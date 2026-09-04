// ============================================================================
//  admin_redname.pwn — Система красного ника администраторов
//  Авторство: by_ml_skarf | Ml Skarf
//  Проект: Ml Skarf
//  Подключение: #include "admin_redname.pwn"
// ============================================================================

#if defined _ADMIN_REDNAME_INCLUDED
	#endinput
#endif
#define _ADMIN_REDNAME_INCLUDED

// ---------------------------------------------------------------------------
//  Настройки
// ---------------------------------------------------------------------------
#define ADMIN_COLOR_RED         0xFF0000FF      // Красный цвет ника
#define ADMIN_COLOR_DEFAULT     0xFFFFFFFF      // Белый (обычный)
#define ADMIN_COLOR_DUTY        0xFF3333FF      // Чуть мягче красный на duty

// Если хочешь, чтобы ник был красным всегда у админов — поставь 1
// Если только на /aduty — поставь 0
#define ADMIN_REDNAME_ALWAYS    0

// ---------------------------------------------------------------------------
//  Данные
// ---------------------------------------------------------------------------
new bool:g_AdminDuty[MAX_PLAYERS];
new g_AdminOldColor[MAX_PLAYERS];

// ---------------------------------------------------------------------------
//  Основные функции
// ---------------------------------------------------------------------------
stock AdminRedName_Set(playerid, bool:enable)
{
	if(!IsPlayerConnected(playerid)) return 0;

	if(enable)
	{
		// Сохраняем старый цвет
		g_AdminOldColor[playerid] = GetPlayerColor(playerid);
		SetPlayerColor(playerid, ADMIN_COLOR_RED);
		g_AdminDuty[playerid] = true;
	}
	else
	{
		// Возвращаем обычный цвет (или белый)
		if(g_AdminOldColor[playerid] != 0)
			SetPlayerColor(playerid, g_AdminOldColor[playerid]);
		else
			SetPlayerColor(playerid, ADMIN_COLOR_DEFAULT);

		g_AdminDuty[playerid] = false;
	}
	return 1;
}

stock bool:AdminRedName_IsDuty(playerid)
{
	return g_AdminDuty[playerid];
}

stock AdminRedName_OnLogin(playerid)
{
	#if ADMIN_REDNAME_ALWAYS == 1
		if(GetPlayerAdminEx(playerid) > 0)
		{
			SetPlayerColor(playerid, ADMIN_COLOR_RED);
			g_AdminDuty[playerid] = true;
		}
	#else
		// По умолчанию выключено, включается через /aduty
		g_AdminDuty[playerid] = false;
	#endif
	return 1;
}

// ---------------------------------------------------------------------------
//  Команды
// ---------------------------------------------------------------------------
CMD:aduty(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа", " ");
		return 1;
	}

	if(g_AdminDuty[playerid])
	{
		AdminRedName_Set(playerid, false);
		SendClientMessage(playerid, 0xAAAAAAFF, "[Админ] Вы вышли с дежурства. Ник стал обычным.");
		
		new msg[128];
		format(msg, sizeof(msg), "[A] %s[%d] вышел с админ-дежурства", GetPlayerNameEx(playerid), playerid);
		SendMessageToAdmins(msg, 0x999999FF);
	}
	else
	{
		AdminRedName_Set(playerid, true);
		SendClientMessage(playerid, 0xFF0000FF, "[Админ] Вы заступили на дежурство. Ник стал красным.");
		
		new msg[128];
		format(msg, sizeof(msg), "[A] %s[%d] заступил на админ-дежурство", GetPlayerNameEx(playerid), playerid);
		SendMessageToAdmins(msg, 0xFF0000FF);
	}
	return 1;
}

CMD:redname(playerid, params[])
{
	// Алиас на /aduty
	if(GetPlayerAdminEx(playerid) < 1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа", " ");
		return 1;
	}

	if(g_AdminDuty[playerid])
	{
		AdminRedName_Set(playerid, false);
		SendClientMessage(playerid, 0xAAAAAAFF, "[Админ] Вы вышли с дежурства. Ник стал обычным.");
	}
	else
	{
		AdminRedName_Set(playerid, true);
		SendClientMessage(playerid, 0xFF0000FF, "[Админ] Вы заступили на дежурство. Ник стал красным.");
	}
	return 1;
}

// ---------------------------------------------------------------------------
//  Хуки
// ---------------------------------------------------------------------------
// Переименовано под berkut.pwn: вызывается из основного public OnPlayerConnect
stock AdminRedName_ConnectHook(playerid)
{
	g_AdminDuty[playerid] = false;
	g_AdminOldColor[playerid] = 0;
	return 1;
}

// Переименовано под berkut.pwn: вызывается из основного public OnPlayerDisconnect
stock AdminRedName_DisconnectHook(playerid, reason)
{
	g_AdminDuty[playerid] = false;
	g_AdminOldColor[playerid] = 0;
	return 1;
}

// Вызови эту функцию после успешного логина администратора
// Например в месте, где проверяется admin > 0 после авторизации:
// AdminRedName_OnLogin(playerid);

// ---------------------------------------------------------------------------
//  Дополнительно: автоматический красный ник при входе (если ALWAYS = 1)
// ---------------------------------------------------------------------------
// Если у тебя есть свой OnPlayerSpawn или место после логина —
// просто вызови AdminRedName_OnLogin(playerid);

// В OnGameModeInit() можешь добавить:
// printf("[ADMIN REDNAME] Система красного ника загружена | by_ml_skarf");
