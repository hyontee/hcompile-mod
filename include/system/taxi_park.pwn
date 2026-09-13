#if defined _SYSTEM_TAXI_PARK
	#endinput
#endif
#define _SYSTEM_TAXI_PARK

// ============================================================
//  Система таксопарков
//  ------------------------------------------------------------
//  Каждый таксопарк ("Яндекс Такси", "Black Taxi", "Gett Taxi")
//  имеет:
//    - пикап входа на улице (свои координаты у каждого);
//    - общую точку "внутри" (один интерьер на всех);
//    - пикап устройства на работу (внутри, координаты общие);
//    - пикап выхода (внутри, координаты общие);
//    - собственные координаты, куда телепортирует пикап выхода;
//    - пикап автопарка на улице (свои координаты у каждого);
//    - собственную парковку (3 места) для машин из автопарка.
//
//  У всех таксопарков один и тот же интерьер (TAXI_PARK_INTERIOR_ID),
//  разделение между ними достигается через уникальный virtual
//  world, который выделяется каждому таксопарку заново при
//  каждом старте сервера (см. TaxiPark_Init, вызывается из
//  OnGameModeInit).
//
//  Устройство в таксопарк хранится в колонке `t_company` таблицы
//  `accounts` (значение -1 = не устроен, иначе номер таксопарка
//  TAXI_PARK_*). Колонка создаётся автоматически при старте, если
//  её ещё нет. Кэш текущего значения хранится в PVar игрока, чтобы
//  не дёргать базу на каждой проверке.
// ============================================================

#define TAXI_PARK_COUNT				(3)

#define TAXI_PARK_YANDEX			(0)
#define TAXI_PARK_BLACK				(1)
#define TAXI_PARK_GETT				(2)

// ID интерьера, в котором находится точка "внутри" таксопарка.
#define TAXI_PARK_INTERIOR_ID		(1)

// База для virtual world таксопарков. Подобрана так, чтобы не
// пересекаться ни с виртуальными мирами игроков, ни с любыми
// другими virtual world, использующимися в моде.
#define TAXI_PARK_VW_BASE			(900000)

// Общая точка "внутри" таксопарка (интерьер один на всех,
// разделение достигается через virtual world)
#define TAXI_PARK_INSIDE_X			(-0.311587)
#define TAXI_PARK_INSIDE_Y			(2501.925781)
#define TAXI_PARK_INSIDE_Z			(2011.045166)
#define TAXI_PARK_INSIDE_A			(0.036637)

// Общая точка пикапа "Устройство на работу" внутри таксопарка
#define TAXI_PARK_HIRE_X			(2.029496)
#define TAXI_PARK_HIRE_Y			(2503.637451)
#define TAXI_PARK_HIRE_Z			(2011.045166)

// Общая точка пикапа "Выход" внутри таксопарка
#define TAXI_PARK_EXIT_X			(-0.270039)
#define TAXI_PARK_EXIT_Y			(2500.643798)
#define TAXI_PARK_EXIT_Z			(2011.045166)

// Модели пикапов "Устройство" и "Выход" внутри таксопарка.
#define TAXI_PARK_HIRE_PICKUP_MODEL	(19132)
#define TAXI_PARK_EXIT_PICKUP_MODEL	(19132)
#define TAXI_PARK_AUTOPARK_PICKUP_MODEL	(1225)

// Собственные (не входящие в общий PICKUP_ACTION_TYPE мода) типы
// действий для новых пикапов. Специально выбраны отрицательными,
// чтобы никогда не пересечься с числами из enum'а PICKUP_ACTION_TYPE_*
// в основном моде.
#define TAXI_PARK_ACTION_EXIT		(-101)
#define TAXI_PARK_ACTION_HIRE		(-102)
#define TAXI_PARK_ACTION_AUTOPARK	(-103)

// Цвета табличек над входом (формат 0xRRGGBBAA)
#define TAXI_PARK_COLOR_YELLOW		(0xFFFF00FF)
#define TAXI_PARK_COLOR_LIGHTBLUE	(0x00BFFFFF)
#define TAXI_PARK_COLOR_WHITE		(0xFFFFFFFF)
#define TAXI_PARK_COLOR_RED			(0xFF0000FF)

// PVar, в котором хранится "устройство" игрока в таксопарк.
// Хранится как (номер_таксопарка + 1), 0 = не устроен нигде.
#define TAXI_PARK_PVAR_JOB			"TaxiParkJob"

// Уникальный id "кнопки" уведомления (ShowNotificationSile) для
// открытия списка вызовов. Подобран так, чтобы не пересекаться
// с TEST_VZ (1..5), VEHICLE_START_ENGINE (100) и т.п.
#define OFFER_TAXI_CHALLENGE		(7001)

// ------------------------------------------------------------
//  Автопарк / машины / заказы
// ------------------------------------------------------------

#define TAXI_VEHICLE_COUNT			(3)

#define TAXI_VEHICLE_TIMEOUT		(60)	// сек. на возврат брошенной машины
#define TAXI_ORDER_MIN_DELAY		(60)	// мин. задержка между вызовами (сек)
#define TAXI_ORDER_MAX_DELAY		(180)	// макс. задержка между вызовами (сек)
#define TAXI_ORDER_MIN_NPC_DIST	(200.0)	// мин. дистанция игрок -> клиент
#define TAXI_ORDER_MIN_DROP_DIST	(400.0)	// мин. дистанция клиент -> точка назначения
#define TAXI_ORDER_ARRIVE_DIST		(3.0)	// на каком расстоянии считается "доехал"
#define TAXI_ORDER_PAY_PER_METER	(10)	// руб. за метр вызова (100м = 1000 руб.)
#define TAXI_MAX_PENDING_CALLS		(3)		// сколько вызовов может копиться одновременно
#define TAXI_CLIENT_ACTOR_SKIN		(67)

