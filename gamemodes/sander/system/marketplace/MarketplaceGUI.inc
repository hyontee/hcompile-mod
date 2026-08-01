
#if defined _sander_marketplace_gui_included
    #endinput
#endif
#define _sander_marketplace_gui_included

#define MARKETPLACE_GUI_ID                    (77)
#define MARKETPLACE_MAX_PAGE_LOTS             (10)
#define MARKETPLACE_DEFAULT_EXPIRE            (259200)
#define MARKETPLACE_SELL_TAX                  (5)
#define MARKETPLACE_MIN_PRICE                 (1)
#define MARKETPLACE_MAX_PRICE                 (999999999)

#define MP_TAB_PROFILE                        (1)
#define MP_TAB_MAIN                           (2)
#define MP_TAB_INVENTORY                      (3) // client sell/inventory tab
#define MP_TAB_HISTORY                        (4)
#define MP_TAB_MY_STORE                       (5)
#define MP_TAB_FAVORITES                      (98)

#define MP_ACT_PAGE                           (6)
#define MP_ACT_DONATE                         (7)
#define MP_ACT_FILTER                         (8)
#define MP_ACT_CREATE_LOT                     (9)
#define MP_ACT_SELECT_INV_ITEM                (10)
#define MP_ACT_PUBLISH_LOT                    (11)
#define MP_ACT_BUY_CLICK                      (12)
#define MP_ACT_CONFIRM_BUY                    (13)
#define MP_ACT_LIKE                           (14)
#define MP_ACT_EDIT_LOT                       (15)
#define MP_ACT_CONFIRM_EDIT                   (16)
#define MP_ACT_DELETE_LOT                     (17)
#define MP_ACT_HISTORY_CARD                   (18)
#define MP_ACT_SEARCH                         (19)
#define MP_ACT_BUY_VIP                        (20)
#define MP_ACT_SORT                           (21)
#define MP_ACT_DOTS_UPDATE                    (22)
#define MP_ACT_LIKED_ARRAY                    (24)
#define MP_ACT_NOTIFY_VIP                     (25)
#define MP_ACT_MONEY_UPDATE                   (26)

#define MP_DIALOG_MAIN                        (28770)
#define MP_DIALOG_LOTS                        (28771)
#define MP_DIALOG_LOT_ACTION                  (28772)
#define MP_DIALOG_INV                         (28773)
#define MP_DIALOG_SELL_COUNT                  (28774)
#define MP_DIALOG_SELL_PRICE                  (28775)
#define MP_DIALOG_MYLOTS                      (28776)
#define MP_DIALOG_MYLOT_ACTION                (28777)
#define MP_DIALOG_SEARCH                      (28778)
#define MP_DIALOG_EDIT_PRICE                  (28779)

new g_MP_SelectedSlot[MAX_PLAYERS] = {-1, ...};
new g_MP_SelectedLot[MAX_PLAYERS] = {-1, ...};
new g_MP_SelectedSellCount[MAX_PLAYERS] = {1, ...};
new g_MP_CurrentTab[MAX_PLAYERS] = {2, ...};
new g_MP_CurrentPage[MAX_PLAYERS] = {0, ...};
new g_MP_Sort[MAX_PLAYERS] = {0, ...};
new g_MP_Search[MAX_PLAYERS][64];

stock Marketplace_SetJsonString(Node:node, const key[], const value[])
{
    new value_buf[256];
    format(value_buf, sizeof value_buf, "%s", value);
    JSON_SetString(node, key, value_buf, sizeof value_buf);
    return 1;
}

forward Marketplace_OnLotsLoaded(playerid, response_type, tab);
forward Marketplace_OnProfileLoaded(playerid);
forward Marketplace_OnHistoryLoaded(playerid);
forward Marketplace_OnBuyInfoLoaded(playerid, lot_id);
forward Marketplace_OnConfirmBuyLoaded(playerid, lot_id, amount);
forward Marketplace_OnWithdrawLoaded(playerid, lot_id);
forward Marketplace_OnDialogLots(playerid, my_lots);

stock Marketplace_ResetPlayer(playerid)
{
    g_MP_SelectedSlot[playerid] = -1;
    g_MP_SelectedLot[playerid] = -1;
    g_MP_SelectedSellCount[playerid] = 1;
    g_MP_CurrentTab[playerid] = MP_TAB_MAIN;
    g_MP_CurrentPage[playerid] = 0;
    g_MP_Sort[playerid] = 0;
    g_MP_Search[playerid][0] = EOS;
    return 1;
}

