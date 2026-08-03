#if !defined TECH_STYLE_WORLD
    #define TECH_STYLE_WORLD      (101)
#endif

#if !defined TECH_STYLE_INTERIOR
    #define TECH_STYLE_INTERIOR   (1)
#endif

#define STYLE_TUNING_CENTER_WORLD   (TECH_STYLE_WORLD)

new Float:g_TuningReturnX[MAX_PLAYERS];
new Float:g_TuningReturnY[MAX_PLAYERS];
new Float:g_TuningReturnZ[MAX_PLAYERS];
new Float:g_TuningReturnA[MAX_PLAYERS];
new g_TuningReturnVW[MAX_PLAYERS];
new g_TuningReturnInt[MAX_PLAYERS];
new g_TuningReturnVehicle[MAX_PLAYERS];

stock HornLegacy_ShowTuningStylingGUI(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "    !");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, ":    ID !");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return SendClientMessage(playerid, -1, "     .");

    new owner_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(owner_id, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, -1, "     .");
        
     new modelid = GetVehicleData(vehicleid, V_MODELID);

    g_TuningType[playerid] = 0;
    new Node:tuning_json = JSON_Object();
    new price;
    
	GetVehicleJsonCostByModelId(modelid, price);
	 
	 JSON_SetInt(tuning_json, "t", 3);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "t", 3);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));

    
    new name[64];
    GetVehicleModelName(modelid, name, sizeof(name));
    JSON_SetString(tuning_json, "n", name);

    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    GetVehiclePos(vehicleid, g_TuningReturnX[playerid], g_TuningReturnY[playerid], g_TuningReturnZ[playerid]);
    GetVehicleZAngle(vehicleid, g_TuningReturnA[playerid]);
    g_TuningReturnVW[playerid] = GetPlayerVirtualWorld(playerid);
    g_TuningReturnInt[playerid] = GetPlayerInterior(playerid);
    g_TuningReturnVehicle[playerid] = vehicleid;
    SetPVarInt(playerid, "StyleTuningCenter", 1);

    // STYLE VOID FIX:
    // Do not move styling preview into donor interior. On mobile/launcher clients
    // the donor interior camera often renders only sky/void. Keep the vehicle in
    // the same world/interior where the player opened the style center and only
    // switch camera to an exterior preview angle.
    SetPlayerVirtualWorld(playerid, g_TuningReturnVW[playerid]);
    SetPlayerInterior(playerid, g_TuningReturnInt[playerid]);
    SetVehicleVirtualWorld(vehicleid, g_TuningReturnVW[playerid]);
    LinkVehicleToInterior(vehicleid, g_TuningReturnInt[playerid]);
    SetVehiclePos(vehicleid, g_TuningReturnX[playerid], g_TuningReturnY[playerid], g_TuningReturnZ[playerid]);
    SetVehicleZAngle(vehicleid, g_TuningReturnA[playerid]);
    PutPlayerInVehicle(playerid, vehicleid, 0);

    StyleTuning_ResetPreviewCamera(playerid);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:tungui1(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "    !");

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


stock StyleTuning_ResetPreviewCamera(playerid)
{
    if(GetPVarInt(playerid, "StyleTuningCenter") != 1) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || vehicleid == INVALID_VEHICLE_ID) vehicleid = g_TuningReturnVehicle[playerid];

    // Keep player/vehicle in the original exterior world/interior. This prevents
    // the style menu from showing sky/void after installing color/vinyl/detail.
    SetPlayerVirtualWorld(playerid, g_TuningReturnVW[playerid]);
    SetPlayerInterior(playerid, g_TuningReturnInt[playerid]);

    new Float:x = g_TuningReturnX[playerid];
    new Float:y = g_TuningReturnY[playerid];
    new Float:z = g_TuningReturnZ[playerid];
    new Float:a = g_TuningReturnA[playerid];

    if(vehicleid && vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, g_TuningReturnVW[playerid]);
        LinkVehicleToInterior(vehicleid, g_TuningReturnInt[playerid]);
        SetVehiclePos(vehicleid, x, y, z);
        SetVehicleZAngle(vehicleid, a);
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }

    SetPlayerCameraPos(playerid, x + 5.5, y + 6.0, z + 2.4);
    SetPlayerCameraLookAt(playerid, x, y, z + 0.8);
    return 1;
}

