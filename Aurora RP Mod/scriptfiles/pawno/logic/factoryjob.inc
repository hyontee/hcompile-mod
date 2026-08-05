#if defined _factoryjob_included
	#endinput
#endif
#define _factoryjob_included

#define MAX_FACTORY_VEHICLES		6
#define MAX_FACTORY_FILL_POS		3
#define MAX_FACTORY_TRAILER_POS		3

#define FACTORY_VEHICLE_JOB_ID		90
#define FACTORY_VEHICLE_RENT_COST	50

#define FACTORY_JOB_PROCESS_ID		21

#define PAYDAY_FACTORY_JOB_1		9
#define PAYDAY_FACTORY_JOB_2		80

static const Float:FactoryVehiclePos[MAX_FACTORY_VEHICLES][4] = {
	{ -60.9565, -303.5059, 6.0039, 271.4461 },
	{ -60.6222, -309.0308, 6.0141, 271.5480 },
	{ -60.6572, -314.7099, 6.0142, 272.0332 },
	{ -60.8333, -321.5571, 5.9910, 269.3463 },
	{ -61.2890, -334.8450, 6.0136, 269.4952 },
	{ -61.2226, -341.0784, 6.0142, 271.6563 }
};
static const Float:FactoryFillTrailerPos[MAX_FACTORY_FILL_POS][4] = {
	{ -0.29970, -360.1688, 5.4297, 270.000 },
	{ -15.2980, -360.2271, 5.4297, 270.000 },
	{ -30.0891, -360.1618, 5.4297, 270.000 }
};
new const Float:FactoryTrailerVehiclePos[MAX_FACTORY_TRAILER_POS][4] = {
	{ -6.81700, -373.1570, 6.597, 0.000 },
	{ -22.1835, -374.2504, 6.475, 0.000 },
	{ -36.6759, -373.4599, 6.450, 0.000 }
};
#define MAX_FACTORY_CELL			3 * 2

