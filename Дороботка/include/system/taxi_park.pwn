#if defined _SYSTEM_TAXI_PARK
	#endinput
#endif
#define _SYSTEM_TAXI_PARK

#define TAXI_PARK_COUNT				(3)

#define TAXI_PARK_YANDEX			(0)
#define TAXI_PARK_BLACK				(1)
#define TAXI_PARK_GETT				(2)

#define TAXI_PARK_INTERIOR_ID		(1)
#define TAXI_PARK_VW_BASE			(900000)

#define TAXI_PARK_INSIDE_X			(-0.311587)
#define TAXI_PARK_INSIDE_Y			(2501.925781)
#define TAXI_PARK_INSIDE_Z			(2011.045166)
#define TAXI_PARK_INSIDE_A			(0.036637)

#define TAXI_PARK_HIRE_X			(2.029496)
#define TAXI_PARK_HIRE_Y			(2503.637451)
#define TAXI_PARK_HIRE_Z			(2011.045166)

#define TAXI_PARK_EXIT_X			(-0.270039)
#define TAXI_PARK_EXIT_Y			(2500.643798)
#define TAXI_PARK_EXIT_Z			(2011.045166)

#define TAXI_PARK_HIRE_PICKUP_MODEL	(19132)
#define TAXI_PARK_EXIT_PICKUP_MODEL	(19132)
#define TAXI_PARK_AUTOPARK_PICKUP_MODEL (19132)

#define TAXI_PARK_ACTION_EXIT		(-101)
#define TAXI_PARK_ACTION_HIRE		(-102)
#define TAXI_PARK_ACTION_AUTOPARK	(-103)

#define TAXI_PARK_COLOR_YELLOW		(0xFFFF00FF)
#define TAXI_PARK_COLOR_LIGHTBLUE	(0x00BFFFFF)
#define TAXI_PARK_COLOR_WHITE		(0xFFFFFFFF)
#define TAXI_PARK_COLOR_RED			(0xFF0000FF)
#define TAXI_PARK_COLOR_GREEN		(0x33FF33FF)

#define TAXI_PARK_PVAR_JOB			"TaxiParkJob"
#define TAXI_PARK_PVAR_VEHICLE		"TaxiParkVeh"
#define TAXI_PARK_PVAR_TIMER			"TaxiParkTimer"
#define TAXI_PARK_PVAR_ORDER			"TaxiParkOrder"
#define TAXI_PARK_PVAR_ORDER_STAGE	"TaxiParkOrderStage"
#define TAXI_PARK_PVAR_DEST_X		"TaxiParkDestX"
#define TAXI_PARK_PVAR_DEST_Y		"TaxiParkDestY"
#define TAXI_PARK_PVAR_DEST_Z		"TaxiParkDestZ"
#define TAXI_PARK_PVAR_ORDER_DIST	"TaxiParkOrderDist"
#define TAXI_PARK_PVAR_ACTOR			"TaxiParkActor"
#define TAXI_PARK_PVAR_PENDING_CAR	"TaxiParkPendingCar"
#define TAXI_PARK_PVAR_LABEL			"TaxiParkLabel"
#define TAXI_PARK_PVAR_ICON			"TaxiParkIcon"

#define TAXI_PARK_RETURN_TIME		(60)
#define TAXI_PARK_ORDER_MIN_TIME		(20)
#define TAXI_PARK_ORDER_MAX_TIME		(45)
#define TAXI_PARK_MIN_ORDER_DIST		(200.0)
#define TAXI_PARK_MIN_DEST_DIST		(400.0)
#define TAXI_PARK_PAY_PER_100M		(1000)

#define TAXI_PARK_CAR_COUNT			(3)
#define TAXI_PARK_PARKING_SPOTS		(3)

#define TAXI_PARK_NPC_COUNT			(11)
#define TAXI_PARK_DEST_COUNT			(16)

#define TAXI_PARK_NOTIFICATION_ID	(101)

forward TaxiPark_Legacy_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
forward TaxiPark_ReturnVehicleTimer(playerid);
forward TaxiPark_OrderTimer(playerid);
forward TaxiPark_OnJobLoaded(playerid);
forward TaxiPark_CheckArrive(playerid);
forward TaxiPark_UpdateReturnText(playerid, seconds);

