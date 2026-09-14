#if !defined RACE_TECHCENTER_GUI
#define RACE_TECHCENTER_GUI

#if !defined VF_SPORTA
    #define VF_SPORTA      (1)
    #define VF_DRIFTA      (2)
    #define VF_COMFORTA    (4)
    #define VF_SPORTPLUSA  (8)
    #define VF_STROB_ON    (16)
    #define VF_DALNIY_ON   (32)
#endif

new RaceVehFlags[MAX_VEHICLES];

stock bool:VehGetFlag(playerid, slot, flag)
{
    #pragma unused playerid
    #pragma unused slot
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) return false;
    return bool:((RaceVehFlags[vehicleid] & flag) != 0);
}

stock VehSetFlag(playerid, slot, flag, bool:value)
{
    #pragma unused slot
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) return 0;
    if(value) RaceVehFlags[vehicleid] |= flag;
    else RaceVehFlags[vehicleid] &= ~flag;
    return 1;
}

stock bool:VehToggleFlag(playerid, slot, flag)
{
    new bool:status = !VehGetFlag(playerid, slot, flag);
    VehSetFlag(playerid, slot, flag, status);
    return status;
}

stock IsPartInstalled(value, part)
{
    if(value <= 0) return 0;
    new temp_val = value;
    while(temp_val > 0)
    {
        if(temp_val % 10 == part) return 1;
        temp_val /= 10;
    }
    return 0;
}

stock IsFullSetInstalled(value)
{
    return (IsPartInstalled(value, 1) && IsPartInstalled(value, 2) &&
            IsPartInstalled(value, 3) && IsPartInstalled(value, 4) &&
            IsPartInstalled(value, 5));
}

stock RaceTech_GetFirmwareFromDetail(detal_id)
{
    switch(detal_id)
    {
        case 4, 9, 14, 19, 24: return 1;
        case 5, 10, 15, 20, 25: return 2;
        case 6, 11, 16, 21, 26: return 3;
        case 7, 12, 17, 22, 27: return 4;
    }
    return 0;
}

stock RaceTech_GetPartInfo(detal_id, &part_type, &part_num, &add_val, col_name[])
{
    part_type = 0;
    part_num = 0;
    add_val = 0;
    col_name[0] = EOS;

    switch(detal_id)
    {
        case 4:  { part_type = 3; part_num = 1; add_val = 1;     format(col_name, 20, "comfort"); }
        case 9:  { part_type = 3; part_num = 2; add_val = 20;    format(col_name, 20, "comfort"); }
        case 14: { part_type = 3; part_num = 3; add_val = 300;   format(col_name, 20, "comfort"); }
        case 19: { part_type = 3; part_num = 4; add_val = 4000;  format(col_name, 20, "comfort"); }
        case 24: { part_type = 3; part_num = 5; add_val = 50000; format(col_name, 20, "comfort"); }

        case 5:  { part_type = 1; part_num = 1; add_val = 1;     format(col_name, 20, "sport"); }
        case 10: { part_type = 1; part_num = 2; add_val = 20;    format(col_name, 20, "sport"); }
        case 15: { part_type = 1; part_num = 3; add_val = 300;   format(col_name, 20, "sport"); }
        case 20: { part_type = 1; part_num = 4; add_val = 4000;  format(col_name, 20, "sport"); }
        case 25: { part_type = 1; part_num = 5; add_val = 50000; format(col_name, 20, "sport"); }

        case 6:  { part_type = 2; part_num = 1; add_val = 1;     format(col_name, 20, "drift"); }
        case 11: { part_type = 2; part_num = 2; add_val = 20;    format(col_name, 20, "drift"); }
        case 16: { part_type = 2; part_num = 3; add_val = 300;   format(col_name, 20, "drift"); }
        case 21: { part_type = 2; part_num = 4; add_val = 4000;  format(col_name, 20, "drift"); }
        case 26: { part_type = 2; part_num = 5; add_val = 50000; format(col_name, 20, "drift"); }

        case 7:  { part_type = 4; part_num = 1; add_val = 1;     format(col_name, 20, "sport_plus"); }
        case 12: { part_type = 4; part_num = 2; add_val = 20;    format(col_name, 20, "sport_plus"); }
        case 17: { part_type = 4; part_num = 3; add_val = 300;   format(col_name, 20, "sport_plus"); }
        case 22: { part_type = 4; part_num = 4; add_val = 4000;  format(col_name, 20, "sport_plus"); }
        case 27: { part_type = 4; part_num = 5; add_val = 50000; format(col_name, 20, "sport_plus"); }

        case 0..2:
        {
            part_type = 5;
            part_num = detal_id;
            add_val = detal_id + 1;
            format(col_name, 20, "nitro");
        }
        default: return 0;
    }
    return 1;
}

