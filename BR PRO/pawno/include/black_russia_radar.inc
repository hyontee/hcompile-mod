// black_russia_radar.inc

#if defined _black_russia_radar_included
    #endinput
#endif
#define _black_russia_radar_included

#include <a_samp>

#define BRR_MAX_RADARS 100
#define BRR_RADAR_PRICE 50000
#define BRR_ACTIVATION_REWARD 500000
#define BRR_SPEED_FINE 250000
#define BRR_OWNER_REWARD 125000
#define BRR_COOLDOWN_TIME 3600000
#define BRR_ACTIVATION_TIME 900
#define BRR_RADAR_RANGE 50.0
#define BRR_DETECTION_RANGE 30.0

enum E_BRR_RADAR {
    bool:brr_Placed,
    brr_Object,
    brr_Object2,
    Text3D:brr_Label,
    brr_OwnerName[MAX_PLAYER_NAME],
    brr_OwnerID,
    brr_SpeedLimit,
    Float:brr_PosX,
    Float:brr_PosY,
    Float:brr_PosZ,
    brr_World,
    brr_Interior,
    brr_ActivationTimer,
    brr_TimeLeft,
    bool:brr_Active,
    brr_FinesCollected
};

new brr_Radars[BRR_MAX_RADARS][E_BRR_RADAR];
new brr_PlayerCooldown[MAX_PLAYERS];
new bool:brr_PlayerInMenu[MAX_PLAYERS];

forward brr_ActivationProcess(radarid);
forward brr_SpeedDetection();
forward brr_UpdateRadarText(radarid);

public OnGameModeInit() {
    SetTimer("brr_SpeedDetection", 1000, true);
    print("Black Russia Radar System Loaded");
    
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        brr_Radars[i][brr_Placed] = false;
    }
    
    #if defined brr_OnGameModeInit
        return brr_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit brr_OnGameModeInit
#if defined brr_OnGameModeInit
    forward brr_OnGameModeInit();
#endif

public OnGameModeExit() {
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(brr_Radars[i][brr_Placed]) {
            brr_DestroyRadar(i);
        }
    }
    
    #if defined brr_OnGameModeExit
        return brr_OnGameModeExit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif

#define OnGameModeExit brr_OnGameModeExit
#if defined brr_OnGameModeExit
    forward brr_OnGameModeExit();
#endif

