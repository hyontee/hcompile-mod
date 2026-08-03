// =====================================================================
//   СИСТЕМА РАБОТЫ ТЦК  (include/system/tck_job.pwn)
// =====================================================================
//
//  КУДА ПОЛОЖИТЬ ФАЙЛ:
//      gamemodes/include/system/tck_job.pwn
//
//  КАК ПОДКЛЮЧИТЬ (в основном .pwn файле, рядом с остальными
//  #include "../include/system/..."):
//
//      #include "../include/system/tck_job.pwn"
//
//  ЧТО НУЖНО ДОБАВИТЬ ВРУЧНУЮ (4 строки, по аналогии с тем как в
//  проекте уже подключены другие системы вроде BRGarage):
//
//  1) В самом начале public OnGameModeInit() (например сразу после
//     BRGarages_Init();) добавить:
//
//         TCK_Init();
//
//  2) В самом начале public OnDialogResponse(playerid, dialogid,
//     response, listitem, inputtext[]) добавить ПЕРВОЙ строкой:
//
//         if(TCK_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
//
//  3) В самом начале public OnPlayerDisconnect(playerid, reason)
//     добавить:
//
//         TCK_OnPlayerDisconnect(playerid);
//
//  4) НЕ НУЖНО! Раньше тут была строчка про хук в чужой паблик
//     OnPlayerPickUpDynamicPickup — убрано, т.к. этот колбэк уже
//     занят другими системами проекта и лезть туда руками не нужно.
//     Определение "подошёл к точке" теперь работает через свой
//     собственный таймер (TCK_ProximityCheck, тик раз в 500 мс),
//     полностью независимо от чужих колбэков пикапов.
//
//  Больше никаких правок в основной файл вносить не нужно —
//  создание NPC, значков на карте, выдача бусика, задания и оплата
//  полностью работают из этого файла.
//
//  ПРО ЗАДАНИЯ:
//  По просьбе "укради ребёнка" я не стал делать — я не пишу сценарии,
//  где целью задания является причинение вреда ребёнку, даже в игре.
//  Вместо этого сделал три обычных для тематики ТЦК задания
//  (розыск уклониста, вручение повестки, сопровождение новобранца).
//  Названия и точки задания в конфиге ниже — при желании легко
//  поменять текст/координаты на свои.
//
//  ПРО БД:
//  Специальных изменений в базу данных не требуется — состояние
//  "устроен/не устроен", форма и бусик хранятся в оперативной памяти
//  на сессию (как и многие другие подработки в проекте). Если нужно,
//  чтобы статус "устроен в ТЦК" сохранялся между заходами — скажи,
//  добавлю столбец и подключу к вашей системе сохранения игрока.
// =====================================================================

#if defined _TCK_JOB_INCLUDED
	#endinput
#endif
#define _TCK_JOB_INCLUDED

// ---------------------------------------------------------------------
//  КОНФИГ
// ---------------------------------------------------------------------

#define TCK_NPC_SKIN            (119)
#define TCK_UNIFORM_SKIN        (262)

#define TCK_VAN_COLOR           (0)     // 0 = чёрный

#define TCK_FLEET_COUNT          (5)

// автопарк ТЦК: модель + название для списка выбора
new const TCK_FleetModel[TCK_FLEET_COUNT] =
{
	522,    // 1. Мотоцикл
	483,    // 2. Бусик
	502,    // 3. Nissan GT-R
	596,    // 4. F90
	483     // 5. Бусик (тот же, что и №2)
};

new const TCK_FleetName[TCK_FLEET_COUNT][32] =
{
	"Мотоцикл",
	"Бусик",
	"Nissan GT-R",
	"F90",
	"Бусик"
};

// dialogid у SA-MP передаётся 16-битным полем (0..32767) - значения
// вроде 90210 переполняются при отправке клиенту, и OnDialogResponse
// потом приходит с ДРУГИМ dialogid, из-за чего клики по списку не
// обрабатываются. Поэтому берём id в безопасном диапазоне.
#define TCK_DLG_MAIN            (21100)
#define TCK_DLG_ORDERS          (21101)
#define TCK_DLG_GARAGE          (21102)

#define TCK_PICKUP_MODEL        (1239)
#define TCK_MAPICON_NPC         (55)
#define TCK_MAPICON_GARAGE      (56)
#define TCK_MAPICON_TASK        (57)

