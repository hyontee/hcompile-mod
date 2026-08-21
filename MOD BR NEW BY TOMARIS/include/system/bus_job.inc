/*
	ПОШАГОВОЕ ПОДКЛЮЧЕНИЕ 

	ШАГ 1. В OnGameModeInit (в самом конце, после инициализации MySQL base):
		BusJob_Init(base);

	ШАГ 2. В OnPlayerConnect:
		BusJob_OnPlayerConnect(playerid);

	ШАГ 3. В OnPlayerDisconnect (ДО того, как игрок сохраняется/удаляется из БД):
		BusJob_OnPlayerDisconnect(playerid);

	ШАГ 4. В OnDialogResponse — ОБЯЗАТЕЛЬНО первой рабочей строкой (return 1 если true):
		if(BusJob_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;

	ШАГ 5. Никаких хуков клавиш не требуется — открытие меню Валеры работает
		ИСКЛЮЧИТЕЛЬНО через команду /valera (кнопка/окно взаимодействия убраны).

	Таблица MySQL создаётся автоматически при старте сервера:
		CREATE TABLE IF NOT EXISTS `bus_workers` (
			`name`     VARCHAR(24) NOT NULL PRIMARY KEY,
			`trips`    INT NOT NULL DEFAULT 0,
			`earned`   INT NOT NULL DEFAULT 0,
			`employed` TINYINT(1) NOT NULL DEFAULT 0
		);

	Логика маршрута (обновлено):
	1) Водитель нажимает "Начать рабочий день", указывает цену проезда — автобус
	   (жёлтого цвета) появляется у Валеры.
	2) Как только водитель садится за руль, включается GPS-навигатор (чекпоинт)
	   на первую из 7 меток BUS_SPAWN_POINTS.
	3) Деньги за цену проезда начисляются водителю КАЖДЫЙ РАЗ, когда к нему в
	   автобус подсаживается пассажир (другой игрок садится не на место водителя).
	4) За каждую пройденную метку (кроме последней) водитель получает
	   BUS_STOP_BONUS и замораживается на BUS_STOP_FREEZE_TIME (5 секунд) —
	   в это время на экране появляется надпись "Автобус приехал на остановку".
	5) На последней (7-й) метке автобус исчезает, рейс засчитывается в БД, и
	   водителю сразу начисляется BUS_FINAL_BONUS (1 000 000).
*/

#if defined _bus_job_included
	#endinput
#endif
#define _bus_job_included

#include <a_samp>
#if !defined _streamer_included && !defined STREAMER_TYPE_OBJECT
	#include <streamer>
#endif

//====================НАСТРОЙКИ====================//
#define BUS_NPC_SKIN            82
#define BUS_NPC_NAME            "Валера"
#define BUS_VEHICLE_MODEL       414
#define BUS_VEHICLE_COLOR1      6       // жёлтый — цвет кузова автобуса
#define BUS_VEHICLE_COLOR2      6       // жёлтый — цвет кузова автобуса
#define BUS_WAIT_TIME           60      // секунд на посадку в автобус
#define BUS_MIN_PRICE           100
#define BUS_MAX_PRICE           10000
#define BUS_TRIGGER_RADIUS      3.0
#define BUS_ROUTE_FROM          "Арзамас"
#define BUS_ROUTE_TO            "Лыткарино"
#define BUS_TABLE               "bus_workers"

#define BUS_CP_RADIUS           5.0     // радиус срабатывания метки-чекпоинта
#define BUS_STOP_BONUS          500000  // деньги за 1 пройденную метку (кроме последней)
#define BUS_FINAL_BONUS         1000000 // бонус за финальную метку
#define BUS_STOP_FREEZE_TIME    5000    // мс заморозки на остановке (5 секунд)

static const Float:BUS_NPC_POS[4] = {889.13, 763.24, 14.35, 342.47};

