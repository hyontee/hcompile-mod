// =========================================================
// Dynamic garage system for KASHON.pwn
// Uses table `dynamic_garages`. Old hardcoded house-garage
// points are disabled in KASHON.pwn by patch.
// =========================================================
#define MAX_DYNAMIC_GARAGES                    (900)
#define PICKUP_ACTION_TYPE_DYNAMIC_GARAGE      (6100)
#define PICKUP_ACTION_TYPE_DYNAMIC_GARAGE_EXIT (6101)
#define DIALOG_DYNAMIC_GARAGE_BUY              (19850)
#define DIALOG_DYNAMIC_GARAGE_MENU             (19851)
#define DIALOG_DYNAMIC_GARAGE_SELL             (19852)
#define DIALOG_DYNAMIC_GARAGE_INFO             (19853)
#define DIALOG_DYNAMIC_GARAGE_UPGRADES         (19854)
#define DIALOG_DYNAMIC_GARAGE_ELITE_CONFIRM    (19855)
#define DIALOG_DYNAMIC_GARAGE_SAFE             (19856)
#define DIALOG_DYNAMIC_GARAGE_SAFE_DEPOSIT     (19857)
#define DIALOG_DYNAMIC_GARAGE_SAFE_WITHDRAW    (19858)
#define DIALOG_DYNAMIC_GARAGE_PAY              (19859)

#define DYNAMIC_GARAGE_SELL_PERCENT            (70)
#define DYNAMIC_GARAGE_WORLD_OFFSET            (25000)
#define DYNAMIC_GARAGE_UPGRADE_SAFE            (1)
#define DYNAMIC_GARAGE_UPGRADE_ELITE           (2)
#define DYNAMIC_GARAGE_SAFE_UPGRADE_PRICE      (1000000)
#define DYNAMIC_GARAGE_ELITE_PRICE_BIG_CITY    (15000000)
#define DYNAMIC_GARAGE_ELITE_PRICE_SMALL_CITY  (6500000)
#define DYNAMIC_GARAGE_SAFE_MAX_MONEY          (1000000000)
#define DYNAMIC_GARAGE_DAY_SECONDS             (86400)
#define DYNAMIC_GARAGE_START_RENT_DAYS         (3)
#define DYNAMIC_GARAGE_MAX_RENT_DAYS           (30)
#define DYNAMIC_GARAGE_EXPIRE_REFUND_DIVIDER    (200) // 0.5% от стоимости при слёте гаража

#define DynamicGarageWorld(%0)              (DYNAMIC_GARAGE_WORLD_OFFSET + (%0))
#define GetDynamicGarageData(%0,%1)         g_dynamic_garage[%0][%1]
#define SetDynamicGarageData(%0,%1,%2)      g_dynamic_garage[%0][%1] = %2
#define IsDynamicGarageOwned(%0)            (GetDynamicGarageData(%0, DG_OWNER_ID) > 0)
#define IsDynamicGarageLocked(%0)           (GetDynamicGarageData(%0, DG_LOCKED) != 0)
#define DynamicGarageHasUpgrade(%0,%1)      ((GetDynamicGarageData(%0, DG_UPGRADES) & (%1)) != 0)
#define GetPlayerGarage(%0)                 DynamicGarageGetPlayerGarage(%0)
#define SetPlayerInGarage(%0,%1)            SetPlayerData(%0, P_IN_GARAGE, %1)

#define DG_ENTER_FOOT_X     (1.2011)
#define DG_ENTER_FOOT_Y     (1994.7356)
#define DG_ENTER_FOOT_Z     (1554.2031)
#define DG_ENTER_FOOT_A     (353.9531)
#define DG_EXIT_PICKUP_X    (2.3500)
#define DG_EXIT_PICKUP_Y    (2001.6000)
#define DG_EXIT_PICKUP_Z    (1554.2031)
// Point at the gate: player must drive here and press horn to leave garage.
#define DG_VEHICLE_EXIT_X   (-0.2940)
#define DG_VEHICLE_EXIT_Y   (2006.1187)
#define DG_VEHICLE_EXIT_Z   (1554.2031)
#define DG_VEHICLE_EXIT_A   (355.2402)

// Safe parking/spawn point inside garage. It is moved away from the gate
// so the vehicle does not spawn into the gate/object and get stuck.
#define DG_VEHICLE_SPAWN_X  (-0.2940)
#define DG_VEHICLE_SPAWN_Y  (1992.8500)
#define DG_VEHICLE_SPAWN_Z  (1554.2031)
#define DG_VEHICLE_SPAWN_A  (355.2402)

#define DG_ELITE_ENTER_FOOT_X     (495.9615)
#define DG_ELITE_ENTER_FOOT_Y     (1989.8678)
#define DG_ELITE_ENTER_FOOT_Z     (1547.6797)
#define DG_ELITE_ENTER_FOOT_A     (271.3424)
#define DG_ELITE_EXIT_PICKUP_X    (495.9615)
#define DG_ELITE_EXIT_PICKUP_Y    (1989.8678)
#define DG_ELITE_EXIT_PICKUP_Z    (1547.6797)
#define DG_ELITE_VEHICLE_EXIT_X   (501.1804)
#define DG_ELITE_VEHICLE_EXIT_Y   (1998.8234)
#define DG_ELITE_VEHICLE_EXIT_Z   (1547.6797)
#define DG_ELITE_VEHICLE_EXIT_A   (348.0000)
#define DG_ELITE_VEHICLE_SPAWN_X  (501.1804)
#define DG_ELITE_VEHICLE_SPAWN_Y  (1994.0000)
#define DG_ELITE_VEHICLE_SPAWN_Z  (1547.6797)
#define DG_ELITE_VEHICLE_SPAWN_A  (348.0000)

#define DG_INTERIOR_ID      (1)
#define DG_OUTSIDE_EXIT_OFFSET (7.0)
#define DG_OUTSIDE_EXIT_Z_OFFSET (0.8)

#define DG_OWNER_NAME_SIZE  (25)
#define DG_CITY_SIZE        (33)

enum E_DYNAMIC_GARAGE_STRUCT
{
    DG_SQL_ID,
    DG_OWNER_ID,
    DG_OWNER_NAME[DG_OWNER_NAME_SIZE],
    DG_CITY[DG_CITY_SIZE],
    DG_PRICE,
    DG_RENT_PRICE,
    DG_PAID_UNTIL,
    DG_LOCKED,
    DG_UPGRADES,
    DG_SAFE_MONEY,
    Float:DG_POS_X,
    Float:DG_POS_Y,
    Float:DG_POS_Z,
    Float:DG_POS_A,
    DG_PICKUP,
    Text3D:DG_LABEL
};

new g_dynamic_garage[MAX_DYNAMIC_GARAGES][E_DYNAMIC_GARAGE_STRUCT];
new g_dynamic_garage_loaded;
new g_dynamic_garage_tick[MAX_PLAYERS];
new g_dynamic_garage_dialog[MAX_PLAYERS] = {-1, ...};

forward DynamicGarageCheckExpiredAll();

stock DynamicGarageFindOnlinePlayerByAccount(accountid)
{
    if(accountid <= 0) return INVALID_PLAYER_ID;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(GetPlayerAccountID(i) == accountid) return i;
    }
    return INVALID_PLAYER_ID;
}

