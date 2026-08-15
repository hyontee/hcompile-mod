#if defined _BR_FAMILY_INC_
	#endinput
#endif
#define _BR_FAMILY_INC_

// Семья (GUI 45, логово, автопарк) — адаптация familybyfronz под BR BLACK STUDIO / mode
#define FAMILY_GUI_ID              (45)
/* Навигация GUIFamilySystem (как в BR / family.inc) */
#define FAMILY_IF_QUESTS           (1)
#define FAMILY_IF_CARPARK          (2)
#define FAMILY_IF_SHOP             (3)
#define FAMILY_IF_UPGRADE          (4)
#define FAMILY_IF_SETTINGS         (5)
#define FAMILY_IF_NOTIFICATIONS    (6)
#define FAMILY_IF_RATING           (7)
#define DIALOG_FAMILY_CREATE       (19350)
#define FAMILY_NAME_MIN_LEN        (3)
#define FAMILY_NAME_MAX_LEN        (24)
#define FAMILY_NAME_CAP            (32)
#define FAMILY_UPGRADE_MAX         (7)
#define FAMILY_FLEET_ACCESS_MAX    (5)
#define FAMILY_RANK_LEADER         (5)
#define FAMILY_RANK_MAX_MEMBER     (4)
#define FAMILY_RANK_SLOTS          (5)
#define FAMILY_CREATE_COST         (3000000)
#define FAMILY_GUI_TOKENS_DEFAULT  (0)

enum E_FAM_GUI_QUEST
{
	FAM_QID,
	FAM_QMONEY,
	FAM_QREP,
	FAM_QTOKEN,
	FAM_QTITLE[48],
	FAM_QDESC[96]
}

enum E_FAM_GUI_SHOP
{
	FAM_SID,
	FAM_SFX,
	FAM_SFXV,
	FAM_SPRICE,
	FAM_STITLE[48]
}

static const g_FamGuiQuests[][E_FAM_GUI_QUEST] =
{
	{1, 10000, 10, 1, "Сборщик", "Выполните ежедневную цель семьи"},
	{2, 12000, 12, 1, "Детектив", "Помогите семье в активной игре"},
	{3, 14000, 14, 1, "Охотник", "Завершите боевое задание семьи"},
	{4, 16000, 16, 1, "Солдат", "Участвуйте в семейном событии"},
	{5, 18000, 18, 2, "Поддержка", "Помогите участникам семьи сегодня"},
	{6, 20000, 20, 2, "Лёгкая прибыль", "Любая прибыльная активность семьи"}
};

static const g_FamGuiShop[][E_FAM_GUI_SHOP] =
{
	{1, 2, 250, 2, "Репутация +250"},
	{2, 3, 25000, 2, "Казна семьи +25 000"},
	{3, 4, 20, 3, "Семейные жетоны +20"},
	{4, 1, 1, 5, "Статус: Синдикат"}
};

#if !defined NOTIFY_TYPE_TEXT_RED
	#define NOTIFY_TYPE_TEXT_RED   (2)
#endif
#if !defined COLOR_VIP_CHAT
	#define COLOR_VIP_CHAT         (0xFFFF99FF)
#endif

#define DIALOG_FAMILY_MAIN         (19351)
#define DIALOG_FAMILY_SUMMARY      (19352)
#define DIALOG_FAMILY_FLEET        (19353)
#define DIALOG_FAMILY_FLEET_ACT    (19354)
#define DIALOG_FAMILY_UPGRADE      (19355)
#define DIALOG_FAMILY_LEAVE        (19356)
#define DIALOG_FAMILY_FLEET_EMPTY  (19357)
#define DIALOG_FAMILY_UPGRADE_DENY (19358)
#define FAMILY_DLG_FLEET_MAX       (24)

/* Диалоги семьи (доп. меню) */
#define DIALOG_FAM_LAIR_ADS        (19359)
#define DIALOG_FAM_LAIR_SKLAD      (19360)
#define DIALOG_FAM_LAIR_SKRES      (19361)
#define DIALOG_FAM_LAIR_SKAMT      (19362)
#define DIALOG_FAM_LAIR_MGMT       (19363)
#define DIALOG_FAM_LAIR_MGMTIN     (19364)
#define DIALOG_FAM_LAIR_SET        (19365)
#define DIALOG_FAM_LAIR_RAT        (19366)
#define DIALOG_FAM_LAIR_LOG        (19367)
#define DIALOG_FAM_AD_MENU         (19370)
#define DIALOG_FAM_AD_LIST         (19371)
#define DIALOG_FAM_AD_INPUT        (19372)
#define DIALOG_FAM_RAT_LIST        (19373)
#define DIALOG_FAM_LOG_LIST        (19374)
#define DIALOG_FAM_SET_COLOR       (19375)
#define DIALOG_FAM_MGMT_RANK       (19376)
#define DIALOG_FAM_RANK_NAME_LIST  (19377)
#define DIALOG_FAM_RANK_NAME_INP   (19378)
#define DIALOG_FAM_RANK_ACC_PICK   (19379)
#define DIALOG_FAM_RANK_ACC_EDIT   (19380)
#define DIALOG_FAM_FLEET_RANK      (19381)

#define FAM_COLOR_TAG "{D9FF00}"
#define FAM_COLOR_GOOD "{1EFF00}"
#define FAM_COLOR_BAD  "{FF0000}"

/* Лимиты склада по уровням — как в mod laird/include/system/family.pwn */
static FamilyCountMoneyLevel[7]     = {500000, 1000000, 2000000, 4000000, 8000000, 16000000, 20000000};
static FamilyCountMaterialLevel[7]  = {5000, 10000, 50000, 100000, 200000, 500000, 1000000};
static FamilyCountMaskLevel[7]      = {100, 250, 400, 500, 600, 700, 1000};
static FamilyCountArmourLevel[7]    = {150, 300, 500, 700, 900, 1000, 1500};
static FamilyCountPatronLevel[7]    = {100000, 200000, 300000, 500000, 600000, 800000, 10000000};

/* --- mod laird: кэш семей в памяти (таблица `family`, игроки — `players`) --- */
#define MAX_FAM_LAIRD (300)

enum E_FAM_LAIRD
{
	FAM_DB_ID,
	FAM_OWNER,
	FAM_COLOR,
	FAM_REP,
	FAM_SLOT_VEH,
	FAM_COUNT_VEH,
	FAM_COUNT_PEOPLE,
	FAM_STORAGE_OPEN,
	FAM_MONEY,
	FAM_ARMOUR,
	FAM_MATERIAL,
	FAM_HEATH_KIT,
	FAM_PATRON,
	FAM_LVL_STORE,
	FAM_LVL_WEAPON,
	FAM_LVL_COMPOUND,
	FAM_HOUSE,
	FAM_NAME[FAMILY_NAME_CAP]
};

static bool:FamLairdSlotUsed[MAX_FAM_LAIRD];
static FamLairdData[MAX_FAM_LAIRD][E_FAM_LAIRD];
static FamLairdRankName[MAX_FAM_LAIRD][5][24];
static FamLairdRankAcc[MAX_FAM_LAIRD][5][5];

forward Family_TimerLoadAll();
forward Family_OnPlayerAccountLoad(playerid);
forward SpawnLoc_OpenAfterAuth(playerid);
forward SpawnLoc_RefreshGuiPayload(playerid);

static stock FamLaird_FindFreeSlot()
{
	for(new i = 0; i < MAX_FAM_LAIRD; i++)
		if(!FamLairdSlotUsed[i]) return i;
	return -1;
}

static stock FamLaird_FindSlotByDbId(dbid)
{
	if(dbid <= 0) return -1;
	for(new i = 0; i < MAX_FAM_LAIRD; i++)
	{
		if(!FamLairdSlotUsed[i]) continue;
		if(FamLairdData[i][FAM_DB_ID] == dbid) return i;
	}
	return -1;
}

static stock FamLaird_ParseRankRow(const src[], slot, rnk)
{
	new name[16], a1, a2, a3, a4, a5;
	if(sscanf(src, "p<,>s[24]ddddd", name, a1, a2, a3, a4, a5) < 6)
	{
		format(FamLairdRankName[slot][rnk], 24, "Ранг %d", rnk + 1);
		for(new k = 0; k < 5; k++) FamLairdRankAcc[slot][rnk][k] = 0;
		return 1;
	}
	format(FamLairdRankName[slot][rnk], 24, "%s", name);
	FamLairdRankAcc[slot][rnk][0] = a1;
	FamLairdRankAcc[slot][rnk][1] = a2;
	FamLairdRankAcc[slot][rnk][2] = a3;
	FamLairdRankAcc[slot][rnk][3] = a4;
	FamLairdRankAcc[slot][rnk][4] = a5;
	return 1;
}

static stock FamLaird_ApplyRowToSlot(slot, row)
{
	FamLairdSlotUsed[slot] = true;
	FamLairdData[slot][FAM_DB_ID] = cache_get_field_content_int(row, "id", db_handle);
	FamLairdData[slot][FAM_OWNER] = cache_get_field_content_int(row, "owner", db_handle);
	FamLairdData[slot][FAM_COLOR] = cache_get_field_content_int(row, "color", db_handle);
	FamLairdData[slot][FAM_REP] = cache_get_field_content_int(row, "reputation", db_handle);
	FamLairdData[slot][FAM_SLOT_VEH] = cache_get_field_content_int(row, "slot_veh", db_handle);
	if(FamLairdData[slot][FAM_SLOT_VEH] < 5) FamLairdData[slot][FAM_SLOT_VEH] = 5;
	FamLairdData[slot][FAM_MONEY] = cache_get_field_content_int(row, "money", db_handle);
	FamLairdData[slot][FAM_ARMOUR] = cache_get_field_content_int(row, "armour", db_handle);
	FamLairdData[slot][FAM_MATERIAL] = cache_get_field_content_int(row, "material", db_handle);
	FamLairdData[slot][FAM_HEATH_KIT] = cache_get_field_content_int(row, "heath_kit", db_handle);
	FamLairdData[slot][FAM_PATRON] = cache_get_field_content_int(row, "patron", db_handle);
	FamLairdData[slot][FAM_LVL_STORE] = cache_get_field_content_int(row, "level_storage", db_handle);
	FamLairdData[slot][FAM_LVL_WEAPON] = cache_get_field_content_int(row, "level_weapon", db_handle);
	FamLairdData[slot][FAM_LVL_COMPOUND] = cache_get_field_content_int(row, "level_compound", db_handle);
	FamLairdData[slot][FAM_HOUSE] = cache_get_field_content_int(row, "house", db_handle);
	FamLairdData[slot][FAM_STORAGE_OPEN] = 1;
	new fname[FAMILY_NAME_CAP];
	cache_get_field_content(row, "name", fname, db_handle, sizeof fname);
	format(FamLairdData[slot][FAM_NAME], FAMILY_NAME_CAP, "%s", fname);
	new rbuf[40];
	cache_get_field_content(row, "rang_1", rbuf, db_handle, sizeof rbuf);
	FamLaird_ParseRankRow(rbuf, slot, 0);
	cache_get_field_content(row, "rang_2", rbuf, db_handle, sizeof rbuf);
	FamLaird_ParseRankRow(rbuf, slot, 1);
	cache_get_field_content(row, "rang_3", rbuf, db_handle, sizeof rbuf);
	FamLaird_ParseRankRow(rbuf, slot, 2);
	cache_get_field_content(row, "rang_4", rbuf, db_handle, sizeof rbuf);
	FamLaird_ParseRankRow(rbuf, slot, 3);
	cache_get_field_content(row, "rang_5", rbuf, db_handle, sizeof rbuf);
	FamLaird_ParseRankRow(rbuf, slot, 4);
	return 1;
}

static stock FamLaird_SyncPlayerPvars(playerid, slot)
{
	if(slot < 0 || !FamLairdSlotUsed[slot]) return 0;
	Player[playerid][pFamilyId] = FamLairdData[slot][FAM_DB_ID];
	format(Player[playerid][pFamilyName], FAMILY_NAME_CAP, "%s", FamLairdData[slot][FAM_NAME]);
	SetPVarInt(playerid, "fam_slot", slot);
	SetPVarInt(playerid, "fam_rep", FamLairdData[slot][FAM_REP]);
	SetPVarInt(playerid, "fam_money", FamLairdData[slot][FAM_MONEY]);
	SetPVarInt(playerid, "fam_mat", FamLairdData[slot][FAM_MATERIAL]);
	SetPVarInt(playerid, "fam_masks", FamLairdData[slot][FAM_HEATH_KIT]);
	SetPVarInt(playerid, "fam_fuel", 0);
	SetPVarInt(playerid, "fam_armor", FamLairdData[slot][FAM_ARMOUR]);
	SetPVarInt(playerid, "fam_ammo", FamLairdData[slot][FAM_PATRON]);
	SetPVarInt(playerid, "fam_lvl_store", FamLairdData[slot][FAM_LVL_STORE]);
	SetPVarInt(playerid, "fam_lvl_weapons", FamLairdData[slot][FAM_LVL_WEAPON]);
	SetPVarInt(playerid, "fam_lvl_members", FamLairdData[slot][FAM_LVL_COMPOUND]);
	SetPVarInt(playerid, "fam_mc", FamLairdData[slot][FAM_COUNT_PEOPLE]);
	if(FamLairdData[slot][FAM_COUNT_PEOPLE] < 1) SetPVarInt(playerid, "fam_mc", 1);
	SetPVarInt(playerid, "fam_storage_open", FamLairdData[slot][FAM_STORAGE_OPEN]);
	SetPVarInt(playerid, "fam_col_idx", FamLairdData[slot][FAM_COLOR]);
	SetPVarString(playerid, "fam_rn_1", FamLairdRankName[slot][0]);
	SetPVarString(playerid, "fam_rn_2", FamLairdRankName[slot][1]);
	SetPVarString(playerid, "fam_rn_3", FamLairdRankName[slot][2]);
	SetPVarString(playerid, "fam_rn_4", FamLairdRankName[slot][3]);
	new lname[MAX_PLAYER_NAME];
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] == FamLairdData[slot][FAM_OWNER])
		{
			format(lname, sizeof lname, "%s", Player[i][pName]);
			break;
		}
	}
	if(!strlen(lname)) format(lname, sizeof lname, "Лидер");
	SetPVarString(playerid, "fam_leader_name", lname);
	return 1;
}

static stock FamLaird_PushSlotToMemory(slot)
{
	if(slot < 0 || !FamLairdSlotUsed[slot]) return 0;
	new fid = FamLairdData[slot][FAM_DB_ID];
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pFamilyId] != fid) continue;
		FamLaird_SyncPlayerPvars(i, slot);
	}
	return 1;
}

stock FamLaird_UpdateInt(sqlid, const col[], value)
{
	new q[160];
	mysql_format(db_handle, q, sizeof q, "UPDATE `family` SET `%s`=%d WHERE `id`=%d LIMIT 1", col, value, sqlid);
	mysql_tquery(db_handle, q, "", "");
	new slot = FamLaird_FindSlotByDbId(sqlid);
	if(slot != -1)
	{
		if(!strcmp(col, "money", true)) FamLairdData[slot][FAM_MONEY] = value;
		else if(!strcmp(col, "material", true)) FamLairdData[slot][FAM_MATERIAL] = value;
		else if(!strcmp(col, "armour", true)) FamLairdData[slot][FAM_ARMOUR] = value;
		else if(!strcmp(col, "heath_kit", true)) FamLairdData[slot][FAM_HEATH_KIT] = value;
		else if(!strcmp(col, "patron", true)) FamLairdData[slot][FAM_PATRON] = value;
		else if(!strcmp(col, "level_storage", true)) FamLairdData[slot][FAM_LVL_STORE] = value;
		else if(!strcmp(col, "level_weapon", true)) FamLairdData[slot][FAM_LVL_WEAPON] = value;
		else if(!strcmp(col, "level_compound", true)) FamLairdData[slot][FAM_LVL_COMPOUND] = value;
		else if(!strcmp(col, "color", true)) FamLairdData[slot][FAM_COLOR] = value;
		else if(!strcmp(col, "reputation", true)) FamLairdData[slot][FAM_REP] = value;
		FamLaird_PushSlotToMemory(slot);
	}
	return 1;
}

new FamilyDlgFleetCarDb[MAX_PLAYERS][FAMILY_DLG_FLEET_MAX];
new FamilyDlgFleetCount[MAX_PLAYERS];
new FamilyDlgSelCarDb[MAX_PLAYERS];
new g_VehFleetMinRank[MAX_VEHICLES];

forward Family_OnGuiPacket(playerid, Node:json, const raw_json[]);
forward LoadPlayerVehicles(playerid);
forward bool:Tune_ExtractJsonIntField(const src[], const key[], &dest);
forward Family_DB_DialogFleetList(playerid);
forward Family_DB_DialogFleetListBare(playerid);
forward Family_DB_OnLeaveFamily(playerid);
forward Family_DlgReopenFleet(playerid);
forward Family_DelayedOpenGui(playerid);
forward SavePlayerAccount(playerid);
forward ShowPlayerGUI(playerid, guiid, Node:json);
forward OnPacketIncomingStr(playerid, guiid, const json_str[]);
forward HidePlayerGUI(playerid, guiid, Node:json);
forward ShowNotification(playerid, type, duration, id, subId, caption[], btnCaption[]);
forward SetGPSMarker(playerid, Float:x, Float:y, Float:z);
forward GPS_Disable(playerid);
forward GPS_ShowMainMenu(playerid);
forward GPS_SetDestination(playerid, Float:x, Float:y, Float:z, icon_id = 85, interior = 0);
forward stock BroadcastPersonalVehicleVisuals(vehicleid, ownerid, slot);
forward ApplyVehicleVisualStateForAll(vehicleid, ownerid, slot);
forward QueueVehicleVisualApplyDeferred(ownerid, slot, delay_ms);

#if !defined GPS_WAYPOINT_ICON
    #define GPS_WAYPOINT_ICON (85)
#endif

stock SetGPSMarker(playerid, Float:x, Float:y, Float:z)
{
    if(!IsPlayerConnected(playerid) || playerid == INVALID_PLAYER_ID)
        return 0;
    return GPS_SetDestination(playerid, x, y, z, GPS_WAYPOINT_ICON, 0);
}

public ApplyVehicleVisualStateForAll(vehicleid, ownerid, slot)
{
    return BroadcastPersonalVehicleVisuals(vehicleid, ownerid, slot);
}

public QueueVehicleVisualApplyDeferred(ownerid, slot, delay_ms)
{
    if(ownerid < 0 || !IsPlayerConnected(ownerid)) return 0;
    if(slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    new vid = VehicleInfo[ownerid][slot][vID];
    if(vid == INVALID_VEHICLE_ID || !GetVehicleModel(vid)) return 0;
    if(delay_ms < 30) delay_ms = 30;
    SetTimerEx("Timer_ReapplyCarVisuals", delay_ms, false, "iii", vid, ownerid, slot);
    return 1;
}
forward InvalidateVehicleOwnerCache(vehicleid);
forward GetPlayerVehicleSlot(playerid, vehicleid);
forward SetVehicleParamsInit(vehicleid);
forward ResetPlayerVehicleSlot(playerid, slot);
forward LoadPlayerVehicles(playerid);
forward bool:CarSell_OnDialogResponse(playerid, dialogid, response);
forward Timer_ReapplyCarVisuals(vehicleid, ownerid, slot);
forward GetPlayerHouseSlot(playerid);
forward GetHouseSlotBySQLID(house_sql_id);
forward House_EnterInterior(playerid, houseid);
forward bool:IsHouseSlotValid(houseid);

static stock Family_Msg(playerid, color, const msg[])
{
	if(!IsPlayerConnected(playerid)) return 0;
	SendClientMessage(playerid, color, msg);
	return 1;
}

stock bool:Family_IsPlayerHouseLinkedToFamily(playerid, house_slot)
{
	if(house_slot < 0 || !IsHouseSlotValid(house_slot)) return false;
	if(Player[playerid][pFamilyId] <= 0) return false;
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot == -1) return false;
	if(FamLairdData[fslot][FAM_HOUSE] != HouseInfo[house_slot][hID]) return false;
	if(HouseInfo[house_slot][hOwnerID] != FamLairdData[fslot][FAM_OWNER]) return false;
	return true;
}

stock Family_NotifySpawnRefreshForFamily(fam_db_id)
{
	if(fam_db_id <= 0) return 0;
	for(new p = 0; p < MAX_PLAYERS; p++)
	{
		if(!IsPlayerConnected(p)) continue;
		if(Player[p][pFamilyId] != fam_db_id) continue;
		SpawnLoc_RefreshGuiPayload(p);
	}
	return 1;
}

stock Family_GetHouseSlotByPlayer(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(Player[playerid][pFamilyId] <= 0) return -1;

	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot == -1) return -1;

	new house_sql = FamLairdData[fslot][FAM_HOUSE];
	if(house_sql <= 0) return -1;

	new hs = GetHouseSlotBySQLID(house_sql);
	if(hs == -1 || !IsHouseSlotValid(hs) || HouseInfo[hs][hID] != house_sql)
	{
		Family_ClearHouseBySqlId(house_sql);
		return -1;
	}

	new leader_uid = FamLairdData[fslot][FAM_OWNER];
	if(HouseInfo[hs][hOwnerID] <= 0 || HouseInfo[hs][hOwnerID] != leader_uid)
	{
		if(FamLairdData[fslot][FAM_HOUSE] == house_sql)
		{
			FamLairdData[fslot][FAM_HOUSE] = -1;
			FamLaird_UpdateInt(FamLairdData[fslot][FAM_DB_ID], "house", -1);
			Family_NotifySpawnRefreshForFamily(FamLairdData[fslot][FAM_DB_ID]);
		}
		return -1;
	}
	return hs;
}

stock Family_ClearHouseBySqlId(house_sql_id)
{
	if(house_sql_id <= 0) return 0;
	new changed, fam_db;
	for(new i = 0; i < MAX_FAM_LAIRD; i++)
	{
		if(!FamLairdSlotUsed[i]) continue;
		if(FamLairdData[i][FAM_HOUSE] != house_sql_id) continue;
		fam_db = FamLairdData[i][FAM_DB_ID];
		FamLairdData[i][FAM_HOUSE] = -1;
		FamLaird_UpdateInt(FamLairdData[i][FAM_DB_ID], "house", -1);
		changed = 1;
	}
	if(changed && fam_db > 0)
		Family_NotifySpawnRefreshForFamily(fam_db);
	return changed;
}

// 0 = ошибка, 1 = привязан, 2 = отвязан
stock Family_ToggleFamilyHouse(playerid, house_slot)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pFamilyId] <= 0)
	{
		Family_Msg(playerid, 0xFF6666FF, "Вы не состоите в семье.");
		return 0;
	}
	if(!Player[playerid][pFamilyLeader])
	{
		Family_Msg(playerid, 0xFF6666FF, "Привязать дом к семье может только лидер.");
		return 0;
	}
	if(house_slot < 0 || !IsHouseSlotValid(house_slot))
	{
		Family_Msg(playerid, 0xFF6666FF, "Дом не найден.");
		return 0;
	}
	if(HouseInfo[house_slot][hOwnerID] != Player[playerid][pID])
	{
		Family_Msg(playerid, 0xFF6666FF, "Вы должны быть владельцем этого дома.");
		return 0;
	}

	new fam_db = Player[playerid][pFamilyId];
	new fslot = FamLaird_FindSlotByDbId(fam_db);
	if(fslot == -1) return 0;

	new house_sql = HouseInfo[house_slot][hID];
	if(house_sql <= 0) return 0;

	for(new i = 0; i < MAX_FAM_LAIRD; i++)
	{
		if(!FamLairdSlotUsed[i]) continue;
		if(FamLairdData[i][FAM_DB_ID] == fam_db) continue;
		if(FamLairdData[i][FAM_HOUSE] == house_sql)
		{
			Family_Msg(playerid, 0xFF6666FF, "Этот дом уже привязан к другой семье.");
			return 0;
		}
	}

	if(FamLairdData[fslot][FAM_HOUSE] == house_sql)
	{
		FamLairdData[fslot][FAM_HOUSE] = -1;
		FamLaird_UpdateInt(fam_db, "house", -1);
		Family_LogWrite(fam_db, Player[playerid][pID], "Дом отвязан от семьи", 9);
		Family_Msg(playerid, 0x88FF88FF, "Дом отвязан от семьи. Спавн «Дом семьи» недоступен.");
		Family_NotifySpawnRefreshForFamily(fam_db);
		return 2;
	}

	FamLairdData[fslot][FAM_HOUSE] = house_sql;
	FamLaird_UpdateInt(fam_db, "house", house_sql);
	Family_LogWrite(fam_db, Player[playerid][pID], "Дом привязан к семье (спавн для участников)", 9);
	Family_Msg(playerid, 0x88FF88FF, "Дом привязан к семье. Участники могут выбрать спавн «Дом семьи».");
	ShowNotification(playerid, 1, 5, 0, 1, "Семейный дом установлен", "");
	Family_NotifySpawnRefreshForFamily(fam_db);
	return 1;
}

static stock Family_HasCreateMoney(playerid)
{
	return (Player[playerid][pMoney] >= FAMILY_CREATE_COST);
}

static stock Family_ChargeCreateCost(playerid)
{
	if(Player[playerid][pMoney] < FAMILY_CREATE_COST)
		return 0;
	Family_PlayerMoneyApply(playerid, -FAMILY_CREATE_COST);
	ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0,
		"Вы потратили 3.000.000 рублей", "");
	return 1;
}

static stock Family_UidIsOnline(uid)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] == uid) return 1;
	}
	return 0;
}

static stock Family_RefreshOnlineMemberRank(uid, newrank)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] != uid) continue;
		Player[i][pFamilyRank] = newrank;
		return 1;
	}
	return 0;
}

static stock Family_IsValidName(const name[])
{
	new len = strlen(name);
	if(len < FAMILY_NAME_MIN_LEN || len > FAMILY_NAME_MAX_LEN) return 0;
	for(new i = 0; i < len; i++)
	{
		new c = name[i];
		if(c >= 'A' && c <= 'Z') continue;
		if(c >= 'a' && c <= 'z') continue;
		if(c >= '0' && c <= '9') continue;
		if(c == '_' || c == ' ') continue;
		return 0;
	}
	return 1;
}

static stock Family_MaxForStoreLevel(level, base_cur, base_max)
{
	if(level < 1) level = 1;
	if(level > FAMILY_UPGRADE_MAX) level = FAMILY_UPGRADE_MAX;
	return base_cur + floatround((float(base_max - base_cur) * float(level - 1)) / float(FAMILY_UPGRADE_MAX - 1));
}

