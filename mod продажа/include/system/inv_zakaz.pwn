#define GreenNotif(%1,%2) format(mes_str, sizeof(mes_str), %2), ShowNewNotification(%1, 3, 3, 0, 0, mes_str, "")
#define CBR2 0xCA5757FF
#define MAX_INV_SLOTS 40
#define MAX_ITEM_STACK 5

enum p_inv_info
{
    invID,
    invItem,
    invCount,
    invValue
}
new PlayerInventory[MAX_PLAYERS][MAX_INV_SLOTS][p_inv_info];

forward LoadPlayerInventory(playerid);
public LoadPlayerInventory(playerid)
{
    new rows = cache_num_rows();
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        PlayerInventory[playerid][i][invID] = 0;
        PlayerInventory[playerid][i][invItem] = 0;
        PlayerInventory[playerid][i][invCount] = 0;
    }
    for(new i = 0; i < rows; i++)
    {
        new slot;
        slot = cache_get_field_content_int(i, "slot");
        if(slot >= 0 && slot < MAX_INV_SLOTS)
        {
            PlayerInventory[playerid][slot][invID] = cache_get_field_content(i, "id");
            PlayerInventory[playerid][slot][invItem] = cache_get_field_content(i, "item_id");
            PlayerInventory[playerid][slot][invCount] = cache_get_field_content(i, "count");
            PlayerInventory[playerid][slot][invValue] = cache_get_field_content(i, "value");
        }
    }
    return 1;
}

forward OnItemInserted(playerid, slot);
public OnItemInserted(playerid, slot)
{
    PlayerInventory[playerid][slot][invID] = cache_insert_id();
    return 1;
}

stock GivePlayerItem(playerid, itemid, amount)
{
    if(GetPVarInt(playerid, "weight") > 150)
    {
        ShowNewNotification(playerid, 2, 4, 0, 0, "Ошибка. Инвентарь переполнен.", "");
        return 0;
    } 
    if(itemid == 22 || itemid == 23 || itemid == 55)
    {
        for(new i = 0; i < MAX_INV_SLOTS; i++)
        {
            if(PlayerInventory[playerid][i][invItem] == itemid && PlayerInventory[playerid][i][invCount] < MAX_ITEM_STACK)
            {
                new can_add = MAX_ITEM_STACK - PlayerInventory[playerid][i][invCount];
                new to_add = (amount > can_add) ? can_add : amount;
                
                PlayerInventory[playerid][i][invCount] += to_add;
                amount -= to_add;
                
                new query[128];
                mysql_format(mysql, query, sizeof(query), "UPDATE `inventory` SET `count` = %d WHERE `id` = %d", PlayerInventory[playerid][i][invCount], PlayerInventory[playerid][i][invID]);
                mysql_tquery(mysql, query);
                
                if(amount <= 0) return 1;
            }
        }
    }

    while(amount > 0)
    {
        new slot = -1;
        for(new i = 0; i < MAX_INV_SLOTS; i++)
        {
            if(PlayerInventory[playerid][i][invItem] == 0) { slot = i; break; }
        }

        if(slot == -1) return 0;

        new to_add;
        if(itemid == 22 || itemid == 23 || itemid == 55) {
            to_add = (amount > MAX_ITEM_STACK) ? MAX_ITEM_STACK : amount;
        } else {
            to_add = 1; 
        }

        PlayerInventory[playerid][slot][invItem] = itemid;
        PlayerInventory[playerid][slot][invCount] = to_add;
        PlayerInventory[playerid][slot][invValue] = 0;
        amount -= to_add;

        new query[256 + 128];
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `inventory` (`uid`, `item_id`, `count`, `slot`, `value`) VALUES (%d, %d, %d, %d, 0)", GetPlayerAccountID(playerid), itemid, to_add, slot);
        mysql_tquery(mysql, query, "OnItemInserted", "ii", playerid, slot);
    }
    return 1;
}

