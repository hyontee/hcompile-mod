//>> Файл: bykranin_src/systems/wounded.pwn
//>> Тема: система ранения (вместо мгновенной смерти от урона другого игрока)
//>> Как работает:
//>>  1) смертельный удар игрока (ApplyServerPlayerDamage в combat_01.inc) не убивает, а переводит в ранение:
//>>     10 HP, игрок лежит, ему показывается меню "Вызвать медиков" / "Отправиться в ЦБ"
//>>  2) любой удар по раненому = добивание. Добивший получает розыск (WOUND_FINISH_STARS), кроме полиции
//>>  3) медик поднимает раненого командой /revive [id]
//>>  4) через WOUND_BLEEDOUT_SEC секунд без помощи раненый теряет сознание и попадает в ЦБ
//>>  Смерть не от игрока (падение, взрыв, огонь и т.д.) идёт по-старому: сразу в ЦБ.
//>> Файл подключается из gamemodes/bykranin.pwn ПЕРЕД core/callbacks (нужно для перехвата колбэков).

#if defined _wounded_included
	#endinput
#endif
#define _wounded_included

#define DIALOG_WOUNDED              (41777)

#define WOUND_HEALTH                (10.0)      // сколько HP остаётся раненому
#define WOUND_BLEEDOUT_SEC          (180)       // через сколько секунд раненый теряет сознание и едет в ЦБ
#define WOUND_FINISH_STARS          (2)         // розыск за добивание
#define WOUND_GRACE_MS              (1500)      // после ранения удары ещё не считаются добиванием (тот же залп)
#define WOUND_REVIVE_HEALTH         (40.0)      // HP после помощи медика
#define WOUND_REVIVE_RANGE          (3.0)       // дистанция медика до раненого
#define WOUND_REVIVE_TIME_MS        (5000)      // сколько длится оказание помощи
#define WOUND_CALL_COOLDOWN_SEC     (30)        // повторный вызов медиков не чаще
#define WOUND_MAPICON_TYPE          (22)        // иконка вызова на карте медика

new bool:g_wounded[MAX_PLAYERS];
new g_wounded_since[MAX_PLAYERS];
new g_wounded_left[MAX_PLAYERS];
new g_wounded_token[MAX_PLAYERS];
new g_wounded_timer[MAX_PLAYERS] = {-1, ...};
new g_wounded_reviver[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new bool:g_wounded_called[MAX_PLAYERS];
new g_wounded_call_tick[MAX_PLAYERS];
new Text3D:g_wounded_label[MAX_PLAYERS];
new g_wounded_icon_id[MAX_PLAYERS];     // иконка вызова у МЕДИКА
new g_wounded_icon_for[MAX_PLAYERS];    // чей вызов показан у медика (playerid + 1)

forward Wounded_Tick(playerid, token);
forward Wounded_ApplyAnim(playerid, token);
forward Wounded_ShowMenuDelayed(playerid, token);
forward Wounded_ReviveDone(medic, patient, token);
forward Wounded_EnsureCB(playerid, token, session);

// Определена позже в core/combat/combat_01.inc; используется в Wounded_ToHospital ниже,
// поэтому нужен прототип (Pawn однопроходный, вызов раньше определения требует объявления).
stock ApplyPlayerHospitalSpawn(playerid);

stock bool:Wounded_IsWounded(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return false;
	return g_wounded[playerid];
}

stock bool:Wounded_InGrace(playerid)
{
	new delta = GetTickCount() - g_wounded_since[playerid];
	return (delta >= 0 && delta < WOUND_GRACE_MS);
}

stock bool:Wounded_CanBeWounded(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return false;
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return false;
	if(g_wounded[playerid]) return false;
	if(GetPlayerHealthEx(playerid) <= 0.0) return false;     // уже умирает
	if(GetPlayerData(playerid, P_HOSPITAL)) return false;     // пациенты больницы умирают как раньше
	if(GetPlayerData(playerid, P_JAIL) > 0) return false;     // в заключении умирают как раньше
	return true;
}

stock Wounded_RemoveMedicIcon(medic)
{
	if(g_wounded_icon_id[medic] > 0 && IsValidDynamicMapIcon(g_wounded_icon_id[medic]))
		DestroyDynamicMapIcon(g_wounded_icon_id[medic]);

	g_wounded_icon_id[medic] = 0;
	g_wounded_icon_for[medic] = 0;
	return 1;
}

// Полностью выключает состояние ранения (таймеры, метка, иконки у медиков, диалог).
stock Wounded_Clear(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
	if(!g_wounded[playerid]) return 0;

	g_wounded[playerid] = false;
	g_wounded_called[playerid] = false;
	g_wounded_reviver[playerid] = INVALID_PLAYER_ID;

	g_wounded_token[playerid] ++;
	if(g_wounded_token[playerid] <= 0) g_wounded_token[playerid] = 1;

	if(g_wounded_timer[playerid] != -1)
	{
		KillTimer(g_wounded_timer[playerid]);
		g_wounded_timer[playerid] = -1;
	}

	if(IsValidDynamic3DTextLabel(g_wounded_label[playerid]))
		DestroyDynamic3DTextLabel(g_wounded_label[playerid]);
	g_wounded_label[playerid] = Text3D:0;

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(g_wounded_icon_for[i] == playerid + 1) Wounded_RemoveMedicIcon(i);
	}

	if(IsPlayerConnected(playerid))
	{
		SetPlayerChatBubble(playerid, " ", 0xFFFFFFFF, 1.0, 1);
		if(GetPlayerData(playerid, P_LAST_DIALOG) == DIALOG_WOUNDED)
			ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, " ", " ", " ", "");
	}
	return 1;
}

