#define TABLE_ECONOMY		"s_others"
#define TABLE_MOVE_CASH     "s_move_cash"

#define MARKET_NDS  3 //(0 - 5)

const COST_HUNTER_LICENSESS = 5_000;
const COST_RIFLE_HUNTER = 10_000;
const SALARY_GRUZ_JOB = 600; //Зарплата на грузчиках
const SALARY_FACTORY_JOB = 450;//
const SALARY_FACTORY_BOX_JOB = 225;
const SALARY_HUNTER_JOB = 1000;
const SALARY_HUNTER_MEET_JOB = 500;
new 
    Float: MarketCurrentCommission[] = {
        0.5, 1.0, 2.5, 3.0, 4.0, 5.0////%.1f%% 
    }; 
enum E_ECONOMY_SERVER {
    ePension,
    ePensionAge,
    eMaterialsLSa[2],
    Text3D: eMaterialsLSText[2]
}
new gEconomyServer[E_ECONOMY_SERVER]; 

stock SetEconomyServer(E_ECONOMY_SERVER:type, amount, save = false) {
    gEconomyServer[type] = amount;
    if (save) { 
        format(t_string, sizeof t_string,
            "UPDATE "TABLE_ECONOMY" SET ePension = '%d', ePensionAge = '%d'", 
            gEconomyServer[ePension], gEconomyServer[ePensionAge]
        );
        mysql_tquery(dbHandle, t_string, "",""), t_string[0] = EOS;
    }
    return 1;
}
stock GetEconomyServer(E_ECONOMY_SERVER:type) {
    return gEconomyServer[type];
}
new CheckMoveCashData = 0;
enum E_MOVE_MONEY {
	IN_JOB,
	IN_SERVER,
	IN_DONATE,
	OUT_SERVER,
    OUT_COMMISSION,
    IN_NALOG_SERVER,
    IN_PENSION,
    IN_WEBSITE,
    IN_MEDIA_WEBSITE
}
new gCashServer[E_MOVE_MONEY]; 

