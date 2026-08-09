#if defined _market_included
    #endinput
#endif
#define _market_included

#define MARKET_GUI_ID               (77)
#define MARKET_PAGE_SIZE            (8)
#define MARKET_MIN_PRICE            (100)
#define MARKET_MAX_PRICE            (999999999)
#define MARKET_LISTING_LIFETIME     (604800)

#define MARKET_TAB_PROFILE          (1)
#define MARKET_TAB_MAIN             (2)
#define MARKET_TAB_HISTORY          (3)
#define MARKET_TAB_FAVORITES        (4)
#define MARKET_TAB_MY_STORE         (5)
#define MARKET_TAB_INVENTORY        (6)

#define MARKET_ACTIVE_SLOT_BASE      (1000)

#define MARKET_TYPE_MATERIAL        (1)
#define MARKET_TYPE_ACCESSORY       (2)
#define MARKET_TYPE_SKIN            (3)
#define MARKET_TYPE_OTHER           MARKET_TYPE_MATERIAL

#define MARKET_HISTORY_BUY          (1)
#define MARKET_HISTORY_SELL         (2)
#define MARKET_NOTIFICATION_HOT     (1)
#define MARKET_NOTIFICATION_NONE    (0)

#define MARKET_VIP_PRICE            (2000000)
#define MARKET_VIP_DAYS             (30)
#define MARKET_VIP_TYPE             (3)

#define MARKET_TEST_SKIN_LISTING_ID (77000002)
#define MARKET_TEST_SKIN_MODEL      (89)
#define MARKET_TEST_SKIN_PRICE      (10000000)

new g_MarketSelectedSlot[MAX_PLAYERS] = {-1, ...};
new g_MarketSelectedListing[MAX_PLAYERS] = {-1, ...};
new g_MarketCurrentTab[MAX_PLAYERS] = {MARKET_TAB_MAIN, ...};
new g_MarketCurrentPage[MAX_PLAYERS] = {1, ...};
new g_MarketSort[MAX_PLAYERS];
new g_MarketSearch[MAX_PLAYERS][32];
new bool:g_MarketOpenPacket[MAX_PLAYERS];

stock Marketplace_Init()
{
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `marketplace_items` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `seller_id` INT NOT NULL, `seller_name` VARCHAR(24) NOT NULL DEFAULT '', `item_id` INT NOT NULL, `item_count` INT NOT NULL DEFAULT 1, `item_name` VARCHAR(64) NOT NULL DEFAULT '', `price` INT NOT NULL, `is_hot` TINYINT(1) NOT NULL DEFAULT 0, `status` TINYINT(1) NOT NULL DEFAULT 0, `buyer_id` INT NOT NULL DEFAULT 0, `buyer_name` VARCHAR(24) NOT NULL DEFAULT '', `created_at` INT NOT NULL DEFAULT 0, `expires_at` INT NOT NULL DEFAULT 0, `sold_at` INT NOT NULL DEFAULT 0, KEY `status` (`status`), KEY `seller_id` (`seller_id`), KEY `buyer_id` (`buyer_id`), KEY `item_id` (`item_id`), KEY `price` (`price`), KEY `created_at` (`created_at`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci", "", "");
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `marketplace_likes` (`player_id` INT NOT NULL, `listing_id` INT NOT NULL, `created_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`player_id`, `listing_id`), KEY `listing_id` (`listing_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci", "", "");
    return 1;
}

stock Market_ResetPlayer(playerid)
{
    g_MarketSelectedSlot[playerid] = -1;
    g_MarketSelectedListing[playerid] = -1;
    g_MarketCurrentTab[playerid] = MARKET_TAB_MAIN;
    g_MarketCurrentPage[playerid] = 1;
    g_MarketSort[playerid] = 0;
    g_MarketSearch[playerid][0] = EOS;
    return 1;
}

stock Market_GetAccessoryIdByItem(itemid)
{
    return Accessory_GetAccessoryIdByInventoryItemId(itemid);
}

stock bool:Market_IsAccessoryItem(itemid)
{
    if(itemid <= 0) return false;
    if(GetItemType(itemid) == ITEM_TYPE_ACCESSORY) return true;
    return (Market_GetAccessoryIdByItem(itemid) >= 0);
}

stock bool:Market_IsSellableItem(itemid)
{
    if(itemid == 134) return true;
    if(Market_IsAccessoryItem(itemid)) return true;
    return false;
}

stock Market_GetProductType(itemid)
{
    if(itemid == 134) return MARKET_TYPE_SKIN;
    if(Market_IsAccessoryItem(itemid)) return MARKET_TYPE_ACCESSORY;
    return MARKET_TYPE_MATERIAL;
}

stock bool:Market_IsActiveSource(sourceId)
{
    return (sourceId >= MARKET_ACTIVE_SLOT_BASE && sourceId < MARKET_ACTIVE_SLOT_BASE + MAX_ACTIVE_SLOTS);
}

stock Market_SourceToActiveSlot(sourceId)
{
    return sourceId - MARKET_ACTIVE_SLOT_BASE;
}

stock bool:Market_GetSourceItem(playerid, sourceId, &itemid, &itemCount)
{
    if(Market_IsActiveSource(sourceId))
    {
        new activeSlot = Market_SourceToActiveSlot(sourceId);
        if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return false;
        itemid = g_PlayerActiveSlots[playerid][activeSlot][inv_itemId];
        itemCount = g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount];
        return Market_IsSellableItem(itemid);
    }

    if(sourceId < 0 || sourceId >= MAX_INVENTORY_SLOTS) return false;
    itemid = g_PlayerInventory[playerid][sourceId][inv_itemId];
    itemCount = g_PlayerInventory[playerid][sourceId][inv_itemCount];
    return Market_IsSellableItem(itemid);
}

stock bool:Market_RemoveSourceItem(playerid, sourceId)
{
    if(Market_IsActiveSource(sourceId))
    {
        new activeSlot = Market_SourceToActiveSlot(sourceId);
        if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return false;

        new itemid = g_PlayerActiveSlots[playerid][activeSlot][inv_itemId];
        if(!Market_IsSellableItem(itemid)) return false;

        if(Market_IsAccessoryItem(itemid))
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, activeSlot)) RemovePlayerAttachedObject(playerid, activeSlot);
            Inventory_ClearActiveSlot(playerid, activeSlot);
            Accessory_SaveAllSlots(playerid);
            return true;
        }

        if(itemid == 134 && activeSlot == SLOT_SKIN)
        {
            Inventory_ClearActiveSlot(playerid, activeSlot);
            Player[playerid][pSkin] = 78;
            SetPlayerSkin(playerid, Player[playerid][pSkin]);
            SavePlayerAccount(playerid);
            return true;
        }

        return false;
    }

    if(sourceId < 0 || sourceId >= MAX_INVENTORY_SLOTS) return false;
    return Inventory_DeleteSlot(playerid, sourceId) ? true : false;
}