stock DynamicGarageSendExpireNotice(playerid, garage_sql_id, refund)
{
    new msg[192];
    format(msg, sizeof msg, "Ваш гараж №%d был продан государству из-за окончания срока оплаты. Компенсация 0.5%%: %d руб. зачислена на банковский счёт.", garage_sql_id, refund);
    SendClientMessage(playerid, 0xFFB500FF, msg);
    return 1;
}

stock DynamicGarageGetDialogGarage(playerid)
{
    return g_dynamic_garage_dialog[playerid];
}

stock DynamicGarageClearDialogGarage(playerid)
{
    g_dynamic_garage_dialog[playerid] = -1;
    return 1;
}

stock IsValidDynamicGarage(garageid)
{
    return (garageid >= 0 && garageid < g_dynamic_garage_loaded);
}

stock DynamicGarageFormatMoney(value, dest[], size)
{
    format(dest, size, "%d", value);
    return 1;
}

stock DynamicGarageGetPaidDaysLeft(garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 0;

    new seconds = GetDynamicGarageData(garageid, DG_PAID_UNTIL) - gettime();
    if(seconds <= 0) return 0;

    new days = seconds / DYNAMIC_GARAGE_DAY_SECONDS;
    if((seconds % DYNAMIC_GARAGE_DAY_SECONDS) != 0) days++;
    return days;
}

stock DynamicGarageFormatRentStatus(garageid, dest[], size)
{
    if(!IsValidDynamicGarage(garageid))
    {
        format(dest, size, "неизвестно");
        return 1;
    }

    new days = DynamicGarageGetPaidDaysLeft(garageid);
    if(days < 0) days = 0;
    if(days > DYNAMIC_GARAGE_MAX_RENT_DAYS) days = DYNAMIC_GARAGE_MAX_RENT_DAYS;

    if(days <= 0) format(dest, size, "{FF5252}0/%d дней", DYNAMIC_GARAGE_MAX_RENT_DAYS);
    else format(dest, size, "{66CC00}%d/%d дней", days, DYNAMIC_GARAGE_MAX_RENT_DAYS);
    return 1;
}

stock DynamicGarageIsRentExpired(garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 1;
    if(!IsDynamicGarageOwned(garageid)) return 0;
    return (DynamicGarageGetPaidDaysLeft(garageid) <= 0);
}

stock DynamicGarageGetFootEnterPos(garageid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE))
    {
        x = DG_ELITE_ENTER_FOOT_X;
        y = DG_ELITE_ENTER_FOOT_Y;
        z = DG_ELITE_ENTER_FOOT_Z;
        a = DG_ELITE_ENTER_FOOT_A;
    }
    else
    {
        x = DG_ENTER_FOOT_X;
        y = DG_ENTER_FOOT_Y;
        z = DG_ENTER_FOOT_Z;
        a = DG_ENTER_FOOT_A;
    }
    return 1;
}

stock DynamicGarageGetVehicleSpawnPos(garageid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE))
    {
        x = DG_ELITE_VEHICLE_SPAWN_X;
        y = DG_ELITE_VEHICLE_SPAWN_Y;
        z = DG_ELITE_VEHICLE_SPAWN_Z;
        a = DG_ELITE_VEHICLE_SPAWN_A;
    }
    else
    {
        x = DG_VEHICLE_SPAWN_X;
        y = DG_VEHICLE_SPAWN_Y;
        z = DG_VEHICLE_SPAWN_Z;
        a = DG_VEHICLE_SPAWN_A;
    }
    return 1;
}

stock DynamicGarageGetVehicleExitGatePos(garageid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE))
    {
        x = DG_ELITE_VEHICLE_EXIT_X;
        y = DG_ELITE_VEHICLE_EXIT_Y;
        z = DG_ELITE_VEHICLE_EXIT_Z;
        a = DG_ELITE_VEHICLE_EXIT_A;
    }
    else
    {
        x = DG_VEHICLE_EXIT_X;
        y = DG_VEHICLE_EXIT_Y;
        z = DG_VEHICLE_EXIT_Z;
        a = DG_VEHICLE_EXIT_A;
    }
    return 1;
}


stock DynamicGarageFindByOwner(ownerid)
{
    if(ownerid <= 0) return -1;
    for(new i; i < g_dynamic_garage_loaded; i++)
    {
        if(GetDynamicGarageData(i, DG_OWNER_ID) == ownerid) return i;
    }
    return -1;
}


stock DynamicGarageExpireToState(garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 0;
    if(!IsDynamicGarageOwned(garageid)) return 0;

    new owner_id = GetDynamicGarageData(garageid, DG_OWNER_ID);
    if(owner_id <= 0) return 0;

    new garage_sql_id = GetDynamicGarageData(garageid, DG_SQL_ID);
    new refund = GetDynamicGarageData(garageid, DG_PRICE) / DYNAMIC_GARAGE_EXPIRE_REFUND_DIVIDER;
    if(refund < 1) refund = 1;

    new online_player = DynamicGarageFindOnlinePlayerByAccount(owner_id);
    new query[512];

    if(online_player != INVALID_PLAYER_ID)
    {
        if(GetPlayerData(online_player, P_IN_GARAGE) == garageid)
        {
            SetPlayerInGarage(online_player, -1);
            SetPlayerPosEx(online_player, GetDynamicGarageData(garageid, DG_POS_X), GetDynamicGarageData(garageid, DG_POS_Y), GetDynamicGarageData(garageid, DG_POS_Z), GetDynamicGarageData(garageid, DG_POS_A), 0, 0);
            SetCameraBehindPlayer(online_player);
        }

        AddPlayerData(online_player, P_BANK, +, refund);
        SetPlayerData(online_player, P_GARAGE_TYPE, -1);
        BankLog(online_player, refund, "Компенсация за слёт гаража");

        mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `garage`=-1,`bank`=%d WHERE `id`=%d LIMIT 1", GetPlayerBankMoney(online_player), owner_id);
        mysql_query(mysql, query, false);

        DynamicGarageSendExpireNotice(online_player, garage_sql_id, refund);
    }
    else
    {
        mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `garage`=-1,`bank`=`bank`+%d WHERE `id`=%d LIMIT 1", refund, owner_id);
        mysql_query(mysql, query, false);

        mysql_format(mysql, query, sizeof query, "INSERT INTO `dynamic_garage_notices` (`uid`,`garage_id`,`refund`,`time`) VALUES (%d,%d,%d,%d)", owner_id, garage_sql_id, refund, gettime());
        mysql_query(mysql, query, false);
    }

    mysql_format(mysql, query, sizeof query, "UPDATE `dynamic_garages` SET `owner_id`=0,`owner_name`='Государство',`open`=1,`upgrades`=0,`safe_money`=0,`created_at`=0 WHERE `id`=%d LIMIT 1", garage_sql_id);
    mysql_query(mysql, query, false);

    SetDynamicGarageData(garageid, DG_OWNER_ID, 0);
    format(g_dynamic_garage[garageid][DG_OWNER_NAME], DG_OWNER_NAME_SIZE, "Государство");
    SetDynamicGarageData(garageid, DG_LOCKED, 1);
    SetDynamicGarageData(garageid, DG_PAID_UNTIL, 0);
    SetDynamicGarageData(garageid, DG_UPGRADES, 0);
    SetDynamicGarageData(garageid, DG_SAFE_MONEY, 0);
    DynamicGarageUpdateLabel(garageid);
    return 1;
}

