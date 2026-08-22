#if defined _transport_company_management_included
    #endinput
#endif
#define _transport_company_management_included

#define MAX_TC_COMPANIES                  (2)
#define MAX_TC_MEMBER_LIST                (32)
#define TC_COMPANY_NONE                   (-1)
#define TC_RANK_DRIVER                    (1)
#define TC_RANK_MANAGER                   (2)
#define TC_RANK_OWNER                     (3)
#define TC_AUCTION_MIN_PRICE              (1000000)
#define TC_AUCTION_DEFAULT_HOURS          (24)
#define TC_AUCTION_ANTISNIPE_SECONDS      (300)
#define TC_FLEET_TRUCK_PRICE              (2500000)
#define TC_FLEET_SLOT_PRICE               (5000000)
#define TC_MAX_FLEET                      (20)
#define TC_MAX_MEMBERS_LIMIT              (30)

#define DIALOG_TC_MAIN                    (42100)
#define DIALOG_TC_COMPANY_LIST            (42101)
#define DIALOG_TC_COMPANY_VIEW            (42102)
#define DIALOG_TC_EMPLOYEES               (42103)
#define DIALOG_TC_EMPLOYEE_ACTION         (42104)
#define DIALOG_TC_APPLICATIONS            (42105)
#define DIALOG_TC_APPLICATION_ACTION      (42106)
#define DIALOG_TC_FINANCE                 (42107)
#define DIALOG_TC_DEPOSIT                 (42108)
#define DIALOG_TC_WITHDRAW                (42109)
#define DIALOG_TC_SETTINGS                (42110)
#define DIALOG_TC_PAYOUT                  (42111)
#define DIALOG_TC_RENAME                  (42112)
#define DIALOG_TC_FLEET                   (42113)
#define DIALOG_TC_AUCTION_LIST            (42114)
#define DIALOG_TC_AUCTION_VIEW            (42115)
#define DIALOG_TC_AUCTION_BID             (42116)
#define DIALOG_TC_AUCTION_START           (42117)
#define DIALOG_TC_LEAVE_CONFIRM           (42118)
#define DIALOG_TC_KICK_CONFIRM            (42119)
#define DIALOG_TC_HELP                    (42120)
#define DIALOG_TC_HISTORY                 (42121)
#define DIALOG_TC_FLEET_INFO              (42122)

#define TC_COLOR_MAIN                     "{FFAE00}"
#define TC_COLOR_TEXT                     "{FFFFFF}"
#define TC_COLOR_GRAY                     "{B8B8B8}"
#define TC_PREFIX                         "{FFAE00}[Транспортная компания] {FFFFFF}"

enum E_TC_COMPANY_DATA
{
    bool:TC_LOADED,
    TC_SQL_ID,
    TC_NAME[32],
    TC_LOCALITY,
    TC_OWNER_ACCOUNT,
    TC_OWNER_NAME[24],
    TC_BALANCE,
    TC_PAYOUT_PERCENT,
    TC_LEVEL,
    TC_REPUTATION,
    TC_COMPLETED_ORDERS,
    TC_FLEET_COUNT,
    TC_FLEET_CAPACITY,
    TC_MAX_MEMBERS,
    bool:TC_AUCTION_ACTIVE,
    TC_AUCTION_START_PRICE,
    TC_AUCTION_CURRENT_BID,
    TC_AUCTION_BIDDER_ACCOUNT,
    TC_AUCTION_BIDDER_NAME[24],
    TC_AUCTION_END,
    TC_AUCTION_LISTED_BY
};
new g_TCCompany[MAX_TC_COMPANIES][E_TC_COMPANY_DATA];
new g_TCActiveTrucks[MAX_TC_COMPANIES];
new bool:g_TCManagementInitialized;
new g_TCSelectedCompany[MAX_PLAYERS];
new g_TCSelectedAccount[MAX_PLAYERS];
new g_TCSelectedApplication[MAX_PLAYERS];
new g_TCCompanyList[MAX_PLAYERS][MAX_TC_COMPANIES];
new g_TCMemberList[MAX_PLAYERS][MAX_TC_MEMBER_LIST];
new g_TCApplicationList[MAX_PLAYERS][MAX_TC_MEMBER_LIST];

forward TransportCompany_Init();
forward TCM_AuctionTick();
forward TCM_LoadPlayer(playerid);
forward TCM_RefreshPlayerByAccount(account_id);

stock TCM_IsValidCompany(companyid)
{
    return 0 <= companyid < MAX_TC_COMPANIES && g_TCCompany[companyid][TC_LOADED];
}

stock TCM_GetLocalityName(companyid, output[], size)
{
    if(!TCM_IsValidCompany(companyid)) return format(output, size, "Неизвестно");
    if(g_TCCompany[companyid][TC_LOCALITY] == TC_LOCALITY_BATUREVO) format(output, size, "Батырево");
    else format(output, size, "Бусаево");
    return 1;
}

stock TCM_GetRankName(rank, output[], size)
{
    switch(rank)
    {
        case TC_RANK_OWNER: format(output, size, "Владелец");
        case TC_RANK_MANAGER: format(output, size, "Управляющий");
        default: format(output, size, "Водитель");
    }
    return 1;
}

stock TCM_FormatTime(seconds, output[], size)
{
    if(seconds < 0) seconds = 0;
    new days = seconds / 86400;
    new hours = (seconds % 86400) / 3600;
    new minutes = (seconds % 3600) / 60;
    if(days > 0) format(output, size, "%d д. %d ч.", days, hours);
    else if(hours > 0) format(output, size, "%d ч. %d мин.", hours, minutes);
    else format(output, size, "%d мин.", minutes);
    return 1;
}

stock TCM_FindOnlineAccount(account_id)
{
    foreach(new playerid : Player)
    {
        if(IsPlayerLogged(playerid) && GetPlayerAccountID(playerid) == account_id)
            return playerid;
    }
    return INVALID_PLAYER_ID;
}

stock TCM_CreditAccount(account_id, amount, reason[] = "Транспортная компания")
{
    if(account_id <= 0 || amount <= 0) return 0;
    new playerid = TCM_FindOnlineAccount(account_id);
    if(playerid != INVALID_PLAYER_ID)
    {
        GivePlayerMoneyEx(playerid, amount, reason, true, true);
        return 1;
    }
    new query[192];
    mysql_format(mysql, query, sizeof query,
        "UPDATE `accounts` SET `money`=LEAST(2147000000,`money`+%d) WHERE `id`=%d LIMIT 1",
        amount, account_id
    );
    mysql_query(mysql, query, false);
    return mysql_errno() == 0;
}

stock TCM_LogTransaction(companyid, account_id, amount, const action[])
{
    if(!TCM_IsValidCompany(companyid)) return 0;
    new query[384], actor_name[24] = "SYSTEM";
    new online = TCM_FindOnlineAccount(account_id);
    if(online != INVALID_PLAYER_ID) format(actor_name, sizeof actor_name, "%s", GetPlayerNameEx(online));
    else if(account_id > 0) format(actor_name, sizeof actor_name, "Account_%d", account_id);
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `transport_company_transactions` (`company_id`,`account_id`,`player_name`,`amount`,`action`,`created_at`) VALUES (%d,%d,'%e',%d,'%e',%d)",
        companyid, account_id, actor_name, amount, action, gettime()
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock TCM_SaveCompany(companyid)
{
    if(!TCM_IsValidCompany(companyid)) return 0;
    new query[1600];
    mysql_format(mysql, query, sizeof query,
        "UPDATE `transport_companies` SET `name`='%e',`locality`=%d,`owner_account`=%d,`owner_name`='%e',`balance`=%d,`payout_percent`=%d,`level`=%d,`reputation`=%d,`completed_orders`=%d,`fleet_count`=%d,`fleet_capacity`=%d,`max_members`=%d,`auction_active`=%d,`auction_start_price`=%d,`auction_current_bid`=%d,`auction_bidder_account`=%d,`auction_bidder_name`='%e',`auction_end`=%d,`auction_listed_by`=%d WHERE `id`=%d LIMIT 1",
        g_TCCompany[companyid][TC_NAME],
        g_TCCompany[companyid][TC_LOCALITY],
        g_TCCompany[companyid][TC_OWNER_ACCOUNT],
        g_TCCompany[companyid][TC_OWNER_NAME],
        g_TCCompany[companyid][TC_BALANCE],
        g_TCCompany[companyid][TC_PAYOUT_PERCENT],
        g_TCCompany[companyid][TC_LEVEL],
        g_TCCompany[companyid][TC_REPUTATION],
        g_TCCompany[companyid][TC_COMPLETED_ORDERS],
        g_TCCompany[companyid][TC_FLEET_COUNT],
        g_TCCompany[companyid][TC_FLEET_CAPACITY],
        g_TCCompany[companyid][TC_MAX_MEMBERS],
        g_TCCompany[companyid][TC_AUCTION_ACTIVE],
        g_TCCompany[companyid][TC_AUCTION_START_PRICE],
        g_TCCompany[companyid][TC_AUCTION_CURRENT_BID],
        g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT],
        g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME],
        g_TCCompany[companyid][TC_AUCTION_END],
        g_TCCompany[companyid][TC_AUCTION_LISTED_BY],
        companyid
    );
    mysql_query(mysql, query, false);
    return mysql_errno() == 0;
}