stock Family_InitDatabase()
{
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `family` (\
			`id` INT NOT NULL AUTO_INCREMENT,\
			`name` VARCHAR(32) NOT NULL,\
			`color` INT NOT NULL DEFAULT 0,\
			`reputation` INT NOT NULL DEFAULT 0,\
			`owner` INT NOT NULL DEFAULT -1,\
			`slot_veh` INT NOT NULL DEFAULT 5,\
			`money` INT NOT NULL DEFAULT 0,\
			`armour` INT NOT NULL DEFAULT 0,\
			`material` INT NOT NULL DEFAULT 0,\
			`heath_kit` INT NOT NULL DEFAULT 0,\
			`patron` INT NOT NULL DEFAULT 0,\
			`level_storage` INT NOT NULL DEFAULT 1,\
			`level_weapon` INT NOT NULL DEFAULT 1,\
			`level_compound` INT NOT NULL DEFAULT 1,\
			`rang_1` VARCHAR(38) NOT NULL DEFAULT 'Rank1,1,0,0,0,1',\
			`rang_2` VARCHAR(38) NOT NULL DEFAULT 'Rank2,1,0,0,0,1',\
			`rang_3` VARCHAR(38) NOT NULL DEFAULT 'Rank3,1,0,0,0,1',\
			`rang_4` VARCHAR(38) NOT NULL DEFAULT 'Rank4,1,0,0,0,1',\
			`rang_5` VARCHAR(38) NOT NULL DEFAULT 'Rank5,1,1,1,1,1',\
			`house` INT NOT NULL DEFAULT -1,\
			PRIMARY KEY (`id`),\
			UNIQUE KEY `name` (`name`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `family_ad` (\
			`id` INT NOT NULL AUTO_INCREMENT,\
			`family` INT NOT NULL,\
			`ad_text` VARCHAR(62) NOT NULL,\
			`create_id` INT NOT NULL,\
			`create_name` VARCHAR(24) NOT NULL,\
			`time` INT NOT NULL,\
			PRIMARY KEY (`id`),\
			KEY `family_idx` (`family`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `family_cars` (\
			`id` INT NOT NULL AUTO_INCREMENT,\
			`model_id` INT NOT NULL,\
			`color_1` INT NOT NULL,\
			`color_2` INT NOT NULL,\
			`number` VARCHAR(7) NOT NULL DEFAULT '------',\
			`pos_x` FLOAT NOT NULL,\
			`pos_y` FLOAT NOT NULL,\
			`pos_z` FLOAT NOT NULL,\
			`angle` FLOAT NOT NULL,\
			`rang` INT NOT NULL DEFAULT 1,\
			`family_owner` INT NOT NULL DEFAULT -1,\
			`create_time` INT NOT NULL DEFAULT 0,\
			`ownable_id` INT NULL DEFAULT NULL,\
			PRIMARY KEY (`id`),\
			KEY `family_owner_idx` (`family_owner`),\
			UNIQUE KEY `ownable_id` (`ownable_id`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
	mysql_tquery(db_handle, "ALTER TABLE `family_cars` ADD COLUMN IF NOT EXISTS `ownable_id` INT NULL DEFAULT NULL", "", "");
	mysql_tquery(db_handle,
		"INSERT INTO `family_cars` (`family_owner`,`model_id`,`color_1`,`color_2`,`number`,`pos_x`,`pos_y`,`pos_z`,`angle`,`rang`,`create_time`,`ownable_id`)\
		 SELECT ff.`family_id`, oc.`model`, oc.`color1`, oc.`color2`,\
		 IF(CHAR_LENGTH(IFNULL(oc.`plate_number`,''))>0, LEFT(oc.`plate_number`,7), '------'),\
		 oc.`x`, oc.`y`, oc.`z`, oc.`a`, IFNULL(ff.`access_rank`,1), UNIX_TIMESTAMP(), oc.`id`\
		 FROM `family_fleet` ff INNER JOIN `ownable_cars` oc ON oc.`id` = ff.`car_db_id`\
		 LEFT JOIN `family_cars` fc ON fc.`ownable_id` = ff.`car_db_id` WHERE fc.`id` IS NULL",
		"", "");
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `family_log` (\
			`id` INT NOT NULL AUTO_INCREMENT,\
			`family` INT NOT NULL,\
			`player` INT NOT NULL DEFAULT 0,\
			`to_player` INT NOT NULL DEFAULT -1,\
			`text` VARCHAR(124) NOT NULL,\
			`time` INT NOT NULL,\
			`type` INT NOT NULL DEFAULT 0,\
			PRIMARY KEY (`id`),\
			KEY `family_idx` (`family`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `family_fleet` (\
			`id` INT NOT NULL AUTO_INCREMENT,\
			`family_id` INT NOT NULL,\
			`car_db_id` INT NOT NULL,\
			`access_rank` INT NOT NULL DEFAULT 1,\
			`added_by_uid` INT NOT NULL DEFAULT 0,\
			`original_owner_uid` INT NOT NULL DEFAULT 0,\
			PRIMARY KEY (`id`),\
			UNIQUE KEY `car_db_id` (`car_db_id`),\
			KEY `family_id` (`family_id`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
	mysql_tquery(db_handle, "ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `family_id` INT NOT NULL DEFAULT -1", "", "");
	mysql_tquery(db_handle, "ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `family_rang` INT NOT NULL DEFAULT 1", "", "");
	mysql_tquery(db_handle, "ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `family_mute` INT NOT NULL DEFAULT 0", "", "");
	mysql_tquery(db_handle, "ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `family_access` VARCHAR(24) NOT NULL DEFAULT '0,0,0,0,0,0,0'", "", "");
	SetTimer("Family_TimerLoadAll", 1500, false);
	#if defined _FAMILY_ADDITION_INC_
		FamilyAddition_OnGameModeInit();
	#endif
	return 1;
}

public Family_TimerLoadAll()
{
	mysql_tquery(db_handle, "SELECT * FROM `family` ORDER BY `id` ASC LIMIT 300", "Family_OnAllFamiliesLoaded", "");
	return 1;
}

forward Family_OnAllFamiliesLoaded();
public Family_OnAllFamiliesLoaded()
{
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	for(new i = 0; i < MAX_FAM_LAIRD; i++) FamLairdSlotUsed[i] = false;
	if(rows > MAX_FAM_LAIRD) rows = MAX_FAM_LAIRD;
	for(new r = 0; r < rows; r++)
		FamLaird_ApplyRowToSlot(r, r);
	for(new s = 0; s < rows; s++)
	{
		if(!FamLairdSlotUsed[s]) continue;
		new q[220], fid = FamLairdData[s][FAM_DB_ID];
		mysql_format(db_handle, q, sizeof q,
			"SELECT (SELECT COUNT(*) FROM `players` WHERE `family_id`=%d) AS pc,\
			GREATEST(COALESCE((SELECT COUNT(*) FROM `family_fleet` WHERE `family_id`=%d),0),\
			COALESCE((SELECT COUNT(*) FROM `family_cars` WHERE `family_owner`=%d),0)) AS vc",
			fid, fid, fid);
		mysql_tquery(db_handle, q, "Family_OnFamilyCounts", "i", s);
	}
	printf("[Family] Загружено семей в память: %d", rows);
	#if defined _FAMILY_ADDITION_INC_
	FamilyAddition_OnFamiliesLoaded();
	#endif
	return 1;
}

forward Family_OnFamilyCounts(slot);
public Family_OnFamilyCounts(slot)
{
	if(slot < 0 || slot >= MAX_FAM_LAIRD || !FamLairdSlotUsed[slot]) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		FamLairdData[slot][FAM_COUNT_PEOPLE] = cache_get_field_content_int(0, "pc", db_handle);
		FamLairdData[slot][FAM_COUNT_VEH] = cache_get_field_content_int(0, "vc", db_handle);
	}
	return 1;
}

stock Family_ResetPlayerVars(playerid)
{
	Player[playerid][pFamilyId] = 0;
	Player[playerid][pFamilyRank] = 0;
	Player[playerid][pFamilyLeader] = false;
	Player[playerid][pFamilyName][0] = '\0';
	DeletePVar(playerid, "fam_rep");
	DeletePVar(playerid, "fam_money");
	DeletePVar(playerid, "fam_mat");
	DeletePVar(playerid, "fam_masks");
	DeletePVar(playerid, "fam_fuel");
	DeletePVar(playerid, "fam_armor");
	DeletePVar(playerid, "fam_ammo");
	DeletePVar(playerid, "fam_lvl_store");
	DeletePVar(playerid, "fam_lvl_weapons");
	DeletePVar(playerid, "fam_lvl_members");
	DeletePVar(playerid, "fam_mc");
	DeletePVar(playerid, "fam_leader_name");
	DeletePVar(playerid, "fam_storage_open");
	DeletePVar(playerid, "fam_mute_left");
	DeletePVar(playerid, "fam_mgmt_kind");
	DeletePVar(playerid, "fam_sklad_tp");
	DeletePVar(playerid, "fam_sklad_res");
	DeletePVar(playerid, "fam_col_idx");
	DeletePVar(playerid, "fam_rn_1");
	DeletePVar(playerid, "fam_rn_2");
	DeletePVar(playerid, "fam_rn_3");
	DeletePVar(playerid, "fam_rn_4");
	DeletePVar(playerid, "fam_loaded");
	DeletePVar(playerid, "fam_open_after_load");
	DeletePVar(playerid, "fam_load_uid");
	DeletePVar(playerid, "fam_load_retry");
	DeletePVar(playerid, "fam_slot");
	for(new a = 0; a < 7; a++)
	{
		new key[20];
		format(key, sizeof key, "fam_acc%d", a);
		DeletePVar(playerid, key);
	}
	FamilyDlgFleetCount[playerid] = 0;
	FamilyDlgSelCarDb[playerid] = 0;
	for(new z = 0; z < FAMILY_DLG_FLEET_MAX; z++)
		FamilyDlgFleetCarDb[playerid][z] = 0;
	return 1;
}

static stock Family_ApplyAccessFromString(playerid, const access[])
{
	new acc[7];
	if(sscanf(access, "p<,>ddddddd", acc[0], acc[1], acc[2], acc[3], acc[4], acc[5], acc[6]) < 7)
	{
		for(new i = 0; i < 7; i++) acc[i] = 0;
	}
	for(new i = 0; i < 7; i++)
	{
		new key[16];
		format(key, sizeof key, "fam_acc%d", i);
		SetPVarInt(playerid, key, acc[i]);
	}
	return 1;
}

static stock Family_FinishPlayerLoad(playerid)
{
	SetPVarInt(playerid, "fam_loaded", 1);

	if(GetPVarInt(playerid, "spawn_wait_fam"))
	{
		DeletePVar(playerid, "spawn_wait_fam");
		SpawnLoc_OpenAfterAuth(playerid);
	}
	else if(GetPVarInt(playerid, "spawn_gui_active"))
		SpawnLoc_RefreshGuiPayload(playerid);

	if(GetPVarInt(playerid, "fam_open_after_load"))
	{
		DeletePVar(playerid, "fam_open_after_load");
		if(Player[playerid][pFamilyId] > 0)
			SetTimerEx("Family_DelayedOpenGui", 100, false, "i", playerid);
		else
			Family_Msg(playerid, 0xCECECEFF, "Вы не состоите в семье. Создайте её: /createfm");
	}
	return 1;
}

forward Family_OnPlayerAccountLoad(playerid);
public Family_OnPlayerAccountLoad(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	Player[playerid][pFamilyId] = 0;
	Player[playerid][pFamilyRank] = 0;
	Player[playerid][pFamilyLeader] = false;
	Player[playerid][pFamilyName][0] = '\0';

	if(rows < 1)
		return Family_FinishPlayerLoad(playerid), 1;

	new fid = cache_get_field_content_int(0, "family_id", db_handle);
	if(fid <= 0)
		return Family_FinishPlayerLoad(playerid), 1;

	new slot = FamLaird_FindSlotByDbId(fid);
	if(slot == -1)
	{
		SetPVarInt(playerid, "fam_pending_fid", fid);
		new q[96];
		mysql_format(db_handle, q, sizeof q, "SELECT * FROM `family` WHERE `id`=%d LIMIT 1", fid);
		mysql_tquery(db_handle, q, "Family_OnSingleFamilyRow", "i", playerid);
		return 1;
	}

	Player[playerid][pFamilyRank] = cache_get_field_content_int(0, "family_rang", db_handle);
	if(Player[playerid][pFamilyRank] < 1) Player[playerid][pFamilyRank] = 1;
	Player[playerid][pFamilyLeader] = (Player[playerid][pFamilyRank] >= FAMILY_RANK_LEADER || FamLairdData[slot][FAM_OWNER] == Player[playerid][pID]);
	new muteleft = cache_get_field_content_int(0, "family_mute", db_handle);
	if(muteleft < 0) muteleft = 0;
	SetPVarInt(playerid, "fam_mute_left", muteleft);
	new access[28];
	cache_get_field_content(0, "family_access", access, db_handle, sizeof access);
	Family_ApplyAccessFromString(playerid, access);
	FamLaird_SyncPlayerPvars(playerid, slot);
	if(Player[playerid][pFamilyLeader])
		Family_ApplyLeaderAccessPvars(playerid);
	else if(Player[playerid][pFamilyRank] >= 1 && Player[playerid][pFamilyRank] <= FAMILY_RANK_MAX_MEMBER)
		Family_SyncPlayerRankAccess(playerid, slot, Player[playerid][pFamilyRank]);
	return Family_FinishPlayerLoad(playerid), 1;
}

forward Family_OnSingleFamilyRow(playerid);
public Family_OnSingleFamilyRow(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows < 1)
	{
		DeletePVar(playerid, "fam_pending_fid");
		if(Player[playerid][pID] > 0)
		{
			new q[128];
			mysql_format(db_handle, q, sizeof q,
				"UPDATE `players` SET `family_id`=-1,`family_rang`=1 WHERE `id`=%d LIMIT 1",
				Player[playerid][pID]);
			mysql_tquery(db_handle, q, "", "");
		}
		Family_Msg(playerid, 0xFF6666FF, "Семья не найдена в базе. Создайте новую: /createfm");
		return Family_FinishPlayerLoad(playerid), 1;
	}
	new slot = FamLaird_FindFreeSlot();
	if(slot == -1) slot = 0;
	FamLaird_ApplyRowToSlot(slot, 0);
	Family_DB_LoadMember(playerid);
	return 1;
}

static stock Family_ParseAccessString(acc[])
{
	if(acc[0] == '\0')
	{
		format(acc, 48, "0,0,0,0,0,0,0");
		return 1;
	}
	return 1;
}

static stock Family_ParseAccessGet(const acc[], idx)
{
	if(idx < 0 || idx > 6) return 0;
	new start = 0, slot = 0, i, len = strlen(acc);
	for(i = 0; i <= len; i++)
	{
		if(i == len || acc[i] == ',')
		{
			new frag[16], fl = i - start, j;
			if(fl >= sizeof frag) fl = sizeof frag - 1;
			for(j = 0; j < fl; j++) frag[j] = acc[start + j];
			frag[fl] = '\0';
			if(slot == idx) return strval(frag);
			slot++;
			start = i + 1;
		}
	}
	return 0;
}

/* Как /v — цвет всей строки через SendClientMessage (без {FFFFFF} в тексте) */
static stock Family_ColorIdxToMsgColor(idx)
{
	switch(idx)
	{
		case 0: return 0xFFFFFFFF;
		case 1: return 0xC3C3C3FF;
		case 2: return COLOR_VIP_CHAT;
		case 3: return 0xF81414FF;
		case 4: return 0x00FFEEFF;
		case 5: return 0xFF00EAFF;
		case 6: return 0xF3FF02FF;
		case 7: return 0xC9FFABFF;
		case 8: return 0xFFF1AFFF;
		case 9: return 0xFFAF00FF;
		case 10: return 0x0049FFFF;
		case 11: return 0xAFE7FFFF;
	}
	return COLOR_VIP_CHAT;
}

static stock Family_GetFamilyColorIdx(fid)
{
	if(fid <= 0) return 0;
	new slot = FamLaird_FindSlotByDbId(fid);
	if(slot == -1) return 0;
	return FamLairdData[slot][FAM_COLOR];
}

static stock Family_GetFamilyMsgColor(fid)
{
	return Family_ColorIdxToMsgColor(Family_GetFamilyColorIdx(fid));
}

static stock Family_FormatFamilyBroadcast(fid, const body[], dest[], len)
{
	#pragma unused fid
	format(dest, len, "[Семья] %s", body);
}

static stock Family_SyncPlayerRankAccess(playerid, slot, rank)
{
	if(slot < 0 || !FamLairdSlotUsed[slot]) return 0;
	if(rank < 1 || rank > FAMILY_RANK_MAX_MEMBER) return 0;
	new ridx = rank - 1;
	if(Player[playerid][pFamilyLeader]) return Family_ApplyLeaderAccessPvars(playerid);
	new v;
	v = FamLairdRankAcc[slot][ridx][0];
	SetPVarInt(playerid, "fam_acc0", v ? 1 : 0);
	v = FamLairdRankAcc[slot][ridx][1];
	SetPVarInt(playerid, "fam_acc1", v ? 999999999 : 0);
	v = FamLairdRankAcc[slot][ridx][2];
	SetPVarInt(playerid, "fam_acc2", v ? 1 : 0);
	SetPVarInt(playerid, "fam_acc_money_in", v ? 1 : 0);
	v = FamLairdRankAcc[slot][ridx][3];
	SetPVarInt(playerid, "fam_acc3", v ? 1 : 0);
	v = FamLairdRankAcc[slot][ridx][4];
	SetPVarInt(playerid, "fam_acc4", v ? 1 : 0);
	SetPVarInt(playerid, "fam_acc5", 0);
	SetPVarInt(playerid, "fam_acc6", 0);
	return 1;
}

static stock Family_ApplyRankAccessToOnline(fid, rank)
{
	if(fid <= 0) return 0;
	new slot = FamLaird_FindSlotByDbId(fid);
	if(slot == -1) return 0;
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pFamilyId] != fid) continue;
		if(Player[i][pFamilyRank] != rank) continue;
		Family_SyncPlayerRankAccess(i, slot, rank);
	}
	return 1;
}

static stock Family_LoadRankAccEditFromCache(playerid, rank)
{
	if(rank < 1 || rank > 4) return 0;
	SetPVarInt(playerid, "fam_acc_edit_rank", rank);
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot == -1)
	{
		for(new k = 0; k < 8; k++)
		{
			new key[12];
			format(key, sizeof key, "fam_ra%d", k);
			SetPVarInt(playerid, key, 0);
		}
	}
	else
	{
		new ridx = rank - 1;
		SetPVarInt(playerid, "fam_ra0", FamLairdRankAcc[fslot][ridx][0] ? 1 : 0);
		SetPVarInt(playerid, "fam_ra1", FamLairdRankAcc[fslot][ridx][1] ? 1 : 0);
		SetPVarInt(playerid, "fam_ra2", FamLairdRankAcc[fslot][ridx][2] ? 1 : 0);
		SetPVarInt(playerid, "fam_ra3", FamLairdRankAcc[fslot][ridx][3] ? 1 : 0);
		SetPVarInt(playerid, "fam_ra4", FamLairdRankAcc[fslot][ridx][4] ? 1 : 0);
		SetPVarInt(playerid, "fam_ra5", 0);
		SetPVarInt(playerid, "fam_ra6", 0);
		SetPVarInt(playerid, "fam_ra7", FamLairdRankAcc[fslot][ridx][4] ? 1 : 0);
	}
	return Family_ShowRankAccEditDialog(playerid);
}

static stock Family_SaveRankAccToCache(playerid, rank)
{
	if(rank < 1 || rank > 4) return 0;
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot == -1) return 0;
	new ridx = rank - 1;
	FamLairdRankAcc[fslot][ridx][0] = GetPVarInt(playerid, "fam_ra0") ? 1 : 0;
	FamLairdRankAcc[fslot][ridx][1] = GetPVarInt(playerid, "fam_ra1") ? 1 : 0;
	FamLairdRankAcc[fslot][ridx][2] = GetPVarInt(playerid, "fam_ra2") ? 1 : 0;
	FamLairdRankAcc[fslot][ridx][3] = GetPVarInt(playerid, "fam_ra3") ? 1 : 0;
	FamLairdRankAcc[fslot][ridx][4] = GetPVarInt(playerid, "fam_ra7") ? 1 : 0;
	new rowstr[48], col[8], qn[320];
	format(rowstr, sizeof rowstr, "%s,%d,%d,%d,%d,%d",
		FamLairdRankName[fslot][ridx],
		FamLairdRankAcc[fslot][ridx][0],
		FamLairdRankAcc[fslot][ridx][1],
		FamLairdRankAcc[fslot][ridx][2],
		FamLairdRankAcc[fslot][ridx][3],
		FamLairdRankAcc[fslot][ridx][4]);
	format(col, sizeof col, "rang_%d", rank);
	mysql_format(db_handle, qn, sizeof(qn),
		"UPDATE `family` SET `%s`='%e' WHERE `id`=%d AND `owner`=%d LIMIT 1",
		col, rowstr, Player[playerid][pFamilyId], Player[playerid][pID]);
	mysql_tquery(db_handle, qn, "", "");
	Family_ApplyRankAccessToOnline(Player[playerid][pFamilyId], rank);
	return 1;
}

static stock Family_IsPlateTextEmpty(const txt[])
{
	if(!strlen(txt)) return 1;
	if(!strcmp(txt, "NULL", true)) return 1;
	if(!strcmp(txt, "null", true)) return 1;
	if(!strcmp(txt, "------", true)) return 1;
	if(!strcmp(txt, "---", true)) return 1;
	return 0;
}

static stock Family_FormatPlateFromRow(rowidx, dest[], len)
{
	new pnum[16], preg[8], plegacy[16];
	cache_get_field_content(rowidx, "plate_number", pnum, db_handle, 12);
	cache_get_field_content(rowidx, "plate_region", preg, db_handle, 8);
	cache_get_field_content(rowidx, "number", plegacy, db_handle, 12);
	if(!Family_IsPlateTextEmpty(pnum))
	{
		if(!Family_IsPlateTextEmpty(preg)) format(dest, len, "%s %s", pnum, preg);
		else format(dest, len, "%s", pnum);
		return 1;
	}
	if(!Family_IsPlateTextEmpty(plegacy))
	{
		format(dest, len, "%s", plegacy);
		return 1;
	}
	format(dest, len, "---");
	return 1;
}

static stock Family_FleetNotifyDenied(playerid)
{
	ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0,
		"Вам недоступно это функция", "");
	Family_Msg(playerid, 0xFF0000FF, "Вам недоступно это функция.");
	return 1;
}

static stock Family_FleetSaveAccessRank(playerid, car_db_id, new_rank)
{
	if(car_db_id <= 0 || new_rank < 1) return 0;
	if(new_rank > FAMILY_FLEET_ACCESS_MAX) new_rank = FAMILY_FLEET_ACCESS_MAX;
	new q[200];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `family_fleet` SET `access_rank`=%d WHERE `car_db_id`=%d AND `family_id`=%d LIMIT 1",
		new_rank, car_db_id, Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "", "");
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `family_cars` SET `rang`=%d WHERE `ownable_id`=%d AND `family_owner`=%d LIMIT 1",
		new_rank, car_db_id, Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "", "");
	new msg[96];
	format(msg, sizeof msg, "Минимальный ранг для авто изменён на %d.", new_rank);
	Family_Msg(playerid, 0x88FF88FF, msg);
	ShowNotification(playerid, 1, 5, 0, 1, msg, "");
	return 1;
}

stock Family_DialogShowFleetRankPick(playerid, car_db_id)
{
	if(car_db_id <= 0) return 0;
	FamilyDlgSelCarDb[playerid] = car_db_id;
	new list[] =
		"Ранг 1 — любой участник\n"\
		"Ранг 2\n"\
		"Ранг 3\n"\
		"Ранг 4\n"\
		"Ранг 5 — только лидер\n"\
		"Назад к действиям";
	ShowPlayerDialog(playerid, DIALOG_FAM_FLEET_RANK, DIALOG_STYLE_LIST,
		"{E0584B}Изменить ранг доступа", list, "Выбрать", "Назад");
	return 1;
}

static stock Family_DialogFleetPresentList(playerid, rows)
{
	if(rows <= 0)
	{
		ShowPlayerDialog(playerid, DIALOG_FAMILY_FLEET_EMPTY, DIALOG_STYLE_MSGBOX,
			"{E0584B}Семейный автопарк",
			"{FFFFFF}В семейном автопарке пока нет транспорта.\n\nДобавьте машину через {E0584B}/car{FFFFFF} — «Добавить в семью».",
			"Назад", "Закрыть");
		return 1;
	}
	new nshow = rows;
	if(nshow > FAMILY_DLG_FLEET_MAX) nshow = FAMILY_DLG_FLEET_MAX;
	new big[4096];
	format(big, sizeof big, "Автомобиль\tНомер\tРанг\n");
	for(new i = 0; i < nshow; i++)
	{
		new cid = cache_get_field_content_int(i, "car_db_id", db_handle);
		new mid = cache_get_field_content_int(i, "model", db_handle);
		new needr = cache_get_field_content_int(i, "access_rank", db_handle);
		if(needr < 1) needr = 1;
		if(needr > FAMILY_FLEET_ACCESS_MAX) needr = FAMILY_FLEET_ACCESS_MAX;
		FamilyDlgFleetCarDb[playerid][i] = cid;
		new vname[56];
		if(mid > 0) format(vname, sizeof vname, "%s", GetVehicleNameByModel(mid));
		else format(vname, sizeof vname, "Авто #%d", cid);
		new plate[32];
		Family_FormatPlateFromRow(i, plate, sizeof plate);
		new line[160];
		format(line, sizeof line, "%s\t%s\t%d\n", vname, plate, needr);
		strcat(big, line, sizeof big);
	}
	FamilyDlgFleetCount[playerid] = nshow;
	ShowPlayerDialog(playerid, DIALOG_FAMILY_FLEET, DIALOG_STYLE_TABLIST_HEADERS,
		"{E0584B}Семейный автопарк", big, "Выбрать", "Назад");
	if(rows > FAMILY_DLG_FLEET_MAX)
		Family_Msg(playerid, 0xCECECEFF, "Показаны не все машины (лимит списка).");
	return 1;
}

stock Family_PlayerCanAccessFleetTrunk(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return false;
	if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return false;
	new need = g_VehFleetMinRank[vehicleid];
	if(need < 1) return true;
	if(Player[playerid][pFamilyLeader]) return true;
	if(Player[playerid][pFamilyRank] >= need) return true;
	return false;
}

stock bool:Family_TryFamilyTrunkAccess(playerid, vehicleid, owner, slot)
{
	if(Player[playerid][pFamilyId] <= 0 || Player[playerid][pFamilyId] != Player[owner][pFamilyId])
		return false;
	if(!VehicleInfo[owner][slot][vFamFleetBorrow])
	{
		if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || g_VehFleetMinRank[vehicleid] <= 0)
			return false;
	}
	if(!Family_PlayerCanAccessFleetTrunk(playerid, vehicleid))
		return false;
	return true;
}

stock Family_ClearVehicleFleetAccessRank(vehicleid)
{
	if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
		g_VehFleetMinRank[vehicleid] = 0;
}

static stock Family_SetVehicleFleetAccessRank(vehicleid, rank)
{
	if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
	if(rank < 1) rank = 1;
	if(rank > FAMILY_FLEET_ACCESS_MAX) rank = FAMILY_FLEET_ACCESS_MAX;
	g_VehFleetMinRank[vehicleid] = rank;
	return 1;
}

static stock Family_ApplyLeaderAccessPvars(playerid)
{
	SetPVarInt(playerid, "fam_acc0", 1);
	SetPVarInt(playerid, "fam_acc1", 999999999);
	SetPVarInt(playerid, "fam_acc2", 1);
	SetPVarInt(playerid, "fam_acc3", 1);
	SetPVarInt(playerid, "fam_acc4", 1);
	SetPVarInt(playerid, "fam_acc5", 1);
	SetPVarInt(playerid, "fam_acc6", 1);
	SetPVarInt(playerid, "fam_acc_money_in", 1);
	return 1;
}

static stock Fam_ApplyRankStoreRow(playerid)
{
	new ai = cache_get_field_content_int(0, "fra_inv", db_handle);
	new mo = cache_get_field_content_int(0, "fra_mo", db_handle);
	new mi = cache_get_field_content_int(0, "fra_mi", db_handle);
	new ar = cache_get_field_content_int(0, "fra_ar", db_handle);
	new ma = cache_get_field_content_int(0, "fra_ma", db_handle);
	new fu = cache_get_field_content_int(0, "fra_fu", db_handle);
	new am = cache_get_field_content_int(0, "fra_am", db_handle);
	new mk = cache_get_field_content_int(0, "fra_mk", db_handle);
	SetPVarInt(playerid, "fam_acc0", ai ? 1 : 0);
	SetPVarInt(playerid, "fam_acc1", mo ? 999999999 : 0);
	SetPVarInt(playerid, "fam_acc2", ar ? 1 : 0);
	SetPVarInt(playerid, "fam_acc3", ma ? 1 : 0);
	SetPVarInt(playerid, "fam_acc4", fu ? 1 : 0);
	SetPVarInt(playerid, "fam_acc5", am ? 1 : 0);
	SetPVarInt(playerid, "fam_acc6", mk ? 1 : 0);
	SetPVarInt(playerid, "fam_acc_money_in", mi ? 1 : 0);
	return 1;
}

static stock Family_FormatAccessFromPVars(playerid, buf[], len)
{
	format(buf, len, "%d,%d,%d,%d,%d,%d,%d",
		GetPVarInt(playerid, "fam_acc0"), GetPVarInt(playerid, "fam_acc1"), GetPVarInt(playerid, "fam_acc2"),
		GetPVarInt(playerid, "fam_acc3"), GetPVarInt(playerid, "fam_acc4"), GetPVarInt(playerid, "fam_acc5"),
		GetPVarInt(playerid, "fam_acc6"));
}

stock Family_PersistMemberRow(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] == 0 || Player[playerid][pFamilyId] == 0) return 0;
	new q[160];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `players` SET `family_mute`=%d WHERE `id`=%d LIMIT 1",
		GetPVarInt(playerid, "fam_mute_left"), Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Family_MuteSecondTick()
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pFamilyId] == 0) continue;
		new m = GetPVarInt(i, "fam_mute_left");
		if(m <= 0) continue;
		m--;
		SetPVarInt(i, "fam_mute_left", m);
		if(m == 0)
			Family_Msg(i, -1, ""FAM_COLOR_BAD"[Семья]{FFFFFF} Мут семейного чата снят.");
	}
	return 1;
}

stock Family_SendFamilyMessage(fid, const msg[])
{
	new col = Family_GetFamilyMsgColor(fid);
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pFamilyId] != fid) continue;
		SendClientMessage(i, col, msg);
	}
	return 1;
}

/* API для family_addition.inc (захваты laird) */
stock FamilyCapt_FindSlotByDbId(dbid)
{
	return FamLaird_FindSlotByDbId(dbid);
}

stock FamilyCapt_GetPlayerSlot(playerid)
{
	if(!IsPlayerConnected(playerid) || Player[playerid][pFamilyId] <= 0) return -1;
	new slot = GetPVarInt(playerid, "fam_slot");
	if(slot >= 0 && slot < MAX_FAM_LAIRD && FamLairdSlotUsed[slot]) return slot;
	slot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	return slot;
}

stock FamilyCapt_IsSlotUsed(slot)
{
	return (slot >= 0 && slot < MAX_FAM_LAIRD && FamLairdSlotUsed[slot]);
}

stock FamilyCapt_GetSlotDbId(slot)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return -1;
	return FamLairdData[slot][FAM_DB_ID];
}

stock FamilyCapt_GetSlotName(slot, dest[], size)
{
	if(!FamilyCapt_IsSlotUsed(slot)) { dest[0] = '\0'; return 0; }
	format(dest, size, "%s", FamLairdData[slot][FAM_NAME]);
	return 1;
}

stock FamilyCapt_SendSlotMessage(slot, const msg[])
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	return Family_SendFamilyMessage(FamLairdData[slot][FAM_DB_ID], msg);
}

stock FamilyCapt_BroadcastAllSlots(const msg[])
{
	for(new i = 0; i < MAX_FAM_LAIRD; i++)
	{
		if(!FamLairdSlotUsed[i]) continue;
		Family_SendFamilyMessage(FamLairdData[i][FAM_DB_ID], msg);
	}
	return 1;
}

stock FamilyCapt_GetReputation(slot)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	return FamLairdData[slot][FAM_REP];
}

stock FamilyCapt_GetMoney(slot)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	return FamLairdData[slot][FAM_MONEY];
}

stock FamilyCapt_SetReputation(slot, value)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	FamLairdData[slot][FAM_REP] = value;
	FamLaird_UpdateInt(FamLairdData[slot][FAM_DB_ID], "reputation", value);
	return 1;
}

stock FamilyCapt_AddReputation(slot, delta)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	new v = FamLairdData[slot][FAM_REP] + delta;
	if(v < 0) v = 0;
	return FamilyCapt_SetReputation(slot, v);
}

stock FamilyCapt_AddMoney(slot, delta)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	new v = FamLairdData[slot][FAM_MONEY] + delta;
	if(v < 0) v = 0;
	FamLairdData[slot][FAM_MONEY] = v;
	FamLaird_UpdateInt(FamLairdData[slot][FAM_DB_ID], "money", v);
	return 1;
}

stock FamilyCapt_AddSlotVeh(slot, delta)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 0;
	new v = FamLairdData[slot][FAM_SLOT_VEH] + delta;
	if(v < 5) v = 5;
	FamLairdData[slot][FAM_SLOT_VEH] = v;
	FamLaird_UpdateInt(FamLairdData[slot][FAM_DB_ID], "slot_veh", v);
	return v;
}

stock Family_GetMaxFleetSlots(fslot)
{
	if(fslot < 0 || fslot >= MAX_FAM_LAIRD || !FamLairdSlotUsed[fslot]) return 5;
	new lim = FamLairdData[fslot][FAM_SLOT_VEH];
	return (lim < 5) ? 5 : lim;
}

stock Family_GetFleetUsedCount(fslot)
{
	if(fslot < 0 || fslot >= MAX_FAM_LAIRD || !FamLairdSlotUsed[fslot]) return 0;
	return FamLairdData[fslot][FAM_COUNT_VEH];
}

stock Family_FleetAdjustUsedCount(fslot, delta)
{
	if(fslot < 0 || fslot >= MAX_FAM_LAIRD || !FamLairdSlotUsed[fslot]) return 0;
	new v = FamLairdData[fslot][FAM_COUNT_VEH] + delta;
	if(v < 0) v = 0;
	FamLairdData[fslot][FAM_COUNT_VEH] = v;
	return v;
}

static stock Family_FleetCountDbSync(fid)
{
	if(fid <= 0) return 0;
	new q[320];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT GREATEST(\
		COALESCE((SELECT COUNT(*) FROM `family_fleet` WHERE `family_id`=%d),0),\
		COALESCE((SELECT COUNT(*) FROM `family_cars` WHERE `family_owner`=%d AND `ownable_id`>0),0)\
		) AS vc",
		fid, fid);
	new Cache:res = mysql_query(db_handle, q, true);
	new cnt = 0;
	if(res != Cache:0)
	{
		if(cache_num_rows() > 0)
			cnt = cache_get_field_content_int(0, "vc", db_handle);
		cache_delete(res);
	}
	return cnt;
}

