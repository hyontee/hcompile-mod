/*
* ==============================================
* СИСТЕМА ГАРАЖЕЙ - ПОЛНОСТЬЮ ИСПРАВЛЕННАЯ
* ==============================================
*/

new LoadCarGarage[MAX_PLAYERS];

enum E_GARAGE_STRUCT
{
    GARAGE_ID,
    GARAGE_OWNER_ID,
    GARAGE_PRICE,
    GARAGE_STATUS,
    Float:GARAGE_X,
    Float:GARAGE_Y,
    Float:GARAGE_Z,
    Float:GARAGE_EXIT_X,
    Float:GARAGE_EXIT_Y,
    Float:GARAGE_EXIT_Z,
    Float:GARAGE_EXIT_ANGLE,
    G_ENTER_PICKUP,
    Text3D:G_LABEL,
    Text3D:G_MINE_LABEL,
    G_OWNER_NAME[32],
    GARAGE_IMPROVEMENTS
}

#define MAX_GARAGES 100
#define MAX_GARAGE_NAME 32

#define GetPlayerInGarage(%0) GetPlayerData(%0, P_IN_GARAGE)
#define SetPlayerInGarage(%0,%1) SetPlayerData(%0, P_IN_GARAGE, %1)

#define GetGarageData(%0,%1) g_garage[%0][%1]
#define SetGarageData(%0,%1,%2) g_garage[%0][%1] = %2
#define IsGarageOwned(%0) (GetGarageData(%0, GARAGE_OWNER_ID) > 0)

new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];
new g_garage_loaded;

#define DIALOG_GARAGE_INFO 22313
#define DIALOG_GARAGE_SETTINGS 22323
#define DIALOG_GARAGE_SELL 22333
#define DIALOG_GARAGE_BUY 22343
#define DIALOG_GARAGE_ENTER 22353
#define DIALOG_OWNABLE_CAR_LOAD_GARAGE 22363
#define DIALOG_GARAGE_IMPROVEMENT 22383
#define DIALOG_GARAGE_IMPROVEMENT_CONFIRM 22393

#define PICKUP_ACTION_TYPE_GARAGE_EXIT 221
#define PICKUP_ACTION_TYPE_GARAGE 222
#define OFFER_TYPE_SELL_GARAGE 224

forward ShowPlayerGarageInfo(playerid, garageid);
forward CheckAndCreateGaragesTables();
forward LoadGarages();

// ==============================================
public CheckAndCreateGaragesTables()
{
    new query[1024];
    
    mysql_format(mysql, query, sizeof(query), "SHOW TABLES LIKE 'garages'");
    mysql_query(mysql, query);
    
    if(cache_num_rows() == 0)
    {
        print("Creating garages table...");
        
        format(query, sizeof(query),
            "CREATE TABLE `garages` (`id` INT(11) NOT NULL AUTO_INCREMENT, `owner_id` INT(11) NOT NULL DEFAULT 0, `price` INT(11) NOT NULL DEFAULT 30000000, `lock` INT(11) NOT NULL DEFAULT 0, `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `z` FLOAT NOT NULL, `exit_x` FLOAT NOT NULL, `exit_y` FLOAT NOT NULL, `exit_z` FLOAT NOT NULL, `exit_angle` FLOAT NOT NULL, `improvements` INT(11) NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;"
        );
        mysql_query(mysql, query);
    }
    return 1;
}