stock DynamicGarageGetPlayerGarage(playerid)
{
    new garageid = GetPlayerData(playerid, P_GARAGE_TYPE);
    if(IsValidDynamicGarage(garageid) && GetDynamicGarageData(garageid, DG_OWNER_ID) == GetPlayerAccountID(playerid))
    {
        if(DynamicGarageIsRentExpired(garageid))
        {
            DynamicGarageExpireToState(garageid);
            return -1;
        }
        return garageid;
    }

    garageid = DynamicGarageFindByOwner(GetPlayerAccountID(playerid));
    if(garageid != -1)
    {
        if(DynamicGarageIsRentExpired(garageid))
        {
            DynamicGarageExpireToState(garageid);
            return -1;
        }
        SetPlayerData(playerid, P_GARAGE_TYPE, garageid);
        UpdatePlayerDatabaseInt(playerid, "garage", garageid);
    }
    else if(GetPlayerData(playerid, P_GARAGE_TYPE) != -1)
    {
        SetPlayerData(playerid, P_GARAGE_TYPE, -1);
        UpdatePlayerDatabaseInt(playerid, "garage", -1);
    }
    return garageid;
}

stock DynamicGarageGetNearest(playerid, Float:radius = 5.0)
{
    for(new i; i < g_dynamic_garage_loaded; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, radius, GetDynamicGarageData(i, DG_POS_X), GetDynamicGarageData(i, DG_POS_Y), GetDynamicGarageData(i, DG_POS_Z))) return i;
    }
    return -1;
}

stock DynamicGarageIsEliteCity(garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 0;
    if(strfind(g_dynamic_garage[garageid][DG_CITY], "Буса", true) != -1) return 1;
    if(strfind(g_dynamic_garage[garageid][DG_CITY], "Батыр", true) != -1) return 1;
    return 0;
}

stock DynamicGarageGetEliteUpgradePrice(garageid)
{
    if(DynamicGarageIsEliteCity(garageid)) return DYNAMIC_GARAGE_ELITE_PRICE_BIG_CITY;
    return DYNAMIC_GARAGE_ELITE_PRICE_SMALL_CITY;
}

stock DynamicGarageGetCityType(garageid, dest[], size)
{
    if(DynamicGarageIsEliteCity(garageid)) format(dest, size, "{FFCC00}элитный город");
    else format(dest, size, "{66CC00}обычный город");
    return 1;
}

stock DynamicGarageGetGarageClass(garageid, dest[], size)
{
    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE)) format(dest, size, "{FFCC00}элитный гараж");
    else format(dest, size, "{CECECE}обычный гараж");
    return 1;
}

stock DynamicGarageGetUpgradesText(garageid, dest[], size)
{
    new bool:has_safe = DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE) ? true : false;
    new bool:has_elite = DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE) ? true : false;

    if(has_safe && has_elite) format(dest, size, "сейф, элитный гараж");
    else if(has_safe) format(dest, size, "сейф");
    else if(has_elite) format(dest, size, "элитный гараж");
    else format(dest, size, "нет");
    return 1;
}

stock DynamicGarageUpdateDatabaseUpgrades(garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof query, "UPDATE `dynamic_garages` SET `upgrades`=%d,`safe_money`=%d WHERE `id`=%d LIMIT 1", GetDynamicGarageData(garageid, DG_UPGRADES), GetDynamicGarageData(garageid, DG_SAFE_MONEY), GetDynamicGarageData(garageid, DG_SQL_ID));
    mysql_query(mysql, query, false);
    return 1;
}

stock DynamicGarageUpdateLabel(garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 0;

    new text[900], price[32], city_type[32], garage_class[32], upgrades[64], elite_price[32], rent_status[48];
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_PRICE), price, sizeof price);
    DynamicGarageFormatMoney(DynamicGarageGetEliteUpgradePrice(garageid), elite_price, sizeof elite_price);
    DynamicGarageGetCityType(garageid, city_type, sizeof city_type);
    DynamicGarageGetGarageClass(garageid, garage_class, sizeof garage_class);
    DynamicGarageGetUpgradesText(garageid, upgrades, sizeof upgrades);
    DynamicGarageFormatRentStatus(garageid, rent_status, sizeof rent_status);

    if(IsDynamicGarageOwned(garageid))
    {
        format(text, sizeof text,
            "{FFCC00}Гараж №%d\n{FFFFFF}Владелец: {FFCC00}%s\n{FFFFFF}Город: {FFCC00}%s\n{FFFFFF}Район: %s\n{FFFFFF}Класс гаража: %s\n{FFFFFF}Улучшения: {FFCC00}%s\n{FFFFFF}Оплачен: %s\n{FFFFFF}Статус: %s\n{FFFFFF}Пикап - вход пешком | Гудок - въезд",
            GetDynamicGarageData(garageid, DG_SQL_ID),
            GetDynamicGarageData(garageid, DG_OWNER_NAME),
            GetDynamicGarageData(garageid, DG_CITY),
            city_type,
            garage_class,
            upgrades,
            rent_status,
            IsDynamicGarageLocked(garageid) ? ("{FF5252}закрыт") : ("{66CC00}открыт")
        );
    }
    else
    {
        format(text, sizeof text,
            "{66CC00}Свободный гараж №%d\n{FFFFFF}Владелец: {CECECE}Государство\n{FFFFFF}Город: {FFCC00}%s\n{FFFFFF}Район: %s\n{FFFFFF}Цена: {FFCC00}%s руб.\n{FFFFFF}После покупки оплата: {66CC00}3 дня\n{FFFFFF}Максимум оплаты: {FFCC00}30 дней\n{FFFFFF}Элитное улучшение: {FFCC00}%s руб.\n{FFFFFF}Подойдите к пикапу, чтобы купить",
            GetDynamicGarageData(garageid, DG_SQL_ID),
            GetDynamicGarageData(garageid, DG_CITY),
            city_type,
            price,
            elite_price
        );
    }

    if(IsValidDynamic3DTextLabel(GetDynamicGarageData(garageid, DG_LABEL)))
        UpdateDynamic3DTextLabelText(GetDynamicGarageData(garageid, DG_LABEL), 0xFFFFFFFF, text);
    return 1;
}