static stock Family_FleetRefreshUsedCount(fslot)
{
	if(fslot < 0 || fslot >= MAX_FAM_LAIRD || !FamLairdSlotUsed[fslot]) return 0;
	new cnt = Family_FleetCountDbSync(FamLairdData[fslot][FAM_DB_ID]);
	FamLairdData[fslot][FAM_COUNT_VEH] = cnt;
	return cnt;
}

static stock bool:Family_FleetCanAddMore(playerid)
{
	if(!IsPlayerConnected(playerid)) return false;
	if(Player[playerid][pFamilyId] <= 0) return false;
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot == -1) return false;
	new used = Family_FleetRefreshUsedCount(fslot);
	new maxs = Family_GetMaxFleetSlots(fslot);
	return (used < maxs);
}

static stock Family_FleetRejectSlotFull(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	new used = 0, maxs = 5;
	if(fslot != -1)
	{
		used = Family_FleetRefreshUsedCount(fslot);
		maxs = Family_GetMaxFleetSlots(fslot);
	}
	new cap[96], chat[160];
	format(cap, sizeof cap, "Свободных слотов нет (%d/%d)", used, maxs);
	format(chat, sizeof chat,
		"Лимит семейного автопарка исчерпан (%d/%d). Доп. слот — в донат-магазине (300 BC).",
		used, maxs);
	ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, cap, "");
	Family_Msg(playerid, 0xFF6666FF, chat);
	DeletePVar(playerid, "fam_fleet_slot");
	return 1;
}

stock Family_GetMaxFleetSlotsByDbId(fid)
{
	new fslot = FamLaird_FindSlotByDbId(fid);
	return Family_GetMaxFleetSlots(fslot);
}

// 0 = ошибка, >0 = новый лимит слотов
stock Family_PurchaseDonateFleetSlot(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pFamilyId] <= 0) return 0;
	if(!Player[playerid][pFamilyLeader]) return 0;
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot == -1) return 0;
	return FamilyCapt_AddSlotVeh(fslot, 1);
}

stock FamilyCapt_GetSlotColorIdx(slot)
{
	if(!FamilyCapt_IsSlotUsed(slot)) return 2;
	new c = FamLairdData[slot][FAM_COLOR];
	if(c < 0 || c > 11) return 2;
	return c;
}

static stock Family_MaxMemberFromLevel(lm)
{
	if(lm < 1) lm = 1;
	if(lm > FAMILY_UPGRADE_MAX) lm = FAMILY_UPGRADE_MAX;
	return 5 + lm * 5;
}

static stock Family_PlayerMoneyApply(playerid, delta)
{
	Player[playerid][pMoney] += delta;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Player[playerid][pMoney]);
	SavePlayerAccount(playerid);
	return 1;
}

static stock Family_CapMoneyStore(playerid)
{
	new ls = GetPVarInt(playerid, "fam_lvl_store");
	if(ls < 1) ls = 1;
	if(ls > FAMILY_UPGRADE_MAX) ls = FAMILY_UPGRADE_MAX;
	return FamilyCountMoneyLevel[ls - 1];
}

forward Family_DB_OnSkladMoneyPull(playerid, amount);
forward Family_DB_OnSkladMoneyPush(playerid, amount);
forward Family_DB_OnStorageFlip(playerid, newst);
forward Family_DB_OnMgmtKick(playerid);
forward Family_DB_OnMgmtRank(playerid, newrank);
forward Family_DB_OnMgmtMuteApply(playerid);
forward Family_DB_OnMgmtUnmute(playerid);
forward Family_DB_OnInviteCheck(playerid, target_acc);
forward Family_DB_OnInviteDone(playerid, target_slot);
forward Family_DB_OnFleetPrecheck(playerid, car_db_id);
forward Family_DB_OnAdsList(playerid);
forward Family_DB_OnRatingList(playerid);
forward Family_DB_OnLogList(playerid);
forward Family_DB_OnAdPosted(playerid);
forward Family_DB_OnRankNameSaved(playerid);
forward Fam_DB_OnCarDbSlot(playerid, slot);
forward Family_DB_OnFleetTransferDb(playerid, car_db_id);
forward Family_DB_OnFleetReturnOwner(playerid, orig_uid, car_db_id);

static stock Family_DialogShowSkladRoot(playerid)
{
	new line[200];
	format(line, sizeof line,
		"| Склад: %s\n1. Взять со склада\n2. Положить на склад\n3. Лимиты доступа (справка)",
		GetPVarInt(playerid, "fam_storage_open") ? ("{00FF00}Открыт") : ("{FF0000}Закрыт"));
	ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_SKLAD, DIALOG_STYLE_LIST,
		"{E0584B}Склад семьи", line, "Далее", "Назад");
	return 1;
}

static stock Family_DialogShowSkladResPick(playerid)
{
	new tp = GetPVarInt(playerid, "fam_sklad_tp");
	new list[] =
		"1. Деньги\n"\
		"2. Материалы (только казна, без инвентаря игрока)\n"\
		"3. Маски / канистры / броня / патроны — см. улучшения склада";
	ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_SKRES, DIALOG_STYLE_LIST,
		tp ? ("{E0584B}Положить на склад") : ("{E0584B}Взять со склада"),
		list, "Далее", "Назад");
	return 1;
}

static stock Family_DialogShowMgmt(playerid)
{
	if(!Player[playerid][pFamilyLeader])
	{
		Family_Msg(playerid, 0xFF6666FF, "Управление семьёй доступно только лидеру.");
		Family_DialogShowMain(playerid);
		return 1;
	}
	new list[] =
		"1. Принять игрока (ID онлайн)\n"\
		"2. Выгнать игрока (ник)\n"\
		"3. Выдать мут чата (формат: Ник_минуты)\n"\
		"4. Снять мут (ник)\n"\
		"5. Ранги: назначить и переименовать";
	ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_MGMT, DIALOG_STYLE_LIST,
		"{E0584B}Управление семьёй", list, "Далее", "Назад");
	return 1;
}

static stock Family_DialogShowFamilySettings(playerid)
{
	if(!Player[playerid][pFamilyLeader])
	{
		Family_Msg(playerid, 0xFF6666FF, "Настройки семьи доступны только лидеру.");
		Family_DialogShowMain(playerid);
		return 1;
	}
	new list[] =
		"Цвет семейного чата — VIP (/fam)\n"\
		"Доступ к складу по рангам (1-4)\n"\
		"Справка по складу";
	ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_SET, DIALOG_STYLE_LIST,
		"{E0584B}Настройка семьи", list, "Выбрать", "Назад");
	return 1;
}

static stock Family_ShowSettingsColorPick(playerid)
{
	if(!Player[playerid][pFamilyLeader]) return 0;
	new list[] =
		"Белый\n"\
		"Серый\n"\
		"Жёлтый — как /v (VIP-чат)\n"\
		"Красный\n"\
		"Голубой\n"\
		"Розовый\n"\
		"Ярко-жёлтый\n"\
		"Салатовый\n"\
		"Лимонный\n"\
		"Оранжевый\n"\
		"Синий\n"\
		"Светло-голубой";
	ShowPlayerDialog(playerid, DIALOG_FAM_SET_COLOR, DIALOG_STYLE_LIST,
		"{E0584B}Цвет семейного чата", list, "Сохранить", "Назад");
	return 1;
}

static stock Family_LogWrite(fid, uid, const txt[], typ)
{
	if(fid <= 0) return 0;
	new q[320];
	mysql_format(db_handle, q, sizeof(q),
		"INSERT INTO `family_log` (`family`,`player`,`to_player`,`text`,`time`,`type`) VALUES (%d,%d,-1,'%e',%d,%d)",
		fid, uid, txt, gettime(), typ);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Family_ShowAdsMenu(playerid)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	new list[] =
		"Просмотреть объявления\n"\
		"Разместить объявление (лидер)";
	ShowPlayerDialog(playerid, DIALOG_FAM_AD_MENU, DIALOG_STYLE_LIST,
		"{E0584B}Объявления семьи", list, "Далее", "Назад");
	return 1;
}

stock Family_RequestAdsList(playerid)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	new q[280];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `ad_text`, `create_name`, `time` FROM `family_ad` WHERE `family`=%d ORDER BY `id` DESC LIMIT 20",
		Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_OnAdsList", "i", playerid);
	return 1;
}

stock Family_RequestRatingList(playerid)
{
	mysql_tquery(db_handle,
		"SELECT `name`, `reputation` FROM `family` ORDER BY `reputation` DESC LIMIT 15",
		"Family_DB_OnRatingList", "i", playerid);
	return 1;
}

stock Family_RequestLogList(playerid)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	new q[220];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `text`, `time`, `type` FROM `family_log` WHERE `family`=%d ORDER BY `id` DESC LIMIT 25",
		Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_OnLogList", "i", playerid);
	return 1;
}

public Family_DB_OnAdsList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new big[4096];
	format(big, sizeof big, "Текст объявления\tАвтор\tВремя\n");
	if(rows == 0)
	{
		strcat(big, "{AAAAAA}Объявлений пока нет.\t-\t-", sizeof big);
	}
	else
	{
		for(new i = 0; i < rows; i++)
		{
			new t[128], a[28];
			cache_get_field_content(i, "ad_text", t, db_handle, sizeof t);
			cache_get_field_content(i, "create_name", a, db_handle, sizeof a);
			new cr = cache_get_field_content_int(i, "time", db_handle);
			if(strlen(t) > 48) t[48] = '\0';
			new line[180];
			format(line, sizeof line, "%s\t%s\t%d\n", t, a, cr);
			strcat(big, line, sizeof big);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_FAM_AD_LIST, DIALOG_STYLE_TABLIST_HEADERS,
		"{E0584B}Объявления семьи", big, "Закрыть", "");
	return 1;
}

public Family_DB_OnRatingList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new big[2048];
	format(big, sizeof big, "#\tСемья\tРепутация\n");
	if(rows == 0)
		strcat(big, "-\tНет данных\t0\n", sizeof big);
	else
	{
		for(new i = 0; i < rows; i++)
		{
			new nm[40];
			cache_get_field_content(i, "name", nm, db_handle, sizeof nm);
			new rep = cache_get_field_content_int(i, "reputation", db_handle);
			new line[96];
			format(line, sizeof line, "%d\t%s\t%d\n", i + 1, nm, rep);
			strcat(big, line, sizeof big);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_FAM_RAT_LIST, DIALOG_STYLE_TABLIST_HEADERS,
		"{E0584B}Рейтинг семей (топ-15)", big, "Назад", "");
	return 1;
}

public Family_DB_OnLogList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new big[4096];
	format(big, sizeof big, "Событие\tВремя\n");
	if(rows == 0)
		strcat(big, "{AAAAAA}Записей пока нет.\t-", sizeof big);
	else
	{
		for(new i = 0; i < rows; i++)
		{
			new lt[128];
			cache_get_field_content(i, "text", lt, db_handle, sizeof lt);
			new cr = cache_get_field_content_int(i, "time", db_handle);
			if(strlen(lt) > 60) lt[60] = '\0';
			new line[200];
			format(line, sizeof line, "%s\t%d\n", lt, cr);
			strcat(big, line, sizeof big);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_FAM_LOG_LIST, DIALOG_STYLE_TABLIST_HEADERS,
		"{E0584B}Журнал семьи", big, "Назад", "");
	return 1;
}

public Family_DB_OnAdPosted(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(cache_affected_rows() > 0 || cache_insert_id() > 0)
	{
		Family_Msg(playerid, 0x88FF88FF, "Объявление опубликовано.");
		Family_LogWrite(Player[playerid][pFamilyId], Player[playerid][pID], "Опубликовано семейное объявление", 1);
	}
	else Family_Msg(playerid, 0xFF6666FF, "Не удалось сохранить объявление.");
	DeletePVar(playerid, "fam_ad_draft");
	Family_ShowAdsMenu(playerid);
	return 1;
}

public Family_DB_OnSkladMoneyPull(playerid, amount)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!cache_affected_rows())
	{
		Family_Msg(playerid, 0xFF6666FF, "Недостаточно денег на складе семьи.");
		return 1;
	}
	Family_PlayerMoneyApply(playerid, amount);
	new fm = GetPVarInt(playerid, "fam_money") - amount;
	if(fm < 0) fm = 0;
	SetPVarInt(playerid, "fam_money", fm);
	new body[96], msg[160];
	format(body, sizeof body, "%s взял со склада %d руб.", Player[playerid][pName], amount);
	Family_FormatFamilyBroadcast(Player[playerid][pFamilyId], body, msg, sizeof msg);
	Family_SendFamilyMessage(Player[playerid][pFamilyId], msg);
	Family_PersistMemberRow(playerid);
	return 1;
}

public Family_DB_OnSkladMoneyPush(playerid, amount)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!cache_affected_rows())
	{
		Family_Msg(playerid, 0xFF6666FF, "Ошибка зачисления на склад.");
		return 1;
	}
	Family_PlayerMoneyApply(playerid, -amount);
	new fm = GetPVarInt(playerid, "fam_money") + amount;
	SetPVarInt(playerid, "fam_money", fm);
	new body[96], msg[160];
	format(body, sizeof body, "%s положил на склад %d руб.", Player[playerid][pName], amount);
	Family_FormatFamilyBroadcast(Player[playerid][pFamilyId], body, msg, sizeof msg);
	Family_SendFamilyMessage(Player[playerid][pFamilyId], msg);
	return 1;
}

public Family_DB_OnStorageFlip(playerid, newst)
{
	if(!IsPlayerConnected(playerid)) return 1;
	#pragma unused newst
	if(cache_affected_rows())
	{
		SetPVarInt(playerid, "fam_storage_open", newst);
		new body[48], msg[128];
		format(body, sizeof body, "Склад %s.", newst ? ("открыт") : ("закрыт"));
		Family_FormatFamilyBroadcast(Player[playerid][pFamilyId], body, msg, sizeof msg);
		Family_SendFamilyMessage(Player[playerid][pFamilyId], msg);
	}
	Family_DialogShowSkladRoot(playerid);
	return 1;
}

public Family_DB_OnMgmtKick(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new nm[MAX_PLAYER_NAME];
	GetPVarString(playerid, "fam_mg_name", nm, sizeof nm);
	if(cache_affected_rows())
	{
		Family_Msg(playerid, 0x88FF88FF, "Участник исключён.");
		if(strlen(nm))
		{
			for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
			{
				if(!IsPlayerConnected(i)) continue;
				if(strcmp(Player[i][pName], nm, true)) continue;
				Family_ResetPlayerVars(i);
				Family_Msg(i, 0xE0584BFF, "Вас исключили из семьи.");
				break;
			}
		}
		SetPVarInt(playerid, "fam_mc", GetPVarInt(playerid, "fam_mc") - 1);
	}
	else Family_Msg(playerid, 0xFF6666FF, "Не удалось исключить (ник не найден или это лидер).");
	DeletePVar(playerid, "fam_mg_name");
	Family_DialogShowMain(playerid);
	return 1;
}

public Family_DB_OnMgmtRank(playerid, newrank)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new tuid = GetPVarInt(playerid, "fam_mg_target_uid");
	DeletePVar(playerid, "fam_mg_target_uid");
	DeletePVar(playerid, "fam_mg_name");
	if(cache_affected_rows())
	{
		Family_Msg(playerid, 0x88FF88FF, "Ранг обновлён.");
		if(tuid > 0)
		{
			for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
			{
				if(!IsPlayerConnected(i)) continue;
				if(Player[i][pID] != tuid) continue;
				Player[i][pFamilyRank] = newrank;
				Family_DB_LoadMember(i);
				break;
			}
		}
	}
	else Family_Msg(playerid, 0xFF6666FF, "Не удалось сменить ранг.");
	Family_DialogShowMain(playerid);
	return 1;
}

public Family_DB_OnMgmtMuteApply(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(cache_affected_rows())
	{
		Family_Msg(playerid, 0x88FF88FF, "Мут выдан.");
		new nm[MAX_PLAYER_NAME];
		GetPVarString(playerid, "fam_mg_mute_name", nm, sizeof nm);
		new tot = GetPVarInt(playerid, "fam_mg_secs");
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(!IsPlayerConnected(i)) continue;
			if(strcmp(Player[i][pName], nm, true)) continue;
			SetPVarInt(i, "fam_mute_left", tot);
			Family_Msg(i, 0xFF6666FF, "[Семья] Вам выдали мут семейного чата.");
			break;
		}
	}
	else Family_Msg(playerid, 0xFF6666FF, "Игрок не найден в семье.");
	DeletePVar(playerid, "fam_mg_mute_name");
	DeletePVar(playerid, "fam_mg_secs");
	Family_DialogShowMain(playerid);
	return 1;
}

public Family_DB_OnMgmtUnmute(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new nm[MAX_PLAYER_NAME];
	GetPVarString(playerid, "fam_mg_unmute", nm, sizeof nm);
	if(cache_affected_rows())
		Family_Msg(playerid, 0x88FF88FF, "Мут снят.");
	else Family_Msg(playerid, 0xFF6666FF, "Игрок не найден.");
	DeletePVar(playerid, "fam_mg_name");
	if(strlen(nm))
	{
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(!IsPlayerConnected(i)) continue;
			if(!strcmp(Player[i][pName], nm, true))
			{
				SetPVarInt(i, "fam_mute_left", 0);
				break;
			}
		}
	}
	DeletePVar(playerid, "fam_mg_unmute");
	Family_DialogShowMain(playerid);
	return 1;
}

public Family_DB_OnInviteCheck(playerid, target_acc)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		Family_Msg(playerid, 0xFF6666FF, "Этот аккаунт уже состоит в семье.");
		Family_DialogShowMain(playerid);
		return 1;
	}
	new tid = INVALID_PLAYER_ID;
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] == target_acc)
		{
			tid = i;
			break;
		}
	}
	if(tid == INVALID_PLAYER_ID)
	{
		Family_Msg(playerid, 0xFF6666FF, "Игрок не в сети или неверный ID.");
		Family_DialogShowMain(playerid);
		return 1;
	}
	if(Player[tid][pFamilyId] != 0)
	{
		Family_Msg(playerid, 0xFF6666FF, "Игрок уже в другой семье.");
		Family_DialogShowMain(playerid);
		return 1;
	}
	new mc = GetPVarInt(playerid, "fam_mc");
	new cap = Family_MaxMemberFromLevel(GetPVarInt(playerid, "fam_lvl_members"));
	if(mc >= cap)
	{
		Family_Msg(playerid, 0xFF6666FF, "Достигнут лимит участников (улучшайте «состав»).");
		Family_DialogShowMain(playerid);
		return 1;
	}
	new q[280];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `players` SET `family_id`=%d,`family_rang`=1,`family_access`='0,0,0,0,0,0,0',`family_mute`=0 WHERE `id`=%d AND (`family_id`=-1 OR `family_id`=0) LIMIT 1",
		Player[playerid][pFamilyId], target_acc);
	mysql_tquery(db_handle, q, "Family_DB_OnInviteDone", "ii", playerid, tid);
	return 1;
}

public Family_DB_OnInviteDone(playerid, target_slot)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(cache_affected_rows() > 0)
	{
		Family_Msg(playerid, 0x88FF88FF, "Игрок принят в семью.");
		if(IsPlayerConnected(target_slot))
		{
			Family_DB_LoadMember(target_slot);
			Family_Msg(target_slot, 0x88FF88FF, "Вас приняли в семью!");
		}
		SetPVarInt(playerid, "fam_mc", GetPVarInt(playerid, "fam_mc") + 1);
	}
	else Family_Msg(playerid, 0xFF6666FF, "Не удалось принять игрока.");
	Family_DialogShowMain(playerid);
	return 1;
}

stock Family_DB_LoadMember(playerid)
{
	if(Player[playerid][pID] == 0) return 0;
	new q[192];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `family_id`,`family_rang`,`family_mute`,`family_access` FROM `players` WHERE `id`=%d LIMIT 1",
		Player[playerid][pID]);
	mysql_tquery(db_handle, q, "Family_OnPlayerAccountLoad", "i", playerid);
	return 1;
}

stock Family_UnloadPlayer(playerid)
{
	if(Player[playerid][pID] <= 0 || Player[playerid][pFamilyId] <= 0) return 0;
	new access[28];
	access[0] = '\0';
	new acc0 = GetPVarInt(playerid, "fam_acc0");
	format(access, sizeof access, "%d,%d,%d,%d,%d,%d,%d",
		acc0, GetPVarInt(playerid, "fam_acc1"), GetPVarInt(playerid, "fam_acc2"),
		GetPVarInt(playerid, "fam_acc3"), GetPVarInt(playerid, "fam_acc4"),
		GetPVarInt(playerid, "fam_acc5"), GetPVarInt(playerid, "fam_acc6"));
	new q[256];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET `family_id`=%d,`family_rang`=%d,`family_mute`=%d,`family_access`='%e' WHERE `id`=%d LIMIT 1",
		Player[playerid][pFamilyId], Player[playerid][pFamilyRank], GetPVarInt(playerid, "fam_mute_left"),
		access, Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

static stock Family_GuiAppendOpenCatalog(playerid, Node:root)
{
	new Node:upgArr = JSON_Array();
	new lvl[3];
	lvl[0] = GetPVarInt(playerid, "fam_lvl_store");
	lvl[1] = GetPVarInt(playerid, "fam_lvl_weapons");
	lvl[2] = GetPVarInt(playerid, "fam_lvl_members");
	for(new u = 0; u < 3; u++)
	{
		if(lvl[u] < 1) lvl[u] = 1;
		new price = Family_UpgradeNextPrice(lvl[u]);
		upgArr = JSON_Append(upgArr, JSON_Object(
			"id", JSON_Int(u),
			"level", JSON_Int(lvl[u]),
			"money", JSON_Int(price),
			"materials", JSON_Int(0),
			"masks", JSON_Int(0),
			"gasoline", JSON_Int(0),
			"armour", JSON_Int(0),
			"people", JSON_Int(0),
			"ammo", JSON_Int(0),
			"price", JSON_Int(price)
		));
	}
	JSON_SetArray(root, "Upgrade", upgArr);

	new Node:shopArr = JSON_Array();
	for(new i = 0; i < sizeof(g_FamGuiShop); i++)
	{
		shopArr = JSON_Append(shopArr, JSON_Object(
			"id", JSON_Int(g_FamGuiShop[i][FAM_SID]),
			"title", JSON_String(g_FamGuiShop[i][FAM_STITLE]),
			"object_id", JSON_Int(0),
			"type", JSON_Int(3),
			"type_id", JSON_Int(g_FamGuiShop[i][FAM_SFX]),
			"price", JSON_Int(g_FamGuiShop[i][FAM_SPRICE]),
			"server_id", JSON_Int(0)
		));
	}
	JSON_SetArray(root, "Shop", shopArr);

	new Node:taskArr = JSON_Array();
	for(new j = 0; j < sizeof(g_FamGuiQuests); j++)
	{
		taskArr = JSON_Append(taskArr, JSON_Object(
			"id", JSON_Int(g_FamGuiQuests[j][FAM_QID]),
			"title", JSON_String(g_FamGuiQuests[j][FAM_QTITLE]),
			"description", JSON_String(g_FamGuiQuests[j][FAM_QDESC]),
			"money_reward", JSON_Int(g_FamGuiQuests[j][FAM_QMONEY]),
			"score_reward", JSON_Int(g_FamGuiQuests[j][FAM_QREP]),
			"token_reward", JSON_Int(g_FamGuiQuests[j][FAM_QTOKEN])
		));
	}
	JSON_SetArray(root, "Tasks", taskArr);
	return 1;
}

static g_FamGuiOpenBuf[8192];
static g_FamGuiReplyBuf[8192];

static stock Family_GuiSendNode(playerid, Node:root)
{
	if(!IsPlayerConnected(playerid)) return 0;
	g_FamGuiReplyBuf[0] = '\0';
	JSON_Stringify(root, g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf);
	JSON_Cleanup(root);
	if(strlen(g_FamGuiReplyBuf) < 4) return 0;
	OnPacketIncomingStr(playerid, FAMILY_GUI_ID, g_FamGuiReplyBuf);
	return 1;
}

static stock Family_EscapeJson(const src[], dest[], dest_size)
{
	new len = 0;
	for(new i = 0; src[i] != '\0' && len < dest_size - 2; i++)
	{
		if(src[i] == '\\' || src[i] == '"')
		{
			dest[len++] = '\\';
			if(len >= dest_size - 1) break;
		}
		dest[len++] = src[i];
	}
	dest[len] = '\0';
	return 1;
}

static stock bool:Family_BuildOpenGuiPacket(playerid)
{
	new fam_name[40], rn[32];
	new efam[80], epn[48], ern[64], etitle[96], edesc[192], tmp[320];

	format(fam_name, sizeof fam_name, "%s", Player[playerid][pFamilyName]);
	if(!fam_name[0]) format(fam_name, sizeof fam_name, "Семья");
	Family_FormatRankTitleForPlayer(playerid, rn, sizeof rn);
	Family_EscapeJson(fam_name, efam, sizeof efam);
	Family_EscapeJson(Player[playerid][pName], epn, sizeof epn);
	Family_EscapeJson(rn, ern, sizeof ern);

	new rep = GetPVarInt(playerid, "fam_rep");
	new place_top = (rep >= 100) ? 1 : 0;

	format(g_FamGuiOpenBuf, sizeof g_FamGuiOpenBuf,
		"{\"t\":0,\"o\":1,\"n\":\"%s\",\"k\":%d,\"m\":%d,\"j\":%d,\"y\":0,\"b\":%d,\"pn\":\"%s\",\"pi\":%d,\"s\":1,\"is\":1,\"rn\":\"%s\",\"Upgrade\":[",
		efam, Player[playerid][pFamilyLeader] ? 1 : 0, GetPVarInt(playerid, "fam_money"),
		FAMILY_GUI_TOKENS_DEFAULT, place_top, epn, Player[playerid][pID], ern);

	new lvl[3], u, price;
	lvl[0] = GetPVarInt(playerid, "fam_lvl_store");
	lvl[1] = GetPVarInt(playerid, "fam_lvl_weapons");
	lvl[2] = GetPVarInt(playerid, "fam_lvl_members");
	for(u = 0; u < 3; u++)
	{
		if(lvl[u] < 1) lvl[u] = 1;
		price = Family_UpgradeNextPrice(lvl[u]);
		format(tmp, sizeof tmp,
			"%s{\"id\":%d,\"level\":%d,\"money\":%d,\"materials\":0,\"masks\":0,\"gasoline\":0,\"armour\":0,\"people\":0,\"ammo\":0,\"price\":%d}",
			(u > 0) ? (",") : (""), u, lvl[u], price, price);
		strcat(g_FamGuiOpenBuf, tmp);
	}
	strcat(g_FamGuiOpenBuf, "],\"Shop\":[");
	for(new i = 0; i < sizeof(g_FamGuiShop); i++)
	{
		Family_EscapeJson(g_FamGuiShop[i][FAM_STITLE], etitle, sizeof etitle);
		format(tmp, sizeof tmp,
			"%s{\"id\":%d,\"title\":\"%s\",\"object_id\":0,\"type\":3,\"type_id\":%d,\"price\":%d,\"server_id\":0}",
			(i > 0) ? (",") : (""), g_FamGuiShop[i][FAM_SID], etitle,
			g_FamGuiShop[i][FAM_SFX], g_FamGuiShop[i][FAM_SPRICE]);
		strcat(g_FamGuiOpenBuf, tmp);
	}
	strcat(g_FamGuiOpenBuf, "],\"Tasks\":[");
	for(new j = 0; j < sizeof(g_FamGuiQuests); j++)
	{
		Family_EscapeJson(g_FamGuiQuests[j][FAM_QTITLE], etitle, sizeof etitle);
		Family_EscapeJson(g_FamGuiQuests[j][FAM_QDESC], edesc, sizeof edesc);
		format(tmp, sizeof tmp,
			"%s{\"id\":%d,\"title\":\"%s\",\"description\":\"%s\",\"money_reward\":%d,\"score_reward\":%d,\"token_reward\":%d}",
			(j > 0) ? (",") : (""), g_FamGuiQuests[j][FAM_QID], etitle, edesc,
			g_FamGuiQuests[j][FAM_QMONEY], g_FamGuiQuests[j][FAM_QREP], g_FamGuiQuests[j][FAM_QTOKEN]);
		strcat(g_FamGuiOpenBuf, tmp);
	}
	strcat(g_FamGuiOpenBuf, "]}");
	return (strlen(g_FamGuiOpenBuf) > 32);
}

static stock Family_SendOpenGui(playerid)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	if(!Family_BuildOpenGuiPacket(playerid)) return 0;
	OnPacketIncomingStr(playerid, FAMILY_GUI_ID, g_FamGuiOpenBuf);
	return 1;
}

forward Family_DB_OnMenuPurseOnly(playerid);
public Family_DB_OnMenuPurseOnly(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(Player[playerid][pFamilyId] == 0) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		new chk = cache_get_field_content_int(0, "id", db_handle);
		if(chk == Player[playerid][pFamilyId])
		{
			SetPVarInt(playerid, "fam_money", cache_get_field_content_int(0, "money", db_handle));
			SetPVarInt(playerid, "fam_rep", cache_get_field_content_int(0, "reputation", db_handle));
			new slot = GetPVarInt(playerid, "fam_slot");
			if(slot >= 0 && slot < MAX_FAM_LAIRD && FamLairdSlotUsed[slot])
			{
				FamLairdData[slot][FAM_MONEY] = GetPVarInt(playerid, "fam_money");
				FamLairdData[slot][FAM_REP] = GetPVarInt(playerid, "fam_rep");
			}
		}
	}
	return 1;
}

static stock Family_RequestOpenGui(playerid)
{
	if(Player[playerid][pFamilyId] <= 0) return 0;
	new slot = GetPVarInt(playerid, "fam_slot");
	if(slot >= 0 && slot < MAX_FAM_LAIRD && FamLairdSlotUsed[slot])
		FamLaird_SyncPlayerPvars(playerid, slot);
	else
	{
		slot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
		if(slot >= 0 && slot < MAX_FAM_LAIRD && FamLairdSlotUsed[slot])
			FamLaird_SyncPlayerPvars(playerid, slot);
	}
	if(!Family_SendOpenGui(playerid)) return 0;
	new q[160];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `id`,`money`,`reputation` FROM `family` WHERE `id`=%d LIMIT 1",
		Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_OnMenuPurseOnly", "i", playerid);
	return 1;
}

public Family_DelayedOpenGui(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(Player[playerid][pFamilyId] <= 0) return 1;
	return Family_RequestOpenGui(playerid);
}

