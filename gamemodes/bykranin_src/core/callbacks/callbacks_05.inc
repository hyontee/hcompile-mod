//>> Файл: bykranin_src/core/callbacks/callbacks_05.inc  (46 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerStreamIn, OnPlayerStreamOut, OnVehicleStreamIn, OnVehicleStreamOut
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR) return 1;

    // Never trust a stale stream cache after teleport/world changes.
    // Mobile clients can stream the same vehicle back while the old iterator entry
    // is still present, so visual tuning must be rebuilt on every real StreamIn.
    UpdateVehicleVisualForPlayer(forplayerid, vehicleid);
    if(GetPlayerData(forplayerid, P_BUY_CAR) == vehicleid)
    {
        ApplyAutosalonPreviewColor(forplayerid);
    }

    if(!Iter_Contains(streamed_players_in_veh[vehicleid], forplayerid))
        Iter_Add(streamed_players_in_veh[vehicleid], forplayerid);
    if(!Iter_Contains(vehicle_in_stream[forplayerid], vehicleid))
        Iter_Add(vehicle_in_stream[forplayerid], vehicleid);

    PermanentTuning_ApplyVehicleForPlayer(forplayerid, vehicleid);
    // One-shot horn config. Never put this in delayed tuning replay: some mobile
    // clients treat repeated RPC 167/type 15 as repeated horn activation.

    // The mobile client can reset custom CRMP components after this callback.
    // Additive delayed retries guarantee the saved tuning is the final state.
    QueueVehicleStreamTuningReplay(forplayerid, vehicleid);
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    Iter_Remove(streamed_players_in_veh[vehicleid], forplayerid);
    Iter_Remove(vehicle_in_stream[forplayerid], vehicleid);
    return 1;
}

