/*

    автор мемори & меллисс
    
    типа в ипакеь
    case 77:
    {
        Marketplace_HandlePacket(playerid, json);
        return 1;
    }
    
    типа в OnGameModeInit перед return 1  
    Marketplace_Init();
    
    ета гавно в бд запросом
    
    CREATE TABLE `items_data` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` int(11) NOT NULL DEFAULT 0,
  `item_weight` int(11) NOT NULL DEFAULT 1,
  `item_max_stack` int(11) NOT NULL DEFAULT 999
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `marketplace_items` (
  `id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `seller_name` varchar(24) NOT NULL DEFAULT '',
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL DEFAULT 1,
  `item_name` varchar(64) NOT NULL DEFAULT '',
  `price` int(11) NOT NULL,
  `is_hot` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 active, 1 sold, 2 cancelled',
  `buyer_id` int(11) NOT NULL DEFAULT 0,
  `buyer_name` varchar(24) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL DEFAULT 0,
  `expires_at` int(11) NOT NULL DEFAULT 0,
  `sold_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

INSERT INTO `marketplace_items` (`id`, `seller_id`, `seller_name`, `item_id`, `item_count`, `item_name`, `price`, `is_hot`, `status`, `buyer_id`, `buyer_name`, `created_at`, `expires_at`, `sold_at`) VALUES
(1, 48, 'Memory_Dev', 944, 1, ' SpeedPack', 1111, 0, 0, 0, '', 1780502453, 0, 0);

CREATE TABLE `marketplace_likes` (
  `player_id` int(11) NOT NULL,
  `listing_id` int(11) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

ALTER TABLE `items_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `item_id` (`item_id`);

ALTER TABLE `marketplace_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `seller_id` (`seller_id`),
  ADD KEY `buyer_id` (`buyer_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `price` (`price`),
  ADD KEY `created_at` (`created_at`);

ALTER TABLE `marketplace_likes`
  ADD PRIMARY KEY (`player_id`,`listing_id`),
  ADD KEY `listing_id` (`listing_id`);

ALTER TABLE `items_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `marketplace_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

    ВСО!!!!
*/
#if defined _market_included
    #endinput
#endif
#define _market_included

#define db_handle mysql
#define pMoney P_MONEY
#define pID P_ACCOUNT_ID
#define pSkin P_SKIN
#define pAdminAuth P_ADMIN_LOGGED
#define pAdminLvl P_ADMIN
#define pExp P_EXP
#define pLevel P_LEVEL

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
#define MARKET_ACTIVE_SLOTS          (2)

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

stock bool:Market_Inv11_GetSlotData(playerid, slot, &item_id, &model_id, &amount, &extra_1)
{
    item_id = 0;
    model_id = 0;
    amount = 0;
    extra_1 = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return false;

    new query[196];
    mysql_format(db_handle, query, sizeof(query), "SELECT item_id, model_id, amount, extra_1, old_skin FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, slot);
    new Cache:result = mysql_query(db_handle, query);

    if(cache_num_rows() <= 0)
    {
        cache_delete(result);
        return false;
    }

    item_id = cache_get_field_content_int(0, "item_id", db_handle);
    amount = cache_get_field_content_int(0, "amount", db_handle);
    extra_1 = cache_get_field_content_int(0, "extra_1", db_handle);

    new old_skin = cache_get_field_content_int(0, "old_skin", db_handle);
    new raw_model = cache_get_field_content_int(0, "model_id", db_handle);
    model_id = (item_id == 134 && old_skin > 0) ? old_skin : raw_model;

    cache_delete(result);
    return true;
}

stock bool:Market_Inv11_HasFreeSlot(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return false;

    new max_slots = Inventory11_GetMaxSlots(playerid);
    new query[160];
    mysql_format(db_handle, query, sizeof(query), "SELECT COUNT(*) AS `cnt` FROM inventory WHERE account_id = %d AND slot BETWEEN 1 AND %d", account_id, max_slots);
    new Cache:result = mysql_query(db_handle, query);

    new used = 0;
    if(cache_num_rows() > 0) used = cache_get_field_content_int(0, "cnt", db_handle);
    cache_delete(result);

    return (used < max_slots);
}

stock Market_Inv11_FindSkinSlotByModel(playerid, modelid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return -1;

    new query[196];
    mysql_format(db_handle, query, sizeof(query), "SELECT slot FROM inventory WHERE account_id = %d AND item_id = 134 AND (model_id = %d OR old_skin = %d) ORDER BY slot ASC LIMIT 1", account_id, modelid, modelid);
    new Cache:result = mysql_query(db_handle, query);

    new slot = -1;
    if(cache_num_rows() > 0) slot = cache_get_field_content_int(0, "slot", db_handle);
    cache_delete(result);

    return slot;
}

stock bool:Market_GetAccessoryNameByModel(modelid, name[], len)
{
    if(modelid <= 0) return false;

    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(accessory[i][ID_ACCESSORY] == modelid)
        {
            format(name, len, "%s", accessory[i][NAME_ACCESSORY]);
            return true;
        }
    }
    return false;
}

