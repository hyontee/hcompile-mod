#if defined _FAMILY_ADDITION_INC_
	#endinput
#endif
#define _FAMILY_ADDITION_INC_

// Семейные захваты / контейнеры — mod laird family_addition.pwn (расписание и логика 1:1)

#if !defined CONVERT_TIME_TO_SECONDS
	#define CONVERT_TIME_TO_SECONDS  (1)
#endif
#if !defined CONVERT_TIME_TO_MINUTES
	#define CONVERT_TIME_TO_MINUTES  (2)
#endif

#define FAMCAPT_START_OBJECT_1  (35)
#define FAMCAPT_START_OBJECT_2  (40)
#define FAMCAPT_START_OBJECT_3  (45)

#define MAX_FAM  MAX_FAM_LAIRD
#define MAX_FAMILY  MAX_FAM_LAIRD

#define GetPlayerIdFamily(%0)  FamilyCapt_GetPlayerSlot(%0)
#define SendFamilyMessage(%0,%1)  FamilyCapt_SendSlotMessage(%0,%1)

#define family_reputation   (2)
#define family_money        (3)

#define GetFamily(%0,%1)  FamCapt_GetFamilyField(%0,%1)

stock FamCapt_GetFamilyField(slot, field)
{
	if(field == family_reputation) return FamilyCapt_GetReputation(slot);
	if(field == family_money) return FamilyCapt_GetMoney(slot);
	return FamilyCapt_GetSlotDbId(slot);
}

stock FamCapt_AddFamily(slot, field, unused, value)
{
	#pragma unused unused
	if(field == family_reputation) return FamilyCapt_AddReputation(slot, value);
	if(field == family_money) return FamilyCapt_AddMoney(slot, value);
	return 0;
}

#define AddFamily(%0,%1,%2,%3)  FamCapt_AddFamily(%0,%1,%2,%3)

stock FamCapt_SetFamily(slot, field, value)
{
	if(field == family_reputation) return FamilyCapt_SetReputation(slot, value);
	return 0;
}

#define SetFamily(%0,%1,%2)  FamCapt_SetFamily(%0,%1,%2)

stock UpdateColumnFamilyInt(dbid, const col[], value)
{
	return FamLaird_UpdateInt(dbid, col, value);
}

stock FamCapt_ConvertUnixTime(unix_time, type)
{
	switch(type)
	{
		case CONVERT_TIME_TO_SECONDS: return unix_time % 60;
		case CONVERT_TIME_TO_MINUTES: return (unix_time / 60) % 60;
	}
	return 0;
}

#define ConvertUnixTime(%0,%1)  FamCapt_ConvertUnixTime(%0,%1)

stock GetDayOfWeek(year, month, day)
{
	new a = (14 - month) / 12;
	new y = year + 4800 - a;
	new m = month + 12 * a - 3;
	new c_date = day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045;
	return c_date % 7 + 1;
}

stock IsPlayerAFK(playerid)
{
	#pragma unused playerid
	return 0;
}

new FamCapt_ObjDuration[5] = {300, 600, 900, 300, 300};

new Float:FamCapt_CoordArea[5][4] =
{
	{910.033874, 1902.940673, 878.857238, 1928.133544},
	{2323.993896, -272.032928, 2291.157470, -240.167694},
	{-565.758972, -1971.165283, -612.426330, -2057.928710},
	{247.395721, -1518.309814, 219.366928, -1497.108764},
	{2684.796630, 559.033142, 2664.952636, 578.705078}
};

new Float:FamCapt_Text3DPos[5][3] =
{
	{886.062377, 1920.454956, 24.079668},
	{2323.703613, -264.093597, 1.561422},
	{-570.480468, -1972.626953, 41.199874},
	{237.258758, -1508.003417, 35.468399},
	{2676.136474, 569.995239, 15.730620}
};

new FamCapt_ObjectName[5][36] =
{
	{"Вышка сотовой связи №1"},
	{"Ферма Гарель"},
	{"Завод Бусаево"},
	{"Вышка сотовой связи №2"},
	{"Вышка сотовой связи №3"}
};

#define FAMCAPT_UI_SLOTS        (9)
#define FAMCAPT_PTD_INVALID     (PlayerText:INVALID_TEXT_DRAW)

new PlayerText:FamCapt_PlayerUI[MAX_PLAYERS][FAMCAPT_UI_SLOTS];
new PlayerText:FamCapt_PlayerScore[MAX_PLAYERS];
new FamCapt_PlayerUiType[MAX_PLAYERS];

new bool:FamCapt_ShowPanel[MAX_PLAYERS];
new FamCapt_Area[5] = {-1, ...};
new FamCapt_GangZone[5] = {-1, ...};
new FamCapt_Second[5];
new bool:FamCapt_Status[5];
new FamCapt_Timer[5] = {-1, ...};
new Text3D:FamCapt_Label[5];
new FamCapt_FamExp[MAX_FAM_LAIRD][5];
new FamCapt_Leader[5][2];
new FamCapt_PlayerExp[MAX_PLAYERS];
new FamCapt_OwnerSlot[5];

static const FamCapt_ColorTag[12][9] =
{
	"{FFFFFF}", "{C3C3C3}", "{F3FF02}", "{F81414}", "{00FFEE}", "{FF00EA}",
	"{C0C0C0}", "{C9FFAB}", "{FFF1AF}", "{FFAF00}", "{0049FF}", "{AFE7FF}"
};

#define FAMCAPT_LABEL_DRAW_DIST   (25.0)
#define FAMCAPT_LABEL_Z_OFFSET    (1.0)

new FamCont_Area[2] = {-1, ...};
new FamCont_GangZone[2] = {-1, ...};
new FamCont_Box[2];
new FamCont_Second[2];
new bool:FamCont_Status[2];
new FamCont_Timer[2] = {-1, ...};
new STREAMER_TAG_3D_TEXT_LABEL:FamCont_Label[2];
new FamCont_Pickup[2];
new FamCont_AreaPickup[2];
new FamCont_Object[2];
new FamCont_DeliveryArea;

new FamCont_VehBoxes[MAX_VEHICLES];
new FamCont_VehFamDbId[MAX_VEHICLES];
new FamCont_VehBootArea[MAX_VEHICLES];
new Text3D:FamCont_VehLabel[MAX_VEHICLES];
new bool:FamCont_VehRoute[MAX_VEHICLES];

new Float:FamCont_CoordArea[2][4] =
{
	{2065.620849, 1366.642456, 2001.571777, 1410.343261},
	{513.669067, -2324.174560, 400.018676, -2446.855957}
};

new Float:FamCont_PickupPos[2][3] =
{
	{2019.277465, 1397.384521, 26.273437},
	{454.554718, -2388.093750, 34.930751}
};

new Float:FamCont_ObjPos[2][3] =
{
	{2016.786865, 1397.302490, 26.15625},
	{452.989440, -2388.076660, 34.813564}
};

