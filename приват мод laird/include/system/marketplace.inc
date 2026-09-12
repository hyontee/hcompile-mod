#if defined _marketplace_included
    #endinput
#endif
#define _marketplace_included

#define MARKETPLACE_SCREEN_ID                              (77)

#define MARKETPLACE_PROFILE_TAB_VALUE                       (1)
#define MARKETPLACE_MAIN_TAB_VALUE                          (2)
#define MARKETPLACE_HISTORY_TAB_VALUE                       (3)
#define MARKETPLACE_FAVORITES_TAB_VALUE                     (4)
#define MARKETPLACE_MY_STORE_TAB_VALUE                      (5)
#define MARKETPLACE_INVENTORY_TAB_VALUE                     (6)

#define MARKETPLACE_OPEN_DONAT_VALUE                        (7)
#define MARKETPLACE_FILTER_VALUE                            (8)
#define MARKETPLACE_CLICK_PLUS_VALUE                        (9)
#define MARKETPLACE_ADD_PRODUCT_VALUE                       (10)
#define MARKETPLACE_CONFIRM_PUBLISH_PRODUCT_LOT_VALUE       (11)
#define MARKETPLACE_BUY_VALUE                               (12)
#define MARKETPLACE_CONFIRM_BUY_VALUE                       (13)
#define MARKETPLACE_LIKE_VALUE                              (14)
#define MARKETPLACE_EDIT_PRODUCT_LOT_VALUE                  (15)
#define MARKETPLACE_CONFIRM_EDIT_PRODUCT_LOT_VALUE          (16)
#define MARKETPLACE_DELETE_PRODUCT_LOT_VALUE                (17)
#define MARKETPLACE_HISTORY_ACTION_VALUE                    (18)
#define MARKETPLACE_SEARCH_BAR_VALUE                        (19)
#define MARKETPLACE_VIP_PLATINUM_BUY_VALUE                  (20)
#define MARKETPLACE_SORT_VALUE                              (21)

#define MARKETPLACE_STATUS_ACTIVE                           (0)
#define MARKETPLACE_STATUS_PURCHASED                        (1)
#define MARKETPLACE_STATUS_SOLD                              (2)

#define MARKETPLACE_MIN_PRICE                                (100)
#define MARKETPLACE_MAX_PRICE                                (999999999)
#define MARKETPLACE_MAX_COUNT                                (999)
#define MARKET_ITEMS_PER_PAGE                                (20)

new g_MktPendingSlot[MAX_PLAYERS];
new g_MktPendingItem[MAX_PLAYERS];
new g_MktPendingModel[MAX_PLAYERS];
new g_MktPendingExtra1[MAX_PLAYERS];
new g_MktPendingExtra2[MAX_PLAYERS];
new g_MktPendingAvail[MAX_PLAYERS];
new g_MktCurrentTab[MAX_PLAYERS];

stock Marketplace_OnConnect(playerid)
{
    g_MktPendingSlot[playerid] = -1;
    g_MktCurrentTab[playerid] = MARKETPLACE_MAIN_TAB_VALUE;
    return 1;
}

stock Marketplace_ResetPending(playerid)
{
    g_MktPendingSlot[playerid] = -1;
    g_MktPendingItem[playerid] = 0;
    g_MktPendingModel[playerid] = 0;
    g_MktPendingExtra1[playerid] = 0;
    g_MktPendingExtra2[playerid] = 0;
    g_MktPendingAvail[playerid] = 0;
    return 1;
}

stock Marketplace_ItemName(itemid, name[], len)
{
    switch(itemid)
    {
        case 22:  format(name, len, "Аптечка");
        case 58:  format(name, len, "SIM-карта");
        case 134: format(name, len, "Скин персонажа");
        default:  format(name, len, "Предмет #%d", itemid);
    }
    return 1;
}

stock Marketplace_FindOnlinePlayerByAccountID(account_id)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPlayerAccountID(i) == account_id)
        {
            return i;
        }
    }
    return INVALID_PLAYER_ID;
}

