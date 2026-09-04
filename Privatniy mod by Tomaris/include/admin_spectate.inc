// ===================================================
// ADMIN SPECTATE SYSTEM - BLACK RUSSIA CRMP
// FINAL VERSION - NO CONFLICTS
// ===================================================

#if defined _adminspec_included
    #endinput
#endif

#define _adminspec_included

#include <a_samp>

#define ADSPEC_DIALOG_START 98760

enum E_ADSPEC_DATA {
    bool:adspec_active,
    adspec_target,
    adspec_timer,
    PlayerText:adspec_bg,
    PlayerText:adspec_header,
    PlayerText:adspec_info_title,
    PlayerText:adspec_player_name,
    PlayerText:adspec_btns[7],
    PlayerText:adspec_stats
}

static AS_Data[MAX_PLAYERS][E_ADSPEC_DATA];

// ===================================================
// CORE SYSTEM FUNCTIONS
// ===================================================

static AS_SystemInit()
{
    for(new i = 0; i < MAX_PLAYERS; i++) {
        AS_Data[i][adspec_active] = false;
        AS_Data[i][adspec_target] = INVALID_PLAYER_ID;
        AS_Data[i][adspec_timer] = 0;
        
        for(new j = 0; j < 7; j++) {
            AS_Data[i][adspec_btns][j] = PlayerText:INVALID_TEXT_DRAW;
        }
        
        AS_Data[i][adspec_bg] = PlayerText:INVALID_TEXT_DRAW;
        AS_Data[i][adspec_header] = PlayerText:INVALID_TEXT_DRAW;
        AS_Data[i][adspec_info_title] = PlayerText:INVALID_TEXT_DRAW;
        AS_Data[i][adspec_player_name] = PlayerText:INVALID_TEXT_DRAW;
        AS_Data[i][adspec_stats] = PlayerText:INVALID_TEXT_DRAW;
    }
    
    printf("[ADMIN-SPEC] System loaded successfully");
    return 1;
}