// Точки ПАРКОВКИ — сюда спавнится автобус в начале смены (случайная из этих 7).
static const Float:BUS_PARK_POINTS[7][4] =
{
	{890.92, 755.99, 14.32, 236.91},
	{892.00, 760.62, 14.31, 243.12},
	{893.72, 765.05, 14.31, 235.73},
	{896.48, 769.23, 14.33, 260.85},
	{897.67, 773.78, 14.32, 233.38},
	{899.18, 779.36, 14.31, 239.24},
	{901.35, 784.56, 14.31, 238.88}
};

// Точки МАРШРУТА (метки/чекпоинты), по которым игрок едет после посадки пассажира (0 -> 7).
// Последняя точка (индекс 7) — конечная: маршрут завершен, выдается BUS_FINAL_BONUS.
static const Float:BUS_SPAWN_POINTS[8][4] =
{
	{772.95, 812.25, 11.33, 246.57},
	{391.14, 744.15, 11.33, 246.57},
	{-19.71, 577.06, 11.35, 246.57},
	{-1775.80, 812.16, 34.85, 246.57},
	{-2154.81, -381.21, 28.71, 246.57},
	{-2137.39, -394.20, 29.45, 246.57},
	{-2519.98, 20.60, 26.79, 246.57},
	{-2421.55, 168.23, 25.37, 246.57}
};

//====================ДИАЛОГИ (диапазон 9000+, чтобы не пересекаться с проектом)====================//
#define DLG_BUS_MENU            9001
#define DLG_BUS_PRICE           9002
#define DLG_BUS_STATS           9003

//====================ПЕРЕМЕННЫЕ====================//
new MySQL:BusJob_DB;
new BusJob_NPC = -1;

new bool:BusJob_Employed[MAX_PLAYERS];
new bool:BusJob_Working[MAX_PLAYERS];
new bool:BusJob_NearNPC[MAX_PLAYERS];
new bool:BusJob_Boarded[MAX_PLAYERS];
new BusJob_Vehicle[MAX_PLAYERS];
new BusJob_Timer[MAX_PLAYERS];
new BusJob_Label[MAX_PLAYERS];
new BusJob_Price[MAX_PLAYERS];
new BusJob_MapIcon[MAX_PLAYERS];

new BusJob_CPIndex[MAX_PLAYERS];          // индекс текущей метки маршрута (0..6)
new bool:BusJob_Frozen[MAX_PLAYERS];      // true = игрок заморожен на остановке
new BusJob_Earned[MAX_PLAYERS];           // накоплено за текущий рейс (для записи в БД)
new bool:BusJob_WasPassenger[MAX_PLAYERS]; // true = игрок уже посчитан как пассажир (чтобы не платить повторно каждую секунду)

//====================ИНИЦИАЛИЗАЦИЯ====================//
forward BusJob_Init(MySQL:db);
public BusJob_Init(MySQL:db)
{
	BusJob_DB = db;

	mysql_tquery(BusJob_DB,
		"CREATE TABLE IF NOT EXISTS `"BUS_TABLE"` (`name` VARCHAR(24) NOT NULL PRIMARY KEY, `trips` INT NOT NULL DEFAULT 0, `earned` INT NOT NULL DEFAULT 0, `employed` TINYINT(1) NOT NULL DEFAULT 0)");

	BusJob_NPC = CreateActor(BUS_NPC_SKIN, BUS_NPC_POS[0], BUS_NPC_POS[1], BUS_NPC_POS[2], BUS_NPC_POS[3]);
	SetActorInvulnerable(BusJob_NPC, true);

	CreateDynamic3DTextLabel("{FFD700}"BUS_NPC_NAME"\n{FFFFFF}Работа: Автобусник\n{00BFFF}Для взаимодействия используйте команду /valera", 0xFFD700FF,
		BUS_NPC_POS[0], BUS_NPC_POS[1], BUS_NPC_POS[2] + 1.05, 15.0);

	SetTimer("BusJob_Tick", 1000, true);
	return 1;
}

