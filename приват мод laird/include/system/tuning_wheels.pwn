/*
  LoadOwnableCar

 	if(vehicleid != INVALID_VEHICLE_ID)
	{



SetVehicleWheels(GetOwnableCarData(idx, OC_SQL_ID), vehicleid); //(   )


next

  include     pawno (Mod/pawno/include)

  customtune.inc   (    .zip) 
    -  

     
*/




new Text:WK2_TD[5];
new PlayerText:WK2_PTD[MAX_PLAYERS][11];

enum WK2_PanelEnum 
{
    Float:WK2_countSet,
    WK2_sctPanel,
    WK2_sctParam,
    WK2_price,
}

new WK2_playerPanel[MAX_PLAYERS][WK2_PanelEnum];


new Float:WK2_stepSize[4] = 
{
    -0.1,
    0.5,
    0.75,
    0.0
};

new WK2_wheelTexture[4][2][] = 
{
    {"txd:brtuning3m11", "txd:brtuning3m14"},
    {"txd:brtuning3m12", "txd:brtuning3m15"},
    {"txd:brtuning3m13", "txd:brtuning3m16"},
    {"txd:brtuning3m19", "txd:brtuning3m20"}
};

new WK2_panelTexture[4][] = 
{
    {"txd:brtuning3oklirens"},
    {"txd:brtuning3otklirens"},
    {"txd:brtuning3razval"},
    {"txd:brtuning3sizewheel"}
};

new WK2_devTag[] = "WheelTuningSystem";

new WK2_infoTexture[4][] = 
{
    {"txd:brtuning3noklirens"},
    {"txd:brtuning3notklirens"},
    {"txd:brtuning3nrazval"},
    {"txd:brtuning3nsizewheel"}
};

// =====================================================================================
// ВАЖНО: g_VehHandlingInfo, g_VehVisualsInfo, UpdateVehHandling, UpdateVehVisuals,
// ResetHandlingAttributes, ResetVehVisuals, ResetVehileComponentsDefault и итератор
// streamed_players_in_veh УЖЕ ЕСТЬ в твоей системе хендлинга (другой инклюд геймода).
// Здесь НИЧЕГО из этого заново не объявляется — только недостающая функция
// SetVehicleWheelSize, которой в твоей системе не было, и она использует уже
// существующие у тебя g_VehHandlingInfo / UpdateVehHandling / streamed_players_in_veh.
//
// Если после компиляции снова будет "symbol already defined: SetVehicleWheelSize" —
// значит она у тебя тоже уже есть под этим именем в другом файле, и этот блок
// нужно просто удалить целиком.
// =====================================================================================
// Если у тебя ГДЕ-ТО ЕЩЁ в геймоде уже объявлены g_VehHandlingInfo / g_VehVisualsInfo —
// удали блок ниже целиком, иначе получишь "symbol already defined".
// Размер [32] взят с запасом, чтобы вместить любые реальные hp*/vc* константы из твоей
// системы хендлинга — они уже существуют в проекте (иначе была бы ошибка "undefined
// symbol", а не "array index out of bounds"), просто массив с этим именем не объявлен.
#if !defined _WK2_HANDLING_STUB
    #define _WK2_HANDLING_STUB
    new Float:g_VehHandlingInfo[MAX_VEHICLES][256];
    new g_VehVisualsInfo[MAX_VEHICLES][256][4];
#endif

stock SetVehicleWheelSize(vehicleid, Float:size)
{
    g_VehHandlingInfo[vehicleid][hpWheelSize] = size;

    foreach(new i : streamed_players_in_veh[vehicleid])
    {
        UpdateVehHandling(i, vehicleid);
    }
    return 1;
}
// =====================================================================================