public OnPlayerDisconnect(playerid, reason) {
    brr_PlayerCooldown[playerid] = 0;
    brr_PlayerInMenu[playerid] = false;
    
    #if defined brr_OnPlayerDisconnect
        return brr_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect brr_OnPlayerDisconnect
#if defined brr_OnPlayerDisconnect
    forward brr_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerDeath(playerid, killerid, reason) {
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(brr_Radars[i][brr_Placed] && brr_Radars[i][brr_OwnerID] == playerid && !brr_Radars[i][brr_Active]) {
            brr_DestroyRadar(i);
            SendClientMessage(playerid, 0xFF0000AA, "RADAR: Missiya provalena! Vy pogibli vo vremya aktivacii.");
        }
    }
    
    #if defined brr_OnPlayerDeath
        return brr_OnPlayerDeath(playerid, killerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath brr_OnPlayerDeath
#if defined brr_OnPlayerDeath
    forward brr_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerCommandText(playerid, cmdtext[]) {
    if(!strcmp(cmdtext, "/radar", true)) {
        if(brr_PlayerCooldown[playerid] > GetTickCount()) {
            new remaining = (brr_PlayerCooldown[playerid] - GetTickCount()) / 1000;
            new minutes = remaining / 60;
            new seconds = remaining % 60;
            
            new message[128];
            format(message, sizeof(message), "RADAR: Sleduyushaya ustanovka cherez %d min. %d sek.", minutes, seconds);
            SendClientMessage(playerid, 0xFF3300AA, message);
            return 1;
        }
        
        brr_ShowMainMenu(playerid);
        return 1;
    }
    return 0;
}

brr_ShowMainMenu(playerid) {
    brr_PlayerInMenu[playerid] = true;
    
    new info[512];
    format(info, sizeof(info),
        "Dobro pozhalovat v sistemu ustanovki radarov!\n\n\
        Stoimost ustanovki: $%d\n\
        Voznagrazhdenie za aktivaciyu: $%d\n\
        Shtraf za prevyshenie: $%d\n\
        Vash dohod so shtrafov: $%d\n\n\
        Vyberite ogranichenie skorosti:",
        BRR_RADAR_PRICE, BRR_ACTIVATION_REWARD, BRR_SPEED_FINE, BRR_OWNER_REWARD);
    
    ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_MSGBOX, "Ustanovka radara GIBDD", info, "Dalee", "Otmena");
}

brr_ShowSpeedSelection(playerid) {
    new speeds[256];
    format(speeds, sizeof(speeds),
        "30 km/ch (gorodskaya zona)\n\
        40 km/ch (zhilie rayoni)\n\
        50 km/ch (vnutri goroda)\n\
        60 km/ch (gorodskie magistrali)\n\
        70 km/ch (zagorodnye dorogi)\n\
        80 km/ch (shosse)\n\
        90 km/ch (magistrali)\n\
        100 km/ch (skorostnye trassy)\n\
        110 km/ch (avtobany)\n\
        120 km/ch (maksimalnaya skorost)");
    
    ShowPlayerDialog(playerid, 9501, DIALOG_STYLE_LIST, "Vybor ogranicheniya skorosti", speeds, "Vybrat", "Nazad");
}

brr_ShowConfirmation(playerid, speedlimit) {
    new confirm[256];
    format(confirm, sizeof(confirm),
        "Podtverzhdenie ustanovki radara\n\n\
        Ogranichenie skorosti: %d km/ch\n\
        Stoimost ustanovki: $%d\n\
        Voznagrazhdenie: $%d\n\
        Dohod so shtrafov: $%d\n\n\
        Posle oplaty vam nuzhno budet ostavatsya\n\
        ryadom s radarom 15 minut dlya aktivacii.",
        speedlimit, BRR_RADAR_PRICE, BRR_ACTIVATION_REWARD, BRR_OWNER_REWARD);
    
    SetPVarInt(playerid, "brr_SelectedSpeed", speedlimit);
    ShowPlayerDialog(playerid, 9502, DIALOG_STYLE_MSGBOX, "Podtverzhdenie ustanovki", confirm, "Ustanovit", "Otmena");
}

brr_CreateRadar(playerid, speedlimit) {
    if(GetPlayerMoney(playerid) < BRR_RADAR_PRICE) {
        SendClientMessage(playerid, 0xFF0000AA, "RADAR: Nedostatochno sredstv dlya ustanovki!");
        brr_PlayerInMenu[playerid] = false;
        return;
    }
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new world = GetPlayerVirtualWorld(playerid);
    new interior = GetPlayerInterior(playerid);
    
    new radarid = -1;
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(!brr_Radars[i][brr_Placed]) {
            radarid = i;
            break;
        }
    }
    
    if(radarid == -1) {
        SendClientMessage(playerid, 0xFF0000AA, "RADAR: Dostignut limit radarov na servere!");
        brr_PlayerInMenu[playerid] = false;
        return;
    }
    
    GivePlayerMoney(playerid, -BRR_RADAR_PRICE);
    
    // Osnovnye dannye radara
    brr_Radars[radarid][brr_Placed] = true;
    brr_Radars[radarid][brr_OwnerID] = playerid;
    brr_Radars[radarid][brr_SpeedLimit] = speedlimit;
    brr_Radars[radarid][brr_PosX] = x + 3.0;
    brr_Radars[radarid][brr_PosY] = y + 3.0;
    brr_Radars[radarid][brr_PosZ] = z - 0.8;
    brr_Radars[radarid][brr_World] = world;
    brr_Radars[radarid][brr_Interior] = interior;
    brr_Radars[radarid][brr_Active] = false;
    brr_Radars[radarid][brr_FinesCollected] = 0;
    
    GetPlayerName(playerid, brr_Radars[radarid][brr_OwnerName], MAX_PLAYER_NAME);
    
    // Sozdanie ob'ektov radara (realichnaya model)
    brr_Radars[radarid][brr_Object] = CreateObject(1999, brr_Radars[radarid][brr_PosX], brr_Radars[radarid][brr_PosY], brr_Radars[radarid][brr_PosZ], 0.0, 0.0, 0.0);
    brr_Radars[radarid][brr_Object2] = CreateObject(1985, brr_Radars[radarid][brr_PosX], brr_Radars[radarid][brr_PosY], brr_Radars[radarid][brr_PosZ] + 1.5, 0.0, 0.0, 0.0);
    
    // Tekstovaya metka
    new labelText[256];
    format(labelText, sizeof(labelText),
        "[RADAR GIBDD]\n\
        Ogranichenie: %d km/ch\n\
        Vladelec: %s\n\
        Status: AKTIVACIA\n\
        Ostalos: 15:00",
        speedlimit, brr_Radars[radarid][brr_OwnerName]);
    
    brr_Radars[radarid][brr_Label] = Create3DTextLabel(labelText, 0x33CCFFAA, 
        brr_Radars[radarid][brr_PosX], brr_Radars[radarid][brr_PosY], brr_Radars[radarid][brr_PosZ] + 3.0, 15.0, world, 0);
    
    // Zapusk taymera aktivacii
    brr_Radars[radarid][brr_TimeLeft] = BRR_ACTIVATION_TIME;
    brr_Radars[radarid][brr_ActivationTimer] = SetTimerEx("brr_ActivationProcess", 1000, true, "i", radarid);
    
    // Soobshcheniya igroku
    SendClientMessage(playerid, 0x33FF33AA, "RADAR: Radar uspeshno ustanovlen!");
    SendClientMessage(playerid, 0x33FF33AA, "RADAR: Ostavaites v radiuse 50 metrov dlya aktivacii (15 minut).");
    SendClientMessage(playerid, 0xFF9900AA, "RADAR: Vnimanie! Esli vy pokinete zonu ili pogibnete - radar budet unichtozhen!");
    
    // Ustanovka koldauna
    brr_PlayerCooldown[playerid] = GetTickCount() + BRR_COOLDOWN_TIME;
    brr_PlayerInMenu[playerid] = false;
}