enum E_TAXI_PARK_DATA
{
	TP_NAME[32],
	Float: TP_ENTER_X,
	Float: TP_ENTER_Y,
	Float: TP_ENTER_Z,
	Float: TP_ENTER_A,
	TP_LABEL_TEXT[128],
	TP_LABEL_COLOR,
	Float: TP_EXIT_X,
	Float: TP_EXIT_Y,
	Float: TP_EXIT_Z,
	Float: TP_EXIT_A,
	Float: TP_AUTOPARK_X,
	Float: TP_AUTOPARK_Y,
	Float: TP_AUTOPARK_Z,
	Float: TP_AUTOPARK_A,
	Float: TP_PARK1_X, Float: TP_PARK1_Y, Float: TP_PARK1_Z, Float: TP_PARK1_A,
	Float: TP_PARK2_X, Float: TP_PARK2_Y, Float: TP_PARK2_Z, Float: TP_PARK2_A,
	Float: TP_PARK3_X, Float: TP_PARK3_Y, Float: TP_PARK3_Z, Float: TP_PARK3_A,
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
		2213.184814, -1734.731567, 21.075531, 129.420944,
		2216.574462, -1735.091796, 21.069419, 359.760742,
		2220.705566, -1734.672119, 21.064792, 359.760742,
		-1, -1, -1, -1, -1
	},
	{
		"Black Taxi",
		2415.988281, 1394.843750, 12.687074, 353.196075,
		"Таксопарк {000000}Black Taxi",
		TAXI_PARK_COLOR_WHITE,
		2416.136718, 1392.381958, 12.191487, 178.377014,
		2432.926025, 1401.844360, 12.043049, 269.764495,
		2427.210205, 1377.970703, 11.252395, 264.955444,
		2424.258300, 1377.980102, 11.252429, 264.955444,
		2421.168701, 1377.488281, 11.252404, 0.515543,
		-1, -1, -1, -1, -1
	},
	{
		"Gett Taxi",
		381.760650, 1372.741333, 15.491137, 236.929077,
		"Таксопарк Gett",
		TAXI_PARK_COLOR_LIGHTBLUE,
		378.398803, 1373.023193, 15.343087, 80.821083,
		385.182586, 1339.206298, 15.194649, 180.558929,
		361.930511, 1347.712036, 14.404004, 1.948105,
		362.119598, 1350.723876, 14.403999, 1.948105,
		362.322540, 1353.599121, 14.404012, 263.892333,
		-1, -1, -1, -1, -1
	}
};

new g_TaxiParkCars[TAXI_PARK_CAR_COUNT] = {466, 411, 426};
new g_TaxiParkCarNames[TAXI_PARK_CAR_COUNT][32] =
{
	"BMW M5 F90",
	"Aston Martin DB11",
	"BMW M5 E39"
};

new Float: g_TaxiParkNpcPos[TAXI_PARK_NPC_COUNT][4] =
{
	{807.616088, 882.075500, 12.352323, 116.456741},
	{1896.671875, 2290.392578, 15.633044, 94.488922},
	{1895.777343, 2157.128417, 15.892739, 100.949737},
	{1907.715209, 2098.423828, 15.707590, 76.638473},
	{1901.683349, 2050.331054, 15.987061, 356.458068},
	{1844.823608, 2051.369873, 15.922142, 2.510913},
	{1973.291259, 1893.257202, 15.565787, 85.372970},
	{1950.688842, 1728.204956, 15.889284, 185.440017},
	{-2541.593017, 42.217430, 27.734191, 278.973846},
	{-2457.039062, 146.560745, 26.165187, 179.614120},
	{-2478.711669, 28.149408, 26.415000, 219.635543}
};

new Float: g_TaxiParkDestPos[TAXI_PARK_DEST_COUNT][4] =
{
	{-2327.418457, -175.992324, 26.805496, 322.336700},
	{-2244.730712, -296.057708, 27.581912, 264.477905},
	{-2216.264160, -297.475341, 27.878917, 272.384185},
	{-2178.774169, -240.560287, 26.617984, 351.832855},
	{-2319.576904, 73.257209, 26.525085, 96.803176},
	{-2373.531982, 57.277076, 26.587593, 183.950241},
	{-2375.809082, 32.612709, 26.577419, 177.763092},
	{-2376.391601, 6.827797, 26.566242, 174.845932},
	{-2334.160888, -13.084966, 26.426216, 265.803649},
	{1953.213012, 1718.885498, 16.003572, 54.546764},
	{1949.738891, 1753.821777, 15.397899, 37.677158},
	{1979.854614, 1746.535888, 15.738937, 0.930935},
	{1980.544799, 1777.199707, 15.624352, 345.255249},
	{1951.654296, 1809.611328, 15.564719, 47.618633},
	{1953.909057, 1896.671386, 15.557974, 9.347331},
	{2381.960937, 1666.193359, 13.750861, 53.705459}
};