forward FamilyAddition_OnGameModeInit();
forward FamilyAddition_OnFamiliesLoaded();
forward FamilyAddition_OnOwnersLoaded();
forward FamilyAddition_FamilyTimer();
forward FamilyAddition_CaptureUpd(type);
forward FamilyAddition_ContUpd(i);
forward FamilyAddition_SetPlayerBoxInHard(playerid, number);

stock FamilyAddition_OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		FamCapt_PlayerUiType[i] = -1;
		FamCapt_PlayerScore[i] = FAMCAPT_PTD_INVALID;
		for(new u = 0; u < FAMCAPT_UI_SLOTS; u++)
			FamCapt_PlayerUI[i][u] = FAMCAPT_PTD_INVALID;
	}
	for(new v = 0; v < MAX_VEHICLES; v++)
	{
		FamCont_VehBootArea[v] = -1;
		FamCont_VehLabel[v] = Text3D:-1;
	}

	Create3DTextLabel("Используйте: {FF0000}гудок", -1, 2323.082275, -248.499404, 1.991280, 25.0, 0);
	FamCont_DeliveryArea = CreateDynamicSphere(2323.082275, -248.499404, 1.991280, 5.0, 0, 0);

	for(new p = 0; p < 5; p++)
	{
		FamCapt_OwnerSlot[p] = -1;
		FamCapt_Label[p] = Text3D:INVALID_3DTEXT_ID;
		FamCapt_UpdateOwnerLabel(p);
	}

	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `family_capture_owner` (\
			`point_id` TINYINT NOT NULL,\
			`family_id` INT NOT NULL DEFAULT 0,\
			`updated_at` INT NOT NULL DEFAULT 0,\
			PRIMARY KEY (`point_id`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
	mysql_tquery(db_handle,
		"INSERT IGNORE INTO `family_capture_owner` (`point_id`,`family_id`) VALUES (0,0),(1,0),(2,0),(3,0),(4,0)",
		"", "");

	SetTimer("FamilyAddition_FamilyTimer", 60 * 1000, true);
	printf("[Family] family_addition: захваты laird (:35/:40/:45, контейнеры) активны.");
	return 1;
}

stock FamCapt_SetLabelText(point, text[])
{
	if(point < 0 || point >= 5) return 0;
	if(FamCapt_Label[point] != Text3D:INVALID_3DTEXT_ID)
	{
		Update3DTextLabelText(FamCapt_Label[point], 0xFFFFFFFF, text);
		return 1;
	}
	new Float:lz = FamCapt_Text3DPos[point][2] + FAMCAPT_LABEL_Z_OFFSET;
	FamCapt_Label[point] = Create3DTextLabel(
		text, 0xFFFFFFFF,
		FamCapt_Text3DPos[point][0], FamCapt_Text3DPos[point][1], lz,
		FAMCAPT_LABEL_DRAW_DIST, 0, 1);
	return (FamCapt_Label[point] != Text3D:INVALID_3DTEXT_ID);
}

stock FamCapt_ColorTagByIdx(idx, dest[], len)
{
	if(idx < 0 || idx > 11) idx = 2;
	format(dest, len, "%s", FamCapt_ColorTag[idx]);
	return 1;
}

stock FamCapt_FormatColoredFamilyName(slot, dest[], len)
{
	new fname[FAMILY_NAME_CAP], tag1[12], tag2[12];
	dest[0] = '\0';
	if(!FamilyCapt_IsSlotUsed(slot))
	{
		format(dest, len, "{C3C3C3}—");
		return 1;
	}
	FamilyCapt_GetSlotName(slot, fname, sizeof fname);
	if(!strlen(fname))
	{
		format(dest, len, "{C3C3C3}—");
		return 1;
	}

	new c1 = FamilyCapt_GetSlotColorIdx(slot);
	new c2 = c1 + 1;
	if(c2 > 11) c2 = 0;
	FamCapt_ColorTagByIdx(c1, tag1, sizeof tag1);
	FamCapt_ColorTagByIdx(c2, tag2, sizeof tag2);

	new sp = strfind(fname, " ", true);
	if(sp == -1)
		format(dest, len, "%s%s", tag1, fname);
	else
	{
		new part1[20], part2[20];
		strmid(part1, fname, 0, sp, sizeof part1);
		strmid(part2, fname, sp + 1, strlen(fname), sizeof part2);
		if(!strlen(part2))
			format(dest, len, "%s%s", tag1, fname);
		else
			format(dest, len, "%s%s %s%s", tag1, part1, tag2, part2);
	}
	return 1;
}

stock FamCapt_UpdateOwnerLabel(point)
{
	if(point < 0 || point >= 5) return 0;
	new ownerLine[96], text[220];
	FamCapt_FormatColoredFamilyName(FamCapt_OwnerSlot[point], ownerLine, sizeof ownerLine);
	format(text, sizeof text,
		"{FFF000}%s\n{FFFFFF}Данным предприятием владеет семья\n%s",
		FamCapt_ObjectName[point], ownerLine);
	return FamCapt_SetLabelText(point, text);
}

stock FamCapt_UpdateBattleLabel(point)
{
	if(point < 0 || point >= 5) return 0;
	new text[180];
	format(text, sizeof text,
		"{FFF000}%s\n{FFFFFF}Идёт сражение — победитель будет владельцем",
		FamCapt_ObjectName[point]);
	return FamCapt_SetLabelText(point, text);
}

stock FamCapt_SaveOwner(point, family_db_id)
{
	if(point < 0 || point >= 5) return 0;
	new q[196];
	mysql_format(db_handle, q, sizeof q,
		"INSERT INTO `family_capture_owner` (`point_id`,`family_id`,`updated_at`) VALUES (%d,%d,%d)\
		 ON DUPLICATE KEY UPDATE `family_id`=%d, `updated_at`=%d",
		point, family_db_id, gettime(), family_db_id, gettime());
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock FamilyAddition_OnFamiliesLoaded()
{
	mysql_tquery(db_handle,
		"SELECT `point_id`,`family_id` FROM `family_capture_owner` WHERE `family_id`>0 ORDER BY `point_id` ASC",
		"FamilyAddition_OnOwnersLoaded", "");
	return 1;
}

public FamilyAddition_OnOwnersLoaded()
{
	for(new p = 0; p < 5; p++)
	{
		FamCapt_OwnerSlot[p] = -1;
		FamCapt_UpdateOwnerLabel(p);
	}
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	for(new r = 0; r < rows; r++)
	{
		new pid = cache_get_field_content_int(r, "point_id", db_handle);
		new fid = cache_get_field_content_int(r, "family_id", db_handle);
		if(pid < 0 || pid >= 5 || fid <= 0) continue;
		new slot = FamilyCapt_FindSlotByDbId(fid);
		if(slot == -1) continue;
		FamCapt_OwnerSlot[pid] = slot;
		FamCapt_UpdateOwnerLabel(pid);
	}
	return 1;
}

stock FamCapt_GetPlayerArea(playerid)
{
	for(new i; i < sizeof(FamCapt_Area); i++)
		if(FamCapt_Area[i] != -1 && IsPlayerInDynamicArea(playerid, FamCapt_Area[i])) return i;
	return -1;
}

stock FamCapt_IsCaptureArea(areaid)
{
	for(new i; i < sizeof(FamCapt_Area); i++)
		if(FamCapt_Area[i] != -1 && FamCapt_Area[i] == areaid) return i;
	return -1;
}

stock FamCapt_ShowGangZone(playerid, zoneid)
{
	if(zoneid < 0) return 0;
	GangZoneShowForPlayer(playerid, zoneid, 0xFF0000AA);
	return 1;
}

stock FamCapt_HideGangZone(playerid, zoneid)
{
	if(zoneid < 0) return 0;
	GangZoneHideForPlayer(playerid, zoneid);
	return 1;
}

stock FamCapt_HideAllGangZones(playerid)
{
	for(new i; i < sizeof(FamCapt_GangZone); i++)
		FamCapt_HideGangZone(playerid, FamCapt_GangZone[i]);
	for(new i; i < sizeof(FamCont_GangZone); i++)
		FamCapt_HideGangZone(playerid, FamCont_GangZone[i]);
	return 1;
}

stock FamCapt_DestroyPlayerUI(playerid)
{
	if(FamCapt_PlayerScore[playerid] != FAMCAPT_PTD_INVALID)
	{
		PlayerTextDrawDestroy(playerid, FamCapt_PlayerScore[playerid]);
		FamCapt_PlayerScore[playerid] = FAMCAPT_PTD_INVALID;
	}
	for(new u = 0; u < FAMCAPT_UI_SLOTS; u++)
	{
		if(FamCapt_PlayerUI[playerid][u] == FAMCAPT_PTD_INVALID) continue;
		PlayerTextDrawDestroy(playerid, FamCapt_PlayerUI[playerid][u]);
		FamCapt_PlayerUI[playerid][u] = FAMCAPT_PTD_INVALID;
	}
	FamCapt_PlayerUiType[playerid] = -1;
	FamCapt_ShowPanel[playerid] = false;
	return 1;
}

stock FamCont_FindVehicleByBootArea(areaid)
{
	for(new v = 1; v < MAX_VEHICLES; v++)
		if(FamCont_VehBootArea[v] == areaid) return v;
	return -1;
}

stock FamCont_IsFamilyVehicle(playerid, vehicleid)
{
	if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
	if(g_VehFleetMinRank[vehicleid] <= 0) return 0;
	if(Player[playerid][pFamilyId] <= 0) return 0;
	new owner = gVehOwnerCache[vehicleid];
	if(owner < 0 || !IsPlayerConnected(owner)) return 0;
	if(Player[owner][pFamilyId] != Player[playerid][pFamilyId]) return 0;
	return 1;
}

stock FamCont_ClearVehicle(vehicleid)
{
	if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
	if(FamCont_VehBootArea[vehicleid] != -1)
	{
		if(IsValidDynamicArea(FamCont_VehBootArea[vehicleid]))
			DestroyDynamicArea(FamCont_VehBootArea[vehicleid]);
		FamCont_VehBootArea[vehicleid] = -1;
	}
	if(FamCont_VehLabel[vehicleid] != Text3D:-1)
	{
		if(IsValidDynamic3DTextLabel(FamCont_VehLabel[vehicleid]))
			DestroyDynamic3DTextLabel(FamCont_VehLabel[vehicleid]);
		FamCont_VehLabel[vehicleid] = Text3D:-1;
	}
	FamCont_VehBoxes[vehicleid] = 0;
	FamCont_VehFamDbId[vehicleid] = 0;
	FamCont_VehRoute[vehicleid] = false;
	return 1;
}

stock FamilyAddition_OnEnterArea(playerid, areaid)
{
	new capt = FamCapt_IsCaptureArea(areaid);
	if(capt != -1)
	{
		if(!FamCapt_Status[capt]) return 0;
		new f = GetPlayerIdFamily(playerid);
		if(f == -1) return 0;
		if(f < 0 || f >= MAX_FAM_LAIRD || !FamilyCapt_IsSlotUsed(f)) return 0;
		if(!FamCapt_ShowPanel[playerid])
			FamCapt_OpenPanel(playerid, capt);
	}

	if(areaid == FamCont_Area[0] || areaid == FamCont_Area[1])
	{
		if(GetPlayerIdFamily(playerid) != -1)
			SendClientMessage(playerid, -1, "{D9FF00}[Семья]{FFFFFF} Вы вошли в зону боев за контейнер — законопослушность не снижается.");
	}

	if(areaid == FamCont_AreaPickup[0] || areaid == FamCont_AreaPickup[1])
	{
		if(GetPlayerIdFamily(playerid) == -1) return 0;
		new number = (areaid == FamCont_AreaPickup[0]) ? 0 : 1;
		if(FamCont_Box[number])
		{
			if(GetPVarInt(playerid, "box_in_hard"))
			{
				SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} У вас уже есть ящик на руках.");
				return 0;
			}
			ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0, 0);
			SetTimerEx("FamilyAddition_SetPlayerBoxInHard", 1000, false, "ii", playerid, number);
		}
		else SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} В контейнере закончились ящики.");
	}

	new bootveh = FamCont_FindVehicleByBootArea(areaid);
	if(bootveh != -1 && GetPlayerIdFamily(playerid) != -1)
	{
		if(FamCont_VehBoxes[bootveh] < 50)
		{
			if(!GetPVarInt(playerid, "box_in_hard"))
			{
				SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} У вас нет ящика на руках.");
				return 0;
			}
			DeletePVar(playerid, "box_in_hard");
			ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 0);
			RemovePlayerAttachedObject(playerid, 2);
			FamCont_VehBoxes[bootveh]++;
			new string[72];
			format(string, sizeof string, "Загружено ящиков: {FF0000}%d", FamCont_VehBoxes[bootveh]);
			if(IsValidDynamic3DTextLabel(FamCont_VehLabel[bootveh]))
				UpdateDynamic3DTextLabelText(FamCont_VehLabel[bootveh], -1, string);
			if(FamCont_VehBoxes[bootveh] != 50)
				SendClientMessage(playerid, -1, "{D9FF00}[Семья]{FFFFFF} Ящик погружен — вернитесь в контейнер за новым.");
			else
				SendClientMessage(playerid, -1, "{D9FF00}[Семья]{FFFFFF} Машина загружена — везите ящики на сдачу (гудок у фермы).");
		}
		else SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} В машине нет места.");
	}
	return 0;
}