stock Market_GetAccessoryIdByItem(itemid)
{
    return Inv11_GetAccModelByItem(itemid);
}

stock bool:Market_IsAccessoryItem(itemid)
{
    if(itemid <= 0) return false;
    return Inventory11_IsAccessoryItem(itemid);
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
    return (sourceId >= MARKET_ACTIVE_SLOT_BASE + 1 && sourceId <= MARKET_ACTIVE_SLOT_BASE + MARKET_ACTIVE_SLOTS);
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
        if(activeSlot < 1 || activeSlot > MARKET_ACTIVE_SLOTS) return false;

        new item_1, model_1, item_2, model_2;
        Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2);

        itemid = (activeSlot == 1) ? item_1 : item_2;
        itemCount = 1;

        if(itemid <= 0) return false;
        return Market_IsSellableItem(itemid);
    }

    if(sourceId < 1 || sourceId > Inventory11_GetMaxSlots(playerid)) return false;

    new item_id, model_id, amount, extra_1;
    if(!Market_Inv11_GetSlotData(playerid, sourceId, item_id, model_id, amount, extra_1)) return false;

    if(item_id == 134)
    {
        itemid = 134;
        itemCount = model_id;
        return true;
    }

    if(Inventory11_IsAccessoryItem(item_id))
    {
        itemid = item_id;
        itemCount = 1;
        return true;
    }

    return false;
}

stock bool:Market_RemoveSourceItem(playerid, sourceId)
{
    if(Market_IsActiveSource(sourceId))
    {
        new activeSlot = Market_SourceToActiveSlot(sourceId);
        if(activeSlot < 1 || activeSlot > MARKET_ACTIVE_SLOTS) return false;

        new item_1, model_1, item_2, model_2;
        Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2);

        new itemid = (activeSlot == 1) ? item_1 : item_2;
        if(itemid <= 0 || !Market_IsAccessoryItem(itemid)) return false;

        new account_id = GetPlayerAccountID(playerid);
        if(account_id <= 0) return false;

        if(IsPlayerAttachedObjectSlotUsed(playerid, activeSlot)) RemovePlayerAttachedObject(playerid, activeSlot);

        new query[160];
        mysql_format(db_handle, query, sizeof(query), "DELETE FROM accessories_players WHERE player_id = %d AND slot = %d LIMIT 1", account_id, activeSlot);
        mysql_tquery(db_handle, query, "", "");

        return true;
    }

    if(sourceId < 1 || sourceId > Inventory11_GetMaxSlots(playerid)) return false;
    return Inventory11_DeleteSlotFromDatabase(playerid, sourceId) ? true : false;
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
        new modelid = Inv11_GetAccModelByItem(itemid);
        if(Market_GetAccessoryNameByModel(modelid, name, len)) return 1;

        format(name, len, "Аксессуар #%d", itemid);
        return 1;
    }

    format(name, len, "Предмет #%d", itemid);
    return 1;
}

