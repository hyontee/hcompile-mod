//>> Файл: bykranin_src/core/vehicle/tuning_01.inc  (470 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: DebugMotoSalonLog, ExitPlayerBuyCarMarket, CarMarketShowNextCar, GetCarMarketMaxIndex, PermanentTuning_ClearVehicleState, PermanentTuning_GetIdentity, PermanentTuning_RebuildVehicleState
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock DebugMotoSalonLog(playerid, const debug_event[], pickupid = -1, action_type = -1)
{
	new Float:pos_x, Float:pos_y, Float:pos_z;
	new pickup_action_type = -1;
	new pickup_action_id = -1;

	GetPlayerPos(playerid, pos_x, pos_y, pos_z);
	if(IsValidPickupID(pickupid))
	{
		pickup_action_type = GetPickupInfo(pickupid, P_ACTION_TYPE);
		pickup_action_id = GetPickupInfo(pickupid, P_ACTION_ID);
	}

	printf
	(
		"[MOTO_DEBUG] %s | playerid=%d name=%s pickupid=%d action_type=%d pickup_info_type=%d pickup_info_id=%d pos=%.4f %.4f %.4f interior=%d vw=%d biz=%d buy_car=%d last_pickup=%d exit_block=%d tick=%d",
		debug_event,
		playerid,
		GetPlayerNameEx(playerid),
		pickupid,
		action_type,
		pickup_action_type,
		pickup_action_id,
		pos_x,
		pos_y,
		pos_z,
		GetPlayerInterior(playerid),
		GetPlayerVirtualWorld(playerid),
		GetPlayerInBiz(playerid),
		GetPlayerData(playerid, P_BUY_CAR),
		GetPlayerData(playerid, P_LAST_PICKUP),
		GetPVarInt(playerid, "moto_salon_exit_block"),
		GetTickCount()
	);
	return 1;
}

stock ExitPlayerBuyCarMarket(playerid)
{
	if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return -1;

	StopAutosalonTestDriveMonitor(playerid);
    DeletePVar(playerid, "autosalon_testdrive_active");
    DeletePVar(playerid, "autosalon_testdrive_price");

	DestroyVehicle(GetPlayerData(playerid, P_BUY_CAR));
	SetPlayerData(playerid, P_BUY_CAR, INVALID_VEHICLE_ID);

	new in_biz = GetPlayerInBiz(playerid);
	if (in_biz == -1) return 1;
	new car_market_id = GetCarMarketIdByBizId(in_biz);
	new biz_interior = 0;

	if(IsMotoSalonBiz(in_biz))
	{
		biz_interior = 1;
	}

	TogglePlayerControllable(playerid, true);
	SetPlayerCleanChat(playerid, 0);
	DebugMotoSalonLog(playerid, "ExitPlayerBuyCarMarket:before");

	SetPlayerPosEx
	(
		playerid,
		GetBusinessData(in_biz, B_EXIT_POS_X),
		GetBusinessData(in_biz, B_EXIT_POS_Y),
		GetBusinessData(in_biz, B_EXIT_POS_Z),
		GetBusinessData(in_biz, B_EXIT_ANGLE),
		biz_interior,
		0
	);
	if(car_market_id == -1 || !IsMotoSalonBiz(in_biz))
	{
		SetPlayerInBiz(playerid, -1);
	}

	DebugMotoSalonLog(playerid, "ExitPlayerBuyCarMarket:after");
	
	HideAutosalonTextDraws(playerid);
	ShowHud(playerid);
	return 1;
}

stock CarMarketShowNextCar(playerid, next = '+')
{
	new biz_id = GetPlayerInBiz(playerid);
	if(biz_id == -1) return 1;
	new car_market_id = GetCarMarketIdByBizId(biz_id);
	if(car_market_id == -1) return 1;

	if(GetBusinessData(biz_id, B_TYPE) != BUSINESS_TYPE_CAR_MARKET) return 1;

	new max_car_index = GetCarMarketMaxIndex(car_market_id);

	if(next == '+')
	{
		if(++buy_car_select_car[playerid] > max_car_index)
			buy_car_select_car[playerid] = 0;
	}
					else
	{
		if(--buy_car_select_car[playerid] < 0)
			buy_car_select_car[playerid] = max_car_index;
	}

    new select_car = buy_car_select_car[playerid];
    SyncAutosalonSelectedColors(playerid);

    new old_vehicleid = GetPlayerData(playerid, P_BUY_CAR);
    if(old_vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(old_vehicleid))
    {
        ResetVehicleStreamCache(old_vehicleid);
        DestroyVehicle(old_vehicleid);
    }
    SetPlayerData(playerid, P_BUY_CAR, INVALID_VEHICLE_ID);

    new vehicleid = CreateVehicle(car_market_data[car_market_id][select_car][CM_MODELID], 1149.8434, 226.0655, 995.1953, 67.6542, 1, 1, 1);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    ResetVehicleStreamCache(vehicleid);
    SetPlayerData(playerid, P_BUY_CAR, vehicleid);
    ApplyCarMarketPreviewScene(playerid, vehicleid, car_market_id);
    ApplyAutosalonPreviewColor(playerid);

    CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
	return 1;
}
stock GetCarMarketMaxIndex(market_id)
{
    new max_index = -1;

    for(new idx; idx < sizeof(car_market_data[]); idx++)
    {
        if(car_market_data[market_id][idx][CM_MODELID] != 0)
            max_index = idx;
    }
    return max_index;
}


