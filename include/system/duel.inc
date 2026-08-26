/*
	 
	 Подключение (в основной .pwn, ПОСЛЕ определения макросов
	 GetPlayerMoneyEx/GetPlayerNameEx/IsPlayerLogged/ConvertMoney,
	 т.е. вместе с остальными "system"-инклюдами):

		#include "../include/system/duel.inc"

	 И добавить вызовы в существующие колбэки:

	 public OnDialogResponse(...)
	 {
	     if(Duel_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
	     ...
	 }

	 public OnPlayerDeath(playerid, killerid, reason)
	 {
	     if(Duel_OnPlayerDeath(playerid, killerid, reason)) return 1; // но обычно return не нужен, см. пример ниже
	     ...
	 }

	 public OnPlayerSpawn(playerid)
	 {
	     Duel_OnPlayerSpawn(playerid);
	     ...
	 }

	 public OnPlayerConnect(playerid)
	 {
	     Duel_OnPlayerConnect(playerid);
	     ...
	 }

	 public OnPlayerDisconnect(playerid, reason)
	 {
	     Duel_OnPlayerDisconnect(playerid);
	     ...
	 }

*/

#if defined _DUEL_SYSTEM_INCLUDED
	#endinput
#endif
#define _DUEL_SYSTEM_INCLUDED

// ================= НАСТРОЙКИ =================
#define DUEL_MAX_BET				(10000000)		// 10.000.000 - максимальная ставка
#define DUEL_MIN_BET				(1)
#define DUEL_WEAPON_AMMO			(9999)

#define DIALOG_DUEL_WEAPON			(88101)
#define DIALOG_DUEL_MONEY_TYPE		(88102)
#define DIALOG_DUEL_BET_AMOUNT		(88103)
#define DIALOG_DUEL_CONFIRM		(88104)

// Координаты телепорта дуэлянтов (X, Y, Z, Angle)
static const Float:g_DuelSpawnPos[2][4] =
{
	{738.325744, -1453.267822, 45.114097, 144.934371},
	{698.153381, -1445.121704, 45.442604, 298.709960}
};

enum e_DuelWeaponInfo
{
	DUEL_WEAPON_ID,
	DUEL_WEAPON_NAME[32]
};

static const g_DuelWeaponList[5][e_DuelWeaponInfo] =
{
	{24, "Desert Eagle"},
	{30, "AK-47"},
	{25, "Shotgun"},
	{31, "M4"},
	{34, "Sniper Rifle"}
};

enum e_DuelState
{
	DUEL_STATE_NONE = 0,
	DUEL_STATE_WEAPON,
	DUEL_STATE_MONEYTYPE,
	DUEL_STATE_BET,
	DUEL_STATE_PENDING,
	DUEL_STATE_ACTIVE
};

enum e_DuelPlayerData
{
	DUEL_STATE,
	DUEL_TARGET,
	DUEL_WEAPON,
	bool:DUEL_WITH_MONEY,
	DUEL_BET,

	bool:DUEL_NEED_RESTORE,
	Float:DUEL_BACK_X,
	Float:DUEL_BACK_Y,
	Float:DUEL_BACK_Z,
	Float:DUEL_BACK_A,
	DUEL_BACK_INT,
	DUEL_BACK_WORLD,
	DUEL_BACK_WEAPONS[13],
	DUEL_BACK_AMMO[13],
	Float:DUEL_BACK_HEALTH,
	Float:DUEL_BACK_ARMOR
};

new g_Duel[MAX_PLAYERS][e_DuelPlayerData];

forward Duel_Countdown(challenger, target, count);