stock Market_GetItemNameFromSlot(playerid, slot, name[], len)
{
    new itemid, itemCount;
    if(!Market_GetSourceItem(playerid, slot, itemid, itemCount)) return 0;
    return Market_GetItemNameByData(itemid, itemCount, name, len);
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
    new vip = Player[playerid][vip_type];
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
    ShowNotificationMemory(playerid, 0, 5, 0, 0, text, "");
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
    mysql_format(db_handle, query, sizeof(query), "INSERT INTO `marketplace_items` (`seller_id`,`seller_name`,`item_id`,`item_count`,`item_name`,`price`,`is_hot`,`status`,`created_at`,`expires_at`) VALUES (%d,'%e',%d,%d,'%e',%d,%d,0,%d,%d)", Player[playerid][pID], Player[playerid][P_NAME], itemid, itemCount, itemName, price, hot ? 1 : 0, now, 0);

    new Cache:result = mysql_query(db_handle, query);
    new listingId = 0;
    if(cache_affected_rows(db_handle) > 0) listingId = cache_insert_id(db_handle);
    cache_delete(result);
    return listingId;
}

stock bool:Market_ResolveCommandSource(playerid, &sourceId)
{
    new itemid, itemCount;

    if(Market_GetSourceItem(playerid, sourceId, itemid, itemCount)) return true;

    if(Inventory11_IsAccessoryItem(sourceId))
    {
        new slot = Inventory11_FindFirstItemSlotById(playerid, sourceId);
        if(slot > 0)
        {
            sourceId = slot;
            return true;
        }

        new item_1, model_1, item_2, model_2;
        Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2);
        if(item_1 == sourceId)
        {
            sourceId = MARKET_ACTIVE_SLOT_BASE + 1;
            return true;
        }
        if(item_2 == sourceId)
        {
            sourceId = MARKET_ACTIVE_SLOT_BASE + 2;
            return true;
        }
        return false;
    }

    new skinSlot = Market_Inv11_FindSkinSlotByModel(playerid, sourceId);
    if(skinSlot > 0)
    {
        sourceId = skinSlot;
        return true;
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
    JSON_SetInt(json, "tm", (mode == MARKET_TAB_MAIN && Player[playerid][vip_type] < MARKET_VIP_TYPE) ? MARKET_VIP_DAYS : 0);
    JSON_SetArray(json, "n", array);
    Market_SendRaw(playerid, json);
    return 1;
}

stock Market_CountSellableSources(playerid)
{
    new total = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id > 0)
    {
        new query[196];
        mysql_format(db_handle, query, sizeof(query), "SELECT item_id FROM inventory WHERE account_id = %d AND slot BETWEEN 1 AND %d", account_id, Inventory11_GetMaxSlots(playerid));
        new Cache:result = mysql_query(db_handle, query);

        new rows = cache_num_rows();
        for(new i = 0; i < rows; i++)
        {
            new item_id = cache_get_field_content_int(i, "item_id", db_handle);
            if(Market_IsSellableItem(item_id)) total++;
        }
        cache_delete(result);
    }

    new item_1, model_1, item_2, model_2;
    Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2);
    if(item_1 > 0) total++;
    if(item_2 > 0) total++;

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
    JSON_SetString(item, "nm", Player[playerid][P_NAME]);
    JSON_SetString(item, "sl", Player[playerid][P_NAME]);
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

    new account_id = GetPlayerAccountID(playerid);
    if(account_id > 0)
    {
        new query[220];
        mysql_format(db_handle, query, sizeof(query), "SELECT item_id, model_id, slot, old_skin FROM inventory WHERE account_id = %d AND slot BETWEEN 1 AND %d ORDER BY slot ASC", account_id, Inventory11_GetMaxSlots(playerid));
        new Cache:result = mysql_query(db_handle, query);

        new rows = cache_num_rows();
        for(new i = 0; i < rows && added < MARKET_PAGE_SIZE; i++)
        {
            new item_id = cache_get_field_content_int(i, "item_id", db_handle);
            if(!Market_IsSellableItem(item_id)) continue;

            new slot = cache_get_field_content_int(i, "slot", db_handle);
            new itemCount = 1;

            if(item_id == 134)
            {
                new model_id = cache_get_field_content_int(i, "model_id", db_handle);
                new old_skin = cache_get_field_content_int(i, "old_skin", db_handle);
                itemCount = (old_skin > 0) ? old_skin : model_id;
            }

            if(skipped < offset)
            {
                skipped++;
                continue;
            }

            array = Market_AppendInventoryCard(playerid, array, slot, item_id, itemCount);
            added++;
        }
        cache_delete(result);
    }

    if(added < MARKET_PAGE_SIZE)
    {
        new item_1, model_1, item_2, model_2;
        Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2);

        if(item_1 > 0 && added < MARKET_PAGE_SIZE)
        {
            if(skipped < offset) skipped++;
            else
            {
                array = Market_AppendInventoryCard(playerid, array, MARKET_ACTIVE_SLOT_BASE + 1, item_1, 1);
                added++;
            }
        }

        if(item_2 > 0 && added < MARKET_PAGE_SIZE)
        {
            if(skipped < offset) skipped++;
            else
            {
                array = Market_AppendInventoryCard(playerid, array, MARKET_ACTIVE_SLOT_BASE + 2, item_2, 1);
                added++;
            }
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
    JSON_SetString(json, "n", Player[playerid][P_NAME]);
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

    g_MarketSelectedSlot[playerid] = -1;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 11);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "id", listingId);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "lp", Market_GetActiveLotsCount(playerid));
    Market_SendRaw(playerid, json);

    ShowNotificationMemory(playerid, 1, 5, 0, 0, "Предмет выставлен на маркет", "");
    return Market_SendInventory(playerid, 1);
}



