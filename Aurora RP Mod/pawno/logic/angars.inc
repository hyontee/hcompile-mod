#if defined _angars_included
	#endinput
#endif
#define _angars_included

#define TABLE_ANGARS	"angars"

#define ANGAR_FIXCAR_PRICE	4000
#define MAX_ANGAR_FUEL		500	
#define MAX_ANGARS			20
#define ANGAR_PAY_COST		7000

enum {
	ANGAR_MENU_MAIN,
	ANGAR_MENU_LIST,
	ANGAR_MENU_INFO,
	ANGAR_MENU_SELL,
	ANGAR_MENU_RANK
};
enum {
	ANGAR_DOOR_STATUS_CLOSED = 0,
	ANGAR_DOOR_STATUS_OPENED
};
enum ANGARS_E {
	aID,
	aFamily,
	aGateStatus,
	aObjectID[11 + 19 /*(furniture)*/],
	Float:aPosition[6], // x y z 0 0 angle
	Float:aGatePosX[2 * 2], // x1 x2 * 2
	Float:aGatePosY[2 * 2], // y1 y2 * 2
	Float:aGatePosZ[2 * 1], // z rz
	Float:aVehiclePos[4 * 2], // x y z angle * 2
	Float:aKeyPos[3 * 3], // x y z * 2
	Float:aPickupPos[3 * 1], // x y z
	aGateAntiFlood,
	aGateRank,
	aPrice,
	aFuel,
	aArea,
	aMapIcon,
	aPickup,
	aDays,
	Text3D:aText[3]
};
new AngarsInfo[MAX_ANGARS][ANGARS_E], Iterator:Angars<MAX_ANGARS>, CurrentAngarID[MAX_PLAYERS];

new AngarsAirplanePrice[7] = {
	7_800_000,
	6_000_000,
	12_000_000,
	8_500_000,
	15_000_000,
	8_500_000,
	11_000_000
};

