// =============================================================================
// reyti_death.inc - Система смерти от Reyti и KBAS's
// Версия: 1.0
// =============================================================================

#if defined _reyti_death_included
	#endinput
#endif
#define _reyti_death_included

// =============================================================================
// НАСТРОЙКИ
// =============================================================================

#define MAX_ROOM 8
new
	IsValid3DTextLabel = 1;
#define DEATH_RESPAWN_DELAY 500 // Задержка перед респавном в мс
#define DEATH_BACKGROUND_TIME 2000 // Время затемнения в мс
#define DEATH_CHECK_RADIUS 5.0 // Радиус для проверки смерти

// RPC пакеты для окна смерти
#define RPC_SHOW_DEAD 0x159
#define RPC_HIDE_DEAD 0x160
#define RPC_UPD_DEAD_NAME 0x161
#define RPC_UPD_DEAD 0x162

// =============================================================================
// ПЕРЕЧИСЛЕНИЯ
// =============================================================================

enum BolkaCoord
{
	Float:X,
	Float:Y,
	Float:Z,
	Angle
}

enum P_DeathInfo
{
    pLastGiveDamageId,
	bool:pDeath,
	bool:pHelpCalled,
	Float:respX,
	Float:respY,
	Float:respZ,
	Text3D:deathLabel,
	animTimer,
	updateTimer
}

enum bck_Info
{
    PlayerText:bgTD,
    bgID,
    bgColor,
    bgPause,
    bgTimer
}

// =============================================================================
// ПЕРЕМЕННЫЕ
// =============================================================================

static BolkaRoom[MAX_ROOM][BolkaCoord] =
{
	{1484.7, 2494.7, 2501.0, 0},
	{1482.7, 2505.7, 2501.0, 180},
	{1469.5, 2494.7, 2501.0, 0},
	{1471.6, 2505.7, 2501.0, 180},
	{1471.6, 2505.6, 2506.0, 180},
	{1482.7, 2505.7, 2506.0, 180},
	{1484.7, 2494.7, 2506.0, 0},
	{1469.5, 2494.7, 2506.0, 0}
};

static pDeathInfo[MAX_PLAYERS][P_DeathInfo];
static bgInfo[MAX_PLAYERS][bck_Info];

// =============================================================================
// СТАТИЧЕСКИЕ ФУНКЦИИ
// =============================================================================

static RE_UpdateDeadTimer()
{
	foreach(new playerid: Player) 
	{
		if(pDeathInfo[playerid][pDeath]) 
		{ 
			RE_SendPlayerWindow(playerid, RPC_UPD_DEAD); 
		}
	}
}

static RE_KillPlayer(playerid, Float:x, Float:y, Float:z)
{
	SetPlayerPosFindZ(playerid, x, y, z);
	RE_FreezePlayer(playerid);
	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, true, 0, 0, 0, 0);
	
	// Создаем 3D текст
	if(IsValid3DTextLabel(pDeathInfo[playerid][deathLabel]))
		Delete3DTextLabel(pDeathInfo[playerid][deathLabel]);
	
	pDeathInfo[playerid][deathLabel] = Create3DTextLabel("Стадия ранения\n{FFFFFF}Подойдите для взаимодействия", 0xFFFF00FF, 0, 0, 0, DEATH_CHECK_RADIUS, 0);
	Attach3DTextLabelToPlayer(pDeathInfo[playerid][deathLabel], playerid, 0, 0, 0.4);
	
	// Отправляем окно смерти
	RE_SendPlayerWindow(playerid, RPC_SHOW_DEAD);
	
	// Обновляем имя убийцы
	new str[32], name[MAX_PLAYER_NAME];
	if(IsPlayerConnected(pDeathInfo[playerid][pLastGiveDamageId]))
	{
		GetPlayerName(pDeathInfo[playerid][pLastGiveDamageId], name, MAX_PLAYER_NAME);
		format(str, sizeof str, "%s (%d)", name, pDeathInfo[playerid][pLastGiveDamageId]);
	}
	else
	{
		format(str, sizeof str, "Неизвестно");
	}
	
	RE_SendPlayerWindow(playerid, RPC_UPD_DEAD_NAME, str);
	
	// Запускаем анимацию
	pDeathInfo[playerid][animTimer] = SetTimerEx("RE_AnimLoop", 300, false, "i", playerid);
	
	// Запускаем таймер обновления
	pDeathInfo[playerid][updateTimer] = SetTimer("RE_UpdateDeadTimer", 1000, true);
	
	return 1;
}

forward RE_AnimLoop(playerid);
public RE_AnimLoop(playerid)
{
	if(pDeathInfo[playerid][pDeath])
	{
		ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, true, 0, 0, 0, 0);
		pDeathInfo[playerid][animTimer] = SetTimerEx("RE_AnimLoop", 300, false, "i", playerid);
	}
}

