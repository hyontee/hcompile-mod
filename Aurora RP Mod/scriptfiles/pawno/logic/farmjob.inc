#if defined _farmjob_included
	#endinput
#endif
#define _farmjob_included

#define MAX_FARM_PLANT_ZONES	(5)
#define FARM_PLANT_DISTANCE		(2.6) // default = 2.6
#define FARM_PLANTS_TIMER		(5) // every 5s
#define FARM_PLANT_100_TIMER	(60) // default = 1m [60s]
#define FARM_PLANT_OBJECT_SD	150.0 // default = 150.0

#define FARM_JOB_PROCESS_ID		20
#define FARM_VEHICLE_JOB_ID		80

#define PAYDAY_FARM_JOB_1		14
#define PAYDAY_FARM_JOB_2		9
#define PAYDAY_FARM_JOB_3		60

#define FARM_MINUS_Z%0(%1) 	\
		( 1.446 + (((2.546 - 1.446) / 100) * (%1)) )

#define MAX_FARM_PLANTS			300
#define MAX_PLAYER_FARM_PLANTS	50
#define MAX_FARM_COWS			12
#define MAX_FARM_VEHICLES		6

#define MAX_FARM_VEHICLE_MILK	10

#define FARM_VEHICLE_RENT_COST	50

static const Float:FarmVehiclePos[MAX_FARM_VEHICLES][4] = {
	{ -408.207, -1413.795, 26.914, 300.142 }, 
	{ -412.224, -1418.673, 27.125, 300.142 }, 
	{ -413.458, -1421.856, 27.459, 300.142 }, 
	{ -415.122, -1426.410, 27.924, 300.142 }, 
	{ -416.135, -1431.445, 28.329, 300.142 }, 
	{ -417.127, -1436.153, 28.713, 300.142 }
};
enum FARM_VEHICLE_E {
	farmVehicleID,
	Float:farmVehiclePos[4],
	farmVehicleOwnerID,
	farmVehicleMilkAmount,
	Text3D:farmVehicleTextID,
}
static const Float:FarmPlantZonePos[MAX_FARM_PLANT_ZONES][4] = {
	{ -324.0, -1416.0, -166.0, -1313.0 }, // 1.1
	{ -324.0, -1428.0, -224.0, -1415.0 }, // 1.2
	{ -334.0, -1428.0, -324.0, -1394.0 }, // 1.3
	{ -333.0, -1557.0, -237.0, -1470.0 }, // 2.1
	{ -238.0, -1527.0, -216.0, -1470.0 } // 2.2
};
static const Float:FarmCowPos[MAX_FARM_COWS][4] = {
	{ -378.226379, -1452.381347, 24.7, 90.000 },
	{ -378.456756, -1449.718994, 24.7, 151.30 },
	{ -378.206878, -1447.294189, 24.7, 66.200 },
	{ -396.837554, -1444.949829, 24.7, -173.5 },
	{ -396.567810, -1437.790771, 24.7, 6.5000 },
	{ -392.435516, -1442.400024, 24.7, -149.7 },
	{ -394.617980, -1443.942138, 24.7, -88.40 },
	{ -398.787414, -1438.798339, 24.7, 91.600 },
	{ -400.969848, -1440.340454, 24.7, 30.300 },
	{ -372.142395, -1446.051879, 24.7, -90.00 },
	{ -371.912017, -1448.714233, 24.7, -28.70 },
	{ -372.161895, -1451.139038, 24.7, -113.8 }
};
static const Float:FarmCowMilkBucketPos[MAX_FARM_COWS][4] = {
	{ -378.678863, -1450.125366, 24.847723, -149.699920 },
	{ -378.664947, -1452.329223, 24.847723, -149.699920 },
	{ -378.625061, -1447.105712, 24.847723, -149.699920 },
	{ -396.806182, -1445.406127, 24.847723, -149.699920 },
	{ -396.616851, -1437.326660, 24.847723, -149.699920 },
	{ -392.193328, -1442.814453, 24.847723, -149.699920 },
	{ -394.184997, -1443.885742, 24.847723, -149.699920 },
	{ -399.204803, -1438.804199, 24.847723, -149.699920 },
	{ -401.235778, -1439.886840, 24.847723, -149.699920 },
	{ -371.657745, -1446.046630, 24.847723, -149.699920 },
	{ -371.699371, -1448.294189, 24.847723, -149.699920 },
	{ -371.749572, -1451.299438, 24.847723, -149.699920 }
};
static const Float:FarmCowMilkPos[MAX_FARM_COWS][4] = {
	{ -378.3504, -1451.8097, 25.7449, 174.241 }, 
	{ -378.0669, -1450.1952, 25.7449, 59.6022 }, 
	{ -378.1150, -1446.6996, 25.7449, 144.996 }, 
	{ -396.2436, -1445.1888, 25.7371, 83.7316 }, 
	{ -396.0125, -1437.5580, 25.7449, 95.8681 }, 
	{ -392.8452, -1442.8531, 25.7371, 286.833 }, 
	{ -394.3756, -1443.3690, 25.7371, 179.359 }, 
	{ -399.0588, -1439.3733, 25.7449, 5.20960 }, 
	{ -400.5401, -1439.9386, 25.7449, 118.679 }, 
	{ -371.9371, -1446.6383, 25.7371, 346.782 },
	{ -372.2716, -1448.1981, 25.7371, 244.133 }, 
	{ -371.7202, -1450.7106, 25.7371, 143.242 }
};
enum {
	FARM_PLANT_STATUS_NONE = 0,
	FARM_PLANT_STATUS_PLANTED,
	FARM_PLANT_STATUS_GROWING,
}
enum {
	FARM_COW_STATUS_HUNGRY = 0,
	FARM_COW_STATUS_FULL,
}
enum FARM_COWS_E {
	farmCowOwnerID,
	farmCowObjectID,
	Text3D:farmCowTextID,
	Float:farmCowPos[3],
	farmCowStatus,
	farmCowTimer,
}
enum FARM_PLANT_E { 
	farmPlantOwnerID,
	farmPlantObjectID,