static AS_CreateUI(playerid)
{
    AS_DestroyUI(playerid);
    
    // Background
    AS_Data[playerid][adspec_bg] = CreatePlayerTextDraw(playerid, 320.000000, 200.000000, "box");
    PlayerTextDrawLetterSize(playerid, AS_Data[playerid][adspec_bg], 0.000000, 25.000000);
    PlayerTextDrawTextSize(playerid, AS_Data[playerid][adspec_bg], 0.000000, 600.000000);
    PlayerTextDrawAlignment(playerid, AS_Data[playerid][adspec_bg], 2);
    PlayerTextDrawColor(playerid, AS_Data[playerid][adspec_bg], -1);
    PlayerTextDrawUseBox(playerid, AS_Data[playerid][adspec_bg], 1);
    PlayerTextDrawBoxColor(playerid, AS_Data[playerid][adspec_bg], 100);
    PlayerTextDrawSetShadow(playerid, AS_Data[playerid][adspec_bg], 0);
    PlayerTextDrawSetOutline(playerid, AS_Data[playerid][adspec_bg], 0);
    PlayerTextDrawBackgroundColor(playerid, AS_Data[playerid][adspec_bg], 255);
    PlayerTextDrawFont(playerid, AS_Data[playerid][adspec_bg], 1);
    PlayerTextDrawSetProportional(playerid, AS_Data[playerid][adspec_bg], 1);

    // Header
    AS_Data[playerid][adspec_header] = CreatePlayerTextDraw(playerid, 320.000000, 165.000000, "ADMIN SPECTATE");
    PlayerTextDrawLetterSize(playerid, AS_Data[playerid][adspec_header], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, AS_Data[playerid][adspec_header], 2);
    PlayerTextDrawColor(playerid, AS_Data[playerid][adspec_header], -16776961);
    PlayerTextDrawSetShadow(playerid, AS_Data[playerid][adspec_header], 0);
    PlayerTextDrawSetOutline(playerid, AS_Data[playerid][adspec_header], 1);
    PlayerTextDrawBackgroundColor(playerid, AS_Data[playerid][adspec_header], 255);
    PlayerTextDrawFont(playerid, AS_Data[playerid][adspec_header], 1);
    PlayerTextDrawSetProportional(playerid, AS_Data[playerid][adspec_header], 1);

    // Buttons
    new const btn_names[7][] = {"KICK", "MUTE", "JAIL", "WARN", "SLAP", "BAN", "EXIT"};
    new Float:btn_y = 190.0;
    
    for(new i = 0; i < 7; i++) {
        AS_Data[playerid][adspec_btns][i] = CreatePlayerTextDraw(playerid, 150.000000, btn_y, btn_names[i]);
        PlayerTextDrawLetterSize(playerid, AS_Data[playerid][adspec_btns][i], 0.250000, 1.200000);
        PlayerTextDrawTextSize(playerid, AS_Data[playerid][adspec_btns][i], 200.000000, 15.000000);
        PlayerTextDrawAlignment(playerid, AS_Data[playerid][adspec_btns][i], 1);
        PlayerTextDrawColor(playerid, AS_Data[playerid][adspec_btns][i], (i == 6) ? -65281 : -1);
        PlayerTextDrawUseBox(playerid, AS_Data[playerid][adspec_btns][i], 1);
        PlayerTextDrawBoxColor(playerid, AS_Data[playerid][adspec_btns][i], 100);
        PlayerTextDrawSetShadow(playerid, AS_Data[playerid][adspec_btns][i], 0);
        PlayerTextDrawSetOutline(playerid, AS_Data[playerid][adspec_btns][i], 0);
        PlayerTextDrawBackgroundColor(playerid, AS_Data[playerid][adspec_btns][i], 255);
        PlayerTextDrawFont(playerid, AS_Data[playerid][adspec_btns][i], 1);
        PlayerTextDrawSetProportional(playerid, AS_Data[playerid][adspec_btns][i], 1);
        PlayerTextDrawSetSelectable(playerid, AS_Data[playerid][adspec_btns][i], true);
        
        btn_y += 20.0;
        if(i == 5) btn_y += 10.0;
    }
    
    // Info title
    AS_Data[playerid][adspec_info_title] = CreatePlayerTextDraw(playerid, 450.000000, 190.000000, "Player Information");
    PlayerTextDrawLetterSize(playerid, AS_Data[playerid][adspec_info_title], 0.200000, 1.000000);
    PlayerTextDrawAlignment(playerid, AS_Data[playerid][adspec_info_title], 1);
    PlayerTextDrawColor(playerid, AS_Data[playerid][adspec_info_title], -1);
    PlayerTextDrawSetShadow(playerid, AS_Data[playerid][adspec_info_title], 0);
    PlayerTextDrawSetOutline(playerid, AS_Data[playerid][adspec_info_title], 0);
    PlayerTextDrawBackgroundColor(playerid, AS_Data[playerid][adspec_info_title], 255);
    PlayerTextDrawFont(playerid, AS_Data[playerid][adspec_info_title], 1);
    PlayerTextDrawSetProportional(playerid, AS_Data[playerid][adspec_info_title], 1);
    
    return 1;
}

static AS_DestroyUI(playerid)
{
    for(new i = 0; i < 7; i++) {
        if(AS_Data[playerid][adspec_btns][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_btns][i]);
            AS_Data[playerid][adspec_btns][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    
    if(AS_Data[playerid][adspec_bg] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_bg]);
    }
    if(AS_Data[playerid][adspec_header] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_header]);
    }
    if(AS_Data[playerid][adspec_info_title] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_info_title]);
    }
    if(AS_Data[playerid][adspec_player_name] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_player_name]);
    }
    if(AS_Data[playerid][adspec_stats] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_stats]);
    }
    
    AS_Data[playerid][adspec_bg] = PlayerText:INVALID_TEXT_DRAW;
    AS_Data[playerid][adspec_header] = PlayerText:INVALID_TEXT_DRAW;
    AS_Data[playerid][adspec_info_title] = PlayerText:INVALID_TEXT_DRAW;
    AS_Data[playerid][adspec_player_name] = PlayerText:INVALID_TEXT_DRAW;
    AS_Data[playerid][adspec_stats] = PlayerText:INVALID_TEXT_DRAW;
    
    return 1;
}

static AS_ShowUI(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) return 0;
    
    PlayerTextDrawShow(playerid, AS_Data[playerid][adspec_bg]);
    PlayerTextDrawShow(playerid, AS_Data[playerid][adspec_header]);
    PlayerTextDrawShow(playerid, AS_Data[playerid][adspec_info_title]);
    
    for(new i = 0; i < 7; i++) {
        PlayerTextDrawShow(playerid, AS_Data[playerid][adspec_btns][i]);
    }
    
    AS_UpdatePlayerInfo(playerid, targetid);
    SelectTextDraw(playerid, 0x00FF00FF);
    
    return 1;
}

