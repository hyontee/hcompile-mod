//>> Файл: bykranin_src/core/decl/funcs_01.inc  (609 строк)
//>> Тема: макросы, константы, enum и глобальные массивы (данные, без логики)
//>> Внутри: GetRemapName, GetVehicleCarMarketID, BuyCarTDsShowForPlayer, BuyCarTDsHideForPlayer, ShowConnectPanelAC, ShowWarningPanelAC, IsAutosalonInfiniteStock
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
new cars_after_purchase_count[5];
new cars_after_purchase_limit[4] = {5, 6, 5, 5};
new
	Float: cars_pos_after_purchase[4][6][4] =
{
	{ // --- Мото-салон
		{727.4211,641.1423,12.0930,249.6270},
		{734.3118,659.4240,12.0928,249.0372},
		{741.0107,677.0425,12.0931,249.4603},
		{745.9255,689.8022,12.0931,249.8988},
		{757.3745,719.7014,12.1885,249.3062},
		{757.3745,719.7014,12.1885,249.3062}
	},
	{ // --- низк класс
		{810.483520,516.262390,12.064481,334.560638},
		{813.528137,514.833679,12.019169,335.904052},
		{817.213928,514.600708,12.008749,335.346496},
		{820.282226,513.258117,12.008749,336.126007},
		{823.382446,511.629516,12.008749,337.763824},
		{830.768005,529.822753,12.008749,335.522369}
	},
	{ // --- прем класс
		{679.412231,2637.056396,12.596967,120},
		{695.105285,2626.832763,12.597441,120},
		{677.361389,2633.763671,12.597142,120},
		{693.275634,2623.485351,12.597107,120},
		{690.896789,2620.379638,12.597354,120},
		{690.896789,2620.379638,12.597354,120}
	},
	{ // --- Cредний класс
		{1371.4735,452.4453,12.6497,149.0897},
		{1375.5096,451.0787,12.6476,146.9182},
		{1378.7089,448.5965,12.6462,149.5981},
		{1382.3378,446.2499,12.6481,148.5284},
		{1389.3162,441.9747,12.6460,148.1852},
		{1389.3162,441.9747,12.6460,148.1852}
	}
};

stock GetRemapName(id, dest[], size)
{
    switch (id)
    {
        case 765: format(dest, size, "remapttbody29");
        case 657: format(dest, size, "remapttbody6");
        case 656: format(dest, size, "remapttbody4");
        case 658: format(dest, size, "remapttbody7");
        case 632: format(dest, size, "remapssbody49");
        case 633: format(dest, size, "remapssbody50");
        case 634: format(dest, size, "remapssbody51");
        case 661: format(dest, size, "remapttbody12");
        case 659: format(dest, size, "remapttbody10");
        case 660: format(dest, size, "remapttbody11");
        case 755: format(dest, size, "remapttbody19");
        case 756: format(dest, size, "remapttbody20");
        case 573: format(dest, size, "remapttbody21");
        case 758: format(dest, size, "remapttbody24");
        case 772: format(dest, size, "remapttbody26");
        case 2392: format(dest, size, "remapttbody30");
        case 28661: format(dest, size, "remapttbody35");
        case 28662: format(dest, size, "remapttbody36");
        case 28663: format(dest, size, "remapttbody37");
        case 28680: format(dest, size, "remapttbody41");
        case 28681: format(dest, size, "remapttbody42");
        case 28682: format(dest, size, "remapttbody43");
        case 28683: format(dest, size, "remapttbody44");
        case 28689: format(dest, size, "remapttbody47");
        case 28690: format(dest, size, "remapttbody48");
        case 28706: format(dest, size, "remapttbody54");
        case 28707: format(dest, size, "remapttbody55");
        case 28708: format(dest, size, "remapttbody56");
        case 28709: format(dest, size, "remapttbody57");
        case 28717: format(dest, size, "remapttbody63");
        case 28718: format(dest, size, "remapttbody64");
        case 28719: format(dest, size, "remapttbody65");
        case 28720: format(dest, size, "remapttbody66");
        case 28721: format(dest, size, "remapttbody67");
        case 28724: format(dest, size, "remapttbody59");
        case 28725: format(dest, size, "remapttbody60");
        case 28731: format(dest, size, "remapttbody70");
        case 28732: format(dest, size, "remapttbody71");

		case 28742: format(dest, size, "remapttbody79");
        case 28741: format(dest, size, "remapttbody78");
        case 28740: format(dest, size, "remapttbody77");
        case 28739: format(dest, size, "remapttbody76");
		case 28738: format(dest, size, "remapttbody75");
		case 28751: format(dest, size, "remapttbody83");
		case 28752: format(dest, size, "remapttbody84");

		//блекпассвинилыснизу
		case 28733: format(dest, size, "remapssbody101");
        case 28734: format(dest, size, "remapssbody102");
        case 28735: format(dest, size, "remapssbody103");
        case 28736: format(dest, size, "remapssbody104");
        case 28737: format(dest, size, "remapssbody105");
        case 28744: format(dest, size, "remapssbody106");
        case 28745: format(dest, size, "remapssbody107");
        case 28746: format(dest, size, "remapssbody108");
        case 28747: format(dest, size, "remapssbody109");
        case 28748: format(dest, size, "remapssbody110");
        //конец

        default: dest[0] = '\0';
    }
}
stock GetVehicleCarMarketID(vehicleid)
{
	if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_RENT_CAR) return -1;
	else return GetVehicleData(vehicleid, V_ACTION_ID);
}