stock RaceTech_GetSavedPartValue(index, const col_name[])
{
    if(index < 0) return 0;

    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
    if(sql_id <= 0) return 0;

    new query[160], Cache:result, value = 0;
    mysql_format(mysql, query, sizeof(query),
        "SELECT `comfort`,`sport`,`sport_plus`,`drift`,`nitro` FROM `ownable_cars` WHERE `id`=%d LIMIT 1",
        sql_id
    );
    result = mysql_query(mysql, query, true);

    if(cache_num_rows() > 0)
        value = cache_get_field_content_int(0, col_name);

    cache_delete(result);
    return value;
}

stock RaceTech_UpdateSavedPartValue(index, const col_name[], value)
{
    if(index < 0) return 0;

    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
    if(sql_id <= 0) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `ownable_cars` SET `%s`=%d WHERE `id`=%d LIMIT 1",
        col_name,
        value,
        sql_id
    );
    mysql_tquery(mysql, query);
    return 1;
}

stock BuyPart(playerid, vehicleid, detal_id)
{
    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    if(index == -1) return 0;

    new part_type, part_num, add_val, col_name[20];
    if(!RaceTech_GetPartInfo(detal_id, part_type, part_num, add_val, col_name)) return 0;

    new current_val = RaceTech_GetSavedPartValue(index, col_name);

    if(part_type == 5)
    {
        if(current_val == add_val) return 0;

        RaceTech_UpdateSavedPartValue(index, col_name, add_val);
        vInfo[vehicleid][viNitro] = add_val;

        switch(add_val)
        {
            case 1: AddVehicleComponent(vehicleid, 1009);
            case 2: AddVehicleComponent(vehicleid, 1008);
            case 3: AddVehicleComponent(vehicleid, 1010);
        }
        SaveVehicleTuning(vehicleid);
        return 1;
    }

    if(IsPartInstalled(current_val, part_num)) return 0;

    new new_val = current_val + add_val;
    RaceTech_UpdateSavedPartValue(index, col_name, new_val);

    // Buy only saves purchased parts. Active firmware is toggled by radial menu only.
    SaveVehicleTuning(vehicleid);
    return 1;
}

stock RaceTech_FirmwareName(firmware, name[], size = sizeof name)
{
    switch(firmware)
    {
        case 1: format(name, size, "Comfort");
        case 2: format(name, size, "Sport");
        case 3: format(name, size, "Drift");
        case 4: format(name, size, "Sport+");
        default: format(name, size, "Stock");
    }
    return 1;
}