stock DynamicGarageCreateWorldExit()
{
    CreateDynamic3DTextLabel("{FFCC00}Выезд из гаража\n{FFFFFF}Нажмите {FFCC00}ГУДОК{FFFFFF} в транспорте", -1, DG_VEHICLE_EXIT_X, DG_VEHICLE_EXIT_Y, DG_VEHICLE_EXIT_Z + 1.0, 12.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{66CC00}Выход на улицу\n{FFFFFF}Обычный пикап выхода", -1, DG_EXIT_PICKUP_X, DG_EXIT_PICKUP_Y, DG_EXIT_PICKUP_Z + 1.0, 12.0, _, _, _, -1, -1);
    CreatePickup(1318, 23, DG_EXIT_PICKUP_X, DG_EXIT_PICKUP_Y, DG_EXIT_PICKUP_Z, -1, PICKUP_ACTION_TYPE_DYNAMIC_GARAGE_EXIT, -1);

    CreateDynamic3DTextLabel("{FFCC00}Выезд из элитного гаража\n{FFFFFF}Нажмите {FFCC00}ГУДОК{FFFFFF} в транспорте", -1, DG_ELITE_VEHICLE_EXIT_X, DG_ELITE_VEHICLE_EXIT_Y, DG_ELITE_VEHICLE_EXIT_Z + 1.0, 12.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{66CC00}Выход на улицу\n{FFFFFF}Обычный пикап выхода", -1, DG_ELITE_EXIT_PICKUP_X, DG_ELITE_EXIT_PICKUP_Y, DG_ELITE_EXIT_PICKUP_Z + 1.0, 12.0, _, _, _, -1, -1);
    CreatePickup(1318, 23, DG_ELITE_EXIT_PICKUP_X, DG_ELITE_EXIT_PICKUP_Y, DG_ELITE_EXIT_PICKUP_Z, -1, PICKUP_ACTION_TYPE_DYNAMIC_GARAGE_EXIT, -1);
    return 1;
}

stock LoadDynamicGarages()
{
    new Cache:result, rows;
    result = mysql_query(mysql, "SELECT * FROM `dynamic_garages` ORDER BY `id` ASC", true);
    rows = cache_num_rows();
    if(rows > MAX_DYNAMIC_GARAGES) rows = MAX_DYNAMIC_GARAGES;
    g_dynamic_garage_loaded = rows;

    for(new idx; idx < rows; idx++)
    {
        SetDynamicGarageData(idx, DG_SQL_ID, cache_get_field_content_int(idx, "id"));
        SetDynamicGarageData(idx, DG_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));
        cache_get_field_content(idx, "owner_name", g_dynamic_garage[idx][DG_OWNER_NAME], mysql, 24);
        cache_get_field_content(idx, "city", g_dynamic_garage[idx][DG_CITY], mysql, 32);
        SetDynamicGarageData(idx, DG_PRICE, cache_get_field_content_int(idx, "price"));
        SetDynamicGarageData(idx, DG_RENT_PRICE, cache_get_field_content_int(idx, "rent_price"));
        SetDynamicGarageData(idx, DG_PAID_UNTIL, cache_get_field_content_int(idx, "created_at"));
        SetDynamicGarageData(idx, DG_LOCKED, cache_get_field_content_int(idx, "open"));
        SetDynamicGarageData(idx, DG_UPGRADES, cache_get_field_content_int(idx, "upgrades"));
        SetDynamicGarageData(idx, DG_SAFE_MONEY, cache_get_field_content_int(idx, "safe_money"));
        SetDynamicGarageData(idx, DG_POS_X, cache_get_field_content_float(idx, "pos_x"));
        SetDynamicGarageData(idx, DG_POS_Y, cache_get_field_content_float(idx, "pos_y"));
        SetDynamicGarageData(idx, DG_POS_Z, cache_get_field_content_float(idx, "pos_z"));
        SetDynamicGarageData(idx, DG_POS_A, cache_get_field_content_float(idx, "pos_a"));

        SetDynamicGarageData(idx, DG_LABEL, CreateDynamic3DTextLabel(" ", -1, GetDynamicGarageData(idx, DG_POS_X), GetDynamicGarageData(idx, DG_POS_Y), GetDynamicGarageData(idx, DG_POS_Z) + 1.0, 15.0, _, _, _, 0, -1));
        SetDynamicGarageData(idx, DG_PICKUP, CreatePickup(19134, 23, GetDynamicGarageData(idx, DG_POS_X), GetDynamicGarageData(idx, DG_POS_Y), GetDynamicGarageData(idx, DG_POS_Z), 0, PICKUP_ACTION_TYPE_DYNAMIC_GARAGE, idx));
        DynamicGarageUpdateLabel(idx);
    }
    cache_delete(result);
    DynamicGarageCreateWorldExit();
    printf("[DynamicGarage]: Loaded %d garages", g_dynamic_garage_loaded);
    return 1;
}


stock DynamicGarageClearPlayerRuntime(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    SetPlayerInGarage(playerid, -1);
    DynamicGarageClearDialogGarage(playerid);

    if(GetPlayerData(playerid, P_LAST_PICKUP) != -1)
    {
        SetPlayerData(playerid, P_LAST_PICKUP, -1);
    }
    return 1;
}

stock DynamicGarageTeleportSafe(playerid, Float:x, Float:y, Float:z, Float:a = 0.0, interior = 0, virtual_world = 0)
{
    if(!IsPlayerConnected(playerid)) return 0;

    DynamicGarageClearPlayerRuntime(playerid);

    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
        {
            SetPlayerInterior(playerid, interior);
            SetPlayerVirtualWorld(playerid, virtual_world);

            LinkVehicleToInterior(vehicleid, interior);
            SetVehicleVirtualWorld(vehicleid, virtual_world);
            SetVehiclePos(vehicleid, x, y, z + 0.6);
            SetVehicleZAngle(vehicleid, a);
            SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
            PutPlayerInVehicle(playerid, vehicleid, 0);
            SetCameraBehindPlayer(playerid);
            return 1;
        }
    }

    SetPlayerPosEx(playerid, x, y, z, a, interior, virtual_world, false);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock DynamicGarageShowBuy(playerid, garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 1;
    g_dynamic_garage_dialog[playerid] = garageid;

    new text[720], price[32], city_type[32], elite_price[32];
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_PRICE), price, sizeof price);
    DynamicGarageFormatMoney(DynamicGarageGetEliteUpgradePrice(garageid), elite_price, sizeof elite_price);
    DynamicGarageGetCityType(garageid, city_type, sizeof city_type);
    format(text, sizeof text,
        "{FFFFFF}Гараж №%d\nГород/район: {FFCC00}%s\n{FFFFFF}Тип района: %s\n{FFFFFF}Цена покупки: {FFCC00}%s руб.\n{FFFFFF}Оплата после покупки: {66CC00}3 дня\n{FFFFFF}Максимальная оплата гаража: {FFCC00}30 дней\n{FFFFFF}Цена элитного улучшения после покупки: {FFCC00}%s руб.\n\n{FFFFFF}Купить этот гараж?",
        GetDynamicGarageData(garageid, DG_SQL_ID), GetDynamicGarageData(garageid, DG_CITY), city_type, price, elite_price);
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{66CC00}Покупка гаража", text, "Купить", "Отмена");
    return 1;
}

stock DynamicGarageBuy(playerid, garageid)
{
    g_dynamic_garage_dialog[playerid] = -1;
    if(!IsValidDynamicGarage(garageid)) return 1;
    if(IsDynamicGarageOwned(garageid)) return SendClientMessage(playerid, 0xCECECEFF, "Этот гараж уже куплен.");
    if(GetPlayerGarage(playerid) != -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас уже есть гараж.");

    new price = GetDynamicGarageData(garageid, DG_PRICE);
    if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно денег для покупки гаража.");

    new paid_until = gettime() + (DYNAMIC_GARAGE_START_RENT_DAYS * DYNAMIC_GARAGE_DAY_SECONDS);
    new query[320];
    mysql_format(mysql, query, sizeof query, "UPDATE `dynamic_garages` SET `owner_id`=%d,`owner_name`='%e',`open`=1,`created_at`=%d WHERE `id`=%d LIMIT 1", GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), paid_until, GetDynamicGarageData(garageid, DG_SQL_ID));
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `garage`=%d WHERE `id`=%d LIMIT 1", garageid, GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, -price, "Покупка гаража", true, false);
    SetDynamicGarageData(garageid, DG_OWNER_ID, GetPlayerAccountID(playerid));
    format(g_dynamic_garage[garageid][DG_OWNER_NAME], DG_OWNER_NAME_SIZE, "%s", GetPlayerNameEx(playerid));
    SetDynamicGarageData(garageid, DG_LOCKED, 1);
    SetDynamicGarageData(garageid, DG_PAID_UNTIL, paid_until);
    SetPlayerData(playerid, P_GARAGE_TYPE, garageid);
    DynamicGarageUpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Вы успешно купили гараж. Он оплачен на 3 дня. Управление: /garage");
    return 1;
}

