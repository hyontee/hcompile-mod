#define TABLE_FAMILY			"s_family"
#define TABLE_HOUSE_FAMILY      "s_family_house"
#define TABLE_FAMILE_BLACK_LIST "s_family_blacklist"

#define	FAMILY_COUNT            500
#define FAMILY_HOUSE_COUNT      100
#define Family:                 FS_
#define MAX_FAMILY_LIST         (20)


 new
    GetFamilyHouseRent = 1000; // LandTax 
new 
    FamilyCenter[2];
 
enum E_FAMILY_SERVER
{
    fID,
    fName[32],
    fOwner[MAX_PLAYER_NAME],
    fNationality,
    fRepute,
    fCoins,
    fPrefix,
    fType,
    fChatColor,
    fHouse,//Особоняк
    fDefHouse,//Обычный дом
	fSettings[10],
    fBank,
    fBankLock,
    fSafeLock,
    fLimitLevel,
    fLimitRating,
    fPromoID
}
new FamilyInfo[FAMILY_COUNT][E_FAMILY_SERVER], S_FAMILY_COUNT = 0;
Family:GetFamilyData(family_id, E_FAMILY_SERVER:type) {
    return FamilyInfo[family_id][type];
}

new fFamilyRank[FAMILY_COUNT][20][30];

new Iterator: PlayerInFamily[FAMILY_COUNT]<MAX_PLAYERS>;
new Iterator: FamilyListVehicle[FAMILY_COUNT]<MAX_VEHICLES>;

new family_label_prefix[][] ={
    "1","@", "#", "&", "©", "?", "•", "€", "®", "™", "$", "»"
};
new family_label_type[9][20] ={
    "Family", "Crew", "Squad", "Gang", "Corporation", "Band", "Group", "Empire", "Clan"
};
new family_chat_color[][] =
{
    "FFFFFF","ff9933","FFFF00","54FF9F","98F5FF",
	"e97451","660000","721422","ed0744","871b41",
	"fd5e53","007d34","ffd700", "FF1493", "FF4500", 
    "800080", "8B4513", "C0C0C0", "708090", "808080", 
    "4169E1", "556B2F"
}; 
enum E_FAMILY_HOUSE
{
    fhID,
    fhOwner[32],
    Float: fhEnter[4],
    Float: fhExit[4], 
    fhIntID,
    fhWorld,
    fhCost,
    fhLandTax,
    fhLock,
    fhUpdate[5],
    fhStore[5],
    fhStoreLevel,
    fhBikers,
    Text3D: fhText,
    Text3D: fhTextStore,
    fhUpdateActor,
    fhUpdatePickup,
    fhUpdateTrigger,
    fhPickup[2],
    fhArea
}

new FamilyHouse[FAMILY_HOUSE_COUNT][E_FAMILY_HOUSE],
    S_FAMILY_HOUSE_COUNT,
    fHouseImproveCost[] = {200_000, 400_000, 1_000_000, 0, 0},
	fHouseImproveName[][36] = {"Гардероб","Дворецкий","Склад", "-", "-"},
    StoreMaterialsLimit[] = {50_000, 100_000, 150_000, 200_000, 250_000},
    StoreCashLimit[] = {5_000_000, 15_000_000, 30_000_000, 40_000_000, 50_000_000};
new 
    Text: FamilyHouse_TD[13],
    PlayerText: FamilyHouse_PTD[MAX_PLAYERS][3];
enum F_HOUSE_INTERIOR_
{
    fID,
    Float: fExit[4],
    Float: fSpawn[4],
    Float: fWareHouse[3],
    Float: fClothes[3],
    Float: fButler[4],
    fInterior
}//Дворецкий/Гардероб/Склад
new FamilyInterior[][F_HOUSE_INTERIOR_] = {
    {1, {2245.2524, 855.8911, 1082.4661, 88.0}, {2237.5156,868.9965,1082.4583,180.0}, {2260.1350,854.7747,1086.1190}, {2254.3635,859.5597,1086.1190}, {2243.8687, 858.2045, 1082.4583, 180.0}, FAMILY_INT_0},
    {2, {1287.4315, 2122.8418, 1069.4065, 90.0}, {1275.9235,2129.5393,1069.4006,185.0}, {1287.9906,2112.1941,1072.8966}, {1288.4436,2115.7112,1072.8947}, {1284.7050, 2121.2004, 1069.4065, 5.1526}, FAMILY_INT_1},
    {3, {1934.7755, 279.6161, 1371.4218, 267.7819}, {1948.1215,282.9420,1374.9434,275.0120}, {1952.4229,258.0454,1374.9434}, {2254.3635,859.5597,1086.1190}, {2243.8687, 858.2045, 1082.4583, 180.0}, 5},
    {4, {1934.7755, 279.6161, 1371.4218, 267.7819}, {1948.1215,282.9420,1374.9434,275.0120}, {1952.4229,258.0454,1374.9434}, {2254.3635,859.5597,1086.1190}, {2243.8687, 858.2045, 1082.4583, 180.0}, 5},
    {5, {1934.7755, 279.6161, 1371.4218, 267.7819}, {1948.1215,282.9420,1374.9434,275.0120}, {1952.4229,258.0454,1374.9434}, {2254.3635,859.5597,1086.1190}, {2243.8687, 858.2045, 1082.4583, 180.0}, 5}
};

Family_OnGameModeInit()
{
    Iter_Init(PlayerInFamily);
    Iter_Init(FamilyListVehicle);
    mysql_tquery(
        dbHandle, "SELECT * FROM "TABLE_FAMILY" ORDER BY "TABLE_FAMILY".`fID` ASC", #OnLoadFamilyData\
    );
    OnLoadFamilyData();
    LoadFamilyHouse();
    FamilyCenter[0] = CreateDynamicPickup(19132, 23, -1880.7670,822.3905,35.1778, 0, INTERIOR_NONE );
    FamilyCenter[1] = CreateDynamicPickup(19132, 23, 2038.6377,2175.0823,1312.7385, 1, FAMILY_CENTER_INT );
    
    return;
}
 
publics: OnLoadFamilyData()
{
    new 
        time = GetTickCount();
    cache_get_row_count(S_FAMILY_COUNT);
    if (!S_FAMILY_COUNT) return print(!"[Загрузка ...] Данные из Family не получены!");
    for(new F_IDX = 0, setting_mass[128]; F_IDX < S_FAMILY_COUNT; F_IDX++)
    {
        cache_get_value_name_int(F_IDX, "fID", FamilyInfo[F_IDX][fID]);
        cache_get_value_name(F_IDX, "fName", FamilyInfo[F_IDX][fName], 68);
        cache_get_value_name(F_IDX, "fOwner", FamilyInfo[F_IDX][fOwner], MAX_PLAYER_NAME);
        cache_get_value_name_int(F_IDX, "fNationality", FamilyInfo[F_IDX][fNationality]);
        cache_get_value_name_int(F_IDX, "fRepute", FamilyInfo[F_IDX][fRepute]);
        cache_get_value_name_int(F_IDX, "fCoins", FamilyInfo[F_IDX][fCoins]);
        cache_get_value_name_int(F_IDX, "fPrefix", FamilyInfo[F_IDX][fPrefix]);
        cache_get_value_name_int(F_IDX, "fType", FamilyInfo[F_IDX][fType]);
        cache_get_value_name_int(F_IDX, "fChatColor", FamilyInfo[F_IDX][fChatColor]);
        cache_get_value_name_int(F_IDX, "fHouse", FamilyInfo[F_IDX][fHouse]);
        cache_get_value_name_int(F_IDX, "fDefHouse", FamilyInfo[F_IDX][fDefHouse]);
        cache_get_value_name(F_IDX, "fSettings", setting_mass, sizeof setting_mass);
        sscanf(setting_mass, "p<|>a<d>[10]", FamilyInfo[F_IDX][fSettings]);

        if (FamilyInfo[F_IDX][fSettings][4] == 0) { 
            FamilyInfo[F_IDX][fSettings][4] = FamilyInfo[F_IDX][fSettings][3]; //Open/Closed Bank
            FamilyInfo[F_IDX][fSettings][5] = FamilyInfo[F_IDX][fSettings][3]; //Open/Closed Safe
        }
        

        t_string[0] = EOS;
        cache_get_value_name(F_IDX, "fRanks", t_string, 384);
        sscanf(t_string, "p<|>s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]",
        fFamilyRank[F_IDX][0], fFamilyRank[F_IDX][1], fFamilyRank[F_IDX][2], fFamilyRank[F_IDX][3],
        fFamilyRank[F_IDX][4], fFamilyRank[F_IDX][5], fFamilyRank[F_IDX][6], fFamilyRank[F_IDX][7],
        fFamilyRank[F_IDX][8], fFamilyRank[F_IDX][9], fFamilyRank[F_IDX][10], fFamilyRank[F_IDX][11]);


        cache_get_value_name_int(F_IDX, "fBank", FamilyInfo[F_IDX][fBank]);
        cache_get_value_name_int(F_IDX, "fBankLock", FamilyInfo[F_IDX][fBankLock]);
        cache_get_value_name_int(F_IDX, "fSafeLock", FamilyInfo[F_IDX][fSafeLock]);
        cache_get_value_name_int(F_IDX, "fLimitLevel", FamilyInfo[F_IDX][fLimitLevel]);
        cache_get_value_name_int(F_IDX, "fLimitRating", FamilyInfo[F_IDX][fLimitRating]);
        cache_get_value_name_int(F_IDX, "fPromoID", FamilyInfo[F_IDX][fPromoID]);

       
    }
    printf("[Загрузка ...] Данные из s_family получены! (%d шт.) Время: %d", S_FAMILY_COUNT, GetTickCount() - time);
    return 1;
}
 
stock LoadFamilyHouse()
{
	new 
        time = GetTickCount(), 
        Cache: tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_HOUSE_FAMILY"");
	cache_get_row_count(S_FAMILY_HOUSE_COUNT);
    if (!S_FAMILY_HOUSE_COUNT) {
        print(!"[Загрузка ...] Данные из s_family_house не получены!");
        if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
        return 1;
    }
	for(new i = 0, data_[128]; i < S_FAMILY_HOUSE_COUNT; i++)
	{
        cache_get_value_name_int(i, "hID", FamilyHouse[i][fhID]);
        cache_get_value_name(i, "hOwner", FamilyHouse[i][fhOwner], 32);
        cache_get_value_name_int(i, "hCost", FamilyHouse[i][fhCost]);
        cache_get_value_name_int(i, "hLandTax", FamilyHouse[i][fhLandTax]);
        cache_get_value_name(i, "hEnter", data_, sizeof data_);
        sscanf(data_,"p<|>a<f>[4]", FamilyHouse[i][fhEnter]);

        cache_get_value_name(i, "hExit", data_, sizeof data_);
        sscanf(data_,"p<|>a<f>[4]", FamilyHouse[i][fhExit]);

        cache_get_value_name_int(i, "hInterior", FamilyHouse[i][fhIntID]);
        cache_get_value_name_int(i, "hLock", FamilyHouse[i][fhLock]); 
        cache_get_value_name_int(i, "hBikers", FamilyHouse[i][fhBikers]); 

        cache_get_value_name(i, "hUpdate", data_, sizeof data_);
        sscanf(data_,"p<|>a<d>[5]", FamilyHouse[i][fhUpdate]); 

        cache_get_value_name(i, "hStore", data_, sizeof data_);
        sscanf(data_,"p<|>a<d>[5]", FamilyHouse[i][fhStore]); 

        cache_get_value_name_int(i, "hStoreLevel", FamilyHouse[i][fhStoreLevel]);
        
        FamilyHouse[i][fhText] = CreateDynamic3DTextLabel("_", COLOR_WHITE, 
            FamilyHouse[i][fhEnter][0], FamilyHouse[i][fhEnter][1], FamilyHouse[i][fhEnter][2], 
            5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0
        );
        UpdateFamilyHouse(i);
        CreateFamilyUpdate(i, true);
	    FamilyHouse[i][fhPickup][0] = CreateDynamicPickup(19523, 23, 
            FamilyHouse[i][fhEnter][0], FamilyHouse[i][fhEnter][1], FamilyHouse[i][fhEnter][2], 0, INTERIOR_NONE
        );

        CreateDynamicMapIcon(FamilyHouse[i][fhEnter][0], FamilyHouse[i][fhEnter][1], FamilyHouse[i][fhEnter][2], 23, 0, 0, INTERIOR_NONE); //W//INT

        new 
            f_int = FamilyHouse[i][fhIntID]; 
     	FamilyHouse[i][fhPickup][1] = CreateDynamicPickup(19132, 23, 
            FamilyInterior[f_int][fExit][0], FamilyInterior[f_int][fExit][1], FamilyInterior[f_int][fExit][2], 
            (FamilyHouse[i][fhID]+50), FamilyInterior[f_int][fInterior]
        );
        
     	FamilyHouse[i][fhArea] = CreateDynamicSphere(FamilyHouse[i][fhEnter][0], FamilyHouse[i][fhEnter][1], FamilyHouse[i][fhEnter][2], 1.0, 0, INTERIOR_NONE);
        SetDynamicAreaType(FamilyHouse[i][fhArea], AREA_TYPE_FAMILY_HOUSE, i);

	}
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery); 
    printf("[Загрузка ...] Данные из s_family_house получены! (%d шт.) Время: %d", S_FAMILY_HOUSE_COUNT, GetTickCount() - time);
	return true;
}
stock CreateFamilyUpdate(houseid, bool: create = false, number = -1) {
    new 
        f_int = FamilyHouse[houseid][fhIntID]; 
    if (create == true) {
        if (FamilyHouse[houseid][fhUpdate][0]) { 
            FamilyHouse[houseid][fhUpdatePickup] = CreateDynamicPickup(1275, 23, FamilyInterior[f_int][fClothes][0], FamilyInterior[f_int][fClothes][1], FamilyInterior[f_int][fClothes][2], 
                (FamilyHouse[houseid][fhID]+50), FamilyInterior[f_int][fInterior]
            );
        } 
        if (FamilyHouse[houseid][fhUpdate][1]) {
            FamilyHouse[houseid][fhUpdateActor] = CreateDynamicActor(random(70) + 1, FamilyInterior[f_int][fButler][0], FamilyInterior[f_int][fButler][1], FamilyInterior[f_int][fButler][2], FamilyInterior[f_int][fButler][3],
                .worldid = (FamilyHouse[houseid][fhID]+50), .interiorid = FamilyInterior[f_int][fInterior]
            );
        }
        if (FamilyHouse[houseid][fhUpdate][2]) {
            format(t_string, sizeof t_string, "{FFD700}Склад %s\n"colwhi"Материалы: {F58B11}%d/%d\n"colwhi"Деньги: {F58B11}$%d/%d\n\n\
                {CAFA0A}Используйте: ALT", FamilyHouse[houseid][fhOwner], FamilyHouse[houseid][fhStore][0], StoreMaterialsLimit[FamilyHouse[houseid][fhStoreLevel]], 
                FamilyHouse[houseid][fhStore][1], StoreCashLimit[FamilyHouse[houseid][fhStoreLevel]]
            );
            FamilyHouse[houseid][fhTextStore] = CreateDynamic3DTextLabel(t_string, -1, FamilyInterior[f_int][fWareHouse][0], FamilyInterior[f_int][fWareHouse][1], FamilyInterior[f_int][fWareHouse][2], 
                10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, (FamilyHouse[houseid][fhID]+50), FamilyInterior[f_int][fInterior]
            ), t_string[0] = EOS;
            FamilyHouse[houseid][fhUpdateTrigger] = CreateDynamicTrigger(FamilyInterior[f_int][fWareHouse][0], FamilyInterior[f_int][fWareHouse][1], FamilyInterior[f_int][fWareHouse][2], (FamilyHouse[houseid][fhID]+50), FamilyInterior[f_int][fInterior], 1);
        }
    }
    else {
        if (number == 0) {
            FamilyHouse[houseid][fhUpdatePickup] = CreateDynamicPickup(1275, 23, FamilyInterior[f_int][fClothes][0], FamilyInterior[f_int][fClothes][1], FamilyInterior[f_int][fClothes][2], 
                (FamilyHouse[houseid][fhID]+50), FamilyInterior[f_int][fInterior]
            );
        }
        else if (number == 1) {
            FamilyHouse[houseid][fhUpdateActor] = CreateDynamicActor(random(70) + 1, FamilyInterior[f_int][fButler][0], FamilyInterior[f_int][fButler][1], FamilyInterior[f_int][fButler][2], FamilyInterior[f_int][fButler][3],
                .worldid = (FamilyHouse[houseid][fhID]+50), .interiorid = FamilyInterior[f_int][fInterior]
            );
        }
        else if (number == 2) {
            format(t_string, sizeof t_string, "{FFD700}Склад %s\n"colwhi"Материалы: {F58B11}%d/%d\n"colwhi"Деньги: {F58B11}$%d/%d\n\n\
                {CAFA0A}Используйте: ALT", FamilyHouse[houseid][fhOwner], FamilyHouse[houseid][fhStore][0], StoreMaterialsLimit[FamilyHouse[houseid][fhStoreLevel]], 
                FamilyHouse[houseid][fhStore][1], StoreCashLimit[FamilyHouse[houseid][fhStoreLevel]]
            );
            FamilyHouse[houseid][fhTextStore] = CreateDynamic3DTextLabel(t_string, -1, FamilyInterior[f_int][fWareHouse][0], FamilyInterior[f_int][fWareHouse][1], FamilyInterior[f_int][fWareHouse][2], 
                10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, (FamilyHouse[houseid][fhID]+50), FamilyInterior[f_int][fInterior]
            ), t_string[0] = EOS;
            FamilyHouse[houseid][fhUpdateTrigger] = CreateDynamicTrigger(FamilyInterior[f_int][fWareHouse][0], FamilyInterior[f_int][fWareHouse][1], FamilyInterior[f_int][fWareHouse][2], (FamilyHouse[houseid][fhID]+50), FamilyInterior[f_int][fInterior], 1);
        }
    }
    
}
stock UpdateFamilyHouse(houseid) {
    t_string[0] = EOS;
    if (GetString(FamilyHouse[houseid][fhOwner],"None"))
    { 
        format(t_string, sizeof t_string, 
            ""colwhi"Семейный особняк [%d]\n\nЦена: %d Family Coins\nДверь: %s", 
            FamilyHouse[houseid][fhID], FamilyHouse[houseid][fhCost], (FamilyHouse[houseid][fhLock] == 0) ? ("{87EB7F}[Открыта]") : ("{FF5E5E}[Закрыта]")
        );  
    }
    else
    {
        if (FamilyHouse[houseid][fhBikers] != 0) {
            format(t_string, sizeof t_string, 
                ""colwhi"Семейный особняк [%d]\n\nВладеет семья: %s\nДверь: %s\n"colwhi"Крыша: {%s}%s", 
                FamilyHouse[houseid][fhID], FamilyHouse[houseid][fhOwner], 
                (FamilyHouse[houseid][fhLock] == 0) ? ("{87EB7F}[Открыта]") : ("{FF5E5E}[Закрыта]"),
                gFraction[FamilyHouse[houseid][fhBikers]][fRGBColor], gFraction[FamilyHouse[houseid][fhBikers]][fName]
            ); 
        }
        else {
            format(t_string, sizeof t_string, 
                ""colwhi"Семейный особняк [%d]\n\nВладеет семья: %s\nДверь: %s\n"colwhi"Крыша: Нет", 
                FamilyHouse[houseid][fhID], FamilyHouse[houseid][fhOwner], 
                (FamilyHouse[houseid][fhLock] == 0) ? ("{87EB7F}[Открыта]") : ("{FF5E5E}[Закрыта]")
            ); 
        }
        
    }
    UpdateDynamic3DTextLabelText(FamilyHouse[houseid][fhText], COLOR_WHITE, t_string);
    return true;
}
CMD:bikerreap(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) 
		return true;
	new mafia;
	if (sscanf(params, "d", mafia)){
	    SendClientMessage(playerid, COLOR_GREY, !"Команда: /bikerreap [bikers]");
	    return SendClientMessage(playerid, COLOR_GREY, !"Mongols = 24ID | Bandidos - 25ID | Outlaws - 26ID");
	}
	if (mafia != 24 && mafia != 25 && mafia != 26) { 
		return SendClientMessage(playerid, COLOR_GREY, !"Mongols = 24ID | Bandidos - 25ID | Outlaws - 26ID");
	}
    if (!pTemp[playerid][tSelectFamilyHouseArea]) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться возле семейного дома!");
	new
        H_IDX = pTemp[playerid][tSelectFamilyHouse];
    FamilyHouse[H_IDX][fhBikers] = mafia; 
    format(t_string, sizeof t_string, "hBikers = '%d'", FamilyHouse[H_IDX][fhBikers]);
    SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS; 
    SendClientMessage(playerid, COLOR_WHITE, !"Семья взята под Ваш контроль");
    
	new string_[128];  

	format(string_, sizeof string_, "Вы передали дом ID %d байкерам: %s", 
		H_IDX, mafia == 24 ? ("Mongols"): mafia == 25 ? ("Bandidos") : ("Outlaws")
	);
	SendClientMessage(playerid, -1, string_);
	UpdateFamilyHouse(H_IDX);
   	return true;
}
alias:bikerreap("sethouse");
stock UpdateFamilyStore(houseid, bool: save = true) {
    format(t_string, sizeof t_string, "{FFD700}Склад %s\n"colwhi"Материалы: {F58B11}%d/%d\n"colwhi"Деньги: {F58B11}$%d/%d\n\n\
        {CAFA0A}Используйте: ALT", FamilyHouse[houseid][fhOwner], FamilyHouse[houseid][fhStore][0], StoreMaterialsLimit[FamilyHouse[houseid][fhStoreLevel]], 
        FamilyHouse[houseid][fhStore][1], StoreCashLimit[FamilyHouse[houseid][fhStoreLevel]]
    );
    UpdateDynamic3DTextLabelText(FamilyHouse[houseid][fhTextStore], -1, t_string), t_string[0] = EOS;
    if (save) {
        new 
            str_[32];
        for(new i; i < 5; i++) {
            if (!i) format(str_, sizeof str_, "%d", FamilyHouse[ houseid ][fhStore][i]);
            else format(str_, sizeof str_, "%s|%d", str_, FamilyHouse[ houseid ] [fhStore][i]);
        }
        format(t_string, sizeof t_string, "hStore = '%s'", str_);
        SaveFamilyHouse(houseid, t_string), t_string[0] = EOS; 
    } 
}
publics: OnLoadFamilyCarData(family_id, type)
{
    new
        time = GetTickCount(),
        RESPAWN_CAR_TIME = -1,
        rows;
    cache_get_row_count(rows);
   // if (!rows) return print(!"[Загрузка ...] Данные из Vehicle Family не получены!");
    if (!rows) {
        /*
        new 
            query_[156];
        mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_vehicle_family` (`vFamily`, `vRank`) VALUES ('%d','1'),('%d','1'),('%d','1'),('%d','1'),('%d','1')", 
            FamilyInfo[  family_id - 1 ][fID], FamilyInfo[  family_id - 1 ][fID], FamilyInfo[  family_id - 1 ][fID], FamilyInfo[  family_id - 1 ][fID], FamilyInfo[  family_id - 1 ][fID]
        );
        mysql_tquery(dbHandle, query_), query_[0] = EOS;

        mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_vehicle_family` WHERE `vFamily` = '%d' LIMIT 5", FamilyInfo[  family_id - 1 ][fID]);
        mysql_tquery(dbHandle, query_, "OnLoadFamilyCarData", "ii", family_id, 1), query_[0] = EOS;*/
        return 1;
    }
    for(new i = 0, colors_mass[10], position_mass[128]; i < rows ; i++)
    { 
        new V_IDX = GetVehicleID();
        VehicleInfo[ V_IDX - 1 ] [vType] = VEHICLE_TYPE_FAMILY;

        cache_get_value_name_int(i, "vID", VehicleInfo[ V_IDX - 1 ][vID]);//++
        cache_get_value_name_int(i, "vModel", VehicleInfo[ V_IDX - 1 ][vModel]); //++
        cache_get_value_name_int(i, "vFamily", VehicleInfo[ V_IDX - 1 ][vFraction]);//
        cache_get_value_name_int(i, "vRank", VehicleInfo[ V_IDX - 1 ][vRank]);//++ 
        cache_get_value_name(i, "vPos", position_mass, 128);//++
        sscanf(position_mass,"p<|>a<f>[4]", VehicleInfo[ V_IDX - 1 ][vPos]);//
//
        cache_get_value_name(i, "vColor", colors_mass, 10);//++
        sscanf(colors_mass, "p<|>a<d>[2]", VehicleInfo[ V_IDX - 1 ][vColor]);// 
//
        cache_get_value_name(i, "vPT_Engine", position_mass, 16);//++
        sscanf(position_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Engine][0], VehicleInfo[ V_IDX - 1 ][vPT_Engine][1],//
        VehicleInfo[ V_IDX - 1][vPT_Engine][2], VehicleInfo[ V_IDX - 1 ][vPT_Engine][3], VehicleInfo[ V_IDX - 1 ][vPT_Engine][4]);//
//
        cache_get_value_name(i, "vPT_Brake", position_mass, 16);//++
        sscanf(position_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Brake][0], VehicleInfo[ V_IDX - 1 ][vPT_Brake][1],//
        VehicleInfo[ V_IDX - 1 ][vPT_Brake][2], VehicleInfo[ V_IDX - 1 ][vPT_Brake][3], VehicleInfo[ V_IDX - 1 ][vPT_Brake][4]);//