stock BuyCarTDsShowForPlayer(playerid)
{
	for(new i; i < 2; i ++)
	{
		TextDrawShowForPlayer(playerid, buy_car_TD[i]);
		PlayerTextDrawShow(playerid, buy_car_PTD[playerid][i]);
	}
	return 1;
}

stock BuyCarTDsHideForPlayer(playerid)
{
	for(new i; i < 6; i ++)
		PlayerTextDrawHide(playerid, buy_car_PTD[playerid][i]);

	TextDrawHideForPlayer(playerid, buy_car_TD[0]);
	TextDrawHideForPlayer(playerid, buy_car_TD[1]);
	return 1;
}

// ------------------------------------------
enum E_ANTI_FLOOD_STRUCT
{
	AF_LAST_TICK,
	AF_RATE
}

// ------------------------------------------
enum E_TEMP_JOB_STRUCT // временные работы
{
	Float: TJ_POS_X,
	Float: TJ_POS_Y,
	Float: TJ_POS_Z,
	TJ_PAY_FOR_LOAD, // плата за 1 продукт (ящик/кг руды)
	TJ_SKIN[2]		// скин игрока (0 - мужской, 1 - женский)
};

/*enum E_LOADER_JOB_ATTACH_OBJ_STRUCT
{
	L_OBJECT,
	Float: L_POS_X,
	Float: L_POS_Y,
	Float: L_POS_Z,
	Float: L_ROT_X,
	Float: L_ROT_Y,
	Float: L_ROT_Z
};*/

// ------------------------------------------
/*enum E_RADAR_STRUCT
{
	R_ID,
	R_CREATOR[21],
	R_LIMIT,
	Float: R_POS_X,
	Float: R_POS_Y,
	Float: R_POS_Z,
	Float: R_POS_RX,
	Float: R_POS_RY,
	Float: R_POS_RZ,
	Float: R_ZONE_X,
	Float: R_ZONE_Y,
	Float: R_ZONE_Z,
	R_OBJECT,
	R_ZONE,
	Text3D: R_LABEL
}
new g_radar[MAX_RADARS][E_RADAR_STRUCT]; // радары для ГИБДД
new player_radar_object[MAX_PLAYERS] = INVALID_OBJECT_ID; // ид объекта во время создания
new Float: player_radar_position[MAX_PLAYERS][9]; // позиция радара
new g_radars_created;*/

new Text3D: player_test_label[MAX_PLAYERS][4];

/*new g_radar_default_values[E_RADAR_STRUCT] =
{
	-1,
	"",
	0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	INVALID_OBJECT_ID,
	-1,
	Text3D: -1,
};*/

