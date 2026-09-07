stock ShowTuningStylingGUI(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Ошибка: Не удалось получить ID автомобиля!");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");

    new owner_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(owner_id, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");
        
     new modelid = GetVehicleData(vehicleid, V_MODELID);

    g_TuningType[playerid] = 0;
    new Node:tuning_json = JSON_Object();
    new price;
    
	GetVehicleJsonCostByModelId(modelid, price);
	 
	 JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));

    
    new name[64];
    GetVehicleModelName(modelid, name, sizeof(name));
    JSON_SetString(tuning_json, "n", name);

    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new Float:x = 1000.0847, Float:y = 1502.3265, Float:z = 1497.5124;
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, 180.0);

    new interior = 1;
    SetPlayerInterior(playerid, interior);

    SetPlayerCameraPos(playerid, 1004.384033, 1497.215942, 1500.519287);
    SetPlayerCameraLookAt(playerid, 1001.266967, 1501.026733, 1499.646728);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:tungui1(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Sanya_Usupka", true) != 0 && strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0)
    {
        ShowNotificationSile(playerid, 2, 5, -1, -1, "Введенная вами команда не найдена!");
        return 1;
    }
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

    g_TuningType[playerid] = 1;

    SyncVehicleTuningForPlayer(playerid, vehicleid);

    new Node:tuning_json = JSON_Object();

    JSON_SetInt(tuning_json, "o", 2);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "t", 2);
    JSON_SetInt(tuning_json, "j", 1000);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new name[64];
    GetVehicleDataName(modelid, name, sizeof(name));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new Float:x = 995.452331, Float:y = 1001.766601, Float:z = 1500.253295;
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, 180.0);

    new interior = 1;
    SetPlayerInterior(playerid, interior);

    SetPlayerCameraPos(playerid, 998.835937, 997.811462, 1501.182983);
    SetPlayerCameraLookAt(playerid, 995.605468, 1001.587646, 1501.734863);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock CloseTuningGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        SyncVehicleTuningForPlayer(playerid, vehicleid);
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 255);
    JSON_SetInt(json, "s", 1);
    ShowPlayerGUI(playerid, 28, json);
    JSON_Cleanup(json);

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);

    switch(g_TuningType[playerid])
    {
        case 0:
        {
            SetVehiclePos(vehicleid, 2296.146240, -2613.668457, 21.829063);
            SetVehicleZAngle(vehicleid, 90.0);
        }
        case 1:
        {
            SetVehiclePos(vehicleid, 1742.453979, 2465.383544, 14.454860);
            SetVehicleZAngle(vehicleid, 285.0);
        }
    }

    SetPlayerInterior(playerid, 0);
    g_TuningType[playerid] = 0;

    printf("Tuning GUI closed for player %d", playerid);
}