stock ShowTechCenterGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
        return RaceNotifyError(playerid, "Вы должны быть в машине!");

    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    if(index == -1)
        return RaceNotifyError(playerid, "Это не ваш личный транспорт!");

    new price = Race_GetVehiclePrice(vehicleid);
    new name[64];
    Race_GetVehicleName(vehicleid, name, sizeof(name));

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
    new nitro_val;
    new query_parts[160], Cache:result_parts;
    mysql_format(mysql, query_parts, sizeof(query_parts),
        "SELECT `comfort`,`sport`,`sport_plus`,`drift`,`nitro` FROM `ownable_cars` WHERE `id`=%d LIMIT 1",
        GetOwnableCarData(index, OC_SQL_ID)
    );
    result_parts = mysql_query(mysql, query_parts, true);

    if(cache_num_rows() > 0)
    {
        part_values[0] = cache_get_field_content_int(0, "comfort");
        part_values[1] = cache_get_field_content_int(0, "sport");
        part_values[2] = cache_get_field_content_int(0, "sport_plus");
        part_values[3] = cache_get_field_content_int(0, "drift");
        nitro_val = cache_get_field_content_int(0, "nitro");
    }
    cache_delete(result_parts);

    for(new row = 0; row < 4; row++)
    {
        for(new part = 1; part <= 5; part++)
        {
            if(IsPartInstalled(part_values[row], part))
            {
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(part_ids[row][part - 1])));
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
            }
        }
    }

    if(1 <= nitro_val <= 3)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(nitro_val - 1)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    InStailing[playerid] = false;
    RaceStyle_SaveReturn(playerid, vehicleid);

    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    LinkVehicleToInterior(vehicleid, 1);
    SetPlayerInterior(playerid, 1);
    SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5000);
    SetVehicleZAngle(vehicleid, -90.0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    TogglePlayerControllable(playerid, false);
    SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
    SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:techcentergui(playerid, params[])
{
    return ShowTechCenterGUI(playerid);
}

stock RaceTech_SetFirmware(playerid, vehicleid, firmware)
{
    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    if(index == -1) return 0;

    SetOwnableCarData(index, OC_FIRMWARE, firmware);
    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `ownable_cars` SET `firmware`=%d WHERE `id`=%d LIMIT 1",
        firmware,
        GetOwnableCarData(index, OC_SQL_ID)
    );
    mysql_tquery(mysql, query);
    SaveVehicleTuning(vehicleid);
    return 1;
}

stock RaceTech_ApplyFirmware(playerid, vehicleid, firmware)
{
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0 || !IsValidVehicle(vehicleid)) return 0;

    // Сбрасываем физические режимы перед применением новой прошивки.
    SetVehicleDrift(vehicleid, false);
    SetVehicleAccelerationBR(vehicleid, 0.0);

    switch(firmware)
    {
        case 1: // Comfort
        {
            SetVehicleChipTune(vehicleid, 1);
        }
        case 2: // Sport
        {
            SetVehicleChipTune(vehicleid, 2);
            SetVehicleAccelerationBR(vehicleid, 18.0);
        }
        case 3: // Drift
        {
            SetVehicleChipTune(vehicleid, 3);
            SetVehicleDrift(vehicleid, true);
        }
        case 4: // Sport+
        {
            SetVehicleChipTune(vehicleid, 4);
            SetVehicleAccelerationBR(vehicleid, 36.0);
        }
        default:
        {
            SetVehicleChipTune(vehicleid, 0);
        }
    }

    if(playerid != INVALID_PLAYER_ID) SyncVehicleTuningForPlayer(playerid, vehicleid);
    return 1;
}

stock RaceTech_ToggleFirmware(playerid, vehicleid, firmware)
{
    new current = 0;
    if(RaceVehFlags[vehicleid] & VF_COMFORTA) current = 1;
    if(RaceVehFlags[vehicleid] & VF_SPORTA) current = 2;
    if(RaceVehFlags[vehicleid] & VF_DRIFTA) current = 3;
    if(RaceVehFlags[vehicleid] & VF_SPORTPLUSA) current = 4;

    RaceVehFlags[vehicleid] &= ~(VF_COMFORTA | VF_SPORTA | VF_DRIFTA | VF_SPORTPLUSA);

    if(current == firmware)
    {
        RaceTech_ApplyFirmware(playerid, vehicleid, 0);
        RaceTech_SetFirmware(playerid, vehicleid, 0);
        return 0;
    }

    switch(firmware)
    {
        case 1: RaceVehFlags[vehicleid] |= VF_COMFORTA;
        case 2: RaceVehFlags[vehicleid] |= VF_SPORTA;
        case 3: RaceVehFlags[vehicleid] |= VF_DRIFTA;
        case 4: RaceVehFlags[vehicleid] |= VF_SPORTPLUSA;
    }
    RaceTech_ApplyFirmware(playerid, vehicleid, firmware);
    RaceTech_SetFirmware(playerid, vehicleid, firmware);
    return 1;
}


stock RaceTech_HasFirmwareSet(playerid, vehicleid, firmware)
{
    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    if(index == -1) return 0;

    new col_name[20];
    switch(firmware)
    {
        case 1: format(col_name, sizeof col_name, "comfort");
        case 2: format(col_name, sizeof col_name, "sport");
        case 3: format(col_name, sizeof col_name, "drift");
        case 4: format(col_name, sizeof col_name, "sport_plus");
        default: return 0;
    }

    return IsFullSetInstalled(RaceTech_GetSavedPartValue(index, col_name));
}