// ==============================================
public LoadGarages()
{
    new query[256];
    new Cache:result, rows;
    
    mysql_format(mysql, query, sizeof(query),
        "SELECT g.*, IFNULL(a.name, 'None') AS owner_name "
        "FROM garages g LEFT JOIN accounts a ON a.id=g.owner_id"
    );
    result = mysql_query(mysql, query);
    rows = cache_num_rows();
    
    if(rows > MAX_GARAGES) rows = MAX_GARAGES;
    
    for(new idx; idx < rows; idx++)
    {
        new garage_id = cache_get_field_content_int(idx, "id");
        new owner_id = cache_get_field_content_int(idx, "owner_id");
        new garage_lock = cache_get_field_content_int(idx, "lock");
        new improvements = cache_get_field_content_int(idx, "improvements");
        
        SetGarageData(idx, GARAGE_ID, garage_id);
        SetGarageData(idx, GARAGE_OWNER_ID, owner_id);
        SetGarageData(idx, GARAGE_PRICE, 30000000);
        SetGarageData(idx, GARAGE_STATUS, garage_lock);
        SetGarageData(idx, GARAGE_X, cache_get_field_content_float(idx, "x"));
        SetGarageData(idx, GARAGE_Y, cache_get_field_content_float(idx, "y"));
        SetGarageData(idx, GARAGE_Z, cache_get_field_content_float(idx, "z"));
        SetGarageData(idx, GARAGE_EXIT_X, cache_get_field_content_float(idx, "exit_x"));
        SetGarageData(idx, GARAGE_EXIT_Y, cache_get_field_content_float(idx, "exit_y"));
        SetGarageData(idx, GARAGE_EXIT_Z, cache_get_field_content_float(idx, "exit_z"));
        SetGarageData(idx, GARAGE_EXIT_ANGLE, cache_get_field_content_float(idx, "exit_angle"));
        SetGarageData(idx, GARAGE_IMPROVEMENTS, improvements);
        
        new owner_name[MAX_GARAGE_NAME];
        cache_get_field_content(idx, "owner_name", owner_name, mysql, MAX_GARAGE_NAME);
        strmid(g_garage[idx][G_OWNER_NAME], owner_name, 0, strlen(owner_name), MAX_GARAGE_NAME);
        
        CreatePickup(19134, 23, GetGarageData(idx, GARAGE_X), GetGarageData(idx, GARAGE_Y),
            GetGarageData(idx, GARAGE_Z), -1);
            
        CreatePickup(1318, 23, 1.2011, 1994.7356, 1554.2031, -1);
        CreatePickup(1318, 23, 492.912048, 1991.464599, 1547.679687, -1);
        
        UpdateGarageInfo(idx);
    }
    g_garage_loaded = rows;
    cache_delete(result);
    
    printf("[WERTON_GARAGES]: Загружено гаражей: %d", g_garage_loaded);
    return 1;
}

// ==============================================
// STOCKS
// ==============================================
stock GetPlayerGarage(playerid)
{
    new garageid = GetPlayerData(playerid, P_GARAGE);
    if(garageid != -1)
    {
        if(GetGarageData(garageid, GARAGE_OWNER_ID) == GetPlayerAccountID(playerid))
            return garageid;
    }
    return -1;
}

stock UpdateGarageInfo(idx)
{
    new query[666];
    
    if(GetGarageData(idx, GARAGE_OWNER_ID) > 0)
    {
        format(query, sizeof(query),
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n"
            "{FFFFFF}Владелец: {FF5252}%s{FFFFFF}\n"
            "{FFFFFF}Дверь: %s\n"
            "{FFFFFF}Цена: {FFA500}30.000.000{FFFFFF} руб",
            GetGarageData(idx, GARAGE_ID),
            GetGarageData(idx, G_OWNER_NAME),
            GetGarageData(idx, GARAGE_STATUS) ? ("{FF5252}закрыта") : ("{66CC33}открыта")
        );
    }
    else
    {
        format(query, sizeof(query),
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n"
            "{FFFFFF}Владелец: {FF5252}Отсутствует{FFFFFF}\n"
            "{FFFFFF}Дверь: {66CC33}открыта{FFFFFF}\n"
            "{FFFFFF}Цена: {FFA500}30.000.000{FFFFFF} руб",
            GetGarageData(idx, GARAGE_ID)
        );
    }
    UpdateDynamic3DTextLabelText(GetGarageData(idx, G_LABEL), 0xfaf2f6AA, query);
}

stock ShowPlayerGarageDialog(playerid)
{
    Dialog(playerid, DIALOG_GARAGE_SETTINGS, DIALOG_STYLE_LIST,
        "{ffff00}Управление гаражем",
        "1. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}гараж\n"
        "2. Продать гараж\n"
        "3. Улучшения\n"
        "4. Доставить транспорт в гараж\n"
        "5. Отметить гараж на GPS\n"
        "6. Продать гараж другому игроку",
        "Выбрать", "Отмена"
    );
}

stock EnterPlayerToGarage(playerid, garageid)
{
    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 1)
    {
        SetPlayerPosEx(playerid, 1.265544, 1996.246215, 1554.203125, 359.354705, 1, garageid + 2000, 0);
        SetPlayerInGarage(playerid, garageid);
    }
    else if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        SetPlayerPosEx(playerid, 495.083526, 1990.127807, 1547.679687, 272.186431, 1, garageid + 2000, 0);
        SetPlayerInGarage(playerid, garageid);
    }
}