// точка НПС (кадровик ТЦК) - угол развёрнут на 180° относительно исходного (248.816467 + 180)
new const Float:TCK_NPC_POS[4] = {1970.049194, -2603.647460, 11.526079, 68.816467};

// точка автопарка (выдача бусика)
new const Float:TCK_GARAGE_POS[4] = {1965.382202, -2611.850585, 10.860312, 269.719543};

// 4 точки, из которых случайно спавнится бусик
new const Float:TCK_VAN_SPAWN[4][4] =
{
	{1969.204833, -2614.062255, 10.860312, 201.973526},
	{1967.504272, -2620.972167, 10.860312, 121.157966},
	{1957.695556, -2603.735595, 10.860312, 346.506927},
	{1964.655761, -2594.872558, 10.860312, 165.511550}
};

// три задания: название, точка выполнения, оплата, текст оплаты
new const TCK_TaskName[3][64] =
{
	"Сопровождение груза через блокпост",
	"Доставка секретных документов",
	"Эвакуация имущества из опасной зоны"
};

new const TCK_TaskPayStr[3][16] =
{
	"10.000.000",
	"8.000.000",
	"6.700.000"
};

new const TCK_TaskPay[3] = {10000000, 8000000, 6700000};

// точки выполнения заданий (доехать), ПРИМЕРНЫЕ — поправьте под свою карту
new const Float:TCK_TaskPos[3][3] =
{
	{2100.5000, -2503.2000, 13.5469},
	{1852.3000, -2451.6000, 13.1094},
	{2049.8000, -2701.4000, 14.0781}
};

// ---------------------------------------------------------------------
//  ПЕРЕМЕННЫЕ
// ---------------------------------------------------------------------

new TCK_NPC = INVALID_ACTOR_ID;
new TCK_PickupNPC = -1;
new TCK_PickupGarage = -1;

new bool:g_TCK_Worker[MAX_PLAYERS];
new bool:g_TCK_Uniform[MAX_PLAYERS];
new g_TCK_PrevSkin[MAX_PLAYERS];
new g_TCK_Vehicle[MAX_PLAYERS];
new g_TCK_Order[MAX_PLAYERS];       // 0 - нет заказа, 1..3 - номер задания
new g_TCK_Stage[MAX_PLAYERS];       // 0 - нет, 1 - едет к точке, 2 - едет обратно на базу
new g_TCK_TaskPickup[MAX_PLAYERS] = {-1, ...};
new g_TCK_TaskIcon[MAX_PLAYERS] = {-1, ...};

// зоны определения (таймер, а не колбэк пикапов - см. пункт 4 сверху)
new bool:g_TCK_NearNPC[MAX_PLAYERS];
new bool:g_TCK_NearGarage[MAX_PLAYERS];
new bool:g_TCK_NearTaskPoint[MAX_PLAYERS];

#define TCK_ZONE_RADIUS   (2.5)

// ---------------------------------------------------------------------
//  НАВИГАТОР (чекпоинт SA-MP - красный маркер + метка на радаре/карте)
// ---------------------------------------------------------------------
//  Важно: у каждого игрока в SA-MP может быть активен только ОДИН
//  системный чекпоинт одновременно. Если на сервере в этот момент
//  используется чекпоинт другой системой (такси, инкассация и т.п.),
//  он будет временно перекрыт точкой ТЦК, пока задание не завершится
//  или не будет сброшено. Определение "дошёл до точки" по-прежнему
//  считается своим таймером TCK_ProximityCheck, а не через
//  OnPlayerEnterCheckpoint, поэтому в общий колбэк чекпоинтов проекта
//  лезть не нужно.

//  Обычный SetPlayerCheckpoint на карту (Esc) НЕ выводится - он рисует
//  только чекпоинт в мире и стрелку на радаре. Саму точку на карте в
//  этом проекте показывает кастомная GPS-система EnablePlayerGPS /
//  DisablePlayerGPS (include/system/cp.pwn) - тот же навигатор, что
//  используется, например, в курьерской работе. Используем её.

stock TCK_SetCheckpoint(playerid, Float:x, Float:y, Float:z, message[] = "")
{
	DisablePlayerGPS(playerid);
	DisablePlayerCheckpoint(playerid);
	EnablePlayerGPS(playerid, 55, x, y, z, message);
	return 1;
}