static RE_SendPlayerWindow(playerid, RPCid, name[] = "")
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 251);
	BS_WriteValue(bitstream, PR_UINT32, RPCid);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen(name));
    BS_WriteValue(bitstream, PR_STRING, name);
	
	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
	return 1;
}

static RE_FreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 0);
    return 1;
}

static RE_UnfreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
    return 1;
}

static RE_PutPlayerBolka(playerid, room)
{
    SetPlayerPos(playerid, BolkaRoom[room][X], BolkaRoom[room][Y], BolkaRoom[room][Z]);
	SetPlayerFacingAngle(playerid, BolkaRoom[room][Angle]);
 	SetPlayerVirtualWorld(playerid, 1);
 	SetPlayerInterior(playerid, 1);
	SetCameraBehindPlayer(playerid);
	pDeathInfo[playerid][pDeath] = false;
	pDeathInfo[playerid][pHelpCalled] = false;
	
	// Очищаем таймеры
	if(pDeathInfo[playerid][animTimer]) KillTimer(pDeathInfo[playerid][animTimer]);
	if(pDeathInfo[playerid][updateTimer]) KillTimer(pDeathInfo[playerid][updateTimer]);
	
	return 1;
}

// =============================================================================
// ФУНКЦИИ ФОНА
// =============================================================================

static RE_CreateBackgroundTextDraw(playerid)
{
    bgInfo[playerid][bgTD] = CreatePlayerTextDraw(playerid, 0.0, 0.0, "_");
    PlayerTextDrawLetterSize(playerid, bgInfo[playerid][bgTD], 2305.0, 1080.0);
    PlayerTextDrawUseBox(playerid, bgInfo[playerid][bgTD], 1);
    PlayerTextDrawBoxColor(playerid, bgInfo[playerid][bgTD], 0x00000000);
    return PlayerTextDrawShow(playerid, bgInfo[playerid][bgTD]);
}

static RE_DestroyBackgroundTextDraw(playerid)
{
    return PlayerTextDrawDestroy(playerid, bgInfo[playerid][bgTD]);
}

static const RE_BACKGROUND_COLORS[] =
{
    0x00000000, 0x00000011, 0x00000022, 0x00000033,
    0x00000044, 0x00000055, 0x00000066, 0x00000077,
    0x00000088, 0x00000099, 0x000000AA, 0x000000BB,
    0x000000CC, 0x000000DD, 0x000000EE, 0x000000FF
};

forward RE_ShowBackground(playerid);
public RE_ShowBackground(playerid)
{
    if(bgInfo[playerid][bgColor] < sizeof(RE_BACKGROUND_COLORS) - 1)
    {
        bgInfo[playerid][bgColor]++;
        PlayerTextDrawBoxColor(playerid, bgInfo[playerid][bgTD], RE_BACKGROUND_COLORS[bgInfo[playerid][bgColor]]);
        PlayerTextDrawShow(playerid, bgInfo[playerid][bgTD]);
        bgInfo[playerid][bgTimer] = SetTimerEx("RE_ShowBackground", 100, false, "i", playerid);
    }
    else
    {
        bgInfo[playerid][bgTimer] = SetTimerEx("RE_HideBackground", bgInfo[playerid][bgPause], false, "i", playerid);
        CallLocalFunction("OnPlayerRevived", "i", playerid);
    }
    return 1;
}

forward RE_HideBackground(playerid);
public RE_HideBackground(playerid)
{
    if(bgInfo[playerid][bgColor] > 0)
    {
        bgInfo[playerid][bgColor]--;
        PlayerTextDrawBoxColor(playerid, bgInfo[playerid][bgTD], RE_BACKGROUND_COLORS[bgInfo[playerid][bgColor]]);
        PlayerTextDrawShow(playerid, bgInfo[playerid][bgTD]);
        bgInfo[playerid][bgTimer] = SetTimerEx("RE_HideBackground", 100, false, "i", playerid);
    }
    else
    {
        RE_DestroyBackgroundTextDraw(playerid);
        bgInfo[playerid][bgID] = 0;
        bgInfo[playerid][bgColor] = 0x00000000;
        bgInfo[playerid][bgPause] = 0;
        KillTimer(bgInfo[playerid][bgTimer]);
        CallLocalFunction("OnPlayerBackgroundComplete", "i", playerid);
    }
    return 1;
}

// =============================================================================
// ПУБЛИЧНЫЕ ФУНКЦИИ
// =============================================================================

stock RE_IsPlayerDead(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	return pDeathInfo[playerid][pDeath];
}

stock RE_GetPlayerKiller(playerid)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	return pDeathInfo[playerid][pLastGiveDamageId];
}