stock BuyPlayerGarage(playerid, garageid, bool:buy_from_owner = false, price = -1)
{
    #pragma unused buy_from_owner
    
    if(!IsGarageOwned(garageid) && GetPlayerGarage(playerid) == -1)
    {
        if(price <= 0) price = 30000000;
        
        if(GetPlayerMoneyEx(playerid) >= price)
        {
            new query[256];
            
            // Обновляем аккаунт игрока
            format(query, sizeof(query),
                "UPDATE accounts SET garage=%d WHERE id=%d",
                garageid, GetPlayerAccountID(playerid)
            );
            mysql_query(mysql, query, false);
            
            // Обновляем гараж
            format(query, sizeof(query),
                "UPDATE garages SET owner_id=%d WHERE id=%d",
                GetPlayerAccountID(playerid), GetGarageData(garageid, GARAGE_ID)
            );
            mysql_query(mysql, query, false);
            
            if(!mysql_errno())
            {
                SetPlayerData(playerid, P_GARAGE, garageid);
                SetGarageData(garageid, GARAGE_OWNER_ID, GetPlayerAccountID(playerid));
                format(g_garage[garageid][G_OWNER_NAME], MAX_GARAGE_NAME, GetPlayerNameEx(playerid));
                EnterPlayerToGarage(playerid, garageid);
                UpdateGarageInfo(garageid);
                GivePlayerMoneyEx(playerid, -price, "Покупка гаража", false, true);
                SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/garage {66CC00}для управления гаражем");
                return 1;
            }
        }
    }
    return -1;
}

stock SellGarage(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return 0;
    
    new garage_price = 30000000;
    new garage_percent = (garage_price * 30) / 100;
    new return_money = (garage_price - garage_percent);
    new query[512];
    
    if(to_player == INVALID_PLAYER_ID)
    {
        // Продажа государству
        SetPlayerData(playerid, P_GARAGE, -1);
        SetGarageData(garageid, GARAGE_OWNER_ID, 0);
        SetGarageData(garageid, GARAGE_STATUS, 0);
        SetGarageData(garageid, GARAGE_IMPROVEMENTS, 1);
        format(g_garage[garageid][G_OWNER_NAME], MAX_GARAGE_NAME, "None");
        
        format(query, sizeof(query),
            "UPDATE accounts SET bank=bank+%d, garage=-1 WHERE id=%d",
            return_money, GetPlayerAccountID(playerid)
        );
        mysql_query(mysql, query, false);
        
        format(query, sizeof(query),
            "UPDATE garages SET owner_id=0, lock=0, improvements=1 WHERE id=%d",
            GetGarageData(garageid, GARAGE_ID)
        );
        mysql_query(mysql, query, false);
        
        // Обновляем локальные данные игрока
        SetPlayerData(playerid, P_BANK, GetPlayerData(playerid, P_BANK) + return_money);
        
        UpdateGarageInfo(garageid);
        SendClientMessage(playerid, 0x66CC00FF, "Вы продали свой гараж государству!");
        
        format(query, sizeof(query), "Налог составил 30%% ({99CC00}%d руб{FFFFFF})", garage_percent);
        SendClientMessage(playerid, 0xCECECEFF, query);
        
        format(query, sizeof(query), "На банк перечислено: {3399FF}%d руб", return_money);
        SendClientMessage(playerid, 0xFFFFFFFF, query);
        return 1;
    }
    else
    {
        // Продажа игроку
        if(!IsPlayerConnected(to_player)) return 0;
        
        if(GetPlayerMoneyEx(to_player) < price)
        {
            SendClientMessage(playerid, -1, "У игрока недостаточно денег!");
            return 0;
        }
        
        if(GetPlayerGarage(to_player) != -1)
        {
            SendClientMessage(playerid, -1, "У игрока уже есть гараж!");
            return 0;
        }
        
        // Снимаем деньги с покупателя
        GivePlayerMoneyEx(to_player, -price);
        
        // Передаем гараж
        SetPlayerData(to_player, P_GARAGE, garageid);
        SetPlayerData(playerid, P_GARAGE, -1);
        
        SetGarageData(garageid, GARAGE_OWNER_ID, GetPlayerAccountID(to_player));
        format(g_garage[garageid][G_OWNER_NAME], MAX_GARAGE_NAME, GetPlayerNameEx(to_player));
        SetGarageData(garageid, GARAGE_STATUS, 0);
        
        format(query, sizeof(query),
            "UPDATE accounts SET garage=%d WHERE id=%d",
            garageid, GetPlayerAccountID(to_player)
        );
        mysql_query(mysql, query, false);
        
        format(query, sizeof(query),
            "UPDATE accounts SET garage=-1 WHERE id=%d",
            GetPlayerAccountID(playerid)
        );
        mysql_query(mysql, query, false);
        
        format(query, sizeof(query),
            "UPDATE garages SET owner_id=%d, lock=0 WHERE id=%d",
            GetPlayerAccountID(to_player), GetGarageData(garageid, GARAGE_ID)
        );
        mysql_query(mysql, query, false);
        
        // Даем деньги продавцу
        GivePlayerMoneyEx(playerid, price);
        
        UpdateGarageInfo(garageid);
        
        format(query, sizeof(query), "Вы продали гараж игроку %s за {99CC00}%d руб{FFFFFF}!", GetPlayerNameEx(to_player), price);
        SendClientMessage(playerid, 0x66CC00FF, query);
        
        format(query, sizeof(query), "Вы купили гараж у %s за {99CC00}%d руб{FFFFFF}!", GetPlayerNameEx(playerid), price);
        SendClientMessage(to_player, 0x66CC00FF, query);
        
        SendClientMessage(to_player, 0x66CC00FF, "Напишите {0099FF}/garage {66CC00}для управления гаражем");
        return 1;
    }
}