stock Market_GetRarity(itemid, price)
{
    if(itemid == 134) return 3;
    if(price >= 10000000) return 5;
    if(price >= 5000000) return 4;
    if(price >= 1000000) return 3;
    if(price >= 300000) return 2;
    return 1;
}

stock Market_GetItemNameByData(itemid, count, name[], len)
{
    if(itemid == 134)
    {
        format(name, len, "Скин #%d", count);
        return 1;
    }

    if(Market_IsAccessoryItem(itemid))
    {
        new acs = Market_GetAccessoryIdByItem(itemid);
        if(Accessory_GetName(acs, name, len)) return 1;

        format(name, len, "Аксессуар #%d", itemid);
        return 1;
    }

    format(name, len, "Предмет #%d", itemid);
    return 1;
}

stock Market_GetItemNameFromSlot(playerid, slot, name[], len)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    return Market_GetItemNameByData(g_PlayerInventory[playerid][slot][inv_itemId], g_PlayerInventory[playerid][slot][inv_itemCount], name, len);
}

stock Market_FindOnlineBySqlId(sqlid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && Player[i][pID] == sqlid) return i;
    }
    return INVALID_PLAYER_ID;
}

stock Market_GetActiveLotsCount(playerid)
{
    new query[160];
    mysql_format(db_handle, query, sizeof(query), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE `seller_id`=%d AND `status`=0 AND (`expires_at`=0 OR `expires_at`>%d)", Player[playerid][pID], gettime());
    new Cache:result = mysql_query(db_handle, query);
    new count = 0;
    if(cache_num_rows() > 0) count = cache_get_field_content_int(0, "cnt", db_handle);
    cache_delete(result);
    return count;
}

stock Market_GetSoldLotsCount(playerid)
{
    new query[160];
    mysql_format(db_handle, query, sizeof(query), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE `seller_id`=%d AND `status`=1", Player[playerid][pID]);
    new Cache:result = mysql_query(db_handle, query);
    new count = 0;
    if(cache_num_rows() > 0) count = cache_get_field_content_int(0, "cnt", db_handle);
    cache_delete(result);
    return count;
}

stock Market_GetAllRevenue(playerid)
{
    new query[160];
    mysql_format(db_handle, query, sizeof(query), "SELECT SUM(`price`) AS `summa` FROM `marketplace_items` WHERE `seller_id`=%d AND `status`=1", Player[playerid][pID]);
    new Cache:result = mysql_query(db_handle, query);
    new money = 0;
    if(cache_num_rows() > 0) money = cache_get_field_content_int(0, "summa", db_handle);
    cache_delete(result);
    return money;
}

stock Market_SendRaw(playerid, Node:json)
{
    if(g_MarketOpenPacket[playerid])
    {
        g_MarketOpenPacket[playerid] = false;
        JSON_SetInt(json, "o", 1);
        ShowPlayerGUI(playerid, MARKET_GUI_ID, json);
    }
    else
    {
        OnPacketIncoming(playerid, MARKET_GUI_ID, json);
    }

    JSON_Cleanup(json);
    return 1;
}


stock Market_GetVipTypeForGui(playerid)
{
    new vip = Player[playerid][pVipType];
    if(vip < 0) vip = 0;
    if(vip > MARKET_VIP_TYPE) vip = MARKET_VIP_TYPE;
    return vip;
}

stock Market_SendError(playerid, responseType, text[])
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", responseType);
    JSON_SetInt(json, "err", 0);
    JSON_SetString(json, "dm", text);
    Market_SendRaw(playerid, json);
    ShowNotification(playerid, 0, 5, 0, 0, text, "");
    return 1;
}


stock Market_SetCommonPacketInfo(playerid, Node:json, page, pages)
{
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "ls", pages);
    JSON_SetInt(json, "lt", page);
    JSON_SetInt(json, "v", Market_GetVipTypeForGui(playerid));
    JSON_SetInt(json, "vm", MARKET_VIP_PRICE);
    JSON_SetInt(json, "lp", Market_GetActiveLotsCount(playerid));
    JSON_SetInt(json, "lh", Market_GetSoldLotsCount(playerid));
    return 1;
}

stock Market_FillTestSkinNode(Node:obj)
{
    JSON_SetInt(obj, "id", MARKET_TEST_SKIN_LISTING_ID);
    JSON_SetInt(obj, "tp", MARKET_NOTIFICATION_HOT);
    JSON_SetInt(obj, "md", 134);
    JSON_SetInt(obj, "ct", MARKET_TEST_SKIN_MODEL);
    JSON_SetInt(obj, "cs", MARKET_TEST_SKIN_PRICE);
    JSON_SetInt(obj, "tm", gettime());
    JSON_SetInt(obj, "ti", MARKET_LISTING_LIFETIME);
    JSON_SetInt(obj, "rt", 5);
    JSON_SetInt(obj, "r", 5);
    JSON_SetInt(obj, "pt", MARKET_TYPE_SKIN);
    JSON_SetInt(obj, "l", 0);
    JSON_SetString(obj, "dm", "Тестовый скин #89");
    JSON_SetString(obj, "nm", "Market");
    JSON_SetString(obj, "sl", "Market");
    JSON_SetInt(obj, "sid", 0);
    return 1;
}

stock Node:Market_AppendTestSkinNode(Node:array)
{
    new Node:item = JSON_Object();
    Market_FillTestSkinNode(item);
    return JSON_Append(array, item);
}

stock Market_InsertListing(playerid, itemid, itemCount, price, hot, itemName[])
{
    new query[512];
    new now = gettime();
    mysql_format(db_handle, query, sizeof(query), "INSERT INTO `marketplace_items` (`seller_id`,`seller_name`,`item_id`,`item_count`,`item_name`,`price`,`is_hot`,`status`,`created_at`,`expires_at`) VALUES (%d,'%e',%d,%d,'%e',%d,%d,0,%d,%d)", Player[playerid][pID], Player[playerid][pName], itemid, itemCount, itemName, price, hot ? 1 : 0, now, 0);

    new Cache:result = mysql_query(db_handle, query);
    new listingId = 0;
    if(cache_affected_rows(db_handle) > 0) listingId = cache_insert_id(db_handle);
    cache_delete(result);
    return listingId;
}

