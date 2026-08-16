new Text:nz_TD[20];
new PlayerText:nz_PTD[MAX_PLAYERS][2];
new player_select_nz[MAX_PLAYERS][7]; //      

public SYS_NZ_WELSI_KUZIA_OnPlayerConnect(playerid)
{
    TextDrawPlayerNomer(playerid);

    #if defined nz_OnPlayerConnect
        return nz_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_NZ_WELSI_KUZIA_OnPlayerConnect
    #undef SYS_NZ_WELSI_KUZIA_OnPlayerConnect
#else
    #define _ALS_SYS_NZ_WELSI_KUZIA_OnPlayerConnect
#endif
#define SYS_NZ_WELSI_KUZIA_OnPlayerConnect nz_OnPlayerConnect
#if defined nz_OnPlayerConnect
    forward nz_OnPlayerConnect(playerid);
#endif

public SYS_NZ_WELSI_KUZIA_OnGameModeInit()
{
    TextDrawNomer();

    #if defined nz_OnGameModeInit
        return nz_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_SYS_NZ_WELSI_KUZIA_OnGameModeInit
    #undef SYS_NZ_WELSI_KUZIA_OnGameModeInit
#else
    #define _ALS_SYS_NZ_WELSI_KUZIA_OnGameModeInit
#endif
#define SYS_NZ_WELSI_KUZIA_OnGameModeInit nz_OnGameModeInit
#if defined nz_OnGameModeInit
    forward nz_OnGameModeInit();
#endif

stock TextDrawNomer()
{
    nz_TD[0] = TextDrawCreate(0.0000, -0.5555, "txd:backnomer_nz"); // 
    TextDrawTextSize(nz_TD[0], 652.0000, 449.0000);
    TextDrawAlignment(nz_TD[0], 1);
    TextDrawColor(nz_TD[0], -1);
    TextDrawBackgroundColor(nz_TD[0], 255);
    TextDrawFont(nz_TD[0], 4);
    TextDrawSetProportional(nz_TD[0], 0);
    TextDrawSetShadow(nz_TD[0], 0);
    nz_TD[18] = TextDrawCreate(599.9998, 2.0888, "welsi_&_kuzia"); // 

    nz_TD[1] = TextDrawCreate(165.0000, 360.7482, "txd:buy_nz"); // 
    TextDrawTextSize(nz_TD[1], 94.0000, 47.0000);
    TextDrawAlignment(nz_TD[1], 1);
    TextDrawColor(nz_TD[1], -1);
    TextDrawBackgroundColor(nz_TD[1], 255);
    TextDrawFont(nz_TD[1], 4);
    TextDrawSetProportional(nz_TD[1], 0);
    TextDrawSetShadow(nz_TD[1], 0);
    TextDrawSetSelectable(nz_TD[1], 1);

    nz_TD[2] = TextDrawCreate(124.9999, 48.9629, "_"); // 
    TextDrawLetterSize(nz_TD[2], 0.0323, 13.7333);
    TextDrawTextSize(nz_TD[2], 479.0000, 0.0000);
    TextDrawAlignment(nz_TD[2], 1);
    TextDrawColor(nz_TD[2], -1);
    TextDrawUseBox(nz_TD[2], 1);
    TextDrawBoxColor(nz_TD[2], -1);
    TextDrawBackgroundColor(nz_TD[2], 255);
    TextDrawFont(nz_TD[2], 1);
    TextDrawSetProportional(nz_TD[2], 1);
    TextDrawSetShadow(nz_TD[2], 0);

    nz_TD[3] = TextDrawCreate(393.0000, 48.5481, "_"); // 
    TextDrawLetterSize(nz_TD[3], -0.0200, 13.7608);
    TextDrawTextSize(nz_TD[3], 382.0000, 0.0000);
    TextDrawAlignment(nz_TD[3], 1);
    TextDrawColor(nz_TD[3], -1);
    TextDrawUseBox(nz_TD[3], 1);
    TextDrawBoxColor(nz_TD[3], 255);
    TextDrawBackgroundColor(nz_TD[3], 255);
    TextDrawFont(nz_TD[3], 1);
    TextDrawSetProportional(nz_TD[3], 1);
    TextDrawSetShadow(nz_TD[3], 0);

    nz_TD[4] = TextDrawCreate(349.0000, 360.0000, "txd:povtor_nz"); // 
    TextDrawTextSize(nz_TD[4], 94.0000, 48.0000);
    TextDrawAlignment(nz_TD[4], 1);
    TextDrawColor(nz_TD[4], -1);
    TextDrawBackgroundColor(nz_TD[4], 255);
    TextDrawFont(nz_TD[4], 4);
    TextDrawSetProportional(nz_TD[4], 0);
    TextDrawSetShadow(nz_TD[4], 0);
    TextDrawSetSelectable(nz_TD[4], 1);

    nz_TD[5] = TextDrawCreate(271.0000, 395.5925, "txd:exit_nz"); // 
    TextDrawTextSize(nz_TD[5], 76.0000, 44.0000);
    TextDrawAlignment(nz_TD[5], 1);
    TextDrawColor(nz_TD[5], -1);
    TextDrawBackgroundColor(nz_TD[5], 255);
    TextDrawFont(nz_TD[5], 4);
    TextDrawSetProportional(nz_TD[5], 0);
    TextDrawSetShadow(nz_TD[5], 0);
    TextDrawSetSelectable(nz_TD[5], 1);

    nz_TD[6] = TextDrawCreate(185.3333, 10.3851, "PECPA_OC._HAKA_AOMO"); // 
    TextDrawLetterSize(nz_TD[6], 0.4000, 1.6000);
    TextDrawAlignment(nz_TD[6], 1);
    TextDrawColor(nz_TD[6], -1);
    TextDrawBackgroundColor(nz_TD[6], 255);
    TextDrawFont(nz_TD[6], 1);
    TextDrawSetProportional(nz_TD[6], 1);
    TextDrawSetShadow(nz_TD[6], 0);

    nz_TD[7] = TextDrawCreate(143.6666, 302.0001, "Cooc_oepx_ako:"); // 
    TextDrawLetterSize(nz_TD[7], 0.2983, 1.4755);
    TextDrawAlignment(nz_TD[7], 1);
    TextDrawColor(nz_TD[7], -1);
    TextDrawBackgroundColor(nz_TD[7], 255);
    TextDrawFont(nz_TD[7], 1);
    TextDrawSetProportional(nz_TD[7], 1);
    TextDrawSetShadow(nz_TD[7], 0);

    nz_TD[8] = TextDrawCreate(143.9999, 326.4740, "Cooc_ee_oepx_ako:"); // 
    TextDrawLetterSize(nz_TD[8], 0.2660, 1.6456);
    TextDrawAlignment(nz_TD[8], 1);
    TextDrawColor(nz_TD[8], -1);
    TextDrawBackgroundColor(nz_TD[8], 255);
    TextDrawFont(nz_TD[8], 1);
    TextDrawSetProportional(nz_TD[8], 1);
    TextDrawSetShadow(nz_TD[8], 0);

    nz_TD[9] = TextDrawCreate(402.0000, 326.8887, "2000"); // 
    TextDrawLetterSize(nz_TD[9], 0.2680, 1.6041);
    TextDrawAlignment(nz_TD[9], 2);
    TextDrawColor(nz_TD[9], -1);
    TextDrawBackgroundColor(nz_TD[9], 255);
    TextDrawFont(nz_TD[9], 1);
    TextDrawSetProportional(nz_TD[9], 1);
    TextDrawSetShadow(nz_TD[9], 0);

    nz_TD[10] = TextDrawCreate(206.3332, 179.2147, "pa_oep_ye_ocae_a_a_pacop"); // 
    TextDrawLetterSize(nz_TD[10], 0.2516, 1.0524);
    TextDrawTextSize(nz_TD[10], -3.0000, 0.0000);
    TextDrawAlignment(nz_TD[10], 1);
    TextDrawColor(nz_TD[10], -1);
    TextDrawBackgroundColor(nz_TD[10], 255);
    TextDrawFont(nz_TD[10], 1);
    TextDrawSetProportional(nz_TD[10], 1);
    TextDrawSetShadow(nz_TD[10], 0);

    nz_TD[11] = TextDrawCreate(124.6666, 48.1333, "_"); // 
    TextDrawLetterSize(nz_TD[11], 0.0000, 0.7833);
    TextDrawTextSize(nz_TD[11], 479.0000, 0.0000);
    TextDrawAlignment(nz_TD[11], 1);
    TextDrawColor(nz_TD[11], -1);
    TextDrawUseBox(nz_TD[11], 1);
    TextDrawBoxColor(nz_TD[11], 255);
    TextDrawBackgroundColor(nz_TD[11], 255);
    TextDrawFont(nz_TD[11], 1);
    TextDrawSetProportional(nz_TD[11], 1);
    TextDrawSetShadow(nz_TD[11], 0);

    nz_TD[12] = TextDrawCreate(124.3333, 165.1110, "_"); // 
    TextDrawLetterSize(nz_TD[12], 0.0000, 1.0499);
    TextDrawTextSize(nz_TD[12], 479.0000, 0.0000);
    TextDrawAlignment(nz_TD[12], 1);
    TextDrawColor(nz_TD[12], -1);
    TextDrawUseBox(nz_TD[12], 1);
    TextDrawBoxColor(nz_TD[12], 255);
    TextDrawBackgroundColor(nz_TD[12], 255);
    TextDrawFont(nz_TD[12], 1);
    TextDrawSetProportional(nz_TD[12], 1);
    TextDrawSetShadow(nz_TD[12], 0);

    nz_TD[13] = TextDrawCreate(124.3333, 53.1110, "_"); // 
    TextDrawLetterSize(nz_TD[13], -0.5343, 12.2243);
    TextDrawTextSize(nz_TD[13], 131.0000, 0.0000);
    TextDrawAlignment(nz_TD[13], 1);
    TextDrawColor(nz_TD[13], -1);
    TextDrawUseBox(nz_TD[13], 1);
    TextDrawBoxColor(nz_TD[13], 255);
    TextDrawBackgroundColor(nz_TD[13], 255);
    TextDrawFont(nz_TD[13], 1);
    TextDrawSetProportional(nz_TD[13], 1);
    TextDrawSetShadow(nz_TD[13], 0);

    nz_TD[14] = TextDrawCreate(472.6666, 52.2814, "_"); // 
    TextDrawLetterSize(nz_TD[14], -0.5343, 12.2243);
    TextDrawTextSize(nz_TD[14], 479.0000, 0.0000);
    TextDrawAlignment(nz_TD[14], 1);
    TextDrawColor(nz_TD[14], -1);
    TextDrawUseBox(nz_TD[14], 1);
    TextDrawBoxColor(nz_TD[14], 255);
    TextDrawBackgroundColor(nz_TD[14], 255);
    TextDrawFont(nz_TD[14], 1);
    TextDrawSetProportional(nz_TD[14], 1);
    TextDrawSetShadow(nz_TD[14], 0);
    nz_TD[15] = TextDrawCreate(446.6665, 143.9555, "_"); // 
    TextDrawLetterSize(nz_TD[15], -0.0833, 0.6625);
    TextDrawTextSize(nz_TD[15], 469.0000, 0.0000);
    TextDrawAlignment(nz_TD[15], 1);
    TextDrawColor(nz_TD[15], 65535);
    TextDrawUseBox(nz_TD[15], 1);
    TextDrawBoxColor(nz_TD[15], 41215);
    TextDrawBackgroundColor(nz_TD[15], 255);
    TextDrawFont(nz_TD[15], 1);
    TextDrawSetProportional(nz_TD[15], 1);
    TextDrawSetShadow(nz_TD[15], 0);

    nz_TD[16] = TextDrawCreate(446.6667, 153.0814, "_"); // 
    TextDrawLetterSize(nz_TD[16], -0.0533, 0.5837);
    TextDrawTextSize(nz_TD[16], 469.0000, 0.0000);
    TextDrawAlignment(nz_TD[16], 1);
    TextDrawColor(nz_TD[16], -1);
    TextDrawUseBox(nz_TD[16], 1);
    TextDrawBoxColor(nz_TD[16], -16776961);
    TextDrawBackgroundColor(nz_TD[16], 255);
    TextDrawFont(nz_TD[16], 1);
    TextDrawSetProportional(nz_TD[16], 1);
    TextDrawSetShadow(nz_TD[16], 0);

    nz_TD[17] = TextDrawCreate(399.0000, 136.4889, "RUS"); // 
    TextDrawLetterSize(nz_TD[17], 0.6383, 2.8734);
    TextDrawTextSize(nz_TD[17], 65.0000, 0.0000);
    TextDrawAlignment(nz_TD[17], 1);
    TextDrawColor(nz_TD[17], 255);
    TextDrawBackgroundColor(nz_TD[17], 255);
    TextDrawFont(nz_TD[17], 1);
    TextDrawSetProportional(nz_TD[17], 0);
    TextDrawSetShadow(nz_TD[17], 0);
    
    TextDrawLetterSize(nz_TD[18], 0.1480, 0.8740);
    TextDrawTextSize(nz_TD[18], -101.0000, 0.0000);
    TextDrawAlignment(nz_TD[18], 1);
    TextDrawColor(nz_TD[18], -81);
    TextDrawBackgroundColor(nz_TD[18], 255);
    TextDrawFont(nz_TD[18], 1);
    TextDrawSetProportional(nz_TD[18], 1);
    TextDrawSetShadow(nz_TD[18], 0);

    nz_TD[19] = TextDrawCreate(404.6666, 46.4740, "52"); // 
    TextDrawLetterSize(nz_TD[19], 1.4790, 8.9339);
    TextDrawTextSize(nz_TD[19], -18.0000, 0.0000);
    TextDrawAlignment(nz_TD[19], 1);
    TextDrawColor(nz_TD[19], 255);
    TextDrawBackgroundColor(nz_TD[19], 255);
    TextDrawFont(nz_TD[19], 1);
    TextDrawSetProportional(nz_TD[19], 1);
    TextDrawSetShadow(nz_TD[19], 0);
}




stock TextDrawPlayerNomer(playerid)
{
    nz_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 255.3332, 51.0370, "c065op"); // 
    PlayerTextDrawLetterSize(playerid, nz_PTD[playerid][0], 1.8133, 11.9122);
    PlayerTextDrawTextSize(playerid, nz_PTD[playerid][0], 0.0000, -42.0000);
    PlayerTextDrawAlignment(playerid, nz_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, nz_PTD[playerid][0], 255);
    PlayerTextDrawBackgroundColor(playerid, nz_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, nz_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, nz_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, nz_PTD[playerid][0], 0);

    nz_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 402.0000, 302.0000, "5000"); //   
    PlayerTextDrawLetterSize(playerid, nz_PTD[playerid][1], 0.2813, 1.5834);
    PlayerTextDrawAlignment(playerid, nz_PTD[playerid][1], 2);
    PlayerTextDrawColor(playerid, nz_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, nz_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, nz_PTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, nz_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, nz_PTD[playerid][1], 0);
}