//
        cache_get_value_name(i, "vComponent", position_mass, 126);//++
        sscanf ( position_mass, "p<|>dddddddddd", VehicleInfo[ V_IDX - 1 ][vComponent][0], VehicleInfo[ V_IDX - 1 ][vComponent][1],//
        VehicleInfo[ V_IDX - 1 ][vComponent][2], VehicleInfo[ V_IDX - 1 ][vComponent][3], VehicleInfo[ V_IDX - 1 ][vComponent][4],
        VehicleInfo[ V_IDX - 1 ][vComponent][5], VehicleInfo[ V_IDX - 1 ][vComponent][6], VehicleInfo[ V_IDX - 1 ][vComponent][7],
        VehicleInfo[ V_IDX - 1 ][vComponent][8], VehicleInfo[ V_IDX - 1 ][vComponent][9]);

        cache_get_value_name_int(i, "vInt", VehicleInfo[ V_IDX - 1 ][vInt]);//++
        cache_get_value_name_int(i, "vWorld", VehicleInfo[ V_IDX - 1 ][vWorld]); //++
        cache_get_value_name(i, "vNumber", VehicleInfo[ V_IDX - 1 ][vNumber], 12);//++
        cache_get_value_name_float(i, "vFuel", VehicleInfo[ V_IDX - 1 ][vFuel]);//++
        if (VehicleInfo[ V_IDX - 1 ][vFuel] > GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel])) {
            VehicleInfo[ V_IDX - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel]);
        }
        cache_get_value_name_float(i, "vMillage", VehicleInfo[ V_IDX - 1 ][vMillage]);//++
        VehicleInfo[ V_IDX - 1 ][vSubFraction] = 0; 
        VehicleInfo[ V_IDX - 1 ][vJacker] = 0;
        VehicleInfo[ V_IDX - 1 ][vJackerOff] = false; 
        cache_get_value_name_int(i, "vRepair", VehicleInfo[ V_IDX - 1 ][vRepair]);//++
        cache_get_value_name_int(i, "vFillBag", VehicleInfo[ V_IDX - 1 ][vFillBag]);//++
        cache_get_value_name_int(i, "vMoney", VehicleInfo[ V_IDX - 1 ][vMoney]);//++
        cache_get_value_name_int(i, "vDrugs", VehicleInfo[ V_IDX - 1 ][vDrugs]);//++
        cache_get_value_name_int(i, "vMaterials", VehicleInfo[ V_IDX - 1 ][vMaterials]);//++
        
        new
            bootg_mass[32],
            boota_mass[32];
            
        cache_get_value_name(i, "vGun", bootg_mass, 32);
        sscanf(bootg_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootGun]);
        cache_get_value_name(i, "vAmmo", boota_mass, 32);
        sscanf(boota_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootAmmo]);
          
        VehicleInfo[ V_IDX - 1 ][vLocked] = false;  
        if (type == 1) {
            VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
                VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], 
                VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
                VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], RESPAWN_CAR_TIME, 0
            );
        } 
        else if (type == 2) { 
            VehicleInfo[ V_IDX - 1 ][vPos][0] = HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][0];
            VehicleInfo[ V_IDX - 1 ][vPos][1] = HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][1];
            VehicleInfo[ V_IDX - 1 ][vPos][2] = HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][2];
            VehicleInfo[ V_IDX - 1 ][vPos][3] = HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][3];
            VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
                HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][0],
                HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][1],
                HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][2],
                HouseInfo[ FamilyInfo[ family_id - 1 ][fDefHouse] ][hCar][3],
                VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
            ); 
        } 
        _SetVehicleHealth(VehicleInfo[ V_IDX - 1 ][vVehicle], vehicleCountArmour[ VehicleInfo[ V_IDX - 1 ][vPT_Engine][1] ]);


        LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
        SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]);
        SetVehicleNumberPlate(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vNumber]); 

        Iter_Add(FamilyListVehicle[family_id], V_IDX);
        printf("LOAD VEH FAMILY: ID: %d vRank: %d vModel %d", V_IDX, VehicleInfo[ V_IDX - 1 ][vRank], VehicleInfo[ V_IDX - 1 ][vModel]);
        
    }
    printf("[Загрузка ...] Данные из s_vehicle_family получены! (%d шт.) Время: %d", rows, GetTickCount() - time);
    return 1;
}
stock GetFamilyVehicleCount(playerid)
{
	new _veh_count = 0,
		query_[78];
	format(query_, sizeof query_,"SELECT * FROM `s_vehicle_family` WHERE `vFamily` = '%d'", pInfo[playerid][pFamily]);
	new Cache: result = mysql_query(dbHandle, query_);
	_veh_count = cache_num_rows( );
	if (cache_is_valid(result)) cache_delete(result);
	return _veh_count;
}
stock GetFamileMembersCount(playerid)
{
    new count_members = 0,
		query_[78];
    format(query_, sizeof query_, "SELECT * FROM `s_users`  WHERE `pFamily` = '%d'", pInfo[playerid][pFamily]);
    new Cache:_result = mysql_query(dbHandle, query_);
    count_members = cache_num_rows();
    if (cache_is_valid(_result)) cache_delete(_result);
    return count_members;
}
stock Float: GetFamilyRatingCount(playerid)
{
    new count_members = 0,
		query_[78];
    format(query_, sizeof query_, "SELECT pRating FROM `s_users`  WHERE `pFamily` = '%d'", pInfo[playerid][pFamily]);
    new Cache:_result = mysql_query(dbHandle, query_);
    count_members = cache_num_rows();
    new 
        Float: p_Rating,
        Float: p_CountRating = 0.00;
    for (new i = 0; i < count_members; i++)
    {
        cache_get_value_name_float(i, "pRating", p_Rating);
        p_CountRating += p_Rating;
    }
    if (cache_is_valid(_result)) cache_delete(_result);
    return p_CountRating;
}
stock GiveFamilyRepute(family, point) {
	FamilyInfo[family][fRepute] += point;
	if (FamilyInfo[family][fRepute] < 0) FamilyInfo[family][fRepute] = 0;
    new
        query_[128];
    format(query_, sizeof query_, "UPDATE "TABLE_FAMILY" SET `fRepute` = '%d' WHERE `fID` = '%d' LIMIT 1", FamilyInfo[ family - 1 ][fRepute], family);
    mysql_tquery(dbHandle, query_, "", ""); 
}  

Family_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;
    new bool:isReturn = false;
    if (newkeys & KEY_WALK && !(oldkeys & KEY_WALK)) { 

        if (pTemp[playerid][tSelectFamilyHouseArea]) {
            new 
                H_IDX = pTemp[playerid][tSelectFamilyHouse],
                idx = FamilyHouse[H_IDX][fhIntID];  
            if (IsPlayerInRangeOfPoint(playerid, 3.0, FamilyHouse[H_IDX][fhEnter][0], FamilyHouse[H_IDX][fhEnter][1], FamilyHouse[H_IDX][fhEnter][2]) && GetPlayerVirtualWorld(playerid) == 0)
            {
                if (GetString(FamilyHouse[ H_IDX ][fhOwner], "None")) {   
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_19, DIALOG_STYLE_LIST, ""colserver"Семейный дом: "colwhi"Cвободен", "[0] Посмотреть\n[1] Купить", "Выбрать", "Закрыть"); 
                }
                else {
                    //new family_id = pInfo[playerid][pFamily];
                    /*if ((FractionInfo[FRACTION_GROVE][fHouseLock] == 0) || (pInfo[playerid][pMember] == FRACTION_GROVE || pInfo[playerid][pAdmin]))
                    { 
                        SetPlayerPosAC(playerid, 2496.1580, -1694.5743, 1014.7422, 1, 3);
                        SetPlayerFacingAngle(playerid, 177.8856); 
                    }
                    else return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет ключа!");*/


                    /*if ((FamilyHouse[ H_IDX ][fhLock] == 1) || (family_id != 0 && !GetString(FamilyHouse[ H_IDX ][fhOwner], FamilyInfo[ family_id -1 ][fName]))) {
                        GameTextForPlayer(playerid, (FamilyHouse[ H_IDX ][fhLock] == 1)?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~FAMILY HOUSE ~r~LOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~FAMILY HOUSE ~g~UNLOCK"), 3000, 3);  
                    }
                    else {*/
                        SetPlayerPosAC(playerid, FamilyInterior[idx][fExit][0], FamilyInterior[idx][fExit][1], FamilyInterior[idx][fExit][2], (FamilyHouse[H_IDX][fhID]+50), FamilyInterior[idx][fInterior]);
                        SetPlayerFacingAngle(playerid, FamilyInterior[idx][fExit][3]);
                        pTemp[playerid][tVirtualWorld] = (FamilyHouse[H_IDX][fhID]+50);
                        pTemp[playerid][tInterior] = FamilyInterior[idx][fInterior];
                        pTemp[playerid][tSelectFamilyHouse] = H_IDX;  
                    //}
                }
                isReturn = true;
            }   
        }
        if (pTemp[playerid][tSelectFamilyHouse] != -1) {
            new 
                H_IDX = pTemp[playerid][tSelectFamilyHouse],
                idx = FamilyHouse[H_IDX][fhIntID]; 
            if (IsPlayerInRangeOfPoint(playerid, 1.0, FamilyInterior[idx][fExit][0], FamilyInterior[idx][fExit][1], FamilyInterior[idx][fExit][2]) 
                && GetPlayerVirtualWorld(playerid) == (FamilyHouse[H_IDX][fhID]+50))
            { 
                SetPlayerPosAC(playerid, FamilyHouse[H_IDX][fhEnter][0], FamilyHouse[H_IDX][fhEnter][1], FamilyHouse[H_IDX][fhEnter][2], 0, INTERIOR_NONE);
                SetPlayerFacingAngle(playerid, FamilyHouse[H_IDX][fhEnter][3]);
                pTemp[playerid][tVirtualWorld] = 0;
                pTemp[playerid][tInterior] = INTERIOR_NONE;
                pTemp[playerid][tSelectFamilyHouse] = -1;
                isReturn = true;
            }
            if (IsPlayerInRangeOfPoint(playerid, 1.0, FamilyInterior[idx][fButler][0], FamilyInterior[idx][fButler][1], FamilyInterior[idx][fButler][2]) 
                && GetPlayerVirtualWorld(playerid) == (FamilyHouse[H_IDX][fhID]+50) && FamilyHouse[H_IDX][fhUpdate][1])
            { 
                if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье!");
                if (!GetString(FamilyHouse[ H_IDX ][fhOwner], FamilyInfo[ pInfo[playerid][pFamily] -1 ][fName])) return SendClientMessage(playerid, COLOR_GREY, !"[Дворецкий] Вы не член нашей семьи, покиньте наш дом!");
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_30, DIALOG_STYLE_LIST, ""colserver"Дворецкий: "colwhi"Семьи", "[0] Список сообщений\n[1] Оставить сообщение", "Выбрать", "Закрыть");
                isReturn = true;
            }  
            if (IsPlayerInRangeOfPoint(playerid, 1.0, FamilyInterior[idx][fClothes][0], FamilyInterior[idx][fClothes][1], FamilyInterior[idx][fClothes][2]) 
                && GetPlayerVirtualWorld(playerid) == (FamilyHouse[H_IDX][fhID]+50) && FamilyHouse[H_IDX][fhUpdate][0])
            { 
                if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье!");
                if (!GetString(FamilyHouse[ H_IDX ][fhOwner], FamilyInfo[ pInfo[playerid][pFamily] -1 ][fName])) return SendClientMessage(playerid, COLOR_GREY, !"Дом, принадлежит другой семье!");
                new str_[64];
                t_string[0] = EOS;
                for(new j = 0; j < 6 ; j ++) {
                    if (pInfo[playerid][pChar][j] == 0) {
                        format(str_, sizeof str_, ""colwhi"[%d] Пусто\n", j);
                        strcat(t_string, str_);
                    }
                    else {
                        if (j == 0) {
                            format(str_, sizeof str_, ""colwhi"[%d] Одежда: %d "collime"[Текущий]\n", j, pInfo[playerid][pChar][j]); 
                        }
                        else {
                            format(str_, sizeof str_, ""colwhi"[%d] Одежда: %d\n", j, pInfo[playerid][pChar][j]); 
                        } 
                        strcat(t_string, str_);
                    }
                }
                if (pInfo[playerid][pMember] != 0 && !IsAGang(playerid) && !IsAMafia(playerid) && !IsABiker(playerid)) {
                    strcat(t_string, "[-] Одежда организации");
                } 
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_29, DIALOG_STYLE_LIST, ""colserver"Гардероб: "colwhi"Семьи", t_string, "Выбрать", "Закрыть" );
                isReturn = true;
            }
            if (IsPlayerInRangeOfPoint(playerid, 1.0, FamilyInterior[idx][fWareHouse][0], FamilyInterior[idx][fWareHouse][1], FamilyInterior[idx][fWareHouse][2]) 
                && GetPlayerVirtualWorld(playerid) == (FamilyHouse[H_IDX][fhID]+50) && FamilyHouse[H_IDX][fhUpdate][2])
            { 
                if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье!");
                if (!GetString(FamilyHouse[ H_IDX ][fhOwner], FamilyInfo[ pInfo[playerid][pFamily] -1 ][fName])) return SendClientMessage(playerid, COLOR_GREY, !"Дом, принадлежит другой семье!");
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
                isReturn = true;
            }   
        }
        isReturn = false;   
        
    }  
    return isReturn;
}
 