stock bool:Market_ResolveCommandSource(playerid, &sourceId)
{
    new itemid, itemCount;

    // 1) Прямой серверный слот, как в инвентаре: 0..39.
    if(Market_GetSourceItem(playerid, sourceId, itemid, itemCount)) return true;

    // 2) Удобный вариант для игроков: /addmp 1 = первый слот инвентаря.
    if(sourceId > 0 && sourceId <= MAX_INVENTORY_SLOTS)
    {
        new zeroSlot = sourceId - 1;
        if(Market_GetSourceItem(playerid, zeroSlot, itemid, itemCount))
        {
            sourceId = zeroSlot;
            return true;
        }
    }

    // 3) Если вместо слота ввели item id аксессуара или 134 для скина.
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        itemid = g_PlayerInventory[playerid][i][inv_itemId];
        itemCount = g_PlayerInventory[playerid][i][inv_itemCount];
        if(!Market_IsSellableItem(itemid)) continue;

        if(itemid == sourceId || (itemid == 134 && itemCount == sourceId))
        {
            sourceId = i;
            return true;
        }
    }

    // 4) Поиск среди активных слотов: надетый скин / надетые аксессуары.
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        itemid = g_PlayerActiveSlots[playerid][i][inv_itemId];
        itemCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
        if(!Market_IsSellableItem(itemid)) continue;

        if(itemid == sourceId || (itemid == 134 && itemCount == sourceId))
        {
            sourceId = MARKET_ACTIVE_SLOT_BASE + i;
            return true;
        }
    }

    return false;
}


stock Market_FillProductNodeFromCache(Node:obj, row, historyMode, playerid)
{
    new listingId = cache_get_field_content_int(row, "id", db_handle);
    new itemid = cache_get_field_content_int(row, "item_id", db_handle);
    new itemCount = cache_get_field_content_int(row, "item_count", db_handle);
    new price = cache_get_field_content_int(row, "price", db_handle);
    new isHot = cache_get_field_content_int(row, "is_hot", db_handle);
    new sellerId = cache_get_field_content_int(row, "seller_id", db_handle);
    new buyerId = cache_get_field_content_int(row, "buyer_id", db_handle);
    new expiresAt = cache_get_field_content_int(row, "expires_at", db_handle);
    new createdAt = cache_get_field_content_int(row, "created_at", db_handle);
    new soldAt = cache_get_field_content_int(row, "sold_at", db_handle);
    new sellerName[MAX_PLAYER_NAME], itemName[64];

    cache_get_field_content(row, "seller_name", sellerName, db_handle, sizeof(sellerName));
    cache_get_field_content(row, "item_name", itemName, db_handle, sizeof(itemName));

    if(itemName[0] == EOS) Market_GetItemNameByData(itemid, itemCount, itemName, sizeof(itemName));

    new timeLeft = expiresAt ? (expiresAt - gettime()) : MARKET_LISTING_LIFETIME;
    if(timeLeft < 0) timeLeft = 0;

    new cardType = isHot ? MARKET_NOTIFICATION_HOT : MARKET_NOTIFICATION_NONE;
    if(historyMode)
    {
        if(buyerId == Player[playerid][pID]) cardType = MARKET_HISTORY_BUY;
        else cardType = MARKET_HISTORY_SELL;
    }

    JSON_SetInt(obj, "id", listingId);
    JSON_SetInt(obj, "tp", cardType);
    JSON_SetInt(obj, "md", itemid);
    JSON_SetInt(obj, "ct", itemCount);
    JSON_SetInt(obj, "cs", price);
    JSON_SetInt(obj, "tm", historyMode ? soldAt : createdAt);
    JSON_SetInt(obj, "ti", timeLeft);
    JSON_SetInt(obj, "rt", Market_GetRarity(itemid, price));
    JSON_SetInt(obj, "r", Market_GetRarity(itemid, price));
    JSON_SetInt(obj, "pt", Market_GetProductType(itemid));
    JSON_SetInt(obj, "l", 0);
    JSON_SetString(obj, "dm", itemName);
    JSON_SetString(obj, "nm", sellerName);
    JSON_SetString(obj, "sl", sellerName);
    JSON_SetInt(obj, "sid", sellerId);
    return 1;
}

stock Market_AddLikeFlag(playerid, Node:obj, listingId)
{
    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT `listing_id` FROM `marketplace_likes` WHERE `player_id`=%d AND `listing_id`=%d LIMIT 1", Player[playerid][pID], listingId);
    new Cache:result = mysql_query(db_handle, query);
    JSON_SetInt(obj, "l", cache_num_rows() > 0 ? 1 : 0);
    cache_delete(result);
    return 1;
}

