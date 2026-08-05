stock ConnectMySQL()
{
    LoadMySQLSettings();
    connects = mysql_connect(MySQLSettings[MAZEHOST_HOST],MySQLSettings[MAZEHOST_USERNAME],MySQLSettings[MAZEHOST_PASSWORD],MySQLSettings[MAZEHOST_DATABASE]);
	mysql_tquery(connects, "SET NAMES cp1251");
	mysql_set_charset("cp1251");
	mysql_query(connects, "SET CHARACTER SET cp1251");
	//mysql_function_query(connects,"SET NAMES 'utf8'",false,"","");
	//mysql_function_query(connects,"SET CHARACTER SET 'cp1251'",false,"","");
	//mysql_function_query(connects,"SELECT * FROM `hostnames`", true, "LoadNames", "");
    return true;
}
stock LoadMySQLSettings()
{
	new FileID = ini_openFile("mysql_settings.ini"),errCode;
	if(FileID < 0)
	{
		printf("Error while opening MySQL settings file. Error code: %d",FileID);
		return 0;
	}
	errCode = ini_getString(FileID,"host",MySQLSettings[MAZEHOST_HOST]);
	if(errCode < 0) printf("Error while reading MySQL settings file (host). Error code: %d",errCode);
	errCode = ini_getString(FileID,"username",MySQLSettings[MAZEHOST_USERNAME]);
	if(errCode < 0) printf("Error while reading MySQL settings file (username). Error code: %d",errCode);
	errCode = ini_getString(FileID,"password",MySQLSettings[MAZEHOST_PASSWORD]);
	if(errCode < 0) printf("Error while reading MySQL settings file (password). Error code: %d",errCode);
	errCode = ini_getString(FileID,"database",MySQLSettings[MAZEHOST_DATABASE]);
	if(errCode < 0) printf("Error while reading MySQL settings file (database). Error code: %d",errCode);
	ini_closeFile(FileID);
	return 1;
}

