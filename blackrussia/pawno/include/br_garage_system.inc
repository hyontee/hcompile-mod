#if defined _BR_GARAGE_SYSTEM_INC
    #endinput
#endif
#define _BR_GARAGE_SYSTEM_INC

#define MAX_BR_GARAGES             (151)
#define BR_GARAGE_PRICE            (500000)
#define BR_GARAGE_SELL_PRICE       (250000)
#define BR_GARAGE_LIVE_PRICE       (30000)
#define BR_GARAGE_SAFE_PRICE       (40000)
#define BR_GARAGE_ELITE_PRICE      (5000000)
#define BR_GARAGE_RENT_DAYS        (30)
#define BR_GARAGE_WORLD_BASE       (8500)
#define BR_GARAGE_INTERIOR         (1)

#define BRG_LOCK_OPEN              (0)
#define BRG_LOCK_CLOSE             (1)

enum E_BR_GARAGE_STRUCT
{
    BRG_OWNER_ID,
    BRG_OWNER_NAME[MAX_PLAYER_NAME + 1],
    BRG_RENT_TIME,
    BRG_LOCK_STATUS,
    BRG_LIVE,
    BRG_SAFE,
    BRG_ELITE,
    Float: BRG_POS_X,
    Float: BRG_POS_Y,
    Float: BRG_POS_Z,
    BRG_PICKUP_ID,
    Text3D: BRG_LABEL
};

new g_br_garage[MAX_BR_GARAGES][E_BR_GARAGE_STRUCT];
new g_br_garage_loaded;