new Float: vehicle_temp_position[MAX_PLAYERS][4]; // позиция автомобиля при въезде в тюнинг

// ------------------------------------------
enum E_ADVERT_STRUCT
{
	A_CREATOR,
	bool: A_EDIT,
	A_TEXT[128]
}

new g_advert[MAX_ADVERTS][E_ADVERT_STRUCT]; // объявления

new g_advert_created; // кол-во отправленных объявлений

// ------------------------------------------
enum // иды временных работ
{
	TEMP_JOB_NONE = -1,
	// ----------------
	TEMP_JOB_LOADER = 0, 		// грузчик
	TEMP_JOB_MINER, 			// шахтер
	TEMP_JOB_FACTORY_TRUCKER,	// завод (служба доставки)
	TEMP_JOB_FACTORY,			// завод
	TEMP_JOB_LUMBERJACK,			// лесоруб
	TEMP_JOB_FERMA
};

enum //
{
	TEMP_JOB_STATE_NONE,
	// --------
	TEMP_JOB_STATE_LOADER_LOAD, 	// брать груз
	TEMP_JOB_STATE_LOADER_UNLOAD, 	// класть груз
	TEMP_JOB_STATE_LOADER_DROP_LOAD,// уронил груз
	// --------
	TEMP_JOB_STATE_MINER_LOAD, 		// добывать руду
	TEMP_JOB_STATE_MINER_UNLOAD, 	// нести на склад
	TEMP_JOB_STATE_MINER_DROP_LOAD, // уронил руду
	// --------
	TEMP_JOB_STATE_FACTORY_TAKE_MET, // брать Материалы
	TEMP_JOB_STATE_FACTORY_CREATE_P, // делать продукт
	TEMP_JOB_STATE_FACTORY_CREATED,  // делает продукт
	TEMP_JOB_STATE_FACTORY_PUT_PROD, // нести продукт на склад
	TEMP_JOB_STATE_FACTORY_DROP_P,	 // уронил продукт
	// --------
	TEMP_JOB_STATE_LUMBERJACK_CHOP,	 // рубить дрова
	TEMP_JOB_STATE_LUMBERJACK_PUT,	 // нести на склад
	TEMP_JOB_STATE_LUMBERJACK_DROP,	 // уронил дрова
};

// ------------------------------------------
// attached object (TODO)
enum
{
	A_OBJECT_SLOT_SPINE = 0, 		// Торс
	A_OBJECT_SLOT_HEAD, 			// Голова
	A_OBJECT_SLOT_ARM, 				// Плечи
	A_OBJECT_SLOT_HAND, 			// Руки
	A_OBJECT_SLOT_THIGH, 			// Бедра
	A_OBJECT_SLOT_FOOT, 			// Ноги
	A_OBJECT_SLOT_CALF, 			// Голень
	A_OBJECT_SLOT_FOREARM, 			// Предплечье
	A_OBJECT_SLOT_CLAVICLE,			// Ключица
	A_OBJECT_SLOT_NECK, 			// Шея
	A_OBJECT_SLOT_JAW				// Челюсть
};

enum
{
	A_OBJECT_BONE_SPINE = 1, 		// Торс
	A_OBJECT_BONE_HEAD, 			// Голова
	A_OBJECT_BONE_LEFT_ARM, 		// Левое плечо
	A_OBJECT_BONE_RIGHT_ARM, 		// Правое плечо
	A_OBJECT_BONE_LEFT_HAND, 		// Левая рука
	A_OBJECT_BONE_RIGHT_HAND, 		// Правая рука
	A_OBJECT_BONE_LEFT_THIGH, 		// Левое бедро
 	A_OBJECT_BONE_RIGHT_THIGH,		// Правое бедро
	A_OBJECT_BONE_LEFT_FOOT, 		// Левая нога
	A_OBJECT_BONE_RIGHT_FOOT, 		// Правая нога
	A_OBJECT_BONE_RIGHT_CALF, 		// Правая голень
	A_OBJECT_BONE_LEFT_CALF, 		// Левая голень
	A_OBJECT_BONE_LEFT_FOREARM, 	// Левое предплечье
	A_OBJECT_BONE_RIGHT_FOREARM,	// Правое предплечье
	A_OBJECT_BONE_LEFT_CLAVICLE,	// Левая ключица (плечо)
	A_OBJECT_BONE_RIGHT_CLAVICLE,	// Правая ключица (плечо)
	A_OBJECT_BONE_NECK, 			// Шея
	A_OBJECT_BONE_JAW				// Челюсть
};

