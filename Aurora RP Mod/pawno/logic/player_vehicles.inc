#if defined _player_vehicles_included
	#endinput
#endif
#define _player_vehicles_included

#define MAX_PLAYER_VEHICLES			10
#define MAX_PLAYER_VEHICLE_KEYS		3

#define VEHICLE_ON_DESTROY_TIMER	(5 * 60)  // раз в 5 мин
//#define VEHICLE_DESTROY_TIMER		(30 * 60) // (30 * 60) // полчаса

#define TABLE_VEHICLES				"vehicles"

#define PLAYER_VEHICLE_MIN_HEATH	310.0

#define FIX_CAR_PARK_PRICE			300
#define FIX_CAR_PARK_LS_PRICE		300
#define FIX_CAR_PLAYER_PRICE		300
#define FIX_CAR_HOUSE_PRICE			500
#define FIX_CAR_GARAGE_PRICE		500

new const Float:ticketVehicleSpawnPos[][4] = {
	// ( 2 stage )
	{ 2817.7700, -1433.31, 19.9027, 90.0000 },
	{ 2817.7700, -1436.31, 19.9027, 90.0000 },
	{ 2817.7700, -1439.31, 19.9027, 90.0000 },
	{ 2817.7700, -1452.31, 19.9027, 90.0000 },
	{ 2817.7700, -1455.31, 19.9027, 90.0000 },
	{ 2817.7700, -1458.31, 19.9027, 90.0000 },
	{ 2817.7700, -1461.31, 19.9027, 90.0000 },
	{ 2817.7700, -1464.31, 19.9027, 90.0000 },
	{ 2792.3600, -1433.31, 19.9027, 270.000 },
	{ 2792.3600, -1436.31, 19.9027, 270.000 },
	{ 2792.3600, -1439.31, 19.9027, 270.000 },
	{ 2792.3600, -1452.31, 19.9027, 270.000 },
	{ 2792.3600, -1455.31, 19.9027, 270.000 },
	// ( 3 stage )
	{ 2817.7700, -1433.31, 23.8428, 90.0000 },
	{ 2817.7700, -1436.31, 23.8428, 90.0000 },
	{ 2817.7700, -1439.31, 23.8428, 90.0000 },
	{ 2817.7700, -1452.31, 23.8428, 90.0000 },
	{ 2817.7700, -1455.31, 23.8428, 90.0000 },
	{ 2817.7700, -1458.31, 23.8428, 90.0000 },
	{ 2817.7700, -1461.31, 23.8428, 90.0000 },
	{ 2817.7700, -1464.31, 23.8428, 90.0000 },
	{ 2792.3600, -1433.31, 23.8428, 270.000 },
	{ 2792.3600, -1436.31, 23.8428, 270.000 },
	{ 2792.3600, -1439.31, 23.8428, 270.000 },
	{ 2792.3600, -1452.31, 23.8428, 270.000 },
	{ 2792.3600, -1455.31, 23.8428, 270.000 },
	// ( 4 stage )
	{ 2817.7700, -1433.31, 27.8364, 90.0000 },
	{ 2817.7700, -1436.31, 27.8364, 90.0000 },
	{ 2817.7700, -1439.31, 27.8364, 90.0000 },
	{ 2817.7700, -1452.31, 27.8364, 90.0000 },
	{ 2817.7700, -1455.31, 27.8364, 90.0000 },
	{ 2817.7700, -1458.31, 27.8364, 90.0000 },
	{ 2817.7700, -1461.31, 27.8364, 90.0000 },
	{ 2817.7700, -1464.31, 27.8364, 90.0000 },
	{ 2792.3600, -1433.31, 27.8364, 270.000 },
	{ 2792.3600, -1436.31, 27.8364, 270.000 },
	{ 2792.3600, -1439.31, 27.8364, 270.000 },
	{ 2792.3600, -1452.31, 27.8364, 270.000 },
	{ 2792.3600, -1455.31, 27.8364, 270.000 }
}; 
#define MAX_VEHICLES_PLAYER		1500

new Iterator:playerVehicles<MAX_VEHICLES_PLAYER>;

enum PLAYER_VEHICLE_E {
	carID,
	carVehicle,
	carOwner[MAX_PLAYER_NAME + 2],
	carKeys[MAX_PLAYER_VEHICLE_KEYS],
	carModel,
	carOwnerID,
	carColor[2],
	Float:carDrived,
	Float:carFuel,
	Float:carStatus,
	carVehcom[14],
	carPaintJob,
	carNumber[32],
	carDestroyTimer,
	carInterior,
	carWorld,
	Float:carPos[4],
	carOrganization,
	carParked,
	carItemsID[6 * 3],
	carItemsAmount[6 * 3],
}
new
	PlayerVehicleInfo[MAX_VEHICLES_PLAYER][PLAYER_VEHICLE_E],
	playerVehicleID[MAX_PLAYERS][MAX_PLAYER_VEHICLES],
	playerVehicleAmount[MAX_PLAYERS],
	playerVehicleListitemID[MAX_PLAYERS][MAX_PLAYER_VEHICLES + 1];

new ParkingFineBarrier[2], ParkingFineBarrierStatus[2];