stock FamilyAddition_OnLeaveArea(playerid, areaid)
{
	new type_capt = FamCapt_IsCaptureArea(areaid);
	if(type_capt == -1) return 0;

	new f = GetPlayerIdFamily(playerid);
	if(f == -1 || !FamCapt_Status[type_capt]) return 0;
	if(f < 0 || f >= MAX_FAM_LAIRD || type_capt < 0 || type_capt >= 5) return 0;

	FamCapt_ClosePanel(playerid, type_capt);

	new exp_new = FamCapt_FamExp[f][type_capt] - FamCapt_PlayerExp[playerid];
	if(exp_new >= 0)
	{
		FamCapt_FamExp[f][type_capt] -= FamCapt_PlayerExp[playerid];
		if(FamCapt_Leader[type_capt][0] == f)
			FamCapt_Leader[type_capt][1] -= FamCapt_PlayerExp[playerid];
	}

	new string[164];
	format(string, sizeof string, "Игрок %s[%d] покинул территорию сражения и потерял %d очков",
		GetPlayerNameEx(playerid), playerid, FamCapt_PlayerExp[playerid]);
	SendFamilyMessage(f, string);
	FamCapt_PlayerExp[playerid] = 0;
	FamCapt_UpdateExpFamily(f, type_capt);
	return 1;
}