static const Float: g_br_garage_pos[MAX_BR_GARAGES][3] =
{
	{2571.7000, -1874.2100, 21.9600},
	{2571.7000, -1878.7300, 21.9600},
	{2571.7000, -1883.1500, 21.9600},
	{2571.7000, -1887.7600, 21.9600},
	{2571.7000, -1892.4100, 21.9600},
	{2571.7000, -1896.8500, 21.9600},
	{2571.7000, -1901.3300, 21.9600},
	{2571.7000, -1906.0200, 21.9600},
	{2571.7000, -1910.4700, 21.9600},
	{2571.7000, -1915.1300, 21.9600},
	{2571.7000, -1919.5600, 21.9600},
	{2571.7000, -1924.0200, 21.9600},
	{2571.7000, -1928.7100, 21.9600},
	{2571.7000, -1932.9700, 21.9600},
	{2571.7000, -1937.6200, 21.9600},
	{2571.7000, -1942.3000, 21.9600},
	{2571.7000, -1946.8000, 21.9600},
	{2571.7000, -1951.3800, 21.9600},
	{2571.7000, -1955.8000, 21.9600},
	{2571.7000, -1960.4200, 21.9600},
	{2571.7000, -1965.0600, 21.9600},
	{2571.7000, -1969.5100, 21.9600},
	{2571.7000, -1973.9100, 21.9600},
	{2571.7000, -1978.6400, 21.9600},
	{2571.7000, -1983.2000, 21.9600},
	{2571.7000, -1987.6800, 21.9600},
	{2571.7000, -1992.2200, 21.9600},
	{2571.7000, -1996.7000, 21.9600},
	{2571.7000, -2001.3100, 21.9600},
	{2571.7000, -2005.8400, 21.9600},
	{2571.7000, -2010.4200, 21.9600},
	{2559.4800, -1869.6200, 21.9600},
	{2559.4800, -1874.2100, 21.9600},
	{2559.4800, -1878.7300, 21.9600},
	{2559.4800, -1883.1500, 21.9600},
	{2559.4800, -1887.7600, 21.9600},
	{2559.4800, -1892.4100, 21.9600},
	{2559.4800, -1896.8500, 21.9600},
	{2559.4800, -1901.3300, 21.9600},
	{2559.4800, -1906.0200, 21.9600},
	{2559.4800, -1910.4700, 21.9600},
	{2559.4800, -1915.1300, 21.9600},
	{2559.4800, -1919.5600, 21.9600},
	{2559.4800, -1924.0200, 21.9600},
	{2559.4800, -1928.7100, 21.9600},
	{2559.4800, -1932.9700, 21.9600},
	{2559.4800, -1937.6200, 21.9600},
	{2559.4800, -1942.3000, 21.9600},
	{2559.4800, -1946.8000, 21.9600},
	{2559.4800, -1951.3800, 21.9600},
	{2559.4800, -1955.8000, 21.9600},
	{2559.4800, -1960.4200, 21.9600},
	{2559.4800, -1965.0600, 21.9600},
	{2559.4800, -1969.5100, 21.9600},
	{2559.4800, -1973.9100, 21.9600},
	{2559.4800, -1978.6400, 21.9600},
	{2559.4800, -1983.2000, 21.9600},
	{2559.4800, -1987.6800, 21.9600},
	{2559.4800, -1992.2200, 21.9600},
	{2559.4800, -1996.7000, 21.9600},
	{2559.4800, -2001.3100, 21.9600},
	{2559.4800, -2005.8400, 21.9600},
	{2559.4800, -2010.4200, 21.9600},
	{1718.4000, 2321.2200, 15.7600},
	{1722.8300, 2321.2300, 15.7600},
	{1727.4200, 2321.2200, 15.7600},
	{1731.8100, 2321.2200, 15.7600},
	{1736.2900, 2321.2200, 15.7600},
	{1740.7200, 2321.2200, 15.7600},
	{1745.2100, 2321.2200, 15.7600},
	{1749.6900, 2321.2300, 15.7600},
	{1754.2300, 2321.2100, 15.7600},
	{1758.6400, 2321.2100, 15.7700},
	{1763.0600, 2321.2100, 15.7700},
	{1767.4800, 2321.2300, 15.7700},
	{1771.9000, 2321.2100, 15.7700},
	{1776.4400, 2321.2100, 15.7800},
	{1781.3200, 2322.9300, 15.7600},
	{1785.2300, 2325.4300, 15.7600},
	{1788.9100, 2327.7900, 15.7600},
	{1792.7000, 2330.2200, 15.7600},
	{1796.4200, 2332.6000, 15.7700},
	{1731.2800, 2333.6400, 15.7800},
	{1730.5000, 2338.0200, 15.8000},
	{1729.7100, 2342.2300, 15.8200},
	{1728.9600, 2346.7500, 15.8300},
	{1728.1600, 2351.2600, 15.8300},
	{1727.4000, 2355.6000, 15.8300},
	{1726.6200, 2360.0000, 15.8300},
	{1725.8500, 2364.4100, 15.8300},
	{1716.5900, 2364.7000, 15.7600},
	{1717.2600, 2360.3200, 15.7600},
	{1718.1600, 1355.8200, 15.7600},
	{1718.9400, 2351.3500, 15.7600},
	{1719.7100, 2347.0200, 15.7600},
	{1738.3200, 2366.7900, 15.8200},
	{1739.1300, 2362.2300, 15.8200},
	{1739.8800, 2357.9500, 15.8200},
	{1740.6700, 2353.4800, 15.8200},
	{1741.4300, 2349.1400, 15.8200},
	{1742.2200, 2344.6800, 15.8400},
	{1742.9700, 2340.3600, 15.8200},
	{1743.7600, 2335.9000, 15.7900},
	{1754.6100, 2333.6300, 15.7600},
	{1753.8500, 2338.0300, 15.7600},
	{1753.0700, 2342.4500, 15.7600},
	{1752.3100, 2346.7800, 15.7500},
	{1751.5200, 2351.2500, 15.7500},
	{1750.7600, 2355.5600, 15.7500},
	{1749.9700, 2360.0700, 15.7400},
	{1749.2000, 2364.4900, 15.7400},
	{1786.6700, 2339.7900, 15.7500},
	{1784.3600, 2343.4300, 15.7600},
	{1781.9400, 2347.1800, 15.7600},
	{1779.4700, 2351.0400, 15.7600},
	{1777.1000, 2354.7400, 15.7600},
	{1774.7000, 2358.4800, 15.7600},
	{1772.2900, 2362.2500, 15.7600},
	{1769.8500, 2366.0500, 15.7600},
	{1767.4600, 2369.7900, 15.7600},
	{1765.0500, 2373.5400, 15.7700},
	{1762.6200, 2377.3300, 15.7700},
	{1759.5700, 2379.1100, 15.7600},
	{1755.0000, 2379.1100, 15.7600},
	{1750.6200, 2379.1100, 15.7600},
	{1746.1800, 2379.1100, 15.7600},
	{1741.5600, 2379.1100, 15.7600},
	{1737.1600, 2379.1100, 15.7600},
	{1742.7000, 2379.1100, 15.7600},
	{1728.3400, 2379.1100, 15.7600},
	{1723.8300, 2379.1100, 15.7600},
	{1719.3100, 2379.1100, 15.7600},
	{1714.8100, 2379.1100, 15.7700},
	{-721.1700, -1559.8800, 41.3200},
	{-718.9300, -1556.1900, 41.3300},
	{-716.8000, -1552.6300, 41.3300},
	{-714.6400, -1549.0100, 41.3300},
	{-712.4800, -1545.3900, 41.3300},
	{-710.2400, -1541.6100, 41.3300},
	{-708.0700, -1537.9900, 41.3200},
	{-705.9300, -1534.4100, 41.3200},
	{-703.7700, -1530.7900, 41.3200},
	{-716.0800, -1523.5300, 41.3200},
	{-718.2600, -1527.1700, 41.3200},
	{-720.4200, -1530.7900, 41.3200},
	{-722.5900, -1534.4200, 41.3200},
	{-724.7500, -1538.0400, 41.3200},
	{-726.9200, -1541.7000, 41.3200},
	{-729.0000, -1545.1800, 41.3100},
	{-731.3100, -1549.0400, 41.3100},
	{-733.4300, -1552.5900, 41.3200}
};

