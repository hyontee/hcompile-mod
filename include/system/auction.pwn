#define MAX_AUCTION_SLOT 1024
#define MAX_AUCTION_LIST 256

#define TYPE_BUSINESS         1                
#define TYPE_VEHICLE          2      
#define TYPE_HOUSE            3  
#define TYPE_VEHICLE_NUMBER   4          
#define TYPE_SUM_NUMBER       5      
#define TYPE_CLOTHES          6      

#define AUCTION_WORLD       183

new enter_auction, exit_auction;

new type_slot[7][22] =
{
    {""},
    {"Бизнес"},
    {"Транспортное_средство"},
    {"Недвижимость"},
    {"Номерной_знак"},
    {"Сим-карта"},
    {"Одежда"}
};

new icon_slot[7][17] =
{
    {""},           //  none
    {"txd:braucbiz"},               //   бизнес
    {"txd:brauccar"},               //   транспорт
    {"txd:brauchome"},               //   дом/недвижимость
    {"txd:braucnumber"},            //   т/с номер
    {"txd:braucsimcard"},           //   сим-карта             
    {"txd:brauccloth"}             //   одежда
};

new bool:load_business_action;
enum STRUCT_AUCTION_SLOT
{
    SLOT_TYPE, 
    OWNER_SLOT_SQL,
    OWNER_SLOT_NAME[24],
    SLOT_NAME[24],
    OPISANIE_SLOT[124],
    OWNER_RATE,
    START_RATE,
    CURRENT_RATE,
    //TIMER_ID,
    TIMER_END,
    //database and server
    DATABASE_ID,
    SERVER_ID,
    //number vehicle and SUM
    NUMBER_VEHICLE[7],
    NUMBER_SUM
}

new auction_slot[MAX_AUCTION_SLOT][STRUCT_AUCTION_SLOT];

new player_cd_auction[MAX_PLAYERS];
new PlayerText:auction_PTD[MAX_PLAYERS][40];

new slot_td[4][3] = //айди тд где информация о слоте
{
    {11, 12, 13},
    {15, 16, 17},
    {19, 20, 21},
    {7, 8, 9}
};

enum STRUCT_AUCTION_PANEL
{
    bool:show_panel,
    count_list,
    select_slot,
    select_type,
    select_tab,
    filter_min_price,
    filter_max_price,
    auction_filter_type,
    filter_tovar_type,
    filter_vehicle_model,
    bool:type_tovar, 
    bool:price_tovar, 
    bool:opisanie_tovar, 
    bool:tovar,
}

new player_show_slot[MAX_PLAYERS][4];
new player_info_panel[MAX_PLAYERS][STRUCT_AUCTION_PANEL];

#define AUCTION_SKIN_ITEM_ID             (134)

forward Auction_DeliverPendingItems(playerid);
forward Auction_DeliverPendingMoney(playerid);

stock Auction_CreateTables()
{
    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `auction_slots` (`slot_id` INT NOT NULL,`slot_type` INT NOT NULL,`owner_account` INT NOT NULL,`owner_name` VARCHAR(24) NOT NULL DEFAULT '-',`slot_name` VARCHAR(32) NOT NULL DEFAULT '-',`description` VARCHAR(124) NOT NULL DEFAULT '-',`bidder_account` INT NOT NULL DEFAULT -1,`start_rate` INT NOT NULL DEFAULT 0,`current_rate` INT NOT NULL DEFAULT 0,`timer_end` INT NOT NULL DEFAULT 0,`database_id` INT NOT NULL DEFAULT -1,`server_id` INT NOT NULL DEFAULT -1,`vehicle_number` VARCHAR(7) NOT NULL DEFAULT '-',`phone_number` INT NOT NULL DEFAULT 0,PRIMARY KEY (`slot_id`),KEY `idx_auction_owner` (`owner_account`),KEY `idx_auction_bidder` (`bidder_account`),KEY `idx_auction_end` (`timer_end`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    if(mysql_errno())
    {
        printf("[AUCTION] auction_slots create failed, errno=%d", mysql_errno());
        return 0;
    }

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `auction_pending_items` (`id` INT NOT NULL AUTO_INCREMENT,`account_id` INT NOT NULL,`item_id` INT NOT NULL,`item_count` INT NOT NULL,`item_plate` VARCHAR(32) NOT NULL DEFAULT '',`created_at` INT NOT NULL,PRIMARY KEY (`id`),KEY `idx_auction_pending_account` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    if(mysql_errno())
    {
        printf("[AUCTION] auction_pending_items create failed, errno=%d", mysql_errno());
        return 0;
    }

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `auction_pending_money` (`id` INT NOT NULL AUTO_INCREMENT,`account_id` INT NOT NULL,`amount` INT NOT NULL,`reason` VARCHAR(96) NOT NULL DEFAULT '',`created_at` INT NOT NULL,PRIMARY KEY (`id`),KEY `idx_auction_money_account` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );

    if(mysql_errno())
    {
        printf("[AUCTION] auction_pending_money create failed, errno=%d", mysql_errno());
        return 0;
    }
    return 1;
}

stock Auction_SaveSlot(slot)
{
    if(slot < 0 || slot >= MAX_AUCTION_SLOT) return 0;
    if(!auction_slot[slot][SLOT_TYPE]) return 0;

    new query[1400];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `auction_slots` (`slot_id`,`slot_type`,`owner_account`,`owner_name`,`slot_name`,`description`,`bidder_account`,`start_rate`,`current_rate`,`timer_end`,`database_id`,`server_id`,`vehicle_number`,`phone_number`) VALUES (%d,%d,%d,'%e','%e','%e',%d,%d,%d,%d,%d,%d,'%e',%d) ON DUPLICATE KEY UPDATE `slot_type`=VALUES(`slot_type`),`owner_account`=VALUES(`owner_account`),`owner_name`=VALUES(`owner_name`),`slot_name`=VALUES(`slot_name`),`description`=VALUES(`description`),`bidder_account`=VALUES(`bidder_account`),`start_rate`=VALUES(`start_rate`),`current_rate`=VALUES(`current_rate`),`timer_end`=VALUES(`timer_end`),`database_id`=VALUES(`database_id`),`server_id`=VALUES(`server_id`),`vehicle_number`=VALUES(`vehicle_number`),`phone_number`=VALUES(`phone_number`)",
        slot,
        auction_slot[slot][SLOT_TYPE],
        auction_slot[slot][OWNER_SLOT_SQL],
        auction_slot[slot][OWNER_SLOT_NAME],
        auction_slot[slot][SLOT_NAME],
        auction_slot[slot][OPISANIE_SLOT],
        auction_slot[slot][OWNER_RATE],
        auction_slot[slot][START_RATE],
        auction_slot[slot][CURRENT_RATE],
        auction_slot[slot][TIMER_END],
        auction_slot[slot][DATABASE_ID],
        auction_slot[slot][SERVER_ID],
        auction_slot[slot][NUMBER_VEHICLE],
        auction_slot[slot][NUMBER_SUM]
    );
    mysql_query(mysql, query, false);

    if(mysql_errno())
    {
        printf("[AUCTION] slot save failed slot=%d errno=%d", slot, mysql_errno());
        return 0;
    }
    return 1;
}

stock Auction_DeleteSlot(slot)
{
    new query[96];
    mysql_format(mysql, query, sizeof query,
        "DELETE FROM `auction_slots` WHERE `slot_id`=%d LIMIT 1",
        slot
    );
    mysql_query(mysql, query, false);
    return mysql_errno() == 0;
}

stock Auction_LoadSlots()
{
    new Cache:result = mysql_query(mysql,
        "SELECT * FROM `auction_slots` WHERE `slot_type` > 0 ORDER BY `slot_id` ASC",
        true
    );
    if(mysql_errno())
    {
        printf("[AUCTION] slot load failed, errno=%d", mysql_errno());
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    new loaded;
    for(new row; row < rows; row++)
    {
        new slot = cache_get_field_content_int(row, "slot_id");
        if(slot < 0 || slot >= MAX_AUCTION_SLOT) continue;

        auction_slot[slot][SLOT_TYPE] = cache_get_field_content_int(row, "slot_type");
        auction_slot[slot][OWNER_SLOT_SQL] = cache_get_field_content_int(row, "owner_account");
        cache_get_field_content(row, "owner_name", auction_slot[slot][OWNER_SLOT_NAME], mysql, 24);
        cache_get_field_content(row, "slot_name", auction_slot[slot][SLOT_NAME], mysql, 24);
        cache_get_field_content(row, "description", auction_slot[slot][OPISANIE_SLOT], mysql, 124);
        auction_slot[slot][OWNER_RATE] = cache_get_field_content_int(row, "bidder_account");
        auction_slot[slot][START_RATE] = cache_get_field_content_int(row, "start_rate");
        auction_slot[slot][CURRENT_RATE] = cache_get_field_content_int(row, "current_rate");
        auction_slot[slot][TIMER_END] = cache_get_field_content_int(row, "timer_end");
        auction_slot[slot][DATABASE_ID] = cache_get_field_content_int(row, "database_id");
        auction_slot[slot][SERVER_ID] = cache_get_field_content_int(row, "server_id");
        cache_get_field_content(row, "vehicle_number", auction_slot[slot][NUMBER_VEHICLE], mysql, 7);
        auction_slot[slot][NUMBER_SUM] = cache_get_field_content_int(row, "phone_number");
        loaded++;
    }
    cache_delete(result);

    printf("[AUCTION] persistent slots loaded=%d", loaded);
    return 1;
}

stock Auction_GetSkinName(modelid, output[], size)
{
    if(modelid < 0)
        format(output, size, "Одежда");
    else
        format(output, size, "Скин_%d", modelid);
    return 1;
}

stock Auction_FindOnlineAccount(account_id)
{
    foreach(new playerid : Player)
    {
        if(GetPlayerAccountID(playerid) == account_id)
            return playerid;
    }
    return INVALID_PLAYER_ID;
}

stock Auction_AdjustOnlineBalance(playerid, amount)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(amount > 0 && GetPlayerMoneyEx(playerid) > 2100000000 - amount) return 0;

    AddPlayerData(playerid, P_MONEY, +, amount);
    GivePlayerMoney(playerid, amount);
    return 1;
}

stock Auction_InsertPendingMoney(account_id, amount, const reason[] = "")
{
    if(account_id <= 0 || amount <= 0) return 0;

    new query[384];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `auction_pending_money` (`account_id`,`amount`,`reason`,`created_at`) VALUES (%d,%d,'%e',%d)",
        account_id, amount, reason, gettime()
    );
    mysql_query(mysql, query, false);
    return mysql_errno() == 0;
}

stock Auction_RefundAccount(account_id, amount, const message[] = "")
{
    if(account_id <= 0 || amount <= 0) return 0;

    if(!Auction_InsertPendingMoney(account_id, amount, message))
    {
        // Резервный путь: если очередь недоступна, зачисляем напрямую.
        new query[192];
        mysql_format(mysql, query, sizeof query,
            "UPDATE `accounts` SET `money`=`money`+%d WHERE `id`=%d LIMIT 1",
            amount, account_id
        );
        new Cache:result = mysql_query(mysql, query, true);
        new updated = (!mysql_errno() && cache_affected_rows(mysql) == 1);
        cache_delete(result);
        if(!updated) return 0;

        new online_id = Auction_FindOnlineAccount(account_id);
        if(online_id != INVALID_PLAYER_ID)
        {
            Auction_AdjustOnlineBalance(online_id, amount);
            if(message[0]) SendClientMessage(online_id, -1, message);
        }
        return 1;
    }

    new playerid = Auction_FindOnlineAccount(account_id);
    if(playerid != INVALID_PLAYER_ID)
        Auction_DeliverPendingMoney(playerid);
    return 1;
}

stock Auction_PaySeller(account_id, amount)
{
    if(account_id <= 0 || amount <= 0) return 1;
    return Auction_RefundAccount(account_id, amount, ""SC" Ваш лот продан. Деньги зачислены.");
}

stock Auction_QueueInventoryItem(account_id, item_id, item_count, const item_plate[] = "")
{
    if(account_id <= 0 || item_id <= 0) return 0;

    new query[320];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `auction_pending_items` (`account_id`,`item_id`,`item_count`,`item_plate`,`created_at`) VALUES (%d,%d,%d,'%e',%d)",
        account_id,
        item_id,
        item_count,
        item_plate,
        gettime()
    );
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[AUCTION] pending item insert failed account=%d item=%d errno=%d", account_id, item_id, mysql_errno());
        return 0;
    }

    new playerid = Auction_FindOnlineAccount(account_id);
    if(playerid != INVALID_PLAYER_ID)
        SetTimerEx("Auction_DeliverPendingItems", 750, false, "i", playerid);
    return 1;
}

public Auction_DeliverPendingItems(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "SELECT `id`,`item_id`,`item_count`,`item_plate` FROM `auction_pending_items` WHERE `account_id`=%d ORDER BY `id` ASC",
        account_id
    );
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    new delivered;
    for(new row; row < rows; row++)
    {
        new free_slot = Inventory_GetFreeSlot(playerid);
        if(free_slot == -1) break;

        new pending_id = cache_get_field_content_int(row, "id");
        new item_id = cache_get_field_content_int(row, "item_id");
        new item_count = cache_get_field_content_int(row, "item_count");
        new item_plate[32];
        cache_get_field_content(row, "item_plate", item_plate, mysql, sizeof item_plate);

        if(!Inventory_AddItem(playerid, item_id, free_slot, item_count, item_plate))
            break;

        mysql_format(mysql, query, sizeof query,
            "DELETE FROM `auction_pending_items` WHERE `id`=%d AND `account_id`=%d LIMIT 1",
            pending_id,
            account_id
        );
        mysql_query(mysql, query, false);
        delivered++;
    }
    cache_delete(result);

    if(delivered)
    {
        new message[112];
        format(message, sizeof message, "Получено предметов из хранилища аукциона: %d.", delivered);
        ShowNotificationSile(playerid, 1, 6, 0, 0, message, "");
    }
    else if(rows && Inventory_GetFreeSlot(playerid) == -1)
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "В хранилище аукциона есть предметы. Освободите инвентарь и введите /auctionitems.", "");
    }
    return delivered;
}

