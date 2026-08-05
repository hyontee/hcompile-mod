#if defined _cars_show_included
	#endinput
#endif
#define _cars_show_included

#define MAX_CARS_SHOW			3
#define MAX_CAR_SLOT_SALE		15
#define MAX_CAR_SLOT_WAREHOUSE	15

#define TABLE_CARS_SHOW			"cars_show"
#define TABLE_CARS_SHOW_IMPORT	"cars_show_import"

enum {
	VEHICLE_CLASS_ECONOMY = 1,
	VEHICLE_CLASS_BUSINESS,
	VEHICLE_CLASS_EXCLUSIVE, // | SPORT
	VEHICLE_CLASS_MOTO,
	VEHICLE_CLASS_CARGO
};
#define MAX_VEHICLE_MODEL	211

enum VEHICLE_IMPORT_E {
	viPrice,
	viClass,
	viAmount,
	viStatus,
	viLimit
};
new VehicleImportInfo[MAX_VEHICLE_MODEL][VEHICLE_IMPORT_E];

enum DEFAULT_IMPORT_E {
	viModel,
	viClass
};
new DefaultImportInfo[][DEFAULT_IMPORT_E] = {
	{ 400, VEHICLE_CLASS_ECONOMY },
	{ 401, VEHICLE_CLASS_ECONOMY },
	{ 404, VEHICLE_CLASS_ECONOMY },
	{ 405, VEHICLE_CLASS_ECONOMY },
	{ 410, VEHICLE_CLASS_ECONOMY },
	{ 412, VEHICLE_CLASS_ECONOMY },
	{ 413, VEHICLE_CLASS_ECONOMY },
	{ 418, VEHICLE_CLASS_ECONOMY },
	{ 419, VEHICLE_CLASS_ECONOMY },
	{ 421, VEHICLE_CLASS_ECONOMY },
	{ 422, VEHICLE_CLASS_ECONOMY },
	{ 436, VEHICLE_CLASS_ECONOMY },
	{ 439, VEHICLE_CLASS_ECONOMY },
	{ 458, VEHICLE_CLASS_ECONOMY },
	{ 466, VEHICLE_CLASS_ECONOMY },
	{ 467, VEHICLE_CLASS_ECONOMY },
	{ 474, VEHICLE_CLASS_ECONOMY },
	{ 475, VEHICLE_CLASS_ECONOMY },
	{ 478, VEHICLE_CLASS_ECONOMY },
	{ 479, VEHICLE_CLASS_ECONOMY },
	{ 482, VEHICLE_CLASS_ECONOMY },
	{ 483, VEHICLE_CLASS_ECONOMY },
	{ 491, VEHICLE_CLASS_ECONOMY },
	{ 492, VEHICLE_CLASS_ECONOMY },
	{ 496, VEHICLE_CLASS_ECONOMY },
	{ 516, VEHICLE_CLASS_ECONOMY },
	{ 517, VEHICLE_CLASS_ECONOMY },
	{ 518, VEHICLE_CLASS_ECONOMY },
	{ 526, VEHICLE_CLASS_ECONOMY },
	{ 527, VEHICLE_CLASS_ECONOMY },
	{ 529, VEHICLE_CLASS_ECONOMY },
	{ 534, VEHICLE_CLASS_ECONOMY },
	{ 536, VEHICLE_CLASS_ECONOMY },
	{ 542, VEHICLE_CLASS_ECONOMY },
	{ 543, VEHICLE_CLASS_ECONOMY },
	{ 546, VEHICLE_CLASS_ECONOMY },
	{ 547, VEHICLE_CLASS_ECONOMY },
	{ 549, VEHICLE_CLASS_ECONOMY },
	{ 551, VEHICLE_CLASS_ECONOMY },
	{ 575, VEHICLE_CLASS_ECONOMY },
	{ 576, VEHICLE_CLASS_ECONOMY },
	{ 600, VEHICLE_CLASS_ECONOMY },
	{ 426, VEHICLE_CLASS_BUSINESS },
	{ 445, VEHICLE_CLASS_BUSINESS },
	{ 477, VEHICLE_CLASS_BUSINESS },
	{ 489, VEHICLE_CLASS_BUSINESS },
	{ 500, VEHICLE_CLASS_BUSINESS },
	{ 507, VEHICLE_CLASS_BUSINESS },
	{ 533, VEHICLE_CLASS_BUSINESS },
	{ 535, VEHICLE_CLASS_BUSINESS },
	{ 540, VEHICLE_CLASS_BUSINESS },
	{ 545, VEHICLE_CLASS_BUSINESS },
	{ 550, VEHICLE_CLASS_BUSINESS },
	{ 554, VEHICLE_CLASS_BUSINESS },
	{ 555, VEHICLE_CLASS_BUSINESS },
	{ 558, VEHICLE_CLASS_BUSINESS },
	{ 561, VEHICLE_CLASS_BUSINESS },
	{ 566, VEHICLE_CLASS_BUSINESS },
	{ 567, VEHICLE_CLASS_BUSINESS },
	{ 579, VEHICLE_CLASS_BUSINESS },
	{ 580, VEHICLE_CLASS_BUSINESS },
	{ 585, VEHICLE_CLASS_BUSINESS },
	{ 587, VEHICLE_CLASS_BUSINESS },
	{ 589, VEHICLE_CLASS_BUSINESS },
	{ 602, VEHICLE_CLASS_BUSINESS },
	{ 603, VEHICLE_CLASS_BUSINESS },
	{ 402, VEHICLE_CLASS_EXCLUSIVE },
	{ 411, VEHICLE_CLASS_EXCLUSIVE },
	{ 415, VEHICLE_CLASS_EXCLUSIVE },
	{ 429, VEHICLE_CLASS_EXCLUSIVE },
	{ 451, VEHICLE_CLASS_EXCLUSIVE },
	{ 480, VEHICLE_CLASS_EXCLUSIVE },
	{ 506, VEHICLE_CLASS_EXCLUSIVE },
	{ 551, VEHICLE_CLASS_EXCLUSIVE },
	{ 559, VEHICLE_CLASS_EXCLUSIVE },
	{ 560, VEHICLE_CLASS_EXCLUSIVE },
	{ 541, VEHICLE_CLASS_EXCLUSIVE },
	{ 562, VEHICLE_CLASS_EXCLUSIVE },
	{ 565, VEHICLE_CLASS_EXCLUSIVE },
	{ 461, VEHICLE_CLASS_MOTO },
	{ 462, VEHICLE_CLASS_MOTO },
	{ 463, VEHICLE_CLASS_MOTO },
	{ 468, VEHICLE_CLASS_MOTO },
	{ 471, VEHICLE_CLASS_MOTO },
	{ 521, VEHICLE_CLASS_MOTO },
	{ 522, VEHICLE_CLASS_MOTO },
	{ 581, VEHICLE_CLASS_MOTO },
	{ 586, VEHICLE_CLASS_MOTO }
};