stock TCM_CreateTables()
{
    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `transport_companies` (`id` INT NOT NULL,`name` VARCHAR(32) NOT NULL,`locality` INT NOT NULL,`owner_account` INT NOT NULL DEFAULT -1,`owner_name` VARCHAR(24) NOT NULL DEFAULT 'Государство',`balance` INT NOT NULL DEFAULT 0,`payout_percent` INT NOT NULL DEFAULT 85,`level` INT NOT NULL DEFAULT 1,`reputation` INT NOT NULL DEFAULT 0,`completed_orders` INT NOT NULL DEFAULT 0,`fleet_count` INT NOT NULL DEFAULT 3,`fleet_capacity` INT NOT NULL DEFAULT 5,`max_members` INT NOT NULL DEFAULT 10,`auction_active` TINYINT NOT NULL DEFAULT 1,`auction_start_price` INT NOT NULL DEFAULT 15000000,`auction_current_bid` INT NOT NULL DEFAULT 15000000,`auction_bidder_account` INT NOT NULL DEFAULT -1,`auction_bidder_name` VARCHAR(24) NOT NULL DEFAULT '-',`auction_end` INT NOT NULL DEFAULT 0,`auction_listed_by` INT NOT NULL DEFAULT -1,PRIMARY KEY (`id`),KEY `idx_tc_owner` (`owner_account`),KEY `idx_tc_auction` (`auction_active`,`auction_end`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    if(mysql_errno()) { printf("[TCM] transport_companies create failed: %d", mysql_errno()); return 0; }

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `transport_company_members` (`account_id` INT NOT NULL,`company_id` INT NOT NULL,`player_name` VARCHAR(24) NOT NULL,`rank` INT NOT NULL DEFAULT 1,`deliveries` INT NOT NULL DEFAULT 0,`earned` INT NOT NULL DEFAULT 0,`joined_at` INT NOT NULL,`last_online` INT NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`),KEY `idx_tc_members_company` (`company_id`,`rank`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    if(mysql_errno()) { printf("[TCM] members create failed: %d", mysql_errno()); return 0; }

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `transport_company_applications` (`id` INT NOT NULL AUTO_INCREMENT,`company_id` INT NOT NULL,`account_id` INT NOT NULL,`player_name` VARCHAR(24) NOT NULL,`created_at` INT NOT NULL,PRIMARY KEY (`id`),UNIQUE KEY `uniq_tc_application` (`company_id`,`account_id`),KEY `idx_tc_app_company` (`company_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    if(mysql_errno()) { printf("[TCM] applications create failed: %d", mysql_errno()); return 0; }

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `transport_company_transactions` (`id` INT NOT NULL AUTO_INCREMENT,`company_id` INT NOT NULL,`account_id` INT NOT NULL,`player_name` VARCHAR(24) NOT NULL DEFAULT '-',`amount` INT NOT NULL,`action` VARCHAR(64) NOT NULL,`created_at` INT NOT NULL,PRIMARY KEY (`id`),KEY `idx_tc_transactions` (`company_id`,`created_at`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    return mysql_errno() == 0;
}

stock TCM_SeedCompanies()
{
    new end_time = gettime() + TC_AUCTION_DEFAULT_HOURS * 3600;
    new query[1024];
    mysql_format(mysql, query, sizeof query,
        "INSERT IGNORE INTO `transport_companies` (`id`,`name`,`locality`,`owner_account`,`owner_name`,`fleet_count`,`fleet_capacity`,`max_members`,`auction_active`,`auction_start_price`,`auction_current_bid`,`auction_end`,`auction_listed_by`) VALUES (0,'Батырево Транс',%d,-1,'Государство',3,5,10,1,15000000,15000000,%d,-1),(1,'Бусаево Логистик',%d,-1,'Государство',3,5,10,1,18000000,18000000,%d,-1)",
        TC_LOCALITY_BATUREVO, end_time, TC_LOCALITY_BUSAEVO, end_time
    );
    mysql_query(mysql, query, false);
    return mysql_errno() == 0;
}

stock TCM_LoadCompanies()
{
    for(new i; i < MAX_TC_COMPANIES; i++)
    {
        g_TCCompany[i][TC_LOADED] = false;
        g_TCActiveTrucks[i] = 0;
    }
    new Cache:result = mysql_query(mysql, "SELECT * FROM `transport_companies` ORDER BY `id` ASC", true);
    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }
    new rows = cache_num_rows();
    for(new row; row < rows; row++)
    {
        new id = cache_get_field_content_int(row, "id");
        if(!(0 <= id < MAX_TC_COMPANIES)) continue;
        g_TCCompany[id][TC_SQL_ID] = id;
        cache_get_field_content(row, "name", g_TCCompany[id][TC_NAME], mysql, 32);
        g_TCCompany[id][TC_LOCALITY] = cache_get_field_content_int(row, "locality");
        g_TCCompany[id][TC_OWNER_ACCOUNT] = cache_get_field_content_int(row, "owner_account");
        cache_get_field_content(row, "owner_name", g_TCCompany[id][TC_OWNER_NAME], mysql, 24);
        g_TCCompany[id][TC_BALANCE] = cache_get_field_content_int(row, "balance");
        g_TCCompany[id][TC_PAYOUT_PERCENT] = cache_get_field_content_int(row, "payout_percent");
        g_TCCompany[id][TC_LEVEL] = cache_get_field_content_int(row, "level");
        g_TCCompany[id][TC_REPUTATION] = cache_get_field_content_int(row, "reputation");
        g_TCCompany[id][TC_COMPLETED_ORDERS] = cache_get_field_content_int(row, "completed_orders");
        g_TCCompany[id][TC_FLEET_COUNT] = cache_get_field_content_int(row, "fleet_count");
        g_TCCompany[id][TC_FLEET_CAPACITY] = cache_get_field_content_int(row, "fleet_capacity");
        g_TCCompany[id][TC_MAX_MEMBERS] = cache_get_field_content_int(row, "max_members");
        g_TCCompany[id][TC_AUCTION_ACTIVE] = bool:cache_get_field_content_int(row, "auction_active");
        g_TCCompany[id][TC_AUCTION_START_PRICE] = cache_get_field_content_int(row, "auction_start_price");
        g_TCCompany[id][TC_AUCTION_CURRENT_BID] = cache_get_field_content_int(row, "auction_current_bid");
        g_TCCompany[id][TC_AUCTION_BIDDER_ACCOUNT] = cache_get_field_content_int(row, "auction_bidder_account");
        cache_get_field_content(row, "auction_bidder_name", g_TCCompany[id][TC_AUCTION_BIDDER_NAME], mysql, 24);
        g_TCCompany[id][TC_AUCTION_END] = cache_get_field_content_int(row, "auction_end");
        g_TCCompany[id][TC_AUCTION_LISTED_BY] = cache_get_field_content_int(row, "auction_listed_by");
        g_TCCompany[id][TC_LOADED] = true;
    }
    cache_delete(result);
    printf("[TCM] Loaded transport companies: %d", rows);
    return 1;
}

public TransportCompany_Init()
{
    if(g_TCManagementInitialized) return 1;
    if(!mysql) return 0;
    if(!TCM_CreateTables()) return 0;
    TCM_SeedCompanies();
    TCM_LoadCompanies();
    SetTimer("TCM_AuctionTick", 60000, true);
    g_TCManagementInitialized = true;
    print("[TCM] Auction and management system initialized.");
    return 1;
}

public TCM_LoadPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerLogged(playerid)) { SetTimerEx("TCM_LoadPlayer", 3000, false, "i", playerid); return 0; }
    player_tc[playerid][p_TC_Copmany] = TC_COMPANY_NONE;
    player_tc[playerid][p_TC_Owner] = 0;
    player_tc[playerid][p_TC_Active] = false;
    DeletePVar(playerid, "tc_fleet_reserved");

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT `company_id`,`rank` FROM `transport_company_members` WHERE `account_id`=%d LIMIT 1",
        GetPlayerAccountID(playerid)
    );
    new Cache:result = mysql_query(mysql, query, true);
    if(cache_num_rows())
    {
        player_tc[playerid][p_TC_Copmany] = cache_get_field_content_int(0, "company_id");
        player_tc[playerid][p_TC_Owner] = cache_get_field_content_int(0, "rank");
        player_tc[playerid][p_TC_Active] = true;
        mysql_format(mysql, query, sizeof query,
            "UPDATE `transport_company_members` SET `player_name`='%e',`last_online`=%d WHERE `account_id`=%d LIMIT 1",
            GetPlayerNameEx(playerid), gettime(), GetPlayerAccountID(playerid)
        );
        mysql_query(mysql, query, false);
    }
    cache_delete(result);
    return 1;
}

public TCM_RefreshPlayerByAccount(account_id)
{
    new playerid = TCM_FindOnlineAccount(account_id);
    if(playerid != INVALID_PLAYER_ID) TCM_LoadPlayer(playerid);
    return 1;
}

stock TCM_GetMemberCount(companyid)
{
    if(!TCM_IsValidCompany(companyid)) return 0;
    new query[128];
    mysql_format(mysql, query, sizeof query, "SELECT COUNT(*) FROM `transport_company_members` WHERE `company_id`=%d", companyid);
    new Cache:result = mysql_query(mysql, query, true);
    new count = cache_get_row_int(0, 0);
    cache_delete(result);
    return count;
}

stock TCM_IsManager(playerid)
{
    return player_tc[playerid][p_TC_Active] && player_tc[playerid][p_TC_Owner] >= TC_RANK_MANAGER;
}

stock TCM_IsOwner(playerid)
{
    return player_tc[playerid][p_TC_Active] && player_tc[playerid][p_TC_Owner] == TC_RANK_OWNER;
}

stock TCM_PlayerOwnsAnyCompany(account_id)
{
    for(new i; i < MAX_TC_COMPANIES; i++)
        if(TCM_IsValidCompany(i) && g_TCCompany[i][TC_OWNER_ACCOUNT] == account_id) return i;
    return TC_COMPANY_NONE;
}

stock TC_CanStartOrder(playerid)
{
    if(!player_tc[playerid][p_TC_Active] || !TCM_IsValidCompany(player_tc[playerid][p_TC_Copmany]))
    {
        SendClientMessage(playerid, -1, TC_PREFIX"Для выполнения заказов вступите в транспортную компанию. Используйте /company.");
        return 0;
    }
    new companyid = player_tc[playerid][p_TC_Copmany];
    new expected_locality = g_TCCompany[companyid][TC_LOCALITY];
    new current_locality = GetPlayerVirtualWorld(playerid) == 2 ? TC_LOCALITY_BUSAEVO : TC_LOCALITY_BATUREVO;
    if(expected_locality != current_locality)
    {
        SendClientMessage(playerid, -1, TC_PREFIX"Принимайте заказы в офисе своей транспортной компании.");
        return 0;
    }
    if(g_TCCompany[companyid][TC_FLEET_COUNT] <= 0)
    {
        SendClientMessage(playerid, -1, TC_PREFIX"В автопарке компании нет грузовиков.");
        return 0;
    }
    return 1;
}

stock TC_ReserveFleetSlot(playerid)
{
    if(GetPVarInt(playerid, "tc_fleet_reserved")) return 1;
    if(!TC_CanStartOrder(playerid)) return 0;
    new companyid = player_tc[playerid][p_TC_Copmany];
    if(g_TCActiveTrucks[companyid] >= g_TCCompany[companyid][TC_FLEET_COUNT])
    {
        SendClientMessage(playerid, -1, TC_PREFIX"Все грузовики компании сейчас заняты сотрудниками.");
        return 0;
    }
    g_TCActiveTrucks[companyid]++;
    SetPVarInt(playerid, "tc_fleet_reserved", companyid + 1);
    return 1;
}

stock TC_ReleaseFleetSlot(playerid)
{
    new value = GetPVarInt(playerid, "tc_fleet_reserved");
    if(value > 0)
    {
        new companyid = value - 1;
        if(0 <= companyid < MAX_TC_COMPANIES && g_TCActiveTrucks[companyid] > 0)
            g_TCActiveTrucks[companyid]--;
        DeletePVar(playerid, "tc_fleet_reserved");
    }
    return 1;
}

stock TC_CompleteDeliveryReward(playerid, gross_salary)
{
    new companyid = player_tc[playerid][p_TC_Copmany];
    if(!TCM_IsValidCompany(companyid))
    {
        GivePlayerMoneyEx(playerid, gross_salary, "Заказ дальнобойщика", true, true);
        TC_ReleaseFleetSlot(playerid);
        return gross_salary;
    }
    new percent = g_TCCompany[companyid][TC_PAYOUT_PERCENT];
    if(percent < 50) percent = 50;
    if(percent > 100) percent = 100;
    new driver_salary = gross_salary * percent / 100;
    new company_income = gross_salary - driver_salary;
    GivePlayerMoneyEx(playerid, driver_salary, "Зарплата транспортной компании", true, true);
    g_TCCompany[companyid][TC_BALANCE] += company_income;
    g_TCCompany[companyid][TC_COMPLETED_ORDERS]++;
    g_TCCompany[companyid][TC_REPUTATION] += 2;
    if(g_TCCompany[companyid][TC_COMPLETED_ORDERS] % 100 == 0) g_TCCompany[companyid][TC_LEVEL]++;
    TCM_SaveCompany(companyid);

    new query[384];
    mysql_format(mysql, query, sizeof query,
        "UPDATE `transport_company_members` SET `deliveries`=`deliveries`+1,`earned`=`earned`+%d,`last_online`=%d WHERE `account_id`=%d LIMIT 1",
        driver_salary, gettime(), GetPlayerAccountID(playerid)
    );
    mysql_query(mysql, query, false);
    TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), company_income, "Комиссия с выполненного заказа");
    TC_ReleaseFleetSlot(playerid);
    return driver_salary;
}