Family_OnPlayerPickUpPickup(playerid, pickupid) { 
	new bool:isReturn = false;  
    if (pickupid == FamilyCenter[0]) {  
        SetPlayerPosAC(playerid, 
            2038.5978,2178.4885,1312.7385,
            .worldid = 1, .interiorid = FAMILY_CENTER_INT
        );
        SetPlayerFacingAngle(playerid, 0.1927);

        SetCameraBehindPlayer(playerid);
        isReturn = true; 
    }
    else if (pickupid == FamilyCenter[1]) {  
        SetPlayerPosAC(playerid, 
            -1885.4215,827.3670,35.1749,
            .worldid = 0, .interiorid = 0
        );
        SetPlayerFacingAngle(playerid, 45.3129);

        SetCameraBehindPlayer(playerid);
        isReturn = true; 
    } 
	if (isReturn) return true;
	return false;
}
Family_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) { 
	switch (dialogid) {
		case D_FAMILY_FUNC_19: {
			if (!response) { 
				return true;
			}
            switch(listitem) {
                case 0:
                {
                    new 
                        H_IDX = pTemp[playerid][tSelectFamilyHouse],
                        idx = FamilyHouse[H_IDX][fhIntID]; 
                    SetPlayerPosAC(playerid, FamilyInterior[idx][fExit][0], FamilyInterior[idx][fExit][1], FamilyInterior[idx][fExit][2], (FamilyHouse[H_IDX][fhID]+50), FamilyInterior[idx][fInterior]);
                    SetPlayerFacingAngle(playerid, FamilyInterior[idx][fExit][3]);
                    pTemp[playerid][tVirtualWorld] = (FamilyHouse[H_IDX][fhID]+50);
                    pTemp[playerid][tInterior] = FamilyInterior[idx][fInterior];
                }
                case 1: {
                    new family_id = pInfo[playerid][pFamily] - 1,
                        H_IDX = pTemp[playerid][tSelectFamilyHouse];
                    if (FamilyInfo[family_id][fHouse] != -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вашей семьи уже есть дом!");
                    if (!GetString(FamilyInfo[family_id][fOwner], pInfo[playerid][pName])) return SendClientMessage(playerid, COLOR_GREY, "Дом может купить только Владелец семьи!");
                    format(t_string, sizeof t_string, 
                        "\n"colwhi"Вы действительно желаете купить дом для семьи {%s}%s"colwhi"?\n\n\
                        Цена: {ffd700}%d Family Coins\n\
                        "colwhi"Арендная плата: "collime"$1000 "colwhi"в час\n\n", 
                        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fName],
                        FamilyHouse[H_IDX][fhCost]
                    );
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_20, DIALOG_STYLE_MSGBOX, ""colserver"Покупка: "colwhi"Семейного дома", t_string, "Купить", "Отмена"), t_string[0] = EOS;
                }
            } 
			return 1; 
		}
        case D_FAMILY_FUNC_20: {
            if (!response) {
                return 1;
            }
            new family_id = pInfo[playerid][pFamily] - 1,
                H_IDX = pTemp[playerid][tSelectFamilyHouse];
            if (FamilyInfo[family_id][fCoins] < FamilyHouse[H_IDX][fhCost]) return SendClientMessage(playerid, COLOR_GREY, !"На счету семьи недостаточно Family Coins!");
            FamilyInfo[family_id][fCoins] -= FamilyHouse[H_IDX][fhCost];
            FamilyInfo[family_id][fHouse] = H_IDX;
            FamilyHouse[H_IDX][fhLandTax] = (GetFamilyHouseRent*24);
            strmid(FamilyHouse[H_IDX][fhOwner], FamilyInfo[family_id][fName], 0, strlen(FamilyInfo[family_id][fName]), 32); 
            format(t_string, sizeof t_string, "hLandTax = '%d', hOwner = '%s'", FamilyHouse[H_IDX][fhLandTax], FamilyHouse[H_IDX][fhOwner]);
            SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS;

            format(t_string, sizeof t_string, "fCoins = %d, fHouse = %d", FamilyInfo[family_id][fCoins], FamilyInfo[family_id][fHouse]);
            SaveFamily(playerid, t_string), t_string[0] = EOS;
            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Поздравляем Вас с покупкой семейного дома!");
            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Контралируйте репутацию своей семьи, чтоб Вас не выселили");
            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Не забывайте продливать аренду дома!");
            format(t_string, sizeof t_string,"{%s}[%s]"colwhi" %s %s: Купил семейный дом №%d",
                family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                FamilyInfo[ family_id ][fName],
                fFamilyRank[ family_id ][ pInfo[playerid][pFamilyRank] - 1 ],
                pInfo[playerid][pName], FamilyHouse[H_IDX][fhID]);
                
            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, t_string), t_string[0] = EOS;
            UpdateFamilyHouse(H_IDX);
            HideMenuFamilyHouse(playerid);
            ShowMenuFamilyHouse(playerid, H_IDX); 
            return 1;
        }
        case D_FAMILY_FUNC_21: {
            if (!response) {
                ShowFamilyPanel(playerid);
                return 1; 
            }
            new 
                family_id = pInfo[playerid][pFamily] - 1,
                H_IDX = FamilyInfo[ family_id ][fHouse];
            switch(listitem) {//1 закрыто / 0 Открыто
                case 0: {
                    t_string[0] = EOS;
                    new str_[128];
                    format(str_, sizeof str_, ""colwhi"Семья:\t\t\t{7CFC00}%s\n", FamilyHouse[H_IDX][fhOwner]);
                    strcat(t_string, str_); 
                    format(str_, sizeof str_, ""colwhi"Район:\t\t\t%s\n", GetPlayerZone(H_IDX, 1));
                    strcat(t_string, str_); 
                    format(str_, sizeof str_, "Номер дома:\t\t%d\n",FamilyHouse[H_IDX][fhID]);
                    strcat(t_string, str_); 
                    new improve[128]; 
					if (FamilyHouse[H_IDX][fhUpdate][0]) strcat(improve,"\n\t - "collime"Гардероб"colwhi"\n");
					if (FamilyHouse[H_IDX][fhUpdate][1]) strcat(improve,"\t - "collime"Дворецкий"colwhi"\n");
					if (FamilyHouse[H_IDX][fhUpdate][2]) strcat(improve,"\t - "collime"Склад"colwhi"\n");
					if (FamilyHouse[H_IDX][fhUpdate][0] == 0 && FamilyHouse[H_IDX][fhUpdate][1] == 0 && FamilyHouse[H_IDX][fhUpdate][2] == 0) strcat(improve,""colwarn"Отсутствуют");
                    format(str_, sizeof str_, "Улучшения:\t\t\t%s\n", improve);
                    strcat(t_string, str_);  
                    format(str_, sizeof str_, ""colwhi"Оплачен на:\t\t%d %s\n", (FamilyHouse[H_IDX][fhLandTax]/GetFamilyHouseRent), Declension_ReturnWord((FamilyHouse[H_IDX][fhLandTax]/GetFamilyHouseRent), "час", "часа", "часов"));
                    strcat(t_string, str_);  
                    format(str_, sizeof str_, ""colwhi"Двери:\t\t\t%s\n\n",FamilyHouse[H_IDX][fhLock] ? (""colwarn"Закрыты") : (""collime"Открыты"));
                    strcat(t_string, str_); 
                    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Семейный особняк: "colwhi"Информация", t_string, "Закрыть", "");
                }
                case 1: {
                    if (pInfo[playerid][PlayerSpawn] == 5) return SendMes(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш текущий спавн %s!", GetPlayerSpawnName(playerid));
					if (pInfo[playerid][pFamily] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
					if (FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fHouse] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вашей семьи нет особняка!");
                    pInfo[playerid][PlayerSpawn] = 5;
					SendClientMessage(playerid, COLOR_GREEN, !"[Информация] "colwhi"Теперь вы будете возраждаться в Семейной особняке!");
                }
                case 2: { 
                    SetPlayerCheckpoint(playerid, FamilyHouse[H_IDX][fhEnter][0], FamilyHouse[H_IDX][fhEnter][1], FamilyHouse[H_IDX][fhEnter][2], 4.0);
		            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш особняк обозначен на карте красной меткой");
		            SetPVarInt(playerid, #CheckpointHome, 1); 
                }
                case 3: {  
                    if (FamilyHouse[ H_IDX ][fhLock] == 1) FamilyHouse[ H_IDX ][fhLock] = 0;  
                    else FamilyHouse[ H_IDX ][fhLock] = 1;  
                    GameTextForPlayer(playerid, (!FamilyHouse[ H_IDX ][fhLock])?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~HOUSE ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~HOUSE ~r~LOCK"), 3000, 3);
                    format(t_string, sizeof t_string,"{%s}[%s]"colwhi" %s %s: %s дверь семейного особняка",
                        family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                        FamilyInfo[ family_id ][fName],
                        fFamilyRank[ family_id ][ pInfo[playerid][pFamilyRank] - 1 ],
                        pInfo[playerid][pName], (!FamilyHouse[ H_IDX ][fhLock])?("Открыл"):("Закрыл"));
                        
                    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, t_string);

                    format(t_string, sizeof t_string, "hLock = '%d'", FamilyHouse[ H_IDX ][fhLock]);
                    SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS; 
                    PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                    UpdateFamilyHouse(H_IDX);
                }
                case 4: {  
					for(new i, color_[10]; i < 3; i++) { 
						if (FamilyHouse[H_IDX][fhUpdate][i]) color_ = ""collime"";
						else if (!i || FamilyHouse[H_IDX][fhUpdate][i-1]) color_ = ""colwhi"";
						else color_ = ""colwarn"";
						if (!i) format(t_string, sizeof t_string, "%s[%d] %s",color_, i+1, fHouseImproveName[i]); 
						else format(t_string, sizeof t_string, "%s\n%s[%d] %s",t_string, color_, i+1, fHouseImproveName[i]);  
					}
					return ShowPlayerDialog(playerid, D_FAMILY_FUNC_22, DIALOG_STYLE_LIST,""colserver"Семейный особняк: "colwhi"Улучшения", t_string, "Купить", "Отмена"), t_string[0] = EOS;
                }
            }
            return 1;
        }
		case D_FAMILY_FUNC_22: {
			if (!response) return 1;
            new 
                H_IDX = FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fHouse]; 
			if (FamilyHouse[H_IDX][fhUpdate][listitem]) { 
                if (listitem == 2) {
                    if (FamilyHouse[H_IDX][fhStoreLevel] == 4) return SendClientMessage(playerid, COLOR_GREY, !"Ваш склад максимального уровня!");
                    if (kLibGetPlayerMoney(playerid) < fHouseImproveCost[2]) {
                        SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег!");
                        return 1;
                    }
                    kLibGivePlayerMoney(playerid, -fHouseImproveCost[2], "level up fHouse");
                    FamilyHouse[H_IDX][fhStoreLevel] ++;
                    format(t_string, sizeof t_string, "Вы повылили уровень Вашего склада до %d/4", FamilyHouse[H_IDX][fhStoreLevel]);
                    SendClientMessage(playerid, COLOR_LIME, t_string);
                    UpdateFamilyStore(H_IDX, false); 
                    format(t_string, sizeof t_string, "hStoreLevel = '%d'", FamilyHouse[H_IDX][fhStoreLevel]);
                    SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS; 
                } 
                else SendClientMessage(playerid, COLOR_GREY, !"У Вас уже установлено данное улучшение"); 
                return 1;
			}
			else if ((!listitem && !FamilyHouse[H_IDX][fhUpdate][listitem]) || (FamilyHouse[H_IDX][fhUpdate][listitem-1] && !FamilyHouse[H_IDX][fhUpdate][listitem])) {	
				new 
                    string_[128]; 
                format(string_, sizeof string_,""colwhi"Улучшение: "collime"%s\n"colwhi"Стоимость "collime"$%d", fHouseImproveName[listitem], fHouseImproveCost[listitem]); 
				SetPVarInt(playerid,"improveid_price", fHouseImproveCost[listitem]);
				ShowPlayerDialog(playerid, D_FAMILY_FUNC_23, DIALOG_STYLE_MSGBOX, ""colserver"Семейный дом: "colwhi"Покупка улучшений", string_,"Купить","Отмена");
				SetPVarInt(playerid,"improveid", listitem);
			}
			else SendClientMessage(playerid, COLOR_GREY, !"Это улучшение Вам недоступно. Откройте улучшения выше");  
            return 1;
		}
        case D_FAMILY_FUNC_23: {
			new improveid = GetPVarInt(playerid,"improveid");
			DeletePVar(playerid,"improveid");
			if (!response) return 1; 
			if (kLibGetPlayerMoney(playerid) < fHouseImproveCost[improveid]) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег!");
                return 1;
			}
			new 
                H_IDX = FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fHouse]; 
			FamilyHouse[H_IDX][fhUpdate][improveid] = 1; 
			if (improveid == 0) {
                CreateFamilyUpdate(H_IDX, false, 0); 
            }
            else if (improveid == 1) {
                CreateFamilyUpdate(H_IDX, false, 1); 
            }
            else if (improveid == 2) {
                CreateFamilyUpdate(H_IDX, false, 2);  
            } 
			new 
                str_[32];
			for(new i; i < 5; i++) {
				if (!i) format(str_, sizeof str_, "%d", FamilyHouse[ H_IDX ][fhUpdate][i]);
				else format(str_, sizeof str_, "%s|%d", str_, FamilyHouse[ H_IDX] [fhUpdate][i]);
			}
            format(t_string, sizeof t_string, "hUpdate = '%s'", str_);
            SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS; 


                    

			kLibGivePlayerMoney(playerid, -fHouseImproveCost[improveid], "buy up fHouse");
			SendClientMessage(playerid, COLOR_GREEN, !"Поздравляем с приобретением улучшения в дом");
			return 1;
		} 
        case D_FAMILY_FUNC_24:
		{
			if (!response) return 1; 
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, D_FAMILY_FUNC_25, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
				case 1: ShowPlayerDialog(playerid, D_FAMILY_FUNC_26, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:","Положить","Назад");
				case 2: { 
					ShowPlayerDialog(playerid, D_FAMILY_FUNC_27, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
				}
				case 3: { 
					if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][0]) {
						new str_[128];
						format(str_, sizeof str_, "Деньги можно брать с %d ранга", FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][0]);
						SendClientMessage(playerid, COLOR_GREY, str_);
						return 1;
					}
					ShowPlayerDialog(playerid, D_FAMILY_FUNC_28, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете взять:","Взять","Назад");
				}
			}
			return 1;
		}
        case D_FAMILY_FUNC_25:
		{
			if (!response) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
			new d_amount = strval(inputtext),
				H_IDX = FamilyInfo[ pInfo[playerid][pFamily] - 1][fHouse],
				str_[64]; 
			if (d_amount < 1 || d_amount > 500) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_25, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
			if (pInfo[playerid][pMats] < d_amount) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько материалов!");
				return ShowPlayerDialog(playerid, D_FAMILY_FUNC_25, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
			} 
			if (FamilyHouse[H_IDX][fhStore][0] + d_amount > StoreMaterialsLimit[FamilyHouse[H_IDX][fhStoreLevel]]) {
				SendClientMessage(playerid, COLOR_GREY, !"Склад Вашей семьи полный!");
				return ShowPlayerDialog(playerid, D_FAMILY_FUNC_25, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
			}
			FamilyHouse[H_IDX][fhStore][0] += d_amount;
			pInfo[playerid][pMats] -= d_amount; 
			format(str_, sizeof str_, "Вы положили на склад "colserver"%d материалов", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
			UpdateFamilyStore(H_IDX);
			return 1;
		}
        case D_FAMILY_FUNC_26:
		{
			if (!response) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
			new d_amount = strval(inputtext),
				H_IDX = FamilyInfo[ pInfo[playerid][pFamily] - 1][fHouse],
				str_[64];
			if (d_amount < 1 || d_amount > 5000000) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_26, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:","Положить","Назад");
			if (kLibGetPlayerMoney(playerid) < d_amount) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег!");
				return ShowPlayerDialog(playerid, D_FAMILY_FUNC_26, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:","Положить","Назад");
			}
            if (FamilyHouse[H_IDX][fhStore][1] + d_amount > StoreCashLimit[FamilyHouse[H_IDX][fhStoreLevel]]) {
				SendClientMessage(playerid, COLOR_GREY, !"Склад Вашей семьи полный!");
				return ShowPlayerDialog(playerid, D_FAMILY_FUNC_26, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:","Положить","Назад");
			}
			FamilyHouse[H_IDX][fhStore][1] += d_amount;
			kLibGivePlayerMoney(playerid, -d_amount, "положил на склад"); 
			format(str_, sizeof str_, "Вы положили на склад "collime"$%d", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
			UpdateFamilyStore(H_IDX);
			return 1;
		}
        case D_FAMILY_FUNC_27:
		{
			if (!response) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
			new d_amount = strval(inputtext),
				H_IDX = FamilyInfo[ pInfo[playerid][pFamily] - 1][fHouse],
				str_[64];
				
			if (d_amount < 1 || d_amount > 500 ) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_27, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
			if (FamilyHouse[H_IDX][fhStore][0] < d_amount ) {
			    SendClientMessage(playerid, COLOR_GREY, !"На складе нет столько материалов!");
			    return ShowPlayerDialog(playerid, D_FAMILY_FUNC_27, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
			}
			if (pInfo[playerid][pMats] + d_amount > GetVIPLimitMaterials(playerid)) {
			    SendMes(playerid, COLOR_GREY, "Нельзя при себе иметь более %d материалов!", GetVIPLimitMaterials(playerid));
			    return ShowPlayerDialog(playerid, D_FAMILY_FUNC_27, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
			}
			FamilyHouse[H_IDX][fhStore][0] -= d_amount;
			pInfo[playerid][pMats] += d_amount ; 
			format(str_, sizeof str_, "Вы взяли со склада "colserver"%d материалов", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			
			format(str_, sizeof str_, "%s взял со склада %d материалов", pInfo[playerid][pName], d_amount);
            ///SendFamilyMessage(pInfo[playerid][pMember], 0x6BB3FFAA, str_);
            SendBeside(playerid, COLOR_PURPLE, str_, 10.0);
			ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
            UpdateFamilyStore(H_IDX);
            return 1;
		}
		case D_FAMILY_FUNC_28:
		{
			if (!response) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
			new d_amount = strval(inputtext),
                H_IDX = FamilyInfo[ pInfo[playerid][pFamily] - 1][fHouse],
				str_[64];

			if (d_amount < 1 || d_amount > 10000000) return ShowPlayerDialog(playerid, D_FAMILY_FUNC_28, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете взять:","Взять","Назад");
			if (FamilyHouse[H_IDX][fhStore][1] < d_amount) {
			    SendClientMessage(playerid, COLOR_GREY, !"На складе нет столько денег!");
			    return ShowPlayerDialog(playerid, D_FAMILY_FUNC_28, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете взять:","Взять","Назад");
			} 
			FamilyHouse[H_IDX][fhStore][1] -= d_amount; 
			kLibGivePlayerMoney(playerid, d_amount, "взял со склада"); 

			format(str_, sizeof str_, "Вы взяли со склада "collime"$%d", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_); 
            /*FAMILY CHAT */
			ShowPlayerDialog(playerid, D_FAMILY_FUNC_24, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Семьи", "[0] Положить материалы\n[1] Положить деньги\n[2] Взять материалы\n[3] Взять деньги", "Выбрать", "Закрыть");
            UpdateFamilyStore(H_IDX);
            return 1;
		}
        case D_FAMILY_FUNC_29:
		{
			if (!response) return 1;
			if (listitem == 6)
			{
                if (pInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в организации!");
				if (pTemp[playerid][tDutyWork] == 0)
				{
					SendClientMessage(playerid, 0x6BB3FFAA, !"Рабочий день начат");
					pTemp[playerid][tDutyWork] = 1;
					SetWeaponFraction(playerid);
					SetPlayerColor(playerid, gFractionColor[pInfo[playerid][pMember]]);
					SetPlayerSkinEx(playerid, pInfo[playerid][pModel]);
				}
				else
				{
				    SendClientMessage(playerid, 0x6BB3FFAA, !"Рабочий день окончен");
		   			SetPlayerColor(playerid, TEAM_HIT_COLOR);
					pTemp[playerid][tDutyWork] = 0;
					SetPlayerArmour(playerid, 0);
					ResetPlayerWeapons(playerid);
					SetPlayerSkinEx(playerid, pInfo[playerid][pChar][0]);
				}
				return 1;
			}
			if (pInfo[playerid][pChar][listitem] == 0) {
				return SendClientMessage(playerid, COLOR_GREY, !"На данной полке у Вас нет одежды");
			}
            if (pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Вы сначало должны завершить рабочий день!");
            if (listitem == 0) {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Данный скин уже надет на Вас");
                return 1;
            }
            new skin = pInfo[playerid][pChar][0];
            pInfo[playerid][pChar][0] = pInfo[playerid][pChar][listitem]; 
            SetPlayerSkinEx(playerid, pInfo[playerid][pChar][0]);
            pInfo[playerid][pChar][listitem] = skin;
            save_player_skins(playerid);  
            return 1;
		}
        case D_FAMILY_FUNC_30: {
            if (!response) {
                return 1;
            }
            switch(listitem) {
                case 0: {
                    format(t_string, sizeof (t_string), "SELECT * FROM `s_family_message` WHERE `pFamily` = '%d' ORDER BY `Date` DESC LIMIT 0, 10", 
                        pInfo[playerid][pFamily]
                    );
                    new rows, Cache:tempQuery = mysql_query(dbHandle, t_string);
                    cache_get_row_count(rows); 
                    if (!rows) {
                        SendClientMessage(playerid, COLOR_GREY, !"Еще нет новых сообщений!");
                        if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
                        return true;
                    }
                    t_string[0] = EOS;
                    strcat(t_string, ""colwhi"");
                    new string_[164];
                    for(new i = 0, date_[32], name_[MAX_PLAYER_NAME], message_[128]; i < rows ; i++)
                    { 
                        cache_get_value(i, "Date", date_, sizeof date_); 
                        cache_get_value(i, "Message", message_, sizeof message_); 
                        cache_get_value(i, "Player", name_, sizeof name_);

                        
                        format(string_, sizeof string_, "\t"colwhi"Дата [%s] | Автор: %s\n", date_, name_ );
                        strcat(t_string, string_);  
                        format(string_, sizeof string_, "Сообщение: "collime"%s\n", message_ );
                        strcat(t_string, string_); 
                    }
                    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, !""colserver"Сообщения: "colwhi"от участников", t_string, !"Закрыть", ""), t_string[0] = EOS;
                    if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
                    return true;
                }
                case 1: { 
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_31, DIALOG_STYLE_INPUT, ""colserver"Оставить сообщение: "colwhi"Для семьи",
                        ""colwhi"Введите желаемое сообщение для своей семьи:\n\nДлина сообщения не более 128 символов", "Отправить", "Закрыть"
                    );
                }
            }
        }
        case D_FAMILY_FUNC_31:
		{
		    if (!response) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_30, DIALOG_STYLE_LIST, ""colserver"Дворецкий: "colwhi"Семьи", "[0] Список сообщений\n[1] Оставить сообщение", "Выбрать", "Закрыть");
                return 1;
            }
			if (!strlen(inputtext) || strlen(inputtext) > 128)
			{
				SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Введите текст сообщения");
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_31, DIALOG_STYLE_INPUT, ""colserver"Оставить сообщение: "colwhi"Для семьи",
                    ""colwhi"Введите желаемое сообщение для своей семьи:\n\nДлина сообщения не более 128 символов", "Отправить", "Закрыть"
                );
				return 1;
			} 
            format(t_string, sizeof t_string, "INSERT INTO `s_family_message` (`Player`, `Message`, `pFamily`, `Date`) VALUES ( '%s', '%s', '%d', NOW())",
                pInfo[playerid][pName], inputtext, pInfo[playerid][pFamily]);
            mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
            SendClientMessage(playerid, COLOR_LIME, !"Вы успешно установили сообщение для своей семьи!"); 
			return 1;
		}
        case D_FAMILY_FUNC_32: {
            if (!response) return 1;
            switch(listitem) {
                case 0: { 
                    if (pInfo[playerid][pFamily] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье"); 
                    new get_donate = 7000;
                    format(t_string, sizeof t_string,""colwhi"Введите сколько Family Coins вы хотите приобрести для своей семьи\nЦена: "collime"1 Family Coins стоит $%d", get_donate);
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_34, DIALOG_STYLE_INPUT, ""colserver"Семейный центр: "colwhi"Покупка Family Coins", t_string, "Далее", "Отмена"), t_string[0] = EOS;
                }
                case 1: {
                    if (pInfo[playerid][pFamily] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье"); 
                    new family_id = pInfo[playerid][pFamily] - 1;
                    if (!GetString(FamilyInfo[family_id][fOwner], pInfo[playerid][pName])) return SendClientMessage(playerid, COLOR_GREY, !"Сменить название семьи может только создатель!");
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_33, DIALOG_STYLE_INPUT, ""colserver"Семейный центр: "colwhi"Переименование семьи", 
                        "\n"colwhi"Введите новое название своей семьи:\n\nСтоимость смены названия семьи составляет "colwhi"$5.000.000\n", "Принять", "Назад" ) ;
                }
                case 2: {
                    ShowFamilyList(playerid);
                }
            }
            return 1;
        }
        /*case D_FAMILY_FUNC_40: {
            if (kLibGetPlayerMoney(playerid) < 10_000_000) return SendClientMessage(playerid, COLOR_GREY, !"Вам надо иметь $10.000.000, для Создания Семьи");
            ShowPlayerDialog(playerid, D_FAMILY_FUNC_41, DIALOG_STYLE_INPUT, ""colwhi"Создание семьи", 
                ""colwhi"Стоимость регистрации семьи составляет "collime"$10.000.000\n"colwhi"Название семьи не может быть менее 4 символов или превышать 32 символа\n\nВведите название своей семьи:", 
                "Создать", "Назад"
            );
            return 1;
        }*/
        case D_FAMILY_FUNC_41:
		{
	        if (!response) {
                SendClientMessage(playerid, COLOR_GREY, !"Вы отказались создавать семью");
                return 1;
            } 
			if (pInfo[playerid][pFamily] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже состоите в семье");
			if (strlen(inputtext) < 4 || strlen(inputtext) > 32) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_41, DIALOG_STYLE_INPUT, ""colwhi"Создание семьи", 
                    ""colwhi"Стоимость регистрации семьи составляет "collime"$10.000.000\n"colwhi"Название семьи не может быть менее 4 символов или превышать 32 символа\n\nВведите название своей семьи:", 
                    "Создать", "Назад"
                );
                return 1;
			}
			if (is_text_invalid(inputtext)) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_41, DIALOG_STYLE_INPUT, ""colwhi"Создание семьи", 
                    ""colwhi"Стоимость регистрации семьи составляет "collime"$10.000.000\n"colwhi"Название семьи не может быть менее 4 символов или превышать 32 символа\n\nВведите название своей семьи:", 
                    "Создать", "Назад"
                );
                return 1;
			} else  {
               	//pInfo[playerid][pDonate] -= 300;
				//SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
                if (kLibGetPlayerMoney(playerid) < 10_000_000) return SendClientMessage(playerid, COLOR_GREY, !"Вам надо иметь на руках $10.000.000, для Создания Семьи");
                kLibGivePlayerMoney(playerid, -10000000, "создал семью");

				new query[164],
					query_[80];
				mysql_format(dbHandle, query, sizeof query, "INSERT INTO `s_family` (`fName`,`fOwner`,`fDate`) VALUES ( '%e', '%s', NOW())", inputtext, pInfo[playerid][pName]);
                mysql_tquery(dbHandle, query );
                pInfo[playerid][pFamily] = S_FAMILY_COUNT + 1;
                pInfo[playerid][pFamilyRank] = 3;
                format(query_, sizeof query_, "UPDATE `s_users` SET pFamily='%d',pFamilyRank='3' WHERE `pID` = '%d'", pInfo[playerid][pFamily], pInfo[playerid][pID]);
				mysql_tquery(dbHandle, query_, "", "");
                format(FamilyInfo[S_FAMILY_COUNT][fName], 32, inputtext);
                format(FamilyInfo[S_FAMILY_COUNT][fOwner], 24, pInfo[playerid][pName]);
                FamilyInfo[S_FAMILY_COUNT][fChatColor] = 0;
                FamilyInfo[S_FAMILY_COUNT][fPrefix] = 0;
                FamilyInfo[S_FAMILY_COUNT][fType] = 0;
				FamilyInfo[S_FAMILY_COUNT][fHouse] = -1;
                FamilyInfo[S_FAMILY_COUNT][fDefHouse] = -1;
                format( fFamilyRank[S_FAMILY_COUNT][0], 30, "Участник" ) ;
                format( fFamilyRank[S_FAMILY_COUNT][1], 30, "Заместитель" ) ;
                format( fFamilyRank[S_FAMILY_COUNT][2], 30, "Основатель" ) ;

				FamilyInfo[S_FAMILY_COUNT][fSettings][0] = 3;
				FamilyInfo[S_FAMILY_COUNT][fSettings][1] = 3;
				FamilyInfo[S_FAMILY_COUNT][fSettings][2] = 3;
				FamilyInfo[S_FAMILY_COUNT][fSettings][3] = 3;
                FamilyInfo[S_FAMILY_COUNT][fSettings][4] = 3; //Open/Closed Bank
                FamilyInfo[S_FAMILY_COUNT][fSettings][5] = 3; //Open/Closed Safe
                FamilyInfo[S_FAMILY_COUNT][fBank] = 0;
                FamilyInfo[S_FAMILY_COUNT][fBankLock] = 1;
                FamilyInfo[S_FAMILY_COUNT][fSafeLock] = 1;
                FamilyInfo[S_FAMILY_COUNT][fLimitLevel] = 3;
                FamilyInfo[S_FAMILY_COUNT][fLimitRating] = 1;
                FamilyInfo[S_FAMILY_COUNT][fPromoID] = -1;
                Invite_Family(playerid, pInfo[playerid][pFamily]);
                SendMes(playerid, COLOR_WHITE, "Вы успешно создали семью "colserver"%s"colwhi". Используйте - "colserver"\"/fam\"", FamilyInfo[S_FAMILY_COUNT][fName]);
				OnPlayerAchievProgress(playerid, 31);
                S_FAMILY_COUNT ++;
				return 1 ;
            }
        }
        case D_FAMILY_FUNC_33:
		{
			if (!response) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_32, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Семейный центр", 
                    ""colserver"[№] Услуга\t"colserver"Стоимость\n[0] Купить Family Coins\t[ "collime"$7000 = 1 Family Coins"colwhi" ]\n[1] Переименовать семью\t$5.000.000\n[-] Список семей штата", "Выбрать", "Закрыть"
                ); 
                return 1;
            }
			if (kLibGetPlayerMoney(playerid) < 5_000_000){
                SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег!");
                return 1;
            }
            
			if (pInfo[playerid][pFamily] == 0) { 
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
			}
			if (strlen(inputtext) < 4 || strlen(inputtext) > 32)
            {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Название семьи может быть от 4 до 32 символов!");
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_33, DIALOG_STYLE_INPUT, ""colserver"Семейный центр: "colwhi"Переименование семьи", 
                        "\n"colwhi"Введите новое название своей семьи:\n\nСтоимость смены названия семьи составляет "colwhi"$5.000.000\n", "Принять", "Назад" ) ;
				return 1 ;
			}
			if (is_text_invalid(inputtext))
            {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_33, DIALOG_STYLE_INPUT, ""colserver"Семейный центр: "colwhi"Переименование семьи", 
                    "\n"colwhi"Введите новое название своей семьи:\n\nСтоимость смены названия семьи составляет "colwhi"$5.000.000\n", "Принять", "Назад" ) ;
				return 1;
			} else { 
				new 
                    query_[128] ;
				mysql_format(dbHandle, query_, sizeof query_, "UPDATE "TABLE_FAMILY" SET `fName`='%e' WHERE `fID`='%d'", inputtext, pInfo[playerid][pFamily]);
                mysql_tquery(dbHandle, query_);

                new 
                    family_id = pInfo[playerid][pFamily] - 1;

                kLibGivePlayerMoney(playerid, -5000000, "re name family");  
                SetMoveCashServer(OUT_SERVER, 5000000); 
                strmid(FamilyInfo[ family_id ][fName], inputtext, 0, strlen(inputtext), 32); 
                if (FamilyInfo[family_id][fHouse] != 0) {
                    new 
                        H_IDX = FamilyInfo[family_id][fHouse];
                    strmid(FamilyHouse[H_IDX][fhOwner], FamilyInfo[family_id][fName], 0, strlen(FamilyInfo[family_id][fName]), 32); 
                    format(query_, sizeof query_, "hOwner = '%s'", FamilyHouse[H_IDX][fhOwner]);
                    SaveFamilyHouse(H_IDX, query_); 
                } 
                new
                    label_[128];
                if (FamilyInfo[ family_id ][fPrefix] != 0)
                {
                    format(label_, sizeof label_, "[%s] {%s}%s "colwhi"%s",
                        family_label_prefix[ FamilyInfo[ family_id ][fPrefix] ],
                        family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                        FamilyInfo[ family_id ] [fName],
                        family_label_type[ FamilyInfo[ family_id ][fType] ]);
                }
                else
                {
                    format(label_, sizeof label_, "{%s}%s "colwhi"%s",
                        family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                        FamilyInfo[ family_id ] [fName],
                        family_label_type[ FamilyInfo[ family_id ][fType] ]);
                }
                if (FamilyInfo[family_id][fHouse] != -1) {
                    UpdateFamilyHouse(FamilyInfo[family_id][fHouse]);
                }
                foreach(new i: PlayerInLogin) /* PlayerInFamily */
                {
                    if (!pInfo[i][pLogin] || AntiCheatIsKickedWithDesync(i)) continue;
                    if (pInfo[i][pFamily] != pInfo[playerid][pFamily]) continue; 
                    if (pTemp[i][FamilyText] != Text3D:-1) {
                        UpdateDynamic3DTextLabelText(pTemp[i][FamilyText], -1, label_);
                    } 
                } 
                format(t_string, sizeof t_string,"{%s}[%s]"colwhi" %s %s: Изменил названия семьи на %s",
                    family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                    FamilyInfo[ family_id ][fName],
                    fFamilyRank[ family_id ][ pInfo[playerid][pFamilyRank] - 1 ],
                    pInfo[playerid][pName], inputtext);
                    
                SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, t_string), t_string[0] = EOS;  
			}
            return 1;
		}
        case D_FAMILY_FUNC_34:
		{
			if (!response) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_32, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Семейный центр", 
                    ""colserver"[№] Услуга\t"colserver"Стоимость\n[0] Купить Family Coins\t[ "collime"$7000 = 1 Family Coins"colwhi" ]\n[1] Переименовать семью\t$500.000\n[-] Список семей штата", "Выбрать", "Закрыть"
                ); 
                return 1;
            }
            new amount = strval(inputtext),
                get_donate = 7000; 
            if (amount < 1 || amount > 10000) {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Минимальное кол-во от 1 до 10000 Family Coins");
                format(t_string, sizeof t_string,""colwhi"Введите сколько Family Coins вы хотите приобрести для своей семьи\nЦена: "collime"1 Family Coins стоит $%d", get_donate);
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_34, DIALOG_STYLE_INPUT, ""colserver"Семейный центр: "colwhi"Покупка Family Coins", t_string, "Далее", "Отмена"), t_string[0] = EOS;
                return 1;
            }
            if (kLibGetPlayerMoney(playerid) < amount*get_donate) {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"У Вас нет столько денег");
                format(t_string, sizeof t_string,""colwhi"Введите сколько Family Coins вы хотите приобрести для своей семьи\nЦена: "collime"1 Family Coins стоит $%d", get_donate);
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_34, DIALOG_STYLE_INPUT, ""colserver"Семейный центр: "colwhi"Покупка Family Coins", t_string, "Далее", "Отмена"), t_string[0] = EOS;
                return 1;
            } 
            kLibGivePlayerMoney(playerid, -amount*get_donate, "Покупка FC"); 
            SetMoveCashServer(OUT_SERVER, amount*get_donate); 
            new 
                family_id = pInfo[playerid][pFamily] - 1; 
            FamilyInfo[family_id][fCoins] += amount;  
            if (amount > 50) {
                FamilyInfo[family_id][fRepute] += 100;
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"За покупку более 100 FC за раз, Вы получили +100 репутации для своей семьи!");
            } 
            format(t_string, sizeof t_string, "fCoins = %d, fRepute = %d", FamilyInfo[family_id][fCoins], FamilyInfo[family_id][fRepute]);
            SaveFamily(playerid, t_string); 
            format(t_string, sizeof t_string,"{%s}[%s]"colwhi" %s %s: Купил для семьи %d Family Coins",
                family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                FamilyInfo[ family_id ][fName],
                fFamilyRank[ family_id ][ pInfo[playerid][pFamilyRank] - 1 ],
                pInfo[playerid][pName], amount);
                
            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, t_string); 
            format(t_string, sizeof t_string, "Вы купили %d FC, за $%d для своей семьи!", amount, amount*get_donate);
            SendClientMessage(playerid, COLOR_LIME, t_string), t_string[0] = EOS; 
            return 1;
		}
        case D_FAMILY_FUNC_35: {
			if (!response) {
				return true;
			}
			new 
				page = pTemp[playerid][tSelectPage],
				id = playerListItem[playerid][listitem];

			switch (id) {
				case 1: ShowFamilyList(playerid, page + 1);
				case 2: ShowFamilyList(playerid, page - 1);
				default: ShowFamilyList(playerid, page);
			}
			return true;
		} 
        case D_FAMILY_FUNC_36:
		{
            if (!response) {
                ShowFamilyPanel(playerid);
                return true;
            }
            new targetid; 
            if (sscanf(inputtext, "u", targetid)) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_36, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Передать управления", 
                    "\n"colwhi"Введите ID игрока которуму хотите передать семью\n"colinfo"Внимание! "colgrey"Действие невозможно будет отменить!", 
                    "Принять", "Отмена"
                );
                return true;
            }
            if (!PlayerInConnected(targetid) || playerid == targetid) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_36, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Передать управления", 
                    "\n"colwhi"Введите ID игрока которуму хотите передать семью\n"colinfo"Внимание! "colgrey"Действие невозможно будет отменить!", 
                    "Принять", "Отмена"
                );
                return true;
            } 
            if (!IsPlayerInRangeOfPlayer(7.0, playerid, targetid) || GetPlayerVirtualWorld(targetid) != GetPlayerVirtualWorld(playerid)) {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Человек слишком далеко от вас!");
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_36, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Передать управления", 
                    "\n"colwhi"Введите ID игрока которуму хотите передать семью\n"colinfo"Внимание! "colgrey"Действие невозможно будет отменить!", 
                    "Принять", "Отмена"
                );
                return true;
            } 
            if (pInfo[targetid][pFamily] != pInfo[playerid][pFamily]) {
                SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье");
                return true;
            } 
			if (pInfo[targetid][pLevel] < 5) {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Игрок должен иметь уровень выше 5-го!");
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_36, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Передать управления", 
                    "\n"colwhi"Введите ID игрока которуму хотите передать семью\n"colinfo"Внимание! "colgrey"Действие невозможно будет отменить!", 
                    "Принять", "Отмена"
                );
                return true;
            }   
            pInfo[targetid][pFamily] = pInfo[playerid][pFamily];
            pInfo[targetid][pFamilyRank] = pInfo[playerid][pFamilyRank];
            pInfo[targetid][pFamilyMute] = 0;
            pInfo[targetid][pFamilyWarn] = 0;
            //SetString(FamilyInfo[  pInfo[playerid][pFamily] - 1  ][fOwner], pInfo[targetid][pName], 32);
            strmid(FamilyInfo[  pInfo[playerid][pFamily] - 1  ][fOwner], pInfo[targetid][pName], 0, strlen(pInfo[targetid][pName]), 32); 
            FamilyInfo[  pInfo[playerid][pFamily] - 1  ][fPromoID] = -1;
            //format(FamilyInfo[  pInfo[playerid][pFamily] - 1  ][fOwner], 24, pInfo[targetid][pName]);
            new
                string_[128],
                query_[128]; 
            mysql_format(dbHandle, query_, sizeof query_, 
                "UPDATE "TABLE_FAMILY" SET `fOwner`='%e', `fPromoID` = '-1' WHERE `fID`='%d'", 
                pInfo[targetid][pName], pInfo[targetid][pFamily]
            );
            mysql_tquery(dbHandle, query_);

            format(query_, sizeof query_, 
                "UPDATE s_users SET pFamily ='%d', pFamilyRank = '%d' WHERE `pID` = '%d'", 
                pInfo[targetid][pFamily], pInfo[targetid][pFamilyRank], pInfo[targetid][pID]);
            mysql_tquery(dbHandle, query_, "", "");

            format(string_, sizeof string_, "Поздравляем! "colwhi"Вы новый основатель семьи %s!", FamilyInfo[ pInfo[targetid][pFamily] - 1 ][fName]);
            SendClientMessage(targetid, COLOR_LI_RED, string_);
            SendClientMessage(targetid, COLOR_YELLOW, !"[Подсказка] "colwhi"Используйте: /fam - Для настройки семьи!");

            format(string_, sizeof string_,"{%s}[%s]"colwhi" %s покинул семью!",
                family_chat_color[ FamilyInfo[ pInfo[targetid][pFamily] - 1 ][fChatColor] ],
                FamilyInfo[ pInfo[targetid][pFamily] - 1 ][fName], 
                pInfo[playerid][pName]
            );

            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
            Leave_Family(playerid, pInfo[playerid][pFamily]); 
            pInfo[playerid][pFamily] = 0;
            pInfo[playerid][pFamilyRank] = 0;
            pInfo[playerid][pFamilyMute] = 0;
            pInfo[playerid][pFamilyWarn] = 0;
            if (pInfo[playerid][PlayerSpawn] == 5 || pInfo[playerid][PlayerSpawn] == 6) {
                pInfo[playerid][PlayerSpawn] = 0;
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш спавн изменен на стандартный!");
            }
            
            format(query_, sizeof query_, "UPDATE `s_users` SET pFamily='0',pFamilyRank='0' WHERE `pID` = '%d'", pInfo[playerid][pID]);
            mysql_tquery(dbHandle, query_, "", "");
			return true;
		}
        case D_FAMILY_FUNC_42: {
            if (!response) {
                ShowFamilyPanel(playerid);
                return 1; 
            }
            new 
                family_id = pInfo[playerid][pFamily] - 1,
                H_IDX = FamilyInfo[ family_id ][fDefHouse];
            switch(listitem) {//1 закрыто / 0 Открыто 
                case 0: {
                    if (pInfo[playerid][PlayerSpawn] == 6) return SendMes(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш текущий спавн %s!", GetPlayerSpawnName(playerid));
					if (pInfo[playerid][pFamily] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
					if (FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fDefHouse] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вашей семьи нет дома!");
                    pInfo[playerid][PlayerSpawn] = 6;
					SendClientMessage(playerid, COLOR_GREEN, !"[Информация] "colwhi"Теперь вы будете возраждаться в Семейной доме!");
                }
                case 1: {  
                    SetPlayerCheckpoint(playerid, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2], 4.0);
		            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш дом обозначен на карте красной меткой");
		            SetPVarInt(playerid, #CheckpointHome, 1); 
                }
                case 2: {  
                    if (HouseInfo[ H_IDX ][hLock] == 1) HouseInfo[ H_IDX ][hLock] = 0;  
                    else HouseInfo[ H_IDX ][hLock] = 1;  
                    GameTextForPlayer(playerid, (!HouseInfo[ H_IDX ][hLock])?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~HOUSE ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~HOUSE ~r~LOCK"), 3000, 3);
                    format(t_string, sizeof t_string,"{%s}[%s]"colwhi" %s %s: %s дверь семейного дома",
                        family_chat_color[ FamilyInfo[ family_id ][fChatColor] ],
                        FamilyInfo[ family_id ][fName],
                        fFamilyRank[ family_id ][ pInfo[playerid][pFamilyRank] - 1 ],
                        pInfo[playerid][pName], (!HouseInfo[ H_IDX ][hLock])?("Открыл"):("Закрыл"));
                        
                    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, t_string);
                    format(t_string, sizeof t_string, "UPDATE `house` SET `hLock`= '%d' WHERE `hID` = '%d'", HouseInfo[H_IDX][hLock], HouseInfo[H_IDX][hID]);
		            mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
                    /*format(t_string, sizeof t_string, "hLock = '%d'", FamilyHouse[ H_IDX ][hLock]);
                    SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS; */
                    PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                    //UpdateFamilyHouse(H_IDX);
                }
            }
            return 1;
        }
        case D_FAMILY_FUNC_43: {
			if(!response) {
				return 1;
			}
            new _step = 0, family_id = pInfo[playerid][pFamily],
				carid ;
			if (Iter_Count(FamilyListVehicle[family_id]) != 0) foreach(new V_IDX:FamilyListVehicle[family_id])
			{
				if (_step == listitem) {
					carid = V_IDX;
				}
				_step ++;
			}		

            printf("DEBUG CARID: %d %d", VehicleInfo[ carid - 1 ][vRank], carid);
            if (GetString(FamilyInfo[ family_id - 1 ][fOwner], pInfo[playerid][pName])) {
                format(t_string, sizeof t_string, "[0] Доступен с %s\n[1] Отбуксировать\n[2] Отметить на GPS\n[3] Продать ТС", 
                    fFamilyRank[ family_id - 1 ][ VehicleInfo[ carid - 1 ][vRank] - 1] 
                );
                
            } else {
                format(t_string, sizeof t_string, "[0] Доступен с %s\n[1] Отбуксировать\n[2] Отметить на GPS", 
                    fFamilyRank[ family_id - 1 ][ VehicleInfo[ carid - 1 ][vRank] - 1] 
                );
            }
            ShowPlayerDialog(playerid, D_FAMILY_FUNC_44, DIALOG_STYLE_LIST, ""colserver"Управления: "colwhi"Автопарком", t_string, "Выбрать", "Назад");
            SetPVarInt(playerid, "Family:V_IDX", carid); 
            return 1;
        }
        case D_FAMILY_FUNC_44:
		{
			if(!response) {
                return 1;
            } 
			new 
                family_id = pInfo[playerid][pFamily];
			switch(listitem)
			{
				case 0:
				{
					t_string[0] = EOS;
					for(new i = 0, string_[80]; i < FamilyInfo[family_id - 1][fSettings][3]; i++) { 
						format(string_, sizeof string_, "[%d] %s\n", i + 1, fFamilyRank[family_id - 1][i]);
						strcat(t_string, string_);
					}
					ShowPlayerDialog(playerid, D_FAMILY_FUNC_45, DIALOG_STYLE_LIST, ""colserver"Управления: "colwhi"Автопарком", t_string, !"Выбрать", !"Назад");
				}
				case 1:
				{
					new 
                        V_IDX = GetPVarInt(playerid, "Family:V_IDX"); 
                    DeletePVar(playerid, "Family:V_IDX");
					if(pInfo[playerid][pFamilyRank] != VehicleInfo[ V_IDX - 1 ][vRank]) return SendClientMessage(playerid, COLOR_GREY, "Вы не можете отбуксировать данный транспорт"); 
					if(IsVehicleOccupied(V_IDX) != -1) return SendClientMessage(playerid, COLOR_GREY, "Транспорт используется"); 
                    SetVehicleToRespawn(V_IDX); 
                     new string_[80];
                    format(string_, sizeof string_, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR %s ~g~FIXCAR~n~~r~$-1000", VehicleNames[VehicleInfo[ V_IDX - 1 ][vModel] - 400]);
                    GameTextForPlayer(playerid, string_, 3000, 3 );
				} 
				case 2://2] Поставить метку "col_li_red"GPS
				{
                    if (CP[playerid] == 777) {
						DisablePlayerCheckpoint(playerid);
						CP[playerid] = 0;
					}
					new 
                        V_IDX = GetPVarInt(playerid, "Family:V_IDX"); 
                    DeletePVar(playerid, "Family:V_IDX"); 
                    new 
                        string_[128]; 
                    format(string_, sizeof string_, 
                        "[Информация] "colwhi"Транспорт "colserver"%s(%d)"colwhi" отмечен на карте красной меткой!", 
                        VehicleNames[VehicleInfo[ V_IDX - 1][vModel]-400], VehicleInfo[ V_IDX - 1][vModel]
                    );
                    SendClientMessage(playerid, COLOR_LI_RED, string_);
                    CP[playerid] = 777;

                    new Float:vehx, Float:vehy, Float:vehz;
                    GetVehiclePos(V_IDX, vehx, vehy, vehz);
                    SetPlayerCheckpoint(playerid, vehx, vehy, vehz, 8); 
				}
                case 3: {
                    new 
                        V_IDX = GetPVarInt(playerid, "Family:V_IDX");   
                    if (VehicleInfo[ V_IDX - 1][vModel] == 462) {
                        DeletePVar(playerid, "Family:V_IDX"); 
                        SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт нельзя продать");
                        return 1;
                    }
                    format(t_string, sizeof t_string, ""colwhi"При продаже семейного автомобиля "colserver"(%s)"colwhi" государству\nГосударство возместит не полную стоимость авто\n\n\
                        Цена автомобиля составит: "collime"$%d\n\n"colwhi"Подтвердите продажу", VehicleNames[ VehicleInfo[ V_IDX - 1 ][vModel] - 400 ], (GetModelGovPrice(VehicleInfo[ V_IDX - 1][vModel]) / 2)
                    );
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_46, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Автомобиля", t_string, "Продать","Отмена"), t_string[0] = EOS; 
                }
			}
            return 1;
		}
        case D_FAMILY_FUNC_45:
		{ 
            if(!response) { 
                DeletePVar(playerid, "Family:V_IDX");
                return 1;
            }   
			new 
                V_IDX = GetPVarInt(playerid, "Family:V_IDX");
			DeletePVar(playerid, "Family:V_IDX");

			VehicleInfo[ V_IDX - 1 ][vRank] = listitem + 1;
			new 
                query_[90];
			format(query_, sizeof query_, "UPDATE `s_vehicle_family` SET `vRank`='%d' WHERE `vID`='%d' LIMIT 1", 
                VehicleInfo[ V_IDX - 1 ][vRank], VehicleInfo[ V_IDX - 1 ][vID]
            );
			mysql_query(dbHandle, query_); 
            return 1;
		}
        case D_FAMILY_FUNC_46: {
            if(!response) { 
                DeletePVar(playerid, "Family:V_IDX");
                return 1;
            }   
			new 
                V_IDX = GetPVarInt(playerid, "Family:V_IDX"),
                family_id = pInfo[playerid][pFamily];
			DeletePVar(playerid, "Family:V_IDX");
            if(IsVehicleOccupied(V_IDX) != -1) return SendClientMessage(playerid, COLOR_GREY, !"Транспорт используется"); 

            new query_[100];
			format(query_, sizeof query_, "DELETE FROM `s_vehicle_family` WHERE `vID` = '%d'", VehicleInfo[ V_IDX - 1 ] [vID]);
			mysql_tquery(dbHandle, query_, "", "");

            Iter_Remove(FamilyListVehicle[family_id], V_IDX);
            _DestroyVehicle(V_IDX); 
            return 1;
        }
        case D_FAMILY_FUNC_47:
		{
		    if (!response) {
                return 1;
            } 
		    switch(listitem)
		    {
				case 0: { 
					ShowPlayerDialog(playerid, D_FAMILY_FUNC_48, DIALOG_STYLE_INPUT, ""colserver"Банк: "colwhi"Пополнить счёт", "\n"colwhi"Введите сумму которую хотите положить на счёт:\n\n", "Выбрать", "Назад");
				}
				case 1: {
					ShowPlayerDialog(playerid, D_FAMILY_FUNC_49, DIALOG_STYLE_INPUT, ""colserver"Банк: "colwhi"Снять со счета", "\n"colwhi"Введите сумму которую хотите снять со счёта:\n\n", "Ввод", "Назад");
				}
				case 2: {
                    callcmd::fambank(playerid);
                }
			}
        }
        case D_FAMILY_FUNC_48:
		{
			if (!response) {
                callcmd::fambank(playerid);
                return 1;
            }
			new 
                F_IDX = pInfo[playerid][pFamily] - 1,
				amount = strval(inputtext);
			if (amount < 1 || amount > 5_000_000) { 
				ShowPlayerDialog(playerid, D_FAMILY_FUNC_48, DIALOG_STYLE_INPUT, ""colserver"Банк: "colwhi"Пополнить счёт", "\n"colwhi"Введите сумму которую хотите положить на счёт:\n\n", "Выбрать", "Назад");
				SendClientMessage(playerid, COLOR_GREY, !"Сумма не может быть меньше $1 и больше 5.000.000"); 
				return 1;
			}
			if (amount <= 0) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_48, DIALOG_STYLE_INPUT, ""colserver"Банк: "colwhi"Пополнить счёт", "\n"colwhi"Введите сумму которую хотите положить на счёт:\n\n", "Выбрать", "Назад");
                SendClientMessage(playerid, COLOR_GREY, !"Неверное кол-во"); 
                return 1;
            }
			if (kLibGetPlayerMoney(playerid) < amount) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег"); 
			kLibGivePlayerMoney(playerid, -amount, "пополнил семью");
			FamilyInfo[F_IDX][fBank] += amount; 
			format(t_string, sizeof t_string, "fBank = %d", FamilyInfo[F_IDX][fBank]);
            SaveFamily(playerid, t_string), t_string[0] = EOS;
			new
				string_[128]; 
            format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: Положил в банк "collime"$%d",
                family_chat_color[ FamilyInfo[ F_IDX ][fChatColor] ], FamilyInfo[ F_IDX ][fName],
                fFamilyRank[ F_IDX ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], amount
            ); 
            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
			return 1;
		}
		case D_FAMILY_FUNC_49:
		{
			if (!response) {
                callcmd::fambank(playerid);
                return 1;
            }
			new 
                F_IDX = pInfo[playerid][pFamily] - 1,
				amount = strval(inputtext);
            if (/*FamilyInfo[F_IDX][fBankLock] == 1 && */!GetString(FamilyInfo[ F_IDX ][fOwner], pInfo[playerid][pName])) {
                SendClientMessage(playerid, COLOR_GREY, !"Деньги снимать может только владелец семьи");
                callcmd::fambank(playerid);
                return 1;
            }
			if (amount < 1 || amount  > 5_000_000) {
				ShowPlayerDialog(playerid, D_FAMILY_FUNC_49, DIALOG_STYLE_INPUT, ""colserver"Банк: "colwhi"Снять со счета", "\n"colwhi"Введите сумму которую хотите снять со счёта:\n\n", "Ввод", "Назад");
				SendClientMessage(playerid, COLOR_GREY, !"Сумма не может быть меньше $1 и больше 5.000.000"); 
				return 1;
			}
			if (amount <= 0) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_49, DIALOG_STYLE_INPUT, ""colserver"Банк: "colwhi"Снять со счета", "\n"colwhi"Введите сумму которую хотите снять со счёта:\n\n", "Ввод", "Назад");
                SendClientMessage(playerid, COLOR_GREY, !"Неверное кол-во"); 
                return 1;
            }
			if (FamilyInfo[F_IDX][fBank] < amount) return SendClientMessage(playerid, COLOR_GREY, !"На банковском счёту нет столько денег.");
			kLibGivePlayerMoney(playerid, amount, "снял с семьи");
			FamilyInfo[F_IDX][fBank] -= amount;  
            format(t_string, sizeof t_string, "fBank = %d", FamilyInfo[F_IDX][fBank]);
            SaveFamily(playerid, t_string), t_string[0] = EOS;
			new
				string_[128]; 
            format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: снял с банка "collime"$%d",
                family_chat_color[ FamilyInfo[ F_IDX ][fChatColor] ], FamilyInfo[ F_IDX ][fName],
                fFamilyRank[ F_IDX ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], amount
            ); 
            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_); 
			return 1;
		}
        case D_FAMILY_FUNC_50: {
			if (!response) {
				ShowPlayerFamilySetting(playerid);
				return true;
			}
			new level = strval(inputtext); 
            new
                F_IDX = pInfo[playerid][pFamily] -1;
            FamilyInfo[F_IDX][fLimitRating] = level;  
            format(t_string, sizeof t_string, "fLimitRating = %d", FamilyInfo[F_IDX][fLimitRating]);
            SaveFamily(playerid, t_string), t_string[0] = EOS;
            new
				string_[128]; 
            format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: изменил пороговый рейтинг на %d.00",
                family_chat_color[ FamilyInfo[ F_IDX ][fChatColor] ], FamilyInfo[ F_IDX ][fName],
                fFamilyRank[ F_IDX ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], level
            ); 
            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_); 
			ShowPlayerFamilySetting(playerid);
			return true;
		}
        case D_FAMILY_FUNC_51: {
			if (!response) {
				ShowPlayerFamilySetting(playerid);
				return true;
			}
			new level = strval(inputtext); 
			if (!(1 <= level <= 100)) {
				ShowPlayerDialog(playerid, D_FAMILY_FUNC_51, DIALOG_STYLE_INPUT, ""colserver"Пороговый: "colwhi"Уровень", "\n"colwhi"Введите пороговый уровень, с которого можно принимать (1-100):\n", "Принять", "Назад");
				SendClientMessage(playerid, COLOR_GREY, !"Введите уровень от 1 до 100");
				return true;
			}
            new
                F_IDX = pInfo[playerid][pFamily] -1;
            FamilyInfo[F_IDX][fLimitLevel] = level;  
            format(t_string, sizeof t_string, "fLimitLevel = %d", FamilyInfo[F_IDX][fLimitLevel]);
            SaveFamily(playerid, t_string), t_string[0] = EOS;
            new
				string_[128]; 
            format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: изменил пороговый уровень на %d",
                family_chat_color[ FamilyInfo[ F_IDX ][fChatColor] ], FamilyInfo[ F_IDX ][fName],
                fFamilyRank[ F_IDX ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], level
            ); 
            SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_); 
			ShowPlayerFamilySetting(playerid);
			return true;
		}
        case D_FAMILY_FUNC_1:
		{
            if (!response)
			{
				for(new i = 0 ; i < 10 ; i ++)
				{
					new pvar_string [ 8 ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i ) ;
					DeletePVar ( playerid, pvar_string ) ;
				}
				DeletePVar ( playerid, "ofm_list_page" ) ;
				DeletePVar ( playerid, "ofm_list_rows" ) ;
				DeletePVar ( playerid, "ofm_listitem" ) ; 
                ShowFamilyPanel(playerid);
				return 1 ;
			}
            new 
                query_[128];
			if ( listitem == 0 )
			{
				new page_id = GetPVarInt ( playerid, "ofm_list_page" ) - 1;
				if ( page_id == 0 )
				{
					SendClientMessage(playerid, COLOR_GREY, !"Вы находитесь на первой странице списка участников семьи");  
                    mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
                    mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid); 
					return 1 ;

				}
				SetPVarInt ( playerid, "ofm_list_page", page_id ) ; 
                mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
                mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid); 

			}
			else if ( listitem == 1 )
			{
				new page_id = GetPVarInt ( playerid, "ofm_list_page" ) - 1 ;
				if ( ( page_id + 1 ) * 10 >= GetPVarInt ( playerid, "ofm_list_rows" ) )
				{
					SendClientMessage(playerid, COLOR_GREY, "Вы находитесь на последней странице списка членов организации.");
                    mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
                    mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid);  
					return 1 ;
				}
				SetPVarInt(playerid, "ofm_list_page", page_id + 2);
                mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
                mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid); 
			}
			else
			{
				new pvar_string[64],
					pl_name[MAX_PLAYER_NAME] ;
				format(pvar_string, 10, "ofm_%d", listitem - 2);
				GetPVarString(playerid, pvar_string, pl_name, 24 ) ;
				SetPVarInt(playerid, "ofm_listitem", listitem - 2 ) ;
				format(pvar_string, sizeof pvar_string, ""colserver"Участник: "colwhi"%s", pl_name);
				ShowPlayerDialog(playerid, D_FAMILY_FUNC_52, DIALOG_STYLE_LIST, pvar_string, "[0] Информация об игроке\n[1] Уволить из организации\n[2] Повысить/понизить игрока", "Выбрать", "Назад" ) ;
			} 
			return 1;
		}
        case D_FAMILY_FUNC_52:
		{
			if (!response)
			{
				DeletePVar( playerid, "ofm_listitem" );
				new query_[128];
                mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
                mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid); 
				return 1 ;
			}
			switch ( listitem )
			{
				case 0:
				{
					new pvar_string [ 18 ],
						pl_name[MAX_PLAYER_NAME] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME) ;
					new query_[ 128 ] ; 
					mysql_format(dbHandle, query_, sizeof query_, "SELECT `pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `Name` = '%s' LIMIT 1", pl_name);
					mysql_tquery(dbHandle, query_, "GetPlayerFamilyInfo", "i", playerid);
				}
				case 1:
				{
                    if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][1]) {
                        DeletePVar(playerid, "ofm_list_page");
                        DeletePVar(playerid, "ofm_list_rows");
                        DeletePVar(playerid, "ofm_listitem"); 
                        SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены выгонять из семьи.");
                        return 1;
                    }
					new pvar_string[64],
						pl_name[MAX_PLAYER_NAME] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) );
					GetPVarString ( playerid, pvar_string, pl_name, 24);
					format ( pvar_string, sizeof ( pvar_string ), ""colserver"Участник: "colwhi"%s", pl_name ); 
					new 
                        query_[128];
					format(query_, sizeof query_,"UPDATE `s_users` SET `pFamily` = '0', `pFamilyRank` = '0' WHERE `Name` = '%s' LIMIT 1", pl_name );
					mysql_tquery ( dbHandle, query_, "", "" ); 
					format(query_, sizeof query_, "Вы выгнали "colserver"%s{FFFFFF} из семьи", pl_name);
					SendClientMessage ( playerid, -1, query_ ); 
					DeletePVar( playerid, "ofm_listitem" ); 
                    mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
                    mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid); 

				}
				case 2: {
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_53, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Изменение ранга", "\n"colwhi"Введите номер ранга, который хотите установить для игрока:\n", "Выбрать", "Назад");
                }
			}
            return 1;
		}
        case D_FAMILY_FUNC_53:
		{
			new pvar_string [64],
				pl_name[40] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME - 4 ) ;
			if ( strval(inputtext) < 1 || strval(inputtext) > FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][3]) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_53, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Изменение ранга", "\n"colwhi"Введите номер ранга, который хотите установить для игрока:\n", "Выбрать", "Назад");
            }
			if ( strval ( inputtext ) >= pInfo[playerid][pFamilyRank]) {
				ShowPlayerDialog(playerid, D_FAMILY_FUNC_53, DIALOG_STYLE_INPUT, ""colserver"Семья: "colwhi"Изменение ранга", 
					""colwhi"- Неверный номер ранга!\n\nВведите номер ранга:\n\n\
					"col_li_red"Вы не можете повысить до ранга, выше/до вашего ранга!", "Далее", "Назад" 
				);
				return 1;
			} 
			if(response)
			{
				new 
                    string_[128];
				format(string_,sizeof string_, "UPDATE `s_users` SET `pFamilyRank` = '%d' WHERE `Name` = '%s' LIMIT 1",
				    strval(inputtext), pl_name 
                );
				mysql_tquery (dbHandle, string_, "", ""); 
				format(string_, sizeof string_, "Вы изменили ранг "colserver"%s{FFFFFF} на "colserver"%d", pl_name, strval ( inputtext ) ) ;
				SendClientMessage(playerid, -1, string_);

			}
			format ( pvar_string, sizeof ( pvar_string ), ""colserver"Участник: "colwhi"%s", pl_name ) ;
			ShowPlayerDialog(playerid, D_FAMILY_FUNC_52, DIALOG_STYLE_LIST, pvar_string, "[0] Информация об игроке\n[1] Выгнать из семьи\n[2] Повысить/понизить игрока", "Выбрать", "Назад" ) ;
            return 1;
		}
        case D_FAMILY_FUNC_54:
		{
			new pvar_string [64],
				pl_name [40] ;

			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME - 4 ) ;
			format ( pvar_string, sizeof ( pvar_string ), ""colserver"Участник: "colwhi"%s", pl_name ) ;
   			ShowPlayerDialog(playerid, D_FAMILY_FUNC_52, DIALOG_STYLE_LIST, pvar_string, "[0] Информация об игроке\n[1] Выгнать из семьи\n[2] Повысить/понизить игрока", "Выбрать", "Назад" ) ;
            return 1;
		}
        case D_FAMILY_FUNC_55: {
            if (!response) {
                return 1;
            }
            switch(listitem) {
                case 0: {
                    ShowFamilyBlackList(playerid);
                }
                case 1: {
                    ShowPlayerAddFamilyBlackList(playerid);
                } 
                case 2: {
                    new 
                        query_[128];
                    format(query_, sizeof query_, ""colwhi"Вы действительно хотите очистить черный список семьи?");
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_62, DIALOG_STYLE_MSGBOX, ""colserver"Черный список: "colwhi"Очистка", query_, "Да", "Нет");
                }
            }
            return 1;
        }
        
        case D_FAMILY_FUNC_56: {
			if (!response) {
				return true;
			}
			new 
				page = pTemp[playerid][tSelectPage],
				id = playerListItem[playerid][listitem];

			switch (id) {
				case 1: ShowFamilyBlackList(playerid, page + 1);
				case 2: ShowFamilyBlackList(playerid, page - 1);
				default: {
                    //SendMes(playerid, COLOR_GREY, "IDX: select %d", playerSelectSlot[playerid][listitem]);
                    new 
                        query_[128];
                    mysql_format(dbHandle, query_, sizeof query_, "SELECT addName, Reason, Name, Date FROM "TABLE_FAMILE_BLACK_LIST" WHERE blFamilyID = '%d' ORDER BY `Date` DESC", pInfo[playerid][pFamily]);
					mysql_tquery(dbHandle, query_, "SetPlayerSelectBLFamily", "ii", playerid, playerSelectSlot[playerid][listitem]);
                    //ShowFamilyBlackList(playerid, page);
                }
			}
			return true;
		}

        case D_FAMILY_FUNC_57: {
            if (!response) {
                strmid(pTemp[playerid][tAddBlackName], "None", 0, strlen(pTemp[playerid][tAddBlackReason]), 24);
                strmid(pTemp[playerid][tAddBlackReason], "None", 0, strlen(pTemp[playerid][tAddBlackReason]), 32); 
                callcmd::fambl(playerid);
                return 1;
            }
            switch(listitem) {
                case 0: {
                    new
                        string_[256];
                    format(string_, sizeof string_, 
                        ""colwhi"Введите никнейм игрока, которого хотите занести в черный список семьи {%s}%s\n"colwhi"Игрок не должен состоять в семье {%s}%s",
                        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                    );
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_58, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                }
                case 1: {
                    if (GetString(pTemp[playerid][tAddBlackName], "None")) {
                        SendClientMessage(playerid, COLOR_GREY, !"Укажите сначала никнейм");
                        ShowPlayerAddFamilyBlackList(playerid);
                        return 1;
                    } 
                     new
                        string_[256];
                    format(string_, sizeof string_, 
                        ""colwhi"Введите причину для пользователя %s\nКоторого хотите добавить в черный список семьи {%s}%s",
                        pTemp[playerid][tAddBlackName], family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                    );
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_59, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Причина", string_, "Сохранить", "Назад");
                }
                case 2: {
                    if (GetString(pTemp[playerid][tAddBlackName], "None")) {
                        SendClientMessage(playerid, COLOR_GREY, !"Укажите сначала никнейм");
                        ShowPlayerAddFamilyBlackList(playerid);
                        return 1;
                    } 
                    if (GetString(pTemp[playerid][tAddBlackReason], "None")) {
                        SendClientMessage(playerid, COLOR_GREY, !"Укажите сначала причину");
                        ShowPlayerAddFamilyBlackList(playerid);
                        return 1;
                    } 
                    new 
                        string_[256];
                    format(string_, sizeof string_, 
                        ""colwhi"Вы действительно хотите добавить пользователя в черный список, семьи {%s}%s?\n"colwhi"Пользователь: %s\nПричина: %s\n",
                        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                        pTemp[playerid][tAddBlackName], pTemp[playerid][tAddBlackReason]
                    );
                    ShowPlayerDialog(playerid, D_FAMILY_FUNC_60, DIALOG_STYLE_MSGBOX, ""colserver"Черный список: "colwhi"Добавить", string_, "Да", "Нет");
                }
            }
            return 1;
        }
        case D_FAMILY_FUNC_58: {
            if (!response) { 
                strmid(pTemp[playerid][tAddBlackName], "None", 0, strlen(pTemp[playerid][tAddBlackReason]), 24);
                ShowPlayerAddFamilyBlackList(playerid);
                return 1;
            }
            new
                string_[256];
            if (!strlen(inputtext) || strlen(inputtext) < 2 || strlen(inputtext) > 24) {
				format(string_, sizeof string_, 
                    ""colwhi"Введите никнейм игрока, которого хотите занести в черный список семьи {%s}%s\n"colwhi"Игрок не должен состоять в семье {%s}%s",
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                );
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_58, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                return 1;
            }
            //mysql_escape_string(inputtext, pInfo[playerid][pKey], 40, dbHandle); 
            if (!IsPlayerSearchBase(inputtext)) {
                SendClientMessage(playerid, COLOR_WHITE, !"Данный аккаунт не найден!");
                format(string_, sizeof string_, 
                    ""colwhi"Введите никнейм игрока, которого хотите занести в черный список семьи {%s}%s\n"colwhi"Игрок не должен состоять в семье {%s}%s",
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                );
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_58, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                return 1;
            }
            if (IsPlayerInFamily(inputtext, pInfo[playerid][pFamily])) {
                SendClientMessage(playerid, COLOR_WHITE, !"Игрок состоит в Вашей семье!");
                format(string_, sizeof string_, 
                    ""colwhi"Введите никнейм игрока, которого хотите занести в черный список семьи {%s}%s\n"colwhi"Игрок не должен состоять в семье {%s}%s",
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                );
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_58, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                return 1;
            }
            if (IsPlayerInFamilyBlackList(inputtext, pInfo[playerid][pFamily])) {
                SendClientMessage(playerid, COLOR_WHITE, !"Игрок уже находиться в черном списке Вашей семьи!");
                format(string_, sizeof string_, 
                    ""colwhi"Введите никнейм игрока, которого хотите занести в черный список семьи {%s}%s\n"colwhi"Игрок не должен состоять в семье {%s}%s",
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                );
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_58, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                return 1;
            }
            strmid(pTemp[playerid][tAddBlackName], inputtext, 0, 30, 30);
            ShowPlayerAddFamilyBlackList(playerid);
            return 1;
        }
        case D_FAMILY_FUNC_59: {
            if (!response) {
                strmid(pTemp[playerid][tAddBlackReason], "None", 0, strlen(pTemp[playerid][tAddBlackReason]), 32); 
                ShowPlayerAddFamilyBlackList(playerid);
                return 1;
            }
            new
                string_[256];
            if (!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 32) {
				format(string_, sizeof string_, 
                    ""colwhi"Введите причину для пользователя %s\nКоторого хотите добавить в черный список семьи {%s}%s\n"colwhi"Причина должна быть от 3 до 32 символов",
                    pTemp[playerid][tAddBlackName], family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                );
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_59, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                return 1;
            }
            if (NonSym(inputtext, 32, 3)) { 
                format(string_, sizeof string_, 
                    ""colwhi"Введите причину для пользователя %s\nКоторого хотите добавить в черный список семьи {%s}%s\n"colwhi"Причина должна быть от 3 до 32 символов",
                    pTemp[playerid][tAddBlackName], family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
                );
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_59, DIALOG_STYLE_INPUT, ""colserver"Черный список: "colwhi"Пользователь", string_, "Сохранить", "Назад");
                return 1;
            }
            strmid(pTemp[playerid][tAddBlackReason], inputtext, 0, strlen(inputtext), 32);
            ShowPlayerAddFamilyBlackList(playerid);
            return 1;
        } 
        case D_FAMILY_FUNC_60: {
            if (!response) {
                ShowPlayerAddFamilyBlackList(playerid);
            }
            else {
                new
                    query_[256];
                format(query_, sizeof query_, 
                    "INSERT INTO "TABLE_FAMILE_BLACK_LIST" (`Name`, `addName`, `blFamilyID`, `Reason`, `Date`) VALUES ('%s','%s','%d','%s',NOW())",
                    pInfo[playerid][pName], pTemp[playerid][tAddBlackName], pInfo[playerid][pFamily], pTemp[playerid][tAddBlackReason]
                );
                mysql_tquery(dbHandle, query_); 
                format(query_, sizeof query_,"{%s}[%s]"colwhi" %s %s: Занес в ЧС %s Причина: %s!",
                    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
                    fFamilyRank[ pInfo[playerid][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], pTemp[playerid][tAddBlackName], pTemp[playerid][tAddBlackReason]
                ); 
                SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, query_); 
                strmid(pTemp[playerid][tAddBlackName], "None", 0, strlen(pTemp[playerid][tAddBlackReason]), 24);
                strmid(pTemp[playerid][tAddBlackReason], "None", 0, strlen(pTemp[playerid][tAddBlackReason]), 32); 
            }
            return 1;
        }
        case D_FAMILY_FUNC_61: {
            if (!response) {
                new
                    getName[MAX_PLAYER_NAME],
                    query_[128];
                GetPVarString(playerid, "Family:BlackListName", getName, 24);
                format(query_, sizeof query_, "DELETE FROM "TABLE_FAMILE_BLACK_LIST" WHERE addName = '%s'", getName);
				mysql_tquery(dbHandle, query_, "", ""); 
                format(query_, sizeof query_, "Пользователь %s удален из черного списка", getName);
                SendClientMessage(playerid, COLOR_WHITE, query_); 
                //ShowFamilyBlackList(playerid);
            } else { 
                ShowFamilyBlackList(playerid);
            }
            DeletePVar(playerid, "Family:BlackListName");
            return 1;
        }
        case D_FAMILY_FUNC_62: {
            if (!response) {
                callcmd::fambl(playerid);
                return 1;
            } else {
                new
                    query_[128];
                format(query_, sizeof query_, "DELETE FROM "TABLE_FAMILE_BLACK_LIST" WHERE blFamilyID = '%d'", pInfo[playerid][pFamily]);
				mysql_tquery(dbHandle, query_, "", ""); 
                SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка] "colwhi"Черный список семьи очищен");
            }
            return 1;
        }
        case D_FAMILY_FUNC_63:
		{
	        if (!response) {
                SendClientMessage(playerid, COLOR_GREY, !"Вы отказались создавать семью");
                return 1;
            } 
			if (pInfo[playerid][pFamily] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже состоите в семье");
			if (strlen(inputtext) < 4 || strlen(inputtext) > 32) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_63, DIALOG_STYLE_INPUT, ""colwhi"Создание семьи", 
                    ""colwhi"Название семьи не может быть менее 4 символов или превышать 32 символа\n\nВведите название своей семьи:", 
                    "Создать", "Назад"
                );
                return 1;
			}
			if (is_text_invalid(inputtext)) {
                ShowPlayerDialog(playerid, D_FAMILY_FUNC_63, DIALOG_STYLE_INPUT, ""colwhi"Создание семьи", 
                    ""colwhi"Название семьи не может быть менее 4 символов или превышать 32 символа\n\nВведите название своей семьи:", 
                    "Создать", "Назад"
                );
                return 1;
			} else  {

				new query[164],
					query_[80];
				mysql_format(dbHandle, query, sizeof query, "INSERT INTO `s_family` (`fName`,`fOwner`,`fDate`) VALUES ( '%e', '%s', NOW())", inputtext, pInfo[playerid][pName]);
                mysql_tquery(dbHandle, query );
                pInfo[playerid][pFamily] = S_FAMILY_COUNT + 1;
                pInfo[playerid][pFamilyRank] = 3;
                format(query_, sizeof query_, "UPDATE `s_users` SET pFamily='%d',pFamilyRank='3' WHERE `pID` = '%d'", pInfo[playerid][pFamily], pInfo[playerid][pID]);
				mysql_tquery(dbHandle, query_, "", "");
                format(FamilyInfo[S_FAMILY_COUNT][fName], 32, inputtext);
                format(FamilyInfo[S_FAMILY_COUNT][fOwner], 24, pInfo[playerid][pName]);
                FamilyInfo[S_FAMILY_COUNT][fChatColor] = 0;
                FamilyInfo[S_FAMILY_COUNT][fPrefix] = 0;
                FamilyInfo[S_FAMILY_COUNT][fType] = 0;
				FamilyInfo[S_FAMILY_COUNT][fHouse] = -1;
                FamilyInfo[S_FAMILY_COUNT][fDefHouse] = -1;
                format( fFamilyRank[S_FAMILY_COUNT][0], 30, "Участник" ) ;
                format( fFamilyRank[S_FAMILY_COUNT][1], 30, "Заместитель" ) ;
                format( fFamilyRank[S_FAMILY_COUNT][2], 30, "Основатель" ) ;

				FamilyInfo[S_FAMILY_COUNT][fSettings][0] = 3;
				FamilyInfo[S_FAMILY_COUNT][fSettings][1] = 3;
				FamilyInfo[S_FAMILY_COUNT][fSettings][2] = 3;
				FamilyInfo[S_FAMILY_COUNT][fSettings][3] = 3;
                FamilyInfo[S_FAMILY_COUNT][fSettings][4] = 3; //Open/Closed Bank
                FamilyInfo[S_FAMILY_COUNT][fSettings][5] = 3; //Open/Closed Safe
                FamilyInfo[S_FAMILY_COUNT][fBank] = 0;
                FamilyInfo[S_FAMILY_COUNT][fBankLock] = 1;
                FamilyInfo[S_FAMILY_COUNT][fSafeLock] = 1;
                FamilyInfo[S_FAMILY_COUNT][fLimitLevel] = 3;
                FamilyInfo[S_FAMILY_COUNT][fLimitRating] = 1;
                FamilyInfo[S_FAMILY_COUNT][fPromoID] = -1;
                Invite_Family(playerid, pInfo[playerid][pFamily]);
                SendMes(playerid, COLOR_WHITE, "Вы успешно создали семью "colserver"%s"colwhi". Используйте - "colserver"\"/fam\"", FamilyInfo[S_FAMILY_COUNT][fName]);
				OnPlayerAchievProgress(playerid, 31);
                S_FAMILY_COUNT ++;
				return 1 ;
            }
        }		
	}
	return false;
}