stock Market_SendProductsList(playerid, responseType, page, mode)
{
    if(page < 1) page = 1;
    g_MarketCurrentTab[playerid] = mode;
    new query[768], countQuery[512], order[72], search[32];
    format(search, sizeof(search), "%s", g_MarketSearch[playerid]);

    switch(g_MarketSort[playerid])
    {
        case 1: format(order, sizeof(order), "`price` ASC, `created_at` DESC");
        case 2: format(order, sizeof(order), "`price` DESC, `created_at` DESC");
        case 3: format(order, sizeof(order), "`created_at` ASC");
        default: format(order, sizeof(order), "`is_hot` DESC, `created_at` DESC");
    }

    new now = gettime();

    if(mode == MARKET_TAB_MAIN)
    {
        if(search[0]) mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE `status`=0 AND (`expires_at`=0 OR `expires_at`>%d) AND (`item_name` LIKE '%%%e%%' OR `seller_name` LIKE '%%%e%%')", now, search, search);
        else mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE `status`=0 AND (`expires_at`=0 OR `expires_at`>%d)", now);
    }
    else if(mode == MARKET_TAB_MY_STORE)
    {
        if(search[0]) mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE `status`=0 AND `seller_id`=%d AND (`expires_at`=0 OR `expires_at`>%d) AND `item_name` LIKE '%%%e%%'", Player[playerid][pID], now, search);
        else mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE `status`=0 AND `seller_id`=%d AND (`expires_at`=0 OR `expires_at`>%d)", Player[playerid][pID], now);
    }
    else if(mode == MARKET_TAB_FAVORITES)
    {
        if(search[0]) mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` m INNER JOIN `marketplace_likes` l ON l.`listing_id`=m.`id` WHERE l.`player_id`=%d AND m.`status`=0 AND (m.`expires_at`=0 OR m.`expires_at`>%d) AND (m.`item_name` LIKE '%%%e%%' OR m.`seller_name` LIKE '%%%e%%')", Player[playerid][pID], now, search, search);
        else mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` m INNER JOIN `marketplace_likes` l ON l.`listing_id`=m.`id` WHERE l.`player_id`=%d AND m.`status`=0 AND (m.`expires_at`=0 OR m.`expires_at`>%d)", Player[playerid][pID], now);
    }
    else
    {
        mysql_format(db_handle, countQuery, sizeof(countQuery), "SELECT COUNT(*) AS `cnt` FROM `marketplace_items` WHERE (`seller_id`=%d OR `buyer_id`=%d) AND `status`=1", Player[playerid][pID], Player[playerid][pID]);
    }

    new Cache:countResult = mysql_query(db_handle, countQuery);
    new total = 0;
    if(cache_num_rows() > 0) total = cache_get_field_content_int(0, "cnt", db_handle);
    cache_delete(countResult);

    new virtualCount = 0;
    if(mode == MARKET_TAB_MAIN && !search[0]) virtualCount = 1;
    total += virtualCount;

    new pages = (total + MARKET_PAGE_SIZE - 1) / MARKET_PAGE_SIZE;
    if(pages < 1) pages = 1;
    if(page > pages) page = pages;
    g_MarketCurrentPage[playerid] = page;

    new offset = (page - 1) * MARKET_PAGE_SIZE;
    new dbLimit = MARKET_PAGE_SIZE;
    new addTestSkin = 0;

    if(mode == MARKET_TAB_MAIN && !search[0])
    {
        if(page == 1)
        {
            addTestSkin = 1;
            dbLimit = MARKET_PAGE_SIZE - 1;
        }
        else
        {
            offset -= 1;
            if(offset < 0) offset = 0;
        }
    }

    if(mode == MARKET_TAB_MAIN)
    {
        if(search[0]) mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `status`=0 AND (`expires_at`=0 OR `expires_at`>%d) AND (`item_name` LIKE '%%%e%%' OR `seller_name` LIKE '%%%e%%') ORDER BY %s LIMIT %d,%d", now, search, search, order, offset, dbLimit);
        else mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `status`=0 AND (`expires_at`=0 OR `expires_at`>%d) ORDER BY %s LIMIT %d,%d", now, order, offset, dbLimit);
    }
    else if(mode == MARKET_TAB_MY_STORE)
    {
        if(search[0]) mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `status`=0 AND `seller_id`=%d AND (`expires_at`=0 OR `expires_at`>%d) AND `item_name` LIKE '%%%e%%' ORDER BY %s LIMIT %d,%d", Player[playerid][pID], now, search, order, offset, dbLimit);
        else mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `status`=0 AND `seller_id`=%d AND (`expires_at`=0 OR `expires_at`>%d) ORDER BY %s LIMIT %d,%d", Player[playerid][pID], now, order, offset, dbLimit);
    }
    else if(mode == MARKET_TAB_FAVORITES)
    {
        if(search[0]) mysql_format(db_handle, query, sizeof(query), "SELECT m.* FROM `marketplace_items` m INNER JOIN `marketplace_likes` l ON l.`listing_id`=m.`id` WHERE l.`player_id`=%d AND m.`status`=0 AND (m.`expires_at`=0 OR m.`expires_at`>%d) AND (m.`item_name` LIKE '%%%e%%' OR m.`seller_name` LIKE '%%%e%%') ORDER BY %s LIMIT %d,%d", Player[playerid][pID], now, search, search, order, offset, dbLimit);
        else mysql_format(db_handle, query, sizeof(query), "SELECT m.* FROM `marketplace_items` m INNER JOIN `marketplace_likes` l ON l.`listing_id`=m.`id` WHERE l.`player_id`=%d AND m.`status`=0 AND (m.`expires_at`=0 OR m.`expires_at`>%d) ORDER BY %s LIMIT %d,%d", Player[playerid][pID], now, order, offset, dbLimit);
    }
    else
    {
        mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE (`seller_id`=%d OR `buyer_id`=%d) AND `status`=1 ORDER BY `sold_at` DESC LIMIT %d,%d", Player[playerid][pID], Player[playerid][pID], offset, dbLimit);
    }

    new Node:json = JSON_Object();
    new Node:array = JSON_Array();
    if(addTestSkin) array = Market_AppendTestSkinNode(array);
    new Cache:result = mysql_query(db_handle, query);
    for(new i = 0; i < cache_num_rows(); i++)
    {
        new Node:item = JSON_Object();
        Market_FillProductNodeFromCache(item, i, mode == MARKET_TAB_HISTORY, playerid);
        Market_AddLikeFlag(playerid, item, cache_get_field_content_int(i, "id", db_handle));
        array = JSON_Append(array, item);
    }
    cache_delete(result);

    JSON_SetInt(json, "t", responseType);
    Market_SetCommonPacketInfo(playerid, json, page, pages);
    JSON_SetInt(json, "tm", (mode == MARKET_TAB_MAIN && Player[playerid][pVipType] < MARKET_VIP_TYPE) ? MARKET_VIP_DAYS : 0);
    JSON_SetArray(json, "n", array);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_CountSellableSources(playerid)
{
    new total = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(Market_IsSellableItem(g_PlayerInventory[playerid][i][inv_itemId])) total++;
    }

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(Market_IsSellableItem(g_PlayerActiveSlots[playerid][i][inv_itemId])) total++;
    }
    return total;
}

stock Node:Market_AppendInventoryCard(playerid, Node:array, sourceId, itemid, itemCount)
{
    new name[64];
    Market_GetItemNameByData(itemid, itemCount, name, sizeof(name));

    new Node:item = JSON_Object();
    JSON_SetInt(item, "id", sourceId);
    JSON_SetInt(item, "tp", MARKET_NOTIFICATION_NONE);
    JSON_SetInt(item, "md", itemid);
    JSON_SetInt(item, "ct", itemCount);
    JSON_SetInt(item, "cs", MARKET_MIN_PRICE);
    JSON_SetInt(item, "tm", 0);
    JSON_SetInt(item, "ti", MARKET_LISTING_LIFETIME);
    JSON_SetInt(item, "rt", Market_GetRarity(itemid, 0));
    JSON_SetInt(item, "r", Market_GetRarity(itemid, 0));
    JSON_SetInt(item, "pt", Market_GetProductType(itemid));
    JSON_SetInt(item, "l", 0);
    JSON_SetString(item, "dm", name);
    JSON_SetString(item, "nm", Player[playerid][pName]);
    JSON_SetString(item, "sl", Player[playerid][pName]);
    return JSON_Append(array, item);
}

