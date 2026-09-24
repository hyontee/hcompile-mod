#if defined _MARKETPLACE_WELSI_INCLUDED
    #endinput
#endif
#define _MARKETPLACE_WELSI_INCLUDED

#define MARKETPLACE_GUI_ID                  (77)
#define MARKETPLACE_PAGE_SIZE               (20)
#define MARKETPLACE_MAX_SELL_COUNT          (999999)
#define MARKETPLACE_MAX_PRICE               (2000000000)
#define MARKETPLACE_SELL_TAX_PERCENT        (5)
#define MARKETPLACE_PLACEMENT_HOURS         (48)

new g_MarketplaceSelectedSlot[MAX_PLAYERS];
new g_MarketplaceSelectedLot[MAX_PLAYERS];
new g_MarketplaceSelectedTab[MAX_PLAYERS];
new g_MarketplacePage[MAX_PLAYERS];
new g_MarketplaceSearch[MAX_PLAYERS][32];

stock Marketplace_ResetPlayer(playerid)
{
    g_MarketplaceSelectedSlot[playerid] = -1;
    g_MarketplaceSelectedLot[playerid] = -1;
    g_MarketplaceSelectedTab[playerid] = 2;
    g_MarketplacePage[playerid] = 1;
    g_MarketplaceSearch[playerid][0] = EOS;
    return 1;
}