public Auction_DeliverPendingMoney(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[320];
    mysql_format(mysql, query, sizeof query,
        "SELECT `id`,`amount`,`reason` FROM `auction_pending_money` WHERE `account_id`=%d ORDER BY `id` ASC",
        account_id
    );
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    new delivered;
    for(new row; row < rows; row++)
    {
        new pending_id = cache_get_field_content_int(row, "id");
        new amount = cache_get_field_content_int(row, "amount");
        new reason[96];
        cache_get_field_content(row, "reason", reason, mysql, sizeof reason);

        if(amount <= 0) continue;
        if(GetPlayerMoneyEx(playerid) > 2100000000 - amount)
        {
            ShowNotificationSile(playerid, 2, 7, -1, -1, "Освободите место на денежном балансе для выплаты аукциона.", "");
            break;
        }

        mysql_query(mysql, "START TRANSACTION", false);
        mysql_format(mysql, query, sizeof query,
            "UPDATE `accounts` SET `money`=`money`+%d WHERE `id`=%d AND `money`<=%d LIMIT 1",
            amount, account_id, 2100000000 - amount
        );
        new Cache:update_result = mysql_query(mysql, query, true);
        new updated = (!mysql_errno() && cache_affected_rows(mysql) == 1);
        cache_delete(update_result);

        if(updated)
        {
            mysql_format(mysql, query, sizeof query,
                "DELETE FROM `auction_pending_money` WHERE `id`=%d AND `account_id`=%d LIMIT 1",
                pending_id, account_id
            );
            new Cache:delete_result = mysql_query(mysql, query, true);
            updated = (!mysql_errno() && cache_affected_rows(mysql) == 1);
            cache_delete(delete_result);
        }

        if(!updated || mysql_errno())
        {
            mysql_query(mysql, "ROLLBACK", false);
            break;
        }
        mysql_query(mysql, "COMMIT", false);

        Auction_AdjustOnlineBalance(playerid, amount);
        if(reason[0]) SendClientMessage(playerid, -1, reason);
        delivered++;
    }
    cache_delete(result);
    return delivered;
}

stock Auction_ValidateAsset(slot)
{
    if(slot < 0 || slot >= MAX_AUCTION_SLOT) return 0;

    new seller = auction_slot[slot][OWNER_SLOT_SQL];
    switch(auction_slot[slot][SLOT_TYPE])
    {
        case TYPE_BUSINESS:
        {
            new businessid = auction_slot[slot][SERVER_ID];
            if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
            if(GetBusinessData(businessid, B_SQL_ID) != auction_slot[slot][DATABASE_ID]) return 0;
            return GetBusinessData(businessid, B_OWNER_ID) == ((seller == -2) ? 0 : seller);
        }
        case TYPE_HOUSE:
        {
            new houseid = auction_slot[slot][SERVER_ID];
            if(houseid < 0 || houseid >= MAX_HOUSES) return 0;
            if(GetHouseData(houseid, H_SQL_ID) != auction_slot[slot][DATABASE_ID]) return 0;
            return GetHouseData(houseid, H_OWNER_ID) == seller;
        }
        case TYPE_VEHICLE:
        {
            new query[160];
            mysql_format(mysql, query, sizeof query,
                "SELECT `id` FROM `ownable_cars` WHERE `id`=%d AND `owner_id`=%d LIMIT 1",
                auction_slot[slot][DATABASE_ID],
                seller
            );
            new Cache:result = mysql_query(mysql, query, true);
            new valid = (!mysql_errno() && cache_num_rows() > 0);
            cache_delete(result);
            return valid;
        }
        case TYPE_VEHICLE_NUMBER:
        {
            new query[224];
            mysql_format(mysql, query, sizeof query,
                "SELECT `id` FROM `ownable_cars` WHERE `id`=%d AND `owner_id`=%d AND `number`='%e' LIMIT 1",
                auction_slot[slot][DATABASE_ID],
                seller,
                auction_slot[slot][NUMBER_VEHICLE]
            );
            new Cache:result = mysql_query(mysql, query, true);
            new valid = (!mysql_errno() && cache_num_rows() > 0);
            cache_delete(result);
            return valid;
        }
        case TYPE_SUM_NUMBER:
        {
            new query[160];
            mysql_format(mysql, query, sizeof query,
                "SELECT `id` FROM `accounts` WHERE `id`=%d AND `phone`=%d LIMIT 1",
                seller,
                auction_slot[slot][NUMBER_SUM]
            );
            new Cache:result = mysql_query(mysql, query, true);
            new valid = (!mysql_errno() && cache_num_rows() > 0);
            cache_delete(result);
            return valid;
        }
        case TYPE_CLOTHES:
        {
            return 1;
        }
    }
    return 0;
}

stock Auction_ReturnUnsoldAsset(slot)
{
    if(auction_slot[slot][SLOT_TYPE] == TYPE_CLOTHES)
    {
        return Auction_QueueInventoryItem(
            auction_slot[slot][OWNER_SLOT_SQL],
            AUCTION_SKIN_ITEM_ID,
            auction_slot[slot][SERVER_ID],
            ""
        );
    }
    return 1;
}

stock Auction_CancelSlot(slot, const reason[])
{
    if(slot < 0 || slot >= MAX_AUCTION_SLOT) return 0;

    if(auction_slot[slot][OWNER_RATE] > 0)
    {
        Auction_RefundAccount(
            auction_slot[slot][OWNER_RATE],
            auction_slot[slot][CURRENT_RATE],
            ""USC" Аукционный лот отменён. Ваша ставка возвращена."
        );
    }

    Auction_ReturnUnsoldAsset(slot);

    new seller_player = Auction_FindOnlineAccount(auction_slot[slot][OWNER_SLOT_SQL]);
    if(seller_player != INVALID_PLAYER_ID && reason[0])
        SendClientMessage(seller_player, -1, reason);

    return reset_slot_auction(slot);
}

CMD:auctionitems(playerid, params[])
{
    #pragma unused params
    Auction_DeliverPendingItems(playerid);
    Auction_DeliverPendingMoney(playerid);
    return 1;
}


/*new type_panel_auction[3][14] =
{
    {"txd:braucbuy"},
    {"txd:braucsell"},
    {"txd:braucmy"}
};*/
new auction_button[8][2][20] =
{
    {"txd:braucnulist", "txd:brauculist"}, //slot
    {"txd:braucnubuy", "txd:braucubuy"}, //купиьь
    {"txd:braucnusell", "txd:braucusell"}, //продать
    {"txd:braucnumy", "txd:braucumy"}, //вкладка мое
    {"txd:braucnutip", "txd:braucutip"}, //тип товара
    {"txd:braucnutovar", "txd:braucutovar"}, //выбор товара
    {"txd:braucnuopisanie", "txd:braucuopisanie"}, //описание товара
    {"txd:braucnucost", "txd:braucucost"} //цена товара
};




