// ==============================================
//              BLACK PASS SYSTEM
// ==============================================

// ============ GLOBAL VARIABLES ============
new BlackPass_PlayerQuest[MAX_PLAYERS];
new BlackPass_PlayerPrize[MAX_PLAYERS];
new BlackPass_PlayerQuestId[MAX_PLAYERS];

// Prizes array
enum BlackPassPrizeInfo
{
    PrizeName[32],
    PrizeType,
    PrizeValue,
    PrizeDesc[64]
}

new const BlackPass_Prizes[][BlackPassPrizeInfo] = {
    {"VIP status 30 days", 1, 30, "Poluchite VIP status na 30 dney!"},
    {"BMW M5 F90", 2, 411, "Poluchite krutuyu mashinu!"},
    {"Skin bandita", 3, 122, "Poluchite unikalniy skin!"}
};

// Vehicles array
enum BlackPassVehicleInfo
{
    VehicleName[32],
    VehicleModel,
    VehiclePrice
}

new const BlackPass_Vehicles[][BlackPassVehicleInfo] = {
    {"BMW M5 F90", 411, 5000000},
    {"Mercedes GT63s", 402, 4500000},
    {"Audi RS7", 421, 4000000},
    {"Lamborghini Aventador", 415, 8000000},
    {"Ferrari F40", 412, 7000000}
};

// Skins array
new const BlackPass_Skins[] = {
    122, 124, 125, 126, 127, 128, 129, 130
};

// ============ INITIALIZATION ============
stock BlackPass_OnGameModeInit()
{
    print("[BlackPass] Sistema Black Pass zagruzhena!");
    return 1;
}

// ============ COMMAND /blackpass ============
CMD:blackpass(playerid, params[])
{
    ShowPlayerDialog(playerid, 6000, DIALOG_STYLE_LIST, 
        "{FFD700}BLACK PASS - PRIZY",
        "{00FF00}Priz 1: {FFFFFF}VIP status 30 dney\n\
         {00FF00}Priz 2: {FFFFFF}BMW M5 F90\n\
         {00FF00}Priz 3: {FFFFFF}Skin bandita",
        "Vibrat", "Zakrit");
    return 1;
}

// ============ COMMAND /blackvest ============
CMD:blackvest(playerid, params[])
{
    if(BlackPass_PlayerQuest[playerid] == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "U vas uzhe est aktivnoe zadanie!");
        return 1;
    }
    
    ShowPlayerDialog(playerid, 6001, DIALOG_STYLE_LIST,
        "{FFD700}BLACK PASS - ZADANIYA",
        "{00FF00}Zadanie 1: {FFFFFF}Prodavte 5 mashin\n\
         {00FF00}Zadanie 2: {FFFFFF}Zarabotayte 1.000.000$\n\
         {00FF00}Zadanie 3: {FFFFFF}Ubeyte 10 vragov",
        "Vibrat", "Zakrit");
    return 1;
}

// ============ COMMAND /giveprize ============
CMD:giveprize(playerid, params[])
{
    new targetid, prizeid;
    
    if(GetPlayerAdminEx(playerid) < 12)
    {
        SendClientMessage(playerid, 0xFF0000FF, "U vas net prav! Trebuetsya 12 uroven admina!");
        return 1;
    }
    
    if(sscanf(params, "ud", targetid, prizeid))
    {
        SendClientMessage(playerid, 0xFFD700FF, "Ispolzovanie: /giveprize [ID igroka] [1-3]");
        return 1;
    }
    
    if(prizeid < 1 || prizeid > 3)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Priz dolzhen byt ot 1 do 3!");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Igrok ne nayden!");
        return 1;
    }
    
    new str[128];
    new targetname[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetname, sizeof(targetname));
    
    format(str, sizeof(str), "{FFD700}Administrator vidal vam priz: {00FF00}%s", BlackPass_Prizes[prizeid-1][PrizeName]);
    SendClientMessage(targetid, 0x00FF00FF, str);
    
    format(str, sizeof(str), "Vi vdali priz \"%s\" igroku %s", BlackPass_Prizes[prizeid-1][PrizeName], targetname);
    SendClientMessage(playerid, 0x00FF00FF, str);
    
    switch(prizeid)
    {
        case 1:
        {
            SendClientMessage(targetid, 0x00FF00FF, "Vi poluchili VIP status na 30 dney!");
        }
        case 2:
        {
            new vehicleid = CreateVehicle(BlackPass_Vehicles[0][VehicleModel], 0.0, 0.0, 0.0, 0.0, -1, -1, 60000);
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                PutPlayerInVehicle(targetid, vehicleid, 0);
            }
            SendClientMessage(targetid, 0x00FF00FF, "Vi poluchili BMW M5 F90!");
        }
        case 3:
        {
            SetPlayerSkin(targetid, BlackPass_Prizes[prizeid-1][PrizeValue]);
            SendClientMessage(targetid, 0x00FF00FF, "Vi poluchili skin bandita!");
        }
    }
    
    return 1;
}

