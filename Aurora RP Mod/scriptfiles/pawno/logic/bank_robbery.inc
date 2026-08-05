#if defined _bank_robbery_included
	#endinput
#endif
#define _bank_robbery_included

#define RB_MINIMUM_COP_COUNT	2
#define RB_MINIMUM_ROB_COUNT	3

#define RB_OPEN_DOOR_TIMER		30
#define RB_DISABLE_LIGHT_TIMER	(5 * 60)
#define RB_STORE_DOOR_TIMER		60

#define RB_JOB_PROCESS_ID		18
#define RB_ROB_JOB_PROCESS_ID	19

#define RB_BUY_C4_PRICE			8000

#define MAX_RB_BAGS_POS	8

new Float:RB_BagPos[MAX_RB_BAGS_POS][3] = { 
	{269.662933, 112.067451, 1045.275878},
	{269.662933, 112.927436, 1045.275878},
	{269.662933, 111.187431, 1044.835449},
	{269.662933, 112.067451, 1044.835449},
	{269.662933, 112.927436, 1044.835449},
	{269.662933, 111.187431, 1045.716308},
	{269.662933, 112.067451, 1045.716308},
	{269.662933, 112.927436, 1045.716308}
};
#define MAX_ROB_BANK_CELLS	8

new Float:RB_CellPos[MAX_ROB_BANK_CELLS][4] = {
	{276.2855, 132.9912, 1037.9183, 271.3522}, 
	{276.2847, 136.9600, 1037.9183, 271.3522}, 
	{276.2855, 140.8817, 1037.9183, 272.2296}, 
	{276.2859, 144.8128, 1037.9183, 263.4562}, 
	{270.3221, 144.8178, 1037.9183, 93.3982}, 
	{270.3220, 140.9542, 1037.9183, 104.6574}, 
	{270.3219, 136.9558, 1037.9183, 94.8604}, 
	{270.3225, 132.9939, 1037.9183, 96.6151}
};

enum {
	RB_STATUS_NONE = 0,
	RB_STATUS_STARTED
};
enum {
	BANK_DOOR_STATUS_CLOSED = 0,
	BANK_DOOR_STATUS_OPENING,
	BANK_DOOR_STATUS_OPENED
};
enum ROB_BANK_E {
	robActorID,
	robActorAnimID,
	robActorAnimTimer,
	robStatus,
	robDoorStatus,
	robStartPlayerID,
	robBankObjectID[5],
	Text3D:robBankTextID[2],
	robTeleportPickup[5],

	robTimer,

	robBombTimer,
	robStoreDoorTimer,
	robLightTimer,