stock RE_SetPlayerDeathPos(playerid, Float:x, Float:y, Float:z)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	pDeathInfo[playerid][respX] = x;
	pDeathInfo[playerid][respY] = y;
	pDeathInfo[playerid][respZ] = z;
	
	return 1;
}

stock RE_RevivePlayer(playerid, bool:toHospital = true, hospitalID = -1)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!pDeathInfo[playerid][pDeath]) return 0;
	
	pDeathInfo[playerid][pDeath] = false;
	RE_SendPlayerWindow(playerid, RPC_HIDE_DEAD);
	
if(pDeathInfo[playerid][deathLabel] != Text3D:0)
{
	Delete3DTextLabel(pDeathInfo[playerid][deathLabel]);
	pDeathInfo[playerid][deathLabel] = Text3D:0;
}	
	// Очищаем таймеры
	if(pDeathInfo[playerid][animTimer]) 
	{
		KillTimer(pDeathInfo[playerid][animTimer]);
		pDeathInfo[playerid][animTimer] = 0;
	}
	
	if(pDeathInfo[playerid][updateTimer]) 
	{
		KillTimer(pDeathInfo[playerid][updateTimer]);
		pDeathInfo[playerid][updateTimer] = 0;
	}
	
	ClearAnimations(playerid);
	RE_UnfreezePlayer(playerid);
	
	// Телепортируем в больницу или на место смерти
	if(toHospital)
	{
		new room = (hospitalID == -1) ? random(MAX_ROOM) : (hospitalID % MAX_ROOM);
		RE_PutPlayerBolka(playerid, room);
		SendClientMessage(playerid, 0x00FF00FF, "Вы были доставлены в больницу.");
	}
	else
	{
		SetPlayerPos(playerid, pDeathInfo[playerid][respX], pDeathInfo[playerid][respY], pDeathInfo[playerid][respZ]);
		SetPlayerHealth(playerid, 50.0);
		SendClientMessage(playerid, 0x00FF00FF, "Вы были реанимированы на месте.");
	}
	
	return 1;
}

stock RE_CallMedic(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!pDeathInfo[playerid][pDeath]) return 0;
	if(pDeathInfo[playerid][pHelpCalled]) return 0;
	
	pDeathInfo[playerid][pHelpCalled] = true;
	
	// Отправляем сообщение игроку
	SendClientMessage(playerid, 0xFFFF00FF, "| {FFFFFF}Вы вызвали медиков, ожидайте их приезда.");
	
	// Отправляем сообщение медикам (если есть такая система)
	new str[128], playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	format(str, sizeof(str), "[МЕДИЦИНА] Игрок %s[%d] вызвал медиков (координаты: %.1f, %.1f, %.1f)", 
		playerName, playerid, 
		pDeathInfo[playerid][respX], 
		pDeathInfo[playerid][respY], 
		pDeathInfo[playerid][respZ]);
	
	// Отправляем всем игрокам во фракции медиков (ID 3)
	foreach(new i: Player)
	{
		// if(GetPlayerFaction(i) == 3) // Раскомментировать если есть система фракций
		{
			SendClientMessage(i, 0xFF4500FF, str);
		}
	}
	
	return 1;
}

stock RE_StartBackgroundEffect(playerid, time = 2000, backgroundid = 1)
{
    if(bgInfo[playerid][bgID]) return 0;
    
    RE_CreateBackgroundTextDraw(playerid);
    bgInfo[playerid][bgID] = backgroundid;
    bgInfo[playerid][bgColor] = 0;
    bgInfo[playerid][bgPause] = time;
    
    return bgInfo[playerid][bgTimer] = SetTimerEx("RE_ShowBackground", 100, false, "i", playerid);
}

// =============================================================================
// КОЛБЭКИ ДЛЯ ПЕРЕОПРЕДЕЛЕНИЯ
// =============================================================================

forward OnPlayerRevived(playerid);
forward OnPlayerBackgroundComplete(playerid);

// =============================================================================
// ХУКИ ДЛЯ ОСНОВНЫХ КОЛБЭКОВ
// =============================================================================