brr_DestroyRadar(radarid) {
    if(brr_Radars[radarid][brr_Placed]) {
        if(brr_Radars[radarid][brr_Object] != 0) {
            DestroyObject(brr_Radars[radarid][brr_Object]);
        }
        if(brr_Radars[radarid][brr_Object2] != 0) {
            DestroyObject(brr_Radars[radarid][brr_Object2]);
        }
        if(brr_Radars[radarid][brr_Label] != Text3D:0) {
            Delete3DTextLabel(brr_Radars[radarid][brr_Label]);
        }
        if(brr_Radars[radarid][brr_ActivationTimer] != 0) {
            KillTimer(brr_Radars[radarid][brr_ActivationTimer]);
        }
        
        brr_Radars[radarid][brr_Placed] = false;
        brr_Radars[radarid][brr_Active] = false;
        brr_Radars[radarid][brr_ActivationTimer] = 0;
    }
}

public brr_ActivationProcess(radarid) {
    if(!brr_Radars[radarid][brr_Placed]) {
        if(brr_Radars[radarid][brr_ActivationTimer] != 0) {
            KillTimer(brr_Radars[radarid][brr_ActivationTimer]);
        }
        return;
    }
    
    brr_Radars[radarid][brr_TimeLeft]--;
    
    if(brr_Radars[radarid][brr_TimeLeft] <= 0) {
        // Aktivacia zavershena
        KillTimer(brr_Radars[radarid][brr_ActivationTimer]);
        brr_Radars[radarid][brr_Active] = true;
        brr_Radars[radarid][brr_ActivationTimer] = 0;
        
        // Obnovlenie teksta
        new activeText[256];
        format(activeText, sizeof(activeText),
            "[RADAR GIBDD]\n\
            Ogranichenie: %d km/ch\n\
            Vladelec: %s\n\
            Status: AKTIVEN\n\
            Shtrafov: %d\n\
            Dohod: $%d",
            brr_Radars[radarid][brr_SpeedLimit], 
            brr_Radars[radarid][brr_OwnerName],
            brr_Radars[radarid][brr_FinesCollected],
            brr_Radars[radarid][brr_FinesCollected] * BRR_OWNER_REWARD);
        
        Update3DTextLabelText(brr_Radars[radarid][brr_Label], 0x00FF00AA, activeText);
        
        // Nagrada za aktivaciyu
        if(IsPlayerConnected(brr_Radars[radarid][brr_OwnerID])) {
            GivePlayerMoney(brr_Radars[radarid][brr_OwnerID], BRR_ACTIVATION_REWARD);
            
            new successMsg[128];
            format(successMsg, sizeof(successMsg), "RADAR: Aktivacia zavershena! Vy poluchili $%d", BRR_ACTIVATION_REWARD);
            SendClientMessage(brr_Radars[radarid][brr_OwnerID], 0x00FF00AA, successMsg);
            
            ShowPlayerDialog(brr_Radars[radarid][brr_OwnerID], 9503, DIALOG_STYLE_MSGBOX,
                "Aktivacia radara",
                "Pozdravlyaem! Vash radar uspeshno aktivirovan.\nTeper on budet fiksirovat narusheniya skorosti\n i prinosit vam dohod!",
                "OK", "");
        }
    } else {
        // Proverka nakhoddeniya vladel'ca ryadom
        if(IsPlayerConnected(brr_Radars[radarid][brr_OwnerID])) {
            new Float:playerX, Float:playerY, Float:playerZ;
            GetPlayerPos(brr_Radars[radarid][brr_OwnerID], playerX, playerY, playerZ);
            
            new Float:distance = GetPlayerDistanceFromPoint(brr_Radars[radarid][brr_OwnerID], 
                brr_Radars[radarid][brr_PosX], brr_Radars[radarid][brr_PosY], brr_Radars[radarid][brr_PosZ]);
            
            if(distance > BRR_RADAR_RANGE) {
                brr_DestroyRadar(radarid);
                SendClientMessage(brr_Radars[radarid][brr_OwnerID], 0xFF0000AA, "RADAR: Missiya provalena! Vy pokinuli zonu aktivacii.");
                return;
            }
        } else {
            brr_DestroyRadar(radarid);
            return;
        }
        
        // Obnovlenie taymera na metke
        new minutes = brr_Radars[radarid][brr_TimeLeft] / 60;
        new seconds = brr_Radars[radarid][brr_TimeLeft] % 60;
        
        new updateText[256];
        format(updateText, sizeof(updateText),
            "[RADAR GIBDD]\n\
            Ogranichenie: %d km/ch\n\
            Vladelec: %s\n\
            Status: AKTIVACIA\n\
            Ostalos: %02d:%02d",
            brr_Radars[radarid][brr_SpeedLimit], 
            brr_Radars[radarid][brr_OwnerName], 
            minutes, seconds);
        
        Update3DTextLabelText(brr_Radars[radarid][brr_Label], 0x33CCFFAA, updateText);
    }
}