stock RaceTech_SendRadialState(playerid, type, race_state)
{
    new Node:race_radial_state = JSON_Object();
    JSON_SetInt(race_radial_state, "t", type);
    JSON_SetInt(race_radial_state, "s", race_state);
    SendPacketToClient(playerid, 27, race_radial_state);
    JSON_Cleanup(race_radial_state);
    return 1;
}

stock RaceTech_ResetFirmwareRadialStates(playerid, active_type)
{
    for(new i = 8; i <= 11; i++)
    {
        if(i == active_type) continue;
        RaceTech_SendRadialState(playerid, i, 0);
    }
    return 1;
}

stock RaceTech_HandleRadial(playerid, type, Node:json_radial_data)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
    {
        JSON_SetInt(json_radial_data, "s", 0);
        return 0;
    }

    switch(type)
    {
        case 5:
        {
            new val = vInfo[vehicleid][viLaunchControl] ? 0 : 1;
            SetVehicleLaunchControl(vehicleid, val, 1);
            SaveVehicleTuning(vehicleid);
            JSON_SetInt(json_radial_data, "s", val);
        }
        case 8, 9, 10, 11:
        {
            new firmware = 0;
            switch(type)
            {
                case 8: firmware = 3;
                case 9: firmware = 1;
                case 10: firmware = 2;
                case 11: firmware = 4;
            }

            if(!RaceTech_HasFirmwareSet(playerid, vehicleid, firmware))
            {
                JSON_SetInt(json_radial_data, "s", 0);
                return 1;
            }

            new active = 0;
            if(firmware == 1 && (RaceVehFlags[vehicleid] & VF_COMFORTA)) active = 1;
            else if(firmware == 2 && (RaceVehFlags[vehicleid] & VF_SPORTA)) active = 1;
            else if(firmware == 3 && (RaceVehFlags[vehicleid] & VF_DRIFTA)) active = 1;
            else if(firmware == 4 && (RaceVehFlags[vehicleid] & VF_SPORTPLUSA)) active = 1;

            RaceVehFlags[vehicleid] &= ~(VF_COMFORTA | VF_SPORTA | VF_DRIFTA | VF_SPORTPLUSA);
            RaceTech_ApplyFirmware(playerid, vehicleid, 0);
            RaceTech_ResetFirmwareRadialStates(playerid, type);

            if(active)
            {
                RaceTech_SetFirmware(playerid, vehicleid, 0);
                JSON_SetInt(json_radial_data, "s", 0);
                return 1;
            }

            switch(firmware)
            {
                case 1: RaceVehFlags[vehicleid] |= VF_COMFORTA;
                case 2: RaceVehFlags[vehicleid] |= VF_SPORTA;
                case 3: RaceVehFlags[vehicleid] |= VF_DRIFTA;
                case 4: RaceVehFlags[vehicleid] |= VF_SPORTPLUSA;
            }
            RaceTech_ApplyFirmware(playerid, vehicleid, firmware);
            RaceTech_SetFirmware(playerid, vehicleid, firmware);
            JSON_SetInt(json_radial_data, "s", 1);
            RaceTech_SendRadialState(playerid, type, 1);
        }
        case 12:
        {
            if(vInfo[vehicleid][vNeon1] == 0 && vInfo[vehicleid][vNeon2] == 0 && vInfo[vehicleid][vNeon3] == 0)
            {
                vInfo[vehicleid][vEnableNeon] = 0;
                JSON_SetInt(json_radial_data, "s", 0);
                return 1;
            }
            new val = vInfo[vehicleid][vEnableNeon] ? 0 : 1;
            vInfo[vehicleid][vEnableNeon] = val;
            if(val) SetVehicleNeon(vehicleid, vInfo[vehicleid][vNeon1], vInfo[vehicleid][vNeon2], vInfo[vehicleid][vNeon3], 0);
            else SetVehicleNeon(vehicleid, 0, 0, 0, 0);
            SaveVehicleTuning(vehicleid);
            JSON_SetInt(json_radial_data, "s", val);
        }
        case 13:
        {
            if(vInfo[vehicleid][vHighLights] <= 0 && vInfo[vehicleid][vEnableHighLights] <= 0)
            {
                JSON_SetInt(json_radial_data, "s", 0);
                return 1;
            }
            new val = vInfo[vehicleid][vEnableHighLights] ? 0 : 1;
            vInfo[vehicleid][vEnableHighLights] = val;
            foreach(new p: Player)
            {
                if(IsVehicleStreamedIn(vehicleid, p)) SetVehicleDlaniy(p, vehicleid, val);
            }
            SaveVehicleTuning(vehicleid);
            JSON_SetInt(json_radial_data, "s", val);
        }
        case 15:
        {
            new strob_level = vInfo[vehicleid][viStrob];
            if(strob_level <= 0) strob_level = vInfo[vehicleid][vStrob];
            if(strob_level <= 0)
            {
                JSON_SetInt(json_radial_data, "s", 0);
                return 1;
            }

            new val = vInfo[vehicleid][vEnableStrob] ? 0 : 1;
            vInfo[vehicleid][vEnableStrob] = val;
            SetVehicleStroboscope(vehicleid, val ? strob_level : 5, 0);
            SaveVehicleTuning(vehicleid);
            JSON_SetInt(json_radial_data, "s", val);
        }
        case 19:
        {
            if(vInfo[vehicleid][viHydraulics] <= 0)
            {
                vInfo[vehicleid][vEnableHydraulics] = 0;
                JSON_SetInt(json_radial_data, "s", 0);
                return 1;
            }
            new val = vInfo[vehicleid][vEnableHydraulics] ? 0 : 1;
            vInfo[vehicleid][vEnableHydraulics] = val;
            SetVehicleHydraulics(vehicleid, val ? vInfo[vehicleid][viHydraulics] : 0, 0);
            SaveVehicleTuning(vehicleid);
            JSON_SetInt(json_radial_data, "s", val);
        }
        case 28:
        {
            callcmd::tungui(playerid, "");
            JSON_SetInt(json_radial_data, "s", 1);
        }
        case 29:
        {
            callcmd::shinka(playerid, "");
            JSON_SetInt(json_radial_data, "s", 1);
        }
        case 30:
        {
            callcmd::techcentergui(playerid, "");
            JSON_SetInt(json_radial_data, "s", 1);
        }
    }
    return 1;
}

