/*
    Horn donor Tech Center + Style Center for laird.pwn structure.
    Clean active horn/style/tech radial module
    Adapted to this mod ownable_cars/vInfo storage
    Adapted to this mod's ownable_cars/vInfo system, without VehicleInfo[][] dependency.
*/
#if !defined HORN_STYLE_TECH_RADIAL_INCLUDED
#define HORN_STYLE_TECH_RADIAL_INCLUDED

#define TECH_STYLE_WORLD      (101)
#define TECH_STYLE_INTERIOR   (1)

new g_TechStyleComfort[MAX_VEHICLES];
new g_TechStyleSport[MAX_VEHICLES];
new g_TechStyleSportPlus[MAX_VEHICLES];
new g_TechStyleDrift[MAX_VEHICLES];
new g_TechStyleNitro[MAX_VEHICLES];
new bool:g_TechStyleLabelsCreated;

new Float:g_TechStyleReturnX[MAX_PLAYERS];
new Float:g_TechStyleReturnY[MAX_PLAYERS];
new Float:g_TechStyleReturnZ[MAX_PLAYERS];
new Float:g_TechStyleReturnA[MAX_PLAYERS];
new g_TechStyleReturnVW[MAX_PLAYERS];
new g_TechStyleReturnInt[MAX_PLAYERS];
new g_TechStyleReturnVehicle[MAX_PLAYERS];

static const Float:g_TechCenterEnter[3][3] =
{
    {-426.2352, 1005.4126, 14.8000},
    {-420.0545, 1005.4092, 14.8000},
    {-413.5492, 1005.5430, 14.8000}
};

static const Float:g_StyleCenterEnter[3][3] =
{
    {2311.4189, -2607.4873, 21.8084},
    {2311.4248, -2613.4609, 21.8084},
    {2311.3186, -2619.4074, 21.8084}
};

stock HornTechStyle_DBInit()
{
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `comfort` INT NOT NULL DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `sport` INT NOT NULL DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `sport_plus` INT NOT NULL DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `drift` INT NOT NULL DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `nitro` INT NOT NULL DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_launch_control` INT NOT NULL DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_vinyl` TINYINT DEFAULT 0", "", "");
    return 1;
}

stock HornTechStyle_CreateLabels()
{
    if(g_TechStyleLabelsCreated) return 1;
    g_TechStyleLabelsCreated = true;

    for(new i; i < 3; i++)
    {
        CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1,
            g_TechCenterEnter[i][0], g_TechCenterEnter[i][1], g_TechCenterEnter[i][2],
            50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);

        CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1,
            g_StyleCenterEnter[i][0], g_StyleCenterEnter[i][1], g_StyleCenterEnter[i][2],
            25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
    }
    return 1;
}

stock TechStyle_LoadFromCache(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return 0;
    if(cache_num_rows() <= 0) return 0;

    g_TechStyleComfort[vehicleid]   = cache_get_field_content_int(0, "comfort");
    g_TechStyleSport[vehicleid]     = cache_get_field_content_int(0, "sport");
    g_TechStyleSportPlus[vehicleid] = cache_get_field_content_int(0, "sport_plus");
    g_TechStyleDrift[vehicleid]     = cache_get_field_content_int(0, "drift");
    g_TechStyleNitro[vehicleid]     = cache_get_field_content_int(0, "nitro");
    vInfo[vehicleid][viLaunchControl] = cache_get_field_content_int(0, "tuning_launch_control");
    vInfo[vehicleid][vVinyl]        = cache_get_field_content_int(0, "tuning_vinyl");
    return 1;
}

stock TechStyle_IsPartInstalled(value, part)
{
    if(value <= 0) return 0;
    while(value > 0)
    {
        if(value % 10 == part) return 1;
        value /= 10;
    }
    return 0;
}

stock TechStyle_AddPartValue(value, part)
{
    if(TechStyle_IsPartInstalled(value, part)) return value;
    switch(part)
    {
        case 1: value += 1;
        case 2: value += 20;
        case 3: value += 300;
        case 4: value += 4000;
        case 5: value += 50000;
    }
    return value;
}

stock TechStyle_IsFullSet(value)
{
    return TechStyle_IsPartInstalled(value, 1) && TechStyle_IsPartInstalled(value, 2) &&
        TechStyle_IsPartInstalled(value, 3) && TechStyle_IsPartInstalled(value, 4) &&
        TechStyle_IsPartInstalled(value, 5);
}

stock TechStyle_GetVehicleBasePrice(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return 0;
    new model = GetVehicleModel(vehicleid);
    if(model >= 400 && model <= 611) return GetVehicleInfo(model - 400, VI_PRICE);
    return 0;
}