stock Marketplace_OnGameModeInit()
{
    MPReward_CreateTables();
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `marketplace_lots` (`id` INT NOT NULL AUTO_INCREMENT, `seller_id` INT NOT NULL, `seller_name` VARCHAR(24) NOT NULL, `item_id` INT NOT NULL, `item_count` INT NOT NULL, `amount` INT NOT NULL DEFAULT 1, `item_plate` VARCHAR(32) NOT NULL DEFAULT '', `item_name` VARCHAR(64) NOT NULL DEFAULT '', `item_type` INT NOT NULL DEFAULT 0, `rarity` INT NOT NULL DEFAULT 1, `price` INT NOT NULL, `is_hot` TINYINT NOT NULL DEFAULT 0, `status` TINYINT NOT NULL DEFAULT 0, `created_at` INT NOT NULL, `expires_at` INT NOT NULL, `buyer_id` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `seller_id` (`seller_id`), KEY `status` (`status`), KEY `item_id` (`item_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `marketplace_history` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `lot_id` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL, `amount` INT NOT NULL DEFAULT 1, `price` INT NOT NULL DEFAULT 0, `status` TINYINT NOT NULL DEFAULT 0, `seller_name` VARCHAR(24) NOT NULL DEFAULT '', `buyer_name` VARCHAR(24) NOT NULL DEFAULT '', `item_name` VARCHAR(64) NOT NULL DEFAULT '', `created_at` INT NOT NULL, PRIMARY KEY (`id`), KEY `account_id` (`account_id`), KEY `lot_id` (`lot_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251");
    return 1;
}

stock Marketplace_IsSpecialItem(item_id)
{
    if(item_id == 134) return 1;
    if(item_id == 58 || item_id == 59 || item_id == 81 || item_id == 82 || item_id == 83) return 1;
    return 0;
}

stock Marketplace_GetSlotSellAmount(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    if(item_id <= 0) return 0;
    if(Marketplace_IsSpecialItem(item_id)) return 1;
    return g_PlayerInventory[playerid][slot][inv_itemCount] > 0 ? g_PlayerInventory[playerid][slot][inv_itemCount] : 1;
}

stock Marketplace_GetProductType(item_id)
{
    switch(item_id)
    {
        case 134: return 3;
        case 58, 59, 60, 81, 82, 83: return 2;
    }
    return 1;
}

stock Marketplace_GetRarity(item_id)
{
    if(item_id == 134) return 3;
    if(item_id == 58 || item_id == 59 || item_id == 60) return 2;
    return 1;
}


stock Marketplace_GetInventoryName(playerid, slot, name[], len = sizeof(name))
{
    name[0] = EOS;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    if(item_id <= 0) return 0;
    GetItemName(item_id, name, len);
    if(!strlen(name)) format(name, len, "Item #%d", item_id);
    return 1;
}

stock Marketplace_FindPlayerByAccountID(account_id)
{
    foreach(new i: Player)
    {
        if(IsPlayerConnected(i) && IsPlayerLogged(i) && GetPlayerAccountID(i) == account_id) return i;
    }
    return INVALID_PLAYER_ID;
}

stock Marketplace_AddMoneyToAccount(account_id, money)
{
    new online = Marketplace_FindPlayerByAccountID(account_id);
    if(online != INVALID_PLAYER_ID)
    {
        GivePlayerMoneyEx(online, money, "Marketplace sale", true, true);
        return 1;
    }
    new query[128];
    mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `money`=`money`+%d WHERE `id`=%d LIMIT 1", money, account_id);
    mysql_tquery(mysql, query);
    return 1;
}

stock Marketplace_Send(Node:json, playerid)
{
    SendPacketToClient(playerid, MARKETPLACE_GUI_ID, json);
    return 1;
}

stock Marketplace_SendActionResult(playerid, action, success)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", action);
    JSON_SetInt(json, "err", success ? 1 : 0);
    Marketplace_Send(json, playerid);
    JSON_Cleanup(json);
    return 1;
}

stock Node:Marketplace_MakeProductNode(lot_id, item_id, item_count, amount, price, item_name[], item_type, rarity, seller_id, seller_name[], created_at, hot)
{
    new Node:item = JSON_Object();
    JSON_SetInt(item, "id", lot_id);
    JSON_SetInt(item, "tp", 0);
    JSON_SetInt(item, "tm", hot);
    JSON_SetInt(item, "ti", created_at);
    JSON_SetInt(item, "md", item_id);
    JSON_SetInt(item, "cs", price);
    JSON_SetInt(item, "ct", amount);
    Marketplace_SetJsonString(item, "dm", item_name);
    JSON_SetInt(item, "r", rarity);
    JSON_SetInt(item, "rt", rarity);
    Marketplace_SetJsonString(item, "nm", seller_name);
    JSON_SetInt(item, "sl", seller_id);
    JSON_SetInt(item, "l", 0);
    JSON_SetInt(item, "tb", created_at);
    #pragma unused item_count
    #pragma unused item_type
    return item;
}

stock Node:Marketplace_MakeInventoryProductNode(playerid, slot)
{
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new amount = Marketplace_GetSlotSellAmount(playerid, slot);
    new item_type = Marketplace_GetProductType(item_id);
    #pragma unused item_type
    new rarity = Marketplace_GetRarity(item_id);
    new item_name[64];
    Marketplace_GetInventoryName(playerid, slot, item_name, sizeof item_name);
    new Node:item = JSON_Object();
    JSON_SetInt(item, "id", slot);
    JSON_SetInt(item, "tp", 0);
    JSON_SetInt(item, "tm", 0);
    JSON_SetInt(item, "ti", gettime());
    JSON_SetInt(item, "md", item_id);
    JSON_SetInt(item, "cs", 0);
    JSON_SetInt(item, "ct", amount);
    Marketplace_SetJsonString(item, "dm", item_name);
    JSON_SetInt(item, "r", rarity);
    JSON_SetInt(item, "rt", rarity);
    new seller_buf[MAX_PLAYER_NAME];
    format(seller_buf, sizeof seller_buf, "%s", GetPlayerNameEx(playerid));
    Marketplace_SetJsonString(item, "nm", seller_buf);
    JSON_SetInt(item, "sl", GetPlayerAccountID(playerid));
    JSON_SetInt(item, "l", 0);
    JSON_SetInt(item, "tb", gettime());
    return item;
}

stock Node:Marketplace_BuildInventoryArray(playerid)
{
    new Node:products = JSON_Array();
    new added;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] <= 0) continue;
        new Node:item = Marketplace_MakeInventoryProductNode(playerid, i);
        products = JSON_Append(products, JSON_Array(item));
        added++;
    }
    return products;
}

stock Marketplace_CountInventoryProducts(playerid)
{
    new count;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0) count++;
    }
    return count;
}

