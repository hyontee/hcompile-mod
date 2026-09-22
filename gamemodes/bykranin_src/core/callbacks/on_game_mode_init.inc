//>> Файл: bykranin_src/core/callbacks/on_game_mode_init.inc  (525 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnGameModeInit
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnGameModeInit()
{

    LoadMySQLSettings();
	LoadNEWSettings();

    print("[SECURITY] Hardcoded server IP lock disabled; continuing startup...");

    mysql_query(mysql, "UPDATE accounts SET job=0 WHERE job=3", false);
    print("[INIT_TRACE] 01 main init entered");
	new gPlayerBlockedPickup[MAX_PLAYERS] = { -1, ... };
	SetTimer("CorrectTimerMinute", 60000, true);
    SetTimer("KraninShopAdvertisement", 30 * 60 * 1000, true);
    SetTimer("UpdateVehicleTurnSignals", 500, true);
    SetTimer("AdminNickRainbowTick", 150, true);
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        TurnSignalDriver[i] = INVALID_PLAYER_ID;
        TurnSignalModel[i] = 0;
    }
    print("[INIT_TRACE] 02 before containers");
	ContForNewCreate();
	LoadTextDraw();
    print("[INIT_TRACE] 03 base systems created");
    StartCont();
    LoadSvetfor();
	CreateHouseATMpickups();
    pickup_rent_main = CreatePickup(1239, 23, 1786.0, -1898.0, 13.5, -1);

    report_edit_TD = TextDrawCreate(7.499990, 314.444396, "REP:_0");
	TextDrawLetterSize(report_edit_TD, 0.400000, 1.600000);
	TextDrawAlignment(report_edit_TD, 1);
	TextDrawColor(report_edit_TD, -1);
	TextDrawSetShadow(report_edit_TD, 0);
	TextDrawSetOutline(report_edit_TD, 1);
	TextDrawBackgroundColor(report_edit_TD, 255);
	TextDrawFont(report_edit_TD, 1);
	TextDrawSetProportional(report_edit_TD, 1);
	TextDrawSetShadow(report_edit_TD, 0);

    // V16: постоянные дата/время для авторизованной администрации, справа снизу.
    admin_datetime_TD = TextDrawCreate(635.000000, 425.000000, "00.00.0000_|_00:00:00");
    TextDrawLetterSize(admin_datetime_TD, 0.235000, 1.050000);
    TextDrawAlignment(admin_datetime_TD, 3);
    TextDrawColor(admin_datetime_TD, -1);
    TextDrawSetShadow(admin_datetime_TD, 0);
    TextDrawSetOutline(admin_datetime_TD, 1);
    TextDrawBackgroundColor(admin_datetime_TD, 255);
    TextDrawFont(admin_datetime_TD, 1);
    TextDrawSetProportional(admin_datetime_TD, 1);
    AdminHUD_UpdateDateTime();
    ReportGUI_UpdateCounter();

	//казино

	TD_1223[0] = TextDrawCreate(518.3331, 102.3185, "casino:brdice"); // пусто
    TextDrawTextSize(TD_1223[0], 121.0000, 155.0000);
    TextDrawAlignment(TD_1223[0], 1);
    TextDrawColor(TD_1223[0], -1);
    TextDrawBackgroundColor(TD_1223[0], 255);
    TextDrawFont(TD_1223[0], 4);
    TextDrawSetProportional(TD_1223[0], 0);
    TextDrawSetShadow(TD_1223[0], 0);

    TD_1223[1] = TextDrawCreate(569.3337, 224.4295, "Dev_Adse"); // пусто
    TextDrawLetterSize(TD_1223[1], 111.0000, 1.0000);
    TextDrawTextSize(TD_1223[1], 525.0000, 0.0000);
    TextDrawAlignment(TD_1223[1], 1);
    TextDrawColor(TD_1223[1], -1);
    TextDrawBackgroundColor(TD_1223[1], 255);
    TextDrawFont(TD_1223[1], 1);
    TextDrawSetProportional(TD_1223[1], 1);
    TextDrawSetShadow(TD_1223[1], 0);

    TD_1223[2] = TextDrawCreate(555.6666, 143.1259, "CTOL_1"); // пусто
    TextDrawLetterSize(TD_1223[2], 0.4000, 1.6000);
    TextDrawAlignment(TD_1223[2], 1);
    TextDrawColor(TD_1223[2], -1);
    TextDrawBackgroundColor(TD_1223[2], 255);
    TextDrawFont(TD_1223[2], 1);
    TextDrawSetProportional(TD_1223[2], 1);
    TextDrawSetShadow(TD_1223[2], 0);

    TD_1223[3] = TextDrawCreate(575.0000, 224.0148, "Box"); // пусто
    TextDrawLetterSize(TD_1223[3], 0.0000, 1.2333);
    TextDrawTextSize(TD_1223[3], 614.0000, 0.0000);
    TextDrawAlignment(TD_1223[3], 1);
    TextDrawColor(TD_1223[3], -1);
    TextDrawUseBox(TD_1223[3], 1);
    TextDrawBoxColor(TD_1223[3], -256);
    TextDrawBackgroundColor(TD_1223[3], 255);
    TextDrawFont(TD_1223[3], 1);
    TextDrawSetProportional(TD_1223[3], 1);
    TextDrawSetShadow(TD_1223[3], 0);
     
	

