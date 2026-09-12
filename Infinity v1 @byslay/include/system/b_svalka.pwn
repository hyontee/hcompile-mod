// ===================== [SCRAP YARD JOB] =====================
#define SCRAP_YARD_CARS            (4)
#define SCRAP_YARD_SPAWN_POINTS    (9)
#define SCRAP_YARD_RESPAWN_TIME    (1500000) // 25 minutes
#define SCRAP_YARD_CAR_NOTIFY_ID   (9130)
#define SCRAP_YARD_NPC_NOTIFY_ID   (9131)
#define SCRAP_YARD_DIALOG_1        (51900)
#define SCRAP_YARD_DIALOG_2        (51901)
#define SCRAP_YARD_DIALOG_3        (51902)
#define SCRAP_YARD_DIALOG_4        (51903)
#define SCRAP_YARD_DIALOG_5        (51904)
#define SCRAP_YARD_DIALOG_6        (51905)
#define SCRAP_YARD_DIALOG_7        (51906)

new g_scrap_yard_actor = INVALID_ACTOR_ID;
new g_scrap_yard_vehicle[SCRAP_YARD_CARS];
new g_scrap_yard_model[SCRAP_YARD_CARS];
new g_scrap_yard_price[SCRAP_YARD_CARS];
new g_scrap_yard_owner[SCRAP_YARD_CARS];
new g_scrap_yard_player_vehicle[MAX_PLAYERS];
new g_scrap_yard_player_ownable_vehicle[MAX_PLAYERS];
new g_scrap_yard_player_ownable_sql[MAX_PLAYERS];

static const Float:g_scrap_yard_spawn_points[SCRAP_YARD_SPAWN_POINTS][4] =
{
    {-1597.272216, -2136.511474, 28.659526, 273.0},
    {-1603.500000, -2140.000000, 28.650000, 180.0},
    {-1590.500000, -2130.000000, 28.650000, 90.0},
    {-1630.492797, -2136.180419, 29.291713, 335.0},
    {-1623.000000, -2144.000000, 29.000000, 250.0},
    {-1638.000000, -2128.000000, 29.000000, 70.0},
    {-1665.372436, -2180.135742, 28.917140, 176.0},
    {-1656.000000, -2174.000000, 28.800000, 95.0},
    {-1674.000000, -2186.000000, 29.000000, 270.0}
};

static const g_scrap_yard_models[] = {2610, 404, 585, 466, 502, 579, 555, 458, 28730};
static const g_scrap_yard_prices[] = {175000, 75000, 95000, 1900000, 5000000, 7000000, 20000, 195000, 6000000};

forward ScrapYard_Respawn();
forward ScrapYard_Init();
forward ScrapYard_DestroyCars();
forward ScrapYard_SpawnCars();
forward ScrapYard_FindSlotByVehicle(vehicleid);
forward ScrapYard_FindPlayerVehicleSlot(playerid);
forward ScrapYard_GetPlayerOwnableFoundVehicle(playerid);
forward ScrapYard_ConvertFoundCarToOwnable(playerid, slot);
forward ScrapYard_GetCarPrice(modelid);
forward ScrapYard_GetCarName(modelid, name[], size);
forward ScrapYard_ProcessPlayer(playerid);
forward ScrapYard_FinishTake(playerid);
forward ScrapYard_ClearTaking(playerid);
forward ScrapYard_ShowArtemDialog(playerid);
forward ShowPlayerProgress(playerid, close, current_status, max_value, max_bar_progress, tick, timer, title[]);


stock ScrapYard_Init()
{
    for(new i = 0; i < SCRAP_YARD_CARS; i++)
    {
        g_scrap_yard_vehicle[i] = INVALID_VEHICLE_ID;
        g_scrap_yard_model[i] = 0;
        g_scrap_yard_price[i] = 0;
        g_scrap_yard_owner[i] = -1;
    }
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        g_scrap_yard_player_vehicle[i] = INVALID_VEHICLE_ID;
        g_scrap_yard_player_ownable_vehicle[i] = INVALID_VEHICLE_ID;
        g_scrap_yard_player_ownable_sql[i] = 0;
    }

    g_scrap_yard_actor = CreateActor(25, -1661.648803, -2133.803466, 28.194393, 194.796859);
    if(g_scrap_yard_actor != INVALID_ACTOR_ID)
    {
        SetActorVirtualWorld(g_scrap_yard_actor, 0);
        SetActorInvulnerable(g_scrap_yard_actor, true);
    }

    CreateDynamic3DTextLabel(
        "{FFD429}\xC0\xF0\xF2\xE5\xEC\n{FFFFFF}\xCF\xEE\xE4\xEE\xE9\xE4\xE8\xF2\xE5 \xE4\xEB\xFF \xE2\xE7\xE0\xE8\xEC\xEE\xE4\xE5\xE9\xF1\xF2\xE2\xE8\xFF",
        0xFFFFFFFF,
        -1661.648803, -2133.803466, 29.044393,
        12.0,
        INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0
    );

    ScrapYard_SpawnCars();
    SetTimer("ScrapYard_Respawn", SCRAP_YARD_RESPAWN_TIME, true);
    printf("[ScrapYard] initialized: NPC Artem + broken cars, respawn 25 min");
    return 1;
}