stock Marketplace_SendInventoryProducts(playerid, response_type = MP_ACT_CREATE_LOT)
{
    new Node:json = JSON_Object();
    new Node:products = Marketplace_BuildInventoryArray(playerid);
    JSON_SetInt(json, "t", response_type);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "lp", Marketplace_CountInventoryProducts(playerid));
    JSON_SetInt(json, "ls", 1);
    JSON_SetArray(json, "n", products);
    Marketplace_Send(json, playerid);
    JSON_Cleanup(products);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_SendLotsRequest(playerid, response_type, tab)
{
    if(!IsPlayerLogged(playerid)) return 0;
    new where[256], order[96], query[768], escaped[96], offset;
    offset = g_MP_CurrentPage[playerid] * MARKETPLACE_MAX_PAGE_LOTS;

    if(tab == MP_TAB_MY_STORE)
    {
        mysql_format(mysql, where, sizeof(where), "WHERE `status`=0 AND `seller_id`=%d", GetPlayerAccountID(playerid));
    }
    else
    {
        mysql_format(mysql, where, sizeof(where), "WHERE `status`=0 AND `expires_at`>%d", gettime());
    }

    if(strlen(g_MP_Search[playerid]))
    {
        new where_base[256];
        format(where_base, sizeof(where_base), "%s", where);
        mysql_escape_string(g_MP_Search[playerid], escaped, mysql, sizeof(escaped));
        format(where, sizeof(where), "%s AND `item_name` LIKE '%%%s%%'", where_base, escaped);
    }

    switch(g_MP_Sort[playerid])
    {
        case 1: format(order, sizeof(order), "ORDER BY `price` ASC, `id` DESC");
        case 2: format(order, sizeof(order), "ORDER BY `price` DESC, `id` DESC");
        default: format(order, sizeof(order), "ORDER BY `is_hot` DESC, `id` DESC");
    }

    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` %s %s LIMIT %d,%d", where, order, offset, MARKETPLACE_MAX_PAGE_LOTS);
    mysql_tquery(mysql, query, "Marketplace_OnLotsLoaded", "iii", playerid, response_type, tab);
    return 1;
}

public Marketplace_OnLotsLoaded(playerid, response_type, tab)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);

    new Node:json = JSON_Object();
    new Node:products = JSON_Array();
    new pages = (rows >= MARKETPLACE_MAX_PAGE_LOTS) ? (g_MP_CurrentPage[playerid] + 2) : (g_MP_CurrentPage[playerid] + 1);

    for(new i = 0; i < rows; i++)
    {
        new item_name[64], seller_name[24];
        cache_get_field_content(i, "item_name", item_name, mysql, sizeof(item_name));
        cache_get_field_content(i, "seller_name", seller_name, mysql, sizeof(seller_name));

        new Node:item = Marketplace_MakeProductNode(
            cache_get_field_content_int(i, "id", mysql),
            cache_get_field_content_int(i, "item_id", mysql),
            cache_get_field_content_int(i, "item_count", mysql),
            cache_get_field_content_int(i, "amount", mysql),
            cache_get_field_content_int(i, "price", mysql),
            item_name,
            cache_get_field_content_int(i, "item_type", mysql),
            cache_get_field_content_int(i, "rarity", mysql),
            cache_get_field_content_int(i, "seller_id", mysql),
            seller_name,
            cache_get_field_content_int(i, "created_at", mysql),
            cache_get_field_content_int(i, "is_hot", mysql)
        );
        products = JSON_Append(products, JSON_Array(item));
    }

    if(response_type > 0) JSON_SetInt(json, "t", response_type);
    else
    {
        JSON_SetInt(json, "o", 1);
        JSON_SetInt(json, "t", MP_TAB_MAIN);
    }
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "v", 0);
    JSON_SetInt(json, "vm", 1000);
    JSON_SetInt(json, "lp", 0);
    JSON_SetInt(json, "ls", pages);
    JSON_SetArray(json, "n", products);
    #pragma unused tab
    Marketplace_Send(json, playerid);
    JSON_Cleanup(products);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_OpenGUI(playerid)
{
    if(!IsPlayerLogged(playerid)) return ShowNotificationSander(playerid, 2, 5, -1, -1, "\xc2\xfb\x20\xe4\xee\xeb\xe6\xed\xfb\x20\xe0\xe2\xf2\xee\xf0\xe8\xe7\xee\xe2\xe0\xf2\xfc\xf1\xff\x2e", "");
    g_MP_CurrentTab[playerid] = MP_TAB_MAIN;
    g_MP_CurrentPage[playerid] = 0;
    g_MP_Search[playerid][0] = EOS;
    Marketplace_SendLotsRequest(playerid, 0, MP_TAB_MAIN);
    return 1;
}

stock Marketplace_SendProfile(playerid)
{
    new query[384];
    mysql_format(mysql, query, sizeof(query), "SELECT COUNT(*) AS active_count, IFNULL(SUM((`price`*`amount`)),0) AS active_sum FROM `marketplace_lots` WHERE `seller_id`=%d AND `status`=0", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Marketplace_OnProfileLoaded", "i", playerid);
    return 1;
}

public Marketplace_OnProfileLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    new active_count, active_sum;
    if(rows)
    {
        active_count = cache_get_field_content_int(0, "active_count", mysql);
        active_sum = cache_get_field_content_int(0, "active_sum", mysql);
    }

    new Node:json = JSON_Object();
    new Node:arr = JSON_Array();
    new Node:item = JSON_Object();
    JSON_SetInt(item, "id", GetPlayerAccountID(playerid));
    new seller_buf[MAX_PLAYER_NAME];
    format(seller_buf, sizeof seller_buf, "%s", GetPlayerNameEx(playerid));
    Marketplace_SetJsonString(item, "dm", seller_buf);
    JSON_SetInt(item, "ct", active_count);
    JSON_SetInt(item, "cs", active_sum);
    JSON_SetInt(item, "ma", GetPlayerMoneyEx(playerid));
    JSON_SetInt(item, "tm", gettime());
    JSON_SetInt(item, "r", 1);
    arr = JSON_Append(arr, JSON_Array(item));

    JSON_SetInt(json, "t", MP_TAB_PROFILE);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(json, "lp", active_count);
    JSON_SetArray(json, "n", arr);
    Marketplace_Send(json, playerid);
    JSON_Cleanup(arr);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_SendHistory(playerid)
{
    new query[384];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_history` WHERE `account_id`=%d ORDER BY `id` DESC LIMIT %d", GetPlayerAccountID(playerid), MARKETPLACE_MAX_PAGE_LOTS);
    mysql_tquery(mysql, query, "Marketplace_OnHistoryLoaded", "i", playerid);
    return 1;
}

