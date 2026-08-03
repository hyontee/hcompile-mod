#include <a_samp>

new PlayerText:gCaseBg[MAX_PLAYERS];
new PlayerText:gCaseIcon[MAX_PLAYERS];
new PlayerText:gCaseDot[MAX_PLAYERS];

stock ShowCaseIconTD(playerid)
{
    // Фон кнопки
    gCaseBg[playerid] = CreatePlayerTextDraw(playerid, 548.0, 184.0, "_");
    PlayerTextDrawLetterSize(playerid, gCaseBg[playerid], 0.000000, 3.200000);
    PlayerTextDrawTextSize(playerid, gCaseBg[playerid], 592.0, 0.0);
    PlayerTextDrawAlignment(playerid, gCaseBg[playerid], 1);
    PlayerTextDrawColor(playerid, gCaseBg[playerid], 0xFFFFFFFF);
    PlayerTextDrawUseBox(playerid, gCaseBg[playerid], 1);
    PlayerTextDrawBoxColor(playerid, gCaseBg[playerid], 0x2B2B2BDD);
    PlayerTextDrawFont(playerid, gCaseBg[playerid], 1);
    PlayerTextDrawSetShadow(playerid, gCaseBg[playerid], 0);
    PlayerTextDrawSetOutline(playerid, gCaseBg[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, gCaseBg[playerid], 0x00000000);
    PlayerTextDrawShow(playerid, gCaseBg[playerid]);

    // Иконка внутри
    gCaseIcon[playerid] = CreatePlayerTextDraw(playerid, 560.0, 194.0, "CASE");
    PlayerTextDrawLetterSize(playerid, gCaseIcon[playerid], 0.230000, 1.050000);
    PlayerTextDrawAlignment(playerid, gCaseIcon[playerid], 1);
    PlayerTextDrawColor(playerid, gCaseIcon[playerid], 0xFFFFFFFF);
    PlayerTextDrawFont(playerid, gCaseIcon[playerid], 2);
    PlayerTextDrawSetShadow(playerid, gCaseIcon[playerid], 0);
    PlayerTextDrawSetOutline(playerid, gCaseIcon[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, gCaseIcon[playerid], 0x000000FF);
    PlayerTextDrawShow(playerid, gCaseIcon[playerid]);

    // Красная точка уведомления
    gCaseDot[playerid] = CreatePlayerTextDraw(playerid, 585.0, 186.0, ".");
    PlayerTextDrawLetterSize(playerid, gCaseDot[playerid], 0.500000, 1.700000);
    PlayerTextDrawAlignment(playerid, gCaseDot[playerid], 1);
    PlayerTextDrawColor(playerid, gCaseDot[playerid], 0xE53935FF);
    PlayerTextDrawFont(playerid, gCaseDot[playerid], 1);
    PlayerTextDrawSetShadow(playerid, gCaseDot[playerid], 0);
    PlayerTextDrawSetOutline(playerid, gCaseDot[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, gCaseDot[playerid], 0x00000000);
    PlayerTextDrawShow(playerid, gCaseDot[playerid]);

    return 1;
}

stock HideCaseIconTD(playerid)
{
    if(gCaseBg[playerid]) PlayerTextDrawHide(playerid, gCaseBg[playerid]);
    if(gCaseIcon[playerid]) PlayerTextDrawHide(playerid, gCaseIcon[playerid]);
    if(gCaseDot[playerid]) PlayerTextDrawHide(playerid, gCaseDot[playerid]);

    if(gCaseBg[playerid]) PlayerTextDrawDestroy(playerid, gCaseBg[playerid]);
    if(gCaseIcon[playerid]) PlayerTextDrawDestroy(playerid, gCaseIcon[playerid]);
    if(gCaseDot[playerid]) PlayerTextDrawDestroy(playerid, gCaseDot[playerid]);

    gCaseBg[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gCaseIcon[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gCaseDot[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

forward ShowCaseIconDelay(playerid);

public OnFilterScriptInit()
{
    print("[caseicon_td] loaded");
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        gCaseBg[i] = PlayerText:INVALID_TEXT_DRAW;
        gCaseIcon[i] = PlayerText:INVALID_TEXT_DRAW;
        gCaseDot[i] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    SetTimerEx("ShowCaseIconDelay", 1500, false, "i", playerid);
    return 1;
}

public ShowCaseIconDelay(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    ShowCaseIconTD(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    HideCaseIconTD(playerid);
    return 1;
}