enum {
	FACTORY_CELL_STATUS_NONE = 0,
	FACTORY_CELL_STATUS_LOADING,
	FACTORY_CELL_STATUS_PROCCESING,
	FACTORY_CELL_STATUS_FREEZED,
}
enum {
	FACTORY_CELL_FILTRATION = 1,
	FACTORY_CELL_HOT,
	FACTORY_CELL_FREEZE,
}
enum FACTORY_CELL_E {
	Float:cellTextPos[3],
	Float:cellPlayerPos[4],
	cellType,
	Text3D:cellText,
	cellAmount,
	cellArea,
	cellStatus,
	//cellTimer,
	cellProcess,
	cellEffectsObjectID[3],
	cellFullMilkObjectID[2],
}
new FactoryCellInfo[MAX_FACTORY_CELL][FACTORY_CELL_E] = {
	{ { 1370.894, 1577.415, 3000.714 }, {1369.0826, 1577.4301, 3000.4705, 0.000}, FACTORY_CELL_FILTRATION }, // [1] отсек фильтрации
	{ { 1370.894, 1595.868, 3000.734 }, {1369.0820, 1595.9080, 3000.4001, 0.000}, FACTORY_CELL_FILTRATION }, // [2] отсек фильтрации

	{ { 1370.894, 1580.826, 3000.714 }, {1369.0789, 1580.8820, 3000.4001, 0.000}, FACTORY_CELL_HOT }, // [1] отсек горячий
	{ { 1370.894, 1592.318, 3000.734 }, {1369.0825, 1592.3652, 3000.4001, 0.000}, FACTORY_CELL_HOT }, // [2] отсек горячий

	{ { 1370.894, 1584.357, 3000.734 }, {1369.0800, 1584.4565, 3000.4001, 0.000}, FACTORY_CELL_FREEZE }, // [1] отсек холодный
	{ { 1370.894, 1588.936, 3000.734 }, {1369.0817, 1588.8440, 3000.4705, 0.000}, FACTORY_CELL_FREEZE } // [2] отсек холодный
};
static const Float:FactoryFullMilkPos[MAX_FACTORY_CELL * 2][6] = {
	{ 1370.893920, 1577.415527, 3000.713867, 0.000000, 90.000000, 180.000000 }, 
	{ 1370.893920, 1595.868530, 3000.733886, 0.000000, 90.000000, -179.999984 },
	{ 1370.893920, 1580.826538, 3000.713867, 0.000000, 90.000000, -179.999984 },
	{ 1370.893920, 1592.318603, 3000.733886, 0.000000, 90.000000, -179.999984 }, 
	{ 1370.893920, 1584.357543, 3000.733886, 0.000000, 90.000000, -179.999984 }, 
	{ 1370.893920, 1588.936767, 3000.733886, 0.000000, 90.000000, -179.999984 }, 

	{ 1370.773803, 1577.305419, 3000.732910, 0.000000, 90.000000, 90.000000 }, 
	{ 1370.773803, 1595.758422, 3000.752929, -0.000015, 90.000000, 90.000000 }, 
	{ 1370.773803, 1580.716430, 3000.732910, -0.000002, 90.000000, 90.000000 }, 
	{ 1370.773803, 1592.208496, 3000.752929, -0.000012, 90.000000, 90.000000 }, 
	{ 1370.773803, 1584.247436, 3000.752929, -0.000007, 90.000000, 90.000000 }, 
	{ 1370.773803, 1588.826660, 3000.752929, -0.000017, 90.000000, 90.000000 } 
};
stock factory_CreateFullMilkObjects(cell_id) {
	new objectid = FactoryCellInfo[cell_id][cellFullMilkObjectID][0] = CreateDynamicObject(19480, 
		FactoryFullMilkPos[cell_id][0], FactoryFullMilkPos[cell_id][1], FactoryFullMilkPos[cell_id][2], 
		FactoryFullMilkPos[cell_id][3], FactoryFullMilkPos[cell_id][4], FactoryFullMilkPos[cell_id][5], 
		5, 4, -1, 60.00, 60.00
	); 
	// SetDynamicObjectMaterial(objectid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(objectid, 0, "l", 120, "Wingdings", 110, 1, 0xFFFFFFFF, 0x00000000, 1); 

	objectid = FactoryCellInfo[cell_id][cellFullMilkObjectID][1] = CreateDynamicObject(19480, 
		FactoryFullMilkPos[cell_id + 6][0], FactoryFullMilkPos[cell_id + 6][1], FactoryFullMilkPos[cell_id + 6][2], 
		FactoryFullMilkPos[cell_id + 6][3], FactoryFullMilkPos[cell_id + 6][4], FactoryFullMilkPos[cell_id + 6][5], 
		5, 4, -1, 60.00, 60.00
	); 
	// SetDynamicObjectMaterial(objectid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(objectid, 0, "l", 120, "Wingdings", 110, 1, 0xFFFFFFFF, 0x00000000, 1);
}
stock factory_DestroyFullMilkObjects(cell_id) {
	DestroyDynamicObject(FactoryCellInfo[cell_id][cellFullMilkObjectID][0]);
	DestroyDynamicObject(FactoryCellInfo[cell_id][cellFullMilkObjectID][1]);

	FactoryCellInfo[cell_id][cellFullMilkObjectID][0] = -1;
	FactoryCellInfo[cell_id][cellFullMilkObjectID][1] = -1;
}
enum FACTORY_VEHICLE_E {
	factoryVehicleID,
	Float:factoryVehiclePos[4],
	factoryVehicleOwnerID,
	factoryVehicleMilkAmount,
	Text3D:factoryVehicleTextID,
}
enum FACTORY_JOB_E {
	factoryCellID,
	factoryJobCollected,
	factoryTruckProcess,
	factoryLoading,
}
new
	FactoryJob_PI[MAX_PLAYERS][FACTORY_JOB_E],
	FactoryVehicleInfo[MAX_FACTORY_VEHICLES][FACTORY_VEHICLE_E]