// ============ COMMAND /blackinfo ============
CMD:blackinfo(playerid, params[])
{
    new type;
    
    if(GetPlayerAdminEx(playerid) < 12)
    {
        SendClientMessage(playerid, 0xFF0000FF, "U vas net prav! Trebuetsya 12 uroven admina!");
        return 1;
    }
    
    if(sscanf(params, "d", type))
    {
        SendClientMessage(playerid, 0xFFD700FF, "Ispolzovanie: /blackinfo [1 - VIP | 2 - Mashiny | 3 - Skiny]");
        return 1;
    }
    
    new str[512];
    
    switch(type)
    {
        case 1:
        {
            format(str, sizeof(str), "{FFD700}=== VIP STATUSY ===\n{00FF00}Priz 1: {FFFFFF}VIP status 30 dney");
            ShowPlayerDialog(playerid, 6002, DIALOG_STYLE_MSGBOX, "Black Pass Info - VIP", str, "OK", "");
        }
        case 2:
        {
            format(str, sizeof(str), "{FFD700}=== DOSTUPNYE MASHINY ===\n");
            for(new i = 0; i < sizeof(BlackPass_Vehicles); i++)
            {
                format(str, sizeof(str), "%s\n{00FF00}%d. {FFFFFF}%s", str, i+1, BlackPass_Vehicles[i][VehicleName]);
            }
            ShowPlayerDialog(playerid, 6002, DIALOG_STYLE_MSGBOX, "Black Pass Info - Mashiny", str, "OK", "");
        }
        case 3:
        {
            format(str, sizeof(str), "{FFD700}=== DOSTUPNYE SKINY ===\n");
            for(new i = 0; i < sizeof(BlackPass_Skins); i++)
            {
                format(str, sizeof(str), "%s\n{00FF00}%d. {FFFFFF}Skin ID: %d", str, i+1, BlackPass_Skins[i]);
            }
            ShowPlayerDialog(playerid, 6002, DIALOG_STYLE_MSGBOX, "Black Pass Info - Skiny", str, "OK", "");
        }
        default:
        {
            SendClientMessage(playerid, 0xFF0000FF, "Neverniy tip! Ispolzuyte: 1 - VIP, 2 - Mashiny, 3 - Skiny");
        }
    }
    return 1;
}

// ============ DIALOG HANDLER ============
stock BlackPass_OnDialogResponse(playerid, dialogid, response, listitem)
{
    if(dialogid == 6000)
    {
        if(response)
        {
            new prizeid = listitem + 1;
            new str[256];
            format(str, sizeof(str), "{FFD700}%s\n\n{FFFFFF}%s\n\n{00FF00}Hotite poluchit etot priz?", 
                BlackPass_Prizes[prizeid-1][PrizeName],
                BlackPass_Prizes[prizeid-1][PrizeDesc]);
            ShowPlayerDialog(playerid, 6003, DIALOG_STYLE_MSGBOX, "Black Pass - Poluchenie priza", str, "Da", "Net");
            BlackPass_PlayerPrize[playerid] = prizeid;
        }
        return 1;
    }
    
    if(dialogid == 6001)
    {
        if(response)
        {
            new questid = listitem + 1;
            BlackPass_PlayerQuest[playerid] = 1;
            BlackPass_PlayerQuestId[playerid] = questid;
            
            new str[256];
            format(str, sizeof(str), "{FFD700}Zadanie prinyato!\n\n{00FF00}Nagrada: %s\n\n{FFFFFF}Vypolnite zadanie i poluchite priz!", 
                BlackPass_Prizes[BlackPass_PlayerPrize[playerid]-1][PrizeName]);
            ShowPlayerDialog(playerid, 6004, DIALOG_STYLE_MSGBOX, "Black Pass - Zadanie prinyato", str, "OK", "");
        }
        return 1;
    }
    
    if(dialogid == 6003)
    {
        if(response)
        {
            SendClientMessage(playerid, 0x00FF00FF, "Dlya polucheniya priza vypolnite zadanie! Vvedite /blackvest");
        }
        return 1;
    }
    
    return 0;
}