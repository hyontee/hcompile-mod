//>> Файл: bykranin_src/core/vehicle/ownable_04.inc  (264 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: OnRconLoginAttempt, MultiplyVehicleMoveSpeed, MultiplyVehicleMoveSpeeds, TechCenter_GetFirmwareSpeedMultiplier, TechCenter_GetFirmwareAccelerationPercent, TechCenter_GetEngineSpeedBonus, TechCenter_ApplyPerformance
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

stock MultiplyVehicleMoveSpeed(vehicleid, Float:multiplier)
{
    new Float:vx, vy, vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);

    new Float:rotation;
    GetVehicleZAngle(vehicleid, rotation); // градусы

    new Float:add = 0.002;

    // sin() и cos() в Pawn
    new Int:angle = floatround(rotation); // градусы в int
    new Int:sinval = floatsin(angle); // -32768..32767
    new Int:cosval = floatcos(angle);

    new Float:sx = sinval / 32768.0; // -1.0..1.0
    new Float:sy = cosval / 32768.0;

    if (sx < 0.0) vx += add;
    else          vx -= add;

    if (sy < 0.0) vy += add;
    else          vy -= add;

    SetVehicleVelocity(vehicleid, vx, vy, vz);
}
stock MultiplyVehicleMoveSpeeds(vehicleid, Float:multiplier)
{
    new Float:vx, vy, vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);

    new Float:rotation;
    GetVehicleZAngle(vehicleid, rotation); // градусы

    new Float:add = 0.002;

    // sin() и cos() в Pawn
    new Int:angle = floatround(rotation); // градусы в int
    new Int:sinval = floatsin(angle); // -32768..32767
    new Int:cosval = floatcos(angle);

    new Float:sx = sinval / 32768.0; // -1.0..1.0
    new Float:sy = cosval / 32768.0;

    if (sx < 0.0) vx += add;
    else          vx -= add;

    if (sy < 0.0) vy += add;
    else          vy -= add;

    SetVehicleVelocity(vehicleid, 1000, 1000, vz);
}

#define FSTATE_NONE        0
#define FSTATE_DRIFT       1
#define FSTATE_COMFORT     2
#define FSTATE_SPORT       3
#define FSTATE_SPORT_PLUS  4

// V7: real performance state for the technical center.
// Previously firmware/PT levels were saved, but max speed was often never applied.
#define TC_FW_SPEED_COMFORT    (1.04)
#define TC_FW_SPEED_DRIFT      (1.08)
#define TC_FW_SPEED_SPORT      (1.14)
#define TC_FW_SPEED_SPORT_PLUS (1.22)

stock Float:TechCenter_GetFirmwareSpeedMultiplier(firmware_state)
{
    switch(firmware_state)
    {
        case FSTATE_DRIFT:      return TC_FW_SPEED_DRIFT;
        case FSTATE_COMFORT:    return TC_FW_SPEED_COMFORT;
        case FSTATE_SPORT:      return TC_FW_SPEED_SPORT;
        case FSTATE_SPORT_PLUS: return TC_FW_SPEED_SPORT_PLUS;
    }
    return 1.0;
}

stock Float:TechCenter_GetFirmwareAccelerationPercent(firmware_state)
{
    switch(firmware_state)
    {
        case FSTATE_COMFORT:    return 6.0;
        case FSTATE_DRIFT:      return 10.0;
        case FSTATE_SPORT:      return 18.0;
        case FSTATE_SPORT_PLUS: return 28.0;
    }
    return 0.0;
}

stock Float:TechCenter_GetEngineSpeedBonus(index)
{
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0.0;

    new level = GetOwnableCarData(index, OC_PT_ENGINE);
    if(level < 0) level = 0;
    if(level > 5) level = 5;

    new Float:bonus = 0.0;
    for(new n = 0; n < level; n++)
        bonus += engine_ptune_boost[n];

    // Compatibility with cars that already contain these legacy DB upgrades.
    new turbo_level = GetOwnableCarData(index, OC_PT_TURBO);
    if(turbo_level < 0) turbo_level = 0;
    if(turbo_level > 5) turbo_level = 5;
    bonus += float(turbo_level) * 0.08;

    new super_level = GetOwnableCarData(index, OC_SUPERCHARGER);
    if(super_level < 0) super_level = 0;
    if(super_level > 5) super_level = 5;
    bonus += float(super_level) * 0.09;
    return bonus;
}

