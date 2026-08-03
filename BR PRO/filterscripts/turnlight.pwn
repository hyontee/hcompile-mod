#include <a_samp>
#include <float>

new g_TurnLightState[MAX_VEHICLES];
new Timer:g_TurnLightTimer[MAX_VEHICLES];
new bool:g_TurnLightActive[MAX_VEHICLES];
new bool:vTurnLeft[MAX_VEHICLES];
new bool:vTurnRight[MAX_VEHICLES];
new bool:vBlinkState[MAX_VEHICLES];
new bool:HazardLightState[MAX_VEHICLES];

#define TURN_INTERVAL 500
#define TURN_CLR 0xAAAAAAFF
#define RPC_TURNLIGHT 168
#define PR_UINT16 1
#define PR_UINT8 2
#define PR_BOOL 3
#define INVALID_PLAYER_ID 65535
#define PR_LOW_PRIORITY 0
#define PR_RELIABLE_ORDERED 3

#define PR_SendRPC(%0,%1,%2,%3,%4) \
    do { \
        if(IsPlayerConnected(%1)) { \
            new rpcmsg[128]; \
            new vehicleid = GetPlayerVehicleID(%1); \
            format(rpcmsg, sizeof(rpcmsg), "[RPC] Поворотники: L=%d R=%d B=%d", \
                vTurnLeft[vehicleid], vTurnRight[vehicleid], vBlinkState[vehicleid]); \
            SendClientMessage(%1, TURN_CLR, rpcmsg); \
        } \
    } while(0)

stock Iter_OPDCInternal(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
    {
        if(g_TurnLightState[vehicleid] > 0)
        {
            g_TurnLightActive[vehicleid] = !g_TurnLightActive[vehicleid];
            return 1;
        }
    }
    return 0;
}

stock Iter_OnFilterScriptInit()
{
    new count = 0;
    for(new i; i < MAX_VEHICLES; i++)
    {
        if(g_TurnLightState[i] > 0) count++;
    }
    return count;
}

stock Iter_OnGameModeInit()
{
    new count = 0;
    for(new i; i < MAX_VEHICLES; i++)
    {
        if(g_TurnLightState[i] > 0) count++;
    }
    return count;
}

stock PR_Init()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new vehicleid = GetPlayerVehicleID(i);
            if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
            {
                new BitStream:bs = BS_New();
                if(bs != BitStream:0)
                {
                    BS_WriteValue(bs, PR_UINT16, vehicleid);
                    BS_WriteValue(bs, PR_UINT8, vTurnLeft[vehicleid] ? 1 : 0);
                    BS_WriteValue(bs, PR_UINT8, vTurnRight[vehicleid] ? 1 : 0);
                    BS_WriteValue(bs, PR_UINT8, vBlinkState[vehicleid] ? 1 : 0);
                    
                    PR_SendRPC(bs, i, RPC_TURNLIGHT, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    
                    BS_Delete(bs);
                }
            }
        }
    }
    
    printf("PR_Init: Инициализирована RPC система для %d игроков", GetPlayerPoolSize());
    return 1;
}

stock BS_ReadValue(BitStream:bs, &value)
{
    value = 0;
    return 0;
}

stock BS_WriteUint8(BitStream:bs, value) { return 0; }
stock BS_WriteUint16(BitStream:bs, value) { return 0; }
stock BS_ReadUint8(BitStream:bs, &value) { value = 0; return 0; }
stock BS_ReadUint16(BitStream:bs, &value) { value = 0; return 0; }
stock BS_New() { return 0; }
stock BS_Delete(BitStream:bs) { return 0; }

stock BS_WriteValue(BitStream:bs, type, value, playerid = INVALID_PLAYER_ID) 
{ 
    switch(type)
    {
        case PR_UINT16: BS_WriteUint16(bs, value);
        case PR_UINT8: BS_WriteUint8(bs, value);
        case PR_BOOL: BS_WriteUint8(bs, value ? 1 : 0);
    }
    return 0; 
}

stock IsValidVehicle(vehicleid)
{
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
    return GetVehicleModel(vehicleid) ? 1 : 0;
}

public OnFilterScriptInit()
{
    Iter_OnFilterScriptInit();
    PR_Init();
    
    for(new i; i < MAX_VEHICLES; i++)
    {
        g_TurnLightState[i] = 0;
        g_TurnLightTimer[i] = Timer:0;
        g_TurnLightActive[i] = false;
        vTurnLeft[i] = false;
        vTurnRight[i] = false;
        vBlinkState[i] = false;
        HazardLightState[i] = false;
    }
    
    print("Поворотники?");
    return 1;
}

public OnFilterScriptExit()
{
    for(new i; i < MAX_VEHICLES; i++)
    {
        if(g_TurnLightTimer[i] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[i]);
            g_TurnLightTimer[i] = Timer:0;
        }
    }
    
    return 1;
}