stock Family_ShowMenu(playerid)
{
	if(Player[playerid][pID] == 0)
		return Family_Msg(playerid, 0xCECECEFF, "Сначала войдите в аккаунт."), 0;
	if(!GetPVarInt(playerid, "fam_loaded"))
	{
		SetPVarInt(playerid, "fam_open_after_load", 1);
		Family_DB_LoadMember(playerid);
		return Family_Msg(playerid, 0xCECECEFF, "Загрузка семьи... Повторите /fm через секунду."), 0;
	}
	if(Player[playerid][pFamilyId] <= 0)
	{
		if(!GetPVarInt(playerid, "fam_reload_try"))
		{
			SetPVarInt(playerid, "fam_reload_try", 1);
			SetPVarInt(playerid, "fam_open_after_load", 1);
			DeletePVar(playerid, "fam_loaded");
			Family_DB_LoadMember(playerid);
			return Family_Msg(playerid, 0xCECECEFF, "Повторная загрузка семьи..."), 0;
		}
		DeletePVar(playerid, "fam_reload_try");
		return Family_Msg(playerid, 0xCECECEFF, "Вы не состоите в семье. Создайте её: /createfm"), 0;
	}
	DeletePVar(playerid, "fam_reload_try");
	DeletePVar(playerid, "fam_open_after_load");
	if(!Family_RequestOpenGui(playerid))
		return Family_Msg(playerid, 0xFF6666FF, "Не удалось открыть меню семьи. Повторите /fm."), 0;
	return 1;
}

static stock Family_SendMainMenuGui(playerid)
{
	new ls = GetPVarInt(playerid, "fam_lvl_store");
	new lw = GetPVarInt(playerid, "fam_lvl_weapons");
	new lm = GetPVarInt(playerid, "fam_lvl_members");
	if(ls < 1) ls = 1;
	if(lw < 1) lw = 1;
	if(lm < 1) lm = 1;
	new rep = GetPVarInt(playerid, "fam_rep");
	new mc = GetPVarInt(playerid, "fam_mc");
	if(mc < 1) mc = 1;

	new fm = GetPVarInt(playerid, "fam_money");
	new mat = GetPVarInt(playerid, "fam_mat");
	new masks = GetPVarInt(playerid, "fam_masks");
	new fuel = GetPVarInt(playerid, "fam_fuel");
	new armor = GetPVarInt(playerid, "fam_armor");
	new ammo = GetPVarInt(playerid, "fam_ammo");

	new max_money = 800000 + (ls - 1) * 200000;
	if(max_money < 800000) max_money = 800000;
	new max_mat = 6000 + (ls - 1) * 2000;
	if(max_mat < 6000) max_mat = 6000;
	new max_masks = 6000 + (ls - 1) * 2000;
	if(max_masks < 6000) max_masks = 6000;
	new max_fuel = 6000 + (ls - 1) * 2000;
	if(max_fuel < 6000) max_fuel = 6000;
	new max_ammo = 50000 + (lw - 1) * 10000;
	if(max_ammo < 50000) max_ammo = 50000;
	new max_armor = 5000 + (lw - 1) * 1000;
	if(max_armor < 5000) max_armor = 5000;

	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf,
		"{\"t\":5,\"id\":0,\"r\":%d,\"am\":%d,\"s\":%d,\"k\":%d,"\
		"\"my\":[%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d],"\
		"\"ug\":[%d,%d,%d,%d,%d,%d],\"ms\":[]}",
		rep, mc, Player[playerid][pSkin], Player[playerid][pFamilyLeader] ? 1 : 0,
		fm, max_money, mat, max_mat, masks, max_masks, fuel, max_fuel, ammo, max_ammo, armor, max_armor,
		ls, FAMILY_UPGRADE_MAX, lw, FAMILY_UPGRADE_MAX, lm, FAMILY_UPGRADE_MAX);
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_SendMainBlock(playerid)
{
	return Family_SendMainMenuGui(playerid);
}

static stock Family_SendQuestOpenGui(playerid)
{
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf, "{\"t\":1,\"s\":1,\"id\":0}");
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_SendShopOpenGui(playerid)
{
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf,
		"{\"t\":3,\"s\":1,\"na\":%d,\"tp\":0}", GetPVarInt(playerid, "fam_money"));
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_GuiRequestLeave(playerid)
{
	if(Player[playerid][pFamilyLeader])
		return Family_Msg(playerid, 0xFF6666FF, "Лидер не может выйти через это меню."), 1;
	return Family_DialogShowLeaveConfirm(playerid);
}

static stock Family_HandleMenuNavigate(playerid, Node:json)
{
	new id = 0, s = -1;
	new bool:hasId = (JSON_GetType(json, "id") == JSON_NODE_NUMBER && JSON_GetInt(json, "id", id));
	if(JSON_GetType(json, "s") == JSON_NODE_NUMBER)
		JSON_GetInt(json, "s", s);

	if(hasId && s == -1)
	{
		/* UIMenuMain: 1=настройки, 2=игроки, 3=склад, 4=логи, 5=ЧС, 6=автопарк, 7=улучш., 8=выход */
		if(id == 1)
			return Family_SendSettingsStart(playerid);
		if(id == 2)
			return Family_PlayerListRequest(playerid);
		if(id == 3)
			return Family_SendStoreSafeParams(playerid);
		if(id == 4)
			return Family_HandleLogsPacket(playerid);
		if(id == 5)
			return Family_HandleBlacklistPacket(playerid);
		if(id == 6)
			return Family_FleetSendListAsync(playerid);
		if(id == 7)
			return Family_SendUpgrade(playerid);
		if(id == 8)
			return Family_GuiRequestLeave(playerid);
	}

	if(hasId)
	{
		switch(id)
		{
			case 1: return Family_HandleSettingsPacket(playerid, json);
			case 2: return Family_HandlePlayersPacket(playerid, json);
			case 3: return Family_HandleStorePacket(playerid, json);
			case 4: return Family_HandleLogsPacket(playerid);
			case 5: return Family_HandleBlacklistPacket(playerid);
		}
	}
	return Family_SendMainBlock(playerid);
}

static stock Family_FleetGarageFlag(playerid)
{
	if(GetPVarInt(playerid, "fam_lvl_store") >= 2) return 1;
	return 0;
}

static stock Family_FindPidFromUid(uid)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pID] == uid) return i;
	}
	return INVALID_PLAYER_ID;
}

static stock Family_FindSlotByDbId(owner_pid, car_db_id)
{
	if(owner_pid == INVALID_PLAYER_ID) return -1;
	for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
	{
		if(VehicleInfo[owner_pid][s][vDBID] == car_db_id) return s;
	}
	return -1;
}

static stock Family_FindFreeVehicleSlot(playerid)
{
	for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
	{
		if(VehicleInfo[playerid][s][vModel] == 0) return s;
	}
	return -1;
}

static stock Family_CopyOcCacheToBorrowSlot(playerid, fs, rowidx)
{
	VehicleInfo[playerid][fs][vDBID] = cache_get_field_content_int(rowidx, "cid", db_handle);
	VehicleInfo[playerid][fs][vModel] = cache_get_field_content_int(rowidx, "model", db_handle);
	VehicleInfo[playerid][fs][vColor][0] = cache_get_field_content_int(rowidx, "color1", db_handle);
	VehicleInfo[playerid][fs][vColor][1] = cache_get_field_content_int(rowidx, "color2", db_handle);
	if(VehicleInfo[playerid][fs][vColor][0] < 0 || VehicleInfo[playerid][fs][vColor][0] > 126) VehicleInfo[playerid][fs][vColor][0] = 1;
	if(VehicleInfo[playerid][fs][vColor][1] < 0 || VehicleInfo[playerid][fs][vColor][1] > 126) VehicleInfo[playerid][fs][vColor][1] = 1;
	VehicleInfo[playerid][fs][vBodyColor] = cache_get_field_content_int(rowidx, "body_color", db_handle);
	VehicleInfo[playerid][fs][vDiskColor] = cache_get_field_content_int(rowidx, "disk_color", db_handle);
	VehicleInfo[playerid][fs][vWheel] = cache_get_field_content_int(rowidx, "wheel", db_handle);
	VehicleInfo[playerid][fs][vWindFront] = cache_get_field_content_int(rowidx, "pered_windcolor", db_handle);
	VehicleInfo[playerid][fs][vWindRear] = cache_get_field_content_int(rowidx, "zadni_windcolor", db_handle);
	VehicleInfo[playerid][fs][vNeonMain] = cache_get_field_content_int(rowidx, "neon_main", db_handle);
	VehicleInfo[playerid][fs][vNeon1] = cache_get_field_content_int(rowidx, "neon1", db_handle);
	VehicleInfo[playerid][fs][vNeon2] = cache_get_field_content_int(rowidx, "neon2", db_handle);
	VehicleInfo[playerid][fs][vLightsColor] = cache_get_field_content_int(rowidx, "lights_color", db_handle);
	VehicleInfo[playerid][fs][vStrob] = cache_get_field_content_int(rowidx, "strob", db_handle);
	if(VehicleInfo[playerid][fs][vStrob] == 0) VehicleInfo[playerid][fs][vStrob] = 5;
	cache_get_field_content(rowidx, "vinyl", VehicleInfo[playerid][fs][vVinyl], db_handle, 32);
	VehicleInfo[playerid][fs][vSport] = cache_get_field_content_int(rowidx, "sport", db_handle);
	VehicleInfo[playerid][fs][vDrift] = cache_get_field_content_int(rowidx, "drift", db_handle);
	VehicleInfo[playerid][fs][vComfort] = cache_get_field_content_int(rowidx, "comfort", db_handle);
	VehicleInfo[playerid][fs][vSportPlus] = cache_get_field_content_int(rowidx, "sport_plus", db_handle);
	VehicleInfo[playerid][fs][vNitro] = cache_get_field_content_int(rowidx, "nitro", db_handle);
	VehicleInfo[playerid][fs][vFuel] = cache_get_field_content_float(rowidx, "fuel", db_handle);
	if(VehicleInfo[playerid][fs][vFuel] < 0.0) VehicleInfo[playerid][fs][vFuel] = 0.0;
	if(VehicleInfo[playerid][fs][vFuel] > 150.0) VehicleInfo[playerid][fs][vFuel] = 150.0;
	gVehicleFuelType[playerid][fs] = Fuel_GetAllowedTypeByModel(VehicleInfo[playerid][fs][vModel]);
	gVehicleMileage[playerid][fs] = cache_get_field_content_float(rowidx, "mileage", db_handle);
	if(_:gVehicleMileage[playerid][fs] != _:gVehicleMileage[playerid][fs] || gVehicleMileage[playerid][fs] < 0.0) gVehicleMileage[playerid][fs] = 0.0;
	VehicleInfo[playerid][fs][vHealth] = cache_get_field_content_float(rowidx, "health", db_handle);
	if(VehicleInfo[playerid][fs][vHealth] < VEH_HP_MIN_VALUE) VehicleInfo[playerid][fs][vHealth] = VEH_HP_MIN_VALUE;
	if(VehicleInfo[playerid][fs][vHealth] > 2000.0) VehicleInfo[playerid][fs][vHealth] = 1000.0;
	VehicleInfo[playerid][fs][vPos][0] = cache_get_field_content_float(rowidx, "x", db_handle);
	VehicleInfo[playerid][fs][vPos][1] = cache_get_field_content_float(rowidx, "y", db_handle);
	VehicleInfo[playerid][fs][vPos][2] = cache_get_field_content_float(rowidx, "z", db_handle);
	VehicleInfo[playerid][fs][vPos][3] = cache_get_field_content_float(rowidx, "a", db_handle);
	VehicleInfo[playerid][fs][vDalniysvet] = cache_get_field_content_int(rowidx, "dalniysvet", db_handle);
	VehicleInfo[playerid][fs][vClearance] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "clearance", db_handle));
	VehicleInfo[playerid][fs][vClearanceFront] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "clearance_front", db_handle));
	VehicleInfo[playerid][fs][vClearanceRear] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "clearance_rear", db_handle));
	Tune_ResetWheelCollapseFields(playerid, fs);
	VehicleInfo[playerid][fs][vOffsetFront] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "offset_front", db_handle));
	VehicleInfo[playerid][fs][vOffsetRear] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "offset_rear", db_handle));
	VehicleInfo[playerid][fs][vCamberFront] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "camber_front", db_handle));
	VehicleInfo[playerid][fs][vCamberRear] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "camber_rear", db_handle));
	VehicleInfo[playerid][fs][vWheelWidthFront] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "wheel_width_front", db_handle));
	VehicleInfo[playerid][fs][vWheelWidthRear] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "wheel_width_rear", db_handle));
	VehicleInfo[playerid][fs][vWheelRadius] = Tune_NormalizeCollapseStored(cache_get_field_content_float(rowidx, "wheel_radius", db_handle));
	VehicleInfo[playerid][fs][vWheelModel] = cache_get_field_content_int(rowidx, "wheel_model_id", db_handle);
	VehicleInfo[playerid][fs][vHydra] = cache_get_field_content_int(rowidx, "hydra", db_handle);
	VehicleInfo[playerid][fs][vPnevmo] = cache_get_field_content_int(rowidx, "pnevmo", db_handle);
	VehicleInfo[playerid][fs][vLaunchControl] = cache_get_field_content_int(rowidx, "launch_control", db_handle);
	VehicleInfo[playerid][fs][vLaunchControlOn] = false;
	VehicleInfo[playerid][fs][vHornSound] = cache_get_field_content_int(rowidx, "horn_sound", db_handle);
	VehicleInfo[playerid][fs][vExhaustSound] = cache_get_field_content_int(rowidx, "exhaust_sound", db_handle);
	VehicleInfo[playerid][fs][vPlateType] = cache_get_field_content_int(rowidx, "plate_type", db_handle);
	cache_get_field_content(rowidx, "plate_number", VehicleInfo[playerid][fs][vPlateNumber], db_handle, 12);
	cache_get_field_content(rowidx, "plate_region", VehicleInfo[playerid][fs][vPlateRegion], db_handle, 8);
	cache_get_field_content(rowidx, "plate", VehicleInfo[playerid][fs][vPlateStr], db_handle, 32);
	VehicleInfo[playerid][fs][vPrice] = cache_get_field_content_int(rowidx, "price", db_handle);
	VehicleInfo[playerid][fs][vID] = INVALID_VEHICLE_ID;
	VehicleInfo[playerid][fs][vSpawned] = false;
	VehicleInfo[playerid][fs][vFamFleetBorrow] = true;
	return 1;
}

static stock bool:Family_IsCarDbSpawned(car_db_id)
{
	for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
	{
		if(!IsPlayerConnected(p)) continue;
		for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
		{
			if(VehicleInfo[p][s][vDBID] != car_db_id) continue;
			if(!VehicleInfo[p][s][vSpawned]) continue;
			if(VehicleInfo[p][s][vID] == INVALID_VEHICLE_ID) continue;
			if(GetVehicleModel(VehicleInfo[p][s][vID]) <= 0) continue;
			return true;
		}
	}
	return false;
}

static stock Family_FleetNotifyRankDenied(playerid)
{
	ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Ваш ранг недостаточен для этого транспорта.", "");
	return Family_Msg(playerid, 0xFF6666FF, "Ваш ранг недостаточен для этого транспорта."), 1;
}

static stock Family_FleetResolveOwnableDbId(playerid, lookup_id)
{
	if(lookup_id <= 0) return 0;
	new q[200];
	mysql_format(db_handle, q, sizeof(q), "SELECT `id` FROM `ownable_cars` WHERE `id`=%d LIMIT 1", lookup_id);
	new Cache:res = mysql_query(db_handle, q, true);
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		cache_delete(res);
		return lookup_id;
	}
	cache_delete(res);
	mysql_format(db_handle, q, sizeof(q),
		"SELECT COALESCE(NULLIF(`ownable_id`,0),0) AS `oid` FROM `family_cars`\
		 WHERE `family_owner`=%d AND (`ownable_id`=%d OR `id`=%d) LIMIT 1",
		Player[playerid][pFamilyId], lookup_id, lookup_id);
	res = mysql_query(db_handle, q, true);
	cache_get_data(rows, fields, db_handle);
	new oid = 0;
	if(rows > 0)
		oid = cache_get_field_content_int(0, "oid", db_handle);
	cache_delete(res);
	if(oid > 0) return oid;
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `car_db_id` FROM `family_fleet` WHERE `car_db_id`=%d AND `family_id`=%d LIMIT 1",
		lookup_id, Player[playerid][pFamilyId]);
	res = mysql_query(db_handle, q, true);
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		oid = cache_get_field_content_int(0, "car_db_id", db_handle);
		cache_delete(res);
		return oid;
	}
	cache_delete(res);
	return lookup_id;
}

static stock Family_FleetSyncRemoveFromFamily(playerid, car_db_id)
{
	new q[256];
	mysql_format(db_handle, q, sizeof(q),
		"DELETE FROM `family_fleet` WHERE `car_db_id`=%d AND `family_id`=%d",
		car_db_id, Player[playerid][pFamilyId]);
	new Cache:r1 = mysql_query(db_handle, q, true);
	cache_delete(r1);
	mysql_format(db_handle, q, sizeof(q), "DELETE FROM `family_cars` WHERE `ownable_id`=%d", car_db_id);
	new Cache:r2 = mysql_query(db_handle, q, true);
	cache_delete(r2);
	return 1;
}

static stock Family_FleetReloadPersonalCars(reload_playerid, owner_uid)
{
	if(!IsPlayerConnected(reload_playerid) || owner_uid <= 0) return 0;
	new ql[192];
	mysql_format(db_handle, ql, sizeof(ql),
		"SELECT * FROM `ownable_cars` WHERE `owner_id`=%d ORDER BY `id` ASC", owner_uid);
	new Cache:lr = mysql_query(db_handle, ql, true);
	LoadPlayerVehicles(reload_playerid);
	cache_delete(lr);
	return 1;
}

static stock Family_FleetResolveOwnerUid(playerid, car_db_id, hint_uid)
{
	if(hint_uid > 0) return hint_uid;
	new q[280];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT COALESCE(NULLIF(ff.`original_owner_uid`, 0), NULLIF(ff.`added_by_uid`, 0), 0) AS `ouid`\
		 FROM `family_fleet` ff WHERE ff.`car_db_id` = %d AND ff.`family_id` = %d LIMIT 1",
		car_db_id, Player[playerid][pFamilyId]);
	new Cache:res = mysql_query(db_handle, q, true);
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new uid = 0;
	if(rows > 0)
		uid = cache_get_field_content_int(0, "ouid", db_handle);
	cache_delete(res);
	if(uid <= 0) uid = Player[playerid][pID];
	return uid;
}

static stock bool:Family_FleetReturnCarToOwner(playerid, lookup_id, orig_uid)
{
	new real_db_id = Family_FleetResolveOwnableDbId(playerid, lookup_id);
	if(real_db_id <= 0) return false;
	new return_uid = Family_FleetResolveOwnerUid(playerid, real_db_id, orig_uid);
	if(return_uid <= 0) return false;

	Family_FleetUnloadByDbId(INVALID_PLAYER_ID, real_db_id);

	new owner_name[MAX_PLAYER_NAME];
	owner_name[0] = '\0';
	new tgt = Family_FindPidFromUid(return_uid);
	if(tgt != INVALID_PLAYER_ID)
		format(owner_name, sizeof owner_name, "%s", Player[tgt][pName]);
	else
	{
		new qn[128];
		mysql_format(db_handle, qn, sizeof(qn), "SELECT `name` FROM `players` WHERE `id`=%d LIMIT 1", return_uid);
		new Cache:rn = mysql_query(db_handle, qn, true);
		new rows, fields;
		cache_get_data(rows, fields, db_handle);
		if(rows > 0)
			cache_get_field_content(0, "name", owner_name, db_handle, MAX_PLAYER_NAME);
		cache_delete(rn);
	}
	if(!owner_name[0]) format(owner_name, sizeof owner_name, "Player_%d", return_uid);

	new qchk[96];
	mysql_format(db_handle, qchk, sizeof(qchk), "SELECT `owner_id` FROM `ownable_cars` WHERE `id`=%d LIMIT 1", real_db_id);
	new Cache:chk = mysql_query(db_handle, qchk, true);
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new cur_owner = -1;
	if(rows > 0)
		cur_owner = cache_get_field_content_int(0, "owner_id", db_handle);
	cache_delete(chk);

	if(rows == 0)
		return false;

	new bool:ok = false;
	if(cur_owner == return_uid)
		ok = true;
	else if(cur_owner == 0)
	{
		new qret[320];
		mysql_format(db_handle, qret, sizeof(qret),
			"UPDATE `ownable_cars` SET `owner_id`=%d, `owner_name`='%e' WHERE `id`=%d AND `owner_id`=0 LIMIT 1",
			return_uid, owner_name, real_db_id);
		new Cache:res = mysql_query(db_handle, qret, true);
		ok = (cache_affected_rows() > 0);
		cache_delete(res);
		if(!ok)
		{
			mysql_format(db_handle, qret, sizeof(qret),
				"UPDATE `ownable_cars` SET `owner_id`=%d, `owner_name`='%e' WHERE `id`=%d LIMIT 1",
				return_uid, owner_name, real_db_id);
			res = mysql_query(db_handle, qret, true);
			ok = (cache_affected_rows() > 0);
			cache_delete(res);
		}
	}
	else if(Player[playerid][pFamilyLeader])
	{
		new qret[320];
		mysql_format(db_handle, qret, sizeof(qret),
			"UPDATE `ownable_cars` SET `owner_id`=%d, `owner_name`='%e' WHERE `id`=%d LIMIT 1",
			return_uid, owner_name, real_db_id);
		new Cache:res = mysql_query(db_handle, qret, true);
		ok = (cache_affected_rows() > 0);
		cache_delete(res);
	}

	if(!ok)
		return false;

	Family_FleetSyncRemoveFromFamily(playerid, real_db_id);

	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot != -1) Family_FleetRefreshUsedCount(fslot);

	for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
	{
		if(VehicleInfo[playerid][s][vDBID] != real_db_id) continue;
		if(VehicleInfo[playerid][s][vFamFleetBorrow] || VehicleInfo[playerid][s][vModel] != 0)
			ResetPlayerVehicleSlot(playerid, s);
	}

	new reload_pl = playerid;
	if(tgt != INVALID_PLAYER_ID)
		reload_pl = tgt;
	else if(Player[playerid][pID] != return_uid)
		return true;

	Family_FleetReloadPersonalCars(reload_pl, return_uid);
	return true;
}

static stock bool:Family_FleetCanUse(playerid, need_rank)
{
	if(!IsPlayerConnected(playerid)) return false;
	if(Player[playerid][pFamilyLeader]) return true;
	if(Player[playerid][pFamilyRank] < need_rank) return false;
	return true;
}

static stock Family_GuiOutgoingStr(playerid, const json_str[])
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(json_str[0] == '\0') return 0;
	OnPacketIncomingStr(playerid, FAMILY_GUI_ID, json_str);
	return 1;
}

static stock Family_FleetPushListStr(playerid, garage_flag)
{
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf, "{\"t\":2,\"g\":%d,\"id\":[", garage_flag);
	if(rows == 0)
	{
		strcat(g_FamGuiReplyBuf, "],\"n\":[]}");
		return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
	}
	new tmp[128], ename[64];
	for(new i = 0; i < rows; i++)
	{
		new cid = cache_get_field_content_int(i, "car_db_id", db_handle);
		format(tmp, sizeof tmp, "%s%d", (i > 0) ? (",") : (""), cid);
		strcat(g_FamGuiReplyBuf, tmp);
	}
	strcat(g_FamGuiReplyBuf, "],\"n\":[");
	for(new j = 0; j < rows; j++)
	{
		new mid2 = cache_get_field_content_int(j, "model", db_handle);
		format(ename, sizeof ename, "%s", GetVehicleNameByModel(mid2));
		Family_EscapeJson(ename, ename, sizeof ename);
		format(tmp, sizeof tmp, "%s\"%s\"", (j > 0) ? (",") : (""), ename);
		strcat(g_FamGuiReplyBuf, tmp);
	}
	strcat(g_FamGuiReplyBuf, "]}");
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_FleetSendSelect(playerid, rank, bool:loaded)
{
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf,
		"{\"t\":2,\"s\":1,\"r\":%d,\"d\":%d}", rank, loaded ? 1 : 0);
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_FleetActionAck(playerid)
{
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf, "{\"t\":2,\"s\":2,\"d\":1}");
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_FleetPrepareBorrowSpawn(playerid, car_db_id)
{
	for(new ss = 0; ss < MAX_PLAYER_VEHICLES; ss++)
	{
		if(VehicleInfo[playerid][ss][vDBID] != car_db_id) continue;
		if(VehicleInfo[playerid][ss][vSpawned] && VehicleInfo[playerid][ss][vID] != INVALID_VEHICLE_ID)
		{
			new vid = VehicleInfo[playerid][ss][vID];
			Family_ClearVehicleFleetAccessRank(vid);
			DestroyVehicle(vid);
			InvalidateVehicleOwnerCache(vid);
		}
		ResetPlayerVehicleSlot(playerid, ss);
	}
	new fs = Family_FindFreeVehicleSlot(playerid);
	if(fs == -1) return -1;
	Family_CopyOcCacheToBorrowSlot(playerid, fs, 0);
	return fs;
}

static stock Family_FleetUnloadByDbId(actorid, car_db_id)
{
	for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
	{
		if(!IsPlayerConnected(p)) continue;
		for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
		{
			if(VehicleInfo[p][s][vDBID] != car_db_id) continue;
			if(VehicleInfo[p][s][vFamFleetBorrow])
			{
				new vidb = VehicleInfo[p][s][vID];
				if(vidb != INVALID_VEHICLE_ID)
					Family_ClearVehicleFleetAccessRank(vidb);
				ResetPlayerVehicleSlot(p, s);
				if(actorid != INVALID_PLAYER_ID)
					ShowNotification(actorid, 1, 5, 0, 1, "Транспорт выгружен.", "");
				return 1;
			}
			if(!VehicleInfo[p][s][vSpawned]) continue;
			new vid = VehicleInfo[p][s][vID];
			if(vid != INVALID_VEHICLE_ID && GetVehicleModel(vid) > 0)
			{
				Family_ClearVehicleFleetAccessRank(vid);
				DestroyVehicle(vid);
				InvalidateVehicleOwnerCache(vid);
			}
			VehicleInfo[p][s][vID] = INVALID_VEHICLE_ID;
			VehicleInfo[p][s][vSpawned] = false;
			if(actorid != INVALID_PLAYER_ID)
				ShowNotification(actorid, 1, 5, 0, 1, "Транспорт выгружен.", "");
			return 1;
		}
	}
	return 0;
}

static stock Family_FleetDoSpawn(actor_pid, owner_pid, car_db_id, modelid, c1, c2, Float:wx, Float:wy, Float:wz, Float:wa, min_rank = 1)
{
	if(owner_pid == INVALID_PLAYER_ID)
	{
		Family_Msg(actor_pid, 0xFF6666FF, "Владелец транспорта должен быть в сети.");
		return 0;
	}
	new slot = Family_FindSlotByDbId(owner_pid, car_db_id);
	if(slot == -1)
	{
		for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
		{
			if(VehicleInfo[owner_pid][s][vDBID] != car_db_id) continue;
			slot = s;
			break;
		}
	}
	if(slot == -1)
	{
		Family_Msg(actor_pid, 0xFF6666FF, "Транспорт не найден в памяти. Загрузите его из автопарка ещё раз.");
		return 0;
	}
	if(VehicleInfo[owner_pid][slot][vSpawned])
	{
		new oldv = VehicleInfo[owner_pid][slot][vID];
		if(oldv != INVALID_VEHICLE_ID && GetVehicleModel(oldv) > 0)
		{
			Family_ClearVehicleFleetAccessRank(oldv);
			DestroyVehicle(oldv);
			InvalidateVehicleOwnerCache(oldv);
		}
		VehicleInfo[owner_pid][slot][vID] = INVALID_VEHICLE_ID;
		VehicleInfo[owner_pid][slot][vSpawned] = false;
	}
	VehicleInfo[owner_pid][slot][vPos][0] = wx;
	VehicleInfo[owner_pid][slot][vPos][1] = wy;
	VehicleInfo[owner_pid][slot][vPos][2] = wz;
	VehicleInfo[owner_pid][slot][vPos][3] = wa;
	new vid = CreateVehicle(modelid, wx, wy, wz, wa, c1, c2, -1);
	if(vid == INVALID_VEHICLE_ID)
	{
		Family_Msg(actor_pid, 0xFF6666FF, "Не удалось создать транспорт.");
		return 0;
	}
	VehicleInfo[owner_pid][slot][vID] = vid;
	VehicleInfo[owner_pid][slot][vSpawned] = true;
	VehicleInfo[owner_pid][slot][vLaunchControlOn] = false;
	if(vid > 0 && vid < MAX_VEHICLES)
	{
		gVehOwnerCache[vid] = owner_pid;
		gVehSlotCache[vid] = slot;
		Family_SetVehicleFleetAccessRank(vid, min_rank);
	}
	CarSystem_InitSpawnedVehicle(vid);
	SetVehicleHealth(vid, VehicleInfo[owner_pid][slot][vHealth]);
	if(VehicleInfo[owner_pid][slot][vWheel] > 0)
		AddVehicleComponent(vid, VehicleInfo[owner_pid][slot][vWheel]);
	if(VehicleInfo[owner_pid][slot][vNitro] > 0)
		AddVehicleComponent(vid, 1007 + VehicleInfo[owner_pid][slot][vNitro]);
	ApplyVehicleVisualStateForAll(vid, owner_pid, slot);
	QueueVehicleVisualApplyDeferred(owner_pid, slot, 150);
	QueueVehicleVisualApplyDeferred(owner_pid, slot, 450);
	new q[220];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `ownable_cars` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f WHERE `id`=%d LIMIT 1",
		wx, wy, wz, wa, car_db_id);
	mysql_tquery(db_handle, q, "", "");
	ShowNotification(actor_pid, 1, 5, 0, 1, "Транспорт загружен (тюнинг сохранён в БД).", "");
	return 1;
}

forward Family_DB_FleetList(playerid);
public Family_DB_FleetList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new garage_flag = Family_FleetGarageFlag(playerid);
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows == 0)
	{
		ShowNotification(playerid, 0, 5, 0, 0, "В автопарке семьи нет транспорта.", "");
		SendClientMessage(playerid, 0xE0584BFF, "[Автопарк] Машин нет — добавьте загруженный ТС через /car.");
	}
	return Family_FleetPushListStr(playerid, garage_flag);
}

static stock Family_FleetSendListAsync(playerid)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	new q[400];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `ownable_id` AS `car_db_id`, `model_id` AS `model`\
		 FROM `family_cars` WHERE `family_owner`=%d AND `ownable_id`>0 ORDER BY `id` ASC",
		Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_FleetListCars", "i", playerid);
	return 1;
}

forward Family_DB_FleetListCars(playerid);
public Family_DB_FleetListCars(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
		return Family_FleetPushListStr(playerid, Family_FleetGarageFlag(playerid));
	new q[320];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT ff.`car_db_id`, oc.`model` FROM `family_fleet` ff\
		 INNER JOIN `ownable_cars` oc ON oc.`id` = ff.`car_db_id`\
		 WHERE ff.`family_id` = %d ORDER BY ff.`id` ASC",
		Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_FleetList", "i", playerid);
	return 1;
}