stock ScrapYard_DestroyCars()
{
    for(new i = 0; i < SCRAP_YARD_CARS; i++)
    {
        if(g_scrap_yard_vehicle[i] != INVALID_VEHICLE_ID && IsValidVehicle(g_scrap_yard_vehicle[i]))
            DestroyVehicle(g_scrap_yard_vehicle[i]);

        g_scrap_yard_vehicle[i] = INVALID_VEHICLE_ID;
        g_scrap_yard_model[i] = 0;
        g_scrap_yard_price[i] = 0;
        g_scrap_yard_owner[i] = -1;
    }

    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(g_scrap_yard_player_vehicle[playerid] != INVALID_VEHICLE_ID)
        {
            if(IsPlayerConnected(playerid))
                ShowNotificationSile(playerid, 2, 5, 0, 0, "\xD1\xEB\xEE\xEC\xE0\xED\xED\xFB\xE5 \xEC\xE0\xF8\xE8\xED\xFB \xED\xE0 \xF1\xE2\xE0\xEB\xEA\xE5 \xE1\xFB\xEB\xE8 \xEE\xE1\xED\xEE\xE2\xEB\xE5\xED\xFB", " ");
            g_scrap_yard_player_vehicle[playerid] = INVALID_VEHICLE_ID;
        }
    }
    return 1;
}

stock ScrapYard_SpawnCars()
{
    ScrapYard_DestroyCars();

    new used[SCRAP_YARD_SPAWN_POINTS];
    new spawn_count = 3 + random(2);

    for(new slot = 0; slot < spawn_count && slot < SCRAP_YARD_CARS; slot++)
    {
        new point;
        do point = random(SCRAP_YARD_SPAWN_POINTS); while(used[point]);
        used[point] = 1;

        new type = random(sizeof(g_scrap_yard_models));
        new color = random(126);
        new vehicleid = CreateVehicle(
            g_scrap_yard_models[type],
            g_scrap_yard_spawn_points[point][0],
            g_scrap_yard_spawn_points[point][1],
            g_scrap_yard_spawn_points[point][2],
            g_scrap_yard_spawn_points[point][3],
            color, color, -1, 0
        );
        if(vehicleid == INVALID_VEHICLE_ID) continue;

        g_scrap_yard_vehicle[slot] = vehicleid;
        g_scrap_yard_model[slot] = g_scrap_yard_models[type];
        g_scrap_yard_price[slot] = g_scrap_yard_prices[type];
        g_scrap_yard_owner[slot] = -1;

        SetVehicleHealth(vehicleid, 250.0);
        SetVehicleParamsEx(vehicleid,
            VEHICLE_PARAM_OFF,
            VEHICLE_PARAM_OFF,
            VEHICLE_PARAM_OFF,
            VEHICLE_PARAM_ON,
            VEHICLE_PARAM_ON,
            VEHICLE_PARAM_ON,
            VEHICLE_PARAM_OFF);
    }
    return 1;
}

public ScrapYard_Respawn()
{
    ScrapYard_SpawnCars();
    SendClientMessageToAll(0xFF9900FF, "\xCD\xE0\x20\xF1\xE2\xE0\xEB\xEA\xE5\x20\xEF\xEE\xFF\xE2\xE8\xEB\xE8\xF1\xFC\x20\xE7\xE0\xE1\xF0\xEE\xF8\xE5\xED\xED\xFB\xE5\x20\xEC\xE0\xF8\xE8\xED\xFB\x2C\x20\xF3\xF1\xEF\xE5\xE9\xF2\xE5\x20\xE7\xE0\xE1\xF0\xE0\xF2\xFC\x21");
    return 1;
}

stock ScrapYard_FindSlotByVehicle(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID) return -1;
    for(new i = 0; i < SCRAP_YARD_CARS; i++)
        if(g_scrap_yard_vehicle[i] == vehicleid) return i;
    return -1;
}

stock ScrapYard_FindPlayerVehicleSlot(playerid)
{
    new vehicleid = g_scrap_yard_player_vehicle[playerid];
    if(vehicleid == INVALID_VEHICLE_ID) return -1;
    new slot = ScrapYard_FindSlotByVehicle(vehicleid);
    if(slot == -1 || g_scrap_yard_owner[slot] != playerid) return -1;
    return slot;
}

