// ============================================================================
//  zags.pwn — Система ЗАГСа (брак / развод)
//  Авторство: by_ml_skarf | Ml Skarf
//  Проект: Ml Skarf
//  Подключение: #include "zags.pwn"
// ============================================================================

#if defined _ZAGS_SYSTEM_INCLUDED
	#endinput
#endif
#define _ZAGS_SYSTEM_INCLUDED

// ---------------------------------------------------------------------------
//  Настройки
// ---------------------------------------------------------------------------
#define ZAGS_MARRY_PRICE          50000      // Стоимость регистрации брака
#define ZAGS_DIVORCE_PRICE        100000     // Стоимость развода
#define ZAGS_MIN_LEVEL            5          // Минимальный уровень для брака
#define ZAGS_MAX_DISTANCE         5.0        // Максимальная дистанция между игроками
#define ZAGS_RING_ITEM_ID         0          // ID предмета "Кольцо" (0 = не требуется)
#define MAX_ZAGS_POINTS           6

// Диалоги
#define DIALOG_ZAGS_MAIN          18500
#define DIALOG_ZAGS_MARRY_CONFIRM 18501
#define DIALOG_ZAGS_DIVORCE_CONFIRM 18502
#define DIALOG_ZAGS_PROPOSE       18503

// ---------------------------------------------------------------------------
//  Данные
// ---------------------------------------------------------------------------
enum e_ZagsPoint
{
	Float:ZAGS_X,
	Float:ZAGS_Y,
	Float:ZAGS_Z,
	Float:ZAGS_A,
	ZAGS_ACTOR,
	ZAGS_PICKUP,
	Text3D:ZAGS_LABEL
}

new g_ZagsPoints[MAX_ZAGS_POINTS][e_ZagsPoint] =
{
	// Арзамас (примерные координаты — подправь под свою карту)
	{  1481.23,  -1740.45,  13.54,  90.0,  0, 0, Text3D:0 },
	// Литеры
	{  1834.12,  -1682.33,  13.38,  180.0, 0, 0, Text3D:0 },
	// Южный
	{  2495.67,   920.11,  11.02,  270.0, 0, 0, Text3D:0 },
	// Северный
	{  -1980.5,  1115.2,   54.4,   0.0,   0, 0, Text3D:0 },
	// Запасные точки
	{  0.0, 0.0, 0.0, 0.0, 0, 0, Text3D:0 },
	{  0.0, 0.0, 0.0, 0.0, 0, 0, Text3D:0 }
};

new g_ZagsProposeTo[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new g_ZagsProposeFrom[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new g_ZagsTimer[MAX_PLAYERS];

// ---------------------------------------------------------------------------
//  Инициализация
// ---------------------------------------------------------------------------
stock Zags_Init()
{
	// Актёры и пикапы
	for(new i = 0; i < MAX_ZAGS_POINTS; i++)
	{
		if(g_ZagsPoints[i][ZAGS_X] == 0.0 && g_ZagsPoints[i][ZAGS_Y] == 0.0)
			continue;

		// Актёр (модель 147 — человек в костюме / подбери свою)
		g_ZagsPoints[i][ZAGS_ACTOR] = CreateActor(147,
			g_ZagsPoints[i][ZAGS_X],
			g_ZagsPoints[i][ZAGS_Y],
			g_ZagsPoints[i][ZAGS_Z],
			g_ZagsPoints[i][ZAGS_A]);

		SetActorInvulnerable(g_ZagsPoints[i][ZAGS_ACTOR], true);

		// Пикап
		g_ZagsPoints[i][ZAGS_PICKUP] = CreatePickup(1274, 23,
			g_ZagsPoints[i][ZAGS_X],
			g_ZagsPoints[i][ZAGS_Y],
			g_ZagsPoints[i][ZAGS_Z] + 0.5,
			-1);

		// 3D-текст
		new label[64];
		format(label, sizeof(label), "{FFD700}ЗАГС\n{FFFFFF}Регистрация брака / Развод");
		g_ZagsPoints[i][ZAGS_LABEL] = Create3DTextLabel(label, 0xFFFFFFFF,
			g_ZagsPoints[i][ZAGS_X],
			g_ZagsPoints[i][ZAGS_Y],
			g_ZagsPoints[i][ZAGS_Z] + 1.2,
			15.0, 0, 0);
	}

	printf("[ZAGS] Система ЗАГСа загружена | by_ml_skarf | Точек: %d", MAX_ZAGS_POINTS);
	return 1;
}

// ---------------------------------------------------------------------------
//  Вспомогательные функции
// ---------------------------------------------------------------------------
stock IsPlayerNearZags(playerid)
{
	for(new i = 0; i < MAX_ZAGS_POINTS; i++)
	{
		if(g_ZagsPoints[i][ZAGS_X] == 0.0) continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0,
			g_ZagsPoints[i][ZAGS_X],
			g_ZagsPoints[i][ZAGS_Y],
			g_ZagsPoints[i][ZAGS_Z]))
			return i;
	}
	return -1;
}