stock PermanentTuning_ClearVehicleState(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    g_perm_tuning_ready[vehicleid] = false;
    g_perm_tuning_action[vehicleid] = VEHICLE_ACTION_TYPE_NONE;
    g_perm_tuning_identity[vehicleid] = 0;
    g_perm_tuning_count[vehicleid] = 0;
    g_perm_tuning_epoch[vehicleid]++;
    for(new i; i < PERM_TUNING_MAX_COMPONENTS; i++)
        g_perm_tuning_components[vehicleid][i] = 0;
    return 1;
}

stock PermanentTuning_GetIdentity(vehicleid, &action_type, &action_id)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;
    action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
    action_id = GetVehicleData(vehicleid, V_ACTION_ID);

    if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
    {
        if(action_id < 0 || action_id >= MAX_OWNABLE_CARS) return 0;
        return GetOwnableCarData(action_id, OC_SQL_ID);
    }
    if(action_type == VEHICLE_ACTION_TYPE_FAMILY_CAR)
    {
        if(action_id < 0 || action_id >= MAX_OWNABLE_CARS) return 0;
        return GetCarFamily(action_id, CAR_F_database);
    }
    return 0;
}

stock PermanentTuning_RebuildVehicleState(vehicleid)
{
    new action_type, action_id;
    new identity = PermanentTuning_GetIdentity(vehicleid, action_type, action_id);
    if(identity <= 0)
    {
        PermanentTuning_ClearVehicleState(vehicleid);
        return 0;
    }

    if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        SyncOwnableVehicleTuningData(vehicleid);

    new table_name[40];
    if(action_type == VEHICLE_ACTION_TYPE_FAMILY_CAR && g_FT55_New[action_id])
        format(table_name, sizeof table_name, "family_vehicle_components");
    else
        format(table_name, sizeof table_name, "vehicle_store_components");

    new query[160];
    mysql_format(mysql, query, sizeof query,
        "SELECT componentid FROM %s WHERE vehicleid=%d AND state=2", table_name, identity);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[PERM_TUNING][SQL_ERROR] vehicle=%d identity=%d errno=%d", vehicleid, identity, mysql_errno());
        cache_delete(result);
        return 0;
    }

    new count, rows = cache_num_rows(result);
    new modelid = GetVehicleData(vehicleid, V_MODELID);
    for(new row; row < rows && count < PERM_TUNING_MAX_COMPONENTS; row++)
    {
        new itemid = cache_get_field_content_int(row, "componentid");
        if(!IsStoredTuneItemAllowedForModel(modelid, itemid)) continue;
        new componentid = GetTuneIdFromItem(itemid);
        if(componentid <= 0) continue;

        new bool:duplicate;
        for(new x; x < count; x++)
        {
            if(g_perm_tuning_components[vehicleid][x] == componentid)
            {
                duplicate = true;
                break;
            }
        }
        if(duplicate) continue;
        g_perm_tuning_components[vehicleid][count++] = componentid;
    }
    cache_delete(result);

    // wheel_comp is stored in ownable/family fields rather than the component table.
    // Put it in the same runtime layer so the self-heal path restores the visible
    // wheel model too, not only body-kit rows.
    new wheel_component;
    if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        wheel_component = GetWheelTuneComponentId(GetOwnableCarData(action_id, OC_wheelcomp));
    else if(action_type == VEHICLE_ACTION_TYPE_FAMILY_CAR && g_FT55_New[action_id])
        wheel_component = GetWheelTuneComponentId(g_FT55[action_id][FT55_DISK]);
    if(wheel_component > 0 && count < PERM_TUNING_MAX_COMPONENTS)
    {
        new bool:wheel_duplicate;
        for(new x; x < count; x++)
        {
            if(g_perm_tuning_components[vehicleid][x] == wheel_component)
            {
                wheel_duplicate = true;
                break;
            }
        }
        if(!wheel_duplicate) g_perm_tuning_components[vehicleid][count++] = wheel_component;
    }

    for(new x = count; x < PERM_TUNING_MAX_COMPONENTS; x++)
        g_perm_tuning_components[vehicleid][x] = 0;

    g_perm_tuning_action[vehicleid] = action_type;
    g_perm_tuning_identity[vehicleid] = identity;
    g_perm_tuning_count[vehicleid] = count;
    g_perm_tuning_ready[vehicleid] = true;
    g_perm_tuning_epoch[vehicleid]++;

    printf("[PERM_TUNING][BUILD] vehicle=%d type=%d identity=%d components=%d epoch=%d",
        vehicleid, action_type, identity, count, g_perm_tuning_epoch[vehicleid]);
    return 1;
}