pv_OnGameModeInit() {
	ParkingFineBarrier[0] = CreateDynamicObject(968, 2311.460693, 1383.508911, 10.610315, 0.0, -45.0, 0.000, 0, 0, -1, 200.00, 200.00);
	ParkingFineBarrier[1] = CreateDynamicObject(968, 2303.098876, 1522.929565, 10.610315, 0.0, -45.0, 180.0, 0, 0, -1, 200.00, 200.00);

	#pragma unused ParkingFineBarrier, ParkingFineBarrierStatus

	CreateDynamicObject(966, 2311.373291, 1383.514404, 9.800311, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00);
	CreateDynamicObject(966, 2303.182861, 1522.932373, 9.800311, 0.000000, 0.000000, 180.0000, 0, 0, -1, 200.00, 200.00);
	CreateDynamicObject(997, 2312.996826, 1383.527709, 9.820316, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00);
	CreateDynamicObject(994, 2297.591308, 1383.502319, 9.820311, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00);
	CreateDynamicObject(994, 2310.823242, 1522.932983, 9.820311, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00);
	CreateDynamicObject(997, 2298.547607, 1522.929077, 9.820316, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00);

	CreateDynamicMapIcon(-1896.9404, -1677.2861, 23.0156, 55, 0xFF0000FF);

	CreateDynamic3DTextLabel(""P"Утилизация транспорта\n \n"W"Чтобы утилизировать транспорт, нажмите "P"\"ALT\"", 0xFFFFFFFF,
		-1896.9404, -1677.2861, 23.0156, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	);
	CreateDynamicObjectCP(-1896.9404, -1677.2861, 23.0156, 10.0);
	CreateDynamicPickup(1239, 23, -1896.9404, -1677.2861, 23.0156, 0, 0);

	new actorid = CreateActor(24, -1897.3003, -1678.5994, 23.0156, 330.9810);
	SetActorVirtualWorld(actorid, 0);
	ApplyActorAnimation(actorid, "DEALER", "Dealer_idle", 4.1, 0, 0, 0, 1, 1);


	CreateDynamicMapIcon(2820.2314, -1469.8209, 16.2568, 55, 0xFF0000FF);

	CreateDynamic3DTextLabel(""P"Штрафстоянка\n \n"W"Чтобы оплатить транспорт, нажмите "P"\"ALT\"", 0xFFFFFFFF,
		2820.2314, -1469.8209, 16.2568, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	);
	CreateDynamicPickup(1239, 23, 2820.2314, -1469.8209, 16.2568, 0, 0);

	CreateDynamicObjectCP(2820.2314, -1469.8209, 16.2568);


	CreateDynamic3DTextLabel(""P"( Для полиции )\n \n"W"Чтобы выставить транспорт, нажмите "P"\"H\"", 0xFFFFFFFF,
		2800.7239, -1464.1243, 16.2241, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	);
	CreateDynamicPickup(19134, 23, 2800.7239, -1464.1243, 16.2241, 0, 0);
	CreateDynamicObjectCP(2800.7239, -1464.1243, 16.2241);
}
stock IsPlayerVehicleID(playerid, vehicleid) {
	new id = 0;
	if (!GetPlayerVehicles(playerid)) 
		return id;

	for (new i = 0, player_vehicle_id = -1; i < MAX_PLAYER_VEHICLES; i++) {
		player_vehicle_id = playerVehicleID[playerid][i];
		if (player_vehicle_id == -1) continue;

		if (vehicleid == PlayerVehicleInfo[player_vehicle_id][carVehicle]) {
			id = 1;
			break;
		}
	}
	return id;
}
stock GetPlayerVehicleSlotID(playerid, vehicleid) {
	new slot = -1;
	if (!GetPlayerVehicles(playerid)) 
		return slot;

	for (new i = 0, player_vehicle_id = -1; i < MAX_PLAYER_VEHICLES; i++) {
		player_vehicle_id = playerVehicleID[playerid][i];
		if (player_vehicle_id == -1) continue;
		if (vehicleid == PlayerVehicleInfo[player_vehicle_id][carVehicle]) {
			slot = i;
			break;
		}
	}
	return slot;
}
stock GetNearestPlayerVehicle(playerid) {
	new id = -1;
	if (!GetPlayerVehicles(playerid)) 
		return id;
	new Float:vehiclePos[3];

	for (new i = 0, player_vehicle_id = -1; i < MAX_PLAYER_VEHICLES; i++) {
		player_vehicle_id = playerVehicleID[playerid][i];
		if (player_vehicle_id == -1) continue;
		GetVehiclePos(PlayerVehicleInfo[player_vehicle_id][carVehicle], vehiclePos[0], vehiclePos[1], vehiclePos[2]);

		if (PlayerToPoint(4.0, playerid, vehiclePos[0], vehiclePos[1], vehiclePos[2]) && GetVehicleVirtualWorld(PlayerVehicleInfo[player_vehicle_id][carVehicle]) == GetPlayerVirtualWorld(playerid))  {
			id = player_vehicle_id;
			break;
		}
	}
	return id;
}
stock pv_OnPlayerDisconnect(playerid) {
	if (GetPlayerVehicles(playerid)) for (new i = 0, player_vehicleid; i < MAX_PLAYER_VEHICLES; i++) {
		player_vehicleid = playerVehicleID[playerid][i];
		if (player_vehicleid == -1) continue;
		if (PlayerVehicleInfo[player_vehicleid][carOwnerID] == playerid) {
			PlayerVehicleInfo[player_vehicleid][carOwnerID] = INVALID_PLAYER_ID;
		}
	}
} 
stock GetPlayerVehicles(playerid) {
	playerVehicleAmount[playerid] = 0;

	foreach (new player_vehicleid: playerVehicles) {
		if (strcmp(PlayerVehicleInfo[player_vehicleid][carOwner], player_name[playerid]))
			continue;
		playerVehicleID[playerid][playerVehicleAmount[playerid]] = player_vehicleid;
		PlayerVehicleInfo[player_vehicleid][carOwnerID] = playerid;

		if (++playerVehicleAmount[playerid] >= MAX_PLAYER_VEHICLES) break;
	}
	return playerVehicleAmount[playerid];
}

stock GetPlayerVehicleCarID(playerid) {
	new 
		vehicle_amount = GetPlayerVehicles(playerid),
		vehicleid = GetPlayerVehicleID(playerid), player_vehicle_id = -1;

	if (vehicle_amount) for (new i = 0, player_vehicleid; i < MAX_PLAYER_VEHICLES; i++) {
		player_vehicleid = playerVehicleID[playerid][i];
		if (player_vehicleid == -1) continue;
		if (PlayerVehicleInfo[player_vehicleid][carVehicle] != vehicleid) continue;
		player_vehicle_id = player_vehicleid;
	}
	return player_vehicle_id;
}