stock TechStyle_GetTuningPrice(base_price, tune_id)
{
    new Float:percent, added;
    switch(tune_id)
    {
        case 0: { percent = 4.0; added = 15000; } // comfort
        case 1: { percent = 7.0; added = 15000; } // sport
        case 2: { percent = 5.0; added = 15000; } // drift
        case 3: { percent = 9.0; added = 25000; } // sport+
        default: return 0;
    }
    return floatround((float(base_price) * percent / 100.0) + float(added));
}

stock TechStyle_GetNitroPrice(base_price, nitro_id)
{
    new Float:percent;
    switch(nitro_id)
    {
        case 0: percent = 2.0;
        case 1: percent = 5.0;
        case 2: percent = 7.0;
        default: return 0;
    }
    return floatround((float(base_price) * percent / 100.0) + 15000.0);
}

stock TechStyle_GetLaunchPrice(base_price)
{
    return floatround((float(base_price) * 6.0 / 100.0) + 25000.0);
}

stock TechStyle_GetOwnableIndex(playerid, vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return -1;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) return -1;

    new idx = GetVehicleData(vehicleid, V_ACTION_ID);
    if(idx < 0 || idx >= MAX_OWNABLE_CARS) return -1;
    if(GetOwnableCarData(idx, OC_OWNER_ID) != GetPlayerAccountID(playerid)) return -1;
    return idx;
}