#define TAXI_ORDER_STATE_NONE		(0)
#define TAXI_ORDER_STATE_TO_CLIENT	(1)
#define TAXI_ORDER_STATE_TO_DROP	(2)

enum E_TAXI_PARK_DATA
{
	TP_NAME[32],

	Float: TP_ENTER_X,
	Float: TP_ENTER_Y,
	Float: TP_ENTER_Z,
	Float: TP_ENTER_A,

	TP_LABEL_TEXT[128],
	TP_LABEL_COLOR,

	// Координаты, куда телепортирует пикап "Выход" именно этого
	// таксопарка (уже не в интерьере)
	Float: TP_EXIT_X,
	Float: TP_EXIT_Y,
	Float: TP_EXIT_Z,
	Float: TP_EXIT_A,

	// Координаты пикапа автопарка этого таксопарка (не в интерьере)
	Float: TP_AUTOPARK_X,
	Float: TP_AUTOPARK_Y,
	Float: TP_AUTOPARK_Z,
	Float: TP_AUTOPARK_A,

	// заполняется автоматически в TaxiPark_Init()
	TP_PICKUP_ENTER_ID,
	TP_PICKUP_EXIT_ID,
	TP_PICKUP_HIRE_ID,
	TP_PICKUP_AUTOPARK_ID,
	TP_VIRTUAL_WORLD
};

new g_TaxiPark[TAXI_PARK_COUNT][E_TAXI_PARK_DATA] =
{
	{
		"Яндекс Такси",
		2223.925781, -1723.143432, 22.320137, 33.810165,
		"Яндекс Таксопарк",
		TAXI_PARK_COLOR_YELLOW,
		2223.755126, -1725.831787, 21.852500, 180.160858,
		2233.586914, -1691.110351, 21.852500, 359.657806,
		-1, -1, -1, -1, -1
	},
	{
		"Black Taxi",
		2415.988281, 1394.843750, 12.687074, 353.196075,
		"Таксопарк {000000}Black Taxi",
		TAXI_PARK_COLOR_WHITE,
		2416.136718, 1392.381958, 12.191487, 178.377014,
		2432.926025, 1401.844360, 12.043049, 269.764495,
		-1, -1, -1, -1, -1
	},
	{
		"Gett Taxi",
		381.760650, 1372.741333, 15.491137, 236.929077,
		"Таксопарк Gett",
		TAXI_PARK_COLOR_LIGHTBLUE,
		378.398803, 1373.023193, 15.343087, 80.821083,
		385.182586, 1339.206298, 15.194649, 180.558929,
		-1, -1, -1, -1, -1
	}
};

// Парковочные места автопарка (3 на таксопарк): X, Y, Z, Angle
new Float: g_TaxiParking[TAXI_PARK_COUNT][3][4] =
{
	{
		{2213.184814, -1734.731567, 21.075531, 129.420944},
		{2216.574462, -1735.091796, 21.069419, 359.760742},
		{2220.705566, -1734.672119, 21.064792, 359.760742}
	},
	{
		{2427.210205, 1377.970703, 11.252395, 264.955444},
		{2424.258300, 1377.980102, 11.252429, 264.955444},
		{2421.168701, 1377.488281, 11.252404, 0.515543}
	},
	{
		{361.930511, 1347.712036, 14.404004, 1.948105},
		{362.119598, 1350.723876, 14.403999, 1.948105},
		{362.322540, 1353.599121, 14.404012, 263.892333}
	}
};

// Каталог машин автопарка: название + модель (номер такой же,
// как в GTA SA, машины визуально заменены модами клиента)
new const g_TaxiVehicleName[TAXI_VEHICLE_COUNT][32] =
{
	"BMW M5 F90",
	"Aston Martin DB11",
	"BMW M5 E39"
};
new const g_TaxiVehicleModel[TAXI_VEHICLE_COUNT] =
{
	466,
	411,
	426
};

// Точки появления клиентов такси (NPC-заказы)
new Float: g_TaxiNpcPos[][3] =
{
	{807.616088, 882.075500, 12.352323},
	{1896.671875, 2290.392578, 15.633044},
	{1895.777343, 2157.128417, 15.892739},
	{1907.715209, 2098.423828, 15.707590},
	{1901.683349, 2050.331054, 15.987061},
	{1844.823608, 2051.369873, 15.922142},
	{1973.291259, 1893.257202, 15.565787},
	{1950.688842, 1728.204956, 15.889284},
	{-2541.593017, 42.217430, 27.734191},
	{-2457.039062, 146.560745, 26.165187},
	{-2478.711669, 28.149408, 26.415000}
};
#define TAXI_NPC_COUNT (sizeof g_TaxiNpcPos)