stock Auction_CommitBid(playerid, slot, rate)
{
    if(slot < 0 || slot >= MAX_AUCTION_SLOT || !auction_slot[slot][SLOT_TYPE]) return 0;

    new bidder = GetPlayerAccountID(playerid);
    new old_bidder = auction_slot[slot][OWNER_RATE];
    new old_rate = auction_slot[slot][CURRENT_RATE];
    if(bidder <= 0 || rate <= old_rate || GetPlayerMoneyEx(playerid) < rate) return 0;

    new query[512];
    mysql_query(mysql, "START TRANSACTION", false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE `accounts` SET `money`=`money`-%d WHERE `id`=%d AND `money`>=%d LIMIT 1",
        rate, bidder, rate
    );
    new Cache:money_result = mysql_query(mysql, query, true);
    new money_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
    cache_delete(money_result);
    if(!money_changed)
    {
        mysql_query(mysql, "ROLLBACK", false);
        return 0;
    }

    mysql_format(mysql, query, sizeof query,
        "UPDATE `auction_slots` SET `bidder_account`=%d,`current_rate`=%d WHERE `slot_id`=%d AND `bidder_account`=%d AND `current_rate`=%d LIMIT 1",
        bidder, rate, slot, old_bidder, old_rate
    );
    new Cache:slot_result = mysql_query(mysql, query, true);
    new slot_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
    cache_delete(slot_result);
    if(!slot_changed)
    {
        mysql_query(mysql, "ROLLBACK", false);
        return 0;
    }

    if(old_bidder > 0 && !Auction_InsertPendingMoney(old_bidder, old_rate, ""SC" Вашу ставку перебили. Деньги возвращены."))
    {
        mysql_query(mysql, "ROLLBACK", false);
        return 0;
    }

    if(mysql_errno())
    {
        mysql_query(mysql, "ROLLBACK", false);
        return 0;
    }
    mysql_query(mysql, "COMMIT", false);

    auction_slot[slot][OWNER_RATE] = bidder;
    auction_slot[slot][CURRENT_RATE] = rate;
    Auction_AdjustOnlineBalance(playerid, -rate);

    if(old_bidder > 0)
    {
        new old_player = Auction_FindOnlineAccount(old_bidder);
        if(old_player != INVALID_PLAYER_ID)
            Auction_DeliverPendingMoney(old_player);
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 5990)
    {
        if(!response) return 1;

        new rate = strval(inputtext);
        new id = GetPVarInt(playerid, "select_slot");
        if(id < 0 || id >= MAX_AUCTION_SLOT || !auction_slot[id][SLOT_TYPE])
            return SendClientMessage(playerid, -1, ""USC" Лот уже недоступен.");

        if(auction_slot[id][TIMER_END] <= gettime())
            return SendClientMessage(playerid, -1, ""USC" Время торгов по этому лоту истекло.");
        if(auction_slot[id][OWNER_SLOT_SQL] == GetPlayerAccountID(playerid))
            return SendClientMessage(playerid, -1, ""USC" Нельзя делать ставку на свой лот.");
        if(auction_slot[id][OWNER_RATE] == GetPlayerAccountID(playerid))
            return SendClientMessage(playerid, -1, ""USC" Ваша ставка уже является максимальной.");
        if(!Auction_ValidateAsset(id))
        {
            Auction_CancelSlot(id, ""USC" Имущество лота больше недоступно. Лот отменён.");
            return 1;
        }

        new current_rate = auction_slot[id][CURRENT_RATE];
        new increment = current_rate / 50;
        if(increment < 1) increment = 1;
        if(current_rate > 1000000000 - increment)
            return SendClientMessage(playerid, -1, ""USC" Лот достиг предельной ставки.");

        new minimum_rate = current_rate + increment;
        if(rate < minimum_rate || rate > 1000000000)
            return SendClientMessage(playerid, -1, ""USC" Некорректная сумма ставки.");
        if(GetPlayerMoneyEx(playerid) < rate)
            return SendClientMessage(playerid, -1, ""USC" Недостаточно денег для этой ставки.");

        if(!Auction_CommitBid(playerid, id, rate))
            return SendClientMessage(playerid, -1, ""USC" Ставка не сохранена. Деньги не списаны.");

        default_select_slot(playerid);
        player_info_panel[playerid][select_slot] = 0;
        for(new i = 1; i < 6; i++) PlayerTextDrawSetString(playerid, auction_PTD[playerid][i], "-");

        new string[16];
        for(new td; td < 4; td++)
        {
            if(player_show_slot[playerid][td] == -1) continue;
            PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][0]], auction_slot[player_show_slot[playerid][td]][OWNER_SLOT_NAME]);
            PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][1]], auction_slot[player_show_slot[playerid][td]][SLOT_NAME]);
            valstr(string, auction_slot[player_show_slot[playerid][td]][CURRENT_RATE]);
            PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][2]], string);
        }
        SendClientMessage(playerid, -1, ""SC" Вы успешно сделали ставку на лот.");
        return 1;
    }
    if(dialogid == 5991)
    {
        if(!response) return 0;

        switch(GetPVarInt(playerid, "select_param"))
        {
            case 1://type
            {
                switch(listitem + 1)
                {
                    case 1:SetPVarInt(playerid, "type_param", TYPE_VEHICLE);
                    case 2:SetPVarInt(playerid, "type_param", TYPE_HOUSE);
                    case 3:SetPVarInt(playerid, "type_param", TYPE_BUSINESS);
                    case 4:SetPVarInt(playerid, "type_param", TYPE_VEHICLE_NUMBER);
                    case 5:SetPVarInt(playerid, "type_param", TYPE_SUM_NUMBER);
                    case 6:SetPVarInt(playerid, "type_param", TYPE_CLOTHES);
                }

                if(!player_info_panel[playerid][type_tovar])
                {
                    player_info_panel[playerid][type_tovar] = true;
                    PlayerTextDrawSetString(playerid, auction_PTD[playerid][29], auction_button[4][1]);
                } 

                PlayerTextDrawSetString(playerid, auction_PTD[playerid][22], icon_slot[GetPVarInt(playerid, "type_param")]);
                PlayerTextDrawSetString(playerid, auction_PTD[playerid][1], type_slot[GetPVarInt(playerid, "type_param")]);
            }
            case 2: // opisanie
            {
                //if(!inputtext) return SendClientMessage(playerid, -1, ""USC" Нельзя оставлять описание пустым");

                SetPVarString(playerid, "opisanie_param", inputtext);

                if(!player_info_panel[playerid][opisanie_tovar])
                {
                    player_info_panel[playerid][opisanie_tovar] = true;
                    PlayerTextDrawSetString(playerid, auction_PTD[playerid][31], auction_button[6][1]);
                }
                PlayerTextDrawSetString(playerid, auction_PTD[playerid][3], "Есть");
            }
            case 3://price
            {
                new price;

                sscanf(inputtext, "d", price);

                if(price >= 1_000_000_001 || price <= 4_999) return SendClientMessage(playerid, -1, ""USC" Введите сумму от 5000 руб до 1000000000 руб");

                SetPVarInt(playerid, "price_param", price);

                if(!player_info_panel[playerid][price_tovar])
                {
                    player_info_panel[playerid][price_tovar] = true;
                    PlayerTextDrawSetString(playerid, auction_PTD[playerid][28], auction_button[7][1]);
                } 
                PlayerTextDrawSetString(playerid, auction_PTD[playerid][4], inputtext);
            }
        }
    }
    if(dialogid == 5992) // согласие
    {
        if(!response) return 1;

        new text[124], name[24];

        switch(GetPVarInt(playerid, "type_param"))
        {
            case TYPE_VEHICLE_NUMBER:
            {
                new num[7];

                GetPVarString(playerid, "tovar_param_num", num, 7);

                if(num[0] == 0)
                {
                    new id_car = GetPlayerListitemValue(playerid, listitem), num_car[7], Cache:result;
                    
                    mysql_format(mysql, text, sizeof text,
                        "SELECT `number` FROM `ownable_cars` WHERE `id`=%d AND `owner_id`=%d AND `number`!='------' LIMIT 1",
                        id_car, GetPlayerAccountID(playerid));
                    result = mysql_query(mysql, text, true);
                    if(mysql_errno())
                    {
                        cache_delete(result);
                        return SendClientMessage(playerid, -1, ""USC" Не удалось проверить номерной знак.");
                    }

                    if(!cache_num_rows())
                    {
                        cache_delete(result);
                        return SendClientMessage(playerid, -1, ""USC" Номерной знак больше недоступен.");
                    }

                    for(new i, sql = GetPlayerAccountID(playerid); i < MAX_AUCTION_SLOT; i++)
                    {
                        if(auction_slot[i][OWNER_SLOT_SQL] != sql) continue;

                        if(auction_slot[i][SLOT_TYPE] == TYPE_VEHICLE && auction_slot[i][DATABASE_ID] == id_car)
                        {
                            cache_delete(result);
                            return SendClientMessage(playerid, -1, ""SC" Транспорт уже выставлен на аукцион.");
                        }
                    }

                    cache_get_field_content(0, "number", num_car, mysql, sizeof num_car);
                    cache_delete(result);

                    format(text, sizeof text, "Вы хотите выставить на аукцион номерной знак %s", num_car);

                    SetPVarString(playerid, "tovar_param_num", num_car);

                    format(name, 24, "%s", num_car);

                    Dialog
                    (
                        playerid, 5992, DIALOG_STYLE_MSGBOX,
                        "{FF0000}Продажа",
                        text,
                        "Далее", "Назад"
                    );
                }
            }
            case TYPE_CLOTHES:
            {
                if(GetPVarInt(playerid, "tovar_param") || GetPVarInt(playerid, "auction_skin_selected")) return 1;

                new inventory_slot = GetPlayerListitemValue(playerid, listitem);
                if(inventory_slot < 0 || inventory_slot >= MAX_INVENTORY_SLOTS)
                    return SendClientMessage(playerid, -1, ""USC" Одежда не найдена.");

                if(g_PlayerInventory[playerid][inventory_slot][inv_itemId] != AUCTION_SKIN_ITEM_ID)
                    return SendClientMessage(playerid, -1, ""USC" Одежда уже перемещена или использована.");

                new skin_model = g_PlayerInventory[playerid][inventory_slot][inv_itemCount];
                new skin_name[24];
                Auction_GetSkinName(skin_model, skin_name, sizeof skin_name);

                format(text, sizeof text, "Вы хотите выставить на аукцион одежду %s?", skin_name);

                SetPVarInt(playerid, "tovar_param", inventory_slot);
                SetPVarInt(playerid, "tovar_param_server", skin_model);
                SetPVarInt(playerid, "auction_skin_selected", 1);

                format(name, sizeof name, "%s", skin_name);

                Dialog
                (
                    playerid, 5992, DIALOG_STYLE_MSGBOX,
                    "{FF0000}Продажа",
                    text,
                    "Далее", "Назад"
                );
            }
            case TYPE_BUSINESS:
                format(name, 24, "%s", GetBusinessData(GetPVarInt(playerid, "tovar_param_server"), B_NAME));

            case TYPE_HOUSE:
                format(name, 24, "Дом %d", GetPVarInt(playerid, "tovar_param_server"));

            case TYPE_SUM_NUMBER:
            {
                new string[6];
                valstr(string, GetPVarInt(playerid, "tovar_param"));

                format(name, 24, "%s", string);
            }
            case TYPE_VEHICLE:
            {
                new id = GetVehicleModel(GetPVarInt(playerid, "tovar_param_server")) - 400;
                Auction_FormatDisplayName(GetVehicleInfo(id, VI_NAME), name, sizeof name);
            }
        }

        if(!player_info_panel[playerid][tovar])
        {
            player_info_panel[playerid][tovar] = true;
            PlayerTextDrawSetString(playerid, auction_PTD[playerid][30], auction_button[5][1]);
        }
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][2], name);

    }
    if(dialogid == 5993)
    {
        if(response)
        {
            if(GetPVarInt(playerid, "filter_select_veh"))
            {
                new model = GetPlayerListitemValue(playerid, listitem);

                player_info_panel[playerid][filter_vehicle_model] = model;
                player_info_panel[playerid][filter_tovar_type] = TYPE_VEHICLE;

                player_info_panel[playerid][count_list] = 1;
                LeafAuction(playerid, 3);
                DeletePVar(playerid, "filter_select_veh");

                return 1;
            }
            else if(player_info_panel[playerid][auction_filter_type] == 2)
            {
                new min_price, max_price;

                if(sscanf(inputtext, "P<,>dd", min_price, max_price))
                {
                    SendClientMessage(playerid, 0x999999FF, "Некорректный ввод");
                    player_info_panel[playerid][auction_filter_type] = 0;

                    return OnDialogResponse(playerid, 5993, 1, 1, "");
                }
                else
                {
                    if(min_price >= max_price) 
                    {
                        SendClientMessage(playerid, 0xFFFFFFFF, ""USC" Минимальная цена должна быть меньше чем максимальная");
                        player_info_panel[playerid][auction_filter_type] = 0;

                        return OnDialogResponse(playerid, 5993, 1, 1, "");
                    }
                    else if(min_price <= 999 || max_price >= 500_000_000)
                    {
                        SendClientMessage(playerid, 0xFFFFFFFF, ""USC" Цена должна быть от 1000 руб до 500000000 руб");
                        player_info_panel[playerid][auction_filter_type] = 0;

                        return OnDialogResponse(playerid, 5993, 1, 1, "");                               
                    }
                    else
                    {
                        player_info_panel[playerid][auction_filter_type] = 2;
                        player_info_panel[playerid][filter_min_price] = min_price;
                        player_info_panel[playerid][filter_max_price] = max_price;

                        player_info_panel[playerid][count_list] = 1;
                        LeafAuction(playerid, 3);
                        return 1;
                    }
                }
            }
            else if(player_info_panel[playerid][auction_filter_type] == 1)
            {
                if(player_info_panel[playerid][filter_tovar_type] == TYPE_VEHICLE)
                {
                    new dialog[284], list[54], market;

                    switch(listitem+1)
                    {
                        case 1:market = 1;
                        case 2:market = 3;
                        case 3:market = 2;
                    }

                    for(new v, model; v < 32;v++)
                    {
                        if(!car_market_data[market][v][0]) continue;

                        model = car_market_data[market][v][0]-400;

                        format(list, sizeof list, "%d. %s\n", v + 1, GetVehicleInfo(model, VI_NAME));
                        strcat(dialog, list);

                        SetPlayerListitemValue(playerid, v, model);
                    }

                    Dialog
                    (
                        playerid, 5993, DIALOG_STYLE_LIST,
                        "{FF0000}Фильтр",
                        dialog,
                        "Далее", "Назад"
                    );

                    SetPVarInt(playerid, "filter_select_veh", 1);

                    return 1;
                }
                else
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            Dialog
                            (
                                playerid, 5993, DIALOG_STYLE_LIST,
                                "{FF0000}Фильтр",
                                "1. Низкий класс\n"\
                                "1. Средний класс\n"\
                                "1. Высокий класс",
                                "Далее", "Назад"
                            );
                            
                            player_info_panel[playerid][filter_tovar_type] = TYPE_VEHICLE;

                            return 1;
                        }
                        case 1:
                        {
                            player_info_panel[playerid][filter_tovar_type] = TYPE_HOUSE;

                            player_info_panel[playerid][count_list] = 1;
                            LeafAuction(playerid, 3);
                        }
                        case 2:
                        {
                            player_info_panel[playerid][filter_tovar_type] = TYPE_BUSINESS;

                            player_info_panel[playerid][count_list] = 1;
                            LeafAuction(playerid, 3);
                        }
                        case 3:
                        {
                            player_info_panel[playerid][filter_tovar_type] = TYPE_VEHICLE_NUMBER;

                            player_info_panel[playerid][count_list] = 1;
                            LeafAuction(playerid, 3);
                        }
                        case 4:
                        {
                            player_info_panel[playerid][filter_tovar_type] = TYPE_SUM_NUMBER;

                            player_info_panel[playerid][count_list] = 1;
                            LeafAuction(playerid, 3);
                        }
                        case 5:
                        {
                            player_info_panel[playerid][filter_tovar_type] = TYPE_CLOTHES;

                            player_info_panel[playerid][count_list] = 1;
                            LeafAuction(playerid, 3);
                        }
                    }
                }
            }    
            else
            {       
                switch(listitem)
                {
                    case 0:
                    {
                        Dialog
                        (
                            playerid, 5993, DIALOG_STYLE_LIST,
                            "{FF0000}Фильтр",
                            "1. Автомобиль\n"\
                            "2. Недвижимость\n"\
                            "3. Бизнес\n"\
                            "4. Номерной знак\n"\
                            "5. Сим-карта\n"\
                            "6. Одежда",
                            "Далее", "Назад"
                        );

                        player_info_panel[playerid][auction_filter_type] = 1;
                        return 1;
                    }
                    case 1:
                    {   
                        Dialog
                        (
                            playerid, 5993, DIALOG_STYLE_INPUT,
                            "{FF0000}Фильтр",
                            "Введите цену от и до через запятую (1000, 500000000)",
                            "Далее", "Назад"
                        );

                        player_info_panel[playerid][auction_filter_type] = 2;
                        return 1;
                    }
                }
            }
        }
        else 
        {
            player_info_panel[playerid][auction_filter_type] = 0;
            player_info_panel[playerid][filter_tovar_type] = 0;
        }
    }
    #if defined auc_OnDialogResponse
        return auc_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse auc_OnDialogResponse
#if defined auc_OnDialogResponse
forward auc_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public:PlayerTextDrawAuction(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    auction_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 27.3333, 100.2444, "txd:braucbuy"); // фон / основа
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][0], 588.0000, 294.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][0], 0);

    auction_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 490.6665, 211.9851, "-"); // имя владельца слота
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][1], 0.2480, 1.3330);//0.3133, 1.2888
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][1], -21.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][1], 0);

    auction_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 490.6665, 236.4593, "-"); // тип слота
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][2], 0.2480, 1.3330);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][2], -21.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][2], 0);

    auction_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 490.6665, 261.7631, "-"); // стартовая
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][3], 0.2480, 1.3330);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][3], -21.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][3], -1107374134);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][3], 0);

    auction_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 490.6665, 286.6520, "-"); // текущяя цена
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][4], 0.2480, 1.3330);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][4], -21.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][4], -1107374134);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][4], 0);

    auction_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 490.6665, 311.5410, "-"); // время
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][5], 0.2480, 1.3330);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][5], -20.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][5], 0);

    auction_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 174.6666, 293.9630, "txd:braucnulist"); // 4
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][6], 298.0000, 70.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][6], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][6], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][6], 1);

    auction_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 193.3333, 316.5185, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][7], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][7], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][7], 0);

    auction_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 303.6669, 317.3482, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][8], 0.2350, 1.4262);//0.3026, 1.2971
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][8], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][8], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][8], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][8], 0);

    auction_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 381.3334, 326.8889, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][9], 0.2150, 1.3262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][9], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][9], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][9], -1107374134);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][9], 0);

    auction_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 174.6666, 144.6296, "txd:braucnulist"); // 1
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][10], 298.0000, 70.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][10], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][10], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][10], 1);

    auction_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 193.3333, 167.1852, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][11], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][11], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][11], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][11], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][11], 0);

    auction_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 303.6669, 168.0148, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][12], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][12], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][12], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][12], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][12], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][12], 0);

    auction_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 381.3334, 177.5556, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][13], 0.2150, 1.3262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][13], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][13], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][13], -1107374134);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][13], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][13], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][13], 0);

    auction_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 174.6666, 195.2370, "txd:braucnulist"); // 2
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][14], 298.0000, 70.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][14], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][14], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][14], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][14], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][14], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][14], 1);

    auction_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 193.3333, 217.7926, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][15], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][15], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][15], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][15], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][15], 0);

    auction_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 303.6669, 218.6222, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][16], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][16], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][16], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][16], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][16], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][16], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][16], 0);

    auction_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 381.3334, 228.1630, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][17], 0.2150, 1.3262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][17], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][17], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][17], -1107374134);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][17], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][17], 0);

    auction_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 174.6666, 244.6000, "txd:braucnulist"); // 3
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][18], 298.0000, 70.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][18], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][18], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][18], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][18], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][18], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][18], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][18], 1);

    auction_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 193.3333, 267.1556, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][19], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][19], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][19], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][19], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][19], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][19], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][19], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][19], 0);

    auction_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 303.6669, 267.9852, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][20], 0.2350, 1.4262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][20], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][20], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][20], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][20], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][20], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][20], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][20], 0);

    auction_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 381.3334, 277.5260, "-"); // пусто
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][21], 0.2150, 1.3262);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][21], -70.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][21], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][21], -1107374134);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][21], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][21], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][21], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][21], 0);

    auction_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 492.3333, 132.6000, "txd:brauchome"); // иконка слота
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][22], 103.0000, 65.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][22], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][22], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][22], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][22], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][22], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][22], 0);

    auction_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 43.3333, 125.1333, "txd:braucubuy"); // вклада покупки
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][23], 109.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][23], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][23], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][23], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][23], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][23], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][23], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][23], 1);

    auction_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 43.3333, 170.3481, "txd:braucnusell"); // вкладка продажа
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][24], 109.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][24], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][24], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][24], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][24], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][24], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][24], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][24], 1);

    auction_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 43.6666, 216.8074, "txd:braucnumy"); // вкладка мои
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][25], 109.0000, 61.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][25], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][25], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][25], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][25], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][25], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][25], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][25], 1);

    auction_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 43.3333, 285.6667, "txd:braucexit"); // выйти
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][26], 109.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][26], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][26], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][26], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][26], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][26], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][26], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][26], 1);

    auction_PTD[playerid][27] = CreatePlayerTextDraw(playerid, 94.3333, 368.3703, "1"); // страница
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][27], 0.3563, 1.6207);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][27], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][27], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][27], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][27], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][27], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][27], 0);

    auction_PTD[playerid][28] = CreatePlayerTextDraw(playerid, 172.0000, 289.4001, "txd:braucnucost"); // пусто
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][28], 302.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][28], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][28], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][28], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][28], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][28], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][28], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][28], 1);

    auction_PTD[playerid][29] = CreatePlayerTextDraw(playerid,171.3333, 154.5852, "txd:braucnutip"); // тип товара
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][29], 302.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][29], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][29], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][29], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][29], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][29], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][29], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][29], 1);

    auction_PTD[playerid][30] = CreatePlayerTextDraw(playerid,172.0000, 200.2147, "txd:braucnutovar"); // товар
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][30], 302.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][30], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][30], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][30], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][30], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][30], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][30], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][30], 1);

    auction_PTD[playerid][31] = CreatePlayerTextDraw(playerid,172.6666, 244.1851, "txd:braucnuopisanie"); // описание
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][31], 302.0000, 63.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][31], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][31], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][31], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][31], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][31], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][31], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][31], 1);

    auction_PTD[playerid][32] = CreatePlayerTextDraw(playerid,491.9997, 310.7110, "0_RUB"); // продвижение
    PlayerTextDrawLetterSize(playerid, auction_PTD[playerid][32], 0.2480, 1.3330);
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][32], 496.9997, 0.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][32], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][32], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][32], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][32], 1);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][32], 1);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][32], 0);

    auction_PTD[playerid][33] = CreatePlayerTextDraw(playerid, 240.3332, 132.1851, "txd:braucsale"); // пусто
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][33], 158.0000, 197.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][33], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][33], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][33], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][33], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][33], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][33], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][33], 1);

    auction_PTD[playerid][34] = CreatePlayerTextDraw(playerid, 393.3332, 146.2888, "txd:braucpurchase"); // пусто
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][34], 143.0000, 175.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][34], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][34], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][34], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][34], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][34], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][34], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][34], 1);

    auction_PTD[playerid][35] = CreatePlayerTextDraw(playerid, 140.0001, 362.5701, "txd:braucright"); //следующий список
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][35], 24.0000, 27.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][35], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][35], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][35], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][35], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][35], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][35], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][35], 1);

    auction_PTD[playerid][36] = CreatePlayerTextDraw(playerid, 39.3333, 362.9849, "txd:braucleft"); // прошлый список
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][36], 23.0000, 27.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][36], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][36], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][36], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][36], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][36], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][36], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][36], 1);

    auction_PTD[playerid][37] = CreatePlayerTextDraw(playerid, 482.3333, 319.6813, "txd:braucbet"); // сделать ставку
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][37], 122.0000, 57.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][37], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][37], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][37], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][37], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][37], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][37], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][37], 1);

    auction_PTD[playerid][38] = CreatePlayerTextDraw(playerid, 439.0000, 115.1778, "txd:braucfilter"); // фильтер
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][38], 24.0000, 26.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][38], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][38], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][38], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][38], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][38], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][38], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][38], 1);

    auction_PTD[playerid][39] = CreatePlayerTextDraw(playerid, 482.3333, 319.6813, "txd:braucexpose"); // выставить
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][39], 122.0000, 57.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][39], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][39], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][39], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][39], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][39], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][39], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][39], 1);
}