static stock bool:Family_FleetSyncLoadCar(playerid, lookup_id, &need_rank, &real_db_id, &orig_uid,
	&modelid, &c1, &c2, &Float:px, &Float:py, &Float:pz, &Float:pa, &Cache:car_res)
{
	car_res = Cache:0;
	new q[1500];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT COALESCE(ff.`access_rank`, IF(fc.`rang`<1,1,fc.`rang`), 1) AS `access_rank`,\
		 COALESCE(ff.`original_owner_uid`, IFNULL(oc.`owner_id`, 0), 0) AS `original_owner_uid`,\
		 IFNULL(oc.`owner_id`, 0) AS `oc_owner`,\
		 IF(fc.`ownable_id`>0, fc.`ownable_id`, fc.`id`) AS `cid`,\
		 COALESCE(oc.`model`, fc.`model_id`, 400) AS `model`,\
		 COALESCE(oc.`color1`, fc.`color_1`, 1) AS `color1`,\
		 COALESCE(oc.`color2`, fc.`color_2`, 1) AS `color2`,\
		 COALESCE(oc.`x`, fc.`pos_x`, 0.0) AS `x`, COALESCE(oc.`y`, fc.`pos_y`, 0.0) AS `y`,\
		 COALESCE(oc.`z`, fc.`pos_z`, 3.0) AS `z`, COALESCE(oc.`a`, fc.`angle`, 0.0) AS `a`,\
		 IFNULL(oc.`fuel`, 100) AS `fuel`, IFNULL(oc.`health`, 1000.0) AS `health`,\
		 IFNULL(oc.`wheel`, 0) AS `wheel`, IFNULL(oc.`sport`, 0) AS `sport`, IFNULL(oc.`drift`, 0) AS `drift`,\
		 IFNULL(oc.`comfort`, 0) AS `comfort`, IFNULL(oc.`sport_plus`, 0) AS `sport_plus`,\
		 IFNULL(oc.`body_color`, 0) AS `body_color`, IFNULL(oc.`disk_color`, 0) AS `disk_color`,\
		 IFNULL(oc.`wheel_model_id`, 0) AS `wheel_model_id`, IFNULL(oc.`pered_windcolor`, 0) AS `pered_windcolor`,\
		 IFNULL(oc.`zadni_windcolor`, 0) AS `zadni_windcolor`, IFNULL(oc.`neon_main`, 0) AS `neon_main`,\
		 IFNULL(oc.`neon1`, 0) AS `neon1`, IFNULL(oc.`neon2`, 0) AS `neon2`, IFNULL(oc.`lights_color`, 0) AS `lights_color`,\
		 IFNULL(oc.`strob`, 0) AS `strob`, IFNULL(oc.`vinyl`, 0) AS `vinyl`, IFNULL(oc.`nitro`, 0) AS `nitro`,\
		 IFNULL(oc.`dalniysvet`, 0) AS `dalniysvet`, IFNULL(oc.`clearance`, 0) AS `clearance`,\
		 IFNULL(oc.`clearance_front`, 0) AS `clearance_front`, IFNULL(oc.`clearance_rear`, 0) AS `clearance_rear`,\
		 IFNULL(oc.`offset_front`, 0) AS `offset_front`, IFNULL(oc.`offset_rear`, 0) AS `offset_rear`,\
		 IFNULL(oc.`camber_front`, 0) AS `camber_front`, IFNULL(oc.`camber_rear`, 0) AS `camber_rear`,\
		 IFNULL(oc.`wheel_width_front`, 0) AS `wheel_width_front`, IFNULL(oc.`wheel_width_rear`, 0) AS `wheel_width_rear`,\
		 IFNULL(oc.`wheel_radius`, 0) AS `wheel_radius`, IFNULL(oc.`hydra`, 0) AS `hydra`, IFNULL(oc.`pnevmo`, 0) AS `pnevmo`,\
		 IFNULL(oc.`plate_type`, 0) AS `plate_type`, IFNULL(oc.`plate_number`, '') AS `plate_number`,\
		 IFNULL(oc.`plate_region`, '') AS `plate_region`, IFNULL(oc.`price`, 0) AS `price`\
		 FROM `family_cars` fc\
		 LEFT JOIN `ownable_cars` oc ON oc.`id` = fc.`ownable_id` AND fc.`ownable_id` > 0\
		 LEFT JOIN `family_fleet` ff ON ff.`car_db_id` = fc.`ownable_id` AND ff.`family_id` = fc.`family_owner`\
		 WHERE fc.`family_owner` = %d AND (fc.`ownable_id` = %d OR fc.`id` = %d) LIMIT 1",
		Player[playerid][pFamilyId], lookup_id, lookup_id);
	car_res = mysql_query(db_handle, q, true);
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows == 0)
	{
		cache_delete(car_res);
		car_res = Cache:0;
		mysql_format(db_handle, q, sizeof(q),
			"SELECT ff.`access_rank`, ff.`original_owner_uid`, oc.`owner_id` AS `oc_owner`, oc.`id` AS `cid`,\
			 oc.`model`, oc.`color1`, oc.`color2`, oc.`x`, oc.`y`, oc.`z`, oc.`a`, oc.`fuel`, oc.`health`,\
			 oc.`wheel`, oc.`sport`, oc.`drift`, oc.`comfort`, oc.`sport_plus`, oc.`body_color`, oc.`disk_color`,\
			 oc.`wheel_model_id`, oc.`pered_windcolor`, oc.`zadni_windcolor`, oc.`neon_main`, oc.`neon1`, oc.`neon2`,\
			 oc.`lights_color`, oc.`strob`, oc.`vinyl`, oc.`nitro`, oc.`dalniysvet`, oc.`clearance`,\
			 oc.`clearance_front`, oc.`clearance_rear`, oc.`offset_front`, oc.`offset_rear`, oc.`camber_front`,\
			 oc.`camber_rear`, oc.`wheel_width_front`, oc.`wheel_width_rear`, oc.`wheel_radius`, oc.`hydra`, oc.`pnevmo`,\
			 oc.`plate_type`, oc.`plate_number`, oc.`plate_region`, oc.`price`\
			 FROM `family_fleet` ff INNER JOIN `ownable_cars` oc ON oc.`id` = ff.`car_db_id`\
			 WHERE ff.`car_db_id` = %d AND ff.`family_id` = %d LIMIT 1",
			lookup_id, Player[playerid][pFamilyId]);
		car_res = mysql_query(db_handle, q, true);
		cache_get_data(rows, fields, db_handle);
	}
	if(rows == 0)
	{
		if(car_res) cache_delete(car_res);
		car_res = Cache:0;
		return false;
	}
	need_rank = cache_get_field_content_int(0, "access_rank", db_handle);
	if(need_rank < 1) need_rank = 1;
	if(need_rank > FAMILY_FLEET_ACCESS_MAX) need_rank = FAMILY_FLEET_ACCESS_MAX;
	real_db_id = cache_get_field_content_int(0, "cid", db_handle);
	if(real_db_id <= 0) real_db_id = lookup_id;
	orig_uid = cache_get_field_content_int(0, "original_owner_uid", db_handle);
	if(orig_uid <= 0)
	{
		new oc_owner = cache_get_field_content_int(0, "oc_owner", db_handle);
		if(oc_owner > 0) orig_uid = oc_owner;
	}
	modelid = cache_get_field_content_int(0, "model", db_handle);
	c1 = cache_get_field_content_int(0, "color1", db_handle);
	c2 = cache_get_field_content_int(0, "color2", db_handle);
	px = cache_get_field_content_float(0, "x", db_handle);
	py = cache_get_field_content_float(0, "y", db_handle);
	pz = cache_get_field_content_float(0, "z", db_handle);
	pa = cache_get_field_content_float(0, "a", db_handle);
	return true;
}

static stock Family_FleetReleaseCarCache(&Cache:car_res)
{
	if(car_res)
	{
		cache_delete(car_res);
		car_res = Cache:0;
	}
	return 1;
}

static stock Family_FleetRunActionSync(playerid, car_db_id, action_id, acc_has, acc_val)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	if(action_id == 5)
	{
		ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "В разработке", "");
		return 1;
	}
	if(action_id == 6)
	{
		new Float:fx, Float:fy, Float:fz, Float:fa;
		GetPlayerPos(playerid, fx, fy, fz);
		GetPlayerFacingAngle(playerid, fa);
		SetPVarFloat(playerid, "fam_sp_x", fx + 3.0);
		SetPVarFloat(playerid, "fam_sp_y", fy + 3.0);
		SetPVarFloat(playerid, "fam_sp_z", fz);
		SetPVarFloat(playerid, "fam_sp_a", fa);
	}
	new lookup_id = car_db_id;
	new resolved = GetPVarInt(playerid, "fam_fleet_car");
	if(resolved > 0) lookup_id = resolved;

	new need_rank, real_db_id, orig_uid, modelid, c1, c2;
	new Float:px, Float:py, Float:pz, Float:pa;
	new Cache:car_res = Cache:0;
	if(!Family_FleetSyncLoadCar(playerid, lookup_id, need_rank, real_db_id, orig_uid, modelid, c1, c2, px, py, pz, pa, car_res))
	{
		ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Действие недоступно для этого ТС.", "");
		return Family_Msg(playerid, 0xFF6666FF, "Действие недоступно для этого транспорта."), 1;
	}
	if(action_id == 3 && !Player[playerid][pFamilyLeader])
	{
		Family_FleetReleaseCarCache(car_res);
		return Family_Msg(playerid, 0xFF6666FF, "Менять ранг доступа может только лидер."), 1;
	}
	if(action_id != 3 && action_id != 9 && !Family_FleetCanUse(playerid, need_rank))
	{
		Family_FleetReleaseCarCache(car_res);
		return Family_FleetNotifyRankDenied(playerid);
	}

	switch(action_id)
	{
		case 0:
		{
			if(px == 0.0 && py == 0.0)
			{
				Family_FleetReleaseCarCache(car_res);
				return Family_Msg(playerid, 0xFF6666FF, "У транспорта нет сохранённой позиции."), 1;
			}
			SetGPSMarker(playerid, px, py, pz);
			ShowNotification(playerid, 1, 5, 0, 1, "Метка GPS установлена.", "");
			Family_FleetReleaseCarCache(car_res);
			return Family_FleetActionAck(playerid);
		}
		case 1:
		{
			if(Family_FleetPrepareBorrowSpawn(playerid, real_db_id) == -1)
			{
				Family_FleetReleaseCarCache(car_res);
				return Family_Msg(playerid, 0xFF6666FF, "Нет свободного слота для семейного транспорта."), 1;
			}
			Family_FleetReleaseCarCache(car_res);
			if(!Family_FleetDoSpawn(playerid, playerid, real_db_id, modelid, c1, c2, px, py, pz, pa, need_rank))
				return 1;
			Family_FleetActionAck(playerid);
			return Family_FleetSendSelect(playerid, need_rank, true);
		}
		case 6:
		{
			new Float:sx = GetPVarFloat(playerid, "fam_sp_x");
			new Float:sy = GetPVarFloat(playerid, "fam_sp_y");
			new Float:sz = GetPVarFloat(playerid, "fam_sp_z");
			new Float:sa = GetPVarFloat(playerid, "fam_sp_a");
			DeletePVar(playerid, "fam_sp_x");
			DeletePVar(playerid, "fam_sp_y");
			DeletePVar(playerid, "fam_sp_z");
			DeletePVar(playerid, "fam_sp_a");
			if(Family_FleetPrepareBorrowSpawn(playerid, real_db_id) == -1)
			{
				Family_FleetReleaseCarCache(car_res);
				return Family_Msg(playerid, 0xFF6666FF, "Нет свободного слота для семейного транспорта."), 1;
			}
			Family_FleetReleaseCarCache(car_res);
			if(!Family_FleetDoSpawn(playerid, playerid, real_db_id, modelid, c1, c2, sx, sy, sz, sa, need_rank))
				return 1;
			Family_FleetActionAck(playerid);
			return Family_FleetSendSelect(playerid, need_rank, true);
		}
		case 2:
		{
			Family_FleetReleaseCarCache(car_res);
			new return_uid = orig_uid;
			if(return_uid <= 0) return_uid = Player[playerid][pID];
			new bool:allowed = (Player[playerid][pFamilyLeader] || Player[playerid][pID] == return_uid);
			if(!allowed)
				return Family_FleetNotifyDenied(playerid);
			if(!Family_FleetReturnCarToOwner(playerid, real_db_id, orig_uid))
			{
				ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Не удалось вернуть транспорт владельцу.", "");
				return Family_Msg(playerid, 0xFF6666FF, "Не удалось вернуть транспорт в личный гараж."), 1;
			}
			if(Player[playerid][pID] == return_uid)
			{
				ShowNotification(playerid, 1, 5, 0, 1, "Транспорт возвращён в ваш /car.", "");
				Family_Msg(playerid, 0x88FF88FF, "Транспорт снят с семейного автопарка и снова в личном гараже (/car).");
			}
			else
			{
				ShowNotification(playerid, 1, 5, 0, 1, "Транспорт возвращён владельцу.", "");
				Family_Msg(playerid, 0x88FF88FF, "Транспорт возвращён владельцу в личный гараж.");
			}
			Family_FleetActionAck(playerid);
			Family_FleetSendListAsync(playerid);
			return 1;
		}
		case 4:
		{
			Family_FleetReleaseCarCache(car_res);
			Family_FleetUnloadByDbId(playerid, real_db_id);
			Family_FleetActionAck(playerid);
			return Family_FleetSendSelect(playerid, need_rank, false);
		}
		case 9:
		{
			Family_FleetReleaseCarCache(car_res);
			if(!Player[playerid][pFamilyLeader])
				return Family_Msg(playerid, 0xFF6666FF, "Вернуть машину в личный гараж может только лидер семьи."), 1;
			if(orig_uid <= 0)
				return Family_Msg(playerid, 0xFF6666FF, "Не удалось определить прежнего владельца."), 1;
			if(!Family_FleetReturnCarToOwner(playerid, real_db_id, orig_uid))
			{
				ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Не удалось вернуть транспорт владельцу.", "");
				return Family_Msg(playerid, 0xFF6666FF, "Не удалось вернуть транспорт в личный гараж."), 1;
			}
			ShowNotification(playerid, 1, 5, 0, 1, "Авто возвращено владельцу", "");
			Family_Msg(playerid, 0x88FF88FF, "Транспорт возвращён владельцу в личный гараж.");
			return Family_FleetActionAck(playerid);
		}
		case 3:
		{
			Family_FleetReleaseCarCache(car_res);
			if(!acc_has) return 1;
			new delta = (acc_val == 0) ? (-1) : (1);
			new nr = need_rank + delta;
			if(nr < 1) nr = 1;
			if(nr > FAMILY_FLEET_ACCESS_MAX) nr = FAMILY_FLEET_ACCESS_MAX;
			new q[160];
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family_fleet` SET `access_rank`=%d WHERE `car_db_id`=%d AND `family_id`=%d LIMIT 1",
				nr, real_db_id, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "", "");
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family_cars` SET `rang`=%d WHERE `ownable_id`=%d AND `family_owner`=%d LIMIT 1",
				nr, real_db_id, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "", "");
			Family_FleetActionAck(playerid);
			return Family_FleetSendSelect(playerid, nr, Family_IsCarDbSpawned(real_db_id));
		}
		case 7:
		{
			Family_FleetReleaseCarCache(car_res);
			new Float:rx = 2491.3955, Float:ry = -760.3754, Float:rz = 11.3192, Float:ra = 359.3163;
			new q[200];
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `ownable_cars` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f WHERE `id`=%d LIMIT 1",
				rx, ry, rz, ra, real_db_id);
			mysql_tquery(db_handle, q, "", "");
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family_cars` SET `pos_x`=%f,`pos_y`=%f,`pos_z`=%f,`angle`=%f WHERE `ownable_id`=%d AND `family_owner`=%d LIMIT 1",
				rx, ry, rz, ra, real_db_id, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "", "");
			ShowNotification(playerid, 1, 5, 0, 1, "Парковка сброшена на стандартную точку.", "");
			return Family_FleetActionAck(playerid);
		}
	}
	Family_FleetReleaseCarCache(car_res);
	return Family_Msg(playerid, 0xFF6666FF, "Неизвестное действие."), 1;
}

static stock Family_FleetClearActionPvars(playerid)
{
	DeletePVar(playerid, "fam_act");
	DeletePVar(playerid, "fam_cardb");
	DeletePVar(playerid, "fam_acch");
	DeletePVar(playerid, "fam_accv");
	DeletePVar(playerid, "fam_act_stage");
}

static stock Family_FleetQueryActionFleet(playerid, car_db_id)
{
	new q[1500];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT ff.`access_rank`, ff.`original_owner_uid`, oc.`owner_id` AS `oc_owner`, oc.`id` AS `cid`,\
		 oc.`model`, oc.`color1`, oc.`color2`, oc.`x`, oc.`y`, oc.`z`, oc.`a`, oc.`fuel`, oc.`health`,\
		 oc.`wheel`, oc.`sport`, oc.`drift`, oc.`comfort`, oc.`sport_plus`, oc.`body_color`, oc.`disk_color`,\
		 oc.`wheel_model_id`, oc.`pered_windcolor`, oc.`zadni_windcolor`, oc.`neon_main`, oc.`neon1`, oc.`neon2`,\
		 oc.`lights_color`, oc.`strob`, oc.`vinyl`, oc.`nitro`, oc.`dalniysvet`, oc.`clearance`,\
		 oc.`clearance_front`, oc.`clearance_rear`, oc.`offset_front`, oc.`offset_rear`, oc.`camber_front`,\
		 oc.`camber_rear`, oc.`wheel_width_front`, oc.`wheel_width_rear`, oc.`wheel_radius`, oc.`hydra`,\
		 oc.`pnevmo`, oc.`plate_type`, oc.`plate_number`, oc.`plate_region`, oc.`price`\
		 FROM `family_fleet` ff INNER JOIN `ownable_cars` oc ON oc.`id` = ff.`car_db_id`\
		 WHERE ff.`car_db_id` = %d AND ff.`family_id` = %d LIMIT 1",
		car_db_id, Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_FleetAction", "i", playerid);
	return 1;
}

static stock Family_FleetQueryActionCars(playerid, car_db_id)
{
	new q[1500];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT COALESCE(ff.`access_rank`, IF(fc.`rang`<1,1,fc.`rang`), 1) AS `access_rank`,\
		 COALESCE(ff.`original_owner_uid`, IFNULL(oc.`owner_id`, 0), 0) AS `original_owner_uid`,\
		 IFNULL(oc.`owner_id`, 0) AS `oc_owner`,\
		 IF(fc.`ownable_id`>0, fc.`ownable_id`, fc.`id`) AS `cid`,\
		 COALESCE(oc.`model`, fc.`model_id`, 400) AS `model`,\
		 COALESCE(oc.`color1`, fc.`color_1`, 1) AS `color1`,\
		 COALESCE(oc.`color2`, fc.`color_2`, 1) AS `color2`,\
		 COALESCE(oc.`x`, fc.`pos_x`, 0.0) AS `x`, COALESCE(oc.`y`, fc.`pos_y`, 0.0) AS `y`,\
		 COALESCE(oc.`z`, fc.`pos_z`, 3.0) AS `z`, COALESCE(oc.`a`, fc.`angle`, 0.0) AS `a`,\
		 IFNULL(oc.`fuel`, 100) AS `fuel`, IFNULL(oc.`health`, 1000.0) AS `health`,\
		 IFNULL(oc.`wheel`, 0) AS `wheel`, IFNULL(oc.`sport`, 0) AS `sport`, IFNULL(oc.`drift`, 0) AS `drift`,\
		 IFNULL(oc.`comfort`, 0) AS `comfort`, IFNULL(oc.`sport_plus`, 0) AS `sport_plus`,\
		 IFNULL(oc.`body_color`, 0) AS `body_color`, IFNULL(oc.`disk_color`, 0) AS `disk_color`,\
		 IFNULL(oc.`wheel_model_id`, 0) AS `wheel_model_id`, IFNULL(oc.`pered_windcolor`, 0) AS `pered_windcolor`,\
		 IFNULL(oc.`zadni_windcolor`, 0) AS `zadni_windcolor`, IFNULL(oc.`neon_main`, 0) AS `neon_main`,\
		 IFNULL(oc.`neon1`, 0) AS `neon1`, IFNULL(oc.`neon2`, 0) AS `neon2`, IFNULL(oc.`lights_color`, 0) AS `lights_color`,\
		 IFNULL(oc.`strob`, 0) AS `strob`, IFNULL(oc.`vinyl`, 0) AS `vinyl`, IFNULL(oc.`nitro`, 0) AS `nitro`,\
		 IFNULL(oc.`dalniysvet`, 0) AS `dalniysvet`, IFNULL(oc.`clearance`, 0) AS `clearance`,\
		 IFNULL(oc.`clearance_front`, 0) AS `clearance_front`, IFNULL(oc.`clearance_rear`, 0) AS `clearance_rear`,\
		 IFNULL(oc.`offset_front`, 0) AS `offset_front`, IFNULL(oc.`offset_rear`, 0) AS `offset_rear`,\
		 IFNULL(oc.`camber_front`, 0) AS `camber_front`, IFNULL(oc.`camber_rear`, 0) AS `camber_rear`,\
		 IFNULL(oc.`wheel_width_front`, 0) AS `wheel_width_front`, IFNULL(oc.`wheel_width_rear`, 0) AS `wheel_width_rear`,\
		 IFNULL(oc.`wheel_radius`, 0) AS `wheel_radius`, IFNULL(oc.`hydra`, 0) AS `hydra`, IFNULL(oc.`pnevmo`, 0) AS `pnevmo`,\
		 IFNULL(oc.`plate_type`, 0) AS `plate_type`, IFNULL(oc.`plate_number`, '') AS `plate_number`,\
		 IFNULL(oc.`plate_region`, '') AS `plate_region`, IFNULL(oc.`price`, 0) AS `price`\
		 FROM `family_cars` fc\
		 LEFT JOIN `ownable_cars` oc ON oc.`id` = fc.`ownable_id` AND fc.`ownable_id` > 0\
		 LEFT JOIN `family_fleet` ff ON ff.`car_db_id` = fc.`ownable_id` AND ff.`family_id` = fc.`family_owner`\
		 WHERE fc.`family_owner` = %d AND (fc.`ownable_id` = %d OR fc.`id` = %d) LIMIT 1",
		Player[playerid][pFamilyId], car_db_id, car_db_id);
	mysql_tquery(db_handle, q, "Family_DB_FleetAction", "i", playerid);
	return 1;
}

forward Family_DB_FleetSelect(playerid);
public Family_DB_FleetSelect(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new car_db_id = GetPVarInt(playerid, "fam_selcar");
	if(rows > 0)
	{
		DeletePVar(playerid, "fam_selcar");
		new rank = cache_get_field_content_int(0, "access_rank", db_handle);
		if(rank < 1) rank = 1;
		if(rank > FAMILY_FLEET_ACCESS_MAX) rank = FAMILY_FLEET_ACCESS_MAX;
		SetPVarInt(playerid, "fam_fleet_car", car_db_id);
		new bool:loaded = Family_IsCarDbSpawned(car_db_id);
		return Family_FleetSendSelect(playerid, rank, loaded);
	}
	new q[320];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT IF(`rang`<1,1,`rang`) AS `access_rank`, `ownable_id` FROM `family_cars`\
		 WHERE `family_owner`=%d AND (`ownable_id`=%d OR `id`=%d) LIMIT 1",
		Player[playerid][pFamilyId], car_db_id, car_db_id);
	mysql_tquery(db_handle, q, "Family_DB_FleetSelectCars", "i", playerid);
	return 1;
}

forward Family_DB_FleetSelectCars(playerid);
public Family_DB_FleetSelectCars(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new car_db_id = GetPVarInt(playerid, "fam_selcar");
	DeletePVar(playerid, "fam_selcar");
	new rank = 1;
	new check_id = car_db_id;
	if(rows > 0)
	{
		rank = cache_get_field_content_int(0, "access_rank", db_handle);
		if(rank < 1) rank = 1;
		new oid = cache_get_field_content_int(0, "ownable_id", db_handle);
		if(oid > 0) check_id = oid;
	}
	if(rank > FAMILY_FLEET_ACCESS_MAX) rank = FAMILY_FLEET_ACCESS_MAX;
	SetPVarInt(playerid, "fam_fleet_car", check_id);
	new bool:loaded = Family_IsCarDbSpawned(check_id);
	return Family_FleetSendSelect(playerid, rank, loaded);
}

static stock Family_FleetRequestSelect(playerid, car_db_id)
{
	if(car_db_id <= 0) return 0;
	SetPVarInt(playerid, "fam_selcar", car_db_id);
	new q[256];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `access_rank` FROM `family_fleet` WHERE `family_id` = %d AND `car_db_id` = %d LIMIT 1",
		Player[playerid][pFamilyId], car_db_id);
	mysql_tquery(db_handle, q, "Family_DB_FleetSelect", "i", playerid);
	return 1;
}

forward Family_DB_FleetAction(playerid);
public Family_DB_FleetAction(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new action_id = GetPVarInt(playerid, "fam_act");
	new car_db_id = GetPVarInt(playerid, "fam_cardb");
	new acc_has = GetPVarInt(playerid, "fam_acch");
	new acc_val = GetPVarInt(playerid, "fam_accv");
	new stage = GetPVarInt(playerid, "fam_act_stage");

	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows == 0)
	{
		if(stage == 0)
		{
			SetPVarInt(playerid, "fam_act_stage", 1);
			return Family_FleetQueryActionFleet(playerid, car_db_id);
		}
		Family_FleetClearActionPvars(playerid);
		ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Действие недоступно для этого ТС.", "");
		return Family_Msg(playerid, 0xFF6666FF, "Действие недоступно для этого транспорта."), 1;
	}

	new need_rank = cache_get_field_content_int(0, "access_rank", db_handle);
	if(need_rank < 1) need_rank = 1;
	if(need_rank > FAMILY_FLEET_ACCESS_MAX) need_rank = FAMILY_FLEET_ACCESS_MAX;
	new real_db_id = cache_get_field_content_int(0, "cid", db_handle);
	if(real_db_id <= 0) real_db_id = car_db_id;

	new modelid = cache_get_field_content_int(0, "model", db_handle);
	new c1 = cache_get_field_content_int(0, "color1", db_handle);
	new c2 = cache_get_field_content_int(0, "color2", db_handle);
	new Float:px = cache_get_field_content_float(0, "x", db_handle);
	new Float:py = cache_get_field_content_float(0, "y", db_handle);
	new Float:pz = cache_get_field_content_float(0, "z", db_handle);
	new Float:pa = cache_get_field_content_float(0, "a", db_handle);

	Family_FleetClearActionPvars(playerid);

	if(action_id == 3 && !Player[playerid][pFamilyLeader])
		return Family_Msg(playerid, 0xFF6666FF, "Менять ранг доступа может только лидер."), 1;
	if(action_id != 3 && action_id != 9 && !Family_FleetCanUse(playerid, need_rank))
		return Family_FleetNotifyRankDenied(playerid);

	switch(action_id)
	{
		case 0:
		{
			SetGPSMarker(playerid, px, py, pz);
			ShowNotification(playerid, 1, 5, 0, 1, "Метка GPS установлена.", "");
			return Family_FleetActionAck(playerid);
		}
		case 1:
		{
			if(Family_FleetPrepareBorrowSpawn(playerid, real_db_id) == -1)
				return Family_Msg(playerid, 0xFF6666FF, "Нет свободного слота для семейного транспорта."), 1;
			if(Family_FleetDoSpawn(playerid, playerid, real_db_id, modelid, c1, c2, px, py, pz, pa, need_rank))
				return Family_FleetActionAck(playerid);
			return 1;
		}
		case 6:
		{
			new Float:sx = GetPVarFloat(playerid, "fam_sp_x");
			new Float:sy = GetPVarFloat(playerid, "fam_sp_y");
			new Float:sz = GetPVarFloat(playerid, "fam_sp_z");
			new Float:sa = GetPVarFloat(playerid, "fam_sp_a");
			DeletePVar(playerid, "fam_sp_x");
			DeletePVar(playerid, "fam_sp_y");
			DeletePVar(playerid, "fam_sp_z");
			DeletePVar(playerid, "fam_sp_a");
			if(Family_FleetPrepareBorrowSpawn(playerid, real_db_id) == -1)
				return Family_Msg(playerid, 0xFF6666FF, "Нет свободного слота для семейного транспорта."), 1;
			if(Family_FleetDoSpawn(playerid, playerid, real_db_id, modelid, c1, c2, sx, sy, sz, sa, need_rank))
				return Family_FleetActionAck(playerid);
			return 1;
		}
		case 2:
		{
			new orig_uid2 = cache_get_field_content_int(0, "original_owner_uid", db_handle);
			new return_uid = orig_uid2;
			if(return_uid <= 0) return_uid = Player[playerid][pID];
			new bool:allowed = (Player[playerid][pFamilyLeader] || Player[playerid][pID] == return_uid);
			if(!allowed)
				return Family_FleetNotifyDenied(playerid);
			if(!Family_FleetReturnCarToOwner(playerid, real_db_id, orig_uid2))
			{
				ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Не удалось вернуть транспорт владельцу.", "");
				return Family_Msg(playerid, 0xFF6666FF, "Не удалось вернуть транспорт в личный гараж."), 1;
			}
			if(Player[playerid][pID] == return_uid)
				Family_Msg(playerid, 0x88FF88FF, "Транспорт снят с семейного автопарка и снова в личном гараже (/car).");
			else
				Family_Msg(playerid, 0x88FF88FF, "Транспорт возвращён владельцу в личный гараж.");
			ShowNotification(playerid, 1, 5, 0, 1, "Транспорт возвращён владельцу.", "");
			return Family_FleetActionAck(playerid);
		}
		case 4:
		{
			Family_FleetUnloadByDbId(playerid, real_db_id);
			return Family_FleetActionAck(playerid);
		}
		case 9:
		{
			if(!Player[playerid][pFamilyLeader])
				return Family_Msg(playerid, 0xFF6666FF, "Вернуть машину в личный гараж может только лидер семьи."), 1;
			new orig_uid = cache_get_field_content_int(0, "original_owner_uid", db_handle);
			if(orig_uid <= 0)
				return Family_Msg(playerid, 0xFF6666FF, "Не удалось определить прежнего владельца."), 1;
			Family_FleetUnloadByDbId(INVALID_PLAYER_ID, real_db_id);
			new qret[320];
			mysql_format(db_handle, qret, sizeof(qret),
				"UPDATE `ownable_cars` oc INNER JOIN `players` p ON p.`id`=%d SET oc.`owner_id`=%d, oc.`owner_name`=p.`name` WHERE oc.`id`=%d AND oc.`owner_id`=0 LIMIT 1",
				orig_uid, orig_uid, real_db_id);
			mysql_tquery(db_handle, qret, "Family_DB_OnFleetReturnOwner", "iii", playerid, orig_uid, real_db_id);
			return 1;
		}
		case 3:
		{
			if(!acc_has) return 1;
			new delta = (acc_val == 0) ? (-1) : (1);
			new nr = need_rank + delta;
			if(nr < 1) nr = 1;
			if(nr > FAMILY_FLEET_ACCESS_MAX) nr = FAMILY_FLEET_ACCESS_MAX;
			new q[160];
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family_fleet` SET `access_rank`=%d WHERE `car_db_id`=%d AND `family_id`=%d LIMIT 1",
				nr, real_db_id, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "", "");
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family_cars` SET `rang`=%d WHERE `ownable_id`=%d AND `family_owner`=%d LIMIT 1",
				nr, real_db_id, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "", "");
			return Family_FleetActionAck(playerid);
		}
		case 7:
		{
			new Float:rx = 2491.3955, Float:ry = -760.3754, Float:rz = 11.3192, Float:ra = 359.3163;
			new q[200];
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `ownable_cars` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f WHERE `id`=%d LIMIT 1",
				rx, ry, rz, ra, real_db_id);
			mysql_tquery(db_handle, q, "", "");
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family_cars` SET `pos_x`=%f,`pos_y`=%f,`pos_z`=%f,`angle`=%f WHERE `ownable_id`=%d AND `family_owner`=%d LIMIT 1",
				rx, ry, rz, ra, real_db_id, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "", "");
			ShowNotification(playerid, 1, 5, 0, 1, "Парковка сброшена на стандартную точку.", "");
			return Family_FleetActionAck(playerid);
		}
	}
	return Family_Msg(playerid, 0xFF6666FF, "Неизвестное действие."), 1;
}