stock Wounded_ShowMenu(playerid)
{
	if(!Wounded_IsWounded(playerid)) return 0;

	Dialog
	(
		playerid, DIALOG_WOUNDED, DIALOG_STYLE_LIST,
		"{FF6666}Вы тяжело ранены",
		"{FF6666}Вызвать медиков\n{FFCC00}Отправиться в ЦБ (Центральная больница)",
		"Выбрать", "Закрыть"
	);
	return 1;
}

public Wounded_ShowMenuDelayed(playerid, token)
{
	if(!IsPlayerConnected(playerid) || !g_wounded[playerid] || g_wounded_token[playerid] != token) return 0;
	return Wounded_ShowMenu(playerid);
}

public Wounded_ApplyAnim(playerid, token)
{
	if(!IsPlayerConnected(playerid) || !g_wounded[playerid] || g_wounded_token[playerid] != token) return 0;

	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}

// Перевод в ранение. Вызывается из ApplyServerPlayerDamage вместо смерти.
stock Wounded_Begin(playerid, issuerid, weaponid)
{
	#pragma unused weaponid

	g_wounded[playerid] = true;
	g_wounded_called[playerid] = false;
	g_wounded_since[playerid] = GetTickCount();
	g_wounded_left[playerid] = WOUND_BLEEDOUT_SEC;
	g_wounded_reviver[playerid] = INVALID_PLAYER_ID;
	g_wounded_call_tick[playerid] = 0;

	g_wounded_token[playerid] ++;
	if(g_wounded_token[playerid] <= 0) g_wounded_token[playerid] = 1;
	new token = g_wounded_token[playerid];

	SetPlayerHealthEx(playerid, WOUND_HEALTH);

	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
	TogglePlayerControllable(playerid, false);
	SetTimerEx("Wounded_ApplyAnim", 400, false, "ii", playerid, token);
	SetTimerEx("Wounded_ShowMenuDelayed", 800, false, "ii", playerid, token);

	if(IsValidDynamic3DTextLabel(g_wounded_label[playerid]))
		DestroyDynamic3DTextLabel(g_wounded_label[playerid]);
	g_wounded_label[playerid] = CreateDynamic3DTextLabel("Ранен", 0xFF3333FF, 0.0, 0.0, 0.6, 15.0, playerid, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);

	if(g_wounded_timer[playerid] != -1) KillTimer(g_wounded_timer[playerid]);
	g_wounded_timer[playerid] = SetTimerEx("Wounded_Tick", 1000, true, "ii", playerid, token);

	SendClientMessage(playerid, 0xFF6666FF, "Вы тяжело ранены. Вызовите медиков или отправьтесь в ЦБ. Меню: {FFFFFF}/wound");

	new msg[144];
	format(msg, sizeof msg, "Игрок %s тяжело ранен. Повторный удар добьёт его и принесёт Вам розыск (%d зв.)", GetPlayerNameEx(playerid), WOUND_FINISH_STARS);

	if(issuerid != INVALID_PLAYER_ID && issuerid >= 0 && issuerid < MAX_PLAYERS && IsPlayerConnected(issuerid))
		SendClientMessage(issuerid, 0xFFC000FF, msg);

	return 1;
}