stock Auction_Init()
{
    // Названия бизнесов не перезаписываются: используются значения из базы данных.
    CreateDynamic3DTextLabel("Введите команду {FF0000}/auction{FFFFFF}\nЧтобы использовать аукцион", -1, 1000.000915,2508.325927,1497.994628, 5.0);
    enter_auction = CreateDynamicSphere(2092.610351,-2283.928955,23.096267, 1.0, 0, 0);
    exit_auction = CreateDynamicSphere(999.965148,2488.335205,1499.304687, 1.0, AUCTION_WORLD, 1);
    CreateDynamicPickup(19134, 23, 2092.610351,-2283.928955,23.096267, 0, 0);
    CreateDynamicPickup(19134, 23, 999.965148,2488.335205,1499.304687, AUCTION_WORLD, 1);
    Create3DTextLabel("{FFFF00}Вход в аукцион\n{FFFFFF}Подойдите ближе чтобы войти", -1, 2092.610351,-2283.928955,23.096267, 10.0, 0);//Автор данной системы https://t.me/welsistudio (Welsi Studio)
    
    defualt_slot();
    if(!Auction_CreateTables())
    {
        print("[AUCTION] initialization stopped because database tables are unavailable");
        return 0;
    }

    if(!Auction_LoadSlots())
        print("[AUCTION] persistent slot loading failed; retry will require a server restart");

    SetTimer("AuctionUpdate", 5000, false);
    print("[AUCTION] full integration initialized");
    return 1;
}
   
public OnPlayerConnect(playerid)
{
    player_cd_auction[playerid] = 0;
    for(new index; index < 4; index++) player_show_slot[playerid][index] = -1;

    player_info_panel[playerid][show_panel] = false;
    player_info_panel[playerid][count_list] = 1;
    player_info_panel[playerid][select_slot] = 0;
    player_info_panel[playerid][select_type] = 0;
    player_info_panel[playerid][select_tab] = 0;
    player_info_panel[playerid][filter_min_price] = -1;
    player_info_panel[playerid][filter_max_price] = -1;
    player_info_panel[playerid][auction_filter_type] = 0;
    player_info_panel[playerid][filter_tovar_type] = 0;
    player_info_panel[playerid][filter_vehicle_model] = 0;
    player_info_panel[playerid][type_tovar] = false;
    player_info_panel[playerid][price_tovar] = false;
    player_info_panel[playerid][opisanie_tovar] = false;
    player_info_panel[playerid][tovar] = false;

    SetTimerEx("PlayerTextDrawAuction", 6000, false, "i", playerid);
    #if defined auc_OnPlayerConnect
        return auc_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect auc_OnPlayerConnect
#if defined auc_OnPlayerConnect
    forward auc_OnPlayerConnect(playerid);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == enter_auction)
    {
        SetPlayerPosEx(playerid, 999.987854,2489.679443,1499.304687,359.335876, 1, AUCTION_WORLD);
    }
    if(areaid == exit_auction)
    {
        SetPlayerPosEx(playerid, 2090.941650,-2283.999511,23.101566,92.530944, 0, 0);
    }
    #if defined auc_OnPlayerEnterDynamicArea
        return auc_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea auc_OnPlayerEnterDynamicArea
#if defined auc_OnPlayerEnterDynamicArea
    forward auc_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