stock TechCenter_ApplyPerformance(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    new modelid = GetVehicleModel(vehicleid);
    if(modelid < 400 || modelid >= 612) modelid = GetVehicleData(vehicleid, V_MODELID);
    if(modelid < 400 || modelid >= 612) modelid = GetOwnableCarData(index, OC_MODEL_ID);
    if(modelid < 400 || modelid >= 612) return 0;

    new Float:base_speed = float(GetVehicleInfo(modelid - 400, VI_MAXSP));
    if(base_speed <= 0.0) return 0;

    new firmware_state = GetOwnableCarData(index, OC_FSTATE);
    if(firmware_state < FSTATE_NONE || firmware_state > FSTATE_SPORT_PLUS)
        firmware_state = vInfo[index][vFstate];

    new Float:engine_bonus = TechCenter_GetEngineSpeedBonus(index);
    new Float:max_speed = base_speed * (1.0 + engine_bonus) * TechCenter_GetFirmwareSpeedMultiplier(firmware_state);

    vInfo[index][vMaxSpeed] = max_speed;
    vInfo[vehicleid][vMaxSpeed] = max_speed;
    vInfo[vehicleid][vFstate] = firmware_state;

    // customtune.inc stores handling on vehicleid and restores it for every stream-in.
    SetVehicleMaxSpeed(vehicleid, max_speed);
    new Float:client_acceleration = 1.0 + (TechCenter_GetFirmwareAccelerationPercent(firmware_state) / 100.0);
    foreach(new streamed_player: Player)
    {
        if(!IsVehicleStreamedIn(vehicleid, streamed_player) && GetPlayerVehicleID(streamed_player) != vehicleid) continue;
        SetVehicleMaxSpeedForPlayer(streamed_player, vehicleid, max_speed);
        SetVehicleAccelerationForPlayer(streamed_player, vehicleid, client_acceleration);
        SetVehicleDriftForPlayer(streamed_player, vehicleid, firmware_state == FSTATE_DRIFT);
    }
    printf("[TECHCENTER V7] vehicle=%d model=%d base=%.1f engine_bonus=%.2f firmware=%d max=%.1f",
        vehicleid, modelid, base_speed, engine_bonus, firmware_state, max_speed);
    return 1;
}

// Reconcile real SA-MP stream state with our iterator cache. Some mobile clients
// miss the stream callbacks around interiors/world switches; this makes the fix
// independent from those callbacks and from the teleport implementation.
stock TuningStream_ReconcilePlayer(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    foreach(new vehicleid : Vehicle)
    {
        new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
        if(action_type != VEHICLE_ACTION_TYPE_OWNABLE_CAR && action_type != VEHICLE_ACTION_TYPE_FAMILY_CAR)
            continue;

        new bool:actually_streamed = IsVehicleStreamedIn(vehicleid, playerid) || GetPlayerVehicleID(playerid) == vehicleid;
        new bool:cached_streamed = Iter_Contains(vehicle_in_stream[playerid], vehicleid);

        if(!actually_streamed)
        {
            if(cached_streamed)
            {
                Iter_Remove(vehicle_in_stream[playerid], vehicleid);
                Iter_Remove(streamed_players_in_veh[vehicleid], playerid);
            }
            continue;
        }

        if(cached_streamed) continue;

        // Callback was missed: rebuild the player-local vehicle state exactly as
        // a real OnVehicleStreamIn would, but never clear already restored parts.
        Iter_Add(vehicle_in_stream[playerid], vehicleid);
        if(!Iter_Contains(streamed_players_in_veh[vehicleid], playerid))
            Iter_Add(streamed_players_in_veh[vehicleid], playerid);

        UpdateVehicleVisualForPlayer(playerid, vehicleid);
        PermanentTuning_ApplyVehicleForPlayer(playerid, vehicleid);
        QueueVehicleStreamTuningReplay(playerid, vehicleid);
    }

    return 1;
}

// Detect every stream-context change, including markers/interiors that call
// SetPlayerInterior/SetPlayerVirtualWorld/SetPlayerPos directly and therefore
// bypass SetPlayerPosEx. This is deliberately independent from /tp.
stock TuningStreamWatch_OnPlayerUpdate(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new now = GetTickCount();
    if(now - g_tuning_stream_watch_tick[playerid] < 350) return 0;
    g_tuning_stream_watch_tick[playerid] = now;

    if(now - g_tuning_stream_reconcile_tick[playerid] >= 1500)
    {
        g_tuning_stream_reconcile_tick[playerid] = now;
        TuningStream_ReconcilePlayer(playerid);
    }

    new interior = GetPlayerInterior(playerid);
    new world = GetPlayerVirtualWorld(playerid);
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if(!g_tuning_stream_watch_init[playerid])
    {
        g_tuning_stream_watch_init[playerid] = true;
        g_tuning_stream_watch_interior[playerid] = interior;
        g_tuning_stream_watch_world[playerid] = world;
        g_tuning_stream_watch_x[playerid] = x;
        g_tuning_stream_watch_y[playerid] = y;
        g_tuning_stream_watch_z[playerid] = z;
        return 1;
    }

    new bool:context_changed =
        (interior != g_tuning_stream_watch_interior[playerid]) ||
        (world != g_tuning_stream_watch_world[playerid]);

    new Float:dx = x - g_tuning_stream_watch_x[playerid];
    new Float:dy = y - g_tuning_stream_watch_y[playerid];
    new Float:dz = z - g_tuning_stream_watch_z[playerid];
    // 60m between 350ms samples is a teleport/marker jump, not normal movement.
    new bool:position_jump = (dx*dx + dy*dy + dz*dz) >= 3600.0;

    g_tuning_stream_watch_interior[playerid] = interior;
    g_tuning_stream_watch_world[playerid] = world;
    g_tuning_stream_watch_x[playerid] = x;
    g_tuning_stream_watch_y[playerid] = y;
    g_tuning_stream_watch_z[playerid] = z;

    if(context_changed || position_jump)
    {
        // On mobile OnVehicleStreamOut/In may be missing around an interior or
        // marker transition. Force our cache to match the new client context and
        // run several additive passes while the vehicle entity is recreated.
        ResetPlayerVehicleStreamCache(playerid);
        QueuePlayerVehicleVisualRefresh(playerid);
    }
    return 1;
}