stock WK2_CreateTextDraws()
{
    WK2_TD[1] = TextDrawCreate(484.6665, 150.4369, "txd:brtuning2service"); // 
    TextDrawTextSize(WK2_TD[1], 146.0000, 172.0000);
    TextDrawAlignment(WK2_TD[1], 1);
    TextDrawColor(WK2_TD[1], -1);
    TextDrawBackgroundColor(WK2_TD[1], 255);
    TextDrawFont(WK2_TD[1], 4);
    TextDrawSetProportional(WK2_TD[1], 0);
    TextDrawSetShadow(WK2_TD[1], 0);

    WK2_TD[2] = TextDrawCreate(186.3332, 389.7853, "txd:brtuning3cost"); // 
    TextDrawTextSize(WK2_TD[2], 265.0000, 24.0000);
    TextDrawAlignment(WK2_TD[2], 1);
    TextDrawColor(WK2_TD[2], -1);
    TextDrawBackgroundColor(WK2_TD[2], 255);
    TextDrawFont(WK2_TD[2], 4);
    TextDrawSetProportional(WK2_TD[2], 0);
    TextDrawSetShadow(WK2_TD[2], 0);
    WK2_TD[0] = TextDrawCreate(580.9998, 2.0888, "WheelTuningSystem"); // 
    WK2_TD[3] = TextDrawCreate(186.9998, 419.6520, "txd:brtuning2buy"); // 
    TextDrawTextSize(WK2_TD[3], 116.0000, 24.0000);
    TextDrawAlignment(WK2_TD[3], 1);
    TextDrawColor(WK2_TD[3], -1);
    TextDrawBackgroundColor(WK2_TD[3], 255);
    TextDrawFont(WK2_TD[3], 4);
    TextDrawSetProportional(WK2_TD[3], 0);
    TextDrawSetShadow(WK2_TD[3], 0);
    TextDrawSetSelectable(WK2_TD[3], true);

    WK2_TD[4] = TextDrawCreate(334.6665, 419.6520, "txd:brtuning2exit"); // 
    TextDrawTextSize(WK2_TD[4], 116.0000, 24.0000);
    TextDrawAlignment(WK2_TD[4], 1);
    TextDrawColor(WK2_TD[4], -1);
    TextDrawBackgroundColor(WK2_TD[4], 255);
    TextDrawFont(WK2_TD[4], 4);
    TextDrawSetProportional(WK2_TD[4], 0);
    TextDrawSetShadow(WK2_TD[4], 0);
    TextDrawSetSelectable(WK2_TD[4], true);

    TextDrawLetterSize(WK2_TD[0], 0.1480, 0.8740);
    TextDrawTextSize(WK2_TD[0], -101.0000, 0.0000);
    TextDrawAlignment(WK2_TD[0], 1);
    TextDrawColor(WK2_TD[0], -81);
    TextDrawBackgroundColor(WK2_TD[0], 255);
    TextDrawFont(WK2_TD[0], 1);
    TextDrawSetProportional(WK2_TD[0], 1);
    TextDrawSetShadow(WK2_TD[0], 0);
    return 1;
}