// ================= КОМАНДА /duel =================
CMD:duel(playerid, params[])
{
	if(!IsPlayerLogged(playerid)) return 1;

	new targetid;
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFFFF}Используйте: {FFCC00}/duel [ID игрока]");

	if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
		return SendClientMessage(playerid, 0xFF0000FF, "Такого игрока нет в сети.");

	if(targetid == playerid)
		return SendClientMessage(playerid, 0xFF0000FF, "Вы не можете вызвать на дуэль самого себя.");

	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок ещё не авторизовался.");

	if(g_Duel[playerid][DUEL_STATE] != DUEL_STATE_NONE)
		return SendClientMessage(playerid, 0xFF0000FF, "Вы уже находитесь в процессе организации/проведения дуэли.");

	if(g_Duel[targetid][DUEL_STATE] != DUEL_STATE_NONE)
		return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок уже занят дуэлью.");

	if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(targetid))
		return SendClientMessage(playerid, 0xFF0000FF, "Дуэль недоступна, пока один из игроков находится в транспорте.");

	g_Duel[playerid][DUEL_STATE] = DUEL_STATE_WEAPON;
	g_Duel[playerid][DUEL_TARGET] = targetid;

	Duel_ShowWeaponDialog(playerid);

	return 1;
}

// ================= ВСПОМОГАТЕЛЬНЫЕ =================
stock Duel_ShowWeaponDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_DUEL_WEAPON, DIALOG_STYLE_LIST, "{FFCC00}Дуэль | Выбор оружия",
		"Desert Eagle (ID: 24)\n\
AK-47 (ID: 30)\n\
Shotgun (ID: 25)\n\
M4 (ID: 31)\n\
Sniper Rifle (ID: 34)", "Выбрать", "Отмена");
}

stock Duel_ShowMoneyTypeDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_DUEL_MONEY_TYPE, DIALOG_STYLE_LIST, "{FFCC00}Дуэль | Ставка",
		"Без денег\nС деньгами", "Выбрать", "Назад");
}

stock Duel_GetWeaponName(weaponid, dest[], size = sizeof dest)
{
	for(new i = 0; i < 5; i++)
	{
		if(g_DuelWeaponList[i][DUEL_WEAPON_ID] == weaponid)
		{
			format(dest, size, "%s", g_DuelWeaponList[i][DUEL_WEAPON_NAME]);
			return 1;
		}
	}
	format(dest, size, "Неизвестно");
	return 0;
}

stock Duel_Reset(playerid)
{
	g_Duel[playerid][DUEL_STATE] = DUEL_STATE_NONE;
	g_Duel[playerid][DUEL_TARGET] = INVALID_PLAYER_ID;
	g_Duel[playerid][DUEL_WEAPON] = 0;
	g_Duel[playerid][DUEL_WITH_MONEY] = false;
	g_Duel[playerid][DUEL_BET] = 0;
	return 1;
}

stock Duel_SendOffer(playerid)
{
	new targetid = g_Duel[playerid][DUEL_TARGET];

	if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
	{
		SendClientMessage(playerid, 0xFF0000FF, "Игрок покинул сервер, дуэль отменена.");
		Duel_Reset(playerid);
		return 0;
	}

	g_Duel[playerid][DUEL_STATE] = DUEL_STATE_PENDING;

	g_Duel[targetid][DUEL_STATE] = DUEL_STATE_PENDING;
	g_Duel[targetid][DUEL_TARGET] = playerid;

	new weapon_name[32];
	Duel_GetWeaponName(g_Duel[playerid][DUEL_WEAPON], weapon_name);

	new msg[256];
	if(g_Duel[playerid][DUEL_WITH_MONEY])
	{
		new money_str[32];
		ConvertMoney(g_Duel[playerid][DUEL_BET], money_str);
		format(msg, sizeof msg, "Игрок %s[%d] вызывает вас на дуэль!\nОружие: %s\nСтавка: %s руб.\n\nПринять вызов?",
			GetPlayerNameEx(playerid), playerid, weapon_name, money_str);
	}
	else
	{
		format(msg, sizeof msg, "Игрок %s[%d] вызывает вас на дуэль!\nОружие: %s\nСтавка: без денег\n\nПринять вызов?",
			GetPlayerNameEx(playerid), playerid, weapon_name);
	}

	ShowPlayerDialog(targetid, DIALOG_DUEL_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFCC00}Вызов на дуэль", msg, "Принять", "Отклонить");

	SendClientMessage(playerid, 0x66CC00FF, "Вызов на дуэль отправлен. Ожидайте ответа...");
	return 1;
}