stock DynamicGarageCanEnter(playerid, garageid)
{
    if(!IsValidDynamicGarage(garageid)) return 0;
    if(!IsDynamicGarageOwned(garageid))
    {
        DynamicGarageShowBuy(playerid, garageid);
        return 0;
    }

    if(DynamicGarageIsRentExpired(garageid))
    {
        DynamicGarageExpireToState(garageid);
        SendClientMessage(playerid, 0xCECECEFF, "Срок оплаты гаража закончился. Гараж продан государству.");
        return 0;
    }

    if(GetDynamicGarageData(garageid, DG_OWNER_ID) == GetPlayerAccountID(playerid)) return 1;
    if(!IsDynamicGarageLocked(garageid)) return 1;
    SendClientMessage(playerid, 0xCECECEFF, "Гараж закрыт владельцем.");
    return 0;
}

stock DynamicGarageEnterFoot(playerid, garageid)
{
    if(!DynamicGarageCanEnter(playerid, garageid)) return 1;

    new Float:x, Float:y, Float:z, Float:a;
    DynamicGarageGetFootEnterPos(garageid, x, y, z, a);

    SetPlayerInGarage(playerid, garageid);
    SetPlayerPosEx(playerid, x, y, z, a, DG_INTERIOR_ID, DynamicGarageWorld(garageid));
    SetCameraBehindPlayer(playerid);
    SendClientMessage(playerid, 0x66CC00FF, "Вы вошли в гараж. Для выхода используйте пикап внутри гаража.");
    return 1;
}

stock DynamicGarageEnterVehicle(playerid, garageid)
{
    if(!DynamicGarageCanEnter(playerid, garageid)) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 1;

    new Float:x, Float:y, Float:z, Float:a;
    DynamicGarageGetVehicleSpawnPos(garageid, x, y, z, a);

    SetPlayerInGarage(playerid, garageid);
    SetPlayerInterior(playerid, DG_INTERIOR_ID);
    SetPlayerVirtualWorld(playerid, DynamicGarageWorld(garageid));
    LinkVehicleToInterior(vehicleid, DG_INTERIOR_ID);
    SetVehicleVirtualWorld(vehicleid, DynamicGarageWorld(garageid));
    SetVehiclePos(vehicleid, x, y, z + 0.4);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    SetCameraBehindPlayer(playerid);
    SendClientMessage(playerid, 0x66CC00FF, "Вы заехали в гараж. Для выезда подъедьте к воротам и нажмите гудок.");
    return 1;
}

stock DynamicGaragePlaceVehicleForPlayer(playerid, vehicleid)
{
    new garageid = GetPlayerData(playerid, P_IN_GARAGE);
    if(!IsValidDynamicGarage(garageid)) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;

    new Float:x, Float:y, Float:z, Float:a;
    DynamicGarageGetVehicleSpawnPos(garageid, x, y, z, a);

    LinkVehicleToInterior(vehicleid, DG_INTERIOR_ID);
    SetVehicleVirtualWorld(vehicleid, DynamicGarageWorld(garageid));
    SetVehiclePos(vehicleid, x, y, z + 0.4);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    return 1;
}

stock DynamicGarageExitFoot(playerid)
{
    new garageid = GetPlayerData(playerid, P_IN_GARAGE);
    if(!IsValidDynamicGarage(garageid)) return 1;
    SetPlayerInGarage(playerid, -1);
    SetPlayerPosEx(playerid, GetDynamicGarageData(garageid, DG_POS_X), GetDynamicGarageData(garageid, DG_POS_Y), GetDynamicGarageData(garageid, DG_POS_Z), GetDynamicGarageData(garageid, DG_POS_A), 0, 0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock DynamicGarageExitVehicle(playerid)
{
    new garageid = GetPlayerData(playerid, P_IN_GARAGE);
    if(!IsValidDynamicGarage(garageid)) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;

    new Float:gate_x, Float:gate_y, Float:gate_z, Float:gate_a;
    DynamicGarageGetVehicleExitGatePos(garageid, gate_x, gate_y, gate_z, gate_a);
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, gate_x, gate_y, gate_z)) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;

    new Float:exit_x, Float:exit_y, Float:exit_z, Float:exit_a;
    exit_a = GetDynamicGarageData(garageid, DG_POS_A);
    exit_x = GetDynamicGarageData(garageid, DG_POS_X) + floatsin(-exit_a, degrees) * DG_OUTSIDE_EXIT_OFFSET;
    exit_y = GetDynamicGarageData(garageid, DG_POS_Y) + floatcos(-exit_a, degrees) * DG_OUTSIDE_EXIT_OFFSET;
    exit_z = GetDynamicGarageData(garageid, DG_POS_Z) + DG_OUTSIDE_EXIT_Z_OFFSET;

    SetPlayerInGarage(playerid, -1);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    LinkVehicleToInterior(vehicleid, 0);
    SetVehicleVirtualWorld(vehicleid, 0);
    SetVehiclePos(vehicleid, exit_x, exit_y, exit_z);
    SetVehicleZAngle(vehicleid, exit_a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock DynamicGarageHandleHorn(playerid, newkeys, oldkeys)
{
    // GTA/SA:MP vehicle horn is KEY_ACTION (H).
    if(!((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION))) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;

    if(GetPlayerData(playerid, P_IN_GARAGE) != -1)
    {
        DynamicGarageExitVehicle(playerid);
        return 1;
    }

    new garageid = DynamicGarageGetNearest(playerid, 8.0);
    if(garageid == -1) return 0;
    DynamicGarageEnterVehicle(playerid, garageid);
    return 1;
}

stock DynamicGarageToggleLock(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    SetDynamicGarageData(garageid, DG_LOCKED, !GetDynamicGarageData(garageid, DG_LOCKED));
    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE `dynamic_garages` SET `open`=%d WHERE `id`=%d LIMIT 1", GetDynamicGarageData(garageid, DG_LOCKED), GetDynamicGarageData(garageid, DG_SQL_ID));
    mysql_query(mysql, query, false);
    DynamicGarageUpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, IsDynamicGarageLocked(garageid) ? ("Гараж закрыт.") : ("Гараж открыт."));
    return 1;
}

stock DynamicGarageShowMenu(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new text[512];
    format(text, sizeof text, "Информация о гараже\nОплатить гараж\nЗагрузить / управление транспортом\n%s гараж\nУлучшения гаража\nПродать гараж государству\nОтметить гараж на карте", IsDynamicGarageLocked(garageid) ? ("Открыть") : ("Закрыть"));
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_MENU, DIALOG_STYLE_LIST, "{FFCC00}Гараж", text, "Выбрать", "Закрыть");
    return 1;
}