new g_TaxiPark_PendingHire[MAX_PLAYERS];
new g_TaxiPark_PlayerOrderTimer[MAX_PLAYERS];
new g_TaxiPark_PlayerReturnTimer[MAX_PLAYERS];
new g_TaxiPark_AvailableOrders[MAX_PLAYERS][TAXI_PARK_NPC_COUNT];
new g_TaxiPark_AvailableOrderCount[MAX_PLAYERS];
new g_TaxiPark_SelectedOrder[MAX_PLAYERS];
new g_TaxiPark_ArriveTimer[MAX_PLAYERS];

stock TaxiPark_GetPlayerJob(playerid)
{
	new job = GetPVarInt(playerid, TAXI_PARK_PVAR_JOB);
	if(job <= 0) return -1;
	return job - 1;
}

stock TaxiPark_SetPlayerJob(playerid, park_id)
{
	SetPVarInt(playerid, TAXI_PARK_PVAR_JOB, park_id + 1);
	UpdatePlayerDatabaseInt(playerid, "taxi_park", park_id);
	return 1;
}

stock TaxiPark_RemovePlayerJob(playerid)
{
	SetPVarInt(playerid, TAXI_PARK_PVAR_JOB, 0);
	UpdatePlayerDatabaseInt(playerid, "taxi_park", -1);
	TaxiPark_DestroyPlayerVehicle(playerid);
	TaxiPark_CancelOrder(playerid);
	return 1;
}

stock TaxiPark_LoadJobFromDB(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new query[160], name[24];
	GetPlayerName(playerid, name, sizeof name);
	mysql_format(mysql, query, sizeof query, "SELECT `taxi_park` FROM `accounts` WHERE `name`='%e' LIMIT 1", name);
	mysql_tquery(mysql, query, "TaxiPark_OnJobLoaded", "i", playerid);
	return 1;
}

public TaxiPark_OnJobLoaded(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new rows = cache_num_rows();
	if(rows > 0)
	{
		new park_id = cache_get_field_content_int(0, "taxi_park");
		if(park_id >= 0 && park_id < TAXI_PARK_COUNT)
			SetPVarInt(playerid, TAXI_PARK_PVAR_JOB, park_id + 1);
		else
			SetPVarInt(playerid, TAXI_PARK_PVAR_JOB, 0);
	}
	return 1;
}