stock FamilyAddition_OnDisconnect(playerid)
{
	new capt = FamCapt_GetPlayerArea(playerid);
	if(GetPlayerIdFamily(playerid) != -1 && FamCapt_PlayerExp[playerid] != 0)
	{
		new f = GetPlayerIdFamily(playerid), string[124];
		if(capt != -1)
		{
			new exp = FamCapt_FamExp[f][capt] - FamCapt_PlayerExp[playerid];
			if(exp >= 0)
			{
				FamCapt_FamExp[f][capt] -= FamCapt_PlayerExp[playerid];
				if(FamCapt_Leader[capt][0] == f)
					FamCapt_Leader[capt][1] -= FamCapt_PlayerExp[playerid];
			}
		}
		else
		{
			for(new i; i < sizeof(FamCapt_Status); i++)
				FamCapt_UpdateExpFamily(f, i);
		}
		format(string, sizeof string, "Игрок %s[%d] вышел во время сражения и потерял %d очков",
			GetPlayerNameEx(playerid), playerid, FamCapt_PlayerExp[playerid]);
		SendFamilyMessage(f, string);
	}
	FamCapt_DestroyPlayerUI(playerid);
	FamCapt_PlayerExp[playerid] = 0;
	FamCapt_HideAllGangZones(playerid);
	return 1;
}

stock FamilyAddition_OnSpawn(playerid)
{
	if(GetPlayerIdFamily(playerid) != -1)
	{
		for(new i; i < sizeof(FamCapt_Status); i++)
		{
			if(!FamCapt_Status[i]) continue;
			FamCapt_ShowGangZone(playerid, FamCapt_GangZone[i]);
		}
		for(new i; i < sizeof(FamCont_Status); i++)
		{
			if(!FamCont_Status[i]) continue;
			FamCapt_ShowGangZone(playerid, FamCont_GangZone[i]);
		}
	}
	FamCapt_PlayerExp[playerid] = 0;
	FamCapt_DestroyPlayerUI(playerid);
	return 1;
}

stock FamilyAddition_OnDeath(playerid, killerid)
{
	if(GetPlayerIdFamily(playerid) == -1) return 0;
	if(!(FamCapt_Status[0] || FamCapt_Status[1] || FamCapt_Status[2] || FamCapt_Status[3] || FamCapt_Status[4]))
		return 0;
	if(FamCapt_PlayerExp[playerid] == 0) return 0;

	new capt = FamCapt_GetPlayerArea(playerid);
	new string[124];

	if(killerid != INVALID_PLAYER_ID)
	{
		new f = GetPlayerIdFamily(killerid);
		if(f != -1 && f >= 0 && f < MAX_FAM_LAIRD && capt != -1)
		{
			format(string, sizeof string, "Игрок %s[%d] убил врага и заработал %d очков",
				GetPlayerNameEx(killerid), killerid, FamCapt_PlayerExp[playerid]);
			SendFamilyMessage(f, string);
			FamCapt_FamExp[f][capt] += FamCapt_PlayerExp[playerid];
			FamCapt_PlayerExp[killerid] += FamCapt_PlayerExp[playerid];
		}
	}

	format(string, sizeof string, "Игрок %s[%d] погиб на сражении и потерял %d очков",
		GetPlayerNameEx(playerid), playerid, FamCapt_PlayerExp[playerid]);
	SendFamilyMessage(GetPlayerIdFamily(playerid), string);

	new pf = GetPlayerIdFamily(playerid);
	if(capt != -1 && pf != -1 && FamCapt_FamExp[pf][capt] - FamCapt_PlayerExp[playerid] >= 0)
	{
		FamCapt_FamExp[pf][capt] -= FamCapt_PlayerExp[playerid];
		if(FamCapt_Leader[capt][0] == pf)
			FamCapt_Leader[capt][1] -= FamCapt_PlayerExp[playerid];
	}
	FamCapt_PlayerExp[playerid] = 0;
	return 1;
}

stock FamilyAddition_OnKeyStateChange(playerid, newkeys, oldkeys)
{
	#pragma unused oldkeys
	if(newkeys & KEY_CROUCH)
		FamCont_HandleDeliveryCrouch(playerid);
	if(newkeys & KEY_FIRE && GetPVarInt(playerid, "box_in_hard"))
	{
		RemovePlayerAttachedObject(playerid, 2);
		DeletePVar(playerid, "box_in_hard");
		SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} Вы уронили ящик — вернитесь в контейнер.");
	}
	return 0;
}

stock FamilyAddition_OnEnterVehicle(playerid, vehicleid, ispassenger)
{
	#pragma unused ispassenger
	if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
	if(!FamCont_VehRoute[vehicleid]) return 0;
	if(g_VehFleetMinRank[vehicleid] <= 0) return 0;

	SendClientMessage(playerid, -1, "{D9FF00}[Семья]{FFFFFF} Точка сдачи отмечена на карте (иконка оружия).");
	CreateDynamicMapIcon(2323.082275, -248.499404, 1.991280, 6, 0, 0, 0, playerid, -1);
	FamCont_VehRoute[vehicleid] = false;
	RemovePlayerAttachedObject(playerid, 2);
	return 1;
}