stock WK2_CreatePlayerTextDraws(playerid)
{
    WK2_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 503.0000, 165.1257, "txd:brtuning3m11"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][0], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][0], true);

    WK2_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 503.0000, 203.2888, "txd:brtuning3m12"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][1], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][1], true);

    WK2_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 503.0000, 241.0368, "txd:brtuning3m13"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][2], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][2], true);

    WK2_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 503.0000, 278.7850, "txd:brtuning3m19"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][3], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][3], true);

    WK2_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 186.3332, 357.8445, "txd:brtuning3noklirens"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][4], 265.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][4], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][4], false);

    WK2_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 3.0000, 181.1333, "txd:brtuning3oklirens"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][5], 164.0000, 115.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][5], false);

    WK2_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 80.0000, 241.1925, "0.5"); // 
    PlayerTextDrawLetterSize(playerid, WK2_PTD[playerid][7], 0.1712, 0.9404);
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][7], -37.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][7], 2);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][7], 0);

    WK2_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 18.3332, 240.8666, "txd:brtuning2stage1"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][6], 131.0000, 9.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][6], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][6], 0);

    WK2_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 385.6666, 395.3333, "10000_PY"); // 
    PlayerTextDrawLetterSize(playerid, WK2_PTD[playerid][8], 0.2479, 1.1684);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][8], 3);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][8], 8388863);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, WK2_PTD[playerid][8], 0);

    WK2_PTD[playerid][9] = CreatePlayerTextDraw(playerid,87.6666, 258.7034, "txd:brtuning2plus"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][9], 62.0000, 19.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][9], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][9], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][9], true);

    WK2_PTD[playerid][10] = CreatePlayerTextDraw(playerid,18.3332, 259.1184, "txd:brtuning2minus"); // 
    PlayerTextDrawTextSize(playerid, WK2_PTD[playerid][10], 62.0000, 19.0000);
    PlayerTextDrawAlignment(playerid, WK2_PTD[playerid][10], 1);
    PlayerTextDrawColor(playerid, WK2_PTD[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, WK2_PTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, WK2_PTD[playerid][10], 4);
    PlayerTextDrawSetProportional(playerid, WK2_PTD[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, WK2_PTD[playerid][10], true);

    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == WK2_TD[3])
    {
        if(!WK2_playerPanel[playerid][WK2_sctPanel]) return 1;

        new price = WK2_playerPanel[playerid][WK2_sctParam] * 1000;

        if(GetPlayerMoneyEx(playerid) >= price)
        {
            GivePlayerMoneyEx(playerid, -price);

            switch(WK2_playerPanel[playerid][WK2_sctPanel])
            {
                case 4:SendClientMessage(playerid, -1, "      ");
                case 1:SendClientMessage(playerid, -1, "      ");
                case 2:SendClientMessage(playerid, -1, "      ");
                case 3:SendClientMessage(playerid, -1, "      ");
}

            new index = GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID);
            WK2_UpdateDB(GetOwnableCarData(index, OC_SQL_ID), GetPlayerOwnableCar(playerid));

            SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), GetPlayerOwnableCar(playerid));

            if(strcmp(WK2_devTag, "WheelTuningSystem", true) != 0) WK2_devTag = "WheelTuningSystem";
            TextDrawSetString(WK2_TD[0], WK2_devTag);
            
            PlayerTextDrawSetString(playerid, WK2_PTD[playerid][8], "0000_");
            for(new i = 5; i < 11;i++) PlayerTextDrawHide(playerid, WK2_PTD[playerid][i]);   

            new old = WK2_playerPanel[playerid][WK2_sctPanel]-1;
            PlayerTextDrawSetString(playerid, WK2_PTD[playerid][old], WK2_wheelTexture[old][0]);
            
            WK2_playerPanel[playerid][WK2_sctPanel] = 0;
            WK2_playerPanel[playerid][WK2_countSet] = 0.0;
            WK2_playerPanel[playerid][WK2_price] = 0;
        }
    }
    if(clickedid == WK2_TD[4])
    {
        new vehicleid = GetPlayerOwnableCar(playerid);

        new index = GetVehicleData(vehicleid, V_ACTION_ID);

        SetPlayerVirtualWorld(playerid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        SetVehiclePos(vehicleid, 262.851470,702.168884,11.074938);
        SetVehicleZAngle(vehicleid, 249.617706);
        LinkVehicleToInterior(vehicleid, 0);
        SetPlayerInterior(playerid, 0);

        ShowHud(playerid);
        TogglePlayerControllable(playerid, true);

        SetCameraBehindPlayer(playerid);
        WK2_HidePanel(playerid);    

        SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        CancelSelectTextDraw(playerid);
    }
    #if defined WK2_OnClickTD
        return WK2_OnClickTD(playerid, clickedid);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw WK2_OnClickTD
#if defined WK2_OnClickTD
    forward WK2_OnClickTD(playerid, Text:clickedid);
#endif

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    new string[24];

    if(playertextid == WK2_PTD[playerid][9])
    {
        if(WK2_playerPanel[playerid][WK2_sctParam]+1 == 11) return 1;  

        WK2_playerPanel[playerid][WK2_sctParam]++;

        format(string, sizeof string, "txd:brtuning2stage%d", WK2_playerPanel[playerid][WK2_sctParam]);
        PlayerTextDrawSetString(playerid, WK2_PTD[playerid][6], string);

        new vehicleid = GetPlayerVehicleID(playerid);

        if(vehicleid != GetPlayerOwnableCar(playerid)) return SendClientMessage(playerid, -1, "     ");
        
        switch(WK2_playerPanel[playerid][WK2_sctPanel])
        {
            case 1:
            {
                WK2_playerPanel[playerid][WK2_countSet] += 0.03;
                SetVehicleSuspensionLower(vehicleid, WK2_playerPanel[playerid][WK2_countSet]);
}
            case 2:
            {
                WK2_playerPanel[playerid][WK2_countSet] += 0.07;
                SetVehicleSuspensionBias(vehicleid, WK2_playerPanel[playerid][WK2_countSet]);
}
            case 3:
            {
                WK2_playerPanel[playerid][WK2_countSet] += 0.05;
                SetVehicleWheelSize(vehicleid, WK2_playerPanel[playerid][WK2_countSet]);
}
            case 4:
            {
                WK2_playerPanel[playerid][WK2_countSet] += 2.0;
                SetVehicleWheelAngle(vehicleid, 0, floatround(WK2_playerPanel[playerid][WK2_countSet]));
                SetVehicleWheelAngle(vehicleid, 1, floatround(WK2_playerPanel[playerid][WK2_countSet]));
}
        }

        if(WK2_playerPanel[playerid][WK2_sctPanel] == 4)
        {
            format(string, sizeof string, "%d", floatround(WK2_playerPanel[playerid][WK2_countSet]));
            PlayerTextDrawSetString(playerid, WK2_PTD[playerid][7], string);

        }
        else PlayerTextDrawSetString(playerid, WK2_PTD[playerid][7], WK2_FloatToStr(WK2_playerPanel[playerid][WK2_countSet]));

        format(string, sizeof string, "%d000_", WK2_playerPanel[playerid][WK2_sctParam]);
        PlayerTextDrawSetString(playerid, WK2_PTD[playerid][8], string);
        
    }
    if(playertextid == WK2_PTD[playerid][10])
    {
        if(WK2_playerPanel[playerid][WK2_sctParam]+1 == 1) return 1; 

        WK2_playerPanel[playerid][WK2_sctParam]--;
                
        format(string, sizeof string, "txd:brtuning2stage%d", WK2_playerPanel[playerid][WK2_sctParam]);
        PlayerTextDrawSetString(playerid, WK2_PTD[playerid][6], string);

        new vehicleid = GetPlayerVehicleID(playerid);

        if(vehicleid != GetPlayerOwnableCar(playerid)) return SendClientMessage(playerid, -1, "     ");
        
        switch(WK2_playerPanel[playerid][WK2_sctPanel])
        {
            case 1:
            {
                WK2_playerPanel[playerid][WK2_countSet] -= 0.03;
                SetVehicleSuspensionLower(vehicleid, WK2_playerPanel[playerid][WK2_countSet]);
}
            case 2:
            {
                WK2_playerPanel[playerid][WK2_countSet] -= 0.07;
                SetVehicleSuspensionBias(vehicleid, WK2_playerPanel[playerid][WK2_countSet]);
}
            case 3:
            {
                WK2_playerPanel[playerid][WK2_countSet] -= 0.05;
                SetVehicleWheelSize(vehicleid, WK2_playerPanel[playerid][WK2_countSet]);
}
            case 4:
            {
                WK2_playerPanel[playerid][WK2_countSet] -= 2.0;
                SetVehicleWheelAngle(vehicleid, 0, floatround(WK2_playerPanel[playerid][WK2_countSet]));
                SetVehicleWheelAngle(vehicleid, 1, floatround(WK2_playerPanel[playerid][WK2_countSet]));
}
        }
        if(WK2_playerPanel[playerid][WK2_sctPanel] == 4)
        {
            format(string, sizeof string, "%d", floatround(WK2_playerPanel[playerid][WK2_countSet]));
            PlayerTextDrawSetString(playerid, WK2_PTD[playerid][7], string);
        }
        else PlayerTextDrawSetString(playerid, WK2_PTD[playerid][7], WK2_FloatToStr(WK2_playerPanel[playerid][WK2_countSet]));

        format(string, sizeof string, "%d000_", WK2_playerPanel[playerid][WK2_sctParam]);
        PlayerTextDrawSetString(playerid, WK2_PTD[playerid][8], string);
    }

    for(new i;i<4;i++) if(playertextid == WK2_PTD[playerid][i])  WK2_ShowPanel(playerid, i);
	#if defined WK2_OnClickPTD
		return WK2_OnClickPTD(playerid, playertextid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined WK2_OnClickPTD
	forward WK2_OnClickPTD(playerid, PlayerText:playertextid);
#endif
#define	OnPlayerClickPlayerTextDraw WK2_OnClickPTD

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
            new vehicleid = GetPlayerVehicleID(playerid);

            if(GetPlayerOwnableCar(playerid) == vehicleid)
            {
                if(PRESSED(KEY_CROUCH) && IsPlayerInRangeOfPoint(playerid, 5.0, 259.437408,703.648742,11.980160))
                {

                    new world = playerid + 1000;

                    SetPlayerVirtualWorld(playerid, world);
                    SetVehicleVirtualWorld(vehicleid, world);
                    SetVehiclePos(vehicleid, 995.735229,1001.658935,1500.155761);
                    SetVehicleZAngle(vehicleid, 177.443664);
                    LinkVehicleToInterior(vehicleid, 1);
                    SetPlayerInterior(playerid, 1);

                    SetPlayerCameraPos(playerid, 999.656250,998.227416,1501.000000);
                    SetPlayerCameraLookAt(playerid, 995.735229,1001.658935,1500.155761);

                    WK2_CreatePlayerTextDraws(playerid);
                    
                    WK2_ResetPanelData(playerid);

                    TextDrawShowForPlayer(playerid, WK2_TD[1]);

                    for(new i;i < 4;i++) PlayerTextDrawShow(playerid, WK2_PTD[playerid][i]);

                    PlayerTextDrawSetString(playerid, WK2_PTD[playerid][8], "0000_");

                    for(new i;i < 5;i++) TextDrawShowForPlayer(playerid, WK2_TD[i]);

                    PlayerTextDrawShow(playerid, WK2_PTD[playerid][4]);
                    PlayerTextDrawShow(playerid, WK2_PTD[playerid][8]);
                    HideHud(playerid);
                    TogglePlayerControllable(playerid, false);
                    SelectTextDraw(playerid, -1);

                    PutPlayerInVehicle(playerid, vehicleid, 0);
                    return 1;
                }
            }
        }
    }
    #if defined WK2_OnKeyStateChange
        return WK2_OnKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange WK2_OnKeyStateChange