forward BusJob_OnPlayerConnect(playerid);
public BusJob_OnPlayerConnect(playerid)
{
	BusJob_Employed[playerid] = false;
	BusJob_Working[playerid] = false;
	BusJob_NearNPC[playerid] = false;
	BusJob_Boarded[playerid] = false;
	BusJob_Vehicle[playerid] = INVALID_VEHICLE_ID;
	BusJob_Timer[playerid] = 0;
	BusJob_Label[playerid] = -1;
	BusJob_Price[playerid] = 0;
	BusJob_CPIndex[playerid] = 0;
	BusJob_Frozen[playerid] = false;
	BusJob_Earned[playerid] = 0;
	BusJob_WasPassenger[playerid] = false;
	BusJob_MapIcon[playerid] = -1;

	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

	new query[128];
	mysql_format(BusJob_DB, query, sizeof(query), "SELECT `employed` FROM `"BUS_TABLE"` WHERE `name` = '%e' LIMIT 1", name);
	mysql_tquery(BusJob_DB, query, "BusJob_LoadCB", "i", playerid);
	return 1;
}

forward BusJob_LoadCB(playerid);
public BusJob_LoadCB(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	if(cache_num_rows())
	{
		new employed;
		employed = cache_get_field_content_int(0, "employed");
		BusJob_Employed[playerid] = employed ? true : false;
	}
	return 1;
}

forward BusJob_OnPlayerDisconnect(playerid);
public BusJob_OnPlayerDisconnect(playerid)
{
	BusJob_EndWorkday(playerid);
	return 1;
}

// взайдействие с нпс командоц /Valera
CMD:valera(playerid, params[])
{
	#pragma unused params
	if(!BusJob_NearNPC[playerid])
	{
		SendClientMessage(playerid, 0xFF5252FF, "Вы должны находиться рядом с Валерой (Автобусник).");
		return 1;
	}
	BusJob_ShowMenu(playerid);
	return 1;
}

//====================ПОИСК ВОДИТЕЛЯ ПО ID АВТОМОБИЛЯ====================//
stock BusJob_FindDriverByVehicle(vehicleid)
{
	for(new j; j < MAX_PLAYERS; j++)
	{
		if(!IsPlayerConnected(j)) continue;
		if(BusJob_Working[j] && BusJob_Boarded[j] && BusJob_Vehicle[j] == vehicleid)
		{
			return j;
		}
	}
	return -1;
}

stock BusJob_UpdateRoute(playerid, Float:toX, Float:toY, Float:toZ)
{
	EnablePlayerGPS(playerid, 55, toX, toY, toZ, "Автобусный маршрут");
	return 1;
}

stock BusJob_ClearRoute(playerid)
{
	DisablePlayerGPS(playerid);
	return 1;
}