stock TaxiPark_Init()
{
	mysql_tquery(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `taxi_park` INT NOT NULL DEFAULT -1");

	CreatePickup(1239, 1, 0.0, 0.0, 0.0, 999999);

	for(new i = 0; i < TAXI_PARK_COUNT; i++)
	{
		g_TaxiPark[i][TP_VIRTUAL_WORLD] = TAXI_PARK_VW_BASE + i;

		g_TaxiPark[i][TP_PICKUP_ENTER_ID] = CreatePickup(19132, 23,
			g_TaxiPark[i][TP_ENTER_X], g_TaxiPark[i][TP_ENTER_Y], g_TaxiPark[i][TP_ENTER_Z],
			0, PICKUP_ACTION_TYPE_TAXI_PARK_ENT, i);

		CreateDynamic3DTextLabel(g_TaxiPark[i][TP_LABEL_TEXT], g_TaxiPark[i][TP_LABEL_COLOR],
			g_TaxiPark[i][TP_ENTER_X], g_TaxiPark[i][TP_ENTER_Y], g_TaxiPark[i][TP_ENTER_Z] + 0.85, 15.0);

		g_TaxiPark[i][TP_PICKUP_EXIT_ID] = CreatePickup(TAXI_PARK_EXIT_PICKUP_MODEL, 23,
			TAXI_PARK_EXIT_X, TAXI_PARK_EXIT_Y, TAXI_PARK_EXIT_Z,
			g_TaxiPark[i][TP_VIRTUAL_WORLD], TAXI_PARK_ACTION_EXIT, i);

		CreateDynamic3DTextLabel("Выход", TAXI_PARK_COLOR_RED,
			TAXI_PARK_EXIT_X, TAXI_PARK_EXIT_Y, TAXI_PARK_EXIT_Z + 0.85, 15.0,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, g_TaxiPark[i][TP_VIRTUAL_WORLD], TAXI_PARK_INTERIOR_ID);

		g_TaxiPark[i][TP_PICKUP_HIRE_ID] = CreatePickup(TAXI_PARK_HIRE_PICKUP_MODEL, 23,
			TAXI_PARK_HIRE_X, TAXI_PARK_HIRE_Y, TAXI_PARK_HIRE_Z,
			g_TaxiPark[i][TP_VIRTUAL_WORLD], TAXI_PARK_ACTION_HIRE, i);

		g_TaxiPark[i][TP_PICKUP_AUTOPARK_ID] = CreatePickup(TAXI_PARK_AUTOPARK_PICKUP_MODEL, 23,
			g_TaxiPark[i][TP_AUTOPARK_X], g_TaxiPark[i][TP_AUTOPARK_Y], g_TaxiPark[i][TP_AUTOPARK_Z],
			0, TAXI_PARK_ACTION_AUTOPARK, i);

		CreateDynamic3DTextLabel("Автопарк", TAXI_PARK_COLOR_GREEN,
			g_TaxiPark[i][TP_AUTOPARK_X], g_TaxiPark[i][TP_AUTOPARK_Y], g_TaxiPark[i][TP_AUTOPARK_Z] + 0.85, 15.0);
	}

	printf("[TaxiPark] Загружено таксопарков: %d (автопарки + системные заказы)", TAXI_PARK_COUNT);
	return 1;
}

stock TaxiPark_OnEnter(playerid, park_id)
{
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 0;
	SetPlayerInterior(playerid, TAXI_PARK_INTERIOR_ID);
	SetPlayerVirtualWorld(playerid, g_TaxiPark[park_id][TP_VIRTUAL_WORLD]);
	SetPlayerPos(playerid, TAXI_PARK_INSIDE_X, TAXI_PARK_INSIDE_Y, TAXI_PARK_INSIDE_Z);
	SetPlayerFacingAngle(playerid, TAXI_PARK_INSIDE_A);
	return 1;
}

stock TaxiPark_OnExit(playerid, park_id)
{
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 0;
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid, g_TaxiPark[park_id][TP_EXIT_X], g_TaxiPark[park_id][TP_EXIT_Y], g_TaxiPark[park_id][TP_EXIT_Z]);
	SetPlayerFacingAngle(playerid, g_TaxiPark[park_id][TP_EXIT_A]);
	return 1;
}

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
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE) != 0)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть машина взятая с автопарка");
		return 1;
	}
	new caption[64], list[256];
	format(caption, sizeof caption, "%s | Автопарк", g_TaxiPark[park_id][TP_NAME]);
	list[0] = EOS;
	for(new i = 0; i < TAXI_PARK_CAR_COUNT; i++)
		format(list, sizeof list, "%s%s\n", list, g_TaxiParkCarNames[i]);
	SetPVarInt(playerid, TAXI_PARK_PVAR_PENDING_CAR, park_id);
	Dialog_Open(playerid, "TaxiPark_AutoparkResponse", DIALOG_STYLE_LIST, caption, list, "Выбрать", "Отмена");
	return 1;
}

Dialog_Response:TaxiPark_AutoparkResponse(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	new park_id = GetPVarInt(playerid, TAXI_PARK_PVAR_PENDING_CAR);
	if(park_id < 0 || park_id >= TAXI_PARK_COUNT) return 1;
	if(listitem < 0 || listitem >= TAXI_PARK_CAR_COUNT) return 1;
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE) != 0)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть машина взятая с автопарка");
		return 1;
	}
	new slot = random(TAXI_PARK_PARKING_SPOTS);
	new Float: px, Float: py, Float: pz, Float: pa;
	switch(slot)
	{
		case 0: { px = g_TaxiPark[park_id][TP_PARK1_X]; py = g_TaxiPark[park_id][TP_PARK1_Y]; pz = g_TaxiPark[park_id][TP_PARK1_Z]; pa = g_TaxiPark[park_id][TP_PARK1_A]; }
		case 1: { px = g_TaxiPark[park_id][TP_PARK2_X]; py = g_TaxiPark[park_id][TP_PARK2_Y]; pz = g_TaxiPark[park_id][TP_PARK2_Z]; pa = g_TaxiPark[park_id][TP_PARK2_A]; }
		default: { px = g_TaxiPark[park_id][TP_PARK3_X]; py = g_TaxiPark[park_id][TP_PARK3_Y]; pz = g_TaxiPark[park_id][TP_PARK3_Z]; pa = g_TaxiPark[park_id][TP_PARK3_A]; }
	}
	new model = g_TaxiParkCars[listitem];
	new vehicleid = CreateVehicle(model, px, py, pz, pa, 1, 1, -1);
	if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Не удалось создать машину, попробуйте позже");
		return 1;
	}
	SetVehicleVirtualWorld(vehicleid, 0);
	LinkVehicleToInterior(vehicleid, 0);
	SetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE, vehicleid);

	
	new label_str[64];
	format(label_str, sizeof label_str, "Таксопарк %s", g_TaxiPark[park_id][TP_NAME]);
	new Text3D:label = CreateDynamic3DTextLabel(label_str, 0xFFFF00FF, 0.0, 0.0, 1.3, 30.0, INVALID_PLAYER_ID, vehicleid);
	SetPVarInt(playerid, TAXI_PARK_PVAR_LABEL, _:label);

	
	new icon = GetPVarInt(playerid, TAXI_PARK_PVAR_ICON);
	if(icon != 0)
		RemovePlayerMapIcon(playerid, 99);
	SetPlayerMapIcon(playerid, 99, px, py, pz, 55, 0, MAPICON_LOCAL); 
	SetPVarInt(playerid, TAXI_PARK_PVAR_ICON, 99);

	SendClientMessage(playerid, -1, "{33FF33}| {ffffff}Машина отмечена на карте. Чтобы посмотреть список вызовов введите /challenge");
	TaxiPark_StartOrderTimer(playerid);
	return 1;
}