stock PacketIncomingTuning(playerid, Node:JSONObject)
{
    new Node:tuning_response = JSON_Object(), 
        type, 
        selector_id, 
        detail_id, 
        color_val,
        color_hex[64],
        status,
        operation,
        car_id,
        current_money;
    
    JSON_GetInt(JSONObject, "t", type);
    JSON_GetInt(JSONObject, "s", status);           // статус операции
    JSON_GetInt(JSONObject, "m", selector_id);      // ID селектора/цвета (m - selector)
    JSON_GetInt(JSONObject, "d", detail_id);        // ID детали
    JSON_GetInt(JSONObject, "p", detail_id);        // ID детали для ремонта
    JSON_GetInt(JSONObject, "mt", operation);       // тип операции для деталей
    JSON_GetString(JSONObject, "d", color_hex, sizeof(color_hex)); // HEX цвет
    
    switch(type) 
    {
        case 0:
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            
            switch(g_TuningType[playerid])
            {
                case 0: 
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 2296.146240, -2613.668457, 21.829063);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.0);
                }
                case 1:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 1742.453979, 2465.383544, 14.454860);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
                }
            }
            
            SetPlayerInterior(playerid, 0);
            g_TuningType[playerid] = 0;
            
            JSON_SetInt(tuning_response, "t", 0);
            JSON_SetInt(tuning_response, "s", 1); 
        }
        case 1:
{
    new vehid = GetPlayerVehicleID(playerid);
    new model_id = GetVehicleData(vehid, V_MODELID);
    new price, query[256];
    new argb_body, argb_wheel;
    
    // ========== НАЧАЛО: ПРОВЕРКИ ==========
    
    // 1. Проверяем, существует ли транспорт
    if(!IsValidVehicle(vehid))
    {
        JSON_SetInt(tuning_response, "t", 1);
        JSON_SetInt(tuning_response, "s", 0);
        JSON_SetString(tuning_response, "d", "Ошибка: Транспорт не найден.");
        SendPacketToClient(playerid, 28, tuning_response);
        JSON_Cleanup(tuning_response);
        return;
    }
    
    // 2. Проверяем, является ли машина личной (не служебной, не арендованной)
    if(!IsAOwnableCar(vehid))
    {
        JSON_SetInt(tuning_response, "t", 1);
        JSON_SetInt(tuning_response, "s", 0);
        JSON_SetString(tuning_response, "d", "Ошибка: Этот транспорт нельзя тюнинговать.");
        SendPacketToClient(playerid, 28, tuning_response);
        JSON_Cleanup(tuning_response);
        return;
    }
    
    // 3. Получаем индекс в массиве g_ownable_car и проверяем владельца
    new idx = GetVehicleData(vehid, V_ACTION_ID);
    new db_owner_id = GetOwnableCarData(idx, OC_OWNER_ID);
    new player_db_id = GetPlayerAccountID(playerid);
    
    if(db_owner_id == 0 || db_owner_id != player_db_id)
    {
        JSON_SetInt(tuning_response, "t", 1);
        JSON_SetInt(tuning_response, "s", 0);
        JSON_SetString(tuning_response, "d", "Ошибка: Это не ваш личный автомобиль.");
        SendPacketToClient(playerid, 28, tuning_response);
        JSON_Cleanup(tuning_response);
        return;
    }
    
    // 4. Получаем SQL ID для сохранения в БД
    new sql_id = GetOwnableCarData(idx, OC_SQL_ID);
    
    // ========== КОНЕЦ ПРОВЕРОК ==========
    
    JSON_GetInt(JSONObject, "j", price);
    sscanf(color_hex, "h", color_val);
    
    // Конвертируем RGBA в ARGB для отправки клиенту
    argb_body = RGBA_to_ARGB(color_val);
    argb_wheel = RGBA_to_ARGB(0xFFFFFFFF); // Белый цвет для дисков по умолчанию
    
    if(selector_id == 0) 
    {
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            // Сохраняем изменение в структуру данных
            SetOwnableCarData(idx, OC_COLOR_1, color_val);
            
            // Сохраняем в базу данных
            mysql_format(mysql, query, sizeof(query), 
                "UPDATE `ownable_cars` SET `color_1`=%d WHERE `id`=%d", 
                color_val, sql_id);
            mysql_tquery(mysql, query);
            
            // Применяем изменения на машине через кастомную функцию
            new body_colors[2], wheel_colors[2];
            body_colors[0] = argb_body;
            body_colors[1] = argb_body;
            wheel_colors[0] = argb_wheel;
            wheel_colors[1] = argb_wheel;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", "Ошибка: Недостаточно денег.");
            SendPacketToClient(playerid, 28, tuning_response);
        } 
    }
    else if(selector_id == 1)
    {
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            // Сохраняем изменение в структуру данных
            SetOwnableCarData(idx, OC_COLOR_2, color_val);
            
            // Сохраняем в базу данных
            mysql_format(mysql, query, sizeof(query), 
                "UPDATE `ownable_cars` SET `color_2`=%d WHERE `id`=%d", 
                color_val, sql_id);
            mysql_tquery(mysql, query);
            
            // Применяем изменения на машине через кастомную функцию
            new body_colors[2], wheel_colors[2];
            body_colors[0] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[1] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[0] = RGBA_to_ARGB(body_colors[0]);
            body_colors[1] = RGBA_to_ARGB(body_colors[1]);
            
            wheel_colors[0] = argb_wheel;
            wheel_colors[1] = argb_wheel;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", "Ошибка: Недостаточно денег.");
            SendPacketToClient(playerid, 28, tuning_response);
        }
    }
    else if(selector_id == 2)
    {
        // Покраска дисков
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            // Сохраняем цвет дисков (если есть поле в структуре)
            // SetOwnableCarData(idx, OC_COLOR_WHEELS, color_val);
            
            new body_colors[2], wheel_colors[2];
            body_colors[0] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[1] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[0] = RGBA_to_ARGB(body_colors[0]);
            body_colors[1] = RGBA_to_ARGB(body_colors[1]);
            
            wheel_colors[0] = argb_body;
            wheel_colors[1] = argb_body;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", "Ошибка: Недостаточно денег.");
            SendPacketToClient(playerid, 28, tuning_response);
        }
    }
    else if(selector_id == 3)
    {
        // Дополнительная покраска (например, полосы)
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            new body_colors[2], wheel_colors[2];
            body_colors[0] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[1] = GetOwnableCarData(idx, OC_COLOR_2);
            body_colors[0] = RGBA_to_ARGB(body_colors[0]);
            body_colors[1] = RGBA_to_ARGB(body_colors[1]);
            
            wheel_colors[0] = argb_wheel;
            wheel_colors[1] = argb_wheel;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", "Ошибка: Недостаточно денег.");
            SendPacketToClient(playerid, 28, tuning_response);
        }
    }
    
    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
}
        case 2:
        {
            new vehid = GetPlayerVehicleID(playerid);
            new transparency, price;
            new hex_with_alpha[16];
            
            JSON_GetInt(JSONObject, "h", transparency);
            JSON_GetInt(JSONObject, "j", price);
            
            format(hex_with_alpha, sizeof(hex_with_alpha), "%02X%s", transparency, color_hex);
            
            JSON_SetInt(tuning_response, "t", 2);
            JSON_SetInt(tuning_response, "s", 1);
            JSON_SetString(tuning_response, "d", hex_with_alpha); // D_KEY_SEND_COLOR_HEX
        }
        case 7:
        {
            new price, cost;
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            
            JSON_GetInt(JSONObject, "d", detail_id);
            JSON_GetInt(JSONObject, "j", price);
            
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                GivePlayerMoneyEx(playerid, -price);
                
           //     SaveTuningDetail(sql_id, selector_id, detail_id);
                
                JSON_SetInt(tuning_response, "t", 7);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
            }
            else
            {
                JSON_SetInt(tuning_response, "t", 7);
                JSON_SetInt(tuning_response, "s", 0);
            }
        }
        case 6:
        {
            new total_cost;
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            
            JSON_GetInt(JSONObject, "j", total_cost);
            
            if(GetPlayerMoneyEx(playerid) >= total_cost)
            {
                GivePlayerMoneyEx(playerid, -total_cost);
                
                JSON_SetInt(tuning_response, "t", 6);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "a", 1); // A_KEY_GET_STATUS_DIAGNOSTIC - статус актуален
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
            }
            else
            {
                JSON_SetInt(tuning_response, "t", 6);
                JSON_SetInt(tuning_response, "s", 0);
            }
        }
        case 26:
        {
            new vinyl_name[64];
            JSON_GetString(JSONObject, "v", vinyl_name, sizeof(vinyl_name));
            
            JSON_SetInt(tuning_response, "t", 26);
            JSON_SetInt(tuning_response, "s", 1);
            JSON_SetString(tuning_response, "v", vinyl_name);
        }
        case 3:
        {
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            new price, vinyl_id;
            
            JSON_GetInt(JSONObject, "d", vinyl_id);
            JSON_GetInt(JSONObject, "j", price);
            
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                GivePlayerMoneyEx(playerid, -price);
              //  SaveTuningVinyl(sql_id, vinyl_id);
                
                JSON_SetInt(tuning_response, "t", 3);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
            }
            else
            {
                JSON_SetInt(tuning_response, "t", 3);
                JSON_SetInt(tuning_response, "s", 0);
            }
        }
        case 5:
        {
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            
            JSON_GetInt(JSONObject, "d", detail_id);
            JSON_GetInt(JSONObject, "mt", operation);
            
            // SetTuningDetail(sql_id, selector_id, detail_id);
            
            JSON_SetInt(tuning_response, "t", 5);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 18:
        {
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            
            JSON_GetInt(JSONObject, "m", selector_id);
            JSON_GetInt(JSONObject, "mt", operation);
            
            //ResetTuningDetails(sql_id, selector_id);
            
            JSON_SetInt(tuning_response, "t", 18);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 23:
        {
            new color_val;
            sscanf(color_hex, "h", color_val);
            
            JSON_SetInt(tuning_response, "t", 23);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 27:
        {
            new car_preview_id;
            JSON_GetInt(JSONObject, "d", car_preview_id);
            
            SetPlayerCameraLookAt(playerid, 0.0, 0.0, 0.0);
            
            JSON_SetInt(tuning_response, "t", 27);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 19:
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            
            JSON_SetInt(tuning_response, "t", 19);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 12:
        {
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            new price, collapse_value;
            
            JSON_GetInt(JSONObject, "d", collapse_value);
            JSON_GetInt(JSONObject, "j", price);
            
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                GivePlayerMoneyEx(playerid, -price);
               // SaveTuningCollapse(sql_id, selector_id, collapse_value);
                
                JSON_SetInt(tuning_response, "t", 12);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
            }
            else
            {
                JSON_SetInt(tuning_response, "t", 12);
                JSON_SetInt(tuning_response, "s", 0);
            }
        }
        case 28:
        {
            JSON_SetInt(tuning_response, "t", 28);
            JSON_SetInt(tuning_response, "s", 1);
        }
    }
    SendPacketToClient(playerid, 28, tuning_response);
    JSON_Cleanup(tuning_response);
}