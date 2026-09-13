// ============================================================
// GARAGE SYSTEM
// Добавлен из присланной системы гаражей.
// ============================================================

#define MAX_GARAGES                (900)
#define GARAGE_DEFAULT_PRICE       (450000)
#define GARAGE_RENT_PRICE          (2500)
#define GARAGE_RENT_DAYS           (30)
#define GARAGE_VIRTUAL_WORLD_BASE  (1000)

#define DIALOG_PAY_FOR_RENT_GARAGE (28001)
#define DIALOG_GARAGE_BUY          (28002)
#define DIALOG_GARAGE_SELL         (28003)
#define DIALOG_GARAGE_INFO         (28004)
#define DIALOG_GARAGE_MENU         (28005)
#define DIALOG_GARAGE_UPGRADE      (28006)
#define DIALOG_GARAGE_UPGRADE_OK   (28007)

#define PICKUP_ACTION_TYPE_GARAGE      (221)
#define PICKUP_ACTION_TYPE_GARAGE_EXIT (222)

#define OFFER_TYPE_BUY_GARAGE (OFFER_TYPE_SELL_GARAGE)

enum E_GARAGE_STRUCT
{
    G_SQL_ID,
    G_OWNER_ID,
    G_RENT_DATE,
    G_RENT_PRICE,
    G_YLUCHENIE,
    G_PRICE,
    G_OPEN,
    G_ENTRACE,
    G_MAP_ICON,
    G_ENTER_PICKUP,
    Text3D: G_LABEL,
    G_OWNER_NAME[20 + 1],
    Float: G_POS_X,
    Float: G_POS_Y,
    Float: G_POS_Z,
    Float: G_EXIT_POS_X,
    Float: G_EXIT_POS_Y,
    Float: G_EXIT_POS_Z,
    Float: G_EXIT_ANGLE
};

new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];
new g_garage_loaded;

#define GetGarageData(%0,%1)       g_garage[%0][%1]
#define SetGarageData(%0,%1,%2)    g_garage[%0][%1] = %2
#define AddGarageData(%0,%1,%2,%3) g_garage[%0][%1] %2= %3
#define SetPlayerInGarage(%0,%1)   SetPlayerData(%0, P_IN_GARAGE, %1)

stock GetPlayerGarage(playerid)
{
    return GetPlayerData(playerid, P_GARAGE_TYPE);
}

stock IsGarageValid(garageid)
{
    return 0 <= garageid < g_garage_loaded;
}

stock IsGarageOwned(garageid)
{
    return IsGarageValid(garageid) && GetGarageData(garageid, G_OWNER_ID) > 0;
}

stock GarageVirtualWorld(garageid)
{
    return garageid + GARAGE_VIRTUAL_WORLD_BASE;
}

stock UpdateGarageInfo(garageid)
{
    if(!IsGarageValid(garageid)) return 0;

    new text[256];

    if(IsGarageOwned(garageid))
    {
        format(text, sizeof(text),
            "Гараж №%d\nВладелец: %s\nНажмите [гудок] для входа\n%s",
            GetGarageData(garageid, G_SQL_ID),
            GetGarageData(garageid, G_OWNER_NAME),
            GetGarageData(garageid, G_OPEN) ? ("Гараж закрыт") : ("Гараж открыт")
        );
    }
    else
    {
        format(text, sizeof(text),
            "Гараж №%d\nГараж продаётся\nЦена: %d руб.\nНажмите [гудок] для покупки",
            GetGarageData(garageid, G_SQL_ID),
            GetGarageData(garageid, G_PRICE)
        );
    }

    if(GetGarageData(garageid, G_LABEL) != Text3D:-1)
        UpdateDynamic3DTextLabelText(GetGarageData(garageid, G_LABEL), 0xFFFFFFFF, text);

    return 1;
}

stock CreateGaragePickup(garageid)
{
    if(!IsGarageValid(garageid)) return 0;

    new pickupid = n_CreatePickup(
        19134, 23,
        GetGarageData(garageid, G_POS_X),
        GetGarageData(garageid, G_POS_Y),
        GetGarageData(garageid, G_POS_Z),
        0,
        PICKUP_ACTION_TYPE_GARAGE,
        garageid
    );

    SetGarageData(garageid, G_ENTER_PICKUP, pickupid);
    return pickupid;
}