stock TaxiPark_DestroyPlayerVehicle(playerid)
{
	new vehicleid = GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE);
	new label = GetPVarInt(playerid, TAXI_PARK_PVAR_LABEL);
	if(label != 0)
	{
		DestroyDynamic3DTextLabel(Text3D:label);
		SetPVarInt(playerid, TAXI_PARK_PVAR_LABEL, 0);
	}
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_ICON) != 0)
	{
		RemovePlayerMapIcon(playerid, 99);
		SetPVarInt(playerid, TAXI_PARK_PVAR_ICON, 0);
	}
	if(vehicleid != 0 && GetVehicleModel(vehicleid) != 0)
		DestroyVehicle(vehicleid);
	SetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE, 0);
	if(g_TaxiPark_PlayerReturnTimer[playerid] != 0)
	{
		KillTimer(g_TaxiPark_PlayerReturnTimer[playerid]);
		g_TaxiPark_PlayerReturnTimer[playerid] = 0;
	}
	return 1;
}

public TaxiPark_ReturnVehicleTimer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new vehicleid = GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE);
	if(vehicleid == 0) return 0;
	if(IsPlayerInVehicle(playerid, vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		g_TaxiPark_PlayerReturnTimer[playerid] = 0;
		return 1;
	}
	TaxiPark_DestroyPlayerVehicle(playerid);
	TaxiPark_CancelOrder(playerid);
	SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Машина возвращена в автопарк");
	return 1;
}

stock TaxiPark_StartReturnTimer(playerid)
{
	if(g_TaxiPark_PlayerReturnTimer[playerid] != 0)
		KillTimer(g_TaxiPark_PlayerReturnTimer[playerid]);
	g_TaxiPark_PlayerReturnTimer[playerid] = SetTimerEx("TaxiPark_ReturnVehicleTimer", TAXI_PARK_RETURN_TIME * 1000, false, "i", playerid);
	new str[32];
	format(str, sizeof str, "~g~%d", TAXI_PARK_RETURN_TIME);
	GameTextForPlayer(playerid, str, 1000, 4);
	SetTimerEx("TaxiPark_UpdateReturnText", 1000, false, "ii", playerid, TAXI_PARK_RETURN_TIME - 1);
	return 1;
}

public TaxiPark_UpdateReturnText(playerid, seconds)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_TaxiPark_PlayerReturnTimer[playerid] == 0) return 0;
	new vehicleid = GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE);
	if(vehicleid == 0) return 0;
	if(IsPlayerInVehicle(playerid, vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		g_TaxiPark_PlayerReturnTimer[playerid] = 0;
		return 1;
	}
	if(seconds <= 0) return 1;
	new str[32];
	format(str, sizeof str, "~g~%d", seconds);
	GameTextForPlayer(playerid, str, 1000, 4);
	SetTimerEx("TaxiPark_UpdateReturnText", 1000, false, "ii", playerid, seconds - 1);
	return 1;
}

stock TaxiPark_StartOrderTimer(playerid)
{
	if(g_TaxiPark_PlayerOrderTimer[playerid] != 0)
		KillTimer(g_TaxiPark_PlayerOrderTimer[playerid]);
	new delay = TAXI_PARK_ORDER_MIN_TIME + random(TAXI_PARK_ORDER_MAX_TIME - TAXI_PARK_ORDER_MIN_TIME + 1);
	g_TaxiPark_PlayerOrderTimer[playerid] = SetTimerEx("TaxiPark_OrderTimer", delay * 1000, false, "i", playerid);
	return 1;
}