CMD:arentpark(playerid) {
	if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return true;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;

	new vehicleid = GetPlayerVehicleID(playerid);

	for(new i = 1; i <= gPlaneCount; i ++)
	{
		if(vehicleid != gAirplanes[i][aCar]) continue;

		new Float:x, Float:y, Float:z, Float:r;

		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, r);

		MYSQL_GLOBAL[0] = EOS;
		mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL),
			"UPDATE `plane` SET PosX = '%.2f',PosY = '%.2f',PosZ = '%.2f',PosXY = '%.2f' WHERE ID = %i", 
			(VehicleInfo[vehicleid][veX] =gAirplanes[i][aPos][0] = x),
			(VehicleInfo[vehicleid][veY] =gAirplanes[i][aPos][1] = y),
			(VehicleInfo[vehicleid][veZ] =gAirplanes[i][aPos][2] = z),
			(VehicleInfo[vehicleid][veA] =gAirplanes[i][aPos][3] = r),
			gAirplanes[i][aID]
		);
		mysql_tquery(connects, MYSQL_GLOBAL, "", "");
		A_DestroyVehicle(gAirplanes[i][aCar]);
		gAirplanes[i][aCar] = CreateJobVehicle(99, gAirplanes[i][aPlane], gAirplanes[i][aPos][0], gAirplanes[i][aPos][1], gAirplanes[i][aPos][2], gAirplanes[i][aPos][3], -1, -1, 400);
	
		ErrorMessage(playerid, "success");
		SetVehiclePos(vehicleid, x, y, z);
		SetVehicleZAngle(vehicleid, r);
		break;
	}
	return true;
}
CMD:testvehattach(playerid, params[])
{
	if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return true;
	if(sscanf(params, "d", params[0]) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		return SendEsp(playerid, "/testvehattach [CAR ID]");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsTrailerAttachedToVehicle(vehicleid))
	{
		DetachTrailerFromVehicle(vehicleid);
		SendClientMessage(playerid, -1, "deattach test");
	}
	else
	{
		if(!IsTrailerAttachedToVehicle(vehicleid)) 
			AttachTrailerToVehicle(params[0], vehicleid);
		SendClientMessage(playerid, -1, "attach test");
	}
	return true;
}
CMD:fangar(playerid) {
	if(PI[playerid][pFamily] < 1) 
		return ErrorMessage(playerid, "Вы не владелец семьи.");
	if(0 == gFamily[PI[playerid][pFamily] - 1][famAngarID])
		return ErrorMessage(playerid, "Ваша семья не владеет ангаром.");
	if(strcmp(gFamily[PI[playerid][pFamily] - 1][famOwner], player_name[playerid], true)) 
		return ErrorMessage(playerid, "Управлять ангаром может только основатель семьи.");

	CurrentAngarID[playerid] = gFamily[PI[playerid][pFamily] - 1][famAngarID];
	angar_ShowMenu(playerid);
	return true;
}
stock angar_ShowBuyMenu(playerid) {
	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Название модели\tСтоимость\n\
		"W"Sparrow\t{00FF00}$%d\n\
		"W"Stuntplane\t{00FF00}$%d\n\
		"W"Maverick\t{00FF00}$%d\n\
		"W"Beagle\t{00FF00}$%d\n\
		"W"Raindance\t{00FF00}$%d\n\
		"W"Dodo\t{00FF00}$%d\n\
		"W"Shamal\t{00FF00}$%d",
		AngarsAirplanePrice[0], AngarsAirplanePrice[1], AngarsAirplanePrice[2],
		AngarsAirplanePrice[3], AngarsAirplanePrice[4], AngarsAirplanePrice[5],
		AngarsAirplanePrice[6]
	);
	ShowPlayerDialog(playerid, D_BUY_AIRPLANES, DIALOG_STYLE_TABLIST_HEADERS, "Семейный воздушный транспорт", STRING_GLOBAL, "Принять", "Отмена");

	return true;
}
stock angar_ShowMenu(playerid, menuid = ANGAR_MENU_MAIN) {
	if(!CurrentAngarID[playerid])
		return false;
	new angar_id = (CurrentAngarID[playerid] - 1);

	switch(menuid) {
		case ANGAR_MENU_MAIN: {
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
				"P"1."W" Информация\n\
				"P"2."W" Список транспорта\n\
				"P"3."W" Доступ к ангару "O"[c %d ранга]\n\
				"P"4."W" Продать ангар "GREEN"[-20%%]", AngarsInfo[angar_id][aGateRank]
			);
			ShowPlayerDialog(playerid, (D_ANGARS_MENU2), DIALOG_STYLE_LIST, ""P"Панель управления ангаром", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case ANGAR_MENU_INFO: {
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
				"W"Владелец: {%s}%s\n \n\
				"W"Топлива на складе: "O"%d литров\n\
				"W"Государственная стоимость: "GREEN"$%d\n\
				"W"Оплачен на: "O"%d дн.",
				FamilyColor[gFamily[AngarsInfo[angar_id][aFamily] - 1][famColor]], gFamily[AngarsInfo[angar_id][aFamily] - 1][famName],
				AngarsInfo[angar_id][aFuel],
				AngarsInfo[angar_id][aPrice], 
				((AngarsInfo[angar_id][aDays] - gettime()) / 86400) + 1
			);
			ShowPlayerDialog(playerid, (D_ANGARS_INFO2), DIALOG_STYLE_MSGBOX, ""P"Информация об ангаре", STRING_GLOBAL, "Назад", "");
		}
		case ANGAR_MENU_RANK: {
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
				{FFFFFF}Введите ранг с которого можно будет открывать/закрывать/заправляться в ангар\n \n\
				{888888}В данный момент можно доступ к ангару с %d ранга.", AngarsInfo[angar_id][aGateRank]
			);
			ShowPlayerDialog(playerid, (D_ANGARS_RANK2), DIALOG_STYLE_INPUT, ""P"Настройка доступа к открытию", STRING_GLOBAL, "Принять", "Назад");
		}
		case ANGAR_MENU_LIST: {
			new CountVehicle = 0;

			STRING_GLOBAL = "Слот\tНазвание\tРанг доступа\n";

			for(new i = 6; i != 8; i ++) if(gFamily[AngarsInfo[angar_id][aFamily] - 1][famCarID][i] != 0xFFFF) {
				CountVehicle++;

				new model = GetVehicleModel(gFamily[AngarsInfo[angar_id][aFamily] - 1][famCarID][i]);
				format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"G"%d.\t"P"%s\t"W"%d\n", STRING_GLOBAL, 
					((i + 1) - 6), gTransport[model - 400][trName], gFamily[AngarsInfo[angar_id][aFamily] - 1][famCarRang][i]
				);
			}
			if(CountVehicle == 0) return ErrorMessage(playerid, "В вашей семье нет воздушного транспорта");
			ShowPlayerDialog(playerid, D_ANGARS_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Семейный воздушный транспорт", STRING_GLOBAL, "Принять", "Назад");
		}
		case ANGAR_MENU_SELL: {
			new angar_price = (AngarsInfo[angar_id][aPrice] - (AngarsInfo[angar_id][aPrice] * 20 / 100));

			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
				{FFFFFF}Вы действительно хотите продать ангар государству со скидкой в 20%%?\n\n\
				Сумма которую вы получите: "GREEN"$%d", angar_price
			);
			ShowPlayerDialog(playerid, (D_ANGARS_SELL2), DIALOG_STYLE_MSGBOX, ""P"Продажа ангара", STRING_GLOBAL, "Да", "Назад");
		}
	}
	STRING_GLOBAL[0] = EOS;

	return true;
}
angar_OnPlayerPickUpDynamPickup(playerid, pickupid) {
	new bool:return_bool = false;
	foreach(new angar_id: Angars) {
		if(
			AngarsInfo[angar_id][aFamily] != 0 || AngarsInfo[angar_id][aPickup] != pickupid
		) continue;

		CurrentAngarID[playerid] = (angar_id + 1);
		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
			"P"1."W" Информация\n\
			"P"2."W" Купить ангар "GREEN"[$%d]",
			AngarsInfo[angar_id][aPrice]
		);
		ShowPlayerDialog(playerid, D_ANGARS, DIALOG_STYLE_LIST, ""P"Ангар продаётся", STRING_GLOBAL, "Выбрать", "Отмена"), STRING_GLOBAL[0] = EOS;
		return_bool = true;
		break;
	}
	return return_bool;
}
angar_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	#pragma unused oldkeys

	new bool:return_bool = false;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH)) foreach(new angar_id: Angars) {

		if(
			AngarsInfo[angar_id][aFamily] == 0 ||  AngarsInfo[angar_id][aGateAntiFlood] > gettime() ||
			!IsPlayerInRangeOfPoint(playerid, 10.0, AngarsInfo[angar_id][aKeyPos][6], AngarsInfo[angar_id][aKeyPos][7], AngarsInfo[angar_id][aKeyPos][8])
		) continue;

		if(
			PI[playerid][pAdmin] < 4 && 
			(AngarsInfo[angar_id][aFamily] != PI[playerid][pFamily] || 
				(
					strcmp(gFamily[AngarsInfo[angar_id][aFamily] - 1][famOwner], player_name[playerid], true) && 
					PI[playerid][pFamRank] < AngarsInfo[angar_id][aGateRank]
				)
			)
		) {
			ErrorMessage(playerid, "У вас нет доступа.");
			break;
		}

		if(IsPlayerInRangeOfPoint(playerid, 7.5, AngarsInfo[angar_id][aKeyPos][6], AngarsInfo[angar_id][aKeyPos][7], AngarsInfo[angar_id][aKeyPos][8])) { 

			new vehicleid = GetPlayerVehicleID(playerid), modelid = GetVehicleModel(vehicleid);
			if(!IsAPlane(vehicleid)) {
				ErrorMessage(playerid, "Заправить можно только воздушный транспорт.");
				break;
			}
			if(!AngarsInfo[angar_id][aFuel]) {
				ErrorMessage(playerid, "В ангаре закончилось топливо.");
				break;
			}
			if(VehicleInfo[vehicleid][vFamily] != PI[playerid][pFamily]) {
				ErrorMessage(playerid, "Заправлять можно только семейный В/Т.");
				break;
			}
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "\n\
				"W"Укажите на сколько литров заправить ваше Т/С:\n\n\
				Доступно литров в баке: {FF9968}%.0f"W"\n\
				Вместимость бака: {FF9968}%d"W"\n\
				Можно заправить на: {FF9968}%.0fл"W"\n\
				В ангре еще: "ORANGE"%d литров\n", 
				VehicleInfo[vehicleid][vFuel], gTransport[modelid - 400][trTank], gTransport[modelid - 400][trTank] - VehicleInfo[vehicleid][vFuel],
				AngarsInfo[angar_id][aFuel]
			);
			ShowPlayerDialog(playerid, D_ANGARS_FUEL, DIALOG_STYLE_INPUT, ""P"Заправка воздушного транспорта", STRING_GLOBAL, "Купить", "Закрыть"), STRING_GLOBAL[0] = EOS;
			AngarsInfo[angar_id][aGateAntiFlood] = (gettime() + 2);

			return_bool = true;

			break;
		}

		break;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)) foreach(new angar_id: Angars) {

		if(
			AngarsInfo[angar_id][aFamily] == 0 ||  AngarsInfo[angar_id][aGateAntiFlood] > gettime() ||
			!IsPlayerInRangeOfPoint(playerid, 5.0, AngarsInfo[angar_id][aKeyPos][0], AngarsInfo[angar_id][aKeyPos][1], AngarsInfo[angar_id][aKeyPos][2])
		) continue;


		new Float:angle = 0;
		if(IsPlayerInRangeOfPoint(playerid, 0.6, AngarsInfo[angar_id][aKeyPos][0], AngarsInfo[angar_id][aKeyPos][1], AngarsInfo[angar_id][aKeyPos][2])) { 
			if(
				PI[playerid][pAdmin] < 4 && 
				(AngarsInfo[angar_id][aFamily] != PI[playerid][pFamily] || 
					(
						strcmp(gFamily[AngarsInfo[angar_id][aFamily] - 1][famOwner], player_name[playerid], true) && 
						PI[playerid][pFamRank] < AngarsInfo[angar_id][aGateRank]
					)
				)
			) {
				ErrorMessage(playerid, "У вас нет доступа.");
				break;
			}
			SetPlayerPos(playerid, AngarsInfo[angar_id][aKeyPos][0], AngarsInfo[angar_id][aKeyPos][1], AngarsInfo[angar_id][aKeyPos][2]);
			GetDynamicObjectRot(AngarsInfo[angar_id][aObjectID][5], angle, angle, angle);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 0.6, AngarsInfo[angar_id][aKeyPos][3], AngarsInfo[angar_id][aKeyPos][4], AngarsInfo[angar_id][aKeyPos][5])) { 
			if(
				PI[playerid][pAdmin] < 4 && 
				(AngarsInfo[angar_id][aFamily] != PI[playerid][pFamily] || 
					(
						strcmp(gFamily[AngarsInfo[angar_id][aFamily] - 1][famOwner], player_name[playerid], true) && 
						PI[playerid][pFamRank] < AngarsInfo[angar_id][aGateRank]
					)
				)
			) {
				ErrorMessage(playerid, "У вас нет доступа.");
				break;
			}
			SetPlayerPos(playerid, AngarsInfo[angar_id][aKeyPos][3], AngarsInfo[angar_id][aKeyPos][4], AngarsInfo[angar_id][aKeyPos][5]);
			GetDynamicObjectRot(AngarsInfo[angar_id][aObjectID][6], angle, angle, angle);
		}
		else break;
		SetPlayerFacingAngle(playerid, angle);
		TogglePlayerControllable(playerid, false);

		PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
		ApplyAnimation(playerid, "CASINO", "Slot_Plyr", 4.1, 0, 1, 1, 1, 0);
		SetTimerEx("angar_ClearAnimations", 1500, false, "i", playerid);

		AngarsInfo[angar_id][aGateAntiFlood] = (gettime() + 2);
		MoveAngarGates(angar_id);

		return_bool = true;
		break;
	}
	return return_bool;
}
stock UpdateAngarStatus(angar_id) {
	if(AngarsInfo[angar_id][aFamily]) {
		new family_id = (AngarsInfo[angar_id][aFamily] - 1);
		if(AngarsInfo[angar_id][aPickup] && IsValidDynamicObject(AngarsInfo[angar_id][aPickup])) {
			DestroyDynamicPickup(AngarsInfo[angar_id][aPickup]);
			AngarsInfo[angar_id][aPickup] = (-1);
		}
		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Ангар принадлежит семье\n{%s}%s", 
			FamilyColor[gFamily[family_id][famColor]], gFamily[family_id][famName]
		);
	}
	else {
		if(AngarsInfo[angar_id][aPickup] == (-1)) {
			AngarsInfo[angar_id][aPickup] = CreateDynamicPickup(1239, 23, 
				(AngarsInfo[angar_id][aPickupPos][0]), (AngarsInfo[angar_id][aPickupPos][1]), 
				(AngarsInfo[angar_id][aPickupPos][2]), 0, 0
			);
		}
		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Ангар продаётся\nСтоимость: {32CD32}$%d", AngarsInfo[angar_id][aPrice]);
	}
	SetDynamicObjectMaterialText(AngarsInfo[angar_id][aObjectID][7], 0, STRING_GLOBAL, 130, "Quartz MS", 26, 1, 0xFFFFFFFF, 0x00000000, 1);
	SetDynamicObjectMaterialText(AngarsInfo[angar_id][aObjectID][8], 0, STRING_GLOBAL, 130, "Quartz MS", 26, 1, 0xFF000000, 0x00000000, 1);

	STRING_GLOBAL[0] = EOS;
}