stock LoadGarage()
{
    new Cache: result;
    new rows;

    result = mysql_query(mysql,
        "SELECT g.*, IFNULL(a.name, '') AS owner_name FROM garage g LEFT JOIN accounts a ON a.id=g.owner_id"
    );

    if(mysql_errno(mysql) != 0)
    {
        printf("[Garage] Ошибка загрузки: %d", mysql_errno(mysql));
        return 0;
    }

    rows = cache_num_rows();
    if(rows > MAX_GARAGES) rows = MAX_GARAGES;

    for(new idx = 0; idx < rows; idx++)
    {
        SetGarageData(idx, G_SQL_ID, cache_get_field_content_int(idx, "id"));
        SetGarageData(idx, G_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));
        SetGarageData(idx, G_RENT_DATE, cache_get_field_content_int(idx, "rent_time"));
        SetGarageData(idx, G_RENT_PRICE, cache_get_field_content_int(idx, "rent"));
        SetGarageData(idx, G_YLUCHENIE, cache_get_field_content_int(idx, "uluchenie"));
        SetGarageData(idx, G_PRICE, cache_get_field_content_int(idx, "price"));
        SetGarageData(idx, G_OPEN, cache_get_field_content_int(idx, "open"));
        SetGarageData(idx, G_ENTRACE, cache_get_field_content_int(idx, "entrance"));
        SetGarageData(idx, G_MAP_ICON, cache_get_field_content_int(idx, "map_icon"));

        SetGarageData(idx, G_POS_X, cache_get_field_content_float(idx, "pos_x"));
        SetGarageData(idx, G_POS_Y, cache_get_field_content_float(idx, "pos_y"));
        SetGarageData(idx, G_POS_Z, cache_get_field_content_float(idx, "pos_z"));
        SetGarageData(idx, G_EXIT_POS_X, cache_get_field_content_float(idx, "exit_x"));
        SetGarageData(idx, G_EXIT_POS_Y, cache_get_field_content_float(idx, "exit_y"));
        SetGarageData(idx, G_EXIT_POS_Z, cache_get_field_content_float(idx, "exit_z"));
        SetGarageData(idx, G_EXIT_ANGLE, cache_get_field_content_float(idx, "exit_angle"));

        cache_get_field_content(idx, "owner_name", g_garage[idx][G_OWNER_NAME], mysql, 21);

        new label[256];
        if(IsGarageOwned(idx))
        {
            format(label, sizeof(label),
                "Гараж №%d\nВладелец: %s\nНажмите [гудок] для входа",
                GetGarageData(idx, G_SQL_ID),
                GetGarageData(idx, G_OWNER_NAME)
            );
        }
        else
        {
            format(label, sizeof(label),
                "Гараж №%d\nПродаётся за %d руб.\nНажмите [гудок]",
                GetGarageData(idx, G_SQL_ID),
                GetGarageData(idx, G_PRICE)
            );
        }

        SetGarageData(idx, G_LABEL,
            CreateDynamic3DTextLabel(
                label, 0xFFFFFFFF,
                GetGarageData(idx, G_POS_X),
                GetGarageData(idx, G_POS_Y),
                GetGarageData(idx, G_POS_Z) + 1.0,
                15.0
            )
        );

        CreateGaragePickup(idx);
    }

    g_garage_loaded = rows;
    cache_delete(result);

    // Выходы из интерьеров.
    n_CreatePickup(1318, 23, 492.701324, 1991.680786, 1547.679687, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT, -1);
    n_CreatePickup(1318, 23, 0.998209, 1994.307739, 1554.203125, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT, -1);

    printf("[Garage] Загружено гаражей: %d", g_garage_loaded);
    SetTimer("SellDebtorsGarage", 3600000, true);
    return 1;
}