stock Marketplace_Ack(playerid, type, success)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", type);
    JSON_SetInt(response, "s", success);
    OnPacketIncoming(playerid, MARKETPLACE_SCREEN_ID, response);
    JSON_Cleanup(response);
    return 1;
}

stock Marketplace_HandlePacket(playerid, JSON:json)
{
    new type = -1;
    JSON_GetInt(json, "t", type);

    new page_requested = -1;
    new bool:is_pagination = (type == MARKETPLACE_INVENTORY_TAB_VALUE && JSON_GetInt(json, "lt", page_requested));

    if(is_pagination)
    {
        Marketplace_SendTab(playerid, g_MktCurrentTab[playerid], page_requested);
        return 1;
    }

    switch(type)
    {
        case MARKETPLACE_PROFILE_TAB_VALUE,
             MARKETPLACE_MAIN_TAB_VALUE,
             MARKETPLACE_HISTORY_TAB_VALUE,
             MARKETPLACE_FAVORITES_TAB_VALUE,
             MARKETPLACE_MY_STORE_TAB_VALUE,
             MARKETPLACE_INVENTORY_TAB_VALUE:
        {
            g_MktCurrentTab[playerid] = type;
            Marketplace_SendTab(playerid, type, 1);
        }

        case MARKETPLACE_OPEN_DONAT_VALUE:
        {
            Marketplace_Ack(playerid, type, 1);
        }

        case MARKETPLACE_FILTER_VALUE:
        {
            Marketplace_Ack(playerid, type, 1);
        }

        case MARKETPLACE_CLICK_PLUS_VALUE:
        {
            Marketplace_ShowSellPicker(playerid);
        }

        case MARKETPLACE_ADD_PRODUCT_VALUE:
        {
            Marketplace_OnPickItemToSell(playerid, json);
        }

        case MARKETPLACE_CONFIRM_PUBLISH_PRODUCT_LOT_VALUE:
        {
            Marketplace_OnConfirmPublish(playerid, json);
        }

        case MARKETPLACE_BUY_VALUE:
        {
            new lotId = 0;
            JSON_GetInt(json, "id", lotId);
            Marketplace_ShowBuyConfirm(playerid, lotId);
        }

        case MARKETPLACE_CONFIRM_BUY_VALUE:
        {
            Marketplace_OnConfirmBuy(playerid, json);
        }

        case MARKETPLACE_DELETE_PRODUCT_LOT_VALUE:
        {
            Marketplace_OnDeleteLot(playerid, json);
        }

        case MARKETPLACE_LIKE_VALUE,
             MARKETPLACE_EDIT_PRODUCT_LOT_VALUE,
             MARKETPLACE_CONFIRM_EDIT_PRODUCT_LOT_VALUE,
             MARKETPLACE_HISTORY_ACTION_VALUE,
             MARKETPLACE_SEARCH_BAR_VALUE,
             MARKETPLACE_VIP_PLATINUM_BUY_VALUE,
             MARKETPLACE_SORT_VALUE:
        {
            Marketplace_Ack(playerid, type, 1);
        }

        default:
        {
            Marketplace_Ack(playerid, type, 0);
        }
    }
    return 1;
}

stock Marketplace_ShowSellPicker(playerid)
{
    new account_id = GetPlayerAccountID(playerid);

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", MARKETPLACE_CLICK_PLUS_VALUE);
    JSON_SetInt(response, "s", 1);

    new Node:items = JSON_Array();

    if(account_id > 0)
    {
        new query[160];
        mysql_format(mysql, query, sizeof(query), "SELECT slot, item_id, model_id, amount FROM inventory WHERE account_id = %d ORDER BY slot ASC", account_id);
        new Cache:c = mysql_query(mysql, query, true);

        if(!mysql_errno())
        {
            new rows = cache_num_rows();
            for(new i = 0; i < rows; i++)
            {
                new slot   = cache_get_field_content_int(i, "slot");
                new itemid = cache_get_field_content_int(i, "item_id");
                new amount = cache_get_field_content_int(i, "amount");

                new name[64];
                Marketplace_ItemName(itemid, name, sizeof(name));

                new Node:entry = JSON_Object();
                JSON_SetInt(entry, "id", slot);
                JSON_SetInt(entry, "ga", itemid);
                JSON_SetString(entry, "n", name);
                JSON_SetInt(entry, "cnt", amount);
                items = JSON_Append(items, entry);
                JSON_Cleanup(entry);
            }
        }
        cache_delete(c);
    }

    JSON_SetArray(response, "it", items);
    OnPacketIncoming(playerid, MARKETPLACE_SCREEN_ID, response);

    JSON_Cleanup(items);
    JSON_Cleanup(response);
    return 1;
}