static AS_HideUI(playerid)
{
    PlayerTextDrawHide(playerid, AS_Data[playerid][adspec_bg]);
    PlayerTextDrawHide(playerid, AS_Data[playerid][adspec_header]);
    PlayerTextDrawHide(playerid, AS_Data[playerid][adspec_info_title]);
    PlayerTextDrawHide(playerid, AS_Data[playerid][adspec_player_name]);
    PlayerTextDrawHide(playerid, AS_Data[playerid][adspec_stats]);
    
    for(new i = 0; i < 7; i++) {
        PlayerTextDrawHide(playerid, AS_Data[playerid][adspec_btns][i]);
    }
    
    CancelSelectTextDraw(playerid);
    return 1;
}

static AS_UpdatePlayerInfo(playerid, targetid)
{
    new name[24], info_str[128], stats_str[256];
    GetPlayerName(targetid, name, sizeof(name));
    
    AS_GetPlayerStats(targetid, stats_str, sizeof(stats_str));
    
    if(AS_Data[playerid][adspec_player_name] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_player_name]);
    }
    
    format(info_str, sizeof(info_str), "[%d] %s", targetid, name);
    AS_Data[playerid][adspec_player_name] = CreatePlayerTextDraw(playerid, 320.000000, 180.000000, info_str);
    PlayerTextDrawLetterSize(playerid, AS_Data[playerid][adspec_player_name], 0.200000, 1.000000);
    PlayerTextDrawAlignment(playerid, AS_Data[playerid][adspec_player_name], 2);
    PlayerTextDrawColor(playerid, AS_Data[playerid][adspec_player_name], -1);
    PlayerTextDrawSetShadow(playerid, AS_Data[playerid][adspec_player_name], 0);
    PlayerTextDrawSetOutline(playerid, AS_Data[playerid][adspec_player_name], 0);
    PlayerTextDrawBackgroundColor(playerid, AS_Data[playerid][adspec_player_name], 255);
    PlayerTextDrawFont(playerid, AS_Data[playerid][adspec_player_name], 1);
    PlayerTextDrawSetProportional(playerid, AS_Data[playerid][adspec_player_name], 1);
    PlayerTextDrawShow(playerid, AS_Data[playerid][adspec_player_name]);
    
    if(AS_Data[playerid][adspec_stats] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, AS_Data[playerid][adspec_stats]);
    }
    
    AS_Data[playerid][adspec_stats] = CreatePlayerTextDraw(playerid, 450.000000, 210.000000, stats_str);
    PlayerTextDrawLetterSize(playerid, AS_Data[playerid][adspec_stats], 0.180000, 1.000000);
    PlayerTextDrawAlignment(playerid, AS_Data[playerid][adspec_stats], 1);
    PlayerTextDrawColor(playerid, AS_Data[playerid][adspec_stats], -1);
    PlayerTextDrawSetShadow(playerid, AS_Data[playerid][adspec_stats], 0);
    PlayerTextDrawSetOutline(playerid, AS_Data[playerid][adspec_stats], 0);
    PlayerTextDrawBackgroundColor(playerid, AS_Data[playerid][adspec_stats], 255);
    PlayerTextDrawFont(playerid, AS_Data[playerid][adspec_stats], 1);
    PlayerTextDrawSetProportional(playerid, AS_Data[playerid][adspec_stats], 1);
    PlayerTextDrawShow(playerid, AS_Data[playerid][adspec_stats]);
    
    return 1;
}

static AS_GetPlayerStats(playerid, stats_str[], size = sizeof(stats_str))
{
    new ping = GetPlayerPing(playerid);
    new loss = NetStats_PacketLossPercent(playerid);
    new Float:health, Float:armor;
    GetPlayerHealth(playerid, health);
    GetPlayerArmour(playerid, armor);
    new money = GetPlayerMoney(playerid);
    new level = GetPlayerScore(playerid);
    
    format(stats_str, size,
        "Ping: %d\nLoss: %d\nSpeed: 2\nHealth: %.1f\nArmor: %.1f\nMoney: %d\nLevel: %d\n\nStatistics\n\nREP: 0",
        ping, loss, health, armor, money, level);
    
    return 1;
}

// ===================================================
// SPECTATE CONTROL
// ===================================================