stock default_select_slot(playerid)
{
    if(player_info_panel[playerid][select_slot] != 0)
    {
        new string[20];
        strcat(string, auction_button[0][0]);
        switch(player_info_panel[playerid][select_slot])
        {
            case 4:PlayerTextDrawSetString(playerid, auction_PTD[playerid][6], string);
            case 1:PlayerTextDrawSetString(playerid, auction_PTD[playerid][10], string);
            case 2:PlayerTextDrawSetString(playerid, auction_PTD[playerid][14], string);
            case 3:PlayerTextDrawSetString(playerid, auction_PTD[playerid][18], string);
        }
    }
    return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == auction_PTD[playerid][6])
    {
        default_select_slot(playerid);
        new slot = player_show_slot[playerid][3];
        if(slot == -1) return 1;

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][1], auction_slot[slot][OWNER_SLOT_NAME]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][2], type_slot[auction_slot[slot][SLOT_TYPE]]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][22], icon_slot[auction_slot[slot][SLOT_TYPE]]);

        new string[13];
        format(string, sizeof string, "%d_руб", auction_slot[slot][START_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][3], string);
        
        format(string, sizeof string, "%d_руб", auction_slot[slot][CURRENT_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][4], string);

        format(string, 9, "%d_ч.",  ConvertUnixTime(auction_slot[slot][TIMER_END] - gettime(), CONVERT_TIME_TO_HOURS));

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][5], string);


        player_info_panel[playerid][select_slot] = 4;
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][6], auction_button[0][1]);

        //SCM(playerid, -1, "ВЫБРАЛ 4 СЛОТ");
    }
    if(playertextid == auction_PTD[playerid][10])
    {
        default_select_slot(playerid);

        new slot = player_show_slot[playerid][0];
        if(slot == -1) return 1;

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][1], auction_slot[slot][OWNER_SLOT_NAME]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][2], type_slot[auction_slot[slot][SLOT_TYPE]]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][22], icon_slot[auction_slot[slot][SLOT_TYPE]]);

        new string[13];
        format(string, sizeof string, "%d_руб", auction_slot[slot][START_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][3], string);
        
        format(string, sizeof string, "%d_руб", auction_slot[slot][CURRENT_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][4], string);

        format(string, 9, "%d_ч.",  ConvertUnixTime(auction_slot[slot][TIMER_END]- gettime(), CONVERT_TIME_TO_HOURS));

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][5], string);


        player_info_panel[playerid][select_slot] = 1;
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][10], auction_button[0][1]);

        //SCM(playerid, -1, "ВЫБРАЛ 1 СЛОТ");
    }
    if(playertextid == auction_PTD[playerid][14])
    {
        default_select_slot(playerid);
        new slot = player_show_slot[playerid][1];
        if(slot == -1) return 1;

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][1], auction_slot[slot][OWNER_SLOT_NAME]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][2], type_slot[auction_slot[slot][SLOT_TYPE]]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][22], icon_slot[auction_slot[slot][SLOT_TYPE]]);

        new string[13];
        format(string, sizeof string, "%d_руб", auction_slot[slot][START_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][3], string);
        
        format(string, sizeof string, "%d_руб", auction_slot[slot][CURRENT_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][4], string);

        format(string, 9, "%d_ч.",  ConvertUnixTime(auction_slot[slot][TIMER_END]- gettime(), CONVERT_TIME_TO_HOURS));

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][5], string);

        player_info_panel[playerid][select_slot] = 2;
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][14], auction_button[0][1]);

        //SCM(playerid, -1, "ВЫБРАЛ 2 СЛОТ");
    }
    if(playertextid == auction_PTD[playerid][18])
    {
        default_select_slot(playerid);
        new slot = player_show_slot[playerid][2];
        if(slot == -1) return 1;
        
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][1], auction_slot[slot][OWNER_SLOT_NAME]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][2], type_slot[auction_slot[slot][SLOT_TYPE]]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][22], icon_slot[auction_slot[slot][SLOT_TYPE]]);

        new string[13];
        format(string, sizeof string, "%d_руб", auction_slot[slot][START_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][3], string);
        
        format(string, sizeof string, "%d_руб", auction_slot[slot][CURRENT_RATE]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][4], string);

        format(string, 9, "%d_ч.",  ConvertUnixTime(auction_slot[slot][TIMER_END] - gettime(), CONVERT_TIME_TO_HOURS));

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][5], string);

        player_info_panel[playerid][select_slot] = 3;
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][18], auction_button[0][1]);

        //SCM(playerid, -1, "ВЫБРАЛ 3 СЛОТ");
    }
    if(playertextid == auction_PTD[playerid][23])
    {
        //SCM(playerid, -1, "ВКЛАДКА ПОКУПКА");      
        ShowTabBuy(playerid);
    }
    if(playertextid == auction_PTD[playerid][24])
    {
        //SCM(playerid, -1, "ВКЛАДКА ПРОДАЖА");   
        ShowTabSell(playerid);     
    }
    if(playertextid == auction_PTD[playerid][25])
    {
        //player_info_panel[playerid][select_tab] = 3;

        //SCM(playerid, -1, "ВКЛАДКА МОИ");  
        ShowTabMy(playerid);     
    }
    if(playertextid == auction_PTD[playerid][26])
    {
        HideTextDrawAuction(playerid);
        //SCM(playerid, -1, "ВЫЙТИ");
    }
    if(playertextid == auction_PTD[playerid][28])
    {
        if(!player_info_panel[playerid][opisanie_tovar]) return SCM(playerid, -1, " Сначало напишите описание");
        if(player_info_panel[playerid][price_tovar]) return 0;

        Dialog
        (
            playerid, 5991, DIALOG_STYLE_INPUT,
            "{FF0000} Продажа",
            "Введите начальную цену за Ваш товар: (5 процентов коммиссия аукциона от итоговой суммы)",
            "Далее","Назад"
        );
        SetPVarInt(playerid, "select_param", 3);
        //SCM(playerid, -1, "ЦЕНА");
    }
    if(playertextid == auction_PTD[playerid][29])
    {
        player_info_panel[playerid][filter_vehicle_model] = 0;
        player_info_panel[playerid][filter_tovar_type] = 0;
        player_info_panel[playerid][auction_filter_type] = 0;
        player_info_panel[playerid][type_tovar] = false;
        player_info_panel[playerid][price_tovar] = false;
        player_info_panel[playerid][tovar] = false;
        player_info_panel[playerid][opisanie_tovar] = false;

        //if(GetPVarInt(playerid, "type_param")) return 1;
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][31], auction_button[6][0]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][30], auction_button[5][0]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][28], auction_button[7][0]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][29], auction_button[4][0]);

        for(new pon = 1; pon < 6;pon++)
        {
            PlayerTextDrawSetString(playerid, auction_PTD[playerid][pon], "-");
        }

        DeletePVar(playerid, "opisanie_param");
        DeletePVar(playerid, "tovar_param_num");
        if(GetPVarInt(playerid, "type_param"))DeletePVar(playerid, "type_param");
        if(GetPVarInt(playerid, "tovar_param_server"))DeletePVar(playerid, "tovar_param_server");
        if(GetPVarInt(playerid, "price_param"))DeletePVar(playerid, "price_param");
        if(GetPVarInt(playerid, "tovar_param"))DeletePVar(playerid, "tovar_param");
        if(GetPVarInt(playerid, "select_type"))DeletePVar(playerid, "select_type");

        Dialog
        (
            playerid, 5991, DIALOG_STYLE_LIST,
            "{FF0000}Продажа",
            "1. Автомобиль\n"\
            "2. Недвижимость\n"\
            "3. Бизнес\n"\
            "4. Номерной знак\n"\
            "5. Сим-карта\n"\
            "6. Одежда",
            "Далее", "Назад"
        );

        SetPVarInt(playerid, "select_param", 1);
        //SCM(playerid, -1, "ТИП");
    }
    if(playertextid == auction_PTD[playerid][30])
    {
        if(!player_info_panel[playerid][type_tovar]) return SCM(playerid, -1, "Сначало выберите тип товара");
        if(player_info_panel[playerid][tovar]) return 0;

        new text[284];

        switch(GetPVarInt(playerid, "type_param"))
        {
            case TYPE_VEHICLE:
            {
                if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
                {
                    new vehicle = GetPlayerOwnableCar(playerid);
                    new model = GetVehicleModel(vehicle) - 400;
                    new action = GetVehicleData(vehicle, V_ACTION_ID);

                    SetPVarInt(playerid, "tovar_param", GetOwnableCarData(action, OC_SQL_ID));
                    SetPVarInt(playerid, "tovar_param_server", vehicle);

                    format(text, sizeof text, "Вы хотите выставить на аукцион транспорт %s [%d]?", GetVehicleInfo(model, VI_NAME), GetOwnableCarData(action, OC_SQL_ID));

                    Dialog
                    (
                        playerid, 5992, DIALOG_STYLE_MSGBOX,
                        "{FF0000}Продажа",
                        text,
                        "Далее", "Назад"
                    );
                }
                else SendClientMessage(playerid, -1, ""USC" Ваш транспорт не загружен на сервер");
            }
            case TYPE_BUSINESS:
            {
                if(GetPlayerBusiness(playerid) != -1)
                {
                    new business = GetPlayerBusiness(playerid);
                    new sql = GetBusinessData(business, B_SQL_ID);

                    SetPVarInt(playerid, "tovar_param", sql);
                    SetPVarInt(playerid, "tovar_param_server", business);

                    format(text, sizeof text, "Вы хотите выставить на аукцион бизнес %s?", GetBusinessData(business, B_NAME), sql);

                    Dialog
                    (
                        playerid, 5992, DIALOG_STYLE_MSGBOX,
                        "{FF0000}Продажа",
                        text,
                        "Далее", "Назад"
                    );
                }
                else SendClientMessage(playerid, -1, ""USC" У вас нет бизнеса");
            }
            case TYPE_HOUSE:
            {
                if(GetPlayerHouse(playerid) != -1)
                {
                    new house = GetPlayerHouse(playerid);
                    new sql = GetHouseData(house, H_SQL_ID);

                    SetPVarInt(playerid, "tovar_param", sql);
                    SetPVarInt(playerid, "tovar_param_server", house);

                    format(text, sizeof text, "Вы хотите выставить на аукцион Дом %d?", house);

                    Dialog
                    (
                        playerid, 5992, DIALOG_STYLE_MSGBOX,
                        "{FF0000}Продажа",
                        text,
                        "Далее", "Назад"
                    );
                }
                else SendClientMessage(playerid, -1, ""USC" У вас нет недвижимости");
            }
            case TYPE_SUM_NUMBER:
            {
                if(GetPlayerPhone(playerid))
                {
                    new sum = GetPlayerPhone(playerid);

                    SetPVarInt(playerid, "tovar_param", sum);

                    format(text, sizeof text, "Вы хотите выставить на аукцион сим-карту %d?", sum);

                    Dialog
                    (
                        playerid, 5992, DIALOG_STYLE_MSGBOX,
                        "{FF0000}Продажа",
                        text,
                        "Далее", "Назад"
                    );
                }
                else SendClientMessage(playerid, -1, ""USC" У вас нет сим-карта");
            }
            case TYPE_VEHICLE_NUMBER:
            {
                new Cache:result;

                mysql_format(mysql, text, sizeof text, "SELECT * FROM ownable_cars WHERE owner_id = %d AND number != '------'", GetPlayerAccountID(playerid));
                result = mysql_query(mysql, text, true);
                if(mysql_errno())
                {
                    cache_delete(result);
                    return SendClientMessage(playerid, -1, ""USC" Не удалось загрузить номерные знаки.");
                }

                if(!cache_num_rows())
                {
                    cache_delete(result);
                    return SendClientMessage(playerid, -1, ""USC" У вас нет транспорта с номером");
                }

                new rows = cache_num_rows(), query[54], id, model_id, car_number[7];
                
                format(text, sizeof text, "");

				for(new i = 0; i < rows; i ++)
				{
					id = cache_get_field_content_int(i, "id");
					model_id = cache_get_field_content_int(i, "model_id") - 400;
					cache_get_field_content(i, "number", car_number);

					format(query, sizeof query, "{FFFFFF}%d. %s - %s\n", i + 1, GetVehicleInfo(model_id, VI_NAME), car_number);
					strcat(text, query);
					SetPlayerListitemValue(playerid, i, id);
				}
                cache_delete(result);

                Dialog
                (
                    playerid, 5992, DIALOG_STYLE_LIST,
                    "{FF0000}Продажа",
                    text, 
                    "Далее", "Назад"
                );
            }
            case TYPE_CLOTHES:
            {
                new rows;
                new query[72];
                new skin_name[24];

                text[0] = EOS;
                for(new inventory_slot; inventory_slot < MAX_INVENTORY_SLOTS; inventory_slot++)
                {
                    if(g_PlayerInventory[playerid][inventory_slot][inv_itemId] != AUCTION_SKIN_ITEM_ID)
                        continue;

                    Auction_GetSkinName(g_PlayerInventory[playerid][inventory_slot][inv_itemCount], skin_name, sizeof skin_name);
                    format(query, sizeof query, "{FFFFFF}%d. %s\n", rows + 1, skin_name);
                    strcat(text, query);
                    SetPlayerListitemValue(playerid, rows, inventory_slot);
                    rows++;
                }

                if(!rows) return SendClientMessage(playerid, -1, ""USC" У вас нет свободной одежды.");

                Dialog
                (
                    playerid, 5992, DIALOG_STYLE_LIST,
                    "{FF0000}Продажа",
                    text,
                    "Далее", "Назад"
                );
            }
        }

        //SCM(playerid, -1, "ТОВАР");
    }
    if(playertextid == auction_PTD[playerid][31])
    {
        if(!player_info_panel[playerid][tovar]) return SCM(playerid, -1, "Сначало выберите товар");
        if(player_info_panel[playerid][opisanie_tovar]) return 0;

        Dialog
        (
            playerid, 5991, DIALOG_STYLE_INPUT,
           "{FF0000}Продажа",
           "Введите описание к Вашему товару, чем лучше описание - тем быстрее Вы сможете продать Ваш товар",
           "Далее","Назад"
        );

        SetPVarInt(playerid, "select_param", 2);
        //SCM(playerid, -1, "ОПИСАНИЕ");
    }
    if(playertextid == auction_PTD[playerid][33])
    {
        new bool:have_sell, list[48], dialog[284];

        for(new c, account = GetPlayerAccountID(playerid);c < MAX_AUCTION_SLOT;c++)
        {
            if(auction_slot[c][OWNER_SLOT_SQL] != account) continue;

            format(list, sizeof list, "%d. %s \t %d ч.\n", c + 1, auction_slot[c][SLOT_NAME], ConvertUnixTime(auction_slot[c][TIMER_END] - gettime(), CONVERT_TIME_TO_HOURS));
            strcat(dialog, list);
            have_sell = true;
        }

        if(!have_sell) return ShowNotification(playerid, 2, "У вас нет ставок на продажу", 3, "", "");

        Dialog
        (
            playerid, -1, DIALOG_STYLE_LIST,
            "{FF0000}Продажи",
            dialog, 
            "Выйти", ""
        );

        //SCM(playerid, -1, "МОИ ПРОДАЖИ");
    }
    if(playertextid == auction_PTD[playerid][34])
    {
        new bool:have_buy, list[48], dialog[284];
        for(new c, account = GetPlayerAccountID(playerid);c < MAX_AUCTION_SLOT;c++)
        {
            if(auction_slot[c][OWNER_RATE] != account) continue;

            format(list, sizeof list, "%d. %s \t %d ч.\n", c + 1, auction_slot[c][SLOT_NAME], ConvertUnixTime(auction_slot[c][TIMER_END] - gettime(), CONVERT_TIME_TO_HOURS));
            strcat(dialog, list);
            have_buy = true;
        }

        if(!have_buy) return ShowNotification(playerid, 2, "У вас нет ставок на покупку", 3, "", ""); 

        Dialog
        (
            playerid, -1, DIALOG_STYLE_LIST,
            "{FF0000}Покупки",
            dialog, 
            "Выйти", ""
        );
        //SCM(playerid, -1, "МОИ ПОКУПКА");
    } 
    if(playertextid == auction_PTD[playerid][37])
    {
        new id_slot, dialog[254];

        switch(player_info_panel[playerid][select_slot])
        {
            case 1:id_slot = player_show_slot[playerid][0];
            case 2:id_slot = player_show_slot[playerid][1];
            case 3:id_slot = player_show_slot[playerid][2];
            case 4:id_slot = player_show_slot[playerid][3];
        }

        if(!auction_slot[id_slot][SLOT_TYPE]) return 0;

        if(auction_slot[id_slot][TIMER_END] <= gettime()) return SendClientMessage(playerid, -1, ""SC" Время вышло. Лот скоро удалиться.");

        if(GetPlayerMoneyEx(playerid) < auction_slot[id_slot][CURRENT_RATE])
        {
            format(dialog, sizeof dialog, "У вас %d, а нужно %d рублей", GetPlayerMoneyEx(playerid), auction_slot[id_slot][CURRENT_RATE]);
            ShowNotification(playerid, 2, dialog, 2, "", "");

            return 1;
        }
        else if(auction_slot[id_slot][OWNER_SLOT_SQL] == GetPlayerAccountID(playerid))
        {
            SendClientMessage(playerid, -1, ""SC" Вы не можете сделать ставку на свой лот.");
            return 1;
        }
        else if(auction_slot[id_slot][OWNER_RATE] == GetPlayerAccountID(playerid))
        {
            SendClientMessage(playerid, -1, ""SC" Вы уже сделали ставку.");
            return 1;
        }
        
        switch(auction_slot[id_slot][SLOT_TYPE])
        {
            case TYPE_BUSINESS:
            {
                if(GetPlayerBusiness(playerid) != -1) return SendClientMessage(playerid, -1, ""SC" У вас уже имеется бизнес");

                for(new i, account = GetPlayerAccountID(playerid); i < MAX_AUCTION_SLOT; i ++)
                {
                    if(auction_slot[i][SLOT_TYPE] != TYPE_BUSINESS) continue;
                    else if(auction_slot[i][OWNER_RATE] != account) continue;

                    SendClientMessage(playerid, -1, ""SC" Вы уже делали ставку на другой бизнес.");
                    return 1;   
                }
            }
            case TYPE_HOUSE:
            {
                if(GetPlayerHouse(playerid) != -1) return SendClientMessage(playerid, -1, ""SC" У вас уже имеется недвижемость");

                for(new i, account = GetPlayerAccountID(playerid); i < MAX_AUCTION_SLOT; i ++)
                {
                    if(auction_slot[i][SLOT_TYPE] != TYPE_HOUSE) continue;
                    else if(auction_slot[i][OWNER_RATE] != account) continue;

                    SendClientMessage(playerid, -1, ""SC" Вы уже делали ставку на другую недвижимость.");
                    return 1;   
                }
            }
            case TYPE_VEHICLE_NUMBER:
            {
                new query[128];
                new Cache: result, rows;

                mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE number = '------' AND owner_id='%d' LIMIT 1", GetPlayerAccountID(playerid));
                result = mysql_query(mysql, query, true);
                if(mysql_errno())
                {
                    cache_delete(result);
                    return SendClientMessage(playerid, -1, ""USC" Не удалось проверить транспорт для номерного знака.");
                }

                rows = cache_num_rows();
                cache_delete(result);

                if(!rows) return SendClientMessage(playerid, -1, ""SC" У вас нет транспорта без номерного знака");
            }
            case TYPE_SUM_NUMBER:
            {
                if(GetPlayerPhone(playerid)) 
                {
                    for(new i; i < 5; i++) SendClientMessage(playerid, -1, ""USC" У вас уже есть сим-карта. При выйгрыше она измениться на новую");
                }
            }
        }

        new increment = auction_slot[id_slot][CURRENT_RATE] / 50;
        if(increment < 1) increment = 1;
        new price = auction_slot[id_slot][CURRENT_RATE] > 1000000000 - increment ? 1000000000 : auction_slot[id_slot][CURRENT_RATE] + increment;

        format(dialog, sizeof dialog,
        "Описание от {FFFF00}продавца: {FFFFFF}%s\n\n"\
        "{FFFFFF}%s: {FFFF00}%s\n\n"\
        "{FFFFFF}Введите сумму которую хотите отдать за данный лот. Минимальная ставка: {FFFF00}%d рублей",
        auction_slot[id_slot][OPISANIE_SLOT], type_slot[auction_slot[id_slot][SLOT_TYPE]], auction_slot[id_slot][SLOT_NAME], 
        price
        );

        Dialog
        (
            playerid, 5990, DIALOG_STYLE_INPUT,
            "{FF0000}Ставка",
            dialog,
            "Далее", "Назад"
        );


        SetPVarInt(playerid, "select_slot", id_slot);

        //SCM(playerid, -1, "ПОСТАВИТЬ");
    }
    if(playertextid == auction_PTD[playerid][38]) 
    {
        Dialog
        (
            playerid, 5993, DIALOG_STYLE_LIST,
            "{FF0000}Фильтр",
            "1. Выбрать тип покупки\n"\
            "2. Выбрать цену покупки",
            "Далее", "Назад"
        );

        player_info_panel[playerid][auction_filter_type] = 0;
        player_info_panel[playerid][filter_tovar_type] = 0;
        player_info_panel[playerid][count_list] = 1;
        LeafAuction(playerid, 3);
    }
    if(playertextid == auction_PTD[playerid][39]) 
    {
        if(!player_info_panel[playerid][price_tovar]) return SendClientMessage(playerid, -1, ""USC" Сначало выберите все");
               
        new type, opisanie[124], start, data_base, server_id, number_veh[7], number_phone;

        type = GetPVarInt(playerid, "type_param");
        
        if(type == TYPE_SUM_NUMBER) number_phone = GetPVarInt(playerid, "tovar_param");

        GetPVarString(playerid, "opisanie_param", opisanie, 124);
        GetPVarString(playerid, "tovar_param_num", number_veh, 7);

        data_base = GetPVarInt(playerid, "tovar_param");
        server_id = GetPVarInt(playerid, "tovar_param_server");
        if(type == TYPE_VEHICLE)
        {
            if(GetPlayerOwnableCar(playerid) != GetPVarInt(playerid, "tovar_param_server"))
                return SendClientMessage(playerid,-1, ""USC" Ваш транспорт выгружен");

            server_id = GetVehicleModel(GetPVarInt(playerid, "tovar_param_server"));
        } 
        
        start = GetPVarInt(playerid, "price_param");
        

        create_auction_slot(playerid, type, opisanie, start, data_base, server_id, number_veh, number_phone);
    }
    if(playertextid == auction_PTD[playerid][35])
    {
        if(player_info_panel[playerid][count_list] == 256) return 1;

        player_info_panel[playerid][count_list]++;

        new all_slot = player_info_panel[playerid][count_list]*4 - 1;

        LeafAuction(playerid, all_slot);
        //UpdateListSlot(playerid, player_info_panel[playerid][count_list]);
        //SCM(playerid, -1, "СЛЕДУЮЩИЙ СПИСОК");
    }
    if(playertextid == auction_PTD[playerid][36])
    {
        if(player_info_panel[playerid][count_list] == 1) return 1;

        player_info_panel[playerid][count_list]--;

        new all_slot = player_info_panel[playerid][count_list]*4 - 1;
        
        LeafAuction(playerid, all_slot);
        //UpdateListSlot(playerid, player_info_panel[playerid][count_list]);
        //SCM(playerid, -1, "ПРЕДЫДУЩИЙ СПИСОК");
    }
	#if defined auc_OnPlayerClickPlayer
		return auc_OnPlayerClickPlayer(playerid, playertextid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined auc_OnPlayerClickPlayer
	forward auc_OnPlayerClickPlayer(playerid, PlayerText:playertextid);
#endif
#define	OnPlayerClickPlayerTextDraw auc_OnPlayerClickPlayer


CMD:auction(playerid)
{
    new hour;

    gettime(hour);

   if(!(8 <= hour <= 21)) return SendClientMessage(playerid, -1, ""USC"Аукцион работает с 8:00 до 22:00");

    if(GetPlayerVirtualWorld(playerid) != AUCTION_WORLD) return 
        EnablePlayerGPS(playerid, 55, 2090.941650,-2283.999511,23.101566, "Местоположение аукциона отмечено на карте.");

    HideTextDrawAuction(playerid);

    if(player_cd_auction[playerid] < gettime()) HideHud(playerid);

    ShowTabBuy(playerid);
    //SCM(playerid, -1, "Аукцион Welsi Studio");

    return 1;
}

stock HideTextDrawAuction(playerid)
{
    ShowHud(playerid);

    default_select_slot(playerid);
    switch(player_info_panel[playerid][select_tab])
    {
        case 1:HideTabBuy(playerid);
        case 2:HideTabSell(playerid);
        case 3:HideTabMy(playerid);
    }

    player_info_panel[playerid][count_list] = 1;
    player_info_panel[playerid][show_panel] = false;
    player_info_panel[playerid][select_slot] = 0;
    player_info_panel[playerid][select_type] = 0;
    player_info_panel[playerid][select_tab] = 0;
    player_info_panel[playerid][filter_min_price] = -1;
    player_info_panel[playerid][filter_max_price] = -1;
    player_info_panel[playerid][filter_vehicle_model] = 0;
    player_info_panel[playerid][filter_tovar_type] = 0;
    player_info_panel[playerid][auction_filter_type] = 0;
    player_info_panel[playerid][type_tovar] = false;
    player_info_panel[playerid][price_tovar] = false;
    player_info_panel[playerid][tovar] = false;
    player_info_panel[playerid][opisanie_tovar] = false;

    TogglePlayerControllable(playerid, true);

    return 1;
}

stock ShowTabBuy(playerid)
{
    new time = gettime();
    if(player_cd_auction[playerid] > time) return SendClientMessage(playerid, -1, "Подождите немного...");

    player_cd_auction[playerid] = time+5;
    switch(player_info_panel[playerid][select_tab])
    {
        case 2:HideTabSell(playerid);
        case 3:HideTabMy(playerid);
        case 1:return 1;
    }

    SelectTextDraw(playerid, -1);

    player_info_panel[playerid][select_tab] = 1;

        //load slot auction

    if(player_info_panel[playerid][select_slot])
    {
        new string[34];
        strcat(string, auction_button[0][0]);

        PlayerTextDrawSetString(playerid, auction_PTD[playerid][6], string);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][10], string);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][14], string);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][18], string);

        player_info_panel[playerid][select_slot] = 0;
    }

    for(new p = 1;p < 6;p++) PlayerTextDrawSetString(playerid, auction_PTD[playerid][p], "-");
    
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][27], "1");
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][0], "txd:braucbuy");

    PlayerTextDrawSetString(playerid, auction_PTD[playerid][23], auction_button[1][1]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][24], auction_button[2][0]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][25], auction_button[3][0]);

    //PlayerTextDrawShow(playerid, auction_PTD[playerid][0]);
    new all_slot = player_info_panel[playerid][count_list]*4 - 1;
    LeafAuction(playerid, all_slot);

    for(new t; t < 39; t++)
    {
        if(28 <= t <= 34) continue;

        PlayerTextDrawShow(playerid, auction_PTD[playerid][t]);
    }

    return 1;
}