public OnGameModeInit()
{
    Iter_OnGameModeInit();
    PR_Init();
    
    for(new i; i < MAX_VEHICLES; i++)
    {
        g_TurnLightState[i] = 0;
        g_TurnLightTimer[i] = Timer:0;
        g_TurnLightActive[i] = false;
        vTurnLeft[i] = false;
        vTurnRight[i] = false;
        vBlinkState[i] = false;
        HazardLightState[i] = false;
    }
    
    print("Поворотники тест #1 Пон?");
    return 1;
}

forward OnCheckAuthTL();
public OnCheckAuthTL()
{
    return 1;
}

public OnPlayerConnect(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
    {
        g_TurnLightState[vehicleid] = 0;
        g_TurnLightActive[vehicleid] = false;
        vTurnLeft[vehicleid] = false;
        vTurnRight[vehicleid] = false;
        vBlinkState[vehicleid] = false;
        HazardLightState[vehicleid] = false;
        
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    }
    
    OnCheckAuthTL();
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
    {
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        
        g_TurnLightState[vehicleid] = 0;
        g_TurnLightActive[vehicleid] = false;
        vTurnLeft[vehicleid] = false;
        vTurnRight[vehicleid] = false;
        vBlinkState[vehicleid] = false;
        HazardLightState[vehicleid] = false;
        
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    }
    
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    HazardLightState[vehicleid] = true;
    SetTimerEx("VehicleUpdateTurnLight", 500, true, "d", vehicleid);
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    vTurnLeft[vehicleid] = false;
    vTurnRight[vehicleid] = false;
    vBlinkState[vehicleid] = false;
    HazardLightState[vehicleid] = false;
    
    if(g_TurnLightTimer[vehicleid] != Timer:0)
    {
        KillTimer(g_TurnLightTimer[vehicleid]);
        g_TurnLightTimer[vehicleid] = Timer:0;
    }
    
    SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
        {
            if(newkeys & KEY_LEFT)
            {
                vTurnLeft[vehicleid] = !vTurnLeft[vehicleid];
                if(vTurnLeft[vehicleid])
                {
                    vTurnRight[vehicleid] = false;
                    vBlinkState[vehicleid] = false;
                }
                povorotnik(playerid, vehicleid, vTurnLeft[vehicleid], vTurnRight[vehicleid], vBlinkState[vehicleid]);
            }
            
            if(newkeys & KEY_RIGHT)
            {
                vTurnRight[vehicleid] = !vTurnRight[vehicleid];
                if(vTurnRight[vehicleid])
                {
                    vTurnLeft[vehicleid] = false;
                    vBlinkState[vehicleid] = false;
                }
                povorotnik(playerid, vehicleid, vTurnLeft[vehicleid], vTurnRight[vehicleid], vBlinkState[vehicleid]);
            }
            
            if(newkeys & KEY_UP)
            {
                vBlinkState[vehicleid] = !vBlinkState[vehicleid];
                if(vBlinkState[vehicleid])
                {
                    vTurnLeft[vehicleid] = false;
                    vTurnRight[vehicleid] = false;
                }
                povorotnik(playerid, vehicleid, vTurnLeft[vehicleid], vTurnRight[vehicleid], vBlinkState[vehicleid]);
            }
        }
    }
    
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
        {
            new BitStream:bs = BS_New();
            if(bs != BitStream:0)
            {
                BS_WriteValue(bs, PR_UINT16, vehicleid);
                BS_WriteValue(bs, PR_UINT8, vTurnLeft[vehicleid] ? 1 : 0);
                BS_WriteValue(bs, PR_UINT8, vTurnRight[vehicleid] ? 1 : 0);
                BS_WriteValue(bs, PR_UINT8, vBlinkState[vehicleid] ? 1 : 0);
                
                PR_SendRPC(bs, playerid, RPC_TURNLIGHT, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                
                BS_Delete(bs);
            }
        }
    }
    
    if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
        {
            vTurnLeft[vehicleid] = false;
            vTurnRight[vehicleid] = false;
            vBlinkState[vehicleid] = false;
            
            if(g_TurnLightTimer[vehicleid] != Timer:0)
            {
                KillTimer(g_TurnLightTimer[vehicleid]);
                g_TurnLightTimer[vehicleid] = Timer:0;
            }
            
            SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
        }
    }
    
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    g_TurnLightState[vehicleid] = 0;
    g_TurnLightActive[vehicleid] = false;
    vTurnLeft[vehicleid] = false;
    vTurnRight[vehicleid] = false;
    vBlinkState[vehicleid] = false;
    HazardLightState[vehicleid] = false;
    
    if(g_TurnLightTimer[vehicleid] != Timer:0)
    {
        KillTimer(g_TurnLightTimer[vehicleid]);
        g_TurnLightTimer[vehicleid] = Timer:0;
    }
    
    SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    
    return 1;
}