stock Duel_PrepPlayer(playerid, opponentid, weapon, bool:with_money, bet)
{
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	g_Duel[playerid][DUEL_BACK_X] = x;
	g_Duel[playerid][DUEL_BACK_Y] = y;
	g_Duel[playerid][DUEL_BACK_Z] = z;
	g_Duel[playerid][DUEL_BACK_A] = a;
	g_Duel[playerid][DUEL_BACK_INT] = GetPlayerInterior(playerid);
	g_Duel[playerid][DUEL_BACK_WORLD] = GetPlayerVirtualWorld(playerid);

	GetPlayerHealth(playerid, g_Duel[playerid][DUEL_BACK_HEALTH]);
	GetPlayerArmour(playerid, g_Duel[playerid][DUEL_BACK_ARMOR]);

	for(new slot = 0; slot < 13; slot++)
	{
		new wid, ammo;
		GetPlayerWeaponData(playerid, slot, wid, ammo);
		g_Duel[playerid][DUEL_BACK_WEAPONS][slot] = wid;
		g_Duel[playerid][DUEL_BACK_AMMO][slot] = ammo;
	}

	g_Duel[playerid][DUEL_NEED_RESTORE] = true;

	g_Duel[playerid][DUEL_STATE] = DUEL_STATE_ACTIVE;
	g_Duel[playerid][DUEL_TARGET] = opponentid;
	g_Duel[playerid][DUEL_WEAPON] = weapon;
	g_Duel[playerid][DUEL_WITH_MONEY] = with_money;
	g_Duel[playerid][DUEL_BET] = bet;

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, weapon, DUEL_WEAPON_AMMO);

	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	return 1;
}

stock Duel_Begin(challenger, target)
{
	new weapon = g_Duel[challenger][DUEL_WEAPON];
	new bool:with_money = g_Duel[challenger][DUEL_WITH_MONEY];
	new bet = g_Duel[challenger][DUEL_BET];

	Duel_PrepPlayer(challenger, target, weapon, with_money, bet);
	Duel_PrepPlayer(target, challenger, weapon, with_money, bet);

	SetPlayerInterior(challenger, 0);
	SetPlayerVirtualWorld(challenger, 0);
	SetPlayerPos(challenger, g_DuelSpawnPos[0][0], g_DuelSpawnPos[0][1], g_DuelSpawnPos[0][2]);
	SetPlayerFacingAngle(challenger, g_DuelSpawnPos[0][3]);

	SetPlayerInterior(target, 0);
	SetPlayerVirtualWorld(target, 0);
	SetPlayerPos(target, g_DuelSpawnPos[1][0], g_DuelSpawnPos[1][1], g_DuelSpawnPos[1][2]);
	SetPlayerFacingAngle(target, g_DuelSpawnPos[1][3]);

	SetCameraBehindPlayer(challenger);
	SetCameraBehindPlayer(target);

	TogglePlayerControllable(challenger, false);
	TogglePlayerControllable(target, false);

	SendClientMessage(challenger, 0x66CC00FF, "Дуэль начинается! Приготовьтесь...");
	SendClientMessage(target, 0x66CC00FF, "Дуэль начинается! Приготовьтесь...");

	SetTimerEx("Duel_Countdown", 1000, false, "iii", challenger, target, 3);
	return 1;
}

public Duel_Countdown(challenger, target, count)
{
	if(!IsPlayerConnected(challenger) || !IsPlayerConnected(target)) return 1;
	if(g_Duel[challenger][DUEL_STATE] != DUEL_STATE_ACTIVE || g_Duel[target][DUEL_STATE] != DUEL_STATE_ACTIVE) return 1;

	if(count > 0)
	{
		new str[8];
		format(str, sizeof str, "%d..", count);
		SendClientMessage(challenger, 0xFFCC00FF, str);
		SendClientMessage(target, 0xFFCC00FF, str);
		SetTimerEx("Duel_Countdown", 1000, false, "iii", challenger, target, count - 1);
	}
	else
	{
		SendClientMessage(challenger, 0x00FF00FF, "НАЧАЛИ!!");
		SendClientMessage(target, 0x00FF00FF, "НАЧАЛИ!!");
		TogglePlayerControllable(challenger, true);
		TogglePlayerControllable(target, true);
	}
	return 1;
}

