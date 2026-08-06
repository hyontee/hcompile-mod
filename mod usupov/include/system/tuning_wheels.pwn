new Text:welsi_tun_TD[5];
new PlayerText:welsi_tun_PTD[MAX_PLAYERS][11];

enum params_panel_tun 
{
    tun_count_set,
    tun_sct_panel,
    tun_sct_param,
    tun_price,
}

new player_wheel_panel[MAX_PLAYERS][params_panel_tun];
new vladshinka;

new stock_count_set[4] = 
{
    50,
    50,
    40,
    0
};

new type_setting_wheel[4][2][] = 
{ 
    {"txd:brtuning3m11", "txd:brtuning3m14"},
    {"txd:brtuning3m12", "txd:brtuning3m15"},
    {"txd:brtuning3m13", "txd:brtuning3m16"},
    {"txd:brtuning3m19", "txd:brtuning3m20"}
};
 
new type_panel_settings[4][] = 
{
    {"txd:brtuning3oklirens"},
    {"txd:brtuning3otklirens"},
    {"txd:brtuning3razval"},
    {"txd:brtuning3sizewheel"}
};

new dev_welsi[] = "";

new type_info_settings[4][] = 
{
    {"txd:brtuning3noklirens"},
    {"txd:brtuning3notklirens"},
    {"txd:brtuning3nrazval"},
    {"txd:brtuning3nsizewheel"}
};

stock TextDrawWheels()
{
    welsi_tun_TD[1] = TextDrawCreate(484874353453454354.6665, 150.4369, "txd:brtuning2service"); // пусто
    TextDrawTextSize(welsi_tun_TD[1], 146487435345345435.0000, 172.0000);
    TextDrawAlignment(welsi_tun_TD[1], 1);
    TextDrawColor(welsi_tun_TD[1], -1);
    TextDrawBackgroundColor(welsi_tun_TD[1], 255);
    TextDrawFont(welsi_tun_TD[1], 4);
    TextDrawSetProportional(welsi_tun_TD[1], 0);
    TextDrawSetShadow(welsi_tun_TD[1], 0);

    welsi_tun_TD[2] = TextDrawCreate(186.3332, 389.7853, "txd:brtuning3cost"); // пусто
    TextDrawTextSize(welsi_tun_TD[2], 265.0000, 24.0000);
    TextDrawAlignment(welsi_tun_TD[2], 1);
    TextDrawColor(welsi_tun_TD[2], -1);
    TextDrawBackgroundColor(welsi_tun_TD[2], 255);
    TextDrawFont(welsi_tun_TD[2], 4);
    TextDrawSetProportional(welsi_tun_TD[2], 0);
    TextDrawSetShadow(welsi_tun_TD[2], 0);
    welsi_tun_TD[0] = TextDrawCreate(580.9998, 2.0888, ""); // пусто
    welsi_tun_TD[3] = TextDrawCreate(186.9998, 419.6520, "txd:brtuning2buy"); // пусто
    TextDrawTextSize(welsi_tun_TD[3], 116.0000, 24.0000);
    TextDrawAlignment(welsi_tun_TD[3], 1);
    TextDrawColor(welsi_tun_TD[3], -1);
    TextDrawBackgroundColor(welsi_tun_TD[3], 255);
    TextDrawFont(welsi_tun_TD[3], 4);
    TextDrawSetProportional(welsi_tun_TD[3], 0);
    TextDrawSetShadow(welsi_tun_TD[3], 0);
    TextDrawSetSelectable(welsi_tun_TD[3], true);

    welsi_tun_TD[4] = TextDrawCreate(334.6665, 419.6520, "txd:brtuning2exit"); // пусто
    TextDrawTextSize(welsi_tun_TD[4], 116.0000, 24.0000);
    TextDrawAlignment(welsi_tun_TD[4], 1);
    TextDrawColor(welsi_tun_TD[4], -1);
    TextDrawBackgroundColor(welsi_tun_TD[4], 255);
    TextDrawFont(welsi_tun_TD[4], 4);
    TextDrawSetProportional(welsi_tun_TD[4], 0);
    TextDrawSetShadow(welsi_tun_TD[4], 0);
    TextDrawSetSelectable(welsi_tun_TD[4], true);

    TextDrawLetterSize(welsi_tun_TD[0], 0.1480, 0.8740);
    TextDrawTextSize(welsi_tun_TD[0], -101.0000, 0.0000);
    TextDrawAlignment(welsi_tun_TD[0], 1);
    TextDrawColor(welsi_tun_TD[0], -81);
    TextDrawBackgroundColor(welsi_tun_TD[0], 255);
    TextDrawFont(welsi_tun_TD[0], 1);
    TextDrawSetProportional(welsi_tun_TD[0], 1);
    TextDrawSetShadow(welsi_tun_TD[0], 0);
    return 1;
}
 