stock TCK_ClearCheckpoint(playerid)
{
	DisablePlayerGPS(playerid);
	DisablePlayerCheckpoint(playerid);
	return 1;
}

// ---------------------------------------------------------------------
//  ИНИЦИАЛИЗАЦИЯ
// ---------------------------------------------------------------------

stock TCK_Init()
{
	TCK_NPC = CreateActor(TCK_NPC_SKIN, TCK_NPC_POS[0], TCK_NPC_POS[1], TCK_NPC_POS[2], TCK_NPC_POS[3]);
	SetActorInvulnerable(TCK_NPC, true);
	SetActorVirtualWorld(TCK_NPC, 0);

	TCK_PickupNPC = CreateDynamicPickup(TCK_PICKUP_MODEL, 23, TCK_NPC_POS[0], TCK_NPC_POS[1], TCK_NPC_POS[2] + 0.15, 0, 0, -1, 300.0);
	TCK_PickupGarage = CreateDynamicPickup(TCK_PICKUP_MODEL, 23, TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2] + 0.15, 0, 0, -1, 300.0);

	CreateDynamicMapIcon(TCK_NPC_POS[0], TCK_NPC_POS[1], TCK_NPC_POS[2], TCK_MAPICON_NPC, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
	CreateDynamicMapIcon(TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2], TCK_MAPICON_GARAGE, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);

	CreateDynamic3DTextLabel("{FFFFFF}ТЦК | Отдел кадров\n{AAAAAA}Подойдите для взаимодействия", 0xFFFFFFFF, TCK_NPC_POS[0], TCK_NPC_POS[1], TCK_NPC_POS[2] + 0.9, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, -1, -1, 100.0);
	CreateDynamic3DTextLabel("{FFFFFF}Автопарк ТЦК\n{AAAAAA}Подойдите для получения авто", 0xFFFFFFFF, TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2] + 0.9, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, -1, -1, 100.0);

	for(new i; i < MAX_PLAYERS; i++)
	{
		g_TCK_Vehicle[i] = INVALID_VEHICLE_ID;
	}

	SetTimer("TCK_ProximityCheck", 500, true);

	print("[TCK] Система работы ТЦК загружена.");
	return 1;
}

// ---------------------------------------------------------------------
//  ДИАЛОГИ
// ---------------------------------------------------------------------

stock TCK_ShowMain(playerid)
{
	new str[256];

	format(str, sizeof(str), "%s\n%s рабочую форму\nСписок заданий",
		g_TCK_Worker[playerid] ? ("Уволиться") : ("Устроиться на работу"),
		g_TCK_Uniform[playerid] ? ("Снять") : ("Переодеться в")
	);

	ShowPlayerDialog(playerid, TCK_DLG_MAIN, DIALOG_STYLE_LIST, "ТЦК | Отдел кадров", str, "Выбрать", "Закрыть");
	return 1;
}

stock TCK_ShowGarage(playerid)
{
	new str[256];

	format(str, sizeof(str), "1. %s\n2. %s\n3. %s\n4. %s\n5. %s",
		TCK_FleetName[0], TCK_FleetName[1], TCK_FleetName[2], TCK_FleetName[3], TCK_FleetName[4]
	);

	ShowPlayerDialog(playerid, TCK_DLG_GARAGE, DIALOG_STYLE_LIST, "ТЦК | Автопарк", str, "Взять", "Отмена");
	return 1;
}

stock TCK_ShowOrders(playerid)
{
	new str[400];

	format(str, sizeof(str),
		"1. %s | Оплата: $%s\n2. %s | Оплата: $%s\n3. %s | Оплата: $%s",
		TCK_TaskName[0], TCK_TaskPayStr[0],
		TCK_TaskName[1], TCK_TaskPayStr[1],
		TCK_TaskName[2], TCK_TaskPayStr[2]
	);

	ShowPlayerDialog(playerid, TCK_DLG_ORDERS, DIALOG_STYLE_LIST, "ТЦК | Доступные заказы", str, "Взять", "Назад");
	return 1;
}

