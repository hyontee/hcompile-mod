// prime_russia_stage.inc
// Autonomous stage tuning system for PRIME RUSSIA CRMP

#if defined _prime_russia_stage_included
    #endinput
#endif
#define _prime_russia_stage_included

#include <a_samp>

// Customizable include paths
#define PRS_DIALOG_ID 17895

// Stage definitions
enum E_PLAYER_STAGE_DATA {
    bool:prsHasStage,
    prsStageType,
    prsStageVehicle,
    Float:prsStageMultiplier
};

new prsPlayerData[MAX_PLAYERS][E_PLAYER_STAGE_DATA];

// Stage prices
#define STAGE_SPORT_PP_PRICE   2000000
#define STAGE_SPORT_P_PRICE    1000000
#define STAGE_SPORT_PRICE      600000
#define STAGE_COMFORT_PRICE    400000
#define STAGE_DRIFT_PRICE      500000

// Stage multipliers
#define STAGE_SPORT_PP_MULT    2.5
#define STAGE_SPORT_P_MULT     2.0
#define STAGE_SPORT_MULT       1.7
#define STAGE_COMFORT_MULT     1.4
#define STAGE_DRIFT_MULT       1.3

// Forward declarations
forward prs_ApplyStageEffect(playerid, vehicleid, stageid);
forward prs_UpdateVehicleSpeed();

// Main initialization
public OnGameModeInit()
{
    SetTimer("prs_UpdateVehicleSpeed", 100, true); // Update every 100ms
    print("PRIME RUSSIA STAGE SYSTEM: Loaded successfully");
    #if defined prs_OnGameModeInit
        return prs_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit prs_OnGameModeInit
#if defined prs_OnGameModeInit
    forward prs_OnGameModeInit();
#endif

// Player connect handler
public OnPlayerConnect(playerid)
{
    prsPlayerData[playerid][prsHasStage] = false;
    prsPlayerData[playerid][prsStageType] = -1;
    prsPlayerData[playerid][prsStageVehicle] = -1;
    prsPlayerData[playerid][prsStageMultiplier] = 1.0;
    
    #if defined prs_OnPlayerConnect
        return prs_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect prs_OnPlayerConnect
#if defined prs_OnPlayerConnect
    forward prs_OnPlayerConnect(playerid);
#endif

// Player disconnect handler  
public OnPlayerDisconnect(playerid, reason)
{
    prsPlayerData[playerid][prsHasStage] = false;
    prsPlayerData[playerid][prsStageType] = -1;
    prsPlayerData[playerid][prsStageVehicle] = -1;
    prsPlayerData[playerid][prsStageMultiplier] = 1.0;
    
    #if defined prs_OnPlayerDisconnect
        return prs_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect prs_OnPlayerDisconnect
#if defined prs_OnPlayerDisconnect
    forward prs_OnPlayerDisconnect(playerid, reason);
#endif

// Player state change handler
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER && prsPlayerData[playerid][prsHasStage]) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid == prsPlayerData[playerid][prsStageVehicle]) {
            prs_ApplyStageEffect(playerid, vehicleid, prsPlayerData[playerid][prsStageType]);
        }
    }
    
    #if defined prs_OnPlayerStateChange
        return prs_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange prs_OnPlayerStateChange
#if defined prs_OnPlayerStateChange
    forward prs_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