stock TextDrawPlayerWheels(playerid)
{
    welsi_tun_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 503.0000, 165.1257, "txd:brtuning3m11"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][0], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][0], true);

    welsi_tun_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 503.0000, 203.2888, "txd:brtuning3m12"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][1], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][1], true);

    welsi_tun_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 503.0000, 241.0368, "txd:brtuning3m13"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][2], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][2], true);

    welsi_tun_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 503.0000, 278.7850, "txd:brtuning3m19"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][3], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][3], true);

    welsi_tun_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 186.3332, 357.8445, "txd:brtuning3noklirens"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][4], 265.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][4], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][4], false);

    welsi_tun_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 3.0000, 181.1333, "txd:brtuning3oklirens"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][5], 164.0000, 115.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][5], false);

    welsi_tun_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 80.0000, 241.1925, "0.5"); // пусто
    PlayerTextDrawLetterSize(playerid, welsi_tun_PTD[playerid][7], 0.1712, 0.9404);
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][7], -37.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][7], 2);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][7], 0);

    welsi_tun_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 18.3332, 240.8666, "txd:brtuning2stage1"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][6], 131.0000, 9.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][6], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][6], 0);

    welsi_tun_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 385.6666, 395.3333, "10000_PYЂ"); // пусто
    PlayerTextDrawLetterSize(playerid, welsi_tun_PTD[playerid][8], 0.2479, 1.1684);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][8], 3);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][8], 8388863);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, welsi_tun_PTD[playerid][8], 0);

    welsi_tun_PTD[playerid][9] = CreatePlayerTextDraw(playerid,87.6666, 258.7034, "txd:brtuning2plus"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][9], 62.0000, 19.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][9], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][9], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][9], true);

    welsi_tun_PTD[playerid][10] = CreatePlayerTextDraw(playerid,18.3332, 259.1184, "txd:brtuning2minus"); // пусто
    PlayerTextDrawTextSize(playerid, welsi_tun_PTD[playerid][10], 62.0000, 19.0000);
    PlayerTextDrawAlignment(playerid, welsi_tun_PTD[playerid][10], 1);
    PlayerTextDrawColor(playerid, welsi_tun_PTD[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, welsi_tun_PTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, welsi_tun_PTD[playerid][10], 4);
    PlayerTextDrawSetProportional(playerid, welsi_tun_PTD[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, welsi_tun_PTD[playerid][10], true);

    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == welsi_tun_TD[3])
    {
        if(!player_wheel_panel[playerid][tun_sct_panel]) return 1;

        new price = player_wheel_panel[playerid][tun_sct_param] * 1000;

        if(GetPlayerMoneyEx(playerid) >= price)
        {
            GivePlayerMoneyEx(playerid, -price);

            switch(player_wheel_panel[playerid][tun_sct_panel])
            { 
                case 4:SendClientMessage(playerid, -1, "Вы успешно купили настройку на развал колес");
                case 1:SendClientMessage(playerid, -1, "Вы успешно купили настройку на общий клиренс");
                case 2:SendClientMessage(playerid, -1, "Вы успешно купили настройку на отдельный клиренс");
                case 3:SendClientMessage(playerid, -1, "Вы успешно купили настройку на размер колес");
            }

            new index = GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID);
            //data_UpdateWheelsVehicle(GetOwnableCarData(index, OC_SQL_ID), GetPlayerOwnableCar(playerid));
            new vehicleid = GetPlayerOwnableCar(playerid);
            new string[204];
            //:000
            new sql = GetOwnableCarData(index, OC_SQL_ID);
            /*new wertonkl = GetPVarInt(vehicleid, "ClearanceOldWerton");
            new wertonotkl = GetPVarInt(vehicleid, "RazdelClearanceOldWerton");
            new wertonsize = GetPVarInt(vehicleid, "SizeOldWerton");
            new wertonrazval = GetPVarInt(vehicleid, "RazvalOldWerton");*/

            mysql_format(mysql, string, sizeof string, "SELECT * FROM ownable_cars WHERE id = %d", sql);
            new Cache:cache = mysql_query(mysql, string, true);

            new wertonsize = cache_get_field_content_int(0, "last_size"),
            wertonotkl = cache_get_field_content_int(0, "last_otkl"),
            wertonkl = cache_get_field_content_int(0, "last_kl"), wertonrazval = cache_get_field_content_int(0, "last_razval");
            
            mysql_format(mysql, string, sizeof string, "UPDATE ownable_cars SET wheels_kl=%d,wheels_otkl=%d,wheels_size=%d,wheels_raz=%d WHERE id = %d LIMIT 1",
            wertonkl, wertonotkl, wertonsize, wertonrazval, sql);
            mysql_query(mysql, string, false);
            if(mysql_errno()) for(new i; i < 10; i++) printf("ERROR %s", string);

            SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), GetPlayerOwnableCar(playerid));

            if(strcmp(dev_welsi, "", true) != 0) dev_welsi = "";
            TextDrawSetString(welsi_tun_TD[0], dev_welsi);
            
            PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][8], "0000_РУБ");
            for(new i = 5; i < 11;i++) PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][i]);   

            new old = player_wheel_panel[playerid][tun_sct_panel]-1;
            PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][old], type_setting_wheel[old][0]);
            
            player_wheel_panel[playerid][tun_sct_panel] = 0;
            player_wheel_panel[playerid][tun_count_set] = 0;
            player_wheel_panel[playerid][tun_price] = 0;
        }
    }
    if(clickedid == welsi_tun_TD[4])
    {
        new vehicleid = GetPlayerOwnableCar(playerid);

        new index = GetVehicleData(vehicleid, V_ACTION_ID);

        SetPlayerPos(playerid, 1744.696777,2465.750244,14.939245);

        SetPlayerVirtualWorld(playerid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        SetVehiclePos(vehicleid, 1744.696777,2465.750244,14.939245);
        SetVehicleZAngle(vehicleid, 280.080505);
        LinkVehicleToInterior(vehicleid, 0);
        SetPlayerInterior(playerid, 0);

        ShowHud(playerid);
        TogglePlayerControllable(playerid, true);

        SetCameraBehindPlayer(playerid);
        HidePanelWheels(playerid);    

        SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        CancelSelectTextDraw(playerid);
        
        SetTimerEx("tpplayerhinEXIT", 400, false, "d", playerid);
    }
    #if defined tun_OnPlayerClickTextDraw
        return tun_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw tun_OnPlayerClickTextDraw
#if defined tun_OnPlayerClickTextDraw
    forward tun_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    new string[24];

    if(playertextid == welsi_tun_PTD[playerid][9])
    {
        if(player_wheel_panel[playerid][tun_sct_param]+1 == 11) return 1;  

        player_wheel_panel[playerid][tun_sct_param]++;

        format(string, sizeof string, "txd:brtuning2stage%d", player_wheel_panel[playerid][tun_sct_param]);
        PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][6], string);

        new vehicleid = GetPlayerOwnableCar(playerid);

        if(vehicleid != GetPlayerOwnableCar(playerid)) return SendClientMessage(playerid, -1, "У вас должен быть личный транспорт");
        
        switch(player_wheel_panel[playerid][tun_sct_panel])
        {
            case 1:
            {
                new string[164];
                player_wheel_panel[playerid][tun_count_set] += 2;
                SetVehicleClearance(vehicleid, player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "ClearanceOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_kl=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
            case 2:
            {
                player_wheel_panel[playerid][tun_count_set] += 3;
                SetVehicleSeparateClearance(vehicleid, player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "RazdelClearanceOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_otkl=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
            case 3:
            {
                new string[164];
                player_wheel_panel[playerid][tun_count_set] += 5;
                SetVehicleWheelWidth(vehicleid, player_wheel_panel[playerid][tun_count_set], player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "SizeOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_size=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
            case 4:
            {
                new string[164];
                player_wheel_panel[playerid][tun_count_set] += 5;
                SetVehicleWheelAlignment(vehicleid, player_wheel_panel[playerid][tun_count_set], player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "RazvalOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_razval=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
        }

        if(player_wheel_panel[playerid][tun_sct_panel] == 4)
        {
            format(string, sizeof string, "%d", player_wheel_panel[playerid][tun_count_set]);
            PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][7], string);
        }
        else PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][7], player_wheel_panel[playerid][tun_count_set]);

        format(string, sizeof string, "%d000_РУБ", player_wheel_panel[playerid][tun_sct_param]);
        PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][8], string);
        
    }
    if(playertextid == welsi_tun_PTD[playerid][10])
    {
        if(player_wheel_panel[playerid][tun_sct_param]+1 == 1) return 1; 

        player_wheel_panel[playerid][tun_sct_param]--;
                
        format(string, sizeof string, "txd:brtuning2stage%d", player_wheel_panel[playerid][tun_sct_param]);
        PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][6], string);
 
        new vehicleid = GetPlayerOwnableCar(playerid);

        if(vehicleid != GetPlayerOwnableCar(playerid)) return SendClientMessage(playerid, -1, "У вас должен быть личный транспорт");
        
        switch(player_wheel_panel[playerid][tun_sct_panel])
        {
            case 1:
            {
                new string[164];
                player_wheel_panel[playerid][tun_count_set] -= 2;
                SetVehicleClearance(vehicleid, player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "ClearanceOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_kl=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
            case 2:
            {
                player_wheel_panel[playerid][tun_count_set] -= 3;
                SetVehicleSeparateClearance(vehicleid, player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "RazdelClearanceOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_otkl=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
            case 3:
            {
                new string[164];
                player_wheel_panel[playerid][tun_count_set] -= 5;
                SetVehicleWheelWidth(vehicleid, player_wheel_panel[playerid][tun_count_set], player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "SizeOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_size=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
            case 4:
            {
                new string[164];
                player_wheel_panel[playerid][tun_count_set] -= 5;
                SetVehicleWheelAlignment(vehicleid, player_wheel_panel[playerid][tun_count_set], player_wheel_panel[playerid][tun_count_set], 1);
                SetPVarInt(vehicleid, "RazvalOldWerton", player_wheel_panel[playerid][tun_count_set]);
                
                new fmt_str[64];
				new index = GetVehicleData(vehicleid, V_ACTION_ID);

				format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET last_razval=%d WHERE id=%d", player_wheel_panel[playerid][tun_count_set], GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, fmt_str, false);
            }
        }
        if(player_wheel_panel[playerid][tun_sct_panel] == 4)
        {
            format(string, sizeof string, "%d", player_wheel_panel[playerid][tun_count_set]);
            PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][7], string);
        }
        else PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][7], player_wheel_panel[playerid][tun_count_set]);

        format(string, sizeof string, "%d000_РУБ", player_wheel_panel[playerid][tun_sct_param]);
        PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][8], string);
    }

    for(new i;i<4;i++) if(playertextid == welsi_tun_PTD[playerid][i])  ShowPanelWheels(playerid, i);
	#if defined tun_OnPlayerClickPlayerTextD
		return tun_OnPlayerClickPlayerTextD(playerid, playertextid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined tun_OnPlayerClickPlayerTextD
	forward tun_OnPlayerClickPlayerTextD(playerid, PlayerText:playertextid);
#endif
#define	OnPlayerClickPlayerTextDraw tun_OnPlayerClickPlayerTextD
 
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_CROUCH)
    {
        if(IsPlayerInRangeOfPoint(playerid,  5.0, 1728.380004,2461.955566,14.946941))
        {
	        if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
		    new vehicleid = GetPlayerVehicleID(playerid);
            new world = playerid + 1000;

            SetPlayerVirtualWorld(playerid, world);
            SetVehicleVirtualWorld(vehicleid, world);
            SetVehiclePos(vehicleid, 995.735229,1001.658935,1500.155761);
            SetVehicleZAngle(vehicleid, 177.443664);
            LinkVehicleToInterior(vehicleid, 1);
            SetPlayerInterior(playerid, 1);

            SetPlayerCameraPos(playerid, 999.656250,998.227416,1501.000000);
            SetPlayerCameraLookAt(playerid, 995.735229,1001.658935,1500.155761);

                    
            HideHud(playerid);
                    
            SetTimerEx("tpplayerhin", 700, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid,  5.0, 1729.587890,2457.302490,14.939245))
        {
	        if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
		    new vehicleid = GetPlayerVehicleID(playerid);
            new world = playerid + 1000;

            SetPlayerVirtualWorld(playerid, world);
            SetVehicleVirtualWorld(vehicleid, world);
            SetVehiclePos(vehicleid, 995.735229,1001.658935,1500.155761);
            SetVehicleZAngle(vehicleid, 177.443664);
            LinkVehicleToInterior(vehicleid, 1);
            SetPlayerInterior(playerid, 1);

            SetPlayerCameraPos(playerid, 999.656250,998.227416,1501.000000);
            SetPlayerCameraLookAt(playerid, 995.735229,1001.658935,1500.155761);

                    
            HideHud(playerid);
                    
            SetTimerEx("tpplayerhin", 700, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid,  5.0, 1730.307739,2452.697753,14.939245))
        {
	        if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
		    new vehicleid = GetPlayerVehicleID(playerid);
            new world = playerid + 1000;

            SetPlayerVirtualWorld(playerid, world);
            SetVehicleVirtualWorld(vehicleid, world);
            SetVehiclePos(vehicleid, 995.735229,1001.658935,1500.155761);
            SetVehicleZAngle(vehicleid, 177.443664);
            LinkVehicleToInterior(vehicleid, 1);
            SetPlayerInterior(playerid, 1);

            SetPlayerCameraPos(playerid, 999.656250,998.227416,1501.000000);
            SetPlayerCameraLookAt(playerid, 995.735229,1001.658935,1500.155761);

                    
            HideHud(playerid);
                    
            SetTimerEx("tpplayerhin", 700, false, "d", playerid);
        }
    }

    #if defined tun_OnPlayerKeyStateChange
        return tun_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
} 
   #if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange tun_OnPlayerKeyStateChange
