#if defined _tech_center_and_stage_included
    #endinput
#endif
#define _tech_center_and_stage_included

#include <a_samp>

// Автоматическое подключение pawn.cmd для работы callcmd::
#if !defined PC_EmulateCommand
    #tryinclude <pawn.cmd>
#endif

// --- [ Константы ] ---
#if !defined DIALOG_TUNING_STAGE
    #define DIALOG_TUNING_STAGE 5500 
#endif

#define ENTER_CARPASS 13

#define ACCEL_STOCK      10.0
#define ACCEL_COMFORT    25.6
#define ACCEL_SPORT      35.6
#define ACCEL_SPORT_PLUS 45.6
#define ACCEL_TURBO      60.6
#define ACCEL_TURBO_PLUS 500.0

// --- [ Переменные системы ] ---
#if !defined g_TuningType
    new g_TuningType[MAX_PLAYERS];
#endif

#if !defined CurrentVehicleAccel
    new CurrentVehicleAccel[MAX_VEHICLES];
#endif

#if !defined IsDriftEnabled
    new bool:IsDriftEnabled[MAX_VEHICLES];
#endif


// --- [ База данных Тех-Центра ] ---
// Числовые данные: {id, type, selector, tuneId, currency}
static const tuneData[][] = {
    {0, 25, 42, 1009, 0}, {1, 25, 42, 1008, 0}, {2, 25, 42, 1010, 0}, // Нитро
    {4, 15, 36, 0, 0},    {5, 15, 36, 1, 0},    {6, 15, 36, 2, 0},    {7, 15, 36, 3, 1}, // Сцепление
    {9, 16, 37, 0, 0},    {10, 16, 37, 1, 0},   {11, 16, 37, 2, 0},   {12, 16, 37, 3, 1}, // Тормоза
    {14, 17, 38, 0, 0},   {15, 17, 38, 1, 0},   {16, 17, 38, 2, 0},   {17, 17, 38, 3, 1}, // Впуск
    {19, 18, 39, 0, 0},   {20, 18, 39, 1, 0},   {21, 18, 39, 2, 0},   {22, 18, 39, 3, 1}, // Двигатель
    {24, 19, 40, 0, 0},   {25, 19, 40, 1, 0},   {26, 19, 40, 2, 0},   {27, 19, 40, 3, 1}, // Нагнетатель
    {35, 22, 41, 36, 1}   // Лаунч-контроль
};

// Текстовые названия деталей - Четко фиксируем размер ячеек
static const tuneNames[][32] = {
    "Нитро 2Х", "Нитро 5Х", "Нитро 10Х",
    "COMFORT", "SPORT", "DRIFT", "SPORT+", 
    "COMFORT", "SPORT", "DRIFT", "SPORT+", 
    "COMFORT", "SPORT", "DRIFT", "SPORT+", 
    "COMFORT", "SPORT", "DRIFT", "SPORT+", 
    "COMFORT", "SPORT", "DRIFT", "SPORT+", 
    "Лаунч-контроль"
};

// Текстовые иконки деталей - Четко фиксируем размер ячеек
static const tuneImages[][32] = {
    "t_nitro_icon", "t_nitro_icon", "t_nitro_icon",
    "t_differential_icon", "t_differential_icon", "t_differential_icon", "t_differential_icon",
    "t_brakers_icon", "t_brakers_icon", "t_brakers_icon", "t_brakers_icon",
    "t_air_filter_icon", "t_air_filter_icon", "t_air_filter_icon", "t_air_filter_icon",
    "t_engine_icon", "t_engine_icon", "t_engine_icon", "t_engine_icon",
    "t_supercharger_icon", "t_supercharger_icon", "t_supercharger_icon", "t_supercharger_icon",
    "t_launch_control"
};

// --- [ Вспомогательные RPC функции ] ---
stock SetVehicleSpeedForPlayer(playerid, vehicleid, Float:speed)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 4, PR_FLOAT, speed);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleDrifttForPlayer(playerid, vehicleid, bool:enable)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 5); 
    BS_WriteValue(bs, PR_UINT16, vehicleid); 
    BS_WriteValue(bs, PR_UINT8, enable); 
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleDriftt(vehicleid, bool:enable)
{
    if (!IsValidVehicle(vehicleid)) return 0;
    vInfo[vehicleid][vDrift] = enable; 
    foreach(new playerid : Player)
    {
        SetVehicleDrifttForPlayer(playerid, vehicleid, enable);
    }
    return 1;
}

stock SetVehicleAccelerationForPlayer(playerid, vehicleid, Float:accel)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 5, PR_FLOAT, accel);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