// Медик помог (или раненого вылечили другим способом).
stock Wounded_Revive(playerid, Float:set_health = -1.0)
{
	if(!Wounded_IsWounded(playerid)) return 0;

	Wounded_Clear(playerid);
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, true);

	if(set_health > 0.0)
	{
		SetPlayerHealthEx(playerid, set_health);
		DamageHealthScheduleResync(playerid);
	}

	SendClientMessage(playerid, 0x66CC00FF, "Вы пришли в себя");
	return 1;
}

// Отправка в ЦБ.
// БЫЛО (баг): SetPlayerHealthEx(playerid, 0.0) убивало игрока по-настоящему. Экран гас, игрок
// проходил обычный цикл смерти SA-MP (client wasted -> сам запрашивает спавн через ~3-4 сек),
// и ТОЛЬКО ТОГДА срабатывал OnPlayerDeath/OnPlayerSpawn и переносил в ЦБ - т.е. игрока сначала
// (визуально) переносило в ЦБ через ApplyPlayerHospitalSpawn из первого спавна, а через несколько
// секунд клиент второй раз спавнился сам (настоящая смерть) поверх этого - отсюда "второй раз в ЦБ"
// и слетающий интерьер (гонка между двумя параллельными переносами HospitalSpawnSync).
// СЕЙЧАС: игрока не убиваем по-настоящему вообще, поэтому клиент никогда не проходит через
// собственный цикл wasted/auto-respawn и не может запустить перенос в ЦБ второй раз.
//  1) смерть засчитывается сразу и один раз: вызывается вся цепочка OnPlayerDeath (флаг больницы,
//     токен, лог, SetPlayerHospitalSpawnInit для /spawn) - как и раньше для обычной смерти;
//  2) вручную (без падения HP до 0) вызывается тот же самый ApplyPlayerHospitalSpawn, что обычно
//     вызывается из OnPlayerSpawn - единственный перенос в ЦБ, с интерьером 1 / вирт. миром 1;
//  3) wound_manual_death_tick на всякий случай гасит случайный поздний OnPlayerDeath от клиента
//     (защита в family_addition.pwn), если мобильный клиент всё же что-то пришлёт сам;
//  4) Wounded_EnsureCB дополнительно перепроверяет интерьер 1 / вирт. мир 1 через 5 и 9 секунд.
stock Wounded_ToHospital(playerid)
{
	if(!Wounded_IsWounded(playerid)) return 0;

	Wounded_Clear(playerid);
	ClearAnimations(playerid);

	SendClientMessage(playerid, 0xFFCC00FF, "Вас доставляют в Центральную больницу...");

	// callbacks_01.inc не пишет админам "убил себя" для такой смерти (флаг снимается внутри OnPlayerDeath)
	SetPVarInt(playerid, "wound_hospital_transfer", 1);

	// 1) засчитываем смерть: killerid нет, reason 255 (как при обычной смерти без убийцы).
	// Внутри выставляется P_HOSPITAL, токен/комната сбрасываются, SetPlayerHospitalSpawnInit
	// готовит SetSpawnInfo - всё то же самое, что происходит при обычной смерти.
	SetPVarInt(playerid, "death_manual_call", 1);
	CallLocalFunction("OnPlayerDeath", "iii", playerid, INVALID_PLAYER_ID, 255);

	new death_stamp = GetTickCount();
	if(death_stamp == 0) death_stamp = 1;
	SetPVarInt(playerid, "wound_manual_death_tick", death_stamp);

	// то, что игрок терял бы при настоящей смерти (оружие/броню), раз настоящей смерти не будет
	ResetPlayerWeapons(playerid);
	SetPlayerArmour(playerid, 0.0);

	// 2) перенос в ЦБ уже произошёл внутри OnPlayerDeath (callbacks_01.inc) синхронно, выше
	new token = GetPVarInt(playerid, "hospital_spawn_token");

	// 4) подстраховка интерьера/вирт. мира
	SetTimerEx("Wounded_EnsureCB", 5000, false, "iii", playerid, token, mysql_race[playerid]);
	SetTimerEx("Wounded_EnsureCB", 9000, false, "iii", playerid, token, mysql_race[playerid]);
	return 1;
}