stock TCM_ShowCompanyInfo(playerid, companyid)
{
    if(!TCM_IsValidCompany(companyid)) return 0;
    new locality[24], auction[96], time_text[32], string[1024];
    TCM_GetLocalityName(companyid, locality, sizeof locality);
    if(g_TCCompany[companyid][TC_AUCTION_ACTIVE])
    {
        TCM_FormatTime(g_TCCompany[companyid][TC_AUCTION_END] - gettime(), time_text, sizeof time_text);
        format(auction, sizeof auction, "{33CC66}На аукционе{FFFFFF}, ставка: %d руб., осталось: %s", g_TCCompany[companyid][TC_AUCTION_CURRENT_BID], time_text);
    }
    else format(auction, sizeof auction, "{AAAAAA}Не выставлена на аукцион");
    format(string, sizeof string,
        "{FFFFFF}Название: {FFAE00}%s\n{FFFFFF}Офис: {FFAE00}%s\n{FFFFFF}Владелец: {FFAE00}%s\n\n{FFFFFF}Уровень: {FFAE00}%d\n{FFFFFF}Репутация: {FFAE00}%d\n{FFFFFF}Выполнено заказов: {FFAE00}%d\n{FFFFFF}Баланс: {33CC66}%d руб.\n{FFFFFF}Выплата водителю: {FFAE00}%d%%\n{FFFFFF}Автопарк: {FFAE00}%d/%d грузовиков\n{FFFFFF}Сотрудники: {FFAE00}%d/%d\n\n{FFFFFF}Статус: %s",
        g_TCCompany[companyid][TC_NAME], locality, g_TCCompany[companyid][TC_OWNER_NAME],
        g_TCCompany[companyid][TC_LEVEL], g_TCCompany[companyid][TC_REPUTATION],
        g_TCCompany[companyid][TC_COMPLETED_ORDERS], g_TCCompany[companyid][TC_BALANCE],
        g_TCCompany[companyid][TC_PAYOUT_PERCENT], g_TCCompany[companyid][TC_FLEET_COUNT],
        g_TCCompany[companyid][TC_FLEET_CAPACITY], TCM_GetMemberCount(companyid),
        g_TCCompany[companyid][TC_MAX_MEMBERS], auction
    );
    g_TCSelectedCompany[playerid] = companyid;
    new button[24];
    if(player_tc[playerid][p_TC_Active]) format(button, sizeof button, "Назад");
    else format(button, sizeof button, "Подать заявку");
    ShowPlayerDialog(playerid, DIALOG_TC_COMPANY_VIEW, DIALOG_STYLE_MSGBOX, "{FFAE00}Транспортная компания", string, button, "Закрыть");
    return 1;
}

stock TCM_ShowCompanyList(playerid)
{
    new dialog[512] = "{FFFFFF}Компания\t{FFFFFF}Офис\t{FFFFFF}Владелец\n";
    new row[160], locality[24], count;
    for(new i; i < MAX_TC_COMPANIES; i++)
    {
        if(!TCM_IsValidCompany(i)) continue;
        TCM_GetLocalityName(i, locality, sizeof locality);
        format(row, sizeof row, "{FFAE00}%s\t{FFFFFF}%s\t{FFFFFF}%s\n", g_TCCompany[i][TC_NAME], locality, g_TCCompany[i][TC_OWNER_NAME]);
        strcat(dialog, row);
        g_TCCompanyList[playerid][count++] = i;
    }
    SetPVarInt(playerid, "tc_company_list_count", count);
    ShowPlayerDialog(playerid, DIALOG_TC_COMPANY_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{FFAE00}Транспортные компании", dialog, "Выбрать", "Назад");
    return 1;
}

stock TCM_ShowAuctionList(playerid)
{
    new dialog[700] = "{FFFFFF}Компания\t{FFFFFF}Ставка\t{FFFFFF}До конца\n";
    new row[200], time_text[32], count;
    for(new i; i < MAX_TC_COMPANIES; i++)
    {
        if(!TCM_IsValidCompany(i) || !g_TCCompany[i][TC_AUCTION_ACTIVE]) continue;
        TCM_FormatTime(g_TCCompany[i][TC_AUCTION_END] - gettime(), time_text, sizeof time_text);
        format(row, sizeof row, "{FFAE00}%s\t{33CC66}%d руб.\t{FFFFFF}%s\n", g_TCCompany[i][TC_NAME], g_TCCompany[i][TC_AUCTION_CURRENT_BID], time_text);
        strcat(dialog, row);
        g_TCCompanyList[playerid][count++] = i;
    }
    if(!count) strcat(dialog, "{AAAAAA}Активных лотов нет\t-\t-\n");
    SetPVarInt(playerid, "tc_auction_list_count", count);
    ShowPlayerDialog(playerid, DIALOG_TC_AUCTION_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{FFAE00}Аукцион транспортных компаний", dialog, "Открыть", "Назад");
    return 1;
}

stock TCM_ShowAuctionView(playerid, companyid)
{
    if(!TCM_IsValidCompany(companyid) || !g_TCCompany[companyid][TC_AUCTION_ACTIVE]) return TCM_ShowAuctionList(playerid);
    new locality[24], time_text[32], string[768];
    TCM_GetLocalityName(companyid, locality, sizeof locality);
    TCM_FormatTime(g_TCCompany[companyid][TC_AUCTION_END] - gettime(), time_text, sizeof time_text);
    new bidder_name[24] = "Ставок нет";
    if(g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] > 0)
        format(bidder_name, sizeof bidder_name, "%s", g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME]);
    format(string, sizeof string,
        "{FFFFFF}Лот: {FFAE00}%s\n{FFFFFF}Офис: {FFAE00}%s\n{FFFFFF}Текущий владелец: {FFAE00}%s\n\n{FFFFFF}Стартовая цена: {33CC66}%d руб.\n{FFFFFF}Текущая ставка: {33CC66}%d руб.\n{FFFFFF}Лидер торгов: {FFAE00}%s\n{FFFFFF}До завершения: {FFAE00}%s\n\n{B8B8B8}Новая ставка должна быть минимум на 5%% выше текущей.\nЕсли ставка сделана в последние 5 минут, торги продлеваются на 5 минут.",
        g_TCCompany[companyid][TC_NAME], locality, g_TCCompany[companyid][TC_OWNER_NAME],
        g_TCCompany[companyid][TC_AUCTION_START_PRICE], g_TCCompany[companyid][TC_AUCTION_CURRENT_BID],
        bidder_name, time_text
    );
    g_TCSelectedCompany[playerid] = companyid;
    new button[24] = "Сделать ставку";
    if(TCM_IsOwner(playerid) && player_tc[playerid][p_TC_Copmany] == companyid && g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] <= 0)
        format(button, sizeof button, "Снять с торгов");
    ShowPlayerDialog(playerid, DIALOG_TC_AUCTION_VIEW, DIALOG_STYLE_MSGBOX, "{FFAE00}Лот транспортной компании", string, button, "Назад");
    return 1;
}