public Family_DB_OnFleetReturnOwner(playerid, orig_uid, car_db_id)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!cache_affected_rows())
	{
		Family_Msg(playerid, 0xFF6666FF, "Не удалось вернуть транспорт (запись не найдена или уже возвращена).");
		return 1;
	}
	new qd[200];
	mysql_format(db_handle, qd, sizeof(qd),
		"DELETE FROM `family_fleet` WHERE `car_db_id`=%d AND `family_id`=%d LIMIT 1",
		car_db_id, Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, qd, "", "");
	Family_FleetDeleteFamilyCarsRow(car_db_id);
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot != -1) Family_FleetRefreshUsedCount(fslot);
	new tgt = Family_FindPidFromUid(orig_uid);
	if(tgt != INVALID_PLAYER_ID)
	{
		new ql[192];
		mysql_format(db_handle, ql, sizeof(ql), "SELECT * FROM `ownable_cars` WHERE `owner_id`=%d ORDER BY `id` ASC", orig_uid);
		mysql_tquery(db_handle, ql, "LoadPlayerVehicles", "i", tgt);
	}
	Family_Msg(playerid, 0x88FF88FF, "Транспорт возвращён владельцу в личный гараж.");
	ShowNotification(playerid, 1, 5, 0, 1, "Авто возвращено владельцу", "");
	Family_FleetActionAck(playerid);
	return 1;
}

static stock Family_FleetBeginAction(playerid, car_db_id, action_id, acc_has, acc_val)
{
	return Family_FleetRunActionSync(playerid, car_db_id, action_id, acc_has, acc_val);
}

static stock Family_GetRankLabelForGui(playerid, rank, dest[], len)
{
	if(rank == FAMILY_RANK_LEADER)
		return format(dest, len, "Лидер"), 1;
	if(rank >= 1 && rank <= 4)
	{
		new key[12];
		format(key, sizeof key, "fam_rn_%d", rank);
		GetPVarString(playerid, key, dest, len);
		if(strlen(dest)) return 1;
	}
	return format(dest, len, "Ранг %d", rank), 1;
}

static stock Family_SendSettingsStart(playerid)
{
	new Node:response = JSON_Object();
	JSON_SetInt(response, "t", 5);
	JSON_SetInt(response, "id", 1);
	JSON_SetInt(response, "st", 1);
	JSON_SetInt(response, "cl", GetPVarInt(playerid, "fam_col_idx"));

	new rnk[32];
	Family_GetRankLabelForGui(playerid, 1, rnk, sizeof rnk);
	new Node:rnames = JSON_Array(JSON_String(rnk));
	for(new i = 2; i <= FAMILY_RANK_SLOTS; i++)
	{
		Family_GetRankLabelForGui(playerid, i, rnk, sizeof rnk);
		rnames = JSON_Append(rnames, JSON_String(rnk));
	}
	new Node:rp = JSON_Array(JSON_Int(127));
	for(new j = 2; j <= FAMILY_RANK_SLOTS; j++)
		rp = JSON_Append(rp, JSON_Int(127));
	JSON_SetArray(response, "r", rnames);
	JSON_SetArray(response, "rp", rp);
	return Family_GuiSendNode(playerid, response);
}

static stock Family_SendStoreSafeParams(playerid)
{
	new fm = GetPVarInt(playerid, "fam_money");
	new mat = GetPVarInt(playerid, "fam_mat");
	new masks = GetPVarInt(playerid, "fam_masks");
	new fuel = GetPVarInt(playerid, "fam_fuel");
	new armor = GetPVarInt(playerid, "fam_armor");
	new Node:np = JSON_Array(JSON_Int(fm), JSON_Int(mat), JSON_Int(masks), JSON_Int(fuel), JSON_Int(armor));
	new Node:response = JSON_Object();
	JSON_SetInt(response, "t", 5);
	JSON_SetInt(response, "id", 3);
	JSON_SetInt(response, "r", 0);
	JSON_SetArray(response, "np", np);
	return Family_GuiSendNode(playerid, response);
}

static stock Family_SendPlayerActionAck(playerid)
{
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf, "{\"t\":5,\"id\":2,\"s\":2,\"r\":1}");
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_PlayerListRequest(playerid)
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	new q[380];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT p.`id`, p.`name`, p.`family_rang` AS `rank` FROM `players` p\
		 WHERE p.`family_id` = %d ORDER BY p.`family_rang` ASC, p.`name` ASC",
		Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_OnGuiPlayerList", "i", playerid);
	return 1;
}

forward Family_DB_OnGuiPlayerList(playerid);
public Family_DB_OnGuiPlayerList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new Node:np;
	new Node:rs;
	if(rows == 0)
	{
		np = JSON_Array(JSON_String("-"));
		rs = JSON_Array(JSON_Int(1), JSON_Int(0));
	}
	else
	{
		new uid0 = cache_get_field_content_int(0, "id", db_handle);
		new name0[MAX_PLAYER_NAME];
		cache_get_field_content(0, "name", name0, db_handle, sizeof name0);
		new rank0 = cache_get_field_content_int(0, "rank", db_handle);
		new st0 = Family_UidIsOnline(uid0);
		np = JSON_Array(JSON_String(name0));
		rs = JSON_Array(JSON_Int(rank0), JSON_Int(st0));
		for(new i = 1; i < rows; i++)
		{
			new uid = cache_get_field_content_int(i, "id", db_handle);
			new pname[MAX_PLAYER_NAME];
			cache_get_field_content(i, "name", pname, db_handle, sizeof pname);
			new rnk = cache_get_field_content_int(i, "rank", db_handle);
			new st = Family_UidIsOnline(uid);
			np = JSON_Append(np, JSON_String(pname));
			rs = JSON_Append(rs, JSON_Int(rnk));
			rs = JSON_Append(rs, JSON_Int(st));
		}
	}
	new Node:response = JSON_Object();
	JSON_SetInt(response, "t", 5);
	JSON_SetInt(response, "id", 2);
	JSON_SetArray(response, "np", np);
	JSON_SetArray(response, "rs", rs);
	return Family_GuiSendNode(playerid, response);
}

static stock Family_PlayerDetailRequest(playerid, nick[])
{
	if(Player[playerid][pFamilyId] == 0) return 0;
	SetPVarString(playerid, "fam_qnick", nick);
	new q[400];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT p.`id`, p.`level`, p.`skin`, p.`family_rang` AS `rank`, (p.`family_rang`>=5) AS `is_leader` FROM `players` p\
		 WHERE p.`family_id` = %d AND p.`name` = '%e' LIMIT 1",
		Player[playerid][pFamilyId], nick);
	mysql_tquery(db_handle, q, "Family_DB_OnGuiPlayerDetail", "i", playerid);
	return 1;
}

forward Family_DB_OnGuiPlayerDetail(playerid);
public Family_DB_OnGuiPlayerDetail(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new qnick[MAX_PLAYER_NAME];
	GetPVarString(playerid, "fam_qnick", qnick, sizeof qnick);
	DeletePVar(playerid, "fam_qnick");
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows == 0)
		return Family_Msg(playerid, 0xFF6666FF, "Игрок не найден в семье."), 1;
	new uid = cache_get_field_content_int(0, "id", db_handle);
	new lvl = cache_get_field_content_int(0, "level", db_handle);
	new skin = cache_get_field_content_int(0, "skin", db_handle);
	new rank = cache_get_field_content_int(0, "rank", db_handle);
	SetPVarInt(playerid, "fam_muid", uid);
	SetPVarString(playerid, "fam_mgmt_nick", qnick);
	new rn[40];
	format(rn, sizeof rn, "{FFFFFF}Ранг %d", rank);
	new Node:response = JSON_Object();
	JSON_SetInt(response, "t", 5);
	JSON_SetInt(response, "id", 2);
	JSON_SetInt(response, "s", 1);
	JSON_SetInt(response, "sk", skin);
	JSON_SetInt(response, "rb", lvl);
	JSON_SetInt(response, "rv", 0);
	JSON_SetInt(response, "rp", 0);
	JSON_SetInt(response, "m", 0);
	JSON_SetString(response, "rn", rn, strlen(rn));
	return Family_GuiSendNode(playerid, response);
}

static stock Family_HandlePlayerAction(playerid, Node:json)
{
	if(!Player[playerid][pFamilyLeader])
		return Family_Msg(playerid, 0xFF6666FF, "Доступно только лидеру."), 1;
	new rrow;
	if(!JSON_GetInt(json, "r", rrow)) return 1;
	new target_uid = GetPVarInt(playerid, "fam_muid");
	if(target_uid <= 0) return 1;
	if(target_uid == Player[playerid][pID])
		return Family_Msg(playerid, 0xFF6666FF, "Нельзя применить к себе."), 1;
	new JSON_NODE:kt = JSON_GetType(json, "k");
	if(kt != JSON_NODE_NUMBER)
	{
		new q[280];
		mysql_format(db_handle, q, sizeof(q),
			"UPDATE `players` SET `family_id`=-1,`family_rang`=1,`family_access`='0,0,0,0,0,0,0'\
			 WHERE `family_id`=%d AND `id`=%d AND `family_rang`<5 LIMIT 1",
			Player[playerid][pFamilyId], target_uid);
		mysql_tquery(db_handle, q, "Family_DB_OnGuiKick", "ii", playerid, target_uid);
		return 1;
	}
	new kdir;
	JSON_GetInt(json, "k", kdir);
	if(rrow == 0)
	{
		new dir = (kdir == 1) ? (1) : (-1);
		new q[260];
		mysql_format(db_handle, q, sizeof(q),
			"UPDATE `players` SET `family_rang` = GREATEST(1, LEAST(%d, `family_rang` + (%d)))\
			 WHERE `family_id` = %d AND `id` = %d AND `family_rang` < 5 LIMIT 1",
			FAMILY_RANK_MAX_MEMBER, dir, Player[playerid][pFamilyId], target_uid);
		mysql_tquery(db_handle, q, "Family_DB_OnGuiRankDelta", "ii", playerid, target_uid);
		return 1;
	}
	return Family_SendPlayerActionAck(playerid);
}

forward Family_DB_OnGuiKick(playerid, target_uid);
public Family_DB_OnGuiKick(playerid, target_uid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	#pragma unused target_uid
	if(cache_affected_rows() > 0)
	{
		Family_Msg(playerid, 0x88FF88FF, "Участник исключён из семьи.");
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(!IsPlayerConnected(i)) continue;
			if(Player[i][pID] != target_uid) continue;
			Family_ResetPlayerVars(i);
			Family_Msg(i, 0xE0584BFF, "Вас исключили из семьи.");
			break;
		}
	}
	else Family_Msg(playerid, 0xFF6666FF, "Не удалось исключить (лидер или не найден).");
	Family_SendPlayerActionAck(playerid);
	return 1;
}

forward Family_DB_OnGuiRankDelta(playerid, target_uid);
public Family_DB_OnGuiRankDelta(playerid, target_uid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(cache_affected_rows() > 0)
	{
		new q[200];
		mysql_format(db_handle, q, sizeof(q),
			"SELECT `family_rang` AS `rank` FROM `players` WHERE `family_id` = %d AND `id` = %d LIMIT 1",
			Player[playerid][pFamilyId], target_uid);
		mysql_tquery(db_handle, q, "Family_DB_OnGuiRankRead", "ii", playerid, target_uid);
		return 1;
	}
	Family_Msg(playerid, 0xFF6666FF, "Ранг не изменён.");
	Family_SendPlayerActionAck(playerid);
	return 1;
}

forward Family_DB_OnGuiRankRead(playerid, target_uid);
public Family_DB_OnGuiRankRead(playerid, target_uid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		new nr = cache_get_field_content_int(0, "rank", db_handle);
		Family_RefreshOnlineMemberRank(target_uid, nr);
	}
	Family_SendPlayerActionAck(playerid);
	return 1;
}

static stock Family_HandleSettingsPacket(playerid, Node:json)
{
	if(JSON_GetType(json, "s") == JSON_NODE_NUMBER)
	{
		new st;
		JSON_GetInt(json, "s", st);
		if(st == 1 || st == 2 || st == 3)
			return 1;
	}
	return Family_SendSettingsStart(playerid);
}

static stock Family_HandlePlayersPacket(playerid, Node:json)
{
	if(JSON_GetType(json, "s") == JSON_NODE_NUMBER)
	{
		new st;
		JSON_GetInt(json, "s", st);
		if(st == 1)
		{
			new nick[MAX_PLAYER_NAME];
			if(!JSON_GetString(json, "n", nick, sizeof nick)) return 1;
			return Family_PlayerDetailRequest(playerid, nick);
		}
		if(st == 2)
			return Family_HandlePlayerAction(playerid, json);
	}
	return Family_PlayerListRequest(playerid);
}

static stock Family_HandleStorePacket(playerid, Node:json)
{
	new r;
	if(!JSON_GetInt(json, "r", r)) r = 0;
	if(r == 0)
		return Family_SendStoreSafeParams(playerid);
	if(r == 1)
	{
		new sv;
		if(JSON_GetType(json, "s") == JSON_NODE_NUMBER && JSON_GetInt(json, "s", sv) && sv == 1)
			return 1;
	}
	return 1;
}

static stock Family_HandleLogsPacket(playerid)
{
	Family_Msg(playerid, 0xCECECEFF, "Семейные логи: скоро. Используйте объявления в игре.");
	return 1;
}

static stock Family_HandleBlacklistPacket(playerid)
{
	Family_Msg(playerid, 0xCECECEFF, "Чёрный список семьи: в разработке.");
	return 1;
}

static stock Family_UpgradeNextPrice(level)
{
	if(level < 1) level = 1;
	if(level >= FAMILY_UPGRADE_MAX) return 0;
	return 350000 + (level * 200000);
}

static stock Family_TryBuyUpgrade(playerid, upg_id)
{
	if(Player[playerid][pFamilyId] == 0) return 1;
	if(!Player[playerid][pFamilyLeader])
		return Family_Msg(playerid, 0xFF6666FF, "Улучшать может только лидер."), 1;
	new cur, fid = Player[playerid][pFamilyId];
	new q[320];
	switch(upg_id)
	{
		case 0:
		{
			cur = GetPVarInt(playerid, "fam_lvl_store");
			if(cur >= FAMILY_UPGRADE_MAX)
				return Family_Msg(playerid, 0xFF6666FF, "Улучшение на максимуме."), 1;
			new price = Family_UpgradeNextPrice(cur);
			new fm = GetPVarInt(playerid, "fam_money");
			if(fm < price)
				return Family_Msg(playerid, 0xFF6666FF, "Недостаточно средств на счету семьи."), 1;
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family` SET `money` = `money` - %d, `level_storage` = `level_storage` + 1 WHERE `id` = %d AND `money` >= %d AND `level_storage` < %d LIMIT 1",
				price, fid, price, FAMILY_UPGRADE_MAX);
			mysql_tquery(db_handle, q, "Family_DB_OnGuiUpgrade", "iii", playerid, upg_id, price);
			return 1;
		}
		case 1:
		{
			cur = GetPVarInt(playerid, "fam_lvl_weapons");
			if(cur >= FAMILY_UPGRADE_MAX)
				return Family_Msg(playerid, 0xFF6666FF, "Улучшение на максимуме."), 1;
			new price = Family_UpgradeNextPrice(cur);
			new fm = GetPVarInt(playerid, "fam_money");
			if(fm < price)
				return Family_Msg(playerid, 0xFF6666FF, "Недостаточно средств на счету семьи."), 1;
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family` SET `money` = `money` - %d, `level_weapon` = `level_weapon` + 1 WHERE `id` = %d AND `money` >= %d AND `level_weapon` < %d LIMIT 1",
				price, fid, price, FAMILY_UPGRADE_MAX);
			mysql_tquery(db_handle, q, "Family_DB_OnGuiUpgrade", "iii", playerid, upg_id, price);
			return 1;
		}
		case 2:
		{
			cur = GetPVarInt(playerid, "fam_lvl_members");
			if(cur >= FAMILY_UPGRADE_MAX)
				return Family_Msg(playerid, 0xFF6666FF, "Улучшение на максимуме."), 1;
			new price = Family_UpgradeNextPrice(cur);
			new fm = GetPVarInt(playerid, "fam_money");
			if(fm < price)
				return Family_Msg(playerid, 0xFF6666FF, "Недостаточно средств на счету семьи."), 1;
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `family` SET `money` = `money` - %d, `level_compound` = `level_compound` + 1 WHERE `id` = %d AND `money` >= %d AND `level_compound` < %d LIMIT 1",
				price, fid, price, FAMILY_UPGRADE_MAX);
			mysql_tquery(db_handle, q, "Family_DB_OnGuiUpgrade", "iii", playerid, upg_id, price);
			return 1;
		}
		default: return Family_Msg(playerid, 0xFF6666FF, "Неизвестное улучшение."), 1;
	}
	return 1;
}

forward Family_DB_OnGuiUpgrade(playerid, upg_id, price);
public Family_DB_OnGuiUpgrade(playerid, upg_id, price)
{
	if(!IsPlayerConnected(playerid)) return 1;
	#pragma unused price
	if(cache_affected_rows() == 0)
		return Family_Msg(playerid, 0xFF6666FF, "Улучшение не применено."), 1;
	if(upg_id == 0)
		SetPVarInt(playerid, "fam_lvl_store", GetPVarInt(playerid, "fam_lvl_store") + 1);
	else if(upg_id == 1)
		SetPVarInt(playerid, "fam_lvl_weapons", GetPVarInt(playerid, "fam_lvl_weapons") + 1);
	else if(upg_id == 2)
		SetPVarInt(playerid, "fam_lvl_members", GetPVarInt(playerid, "fam_lvl_members") + 1);
	new q[128];
	mysql_format(db_handle, q, sizeof(q), "SELECT `money` FROM `family` WHERE `id` = %d LIMIT 1", Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_OnGuiUpgradeMoney", "ii", playerid, upg_id);
	return 1;
}

forward Family_DB_OnGuiUpgradeMoney(playerid, upg_id);
public Family_DB_OnGuiUpgradeMoney(playerid, upg_id)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
		SetPVarInt(playerid, "fam_money", cache_get_field_content_int(0, "money", db_handle));
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf, "{\"t\":4,\"s\":1,\"id\":%d}", upg_id);
	Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
	Family_SendUpgrade(playerid);
	ShowNotification(playerid, 1, 5, 0, 1, "Улучшение семьи применено.", "");
	return 1;
}

static stock Family_SendUpgrade(playerid)
{
	new ls = GetPVarInt(playerid, "fam_lvl_store");
	new lw = GetPVarInt(playerid, "fam_lvl_weapons");
	new lm = GetPVarInt(playerid, "fam_lvl_members");
	if(ls < 1) ls = 1;
	if(lw < 1) lw = 1;
	if(lm < 1) lm = 1;
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf,
		"{\"t\":4,\"m\":%d,\"y\":[%d,%d,%d]}",
		GetPVarInt(playerid, "fam_money"), ls, lw, lm);
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_SendNotificationsEmpty(playerid)
{
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf, "{\"t\":6,\"b\":0,\"m\":[],\"x\":[]}");
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

static stock Family_SendRating(playerid)
{
	new q[192];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `id`,`name`,`reputation` FROM `family` ORDER BY `reputation` DESC, `id` ASC LIMIT 15");
	mysql_tquery(db_handle, q, "Family_DB_OnGuiRating", "i", playerid);
	return 1;
}

forward Family_DB_OnGuiRating(playerid);
public Family_DB_OnGuiRating(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new rep = GetPVarInt(playerid, "fam_rep");
	new place = 0;
	new my_fid = Player[playerid][pFamilyId];
	format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf,
		"{\"t\":7,\"tp\":%d,\"tr\":0,\"tz\":1,\"m\":[", rep);
	if(rows == 0)
	{
		format(g_FamGuiReplyBuf, sizeof g_FamGuiReplyBuf,
			"{\"t\":7,\"p\":1,\"tp\":%d,\"tr\":0,\"tz\":1,\"m\":[1],\"mn\":[\"%e\"]}",
			rep, Player[playerid][pFamilyName]);
		return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
	}
	new tmp[96], ename[FAMILY_NAME_CAP];
	for(new i = 0; i < rows; i++)
	{
		new pos = i + 1;
		new fid = cache_get_field_content_int(i, "id", db_handle);
		if(fid == my_fid) place = pos;
		format(tmp, sizeof tmp, "%s%d", (i > 0) ? (",") : (""), pos);
		strcat(g_FamGuiReplyBuf, tmp);
	}
	if(place == 0) place = rows + 1;
	new mid = strlen(g_FamGuiReplyBuf);
	format(g_FamGuiReplyBuf[mid], sizeof g_FamGuiReplyBuf - mid, "],\"mn\":[");
	for(new j = 0; j < rows; j++)
	{
		cache_get_field_content(j, "name", ename, db_handle, sizeof ename);
		Family_EscapeJson(ename, ename, sizeof ename);
		format(tmp, sizeof tmp, "%s\"%s\"", (j > 0) ? (",") : (""), ename);
		strcat(g_FamGuiReplyBuf, tmp);
	}
	format(tmp, sizeof tmp, "],\"p\":%d}", place);
	strcat(g_FamGuiReplyBuf, tmp);
	return Family_GuiOutgoingStr(playerid, g_FamGuiReplyBuf);
}

stock Family_OnGuiPacket(playerid, Node:json, const raw_json[])
{
	new t = -1;
	if(!Tune_ExtractJsonIntField(raw_json, "t", t))
	{
		if(JSON_GetType(json, "t") == JSON_NODE_NUMBER)
			JSON_GetInt(json, "t", t);
	}

	switch(t)
	{
		case 1:
		{
			if(Player[playerid][pFamilyId] == 0)
				return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье."), 1;
			return Family_SendQuestOpenGui(playerid);
		}
		case 2:
		{
			if(Player[playerid][pFamilyId] == 0)
				return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье."), 1;
			new st = -1;
			if(!Tune_ExtractJsonIntField(raw_json, "s", st))
			{
				if(JSON_GetType(json, "s") == JSON_NODE_NUMBER)
					JSON_GetInt(json, "s", st);
			}
			if(st == 1)
			{
				new car_db_id = 0;
				if(!Tune_ExtractJsonIntField(raw_json, "id", car_db_id))
				{
					if(JSON_GetType(json, "id") == JSON_NODE_NUMBER)
						JSON_GetInt(json, "id", car_db_id);
				}
				if(car_db_id <= 0) return 1;
				return Family_FleetRequestSelect(playerid, car_db_id);
			}
			if(st == 2)
			{
				new car_db_id = 0, action_id = 0;
				if(!Tune_ExtractJsonIntField(raw_json, "m", car_db_id))
					return 1;
				if(!Tune_ExtractJsonIntField(raw_json, "id", action_id))
					return 1;
				if(car_db_id <= 0) return 1;
				new acc_has = 0, acc_val = 0;
				if(Tune_ExtractJsonIntField(raw_json, "r", acc_val))
					acc_has = 1;
				else if(action_id == 3)
				{
					acc_has = 1;
					acc_val = 0;
				}
				return Family_FleetBeginAction(playerid, car_db_id, action_id, acc_has, acc_val);
			}
			return Family_FleetSendListAsync(playerid);
		}
		case 3:
		{
			if(Player[playerid][pFamilyId] == 0)
				return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье."), 1;
			if(JSON_GetType(json, "id") == JSON_NODE_NUMBER)
			{
				ShowNotification(playerid, 0, 5, 0, 0, "Покупка в семейном магазине скоро.", "");
				return 1;
			}
			return Family_SendShopOpenGui(playerid);
		}
		case 4:
		{
			if(Player[playerid][pFamilyId] == 0)
				return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье."), 1;
			if(JSON_GetType(json, "s") == JSON_NODE_NUMBER)
			{
				new st;
				JSON_GetInt(json, "s", st);
				if(st == 1)
				{
					new upg_sel = 0;
					if(JSON_GetType(json, "id") == JSON_NODE_NUMBER)
						JSON_GetInt(json, "id", upg_sel);
					if(upg_sel >= 0)
						return Family_TryBuyUpgrade(playerid, upg_sel);
					return 1;
				}
			}
			Family_SendUpgrade(playerid);
			return 1;
		}
		case 5:
		{
			if(Player[playerid][pFamilyId] == 0)
				return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье."), 1;
			new sub_id = -1, sub_s = -1;
			new bool:hasSubId = (JSON_GetType(json, "id") == JSON_NODE_NUMBER && JSON_GetInt(json, "id", sub_id));
			new bool:hasSubS = (JSON_GetType(json, "s") == JSON_NODE_NUMBER && JSON_GetInt(json, "s", sub_s));
			if(!hasSubId && !hasSubS)
				return Family_SendMainMenuGui(playerid);
			if(hasSubId && !hasSubS)
				return Family_HandleMenuNavigate(playerid, json);
			if(hasSubId && sub_id == 1)
				return Family_HandleSettingsPacket(playerid, json);
			if(hasSubId && sub_id == 2)
				return Family_HandlePlayersPacket(playerid, json);
			if(hasSubId && sub_id == 3)
				return Family_HandleStorePacket(playerid, json);
			if(hasSubId && sub_id == 4)
				return Family_HandleLogsPacket(playerid);
			if(hasSubId && sub_id == 5)
				return Family_HandleBlacklistPacket(playerid);
			return Family_HandleMenuNavigate(playerid, json);
		}
		case 6:
		{
			return Family_SendNotificationsEmpty(playerid);
		}
		case 10:
		{
			return Family_GuiRequestLeave(playerid);
		}
		case 7:
		{
			Family_SendRating(playerid);
			return 1;
		}
	}
	return 0;
}

forward Family_DB_OnNameFree(playerid);
public Family_DB_OnNameFree(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	new pending[FAMILY_NAME_CAP + 8];
	GetPVarString(playerid, "FamCreateName", pending, sizeof pending);
	if(rows > 0)
	{
		DeletePVar(playerid, "FamCreateName");
		return Family_Msg(playerid, 0xFF6666FF, "Семья с таким названием уже существует."), 1;
	}
	if(Player[playerid][pFamilyId] != 0)
	{
		DeletePVar(playerid, "FamCreateName");
		return Family_Msg(playerid, 0xFF6666FF, "Вы уже состоите в семье."), 1;
	}
	if(!Family_HasCreateMoney(playerid))
	{
		DeletePVar(playerid, "FamCreateName");
		return Family_Msg(playerid, 0xFF6666FF, "Для создания семьи нужно 3.000.000 рублей на руках."), 1;
	}
	if(!Family_IsValidName(pending))
	{
		DeletePVar(playerid, "FamCreateName");
		return Family_Msg(playerid, 0xFF6666FF, "Недопустимое название (3-24 символа, латиница, цифры, пробел, _)."), 1;
	}

	new slot = FamLaird_FindFreeSlot();
	if(slot == -1)
	{
		DeletePVar(playerid, "FamCreateName");
		return Family_Msg(playerid, 0xFF6666FF, "На сервере нет свободного слота для семьи."), 1;
	}
	SetPVarInt(playerid, "FamCreateSlot", slot);
	new q[256];
	mysql_format(db_handle, q, sizeof(q),
		"INSERT INTO `family` (`owner`,`name`) VALUES (%d,'%e')", Player[playerid][pID], pending);
	mysql_tquery(db_handle, q, "Family_DB_OnCreated", "i", playerid);
	return 1;
}

forward Family_DB_OnCreated(playerid);
public Family_DB_OnCreated(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new pending[FAMILY_NAME_CAP + 8];
	GetPVarString(playerid, "FamCreateName", pending, sizeof pending);
	if(!strlen(pending))
		return Family_Msg(playerid, 0xFF6666FF, "Ошибка создания семьи."), 1;

	new ins_id = cache_insert_id();
	if(ins_id <= 0)
	{
		new qs[128];
		mysql_format(db_handle, qs, sizeof qs, "SELECT `id` FROM `family` WHERE `owner`=%d LIMIT 1", Player[playerid][pID]);
		mysql_tquery(db_handle, qs, "Family_DB_OnCreatedLookup", "i", playerid);
		return 1;
	}
	SetPVarInt(playerid, "FamCreateFid", ins_id);
	new q[220];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET `family_id`=%d,`family_rang`=%d,`family_access`='1,1,1,1,1,1,1',`family_mute`=0 WHERE `id`=%d LIMIT 1",
		ins_id, FAMILY_RANK_LEADER, Player[playerid][pID]);
	mysql_tquery(db_handle, q, "Family_DB_OnCreatedPlayer", "i", playerid);
	return 1;
}

forward Family_DB_OnCreatedLookup(playerid);
public Family_DB_OnCreatedLookup(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows < 1)
		return Family_Msg(playerid, 0xFF6666FF, "Не удалось создать семью. Проверьте SQL (таблица family)."), 1;
	SetPVarInt(playerid, "FamCreateFid", cache_get_field_content_int(0, "id", db_handle));
	new q[220];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET `family_id`=%d,`family_rang`=%d,`family_access`='1,1,1,1,1,1,1',`family_mute`=0 WHERE `id`=%d LIMIT 1",
		GetPVarInt(playerid, "FamCreateFid"), FAMILY_RANK_LEADER, Player[playerid][pID]);
	mysql_tquery(db_handle, q, "Family_DB_OnCreatedPlayer", "i", playerid);
	return 1;
}