CMD:giveitem(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return ShowNewNotification(playerid, 2, 4, 0, 0, "Недостаточно прав для использования команды.", "");
    new targetid, item, count;
    if(sscanf(params, "uii", targetid, item, count)) return SendClientMessage(playerid, CBR2, "| {FFFFFF}Используйте: {CA5757}/giveitem [айди игрока] [айди предмета] [колво]");
    if(targetid == INVALID_PLAYER_ID) return 1;
    if(!GivePlayerItem(targetid, item, count)) return SendClientMessage(playerid, -1, "Ошибка!");
    return 1;
}

stock GivePlayerSkin(playerid, skinid)
{
    new slot = -1;
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerInventory[playerid][i][invItem] == 0) { slot = i; break; }
    }
    if(GetPVarInt(playerid, "weight") > 150)
    {
        ShowNewNotification(playerid, 2, 4, 0, 0, "Ошибка. Инвентарь переполнен.", "");
        return 0;
    } 

    if(slot == -1) return 0;

    PlayerInventory[playerid][slot][invItem] = 134; 
    PlayerInventory[playerid][slot][invCount] = 1;
    PlayerInventory[playerid][slot][invValue] = skinid; 

    new query[256];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `inventory` (`uid`, `item_id`, `count`, `slot`, `value`) VALUES (%d, 134, 1, %d, %d)", GetPlayerAccountID(playerid), slot, skinid);
    mysql_tquery(mysql, query, "OnItemInserted", "ii", playerid, slot);
    return 1;
}

CMD:addskin(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return ShowNewNotification(playerid, 2, 4, 0, 0, "Недостаточно прав для использования команды.", "");
    new targetid, skin;
    if(sscanf(params, "ui", targetid, skin)) return SendClientMessage(playerid, CBR2, "Используйте: /addskin [айди игрока] [айди скина]");
    if(targetid == INVALID_PLAYER_ID) return 1;

    if(!GivePlayerSkin(targetid, skin)) return SendClientMessage(playerid, -1, "Ошибка!");
    return 1;
}

stock Inventory(playerid)
{
    new Node:JSONObject = JSON_Object();
    new weight = 0;
    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "i", 0);
    JSON_SetInt(JSONObject, "nm", 0);
    JSON_SetString(JSONObject, "n", GetPlayerNameEx(playerid)); 
    JSON_SetInt(JSONObject, "lv", g_player[playerid][P_LEVEL]);
    JSON_SetInt(JSONObject, "id", playerid);
    JSON_SetInt(JSONObject, "mw", 150);
    JSON_SetInt(JSONObject, "s", 0);
    JSON_SetInt(JSONObject, "v", 0);
    JSON_SetInt(JSONObject, "ps", GetPlayerSkinEx(playerid));
    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));  
    JSON_SetInt(JSONObject, "sl", MAX_INV_SLOTS);
    new Node:itArray = JSON_Array();
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerInventory[playerid][i][invItem] > 0)
        {
            new Node:tempItem;
            if(PlayerInventory[playerid][i][invItem] == 134) 
            {
                tempItem = JSON_Array(JSON_Int(134), JSON_Int(PlayerInventory[playerid][i][invValue]), JSON_Int(i), JSON_Int(PlayerInventory[playerid][i][invCount]));
                weight = weight + 5;
            }
            else 
            {
                tempItem = JSON_Array(JSON_Int(PlayerInventory[playerid][i][invItem]), JSON_Int(PlayerInventory[playerid][i][invCount]), JSON_Int(i), JSON_Int(0));
                if(PlayerInventory[playerid][i][invItem] == 22) weight = weight + 10;
                else weight = weight + 3;
            }
            itArray = JSON_Append(itArray, tempItem); 
        }
    }
    SetPVarInt(playerid, "weight", weight);
    JSON_SetInt(JSONObject, "w", GetPVarInt(playerid, "weight")); 
    JSON_SetArray(JSONObject, "it", itArray);
    new Node:aiArray = JSON_Array(JSON_Int(134), JSON_Int(g_player[playerid][P_SKIN]), JSON_Int(6), JSON_Int(0));
    JSON_SetArray(JSONObject, "ai", aiArray);
    OnPacketIncoming(playerid, 33, JSONObject);    
    return 1;
}

CMD:inv(playerid)
{
    Inventory(playerid);
    return 1;
}