stock ShowTabSell(playerid)
{
    new time = gettime();
    if(player_cd_auction[playerid] > time) return SendClientMessage(playerid, -1, "Подождите немного...");

    player_cd_auction[playerid] = time+5;
    switch(player_info_panel[playerid][select_tab])
    {
        case 1:HideTabBuy(playerid);
        case 3:HideTabMy(playerid);
        default:return 1;
    }

    SelectTextDraw(playerid, -1);

    player_info_panel[playerid][select_tab] = 2;
    
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][0], "txd:braucsell");

    PlayerTextDrawSetString(playerid, auction_PTD[playerid][23], auction_button[1][0]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][24], auction_button[2][1]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][25], auction_button[3][0]);


    //PlayerTextDrawSetString(playerid, auction_TD[5]);
    
    for(new p = 1;p < 5;p++) PlayerTextDrawSetString(playerid, auction_PTD[playerid][p], "-");
    PlayerTextDrawColor(playerid, auction_PTD[playerid][3], -1);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][5], "Нет");
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][32], "Нет");

    //PlayerTextDrawShow(playerid, auction_PTD[playerid][0]);

    for(new t; t < 5; t++)
    {
        PlayerTextDrawShow(playerid, auction_PTD[playerid][t]);
    }
    for(new t = 28; t < 33; t++)
    {
        PlayerTextDrawShow(playerid, auction_PTD[playerid][t]);
    }

    PlayerTextDrawShow(playerid, auction_PTD[playerid][22]);

    for(new b = 23;b < 27;b++) // цикл для открытия вкладок
    {
        PlayerTextDrawShow(playerid, auction_PTD[playerid][b]);
    }

    PlayerTextDrawShow(playerid, auction_PTD[playerid][39]);

    return 1;
}

stock HideTabSell(playerid)
{
    CancelSelectTextDraw(playerid);
    player_info_panel[playerid][type_tovar] = false;
    player_info_panel[playerid][price_tovar] = false;
    player_info_panel[playerid][tovar] = false;
    player_info_panel[playerid][opisanie_tovar] = false;

    PlayerTextDrawHide(playerid, auction_PTD[playerid][39]);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][3], -1107374134);

    for(new t; t < 6; t++)
    {
        PlayerTextDrawHide(playerid, auction_PTD[playerid][t]);
    }

    PlayerTextDrawHide(playerid, auction_PTD[playerid][22]);

    for(new t = 28; t < 33; t++)
    {
        PlayerTextDrawHide(playerid, auction_PTD[playerid][t]);
    }

    for(new b = 23;b < 27;b++) // цикл для открытия вкладок
    {
        PlayerTextDrawHide(playerid, auction_PTD[playerid][b]);
    }
    return 1;
}

stock HideTabBuy(playerid)
{
    default_select_slot(playerid);
    CancelSelectTextDraw(playerid);
    player_info_panel[playerid][count_list] = 1;
    player_info_panel[playerid][show_panel] = false;
    player_info_panel[playerid][select_slot] = 0;
    player_info_panel[playerid][select_type] = 0;
    player_info_panel[playerid][select_tab] = 0;
    player_info_panel[playerid][filter_min_price] = -1;
    player_info_panel[playerid][filter_max_price] = -1;

    for(new t = 35; t < 39; t++)
    {
        PlayerTextDrawHide(playerid, auction_PTD[playerid][t]);
    }

    for(new t; t < 28; t++)
    {
        PlayerTextDrawHide(playerid, auction_PTD[playerid][t]);
    }
    return 1;
}

stock HideTabMy(playerid)
{
    CancelSelectTextDraw(playerid);

    PlayerTextDrawDestroy(playerid, auction_PTD[playerid][0]);
    for(new i = 23;i < 27;i++) PlayerTextDrawDestroy(playerid, auction_PTD[playerid][i]);
    
    auction_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 27.3333, 100.2444, "txd:braucbuy"); // фон / основа
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][0], 588.0000, 294.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][0], 0);

    auction_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 43.3333, 125.1333, "txd:braucubuy"); // вклада покупки
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][23], 109.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][23], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][23], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][23], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][23], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][23], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][23], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][23], 1);

    auction_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 43.3333, 170.3481, "txd:braucnusell"); // вкладка продажа
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][24], 109.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][24], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][24], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][24], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][24], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][24], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][24], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][24], 1);

    auction_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 43.6666, 216.8074, "txd:braucnumy"); // вкладка мои
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][25], 109.0000, 61.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][25], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][25], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][25], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][25], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][25], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][25], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][25], 1);

    auction_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 43.3333, 285.6667, "txd:braucexit"); // выйти
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][26], 109.0000, 62.0000);
    PlayerTextDrawAlignment(playerid, auction_PTD[playerid][26], 1);
    PlayerTextDrawColor(playerid, auction_PTD[playerid][26], -1);
    PlayerTextDrawBackgroundColor(playerid, auction_PTD[playerid][26], 255);
    PlayerTextDrawFont(playerid, auction_PTD[playerid][26], 4);
    PlayerTextDrawSetProportional(playerid, auction_PTD[playerid][26], 0);
    PlayerTextDrawSetShadow(playerid, auction_PTD[playerid][26], 0);
    PlayerTextDrawSetSelectable(playerid, auction_PTD[playerid][26], 1);

    PlayerTextDrawHide(playerid, auction_PTD[playerid][0]);

    for(new t = 23; t < 27;t++)
    {
        PlayerTextDrawHide(playerid, auction_PTD[playerid][t]);
    }
    
    PlayerTextDrawHide(playerid, auction_PTD[playerid][33]);
    PlayerTextDrawHide(playerid, auction_PTD[playerid][34]);

    return 1;
}

stock ShowTabMy(playerid)
{
    new time = gettime();
    if(player_cd_auction[playerid] > time) return SendClientMessage(playerid, -1, "Подождите немного...");

    player_cd_auction[playerid] = time+5;
    switch(player_info_panel[playerid][select_tab])
    {
        case 1:HideTabBuy(playerid);
        case 2:HideTabSell(playerid);
        default:return 1;
    }

    SelectTextDraw(playerid, -1);

    player_info_panel[playerid][select_tab] = 3;

    PlayerTextDrawDestroy(playerid, auction_PTD[playerid][0]);
    for(new i = 23;i < 27;i++) PlayerTextDrawDestroy(playerid, auction_PTD[playerid][i]);

    auction_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 83.9999, 103.5629, "txd:braucmy"); // пусто
    PlayerTextDrawTextSize(playerid, auction_PTD[playerid][0], 462.0000, 256.0000);
    PlayerTextDrawAlignment(playerid,auction_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid,auction_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid,auction_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid,auction_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid,auction_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid,auction_PTD[playerid][0], 0);

    auction_PTD[playerid][23] = CreatePlayerTextDraw(playerid,97.3332, 115.5925, "txd:braucnubuy"); // пусто
    PlayerTextDrawTextSize(playerid,auction_PTD[playerid][23], 120.0000, 68.0000);
    PlayerTextDrawAlignment(playerid,auction_PTD[playerid][23], 1);
    PlayerTextDrawColor(playerid,auction_PTD[playerid][23], -1);
    PlayerTextDrawBackgroundColor(playerid,auction_PTD[playerid][23], 255);
    PlayerTextDrawFont(playerid,auction_PTD[playerid][23], 4);
    PlayerTextDrawSetProportional(playerid,auction_PTD[playerid][23], 0);
    PlayerTextDrawSetShadow(playerid,auction_PTD[playerid][23], 0);
    PlayerTextDrawSetSelectable(playerid,auction_PTD[playerid][23], 1);

    auction_PTD[playerid][24] = CreatePlayerTextDraw(playerid,97.6666, 164.5406, "txd:braucnusell"); // пусто
    PlayerTextDrawTextSize(playerid,auction_PTD[playerid][24], 120.0000, 68.0000);
    PlayerTextDrawAlignment(playerid,auction_PTD[playerid][24], 1);
    PlayerTextDrawColor(playerid,auction_PTD[playerid][24], -1);
    PlayerTextDrawBackgroundColor(playerid,auction_PTD[playerid][24], 255);
    PlayerTextDrawFont(playerid,auction_PTD[playerid][24], 4);
    PlayerTextDrawSetProportional(playerid,auction_PTD[playerid][24], 0);
    PlayerTextDrawSetShadow(playerid,auction_PTD[playerid][24], 0);
    PlayerTextDrawSetSelectable(playerid,auction_PTD[playerid][24], 1);

    auction_PTD[playerid][25] = CreatePlayerTextDraw(playerid,97.6666, 213.4888, "txd:braucumy"); // пусто
    PlayerTextDrawTextSize(playerid,auction_PTD[playerid][25], 120.0000, 68.0000);
    PlayerTextDrawAlignment(playerid,auction_PTD[playerid][25], 1);
    PlayerTextDrawColor(playerid,auction_PTD[playerid][25], -1);
    PlayerTextDrawBackgroundColor(playerid,auction_PTD[playerid][25], 255);
    PlayerTextDrawFont(playerid,auction_PTD[playerid][25], 4);
    PlayerTextDrawSetProportional(playerid,auction_PTD[playerid][25], 0);
    PlayerTextDrawSetShadow(playerid,auction_PTD[playerid][25], 0);
    PlayerTextDrawSetSelectable(playerid,auction_PTD[playerid][25], 1);

    auction_PTD[playerid][26] = CreatePlayerTextDraw(playerid,97.6666, 272.3926, "txd:braucexit"); // пусто
    PlayerTextDrawTextSize(playerid,auction_PTD[playerid][26], 120.0000, 62.0000);
    PlayerTextDrawAlignment(playerid,auction_PTD[playerid][26], 1);
    PlayerTextDrawColor(playerid,auction_PTD[playerid][26], -1);
    PlayerTextDrawBackgroundColor(playerid,auction_PTD[playerid][26], 255);
    PlayerTextDrawFont(playerid,auction_PTD[playerid][26], 4);
    PlayerTextDrawSetProportional(playerid,auction_PTD[playerid][26], 0);
    PlayerTextDrawSetShadow(playerid,auction_PTD[playerid][26], 1);
    PlayerTextDrawSetSelectable(playerid,auction_PTD[playerid][26], 1);

    PlayerTextDrawShow(playerid, auction_PTD[playerid][0]);

    for(new t = 23; t < 27;t++)
    {
        PlayerTextDrawShow(playerid, auction_PTD[playerid][t]);
    }

    PlayerTextDrawShow(playerid, auction_PTD[playerid][33]);
    PlayerTextDrawShow(playerid, auction_PTD[playerid][34]);
    
    return 1;
}

public:AuctionUpdate()
{
    if(!load_business_action)
    {
        SetTimer("AuctionUpdate", 1000, true);
        LoadBusinessToAuction();
    } 

    new hour;

    gettime(hour);

    //if(hour >= 22) return 0;

    for(new slot;slot < MAX_AUCTION_SLOT; slot++)
    {
        if(!auction_slot[slot][SLOT_TYPE]) continue;

        if(auction_slot[slot][TIMER_END] <= gettime())
            finish_auction_slot(slot);
    }

    return 1;
}