static AS_StartSpectate(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "Player not found");
        return 0;
    }
    
    if(AS_Data[playerid][adspec_active]) {
        SendClientMessage(playerid, 0xFF0000AA, "Already spectating! Use /aspoff");
        return 0;
    }
    
    AS_Data[playerid][adspec_active] = true;
    AS_Data[playerid][adspec_target] = targetid;
    
    if(AS_Data[playerid][adspec_bg] == PlayerText:INVALID_TEXT_DRAW) {
        AS_CreateUI(playerid);
    }
    
    TogglePlayerSpectating(playerid, true);
    PlayerSpectatePlayer(playerid, targetid);
    AS_ShowUI(playerid, targetid);
    
    AS_Data[playerid][adspec_timer] = SetTimerEx("AS_UpdateTimer", 2000, true, "i", playerid);
    
    new name[24], msg[128];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "Spectating [%d] %s", targetid, name);
    SendClientMessage(playerid, 0x00FF00AA, msg);
    
    return 1;
}

static AS_StopSpectate(playerid)
{
    if(!AS_Data[playerid][adspec_active]) {
        SendClientMessage(playerid, 0xFF0000AA, "Not in spectate mode!");
        return 0;
    }
    
    AS_Data[playerid][adspec_active] = false;
    TogglePlayerSpectating(playerid, false);
    AS_HideUI(playerid);
    
    if(AS_Data[playerid][adspec_timer] != 0) {
        KillTimer(AS_Data[playerid][adspec_timer]);
        AS_Data[playerid][adspec_timer] = 0;
    }
    
    AS_Data[playerid][adspec_target] = INVALID_PLAYER_ID;
    SendClientMessage(playerid, 0x00FF00AA, "Spectate mode ended");
    return 1;
}

// ===================================================
// ACTION HANDLERS
// ===================================================

static AS_ShowMuteMenu(playerid)
{
    ShowPlayerDialog(playerid, ADSPEC_DIALOG_START + 1, DIALOG_STYLE_INPUT, 
        "Mute Player", "Enter minutes and reason:\nExample: 60 Cheating", "Mute", "Back");
}

static AS_ShowJailMenu(playerid)
{
    ShowPlayerDialog(playerid, ADSPEC_DIALOG_START + 2, DIALOG_STYLE_INPUT, 
        "Jail Player", "Enter minutes and reason:\nExample: 60 DM", "Jail", "Back");
}

static AS_ShowWarnMenu(playerid)
{
    ShowPlayerDialog(playerid, ADSPEC_DIALOG_START + 3, DIALOG_STYLE_INPUT, 
        "Warn Player", "Enter reason:\nExample: Rules violation", "Warn", "Back");
}

static AS_ShowSlapMenu(playerid)
{
    ShowPlayerDialog(playerid, ADSPEC_DIALOG_START + 4, DIALOG_STYLE_LIST, 
        "Slap Player", "Up\nDown", "Select", "Back");
}

static AS_ShowBanMenu(playerid)
{
    ShowPlayerDialog(playerid, ADSPEC_DIALOG_START + 5, DIALOG_STYLE_INPUT, 
        "Ban Player", "Enter minutes and reason:\nExample: 1440 Cheating", "Ban", "Back");
}

static AS_HandleAction(playerid, action)
{
    new targetid = AS_Data[playerid][adspec_target];
    
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, 0xFF0000AA, "Target disconnected!");
        AS_StopSpectate(playerid);
        return 0;
    }
    
    switch(action) {
        case 0: { // KICK
            new cmd[64];
            format(cmd, sizeof(cmd), "kick %d rejoin", targetid);
            SendClientMessage(playerid, 0x00FF00AA, "Player kicked!");
            SendClientMessage(playerid, 0xFFFFFFAA, cmd);
        }
        case 1: AS_ShowMuteMenu(playerid);
        case 2: AS_ShowJailMenu(playerid);
        case 3: AS_ShowWarnMenu(playerid);
        case 4: AS_ShowSlapMenu(playerid);
        case 5: AS_ShowBanMenu(playerid);
        case 6: AS_StopSpectate(playerid);
    }
    return 1;
}