// ==================[otdel]

// ==================[redtart]
    
    SetTimer("AutoRestart", 60000, 1); // каждые 60 секунд вызываем паблик AutoRestart ( 1 сек. = 1000)
    
// ==================[fama]

    family_create_pickup = CreatePickup(1239, 23, -886.708374, -1572.291259, 1398.501098, -1);
    CreateDynamic3DTextLabel("{FFFF00}« Создание семьи »\n\n{FFFFFF}Подойдите ближе \nдля взаимодействия", -1, -886.708374, -1572.291259, 1398.501098, 15.0, _, _, _, -1, -1);
    
//=================[раздевалки]

	razdev  = CreatePickup(1275, 23, 2911.612792,1991.115966,2051.028564, 1); // ФСБ
    razdev1 = CreatePickup(1275, 23, -873.668273,-1579.249511,1398.501098, 1); // Правительство
    razdev2 = CreatePickup(1275, 23, 1815.482788,1697.846679,1493.039794, 1); // Армия
    razdev3 = CreatePickup(1275, 23, 1496.850341,2530.039062,2501.000000, 1); // Больница
    razdev9 = CreatePickup(1275, 23, 1977.712280,-17.240310,1381.003540, 1); // СМИ
    razdev4 = CreatePickup(1275, 23, -1093.627563,1525.411376,1499.947265, 1); // ГИБДД
    razdev5 = CreatePickup(1275, 23, -1094.364379,1524.709106,1499.987304, 2); // УМВД
    razdev6 = CreatePickup(1275, 23, -9.055850,489.159149,1381.042236, 1); // Арзамасская ОПГ
    razdev7 = CreatePickup(1275, 23, -9.847818,489.051422,1381.042236, 2); // Батыревская ОПГ
    razdev8 = CreatePickup(1275, 23, -9.575647,489.042694,1381.042236, 3); // Лыткаринская ОПГ

    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 2883.010253,2013.102050,2051.998046, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 956.964355,3.978107,1382.003540, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 1815.482788,1697.846679,1494.039794, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 1496.850341,2530.039062,2502.000000, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 1977.712280,-17.240310,1382.003540, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, -1093.627563,1525.411376,1500.947265, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 2882.406982,1495.399536,1552.946411, 15.0, _, _, _, 2, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 485.440368,739.756225,13.000550, 15.0, _, _, _, 1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, 1934.242431,2171.894531,16.705187, 15.0, _, _, _, 2, -1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Рабочая форма", -1, -2356.504394,78.742248,22.368095, 15.0, _, _, _, 3, -1);

   //койки 
    koika1 = CreateDynamicSphere(1486.96, 2496.20, 2501.60, 2.0);
	koika2 = CreateDynamicSphere(1487.08, 2492.86, 2501.60, 2.0);
	koika3 = CreateDynamicSphere(1482.71, 2492.71, 2501.60, 2.0);
	koika4 = CreateDynamicSphere(1482.72, 2496.41, 2501.60, 2.0);
	koika5 = CreateDynamicSphere(1484.96, 2504.06, 2501.60, 2.0);
	koika6 = CreateDynamicSphere(1484.72, 2507.10, 2501.60, 2.0);
	koika7 = CreateDynamicSphere(1480.52, 2507.26, 2501.60, 2.0);
	koika8 = CreateDynamicSphere(1480.38, 2503.78, 2501.60, 2.0);
	koika9 = CreateDynamicSphere(1471.71, 2496.20, 2501.60, 2.0);
	koika10 = CreateDynamicSphere(1471.60, 2492.82, 2501.60, 2.0);
	koika11 = CreateDynamicSphere(1467.40, 2492.95, 2501.60, 2.0);
	koika12 = CreateDynamicSphere(1467.36, 2496.46, 2501.60, 2.0);
	koika13 = CreateDynamicSphere(1473.69, 2503.78, 2501.60, 2.0);
	koika14 = CreateDynamicSphere(1473.90, 2507.18, 2501.60, 2.0);
	koika15 = CreateDynamicSphere(1469.51, 2507.27, 2501.60, 2.0);
	koika16 = CreateDynamicSphere(1469.47, 2504.00, 2501.60, 2.0);
	koika17 = CreateDynamicSphere(1486.96, 2496.20, 2506.60, 2.0);
	koika18 = CreateDynamicSphere(1487.08, 2492.86, 2506.60, 2.0);
	koika19 = CreateDynamicSphere(1482.71, 2492.71, 2506.60, 2.0);
	koika20 = CreateDynamicSphere(1482.72, 2496.41, 2506.60, 2.0);
	koika21 = CreateDynamicSphere(1484.96, 2504.06, 2506.60, 2.0);
	koika22 = CreateDynamicSphere(1484.72, 2507.10, 2506.60, 2.0);
	koika23 = CreateDynamicSphere(1480.52, 2507.26, 2506.60, 2.0);
	koika24 = CreateDynamicSphere(1480.38, 2503.78, 2506.60, 2.0);
	koika25 = CreateDynamicSphere(1471.71, 2496.20, 2506.60, 2.0);
	koika26 = CreateDynamicSphere(1471.60, 2492.82, 2506.60, 2.0);
	koika27 = CreateDynamicSphere(1467.40, 2492.95, 2506.60, 2.0);
	koika28 = CreateDynamicSphere(1467.36, 2496.46, 2506.60, 2.0);
	koika29 = CreateDynamicSphere(1473.69, 2503.78, 2506.60, 2.0);
	koika30 = CreateDynamicSphere(1473.90, 2507.18, 2506.60, 2.0);
	koika31 = CreateDynamicSphere(1469.51, 2507.27, 2506.60, 2.0);
	koika32 = CreateDynamicSphere(1469.47, 2504.00, 2506.60, 2.0);

	CreateDynamic3DTextLabel("{FFFF00}<< Лифт вверх >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, 1466.26, 2500.16, 2501.60, 10.0);
	CreateDynamic3DTextLabel("{FFFF00}<< Лифт вниз >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, 1466.26, 2500.16, 2506.60, 10.0);

    CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -420.054534,1005.409240,12.307003, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -413.549285,1005.543029,12.326748, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.326416, -2613.377685, 21.829063, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.343261, -2619.453125, 21.829063, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Шиномонтажный центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 1729.730712, 2457.556396, 14.979245, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Шиномонтажный центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 1730.881835, 2452.856689, 14.979245, 9.0, _, _, _, -1, -1);

	CreateDynamic3DTextLabel("{f6fa05}СТО \n{ffffff}Нажмите на{e81717} гудок\n{ffffff} Чтобы заехать", -1, 2164.40302, -870.388139, 27.89245, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}СТО \n{ffffff}Нажмите на{e81717} гудок\n{ffffff} Чтобы заехать", -1, 2164.40302, -865.467270, 27.89245, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}СТО \n{ffffff}Нажмите на{e81717} гудок\n{ffffff} Чтобы заехать", -1, 2164.40302, -854.441777, 27.89245, 9.0, _, _, _, -1, -1);
	CreateDynamic3DTextLabel("{f6fa05}СТО \n{ffffff}Нажмите на{e81717} гудок\n{ffffff} Чтобы заехать", -1, 2164.40302, -860.089064, 27.89245, 9.0, _, _, _, -1, -1);


    //CreateDynamic3DTextLabel("{FFFF00}Техехнический центр (1)\n{228B22}Бизнес находиться на аукционе\n{228B22}Крыша: Отсутствует\n{FFFF00}Подойдите для взаимодействия", 0xFFFF00FF, -431.966888,1005.120910,12.149999 + 0.9, 10.0);
    //tehsentervlad = CreatePickup(1318, 23, -431.966888,1005.120910,12.149999, 0);

	//=============================
    AntiDeAMX2();
	AntiDeAMX();
	new hour;
	gettime(hour);
	load_tuning();
    print("[INIT_TRACE] 04 before SvCreateGStream");
	gstream = SvCreateGStream(0xffff0000, "Global");
    print("[INIT_TRACE] 05 after SvCreateGStream");

	SetWorldTime(hour);
	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	
	CreateGreenZones();

	CreateDynamic3DTextLabel("{ffff00}Завод Бусаево\n{ffffff}Данным предприятием владеет семья\n{ff0000} none", 0xFFFF00FF, -2570.026123,-1979.871093,0.550000 + 1.8, 10.0);
	CreateDynamic3DTextLabel("{ffff00}Ферма Гарель\n{ffffff}Данным предприятием владеет семья\n{0066CC} none", 0xFFFF00FF, -2570.026123,-1979.871093,0.550000 + 1.8, 10.0);
	CreateDynamic3DTextLabel("{ffff00}Вышка сотовой связи №2\n{ffffff}Данным предприятием владеет семья\n{D3D3D3} none", 0xFFFF00FF, -2570.026123, -1979.871093, 0.550000 + 1.8, 10.0);
	CreateDynamic3DTextLabel("{ffff00}Вышка сотовой связи №1\n{ffffff}Данным предприятием владеет семья\n{00FF33} none", 0xFFFF00FF, -2570.026123, -1979.871093, 0.550000 + 1.8, 10.0);
	CreateDynamic3DTextLabel("банкомат введите\n/bankomat", 0xFFFF00FF, 2908.593750,2485.025878,1051.000000 + 1.8, 10.0);
	CreateDynamic3DTextLabel("{ffff00}Гараж №23\n{ffffff}Владелец:{ff0000}Enzo_Ludovic\n{EB4C42}Гараж закрыт", 0xFFFF00FF, 501.124755,276.682281,13.223153 + 0.5, 10.0);
	CreateDynamic3DTextLabel("Создание семьи", 0xFFD700FF, -145.753341,616.964782,12.255379 + 0.3, 5.0);
	medka = CreatePickup(1318, 23, 1501.575927,2498.214843,2501.000000, -1);
    Create3DTextLabel("{ffff00}« Получение мед. карты »\n{ffffff}Подойдите ближе\nдля взоимодействия", -1, 1501.584228,2498.212158,2501.000000, 15.0, 1);
    for(new used_market_entry; used_market_entry < sizeof gUsedMarketVehicleEnter; used_market_entry++)
    {
        CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}в своём автомобиле", -1,
            gUsedMarketVehicleEnter[used_market_entry][0], gUsedMarketVehicleEnter[used_market_entry][1],
            gUsedMarketVehicleEnter[used_market_entry][2] + 1.0, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    }
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 482.254608,954.700195,1001.000000, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 499.931915,918.361816,1001.000000, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 481.850952,1081.980712,1001.000000, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 561.913696,1018.296691,1001.000000, 9.0, _, _, _, -1, -1); //
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 553.966735,918.125732,1001.000000, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 473.902709,1018.365661,1001.000000, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 553.964111,1082.194213,1001.000000, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Авторынок\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 562.388244,963.125244,1001.000000, 9.0, _, _, _, -1, -1);
    pkvxod = CreatePickup(1318, 23, -2383.645751,31.737224,27.031343, -1, PICKUP_PKVXOD);
    pkvixod = CreatePickup(1318, 23, 1312.644531,1711.863281,1498.363159, 0, PICKUP_PKVIXOD);

	avtorinokz = CreatePickup(1318, 23, 887.844970,-922.904968,41.470359, 0);
	avtorinokv = CreatePickup(1318, 23, 437.292938,982.754150,1001.000000, 101);
    CreateDynamic3DTextLabel("{FFFF00}Авторынок\n{FFFFFF}Пеший вход: подойдите к метке\nВъезд на авто: гудок у въездных мест", -1,
        887.844970, -922.904968, 42.170359, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    CreateDynamicMapIcon(887.844970, -922.904968, 41.470359, 55, -1, 0, 0);


	new server_command[96];
	format(server_command, sizeof server_command, "hostname %s", NameServer[KRANIN_NAME]);
	SendRconCommand(server_command);
	format(server_command, sizeof server_command, "weburl %s", NameServer[KRANIN_SITE]);
	SendRconCommand(server_command);
	SendRconCommand("mapname "SERVER_MAP_NAME"");
	
	SendRconCommand("ackslimit 10000");

	ShowNameTags(true);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ManualVehicleEngineAndLights();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	SetNameTagDrawDistance(30.0);

	//Streamer_SetMaxItems(STREAMER_TYPE_MAP_ICON, 98);
	Streamer_SetVisibleItems(STREAMER_TYPE_MAP_ICON, 98);
	Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 650); // Default: 500
	
	// -- custom-side-brilliant
    Iter_Init(streamed_players_in_veh);
    Iter_Init(vehicle_in_stream);

	Streamer_ToggleErrorCallback(true);
	
	CreatePickup(1239,23,-316.1636,400.8567,13.5937,0,PICKUP_ACTION_OBMEN_MONET);

    CreatePickup(1239,23,1301.493896,1704.872924,1498.363159,0, PICKUP_ACTION_TYPE_MPREG);
    
    CreateActor(306, -2426.133789,187.171112,26.095102,21.786745);
    Create3DTextLabel("{ffff00}Дядя Чупа\n{ffffff}Подойдите для {ffff00}обучения", -1, -2426.133789,187.171112,26.095102, 15.0, 0);

    CreateActor(306, 1792.237304,2536.952392,14.654764,219.829956);
    Create3DTextLabel("{ffff00}Дядя Чупа\n{ffffff}Подойдите для {ffff00}обучения", -1, 1792.237304,2536.952392,14.654764, 15.0, 0);

    CreateActor(306, 827.973327,788.347839,13.142774,276.134521);
    Create3DTextLabel("{ffff00}Дядя Чупа\n{ffffff}Подойдите для {ffff00}обучения", -1, 827.973327,788.347839,13.142774, 15.0, 0);
    
    OtdelKadrovCb = CreateActor(81, 1502.981933,2500.498535,2501.000000,270.907531);
    CreateDynamic3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Нажмите кнопку взаимодействия", -1, 1502.981933,2500.498535,2501.800000, 15.0, _, _, _, 1, 1);
    SetActorVirtualWorld(OtdelKadrovCb, 1);
    
    OtdelKadrovSmi = CreateActor(81, 1985.329711,-3.292105,1381.003540,358.328704);
    CreateDynamic3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Нажмите кнопку взаимодействия", -1, 1985.329711,-3.292105,1381.803540, 15.0, _, _, _, 1, 1);
    SetActorVirtualWorld(OtdelKadrovSmi, 1);
    
    OtdelKadrovVoenkom = CreateActor(81, 498.718017,1511.595458,1501.000000, 0.0);
    CreateDynamic3DTextLabel("{ffff00}« Отдел кадров военкомата »\n{ffffff}Нажмите кнопку взаимодействия", -1, 498.718017,1511.595458,1501.800000, 15.0, _, _, _, 1, 1);
    SetActorVirtualWorld(OtdelKadrovVoenkom, 1);
    
    OtdelKadrovPravo = CreateActor(81, -887.145874,-1567.841796,1398.501098,85.106346);
    CreateDynamic3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Нажмите кнопку взаимодействия", -1, -887.145874,-1567.841796,1399.301098, 15.0, _, _, _, 1, 1);
    SetActorVirtualWorld(OtdelKadrovPravo, 1);
    
    OtdelKadrovGibdd = CreateActor(81, -1106.177490,1513.784179,1499.953247,58.987396);
    CreateDynamic3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Нажмите кнопку взаимодействия", -1, -1106.177490,1513.784179,1500.753247, 15.0, _, _, _, 1, 1);
    SetActorVirtualWorld(OtdelKadrovGibdd, 1);
    
    OtdelKadrovUmvd = CreateActor(81, -1105.977539,1513.604003,1499.985961,47.100631);
    CreateDynamic3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Нажмите кнопку взаимодействия", -1, -1105.977539,1513.604003,1500.785961, 15.0, _, _, _, 2, 1);
    SetActorVirtualWorld(OtdelKadrovUmvd, 2);
    
    CreateActor(236, 652.252060,173.563812,2.041145,183.585617);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Нажмите кнопку взаимодействия", -1, 652.252060,173.563812,2.041145, 15.0, 0);
    vodolazactor[0] = CreateDynamicSphere(652.252060,173.563812,2.041145, 3.5);
    
    CreateActor(236, 2272.684570,309.651611,4.000000,344.699798);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Нажмите кнопку взаимодействия", -1, 2272.684570,309.651611,4.000000, 15.0, 0);
    vodolazactor[1] = CreateDynamicSphere(2272.684570,309.651611,4.000000, 3.5);
    
    CreateActor(236, 2500.639648,-1252.934204,1.396202,207.274276);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Нажмите кнопку взаимодействия", -1, 2500.639648,-1252.934204,1.396202, 15.0, 0);
    vodolazactor[2] = CreateDynamicSphere(2500.639648,-1252.934204,1.396202, 3.5);
    
    CreateActor(236, -2527.409423,358.139892,2.060437,144.376846);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Нажмите кнопку взаимодействия", -1, -2527.409423,358.139892,2.060437, 15.0, 0);
    vodolazactor[3] = CreateDynamicSphere(-2527.409423,358.139892,2.060437, 3.5);

    // Same mobile interaction button as containers for underwater diver loot.
    vodolootsphere[0][0] = CreateDynamicSphere(-825.829650, -1330.570922, -0.279577, 5.0);
    
    CreateActor(98, -2433.244140,186.891983,26.095102,308.512725);
    Create3DTextLabel("{ffff00}Для новичков\n{ffffff}Помощь по игре", -1, -2433.244140,186.891983,26.095102, 15.0, 0);
    
    CreateActor(98, 1816.017578,2510.523437,14.664855,211.883209);
    Create3DTextLabel("{ffff00}Для новичков\n{ffffff}Помощь по игре", -1, 1816.017578,2510.523437,14.664855, 15.0, 0);
    
    CreateActor(98, 842.087951,787.303894,13.384387,30.914310);
    Create3DTextLabel("{ffff00}Для новичков\n{ffffff}Помощь по игре", -1, 842.087951,787.303894,13.384387, 15.0, 0);
    
    CreateActor(98, 2741.403564,-2433.814697,21.781099,231.110839);
    Create3DTextLabel("{ffff00}Для новичков\n{ffffff}Помощь по игре", -1, 2741.403564,-2433.814697,21.781099, 15.0, 0);
    
    CreateActor(306, 2753.569335,-2443.314697,21.781099,92.578720);
    Create3DTextLabel("{ffff00}Дядя Чупа\n{ffffff}Подойдите для {ffff00}обучения", -1,  2753.569335,-2443.314697,21.781099, 15.0, 0);
    
    CreateActor(57, -1721.147827,-2815.024169,7.582671,132.815338);
    Create3DTextLabel("{ffff00}« Игла »\n{ffffff}Подойдите ближе\nдля взоимодействия", -1, -1721.147827,-2815.024169,7.582671, 15.0, 0);
    
    Create3DTextLabel("{ffff00}Общий тайник\n{ffffff}Подойдите ближе для взоимодействия", -1, -1698.703979,-2698.262695,1499.500000, 15.0, 6);
    
    
    Create3DTextLabel("{ffCC00}МЕРОПРИЯТИЕ\n \n{ffCC00}Организатор:\n{ffCC00}Название мероприятия:мп\n{ffCC00}Количество игроков:неограничено\n \n{ffCC00}Чтобы покинуть мероприятие /cevent", -1, 1906.339965,-1896.160766,56.413967, 15.0, 0);
    
    
    // Static larek labels are created by modules/m1stoks.