public Marketplace_OnHistoryLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    new Node:json = JSON_Object();
    new Node:history = JSON_Array();
    for(new i = 0; i < rows; i++)
    {
        new item_name[64], seller_name[24];
        cache_get_field_content(i, "item_name", item_name, mysql, sizeof(item_name));
        cache_get_field_content(i, "seller_name", seller_name, mysql, sizeof(seller_name));
        new Node:item = Marketplace_MakeProductNode(
            cache_get_field_content_int(i, "lot_id", mysql),
            cache_get_field_content_int(i, "item_id", mysql),
            cache_get_field_content_int(i, "amount", mysql),
            cache_get_field_content_int(i, "amount", mysql),
            cache_get_field_content_int(i, "price", mysql),
            item_name,
            Marketplace_GetProductType(cache_get_field_content_int(i, "item_id", mysql)),
            Marketplace_GetRarity(cache_get_field_content_int(i, "item_id", mysql)),
            0,
            seller_name,
            cache_get_field_content_int(i, "created_at", mysql),
            0
        );
        history = JSON_Append(history, JSON_Array(item));
    }
    JSON_SetInt(json, "t", MP_TAB_HISTORY);
    JSON_SetInt(json, "ls", 1);
    JSON_SetArray(json, "n", history);
    Marketplace_Send(json, playerid);
    JSON_Cleanup(history);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_SelectInventorySlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS || g_PlayerInventory[playerid][slot][inv_itemId] <= 0)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_SELECT_INV_ITEM, 0);
        return 0;
    }
    g_MP_SelectedSlot[playerid] = slot;
    g_MP_SelectedSellCount[playerid] = 1;

    new Node:json = JSON_Object();
    new Node:item = Marketplace_MakeInventoryProductNode(playerid, slot);
    JSON_SetInt(json, "t", MP_ACT_SELECT_INV_ITEM);
    JSON_SetInt(json, "err", 1);
    JSON_SetInt(json, "rk", Marketplace_GetRarity(g_PlayerInventory[playerid][slot][inv_itemId]));
    JSON_SetInt(json, "id", slot);
    JSON_SetInt(json, "md", g_PlayerInventory[playerid][slot][inv_itemId]);
    JSON_SetInt(json, "ct", Marketplace_GetSlotSellAmount(playerid, slot));
    JSON_SetInt(json, "cs", 0);
    new item_name[64];
    Marketplace_GetInventoryName(playerid, slot, item_name, sizeof item_name);
    Marketplace_SetJsonString(json, "dm", item_name);
    new Node:arr = JSON_Array(item);
    JSON_SetArray(json, "n", arr);
    Marketplace_Send(json, playerid);
    JSON_Cleanup(arr);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_PublishSelected(playerid, amount, price, hot)
{
    new slot = g_MP_SelectedSlot[playerid];
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS || g_PlayerInventory[playerid][slot][inv_itemId] <= 0)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_PUBLISH_LOT, 0);
        return 0;
    }
    if(price < MARKETPLACE_MIN_PRICE || price > MARKETPLACE_MAX_PRICE)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_PUBLISH_LOT, 0);
        return 0;
    }

    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new max_amount = Marketplace_GetSlotSellAmount(playerid, slot);
    if(amount < 1) amount = 1;
    if(amount > max_amount) amount = max_amount;
    if(Marketplace_IsSpecialItem(item_id)) amount = 1;

    new inv_count = g_PlayerInventory[playerid][slot][inv_itemCount];
    new item_plate[32], item_name[64], seller_name[MAX_PLAYER_NAME];
    item_plate[0] = EOS;
    Marketplace_GetInventoryName(playerid, slot, item_name, sizeof item_name);
    format(seller_name, sizeof(seller_name), "%s", GetPlayerNameEx(playerid));

    new item_type = Marketplace_GetProductType(item_id);
    new rarity = Marketplace_GetRarity(item_id);
    new created = gettime();
    new expires = created + MARKETPLACE_DEFAULT_EXPIRE;
    new query[1024];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `marketplace_lots` (`seller_id`,`seller_name`,`item_id`,`item_count`,`amount`,`item_plate`,`item_name`,`item_type`,`rarity`,`price`,`is_hot`,`status`,`created_at`,`expires_at`) VALUES (%d,'%e',%d,%d,%d,'%e','%e',%d,%d,%d,%d,0,%d,%d)", GetPlayerAccountID(playerid), seller_name, item_id, inv_count, amount, item_plate, item_name, item_type, rarity, price, hot ? 1 : 0, created, expires);
    new Cache:insert_result = mysql_query(mysql, query, true);
    new inserted_lot_id = cache_insert_id();
    cache_delete(insert_result);

    if(inserted_lot_id <= 0)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_PUBLISH_LOT, 0);
        ShowNotificationSander(playerid, 2, 5, -1, -1, "\xcb\xee\xf2\x20\xed\xe5\x20\xe2\xfb\xf1\xf2\xe0\xe2\xeb\xe5\xed\x2e\x20\xcf\xf0\xe5\xe4\xec\xe5\xf2\x20\xee\xf1\xf2\xe0\xeb\xf1\xff\x20\xe2\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xe5\x2e", "");
        return 0;
    }

    if(Marketplace_IsSpecialItem(item_id) || amount >= max_amount) Inventory_DeleteItem(playerid, slot);
    else Inventory_RemoveItem(playerid, slot, amount);

    g_MP_SelectedSlot[playerid] = -1;
    g_MP_SelectedSellCount[playerid] = 1;
    Marketplace_SendActionResult(playerid, MP_ACT_PUBLISH_LOT, 1);
    Marketplace_SendInventoryProducts(playerid, MP_ACT_CREATE_LOT);
    ShowNotificationSander(playerid, 1, 5, -1, -1, "\xcb\xee\xf2\x20\xe2\xfb\xf1\xf2\xe0\xe2\xeb\xe5\xed\x20\xed\xe0\x20\xef\xf0\xee\xe4\xe0\xe6\xf3\x2e", "");
    return 1;
}

stock Marketplace_RequestBuy(playerid, lot_id)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `id`=%d AND `status`=0 AND `expires_at`>%d LIMIT 1", lot_id, gettime());
    mysql_tquery(mysql, query, "Marketplace_OnBuyInfoLoaded", "ii", playerid, lot_id);
    return 1;
}

public Marketplace_OnBuyInfoLoaded(playerid, lot_id)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(!rows)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_BUY_CLICK, 0);
        return 0;
    }
    new item_name[64];
    cache_get_field_content(0, "item_name", item_name, mysql, sizeof(item_name));
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", MP_ACT_BUY_CLICK);
    JSON_SetInt(json, "id", lot_id);
    JSON_SetInt(json, "md", cache_get_field_content_int(0, "item_id", mysql));
    JSON_SetInt(json, "cs", cache_get_field_content_int(0, "price", mysql));
    JSON_SetInt(json, "sl", cache_get_field_content_int(0, "seller_id", mysql));
    JSON_SetInt(json, "ct", cache_get_field_content_int(0, "amount", mysql));
    Marketplace_SetJsonString(json, "dm", item_name);
    Marketplace_Send(json, playerid);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_ConfirmBuy(playerid, lot_id, amount)
{
    if(amount < 1) amount = 1;
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `id`=%d AND `status`=0 AND `expires_at`>%d LIMIT 1", lot_id, gettime());
    mysql_tquery(mysql, query, "Marketplace_OnConfirmBuyLoaded", "iii", playerid, lot_id, amount);
    return 1;
}