CMD:famcars(playerid)
{
	if (pInfo[playerid][pFamily] == 0 || GetFamilyDefaultHouse(playerid) == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье или у вашей семьи нет семейного дома");
	return ShowPlayerSelectFamilyCar(playerid, pInfo[playerid][pFamily]);
}

CMD:faminvite(playerid, params[])
{
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
	if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][0])return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены приглашать в семью");
    if (sscanf(params, "u", params[0]))return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /faminvite [id]");
 	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
	if (params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали свой ID");
	if (GetDistanceBetweenPlayers(playerid, params[0]) > 5.0) return SendClientMessage(playerid, COLOR_GREY, !"Вы слишком далеко!");
	if (pInfo[params[0]][pFamily] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже состоит в семье");
    new 
        string_[256];

    /*
    if (pInfo[params[0]][pLevel] < FamilyInfo[pInfo[playerid][pFamily] - 1][fLimitLevel]) {
        format(string_, sizeof string_, "Игрок должен иметь %d уровень", FamilyInfo[pInfo[playerid][pFamily] - 1][fLimitLevel]);
        SendClientMessage(playerid, COLOR_GREY, string_);
        return 1;
    }
    */
    if (floatround(pInfo[params[0]][pRating]) < FamilyInfo[pInfo[playerid][pFamily] - 1][fLimitRating]) {
        format(string_, sizeof string_, "Игрок должен иметь %d.00 рейтинга", FamilyInfo[pInfo[playerid][pFamily] - 1][fLimitRating]);
        SendClientMessage(playerid, COLOR_GREY, string_);
        return 1;
    }
    if (IsPlayerInFamilyBlackList(pInfo[params[0]][pName], pInfo[playerid][pFamily])) {
        SendClientMessage(playerid, COLOR_WHITE, !"Игрок находиться в черном списке Вашей семьи!");
        return 1;
    }          
	format(string_, sizeof string_,"{FFFFFF}%s предлагает Вам вступить в семью: "colserver"%s{FFFFFF}\n\nНажмите Да для согласия.\nНажмите Нет для отказа!", pInfo[playerid][pName], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]);
	ShowPlayerDialog(params[0], D_FAMILY_FUNC_5, DIALOG_STYLE_MSGBOX, ""colserver"Предложение", string_, "Да", "Нет");
	SendMes(playerid, COLOR_WHITE, "Вы пригласили "colserver"%s"colwhi" присоединиться к семье "colserver"%s "colwhi"", pInfo[params[0]][pName], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]);
    SetPVarInt(params[0], "PlayerFamilyInvite", pInfo[playerid][pFamily]);
    return 1;
}
CMD:famuninvite(playerid, params[])
{
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в семье");
 	if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][1]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены выгонять из семьи.");
    if ( sscanf(params, "u", params [0] ) )return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /famuninvite [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
	if (params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали свой ID"); 
    if (pInfo[params[0]][pFamily] != pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье");
	if (GetString(pInfo[ params[0] ][pName], FamilyInfo[ pInfo[ params[0] ][pFamily] - 1 ][fOwner])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете уволить владельца");

    SendMes(playerid, COLOR_WHITE, "Вы выгнали "colserver"%s "colwhi"из семьи"colserver"%s "colwhi"", pInfo[params[0]][pName], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]);

    new
		string_[80];
    format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: исключили из семьи!",
    family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ],
    FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
	fFamilyRank[ pInfo[params[0]][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ],
	pInfo[params[0]][pName]);

    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
    Leave_Family(params[0], pInfo[params[0]][pFamily]);
	pInfo[params[0]][pFamily] = 0;
	pInfo[params[0]][pFamilyRank] = 0;  
	new
		query_[80];
    format(query_, sizeof query_, "UPDATE `s_users` SET pFamily='0',pFamilyRank='0' WHERE `pID` = '%d'", pInfo[params[0]][pID]);
	mysql_tquery(dbHandle, query_, "", "");
    return 1;
}

CMD:famoffuninvite(playerid, params[])
{
	if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в семье");
    //if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][1]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены выгонять из семьи.");
 	if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][1]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены выгонять из семьи");
    if (strlen(params[0]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
    new 
        queryName[32], targetid = INVALID_PLAYER_ID; 
    if (sscanf(params, "s[32]", queryName)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /famoffuninvite [NickName]");
    if (GetString(queryName, FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fOwner])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете уволить владельца");
    sscanf(queryName, "u", targetid);
	if (IsPlayerConnected(targetid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /famuninvite ))", pInfo[targetid][pName], targetid);
    new 
        query_[128];  
    format(query_, sizeof query_, "SELECT pID, playerspawn FROM s_users WHERE Name = '%s' AND pFamily = %d LIMIT 1", params[0], pInfo[playerid][pFamily]);
    mysql_tquery(dbHandle, query_, "SetFamilyPlayerOff", "is", playerid, queryName); 
	return 1;
}
publics: SetFamilyPlayerOff(playerid, const queryName[]) {

    new rows;
	cache_get_row_count(rows);
    if (!rows) {
        SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье!");
        return 1;
    }  
    new  
        f_SpawnChange = -1,
        f_pID; 
    cache_get_value_name_int(0, "pID", f_pID);
    cache_get_value_name_int(0, "playerspawn", f_SpawnChange);
    if (f_SpawnChange == 5 || f_SpawnChange == 6) {
        f_SpawnChange = 0;  
    } 
    new 
        query_[128];
    format(query_, sizeof query_, "UPDATE s_users SET pFamilyRank = 0, pFamily = 0, playerspawn = '%d' WHERE pID = '%d'", f_SpawnChange, f_pID);
    mysql_tquery(dbHandle, query_); 
    format(query_, sizeof query_,"{%s}[%s]"colwhi" %s %s: исключил из семьи %s Offline!",
        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ], FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
        fFamilyRank[ pInfo[playerid][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], queryName
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, query_);
    format(query_, sizeof query_, ""colinfo"[Уведомления] "colwhi"Вас исключили из семьи");
    MessagePlayerOffline(f_pID, query_);
    return 1;
}
stock Family_PlayerTime(playerid) 
{
    if (pInfo[playerid][pFamilyMute] > 0) 
    {
        pInfo[playerid][pFamilyMute] --;
        
        if (pInfo[playerid][pFamilyMute] <= 0) 
        {
            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Срок бана семейного чата истёк, не нарушайте правила!");
        }
    }
}
CMD:fammute(playerid, params[])
{
    if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][0])return SendClientMessage(playerid, COLOR_GREY, !"Выдать бан семейного чата"); 
	if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /fammute [ID] [минуты]");  
	if (params[0] == INVALID_PLAYER_ID) return 1;
    if (GetString(pInfo[ params[0] ][pName], FamilyInfo[ pInfo[ params[0] ][pFamily] - 1 ][fOwner])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете замутить владельца!");
	if (pInfo[params[0]][pFamily] != pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье"); 
	if (pInfo[params[0]][pFamilyMute] > 0) return SendClientMessage(playerid, COLOR_GREY, !"У этого игрока уже есть бан семейного чата!");
    if (params[1] > 120 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Время от 1 минуты до 120 минут");
	pInfo[params[0]][pFamilyMute] = (params[1]*60);
    SavePlayerInteger(params[0], "pFamilyMute", pInfo[params[0]][pFamilyMute]);
    new
		string_[144];
    format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: выдал бан семейного чата: %s[%d] на %d минут",
        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ],
        FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
        fFamilyRank[ pInfo[playerid][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ],
        pInfo[playerid][pName], pInfo[params[0]][pName], params[0], params[1] 
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_); 
	return 1;
}
CMD:famunmute(playerid, params[])
{
	if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][0])return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены выдавать бан семейного чата");
	if (sscanf(params, "u", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /famunmute [ID]");  
	if (params[0] == INVALID_PLAYER_ID) return 1;
    if (pInfo[params[0]][pFamily] != pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье");  
	if (pInfo[params[0]][pFamilyMute] < 1) return SendClientMessage(playerid, COLOR_GREY, !"У этого игрока нет бана чата!"); 
	SavePlayerInteger(params[0], "pFamilyMute", pInfo[params[0]][pFamilyMute]);
    new
		string_[144];
    format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: снял бан семейного чата: %s[%d]",
        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ],
        FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
        fFamilyRank[ pInfo[playerid][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ],
        pInfo[playerid][pName], pInfo[params[0]][pName], params[0]
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);  
	return 1;
}
CMD:k(playerid, params[])
{ 
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /k [текст]"); 
    new
		string_[144];
    format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: %s",
        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ],
        FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
        fFamilyRank[ pInfo[playerid][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ],
        pInfo[playerid][pName], params[0]
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
    return 1;
}
CMD:kb(playerid, params[])
{ 
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /kb [OOC текст]"); 
    new
		string_[144];
    format(string_, sizeof string_,"(( {%s}[%s]"colwhi" %s %s: %s ))",
        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ],
        FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName],
        fFamilyRank[ pInfo[playerid][pFamily] - 1 ][ pInfo[playerid][pFamilyRank] - 1 ],
        pInfo[playerid][pName], params[0]
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
    return 1;
}  	
CMD:famrank(playerid, params[])
{
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в семье");
 	if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][2]) return 1;
    if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /famrank [id]");
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
	if (params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали свой ID");
    if (pInfo[params[0]][pFamily] != pInfo[playerid][pFamily])return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье");
	if (GetString(pInfo[ params[0] ][pName], FamilyInfo[ pInfo[ params[0] ][pFamily] - 1 ][fOwner])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете изменить ранг владельцу"); 
    t_string[0] = EOS;
	for(new i = 0, string_[64]; i < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][3]; i ++) { 
		format(string_, sizeof string_, ""colwhi"[%d] %s\n", i, fFamilyRank [ pInfo[playerid][pFamily] - 1 ] [ i ] ) ;
		strcat(t_string, string_);
	}
	ShowPlayerDialog(playerid, D_FAMILY_FUNC_14, DIALOG_STYLE_LIST, ""colserver"Семья: "colwhi"Назначить ранг", t_string, "Выбрать", "Назад" ); 
	SetPVarInt(playerid, "pl_setrank_id", params[0] ) ;
	return 1 ;
}
CMD:fambl(playerid) {
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в семье");
    if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][1]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены заносить в ЧС");
    new 
        string_[128];
    format(string_, sizeof string_, "[0] Черный список семьи {%s}%s\n[1] Добавить в список\n[2] Очистить список", 
        family_chat_color[ FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fChatColor] ],
        FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fName]
    );
    ShowPlayerDialog(playerid, D_FAMILY_FUNC_55, DIALOG_STYLE_LIST, ""colserver"Семейный: "colwhi"Черный список", string_, "Выбрать", "Закрыть");
    return 1;
}
stock IsPlayerInFamilyBlackList(const name_player[], family_id)
{
	new query_[128],
		rows ;
	format(query_, sizeof query_, "SELECT * FROM "TABLE_FAMILE_BLACK_LIST" WHERE `addName` = '%s' AND `blFamilyID` = '%d' LIMIT 1", name_player, family_id);
	mysql_query(dbHandle, query_, true);
	cache_get_row_count(rows);

	if (!rows)
		return 0;
	else
		return 1;
}
stock IsPlayerSearchBase(const name_player[])
{
	new query_[128],
		rows ;
	format(query_, sizeof query_, "SELECT * FROM s_users WHERE `Name` = '%s' LIMIT 1", name_player);
	mysql_query(dbHandle, query_, true);
	cache_get_row_count(rows);

	if (!rows)
		return 0;
	else
		return 1;
}
stock IsPlayerInFamily(const name_player[], family_id)
{
	new query_[128],
		rows ;
	format(query_, sizeof query_, "SELECT * FROM s_users WHERE `Name` = '%s' AND `pFamily` = '%d' LIMIT 1", name_player, family_id);
	mysql_query(dbHandle, query_, true);
	cache_get_row_count(rows);

	if (!rows)
		return 0;
	else
		return 1;
}
            