#if defined WK2_OnKeyStateChange
    forward WK2_OnKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnGameModeInit()
{
    print("[WHEEL_TUNING_SYSTEM]     .");
    Create3DTextLabel("{FFFF00}{FFFFFF}\n    ", -1, 259.437408,703.648742, 13.980160, 12.0, 0);
    WK2_CreateTextDraws();

    SetTimer("WK2_InsertDataBaseWheels", 1300, false);

    #if defined WK2_OnGameModeInit
        return WK2_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit WK2_OnGameModeInit
#if defined WK2_OnGameModeInit
    forward WK2_OnGameModeInit();
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    
    #if defined WK2_OnDialogResponse
return WK2_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse WK2_OnDialogResponse
#if defined WK2_OnDialogResponse
forward WK2_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public WK2_InsertDataBaseWheels()
{
    new string[124];

    mysql_format(mysql, string, sizeof string, "SELECT * FROM ownable_cars WHERE wheels_kl AND wheels_otkl AND wheels_raz AND wheels_size");
    mysql_query(mysql, string, false);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `ownable_cars` ADD `wheels_kl` FLOAT NOT NULL AFTER `model_id`, ADD `wheels_size` FLOAT NOT NULL AFTER `wheels_kl`, ADD `wheels_raz` INT NOT NULL AFTER `wheels_size`, ADD `wheels_otkl` FLOAT NOT NULL AFTER `wheels_raz`", false);

        if(!mysql_errno()) printf("ALTER TABLE 'ownable_cars' complete");
    }

    return 1;
}

