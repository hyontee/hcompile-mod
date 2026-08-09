/*Автор системы: https://t.me/rcdDRIFTOVICH (Werton) 

Лс автора: @Tinkoff_account
                     @HET_HOMEP */
                     
enum PLAYER_FIXPICKUP
{
    P_PICK
}
new player_fix_pickup[MAX_PLAYERS][PLAYER_FIXPICKUP];
// Выше старая идея для 3 версии но я решил сделать проще

public OnPlayerConnect(playerid)
{
SetPVarInt(playerid, "player_state_pickup", 0);

#if defined fixp_OnPlayerConnect
        return fixp_OnPlayerConnect(playerid);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect fixp_OnPlayerConnect
#if defined fixp_OnPlayerConnect
    forward fixp_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn(playerid)
{
SetPVarInt(playerid, "player_state_pickup", 0);

#if defined fixp_OnPlayerSpawn
        return fixp_OnPlayerSpawn(playerid);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn fixp_OnPlayerSpawn
#if defined fixp_OnPlayerSpawn
    forward fixp_OnPlayerSpawn(playerid);
#endif

public OnGameModeInit()
{
    print("\n");
    print("===============================\n");
    print(" Fix Pickup 2025 loaded.\n");
    print("      Version:  1.1.3\n");
    print(" (create) 2025 By Wеrtоn\n");
    print("===============================\n");

    #if defined fixp_OnGameModeInit
        return fixp_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit fixp_OnGameModeInit
#if defined fixp_OnGameModeInit
    forward fixp_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{


#if defined fixp_OnPlayerEnterDynamicArea
        return fixp_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea fixp_OnPlayerEnterDynamicArea
#if defined fixp_OnPlayerEnterDynamicArea
    forward fixp_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
SetPVarInt(playerid, "player_state_pickup", 0);

#if defined fixp_OnPlayerLeaveDynamicArea
        return fixp_OnPlayerLeaveDynamicArea(playerid, areaid);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea
#else
    #define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea fixp_OnPlayerLeaveDynamicArea
#if defined fixp_OnPlayerLeaveDynamicArea
    forward fixp_OnPlayerLeaveDynamicArea(playerid, areaid);
#endif

/*Автор системы: https://t.me/rcdDRIFTOVICH (Werton) 

Лс автора: @Tinkoff_account
                     @HET_HOMEP */