stock create_auction_slot(playerid, type, opisanie[124], start_rate, data_base, server_id, number_vehicle[7] = "", number_SUM = 0)
{
    new id = -1, bool:stop_create;

    PlayerTextDrawSetString(playerid, auction_PTD[playerid][31], auction_button[6][0]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][30], auction_button[5][0]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][28], auction_button[7][0]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][29], auction_button[4][0]);

    DeletePVar(playerid, "opisanie_param");
    DeletePVar(playerid, "tovar_param_num");
    DeletePVar(playerid, "type_param");
    DeletePVar(playerid, "tovar_param_server");
    DeletePVar(playerid, "price_param");
    DeletePVar(playerid, "tovar_param");
    DeletePVar(playerid, "select_type");
    DeletePVar(playerid, "auction_skin_selected");

    for(new pon = 1; pon < 6;pon++)
    {
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][pon], "-");
    }

    for(new s;s < MAX_AUCTION_SLOT;s++)
    {
        if(auction_slot[s][OWNER_SLOT_SQL] == GetPlayerAccountID(playerid))
        {
            if(auction_slot[s][DATABASE_ID] == data_base && auction_slot[s][SERVER_ID] == server_id)
            {
                if(auction_slot[s][SLOT_TYPE] == type)
                {
                    stop_create = true;
                    break;
                } 
                
            }

            if(auction_slot[s][SLOT_TYPE] == TYPE_VEHICLE_NUMBER)
            {
                if(strfind(number_vehicle, auction_slot[s][NUMBER_VEHICLE], true) != -1)
                {
                    stop_create = true;
                    break;
                }
            }
            
            if(auction_slot[s][SLOT_TYPE] == TYPE_SUM_NUMBER)
            {
                if(auction_slot[s][NUMBER_SUM] == number_SUM)
                {
                    stop_create = true;
                    break;
                }
            }
        }
        
    }

    if(stop_create) return SendClientMessage(playerid, -1, ""USC" Вы уже выставляли данный товар.");

    for(new s; s < MAX_AUCTION_SLOT;s++)
    {
        if(auction_slot[s][SLOT_TYPE] >= 1) continue;
        
        id = s;        
        break;
    }

    if(id == -1) return SendClientMessage(playerid, -1, ""SC" В данный момент достигнут лимит слотов в аукционе.");

    auction_slot[id][OWNER_SLOT_SQL] = GetPlayerAccountID(playerid);
    auction_slot[id][SLOT_TYPE] = type;
    auction_slot[id][START_RATE] = start_rate;
    auction_slot[id][CURRENT_RATE] = start_rate;
    auction_slot[id][DATABASE_ID] = data_base;
    auction_slot[id][SERVER_ID] = server_id;
    format(auction_slot[id][OWNER_SLOT_NAME], 24, "%s", GetPlayerNameEx(playerid));
    format(auction_slot[id][OPISANIE_SLOT], 124, "%s", opisanie);

    // Лот живёт не более трёх часов и не переносится за 23:00 текущего дня.
    new current_hour, current_minute, current_second;
    gettime(current_hour, current_minute, current_second);

    new seconds_until_23 = ((23 - current_hour) * 3600) - (current_minute * 60) - current_second;
    if(seconds_until_23 <= 0 || seconds_until_23 > 10800)
        seconds_until_23 = 10800;

    auction_slot[id][TIMER_END] = gettime() + seconds_until_23;

    switch(type)
    {
        case TYPE_BUSINESS:
        {
            for(new s;s < MAX_BUSINESS;s++)
            {
                if(GetBusinessData(s, B_SQL_ID) == data_base)
                {
                    auction_slot[id][SERVER_ID] = s;
                    format(auction_slot[id][SLOT_NAME], 24, "%s", GetBusinessData(s, B_NAME));
                    break;
                }
            }
        }
        case TYPE_VEHICLE:
        {
            
            new id_model = server_id - 400;

            Auction_FormatDisplayName(GetVehicleInfo(id_model, VI_NAME), auction_slot[id][SLOT_NAME], 24);
            UnloadPlayerOwnableCar(playerid);
        }
        case TYPE_HOUSE:
        {
            for(new s;s < MAX_HOUSES;s++)
            {
                if(GetHouseData(s, H_SQL_ID) == data_base)
                {
                    auction_slot[id][SERVER_ID] = s;
                    format(auction_slot[id][SLOT_NAME], 24, "Дом_(%d)", s);
                    break;
                }
            }
        }
        case TYPE_VEHICLE_NUMBER:
        {
            format(auction_slot[id][SLOT_NAME], 24, "%s", number_vehicle);
            format(auction_slot[id][NUMBER_VEHICLE], 7, "%s", number_vehicle);
        }
        case TYPE_SUM_NUMBER:
        {
            auction_slot[id][NUMBER_SUM] = number_SUM;

            new sum[6];
            valstr(sum, number_SUM);
            format(auction_slot[id][SLOT_NAME], 24, "%s", sum);
        }
        case TYPE_CLOTHES:
        {
            Auction_GetSkinName(server_id, auction_slot[id][SLOT_NAME], 24);

            if(data_base < 0 || data_base >= MAX_INVENTORY_SLOTS ||
                g_PlayerInventory[playerid][data_base][inv_itemId] != AUCTION_SKIN_ITEM_ID ||
                g_PlayerInventory[playerid][data_base][inv_itemCount] != server_id)
            {
                reset_slot_auction(id);
                return SendClientMessage(playerid, -1, ""USC" Одежда уже перемещена или недоступна.");
            }

            // Одежда хранится в аукционном хранилище до завершения лота.
            if(!Inventory_DeleteItemCompletely(playerid, data_base))
            {
                reset_slot_auction(id);
                return SendClientMessage(playerid, -1, ""USC" Не удалось переместить одежду в хранилище.");
            }
        }
    }



    if(!Auction_SaveSlot(id))
    {
        if(type == TYPE_CLOTHES)
            Auction_QueueInventoryItem(GetPlayerAccountID(playerid), AUCTION_SKIN_ITEM_ID, server_id, "");
        reset_slot_auction(id);
        return SendClientMessage(playerid, -1, ""USC" Не удалось сохранить лот. Имущество возвращено.");
    }

    SendClientMessage(playerid, -1, ""SC" Вы выставили слот на аукцион");

    return 1;
}

stock finish_auction_slot(slot)
{
    if(slot < 0 || slot >= MAX_AUCTION_SLOT || !auction_slot[slot][SLOT_TYPE]) return 0;

    new seller = auction_slot[slot][OWNER_SLOT_SQL];
    new winner = auction_slot[slot][OWNER_RATE];
    new price = auction_slot[slot][CURRENT_RATE];
    new type = auction_slot[slot][SLOT_TYPE];

    if(winner <= 0)
    {
        if(!Auction_ReturnUnsoldAsset(slot))
        {
            printf("[AUCTION] failed to return unsold asset slot=%d", slot);
            return 0;
        }

        new seller_player = Auction_FindOnlineAccount(seller);
        if(seller_player != INVALID_PLAYER_ID)
            SendClientMessage(seller_player, -1, ""USC" Аукцион завершён без ставок. Лот снят с продажи.");

        reset_slot_auction(slot);
        return 1;
    }

    if(!Auction_ValidateAsset(slot))
    {
        Auction_CancelSlot(slot, ""USC" Имущество лота больше не принадлежит продавцу. Лот отменён.");
        return 0;
    }

    new bool:transferred;
    new query[512];

    switch(type)
    {
        case TYPE_BUSINESS:
        {
            transferred = bool:AuctionBusiness(winner, slot);
        }
        case TYPE_HOUSE:
        {
            transferred = bool:AuctionHouse(slot, winner, auction_slot[slot][SERVER_ID]);
        }
        case TYPE_VEHICLE:
        {
            mysql_format(mysql, query, sizeof query,
                "UPDATE `ownable_cars` SET `owner_id`=%d WHERE `id`=%d AND `owner_id`=%d LIMIT 1",
                winner,
                auction_slot[slot][DATABASE_ID],
                seller
            );
            new Cache:result = mysql_query(mysql, query, true);
            transferred = (!mysql_errno() && cache_affected_rows(mysql) == 1);
            cache_delete(result);
        }
        case TYPE_VEHICLE_NUMBER:
        {
            mysql_format(mysql, query, sizeof query,
                "SELECT `id` FROM `ownable_cars` WHERE `owner_id`=%d AND `number`='------' LIMIT 1",
                winner
            );
            new Cache:result = mysql_query(mysql, query, true);
            if(!mysql_errno() && cache_num_rows())
            {
                new winner_car_id = cache_get_field_content_int(0, "id");
                cache_delete(result);

                mysql_query(mysql, "START TRANSACTION", false);

                mysql_format(mysql, query, sizeof query,
                    "UPDATE `ownable_cars` SET `number`='------' WHERE `id`=%d AND `owner_id`=%d AND `number`='%e' LIMIT 1",
                    auction_slot[slot][DATABASE_ID], seller, auction_slot[slot][NUMBER_VEHICLE]
                );
                new Cache:release_result = mysql_query(mysql, query, true);
                new released = (!mysql_errno() && cache_affected_rows(mysql) == 1);
                cache_delete(release_result);

                if(released)
                {
                    mysql_format(mysql, query, sizeof query,
                        "UPDATE `ownable_cars` SET `number`='%e' WHERE `id`=%d AND `owner_id`=%d AND `number`='------' LIMIT 1",
                        auction_slot[slot][NUMBER_VEHICLE], winner_car_id, winner
                    );
                    new Cache:assign_result = mysql_query(mysql, query, true);
                    transferred = (!mysql_errno() && cache_affected_rows(mysql) == 1);
                    cache_delete(assign_result);
                }

                if(!released || !transferred || mysql_errno())
                {
                    mysql_query(mysql, "ROLLBACK", false);
                    transferred = false;
                }
                else
                {
                    mysql_query(mysql, "COMMIT", false);
                }
            }
            else
            {
                cache_delete(result);
                transferred = false;
            }
        }
        case TYPE_SUM_NUMBER:
        {
            mysql_query(mysql, "START TRANSACTION", false);

            mysql_format(mysql, query, sizeof query,
                "UPDATE `accounts` SET `phone`=0 WHERE `id`=%d AND `phone`=%d LIMIT 1",
                seller, auction_slot[slot][NUMBER_SUM]
            );
            new Cache:seller_result = mysql_query(mysql, query, true);
            new seller_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
            cache_delete(seller_result);

            if(seller_changed)
            {
                mysql_format(mysql, query, sizeof query,
                    "UPDATE `accounts` SET `phone`=%d WHERE `id`=%d LIMIT 1",
                    auction_slot[slot][NUMBER_SUM], winner
                );
                new Cache:winner_result = mysql_query(mysql, query, true);
                transferred = (!mysql_errno() && cache_affected_rows(mysql) == 1);
                cache_delete(winner_result);
            }

            if(!seller_changed || !transferred || mysql_errno())
            {
                mysql_query(mysql, "ROLLBACK", false);
                transferred = false;
            }
            else
            {
                mysql_query(mysql, "COMMIT", false);

                new seller_player = Auction_FindOnlineAccount(seller);
                if(seller_player != INVALID_PLAYER_ID) SetPlayerData(seller_player, P_PHONE, 0);

                new winner_player = Auction_FindOnlineAccount(winner);
                if(winner_player != INVALID_PLAYER_ID) SetPlayerData(winner_player, P_PHONE, auction_slot[slot][NUMBER_SUM]);
            }
        }
        case TYPE_CLOTHES:
        {
            transferred = bool:Auction_QueueInventoryItem(winner, AUCTION_SKIN_ITEM_ID, auction_slot[slot][SERVER_ID], "");
        }
    }

    if(!transferred)
    {
        Auction_CancelSlot(slot, ""USC" Передача имущества не выполнена. Лот отменён, ставка возвращена.");
        return 0;
    }

    new seller_payment_ok = Auction_PaySeller(seller, price);
    if(!seller_payment_ok)
    {
        // Имущество уже передано победителю. Не запускаем повторную передачу лота:
        // фиксируем критическую ошибку и завершаем слот без возврата ставки покупателю.
        printf("[AUCTION] CRITICAL seller payment failed account=%d amount=%d slot=%d", seller, price, slot);
    }

    new winner_player = Auction_FindOnlineAccount(winner);
    if(winner_player != INVALID_PLAYER_ID)
        SendClientMessage(winner_player, -1, ""SC" Вы выиграли лот. Имущество передано Вам.");

    new seller_player = Auction_FindOnlineAccount(seller);
    if(seller_player != INVALID_PLAYER_ID)
    {
        if(seller_payment_ok)
            SendClientMessage(seller_player, -1, ""SC" Ваш лот продан на аукционе.");
        else
            SendClientMessage(seller_player, 0xFF6347FF, "[Аукцион] Лот передан покупателю, но выплата не записалась. Сообщите администрации.");
    }

    reset_slot_auction(slot);
    return 1;
}

stock reset_slot_auction(slot)
{
    if(slot < 0 || slot >= MAX_AUCTION_SLOT) return 0;
    if(auction_slot[slot][SLOT_TYPE])
        Auction_DeleteSlot(slot);

    auction_slot[slot][SLOT_TYPE] = 0;
    auction_slot[slot][OWNER_SLOT_SQL] = -1;
    format(auction_slot[slot][OWNER_SLOT_NAME], 24, "-");
    format(auction_slot[slot][SLOT_NAME], 32, "-");
    format(auction_slot[slot][OPISANIE_SLOT], 124, "-");
    format(auction_slot[slot][NUMBER_VEHICLE], 7, "-");
    auction_slot[slot][OWNER_RATE] = -1;
    auction_slot[slot][START_RATE] = 0;
    auction_slot[slot][CURRENT_RATE] = 0;
    auction_slot[slot][TIMER_END] = 0;
    auction_slot[slot][DATABASE_ID] = -1;
    auction_slot[slot][SERVER_ID] = -1;
    auction_slot[slot][NUMBER_SUM] = 0;
    
    return 1;
}