forward BusJob_Tick();
public BusJob_Tick()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;

		if(GetPlayerState(i) == PLAYER_STATE_ONFOOT)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(i, x, y, z);
			new Float:dist = VectorSize(x - BUS_NPC_POS[0], y - BUS_NPC_POS[1], z - BUS_NPC_POS[2]);

			if(dist <= BUS_TRIGGER_RADIUS)
			{
				if(!BusJob_NearNPC[i])
				{
					BusJob_NearNPC[i] = true;
					GameTextForPlayer(i, "~w~Для взаимодействия используйте ~g~/valera", 3000, 5);
				}
			}
			else if(BusJob_NearNPC[i])
			{
				BusJob_NearNPC[i] = false;
			}
		}

		// ---- Пассажир сел / вышел из чьего-то автобуса ----
		new vid = GetPlayerVehicleID(i);
		if(vid != 0 && GetPlayerVehicleSeat(i) > 0)
		{
			new driverid = BusJob_FindDriverByVehicle(vid);
			if(driverid != -1 && driverid != i)
			{
				if(!BusJob_WasPassenger[i])
				{
					BusJob_WasPassenger[i] = true;
					BusJob_Earned[driverid] += BusJob_Price[driverid];
					GivePlayerMoneyEx(driverid, BusJob_Price[driverid], "Автобус: пассажир", false, true);

					new pname[MAX_PLAYER_NAME];
					GetPlayerName(i, pname, sizeof(pname));

					new msgD[144];
					format(msgD, sizeof(msgD), "Пассажир %s сел в автобус! Начислено %d рублей.", pname, BusJob_Price[driverid]);
					SendClientMessage(driverid, 0x4CAF50FF, msgD);

					new msgP[128];
					format(msgP, sizeof(msgP), "Вы сели в автобус. Стоимость проезда: %d рублей.", BusJob_Price[driverid]);
					SendClientMessage(i, 0xFFD700FF, msgP);
				}
			}
			else
			{
				BusJob_WasPassenger[i] = false;
			}
		}
		else
		{
			BusJob_WasPassenger[i] = false;
		}

		// ---- Водитель: посадка за руль и прохождение меток маршрута ----
		if(BusJob_Working[i] && BusJob_Vehicle[i] != INVALID_VEHICLE_ID)
		{
			if(GetPlayerVehicleID(i) == BusJob_Vehicle[i] && GetPlayerVehicleSeat(i) == 0)
			{
				if(!BusJob_Boarded[i])
				{
					BusJob_OnBoarded(i);
				}
				else if(!BusJob_Frozen[i])
				{
					new Float:px, Float:py, Float:pz;
					GetPlayerPos(i, px, py, pz);

					new idx = BusJob_CPIndex[i];
					new Float:cpdist = VectorSize(px - BUS_SPAWN_POINTS[idx][0], py - BUS_SPAWN_POINTS[idx][1], pz - BUS_SPAWN_POINTS[idx][2]);

					if(cpdist <= BUS_CP_RADIUS)
					{
						BusJob_OnCheckpointReached(i);
					}
				}
			}
		}
	}
	return 1;
}

//====================МЕНЮ У НПС====================//
stock BusJob_ShowMenu(playerid)
{
	new list[128];
	format(list, sizeof(list), "%s\n%s\nСтатистика",
		BusJob_Employed[playerid] ? ("Уволиться") : ("Устроиться"),
		BusJob_Working[playerid] ? ("Закончить рабочий день") : ("Начать рабочий день"));

	ShowPlayerDialog(playerid, DLG_BUS_MENU, DIALOG_STYLE_LIST, "{FFD700}Валера | Автобусник", list, "Выбрать", "Закрыть");
	return 1;
}