stock Market_SendInventory(playerid, page)
{
    if(page < 1) page = 1;
    g_MarketCurrentTab[playerid] = MARKET_TAB_INVENTORY;
    g_MarketCurrentPage[playerid] = page;

    new total = Market_CountSellableSources(playerid);
    new pages = (total + MARKET_PAGE_SIZE - 1) / MARKET_PAGE_SIZE;
    if(pages < 1) pages = 1;
    if(page > pages) page = pages;

    new offset = (page - 1) * MARKET_PAGE_SIZE;
    new added = 0, skipped = 0;
    new Node:json = JSON_Object();
    new Node:array = JSON_Array();

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        new itemid = g_PlayerInventory[playerid][i][inv_itemId];
        if(!Market_IsSellableItem(itemid)) continue;
        if(skipped < offset)
        {
            skipped++;
            continue;
        }
        if(added >= MARKET_PAGE_SIZE) break;
        array = Market_AppendInventoryCard(playerid, array, i, itemid, g_PlayerInventory[playerid][i][inv_itemCount]);
        added++;
    }

    if(added < MARKET_PAGE_SIZE)
    {
        for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
        {
            new itemid = g_PlayerActiveSlots[playerid][i][inv_itemId];
            if(!Market_IsSellableItem(itemid)) continue;
            if(skipped < offset)
            {
                skipped++;
                continue;
            }
            if(added >= MARKET_PAGE_SIZE) break;
            array = Market_AppendInventoryCard(playerid, array, MARKET_ACTIVE_SLOT_BASE + i, itemid, g_PlayerActiveSlots[playerid][i][inv_itemCount]);
            added++;
        }
    }

    JSON_SetInt(json, "t", 9);
    Market_SetCommonPacketInfo(playerid, json, page, pages);
    JSON_SetInt(json, "tm", 0);
    JSON_SetArray(json, "n", array);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_SendProfile(playerid)
{
    g_MarketCurrentTab[playerid] = MARKET_TAB_PROFILE;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetString(json, "n", Player[playerid][pName]);
    JSON_SetInt(json, "id", Player[playerid][pID]);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "ct", Market_GetActiveLotsCount(playerid));
    JSON_SetInt(json, "lp", Market_GetActiveLotsCount(playerid));
    JSON_SetInt(json, "lh", Market_GetSoldLotsCount(playerid));
    JSON_SetInt(json, "ma", Market_GetAllRevenue(playerid));
    JSON_SetInt(json, "tm", 0);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_SendOpenPacket(playerid)
{
    // Первый лёгкий пакет без SQL-запросов: он гарантированно открывает Java GUI 77.
    new Node:json = JSON_Object();
    new Node:array = JSON_Array();

    array = Market_AppendTestSkinNode(array);

    JSON_SetInt(json, "t", 2);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "v", Market_GetVipTypeForGui(playerid));
    JSON_SetInt(json, "vm", MARKET_VIP_PRICE);
    JSON_SetInt(json, "lp", 0);
    JSON_SetInt(json, "lh", 0);
    JSON_SetInt(json, "tm", (Market_GetVipTypeForGui(playerid) < MARKET_VIP_TYPE) ? MARKET_VIP_DAYS : 0);
    JSON_SetInt(json, "ls", 1);
    JSON_SetInt(json, "lt", 1);
    JSON_SetArray(json, "n", array);
    return Market_SendRaw(playerid, json);
}

stock Market_Open(playerid)
{
    Market_ResetPlayer(playerid);

    // First packet must open Java GUI 77. Product list is sent after that as update.
    g_MarketOpenPacket[playerid] = true;
    Market_SendOpenPacket(playerid);

    return Market_SendProductsList(playerid, 2, 1, MARKET_TAB_MAIN);
}


stock Market_SelectSellItem(playerid, slot)
{
    new itemid, itemCount;
    if(!Market_GetSourceItem(playerid, slot, itemid, itemCount)) return Market_SendError(playerid, 10, "Неверный слот предмета");
    if(!Market_IsSellableItem(itemid)) return Market_SendError(playerid, 10, "На маркет можно выставлять только аксессуары и скины");

    g_MarketSelectedSlot[playerid] = slot;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 10);
    JSON_SetInt(json, "rk", 999);
    JSON_SetInt(json, "id", slot);
    JSON_SetInt(json, "md", itemid);
    JSON_SetInt(json, "ct", itemCount);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_PublishSelected(playerid, price, hot)
{
    new slot = g_MarketSelectedSlot[playerid];
    if(slot < 0) return Market_SendError(playerid, 11, "Сначала выберите предмет");
    if(price < MARKET_MIN_PRICE || price > MARKET_MAX_PRICE) return Market_SendError(playerid, 11, "Неверная цена");

    new itemid, itemCount;
    if(!Market_GetSourceItem(playerid, slot, itemid, itemCount)) return Market_SendError(playerid, 11, "На маркет можно выставлять только аксессуары и скины");
    if(!Market_IsSellableItem(itemid)) return Market_SendError(playerid, 11, "На маркет можно выставлять только аксессуары и скины");

    new name[64];
    Market_GetItemNameByData(itemid, itemCount, name, sizeof(name));

    new listingId = Market_InsertListing(playerid, itemid, itemCount, price, hot, name);
    if(listingId <= 0)
    {
        return Market_SendError(playerid, 11, "SQL ошибка: лот не был сохранен");
    }

    if(!Market_RemoveSourceItem(playerid, slot))
    {
        new query[160];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=2 WHERE `id`=%d LIMIT 1", listingId);
        mysql_query(db_handle, query);
        return Market_SendError(playerid, 11, "Не удалось снять предмет из инвентаря");
    }

    Inventory_Save(playerid);
    ShowPlayerInventory(playerid);
    g_MarketSelectedSlot[playerid] = -1;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 11);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "id", listingId);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "lp", Market_GetActiveLotsCount(playerid));
    Market_SendRaw(playerid, json);

    ShowNotification(playerid, 1, 5, 0, 0, "Предмет выставлен на маркет", "");
    return Market_SendInventory(playerid, 1);
}



stock Market_PublishSource(playerid, sourceId, price, hot)
{
    if(Player[playerid][pID] <= 0) return ShowNotification(playerid, 0, 5, 0, 0, "Сначала авторизуйтесь", "");
    if(price < MARKET_MIN_PRICE || price > MARKET_MAX_PRICE) return ShowNotification(playerid, 2, 5, 0, 0, "Неверная цена. Используйте цену от 100 до 999999999", "");

    if(!Market_ResolveCommandSource(playerid, sourceId)) return ShowNotification(playerid, 2, 5, 0, 0, "В этом слоте нет скина или аксессуара для продажи", "");

    new itemid, itemCount;
    if(!Market_GetSourceItem(playerid, sourceId, itemid, itemCount)) return ShowNotification(playerid, 2, 5, 0, 0, "В этом слоте нет скина или аксессуара для продажи", "");
    if(!Market_IsSellableItem(itemid)) return ShowNotification(playerid, 2, 5, 0, 0, "На маркет можно выставлять только аксессуары и скины", "");

    new name[64];
    Market_GetItemNameByData(itemid, itemCount, name, sizeof(name));

    new listingId = Market_InsertListing(playerid, itemid, itemCount, price, hot, name);
    if(listingId <= 0)
    {
        return ShowNotification(playerid, 2, 5, 0, 0, "SQL ошибка: лот не был сохранен", "");
    }

    if(!Market_RemoveSourceItem(playerid, sourceId))
    {
        new query[160];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=2 WHERE `id`=%d LIMIT 1", listingId);
        mysql_query(db_handle, query);
        return ShowNotification(playerid, 2, 5, 0, 0, "Не удалось забрать предмет из инвентаря", "");
    }

    Inventory_Save(playerid);
    ShowPlayerInventory(playerid);

    new msg[128];
    format(msg, sizeof(msg), "Лот #%d выставлен на маркет за %d$", listingId, price);
    ShowNotification(playerid, 1, 5, 0, 0, msg, "");

    g_MarketOpenPacket[playerid] = true;
    return Market_SendProductsList(playerid, 2, 1, MARKET_TAB_MAIN);
}