stock Marketplace_OnPickItemToSell(playerid, JSON:json)
{
    new slot = -1;
    JSON_GetInt(json, "id", slot);

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0 || slot < 1 || slot > Inventory11_GetMaxSlots(playerid))
    {
        Marketplace_Ack(playerid, MARKETPLACE_ADD_PRODUCT_VALUE, 0);
        return 0;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT item_id, model_id, amount, extra_1, extra_2 FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, slot);
    new Cache:c = mysql_query(mysql, query, true);

    if(mysql_errno() || cache_num_rows() <= 0)
    {
        cache_delete(c);
        Marketplace_Ack(playerid, MARKETPLACE_ADD_PRODUCT_VALUE, 0);
        return 0;
    }

    new itemid  = cache_get_field_content_int(0, "item_id");
    new modelid = cache_get_field_content_int(0, "model_id");
    new amount  = cache_get_field_content_int(0, "amount");
    new extra1  = cache_get_field_content_int(0, "extra_1");
    new extra2  = cache_get_field_content_int(0, "extra_2");
    cache_delete(c);

    if(amount <= 0)
    {
        Marketplace_Ack(playerid, MARKETPLACE_ADD_PRODUCT_VALUE, 0);
        return 0;
    }

    g_MktPendingSlot[playerid]  = slot;
    g_MktPendingItem[playerid]  = itemid;
    g_MktPendingModel[playerid] = modelid;
    g_MktPendingExtra1[playerid] = extra1;
    g_MktPendingExtra2[playerid] = extra2;
    g_MktPendingAvail[playerid] = amount;

    new name[64];
    Marketplace_ItemName(itemid, name, sizeof(name));

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", MARKETPLACE_ADD_PRODUCT_VALUE);
    JSON_SetInt(response, "s", 1);
    JSON_SetString(response, "n", name);
    JSON_SetInt(response, "mx", amount);
    JSON_SetInt(response, "minpr", MARKETPLACE_MIN_PRICE);
    JSON_SetInt(response, "maxpr", MARKETPLACE_MAX_PRICE);

    OnPacketIncoming(playerid, MARKETPLACE_SCREEN_ID, response);
    JSON_Cleanup(response);
    return 1;
}

stock Marketplace_OnConfirmPublish(playerid, JSON:json)
{
    new slot = g_MktPendingSlot[playerid];
    new account_id = GetPlayerAccountID(playerid);

    if(slot < 1 || account_id <= 0 || g_MktPendingAvail[playerid] <= 0)
    {
        Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_PUBLISH_PRODUCT_LOT_VALUE, 0);
        return 0;
    }

    new count = 0, price = 0, hasAds = 0;
    JSON_GetInt(json, "ct", count);
    JSON_GetInt(json, "cs", price);
    JSON_GetInt(json, "rs", hasAds);

    if(count <= 0 || count > g_MktPendingAvail[playerid]
       || count > MARKETPLACE_MAX_COUNT
       || price < MARKETPLACE_MIN_PRICE || price > MARKETPLACE_MAX_PRICE)
    {
        Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_PUBLISH_PRODUCT_LOT_VALUE, 0);
        return 0;
    }

    new itemid  = g_MktPendingItem[playerid];
    new modelid = g_MktPendingModel[playerid];
    new extra1  = g_MktPendingExtra1[playerid];
    new extra2  = g_MktPendingExtra2[playerid];
    new leftover = g_MktPendingAvail[playerid] - count;

    if(leftover <= 0)
    {
        Inventory11_DeleteSlotFromDatabase(playerid, slot);
    }
    else
    {
        new q[196];
        if(itemid == 22)
        {
            mysql_format(mysql, q, sizeof(q), "UPDATE inventory SET amount = %d, model_id = %d WHERE account_id = %d AND slot = %d LIMIT 1", leftover, leftover, account_id, slot);
        }
        else
        {
            mysql_format(mysql, q, sizeof(q), "UPDATE inventory SET amount = %d WHERE account_id = %d AND slot = %d LIMIT 1", leftover, account_id, slot);
        }
        mysql_query(mysql, q, true);
    }

    new query[400];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO marketplace_lots (seller_id, item_id, model_id, extra_1, extra_2, count, price, has_ads, status, created_at) VALUES (%d, %d, %d, %d, %d, %d, %d, %d, 0, %d)",
        account_id, itemid, modelid, extra1, extra2, count, price, hasAds, gettime()
    );
    mysql_tquery(mysql, query);

    Marketplace_ResetPending(playerid);
    Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_PUBLISH_PRODUCT_LOT_VALUE, 1);
    return 1;
}