#if defined tun_OnPlayerKeyStateChange
    forward tun_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnGameModeInit()
{
    print("[W_SYSTEM] Система шиномонтажа загружена.");
    vladshinka = CreatePickup(1318,23,1732.120849,2447.988281,14.939245,0);
	CreateDynamic3DTextLabel("{FFFF00}Шиномонтажный центр (34)\n{228B22}Бизнес находиться на аукционе\n{228B22}Крыша: Отсутствует\n{FFFF00}Подойдите для взаимодействия", 0xFFFF00FF, 1732.120849,2447.988281,14.939245 + 0.9, 10.0);
    TextDrawWheels();
    CreateDynamic3DTextLabel("{f6fa05}Шиномонтажный центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 1728.380004,2461.955566,14.946941, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Шиномонтажный центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 1729.587890,2457.302490,14.939245, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Шиномонтажный центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 1730.307739,2452.697753,14.939245, 9.0, _, _, _, -1, -1);
    SetTimer("InsertDataBaseWheels", 1300, false);
    
    #if defined tun_OnGameModeInit
        return tun_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit tun_OnGameModeInit
#if defined tun_OnGameModeInit
    forward tun_OnGameModeInit();
#endif

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
if(pickupid == vladshinka)
	{
	    SendClientMessage(playerid, 0xCECECEFF, "В данный тип бизнеса нельзя войти");
	}
#if defined tun_OnPlayerPickUpPickupEx
        return tun_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;

    #endif
}
#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx tun_OnPlayerPickUpPickupEx
#if defined tun_OnPlayerPickUpPickupEx
    forward tun_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
     if(dialogid == 6543)
    {
	    if(response)
	        {
	            switch(listitem)
	                {        
	                  case 0:
							{
							SelectTextDraw(playerid, -1);
							TextDrawPlayerWheels(playerid);
                    
                    ResetSctWheelsTextD(playerid);

                    TextDrawShowForPlayer(playerid, welsi_tun_TD[1]);
 
                    for(new i;i < 4;i++) PlayerTextDrawShow(playerid, welsi_tun_PTD[playerid][i]);

                    PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][8], "0000_РУБ");

                    for(new i;i < 5;i++) TextDrawShowForPlayer(playerid, welsi_tun_TD[i]);

                    PlayerTextDrawShow(playerid, welsi_tun_PTD[playerid][4]);
                    PlayerTextDrawShow(playerid, welsi_tun_PTD[playerid][8]);
                    HideHud(playerid);
                    SelectTextDraw(playerid, -1);
							}
					case 1:
							{
							Dialog
                              (
                                  playerid, 6544, DIALOG_STYLE_LIST,
                                  "{FF6347}"SERVER_NAME" {FFFFFF}| Установка гидравлики",
                                  "1. Установить\t{ffff00}\t40000{ffffff} P\n"\
                                  "2. Удалить\t{ffff00}\t10000{ffffff} P",
                                  "Далее", "Отмена"
                              );
	                        }
	        }
	}
	else shinexit(playerid);
	}
	if(dialogid == 6544)
	        {
	            new veh = GetPlayerOwnableCar(playerid);

	            if(response)
	            {
	                new fmt_text[999];
                	new index = GetVehicleData(veh, V_ACTION_ID);
                    new idx = GetOwnableCarData(index, OC_SQL_ID);
                
	                switch(listitem)
	                {
	                case 0:
	                    {
	                        SetVehicleHydraulics(veh, 1, 1);
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET gidra='1'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -40000, "гидравлика", true, true), SCM(playerid, -1, ""SC"Вы успешно купили гидравлику!");
							Dialog
                              (
                                  playerid, 6543, DIALOG_STYLE_LIST,
                                  "{FF6347}"SERVER_NAME" {FFFFFF}| Шиномонтажный центр",
                                  "1. Настройка подвески\n"\
                                  "2. Установка гидравлики",
                                  "Выбрать", "Выйти"
                              );
	                    }
	                case 1:
	                    {
							SetVehicleHydraulics(veh, 0, 1);
                            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET gidra='0'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);								
							GivePlayerMoneyEx(playerid, -10000, "гидравлика", true, true), SCM(playerid, -1, ""SC"Вы успешно удалили гидравлику!");
							Dialog
                              (
                                  playerid, 6543, DIALOG_STYLE_LIST,
                                  "{FF6347}"SERVER_NAME" {FFFFFF}| Шиномонтажный центр",
                                  "1. Настройка подвески\n"\
                                  "2. Установка гидравлики",
                                  "Выбрать", "Выйти"
                              );
	                    }
	                }
	            }
	            
	        }	
    #if defined tun_OnDialogResponse
    return tun_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse tun_OnDialogResponse
