#if defined _GORDEEV_TURNLIGHT_INC_INCLUDED
    #endinput
#endif
#define _GORDEEV_TURNLIGHT_INC_INCLUDED

#if !defined _samp_included
    #error "Include turnlight.inc after a_samp include."
#endif

new TurnSignalState[MAX_VEHICLES];
new bool:TurnSignalBlinkOn[MAX_VEHICLES];
new TurnSignalDriver[MAX_VEHICLES];
new TurnSignalModel[MAX_VEHICLES];

stock IsTurnSignalVehicleValid(vehicleid)
{
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
    if(!GetVehicleModel(vehicleid)) return 0;
    return 1;
}

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
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        SendVehicleTurnLight(i, vehicleid, status);
    }
    return 1;
}

CMD:turnpacket(playerid, params[])
{
    new status;
    if(sscanf(params, "i", status))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "{1E90FF}[Подсказка]:{FFFFFF} /turnpacket [статус 0-3]");
    }

    if(status < 0 || status > 3)
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Статус: 0=выкл, 1=левый, 2=правый, 3=аварийка");
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid <= 0 || !IsTurnSignalVehicleValid(vehicleid))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");
    }

    if(status == 0)
    {
        StopVehicleTurnSignal(vehicleid);
        SendClientMessage(playerid, 0x66CC00FF, "Поворотники выключены");
        return 1;
    }

    if(TurnSignalState[vehicleid] == status && TurnSignalDriver[vehicleid] == playerid)
    {
        StopVehicleTurnSignal(vehicleid);
        SendClientMessage(playerid, 0x66CC00FF, "Поворотники выключены");
        return 1;
    }

    StopVehicleTurnSignal(vehicleid);
    StartVehicleTurnSignal(playerid, vehicleid, status);

    new fmt_str[96];
    format(fmt_str, sizeof fmt_str, "Поворотники включены: veh %d, статус %d", vehicleid, status);
    SendClientMessage(playerid, 0x66CC00FF, fmt_str);
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

    if(IsTurnSignalVehicleValid(vehicleid))
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

forward UpdateVehicleTurnSignals();
public UpdateVehicleTurnSignals()
{
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(TurnSignalState[vehicleid] < 1 || TurnSignalState[vehicleid] > 3) continue;

        if(!IsTurnSignalVehicleValid(vehicleid))
        {
            ResetVehicleTurnSignalData(vehicleid);
            continue;
        }

        new driverid = TurnSignalDriver[vehicleid];

        if(driverid == INVALID_PLAYER_ID)
        {
            if(IsTurnSignalVehicleValid(vehicleid))
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
            }
            continue;
        }

        if(!IsPlayerConnected(driverid))
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

        if(GetPlayerState(driverid) != PLAYER_STATE_DRIVER)
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

        if(GetPlayerVehicleID(driverid) != vehicleid)
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

stock TurnSignal_Init()
{
    print("---------------------------------");
    print("   Turnlights by Dima_Joket");
    print("---------------------------------");
    SetTimer("UpdateVehicleTurnSignals", 500, true);

    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        TurnSignalDriver[i] = INVALID_PLAYER_ID;
        TurnSignalModel[i] = 0;
        TurnSignalState[i] = 0;
        TurnSignalBlinkOn[i] = false;
    }
    return 1;
}

stock TurnSignal_OnVehicleSpawn(vehicleid)
{
    StopVehicleTurnSignal(vehicleid);
    return 1;
}

stock TurnSignal_OnVehicleDeath(vehicleid)
{
    StopVehicleTurnSignal(vehicleid);
    return 1;
}

stock TurnSignal_OnPlayerDisconnect(playerid)
{
    StopPlayerVehicleTurnSignal(playerid);
    return 1;
}

stock TurnSignal_OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid >= 1 && vehicleid < MAX_VEHICLES && TurnSignalDriver[vehicleid] == playerid)
        {
            TurnSignalDriver[vehicleid] = INVALID_PLAYER_ID;
        }
    }
    return 1;
}