// ==============================================
// PUBLIC FUNCTIONS
// ==============================================
public ShowPlayerGarageInfo(playerid, garageid)
{
    SetPlayerUseListitem(playerid, garageid);
    new string[256];
    
    if(IsGarageOwned(garageid))
    {
        format(string, sizeof(string),
            "{FFFFFF}Владелец: {33CCFF}%s\n\n{ffffff}Номер гаража: %d\n{ffffff}Стоимость: {ffff00}30.000.000 руб",
            GetGarageData(garageid, G_OWNER_NAME), garageid
        );
        Dialog(playerid, DIALOG_GARAGE_ENTER, DIALOG_STYLE_MSGBOX, "{FF9900}Гараж занят", string, "Войти", "Отмена");
    }
    else
    {
        format(string, sizeof(string),
            "{ffffff}Номер гаража: %d\n\n{ffffff}Стоимость: {ffff00}30.000.000 руб",
            garageid
        );
        Dialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{33CC00}Гараж свободен", string, "Купить", "Отмена");
    }
}

// ==============================================
// OnDialogResponse
// ==============================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    
    if(dialogid == DIALOG_GARAGE_IMPROVEMENT_CONFIRM)
    {
        if(response)
        {
            new garageid = GetPlayerGarage(playerid);
            if(garageid != -1)
            {
                new query[255];
                format(query, sizeof(query), "UPDATE garages SET improvements=2 WHERE id=%d", GetGarageData(garageid, GARAGE_ID));
                mysql_query(mysql, query, false);
                SetGarageData(garageid, GARAGE_IMPROVEMENTS, 2);
                Notka(playerid, "Улучшение куплено!", "Вы потратили 5.000.000 руб", 3000, 0x66CC33FF);
                GivePlayerMoneyEx(playerid, -5000000);
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_GARAGE_INFO)
    {
        if(response) ShowPlayerGarageDialog(playerid);
        return 1;
    }
    
    if(dialogid == DIALOG_GARAGE_SELL)
    {
        if(response) SellGarage(playerid);
        return 1;
    }
    
    if(dialogid == DIALOG_GARAGE_BUY)
    {
        if(response)
        {
            new garageid = GetPlayerUseListitem(playerid);
            if(GetPlayerGarage(playerid) == -1)
            {
                if(!IsGarageOwned(garageid))
                {
                    if(GetPlayerMoneyEx(playerid) >= 30000000)
                    {
                        SendClientMessage(playerid, -1, "Поздравляем! Вы купили гараж!");
                        BuyPlayerGarage(playerid, garageid);
                    }
                    else SendClientMessage(playerid, -1, "У вас недостаточно денег!");
                }
                else SendClientMessage(playerid, -1, "Этот гараж уже занят!");
            }
            else SendClientMessage(playerid, -1, "У вас уже есть гараж!");
        }
        return 1;
    }
    
    if(dialogid == DIALOG_GARAGE_ENTER)
    {
        if(response)
        {
            new garageid = GetPlayerUseListitem(playerid);
            
            if(IsGarageOwned(garageid))
            {
                if(GetGarageData(garageid, GARAGE_STATUS) == 1)
                {
                    SendClientMessage(playerid, -1, "Гараж закрыт!");
                    return 1;
                }
                EnterPlayerToGarage(playerid, garageid);
            }
            else SendClientMessage(playerid, -1, "Гараж не принадлежит никому!");
        }
        return 1;
    }
    
    if(dialogid == DIALOG_GARAGE_SETTINGS)
    {
        if(response)
        {
            new garageid = GetPlayerGarage(playerid);
            if(garageid == -1) return SendClientMessage(playerid, -1, "У вас нет гаража!");
            
            switch(listitem)
            {
                case 0: // Открыть/Закрыть
                {
                    new status = GetGarageData(garageid, GARAGE_STATUS);
                    new query[256];
                    
                    status = !status;
                    SetGarageData(garageid, GARAGE_STATUS, status);
                    
                    format(query, sizeof(query), "UPDATE garages SET lock=%d WHERE id=%d",
                        status, GetGarageData(garageid, GARAGE_ID)
                    );
                    mysql_query(mysql, query, false);
                    
                    UpdateGarageInfo(garageid);
                    SendClientMessage(playerid, -1, status ? ("Гараж {FF0000}закрыт{FFFFFF}!") : ("Гараж {00FF00}открыт{FFFFFF}!"));
                }
                case 1: callcmd::sellgarage(playerid, ""); // Продать гараж
                case 2: // Улучшения
                {
                    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 1)
                    {
                        Dialog(playerid, DIALOG_GARAGE_IMPROVEMENT, DIALOG_STYLE_LIST,
                            "{ff0000}Улучшения",
                            "1. Элитный гараж\t\t5.000.000 руб.\t{ff0000}нет",
                            "Далее", "Выйти"
                        );
                    }
                    else SendClientMessage(playerid, -1, "У вас уже элитный гараж!");
                }
                case 3: // Доставить транспорт
                {
                    ShowOwnableCarsDialog(playerid, 1);
                }
                case 4: // Отметить на GPS
                {
                    new Float:x = GetGarageData(garageid, GARAGE_X);
                    new Float:y = GetGarageData(garageid, GARAGE_Y);
                    new Float:z = GetGarageData(garageid, GARAGE_Z);
                    EnablePlayerGPS(playerid, 55, x, y, z, "Гараж отмечен на GPS");
                }
                case 5: // Продать игроку
                {
                    SendClientMessage(playerid, -1, "Используйте /sellmygarage [id] [цена]");
                }
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_OWNABLE_CAR_LOAD_GARAGE)
    {
        if(response)
        {
            new idx = GetPVarInt(playerid, "ownablecar_id");
            if(LoadCarGarage[playerid] == 0)
            {
                switch(listitem + 1)
                {
                    case 1:
                    {
                        new Float:x, Float:y, Float:z;
                        new Cache:result;
                        new query[100];
                        mysql_format(mysql, query, sizeof(query), "SELECT pos_x,pos_y,pos_z FROM ownable_cars WHERE id='%d'", idx);
                        result = mysql_query(mysql, query, true);
                        if(cache_num_rows())
                        {
                            x = cache_get_row_float(0, 0);
                            y = cache_get_row_float(0, 1);
                            z = cache_get_row_float(0, 2);
                        }
                        cache_delete(result);
                        EnablePlayerGPS(playerid, 55, x, y, z, "Транспорт отмечен на GPS");
                    }
                    case 3:
                    {
                        if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
                        {
                            if(LoadOwnableCar(idx, playerid) != -1)
                            {
                                PlayerOwnableCarInit(playerid);
                                SendClientMessage(playerid, 0x66CC33FF, "Транспорт загружен!");
                            }
                        }
                    }
                }
            }
            else
            {
                new garageid = GetPlayerGarage(playerid);
                switch(listitem + 1)
                {
                    case 1:
                    {
                        new Float:x = GetGarageData(garageid, GARAGE_X);
                        new Float:y = GetGarageData(garageid, GARAGE_Y);
                        new Float:z = GetGarageData(garageid, GARAGE_Z);
                        EnablePlayerGPS(playerid, 55, x, y, z, "Место загрузки отмечено");
                    }
                    case 2:
                    {
                        if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
                        {
                            if(LoadOwnableCar(idx, playerid) != -1)
                            {
                                PlayerOwnableCarInit(playerid);
                                SendClientMessage(playerid, 0x66CC33FF, "Транспорт загружен в гараж!");
                                LoadCarGarage[playerid] = 0;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            LoadCarGarage[playerid] = 0;
            if(GetPVarInt(playerid, "show_menu"))
            {
                DeletePVar(playerid, "show_menu");
                callcmd::car(playerid, "");
            }
        }
        return 1;
    }
    
    #if defined garage_OnDialogResponse
        return garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse garage_OnDialogResponse
#if defined garage_OnDialogResponse
    forward garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ==============================================
// COMMANDS
// ==============================================
CMD:garage(playerid, params[])
{
    #pragma unused params
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, -1, "У Вас нет гаража");
    
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}Номер: %d\nВладелец: %s\nСтатус: %s\nЦена: 30.000.000 руб",
        garageid,
        GetGarageData(garageid, G_OWNER_NAME),
        GetGarageData(garageid, GARAGE_STATUS) ? ("{CC3333}закрыт") : ("{66CC33}открыт")
    );
    Dialog(playerid, DIALOG_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}Информация о гараже", string, "Управление", "Выйти");
    return 1;
}

CMD:sellgarage(playerid, params[])
{
    #pragma unused params
    if(GetPlayerGarage(playerid) == -1) return SendClientMessage(playerid, -1, "У Вас нет гаража");
    
    Dialog(playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_MSGBOX,
        "{FFCD00}Продажа гаража",
        "Продать гараж государству?\nВозврат 70% стоимости.\nДля продажи игроку используйте /sellmygarage",
        "Да", "Нет"
    );
    return 1;
}

CMD:sellmygarage(playerid, params[])
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, -1, "У Вас нет гаража");
    
    new to_player, price;
    if(sscanf(params, "ud", to_player, price))
        return SendClientMessage(playerid, -1, "Используйте: /sellmygarage [id] [цена]");
    
    if(!IsPlayerConnected(to_player) || to_player == playerid)
        return SendClientMessage(playerid, -1, "Неверный игрок");
    
    if(price < 1) return SendClientMessage(playerid, -1, "Укажите цену");
    if(GetPlayerMoneyEx(to_player) < price) return SendClientMessage(playerid, -1, "У покупателя нет денег");
    
    SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_GARAGE, garageid, price);
    return 1;
}

CMD:addgarage(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    new idx = g_garage_loaded;
    new query[256];
    
    format(query, sizeof(query),
        "INSERT INTO garages (price, x, y, z, exit_x, exit_y, exit_z, exit_angle) VALUES (30000000, %f, %f, %f, %f, %f, %f, %f)",
        x, y, z, x, y, z, 0.0
    );
    mysql_query(mysql, query, false);
    
    SetGarageData(idx, GARAGE_ID, cache_insert_id());
    SetGarageData(idx, GARAGE_X, x);
    SetGarageData(idx, GARAGE_Y, y);
    SetGarageData(idx, GARAGE_Z, z);
    SetGarageData(idx, GARAGE_EXIT_X, x);
    SetGarageData(idx, GARAGE_EXIT_Y, y);
    SetGarageData(idx, GARAGE_EXIT_Z, z);
    SetGarageData(idx, GARAGE_EXIT_ANGLE, 0.0);
    g_garage_loaded++;
    
    CreatePickup(19134, 23, x, y, z, -1);
    SendClientMessage(playerid, -1, "Гараж создан! Используйте /gsetexitpos [id]");
    return 1;
}

CMD:gsetexitpos(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    
    new garageid;
    if(sscanf(params, "d", garageid)) return SendClientMessage(playerid, -1, "Используйте: /gsetexitpos [id]");
    if(garageid < 0 || garageid >= g_garage_loaded) return SendClientMessage(playerid, -1, "Неверный ID");
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    new query[256];
    format(query, sizeof(query),
        "UPDATE garages SET exit_x=%f,exit_y=%f,exit_z=%f,exit_angle=%f WHERE id=%d",
        x, y, z, a, GetGarageData(garageid, GARAGE_ID)
    );
    mysql_query(mysql, query, false);
    
    SetGarageData(garageid, GARAGE_EXIT_X, x);
    SetGarageData(garageid, GARAGE_EXIT_Y, y);
    SetGarageData(garageid, GARAGE_EXIT_Z, z);
    SetGarageData(garageid, GARAGE_EXIT_ANGLE, a);
    
    SendClientMessage(playerid, -1, "Позиция выхода установлена!");
    return 1;
}

CMD:asellgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, -1, "Нет прав");
    
    new garageid;
    if(sscanf(params, "d", garageid)) return SendClientMessage(playerid, -1, "Используйте: /asellgarage [id]");
    if(garageid < 1 || garageid > MAX_GARAGES) return SendClientMessage(playerid, -1, "Неверный ID");
    
    new query[256];
    new owner_id = 0;
    new owner_name[MAX_PLAYER_NAME];
    
    mysql_format(mysql, query, sizeof(query), "SELECT owner_id FROM garages WHERE id=%d", garageid);
    mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        owner_id = cache_get_field_content_int(0, "owner_id");
        if(owner_id > 0)
        {
            mysql_format(mysql, query, sizeof(query), "SELECT name FROM accounts WHERE id=%d", owner_id);
            mysql_query(mysql, query);
            if(cache_num_rows() > 0)
                cache_get_field_content(0, "name", owner_name, mysql, MAX_PLAYER_NAME);
        }
        
        mysql_format(mysql, query, sizeof(query), "UPDATE garages SET owner_id=0, lock=0, improvements=1 WHERE id=%d", garageid);
        mysql_query(mysql, query, false);
        
        if(owner_id > 0)
        {
            mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET garage=-1 WHERE id=%d", owner_id);
            mysql_query(mysql, query, false);
        }
        
        new idx = garageid - 1;
        if(idx >= 0 && idx < g_garage_loaded)
        {
            SetGarageData(idx, GARAGE_OWNER_ID, 0);
            SetGarageData(idx, GARAGE_STATUS, 0);
            SetGarageData(idx, GARAGE_IMPROVEMENTS, 1);
            format(g_garage[idx][G_OWNER_NAME], MAX_GARAGE_NAME, "None");
            UpdateGarageInfo(idx);
        }
        
        SendClientMessage(playerid, -1, "Гараж обнулен!");
        
        new msg[256];
        format(msg, sizeof(msg), "Администратор %s обнулил гараж %d игрока %s",
            GetPlayerNameEx(playerid), garageid, owner_id > 0 ? owner_name : "никто"
        );
        SendClientMessageToAll(-1, msg);
    }
    return 1;
}