#if defined tun_OnDialogResponse
forward tun_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public:InsertDataBaseWheels()
{
    new string[124];

    mysql_format(mysql, string, sizeof string, "SELECT * FROM ownable_cars WHERE wheels_kl AND wheels_otkl AND wheels_raz AND wheels_size");
    mysql_query(mysql, string, false);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `ownable_cars` ADD `wheels_kl` INT NOT NULL AFTER `model_id`, ADD `wheels_size` INT NOT NULL AFTER `wheels_kl`, ADD `wheels_raz` INT NOT NULL AFTER `wheels_size`, ADD `wheels_otkl` INT NOT NULL AFTER `wheels_raz`", false);

        if(!mysql_errno()) printf("ALTER TABLE 'ownable_cars' complete");
    }

    return 1;
}

stock ResetSctWheelsTextD(playerid)
{
    player_wheel_panel[playerid][tun_sct_param] = 0;
    player_wheel_panel[playerid][tun_count_set] = 0.0;
    player_wheel_panel[playerid][tun_sct_panel] = 0;
    player_wheel_panel[playerid][tun_price] = 0;

    return 1;
}

stock HidePanelWheels(playerid)
{
    for(new i; i < 5;i++) TextDrawHideForPlayer(playerid, welsi_tun_TD[i]);

    for(new i; i < 11;i++) PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][i]);

    ResetSctWheelsTextD(playerid);

    return 1;
}