stock ScrapYard_GetPlayerOwnableFoundVehicle(playerid)
{
    new vehicleid = g_scrap_yard_player_ownable_vehicle[playerid];
    if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid) && IsAOwnableCar(vehicleid))
    {
        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(index >= 0 && GetOwnableCarData(index, OC_OWNER_ID) == GetPlayerAccountID(playerid))
            return vehicleid;
    }

    // The personal vehicle may have been unloaded. Recover it by its SQL id
    // after the player loads it again through the normal personal-TS system.
    if(g_scrap_yard_player_ownable_sql[playerid] > 0)
    {
        vehicleid = GetOwnableCarBySqlID(g_scrap_yard_player_ownable_sql[playerid]);
        if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid) && IsAOwnableCar(vehicleid))
        {
            new index = GetVehicleData(vehicleid, V_ACTION_ID);
            if(index >= 0 && GetOwnableCarData(index, OC_OWNER_ID) == GetPlayerAccountID(playerid))
            {
                g_scrap_yard_player_ownable_vehicle[playerid] = vehicleid;
                return vehicleid;
            }
        }
    }

    return INVALID_VEHICLE_ID;
}

stock ShowPlayerProgress(playerid, close, current_status, max_value, max_bar_progress, tick, timer, title[])
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "g", 1);
    JSON_SetInt(json, "x", close);
    JSON_SetInt(json, "p_start", current_status);
    JSON_SetInt(json, "p_max", max_value);
    JSON_SetInt(json, "p_max_bar", max_bar_progress);
    JSON_SetInt(json, "p_tick", tick);
    JSON_SetInt(json, "p_timer", timer);
    JSON_SetString(json, "p_title", title, strlen(title));
    SendPacketToClient(playerid, 31, json);
    JSON_Cleanup(json);
    return 1;
}

public ScrapYard_ClearTaking(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    DeletePVar(playerid, "scrap_taking");
    return 1;
}

public ScrapYard_FinishTake(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new slot = GetPVarInt(playerid, "scrap_take_slot");
    new vehicleid = GetPVarInt(playerid, "scrap_take_vehicle");
    DeletePVar(playerid, "scrap_taking");
    DeletePVar(playerid, "scrap_take_slot");
    DeletePVar(playerid, "scrap_take_vehicle");

    if(slot < 0 || slot >= SCRAP_YARD_CARS || vehicleid == INVALID_VEHICLE_ID) return 1;
    if(g_scrap_yard_vehicle[slot] != vehicleid || !IsValidVehicle(vehicleid))
    {
        if(slot >= 0 && slot < SCRAP_YARD_CARS && g_scrap_yard_owner[slot] == playerid) g_scrap_yard_owner[slot] = -1;
        g_scrap_yard_player_vehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }
    if(g_scrap_yard_owner[slot] != playerid) return 1;

    new Float:veh_x, Float:veh_y, Float:veh_z;
    GetVehiclePos(vehicleid, veh_x, veh_y, veh_z);
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, veh_x, veh_y, veh_z))
    {
        ShowNotificationSile(playerid, 2, 5, 0, 0, "\xCF\xEE\xE4\xEE\xE9\xE4\xE8\xF2\xE5 \xEA \xEC\xE0\xF8\xE8\xED\xE5", " ");
        return 1;
    }

    // Save the scrapyard model BEFORE conversion clears the slot.
    // Do not take the model from the newly created ownable vehicle: the normal
    // loader can still have old/runtime vehicle data at this exact moment.
    new scrap_modelid = g_scrap_yard_model[slot];

    new converted_vehicle = ScrapYard_ConvertFoundCarToOwnable(playerid, slot);
    if(converted_vehicle == INVALID_VEHICLE_ID) return 1;

    new car_name[64], text[192];
    ScrapYard_GetCarName(scrap_modelid, car_name, sizeof(car_name));
    format(text, sizeof(text), "\xC2\xFB \xE7\xE0\xE1\xF0\xE0\xEB\xE8 \xEC\xE0\xF8\xE8\xED\xF3 \xE2 \xEB\xE8\xF7\xED\xFB\xE5 \xD2\xD1: {FFD429}%s{FFFFFF}\n\xC2\xFB \xEC\xEE\xE6\xE5\xF2\xE5 \xEE\xF1\xF2\xE0\xE2\xE8\xF2\xFC \xE5\xE5 \xF1\xE5\xE1\xE5.", car_name);
    ShowNotificationSile(playerid, 3, 6, 0, 0, text, " ");
    return 1;
}