// Игрок в ЦБ всегда должен быть в интерьере 1 и виртуальном мире 1.
public Wounded_EnsureCB(playerid, token, session)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
	if(mysql_race[playerid] != session) return 0;
	if(!GetPlayerData(playerid, P_HOSPITAL)) return 0;
	if(GetPVarInt(playerid, "hospital_spawn_token") != token) return 0;
	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_NONE) return 0;

	if(GetPlayerInterior(playerid) != 1 || GetPlayerVirtualWorld(playerid) != 1)
	{
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 1);
		Streamer_Update(playerid);
	}
	return 1;
}

stock Wounded_GiveFinishStars(issuerid, victimid)
{
	if(issuerid == INVALID_PLAYER_ID || issuerid < 0 || issuerid >= MAX_PLAYERS || !IsPlayerConnected(issuerid)) return 0;
	if(IsPlayerInPoliceTeam(issuerid)) return 0;     // полиция за добивание розыск не получает

	new current = GetPlayerSuspect(issuerid);
	if(current >= 6) return 0;

	new add = WOUND_FINISH_STARS;
	if(current + add > 6) add = 6 - current;

	AddPlayerData(issuerid, P_SUSPECT, +, add);
	SetPlayerSuspectInit(issuerid);
	UpdatePlayerDatabaseInt(issuerid, "suspect", GetPlayerData(issuerid, P_SUSPECT));

	new msg[144];
	format(msg, sizeof msg, "Вы добили раненого %s. Вам выдан розыск: +%d (уровень %d/6)", GetPlayerNameEx(victimid), add, GetPlayerSuspect(issuerid));
	SendClientMessage(issuerid, 0xFF6600FF, msg);

	format(msg, sizeof msg, "[Розыск] %s[%d] добил раненого %s[%d] - розыск [%d/6]", GetPlayerNameEx(issuerid), issuerid, GetPlayerNameEx(victimid), victimid, GetPlayerSuspect(issuerid));
	SendMessageToPoliceTeam(msg, 0xFFC000FF);
	return 1;
}

// Добивание: удар по раненому. Дальше обычная смерть с засчитанным убийцей.
// Раньше здесь тоже ставили HP 0 и ждали настоящую смерть клиента - тот же баг двойной
// отгрузки в ЦБ, что был в Wounded_ToHospital (см. комментарий там). Убийца передаётся через
// server_death_killer/server_death_weapon - family_addition.pwn подставляет его в OnPlayerDeath,
// поэтому реальная смерть (HP 0) для правильного зачёта убийства не нужна.
stock Wounded_Finish(playerid, issuerid, weaponid)
{
	if(!Wounded_IsWounded(playerid)) return 0;

	Wounded_Clear(playerid);
	Wounded_GiveFinishStars(issuerid, playerid);

	// 1) убийца/оружие передаются через pvar'ы (family_addition.pwn подставит их в OnPlayerDeath,
	// т.к. killerid ниже INVALID_PLAYER_ID), затем сразу же засчитывается сама смерть
	SetPVarInt(playerid, "server_death_killer", issuerid + 1);
	SetPVarInt(playerid, "server_death_weapon", weaponid);
	SetPVarInt(playerid, "server_death_tick", GetTickCount());
	SetPVarInt(playerid, "death_manual_call", 1);
	CallLocalFunction("OnPlayerDeath", "iii", playerid, INVALID_PLAYER_ID, 255);

	new death_stamp = GetTickCount();
	if(death_stamp == 0) death_stamp = 1;
	SetPVarInt(playerid, "wound_manual_death_tick", death_stamp);

	// то, что игрок терял бы при настоящей смерти (оружие/броню), раз настоящей смерти не будет
	ResetPlayerWeapons(playerid);
	SetPlayerArmour(playerid, 0.0);

	// 2) перенос в ЦБ уже произошёл внутри OnPlayerDeath (callbacks_01.inc) синхронно, выше
	new token = GetPVarInt(playerid, "hospital_spawn_token");

	// 3) подстраховка интерьера/вирт. мира
	SetTimerEx("Wounded_EnsureCB", 5000, false, "iii", playerid, token, mysql_race[playerid]);
	SetTimerEx("Wounded_EnsureCB", 9000, false, "iii", playerid, token, mysql_race[playerid]);
	return 1;
}