stock ShowPanelWheels(playerid, panel = -1)
{
    new old = player_wheel_panel[playerid][tun_sct_panel]-1;
    if(player_wheel_panel[playerid][tun_sct_panel] != 0) PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][old], type_setting_wheel[old][0]);

    PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][panel], type_setting_wheel[panel][1]);
    PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][5], type_panel_settings[panel]);
    PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][4], type_info_settings[panel]);
    
    PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][6], "txd:brtuning2stage5");
    PlayerTextDrawSetString(playerid, welsi_tun_PTD[playerid][7], stock_count_set[panel]);

    if(strcmp(dev_welsi, "", true) != 0) dev_welsi = "";
    TextDrawSetString(welsi_tun_TD[0], dev_welsi);

    for(new i;i < 11;i++) PlayerTextDrawShow(playerid, welsi_tun_PTD[playerid][i]);
    player_wheel_panel[playerid][tun_count_set] = stock_count_set[panel];
    player_wheel_panel[playerid][tun_sct_panel] = panel+1;
    player_wheel_panel[playerid][tun_sct_param] = 5;
    
    new vehicleid = GetPlayerOwnableCar(playerid);

    new index = GetVehicleData(vehicleid, V_ACTION_ID);

    SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
    return 1;
}

stock floattostring(Float:float)
{
    new string[32];

    format(string, sizeof string, "%.2f", float);

    return string;
} 