stock Market_PublishSource(playerid, sourceId, price, hot)
{
    if(Player[playerid][pID] <= 0) return ShowNotificationMemory(playerid, 0, 5, 0, 0, "Сначала авторизуйтесь", "");
    if(price < MARKET_MIN_PRICE || price > MARKET_MAX_PRICE) return ShowNotificationMemory(playerid, 2, 5, 0, 0, "Неверная цена. Используйте цену от 100 до 999999999", "");

    if(!Market_ResolveCommandSource(playerid, sourceId)) return ShowNotificationMemory(playerid, 2, 5, 0, 0, "В этом слоте нет скина или аксессуара для продажи", "");

    new itemid, itemCount;
    if(!Market_GetSourceItem(playerid, sourceId, itemid, itemCount)) return ShowNotificationMemory(playerid, 2, 5, 0, 0, "В этом слоте нет скина или аксессуара для продажи", "");
    if(!Market_IsSellableItem(itemid)) return ShowNotificationMemory(playerid, 2, 5, 0, 0, "На маркет можно выставлять только аксессуары и скины", "");

    new name[64];
    Market_GetItemNameByData(itemid, itemCount, name, sizeof(name));

    new listingId = Market_InsertListing(playerid, itemid, itemCount, price, hot, name);
    if(listingId <= 0)
    {
        return ShowNotificationMemory(playerid, 2, 5, 0, 0, "SQL ошибка: лот не был сохранен", "");
    }

    if(!Market_RemoveSourceItem(playerid, sourceId))
    {
        new query[160];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=2 WHERE `id`=%d LIMIT 1", listingId);
        mysql_query(db_handle, query);
        return ShowNotificationMemory(playerid, 2, 5, 0, 0, "Не удалось забрать предмет из инвентаря", "");
    }

    new msg[128];
    format(msg, sizeof(msg), "Лот #%d выставлен на маркет за %d$", listingId, price);
    ShowNotificationMemory(playerid, 1, 5, 0, 0, msg, "");

    g_MarketOpenPacket[playerid] = true;
    return Market_SendProductsList(playerid, 2, 1, MARKET_TAB_MAIN);
}