static AS_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(!AS_Data[playerid][adspec_active]) return 0;
    
    new targetid = AS_Data[playerid][adspec_target];
    new cmd[128];
    
    switch(dialogid - ADSPEC_DIALOG_START) {
        case 1: { // MUTE
            if(response && strlen(inputtext) > 0) {
                format(cmd, sizeof(cmd), "mute %d %s", targetid, inputtext);
                SendClientMessage(playerid, 0x00FF00AA, "Player muted!");
                SendClientMessage(playerid, 0xFFFFFFAA, cmd);
            }
            AS_ShowUI(playerid, targetid);
        }
        case 2: { // JAIL
            if(response && strlen(inputtext) > 0) {
                format(cmd, sizeof(cmd), "jail %d %s", targetid, inputtext);
                SendClientMessage(playerid, 0x00FF00AA, "Player jailed!");
                SendClientMessage(playerid, 0xFFFFFFAA, cmd);
            }
            AS_ShowUI(playerid, targetid);
        }
        case 3: { // WARN
            if(response) {
                if(strlen(inputtext) > 0) {
                    format(cmd, sizeof(cmd), "warn %d %s", targetid, inputtext);
                } else {
                    format(cmd, sizeof(cmd), "warn %d", targetid);
                }
                SendClientMessage(playerid, 0x00FF00AA, "Player warned!");
                SendClientMessage(playerid, 0xFFFFFFAA, cmd);
            }
            AS_ShowUI(playerid, targetid);
        }
        case 4: { // SLAP
            if(response) {
                SetPVarInt(playerid, "as_slap_dir", listitem);
                ShowPlayerDialog(playerid, ADSPEC_DIALOG_START + 6, DIALOG_STYLE_INPUT, 
                    "Slap Reason", "Enter slap reason:", "Slap", "Back");
            } else {
                AS_ShowUI(playerid, targetid);
            }
        }
        case 5: { // BAN
            if(response && strlen(inputtext) > 0) {
                format(cmd, sizeof(cmd), "ban %d %s", targetid, inputtext);
                SendClientMessage(playerid, 0x00FF00AA, "Player banned!");
                SendClientMessage(playerid, 0xFFFFFFAA, cmd);
            }
            AS_ShowUI(playerid, targetid);
        }
        case 6: { // SLAP reason
            if(response && strlen(inputtext) > 0) {
                new dir = GetPVarInt(playerid, "as_slap_dir");
                format(cmd, sizeof(cmd), "slap %d %d %s", targetid, dir, inputtext);
                SendClientMessage(playerid, 0x00FF00AA, "Player slapped!");
                SendClientMessage(playerid, 0xFFFFFFAA, cmd);
                DeletePVar(playerid, "as_slap_dir");
            }
            AS_ShowUI(playerid, targetid);
        }
    }
    return 1;
}

// ===================================================
// PUBLIC INTERFACE
// ===================================================

forward AS_UpdateTimer(playerid);
public AS_UpdateTimer(playerid)
{
    if(AS_Data[playerid][adspec_active]) {
        new targetid = AS_Data[playerid][adspec_target];
        if(IsPlayerConnected(targetid)) {
            AS_UpdatePlayerInfo(playerid, targetid);
            if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {
                PlayerSpectatePlayer(playerid, targetid);
            }
        } else {
            SendClientMessage(playerid, 0xFF0000AA, "Target disconnected!");
            AS_StopSpectate(playerid);
        }
    }
}

// Call this in OnGameModeInit
stock AdminSpectate_Init()
{
    return AS_SystemInit();
}

// Call this in OnPlayerConnect
stock AdminSpectate_OnPlayerConnect(playerid)
{
    AS_Data[playerid][adspec_active] = false;
    AS_Data[playerid][adspec_target] = INVALID_PLAYER_ID;
    AS_Data[playerid][adspec_timer] = 0;
    return 1;
}

// Call this in OnPlayerDisconnect
stock AdminSpectate_OnPlayerDisconnect(playerid, reason)
{
    if(AS_Data[playerid][adspec_active]) {
        AS_StopSpectate(playerid);
    }
    AS_DestroyUI(playerid);
    return 1;
}

// Call this in OnDialogResponse
stock AdminSpectate_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid >= ADSPEC_DIALOG_START && dialogid <= ADSPEC_DIALOG_START + 10) {
        return AS_HandleDialog(playerid, dialogid, response, listitem, inputtext);
    }
    return 0;
}

// Call this in OnPlayerClickPlayerTextDraw
stock AdminSpectate_OnPlayerClickPTD(playerid, PlayerText:playertextid)
{
    if(!AS_Data[playerid][adspec_active]) return 0;
    
    for(new i = 0; i < 7; i++) {
        if(playertextid == AS_Data[playerid][adspec_btns][i]) {
            AS_HandleAction(playerid, i);
            return 1;
        }
    }
    return 0;
}

// Command functions - call these from your OnPlayerCommandText
stock AdminSpectate_ASP(playerid, targetid)
{
    if(!IsPlayerAdmin(playerid)) {
        SendClientMessage(playerid, 0xFF0000AA, "Admin access required!");
        return 0;
    }
    
    return AS_StartSpectate(playerid, targetid);
}

stock AdminSpectate_ASPOFF(playerid)
{
    return AS_StopSpectate(playerid);
}