/*stock data_UpdateWheelsVehicle(sql, veh)
{
    new string[184];

    mysql_format(mysql, string, sizeof string, "UPDATE ownable_cars SET wheels_kl=%f,wheels_otkl=%f,wheels_size=%f,wheels_raz=%d WHERE id = %d LIMIT 1",
    g_VehHandlingInfo[veh][hpSuspensionLowerLimit], g_VehHandlingInfo[veh][hpSuspensionBias], g_VehHandlingInfo[veh][hpWheelSize],
     g_VehVisualsInfo[veh][vcWheelAlignment][0], sql);
    mysql_query(mysql, string, false);
    if(mysql_errno()) for(new i; i < 10; i++) printf("ERROR %s", string);
}*/
 
stock SetVehicleWheels(sql, vehicle)
{
    new string[164];
    mysql_format(mysql, string, sizeof string, "SELECT * FROM ownable_cars WHERE id = %d", sql);
    new Cache:cache = mysql_query(mysql, string, true);

    //if(mysql_errno()) for(new i; i < 10; i++) printf("ERROR %s", string);

    new size = cache_get_field_content_int(0, "wheels_size"),
    otkl = cache_get_field_content_int(0, "wheels_otkl"),
    kl = cache_get_field_content_int(0, "wheels_kl"), razval = cache_get_field_content_int(0, "wheels_raz");
    new gidra = cache_get_field_content_int(0, "gidra");
    
    if(size == 0) size = 40;
    if(otkl == 0) otkl = 50;
    if(kl == 0)   kl = 50;
    if(gidra == 0)   SetVehicleHydraulics(vehicle, 0, 1);
    if(gidra == 1)   SetVehicleHydraulics(vehicle, 1, 1);
 
    SetVehicleWheelAlignment(vehicle, razval, razval, 1);
    SetVehicleClearance(vehicle, kl, 1);
    SetVehicleWheelWidth(vehicle, size, size, 1);
    SetVehicleSeparateClearance(vehicle, otkl, 1);
    SetVehicleWheelRadius(vehicle, 75, 1);
    
    SetPVarInt(vehicle, "ClearanceOldWerton", kl);
    SetPVarInt(vehicle, "RazdelClearanceOldWerton", otkl);
    SetPVarInt(vehicle, "SizeOldWerton", size);
    SetPVarInt(vehicle, "RazvalOldWerton", razval);
    
    cache_delete(cache);
    return 1;
}