stock BRGarage_IsValid(garageid)
{
    return (0 <= garageid < MAX_BR_GARAGES);
}

stock BRGarage_GetPlayerGarage(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return -1;

    for(new garageid; garageid < MAX_BR_GARAGES; garageid ++)
    {
        if(g_br_garage[garageid][BRG_OWNER_ID] == account_id)
            return garageid;
    }
    return -1;
}

stock BRGarage_GetPlayerInside(playerid)
{
    new garageid = GetPVarInt(playerid, "br_garage_inside") - 1;
    if(BRGarage_IsValid(garageid)) return garageid;

    garageid = GetPlayerVirtualWorld(playerid) - BR_GARAGE_WORLD_BASE;
    if(BRGarage_IsValid(garageid)) return garageid;

    return -1;
}

stock BRGarage_FormatOwnerName(garageid, dest[], size = sizeof dest)
{
    if(g_br_garage[garageid][BRG_OWNER_ID] > 0)
        format(dest, size, "%s", g_br_garage[garageid][BRG_OWNER_NAME]);
    else
        format(dest, size, "Нет");
    return 1;
}

stock BRGarage_Save(garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;

    new query[384];
    mysql_format(mysql, query, sizeof query,
        "REPLACE INTO `br_garages` (`id`,`owner_id`,`owner_name`,`rent_time`,`locked`,`live`,`safe`,`elite`) VALUES (%d,%d,'%e',%d,%d,%d,%d,%d)",
        garageid + 1,
        g_br_garage[garageid][BRG_OWNER_ID],
        g_br_garage[garageid][BRG_OWNER_NAME],
        g_br_garage[garageid][BRG_RENT_TIME],
        g_br_garage[garageid][BRG_LOCK_STATUS],
        g_br_garage[garageid][BRG_LIVE],
        g_br_garage[garageid][BRG_SAFE],
        g_br_garage[garageid][BRG_ELITE]
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock BRGarage_Reset(garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;

    g_br_garage[garageid][BRG_OWNER_ID] = 0;
    g_br_garage[garageid][BRG_OWNER_NAME][0] = EOS;
    g_br_garage[garageid][BRG_RENT_TIME] = 0;
    g_br_garage[garageid][BRG_LOCK_STATUS] = BRG_LOCK_OPEN;
    g_br_garage[garageid][BRG_LIVE] = 0;
    g_br_garage[garageid][BRG_SAFE] = 0;
    g_br_garage[garageid][BRG_ELITE] = 0;

    new query[80];
    mysql_format(mysql, query, sizeof query, "DELETE FROM `br_garages` WHERE `id`=%d LIMIT 1", garageid + 1);
    mysql_query(mysql, query, false);

    BRGarage_UpdateLabel(garageid);
    return 1;
}

stock BRGarage_UpdateLabel(garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;

    new text[192], owner_name[MAX_PLAYER_NAME + 1];
    BRGarage_FormatOwnerName(garageid, owner_name, sizeof owner_name);

    if(g_br_garage[garageid][BRG_LABEL] != Text3D:INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(g_br_garage[garageid][BRG_LABEL]);
        g_br_garage[garageid][BRG_LABEL] = Text3D:INVALID_3DTEXT_ID;
    }

    if(g_br_garage[garageid][BRG_OWNER_ID] > 0)
    {
        format(text, sizeof text,
            "{FFFF00}Гараж №%d\n{FFFFFF}Владелец: {8B0000}%s\n%s",
            garageid + 1,
            owner_name,
            g_br_garage[garageid][BRG_LOCK_STATUS] ? ("{B22222}Гараж закрыт") : ("{00FF00}Гараж открыт")
        );
    }
    else
    {
        format(text, sizeof text, "{FFFF00}Гараж №%d\n{FFFFFF}Гараж продается\n{FFFFFF}Цена: {FFCD00}500000 руб.", garageid + 1);
    }

    g_br_garage[garageid][BRG_LABEL] = CreateDynamic3DTextLabel(text, 0xFFFF00FF,
        g_br_garage[garageid][BRG_POS_X],
        g_br_garage[garageid][BRG_POS_Y],
        g_br_garage[garageid][BRG_POS_Z] + 1.0,
        12.0
    );
    return 1;
}

stock BRGarage_InitDefaults()
{
    for(new garageid; garageid < MAX_BR_GARAGES; garageid ++)
    {
        g_br_garage[garageid][BRG_OWNER_ID] = 0;
        g_br_garage[garageid][BRG_OWNER_NAME][0] = EOS;
        g_br_garage[garageid][BRG_RENT_TIME] = 0;
        g_br_garage[garageid][BRG_LOCK_STATUS] = BRG_LOCK_OPEN;
        g_br_garage[garageid][BRG_LIVE] = 0;
        g_br_garage[garageid][BRG_SAFE] = 0;
        g_br_garage[garageid][BRG_ELITE] = 0;
        g_br_garage[garageid][BRG_POS_X] = g_br_garage_pos[garageid][0];
        g_br_garage[garageid][BRG_POS_Y] = g_br_garage_pos[garageid][1];
        g_br_garage[garageid][BRG_POS_Z] = g_br_garage_pos[garageid][2];
        g_br_garage[garageid][BRG_PICKUP_ID] = -1;
        g_br_garage[garageid][BRG_LABEL] = Text3D:INVALID_3DTEXT_ID;
    }
    return 1;
}

stock BRGarages_Init()
{
    BRGarage_InitDefaults();

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `br_garages` (`id` int(11) NOT NULL, `owner_id` int(11) NOT NULL DEFAULT 0, `owner_name` varchar(24) NOT NULL DEFAULT '', `rent_time` int(11) NOT NULL DEFAULT 0, `locked` tinyint(1) NOT NULL DEFAULT 0, `live` tinyint(1) NOT NULL DEFAULT 0, `safe` tinyint(1) NOT NULL DEFAULT 0, `elite` tinyint(1) NOT NULL DEFAULT 0, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;",
        false
    );

    new Cache: result = mysql_query(mysql, "SELECT * FROM `br_garages`", true);
    new rows = cache_num_rows();

    for(new row; row < rows; row ++)
    {
        new garageid = cache_get_field_content_int(row, "id") - 1;
        if(!BRGarage_IsValid(garageid)) continue;

        g_br_garage[garageid][BRG_OWNER_ID] = cache_get_field_content_int(row, "owner_id");
        cache_get_field_content(row, "owner_name", g_br_garage[garageid][BRG_OWNER_NAME], mysql, MAX_PLAYER_NAME + 1);
        g_br_garage[garageid][BRG_RENT_TIME] = cache_get_field_content_int(row, "rent_time");
        g_br_garage[garageid][BRG_LOCK_STATUS] = cache_get_field_content_int(row, "locked");
        g_br_garage[garageid][BRG_LIVE] = cache_get_field_content_int(row, "live");
        g_br_garage[garageid][BRG_SAFE] = cache_get_field_content_int(row, "safe");
        g_br_garage[garageid][BRG_ELITE] = cache_get_field_content_int(row, "elite");
    }
    cache_delete(result);

    for(new garageid; garageid < MAX_BR_GARAGES; garageid ++)
    {
        g_br_garage[garageid][BRG_PICKUP_ID] = CreatePickup(1318, 23,
            g_br_garage[garageid][BRG_POS_X],
            g_br_garage[garageid][BRG_POS_Y],
            g_br_garage[garageid][BRG_POS_Z],
            0,
            PICKUP_ACTION_TYPE_BR_GARAGE,
            garageid
        );
        BRGarage_UpdateLabel(garageid);
    }

    CreatePickup(1318, 23, 1.2011, 1994.7356, 1554.2031, -1, PICKUP_ACTION_TYPE_BR_GARAGE_EXIT);
    CreateDynamic3DTextLabel("Нажмите на {8B0000}гудок\n{FFFFFF}Чтобы выехать", 0xFFFF00FF, 1.2011, 1994.7356, 1554.2031 + 1.0, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Выход из гаража", 0xFFFF00FF, -0.2940, 2006.1187, 1554.2031 + 1.0, 9.0, _, _, _, -1, -1);

    g_br_garage_loaded = MAX_BR_GARAGES;
    printf("[BRGarages]: loaded %d garages", g_br_garage_loaded);
    return 1;
}

stock BRGarage_ShowInfo(playerid, garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;

    SetPVarInt(playerid, "br_garage_select", garageid + 1);

    new owner_name[MAX_PLAYER_NAME + 1], text[320];
    BRGarage_FormatOwnerName(garageid, owner_name, sizeof owner_name);

    if(g_br_garage[garageid][BRG_OWNER_ID] <= 0)
    {
        format(text, sizeof text,
            "Номер гаража: %d\nСостояние: продается\nСтоимость: 500000 рублей",
            garageid + 1
        );
        Dialog(playerid, DIALOG_BR_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{8B0000}Покупка гаража", text, "Купить", "Закрыть");
        return 1;
    }

    format(text, sizeof text,
        "Номер гаража: %d\nВладелец: %s\nСостояние: %s\nОплачен на: %d дней\nСтоимость: 500000 руб.",
        garageid + 1,
        owner_name,
        g_br_garage[garageid][BRG_LOCK_STATUS] ? ("закрыт") : ("открыт"),
        g_br_garage[garageid][BRG_RENT_TIME] > gettime() ? ((g_br_garage[garageid][BRG_RENT_TIME] - gettime()) / 86400) + 1 : 0
    );

    if(g_br_garage[garageid][BRG_OWNER_ID] == GetPlayerAccountID(playerid))
        Dialog(playerid, DIALOG_BR_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "{8B0000}Информация о гараже", text, "Изменить", "Закрыть");
    else
        Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{8B0000}Информация о гараже", text, "Закрыть", "");

    return 1;
}

stock BRGarage_ShowMenu(playerid, garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;
    if(g_br_garage[garageid][BRG_OWNER_ID] != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот гараж вам не принадлежит");

    SetPVarInt(playerid, "br_garage_select", garageid + 1);
    Dialog(playerid, DIALOG_BR_GARAGE_MENU, DIALOG_STYLE_LIST,
        "{8B0000}Панель гаража",
        "1. Открыть/Закрыть гараж\n2. Продать гараж\n3. Улучшения\n4. Доставить транспорт в гараж\n5. Отметить гараж на GPS",
        "Выбрать", "Закрыть"
    );
    return 1;
}

stock BRGarage_Enter(playerid, garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;
    if(g_br_garage[garageid][BRG_OWNER_ID] <= 0) return BRGarage_ShowInfo(playerid, garageid);
    if(g_br_garage[garageid][BRG_LOCK_STATUS] && g_br_garage[garageid][BRG_OWNER_ID] != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Гараж закрыт");

    SetPVarInt(playerid, "br_garage_inside", garageid + 1);
    SetPlayerPosEx(playerid, -0.2940, 2006.1187, 1554.2031, 180.0, BR_GARAGE_INTERIOR, BR_GARAGE_WORLD_BASE + garageid);
    return 1;
}

stock BRGarage_Exit(playerid)
{
    new garageid = BRGarage_GetPlayerInside(playerid);
    if(!BRGarage_IsValid(garageid)) return 0;

    DeletePVar(playerid, "br_garage_inside");
    SetPlayerPosEx(playerid,
        g_br_garage[garageid][BRG_POS_X],
        g_br_garage[garageid][BRG_POS_Y],
        g_br_garage[garageid][BRG_POS_Z],
        0.0,
        0,
        0
    );
    return 1;
}

stock BRGarage_DeliverVehicle(playerid, garageid)
{
    if(!BRGarage_IsValid(garageid)) return 0;
    if(g_br_garage[garageid][BRG_OWNER_ID] != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот гараж вам не принадлежит");

    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен");

    SetVehiclePos(vehicleid, 1.7160, 1999.7250, 1554.2031);
    SetVehicleZAngle(vehicleid, 180.0);
    LinkVehicleToInterior(vehicleid, BR_GARAGE_INTERIOR);
    SetVehicleVirtualWorld(vehicleid, BR_GARAGE_WORLD_BASE + garageid);

    if(IsPlayerInVehicle(playerid, vehicleid))
    {
        SetPlayerInterior(playerid, BR_GARAGE_INTERIOR);
        SetPlayerVirtualWorld(playerid, BR_GARAGE_WORLD_BASE + garageid);
        SetCameraBehindPlayer(playerid);
        SetPVarInt(playerid, "br_garage_inside", garageid + 1);
    }

    SendClientMessage(playerid, 0x66CC00FF, "Транспорт доставлен в гараж");
    return 1;
}

stock BRGarage_VehicleExit(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1.2011, 1994.7356, 1554.2031)) return 0;

    new garageid = BRGarage_GetPlayerInside(playerid);
    if(!BRGarage_IsValid(garageid)) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    if(GetPlayerOwnableCar(playerid) != vehicleid) return SendClientMessage(playerid, 0x999999FF, "Вы должны быть за рулем своего личного транспорта");

    SetVehiclePos(vehicleid,
        g_br_garage[garageid][BRG_POS_X],
        g_br_garage[garageid][BRG_POS_Y],
        g_br_garage[garageid][BRG_POS_Z]
    );
    SetVehicleZAngle(vehicleid, 0.0);
    LinkVehicleToInterior(vehicleid, 0);
    SetVehicleVirtualWorld(vehicleid, 0);

    for(new i; i < MAX_PLAYERS; i ++)
    {
        if(IsPlayerInVehicle(i, vehicleid))
        {
            SetPlayerInterior(i, 0);
            SetPlayerVirtualWorld(i, 0);
            SetCameraBehindPlayer(i);
            DeletePVar(i, "br_garage_inside");
        }
    }
    return 1;
}

stock BRGarage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(((newkeys & KEY_CROUCH) == KEY_CROUCH) && ((oldkeys & KEY_CROUCH) != KEY_CROUCH))
    {
        if(BRGarage_VehicleExit(playerid)) return 1;
    }
    return 0;
}

stock BRGarage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_BR_GARAGE_BUY:
        {
            new garageid = GetPVarInt(playerid, "br_garage_select") - 1;
            if(!response) return 1;
            if(!BRGarage_IsValid(garageid)) return 1;
            if(g_br_garage[garageid][BRG_OWNER_ID] > 0) return SendClientMessage(playerid, 0x999999FF, "Этот гараж уже куплен");
            if(BRGarage_GetPlayerGarage(playerid) != -1) return SendClientMessage(playerid, 0x999999FF, "У вас уже есть гараж");
            if(GetPlayerMoneyEx(playerid) < BR_GARAGE_PRICE) return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки гаража");

            GivePlayerMoneyEx(playerid, -BR_GARAGE_PRICE, "Покупка гаража", true, true);
            g_br_garage[garageid][BRG_OWNER_ID] = GetPlayerAccountID(playerid);
            format(g_br_garage[garageid][BRG_OWNER_NAME], MAX_PLAYER_NAME + 1, "%s", GetPlayerNameEx(playerid));
            g_br_garage[garageid][BRG_RENT_TIME] = gettime() + (BR_GARAGE_RENT_DAYS * 86400);
            g_br_garage[garageid][BRG_LOCK_STATUS] = BRG_LOCK_OPEN;
            BRGarage_Save(garageid);
            BRGarage_UpdateLabel(garageid);

            SendClientMessage(playerid, 0x66CC00FF, "Поздравляем с покупкой гаража. Используйте /garage для управления");
            return 1;
        }
        case DIALOG_BR_GARAGE_INFO:
        {
            if(!response) return 1;
            new garageid = GetPVarInt(playerid, "br_garage_select") - 1;
            return BRGarage_ShowMenu(playerid, garageid);
        }
        case DIALOG_BR_GARAGE_MENU:
        {
            new garageid = GetPVarInt(playerid, "br_garage_select") - 1;
            if(!response) return 1;
            if(!BRGarage_IsValid(garageid)) return 1;
            if(g_br_garage[garageid][BRG_OWNER_ID] != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот гараж вам не принадлежит");

            switch(listitem)
            {
                case 0:
                {
                    g_br_garage[garageid][BRG_LOCK_STATUS] = !g_br_garage[garageid][BRG_LOCK_STATUS];
                    BRGarage_Save(garageid);
                    BRGarage_UpdateLabel(garageid);
                    SendClientMessage(playerid, 0x66CC00FF, g_br_garage[garageid][BRG_LOCK_STATUS] ? ("Гараж закрыт") : ("Гараж открыт"));
                    return BRGarage_ShowMenu(playerid, garageid);
                }
                case 1:
                {
                    Dialog(playerid, DIALOG_BR_GARAGE_SELL_CONFIRM, DIALOG_STYLE_MSGBOX, "{8B0000}Продажа гаража", "Вы действительно хотите продать гараж государству за 250000 рублей?", "Продать", "Отмена");
                    return 1;
                }
                case 2:
                {
                    Dialog(playerid, DIALOG_BR_GARAGE_UPGRADE, DIALOG_STYLE_LIST,
                        "{8B0000}Улучшения",
                        "1. Возможность проживания в гараже - 30000 руб.\n2. Сейф в гараже - 40000 руб.\n3. Улучшение до элитного - 5000000 руб.",
                        "Купить", "Назад"
                    );
                    return 1;
                }
                case 3:
                {
                    BRGarage_DeliverVehicle(playerid, garageid);
                    return 1;
                }
                case 4:
                {
                    EnablePlayerGPS(playerid, 55, g_br_garage[garageid][BRG_POS_X], g_br_garage[garageid][BRG_POS_Y], g_br_garage[garageid][BRG_POS_Z], "Гараж отмечен на GPS");
                    return 1;
                }
            }
            return 1;
        }
        case DIALOG_BR_GARAGE_SELL_CONFIRM:
        {
            new garageid = GetPVarInt(playerid, "br_garage_select") - 1;
            if(!response) return BRGarage_ShowMenu(playerid, garageid);
            if(!BRGarage_IsValid(garageid)) return 1;
            if(g_br_garage[garageid][BRG_OWNER_ID] != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот гараж вам не принадлежит");

            BRGarage_Reset(garageid);
            GivePlayerMoneyEx(playerid, BR_GARAGE_SELL_PRICE, "Продажа гаража", true, true);
            SendClientMessage(playerid, 0x66CC00FF, "Вы продали гараж государству");
            return 1;
        }
        case DIALOG_BR_GARAGE_UPGRADE:
        {
            new garageid = GetPVarInt(playerid, "br_garage_select") - 1;
            if(!response) return BRGarage_ShowMenu(playerid, garageid);
            if(!BRGarage_IsValid(garageid)) return 1;
            if(g_br_garage[garageid][BRG_OWNER_ID] != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот гараж вам не принадлежит");

            new price, field;
            switch(listitem)
            {
                case 0: { price = BR_GARAGE_LIVE_PRICE; field = BRG_LIVE; }
                case 1: { price = BR_GARAGE_SAFE_PRICE; field = BRG_SAFE; }
                case 2: { price = BR_GARAGE_ELITE_PRICE; field = BRG_ELITE; }
                default: return 1;
            }

            if(g_br_garage[garageid][field]) return SendClientMessage(playerid, 0x999999FF, "Это улучшение уже куплено");
            if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");

            GivePlayerMoneyEx(playerid, -price, "Улучшение гаража", true, true);
            g_br_garage[garageid][field] = 1;
            BRGarage_Save(garageid);
            SendClientMessage(playerid, 0x66CC00FF, "Улучшение куплено");
            return BRGarage_ShowMenu(playerid, garageid);
        }
    }
    return 0;
}

CMD:garage(playerid)
{
    new garageid = BRGarage_GetPlayerInside(playerid);
    if(!BRGarage_IsValid(garageid)) garageid = BRGarage_GetPlayerGarage(playerid);

    if(!BRGarage_IsValid(garageid))
        return SendClientMessage(playerid, 0x999999FF, "У вас нет гаража");

    return BRGarage_ShowInfo(playerid, garageid);
}

CMD:addgarage(playerid)
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;
    SendClientMessage(playerid, 0xCECECEFF, "Гаражи БР загружаются из массива на 151 место. Для добавления новых точек измените g_br_garage_pos.");
    return 1;
}