stock CheckAndCreateGaragesTable()
{
    new query[1024];

    mysql_format(mysql, query, sizeof(query),
        "CREATE TABLE IF NOT EXISTS `garage` ("\
        "`id` INT NOT NULL AUTO_INCREMENT,"\
        "`owner_id` INT NOT NULL DEFAULT 0,"\
        "`rent_time` INT NOT NULL DEFAULT 0,"\
        "`rent` INT NOT NULL DEFAULT 2500,"\
        "`uluchenie` INT NOT NULL DEFAULT 0,"\
        "`price` INT NOT NULL DEFAULT 450000,"\
        "`open` INT NOT NULL DEFAULT 0,"\
        "`entrance` INT NOT NULL DEFAULT -1,"\
        "`map_icon` INT NOT NULL DEFAULT -1,"\
        "`pos_x` FLOAT NOT NULL DEFAULT 0,"\
        "`pos_y` FLOAT NOT NULL DEFAULT 0,"\
        "`pos_z` FLOAT NOT NULL DEFAULT 0,"\
        "`exit_x` FLOAT NOT NULL DEFAULT 0,"\
        "`exit_y` FLOAT NOT NULL DEFAULT 0,"\
        "`exit_z` FLOAT NOT NULL DEFAULT 0,"\
        "`exit_angle` FLOAT NOT NULL DEFAULT 0,"\
        "PRIMARY KEY (`id`)"\
        ") ENGINE=MyISAM DEFAULT CHARSET=utf8mb4"
    );
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof(query),
        "SHOW COLUMNS FROM `accounts` LIKE 'garage'"
    );
    mysql_query(mysql, query, true);

    if(cache_num_rows() == 0)
    {
        mysql_format(mysql, query, sizeof(query),
            "ALTER TABLE `accounts` ADD COLUMN `garage` INT NOT NULL DEFAULT -1"
        );
        mysql_query(mysql, query, false);
    }

    return 1;
}

forward GarageInitTimer();
public GarageInitTimer()
{
    CheckAndCreateGaragesTable();
    SetTimer("GarageLoadTimer", 1500, false);
    return 1;
}

forward GarageLoadTimer();
public GarageLoadTimer()
{
    LoadGarage();
    return 1;
}