public OnGameModeInit() {
	gCurDay = GetDayNumber();
	SetGameModeText("Android | PC");
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	SendRconCommand("hostname Ultimate RolePlay | Server 01");
	//Profiler_Start();


	ConnectMySQL();
	/*switch(SELECT_SERVER) {
		case 1: {
		    connects = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATEBASE, option_id);
			printf("[Загрузка ...] БД MYSQL успешно соединено! (СЕРВЕР [ОСНОВНОЙ] | %i)",SELECT_SERVER);
		}
		case 2: {
		    connects = mysql_connect(MYSQL_HOST_TEST, MYSQL_USER_TEST, MYSQL_PASSWORD_TEST, MYSQL_DATEBASE_TEST, option_id);
			printf("[Загрузка ...] БД MYSQL успешно соединено! (СЕРВЕР [ТЕСТОВЫЙ] | %i)",SELECT_SERVER);
		}
		case 3: {
			connects = mysql_connect(MYSQL_HOST_LOCAL, MYSQL_USER_LOCAL, MYSQL_PASSWORD_LOCAL, MYSQL_DATEBASE_LOCAL, option_id);
			printf("[Загрузка ...] БД MYSQL успешно соединено! (СЕРВЕР [LOCALHOST] | %i)",SELECT_SERVER);
		}
	}*/
	mysql_log(ERROR | WARNING);
	switch(mysql_errno())//
	{
		case 0: print("Подключение к базе данных удалось");
	    case 1044: return printf("Подключение к базе данных не удалось [Указано несуществующее имя пользователя %s]", MySQLSettings[MAZEHOST_USERNAME]);
	    case 1045: return printf("Подключение к базе данных не удалось [Указан неправильный пароль %s]", MySQLSettings[MAZEHOST_PASSWORD]);
	    case 1049: return printf("Подключение к базе данных не удалось [Указана несуществующа¤ база данных %s]", MySQLSettings[MAZEHOST_DATABASE]);
	    case 2003: return printf("Подключение к базе данных не удалось [Хостинг с базой данных недоступен %s]", MySQLSettings[MAZEHOST_HOST]);
	    case 2005: return printf("Подключение к базе данных не удалось [Указан неправильный адрес хостинга %s]", MySQLSettings[MAZEHOST_HOST]);
	    default: return printf("Подключение к базе данных не удалось [Неизвестная ошибка.  од ошибки: %d]", mysql_errno());
	}
	SendRconCommand("ackslimit 7800");
	/*============================================================================*/
	mysql_set_charset("cp1251");
	mysql_tquery(connects, !"SET CHARACTER SET 'utf8'", "", "");
	mysql_tquery(connects, !"SET NAMES 'utf8'", "", "");
	mysql_tquery(connects, !"SET character_set_client = 'cp1251'", "", "");
	mysql_tquery(connects, !"SET character_set_connection = 'cp1251'", "", "");
	mysql_tquery(connects, !"SET character_set_results = 'cp1251'", "", "");
	mysql_tquery(connects, !"SET SESSION collation_connection = 'utf8_general_ci'", "", "");

	load_vehicles();
	CreateVehicless();
	CreatePickups();
	load_fracfreez();
	load_house();
	load_hotels();
	load_airports();
	load_airplane();
	load_family();
	load_rooms();
	load_bint();
	load_funcbizz();
	load_business();
    load_greenzone();
	load_gangzone();
    load_fractions();
    load_diplomation();
    load_others();
	load_anticheat();
	load_market();
	load_labrary();
	load_economy();
	load_atm();
	load_vote();
	load_fracgun();
	load_bonuses();
	load_graffity();
	load_vip();
	mysql_tquery(connects,"UPDATE `accounts` SET `online_status` = '1001'", "", "");

	for(new d = 0; d < MAX_DUELS; d++) {
		DI[d][duel_owner_id] = DI[d][duel_id][0] = DI[d][duel_id][1] = DI[d][duel_id][2] = DI[d][duel_id][3] = DI[d][duel_id][4] = DI[d][duel_id][5] = INVALID_PLAYER_ID;
		DI[d][duel_gun] = 0;
		DI[d][duel_money] = 1000;
		DI[d][duel_raund] = 1;
		DI[d][duel_type] = 0;
		DI[d][duel_map] = 0;
		DI[d][duel_health] = 100;
		DI[d][duel_armour] = 0;
		DI[d][duel_start] = false;
		DI[d][duel_create] = false;
		DI[d][duel_point_1] = 0;
		DI[d][duel_point_2] = 0;
		DI[d][duel_vw] = 0;
	}
	for(new i=0;i<MAX_DROP_GUNS;i++) {
		drop_gun[i][dg_object] = -1;
		drop_gun[i][dg_gun] = -1;
		drop_gun[i][dg_ammo] = -1;
		drop_gun[i][dg_text] = Text3D:-1;
		drop_gun[i][dg_time] = -1;
	}
	calls_news[0] = INVALID_PLAYER_ID;
	calls_news[1] = INVALID_PLAYER_ID;
	calls_news[2] = INVALID_PLAYER_ID;
	calls_ether[0] = INVALID_PLAYER_ID;
	calls_ether[1] = INVALID_PLAYER_ID;
	calls_ether[2] = INVALID_PLAYER_ID;

	for(new i = 0; i < 14; i++) VacancyInfo[i][VacancyCreator] = INVALID_PLAYER_ID;

	SetGravity(0.010);

	components_name();
    SetWeather(2);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ManualVehicleEngineAndLights();
	LimitGlobalChatRadius(13.0);
	LimitPlayerMarkerRadius(12.0);
	SetNameTagDrawDistance(30.0);

	new mi,h;
	gettime(h,mi,gCurHour);
	SetWorldTime(h);

	advertise_price = 2;
	condition_of_roads_ = 1;

	for(new i = 0; i < sizeof(object_park_ls); i++) {
        object_park_ls[i] = CreateDynamicObject(14468, check_job_mower[i][0], check_job_mower[i][1], check_job_mower[i][2], check_job_mower[i][3],
							check_job_mower[i][4], check_job_mower[i][5], -1, -1);
        status_check_job_mower[i] = false;
	}
	check_verona_beach = 0;
	check_white_house = 0;
	check_medic_ls = 0;
	check_glenpark_1 = 0;
	check_glenpark_2 = 0;

	fish_zone[0] = GangZoneCreate(-310.00006103515625, -505.0000762939453, -200.00006103515625, -415.0000762939453);
	fish_zone[1] = GangZoneCreate(-350.00006103515625, -640.0000610351562, -240.00006103515625, -540.0000610351562);
	fish_zone[2] = GangZoneCreate(-246.00006103515625, -763.0000610351562, -136.00006103515625, -673.0000610351562);

	specmenu = CreateMenu("Recon", 1, 15.0, 200.0, 100.0);
    AddMenuItem(specmenu,0,"Refresh");
    AddMenuItem(specmenu,0,"Kick");
    AddMenuItem(specmenu,0,"Warn");
    AddMenuItem(specmenu,0,"Ban");
    AddMenuItem(specmenu,0,"Slap");
    AddMenuItem(specmenu,0,"Stats");
    AddMenuItem(specmenu,0,"Next");
	AddMenuItem(specmenu,0,"Back");
    AddMenuItem(specmenu,0,"-EXIT-");

	Create3dText();
	CreateTexdraw();
	CreateSphree();

	#include "modules/objects/objects.inc"
	#include "modules/objects/magomed_zone.inc"
	//

	// Маппинг фракций
	#include "modules/objects/fractions/State/ArmySF.inc"
	#include "modules/objects/fractions/State/ArmyLV_park.inc"
	#include "modules/objects/fractions/State/Int_meria.inc"

	#include "modules/objects/fractions/Mafia/Int_Mafia.inc"


	// #include "modules/objects/public_places/Int_autoschool_new.inc" // new autoschool
	// #include "modules/objects/public_places/Int_autoschool_exterier.inc" // new autoschool ext
	#include "modules/objects/public_places/Int_autoschool.inc"


	#include "modules/objects/fractions/State/Int_CNN.inc"
	#include "modules/objects/fractions/State/Int_FBI.inc"
	#include "modules/objects/fractions/State/Int_Hospital.inc"
	#include "modules/objects/fractions/State/Int_kazarma_armia.inc"
	#include "modules/objects/fractions/State/Int_LSPD.inc"
	//

	// Бизнесы
	#include "modules/objects/business/24_7.inc" // int 24/7
	#include "modules/objects/business/taxi_enterprice.inc" // Таксопарк маппинг
	#include "modules/objects/business/transport_enterprice.inc" // тк + ещё тк какие-то
	#include "modules/objects/business/perfomance_tuning.inc" // perfomance
	#include "modules/objects/business/bank.inc" // Банк
	#include "modules/objects/business/gas.inc"
	//

	// Публичные места
	#include "modules/objects/public_places/spawns_ls.inc" // спавн ждлс
	#include "modules/objects/public_places/rent_and_eat_boxes.inc" // Аренд будки + еда будки
	//

	// JOBS(Работы)
	#include "modules/objects/jobs/Job_Wood.inc" // лесопилка
	#include "modules/objects/jobs/Job_mine.inc" // шахта
	#include "modules/objects/jobs/Job_heaver.inc" // грузчики ЛС
	#include "modules/objects/jobs/Job_farm.inc" // яблочный сад(ферма)
	#include "modules/objects/jobs/Job_oil.inc" // яблочный сад(ферма)
	//
	CreateDynamicObject(13198, 151.92943, -241.42261, 5.59380,   0.00000, 0.00000, -273.00000);
	//tmpobjid = CreateObject(4821, 1745.199951, -1882.849975, 26.140600, 0.000000, 0.000000, 0.000000,300.00);
	//SetObjectMaterial(tmpobjid, 5, 18029, "genintintsmallrest", "GB_restaursmll03", 0x00000000);
	//SetObjectMaterial(tmpobjid, 7, 7555, "bballcpark1", "ws_carparknew2", 0x00000000);
	//SetObjectMaterial(tmpobjid, 10, 3979, "civic01_lan", "airportwall_256128", 0x00000000);
	printf("[Объекты ...] Динамических объектов: (%d шт.)",CountDynamicObjects());
	printf("[Объекты ...] Статических объектов: (%d шт.)",TotalObject);
	// Синхронизация времени для Timer_Unix

	unix = gettime(tmphour, tmpminute, tmpsecond); // обнволяем unix и tmphour, tmpminute, tmpsecond
	new sunix = unix; // sunix равна unix

	sunix -= tmpminute*60; // в sunix обнуляем минуты
	sunix -= tmpsecond; // в sunix обнуляем минуты

	unix_hour = sunix+3600; // добавляем в unix_h - час чтобы Timer_Unix сработал кореектно в 00 мин
	unix_min = sunix+60; // добавляем в unix_m - минуту чтобы Timer_Unix сработал кореектно в 00 сек
	unix_heal = sunix+240;
	unix_sec = sunix;
	unix_three_sec = sunix+3;

	if(timers_unix != -1) {
		KillTimer(timers_unix);
		timers_unix = -1;
	}
	if(timers_unix == -1) timers_unix = SetTimer("Timer_Unix",125,true); // 250 ms

	capture_kd[fBALLAS] = capture_kd[fVAGOS] = capture_kd[fGROVE] = capture_kd[fAZTEC] = capture_kd[fRIFA] = unix;
	bizwar_kd[fLCN] = bizwar_kd[fYAKUZA] = bizwar_kd[fRM] = unix;

	return true;
}