//====================ОБРАБОТКА ДИАЛОГОВ====================//
stock BusJob_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DLG_BUS_STATS)
	{
		return 1; // информационное окно, действий не требуется
	}

	if(dialogid == DLG_BUS_MENU)
	{
		if(!response) return 1;

		switch(listitem)
		{
			case 0: // Устроиться / Уволиться
			{
				if(BusJob_Working[playerid])
				{
					SendClientMessage(playerid, 0xFF3030FF, "Сначала закончите рабочий день!");
				}
				else
				{
					BusJob_Employed[playerid] = !BusJob_Employed[playerid];
					SendClientMessage(playerid, 0xFFD700FF, BusJob_Employed[playerid] ?
						("Вы устроились на работу автобусника!") : ("Вы уволились с работы автобусника."));

					new bname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, bname, sizeof(bname));

					new bq[160];
					mysql_format(BusJob_DB, bq, sizeof(bq),
						"INSERT INTO `"BUS_TABLE"` (`name`,`employed`) VALUES ('%e',%d) ON DUPLICATE KEY UPDATE `employed`=%d",
						bname, BusJob_Employed[playerid], BusJob_Employed[playerid]);
					mysql_tquery(BusJob_DB, bq);
				}
			}
			case 1: // Начать / Закончить рабочий день
			{
				if(!BusJob_Employed[playerid])
				{
					SendClientMessage(playerid, 0xFF3030FF, "Сначала устройтесь на работу!");
				}
				else if(BusJob_Working[playerid])
				{
					BusJob_EndWorkday(playerid);
					SendClientMessage(playerid, 0xFFD700FF, "Рабочий день окончен.");
				}
				else
				{
					BusJob_StartWorkday(playerid);
				}
			}
			case 2: // Статистика
			{
				BusJob_ShowStats(playerid);
			}
		}
		return 1;
	}

	if(dialogid == DLG_BUS_PRICE)
	{
		if(!response || !BusJob_Working[playerid] || BusJob_Vehicle[playerid] == INVALID_VEHICLE_ID)
		{
			SendClientMessage(playerid, 0xFF3030FF, "Вы отменили ввод цены, автобус исчез.");
			BusJob_EndWorkday(playerid);
			return 1;
		}

		if(!BusJob_IsNumeric(inputtext) || strval(inputtext) < BUS_MIN_PRICE || strval(inputtext) > BUS_MAX_PRICE)
		{
			new msg[128];
			format(msg, sizeof(msg), "Введите корректную цену числом от %d до %d рублей:", BUS_MIN_PRICE, BUS_MAX_PRICE);
			ShowPlayerDialog(playerid, DLG_BUS_PRICE, DIALOG_STYLE_INPUT, "{FFD700}Стоимость проезда", msg, "Продолжить", "Отмена");
			return 1;
		}

		BusJob_Price[playerid] = strval(inputtext);

		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));

		new label[160];
		format(label, sizeof(label), "{FFFFFF}Автобус:\n{FFD700}"BUS_ROUTE_FROM" - "BUS_ROUTE_TO"\n{FFFFFF}Цена за пассажира: {4CAF50}%d рублей\n{FFFFFF}Водитель: {00BFFF}%s",
			BusJob_Price[playerid], name);

		BusJob_Label[playerid] = Create3DTextLabel(label, 0xFFFFFFFF, 0.0, 0.0, 0.0, 20.0, -1, 0);
		Attach3DTextLabelToVehicle(Text3D:BusJob_Label[playerid], BusJob_Vehicle[playerid], 0.0, 0.0, 2.2);

		new msg2[128];
		format(msg2, sizeof(msg2), "Автобус подан! У вас есть %d секунд, чтобы сесть за руль.", BUS_WAIT_TIME);
		SendClientMessage(playerid, 0xFFD700FF, msg2);
		return 1;
	}

	return 0;
}

stock bool:BusJob_IsNumeric(const str[])
{
	if(str[0] == '\0') return false;
	for(new i; str[i] != '\0'; i++)
	{
		if(str[i] < '0' || str[i] > '9') return false;
	}
	return true;
}

//====================НАЧАТЬ / ЗАКОНЧИТЬ РАБОЧИЙ ДЕНЬ====================//
stock BusJob_StartWorkday(playerid)
{
	new spawnIdx = random(sizeof(BUS_PARK_POINTS));

	BusJob_Vehicle[playerid] = CreateVehicle(BUS_VEHICLE_MODEL,
		BUS_PARK_POINTS[spawnIdx][0], BUS_PARK_POINTS[spawnIdx][1], BUS_PARK_POINTS[spawnIdx][2], BUS_PARK_POINTS[spawnIdx][3],
		BUS_VEHICLE_COLOR1, BUS_VEHICLE_COLOR2, -1);

	BusJob_Working[playerid] = true;
	BusJob_Boarded[playerid] = false;
	BusJob_Frozen[playerid] = false;
	BusJob_CPIndex[playerid] = 0;
	BusJob_Earned[playerid] = 0;
	BusJob_Price[playerid] = 0;

	BusJob_Timer[playerid] = SetTimerEx("BusJob_TimeUp", BUS_WAIT_TIME * 1000, false, "i", playerid);

	new msg[96];
	format(msg, sizeof(msg), "Укажите цену за проезд (от %d до %d рублей):", BUS_MIN_PRICE, BUS_MAX_PRICE);
	ShowPlayerDialog(playerid, DLG_BUS_PRICE, DIALOG_STYLE_INPUT, "{FFD700}Стоимость проезда", msg, "Продолжить", "Отмена");
	return 1;
}

forward BusJob_TimeUp(playerid);
public BusJob_TimeUp(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	BusJob_Timer[playerid] = 0;

	if(BusJob_Working[playerid] && !BusJob_Boarded[playerid])
	{
		SendClientMessage(playerid, 0xFF3030FF, "Вы не успели сесть в автобус — рабочий день окончен.");
		BusJob_EndWorkday(playerid);
	}
	return 1;
}