	Text3D:farmPlantTextID,
	Float:farmPlantPos[3],
	Float:farmPlantProcess,

	farmPlantStatus,
}
enum FARMJOB_PLAYER_E {
	farmPlantsAmount,
	farmWaterAmount,
	farmPlantedAmount,
	farmPlantsCollected,

	farmJobCollected,

	farmPlantTime,
	farmRentVehicleID,
}
new 
	FarmJob_PI[MAX_PLAYERS][FARMJOB_PLAYER_E], 
	FarmVehicleInfo[MAX_FARM_VEHICLES][FARM_VEHICLE_E],
	FarmPlantInfo[MAX_FARM_PLANTS][FARM_PLANT_E],
	FarmCowInfo[MAX_FARM_COWS][FARM_COWS_E],

	FarmPlantGangZone[MAX_FARM_PLANT_ZONES],
	Iterator:farmPlants<MAX_FARM_PLANTS>, 
	farmMilkAmount = 4000,
	Text3D:farmMilkTextID
;
static farmPlantsTimer;

farm_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;
	new farm_jobid = GetPVarInt(playerid, "farmJob");
	if (!farm_jobid) 
		return false;
	if ((newkeys & KEY_CTRL_BACK) && !(oldkeys & KEY_CTRL_BACK) && TI[playerid][tArendaCar] != -1) {
		if (VehicleInfo[TI[playerid][tArendaCar]][vJob] == FARM_VEHICLE_JOB_ID && farm_jobid == 3) {
			new Float:x, Float:y, Float:z;
			GetVehicleShiftPos(TI[playerid][tArendaCar], 1, x, y, z, 2.0);
			if (IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z)) {

				if (GetPVarInt(playerid, "farmMilkTaken")) {
					ClearAnims(playerid);
					if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_JOB_2)) 
						RemovePlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2);
					SendOk(playerid, "Вы загрузили бидон с молоком в транспорт.");
					DeletePVar(playerid, "farmMilkTaken");

					FarmVehicleInfo[GetPVarInt(playerid, "farmTempVehicleID")][farmVehicleMilkAmount]++;
					farm_UpdateVehicleText(GetPVarInt(playerid, "farmTempVehicleID"));

					if (1 == FarmVehicleInfo[GetPVarInt(playerid, "farmTempVehicleID")][farmVehicleMilkAmount]) {
						ErrorMessage(playerid, ""NO"[Подсказка]"G" После загрузки всех бидонов, отвезите молоко на завод.");
						EnableGPSForPlayer(playerid, -60.5805, -224.0083, 5.429);
					}
					return true;
				}
				else if (FarmVehicleInfo[GetPVarInt(playerid, "farmTempVehicleID")][farmVehicleMilkAmount]) {

					ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 1, 1, 1);
					SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 3632, 6, 
						0.075999, 0.178999, -0.296000, -15.900001, 0.000000, 0.000000, 0.696000, 0.799000, 0.802000
					);
					SendOk(playerid, "Вы взяли бидон с молоком из транспорта.");
					SetPVarInt(playerid, "farmMilkTaken", 1);

					FarmVehicleInfo[GetPVarInt(playerid, "farmTempVehicleID")][farmVehicleMilkAmount]--;
					farm_UpdateVehicleText(GetPVarInt(playerid, "farmTempVehicleID"));
					return true;

				}
			}
		}
	}
	if ((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)) {
		if (IsPlayerInRangeOfPoint(playerid, 1.5, -389.8095, -1424.1799, 25.7266)) {
			switch (farm_jobid) {
				case 1: {
					if (FarmJob_PI[playerid][farmPlantsCollected]) {
						format(STRING_GLOBAL, sizeof(STRING_GLOBAL), 
							""GREEN"*"G" Вы сдали на склад "P"%d "G"пшеничных ростоков.",
							FarmJob_PI[playerid][farmPlantsCollected]
						);
						SendClientMessage(playerid, 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;


						FarmJob_PI[playerid][farmJobCollected] += FarmJob_PI[playerid][farmPlantsCollected];
						FarmJob_PI[playerid][farmPlantsCollected] = 0;
						return true;
					}
				}
				case 2: {
					if (!GetPVarInt(playerid, "farmPlantTaken")) {
						SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 2901, 6, 0.152, 0.0, 0.0, -2.9, 87.6, 0.0, 0.49, 0.483, 0.497);
						SetPVarInt(playerid, "farmPlantTaken", 1);
						return true;
					}
				}
			}
		}
		new bool:isReturn = false;
		switch (farm_jobid) {
			case 1: {
				if (farm_IsPlayerInPlantArea(playerid)) { 
					foreach (new farm_plant_id: farmPlants) {
						if (FarmPlantInfo[farm_plant_id][farmPlantStatus] == FARM_PLANT_STATUS_NONE ||
							!IsPlayerInRangeOfPoint(playerid, 1.5, 
							FarmPlantInfo[farm_plant_id][farmPlantPos][0], 
							FarmPlantInfo[farm_plant_id][farmPlantPos][1], 
							FarmPlantInfo[farm_plant_id][farmPlantPos][2]
						)) continue;
						farm_ActionPlant(playerid, farm_plant_id);
						isReturn = true;

						break;
					}
					if (isReturn) return true;

					if (FarmJob_PI[playerid][farmPlantTime] < gettime() && FarmJob_PI[playerid][farmPlantsAmount] > 0) {
						ShowPlayerDialog(playerid, D_FARMJOB_4, DIALOG_STYLE_MSGBOX, ""P"Посадка ростков", 
							""W"Вы хотите посадить росток в данном месте?", "Да", "Отмена"
						);
						return true;
					}
				}
			}
			case 2: {
				if (IsPlayerInRangeOfPoint(playerid, 1.5, -386.2530, -1414.9113, 25.7266) && GetPVarInt(playerid, "farmMilkTaken")) {
					ClearAnimations(playerid);
					if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_JOB_2)) 
						RemovePlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2);
					farmMilkAmount++, farm_UpdateMilkText();

					FarmJob_PI[playerid][farmJobCollected] += 1;
					PI[playerid][pFarmSkills][1]++;

					SendOk(playerid, "Вы сдали бидон с молоком на склад.");
					DeletePVar(playerid, "farmMilkTaken");
					return true;
				}
				if (!GetPVarInt(playerid, "farmMilkTaken")) for (new farm_cow_id = 0; farm_cow_id < MAX_FARM_COWS; farm_cow_id++) {
					if (!IsPlayerInRangeOfPoint(playerid, 1.5, FarmCowMilkPos[farm_cow_id][0], FarmCowMilkPos[farm_cow_id][1], FarmCowMilkPos[farm_cow_id][2])) 
						continue;
					farm_ActionCow(playerid, farm_cow_id);
					SetPVarInt(playerid, "farmCowID", farm_cow_id);

					isReturn = true;
					break;
				}
				if (isReturn) return true;
			}
			case 3: {
				if (IsPlayerInRangeOfPoint(playerid, 1.5, -60.5805, -224.0083, 5.4297)) {
					if (GetPVarInt(playerid, "farmMilkTaken")) {
						ClearAnimations(playerid);
						if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_JOB_2)) 
							RemovePlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2);

						FarmJob_PI[playerid][farmJobCollected] += 1;
						PI[playerid][pFarmSkills][2]++;

						SendOk(playerid, "Вы сдали бидон с молоком на завод.");
						DeletePVar(playerid, "farmMilkTaken");
						return true;
					}
				}
				if (IsPlayerInRangeOfPoint(playerid, 1.5, -386.2530, -1414.9113, 25.7266)) {
					if (!GetPVarInt(playerid, "farmMilkTaken")) {
						if (TI[playerid][tArendaCar] == -1 || VehicleInfo[TI[playerid][tArendaCar]][vJob] != FARM_VEHICLE_JOB_ID) {
							ErrorMessage(playerid, "Сначала арендуйте рабочий транспорт на ферме.");
							return true; 
						}
						if (farmMilkAmount <= 0) {
							ErrorMessage(playerid, "На складе недостаточно молока!");
							return true; 
						}
						if (FarmVehicleInfo[GetPVarInt(playerid, "farmTempVehicleID")][farmVehicleMilkAmount] >= MAX_FARM_VEHICLE_MILK) {
							ErrorMessage(playerid, "Фургон уже полный!");
							return true; 
						}
						SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 3632, 6, 
							0.075999, 0.178999, -0.296000, -15.900001, 0.000000, 0.000000, 0.696000, 0.799000, 0.802000
						);
						farmMilkAmount--, farm_UpdateMilkText();

						SendOk(playerid, "Вы взяли бидон с молоком в руки.");
						ErrorMessage(playerid, ""NO"[Подсказка]"G" Чтобы загрузить в рабочий транспорт, нажмите "P"\"H\""G".");

						ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 1, 1, 1);
						return SetPVarInt(playerid, "farmMilkTaken", 1);
					}
				}
			}
		}
	}
	return false;
}
stock farm_ActionCow(playerid, farm_cow_id) {
	SetPlayerPosAC(playerid, FarmCowMilkPos[farm_cow_id][0], FarmCowMilkPos[farm_cow_id][1], FarmCowMilkPos[farm_cow_id][2], 0, 0);
	
	switch (FarmCowInfo[farm_cow_id][farmCowStatus]) {
		case FARM_COW_STATUS_HUNGRY: {
			if (!GetPVarInt(playerid, "farmPlantTaken")) {
				ErrorMessage(playerid, "У вас нет сена в руках, чтобы накормить!");
				return false; 
			}
			if (GetPVarInt(playerid, "farmMilkTaken")) {
				ErrorMessage(playerid, "Сначала сдайте набранное молоко!");
				return false; 
			}
			if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_JOB_2))
				RemovePlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2);
			DeletePVar(playerid, "farmPlantTaken");
			FarmCowInfo[farm_cow_id][farmCowOwnerID] = playerid;

			format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), ""P"Корова\n"W"Статус: "O"сытая\n \n"W"Чтобы подоить, нажмите "P"\"ALT\"");
			UpdateDynamic3DTextLabelText(FarmCowInfo[farm_cow_id][farmCowTextID], 0xFFFFFFFF, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;

			FarmCowInfo[farm_cow_id][farmCowStatus] = FARM_COW_STATUS_FULL;
		}
		case FARM_COW_STATUS_FULL: {
			if (FarmCowInfo[farm_cow_id][farmCowOwnerID] != playerid) {
				ErrorMessage(playerid, "В данный момент корова занята другим игроком!");
				return false; 
			}
			JobTempProcess[playerid] = FARM_JOB_PROCESS_ID;
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
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 1, 1, 1, 0);
			SetPlayerToFacePos(playerid, FarmCowMilkPos[farm_cow_id][0], FarmCowMilkPos[farm_cow_id][1]);
		}
	}
	return true;
}
stock farm_ActionPlant(playerid, farm_plant_id) {
	if (FarmPlantInfo[farm_plant_id][farmPlantOwnerID] != playerid) {
		ErrorMessage(playerid, "Данный пшеничный росток не принадлежит вам!");
		return false; 
	}
	if (AntiCheatIsFrozen(playerid)) 
		return false;
	if (FarmJob_PI[playerid][farmPlantTime] >= gettime()) 
		return false; 

	SetPlayerToFacePos(playerid, 
		FarmPlantInfo[farm_plant_id][farmPlantPos][0], FarmPlantInfo[farm_plant_id][farmPlantPos][1]
	);
	switch (FarmPlantInfo[farm_plant_id][farmPlantStatus]) {
		case FARM_PLANT_STATUS_PLANTED: { // поливаем росток
			if (FarmJob_PI[playerid][farmWaterAmount] <= 0) {
				ErrorMessage(playerid, "У вас закончилась вода, наберите у скважины.");
				return false; 
			}
			FarmJob_PI[playerid][farmWaterAmount]--;
			GameTextForPlayer(playerid,"~r~~h~~h~~h~wait..", 2500, 6);
			TogglePlayerControllable(playerid, false);

			ApplyAnimation(playerid, "WEAPONS", "SHP_Tray_Out", 4.1, 0, 1, 1, 1, 1);
			SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_1, 19621, 6, 0.066, 0.029, 0.021, 0.000, 0.000, 83.700, 1.887, 1.401, 2.468);
			SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 18676, 6, 0.096, -0.023, -1.172, 0.000, 17.700, 0.000);

			SetTimerEx("farm_ActionPlantTimer", 5000, false, "iii", playerid, farm_plant_id, 1);
		}
		case FARM_PLANT_STATUS_GROWING: { // собираем росток
			if (FarmPlantInfo[farm_plant_id][farmPlantProcess] < 100.0) {
				ErrorMessage(playerid, "Данный пшеничный росток еще не вырос!");
				return false; 
			}
			GameTextForPlayer(playerid,"~r~~h~~h~~h~wait..", 2500, 6);
			TogglePlayerControllable(playerid, false);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4, 0, 0, 0, 0, 0);

			SetTimerEx("farm_ActionPlantTimer", 3500, false, "iii", playerid, farm_plant_id, 2);
		}
	}
	return true;
}
forward farm_ActionPlantTimer(playerid, farm_plant_id, status);
public farm_ActionPlantTimer(playerid, farm_plant_id, status) {
	if (!IsPlayerInRangeOfPoint(playerid, 1.75, 
		FarmPlantInfo[farm_plant_id][farmPlantPos][0], 
		FarmPlantInfo[farm_plant_id][farmPlantPos][1], 
		FarmPlantInfo[farm_plant_id][farmPlantPos][2])
	) return;

	TogglePlayerControllable(playerid, true);

	switch(status) {
		case 1: {
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 1, 1, 1);
			ClearAnims(playerid);

			if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_JOB_2))
				RemovePlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2);
			FarmPlantInfo[farm_plant_id][farmPlantStatus] = FARM_PLANT_STATUS_GROWING;
			FarmPlantInfo[farm_plant_id][farmPlantProcess] = (100.0 / FARM_PLANT_100_TIMER);

			farm_UpdatePlantText(farm_plant_id);
			SendClientMessage(playerid, 0xFFFFFFFF, "Вы успешно полили пшеничный росток.");
		}
		case 2: {
			switch (100 - random(101)) { // 100 - random(101)
				case 0..CHANCE_DROP_ITEMS: GivePlayerItem(playerid, 165);
			}
			farm_DestroyPlant(farm_plant_id);
			FarmJob_PI[playerid][farmPlantedAmount]--;

			FarmJob_PI[playerid][farmPlantsCollected]++;
			PI[playerid][pFarmSkills][0]++;

			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), 
				""GREEN"*"G" Вы собрали "P"%d "G"пшеничных ростоков. За всё время собрано: "P"%d "G"ростков.",
				FarmJob_PI[playerid][farmPlantsCollected], PI[playerid][pFarmSkills][0]
			);
			SendClientMessage(playerid, 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
		}
	}
}
stock farm_IsPlayerInPlantArea(playerid) {
	if (GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) 
		return false;
	new bool:isReturn = false, Float:playerPos[3];
	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

	for (new i = 0; i < MAX_FARM_PLANT_ZONES; i++) {
		if (!IsPointInReactangle(playerPos[0], playerPos[1], 
			FarmPlantZonePos[i][0], FarmPlantZonePos[i][1], 
			FarmPlantZonePos[i][2], FarmPlantZonePos[i][3]
		)) continue;
		isReturn = true;
		break;
	}
	if (!isReturn) 
		return false;
	return true;
}
farm_CreatePlant(playerid) {
	new farmPlants_amount = Iter_Count(farmPlants);

	if (farmPlants_amount >= MAX_FARM_PLANTS) {
		ErrorMessage(playerid, "В данный момент нельзя посадить росток. (максимальное количество)");
		return false;
	}
	if (!farm_IsPlayerInPlantArea(playerid)) {
		ErrorMessage(playerid, "В данном месте нельзя посадить росток. (только на поле)");
		return false;
	}
	if (farmPlants_amount) {
		new bool:isReturn = false;
		foreach (new farm_plant_id: farmPlants) {
			if (!IsPlayerInRangeOfPoint(playerid, FARM_PLANT_DISTANCE, 
				FarmPlantInfo[farm_plant_id][farmPlantPos][0], 
				FarmPlantInfo[farm_plant_id][farmPlantPos][1], 
				FarmPlantInfo[farm_plant_id][farmPlantPos][2]
			)) continue;
			isReturn = true;
			break;
		}
		if (isReturn) {
			ErrorMessage(playerid, "В данном месте нельзя посадить росток. (слишком близко)");
			return false;
		}
		new playerPlantsAmount = 0;
		foreach (new farm_plant_id: farmPlants) {
			if (
				FarmPlantInfo[farm_plant_id][farmPlantStatus] == FARM_PLANT_STATUS_NONE ||
				FarmPlantInfo[farm_plant_id][farmPlantOwnerID] != playerid
			) continue;
			if (++playerPlantsAmount >= MAX_PLAYER_FARM_PLANTS) break;
		}
		if (playerPlantsAmount >= MAX_PLAYER_FARM_PLANTS) {
			ErrorMessage(playerid, "Вы посадили максимальное количетсво ростков. ("#MAX_PLAYER_FARM_PLANTS")");
			return false;
		}
	}
	new farm_plantid = Iter_Free(farmPlants);
	GetPlayerPos(playerid, 
		FarmPlantInfo[farm_plantid][farmPlantPos][0], 
		FarmPlantInfo[farm_plantid][farmPlantPos][1], 
		FarmPlantInfo[farm_plantid][farmPlantPos][2]
	);
	FarmPlantInfo[farm_plantid][farmPlantOwnerID] = playerid; 
	FarmPlantInfo[farm_plantid][farmPlantProcess] = 0.0; // default = 1.666% [60s]

	FarmPlantInfo[farm_plantid][farmPlantObjectID] = CreateDynamicObject(19473, 
		FarmPlantInfo[farm_plantid][farmPlantPos][0], 
		FarmPlantInfo[farm_plantid][farmPlantPos][1], 
		FarmPlantInfo[farm_plantid][farmPlantPos][2] - FARM_MINUS_Z(100.0 - FarmPlantInfo[farm_plantid][farmPlantProcess]), 
		0.000, 0.000, 0.000, 0, 0, -1, FARM_PLANT_OBJECT_SD
	);
	SetDynamicObjectMaterial(FarmPlantInfo[farm_plantid][farmPlantObjectID], 0, 728, "gtatreeshi", "berrybush1", 0x00000000);

	FarmPlantInfo[farm_plantid][farmPlantStatus] = FARM_PLANT_STATUS_PLANTED; // создан, но не полит | 2 - полит и растет

	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), 
		""P"Пшеничный росток\n \n"W"Посадил: "G"%s\n"W"Статус: "O"еще не полит\n \n"W"Нажмите "P"\"ALT\""W", чтобы полить",
		player_name[playerid]
	);
	FarmPlantInfo[farm_plantid][farmPlantTextID] = CreateDynamic3DTextLabel(STRING_GLOBAL, 0xFFFFFFFF,
		FarmPlantInfo[farm_plantid][farmPlantPos][0], 
		FarmPlantInfo[farm_plantid][farmPlantPos][1], 
		FarmPlantInfo[farm_plantid][farmPlantPos][2], 
		FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	), STRING_GLOBAL[0] = EOS;

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
	Streamer_Update(playerid);

	SendClientMessage(playerid, 0xFFFFFFFF, "Вы успешно посадили росток пшеницы, полейте его.");

	Iter_Add(farmPlants, farm_plantid);
	FarmJob_PI[playerid][farmPlantedAmount]++;
	FarmJob_PI[playerid][farmPlantTime] = gettime() + 3;

	return true;
}
farm_DestroyPlant(farm_plant_id, iter_remove = 1) {
	if (FarmPlantInfo[farm_plant_id][farmPlantStatus] == FARM_PLANT_STATUS_NONE) 
		return;

	FarmPlantInfo[farm_plant_id][farmPlantStatus] = FARM_PLANT_STATUS_NONE;
	FarmPlantInfo[farm_plant_id][farmPlantOwnerID] = 0;

	FarmPlantInfo[farm_plant_id][farmPlantProcess] =
	FarmPlantInfo[farm_plant_id][farmPlantPos][0] =
	FarmPlantInfo[farm_plant_id][farmPlantPos][1] =
	FarmPlantInfo[farm_plant_id][farmPlantPos][2] = 0.0;


	DestroyDynamic3DTextLabel(FarmPlantInfo[farm_plant_id][farmPlantTextID]);
	DestroyDynamicObject(FarmPlantInfo[farm_plant_id][farmPlantObjectID]);

	if (iter_remove) Iter_Remove(farmPlants, farm_plant_id);
}
farm_Timer() {
	if (++farmPlantsTimer < FARM_PLANTS_TIMER) 
		return;
	if (!Iter_Count(farmPlants)) 
		return;
	foreach (new farm_plant_id: farmPlants) {
		if (FarmPlantInfo[farm_plant_id][farmPlantProcess] >= 100.0 || FarmPlantInfo[farm_plant_id][farmPlantStatus] != FARM_PLANT_STATUS_GROWING)
			continue;
		FarmPlantInfo[farm_plant_id][farmPlantProcess] += FARM_PLANTS_TIMER * (100.0 / FARM_PLANT_100_TIMER);
		if (FarmPlantInfo[farm_plant_id][farmPlantProcess] > 100.0) 
			FarmPlantInfo[farm_plant_id][farmPlantProcess] = 100.0;
		farm_UpdatePlantText(farm_plant_id);

		MoveDynamicObject(FarmPlantInfo[farm_plant_id][farmPlantObjectID], 
			FarmPlantInfo[farm_plant_id][farmPlantPos][0], 
			FarmPlantInfo[farm_plant_id][farmPlantPos][1], 
			FarmPlantInfo[farm_plant_id][farmPlantPos][2] - FARM_MINUS_Z(100.0 - FarmPlantInfo[farm_plant_id][farmPlantProcess]),
			10.0, 0.0, 0.0, 0.0
		);
	}

	farmPlantsTimer = 0;
}
farm_UpdateMilkText() {
	format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), "\
		"W"На складе: "P"%i "W"б. молока\n \n\
		Чтобы взять / сдать бидон с молоком, нажмите "P"\"ALT\"", 
		farmMilkAmount
	);
	UpdateDynamic3DTextLabelText(farmMilkTextID, 0xFFFFFFFF, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;
}
stock farm_UpdatePlantText(farm_plant_id) {
	if (FarmPlantInfo[farm_plant_id][farmPlantStatus] != FARM_PLANT_STATUS_GROWING) 
		return;
	if (FarmPlantInfo[farm_plant_id][farmPlantProcess] < 100.0) {
		format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), 
			""P"Пшеничный росток\n \n"W"Посадил: "G"%s\n"W"Статус роста: "P"%.0f/100%%",
			player_name[FarmPlantInfo[farm_plant_id][farmPlantOwnerID]], FarmPlantInfo[farm_plant_id][farmPlantProcess]
		);
	}
	else {
		format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), 
			""P"Пшеничный росток\n \n"W"Посадил: "G"%s\n"W"Статус роста: "P"%.0f/100%%\n \n"W"Нажмите "P"\"ALT\""W", чтобы собрать",
			player_name[FarmPlantInfo[farm_plant_id][farmPlantOwnerID]], FarmPlantInfo[farm_plant_id][farmPlantProcess]
		);
	}
	UpdateDynamic3DTextLabelText(FarmPlantInfo[farm_plant_id][farmPlantTextID], 0xFFFFFFFF, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;
}
stock farm_UpdateVehicleText(farm_vehicle_id) {
	if (FarmVehicleInfo[farm_vehicle_id][farmVehicleOwnerID] == INVALID_PLAYER_ID) {
		format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), 
			""P"Рабочий транспорт\n \n\
			"W"Стоимость аренды: "GREEN"$"#FARM_VEHICLE_RENT_COST""
		);

	}
	else {
		format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), 
			""P"Рабочий транспорт\n\
			"W"Арендатор: "G"%s\n \n\
			"W"Загружено молока: "P"%i/"#MAX_FARM_VEHICLE_MILK" "W"б.",
			player_name[FarmVehicleInfo[farm_vehicle_id][farmVehicleOwnerID]], 
			FarmVehicleInfo[farm_vehicle_id][farmVehicleMilkAmount]
		);
	}
	UpdateDynamic3DTextLabelText(FarmVehicleInfo[farm_vehicle_id][farmVehicleTextID], 0xFFFFFFFF, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;
}
farm_OnGameModeInit() {
	for (new i = 0; i < MAX_FARM_PLANT_ZONES; i++) {
		FarmPlantGangZone[i] = GangZoneCreate(
			FarmPlantZonePos[i][0], FarmPlantZonePos[i][1], 
			FarmPlantZonePos[i][2], FarmPlantZonePos[i][3]
		);
	}
	CreateDynamicMapIcon(-368.8796, -1421.6219, 25.7266, 11, CWHITE);

	CreateDynamicPickup(1275, 23, -368.8796, -1421.6219, 25.7266, 0, 0); // join
	CreateDynamicPickup(2901, 23, -389.8095, -1424.1799, 25.7266, 0, 0); // action
	CreateDynamicPickup(3632, 23, -386.2530, -1414.9113, 25.7266, 0, 0); // take milk
	CreateDynamicPickup(19621, 23, -384.3969, -1441.5284, 25.7266, 0, 0); // fill water
	CreateDynamicPickup(19570, 23, -60.5805, -224.0083, 5.4297, 0, 0); // milk zavod

	CreateDynamicObjectCP(-389.8095, -1424.1799, 25.7266, 5.0); // action
	CreateDynamicObjectCP(-386.2530, -1414.9113, 25.7266, 5.0); // take milk
	CreateDynamicObjectCP(-384.3969, -1441.5284, 25.7266, 5.0); // fill water
	CreateDynamicObjectCP(-60.5805, -224.0083, 5.4297, 5.0); // milk zavod

	farmMilkTextID = CreateDynamic3DTextLabel(" ", 0xFFFFFFFF,
		-386.2530, -1414.9113, 25.7266, 
		FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	);
	farm_UpdateMilkText();

	CreateDynamic3DTextLabel(""P"Склад сена\n \n"W"Чтобы сдать / взять сено, нажмите \"ALT\"", 0xFFFFFFFF,
		-389.8095, -1424.1799, 25.7266, 
		FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	);
	CreateDynamic3DTextLabel(""P"Место сдачи молока\n \n"W"Чтобы сдать, нажмите \"ALT\"", 0xFFFFFFFF,
		-60.5805, -224.0083, 5.4297, 
		FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/* testlos */, 0, 0, -1
	);
	for (new i = 0; i < MAX_FARM_COWS; i++) {
		FarmCowInfo[i][farmCowStatus] = FARM_COW_STATUS_HUNGRY;
		FarmCowInfo[i][farmCowOwnerID] = INVALID_PLAYER_ID;
		FarmCowInfo[i][farmCowTimer] = 0;

		FarmCowInfo[i][farmCowObjectID] = CreateDynamicObject(19833, 
			FarmCowPos[i][0], FarmCowPos[i][1], FarmCowPos[i][2], 
			0.000, 0.000, FarmCowPos[i][3], 0, 0, -1, FARM_PLANT_OBJECT_SD
		);
		SetDynamicObjectMaterial(FarmCowInfo[i][farmCowObjectID], 0, -1, "none", "none", 0xFFFFFFFF);

		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), ""P"Корова\n"W"Статус: "R"голодная\n \n"W"Чтобы накормить, нажмите "P"\"ALT\"");

		FarmCowInfo[i][farmCowTextID] = CreateDynamic3DTextLabel(STRING_GLOBAL, 0xFFFFFFFF,
			FarmCowPos[i][0], FarmCowPos[i][1], FarmCowPos[i][2] + 1.0, 
			FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
			0/* testlos */, 0, 0, -1
		);
		STRING_GLOBAL[0] = EOS;

		CreateDynamicObject(19468, 
			FarmCowMilkBucketPos[i][0], FarmCowMilkBucketPos[i][1], FarmCowMilkBucketPos[i][2], 
			0.000, 0.000, FarmCowMilkBucketPos[i][3], 0, 0, -1, 50.0
		); // bucket-test
		CreateDynamicObjectCP(FarmCowMilkPos[i][0], FarmCowMilkPos[i][1], FarmCowMilkPos[i][2]);
	}
	for(new i = 0; i < MAX_FARM_VEHICLES; i++) {
		new vehicleid = FarmVehicleInfo[i][farmVehicleID] = CreateJobVehicle(FARM_VEHICLE_JOB_ID, 499, 
			FarmVehiclePos[i][0], FarmVehiclePos[i][1], FarmVehiclePos[i][2], FarmVehiclePos[i][3], 
			random(255), random(255), RES_CAR_TIME
		);
		FarmVehicleInfo[i][farmVehicleTextID] = CreateDynamic3DTextLabel(STRING_GLOBAL, 0xFFFFFFFF,
			0.0, 0.0, 1.0, FARM_PLANT_DISTANCE, INVALID_PLAYER_ID, vehicleid, 
			0/* testlos */, 0, 0, -1
		);
		FarmVehicleInfo[i][farmVehiclePos][0] = FarmVehiclePos[i][0];
		FarmVehicleInfo[i][farmVehiclePos][1] = FarmVehiclePos[i][1];
		FarmVehicleInfo[i][farmVehiclePos][2] = FarmVehiclePos[i][2];
		FarmVehicleInfo[i][farmVehiclePos][3] = FarmVehiclePos[i][3];

		FarmVehicleInfo[i][farmVehicleOwnerID] = INVALID_PLAYER_ID;
		farm_UpdateVehicleText(i);

		SignalTick[vehicleid][1] = -1;
		LightsObject[vehicleid][0] = -1;
		LightsObject[vehicleid][1] = -1;
		SetVehicleParamsEx(vehicleid, false, false, false, false, false, false, false);
	
		VehicleInfo[vehicleid][vFuel] = gTransport[GetVehicleModel(vehicleid) - 400][trTank];
		VehicleInfo[vehicleid][vPlayer] = -1;
	}
}