Float:brr_CalculateSpeed(vehicleid) {
    new Float:x, Float:y, Float:z;
    GetVehicleVelocity(vehicleid, x, y, z);
    return floatsqroot(x*x + y*y + z*z) * 180.0;
}

public brr_SpeedDetection() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
            new vehicleid = GetPlayerVehicleID(i);
            new Float:speed = brr_CalculateSpeed(vehicleid);
            
            for(new j = 0; j < BRR_MAX_RADARS; j++) {
                if(brr_Radars[j][brr_Placed] && brr_Radars[j][brr_Active]) {
                    // Proverka mira i inter'era
                    if(GetPlayerVirtualWorld(i) != brr_Radars[j][brr_World] || GetPlayerInterior(i) != brr_Radars[j][brr_Interior]) {
                        continue;
                    }
                    
                    // Proverka rasstoyaniya
                    new Float:playerX, Float:playerY, Float:playerZ;
                    GetPlayerPos(i, playerX, playerY, playerZ);
                    
                    new Float:distance = GetPlayerDistanceFromPoint(i, 
                        brr_Radars[j][brr_PosX], brr_Radars[j][brr_PosY], brr_Radars[j][brr_PosZ]);
                    
                    if(distance < BRR_DETECTION_RANGE) {
                        // Proverka skorosti
                        if(speed > brr_Radars[j][brr_SpeedLimit]) {
                            // Vladelec ne poluchaet shtrafy
                            if(i == brr_Radars[j][brr_OwnerID]) continue;
                            
                            if(GetPlayerMoney(i) >= BRR_SPEED_FINE) {
                                // Vypisyvaem shtraf
                                GivePlayerMoney(i, -BRR_SPEED_FINE);
                                
                                // Vizual'noe opoveshchenie
                                GameTextForPlayer(i, "~r~PREVYSHENIE SKOROSTI!~n~~w~Shtraf: ~r~$250,000", 5000, 3);
                                SendClientMessage(i, 0xFF0000AA, "RADAR: Prevyshena dopustimaya skorost! Shtraf $250,000");
                                
                                // Nagrada vladel'cu
                                if(IsPlayerConnected(brr_Radars[j][brr_OwnerID])) {
                                    GivePlayerMoney(brr_Radars[j][brr_OwnerID], BRR_OWNER_REWARD);
                                    brr_Radars[j][brr_FinesCollected]++;
                                    
                                    new ownerMsg[128];
                                    format(ownerMsg, sizeof(ownerMsg), "RADAR: Zafiksirovano narushenie! Vash dohod: $%d", BRR_OWNER_REWARD);
                                    SendClientMessage(brr_Radars[j][brr_OwnerID], 0x00FF00AA, ownerMsg);
                                    
                                    // Obnovlyaem tekst radara
                                    brr_UpdateRadarText(j);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

public brr_UpdateRadarText(radarid) {
    if(brr_Radars[radarid][brr_Placed] && brr_Radars[radarid][brr_Active]) {
        new updatedText[256];
        format(updatedText, sizeof(updatedText),
            "[RADAR GIBDD]\n\
            Ogranichenie: %d km/ch\n\
            Vladelec: %s\n\
            Status: AKTIVEN\n\
            Shtrafov: %d\n\
            Dohod: $%d",
            brr_Radars[radarid][brr_SpeedLimit], 
            brr_Radars[radarid][brr_OwnerName],
            brr_Radars[radarid][brr_FinesCollected],
            brr_Radars[radarid][brr_FinesCollected] * BRR_OWNER_REWARD);
        
        Update3DTextLabelText(brr_Radars[radarid][brr_Label], 0x00FF00AA, updatedText);
    }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(brr_PlayerInMenu[playerid]) {
        switch(dialogid) {
            case 9500: {
                if(response) {
                    brr_ShowSpeedSelection(playerid);
                } else {
                    brr_PlayerInMenu[playerid] = false;
                    SendClientMessage(playerid, 0xFF0000AA, "RADAR: Ustanovka otmenena.");
                }
                return 1;
            }
            case 9501: {
                if(response) {
                    new speedlimit = 30 + (listitem * 10);
                    brr_ShowConfirmation(playerid, speedlimit);
                } else {
                    brr_ShowMainMenu(playerid);
                }
                return 1;
            }
            case 9502: {
                if(response) {
                    new speedlimit = GetPVarInt(playerid, "brr_SelectedSpeed");
                    DeletePVar(playerid, "brr_SelectedSpeed");
                    brr_CreateRadar(playerid, speedlimit);
                } else {
                    DeletePVar(playerid, "brr_SelectedSpeed");
                    brr_ShowSpeedSelection(playerid);
                }
                return 1;
            }
        }
    }
    
    #if defined brr_OnDialogResponse
        return brr_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse brr_OnDialogResponse
#if defined brr_OnDialogResponse
    forward brr_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif

#define OnPlayerCommandText brr_OnPlayerCommandText
forward brr_OnPlayerCommandText(playerid, cmdtext[]);

// Dopolnitel'nye funkcii dlya administrirovaniya
stock BRR_DestroyAllRadars() {
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(brr_Radars[i][brr_Placed]) {
            brr_DestroyRadar(i);
        }
    }
    print("Black Russia Radar System: All radars destroyed");
}

stock BRR_GetPlayerRadars(playerid) {
    new count = 0;
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(brr_Radars[i][brr_Placed] && brr_Radars[i][brr_OwnerID] == playerid) {
            count++;
        }
    }
    return count;
}

stock BRR_RemovePlayerRadars(playerid) {
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(brr_Radars[i][brr_Placed] && brr_Radars[i][brr_OwnerID] == playerid) {
            brr_DestroyRadar(i);
        }
    }
}

stock BRR_GetActiveRadarsCount() {
    new count = 0;
    for(new i = 0; i < BRR_MAX_RADARS; i++) {
        if(brr_Radars[i][brr_Placed] && brr_Radars[i][brr_Active]) {
            count++;
        }
    }
    return count;
}