// ==============================================
// ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ВЫХОДА ИЗ ГАРАЖА
// ==============================================
CMD:exitgarage(playerid, params[])
{
    #pragma unused params
    new garageid = GetPlayerInGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, -1, "Вы не в гараже");
    
    new Float:x, Float:y, Float:z, Float:a;
    x = GetGarageData(garageid, GARAGE_EXIT_X);
    y = GetGarageData(garageid, GARAGE_EXIT_Y);
    z = GetGarageData(garageid, GARAGE_EXIT_Z);
    a = GetGarageData(garageid, GARAGE_EXIT_ANGLE);
    
    SetPlayerPosEx(playerid, x, y, z, a, 0, 0, 0);
    SetPlayerInGarage(playerid, -1);
    return 1;
}

// ==============================================
// ОБРАБОТЧИК ВЫХОДА ИЗ ГАРАЖА (PICKUP)
// ==============================================
public OnPlayerPickUpPickup(playerid, pickupid)
{
    for(new i; i < g_garage_loaded; i++)
    {
        if(pickupid == GetGarageData(i, G_ENTER_PICKUP))
        {
            if(!IsGarageOwned(i) || GetGarageData(i, GARAGE_STATUS) == 0)
            {
                ShowPlayerGarageInfo(playerid, i);
            }
            else
            {
                SendClientMessage(playerid, -1, "Гараж закрыт!");
            }
            return 1;
        }
    }
    #if defined garage_OnPlayerPickUpPickup
        return garage_OnPlayerPickUpPickup(playerid, pickupid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define _ALS_OnPlayerPickUpPickup
#endif
#define OnPlayerPickUpPickup garage_OnPlayerPickUpPickup
#if defined garage_OnPlayerPickUpPickup
    forward garage_OnPlayerPickUpPickup(playerid, pickupid);
#endif