;
factory_OnGameModeInit() {
	new tmpobjid = CreateDynamicObject(18972, 1370.661743, 1580.823120, 2999.362060, 0.000000, 0.000000, 0.000000, 5, 4, -1, 50.00, 50.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFFFFFFFF);
	// SetDynamicObjectMaterial(tmpobjid, 1, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
	tmpobjid = CreateDynamicObject(18972, 1370.661743, 1592.294433, 2999.362060, 0.000000, 0.000000, 0.000000, 5, 4, -1, 50.00, 50.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFFFFFFFF);
	// SetDynamicObjectMaterial(tmpobjid, 1, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);

	CreateDynamicMapIcon(1079.6270, 1903.3024, 16.4873, 51, CWHITE); // Склад продуктов ЛВ

	for (new i = 0; i < MAX_FACTORY_CELL; i++) {
		FactoryCellInfo[i][cellText] = CreateDynamic3DTextLabel(" ", 0xFFFFFFFF,
			FactoryCellInfo[i][cellTextPos][0], FactoryCellInfo[i][cellTextPos][1], FactoryCellInfo[i][cellTextPos][2],
			7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
			0/* testlos */, 5, 4, -1
		);
		FactoryCellInfo[i][cellStatus] = FACTORY_CELL_STATUS_NONE;

		FactoryCellInfo[i][cellAmount] = 0;
		FactoryCellInfo[i][cellProcess] = 0;

		switch (FactoryCellInfo[i][cellType]) {
			case FACTORY_CELL_FILTRATION: {
				CreateDynamicObjectCP(
					FactoryCellInfo[i][cellPlayerPos][0], FactoryCellInfo[i][cellPlayerPos][1], FactoryCellInfo[i][cellPlayerPos][2],
					5.0, 5, 4
				);
				FactoryCellInfo[i][cellArea] = CreateDynamicSphere(
					FactoryCellInfo[i][cellPlayerPos][0], FactoryCellInfo[i][cellPlayerPos][1], FactoryCellInfo[i][cellPlayerPos][2],
					0.5, 5, 4
				);
			}
			default: {
				FactoryCellInfo[i][cellArea] = -1;
			}
		}
		FactoryCellInfo[i][cellFullMilkObjectID][0] = FactoryCellInfo[i][cellFullMilkObjectID][1] = -1;
		FactoryCellInfo[i][cellEffectsObjectID][0] = FactoryCellInfo[i][cellEffectsObjectID][1] = 
		FactoryCellInfo[i][cellEffectsObjectID][2] = -1;

		factory_UpdateCellText(i);
	}
	CreateDynamic3DTextLabel(""P"Управление отсеками [1]\n \n"W"Нажмите "P"\"ALT\"", 0xFFFFFFFF,
		1367.9537, 1586.0359, 3000.4001,
		4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
		0/* testlos */, 5, 4, -1
	);
	CreateDynamic3DTextLabel(""P"Управление отсеками [2]\n \n"W"Нажмите "P"\"ALT\"", 0xFFFFFFFF,
		1367.9568, 1587.6581, 3000.4001,
		4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
		0/* testlos */, 5, 4, -1
	);
	CreateDynamicObjectCP(1367.9537, 1586.0359, 3000.4001, 4.05);
	CreateDynamicObjectCP(1367.9568, 1587.6581, 3000.4001, 4.05);

	CreateDynamicPickup(1239, 23, 1367.9537, 1586.0359, 3000.4001, 5, 4);
	CreateDynamicPickup(1239, 23, 1367.9568, 1587.6581, 3000.4001, 5, 4);


	CreateDynamic3DTextLabel(""P"Разгрузка молочных продуктов\n \n"W"Чтобы разгрузиться, нажмите "P"\"H\"", 0xFFFFFFFF,
		1067.8579, 1890.2605, 10.8203,
		7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
		0/* testlos */, 0, 0, -1
	);
	CreateDynamicObjectCP(1067.8579, 1890.2605, 10.8203, 7.5);

	CreateDynamicPickup(19134, 23, 1067.8579, 1890.2605, 10.8203, 0, 0);

	for (new i = 0; i < MAX_FACTORY_FILL_POS; i++) {
		CreateDynamic3DTextLabel(""P"Заполнить цистерну\n \n"W"Чтобы начать процесс, нажмите "P"\"ALT\"", 0xFFFFFFFF,
			FactoryFillTrailerPos[i][0], FactoryFillTrailerPos[i][1], FactoryFillTrailerPos[i][2],
			7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
			0/* testlos */, 0, 0, -1
		);
		CreateDynamicObjectCP(FactoryFillTrailerPos[i][0], FactoryFillTrailerPos[i][1], FactoryFillTrailerPos[i][2], 7.5);

		CreateDynamicPickup(1239, 23, FactoryFillTrailerPos[i][0], FactoryFillTrailerPos[i][1], FactoryFillTrailerPos[i][2], 0, 0);
	}
	new actorid = CreateActor(59, 1177.4626, 1575.2095, 3001.1030, 280);
	SetActorVirtualWorld(actorid, 5);

	// factoryJobPickup[0] = CreateDynamicPickup(1275, 23, 1178.8324, 1575.6246, 3001.1030, 5, 4); // join

	CreateDynamic3DTextLabel(""P"Склад молока\n \n"W"Чтобы взять, нажмите "P"\"ALT\"", 0xFFFFFFFF,
		1180.0198, 1542.7045, 3001.1289,
		2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,
		0/* testlos */, 5, 4, -1
	);
	CreateDynamicObjectCP(1180.0198, 1542.7045, 3001.1289, 2.5, 5, 4);
	CreateDynamicPickup(3632, 23, 1180.0198, 1542.7045, 3001.1289, 5, 4); // take milk barriel

	CreateDynamicMapIcon(-49.9145, -269.3650, 6.6332, 11, CWHITE);

	for(new i = 0; i < MAX_FACTORY_VEHICLES; i++) {
		new vehicleid = FactoryVehicleInfo[i][factoryVehicleID] = CreateJobVehicle(FACTORY_VEHICLE_JOB_ID, 403,
			FactoryVehiclePos[i][0], FactoryVehiclePos[i][1], FactoryVehiclePos[i][2], FactoryVehiclePos[i][3],
			random(255), random(255), RES_CAR_TIME
		);
		FactoryVehicleInfo[i][factoryVehicleTextID] = CreateDynamic3DTextLabel(STRING_GLOBAL, 0xFFFFFFFF,
			0.0, 0.0, 1.0, FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, vehicleid,
			0/* testlos */, 0, 0, -1
		);
		FactoryVehicleInfo[i][factoryVehiclePos][0] = FactoryVehiclePos[i][0];
		FactoryVehicleInfo[i][factoryVehiclePos][1] = FactoryVehiclePos[i][1];
		FactoryVehicleInfo[i][factoryVehiclePos][2] = FactoryVehiclePos[i][2];
		FactoryVehicleInfo[i][factoryVehiclePos][3] = FactoryVehiclePos[i][3];

		FactoryVehicleInfo[i][factoryVehicleOwnerID] = INVALID_PLAYER_ID;
		// farm_UpdateVehicleText(i);

		SignalTick[vehicleid][1] = -1;
		LightsObject[vehicleid][0] = -1;
		LightsObject[vehicleid][1] = -1;
		SetVehicleParamsEx(vehicleid, false, false, false, false, false, false, false);

		VehicleInfo[vehicleid][vFuel] = gTransport[GetVehicleModel(vehicleid) - 400][trTank];
		VehicleInfo[vehicleid][vPlayer] = -1;
	}
}
factory_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	new factory_jobid = GetPVarInt(playerid, "factoryJob");
	if (!factory_jobid)
		return false;

	if (factory_jobid == 2 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && (newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH)) {
		new vehicleid = GetPlayerVehicleID(playerid);
		if (IsPlayerInRangeOfPoint(playerid, 7.0, 1067.8579, 1890.2605, 10.8203)) {
			new target_vehicleid = GetVehicleTrailer(vehicleid);
			// printf("target_vehicleid = %d | Factory_Trailer = %d\n", target_vehicleid, Factory_Trailer[playerid]);

			if (Factory_Trailer[playerid] != INVALID_VEHICLE_ID && Factory_Trailer[playerid] == target_vehicleid) {
				FactoryJob_PI[playerid][factoryJobCollected]++;
				DetachTrailerFromVehicle(Factory_Trailer[playerid]);
				A_DestroyVehicle(Factory_Trailer[playerid]);
				Factory_Trailer[playerid] = INVALID_VEHICLE_ID;
				Factory_TrailerTime[playerid] = 0;

				SendOk(playerid, "Вы успешно разгрузили цистерну с молоком на склад.");

				return true;
			}
		}
	}
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return false;
	if ((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)) {
		new bool:isReturn = false;
		switch (factory_jobid) {
			case 1: {
				if (IsPlayerInRangeOfPoint(playerid, 0.5, 1367.9537, 1586.0359, 3000.4001)) {
					FactoryJob_PI[playerid][factoryCellID] = 0;

					ShowPlayerDialog(playerid, D_FACTORYJOB_CELL, DIALOG_STYLE_LIST, ""P"Управление отсеками [1]", \
						""P"1. "W"Запустить отсек фильтрации\n\
						"P"2. "W"Запустить отсек горячей обработки\n\
						"P"3. "W"Запустить отсек холодной обратоки\n\
						"P"4. "W"Перелить в резервуар",
						"Выбрать", "Отмена"
					);
					return true;
				}
				else if (IsPlayerInRangeOfPoint(playerid, 0.5, 1367.9537, 1587.6581, 3000.4001)) {
					FactoryJob_PI[playerid][factoryCellID] = 1;

					ShowPlayerDialog(playerid, D_FACTORYJOB_CELL, DIALOG_STYLE_LIST, ""P"Управление отсеками [1]", \
						""P"1. "W"Запустить отсек фильтрации\n\
						"P"2. "W"Запустить отсек горячей обработки\n\
						"P"3. "W"Запустить отсек холодной обратоки\n\
						"P"4. "W"Перелить в резервуар",
						"Выбрать", "Отмена"
					);
					return true;
				}
				else if (IsPlayerInRangeOfPoint(playerid, 0.5, 1180.0198, 1542.7045, 3001.1289)) {
					if (!GetPVarInt(playerid, "factoryMilkTaken")) {
						SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_1, 3632, 6,
							0.000000, 0.127999, -0.247999, -17.699998, -6.599999, 82.199981, 0.775999, 0.727999, 0.858000
						);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
						SetPVarInt(playerid, "factoryMilkTaken", 1);

						SendOk(playerid, "Вы взяли бочку с молоком, отправляйтесь в цех, перелейте молоко в отсек фильтрации.");
						return true;
					}
				}
			}
			case 2: {
				for (new i = 0; i < MAX_FACTORY_FILL_POS; i++) {
					if (!IsPlayerInRangeOfPoint(playerid, 0.5, FactoryFillTrailerPos[i][0], FactoryFillTrailerPos[i][1], FactoryFillTrailerPos[i][2]))
						continue;
					factory_ActionFillTrailer(playerid, i);
					isReturn = true;
					break;
				}
				if (isReturn) return true;
			}
		}
	}
	return false;
}
stock factory_ActionFillTrailer(playerid, id) {
	if (JobTempProcess[playerid])
		return;
	if(Factory_Trailer[playerid] != INVALID_VEHICLE_ID) {
		ErrorMessage(playerid, "У Вас уже есть груз");
		return;
	}

	JobTempProcess[playerid] = FACTORY_JOB_PROCESS_ID;
	TI[playerid][tProcess][0] = 0;
	TI[playerid][tProcess][1] = 10;
	PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
	for(new YN = 0; YN < 3; YN++)
	{
		TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
		if (YN < 2) PlayerTextDrawShow(playerid, YandNsysTDPlayer[playerid][YN]);
	}
	RandomYareNforJOBS(playerid);
	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 1, 1, 1, 1);

	SetPlayerPosAC(playerid, FactoryFillTrailerPos[id][0], FactoryFillTrailerPos[id][1], FactoryFillTrailerPos[id][2], 0, 0);
	SetPlayerFacingAngle(playerid, FactoryFillTrailerPos[id][3]);

	SetPVarInt(playerid, "factoryTrailerFillID", id);
}
stock factory_PutMilk(playerid, cell_id) {
	if (
		FactoryCellInfo[cell_id][cellStatus] != FACTORY_CELL_STATUS_NONE ||
		FactoryCellInfo[cell_id][cellAmount] >= 10
	) {
		ErrorMessage(playerid, "Пожалуйста, подождите..");
		return;
	}
	FactoryJob_PI[playerid][factoryCellID] = cell_id;

	DeletePVar(playerid, "factoryMilkTaken");
	FactoryCellInfo[cell_id][cellAmount]++;
	FactoryJob_PI[playerid][factoryJobCollected]++;

	if (FactoryCellInfo[cell_id][cellAmount] >= 10) {
		FactoryCellInfo[cell_id][cellStatus] = FACTORY_CELL_STATUS_LOADING;
		FactoryCellInfo[cell_id][cellProcess] = 0;
	}
	SetPlayerPosAC(playerid,
		FactoryCellInfo[cell_id][cellPlayerPos][0], FactoryCellInfo[cell_id][cellPlayerPos][1],
		FactoryCellInfo[cell_id][cellPlayerPos][2], 5, 4
	);
	SetPlayerFacingAngle(playerid, FactoryCellInfo[cell_id][cellPlayerPos][3]);

 	SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_1, 3632, 6, 0.000000, 0.190999, -0.102999, -14.100002, 0.000000, 82.299987, 0.775999, 0.727999, 0.858000);
	SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 18705, 6, -0.049999, 1.730000, -0.019999, 79.599983, 0.000000, 0.000000);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	TogglePlayerControllable(playerid, false);
	FactoryJob_PI[playerid][factoryLoading] = 1;
	ShowJobProcessTD(playerid);
	factory_UpdateCellText(cell_id);
}