// Точки, куда можно отвезти клиента (выбираются случайно, не
// ближе TAXI_ORDER_MIN_DROP_DIST метров от точки посадки)
new Float: g_TaxiDropPos[][3] =
{
	{-2327.418457, -175.992324, 26.805496},
	{-2244.730712, -296.057708, 27.581912},
	{-2216.264160, -297.475341, 27.878917},
	{-2178.774169, -240.560287, 26.617984},
	{-2319.576904, 73.257209, 26.525085},
	{-2373.531982, 57.277076, 26.587593},
	{-2375.809082, 32.612709, 26.577419},
	{-2376.391601, 6.827797, 26.566242},
	{-2334.160888, -13.084966, 26.426216},
	{1953.213012, 1718.885498, 16.003572},
	{1949.738891, 1753.821777, 15.397899},
	{1979.854614, 1746.535888, 15.738937},
	{1980.544799, 1777.199707, 15.624352},
	{1951.654296, 1809.611328, 15.564719},
	{1953.909057, 1896.671386, 15.557974},
	{2381.960937, 1666.193359, 13.750861}
};
#define TAXI_DROP_COUNT (sizeof g_TaxiDropPos)

// Хранит, в каком диалоге устройства (TAXI_PARK_ACTION_HIRE) сейчас
// находится игрок, чтобы после ответа на диалог знать, в какой
// именно таксопарк он пытается устроиться.
new g_TaxiPark_PendingHire[MAX_PLAYERS];

// Хранит, к какому таксопарку относится открытый диалог автопарка.
new g_TaxiPark_PendingAutopark[MAX_PLAYERS];

// -- Машина игрока, взятая с автопарка --
new g_TaxiPark_Vehicle[MAX_PLAYERS];
new Float: g_TaxiPark_VehicleSeconds[MAX_PLAYERS];

// -- Заказы (вызовы) --
new g_TaxiPark_PendingCount[MAX_PLAYERS];
new g_TaxiPark_PendingNpc[MAX_PLAYERS][TAXI_MAX_PENDING_CALLS];
new g_TaxiPark_PendingDrop[MAX_PLAYERS][TAXI_MAX_PENDING_CALLS];
new Float: g_TaxiPark_PendingDist[MAX_PLAYERS][TAXI_MAX_PENDING_CALLS];

new g_TaxiPark_OrderState[MAX_PLAYERS];
new g_TaxiPark_ActiveActor[MAX_PLAYERS];
new Float: g_TaxiPark_ActiveNpcPos[MAX_PLAYERS][3];
new Float: g_TaxiPark_ActiveDropPos[MAX_PLAYERS][3];
new Float: g_TaxiPark_ActiveDistance[MAX_PLAYERS];

// ------------------------------------------------------------
//  Небольшие утилиты
// ------------------------------------------------------------

stock Float: TaxiPark_Dist3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
	return floatsqroot(floatpower(x2 - x1, 2.0) + floatpower(y2 - y1, 2.0) + floatpower(z2 - z1, 2.0));
}

// ------------------------------------------------------------
//  Работа с "устройством" игрока в таксопарк (кэш в PVar,
//  реальное хранилище - колонка `t_company` в `accounts`)
// ------------------------------------------------------------

stock TaxiPark_GetPlayerJob(playerid)
{
	new job = GetPVarInt(playerid, TAXI_PARK_PVAR_JOB);
	if(job <= 0) return -1;
	return job - 1;
}

// Только меняет кэш в PVar, БЕЗ записи в базу (используется при
// загрузке значения из базы, чтобы не гонять лишний UPDATE).
stock TaxiPark_SetPlayerJobLocal(playerid, park_id)
{
	SetPVarInt(playerid, TAXI_PARK_PVAR_JOB, park_id + 1);
	return 1;
}

// Меняет кэш и сразу сохраняет значение в базу.
stock TaxiPark_SetPlayerJob(playerid, park_id)
{
	TaxiPark_SetPlayerJobLocal(playerid, park_id);
	UpdatePlayerDatabaseInt(playerid, "t_company", park_id);
	return 1;
}

stock TaxiPark_RemovePlayerJob(playerid)
{
	SetPVarInt(playerid, TAXI_PARK_PVAR_JOB, 0);
	UpdatePlayerDatabaseInt(playerid, "t_company", -1);
	return 1;
}

// ------------------------------------------------------------
//  MySQL: автосоздание колонки и загрузка данных при входе
// ------------------------------------------------------------

stock TaxiPark_EnsureDatabase()
{
	new query[192];

	// Если колонки `t_company` ещё нет в `accounts` - создаём её.
	// (IF NOT EXISTS поддерживается MySQL 8+/MariaDB - если версия
	// сервера БД старше, просто уберите "IF NOT EXISTS" и создайте
	// колонку руками один раз.)
	mysql_format(mysql, query, sizeof query, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `t_company` INT(11) NOT NULL DEFAULT -1");
	mysql_query(mysql, query, false);

	return 1;
}

stock TaxiPark_LoadPlayer(playerid)
{
	if(GetPlayerAccountID(playerid) <= 0) return 0;

	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT `t_company` FROM `accounts` WHERE `id` = %d LIMIT 1", GetPlayerAccountID(playerid));
	mysql_tquery(mysql, query, "TaxiPark_OnPlayerLoad", "d", playerid);
	return 1;
}

forward TaxiPark_OnPlayerLoad(playerid);
public TaxiPark_OnPlayerLoad(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;

	new park_id = cache_get_field_content_int(0, "t_company");
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT)
	{
		TaxiPark_SetPlayerJobLocal(playerid, -1);
	}
	else
	{
		TaxiPark_SetPlayerJobLocal(playerid, park_id);
	}
	return 1;
}

// ------------------------------------------------------------
//  Инициализация
// ------------------------------------------------------------