forward Family_DB_OnCreatedPlayer(playerid);
public Family_DB_OnCreatedPlayer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new pending[FAMILY_NAME_CAP + 8];
	GetPVarString(playerid, "FamCreateName", pending, sizeof pending);
	DeletePVar(playerid, "FamCreateName");
	new fid = GetPVarInt(playerid, "FamCreateFid");
	DeletePVar(playerid, "FamCreateFid");
	if(fid <= 0)
		return Family_Msg(playerid, 0xFF6666FF, "Ошибка привязки семьи к аккаунту."), 1;

	if(!Family_ChargeCreateCost(playerid))
	{
		new qd[160];
		mysql_format(db_handle, qd, sizeof qd, "UPDATE `players` SET `family_id`=-1,`family_rang`=1 WHERE `id`=%d LIMIT 1", Player[playerid][pID]);
		mysql_tquery(db_handle, qd, "", "");
		return Family_Msg(playerid, 0xFF6666FF, "Недостаточно денег для создания семьи (3.000.000 руб.)."), 1;
	}

	new slot = GetPVarInt(playerid, "FamCreateSlot");
	DeletePVar(playerid, "FamCreateSlot");
	if(slot < 0 || slot >= MAX_FAM_LAIRD) slot = FamLaird_FindFreeSlot();
	new qf[96];
	mysql_format(db_handle, qf, sizeof qf, "SELECT * FROM `family` WHERE `id`=%d LIMIT 1", fid);
	mysql_tquery(db_handle, qf, "Family_DB_OnCreatedFamilyRow", "ii", playerid, slot);
	return 1;
}

forward Family_DB_OnCreatedFamilyRow(playerid, slot);
public Family_DB_OnCreatedFamilyRow(playerid, slot)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0 && slot >= 0 && slot < MAX_FAM_LAIRD)
		FamLaird_ApplyRowToSlot(slot, 0);
	FamLairdData[slot][FAM_COUNT_PEOPLE] = 1;
	DeletePVar(playerid, "fam_loaded");
	Family_DB_LoadMember(playerid);
	new pending[FAMILY_NAME_CAP + 8];
	format(pending, sizeof pending, "%s", Player[playerid][pFamilyName]);
	if(!strlen(pending)) format(pending, sizeof pending, "Семья");
	new done[96];
	format(done, sizeof done, "Семья «%s» создана. Меню: /fm, чат: /fam [текст]", pending);
	Family_Msg(playerid, 0x88FF88FF, done);
	SetPVarInt(playerid, "fam_open_after_load", 1);
	return 1;
}

static stock Family_FormatRankTitleForPlayer(playerid, buf[], len)
{
	if(Player[playerid][pFamilyLeader])
	{
		format(buf, len, "Лидер");
		return 1;
	}
	new r = Player[playerid][pFamilyRank];
	if(r < 1 || r > FAMILY_RANK_MAX_MEMBER)
	{
		format(buf, len, "Ранг %d", r);
		return 1;
	}
	new key[12], rn[32];
	format(key, sizeof key, "fam_rn_%d", r);
	GetPVarString(playerid, key, rn, sizeof rn);
	if(!strlen(rn)) format(buf, len, "Ранг %d", r);
	else format(buf, len, "%s", rn);
	return 1;
}

stock Family_ReloadFamilyOnline(fid)
{
	if(fid <= 0) return 0;
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pFamilyId] != fid) continue;
		Family_DB_LoadMember(i);
	}
	return 1;
}

stock Family_ShowRankNameList(playerid)
{
	if(!Player[playerid][pFamilyLeader]) return 0;
	new rn1[32], rn2[32], rn3[32], rn4[32];
	GetPVarString(playerid, "fam_rn_1", rn1, sizeof rn1);
	GetPVarString(playerid, "fam_rn_2", rn2, sizeof rn2);
	GetPVarString(playerid, "fam_rn_3", rn3, sizeof rn3);
	GetPVarString(playerid, "fam_rn_4", rn4, sizeof rn4);
	new big[400];
	format(big, sizeof big,
		"Ранг 1 — %s\n"\
		"Ранг 2 — %s\n"\
		"Ранг 3 — %s\n"\
		"Ранг 4 — %s\n"\
		"Назад",
		rn1, rn2, rn3, rn4);
	ShowPlayerDialog(playerid, DIALOG_FAM_RANK_NAME_LIST, DIALOG_STYLE_LIST,
		"{E0584B}Названия рангов (1-4)", big, "Выбрать", "Назад");
	return 1;
}

static stock Family_ShowRankAccEditDialog(playerid)
{
	new rk = GetPVarInt(playerid, "fam_acc_edit_rank");
	new key[12], rn[32], title[96];
	format(key, sizeof key, "fam_rn_%d", rk);
	GetPVarString(playerid, key, rn, sizeof rn);
	if(!strlen(rn)) format(title, sizeof title, "{E0584B}Доступ к складу — ранг %d", rk);
	else format(title, sizeof title, "{E0584B}Доступ — %s", rn);
	new big[768];
	format(big, sizeof big,
		"Предмет\tСтатус\n"\
		"Деньги (снятие со склада)\t%s\n"\
		"Деньги (внесение на склад)\t%s\n"\
		"Броня\t%s\n"\
		"Материалы\t%s\n"\
		"Канистры\t%s\n"\
		"Патроны\t%s\n"\
		"Маски\t%s\n"\
		"Приглашения в семью\t%s",
		GetPVarInt(playerid, "fam_ra0") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra1") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra2") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra3") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra4") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra5") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra6") ? ("Включено") : ("Выключено"),
		GetPVarInt(playerid, "fam_ra7") ? ("Включено") : ("Выключено"));
	ShowPlayerDialog(playerid, DIALOG_FAM_RANK_ACC_EDIT, DIALOG_STYLE_TABLIST_HEADERS,
		title, big, "Выбрать", "Назад");
	return 1;
}

static stock Family_RequestRankAccEditDialog(playerid, rank)
{
	return Family_LoadRankAccEditFromCache(playerid, rank);
}

public Family_DB_OnRankNameSaved(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	Family_Msg(playerid, 0x88FF88FF, "Название ранга сохранено.");
	if(Player[playerid][pFamilyId] > 0)
		Family_ReloadFamilyOnline(Player[playerid][pFamilyId]);
	Family_ShowRankNameList(playerid);
	return 1;
}

stock Family_DialogShowRankAccPick(playerid)
{
	if(!Player[playerid][pFamilyLeader])
		return Family_Msg(playerid, 0xFF6666FF, "Только лидер настраивает доступы."), 0;
	new rn1[28], rn2[28], rn3[28], rn4[28];
	GetPVarString(playerid, "fam_rn_1", rn1, sizeof rn1);
	GetPVarString(playerid, "fam_rn_2", rn2, sizeof rn2);
	GetPVarString(playerid, "fam_rn_3", rn3, sizeof rn3);
	GetPVarString(playerid, "fam_rn_4", rn4, sizeof rn4);
	new big[400];
	format(big, sizeof big,
		"Ранг 1 — %s\n"\
		"Ранг 2 — %s\n"\
		"Ранг 3 — %s\n"\
		"Ранг 4 — %s",
		rn1, rn2, rn3, rn4);
	ShowPlayerDialog(playerid, DIALOG_FAM_RANK_ACC_PICK, DIALOG_STYLE_LIST,
		"{E0584B}Доступ к складу по рангам", big, "Выбрать", "Назад");
	return 1;
}

static stock Family_DialogBuildSummary(playerid, buf[], len)
{
	new ls = GetPVarInt(playerid, "fam_lvl_store");
	new lw = GetPVarInt(playerid, "fam_lvl_weapons");
	new lm = GetPVarInt(playerid, "fam_lvl_members");
	new rep = GetPVarInt(playerid, "fam_rep");
	new mc = GetPVarInt(playerid, "fam_mc");
	if(mc < 1) mc = 1;
	if(ls < 1) ls = 1;
	if(ls > FAMILY_UPGRADE_MAX) ls = FAMILY_UPGRADE_MAX;
	if(lw < 1) lw = 1;
	if(lw > FAMILY_UPGRADE_MAX) lw = FAMILY_UPGRADE_MAX;
	new fm = GetPVarInt(playerid, "fam_money");
	new mat = GetPVarInt(playerid, "fam_mat");
	new masks = GetPVarInt(playerid, "fam_masks");
	new fuel = GetPVarInt(playerid, "fam_fuel");
	new armor = GetPVarInt(playerid, "fam_armor");
	new ammo = GetPVarInt(playerid, "fam_ammo");
	new max_money = FamilyCountMoneyLevel[ls - 1];
	new max_mat = FamilyCountMaterialLevel[lw - 1];
	new max_masks = FamilyCountMaskLevel[ls - 1];
	new max_fuel = Family_MaxForStoreLevel(ls, 40, 480);
	new max_armor = FamilyCountArmourLevel[ls - 1];
	new max_ammo = FamilyCountPatronLevel[lw - 1];
	new lstr[40];
	new lnm[MAX_PLAYER_NAME];
	GetPVarString(playerid, "fam_leader_name", lnm, sizeof lnm);
	if(!strlen(lnm)) format(lnm, sizeof lnm, "—");
	format(lstr, sizeof lstr, "%s", Player[playerid][pFamilyLeader] ? ("{88FF88}лидер") : ("участник"));
	new rtitle[40];
	Family_FormatRankTitleForPlayer(playerid, rtitle, sizeof rtitle);
	format(buf, len,
		"{FFFFFF}Семья: {D4AF37}%s\n"\
		"Лидер: {D4AF37}%s\n\n"\
		"Репутация: %d\n"\
		"Участников: %d / %d (лимит от улучшения состава)\n"\
		"Ваш статус: %s {FFFFFF}(%s, №%d)\n\n"\
		"Казна семьи: {88FF88}%d{FFFFFF} руб.\n\n"\
		"Деньги на складе: %d / %d руб.\n"\
		"Материалы: %d / %d шт.\n"\
		"Маски: %d / %d шт.\n"\
		"Канистры: %d / %d\n"\
		"Бронежилеты: %d / %d шт.\n"\
		"Патроны: %d / %d шт.\n\n"\
		"Уровни развития семьи: склад %d/7, оружейный склад %d/7, состав %d/7\n",
		Player[playerid][pFamilyName], lnm,
		rep, mc, Family_MaxMemberFromLevel(lm),
		lstr, rtitle, Player[playerid][pFamilyRank],
		fm, fm, max_money, mat, max_mat, masks, max_masks, fuel, max_fuel, armor, max_armor, ammo, max_ammo,
		ls, lw, lm);
}

stock Family_DialogShowMain(playerid)
{
	if(Player[playerid][pFamilyId] <= 0) return 0;
	new list[] =
		"Объявления семьи\n"\
		"Информация о семье\n"\
		"Настройка семьи (лидер)\n"\
		"Управление семьёй (лидер)\n"\
		"Склад семьи\n"\
		"Семейный автопарк\n"\
		"Развитие семьи\n"\
		"Рейтинг семей\n"\
		"Логи семьи\n"\
		"Покинуть семью";
	ShowPlayerDialog(playerid, DIALOG_FAMILY_MAIN, DIALOG_STYLE_LIST,
		"{E0584B}Семья — меню", list, "Выбрать", "Закрыть");
	return 1;
}

stock Family_DialogShowSummary(playerid)
{
	new txt[700];
	Family_DialogBuildSummary(playerid, txt, sizeof txt);
	ShowPlayerDialog(playerid, DIALOG_FAMILY_SUMMARY, DIALOG_STYLE_MSGBOX,
		"{E0584B}Информация о семье", txt, "Назад", "Закрыть");
	return 1;
}

static stock Family_DialogFleetSyncBg(fid)
{
	if(fid <= 0) return 0;
	new qr[360];
	mysql_format(db_handle, qr, sizeof(qr),
		"INSERT IGNORE INTO `family_fleet` (`family_id`,`car_db_id`,`access_rank`,`added_by_uid`,`original_owner_uid`)\
		 SELECT `family_owner`,`ownable_id`, IF(`rang`<1,1,`rang`), 0, 0 FROM `family_cars`\
		 WHERE `family_owner`=%d AND `ownable_id`>0",
		fid);
	mysql_tquery(db_handle, qr, "", "");
	return 1;
}

static stock Family_DialogFleetTrySync(playerid, query[])
{
	new Cache:res = mysql_query(db_handle, query, true);
	if(res == Cache:0)
		return 0;
	new rows = cache_num_rows();
	if(rows <= 0)
	{
		cache_delete(res);
		return 0;
	}
	new ret = Family_DialogFleetPresentList(playerid, rows);
	cache_delete(res);
	return ret;
}

static stock Family_DialogOpenFleetQuery(playerid)
{
	if(Player[playerid][pFamilyId] == 0)
	{
		Family_Msg(playerid, 0xFF6666FF, "Вы не в семье.");
		return 0;
	}
	new fid = Player[playerid][pFamilyId];
	FamilyDlgFleetCount[playerid] = 0;
	Family_DialogFleetSyncBg(fid);

	new q[520];

	mysql_format(db_handle, q, sizeof(q),
		"SELECT `ownable_id` AS `car_db_id`, `model_id` AS `model`, `rang` AS `access_rank`, `number` AS `plate_number`\
		 FROM `family_cars` WHERE `family_owner`=%d AND `ownable_id`>0 ORDER BY `id` ASC",
		fid);
	if(Family_DialogFleetTrySync(playerid, q))
		return 1;

	mysql_format(db_handle, q, sizeof(q),
		"SELECT `id` AS `car_db_id`, `model_id` AS `model`, `rang` AS `access_rank`, `number` AS `plate_number`\
		 FROM `family_cars` WHERE `family_owner`=%d ORDER BY `id` ASC",
		fid);
	if(Family_DialogFleetTrySync(playerid, q))
		return 1;

	mysql_format(db_handle, q, sizeof(q),
		"SELECT `car_db_id`, `access_rank`,\
		 (SELECT `model` FROM `ownable_cars` WHERE `id`=`family_fleet`.`car_db_id` LIMIT 1) AS `model`,\
		 (SELECT `plate_number` FROM `ownable_cars` WHERE `id`=`family_fleet`.`car_db_id` LIMIT 1) AS `plate_number`,\
		 (SELECT `plate_region` FROM `ownable_cars` WHERE `id`=`family_fleet`.`car_db_id` LIMIT 1) AS `plate_region`\
		 FROM `family_fleet` WHERE `family_id`=%d ORDER BY `id` ASC",
		fid);
	if(Family_DialogFleetTrySync(playerid, q))
		return 1;

	mysql_format(db_handle, q, sizeof(q),
		"SELECT `car_db_id`, `access_rank` FROM `family_fleet` WHERE `family_id`=%d ORDER BY `id` ASC",
		fid);
	if(Family_DialogFleetTrySync(playerid, q))
		return 1;

	SetPVarInt(playerid, "fam_fleet_qfid", fid);
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `ownable_id` AS `car_db_id`, `model_id` AS `model`, `rang` AS `access_rank`, `number` AS `plate_number`\
		 FROM `family_cars` WHERE `family_owner`=%d ORDER BY `id` ASC",
		fid);
	mysql_tquery(db_handle, q, "Family_DB_DialogFleetList", "i", playerid);
	return 1;
}

public Family_DB_DialogFleetList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	FamilyDlgFleetCount[playerid] = 0;
	if(rows == 0)
	{
		new fid = GetPVarInt(playerid, "fam_fleet_qfid");
		if(fid <= 0) fid = Player[playerid][pFamilyId];
		DeletePVar(playerid, "fam_fleet_qfid");
		new q[280];
		mysql_format(db_handle, q, sizeof(q),
			"SELECT `car_db_id`, `access_rank` FROM `family_fleet` WHERE `family_id`=%d ORDER BY `id` ASC",
			fid);
		mysql_tquery(db_handle, q, "Family_DB_DialogFleetListBare", "i", playerid);
		return 1;
	}
	DeletePVar(playerid, "fam_fleet_qfid");
	return Family_DialogFleetPresentList(playerid, rows);
}

public Family_DB_DialogFleetListBare(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	return Family_DialogFleetPresentList(playerid, rows);
}

stock Family_DialogShowFleetActions(playerid, car_db_id)
{
	if(car_db_id <= 0) return 0;
	FamilyDlgSelCarDb[playerid] = car_db_id;
	if(Player[playerid][pFamilyLeader])
	{
		new list[] =
			"Загрузить транспорт\n"\
			"Выгрузить транспорт\n"\
			"Вернуть владельцу в личный гараж\n"\
			"Изменить ранг\n"\
			"Назад к списку";
		ShowPlayerDialog(playerid, DIALOG_FAMILY_FLEET_ACT, DIALOG_STYLE_LIST,
			"{E0584B}Транспорт семьи", list, "Выбрать", "Назад");
	}
	else
	{
		new list[] =
			"Загрузить транспорт\n"\
			"Выгрузить транспорт\n"\
			"Изменить ранг\n"\
			"Назад к списку";
		ShowPlayerDialog(playerid, DIALOG_FAMILY_FLEET_ACT, DIALOG_STYLE_LIST,
			"{E0584B}Транспорт семьи", list, "Выбрать", "Назад");
	}
	return 1;
}

stock Family_DialogShowUpgrade(playerid)
{
	if(!Player[playerid][pFamilyLeader])
	{
		ShowPlayerDialog(playerid, DIALOG_FAMILY_UPGRADE_DENY, DIALOG_STYLE_MSGBOX,
			"{E0584B}Развитие семьи",
			"{FFFFFF}Уровни развития покупает только {E0584B}лидер{FFFFFF} семьи.",
			"Назад", "Закрыть");
		return 1;
	}
	new ls = GetPVarInt(playerid, "fam_lvl_store");
	new lw = GetPVarInt(playerid, "fam_lvl_weapons");
	new lm = GetPVarInt(playerid, "fam_lvl_members");
	new pm = GetPVarInt(playerid, "fam_money");
	new l0[144], l1[144], l2[144];
	new p0 = Family_UpgradeNextPrice(ls);
	new p1 = Family_UpgradeNextPrice(lw);
	new p2 = Family_UpgradeNextPrice(lm);
	format(l0, sizeof l0, "Склад: ур. %d/%d — купить за %d руб. (казна: %d)", ls, FAMILY_UPGRADE_MAX, p0, pm);
	format(l1, sizeof l1, "Оружейный склад: ур. %d/%d — %d руб.", lw, FAMILY_UPGRADE_MAX, p1);
	format(l2, sizeof l2, "Состав (слоты): ур. %d/%d — %d руб.", lm, FAMILY_UPGRADE_MAX, p2);
	new big[460];
	format(big, sizeof big, "%s\n%s\n%s", l0, l1, l2);
	ShowPlayerDialog(playerid, DIALOG_FAMILY_UPGRADE, DIALOG_STYLE_LIST,
		"{E0584B}Развитие семьи", big, "Купить", "Назад");
	return 1;
}

stock Family_DialogShowLeaveConfirm(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_FAMILY_LEAVE, DIALOG_STYLE_MSGBOX,
		"{E0584B}Выход из семьи",
		"{FFFFFF}Вы действительно хотите покинуть семью?\n\n{E0584B}Лидер{FFFFFF} не может выйти через это меню.",
		"Да, выйти", "Нет");
	return 1;
}

public Family_DB_OnLeaveFamily(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(cache_affected_rows() > 0)
	{
		Family_Msg(playerid, 0x88FF88FF, "Вы покинули семью.");
		Family_ResetPlayerVars(playerid);
	}
	else Family_Msg(playerid, 0xFF6666FF, "Не удалось выйти (вы лидер или ошибка).");
	return 1;
}

public Family_DlgReopenFleet(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(Player[playerid][pFamilyId] == 0) return 1;
	Family_DialogOpenFleetQuery(playerid);
	return 1;
}