public TaxiPark_OrderTimer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new vehicleid = GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE);
	if(vehicleid == 0)
	{
		g_TaxiPark_PlayerOrderTimer[playerid] = 0;
		return 0;
	}
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE) != 0)
	{
		TaxiPark_StartOrderTimer(playerid);
		return 1;
	}
	new Float: px, Float: py, Float: pz;
	GetPlayerPos(playerid, px, py, pz);

	
	new candidates[TAXI_PARK_NPC_COUNT], cand_count;
	cand_count = 0;
	for(new i = 0; i < TAXI_PARK_NPC_COUNT; i++)
	{
		new Float: dist = GetDistanceBetweenPoints(px, py, pz, g_TaxiParkNpcPos[i][0], g_TaxiParkNpcPos[i][1], g_TaxiParkNpcPos[i][2]);
		if(dist >= TAXI_PARK_MIN_ORDER_DIST)
		{
			candidates[cand_count] = i;
			cand_count++;
		}
	}

	
	g_TaxiPark_AvailableOrderCount[playerid] = 0;
	if(cand_count > 0)
	{
		new pick = candidates[random(cand_count)];
		g_TaxiPark_AvailableOrders[playerid][0] = pick;
		g_TaxiPark_AvailableOrderCount[playerid] = 1;
		ShowNotificationSile(playerid, 4, 6, TAXI_PARK_NOTIFICATION_ID, 0, "Поступил новый вызов", ">>");
	}
	TaxiPark_StartOrderTimer(playerid);
	return 1;
}

stock Float: GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
	return floatsqroot(floatpower(x1 - x2, 2.0) + floatpower(y1 - y2, 2.0) + floatpower(z1 - z2, 2.0));
}

public TaxiPark_NotificationClick(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	TaxiPark_ShowChallengeDialog(playerid);
	return 1;
}

stock TaxiPark_ShowChallengeDialog(playerid)
{
	new park_id = TaxiPark_GetPlayerJob(playerid);
	if(park_id == -1)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не устроены ни в одном таксопарке");
		return 1;
	}
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE) == 0)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Сначала возьмите машину в автопарке");
		return 1;
	}
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE) != 0)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть активный вызов");
		return 1;
	}
	new caption[64];
	format(caption, sizeof caption, "%s | Список вызовов", g_TaxiPark[park_id][TP_NAME]);
	if(g_TaxiPark_AvailableOrderCount[playerid] <= 0)
	{
		Dialog_Open(playerid, "TaxiPark_ChallengeResponse", DIALOG_STYLE_MSGBOX, caption, "На данный момент вызовов нету", "Закрыть", "");
		return 1;
	}
	new Float: px, Float: py, Float: pz;
	GetPlayerPos(playerid, px, py, pz);
	new list[512];
	list[0] = EOS;
	for(new i = 0; i < g_TaxiPark_AvailableOrderCount[playerid]; i++)
	{
		new npc_idx = g_TaxiPark_AvailableOrders[playerid][i];
		new Float: dist = GetDistanceBetweenPoints(px, py, pz, g_TaxiParkNpcPos[npc_idx][0], g_TaxiParkNpcPos[npc_idx][1], g_TaxiParkNpcPos[npc_idx][2]);
		format(list, sizeof list, "%sВызов %d  %.0fm\n", list, i + 1, dist);
	}
	Dialog_Open(playerid, "TaxiPark_ChallengeResponse", DIALOG_STYLE_LIST, caption, list, "Выбрать", "Закрыть");
	return 1;
}

cmd:challenge(playerid, params[])
{
	return TaxiPark_ShowChallengeDialog(playerid);
}