stock SetVehicleWheelsFam(sql, vehicle)
{
    new string[164];
    mysql_format(mysql, string, sizeof string, "SELECT * FROM family_cars WHERE id = %d", sql);
    new Cache:cache = mysql_query(mysql, string, true);

    //if(mysql_errno()) for(new i; i < 10; i++) printf("ERROR %s", string);

    new size = cache_get_field_content_int(0, "wheels_size"),
    otkl = cache_get_field_content_int(0, "wheels_otkl"),
    kl = cache_get_field_content_int(0, "wheels_kl"), razval = cache_get_field_content_int(0, "wheels_raz");
    new gidra = cache_get_field_content_int(0, "gidra");
    
    if(size == 0) size = 40;
    if(otkl == 0) otkl = 50;
    if(kl == 0)   kl = 50;
    if(gidra == 0)   SetVehicleHydraulics(vehicle, 0, 1);
    if(gidra == 1)   SetVehicleHydraulics(vehicle, 1, 1);
 
    SetVehicleWheelAlignment(vehicle, razval, razval, 1);
    SetVehicleClearance(vehicle, kl, 1);
    SetVehicleWheelWidth(vehicle, size, size, 1);
    SetVehicleSeparateClearance(vehicle, otkl, 1);
    SetVehicleWheelRadius(vehicle, 75, 1);
    
    SetPVarInt(vehicle, "ClearanceOldWerton", kl);
    SetPVarInt(vehicle, "RazdelClearanceOldWerton", otkl);
    SetPVarInt(vehicle, "SizeOldWerton", size);
    SetPVarInt(vehicle, "RazvalOldWerton", razval);
    
    cache_delete(cache);
    return 1;
}