/*
addName
Reason
Name
Date
blFamilyID
*/
                    
stock ShowFamilyBlackList(playerid, page = 1) {
    format(t_string, sizeof (t_string), "SELECT addName, Reason, Name, Date FROM "TABLE_FAMILE_BLACK_LIST" WHERE blFamilyID = '%d' ORDER BY `Date` DESC", 
        pInfo[playerid][pFamily]
    );
    new rows, Cache:tempQuery = mysql_query(dbHandle, t_string);
    cache_get_row_count(rows);
    t_string[0] = EOS;
    
    if (!rows) {
        SendClientMessage(playerid, COLOR_GREY, !"Ваш черный список пуст");
        if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
        return true;
    }
    new max_page = (MAX_DIALOG_LIST_BLACK_LIST + rows) / MAX_DIALOG_LIST_BLACK_LIST, idx = 0;
    if (page < 1) page = 1;
    else if (page > max_page) page = max_page; 

    t_string = ""colserver"Пользователь\t"colserver"Причина\t"colserver"Инициатор\t"colserver"Дата добавления\n"colwhi"";
    for (new i = ((page - 1) * MAX_DIALOG_LIST_BLACK_LIST), tempName[32], tempID, tempReason[32], tempOwner[32], tempDate[32]; i < (page * MAX_DIALOG_LIST_BLACK_LIST); i++) {
        if (i >= rows) continue;
        cache_get_value_name_int(i, "blID", tempID);
        cache_get_value_name(i, "addName", tempName, sizeof (tempName));
        cache_get_value_name(i, "Reason", tempReason, sizeof (tempReason)); 
        cache_get_value_name(i, "Name", tempOwner, sizeof (tempOwner));
        cache_get_value_name(i, "Date", tempDate, sizeof (tempDate));

        format(t_string, sizeof (t_string), "%s[%i] %s\t%s\t%s\t%s\t\n", t_string, (page - 1) * MAX_DIALOG_LIST_BLACK_LIST + idx, tempName, tempReason, tempOwner, tempDate);
        playerListItem[playerid][idx] = -1;
        playerSelectSlot[playerid][idx] = i;
        idx++;
        //SendMes(playerid, COLOR_GREY, "IDX: %d | rows %d : tempID %d", playerListItem[playerid][idx], i, tempID);
    }
    if (page > 1) {
        strcat(t_string, "[<<<] Предыдущая страница\n");
        playerListItem[playerid][idx++] = 2; // (-)
    }
    if (page < max_page) {
        strcat(t_string, "Следующая страница [>>>] \n");
        playerListItem[playerid][idx++] = 1; // (+)
    }
    pTemp[playerid][tSelectPage] = page; 

    new titleSTR[46];
    format(titleSTR, sizeof (titleSTR), ""colserver"Черный список: "colwhi"Всего: %d", rows);
    ShowPlayerDialog(playerid, D_FAMILY_FUNC_56, DIALOG_STYLE_TABLIST_HEADERS, titleSTR, t_string, "Выбрать", "Закрыть");

    if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
    t_string[0] = EOS;
    return true;
}
publics: SetPlayerSelectBLFamily(playerid, rows_id)
{
	new rows;
	cache_get_row_count(rows);
	if (rows_id > rows)
	{
        new 
            page = pTemp[playerid][tSelectPage];
        ShowFamilyBlackList(playerid, page);
		return 1;
	} else {
        new 
            getAddName[24],
            getBLName[24],
            getReason[32], 
            getDate[16]; 
        cache_get_value_name(rows_id, "addName", getBLName, sizeof (getBLName));
        cache_get_value_name(rows_id, "Reason", getReason, sizeof (getReason)); 
        cache_get_value_name(rows_id, "Name", getAddName, sizeof (getAddName));
        cache_get_value_name(rows_id, "Date", getDate, sizeof (getDate));  
        SetPVarString(playerid, "Family:BlackListName", getBLName/*, MAX_PLAYER_NAME*/);
		format(t_string, sizeof t_string, 
            ""colwhi"Пользователь %s, в черном списке с %s\nДобавил в черный список: %s\nПричина: %s",
			getBLName, getDate, getAddName, getReason 
		);
		ShowPlayerDialog(playerid, D_FAMILY_FUNC_61, DIALOG_STYLE_MSGBOX, ""colserver"Информация об игроке", t_string, "Назад", "Удалить"), t_string[0] = EOS;
    } 
	return 1;
}
        