stock ScrapYard_ConvertFoundCarToOwnable(playerid, slot)
{
    if(slot < 0 || slot >= SCRAP_YARD_CARS) return INVALID_VEHICLE_ID;
    if(g_scrap_yard_vehicle[slot] == INVALID_VEHICLE_ID || !IsValidVehicle(g_scrap_yard_vehicle[slot])) return INVALID_VEHICLE_ID;
    if(g_scrap_yard_owner[slot] != playerid) return INVALID_VEHICLE_ID;

    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
    {
        ShowNotificationSile(playerid, 2, 5, 0, 0, "\xD3\x20\xE2\xE0\xF1\x20\xED\xE5\xF2\x20\xF1\xE2\xEE\xE1\xEE\xE4\xED\xEE\xE3\xEE\x20\xF1\xEB\xEE\xEE\xF2\xE0\x20\xE4\xEB\xFF\x20\xEB\xE8\xF7\xED\xEE\xE3\xEE\x20\xD2\xD1", " ");
        return INVALID_VEHICLE_ID;
    }

    // IMPORTANT: do not build a personal vehicle only in memory here.
    // The normal personal-vehicle loader initializes all fields used by /car,
    // garages, trunks and the personal-vehicle UI. We first save the found car
    // to ownable_cars, then load it through the same code as a normal ownable TS.
    new source_vehicle = g_scrap_yard_vehicle[slot];
    // The slot is the single source of truth for which scrapyard car was claimed.
    // This prevents another model from being used after the progress timer fires.
    new modelid = g_scrap_yard_model[slot];
    if(modelid <= 0) return INVALID_VEHICLE_ID;
    new color_1 = GetVehicleData(source_vehicle, V_COLOR_1);
    new color_2 = GetVehicleData(source_vehicle, V_COLOR_2);
    if(color_1 < 0 || color_1 > 255) color_1 = 0;
    if(color_2 < 0 || color_2 > 255) color_2 = 0;

    new Float:pos_x, Float:pos_y, Float:pos_z, Float:angle;
    GetVehiclePos(source_vehicle, pos_x, pos_y, pos_z);
    GetVehicleZAngle(source_vehicle, angle);

    new query[1024], Cache:result;
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time,body_colors,wheel_colors) VALUES (%d,%d,%d,%d,%f,%f,%f,%f,%d,0,0)",
        GetPlayerAccountID(playerid), modelid, color_1, color_2,
        pos_x, pos_y, pos_z, angle, gettime());

    result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        if(result) cache_delete(result);
        printf("[ScrapYard] ownable_cars INSERT error: %d", mysql_errno());
        ShowNotificationSile(playerid, 2, 5, 0, 0, "\xCE\xF8\xE8\xE1\xEA\xE0 \xF1\xEE\xF5\xF0\xE0\xED\xE5\xED\xE8\xFF \xD2\xD1", " ");
        return INVALID_VEHICLE_ID;
    }

    new sql_id = cache_insert_id();
    cache_delete(result);

    if(sql_id <= 0)
    {
        printf("[ScrapYard] ownable_cars INSERT returned invalid id");
        return INVALID_VEHICLE_ID;
    }

    // Load through the server's real ownable-car system.
    new vehicleid = LoadOwnableCar(sql_id);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        mysql_format(mysql, query, sizeof query, "DELETE FROM ownable_cars WHERE id=%d LIMIT 1", sql_id);
        mysql_query(mysql, query, false);
        ShowNotificationSile(playerid, 2, 5, 0, 0, "\xCD\xE5 \xF3\xE4\xE0\xEB\xEE\xF1\xFC \xE7\xE0\xE3\xF0\xF3\xE7\xE8\xF2\xFC \xD2\xD1", " ");
        return INVALID_VEHICLE_ID;
    }

    // It is now a real ownable vehicle: action type/id, DB id and all normal
    // ownable-car fields were initialized by LoadOwnableCar().
    SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
    g_scrap_yard_player_ownable_vehicle[playerid] = vehicleid;
    g_scrap_yard_player_ownable_sql[playerid] = sql_id;

    DestroyVehicle(source_vehicle);
    g_scrap_yard_vehicle[slot] = INVALID_VEHICLE_ID;
    g_scrap_yard_model[slot] = 0;
    g_scrap_yard_price[slot] = 0;
    g_scrap_yard_owner[slot] = -1;
    g_scrap_yard_player_vehicle[playerid] = INVALID_VEHICLE_ID;

    return vehicleid;
}

stock ScrapYard_GetCarPrice(modelid)
{
    switch(modelid)
    {
        case 2610: return 175000;
        case 404: return 75000;
        case 585: return 95000;
        case 466: return 1900000;
        case 502: return 5000000;
        case 579: return 7000000;
        case 555: return 20000;
        case 458: return 195000;
        case 28730: return 6000000;
    }
    return 0;
}