stock Duel_RestorePlayer(playerid)
{
	if(!g_Duel[playerid][DUEL_NEED_RESTORE]) return 0;

	SetPlayerInterior(playerid, g_Duel[playerid][DUEL_BACK_INT]);
	SetPlayerVirtualWorld(playerid, g_Duel[playerid][DUEL_BACK_WORLD]);
	SetPlayerPos(playerid, g_Duel[playerid][DUEL_BACK_X], g_Duel[playerid][DUEL_BACK_Y], g_Duel[playerid][DUEL_BACK_Z]);
	SetPlayerFacingAngle(playerid, g_Duel[playerid][DUEL_BACK_A]);

	ResetPlayerWeapons(playerid);
	for(new slot = 0; slot < 13; slot++)
	{
		if(g_Duel[playerid][DUEL_BACK_WEAPONS][slot] > 0 && g_Duel[playerid][DUEL_BACK_AMMO][slot] > 0)
		{
			GivePlayerWeapon(playerid, g_Duel[playerid][DUEL_BACK_WEAPONS][slot], g_Duel[playerid][DUEL_BACK_AMMO][slot]);
		}
	}

	SetPlayerHealth(playerid, g_Duel[playerid][DUEL_BACK_HEALTH]);
	SetPlayerArmour(playerid, g_Duel[playerid][DUEL_BACK_ARMOR]);

	TogglePlayerControllable(playerid, true);

	g_Duel[playerid][DUEL_NEED_RESTORE] = false;
	return 1;
}

stock Duel_FinishPlayer(playerid)
{
	Duel_RestorePlayer(playerid);

	g_Duel[playerid][DUEL_STATE] = DUEL_STATE_NONE;
	g_Duel[playerid][DUEL_TARGET] = INVALID_PLAYER_ID;
	g_Duel[playerid][DUEL_WEAPON] = 0;
	g_Duel[playerid][DUEL_WITH_MONEY] = false;
	g_Duel[playerid][DUEL_BET] = 0;
	return 1;
}