// Создаёт все пикапы системы и таблички над ними, выделяет
// каждому таксопарку собственный virtual world.
stock TaxiPark_Init()
{
	TaxiPark_EnsureDatabase();

	// ФИКС бага с "левым" диалогом мода на пикапе Яндекс Такси:
	// в моде используются переменные-указатели на ID пикапов
	// (например "new litvinghghgh;"), которые по умолчанию равны 0
	// и нигде не инициализируются собственным CreatePickup(...).
	// Если ЛЮБОЙ реальный пикап получает ID 0, старые проверки вида
	// "if(pickupid == litvinghghgh)" начинают ошибочно срабатывать
	// на этом пикапе. Так как пикап входа в Яндекс Такси создавался
	// самым первым, ему и доставался этот "опасный" ID 0.
	// Чтобы полностью исключить это, ДО создания собственных пикапов
	// "сжигаем" нулевой ID технич. пикапом, который не виден и не
	// достижим ни одним игроком (далеко за картой, в отдельном
	// virtual world).
	CreatePickup(1239, 1, 0.0, 0.0, 0.0, 999999);

	for(new i = 0; i < TAXI_PARK_COUNT; i++)
	{
		g_TaxiPark[i][TP_VIRTUAL_WORLD] = TAXI_PARK_VW_BASE + i;

		// -- Пикап входа на улице --
		g_TaxiPark[i][TP_PICKUP_ENTER_ID] = CreatePickup
		(
			19132, 23,
			g_TaxiPark[i][TP_ENTER_X], g_TaxiPark[i][TP_ENTER_Y], g_TaxiPark[i][TP_ENTER_Z],
			0,
			PICKUP_ACTION_TYPE_TAXI_PARK_ENT, i
		);

		CreateDynamic3DTextLabel
		(
			g_TaxiPark[i][TP_LABEL_TEXT],
			g_TaxiPark[i][TP_LABEL_COLOR],
			g_TaxiPark[i][TP_ENTER_X], g_TaxiPark[i][TP_ENTER_Y], g_TaxiPark[i][TP_ENTER_Z] + 0.85,
			15.0
		);

		// -- Пикап "Выход" внутри таксопарка --
		g_TaxiPark[i][TP_PICKUP_EXIT_ID] = CreatePickup
		(
			TAXI_PARK_EXIT_PICKUP_MODEL, 23,
			TAXI_PARK_EXIT_X, TAXI_PARK_EXIT_Y, TAXI_PARK_EXIT_Z,
			g_TaxiPark[i][TP_VIRTUAL_WORLD],
			TAXI_PARK_ACTION_EXIT, i
		);

		CreateDynamic3DTextLabel
		(
			"Выход",
			TAXI_PARK_COLOR_RED,
			TAXI_PARK_EXIT_X, TAXI_PARK_EXIT_Y, TAXI_PARK_EXIT_Z + 0.85,
			15.0,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
			g_TaxiPark[i][TP_VIRTUAL_WORLD], TAXI_PARK_INTERIOR_ID
		);

		// -- Пикап "Устройство на работу" внутри таксопарка --
		g_TaxiPark[i][TP_PICKUP_HIRE_ID] = CreatePickup
		(
			TAXI_PARK_HIRE_PICKUP_MODEL, 23,
			TAXI_PARK_HIRE_X, TAXI_PARK_HIRE_Y, TAXI_PARK_HIRE_Z,
			g_TaxiPark[i][TP_VIRTUAL_WORLD],
			TAXI_PARK_ACTION_HIRE, i
		);

		// -- Пикап автопарка на улице --
		g_TaxiPark[i][TP_PICKUP_AUTOPARK_ID] = CreatePickup
		(
			TAXI_PARK_AUTOPARK_PICKUP_MODEL, 23,
			g_TaxiPark[i][TP_AUTOPARK_X], g_TaxiPark[i][TP_AUTOPARK_Y], g_TaxiPark[i][TP_AUTOPARK_Z],
			0,
			TAXI_PARK_ACTION_AUTOPARK, i
		);

		CreateDynamic3DTextLabel
		(
			"Автопарк",
			TAXI_PARK_COLOR_WHITE,
			g_TaxiPark[i][TP_AUTOPARK_X], g_TaxiPark[i][TP_AUTOPARK_Y], g_TaxiPark[i][TP_AUTOPARK_Z] + 0.85,
			15.0
		);
	}

	for(new p = 0; p < MAX_PLAYERS; p++)
	{
		g_TaxiPark_Vehicle[p] = INVALID_VEHICLE_ID;
		g_TaxiPark_VehicleSeconds[p] = -1.0;
		g_TaxiPark_OrderState[p] = TAXI_ORDER_STATE_NONE;
		g_TaxiPark_ActiveActor[p] = INVALID_ACTOR_ID;
	}

	SetTimer("TaxiPark_OnSecondTimer", 1000, true);

	printf("[TaxiPark] Загружено таксопарков: %d", TAXI_PARK_COUNT);
	return 1;
}

// ------------------------------------------------------------
//  Обработчики пикапов "вход / выход / устройство"
// ------------------------------------------------------------

// Вызывается при подборе пикапа входа в таксопарк (park_id = TAXI_PARK_*)
stock TaxiPark_OnEnter(playerid, park_id)
{
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 0;

	SetPlayerInterior(playerid, TAXI_PARK_INTERIOR_ID);
	SetPlayerVirtualWorld(playerid, g_TaxiPark[park_id][TP_VIRTUAL_WORLD]);
	SetPlayerPos(playerid, TAXI_PARK_INSIDE_X, TAXI_PARK_INSIDE_Y, TAXI_PARK_INSIDE_Z);
	SetPlayerFacingAngle(playerid, TAXI_PARK_INSIDE_A);

	return 1;
}