stock factory_UpdateCellText(cell_id) {
	switch (FactoryCellInfo[cell_id][cellType]) {
		case FACTORY_CELL_FILTRATION: {
			switch (FactoryCellInfo[cell_id][cellStatus]) {
				case FACTORY_CELL_STATUS_NONE, FACTORY_CELL_STATUS_LOADING: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек фильтрации\n \n"W"Загружен на "P"%d%",
						FactoryCellInfo[cell_id][cellAmount] * 10
					);
				}
				/*case FACTORY_CELL_STATUS_LOADING: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек фильтрации\n \n"W"Процесс загрузки "P"(%d%)",
						FactoryCellInfo[cell_id][cellProcess]
					);
				}*/
				case FACTORY_CELL_STATUS_PROCCESING: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек фильтрации\n \n"W"Идёт процесс фильтрации "P"(%d%%)",
						FactoryCellInfo[cell_id][cellProcess]
					);

				}
			}
		}
		case FACTORY_CELL_HOT: {
			switch (FactoryCellInfo[cell_id][cellStatus]) {
				case FACTORY_CELL_STATUS_NONE: {
					if (FactoryCellInfo[cell_id][cellAmount] == 10) {
						format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
							"P"Отсек горячей обработки\n \n"W"Загружен на "P"%d%",
						FactoryCellInfo[cell_id][cellAmount] * 10
						);
					}
					else {
						format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
							"P"Отсек горячей обработки\n \n"W"В ожидании.."
						);
					}
				}
				case FACTORY_CELL_STATUS_LOADING: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек горячей обработки\n \n"W"Процесс обработки "P"(%d%%)",
						FactoryCellInfo[cell_id][cellProcess]
					);
				}
			}
		}
		case FACTORY_CELL_FREEZE: {
			switch (FactoryCellInfo[cell_id][cellStatus]) {
				case FACTORY_CELL_STATUS_NONE: {
					if (FactoryCellInfo[cell_id][cellAmount] == 10) {
						format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
							"P"Отсек холодной обработки\n \n"W"Загружен на "P"%d%",
						FactoryCellInfo[cell_id][cellAmount] * 10
						);
					}
					else {
						format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
							"P"Отсек холодной обработки\n \n"W"В ожидании.."
						);
					}
				}
				case FACTORY_CELL_STATUS_LOADING: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек холодной обработки\n \n"W"Процесс обработки "P"(%d%%)",
						FactoryCellInfo[cell_id][cellProcess]
					);
				}
				case FACTORY_CELL_STATUS_FREEZED: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек холодной обработки\n \n"W"Процесс обработки "P"(100%%)"
					);
				}
				case FACTORY_CELL_STATUS_PROCCESING: {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
						"P"Отсек холодной обработки\n \n"W"Процесс переливания "P"(%d%%)",
						FactoryCellInfo[cell_id][cellProcess]
					);
				}
			}
		}
	}
	UpdateDynamic3DTextLabelText(FactoryCellInfo[cell_id][cellText], 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
}
stock factory_Timer() {
	for (new cell_id = 0; cell_id < MAX_FACTORY_CELL; cell_id++) {
		switch (FactoryCellInfo[cell_id][cellType]) {
			case FACTORY_CELL_FILTRATION: {
				switch (FactoryCellInfo[cell_id][cellStatus]) {
					case FACTORY_CELL_STATUS_PROCCESING: {
						FactoryCellInfo[cell_id][cellProcess] += 5;

						if (FactoryCellInfo[cell_id][cellProcess] > 100) {
							FactoryCellInfo[cell_id][cellStatus] = FACTORY_CELL_STATUS_NONE;
							FactoryCellInfo[cell_id][cellProcess] = 0;

							FactoryCellInfo[cell_id][cellAmount] = 0;
							factory_DestroyFullMilkObjects(cell_id);

							new next_cell_id = cell_id + 2;
							FactoryCellInfo[next_cell_id][cellAmount] = 10;
							factory_CreateFullMilkObjects(next_cell_id);

							FactoryCellInfo[next_cell_id][cellProcess] = 0;

							factory_UpdateCellText(next_cell_id);
						}
						factory_UpdateCellText(cell_id);
					}
				}
				
			}
			case FACTORY_CELL_HOT: {
				switch (FactoryCellInfo[cell_id][cellStatus]) {
					case FACTORY_CELL_STATUS_LOADING: {
						FactoryCellInfo[cell_id][cellProcess] += 5;

						if (FactoryCellInfo[cell_id][cellProcess] > 100) {
							FactoryCellInfo[cell_id][cellStatus] = FACTORY_CELL_STATUS_NONE;
							FactoryCellInfo[cell_id][cellProcess] = 0;
							FactoryCellInfo[cell_id][cellAmount] = 0;

							factory_DestroyFullMilkObjects(cell_id);
							DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][0]);
							DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][1]);
							DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][2]);
							FactoryCellInfo[cell_id][cellEffectsObjectID][0] = -1;
							FactoryCellInfo[cell_id][cellEffectsObjectID][1] = -1;
							FactoryCellInfo[cell_id][cellEffectsObjectID][2] = -1;

							new next_cell_id = cell_id + 2;
							FactoryCellInfo[next_cell_id][cellAmount] = 10;
							factory_CreateFullMilkObjects(next_cell_id);

							FactoryCellInfo[next_cell_id][cellProcess] = 0;

							factory_UpdateCellText(next_cell_id);
						}
						factory_UpdateCellText(cell_id);
					}
				}
			}
			case FACTORY_CELL_FREEZE: {
				switch (FactoryCellInfo[cell_id][cellStatus]) {
					case FACTORY_CELL_STATUS_LOADING: {
						FactoryCellInfo[cell_id][cellProcess] += 5;

						if (FactoryCellInfo[cell_id][cellProcess] > 100) {
							FactoryCellInfo[cell_id][cellStatus] = FACTORY_CELL_STATUS_FREEZED;
							FactoryCellInfo[cell_id][cellProcess] = 0;
							FactoryCellInfo[cell_id][cellAmount] = 0;

							DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][0]);
							DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][1]);
							FactoryCellInfo[cell_id][cellEffectsObjectID][0] = -1;
							FactoryCellInfo[cell_id][cellEffectsObjectID][1] = -1;

							//factory_DestroyFullMilkObjects(cell_id);
						}
						factory_UpdateCellText(cell_id);
					}
					case FACTORY_CELL_STATUS_PROCCESING: {
						FactoryCellInfo[cell_id][cellProcess] += 5;

						if (FactoryCellInfo[cell_id][cellProcess] > 100) {
							FactoryCellInfo[cell_id][cellStatus] = FACTORY_CELL_STATUS_NONE;
							FactoryCellInfo[cell_id][cellProcess] = 0;
							FactoryCellInfo[cell_id][cellAmount] = 0;

							/*DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][0]);
							DestroyDynamicObject(FactoryCellInfo[cell_id][cellEffectsObjectID][1]);
							FactoryCellInfo[cell_id][cellEffectsObjectID][0] = -1;
							FactoryCellInfo[cell_id][cellEffectsObjectID][1] = -1;*/

							factory_DestroyFullMilkObjects(cell_id);
						}
						factory_UpdateCellText(cell_id);
					}
				}
			}
		}
	}
}
stock factory_ResetRentVehicle(factory_vehicleid, playerid = INVALID_PLAYER_ID) {
	new vehicleid = FactoryVehicleInfo[factory_vehicleid][factoryVehicleID];

	VehicleInfo[vehicleid][vPlayer] = -1;
	FactoryVehicleInfo[factory_vehicleid][factoryVehicleOwnerID] = INVALID_PLAYER_ID;
	SetVehicleToRespawn(vehicleid);

	if (playerid != INVALID_PLAYER_ID) {
		if (Factory_Trailer[playerid] != INVALID_VEHICLE_ID) {
			A_DestroyVehicle(Factory_Trailer[playerid]);
			Factory_Trailer[playerid] = INVALID_VEHICLE_ID;
			Factory_TrailerTime[playerid] = 0;
		}
		if (TI[playerid][tArendaCar] == vehicleid) {
			TI[playerid][tArendaCar] = -1;
			SetPVarInt(playerid, "factoryTempVehicleID", -1);
		}
	}
}