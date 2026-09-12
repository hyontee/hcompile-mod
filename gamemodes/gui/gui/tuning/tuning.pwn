new g_VehicleTechMode[MAX_VEHICLES];
new g_VehiclePneumoMode[MAX_VEHICLES];
new g_TuneClearance[MAX_VEHICLES];
new g_TuneWheelRadius[MAX_VEHICLES];
new g_TuneWheelAlignment[MAX_VEHICLES];
new g_TuneWheelDeparture[MAX_VEHICLES];

CMD:tungui(playerid, params[])
{
    return ShowTuningStylingGUI(playerid);
}

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

    SyncVehicleTuningForPlayer(playerid, vehicleid);
    new Node:tuning_json = JSON_Object();
    new price;
    
	GetVehicleJsonCostByModelId(modelid, price);
	 
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "s", 5);
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
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

    g_TuningType[playerid] = 1;

    SyncVehicleTuningForPlayer(playerid, vehicleid);

    new Node:tuning_json = JSON_Object();

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "s", 5);
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

CMD:tungui2(playerid, params[])
{
    return ShowTuningTechGUI(playerid);
}

stock ShowTuningTechGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "You must be in your own vehicle.");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return SendClientMessage(playerid, -1, "You must be in your own vehicle.");

    new owner_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(owner_id, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, -1, "You must be in your own vehicle.");

    SyncVehicleTuningForPlayer(playerid, vehicleid);

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new price, name[64];
    GetVehicleJsonCostByModelId(modelid, price);
    GetVehicleModelName(modelid, name, sizeof(name));

    new Node:tuning_json = JSON_Object();
    new Node:k_array = JSON_Array();
    static const part_ids[4][5] =
    {
        {4, 9, 14, 19, 24},
        {5, 10, 15, 20, 25},
        {7, 12, 17, 22, 27},
        {6, 11, 16, 21, 26}
    };
    new part_values[4];
    part_values[0] = vInfo[vehicleid][vTechComfort];
    part_values[1] = vInfo[vehicleid][vTechSport];
    part_values[2] = vInfo[vehicleid][vTechSportPlus];
    part_values[3] = vInfo[vehicleid][vTechDrift];

    for(new category; category < 4; category++)
    {
        for(new part = 1; part <= 5; part++)
        {
            if(IsTuningPartInstalled(part_values[category], part))
            {
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(part_ids[category][part - 1])));
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
            }
        }
    }
    if(vInfo[vehicleid][vTechNitro] >= 1 && vInfo[vehicleid][vTechNitro] <= 3)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(vInfo[vehicleid][vTechNitro] - 1)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    SetVehiclePos(vehicleid, 1000.0847, 1502.3265, 1497.5124);
    SetVehicleZAngle(vehicleid, 180.0);
    SetPlayerInterior(playerid, 1);
    SetPlayerCameraPos(playerid, 1004.384033, 1497.215942, 1500.519287);
    SetPlayerCameraLookAt(playerid, 1001.266967, 1501.026733, 1499.646728);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(k_array);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock IsTuningPartInstalled(value, part)
{
    while(value > 0)
    {
        if(value % 10 == part)
            return 1;
        value /= 10;
    }
    return 0;
}

stock IsFullTechSetInstalled(value)
{
    return IsTuningPartInstalled(value, 1) &&
        IsTuningPartInstalled(value, 2) &&
        IsTuningPartInstalled(value, 3) &&
        IsTuningPartInstalled(value, 4) &&
        IsTuningPartInstalled(value, 5);
}