stock FamCapt_StartCapture(type_capt)
{
	if(FamCapt_Status[type_capt]) return printf("[FamilyCapt] %d already started", type_capt);

	new string[265], count, targets[3] = {0, 3, 4};
	if(type_capt)
	{
		count = 1;
		targets[0] = type_capt;
	}
	else count = 3;

	for(new i; i < count; i++)
	{
		new e = targets[i];
		FamCapt_Status[e] = true;
		FamCapt_Leader[e][0] = -1;
		FamCapt_Leader[e][1] = 0;
		FamCapt_Second[e] = FamCapt_ObjDuration[e];
		FamCapt_Timer[e] = SetTimerEx("FamilyAddition_CaptureUpd", 1000, true, "i", e);
		FamCapt_GangZone[e] = GangZoneCreate(FamCapt_CoordArea[e][0], FamCapt_CoordArea[e][1], FamCapt_CoordArea[e][2], FamCapt_CoordArea[e][3]);
		FamCapt_Area[e] = CreateDynamicRectangle(FamCapt_CoordArea[e][0], FamCapt_CoordArea[e][1], FamCapt_CoordArea[e][2], FamCapt_CoordArea[e][3], 0, 0);

		for(new w; w < MAX_FAM_LAIRD; w++) FamCapt_FamExp[w][e] = 0;

		FamCapt_UpdateBattleLabel(e);

		for(new w = 0, pj = GetPlayerPoolSize(); w <= pj; w++)
		{
			if(!IsPlayerConnected(w)) continue;
			if(GetPlayerIdFamily(w) == -1) continue;
			FamCapt_ShowGangZone(w, FamCapt_GangZone[e]);
		}

		format(string, sizeof string, "{fad201}|{FFFFFF} Началось сражение за {fad201}%s{FFFFFF}. Место — на карте.", FamCapt_ObjectName[e]);
		for(new w = 0, pj = GetPlayerPoolSize(); w <= pj; w++)
		{
			if(!IsPlayerConnected(w)) continue;
			if(GetPlayerIdFamily(w) == -1) continue;
			SendClientMessage(w, -1, string);
		}
	}
	return 1;
}

stock FamCapt_EndCapture(type)
{
	KillTimer(FamCapt_Timer[type]);
	FamCapt_Timer[type] = -1;

	for(new i = 0, pj = GetPlayerPoolSize(); i <= pj; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(GetPlayerIdFamily(i) == -1) continue;
		if(!IsPlayerInDynamicArea(i, FamCapt_Area[type])) continue;
		FamCapt_ClosePanel(i, type);
		FamCapt_PlayerExp[i] = 0;
	}

	new string[245], f = FamCapt_Leader[type][0];
	if(f != -1 || FamCapt_Leader[type][1] != 0)
	{
		new fname[FAMILY_NAME_CAP];
		FamilyCapt_GetSlotName(f, fname, sizeof fname);
		format(string, sizeof string, "Сражение окончено. Победила семья %s — %d очков", fname, FamCapt_Leader[type][1]);
		AddFamily(f, family_reputation, 0, FamCapt_Leader[type][1]);
		UpdateColumnFamilyInt(FamilyCapt_GetSlotDbId(f), "reputation", FamilyCapt_GetReputation(f));
		FamilyCapt_BroadcastAllSlots(string);

		FamCapt_OwnerSlot[type] = f;
		FamCapt_SaveOwner(type, FamilyCapt_GetSlotDbId(f));
		FamCapt_UpdateOwnerLabel(type);
	}
	else FamCapt_UpdateOwnerLabel(type);

	if(FamCapt_Area[type] != -1)
	{
		DestroyDynamicArea(FamCapt_Area[type]);
		FamCapt_Area[type] = -1;
	}
	if(FamCapt_GangZone[type] != -1)
	{
		for(new p = 0, pj = GetPlayerPoolSize(); p <= pj; p++)
			if(IsPlayerConnected(p)) FamCapt_HideGangZone(p, FamCapt_GangZone[type]);
		GangZoneDestroy(FamCapt_GangZone[type]);
		FamCapt_GangZone[type] = -1;
	}
	FamCapt_Second[type] = 0;
	FamCapt_Status[type] = false;
	for(new i; i < MAX_FAM_LAIRD; i++) FamCapt_FamExp[i][type] = 0;
	FamCapt_Leader[type][0] = -1;
	FamCapt_Leader[type][1] = 0;
	return 1;
}

new FamCapt_TimeStr[8];
public FamilyAddition_CaptureUpd(type)
{
	if(!FamCapt_Second[type]) return FamCapt_EndCapture(type);
	FamCapt_Second[type]--;
	format(FamCapt_TimeStr, sizeof FamCapt_TimeStr, "%d:%02d",
		FamCapt_ConvertUnixTime(FamCapt_Second[type], CONVERT_TIME_TO_MINUTES),
		FamCapt_ConvertUnixTime(FamCapt_Second[type], CONVERT_TIME_TO_SECONDS));

	for(new i = 0, pj = GetPlayerPoolSize(); i <= pj; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(GetPlayerIdFamily(i) == -1)
		{
			if(FamCapt_ShowPanel[i]) FamCapt_ClosePanel(i, type);
			continue;
		}
		if(!IsPlayerInDynamicArea(i, FamCapt_Area[type])) continue;
		if(IsPlayerAFK(i)) continue;

		FamCapt_PlayerExp[i]++;
		new fslot = GetPlayerIdFamily(i);
		FamCapt_FamExp[fslot][type]++;

		if(FamCapt_ShowPanel[i] && FamCapt_PlayerUiType[i] == type)
			FamCapt_RefreshPlayerUI(i, type);
	}

	new lid = FamCapt_Leader[type][0], lexp = FamCapt_Leader[type][1];
	for(new i; i < MAX_FAM_LAIRD; i++)
	{
		if(lid == i && FamCapt_FamExp[i][type] < lexp)
			FamCapt_UpdateExpFamily(i, type);
		if(FamCapt_FamExp[i][type] <= lexp) continue;
		FamCapt_Leader[type][0] = i;
		FamCapt_Leader[type][1] = FamCapt_FamExp[i][type];
	}
	return 1;
}

stock FamCapt_UpdateExpFamily(f, t)
{
	new total;
	for(new i = 0, pj = GetPlayerPoolSize(); i <= pj; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(GetPlayerIdFamily(i) != f) continue;
		if(!IsPlayerInDynamicArea(i, FamCapt_Area[t])) continue;
		total += FamCapt_PlayerExp[i];
	}
	if(FamCapt_FamExp[f][t] != total) FamCapt_FamExp[f][t] = total;
	if(f == FamCapt_Leader[t][0]) FamCapt_Leader[t][1] = FamCapt_FamExp[f][t];
	return 1;
}