stock GetPlayerWife(playerid)
{
	return GetPlayerData(playerid, P_WIFE);
}

stock SetPlayerWife(playerid, wifeid)
{
	SetPlayerData(playerid, P_WIFE, wifeid);
	UpdatePlayerDatabaseInt(playerid, "wife", wifeid);
	return 1;
}

stock bool:IsPlayerMarried(playerid)
{
	new wife = GetPlayerWife(playerid);
	return (wife > 0);
}

stock GetPlayerNameExSafe(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

// ---------------------------------------------------------------------------
//  Основные функции
// ---------------------------------------------------------------------------
stock ShowZagsMainDialog(playerid)
{
	if(IsPlayerNearZags(playerid) == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы должны находиться у здания ЗАГСа", " ");
		return 0;
	}

	new string[512];
	new wife = GetPlayerWife(playerid);

	if(wife > 0)
	{
		// Уже женат
		format(string, sizeof(string),
			"{FFFFFF}Вы состоите в браке.\n\n\
			{AAAAAA}Супруг(а) ID: {FFFFFF}%d\n\n\
			{FF5252}1. Подать на развод ({FFFFFF}%d${FF5252})",
			wife, ZAGS_DIVORCE_PRICE);
	}
	else
	{
		format(string, sizeof(string),
			"{FFFFFF}Добро пожаловать в ЗАГС!\n\n\
			{AAAAAA}Здесь вы можете зарегистрировать брак.\n\n\
			{00FF00}1. Зарегистрировать брак ({FFFFFF}%d${00FF00})\n\
			{AAAAAA}Для брака оба игрока должны стоять рядом.",
			ZAGS_MARRY_PRICE);
	}

	ShowPlayerDialog(playerid, DIALOG_ZAGS_MAIN, DIALOG_STYLE_LIST,
		"{FFD700}ЗАГС — Регистрация актов гражданского состояния",
		string, "Выбрать", "Отмена");
	return 1;
}

stock Zags_ProposeMarriage(playerid, targetid)
{
	if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
	{
		ShowNotificationNew(playerid, 2, 4, 0, 0, "Игрок не в сети", " ");
		return 0;
	}

	if(playerid == targetid)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Нельзя жениться на себе", " ");
		return 0;
	}

	if(IsPlayerMarried(playerid))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы уже состоите в браке", " ");
		return 0;
	}

	if(IsPlayerMarried(targetid))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Этот игрок уже состоит в браке", " ");
		return 0;
	}

	if(GetPlayerData(playerid, P_LEVEL) < ZAGS_MIN_LEVEL || GetPlayerData(targetid, P_LEVEL) < ZAGS_MIN_LEVEL)
	{
		new msg[128];
		format(msg, sizeof(msg), "Минимальный уровень для брака — %d", ZAGS_MIN_LEVEL);
		ShowNotificationNew(playerid, 2, 3, 0, 0, msg, " ");
		return 0;
	}

	if(GetPlayerMoney(playerid) < ZAGS_MARRY_PRICE)
	{
		ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно денег для регистрации брака", " ");
		return 0;
	}

	// Дистанция
	new Float:x, Float:y, Float:z;
	GetPlayerPos(targetid, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, ZAGS_MAX_DISTANCE, x, y, z))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Игрок слишком далеко", " ");
		return 0;
	}

	// Оба у ЗАГСа
	if(IsPlayerNearZags(playerid) == -1 || IsPlayerNearZags(targetid) == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Оба игрока должны находиться у ЗАГСа", " ");
		return 0;
	}

	// Пол (опционально — раскомментируй если нужно только разнополые)
	/*
	if(GetPlayerData(playerid, P_SEX) == GetPlayerData(targetid, P_SEX))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Брак возможен только между мужчиной и женщиной", " ");
		return 0;
	}
	*/

	g_ZagsProposeTo[playerid] = targetid;
	g_ZagsProposeFrom[targetid] = playerid;

	new string[256];
	format(string, sizeof(string),
		"{FFFFFF}%s[%d] предлагает вам заключить брак.\n\n\
		Стоимость регистрации: {00FF00}%d$\n\
		{AAAAAA}(оплачивает тот, кто предлагает)",
		GetPlayerNameExSafe(playerid), playerid, ZAGS_MARRY_PRICE);

	ShowPlayerDialog(targetid, DIALOG_ZAGS_PROPOSE, DIALOG_STYLE_MSGBOX,
		"{FFD700}Предложение руки и сердца",
		string, "Согласиться", "Отказаться");

	format(string, sizeof(string), "Вы предложили %s[%d] заключить брак. Ожидайте ответа...",
		GetPlayerNameExSafe(targetid), targetid);
	SendClientMessage(playerid, 0xFFD700FF, string);

	// Таймер на авто-отказ через 60 сек
	if(g_ZagsTimer[targetid]) KillTimer(g_ZagsTimer[targetid]);
	g_ZagsTimer[targetid] = SetTimerEx("Zags_ProposeTimeout", 60000, false, "i", targetid);

	return 1;
}