stock ScrapYard_GetCarName(modelid, name[], size)
{
    switch(modelid)
    {
        case 2610: return format(name, size, "BMW E34");
        case 404: return format(name, size, "\xC2\xE0\xE7 2107");
        case 585: return format(name, size, "\xC2\xE0\xE7 2115");
        case 466: return format(name, size, "BMW F90");
        case 502: return format(name, size, "Nissan GT-R R35");
        case 579: return format(name, size, "Mercedes-Benz G65 AMG");
        case 555: return format(name, size, "ZAZ 968");
        case 458: return format(name, size, "VAZ 2114");
        case 28730: return format(name, size, "VAZ-2105 Street 1996");
    }
    return format(name, size, "\xC0\xE2\xF2\xEE\xEC\xEE\xE1\xE8\xEB\xFC");
}

stock ScrapYard_GetCarClass(modelid, name[], size)
{
    switch(modelid)
    {
        case 404, 585, 555, 458: return format(name, size, "\xCD\xE8\xE7\xEA\xE8\xE9 \xEA\xEB\xE0\xF1\xF1");
        case 2610: return format(name, size, "\xD1\xF0\xE5\xE4\xED\xE8\xE9 \xEA\xEB\xE0\xF1\xF1");
        case 466, 502, 579, 28730: return format(name, size, "\xC2\xFB\xF1\xEE\xEA\xE8\xE9 \xEA\xEB\xE0\xF1\xF1");
    }
    return format(name, size, "\xD1\xF0\xE5\xE4\xED\xE8\xE9 \xEA\xEB\xE0\xF1\xF1");
}


stock ScrapYard_ProcessPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        SetPVarInt(playerid, "scrap_near_vehicle", INVALID_VEHICLE_ID);
        SetPVarInt(playerid, "scrap_npc_near", 0);
        return 1;
    }

    new near_vehicle = INVALID_VEHICLE_ID;
    new near_slot = -1;
    for(new i = 0; i < SCRAP_YARD_CARS; i++)
    {
        if(g_scrap_yard_vehicle[i] == INVALID_VEHICLE_ID || !IsValidVehicle(g_scrap_yard_vehicle[i])) continue;

        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(g_scrap_yard_vehicle[i], vx, vy, vz);
        if(IsPlayerInRangeOfPoint(playerid, 4.0, vx, vy, vz))
        {
            near_vehicle = g_scrap_yard_vehicle[i];
            near_slot = i;
            break;
        }
    }

    new old_near_vehicle = GetPVarInt(playerid, "scrap_near_vehicle");
    if(near_slot != -1)
    {
        if(old_near_vehicle != near_vehicle)
        {
            SetPVarInt(playerid, "scrap_near_vehicle", near_vehicle);
            if(g_scrap_yard_owner[near_slot] == -1)
            {
                new car_name[64], text[192];
                ScrapYard_GetCarName(g_scrap_yard_model[near_slot], car_name, sizeof(car_name));
                format(text, sizeof(text), "{FFFFFF}\xC2\xFB \xED\xE0\xF8\xEB\xE8 \xF1\xEB\xEE\xEC\xE0\xED\xED\xF3\xFE \xEC\xE0\xF8\xE8\xED\xF3: {FFD429}%s", car_name);
                ShowNotificationSile(playerid, 5, 10, SCRAP_YARD_CAR_NOTIFY_ID, near_vehicle, text, "\xC7\xC0\xC1\xD0\xC0\xD2\xDC \xCA\x20\xD1\xC5\xC1\xC5");
            }
        }
    }
    else if(old_near_vehicle != INVALID_VEHICLE_ID)
    {
        SetPVarInt(playerid, "scrap_near_vehicle", INVALID_VEHICLE_ID);
    }

    new npc_near = IsPlayerInRangeOfPoint(playerid, 2.8, -1661.648803, -2133.803466, 28.194393);
    new old_npc_near = GetPVarInt(playerid, "scrap_npc_near");
    if(npc_near && !old_npc_near)
    {
        SetPVarInt(playerid, "scrap_npc_near", 1);
        ShowNotificationSile(playerid, 5, 10, SCRAP_YARD_NPC_NOTIFY_ID, 0,
            "{FFFFFF}\xC0\xF0\xF2\xE5\xEC\n\xC3\xEE\xF2\xEE\xE2 \xEF\xF0\xE8\xED\xE8\xEC\xE0\xF2\xFC \xED\xE0\xE9\xE4\xE5\xED\xED\xF3\xFE \xEC\xE0\xF8\xE8\xED\xF3",
            "\xC2\xC7\xC0\xC8\xCC\xCE\xC4\xC5\xC9\xD1\xD2\xD2\xC2\xC8\xC5");
    }
    else if(!npc_near && old_npc_near)
    {
        SetPVarInt(playerid, "scrap_npc_near", 0);
    }
    return 1;
}