stock Marketplace_DBInit()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `marketplace_lots` (`id` INT NOT NULL AUTO_INCREMENT, `seller_id` INT NOT NULL DEFAULT 0, `seller_name` VARCHAR(24) NOT NULL DEFAULT '', `item_id` INT NOT NULL DEFAULT 0, `item_count` INT NOT NULL DEFAULT 0, `item_plate` VARCHAR(64) NOT NULL DEFAULT '', `price` INT NOT NULL DEFAULT 0, `is_sold` TINYINT NOT NULL DEFAULT 0, `buyer_id` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, `sold_at` INT NOT NULL DEFAULT 0, `is_hot` TINYINT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `seller_id` (`seller_id`), KEY `is_sold` (`is_sold`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `marketplace_history` (`id` INT NOT NULL AUTO_INCREMENT, `lot_id` INT NOT NULL DEFAULT 0, `seller_id` INT NOT NULL DEFAULT 0, `buyer_id` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL DEFAULT 0, `item_count` INT NOT NULL DEFAULT 0, `price` INT NOT NULL DEFAULT 0, `time` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `seller_id` (`seller_id`), KEY `buyer_id` (`buyer_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    return 1;
}

stock Marketplace_Notify(playerid, const text[])
{
    if(IsPlayerConnected(playerid)) SendClientMessage(playerid, 0x66CCFFFF, text);
    return 1;
}

stock Marketplace_GetPlayerFreeSlot(playerid)
{
    return Inventory_GetFreeSlot(playerid);
}

stock Marketplace_GetItemRarity(itemid)
{
    if(itemid == 134) return 3;
    if(itemid >= 5000) return 4;
    if(itemid >= 1000) return 2;
    return 1;
}

stock Marketplace_GetItemModel(itemid, count)
{
    if(itemid == 134) return count;
    return itemid;
}

stock Marketplace_AddProductToArray(Node:array, lot_id, item_id, item_count, price, const seller[], const plate[], created_at, is_hot, is_user)
{
    new name[64];
    GetItemName(item_id, name, sizeof(name));
    if(name[0] == EOS) format(name, sizeof(name), "Item %d", item_id);

    new left_time = (created_at + MARKETPLACE_PLACEMENT_HOURS * 3600) - gettime();
    if(left_time < 0) left_time = 0;

    new Node:product = JSON_Object(
        "id", JSON_Int(lot_id),
        "md", JSON_Int(item_id),
        "dm", JSON_String(name),
        "n", JSON_String(name),
        "ct", JSON_Int(item_count),
        "cs", JSON_Int(price),
        "nm", JSON_String(seller),
        "sl", JSON_Int(is_user),
        "r", JSON_Int(Marketplace_GetItemRarity(item_id)),
        "rt", JSON_Int(Marketplace_GetItemRarity(item_id)),
        "tp", JSON_Int(is_hot ? 1 : 0),
        "tm", JSON_Int(left_time),
        "ti", JSON_Int(left_time),
        "tb", JSON_Int(created_at),
        "l", JSON_Int(0),
        "p", JSON_String(plate)
    );
    return JSON_Append(array, product);
}

stock Node:Marketplace_AddInventoryProductToArray(Node:array, playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return array;
    if(g_PlayerInventory[playerid][slot][inv_itemId] <= 0) return array;

    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new count = g_PlayerInventory[playerid][slot][inv_itemCount];
    new name[64];
    GetItemName(item_id, name, sizeof(name));
    if(name[0] == EOS) format(name, sizeof(name), "Item %d", item_id);

    new Node:product = JSON_Object(
        "id", JSON_Int(slot),
        "md", JSON_Int(item_id),
        "dm", JSON_String(name),
        "n", JSON_String(name),
        "ct", JSON_Int(count),
        "cs", JSON_Int(0),
        "nm", JSON_String(GetPlayerNameEx(playerid)),
        "sl", JSON_Int(1),
        "r", JSON_Int(Marketplace_GetItemRarity(item_id)),
        "rt", JSON_Int(Marketplace_GetItemRarity(item_id)),
        "tp", JSON_Int(0),
        "tm", JSON_Int(0),
        "ti", JSON_Int(0),
        "tb", JSON_Int(gettime()),
        "l", JSON_Int(0),
        "p", JSON_String(g_PlayerInventory[playerid][slot][inv_itemPlate])
    );
    return JSON_Append(array, product);
}

stock Marketplace_SendPacket(playerid, Node:json)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, MARKETPLACE_GUI_ID);

    new data[32768];
    JSON_Stringify(json, data, sizeof(data));

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
    return 1;
}

stock Marketplace_SendPacketString(playerid, const data[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, MARKETPLACE_GUI_ID);
    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
    return 1;
}

stock Marketplace_SendOpenPacket(playerid)
{
    new data[2048];
    format(data, sizeof(data), "{\"o\":1,\"t\":%d,\"n\":[],\"nm\":\"%s\",\"id\":%d,\"m\":%d,\"ma\":0,\"rk\":0,\"rs\":[],\"v\":0,\"vm\":0,\"tm\":0,\"lt\":%d,\"ls\":1,\"st\":0,\"s\":\"\",\"lp\":[],\"lh\":[],\"nf\":[],\"nh\":[],\"f\":[]}",
        g_MarketplaceSelectedTab[playerid],
        GetPlayerNameEx(playerid),
        GetPlayerAccountID(playerid),
        GetPlayerMoneyEx(playerid),
        g_MarketplacePage[playerid]
    );
    return Marketplace_SendPacketString(playerid, data);
}

stock Marketplace_SendBasePacket(playerid, Node:products, Node:inventory_products, Node:user_products, Node:history)
{
    new Node:visible_products = products;
    new Node:published_products = user_products;

    // APK tabs are only 1..5. Type 6 is page navigation, not inventory.
    // Inventory for the plus button must be sent as server packet t=9.
    if(g_MarketplaceSelectedTab[playerid] == 5)
    {
        visible_products = user_products;
        published_products = JSON_Array();
    }
    else if(g_MarketplaceSelectedTab[playerid] == 3) visible_products = history;

    new Node:json = JSON_Object(
        "t", JSON_Int(g_MarketplaceSelectedTab[playerid]),
        "n", visible_products,
        "lp", published_products,
        "lh", JSON_Array(),
        "m", JSON_Int(GetPlayerMoneyEx(playerid)),
        "ma", JSON_Int(0),
        "rk", JSON_Int(0),
        "rs", JSON_Array(),
        "v", JSON_Int(0),
        "vm", JSON_Int(0),
        "tm", JSON_Int(0),
        "lt", JSON_Int(g_MarketplacePage[playerid]),
        "ls", JSON_Int(1),
        "st", JSON_Int(0),
        "s", JSON_String(g_MarketplaceSearch[playerid]),
        "nf", JSON_Array(),
        "nh", JSON_Array(),
        "f", JSON_Array()
    );
    Marketplace_SendPacket(playerid, json);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_SendInventoryPacket(playerid)
{
    new Node:inventory_products = JSON_Array();
    new inv_count = 0;
    new sent_count = 0;

    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(g_PlayerInventory[playerid][slot][inv_itemId] > 0 && g_PlayerInventory[playerid][slot][inv_itemCount] > 0)
        {
            inv_count++;
            inventory_products = Marketplace_AddInventoryProductToArray(inventory_products, playerid, slot);
            sent_count++;
        }
    }

    new dbg[128];
    format(dbg, sizeof(dbg), "Marketplace: inventory normal scan inv=%d sent=%d.", inv_count, sent_count);
    Marketplace_Notify(playerid, dbg);

    new Node:json = JSON_Object(
        "t", JSON_Int(9),
        "n", inventory_products,
        "m", JSON_Int(GetPlayerMoneyEx(playerid)),
        "lt", JSON_Int(1),
        "ls", JSON_Int(1),
        "st", JSON_Int(0),
        "s", JSON_String("")
    );
    Marketplace_SendPacket(playerid, json);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_SendSellSelectPacket(playerid, rk = 0)
{
    new Node:json = JSON_Object(
        "t", JSON_Int(10),
        "rk", JSON_Int(rk),
        "m", JSON_Int(GetPlayerMoneyEx(playerid))
    );
    Marketplace_SendPacket(playerid, json);
    JSON_Cleanup(json);
    return 1;
}

stock Marketplace_SendPublishResultPacket(playerid, err = 0)
{
    new Node:json = JSON_Object(
        "t", JSON_Int(11),
        "err", JSON_Int(err),
        "m", JSON_Int(GetPlayerMoneyEx(playerid))
    );
    Marketplace_SendPacket(playerid, json);
    JSON_Cleanup(json);
    return 1;
}

public Marketplace_DelayedInventoryPacket(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    Marketplace_SendInventoryPacket(playerid);
    return 1;
}

stock Marketplace_SendLocalOpen(playerid)
{
    new Node:products = JSON_Array();
    new Node:user_products = JSON_Array();
    new Node:history = JSON_Array();
    new Node:inventory_products = JSON_Array();

    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(g_PlayerInventory[playerid][slot][inv_itemId] > 0 && g_PlayerInventory[playerid][slot][inv_itemCount] > 0)
        {
            inventory_products = Marketplace_AddInventoryProductToArray(inventory_products, playerid, slot);
        }
    }
    return Marketplace_SendBasePacket(playerid, products, inventory_products, user_products, history);
}

stock Marketplace_Open(playerid, tab = 2)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Marketplace: open failed - player not logged.");
        return 0;
    }
    if(tab >= 1 && tab <= 5) g_MarketplaceSelectedTab[playerid] = tab;
    if(g_MarketplacePage[playerid] <= 0) g_MarketplacePage[playerid] = 1;

    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: command reached. Sending GUI 77 raw open packet...");
    Marketplace_SendOpenPacket(playerid);
    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: GUI 77 raw open packet sent.");

    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `is_sold`=0 ORDER BY `is_hot` DESC, `id` DESC LIMIT 60");
    mysql_tquery(mysql, query, "Marketplace_OnLotsLoad", "i", playerid);
    return 1;
}

public Marketplace_OnLotsLoad(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows, fields;
    cache_get_data(rows, fields, mysql);

    new Node:products = JSON_Array();
    new Node:user_products = JSON_Array();
    new Node:history = JSON_Array();
    new Node:inventory_products = JSON_Array();

    for(new i = 0; i < rows; i++)
    {
        new lot_id = cache_get_field_content_int(i, "id");
        new seller_id = cache_get_field_content_int(i, "seller_id");
        new item_id = cache_get_field_content_int(i, "item_id");
        new item_count = cache_get_field_content_int(i, "item_count");
        new price = cache_get_field_content_int(i, "price");
        new created_at = cache_get_field_content_int(i, "created_at");
        new is_hot = cache_get_field_content_int(i, "is_hot");
        new seller[24], plate[64];
        cache_get_field_content(i, "seller_name", seller, mysql, sizeof(seller));
        cache_get_field_content(i, "item_plate", plate, mysql, sizeof(plate));

        if(seller_id == GetPlayerAccountID(playerid))
        {
            user_products = Marketplace_AddProductToArray(user_products, lot_id, item_id, item_count, price, seller, plate, created_at, is_hot, 1);
        }
        else
        {
            products = Marketplace_AddProductToArray(products, lot_id, item_id, item_count, price, seller, plate, created_at, is_hot, 0);
        }
    }

    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(g_PlayerInventory[playerid][slot][inv_itemId] > 0 && g_PlayerInventory[playerid][slot][inv_itemCount] > 0)
        {
            inventory_products = Marketplace_AddInventoryProductToArray(inventory_products, playerid, slot);
        }
    }

    return Marketplace_SendBasePacket(playerid, products, inventory_products, user_products, history);
}

stock Marketplace_GetJsonInt(Node:json, const key[], def = 0)
{
    new value = def;
    JSON_GetInt(json, key, value);
    return value;
}

stock Marketplace_FindInventorySlotByItemId(playerid, item_id)
{
    if(item_id <= 0) return -1;
    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(g_PlayerInventory[playerid][slot][inv_itemId] == item_id && g_PlayerInventory[playerid][slot][inv_itemCount] > 0)
        {
            return slot;
        }
    }
    return -1;
}

stock Marketplace_ResolveInventorySlot(playerid, Node:JSONObject)
{
    new slot = -1;
    JSON_GetInt(JSONObject, "id", slot);
    if(slot >= 0 && slot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][slot][inv_itemId] > 0) return slot;

    // Some client builds send inventory/card id in md instead of id.
    new md = -1;
    JSON_GetInt(JSONObject, "md", md);
    if(md >= 0 && md < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][md][inv_itemId] > 0) return md;
    if(md > 0)
    {
        slot = Marketplace_FindInventorySlotByItemId(playerid, md);
        if(slot != -1) return slot;
    }

    new sl = -1;
    JSON_GetInt(JSONObject, "sl", sl);
    if(sl >= 0 && sl < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][sl][inv_itemId] > 0) return sl;

    return -1;
}

stock Marketplace_HandlePacket(playerid, Node:JSONObject)
{
    new type = -1;
    JSON_GetInt(JSONObject, "t", type);

    switch(type)
    {
        case 1, 2, 3, 4, 5:
        {
            g_MarketplaceSelectedTab[playerid] = type;
            Marketplace_Open(playerid, type);
            return 1;
        }
        case 6:
        {
            // Client sends t=6 only for page switching: {"t":6,"lt":page}.
            new page = Marketplace_GetJsonInt(JSONObject, "lt", 1);
            if(page < 1) page = 1;
            g_MarketplacePage[playerid] = page;
            Marketplace_Open(playerid, g_MarketplaceSelectedTab[playerid]);
            return 1;
        }
        case 9:
        {
            // Plus button. APK expects server answer with t=9 and inventory items in "n".
            // Do not switch to t=6: that throws the client back to the main page.
            g_MarketplaceSelectedSlot[playerid] = -1;
            Marketplace_Notify(playerid, "Marketplace: plus clicked -> send t=9 inventory list.");
            Marketplace_SendInventoryPacket(playerid);
            return 1;
        }
        case 10:
        {
            new slot = Marketplace_ResolveInventorySlot(playerid, JSONObject);
            if(slot >= 0 && slot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][slot][inv_itemId] > 0)
            {
                g_MarketplaceSelectedSlot[playerid] = slot;

                new msg[128];
                format(msg, sizeof(msg), "Marketplace: item selected from slot %d -> send t=10 sell window.", slot);
                Marketplace_Notify(playerid, msg);
                Marketplace_SendSellSelectPacket(playerid, 0);
            }
            else Marketplace_Notify(playerid, "Marketplace: item not found. Try another item.");
            return 1;
        }
        case 11:
        {
            // Confirm publish. Some client builds resend item id/slot in this packet,
            // so resolve it again if there was no separate item-select packet.
            if(g_MarketplaceSelectedSlot[playerid] < 0)
            {
                g_MarketplaceSelectedSlot[playerid] = Marketplace_ResolveInventorySlot(playerid, JSONObject);
            }

            new count = Marketplace_GetJsonInt(JSONObject, "ct", 1);
            new price = Marketplace_GetJsonInt(JSONObject, "cs", 0);
            new is_hot = Marketplace_GetJsonInt(JSONObject, "rs", 0);
            return Marketplace_PublishSelected(playerid, count, price, is_hot);
        }
        case 12:
        {
            new lot_id = Marketplace_GetJsonInt(JSONObject, "id", -1);
            if(lot_id > 0)
            {
                g_MarketplaceSelectedLot[playerid] = lot_id;
                Marketplace_Notify(playerid, "Marketplace: press confirm to buy.");
            }
            return 1;
        }
        case 13:
        {
            new lot_id = Marketplace_GetJsonInt(JSONObject, "id", g_MarketplaceSelectedLot[playerid]);
            new count = Marketplace_GetJsonInt(JSONObject, "ct", 1);
            return Marketplace_Buy(playerid, lot_id, count);
        }
        case 14:
        {
            Marketplace_Notify(playerid, "Marketplace: like saved.");
            return 1;
        }
        case 15:
        {
            g_MarketplaceSelectedLot[playerid] = Marketplace_GetJsonInt(JSONObject, "id", -1);
            Marketplace_Notify(playerid, "Marketplace: lot selected for edit.");
            return 1;
        }
        case 16:
        {
            new price = Marketplace_GetJsonInt(JSONObject, "cs", 0);
            return Marketplace_EditSelected(playerid, price);
        }
        case 17:
        {
            return Marketplace_WithdrawSelected(playerid);
        }
        case 18:
        {
            Marketplace_Notify(playerid, "Marketplace: history card selected.");
            return 1;
        }
        case 19:
        {
            JSON_GetString(JSONObject, "s", g_MarketplaceSearch[playerid], sizeof(g_MarketplaceSearch[]));
            Marketplace_Open(playerid, g_MarketplaceSelectedTab[playerid]);
            return 1;
        }
        case 20, 25:
        {
            Marketplace_Notify(playerid, "Marketplace VIP is disabled on server side.");
            return 1;
        }
        case 21:
        {
            Marketplace_Open(playerid, g_MarketplaceSelectedTab[playerid]);
            return 1;
        }
    }

    new close = 0;
    JSON_GetInt(JSONObject, "c", close);
    if(close == 1) return 1;
    return 1;
}

stock Marketplace_PublishSelected(playerid, count, price, is_hot)
{
    new slot = g_MarketplaceSelectedSlot[playerid];
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS)
    {
        Marketplace_SendPublishResultPacket(playerid, 1);
        return Marketplace_Notify(playerid, "Marketplace: select item first.");
    }
    if(g_PlayerInventory[playerid][slot][inv_itemId] <= 0)
    {
        Marketplace_SendPublishResultPacket(playerid, 1);
        return Marketplace_Notify(playerid, "Marketplace: item not found.");
    }
    if(count <= 0) count = 1;
    if(count > g_PlayerInventory[playerid][slot][inv_itemCount]) count = g_PlayerInventory[playerid][slot][inv_itemCount];
    if(count > MARKETPLACE_MAX_SELL_COUNT) count = MARKETPLACE_MAX_SELL_COUNT;
    if(price < 100 || price > MARKETPLACE_MAX_PRICE)
    {
        Marketplace_SendPublishResultPacket(playerid, 1);
        return Marketplace_Notify(playerid, "Marketplace: wrong price. Minimum price is 100 rub.");
    }

    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new plate[64];
    format(plate, sizeof(plate), "%s", g_PlayerInventory[playerid][slot][inv_itemPlate]);

    if(!Inventory_RemoveItem(playerid, slot, count))
    {
        Marketplace_SendPublishResultPacket(playerid, 1);
        return Marketplace_Notify(playerid, "Marketplace: can not remove item.");
    }

    new query[512];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `marketplace_lots` (`seller_id`,`seller_name`,`item_id`,`item_count`,`item_plate`,`price`,`created_at`,`is_hot`) VALUES (%d,'%e',%d,%d,'%e',%d,%d,%d)", GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), item_id, count, plate, price, gettime(), is_hot ? 1 : 0);
    mysql_tquery(mysql, query, "Marketplace_OnPublished", "i", playerid);
    return 1;
}

public Marketplace_OnPublished(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        g_MarketplaceSelectedSlot[playerid] = -1;
        Marketplace_SendPublishResultPacket(playerid, 0);
        Marketplace_Notify(playerid, "Marketplace: lot published.");
        Marketplace_Open(playerid, 5);
    }
    return 1;
}

stock Marketplace_Buy(playerid, lot_id, count)
{
    if(lot_id <= 0) return Marketplace_Notify(playerid, "Marketplace: lot not selected.");
    if(count <= 0) count = 1;
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `id`=%d AND `is_sold`=0 LIMIT 1", lot_id);
    mysql_tquery(mysql, query, "Marketplace_OnBuyLoad", "iii", playerid, lot_id, count);
    return 1;
}

public Marketplace_OnBuyLoad(playerid, lot_id, buy_count)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(!rows) return Marketplace_Notify(playerid, "Marketplace: lot is not available.");

    new seller_id = cache_get_field_content_int(0, "seller_id");
    new item_id = cache_get_field_content_int(0, "item_id");
    new item_count = cache_get_field_content_int(0, "item_count");
    new price = cache_get_field_content_int(0, "price");
    new plate[64];
    cache_get_field_content(0, "item_plate", plate, mysql, sizeof(plate));

    if(seller_id == GetPlayerAccountID(playerid)) return Marketplace_Notify(playerid, "Marketplace: you can not buy your own lot.");
    if(buy_count <= 0) buy_count = 1;
    if(buy_count > item_count) buy_count = item_count;

    new total_price = price * buy_count;
    if(total_price <= 0 || GetPlayerMoneyEx(playerid) < total_price) return Marketplace_Notify(playerid, "Marketplace: not enough money.");

    new free_slot = Marketplace_GetPlayerFreeSlot(playerid);
    if(free_slot == -1) return Marketplace_Notify(playerid, "Marketplace: inventory is full.");

    GivePlayerMoneyEx(playerid, -total_price, "Marketplace buy", true, true);
    Inventory_AddItem(playerid, item_id, free_slot, buy_count, plate);

    new seller_player = INVALID_PLAYER_ID;
    foreach(new i: Player)
    {
        if(IsPlayerConnected(i) && IsPlayerLogged(i) && GetPlayerAccountID(i) == seller_id)
        {
            seller_player = i;
            break;
        }
    }

    new seller_money = total_price - ((total_price * MARKETPLACE_SELL_TAX_PERCENT) / 100);
    if(seller_player != INVALID_PLAYER_ID)
    {
        GivePlayerMoneyEx(seller_player, seller_money, "Marketplace sell", true, true);
        Marketplace_Notify(seller_player, "Marketplace: your item was sold.");
    }
    else
    {
        new query_money[160];
        mysql_format(mysql, query_money, sizeof(query_money), "UPDATE `accounts` SET `money`=`money`+%d WHERE `id`=%d LIMIT 1", seller_money, seller_id);
        mysql_tquery(mysql, query_money, "", "");
    }

    new query[512];
    if(buy_count >= item_count)
    {
        mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `is_sold`=1,`buyer_id`=%d,`sold_at`=%d WHERE `id`=%d LIMIT 1", GetPlayerAccountID(playerid), gettime(), lot_id);
        mysql_tquery(mysql, query, "", "");
    }
    else
    {
        mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `item_count`=`item_count`-%d WHERE `id`=%d LIMIT 1", buy_count, lot_id);
        mysql_tquery(mysql, query, "", "");
    }

    mysql_format(mysql, query, sizeof(query), "INSERT INTO `marketplace_history` (`lot_id`,`seller_id`,`buyer_id`,`item_id`,`item_count`,`price`,`time`) VALUES (%d,%d,%d,%d,%d,%d,%d)", lot_id, seller_id, GetPlayerAccountID(playerid), item_id, buy_count, total_price, gettime());
    mysql_tquery(mysql, query, "", "");

    Marketplace_Notify(playerid, "Marketplace: purchase complete.");
    Marketplace_Open(playerid, g_MarketplaceSelectedTab[playerid]);
    return 1;
}

stock Marketplace_EditSelected(playerid, price)
{
    new lot_id = g_MarketplaceSelectedLot[playerid];
    if(lot_id <= 0) return Marketplace_Notify(playerid, "Marketplace: lot not selected.");
    if(price < 100 || price > MARKETPLACE_MAX_PRICE) return Marketplace_Notify(playerid, "Marketplace: wrong price. Minimum price is 100 rub.");
    new query[256];
    mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `price`=%d WHERE `id`=%d AND `seller_id`=%d AND `is_sold`=0 LIMIT 1", price, lot_id, GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Marketplace_OnEdited", "i", playerid);
    return 1;
}

public Marketplace_OnEdited(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        Marketplace_Notify(playerid, "Marketplace: lot changed.");
        Marketplace_Open(playerid, 5);
    }
    return 1;
}

stock Marketplace_WithdrawSelected(playerid)
{
    new lot_id = g_MarketplaceSelectedLot[playerid];
    if(lot_id <= 0) return Marketplace_Notify(playerid, "Marketplace: lot not selected.");
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `marketplace_lots` WHERE `id`=%d AND `seller_id`=%d AND `is_sold`=0 LIMIT 1", lot_id, GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Marketplace_OnWithdrawLoad", "ii", playerid, lot_id);
    return 1;
}

public Marketplace_OnWithdrawLoad(playerid, lot_id)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(!rows) return Marketplace_Notify(playerid, "Marketplace: lot not found.");

    new item_id = cache_get_field_content_int(0, "item_id");
    new item_count = cache_get_field_content_int(0, "item_count");
    new plate[64];
    cache_get_field_content(0, "item_plate", plate, mysql, sizeof(plate));

    new free_slot = Marketplace_GetPlayerFreeSlot(playerid);
    if(free_slot == -1) return Marketplace_Notify(playerid, "Marketplace: inventory is full.");

    Inventory_AddItem(playerid, item_id, free_slot, item_count, plate);

    new query[160];
    mysql_format(mysql, query, sizeof(query), "UPDATE `marketplace_lots` SET `is_sold`=1 WHERE `id`=%d AND `seller_id`=%d LIMIT 1", lot_id, GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "", "");

    g_MarketplaceSelectedLot[playerid] = -1;
    Marketplace_Notify(playerid, "Marketplace: lot returned to inventory.");
    Marketplace_Open(playerid, 5);
    return 1;
}

stock Marketplace_DebugInventory(playerid)
{
    new normal_count = 0;
    new active_count = 0;
    new msg[144];

    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace DEBUG: start inventory scan.");

    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
        new count = g_PlayerInventory[playerid][slot][inv_itemCount];
        if(item_id > 0 && count > 0)
        {
            normal_count++;
            if(normal_count <= 8)
            {
                new name[64];
                GetItemName(item_id, name, sizeof(name));
                if(name[0] == EOS) format(name, sizeof(name), "Item %d", item_id);
                format(msg, sizeof(msg), "INV slot=%d item=%d count=%d name=%s", slot, item_id, count, name);
                SendClientMessage(playerid, 0xCECECEFF, msg);
            }
        }
    }

    for(new active_slot = 0; active_slot < MAX_ACTIVE_SLOTS; active_slot++)
    {
        new item_id = g_PlayerActiveSlots[playerid][active_slot][inv_itemId];
        new count = g_PlayerActiveSlots[playerid][active_slot][inv_itemCount];
        if(item_id > 0 && count > 0)
        {
            active_count++;
            if(active_count <= 8)
            {
                new name[64];
                GetItemName(item_id, name, sizeof(name));
                if(name[0] == EOS) format(name, sizeof(name), "Item %d", item_id);
                format(msg, sizeof(msg), "ACTIVE slot=%d item=%d count=%d name=%s", active_slot, item_id, count, name);
                SendClientMessage(playerid, 0xCECECEFF, msg);
            }
        }
    }

    format(msg, sizeof(msg), "Marketplace DEBUG: normal=%d active=%d. Send this line to ChatGPT.", normal_count, active_count);
    SendClientMessage(playerid, 0x66CCFFFF, msg);
    return 1;
}

CMD:marketdebug(playerid, params[])
{
    #pragma unused params
    return Marketplace_DebugInventory(playerid);
}

CMD:market(playerid, params[])
{
    #pragma unused params
    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: /market command reached.");
    if(!Marketplace_Open(playerid, 2))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Marketplace: command reached, but open failed.");
    }
    return 1;
}

CMD:marketplace(playerid, params[])
{
    #pragma unused params
    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: /marketplace command reached.");
    if(!Marketplace_Open(playerid, 2))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Marketplace: command reached, but open failed.");
    }
    return 1;
}

CMD:mpmarket(playerid, params[])
{
    #pragma unused params
    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: /mpmarket command reached.");
    if(!Marketplace_Open(playerid, 2))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Marketplace: command reached, but open failed.");
    }
    return 1;
}

CMD:marketinv(playerid, params[])
{
    #pragma unused params
    SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: /marketinv command reached.");
    if(!Marketplace_Open(playerid, 2))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Marketplace: inventory open failed.");
    }
    else
    {
        SetTimerEx("Marketplace_DelayedInventoryPacket", 700, false, "i", playerid);
        SendClientMessage(playerid, 0x66CCFFFF, "Marketplace: delayed t=9 inventory packet scheduled.");
    }
    return 1;
}

CMD:sellitem(playerid, params[])
{
    new slot, price, count;
    extract params -> new s_slot, s_price, s_count; else
    {
        SendClientMessage(playerid, 0xCECECEFF, "Use: /sellitem [slot] [price] [count]");
        return 1;
    }
    slot = s_slot;
    price = s_price;
    count = s_count;
    g_MarketplaceSelectedSlot[playerid] = slot;
    Marketplace_PublishSelected(playerid, count, price, 0);
    return 1;
}
