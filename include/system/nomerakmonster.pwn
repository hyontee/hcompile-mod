new Text:nz_TD[5];
new PlayerText:nz_PTD[MAX_PLAYERS][2];
new player_select_nz[MAX_PLAYERS][7]; //номер который в данный момент видит игрок
new nomera;

public OnPlayerConnect(playerid)
{
    TextDrawPlayerNomer(playerid);
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

    #if defined nz_OnPlayerConnect
        return nz_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect nz_OnPlayerConnect
#if defined nz_OnPlayerConnect
    forward nz_OnPlayerConnect(playerid);
#endif

public OnGameModeInit()
{
    TextDrawNomer();

    #if defined nz_OnGameModeInit
        return nz_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit nz_OnGameModeInit
#if defined nz_OnGameModeInit
    forward nz_OnGameModeInit();
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == nz_TD[1])
    {
        new fmt_text[100],
	    index;
	    new vehicleid = GetPlayerOwnableCar(playerid);

	    index = GetVehicleData(vehicleid, V_ACTION_ID);

        //index = GetVehicleData(vehicleid, V_ACTION_ID);
        format(g_ownable_car[index][OC_NUMBER], 7, player_select_nz[playerid]);
        SetVehicleRuNumberPlate(vehicleid, g_ownable_car[index][OC_NUMBER], "777");

	    //format(fmt_text, sizeof fmt_text, "Вы купили номера формата: {ffcd00}\"%s\" {66cc33}за 5000 руб", player_select_nz);
	    //SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	    GivePlayerMoneyEx(playerid, -5000, "Покупка номеров", true, true);
	    
		ShowNotification(playerid, 0, "Вы потратили 5000 рублей", 1, "", "");

	    mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET number='%s' WHERE id='%d' LIMIT 1", player_select_nz, GetOwnableCarData(index, OC_SQL_ID));
	    mysql_query(mysql, fmt_text, false);

        format(player_select_nz[playerid], 7, GenerateCarNumber());
    
        PlayerTextDrawSetString(playerid, nz_PTD[playerid][0], player_select_nz[playerid]);
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);
        printf("Игрок %d кликнул на TextDraw ID %d", playerid, _:clickedid);

    }
    if(clickedid == nz_TD[2])
    {
        format(player_select_nz[playerid], 7, GenerateCarNumber());

        GivePlayerMoneyEx(playerid, -2000, "Прокрутка н/з");

		ShowNotification(playerid, 0, "Вы потратили 2000 рублей", 1, "", "");

        PlayerTextDrawSetString(playerid, nz_PTD[playerid][0], player_select_nz[playerid]);
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);
        printf("Игрок %d кликнул на TextDraw ID %d", playerid, _:clickedid);
    }
    if(clickedid == nz_TD[3])
    {
        for(new t;t < sizeof nz_TD;t++)
        {
            TextDrawHideForPlayer(playerid, nz_TD[t]);
        }

        PlayerTextDrawHide(playerid, nz_PTD[playerid][0]);
        PlayerTextDrawHide(playerid, nz_PTD[playerid][1]);
        //SendClientMessage(playerid, -1, "[BUTTON] Выйти");
        CancelSelectTextDraw(playerid);
        printf("Игрок %d кликнул на TextDraw ID %d", playerid, _:clickedid);
        TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
        ShowHud(playerid);
    }
    #if defined nz_OnPlayerClickTextDraw
        return nz_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw nz_OnPlayerClickTextDraw
#if defined nz_OnPlayerClickTextDraw
    forward nz_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

CMD:nomera(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        for(new t;t < sizeof nz_TD;t++)
        {
            TextDrawShowForPlayer(playerid, nz_TD[t]);
        }
    
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);
        PlayerTextDrawShow(playerid, nz_PTD[playerid][1]);
    
        format(player_select_nz[playerid], 7, GenerateCarNumber());
    
        PlayerTextDrawSetString(playerid, nz_PTD[playerid][0], player_select_nz[playerid]);
        TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);
        SelectTextDraw(playerid, 0x00FF00FF);
        HideHud(playerid);
    }
    return 1;
}