enum CARS_SHOW_E {
	csID,
	csWorld,
	csBizzID,

	csVehicleID[MAX_CAR_SLOT_SALE],
	csPickupID[MAX_CAR_SLOT_SALE],
	Text3D:csTextID[MAX_CAR_SLOT_SALE],
	csAreaID[MAX_CAR_SLOT_SALE],

	csCarsSaleID[MAX_CAR_SLOT_SALE],
	csCarsSaleAmount[MAX_CAR_SLOT_SALE],
	csCarsSalePrice[MAX_CAR_SLOT_SALE],

	csCarsWarehouseID[MAX_CAR_SLOT_WAREHOUSE],
	csCarsWarehouseAmount[MAX_CAR_SLOT_WAREHOUSE],
}
new CarsShowInfo[MAX_CARS_SHOW][CARS_SHOW_E], CARS_SHOW_AMOUNT;

#define MAX_CARS_LIST_ITEMS	50
new CarsImportTempID[MAX_PLAYERS][MAX_CARS_LIST_ITEMS];

enum CS_VEHICLE_E {
	vWorld,
	Float:vPickupPos[3],
	Float:vVehiclePos[4],
}
static const CarsShowVehicle[MAX_CAR_SLOT_SALE][CS_VEHICLE_E] = {
	{ 1, {1445.1970, 705.7463, 1087.9011}, {1448.0447, 708.2873, 1087.5800, 89.6385} },  // 1
	{ 1, {1445.1982, 710.9193, 1087.9011}, {1448.0784, 713.6127, 1087.5901, 89.6393} },  // 2
	{ 1, {1445.2039, 716.5222, 1087.9011}, {1448.1138, 719.2037, 1087.5951, 89.6386} },  // 3
	{ 1, {1445.2312, 721.8218, 1087.9011}, {1448.1484, 724.7229, 1087.6003, 89.6391} },  // 4
	{ 1, {1445.2173, 727.5865, 1087.9011}, {1448.1849, 730.5540, 1087.6053, 89.6395} },  // 5
	{ 1, {1445.2234, 733.4098, 1087.9011}, {1448.2197, 736.0845, 1087.6095, 89.6402} },  // 6
	{ 1, {1440.5392, 735.0312, 1087.9011}, {1438.0615, 737.8141, 1087.5917, 177.9575} }, // 7
	{ 1, {1429.7823, 740.1288, 1087.9241}, {1427.1453, 737.7178, 1087.6104, 269.8790} }, // 8
	{ 1, {1429.8115, 735.5298, 1087.9241}, {1427.1362, 733.3904, 1087.6160, 269.8798} }, // 9
	{ 1, {1429.7954, 731.3306, 1087.9241}, {1427.1268, 728.9119, 1087.6213, 269.8804} }, // 10
	{ 1, {1429.8168, 726.9245, 1087.9241}, {1427.1184, 724.8679, 1087.6309, 269.8807} }, // 11
	{ 1, {1429.8368, 723.0578, 1087.9241}, {1427.1099, 720.7058, 1087.6355, 269.8802} }, // 12
	{ 1, {1429.7701, 718.8285, 1087.9241}, {1427.1012, 716.5450, 1087.6406, 269.8808} }, // 13
	{ 1, {1429.7668, 714.4569, 1087.9241}, {1427.0918, 712.0411, 1087.6406, 269.8808} }, // 14
	{ 1, {1429.8173, 709.7039, 1087.9241}, {1427.0824, 707.4381, 1087.6454, 269.8802} }  // 15
/*
	{ 1, {1445.2085, 705.7338, 1087.9011}, {1448.1471, 708.4460, 1087.6650, 90.00} }, // 1
	{ 1, {1445.2091, 710.9103, 1087.9011}, {1448.1471, 713.7061, 1087.6650, 90.00} }, // 1
	{ 1, {1445.2209, 716.5020, 1087.9011}, {1448.1471, 719.3146, 1087.6650, 90.00} }, // 3
	{ 1, {1445.2075, 721.8635, 1087.9011}, {1448.1471, 724.8481, 1087.6650, 90.00} }, // 4
	{ 1, {1445.2218, 727.5889, 1087.9011}, {1447.6071, 730.6991, 1087.6650, 90.00} }, // 5
	{ 1, {1445.2330, 733.3967, 1087.9011}, {1448.1471, 736.4272, 1087.9449, 90.00} }, // 6
	{ 1, {1440.6002, 735.0201, 1087.9011}, {1438.2729, 737.9459, 1087.9449, 180.0} }, // 7
	{ 1, {1429.7894, 740.1119, 1087.9241}, {1427.2094, 737.6930, 1087.9449, -90.0} }, // 8
	{ 1, {1429.7721, 735.5907, 1087.9241}, {1427.4995, 733.3177, 1087.9449, -90.0} }, // 9
	{ 1, {1429.7736, 731.3618, 1087.9241}, {1427.4995, 729.1904, 1087.9449, -90.0} }, // 10
	{ 1, {1429.8004, 726.9999, 1087.9241}, {1427.4395, 724.9910, 1087.9449, -90.0} }, // 11
	{ 1, {1429.8016, 723.1078, 1087.9241}, {1427.3696, 720.9914, 1087.9449, -90.0} }, // 12
	{ 1, {1429.7720, 718.8213, 1087.9241}, {1427.3696, 716.6315, 1087.9449, -90.0} }, // 13
	{ 1, {1429.7936, 714.4084, 1087.9241}, {1427.3696, 711.9934, 1087.9449, -90.0} }, // 14
	{ 1, {1429.7799, 709.7604, 1087.9241}, {1427.4827, 707.3099, 1087.9449, -90.0} } // 15
 */
	/*{ 1, {1429.7854, 705.0353, 1087.9241}, {1427.3752, 702.1538, 1087.9449, -90.0} }, // 16
	{ 1, {1429.7755, 699.8195, 1087.9241}, {1427.6852, 697.2802, 1087.9449, -90.0} }, // 17
	{ 1, {1441.5001, 712.2757, 1087.9011}, {1438.7712, 710.4130, 1087.9449, -90.0} }, // 18
	{ 1, {1441.5013, 725.3693, 1087.9011}, {1438.7712, 723.2712, 1087.9449, -90.0} }, // 19

	{ 2, {1445.2085, 705.7338, 1087.9011}, {1448.1471, 708.4460, 1087.6650, 90.00} }, // 1
	{ 2, {1445.2091, 710.9103, 1087.9011}, {1448.1471, 713.7061, 1087.6650, 90.00} }, // 1
	{ 2, {1445.2209, 716.5020, 1087.9011}, {1447.7671, 719.3146, 1087.6650, 90.00} }, // 3
	{ 2, {1445.2075, 721.8635, 1087.9011}, {1448.1271, 724.8481, 1087.6650, 90.00} }, // 4
	{ 2, {1445.2218, 727.5889, 1087.9011}, {1447.6071, 730.6991, 1087.6650, 90.00} }*/ // 5
};