stock TCM_ShowMain(playerid)
{
    if(player_tc[playerid][p_TC_Active] && TCM_IsValidCompany(player_tc[playerid][p_TC_Copmany]))
    {
        new companyid = player_tc[playerid][p_TC_Copmany];
        new rank[24], dialog[768], title[96];
        TCM_GetRankName(player_tc[playerid][p_TC_Owner], rank, sizeof rank);
        format(title, sizeof title, "{FFAE00}%s | {FFFFFF}%s", g_TCCompany[companyid][TC_NAME], rank);
        format(dialog, sizeof dialog,
            "{FFFFFF}Информация о компании\n{FFFFFF}Заказы компании\n{FFFFFF}Автопарк\n{FFFFFF}Сотрудники\n");
        if(TCM_IsManager(playerid)) strcat(dialog, "{FFFFFF}Заявки на вступление\n{FFFFFF}Финансы компании\n");
        if(TCM_IsOwner(playerid)) strcat(dialog, "{FFFFFF}Настройки компании\n{FFFFFF}Выставить компанию на аукцион\n");
        strcat(dialog, "{FFFFFF}Аукцион компаний\n{FF6666}Покинуть компанию");
        ShowPlayerDialog(playerid, DIALOG_TC_MAIN, DIALOG_STYLE_LIST, title, dialog, "Выбрать", "Закрыть");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_TC_MAIN, DIALOG_STYLE_LIST, "{FFAE00}Транспортные компании",
            "{FFFFFF}Список транспортных компаний\n{FFFFFF}Аукцион транспортных компаний\n{B8B8B8}Как начать работу", "Выбрать", "Закрыть");
    }
    return 1;
}


stock TCM_ShowEmployees(playerid)
{
    new companyid = player_tc[playerid][p_TC_Copmany];
    if(!TCM_IsValidCompany(companyid)) return 0;
    new query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT `account_id`,`player_name`,`rank`,`deliveries`,`earned` FROM `transport_company_members` WHERE `company_id`=%d ORDER BY `rank` DESC,`deliveries` DESC LIMIT %d",
        companyid, MAX_TC_MEMBER_LIST
    );
    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows(), dialog[2600] = "{FFFFFF}Сотрудник\t{FFFFFF}Должность\t{FFFFFF}Рейсы\t{FFFFFF}Заработано\n";
    new row[220], rank[24];
    for(new i; i < rows; i++)
    {
        new account = cache_get_field_content_int(i, "account_id");
        new member_rank = cache_get_field_content_int(i, "rank");
        new name[24]; cache_get_field_content(i, "player_name", name, mysql, 24);
        TCM_GetRankName(member_rank, rank, sizeof rank);
        format(row, sizeof row, "{FFAE00}%s\t{FFFFFF}%s\t{FFFFFF}%d\t{33CC66}%d\n", name, rank,
            cache_get_field_content_int(i, "deliveries"), cache_get_field_content_int(i, "earned"));
        strcat(dialog, row);
        g_TCMemberList[playerid][i] = account;
    }
    cache_delete(result);
    SetPVarInt(playerid, "tc_member_list_count", rows);
    new button[24];
    if(TCM_IsManager(playerid)) format(button, sizeof button, "Управление");
    else format(button, sizeof button, "Закрыть");
    ShowPlayerDialog(playerid, DIALOG_TC_EMPLOYEES, DIALOG_STYLE_TABLIST_HEADERS, "{FFAE00}Сотрудники компании", dialog, button, "Назад");
    return 1;
}

stock TCM_ShowApplications(playerid)
{
    if(!TCM_IsManager(playerid)) return 0;
    new companyid = player_tc[playerid][p_TC_Copmany], query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT `id`,`account_id`,`player_name`,`created_at` FROM `transport_company_applications` WHERE `company_id`=%d ORDER BY `created_at` ASC LIMIT %d",
        companyid, MAX_TC_MEMBER_LIST
    );
    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows(), dialog[1800] = "{FFFFFF}Игрок\t{FFFFFF}Account ID\n", row[100];
    for(new i; i < rows; i++)
    {
        new name[24]; cache_get_field_content(i, "player_name", name, mysql, 24);
        format(row, sizeof row, "{FFAE00}%s\t{FFFFFF}%d\n", name, cache_get_field_content_int(i, "account_id"));
        strcat(dialog, row);
        g_TCApplicationList[playerid][i] = cache_get_field_content_int(i, "id");
    }
    cache_delete(result);
    if(!rows) strcat(dialog, "{AAAAAA}Нет новых заявок\t-\n");
    SetPVarInt(playerid, "tc_application_list_count", rows);
    ShowPlayerDialog(playerid, DIALOG_TC_APPLICATIONS, DIALOG_STYLE_TABLIST_HEADERS, "{FFAE00}Заявки на вступление", dialog, "Открыть", "Назад");
    return 1;
}

stock TCM_ShowFinance(playerid)
{
    new companyid = player_tc[playerid][p_TC_Copmany], string[256], title[112];
    if(!TCM_IsValidCompany(companyid) || !TCM_IsManager(playerid)) return 0;
    format(title, sizeof title, "{FFAE00}Баланс: {33CC66}%d руб. {FFFFFF}| Выплата: {FFAE00}%d%%",
        g_TCCompany[companyid][TC_BALANCE], g_TCCompany[companyid][TC_PAYOUT_PERCENT]);
    format(string, sizeof string, "{FFFFFF}Пополнить баланс\n");
    if(TCM_IsOwner(playerid)) strcat(string, "{FFFFFF}Снять средства\n");
    strcat(string, "{FFFFFF}История операций");
    ShowPlayerDialog(playerid, DIALOG_TC_FINANCE, DIALOG_STYLE_LIST, title, string, "Выбрать", "Назад");
    return 1;
}


stock TCM_ShowFleet(playerid)
{
    new companyid = player_tc[playerid][p_TC_Copmany], string[384], title[112];
    if(!TCM_IsValidCompany(companyid)) return 0;
    new free_trucks = g_TCCompany[companyid][TC_FLEET_COUNT] - g_TCActiveTrucks[companyid];
    if(free_trucks < 0) free_trucks = 0;
    format(title, sizeof title, "{FFAE00}Автопарк: %d/%d {FFFFFF}| Свободно: {33CC66}%d",
        g_TCCompany[companyid][TC_FLEET_COUNT], g_TCCompany[companyid][TC_FLEET_CAPACITY], free_trucks);
    if(!TCM_IsOwner(playerid))
    {
        format(string, sizeof string,
            "{FFFFFF}Всего грузовиков: {FFAE00}%d/%d\n{FFFFFF}Сейчас на рейсах: {FFAE00}%d\n{FFFFFF}Свободно: {33CC66}%d\n\n{B8B8B8}Один грузовик позволяет одному сотруднику выполнять заказ одновременно.",
            g_TCCompany[companyid][TC_FLEET_COUNT], g_TCCompany[companyid][TC_FLEET_CAPACITY],
            g_TCActiveTrucks[companyid], free_trucks);
        ShowPlayerDialog(playerid, DIALOG_TC_FLEET_INFO, DIALOG_STYLE_MSGBOX, title, string, "Назад", "");
        return 1;
    }
    format(string, sizeof string,
        "{FFFFFF}Купить грузовик - 2.500.000 руб.\n{FFFFFF}Расширить парковочное место - 5.000.000 руб.\n{FFFFFF}Продать грузовик - 1.250.000 руб.");
    ShowPlayerDialog(playerid, DIALOG_TC_FLEET, DIALOG_STYLE_LIST, title, string, "Выбрать", "Назад");
    return 1;
}


