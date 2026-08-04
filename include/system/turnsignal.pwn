// ===================================================================
// Система поворотников | by Dima_Joket
// Интегрировано в основной gamemode (было отдельным filterscript'ом)
// ===================================================================

new TurnSignalState[MAX_VEHICLES];
new bool:TurnSignalBlinkOn[MAX_VEHICLES];
new TurnSignalDriver[MAX_VEHICLES];
new TurnSignalModel[MAX_VEHICLES];

// -------------------------------------------------------------------
// ВАЖНО: IsValidVehicle УЖЕ объявлена как native в include/system/vehicle.pwn
// (используется по всему gamemode). Свою копию не создаём — иначе будет
// конфликт имён (native vs stock с одинаковым именем = ошибка компиляции).
// Ниже используется существующая native IsValidVehicle() напрямую.
// -------------------------------------------------------------------

stock SendVehicleTurnLight(playerid, vehicleid, status)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 253);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, status);
    PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SendVehicleTurnLightForAll(vehicleid, status)
{
    foreach(new i : Player)
    {
        SendVehicleTurnLight(i, vehicleid, status);
    }
    return 1;
}

stock ResetVehicleTurnSignalData(vehicleid)
{
    TurnSignalState[vehicleid] = 0;
    TurnSignalBlinkOn[vehicleid] = false;
    TurnSignalDriver[vehicleid] = INVALID_PLAYER_ID;
    TurnSignalModel[vehicleid] = 0;
    return 1;
}

stock StopVehicleTurnSignal(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;

    if(IsValidVehicle(vehicleid))
    {
        SendVehicleTurnLightForAll(vehicleid, 0);
    }

    ResetVehicleTurnSignalData(vehicleid);
    return 1;
}

stock StartVehicleTurnSignal(playerid, vehicleid, status)
{
    TurnSignalState[vehicleid] = status;
    TurnSignalBlinkOn[vehicleid] = true;
    TurnSignalDriver[vehicleid] = playerid;
    TurnSignalModel[vehicleid] = GetVehicleModel(vehicleid);
    SendVehicleTurnLightForAll(vehicleid, status);
    return 1;
}

stock StopPlayerVehicleTurnSignal(playerid)
{
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(TurnSignalDriver[vehicleid] != playerid) continue;
        StopVehicleTurnSignal(vehicleid);
    }
    return 1;
}

// Вызывается напрямую из основного OnIncomingRPC (rpcid 97, action 3) —
// смотри правку в конце gamemodes/workk.pwn. Действие 3 в этом rpcid
// раньше нигде не использовалось (занято только действие 4 — радиал-меню),
// конфликта нет.
stock TS_HandleIncomingRPC(playerid, BitStream:bs)
{
    new vehicleid;
    new turnStatus;

    if(!BS_ReadUint16(bs, vehicleid)) return 1;
    if(!BS_ReadUint8(bs, turnStatus)) return 1;

    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;
    if(!IsValidVehicle(vehicleid)) return 1;
    if(GetPlayerVehicleID(playerid) != vehicleid) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    if(turnStatus < 1 || turnStatus > 3) return 1;

    if(TurnSignalState[vehicleid] == turnStatus && TurnSignalDriver[vehicleid] == playerid)
    {
        StopVehicleTurnSignal(vehicleid);
    }
    else
    {
        StopVehicleTurnSignal(vehicleid);
        StartVehicleTurnSignal(playerid, vehicleid, turnStatus);
    }
    return 1;
}

forward UpdateVehicleTurnSignals();
public UpdateVehicleTurnSignals()
{
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(TurnSignalState[vehicleid] < 1 || TurnSignalState[vehicleid] > 3) continue;

        if(!IsValidVehicle(vehicleid))
        {
            ResetVehicleTurnSignalData(vehicleid);
            continue;
        }

        new driverid = TurnSignalDriver[vehicleid];

        if(driverid == INVALID_PLAYER_ID)
        {
            if(TurnSignalBlinkOn[vehicleid])
            {
                TurnSignalBlinkOn[vehicleid] = false;
                SendVehicleTurnLightForAll(vehicleid, 0);
            }
            else
            {
                TurnSignalBlinkOn[vehicleid] = true;
                SendVehicleTurnLightForAll(vehicleid, TurnSignalState[vehicleid]);
            }
            continue;
        }

        if(!IsPlayerConnected(driverid) || GetPlayerState(driverid) != PLAYER_STATE_DRIVER || GetPlayerVehicleID(driverid) != vehicleid)
        {
            TurnSignalDriver[vehicleid] = INVALID_PLAYER_ID;

            if(TurnSignalBlinkOn[vehicleid])
            {
                TurnSignalBlinkOn[vehicleid] = false;
                SendVehicleTurnLightForAll(vehicleid, 0);
            }
            else
            {
                TurnSignalBlinkOn[vehicleid] = true;
                SendVehicleTurnLightForAll(vehicleid, TurnSignalState[vehicleid]);
            }
            continue;
        }

        if(GetVehicleModel(vehicleid) != TurnSignalModel[vehicleid])
        {
            ResetVehicleTurnSignalData(vehicleid);
            continue;
        }

        if(TurnSignalBlinkOn[vehicleid])
        {
            TurnSignalBlinkOn[vehicleid] = false;
            SendVehicleTurnLightForAll(vehicleid, 0);
        }
        else
        {
            TurnSignalBlinkOn[vehicleid] = true;
            SendVehicleTurnLightForAll(vehicleid, TurnSignalState[vehicleid]);
        }
    }
    return 1;
}

public OnGameModeInit()
{
    print("---------------------------------");
    print("   Поворотники by Dima_Joket");
    print("---------------------------------");

    SetTimer("UpdateVehicleTurnSignals", 500, true);

    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        TurnSignalDriver[i] = INVALID_PLAYER_ID;
        TurnSignalModel[i] = 0;
    }
    #if defined ts_OnGameModeInit
        return ts_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit ts_OnGameModeInit
#if defined ts_OnGameModeInit
    forward ts_OnGameModeInit();
#endif

public OnVehicleSpawn(vehicleid)
{
    StopVehicleTurnSignal(vehicleid);
    #if defined ts_OnVehicleSpawn
        return ts_OnVehicleSpawn(vehicleid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define _ALS_OnVehicleSpawn
#endif
#define OnVehicleSpawn ts_OnVehicleSpawn
#if defined ts_OnVehicleSpawn
    forward ts_OnVehicleSpawn(vehicleid);
#endif

public OnVehicleDeath(vehicleid, killerid)
{
    StopVehicleTurnSignal(vehicleid);
    #if defined ts_OnVehicleDeath
        return ts_OnVehicleDeath(vehicleid, killerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleDeath
    #undef OnVehicleDeath
#else
    #define _ALS_OnVehicleDeath
#endif
#define OnVehicleDeath ts_OnVehicleDeath
#if defined ts_OnVehicleDeath
    forward ts_OnVehicleDeath(vehicleid, killerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    StopPlayerVehicleTurnSignal(playerid);
    #if defined ts_OnPlayerDisconnect
        return ts_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect ts_OnPlayerDisconnect
#if defined ts_OnPlayerDisconnect
    forward ts_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid >= 1 && vehicleid < MAX_VEHICLES && TurnSignalDriver[vehicleid] == playerid)
        {
            TurnSignalDriver[vehicleid] = INVALID_PLAYER_ID;
        }
    }
    #if defined ts_OnPlayerStateChange
        return ts_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange ts_OnPlayerStateChange
#if defined ts_OnPlayerStateChange
    forward ts_OnPlayerStateChange(playerid, newstate, oldstate);
#endif