public OnPlayerConnect(playerid)
{
	pDeathInfo[playerid][pDeath] = false;
	pDeathInfo[playerid][pHelpCalled] = false;
	pDeathInfo[playerid][pLastGiveDamageId] = INVALID_PLAYER_ID;
	pDeathInfo[playerid][deathLabel] = Text3D:INVALID_3DTEXT_ID;
	pDeathInfo[playerid][animTimer] = 0;
	pDeathInfo[playerid][updateTimer] = 0;
	
	#if defined RE_OnPlayerConnect
		return RE_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect RE_OnPlayerConnect
#if defined RE_OnPlayerConnect
	forward RE_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	if(pDeathInfo[playerid][pDeath])
	{
		if(pDeathInfo[playerid][deathLabel] != Text3D:0)
{
	Delete3DTextLabel(pDeathInfo[playerid][deathLabel]);
}		
		if(pDeathInfo[playerid][animTimer]) KillTimer(pDeathInfo[playerid][animTimer]);
		if(pDeathInfo[playerid][updateTimer]) KillTimer(pDeathInfo[playerid][updateTimer]);
	}
	
	RE_DestroyBackgroundTextDraw(playerid);
    bgInfo[playerid][bgID] = 0;
    bgInfo[playerid][bgColor] = 0x00000000;
    bgInfo[playerid][bgPause] = 0;
    if(bgInfo[playerid][bgTimer]) KillTimer(bgInfo[playerid][bgTimer]);
	
	#if defined RE_OnPlayerDisconnect
		return RE_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect RE_OnPlayerDisconnect
#if defined RE_OnPlayerDisconnect
	forward RE_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(damagedid))
	{
		pDeathInfo[damagedid][pLastGiveDamageId] = playerid;
	}
	
	#if defined RE_OnPlayerGiveDamage
		return RE_OnPlayerGiveDamage(playerid, damagedid, amount, weaponid, bodypart);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerGiveDamage
	#undef OnPlayerGiveDamage
#else
	#define _ALS_OnPlayerGiveDamage
#endif
#define OnPlayerGiveDamage RE_OnPlayerGiveDamage
#if defined RE_OnPlayerGiveDamage
	forward RE_OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	pDeathInfo[playerid][pDeath] = true;
	pDeathInfo[playerid][pHelpCalled] = false;
	pDeathInfo[playerid][pLastGiveDamageId] = killerid;
	
	GetPlayerPos(playerid, 
		pDeathInfo[playerid][respX], 
		pDeathInfo[playerid][respY], 
		pDeathInfo[playerid][respZ]);
	
	#if defined RE_OnPlayerDeath
		return RE_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath RE_OnPlayerDeath
#if defined RE_OnPlayerDeath
	forward RE_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerSpawn(playerid)
{
	if(pDeathInfo[playerid][pDeath])
	{
		if(IsPlayerConnected(pDeathInfo[playerid][pLastGiveDamageId]))
		{
			SetPlayerPos(playerid, 
				pDeathInfo[playerid][respX],
				pDeathInfo[playerid][respY],
				pDeathInfo[playerid][respZ]);
				
			SetTimerEx("RE_KillPlayer", DEATH_RESPAWN_DELAY, false, "dfff", 
				playerid, 
				pDeathInfo[playerid][respX],
				pDeathInfo[playerid][respY],
				pDeathInfo[playerid][respZ]);
		}
		else
		{
			// Если убийца отключился, оживляем игрока
			RE_RevivePlayer(playerid, false);
		}
	}
	
	#if defined RE_OnPlayerSpawn
		return RE_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn RE_OnPlayerSpawn
#if defined RE_OnPlayerSpawn
	forward RE_OnPlayerSpawn(playerid);
#endif

// =============================================================================
// КОМАНДЫ (если нужно)
// =============================================================================

#if defined PAWNCMD
CMD:deathrevive(playerid, params[])
{
	if(!RE_IsPlayerDead(playerid)) 
		return SendClientMessage(playerid, 0xFF0000FF, "Вы не мертвы!");
	
	RE_RevivePlayer(playerid);
	return 1;
}

CMD:callmedic(playerid, params[])
{
	if(!RE_IsPlayerDead(playerid)) 
		return SendClientMessage(playerid, 0xFF0000FF, "Вы не ранены!");
	
	RE_CallMedic(playerid);
	return 1;
}


CMD:deadinfo(playerid, params[])
{
	if(RE_IsPlayerDead(playerid))
	{
		new killerid = RE_GetPlayerKiller(playerid);
		new killerName[MAX_PLAYER_NAME] = "Неизвестно";
		
		if(IsPlayerConnected(killerid))
			GetPlayerName(killerid, killerName, MAX_PLAYER_NAME);
		
		new str[128];
		format(str, sizeof(str), 
			"Статус: Ранен\nУбийца: %s (%d)\nВызваны медики: %s\nКоординаты: %.1f, %.1f, %.1f",
			killerName, killerid,
			(pDeathInfo[playerid][pHelpCalled] ? "Да" : "Нет"),
			pDeathInfo[playerid][respX],
			pDeathInfo[playerid][respY],
			pDeathInfo[playerid][respZ]);
			
		SendClientMessage(playerid, 0xFFFF00FF, str);
	}
	else
	{
		SendClientMessage(playerid, 0x00FF00FF, "Вы живы и здоровы!");
	}
	return 1;
}
#endif

// =============================================================================
// КОНЕЦ ИНКЛУДА
// =============================================================================