public SYS_NZ_WELSI_KUZIA_OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == nz_TD[1])
    {
        new fmt_text[100],
	    index;
	    new vehicleid = GetPlayerOwnableCar(playerid);

	    index = GetVehicleData(vehicleid, V_ACTION_ID);

        //index = GetVehicleData(vehicleid, V_ACTION_ID);
        format(g_ownable_car[index][OC_NUMBER], 7, player_select_nz[playerid]);
        SetVehicleRuNumberPlate(vehicleid, g_ownable_car[index][OC_NUMBER], "17");

	    format(fmt_text, sizeof fmt_text, "   : {ffcd00}\"%s\" {66cc33} 5000 ", player_select_nz);
	    SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	    GivePlayerMoneyEx(playerid, -5000, " ", true, true);

	    mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET number='%s' WHERE id='%d' LIMIT 1", player_select_nz, GetOwnableCarData(index, OC_SQL_ID));
	    mysql_query(mysql, fmt_text, false);

        format(player_select_nz[playerid], 7, GenerateCarNumber());
    
        PlayerTextDrawSetString(playerid, nz_PTD[playerid][0], player_select_nz[playerid]);
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);

    }
    if(clickedid == nz_TD[4])
    {
        format(player_select_nz[playerid], 7, GenerateCarNumber());

        GivePlayerMoneyEx(playerid, -2000, " /");

        PlayerTextDrawSetString(playerid, nz_PTD[playerid][0], player_select_nz[playerid]);
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);
    }
    if(clickedid == nz_TD[5])
    {
        for(new t;t < sizeof nz_TD;t++)
        {
            TextDrawHideForPlayer(playerid, nz_TD[t]);
        }

        PlayerTextDrawHide(playerid, nz_PTD[playerid][0]);
        PlayerTextDrawHide(playerid, nz_PTD[playerid][1]);
        //SendClientMessage(playerid, -1, "[BUTTON] ");
        CancelSelectTextDraw(playerid);
    }
    #if defined nz_OnPlayerClickTextDraw
        return nz_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_NZ_WELSI_KUZIA_OnPlayerClickTextDraw
    #undef SYS_NZ_WELSI_KUZIA_OnPlayerClickTextDraw
#else
    #define _ALS_SYS_NZ_WELSI_KUZIA_OnPlayerClickTextDraw
#endif
#define SYS_NZ_WELSI_KUZIA_OnPlayerClickTextDraw nz_OnPlayerClickTextDraw
#if defined nz_OnPlayerClickTextDraw
    forward nz_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

CMD:buynumber(playerid)
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
        PlayerTextDrawShow(playerid, nz_PTD[playerid][0]);
        SelectTextDraw(playerid, 0x00FF00FF);
    }
    return 1;
}