stock Wounded_CallMedics(playerid)
{
	if(!Wounded_IsWounded(playerid)) return 0;

	if(g_wounded_called[playerid])
	{
		new delta = GetTickCount() - g_wounded_call_tick[playerid];
		if(delta >= 0 && delta < WOUND_CALL_COOLDOWN_SEC * 1000)
		{
			SendClientMessage(playerid, 0xCECECEFF, "Вы уже вызывали медиков. Подождите немного");
			return 0;
		}
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new msg[144];
	format(msg, sizeof msg, "[MED] Вызов: %s[%d] тяжело ранен, метка на карте. Помощь: /revive %d", GetPlayerNameEx(playerid), playerid, playerid);

	new count = 0;
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
		if(GetPlayerTeamEx(i) != TEAM_HOSPITAL) continue;
		if(g_wounded[i]) continue;

		SendClientMessage(i, 0x99CC99FF, msg);

		Wounded_RemoveMedicIcon(i);
		g_wounded_icon_id[i] = CreateDynamicMapIcon(x, y, z, WOUND_MAPICON_TYPE, 0, -1, -1, i, 20000.0, MAPICON_GLOBAL);
		g_wounded_icon_for[i] = playerid + 1;
		count ++;
	}

	if(!count)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Сейчас нет медиков в сети. Вы можете отправиться в ЦБ");
		return 0;
	}

	g_wounded_called[playerid] = true;
	g_wounded_call_tick[playerid] = GetTickCount();

	format(msg, sizeof msg, "Вызов отправлен медикам (в сети: %d). Ожидайте помощи или отправьтесь в ЦБ", count);
	SendClientMessage(playerid, 0x66CC00FF, msg);
	return 1;
}

public Wounded_Tick(playerid, token)
{
	if(!IsPlayerConnected(playerid) || !g_wounded[playerid] || g_wounded_token[playerid] != token) return 0;

	// вылечили другим способом (/heal, админ и т.д.)
	new Float:hp = GetPlayerHealthEx(playerid);
	if(hp > WOUND_HEALTH + 5.0)
	{
		Wounded_Revive(playerid);
		return 1;
	}

	g_wounded_left[playerid] --;
	if(g_wounded_left[playerid] <= 0)
	{
		SendClientMessage(playerid, 0xFF6666FF, "Вы потеряли много крови и потеряли сознание");
		Wounded_ToHospital(playerid);
		return 1;
	}

	// раненый не должен вставать (оглушение дубинкой и т.п. могло его разморозить)
	if(g_wounded_left[playerid] % 3 == 0) TogglePlayerControllable(playerid, false);

	SetPlayerChatBubble(playerid, "Ранен", 0xFF3333FF, 20.0, 1100);

	if(IsValidDynamic3DTextLabel(g_wounded_label[playerid]))
	{
		new text[96];
		format(text, sizeof text, "Ранен (%d сек.)\nМедик: /revive %d", g_wounded_left[playerid], playerid);
		UpdateDynamic3DTextLabelText(g_wounded_label[playerid], 0xFF3333FF, text);
	}
	return 1;
}

public Wounded_ReviveDone(medic, patient, token)
{
	if(IsPlayerConnected(medic)) TogglePlayerControllable(medic, true);

	if(!IsPlayerConnected(patient) || !g_wounded[patient] || g_wounded_token[patient] != token) return 0;
	if(g_wounded_reviver[patient] != medic) return 0;

	g_wounded_reviver[patient] = INVALID_PLAYER_ID;

	if(!IsPlayerConnected(medic) || GetPlayerTeamEx(medic) != TEAM_HOSPITAL || g_wounded[medic] || !IsPlayerInRangeOfPlayer(medic, patient, WOUND_REVIVE_RANGE + 1.5))
	{
		if(IsPlayerConnected(medic)) SendClientMessage(medic, 0xCECECEFF, "Помощь прервана: пациент слишком далеко");
		SendClientMessage(patient, 0xCECECEFF, "Медик не смог закончить оказание помощи");
		return 0;
	}

	new msg[96];
	format(msg, sizeof msg, "Медицинский работник %s оказал Вам помощь", GetPlayerNameEx(medic));

	Wounded_Revive(patient, WOUND_REVIVE_HEALTH);
	SendClientMessage(patient, 0x66CC00FF, msg);

	format(msg, sizeof msg, "Вы помогли пациенту %s", GetPlayerNameEx(patient));
	SendClientMessage(medic, 0x66CC00FF, msg);
	return 1;
}

// ---------------------------------------------------------------- команды