stock ScrapYard_ShowArtemDialog(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.5, -1661.648803, -2133.803466, 28.194393)) return 1;

    ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_1, DIALOG_STYLE_LIST,
        "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xD1\xE2\xE0\xEB\xEA\xE0",
        "{FFFFFF}1. \xCF\xF0\xEE\xE4\xE0\xF2\xFC \xEC\xE0\xF8\xE8\xED\xF3\n2. \xCF\xEE\xEB\xF3\xF7\xE8\xF2\xFC \xEC\xE0\xF8\xE8\xED\xF3 \xE2 \xEB\xE8\xF7\xED\xEE\xE5 \xEF\xEE\xEB\xFC\xE7\xEE\xE2\xE0\xED\xE8\xE5\n3. \xD1\xF2\xE0\xF2\xE8\xF1\xF2\xE8\xEA\xE0",
        "\xC2\xFB\xE1\xF0\xE0\xF2\xFC", "\xC7\xE0\xEA\xF0\xFB\xF2\xFC");
    return 1;
}



stock ScrapYard_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == SCRAP_YARD_DIALOG_1)
    {
        if(!response) return 1;

        switch(listitem)
        {
            case 0: // \xCF\xF0\xEE\xE4\xE0\xF2\xFC \xEC\xE0\xF8\xE8\xED\xF3
            {
                new vehicleid = ScrapYard_GetPlayerOwnableFoundVehicle(playerid);
                if(vehicleid == INVALID_VEHICLE_ID)
                {
                    ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_2, DIALOG_STYLE_MSGBOX,
                        "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xD1\xE2\xE0\xEB\xEA\xE0",
                        "{FFFFFF}\xD3 \xF2\xE5\xE1\xFF \xED\xE5\xF2 \xEC\xE0\xF8\xE8\xED\xFB \xF1\xEE \xF1\xE2\xE0\xEB\xEA\xE8 \xED\xE0 \xF1\xF0\xEE\xE4\xE0\xE6\xF3.\n\xD1\xED\xE0\xF7\xE0\xEB\xE0 \xED\xE0\xE9\xE4\xE8 \xE5\xB8.",
                        "Ok", "");
                    return 1;
                }

                new ownable_index = GetVehicleData(vehicleid, V_ACTION_ID);
                if(ownable_index < 0 || !IsAOwnableCar(vehicleid)) return 1;

                new modelid = GetOwnableCarData(ownable_index, OC_MODEL_ID);
                new car_name[64], car_class[32], offer_text[256];
                ScrapYard_GetCarName(modelid, car_name, sizeof(car_name));
                ScrapYard_GetCarClass(modelid, car_class, sizeof(car_class));

                new price = ScrapYard_GetCarPrice(modelid);
                if(price <= 0) return 1;

                format(offer_text, sizeof(offer_text),
                    "{FFFFFF}\xCC\xEE\xE4\xE5\xEB\xFC: {FFFF00}%s\n{FFFFFF}\xCA\xEB\xE0\xF1\xF1: {FFFF00}%s\n{FFFFFF}\xC0\xF0\xF2\xE5\xEC \xEF\xF0\xE4\xEB\xE0\xE3\xE0\xE5\xF2: {FFFF00}%d \xF0\xF3\xE1\xEB\xE5\xE9\n\n\xCF\xEE\xE4\xF2\xE2\xE5\xF0\xE4\xE8\xF2\xFC \xEF\xF0\xEE\xE4\xE0\xE6\xF3?",
                    car_name, car_class, price);

                ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_2, DIALOG_STYLE_MSGBOX,
                    "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xCF\xF0\xEE\xE4\xE0\xE6\xE0",
                    offer_text,
                    "\xCF\xF0\xEE\xE4\xE0\xF2\xFC", "\xCE\xF2\xEC\xE5\xED\xE0");
                return 1;
            }
            case 1: // \xCF\xEE\xEB\xF3\xF7\xE8\xF2\xFC \xEC\xE0\xF8\xE8\xED\xF3 \xE2 \xEB\xE8\xF7\xED\xEE\xE5 \xEF\xEE\xEB\xFC\xE7\xEE\xE2\xE0\xED\xE8\xE5
            {
                new vehicleid = ScrapYard_GetPlayerOwnableFoundVehicle(playerid);
                if(vehicleid == INVALID_VEHICLE_ID)
                {
                    ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_3, DIALOG_STYLE_MSGBOX,
                        "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xD1\xE2\xE0\xEB\xEA\xE0",
                        "{FFFFFF}\xD3 \xF2\xE5\xE1\xFF \xED\xE5\xF2 \xEC\xE0\xF8\xE8\xED\xFB \xF1\xEE \xF1\xE2\xE0\xEB\xEA\xE8.\n\xD1\xED\xE0\xF7\xE0\xEB\xE0 \xED\xE0\xE9\xE4\xE8 \xE5\xB8.",
                        "Ok", "");
                    return 1;
                }

                new ownable_index = GetVehicleData(vehicleid, V_ACTION_ID);
                if(ownable_index < 0 || !IsAOwnableCar(vehicleid)) return 1;

                new modelid = GetOwnableCarData(ownable_index, OC_MODEL_ID);
                new car_name[64], text[192];
                ScrapYard_GetCarName(modelid, car_name, sizeof(car_name));
                format(text, sizeof(text),
                    "{FFFFFF}\xCC\xE0\xF8\xE8\xED\xE0: {FFD429}%s{FFFFFF}.\n\n\xCE\xED\xE0 \xF3\xE6\xE5 \xEE\xF4\xEE\xF0\xEC\xEB\xE5\xED\xE0 \xE2 \xEB\xE8\xF7\xED\xEE\xE5 \xEF\xEE\xEB\xFC\xE7\xEE\xE2\xE0\xED\xE8\xE5.", car_name);
                ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_3, DIALOG_STYLE_MSGBOX,
                    "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xD1\xE2\xE0\xEB\xEA\xE0",
                    text, "Ok", "");
                return 1;
            }
            case 2: // \xD1\xF2\xE0\xF2\xE8\xF1\xF2\xE8\xEA\xE0
            {
                new available;
                for(new i = 0; i < SCRAP_YARD_CARS; i++)
                    if(g_scrap_yard_vehicle[i] != INVALID_VEHICLE_ID && IsValidVehicle(g_scrap_yard_vehicle[i])) available++;

                new text[256];
                format(text, sizeof(text),
                    "{FFFFFF}\xD1\xE5\xE9\xF7\xE0\xF1 \xED\xE0 \xF1\xE2\xE0\xEB\xEA\xE5 \xE4\xEE\xF1\xF2\xF3\xEF\xED\xEE: {FFD429}%d{FFFFFF} \xEC\xE0\xF8\xE8\xED.\n\n\xCD\xEE\xE2\xFB\xE5 \xEC\xE0\xF8\xE8\xED\xFB \xEF\xEE\xFF\xE2\xEB\xFF\xFE\xF2\xF1\xFF \xEA\xE0\xE6\xE4\xFB\xE5 25 \xEC\xE8\xED\xF3\xF2.", available);
                ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_4, DIALOG_STYLE_MSGBOX,
                    "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xD1\xF2\xE0\xF2\xE8\xF1\xF2\xE8\xEA\xE0",
                    text, "Ok", "");
                return 1;
            }
        }
        return 1;
    }

    if(dialogid == SCRAP_YARD_DIALOG_2)
    {
        if(!response) return 1;

        new vehicleid = ScrapYard_GetPlayerOwnableFoundVehicle(playerid);
        if(vehicleid == INVALID_VEHICLE_ID) return 1;
        if(!IsPlayerInRangeOfPoint(playerid, 4.0, -1661.648803, -2133.803466, 28.194393)) return 1;

        new ownable_index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(ownable_index < 0 || !IsAOwnableCar(vehicleid)) return 1;
        if(GetOwnableCarData(ownable_index, OC_OWNER_ID) != GetPlayerAccountID(playerid)) return 1;

        new price = ScrapYard_GetCarPrice(GetOwnableCarData(ownable_index, OC_MODEL_ID));
        if(price <= 0) return 1;

        if(GetPlayerOwnableCar(playerid) == vehicleid)
            SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

        g_scrap_yard_player_ownable_vehicle[playerid] = INVALID_VEHICLE_ID;
        g_scrap_yard_player_ownable_sql[playerid] = 0;
        DestroyOwnableCar(vehicleid);

        GivePlayerMoneyEx(playerid, price, "\xCF\xF0\xEE\xE4\xE0\xE6\xE0 \xEC\xE0\xF8\xE8\xED\xFB \xF1\xEE \xF1\xE2\xE0\xEB\xEA\xE8", true, true);
        ShowPlayerDialog(playerid, SCRAP_YARD_DIALOG_4, DIALOG_STYLE_MSGBOX,
            "{FFD429}\xC0\xF0\xF2\xE5\xEC | \xD1\xE2\xE0\xEB\xEA\xE0",
            "{FFFFFF}\xC2\xEE\xF2 \xF2\xE2\xEE\xE8 \xE4\xE5\xED\xFC\xE3\xE8. \xD1\xEF\xE0\xF1\xE8\xE1\xEE, \xF3\xE4\xE0\xF7\xE8!",
            "Ok", "");
        return 1;
    }

    if(dialogid == SCRAP_YARD_DIALOG_3 || dialogid == SCRAP_YARD_DIALOG_4)
        return 1;


    return 0;
}