stock DynamicGarageShowInfo(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new text[1200], price[32], sellprice[32], city_type[32], garage_class[32], upgrades[64], elite_price[32], safe_money[32], rent_status[48], rent_price[32];
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_PRICE), price, sizeof price);
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_PRICE) * DYNAMIC_GARAGE_SELL_PERCENT / 100, sellprice, sizeof sellprice);
    DynamicGarageFormatMoney(DynamicGarageGetEliteUpgradePrice(garageid), elite_price, sizeof elite_price);
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_SAFE_MONEY), safe_money, sizeof safe_money);
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_RENT_PRICE), rent_price, sizeof rent_price);
    DynamicGarageGetCityType(garageid, city_type, sizeof city_type);
    DynamicGarageGetGarageClass(garageid, garage_class, sizeof garage_class);
    DynamicGarageGetUpgradesText(garageid, upgrades, sizeof upgrades);
    DynamicGarageFormatRentStatus(garageid, rent_status, sizeof rent_status);

    format(text, sizeof text,
        "{FFFFFF}Номер гаража: {FFCC00}%d\n{FFFFFF}Владелец: {FFCC00}%s\n{FFFFFF}Город: {FFCC00}%s\n{FFFFFF}Тип района: %s\n{FFFFFF}Класс гаража: %s\n{FFFFFF}Улучшения: {FFCC00}%s\n{FFFFFF}Оплата гаража: %s\n{FFFFFF}Цена оплаты за 1 день: {FFCC00}%s руб.\n{FFFFFF}Максимум оплаты: {FFCC00}30 дней\n{FFFFFF}Стоимость гаража: {FFCC00}%s руб.\n{FFFFFF}Продажа государству: {FFCC00}%s руб.\n{FFFFFF}Стоимость элитного улучшения: {FFCC00}%s руб.\n{FFFFFF}Сейф: %s\n{FFFFFF}Деньги в сейфе: {FFCC00}%s руб.\n{FFFFFF}Статус: %s\n\n{FFFFFF}Въезд: гудок у внешнего пикапа.\nВыезд: гудок у ворот внутри гаража.\nПеший выход: отдельный простой пикап чуть дальше от ворот.",
        GetDynamicGarageData(garageid, DG_SQL_ID),
        GetDynamicGarageData(garageid, DG_OWNER_NAME),
        GetDynamicGarageData(garageid, DG_CITY),
        city_type,
        garage_class,
        upgrades,
        rent_status,
        rent_price,
        price,
        sellprice,
        elite_price,
        DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE) ? ("{66CC00}установлен") : ("{FF5252}не установлен"),
        safe_money,
        IsDynamicGarageLocked(garageid) ? ("{FF5252}закрыт") : ("{66CC00}открыт")
    );
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "{FFCC00}Информация о гараже", text, "Назад", "");
    return 1;
}

stock DynamicGarageShowUpgrades(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new text[512], safe_price[32], elite_price[32], safe_status[96], elite_status[96];
    DynamicGarageFormatMoney(DYNAMIC_GARAGE_SAFE_UPGRADE_PRICE, safe_price, sizeof safe_price);
    DynamicGarageFormatMoney(DynamicGarageGetEliteUpgradePrice(garageid), elite_price, sizeof elite_price);

    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE)) format(safe_status, sizeof safe_status, "установлен / открыть сейф");
    else format(safe_status, sizeof safe_status, "не установлен / установить за %s руб.", safe_price);

    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE)) format(elite_status, sizeof elite_status, "куплен");
    else format(elite_status, sizeof elite_status, "не куплен / купить за %s руб.", elite_price);

    format(text, sizeof text, "Сейф: %s\nЭлитный гараж: %s\nНазад", safe_status, elite_status);
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_UPGRADES, DIALOG_STYLE_LIST, "{FFCC00}Улучшения гаража", text, "Выбрать", "Назад");
    return 1;
}
stock DynamicGarageHandleUpgradeDialog(playerid, listitem)
{
    switch(listitem)
    {
        case 0:
        {
            new garageid = GetPlayerGarage(playerid);
            if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
            if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE)) return DynamicGarageShowSafe(playerid);
            return DynamicGarageInstallSafe(playerid);
        }
        case 1:
        {
            new garageid = GetPlayerGarage(playerid);
            if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
            if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE)) return SendClientMessage(playerid, 0xCECECEFF, "У вас уже куплено элитное улучшение гаража.");
            return DynamicGarageConfirmEliteUpgrade(playerid);
        }
        case 2: return DynamicGarageShowMenu(playerid);
    }
    return 1;
}

stock DynamicGarageInstallSafe(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE)) return DynamicGarageShowSafe(playerid);

    if(GetPlayerMoneyEx(playerid) < DYNAMIC_GARAGE_SAFE_UPGRADE_PRICE) return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для установки сейфа. Нужно 1 000 000 руб.");

    GivePlayerMoneyEx(playerid, -DYNAMIC_GARAGE_SAFE_UPGRADE_PRICE, "Установка сейфа в гараж", true, false);
    SetDynamicGarageData(garageid, DG_UPGRADES, GetDynamicGarageData(garageid, DG_UPGRADES) | DYNAMIC_GARAGE_UPGRADE_SAFE);
    DynamicGarageUpdateDatabaseUpgrades(garageid);
    DynamicGarageUpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Сейф успешно установлен в гараж.");
    return DynamicGarageShowSafe(playerid);
}

stock DynamicGarageConfirmEliteUpgrade(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new text[512], price[32], city_type[32];
    DynamicGarageFormatMoney(DynamicGarageGetEliteUpgradePrice(garageid), price, sizeof price);
    DynamicGarageGetCityType(garageid, city_type, sizeof city_type);

    format(text, sizeof text, "{FFFFFF}Город гаража: {FFCC00}%s\n{FFFFFF}Тип района: %s\n{FFFFFF}Стоимость элитного улучшения: {FFCC00}%s руб.\n\n{FFFFFF}Бусаева и Батырево считаются элитными городами — 15 000 000 руб.\nОбычные города — 6 500 000 руб.\n\nКупить элитное улучшение?", GetDynamicGarageData(garageid, DG_CITY), city_type, price);
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_ELITE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFCC00}Элитный гараж", text, "Купить", "Назад");
    return 1;
}

stock DynamicGarageBuyEliteUpgrade(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
    if(DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_ELITE)) return SendClientMessage(playerid, 0xCECECEFF, "У вас уже куплено элитное улучшение гаража.");

    new price = DynamicGarageGetEliteUpgradePrice(garageid);
    if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки элитного улучшения гаража.");

    GivePlayerMoneyEx(playerid, -price, "Элитное улучшение гаража", true, false);
    SetDynamicGarageData(garageid, DG_UPGRADES, GetDynamicGarageData(garageid, DG_UPGRADES) | DYNAMIC_GARAGE_UPGRADE_ELITE);
    DynamicGarageUpdateDatabaseUpgrades(garageid);
    DynamicGarageUpdateLabel(garageid);
    if(GetPlayerData(playerid, P_IN_GARAGE) == garageid)
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) DynamicGarageEnterVehicle(playerid, garageid);
        else DynamicGarageEnterFoot(playerid, garageid);
    }
    SendClientMessage(playerid, 0x66CC00FF, "Вы успешно улучшили гараж до элитного класса. Интерьер гаража обновлен.");
    return DynamicGarageShowUpgrades(playerid);
}

stock DynamicGarageShowSafe(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
    if(!DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE)) return SendClientMessage(playerid, 0xCECECEFF, "В вашем гараже еще нет сейфа.");

    new text[128], title[96], safe_money[32];
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_SAFE_MONEY), safe_money, sizeof safe_money);
    format(text, sizeof text, "Положить деньги\nЗабрать деньги\nНазад");
    format(title, sizeof title, "{FFCC00}Сейф гаража | %s руб.", safe_money);
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_SAFE, DIALOG_STYLE_LIST, title, text, "Выбрать", "Назад");
    return 1;
}
stock DynamicGarageShowSafeDeposit(playerid)
{
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_SAFE_DEPOSIT, DIALOG_STYLE_INPUT, "{FFCC00}Сейф гаража", "{FFFFFF}Введите сумму, которую хотите положить в сейф:", "Положить", "Назад");
    return 1;
}