// ================= ОБРАБОТКА ДИАЛОГОВ =================
// Вызывать из public OnDialogResponse(...)
stock bool:Duel_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_DUEL_WEAPON:
		{
			if(g_Duel[playerid][DUEL_STATE] != DUEL_STATE_WEAPON) return false;

			if(!response)
			{
				Duel_Reset(playerid);
				return true;
			}

			if(listitem < 0 || listitem >= 5) return true;

			g_Duel[playerid][DUEL_WEAPON] = g_DuelWeaponList[listitem][DUEL_WEAPON_ID];
			g_Duel[playerid][DUEL_STATE] = DUEL_STATE_MONEYTYPE;

			Duel_ShowMoneyTypeDialog(playerid);
			return true;
		}

		case DIALOG_DUEL_MONEY_TYPE:
		{
			if(g_Duel[playerid][DUEL_STATE] != DUEL_STATE_MONEYTYPE) return false;

			if(!response)
			{
				g_Duel[playerid][DUEL_STATE] = DUEL_STATE_WEAPON;
				Duel_ShowWeaponDialog(playerid);
				return true;
			}

			if(listitem == 0)
			{
				g_Duel[playerid][DUEL_WITH_MONEY] = false;
				g_Duel[playerid][DUEL_BET] = 0;
				Duel_SendOffer(playerid);
			}
			else
			{
				g_Duel[playerid][DUEL_STATE] = DUEL_STATE_BET;
				ShowPlayerDialog(playerid, DIALOG_DUEL_BET_AMOUNT, DIALOG_STYLE_INPUT, "{FFCC00}Дуэль | Сумма ставки",
					"Введите сумму ставки (от 1 до 10.000.000):", "Далее", "Назад");
			}
			return true;
		}

		case DIALOG_DUEL_BET_AMOUNT:
		{
			if(g_Duel[playerid][DUEL_STATE] != DUEL_STATE_BET) return false;

			if(!response)
			{
				g_Duel[playerid][DUEL_STATE] = DUEL_STATE_MONEYTYPE;
				Duel_ShowMoneyTypeDialog(playerid);
				return true;
			}

			new bet;
			if(sscanf(inputtext, "d", bet) || bet < DUEL_MIN_BET || bet > DUEL_MAX_BET)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Некорректная сумма. Введите целое число от 1 до 10.000.000.");
				ShowPlayerDialog(playerid, DIALOG_DUEL_BET_AMOUNT, DIALOG_STYLE_INPUT, "{FFCC00}Дуэль | Сумма ставки",
					"Введите сумму ставки (от 1 до 10.000.000):", "Далее", "Назад");
				return true;
			}

			if(GetPlayerMoneyEx(playerid) < bet)
			{
				SendClientMessage(playerid, 0xFF0000FF, "У вас недостаточно денег для такой ставки.");
				Duel_Reset(playerid);
				return true;
			}

			g_Duel[playerid][DUEL_WITH_MONEY] = true;
			g_Duel[playerid][DUEL_BET] = bet;
			Duel_SendOffer(playerid);
			return true;
		}

		case DIALOG_DUEL_CONFIRM:
		{
			new challenger = g_Duel[playerid][DUEL_TARGET];

			if(!response || challenger == INVALID_PLAYER_ID || !IsPlayerConnected(challenger)
				|| g_Duel[challenger][DUEL_STATE] != DUEL_STATE_PENDING || g_Duel[challenger][DUEL_TARGET] != playerid)
			{
				if(challenger != INVALID_PLAYER_ID && IsPlayerConnected(challenger) && g_Duel[challenger][DUEL_STATE] == DUEL_STATE_PENDING)
				{
					SendClientMessage(challenger, 0xFF0000FF, "Игрок отклонил ваш вызов на дуэль.");
					Duel_Reset(challenger);
				}
				Duel_Reset(playerid);
				return true;
			}

			if(g_Duel[challenger][DUEL_WITH_MONEY])
			{
				new bet = g_Duel[challenger][DUEL_BET];

				if(GetPlayerMoneyEx(challenger) < bet)
				{
					SendClientMessage(playerid, 0xFF0000FF, "У соперника больше нет денег на такую ставку. Дуэль отменена.");
					SendClientMessage(challenger, 0xFF0000FF, "У вас больше нет денег на такую ставку. Дуэль отменена.");
					Duel_Reset(challenger);
					Duel_Reset(playerid);
					return true;
				}
				if(GetPlayerMoneyEx(playerid) < bet)
				{
					SendClientMessage(playerid, 0xFF0000FF, "У вас недостаточно денег для такой ставки. Дуэль отменена.");
					SendClientMessage(challenger, 0xFF0000FF, "У соперника недостаточно денег. Дуэль отменена.");
					Duel_Reset(challenger);
					Duel_Reset(playerid);
					return true;
				}
			}

			if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(challenger))
			{
				SendClientMessage(playerid, 0xFF0000FF, "Дуэль отменена: один из игроков находится в транспорте.");
				SendClientMessage(challenger, 0xFF0000FF, "Дуэль отменена: один из игроков находится в транспорте.");
				Duel_Reset(challenger);
				Duel_Reset(playerid);
				return true;
			}

			Duel_Begin(challenger, playerid);
			return true;
		}
	}
	return false;
}