stock ScrapYard_OnNotifyClick(playerid, notify_type, notify_id, notify_sub_id)
{
    // Scrap Yard notification buttons.
    if(notify_id == SCRAP_YARD_CAR_NOTIFY_ID)
    {
        new vehicleid = notify_sub_id;
        new slot = ScrapYard_FindSlotByVehicle(vehicleid);
        if(slot == -1 || !IsValidVehicle(vehicleid)) return 1;

        new Float:veh_x, Float:veh_y, Float:veh_z;
        GetVehiclePos(vehicleid, veh_x, veh_y, veh_z);
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, veh_x, veh_y, veh_z))
        {
            ShowNotificationSile(playerid, 2, 5, 0, 0, "\xCF\xEE\xE4\xEE\xE9\xE4\xE8\xF2\xE5 \xEA \xEC\xE0\xF8\xE8\xED\xE5", " ");
            return 1;
        }

        if(g_scrap_yard_owner[slot] != -1)
        {
            ShowNotificationSile(playerid, 2, 5, 0, 0, "\xDD\xF2\xF3 \xEC\xE0\xF8\xE8\xED\xF3 \xF3\xE6\xE5 \xE7\xE0\xE1\xF0\xE0\xEB\xE8", " ");
            return 1;
        }

        if(ScrapYard_GetPlayerOwnableFoundVehicle(playerid) != INVALID_VEHICLE_ID)
        {
            ShowNotificationSile(playerid, 2, 5, 0, 0, "\xD3 \xE2\xE0\xF1 \xF3\xE6\xE5 \xE5\xF1\xF2\xFC \xED\xE0\xE9\xE4\xE5\xED\xED\xE0\xFF \xEC\xE0\xF8\xE8\xED\xE0. \xD1\xED\xE0\xF7\xE0\xEB\xE0 \xF0\xE5\xF8\xE8\xF2\xE5, \xE5\xE5 \xEF\xF0\xEE\xE4\xE0\xF2\xFC \xE8\xEB\xE8 \xEE\xF1\xF2\xE0\xE2\xFC\xF2\xE5 \xF1\xE5\xE1\xE5.", " ");
            return 1;
        }

        // Start the full 8-second progress. The personal vehicle is created ONLY
        // after the progress finishes, so there is no delayed/second conversion.
        if(GetPVarInt(playerid, "scrap_taking")) return 1;

        g_scrap_yard_owner[slot] = playerid;
        g_scrap_yard_player_vehicle[playerid] = vehicleid;
        SetPVarInt(playerid, "scrap_taking", 1);
        SetPVarInt(playerid, "scrap_take_slot", slot);
        SetPVarInt(playerid, "scrap_take_vehicle", vehicleid);

        ShowPlayerProgress(playerid, 0, 0, 100, 100, 1, 60, "\xC7\xE0\xE1\xE8\xF0\xE0\xE5\xEC \xEC\xE0\xF8\xE8\xED\xF3...");
        SetTimerEx("ScrapYard_FinishTake", 8000, false, "i", playerid);
        return 1;
    }

    if(notify_id == SCRAP_YARD_NPC_NOTIFY_ID)
    {
        ScrapYard_ShowArtemDialog(playerid);
        return 1;
    }


    return 0;
}