public Marketplace_OnConfirmBuyLoaded(playerid, lot_id, amount)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(!rows)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_BUY, 0);
        return 0;
    }

    new seller_id = cache_get_field_content_int(0, "seller_id", mysql);
    if(seller_id == GetPlayerAccountID(playerid))
    {
        Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_BUY, 0);
        ShowNotificationSander(playerid, 2, 5, -1, -1, "\xcd\xe5\xeb\xfc\xe7\xff\x20\xea\xf3\xef\xe8\xf2\xfc\x20\xf1\xe2\xee\xe9\x20\xeb\xee\xf2\x2e", "");
        return 0;
    }

    new lot_amount = cache_get_field_content_int(0, "amount", mysql);
    if(amount > lot_amount) amount = lot_amount;
    if(amount < 1) amount = 1;

    new price = cache_get_field_content_int(0, "price", mysql);
    new total_price = price * amount;
    if(GetPlayerMoneyEx(playerid) < total_price)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_BUY, 0);
        ShowNotificationSander(playerid, 2, 5, -1, -1, "\xcd\xe5\xe4\xee\xf1\xf2\xe0\xf2\xee\xf7\xed\xee\x20\xe4\xe5\xed\xe5\xe3\x2e", "");
        return 0;
    }

    new freeSlot = Inventory_GetFreeSlot(playerid);

    new item_id = cache_get_field_content_int(0, "item_id", mysql);
    new inv_count = cache_get_field_content_int(0, "item_count", mysql);
    new plate[32], item_name[64], seller_name[24], buyer_name[24];
    cache_get_field_content(0, "item_plate", plate, mysql, sizeof(plate));
    cache_get_field_content(0, "item_name", item_name, mysql, sizeof(item_name));
    cache_get_field_content(0, "seller_name", seller_name, mysql, sizeof(seller_name));
    format(buyer_name, sizeof(buyer_name), "%s", GetPlayerNameEx(playerid));

    if(!Marketplace_IsSpecialItem(item_id)) inv_count = amount;

    new bool:queued_to_reward = false;
    if(freeSlot == -1)
    {
        if(MPReward_QueueInvItem(GetPlayerAccountID(playerid), item_id, inv_count, plate, item_name, lot_id) <= 0)
        {
            Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_BUY, 0);
            ShowNotificationSander(playerid, 2, 5, -1, -1, "\xcd\xe5\xf2\x20\xf1\xe2\xee\xe1\xee\xe4\xed\xee\xe3\xee\x20\xec\xe5\xf1\xf2\xe0\x20\xe2\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xe5\x2c\x20\xee\xf2\xef\xf0\xe0\xe2\xea\xe0\x20\xe2\x20\x2f\x72\x65\x77\x61\x72\x64\x20\xed\xe5\x20\xf3\xe4\xe0\xeb\xe0\xf1\xfc\x2e", "");
            return 0;
        }
        queued_to_reward = true;
    }
    else
    {
        Inventory_AddItem(playerid, item_id, freeSlot, inv_count, plate);
    }

    GivePlayerMoneyEx(playerid, -total_price, "Marketplace buy", true, true);

    new seller_money = total_price - ((total_price * MARKETPLACE_SELL_TAX) / 100);
    Marketplace_AddMoneyToAccount(seller_id, seller_money);

    new query[1024];
    if(amount >= lot_amount)
    {
        mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `status`=1,`buyer_id`=%d WHERE `id`=%d LIMIT 1", GetPlayerAccountID(playerid), lot_id);
    }
    else
    {
        mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `amount`=`amount`-%d WHERE `id`=%d LIMIT 1", amount, lot_id);
    }
    mysql_tquery(mysql, query);

    mysql_format(mysql, query, sizeof(query), "INSERT INTO `marketplace_history` (`account_id`,`lot_id`,`item_id`,`amount`,`price`,`status`,`seller_name`,`buyer_name`,`item_name`,`created_at`) VALUES (%d,%d,%d,%d,%d,1,'%e','%e','%e',%d),(%d,%d,%d,%d,%d,2,'%e','%e','%e',%d)", GetPlayerAccountID(playerid), lot_id, item_id, amount, total_price, seller_name, buyer_name, item_name, gettime(), seller_id, lot_id, item_id, amount, total_price, seller_name, buyer_name, item_name, gettime());
    mysql_tquery(mysql, query);

    Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_BUY, 1);
    Marketplace_SendLotsRequest(playerid, MP_TAB_MAIN, MP_TAB_MAIN);
    if(queued_to_reward) ShowNotificationSander(playerid, 1, 5, -1, -1, "\xcf\xf0\xe5\xe4\xec\xe5\xf2\x20\xea\xf3\xef\xeb\xe5\xed\x2e\x20\xc8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc\x20\xe7\xe0\xef\xee\xeb\xed\xe5\xed\x2c\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\x20\xee\xf2\xef\xf0\xe0\xe2\xeb\xe5\xed\x20\xe2\x20\x2f\x72\x65\x77\x61\x72\x64\x2e", "");
    else ShowNotificationSander(playerid, 1, 5, -1, -1, "\xcf\xf0\xe5\xe4\xec\xe5\xf2\x20\xea\xf3\xef\xeb\xe5\xed\x2e\x20\xcf\xf0\xee\xe2\xe5\xf0\xfc\xf2\xe5\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc\x2e", "");
    return 1;
}

stock Marketplace_DeleteOrWithdrawLot(playerid, lot_id)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `id`=%d AND `seller_id`=%d AND `status`=0 LIMIT 1", lot_id, GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Marketplace_OnWithdrawLoaded", "ii", playerid, lot_id);
    return 1;
}