stock Family_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(Player[playerid][pID] == 0) return 0;
	switch(dialogid)
	{
		case DIALOG_FAMILY_MAIN:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: { Family_ShowAdsMenu(playerid); return 1; }
				case 1: { Family_DialogShowSummary(playerid); return 1; }
				case 2: { Family_DialogShowFamilySettings(playerid); return 1; }
				case 3: { Family_DialogShowMgmt(playerid); return 1; }
				case 4: { Family_DialogShowSkladRoot(playerid); return 1; }
				case 5: { Family_DialogOpenFleetQuery(playerid); return 1; }
				case 6: { Family_DialogShowUpgrade(playerid); return 1; }
				case 7: { Family_RequestRatingList(playerid); return 1; }
				case 8: { Family_RequestLogList(playerid); return 1; }
				case 9: { Family_DialogShowLeaveConfirm(playerid); return 1; }
			}
			return 1;
		}
		case DIALOG_FAM_AD_MENU:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(listitem == 0) { Family_RequestAdsList(playerid); return 1; }
			if(listitem == 1)
			{
				if(!Player[playerid][pFamilyLeader])
				{
					Family_Msg(playerid, 0xFF6666FF, "Только лидер может размещать объявления.");
					Family_ShowAdsMenu(playerid);
					return 1;
				}
				ShowPlayerDialog(playerid, DIALOG_FAM_AD_INPUT, DIALOG_STYLE_INPUT,
					"{E0584B}Новое объявление",
					"{FFFFFF}Текст (до 120 символов). Будет виден всем участникам в списке:",
					"Опубликовать", "Назад");
				return 1;
			}
			return 1;
		}
		case DIALOG_FAM_AD_LIST:
		{
			Family_ShowAdsMenu(playerid);
			return 1;
		}
		case DIALOG_FAM_AD_INPUT:
		{
			if(!response) { Family_ShowAdsMenu(playerid); return 1; }
			if(isnull(inputtext) || strlen(inputtext) < 3)
			{
				Family_Msg(playerid, 0xFF6666FF, "Минимум 3 символа.");
				Family_ShowAdsMenu(playerid);
				return 1;
			}
			new q[400];
			mysql_format(db_handle, q, sizeof(q),
				"INSERT INTO `family_ad` (`family`,`ad_text`,`create_id`,`create_name`,`time`) VALUES (%d,'%e',%d,'%e',%d)",
				Player[playerid][pFamilyId], inputtext, Player[playerid][pID], Player[playerid][pName], gettime());
			mysql_tquery(db_handle, q, "Family_DB_OnAdPosted", "i", playerid);
			return 1;
		}
		case DIALOG_FAM_RAT_LIST:
		{
			if(response) Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAM_LOG_LIST:
		{
			if(response) Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAM_SET_COLOR:
		{
			if(!response) { Family_DialogShowFamilySettings(playerid); return 1; }
			if(listitem < 0 || listitem > 11) return 1;
			FamLaird_UpdateInt(Player[playerid][pFamilyId], "color", listitem);
			Family_Msg(playerid, 0x88FF88FF, "Цвет чата сохранён (как /v — выберите «Жёлтый — как /v»).");
			Family_ReloadFamilyOnline(Player[playerid][pFamilyId]);
			Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAM_RANK_NAME_LIST:
		{
			if(!response)
			{
				new sublist[] =
					"Назначить ранг (ввод: ID_ранг, ранг 1-4)\n"\
					"Изменить названия рангов (1-4)\n"\
					"Назад к управлению";
				ShowPlayerDialog(playerid, DIALOG_FAM_MGMT_RANK, DIALOG_STYLE_LIST,
					"{E0584B}Ранги семьи", sublist, "Выбрать", "Назад");
				return 1;
			}
			if(listitem >= 0 && listitem < 4)
			{
				SetPVarInt(playerid, "fam_rn_edit_slot", listitem + 1);
				ShowPlayerDialog(playerid, DIALOG_FAM_RANK_NAME_INP, DIALOG_STYLE_INPUT,
					"{E0584B}Название ранга",
					"{FFFFFF}Новое название (2-24 символа, латиница/кириллица/цифры/пробел/_):",
					"Сохранить", "Назад");
				return 1;
			}
			if(listitem == 4)
			{
				new sublist2[] =
					"Назначить ранг (ввод: ID_ранг, ранг 1-4)\n"\
					"Изменить названия рангов (1-4)\n"\
					"Назад к управлению";
				ShowPlayerDialog(playerid, DIALOG_FAM_MGMT_RANK, DIALOG_STYLE_LIST,
					"{E0584B}Ранги семьи", sublist2, "Выбрать", "Назад");
				return 1;
			}
			return 1;
		}
		case DIALOG_FAM_RANK_NAME_INP:
		{
			if(!response) { Family_ShowRankNameList(playerid); return 1; }
			new ln = strlen(inputtext);
			if(ln < 2 || ln > 24)
			{
				Family_Msg(playerid, 0xFF6666FF, "Длина названия: от 2 до 24 символов.");
				Family_ShowRankNameList(playerid);
				return 1;
			}
			new slot = GetPVarInt(playerid, "fam_rn_edit_slot");
			if(slot < 1 || slot > 4) return Family_ShowRankNameList(playerid), 1;
			new fid = Player[playerid][pFamilyId], lid = Player[playerid][pID];
			new fslot = FamLaird_FindSlotByDbId(fid);
			new ridx = slot - 1;
			new a0 = 1, a1, a2, a3, a4 = 1;
			if(fslot != -1)
			{
				a1 = FamLairdRankAcc[fslot][ridx][0];
				a2 = FamLairdRankAcc[fslot][ridx][1];
				a3 = FamLairdRankAcc[fslot][ridx][2];
				a4 = FamLairdRankAcc[fslot][ridx][3];
				format(FamLairdRankName[fslot][ridx], 24, "%s", inputtext);
			}
			new rowstr[48], col[8], qn[320];
			format(rowstr, sizeof rowstr, "%s,%d,%d,%d,%d,%d", inputtext, a0, a1, a2, a3, a4);
			format(col, sizeof col, "rang_%d", slot);
			mysql_format(db_handle, qn, sizeof(qn), "UPDATE `family` SET `%s`='%e' WHERE `id`=%d AND `owner`=%d LIMIT 1", col, rowstr, fid, lid);
			mysql_tquery(db_handle, qn, "Family_DB_OnRankNameSaved", "i", playerid);
			new pkey[12];
			format(pkey, sizeof pkey, "fam_rn_%d", slot);
			SetPVarString(playerid, pkey, inputtext);
			return 1;
		}
		case DIALOG_FAM_RANK_ACC_PICK:
		{
			if(!response) { Family_DialogShowFamilySettings(playerid); return 1; }
			if(listitem >= 0 && listitem < 4)
				Family_RequestRankAccEditDialog(playerid, listitem + 1);
			return 1;
		}
		case DIALOG_FAM_RANK_ACC_EDIT:
		{
			if(!response) { Family_DialogShowRankAccPick(playerid); return 1; }
			if(listitem < 0 || listitem > 7) return 1;
			if(listitem == 0) SetPVarInt(playerid, "fam_ra0", GetPVarInt(playerid, "fam_ra0") ? 0 : 1);
			else if(listitem == 1) SetPVarInt(playerid, "fam_ra1", GetPVarInt(playerid, "fam_ra1") ? 0 : 1);
			else if(listitem == 2) SetPVarInt(playerid, "fam_ra2", GetPVarInt(playerid, "fam_ra2") ? 0 : 1);
			else if(listitem == 3) SetPVarInt(playerid, "fam_ra3", GetPVarInt(playerid, "fam_ra3") ? 0 : 1);
			else if(listitem == 4) SetPVarInt(playerid, "fam_ra4", GetPVarInt(playerid, "fam_ra4") ? 0 : 1);
			else if(listitem == 5) SetPVarInt(playerid, "fam_ra5", GetPVarInt(playerid, "fam_ra5") ? 0 : 1);
			else if(listitem == 6) SetPVarInt(playerid, "fam_ra6", GetPVarInt(playerid, "fam_ra6") ? 0 : 1);
			else if(listitem == 7) SetPVarInt(playerid, "fam_ra7", GetPVarInt(playerid, "fam_ra7") ? 0 : 1);
			new rk = GetPVarInt(playerid, "fam_acc_edit_rank");
			Family_SaveRankAccToCache(playerid, rk);
			Family_Msg(playerid, 0x88FF88FF, "Доступы для ранга обновлены.");
			Family_ShowRankAccEditDialog(playerid);
			return 1;
		}
		case DIALOG_FAM_LAIR_LOG:
		{
			Family_DialogShowFamilySettings(playerid);
			return 1;
		}
		case DIALOG_FAM_LAIR_SET:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(listitem == 0) { Family_ShowSettingsColorPick(playerid); return 1; }
			if(listitem == 1) { Family_DialogShowRankAccPick(playerid); return 1; }
			ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_LOG, DIALOG_STYLE_MSGBOX,
				"{E0584B}Склад семьи",
				"{FFFFFF}Доступы к ресурсам склада настраиваются в пункте «Доступ к складу по рангам».\n"\
				"Ранг 5 (лидер) всегда имеет полный доступ.\n"\
				"Участники с 1 по 4 ранг получают права по таблице для своего ранга.",
				"Назад", "");
			return 1;
		}
		case DIALOG_FAM_LAIR_SKLAD:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(listitem == 0)
			{
				if(Player[playerid][pFamilyRank] < 4 && !Player[playerid][pFamilyLeader])
				{
					Family_Msg(playerid, 0xFF6666FF, "Склад открывает/закрывает заместитель (ранг 4+) или лидер.");
					Family_DialogShowSkladRoot(playerid);
					return 1;
				}
				new ns = GetPVarInt(playerid, "fam_storage_open") ? 0 : 1;
				new q[144];
				#pragma unused ns
				mysql_format(db_handle, q, sizeof(q), "UPDATE `family` SET `reputation`=`reputation` WHERE `id`=%d LIMIT 1", Player[playerid][pFamilyId]);
				mysql_tquery(db_handle, q, "Family_DB_OnStorageFlip", "ii", playerid, ns);
				return 1;
			}
			if(listitem == 1)
			{
				if(!GetPVarInt(playerid, "fam_storage_open") && !Player[playerid][pFamilyLeader] && Player[playerid][pFamilyRank] < 4)
				{
					Family_Msg(playerid, 0xFF6666FF, "Склад закрыт. Войти могут лидер и заместители (4+ ранг).");
					Family_DialogShowSkladRoot(playerid);
					return 1;
				}
				SetPVarInt(playerid, "fam_sklad_tp", 0);
				Family_DialogShowSkladResPick(playerid);
				return 1;
			}
			if(listitem == 2)
			{
				SetPVarInt(playerid, "fam_sklad_tp", 1);
				Family_DialogShowSkladResPick(playerid);
				return 1;
			}
			if(listitem == 3)
			{
				Family_Msg(playerid, 0xCECECEFF, "Доступы настраиваются лидером: меню семьи — настройка — «Доступ к складу по рангам».");
				Family_DialogShowSkladRoot(playerid);
				return 1;
			}
			return 1;
		}
		case DIALOG_FAM_LAIR_SKRES:
		{
			if(!response) { Family_DialogShowSkladRoot(playerid); return 1; }
			if(listitem == 0)
			{
				SetPVarInt(playerid, "fam_sklad_res", 1);
				ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_SKAMT, DIALOG_STYLE_INPUT,
					"{E0584B}Казна семьи",
					"{FFFFFF}Введите сумму в рублях:",
					"Ок", "Назад");
				return 1;
			}
			Family_Msg(playerid, 0xCECECEFF, "Сейчас через это меню доступны только операции с деньгами склада.");
			Family_DialogShowSkladRoot(playerid);
			return 1;
		}
		case DIALOG_FAM_LAIR_SKAMT:
		{
			if(!response) { Family_DialogShowSkladResPick(playerid); return 1; }
			if(GetPVarInt(playerid, "fam_sklad_res") != 1) { Family_DialogShowSkladRoot(playerid); return 1; }
			new amt = strval(inputtext);
			if(amt <= 0)
			{
				Family_Msg(playerid, 0xFF6666FF, "Введите число больше 0.");
				Family_DialogShowSkladResPick(playerid);
				return 1;
			}
			new tp = GetPVarInt(playerid, "fam_sklad_tp");
			if(tp == 0)
			{
				if(!GetPVarInt(playerid, "fam_storage_open") && !Player[playerid][pFamilyLeader] && Player[playerid][pFamilyRank] < 4)
				{
					Family_Msg(playerid, 0xFF6666FF, "Склад закрыт. Войти могут лидер и заместители (4+ ранг).");
					Family_DialogShowSkladRoot(playerid);
					return 1;
				}
				new fm = GetPVarInt(playerid, "fam_money");
				if(amt > fm)
				{
					Family_Msg(playerid, 0xFF6666FF, "В казне семьи недостаточно денег.");
					Family_DialogShowSkladResPick(playerid);
					return 1;
				}
				if(!Player[playerid][pFamilyLeader])
				{
					new quota = GetPVarInt(playerid, "fam_acc1");
					if(quota <= 0 || quota < amt)
					{
						Family_Msg(playerid, 0xFF6666FF, "Нет права снимать деньги со склада или превышен лимит (настройка лидера: доступ по рангу).");
						Family_DialogShowSkladResPick(playerid);
						return 1;
					}
				}
				new q[220];
				mysql_format(db_handle, q, sizeof(q), "UPDATE `family` SET `money`=`money`-%d WHERE `id`=%d AND `money`>=%d LIMIT 1", amt, Player[playerid][pFamilyId], amt);
				mysql_tquery(db_handle, q, "Family_DB_OnSkladMoneyPull", "ii", playerid, amt);
				return 1;
			}
			if(!GetPVarInt(playerid, "fam_storage_open") && !Player[playerid][pFamilyLeader] && Player[playerid][pFamilyRank] < 4)
			{
				Family_Msg(playerid, 0xFF6666FF, "Склад закрыт.");
				Family_DialogShowSkladRoot(playerid);
				return 1;
			}
			if(!Player[playerid][pFamilyLeader] && !GetPVarInt(playerid, "fam_acc_money_in"))
			{
				Family_Msg(playerid, 0xFF6666FF, "Нет права вносить деньги на склад (спросите лидера о доступе для вашего ранга).");
				Family_DialogShowSkladResPick(playerid);
				return 1;
			}
			if(Player[playerid][pMoney] < amt)
			{
				Family_Msg(playerid, 0xFF6666FF, "У вас недостаточно наличных.");
				Family_DialogShowSkladResPick(playerid);
				return 1;
			}
			new fm2 = GetPVarInt(playerid, "fam_money");
			new cap = Family_CapMoneyStore(playerid);
			if(fm2 + amt > cap)
			{
				Family_Msg(playerid, 0xFF6666FF, "Превышен лимит денег на складе для уровня склада.");
				Family_DialogShowSkladResPick(playerid);
				return 1;
			}
			new q2[200];
			mysql_format(db_handle, q2, sizeof(q2), "UPDATE `family` SET `money`=`money`+%d WHERE `id`=%d LIMIT 1", amt, Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q2, "Family_DB_OnSkladMoneyPush", "ii", playerid, amt);
			return 1;
		}
		case DIALOG_FAM_LAIR_MGMT:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(listitem < 0 || listitem > 4) return Family_DialogShowMain(playerid), 1;
			if(listitem == 4)
			{
				new sublist[] =
					"Назначить ранг (ввод: ID_ранг, ранг 1-4)\n"\
					"Изменить названия рангов (1-4)\n"\
					"Назад к управлению";
				ShowPlayerDialog(playerid, DIALOG_FAM_MGMT_RANK, DIALOG_STYLE_LIST,
					"{E0584B}Ранги семьи", sublist, "Выбрать", "Назад");
				return 1;
			}
			SetPVarInt(playerid, "fam_mgmt_kind", listitem + 1);
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_MGMTIN, DIALOG_STYLE_INPUT,
						"{E0584B}Приглашение",
						"{FFFFFF}Введите ID игрока в игре (слот):",
						"Ок", "Назад");
					return 1;
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_MGMTIN, DIALOG_STYLE_INPUT,
						"{E0584B}Исключение",
						"{FFFFFF}Ник игрока (как в игре):",
						"Ок", "Назад");
					return 1;
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_MGMTIN, DIALOG_STYLE_INPUT,
						"{E0584B}Мут чата",
						"{FFFFFF}Формат: {E0584B}Ник_минуты{FFFFFF} (пример: Ivan_15):",
						"Ок", "Назад");
					return 1;
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_MGMTIN, DIALOG_STYLE_INPUT,
						"{E0584B}Снять мут",
						"{FFFFFF}Ник игрока:",
						"Ок", "Назад");
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_FAM_MGMT_RANK:
		{
			if(!response) { Family_DialogShowMgmt(playerid); return 1; }
			if(listitem == 0)
			{
				SetPVarInt(playerid, "fam_mgmt_kind", 6);
				ShowPlayerDialog(playerid, DIALOG_FAM_LAIR_MGMTIN, DIALOG_STYLE_INPUT,
					"{E0584B}Назначить ранг",
					"{FFFFFF}Формат: {E0584B}ID_ранг{FFFFFF} — игровой слот SA-MP и ранг {E0584B}1-4{FFFFFF}.\n"\
					"Пример: {E0584B}12_2{FFFFFF} — игрок с ID 12 получит 2 ранг.\n"\
					"{AAAAAA}Ранг 5 (лидер) только у создателя семьи.",
					"Ок", "Назад");
				return 1;
			}
			if(listitem == 1)
			{
				Family_ShowRankNameList(playerid);
				return 1;
			}
			Family_DialogShowMgmt(playerid);
			return 1;
		}
		case DIALOG_FAM_LAIR_MGMTIN:
		{
			if(!response) { Family_DialogShowMgmt(playerid); return 1; }
			if(isnull(inputtext) || !strlen(inputtext))
			{
				Family_Msg(playerid, 0xFF6666FF, "Пустой ввод.");
				Family_DialogShowMgmt(playerid);
				return 1;
			}
			new kind = GetPVarInt(playerid, "fam_mgmt_kind");
			switch(kind)
			{
				case 1:
				{
					new sslot = strval(inputtext);
					if(!IsPlayerConnected(sslot))
					{
						Family_Msg(playerid, 0xFF6666FF, "Игрок не в сети или неверный ID.");
						Family_DialogShowMain(playerid);
						return 1;
					}
					new acc = Player[sslot][pID];
					new qchk[160];
					mysql_format(db_handle, qchk, sizeof(qchk), "SELECT `id` FROM `players` WHERE `id`=%d AND `family_id`>0 LIMIT 1", acc);
					mysql_tquery(db_handle, qchk, "Family_DB_OnInviteCheck", "ii", playerid, acc);
					return 1;
				}
				case 2:
				{
					SetPVarString(playerid, "fam_mg_name", inputtext);
					new qk[320];
					mysql_format(db_handle, qk, sizeof(qk),
						"UPDATE `players` SET `family_id`=-1,`family_rang`=1,`family_access`='0,0,0,0,0,0,0'\
						 WHERE `family_id`=%d AND `name`='%e' AND `family_rang`<5 LIMIT 1",
						Player[playerid][pFamilyId], inputtext);
					mysql_tquery(db_handle, qk, "Family_DB_OnMgmtKick", "i", playerid);
					return 1;
				}
				case 3:
				{
					new buf[40], us = strfind(inputtext, "_", false);
					if(us <= 0)
					{
						Family_Msg(playerid, 0xFF6666FF, "Используйте формат Ник_минуты.");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					format(buf, sizeof buf, "%s", inputtext);
					buf[us] = '\0';
					new tailm[16];
					strmid(tailm, inputtext, us + 1, strlen(inputtext), sizeof tailm);
					new minutes = strval(tailm);
					if(minutes <= 0 || minutes > 10080)
					{
						Family_Msg(playerid, 0xFF6666FF, "Минуты: от 1 до 10080 (неделя).");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					SetPVarString(playerid, "fam_mg_mute_name", buf);
					SetPVarInt(playerid, "fam_mg_secs", minutes * 60);
					new qm[400];
					mysql_format(db_handle, qm, sizeof(qm),
						"UPDATE `players` SET `family_mute`=%d WHERE `family_id`=%d AND `name`='%e' AND `family_rang`<5 LIMIT 1",
						minutes * 60, Player[playerid][pFamilyId], buf);
					mysql_tquery(db_handle, qm, "Family_DB_OnMgmtMuteApply", "i", playerid);
					return 1;
				}
				case 4:
				{
					SetPVarString(playerid, "fam_mg_unmute", inputtext);
					new qu[320];
					mysql_format(db_handle, qu, sizeof(qu),
						"UPDATE `players` SET `family_mute`=0 WHERE `family_id`=%d AND `name`='%e' LIMIT 1",
						Player[playerid][pFamilyId], inputtext);
					mysql_tquery(db_handle, qu, "Family_DB_OnMgmtUnmute", "i", playerid);
					return 1;
				}
				case 6:
				{
					new us2 = strfind(inputtext, "_", false);
					if(us2 <= 0)
					{
						Family_Msg(playerid, 0xFF6666FF, "Используйте формат ID_ранг (игровой слот).");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					new sidpart[12], tailr[8];
					strmid(sidpart, inputtext, 0, us2, sizeof sidpart);
					strmid(tailr, inputtext, us2 + 1, strlen(inputtext), sizeof tailr);
					new tid = strval(sidpart);
					new rnk = strval(tailr);
					if(!IsPlayerConnected(tid))
					{
						Family_Msg(playerid, 0xFF6666FF, "Игрок не в сети или неверный ID.");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					if(Player[tid][pFamilyId] != Player[playerid][pFamilyId])
					{
						Family_Msg(playerid, 0xFF6666FF, "Игрок не в вашей семье.");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					if(Player[tid][pFamilyLeader])
					{
						Family_Msg(playerid, 0xFF6666FF, "Ранг лидера (5) нельзя выдать или сменить через меню.");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					if(rnk < 1 || rnk > FAMILY_RANK_MAX_MEMBER)
					{
						Family_Msg(playerid, 0xFF6666FF, "Доступны только ранги с 1 по 4.");
						Family_DialogShowMgmt(playerid);
						return 1;
					}
					SetPVarInt(playerid, "fam_mg_target_uid", Player[tid][pID]);
					new qr[200];
					mysql_format(db_handle, qr, sizeof(qr),
						"UPDATE `players` SET `family_rang`=%d WHERE `family_id`=%d AND `id`=%d AND `family_rang`<5 LIMIT 1",
						rnk, Player[playerid][pFamilyId], Player[tid][pID]);
					mysql_tquery(db_handle, qr, "Family_DB_OnMgmtRank", "ii", playerid, rnk);
					return 1;
				}
			}
			Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAMILY_SUMMARY:
		{
			if(response) Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAMILY_FLEET_EMPTY:
		{
			if(response) Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAMILY_FLEET:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(listitem < 0 || listitem >= FamilyDlgFleetCount[playerid]) return 1;
			Family_DialogShowFleetActions(playerid, FamilyDlgFleetCarDb[playerid][listitem]);
			return 1;
		}
		case DIALOG_FAMILY_FLEET_ACT:
		{
			if(!response) return Family_DialogOpenFleetQuery(playerid), 1;
			new cid = FamilyDlgSelCarDb[playerid];
			if(cid <= 0) return Family_DialogOpenFleetQuery(playerid), 1;
			if(Player[playerid][pFamilyLeader])
			{
				if(listitem == 0) { Family_FleetBeginAction(playerid, cid, 1, 0, 0); SetTimerEx("Family_DlgReopenFleet", 500, false, "i", playerid); return 1; }
				if(listitem == 1) { Family_FleetBeginAction(playerid, cid, 4, 0, 0); SetTimerEx("Family_DlgReopenFleet", 500, false, "i", playerid); return 1; }
				if(listitem == 2) { Family_FleetBeginAction(playerid, cid, 9, 0, 0); SetTimerEx("Family_DlgReopenFleet", 500, false, "i", playerid); return 1; }
				if(listitem == 3) { Family_DialogShowFleetRankPick(playerid, cid); return 1; }
				if(listitem == 4) return Family_DialogOpenFleetQuery(playerid), 1;
			}
			else
			{
				if(listitem == 0) { Family_FleetBeginAction(playerid, cid, 1, 0, 0); SetTimerEx("Family_DlgReopenFleet", 500, false, "i", playerid); return 1; }
				if(listitem == 1) { Family_FleetBeginAction(playerid, cid, 4, 0, 0); SetTimerEx("Family_DlgReopenFleet", 500, false, "i", playerid); return 1; }
				if(listitem == 2)
				{
					Family_FleetNotifyDenied(playerid);
					Family_DialogShowFleetActions(playerid, cid);
					return 1;
				}
				if(listitem == 3) return Family_DialogOpenFleetQuery(playerid), 1;
			}
			return 1;
		}
		case DIALOG_FAM_FLEET_RANK:
		{
			new cid = FamilyDlgSelCarDb[playerid];
			if(!response)
			{
				if(cid > 0) Family_DialogShowFleetActions(playerid, cid);
				else Family_DialogOpenFleetQuery(playerid);
				return 1;
			}
			if(!Player[playerid][pFamilyLeader])
			{
				Family_FleetNotifyDenied(playerid);
				if(cid > 0) Family_DialogShowFleetActions(playerid, cid);
				return 1;
			}
			if(listitem == 5)
			{
				if(cid > 0) Family_DialogShowFleetActions(playerid, cid);
				return 1;
			}
			if(listitem < 0 || listitem > 4)
			{
				if(cid > 0) Family_DialogShowFleetActions(playerid, cid);
				return 1;
			}
			if(cid <= 0) return Family_DialogOpenFleetQuery(playerid), 1;
			Family_FleetSaveAccessRank(playerid, cid, listitem + 1);
			SetTimerEx("Family_DlgReopenFleet", 350, false, "i", playerid);
			return 1;
		}
		case DIALOG_FAMILY_UPGRADE:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(!Player[playerid][pFamilyLeader]) return Family_DialogShowMain(playerid), 1;
			if(listitem >= 0 && listitem <= 2) Family_TryBuyUpgrade(playerid, listitem);
			Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAMILY_UPGRADE_DENY:
		{
			if(response) Family_DialogShowMain(playerid);
			return 1;
		}
		case DIALOG_FAMILY_LEAVE:
		{
			if(!response) { Family_DialogShowMain(playerid); return 1; }
			if(Player[playerid][pFamilyLeader])
			{
				Family_Msg(playerid, 0xFF6666FF, "Лидер не может выйти через это меню.");
				Family_DialogShowMain(playerid);
				return 1;
			}
			new q[220];
			mysql_format(db_handle, q, sizeof(q),
				"UPDATE `players` SET `family_id`=-1,`family_rang`=1,`family_access`='0,0,0,0,0,0,0' WHERE `id`=%d AND `family_id`=%d AND `family_rang`<5 LIMIT 1",
				Player[playerid][pID], Player[playerid][pFamilyId]);
			mysql_tquery(db_handle, q, "Family_DB_OnLeaveFamily", "i", playerid);
			return 1;
		}
	}
	return 0;
}

stock Family_ShowCreateDialog(playerid)
{
	if(Player[playerid][pID] == 0)
		return Family_Msg(playerid, 0xCECECEFF, "Сначала войдите в аккаунт."), 0;
	if(Player[playerid][pFamilyId] != 0)
		return Family_Msg(playerid, 0xCECECEFF, "Вы уже состоите в семье."), 0;
	if(!Family_HasCreateMoney(playerid))
		return Family_Msg(playerid, 0xFF6666FF, "Для создания семьи нужно 3.000.000 рублей на руках."), 0;
	ShowPlayerDialog(playerid, DIALOG_FAMILY_CREATE, DIALOG_STYLE_INPUT,
		"{E0584B}Создание семьи",
		"{FFFFFF}Стоимость: {E0584B}3.000.000 рублей{FFFFFF}.\n\nВведите название семьи:",
		"Создать", "Отмена");
	return 1;
}

stock Family_OnCreateDialog(playerid, response, inputtext[])
{
	if(!response) return 1;
	if(isnull(inputtext) || !strlen(inputtext))
		return Family_ShowCreateDialog(playerid), 1;
	if(!Family_IsValidName(inputtext))
	{
		Family_Msg(playerid, 0xFF6666FF, "Недопустимое название (3-24 символа, латиница, цифры, пробел, _).");
		Family_ShowCreateDialog(playerid);
		return 1;
	}
	if(!Family_HasCreateMoney(playerid))
		return Family_Msg(playerid, 0xFF6666FF, "Для создания семьи нужно 3.000.000 рублей на руках."), 1;
	SetPVarString(playerid, "FamCreateName", inputtext);
	new q[128];
	mysql_format(db_handle, q, sizeof(q), "SELECT `id` FROM `family` WHERE `name` = '%e' LIMIT 1", inputtext);
	mysql_tquery(db_handle, q, "Family_DB_OnNameFree", "i", playerid);
	return 1;
}

static stock Family_FleetSyncFamilyCarsRow(fid, car_db_id)
{
	if(fid <= 0 || car_db_id <= 0) return 0;
	new qd[96], qi[480];
	mysql_format(db_handle, qd, sizeof(qd), "DELETE FROM `family_cars` WHERE `ownable_id`=%d LIMIT 1", car_db_id);
	mysql_tquery(db_handle, qd, "", "");
	mysql_format(db_handle, qi, sizeof(qi),
		"INSERT INTO `family_cars` (`family_owner`,`model_id`,`color_1`,`color_2`,`number`,`pos_x`,`pos_y`,`pos_z`,`angle`,`rang`,`create_time`,`ownable_id`)\
		 SELECT %d, `model`, `color1`, `color2`,\
		 IF(CHAR_LENGTH(IFNULL(`plate_number`,''))>0, LEFT(`plate_number`,7), '------'),\
		 `x`, `y`, `z`, `a`, 1, %d, `id` FROM `ownable_cars` WHERE `id`=%d LIMIT 1",
		fid, gettime(), car_db_id);
	mysql_tquery(db_handle, qi, "", "");
	return 1;
}

stock Family_FleetDeleteFamilyCarsRow(car_db_id)
{
	if(car_db_id <= 0) return 0;
	new q[120];
	mysql_format(db_handle, q, sizeof(q), "DELETE FROM `family_cars` WHERE `ownable_id`=%d LIMIT 1", car_db_id);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

forward Family_DB_OnFleetAdd(playerid, car_db_id);
forward Family_DB_OnFleetStripPersonal(playerid);

stock Family_FleetRequestStripPersonalCars(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	new q[520];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT DISTINCT `cid` FROM (\
		 SELECT ff.`car_db_id` AS `cid` FROM `family_fleet` ff\
		 LEFT JOIN `ownable_cars` oc ON oc.`id` = ff.`car_db_id`\
		 WHERE ff.`original_owner_uid` = %d OR oc.`owner_id` = %d\
		 UNION\
		 SELECT fc.`ownable_id` AS `cid` FROM `family_cars` fc\
		 WHERE fc.`family_owner` = %d AND fc.`ownable_id` > 0) AS `t` WHERE `cid` > 0",
		Player[playerid][pID], Player[playerid][pID], Player[playerid][pFamilyId]);
	mysql_tquery(db_handle, q, "Family_DB_OnFleetStripPersonal", "i", playerid);
	return 1;
}

public Family_DB_OnFleetStripPersonal(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	for(new r = 0; r < rows; r++)
	{
		new cid = cache_get_field_content_int(r, "cid", db_handle);
		if(cid <= 0) continue;
		for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
		{
			if(VehicleInfo[playerid][s][vDBID] != cid) continue;
			if(VehicleInfo[playerid][s][vFamFleetBorrow]) continue;
			ResetPlayerVehicleSlot(playerid, s);
		}
	}
	return 1;
}

public Family_DB_OnFleetAdd(playerid, car_db_id)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new ins = cache_insert_id();
	new aff = cache_affected_rows();
	if(ins <= 0 && aff == 0)
	{
		ShowNotification(playerid, 0, 5, 0, 0, "Не удалось добавить в семью", "");
		return Family_Msg(playerid, 0xFF6666FF, "Не удалось добавить транспорт в семью (ошибка БД)."), 1;
	}
	Family_FleetSyncFamilyCarsRow(Player[playerid][pFamilyId], car_db_id);
	new fslot = FamLaird_FindSlotByDbId(Player[playerid][pFamilyId]);
	if(fslot != -1) Family_FleetRefreshUsedCount(fslot);
	new slot = GetPVarInt(playerid, "fam_fleet_slot");
	if(slot >= 0 && slot < MAX_PLAYER_VEHICLES && VehicleInfo[playerid][slot][vDBID] == car_db_id)
		ResetPlayerVehicleSlot(playerid, slot);
	DeletePVar(playerid, "fam_fleet_slot");
	Family_LogWrite(Player[playerid][pFamilyId], Player[playerid][pID], "Транспорт добавлен в семейный автопарк", 9);
	ShowNotification(playerid, 1, 5, 0, 1, "Авто в семейном автопарке", "");
	Family_Msg(playerid, 0x88FF88FF, "Машина передана семье: снята с учёта в вашем /car и выгружена. Вернуть только лидер: /fm — семейный автопарк — «Вернуть владельцу».");
	return 1;
}

public Family_DB_OnFleetTransferDb(playerid, car_db_id)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!cache_affected_rows())
	{
		ShowNotification(playerid, 0, 5, 0, 0, "Ошибка передачи авто", "");
		Family_Msg(playerid, 0xFF6666FF, "Не удалось передать машину семье (ошибка базы).");
		DeletePVar(playerid, "fam_fleet_slot");
		return 1;
	}
	if(!Family_FleetCanAddMore(playerid))
	{
		new qback[220];
		new orig_uid = Player[playerid][pID];
		mysql_format(db_handle, qback, sizeof(qback),
			"UPDATE `ownable_cars` SET `owner_id`=%d, `owner_name`='%e' WHERE `id`=%d AND `owner_id`=0 LIMIT 1",
			orig_uid, Player[playerid][pName], car_db_id);
		mysql_tquery(db_handle, qback, "", "");
		new slot = GetPVarInt(playerid, "fam_fleet_slot");
		if(slot >= 0 && slot < MAX_PLAYER_VEHICLES)
			LoadPlayerVehicles(playerid);
		return Family_FleetRejectSlotFull(playerid), 1;
	}
	new slot = GetPVarInt(playerid, "fam_fleet_slot");
	new orig = Player[playerid][pID];
	ResetPlayerVehicleSlot(playerid, slot);
	DeletePVar(playerid, "fam_fleet_slot");
	new qi[320];
	mysql_format(db_handle, qi, sizeof(qi),
		"INSERT INTO `family_fleet` (`family_id`,`car_db_id`,`access_rank`,`added_by_uid`,`original_owner_uid`) VALUES (%d,%d,1,%d,%d)",
		Player[playerid][pFamilyId], car_db_id, Player[playerid][pID], orig);
	mysql_tquery(db_handle, qi, "Family_DB_OnFleetAdd", "ii", playerid, car_db_id);
	return 1;
}

public Family_DB_OnFleetPrecheck(playerid, car_db_id)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
	{
		new fid = cache_get_field_content_int(0, "family_id", db_handle);
		if(fid == Player[playerid][pFamilyId])
		{
			ShowNotification(playerid, 0, 5, 0, 0, "Уже в семейном автопарке", "");
			Family_Msg(playerid, 0xFF6666FF, "Этот транспорт уже в автопарке вашей семьи.");
		}
		else
		{
			ShowNotification(playerid, 0, 5, 0, 0, "Машина у другой семьи", "");
			Family_Msg(playerid, 0xFF6666FF, "Этот транспорт закреплён за другой семьёй.");
		}
		DeletePVar(playerid, "fam_fleet_slot");
		return 1;
	}
	if(!Family_FleetCanAddMore(playerid))
		return Family_FleetRejectSlotFull(playerid), 1;
	new q[220];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `ownable_cars` SET `owner_id`=0, `owner_name`='' WHERE `id`=%d AND `owner_id`=%d LIMIT 1",
		car_db_id, Player[playerid][pID]);
	mysql_tquery(db_handle, q, "Family_DB_OnFleetTransferDb", "ii", playerid, car_db_id);
	return 1;
}

stock Family_FleetRequestAddCarDb(playerid, car_db_id)
{
	if(Player[playerid][pID] == 0) return 0;
	if(Player[playerid][pFamilyId] == 0) return 0;
	if(car_db_id <= 0) return 0;
	if(!Family_FleetCanAddMore(playerid))
		return Family_FleetRejectSlotFull(playerid), 0;
	new q[200];
	mysql_format(db_handle, q, sizeof(q),
		"SELECT `family_id` FROM `family_fleet` WHERE `car_db_id`=%d LIMIT 1", car_db_id);
	mysql_tquery(db_handle, q, "Family_DB_OnFleetPrecheck", "ii", playerid, car_db_id);
	return 1;
}

public Fam_DB_OnCarDbSlot(playerid, slot)
{
	if(!IsPlayerConnected(playerid)) return 1;
	SetPVarInt(playerid, "fam_fleet_slot", slot);
	if(slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 1;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows == 0)
	{
		ShowNotification(playerid, 0, 5, 0, 0, "Ошибка БД авто", "");
		Family_Msg(playerid, 0xFF6666FF, "Машина не найдена в ownable_cars. Перезайдите в игру.");
		return 1;
	}
	new cid = cache_get_field_content_int(0, "id", db_handle);
	if(cid <= 0) return 1;
	VehicleInfo[playerid][slot][vDBID] = cid;
	if(!Family_FleetCanAddMore(playerid))
		return Family_FleetRejectSlotFull(playerid), 1;
	ShowNotification(playerid, 1, 5, 0, 0, "Добавляем в семью...", "");
	return Family_FleetRequestAddCarDb(playerid, cid);
}

stock Family_TryAddFleetFromCarMenu(playerid, slot)
{
	if(slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
	SetPVarInt(playerid, "fam_fleet_slot", slot);
	if(VehicleInfo[playerid][slot][vModel] == 0) return 0;
	if(Player[playerid][pFamilyId] == 0)
	{
		ShowNotification(playerid, 0, 5, 0, 0, "Вы не в семье", "");
		Family_Msg(playerid, 0xCECECEFF, "Вы не состоите в семье.");
		return 0;
	}
	if(!Player[playerid][pFamilyLeader])
	{
		ShowNotification(playerid, 0, 5, 0, 0, "Только лидер", "");
		Family_Msg(playerid, 0xFF6666FF, "Добавлять транспорт в семью может только лидер.");
		return 0;
	}
	new cid = VehicleInfo[playerid][slot][vDBID];
	if(cid <= 0)
	{
		new qr[200];
		mysql_format(db_handle, qr, sizeof(qr),
			"SELECT `id` FROM `ownable_cars` WHERE `owner_id`=%d ORDER BY `id` ASC LIMIT 1 OFFSET %d",
			Player[playerid][pID], slot);
		mysql_tquery(db_handle, qr, "Fam_DB_OnCarDbSlot", "ii", playerid, slot);
		return 1;
	}
	if(!Family_FleetCanAddMore(playerid))
		return Family_FleetRejectSlotFull(playerid), 0;
	ShowNotification(playerid, 1, 5, 0, 0, "Добавляем в семью...", "");
	return Family_FleetRequestAddCarDb(playerid, cid);
}

CMD:addfamcar(playerid, params[])
{
	#pragma unused params
	if(Player[playerid][pID] == 0) return 1;
	if(Player[playerid][pFamilyId] == 0)
		return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье."), 1;
	if(!Player[playerid][pFamilyLeader])
		return Family_Msg(playerid, 0xFF6666FF, "Добавлять транспорт может только лидер семьи."), 1;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return Family_Msg(playerid, 0xCECECEFF, "Сядьте за руль своего транспорта."), 1;
	new veh = GetPlayerVehicleID(playerid);
	if(!veh)
		return Family_Msg(playerid, 0xCECECEFF, "Вы должны быть в транспорте."), 1;
	new slot = GetPlayerVehicleSlot(playerid, veh);
	if(slot == -1)
		return Family_Msg(playerid, 0xCECECEFF, "Это не ваш личный транспорт."), 1;
	if(!Family_FleetCanAddMore(playerid))
		return Family_FleetRejectSlotFull(playerid), 1;
	SetPVarInt(playerid, "fam_fleet_slot", slot);
	new cid = VehicleInfo[playerid][slot][vDBID];
	if(cid <= 0)
	{
		new qr[200];
		mysql_format(db_handle, qr, sizeof(qr),
			"SELECT `id` FROM `ownable_cars` WHERE `owner_id`=%d ORDER BY `id` ASC LIMIT 1 OFFSET %d",
			Player[playerid][pID], slot);
		mysql_tquery(db_handle, qr, "Fam_DB_OnCarDbSlot", "ii", playerid, slot);
		return 1;
	}
	Family_FleetRequestAddCarDb(playerid, cid);
	return 1;
}

CMD:createfm(playerid, params[])
{
	#pragma unused params
	Family_ShowCreateDialog(playerid);
	return 1;
}

CMD:fm(playerid, params[])
{
	#pragma unused params
	Family_ShowMenu(playerid);
	return 1;
}

CMD:fam(playerid, params[])
{
	if(Player[playerid][pID] == 0) return 1;
	if(Player[playerid][pFamilyId] == 0)
		return Family_Msg(playerid, 0xCECECEFF, "Вы не в семье. Используйте /createfm"), 1;
	if(GetPVarInt(playerid, "fam_mute_left") > 0)
		return Family_Msg(playerid, 0xFF6666FF, "[Семья] У вас мут семейного чата."), 1;
	if(isnull(params) || !strlen(params))
		return Family_Msg(playerid, 0xCECECEFF, "Использование: /fam [сообщение]"), 1;

	new fname[32];
	format(fname, sizeof fname, "%s", Player[playerid][pFamilyName]);
	if(!strlen(fname)) format(fname, sizeof fname, "Семья");

	new rtitle[40], msg[196];
	Family_FormatRankTitleForPlayer(playerid, rtitle, sizeof rtitle);
	format(msg, sizeof msg,
		"[%s] %s (%s) [ID:%d]: %s",
		fname, Player[playerid][pName], rtitle, playerid, params);

	new col = Family_GetFamilyMsgColor(Player[playerid][pFamilyId]);
	for(new i = 0; i <= GetPlayerPoolSize(); i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][pFamilyId] == Player[playerid][pFamilyId])
			SendClientMessage(i, col, msg);
	}
	return 1;
}