// --- [ Клики в интерфейсе Тех-Центра (Покупка деталей) ] ---
forward OnTechCenterClick(playerid, item_id);
public OnTechCenterClick(playerid, item_id)
{
    if(g_TuningType[playerid] != 2) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || vehicleid != GetPlayerOwnableCar(playerid)) return 1;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new sql_id = g_ownable_car[index][OC_SQL_ID];
    if(sql_id <= 0) return SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}Транспорт не зарегистрирован в базе данных!");

    new idx = -1;
    for(new i = 0; i < sizeof(tuneData); i++)
    {
        if(tuneData[i][0] == item_id) { idx = i; break; }
    }
    if(idx == -1) return 0;

    new detail_type  = tuneData[idx][1]; // 15, 16, 17, 18, 19, 25
    new selector_id  = tuneData[idx][2];
    new tune_id_val  = tuneData[idx][3]; // 0 - Comfort, 1 - Sport, 2 - Drift, 3 - Sport+
    new detail_level = tune_id_val + 1; 

    new query[256];

    // ОБРАБОТКА НИТРО
    if(detail_type == 25) 
    {
        // tune_id_val уже содержит component ID: 1009=X2, 1008=X5, 1010=X10
        new comp_id = tune_id_val;

        // Текущее нитро из vInfo (там хранится component ID напрямую)
        new cur_comp = vInfo[vehicleid][viNitro];

        // Уже стоит такое же
        if(cur_comp == comp_id)
        {
            ShowNotificationMisters(playerid, 2, 5, -1, -1, "Нитро уже установлено!", "");
            return SendJsonFailPacket(playerid, selector_id, item_id);
        }

        // Снимаем старое нитро если было
        if(cur_comp > 0)
            RemoveVehicleComponent(vehicleid, cur_comp);

        // Сохраняем component ID напрямую в tuning_nitro
        // (LoadVehicleTuningFromCache читает это поле и передаёт в AddVehicleComponent напрямую)
        vInfo[vehicleid][viNitro] = comp_id;
        mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_nitro` = %d WHERE `id` = %d LIMIT 1", comp_id, sql_id);
        mysql_query(mysql, query, false);

        // Синхронизируем OC_NITRO (для /carpass и techcentergui)
        // OC_NITRO хранит 1/2/3 — конвертируем
        new oc_val;
        if(comp_id == 1009)      oc_val = 1;
        else if(comp_id == 1008) oc_val = 2;
        else if(comp_id == 1010) oc_val = 3;
        g_ownable_car[index][OC_NITRO] = oc_val;

        // Применяем на машину прямо сейчас
        AddVehicleComponent(vehicleid, comp_id);

        SendJsonSuccessPacket(playerid, selector_id, item_id);
        
        ShowNotificationMisters(playerid, 0, 6, -1, -1, "Вы купили нитро", "");
        return 1;
    }

    // ОПРЕДЕЛЯЕМ ИМЯ НОВОГО СТОЛБЦА ИЗ ТЕХ 20, ЧТО ТЫ ДОБАВИЛ В SQL
    new db_field[24];
    if(tune_id_val == 0) // Comfort
    {
        if(detail_type == 15) strmid(db_field, "c_stability", 0, sizeof(db_field));
        else if(detail_type == 16) strmid(db_field, "c_brake", 0, sizeof(db_field));
        else if(detail_type == 17) strmid(db_field, "c_intake", 0, sizeof(db_field));
        else if(detail_type == 18) strmid(db_field, "c_engine", 0, sizeof(db_field));
        else if(detail_type == 19) strmid(db_field, "c_charger", 0, sizeof(db_field));
    }
    else if(tune_id_val == 1) // Sport
    {
        if(detail_type == 15) strmid(db_field, "s_stability", 0, sizeof(db_field));
        else if(detail_type == 16) strmid(db_field, "s_brake", 0, sizeof(db_field));
        else if(detail_type == 17) strmid(db_field, "s_intake", 0, sizeof(db_field));
        else if(detail_type == 18) strmid(db_field, "s_engine", 0, sizeof(db_field));
        else if(detail_type == 19) strmid(db_field, "s_charger", 0, sizeof(db_field));
    }
    else if(tune_id_val == 2) // Drift
    {
        if(detail_type == 15) strmid(db_field, "d_stability", 0, sizeof(db_field));
        else if(detail_type == 16) strmid(db_field, "d_brake", 0, sizeof(db_field));
        else if(detail_type == 17) strmid(db_field, "d_intake", 0, sizeof(db_field));
        else if(detail_type == 18) strmid(db_field, "d_engine", 0, sizeof(db_field));
        else if(detail_type == 19) strmid(db_field, "d_charger", 0, sizeof(db_field));
    }
    else if(tune_id_val == 3) // Sport+
    {
        if(detail_type == 15) strmid(db_field, "sp_stability", 0, sizeof(db_field));
        else if(detail_type == 16) strmid(db_field, "sp_brake", 0, sizeof(db_field));
        else if(detail_type == 17) strmid(db_field, "sp_intake", 0, sizeof(db_field));
        else if(detail_type == 18) strmid(db_field, "sp_engine", 0, sizeof(db_field));
        else if(detail_type == 19) strmid(db_field, "sp_charger", 0, sizeof(db_field));
    }

    // Проверяем статус в БД напрямую перед покупкой
    mysql_format(mysql, query, sizeof(query), "SELECT `%s` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", db_field, sql_id);
    new Cache:res_check = mysql_query(mysql, query, true);
    new is_already_bought = cache_get_field_content_int(0, db_field);
    cache_delete(res_check);

    if(is_already_bought == 1)
    {
        ShowNotificationMisters(playerid, 2, 5, -1, -1, "Эта деталь уже установлена на ваш автомобиль!", "");
        return SendJsonFailPacket(playerid, selector_id, item_id);
    }

    // ЗАПИСЫВАЕМ ФАКТ ПОКУПКИ (Выставляем 1 в личный столбец)
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s` = 1 WHERE `id` = %d LIMIT 1", db_field, sql_id);
    mysql_query(mysql, query, false);

    // Дополнительно обновляем ходовые характеристики pt_ столбцов, чтобы деталь применилась прямо сейчас
    new main_field[24];
    if(detail_type == 15)      strmid(main_field, "pt_stability", 0, sizeof(main_field));
    else if(detail_type == 16) strmid(main_field, "pt_brake", 0, sizeof(main_field));
    else if(detail_type == 17) strmid(main_field, "pt_intake", 0, sizeof(main_field));
    else if(detail_type == 18) strmid(main_field, "pt_engine", 0, sizeof(main_field));
    else if(detail_type == 19) strmid(main_field, "pt_charger", 0, sizeof(main_field));

    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s` = %d WHERE `id` = %d LIMIT 1", main_field, detail_level, sql_id);
    mysql_query(mysql, query, false);

    // Обновляем кэш массива g_ownable_car
    if(detail_type == 15)      g_ownable_car[index][OC_PT_STABILITY] = detail_level;
    else if(detail_type == 16) g_ownable_car[index][OC_PT_BRAKE]     = detail_level;
    else if(detail_type == 17) g_ownable_car[index][OC_PT_INTAKE]    = detail_level;
    else if(detail_type == 18) g_ownable_car[index][OC_PT_ENGINE]    = detail_level;
    else if(detail_type == 19) g_ownable_car[index][OC_PT_CHARGER]   = detail_level;

    // Считаем прогресс собранной прошивки (сколько деталей этого уровня уже куплено в БД)
    new field_prefix[8];
    if(tune_id_val == 0)      strmid(field_prefix, "c_", 0, sizeof(field_prefix));
    else if(tune_id_val == 1) strmid(field_prefix, "s_", 0, sizeof(field_prefix));
    else if(tune_id_val == 2) strmid(field_prefix, "d_", 0, sizeof(field_prefix));
    else if(tune_id_val == 3) strmid(field_prefix, "sp_", 0, sizeof(field_prefix));

    mysql_format(mysql, query, sizeof(query), "SELECT `%sstability`, `%sbrake`, `%sintake`, `%sengine`, `%scharger` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", field_prefix, field_prefix, field_prefix, field_prefix, field_prefix, sql_id);
    new Cache:res_count = mysql_query(mysql, query, true);

    // ИСПРАВЛЕНО (ФИКС ОШИБКИ 035): Собираем полные строковые имена столбцов для получения данных из кэша
    new f_stab[24], f_brk[24], f_int[24], f_eng[24], f_chg[24];
    format(f_stab, sizeof(f_stab), "%sstability", field_prefix);
    format(f_brk, sizeof(f_brk), "%sbrake", field_prefix);
    format(f_int, sizeof(f_int), "%sintake", field_prefix);
    format(f_eng, sizeof(f_eng), "%sengine", field_prefix);
    format(f_chg, sizeof(f_chg), "%scharger", field_prefix);

    // Передаем имена столбцов строками, полностью ликвидируя несоответствие типов
    new detail_count = cache_get_field_content_int(0, f_stab) + 
                       cache_get_field_content_int(0, f_brk) + 
                       cache_get_field_content_int(0, f_int) + 
                       cache_get_field_content_int(0, f_eng) + 
                       cache_get_field_content_int(0, f_chg);
    cache_delete(res_count);

    // Уведомление
    new item_category_name[32];
    if(detail_type == 15)      strmid(item_category_name, "сцепление", 0, sizeof(item_category_name));
    else if(detail_type == 16) strmid(item_category_name, "тормоза", 0, sizeof(item_category_name));
    else if(detail_type == 17) strmid(item_category_name, "впуск", 0, sizeof(item_category_name));
    else if(detail_type == 18) strmid(item_category_name, "чип двигателя", 0, sizeof(item_category_name));
    else if(detail_type == 19) strmid(item_category_name, "нагнетатель", 0, sizeof(item_category_name));

    new level_name[32];
    format(level_name, sizeof(level_name), "%s", tuneNames[idx]);
    new msg_string[128];
    format(msg_string, sizeof(msg_string), "Вы купили %s %s деталей %d/5", item_category_name, level_name, detail_count);
    new sub_string[32];
    strmid(sub_string, "Успешная установка", 0, sizeof(sub_string));
    ShowNotificationMisters(playerid, 0, 6, 0, 0, msg_string, sub_string);

    SendJsonSuccessPacket(playerid, selector_id, item_id);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    return 1;
}


stock SendJsonFailPacket(playerid, selector_id, item_id) {
    new Node:json_fail = JSON_Object();
    // "t" должен совпадать с selector_id (36-42) — клиент ждёт echo типа операции
    JSON_SetInt(json_fail, "t", selector_id);
    JSON_SetInt(json_fail, "s", 0);
    JSON_SetInt(json_fail, "m", selector_id);
    JSON_SetInt(json_fail, "d", item_id);
    JSON_SetInt(json_fail, "r", GetPlayerMoneyEx(playerid));
    OnPacketIncoming(playerid, 28, json_fail);
    JSON_Cleanup(json_fail);
    return 1;
}

stock SendJsonSuccessPacket(playerid, selector_id, item_id) {
    new Node:json_ok = JSON_Object();
    // "t" должен совпадать с selector_id (36-42) — клиент ждёт echo типа операции
    JSON_SetInt(json_ok, "t", selector_id);
    JSON_SetInt(json_ok, "s", 1);
    JSON_SetInt(json_ok, "m", selector_id);
    JSON_SetInt(json_ok, "d", item_id);
    JSON_SetInt(json_ok, "r", GetPlayerMoneyEx(playerid));
    OnPacketIncoming(playerid, 28, json_ok);
    JSON_Cleanup(json_ok);
    return 1;
}

// --- [ Открытие GUI Тех-Центра лаунчера (Выгрузка статусов) ] ---
CMD:techcentergui(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid) return SendClientMessage(playerid, -1, "{FF0000}Вы должны быть в машине!");

    if(vehicleid != GetPlayerOwnableCar(playerid))
    {
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка: Техцентр доступен только для личного транспорта!");
    }

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new sql_id = g_ownable_car[index][OC_SQL_ID];
    if(sql_id <= 0) return SendClientMessage(playerid, -1, "{FF0000}Ошибка: Автомобиль отсутствует в базе данных!");

    // ВЫГРУЖАЕМ СОСТОЯНИЕ ВСЕХ 20 СТОЛБЦОВ ТЮНИНГА И НИТРО ОДНОВРЕМЕННО
    new query[384];
    mysql_format(mysql, query, sizeof(query), "SELECT `tuning_nitro`, `c_stability`,`c_brake`,`c_intake`,`c_engine`,`c_charger`, `s_stability`,`s_brake`,`s_intake`,`s_engine`,`s_charger`, `d_stability`,`d_brake`,`d_intake`,`d_engine`,`d_charger`, `sp_stability`,`sp_brake`,`sp_intake`,`sp_engine`,`sp_charger` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", sql_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(!cache_num_rows()) return cache_delete(result), SendClientMessage(playerid, -1, "{FF0000}Ошибка чтения данных из БД!");

    new db_nitro = cache_get_field_content_int(0, "tuning_nitro");
    
    // ИСПРАВЛЕНО (ФИКС ОШИБКИ 035): Заменяем числовой цикл на явное чтение по именам столбцов в кавычках
    new comfort_vals[5], sport_vals[5], drift_vals[5], sportplus_vals[5];

    // 1. Выгружаем Comfort
    comfort_vals[0] = cache_get_field_content_int(0, "c_stability");
    comfort_vals[1] = cache_get_field_content_int(0, "c_brake");
    comfort_vals[2] = cache_get_field_content_int(0, "c_intake");
    comfort_vals[3] = cache_get_field_content_int(0, "c_engine");
    comfort_vals[4] = cache_get_field_content_int(0, "c_charger");

    // 2. Выгружаем Sport
    sport_vals[0] = cache_get_field_content_int(0, "s_stability");
    sport_vals[1] = cache_get_field_content_int(0, "s_brake");
    sport_vals[2] = cache_get_field_content_int(0, "s_intake");
    sport_vals[3] = cache_get_field_content_int(0, "s_engine");
    sport_vals[4] = cache_get_field_content_int(0, "s_charger");

    // 3. Выгружаем Drift
    drift_vals[0] = cache_get_field_content_int(0, "d_stability");
    drift_vals[1] = cache_get_field_content_int(0, "d_brake");
    drift_vals[2] = cache_get_field_content_int(0, "d_intake");
    drift_vals[3] = cache_get_field_content_int(0, "d_engine");
    drift_vals[4] = cache_get_field_content_int(0, "d_charger");

    // 4. Выгружаем Sport Plus
    sportplus_vals[0] = cache_get_field_content_int(0, "sp_stability");
    sportplus_vals[1] = cache_get_field_content_int(0, "sp_brake");
    sportplus_vals[2] = cache_get_field_content_int(0, "sp_intake");
    sportplus_vals[3] = cache_get_field_content_int(0, "sp_engine");
    sportplus_vals[4] = cache_get_field_content_int(0, "sp_charger");

    cache_delete(result);

    g_TuningType[playerid] = 2; 

    new Node:tuning_json = JSON_Object();
    new Node:k_array = JSON_Array(); 

    for(new i = 0; i < sizeof(tuneData); i++)
    {
        new Node:item = JSON_Object();
        
        new item_id      = tuneData[i][0];
        new detail_type  = tuneData[i][1];
        new selector_val = tuneData[i][2];
        new tune_id_val  = tuneData[i][3]; // 0 - Comfort, 1 - Sport, 2 - Drift, 3 - Sport+
        new currency_val = tuneData[i][4];
        
        new is_installed = 0; 

        if(detail_type == 25) // Подсветка Нитро
        {
            // tuning_nitro хранит component ID напрямую (1009/1008/1010)
            if(db_nitro == tune_id_val) is_installed = 1;
        }
        else // Подсветка кнопок на основе индивидуальных 20 столбцов
        {
            new bit_idx = 0;
            if(detail_type == 15) bit_idx = 0;
            else if(detail_type == 16) bit_idx = 1;
            else if(detail_type == 17) bit_idx = 2;
            else if(detail_type == 18) bit_idx = 3;
            else if(detail_type == 19) bit_idx = 4;

            if(tune_id_val == 0 && comfort_vals[bit_idx] == 1) is_installed = 1;
            else if(tune_id_val == 1 && sport_vals[bit_idx] == 1) is_installed = 1;
            else if(tune_id_val == 2 && drift_vals[bit_idx] == 1) is_installed = 1;
            else if(tune_id_val == 3 && sportplus_vals[bit_idx] == 1) is_installed = 1;
        }

        JSON_SetInt(item, "id", item_id);
        JSON_SetInt(item, "type", detail_type);
        JSON_SetInt(item, "selector", selector_val);
        JSON_SetInt(item, "tuneId", tune_id_val);
        JSON_SetInt(item, "currency", currency_val);
        JSON_SetString(item, "name", tuneNames[i]);
        JSON_SetString(item, "imageId", tuneImages[i]);
        JSON_SetInt(item, "def", is_installed); 
        
        JSON_Append(k_array, item);
    }

    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "o", 1); 
    JSON_SetInt(tuning_json, "j", 0); 
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", "Транспорт"); 
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    SetPlayerInterior(playerid, 1);

    SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5);
    SetVehicleZAngle(vehicleid, -90.0);

    SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
    SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);

    OnPacketIncoming(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json); 
    return 1;
}


// ==========================================
//    КОМАНДЫ АКТИВАЦИИ ПРОШИВОК (STAGE)
// ==========================================

CMD:comfort(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new index = GetVehicleData(vid, V_ACTION_ID);
    if(index < 0 || g_ownable_car[index][OC_SQL_ID] <= 0) 
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Транспорт не зарегистрирован в базе данных!");

    // ПРЯМОЙ ОПРОС БД: Проверяем, куплены ли ВСЕ 5 деталей уровня Comfort (c_...)
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT `c_stability`, `c_brake`, `c_intake`, `c_engine`, `c_charger` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    new Cache:result = mysql_query(mysql, query, true);

    if(!cache_num_rows()) return cache_delete(result), SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Данные авто не найдены в БД!");

    new c_stability = cache_get_field_content_int(0, "c_stability"),
        c_brake     = cache_get_field_content_int(0, "c_brake"),
        c_intake    = cache_get_field_content_int(0, "c_intake"),
        c_engine    = cache_get_field_content_int(0, "c_engine"),
        c_charger   = cache_get_field_content_int(0, "c_charger");
    cache_delete(result);

    if(c_stability != 1 || c_brake != 1 || c_intake != 1 || c_engine != 1 || c_charger != 1)
    {
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Для активации прошивки вам необходимо купить {FF5252}все 5 деталей{FFFFFF} уровня COMFORT!");
    }

    if(CurrentVehicleAccel[vid] == 1) return callcmd::stock(playerid, "");
    
    SetVehicleAccelerationForPlayer(playerid, vid, ACCEL_COMFORT);
    CurrentVehicleAccel[vid] = 1;
    
    // Записываем код активного режима (1) в базу данных
    g_ownable_car[index][OC_LAST_DRIVE_MODE] = 1;
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_drive_mode` = 1 WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    mysql_query(mysql, query, false);

    SendClientMessage(playerid, -1, "{FF5252}Тюнинг: {FFFFFF}Установлен режим {FF5252}Comfort {FFFFFF}(активирован полный комплект деталей)");
    return 1;
}

