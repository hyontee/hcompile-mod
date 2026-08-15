#if defined _BR_DEATH_VEHICLE_API_INC_
    #endinput
#endif
#define _BR_DEATH_VEHICLE_API_INC_

// Требует: enum E_VEHICLE_PARAMS_STRUCT, new g_vehicle_params[] в death.pwn

new g_LcAutoOffTimer[MAX_PLAYERS];

stock SetVehicleParamsInit(vehicleid)
{
    g_vehicle_params[vehicleid][V_ENGINE]    = true;
    g_vehicle_params[vehicleid][V_LIGHTS]    = false;
    g_vehicle_params[vehicleid][V_ALARM]     = false;
    g_vehicle_params[vehicleid][V_LOCK]      = false;
    g_vehicle_params[vehicleid][V_BONNET]    = false;
    g_vehicle_params[vehicleid][V_BOOT]      = false;
    g_vehicle_params[vehicleid][V_OBJECTIVE] = false;

    SetVehicleParamsEx(vehicleid, 1, 0, 0, 0, 0, 0, 0);
    return 1;
}

stock GetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid)
{
    return _:g_vehicle_params[vehicleid][paramid];
}

stock SetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid, set_value)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    g_vehicle_params[vehicleid][paramid] = bool:set_value;

    switch(paramid)
    {
        case V_ENGINE:    engine = set_value;
        case V_LIGHTS:    lights = set_value;
        case V_ALARM:     alarm = set_value;
        case V_LOCK:      doors = set_value;
        case V_BONNET:    bonnet = set_value;
        case V_BOOT:      boot = set_value;
        case V_OBJECTIVE: objective = set_value;
    }

    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}

stock LaunchControl_CancelAutoOff(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(g_LcAutoOffTimer[playerid])
    {
        KillTimer(g_LcAutoOffTimer[playerid]);
        g_LcAutoOffTimer[playerid] = 0;
    }
    return 1;
}

stock SetVehLaunchCtrlForPlr(playerid, vehicleid, lc_type)
{
    if(!IsPlayerConnected(playerid) || vehicleid == INVALID_VEHICLE_ID || lc_type < 0) return 0;
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 23, PR_UINT8, lc_type);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock BroadcastVehicleLaunchControl(vehicleid, lc_type)
{
    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
    {
        if(IsPlayerConnected(p)) SetVehLaunchCtrlForPlr(p, vehicleid, lc_type);
    }
    return 1;
}

stock LaunchControl_ForceOff(playerid, vehicleid, owner, slot)
{
    LaunchControl_CancelAutoOff(playerid);
    if(owner < 0 || owner >= MAX_PLAYERS || slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;

    VehicleInfo[owner][slot][vLaunchControlOn] = false;
    if(VehicleInfo[owner][slot][vLaunchControl] > 0)
        BroadcastVehicleLaunchControl(vehicleid, 0);
    return 1;
}

#define LAUNCH_CONTROL_AUTO_OFF_MS (4500)

forward bool:GetVehicleOwnerSlot(vehicleid, &owner, &slot);
forward LaunchControl_AutoOffTimer(playerid);

stock SetVehicleSuspension(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 1);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
    return 1;
}

stock UpdateVehicleNeon(playerid, vehicleid, main, left, right)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x09, PR_UINT32, main, PR_UINT32, left, PR_UINT32, right);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleStroboscopeForPlayer(playerid, vehicleid, type)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid, PR_UINT8, 19, PR_UINT32, type);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
    return 1;
}

stock SetVehicleDlaniy(playerid, vehicleid, value)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 22, PR_UINT8, value);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleHydraulicsForPlayer(playerid, vehicleid, type)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 21, PR_UINT8, type);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock BroadcastVehicleNeon(vehicleid, ownerid, slot)
{
    if(ownerid < 0 || slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;
    new neon_main = VehicleInfo[ownerid][slot][vNeonMain];
    new neon_left = VehicleInfo[ownerid][slot][vNeon1];
    new neon_right = VehicleInfo[ownerid][slot][vNeon2];
    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        if(VehicleInfo[ownerid][slot][vNeonState])
            UpdateVehicleNeon(p, vehicleid, neon_main, neon_left, neon_right);
        else
            UpdateVehicleNeon(p, vehicleid, 0, 0, 0);
    }
    return 1;
}

stock BroadcastVehicleDlaniy(vehicleid, value)
{
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;
    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
    {
        if(IsPlayerConnected(p)) SetVehicleDlaniy(p, vehicleid, value);
    }
    return 1;
}

stock BroadcastVehicleStroboscope(vehicleid, ownerid, slot)
{
    if(ownerid < 0 || slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;
    new type_to_send = (VehicleInfo[ownerid][slot][vStrobState]) ? VehicleInfo[ownerid][slot][vStrob] : 5;
    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
    {
        if(IsPlayerConnected(p)) SetVehicleStroboscopeForPlayer(p, vehicleid, type_to_send);
    }
    return 1;
}

stock BroadcastVehicleHydraulics(vehicleid, ownerid, slot)
{
    if(ownerid < 0 || slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;
    if(VehicleInfo[ownerid][slot][vHydra] <= 0) return 0;
    new hydra_on = VehicleInfo[ownerid][slot][vHydraState] ? 1 : 0;
    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
    {
        if(IsPlayerConnected(p)) SetVehicleHydraulicsForPlayer(p, vehicleid, hydra_on);
    }
    return 1;
}

stock LaunchControl_OnRadialUse(playerid, vehicleid, owner, slot, bool:lc_on)
{
    if(owner < 0 || slot < 0 || vehicleid == INVALID_VEHICLE_ID) return 0;
    LaunchControl_CancelAutoOff(playerid);
    if(lc_on)
    {
        BroadcastVehicleLaunchControl(vehicleid, 1);
        g_LcAutoOffTimer[playerid] = SetTimerEx("LaunchControl_AutoOffTimer", LAUNCH_CONTROL_AUTO_OFF_MS, false, "i", playerid);
    }
    else
        LaunchControl_ForceOff(playerid, vehicleid, owner, slot);
    return 1;
}