forward Zags_ProposeTimeout(playerid);
public Zags_ProposeTimeout(playerid)
{
	if(g_ZagsProposeFrom[playerid] != INVALID_PLAYER_ID)
	{
		new from = g_ZagsProposeFrom[playerid];
		if(IsPlayerConnected(from))
			SendClientMessage(from, 0xFF5252FF, "Время ожидания ответа на предложение истекло.");

		g_ZagsProposeFrom[playerid] = INVALID_PLAYER_ID;
		g_ZagsProposeTo[from] = INVALID_PLAYER_ID;
	}
	g_ZagsTimer[playerid] = 0;
	return 1;
}

stock Zags_CompleteMarriage(playerid, targetid)
{
	// playerid — тот, кто предложил (платит)
	if(GetPlayerMoney(playerid) < ZAGS_MARRY_PRICE)
	{
		ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно денег", " ");
		return 0;
	}

	GivePlayerMoneyEx(playerid, -ZAGS_MARRY_PRICE, "Регистрация брака", true, true);

	// Устанавливаем взаимно
	SetPlayerWife(playerid, GetPlayerAccountID(targetid));
	SetPlayerWife(targetid, GetPlayerAccountID(playerid));

	new string[256];
	format(string, sizeof(string),
		"{FFD700}[ЗАГС] {FFFFFF}%s[%d] и %s[%d] официально вступили в брак!",
		GetPlayerNameExSafe(playerid), playerid,
		GetPlayerNameExSafe(targetid), targetid);
	SendClientMessageToAll(-1, string);

	SendClientMessage(playerid, 0x00FF00FF, "Поздравляем! Вы успешно зарегистрировали брак.");
	SendClientMessage(targetid, 0x00FF00FF, "Поздравляем! Вы успешно зарегистрировали брак.");

	// Можно добавить эффект / звук / анимацию
	ApplyAnimation(playerid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
	ApplyAnimation(targetid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);

	g_ZagsProposeTo[playerid] = INVALID_PLAYER_ID;
	g_ZagsProposeFrom[targetid] = INVALID_PLAYER_ID;

	if(g_ZagsTimer[targetid]) KillTimer(g_ZagsTimer[targetid]);
	g_ZagsTimer[targetid] = 0;

	return 1;
}

stock Zags_DoDivorce(playerid)
{
	new wifeAccId = GetPlayerWife(playerid);
	if(wifeAccId <= 0)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы не состоите в браке", " ");
		return 0;
	}

	if(GetPlayerMoney(playerid) < ZAGS_DIVORCE_PRICE)
	{
		ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно денег для развода", " ");
		return 0;
	}

	GivePlayerMoneyEx(playerid, -ZAGS_DIVORCE_PRICE, "Развод", true, true);

	// Ищем супруга онлайн
	new wifePlayer = INVALID_PLAYER_ID;
	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerAccountID(i) == wifeAccId)
		{
			wifePlayer = i;
			break;
		}
	}

	SetPlayerWife(playerid, 0);

	if(wifePlayer != INVALID_PLAYER_ID)
	{
		SetPlayerWife(wifePlayer, 0);
		new string[128];
		format(string, sizeof(string), "{FF5252}Ваш супруг(а) %s[%d] подал(а) на развод.",
			GetPlayerNameExSafe(playerid), playerid);
		SendClientMessage(wifePlayer, -1, string);
	}
	else
	{
		// Оффлайн — обновляем в БД напрямую
		new query[128];
		mysql_format(mysql, query, sizeof(query),
			"UPDATE `accounts` SET `wife` = 0 WHERE `id` = %d LIMIT 1", wifeAccId);
		mysql_tquery(mysql, query);
	}

	SendClientMessage(playerid, 0xFF5252FF, "Вы успешно расторгли брак.");
	SendClientMessageToAll(0xFF5252FF, "Один из игроков расторгнул брак в ЗАГСе.");

	return 1;
}