stock DynamicGarageShowSafeWithdraw(playerid)
{
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_SAFE_WITHDRAW, DIALOG_STYLE_INPUT, "{FFCC00}Сейф гаража", "{FFFFFF}Введите сумму, которую хотите забрать из сейфа:", "Забрать", "Назад");
    return 1;
}

stock DynamicGarageSafeDeposit(playerid, inputtext[])
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
    if(!DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE)) return SendClientMessage(playerid, 0xCECECEFF, "В вашем гараже еще нет сейфа.");

    new amount = strval(inputtext);
    if(amount <= 0) return DynamicGarageShowSafeDeposit(playerid);
    if(GetPlayerMoneyEx(playerid) < amount) return SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно денег.");
    if(amount > DYNAMIC_GARAGE_SAFE_MAX_MONEY - GetDynamicGarageData(garageid, DG_SAFE_MONEY)) return SendClientMessage(playerid, 0xCECECEFF, "В сейфе не хватает места для такой суммы.");

    GivePlayerMoneyEx(playerid, -amount, "Пополнение сейфа гаража", true, false);
    SetDynamicGarageData(garageid, DG_SAFE_MONEY, GetDynamicGarageData(garageid, DG_SAFE_MONEY) + amount);
    DynamicGarageUpdateDatabaseUpgrades(garageid);
    DynamicGarageUpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Деньги положены в сейф гаража.");
    return DynamicGarageShowSafe(playerid);
}

stock DynamicGarageSafeWithdraw(playerid, inputtext[])
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
    if(!DynamicGarageHasUpgrade(garageid, DYNAMIC_GARAGE_UPGRADE_SAFE)) return SendClientMessage(playerid, 0xCECECEFF, "В вашем гараже еще нет сейфа.");

    new amount = strval(inputtext);
    if(amount <= 0) return DynamicGarageShowSafeWithdraw(playerid);
    if(GetDynamicGarageData(garageid, DG_SAFE_MONEY) < amount) return SendClientMessage(playerid, 0xCECECEFF, "В сейфе нет такой суммы.");

    GivePlayerMoneyEx(playerid, amount, "Снятие денег из сейфа гаража", true, false);
    SetDynamicGarageData(garageid, DG_SAFE_MONEY, GetDynamicGarageData(garageid, DG_SAFE_MONEY) - amount);
    DynamicGarageUpdateDatabaseUpgrades(garageid);
    DynamicGarageUpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Деньги забраны из сейфа гаража.");
    return DynamicGarageShowSafe(playerid);
}


stock DynamicGarageShowPay(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new text[640], rent_status[48], rent_price[32];
    DynamicGarageFormatRentStatus(garageid, rent_status, sizeof rent_status);
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_RENT_PRICE), rent_price, sizeof rent_price);
    format(text, sizeof text, "{FFFFFF}Текущая оплата гаража: %s\n{FFFFFF}Цена за 1 день: {FFCC00}%s руб.\n{FFFFFF}Оплата списывается с {3399FF}основного банковского счёта{FFFFFF}.\n{FFFFFF}Максимально можно оплатить до {FFCC00}30 дней{FFFFFF}.\n\nВведите количество дней для оплаты:", rent_status, rent_price);
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_PAY, DIALOG_STYLE_INPUT, "{FFCC00}Оплата гаража", text, "Оплатить", "Назад");
    return 1;
}

stock DynamicGaragePay(playerid, inputtext[])
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new days = strval(inputtext);
    if(days < 1 || days > DYNAMIC_GARAGE_MAX_RENT_DAYS)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Можно оплатить только от 1 до 30 дней.");
        return DynamicGarageShowPay(playerid);
    }

    new left_days = DynamicGarageGetPaidDaysLeft(garageid);
    if(left_days >= DYNAMIC_GARAGE_MAX_RENT_DAYS)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Гараж уже оплачен на максимальный срок.");
        return DynamicGarageShowMenu(playerid);
    }

    if(left_days + days > DYNAMIC_GARAGE_MAX_RENT_DAYS)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя оплатить гараж больше чем на 30 дней вперед.");
        return DynamicGarageShowPay(playerid);
    }

    new price = GetDynamicGarageData(garageid, DG_RENT_PRICE) * days;
    if(GetPlayerBankMoney(playerid) < price)
    {
        SendClientMessage(playerid, 0xCECECEFF, "На основном банковском счёте недостаточно денег для оплаты гаража.");
        return DynamicGarageShowPay(playerid);
    }

    new base_time = GetDynamicGarageData(garageid, DG_PAID_UNTIL);
    if(base_time < gettime()) base_time = gettime();

    new paid_until = base_time + (days * DYNAMIC_GARAGE_DAY_SECONDS);
    new bank_after = GetPlayerBankMoney(playerid) - price;

    new query[256];
    mysql_format(mysql, query, sizeof query, "UPDATE `accounts` a,`dynamic_garages` g SET a.`bank`=%d,g.`created_at`=%d WHERE a.`id`=%d AND g.`id`=%d", bank_after, paid_until, GetPlayerAccountID(playerid), GetDynamicGarageData(garageid, DG_SQL_ID));
    mysql_query(mysql, query, false);

    AddPlayerData(playerid, P_BANK, -, price);
    BankLog(playerid, -price, "Оплата гаража");
    SetDynamicGarageData(garageid, DG_PAID_UNTIL, paid_until);

    DynamicGarageUpdateLabel(garageid);

    new msg[128];
    format(msg, sizeof msg, "Гараж успешно оплачен. С банковского счёта списано %d руб.", price);
    SendClientMessage(playerid, 0x66CC00FF, msg);
    return DynamicGarageShowMenu(playerid);
}


stock DynamicGarageCheckPlayerOfflineNotice(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof query, "SELECT `garage_id`,`refund` FROM `dynamic_garage_notices` WHERE `uid`=%d ORDER BY `id` ASC LIMIT 5", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);

    if(cache_num_rows())
    {
        for(new i = 0; i < cache_num_rows(); i++)
        {
            DynamicGarageSendExpireNotice(playerid, cache_get_field_content_int(i, "garage_id"), cache_get_field_content_int(i, "refund"));
        }

        mysql_format(mysql, query, sizeof query, "DELETE FROM `dynamic_garage_notices` WHERE `uid`=%d", GetPlayerAccountID(playerid));
        mysql_query(mysql, query, false);
    }

    cache_delete(result);
    return 1;
}

public DynamicGarageCheckExpiredAll()
{
    new time = gettime();
    for(new i = 0; i < g_dynamic_garage_loaded; i++)
    {
        if(!IsDynamicGarageOwned(i)) continue;
        if(GetDynamicGarageData(i, DG_PAID_UNTIL) > time) continue;

        DynamicGarageExpireToState(i);
    }
    return 1;
}

stock DynamicGarageConfirmSell(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    new text[320], sellprice[32];
    DynamicGarageFormatMoney(GetDynamicGarageData(garageid, DG_PRICE) * DYNAMIC_GARAGE_SELL_PERCENT / 100, sellprice, sizeof sellprice);
    format(text, sizeof text, "{FFFFFF}Вы действительно хотите продать гараж государству?\nВы получите: {FFCC00}%s руб.\n\n{FF5252}Улучшения гаража и деньги в сейфе будут очищены.", sellprice);
    Dialog(playerid, DIALOG_DYNAMIC_GARAGE_SELL, DIALOG_STYLE_MSGBOX, "{FF5252}Продажа гаража", text, "Продать", "Отмена");
    return 1;
}