stock LoadPlayerVehicles() {
	new Cache: result, rows;
	result = mysql_query(connects, "SELECT * FROM `"TABLE_VEHICLES"`");
	rows = cache_num_rows();

	if (!rows)  {
		print("[Загрузка...] Транспорт игроков не найден в базе данных.");
		cache_delete(result);
		return;
	}
	new vpanels, vdoors, vlights, vtires, Float:vhealth, itemsID[90], itemsAmount[90];

	for (new idx = 1, vehicleid; idx <= rows; idx++) {
		new i = (idx - 1), player_vehicleid = i; 
		if (i >= MAX_VEHICLES_PLAYER) continue;
		Iter_Add(playerVehicles, player_vehicleid);

		cache_get_value_name_int(i, "id", PlayerVehicleInfo[player_vehicleid][carID]);
		cache_get_value_name_int(i, "model", PlayerVehicleInfo[player_vehicleid][carModel]);
		cache_get_value_name(i, "owner", PlayerVehicleInfo[player_vehicleid][carOwner], MAX_PLAYER_NAME + 2);

		cache_get_value_name_int(i, "color_one", PlayerVehicleInfo[player_vehicleid][carColor][0]);
		cache_get_value_name_int(i, "color_two", PlayerVehicleInfo[player_vehicleid][carColor][1]);

		cache_get_value_name_float(i, "status", PlayerVehicleInfo[player_vehicleid][carStatus]);
		cache_get_value_name_float(i, "drived", PlayerVehicleInfo[player_vehicleid][carDrived]);
		cache_get_value_name_float(i, "fuel", PlayerVehicleInfo[player_vehicleid][carFuel]);

		cache_get_value_name_float(i, "x", PlayerVehicleInfo[player_vehicleid][carPos][0]);
		cache_get_value_name_float(i, "y", PlayerVehicleInfo[player_vehicleid][carPos][1]);
		cache_get_value_name_float(i, "z", PlayerVehicleInfo[player_vehicleid][carPos][2]);
		cache_get_value_name_float(i, "angle", PlayerVehicleInfo[player_vehicleid][carPos][3]);

		cache_get_value_name_int(i, "panels", vpanels);
		cache_get_value_name_int(i, "doors", vdoors);
		cache_get_value_name_int(i, "lights", vlights);
		cache_get_value_name_int(i, "tires", vtires);
		cache_get_value_name_float(i, "health", vhealth);

		cache_get_value_name_int(i, "interior", PlayerVehicleInfo[player_vehicleid][carInterior]);
		cache_get_value_name_int(i, "world", PlayerVehicleInfo[player_vehicleid][carWorld]);

		cache_get_value_name_int(i, "vehcom_1", PlayerVehicleInfo[player_vehicleid][carVehcom][0]);
		cache_get_value_name_int(i, "vehcom_2", PlayerVehicleInfo[player_vehicleid][carVehcom][1]);
		cache_get_value_name_int(i, "vehcom_3", PlayerVehicleInfo[player_vehicleid][carVehcom][2]);
		cache_get_value_name_int(i, "vehcom_4", PlayerVehicleInfo[player_vehicleid][carVehcom][3]);
		cache_get_value_name_int(i, "vehcom_5", PlayerVehicleInfo[player_vehicleid][carVehcom][4]);
		cache_get_value_name_int(i, "vehcom_6", PlayerVehicleInfo[player_vehicleid][carVehcom][5]);
		cache_get_value_name_int(i, "vehcom_7", PlayerVehicleInfo[player_vehicleid][carVehcom][6]);
		cache_get_value_name_int(i, "vehcom_8", PlayerVehicleInfo[player_vehicleid][carVehcom][7]);
		cache_get_value_name_int(i, "vehcom_9", PlayerVehicleInfo[player_vehicleid][carVehcom][8]);
		cache_get_value_name_int(i, "vehcom_10", PlayerVehicleInfo[player_vehicleid][carVehcom][9]);
		cache_get_value_name_int(i, "vehcom_11", PlayerVehicleInfo[player_vehicleid][carVehcom][10]);
		cache_get_value_name_int(i, "vehcom_12", PlayerVehicleInfo[player_vehicleid][carVehcom][11]);
		cache_get_value_name_int(i, "vehcom_13", PlayerVehicleInfo[player_vehicleid][carVehcom][12]);
		cache_get_value_name_int(i, "vehcom_14", PlayerVehicleInfo[player_vehicleid][carVehcom][13]);

		cache_get_value_name_int(i, "parked", PlayerVehicleInfo[player_vehicleid][carParked]);
		cache_get_value_name_int(i, "organization", PlayerVehicleInfo[player_vehicleid][carOrganization]);

		cache_get_value_name(i, "number", PlayerVehicleInfo[player_vehicleid][carNumber], 32);

		cache_get_value_name_int(i, "paintjob", PlayerVehicleInfo[player_vehicleid][carPaintJob]);

		cache_get_value_name(i, "itemsID", itemsID, sizeof (itemsID));
		cache_get_value_name(i, "itemsAmount", itemsAmount, sizeof (itemsAmount));

		sscanf(itemsID, "p<,>a<i>[18]", PlayerVehicleInfo[player_vehicleid][carItemsID]);
		sscanf(itemsAmount, "p<,>a<i>[18]", PlayerVehicleInfo[player_vehicleid][carItemsAmount]);

		cache_get_value_name(i, "keysID", itemsID, sizeof (itemsID));
		sscanf(itemsID, "p<,>a<i>["#MAX_PLAYER_VEHICLE_KEYS"]", PlayerVehicleInfo[player_vehicleid][carKeys]);

		if (PlayerVehicleInfo[player_vehicleid][carPos][0] == 0.0 && PlayerVehicleInfo[player_vehicleid][carPos][1] == 0.0) {
			new random_spawn = random(sizeof (ticketVehicleSpawnPos));

			PlayerVehicleInfo[player_vehicleid][carPos][0] = ticketVehicleSpawnPos[random_spawn][0];
			PlayerVehicleInfo[player_vehicleid][carPos][1] = ticketVehicleSpawnPos[random_spawn][1];
			PlayerVehicleInfo[player_vehicleid][carPos][2] = ticketVehicleSpawnPos[random_spawn][2];
			PlayerVehicleInfo[player_vehicleid][carPos][3] = ticketVehicleSpawnPos[random_spawn][3];

			PlayerVehicleInfo[player_vehicleid][carInterior] = 0;
			PlayerVehicleInfo[player_vehicleid][carWorld] = 0;
			PlayerVehicleInfo[player_vehicleid][carParked] = 0;
		}
		UpdatePlayerVehiclePosition(player_vehicleid, 0);

		PlayerVehicleInfo[player_vehicleid][carVehicle] = vehicleid = A_CreateVehicle(PlayerVehicleInfo[player_vehicleid][carModel],
			PlayerVehicleInfo[player_vehicleid][carPos][0], PlayerVehicleInfo[player_vehicleid][carPos][1],
			PlayerVehicleInfo[player_vehicleid][carPos][2], PlayerVehicleInfo[player_vehicleid][carPos][3],
			PlayerVehicleInfo[player_vehicleid][carColor][0], PlayerVehicleInfo[player_vehicleid][carColor][1],
			-1, VEHICLE_TYPE_PLAYER
		);
		VehicleInfo[vehicleid][vPlayerVehicleID] = player_vehicleid;
		SetVehicleToRespawn(vehicleid);

		SetVehicleHealth(vehicleid, (vhealth < PLAYER_VEHICLE_MIN_HEATH) ? (vhealth = PLAYER_VEHICLE_MIN_HEATH) : (vhealth));
		UpdateVehicleDamageStatus(vehicleid, vpanels, vdoors, vlights, vtires);

		VehicleInfo[vehicleid][vFuel] = PlayerVehicleInfo[player_vehicleid][carFuel];
		VehicleInfo[vehicleid][vDrived] = PlayerVehicleInfo[player_vehicleid][carDrived];
		VehicleInfo[vehicleid][vOrganization] = PlayerVehicleInfo[player_vehicleid][carOrganization];
		VehicleInfo[vehicleid][vStatus] = PlayerVehicleInfo[player_vehicleid][carStatus];
		VehicleInfo[vehicleid][vParkingFine] = !PlayerVehicleInfo[player_vehicleid][carParked];

		for (new slotid = 0; slotid < (6 * 3); slotid++) {
			VehicleInfo[vehicleid][vItemsID][slotid] = PlayerVehicleInfo[player_vehicleid][carItemsID][slotid];
			VehicleInfo[vehicleid][vItemsAmount][slotid] = PlayerVehicleInfo[player_vehicleid][carItemsAmount][slotid];
		}

		PlayerVehicleInfo[player_vehicleid][carOwnerID] = INVALID_PLAYER_ID;
	}
	printf("[Загрузка ...] Транспорт игроков успешно загружен (%i шт.)", rows);

	cache_delete(result);
}
stock GetPlayerAvailableCars(playerid) {
	// #pragma unused playerid
	if (GetString(player_name[playerid], "Dev_Hub")) 
		return MAX_PLAYER_VEHICLES;
	else if (GetString(player_name[playerid], "redoctower")) 
		return MAX_PLAYER_VEHICLES;
	return 1;
}
stock DestroyPlayerVehicle(playerid, player_vehicle_id) {
	if (!(0 <= player_vehicle_id < MAX_VEHICLES_PLAYER)) 
		return false;
	if (!GetString(PlayerVehicleInfo[player_vehicle_id][carOwner], player_name[playerid]))
		return false;

	new 
		insert_id = PlayerVehicleInfo[player_vehicle_id][carID],
		vehicleid = PlayerVehicleInfo[player_vehicle_id][carVehicle], 
		PlayerVehicleInfo_NULL[PLAYER_VEHICLE_E];

	PlayerVehicleInfo[player_vehicle_id] = PlayerVehicleInfo_NULL;

	A_DestroyVehicle(vehicleid);
	Iter_Remove(playerVehicles, player_vehicle_id);

	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), 
		"DELETE FROM "TABLE_VEHICLES" WHERE id=%i LIMIT 1",
		insert_id
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;

	GetPlayerVehicles(playerid);
	return true;
}
stock CreatePlayerVehicle(playerid, model, Float:x, Float:y, Float:z, Float:angle, color_1, color_2, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:spawn_angle) {
	new vehicle_amount = GetPlayerVehicles(playerid);

	if (vehicle_amount + 1 > GetPlayerAvailableCars(playerid)) {
		ErrorMessage(playerid, "У вас максимальное количество ТС.");
		return 0;
	}
	if (Iter_Count(playerVehicles) >= MAX_VEHICLES_PLAYER) {
		print("CreatePlayerVehicle - Iter_Count(playerVehicles) >= MAX_VEHICLES_PLAYER");
		return 0;
	}
	new player_vehicleid = Iter_Free(playerVehicles), vehicleid = INVALID_VEHICLE_ID;
	Iter_Add(playerVehicles, player_vehicleid);

	PlayerVehicleInfo[player_vehicleid][carModel] = model;
	PlayerVehicleInfo[player_vehicleid][carStatus] = 100.0;
	PlayerVehicleInfo[player_vehicleid][carFuel] = 40.0;

	PlayerVehicleInfo[player_vehicleid][carPos][0] = x;
	PlayerVehicleInfo[player_vehicleid][carPos][1] = y;
	PlayerVehicleInfo[player_vehicleid][carPos][2] = z;
	PlayerVehicleInfo[player_vehicleid][carPos][3] = angle;
	PlayerVehicleInfo[player_vehicleid][carInterior] = 0;
	PlayerVehicleInfo[player_vehicleid][carWorld] = 0;

	PlayerVehicleInfo[player_vehicleid][carColor][0] = color_1;
	PlayerVehicleInfo[player_vehicleid][carColor][1] = color_2;
	PlayerVehicleInfo[player_vehicleid][carPaintJob] = 3;
	PlayerVehicleInfo[player_vehicleid][carParked] = 0;
	PlayerVehicleInfo[player_vehicleid][carDrived] = 0;

	UpdatePlayerVehiclePosition(player_vehicleid, 0, .save = 0);

	strmid(PlayerVehicleInfo[player_vehicleid][carOwner], player_name[playerid], 0, strlen(player_name[playerid]), MAX_PLAYER_NAME + 2);
	strmid(PlayerVehicleInfo[player_vehicleid][carNumber], "TRANSIT", 0, strlen("TRANSIT"), 32);

	PlayerVehicleInfo[player_vehicleid][carVehicle] = vehicleid = A_CreateVehicle(PlayerVehicleInfo[player_vehicleid][carModel],
		PlayerVehicleInfo[player_vehicleid][carPos][0], PlayerVehicleInfo[player_vehicleid][carPos][1],
		PlayerVehicleInfo[player_vehicleid][carPos][2], PlayerVehicleInfo[player_vehicleid][carPos][3],
		PlayerVehicleInfo[player_vehicleid][carColor][0], PlayerVehicleInfo[player_vehicleid][carColor][1],
		-1, VEHICLE_TYPE_PLAYER
	);
	VehicleInfo[vehicleid][vPlayerVehicleID] = player_vehicleid;
	SetVehicleToRespawn(vehicleid);

	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "INSERT INTO `"TABLE_VEHICLES"` \
		(`owner`, `model`, `color_one`, `color_two`, `x`, `y`, `z`, `angle`) VALUES \
		('%s', %i, %i, %i, '%.2f', '%.2f', '%.2f', '%.2f')",
		player_name[playerid], PlayerVehicleInfo[player_vehicleid][carModel],
		PlayerVehicleInfo[player_vehicleid][carColor][0], PlayerVehicleInfo[player_vehicleid][carColor][1],
		PlayerVehicleInfo[player_vehicleid][carPos][0], PlayerVehicleInfo[player_vehicleid][carPos][1],
		PlayerVehicleInfo[player_vehicleid][carPos][2], PlayerVehicleInfo[player_vehicleid][carPos][3]
	);
	new Cache:result = mysql_query(connects, MYSQL_GLOBAL);
	PlayerVehicleInfo[player_vehicleid][carID] = cache_insert_id();
	if (cache_is_valid(result)) cache_delete(result);

	SetVehiclePos(vehicleid, spawn_x, spawn_y, spawn_z);
	SetVehicleZAngle(vehicleid, spawn_angle);

	GetPlayerVehicles(playerid);
	SavePlayerVehicle(player_vehicleid);

	MYSQL_GLOBAL[0] = EOS;
	return player_vehicleid;
}
stock OnPlayerVehicleSpawn(vehicleid, player_vehicleid) {
	VehicleInfo[vehicleid][vFuel] = PlayerVehicleInfo[player_vehicleid][carFuel];
	VehicleInfo[vehicleid][vDrived] = PlayerVehicleInfo[player_vehicleid][carDrived];
	VehicleInfo[vehicleid][vStatus] = PlayerVehicleInfo[player_vehicleid][carStatus];
	VehicleInfo[vehicleid][vOrganization] = PlayerVehicleInfo[player_vehicleid][carOrganization];

	for (new slotid = 0; slotid < (6 * 3); slotid++) {
		VehicleInfo[vehicleid][vItemsID][slotid] = PlayerVehicleInfo[player_vehicleid][carItemsID][slotid];
		VehicleInfo[vehicleid][vItemsAmount][slotid] = PlayerVehicleInfo[player_vehicleid][carItemsAmount][slotid];
	}
	SetVehiclePos(vehicleid,
		PlayerVehicleInfo[player_vehicleid][carPos][0],
		PlayerVehicleInfo[player_vehicleid][carPos][1],
		PlayerVehicleInfo[player_vehicleid][carPos][2]
	);
	SetVehicleZAngle(vehicleid, PlayerVehicleInfo[player_vehicleid][carPos][3]);

	SetVehicleVirtualWorld(vehicleid, PlayerVehicleInfo[player_vehicleid][carWorld]);
	LinkVehicleToInterior(vehicleid, PlayerVehicleInfo[player_vehicleid][carInterior]);

	ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][vColor][0], VehicleInfo[vehicleid][vColor][1]);
	LoadPlayerVehicleTuning(vehicleid, player_vehicleid);

	SetVehicleNumberPlate(vehicleid, PlayerVehicleInfo[player_vehicleid][carNumber]);		
	SetVehicleNumberText(vehicleid, PlayerVehicleInfo[player_vehicleid][carNumber]);

	if (PlayerVehicleInfo[player_vehicleid][carPos][0] == 0.0 && PlayerVehicleInfo[player_vehicleid][carPos][1] == 0.0) 
		VehicleInfo[vehicleid][vParkingFine] = 1;
	else VehicleInfo[vehicleid][vParkingFine] = 0;

	if (VehicleInfo[vehicleid][vDeath]) {
		VehicleInfo[vehicleid][vDeath] = 0;
		SetVehicleHealth(vehicleid, PLAYER_VEHICLE_MIN_HEATH);
	}
	SetVehicleEngineStatus(vehicleid, .status = 0);
    SetVehicleDoorStatus(vehicleid, .status = 1);
}
stock ParkPlayerVehicle(playerid) {
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
		ErrorMessage(playerid, "Вы должны быть за рулем личного ТС.");
		return;
	}
	new vehicleid = GetPlayerVehicleID(playerid), player_vehicleid = VehicleInfo[vehicleid][vPlayerVehicleID];

	if (!GetString(player_name[playerid], PlayerVehicleInfo[player_vehicleid][carOwner])) {
		if (VehicleInfo[vehicleid][vOrganization]) {
			if (VehicleInfo[vehicleid][vOrganization] != PI[playerid][pOrgMember] || !GetString(player_name[playerid], OrganizationInfo[VehicleInfo[vehicleid][vOrganization]][orgLeader])) {
				ErrorMessage(playerid, "Вы должны быть за рулем личного ТС.");
				return;
			}
		} else {
			ErrorMessage(playerid, "Вы должны быть за рулем личного ТС.");
			return;
		}
	}
	if (_GetVehicleSpeed(vehicleid) > 0) {
		ErrorMessage(playerid, "Для начала остановите транспорт, чтобы его припарковать.");
		return;
	}
	new Float:vehicleHealth, vpanels, vdoors, vlights, vtires, Float:vehiclePos[4];
	
	GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
	GetVehicleZAngle(vehicleid, vehiclePos[3]);

	if (PlayerToKvadrat(playerid, 2788.4211/* (x1) */, -1478.2009/* (y1) */, 2821.3491/* (x2) */, -1424.5981/* (y2) */) && vehiclePos[2] < 100.0) {
		ErrorMessage(playerid, "Вы не можете припарковать личный транспорт на штрафстоянке.");
		return;
	}
	new Float:vehicle_Pos[3], bool:isReturn = false;
	for (new x = GetVehiclePoolSize() + 1; --x != 0;) {
		if (!IsValidVehicle(x)) continue;
		AntiCheatGetVehicleSpawnPos(x, vehicle_Pos[0], vehicle_Pos[1], vehicle_Pos[2]);
		if (!IsPlayerInRangeOfPoint(playerid, 4.5, vehicle_Pos[0], vehicle_Pos[1], vehicle_Pos[2])) continue;

		new player_vehicle_id = VehicleInfo[vehicleid][vPlayerVehicleID];
		if (VehicleInfo[x][vType] == VEHICLE_TYPE_PLAYER && (0 <= player_vehicle_id < MAX_VEHICLES_PLAYER) && GetPlayerVirtualWorld(playerid) == PlayerVehicleInfo[player_vehicle_id][carWorld]) {
			isReturn = true;
			break;
		}
	}
	if (isReturn) {
		ErrorMessage(playerid, "В данном месте нельзя припарковать транспорт (место занято).");
		return;
	} 
	
	GetVehicleHealth(vehicleid, vehicleHealth);
	if (vehicleHealth < PLAYER_VEHICLE_MIN_HEATH) vehicleHealth = PLAYER_VEHICLE_MIN_HEATH;
	GetVehicleDamageStatus(vehicleid, vpanels, vdoors, vlights, vtires);

	PlayerVehicleInfo[player_vehicleid][carPos][0] = vehiclePos[0];
	PlayerVehicleInfo[player_vehicleid][carPos][1] = vehiclePos[1];
	PlayerVehicleInfo[player_vehicleid][carPos][2] = vehiclePos[2];
	PlayerVehicleInfo[player_vehicleid][carPos][3] = vehiclePos[3];

	PlayerVehicleInfo[player_vehicleid][carInterior] = GetPlayerInterior(playerid);
	PlayerVehicleInfo[player_vehicleid][carWorld] = GetPlayerVirtualWorld(playerid);
	PlayerVehicleInfo[player_vehicleid][carParked] = 1;

	PlayerVehicleInfo[player_vehicleid][carStatus] = VehicleInfo[vehicleid][vStatus];
	PlayerVehicleInfo[player_vehicleid][carFuel] = VehicleInfo[vehicleid][vFuel];
	PlayerVehicleInfo[player_vehicleid][carDrived] = VehicleInfo[vehicleid][vDrived];

	PlayerVehicleInfo[player_vehicleid][carStatus] = VehicleInfo[vehicleid][vStatus];

	for (new slotid = 0; slotid < (6 * 3); slotid++) {
		PlayerVehicleInfo[player_vehicleid][carItemsID][slotid] = VehicleInfo[vehicleid][vItemsID][slotid];
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][slotid] = VehicleInfo[vehicleid][vItemsAmount][slotid];
	}
	A_DestroyVehicle(vehicleid);

	PlayerVehicleInfo[player_vehicleid][carVehicle] = vehicleid = A_CreateVehicle(PlayerVehicleInfo[player_vehicleid][carModel],
		PlayerVehicleInfo[player_vehicleid][carPos][0], PlayerVehicleInfo[player_vehicleid][carPos][1],
		PlayerVehicleInfo[player_vehicleid][carPos][2], PlayerVehicleInfo[player_vehicleid][carPos][3],
		PlayerVehicleInfo[player_vehicleid][carColor][0], PlayerVehicleInfo[player_vehicleid][carColor][1],
		-1, VEHICLE_TYPE_PLAYER
	);
	VehicleInfo[vehicleid][vPlayerVehicleID] = player_vehicleid;
	SetVehicleToRespawn(vehicleid);

	VehicleInfo[vehicleid][vFuel] = PlayerVehicleInfo[player_vehicleid][carFuel];
	VehicleInfo[vehicleid][vDrived] = PlayerVehicleInfo[player_vehicleid][carDrived];
	VehicleInfo[vehicleid][vOrganization] = PlayerVehicleInfo[player_vehicleid][carOrganization];
	VehicleInfo[vehicleid][vStatus] = PlayerVehicleInfo[player_vehicleid][carStatus];
	/*VehicleInfo[vehicleid][vItemsID] = PlayerVehicleInfo[player_vehicleid][carItemsID];
	VehicleInfo[vehicleid][vItemsAmount] = PlayerVehicleInfo[player_vehicleid][carItemsAmount];*/

	for (new slotid = 0; slotid < (6 * 3); slotid++) {
		VehicleInfo[vehicleid][vItemsID][slotid] = PlayerVehicleInfo[player_vehicleid][carItemsID][slotid];
		VehicleInfo[vehicleid][vItemsAmount][slotid] = PlayerVehicleInfo[player_vehicleid][carItemsAmount][slotid];
	}
	UpdateVehicleDamageStatus(vehicleid, vpanels, vdoors, vlights, vtires);
	SetVehicleHealth(vehicleid, vehicleHealth);

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SavePlayerVehicle(player_vehicleid);

    PlayerTextDrawColor(playerid, speed_ptd[playerid][15], -1523963137), PlayerTextDrawShow(playerid, speed_ptd[playerid][15]);
    PlayerTextDrawColor(playerid, speed_ptd[playerid][16], -1523963137), PlayerTextDrawShow(playerid, speed_ptd[playerid][16]);

	SendOk(playerid, "Вы успешно перепарковали свое ТС.");
}
stock SaveVehicleInventory(vehicleid) {
	if (!IsValidVehicle(vehicleid)) return;
	new player_vehicleid = VehicleInfo[vehicleid][vPlayerVehicleID];
	if (player_vehicleid != -1) SavePlayerVehicleInventory(player_vehicleid);
}
stock SavePlayerVehicleInventory(player_vehicleid) {
	if (!(0 <= player_vehicleid < MAX_VEHICLES_PLAYER)) 
		return;
	MYSQL_GLOBAL[0] = EOS;

	new vehicleid = PlayerVehicleInfo[player_vehicleid][carVehicle];

	for (new slotid = 0; slotid < (6 * 3); slotid++) {
		PlayerVehicleInfo[player_vehicleid][carItemsID][slotid] = VehicleInfo[vehicleid][vItemsID][slotid];
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][slotid] = VehicleInfo[vehicleid][vItemsAmount][slotid];
	}
	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `"TABLE_VEHICLES"` SET \
		`itemsID`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i', \
		`itemsAmount`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i' \
		WHERE id = %d LIMIT 1",
		PlayerVehicleInfo[player_vehicleid][carItemsID][0], PlayerVehicleInfo[player_vehicleid][carItemsID][1], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][2], PlayerVehicleInfo[player_vehicleid][carItemsID][3], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][4], PlayerVehicleInfo[player_vehicleid][carItemsID][5], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][6], PlayerVehicleInfo[player_vehicleid][carItemsID][7], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][8], PlayerVehicleInfo[player_vehicleid][carItemsID][9], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][10], PlayerVehicleInfo[player_vehicleid][carItemsID][11], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][12], PlayerVehicleInfo[player_vehicleid][carItemsID][13], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][14], PlayerVehicleInfo[player_vehicleid][carItemsID][15], 
		PlayerVehicleInfo[player_vehicleid][carItemsID][16], PlayerVehicleInfo[player_vehicleid][carItemsID][17],

		PlayerVehicleInfo[player_vehicleid][carItemsAmount][0], PlayerVehicleInfo[player_vehicleid][carItemsAmount][1], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][2], PlayerVehicleInfo[player_vehicleid][carItemsAmount][3], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][4], PlayerVehicleInfo[player_vehicleid][carItemsAmount][5], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][6], PlayerVehicleInfo[player_vehicleid][carItemsAmount][7], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][8], PlayerVehicleInfo[player_vehicleid][carItemsAmount][9], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][10], PlayerVehicleInfo[player_vehicleid][carItemsAmount][11], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][12], PlayerVehicleInfo[player_vehicleid][carItemsAmount][13], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][14], PlayerVehicleInfo[player_vehicleid][carItemsAmount][15], 
		PlayerVehicleInfo[player_vehicleid][carItemsAmount][16], PlayerVehicleInfo[player_vehicleid][carItemsAmount][17], 

		PlayerVehicleInfo[player_vehicleid][carID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", "");
	MYSQL_GLOBAL[0] = EOS;
}
stock SavePlayerVehicle(player_vehicleid) {
	if (!(0 <= player_vehicleid < MAX_VEHICLES_PLAYER)) 
		return;
	MYSQL_GLOBAL[0] = EOS;

	new vehicleid = PlayerVehicleInfo[player_vehicleid][carVehicle];

	new vpanels, vdoors, vlights, vtires, Float:vhealth;
	GetVehicleHealth(vehicleid, vhealth);
	GetVehicleDamageStatus(vehicleid, vpanels, vdoors, vlights, vtires);

	PlayerVehicleInfo[player_vehicleid][carDrived] = VehicleInfo[vehicleid][vDrived];
	PlayerVehicleInfo[player_vehicleid][carFuel] = VehicleInfo[vehicleid][vFuel];
	PlayerVehicleInfo[player_vehicleid][carStatus] = VehicleInfo[vehicleid][vStatus];

	PlayerVehicleInfo[player_vehicleid][carVehcom][0] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SPOILER);
	PlayerVehicleInfo[player_vehicleid][carVehcom][1] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HOOD);
	PlayerVehicleInfo[player_vehicleid][carVehcom][2] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_ROOF);
	PlayerVehicleInfo[player_vehicleid][carVehcom][3] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SIDESKIRT);
	PlayerVehicleInfo[player_vehicleid][carVehcom][4] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_LAMPS);
	PlayerVehicleInfo[player_vehicleid][carVehcom][5] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO);
	PlayerVehicleInfo[player_vehicleid][carVehcom][6] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_EXHAUST);
	PlayerVehicleInfo[player_vehicleid][carVehcom][7] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_WHEELS);
	PlayerVehicleInfo[player_vehicleid][carVehcom][8] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_STEREO);
	PlayerVehicleInfo[player_vehicleid][carVehcom][9] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HYDRAULICS);
	PlayerVehicleInfo[player_vehicleid][carVehcom][10] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_FRONT_BUMPER);
	PlayerVehicleInfo[player_vehicleid][carVehcom][11] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_REAR_BUMPER);
	PlayerVehicleInfo[player_vehicleid][carVehcom][12] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_VENT_RIGHT);
	PlayerVehicleInfo[player_vehicleid][carVehcom][13] = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_VENT_LEFT);

	SavePlayerVehicleInventory(player_vehicleid);

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `"TABLE_VEHICLES"` SET \
		`color_one` = %i, `color_two` = %i, \
		`x` = '%.2f', `y` = '%.2f', `z` = '%.2f', `angle` = '%.2f', \
		`number` = '%s', `interior` = %i, `world` = %i, \
		`vehcom_1` = '%i', `vehcom_2` = '%i', `vehcom_3` = '%i', `vehcom_4` = '%i', `vehcom_5` = '%i', \
		`vehcom_6` = '%i', `vehcom_7` = '%i', `vehcom_8` = '%i', `vehcom_9` = '%i', `vehcom_10` = '%i', \
		`vehcom_11` = '%i', `vehcom_12` = '%i', `vehcom_13` = '%i', `vehcom_14` = '%i', \
		`drived` = '%.2f', `fuel` = '%.2f', `status` = '%.2f', `parked` = '%i', `organization` = '%i', \
		`paintjob`= '%i', \
		`keysID`='%i,%i,%i',\
		`health` = %.2f, `panels` = %i, `doors` = %i, `lights` = %i, `tires` = %i \
		WHERE id = %d LIMIT 1",

		PlayerVehicleInfo[player_vehicleid][carColor][0], PlayerVehicleInfo[player_vehicleid][carColor][1],
		PlayerVehicleInfo[player_vehicleid][carPos][0], PlayerVehicleInfo[player_vehicleid][carPos][1],
		PlayerVehicleInfo[player_vehicleid][carPos][2], PlayerVehicleInfo[player_vehicleid][carPos][3],
		PlayerVehicleInfo[player_vehicleid][carNumber], 

		PlayerVehicleInfo[player_vehicleid][carInterior], PlayerVehicleInfo[player_vehicleid][carWorld], 

		PlayerVehicleInfo[player_vehicleid][carVehcom][0], PlayerVehicleInfo[player_vehicleid][carVehcom][1], 
		PlayerVehicleInfo[player_vehicleid][carVehcom][2], PlayerVehicleInfo[player_vehicleid][carVehcom][3], 
		PlayerVehicleInfo[player_vehicleid][carVehcom][4], PlayerVehicleInfo[player_vehicleid][carVehcom][5], 
		PlayerVehicleInfo[player_vehicleid][carVehcom][6], PlayerVehicleInfo[player_vehicleid][carVehcom][7], 
		PlayerVehicleInfo[player_vehicleid][carVehcom][8], PlayerVehicleInfo[player_vehicleid][carVehcom][9], 
		PlayerVehicleInfo[player_vehicleid][carVehcom][10], PlayerVehicleInfo[player_vehicleid][carVehcom][11], 
		PlayerVehicleInfo[player_vehicleid][carVehcom][12], PlayerVehicleInfo[player_vehicleid][carVehcom][13], 

		PlayerVehicleInfo[player_vehicleid][carDrived], PlayerVehicleInfo[player_vehicleid][carFuel],
		PlayerVehicleInfo[player_vehicleid][carStatus], PlayerVehicleInfo[player_vehicleid][carParked],
		PlayerVehicleInfo[player_vehicleid][carOrganization],

		PlayerVehicleInfo[player_vehicleid][carPaintJob],

		PlayerVehicleInfo[player_vehicleid][carKeys][0], PlayerVehicleInfo[player_vehicleid][carKeys][1],
		PlayerVehicleInfo[player_vehicleid][carKeys][2],

		vhealth, vpanels, vdoors, vlights, vtires,
		PlayerVehicleInfo[player_vehicleid][carID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;
}
stock LoadPlayerVehicleTuning(vehicleid, player_vehicleid) {
	if (!(0 <= player_vehicleid < MAX_VEHICLES_PLAYER)) 
		return;
	if (PlayerVehicleInfo[player_vehicleid][carPaintJob] != -1)
		ChangeVehiclePaintjob(vehicleid, PlayerVehicleInfo[player_vehicleid][carPaintJob]);
	for (new i = 0; i < 14; i++) {
		if (PlayerVehicleInfo[player_vehicleid][carVehcom][i] == 0) continue;
		ACC_AddVehicleComponent(vehicleid, PlayerVehicleInfo[player_vehicleid][carVehcom][i]);
	}
}
stock UpdatePlayerVehiclePosition(player_vehicleid, update_vehicle = 1, save = 1) {
	if (!(0 <= player_vehicleid < MAX_VEHICLES_PLAYER)) 
		return;
	if (PlayerVehicleInfo[player_vehicleid][carPos][0] != 0.0 || PlayerVehicleInfo[player_vehicleid][carPos][1] != 0.0)
		return;

	new random_spawn = random(sizeof (ticketVehicleSpawnPos));

	PlayerVehicleInfo[player_vehicleid][carPos][0] = ticketVehicleSpawnPos[random_spawn][0];
	PlayerVehicleInfo[player_vehicleid][carPos][1] = ticketVehicleSpawnPos[random_spawn][1];
	PlayerVehicleInfo[player_vehicleid][carPos][2] = ticketVehicleSpawnPos[random_spawn][2];
	PlayerVehicleInfo[player_vehicleid][carPos][3] = ticketVehicleSpawnPos[random_spawn][3];

	PlayerVehicleInfo[player_vehicleid][carInterior] = 0;
	PlayerVehicleInfo[player_vehicleid][carWorld] = 0;

	new vehicleid = PlayerVehicleInfo[player_vehicleid][carVehicle];
	//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);

	PlayerVehicleInfo[player_vehicleid][carParked] = 0;
	VehicleInfo[vehicleid][vParkingFine] = 1;

	if (update_vehicle) {
		SetVehiclePos(vehicleid, 
			PlayerVehicleInfo[player_vehicleid][carPos][0], PlayerVehicleInfo[player_vehicleid][carPos][1], PlayerVehicleInfo[player_vehicleid][carPos][2]
		);
		SetVehicleZAngle(vehicleid, PlayerVehicleInfo[player_vehicleid][carPos][3]);

		LinkVehicleToInterior(vehicleid, PlayerVehicleInfo[player_vehicleid][carInterior]);
		SetVehicleVirtualWorld(vehicleid, PlayerVehicleInfo[player_vehicleid][carWorld]);
	}
	if (save) SavePlayerVehicle(player_vehicleid);
}
stock ShowPlayerCarsList(playerid, menu_id = D_FIX_CAR) {
	new vehicle_amount = GetPlayerVehicles(playerid);
	if (!vehicle_amount) {
		ErrorMessage(playerid, "У вас нет личного транспорта.");
		return false;
	}
	STRING_GLOBAL[0] = EOS;

	switch (menu_id) {
		case D_SELL_CAR: {
			new 
				target_name[MAX_PLAYER_NAME + 8],
				player_vehicle[32], target_vehicle[32];

			if (TI[playerid][tTempChangeCarBuyerID] != INVALID_PLAYER_ID) {
				format(target_name, sizeof (target_name), ""P"%s [ID: %i]",
					player_name[TI[playerid][tTempChangeCarBuyerID]],
					TI[playerid][tTempChangeCarBuyerID]
				);
			}
			else format(target_name, sizeof (target_name), ""R"игрок не выбран");

			if (TI[playerid][tTempChangeCarVehicleID][0] != -1) {
				format(player_vehicle, sizeof (player_vehicle), ""P"%s [ID: %i]",
					gTransport[PlayerVehicleInfo[TI[playerid][tTempChangeCarVehicleID][0]][carModel] - 400][trName],
					PlayerVehicleInfo[TI[playerid][tTempChangeCarVehicleID][0]][carVehicle]
				);
			}
			else format(player_vehicle, sizeof (player_vehicle), ""R"не выбран");

			if (TI[playerid][tTempChangeCarVehicleID][1] != -1) {
				format(target_vehicle, sizeof (target_vehicle), ""P"%s [ID: %i]",
					gTransport[PlayerVehicleInfo[TI[playerid][tTempChangeCarVehicleID][1]][carModel] - 400][trName],
					PlayerVehicleInfo[TI[playerid][tTempChangeCarVehicleID][1]][carVehicle]
				);
			}
			else format(target_vehicle, sizeof (target_vehicle), ""G"не выбран");

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Покупатель: %s\n\
				"P"2. "W"Транспорт для продажи: %s\n\
				"P"3. "W"Транспорт для обмена: %s\n\
				"P"4. "W"Стоимость продажи: "GREEN"$%i\n\
				"P">> "W"Далее",
				target_name,
				player_vehicle,
				target_vehicle,
				TI[playerid][tTempChangeCarPrice]
			);
			ShowPlayerDialog(playerid, D_SELL_CAR, DIALOG_STYLE_LIST, ""P"Продажа / обмен ТС", STRING_GLOBAL, "Выбрать", "Отмена");
			return true;
		}
		case D_SELL_CAR_PLAYER: {
			ShowPlayerDialog(playerid, D_SELL_CAR_PLAYER, DIALOG_STYLE_INPUT, ""P"Выберите покупателя", "\
				"W"Введите ID игрока, которому хотите предложить сделку:", 
				"Выбрать", "Назад"
			);
			return true;
		}
		case D_SELL_CAR_PRICE: {
			ShowPlayerDialog(playerid, D_SELL_CAR_PRICE, DIALOG_STYLE_INPUT, ""P"Стоимость продажи", "\
				"W"Введите стоимость продажи:\n \n\
				"G"Примечание: стоимость продажи должна быть не менее $1 и не более $1,000,000", 
				"Выбрать", "Назад"
			);
			return true;
		}
		case D_SELL_CAR_VEHICLE_2: {
			new targetid = TI[playerid][tTempChangeCarBuyerID], idx;
			for (new i = 0, player_vehicleid = -1; i < GetPlayerVehicles(targetid); i++) {
				player_vehicleid = playerVehicleID[targetid][i];

				format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d. "W"Транспорт \"%s\" "G"[ID: %d] "GREEN"[%s]\n",
					STRING_GLOBAL, i + 1, 
					gTransport[PlayerVehicleInfo[player_vehicleid][carModel] - 400][trName],
					PlayerVehicleInfo[player_vehicleid][carVehicle], // carModel
					PlayerVehicleInfo[player_vehicleid][carNumber]
				);
				playerVehicleListitemID[playerid][idx++] = player_vehicleid;
			}
			playerVehicleListitemID[playerid][idx++] = -1;
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"- "W"Ничего не выбирать", STRING_GLOBAL);

			ShowPlayerDialog(playerid, D_SELL_CAR_VEHICLE_2, DIALOG_STYLE_LIST, ""P"Выберите транспорт игрока", STRING_GLOBAL, "Выбрать", "Назад");
			return true;
		}
	}
	for (new i = 0, player_vehicleid = -1; i < vehicle_amount; i++) {
		player_vehicleid = playerVehicleID[playerid][i];

		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d. "W"Транспорт \"%s\" "G"[ID: %d] "GREEN"[%s]\n",
			STRING_GLOBAL, i + 1, 
			gTransport[PlayerVehicleInfo[player_vehicleid][carModel] - 400][trName],
			PlayerVehicleInfo[player_vehicleid][carVehicle], // carModel
			PlayerVehicleInfo[player_vehicleid][carNumber]
		);
		playerVehicleListitemID[playerid][i] = player_vehicleid;
	}
	switch (menu_id) {
		case D_CAR_LIST: {
			ShowPlayerDialog(playerid, D_CAR_LIST, DIALOG_STYLE_LIST, ""P"Выберите транспорт", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_FIX_CAR: {
			ShowPlayerDialog(playerid, D_FIX_CAR, DIALOG_STYLE_LIST, ""P"Доставить транспорт", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_NUMBER_CAR: {
			ShowPlayerDialog(playerid, D_NUMBER_CAR, DIALOG_STYLE_LIST, ""P"Покупка номерного знака", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_SEARCH_CAR: {
			ShowPlayerDialog(playerid, D_SEARCH_CAR, DIALOG_STYLE_LIST, ""P"Найти личный транспорт", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_UTILIZATION_CAR: {
			SendClientMessage(playerid, CGOLD, !"Выберите транспорт, который хотите утилизировать.");
			ShowPlayerDialog(playerid, D_UTILIZATION_CAR, DIALOG_STYLE_LIST, ""P"Утилизация транспорта", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_SELL_CAR_VEHICLE_1: {
			ShowPlayerDialog(playerid, D_SELL_CAR_VEHICLE_1, DIALOG_STYLE_LIST, ""P"Выберите личный транспорт", STRING_GLOBAL, "Выбрать", "Назад");
		}
	}
	STRING_GLOBAL[0] = EOS;

	return true;
}
stock ShowPlayerParkingFineList(playerid) {
	new vehicle_amount = GetPlayerVehicles(playerid);
	if (!vehicle_amount) {
		ErrorMessage(playerid, "У вас нет личного транспорта.");
		return false;
	}
	STRING_GLOBAL[0] = EOS;

	new idx = 0;
	for (new i = 0, player_vehicleid = -1, vehicleid; i < vehicle_amount; i++) {
		player_vehicleid = playerVehicleID[playerid][i];
		vehicleid = PlayerVehicleInfo[player_vehicleid][carVehicle];

		if (!VehicleInfo[vehicleid][vParkingFine]) continue;

		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d. "W"Транспорт \"%s\" "G"[ID: %d] "GREEN"[%s]"W" - "GREEN"$1000\n",
			STRING_GLOBAL, i + 1, 
			gTransport[PlayerVehicleInfo[player_vehicleid][carModel] - 400][trName],
			vehicleid, 
			PlayerVehicleInfo[player_vehicleid][carNumber]
		);
		playerVehicleListitemID[playerid][idx++] = player_vehicleid;
	}
	if (0 == idx) 
		return ErrorMessage(playerid, "Ваших личных ТС нет в данный момент на штрафстоянке.");
	ShowPlayerDialog(playerid, D_PARKING_FINE, DIALOG_STYLE_LIST, ""P"Оплатить личный транспорт", STRING_GLOBAL, "Выбрать", "Отмена");
		
	STRING_GLOBAL[0] = EOS;

	return true;
}
CMD:setstatus(playerid, params[]) {
	if (PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) 
		return true;
	new vehicleid = GetPlayerVehicleID(playerid);
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || VehicleInfo[vehicleid][vType] != VEHICLE_TYPE_PLAYER)
		return 0;
	new status;
	if (sscanf(params, "i", status) || !(10 <= status <= 100)) 
		return SendEsp(playerid, "/setstatus [10 - 100 процентов]");
	VehicleInfo[vehicleid][vStatus] = status;
	ErrorMessage(playerid, "Вы успешно изменили тех.статус ТС.");
	return true;
} 
CMD:aunpark(playerid, params[]) {
	if (PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) 
		return true;
	new vehicleid = GetPlayerVehicleID(playerid), vehicle_id;

	if (!sscanf(params, "i", vehicle_id) && (1 <= vehicle_id < MAX_VEHICLES) && IsValidVehicle(vehicle_id)) 
		vehicleid = vehicle_id;

	new player_vehicle_id = -1, Float:playerPos[3];
	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

	foreach(new player_vehicleid: playerVehicles) {
		if (PlayerVehicleInfo[player_vehicleid][carVehicle] != vehicleid) 
			continue;
		player_vehicle_id = player_vehicleid;
		break;
	}
	if (player_vehicle_id == -1)
		return ErrorMessage(playerid, "Убирать с парковки можно только личный транспорт игроков.");

	PlayerVehicleInfo[player_vehicle_id][carPos][0] = PlayerVehicleInfo[player_vehicle_id][carPos][1] = 0.0;
	UpdatePlayerVehiclePosition(player_vehicle_id, 1);
	SetVehicleToRespawn(PlayerVehicleInfo[player_vehicle_id][carVehicle]);

	SendOk(playerid, "Вы отправили транспорт на штрафстоянку.");

	SetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
	return true;
}
alias:park("vpark");
CMD:park(playerid) {
	ParkPlayerVehicle(playerid);
	return true;
}
alias:cars("auto", "mycars", "vehicles");
CMD:cars(playerid) {
	ShowPlayerCarsList(playerid, D_CAR_LIST);
	return true;
}
alias:changecar("sellcar");
CMD:changecar(playerid) {
	if (TI[playerid][tTempChangeCarBuyerID] != INVALID_PLAYER_ID)
		return ErrorMessage(playerid, "Вы уже предложили сделку по продаже / обмену ТС.");
	TI[playerid][tTempChangeCarBuyerID] = INVALID_PLAYER_ID;
	TI[playerid][tTempChangeCarPrice] = 0;
	TI[playerid][tTempChangeCarVehicleID][0] = -1;
	TI[playerid][tTempChangeCarVehicleID][1] = -1;

	ShowPlayerCarsList(playerid, D_SELL_CAR);
	return true;
}