stock IsPointInReactangle(Float:x, Float:y, Float:xmin, Float:ymin, Float:xmax, Float:ymax) {
	if (x >= xmin && y >= ymin && x <= xmax && y <= ymax)
		return true;
	return false;
}
stock farm_DestroyRentVehicle(playerid) {
	new vehicleid = TI[playerid][tArendaCar];
	if (vehicleid == -1) 
		return;
	if (VehicleInfo[vehicleid][vJob] != FARM_VEHICLE_JOB_ID) 
		return;

	new farm_vehicleid = GetPVarInt(playerid, "farmTempVehicleID");
	VehicleInfo[vehicleid][vPlayer] = -1;
	FarmVehicleInfo[farm_vehicleid][farmVehicleOwnerID] = INVALID_PLAYER_ID;
	FarmVehicleInfo[farm_vehicleid][farmVehicleMilkAmount] = 0;
	TI[playerid][tArendaCar] = -1;
	farm_UpdateVehicleText(farm_vehicleid);

	SetVehicleToRespawn(vehicleid);
}
farm_OnPlayerDisconnect(playerid) {
	farm_DestroyRentVehicle(playerid);
	farm_DestroyAllPlants(playerid);
}	
stock farm_DestroyAllPlants(playerid) {
	foreach (new farm_plant_id: farmPlants) {
		if (!Iter_Count(farmPlants) || farm_plant_id >= MAX_FARM_PLANTS)
			break;
		if (FarmPlantInfo[farm_plant_id][farmPlantOwnerID] != playerid) 
			continue;
		farm_DestroyPlant(farm_plant_id, .iter_remove = 0);
		FarmJob_PI[playerid][farmPlantedAmount]--;

		new current = farm_plant_id;
		Iter_SafeRemove(farmPlants, farm_plant_id, farm_plant_id);
		if (farm_plant_id == current) {
			farm_plant_id = Iter_Next(farmPlants, farm_plant_id);
		}
	}
}
stock farm_ResetRentVehicle(farm_vehicleid, playerid = INVALID_PLAYER_ID) {
	new vehicleid = FarmVehicleInfo[farm_vehicleid][farmVehicleID];

	VehicleInfo[vehicleid][vPlayer] = -1;
	FarmVehicleInfo[farm_vehicleid][farmVehicleOwnerID] = INVALID_PLAYER_ID;
	FarmVehicleInfo[farm_vehicleid][farmVehicleMilkAmount] = 0;
	farm_UpdateVehicleText(farm_vehicleid);
	SetVehicleToRespawn(vehicleid);

	if (playerid != INVALID_PLAYER_ID) {
		if (TI[playerid][tArendaCar] == vehicleid) {
			TI[playerid][tArendaCar] = -1;
			SetPVarInt(playerid, "farmTempVehicleID", -1);
		}
	}
}