CreateActor(167, 2760.039550,-2391.703857,21.890424,271.692077);
    
	NPC_Dityukovich = CreateActor(34, 1633.826660,1294.855712,12.221715,310.005340);
	pickupferma = CreatePickup(1275, 23, 1634.798217,1295.547119,12.204029, -1);
	CreateDynamic3DTextLabel("[NPC]\n Дитюкович", 0xFFFF00FF, 1633.826660,1294.855712,12.221715, 10.0);
   
   
	CreateDynamic3DTextLabel("Прием на работу", 0xFFFF00FF, 991.6033,-7.3193,1380.9962 + 1.8, 10.0);
	CreatePickup(1210, 23, 991.6033,-7.3193,1380.9962, 1, PICKUP_ACTION_TYPE_MAYOR_JOB);
	
	// Legacy MCHS pickups disabled, firesystem.pwn handles the new system.
	mchsavto = -1;
	mchsrazdewalka = -1;
	mchsexit = -1;
	mchsvhod = -1;

	lazaretvhod = CreatePickup(1318, 23, -1801.931030,-2757.826660,1501.000000, -1, PICKUP_LAZARETVHOD);

	CreateDynamic3DTextLabel("Выход из лазарета", 0xFFFF00FF, -2003.557861,-1506.610107,1751.005249 + 1.0, 10.0);
	lazaretvihod = CreatePickup(1318, 23, -2003.557861,-1506.610107,1751.005249, -1, PICKUP_LAZARETVIHOD);


	CreateDynamic3DTextLabel("Вход в камеру", 0xFFFF00FF, -1801.861206,-2766.176757,1501.000000 + 1.0, 10.0);
	cameravhod = CreatePickup(1318, 23, -1801.861206,-2766.176757,1501.000000, -1, PICKUP_CAMERAVHOD);

	CreateDynamic3DTextLabel("Выход из камеры", 0xFFFF00FF, -1697.535400,-2702.098876,1499.500000 + 1.0, 10.0);
	cameravihod = CreatePickup(1318, 23, -1697.535400,-2702.098876,1499.500000, -1, PICKUP_CAMERAVIHOD);

	CreateDynamic3DTextLabel("Вход в комнату лесопильни", 0xFFFF00FF, -1798.070190,-2759.390869,1501.000000 + 1.0, 10.0);
	lesopilvhod = CreatePickup(1318, 23, -1798.070190,-2759.390869,1501.000000, -1, PICKUP_LESOPILVHOD);

	CreateDynamic3DTextLabel("Выход из комнаты лесопильни", 0xFFFF00FF, -1887.860717,-2609.774902,1501.233764 + 1.0, 10.0);
	lesopilvihod = CreatePickup(1318, 23, -1887.860717,-2609.774902,1501.233764, -1, PICKUP_LESOPILVIHOD);

	CreateDynamic3DTextLabel("Правительство области", 0xFFFF00FF, 978.711975,-18.241992,1380.996215, -1 + 1.0, 10.0);
	vxodpravo = (1318, 23, 978.711975,-18.241992,1380.996215, 1);

	CreateDynamic3DTextLabel("Выход", 0xFFFF00FF, 980.241271,-20.293521,1380.996215, -1 + 1.0, 10.0);
	vixodpravo = CreatePickup(1318, 23, 980.241271,-20.293521,1380.996215, -1);
	//bus job
    buspick1 = -1;
    buspick2 = -1;
    buspick3 = -1;
    SetTimer("CasinoDiceUiTick", 1000, true);
	CreatePickup(1650, 23, 13.1749,2.9268,1380.9985, 1, PICKUP_ACTION_TYPE_PUT_PROD);

	CreatePickup(1239, 23, 2883.7095,1447.6533,1050.9984, 1);
	g_casino_bonus_entry_pickup = CreatePickup(1318, 23, 1333.740600,2372.598632,17.712001, 0);
	pickup_shop247_medkit = CreatePickup(1240, 23, 1552.954833, 412.214538, 1001.039306, -1);
	CreateDynamic3DTextLabel("{01b001}Аптечка\n{f0c101}Стоимость: 150 RUB.", 0xFFFFFFFF, 1552.954833, 412.214538, 1001.039306 + 0.85, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 1, -1, STREAMER_3D_TEXT_LABEL_SD);
	CreatePickup(1239, 23, 1561.954833,1643.207153,15.971530, 0, PICKUP_ACTION_TYPE_TEMP_ARMY);

	CreateDynamic3DTextLabel("- Получение -\n{FFFFFF}номеров на личное ТС", 0x3399FFFF,
		-1109.050415, 1510.751464, 1499.945922 + 1.8, 10.0,
		INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 1, -1);
	CreatePickup(1239, 23, -1109.050415,1510.751464,1499.945922, 1, PICKUP_ACTION_TYPE_GET_CAR_NUM);

	vorotafrack();

	g_last_lottery_time =
	g_last_pay_day_time =
	g_last_m_timer_time = gettime();

    print("[INIT_TRACE] 06 before common systems");
	CreateTextDraws();
	CreateMenus();
	CreateMedBeds();
	CreateCasinoTables();
    CreateCasinoDiceTextDraws();
	CreateArmories();

	CreateQuestPickup();
	CreateGreenZones();
	Construction_Init();
	FsinFull_Init();

	HelpInfoInit();
	AnimListInit();
	BusRoutesInit();
	CreateATMs();
	BanksInit();
	TempJobsInit();
	
	
	MapIconsInit();

	TeleportPickupsInit();
	DrivingSchoolInit();
 	CreateRentBike();
 	CreateFractionCar();

	#if defined RAND_WEATHER
	SetRandomWeather();
	#endif

	#if defined _GANG_ZONES_INC
	#endif

    print("[INIT_TRACE] 07 before mysql");
	mysql_log();
	mysql = mysql_connect(MySQLSettings[KRANIN_HOST],MySQLSettings[KRANIN_USERNAME],MySQLSettings[KRANIN_DATABASE],MySQLSettings[KRANIN_PASSWORD]);

	if(mysql_errno() != 0)
		return print("Не удалось подключится к базе данных!");

	mysql_set_charset("cp1251");