public OnGameModeExit() {
    SaveServer();
	mysql_close(connects);
	for(new i; i < MAX_ACTORSS; i++) DestroyActor(actor[i]);
	print("Gamemode ended.");
	return true;
}

public OnRconCommand(cmd[]) {
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle) {
	printf("[OnQueryError]: query: %s, error: %s, callback: %s", query, error, callback);
	return print(query);
}

public OnOutcomingRPC(playerid, rpcid, BitStream:bs) {
	if (playerid == -1) {
		return true;
	}
	if(TI[playerid][loadingMode] == 1) {
		if (rpcid == 84 || rpcid == 44) {
			TI[playerid][loadingMode] = 2;
			PlayerTextDrawTextSize(playerid,LoadTexturess[playerid], 211.777893+26*2, 0.000000);
			PlayerTextDrawShow(playerid,LoadTexturess[playerid]);
		}
	}
	else if (TI[playerid][loadingMode] == 2) {
		if(rpcid == 84 || rpcid == 44) {
			TI[playerid][loadingModelPlayer] = 0;
			PlayerTextDrawTextSize(playerid,LoadTexturess[playerid], 211.777893+26*4, 0.000000);
			PlayerTextDrawShow(playerid,LoadTexturess[playerid]);
		}
		else {
			TI[playerid][loadingModelPlayer]++;
			if(TI[playerid][loadingModelPlayer] > 3) {
				TI[playerid][loadingMode] = 0;
				PlayerTextDrawTextSize(playerid,LoadTexturess[playerid], 211.777893, 0.000000);
				for(new i; i < 4; i ++) TextDrawHideForPlayer(playerid, LoadTextures[i]); // Закрываем TextDraw'ы
				PlayerTextDrawHide(playerid, LoadTexturess[playerid]); // Показываем TextDraw'ы
				TogglePlayerControllable(playerid, true); // Размораживаем игрока
			}
		}
	}
	return true;
}