stock AuctionBusiness(sql_id, slot)
{
    new businessid = auction_slot[slot][SERVER_ID];
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "SELECT `business`,`name` FROM `accounts` WHERE `id`=%d LIMIT 1",
        sql_id
    );
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno() || !cache_num_rows())
    {
        cache_delete(result);
        return 0;
    }

    new current_business = cache_get_field_content_int(0, "business");
    new owner_name[24];
    cache_get_field_content(0, "name", owner_name, mysql, sizeof owner_name);
    cache_delete(result);

    if(current_business != -1) return 0;

    new rent_time = (gettime() - (gettime() % 86400)) + 86400;
    new expected_owner = auction_slot[slot][OWNER_SLOT_SQL] == -2 ? 0 : auction_slot[slot][OWNER_SLOT_SQL];
    mysql_query(mysql, "START TRANSACTION", false);

    if(auction_slot[slot][OWNER_SLOT_SQL] > 0)
    {
        mysql_format(mysql, query, sizeof query,
            "UPDATE `accounts` SET `business`=-1 WHERE `id`=%d AND `business`=%d LIMIT 1",
            auction_slot[slot][OWNER_SLOT_SQL], businessid
        );
        mysql_query(mysql, query, false);
    }

    if(!mysql_errno())
    {
        mysql_format(mysql, query, sizeof query,
            "UPDATE `accounts` SET `business`=%d WHERE `id`=%d AND `business`=-1 LIMIT 1",
            businessid, sql_id
        );
        new Cache:account_result = mysql_query(mysql, query, true);
        new account_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
        cache_delete(account_result);
        if(!account_changed)
        {
            mysql_query(mysql, "ROLLBACK", false);
            return 0;
        }
    }

    if(!mysql_errno())
    {
        mysql_format(mysql, query, sizeof query,
            "UPDATE `business` SET `owner_id`=%d,`improvements`=0,`products`=20,`prod_price`=0,`balance`=0,`rent_time`=%d,`lock`=0 WHERE `id`=%d AND `owner_id`=%d LIMIT 1",
            sql_id, rent_time, GetBusinessData(businessid, B_SQL_ID), expected_owner
        );
        new Cache:business_result = mysql_query(mysql, query, true);
        new business_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
        cache_delete(business_result);
        if(!business_changed)
        {
            mysql_query(mysql, "ROLLBACK", false);
            return 0;
        }
    }

    if(mysql_errno())
    {
        mysql_query(mysql, "ROLLBACK", false);
        return 0;
    }
    mysql_query(mysql, "COMMIT", false);

    new seller_player = Auction_FindOnlineAccount(auction_slot[slot][OWNER_SLOT_SQL]);
    if(seller_player != INVALID_PLAYER_ID) SetPlayerData(seller_player, P_BUSINESS, -1);

    new winner_player = Auction_FindOnlineAccount(sql_id);
    if(winner_player != INVALID_PLAYER_ID)
    {
        SetPlayerData(winner_player, P_BUSINESS, businessid);
        SendClientMessage(winner_player, 0x66CC00FF, "Напишите {0099FF}/business {66CC00}чтобы узнать о возможностях");
    }

    SetBusinessData(businessid, B_OWNER_ID, sql_id);
    SetBusinessData(businessid, B_IMPROVEMENTS, 0);
    SetBusinessData(businessid, B_PRODS, 20);
    SetBusinessData(businessid, B_PROD_PRICE, 0);
    SetBusinessData(businessid, B_ENTER_MUSIC, 0);
    SetBusinessData(businessid, B_ENTER_PRICE, 0);
    SetBusinessData(businessid, B_BALANCE, 0);
    SetBusinessData(businessid, B_RENT_DATE, rent_time);
    SetBusinessData(businessid, B_LOCK_STATUS, false);
    format(g_business[businessid][B_OWNER_NAME], 21, "%s", owner_name);
    CallLocalFunction("UpdateBusinessLabel", "i", businessid);
    BusinessHealthPickupInit(businessid);

    mysql_format(mysql, query, sizeof query, "DELETE FROM `business_gps` WHERE `bid`=%d", businessid);
    mysql_query(mysql, query, false);
    g_business_gps_init = false;

    mysql_format(mysql, query, sizeof query,
        "UPDATE `business_profit` SET `view`=0 WHERE `bid`=%d AND `view`=1",
        GetBusinessData(businessid, B_SQL_ID)
    );
    mysql_query(mysql, query, false);
    return 1;
}

public:LoadBusinessToAuction()
{
    load_business_action = true;

    new Cache:result = mysql_query(mysql, "SELECT `id`,`name`,`price` FROM `business` WHERE `owner_id`=0", true);
    if(mysql_errno())
    {
        cache_delete(result);
        load_business_action = false;
        print("[AUCTION] failed to load state businesses; retry scheduled");
        return 0;
    }

    new rows = cache_num_rows();
    new loaded;
    for(new row; row < rows; row++)
    {
        new database_id = cache_get_field_content_int(row, "id");
        new bool:already_loaded;

        for(new existing; existing < MAX_AUCTION_SLOT; existing++)
        {
            if(auction_slot[existing][SLOT_TYPE] == TYPE_BUSINESS &&
               auction_slot[existing][DATABASE_ID] == database_id)
            {
                already_loaded = true;
                break;
            }
        }
        if(already_loaded) continue;

        new free_slot = -1;
        for(new slot; slot < MAX_AUCTION_SLOT; slot++)
        {
            if(!auction_slot[slot][SLOT_TYPE])
            {
                free_slot = slot;
                break;
            }
        }
        if(free_slot == -1) break;

        new businessid = -1;
        for(new idx; idx < MAX_BUSINESS; idx++)
        {
            if(GetBusinessData(idx, B_SQL_ID) == database_id)
            {
                businessid = idx;
                break;
            }
        }
        if(businessid == -1) continue;

        auction_slot[free_slot][SLOT_TYPE] = TYPE_BUSINESS;
        auction_slot[free_slot][OWNER_SLOT_SQL] = -2;
        auction_slot[free_slot][OWNER_RATE] = -1;
        format(auction_slot[free_slot][OWNER_SLOT_NAME], 24, "Государство");
        cache_get_field_content(row, "name", auction_slot[free_slot][SLOT_NAME], mysql, 24);
        auction_slot[free_slot][DATABASE_ID] = database_id;
        auction_slot[free_slot][SERVER_ID] = businessid;
        auction_slot[free_slot][START_RATE] = cache_get_field_content_int(row, "price");
        auction_slot[free_slot][CURRENT_RATE] = auction_slot[free_slot][START_RATE];
        format(auction_slot[free_slot][OPISANIE_SLOT], 124, "Государственный бизнес (%d)", businessid);

        new hours, minutes, seconds;
        gettime(hours, minutes, seconds);
        new seconds_to_close = ((21 - hours) * 3600) + ((59 - minutes) * 60) + (59 - seconds) - 10;
        if(seconds_to_close <= 3600) seconds_to_close = 1800;
        auction_slot[free_slot][TIMER_END] = gettime() + seconds_to_close;

        if(Auction_SaveSlot(free_slot)) loaded++;
        else reset_slot_auction(free_slot);
    }
    cache_delete(result);

    printf("[AUCTION] state businesses loaded=%d", loaded);
    return 1;
}

stock defualt_slot()
{
    for(new WELSI; WELSI < MAX_AUCTION_SLOT; WELSI++)
    {
        auction_slot[WELSI][SLOT_TYPE] = 0;
        auction_slot[WELSI][OWNER_SLOT_SQL] = -1;
        format(auction_slot[WELSI][OWNER_SLOT_NAME], 24, "-");
        format(auction_slot[WELSI][SLOT_NAME], 24, "-");
        format(auction_slot[WELSI][OPISANIE_SLOT], 124, "-");
        format(auction_slot[WELSI][NUMBER_VEHICLE], 7 , "-");
        auction_slot[WELSI][OWNER_RATE] = -1;
        auction_slot[WELSI][START_RATE] = 0;
        auction_slot[WELSI][CURRENT_RATE] = 0;
        auction_slot[WELSI][TIMER_END] = 0;
        auction_slot[WELSI][DATABASE_ID] = 0;
        auction_slot[WELSI][SERVER_ID] = 0;
        auction_slot[WELSI][NUMBER_SUM] = 0;
    }
}

stock AuctionHouse(slot, win_slot, houseid)
{
    if(houseid < 0 || houseid >= MAX_HOUSES) return 0;

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "SELECT `house`,`name` FROM `accounts` WHERE `id`=%d LIMIT 1",
        win_slot
    );
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno() || !cache_num_rows())
    {
        cache_delete(result);
        return 0;
    }

    new current_house = cache_get_field_content_int(0, "house");
    new owner_name[24];
    cache_get_field_content(0, "name", owner_name, mysql, sizeof owner_name);
    cache_delete(result);

    if(current_house != -1) return 0;

    new rent_time = (gettime() - (gettime() % 86400)) + 86400;
    mysql_query(mysql, "START TRANSACTION", false);

    mysql_format(mysql, query, sizeof query,
        "UPDATE `accounts` SET `house_type`=-1,`house_room`=-1,`house`=-1 WHERE `id`=%d AND `house`=%d LIMIT 1",
        auction_slot[slot][OWNER_SLOT_SQL], houseid
    );
    mysql_query(mysql, query, false);

    if(!mysql_errno())
    {
        mysql_format(mysql, query, sizeof query,
            "UPDATE `accounts` SET `house_type`=%d,`house_room`=-1,`house`=%d WHERE `id`=%d AND `house`=-1 LIMIT 1",
            HOUSE_TYPE_HOME, houseid, win_slot
        );
        new Cache:account_result = mysql_query(mysql, query, true);
        new account_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
        cache_delete(account_result);
        if(!account_changed)
        {
            mysql_query(mysql, "ROLLBACK", false);
            return 0;
        }
    }

    if(!mysql_errno())
    {
        mysql_format(mysql, query, sizeof query,
            "UPDATE `houses` SET `owner_id`=%d,`improvements`=0,`rent_time`=%d,`lock`=0,`store_x`=0.0,`store_y`=0.0,`store_z`=0.0 WHERE `id`=%d AND `owner_id`=%d LIMIT 1",
            win_slot, rent_time, GetHouseData(houseid, H_SQL_ID), auction_slot[slot][OWNER_SLOT_SQL]
        );
        new Cache:house_result = mysql_query(mysql, query, true);
        new house_changed = (!mysql_errno() && cache_affected_rows(mysql) == 1);
        cache_delete(house_result);
        if(!house_changed)
        {
            mysql_query(mysql, "ROLLBACK", false);
            return 0;
        }
    }

    if(mysql_errno())
    {
        mysql_query(mysql, "ROLLBACK", false);
        return 0;
    }
    mysql_query(mysql, "COMMIT", false);

    CallLocalFunction("EvictHouseRentersAll", "i", houseid);

    new seller_player = Auction_FindOnlineAccount(auction_slot[slot][OWNER_SLOT_SQL]);
    if(seller_player != INVALID_PLAYER_ID)
    {
        SetPlayerData(seller_player, P_HOUSE, -1);
        SetPlayerData(seller_player, P_HOUSE_TYPE, -1);
    }

    new winner_player = Auction_FindOnlineAccount(win_slot);
    if(winner_player != INVALID_PLAYER_ID)
    {
        SetPlayerData(winner_player, P_HOUSE, houseid);
        SetPlayerData(winner_player, P_HOUSE_TYPE, HOUSE_TYPE_HOME);
    }

    SetHouseData(houseid, H_OWNER_ID, win_slot);
    SetHouseData(houseid, H_IMPROVEMENTS, 0);
    SetHouseData(houseid, H_STORE_X, 0.0);
    SetHouseData(houseid, H_STORE_Y, 0.0);
    SetHouseData(houseid, H_STORE_Z, 0.0);
    SetHouseData(houseid, H_RENT_DATE, rent_time);
    SetHouseData(houseid, H_LOCK_STATUS, false);
    format(g_house[houseid][H_OWNER_NAME], 21, "%s", owner_name);

    new entranceid = GetHouseData(houseid, H_ENTRACE);
    if(entranceid != -1)
        CallLocalFunction("EntranceStatusInit", "i", entranceid);

    UpdateHouse(houseid);
    HouseHealthInit(houseid);
    HouseStoreInit(houseid);
    return 1;
}

stock LeafAuction(playerid, all_slot)
{
    for(new p;p < 4;p++) player_show_slot[playerid][p] = -1;

    for(new td; td < 4; td++)
    {
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][0]], "-");
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][1]], "-");
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][2]], "-");
    }

    for(new i = 1; i < 6;i++ ) PlayerTextDrawSetString(playerid, auction_PTD[playerid][i], "-");

    default_select_slot(playerid);

    player_info_panel[playerid][select_slot] = 0;

    for(new i;i < 4;i++) player_show_slot[playerid][i] = -1;
    
    new string[9];
    valstr(string, player_info_panel[playerid][count_list]);
    PlayerTextDrawSetString(playerid, auction_PTD[playerid][27], string);

    new active_slot_id[MAX_AUCTION_SLOT], slot = -1, filter = player_info_panel[playerid][auction_filter_type], 
    tovar_type = player_info_panel[playerid][filter_tovar_type];

    for(new c;c < MAX_AUCTION_SLOT;c++)
    {
        if(!auction_slot[c][SLOT_TYPE]) continue;

        switch(filter)
        {
            case 1:
            {
                switch(tovar_type)
                {
                    case TYPE_VEHICLE: if(auction_slot[c][SERVER_ID] != player_info_panel[playerid][filter_vehicle_model] && auction_slot[c][SLOT_TYPE] != TYPE_VEHICLE) continue;
                    case TYPE_BUSINESS: if(auction_slot[c][SLOT_TYPE] != TYPE_BUSINESS) continue;
                    case TYPE_HOUSE: if(auction_slot[c][SLOT_TYPE] != TYPE_HOUSE) continue;
                    case TYPE_VEHICLE_NUMBER: if(auction_slot[c][SLOT_TYPE] != TYPE_VEHICLE_NUMBER) continue;
                    case TYPE_SUM_NUMBER: if(auction_slot[c][SLOT_TYPE] != TYPE_SUM_NUMBER) continue;
                    case TYPE_CLOTHES: if(auction_slot[c][SLOT_TYPE] != TYPE_CLOTHES) continue;
                }
            }
            case 2:
            {
                if(auction_slot[c][CURRENT_RATE] < player_info_panel[playerid][filter_min_price]) continue;
                else if(auction_slot[c][CURRENT_RATE] > player_info_panel[playerid][filter_max_price]) continue;
            }
        }
    
        slot++;

        active_slot_id[slot] = c;
        
        if(slot == all_slot - 3) player_show_slot[playerid][0] = active_slot_id[slot];
        if(slot == all_slot - 2) player_show_slot[playerid][1] = active_slot_id[slot];
        if(slot == all_slot - 1) player_show_slot[playerid][2] = active_slot_id[slot];
        if(slot == all_slot)
        {
            player_show_slot[playerid][3] = active_slot_id[slot];
            break;
        }
    }

    for(new td; td < 4; td++)
    {
        if(player_show_slot[playerid][td] == -1) continue;
        
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][0]], auction_slot[player_show_slot[playerid][td]][OWNER_SLOT_NAME]);
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][1]], auction_slot[player_show_slot[playerid][td]][SLOT_NAME]);
        valstr(string, auction_slot[player_show_slot[playerid][td]][CURRENT_RATE]);
        
        PlayerTextDrawSetString(playerid, auction_PTD[playerid][slot_td[td][2]], string);
    }
}

stock Auction_FormatDisplayName(const input[], output[], size)
{
    if(size <= 0) return 0;

    format(output, size, "%s", input);
    for(new index; output[index] != EOS && index < size - 1; index++)
    {
        if(output[index] == ' ') output[index] = '_';
    }
    return 1;
}