// Вызывается при подборе пикапа "Выход" внутри таксопарка
stock TaxiPark_OnExit(playerid, park_id)
{
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 0;

	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid, g_TaxiPark[park_id][TP_EXIT_X], g_TaxiPark[park_id][TP_EXIT_Y], g_TaxiPark[park_id][TP_EXIT_Z]);
	SetPlayerFacingAngle(playerid, g_TaxiPark[park_id][TP_EXIT_A]);

	return 1;
}

// Вызывается при подборе пикапа "Устройство на работу"
stock TaxiPark_OnHirePickup(playerid, park_id)
{
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 0;

	new current_job = TaxiPark_GetPlayerJob(playerid);

	if(current_job == park_id)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы уже устроены в этом таксопарке, если вы хотите уволиться введите /tmenu");
		return 1;
	}

	if(current_job != -1)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы уже устроены в другом таксопарке, если вы хотите уволиться введите /tmenu");
		return 1;
	}

	g_TaxiPark_PendingHire[playerid] = park_id;

	new caption[64], info[160];
	format(caption, sizeof caption, "%s | Устройство в", g_TaxiPark[park_id][TP_NAME]);
	format(info, sizeof info, "Вы точно хотите устроиться в %s?", g_TaxiPark[park_id][TP_NAME]);

	Dialog_Open(playerid, "TaxiPark_HireResponse", DIALOG_STYLE_MSGBOX, caption, info, "Да", "Нет");
	return 1;
}

Dialog_Response:TaxiPark_HireResponse(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;

	new park_id = g_TaxiPark_PendingHire[playerid];
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 1;

	// Игрок мог успеть устроиться в другой таксопарк, пока
	// был открыт диалог, — перепроверяем ещё раз.
	new current_job = TaxiPark_GetPlayerJob(playerid);
	if(current_job != -1)
	{
		if(current_job == park_id)
			SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы уже устроены в этом таксопарке, если вы хотите уволиться введите /tmenu");
		else
			SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы уже устроены в другом таксопарке, если вы хотите уволиться введите /tmenu");
		return 1;
	}

	TaxiPark_SetPlayerJob(playerid, park_id);

	new msg[128];
	format(msg, sizeof msg, "{33FF33}| {ffffff}Вы устроились в таксопарк %s", g_TaxiPark[park_id][TP_NAME]);
	SendClientMessage(playerid, -1, msg);

	return 1;
}

// ------------------------------------------------------------
//  Команда /tmenu
// ------------------------------------------------------------

cmd:tmenu(playerid, params[])
{
	new park_id = TaxiPark_GetPlayerJob(playerid);

	if(park_id == -1)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не устроены ни в одном таксопарке");
		return 1;
	}

	new caption[64];
	format(caption, sizeof caption, "%s | Меню таксопарка", g_TaxiPark[park_id][TP_NAME]);

	Dialog_Open(playerid, "TaxiPark_MenuResponse", DIALOG_STYLE_MSGBOX, caption, "Уволиться с таксопарка", "Выбрать", "Отмена");
	return 1;
}

Dialog_Response:TaxiPark_MenuResponse(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;

	new park_id = TaxiPark_GetPlayerJob(playerid);
	if(park_id == -1) return 1;

	TaxiPark_RemovePlayerJob(playerid);
	TaxiPark_ClearPlayerVehicle(playerid, false);

	new msg[128];
	format(msg, sizeof msg, "{33FF33}| {ffffff}Вы уволились из таксопарка %s", g_TaxiPark[park_id][TP_NAME]);
	SendClientMessage(playerid, -1, msg);

	return 1;
}

// ------------------------------------------------------------
//  Автопарк
// ------------------------------------------------------------

stock TaxiPark_OnAutoparkPickup(playerid, park_id)
{
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 0;

	new current_job = TaxiPark_GetPlayerJob(playerid);

	if(current_job == -1)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не устроены в таксопарк, зайдите в таксопарк и устройтесь");
		return 1;
	}

	if(current_job != park_id)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы находитесь в другом таксопарке, используйте автопарк вашего таксопарка, или увольтесь с таксопарка в котором вы сейчас устроены, и устройтесь в наш таксопарк.");
		return 1;
	}

	if(g_TaxiPark_Vehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(g_TaxiPark_Vehicle[playerid]))
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть машина взятая с автопарка");
		return 1;
	}

	g_TaxiPark_PendingAutopark[playerid] = park_id;

	new caption[64], info[160];
	format(caption, sizeof caption, "%s | Автопарк", g_TaxiPark[park_id][TP_NAME]);
	format(info, sizeof info, "%s\n%s\n%s", g_TaxiVehicleName[0], g_TaxiVehicleName[1], g_TaxiVehicleName[2]);

	Dialog_Open(playerid, "TaxiPark_AutoparkResponse", DIALOG_STYLE_LIST, caption, info, "Выбрать", "Отмена");
	return 1;
}