stock BusJob_OnBoarded(playerid)
{
	BusJob_Boarded[playerid] = true;

	GameTextForPlayer(playerid, "~w~Автор системы: ~y~@nexus_gei", 3000, 3);

	if(BusJob_Timer[playerid] != 0)
	{
		KillTimer(BusJob_Timer[playerid]);
		BusJob_Timer[playerid] = 0;
	}

	BusJob_CPIndex[playerid] = 0;
	BusJob_Earned[playerid] = 0;
	BusJob_Frozen[playerid] = false;

	if(BusJob_MapIcon[playerid] != -1)
	{
		RemovePlayerMapIcon(playerid, BusJob_MapIcon[playerid]);
	}
	BusJob_MapIcon[playerid] = 40;
	SetPlayerMapIcon(playerid, BusJob_MapIcon[playerid], BUS_SPAWN_POINTS[0][0], BUS_SPAWN_POINTS[0][1], BUS_SPAWN_POINTS[0][2], 32, 0xFFD700FF, MAPICON_LOCAL);

	BusJob_UpdateRoute(playerid, BUS_SPAWN_POINTS[0][0], BUS_SPAWN_POINTS[0][1], BUS_SPAWN_POINTS[0][2]);

	new msg[144];
	format(msg, sizeof(msg), "Вы сели за руль! Следуйте по навигатору — впереди %d остановок.", sizeof(BUS_SPAWN_POINTS));
	SendClientMessage(playerid, 0x4CAF50FF, msg);
	return 1;
}


stock BusJob_OnCheckpointReached(playerid)
{
	new idx = BusJob_CPIndex[playerid];
	new total = sizeof(BUS_SPAWN_POINTS);

	if(idx >= total - 1)
	{
		//====================ФИНАЛЬНАЯ МЕТКА====================//
		BusJob_Frozen[playerid] = true;
		DisablePlayerCheckpoint(playerid);

		BusJob_Earned[playerid] += BUS_FINAL_BONUS;
		GivePlayerMoneyEx(playerid, BUS_FINAL_BONUS, "Автобус: финальный рейс", false, true);

		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));

		new query[220];
		mysql_format(BusJob_DB, query, sizeof(query),
			"INSERT INTO `"BUS_TABLE"` (`name`,`trips`,`earned`) VALUES ('%e',1,%d) ON DUPLICATE KEY UPDATE `trips`=`trips`+1, `earned`=`earned`+%d",
			name, BusJob_Earned[playerid], BusJob_Earned[playerid]);
		mysql_tquery(BusJob_DB, query);

		GameTextForPlayer(playerid, "~g~Маршрут завершён!~n~~w~+1 000 000$", 5000, 3);

		new msg[144];
		format(msg, sizeof(msg), "Маршрут полностью пройден! Итого за рейс начислено %d рублей.", BusJob_Earned[playerid]);
		SendClientMessage(playerid, 0x4CAF50FF, msg);

		BusJob_EndWorkday(playerid); // автобус исчезает
		return 1;
	}

	//====================ОБЫЧНАЯ ОСТАНОВКА====================//
	BusJob_Frozen[playerid] = true;
	TogglePlayerControllable(playerid, false);
	DisablePlayerCheckpoint(playerid);

	BusJob_Earned[playerid] += BUS_STOP_BONUS;
	GivePlayerMoneyEx(playerid, BUS_STOP_BONUS, "Автобус: остановка", false, true);

	new msgText[144];
	format(msgText, sizeof(msgText), "~y~Автобус приехал на остановку %d/%d~n~~w~Ожидание: 5 сек.", idx + 1, total);
	GameTextForPlayer(playerid, msgText, 5000, 3);

	new msgChat[144];
	format(msgChat, sizeof(msgChat), "Остановка %d/%d! Начислено %d рублей. Ожидание 5 секунд...", idx + 1, total, BUS_STOP_BONUS);
	SendClientMessage(playerid, 0xFFD700FF, msgChat);

	SetTimerEx("BusJob_Unfreeze", BUS_STOP_FREEZE_TIME, false, "i", playerid);
	return 1;
}