public Marketplace_OnWithdrawLoaded(playerid, lot_id)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(!rows)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_DELETE_LOT, 0);
        return 0;
    }

    new freeSlot = Inventory_GetFreeSlot(playerid);

    new item_id = cache_get_field_content_int(0, "item_id", mysql);
    new inv_count = cache_get_field_content_int(0, "item_count", mysql);
    new amount = cache_get_field_content_int(0, "amount", mysql);
    new plate[32];
    cache_get_field_content(0, "item_plate", plate, mysql, sizeof(plate));
    if(!Marketplace_IsSpecialItem(item_id)) inv_count = amount;

    new bool:returned_to_reward = false;
    if(freeSlot == -1)
    {
        new item_name[64];
        cache_get_field_content(0, "item_name", item_name, mysql, sizeof(item_name));
        if(MPReward_QueueInvItem(GetPlayerAccountID(playerid), item_id, inv_count, plate, item_name, lot_id) <= 0)
        {
            Marketplace_SendActionResult(playerid, MP_ACT_DELETE_LOT, 0);
            ShowNotificationSander(playerid, 2, 5, -1, -1, "\xcd\xe5\xf2\x20\xf1\xe2\xee\xe1\xee\xe4\xed\xee\xe3\xee\x20\xec\xe5\xf1\xf2\xe0\x20\xe2\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xe5\x2c\x20\xee\xf2\xef\xf0\xe0\xe2\xea\xe0\x20\xe2\x20\x2f\x72\x65\x77\x61\x72\x64\x20\xed\xe5\x20\xf3\xe4\xe0\xeb\xe0\xf1\xfc\x2e", "");
            return 0;
        }
        returned_to_reward = true;
    }
    else
    {
        Inventory_AddItem(playerid, item_id, freeSlot, inv_count, plate);
    }

    new query[160];
    mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `status`=2 WHERE `id`=%d LIMIT 1", lot_id);
    mysql_tquery(mysql, query);

    Marketplace_SendActionResult(playerid, MP_ACT_DELETE_LOT, 1);
    Marketplace_SendLotsRequest(playerid, MP_TAB_MY_STORE, MP_TAB_MY_STORE);
    if(returned_to_reward) ShowNotificationSander(playerid, 1, 5, -1, -1, "\xcb\xee\xf2\x20\xf1\xed\xff\xf2\x2e\x20\xc8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc\x20\xe7\xe0\xef\xee\xeb\xed\xe5\xed\x2c\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\x20\xee\xf2\xef\xf0\xe0\xe2\xeb\xe5\xed\x20\xe2\x20\x2f\x72\x65\x77\x61\x72\x64\x2e", "");
    else ShowNotificationSander(playerid, 1, 5, -1, -1, "\xcb\xee\xf2\x20\xf1\xed\xff\xf2\x20\xe8\x20\xe2\xee\xe7\xe2\xf0\xe0\xf9\xb8\xed\x20\xe2\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc\x2e", "");
    return 1;
}

stock Marketplace_EditLot(playerid, lot_id, price)
{
    if(price < MARKETPLACE_MIN_PRICE || price > MARKETPLACE_MAX_PRICE)
    {
        Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_EDIT, 0);
        return 0;
    }
    new query[256];
    mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `price`=%d WHERE `id`=%d AND `seller_id`=%d AND `status`=0 LIMIT 1", price, lot_id, GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);
    Marketplace_SendActionResult(playerid, MP_ACT_CONFIRM_EDIT, 1);
    Marketplace_SendLotsRequest(playerid, MP_TAB_MY_STORE, MP_TAB_MY_STORE);
    return 1;
}

stock Marketplace_OnPacket(playerid, Node:json)
{
    new type;
    JSON_GetInt(json, "t", type);

    switch(type)
    {
        case MP_TAB_PROFILE: Marketplace_SendProfile(playerid);
        case MP_TAB_MAIN:
        {
            g_MP_CurrentTab[playerid] = MP_TAB_MAIN;
            g_MP_CurrentPage[playerid] = 0;
            g_MP_Search[playerid][0] = EOS;
            Marketplace_SendLotsRequest(playerid, MP_TAB_MAIN, MP_TAB_MAIN);
        }
        case MP_TAB_HISTORY: Marketplace_SendHistory(playerid);
        case MP_TAB_FAVORITES:
        {
            g_MP_CurrentTab[playerid] = MP_TAB_FAVORITES;
            Marketplace_SendLotsRequest(playerid, MP_TAB_FAVORITES, MP_TAB_MAIN);
        }
        case MP_TAB_MY_STORE:
        {
            g_MP_CurrentTab[playerid] = MP_TAB_MY_STORE;
            g_MP_CurrentPage[playerid] = 0;
            Marketplace_SendLotsRequest(playerid, MP_TAB_MY_STORE, MP_TAB_MY_STORE);
        }
        case MP_TAB_INVENTORY:
        {
            g_MP_CurrentTab[playerid] = MP_TAB_INVENTORY;
            Marketplace_SendInventoryProducts(playerid, MP_TAB_INVENTORY);
        }
        case MP_ACT_PAGE:
        {
            new page;
            JSON_GetInt(json, "lt", page);
            if(page < 0) page = 0;
            g_MP_CurrentPage[playerid] = page;
            Marketplace_SendLotsRequest(playerid, MP_ACT_PAGE, g_MP_CurrentTab[playerid]);
        }
        case MP_ACT_CREATE_LOT: Marketplace_SendInventoryProducts(playerid, MP_ACT_CREATE_LOT);
        case MP_ACT_SELECT_INV_ITEM:
        {
            new slot;
            JSON_GetInt(json, "id", slot);
            Marketplace_SelectInventorySlot(playerid, slot);
        }
        case MP_ACT_PUBLISH_LOT:
        {
            new amount, price, hot;
            JSON_GetInt(json, "ct", amount);
            JSON_GetInt(json, "cs", price);
            JSON_GetInt(json, "rs", hot);
            Marketplace_PublishSelected(playerid, amount, price, hot);
        }
        case MP_ACT_BUY_CLICK:
        {
            new lot_id;
            JSON_GetInt(json, "id", lot_id);
            g_MP_SelectedLot[playerid] = lot_id;
            Marketplace_RequestBuy(playerid, lot_id);
        }
        case MP_ACT_CONFIRM_BUY:
        {
            new lot_id, amount;
            JSON_GetInt(json, "id", lot_id);
            JSON_GetInt(json, "ct", amount);
            Marketplace_ConfirmBuy(playerid, lot_id, amount);
        }
        case MP_ACT_EDIT_LOT:
        {
            new lot_id;
            JSON_GetInt(json, "id", lot_id);
            g_MP_SelectedLot[playerid] = lot_id;
            Marketplace_RequestBuy(playerid, lot_id);
        }
        case MP_ACT_CONFIRM_EDIT:
        {
            new price, hot;
            JSON_GetInt(json, "cs", price);
            JSON_GetInt(json, "rs", hot);
            #pragma unused hot
            Marketplace_EditLot(playerid, g_MP_SelectedLot[playerid], price);
        }
        case MP_ACT_DELETE_LOT:
        {
            Marketplace_DeleteOrWithdrawLot(playerid, g_MP_SelectedLot[playerid]);
        }
        case MP_ACT_HISTORY_CARD:
        {
            new lot_id;
            JSON_GetInt(json, "id", lot_id);
            Marketplace_RequestBuy(playerid, lot_id);
        }
        case MP_ACT_SEARCH:
        {
            JSON_GetString(json, "s", g_MP_Search[playerid], 64);
            g_MP_CurrentPage[playerid] = 0;
            Marketplace_SendLotsRequest(playerid, MP_ACT_SEARCH, MP_TAB_MAIN);
        }
        case MP_ACT_SORT:
        {
            new sort;
            JSON_GetInt(json, "st", sort);
            g_MP_Sort[playerid] = sort;
            Marketplace_SendLotsRequest(playerid, MP_ACT_SORT, g_MP_CurrentTab[playerid]);
        }
        case MP_ACT_LIKE:
        {
            Marketplace_SendActionResult(playerid, MP_ACT_LIKE, 1);
        }
        case MP_ACT_BUY_VIP, MP_ACT_DONATE, MP_ACT_NOTIFY_VIP:
        {
            Marketplace_SendActionResult(playerid, type, 0);
        }
        default:
        {
            Marketplace_SendLotsRequest(playerid, MP_TAB_MAIN, MP_TAB_MAIN);
        }
    }
    return 1;
}

