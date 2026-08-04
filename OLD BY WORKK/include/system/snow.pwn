/*
  Автор системы Workk
*/
#if defined _snow_arc_included
    #endinput
#endif
#define _snow_arc_included

#include <a_samp>

#define SNOW_ARC_OBJECT 18863
#define MAX_SNOW_FLAKES_PER_PLAYER 150
#define SNOW_UPDATE_INTERVAL 40

enum PlayerSnowData {
    Float:snow_x[MAX_SNOW_FLAKES_PER_PLAYER],
    Float:snow_y[MAX_SNOW_FLAKES_PER_PLAYER],
    Float:snow_z[MAX_SNOW_FLAKES_PER_PLAYER],
    Float:snow_speed[MAX_SNOW_FLAKES_PER_PLAYER],
    Float:snow_size[MAX_SNOW_FLAKES_PER_PLAYER],
    Float:snow_rotation[MAX_SNOW_FLAKES_PER_PLAYER],
    Float:snow_rotate_speed[MAX_SNOW_FLAKES_PER_PLAYER],
    snow_object_id[MAX_SNOW_FLAKES_PER_PLAYER],
    snow_timer,
    bool:snow_initialized
}

new PlayerSnow[MAX_PLAYERS][PlayerSnowData];
new Float:GlobalWindX = 0.3;
new Float:GlobalWindY = -0.2;

stock Float:RandomFloat(Float:min, Float:max)
{
    return min + (random(1000000) * (max - min)) / 1000000.0;
}

InitPlayerSnow(playerid)
{
    if(PlayerSnow[playerid][snow_initialized]) return 0;
    
    new Float:player_x, Float:player_y, Float:player_z;
    GetPlayerPos(playerid, player_x, player_y, player_z);
    
    for(new i = 0; i < MAX_SNOW_FLAKES_PER_PLAYER; i++)
    {
        PlayerSnow[playerid][snow_x][i] = player_x + RandomFloat(-40.0, 40.0);
        PlayerSnow[playerid][snow_y][i] = player_y + RandomFloat(-40.0, 40.0);
        PlayerSnow[playerid][snow_z][i] = player_z + RandomFloat(20.0, 50.0);
        PlayerSnow[playerid][snow_speed][i] = RandomFloat(0.25, 0.65);
        PlayerSnow[playerid][snow_size][i] = RandomFloat(0.12, 0.28);
        PlayerSnow[playerid][snow_rotation][i] = RandomFloat(0.0, 360.0);
        PlayerSnow[playerid][snow_rotate_speed][i] = RandomFloat(-1.8, 1.8);
        PlayerSnow[playerid][snow_object_id][i] = INVALID_OBJECT_ID;
        
        CreatePlayerSnowFlake(playerid, i);
    }
    
    PlayerSnow[playerid][snow_timer] = SetTimerEx("UpdatePlayerSnow", SNOW_UPDATE_INTERVAL, true, "i", playerid);
    PlayerSnow[playerid][snow_initialized] = true;
    
    return 1;
}

CreatePlayerSnowFlake(playerid, flakeid)
{
    if(PlayerSnow[playerid][snow_object_id][flakeid] != INVALID_OBJECT_ID)
    {
        if(IsValidPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][flakeid]))
        {
            DestroyPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][flakeid]);
        }
    }
    
    new Float:size = PlayerSnow[playerid][snow_size][flakeid];
    new Float:rx = RandomFloat(0.0, 360.0);
    new Float:ry = RandomFloat(0.0, 360.0);
    new Float:rz = PlayerSnow[playerid][snow_rotation][flakeid];
    
    PlayerSnow[playerid][snow_object_id][flakeid] = CreatePlayerObject(playerid, SNOW_ARC_OBJECT, 
        PlayerSnow[playerid][snow_x][flakeid], 
        PlayerSnow[playerid][snow_y][flakeid], 
        PlayerSnow[playerid][snow_z][flakeid], 
        rx, ry, rz, size);
    
    return 1;
}

ResetPlayerSnowFlake(playerid, flakeid)
{
    new Float:player_x, Float:player_y, Float:player_z;
    GetPlayerPos(playerid, player_x, player_y, player_z);
    
    PlayerSnow[playerid][snow_x][flakeid] = player_x + RandomFloat(-50.0, 50.0);
    PlayerSnow[playerid][snow_y][flakeid] = player_y + RandomFloat(-50.0, 50.0);
    PlayerSnow[playerid][snow_z][flakeid] = player_z + RandomFloat(30.0, 70.0);
    PlayerSnow[playerid][snow_speed][flakeid] = RandomFloat(0.25, 0.65);
    PlayerSnow[playerid][snow_rotation][flakeid] = RandomFloat(0.0, 360.0);
    
    if(PlayerSnow[playerid][snow_object_id][flakeid] != INVALID_OBJECT_ID)
    {
        if(IsValidPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][flakeid]))
        {
            DestroyPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][flakeid]);
        }
        PlayerSnow[playerid][snow_object_id][flakeid] = INVALID_OBJECT_ID;
    }
    
    CreatePlayerSnowFlake(playerid, flakeid);
}