// Dialog response handler
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == PRS_DIALOG_ID) {
        if(!response) {
            SendClientMessage(playerid, 0xAAAAAAAA, "Stage selection cancelled.");
            return 1;
        }
        
        if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
            SendClientMessage(playerid, 0xFF0000AA, "ERROR: You must be in a vehicle as driver!");
            return 1;
        }
        
        new vehicleid = GetPlayerVehicleID(playerid);
        new stageName[32], message[128], price;
        new Float:multiplier = 1.0;
        
        switch(listitem) {
            case 0: { 
                price = STAGE_SPORT_PP_PRICE;
                format(stageName, sizeof(stageName), "SPORT++");
                multiplier = STAGE_SPORT_PP_MULT;
            }
            case 1: { 
                price = STAGE_SPORT_P_PRICE;
                format(stageName, sizeof(stageName), "SPORT+");
                multiplier = STAGE_SPORT_P_MULT;
            }
            case 2: { 
                price = STAGE_SPORT_PRICE;
                format(stageName, sizeof(stageName), "SPORT");
                multiplier = STAGE_SPORT_MULT;
            }
            case 3: { 
                price = STAGE_COMFORT_PRICE;
                format(stageName, sizeof(stageName), "COMFORT");
                multiplier = STAGE_COMFORT_MULT;
            }
            case 4: { 
                price = STAGE_DRIFT_PRICE;
                format(stageName, sizeof(stageName), "DRIFT");
                multiplier = STAGE_DRIFT_MULT;
            }
            default: return 1;
        }
        
        if(GetPlayerMoney(playerid) < price) {
            format(message, sizeof(message), "ERROR: You need $%d to purchase %s stage!", price, stageName);
            SendClientMessage(playerid, 0xFF0000AA, message);
            return 1;
        }
        
        GivePlayerMoney(playerid, -price);
        prsPlayerData[playerid][prsHasStage] = true;
        prsPlayerData[playerid][prsStageType] = listitem;
        prsPlayerData[playerid][prsStageVehicle] = vehicleid;
        prsPlayerData[playerid][prsStageMultiplier] = multiplier;
        
        format(message, sizeof(message), "SUCCESS: You have purchased %s stage for $%d! It will be active until you leave the game.", stageName, price);
        SendClientMessage(playerid, 0x00FF00AA, message);
        
        prs_ApplyStageEffect(playerid, vehicleid, listitem);
        return 1;
    }
    
    #if defined prs_OnDialogResponse
        return prs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse prs_OnDialogResponse
#if defined prs_OnDialogResponse
    forward prs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// Stage effect application
public prs_ApplyStageEffect(playerid, vehicleid, stageid) {
    if(!IsPlayerConnected(playerid) || GetPlayerVehicleID(playerid) != vehicleid) return 0;
    
    switch(stageid) {
        case 0: GameTextForPlayer(playerid, "~g~SPORT++ ~w~ACTIVATED", 3000, 4);
        case 1: GameTextForPlayer(playerid, "~b~SPORT+ ~w~ACTIVATED", 3000, 4);
        case 2: GameTextForPlayer(playerid, "~y~SPORT ~w~ACTIVATED", 3000, 4);
        case 3: GameTextForPlayer(playerid, "~p~COMFORT ~w~ACTIVATED", 3000, 4);
        case 4: GameTextForPlayer(playerid, "~r~DRIFT ~w~ACTIVATED", 3000, 4);
    }
    return 1;
}

// Vehicle speed update timer
public prs_UpdateVehicleSpeed() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && prsPlayerData[i][prsHasStage]) {
            if(IsPlayerInAnyVehicle(i) && GetPlayerState(i) == PLAYER_STATE_DRIVER) {
                new vehicleid = GetPlayerVehicleID(i);
                if(vehicleid == prsPlayerData[i][prsStageVehicle]) {
                    new keys, updown, leftright;
                    GetPlayerKeys(i, keys, updown, leftright);
                    
                    // Apply speed boost when accelerating
                    if(keys & KEY_ANALOG_UP) {
                        new Float:x, Float:y, Float:z;
                        GetVehicleVelocity(vehicleid, x, y, z);
                        
                        // Calculate current speed
                        new Float:speed = floatsqroot(x*x + y*y + z*z);
                        
                        // Only boost if already moving
                        if(speed > 0.1) {
                            new Float:angle;
                            GetVehicleZAngle(vehicleid, angle);
                            
                            // Calculate new velocity with multiplier
                            new Float:new_x = x * prsPlayerData[i][prsStageMultiplier];
                            new Float:new_y = y * prsPlayerData[i][prsStageMultiplier];
                            
                            SetVehicleVelocity(vehicleid, new_x, new_y, z);
                        }
                    }
                }
            }
        }
    }
}


// Stock functions
stock PRS_HasPlayerStage(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    return prsPlayerData[playerid][prsHasStage];
}

stock PRS_GetPlayerStageType(playerid) {
    if(!IsPlayerConnected(playerid)) return -1;
    return prsPlayerData[playerid][prsStageType];
}

stock PRS_GetPlayerStageMultiplier(playerid) {
    if(!IsPlayerConnected(playerid)) return 1.0;
    return prsPlayerData[playerid][prsStageMultiplier];
}

stock PRS_RemovePlayerStage(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    prsPlayerData[playerid][prsHasStage] = false;
    prsPlayerData[playerid][prsStageType] = -1;
    prsPlayerData[playerid][prsStageVehicle] = -1;
    prsPlayerData[playerid][prsStageMultiplier] = 1.0;
    return 1;
}