stock Market_BuyTestSkin(playerid)
{
    if(GetPlayerMoneyEx(playerid) < MARKET_TEST_SKIN_PRICE) return Market_SendError(playerid, 13, "Недостаточно денег");
    if(!Market_CanReceiveItem(playerid, 134, MARKET_TEST_SKIN_MODEL)) return Market_SendError(playerid, 13, "В инвентаре нет места или превышен вес");
    if(!Inventory_AddSkinItem(playerid, MARKET_TEST_SKIN_MODEL)) return Market_SendError(playerid, 13, "Не удалось выдать скин");

    Inventory_Save(playerid);
    GivePlayerMoneyEx(playerid, -MARKET_TEST_SKIN_PRICE);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 13);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "id", MARKET_TEST_SKIN_LISTING_ID);
    Market_SendRaw(playerid, json);

    ShowNotification(playerid, 1, 5, 0, 0, "Вы купили тестовый скин #89", "");
    return Market_SendProductsList(playerid, 2, g_MarketCurrentPage[playerid], MARKET_TAB_MAIN);
}

stock Market_SelectVip(playerid)
{
    g_MarketSelectedListing[playerid] = 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 12);
    JSON_SetInt(json, "id", 0);
    JSON_SetInt(json, "tp", MARKET_NOTIFICATION_NONE);
    JSON_SetInt(json, "md", 0);
    JSON_SetInt(json, "ct", 1);
    JSON_SetInt(json, "cs", MARKET_VIP_PRICE);
    JSON_SetInt(json, "tm", MARKET_VIP_DAYS);
    JSON_SetInt(json, "ti", MARKET_VIP_DAYS * 86400);
    JSON_SetInt(json, "rt", 5);
    JSON_SetInt(json, "r", 5);
    JSON_SetInt(json, "pt", MARKET_TYPE_OTHER);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetString(json, "dm", "Platinum VIP на 30 дней");
    JSON_SetString(json, "nm", "Market");
    JSON_SetString(json, "sl", "Market");
    return Market_SendRaw(playerid, json);
}

stock Market_BuyVip(playerid)
{
    if(GetPlayerMoneyEx(playerid) < MARKET_VIP_PRICE) return Market_SendError(playerid, 26, "Недостаточно денег для покупки VIP");

    GivePlayerMoneyEx(playerid, -MARKET_VIP_PRICE);
    Player[playerid][pVipType] = MARKET_VIP_TYPE;
    if(Player[playerid][pVipTime] < 0) Player[playerid][pVipTime] = 0;
    Player[playerid][pVipTime] += MARKET_VIP_DAYS * 24 * 60;
    SavePlayerAccount(playerid);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 26);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "lp", Market_GetActiveLotsCount(playerid));
    Market_SendRaw(playerid, json);

    ShowNotification(playerid, 1, 5, 0, 0, "Вы купили Platinum VIP на 30 дней", "");
    return Market_SendProductsList(playerid, 2, 1, MARKET_TAB_MAIN);
}

stock Market_SelectBuy(playerid, listingId)
{
    if(listingId == 0) return Market_SelectVip(playerid);
    if(listingId == MARKET_TEST_SKIN_LISTING_ID)
    {
        g_MarketSelectedListing[playerid] = listingId;
        new Node:json = JSON_Object();
        Market_FillTestSkinNode(json);
        JSON_SetInt(json, "t", 12);
        JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
        return Market_SendRaw(playerid, json);
    }

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `id`=%d AND `status`=0 AND (`expires_at`=0 OR `expires_at`>%d) LIMIT 1", listingId, gettime());
    new Cache:result = mysql_query(db_handle, query);
    if(cache_num_rows() == 0)
    {
        cache_delete(result);
        return Market_SendError(playerid, 12, "Лот уже недоступен");
    }

    new sellerId = cache_get_field_content_int(0, "seller_id", db_handle);
    if(sellerId == Player[playerid][pID])
    {
        cache_delete(result);
        return Market_SendError(playerid, 12, "Нельзя купить свой лот");
    }

    g_MarketSelectedListing[playerid] = listingId;
    new Node:json = JSON_Object();
    Market_FillProductNodeFromCache(json, 0, 0, playerid);
    JSON_SetInt(json, "t", 12);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    cache_delete(result);
    Market_SendRaw(playerid, json);
    return 1;
}

stock bool:Market_CanReceiveItem(playerid, itemid, itemCount)
{
    if(itemid == 134)
    {
        if(itemCount < 0 || itemCount > 311) return false;
        if(Inventory_GetFreeSlot(playerid) == -1) return false;
        if(GetPlayerWeight(playerid) + Inventory_GetItemTotalWeight(134, 1) > GetPlayerMaxWeight(playerid)) return false;
        return true;
    }

    if(Market_IsAccessoryItem(itemid))
    {
        if(Market_GetAccessoryIdByItem(itemid) < 0) return false;
        if(Inventory_GetFreeSlot(playerid) == -1) return false;
        if(GetPlayerWeight(playerid) + GetItemWeight(itemid) > GetPlayerMaxWeight(playerid)) return false;
        return true;
    }

    return false;
}

stock bool:Market_GiveItemToPlayer(playerid, itemid, itemCount)
{
    if(itemid == 134)
    {
        return Inventory_AddSkinItem(playerid, itemCount) ? true : false;
    }

    if(Market_IsAccessoryItem(itemid))
    {
        new acs = Market_GetAccessoryIdByItem(itemid);
        if(acs < 0) return false;
        return Inventory_AddAccessoryItem(playerid, acs, itemid);
    }

    return false;
}