CMD:sport(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new index = GetVehicleData(vid, V_ACTION_ID);
    if(index < 0 || g_ownable_car[index][OC_SQL_ID] <= 0) 
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Транспорт не зарегистрирован в базе данных!");

    // ПРЯМОЙ ОПРОС БД: Проверяем, куплены ли ВСЕ 5 деталей уровня Sport (s_...)
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT `s_stability`, `s_brake`, `s_intake`, `s_engine`, `s_charger` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    new Cache:result = mysql_query(mysql, query, true);

    if(!cache_num_rows()) return cache_delete(result), SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Данные авто не найдены в БД!");

    new s_stability = cache_get_field_content_int(0, "s_stability"),
        s_brake     = cache_get_field_content_int(0, "s_brake"),
        s_intake    = cache_get_field_content_int(0, "s_intake"),
        s_engine    = cache_get_field_content_int(0, "s_engine"),
        s_charger   = cache_get_field_content_int(0, "s_charger");
    cache_delete(result);

    if(s_stability != 1 || s_brake != 1 || s_intake != 1 || s_engine != 1 || s_charger != 1)
    {
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Для активации прошивки вам необходимо купить {FF5252}все 5 деталей{FFFFFF} уровня SPORT!");
    }

    if(CurrentVehicleAccel[vid] == 2) return callcmd::stock(playerid, "");
    
    SetVehicleAccelerationForPlayer(playerid, vid, ACCEL_SPORT);
    CurrentVehicleAccel[vid] = 2;
    
    // Записываем код активного режима (2) в базу данных
    g_ownable_car[index][OC_LAST_DRIVE_MODE] = 2;
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_drive_mode` = 2 WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    mysql_query(mysql, query, false);

    SendClientMessage(playerid, -1, "{FF5252}Тюнинг: {FFFFFF}Установлена прошивка {FF5252}Sport {FFFFFF}(активирован полный комплект деталей)");
    return 1;
}

CMD:sportplus(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new index = GetVehicleData(vid, V_ACTION_ID);
    if(index < 0 || g_ownable_car[index][OC_SQL_ID] <= 0) 
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Транспорт не зарегистрирован в базе данных!");

    // ПРЯМОЙ ОПРОС БД: Проверяем, куплены ли ВСЕ 5 деталей уровня Sport+ (sp_...)
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT `sp_stability`, `sp_brake`, `sp_intake`, `sp_engine`, `sp_charger` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    new Cache:result = mysql_query(mysql, query, true);

    if(!cache_num_rows()) return cache_delete(result), SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Данные авто не найдены в БД!");

    new sp_stability = cache_get_field_content_int(0, "sp_stability"),
        sp_brake     = cache_get_field_content_int(0, "sp_brake"),
        sp_intake    = cache_get_field_content_int(0, "sp_intake"),
        sp_engine    = cache_get_field_content_int(0, "sp_engine"),
        sp_charger   = cache_get_field_content_int(0, "sp_charger");
    cache_delete(result);

    if(sp_stability != 1 || sp_brake != 1 || sp_intake != 1 || sp_engine != 1 || sp_charger != 1)
    {
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Для активации прошивки вам необходимо купить {FF5252}все 5 деталей{FFFFFF} уровня SPORT+!");
    }

    if(CurrentVehicleAccel[vid] == 3) return callcmd::stock(playerid, "");
    
    SetVehicleAccelerationForPlayer(playerid, vid, ACCEL_SPORT_PLUS);
    CurrentVehicleAccel[vid] = 3;
    
    // Записываем код активного режима (3) в базу данных
    g_ownable_car[index][OC_LAST_DRIVE_MODE] = 3;
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_drive_mode` = 3 WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    mysql_query(mysql, query, false);

    SendClientMessage(playerid, -1, "{FF5252}Тюнинг: {FFFFFF}Установлена прошивка {FF5252}Sport+ {FFFFFF}(активирован полный комплект деталей)");
    return 1;
}