stock FamCapt_PTD_Box(playerid, slot, Float:x, Float:y, Float:w, Float:h, color)
{
	FamCapt_PlayerUI[playerid][slot] = CreatePlayerTextDraw(playerid, x, y, "_");
	PlayerTextDrawUseBox(playerid, FamCapt_PlayerUI[playerid][slot], 1);
	PlayerTextDrawBoxColor(playerid, FamCapt_PlayerUI[playerid][slot], color);
	PlayerTextDrawTextSize(playerid, FamCapt_PlayerUI[playerid][slot], x + w, y + h);
	PlayerTextDrawAlignment(playerid, FamCapt_PlayerUI[playerid][slot], 1);
	PlayerTextDrawFont(playerid, FamCapt_PlayerUI[playerid][slot], 1);
	PlayerTextDrawSetShadow(playerid, FamCapt_PlayerUI[playerid][slot], 0);
	PlayerTextDrawSetOutline(playerid, FamCapt_PlayerUI[playerid][slot], 0);
	PlayerTextDrawBackgroundColor(playerid, FamCapt_PlayerUI[playerid][slot], 255);
	PlayerTextDrawColor(playerid, FamCapt_PlayerUI[playerid][slot], 0);
	return 1;
}

stock FamCapt_PTD_Label(playerid, slot, Float:x, Float:y, text[], Float:lsX, Float:lsY, align, font)
{
	FamCapt_PlayerUI[playerid][slot] = CreatePlayerTextDraw(playerid, x, y, text);
	PlayerTextDrawLetterSize(playerid, FamCapt_PlayerUI[playerid][slot], lsX, lsY);
	PlayerTextDrawAlignment(playerid, FamCapt_PlayerUI[playerid][slot], align);
	PlayerTextDrawColor(playerid, FamCapt_PlayerUI[playerid][slot], -1);
	PlayerTextDrawFont(playerid, FamCapt_PlayerUI[playerid][slot], font);
	PlayerTextDrawSetShadow(playerid, FamCapt_PlayerUI[playerid][slot], 0);
	PlayerTextDrawSetOutline(playerid, FamCapt_PlayerUI[playerid][slot], 0);
	PlayerTextDrawBackgroundColor(playerid, FamCapt_PlayerUI[playerid][slot], 255);
	return 1;
}

stock FamCapt_RefreshPlayerUI(playerid, t)
{
	if(!FamCapt_ShowPanel[playerid] || FamCapt_PlayerUiType[playerid] != t) return 0;
	new f = GetPlayerIdFamily(playerid);
	if(f == -1) return FamCapt_DestroyPlayerUI(playerid);

	new score[12], leader[12];
	format(score, sizeof score, "%d", FamCapt_FamExp[f][t]);
	format(leader, sizeof leader, "%d", FamCapt_Leader[t][1]);

	if(FamCapt_PlayerScore[playerid] != FAMCAPT_PTD_INVALID)
		PlayerTextDrawSetString(playerid, FamCapt_PlayerScore[playerid], score);
	if(FamCapt_PlayerUI[playerid][4] != FAMCAPT_PTD_INVALID)
		PlayerTextDrawSetString(playerid, FamCapt_PlayerUI[playerid][4], leader);
	if(FamCapt_PlayerUI[playerid][8] != FAMCAPT_PTD_INVALID)
		PlayerTextDrawSetString(playerid, FamCapt_PlayerUI[playerid][8], FamCapt_TimeStr);
	return 1;
}

stock FamCapt_OpenPanel(playerid, t)
{
	if(t < 0 || t >= 5 || !FamCapt_Status[t] || FamCapt_Area[t] == -1) return 0;
	new f = GetPlayerIdFamily(playerid);
	if(f == -1 || !FamilyCapt_IsSlotUsed(f)) return 0;

	FamCapt_DestroyPlayerUI(playerid);

	FamCapt_PTD_Box(playerid, 0, 6.3333, 248.3333, 107.0, 59.0, 0x5A5A5AAA);
	FamCapt_PTD_Box(playerid, 1, 6.3333, 249.5777, 107.0, 36.0, 0x161616AA);
	FamCapt_PTD_Label(playerid, 2, 10.3332, 252.2221, "Ваши очки:", 0.1699, 1.4879, 1, 2);
	FamCapt_PTD_Label(playerid, 3, 10.3332, 266.7406, "Лидер:", 0.1699, 1.4879, 1, 2);
	FamCapt_PTD_Label(playerid, 4, 99.6667, 267.1553, "0", 0.2022, 1.4920, 2, 2);
	FamCapt_PTD_Box(playerid, 5, 6.3333, 295.2074, 107.0, 5.0, 0x161616AA);
	FamCapt_PTD_Box(playerid, 6, 6.3333, 301.0148, 107.0, 6.0, 0x161616AA);
	FamCapt_PTD_Label(playerid, 7, 40.6666, 284.9925, "ВРЕМЯ:", 0.2253, 1.0524, 1, 1);
	FamCapt_PTD_Label(playerid, 8, 67.6666, 284.9925, "00:00", 0.2253, 1.0524, 1, 1);

	FamCapt_PlayerScore[playerid] = CreatePlayerTextDraw(playerid, 99.3332, 252.6367, "0");
	PlayerTextDrawLetterSize(playerid, FamCapt_PlayerScore[playerid], 0.1799, 1.4961);
	PlayerTextDrawAlignment(playerid, FamCapt_PlayerScore[playerid], 2);
	PlayerTextDrawColor(playerid, FamCapt_PlayerScore[playerid], -1);
	PlayerTextDrawFont(playerid, FamCapt_PlayerScore[playerid], 2);

	for(new u = 0; u < FAMCAPT_UI_SLOTS; u++)
	{
		if(FamCapt_PlayerUI[playerid][u] == FAMCAPT_PTD_INVALID) continue;
		PlayerTextDrawShow(playerid, FamCapt_PlayerUI[playerid][u]);
	}
	if(FamCapt_PlayerScore[playerid] != FAMCAPT_PTD_INVALID)
		PlayerTextDrawShow(playerid, FamCapt_PlayerScore[playerid]);

	FamCapt_PlayerUiType[playerid] = t;
	FamCapt_ShowPanel[playerid] = true;
	FamCapt_RefreshPlayerUI(playerid, t);
	return 1;
}

stock FamCapt_ClosePanel(playerid, t)
{
	#pragma unused t
	return FamCapt_DestroyPlayerUI(playerid);
}

public FamilyAddition_FamilyTimer()
{
	new minute, hours;
	gettime(hours, minute);

	switch(minute)
	{
		case 0:
		{
			if(!hours)
			{
				new year, month, day;
				getdate(year, month, day);
				if(GetDayOfWeek(year, month, day) == 4)
					FamCapt_WeeklySeasonReset();
			}
		}
		case FAMCAPT_START_OBJECT_1: FamCapt_StartCapture(0);
		case FAMCAPT_START_OBJECT_2: FamCapt_StartCapture(1);
		case FAMCAPT_START_OBJECT_3: FamCapt_StartCapture(2);
		default:
		{
			if(!FamCont_Status[0] && !FamCont_Status[1])
			{
				new r = random(40);
				if(r <= 10) return 1;
				FamCont_Start(1);
			}
		}
	}
	return 1;
}