stock PermanentTuning_EnsureVehicleState(vehicleid)
{
    new action_type, action_id;
    new identity = PermanentTuning_GetIdentity(vehicleid, action_type, action_id);
    if(identity <= 0) return 0;

    if(!g_perm_tuning_ready[vehicleid] ||
       g_perm_tuning_action[vehicleid] != action_type ||
       g_perm_tuning_identity[vehicleid] != identity)
    {
        return PermanentTuning_RebuildVehicleState(vehicleid);
    }
    return 1;
}

stock PermanentTuning_ApplyComponentsForPlayer(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(!PermanentTuning_EnsureVehicleState(vehicleid)) return 0;

    for(new i; i < g_perm_tuning_count[vehicleid]; i++)
    {
        new componentid = g_perm_tuning_components[vehicleid][i];
        if(componentid > 0)
            AddToVehicleComponentForPlayer(playerid, vehicleid, componentid);
    }
    return 1;
}

stock PermanentTuning_ApplyVehicleForPlayer(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;

    new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
    if(action_type != VEHICLE_ACTION_TYPE_OWNABLE_CAR && action_type != VEHICLE_ACTION_TYPE_FAMILY_CAR)
        return 0;

    PermanentTuning_EnsureVehicleState(vehicleid);

    // Do not send REMOVE ALL during stream recovery. The client destroys/recreates
    // the vehicle entity itself; a late REMOVE ALL can win the race and leave stock.
    g_tuning_additive_replay[playerid] = true;
    ApplyVehicleTuning(playerid, vehicleid);
    g_tuning_additive_replay[playerid] = false;
    ApplyVehicleFirmware(playerid, vehicleid);
    Styling_QueueSuspension(vehicleid);
    FT55_Queue(vehicleid);
    return 1;
}

stock ResetVehicleStreamCache(vehicleid)
{
    if(!IsValidVehicleID(vehicleid)) return 1;

    foreach(new stream_playerid : streamed_players_in_veh[vehicleid])
    {
        Iter_Remove(vehicle_in_stream[stream_playerid], vehicleid);
    }
    Iter_Clear(streamed_players_in_veh[vehicleid]);
    return 1;
}

stock ResetPlayerVehicleStreamCache(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;

    foreach(new stream_vehicleid : vehicle_in_stream[playerid])
    {
        if(IsValidVehicleID(stream_vehicleid))
            Iter_Remove(streamed_players_in_veh[stream_vehicleid], playerid);
    }
    Iter_Clear(vehicle_in_stream[playerid]);
    return 1;
}

stock QueuePlayerVehicleVisualRefresh(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    new epoch = ++g_vehicle_stream_refresh_epoch[playerid];
    SetTimerEx("Player_ReapplyStreamedVehicleVisuals", 250, false, "dd", playerid, epoch);
    SetTimerEx("Player_ReapplyStreamedVehicleVisuals", 900, false, "dd", playerid, epoch);
    SetTimerEx("Player_ReapplyStreamedVehicleVisuals", 2200, false, "dd", playerid, epoch);
    SetTimerEx("Player_ReapplyStreamedVehicleVisuals", 4500, false, "dd", playerid, epoch);
    return 1;
}