stock NonSym(const text_[], max = 0, min = 0) 
{
	static 
		BadNameChars[][2] = {"/","\n","`","~","%","^","&","[","]","{","}","|","'"}; 
	for( new i = 0; i < sizeof( BadNameChars ); i++ ) {
		if( strfind( text_, BadNameChars[i], true ) != -1 || strlen( text_ ) > max || strlen( text_ ) < min ) 
			return 1;
	} 
	return 0;
}
stock ShowPlayerAddFamilyBlackList(playerid) {
    new
        string_[128],
        strName[24],
        strReason[32];
    if (!GetString(pTemp[playerid][tAddBlackName], "None")) {
        strmid(strName, pTemp[playerid][tAddBlackName], 0, strlen(pTemp[playerid][tAddBlackName]), MAX_PLAYER_NAME);
    } else strName = "Не указан";
    if (!GetString(pTemp[playerid][tAddBlackReason], "None")) {
        strmid(strReason, pTemp[playerid][tAddBlackReason], 0, strlen(pTemp[playerid][tAddBlackReason]), 32);
    } else strReason = "Не указана";

    format(string_, sizeof string_, ""colwhi"[0] Пользователь:\t%s\n[1] Причина:\t%s\n"collime"[»] Занести в ЧС", strName, strReason); 
    ShowPlayerDialog(playerid, D_FAMILY_FUNC_57, DIALOG_STYLE_TABLIST, ""colserver"Черный список: "colwhi"Занести", string_, "Выбор", "Назад");
}
         
CMD:famoffrank(playerid, params[])
{
	if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в семье");
 	if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][2]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены менять ранг");
    if (strlen(params[0]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
    new 
        queryName[32], tid_rank, targetid = INVALID_PLAYER_ID; 
    if (sscanf(params, "s[32]d", queryName, tid_rank)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /famoffrank [NickName] [ранг]");
    if (GetString(queryName, FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fOwner])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете изменить владельцу ранг");
    if (tid_rank < 1) return SendClientMessage(playerid, COLOR_GREY, !"Ранг должен быть не меньше одного!");
    new 
        query_[128]; 
    if (tid_rank > FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][3]) {
		format(query_, sizeof query_, "Нельзя меньше 1 и больше %d!", FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][3]);
		SendClientMessage(playerid, COLOR_GREY, query_);
		return 1;
	}
    sscanf(queryName, "u", targetid);
	if (IsPlayerConnected(targetid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /famrank ))", pInfo[targetid][pName], targetid);
    if (tid_rank >= pInfo[playerid][pFamilyRank]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете повысить до ранга, выше вашего/до вашего ранга!");
     
    format(query_, sizeof query_, "SELECT pID, pFamilyRank FROM s_users WHERE Name = '%s' AND pFamily = %d LIMIT 1", queryName, pInfo[playerid][pFamily]);
    mysql_tquery(dbHandle, query_, "SetFamilyPlayerOffGiveRank", "dds", playerid, tid_rank, queryName); 
	return 1;
}
publics: SetFamilyPlayerOffGiveRank(playerid, rank, targetname[]) {

    new rows;
	cache_get_row_count(rows);
    if (!rows) {
        SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в Вашей семье!");
        return 1;
    }  
    new  
        f_pID,
        f_FamilyRank; 
    cache_get_value_name_int(0, "pID", f_pID);
    cache_get_value_name_int(0, "pFamilyRank", f_FamilyRank); 
    if (pInfo[playerid][pFamilyRank] == f_FamilyRank) {
        SendClientMessage(playerid, COLOR_GREY, !"Вы не можете понизить равного себе по рангу");
        return 1;
    }
    new 
        query_[128];
    format(query_, sizeof query_, "UPDATE s_users SET pFamilyRank = '%d' WHERE pID = '%d'", rank, f_pID);
    mysql_tquery(dbHandle, query_);
    format(query_, sizeof query_, "Вы назначили "colserver"%s"colwhi" на статус "colserver"%s(%d)", targetname, fFamilyRank[ pInfo[playerid][pFamily] - 1 ] [ rank - 1 ], rank);
    SendClientMessage(playerid, COLOR_WHITE, query_); 
    return 1;
}
CMD:addfamhouse(playerid, params[])
{ 
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /addfamhouse [Цена] [int]");
    if (params[1] < 0 || params[1] > sizeof(FamilyInterior)) return SendClientMessage(playerid, COLOR_GREY, !"Error ID Family Int");
    new Float: p_X, Float: p_Y, Float: p_Z, Float: p_A;
	GetPlayerPos(playerid, p_X, p_Y, p_Z);
    GetPlayerFacingAngle(playerid, p_A);

	FamilyHouse[S_FAMILY_HOUSE_COUNT][fhEnter][0] = p_X;
    FamilyHouse[S_FAMILY_HOUSE_COUNT][fhEnter][1] = p_Y;
    FamilyHouse[S_FAMILY_HOUSE_COUNT][fhEnter][2] = p_Z;
    FamilyHouse[S_FAMILY_HOUSE_COUNT][fhEnter][3] = p_A;

    FamilyHouse[S_FAMILY_HOUSE_COUNT][fhCost] = params[0];
	FamilyHouse[S_FAMILY_HOUSE_COUNT][fhIntID] = params[1]; 
    t_string[0] = EOS;
    format(t_string, sizeof (t_string), "INSERT INTO "TABLE_HOUSE_FAMILY" (`hCost`, `hEnter`, `hInterior`) VALUES ('%d', '%.2f|%.2f|%.2f|%.2f', '%d')",
		params[0], p_X, p_Y, p_Z, p_A, params[1]
	);
	new Cache:tempQuery = mysql_query(dbHandle, t_string), rows;

	t_string[0] = EOS;
	cache_get_row_count(rows);

	FamilyHouse[S_FAMILY_HOUSE_COUNT][fhID] = cache_insert_id(); 
    S_FAMILY_HOUSE_COUNT++;
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
    SendClientMessage(playerid, COLOR_RED, !"[Подсказка] {FFFFFF}Вы успешно создали новую семейную квартиру!"); 
	return true;
} 

stock ShowMenuFamilyHouse(playerid, houseid) {
	if (pTemp[playerid][tFamilyHouseMenuShowed]) return true;  
    format(t_string, sizeof (t_string), "%d", FamilyHouse[houseid][fhID]);
    FamilyHouse_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 552.566589, 165.755493, t_string);//Номер дома
    PlayerTextDrawLetterSize(playerid, FamilyHouse_PTD[playerid][0], 0.217899, 0.886500);
    PlayerTextDrawAlignment(playerid, FamilyHouse_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, FamilyHouse_PTD[playerid][0], COLOR_SERVER);
    PlayerTextDrawSetShadow(playerid, FamilyHouse_PTD[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, FamilyHouse_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, FamilyHouse_PTD[playerid][0], -754100980);
    PlayerTextDrawFont(playerid, FamilyHouse_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, FamilyHouse_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, FamilyHouse_PTD[playerid][0], 0);

    format(t_string, sizeof (t_string), "%s", FamilyHouse[houseid][fhOwner]);
    FamilyHouse_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 528.466674, 193.533294, t_string);//Фам овнер
    PlayerTextDrawLetterSize(playerid, FamilyHouse_PTD[playerid][1], 0.167300, 0.770299);
    PlayerTextDrawAlignment(playerid, FamilyHouse_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, FamilyHouse_PTD[playerid][1], COLOR_SERVER);
    PlayerTextDrawSetShadow(playerid, FamilyHouse_PTD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, FamilyHouse_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, FamilyHouse_PTD[playerid][1], -754100980);
    PlayerTextDrawFont(playerid, FamilyHouse_PTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, FamilyHouse_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, FamilyHouse_PTD[playerid][1], 0); 

    format(t_string, sizeof (t_string), "%i", FamilyHouse[houseid][fhCost]);
    FamilyHouse_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 552.000000, 220.681503, t_string);//Кост
    PlayerTextDrawLetterSize(playerid, FamilyHouse_PTD[playerid][2], 0.217899, 0.886500);
    PlayerTextDrawAlignment(playerid, FamilyHouse_PTD[playerid][2], 2);
    PlayerTextDrawColor(playerid, FamilyHouse_PTD[playerid][2], COLOR_SERVER);
    PlayerTextDrawSetShadow(playerid, FamilyHouse_PTD[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, FamilyHouse_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, FamilyHouse_PTD[playerid][2], -754100980);
    PlayerTextDrawFont(playerid, FamilyHouse_PTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, FamilyHouse_PTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, FamilyHouse_PTD[playerid][2], 0);

     

	for (new i = 0; i < sizeof (FamilyHouse_TD); i++) 
		TextDrawShowForPlayer(playerid, FamilyHouse_TD[i]);
	for (new i = 0; i < 3; i++) { 
		PlayerTextDrawShow(playerid, FamilyHouse_PTD[playerid][i]); 
    }
        

	pTemp[playerid][tFamilyHouseMenuShowed] = true; 
	return true;
}
 