stock wheel_DestroyVehicle(vehicleid)
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
#define DestroyVehicle wheel_DestroyVehicle

public tpplayerhin(playerid)
{
SetPlayerPos(playerid, 1005.610839, 995.741149, 1501);
			SetPlayerFacingAngle(playerid, 221.490325);
			
   Dialog
    (
        playerid, 6543, DIALOG_STYLE_LIST,
        "{FF6347}"SERVER_NAME" {FFFFFF}| Шиномонтажный центр",
        "1. Настройка подвески\n"\
        "2. Установка гидравлики",
        "Выбрать", "Выйти"
    );
			return 1;
}

public tpplayerhinEXIT(playerid)
{
       SelectTextDraw(playerid, -1);
       TextDrawHideForPlayer(playerid, welsi_tun_TD[0]);
       SelectTextDraw(playerid, -1);
       TextDrawHideForPlayer(playerid, welsi_tun_TD[1]);
       SelectTextDraw(playerid, -1);
       TextDrawHideForPlayer(playerid, welsi_tun_TD[2]);
       SelectTextDraw(playerid, -1);
       TextDrawHideForPlayer(playerid, welsi_tun_TD[3]);
       SelectTextDraw(playerid, -1);
       TextDrawHideForPlayer(playerid, welsi_tun_TD[4]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][0]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][1]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][2]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][3]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][4]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][5]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][6]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][7]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][8]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][9]);
       SelectTextDraw(playerid, -1);
       PlayerTextDrawHide(playerid, welsi_tun_PTD[playerid][10]);
       CancelSelectTextDraw(playerid);
       ResetSctWheelsTextD(playerid);
}

stock shinexit(playerid)
{
        new vehicleid = GetPlayerOwnableCar(playerid);

        new index = GetVehicleData(vehicleid, V_ACTION_ID);

        SetPlayerPos(playerid, 1744.696777,2465.750244,14.939245);

        SetPlayerVirtualWorld(playerid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        SetVehiclePos(vehicleid, 1744.696777,2465.750244,14.939245);
        SetVehicleZAngle(vehicleid, 280.080505);
        LinkVehicleToInterior(vehicleid, 0);
        SetPlayerInterior(playerid, 0);

        ShowHud(playerid);
        TogglePlayerControllable(playerid, true);

        SetCameraBehindPlayer(playerid);
        HidePanelWheels(playerid);    

        SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        CancelSelectTextDraw(playerid);
        
        SetTimerEx("tpplayerhinEXIT", 400, false, "d", playerid);
}