CMD:marketplace(playerid, params[])
{
    #pragma unused params
    Marketplace_OpenGUI(playerid);
    return 1;
}

stock Marketplace_ShowDialogMain(playerid)
{
    ShowPlayerDialog(playerid, MP_DIALOG_MAIN, DIALOG_STYLE_LIST, "\xcc\xe0\xf0\xea\xe5\xf2\xef\xeb\xe5\xe9\xf1", "\xce\xf2\xea\xf0\xfb\xf2\xfc\x20\x47\x55\x49\n\xca\xf3\xef\xe8\xf2\xfc\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\xfb\n\xcf\xf0\xee\xe4\xe0\xf2\xfc\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\x20\xe8\xe7\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xff\n\xcc\xee\xe8\x20\xeb\xee\xf2\xfb\n\xcf\xee\xe8\xf1\xea", "\xc2\xfb\xe1\xf0\xe0\xf2\xfc", "\xc7\xe0\xea\xf0\xfb\xf2\xfc");
    return 1;
}

CMD:marketd(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "\xc2\xfb\x20\xe4\xee\xeb\xe6\xed\xfb\x20\xe0\xe2\xf2\xee\xf0\xe8\xe7\xee\xe2\xe0\xf2\xfc\xf1\xff\x2e");
    Marketplace_ShowDialogMain(playerid);
    return 1;
}

stock Marketplace_ShowDialogLots(playerid, my_lots = 0)
{
    new query[384];
    if(my_lots)
    {
        mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `seller_id`=%d AND `status`=0 ORDER BY `id` DESC LIMIT 30", GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "Marketplace_OnDialogLots", "ii", playerid, 1);
    }
    else
    {
        mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `status`=0 AND `expires_at`>%d ORDER BY `is_hot` DESC, `id` DESC LIMIT 30", gettime());
        mysql_tquery(mysql, query, "Marketplace_OnDialogLots", "ii", playerid, 0);
    }
    return 1;
}

public Marketplace_OnDialogLots(playerid, my_lots)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    new list[2048];
    list[0] = EOS;
    if(!rows) strcat(list, "\xcb\xee\xf2\xee\xe2\x20\xed\xe5\xf2\n", sizeof(list));
    for(new i = 0; i < rows && i < 30; i++)
    {
        new lot_id = cache_get_field_content_int(i, "id", mysql);
        new amount = cache_get_field_content_int(i, "amount", mysql);
        new price = cache_get_field_content_int(i, "price", mysql);
        new item_name[64], lot_line[128];
        cache_get_field_content(i, "item_name", item_name, mysql, sizeof item_name);
        format(lot_line, sizeof lot_line, "#%d %s x%d - %d rub\n", lot_id, item_name, amount, price);
        strcat(list, lot_line, sizeof list);
    }
    ShowPlayerDialog(playerid, my_lots ? MP_DIALOG_MYLOTS : MP_DIALOG_LOTS, DIALOG_STYLE_LIST, my_lots ? "\xcc\xee\xe8\x20\xeb\xee\xf2\xfb" : "\xcb\xee\xf2\xfb\x20\xec\xe0\xf0\xea\xe5\xf2\xef\xeb\xe5\xe9\xf1\xe0", list, "\xc2\xfb\xe1\xf0\xe0\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
    return 1;
}

stock Marketplace_ShowInventoryDialog(playerid)
{
    new list[2048];
    list[0] = EOS;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] <= 0) continue;
        new mp_inv_line[128], mp_inv_name[64], amount = Marketplace_GetSlotSellAmount(playerid, i);
        Marketplace_GetInventoryName(playerid, i, mp_inv_name, sizeof mp_inv_name);
        format(mp_inv_line, sizeof(mp_inv_line), "slot %d: %s x%d\n", i, mp_inv_name, amount);
        strcat(list, mp_inv_line, sizeof(list));
    }
    if(!strlen(list)) strcat(list, "\xc8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc \xef\xf3\xf1\xf2\n", sizeof(list));
    ShowPlayerDialog(playerid, MP_DIALOG_INV, DIALOG_STYLE_LIST, "\xcf\xf0\xee\xe4\xe0\xe6\xe0\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\xe0\x20\xe8\xe7\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xff", list, "\xcf\xf0\xee\xe4\xe0\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
    return 1;
}