stock HideMenuFamilyHouse(playerid) {
	if (!pTemp[playerid][tFamilyHouseMenuShowed]) return false;
    for (new i = 0; i < sizeof (FamilyHouse_TD); i++) 
		TextDrawHideForPlayer(playerid, FamilyHouse_TD[i]);
	for (new i = 0; i < 3; i++) 
		PlayerTextDrawDestroy(playerid, FamilyHouse_PTD[playerid][i]);  
	pTemp[playerid][tFamilyHouseMenuShowed] = false; 
	return true;
} 
stock SaveFamilyHouse(houseid, const query_string[]) {
    mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_HOUSE_FAMILY" SET %s WHERE hID = %i LIMIT 1", query_string, FamilyHouse[houseid][fhID]
	);
	if (MYSQL_DEBUG) printf("[SaveFamilyHouse]: \"%s\"", t_string);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}
stock SaveFamily(playerid, const query_string[]) {
	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_FAMILY" SET %s WHERE fID = %i LIMIT 1", query_string, pInfo[playerid][pFamily]
	);
	if (MYSQL_DEBUG) printf("[SaveFamily]: \"%s\"", t_string);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}  
stock ShowFamilyList(playerid, page = 1) { 
    new rows, Cache:tempQuery = mysql_query(dbHandle, "SELECT `fName`,`fOwner`,`fRepute` FROM "TABLE_FAMILY"");
    cache_get_row_count(rows);
    t_string[0] = EOS;
    
    if (!rows) {
        SendClientMessage(playerid, COLOR_GREY, !"В данный момент нет еще семей");
        if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
        return true;
    }
    new max_page = (MAX_FAMILY_LIST + rows) / MAX_FAMILY_LIST, idx = 0;
    if (page < 1) page = 1;
    else if (page > max_page) page = max_page; 

    t_string = ""colserver"Название\t"colserver"Репутация\t"colserver"Основатель\n"colwhi"";
    for (new i = ((page - 1) * MAX_FAMILY_LIST), tempName[32], tempOwner[24], tempLevel; i < (page * MAX_FAMILY_LIST); i++) {
        if (i >= rows) continue;
        cache_get_value_name(i, "fName", tempName, sizeof (tempName));
        cache_get_value_name_int(i, "fRepute", tempLevel); 
        cache_get_value_name(i, "fOwner", tempOwner, sizeof (tempOwner));

        format(t_string, sizeof (t_string), "%s[%i] %s\t%d\t%s\n", t_string, (page - 1) * MAX_FAMILY_LIST + idx, tempName, tempLevel, tempOwner);
        playerListItem[playerid][idx++] = -1;
    }
    if (page > 1) {
        strcat(t_string, "[<<<] Предыдущая страница\n");
        playerListItem[playerid][idx++] = 2; // (-)
    }
    if (page < max_page) {
        strcat(t_string, "Следующая страница [>>>] \n");
        playerListItem[playerid][idx++] = 1; // (+)
    }
    pTemp[playerid][tSelectPage] = page; 

    new titleSTR[52];
    format(titleSTR, sizeof (titleSTR), ""colserver"Семейный центр: "colwhi"Всего семей: %d", rows);
    ShowPlayerDialog(playerid, D_FAMILY_FUNC_35, DIALOG_STYLE_TABLIST_HEADERS, titleSTR, t_string, "Выбрать", "Закрыть");

    if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
    t_string[0] = EOS;
    return true;
}   

CMD:famhouse(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /famhouse [housenumber]");
    if (params[0] > S_FAMILY_HOUSE_COUNT) return SendMes(playerid, COLOR_GREY, !"Неверный ID FAM HOUSE (Count: %d)", S_FAMILY_HOUSE_COUNT);
	SetPlayerPosAC(playerid, FamilyHouse[params[0]][fhEnter][0], FamilyHouse[params[0]][fhEnter][1], FamilyHouse[params[0]][fhEnter][2], 0, 0);
	SetPlayerFacingAngle(playerid, 0.0);
    teleport_tick[playerid] = GetTickCount();
    GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~TELEPORT ~g~FAMILY_HOUSE", 3000, 3);
	return 1;
}  
stock GetFamilyHome()
{
    for(new i = 0; i < S_FAMILY_HOUSE_COUNT; i++) 
	{
        if (strcmp("None", FamilyHouse[i][fhOwner],true) == 0) continue;//fhLandTax
       
		if (FamilyHouse[i][fhLandTax] < GetFamilyHouseRent)
		{ 
            for(new F_IDX = 0, query_[100]; F_IDX < S_FAMILY_COUNT; F_IDX++) {
                if (FamilyInfo[ (F_IDX + 1) ][fHouse] == i) {
                    printf("fName %s %d", FamilyInfo[ (F_IDX + 1) ][fName], (F_IDX + 1));
                    format(t_string, sizeof t_string,"{%s}[%s]"colwhi": Cемейный дом №%d был продан государству!",
                        family_chat_color[ FamilyInfo[ (F_IDX + 1) ][fChatColor] ],
                        FamilyInfo[ (F_IDX + 1) ][fName], FamilyHouse[i][fhID]
                    ); 
                    SendPlayerFamilyMessage((F_IDX + 2), COLOR_WHITE, t_string, true), t_string[0] = EOS;
                    format(query_, sizeof query_, "UPDATE `s_users` SET `playerspawn` = '0' WHERE `pFamily` = '%d' AND `playerspawn` = '5'", (F_IDX + 1));
                    mysql_tquery(dbHandle, query_);
                    FamilyInfo[(F_IDX + 1)][fHouse] = -1;

                    mysql_format(dbHandle, t_string, sizeof (t_string), 
                        "UPDATE "TABLE_FAMILY" SET fHouse = -1 WHERE fID = %i LIMIT 1", (F_IDX + 2)
                    ); 
                    mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS; 
                }
            } 
			strmid(FamilyHouse[i][fhOwner],"None", 0, strlen("None"), MAX_PLAYER_NAME); 
            if (FamilyHouse[i][fhUpdate][0]) { 
                DestroyDynamicPickup(FamilyHouse[i][fhUpdatePickup]); 
            } 
            if (FamilyHouse[i][fhUpdate][1]) {
                DestroyDynamicActor(FamilyHouse[i][fhUpdateActor]); 
            }
            if (FamilyHouse[i][fhUpdate][2]) {
                DestroyDynamicObject(FamilyHouse[i][fhUpdateTrigger]); 
            }
            FamilyHouse[i][fhUpdate][0] =
            FamilyHouse[i][fhUpdate][1] =
            FamilyHouse[i][fhUpdate][2] =
            FamilyHouse[i][fhUpdate][3] =
            FamilyHouse[i][fhUpdate][4] = 0;
            FamilyHouse[i][fhStore][0] =
            FamilyHouse[i][fhStore][1] =
            FamilyHouse[i][fhStore][2] =
            FamilyHouse[i][fhStore][3] =
            FamilyHouse[i][fhStore][4] = 0;
            FamilyHouse[i][fhStoreLevel] = 0;
            FamilyHouse[i][fhLock] = 0;  
            SaveFamilyHouse(i, "hOwner = 'None', hLock = '0', hUpdate = '0|0|0|0|0', hStore = '0|0|0|0|0', hStoreLevel = '0'"); 


            FamilyHouse[i][fhLandTax] = 0;
            UpdateFamilyHouse(i); 
		}
		else {
            if (FamilyHouse[i][fhBikers] != 0) {
                FractionInfo[ FamilyHouse[i][fhBikers] ][fMoney] += 500;
                //GiveFractionRepute(FamilyHouse[i][fhBikers], 2);
                UpdateFractionStore(FractionInfo[FamilyHouse[i][fhBikers]][fID]);
                SaveFractionInfoID(FractionInfo[FamilyHouse[i][fhBikers]][fID], false);
            }
			FamilyHouse[i][fhLandTax] -= GetFamilyHouseRent;
            format(t_string, sizeof t_string, "hLandTax = '%d'", FamilyHouse[i][fhLandTax]);
            SaveFamilyHouse(i, t_string), t_string[0] = EOS;
			SetMoveCashServer(IN_NALOG_SERVER, GetFamilyHouseRent); 
		} 
	}
	return 1;
} 
stock setPlayerFamilyColor(playerid) {
	t_string[0] = EOS;
	new 
		string_[128],
		family_id = pInfo[playerid][pFamily] - 1;
	format(string_, sizeof string_, "Текущий цвет: {%s}[||||||||||||||||||]\n", family_chat_color[ FamilyInfo[family_id][fChatColor] ]);
	strcat(t_string, string_);
	for(new i = 0, str_[64]; i < 21/*sizeof family_chat_color[]*/; i++) {
		format(str_, sizeof str_, "[%d] {%s}[||||||||||||||||||]\n", i, family_chat_color[i]);
		strcat(t_string, str_);
	}
	ShowPlayerDialog(playerid, D_FAMILY_FUNC_13, DIALOG_STYLE_LIST, ""colserver"Настройки: "colwhi"Цвета", t_string, "Выбрать","Отмена");
}

stock Invite_Family(playerid, family_id)  
{
    if (family_id == 0 || family_id > FAMILY_COUNT-1) return 0;

    if (!Iter_Contains(PlayerInFamily[family_id], playerid)) {
		Iter_Add(PlayerInFamily[family_id], playerid);
	}
    if (pTemp[playerid][FamilyText] != Text3D:-1) {
        DestroyDynamic3DTextLabel(pTemp[playerid][FamilyText]);
        pTemp[playerid][FamilyText] = Text3D:-1;
    } 
    new
        label_[128];
    if (FamilyInfo[ family_id - 1 ][fPrefix] != 0) {
        format(label_, sizeof label_, "[%s] {%s}%s "colwhi"%s",
            family_label_prefix[ FamilyInfo[ family_id - 1 ][fPrefix] ],
            family_chat_color[ FamilyInfo[ family_id - 1 ][fChatColor] ],
            FamilyInfo[ family_id - 1 ] [fName],
            family_label_type[ FamilyInfo[ family_id - 1 ][fType] ]);
    } else {
        format(label_, sizeof label_, "{%s}%s "colwhi"%s",
            family_chat_color[ FamilyInfo[ family_id - 1 ][fChatColor] ],
            FamilyInfo[ family_id - 1 ] [fName],
            family_label_type[ FamilyInfo[ family_id - 1 ][fType] ]);
    }
    
    
    pTemp[playerid][FamilyText] = CreateDynamic3DTextLabel(label_, -1, 0.0, 0.0, 0.5, 12.0, playerid, INVALID_VEHICLE_ID, 1), label_[0] = EOS;
    // Load Vehicles Family
    if (Iter_Count(PlayerInFamily[family_id]) == 1) {
        if (FamilyInfo[ family_id - 1 ][fDefHouse] != -1) {
            mysql_format(dbHandle, label_, sizeof label_, "SELECT * FROM `s_vehicle_family` WHERE `vFamily` = '%d' LIMIT 5", FamilyInfo[  family_id - 1 ][fID]);
            mysql_tquery(dbHandle, label_, "OnLoadFamilyCarData", "ii", family_id, 1), label_[0] = EOS;
        }
    } 
    return 1;
}


stock Leave_Family(playerid, family_id)  
{
    if (family_id == 0 || family_id > FAMILY_COUNT -1 ) return 0;
	if (Iter_Contains(PlayerInFamily[family_id], playerid)) {
        Iter_Remove(PlayerInFamily[family_id], playerid);
    }
    if (pTemp[playerid][FamilyText] != Text3D:-1) {
        DestroyDynamic3DTextLabel(pTemp[playerid][FamilyText]);
        pTemp[playerid][FamilyText] = Text3D:-1;
    }  
    if (Iter_Count(PlayerInFamily[family_id]) == 0 && Iter_Count(FamilyListVehicle[family_id]) != 0) {
        foreach(new V_IDX: FamilyListVehicle[family_id]) {
            _DestroyVehicle(V_IDX); 
        }
        Iter_Clear(FamilyListVehicle[family_id]);
    } 
    return 1;
}
stock ClearFamilyVehicle(family_id) {
    if (Iter_Count(FamilyListVehicle[family_id]) != 0) {
        foreach(new V_IDX: FamilyListVehicle[family_id]) {
            _DestroyVehicle(V_IDX); 
        }
        Iter_Clear(FamilyListVehicle[family_id]);
    } 
    return 1;
} 
stock GetFamilyDefaultHouse(playerid) {
    return FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fDefHouse];
}
stock ShowPlayerSelectFamilyCar(playerid, family_id)
{ 
    if (Iter_Count(FamilyListVehicle[family_id]) == 0) {
        SendClientMessage(playerid, COLOR_GREY, !"У Вашей семьи нет транспорта");
        return 1;
    }
    t_string = ""colserver"Слот\t"colserver"Автомобиль\t"colserver"Позиция\t"colserver"Доступ\n";
    new 
        string_[144],
        count_vehicle = 0; 
	foreach(new V_IDX: FamilyListVehicle[family_id]) 
    {
        if (!IsValidVehicle(V_IDX)) continue;
        count_vehicle++;
        format(string_, sizeof string_,"[%d]\t%s\t%s\t%d(%s)\n",
            count_vehicle,
            VehicleNames[ VehicleInfo[ V_IDX - 1 ][vModel] - 400 ], 
            IsVehicleOccupied(V_IDX) != -1 ? ("Используется") : ("Не используется"),
            VehicleInfo[ V_IDX - 1 ][vRank],
            fFamilyRank[ family_id - 1 ][ VehicleInfo[ V_IDX - 1 ][vRank] - 1 ] 
        );
        strcat(t_string, string_);
    }
    ShowPlayerDialog(playerid, D_FAMILY_FUNC_43, DIALOG_STYLE_TABLIST_HEADERS, !""colserver"Семья: "colwhi"Автопарк", t_string, !"Выбрать", !"Назад"), t_string[0] = EOS;
    return 1;
}

stock ChangeVehicleFamily(playerid, family_id) {
	t_string = ""colserver"Слот\t"colserver"Автомобиль\t"colserver"Позиция\n";
    new 
        string_[144],
        count_vehicle = 0; 
	foreach(new V_IDX: FamilyListVehicle[family_id]) 
    {
        if (!IsValidVehicle(V_IDX)) continue;
        count_vehicle++;
        format(string_, sizeof string_,"[%d]\t%s\t%s\t%d(%s)\n",
            count_vehicle,
            VehicleNames[ VehicleInfo[ V_IDX - 1 ][vModel] - 400 ], 
            IsVehicleOccupied(V_IDX) != -1 ? ("Используется") : ("Не Используется")
        );
        strcat(t_string, string_);
    }
    ShowPlayerDialog(playerid, D_AUTOSHOP_SHOW_4, DIALOG_STYLE_TABLIST_HEADERS, !""colserver"Автосалон: "colwhi"Замена ТС", t_string, !"Выбрать", !"Назад"), t_string[0] = EOS;
	return 1;
}

stock CheckVehicleRevision(playerid, vehicleid)
{
	if (VehicleInfo[ vehicleid - 1 ][vFraction] == pInfo[playerid][pID]  && VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_PLAYER) return 1;
	else if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_FAMILY &&  pInfo[playerid][pFamily] > 0 && FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][3] == pInfo[playerid][pFamilyRank]) return 1;
	return 0;
}
stock ShowStatsFamily(playerid) {
    new
        count_family = 0,
        nationality_string[28],
        family_id = pInfo[playerid][pFamily] - 1;
    foreach(new i: PlayerInLogin)
    {
        if (pInfo[i][pFamily] != pInfo[playerid][pFamily]) continue;
        count_family ++;
    } 
    switch(FamilyInfo[family_id][fNationality])
    {
        case 1: nationality_string = "Американцы";
        case 2: nationality_string = "Японцы";
        case 3: nationality_string = "Итальянцы";
        case 4: nationality_string = "Мексиканцы";
        case 5: nationality_string = "Латиноамериканцы";
        case 6: nationality_string = "Испанцы";
        case 7: nationality_string = "Русские";
        case 8: nationality_string = "Португальцы";
        case 9: nationality_string = "Французы";
        default:nationality_string = "Неизвестно";
    }
    t_string[0] = EOS;
    new str_[128];
    format(str_, sizeof str_,""colwhi"Семья:\t\t\t\t\t{%s}%s\n"colwhi"Создатель семьи:\t\t\t{%s}%s\n\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fName],
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fOwner]
    );
    strcat(t_string, str_);
    new
        countFamily = GetFamileMembersCount(playerid),
        Float: countRating = GetFamilyRatingCount(playerid),
        Float: membersRating = (countFamily * 30.0),
        Float: commonFamilyRating = (countRating + membersRating),
        Float: middleRating = (commonFamilyRating / countFamily) 
    ;
    format(str_, sizeof str_, ""colwhi"Общий рейтинг:\t\t\t{%s}%.2f\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], middleRating
    );
    strcat(t_string, str_); 
    format(str_, sizeof str_,""colwhi"Национальность:\t\t\t{%s}%s\n"colwhi"Тип семьи:\t\t\t\t{%s}%s\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], nationality_string,
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], family_label_type[ FamilyInfo[family_id][fType] ]
    );
    strcat(t_string, str_);  
    format(str_, sizeof str_,""colwhi"Банк семьи:\t\t\t\t%s\n"colwhi"Баланс банка семьи:\t\t\t"collime"$%s\n",
        (FamilyInfo[family_id][fBankLock] == 0) ? ("{87EB7F}[Открыт]") : ("{FF5E5E}[Закрыт]"), convert_money(FamilyInfo[family_id][fBank])
    );
    strcat(t_string, str_);  
    format(str_, sizeof str_,""colwhi"Пороговый рейтинг:\t\t\t{%s}%d.00\n"colwhi"Пороговый уровень:\t\t\t{%s}%d\n\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fLimitRating],
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fLimitLevel]
    );
    strcat(t_string, str_);
 
    if (FamilyInfo[family_id][fHouse] != -1) {
        format(str_, sizeof str_, ""colwhi"Семейный особняк:\t\t\t№{%s}%d %s\n",
            family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyHouse[ FamilyInfo[family_id][fHouse] ][fhID], (FamilyHouse[ FamilyInfo[family_id][fHouse] ][fhLock] == 0) ? ("{87EB7F}[Открыт]") : ("{FF5E5E}[Закрыт]")
        );//
        strcat(t_string, str_);
    }
    if (FamilyInfo[family_id][fDefHouse] != -1) {
        new house_class_name[MAX_HOUSE_CLASS_NAME + 1];

        GetHouseClassName(FamilyInfo[family_id][fDefHouse], house_class_name);
        format(str_, sizeof str_, ""colwhi"Семейный дом:\t\t\t№{%s}%d %s\n"colwhi"Класс: %s\n"colwhi"Сейф семьи:\t\t\t\t%s\n\n",
            family_chat_color[ FamilyInfo[family_id][fChatColor] ], HouseInfo[ FamilyInfo[family_id][fDefHouse] ][hID], (HouseInfo[ FamilyInfo[family_id][fDefHouse] ][hLock] == 0) ? ("{87EB7F}[Открыт]") : ("{FF5E5E}[Закрыт]"), 
            house_class_name, (FamilyInfo[family_id][fSafeLock] == 0) ? ("{87EB7F}[Открыт]") : ("{FF5E5E}[Закрыт]")
        );//
        strcat(t_string, str_);
    }
    format(str_, sizeof str_, ""colwhi"Прием в семью возможен с:\t\t{%s}%s\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], fFamilyRank[family_id][FamilyInfo[family_id][fSettings][0] - 1 ]
    );
    strcat(t_string, str_);
    format(str_, sizeof str_, ""colwhi"Назначение в семье возможно с:\t{%s}%s\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], fFamilyRank[family_id][FamilyInfo[family_id][fSettings][2] - 1 ]
    );
    strcat(t_string, str_);
    format(str_, sizeof str_, ""colwhi"Увольнение из семьи возможно с:\t{%s}%s\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], fFamilyRank[family_id][FamilyInfo[family_id][fSettings][1] - 1 ]
    );
    strcat(t_string, str_);
    format(str_, sizeof str_, ""colwhi"Открытие банка семьи возможно с:\t{%s}%s\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], fFamilyRank[family_id][FamilyInfo[family_id][fSettings][4] - 1 ]
    );
    strcat(t_string, str_);
    if (FamilyInfo[family_id][fHouse] != -1 && FamilyInfo[family_id][fDefHouse] != -1 ) {
        format(str_, sizeof str_, ""colwhi"Открытие сейфа семьи возможно с:\t{%s}%s\n",
            family_chat_color[ FamilyInfo[family_id][fChatColor] ], fFamilyRank[family_id][FamilyInfo[family_id][fSettings][5] - 1 ]
        );
        strcat(t_string, str_);
    }
    strcat(t_string, ""colwhi"\n");
    format(str_, sizeof str_, ""colwhi"Онлайн:\t\t\t\t{%s}%d\n",  
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], count_family
    );
    strcat(t_string, str_);
    format(str_, sizeof str_, ""colwhi"Всего участников:\t\t\t{%s}%d\n\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], countFamily
    );
    strcat(t_string, str_);
    if (Family:GetFamilyData(family_id, fPromoID) != -1) {
        format(str_, sizeof str_, ""colwhi"Промокод семьи:\t\t\t{%s}%s\n\n",
            family_chat_color[ FamilyInfo[family_id][fChatColor] ], PromoCode:getPlayerPromoName(Family:GetFamilyData(family_id, fPromoID))
        );
        strcat(t_string, str_);
    }
    
    format(str_, sizeof str_, ""colwhi"Репутация:\t\t{%s}%d\n{ffd700}Family Coins:\t\t{%s}%d\n",
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fRepute],
        family_chat_color[ FamilyInfo[family_id][fChatColor] ], FamilyInfo[family_id][fCoins]
    );
    strcat(t_string, str_);
    

    ShowPlayerDialog(playerid, D_FAMILY_FUNC_2, DIALOG_STYLE_MSGBOX, ""colserver"Информация: "colwhi"Семьи", t_string, "Назад", "Закрыть"), t_string[0] = EOS;
}
/*
FamilyInfo[S_FAMILY_COUNT][fSettings][0] = 3; /faminvite 
FamilyInfo[S_FAMILY_COUNT][fSettings][1] = 3; /famuninvite
FamilyInfo[S_FAMILY_COUNT][fSettings][2] = 3; //famrank
FamilyInfo[S_FAMILY_COUNT][fSettings][3] = 3; //count rank 
FamilyInfo[S_FAMILY_COUNT][fSettings][4] = 3; //Open/Closed Bank
FamilyInfo[S_FAMILY_COUNT][fSettings][5] = 3; //Open/Closed Safe*/

