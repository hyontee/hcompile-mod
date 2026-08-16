#include <a_samp>

#define COLOR_WHITE 0xFFFFFFFF

new Text:WorkkTextDraw;

public OnFilterScriptInit()
{
    WorkkTextDraw = TextDrawCreate(10.0, 440.0, "Claus-Games Build 1.1 - ");
    TextDrawFont(WorkkTextDraw, 1);
    TextDrawLetterSize(WorkkTextDraw, 0.2, 0.8);
    TextDrawColor(WorkkTextDraw, COLOR_WHITE);
    TextDrawSetOutline(WorkkTextDraw, 0);
    TextDrawSetProportional(WorkkTextDraw, 1);
    TextDrawAlignment(WorkkTextDraw, 1);
    TextDrawSetShadow(WorkkTextDraw, 0);
    TextDrawBackgroundColor(WorkkTextDraw, 0x00000000);
    
    return 1;
}

public OnFilterScriptExit()
{
    TextDrawDestroy(WorkkTextDraw);
    return 1;
}

public OnPlayerConnect(playerid)
{
    TextDrawShowForPlayer(playerid, WorkkTextDraw);
    SetTimerEx("UpdateWorkkText", 1000, true, "i", playerid);
    return 1;
}

forward UpdateWorkkText(playerid);
public UpdateWorkkText(playerid)
{
    if(!IsPlayerConnected(playerid)) return;
    
    new hour, minute, second;
    gettime(hour, minute, second);
    
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    new text[128];
    format(text, sizeof(text), "DIMA GAMES Build 0.0.12 Time - %02d:%02d:%02d - Player Name  (%d)%s", hour, minute, second, playerid, playerName);
    
    TextDrawSetString(WorkkTextDraw, text);
    TextDrawShowForPlayer(playerid, WorkkTextDraw);
}