forward Player_ReapplyStreamedVehicleVisuals(playerid, epoch);
public Player_ReapplyStreamedVehicleVisuals(playerid, epoch)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(epoch != g_vehicle_stream_refresh_epoch[playerid]) return 0;

    foreach(new vehicleid : Vehicle)
    {
        new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
        if(action_type != VEHICLE_ACTION_TYPE_OWNABLE_CAR && action_type != VEHICLE_ACTION_TYPE_FAMILY_CAR)
            continue;

        if(!IsVehicleStreamedIn(vehicleid, playerid) && GetPlayerVehicleID(playerid) != vehicleid)
            continue;

        if(!Iter_Contains(streamed_players_in_veh[vehicleid], playerid))
            Iter_Add(streamed_players_in_veh[vehicleid], playerid);
        if(!Iter_Contains(vehicle_in_stream[playerid], vehicleid))
            Iter_Add(vehicle_in_stream[playerid], vehicleid);

        UpdateVehicleVisualForPlayer(playerid, vehicleid);
        PermanentTuning_ApplyVehicleForPlayer(playerid, vehicleid);
    }
    return 1;
}


// V16 tuning stream replay v2:
// The CRMP mobile client may finish creating/resetting the streamed vehicle a little
// after OnVehicleStreamIn. A full ApplyVehicleTuning contains REMOVE ALL, so delayed
// retries must be additive: once the client entity is stable we only put the saved
// components back, never clear them again.
stock ReplaySavedVehicleComponentsForPlayer(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;

    new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
    new index = GetVehicleData(vehicleid, V_ACTION_ID);

    if(action_type == VEHICLE_ACTION_TYPE_FAMILY_CAR)
    {
        if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;
        FamilyCarApplyVehicleStoreComponents(vehicleid, GetCarFamily(index, CAR_F_database), playerid);

        new family_vinyl[32];
        ResolveFamilyCarVinylName(index, family_vinyl, sizeof family_vinyl, true);
        if(family_vinyl[0] != EOS) SetVehicleVinylForPlayer(playerid, vehicleid, family_vinyl);

        new nitro_component = GetNitroComponentByLevel(GetCarFamily(index, V_F_NITRO));
        if(nitro_component > 0) AddToVehicleComponentForPlayer(playerid, vehicleid, nitro_component);
        FT55_Apply(playerid, vehicleid);
        return 1;
    }

    if(action_type != VEHICLE_ACTION_TYPE_OWNABLE_CAR) return 0;
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    // Re-sync the runtime visual cache from the authoritative loaded ownable-car row.
    SyncOwnableVehicleTuningData(vehicleid);
    Styling_ApplyWheels(playerid, vehicleid);

    PermanentTuning_ApplyComponentsForPlayer(playerid, vehicleid);
    ApplyOwnableVehicleNitro(playerid, vehicleid, vInfo[index][vNitro]);
    return 1;
}

stock QueueVehicleStreamTuningReplay(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;

    new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
    if(action_type != VEHICLE_ACTION_TYPE_OWNABLE_CAR && action_type != VEHICLE_ACTION_TYPE_FAMILY_CAR) return 0;

    new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
    new identity;
    if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
    {
        if(action_id < 0 || action_id >= MAX_OWNABLE_CARS) return 0;
        identity = GetOwnableCarData(action_id, OC_SQL_ID);
    }
    else
    {
        if(action_id < 0 || action_id >= MAX_OWNABLE_CARS) return 0;
        identity = GetCarFamily(action_id, CAR_F_database);
    }

    // One early and one late retry cover entity creation on normal and slow mobile
    // clients. Further periodic RPC replays congest the reliable ordered channel
    // and can delay vehicle-enter/state traffic.
    SetTimerEx("Vehicle_StreamTuningReplay", 250, false, "ddddd", playerid, vehicleid, action_type, action_id, identity);
    SetTimerEx("Vehicle_StreamTuningReplay", 1100, false, "ddddd", playerid, vehicleid, action_type, action_id, identity);
    return 1;
}

forward Vehicle_StreamTuningReplay(playerid, vehicleid, action_type, action_id, identity);
public Vehicle_StreamTuningReplay(playerid, vehicleid, action_type, action_id, identity)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != action_type || GetVehicleData(vehicleid, V_ACTION_ID) != action_id) return 0;
    if(!IsVehicleStreamedIn(vehicleid, playerid) && GetPlayerVehicleID(playerid) != vehicleid) return 0;

    if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
    {
        if(action_id < 0 || action_id >= MAX_OWNABLE_CARS || GetOwnableCarData(action_id, OC_SQL_ID) != identity) return 0;
    }
    else if(action_type == VEHICLE_ACTION_TYPE_FAMILY_CAR)
    {
        if(action_id < 0 || action_id >= MAX_OWNABLE_CARS || GetCarFamily(action_id, CAR_F_database) != identity) return 0;
    }
    else return 0;

    UpdateVehicleVisualForPlayer(playerid, vehicleid);
    PermanentTuning_ApplyVehicleForPlayer(playerid, vehicleid);
    return 1;
}