stock ApplyVehicleFirmwareHandling(vehicleid, firmware)
{
    new base_speed, modelid = GetVehicleModel(vehicleid);
    if(!GetVehSpeedByModel(modelid, base_speed))
    {
        new data_modelid = GetVehicleData(vehicleid, V_MODELID);
        new info_index = data_modelid - 400;
        if(0 <= info_index < sizeof(g_vehicle_info))
        {
            base_speed = floatround(GetVehicleInfo(info_index, VI_MAXSP));
            modelid = data_modelid;
        }
    }
    if(base_speed <= 0)
    {
        printf("[TUNING] Handling not found: vehicle=%d model=%d firmware=%d", vehicleid, modelid, firmware);
        return 0;
    }

    switch(firmware)
    {
        case 9:
        {
            SetVehicleAccelerationBR(vehicleid, 31.8);
        }
        case 10:
        {
            SetVehicleAccelerationBR(vehicleid, 35.0);
        }
        case 11:
        {
            SetVehicleAccelerationBR(vehicleid, 36.0);
        }
        default:
        {
            SetVehicleAccelerationBR(vehicleid, 0.0);
        }
    }
    return 1;
}

forward ApplyFirmwareAfterVehicleEnter(playerid, vehicleid);
public ApplyFirmwareAfterVehicleEnter(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid) ||
       GetPlayerVehicleID(playerid) != vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return 0;

    if(g_VehicleTechMode[vehicleid] == 8)
        SetVehicleDrift(vehicleid, true);
    else if(9 <= g_VehicleTechMode[vehicleid] <= 11)
        ApplyVehicleFirmwareHandling(vehicleid, g_VehicleTechMode[vehicleid]);

    RemoveVehicleComponent(vehicleid, 1008);
    RemoveVehicleComponent(vehicleid, 1009);
    RemoveVehicleComponent(vehicleid, 1010);
    if(vInfo[vehicleid][vTechNitro] >= 1 && vInfo[vehicleid][vTechNitro] <= 3)
    {
        static const nitro_components[] = {1009, 1008, 1010};
        AddVehicleComponent(vehicleid, nitro_components[vInfo[vehicleid][vTechNitro] - 1]);
    }
    if(vInfo[vehicleid][viHornSound] > 0)
        SetVehicleHornSound(vehicleid, vInfo[vehicleid][viHornSound]);
    if(-100 <= g_TuneClearance[vehicleid] <= 100 && g_TuneClearance[vehicleid] != 0)
        SetVehicleClearance(vehicleid, g_TuneClearance[vehicleid]);
    return 1;
}

stock GetTechTuningPrice(vehicle_price, category)
{
    switch(category)
    {
        case 0: return floatround(float(vehicle_price) * 0.04) + 15000;
        case 1: return floatround(float(vehicle_price) * 0.07) + 15000;
        case 2: return floatround(float(vehicle_price) * 0.05) + 15000;
        case 3: return floatround(float(vehicle_price) * 0.02) + 20000;
    }
    return 0;
}

stock GetTechNitroPrice(vehicle_price, nitro_id)
{
    switch(nitro_id)
    {
        case 0: return floatround(float(vehicle_price) * 0.02) + 15000;
        case 1: return floatround(float(vehicle_price) * 0.05) + 15000;
        case 2: return floatround(float(vehicle_price) * 0.07) + 15000;
    }
    return 0;
}