stock TechStyle_SaveColumn(vehicleid, const column[], value)
{
    new idx = GetVehicleData(vehicleid, V_ACTION_ID);
    if(idx < 0 || idx >= MAX_OWNABLE_CARS) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`=%d WHERE `id`=%d LIMIT 1", column, value, GetOwnableCarData(idx, OC_SQL_ID));
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock TechStyle_BuyPart(playerid, vehicleid, detal_id)
{
    new idx = TechStyle_GetOwnableIndex(playerid, vehicleid);
    if(idx == -1) return 0;

    new type, part_num, current_val, new_val;
    new col_name[24];

    switch(detal_id)
    {
        case 4:  { type = 3; part_num = 1; }
        case 9:  { type = 3; part_num = 2; }
        case 14: { type = 3; part_num = 3; }
        case 19: { type = 3; part_num = 4; }
        case 24: { type = 3; part_num = 5; }

        case 5:  { type = 1; part_num = 1; }
        case 10: { type = 1; part_num = 2; }
        case 15: { type = 1; part_num = 3; }
        case 20: { type = 1; part_num = 4; }
        case 25: { type = 1; part_num = 5; }

        case 6:  { type = 2; part_num = 1; }
        case 11: { type = 2; part_num = 2; }
        case 16: { type = 2; part_num = 3; }
        case 21: { type = 2; part_num = 4; }
        case 26: { type = 2; part_num = 5; }

        case 7:  { type = 4; part_num = 1; }
        case 12: { type = 4; part_num = 2; }
        case 17: { type = 4; part_num = 3; }
        case 22: { type = 4; part_num = 4; }
        case 27: { type = 4; part_num = 5; }

        case 0..2:
        {
            if(g_TechStyleNitro[vehicleid] == detal_id + 1) return 0;
            g_TechStyleNitro[vehicleid] = detal_id + 1;
            TechStyle_SaveColumn(vehicleid, "nitro", g_TechStyleNitro[vehicleid]);

            new nitro_component;
            switch(detal_id)
            {
                case 0: nitro_component = 1009;
                case 1: nitro_component = 1008;
                case 2: nitro_component = 1010;
            }
            if(nitro_component) AddVehicleComponent(vehicleid, nitro_component);
            return 1;
        }
        case 3:
        {
            if(vInfo[vehicleid][viLaunchControl] > 0) return 0;
            SetVehicleLaunchControl(vehicleid, 1, 1);
            TechStyle_SaveColumn(vehicleid, "tuning_launch_control", vInfo[vehicleid][viLaunchControl]);
            return 1;
        }
        default: return 0;
    }

    switch(type)
    {
        case 1: { current_val = g_TechStyleSport[vehicleid]; format(col_name, sizeof(col_name), "sport"); }
        case 2: { current_val = g_TechStyleDrift[vehicleid]; format(col_name, sizeof(col_name), "drift"); }
        case 3: { current_val = g_TechStyleComfort[vehicleid]; format(col_name, sizeof(col_name), "comfort"); }
        case 4: { current_val = g_TechStyleSportPlus[vehicleid]; format(col_name, sizeof(col_name), "sport_plus"); }
    }

    if(TechStyle_IsPartInstalled(current_val, part_num)) return 0;
    new_val = TechStyle_AddPartValue(current_val, part_num);

    switch(type)
    {
        case 1: g_TechStyleSport[vehicleid] = new_val;
        case 2: g_TechStyleDrift[vehicleid] = new_val;
        case 3: g_TechStyleComfort[vehicleid] = new_val;
        case 4: g_TechStyleSportPlus[vehicleid] = new_val;
    }

    TechStyle_SaveColumn(vehicleid, col_name, new_val);
    return 1;
}

stock TechStyle_AddInstalledParts(Node:k_array, value, const part_ids[])
{
    for(new p = 1; p <= 5; p++)
    {
        if(TechStyle_IsPartInstalled(value, p))
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(part_ids[p - 1])));
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
        }
    }
    return 1;
}

stock TechStyle_OpenTechCenter(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || vehicleid == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны быть в машине!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны быть за рулем транспорта.");
    if(TechStyle_GetOwnableIndex(playerid, vehicleid) == -1) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Это не ваш личный транспорт.");

    new model = GetVehicleModel(vehicleid);
    new price = TechStyle_GetVehicleBasePrice(vehicleid);
    new Node:tuning_json = JSON_Object();
    new Node:k_array = JSON_Array();

    static const comfort_ids[5] = {4, 9, 14, 19, 24};
    static const sport_ids[5] = {5, 10, 15, 20, 25};
    static const sportplus_ids[5] = {7, 12, 17, 22, 27};
    static const drift_ids[5] = {6, 11, 16, 21, 26};

    TechStyle_AddInstalledParts(k_array, g_TechStyleComfort[vehicleid], comfort_ids);
    TechStyle_AddInstalledParts(k_array, g_TechStyleSport[vehicleid], sport_ids);
    TechStyle_AddInstalledParts(k_array, g_TechStyleSportPlus[vehicleid], sportplus_ids);
    TechStyle_AddInstalledParts(k_array, g_TechStyleDrift[vehicleid], drift_ids);

    if(g_TechStyleNitro[vehicleid] >= 1 && g_TechStyleNitro[vehicleid] <= 3)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(g_TechStyleNitro[vehicleid] - 1)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    if(vInfo[vehicleid][viLaunchControl] > 0)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(3)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    new vehicle_name[64];
    if(model >= 400 && model <= 611) format(vehicle_name, sizeof(vehicle_name), "%s", GetVehicleInfo(model - 400, VI_NAME));
    else format(vehicle_name, sizeof(vehicle_name), "Vehicle");

    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", vehicle_name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    GetVehiclePos(vehicleid, g_TechStyleReturnX[playerid], g_TechStyleReturnY[playerid], g_TechStyleReturnZ[playerid]);
    GetVehicleZAngle(vehicleid, g_TechStyleReturnA[playerid]);
    g_TechStyleReturnVW[playerid] = GetPlayerVirtualWorld(playerid);
    g_TechStyleReturnInt[playerid] = GetPlayerInterior(playerid);
    g_TechStyleReturnVehicle[playerid] = vehicleid;

    SetPVarInt(playerid, "TechStyleCenter", 1);
    SetPlayerVirtualWorld(playerid, TECH_STYLE_WORLD + playerid);
    SetVehicleVirtualWorld(vehicleid, TECH_STYLE_WORLD + playerid);
    LinkVehicleToInterior(vehicleid, TECH_STYLE_INTERIOR);
    SetPlayerInterior(playerid, TECH_STYLE_INTERIOR);

    SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5000);
    SetVehicleZAngle(vehicleid, -90.0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
    SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock TechStyle_CloseTechCenter(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || vehicleid == INVALID_VEHICLE_ID) vehicleid = g_TechStyleReturnVehicle[playerid];

    SetPlayerVirtualWorld(playerid, g_TechStyleReturnVW[playerid]);
    SetPlayerInterior(playerid, g_TechStyleReturnInt[playerid]);
    DeletePVar(playerid, "TechStyleCenter");

    if(vehicleid && vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, g_TechStyleReturnVW[playerid]);
        LinkVehicleToInterior(vehicleid, g_TechStyleReturnInt[playerid]);
        SetVehiclePos(vehicleid, g_TechStyleReturnX[playerid], g_TechStyleReturnY[playerid], g_TechStyleReturnZ[playerid]);
        SetVehicleZAngle(vehicleid, g_TechStyleReturnA[playerid]);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        SaveVehicleTuning(vehicleid);
    }
    else SetPlayerPos(playerid, g_TechStyleReturnX[playerid], g_TechStyleReturnY[playerid], g_TechStyleReturnZ[playerid]);

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);
    g_TechStyleReturnVehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

stock TechStyle_HandlePacket(playerid, Node:JSONObject)
{
    if(GetPVarInt(playerid, "TechStyleCenter") != 1) return 0;

    new type, detal_id, status;
    JSON_GetInt(JSONObject, "t", type);
    JSON_GetInt(JSONObject, "s", status);
    JSON_GetInt(JSONObject, "d", detal_id);
    JSON_GetInt(JSONObject, "p", detal_id);

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", type);
    JSON_SetInt(response, "s", 0);

    switch(type)
    {
        case 0:
        {
            if(GetPVarInt(playerid, "TechStyleIgnoreClose") > gettime())
            {
                DeletePVar(playerid, "TechStyleIgnoreClose");
            }
            else
            {
                TechStyle_CloseTechCenter(playerid);
            }
            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
            JSON_SetInt(response, "s", 1);
        }
        case 6:
        {
            JSON_SetInt(response, "a", 1);
            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
            JSON_SetInt(response, "s", 1);
        }
        case 7:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            new base_price = TechStyle_GetVehicleBasePrice(vehicleid);
            new price, pay_money = 1;

            switch(detal_id)
            {
                case 4, 9, 14, 19, 24: price = TechStyle_GetTuningPrice(base_price, 0);
                case 5, 10, 15, 20, 25: price = TechStyle_GetTuningPrice(base_price, 1);
                case 6, 11, 16, 21, 26: price = TechStyle_GetTuningPrice(base_price, 2);
                case 7, 12, 17, 22, 27: price = TechStyle_GetTuningPrice(base_price, 3);
                case 0, 1, 2: price = TechStyle_GetNitroPrice(base_price, detal_id);
                case 3: price = TechStyle_GetLaunchPrice(base_price);
            }

            if(price > 0)
            {
                if(pay_money && GetPlayerMoneyEx(playerid) >= price)
                {
                    if(TechStyle_BuyPart(playerid, vehicleid, detal_id))
                    {
                        GivePlayerMoneyEx(playerid, -price);
                        SetPVarInt(playerid, "TechStyleIgnoreClose", gettime() + 3);
                        SaveVehicleTuning(vehicleid);
                        JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
                        JSON_SetInt(response, "p", detal_id);
                        JSON_SetInt(response, "s", 1);
                    }
                }
            }
        }
        case 5, 18, 28:
        {
            JSON_SetInt(response, "s", 1);
            JSON_SetInt(response, "m", GetPlayerMoneyEx(playerid));
        }
    }

    SendPacketToClient(playerid, 28, response);
    JSON_Cleanup(response);
    return 1;
}

stock TechStyle_IsNearTechCenter(playerid)
{
    for(new i; i < 3; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 9.0, g_TechCenterEnter[i][0], g_TechCenterEnter[i][1], g_TechCenterEnter[i][2])) return 1;
    }
    return 0;
}

stock TechStyle_IsNearStyleCenter(playerid)
{
    for(new i; i < 3; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 9.0, g_StyleCenterEnter[i][0], g_StyleCenterEnter[i][1], g_StyleCenterEnter[i][2])) return 1;
    }
    return 0;
}

stock HornTechStyle_TryOpenByHorn(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    if(!IsPlayerInAnyVehicle(playerid)) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(TechStyle_GetOwnableIndex(playerid, vehicleid) == -1)
    {
        if(TechStyle_IsNearTechCenter(playerid) || TechStyle_IsNearStyleCenter(playerid))
        {
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны быть за рулем своего личного транспорта.");
            return 1;
        }
        return 0;
    }

    if(TechStyle_IsNearTechCenter(playerid)) return TechStyle_OpenTechCenter(playerid);
    if(TechStyle_IsNearStyleCenter(playerid)) return ShowTuningStylingGUI(playerid);
    return 0;
}

CMD:techcentergui(playerid, params[])
{
    #pragma unused params
    return TechStyle_OpenTechCenter(playerid);
}

CMD:techcenter(playerid, params[])
{
    #pragma unused params
    return TechStyle_OpenTechCenter(playerid);
}

CMD:tungui(playerid, params[])
{
    #pragma unused params
    return ShowTuningStylingGUI(playerid);
}

CMD:stylecenter(playerid, params[])
{
    #pragma unused params
    return ShowTuningStylingGUI(playerid);
}

CMD:stailing(playerid, params[])
{
    #pragma unused params
    return ShowTuningStylingGUI(playerid);
}

#endif