stock Market_BuyListing(playerid, listingId)
{
    if(listingId == 0) return Market_BuyVip(playerid);
    if(listingId <= 0) listingId = g_MarketSelectedListing[playerid];
    if(listingId == MARKET_TEST_SKIN_LISTING_ID) return Market_BuyTestSkin(playerid);
    if(listingId <= 0) return Market_SendError(playerid, 13, "Сначала выберите лот");

    new query[512];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `id`=%d AND `status`=0 AND (`expires_at`=0 OR `expires_at`>%d) LIMIT 1", listingId, gettime());
    new Cache:result = mysql_query(db_handle, query);
    if(cache_num_rows() == 0)
    {
        cache_delete(result);
        return Market_SendError(playerid, 13, "Лот уже недоступен");
    }

    new sellerId = cache_get_field_content_int(0, "seller_id", db_handle);
    new itemid = cache_get_field_content_int(0, "item_id", db_handle);
    new itemCount = cache_get_field_content_int(0, "item_count", db_handle);
    new price = cache_get_field_content_int(0, "price", db_handle);

    if(sellerId == Player[playerid][pID])
    {
        cache_delete(result);
        return Market_SendError(playerid, 13, "Нельзя купить свой лот");
    }

    if(GetPlayerMoneyEx(playerid) < price)
    {
        cache_delete(result);
        return Market_SendError(playerid, 13, "Недостаточно денег");
    }

    if(!Market_CanReceiveItem(playerid, itemid, itemCount))
    {
        cache_delete(result);
        return Market_SendError(playerid, 13, "В инвентаре нет места или превышен вес");
    }

    mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=1, `buyer_id`=%d, `buyer_name`='%e', `sold_at`=%d WHERE `id`=%d AND `status`=0", Player[playerid][pID], Player[playerid][pName], gettime(), listingId);
    new Cache:buyResult = mysql_query(db_handle, query);
    new affected = cache_affected_rows(db_handle);
    cache_delete(buyResult);

    if(affected <= 0)
    {
        cache_delete(result);
        return Market_SendError(playerid, 13, "Лот уже недоступен");
    }

    if(!Market_GiveItemToPlayer(playerid, itemid, itemCount))
    {
        mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=0, `buyer_id`=0, `buyer_name`='', `sold_at`=0 WHERE `id`=%d AND `buyer_id`=%d", listingId, Player[playerid][pID]);
        mysql_tquery(db_handle, query, "", "");
        cache_delete(result);
        return Market_SendError(playerid, 13, "В инвентаре нет места или превышен вес");
    }
    Inventory_Save(playerid);

    GivePlayerMoneyEx(playerid, -price);

    new sellerOnline = Market_FindOnlineBySqlId(sellerId);
    if(sellerOnline != INVALID_PLAYER_ID)
    {
        GivePlayerMoneyEx(sellerOnline, price);
        ShowNotification(sellerOnline, 1, 5, 0, 0, "Ваш предмет купили на маркете", "");
    }
    else
    {
        mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `money`=`money`+%d WHERE `id`=%d", price, sellerId);
        mysql_tquery(db_handle, query, "", "");
    }

    cache_delete(result);

    g_MarketSelectedListing[playerid] = -1;
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 13);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "id", listingId);
    Market_SendRaw(playerid, json);
    ShowNotification(playerid, 1, 5, 0, 0, "Покупка успешно завершена", "");

    Market_SendProductsList(playerid, 2, g_MarketCurrentPage[playerid], MARKET_TAB_MAIN);
    return 1;
}

stock Market_SelectEdit(playerid, listingId)
{
    new query[256];
    mysql_format(db_handle, query, sizeof(query), "SELECT `id` FROM `marketplace_items` WHERE `id`=%d AND `seller_id`=%d AND `status`=0 LIMIT 1", listingId, Player[playerid][pID]);
    new Cache:result = mysql_query(db_handle, query);
    if(cache_num_rows() == 0)
    {
        cache_delete(result);
        return Market_SendError(playerid, 15, "Лот не найден");
    }
    cache_delete(result);

    g_MarketSelectedListing[playerid] = listingId;
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 15);
    JSON_SetInt(json, "id", listingId);
    JSON_SetInt(json, "rk", 999);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_EditSelected(playerid, price, hot)
{
    new listingId = g_MarketSelectedListing[playerid];
    if(listingId <= 0) return Market_SendError(playerid, 16, "Сначала выберите лот");
    if(price < MARKET_MIN_PRICE || price > MARKET_MAX_PRICE) return Market_SendError(playerid, 16, "Неверная цена");

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `price`=%d, `is_hot`=%d WHERE `id`=%d AND `seller_id`=%d AND `status`=0", price, hot ? 1 : 0, listingId, Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 16);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "id", listingId);
    JSON_SetInt(json, "cs", price);
    JSON_SetInt(json, "rs", hot ? 1 : 0);
    Market_SendRaw(playerid, json);
    ShowNotification(playerid, 1, 5, 0, 0, "Лот обновлен", "");
    Market_SendProductsList(playerid, 5, g_MarketCurrentPage[playerid], MARKET_TAB_MY_STORE);
    return 1;
}

stock Market_DeleteSelected(playerid)
{
    new listingId = g_MarketSelectedListing[playerid];
    if(listingId <= 0) return Market_SendError(playerid, 17, "Сначала выберите лот");

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `id`=%d AND `seller_id`=%d AND `status`=0 LIMIT 1", listingId, Player[playerid][pID]);
    new Cache:result = mysql_query(db_handle, query);
    if(cache_num_rows() == 0)
    {
        cache_delete(result);
        return Market_SendError(playerid, 17, "Лот не найден");
    }

    new itemid = cache_get_field_content_int(0, "item_id", db_handle);
    new itemCount = cache_get_field_content_int(0, "item_count", db_handle);

    if(!Market_GiveItemToPlayer(playerid, itemid, itemCount))
    {
        cache_delete(result);
        return Market_SendError(playerid, 17, "В инвентаре нет места или превышен вес");
    }
    Inventory_Save(playerid);
    cache_delete(result);

    mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=2 WHERE `id`=%d AND `seller_id`=%d AND `status`=0", listingId, Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");
    g_MarketSelectedListing[playerid] = -1;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 17);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "id", listingId);
    Market_SendRaw(playerid, json);
    ShowNotification(playerid, 1, 5, 0, 0, "Лот снят с маркета", "");
    Market_SendProductsList(playerid, 5, g_MarketCurrentPage[playerid], MARKET_TAB_MY_STORE);
    return 1;
}