Dialog_Response:TaxiPark_ChallengeResponse(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(g_TaxiPark_AvailableOrderCount[playerid] <= 0) return 1;
	if(listitem < 0 || listitem >= g_TaxiPark_AvailableOrderCount[playerid]) return 1;
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE) != 0)
	{
		SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть активный вызов");
		return 1;
	}
	new npc_idx = g_TaxiPark_AvailableOrders[playerid][listitem];
	g_TaxiPark_SelectedOrder[playerid] = npc_idx;
	new Float: nx = g_TaxiParkNpcPos[npc_idx][0];
	new Float: ny = g_TaxiParkNpcPos[npc_idx][1];
	new Float: nz = g_TaxiParkNpcPos[npc_idx][2];
	new Float: na = g_TaxiParkNpcPos[npc_idx][3];
	new actorid = CreateActor(67, nx, ny, nz, na);
	SetPVarInt(playerid, TAXI_PARK_PVAR_ACTOR, actorid);
	new Float: px, Float: py, Float: pz;
	GetPlayerPos(playerid, px, py, pz);
	new Float: dist = GetDistanceBetweenPoints(px, py, pz, nx, ny, nz);
	SetPVarFloat(playerid, TAXI_PARK_PVAR_ORDER_DIST, dist);
	SetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE, 1);
	EnablePlayerGPS(playerid, 0, nx, ny, nz, "Клиент отмечен на карте");
	if(g_TaxiPark_ArriveTimer[playerid] != 0) KillTimer(g_TaxiPark_ArriveTimer[playerid]);
	g_TaxiPark_ArriveTimer[playerid] = SetTimerEx("TaxiPark_CheckArrive", 1000, true, "i", playerid);
	SendClientMessage(playerid, -1, "{33FF33}| {ffffff}Вызов принят. Езжайте к клиенту.");
	return 1;
}

public TaxiPark_CheckArrive(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new stage = GetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE);
	if(stage == 0) return 0;
	new vehicleid = GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE);
	if(vehicleid == 0 || !IsPlayerInVehicle(playerid, vehicleid)) return 1;
	if(stage == 1)
	{
		new npc_idx = g_TaxiPark_SelectedOrder[playerid];
		new Float: nx = g_TaxiParkNpcPos[npc_idx][0];
		new Float: ny = g_TaxiParkNpcPos[npc_idx][1];
		new Float: nz = g_TaxiParkNpcPos[npc_idx][2];
		if(IsPlayerInRangeOfPoint(playerid, 8.0, nx, ny, nz))
		{
			new actorid = GetPVarInt(playerid, TAXI_PARK_PVAR_ACTOR);
			if(actorid != 0)
			{
				DestroyActor(actorid);
				SetPVarInt(playerid, TAXI_PARK_PVAR_ACTOR, 0);
			}
			DisablePlayerGPS(playerid);
			new dest_idx = -1, tries = 0;
			while(tries < 30)
			{
				new idx = random(TAXI_PARK_DEST_COUNT);
				new Float: ddist = GetDistanceBetweenPoints(nx, ny, nz, g_TaxiParkDestPos[idx][0], g_TaxiParkDestPos[idx][1], g_TaxiParkDestPos[idx][2]);
				if(ddist >= TAXI_PARK_MIN_DEST_DIST)
				{
					dest_idx = idx;
					break;
				}
				tries++;
			}
			if(dest_idx == -1) dest_idx = random(TAXI_PARK_DEST_COUNT);
			new Float: dx = g_TaxiParkDestPos[dest_idx][0];
			new Float: dy = g_TaxiParkDestPos[dest_idx][1];
			new Float: dz = g_TaxiParkDestPos[dest_idx][2];
			SetPVarFloat(playerid, TAXI_PARK_PVAR_DEST_X, dx);
			SetPVarFloat(playerid, TAXI_PARK_PVAR_DEST_Y, dy);
			SetPVarFloat(playerid, TAXI_PARK_PVAR_DEST_Z, dz);
			new Float: trip_dist = GetDistanceBetweenPoints(nx, ny, nz, dx, dy, dz);
			SetPVarFloat(playerid, TAXI_PARK_PVAR_ORDER_DIST, trip_dist);
			SetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE, 2);
			ShowNotificationSile(playerid, 3, 5, 0, 0, "Вы подобрали клиента, довезите его до нужного места.", "");
			EnablePlayerGPS(playerid, 0, dx, dy, dz, "Место назначения отмечено на карте");
		}
	}
	else if(stage == 2)
	{
		new Float: dx = GetPVarFloat(playerid, TAXI_PARK_PVAR_DEST_X);
		new Float: dy = GetPVarFloat(playerid, TAXI_PARK_PVAR_DEST_Y);
		new Float: dz = GetPVarFloat(playerid, TAXI_PARK_PVAR_DEST_Z);
		if(IsPlayerInRangeOfPoint(playerid, 8.0, dx, dy, dz))
		{
			DisablePlayerGPS(playerid);
			new Float: trip_dist = GetPVarFloat(playerid, TAXI_PARK_PVAR_ORDER_DIST);
			new payment = floatround(trip_dist / 100.0) * TAXI_PARK_PAY_PER_100M;
			if(payment < 500) payment = 500;
			GivePlayerMoneyEx(playerid, payment, "Заказ такси", true, true);
			new msg[128];
			format(msg, sizeof msg, "{33FF33}| {ffffff}Вы довезли клиента. Заработано: %dруб", payment);
			SendClientMessage(playerid, -1, msg);
			ShowNotificationSile(playerid, 3, 5, 0, 0, "Клиент доставлен. Заказ выполнен!", "");
			TaxiPark_CancelOrder(playerid);
		}
	}
	return 1;
}