forward UpdatePlayerSnow(playerid);
public UpdatePlayerSnow(playerid)
{
    if(!IsPlayerConnected(playerid)) return;
    
    new Float:player_x, Float:player_y, Float:player_z;
    GetPlayerPos(playerid, player_x, player_y, player_z);
    
    for(new i = 0; i < MAX_SNOW_FLAKES_PER_PLAYER; i++)
    {
        if(PlayerSnow[playerid][snow_object_id][i] == INVALID_OBJECT_ID || 
           !IsValidPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][i]))
        {
            ResetPlayerSnowFlake(playerid, i);
            continue;
        }
        
        PlayerSnow[playerid][snow_x][i] += GlobalWindX * 0.8;
        PlayerSnow[playerid][snow_y][i] += GlobalWindY * 0.8;
        PlayerSnow[playerid][snow_z][i] -= PlayerSnow[playerid][snow_speed][i];
        
        PlayerSnow[playerid][snow_rotation][i] += PlayerSnow[playerid][snow_rotate_speed][i];
        if(PlayerSnow[playerid][snow_rotation][i] > 360.0) 
            PlayerSnow[playerid][snow_rotation][i] -= 360.0;
        if(PlayerSnow[playerid][snow_rotation][i] < 0.0) 
            PlayerSnow[playerid][snow_rotation][i] += 360.0;
        
        new Float:distance = VectorSize(
            PlayerSnow[playerid][snow_x][i] - player_x,
            PlayerSnow[playerid][snow_y][i] - player_y,
            PlayerSnow[playerid][snow_z][i] - player_z
        );
        
        if(PlayerSnow[playerid][snow_z][i] < player_z - 10.0 || distance > 60.0)
        {
            ResetPlayerSnowFlake(playerid, i);
            continue;
        }
        
        new Float:current_x, Float:current_y, Float:current_z;
        GetPlayerObjectPos(playerid, PlayerSnow[playerid][snow_object_id][i], current_x, current_y, current_z);
        
        new Float:move_distance = VectorSize(
            PlayerSnow[playerid][snow_x][i] - current_x,
            PlayerSnow[playerid][snow_y][i] - current_y,
            PlayerSnow[playerid][snow_z][i] - current_z
        );
        
        if(move_distance > 0.5)
        {
            new Float:rx, Float:ry, Float:rz;
            GetPlayerObjectRot(playerid, PlayerSnow[playerid][snow_object_id][i], rx, ry, rz);
            
            rz = PlayerSnow[playerid][snow_rotation][i];
            SetPlayerObjectRot(playerid, PlayerSnow[playerid][snow_object_id][i], rx, ry, rz);
            
            MovePlayerObject(playerid, PlayerSnow[playerid][snow_object_id][i], 
                PlayerSnow[playerid][snow_x][i], 
                PlayerSnow[playerid][snow_y][i], 
                PlayerSnow[playerid][snow_z][i], 
                PlayerSnow[playerid][snow_speed][i] * 0.8);
        }
    }
}

DestroyPlayerSnow(playerid)
{
    if(!PlayerSnow[playerid][snow_initialized]) return 0;
    
    if(PlayerSnow[playerid][snow_timer] != 0)
    {
        KillTimer(PlayerSnow[playerid][snow_timer]);
        PlayerSnow[playerid][snow_timer] = 0;
    }
    
    for(new i = 0; i < MAX_SNOW_FLAKES_PER_PLAYER; i++)
    {
        if(PlayerSnow[playerid][snow_object_id][i] != INVALID_OBJECT_ID)
        {
            if(IsValidPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][i]))
            {
                DestroyPlayerObject(playerid, PlayerSnow[playerid][snow_object_id][i]);
            }
            PlayerSnow[playerid][snow_object_id][i] = INVALID_OBJECT_ID;
        }
    }
    
    PlayerSnow[playerid][snow_initialized] = false;
    
    return 1;
}

public OnGameModeInit()
{
    GlobalWindX = 0.35;
    GlobalWindY = -0.15;
    
    #if defined SNOWARC_OnGameModeInit
        return SNOWARC_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit SNOWARC_OnGameModeInit
#if defined SNOWARC_OnGameModeInit
    forward SNOWARC_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    PlayerSnow[playerid][snow_initialized] = false;
    PlayerSnow[playerid][snow_timer] = 0;
    
    #if defined SNOWARC_OnPlayerConnect
        return SNOWARC_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect SNOWARC_OnPlayerConnect
#if defined SNOWARC_OnPlayerConnect
    forward SNOWARC_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn(playerid)
{
    SetTimerEx("InitPlayerSnowDelayed", 1000, false, "i", playerid);
    
    #if defined SNOWARC_OnPlayerSpawn
        return SNOWARC_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn SNOWARC_OnPlayerSpawn
#if defined SNOWARC_OnPlayerSpawn
    forward SNOWARC_OnPlayerSpawn(playerid);
#endif

forward InitPlayerSnowDelayed(playerid);
public InitPlayerSnowDelayed(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        InitPlayerSnow(playerid);
    }
}

public OnPlayerDisconnect(playerid, reason)
{
    DestroyPlayerSnow(playerid);
    
    #if defined SNOWARC_OnPlayerDisconnect
        return SNOWARC_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect SNOWARC_OnPlayerDisconnect
#if defined SNOWARC_OnPlayerDisconnect
    forward SNOWARC_OnPlayerDisconnect(playerid, reason);
#endif