CMD:wound(playerid, params[])
{
	#pragma unused params
	if(!Wounded_IsWounded(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не ранены");
	return Wounded_ShowMenu(playerid);
}

CMD:revive(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "Вы не медицинский работник");
	if(Wounded_IsWounded(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы сами ранены");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0x999999FF, "Выйдите из транспорта");

	new target;
	if(sscanf(params, "u", target)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /revive [id игрока]");

	if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !IsPlayerLogged(target) || target == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!Wounded_IsWounded(target)) return SendClientMessage(playerid, 0x999999FF, "Этот игрок не ранен");
	if(!IsPlayerInRangeOfPlayer(playerid, target, WOUND_REVIVE_RANGE)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
	if(g_wounded_reviver[target] != INVALID_PLAYER_ID) return SendClientMessage(playerid, 0x999999FF, "Этому игроку уже оказывают помощь");

	g_wounded_reviver[target] = playerid;

	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);

	new msg[96];
	format(msg, sizeof msg, "Вы оказываете помощь пациенту %s. Не отходите %d сек.", GetPlayerNameEx(target), WOUND_REVIVE_TIME_MS / 1000);
	SendClientMessage(playerid, 0x66CC00FF, msg);

	format(msg, sizeof msg, "Медицинский работник %s оказывает Вам помощь", GetPlayerNameEx(playerid));
	SendClientMessage(target, 0x66CC00FF, msg);

	SetTimerEx("Wounded_ReviveDone", WOUND_REVIVE_TIME_MS, false, "iii", playerid, target, g_wounded_token[target]);
	return 1;
}

// ---------------------------------------------------------------- перехват колбэков

stock bool:Wounded_IsAllowedCommand(const cmd[])
{
	new name[32];
	name[0] = EOS;
	strcat(name, cmd, sizeof name);
	if(name[0] == '/') strdel(name, 0, 1);

	new const allowed[][] = {"wound", "me", "do", "try", "b", "s", "report", "ask", "pm"};
	for(new i; i < sizeof allowed; i ++)
	{
		if(!strcmp(name, allowed[i], true)) return true;
	}
	return false;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(playerid >= 0 && playerid < MAX_PLAYERS && g_wounded[playerid] && GetPlayerAdminEx(playerid) < 1)
	{
		if(!Wounded_IsAllowedCommand(cmd))
		{
			SendClientMessage(playerid, 0xCECECEFF, "Вы тяжело ранены и не можете этого сделать. Меню ранения: /wound");
			return 0;
		}
	}
	#if defined wnd_OnPlayerCommandReceived
		return wnd_OnPlayerCommandReceived(playerid, cmd, params, flags);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerCommandReceived
	#undef OnPlayerCommandReceived
#else
	#define _ALS_OnPlayerCommandReceived
#endif
#define OnPlayerCommandReceived wnd_OnPlayerCommandReceived
#if defined wnd_OnPlayerCommandReceived
	forward wnd_OnPlayerCommandReceived(playerid, cmd[], params[], flags);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_WOUNDED)
	{
		if(!Wounded_IsWounded(playerid)) return 1;

		if(!response)
		{
			SendClientMessage(playerid, 0xCECECEFF, "Меню ранения можно открыть командой /wound");
			return 1;
		}

		switch(listitem)
		{
			case 0:
			{
				Wounded_CallMedics(playerid);
				Wounded_ShowMenu(playerid);
			}
			case 1: Wounded_ToHospital(playerid);
		}
		return 1;
	}
	#if defined wnd_OnDialogResponse
		return wnd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse wnd_OnDialogResponse
#if defined wnd_OnDialogResponse
	forward wnd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	Wounded_Clear(playerid);
	#if defined wnd_OnPlayerDeath
		return wnd_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath wnd_OnPlayerDeath
#if defined wnd_OnPlayerDeath
	forward wnd_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	if(g_wounded[playerid] && IsPlayerLogged(playerid))
	{
		// вышел раненым: после входа он окажется в ЦБ, а не убежит от последствий
		SetPlayerData(playerid, P_HOSPITAL, true);
		UpdatePlayerDatabaseInt(playerid, "hospital", 1);
	}
	Wounded_Clear(playerid);
	Wounded_RemoveMedicIcon(playerid);
	g_wounded_called[playerid] = false;
	#if defined wnd_OnPlayerDisconnect
		return wnd_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect wnd_OnPlayerDisconnect
#if defined wnd_OnPlayerDisconnect
	forward wnd_OnPlayerDisconnect(playerid, reason);
#endif