/*

cache_get_value_name_int(F_IDX, "fBank", FamilyInfo[F_IDX][fBank]);
        cache_get_value_name_int(F_IDX, "fBankLock", FamilyInfo[F_IDX][fBankLock]);
        cache_get_value_name_int(F_IDX, "fSafeLock", FamilyInfo[F_IDX][fSafeLock]);
        cache_get_value_name_int(F_IDX, "fLimitLevel", FamilyInfo[F_IDX][fLimitLevel]);
        cache_get_value_name_int(F_IDX, "fLimitRating", FamilyInfo[F_IDX][fLimitRating]);
ALTER TABLE `s_family` ADD `fBank` INT(11) NOT NULL DEFAULT '0' AFTER `fDate`, ADD `fBankLock` INT(11) NOT NULL DEFAULT '0' AFTER `fBank`, ADD `fSafeLock` INT(11) NOT NULL DEFAULT '0' AFTER `fBankLock`, ADD `fLimitLevel` INT(11) NOT NULL DEFAULT '3' AFTER `fSafeLock`, ADD `fLimitRating` INT(11) NOT NULL DEFAULT '100' AFTER `fLimitLevel`;
FamilyInfo[S_FAMILY_COUNT][fSettings][0] = 3; /faminvite 
FamilyInfo[S_FAMILY_COUNT][fSettings][1] = 3; /famuninvite
FamilyInfo[S_FAMILY_COUNT][fSettings][2] = 3; //famrank
FamilyInfo[S_FAMILY_COUNT][fSettings][3] = 3; //count rank 
FamilyInfo[S_FAMILY_COUNT][fSettings][4] = 3; //Open/Closed Bank
FamilyInfo[S_FAMILY_COUNT][fSettings][5] = 3; //Open/Closed Safe
*/


CMD:fam(playerid)
{
	if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
	ShowFamilyPanel(playerid);
	return 1;
}
stock ShowFamilyPanel(playerid)
{
	new
		str_[64],
		family_id = pInfo[playerid][pFamily];
	format(str_, sizeof str_, 
		""colserver"Семья: {%s} %s", 
		family_chat_color[ FamilyInfo[ family_id - 1 ][fChatColor] ], FamilyInfo[ family_id - 1 ][fName]
	);
	format(t_string, sizeof t_string, 
		""colwhi"[0] Статистика семьи\t \n[1] Члены семьи\t["col_li_red"OFFLINE"colwhi"]\n[2] Члены семьи\t["collime"ONLINE"colwhi"]\n\
		[3] Настройки семьи\t \n[4] Семейный особняк\t[%s"colwhi"]\n[5] Семейный дом\t[%s"colwhi"]\n\
        [6] "col_li_red"Покинуть семью\n"colwhi"[7] "col_li_red"Передать семью\n[-] Помощь", 
        (FamilyInfo[ family_id - 1 ][fHouse] == -1)?(""colwarn"Не Имеется"):(""collime"Имеется"), (FamilyInfo[ family_id - 1 ][fDefHouse] == -1)?(""colwarn"Не Имеется"):(""collime"Имеется")
	);
	ShowPlayerDialog(playerid, D_FAMILY_FUNC_0, DIALOG_STYLE_TABLIST, str_, t_string, "Выбрать", "Закрыть");
	return 1 ;
} 
stock ShowPlayerFamilySetting(playerid)
{
	new
		family_id = pInfo[playerid][pFamily] - 1,
		prefics[12],
		nationality_string[28];
    switch(FamilyInfo[family_id][fNationality])
	{
		case 1: nationality_string = "Американцы";
		case 2: nationality_string = "Японцы";
		case 3: nationality_string = "Итальянцы";
		case 4: nationality_string = "Мексиканцы";
		case 5: nationality_string = "Латиноамериканцы";
		case 6: nationality_string = "Испанцы";
		case 7: nationality_string = "Русские";
		case 8: nationality_string = "Португальцы";
		case 9: nationality_string = "Французы";
		default: nationality_string = "Неизвестно";
	}
	if (FamilyInfo[family_id][fPrefix] == 0) prefics = "Отсутствует";
	else format(prefics, sizeof prefics, "%s", family_label_prefix[ FamilyInfo[family_id][fPrefix] ]);
    t_string[0] = EOS;
	format(t_string, sizeof t_string, ""colserver"Наименование\t"colserver"Статус\n\
		[0] Прием в семью\t[%s]\n\
		[1] Исключение из семьи\t[%s]\n\
		[2] Изменение ранга\t[%s]\n\
        [3] Открыть/Закрыть банк\t[%s]\n\
        [4] Открыть/Закрыть сейф\t[%s]\n\
		[5] Количество рангов\t[%d]\n\
		[6] Название рангов\t[Изменить]\n\
        [7] Пороговый рейтинг\t[%d.00]\n\
        [8] Пороговый уровень\t[%d]\n\
		[9] Национальность семьи\t[%s]\n\
		[10] Цвет семьи\t[{%s}||||||"colwhi"]\n\
		[11] Префикс семьи\t[%s]\n\
		[12] Тип семьи\t[%s]\n", 
	fFamilyRank[family_id][FamilyInfo[family_id][fSettings][0] - 1 ],//invite
	fFamilyRank[family_id][FamilyInfo[family_id][fSettings][1] - 1 ],//uninvite
	fFamilyRank[family_id][FamilyInfo[family_id][fSettings][2] - 1 ],//famrank
    fFamilyRank[family_id][FamilyInfo[family_id][fSettings][4] - 1 ],//fbanklock
    fFamilyRank[family_id][FamilyInfo[family_id][fSettings][5] - 1 ],//fsafelock
	FamilyInfo[family_id][fSettings][3], 
    FamilyInfo[family_id][fLimitRating],
    FamilyInfo[family_id][fLimitLevel],
    nationality_string,
	family_chat_color[ FamilyInfo[family_id][fChatColor] ],
	prefics,
	family_label_type[ FamilyInfo[family_id][fType] ]);
	ShowPlayerDialog(playerid, D_FAMILY_FUNC_4, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Настройки: "colwhi"Семьи", t_string, "Выбрать", "Назад");
	return 1;
} 
CMD:fbanklock(playerid)
{
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    new
        F_IDX = pInfo[playerid][pFamily] - 1,
        string_[128]; 
    if (pInfo[playerid][pFamilyRank] < FamilyInfo[ F_IDX ][fSettings][4]) {
        format(string_, sizeof string_, "Данная команда доступна с %i ранга", FamilyInfo[ F_IDX ][fSettings][4]);
        SendClientMessage(playerid, COLOR_GREY, string_);
        return 1;
    }   
    if (FamilyInfo[F_IDX][fBankLock] == 0) FamilyInfo[F_IDX][fBankLock] = 1;
    else FamilyInfo[F_IDX][fBankLock] = 0;  
    format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: %s банк семьи!",
        family_chat_color[ FamilyInfo[ F_IDX ][fChatColor] ], FamilyInfo[ F_IDX ][fName], fFamilyRank[ F_IDX ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], FamilyInfo[F_IDX][fBankLock] ? ("Закрыл") : ("Открыл")
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
    format(t_string, sizeof t_string, "fBankLock = %d", FamilyInfo[F_IDX][fBankLock]);
    SaveFamily(playerid, t_string), t_string[0] = EOS;
	return 1;
}
CMD:fsafelock(playerid)
{
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    new
        F_IDX = pInfo[playerid][pFamily] - 1,
        string_[128]; 
	if (pInfo[playerid][pFamilyRank] < FamilyInfo[ F_IDX ][fSettings][5]) {
        format(string_, sizeof string_, "Данная команда доступна с %i ранга", FamilyInfo[ F_IDX ][fSettings][4]);
        SendClientMessage(playerid, COLOR_GREY, string_);
        return 1;
    }
    if (FamilyInfo[ F_IDX ][fDefHouse] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вашей семьи нет семейного дома"); 
    if (FamilyInfo[F_IDX][fSafeLock] == 0) FamilyInfo[F_IDX][fSafeLock] = 1;
    else FamilyInfo[F_IDX][fSafeLock] = 0;  
    format(string_, sizeof string_,"{%s}[%s]"colwhi" %s %s: %s сейф семьи!",
        family_chat_color[ FamilyInfo[ F_IDX ][fChatColor] ], FamilyInfo[ F_IDX ][fName],
        fFamilyRank[ F_IDX ][ pInfo[playerid][pFamilyRank] - 1 ], pInfo[playerid][pName], FamilyInfo[F_IDX][fSafeLock] ? ("Закрыл") : ("Открыл")
    ); 
    SendPlayerFamilyMessage(pInfo[playerid][pFamily], COLOR_WHITE, string_);
    format(t_string, sizeof t_string, "fSafeLock = %d", FamilyInfo[F_IDX][fSafeLock]);
    SaveFamily(playerid, t_string), t_string[0] = EOS;
	return 1;
}
CMD:fambank(playerid) {
    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье"); 
    new
        F_IDX = pInfo[playerid][pFamily] -1,
        string_[128],
        str_Title[64];
    format(string_, sizeof string_, ""colwhi"[0] Положить деньги\n[1] Снять деньги\n[2] Баланс: "collime"$%d "colwhi"", 
        FamilyInfo[F_IDX][fBank]
    ); 
    format(str_Title, sizeof str_Title, ""colserver"Банк семьи: {%s}%s", family_chat_color[ FamilyInfo[F_IDX][fChatColor] ], FamilyInfo[F_IDX][fName]);
	ShowPlayerDialog(playerid, D_FAMILY_FUNC_47, DIALOG_STYLE_LIST, str_Title, string_, "Выбрать", "Закрыть");
	return 1;
}

publics: GetFamilyOffMembers(playerid)
{
	new
		rows, 
		string_[128];
	cache_get_row_count(rows);
	if (rows) {
	    SendClientMessage(playerid, 0x059BD3FF, !"Список игроков: [Ник] [Ранг] [Последний вход] [Рейтинг]");
	    for(new i, get_rank, get_date[32], get_name[MAX_PLAYER_NAME], Float:p_Rating = 0.00; i < rows; i++) {
		    cache_get_value_name(i, "Name", get_name);
		 	cache_get_value_name_int(i, "pFamilyRank", get_rank);
            cache_get_value_name_float(i, "pRating", p_Rating);
			cache_get_value_name(i, "pGetonDate", get_date);
			format(string_, sizeof string_, "[%s] [%d] [%s] [%.2f]",get_name, get_rank, get_date, p_Rating);
			SendClientMessage(playerid, 0x059BD3FF, string_);
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, !"Все члены семьи в сети!");
	return 1;
}   
publics: off_family_members_callback(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) {
		SendClientMessage(playerid, COLOR_GREY, !"Участники семьи не найдены") ; 
		DeletePVar ( playerid, "ofm_list_page" ) ;
		return 1 ;
	}
	new 
        rows_list = GetPVarInt(playerid, "ofm_list_page") - 1;
	SetPVarInt(playerid, "ofm_list_rows", rows);

	new string_[128],
		pl_ofm_name[MAX_PLAYER_NAME],
		pl_ofm_rank,
		pl_ofm_online [ 16 ],
        pl_f_id;

	t_string[0] = EOS;
	strcat(t_string, ""colserver"<< Предыдущая страница\t \t \n"colserver">> Следующая страница\t \t \n");
	for(new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++)
	{
		if ( i >= rows ) break ;
		cache_get_value_name(i, "Name", pl_ofm_name);
        cache_get_value_name_int(i, "pFamily", pl_f_id);
		cache_get_value_name_int(i, "pFamilyRank", pl_ofm_rank);
		cache_get_value_name(i, "pGetonDate", pl_ofm_online);

		new pvar_string [ 8 ] ;
		format(pvar_string, sizeof ( pvar_string ), "ofm_%d", i - rows_list * 10 ) ;
		SetPVarString ( playerid, pvar_string, pl_ofm_name ) ;

		format(string_, sizeof string_, "%s"colserver"\t%s(%d){ffffff}\t%s\n",
            pl_ofm_name,
            fFamilyRank[ pl_f_id - 1 ][ pl_ofm_rank - 1 ], pl_ofm_rank,
            pl_ofm_online 
        );
		strcat(t_string, string_);
	}
	ShowPlayerDialog(playerid, D_FAMILY_FUNC_1, DIALOG_STYLE_TABLIST, ""colserver"Участники: "colwhi"Семьи OFFLINE", t_string, "Выбрать", "Назад" ) ;
	return 1 ;
}
publics: GetPlayerFamilyInfo(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if (rows) {
		new g_Family, pl_rank, last_date[16]; 
        cache_get_value_name_int(0, "pFamily", g_Family);
		cache_get_value_name_int(0, "pFamilyRank", pl_rank);
		cache_get_value_name(0, "pGetonDate", last_date);
		new 
            pvar_string[20], 
            pl_name[MAX_PLAYER_NAME] ;

		format(pvar_string, sizeof pvar_string, "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ));
		GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME) ; 
		new dialog_string [ 186 ] ;
		format(dialog_string, sizeof dialog_string, ""colwhi"Имя: %s\nРанг:%s [%d]\nПоследний вход: %s",
            pl_name,
            fFamilyRank[ g_Family - 1 ][ pl_rank - 1 ], pl_rank, 
            last_date
        );
		ShowPlayerDialog(playerid, D_FAMILY_FUNC_54, DIALOG_STYLE_MSGBOX, ""colserver"Информация об игроке", dialog_string, "Назад", "" );
	}
	if (!rows) {
		new query_[128];
		DeletePVar(playerid, "ofm_listitem");
		mysql_format(dbHandle, query_, sizeof query_, "SELECT `Name`,`pFamily`,`pFamilyRank`,`pGetonDate` FROM `s_users` WHERE `pFamily` = '%d' AND `pLogin` = '0'", pInfo[playerid][pFamily]);
        mysql_tquery(dbHandle, query_, "off_family_members_callback", "i", playerid);
	}
	return 1 ;
} 
stock ShowPlayerFamilyMembers(playerid, bool: cmd = false) {
    t_string[0] = EOS;
    new
        string_[128],
        number_logged = 0;
    strcat(t_string, ""colserver"[№] Никнейм\t"colserver"Должность\t"colserver"Рейтинг\n");
    foreach(new i: PlayerInLogin) {
        if (pInfo[i][pFamily] == pInfo[playerid][pFamily]) {
            number_logged ++ ;
            format(string_, sizeof string_, "[%d] %s\t%s(%d)\t%.2f\n",
                number_logged, pInfo[i][pName], fFamilyRank[ pInfo[i][pFamily] - 1 ] [ pInfo[i][pFamilyRank] - 1 ], pInfo[i][pFamilyRank], pInfo[i][pRating]
            );
            strcat(t_string, string_);
        }
        if (!cmd) {
            ShowPlayerDialog(playerid, D_FAMILY_FUNC_3, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Члены: "colwhi"Семьи [ONLINE]", t_string, "Назад", "Закрыть");
        } else {
            ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Члены: "colwhi"Семьи [ONLINE]", t_string, "Закрыть", "");
        }
    }
    return 1;
}
CMD:fmembers(playerid) {
    if (pInfo[playerid][pFamily] == 0) return SendClientMessage(playerid, COLOR_GRAD1, !"Вам недоступна эта функция!"); 
    ShowPlayerFamilyMembers(playerid, .cmd = true);
    return 1;
}     
stock GetPlayerCountClothes(playerid) {
    new 
        free_slot = 0;
    for(new j = 0; j < 11 ; j ++) {
        if (pInfo[playerid][pChar][j] == 0) {
            free_slot++;
        } 
    } 
    return free_slot;
}
stock GetPlayerSlotClothes(playerid) {
    new 
        free_slot = -1;
    for(new j = 0; j < 11 ; j ++) {
        if (pInfo[playerid][pChar][j] != 0 && free_slot == -1) continue; 
        free_slot = j;
        break; 
    } 
    return free_slot;
} 
CMD:fampark(playerid)
{ 
	if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
    if (pInfo[playerid][pFamilyRank] < FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fSettings][0]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не уполномочены парковать семейный ТС");
	for(new j = 0 ; j < MAX_NONPARKING_ZONES ; j ++) {
		if (IsPlayerInDynamicArea(playerid, non_parking_area[j])) return SendClientMessage(playerid, -1, !"Здесь запрещена парковка");
	}
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине!");

	new V_IDX = GetPlayerVehicleID(playerid);
	if (IsValidVehicle(V_IDX))
	{//VehicleInfo[ veh_id - 1 ][vType] == VEHICLE_TYPE_FAMILY && VehicleInfo[ veh_id - 1 ][vFraction] ==  pInfo[playerid][pFamily]
		if (VehicleInfo[ V_IDX - 1 ][vFraction] != pInfo[playerid][pFamily] || VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_FAMILY) {
			SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в семейном транспорте!");
			return 1;
		}
		new 
			Float:vehicle_health;
		GetVehicleHealth(V_IDX, vehicle_health);
		if (vehicle_health < 500) return SendClientMessage(playerid, COLOR_WHITE, !"Для начала нужно починить транспортное средство"); 
		//new time = GetTickCount();
		for(new j = GetVehiclePoolSize() + 1; --j != 0;) {
			if (!IsValidVehicle(j)) continue;
			if (VehicleInfo[ j - 1 ][vWorld] == GetPlayerVirtualWorld(playerid)
				&& IsPlayerInRangeOfPoint(playerid, 3.0, VehicleInfo[ j - 1 ][vPos][0], VehicleInfo[ j - 1 ][vPos][1], VehicleInfo[ j - 1 ][vPos][2]))
			{ 
				SendClientMessage(playerid, COLOR_WHITE, !"Невозможно припарковать транспорт вбилизи парковки другого транспортного средства");
				return 1 ;
			}
		} 
		GetVehiclePos(V_IDX, VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2]);
		GetVehicleZAngle(V_IDX, VehicleInfo[ V_IDX - 1 ][vPos][3]);

		new new_veh_id = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 ) ;
		new	
			family_id = pInfo[playerid][pFamily];
		Iter_Add(FamilyListVehicle[family_id], new_veh_id);
		VehicleInfo[ new_veh_id - 1 ][vType] = VEHICLE_TYPE_FAMILY ;
		VehicleInfo[ new_veh_id - 1 ][vID] = VehicleInfo[ V_IDX - 1 ][vID];
		VehicleInfo[ new_veh_id - 1 ][vPos][0] = VehicleInfo[ V_IDX - 1 ][vPos][0];
		VehicleInfo[ new_veh_id - 1 ][vPos][1] = VehicleInfo[ V_IDX - 1 ][vPos][1];
		VehicleInfo[ new_veh_id - 1 ][vPos][2] = VehicleInfo[ V_IDX - 1 ][vPos][2];
		VehicleInfo[ new_veh_id - 1 ][vPos][3] = VehicleInfo[ V_IDX - 1 ][vPos][3];

		VehicleInfo[ new_veh_id - 1 ][vFraction] = VehicleInfo[ V_IDX - 1 ][vFraction];
		VehicleInfo[ new_veh_id - 1 ][vRank] = VehicleInfo[ V_IDX - 1 ][vRank];
		VehicleInfo[ new_veh_id - 1 ][vColor][0] = VehicleInfo[ V_IDX - 1 ][vColor][0];
		VehicleInfo[ new_veh_id - 1 ][vColor][1] = VehicleInfo[ V_IDX - 1 ][vColor][1];

		VehicleInfo[ new_veh_id - 1 ][vPaint] = VehicleInfo[ V_IDX - 1 ][vPaint];
		if ( VehicleInfo[ new_veh_id - 1 ][vPaint] != 3) {
			ChangeVehiclePaintjob(new_veh_id, VehicleInfo[ new_veh_id - 1 ][vPaint]);
		}

		VehicleInfo[ new_veh_id - 1 ][vLocked] = VehicleInfo[ V_IDX - 1 ][vLocked];

		VehicleInfo[ new_veh_id - 1 ][vNumber] = VehicleInfo[ V_IDX - 1 ][vNumber] ;
		format(VehicleInfo[ new_veh_id - 1 ] [vNumber], 12, "%s", VehicleInfo[ V_IDX - 1 ] [vNumber]);

		VehicleInfo[ new_veh_id - 1 ][vFuel] = VehicleInfo[ V_IDX - 1 ][vFuel];
		VehicleInfo[ new_veh_id - 1 ][vMillage] = VehicleInfo[ V_IDX - 1 ][vMillage]; 

		VehicleInfo[ new_veh_id - 1 ][vVehicle] = new_veh_id ;

		for(new i = 0; i < 5 ; i ++ ) {
			VehicleInfo[ new_veh_id - 1 ][vPT_Engine][i] = VehicleInfo[ V_IDX - 1 ][vPT_Engine][i]; 
		}  
		_SetVehicleHealth(new_veh_id, vehicleCountArmour[VehicleInfo[ new_veh_id - 1 ][vPT_Engine][1]]);

		VehicleInfo[ new_veh_id - 1 ][vWorld] = GetPlayerVirtualWorld(playerid);
		VehicleInfo[ new_veh_id - 1 ][vInt] = GetPlayerInterior(playerid);
		if (VehicleInfo[ new_veh_id - 1 ][vInt] != 0 ) LinkVehicleToInterior(new_veh_id, VehicleInfo[ new_veh_id - 1 ][vInt]);
		if (VehicleInfo[ new_veh_id - 1 ][vWorld] != 0 ) SetVehicleVirtualWorld(new_veh_id, VehicleInfo[ new_veh_id - 1 ][vWorld]);

		for ( new j = 0; j < 10; j ++ )
		{
			VehicleInfo[ new_veh_id - 1 ][vComponent][j] = VehicleInfo[ V_IDX - 1 ][vComponent][j];
			AddVehicleComponent(VehicleInfo[ new_veh_id - 1 ] [vVehicle ], VehicleInfo[ new_veh_id - 1 ][vComponent][j]);
		}

		SetVehicleNumberPlate(new_veh_id, VehicleInfo[ new_veh_id - 1 ] [vNumber]);

		VehicleInfo[ new_veh_id - 1 ][vMoney] = VehicleInfo[ V_IDX - 1 ][vMoney];
		VehicleInfo[ new_veh_id - 1 ][vFillBag] = VehicleInfo[ V_IDX - 1 ][vFillBag];
		VehicleInfo[ new_veh_id - 1 ][vRepair] = VehicleInfo[ V_IDX - 1 ][vRepair];
		VehicleInfo[ new_veh_id - 1 ][vDrugs] = VehicleInfo[ V_IDX - 1 ][vDrugs];
		VehicleInfo[ new_veh_id - 1 ][vMaterials] = VehicleInfo[ V_IDX - 1 ][vMaterials];
		for(new t = 0; t < 6; t++) {
			VehicleInfo[ new_veh_id - 1 ][vBootGun][t] = VehicleInfo[ V_IDX - 1 ][vBootGun][t];
			VehicleInfo[ new_veh_id - 1 ][vBootAmmo][t] = VehicleInfo[ V_IDX - 1 ][vBootAmmo][t];
		} 



		_DestroyVehicle(V_IDX);
		Iter_Remove(FamilyListVehicle[family_id], V_IDX); 
		GetVehicleParamsEx(new_veh_id, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 );
		SetVehicleParamsEx(new_veh_id, engine1, lights2, alarm2, VehicleInfo[ new_veh_id - 1 ] [vLocked], bonnet2, boot1, objective1 );

		new query_[198];
		GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~FAMILY_CAR ~g~PARKING", 3000, 3 ) ;

		format(query_, sizeof query_, "UPDATE `s_vehicle_family` SET `vPos` = '%.2f|%.2f|%.2f|%.2f',`vWorld` = '%d',`vInt` = '%d' WHERE `vID` = '%d'",
			VehicleInfo[ new_veh_id - 1 ][vPos][0], VehicleInfo[ new_veh_id - 1 ][vPos][1], VehicleInfo[ new_veh_id - 1 ][vPos][2], VehicleInfo[ new_veh_id - 1 ][vPos][3],
			VehicleInfo[ new_veh_id - 1 ][vWorld], VehicleInfo[ new_veh_id - 1 ] [vInt],
			VehicleInfo[ new_veh_id - 1 ][vID] 
		);
		mysql_tquery(dbHandle, query_, "", "");
        UpdateVehiclevText(playerid, new_veh_id, true);
	}
	return 1 ;
}

public OnPlayerConnect(playerid)
{
    pInfo[playerid][pFamilyMute] = 0;

    #if defined Family_OnPlayerConnect
		return Family_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}


#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Family_OnPlayerConnect
#if defined Family_OnPlayerConnect
	forward Family_OnPlayerConnect(playerid);
#endif