stock DynamicGarageSell(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");
    if(GetDynamicGarageData(garageid, DG_OWNER_ID) != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Этот гараж вам не принадлежит.");

    if(GetPlayerData(playerid, P_IN_GARAGE) == garageid) DynamicGarageExitFoot(playerid);

    new sellprice = GetDynamicGarageData(garageid, DG_PRICE) * DYNAMIC_GARAGE_SELL_PERCENT / 100;
    new query[256];
    mysql_format(mysql, query, sizeof query, "UPDATE `dynamic_garages` SET `owner_id`=0,`owner_name`='Государство',`open`=1,`upgrades`=0,`safe_money`=0,`created_at`=0 WHERE `id`=%d LIMIT 1", GetDynamicGarageData(garageid, DG_SQL_ID));
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `garage`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, sellprice, "Продажа гаража", true, false);
    SetPlayerData(playerid, P_GARAGE_TYPE, -1);
    SetPlayerInGarage(playerid, -1);
    SetDynamicGarageData(garageid, DG_OWNER_ID, 0);
    format(g_dynamic_garage[garageid][DG_OWNER_NAME], DG_OWNER_NAME_SIZE, "Государство");
    SetDynamicGarageData(garageid, DG_LOCKED, 1);
    SetDynamicGarageData(garageid, DG_PAID_UNTIL, 0);
    SetDynamicGarageData(garageid, DG_UPGRADES, 0);
    SetDynamicGarageData(garageid, DG_SAFE_MONEY, 0);
    DynamicGarageUpdateLabel(garageid);
    SendClientMessage(playerid, 0x66CC00FF, "Вы успешно продали гараж государству.");
    return 1;
}

stock DynamicGarageMarkGPS(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража.");

    EnablePlayerGPS(playerid, 0, GetDynamicGarageData(garageid, DG_POS_X), GetDynamicGarageData(garageid, DG_POS_Y), GetDynamicGarageData(garageid, DG_POS_Z), "Гараж отмечен на карте.");
    return 1;
}

CMD:garage(playerid, params[])
{
    return DynamicGarageShowMenu(playerid);
}

CMD:sellgarage(playerid, params[])
{
    return DynamicGarageConfirmSell(playerid);
}

CMD:addgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new price, city[32];
    if(sscanf(params, "D(450000)S(Klonov Russia)[32]", price, city)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addgarage [цена] [город]");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `dynamic_garages` (`owner_id`,`owner_name`,`city`,`price`,`pos_x`,`pos_y`,`pos_z`,`pos_a`,`open`,`upgrades`,`safe_money`,`created_at`,`rent_price`) VALUES (0,'Государство','%e',%d,%f,%f,%f,%f,1,0,0,0,2500)",
        city, price, x, y, z, a);
    mysql_query(mysql, query, false);

    if(g_dynamic_garage_loaded >= MAX_DYNAMIC_GARAGES) return SendClientMessage(playerid, 0xCECECEFF, "Достигнут лимит гаражей.");

    new idx = g_dynamic_garage_loaded++;
    SetDynamicGarageData(idx, DG_SQL_ID, cache_insert_id());
    SetDynamicGarageData(idx, DG_OWNER_ID, 0);
    format(g_dynamic_garage[idx][DG_OWNER_NAME], DG_OWNER_NAME_SIZE, "Государство");
    format(g_dynamic_garage[idx][DG_CITY], DG_CITY_SIZE, "%s", city);
    SetDynamicGarageData(idx, DG_PRICE, price);
    SetDynamicGarageData(idx, DG_RENT_PRICE, 2500);
    SetDynamicGarageData(idx, DG_PAID_UNTIL, 0);
    SetDynamicGarageData(idx, DG_LOCKED, 1);
    SetDynamicGarageData(idx, DG_UPGRADES, 0);
    SetDynamicGarageData(idx, DG_SAFE_MONEY, 0);
    SetDynamicGarageData(idx, DG_POS_X, x);
    SetDynamicGarageData(idx, DG_POS_Y, y);
    SetDynamicGarageData(idx, DG_POS_Z, z);
    SetDynamicGarageData(idx, DG_POS_A, a);
    SetDynamicGarageData(idx, DG_LABEL, CreateDynamic3DTextLabel(" ", -1, x, y, z + 1.0, 15.0, _, _, _, 0, -1));
    SetDynamicGarageData(idx, DG_PICKUP, CreatePickup(19134, 23, x, y, z, 0, PICKUP_ACTION_TYPE_DYNAMIC_GARAGE, idx));
    DynamicGarageUpdateLabel(idx);
    SendClientMessage(playerid, 0x66CC00FF, "Гараж создан. Формат: /addgarage [цена] [город].");
    return 1;
}

// =========================================================
// Integration glue (added to wire this file into berkut.pwn)
// Call DynamicGarage_OnDialogResponse(...) from OnDialogResponse.
// =========================================================
stock DynamicGarageHandleMenuDialog(playerid, listitem)
{
    switch(listitem)
    {
        case 0: return DynamicGarageShowInfo(playerid);
        case 1: return DynamicGarageMarkGPS(playerid);
        case 2: return DynamicGarageShowUpgrades(playerid);
        case 3: return DynamicGarageToggleLock(playerid);
        case 4: return DynamicGarageShowPay(playerid);
        case 5: return DynamicGarageConfirmSell(playerid);
        case 6: return DynamicGarageExitFoot(playerid);
    }
    return 1;
}

stock DynamicGarage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_DYNAMIC_GARAGE_BUY:
        {
            new garageid = DynamicGarageGetDialogGarage(playerid);
            if(!response) { DynamicGarageClearDialogGarage(playerid); return 1; }
            DynamicGarageBuy(playerid, garageid);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_MENU:
        {
            if(!response) return 1;
            DynamicGarageHandleMenuDialog(playerid, listitem);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_SELL:
        {
            if(response) DynamicGarageSell(playerid);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_INFO:
        {
            DynamicGarageShowMenu(playerid);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_UPGRADES:
        {
            if(!response) { DynamicGarageShowMenu(playerid); return 1; }
            DynamicGarageHandleUpgradeDialog(playerid, listitem);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_ELITE_CONFIRM:
        {
            if(response) DynamicGarageBuyEliteUpgrade(playerid);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_SAFE:
        {
            if(!response) { DynamicGarageShowMenu(playerid); return 1; }
            switch(listitem)
            {
                case 0: DynamicGarageShowSafeDeposit(playerid);
                case 1: DynamicGarageShowSafeWithdraw(playerid);
                case 2: DynamicGarageShowMenu(playerid);
            }
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_SAFE_DEPOSIT:
        {
            if(response) DynamicGarageSafeDeposit(playerid, inputtext);
            else DynamicGarageShowSafe(playerid);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_SAFE_WITHDRAW:
        {
            if(response) DynamicGarageSafeWithdraw(playerid, inputtext);
            else DynamicGarageShowSafe(playerid);
            return 1;
        }
        case DIALOG_DYNAMIC_GARAGE_PAY:
        {
            if(response) DynamicGaragePay(playerid, inputtext);
            else DynamicGarageShowMenu(playerid);
            return 1;
        }
    }
    return 0;
}