// ------------------------------------------
enum // шаги регистрации
{
	REGISTER_STATE_PASSWORD = 1, // ввод пароля
	//REGISTER_STATE_EMAIL, 		// ввод емайла
	//REGISTER_STATE_REFER, 		// ввод ника пригласившего игрока
	REGISTER_STATE_SEX, 		// выбор пола
	//REGISTER_STATE_RULES, 		// правила сервера
	REGISTER_STATE_CREATE_ACC 	// создание аккаунта
};

enum // шаги авторизации
{
	LOGIN_STATE_CHECK_BAN = 0,	// проверка бана
	LOGIN_STATE_PASSWORD, 		// ввод пароля
	LOGIN_STATE_PHONE,			// ввод 5 послед. цифр телефона
	LOGIN_STATE_PIN_CODE,		// ввод пин кода
	//LOGIN_STATE_GOOGLE_CODE,	// ввод кода от гугла
	LOGIN_STATE_LOAD_ACC	 	// Загрузка аккаунта
};
// ------------------------------------------
new mysql; // пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
new str[1024];
new engine, lights, alarm, doors;

//#include "../include/anticheat.inc"
forward GivePlayerMoneyEx(playerid, money, description[]="None", bool:save=true, bool:game_text=true);
forward SendMessageToAdmins(message[], color, a_level = 1);
forward SetVehicleSpeedometerInfo(vehicleid, Float:fuel = 52.0, Float:mileage = 1488.0);
forward SetVehicleSpeedometerInfoFP(playerid, vehicleid, Float:fuel = 52.0, Float:mileage = 1488.0);
forward utf8_to_cp1251(string[]);
forward UpdatePlayerDatabaseString(playerid, field[], value[]);
native gpci(playerid, buffer[], size = sizeof(buffer));


stock ShowConnectPanelAC(playerid)
{
    return 1;
}

stock ShowWarningPanelAC(playerid)
{
    return 1;
}
// ------------------------------------------
new Text: gps_on_TD[1]; 			// gps
new Text: stop_anim_TD[1];			// anim list
new Text: select_TD[6];		// панель выбора
new Text: capture_TD[2];	// статистика для капта



new PlayerText:speedometr_PTD[MAX_PLAYERS][10];
new Text: speedometr_TD[1];
new PlayerText: price_select_TD[MAX_PLAYERS][1]; 	// цена в панели выбора

// ------------------------------------------
new PlayerText:pin_code_PTD[MAX_PLAYERS][10];
new pin_code_value[MAX_PLAYERS][10];
new pin_code_state[MAX_PLAYERS] = {PIN_CODE_STATE_NONE, ...};
new pin_code_input[MAX_PLAYERS][5];

// ------------------------------------------
new Text: radio_edit_TD;	// количество объявлений для редактирования

// ------------------------------------------
//new Menu: reg_select_skin_menu;

// ------------------------------------------

new Menu: admin_spec_menu;
new g_player_inv_offset[MAX_PLAYERS]; // текущая позиция догрузки
new g_player_filter[MAX_PLAYERS]; 
new JSON:g_player_pr_array[MAX_PLAYERS];
new g_player_inventory_count[MAX_PLAYERS]; 
enum E_PLAYER_ITEM
{
    item_ids,
    item_types,
    item_internals,
    item_counts,
    item_case_indexs,
	item_prices
};
#define MAX_PLAYER_MAX_PLAYERSITEMS 1000

new g_player_inventory[MAX_PLAYERS][MAX_PLAYER_MAX_PLAYERSITEMS][E_PLAYER_ITEM];
// ------------------------------------------
new g_player_case[MAX_PLAYERS][1024];
#define MAX_CASE_REWARDS 1000
enum eReward
{
    rCase,
    rItem, 
	rBonus
}

new g_PlayerRewards[MAX_PLAYERS][MAX_CASE_REWARDS][eReward];
new g_PlayerRewardsCount[MAX_PLAYERS];
new g_player_case_rewards[MAX_PLAYERS][1024];
new g_player_case_rewards_bonus[MAX_PLAYERS][1024];
new g_player_case_bonus[MAX_PLAYERS][1024];
forward BlackPass_GetRewardInventoryData(itemid, name[], name_len, &type, &internal, &count, &rarity, &price);
forward BlackPass_AddDust(playerid, amount);
forward BlackPass_GrantExperience(playerid, experience);
forward BlackPass_SendLevelSyncPacket(playerid, level = -1, exp_value = -1);
// ------------------------------------------
new g_player[MAX_PLAYERS][E_PLAYER_STRUCT];

#define MAX_AUTOSALON_SLOT_ROWS (512)

enum E_AUTOSALON_SLOT_STRUCT
{
	AS_MARKET_ID,
	AS_MODEL_ID,
	AS_SLOTS
}

new g_autosalon_slots[MAX_AUTOSALON_SLOT_ROWS][E_AUTOSALON_SLOT_STRUCT];
new g_autosalon_slots_loaded;

#define AUTOSALON_INFINITE_SLOT_VALUE (999999)

stock bool:IsAutosalonInfiniteStock(marketid)
{
	// Все пять салонов: мотосалон, три класса легковых и грузовой салон.
	return (marketid >= 0 && marketid <= 4);
}

stock bool:AutosalonInitTable()
{
	new query[512];
	mysql_format(mysql, query, sizeof query,
        "CREATE TABLE IF NOT EXISTS autosalon (market_id INT NOT NULL, model_id INT NOT NULL, slots INT NOT NULL DEFAULT 0, updated_at INT NOT NULL DEFAULT 0, PRIMARY KEY (market_id, model_id)) ENGINE=InnoDB DEFAULT CHARSET=cp1251");
	mysql_query(mysql, query, false);

	new error = mysql_errno();
	if(error)
	{
        printf("[MYSQL][AUTOSALON] Failed to initialize table, error: %d", error);
		return false;
	}

	return true;
}

stock AutosalonFindSlotRow(marketid, modelid)
{
	for(new idx; idx < g_autosalon_slots_loaded; idx ++)
	{
		if(g_autosalon_slots[idx][AS_MARKET_ID] != marketid) continue;
		if(g_autosalon_slots[idx][AS_MODEL_ID] != modelid) continue;

		return idx;
	}
	return -1;
}

stock AutosalonGetRawSlots(marketid, modelid)
{
	new row = AutosalonFindSlotRow(marketid, modelid);
	if(row == -1) return 0;

	return g_autosalon_slots[row][AS_SLOTS];
}

stock GetAutosalonVehicleSlots(marketid, modelid)
{
	if(!(0 <= marketid <= 4)) return 0;
	if(IsAutosalonInfiniteStock(marketid)) return AUTOSALON_INFINITE_SLOT_VALUE;

	new row = AutosalonFindSlotRow(marketid, modelid);
	if(row != -1) return g_autosalon_slots[row][AS_SLOTS];

	row = AutosalonFindSlotRow(marketid, 0);
	if(row != -1) return g_autosalon_slots[row][AS_SLOTS];

	return 0;
}

stock bool:AutosalonHasVehicleSlots(marketid, modelid)
{
	if(IsAutosalonInfiniteStock(marketid)) return true;
	if(GetAutosalonVehicleSlots(marketid, modelid) > 0) return true;
	return false;
}

stock AutosalonSetVehicleSlots(marketid, modelid, slots)
{
	if(!(0 <= marketid <= 4)) return 0;
	if(slots < 0) slots = 0;

	new query[192];
	mysql_format(mysql, query, sizeof query, "INSERT INTO autosalon (market_id, model_id, slots, updated_at) VALUES (%d, %d, %d, %d) ON DUPLICATE KEY UPDATE slots=%d, updated_at=%d",
		marketid, modelid, slots, gettime(), slots, gettime());
	mysql_query(mysql, query, false);
	if(mysql_errno()) return 0;

	new row = AutosalonFindSlotRow(marketid, modelid);
	if(row == -1)
	{
		if(g_autosalon_slots_loaded >= MAX_AUTOSALON_SLOT_ROWS) return 0;

		row = g_autosalon_slots_loaded++;
		g_autosalon_slots[row][AS_MARKET_ID] = marketid;
		g_autosalon_slots[row][AS_MODEL_ID] = modelid;
	}

	g_autosalon_slots[row][AS_SLOTS] = slots;
	return 1;
}

stock AutosalonAddVehicleSlot(marketid, modelid, amount)
{
	if(IsAutosalonInfiniteStock(marketid)) return 1;

	new slots = AutosalonGetRawSlots(marketid, modelid) + amount;
	if(slots < 0) slots = 0;

	return AutosalonSetVehicleSlots(marketid, modelid, slots);
}

stock bool:AutosalonEnsureVehicleSlotRow(marketid, modelid)
{
	if(AutosalonFindSlotRow(marketid, modelid) != -1) return true;

	new default_row = AutosalonFindSlotRow(marketid, 0);
	if(default_row == -1) return false;

	return AutosalonSetVehicleSlots(marketid, modelid, g_autosalon_slots[default_row][AS_SLOTS]);
}

stock bool:AutosalonTakeVehicleSlot(marketid, modelid, &slot_modelid)
{
	if(IsAutosalonInfiniteStock(marketid))
	{
		slot_modelid = modelid;
		return true;
	}

	if(!AutosalonEnsureVehicleSlotRow(marketid, modelid)) return false;

	new row = AutosalonFindSlotRow(marketid, modelid);
	slot_modelid = modelid;

	if(row == -1) return false;
	if(g_autosalon_slots[row][AS_SLOTS] <= 0) return false;

	new old_slots = g_autosalon_slots[row][AS_SLOTS];
	g_autosalon_slots[row][AS_SLOTS] = old_slots - 1;

	new query[144];
	mysql_format(mysql, query, sizeof query, "UPDATE autosalon SET slots=%d, updated_at=%d WHERE market_id=%d AND model_id=%d LIMIT 1",
		g_autosalon_slots[row][AS_SLOTS], gettime(), marketid, slot_modelid);
	mysql_query(mysql, query, false);
	if(mysql_errno())
	{
		g_autosalon_slots[row][AS_SLOTS] = old_slots;
		return false;
	}

	return true;
}

stock GetCarMarketModelIndex(marketid, modelid)
{
	if(!(0 <= marketid <= 4)) return -1;

	for(new idx; idx < sizeof(car_market_data[]); idx ++)
	{
		if(car_market_data[marketid][idx][CM_MODELID] == modelid)
			return idx;
	}
	return -1;
}

stock LoadAutosalonSlots()
{
	g_autosalon_slots_loaded = 0;
	if(!AutosalonInitTable()) return 0;

	new query[64], Cache: result;
	mysql_format(mysql, query, sizeof query, "SELECT market_id, model_id, slots FROM autosalon");
	result = mysql_query(mysql, query, true);
	if(mysql_errno())
	{
		cache_delete(result);
		return 0;
	}

	new rows = cache_num_rows(result);
	for(new idx; idx < rows && idx < MAX_AUTOSALON_SLOT_ROWS; idx ++)
	{
		g_autosalon_slots[idx][AS_MARKET_ID] = cache_get_field_content_int(idx, "market_id");
		g_autosalon_slots[idx][AS_MODEL_ID] = cache_get_field_content_int(idx, "model_id");
		g_autosalon_slots[idx][AS_SLOTS] = cache_get_field_content_int(idx, "slots");
		g_autosalon_slots_loaded ++;
	}

	cache_delete(result);
	printf("[MYSQL][AUTOSALON] Loaded %d slot rows", g_autosalon_slots_loaded);
	return 1;
}

stock RefreshAutosalonSlotsForPlayers()
{
	foreach(new playerid : Player)
	{
		if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) continue;

		BuyCarPTDUpdate(playerid);
	}
	return 1;
}