// ---------------------------------------------------------------------------
//  Обработка диалогов
// ---------------------------------------------------------------------------
// Переименовано под berkut.pwn: вызывается из основного public OnDialogResponse
stock Zags_MainDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

	switch(dialogid)
	{
		case DIALOG_ZAGS_MAIN:
		{
			if(!response) return 1;

			new wife = GetPlayerWife(playerid);
			if(wife > 0)
			{
				// Развод
				if(listitem == 0)
				{
					new string[256];
					format(string, sizeof(string),
						"{FFFFFF}Вы уверены, что хотите расторгнуть брак?\n\n\
						Стоимость: {FF5252}%d$\n\
						{AAAAAA}Это действие необратимо.",
						ZAGS_DIVORCE_PRICE);
					ShowPlayerDialog(playerid, DIALOG_ZAGS_DIVORCE_CONFIRM, DIALOG_STYLE_MSGBOX,
						"{FF5252}Подтверждение развода", string, "Да, развестись", "Отмена");
				}
			}
			else
			{
				// Брак — просим ввести ID
				ShowPlayerDialog(playerid, DIALOG_ZAGS_MARRY_CONFIRM, DIALOG_STYLE_INPUT,
					"{FFD700}Регистрация брака",
					"{FFFFFF}Введите ID игрока, с которым хотите заключить брак:\n\n\
					{AAAAAA}Оба должны стоять у ЗАГСа.",
					"Предложить", "Отмена");
			}
			return 1;
		}

		case DIALOG_ZAGS_MARRY_CONFIRM:
		{
			if(!response) return 1;

			new targetid = strval(inputtext);
			if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid))
			{
				ShowNotificationNew(playerid, 2, 4, 0, 0, "Неверный ID игрока", " ");
				return 1;
			}

			Zags_ProposeMarriage(playerid, targetid);
			return 1;
		}

		case DIALOG_ZAGS_PROPOSE:
		{
			new from = g_ZagsProposeFrom[playerid];
			if(from == INVALID_PLAYER_ID) return 1;

			if(g_ZagsTimer[playerid]) KillTimer(g_ZagsTimer[playerid]);
			g_ZagsTimer[playerid] = 0;

			if(response)
			{
				Zags_CompleteMarriage(from, playerid);
			}
			else
			{
				SendClientMessage(from, 0xFF5252FF, "Вам отказали в предложении брака.");
				SendClientMessage(playerid, 0xAAAAAAFF, "Вы отказались от предложения.");
				g_ZagsProposeTo[from] = INVALID_PLAYER_ID;
				g_ZagsProposeFrom[playerid] = INVALID_PLAYER_ID;
			}
			return 1;
		}

		case DIALOG_ZAGS_DIVORCE_CONFIRM:
		{
			if(response)
				Zags_DoDivorce(playerid);
			return 1;
		}
	}
	return 0; // или 1 в зависимости от ALS
}