angar_OnGameModeInit() {
	LoadAngars();
}

angar_OnGameModeExit() {
	Iter_Clear(Angars);
}
stock MoveAngarGates(angar_id) {
	switch(AngarsInfo[angar_id][aGateStatus]) {
		case ANGAR_DOOR_STATUS_OPENED: {
			MoveDynamicObject(AngarsInfo[angar_id][aObjectID][9],
				AngarsInfo[angar_id][aGatePosX][0], AngarsInfo[angar_id][aGatePosY][0], AngarsInfo[angar_id][aGatePosZ][0], 1.0,
				0.000014, 0.000000, AngarsInfo[angar_id][aGatePosZ][1]
			);
			MoveDynamicObject(AngarsInfo[angar_id][aObjectID][10],
				AngarsInfo[angar_id][aGatePosX][1], AngarsInfo[angar_id][aGatePosY][1], AngarsInfo[angar_id][aGatePosZ][0], 1.0,
				0.000014, 0.000000, AngarsInfo[angar_id][aGatePosZ][1]
			);
			AngarsInfo[angar_id][aGateStatus] = ANGAR_DOOR_STATUS_CLOSED;
		}
		case ANGAR_DOOR_STATUS_CLOSED: {
			MoveDynamicObject(AngarsInfo[angar_id][aObjectID][9],
				AngarsInfo[angar_id][aGatePosX][2], AngarsInfo[angar_id][aGatePosY][2], AngarsInfo[angar_id][aGatePosZ][0], 1.0,
				0.000014, 0.000000, AngarsInfo[angar_id][aGatePosZ][1]
			);
			MoveDynamicObject(AngarsInfo[angar_id][aObjectID][10],
				AngarsInfo[angar_id][aGatePosX][3], AngarsInfo[angar_id][aGatePosY][3], AngarsInfo[angar_id][aGatePosZ][0], 1.0,
				0.000014, 0.000000, AngarsInfo[angar_id][aGatePosZ][1]
			);
			AngarsInfo[angar_id][aGateStatus] = ANGAR_DOOR_STATUS_OPENED;
		}
	}
}