forward VehicleUpdateTurnLight(vehicleid);
public VehicleUpdateTurnLight(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) 
    {
        KillTimer(g_TurnLightTimer[vehicleid]);
        g_TurnLightTimer[vehicleid] = Timer:0;
        return 0;
    }
    
    g_TurnLightActive[vehicleid] = !g_TurnLightActive[vehicleid];
    
    if(g_TurnLightActive[vehicleid]) 
        SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
    else 
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    
    return 1;
}

forward Timer_ToggleBlink(vehicleid);
public Timer_ToggleBlink(vehicleid)
{
    if(!GetVehicleModel(vehicleid)) 
    {
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        return 0;
    }
    
    g_TurnLightActive[vehicleid] = !g_TurnLightActive[vehicleid];
    
    switch(g_TurnLightState[vehicleid])
    {
        case 1:
        {
            SetVehicleParamsEx(vehicleid, 
                g_TurnLightActive[vehicleid] ? 1 : 0,
                0, 0, 0, 0, 0, 0
            );
        }
        case 2:
        {
            SetVehicleParamsEx(vehicleid, 
                0,
                g_TurnLightActive[vehicleid] ? 1 : 0,
                0, 0, 0, 0, 0
            );
        }
        case 3:
        {
            SetVehicleParamsEx(vehicleid, 
                g_TurnLightActive[vehicleid] ? 1 : 0,
                g_TurnLightActive[vehicleid] ? 1 : 0,
                0, 0, 0, 0, 0
            );
        }
        default:
        {
            SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
        }
    }
    
    return 1;
}

forward OnIncomingRPC(playerid, rpcid, BitStream:bs);
public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
    if(rpcid == 168)
    {
        new action;
        if(!BS_ReadUint8(bs,action))
        {
            return 1;
        }
        
        switch(action)
        {
            case 3:
            {
                if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                    return 1;

                new veh = GetPlayerVehicleID(playerid);
                if(veh <= 0 || veh >= MAX_VEHICLES)
                    return 1;

                new turnType;
                if(!BS_ReadUint8(bs, turnType))
                {
                    return 1;
                }
                
                switch(turnType)
                {
                    case 0:
                    {
                        vTurnLeft[veh] = false;
                        vTurnRight[veh] = false;
                        vBlinkState[veh] = false;
                    }
                    case 1:
                    {
                        vTurnLeft[veh] = !vTurnLeft[veh];
                        if(vTurnLeft[veh])
                        {
                            vTurnRight[veh] = false;
                            vBlinkState[veh] = false;
                        }
                    }
                    case 2:
                    {
                        vTurnRight[veh] = !vTurnRight[veh];
                        if(vTurnRight[veh])
                        {
                            vTurnLeft[veh] = false;
                            vBlinkState[veh] = false;
                        }
                    }
                    case 3:
                    {
                        vBlinkState[veh] = !vBlinkState[veh];
                        if(vBlinkState[veh])
                        {
                            vTurnLeft[veh] = false;
                            vTurnRight[veh] = false;
                        }
                    }
                }
                
                povorotnik(
                    playerid,
                    veh,
                    vTurnLeft[veh],
                    vTurnRight[veh],
                    vBlinkState[veh]
                );

                return 1;
            }
        }
    }
    
    return 1;
}

stock povorotnik(playerid, vehicleid, left, right, blink)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES)
        return 0;

    if(blink)
    {
        g_TurnLightState[vehicleid] = 3;
        
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        
        g_TurnLightTimer[vehicleid] = SetTimerEx("Timer_ToggleBlink", TURN_INTERVAL, true, "d", vehicleid);
    }
    else if(left)
    {
        g_TurnLightState[vehicleid] = 1;
        
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        
        g_TurnLightTimer[vehicleid] = SetTimerEx("Timer_ToggleBlink", TURN_INTERVAL, true, "d", vehicleid);
    }
    else if(right)
    {
        g_TurnLightState[vehicleid] = 2;
        
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        
        g_TurnLightTimer[vehicleid] = SetTimerEx("Timer_ToggleBlink", TURN_INTERVAL, true, "d", vehicleid);
    }
    else
    {
        g_TurnLightState[vehicleid] = 0;
        
        if(g_TurnLightTimer[vehicleid] != Timer:0)
        {
            KillTimer(g_TurnLightTimer[vehicleid]);
            g_TurnLightTimer[vehicleid] = Timer:0;
        }
        
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    }

    new BitStream:bs = BS_New();
    if(bs == BitStream:0)
        return 0;

    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, left ? 1 : 0);
    BS_WriteValue(bs, PR_UINT8, right ? 1 : 0);
    BS_WriteValue(bs, PR_UINT8, blink ? 1 : 0);

    PR_SendRPC(bs, playerid, RPC_TURNLIGHT, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bs);
    return 1;
}

public OnPlayerUpdate(playerid)
{
    return 1;
}