Dialog_Response:TaxiPark_AutoparkResponse(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(listitem < 0 || listitem >= TAXI_VEHICLE_COUNT) return 1;

	new park_id = g_TaxiPark_PendingAutopark[playerid];
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 1;

	// Повторная проверка на случай, если игрок успел уволиться
	// или взять другую машину, пока был открыт диалог.
	if(TaxiPark_GetPlayerJob(playerid) != park_id) return 1;
	if(g_TaxiPark_Vehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(g_TaxiPark_Vehicle[playerid]))
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть машина взятая с автопарка");
		return 1;
	}

	new slot = random(3);
	new Float:x = g_TaxiParking[park_id][slot][0];
	new Float:y = g_TaxiParking[park_id][slot][1];
	new Float:z = g_TaxiParking[park_id][slot][2];
	new Float:a = g_TaxiParking[park_id][slot][3];

	new vehicleid = CreateVehicle(g_TaxiVehicleModel[listitem], x, y, z, a, -1, -1, -1, false);
	SetVehicleVirtualWorld(vehicleid, 0);
	LinkVehicleToInterior(vehicleid, 0);
	PutPlayerInVehicle(playerid, vehicleid, 0);

	g_TaxiPark_Vehicle[playerid] = vehicleid;
	g_TaxiPark_VehicleSeconds[playerid] = -1.0;

	SendClientMessage(playerid, -1, "{ffffff}Чтобы посмотреть список вызовов введите /challenge");

	TaxiPark_ScheduleNextOrder(playerid);

	return 1;
}

// Убирает у игрока машину такси (и всё, что с ней связано).
// bool:destroy_vehicle - удалять ли саму машину (false - если она
// уже была удалена/сгорела/итд снаружи).
stock TaxiPark_ClearPlayerVehicle(playerid, bool:destroy_vehicle = true)
{
	if(g_TaxiPark_Vehicle[playerid] != INVALID_VEHICLE_ID)
	{
		if(destroy_vehicle && IsValidVehicle(g_TaxiPark_Vehicle[playerid]))
		{
			DestroyVehicle(g_TaxiPark_Vehicle[playerid]);
		}
		g_TaxiPark_Vehicle[playerid] = INVALID_VEHICLE_ID;
	}

	g_TaxiPark_VehicleSeconds[playerid] = -1.0;
	TaxiPark_ClearActiveOrder(playerid);
	g_TaxiPark_PendingCount[playerid] = 0;

	return 1;
}

// ------------------------------------------------------------
//  Заказы (системные вызовы)
// ------------------------------------------------------------

stock TaxiPark_ClearActiveOrder(playerid)
{
	if(g_TaxiPark_ActiveActor[playerid] != INVALID_ACTOR_ID)
	{
		if(IsValidActor(g_TaxiPark_ActiveActor[playerid]))
			DestroyActor(g_TaxiPark_ActiveActor[playerid]);
		g_TaxiPark_ActiveActor[playerid] = INVALID_ACTOR_ID;
	}

	if(g_TaxiPark_OrderState[playerid] != TAXI_ORDER_STATE_NONE)
	{
		DisablePlayerGPS(playerid);
	}

	g_TaxiPark_OrderState[playerid] = TAXI_ORDER_STATE_NONE;
	return 1;
}

stock TaxiPark_ScheduleNextOrder(playerid)
{
	new delay = (TAXI_ORDER_MIN_DELAY + random(TAXI_ORDER_MAX_DELAY - TAXI_ORDER_MIN_DELAY + 1)) * 1000;
	SetTimerEx("TaxiPark_GenerateCall", delay, false, "i", playerid);
	return 1;
}

forward TaxiPark_GenerateCall(playerid);
public TaxiPark_GenerateCall(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(g_TaxiPark_Vehicle[playerid] == INVALID_VEHICLE_ID || !IsValidVehicle(g_TaxiPark_Vehicle[playerid]))
	{
		return 1; // машины больше нет - заказы для этого игрока прекращаются
	}

	if(g_TaxiPark_PendingCount[playerid] < TAXI_MAX_PENDING_CALLS)
	{
		new Float:px, Float:py, Float:pz;
		GetPlayerPos(playerid, px, py, pz);

		// Ищем точку появления клиента не ближе TAXI_ORDER_MIN_NPC_DIST
		new npc_id = random(TAXI_NPC_COUNT);
		new Float:npc_dist = TaxiPark_Dist3D(px, py, pz, g_TaxiNpcPos[npc_id][0], g_TaxiNpcPos[npc_id][1], g_TaxiNpcPos[npc_id][2]);

		for(new tries = 0; tries < 20 && npc_dist < TAXI_ORDER_MIN_NPC_DIST; tries++)
		{
			npc_id = random(TAXI_NPC_COUNT);
			npc_dist = TaxiPark_Dist3D(px, py, pz, g_TaxiNpcPos[npc_id][0], g_TaxiNpcPos[npc_id][1], g_TaxiNpcPos[npc_id][2]);
		}

		// Ищем точку назначения не ближе TAXI_ORDER_MIN_DROP_DIST от клиента
		new drop_id = random(TAXI_DROP_COUNT);
		new Float:drop_dist = TaxiPark_Dist3D(g_TaxiNpcPos[npc_id][0], g_TaxiNpcPos[npc_id][1], g_TaxiNpcPos[npc_id][2], g_TaxiDropPos[drop_id][0], g_TaxiDropPos[drop_id][1], g_TaxiDropPos[drop_id][2]);

		for(new tries = 0; tries < 20 && drop_dist < TAXI_ORDER_MIN_DROP_DIST; tries++)
		{
			drop_id = random(TAXI_DROP_COUNT);
			drop_dist = TaxiPark_Dist3D(g_TaxiNpcPos[npc_id][0], g_TaxiNpcPos[npc_id][1], g_TaxiNpcPos[npc_id][2], g_TaxiDropPos[drop_id][0], g_TaxiDropPos[drop_id][1], g_TaxiDropPos[drop_id][2]);
		}

		new slot = g_TaxiPark_PendingCount[playerid];
		g_TaxiPark_PendingNpc[playerid][slot] = npc_id;
		g_TaxiPark_PendingDrop[playerid][slot] = drop_id;
		g_TaxiPark_PendingDist[playerid][slot] = npc_dist;
		g_TaxiPark_PendingCount[playerid]++;

		ShowNotificationSile(playerid, 4, 6, OFFER_TAXI_CHALLENGE, 0, "Поступил новый вызов", ">>");
	}

	TaxiPark_ScheduleNextOrder(playerid);
	return 1;
}