stock ScrapYard_OnPlayerEnterVehicle(playerid, vehicleid)
{
    if(ScrapYard_FindSlotByVehicle(vehicleid) != -1)
    {
        ClearAnimations(playerid);
        ShowNotificationSile(playerid, 2, 5, 0, 0, "\xD1\xEB\xEE\xEC\xE0\xED\xED\xE0\xFF \xEC\xE0\xF8\xE8\xED\xE0 \xED\xE5 \xEF\xF0\xE5\xE4\xED\xE0\xE7\xED\xE0\xF7\xE5\xED\xE0 \xE4\xEB\xFF \xE5\xE7\xE4\xFB", " ");
        return 0;
    }


    return 0;
}

stock ScrapYard_OnPlayerDisconnect(playerid)
{
	if(g_scrap_yard_player_vehicle[playerid] != INVALID_VEHICLE_ID)
	{
		new scrap_slot = ScrapYard_FindSlotByVehicle(g_scrap_yard_player_vehicle[playerid]);
		if(scrap_slot != -1 && g_scrap_yard_owner[scrap_slot] == playerid)
			g_scrap_yard_owner[scrap_slot] = -1;
	}
	g_scrap_yard_player_vehicle[playerid] = INVALID_VEHICLE_ID;

    return 1;
}