// Разморозка после 5 секунд ожидания на остановке + переход к следующей метке.
forward BusJob_Unfreeze(playerid);
public BusJob_Unfreeze(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!BusJob_Working[playerid] || !BusJob_Boarded[playerid]) return 0;

	TogglePlayerControllable(playerid, true);
	BusJob_Frozen[playerid] = false;
	BusJob_CPIndex[playerid]++;

	new idx = BusJob_CPIndex[playerid];

	if(BusJob_MapIcon[playerid] != -1)
	{
		RemovePlayerMapIcon(playerid, BusJob_MapIcon[playerid]);
	}
	BusJob_MapIcon[playerid] = 40;
	SetPlayerMapIcon(playerid, BusJob_MapIcon[playerid], BUS_SPAWN_POINTS[idx][0], BUS_SPAWN_POINTS[idx][1], BUS_SPAWN_POINTS[idx][2], 32, 0xFFD700FF, MAPICON_LOCAL);

	BusJob_UpdateRoute(playerid, BUS_SPAWN_POINTS[idx][0], BUS_SPAWN_POINTS[idx][1], BUS_SPAWN_POINTS[idx][2]);

	SendClientMessage(playerid, 0x4CAF50FF, "Автобус поехал дальше — следуйте по навигатору к следующей остановке!");
	return 1;
}

stock BusJob_EndWorkday(playerid)
{
	if(BusJob_Timer[playerid] != 0)
	{
		KillTimer(BusJob_Timer[playerid]);
		BusJob_Timer[playerid] = 0;
	}

	if(BusJob_Label[playerid] != -1)
	{
		Delete3DTextLabel(Text3D:BusJob_Label[playerid]);
		BusJob_Label[playerid] = -1;
	}

	if(BusJob_MapIcon[playerid] != -1)
	{
		RemovePlayerMapIcon(playerid, BusJob_MapIcon[playerid]);
		BusJob_MapIcon[playerid] = -1;
	}

	BusJob_ClearRoute(playerid);

	if(BusJob_Vehicle[playerid] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(BusJob_Vehicle[playerid]);
		BusJob_Vehicle[playerid] = INVALID_VEHICLE_ID;
	}

	if(BusJob_Frozen[playerid])
	{
		TogglePlayerControllable(playerid, true);
	}

	DisablePlayerCheckpoint(playerid);

	BusJob_Working[playerid] = false;
	BusJob_Boarded[playerid] = false;
	BusJob_Frozen[playerid] = false;
	BusJob_CPIndex[playerid] = 0;
	BusJob_Earned[playerid] = 0;
	return 1;
}

//====================СТАТИСТИКА====================//
stock BusJob_ShowStats(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

	new query[160];
	mysql_format(BusJob_DB, query, sizeof(query), "SELECT `trips`,`earned` FROM `"BUS_TABLE"` WHERE `name` = '%e' LIMIT 1", name);
	mysql_tquery(BusJob_DB, query, "BusJob_StatsCB", "i", playerid);
	return 1;
}

forward BusJob_StatsCB(playerid);
public BusJob_StatsCB(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new trips = 0, earned = 0;
	if(cache_num_rows())
	{
		trips = cache_get_field_content_int(0, "trips");
		earned = cache_get_field_content_int(0, "earned");
	}

	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

	new msg[256];
	format(msg, sizeof(msg), "{FFD700}Ваш ник: {FFFFFF}%s\n{FFD700}Поездок за всё время: {FFFFFF}%d\n{FFD700}Заработано за всё время: {FFFFFF}%d руб.",
		name, trips, earned);
	ShowPlayerDialog(playerid, DLG_BUS_STATS, DIALOG_STYLE_MSGBOX, "{FFD700}Статистика автобусника", msg, "Ок", "");
	return 1;
}