// Вызывается при нажатии на кнопку ">>" в уведомлении о новом вызове
stock TaxiPark_OnChallengeNotification(playerid)
{
	callcmd::challenge(playerid, "");
	return 1;
}

cmd:challenge(playerid, params[])
{
	if(g_TaxiPark_Vehicle[playerid] == INVALID_VEHICLE_ID || !IsValidVehicle(g_TaxiPark_Vehicle[playerid]))
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас нет машины, взятой с автопарка такси");
		return 1;
	}

	new park_id = TaxiPark_GetPlayerJob(playerid);
	if(park_id == -1) return 1;

	new caption[64];
	format(caption, sizeof caption, "%s | Список вызовов", g_TaxiPark[park_id][TP_NAME]);

	new info[512];
	if(g_TaxiPark_PendingCount[playerid] <= 0)
	{
		format(info, sizeof info, "На данный момент вызовов нету");
	}
	else
	{
		new taxi_line[48];
		new Float:call_dist_i;
		info[0] = 0;
		for(new i = 0; i < g_TaxiPark_PendingCount[playerid]; i++)
		{
			call_dist_i = g_TaxiPark_PendingDist[playerid][i];
			format(taxi_line, sizeof taxi_line, "Вызов %d  %.0fм\n", i + 1, call_dist_i);
			strcat(info, taxi_line, sizeof info);
		}
	}

	Dialog_Open(playerid, "TaxiPark_ChallengeResponse", DIALOG_STYLE_LIST, caption, info, "Выбрать", "Закрыть");
	return 1;
}

Dialog_Response:TaxiPark_ChallengeResponse(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(g_TaxiPark_PendingCount[playerid] <= 0) return 1;
	if(listitem < 0 || listitem >= g_TaxiPark_PendingCount[playerid]) return 1;

	if(g_TaxiPark_OrderState[playerid] != TAXI_ORDER_STATE_NONE)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть активный вызов, сначала завершите его");
		return 1;
	}

	new npc_id = g_TaxiPark_PendingNpc[playerid][listitem];
	new drop_id = g_TaxiPark_PendingDrop[playerid][listitem];
	new Float:call_dist = g_TaxiPark_PendingDist[playerid][listitem];

	// убираем выбранный вызов из очереди (сдвигаем оставшиеся)
	for(new i = listitem; i < g_TaxiPark_PendingCount[playerid] - 1; i++)
	{
		g_TaxiPark_PendingNpc[playerid][i] = g_TaxiPark_PendingNpc[playerid][i + 1];
		g_TaxiPark_PendingDrop[playerid][i] = g_TaxiPark_PendingDrop[playerid][i + 1];
		g_TaxiPark_PendingDist[playerid][i] = g_TaxiPark_PendingDist[playerid][i + 1];
	}
	g_TaxiPark_PendingCount[playerid]--;

	g_TaxiPark_ActiveNpcPos[playerid][0] = g_TaxiNpcPos[npc_id][0];
	g_TaxiPark_ActiveNpcPos[playerid][1] = g_TaxiNpcPos[npc_id][1];
	g_TaxiPark_ActiveNpcPos[playerid][2] = g_TaxiNpcPos[npc_id][2];

	g_TaxiPark_ActiveDropPos[playerid][0] = g_TaxiDropPos[drop_id][0];
	g_TaxiPark_ActiveDropPos[playerid][1] = g_TaxiDropPos[drop_id][1];
	g_TaxiPark_ActiveDropPos[playerid][2] = g_TaxiDropPos[drop_id][2];

	g_TaxiPark_ActiveDistance[playerid] = call_dist;

	g_TaxiPark_ActiveActor[playerid] = CreateActor(TAXI_CLIENT_ACTOR_SKIN, g_TaxiPark_ActiveNpcPos[playerid][0], g_TaxiPark_ActiveNpcPos[playerid][1], g_TaxiPark_ActiveNpcPos[playerid][2], 0.0);
	SetActorInvulnerable(g_TaxiPark_ActiveActor[playerid], true);

	EnablePlayerGPS(playerid, 55, g_TaxiPark_ActiveNpcPos[playerid][0], g_TaxiPark_ActiveNpcPos[playerid][1], g_TaxiPark_ActiveNpcPos[playerid][2], "Заберите клиента по указанному маршруту");

	g_TaxiPark_OrderState[playerid] = TAXI_ORDER_STATE_TO_CLIENT;

	return 1;
}

// ------------------------------------------------------------
//  Единый тикер (раз в секунду): таймер брошенной машины +
//  отслеживание прогресса активного заказа.
// ------------------------------------------------------------