	robCellPlayerID,
	robCellChecked[MAX_ROB_BANK_CELLS],
	Text3D:robBankCellTextID[MAX_ROB_BANK_CELLS],
	robBankBagObjectID[MAX_RB_BAGS_POS],
}
new RobBankInfo[ROB_BANK_E], RB_AntiFloodUpdate[MAX_PLAYERS];
new ROB_BANK_ENABLE = 1;
/*
	#define MAX_RB_SQUAD_PLAYERS 10
	new Iterator:RobBankSquad[MAX_PLAYERS]<MAX_RB_SQUAD_PLAYERS>;
*/
enum RB_PLAYER_E {
	Text3D:robTextID,
	robCellTaken,
	robBagTaken,
	robC4Bought,
	robCellStep,
}
new RB_PlayerInfo[MAX_PLAYERS][RB_PLAYER_E];

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float: amount, weaponid, bodypart) {
	SetActorHealth(damaged_actorid, 100.0);

	if(!IsAGang(playerid) && !IsAMafia(playerid)) 
		return 1;
	if(RobBankInfo[robActorAnimID] > 1) 
		return 1;

	if(damaged_actorid == RobBankInfo[robActorID]) {
		if(RobBankInfo[robStatus] == RB_STATUS_NONE) {
			/*RobBankInfo[robActorAnimID] = 3;
			RobBankInfo[robActorAnimTimer] = (30 * 1);

			ApplyActorAnimation(RobBankInfo[robActorID], "PED", "DUCK_cower", 4.1, 1, 1, 1, 1, 1);*/
			return 1;
		}
		if(9 == bodypart) {
			RobBankInfo[robActorAnimID] = 4;
			RobBankInfo[robActorAnimTimer] = (5 * 60);

			SetActorFacingAngle(RobBankInfo[robActorID], 190.0);
			ApplyActorAnimation(damaged_actorid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0);
		}
		else {
			RobBankInfo[robActorAnimID] = 2;
			RobBankInfo[robActorAnimTimer] = (1 * 60);

			SetActorFacingAngle(RobBankInfo[robActorID], 290.0);
			ApplyActorAnimation(damaged_actorid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0);
		}
	}
    return 1;
}
stock RB_Start(playerid = INVALID_PLAYER_ID) {
	if(RobBankInfo[robStatus] != RB_STATUS_NONE)
		return false;

	for(new bag_id = 0; bag_id < MAX_RB_BAGS_POS; bag_id++) if((-1) == RobBankInfo[robBankBagObjectID][bag_id]) {
		RobBankInfo[robBankBagObjectID][bag_id] = CreateDynamicObject(11745, 
			RB_BagPos[bag_id][0], RB_BagPos[bag_id][1], RB_BagPos[bag_id][2], 
			0.0, 0.0, 0.0, 8, 5, -1, 50.0, 50.0
		);
	}
	RobBankInfo[robStartPlayerID] = playerid;
	RobBankInfo[robStatus] = RB_STATUS_STARTED;
	RobBankInfo[robStoreDoorTimer] = RB_STORE_DOOR_TIMER;
	RobBankInfo[robTimer] = 15 * 60;

	RB_EnableLight();
	RB_ReCreateDoor();

	return true;

}
stock RB_ReCreateDoor() {
	DestroyDynamicObject(RobBankInfo[robBankObjectID][0]);

	RobBankInfo[robBankObjectID][0] = CreateDynamicObject(19799, 272.30, 130.722, 1038.60, 0.0, 0.0, 180.0, -1, 5, -1, 50.00, 50.00);
	SetDynamicObjectMaterial(RobBankInfo[robBankObjectID][0], 0, 1560, "7_11_door", "cj_sheetmetal2", 0x00000000);

	RobBankInfo[robDoorStatus] = BANK_DOOR_STATUS_CLOSED;
}
RB_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	#pragma unused oldkeys
	if(!IsAMafia(playerid) && !IsAGang(playerid))
		return false;
	if(GetPVarInt(playerid, "KEYAntiFlood") > gettime())
		return false;

	if(newkeys & KEY_WALK) {
 		/*if(IsPlayerInRangeOfPoint(playerid, 1.0, 2323.3960, -1229.8292, 22.5247)) {
 			if(RB_PlayerInfo[playerid][robC4Bought] != 0) {
 				ErrorMessage(playerid, "Вы уже купили C4.");
 				return false;
 			}
 			ShowPlayerDialog(playerid, D_C4_BUY, DIALOG_STYLE_MSGBOX, ""P"Покупка C4", 
 				""W"Вы действительно хотите купить "O"'C4'"W"?\n \n\
 				Стоимость: "G"$"#RB_BUY_C4_PRICE"", "Купить", "Отмена"
 			);
			SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
 			return true;
 		}*/
	}
	else if(newkeys & KEY_CTRL_BACK) {
		new bool:cell_pos = false;
		if(RB_PlayerInfo[playerid][robTextID] != Text3D:(-1) && JobTempProcess[playerid] != RB_ROB_JOB_PROCESS_ID) for(new cell_id = 0; cell_id < MAX_ROB_BANK_CELLS; cell_id++) if(IsPlayerInRangeOfPoint(playerid, 1.0, RB_CellPos[cell_id][0], RB_CellPos[cell_id][1], RB_CellPos[cell_id][2])) {
			if(RobBankInfo[robCellChecked][cell_id]) {
				ErrorMessage(playerid, "Данная банковская ячейка уже ограблена, попробуйте другую.");
				cell_pos = true;
				break;
			}
			else if(!RB_PlayerInfo[playerid][robBagTaken]) {
				SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);

				ErrorMessage(playerid, "Вы не взяли рюкзак для денег.");
				cell_pos = true;
				break;
			}
			else if(GetPVarInt(playerid, "BankCellRobbed")) {
				SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
				ErrorMessage(playerid, "Вы уже ограбили одну банковскую ячейку.");
				cell_pos = true;
				break;
			}
			else {
				foreach(new i: Player) {
					if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i))
						continue;
					if(GetPlayerInterior(i) != 1 && GetPlayerInterior(i) != 5 && GetPlayerInterior(i) != 78)
						continue;
					if(
						!IsPlayerInRangeOfPoint(i, 50.0, 273.18, 130.50, 1037.57) &&
						!IsPlayerInRangeOfPoint(i, 30.0, 2406.1443,-34.2138,1029.625) &&
						!IsPlayerInRangeOfPoint(i, 30.0, 184.2615, -270.0170, 1000.976)
					) continue;

					if(JobTempProcess[i] == RB_ROB_JOB_PROCESS_ID) {
						SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
						ErrorMessage(playerid, "Грабить банковскую ячейку можно только поочереди.");
						cell_pos = true;
						break;
					}
				}
				if(!cell_pos) {
					RobBankInfo[robCellChecked][cell_id] = 1;
					SetPVarInt(playerid, "RB_CellID", cell_id);
					RB_StartRobCell(playerid, cell_id);
				}
			}

			cell_pos = true;
			break;
		}
		if(cell_pos) return true;

 		if(RB_PlayerInfo[playerid][robTextID] != Text3D:(-1) && IsPlayerInRangeOfPoint(playerid, 1.0, 270.5054, 111.9942, 1045.31271)) {
			if(RB_STATUS_NONE == RobBankInfo[robStatus])
				return false;
 			if(RB_PlayerInfo[playerid][robBagTaken] != 0) {
				SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
 				ErrorMessage(playerid, "Вы уже взяли пустую сумку.");
 				return false;
 			}
 			new bool:bag_taken = false;
			for(new bag_id = 0; bag_id < MAX_RB_BAGS_POS; bag_id++) {
				if(RobBankInfo[robBankBagObjectID][bag_id] != (-1)) {
					DestroyDynamicObject(RobBankInfo[robBankBagObjectID][bag_id]);
					RobBankInfo[robBankBagObjectID][bag_id] = (-1);

					SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_1, 11745, 1, 0.095000, -0.241000, 0.000000, 84.700019, 1.999997, -89.900032);
 					RB_PlayerInfo[playerid][robBagTaken] = 1;

					SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
					bag_taken = true;
					break;
				}
			}
			if(!bag_taken) {
				SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
				ErrorMessage(playerid, "В данный момент нет пустых сумок на стойке.");
			}
 			return bag_taken;
 		}
		else if(RB_PlayerInfo[playerid][robTextID] != Text3D:(-1) && JobTempProcess[playerid] != RB_JOB_PROCESS_ID && RobBankInfo[robLightTimer] == 0 && IsPlayerInRangeOfPoint(playerid, 0.5, 272.2778,124.3456,1045.686)) {
			if(RB_STATUS_NONE == RobBankInfo[robStatus])
				return false;
			SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
			RB_StartDisableLight(playerid);

			return true;
		}
		else if(RB_PlayerInfo[playerid][robTextID] != Text3D:(-1) && RobBankInfo[robBombTimer] == 0 && IsPlayerInRangeOfPoint(playerid, 1.0, 274.029724, 130.53, 1038.51)) {
			if(RB_STATUS_NONE == RobBankInfo[robStatus])
				return false;
			if(RobBankInfo[robLightTimer] <= 0) {
				SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
				ErrorMessage(playerid, "Сначала необходимо отключить электричество в банке.");
				return false;
			}
			if(RB_PlayerInfo[playerid][robC4Bought] == 0) {
				SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
				ErrorMessage(playerid, "У вас нет 'C4' с собой, купите на черном рынке.");
				return false;
			}
			SetPVarInt(playerid, "KEYAntiFlood", gettime() + 2);
			SetPlayerPosAC(playerid, 273.9630, 128.8786, 1038.0303, 8, 5);
			
			RB_PutBomb();
			Streamer_Update(playerid);

			return true;
		}
	}
	return false;
}
stock RB_ResetPlayer(playerid) {

	if(RB_PlayerInfo[playerid][robTextID] != Text3D:(-1)) {
		DestroyDynamic3DTextLabel(RB_PlayerInfo[playerid][robTextID]);
		RB_PlayerInfo[playerid][robTextID] = Text3D:(-1);
	}
}
RB_OnGameModeInit() {
	for(new bag_id = 0; bag_id < MAX_RB_BAGS_POS; bag_id++) {
		RobBankInfo[robBankBagObjectID][bag_id] = CreateDynamicObject(11745, 
			RB_BagPos[bag_id][0], RB_BagPos[bag_id][1], RB_BagPos[bag_id][2], 
			0.0, 0.0, 0.0, 8, 5, -1, 50.0, 50.0
		);
	}
	for(new cell_id = 0; cell_id < MAX_ROB_BANK_CELLS; cell_id++) {
		RobBankInfo[robBankCellTextID][cell_id] = CreateDynamic3DTextLabel(
			"{CD5C5C}Банковская ячейка\n \n{FFFFFF}Нажмите H, чтобы начать грабить", 0xFFFFFFFF, 
			RB_CellPos[cell_id][0], RB_CellPos[cell_id][1], RB_CellPos[cell_id][2], 
			3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 8, 5
		);
	}
	CreateDynamicObject(1569, 2410.6, -32.08, 1028.6, 0.0, 0.0, -90.0, 8, 1, -1, 100.0); // door

	RobBankInfo[robTeleportPickup][0] = CreateDynamicSphere(2410.2483, -32.9552, 1029.6256, 1.0, 8, 1); // вход в хранилище
	RobBankInfo[robTeleportPickup][1] = CreateDynamicSphere(276.7771, 107.9911, 1050.5099, 1.0, 8, 5); // вход в управление банка
	RobBankInfo[robTeleportPickup][2] = CreateDynamicSphere(369.8367, 74.8813, 1038.2030, 1.0, 8, 5); // выход на улицу из тунеля
	RobBankInfo[robTeleportPickup][3] = CreateDynamicSphere(259.1755, 129.2865, 1038.0303, 1.0, 8, 5); // выход на улицу из тунеля

	RobBankInfo[robTeleportPickup][4] = CreateDynamicSphere(1667.1351, -1399.9873, 17.3062, 50.0, 0, 0); // зона мусорки

	CreateDynamicPickup(1318, 1, 2410.2483, -32.9552, 1029.6256, 8, 1);
	CreateDynamicPickup(1318, 1, 276.7771, 107.9911, 1050.5099, 8, 5);
	CreateDynamicPickup(1318, 1, 259.1755, 129.2865, 1038.0303, 8, 5);
	CreateDynamicPickup(1318, 1, 369.8367, 74.8813, 1038.2030, 8, 5);

	/*CreateDynamicPickup(1252, 1, 2323.3960, -1229.8292, 22.5247, 0, 0);
	CreateDynamic3DTextLabel(""W"Нажмите "O"'ALT'", -1, 2323.3960, -1229.8292, 22.5247, 7.0);*/

	CreateDynamic3DTextLabel("Вход в хранилище\n\n"G"Вcтаньте на пикап, чтобы войти", PP, 
		2410.2483, -32.9552, 1029.6256, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 8, 1
	);
	CreateDynamic3DTextLabel("Выход из хранилища\n\n"G"Вcтаньте на пикап, чтобы выйти", PP, 
		276.7771, 107.9911, 1050.5099, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 8, 5
	);
	CreateDynamic3DTextLabel("Выход через туннель\n\n"G"Вcтаньте на пикап, чтобы войти", PP, 
		259.1755, 129.2865, 1038.0303, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 8, 5
	);
	CreateDynamic3DTextLabel("Выход на улицу\n\n"G"Вcтаньте на пикап, чтобы выйти", PP, 
		369.8367, 74.8813, 1038.2030, 
		7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 8, 5
	);
	CreateDynamic3DTextLabel("Пустые сумки\n\n"G"Нажмите H, чтобы взять", PP, 
		270.5054, 111.9942, 1045.3127, 
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 8, 5
	);

	// 2323.4500,-1229.8291,22.5247
	RobBankInfo[robBankTextID][0] = CreateDynamic3DTextLabel("{CD5C5C}Чтобы заминировать \"C-4\"\n \n{FFFFFF}Нажмите H",
		0xFFFFFFFF, 274.029724, 130.53, 1038.51, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 8, 5
	);
	RobBankInfo[robBankTextID][1] = CreateDynamic3DTextLabel("{CD5C5C}Чтобы отключить электричество\n \n{FFFFFF}Нажмите H",
		0xFFFFFFFF, 272.2778, 124.3456, 1045.68 + 1.0, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 8, 5
	);
	RobBankInfo[robActorAnimID] = 0;
	RobBankInfo[robStatus] = RB_STATUS_NONE;

	RobBankInfo[robBankObjectID][0] = CreateDynamicObject(19799, 272.30, 130.722, 1038.60, 0.0, 0.0, 180.0, -1, 5, -1, 50.00, 50.00);
	SetDynamicObjectMaterial(RobBankInfo[robBankObjectID][0], 0, 1560, "7_11_door", "cj_sheetmetal2", 0x00000000);

	RobBankInfo[robActorID] = CreateActor(171, 184.2615, -270.0170, 1000.9766, 290.0);
	SetActorVirtualWorld(RobBankInfo[robActorID], 46);
	SetActorInvulnerable(RobBankInfo[robActorID], false);
	SetActorHealth(RobBankInfo[robActorID], 100);
} 
stock RB_StartRobCell(playerid, cell_id) {
	RB_PlayerInfo[playerid][robCellStep] = 0;
	TogglePlayerControllable(playerid, false);
	TI[playerid][tProcess][0] = 0;
	TI[playerid][tProcess][1] = 10;
	JobTempProcess[playerid] = RB_ROB_JOB_PROCESS_ID;
	RandomYareNforJOBS(playerid);
	PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
	for(new YN = 0; YN < 3; YN++) {
		TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
		if(YN < 2) PlayerTextDrawShow(playerid, YandNsysTDPlayer[playerid][YN]);
	}
	ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.1, 0, 1, 1, 1, 0, 1);

	SetPlayerPosAC(playerid, RB_CellPos[cell_id][0], RB_CellPos[cell_id][1], RB_CellPos[cell_id][2], 8, 5);
	SetPlayerFacingAngle(playerid, RB_CellPos[cell_id][3]);

	SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_1, 11745, 5, 0.171999, -0.079999, -0.002999, 0.000000, -80.299987, -81.599990);
}
stock RB_StartDisableLight(playerid) {
	TogglePlayerControllable(playerid, false);
	TI[playerid][tProcess][0] = 0;
	TI[playerid][tProcess][1] = 10;
	JobTempProcess[playerid] = RB_JOB_PROCESS_ID;
	RandomYareNforJOBS(playerid);
	PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
	for(new YN = 0; YN < 3; YN++) {
		TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
		if(YN < 2) PlayerTextDrawShow(playerid, YandNsysTDPlayer[playerid][YN]);
	}
}
stock RB_PutBomb() {
	if(BANK_DOOR_STATUS_CLOSED != RobBankInfo[robDoorStatus])
		return false;
	RobBankInfo[robBankObjectID][2] = CreateDynamicObject(2141, 274.140411, 134.17, 1038.47, 180.0, 90.0, 270.0, -1, 5, -1, 50.00, 50.00); // bomb+ object
	SetDynamicObjectMaterial(RobBankInfo[robBankObjectID][2], 0, 1613, "alleyprop", "stuffdirtcol", 0x000000FF);
	SetDynamicObjectMaterial(RobBankInfo[robBankObjectID][2], 1, 1613, "alleyprop", "stuffdirtcol", 0x000000FF);

	RobBankInfo[robBankObjectID][1] = CreateDynamicObject(1252, 274.029724, 130.53, 1038.51, 0.0, 0.0, 0.0, -1, 5, -1, 50.00, 50.00); // bomb
	SetDynamicObjectMaterial(RobBankInfo[robBankObjectID][1], 1, 10412, "hotel1", "carpet_red_256", 0x00000000);

	UpdateDynamic3DTextLabelText(RobBankInfo[robBankTextID][0], 0xFFFFFFFF,
		"{CD5C5C}\"C-4\" заминирована\n \n{C0C0C0}До взрыва: "#RB_OPEN_DOOR_TIMER" сек."
	);
	RobBankInfo[robBombTimer] = RB_OPEN_DOOR_TIMER;
	RobBankInfo[robDoorStatus] = BANK_DOOR_STATUS_OPENING;

	return true;
}
CMD:robbankreset(playerid ) {
	if(PI[playerid][pAdmin] < 3 || dostup[playerid] == 0) return true;
	RobBankInfo[robTimer] = 1;
	SendOk(playerid, "success robBank reset");
	return true;
}
CMD:robbanktoggle(playerid) {
	if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return true;
	if(ROB_BANK_ENABLE) {
		ROB_BANK_ENABLE = 0;
		SendClientMessage(playerid, -1, "Ограбление банка выключено-.");
	}
	else {
		ROB_BANK_ENABLE = 1;
		SendClientMessage(playerid, -1, "Ограбление банка включено+.");
	}
	return true;

}
stock RB_Timer() {
	if(RobBankInfo[robTimer]) {
		RobBankInfo[robTimer]--;
		if(RobBankInfo[robTimer] <= 0) {
			for(new bag_id = 0; bag_id < MAX_RB_BAGS_POS; bag_id++) if((-1) == RobBankInfo[robBankBagObjectID][bag_id]) {
				RobBankInfo[robBankBagObjectID][bag_id] = CreateDynamicObject(11745, 
					RB_BagPos[bag_id][0], RB_BagPos[bag_id][1], RB_BagPos[bag_id][2], 
					0.0, 0.0, 0.0, 8, 5, -1, 50.0, 50.0
				);
			}
			for(new cell_id = 0; cell_id < MAX_ROB_BANK_CELLS; cell_id++) 
				RobBankInfo[robCellChecked][cell_id] = 0;

			RobBankInfo[robStatus] = RB_STATUS_NONE;

			RobBankInfo[robActorAnimTimer] = RobBankInfo[robActorAnimID] = 0;
			SetActorPos(RobBankInfo[robActorID], 184.2615, -270.0170, 1000.9766);
			SetActorFacingAngle(RobBankInfo[robActorID], 290.0);
			ApplyActorAnimation(RobBankInfo[robActorID], "CARRY", "null", 1.0, 0, 0, 0, 0, 0);
			ClearActorAnimations(RobBankInfo[robActorID]);
		}
	}
	if(RobBankInfo[robActorAnimID] && RobBankInfo[robActorAnimTimer]) {
		RobBankInfo[robActorAnimTimer]--;

		if(RobBankInfo[robActorAnimTimer] <= 0) {
			ApplyActorAnimation(RobBankInfo[robActorID], "CARRY", "null", 1.0, 0, 0, 0, 0, 0);
			switch(RobBankInfo[robActorAnimID]) {
				case 1: {
					ClearActorAnimations(RobBankInfo[robActorID]); 
					/*SendClientMessageToAll(-1, "Внимание! В банке г.ЛС сработала сигнализация, полиция уже в пути! [для грабителей]");
					SendClientMessageToAll(-1, "Внимание! В банке г.ЛС сработала сигнализация, возможно это ограбление! [для полиции]");*/
				}
				case 3: {
					ClearActorAnimations(RobBankInfo[robActorID]); 
				}
			}
			SetActorPos(RobBankInfo[robActorID], 184.2615, -270.0170, 1000.9766);
			SetActorFacingAngle(RobBankInfo[robActorID], 290.0);
			RobBankInfo[robActorAnimTimer] =
			RobBankInfo[robActorAnimID] = 0;
		}
	}
	if(RobBankInfo[robStoreDoorTimer]) {
		RobBankInfo[robStoreDoorTimer]--;
		if(RobBankInfo[robStoreDoorTimer] <= 0) RobBankInfo[robStoreDoorTimer] = 0;
	}
	if(RobBankInfo[robLightTimer]) {
		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{CD5C5C}Электричество отключено\n \n{C0C0C0}До восстановления: %d сек.",
			RobBankInfo[robLightTimer]
		);
		UpdateDynamic3DTextLabelText(RobBankInfo[robBankTextID][1], 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;

		RobBankInfo[robLightTimer]--;

		if(RobBankInfo[robLightTimer] <= 0) {
			UpdateDynamic3DTextLabelText(RobBankInfo[robBankTextID][1], 0xFFFFFFFF, "{CD5C5C}Чтобы отключить электричество\n \n{FFFFFF}Нажмите H");
			RobBankInfo[robLightTimer] = 0;

			new hour, minute, second;
			gettime(hour, minute, second);

			foreach(new i: Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i))
					continue;
				if(GetPlayerInterior(i) != 1 && GetPlayerInterior(i) != 5 && GetPlayerInterior(i) != 78)
					continue;
				if(
					!IsPlayerInRangeOfPoint(i, 50.0, 273.18, 130.50, 1037.57) &&
					!IsPlayerInRangeOfPoint(i, 30.0, 2406.1443,-34.2138,1029.625) &&
					!IsPlayerInRangeOfPoint(i, 30.0, 184.2615, -270.0170, 1000.976)
				) continue;

				SetPlayerTime(i, hour, minute);
			}
		}
	}
	if(RobBankInfo[robBombTimer] <= 0) return;
	RobBankInfo[robBombTimer]--;

	if(RobBankInfo[robBombTimer] > 0) {
		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{CD5C5C}\"C-4\" заминирована\n \n{C0C0C0}До взрыва: %d сек.",
			RobBankInfo[robBombTimer]
		);
		UpdateDynamic3DTextLabelText(RobBankInfo[robBankTextID][0], 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
	}
	switch(RobBankInfo[robBombTimer]) {
		case 1: {
			CreateExplosion(273.18, 130.50, 1037.57, 0, 3.0 ); 

			RobBankInfo[robBankObjectID][3] = CreateObject(18683/*18685*/, 273.18, 130.50, 1037.57, 0.0, 0.0, 0.0, 50.00);
			RobBankInfo[robBankObjectID][4] = CreateObject(18683, 273.18, 130.50, 1036.67, 0.0, 0.0, 0.0, 50.00);

			for(new objectid = 1; objectid < 3; objectid++)
				DestroyDynamicObject(RobBankInfo[robBankObjectID][objectid]);
			MoveDynamicObject(RobBankInfo[robBankObjectID][0],
				272.30, 129.04 + 0.01, 1036.98,
				1.5,
				-90.00, 4.00, 180.00
			);
		}
		case 0: {
			DestroyObject(RobBankInfo[robBankObjectID][3]);
			DestroyObject(RobBankInfo[robBankObjectID][4]);

			RobBankInfo[robDoorStatus] = BANK_DOOR_STATUS_OPENED;
			UpdateDynamic3DTextLabelText(RobBankInfo[robBankTextID][0], 0xFFFFFFFF, " ");
		}
	}

}
stock RB_EnableLight() 
	return RobBankInfo[robLightTimer] = 1;

stock RB_DisableLight() {
	if(RobBankInfo[robLightTimer])
		return false;
	RobBankInfo[robLightTimer] = RB_DISABLE_LIGHT_TIMER;

	foreach(new i: Player) {
		if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i))
			continue;
		if(GetPlayerInterior(i) != 1 && GetPlayerInterior(i) != 5 && GetPlayerInterior(i) != 78)
			continue;
		if(
			!IsPlayerInRangeOfPoint(i, 50.0, 273.18, 130.50, 1037.57) &&
			!IsPlayerInRangeOfPoint(i, 30.0, 2406.1443,-34.2138,1029.625) &&
			!IsPlayerInRangeOfPoint(i, 30.0, 184.2615, -270.0170, 1000.976)
		) continue;

		SetPlayerTime(i, 3, 0);
	}
	return true;
}