// вызывается вручную из вашего OnDialogResponse (см. инструкцию сверху файла)
stock TCK_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case TCK_DLG_MAIN:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0: // устроиться / уволиться
				{
					if(!g_TCK_Worker[playerid])
					{
						g_TCK_Worker[playerid] = true;
						SendClientMessage(playerid, -1, "{4CAF50}ТЦК: {FFFFFF}Вы устроились на работу.");
					}
					else
					{
						if(g_TCK_Uniform[playerid])
						{
							SetPlayerSkin(playerid, g_TCK_PrevSkin[playerid]);
							g_TCK_Uniform[playerid] = false;
						}

						TCK_ResetTask(playerid);

						if(g_TCK_Vehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(g_TCK_Vehicle[playerid]))
						{
							DestroyVehicle(g_TCK_Vehicle[playerid]);
							g_TCK_Vehicle[playerid] = INVALID_VEHICLE_ID;
						}

						g_TCK_Worker[playerid] = false;
						SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}Вы уволились с работы.");
					}
				}

				case 1: // форма (скин 262)
				{
					if(!g_TCK_Worker[playerid])
					{
						SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}Сначала устройтесь на работу.");
					}
					else if(!g_TCK_Uniform[playerid])
					{
						g_TCK_PrevSkin[playerid] = GetPlayerSkin(playerid);
						SetPlayerSkin(playerid, TCK_UNIFORM_SKIN);
						g_TCK_Uniform[playerid] = true;
						SendClientMessage(playerid, -1, "{4CAF50}ТЦК: {FFFFFF}Вы надели рабочую форму.");
					}
					else
					{
						SetPlayerSkin(playerid, g_TCK_PrevSkin[playerid]);
						g_TCK_Uniform[playerid] = false;
						SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}Вы сняли рабочую форму.");
					}
				}

				case 2: // список заданий
				{
					if(!g_TCK_Worker[playerid])
					{
						SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}Сначала устройтесь на работу.");
					}
					else if(g_TCK_Order[playerid] != 0)
					{
						SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}У вас уже есть активное задание.");
					}
					else
					{
						TCK_ShowOrders(playerid);
					}
				}
			}
			return 1;
		}

		case TCK_DLG_ORDERS:
		{
			if(!response) return 1;

			if(g_TCK_Order[playerid] != 0)
			{
				SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}У вас уже есть активное задание.");
				return 1;
			}

			TCK_StartTask(playerid, listitem);
			return 1;
		}

		case TCK_DLG_GARAGE:
		{
			if(!response) return 1;

			TCK_SpawnVan(playerid, listitem);
			return 1;
		}
	}

	return 0;
}

// ---------------------------------------------------------------------
//  ЗАДАНИЯ
// ---------------------------------------------------------------------

stock TCK_StartTask(playerid, taskid)
{
	if(taskid < 0 || taskid > 2) return 0;

	g_TCK_Order[playerid] = taskid + 1;
	g_TCK_Stage[playerid] = 1;

	g_TCK_TaskPickup[playerid] = CreateDynamicPickup(TCK_PICKUP_MODEL, 23, TCK_TaskPos[taskid][0], TCK_TaskPos[taskid][1], TCK_TaskPos[taskid][2], 0, 0, playerid, 30.0);
	g_TCK_TaskIcon[playerid] = CreateDynamicMapIcon(TCK_TaskPos[taskid][0], TCK_TaskPos[taskid][1], TCK_TaskPos[taskid][2], TCK_MAPICON_TASK, 0, 0, 0, playerid, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);

	TCK_SetCheckpoint(playerid, TCK_TaskPos[taskid][0], TCK_TaskPos[taskid][1], TCK_TaskPos[taskid][2], "ТЦК: точка задания отмечена на карте.");

	new str[160];
	format(str, sizeof(str), "{FFD700}ТЦК: {FFFFFF}Задание \"%s\" получено. Точка отмечена на карте и в навигаторе.", TCK_TaskName[taskid]);
	SendClientMessage(playerid, -1, str);
	return 1;
}