stock RaceTech_SaveStroboscope(playerid, vehicleid, strobLevel)
{
    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    if(index == -1) return 0;

    vInfo[vehicleid][viStrob] = strobLevel;
    vInfo[vehicleid][vStrob] = strobLevel;
    // Purchase does not auto-enable strobe after reconnect.
    if(vInfo[vehicleid][vEnableStrob]) SetVehicleStroboscope(vehicleid, strobLevel, 0);
    else SetVehicleStroboscope(vehicleid, 5, 0);
    SaveVehicleTuning(vehicleid);
    return 1;
}

stock RaceTech_SaveHighLight(playerid, vehicleid, lightLevel)
{
    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    if(index == -1) return 0;

    vInfo[vehicleid][viHighLights] = lightLevel;
    vInfo[vehicleid][vHighLights] = lightLevel;
    // Purchase does not auto-enable high light after reconnect.
    if(vInfo[vehicleid][vEnableHighLights]) SetVehicleHighLight(vehicleid, lightLevel, 0);
    else SetVehicleHighLight(vehicleid, 0, 0);
    SaveVehicleTuning(vehicleid);
    return 1;
}

stock PacketIncomingTuning(playerid, Node:JSONObject)
{
    new Node:response = JSON_Object();
    new type, status, detail_id, selector_id, operation, sound_id;
    new color_hex[64], color_val;

    JSON_GetInt(JSONObject, "t", type);
    JSON_GetInt(JSONObject, "s", status);
    JSON_GetInt(JSONObject, "m", selector_id);
    JSON_GetInt(JSONObject, "d", detail_id);
    JSON_GetInt(JSONObject, "p", detail_id);
    JSON_GetInt(JSONObject, "mt", operation);
    JSON_GetInt(JSONObject, "h", sound_id);
    JSON_GetString(JSONObject, "d", color_hex, sizeof(color_hex));
    JSON_GetString(JSONObject, "co", color_hex, sizeof(color_hex));

    JSON_SetInt(response, "t", type);
    JSON_SetInt(response, "s", 0);

    new vehicleid = GetPlayerVehicleID(playerid);
    new index = Race_GetOwnedVehicleIndex(playerid, vehicleid);
    new price = Race_GetVehiclePrice(vehicleid);

    switch(type)
    {
        case 0:
        {
            RaceStyle_RestoreVehicle(playerid);
            JSON_SetInt(response, "s", 1);
        }
        case 1:
        {
            if(index != -1)
            {
                sscanf(color_hex, "h", color_val);
                new pay = GetBodyPaintCost(price);

                switch(selector_id)
                {
                    case 0: // цвет кузова
                    {
                        pay = GetBodyPaintCost(price);
                        if(GetPlayerMoneyEx(playerid) >= pay)
                        {
                            GivePlayerMoneyEx(playerid, -pay);
                            new body[2], wheel[2];
                            body[0] = color_val;
                            body[1] = color_val;
                            wheel[0] = GetOwnableCarData(index, OC_COLOR_2);
                            wheel[1] = GetOwnableCarData(index, OC_COLOR_2);
                            SetVehicleColor(vehicleid, body, wheel, 1);
                            SetOwnableCarData(index, OC_COLOR_1, color_val);
                            SaveVehicleTuning(vehicleid);
                            RaceNotifySuccess(playerid, "Покраска кузова успешно куплена и установлена");
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                        }
                    }
                    case 1: // цвет дисков
                    {
                        pay = GetBodyPaintCost(price);
                        if(GetPlayerMoneyEx(playerid) >= pay)
                        {
                            GivePlayerMoneyEx(playerid, -pay);
                            new body[2], wheel[2];
                            body[0] = GetOwnableCarData(index, OC_COLOR_1);
                            body[1] = GetOwnableCarData(index, OC_COLOR_1);
                            wheel[0] = color_val;
                            wheel[1] = color_val;
                            SetVehicleColor(vehicleid, body, wheel, 1);
                            SetOwnableCarData(index, OC_COLOR_2, color_val);
                            SaveVehicleTuning(vehicleid);
                            RaceNotifySuccess(playerid, "Цвет дисков успешно куплен и установлен");
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                        }
                    }
                    case 3, 4: // тонировка как в new.zip: перед / зад + боковые окна
                    {
                        pay = GetExtraCost(price);
                        if(GetPlayerMoneyEx(playerid) >= pay)
                        {
                            GivePlayerMoneyEx(playerid, -pay);

                            if(selector_id == 3)
                            {
                                vInfo[vehicleid][viTonerFront] = color_val;
                                vInfo[vehicleid][viTonerFrontSide] = color_val;
                            }
                            else
                            {
                                vInfo[vehicleid][viTonerRear] = color_val;
                                vInfo[vehicleid][viTonerRearSide] = color_val;
                            }

                            SetVehicleTonerRPC(vehicleid,
                                vInfo[vehicleid][viTonerFront],
                                vInfo[vehicleid][viTonerRear],
                                vInfo[vehicleid][viTonerFrontSide],
                                vInfo[vehicleid][viTonerRearSide],
                                1
                            );

                            SaveVehicleTuning(vehicleid);
                            RaceNotifySuccess(playerid, "Тонировка успешно куплена и установлена");
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                        }
                    }
                    case 10: // цвет фар
                    {
                        pay = GetDoubleCost(price);
                        if(GetPlayerMoneyEx(playerid) >= pay)
                        {
                            GivePlayerMoneyEx(playerid, -pay);
                            vInfo[vehicleid][vLightColor] = color_val;
                            RaceTuning_ApplyLightColor(vehicleid);
                            SaveVehicleTuning(vehicleid);
                            RaceNotifySuccess(playerid, "Цвет фар успешно куплен и установлен");
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                        }
                    }
                    case 11, 12, 13: // неон как в new.zip
                    {
                        pay = GetUnivCost(price);
                        if(GetPlayerMoneyEx(playerid) >= pay)
                        {
                            GivePlayerMoneyEx(playerid, -pay);
                            if(selector_id == 11) vInfo[vehicleid][vNeon1] = color_val;
                            else if(selector_id == 12) vInfo[vehicleid][vNeon2] = color_val;
                            else if(selector_id == 13) vInfo[vehicleid][vNeon3] = color_val;
                            SetVehicleNeon(vehicleid, vInfo[vehicleid][vNeon1], vInfo[vehicleid][vNeon2], vInfo[vehicleid][vNeon3], 1);
                            SaveVehicleTuning(vehicleid);
                            RaceNotifySuccess(playerid, "Неон успешно куплен и установлен");
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                        }
                    }
                }
            }
        }
        case 3:
        {
            if(index != -1 && 0 <= detail_id < sizeof(VinylNames))
            {
                new pay = GetUnivCost(price);
                if(GetPlayerMoneyEx(playerid) >= pay)
                {
                    GivePlayerMoneyEx(playerid, -pay);
                    SetVehicleVinyl(vehicleid, VinylNames[detail_id], 1);
                    SaveVehicleTuning(vehicleid);
                    RaceNotifySuccess(playerid, "Винил успешно куплен и установлен");
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                }
            }
        }
        case 7:
        {
            if(index != -1)
            {
                new pay = GetUnivCost(price);

                if(detail_id == 130)
                {
                    pay = GetDalniyCost(price);
                    if(GetPlayerMoneyEx(playerid) >= pay && RaceTech_SaveHighLight(playerid, vehicleid, 1))
                    {
                        GivePlayerMoneyEx(playerid, -pay);
                        RaceNotifySuccess(playerid, "Дальний свет успешно куплен и установлен");
                        JSON_SetInt(response, "p", detail_id);
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                    }
                }
                else if(detail_id == 32)
                {
                    pay = GetDonatCost(price);
                    if(GetPlayerDonateRub(playerid) >= pay && RaceTech_SaveStroboscope(playerid, vehicleid, 4))
                    {
                        GivePlayerDonateRub(playerid, -pay, "Покупка стробоскопов", true);
                        RaceNotifySuccess(playerid, "Стробоскопы успешно куплены и установлены");
                        JSON_SetInt(response, "p", detail_id);
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                    }
                }
                else if(28 <= detail_id <= 31)
                {
                    new strobLevel = detail_id - 27;
                    if(GetPlayerMoneyEx(playerid) >= pay && RaceTech_SaveStroboscope(playerid, vehicleid, strobLevel))
                    {
                        GivePlayerMoneyEx(playerid, -pay);
                        RaceNotifySuccess(playerid, "Стробоскопы успешно куплены и установлены");
                        JSON_SetInt(response, "p", detail_id);
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                    }
                }
                else
                {
                    if(RaceTech_GetFirmwareFromDetail(detail_id)) pay = (price / 100) + 15000;
                    if(GetPlayerMoneyEx(playerid) >= pay && BuyPart(playerid, vehicleid, detail_id))
                    {
                        GivePlayerMoneyEx(playerid, -pay);
                        RaceNotifySuccess(playerid, "Деталь успешно куплена и установлена");
                        JSON_SetInt(response, "p", detail_id);
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                    }
                }
            }
        }
        case 20, 21, 22, 23, 24, 25, 26, 27, 28, 29:
        {
            if(index != -1)
            {
                new Float:fval, ival, pay = GetShinaPrice(price, 0);
                JSON_GetFloat(JSONObject, "v", fval);
                JSON_GetInt(JSONObject, "v", ival);

                switch(type)
                {
                    case 20: pay = GetShinaPrice(price, 0);
                    case 21, 22: pay = GetShinaPrice(price, 1);
                    case 23, 24: pay = GetShinaPrice(price, 2);
                    case 25, 26: pay = GetShinaPrice(price, 3);
                    case 27: pay = GetShinaPrice(price, 4);
                    case 28: pay = GetShinaPrice(price, 5);
                    case 29: pay = GetShinaPrice(price, 6);
                }

                if(GetPlayerMoneyEx(playerid) >= pay)
                {
                    GivePlayerMoneyEx(playerid, -pay);
                    switch(type)
                    {
                        case 20: SetVehicleWheelSizeRPC(vehicleid, fval, 1);
                        case 21: SetVehicleWheelAdditive(vehicleid, fval, vInfo[vehicleid][vWheelAddRear], 1);
                        case 22: SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][vWheelAddFront], fval, 1);
                        case 23: SetVehicleWheelDeparture(vehicleid, fval, 0.0, 1);
                        case 24: SetVehicleWheelDeparture(vehicleid, 0.0, fval, 1);
                        case 25: SetVehicleWheelAlignment(vehicleid, fval, 0.0, 1);
                        case 26: SetVehicleWheelAlignment(vehicleid, 0.0, fval, 1);
                        case 27: SetVehicleSuspensionForce(vehicleid, floatround(fval), 1);
                        case 28: SetVehicleHydraulics(vehicleid, ival, 1);
                    }
                    SaveVehicleTuning(vehicleid);
                    RaceNotifySuccess(playerid, "Настройка колёс успешно куплена и установлена");
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                }
            }
        }
        case 8:
        {
            if(index != -1)
            {
                new pay = GetDonatCost(price);
                if(GetPlayerDonateRub(playerid) >= pay)
                {
                    GivePlayerDonateRub(playerid, -pay, "Покупка неона", true);
                    sscanf(color_hex, "h", color_val);
                    SetVehicleNeon(vehicleid, color_val, color_val, color_val, 1);
                    SaveVehicleTuning(vehicleid);
                    RaceNotifySuccess(playerid, "Неон успешно куплен и установлен");
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                }
            }
        }
        case 12:
        {
            if(index != -1)
            {
                new pay = GetUnivCost(price);
                if(GetPlayerMoneyEx(playerid) >= pay)
                {
                    GivePlayerMoneyEx(playerid, -pay);
                    SetVehicleTint(vehicleid, detail_id, 1);
                    SaveVehicleTuning(vehicleid);
                    RaceNotifySuccess(playerid, "Тонировка успешно куплена и установлена");
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                }
            }
        }
        case 18:
        {
            if(index != -1)
            {
                new pay = GetUnivCost(price);
                if(GetPlayerMoneyEx(playerid) >= pay)
                {
                    GivePlayerMoneyEx(playerid, -pay);
                    if(sound_id > 0) detail_id = sound_id;
                    vInfo[vehicleid][viHornSound] = detail_id;
                    SetVehicleHornSound(vehicleid, detail_id, 1);
                    SaveVehicleTuning(vehicleid);
                    RaceNotifySuccess(playerid, "Звук сигнала успешно куплен и установлен");
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                }
            }
        }
        case 19:
        {
            if(index != -1)
            {
                new pay = GetUnivCost(price);
                if(GetPlayerMoneyEx(playerid) >= pay)
                {
                    GivePlayerMoneyEx(playerid, -pay);
                    if(sound_id > 0) detail_id = sound_id;
                    vInfo[vehicleid][viExhaustSound] = detail_id;
                    SetVehicleExhaust(vehicleid, detail_id, 1);
                    SaveVehicleTuning(vehicleid);
                    RaceNotifySuccess(playerid, "Выхлоп успешно куплен и установлен");
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                }
            }
        }
    }

    new response_status;
    JSON_GetInt(response, "s", response_status);
    if(!response_status)
    {
        switch(type)
        {
            case 1, 3, 7, 8, 12, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 130:
            {
                if(index == -1) RaceNotifyError(playerid, "Это не ваш личный транспорт!");
                else RaceNotifyError(playerid, "Недостаточно средств или деталь недоступна");
            }
        }
    }

    SendPacketToClient(playerid, 28, response);
    JSON_Cleanup(response);
    return 1;
}

CMD:comforton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ToggleFirmware(playerid, vehicleid, 1);
    return 1;
}

CMD:comfortoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ApplyFirmware(playerid, vehicleid, 0);
    return 1;
}

CMD:sporton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ToggleFirmware(playerid, vehicleid, 2);
    return 1;
}

CMD:sportoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ApplyFirmware(playerid, vehicleid, 0);
    return 1;
}

CMD:sportpluson(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ToggleFirmware(playerid, vehicleid, 4);
    return 1;
}

CMD:sportplusoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ApplyFirmware(playerid, vehicleid, 0);
    return 1;
}

CMD:drifton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ToggleFirmware(playerid, vehicleid, 3);
    return 1;
}

CMD:driftoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ApplyFirmware(playerid, vehicleid, 0);
    return 1;
}

CMD:tuningoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    RaceTech_ApplyFirmware(playerid, vehicleid, 0);
    RaceVehFlags[vehicleid] = 0;
    return 1;
}

#endif