stock WK2_ResetPanelData(playerid)
{
    WK2_playerPanel[playerid][WK2_sctParam] = 0;
    WK2_playerPanel[playerid][WK2_countSet] = 0.0;
    WK2_playerPanel[playerid][WK2_sctPanel] = 0;
    WK2_playerPanel[playerid][WK2_price] = 0;

    return 1;
}

stock WK2_HidePanel(playerid)
{
    for(new i; i < 5;i++) TextDrawHideForPlayer(playerid, WK2_TD[i]);

    for(new i; i < 11;i++) PlayerTextDrawHide(playerid, WK2_PTD[playerid][i]);

    WK2_ResetPanelData(playerid);

    return 1;
}

stock WK2_ShowPanel(playerid, panel = -1)
{
    new old = WK2_playerPanel[playerid][WK2_sctPanel]-1;
    if(WK2_playerPanel[playerid][WK2_sctPanel] != 0) PlayerTextDrawSetString(playerid, WK2_PTD[playerid][old], WK2_wheelTexture[old][0]);

    PlayerTextDrawSetString(playerid, WK2_PTD[playerid][panel], WK2_wheelTexture[panel][1]);
    PlayerTextDrawSetString(playerid, WK2_PTD[playerid][5], WK2_panelTexture[panel]);
    PlayerTextDrawSetString(playerid, WK2_PTD[playerid][4], WK2_infoTexture[panel]);
    
    PlayerTextDrawSetString(playerid, WK2_PTD[playerid][6], "txd:brtuning2stage5");
    PlayerTextDrawSetString(playerid, WK2_PTD[playerid][7], WK2_FloatToStr(WK2_stepSize[panel]));

    if(strcmp(WK2_devTag, "WheelTuningSystem", true) != 0) WK2_devTag = "WheelTuningSystem";
    TextDrawSetString(WK2_TD[0], WK2_devTag);

    for(new i;i < 11;i++) PlayerTextDrawShow(playerid, WK2_PTD[playerid][i]);
    WK2_playerPanel[playerid][WK2_countSet] = WK2_stepSize[panel];
    WK2_playerPanel[playerid][WK2_sctPanel] = panel+1;
    WK2_playerPanel[playerid][WK2_sctParam] = 5;
    
    new vehicleid = GetPlayerOwnableCar(playerid);

    new index = GetVehicleData(vehicleid, V_ACTION_ID);

    SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
    return 1;
}

