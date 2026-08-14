// ==========================================
// СИСТЕМА ПЛАНШЕТА
// ==========================================

#if defined _tablet_included
    #endinput
#endif
#define _tablet_included

new Text:Tablet_BG;
new Text:Tablet_BTN_GPS;
new Text:Tablet_BTN_PLAYERS;
new Text:Tablet_BTN_BIZ;
new Text:Tablet_BTN_SETTINGS;
new bool:TabletOpened[MAX_PLAYERS];

stock CreateTabletTextDraws()
{
    Tablet_BG = TextDrawCreate(150.0, 100.0, "_");
    TextDrawFont(Tablet_BG, 1);
    TextDrawLetterSize(Tablet_BG, 0.0, 3.0);
    TextDrawTextSize(Tablet_BG, 450.0, 320.0);
    TextDrawUseBox(Tablet_BG, 1);
    TextDrawBoxColor(Tablet_BG, 0x000000AA);
    TextDrawAlignment(Tablet_BG, 1);

    Tablet_BTN_GPS = TextDrawCreate(170.0, 140.0, "GPS");
    TextDrawFont(Tablet_BTN_GPS, 2);
    TextDrawLetterSize(Tablet_BTN_GPS, 0.3, 1.4);
    TextDrawColor(Tablet_BTN_GPS, 0xFFFFFFFF);
    TextDrawSetSelectable(Tablet_BTN_GPS, true);
    TextDrawAlignment(Tablet_BTN_GPS, 1);

    Tablet_BTN_PLAYERS = TextDrawCreate(170.0, 180.0, "Игроки");
    TextDrawFont(Tablet_BTN_PLAYERS, 2);
    TextDrawLetterSize(Tablet_BTN_PLAYERS, 0.3, 1.4);
    TextDrawColor(Tablet_BTN_PLAYERS, 0xFFFFFFFF);
    TextDrawSetSelectable(Tablet_BTN_PLAYERS, true);
    TextDrawAlignment(Tablet_BTN_PLAYERS, 1);

    Tablet_BTN_BIZ = TextDrawCreate(170.0, 220.0, "Бизнес");
    TextDrawFont(Tablet_BTN_BIZ, 2);
    TextDrawLetterSize(Tablet_BTN_BIZ, 0.3, 1.4);
    TextDrawColor(Tablet_BTN_BIZ, 0xFFFFFFFF);
    TextDrawSetSelectable(Tablet_BTN_BIZ, true);
    TextDrawAlignment(Tablet_BTN_BIZ, 1);

    Tablet_BTN_SETTINGS = TextDrawCreate(170.0, 260.0, "Настройки");
    TextDrawFont(Tablet_BTN_SETTINGS, 2);
    TextDrawLetterSize(Tablet_BTN_SETTINGS, 0.3, 1.4);
    TextDrawColor(Tablet_BTN_SETTINGS, 0xFFFFFFFF);
    TextDrawSetSelectable(Tablet_BTN_SETTINGS, true);
    TextDrawAlignment(Tablet_BTN_SETTINGS, 1);
    return 1;
}

stock ShowTablet(playerid)
{
    TabletOpened[playerid] = true;
    TextDrawShowForPlayer(playerid, Tablet_BG);
    TextDrawShowForPlayer(playerid, Tablet_BTN_GPS);
    TextDrawShowForPlayer(playerid, Tablet_BTN_PLAYERS);
    TextDrawShowForPlayer(playerid, Tablet_BTN_BIZ);
    TextDrawShowForPlayer(playerid, Tablet_BTN_SETTINGS);
    SelectTextDraw(playerid, 0xFFFFFFAA);
    return 1;
}

stock HideTablet(playerid)
{
    TabletOpened[playerid] = false;
    CancelSelectTextDraw(playerid);
    TextDrawHideForPlayer(playerid, Tablet_BG);
    TextDrawHideForPlayer(playerid, Tablet_BTN_GPS);
    TextDrawHideForPlayer(playerid, Tablet_BTN_PLAYERS);
    TextDrawHideForPlayer(playerid, Tablet_BTN_BIZ);
    TextDrawHideForPlayer(playerid, Tablet_BTN_SETTINGS);
    return 1;
}

CMD:tabletgui(playerid)
{
    if(!TabletOpened[playerid]) ShowTablet(playerid);
    else HideTablet(playerid);
    return 1;
}

// Функция для вызова из основного OnPlayerClickTextDraw
stock Tablet_OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(!TabletOpened[playerid]) return 0;
    
    if(clickedid == Tablet_BTN_GPS)
    {
        HideTablet(playerid);
        ShowPlayerDialog(playerid, 5000, DIALOG_STYLE_LIST,
            "GPS Навигация",
            "Авторынок\nРаботы\nНачальные работы\nВокзалы\nБлижайшие места\nБанк\nГос. организации\nВажные места",
            "Выбрать", "Закрыть");
        return 1;
    }
    else if(clickedid == Tablet_BTN_PLAYERS)
    {
        HideTablet(playerid);
        new list[1024] = "Игроки онлайн:\n";
        new count = 0;
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                count++;
                new name[MAX_PLAYER_NAME];
                GetPlayerName(i, name, MAX_PLAYER_NAME);
                format(list, sizeof(list), "%s%s\n", list, name);
            }
        }
        new header[64];
        format(header, sizeof(header), "Игроки онлайн (%d)", count);
        ShowPlayerDialog(playerid, 5001, DIALOG_STYLE_MSGBOX, header, list, "ОК", "");
        return 1;
    }
    else if(clickedid == Tablet_BTN_BIZ)
    {
        HideTablet(playerid);
        ShowPlayerDialog(playerid, 5002, DIALOG_STYLE_MSGBOX,
            "Бизнесы",
            "Раздел в разработке.",
            "ОК", "");
        return 1;
    }
    else if(clickedid == Tablet_BTN_SETTINGS)
    {
        HideTablet(playerid);
        ShowPlayerDialog(playerid, 5003, DIALOG_STYLE_MSGBOX,
            "Настройки",
            "Раздел в разработке.",
            "ОК", "");
        return 1;
    }
    return 0;
}

stock Tablet_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 5000 && response)
    {
        switch(listitem)
        {
            case 0: SetPlayerPos(playerid, 1145.2, -1720.3, 13.4);
            case 1: SetPlayerPos(playerid, 55.2, -83.3, 1.9);
            case 2: SetPlayerPos(playerid, 1740.5, -1862.1, 13.5);
            case 3: SetPlayerPos(playerid, 1400.4, -1720.3, 13.2);
            case 4: SetPlayerPos(playerid, 1250.0, -1450.0, 13.2);
            case 5: SetPlayerPos(playerid, 1470.1, -1300.2, 13.2);
            case 6: SetPlayerPos(playerid, 1550.1, -1670.5, 13.5);
            case 7: SetPlayerPos(playerid, 1600.3, -1800.2, 13.5);
        }
        SendClientMessage(playerid, -1, "{33aa33}✔ Телепортация выполнена.");
        return 1;
    }
    return 0;
}