stock FamCapt_WeeklySeasonReset()
{
	new q[192], Cache:result = mysql_query(db_handle,
		"SELECT * FROM `family` WHERE `reputation` >= 0 ORDER BY `reputation` DESC LIMIT 3", true);
	if(!result) return 0;

	new rows = cache_num_rows(), id;
	for(new i; i < rows; i++)
	{
		id = cache_get_field_content_int(i, "id", db_handle);
		switch(i)
		{
			case 0:
			{
				mysql_format(db_handle, q, sizeof q, "UPDATE `family` SET `slot_veh`=`slot_veh`+2 WHERE `id`=%d", id);
				mysql_tquery(db_handle, q, "", "");
				mysql_format(db_handle, q, sizeof q,
					"INSERT INTO `family_ad` (`family`,`ad_text`,`create_id`,`create_name`,`time`) VALUES (%d,'Ваша семья заняла первое место в прошлом сезоне',-1,'Система',%d)",
					id, gettime() + 10800);
				mysql_tquery(db_handle, q, "", "");
				mysql_format(db_handle, q, sizeof q,
					"UPDATE `players` SET `money`=`money`+90000, `donate`=`donate`+40 WHERE `family_id`=%d", id);
				mysql_tquery(db_handle, q, "", "");
				new slot = FamilyCapt_FindSlotByDbId(id);
				if(slot != -1) FamilyCapt_AddSlotVeh(slot, 2);
			}
			case 1:
			{
				mysql_format(db_handle, q, sizeof q, "UPDATE `family` SET `slot_veh`=`slot_veh`+1 WHERE `id`=%d", id);
				mysql_tquery(db_handle, q, "", "");
				mysql_format(db_handle, q, sizeof q,
					"INSERT INTO `family_ad` (`family`,`ad_text`,`create_id`,`create_name`,`time`) VALUES (%d,'Ваша семья заняла второе место в прошлом сезоне',-1,'Система',%d)",
					id, gettime() + 10800);
				mysql_tquery(db_handle, q, "", "");
				mysql_format(db_handle, q, sizeof q,
					"UPDATE `players` SET `money`=`money`+60000, `donate`=`donate`+30 WHERE `family_id`=%d", id);
				mysql_tquery(db_handle, q, "", "");
				new slot = FamilyCapt_FindSlotByDbId(id);
				if(slot != -1) FamilyCapt_AddSlotVeh(slot, 1);
			}
			case 2:
			{
				mysql_format(db_handle, q, sizeof q,
					"UPDATE `players` SET `money`=`money`+30000, `donate`=`donate`+20 WHERE `family_id`=%d", id);
				mysql_tquery(db_handle, q, "", "");
				mysql_format(db_handle, q, sizeof q,
					"INSERT INTO `family_ad` (`family`,`ad_text`,`create_id`,`create_name`,`time`) VALUES (%d,'Ваша семья заняла третье место в прошлом сезоне',-1,'Система',%d)",
					id, gettime() + 10800);
				mysql_tquery(db_handle, q, "", "");
			}
		}
	}
	for(new i = 0; i < MAX_FAM_LAIRD; i++)
		if(FamilyCapt_IsSlotUsed(i)) FamilyCapt_SetReputation(i, 0);
	mysql_tquery(db_handle, "UPDATE `family` SET `reputation`=0", "", "");
	cache_delete(result);
	return 1;
}

stock FamCont_Start(type_capt)
{
	#pragma unused type_capt
	if(FamCont_Status[0] || FamCont_Status[1]) return printf("[FamCont] already started");

	new string[265];
	for(new i; i < 2; i++)
	{
		FamCont_Status[i] = true;
		FamCont_Box[i] = 350;
		FamCont_Second[i] = 1500;
		FamCont_GangZone[i] = GangZoneCreate(FamCont_CoordArea[i][0], FamCont_CoordArea[i][1], FamCont_CoordArea[i][2], FamCont_CoordArea[i][3]);
		FamCont_Area[i] = CreateDynamicRectangle(FamCont_CoordArea[i][0], FamCont_CoordArea[i][1], FamCont_CoordArea[i][2], FamCont_CoordArea[i][3], 0, 0);
		FamCont_Object[i] = CreateObject(934, FamCont_ObjPos[i][0], FamCont_ObjPos[i][1], FamCont_ObjPos[i][2] + 1.0, 0.0, 0.0, 0.0);
		FamCont_Pickup[i] = CreateDynamicPickup(19135, 23, FamCont_PickupPos[i][0], FamCont_PickupPos[i][1], FamCont_PickupPos[i][2], 0, 0);
		FamCont_AreaPickup[i] = CreateDynamicSphere(FamCont_PickupPos[i][0], FamCont_PickupPos[i][1], FamCont_PickupPos[i][2], 1.5, 0, 0);
		FamCont_Label[i] = CreateDynamic3DTextLabel(
			"Содержимое контейнера\nКонец захвата через: 25 минут\nПодойдите к пикапу для взаимодействия.",
			0xFFFFFFFF,
			FamCont_PickupPos[i][0], FamCont_PickupPos[i][1], FamCont_PickupPos[i][2] + 1.5,
			35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 300.0);

		for(new w = 0, pj = GetPlayerPoolSize(); w <= pj; w++)
		{
			if(!IsPlayerConnected(w)) continue;
			if(GetPlayerIdFamily(w) == -1) continue;
			FamCapt_ShowGangZone(w, FamCont_GangZone[i]);
		}
		FamCont_Timer[i] = SetTimerEx("FamilyAddition_ContUpd", 1000, true, "i", i);
	}
	format(string, sizeof string, "{fad201}|{FFFFFF} Началось сражение за {fad201}семейные контейнеры{FFFFFF}. Место — на карте.");
	for(new w = 0, pj = GetPlayerPoolSize(); w <= pj; w++)
	{
		if(!IsPlayerConnected(w)) continue;
		if(GetPlayerIdFamily(w) == -1) continue;
		SendClientMessage(w, -1, string);
	}
	return 1;
}

new FamCont_CountStr[98];
public FamilyAddition_ContUpd(i)
{
	if(!FamCont_Second[i]) return FamCont_EndAll();
	FamCont_Second[i]--;
	format(FamCont_CountStr, sizeof FamCont_CountStr,
		"Содержимое контейнера\nКонец захвата через: %d минут\nПодойдите к пикапу для взаимодействия.",
		FamCapt_ConvertUnixTime(FamCont_Second[i], CONVERT_TIME_TO_MINUTES));
	if(IsValidDynamic3DTextLabel(FamCont_Label[i]))
		UpdateDynamic3DTextLabelText(FamCont_Label[i], 0xFFFFFFFF, FamCont_CountStr);
	return 1;
}