stock Market_ToggleLike(playerid, listingId)
{
    if(listingId <= 0) return 1;
    new query[256];
    mysql_format(db_handle, query, sizeof(query), "SELECT `listing_id` FROM `marketplace_likes` WHERE `player_id`=%d AND `listing_id`=%d LIMIT 1", Player[playerid][pID], listingId);
    new Cache:result = mysql_query(db_handle, query);
    if(cache_num_rows() > 0)
    {
        cache_delete(result);
        mysql_format(db_handle, query, sizeof(query), "DELETE FROM `marketplace_likes` WHERE `player_id`=%d AND `listing_id`=%d", Player[playerid][pID], listingId);
        mysql_tquery(db_handle, query, "", "");
    }
    else
    {
        cache_delete(result);
        mysql_format(db_handle, query, sizeof(query), "INSERT INTO `marketplace_likes` (`player_id`,`listing_id`,`created_at`) VALUES (%d,%d,%d)", Player[playerid][pID], listingId, gettime());
        mysql_tquery(db_handle, query, "", "");
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 14);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "id", listingId);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_SendHistoryInfo(playerid, listingId)
{
    new query[256];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `marketplace_items` WHERE `id`=%d AND (`seller_id`=%d OR `buyer_id`=%d) LIMIT 1", listingId, Player[playerid][pID], Player[playerid][pID]);
    new Cache:result = mysql_query(db_handle, query);
    if(cache_num_rows() == 0)
    {
        cache_delete(result);
        return Market_SendError(playerid, 18, "История лота не найдена");
    }

    new Node:json = JSON_Object();
    Market_FillProductNodeFromCache(json, 0, 1, playerid);
    JSON_SetInt(json, "t", 18);
    JSON_SetInt(json, "tb", cache_get_field_content_int(0, "sold_at", db_handle));
    cache_delete(result);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Marketplace_HandlePacket(playerid, Node:json)
{
    new type;
    JSON_GetInt(json, "t", type);

    switch(type)
    {
            case 1:
            {
                return Market_SendProfile(playerid);
            }
            case 2:
            {
                g_MarketCurrentTab[playerid] = MARKET_TAB_MAIN;
                return Market_SendProductsList(playerid, 2, 1, MARKET_TAB_MAIN);
            }
            case 3:
            {
                g_MarketCurrentTab[playerid] = MARKET_TAB_HISTORY;
                return Market_SendProductsList(playerid, 3, 1, MARKET_TAB_HISTORY);
            }
            case 4:
            {
                g_MarketCurrentTab[playerid] = MARKET_TAB_FAVORITES;
                return Market_SendProductsList(playerid, 4, 1, MARKET_TAB_FAVORITES);
            }
            case 5:
            {
                g_MarketCurrentTab[playerid] = MARKET_TAB_MY_STORE;
                return Market_SendProductsList(playerid, 5, 1, MARKET_TAB_MY_STORE);
            }
            case 6:
            {
                new page;
                JSON_GetInt(json, "lt", page);
                if(page <= 0) page = 1;
                switch(g_MarketCurrentTab[playerid])
                {
                    case MARKET_TAB_HISTORY: return Market_SendProductsList(playerid, 3, page, MARKET_TAB_HISTORY);
                    case MARKET_TAB_FAVORITES: return Market_SendProductsList(playerid, 4, page, MARKET_TAB_FAVORITES);
                    case MARKET_TAB_MY_STORE: return Market_SendProductsList(playerid, 5, page, MARKET_TAB_MY_STORE);
                    case MARKET_TAB_INVENTORY: return Market_SendInventory(playerid, page);
                    default: return Market_SendProductsList(playerid, 2, page, MARKET_TAB_MAIN);
                }
            }
            case 7:
            {
                ShowNotification(playerid, 2, 5, 0, 0, "Донат из маркета пока отключен", "");
                return 1;
            }
            case 8:
            {
                if(g_MarketCurrentTab[playerid] == MARKET_TAB_INVENTORY) return Market_SendInventory(playerid, 1);
                return Market_SendProductsList(playerid, 8, 1, g_MarketCurrentTab[playerid]);
            }
            case 9:
            {
                return Market_SendInventory(playerid, 1);
            }
            case 10:
            {
                new slot;
                JSON_GetInt(json, "id", slot);
                return Market_SelectSellItem(playerid, slot);
            }
            case 11:
            {
                new price, hot;
                JSON_GetInt(json, "cs", price);
                JSON_GetInt(json, "rs", hot);
                return Market_PublishSelected(playerid, price, hot);
            }
            case 12:
            {
                new listingId;
                JSON_GetInt(json, "id", listingId);
                return Market_SelectBuy(playerid, listingId);
            }
            case 13:
            {
                new listingId;
                JSON_GetInt(json, "id", listingId);
                return Market_BuyListing(playerid, listingId);
            }
            case 14:
            {
                new listingId;
                JSON_GetInt(json, "id", listingId);
                return Market_ToggleLike(playerid, listingId);
            }
            case 15:
            {
                new listingId;
                JSON_GetInt(json, "id", listingId);
                return Market_SelectEdit(playerid, listingId);
            }
            case 16:
            {
                new price, hot;
                JSON_GetInt(json, "cs", price);
                JSON_GetInt(json, "rs", hot);
                return Market_EditSelected(playerid, price, hot);
            }
            case 17:
            {
                return Market_DeleteSelected(playerid);
            }
            case 18:
            {
                new listingId;
                JSON_GetInt(json, "id", listingId);
                return Market_SendHistoryInfo(playerid, listingId);
            }
            case 19:
            {
                JSON_GetString(json, "s", g_MarketSearch[playerid], 32);
                if(g_MarketCurrentTab[playerid] == MARKET_TAB_INVENTORY) return Market_SendInventory(playerid, 1);
                return Market_SendProductsList(playerid, 19, 1, g_MarketCurrentTab[playerid]);
            }
            case 20:
            {
                return Market_BuyVip(playerid);
            }
            case 25:
            {
                return Market_SelectVip(playerid);
            }
            case 21:
            {
                JSON_GetInt(json, "st", g_MarketSort[playerid]);
                if(g_MarketCurrentTab[playerid] == MARKET_TAB_INVENTORY) return Market_SendInventory(playerid, 1);
                if(g_MarketCurrentTab[playerid] == MARKET_TAB_MY_STORE) return Market_SendProductsList(playerid, 5, 1, MARKET_TAB_MY_STORE);
                return Market_SendProductsList(playerid, 21, 1, g_MarketCurrentTab[playerid]);
            }
            case 26:
            {
                new Node:answer = JSON_Object();
                JSON_SetInt(answer, "t", 26);
                JSON_SetInt(answer, "m", GetPlayerMoneyEx(playerid));
                JSON_SetInt(answer, "lp", Market_GetActiveLotsCount(playerid));
                Market_SendRaw(playerid, answer);
                return 1;
            }
    }

    new close;
    JSON_GetInt(json, "c", close);
    if(close == 1)
    {
        g_MarketSelectedSlot[playerid] = -1;
        g_MarketSelectedListing[playerid] = -1;
        return 1;
    }
    return 1;
}


// shram