// ---------------------------------------------------------------------------
//  Команды
// ---------------------------------------------------------------------------
CMD:zags(playerid, params[])
{
	ShowZagsMainDialog(playerid);
	return 1;
}

CMD:marry(playerid, params[])
{
	extract params -> new targetid; else
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /marry [id игрока]");

	Zags_ProposeMarriage(playerid, targetid);
	return 1;
}

CMD:divorce(playerid, params[])
{
	if(IsPlayerNearZags(playerid) == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Развод можно оформить только в ЗАГСе", " ");
		return 1;
	}

	new string[256];
	format(string, sizeof(string),
		"{FFFFFF}Вы уверены, что хотите расторгнуть брак?\n\n\
		Стоимость: {FF5252}%d$",
		ZAGS_DIVORCE_PRICE);
	ShowPlayerDialog(playerid, DIALOG_ZAGS_DIVORCE_CONFIRM, DIALOG_STYLE_MSGBOX,
		"{FF5252}Подтверждение развода", string, "Да", "Нет");
	return 1;
}

// ---------------------------------------------------------------------------
//  OnPlayerConnect / Disconnect (сброс)
// ---------------------------------------------------------------------------
// Переименовано под berkut.pwn: вызывается из основного public OnPlayerConnect
stock Zags_ConnectHook(playerid)
{
	g_ZagsProposeTo[playerid] = INVALID_PLAYER_ID;
	g_ZagsProposeFrom[playerid] = INVALID_PLAYER_ID;
	g_ZagsTimer[playerid] = 0;
	return 1;
}

// Переименовано под berkut.pwn: вызывается из основного public OnPlayerDisconnect
stock Zags_DisconnectHook(playerid, reason)
{
	if(g_ZagsTimer[playerid]) KillTimer(g_ZagsTimer[playerid]);

	new to = g_ZagsProposeTo[playerid];
	if(to != INVALID_PLAYER_ID)
	{
		g_ZagsProposeFrom[to] = INVALID_PLAYER_ID;
		g_ZagsProposeTo[playerid] = INVALID_PLAYER_ID;
	}

	new from = g_ZagsProposeFrom[playerid];
	if(from != INVALID_PLAYER_ID)
	{
		g_ZagsProposeTo[from] = INVALID_PLAYER_ID;
		g_ZagsProposeFrom[playerid] = INVALID_PLAYER_ID;
	}
	return 1;
}

// ---------------------------------------------------------------------------
//  Пикап — переименовано под berkut.pwn: вызывается из public OnPlayerPickUpPickup
//  (include/system/pickup.pwn). Возвращает 1, если пикап обработан ЗАГСом.
// ---------------------------------------------------------------------------
stock Zags_HandlePickup(playerid, pickupid)
{
	for(new i = 0; i < MAX_ZAGS_POINTS; i++)
	{
		if(g_ZagsPoints[i][ZAGS_PICKUP] == pickupid)
		{
			ShowZagsMainDialog(playerid);
			return 1;
		}
	}
	return 0;
}

// ---------------------------------------------------------------------------
//  Вызов при старте сервера
// ---------------------------------------------------------------------------
// В OnGameModeInit добавь:
// Zags_Init();