stock BuyTechTuningPart(playerid, vehicleid, detail_id)
{
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return 0;

    new category = -1, part, add_value, field_name[16], current_value;
    switch(detail_id)
    {
        case 4:  { category = 0; part = 1; add_value = 1; }
        case 9:  { category = 0; part = 2; add_value = 20; }
        case 14: { category = 0; part = 3; add_value = 300; }
        case 19: { category = 0; part = 4; add_value = 4000; }
        case 24: { category = 0; part = 5; add_value = 50000; }
        case 5:  { category = 1; part = 1; add_value = 1; }
        case 10: { category = 1; part = 2; add_value = 20; }
        case 15: { category = 1; part = 3; add_value = 300; }
        case 20: { category = 1; part = 4; add_value = 4000; }
        case 25: { category = 1; part = 5; add_value = 50000; }
        case 6:  { category = 2; part = 1; add_value = 1; }
        case 11: { category = 2; part = 2; add_value = 20; }
        case 16: { category = 2; part = 3; add_value = 300; }
        case 21: { category = 2; part = 4; add_value = 4000; }
        case 26: { category = 2; part = 5; add_value = 50000; }
        case 7:  { category = 3; part = 1; add_value = 1; }
        case 12: { category = 3; part = 2; add_value = 20; }
        case 17: { category = 3; part = 3; add_value = 300; }
        case 22: { category = 3; part = 4; add_value = 4000; }
        case 27: { category = 3; part = 5; add_value = 50000; }
        case 0..2:
        {
            if(vInfo[vehicleid][vTechNitro] == detail_id + 1)
                return 0;

            new price, model_price;
            GetVehicleJsonCostByModelId(GetVehicleData(vehicleid, V_MODELID), model_price);
            price = GetTechNitroPrice(model_price, detail_id);
            if(GetPlayerMoneyEx(playerid) < price)
                return 0;

            vInfo[vehicleid][vTechNitro] = detail_id + 1;
            static const nitro_components[] = {1009, 1008, 1010};
            AddVehicleComponent(vehicleid, nitro_components[detail_id]);
            GivePlayerMoneyEx(playerid, -price);

            new query[128];
            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `nitro`=%d WHERE `id`=%d",
                detail_id + 1, GetOwnableCarData(index, OC_SQL_ID));
            mysql_tquery(mysql, query);
            return 1;
        }
        default: return 0;
    }

    switch(category)
    {
        case 0: { current_value = vInfo[vehicleid][vTechComfort]; format(field_name, sizeof(field_name), "comfort"); }
        case 1: { current_value = vInfo[vehicleid][vTechSport]; format(field_name, sizeof(field_name), "sport"); }
        case 2: { current_value = vInfo[vehicleid][vTechDrift]; format(field_name, sizeof(field_name), "drift"); }
        case 3: { current_value = vInfo[vehicleid][vTechSportPlus]; format(field_name, sizeof(field_name), "sport_plus"); }
    }
    if(IsTuningPartInstalled(current_value, part))
        return 0;

    new model_price;
    GetVehicleJsonCostByModelId(GetVehicleData(vehicleid, V_MODELID), model_price);
    new price = GetTechTuningPrice(model_price, category);
    if(GetPlayerMoneyEx(playerid) < price)
        return 0;

    current_value += add_value;
    switch(category)
    {
        case 0: vInfo[vehicleid][vTechComfort] = current_value;
        case 1: vInfo[vehicleid][vTechSport] = current_value;
        case 2: vInfo[vehicleid][vTechDrift] = current_value;
        case 3: vInfo[vehicleid][vTechSportPlus] = current_value;
    }
    GivePlayerMoneyEx(playerid, -price);

    new query[144];
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`=%d WHERE `id`=%d",
        field_name, current_value, GetOwnableCarData(index, OC_SQL_ID));
    mysql_tquery(mysql, query);
    return 1;
}

stock BuyStylingTuningPart(playerid, vehicleid, detail_id)
{
    if(!IsPlayerVehicleTuningOwner(playerid, vehicleid))
        return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
    new vehicle_price;
    GetVehicleJsonCostByModelId(GetVehicleData(vehicleid, V_MODELID), vehicle_price);
    new price = (vehicle_price / 100) + 50000;
    new query[144], value;

    if(detail_id >= 28 && detail_id <= 32)
    {
        value = detail_id - 28;
        if(value == 0) value = 1;
        if(vInfo[vehicleid][viStrob] == value || GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][viStrob] = value;
        vInfo[vehicleid][vStrob] = 0;
        SetVehicleStroboscope(vehicleid, 5);
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `ownable_cars` SET `tuning_stroboscope`=%d WHERE `id`=%d", value, sql_id);
    }
    else if(detail_id == 35)
    {
        if(vInfo[vehicleid][viLaunchControl] > 0 || GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][viLaunchControl] = 1;
        vInfo[vehicleid][vLaunchControl] = 0;
        SetVehicleLaunchControl(vehicleid, 0);
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `ownable_cars` SET `tuning_launch_control`=1 WHERE `id`=%d", sql_id);
    }
    else if(detail_id == 33)
    {
        if(vInfo[vehicleid][viHydraulics] > 0 || GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][viHydraulics] = 1;
        vInfo[vehicleid][vHydraulics] = 0;
        SetVehicleHydraulics(vehicleid, 0);
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `ownable_cars` SET `tuning_hydraulics`=1 WHERE `id`=%d", sql_id);
    }
    else if(detail_id == 34)
    {
        if(vInfo[vehicleid][vSuspensionForce] != 0 || GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][vSuspensionForce] = 1.0;
        SetVehicleSuspensionForce(vehicleid, 1.0);
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `ownable_cars` SET `tuning_suspension_force`=1.0 WHERE `id`=%d", sql_id);
    }
    else if(detail_id == 299 || detail_id == 130)
    {
        ShowNotificationSile(playerid, 2, 5, 0, 0, "Дальний свет временно отключен.", "");
        return 0;
    }
    else if(detail_id == 102 || detail_id == 112 || detail_id == 119 || detail_id == 125)
    {
        if(GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][viHornSound] = detail_id;
        vInfo[vehicleid][viSiren] = 0;
        SetVehicleHornSound(vehicleid, detail_id);
        SetVehicleSiren(vehicleid, 0, 1);
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `ownable_cars` SET `tuning_siren`=0 WHERE `id`=%d", sql_id);
    }
    else if(detail_id == 117)
    {
        if(vInfo[vehicleid][viSiren] > 0 || GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][viSiren] = 1;
        SetVehicleSiren(vehicleid, 1, 1);
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `ownable_cars` SET `tuning_siren`=1 WHERE `id`=%d", sql_id);
    }
    else if(detail_id == 98)
    {
        if(vInfo[vehicleid][viExhaustSound] > 0 || GetPlayerMoneyEx(playerid) < price)
            return 0;

        GivePlayerMoneyEx(playerid, -price);
        vInfo[vehicleid][viExhaustSound] = 1;
        SetVehicleExhaust(vehicleid, 1);
        format(query, sizeof(query), "SELECT 1");
    }
    else
    {
        printf("[TUNING] Unknown styling detail id %d from player %d", detail_id, playerid);
        return 0;
    }

    mysql_tquery(mysql, query);
    return 1;
}

stock IsPlayerVehicleTuningOwner(playerid, vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
        return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return 0;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    return index >= 0 && GetOwnableCarData(index, OC_OWNER_ID) == GetPlayerAccountID(playerid);
}

stock PacketIncomingVehicleRadial(playerid, Node:JSONObject)
{
    new vehicleid = GetPlayerVehicleID(playerid), type;
    JSON_GetInt(JSONObject, "t", type);

    if(type == 0)
    {
        TogglePlayerControllable(playerid, 1);
        SetCameraBehindPlayer(playerid);
        ShowHud(playerid);
        return 1;
    }

    if(!IsPlayerVehicleTuningOwner(playerid, vehicleid))
    {
        JSON_SetInt(JSONObject, "t", type);
        JSON_SetInt(JSONObject, "s", 0);
        SendPacketToClient(playerid, 27, JSONObject);
        return 0;
    }

    new radial_state;
    switch(type)
    {
        case 1:
        {
            callcmd::park(playerid, "");
            radial_state = 1;
        }
        case 3:
        {
            callcmd::lock(playerid, "");
            radial_state = GetVehicleParam(vehicleid, V_LOCK) ? 1 : 0;
        }
        case 5:
        {
            if(vInfo[vehicleid][viLaunchControl] <= 0)
            {
                radial_state = 0;
                ShowNotificationSile(playerid, 2, 5, 0, 0, "Launch-control не установлен.", "");
            }
            else
            {
                vInfo[vehicleid][vLaunchControl] = !vInfo[vehicleid][vLaunchControl];
                radial_state = vInfo[vehicleid][vLaunchControl];
                SetVehicleLaunchControl(vehicleid, radial_state ? vInfo[vehicleid][viLaunchControl] : 0);
            }
        }
        case 6:
        {
            engineon(playerid);
            radial_state = GetVehicleParam(vehicleid, V_ENGINE) ? 1 : 0;
        }
        case 8..11:
        {
            new installed;
            switch(type)
            {
                case 8: installed = IsFullTechSetInstalled(vInfo[vehicleid][vTechDrift]);
                case 9: installed = IsFullTechSetInstalled(vInfo[vehicleid][vTechComfort]);
                case 10: installed = IsFullTechSetInstalled(vInfo[vehicleid][vTechSport]);
                case 11: installed = IsFullTechSetInstalled(vInfo[vehicleid][vTechSportPlus]);
            }
            if(installed)
            {
                new old_mode = g_VehicleTechMode[vehicleid];
                g_VehicleTechMode[vehicleid] = old_mode == type ? 0 : type;
                radial_state = g_VehicleTechMode[vehicleid] == type;

                new ownable_index = GetVehicleData(vehicleid, V_ACTION_ID);
                if(ownable_index >= 0)
                {
                    SetOwnableCarData(ownable_index, OC_FIRMWARE, g_VehicleTechMode[vehicleid]);
                    new firmware_query[128];
                    mysql_format(mysql, firmware_query, sizeof(firmware_query),
                        "UPDATE `ownable_cars` SET `firmware`=%d WHERE `id`=%d",
                        g_VehicleTechMode[vehicleid], GetOwnableCarData(ownable_index, OC_SQL_ID));
                    mysql_tquery(mysql, firmware_query);
                }

                if(old_mode == 8)
                    SetVehicleDrift(vehicleid, false);
                if(type == 8)
                {
                    ApplyVehicleFirmwareHandling(vehicleid, 0);
                    SetVehicleDrift(vehicleid, radial_state != 0);
                }
                else
                {
                    ApplyVehicleFirmwareHandling(vehicleid, g_VehicleTechMode[vehicleid]);
                }
            }
            else ShowNotificationSile(playerid, 2, 5, 0, 0, "Прошивка установлена не полностью.", "");
        }
        case 12:
        {
            if(!(vInfo[vehicleid][vNeon1] || vInfo[vehicleid][vNeon2] || vInfo[vehicleid][vNeon3]))
            {
                radial_state = 0;
                ShowNotificationSile(playerid, 2, 5, 0, 0, "Подсветка не установлена.", "");
            }
            else
            {
                vInfo[vehicleid][vEnableNeon][0] = !vInfo[vehicleid][vEnableNeon][0];
                radial_state = vInfo[vehicleid][vEnableNeon][0];
                if(radial_state)
                    SetVehicleNeon(vehicleid, vInfo[vehicleid][vNeon1], vInfo[vehicleid][vNeon2], vInfo[vehicleid][vNeon3]);
                else
                    SetVehicleNeon(vehicleid, 0, 0, 0);
            }
        }
        case 13:
        {
            radial_state = 0;
            vInfo[vehicleid][vHighLights] = 0;
            ShowNotificationSile(playerid, 2, 5, 0, 0, "Дальний свет временно отключен.", "");
        }
        case 14:
        {
            lightss(playerid);
            radial_state = GetVehicleParam(vehicleid, V_LIGHTS) ? 1 : 0;
        }
        case 15:
        {
            if(vInfo[vehicleid][viStrob] <= 0)
            {
                radial_state = 0;
                ShowNotificationSile(playerid, 2, 5, 0, 0, "Стробоскопы не установлены.", "");
            }
            else
            {
                vInfo[vehicleid][vStrob] = !vInfo[vehicleid][vStrob];
                radial_state = vInfo[vehicleid][vStrob];
                SetVehicleStroboscope(vehicleid, radial_state ? vInfo[vehicleid][viStrob] : 5);
            }
        }
        case 16..18:
        {
            if(vInfo[vehicleid][vSuspensionForce] != 0)
            {
                g_VehiclePneumoMode[vehicleid] = type;
                radial_state = 1;
                switch(type)
                {
                    case 16: SetVehicleSuspensionForce(vehicleid, 0.70);
                    case 17: SetVehicleSuspensionForce(vehicleid, 1.00);
                    case 18: SetVehicleSuspensionForce(vehicleid, 1.30);
                }
            }
            else ShowNotificationSile(playerid, 2, 5, 0, 0, "Пневмоподвеска не установлена.", "");
        }
        case 19:
        {
            if(vInfo[vehicleid][viHydraulics] <= 0)
            {
                radial_state = 0;
                ShowNotificationSile(playerid, 2, 5, 0, 0, "Гидравлика не установлена.", "");
            }
            else
            {
                vInfo[vehicleid][vHydraulics] = !vInfo[vehicleid][vHydraulics];
                radial_state = vInfo[vehicleid][vHydraulics];
                SetVehicleHydraulics(vehicleid, radial_state ? vInfo[vehicleid][viHydraulics] : 0);
            }
        }
        default: radial_state = 0;
    }

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "s", radial_state);
    SendPacketToClient(playerid, 27, JSONObject);
    return 1;
}

stock CloseTuningGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        SyncVehicleTuningForPlayer(playerid, vehicleid);
        if(!vInfo[vehicleid][vLaunchControl])
            SetVehicleLaunchControl(vehicleid, 0);
        if(!vInfo[vehicleid][vStrob])
            SetVehicleStroboscope(vehicleid, 5);
        if(!vInfo[vehicleid][vHydraulics])
            SetVehicleHydraulics(vehicleid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        LinkVehicleToInterior(vehicleid, 0);
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 255);
    JSON_SetInt(json, "s", 1);
    ShowPlayerGUI(playerid, 28, json);
    JSON_Cleanup(json);

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);

    new tuning_slot = g_TuningCenterSlot[playerid];
    if(g_IsTechTuningCenter[playerid] && 0 <= tuning_slot < 3)
    {
        SetVehiclePos(vehicleid, g_TechTuningExit[tuning_slot][0], g_TechTuningExit[tuning_slot][1], g_TechTuningExit[tuning_slot][2]);
        SetVehicleZAngle(vehicleid, g_TechTuningExit[tuning_slot][3]);
    }
    else if(g_TuningType[playerid] == 1)
    {
        SetVehiclePos(vehicleid, 1742.453979, 2465.383544, 14.454860);
        SetVehicleZAngle(vehicleid, 285.0);
    }
    else
    {
        SetVehiclePos(vehicleid, 2296.146240, -2613.668457, 21.829063);
        SetVehicleZAngle(vehicleid, 90.0);
    }

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    g_TuningType[playerid] = 0;
    g_IsTechTuningCenter[playerid] = false;

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
    printf("[TUNING_PACKET] player=%d type=%d selector=%d detail=%d operation=%d status=%d",
        playerid, type, selector_id, detail_id, operation, status);
    
    switch(type) 
    {
        case 0:
        {
            new close_vehicleid = GetPlayerVehicleID(playerid);
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowHud(playerid);
            
            new tuning_slot = g_TuningCenterSlot[playerid];
            if(g_IsTechTuningCenter[playerid] && 0 <= tuning_slot < 3)
            {
                SetVehiclePos(GetPlayerVehicleID(playerid), g_TechTuningExit[tuning_slot][0], g_TechTuningExit[tuning_slot][1], g_TechTuningExit[tuning_slot][2]);
                SetVehicleZAngle(GetPlayerVehicleID(playerid), g_TechTuningExit[tuning_slot][3]);
            }
            else if(g_TuningType[playerid] == 1)
            {
                SetVehiclePos(GetPlayerVehicleID(playerid), 1742.453979, 2465.383544, 14.454860);
                SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
            }
            else
            {
                SetVehiclePos(GetPlayerVehicleID(playerid), 2296.146240, -2613.668457, 21.829063);
                SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.0);
            }
            
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            if(IsValidVehicle(close_vehicleid))
            {
                SetVehicleVirtualWorld(close_vehicleid, 0);
                LinkVehicleToInterior(close_vehicleid, 0);
                if(!vInfo[close_vehicleid][vLaunchControl])
                    SetVehicleLaunchControl(close_vehicleid, 0);
                if(!vInfo[close_vehicleid][vStrob])
                    SetVehicleStroboscope(close_vehicleid, 5);
                if(!vInfo[close_vehicleid][vHydraulics])
                    SetVehicleHydraulics(close_vehicleid, 0);
            }
            g_TuningType[playerid] = 0;
            g_IsTechTuningCenter[playerid] = false;
            
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
    argb_wheel = RGBA_to_ARGB(0xFFFFFFFF);
    
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
    else if(selector_id == 3 || selector_id == 4)
    {
        // Дополнительная покраска (например, полосы)
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            if(selector_id == 3)
            {
                vInfo[vehid][viTonerFront] = color_val;
                vInfo[vehid][viTonerFrontSide] = color_val;
            }
            else
            {
                vInfo[vehid][viTonerRear] = color_val;
                vInfo[vehid][viTonerRearSide] = color_val;
            }
            SetVehicleTonerRPC(vehid,
                vInfo[vehid][viTonerFront], vInfo[vehid][viTonerRear],
                vInfo[vehid][viTonerFrontSide], vInfo[vehid][viTonerRearSide]);
            mysql_format(mysql, query, sizeof(query),
                "UPDATE `ownable_cars` SET `tuning_toner_front`=%d, `tuning_toner_rear`=%d, `tuning_toner_front_side`=%d, `tuning_toner_rear_side`=%d WHERE `id`=%d",
                vInfo[vehid][viTonerFront], vInfo[vehid][viTonerRear],
                vInfo[vehid][viTonerFrontSide], vInfo[vehid][viTonerRearSide], sql_id);
            mysql_tquery(mysql, query);
            
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
    else if(selector_id == 10)
    {
        if(GetPlayerMoneyEx(playerid) >= price)
        {
            GivePlayerMoneyEx(playerid, -price);
            vInfo[vehid][viLightColor] = color_val;
            SetVehicleLightsColors(vehid,
                (color_val >> 24) & 0xFF,
                (color_val >> 16) & 0xFF,
                (color_val >> 8) & 0xFF);
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);
        }
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
        }
    }
    else if(selector_id >= 11 && selector_id <= 13)
    {
        new vehicle_price;
        GetVehicleJsonCostByModelId(model_id, vehicle_price);
        new neon_price = (vehicle_price / 100) + 50000;
        if(GetPlayerMoneyEx(playerid) >= neon_price)
        {
            GivePlayerMoneyEx(playerid, -neon_price);
            switch(selector_id)
            {
                case 11: vInfo[vehid][vNeon1] = color_val;
                case 12: vInfo[vehid][vNeon2] = color_val;
                case 13: vInfo[vehid][vNeon3] = color_val;
            }
            SetVehicleNeon(vehid, vInfo[vehid][vNeon1], vInfo[vehid][vNeon2], vInfo[vehid][vNeon3]);

            mysql_format(mysql, query, sizeof(query),
                "UPDATE `ownable_cars` SET `tuning_neon1`=%d, `tuning_neon2`=%d, `tuning_neon3`=%d WHERE `id`=%d",
                vInfo[vehid][vNeon1], vInfo[vehid][vNeon2], vInfo[vehid][vNeon3], sql_id);
            mysql_tquery(mysql, query);
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);
        }
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
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
            JSON_GetInt(JSONObject, "d", detail_id);
            new vehicleid = GetPlayerVehicleID(playerid);
            printf("[TUNING] Purchase request: player=%d vehicle=%d detail=%d", playerid, vehicleid, detail_id);
            if(BuyTechTuningPart(playerid, vehicleid, detail_id) ||
               BuyStylingTuningPart(playerid, vehicleid, detail_id))
            {
                JSON_SetInt(tuning_response, "t", 7);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "p", detail_id);
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
                if(selector_id == 22)
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    g_TuneClearance[vehicleid] = collapse_value;
                    SetVehicleClearance(vehicleid, collapse_value);
                    new query[128];
                    mysql_format(mysql, query, sizeof(query),
                        "UPDATE `ownable_cars` SET `wheels_kl`=%d WHERE `id`=%d",
                        collapse_value, sql_id);
                    mysql_tquery(mysql, query);
                }
                
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