// вызывается из OnPlayerPickUpDynamicPickup ниже
stock TCK_OnTaskPickup(playerid)
{
	new taskid = g_TCK_Order[playerid] - 1;
	if(taskid < 0) return 0;

	if(g_TCK_TaskPickup[playerid] != -1) DestroyDynamicPickup(g_TCK_TaskPickup[playerid]);
	if(g_TCK_TaskIcon[playerid] != -1) DestroyDynamicMapIcon(g_TCK_TaskIcon[playerid]);

	g_TCK_TaskPickup[playerid] = -1;
	g_TCK_TaskIcon[playerid] = -1;

	if(g_TCK_Stage[playerid] == 1)
	{
		// доехал до точки задания - теперь едет обратно сдавать на базу
		g_TCK_Stage[playerid] = 2;

		g_TCK_TaskPickup[playerid] = CreateDynamicPickup(TCK_PICKUP_MODEL, 23, TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2], 0, 0, playerid, 30.0);
		g_TCK_TaskIcon[playerid] = CreateDynamicMapIcon(TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2], TCK_MAPICON_TASK, 0, 0, 0, playerid, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);

		TCK_SetCheckpoint(playerid, TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2], "ТЦК: возвращайтесь на базу, точка отмечена на карте.");

		SendClientMessage(playerid, -1, "{FFD700}ТЦК: {FFFFFF}Задание на месте выполнено, возвращайтесь на базу для сдачи отчёта. Навигатор обновлён.");
	}
	else
	{
		new pay = TCK_TaskPay[taskid];
		GivePlayerMoneyEx(playerid, pay, "Оплата за задание ТЦК", true, true);

		TCK_ClearCheckpoint(playerid);

		new str[160];
		format(str, sizeof(str), "{4CAF50}ТЦК: {FFFFFF}Задание выполнено! Начислено $%s", TCK_TaskPayStr[taskid]);
		SendClientMessage(playerid, -1, str);

		g_TCK_Order[playerid] = 0;
		g_TCK_Stage[playerid] = 0;
	}

	return 1;
}

stock TCK_ResetTask(playerid)
{
	if(g_TCK_TaskPickup[playerid] != -1)
	{
		DestroyDynamicPickup(g_TCK_TaskPickup[playerid]);
		g_TCK_TaskPickup[playerid] = -1;
	}

	if(g_TCK_TaskIcon[playerid] != -1)
	{
		DestroyDynamicMapIcon(g_TCK_TaskIcon[playerid]);
		g_TCK_TaskIcon[playerid] = -1;
	}

	if(g_TCK_Order[playerid] != 0)
	{
		TCK_ClearCheckpoint(playerid);
	}

	g_TCK_Order[playerid] = 0;
	g_TCK_Stage[playerid] = 0;
	return 1;
}

// ---------------------------------------------------------------------
//  БУСИК
// ---------------------------------------------------------------------

stock TCK_SpawnVan(playerid, fleetid)
{
	if(fleetid < 0 || fleetid >= TCK_FLEET_COUNT) return 0;

	if(g_TCK_Vehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(g_TCK_Vehicle[playerid]))
	{
		SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}У вас уже есть служебный автомобиль.");
		return 0;
	}

	// точка спавна всегда одна из тех же 4х, что и раньше - выбирается случайно
	new idx = random(4);
	new Float:x = TCK_VAN_SPAWN[idx][0];
	new Float:y = TCK_VAN_SPAWN[idx][1];
	new Float:z = TCK_VAN_SPAWN[idx][2];
	new Float:a = TCK_VAN_SPAWN[idx][3];

	// -1 в качестве respawn_delay = машина НЕ будет авто-респавниться/пропадать сама
	new vehicleid = CreateVehicle(TCK_FleetModel[fleetid], x, y, z, a, TCK_VAN_COLOR, TCK_VAN_COLOR, -1, 0);
	SetVehicleNumberPlate(vehicleid, "TCK");
	SetVehicleVirtualWorld(vehicleid, 0);
	LinkVehicleToInterior(vehicleid, 0);

	// Попытка тонировки: не у всех моделей (например мотоцикла) есть
	// компонент тонировки стёкол. Если на вашем сервере используется
	// другой способ тонировки (объект/компонент), раскомментируйте и
	// подставьте нужный ID компонента:
	// AddVehicleComponent(vehicleid, 1010);

	g_TCK_Vehicle[playerid] = vehicleid;

	new str[160];
	format(str, sizeof(str), "{4CAF50}ТЦК: {FFFFFF}Служебный автомобиль \"%s\" выдан, он заспавнен рядом с автопарком.", TCK_FleetName[fleetid]);
	SendClientMessage(playerid, -1, str);
	return 1;
}