stock FamCont_EndAll()
{
	for(new i; i < 2; i++)
	{
		KillTimer(FamCont_Timer[i]);
		FamCont_Timer[i] = -1;
		FamCont_Status[i] = false;
		if(FamCont_Object[i]) { DestroyObject(FamCont_Object[i]); FamCont_Object[i] = 0; }
		if(FamCont_Area[i] != -1) { DestroyDynamicArea(FamCont_Area[i]); FamCont_Area[i] = -1; }
		if(FamCont_AreaPickup[i] != -1) { DestroyDynamicArea(FamCont_AreaPickup[i]); FamCont_AreaPickup[i] = -1; }
		if(FamCont_GangZone[i] != -1)
		{
			for(new p = 0, pj = GetPlayerPoolSize(); p <= pj; p++)
				if(IsPlayerConnected(p)) FamCapt_HideGangZone(p, FamCont_GangZone[i]);
			GangZoneDestroy(FamCont_GangZone[i]);
			FamCont_GangZone[i] = -1;
		}
		FamCont_Box[i] = 0;
		FamCont_Second[i] = 0;
		if(IsValidDynamic3DTextLabel(FamCont_Label[i]))
		{
			DestroyDynamic3DTextLabel(FamCont_Label[i]);
			FamCont_Label[i] = STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID;
		}
		if(FamCont_Pickup[i]) { DestroyDynamicPickup(FamCont_Pickup[i]); FamCont_Pickup[i] = 0; }
	}
	for(new v = 1; v < MAX_VEHICLES; v++)
		if(FamCont_VehBootArea[v] != -1) FamCont_ClearVehicle(v);
	return 1;
}

stock FamCont_GetBootCoords(vehicleid, &Float:x, &Float:y, &Float:z)
{
	new Float:angle, Float:distance;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, x, distance, z);
	distance = distance / 2.0 + 0.1;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);
	x += (distance * floatsin(-angle + 180.0, degrees));
	y += (distance * floatcos(-angle + 180.0, degrees));
	return 1;
}

stock FamCont_HandleDeliveryCrouch(playerid)
{
	if(GetPlayerIdFamily(playerid) == -1 || !IsPlayerInDynamicArea(playerid, FamCont_DeliveryArea)) return 0;
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!vehicleid || g_VehFleetMinRank[vehicleid] <= 0) return 0;
	new owner = gVehOwnerCache[vehicleid];
	if(owner < 0 || Player[owner][pFamilyId] != Player[playerid][pFamilyId]) return 0;
	if(FamCont_VehBoxes[vehicleid] == 0)
	{
		SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} В транспорте нет ящиков.");
		return 0;
	}

	new boxes = FamCont_VehBoxes[vehicleid];
	new money = boxes * 100;
	new fslot = GetPlayerIdFamily(playerid);
	AddFamily(fslot, family_reputation, 0, boxes);
	AddFamily(fslot, family_money, 0, money);
	UpdateColumnFamilyInt(FamilyCapt_GetSlotDbId(fslot), "money", FamilyCapt_GetMoney(fslot));
	UpdateColumnFamilyInt(FamilyCapt_GetSlotDbId(fslot), "reputation", FamilyCapt_GetReputation(fslot));

	new string[144];
	format(string, sizeof string, "%s[%d] сдал ящики: семья +%d реп., +%d руб.",
		GetPlayerNameEx(playerid), playerid, boxes, money);
	SendFamilyMessage(fslot, string);
	FamCont_ClearVehicle(vehicleid);
	return 1;
}

public FamilyAddition_SetPlayerBoxInHard(playerid, number)
{
	SetPlayerAttachedObject(playerid, 2, 2969, 1, 0.121241, 0.433916, -0.038068, 359.338867, 91.670600, 179.788787, 1.0, 1.0, 1.0);
	FamCont_Box[number]--;
	SendClientMessage(playerid, -1, "{D9FF00}[Семья]{FFFFFF} Вы взяли ящик — отнесите его в семейный транспорт.");
	SetPVarInt(playerid, "box_in_hard", 1);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0);
	return 1;
}

CMD:startfevent(playerid, params[])
{
	new t;
	if(sscanf(params, "d", t) || t < 1 || t > 4)
		return SendClientMessage(playerid, -1, "1 — вышки | 2 — ферма | 3 — завод | 4 — контейнеры"), 1;
	if(1 <= t <= 3)
	{
		if(FamCapt_Status[t - 1]) return SendClientMessage(playerid, -1, "Это сражение уже идёт."), 1;
		FamCapt_StartCapture(t - 1);
	}
	else
	{
		if(FamCont_Status[0] || FamCont_Status[1]) return SendClientMessage(playerid, -1, "Контейнеры уже активны."), 1;
		FamCont_Start(0);
	}
	return 1;
}

CMD:endfevent(playerid, params[])
{
	#pragma unused params
	if(FamCapt_Status[0]) FamCapt_EndCapture(0);
	if(FamCapt_Status[1]) FamCapt_EndCapture(1);
	if(FamCapt_Status[2]) FamCapt_EndCapture(2);
	if(FamCapt_Status[3]) FamCapt_EndCapture(3);
	if(FamCapt_Status[4]) FamCapt_EndCapture(4);
	SendClientMessage(playerid, -1, "Семейные захваты остановлены (вышки/ферма/завод).");
	return 1;
}

CMD:loadfamily(playerid, params[])
{
	#pragma unused params
	if(GetPlayerIdFamily(playerid) == -1) return 0;
	if(!IsPlayerInDynamicArea(playerid, FamCont_Area[0]) && !IsPlayerInDynamicArea(playerid, FamCont_Area[1]))
		return SendClientMessage(playerid, -1, "{FF0000}[Семья]{FFFFFF} Вы не в зоне семейных контейнеров."), 1;
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!vehicleid || !FamCont_IsFamilyVehicle(playerid, vehicleid))
		return SendClientMessage(playerid, 0xFF6666FF, "{FF0000}[Семья]{FFFFFF} Нужен семейный транспорт из автопарка."), 1;

	FamCont_ClearVehicle(vehicleid);
	new Float:x, Float:y, Float:z, string[74];
	FamCont_GetBootCoords(vehicleid, x, y, z);
	FamCont_VehFamDbId[vehicleid] = Player[playerid][pFamilyId];
	format(string, sizeof string, "Загружено ящиков: {FF0000}0");
	FamCont_VehBootArea[vehicleid] = CreateDynamicSphere(x, y, z, 1.5, 0, 0);
	FamCont_VehLabel[vehicleid] = CreateDynamic3DTextLabel(string, -1, x, y, z, 7.0);
	FamCont_VehRoute[vehicleid] = true;
	RemovePlayerFromVehicle(playerid);
	SendClientMessage(playerid, -1, "{D9FF00}[Семья]{FFFFFF} Загрузка начата — берите ящики у контейнера.");
	return 1;
}

CMD:tpw(playerid, params[])
{
	if(isnull(params))
		SetPlayerPos(playerid, 452.989440, -2388.076660, 34.813564);
	else
		SetPlayerPos(playerid, 2016.786865, 1397.302490, 26.15625);
	return 1;
}