stock TextDrawNomer()
{
    nz_TD[0] = TextDrawCreate(0.0000, -0.5555, "txd:menukmonster"); // пусто
    TextDrawTextSize(nz_TD[0], 652.0000, 449.0000);
    TextDrawAlignment(nz_TD[0], 1);
    TextDrawColor(nz_TD[0], -1);
    TextDrawBackgroundColor(nz_TD[0], 255);
    TextDrawFont(nz_TD[0], 4);
    TextDrawSetProportional(nz_TD[0], 0);
    TextDrawSetShadow(nz_TD[0], 0);

    nz_TD[1] = TextDrawCreate(295.0000, 363.7482, "txd:paykmonster"); // пусто
    TextDrawLetterSize(nz_TD[1], 3.0, 5.0);
    TextDrawTextSize(nz_TD[1], 96.0000, 53.0000);
    TextDrawAlignment(nz_TD[1], 1);
    TextDrawColor(nz_TD[1], -1);
    TextDrawBackgroundColor(nz_TD[1], 255);
    TextDrawFont(nz_TD[1], 4);
    TextDrawSetProportional(nz_TD[1], 0);
    TextDrawSetShadow(nz_TD[1], 0);
    TextDrawSetSelectable(nz_TD[1], true);

    nz_TD[2] = TextDrawCreate(410.0000, 363.7482, "txd:nextkmonster"); // пусто
    TextDrawLetterSize(nz_TD[2], 3.0, 5.0);
    TextDrawTextSize(nz_TD[2], 96.0000, 53.0000);
    TextDrawAlignment(nz_TD[2], 1);
    TextDrawColor(nz_TD[2], -1);
    TextDrawBackgroundColor(nz_TD[2], 255);
    TextDrawFont(nz_TD[2], 4);
    TextDrawSetProportional(nz_TD[2], 0);
    TextDrawSetShadow(nz_TD[2], 0);
    TextDrawSetSelectable(nz_TD[2], true);

    nz_TD[3] = TextDrawCreate(28.0000, 372.5925, "txd:exitkmonster"); // пусто
	TextDrawLetterSize(nz_TD[3], 3.0, 5.0);
    TextDrawTextSize(nz_TD[3], 94.0000, 60.0000);
    TextDrawAlignment(nz_TD[3], 1);
    TextDrawColor(nz_TD[3], -1);
    TextDrawBackgroundColor(nz_TD[3], 255);
    TextDrawFont(nz_TD[3], 4);
    TextDrawSetProportional(nz_TD[3], 0);
    TextDrawSetShadow(nz_TD[3], 0);
    TextDrawSetSelectable(nz_TD[3], true);
    
    nz_TD[4] = TextDrawCreate(532.3332, 130.0370, "777"); // номер
    TextDrawLetterSize(nz_TD[4], 1.0000, 5.9122);
    TextDrawTextSize(nz_TD[4], 0.0000, -40.0000);
    TextDrawAlignment(nz_TD[4], 2);
    TextDrawColor(nz_TD[4], 255);
    TextDrawBackgroundColor(nz_TD[4], 255);
    TextDrawFont(nz_TD[4], 1);
    TextDrawSetProportional(nz_TD[4], 1);
    TextDrawSetShadow(nz_TD[4], 0);
}

stock TextDrawPlayerNomer(playerid)
{
    nz_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 370.3332, 106.0370, "c065op"); // номер
    PlayerTextDrawLetterSize(playerid, nz_PTD[playerid][0], 1.8133, 11.9122);
    PlayerTextDrawTextSize(playerid, nz_PTD[playerid][0], 0.0000, -42.0000);
    PlayerTextDrawAlignment(playerid, nz_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, nz_PTD[playerid][0], 255);
    PlayerTextDrawBackgroundColor(playerid, nz_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, nz_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, nz_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, nz_PTD[playerid][0], 0);

}