forward TaxiPark_OnSecondTimer();
public TaxiPark_OnSecondTimer()
{
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
		if(!IsPlayerConnected(playerid)) continue;

		// -- Таймер брошенной машины --
		if(g_TaxiPark_Vehicle[playerid] != INVALID_VEHICLE_ID)
		{
			if(!IsValidVehicle(g_TaxiPark_Vehicle[playerid]))
			{
				TaxiPark_ClearPlayerVehicle(playerid, false);
			}
			else
			{
				new bool:in_own_car = (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == g_TaxiPark_Vehicle[playerid]);

				if(in_own_car)
				{
					g_TaxiPark_VehicleSeconds[playerid] = -1.0;
				}
				else
				{
					if(g_TaxiPark_VehicleSeconds[playerid] < 0.0)
					{
						g_TaxiPark_VehicleSeconds[playerid] = float(TAXI_VEHICLE_TIMEOUT);
					}
					else
					{
						g_TaxiPark_VehicleSeconds[playerid] -= 1.0;
					}

					if(g_TaxiPark_VehicleSeconds[playerid] <= 0.0)
					{
						TaxiPark_ClearPlayerVehicle(playerid, true);
						SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Машина возвращена в автопарк");
					}
					else
					{
						new gtext[32];
						format(gtext, sizeof gtext, "~g~%d", floatround(g_TaxiPark_VehicleSeconds[playerid]));
						GameTextForPlayer(playerid, gtext, 1100, 4);
					}
				}
			}
		}

		// -- Прогресс активного заказа --
		if(g_TaxiPark_OrderState[playerid] == TAXI_ORDER_STATE_TO_CLIENT)
		{
			if(IsPlayerInRangeOfPoint(playerid, TAXI_ORDER_ARRIVE_DIST, g_TaxiPark_ActiveNpcPos[playerid][0], g_TaxiPark_ActiveNpcPos[playerid][1], g_TaxiPark_ActiveNpcPos[playerid][2]))
			{
				if(g_TaxiPark_ActiveActor[playerid] != INVALID_ACTOR_ID)
				{
					if(IsValidActor(g_TaxiPark_ActiveActor[playerid]))
						DestroyActor(g_TaxiPark_ActiveActor[playerid]);
					g_TaxiPark_ActiveActor[playerid] = INVALID_ACTOR_ID;
				}

				DisablePlayerGPS(playerid);
				EnablePlayerGPS(playerid, 55, g_TaxiPark_ActiveDropPos[playerid][0], g_TaxiPark_ActiveDropPos[playerid][1], g_TaxiPark_ActiveDropPos[playerid][2], "");
				ShowNotificationSile(playerid, 3, 6, -1, -1, "Вы подобрали клиента, довезите его до нужного места.", "");

				g_TaxiPark_OrderState[playerid] = TAXI_ORDER_STATE_TO_DROP;
			}
		}
		else if(g_TaxiPark_OrderState[playerid] == TAXI_ORDER_STATE_TO_DROP)
		{
			if(IsPlayerInRangeOfPoint(playerid, TAXI_ORDER_ARRIVE_DIST, g_TaxiPark_ActiveDropPos[playerid][0], g_TaxiPark_ActiveDropPos[playerid][1], g_TaxiPark_ActiveDropPos[playerid][2]))
			{
				new payout = floatround(g_TaxiPark_ActiveDistance[playerid]) * TAXI_ORDER_PAY_PER_METER;
				GivePlayerMoneyEx(playerid, payout, "Оплата поездки на такси");

				DisablePlayerGPS(playerid);
				g_TaxiPark_OrderState[playerid] = TAXI_ORDER_STATE_NONE;
			}
		}
	}

	return 1;
}

// ------------------------------------------------------------
//  Подключение к существующему в моде OnPlayerPickUpPickupEx
//  ------------------------------------------------------------
//  В моде уже есть единственная public-функция OnPlayerPickUpPickupEx
//  (в основном .pwn файле), которая обрабатывает подбор пикапов, в
//  том числе уже готовый case PICKUP_ACTION_TYPE_TAXI_PARK_ENT.
//  Чтобы не редактировать основной файл мода (вся система должна
//  жить в taxi_park.pwn), мы "перехватываем" эту функцию по тому же
//  принципу (ALS), что уже используется в pickup.pwn: забираем себе
//  настоящее имя OnPlayerPickUpPickupEx, обрабатываем свои новые
//  типы действий (выход, устройство на работу, автопарк), а затем
//  ЯВНО вызываем переименованную версию мода, чтобы вся остальная
//  логика подбора пикапов продолжала работать как прежде.
// ------------------------------------------------------------

forward TaxiPark_Legacy_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	switch(action_type)
	{
		case TAXI_PARK_ACTION_EXIT:
		{
			TaxiPark_OnExit(playerid, action_id);
		}
		case TAXI_PARK_ACTION_HIRE:
		{
			TaxiPark_OnHirePickup(playerid, action_id);
		}
		case TAXI_PARK_ACTION_AUTOPARK:
		{
			TaxiPark_OnAutoparkPickup(playerid, action_id);
		}
	}

	return TaxiPark_Legacy_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
}

#if defined _ALS_OnPlayerPickUpPickupEx
	#undef OnPlayerPickUpPickupEx
#else
	#define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx TaxiPark_Legacy_OnPlayerPickUpPickupEx

// ------------------------------------------------------------
//  Очистка при отключении игрока (ALS, т.к. в моде уже есть
//  несколько обработчиков OnPlayerDisconnect)
// ------------------------------------------------------------

public OnPlayerDisconnect(playerid, reason)
{
	TaxiPark_ClearPlayerVehicle(playerid, true);

	#if defined txp_OnPlayerDisconnect
		return txp_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect txp_OnPlayerDisconnect
#if defined txp_OnPlayerDisconnect
	forward txp_OnPlayerDisconnect(playerid, reason);
#endif