stock CreateDynamicAngar(angar_id, Float:x, Float:y, Float:z, Float:angle) {
	if(Iter_Count(Angars) >= MAX_ANGARS) 
		return printf("[CreateDynamicAngar(%.2f %.2f %.2f)] ERROR: Iter_Count(Angars) >= MAX_ANGARS", x, y, z, angle), false;
	new Float:new_object_pos[3], Float:new_object_rot[3]; //, angar_id = Iter_Free(Angars);

	AngarsInfo[angar_id][aObjectID][0] = CreateDynamicObject(16771, 
		AngarsInfo[angar_id][aPosition][0] = x, AngarsInfo[angar_id][aPosition][1] = y, AngarsInfo[angar_id][aPosition][2] = z, 
		AngarsInfo[angar_id][aPosition][3] = 0.0, AngarsInfo[angar_id][aPosition][4] = 0.0, AngarsInfo[angar_id][aPosition][5] = angle, 
		0, 0, -1, 500.00, 500.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][0], 10, 16093, "a51_ext", "ws_corr_2_plain", 0x00000000);

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		29.162910, -8.393444, -7.429554, 0.000000, 0.000015, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	/*AngarsInfo[angar_id][aObjectID][1] = CreateDynamicObject(19529,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 130.00, 130.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][1], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);*/

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-0.196777, 21.519042, 2.629037, 0.000038, 0.000000, 89.999885,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][2] = CreateDynamicObject(19455,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 280.00, 280.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][2], 0, 1583, "targets", "targetframe2", 0xFF111111);

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.543945, 21.804931, -7.810672 + 0.18, 0.000000, 0.000000, 180.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][3] = CreateDynamicObject(19992,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 130.00, 130.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][3], 2, 16640, "a51", "airvent_gz", 0x00000000);

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.523925, 21.424560, -7.810672 + 0.18, 0.000000, 0.000000, 360.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][4] = CreateDynamicObject(19992,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 130.00, 130.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][4], 2, 16640, "a51", "airvent_gz", 0x00000000);

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.529785, 21.825439, -4.973897, 0.000000, 0.000022, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][5] = CreateDynamicObject(2922,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 130.00, 130.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.529785, 21.405029, -4.973897, 0.000000, -0.000022, 179.999862,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][6] = CreateDynamicObject(2922,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 130.00, 130.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-0.260009, 21.620117, 2.662973, 0.000045, 0.000000, 89.999862,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][7] = CreateDynamicObject(19479,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 280.00, 280.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][7], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
	
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-0.209472, 21.610107, 2.662973, 0.000045, 0.000000, 89.999862,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][8] = CreateDynamicObject(19479,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 280.00, 280.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][8], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
	// Furnitures
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-21.234310, 15.558536, -4.265937, 0.0, 0.0, 88.599983,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][11] = CreateDynamicObject(2258, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][11], 0, -1, "none", "none", 0xFFFFFFFF);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		11.062177, -11.202713, 2.755960, 0.0, 0.0, -149.999862,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][12] = CreateDynamicObject(2512, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][12], 0, -1, "none", "none", 0xFFFFFFFF);

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		20.899301, 7.199326, -5.025938, 0.0, 0.0, 91.099998,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][15] = CreateDynamicObject(1676, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][15], 0, -1, "none", "none", 0xFFFFFFFF);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		20.844427, 2.919923, -5.005933, 0.0, 0.0, 89.299934,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][16] = CreateDynamicObject(1676, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	SetDynamicObjectMaterial(AngarsInfo[angar_id][aObjectID][16], 0, -1, "none", "none", 0xFFFFFFFF);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-17.373491, 15.773818, -6.445938, 0.0, 0.0, -105.899955,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][17] = CreateDynamicObject(1712, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-20.717769, 15.164767, -6.445938, 0.0, 0.0, 91.600013,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][18] = CreateDynamicObject(1710, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-21.248928, 18.095830, -3.524866, -0.699998, 0.199999, 88.799987,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][19] = CreateDynamicObject(2286, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-20.553287, 14.138743, -4.945945, 0.0, 0.0, 44.099998,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][20] = CreateDynamicObject(2072, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-20.569723, 19.950414, -4.925945, 0.0, 0.0, -26.300003,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][21] = CreateDynamicObject(2072, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-20.752599, 16.840738, -4.505936, 0.0, 0.0, 81.699974,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][22] = CreateDynamicObject(2270, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-20.784772, 15.560755, -3.515941, 0.0, 0.0, 90.099983,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][23] = CreateDynamicObject(2264, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-20.972864, 7.417623, -5.845936, 0.0, 0.0, 90.799949,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][24] = CreateDynamicObject(2063, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-21.114116, 2.636948, -5.875940, 0.0, 0.0, 87.900024,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][25] = CreateDynamicObject(2063, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-18.022298, 19.521286, -6.445938, 0.0, 0.0, -71.100036,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][26] = CreateDynamicObject(1712, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-18.530370, 16.475269, -6.455945, 0.0, 0.0, 89.399955,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][27] = CreateDynamicObject(1817, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		21.181343, 8.960738, -5.035943, 0.0, 0.0, -70.399993,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][28] = CreateDynamicObject(2690, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		21.250675, 1.180631, -5.035943, 0.0, 0.0, -91.699996,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][29] = CreateDynamicObject(2690, 
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2], 
		0, 0, -1, 87.00, 87.00
	);

	// Creating KEYPAD area
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.529785, 21.825439 - 0.55, -5.57, 0.000000, 0.000022, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aArea] = CreateDynamicSphere(new_object_pos[0], new_object_pos[1], new_object_pos[2], 5.0, 0, 0);

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.5014, 21.0578, -5.57, 0.000000, 0.000022, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aText][0] = CreateDynamic3DTextLabel(
		"Ангар\n \n"P" Нажмите F", 
		0xFFFFFFFF, new_object_pos[0], new_object_pos[1], new_object_pos[2] + 0.55, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		.testlos = 1, .worldid = 0, .interiorid = 0
	);
	AngarsInfo[angar_id][aKeyPos][0] = new_object_pos[0];
	AngarsInfo[angar_id][aKeyPos][1] = new_object_pos[1];

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.5575, 22.1721, -5.57, 0.000000, 0.000022, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aText][1] = CreateDynamic3DTextLabel(
		"Ангар\n \n"P" Нажмите F", 
		0xFFFFFFFF, new_object_pos[0], new_object_pos[1], new_object_pos[2] + 0.55, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		.testlos = 1, .worldid = 0, .interiorid = 0
	);
	AngarsInfo[angar_id][aKeyPos][3] = new_object_pos[0];
	AngarsInfo[angar_id][aKeyPos][4] = new_object_pos[1];

	AngarsInfo[angar_id][aKeyPos][2] = AngarsInfo[angar_id][aKeyPos][5] = new_object_pos[2];

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.5749, 4.9331, -6.4459, 0.000000, 0.000022, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aText][2] = CreateDynamic3DTextLabel(
		"Чтобы заправить В/Т\n \n"P" Нажмите H", 
		0xFFFFFFFF, new_object_pos[0], new_object_pos[1], new_object_pos[2] + 1.0, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		.testlos = 1, .worldid = 0, .interiorid = 0
	);
	CreateDynamicPickup(1650, 23, new_object_pos[0], new_object_pos[1], new_object_pos[2] + 1.0, 0, 0); // can pickup

	AngarsInfo[angar_id][aKeyPos][6] = new_object_pos[0];
	AngarsInfo[angar_id][aKeyPos][7] = new_object_pos[1];
	AngarsInfo[angar_id][aKeyPos][8] = new_object_pos[2] + 1.0;

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		0.00000, 22.1721, -5.57, 0.000000, 0.000022, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aMapIcon] = CreateDynamicMapIcon(
		(AngarsInfo[angar_id][aPickupPos][0] = new_object_pos[0]),
		(AngarsInfo[angar_id][aPickupPos][1] = new_object_pos[1]),
		(AngarsInfo[angar_id][aPickupPos][2] = new_object_pos[2]), 
		56, CWHITE
	);
	AngarsInfo[angar_id][aPickup] = (-1);
	// Creating gates
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-7.328359, 21.554386, -2.556, 0.000000, 0.000015, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][9] = CreateDynamicObject(16773,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 500.00, 500.00
	);
	AngarsInfo[angar_id][aGatePosX][0] = new_object_pos[0];
	AngarsInfo[angar_id][aGatePosY][0] = new_object_pos[1];

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		7.312985, 21.554395, -2.556, 0.000000, 0.000015, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aObjectID][10] = CreateDynamicObject(16773,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
		0, 0, -1, 500.00, 500.00
	);
	AngarsInfo[angar_id][aGatePosX][1] = new_object_pos[0];
	AngarsInfo[angar_id][aGatePosY][1] = new_object_pos[1];


	// Opened float for gates

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-16.828359, 21.554386, -2.556, 0.000000, 0.000015, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aGatePosX][2] = new_object_pos[0];
	AngarsInfo[angar_id][aGatePosY][2] = new_object_pos[1];

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		16.812984, 21.554395, -2.556, 0.000000, 0.000015, 0.000000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aGatePosX][3] = new_object_pos[0];
	AngarsInfo[angar_id][aGatePosY][3] = new_object_pos[1];

	AngarsInfo[angar_id][aGatePosZ][0] = new_object_pos[2];
	AngarsInfo[angar_id][aGatePosZ][1] = new_object_rot[2];

	// Vehicle parking pos

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle, 9.9959, -5.5258, -5.3669, 0.0, 0.0, 0.0,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aVehiclePos][0] = new_object_pos[0];
	AngarsInfo[angar_id][aVehiclePos][1] = new_object_pos[1];
	AngarsInfo[angar_id][aVehiclePos][2] = new_object_pos[2];
	AngarsInfo[angar_id][aVehiclePos][3] = new_object_rot[2];

	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle, -10.2853, -5.0182, -5.3661, 0.0, 0.0, 0.0,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	AngarsInfo[angar_id][aVehiclePos][4] = new_object_pos[0];
	AngarsInfo[angar_id][aVehiclePos][5] = new_object_pos[1];
	AngarsInfo[angar_id][aVehiclePos][6] = new_object_pos[2];
	AngarsInfo[angar_id][aVehiclePos][7] = new_object_rot[2];

	/* testing */
	/*new vehicleid = A_CreateVehicle(519, 
		AngarsInfo[angar_id][aVehiclePos][0], AngarsInfo[angar_id][aVehiclePos][1], AngarsInfo[angar_id][aVehiclePos][2], 
		AngarsInfo[angar_id][aVehiclePos][3], 0, 0, -1, VEHICLE_TYPE_ADMIN);

	VehicleInfo[vehicleid][veX] = AngarsInfo[angar_id][aVehiclePos][0];
	VehicleInfo[vehicleid][veY] = AngarsInfo[angar_id][aVehiclePos][1];
	VehicleInfo[vehicleid][veZ] = AngarsInfo[angar_id][aVehiclePos][2];

	vehicleid = A_CreateVehicle(519, 
		AngarsInfo[angar_id][aVehiclePos][4], AngarsInfo[angar_id][aVehiclePos][5], AngarsInfo[angar_id][aVehiclePos][6], 
		AngarsInfo[angar_id][aVehiclePos][7], 0, 0, -1, VEHICLE_TYPE_ADMIN);

	VehicleInfo[vehicleid][veX] = AngarsInfo[angar_id][aVehiclePos][4];
	VehicleInfo[vehicleid][veY] = AngarsInfo[angar_id][aVehiclePos][5];
	VehicleInfo[vehicleid][veZ] = AngarsInfo[angar_id][aVehiclePos][6];*/
	/* testing */

	AngarsInfo[angar_id][aGateStatus] = ANGAR_DOOR_STATUS_CLOSED;
	UpdateAngarStatus(angar_id);

	Iter_Add(Angars, angar_id);
	return true;
}