stock MoveCash_OnGameModeInit() {
    gCashServer[IN_JOB] =
    gCashServer[IN_SERVER] =
    gCashServer[IN_DONATE] =
    gCashServer[OUT_SERVER] =
    gCashServer[OUT_COMMISSION] =
    gCashServer[IN_NALOG_SERVER] = 
    gCashServer[IN_PENSION] = 
    gCashServer[IN_WEBSITE] = 
    gCashServer[IN_MEDIA_WEBSITE] = 0;
    mysql_tquery(dbHandle, "SELECT * FROM "TABLE_ECONOMY"", "OnLoadEconomyServer", "");
    mysql_tquery(dbHandle, "SELECT * FROM "TABLE_MOVE_CASH"", "OnLoadMoveCashServer", "");    
	/*new 
        Cache:result = mysql_query(dbHandle, "SELECT * FROM `s_move_cash`"), 
        rows; 
	cache_get_row_count(rows);
    if (!rows) {
		print(!"[Загрузка ...] Данные из MoveCash Server не получены!");
		if (cache_is_valid(result)) cache_delete(result);
		return;
	}
    cache_get_value_name_int(0, "IN_JOB", gCashServer[IN_JOB]);//Рыбалка
    cache_get_value_name_int(0, "IN_SERVER", gCashServer[IN_SERVER]);
    cache_get_value_name_int(0, "IN_DONATE", gCashServer[IN_DONATE]);
    cache_get_value_name_int(0, "OUT_SERVER", gCashServer[OUT_SERVER]);
    //IN_NALOG_SERVER
    if (cache_is_valid(result)) cache_delete(result);
    printf("[Загрузка ...] Данные из MoveCash Server получены! (%i шт.)", rows);*/
} 
publics: OnLoadMoveCashServer()
{
	new rows;
	cache_get_row_count(rows);
	new
        time = GetTickCount();
    if (!rows) return print("[Загрузка ...] Данные из "#TABLE_MOVE_CASH" не получены!");

	cache_get_value_name_int(0, "IN_JOB", gCashServer[IN_JOB]);//Рыбалка
    cache_get_value_name_int(0, "IN_SERVER", gCashServer[IN_SERVER]);
    cache_get_value_name_int(0, "IN_DONATE", gCashServer[IN_DONATE]);
    cache_get_value_name_int(0, "OUT_SERVER", gCashServer[OUT_SERVER]); 
    cache_get_value_name_int(0, "IN_NALOG_SERVER", gCashServer[IN_NALOG_SERVER]); 
    cache_get_value_name_int(0, "IN_PENSION", gCashServer[IN_PENSION]); 
    cache_get_value_name_int(0, "IN_WEBSITE", gCashServer[IN_WEBSITE]); 
    cache_get_value_name_int(0, "IN_MEDIA_WEBSITE", gCashServer[IN_MEDIA_WEBSITE]); 
    printf("[Загрузка ...] Данные из "TABLE_MOVE_CASH" получены. Время: %d!", GetTickCount() - time);
    return 1;
}
MoveCash_SecondTimer() {
    if (++CheckMoveCashData > 300) {
        mysql_tquery(dbHandle, "SELECT * FROM "TABLE_MOVE_CASH"", "OnCheckMoveCashServer", ""); 
        CheckMoveCashData = 0;
    } 
}
publics: OnCheckMoveCashServer()
{
    new rows;
	cache_get_row_count(rows);
	if(!rows) return 1; 
 	cache_get_value_name_int(0, "IN_WEBSITE", gCashServer[IN_WEBSITE]); 
    cache_get_value_name_int(0, "IN_MEDIA_WEBSITE", gCashServer[IN_MEDIA_WEBSITE]);  
	return 1;
}
new
    HelllowenSorry, HelllowenNoSorry;
publics: OnLoadEconomyServer()
{
	new rows;
	cache_get_row_count(rows);
	new
        time = GetTickCount();
    if (!rows) return print("[Загрузка ...] Данные из "#TABLE_ECONOMY" не получены!");

	cache_get_value_name_int(0, "healprice", healpric);
    cache_get_value_name_int(0, "mats_lsa", lsamatbi);
    cache_get_value_name_int(0, "ServerAntiTK", ServerAntiTK); 
    cache_get_value_name_int(0, "ePension", gEconomyServer[ePension]); 
    cache_get_value_name_int(0, "ePensionAge", gEconomyServer[ePensionAge]); 
    gEconomyServer[eMaterialsLSa][0] = 
    gEconomyServer[eMaterialsLSa][1] = 400_000;
    new settings[14];
    cache_get_value_name(0, "ServerInviteSettings", settings, sizeof (settings));
    sscanf(settings, "p<|>a<i>[5]", ServerInviteSettings);
    for (new i = 0; i < sizeof (ServerInviteSettings); i++) {
        if (ServerInviteSettings[i] < 1) ServerInviteSettings[i] = 1;
    } 
    cache_get_value_name_int(0, "hellowen_sorry", HelllowenSorry);
    cache_get_value_name_int(0, "hellowen_Nosorry", HelllowenNoSorry);
    printf("[Загрузка ...] Данные из "TABLE_ECONOMY" получены. Время: %d!", GetTickCount() - time);
    cache_get_value_name_int(0, "gPokerGame", SystemConfig[gPokerGame]);

    cache_get_value_name(0, "gCaptureOnlyDay", settings, sizeof (settings));//gCaptureOnlyDay
    sscanf(settings, "p<|>a<i>[3]", SystemConfig[gCaptureOnlyDay]);
    cache_get_value_name_int(0, "gAntiCBug", SystemConfig[gAntiCBug]);
    cache_get_value_name_int(0, "gTheftGang", SystemConfig[gTheftGang]);
    cache_get_value_name_int(0, "gCaptureEveryOneHour", SystemConfig[gCaptureEveryOneHour]);
    cache_get_value_name_int(0, "Spawncartime", Spawncartime);
    cache_get_value_name_int(0, "ReklamaOOC", ReklamaOOC);
    cache_get_value_name_int(0, "adminInterior", adminInterior);	

    
    new
        strings[200];
    for ( new i ; i < 10 ; i ++ )
    {
        TurnLoadingTrucker[LOADING_SAWMILL_0][i] = INVALID_PLAYER_ID;
        TurnLoadingTrucker[LOADING_SAWMILL_1][i] = INVALID_PLAYER_ID;
        TurnLoadingTrucker[LOADING_COAL_0][i] = INVALID_PLAYER_ID;
        TurnLoadingTrucker[LOADING_COAL_1][i] = INVALID_PLAYER_ID;
        TurnLoadingTrucker[LOADING_OIL_0][i] = INVALID_PLAYER_ID;
        TurnLoadingTrucker[LOADING_OIL_1][i] = INVALID_PLAYER_ID;
    } 

    TextLoadingTrucker[0] = CreateDynamic3DTextLabel( "Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы загрузить фуру\n\nОчередь на загрузку", -1, -449.3336,-65.9115,59.4158, 38.0, .worldid = 0, .interiorid = 0);
    TextLoadingTrucker[1] = CreateDynamic3DTextLabel( "Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы загрузить фуру\n\nОчередь на загрузку", -1, -1978.6846,-2434.8274,30.6250, 38.0, .worldid = 0, .interiorid = 0); 
    TextLoadingTrucker[2] = CreateDynamic3DTextLabel( "Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы загрузить фуру\n\nОчередь на загрузку", -1, 608.7718,847.8765,-43.1532, 38.0, .worldid = 0, .interiorid = 0);
    TextLoadingTrucker[3] = CreateDynamic3DTextLabel( "Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы загрузить фуру\n\nОчередь на загрузку", -1, -1873.0896,-1720.2430,21.7500, 38.0, .worldid = 0, .interiorid = 0);
    TextLoadingTrucker[4] = CreateDynamic3DTextLabel( "Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы загрузить фуру\n\nОчередь на загрузку", -1, 256.4736,1414.5182,10.7075, 38.0, .worldid = 0, .interiorid = 0);
    TextLoadingTrucker[5] = CreateDynamic3DTextLabel( "Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы загрузить фуру\n\nОчередь на загрузку", -1, -1046.7723,-670.7208,32.3516, 38.0, .worldid = 0, .interiorid = 0);
    for ( new i = 0 ; i < LOADING_ALL ; i ++ )
    {
        TurnLoadingPlayerID[i] = INVALID_PLAYER_ID;
    } 
    static const Float: PositionAngarsLSa[][] = {
        {2794.3711,-2426.8948,13.4695},
        {2794.5359,-2470.8730,13.4695}
    };
    for(new i = 0; i < 2; i++)
    {
        format(strings, sizeof strings, "[ Ангар № %d]\n"collime"Материалов: %d", i, gEconomyServer[eMaterialsLSa][i]);
        gAreas[arPutAmmoAngarsLS][i] = CreateDynamicSphere(PositionAngarsLSa[i][0], PositionAngarsLSa[i][1], PositionAngarsLSa[i][2], 1.0, 0, 0); //LS
	    CreateDynamicTrigger(PositionAngarsLSa[i][0], PositionAngarsLSa[i][1], PositionAngarsLSa[i][2] +0.1, 0, INTERIOR_NONE);//left
        gEconomyServer[eMaterialsLSText][i] = CreateDynamic3DTextLabel(strings, COLOR_ISPOLZUY, PositionAngarsLSa[i][0], PositionAngarsLSa[i][1], PositionAngarsLSa[i][2], 20.0, .worldid = 0, .interiorid = 0);
        SetDynamicAreaType(gAreas[arPutAmmoAngarsLS][i], AREA_TYPE_STEAL_MATERIALS, i);
    }  

    //UnloadingTrucker[]
    format(strings, sizeof strings, "Порт СФ\n\n"colwhi"Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фуру\n"C_PODS"Нефть: $%d\nУголь: $%d\nДерево: $%d", Sellbenz[1], Sellugol[1], Sellderevo[1]);
    Doki[1] = CreateDynamic3DTextLabel(strings, 0xFFFF00FF,-1731.4509,118.9413,3.5547,20.0, .worldid = 0, .interiorid = 0);
    CreateDynamicPickup(1239, 23, -1731.4509, 118.9413, 3.5547, .worldid = 0, .interiorid = 0);//Порт СФ
    format(strings, sizeof strings, "Порт ЛС\n\n"colwhi"Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фуру\n"C_PODS"Нефть: $%d\nУголь: $%d\nДерево: $%d", Sellbenz[0], Sellugol[0], Sellderevo[0]);
    Doki[0] = CreateDynamic3DTextLabel(strings, 0xFFFF00FF,2601.7222,-2226.5867,13.3732,20.0, .worldid = 0, .interiorid = 0);
    CreateDynamicPickup(1239, 23, 2601.7222, -2226.5867, 13.3732, .worldid = 0, .interiorid = 0);//Порт ЛС 

    LvaLable[0] = CreateDynamic3DTextLabel("-",0x33AA33FF,-1325.5178,492.5216,27.5871,15.0, INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 1,5);
    LvaLable[1] = CreateDynamic3DTextLabel("-",0x33AA33FF,2556.3315,-1411.9286,1500.8770,15.0, INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0,-1); 
	return 1;
} 
stock SetUpdate3DTextLabel() {
    for(new i = 0, string_[128]; i < 2; i++) {
        format(string_, sizeof string_, "[ Ангар № %d]\n"collime"Материалов: %d", i, gEconomyServer[eMaterialsLSa][i]);
        UpdateDynamic3DTextLabelText(gEconomyServer[eMaterialsLSText][i], 0x33AA33FF, string_); 
    }
}
stock SetMoveCashServer(E_MOVE_MONEY:type, amount, save = false) 
{
    gCashServer[type] += amount;
   // printf("Save Move Cash type: %d -> amount: %d", type, amount);
    if (save) {
        
        /*format(t_string, sizeof t_string,
            "UPDATE `s_move_cash` SET `IN_JOB`='%d', `IN_SERVER`='%d', `IN_DONATE`='%d', `OUT_SERVER`='%d'",
            gCashServer[IN_JOB], gCashServer[IN_SERVER], gCashServer[IN_DONATE], gCashServer[OUT_SERVER]
        );
	    mysql_tquery(dbHandle, t_string, "",""), t_string[0] = EOS;*/
    } 
	return 1;
}