mysql_tquery(mysql, "SET NAMES cp1251");

	GarageSys_Init();
	FactionGate_Init();

	// Marketplace tables must be initialized only after mysql_connect succeeds.
	// The old order called Marketplace_Init() before a DB connection existed,
	// so marketplace_lots/history were not created and publishing returned
	// "lot not listed" on INSERT.
	Marketplace_Init();

	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `nick_color` INT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `nick_rainbow` TINYINT(1) NOT NULL DEFAULT 0", false);
	if(mysql_errno() != 0)
		printf("[NICKCOLOR] Failed to ensure accounts.nick_color/nick_rainbow, mysql errno=%d", mysql_errno());

	mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `blogger_profiles` (`account_id` INT(11) NOT NULL, `enabled` TINYINT(1) NOT NULL DEFAULT 0, `fake_nick` VARCHAR(24) NOT NULL DEFAULT '', PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
	if(mysql_errno() != 0)
		printf("[BLOGGER] Failed to ensure blogger_profiles, mysql errno=%d", mysql_errno());

	mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `objects_placed` (`id` INT(11) NOT NULL AUTO_INCREMENT, `type` TINYINT(1) NOT NULL DEFAULT 0, `model_id` INT(11) NOT NULL DEFAULT 0, `custom_id` INT(11) NOT NULL DEFAULT 0, `name` VARCHAR(64) NOT NULL DEFAULT '', `sign_text` VARCHAR(144) NOT NULL DEFAULT '', `color` INT(11) NOT NULL DEFAULT 0, `x` FLOAT NOT NULL DEFAULT 0, `y` FLOAT NOT NULL DEFAULT 0, `z` FLOAT NOT NULL DEFAULT 0, `angle` FLOAT NOT NULL DEFAULT 0, `created_by` VARCHAR(24) NOT NULL DEFAULT '', PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
	if(mysql_errno() != 0)
		printf("[OBJECT_PLACER] Failed to ensure objects_placed, mysql errno=%d", mysql_errno());
	mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `objects_favorites` (`id` INT(11) NOT NULL AUTO_INCREMENT, `type` TINYINT(1) NOT NULL DEFAULT 0, `model_id` INT(11) NOT NULL DEFAULT 0, `custom_id` INT(11) NOT NULL DEFAULT 0, `name` VARCHAR(64) NOT NULL DEFAULT '', `sign_text` VARCHAR(144) NOT NULL DEFAULT '', `color` INT(11) NOT NULL DEFAULT 0, `label` VARCHAR(32) NOT NULL DEFAULT '', `created_by` VARCHAR(24) NOT NULL DEFAULT '', PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
	if(mysql_errno() != 0)
		printf("[OBJECT_PLACER] Failed to ensure objects_favorites, mysql errno=%d", mysql_errno());
	ObjectPlacer_LoadFromDB();
	ObjectPlacer_Favorites_LoadFromDB();

	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `med` TINYINT(1) NOT NULL DEFAULT 0", false);
	if(mysql_errno() != 0)
		printf("[MEDCARD] Failed to ensure accounts.med, mysql errno=%d", mysql_errno());

	// Донат-слоты недвижимости должны существовать в любой старой базе.
	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `house_slots` INT NOT NULL DEFAULT 0", false);
	if(mysql_errno() != 0)
		printf("[PROPERTY_SLOTS] Failed to ensure accounts.house_slots, mysql errno=%d", mysql_errno());
	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `buss_slots` INT NOT NULL DEFAULT 0", false);
	if(mysql_errno() != 0)
		printf("[PROPERTY_SLOTS] Failed to ensure accounts.buss_slots, mysql errno=%d", mysql_errno());

	AdminStats_Init();
	TC_Init();
	// Новая очередь репортов не очищает рабочую SQL-таблицу при запуске.
	// Fire database module is not present in this build.
	// Diner database module is not present in this build.
	LoadGreenZonesFromDB();
	UpdateCharity();
	RepositoriesLoad();

	LoadEntrances();
	// LoadHouses();
	// LoadHousesRenters();
	LoadHousesNew();
	EntranceStatusInitAll();

	LoadFamily();
    FamilySystemInit();
	LoadSettings();
	printf("[MYSQL][AUTOSALON] OnGameModeInit: before LoadBusinesses");
	LoadBusinesses();
	Larek_OnGameModeInit();
	LoadAutosalonSlots();
	printf("[MYSQL][AUTOSALON] OnGameModeInit: after LoadBusinesses");
	
	LoadCarObmen();

	LoadHotels();

	LoadFuelStations();
	LoadOrders();

	LoadGangRepositories();

	LoadLeaderList();
	
	SetWeather(11);

	SetTimer("ClearBanList", 15_000, false);
	SetTimer("OnSecondTimer", 1000, true);
    SetTimer("UpdateOnlineTimers", 60000, true);
	SetTimer("SaveOnlineTimers", 300000, true); // 5 минут = 300000 мс

	CallLocalFunction("HospitalTreatment", "");

	SetGameModeText(SERVER_VERSION);
	
	LoadHousesBought();
    return 1;
}