CB:angar_ClearAnimations(playerid) {
	if(!TI[playerid][tLogin]) return;
	TogglePlayerControllable(playerid, true);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}
stock LoadAngars() {
	new Cache:result;
	result = mysql_query (connects, "SELECT * FROM `"TABLE_ANGARS"`");
	new TOTAL_ANGARS = cache_num_rows(), family_id;
	if(TOTAL_ANGARS >= FAMILY_COUNT) print("Кол-во семей в базе больше максимального");
	else if(!TOTAL_ANGARS) print("Семьи в базе не найдены");
	else for(new angar_id = 0; angar_id < TOTAL_ANGARS; angar_id++) {
		cache_get_value_name_int(angar_id, "id", AngarsInfo[angar_id][aID]);

		cache_get_value_float(angar_id, "x", AngarsInfo[angar_id][aPosition][0]);
		cache_get_value_float(angar_id, "y", AngarsInfo[angar_id][aPosition][1]);
		cache_get_value_float(angar_id, "z", AngarsInfo[angar_id][aPosition][2]);
		cache_get_value_float(angar_id, "r", AngarsInfo[angar_id][aPosition][3]);

		cache_get_value_int(angar_id, "family", AngarsInfo[angar_id][aFamily]);
		cache_get_value_int(angar_id, "price", AngarsInfo[angar_id][aPrice]);
		cache_get_value_int(angar_id, "gate_rank", AngarsInfo[angar_id][aGateRank]);
		cache_get_value_int(angar_id, "fuel", AngarsInfo[angar_id][aFuel]);
		cache_get_value_int(angar_id, "days", AngarsInfo[angar_id][aDays]);
	
		if(AngarsInfo[angar_id][aFamily]) {
			family_id = (AngarsInfo[angar_id][aFamily] - 1);
			gFamily[family_id][famAngarID] = (angar_id + 1);
		}
		CreateDynamicAngar(angar_id, 
			AngarsInfo[angar_id][aPosition][0], AngarsInfo[angar_id][aPosition][1], 
			AngarsInfo[angar_id][aPosition][2], AngarsInfo[angar_id][aPosition][3]
		);
		if(AngarsInfo[angar_id][aFamily]) {
			format(MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "SELECT * FROM `family_cars` WHERE `FamID` = '%d' AND `Slot` > 5", 
				gFamily[(AngarsInfo[angar_id][aFamily] - 1)][famID]
			);
			mysql_tquery(connects, MYSQL_GLOBAL, "load_family_cars", "i", (gFamily[(AngarsInfo[angar_id][aFamily] - 1)][famID] - 1)), MYSQL_GLOBAL[0] = EOS;
		}
	}
	cache_delete(result);
	printf("[Загрузка ...] Ангары успешно загружены (%i шт.)", TOTAL_ANGARS);
	return 1;
}