stock TCM_ShowSettings(playerid)
{
    if(!TCM_IsOwner(playerid)) return 0;
    new companyid = player_tc[playerid][p_TC_Copmany], string[384], title[112];
    format(title, sizeof title, "{FFAE00}Настройки | {FFFFFF}Сотрудники: %d/%d",
        TCM_GetMemberCount(companyid), g_TCCompany[companyid][TC_MAX_MEMBERS]);
    format(string, sizeof string,
        "{FFFFFF}Изменить название\n{FFFFFF}Процент выплаты водителям: {FFAE00}%d%%\n{FFFFFF}Увеличить лимит сотрудников - 3.000.000 руб.",
        g_TCCompany[companyid][TC_PAYOUT_PERCENT]
    );
    ShowPlayerDialog(playerid, DIALOG_TC_SETTINGS, DIALOG_STYLE_LIST, title, string, "Выбрать", "Назад");
    return 1;
}


stock TCM_SubmitApplication(playerid, companyid)
{
    if(GetPlayerLevel(playerid) < LEVEL_START_TC)
        return SendClientMessage(playerid, -1, TC_PREFIX"Работа в транспортной компании доступна с 1 игрового уровня.");
    if(player_tc[playerid][p_TC_Active]) return SendClientMessage(playerid, -1, TC_PREFIX"Вы уже состоите в транспортной компании.");
    if(!TCM_IsValidCompany(companyid)) return 0;
    if(TCM_GetMemberCount(companyid) >= g_TCCompany[companyid][TC_MAX_MEMBERS])
        return SendClientMessage(playerid, -1, TC_PREFIX"В компании нет свободных мест.");
    new query[384];
    mysql_format(mysql, query, sizeof query,
        "INSERT IGNORE INTO `transport_company_applications` (`company_id`,`account_id`,`player_name`,`created_at`) VALUES (%d,%d,'%e',%d)",
        companyid, GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), gettime()
    );
    mysql_query(mysql, query, false);
    SendClientMessage(playerid, -1, TC_PREFIX"Заявка отправлена руководству компании.");
    return 1;
}

stock TCM_RemoveMember(account_id)
{
    new query[192];
    mysql_format(mysql, query, sizeof query, "DELETE FROM `transport_company_members` WHERE `account_id`=%d LIMIT 1", account_id);
    mysql_query(mysql, query, false);
    TCM_RefreshPlayerByAccount(account_id);
    return 1;
}

stock TCM_AcceptApplication(playerid, application_id)
{
    if(!TCM_IsManager(playerid)) return 0;
    new companyid = player_tc[playerid][p_TC_Copmany];
    if(TCM_GetMemberCount(companyid) >= g_TCCompany[companyid][TC_MAX_MEMBERS])
        return SendClientMessage(playerid, -1, TC_PREFIX"Достигнут лимит сотрудников.");
    new query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT `account_id`,`player_name` FROM `transport_company_applications` WHERE `id`=%d AND `company_id`=%d LIMIT 1",
        application_id, companyid
    );
    new Cache:result = mysql_query(mysql, query, true);
    if(!cache_num_rows())
    {
        cache_delete(result);
        return TCM_ShowApplications(playerid);
    }
    new account_id = cache_get_field_content_int(0, "account_id"), name[24];
    cache_get_field_content(0, "player_name", name, mysql, 24);
    cache_delete(result);

    mysql_format(mysql, query, sizeof query,
        "SELECT COUNT(*) FROM `transport_company_members` WHERE `account_id`=%d", account_id
    );
    result = mysql_query(mysql, query, true);
    new already_member = cache_get_row_int(0, 0);
    cache_delete(result);
    if(already_member)
    {
        mysql_format(mysql, query, sizeof query, "DELETE FROM `transport_company_applications` WHERE `account_id`=%d", account_id);
        mysql_query(mysql, query, false);
        return SendClientMessage(playerid, -1, TC_PREFIX"Игрок уже состоит в другой компании.");
    }

    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `transport_company_members` (`account_id`,`company_id`,`player_name`,`rank`,`joined_at`,`last_online`) VALUES (%d,%d,'%e',%d,%d,%d)",
        account_id, companyid, name, TC_RANK_DRIVER, gettime(), gettime()
    );
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query, "DELETE FROM `transport_company_applications` WHERE `account_id`=%d", account_id);
    mysql_query(mysql, query, false);
    TCM_RefreshPlayerByAccount(account_id);
    new target = TCM_FindOnlineAccount(account_id);
    if(target != INVALID_PLAYER_ID) SendClientMessage(target, -1, TC_PREFIX"Ваша заявка одобрена. Вы приняты в транспортную компанию.");
    SendClientMessage(playerid, -1, TC_PREFIX"Игрок принят в компанию.");
    return TCM_ShowApplications(playerid);
}

stock TCM_StartAuction(playerid, companyid, start_price)
{
    if(!TCM_IsOwner(playerid) || player_tc[playerid][p_TC_Copmany] != companyid) return 0;
    if(g_TCCompany[companyid][TC_AUCTION_ACTIVE])
        return SendClientMessage(playerid, -1, TC_PREFIX"Компания уже находится на аукционе.");
    if(start_price < TC_AUCTION_MIN_PRICE)
        return SendClientMessage(playerid, -1, TC_PREFIX"Минимальная стартовая цена: 1.000.000 рублей.");
    g_TCCompany[companyid][TC_AUCTION_ACTIVE] = true;
    g_TCCompany[companyid][TC_AUCTION_START_PRICE] = start_price;
    g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] = start_price;
    g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] = -1;
    format(g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME], 24, "-");
    g_TCCompany[companyid][TC_AUCTION_END] = gettime() + TC_AUCTION_DEFAULT_HOURS * 3600;
    g_TCCompany[companyid][TC_AUCTION_LISTED_BY] = GetPlayerAccountID(playerid);
    TCM_SaveCompany(companyid);
    SendClientMessage(playerid, -1, TC_PREFIX"Компания выставлена на аукцион на 24 часа.");
    return 1;
}

stock TCM_PlaceBid(playerid, companyid, amount)
{
    if(!TCM_IsValidCompany(companyid) || !g_TCCompany[companyid][TC_AUCTION_ACTIVE])
        return SendClientMessage(playerid, -1, TC_PREFIX"Этот лот уже недоступен.");
    new account_id = GetPlayerAccountID(playerid);
    if(g_TCCompany[companyid][TC_OWNER_ACCOUNT] == account_id)
        return SendClientMessage(playerid, -1, TC_PREFIX"Нельзя делать ставку на собственную компанию.");
    if(TCM_PlayerOwnsAnyCompany(account_id) != TC_COMPANY_NONE)
        return SendClientMessage(playerid, -1, TC_PREFIX"Игрок может владеть только одной транспортной компанией.");
    if(GetPlayerLevel(playerid) < LEVEL_START_TC)
        return SendClientMessage(playerid, -1, TC_PREFIX"Для участия в аукционе транспортных компаний требуется 1 игровой уровень.");
    new minimum = g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] + g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] / 20;
    if(amount < minimum) return SendClientMessage(playerid, -1, TC_PREFIX"Ставка должна быть минимум на 5 процентов выше текущей.");

    if(g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] == account_id)
    {
        new extra = amount - g_TCCompany[companyid][TC_AUCTION_CURRENT_BID];
        if(extra <= 0 || GetPlayerMoneyEx(playerid) < extra)
            return SendClientMessage(playerid, -1, TC_PREFIX"Недостаточно средств для увеличения собственной ставки.");
        GivePlayerMoneyEx(playerid, -extra, "Доплата ставки за транспортную компанию", true, true);
    }
    else
    {
        if(GetPlayerMoneyEx(playerid) < amount)
            return SendClientMessage(playerid, -1, TC_PREFIX"Недостаточно наличных средств для ставки.");
        if(g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] > 0)
            TCM_CreditAccount(g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT], g_TCCompany[companyid][TC_AUCTION_CURRENT_BID], "Возврат ставки за транспортную компанию");
        GivePlayerMoneyEx(playerid, -amount, "Ставка за транспортную компанию", true, true);
    }
    g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] = amount;
    g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] = account_id;
    format(g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME], 24, "%s", GetPlayerNameEx(playerid));
    if(g_TCCompany[companyid][TC_AUCTION_END] - gettime() <= TC_AUCTION_ANTISNIPE_SECONDS)
        g_TCCompany[companyid][TC_AUCTION_END] = gettime() + TC_AUCTION_ANTISNIPE_SECONDS;
    TCM_SaveCompany(companyid);
    SendClientMessage(playerid, -1, TC_PREFIX"Ставка принята. Средства удержаны до завершения торгов или перебития ставки.");
    return TCM_ShowAuctionView(playerid, companyid);
}