stock EnterPlayerToGarage(playerid, garageid)
{
    if(!IsGarageValid(garageid)) return 0;
    if(GetGarageData(garageid, G_OPEN) && GetGarageData(garageid, G_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж закрыт владельцем.");

    SetPlayerInGarage(playerid, garageid);

    if(GetGarageData(garageid, G_YLUCHENIE) == 0)
    {
        SetPlayerPosEx(playerid, 1.387492, 1995.810791, 1554.203125, 180.0, 1, GarageVirtualWorld(garageid));
    }
    else
    {
        SetPlayerPosEx(playerid, 495.961517, 1989.867797, 1547.679687, 271.34, 1, GarageVirtualWorld(garageid));
    }

    return 1;
}

stock ExitPlayerGarage(playerid)
{
    new garageid = GetPlayerData(playerid, P_IN_GARAGE);
    if(!IsGarageValid(garageid)) return 0;

    SetPlayerPosEx(
        playerid,
        GetGarageData(garageid, G_EXIT_POS_X),
        GetGarageData(garageid, G_EXIT_POS_Y),
        GetGarageData(garageid, G_EXIT_POS_Z),
        GetGarageData(garageid, G_EXIT_ANGLE),
        0,
        0
    );

    SetPlayerInGarage(playerid, -1);
    return 1;
}

stock ShowPlayerGarageInfo(playerid, garageid)
{
    if(!IsGarageValid(garageid)) return 0;

    SetPlayerUseListitem(playerid, garageid);

    new text[512];

    if(IsGarageOwned(garageid))
    {
        format(text, sizeof(text),
            "{FFFFFF}Гараж №%d\nВладелец: {66CCFF}%s\n\n{FFFFFF}Цена: %d руб.\nАренда: %d руб./день\nСостояние: %s",
            GetGarageData(garageid, G_SQL_ID),
            GetGarageData(garageid, G_OWNER_NAME),
            GetGarageData(garageid, G_PRICE),
            GetGarageData(garageid, G_RENT_PRICE),
            GetGarageData(garageid, G_OPEN) ? ("закрыт") : ("открыт")
        );
        ShowPlayerDialog(playerid, DIALOG_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "Гараж", text, "Меню", "Закрыть");
    }
    else
    {
        format(text, sizeof(text),
            "{FFFFFF}Гараж №%d\n\nЦена покупки: {33CC00}%d руб.\nАренда: %d руб./день\n\nКупить гараж?",
            GetGarageData(garageid, G_SQL_ID),
            GetGarageData(garageid, G_PRICE),
            GetGarageData(garageid, G_RENT_PRICE)
        );
        ShowPlayerDialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "Покупка гаража", text, "Купить", "Отмена");
    }

    return 1;
}

stock ShowGarageMenu(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(!IsGarageValid(garageid))
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет гаража.");

    ShowPlayerDialog(
        playerid,
        DIALOG_GARAGE_MENU,
        DIALOG_STYLE_LIST,
        "Гараж",
        "Информация о гараже\nОплатить аренду\nОткрыть/закрыть гараж\nУлучшение гаража\nОтметить гараж на карте\nПродать государству\nПродать игроку",
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

stock BuyPlayerGarage(playerid, garageid, price = -1)
{
    if(!IsGarageValid(garageid) || IsGarageOwned(garageid))
        return 0;

    if(GetPlayerGarage(playerid) != -1)
        return -1;

    if(price < 0) price = GetGarageData(garageid, G_PRICE);

    if(GetPlayerMoneyEx(playerid) < price)
        return 0;

    new rent_time = (gettime() - (gettime() % 86400)) + 86400;
    new query[512];

    mysql_format(mysql, query, sizeof(query),
        "UPDATE accounts a, garage g SET a.garage=%d, g.owner_id=%d, g.owner_name='%e', g.rent_time=%d WHERE a.id=%d AND g.id=%d",
        garageid,
        GetPlayerAccountID(playerid),
        GetPlayerNameEx(playerid),
        rent_time,
        GetPlayerAccountID(playerid),
        GetGarageData(garageid, G_SQL_ID)
    );
    mysql_query(mysql, query, false);

    if(mysql_errno(mysql) != 0)
        return 0;

    GivePlayerMoneyEx(playerid, -price, "Покупка гаража", true, true);

    SetPlayerData(playerid, P_GARAGE_TYPE, garageid);
    SetGarageData(garageid, G_OWNER_ID, GetPlayerAccountID(playerid));
    SetGarageData(garageid, G_RENT_DATE, rent_time);
    format(g_garage[garageid][G_OWNER_NAME], 21, "%s", GetPlayerNameEx(playerid));
    UpdateGarageInfo(garageid);

    SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы приобрели гараж.");
    return 1;
}

stock SellGarageGos(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(!IsGarageValid(garageid)) return 0;

    new price = GetGarageData(garageid, G_PRICE);
    new return_money = (price * 70) / 100;
    new query[512];

    mysql_format(mysql, query, sizeof(query),
        "UPDATE accounts a, garage g SET a.garage=-1, g.owner_id=0, g.owner_name='', g.rent_time=0, g.open=0, g.uluchenie=0 WHERE a.id=%d AND g.id=%d",
        GetPlayerAccountID(playerid),
        GetGarageData(garageid, G_SQL_ID)
    );
    mysql_query(mysql, query, false);

    if(mysql_errno(mysql) != 0)
        return 0;

    GivePlayerMoneyEx(playerid, return_money, "Продажа гаража государству", true, false);

    SetPlayerData(playerid, P_GARAGE_TYPE, -1);
    SetGarageData(garageid, G_OWNER_ID, 0);
    SetGarageData(garageid, G_RENT_DATE, 0);
    SetGarageData(garageid, G_OPEN, 0);
    SetGarageData(garageid, G_YLUCHENIE, 0);
    g_garage[garageid][G_OWNER_NAME][0] = '\0';

    UpdateGarageInfo(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Вы продали гараж государству.");
    return 1;
}

stock SellGaragePlayer(sellerid, buyerid, price)
{
    new garageid = GetPlayerGarage(sellerid);
    if(!IsGarageValid(garageid)) return 0;
    if(GetPlayerGarage(buyerid) != -1) return -1;
    if(GetPlayerMoneyEx(buyerid) < price) return 0;

    new query[512];

    mysql_format(mysql, query, sizeof(query),
        "UPDATE accounts a1, accounts a2, garage g SET a1.garage=-1, a2.garage=%d, g.owner_id=%d, g.owner_name='%e' WHERE a1.id=%d AND a2.id=%d AND g.id=%d",
        garageid,
        GetPlayerAccountID(buyerid),
        GetPlayerNameEx(buyerid),
        GetPlayerAccountID(sellerid),
        GetPlayerAccountID(buyerid),
        GetGarageData(garageid, G_SQL_ID)
    );
    mysql_query(mysql, query, false);

    if(mysql_errno(mysql) != 0)
        return 0;

    GivePlayerMoneyEx(buyerid, -price, "Покупка гаража у игрока", true, true);
    GivePlayerMoneyEx(sellerid, price, "Продажа гаража игроку", true, true);

    SetPlayerData(sellerid, P_GARAGE_TYPE, -1);
    SetPlayerData(buyerid, P_GARAGE_TYPE, garageid);
    SetGarageData(garageid, G_OWNER_ID, GetPlayerAccountID(buyerid));
    format(g_garage[garageid][G_OWNER_NAME], 21, "%s", GetPlayerNameEx(buyerid));

    UpdateGarageInfo(garageid);

    SendClientMessage(sellerid, 0x66CC00FF, "Вы успешно продали гараж игроку.");
    SendClientMessage(buyerid, 0x66CC00FF, "Вы успешно приобрели гараж.");
    return 1;
}

stock ShowPlayerGaragePayForRent(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(!IsGarageValid(garageid)) return 0;

    new days = GetElapsedTime(GetGarageData(garageid, G_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS);
    if(days < 0) days = 0;

    new text[512];
    format(text, sizeof(text),
        "Гараж №%d\nОплачено дней: %d из %d\nСтоимость: %d руб./день\n\nВведите количество дней:",
        GetGarageData(garageid, G_SQL_ID),
        days,
        GARAGE_RENT_DAYS,
        GetGarageData(garageid, G_RENT_PRICE)
    );

    ShowPlayerDialog(playerid, DIALOG_PAY_FOR_RENT_GARAGE, DIALOG_STYLE_INPUT, "Оплата гаража", text, "Оплатить", "Назад");
    return 1;
}

stock SellDebtorsGarage()
{
    new query[512];

    for(new garageid = 0; garageid < g_garage_loaded; garageid++)
    {
        if(!IsGarageOwned(garageid)) continue;
        if(GetGarageData(garageid, G_RENT_DATE) >= gettime()) continue;

        new owner_id = GetGarageData(garageid, G_OWNER_ID);

        mysql_format(mysql, query, sizeof(query),
            "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1",
            owner_id
        );
        mysql_query(mysql, query, false);

        mysql_format(mysql, query, sizeof(query),
            "UPDATE garage SET owner_id=0, owner_name='', rent_time=0, open=0, uluchenie=0 WHERE id=%d LIMIT 1",
            GetGarageData(garageid, G_SQL_ID)
        );
        mysql_query(mysql, query, false);

        new owner_player = GetPlayerIDBySqlID(owner_id);
        if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
            SetPlayerData(owner_player, P_GARAGE_TYPE, -1);

        SetGarageData(garageid, G_OWNER_ID, 0);
        SetGarageData(garageid, G_RENT_DATE, 0);
        SetGarageData(garageid, G_OPEN, 0);
        SetGarageData(garageid, G_YLUCHENIE, 0);
        g_garage[garageid][G_OWNER_NAME][0] = '\0';

        UpdateGarageInfo(garageid);
    }

    return 1;
}

public OnGameModeInit()
{
    SetTimer("GarageInitTimer", 1000, false);

    #if defined garage_added_OnGameModeInit
        return garage_added_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit garage_added_OnGameModeInit
#if defined garage_added_OnGameModeInit
    forward garage_added_OnGameModeInit();
#endif

public OnPlayerSpawn(playerid)
{
    SetPlayerData(playerid, P_IN_GARAGE, -1);

    #if defined garage_added_OnPlayerSpawn
        return garage_added_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn garage_added_OnPlayerSpawn
#if defined garage_added_OnPlayerSpawn
    forward garage_added_OnPlayerSpawn(playerid);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
    SetPlayerData(playerid, P_IN_GARAGE, -1);

    #if defined garage_added_OnPlayerDeath
        return garage_added_OnPlayerDeath(playerid, killerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath garage_added_OnPlayerDeath
#if defined garage_added_OnPlayerDeath
    forward garage_added_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(action_type == PICKUP_ACTION_TYPE_GARAGE)
    {
        if(!IsGarageValid(action_id)) return 1;

        if(IsGarageOwned(action_id))
        {
            if(GetGarageData(action_id, G_OPEN) && GetGarageData(action_id, G_OWNER_ID) != GetPlayerAccountID(playerid))
                return SendClientMessage(playerid, 0xCECECEFF, "Гараж закрыт владельцем.");

            if(GetGarageData(action_id, G_OWNER_ID) == GetPlayerAccountID(playerid))
                return EnterPlayerToGarage(playerid, action_id);

            return SendClientMessage(playerid, 0xCECECEFF, "Этот гараж принадлежит другому игроку.");
        }

        return ShowPlayerGarageInfo(playerid, action_id);
    }

    if(action_type == PICKUP_ACTION_TYPE_GARAGE_EXIT)
    {
        return ExitPlayerGarage(playerid);
    }

    #if defined garage_added_OnPlayerPickUpPickupEx
        return garage_added_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx garage_added_OnPlayerPickUpPickupEx
#if defined garage_added_OnPlayerPickUpPickupEx
    forward garage_added_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_GARAGE_BUY)
    {
        if(response)
        {
            new garageid = GetPlayerUseListitem(playerid);
            if(BuyPlayerGarage(playerid, garageid) == 0)
                SendClientMessage(playerid, 0xCECECEFF, "Не удалось приобрести гараж. Проверьте деньги и наличие свободного гаража.");
        }
        return 1;
    }

    if(dialogid == DIALOG_GARAGE_INFO)
    {
        if(response) ShowGarageMenu(playerid);
        return 1;
    }

    if(dialogid == DIALOG_GARAGE_MENU)
    {
        if(!response) return 1;

        new garageid = GetPlayerGarage(playerid);
        if(!IsGarageValid(garageid)) return 1;

        switch(listitem)
        {
            case 0: ShowPlayerGarageInfo(playerid, garageid);
            case 1: ShowPlayerGaragePayForRent(playerid);
            case 2:
            {
                new new_open = !GetGarageData(garageid, G_OPEN);
                new query[256];

                mysql_format(mysql, query, sizeof(query),
                    "UPDATE garage SET open=%d WHERE id=%d LIMIT 1",
                    new_open,
                    GetGarageData(garageid, G_SQL_ID)
                );
                mysql_query(mysql, query, false);

                if(mysql_errno(mysql) == 0)
                {
                    SetGarageData(garageid, G_OPEN, new_open);
                    SendClientMessage(playerid, 0x66CC00FF, new_open ? "Гараж закрыт." : "Гараж открыт.");
                    UpdateGarageInfo(garageid);
                }
            }
            case 3:
            {
                ShowPlayerDialog(
                    playerid,
                    DIALOG_GARAGE_UPGRADE,
                    DIALOG_STYLE_MSGBOX,
                    "Улучшение гаража",
                    "Улучшение гаража стоит 5.000.000 руб.\nПосле покупки откроется улучшенный интерьер.",
                    "Купить",
                    "Назад"
                );
            }
            case 4:
            {
                EnablePlayerGPS(
                    playerid,
                    18,
                    GetGarageData(garageid, G_POS_X),
                    GetGarageData(garageid, G_POS_Y),
                    GetGarageData(garageid, G_POS_Z),
                    "Гараж"
                );
            }
            case 5:
            {
                ShowPlayerDialog(
                    playerid,
                    DIALOG_GARAGE_SELL,
                    DIALOG_STYLE_MSGBOX,
                    "Продажа гаража",
                    "Продать гараж государству?\nВы получите 70% от его стоимости.",
                    "Продать",
                    "Отмена"
                );
            }
            case 6:
            {
                ShowPlayerDialog(
                    playerid,
                    DIALOG_GARAGE_SELL,
                    DIALOG_STYLE_INPUT,
                    "Продажа гаража игроку",
                    "Введите: ID игрока и цену\nНапример: 12 500000",
                    "Продолжить",
                    "Отмена"
                );
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_GARAGE_SELL)
    {
        if(!response) return 1;

        // Если это MSGBOX — продаём государству.
        // Для INPUT разбираем ID игрока и цену.
        if(strfind(inputtext, " ") == -1)
        {
            SellGarageGos(playerid);
            return 1;
        }

        new buyerid, price;
        if(sscanf(inputtext, "ii", buyerid, price))
            return SendClientMessage(playerid, 0xCECECEFF, "Формат: ID игрока и цена.");

        if(!IsPlayerConnected(buyerid) || !IsPlayerLogged(buyerid) || buyerid == playerid)
            return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

        if(price < 1)
            return SendClientMessage(playerid, 0xCECECEFF, "Цена должна быть больше нуля.");

        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        if(!IsPlayerInRangeOfPoint(buyerid, 10.0, x, y, z))
            return SendClientMessage(playerid, 0xCECECEFF, "Покупатель должен находиться рядом.");

        if(GetPlayerGarage(buyerid) != -1)
            return SendClientMessage(playerid, 0xCECECEFF, "У покупателя уже есть гараж.");

        if(GetPlayerMoneyEx(buyerid) < price)
            return SendClientMessage(playerid, 0xCECECEFF, "У покупателя недостаточно денег.");

        SendPlayerOffer(playerid, buyerid, OFFER_TYPE_SELL_GARAGE, garageid, price);
        SetPVarInt(buyerid, "GarageSellerID", playerid);
        SetPVarInt(buyerid, "GaragePrice", price);
        SendClientMessage(playerid, 0x66CC00FF, "Предложение о покупке гаража отправлено игроку.");
        return 1;
    }

    if(dialogid == DIALOG_PAY_FOR_RENT_GARAGE)
    {
        if(!response) return 1;

        new garageid = GetPlayerGarage(playerid);
        if(!IsGarageValid(garageid)) return 1;

        new days = strval(inputtext);
        if(days < 1 || days > GARAGE_RENT_DAYS)
            return SendClientMessage(playerid, 0xCECECEFF, "Можно оплатить от 1 до 30 дней.");

        new total = days * GetGarageData(garageid, G_RENT_PRICE);
        if(GetPlayerBankMoney(playerid) < total)
            return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег на банковском счёте.");

        new rent_time = GetGarageData(garageid, G_RENT_DATE);
        if(rent_time < gettime()) rent_time = gettime();

        rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

        new query[256];
        mysql_format(mysql, query, sizeof(query),
            "UPDATE accounts SET bank=%d WHERE id=%d LIMIT 1",
            GetPlayerBankMoney(playerid) - total,
            GetPlayerAccountID(playerid)
        );
        mysql_query(mysql, query, false);

        mysql_format(mysql, query, sizeof(query),
            "UPDATE garage SET rent_time=%d WHERE id=%d LIMIT 1",
            rent_time,
            GetGarageData(garageid, G_SQL_ID)
        );
        mysql_query(mysql, query, false);

        if(mysql_errno(mysql) == 0)
        {
            AddPlayerData(playerid, P_BANK, -, total);
            SetGarageData(garageid, G_RENT_DATE, rent_time);
            SendClientMessage(playerid, 0x66CC00FF, "Аренда гаража успешно продлена.");
        }
        return 1;
    }

    if(dialogid == DIALOG_GARAGE_UPGRADE)
    {
        if(!response) return 1;

        new garageid = GetPlayerGarage(playerid);
        if(!IsGarageValid(garageid)) return 1;

        if(GetGarageData(garageid, G_YLUCHENIE) >= 1)
            return SendClientMessage(playerid, 0xCECECEFF, "Гараж уже улучшен.");

        if(GetPlayerMoneyEx(playerid) < 5000000)
            return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег. Нужно 5.000.000 руб.");

        new query[256];
        mysql_format(mysql, query, sizeof(query),
            "UPDATE garage SET uluchenie=1 WHERE id=%d LIMIT 1",
            GetGarageData(garageid, G_SQL_ID)
        );
        mysql_query(mysql, query, false);

        if(mysql_errno(mysql) == 0)
        {
            SetGarageData(garageid, G_YLUCHENIE, 1);
            GivePlayerMoneyEx(playerid, -5000000, "Улучшение гаража", true, true);
            SendClientMessage(playerid, 0x66CC00FF, "Гараж успешно улучшен.");
        }
        return 1;
    }

    #if defined garage_added_OnDialogResponse
        return garage_added_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse garage_added_OnDialogResponse
#if defined garage_added_OnDialogResponse
    forward garage_added_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

CMD:garage(playerid, params[])
{
    if(GetPlayerGarage(playerid) == -1)
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет гаража.");

    return ShowGarageMenu(playerid);
}

CMD:addgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new price;
    if(sscanf(params, "d", price))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addgarage [цена]");

    if(price < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "Цена должна быть больше нуля.");

    if(g_garage_loaded >= MAX_GARAGES)
        return SendClientMessage(playerid, 0xCECECEFF, "Достигнут лимит гаражей.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO garage (price,pos_x,pos_y,pos_z,exit_x,exit_y,exit_z,exit_angle) VALUES (%d,%f,%f,%f,%f,%f,%f,%f)",
        price, x, y, z, x, y, z, 0.0
    );

    new Cache: result = mysql_query(mysql, query, true);
    if(mysql_errno(mysql) != 0)
    {
        cache_delete(result);
        return SendClientMessage(playerid, 0xCECECEFF, "Ошибка создания гаража в базе данных.");
    }

    new idx = g_garage_loaded;
    SetGarageData(idx, G_SQL_ID, cache_insert_id());
    SetGarageData(idx, G_OWNER_ID, 0);
    SetGarageData(idx, G_PRICE, price);
    SetGarageData(idx, G_RENT_PRICE, GARAGE_RENT_PRICE);
    SetGarageData(idx, G_RENT_DATE, 0);
    SetGarageData(idx, G_YLUCHENIE, 0);
    SetGarageData(idx, G_OPEN, 0);
    SetGarageData(idx, G_POS_X, x);
    SetGarageData(idx, G_POS_Y, y);
    SetGarageData(idx, G_POS_Z, z);
    SetGarageData(idx, G_EXIT_POS_X, x);
    SetGarageData(idx, G_EXIT_POS_Y, y);
    SetGarageData(idx, G_EXIT_POS_Z, z);
    SetGarageData(idx, G_EXIT_ANGLE, 0.0);

    cache_delete(result);

    new label[256];
    format(label, sizeof(label), "Гараж №%d\nПродаётся за %d руб.\nНажмите [гудок]", GetGarageData(idx, G_SQL_ID), price);

    SetGarageData(idx, G_LABEL,
        CreateDynamic3DTextLabel(label, 0xFFFFFFFF, x, y, z + 1.0, 15.0)
    );

    CreateGaragePickup(idx);
    g_garage_loaded++;

    SendClientMessage(playerid, 0x66CC00FF, "Гараж создан. Установите точку выхода командой /gsetexitpos [ID].");
    return 1;
}

CMD:gsetexitpos(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new garageid;
    if(sscanf(params, "d", garageid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gsetexitpos [ID гаража]");

    if(!IsGarageValid(garageid))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого гаража нет.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE garage SET exit_x=%f,exit_y=%f,exit_z=%f,exit_angle=%f WHERE id=%d LIMIT 1",
        x, y, z, a, GetGarageData(garageid, G_SQL_ID)
    );
    mysql_query(mysql, query, false);

    if(mysql_errno(mysql) != 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Не удалось сохранить точку выхода.");

    SetGarageData(garageid, G_EXIT_POS_X, x);
    SetGarageData(garageid, G_EXIT_POS_Y, y);
    SetGarageData(garageid, G_EXIT_POS_Z, z);
    SetGarageData(garageid, G_EXIT_ANGLE, a);

    SendClientMessage(playerid, 0x66CC00FF, "Точка выхода гаража сохранена.");
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH))
    {
        if(GetPlayerData(playerid, P_IN_GARAGE) != -1)
            ExitPlayerGarage(playerid);
    }

    #if defined garage_added_OnPlayerKeyStateChange
        return garage_added_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange garage_added_OnPlayerKeyStateChange
#if defined garage_added_OnPlayerKeyStateChange
    forward garage_added_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif
