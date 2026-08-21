/*
    GUI-система гаражей
    Собрано из загруженного файла "гаражи.pwn" под текущий laird.pwn.

    Команды:
    /garage    - меню гаража игрока
    /addgarage - создать гараж на позиции администратора
*/

#if defined _garage_gui_included
    #endinput
#endif
#define _garage_gui_included

#if !defined MAX_GARAGES
    #define MAX_GARAGES (900)
#endif

#define GARAGE_DEFAULT_PRICE       (450000)
#define GARAGE_DEFAULT_RENT_PRICE  (2500)
#define GARAGE_UPGRADE_PRICE       (350000)
#define GARAGE_STATE_SELL_PERCENT  (60)
#define GARAGE_VIRTUAL_WORLD_BASE  (54000)
#define GARAGE_EXIT_KEY            KEY_CROUCH

#define GetPlayerGarage(%0)        GetPlayerData(%0, P_GARAGE)
#define SetPlayerGarage(%0,%1)     SetPlayerData(%0, P_GARAGE, %1)
#define GetPlayerInGarage(%0)      GetPlayerData(%0, P_IN_GARAGE)
#define SetPlayerInGarage(%0,%1)   SetPlayerData(%0, P_IN_GARAGE, %1)

#define GetGarageData(%0,%1)       g_garage[%0][%1]
#define IsGarageOwned(%0)          (GetGarageData(%0, GAR_OWNER_ID) > 0)

enum E_GARAGE_STRUCT
{
    GAR_SQL_ID,
    GAR_OWNER_ID,
    GAR_RENT_DATE,
    GAR_RENT_PRICE,
    GAR_UPGRADE,
    GAR_PRICE,
    bool:GAR_LOCK,
    GAR_PICKUP,
    Text3D:GAR_LABEL,
    GAR_OWNER_NAME[21],
    Float:GAR_POS_X,
    Float:GAR_POS_Y,
    Float:GAR_POS_Z,
    Float:GAR_EXIT_POS_X,
    Float:GAR_EXIT_POS_Y,
    Float:GAR_EXIT_POS_Z,
    Float:GAR_EXIT_ANGLE
};

new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];
new g_garage_loaded;

stock Garage_IsValid(garageid)
{
    return (0 <= garageid < g_garage_loaded);
}

stock Garage_Reset(garageid)
{
    g_garage[garageid][GAR_SQL_ID] = 0;
    g_garage[garageid][GAR_OWNER_ID] = 0;
    g_garage[garageid][GAR_RENT_DATE] = 0;
    g_garage[garageid][GAR_RENT_PRICE] = GARAGE_DEFAULT_RENT_PRICE;
    g_garage[garageid][GAR_UPGRADE] = 0;
    g_garage[garageid][GAR_PRICE] = GARAGE_DEFAULT_PRICE;
    g_garage[garageid][GAR_LOCK] = false;
    g_garage[garageid][GAR_PICKUP] = -1;
    g_garage[garageid][GAR_LABEL] = Text3D:-1;
    format(g_garage[garageid][GAR_OWNER_NAME], 21, "None");
    return 1;
}

stock Garage_GetRentDaysLeft(garageid)
{
    if(!Garage_IsValid(garageid)) return 0;

    new rent_time = GetGarageData(garageid, GAR_RENT_DATE);
    new now = gettime();

    if(rent_time <= now) return 0;
    return (rent_time - now) / 86400;
}

stock Garage_FormatLockStatus(garageid, output[], size = sizeof output)
{
    if(GetGarageData(garageid, GAR_LOCK))
        format(output, size, "{FF6666}закрыт");
    else
        format(output, size, "{66CC33}открыт");

    return 1;
}

stock Garage_FormatOwner(garageid, output[], size = sizeof output)
{
    if(IsGarageOwned(garageid))
        format(output, size, "%s", GetGarageData(garageid, GAR_OWNER_NAME));
    else
        format(output, size, "Свободен");

    return 1;
}

stock Garage_UpdateLabel(garageid)
{
    if(!Garage_IsValid(garageid)) return 0;

    if(GetGarageData(garageid, GAR_LABEL) != Text3D:-1)
    {
        DestroyDynamic3DTextLabel(GetGarageData(garageid, GAR_LABEL));
        g_garage[garageid][GAR_LABEL] = Text3D:-1;
    }

    new owner_text[32], lock_text[24], label_text[256];
    Garage_FormatOwner(garageid, owner_text, sizeof owner_text);
    Garage_FormatLockStatus(garageid, lock_text, sizeof lock_text);

    if(IsGarageOwned(garageid))
    {
        format
        (
            label_text, sizeof label_text,
            "{FFCD00}Гараж №%d\n{FFFFFF}Владелец: {66CCFF}%s\n{FFFFFF}Статус: %s\n{CCCCCC}Команда: /garage",
            garageid + 1,
            owner_text,
            lock_text
        );
    }
    else
    {
        format
        (
            label_text, sizeof label_text,
            "{FFCD00}Гараж №%d\n{FFFFFF}Свободен\n{FFFFFF}Цена: {66CC33}%d руб\n{CCCCCC}Подойдите к пикапу для покупки",
            garageid + 1,
            GetGarageData(garageid, GAR_PRICE)
        );
    }

    g_garage[garageid][GAR_LABEL] = CreateDynamic3DTextLabel(label_text, 0xFFFFFFFF,
            GetGarageData(garageid, GAR_POS_X),
            GetGarageData(garageid, GAR_POS_Y),
            GetGarageData(garageid, GAR_POS_Z) + 1.0,
            15.0);
    return 1;
}

stock Garage_CreateWorld(garageid)
{
    if(!Garage_IsValid(garageid)) return 0;

    g_garage[garageid][GAR_PICKUP] = CreatePickup(1273, 23,
            GetGarageData(garageid, GAR_POS_X),
            GetGarageData(garageid, GAR_POS_Y),
            GetGarageData(garageid, GAR_POS_Z),
            0,
            PICKUP_ACTION_TYPE_GARAGE,
            garageid);

    Garage_UpdateLabel(garageid);
    return 1;
}

stock Garage_LoadAll()
{
    new Cache:result = mysql_query(mysql, "SELECT g.*, IFNULL(a.name, 'None') owner_name FROM garage g LEFT JOIN accounts a ON a.id = g.owner_id", true);
    new rows = cache_num_rows();

    if(rows > MAX_GARAGES)
    {
        rows = MAX_GARAGES;
        print("[Garages]: DB rows > MAX_GARAGES");
    }

    g_garage_loaded = rows;

    for(new idx = 0; idx < rows; idx++)
    {
        Garage_Reset(idx);

        g_garage[idx][GAR_SQL_ID] = cache_get_field_content_int(idx, "id");
        g_garage[idx][GAR_OWNER_ID] = cache_get_field_content_int(idx, "owner_id");
        g_garage[idx][GAR_RENT_DATE] = cache_get_field_content_int(idx, "rent_time");
        g_garage[idx][GAR_RENT_PRICE] = cache_get_field_content_int(idx, "rent_price");
        g_garage[idx][GAR_UPGRADE] = cache_get_field_content_int(idx, "uluchenie");
        g_garage[idx][GAR_PRICE] = cache_get_field_content_int(idx, "price");
        g_garage[idx][GAR_LOCK] = bool:cache_get_field_content_int(idx, "open");

        if(GetGarageData(idx, GAR_PRICE) <= 0) g_garage[idx][GAR_PRICE] = GARAGE_DEFAULT_PRICE;
        if(GetGarageData(idx, GAR_RENT_PRICE) <= 0) g_garage[idx][GAR_RENT_PRICE] = GARAGE_DEFAULT_RENT_PRICE;

        g_garage[idx][GAR_POS_X] = cache_get_field_content_float(idx, "pos_x");
        g_garage[idx][GAR_POS_Y] = cache_get_field_content_float(idx, "pos_y");
        g_garage[idx][GAR_POS_Z] = cache_get_field_content_float(idx, "pos_z");
        g_garage[idx][GAR_EXIT_POS_X] = cache_get_field_content_float(idx, "exit_x");
        g_garage[idx][GAR_EXIT_POS_Y] = cache_get_field_content_float(idx, "exit_y");
        g_garage[idx][GAR_EXIT_POS_Z] = cache_get_field_content_float(idx, "exit_z");
        g_garage[idx][GAR_EXIT_ANGLE] = cache_get_field_content_float(idx, "exit_angle");

        cache_get_field_content(idx, "owner_name", g_garage[idx][GAR_OWNER_NAME], mysql, 21);
        if(!IsGarageOwned(idx)) format(g_garage[idx][GAR_OWNER_NAME], 21, "None");

        Garage_CreateWorld(idx);
    }

    cache_delete(result);

    CreateDynamic3DTextLabel("{FFCD00}Выход из гаража\n{FFFFFF}Клавиша: {0095FF}H", -1, 1.2011, 1994.7356, 1554.2031, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{FFCD00}Выезд из гаража\n{FFFFFF}Клавиша: {0095FF}H", -1, -0.2940, 2006.1187, 1554.2031, 9.0, _, _, _, -1, -1);

    printf("[Garages]: Загружено гаражей: %d", g_garage_loaded);
    return 1;
}

stock Garage_GetPlayerOwned(playerid)
{
    new garageid = GetPlayerGarage(playerid);

    if(Garage_IsValid(garageid) && GetGarageData(garageid, GAR_OWNER_ID) == GetPlayerAccountID(playerid))
        return garageid;

    for(new i = 0; i < g_garage_loaded; i++)
    {
        if(GetGarageData(i, GAR_OWNER_ID) == GetPlayerAccountID(playerid))
        {
            SetPlayerGarage(playerid, i);
            return i;
        }
    }

    SetPlayerGarage(playerid, -1);
    return -1;
}

stock Garage_IsPlayerNearOutside(playerid, garageid, Float:radius = 5.0)
{
    if(!Garage_IsValid(garageid)) return 0;
    return IsPlayerInRangeOfPoint(playerid, radius,
        GetGarageData(garageid, GAR_POS_X),
        GetGarageData(garageid, GAR_POS_Y),
        GetGarageData(garageid, GAR_POS_Z));
}

stock Garage_IsPlayerNearInsideExit(playerid, Float:radius = 6.0)
{
    if(IsPlayerInRangeOfPoint(playerid, radius, 1.2011, 1994.7356, 1554.2031)) return 1;
    if(IsPlayerInRangeOfPoint(playerid, radius, -0.2940, 2006.1187, 1554.2031)) return 1;
    return 0;
}

stock Garage_ShowBuy(playerid, garageid)
{
    if(!Garage_IsValid(garageid)) return 1;
    if(IsGarageOwned(garageid)) return Garage_ShowVisitorInfo(playerid, garageid);

    SetPVarInt(playerid, "garage_dialog_id", garageid);

    new text[512];
    format
    (
        text, sizeof text,
        "{FFFFFF}Гараж №{FFCD00}%d\n"\
        "{FFFFFF}Цена: {66CC33}%d руб\n"\
        "{FFFFFF}Аренда: {66CC33}%d руб/день\n\n"\
        "{CCCCCC}После покупки гараж будет оплачен на 7 дней.",
        garageid + 1,
        GetGarageData(garageid, GAR_PRICE),
        GetGarageData(garageid, GAR_RENT_PRICE)
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_BUY, DIALOG_STYLE_MSGBOX, "{FFCD00}Покупка гаража", text, "Купить", "Отмена");
}

stock Garage_ShowVisitorInfo(playerid, garageid)
{
    if(!Garage_IsValid(garageid)) return 1;

    new owner_text[32], lock_text[24], text[512];
    Garage_FormatOwner(garageid, owner_text, sizeof owner_text);
    Garage_FormatLockStatus(garageid, lock_text, sizeof lock_text);

    format
    (
        text, sizeof text,
        "{FFFFFF}Гараж №{FFCD00}%d\n"\
        "{FFFFFF}Владелец: {66CCFF}%s\n"\
        "{FFFFFF}Статус: %s\n"\
        "{FFFFFF}Оплачено дней: {FFCD00}%d\n"\
        "{FFFFFF}Улучшение: {FFCD00}%s",
        garageid + 1,
        owner_text,
        lock_text,
        Garage_GetRentDaysLeft(garageid),
        GetGarageData(garageid, GAR_UPGRADE) ? ("есть") : ("нет")
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}Информация о гараже", text, "Закрыть", "");
}

stock Garage_ShowInfo(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет гаража");

    new lock_text[24], text[768];
    Garage_FormatLockStatus(garageid, lock_text, sizeof lock_text);

    format
    (
        text, sizeof text,
        "{FFFFFF}Номер гаража:\t\t{FFCD00}%d\n"\
        "{FFFFFF}Статус:\t\t\t%s\n"\
        "{FFFFFF}Оплачено дней:\t\t{FFCD00}%d\n"\
        "{FFFFFF}Ежедневная аренда:\t{66CC33}%d руб\n"\
        "{FFFFFF}Улучшение:\t\t{FFCD00}%s\n"\
        "{FFFFFF}Гос. продажа:\t\t{66CC33}%d руб",
        garageid + 1,
        lock_text,
        Garage_GetRentDaysLeft(garageid),
        GetGarageData(garageid, GAR_RENT_PRICE),
        GetGarageData(garageid, GAR_UPGRADE) ? ("есть") : ("нет"),
        (GetGarageData(garageid, GAR_PRICE) * GARAGE_STATE_SELL_PERCENT) / 100
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}Мой гараж", text, "Назад", "Закрыть");
}

stock Garage_ShowMain(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет гаража");

    new lock_text[24], text[2048];
    Garage_FormatLockStatus(garageid, lock_text, sizeof lock_text);

    format
    (
        text, sizeof text,
        "Действие\tИнформация\n"\
        "Информация\tГараж №%d | %s\n"\
        "Войти пешком\tПодойдите к пикапу гаража\n"\
        "Загрузить транспорт\tВъезд на личном авто\n"\
        "Открыть / закрыть\tСейчас: %s\n"\
        "Оплатить аренду\tОплачено: %d дней\n"\
        "Улучшить гараж\tСтоимость: %d руб\n"\
        "Продать государству\tВозврат: %d руб\n"\
        "Продать игроку\tВведите ID и цену",
        garageid + 1,
        GetGarageData(garageid, GAR_UPGRADE) ? ("улучшенный") : ("обычный"),
        lock_text,
        Garage_GetRentDaysLeft(garageid),
        GARAGE_UPGRADE_PRICE,
        (GetGarageData(garageid, GAR_PRICE) * GARAGE_STATE_SELL_PERCENT) / 100
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Управление гаражом", text, "Выбрать", "Закрыть");
}

stock Garage_Buy(playerid, garageid)
{
    if(!Garage_IsValid(garageid)) return 1;
    if(IsGarageOwned(garageid)) return SendClientMessage(playerid, 0xCECECEFF, "Этот гараж уже куплен");
    if(Garage_GetPlayerOwned(playerid) != -1) return SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть гараж");

    new price = GetGarageData(garageid, GAR_PRICE);
    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки гаража");

    new rent_time = gettime() + 7 * 86400;
    new query[256];

    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET garage=%d WHERE id=%d LIMIT 1",
        garageid,
        GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE garage SET owner_id=%d, rent_time=%d, `open`=0 WHERE id=%d LIMIT 1",
        GetPlayerAccountID(playerid),
        rent_time,
        GetGarageData(garageid, GAR_SQL_ID));
    mysql_query(mysql, query, false);

    if(mysql_errno())
        return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения гаража в базе данных. Проверьте sql/garages_gui.sql");

    GivePlayerMoneyEx(playerid, -price, "Покупка гаража", false, true);
    SetPlayerGarage(playerid, garageid);
    g_garage[garageid][GAR_OWNER_ID] = GetPlayerAccountID(playerid);
    g_garage[garageid][GAR_RENT_DATE] = rent_time;
    g_garage[garageid][GAR_LOCK] = false;
    format(g_garage[garageid][GAR_OWNER_NAME], 21, "%s", GetPlayerNameEx(playerid));

    Garage_UpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы приобрели гараж. Управление: /garage");
    return 1;
}

stock Garage_ToggleLock(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    g_garage[garageid][GAR_LOCK] = !GetGarageData(garageid, GAR_LOCK);

    new query[128];
    mysql_format(mysql, query, sizeof query,
        "UPDATE garage SET `open`=%d WHERE id=%d LIMIT 1",
        GetGarageData(garageid, GAR_LOCK),
        GetGarageData(garageid, GAR_SQL_ID));
    mysql_query(mysql, query, false);

    Garage_UpdateLabel(garageid);

    if(GetGarageData(garageid, GAR_LOCK))
        SendClientMessage(playerid, 0xFFCC00FF, "Гараж закрыт");
    else
        SendClientMessage(playerid, 0x66CC00FF, "Гараж открыт");

    return Garage_ShowMain(playerid);
}

stock Garage_Enter(playerid, bool:with_vehicle = false)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    if(!Garage_IsPlayerNearOutside(playerid, garageid, 7.0))
        return SendClientMessage(playerid, 0xCECECEFF, "Подойдите к своему гаражу");

    new world = GARAGE_VIRTUAL_WORLD_BASE + garageid;

    if(with_vehicle)
    {
        if(!IsPlayerInAnyVehicle(playerid) || !IsPlayerDriver(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "Сядьте за руль личного транспорта");

        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid == 0 || vehicleid != GetPlayerOwnableCar(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "В гараж можно загрузить только свой личный транспорт");

        SetPlayerInGarage(playerid, garageid);
        SetPlayerPosEx(playerid, -0.292650, 2000.242065, 1553.358764, 355.240234, 1, world);
        SetVehiclePos(vehicleid, -0.292650, 2000.242065, 1553.358764);
        SetVehicleZAngle(vehicleid, 355.240234);
        LinkVehicleToInterior(vehicleid, 1);
        SetVehicleVirtualWorld(vehicleid, world);
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }
    else
    {
        SetPlayerInGarage(playerid, garageid);
        SetPlayerPosEx(playerid, 1.2011, 1994.7356, 1554.2031, 180.0, 1, world);
    }

    SendClientMessage(playerid, 0x66CC00FF, "Вы вошли в гараж. Для выхода нажмите H у выхода");
    return 1;
}

stock Garage_Exit(playerid)
{
    new garageid = GetPlayerInGarage(playerid);
    if(!Garage_IsValid(garageid)) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid != 0 && IsPlayerDriver(playerid))
    {
        SetVehiclePos(vehicleid,
            GetGarageData(garageid, GAR_EXIT_POS_X),
            GetGarageData(garageid, GAR_EXIT_POS_Y),
            GetGarageData(garageid, GAR_EXIT_POS_Z));
        SetVehicleZAngle(vehicleid, GetGarageData(garageid, GAR_EXIT_ANGLE));
        LinkVehicleToInterior(vehicleid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
    }

    SetPlayerPosEx(playerid,
        GetGarageData(garageid, GAR_EXIT_POS_X),
        GetGarageData(garageid, GAR_EXIT_POS_Y),
        GetGarageData(garageid, GAR_EXIT_POS_Z),
        GetGarageData(garageid, GAR_EXIT_ANGLE),
        0,
        0);

    SetPlayerInGarage(playerid, -1);

    if(vehicleid != 0 && IsPlayerDriver(playerid))
        PutPlayerInVehicle(playerid, vehicleid, 0);

    return 1;
}

stock Garage_ShowPayRent(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    new text[512];
    format
    (
        text, sizeof text,
        "{FFFFFF}Гараж №{FFCD00}%d\n"\
        "{FFFFFF}Оплачено дней: {FFCD00}%d из 30\n"\
        "{FFFFFF}Ежедневная аренда: {66CC33}%d руб\n\n"\
        "{FFFFFF}Введите количество дней для оплаты:",
        garageid + 1,
        Garage_GetRentDaysLeft(garageid),
        GetGarageData(garageid, GAR_RENT_PRICE)
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_PAY_RENT, DIALOG_STYLE_INPUT, "{FFCD00}Оплата гаража", text, "Оплатить", "Назад");
}

stock Garage_PayRent(playerid, days)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    if(days <= 0) return Garage_ShowPayRent(playerid);

    new days_left = Garage_GetRentDaysLeft(garageid);
    if(days_left + days > 30)
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж можно оплатить максимум на 30 дней вперед");

    new price = GetGarageData(garageid, GAR_RENT_PRICE) * days;
    if(GetPlayerBankMoney(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег на банковском счете");

    new rent_time = GetGarageData(garageid, GAR_RENT_DATE);
    if(rent_time < gettime()) rent_time = gettime();
    rent_time += days * 86400;

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET bank=%d WHERE id=%d LIMIT 1",
        GetPlayerBankMoney(playerid) - price,
        GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE garage SET rent_time=%d WHERE id=%d LIMIT 1",
        rent_time,
        GetGarageData(garageid, GAR_SQL_ID));
    mysql_query(mysql, query, false);

    AddPlayerData(playerid, P_BANK, -, price);
    g_garage[garageid][GAR_RENT_DATE] = rent_time;

    new message[128];
    format(message, sizeof message, "Вы оплатили гараж на %d дней. С банка списано %d руб", days, price);
    SendClientMessage(playerid, 0x66CC00FF, message);
    return Garage_ShowMain(playerid);
}

stock Garage_ShowUpgrade(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    if(GetGarageData(garageid, GAR_UPGRADE) > 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж уже улучшен");

    new text[512];
    format
    (
        text, sizeof text,
        "{FFFFFF}Улучшение гаража открывает расширенный статус в меню и готовит систему под второй слот/доп. интерьер.\n\n"\
        "{FFFFFF}Стоимость: {66CC33}%d руб\n"\
        "{FFFFFF}Оплата списывается с наличных.",
        GARAGE_UPGRADE_PRICE
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_UPGRADE, DIALOG_STYLE_MSGBOX, "{FFCD00}Улучшение гаража", text, "Купить", "Назад");
}

stock Garage_Upgrade(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    if(GetGarageData(garageid, GAR_UPGRADE) > 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж уже улучшен");

    if(GetPlayerMoneyEx(playerid) < GARAGE_UPGRADE_PRICE)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег");

    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE garage SET uluchenie=1 WHERE id=%d LIMIT 1", GetGarageData(garageid, GAR_SQL_ID));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, -GARAGE_UPGRADE_PRICE, "Улучшение гаража", false, true);
    g_garage[garageid][GAR_UPGRADE] = 1;
    Garage_UpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Гараж успешно улучшен");
    return Garage_ShowMain(playerid);
}

stock Garage_ShowSellState(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    new price = (GetGarageData(garageid, GAR_PRICE) * GARAGE_STATE_SELL_PERCENT) / 100;
    new text[512];
    format
    (
        text, sizeof text,
        "{FFFFFF}Вы действительно хотите продать гараж государству?\n\n"\
        "{FFFFFF}Гараж №{FFCD00}%d\n"\
        "{FFFFFF}Вы получите: {66CC33}%d руб\n\n"\
        "{FF6666}Действие нельзя отменить.",
        garageid + 1,
        price
    );

    return Dialog(playerid, DIALOG_GARAGE_GUI_SELL_STATE, DIALOG_STYLE_MSGBOX, "{FFCD00}Продажа гаража", text, "Продать", "Назад");
}

stock Garage_SellState(playerid)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    new price = (GetGarageData(garageid, GAR_PRICE) * GARAGE_STATE_SELL_PERCENT) / 100;
    new query[256];

    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1",
        GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE garage SET owner_id=0, rent_time=0, uluchenie=0, `open`=0 WHERE id=%d LIMIT 1",
        GetGarageData(garageid, GAR_SQL_ID));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, price, "Продажа гаража государству", false, true);
    SetPlayerGarage(playerid, -1);
    g_garage[garageid][GAR_OWNER_ID] = 0;
    g_garage[garageid][GAR_RENT_DATE] = 0;
    g_garage[garageid][GAR_UPGRADE] = 0;
    g_garage[garageid][GAR_LOCK] = false;
    format(g_garage[garageid][GAR_OWNER_NAME], 21, "None");
    Garage_UpdateLabel(garageid);

    SendClientMessage(playerid, 0x66CC00FF, "Гараж продан государству");
    return 1;
}

stock Garage_ShowSellPlayer(playerid)
{
    if(Garage_GetPlayerOwned(playerid) == -1) return 1;

    return Dialog(playerid, DIALOG_GARAGE_GUI_SELL_PLAYER, DIALOG_STYLE_INPUT,
        "{FFCD00}Продажа гаража игроку",
        "{FFFFFF}Введите ID игрока и цену через пробел.\n\n{CCCCCC}Пример: 15 500000",
        "Предложить", "Назад");
}

stock Garage_SendSellOffer(playerid, to_player, price)
{
    new garageid = Garage_GetPlayerOwned(playerid);
    if(garageid == -1) return 1;

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден");

    if(to_player == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя продать гараж самому себе");

    if(Garage_GetPlayerOwned(to_player) != -1)
        return SendClientMessage(playerid, 0xCECECEFF, "У игрока уже есть гараж");

    if(price <= 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Укажите корректную цену");

    if(GetPlayerMoneyEx(to_player) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "У игрока недостаточно денег");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(to_player, 5.0, x, y, z))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок должен быть рядом с Вами");

    SetPVarInt(to_player, "garage_offer_seller", playerid);
    SetPVarInt(to_player, "garage_offer_id", garageid);
    SetPVarInt(to_player, "garage_offer_price", price);

    new text[512];
    format(text, sizeof text,
        "{FFFFFF}%s предлагает Вам купить гараж №{FFCD00}%d {FFFFFF}за {66CC33}%d руб.\n\n{FFFFFF}Вы согласны?",
        GetPlayerNameEx(playerid),
        garageid + 1,
        price);

    Dialog(to_player, DIALOG_GARAGE_GUI_ACCEPT_OFFER, DIALOG_STYLE_MSGBOX, "{FFCD00}Покупка гаража у игрока", text, "Купить", "Отмена");

    format(text, sizeof text, "Вы предложили %s купить Ваш гараж за %d руб", GetPlayerNameEx(to_player), price);
    SendClientMessage(playerid, 0x66CC00FF, text);
    return 1;
}

stock Garage_AcceptSellOffer(playerid)
{
    new seller = GetPVarInt(playerid, "garage_offer_seller");
    new garageid = GetPVarInt(playerid, "garage_offer_id");
    new price = GetPVarInt(playerid, "garage_offer_price");

    DeletePVar(playerid, "garage_offer_seller");
    DeletePVar(playerid, "garage_offer_id");
    DeletePVar(playerid, "garage_offer_price");

    if(!IsPlayerConnected(seller) || !IsPlayerLogged(seller))
        return SendClientMessage(playerid, 0xCECECEFF, "Продавец вышел из игры");

    if(!Garage_IsValid(garageid) || GetGarageData(garageid, GAR_OWNER_ID) != GetPlayerAccountID(seller))
        return SendClientMessage(playerid, 0xCECECEFF, "Предложение больше не актуально");

    if(Garage_GetPlayerOwned(playerid) != -1)
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть гараж");

    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег");

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1",
        GetPlayerAccountID(seller));
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET garage=%d WHERE id=%d LIMIT 1",
        garageid,
        GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE garage SET owner_id=%d WHERE id=%d LIMIT 1",
        GetPlayerAccountID(playerid),
        GetGarageData(garageid, GAR_SQL_ID));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, -price, "Покупка гаража у игрока", false, true);
    GivePlayerMoneyEx(seller, price, "Продажа гаража игроку", false, true);

    SetPlayerGarage(seller, -1);
    SetPlayerGarage(playerid, garageid);
    g_garage[garageid][GAR_OWNER_ID] = GetPlayerAccountID(playerid);
    format(g_garage[garageid][GAR_OWNER_NAME], 21, "%s", GetPlayerNameEx(playerid));
    Garage_UpdateLabel(garageid);

    SendClientMessage(playerid, 0x66CC00FF, "Вы купили гараж");
    SendClientMessage(seller, 0x66CC00FF, "Игрок принял предложение. Гараж продан");
    return 1;
}

stock Garage_Add(playerid)
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно прав для создания гаража");

    if(g_garage_loaded >= MAX_GARAGES)
        return SendClientMessage(playerid, 0xCECECEFF, "Достигнут лимит гаражей");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO garage (owner_id, price, rent_price, rent_time, uluchenie, `open`, pos_x, pos_y, pos_z, exit_x, exit_y, exit_z, exit_angle) VALUES (0,%d,%d,0,0,0,%f,%f,%f,%f,%f,%f,%f)",
        GARAGE_DEFAULT_PRICE,
        GARAGE_DEFAULT_RENT_PRICE,
        x, y, z,
        x, y, z,
        a);
    mysql_query(mysql, query, false);

    if(mysql_errno())
        return SendClientMessage(playerid, 0xFF6600FF, "Ошибка создания гаража. Проверьте таблицу garage");

    new idx = g_garage_loaded;
    Garage_Reset(idx);
    g_garage[idx][GAR_SQL_ID] = cache_insert_id();
    g_garage[idx][GAR_PRICE] = GARAGE_DEFAULT_PRICE;
    g_garage[idx][GAR_RENT_PRICE] = GARAGE_DEFAULT_RENT_PRICE;
    g_garage[idx][GAR_POS_X] = x;
    g_garage[idx][GAR_POS_Y] = y;
    g_garage[idx][GAR_POS_Z] = z;
    g_garage[idx][GAR_EXIT_POS_X] = x;
    g_garage[idx][GAR_EXIT_POS_Y] = y;
    g_garage[idx][GAR_EXIT_POS_Z] = z;
    g_garage[idx][GAR_EXIT_ANGLE] = a;

    g_garage_loaded++;
    Garage_CreateWorld(idx);

    new message[96];
    format(message, sizeof message, "Создан гараж №%d", idx + 1);
    SendClientMessage(playerid, 0x66CC00FF, message);
    return 1;
}

stock Garage_HandleMain(playerid, listitem)
{
    switch(listitem)
    {
        case 0: return Garage_ShowInfo(playerid);
        case 1: return Garage_Enter(playerid, false);
        case 2: return Garage_Enter(playerid, true);
        case 3: return Garage_ToggleLock(playerid);
        case 4: return Garage_ShowPayRent(playerid);
        case 5: return Garage_ShowUpgrade(playerid);
        case 6: return Garage_ShowSellState(playerid);
        case 7: return Garage_ShowSellPlayer(playerid);
    }
    return 1;
}

stock GarageGUI_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_GARAGE_GUI_MAIN:
        {
            if(!response) return 1;
            return Garage_HandleMain(playerid, listitem);
        }
        case DIALOG_GARAGE_GUI_INFO:
        {
            if(response && Garage_GetPlayerOwned(playerid) != -1) return Garage_ShowMain(playerid);
            return 1;
        }
        case DIALOG_GARAGE_GUI_BUY:
        {
            if(!response) return 1;
            return Garage_Buy(playerid, GetPVarInt(playerid, "garage_dialog_id"));
        }
        case DIALOG_GARAGE_GUI_PAY_RENT:
        {
            if(!response) return Garage_ShowMain(playerid);
            if(!IsNumeric(inputtext)) return Garage_ShowPayRent(playerid);
            return Garage_PayRent(playerid, strval(inputtext));
        }
        case DIALOG_GARAGE_GUI_UPGRADE:
        {
            if(!response) return Garage_ShowMain(playerid);
            return Garage_Upgrade(playerid);
        }
        case DIALOG_GARAGE_GUI_SELL_STATE:
        {
            if(!response) return Garage_ShowMain(playerid);
            return Garage_SellState(playerid);
        }
        case DIALOG_GARAGE_GUI_SELL_PLAYER:
        {
            if(!response) return Garage_ShowMain(playerid);

            new to_player, price;
            if(sscanf(inputtext, "ui", to_player, price))
                return Garage_ShowSellPlayer(playerid);

            return Garage_SendSellOffer(playerid, to_player, price);
        }
        case DIALOG_GARAGE_GUI_ACCEPT_OFFER:
        {
            if(!response)
            {
                DeletePVar(playerid, "garage_offer_seller");
                DeletePVar(playerid, "garage_offer_id");
                DeletePVar(playerid, "garage_offer_price");
                return 1;
            }
            return Garage_AcceptSellOffer(playerid);
        }
    }
    return 0;
}

stock GarageGUI_OnPickup(playerid, action_type, action_id)
{
    if(action_type != PICKUP_ACTION_TYPE_GARAGE) return 0;
    if(!Garage_IsValid(action_id)) return 1;

    if(!IsGarageOwned(action_id))
        return Garage_ShowBuy(playerid, action_id);

    if(GetGarageData(action_id, GAR_OWNER_ID) == GetPlayerAccountID(playerid))
        return Garage_ShowMain(playerid);

    if(GetGarageData(action_id, GAR_LOCK))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Гараж закрыт");
        return 1;
    }

    return Garage_ShowVisitorInfo(playerid, action_id);
}

stock GarageGUI_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(!((newkeys & GARAGE_EXIT_KEY) && !(oldkeys & GARAGE_EXIT_KEY))) return 0;

    new garageid = GetPlayerInGarage(playerid);
    if(Garage_IsValid(garageid))
    {
        if(Garage_IsPlayerNearInsideExit(playerid, 7.0))
        {
            Garage_Exit(playerid);
            return 1;
        }
        return 0;
    }

    if(IsPlayerInAnyVehicle(playerid) && IsPlayerDriver(playerid))
    {
        garageid = Garage_GetPlayerOwned(playerid);
        if(garageid != -1 && Garage_IsPlayerNearOutside(playerid, garageid, 15.0))
        {
            Garage_Enter(playerid, true);
            return 1;
        }
    }

    return 0;
}
CMD:garage(playerid, params[])
{
    #pragma unused params
    return Garage_ShowMain(playerid);
}

CMD:addgarage(playerid, params[])
{
    #pragma unused params
    return Garage_Add(playerid);
}
