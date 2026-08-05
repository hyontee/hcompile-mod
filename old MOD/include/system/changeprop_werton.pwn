#define E_HOUSE 1
#define E_VEHICLE   2
#define E_BUSINESS  3
#define E_FUELSTATION    4

new string_284[285];
new ChangePropTimer[MAX_PLAYERS]; 

new player_Changeprop[MAX_PLAYERS];

public OnGameModeInit()
{
    print("[W_SYSTEM] Команда для обмена загружена.");
   
    #if defined ch_OnGameModeInit
        return ch_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit ch_OnGameModeInit
#if defined ch_OnGameModeInit
    forward ch_OnGameModeInit();
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(player_Changeprop[playerid] != -1)
    {
        new to_player = player_Changeprop[playerid];

        SendClientMessage(to_player, -1, ""USC" Игрок с которым вы обменивались вышел.");
        player_Changeprop[to_player] = -1;
        player_Changeprop[playerid] = -1;
    }
    #if defined name_OnPlayerDisconnect
        return name_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect name_OnPlayerDisconnect
#if defined name_OnPlayerDisconnect
    forward name_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerConnect(playerid)
{
    
    player_Changeprop[playerid] = -1;
    
    // if(player_Changeprop[playerid] != INVALID_PLAYER_ID)
    // {
    //     printf("[W_SYSTEM] player_Changeprop != INVALID_PLAYER_ID -> %d -> %d.", playerid, player_Changeprop[playerid]);
    //     player_Changeprop[playerid] = playerid;
    // }
    // else player_Changeprop[playerid] = INVALID_PLAYER_ID;
    #if defined ch_OnPlayerConnect
        return ch_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect ch_OnPlayerConnect
#if defined ch_OnPlayerConnect
    forward ch_OnPlayerConnect(playerid);
#endif



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1610)
    {
        if(response)
        {   
            new string[64];

            new player = -1;
            if(GetPVarInt(playerid, "select_to_player")) player = player_Changeprop[playerid];
            else player = playerid;

            switch(listitem)
            {
                case 0:
                {
                    if(GetPlayerHouse(player) != -1)
                    {
                        if(player == playerid) format(string, sizeof string, "Вы хотите обменяться на свой {FFFF00}Дом №%d{FFFFFF}?", GetPlayerHouse(player));
                        else format(string, sizeof string, "Вы хотите обменяться на {FFFF00}Дом №%d{FFFFFF}?", GetPlayerHouse(player));

                        SendClientMessage(player_Changeprop[playerid], -1, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал тип имущества - {FFD900}Дом/Квартира");

                        Dialog
                        (
                            playerid, 1612, DIALOG_STYLE_MSGBOX,
                            "{FF0000}Обмен{FFFFFF} | Дом/квартира",
                            string,
                            "Выбрать", "Назад"
                        );
                        SetPVarInt(player, "select_type_Changeprop", E_HOUSE);
                    }
                    else
                    {
                        SendClientMessage(playerid, -1, ""USC" У вас/игрока нет дома/квартиры");
                        
                        ShowDialogSelectTypeChangeprop(playerid);

                        return 1;                        
                    }
                }
                case 1:
                {
                    SendClientMessage(player_Changeprop[playerid], -1, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал тип имущества - {FFD900}Машина");
                    new Cache:result;

                    mysql_format(mysql, string_284, sizeof string_284, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(player));
                    result = mysql_query(mysql, string_284);

                    if(!mysql_errno())
                    {
                        if(!cache_num_rows())
                        {
                            SendClientMessage(playerid, -1, ""USC" У вас нет транспорта");
                            ShowDialogSelectTypeChangeprop(playerid);

                            return 1;
                        }

                        new rows = cache_num_rows();

                        new id, model, string_veh[68], dialog[514];

                        for(new i; i < rows; i ++)
                        {
                            id = cache_get_field_content_int(i, "id");
                            model = cache_get_field_content_int(i, "model_id")-400;

                            format(string_veh, sizeof string_veh, "№%d %s\n", id, GetVehicleInfo(model, VI_NAME));
                            strcat(dialog, string_veh);
                            SetPlayerListitemValue(playerid, i, id);
                        }

                        Dialog(playerid, 1612, DIALOG_STYLE_LIST, "{FF0000}Обмен{FFFFFF} | Выберите транспорт.", dialog, "Выбрать", "Назад");
                        SetPVarInt(player, "select_type_Changeprop", E_VEHICLE);
                    }
                    else print("[ERROR Changeprop MYSQL] ID ERROR:: 5");

                    cache_delete(result);
                }
                case 2:
                {
                    if(GetPlayerBusiness(player) != -1)
                    {
                        SendClientMessage(player_Changeprop[playerid], -1, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал тип имущества - {FFD900}Бизнес");

                        if(player == playerid) format(string, sizeof string, "Вы хотите обменяться на свой {FFFF00}Бизнес №%d{FFFFFF}?", GetPlayerBusiness(player));
                        else format(string, sizeof string, "Вы хотите обменяться на {FFFF00}Бизнес №%d{FFFFFF}?", GetPlayerBusiness(player));

                        Dialog
                        (
                            playerid, 1612, DIALOG_STYLE_MSGBOX,
                            "{FF0000}Обмен{FFFFFF} | Бизнес",
                            string,
                            "Выбрать", "Назад"
                        );
                        SetPVarInt(player, "select_type_Changeprop", E_BUSINESS);
                    }
                    else
                    {
                        SendClientMessage(playerid, -1, ""USC" У вас/игрока нет бизнеса");
                        ShowDialogSelectTypeChangeprop(playerid);

                        return 1;                        
                    }
                }
                case 3:
                {
                    if(GetPlayerFuelStation(player) != -1)
                    {
                        SendClientMessage(player_Changeprop[playerid], -1, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал тип имущества - {FFD900}Заправочная станция");

                        if(player == playerid) format(string, sizeof string, "Вы хотите обменяться на свою {FFFF00}Заправку №%d{FFFFFF}?", GetPlayerFuelStation(player));
                        else format(string, sizeof string, "Вы хотите обменяться на {FFFF00}Заправку №%d{FFFFFF}?", GetPlayerFuelStation(player));

                        Dialog
                        (
                            playerid, 1612, DIALOG_STYLE_MSGBOX,
                            "{FF0000}Обмен{FFFFFF} | Заправочная станция",
                            string,
                            "Выбрать", "Назад"
                        );
                        SetPVarInt(player, "select_type_Changeprop", E_FUELSTATION);
                    }
                    else
                    {
                        SendClientMessage(playerid, -1, ""USC" У вас/игрока нет заправочной станции");
                        ShowDialogSelectTypeChangeprop(playerid);

                        return 1;                        
                    }
                }
            }
        }
        else 
        {
            player_Changeprop[player_Changeprop[playerid]] = -1;
            player_Changeprop[playerid] = -1;
            
            DeleteFullPVarChangeprop(playerid);
        }
    }
    if(dialogid == 1612)
    {
        if(response)
        {

            new select_player = GetPVarInt(playerid, "select_to_player");

            new player = -1;
            if(select_player) player = player_Changeprop[playerid];
            else player = playerid;

            new type = GetPVarInt(player, "select_type_Changeprop");

            if(!type) ShowDialogSelectTypeChangeprop(playerid);

            new string_vehicle[68];

            if(type == E_VEHICLE) 
            {
                new id = GetPlayerListitemValue(playerid, listitem);

                SetPVarInt(player, "database_vehicle", id);

                mysql_format(mysql, string_284, sizeof string_284, "SELECT * FROM ownable_cars WHERE id=%d", id);
                new Cache:result;
                result = mysql_query(mysql, string_284);

                if(!cache_num_rows())
                {
                    print("[ERROR Changeprop MYSQL] ID ERROR:: 4");
                    return ShowDialogSelectTypeChangeprop(playerid);
                }
                new model = cache_get_field_content_int(0, "model_id")-400;

                
                format(string_vehicle, sizeof string_vehicle, "%s (№%d)", GetVehicleInfo(model, VI_NAME), id);
                SetPVarString(player, "string_vehicle", string_vehicle);
            }

            new to_player = player_Changeprop[playerid];

            new message[114];

            if(!select_player)
            {
                switch(type)//message
                {
                    case E_HOUSE:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал свой {FFFF00}Дом №%d", GetPlayerHouse(player));
                    case E_VEHICLE:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал свой транспорт {FFFF00}%s", string_vehicle);
                    case E_BUSINESS:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал свой {FFFF00}Бизнес №%d", GetPlayerBusiness(player));
                    case E_FUELSTATION:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал свою {FFFF00}Заправку №%d", GetPlayerFuelStation(player));
                }
            }
            else
            {
                switch(type)//message
                {
                    case E_HOUSE:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал Ваш {FFFF00}Дом №%d", GetPlayerHouse(player));
                    case E_VEHICLE:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал Ваш транспорт {FFFF00}%s", string_vehicle);
                    case E_BUSINESS:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал Ваш {FFFF00}Бизнес №%d", GetPlayerBusiness(player));
                    case E_FUELSTATION:format(message, sizeof message, "{FFD900}| [Обмен] {FFFFFF}Игрок выбрал Вашу {FFFF00}Заправку №%d", GetPlayerFuelStation(player));
                }
            }

            SendClientMessage(to_player, -1, message);

            ShowNewNotification(playerid, 1, 5, 1, 1, "Выберите тип имущества игрока", "");
            ShowNotification(playerid, 1, "Выберите тип имущества игрока", 3, "","");

            if(!GetPVarInt(playerid, "select_to_player"))
            {
                ShowDialogSelectTypeChangeprop(playerid);
                SetPVarInt(playerid, "select_to_player", 1);
            }
            else
            {
                Dialog
                (
                   playerid, 1613, DIALOG_STYLE_LIST,
                   "{FF0000}Обмен{FFFFFF} | Доплата",
                   "Без доплаты\n"\
                   "Доплачиваете Вы\n"\
                   "Доплачивает Игрок",
                   "Выбрать", "Назад"
                );
            }

        }
        else ShowDialogSelectTypeChangeprop(playerid);
    }
    if(dialogid == 1613)
    {
        if(response)
        {
            if(GetPVarInt(playerid, "surchange_type"))
            {
                new surchange = strval(inputtext), to_player = player_Changeprop[playerid];

                if(!surchange) return SendClientMessage(playerid, -1, ""SC" Нужно ввести сумму больше 0");

                if(GetPVarInt(playerid, "surchange_type") == 2)
                {
                    if(GetPlayerMoneyEx(to_player) >= surchange)
                    {
                        SetPVarInt(playerid, "surchange", surchange);
                        SendChangeprop(to_player);
                    }
                    else
                    {
                        player_Changeprop[to_player] = -1;
                        player_Changeprop[playerid] = -1;
                        
                        DeleteFullPVarChangeprop(playerid);
                    }
                }
                else
                {
                    if(GetPlayerMoneyEx(playerid) >= surchange)
                    {
                        SetPVarInt(playerid, "surchange", surchange);
                        SendChangeprop(to_player);
                    }
                    else
                    {
                        player_Changeprop[to_player] = -1;
                        player_Changeprop[playerid] = -1;
                        
                        DeleteFullPVarChangeprop(playerid);
                    }
                }           

                return 1;
            }

            switch(listitem)
            {
                case 0:SendChangeprop(player_Changeprop[playerid]);
                case 1:
                {
                    Dialog
                    (
                        playerid, 1613, DIALOG_STYLE_INPUT,
                        "{FF0000}Обмен{FFFFFF} | Доплата",
                        "Введите сумму которую Вы должны доплатить игроку за обмен.",
                        "Обмен", "Выйти"
                    );
                    SetPVarInt(playerid, "surchange_type", 1);
                }
                case 2:
                {
                    Dialog
                    (
                        playerid, 1613, DIALOG_STYLE_INPUT,
                        "{FF0000}Обмен{FFFFFF} | Доплата",
                        "Введите сумму которую игрок должен доплатить Вам за обмен.",
                        "Обмен", "Выйти"
                    );
                    SetPVarInt(playerid, "surchange_type", 2);
                }
            }
        }
        else ShowDialogSelectTypeChangeprop(playerid);
    }
    if(dialogid == 1614)
    {
        if(response)
        {
            new to_player = player_Changeprop[playerid];

            new type = GetPVarInt(playerid, "select_type_Changeprop"),
            type_1 = GetPVarInt(to_player, "select_type_Changeprop"),
            surchange = GetPVarInt(to_player, "surchange"),
            surchange_p = GetPVarInt(to_player, "surchange_type")-1;

            new vehicle_sql, vehicle_sql_1;
            if(type == E_VEHICLE) vehicle_sql = GetPVarInt(playerid, "database_vehicle");
            if(type_1 == E_VEHICLE) vehicle_sql_1 = GetPVarInt(to_player, "database_vehicle");

            Changeprop(type, type_1, playerid, to_player, surchange, surchange_p, vehicle_sql, vehicle_sql_1);
        }
        else
        {
            SendClientMessage(player_Changeprop[playerid], -1,""USC"Игрок отказался от обмена.");
            SendClientMessage(playerid, -1,""USC"Вы отказались от обмена.");
            DeleteFullPVarChangeprop(playerid);
            DeleteFullPVarChangeprop(player_Changeprop[playerid]);
        }
    }
    #if defined ch_OnDialogResponse
return ch_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse ch_OnDialogResponse
#if defined ch_OnDialogResponse
forward ch_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


CMD:changeprop(playerid, params[])
{
	extract params -> new to_player; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /changeprop [id игрока]");

	if(!IsPlayerConnected(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
    
    if(player_Changeprop[to_player] != -1)
        return SendClientMessage(playerid, -1, ""USC"Игрок в данный момент обменивается с другим игроком.");

    player_Changeprop[playerid] = -1;

    new text[84];
    format(text, sizeof text, "Игрок %s предлагает начать обмен имуществом.", GetPlayerNameEx(playerid));
    SendClientMessage(to_player, 0xFFD900FF, text);
    ShowNotification(to_player, 5, text, 5, "/yeschange", ">>");
    ShowNewNotification(playerid, 5, 5, YES_CHANGEPROP, 1, text, "");
    //SendClientMessage(to_player, 0xFFD900FF, "Для согласия введите /yeschange");
    
    format(text, sizeof text, "Вы предложили %s начать обмен имуществом.", GetPlayerNameEx(to_player));
    SendClientMessage(playerid, 0xFFD900FF, text);
    
    ChangePropTimer[to_player] = SetTimerEx("CancelChangePropTimer", 30000, false, "d", to_player);

    SetPVarInt(to_player, "to_player", playerid);
    SetPVarInt(playerid, "playerid", to_player);

    return 1;
}

cmd:yeschange(playerid)
{
KillTimer(ChangePropTimer[playerid]);

    new id = GetPVarInt(playerid, "to_player");

    player_Changeprop[id] = GetPVarInt(id, "playerid");
    player_Changeprop[playerid] = id;

    SendClientMessage(id, 0xFFD900FF, "Игрок согласился на обмен имуществом.");
    SendClientMessage(playerid, 0xFFD900FF, "Вы согласились на обмен имуществом.");

    ShowDialogSelectTypeChangeprop(id);
    return 1;

}
stock Changeprop(type, type_1, player, player_1, surcharge = 0, surcharge_p = -1, vehicle_sql = -1, vehicle_sql_1 = -1)
{
    switch(type)
    {
        case E_HOUSE:ChangepropHouse(player, player_1);
        case E_VEHICLE:ChangepropVehicle(player_1, vehicle_sql);
        case E_BUSINESS:ChangepropBusiness(player, player_1);
        case E_FUELSTATION:ChangepropFuelStation(player, player_1);
        default:print("ERROR Changeprop - None Type");
    }

    switch(type_1)
    {
        case E_HOUSE:ChangepropHouse(player_1, player);
        case E_VEHICLE:ChangepropVehicle(player, vehicle_sql_1);
        case E_BUSINESS:ChangepropBusiness(player_1, player);
        case E_FUELSTATION:ChangepropFuelStation(player_1, player);
        default:print("ERROR Changeprop - None Type_1");
    }

    if(surcharge >= 1)
    {
        new player_money = -1, player_take_money = -1;

        if(!surcharge_p)
        {
            player_money = player;
            player_take_money = player_1;
        } 
        else if(surcharge_p)
        {
            player_money = player_1;
            player_take_money = player;
        } 
        else return print("Error");

        GivePlayerMoneyEx(player_money, surcharge);
        GivePlayerMoneyEx(player_take_money, -surcharge);
    }

    SendClientMessage(player, -1, "{FFD900}| [Обмен] {FFFFFF}Вы успешно провели обмен с игроком.");
    SendClientMessage(player_1, -1, "{FFD900}| [Обмен] {FFFFFF}Вы успешно провели обмен с игроком.");

    DeleteFullPVarChangeprop(player);
    DeleteFullPVarChangeprop(player_1);
    return 1;
}

stock ChangepropVehicle(playerid, sql_id)
{
    new vehicleid = GetPlayerOwnableCar(player_Changeprop[playerid]);

	if(vehicleid != INVALID_VEHICLE_ID)
    {
        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(GetOwnableCarData(index, OC_SQL_ID) == sql_id) UnloadPlayerOwnableCar(player_Changeprop[playerid]);
    }
    
    mysql_format(mysql, string_284, sizeof string_284, "UPDATE ownable_cars SET owner_id=%d WHERE id=%d", GetPlayerAccountID(playerid), sql_id);
    mysql_query(mysql, string_284, false);

    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 3");
    return 1;
}

stock ChangepropFuelStation(playerid, to_player)
{
    new stationid = GetPlayerFuelStation(playerid);
    new account_player = GetPlayerAccountID(playerid),
    account_to_player = GetPlayerAccountID(to_player);

    SetPlayerData(playerid, P_FUEL_ST, -1);

    mysql_format(mysql, string_284, sizeof string_284, "UPDATE accounts SET fuel_st=-1 WHERE id=%d", account_player);
    mysql_query(mysql, string_284, false);
    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 6");
    

    format(string_284, sizeof string_284, "UPDATE accounts a, fuel_stations f SET a.fuel_st=%d,f.owner_id=%d WHERE a.id=%d AND f.id=%d", stationid, account_to_player, account_to_player, GetFuelStationData(stationid, FS_SQL_ID));
    mysql_query(mysql, string_284, false);
    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 6.1");

    if(!mysql_errno())
    {
        SetPlayerData(to_player, P_FUEL_ST, stationid);

        SetFuelStationData(stationid, FS_OWNER_ID, 		account_to_player);
        SetFuelStationData(stationid, FS_IMPROVEMENTS, 0);

        new time = gettime();
        new rent_time = (time - (time % 86400)) + 86400;

        SetFuelStationData(stationid, FS_FUELS, 		50);
        SetFuelStationData(stationid, FS_FUEL_PRICE,	3);
        SetFuelStationData(stationid, FS_BUY_FUEL_PRICE,0);

        SetFuelStationData(stationid, FS_BALANCE,		0);
        SetFuelStationData(stationid, FS_RENT_DATE,		rent_time);
        SetFuelStationData(stationid, FS_LOCK_STATUS,	false);

        format(g_fuel_station[stationid][FS_OWNER_NAME], 21, GetPlayerNameEx(to_player), 0);
        CallLocalFunction("UpdateFuelStationLabel", "i", stationid);

        SendClientMessage(to_player, 0x66CC00FF, "Напишите {3399FF}/fuelst {66CC00}чтобы узнать о возможностях");

        format(string_284, sizeof string_284, "UPDATE fuel_stations SET improvements=0,fuels=%d,fuel_price=%d,buy_fuel_price=%d,balance=%d,rent_time=%d,`lock`=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_FUEL_PRICE), GetFuelStationData(stationid, FS_BUY_FUEL_PRICE), GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_RENT_DATE), GetFuelStationData(stationid, FS_LOCK_STATUS), GetFuelStationData(stationid, FS_SQL_ID));
        mysql_query(mysql, string_284, false);

        format(string_284, sizeof string_284, "UPDATE fuel_stations_profit SET view=0 WHERE fid=%d AND view=1",  GetFuelStationData(stationid, FS_SQL_ID));
        mysql_query(mysql, string_284, false);

        return 1;
    }

    return 1;
}
stock ChangepropBusiness(playerid, to_player)
{
    new businessid = GetPlayerBusiness(playerid);
    
    new account_player = GetPlayerAccountID(playerid),
    account_to_player = GetPlayerAccountID(to_player);

    SetPlayerData(playerid, P_BUSINESS, -1);
    
    mysql_format(mysql, string_284, sizeof string_284, "UPDATE accounts SET business=-1 WHERE id=%d", account_player);
    mysql_query(mysql, string_284, false);
    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 2");

    mysql_format(mysql, string_284, sizeof string_284, "UPDATE accounts a, business b SET a.business=%d,b.owner_id=%d WHERE a.id=%d AND b.id=%d", businessid, account_to_player, account_to_player, GetBusinessData(businessid, B_SQL_ID));
    mysql_query(mysql, string_284, false);
    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 2.1");
    printf("sql %s", string_284);

    if(!mysql_errno())
    {
        SetPlayerData(to_player, P_BUSINESS, businessid);

        SetBusinessData(businessid, B_OWNER_ID, account_to_player);
        SetBusinessData(businessid, B_IMPROVEMENTS, 	0);

        new time = gettime();//Автор данной системы https://t.me/welsistudio (Welsi Studio)
        new rent_time = (time - (time % 86400)) + 86400;


        SetBusinessData(businessid,	B_PRODS, 		20);
        SetBusinessData(businessid,	B_PROD_PRICE, 	0);

        SetBusinessData(businessid,	B_ENTER_MUSIC, 	0);
        SetBusinessData(businessid,	B_ENTER_PRICE, 	0);

        SetBusinessData(businessid,	B_BALANCE, 		0);
        SetBusinessData(businessid,	B_RENT_DATE,	rent_time);
        SetBusinessData(businessid,	B_LOCK_STATUS,	false);


        format(g_business[businessid][B_OWNER_NAME], 21, GetPlayerNameEx(to_player), 0);
        CallLocalFunction("UpdateBusinessLabel", "i", businessid);

        SendClientMessage(to_player, 0x66CC00FF, "Напишите {0099FF}/business {66CC00}чтобы узнать о возможностях");

        format(string_284, sizeof string_284, "UPDATE business SET improvements=0,products=%d,prod_price=%d,balance=%d,rent_time=%d,`lock`=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_RENT_DATE), GetBusinessData(businessid, B_LOCK_STATUS), GetBusinessData(businessid, B_SQL_ID));
        mysql_query(mysql, string_284, false);
        if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 2.2");

        format(string_284, sizeof string_284, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(businessid, B_SQL_ID));
        mysql_query(mysql, string_284, false);
        if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 2.3");

        return 1;
    }
    return 1;
}
stock ChangepropHouse(playerid, to_player)
{
    new houseid = GetPlayerHouse(playerid);

    new account_player = GetPlayerAccountID(playerid),
    account_to_player = GetPlayerAccountID(to_player);


    SetPlayerData(playerid, P_HOUSE, 		-1);
    SetPlayerData(playerid, P_HOUSE_TYPE, 	-1);

    mysql_format(mysql, string_284, sizeof string_284, "UPDATE accounts SET house_type = -1, house = -1 WHERE id=%d", account_player);
    mysql_query(mysql, string_284, false);
    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 0.9");


    format(string_284, sizeof string_284, "UPDATE accounts a, houses h SET a.house_type=%d,a.house=%d,h.owner_id=%d WHERE a.id=%d AND h.id=%d", HOUSE_TYPE_HOME, houseid, account_to_player, account_to_player, GetHouseData(houseid, H_SQL_ID));
    mysql_query(mysql, string_284, false);
    if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 1");
    printf("sql %s", string_284);

    if(!mysql_errno())
    {
        SetPlayerData(to_player, P_HOUSE, 		houseid);
        SetPlayerData(to_player, P_HOUSE_TYPE, 	HOUSE_TYPE_HOME);


        SetHouseData(houseid, H_OWNER_ID, account_to_player);
        SetHouseData(houseid, H_IMPROVEMENTS, 	0);

        SetHouseData(houseid, H_STORE_X, 0.0);
        SetHouseData(houseid, H_STORE_Y, 0.0);
        SetHouseData(houseid, H_STORE_Z, 0.0);

        new time = gettime();
        new rent_time = (time - (time % 86400)) + 86400;

        if(GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
        {
            SetHouseData(houseid, H_RENT_DATE, rent_time);
        }

        new entranceid = GetHouseData(houseid, H_ENTRACE);
        if(entranceid != -1)
        {
            CallLocalFunction("EntranceStatusInit", "i", entranceid);
        }

        new Cache:result, name[24];

        if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 1.1");


        format(g_house[houseid][H_OWNER_NAME], 21, GetPlayerNameEx(to_player), 0);

        cache_delete(result);

        UpdateHouse(houseid);

        HouseHealthInit(houseid);
        HouseStoreInit(houseid);

        format(string_284, sizeof string_284, "UPDATE houses SET improvements=0,rent_time=%d,`lock`=%d,store_x=0.0,store_y=0.0,store_z=0.0 WHERE id=%d LIMIT 1", GetHouseData(houseid, H_RENT_DATE), GetHouseData(houseid, H_LOCK_STATUS), GetHouseData(houseid, H_SQL_ID));
        mysql_query(mysql, string_284, false);
        if(mysql_errno()) return print("[ERROR Changeprop MYSQL] ID ERROR:: 1.2");
    }
    return 1;
}

stock ShowDialogSelectTypeChangeprop(playerid)
{
    if(player_Changeprop[playerid] != -1)
    {
        Dialog
        (
            playerid, 1610, DIALOG_STYLE_LIST,
            "{FF0000}Обмен{FFFFFF} | Выберите тип имущества",
            "1. Дом/квартира\n"\
            "2. Машина\n"\
            "3. Бизнес\n"\
            "4. Заправка",
            "Выбрать", "Назад"
        );      
    } 

    return 1;   
}

stock SendChangeprop(playerid)
{
    new to_player = player_Changeprop[playerid];

    new surchange_money = GetPVarInt(to_player, "surchange");

    new surchange[48] = "Без доплаты";

    new select_player[68], select_to_player[68];

    switch(GetPVarInt(playerid, "select_type_Changeprop"))
    {
        case E_HOUSE:
        {
            if(GetPlayerHouse(to_player) != -1)
            {
                SendClientMessage(playerid, -1, "{FFD900}| [Обмен] {FFFFFF}У игрока уже есть дом/квартира.");
                SendClientMessage(to_player, -1, "{FFD900}| [Обмен] {FFFFFF}У вас уже есть дом/квартира.");

                DeleteFullPVarChangeprop(playerid);
                DeleteFullPVarChangeprop(to_player);
                return 1;
            }
        }
        case E_BUSINESS:
        {
            if(GetPlayerBusiness(to_player) != -1)
            {
                SendClientMessage(playerid, -1, "{FFD900}| [Обмен] {FFFFFF}У игрока уже есть бизнес.");
                SendClientMessage(to_player, -1, "{FFD900}| [Обмен] {FFFFFF}У вас уже есть бизнес.");

                DeleteFullPVarChangeprop(playerid);
                DeleteFullPVarChangeprop(to_player);
                return 1;
            }
        }
        case E_FUELSTATION:
        {
            if(GetPlayerFuelStation(to_player) != -1)
            {
                SendClientMessage(playerid, -1, "{FFD900}| [Обмен] {FFFFFF}У игрока уже есть заправочная станция.");
                SendClientMessage(to_player, -1, "{FFD900}| [Обмен] {FFFFFF}У вас уже есть заправочная станция.");

                DeleteFullPVarChangeprop(playerid);
                DeleteFullPVarChangeprop(to_player);
                return 1;
            }
        }
        default:print("ERROR Changeprop - None Type");
    }

    switch(GetPVarInt(to_player, "select_type_Changeprop"))
    {
        case E_HOUSE:
        {
            if(GetPlayerHouse(playerid) != -1)
            {
                SendClientMessage(to_player, -1, "{FFD900}| [Обмен] {FFFFFF}У игрока уже есть дом/квартира.");
                SendClientMessage(playerid, -1, "{FFD900}| [Обмен] {FFFFFF}У вас уже есть дом/квартира.");

                DeleteFullPVarChangeprop(to_player);
                DeleteFullPVarChangeprop(playerid);
                return 1;
            }

        }
        case E_BUSINESS:
        {
            if(GetPlayerBusiness(playerid) != -1)
            {
                SendClientMessage(to_player, -1, "{FFD900}| [Обмен] {FFFFFF}У игрока уже есть бизнес.");
                SendClientMessage(playerid, -1, "{FFD900}| [Обмен] {FFFFFF}У вас уже есть бизнес.");

                DeleteFullPVarChangeprop(playerid);
                DeleteFullPVarChangeprop(to_player);
                return 1;
            }
        }
        case E_FUELSTATION:
        {
            if(GetPlayerFuelStation(playerid) != -1)
            {
                SendClientMessage(to_player, -1, "{FFD900}| [Обмен] {FFFFFF}У игрока уже есть заправочная станция.");
                SendClientMessage(playerid, -1, "{FFD900}| [Обмен] {FFFFFF}У вас уже есть заправочная станция.");

                DeleteFullPVarChangeprop(playerid);
                DeleteFullPVarChangeprop(to_player);
                return 1;
            }
        }
        default:print("ERROR Changeprop - None Type_1");
    }


    switch(GetPVarInt(playerid, "select_type_Changeprop"))
    {
        case E_HOUSE:format(select_player, sizeof select_player, "{FFFF00}Дом №%d", GetPlayerHouse(playerid));
        case E_VEHICLE:
        {
            new string_vehicle[68];
            GetPVarString(playerid, "string_vehicle", string_vehicle, 68);
            format(select_player, sizeof select_player, string_vehicle);
        }
        case E_BUSINESS:format(select_player, sizeof select_player, "{FFFF00}Бизнес №%d", GetPlayerBusiness(playerid));
        case E_FUELSTATION:format(select_player, sizeof select_player, "{FFFF00}Заправка №%d", GetPlayerFuelStation(playerid));
    }

    switch(GetPVarInt(to_player, "select_type_Changeprop"))
    {
        case E_HOUSE:format(select_to_player, sizeof select_to_player, "{FFFF00}Дом №%d", GetPlayerHouse(to_player));
        case E_VEHICLE:
        {
            new string_vehicle[68];
            GetPVarString(to_player, "string_vehicle", string_vehicle, 68);
            format(select_to_player, sizeof select_to_player, string_vehicle);
        }
        case E_BUSINESS:format(select_to_player, sizeof select_to_player, "{FFFF00}Бизнес №%d", GetPlayerBusiness(to_player));
        case E_FUELSTATION:format(select_to_player, sizeof select_to_player, "{FFFF00}Заправка №%d", GetPlayerFuelStation(to_player));
    }

    if(surchange_money >= 1)
    {
        switch(GetPVarInt(to_player, "surchange_type"))
        {
            case 1:format(surchange, sizeof surchange, "Доплачивает игрок %d рублей", surchange_money);
            case 2:format(surchange, sizeof surchange, "Доплачиваете Вы %d рублей", surchange_money);
        }
    }

    format
    (
        string_284, sizeof string_284,
        "Вы выполняете обмен с {FFFF00}%s\n\
        {FFFFFF}Вы обмениваете {FFFF00}%s{FFFFFF} на Ваш(y) {FFFF00}%s\n\
        {FFFFFF}%s\n\n\
        Вы согласны?",
        GetPlayerNameEx(to_player),
        select_to_player, select_player,
        surchange
    );

    Dialog
    (
        playerid, 1614, DIALOG_STYLE_MSGBOX,
        "{FF0000}Обмен",
        string_284,
        "Обмен", "Выйти"
    );

    return 1;
}

stock DeleteFullPVarChangeprop(playerid)
{
    player_Changeprop[playerid] = -1;
    DeletePVar(playerid, "surcharge");
    DeletePVar(playerid, "surchange_type");
    DeletePVar(playerid, "select_to_player");
    DeletePVar(playerid, "string_vehicle");
    DeletePVar(playerid, "database_vehicle");
    DeletePVar(playerid, "select_type_Changeprop");
    
    return 1;
}

public CancelChangePropTimer(playerid)
{
            KillTimer(ChangePropTimer[playerid]);
            SendClientMessage(player_Changeprop[playerid], -1,""USC"Игрок отказался от обмена.");
            SendClientMessage(playerid, -1,""USC"Вы отказались от обмена.");
            DeleteFullPVarChangeprop(playerid);
            DeleteFullPVarChangeprop(player_Changeprop[playerid]);
}