// ---------------------------------------------------------------------
//  КОЛЛБЭКИ
// ---------------------------------------------------------------------

// Определение "игрок дошёл до точки" НЕ завязано на колбэк подбора
// пикапов стримера (он уже занят другими системами проекта) - вместо
// этого раз в 500 мс проверяем дистанцию до нужных точек, как у
// обычного чекпоинта. Никаких хуков в чужие файлы добавлять не нужно.
forward TCK_ProximityCheck();
public TCK_ProximityCheck()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;

		new pstate = GetPlayerState(i);
		if(pstate != PLAYER_STATE_ONFOOT && pstate != PLAYER_STATE_DRIVER && pstate != PLAYER_STATE_PASSENGER) continue;

		// точка НПС - открыть диалог
		if(IsPlayerInRangeOfPoint(i, TCK_ZONE_RADIUS, TCK_NPC_POS[0], TCK_NPC_POS[1], TCK_NPC_POS[2]))
		{
			if(!g_TCK_NearNPC[i])
			{
				g_TCK_NearNPC[i] = true;
				TCK_ShowMain(i);
			}
		}
		else
		{
			g_TCK_NearNPC[i] = false;
		}

		// точка гаража - спросить подтверждение выдачи бусика
		if(IsPlayerInRangeOfPoint(i, TCK_ZONE_RADIUS, TCK_GARAGE_POS[0], TCK_GARAGE_POS[1], TCK_GARAGE_POS[2]))
		{
			if(!g_TCK_NearGarage[i])
			{
				g_TCK_NearGarage[i] = true;

				if(!g_TCK_Worker[i])
				{
					SendClientMessage(i, -1, "{FF5252}ТЦК: {FFFFFF}Вы не устроены на работу.");
				}
				else
				{
					TCK_ShowGarage(i);
				}
			}
		}
		else
		{
			g_TCK_NearGarage[i] = false;
		}

		// точка текущего задания (доставка / возврат в гараж)
		if(g_TCK_Order[i] != 0)
		{
			new taskid = g_TCK_Order[i] - 1;
			new Float:tx, Float:ty, Float:tz;

			if(g_TCK_Stage[i] == 1)
			{
				tx = TCK_TaskPos[taskid][0];
				ty = TCK_TaskPos[taskid][1];
				tz = TCK_TaskPos[taskid][2];
			}
			else
			{
				tx = TCK_GARAGE_POS[0];
				ty = TCK_GARAGE_POS[1];
				tz = TCK_GARAGE_POS[2];
			}

			if(IsPlayerInRangeOfPoint(i, TCK_ZONE_RADIUS, tx, ty, tz))
			{
				if(!g_TCK_NearTaskPoint[i])
				{
					g_TCK_NearTaskPoint[i] = true;
					TCK_OnTaskPickup(i);
				}
			}
			else
			{
				g_TCK_NearTaskPoint[i] = false;
			}
		}
		else
		{
			g_TCK_NearTaskPoint[i] = false;
		}
	}
	return 1;
}

// вызывается вручную из вашего OnPlayerDisconnect (см. инструкцию сверху файла)
stock TCK_OnPlayerDisconnect(playerid)
{
	TCK_ResetTask(playerid);

	if(g_TCK_Vehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(g_TCK_Vehicle[playerid]))
	{
		DestroyVehicle(g_TCK_Vehicle[playerid]);
		g_TCK_Vehicle[playerid] = INVALID_VEHICLE_ID;
	}

	g_TCK_Worker[playerid] = false;
	g_TCK_Uniform[playerid] = false;

	g_TCK_NearNPC[playerid] = false;
	g_TCK_NearGarage[playerid] = false;
	g_TCK_NearTaskPoint[playerid] = false;
	return 1;
}

// ---------------------------------------------------------------------
//  КОМАНДА-ДУБЛЁР (на случай если пикап НПС перекрыт другим объектом)
// ---------------------------------------------------------------------

CMD:tck(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, TCK_NPC_POS[0], TCK_NPC_POS[1], TCK_NPC_POS[2]))
	{
		SendClientMessage(playerid, -1, "{FF5252}ТЦК: {FFFFFF}Вы должны находиться рядом с представителем ТЦК.");
		return 1;
	}

	TCK_ShowMain(playerid);
	return 1;
}