stock CloseTuningGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || vehicleid == INVALID_VEHICLE_ID) vehicleid = g_TuningReturnVehicle[playerid];

    if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        SyncVehicleTuningForPlayer(playerid, vehicleid);
        SaveVehicleTuning(vehicleid);
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 255);
    JSON_SetInt(json, "s", 1);
    ShowPlayerGUI(playerid, 28, json);
    JSON_Cleanup(json);

    SetPlayerVirtualWorld(playerid, g_TuningReturnVW[playerid]);
    SetPlayerInterior(playerid, g_TuningReturnInt[playerid]);

    if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, g_TuningReturnVW[playerid]);
        LinkVehicleToInterior(vehicleid, g_TuningReturnInt[playerid]);
        SetVehiclePos(vehicleid, g_TuningReturnX[playerid], g_TuningReturnY[playerid], g_TuningReturnZ[playerid]);
        SetVehicleZAngle(vehicleid, g_TuningReturnA[playerid]);
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }
    else
    {
        SetPlayerPos(playerid, g_TuningReturnX[playerid], g_TuningReturnY[playerid], g_TuningReturnZ[playerid]);
        SetPlayerFacingAngle(playerid, g_TuningReturnA[playerid]);
    }

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);
    DeletePVar(playerid, "StyleTuningCenter");
    g_TuningType[playerid] = 0;
    g_TuningReturnVehicle[playerid] = INVALID_VEHICLE_ID;

    printf("Tuning GUI closed for player %d", playerid);
    return 1;
}


#if !defined _HORN_TECHSTYLE_HANDLEPACKET_STUB
#define _HORN_TECHSTYLE_HANDLEPACKET_STUB
stock TechStyle_HandlePacket(playerid, Node:JSONObject)
{
    #pragma unused playerid
    #pragma unused JSONObject
    return 0;
}
#endif

stock HornLegacy_PacketIncomingTuning(playerid, Node:JSONObject)
{
    if(TechStyle_HandlePacket(playerid, JSONObject)) return;
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
    JSON_GetInt(JSONObject, "s", status);           //  
    JSON_GetInt(JSONObject, "m", selector_id);      // ID / (m - selector)
    JSON_GetInt(JSONObject, "d", detail_id);        // ID 
    JSON_GetInt(JSONObject, "p", detail_id);        // ID   
    JSON_GetInt(JSONObject, "mt", operation);       //    
    JSON_GetString(JSONObject, "d", color_hex, sizeof(color_hex)); // HEX 
    
    switch(type) 
    {
        case 0:
        {
            if(GetPVarInt(playerid, "StyleTuningIgnoreClose") > gettime())
            {
                DeletePVar(playerid, "StyleTuningIgnoreClose");
            }
            else
            {
                CloseTuningGUI(playerid);
            }
            JSON_SetInt(tuning_response, "t", 0);
            JSON_SetInt(tuning_response, "s", 1);
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
        }
        case 1:
{
    new vehid = GetPlayerVehicleID(playerid);
    new model_id = GetVehicleData(vehid, V_MODELID);
    new price, query[256];
    new argb_body, argb_wheel;
    
    // ========== :  ==========
    
    // 1. ,   
    if(!IsValidVehicle(vehid))
    {
        JSON_SetInt(tuning_response, "t", 1);
        JSON_SetInt(tuning_response, "s", 0);
        JSON_SetString(tuning_response, "d", ":   .");
        SendPacketToClient(playerid, 28, tuning_response);
        JSON_Cleanup(tuning_response);
        return;
    }
    
    // 2. ,     ( ,  )
    if(!IsAOwnableCar(vehid))
    {
        JSON_SetInt(tuning_response, "t", 1);
        JSON_SetInt(tuning_response, "s", 0);
        JSON_SetString(tuning_response, "d", ":    .");
        SendPacketToClient(playerid, 28, tuning_response);
        JSON_Cleanup(tuning_response);
        return;
    }
    
    // 3.     g_ownable_car   
    new idx = GetVehicleData(vehid, V_ACTION_ID);
    new db_owner_id = GetOwnableCarData(idx, OC_OWNER_ID);
    new player_db_id = GetPlayerAccountID(playerid);
    
    if(db_owner_id == 0 || db_owner_id != player_db_id)
    {
        JSON_SetInt(tuning_response, "t", 1);
        JSON_SetInt(tuning_response, "s", 0);
        JSON_SetString(tuning_response, "d", ":     .");
        SendPacketToClient(playerid, 28, tuning_response);
        JSON_Cleanup(tuning_response);
        return;
    }
    
    // 4.  SQL ID    
    new sql_id = GetOwnableCarData(idx, OC_SQL_ID);
    
    // ==========   ==========
    
    JSON_GetInt(JSONObject, "j", price);
    sscanf(color_hex, "h", color_val);
    
    //  RGBA  ARGB   
    argb_body = RGBA_to_ARGB(color_val);
    argb_wheel = RGBA_to_ARGB(0xFFFFFFFF); //      
    
    if(selector_id == 0) 
    {
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            //     
            SetOwnableCarData(idx, OC_COLOR_1, color_val);
            
            //    
            mysql_format(mysql, query, sizeof(query), 
                "UPDATE `ownable_cars` SET `color_1`=%d WHERE `id`=%d", 
                color_val, sql_id);
            mysql_tquery(mysql, query);
            
            //       
            new body_colors[2], wheel_colors[2];
            body_colors[0] = argb_body;
            body_colors[1] = argb_body;
            wheel_colors[0] = argb_wheel;
            wheel_colors[1] = argb_wheel;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
            SaveVehicleTuning(vehid);
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", ":  .");
            SendPacketToClient(playerid, 28, tuning_response);
        } 
    }
    else if(selector_id == 1)
    {
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            //     
            SetOwnableCarData(idx, OC_COLOR_2, color_val);
            
            //    
            mysql_format(mysql, query, sizeof(query), 
                "UPDATE `ownable_cars` SET `color_2`=%d WHERE `id`=%d", 
                color_val, sql_id);
            mysql_tquery(mysql, query);
            
            //       
            new body_colors[2], wheel_colors[2];
            body_colors[0] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[1] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[0] = RGBA_to_ARGB(body_colors[0]);
            body_colors[1] = RGBA_to_ARGB(body_colors[1]);
            
            wheel_colors[0] = argb_wheel;
            wheel_colors[1] = argb_wheel;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
            SaveVehicleTuning(vehid);
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", ":  .");
            SendPacketToClient(playerid, 28, tuning_response);
        }
    }
    else if(selector_id == 2)
    {
        //  
        if(GetPlayerMoneyEx(playerid) >= price) 
        {
            GivePlayerMoneyEx(playerid, -price);
            
            //    (    )
            // SetOwnableCarData(idx, OC_COLOR_WHEELS, color_val);
            
            new body_colors[2], wheel_colors[2];
            body_colors[0] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[1] = GetOwnableCarData(idx, OC_COLOR_1);
            body_colors[0] = RGBA_to_ARGB(body_colors[0]);
            body_colors[1] = RGBA_to_ARGB(body_colors[1]);
            
            wheel_colors[0] = argb_body;
            wheel_colors[1] = argb_body;
            
            SetVehicleColor(vehid, body_colors, wheel_colors, 1);
            
            SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
            SaveVehicleTuning(vehid);
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", ":  .");
            SendPacketToClient(playerid, 28, tuning_response);
        }
    }
    else if(selector_id == 3)
    {
        //   (, )
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
            
            SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
            SaveVehicleTuning(vehid);
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 1);        
            JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid)); 
        } 
        else
        {
            JSON_SetInt(tuning_response, "t", 1);
            JSON_SetInt(tuning_response, "s", 0);
            JSON_SetString(tuning_response, "d", ":  .");
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
                SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
                SaveVehicleTuning(GetPlayerVehicleID(playerid));
                
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
                JSON_SetInt(tuning_response, "a", 1); // A_KEY_GET_STATUS_DIAGNOSTIC -  
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
                vInfo[GetPlayerVehicleID(playerid)][vVinyl] = vinyl_id;
                SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
                SaveVehicleTuning(GetPlayerVehicleID(playerid));
                
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
            
            StyleTuning_ResetPreviewCamera(playerid);
            
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
                SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 3);
                SaveVehicleTuning(GetPlayerVehicleID(playerid));
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
    if(type != 0 && GetPVarInt(playerid, "StyleTuningCenter") == 1)
    {
        StyleTuning_ResetPreviewCamera(playerid);
    }

    SendPacketToClient(playerid, 28, tuning_response);
    JSON_Cleanup(tuning_response);
}