stock Market_BuyTestSkin(playerid)
{
    if(GetPlayerMoneyEx(playerid) < MARKET_TEST_SKIN_PRICE) return Market_SendError(playerid, 13, "Недостаточно денег");
    if(!Market_CanReceiveItem(playerid, 134, MARKET_TEST_SKIN_MODEL)) return Market_SendError(playerid, 13, "В инвентаре нет места или превышен вес");
    if(Inventory11_AddItemToDatabase(playerid, 134, MARKET_TEST_SKIN_MODEL, 1, 0, 0) == -1) return Market_SendError(playerid, 13, "Не удалось выдать скин");

    GivePlayerMoneyEx(playerid, -MARKET_TEST_SKIN_PRICE);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 13);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "id", MARKET_TEST_SKIN_LISTING_ID);
    Market_SendRaw(playerid, json);

    ShowNotificationMemory(playerid, 1, 5, 0, 0, "TEST M3MORY @WHEREMYMEMORY", "");
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
    Player[playerid][vip_type] = MARKET_VIP_TYPE;
    if(Player[playerid][P_PREMIUM_DATE] < 0) Player[playerid][P_PREMIUM_DATE] = 0;
    Player[playerid][P_PREMIUM_DATE] += MARKET_VIP_DAYS * 24 * 60;
    SavePlayerAccount(playerid);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 26);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "lp", Market_GetActiveLotsCount(playerid));
    Market_SendRaw(playerid, json);

    ShowNotificationMemory(playerid, 1, 5, 0, 0, "Вы купили Platinum VIP на 30 дней", "");
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
        if(!Market_Inv11_HasFreeSlot(playerid)) return false;
        if(!Inventory11_CanAddItemWeight(playerid, 134, 1)) return false;
        return true;
    }

    if(Market_IsAccessoryItem(itemid))
    {
        if(Market_GetAccessoryIdByItem(itemid) < 0) return false;
        if(!Market_Inv11_HasFreeSlot(playerid)) return false;
        if(!Inventory11_CanAddItemWeight(playerid, itemid, 1)) return false;
        return true;
    }

    return false;
}

stock bool:Market_GiveItemToPlayer(playerid, itemid, itemCount)
{
    if(itemid == 134)
    {
        new skin_model = (itemCount > 0) ? itemCount : 78;
        return (Inventory11_AddItemToDatabase(playerid, 134, skin_model, 1, 0, 0) != -1);
    }

    if(Market_IsAccessoryItem(itemid))
    {
        new modelid = Market_GetAccessoryIdByItem(itemid);
        if(modelid < 0) return false;

        return (Inventory11_AddItemToDatabase(playerid, itemid, 1, 1, modelid, 0) != -1);
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

    mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=1, `buyer_id`=%d, `buyer_name`='%e', `sold_at`=%d WHERE `id`=%d AND `status`=0", Player[playerid][pID], Player[playerid][P_NAME], gettime(), listingId);
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

    GivePlayerMoneyEx(playerid, -price);

    new sellerOnline = Market_FindOnlineBySqlId(sellerId);
    if(sellerOnline != INVALID_PLAYER_ID)
    {
        GivePlayerMoneyEx(sellerOnline, price);
        ShowNotificationMemory(sellerOnline, 1, 5, 0, 0, "Ваш предмет купили на маркете", "");
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
    ShowNotificationMemory(playerid, 1, 5, 0, 0, "Покупка успешно завершена", "");

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
    ShowNotificationMemory(playerid, 1, 5, 0, 0, "Лот обновлен", "");
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
    cache_delete(result);

    mysql_format(db_handle, query, sizeof(query), "UPDATE `marketplace_items` SET `status`=2 WHERE `id`=%d AND `seller_id`=%d AND `status`=0", listingId, Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");
    g_MarketSelectedListing[playerid] = -1;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 17);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "id", listingId);
    Market_SendRaw(playerid, json);
    ShowNotificationMemory(playerid, 1, 5, 0, 0, "Лот снят с маркета", "");
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
                ShowNotificationMemory(playerid, 2, 5, 0, 0, "Донат из маркета пока отключен", "");
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

CMD:market(playerid)
{
    return Market_Open(playerid);
}

CMD:marketplace(playerid)
{
    return Market_Open(playerid);
}

//выставление

CMD:addmp(playerid, params[])
{
    new slot, price;
    if(sscanf(params, "ii", slot, price)) return SendClientMessage(playerid, -1, "{999999}Используйте: /addmp [слот инвентаря] [цена]");
    return Market_PublishSource(playerid, slot, price, 0);
}