CMD:drift(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new index = GetVehicleData(vid, V_ACTION_ID);
    if(index < 0 || g_ownable_car[index][OC_SQL_ID] <= 0) 
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Транспорт не зарегистрирован в базе данных!");

    // ПРЯМОЙ ОПРОС БД: Проверяем, куплены ли ВСЕ 5 деталей уровня Drift (d_...)
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT `d_stability`, `d_brake`, `d_intake`, `d_engine`, `d_charger` FROM `ownable_cars` WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_SQL_ID]);
    new Cache:result = mysql_query(mysql, query, true);

    if(!cache_num_rows()) return cache_delete(result), SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Данные авто не найдены в БД!");

    new d_stability = cache_get_field_content_int(0, "d_stability"),
        d_brake     = cache_get_field_content_int(0, "d_brake"),
        d_intake    = cache_get_field_content_int(0, "d_intake"),
        d_engine    = cache_get_field_content_int(0, "d_engine"),
        d_charger   = cache_get_field_content_int(0, "d_charger");
    cache_delete(result);

    if(d_stability != 1 || d_brake != 1 || d_intake != 1 || d_engine != 1 || d_charger != 1)
    {
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Для активации прошивки вам необходимо купить {FF5252}все 5 деталей{FFFFFF} уровня DRIFT!");
    }

    IsDriftEnabled[vid] = !IsDriftEnabled[vid];
    SetVehicleDriftt(vid, IsDriftEnabled[vid]); 

    // Записываем код режима в БД (4 - дрифт активен, 0 - выключен)
    g_ownable_car[index][OC_LAST_DRIVE_MODE] = IsDriftEnabled[vid] ? (4) : (0);
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_drive_mode` = %d WHERE `id` = %d LIMIT 1", g_ownable_car[index][OC_LAST_DRIVE_MODE], g_ownable_car[index][OC_SQL_ID]);
    mysql_query(mysql, query, false);

    SendClientMessage(playerid, -1, IsDriftEnabled[vid] ? ("{FF5252}Дрифт: {FFFFFF}Включен") : ("{FF5252}Дрифт: {FFFFFF}Выключен"));
    return 1;
}

CMD:turbo(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    if(CurrentVehicleAccel[vid] == 4) return callcmd::stock(playerid, "");
    
    SetVehicleAccelerationForPlayer(playerid, vid, ACCEL_TURBO);
    SetVehicleSpeedForPlayer(playerid, vid, 654.0);
    CurrentVehicleAccel[vid] = 4;
    SendClientMessage(playerid, -1, "{FF5252}Тюнинг: {FFFFFF}Временно установлена прошивка {FF5252}Turbo {FFFFFF}(сбросится после рестарта)");
    return 1;
}

CMD:turboplus(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    if(CurrentVehicleAccel[vid] == 5) return callcmd::stock(playerid, "");
    
    SetVehicleAccelerationForPlayer(playerid, vid, ACCEL_TURBO_PLUS);
    SetVehicleSpeedForPlayer(playerid, vid, 1200.0);
    CurrentVehicleAccel[vid] = 5;
    SendClientMessage(playerid, -1, "{FF5252}Тюнинг: {FFFFFF}Временно установлена прошивка {FF5252}Turbo+ {FFFFFF}(сбросится после рестарта)");
    return 1;
}

CMD:stock(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    // Временно сбрасываем характеристики машины в заводской сток для текущей сессии игры
    SetVehicleAccelerationForPlayer(playerid, vid, 10.0); 
    SetVehicleSpeedForPlayer(playerid, vid, 250.0);

    if(IsDriftEnabled[vid]) {
        IsDriftEnabled[vid] = false;
        SetVehicleDriftt(vid, false);
    }
    
    CurrentVehicleAccel[vid] = 0;
    
    // В СУБД изменения не отправляем, чтобы после рестарта или спавна вернулась законная прошивка
    SendClientMessage(playerid, -1, "{FFFFFF}Прошивки временно сброшены. {66FF66}После рестарта вернется сохраненный режим.");
    return 1;
}

// --- [ Меню выбора прошивок Dialog ] ---
CMD:stage(playerid, params[])
{
    if(GetPlayerGarage(playerid) == -1)
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Для чип-тюнинга автомобиля вам необходимо владеть личным гаражом!");

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
        return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Вы должны быть за рулем!");

    new vid = GetPlayerVehicleID(playerid);
    new index = GetVehicleData(vid, V_ACTION_ID);
    if(index < 0 || g_ownable_car[index][OC_SQL_ID] <= 0) return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Этот транспорт не поддерживает прошивки!");

    static const list_fmt[] = "\
        {FFFFFF}1. Stock {66FF66}(Сброс)\n\
        {FFFFFF}2. Comfort\n\
        {FFFFFF}3. Sport\n\
        {FFFFFF}4. Sport+\n\
        {FFFFFF}5. Turbo\n\
        {FFFFFF}6. Drift Mode %s";
    
    new listitems[sizeof(list_fmt) + 16];
    format(listitems, sizeof(listitems), list_fmt, IsDriftEnabled[vid] ? ("{66FF66}[ON]") : ("{FF5252}[OFF]"));

    ShowPlayerDialog(playerid, DIALOG_TUNING_STAGE, DIALOG_STYLE_LIST, "{FF5252}Тюнинг автомобиля", listitems, "Выбрать", "Закрыть");
    return 1;
}

// --- [ Перехват событий диалога ] ---
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TUNING_STAGE)
    {
        if(!response) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
            return SendClientMessage(playerid, -1, "{FF5252}Ошибка: {FFFFFF}Вы должны быть за рулем!");

        // Вызовы команд строго через синтаксис callcmd:: вашего процессора
        switch(listitem)
        {
            case 0: callcmd::stock(playerid, "");
            case 1: callcmd::comfort(playerid, "");
            case 2: callcmd::sport(playerid, "");
            case 3: callcmd::sportplus(playerid, "");
            case 4: callcmd::turbo(playerid, "");
            case 5: callcmd::drift(playerid, "");
        }
        return 1;
    }

    #if defined CT_OnDialogResponse
        return CT_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse CT_OnDialogResponse
#if defined CT_OnDialogResponse
    forward CT_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnVehicleSpawn(vehicleid)
{
    IsDriftEnabled[vehicleid] = false;
    CurrentVehicleAccel[vehicleid] = 0;

    #if defined CT_OnVehicleSpawn
        return CT_OnVehicleSpawn(vehicleid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define _ALS_OnVehicleSpawn
#endif
#define OnVehicleSpawn CT_OnVehicleSpawn
#if defined CT_OnVehicleSpawn
    forward CT_OnVehicleSpawn(vehicleid);
#endif

forward CloseTechCenter(playerid);
public CloseTechCenter(playerid)
{
    g_TuningType[playerid] = 0;
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetCameraBehindPlayer(playerid);
    
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid) SetVehicleVirtualWorld(vehicleid, 0);
    return 1;
}

#if defined _tech_center_and_stage_included
    #undef _tech_center_and_stage_included
#endif
stock ShowPlayerCarPass(playerid, ownerid)
{
    if(!IsPlayerConnected(ownerid))
        return ShowNotificationMisters(playerid, 2, 5, -1, -1, "Игрок, показавший паспорт, вышел из игры!", "Ошибка");

    new vehicleid = GetPlayerOwnableCar(ownerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return ShowNotificationMisters(playerid, 2, 5, -1, -1, "Транспорт владельца больше не загружен!", "Ошибка");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new sql_id = g_ownable_car[index][OC_SQL_ID];
    new model_id = GetVehicleData(vehicleid, V_MODELID);

    new price = 0;
    // ИСПРАВЛЕНО: расширили лимит проверки моделей до 20 000
    if(model_id >= 400 && model_id <= 20000)
    {
        price = GetVehicleInfo(model_id - 400, VI_PRICE);
    }

    new carpass_text[850];
    format(carpass_text, sizeof(carpass_text), "{FFFFFF}Марка транспорта:\t{3399FF}%s {999999}(ID в БД: %d)\n", GetVehicleName(vehicleid), sql_id);

    new temp_fmt[128]; 

    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Номерной знак:\t\t{3399FF}%s\n", g_ownable_car[index][OC_NUMBER]);
    strcat(carpass_text, temp_fmt);

    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Гос. стоимость:\t\t{66CC33}%d руб.\n", price);
    strcat(carpass_text, temp_fmt);

    new col1 = g_ownable_car[index][OC_COLOR_1]; 
    new col2 = g_ownable_car[index][OC_COLOR_2];
    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Цвет кузова:\t\t{3399FF}ID %d / ID %d\n", col1, col2);
    strcat(carpass_text, temp_fmt);

    switch(g_ownable_car[index][OC_NITRO])
    {
        case 1: strcat(carpass_text, "{FFFFFF}Закись азота (Nitro):\t{66CC33}Установлено (x2)\n");
        case 2: strcat(carpass_text, "{FFFFFF}Закись азота (Nitro):\t{66CC33}Установлено (x5)\n");
        case 3: strcat(carpass_text, "{FFFFFF}Закись азота (Nitro):\t{66CC33}Установлено (x10)\n");
        default: strcat(carpass_text, "{FFFFFF}Закись азота (Nitro):\t{FF5533}Отсутствует\n");
    }

    switch(g_ownable_car[index][OC_TONER_FRONT])
    {
        case 0xFF000000: strcat(carpass_text, "{FFFFFF}Тонировка стекол:\t\t{66CC33}Черная\n");
        case 0xFF0000FF: strcat(carpass_text, "{FFFFFF}Тонировка стекол:\t\t{FF5533}Красная\n");
        case 0x0000FFFF: strcat(carpass_text, "{FFFFFF}Тонировка стекол:\t\t{3399FF}Синяя\n");
        case 0x00FF00FF: strcat(carpass_text, "{FFFFFF}Тонировка стекол:\t\t{00FF00}Зеленая\n");
        default:         strcat(carpass_text, "{FFFFFF}Тонировка стекол:\t\t{FFFFFF}Отсутствует\n");
    }

    switch(vInfo[vehicleid][vNeon1])
    {
        case 0xFFFFFFFF: strcat(carpass_text, "{FFFFFF}Подсветка (Неон):\t{FFFFFF}Белый\n");
        case 0xFC0FC0FF: strcat(carpass_text, "{FFFFFF}Подсветка (Неон):\t{FF00FF}Розовый\n");
        case 0xFF0000FF: strcat(carpass_text, "{FFFFFF}Подсветка (Неон):\t{FF5533}Красный\n");
        case 0x0000FFFF: strcat(carpass_text, "{FFFFFF}Подсветка (Неон):\t{3399FF}Синий\n");
        case 0x00FF00FF: strcat(carpass_text, "{FFFFFF}Подсветка (Неон):\t{00FF00}Зеленый\n");
        default:         strcat(carpass_text, "{FFFFFF}Подсветка (Неон):\t{FFFFFF}Отсутствует\n");
    }

    switch(g_ownable_car[index][OC_STROB])
    {
        case 1: strcat(carpass_text, "{FFFFFF}Стробоскопы:\t\t{66CC33}Обычные (Режим 1)\n\n");
        case 2: strcat(carpass_text, "{FFFFFF}Стробоскопы:\t\t{66CC33}Обычные (Режим 2)\n\n");
        case 3: strcat(carpass_text, "{FFFFFF}Стробоскопы:\t\t{66CC33}Обычные (Режим 3)\n\n");
        case 4: strcat(carpass_text, "{FFFFFF}Стробоскопы:\t\t{FFFF00}Донат-стробоскопы\n\n");
        default: strcat(carpass_text, "{FFFFFF}Стробоскопы:\t\t{FF5533}Отсутствуют\n\n");
    }

    new drive_mode = g_ownable_car[index][OC_LAST_DRIVE_MODE];
    switch(drive_mode)
    {
        case 1: strcat(carpass_text, "{FFFFFF}Прошивка:\\t\\t{66CC33}Comfort");
        case 2: strcat(carpass_text, "{FFFFFF}Прошивка:\\t\\t{3399FF}Sport");
        case 3: strcat(carpass_text, "{FFFFFF}Прошивка:\\t\\t{FF00FF}Sport+");
        case 4: strcat(carpass_text, "{FFFFFF}Прошивка:\\t\\t{FFFF00}Drift");
        default: strcat(carpass_text, "{FFFFFF}Прошивка:\\t\\t{999999}Сток");
    }

    ShowPlayerDialog(playerid, 2716, DIALOG_STYLE_MSGBOX, "{FFCC00}Технический паспорт транспорта", carpass_text, "Закрыть", "");
    return 1;
}


alias:carpass("pts")
CMD:carpass(playerid, params[])
{
    // 1. Проверяем, есть ли личный транспорт у того, кто ввел команду
    if(GetPlayerOwnableCars(playerid) == 0)
        return ShowNotificationMisters(playerid, 2, 6, 0, 0, "У Вас нет личного транспорта", "");

    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return ShowNotificationMisters(playerid, 2, 6, 0, 0, "Ваш личный транспорт не загружен на сервере", "");

    new targetid;

    // 2. Считываем ID. Если параметры пустые (просто /carpass) — автоматически ставим самого себя
    if(sscanf(params, "u", targetid)) 
    {
        targetid = playerid; 
    }

    // 3. ЕСЛИ УКАЗАЛИ ДРУГОГО ИГРОКА — делаем стандартные проверки и шлем плашку
    if(targetid != playerid)
    {
        if(!IsPlayerConnected(targetid))
            return ShowNotificationMisters(playerid, 2, 5, -1, -1, "Такого игрока нет", "");

        new Float:tX, Float:tY, Float:tZ;
        GetPlayerPos(targetid, tX, tY, tZ);
        if(!IsPlayerInRangeOfPoint(playerid, 3.5, tX, tY, tZ))
            return ShowNotificationMisters(playerid, 2, 5, -1, -1, "Игрок находится слишком далеко от Вас", "");

        SetPVarInt(targetid, "carpass_owner_id", playerid);

        new offer_msg[64];
        format(offer_msg, sizeof(offer_msg), "Предложение от %s", GetPlayerNameEx(playerid));
        ShowNotificationMisters(targetid, 4, 6, ENTER_CARPASS, playerid, offer_msg, ">>");

        new msg[128];
        format(msg, sizeof(msg), "Вы предложили посмотреть тех. паспорт игроку %s[%d]", GetPlayerNameEx(targetid), targetid);
        SendClientMessage(playerid, 0x3399FFFF, msg);
        return 1;
    }

    // 4. ЛОГИКА ОТКРЫТИЯ ДЛЯ САМОГО СЕБЯ (если ввели просто /carpass)
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new sql_id = g_ownable_car[index][OC_SQL_ID];
    new model_id = GetVehicleData(vehicleid, V_MODELID);

    new price = 0;
    if(model_id >= 400 && model_id <= 20000)
    {
        price = GetVehicleInfo(model_id - 400, VI_PRICE);
    }

    new temp_fmt[256];
    new carpass_text[1024]; // немного увеличил размер для надёжности

    // Владелец
    format(carpass_text, sizeof(carpass_text), "{FFFFFF}Владелец:\t\t{E0584B}%s\n", GetPlayerNameEx(playerid));

    // Транспорт
    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Транспорт:\t\t{E0584B}%s [%d]\n", GetVehicleName(vehicleid), sql_id);
    strcat(carpass_text, temp_fmt);

    // Номер
    new plate_str[32];
    if(vNumber[vehicleid][npType] > 0 && strlen(vNumber[vehicleid][npNumber]) > 0)
        format(plate_str, sizeof plate_str, "%s [%s]", vNumber[vehicleid][npNumber], vNumber[vehicleid][npRegion]);
    else
        format(plate_str, sizeof plate_str, "%s", GetOwnableCarData(index, OC_NUMBER));

    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Номер:\t\t{E0584B}%s\n", plate_str);
    strcat(carpass_text, temp_fmt);

    // Пробег (добавлено после номера)
    new Float:mileage = GetVehicleData(vehicleid, V_MILEAGE);
    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Пробег:\t\t{E0584B}%07i\n", floatround(mileage, floatround_ceil));
    strcat(carpass_text, temp_fmt);

    // Гос. стоимость
    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Гос. стоимость:\t\t{E0584B}%d руб.\n", price);
    strcat(carpass_text, temp_fmt);

    // ---------- ИЗМЕНЁННЫЙ БЛОК: только активная прошивка ----------
    new tune_str[64];
    if(vInfo[vehicleid][viDrift])
        format(tune_str, sizeof(tune_str), "{E0584B}Drift");
    else if(CurrentVehicleAccel[vehicleid] == 1)
        format(tune_str, sizeof(tune_str), "{E0584B}Comfort");
    else if(CurrentVehicleAccel[vehicleid] == 2)
        format(tune_str, sizeof(tune_str), "{E0584B}Sport");
    else if(CurrentVehicleAccel[vehicleid] == 3)
        format(tune_str, sizeof(tune_str), "{E0584B}Sport+");
    else
        format(tune_str, sizeof(tune_str), "{E0584B}Сток");

    format(temp_fmt, sizeof(temp_fmt), "{FFFFFF}Прошивка:\t\t%s\n", tune_str);
    strcat(carpass_text, temp_fmt);
    // ---------------------------------------------------------------

    // Нитро
    switch(g_ownable_car[index][OC_NITRO])
    {
        case 1: strcat(carpass_text, "{FFFFFF}Нитро:\t\t{E0584B}x2\n");
        case 2: strcat(carpass_text, "{FFFFFF}Нитро:\t\t{E0584B}x5\n");
        case 3: strcat(carpass_text, "{FFFFFF}Нитро:\t\t{E0584B}x10\n");
        default: strcat(carpass_text, "{FFFFFF}Нитро:\t\t{E0584B}Отсутствует\n");
    }

    ShowPlayerDialog(playerid, 2719, DIALOG_STYLE_LIST, "{FFCC00}Тех. паспорт", carpass_text, "Закрыть", "");
    return 1;
}