// ================= ОБРАБОТКА СМЕРТИ =================
// Вызывать из public OnPlayerDeath(playerid, killerid, reason)
stock bool:Duel_OnPlayerDeath(playerid, killerid, reason)
{
	#pragma unused reason

	if(g_Duel[playerid][DUEL_STATE] != DUEL_STATE_ACTIVE) return false;

	new opponent = g_Duel[playerid][DUEL_TARGET];

	// Погиб не от руки соперника по дуэли (машина, вода, читы и т.д.) - завершаем без результата
	if(killerid == INVALID_PLAYER_ID || killerid != opponent)
	{
		if(opponent != INVALID_PLAYER_ID && IsPlayerConnected(opponent) && g_Duel[opponent][DUEL_STATE] == DUEL_STATE_ACTIVE)
		{
			SendClientMessage(opponent, 0xFF0000FF, "Дуэль прервана: соперник погиб не от вашей руки.");
			Duel_FinishPlayer(opponent);
		}
		Duel_FinishPlayer(playerid);
		return true;
	}

	new bool:with_money = g_Duel[playerid][DUEL_WITH_MONEY];
	new bet = g_Duel[playerid][DUEL_BET];

	new msg[128];

	if(with_money && bet > 0)
	{
		GivePlayerMoneyEx(killerid, bet, "Победа в дуэли", true, true);
		GivePlayerMoneyEx(playerid, -bet, "Поражение в дуэли", true, true);

		new money_str[32];
		ConvertMoney(bet, money_str);

		format(msg, sizeof msg, "Вы выиграли дуэль против %s! (+%s руб.)", GetPlayerNameEx(playerid), money_str);
		SendClientMessage(killerid, 0x66CC00FF, msg);

		format(msg, sizeof msg, "Вы проиграли дуэль против %s. (-%s руб.)", GetPlayerNameEx(killerid), money_str);
		SendClientMessage(playerid, 0xFF0000FF, msg);
	}
	else
	{
		format(msg, sizeof msg, "Вы выиграли дуэль против %s!", GetPlayerNameEx(playerid));
		SendClientMessage(killerid, 0x66CC00FF, msg);

		format(msg, sizeof msg, "Вы проиграли дуэль против %s.", GetPlayerNameEx(killerid));
		SendClientMessage(playerid, 0xFF0000FF, msg);
	}

	Duel_FinishPlayer(killerid);
	Duel_FinishPlayer(playerid);

	return true;
}

// ================= СПАВН / КОННЕКТ / ДИСКОННЕКТ =================
// Вызывать из public OnPlayerSpawn(playerid)
stock Duel_OnPlayerSpawn(playerid)
{
	if(g_Duel[playerid][DUEL_NEED_RESTORE])
	{
		Duel_RestorePlayer(playerid);
	}
	return 1;
}

// Вызывать из public OnPlayerConnect(playerid)
stock Duel_OnPlayerConnect(playerid)
{
	Duel_Reset(playerid);
	g_Duel[playerid][DUEL_NEED_RESTORE] = false;
	return 1;
}

// Вызывать из public OnPlayerDisconnect(playerid, reason)
stock Duel_OnPlayerDisconnect(playerid)
{
	if(g_Duel[playerid][DUEL_STATE] == DUEL_STATE_ACTIVE)
	{
		new opponent = g_Duel[playerid][DUEL_TARGET];
		if(opponent != INVALID_PLAYER_ID && IsPlayerConnected(opponent) && g_Duel[opponent][DUEL_STATE] == DUEL_STATE_ACTIVE)
		{
			SendClientMessage(opponent, 0xFF0000FF, "Соперник покинул сервер во время дуэли. Дуэль отменена.");
			Duel_FinishPlayer(opponent);
		}
	}
	else if(g_Duel[playerid][DUEL_STATE] != DUEL_STATE_NONE)
	{
		new opponent = g_Duel[playerid][DUEL_TARGET];
		if(opponent != INVALID_PLAYER_ID && IsPlayerConnected(opponent) && g_Duel[opponent][DUEL_STATE] != DUEL_STATE_NONE)
		{
			SendClientMessage(opponent, 0xFF0000FF, "Игрок отключился, дуэль отменена.");
			Duel_Reset(opponent);
		}
	}

	Duel_Reset(playerid);
	g_Duel[playerid][DUEL_NEED_RESTORE] = false;
	return 1;
}