stock Marketplace_SendTab(playerid, tab, page)
{
    if(page < 1) page = 1;
    new offset = (page - 1) * MARKET_ITEMS_PER_PAGE;
    new account_id = GetPlayerAccountID(playerid);

    new query[256];
    if(tab == MARKETPLACE_MY_STORE_TAB_VALUE)
    {
        mysql_format(mysql, query, sizeof(query),
            "SELECT * FROM marketplace_lots WHERE seller_id = %d AND status = 0 ORDER BY id DESC LIMIT %d,%d",
            account_id, offset, MARKET_ITEMS_PER_PAGE);
    }
    else
    {
        mysql_format(mysql, query, sizeof(query),
            "SELECT * FROM marketplace_lots WHERE status = 0 AND seller_id != %d ORDER BY id DESC LIMIT %d,%d",
            account_id, offset, MARKET_ITEMS_PER_PAGE);
    }

    new Cache:c = mysql_query(mysql, query, true);
    new rows = (!mysql_errno()) ? cache_num_rows() : 0;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", tab);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "page", page);

    new Node:items = JSON_Array();
    for(new i = 0; i < rows; i++)
    {
        new lotId  = cache_get_field_content_int(i, "id");
        new itemid = cache_get_field_content_int(i, "item_id");
        new count  = cache_get_field_content_int(i, "count");
        new price  = cache_get_field_content_int(i, "price");

        new name[64];
        Marketplace_ItemName(itemid, name, sizeof(name));

        new Node:entry = JSON_Object();
        JSON_SetInt(entry, "id", lotId);
        JSON_SetString(entry, "n", name);
        JSON_SetInt(entry, "pr", price);
        JSON_SetString(entry, "cur", "рублей");
        JSON_SetInt(entry, "cnt", count);
        JSON_SetInt(entry, "st", MARKETPLACE_STATUS_ACTIVE);
        items = JSON_Append(items, entry);
        JSON_Cleanup(entry);
    }
    JSON_SetArray(response, "it", items);

    OnPacketIncoming(playerid, MARKETPLACE_SCREEN_ID, response);

    JSON_Cleanup(items);
    JSON_Cleanup(response);
    cache_delete(c);
    return 1;
}

stock Marketplace_ShowBuyConfirm(playerid, lotId)
{
    new query[160];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM marketplace_lots WHERE id = %d AND status = 0 LIMIT 1", lotId);
    new Cache:c = mysql_query(mysql, query, true);

    new bool:found = (!mysql_errno() && cache_num_rows() > 0);
    new price = 0, itemid = 0, count = 0;
    if(found)
    {
        price  = cache_get_field_content_int(0, "price");
        itemid = cache_get_field_content_int(0, "item_id");
        count  = cache_get_field_content_int(0, "count");
    }
    cache_delete(c);

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", MARKETPLACE_BUY_VALUE);
    JSON_SetInt(response, "s", found ? 1 : 0);
    if(found)
    {
        new name[64];
        Marketplace_ItemName(itemid, name, sizeof(name));
        JSON_SetInt(response, "id", lotId);
        JSON_SetString(response, "n", name);
        JSON_SetInt(response, "pr", price);
        JSON_SetInt(response, "cnt", count);
    }
    OnPacketIncoming(playerid, MARKETPLACE_SCREEN_ID, response);
    JSON_Cleanup(response);
    return 1;
}

stock Marketplace_OnConfirmBuy(playerid, JSON:json)
{
    new lotId = 0, wantCount = 0;
    JSON_GetInt(json, "id", lotId);
    JSON_GetInt(json, "ct", wantCount);

    new query[160];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM marketplace_lots WHERE id = %d AND status = 0 LIMIT 1", lotId);
    new Cache:c = mysql_query(mysql, query, true);

    if(mysql_errno() || cache_num_rows() == 0)
    {
        cache_delete(c);
        Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_BUY_VALUE, 0);
        return 0;
    }

    new price    = cache_get_field_content_int(0, "price");
    new itemid   = cache_get_field_content_int(0, "item_id");
    new modelid  = cache_get_field_content_int(0, "model_id");
    new extra1   = cache_get_field_content_int(0, "extra_1");
    new extra2   = cache_get_field_content_int(0, "extra_2");
    new count    = cache_get_field_content_int(0, "count");
    new sellerId = cache_get_field_content_int(0, "seller_id");
    cache_delete(c);

    if(wantCount != count || GetPlayerMoneyEx(playerid) < price)
    {
        Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_BUY_VALUE, 0);
        return 0;
    }

    if(Inventory11_AddItemToDatabase(playerid, itemid, modelid, count, extra1, extra2) == -1)
    {
        Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_BUY_VALUE, 0);
        return 0;
    }

    GivePlayerMoneyEx(playerid, -price);

    new upd[128];
    mysql_format(mysql, upd, sizeof(upd), "UPDATE marketplace_lots SET status = 1, buyer_id = %d WHERE id = %d", GetPlayerAccountID(playerid), lotId);
    mysql_tquery(mysql, upd);

    new sellerPlayerId = Marketplace_FindOnlinePlayerByAccountID(sellerId);
    if(sellerPlayerId != INVALID_PLAYER_ID)
    {
        GivePlayerMoneyEx(sellerPlayerId, price);
    }
    else
    {
        new payout[160];
        mysql_format(mysql, payout, sizeof(payout), "INSERT INTO marketplace_payouts (seller_id, amount, created_at) VALUES (%d, %d, %d)", sellerId, price, gettime());
        mysql_tquery(mysql, payout);
    }

    Marketplace_Ack(playerid, MARKETPLACE_CONFIRM_BUY_VALUE, 1);
    return 1;
}

stock Marketplace_OnDeleteLot(playerid, JSON:json)
{
    new lotId = 0;
    JSON_GetInt(json, "id", lotId);

    new query[160];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM marketplace_lots WHERE id = %d AND seller_id = %d AND status = 0 LIMIT 1", lotId, GetPlayerAccountID(playerid));
    new Cache:c = mysql_query(mysql, query, true);

    if(mysql_errno() || cache_num_rows() == 0)
    {
        cache_delete(c);
        Marketplace_Ack(playerid, MARKETPLACE_DELETE_PRODUCT_LOT_VALUE, 0);
        return 0;
    }

    new itemid  = cache_get_field_content_int(0, "item_id");
    new modelid = cache_get_field_content_int(0, "model_id");
    new extra1  = cache_get_field_content_int(0, "extra_1");
    new extra2  = cache_get_field_content_int(0, "extra_2");
    new count   = cache_get_field_content_int(0, "count");
    cache_delete(c);

    if(Inventory11_AddItemToDatabase(playerid, itemid, modelid, count, extra1, extra2) == -1)
    {
        Marketplace_Ack(playerid, MARKETPLACE_DELETE_PRODUCT_LOT_VALUE, 0);
        return 0;
    }

    new upd[96];
    mysql_format(mysql, upd, sizeof(upd), "UPDATE marketplace_lots SET status = 2 WHERE id = %d", lotId);
    mysql_tquery(mysql, upd);

    Marketplace_Ack(playerid, MARKETPLACE_DELETE_PRODUCT_LOT_VALUE, 1);
    return 1;
}