stock TCM_FinalizeAuction(companyid)
{
    if(!TCM_IsValidCompany(companyid) || !g_TCCompany[companyid][TC_AUCTION_ACTIVE]) return 0;
    new bidder = g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT];
    if(bidder <= 0)
    {
        if(g_TCCompany[companyid][TC_OWNER_ACCOUNT] <= 0)
        {
            g_TCCompany[companyid][TC_AUCTION_END] = gettime() + TC_AUCTION_DEFAULT_HOURS * 3600;
            TCM_SaveCompany(companyid);
            return 1;
        }
        g_TCCompany[companyid][TC_AUCTION_ACTIVE] = false;
        g_TCCompany[companyid][TC_AUCTION_END] = 0;
        TCM_SaveCompany(companyid);
        return 1;
    }

    new seller = g_TCCompany[companyid][TC_OWNER_ACCOUNT];
    if(seller > 0) TCM_CreditAccount(seller, g_TCCompany[companyid][TC_AUCTION_CURRENT_BID], "Продажа транспортной компании");

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "DELETE FROM `transport_company_members` WHERE `account_id`=%d OR (`company_id`=%d AND `rank`=%d)",
        bidder, companyid, TC_RANK_OWNER
    );
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `transport_company_members` (`account_id`,`company_id`,`player_name`,`rank`,`joined_at`,`last_online`) VALUES (%d,%d,'%e',%d,%d,%d) ON DUPLICATE KEY UPDATE `company_id`=VALUES(`company_id`),`player_name`=VALUES(`player_name`),`rank`=VALUES(`rank`)",
        bidder, companyid, g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME], TC_RANK_OWNER, gettime(), gettime()
    );
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query,
        "DELETE FROM `transport_company_applications` WHERE `account_id`=%d", bidder
    );
    mysql_query(mysql, query, false);

    g_TCCompany[companyid][TC_OWNER_ACCOUNT] = bidder;
    format(g_TCCompany[companyid][TC_OWNER_NAME], 24, "%s", g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME]);
    g_TCCompany[companyid][TC_AUCTION_ACTIVE] = false;
    g_TCCompany[companyid][TC_AUCTION_START_PRICE] = 0;
    g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] = 0;
    g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] = -1;
    format(g_TCCompany[companyid][TC_AUCTION_BIDDER_NAME], 24, "-");
    g_TCCompany[companyid][TC_AUCTION_END] = 0;
    g_TCCompany[companyid][TC_AUCTION_LISTED_BY] = -1;
    TCM_SaveCompany(companyid);

    if(seller > 0) TCM_RefreshPlayerByAccount(seller);
    TCM_RefreshPlayerByAccount(bidder);
    new winner = TCM_FindOnlineAccount(bidder);
    if(winner != INVALID_PLAYER_ID) SendClientMessage(winner, -1, TC_PREFIX"Поздравляем! Вы выиграли аукцион и стали владельцем транспортной компании.");
    return 1;
}

public TCM_AuctionTick()
{
    if(!g_TCManagementInitialized) return 1;
    for(new i; i < MAX_TC_COMPANIES; i++)
        if(TCM_IsValidCompany(i) && g_TCCompany[i][TC_AUCTION_ACTIVE] && g_TCCompany[i][TC_AUCTION_END] <= gettime())
            TCM_FinalizeAuction(i);
    return 1;
}

CMD:company(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 0;
    TCM_ShowMain(playerid);
    return 1;
}

CMD:tccompany(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 0;
    TCM_ShowMain(playerid);
    return 1;
}

CMD:tcauction(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 0;
    TCM_ShowAuctionList(playerid);
    return 1;
}

CMD:tc(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 0;
    if(!player_tc[playerid][p_TC_Active] || !TCM_IsValidCompany(player_tc[playerid][p_TC_Copmany]))
        return SendClientMessage(playerid, -1, TC_PREFIX"Вы не состоите в транспортной компании.");
    if(IsPlayerMuted(playerid) > 0)
        return SendClientMessage(playerid, -1, TC_PREFIX"Доступ в чат временно заблокирован.");
    if(!strlen(params))
        return SendClientMessage(playerid, -1, TC_PREFIX"Используйте: /tc [сообщение]");
    if(IsAIP(params))
        return SendClientMessage(playerid, -1, TC_PREFIX"Сообщение похоже на рекламу и не было отправлено.");

    new rank[24], message[160], companyid = player_tc[playerid][p_TC_Copmany];
    TCM_GetRankName(player_tc[playerid][p_TC_Owner], rank, sizeof rank);
    format(message, sizeof message, "[TC] %s %s[%d]: %s", rank, GetPlayerNameEx(playerid), playerid, params);
    foreach(new targetid : Player)
    {
        if(!IsPlayerLogged(targetid)) continue;
        if(!player_tc[targetid][p_TC_Active]) continue;
        if(player_tc[targetid][p_TC_Copmany] != companyid) continue;
        SendClientMessage(targetid, 0xFFAE00FF, message);
    }
    return 1;
}

CMD:orders(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 0;
    if(!TC_CanStartOrder(playerid)) return 1;
    return ShowDialogOrders(playerid, g_TCCompany[player_tc[playerid][p_TC_Copmany]][TC_LOCALITY]);
}

CMD:tcsetowner(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4) return 0;
    extract params -> new companyid, targetid;
    if(!TCM_IsValidCompany(companyid) || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, -1, "Используйте: /tcsetowner [0-1] [playerid]");
    new account = GetPlayerAccountID(targetid), query[384];
    mysql_format(mysql, query, sizeof query, "DELETE FROM `transport_company_members` WHERE `account_id`=%d OR (`company_id`=%d AND `rank`=%d)", account, companyid, TC_RANK_OWNER);
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `transport_company_members` (`account_id`,`company_id`,`player_name`,`rank`,`joined_at`,`last_online`) VALUES (%d,%d,'%e',%d,%d,%d)",
        account, companyid, GetPlayerNameEx(targetid), TC_RANK_OWNER, gettime(), gettime());
    mysql_query(mysql, query, false);
    g_TCCompany[companyid][TC_OWNER_ACCOUNT] = account;
    format(g_TCCompany[companyid][TC_OWNER_NAME], 24, "%s", GetPlayerNameEx(targetid));
    g_TCCompany[companyid][TC_AUCTION_ACTIVE] = false;
    TCM_SaveCompany(companyid);
    TCM_LoadPlayer(targetid);
    SendClientMessage(playerid, -1, TC_PREFIX"Владелец компании назначен.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    g_TCSelectedCompany[playerid] = TC_COMPANY_NONE;
    g_TCSelectedAccount[playerid] = -1;
    g_TCSelectedApplication[playerid] = -1;
    SetTimerEx("TCM_LoadPlayer", 5000, false, "i", playerid);
    #if defined tcm_OnPlayerConnect
        return tcm_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect tcm_OnPlayerConnect
#if defined tcm_OnPlayerConnect
    forward tcm_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    TC_ReleaseFleetSlot(playerid);
    if(IsPlayerLogged(playerid) && player_tc[playerid][p_TC_Active])
    {
        new query[160];
        mysql_format(mysql, query, sizeof query, "UPDATE `transport_company_members` SET `last_online`=%d WHERE `account_id`=%d LIMIT 1", gettime(), GetPlayerAccountID(playerid));
        mysql_query(mysql, query, false);
    }
    #if defined tcm_OnPlayerDisconnect
        return tcm_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect tcm_OnPlayerDisconnect
#if defined tcm_OnPlayerDisconnect
    forward tcm_OnPlayerDisconnect(playerid, reason);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_TC_MAIN:
        {
            if(!response) return 1;
            if(!player_tc[playerid][p_TC_Active])
            {
                switch(listitem)
                {
                    case 0: TCM_ShowCompanyList(playerid);
                    case 1: TCM_ShowAuctionList(playerid);
                    case 2: ShowPlayerDialog(playerid, DIALOG_TC_HELP, DIALOG_STYLE_MSGBOX, "{FFAE00}Работа в транспортной компании", "{FFFFFF}Выберите компанию, подайте заявку и дождитесь одобрения руководства. После вступления приезжайте в офис своей компании и выбирайте заказы. Для каждого одновременного рейса нужен свободный грузовик в автопарке.", "Понятно", "");
                }
                return 1;
            }
            new idx;
            if(listitem == idx++) return TCM_ShowCompanyInfo(playerid, player_tc[playerid][p_TC_Copmany]);
            if(listitem == idx++)
            {
                new locality = g_TCCompany[player_tc[playerid][p_TC_Copmany]][TC_LOCALITY];
                return ShowDialogOrders(playerid, locality);
            }
            if(listitem == idx++) return TCM_ShowFleet(playerid);
            if(listitem == idx++) return TCM_ShowEmployees(playerid);
            if(TCM_IsManager(playerid) && listitem == idx++) return TCM_ShowApplications(playerid);
            if(TCM_IsManager(playerid) && listitem == idx++) return TCM_ShowFinance(playerid);
            if(TCM_IsOwner(playerid) && listitem == idx++) return TCM_ShowSettings(playerid);
            if(TCM_IsOwner(playerid) && listitem == idx++)
            {
                new companyid = player_tc[playerid][p_TC_Copmany];
                if(g_TCCompany[companyid][TC_AUCTION_ACTIVE]) return TCM_ShowAuctionView(playerid, companyid);
                return ShowPlayerDialog(playerid, DIALOG_TC_AUCTION_START, DIALOG_STYLE_INPUT, "{FFAE00}Выставить компанию", "{FFFFFF}Введите стартовую цену компании.\n{B8B8B8}Срок торгов: 24 часа. Минимальная цена: 1.000.000 рублей.", "Выставить", "Назад");
            }
            if(listitem == idx++) return TCM_ShowAuctionList(playerid);
            if(listitem == idx++)
            {
                if(TCM_IsOwner(playerid))
                    return ShowPlayerDialog(playerid, DIALOG_TC_LEAVE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF6666}Покинуть компанию", "{FFFFFF}Владелец не может покинуть компанию. Сначала продайте её на аукционе.", "Назад", "Отмена");
                return ShowPlayerDialog(playerid, DIALOG_TC_LEAVE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF6666}Покинуть компанию", "{FFFFFF}Вы действительно хотите покинуть транспортную компанию?", "Покинуть", "Отмена");
            }
            return 1;
        }
        case DIALOG_TC_COMPANY_LIST:
        {
            if(!response) return TCM_ShowMain(playerid);
            new count = GetPVarInt(playerid, "tc_company_list_count");
            if(!(0 <= listitem < count)) return 1;
            return TCM_ShowCompanyInfo(playerid, g_TCCompanyList[playerid][listitem]);
        }
        case DIALOG_TC_COMPANY_VIEW:
        {
            if(!response) return 1;
            if(player_tc[playerid][p_TC_Active]) return TCM_ShowMain(playerid);
            return TCM_SubmitApplication(playerid, g_TCSelectedCompany[playerid]);
        }
        case DIALOG_TC_EMPLOYEES:
        {
            if(!response) return TCM_ShowMain(playerid);
            if(!TCM_IsManager(playerid)) return 1;
            new count = GetPVarInt(playerid, "tc_member_list_count");
            if(!(0 <= listitem < count)) return 1;
            g_TCSelectedAccount[playerid] = g_TCMemberList[playerid][listitem];
            if(g_TCSelectedAccount[playerid] == GetPlayerAccountID(playerid)) return SendClientMessage(playerid, -1, TC_PREFIX"Нельзя управлять собственной должностью.");
            ShowPlayerDialog(playerid, DIALOG_TC_EMPLOYEE_ACTION, DIALOG_STYLE_LIST, "{FFAE00}Управление сотрудником", "{FFFFFF}Повысить до управляющего\n{FFFFFF}Понизить до водителя\n{FF6666}Уволить сотрудника", "Выбрать", "Назад");
            return 1;
        }
        case DIALOG_TC_EMPLOYEE_ACTION:
        {
            if(!response) return TCM_ShowEmployees(playerid);
            if(!TCM_IsManager(playerid)) return 1;
            new account = g_TCSelectedAccount[playerid], companyid = player_tc[playerid][p_TC_Copmany], query[256];
            if(account <= 0) return 1;
            if(listitem == 0 || listitem == 1)
            {
                if(!TCM_IsOwner(playerid)) return SendClientMessage(playerid, -1, TC_PREFIX"Только владелец может менять должности сотрудников.");
                new rank = listitem == 0 ? TC_RANK_MANAGER : TC_RANK_DRIVER;
                mysql_format(mysql, query, sizeof query, "UPDATE `transport_company_members` SET `rank`=%d WHERE `account_id`=%d AND `company_id`=%d AND `rank`<%d LIMIT 1", rank, account, companyid, TC_RANK_OWNER);
                mysql_query(mysql, query, false);
                TCM_RefreshPlayerByAccount(account);
                SendClientMessage(playerid, -1, TC_PREFIX"Должность сотрудника изменена.");
                return TCM_ShowEmployees(playerid);
            }
            if(listitem == 2)
            {
                SetPVarInt(playerid, "tc_kick_account", account);
                return ShowPlayerDialog(playerid, DIALOG_TC_KICK_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF6666}Увольнение", "{FFFFFF}Вы действительно хотите уволить выбранного сотрудника?", "Уволить", "Отмена");
            }
            return 1;
        }
        case DIALOG_TC_KICK_CONFIRM:
        {
            if(!response) return TCM_ShowEmployees(playerid);
            if(!TCM_IsManager(playerid)) return 1;
            new account = GetPVarInt(playerid, "tc_kick_account"), companyid = player_tc[playerid][p_TC_Copmany], query[256];
            mysql_format(mysql, query, sizeof query, "DELETE FROM `transport_company_members` WHERE `account_id`=%d AND `company_id`=%d AND `rank`<%d LIMIT 1", account, companyid, player_tc[playerid][p_TC_Owner]);
            mysql_query(mysql, query, false);
            TCM_RefreshPlayerByAccount(account);
            SendClientMessage(playerid, -1, TC_PREFIX"Сотрудник уволен.");
            return TCM_ShowEmployees(playerid);
        }
        case DIALOG_TC_APPLICATIONS:
        {
            if(!response) return TCM_ShowMain(playerid);
            new count = GetPVarInt(playerid, "tc_application_list_count");
            if(!(0 <= listitem < count)) return 1;
            g_TCSelectedApplication[playerid] = g_TCApplicationList[playerid][listitem];
            ShowPlayerDialog(playerid, DIALOG_TC_APPLICATION_ACTION, DIALOG_STYLE_LIST, "{FFAE00}Заявка", "{33CC66}Принять игрока\n{FF6666}Отклонить заявку", "Выбрать", "Назад");
            return 1;
        }
        case DIALOG_TC_APPLICATION_ACTION:
        {
            if(!response) return TCM_ShowApplications(playerid);
            if(listitem == 0) return TCM_AcceptApplication(playerid, g_TCSelectedApplication[playerid]);
            if(listitem == 1)
            {
                new query[160];
                mysql_format(mysql, query, sizeof query, "DELETE FROM `transport_company_applications` WHERE `id`=%d LIMIT 1", g_TCSelectedApplication[playerid]);
                mysql_query(mysql, query, false);
                return TCM_ShowApplications(playerid);
            }
            return 1;
        }
        case DIALOG_TC_HELP:
        {
            return 1;
        }
        case DIALOG_TC_HISTORY:
        {
            return TCM_ShowFinance(playerid);
        }
        case DIALOG_TC_FLEET_INFO:
        {
            return TCM_ShowMain(playerid);
        }
        case DIALOG_TC_FINANCE:
        {
            if(!response) return TCM_ShowMain(playerid);
            new idx;
            if(listitem == idx++) return ShowPlayerDialog(playerid, DIALOG_TC_DEPOSIT, DIALOG_STYLE_INPUT, "{FFAE00}Пополнение баланса", "{FFFFFF}Введите сумму, которую хотите внести на счёт компании.", "Внести", "Назад");
            if(TCM_IsOwner(playerid) && listitem == idx++) return ShowPlayerDialog(playerid, DIALOG_TC_WITHDRAW, DIALOG_STYLE_INPUT, "{FFAE00}Снятие средств", "{FFFFFF}Введите сумму для снятия с баланса компании.", "Снять", "Назад");
            if(listitem == idx++)
            {
                new companyid = player_tc[playerid][p_TC_Copmany], query[256];
                mysql_format(mysql, query, sizeof query, "SELECT `player_name`,`amount`,`action` FROM `transport_company_transactions` WHERE `company_id`=%d ORDER BY `id` DESC LIMIT 15", companyid);
                new Cache:result = mysql_query(mysql, query, true);
                new rows = cache_num_rows(), dialog[1800] = "{FFFFFF}Игрок\t{FFFFFF}Сумма\t{FFFFFF}Операция\n", row[180], name[24], action[64];
                for(new i; i < rows; i++)
                {
                    cache_get_field_content(i, "player_name", name, mysql, 24);
                    cache_get_field_content(i, "action", action, mysql, 64);
                    format(row, sizeof row, "{FFAE00}%s\t{FFFFFF}%d\t{FFFFFF}%s\n", name, cache_get_field_content_int(i, "amount"), action);
                    strcat(dialog, row);
                }
                cache_delete(result);
                if(!rows) strcat(dialog, "{AAAAAA}Операций пока нет\t0\t-\n");
                ShowPlayerDialog(playerid, DIALOG_TC_HISTORY, DIALOG_STYLE_TABLIST_HEADERS, "{FFAE00}История операций", dialog, "Закрыть", "");
                return 1;
            }
            return 1;
        }
        case DIALOG_TC_DEPOSIT:
        {
            if(!response) return TCM_ShowFinance(playerid);
            new amount = strval(inputtext), companyid = player_tc[playerid][p_TC_Copmany];
            if(amount <= 0 || !IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_TC_DEPOSIT, DIALOG_STYLE_INPUT, "{FFAE00}Пополнение баланса", "{FF6666}Введите корректную положительную сумму.", "Внести", "Назад");
            if(GetPlayerMoneyEx(playerid) < amount) return SendClientMessage(playerid, -1, TC_PREFIX"Недостаточно денег.");
            if(g_TCCompany[companyid][TC_BALANCE] > 2100000000 - amount) return SendClientMessage(playerid, -1, TC_PREFIX"Баланс компании переполнен.");
            GivePlayerMoneyEx(playerid, -amount, "Пополнение транспортной компании", true, true);
            g_TCCompany[companyid][TC_BALANCE] += amount;
            TCM_SaveCompany(companyid);
            TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), amount, "Пополнение баланса");
            return TCM_ShowFinance(playerid);
        }
        case DIALOG_TC_WITHDRAW:
        {
            if(!response) return TCM_ShowFinance(playerid);
            if(!TCM_IsOwner(playerid)) return 1;
            new amount = strval(inputtext), companyid = player_tc[playerid][p_TC_Copmany];
            if(amount <= 0 || !IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_TC_WITHDRAW, DIALOG_STYLE_INPUT, "{FFAE00}Снятие средств", "{FF6666}Введите корректную положительную сумму.", "Снять", "Назад");
            if(g_TCCompany[companyid][TC_BALANCE] < amount) return SendClientMessage(playerid, -1, TC_PREFIX"На балансе компании недостаточно средств.");
            g_TCCompany[companyid][TC_BALANCE] -= amount;
            GivePlayerMoneyEx(playerid, amount, "Снятие со счёта транспортной компании", true, true);
            TCM_SaveCompany(companyid);
            TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), -amount, "Снятие с баланса");
            return TCM_ShowFinance(playerid);
        }
        case DIALOG_TC_SETTINGS:
        {
            if(!response) return TCM_ShowMain(playerid);
            if(!TCM_IsOwner(playerid)) return 1;
            new companyid = player_tc[playerid][p_TC_Copmany];
            switch(listitem)
            {
                case 0: ShowPlayerDialog(playerid, DIALOG_TC_RENAME, DIALOG_STYLE_INPUT, "{FFAE00}Название компании", "{FFFFFF}Введите новое название от 3 до 30 символов.", "Сохранить", "Назад");
                case 1: ShowPlayerDialog(playerid, DIALOG_TC_PAYOUT, DIALOG_STYLE_INPUT, "{FFAE00}Выплата водителям", "{FFFFFF}Введите процент, который получает водитель с заказа.\n{B8B8B8}Допустимо от 50 до 100 процентов.", "Сохранить", "Назад");
                case 2:
                {
                    if(g_TCCompany[companyid][TC_MAX_MEMBERS] >= TC_MAX_MEMBERS_LIMIT) return SendClientMessage(playerid, -1, TC_PREFIX"Достигнут максимальный лимит сотрудников.");
                    if(g_TCCompany[companyid][TC_BALANCE] < 3000000) return SendClientMessage(playerid, -1, TC_PREFIX"На балансе компании недостаточно средств.");
                    g_TCCompany[companyid][TC_BALANCE] -= 3000000;
                    g_TCCompany[companyid][TC_MAX_MEMBERS] += 5;
                    if(g_TCCompany[companyid][TC_MAX_MEMBERS] > TC_MAX_MEMBERS_LIMIT) g_TCCompany[companyid][TC_MAX_MEMBERS] = TC_MAX_MEMBERS_LIMIT;
                    TCM_SaveCompany(companyid);
                    TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), -3000000, "Расширение штата");
                    TCM_ShowSettings(playerid);
                }
            }
            return 1;
        }
        case DIALOG_TC_RENAME:
        {
            if(!response) return TCM_ShowSettings(playerid);
            if(!TCM_IsOwner(playerid)) return 1;
            new len = strlen(inputtext), companyid = player_tc[playerid][p_TC_Copmany];
            if(len < 3 || len > 30) return ShowPlayerDialog(playerid, DIALOG_TC_RENAME, DIALOG_STYLE_INPUT, "{FFAE00}Название компании", "{FF6666}Название должно содержать от 3 до 30 символов.", "Сохранить", "Назад");
            format(g_TCCompany[companyid][TC_NAME], 32, "%s", inputtext);
            TCM_SaveCompany(companyid);
            return TCM_ShowSettings(playerid);
        }
        case DIALOG_TC_PAYOUT:
        {
            if(!response) return TCM_ShowSettings(playerid);
            if(!TCM_IsOwner(playerid)) return 1;
            new percent = strval(inputtext), companyid = player_tc[playerid][p_TC_Copmany];
            if(percent < 50 || percent > 100 || !IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_TC_PAYOUT, DIALOG_STYLE_INPUT, "{FFAE00}Выплата водителям", "{FF6666}Введите число от 50 до 100.", "Сохранить", "Назад");
            g_TCCompany[companyid][TC_PAYOUT_PERCENT] = percent;
            TCM_SaveCompany(companyid);
            return TCM_ShowSettings(playerid);
        }
        case DIALOG_TC_FLEET:
        {
            if(!response) return TCM_ShowMain(playerid);
            if(!TCM_IsOwner(playerid)) return 1;
            new companyid = player_tc[playerid][p_TC_Copmany];
            switch(listitem)
            {
                case 0:
                {
                    if(g_TCCompany[companyid][TC_FLEET_COUNT] >= g_TCCompany[companyid][TC_FLEET_CAPACITY]) return SendClientMessage(playerid, -1, TC_PREFIX"Сначала расширьте парковочные места.");
                    if(g_TCCompany[companyid][TC_BALANCE] < TC_FLEET_TRUCK_PRICE) return SendClientMessage(playerid, -1, TC_PREFIX"На балансе компании недостаточно средств.");
                    g_TCCompany[companyid][TC_BALANCE] -= TC_FLEET_TRUCK_PRICE;
                    g_TCCompany[companyid][TC_FLEET_COUNT]++;
                    TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), -TC_FLEET_TRUCK_PRICE, "Покупка грузовика");
                }
                case 1:
                {
                    if(g_TCCompany[companyid][TC_FLEET_CAPACITY] >= TC_MAX_FLEET) return SendClientMessage(playerid, -1, TC_PREFIX"Достигнут максимальный размер автопарка.");
                    if(g_TCCompany[companyid][TC_BALANCE] < TC_FLEET_SLOT_PRICE) return SendClientMessage(playerid, -1, TC_PREFIX"На балансе компании недостаточно средств.");
                    g_TCCompany[companyid][TC_BALANCE] -= TC_FLEET_SLOT_PRICE;
                    g_TCCompany[companyid][TC_FLEET_CAPACITY]++;
                    TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), -TC_FLEET_SLOT_PRICE, "Расширение автопарка");
                }
                case 2:
                {
                    if(g_TCCompany[companyid][TC_FLEET_COUNT] <= 1) return SendClientMessage(playerid, -1, TC_PREFIX"В компании должен остаться хотя бы один грузовик.");
                    if(g_TCCompany[companyid][TC_FLEET_COUNT] <= g_TCActiveTrucks[companyid]) return SendClientMessage(playerid, -1, TC_PREFIX"Нельзя продать грузовик, пока он используется сотрудником.");
                    g_TCCompany[companyid][TC_FLEET_COUNT]--;
                    g_TCCompany[companyid][TC_BALANCE] += TC_FLEET_TRUCK_PRICE / 2;
                    TCM_LogTransaction(companyid, GetPlayerAccountID(playerid), TC_FLEET_TRUCK_PRICE / 2, "Продажа грузовика");
                }
                default: return 1;
            }
            TCM_SaveCompany(companyid);
            return TCM_ShowFleet(playerid);
        }
        case DIALOG_TC_AUCTION_LIST:
        {
            if(!response) return TCM_ShowMain(playerid);
            new count = GetPVarInt(playerid, "tc_auction_list_count");
            if(!(0 <= listitem < count)) return 1;
            return TCM_ShowAuctionView(playerid, g_TCCompanyList[playerid][listitem]);
        }
        case DIALOG_TC_AUCTION_VIEW:
        {
            if(!response) return TCM_ShowAuctionList(playerid);
            new companyid = g_TCSelectedCompany[playerid];
            if(TCM_IsOwner(playerid) && player_tc[playerid][p_TC_Copmany] == companyid && g_TCCompany[companyid][TC_AUCTION_BIDDER_ACCOUNT] <= 0)
            {
                g_TCCompany[companyid][TC_AUCTION_ACTIVE] = false;
                g_TCCompany[companyid][TC_AUCTION_END] = 0;
                TCM_SaveCompany(companyid);
                SendClientMessage(playerid, -1, TC_PREFIX"Лот снят с аукциона, так как ставок ещё не было.");
                return TCM_ShowMain(playerid);
            }
            new minimum = g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] + g_TCCompany[companyid][TC_AUCTION_CURRENT_BID] / 20;
            new text[192];
            format(text, sizeof text, "{FFFFFF}Введите сумму ставки.\n{B8B8B8}Минимальная ставка: %d рублей.", minimum);
            ShowPlayerDialog(playerid, DIALOG_TC_AUCTION_BID, DIALOG_STYLE_INPUT, "{FFAE00}Ставка на компанию", text, "Поставить", "Назад");
            return 1;
        }
        case DIALOG_TC_AUCTION_BID:
        {
            if(!response) return TCM_ShowAuctionView(playerid, g_TCSelectedCompany[playerid]);
            new amount = strval(inputtext);
            if(amount <= 0 || !IsNumeric(inputtext)) return SendClientMessage(playerid, -1, TC_PREFIX"Введите корректную сумму ставки.");
            return TCM_PlaceBid(playerid, g_TCSelectedCompany[playerid], amount);
        }
        case DIALOG_TC_AUCTION_START:
        {
            if(!response) return TCM_ShowMain(playerid);
            new price = strval(inputtext);
            if(price <= 0 || !IsNumeric(inputtext)) return SendClientMessage(playerid, -1, TC_PREFIX"Введите корректную стартовую цену.");
            return TCM_StartAuction(playerid, player_tc[playerid][p_TC_Copmany], price);
        }
        case DIALOG_TC_LEAVE_CONFIRM:
        {
            if(!response) return TCM_ShowMain(playerid);
            if(TCM_IsOwner(playerid)) return TCM_ShowMain(playerid);
            TCM_RemoveMember(GetPlayerAccountID(playerid));
            SendClientMessage(playerid, -1, TC_PREFIX"Вы покинули транспортную компанию.");
            return 1;
        }
    }
    #if defined tcm_OnDialogResponse
        return tcm_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse tcm_OnDialogResponse
#if defined tcm_OnDialogResponse
    forward tcm_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