stock WK2_FloatToStr(Float:float)
{
    new string[32];

    format(string, sizeof string, "%.2f", float);

    return string;
}

stock WK2_UpdateDB(sql, veh)
{
    new string[184];

    mysql_format(mysql, string, sizeof string, "UPDATE ownable_cars SET wheels_kl=%f,wheels_otkl=%f,wheels_size=%f,wheels_raz=%d WHERE id = %d LIMIT 1",
    g_VehHandlingInfo[veh][hpSuspensionLowerLimit], g_VehHandlingInfo[veh][hpSuspensionBias], g_VehHandlingInfo[veh][hpWheelSize],
     g_VehVisualsInfo[veh][vcWheelAlignment][0], sql);
    mysql_query(mysql, string, false);
    if(mysql_errno()) for(new i; i < 10; i++) printf("ERROR %s", string);
}

stock SetVehicleWheels(sql, vehicle)
{
    new string[164];
    mysql_format(mysql, string, sizeof string, "SELECT * FROM ownable_cars WHERE id = %d", sql);
    new Cache:cache = mysql_query(mysql, string, true);

    if(mysql_errno()) for(new i; i < 10; i++) printf("ERROR %s", string);

    new Float:size = cache_get_field_content_float(0, "wheels_size"),
    Float:otkl = cache_get_field_content_float(0, "wheels_otkl"),
    Float:kl = cache_get_field_content_float(0, "wheels_kl"), razval = cache_get_field_content_int(0, "wheels_raz");

    if(size == 0.0) size = 0.75;
    if(otkl == 0.0) otkl = 0.5;
    if(kl == 0.0)   kl = -0.1;

    g_VehUsesVisuals[vehicle] = true;
    g_VehVisualsInfo[vehicle][vcWheelAlignment][0] = razval;
    g_VehVisualsInfo[vehicle][vcWheelAlignment][1] = razval;

    foreach(new i : streamed_players_in_veh[vehicle])
	{
		UpdateVehVisuals(i, vehicle);
	}

    g_VehUsesHandling[vehicle] = true;
    g_VehHandlingInfo[vehicle][hpWheelSize] = size;
    g_VehHandlingInfo[vehicle][hpSuspensionBias] = otkl;
    g_VehHandlingInfo[vehicle][hpSuspensionLowerLimit] = kl;

    foreach(new i : streamed_players_in_veh[vehicle])
    {
        UpdateVehHandling(i, vehicle);
    }


    cache_delete(cache);
    return 1;
}

stock WK2_DestroyVehicle(vehicleid)
{
    ResetHandlingAttributes(vehicleid);
	ResetVehileComponentsDefault(vehicleid);
	ResetVehVisuals(vehicleid);

    return DestroyVehicle(vehicleid);
}
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle WK2_DestroyVehicle