stock Marketplace_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == MP_DIALOG_MAIN)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: Marketplace_OpenGUI(playerid);
            case 1: Marketplace_ShowDialogLots(playerid, 0);
            case 2: Marketplace_ShowInventoryDialog(playerid);
            case 3: Marketplace_ShowDialogLots(playerid, 1);
            case 4: ShowPlayerDialog(playerid, MP_DIALOG_SEARCH, DIALOG_STYLE_INPUT, "\xcf\xee\xe8\xf1\xea\x20\xe2\x20\xec\xe0\xf0\xea\xe5\xf2\xef\xeb\xe5\xe9\xf1\xe5", "\xc2\xe2\xe5\xe4\xe8\xf2\xe5\x20\xed\xe0\xe7\xe2\xe0\xed\xe8\xe5\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\xe0\x3a", "\xcf\xee\xe8\xf1\xea", "\xcd\xe0\xe7\xe0\xe4");
        }
        return 1;
    }
    if(dialogid == MP_DIALOG_LOTS)
    {
        if(!response) return Marketplace_ShowDialogMain(playerid);
        new lot_id;
        if(sscanf(inputtext, "p<#>i", lot_id)) return 1;
        g_MP_SelectedLot[playerid] = lot_id;
        ShowPlayerDialog(playerid, MP_DIALOG_LOT_ACTION, DIALOG_STYLE_INPUT, "\xcf\xee\xea\xf3\xef\xea\xe0\x20\xeb\xee\xf2\xe0", "\xc2\xe2\xe5\xe4\xe8\xf2\xe5\x20\xea\xee\xeb\xe8\xf7\xe5\xf1\xf2\xe2\xee\x20\xe4\xeb\xff\x20\xef\xee\xea\xf3\xef\xea\xe8\x3a", "\xca\xf3\xef\xe8\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
        return 1;
    }
    if(dialogid == MP_DIALOG_LOT_ACTION)
    {
        if(!response) return Marketplace_ShowDialogLots(playerid, 0);
        new amount = strval(inputtext);
        if(amount < 1) amount = 1;
        Marketplace_ConfirmBuy(playerid, g_MP_SelectedLot[playerid], amount);
        return 1;
    }
    if(dialogid == MP_DIALOG_INV)
    {
        if(!response) return Marketplace_ShowDialogMain(playerid);
        new slot = -1;
        if(strfind(inputtext, "slot ", true) == 0)
        {
            new colon = strfind(inputtext, ":", true), tmp[12];
            if(colon != -1)
            {
                strmid(tmp, inputtext, 5, colon, sizeof(tmp));
                slot = strval(tmp);
            }
        }
        if(slot < 0 || slot >= MAX_INVENTORY_SLOTS || g_PlayerInventory[playerid][slot][inv_itemId] <= 0) return 1;
        g_MP_SelectedSlot[playerid] = slot;
        ShowPlayerDialog(playerid, MP_DIALOG_SELL_COUNT, DIALOG_STYLE_INPUT, "\xca\xee\xeb\xe8\xf7\xe5\xf1\xf2\xe2\xee\x20\xe4\xeb\xff\x20\xef\xf0\xee\xe4\xe0\xe6\xe8", "\xc2\xe2\xe5\xe4\xe8\xf2\xe5\x20\xea\xee\xeb\xe8\xf7\xe5\xf1\xf2\xe2\xee\x3a", "\xc4\xe0\xeb\xe5\xe5", "\xcd\xe0\xe7\xe0\xe4");
        return 1;
    }
    if(dialogid == MP_DIALOG_SELL_COUNT)
    {
        if(!response) return Marketplace_ShowInventoryDialog(playerid);
        new amount = strval(inputtext), max_amount = Marketplace_GetSlotSellAmount(playerid, g_MP_SelectedSlot[playerid]);
        if(amount < 1) amount = 1;
        if(amount > max_amount) amount = max_amount;
        g_MP_SelectedSellCount[playerid] = amount;
        ShowPlayerDialog(playerid, MP_DIALOG_SELL_PRICE, DIALOG_STYLE_INPUT, "\xd6\xe5\xed\xe0\x20\xef\xf0\xee\xe4\xe0\xe6\xe8", "\xc2\xe2\xe5\xe4\xe8\xf2\xe5\x20\xf6\xe5\xed\xf3\x20\xe7\xe0\x20\x31\x20\xef\xf0\xe5\xe4\xec\xe5\xf2\x3a", "\xc2\xfb\xf1\xf2\xe0\xe2\xe8\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
        return 1;
    }
    if(dialogid == MP_DIALOG_SELL_PRICE)
    {
        if(!response) return Marketplace_ShowInventoryDialog(playerid);
        new price = strval(inputtext);
        Marketplace_PublishSelected(playerid, g_MP_SelectedSellCount[playerid], price, 0);
        return 1;
    }
    if(dialogid == MP_DIALOG_MYLOTS)
    {
        if(!response) return Marketplace_ShowDialogMain(playerid);
        new lot_id;
        if(sscanf(inputtext, "p<#>i", lot_id)) return 1;
        g_MP_SelectedLot[playerid] = lot_id;
        ShowPlayerDialog(playerid, MP_DIALOG_MYLOT_ACTION, DIALOG_STYLE_LIST, "\xcc\xee\xe9\x20\xeb\xee\xf2", "\xd1\xed\xff\xf2\xfc\x20\xe2\x20\xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc\n\xc8\xe7\xec\xe5\xed\xe8\xf2\xfc\x20\xf6\xe5\xed\xf3", "\xc2\xfb\xe1\xf0\xe0\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
        return 1;
    }
    if(dialogid == MP_DIALOG_MYLOT_ACTION)
    {
        if(!response) return Marketplace_ShowDialogLots(playerid, 1);
        if(listitem == 0) Marketplace_DeleteOrWithdrawLot(playerid, g_MP_SelectedLot[playerid]);
        else ShowPlayerDialog(playerid, MP_DIALOG_EDIT_PRICE, DIALOG_STYLE_INPUT, "\xcd\xee\xe2\xe0\xff\x20\xf6\xe5\xed\xe0", "\xc2\xe2\xe5\xe4\xe8\xf2\xe5\x20\xed\xee\xe2\xf3\xfe\x20\xf6\xe5\xed\xf3\x3a", "\xd1\xee\xf5\xf0\xe0\xed\xe8\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
        return 1;
    }
    if(dialogid == MP_DIALOG_EDIT_PRICE)
    {
        if(!response) return Marketplace_ShowDialogLots(playerid, 1);
        new price = strval(inputtext);
        Marketplace_EditLot(playerid, g_MP_SelectedLot[playerid], price);
        return 1;
    }
    if(dialogid == MP_DIALOG_SEARCH)
    {
        if(!response) return Marketplace_ShowDialogMain(playerid);
        format(g_MP_Search[playerid], 64, "%s", inputtext);
        Marketplace_SendLotsRequest(playerid, MP_ACT_SEARCH, MP_TAB_MAIN);
        Marketplace_ShowDialogLots(playerid, 0);
        return 1;
    }
    return 0;
}