stock TaxiPark_CancelOrder(playerid)
{
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE) == 0) return 1;
	new actorid = GetPVarInt(playerid, TAXI_PARK_PVAR_ACTOR);
	if(actorid != 0)
	{
		DestroyActor(actorid);
		SetPVarInt(playerid, TAXI_PARK_PVAR_ACTOR, 0);
	}
	DisablePlayerGPS(playerid);
	if(g_TaxiPark_ArriveTimer[playerid] != 0)
	{
		KillTimer(g_TaxiPark_ArriveTimer[playerid]);
		g_TaxiPark_ArriveTimer[playerid] = 0;
	}
	SetPVarInt(playerid, TAXI_PARK_PVAR_ORDER_STAGE, 0);
	SetPVarFloat(playerid, TAXI_PARK_PVAR_ORDER_DIST, 0.0);
	g_TaxiPark_SelectedOrder[playerid] = -1;
	return 1;
}

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
	new msg[128];
	format(msg, sizeof msg, "{33FF33}| {ffffff}Вы уволились из таксопарка %s", g_TaxiPark[park_id][TP_NAME]);
	SendClientMessage(playerid, -1, msg);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPVarInt(playerid, TAXI_PARK_PVAR_VEHICLE);
	if(vehicleid != 0)
	{
		if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
		{
			if(!IsPlayerInVehicle(playerid, vehicleid))
				TaxiPark_StartReturnTimer(playerid);
		}
		else if(newstate == PLAYER_STATE_DRIVER && IsPlayerInVehicle(playerid, vehicleid))
		{
			if(g_TaxiPark_PlayerReturnTimer[playerid] != 0)
			{
				KillTimer(g_TaxiPark_PlayerReturnTimer[playerid]);
				g_TaxiPark_PlayerReturnTimer[playerid] = 0;
			}
			
			if(GetPVarInt(playerid, TAXI_PARK_PVAR_ICON) != 0)
			{
				RemovePlayerMapIcon(playerid, 99);
				SetPVarInt(playerid, TAXI_PARK_PVAR_ICON, 0);
			}
		}
	}
	#if defined TaxiPark_OnPlayerStateChange
		return TaxiPark_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange TaxiPark_OnPlayerStateChange
#if defined TaxiPark_OnPlayerStateChange
	forward TaxiPark_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	TaxiPark_DestroyPlayerVehicle(playerid);
	TaxiPark_CancelOrder(playerid);
	if(g_TaxiPark_PlayerOrderTimer[playerid] != 0)
	{
		KillTimer(g_TaxiPark_PlayerOrderTimer[playerid]);
		g_TaxiPark_PlayerOrderTimer[playerid] = 0;
	}
	#if defined TaxiPark_OnPlayerDisconnect
		return TaxiPark_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect TaxiPark_OnPlayerDisconnect
#if defined TaxiPark_OnPlayerDisconnect
	forward TaxiPark_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerSpawn(playerid)
{
	
	if(GetPVarInt(playerid, TAXI_PARK_PVAR_JOB) == 0 && GetPVarInt(playerid, "TaxiParkJobLoaded") == 0)
	{
		SetPVarInt(playerid, "TaxiParkJobLoaded", 1);
		TaxiPark_LoadJobFromDB(playerid);
	}
	#if defined TaxiPark_OnPlayerSpawn
		return TaxiPark_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn TaxiPark_OnPlayerSpawn
#if defined TaxiPark_OnPlayerSpawn
	forward TaxiPark_OnPlayerSpawn(playerid);
#endif

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	switch(action_type)
	{
		case TAXI_PARK_ACTION_EXIT: TaxiPark_OnExit(playerid, action_id);
		case TAXI_PARK_ACTION_HIRE: TaxiPark_OnHirePickup(playerid, action_id);
		case TAXI_PARK_ACTION_AUTOPARK: TaxiPark_OnAutoparkPickup(playerid, action_id);
	}
	return TaxiPark_Legacy_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
}
#if defined _ALS_OnPlayerPickUpPickupEx
	#undef OnPlayerPickUpPickupEx
#else
	#define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx TaxiPark_Legacy_OnPlayerPickUpPickupEx
