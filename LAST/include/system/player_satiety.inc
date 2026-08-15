#if defined _BR_PLAYER_SATIETY_INC_
	#endinput
#endif
#define _BR_PLAYER_SATIETY_INC_

#define BR_SATIETY_MAX              (100)
#define BR_SATIETY_REG_DEFAULT      (100)
#define BR_SATIETY_PASSIVE_MS       (200000)
#define BR_SATIETY_HUNGER_STEP_DIST (2.0)
#define BR_SATIETY_HP_DRAIN         (2.5)

new g_PlayerSatiety[MAX_PLAYERS];
new bool:g_SatietyDbDirty[MAX_PLAYERS];
new Float:g_SatietyLastX[MAX_PLAYERS];
new Float:g_SatietyLastY[MAX_PLAYERS];
new Float:g_SatietyLastZ[MAX_PLAYERS];
new bool:g_SatietyPosInit[MAX_PLAYERS];
new g_SatietyPassiveTimer = -1;
new g_SatietyTickTimer = -1;

stock Satiety_Clamp(value)
{
	if(value < 0) return 0;
	if(value > BR_SATIETY_MAX) return BR_SATIETY_MAX;
	return value;
}

stock Satiety_Get(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
	return g_PlayerSatiety[playerid];
}

stock Satiety_Set(playerid, value, bool:mark_dirty = true)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
	g_PlayerSatiety[playerid] = Satiety_Clamp(value);
	if(mark_dirty) g_SatietyDbDirty[playerid] = true;
	return g_PlayerSatiety[playerid];
}

stock Satiety_Add(playerid, amount)
{
	return Satiety_Set(playerid, Satiety_Get(playerid) + amount, true);
}

stock Satiety_SaveDb(playerid, bool:force = false)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
	if(Player[playerid][pID] <= 0) return 0;
	if(!force && !g_SatietyDbDirty[playerid]) return 0;

	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET `satiety`=%d WHERE `id`=%d LIMIT 1",
		Satiety_Get(playerid), Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	g_SatietyDbDirty[playerid] = false;
	return 1;
}

stock Satiety_OnRegister(playerid)
{
	Satiety_Set(playerid, BR_SATIETY_REG_DEFAULT, true);
	Satiety_SaveDb(playerid, true);
	return 1;
}

stock Satiety_OnAccountLoaded(playerid, loaded_value)
{
	Satiety_Set(playerid, loaded_value, false);
	g_SatietyDbDirty[playerid] = false;
	return 1;
}

stock Satiety_ResetPosition(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	GetPlayerPos(playerid, g_SatietyLastX[playerid], g_SatietyLastY[playerid], g_SatietyLastZ[playerid]);
	g_SatietyPosInit[playerid] = true;
	return 1;
}

stock Satiety_ApplyHungerHpDrain(playerid, Float:distance)
{
	if(Satiety_Get(playerid) > 0) return 0;
	if(distance < BR_SATIETY_HUNGER_STEP_DIST) return 0;

	new pstate = GetPlayerState(playerid);
	if(pstate == PLAYER_STATE_SPECTATING || pstate == PLAYER_STATE_NONE)
		return 0;

	new Float:hp;
	GetPlayerHealth(playerid, hp);
	if(hp <= 5.0) return 0;

	hp -= BR_SATIETY_HP_DRAIN;
	if(hp < 5.0) hp = 5.0;
	SetPlayerHealth(playerid, hp);
	Player[playerid][pHealth] = hp;
	return 1;
}

forward BR_Satiety_PassiveTick();
public BR_Satiety_PassiveTick()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] <= 0) continue;
		if(GetPVarInt(i, "auth_first_play")) continue;
		if(Satiety_Get(i) <= 0) continue;
		Satiety_Add(i, -1);
	}
	return 1;
}

forward BR_Satiety_MoveTick();
public BR_Satiety_MoveTick()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] <= 0) continue;
		if(GetPVarInt(i, "auth_first_play")) continue;

		new Float:x, Float:y, Float:z;
		GetPlayerPos(i, x, y, z);

		if(!g_SatietyPosInit[i])
		{
			g_SatietyLastX[i] = x;
			g_SatietyLastY[i] = y;
			g_SatietyPosInit[i] = true;
			continue;
		}

		new Float:dist = floatsqroot(
			(x - g_SatietyLastX[i]) * (x - g_SatietyLastX[i]) +
			(y - g_SatietyLastY[i]) * (y - g_SatietyLastY[i]));

		if(Satiety_Get(i) <= 0 && dist >= BR_SATIETY_HUNGER_STEP_DIST)
			Satiety_ApplyHungerHpDrain(i, dist);

		if(dist >= 0.25)
		{
			g_SatietyLastX[i] = x;
			g_SatietyLastY[i] = y;
		}
	}
	return 1;
}

stock Satiety_OnGameModeInit()
{
	mysql_tquery(db_handle,
		"ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `satiety` INT NOT NULL DEFAULT 100 AFTER `money`",
		"", "");
	if(g_SatietyPassiveTimer != -1) KillTimer(g_SatietyPassiveTimer);
	if(g_SatietyTickTimer != -1) KillTimer(g_SatietyTickTimer);
	g_SatietyPassiveTimer = SetTimer("BR_Satiety_PassiveTick", BR_SATIETY_PASSIVE_MS, true);
	g_SatietyTickTimer = SetTimer("BR_Satiety_MoveTick", 450, true);
	printf("[Satiety] Сытость: БД + пассив -1 / %d сек, HP при 0%% каждые %.1f м",
		BR_SATIETY_PASSIVE_MS / 1000, BR_SATIETY_HUNGER_STEP_DIST);
	return 1;
}

stock Satiety_OnPlayerConnect(playerid)
{
	g_PlayerSatiety[playerid] = BR_SATIETY_REG_DEFAULT;
	g_SatietyDbDirty[playerid] = false;
	g_SatietyPosInit[playerid] = false;
	return 1;
}

stock Satiety_OnPlayerDisconnect(playerid)
{
	Satiety_SaveDb(playerid, true);
	g_SatietyPosInit[playerid] = false;
	return 1;
}