cs_OnGameModeInit() {

	// CreateActor(194, -1648.4329, 1207.6328, 7.2500, 7.6142);

	CreateDynamicMapIcon(2255.6689, -2387.5527, 17.4219/*-1636.7570, 1201.6077, 7.2038*/, 55, CWHITE);

	CreateDynamic3DTextLabel(""P"Центр импорта транспорта\n \n"W"Чтобы заказать ТС, нажмите \"ALT\"", 0xFFFFFFFF,
		2255.6689, -2387.5527, 17.4219/*-1649.1649, 1209.0283, 7.2500*/,
		FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
		0/* testlos */, 0, 0, -1
	);
	CreateDynamicPickup(1239, 23, 2255.6689, -2387.5527, 17.4219/*-1649.1649, 1209.0283, 7.2500*/, 0, 0);
	CreateDynamicObjectCP(2255.6689, -2387.5527, 17.4219/*-1649.1649, 1209.0283, 7.2500*/, 5.0);

	for (new modelid = 0; modelid < sizeof (DefaultImportInfo); modelid++) {
		new model_id = DefaultImportInfo[modelid][viModel];

		VehicleImportInfo[model_id - 400][viClass] = DefaultImportInfo[modelid][viClass];
		VehicleImportInfo[model_id - 400][viStatus] = 1;
		VehicleImportInfo[model_id - 400][viLimit] = 10;
		// VehicleImportInfo[model_id - 400][viAmount] = random(5);
	}
}
stock LoadCarsShow() {

	new Cache:result;
	result = mysql_query(connects, "SELECT * FROM `"TABLE_CARS_SHOW"`");

	CARS_SHOW_AMOUNT = cache_num_rows();
	if (!CARS_SHOW_AMOUNT) {
		cache_delete(result);
    	return print("[Загрузка ...] Автосалоны в базе не найдены!");
	}
	for (new i = 0, params[128]; i < CARS_SHOW_AMOUNT; i++) {
		cache_get_value_name_int(i, "id", CarsShowInfo[i][csID]);

		cache_get_value(i, "cars_sale_id", params);
		sscanf(params, "p<,>a<i>["#MAX_CAR_SLOT_SALE"]", CarsShowInfo[i][csCarsSaleID]);
		cache_get_value(i, "cars_sale_amount", params);
		sscanf(params, "p<,>a<i>["#MAX_CAR_SLOT_SALE"]", CarsShowInfo[i][csCarsSaleAmount]);
		cache_get_value(i, "cars_sale_price", params);
		sscanf(params, "p<,>a<i>["#MAX_CAR_SLOT_SALE"]", CarsShowInfo[i][csCarsSalePrice]);
	
		cache_get_value(i, "cars_warehouse_id", params);
		sscanf(params, "p<,>a<i>["#MAX_CAR_SLOT_WAREHOUSE"]", CarsShowInfo[i][csCarsWarehouseID]);
		cache_get_value(i, "cars_warehouse_amount", params);
		sscanf(params, "p<,>a<i>["#MAX_CAR_SLOT_WAREHOUSE"]", CarsShowInfo[i][csCarsWarehouseAmount]);

		if (i >= MAX_CARS_SHOW) {
            break;
	    }
	}
	cache_delete(result);
	printf("[Загрузка ...] Автосалоны успешно загружены (%i шт.)", CARS_SHOW_AMOUNT);

	return true;
}
stock SaveCarsShow(cars_show_id) {
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `"TABLE_CARS_SHOW"` SET \
		`cars_sale_id`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i', \
		`cars_sale_amount`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i', \
		`cars_sale_price`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i', \
		`cars_warehouse_id`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i', \
		`cars_warehouse_amount`='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i' \
		WHERE id = %d LIMIT 1",

		CarsShowInfo[cars_show_id][csCarsSaleID][0], CarsShowInfo[cars_show_id][csCarsSaleID][1], CarsShowInfo[cars_show_id][csCarsSaleID][2],
		CarsShowInfo[cars_show_id][csCarsSaleID][3], CarsShowInfo[cars_show_id][csCarsSaleID][4], CarsShowInfo[cars_show_id][csCarsSaleID][5],
		CarsShowInfo[cars_show_id][csCarsSaleID][6], CarsShowInfo[cars_show_id][csCarsSaleID][7], CarsShowInfo[cars_show_id][csCarsSaleID][8],
		CarsShowInfo[cars_show_id][csCarsSaleID][9], CarsShowInfo[cars_show_id][csCarsSaleID][10], CarsShowInfo[cars_show_id][csCarsSaleID][11],
		CarsShowInfo[cars_show_id][csCarsSaleID][12], CarsShowInfo[cars_show_id][csCarsSaleID][13], CarsShowInfo[cars_show_id][csCarsSaleID][14],

		CarsShowInfo[cars_show_id][csCarsSaleAmount][0], CarsShowInfo[cars_show_id][csCarsSaleAmount][1], CarsShowInfo[cars_show_id][csCarsSaleAmount][2],
		CarsShowInfo[cars_show_id][csCarsSaleAmount][3], CarsShowInfo[cars_show_id][csCarsSaleAmount][4], CarsShowInfo[cars_show_id][csCarsSaleAmount][5],
		CarsShowInfo[cars_show_id][csCarsSaleAmount][6], CarsShowInfo[cars_show_id][csCarsSaleAmount][7], CarsShowInfo[cars_show_id][csCarsSaleAmount][8],
		CarsShowInfo[cars_show_id][csCarsSaleAmount][9], CarsShowInfo[cars_show_id][csCarsSaleAmount][10], CarsShowInfo[cars_show_id][csCarsSaleAmount][11],
		CarsShowInfo[cars_show_id][csCarsSaleAmount][12], CarsShowInfo[cars_show_id][csCarsSaleAmount][13], CarsShowInfo[cars_show_id][csCarsSaleAmount][14],

		CarsShowInfo[cars_show_id][csCarsSalePrice][0], CarsShowInfo[cars_show_id][csCarsSalePrice][1], CarsShowInfo[cars_show_id][csCarsSalePrice][2],
		CarsShowInfo[cars_show_id][csCarsSalePrice][3], CarsShowInfo[cars_show_id][csCarsSalePrice][4], CarsShowInfo[cars_show_id][csCarsSalePrice][5],
		CarsShowInfo[cars_show_id][csCarsSalePrice][6], CarsShowInfo[cars_show_id][csCarsSalePrice][7], CarsShowInfo[cars_show_id][csCarsSalePrice][8],
		CarsShowInfo[cars_show_id][csCarsSalePrice][9], CarsShowInfo[cars_show_id][csCarsSalePrice][10], CarsShowInfo[cars_show_id][csCarsSalePrice][11],
		CarsShowInfo[cars_show_id][csCarsSalePrice][12], CarsShowInfo[cars_show_id][csCarsSalePrice][13], CarsShowInfo[cars_show_id][csCarsSalePrice][14],

		CarsShowInfo[cars_show_id][csCarsWarehouseID][0], CarsShowInfo[cars_show_id][csCarsWarehouseID][1], CarsShowInfo[cars_show_id][csCarsWarehouseID][2],
		CarsShowInfo[cars_show_id][csCarsWarehouseID][3], CarsShowInfo[cars_show_id][csCarsWarehouseID][4], CarsShowInfo[cars_show_id][csCarsWarehouseID][5],
		CarsShowInfo[cars_show_id][csCarsWarehouseID][6], CarsShowInfo[cars_show_id][csCarsWarehouseID][7], CarsShowInfo[cars_show_id][csCarsWarehouseID][8],
		CarsShowInfo[cars_show_id][csCarsWarehouseID][9], CarsShowInfo[cars_show_id][csCarsWarehouseID][10], CarsShowInfo[cars_show_id][csCarsWarehouseID][11],
		CarsShowInfo[cars_show_id][csCarsWarehouseID][12], CarsShowInfo[cars_show_id][csCarsWarehouseID][13], CarsShowInfo[cars_show_id][csCarsWarehouseID][14],

		CarsShowInfo[cars_show_id][csCarsWarehouseAmount][0], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][1], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][2],
		CarsShowInfo[cars_show_id][csCarsWarehouseAmount][3], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][4], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][5],
		CarsShowInfo[cars_show_id][csCarsWarehouseAmount][6], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][7], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][8],
		CarsShowInfo[cars_show_id][csCarsWarehouseAmount][9], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][10], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][11],
		CarsShowInfo[cars_show_id][csCarsWarehouseAmount][12], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][13], CarsShowInfo[cars_show_id][csCarsWarehouseAmount][14],

		CarsShowInfo[cars_show_id][csID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;

}
stock cs_DestroyVehicle(cars_show_id, slot) {
	if (!(0 <= cars_show_id < MAX_CARS_SHOW) || !(0 <= slot < MAX_CAR_SLOT_SALE))
		return;
	new vehicleid = CarsShowInfo[cars_show_id][csVehicleID][slot];

	if(INVALID_VEHICLE_ID == vehicleid)
		return;
	DestroyDynamicArea(CarsShowInfo[cars_show_id][csAreaID][slot]);
	DestroyDynamicPickup(CarsShowInfo[cars_show_id][csPickupID][slot]);

	A_DestroyVehicle(vehicleid);
	CarsShowInfo[cars_show_id][csVehicleID][slot] = INVALID_VEHICLE_ID;
}
stock cs_CreateVehicle(cars_show_id, slot) {
	if (!(0 <= cars_show_id < MAX_CARS_SHOW) || !(0 <= slot < MAX_CAR_SLOT_SALE))
		return;
	new
		vehicleid = CarsShowInfo[cars_show_id][csVehicleID][slot],
		modelid = CarsShowInfo[cars_show_id][csCarsSaleID][slot];

	if(INVALID_VEHICLE_ID != vehicleid) cs_DestroyVehicle(cars_show_id, slot);

	vehicleid = CarsShowInfo[cars_show_id][csVehicleID][slot] = A_CreateVehicle(modelid,
		CarsShowVehicle[slot][vVehiclePos][0], CarsShowVehicle[slot][vVehiclePos][1], CarsShowVehicle[slot][vVehiclePos][2],
		CarsShowVehicle[slot][vVehiclePos][3], 1, 1, -1, VEHICLE_TYPE_AUTOSALON
	);
	/*printf(">> cs_CreateVehicle(id = %d, slot = %d): model = %d, world = %d",
		cars_show_id, slot, modelid, CarsShowInfo[cars_show_id][csWorld]
	);*/
	SetVehicleVirtualWorld(vehicleid, CarsShowInfo[cars_show_id][csWorld]);
	LinkVehicleToInterior(vehicleid, 82);
	SetVehicleParamsEx(vehicleid, false, false, false, true, false, false, false);

	CarsShowInfo[cars_show_id][csPickupID][slot] = CreateDynamicPickup(1239, 23,
		CarsShowVehicle[slot][vPickupPos][0], CarsShowVehicle[slot][vPickupPos][1],
		CarsShowVehicle[slot][vPickupPos][2], CarsShowInfo[cars_show_id][csWorld], 82
	);
	CarsShowInfo[cars_show_id][csAreaID][slot] = CreateDynamicSphere(
		CarsShowVehicle[slot][vPickupPos][0], CarsShowVehicle[slot][vPickupPos][1],
		CarsShowVehicle[slot][vPickupPos][2], 0.5, CarsShowInfo[cars_show_id][csWorld], 82
	);
	SetDynamicAreaType(CarsShowInfo[cars_show_id][csAreaID][slot], AREA_TYPE_CARS_SHOW, cars_show_id, slot);
}
enum {
	CS_MENU_IMPORT_MAIN = 0,
	CS_MENU_IMPORT_CLASS,
	CS_MENU_IMPORT_LIST,
	CS_MENU_MAIN,
	CS_MENU_WAREHOUSE,
	CS_MENU_SALE,
	CS_MENU_SETTINGS,
	CS_MENU_WAREHOUSE_ACTION,
	CS_MENU_SALE_ACTION,
	CS_MENU_WAREHOUSE_S_SLOT,
}
stock GetPlayerCarsShowID(playerid) {
	new carsshow_id = 0;
	for (new cars_show_id = 0, businessid; cars_show_id < CARS_SHOW_AMOUNT; cars_show_id++) {
		businessid = CarsShowInfo[cars_show_id][csBizzID];

		if(GetString(player_name[playerid], gBusiness[businessid][bizzOwner])) {
			carsshow_id = (cars_show_id + 1);
			break;
		}
	}
	return carsshow_id;
}
stock cs_ShowPlayerMenu(playerid, menuid) {
	new cars_show_id = GetPlayerCarsShowID(playerid) - 1;
	if (cars_show_id < 0)
		return ErrorMessage(playerid, "Вы не владеете автосалоном!");
	STRING_GLOBAL[0] = EOS;
	switch (menuid) {
		case CS_MENU_MAIN: {
			ShowPlayerDialog(playerid, D_CARS_SHOW_MAIN, DIALOG_STYLE_LIST, ""P"Управление автосалоном",
				""P"1. "W"Управление склада\n\
				"P"2. "W"Управление стендами",
				"Выбрать", "Отмена"
			);
		}
		case CS_MENU_IMPORT_MAIN: {
			ShowPlayerDialog(playerid, D_CARS_SHOW_IMPORT_MAIN, DIALOG_STYLE_LIST, ""P"Центр импорта транспорта",
				""P"1. "W"Информация\n\
				"P"2. "W"Перейти к закупке",
				"Выбрать", "Отмена"
			);
		}
		case CS_MENU_IMPORT_CLASS: {
			new classAmount[4];

			for (new i = 0; i < MAX_VEHICLE_MODEL; i++) {
				/*if (VehicleImportInfo[i][viStatus] == 0)
					continue;*/
				if (VehicleImportInfo[i][viAmount] <= 0)
					continue;
				new classid = VehicleImportInfo[i][viClass];
				if (0 <= classid <= sizeof (classAmount)) {
					if (classid == 0) classid = 1;
					classAmount[classid - 1]++;
				}
			}
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
				"P"1. "W"Эконом класс\t"G"[%d в наличии]\n\
				"P"2. "W"Бизнес класс\t"G"[%d в наличии]\n\
				"P"3. "W"Спорт класс\t"G"[%d в наличии]\n\
				"P"4. "W"Мотоциклы\t"G"[%d в наличии]",
				classAmount[0], classAmount[1],
				classAmount[2], classAmount[3]
			);
			ShowPlayerDialog(playerid, D_CARS_SHOW_IMPORT_CLASS, DIALOG_STYLE_TABLIST, ""P"Выберите класс ТС", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case CS_MENU_IMPORT_LIST: {
			new classID = GetPVarInt(playerid, "SelectedClassID");

			for (new i = 0, str[256], idx = 1; i < MAX_VEHICLE_MODEL; i++) {
				if (VehicleImportInfo[i][viStatus] == 0)
					continue;
				if (VehicleImportInfo[i][viAmount] <= 0)
					continue;
				if (VehicleImportInfo[i][viClass] != classID)
					continue;
				if (idx >= MAX_CARS_LIST_ITEMS) break;

				CarsImportTempID[playerid][idx - 1] = i;

				format(str, sizeof(str), ""P"%i. "W"%s [ID: %i]\t"G"[%i/%i]\t"GREEN"$%i\n", idx++,
					gTransport[i][trName],i + 400, VehicleImportInfo[i][viAmount],
					VehicleImportInfo[i][viLimit], VehicleImportInfo[i][viPrice]
				);
				strcat(STRING_GLOBAL, str, sizeof(STRING_GLOBAL));
			}
			ShowPlayerDialog(playerid, D_CARS_SHOW_IMPORT_BUY, DIALOG_STYLE_TABLIST, ""P"Выберите транспорт", STRING_GLOBAL, "Купить", "Назад"), STRING_GLOBAL[0] = EOS;
		}
		case CS_MENU_WAREHOUSE: {
			new idx = 1;
			for (new slot = 0, str[256]; slot < MAX_CAR_SLOT_SALE; slot++) {
				if (CarsShowInfo[cars_show_id][csCarsWarehouseID][slot] == 0)
					continue;
				new modelid = CarsShowInfo[cars_show_id][csCarsWarehouseID][slot];

				CarsImportTempID[playerid][idx - 1] = slot;

				format(str, sizeof(str), "\
					"P"%i. "W"%s "G"[ID: %i]\t"G"[%i/%i]\t"G"[на складе]\n", idx++, //\t"G"[%i/%i]\t"GREEN"$%i
					gTransport[modelid - 400][trName], modelid,
					CarsShowInfo[cars_show_id][csCarsWarehouseAmount][slot], MAX_CAR_SLOT_WAREHOUSE

					/*VehicleImportInfo[modelid - 400][viAmount],
					VehicleImportInfo[modelid - 400][viLimit], VehicleImportInfo[modelid - 400][viPrice]  */
				);
				strcat(STRING_GLOBAL, str, sizeof(STRING_GLOBAL));

				if (idx >= MAX_CARS_LIST_ITEMS) break;
			}
			if(idx == 1) {
				format(STRING_GLOBAL, sizeof(STRING_GLOBAL), ""W"Пусто");
				CarsImportTempID[playerid][0] = -1;
			}
			ShowPlayerDialog(playerid, D_CARS_SHOW_WAREHOUSE, DIALOG_STYLE_TABLIST, ""P"Выберите транспорт", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case CS_MENU_WAREHOUSE_ACTION: {
			ShowPlayerDialog(playerid, D_CARS_SHOW_WAREHOUSE_ACTION, DIALOG_STYLE_TABLIST, ""P"Выберите действие", "\
				"P"1. "W"Выставить на продажу\n\
				"P"2. "W"Продать за 50%",
				"Выбрать", "Назад"
			);
		}
		case CS_MENU_WAREHOUSE_S_SLOT: {
			new idx = 1;
			for (new slot = 0, str[256]; slot < MAX_CAR_SLOT_SALE; slot++) {
				new modelid = CarsShowInfo[cars_show_id][csCarsSaleID][slot];

				if (idx >= MAX_CARS_LIST_ITEMS)
					break;
				CarsImportTempID[playerid][idx - 1] = slot;

				if (modelid == 0)
					format(str, sizeof(str), ""P"%i. "W"Пустой слот\t-\t-\n", idx++);
				else {
					format(str, sizeof(str), ""P"%i. "W"%s "G"[ID: %i]\t"G"[%i шт.]\t"G"[на продаже]\n", idx++, //\t"GREEN"$%i
						gTransport[modelid - 400][trName], modelid,
						CarsShowInfo[cars_show_id][csCarsSaleAmount][slot]
					);
				}
				strcat(STRING_GLOBAL, str, sizeof(STRING_GLOBAL));
			}
			ShowPlayerDialog(playerid, D_CARS_SHOW_WAREHOUSE_S_SLOT, DIALOG_STYLE_TABLIST, ""P"Выберите свободный слот", STRING_GLOBAL, "Выбрать", "Назад");

		}
		case CS_MENU_SALE_ACTION: {
			ShowPlayerDialog(playerid, D_CARS_SHOW_SALE_ACTION, DIALOG_STYLE_TABLIST, ""P"Выберите действие", "\
				"P"1. "W"Снять с продажи",
				"Выбрать", "Назад"
			);
		}
		case CS_MENU_SALE: {
			new idx = 1;
			for (new slot = 0, str[256]; slot < MAX_CAR_SLOT_SALE; slot++) {
				new modelid = CarsShowInfo[cars_show_id][csCarsSaleID][slot];

				if (idx >= MAX_CARS_LIST_ITEMS)
					break;
				CarsImportTempID[playerid][idx - 1] = slot;

				if (modelid == 0)
					format(str, sizeof(str), ""P"%i. "W"Пустой слот\t-\t-\n", idx++);
				else {
					format(str, sizeof(str), ""P"%i. "W"%s "G"[ID: %i]\t"G"[%i шт.]\t"G"[на продаже]\n", idx++, //\t"GREEN"$%i
						gTransport[modelid - 400][trName], modelid,
						CarsShowInfo[cars_show_id][csCarsSaleAmount][slot]
					);
				}

				strcat(STRING_GLOBAL, str, sizeof(STRING_GLOBAL));
			}
			ShowPlayerDialog(playerid, D_CARS_SHOW_SALE, DIALOG_STYLE_TABLIST, ""P"Выберите транспорт", STRING_GLOBAL, "Выбрать", "Назад");
		}
	}
	STRING_GLOBAL[0] = EOS;

	return true;
}

stock cs_ShowEditMenu(playerid, page) {
	STRING_GLOBAL[0] = EOS;
	new idx;
	for (new i = 0; i < 25; i++) {
		new vehicle_id = i + (page * 25);
		if (vehicle_id >= sizeof (VehicleImportInfo)) continue;
		format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "\
			"P"%i.%i. "W"%s [ID: %i]\t["GREEN"$%i"W"]\t[%d шт.]\n",
			page, 
			idx + 1, 
			gTransport[vehicle_id][trName], vehicle_id + 400,
			VehicleImportInfo[vehicle_id][viPrice], 
			VehicleImportInfo[vehicle_id][viAmount]
		);
		strcat(STRING_GLOBAL, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;
		playerListitemID[playerid][idx++] = vehicle_id;
	}
	playerListitemID[playerid][idx++] = 101;
	playerListitemID[playerid][idx++] = 102;
	strcat(STRING_GLOBAL, ""P"[>>] "W"Далее\n"G"[<<] "W"Назад");

	ShowPlayerDialog(playerid, D_EDIT_VEH_IMPORT, DIALOG_STYLE_TABLIST, ""P"Изменение цен и кол-ва ТС", STRING_GLOBAL, "Выбрать", "Отмена");
	SetPVarInt(playerid, "cs_ShowEditPage", page);
	return true;
}
CMD:carsedit(playerid) {
	if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) 
		return true;
	cs_ShowEditMenu(playerid, 0);
	return true;
}