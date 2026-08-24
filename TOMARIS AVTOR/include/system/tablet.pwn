//======================================================================
// Планшет система (Tablet) by Kovalchuk and Nikso
//======================================================================

#if defined _tablet_included
    #endinput
#endif
#define _tablet_included

//======================================================================
// Константы диалогов
//======================================================================
#define DIALOG_TABLET_GPS        5500
#define DIALOG_TABLET_PLAYERS    5501
#define DIALOG_TABLET_BIZ        5502
#define DIALOG_TABLET_SETTINGS   5503

//======================================================================
// Переменные
//======================================================================
new PlayerText:Tablet_BG[MAX_PLAYERS];
new PlayerText:Tablet_BTN_GPS[MAX_PLAYERS];
new PlayerText:Tablet_BTN_PLAYERS[MAX_PLAYERS];
new PlayerText:Tablet_BTN_BIZ[MAX_PLAYERS];
new PlayerText:Tablet_BTN_SETTINGS[MAX_PLAYERS];
new bool:TabletOpened[MAX_PLAYERS];

//======================================================================
// Функции планшета
//======================================================================

// Показать планшет
stock ShowPlayerTablet(playerid)
{
    if(TabletOpened[playerid]) 
        return 1;
        
    TabletOpened[playerid] = true;

    Tablet_BG[playerid] = CreatePlayerTextDraw(playerid, 150.0, 100.0, " ");
    PlayerTextDrawFont(playerid, Tablet_BG[playerid], 1);
    PlayerTextDrawLetterSize(playerid, Tablet_BG[playerid], 0.6, 3.0);
    PlayerTextDrawTextSize(playerid, Tablet_BG[playerid], 450.0, 320.0);
    PlayerTextDrawUseBox(playerid, Tablet_BG[playerid], 1);
    PlayerTextDrawBoxColor(playerid, Tablet_BG[playerid], 0x000000AA);
    PlayerTextDrawShow(playerid, Tablet_BG[playerid]);

    Tablet_BTN_GPS[playerid] = CreatePlayerTextDraw(playerid, 170.0, 140.0, "GPS");
    PlayerTextDrawFont(playerid, Tablet_BTN_GPS[playerid], 2);
    PlayerTextDrawLetterSize(playerid, Tablet_BTN_GPS[playerid], 0.3, 1.4);
    PlayerTextDrawColor(playerid, Tablet_BTN_GPS[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, Tablet_BTN_GPS[playerid], true);
    PlayerTextDrawShow(playerid, Tablet_BTN_GPS[playerid]);

    Tablet_BTN_PLAYERS[playerid] = CreatePlayerTextDraw(playerid, 170.0, 180.0, "Игроки");
    PlayerTextDrawFont(playerid, Tablet_BTN_PLAYERS[playerid], 2);
    PlayerTextDrawLetterSize(playerid, Tablet_BTN_PLAYERS[playerid], 0.3, 1.4);
    PlayerTextDrawColor(playerid, Tablet_BTN_PLAYERS[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, Tablet_BTN_PLAYERS[playerid], true);
    PlayerTextDrawShow(playerid, Tablet_BTN_PLAYERS[playerid]);

    Tablet_BTN_BIZ[playerid] = CreatePlayerTextDraw(playerid, 170.0, 220.0, "Бизнес");
    PlayerTextDrawFont(playerid, Tablet_BTN_BIZ[playerid], 2);
    PlayerTextDrawLetterSize(playerid, Tablet_BTN_BIZ[playerid], 0.3, 1.4);
    PlayerTextDrawColor(playerid, Tablet_BTN_BIZ[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, Tablet_BTN_BIZ[playerid], true);
    PlayerTextDrawShow(playerid, Tablet_BTN_BIZ[playerid]);

    Tablet_BTN_SETTINGS[playerid] = CreatePlayerTextDraw(playerid, 170.0, 260.0, "Настройки");
    PlayerTextDrawFont(playerid, Tablet_BTN_SETTINGS[playerid], 2);
    PlayerTextDrawLetterSize(playerid, Tablet_BTN_SETTINGS[playerid], 0.3, 1.4);
    PlayerTextDrawColor(playerid, Tablet_BTN_SETTINGS[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, Tablet_BTN_SETTINGS[playerid], true);
    PlayerTextDrawShow(playerid, Tablet_BTN_SETTINGS[playerid]);

    SelectTextDraw(playerid, 0xFFFFFFAA);
    return 1;
}

// Скрыть планшет
stock HidePlayerTablet(playerid)
{
    if(!TabletOpened[playerid]) 
        return 1;
        
    TabletOpened[playerid] = false;
    CancelSelectTextDraw(playerid);

    PlayerTextDrawHide(playerid, Tablet_BG[playerid]);
    PlayerTextDrawDestroy(playerid, Tablet_BG[playerid]);
    
    PlayerTextDrawHide(playerid, Tablet_BTN_GPS[playerid]);
    PlayerTextDrawDestroy(playerid, Tablet_BTN_GPS[playerid]);
    
    PlayerTextDrawHide(playerid, Tablet_BTN_PLAYERS[playerid]);
    PlayerTextDrawDestroy(playerid, Tablet_BTN_PLAYERS[playerid]);
    
    PlayerTextDrawHide(playerid, Tablet_BTN_BIZ[playerid]);
    PlayerTextDrawDestroy(playerid, Tablet_BTN_BIZ[playerid]);
    
    PlayerTextDrawHide(playerid, Tablet_BTN_SETTINGS[playerid]);
    PlayerTextDrawDestroy(playerid, Tablet_BTN_SETTINGS[playerid]);
    return 1;
}

// Обработка GPS телепортации
stock ProcessTabletGPSCommand(playerid, listitem)
{
    switch(listitem)
    {
        case 0: SetPlayerPos(playerid, 1145.2, -1720.3, 13.4);   // авторынок
        case 1: SetPlayerPos(playerid, 55.2, -83.3, 1.9);        // работы
        case 2: SetPlayerPos(playerid, 1740.5, -1862.1, 13.5);   // начальные работы
        case 3: SetPlayerPos(playerid, 1400.4, -1720.3, 13.2);   // вокзалы
        case 4: SetPlayerPos(playerid, 1250.0, -1450.0, 13.2);   // ближайшие места
        case 5: SetPlayerPos(playerid, 1470.1, -1300.2, 13.2);   // Банк
        case 6: SetPlayerPos(playerid, 1550.1, -1670.5, 13.5);   // государственные организации
        case 7: SetPlayerPos(playerid, 1600.3, -1800.2, 13.5);   // важные места
    }
    SendClientMessage(playerid, -1, "✔ Телепортация выполнена.");
    return 1;
}

//======================================================================
// Функции для вызова из главного мода
//======================================================================

// Вызывайте из OnPlayerClickPlayerTD в главном моде
public OnPlayerClickTabletTD(playerid, PlayerText:td)
{
    if(td == Tablet_BTN_GPS[playerid])
    {
        HidePlayerTablet(playerid);
        ShowPlayerDialog(playerid, DIALOG_TABLET_GPS, DIALOG_STYLE_LIST,
        "GPS Навигация",
        "авторынок\nработы\nначальные работы\nвокзалы\nближайшие места\nБанк\nгосударственные организации\nважные места",
        "Выбрать", "Закрыть");
        return 1;
    }

    if(td == Tablet_BTN_PLAYERS[playerid])
    {
        HidePlayerTablet(playerid);
        ShowPlayerDialog(playerid, DIALOG_TABLET_PLAYERS, DIALOG_STYLE_MSGBOX,
        "Игроки онлайн",
        "Список будет позже.",
        "Ок", "");
        return 1;
    }

    if(td == Tablet_BTN_BIZ[playerid])
    {
        HidePlayerTablet(playerid);
        ShowPlayerDialog(playerid, DIALOG_TABLET_BIZ, DIALOG_STYLE_MSGBOX,
        "Бизнесы",
        "Раздел в разработке.",
        "Ок", "");
        return 1;
    }

    if(td == Tablet_BTN_SETTINGS[playerid])
    {
        HidePlayerTablet(playerid);
        ShowPlayerDialog(playerid, DIALOG_TABLET_SETTINGS, DIALOG_STYLE_MSGBOX,
        "Настройки",
        "Раздел в разработке.",
        "Ок", "");
        return 1;
    }
    return 0;
}

// Вызывайте из OnDialogResponse в главном моде
public OnTabletDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TABLET_GPS && response)
    {
        ProcessTabletGPSCommand(playerid, listitem);
        return 1;
    }
    return 0;
}

// Вызывайте из OnPlayerDisconnect в главном моде
public OnPlayerDisconnectTablet(playerid, reason)
{
    if(TabletOpened[playerid])
    {
        HidePlayerTablet(playerid);
    }
    return 1;
}

//======================================================================
// Команды
//======================================================================

CMD:tablet(playerid)
{
    if(!TabletOpened[playerid]) 
        ShowPlayerTablet(playerid);
    else 
        HidePlayerTablet(playerid);
    return 1;
}

CMD:tabletgui(playerid)
{
    if(!TabletOpened[playerid]) 
        ShowPlayerTablet(playerid);
    else 
        HidePlayerTablet(playerid);
    return 1;
}

//======================================================================
// Конец планшет системы
//======================================================================