#if !defined GM_MAX_PLAYERS
    #define GM_MAX_PLAYERS MAX_PLAYERS
#endif
#define MOD_MAX_PLAYERS GM_MAX_PLAYERS

#if !defined MAX_INVENTORY_SLOTS
    #define MAX_INVENTORY_SLOTS 40
#endif
#if !defined MAX_ACTIVE_SLOTS
    #define MAX_ACTIVE_SLOTS 8
#endif

#if !defined SIM_SLOT
    #define SIM_SLOT 0
#endif
#if !defined SKIN_SLOT
    #define SKIN_SLOT 1
#endif
#if !defined SIM_SERVER_SLOT
    #define SIM_SERVER_SLOT 255
#endif
#if !defined SIM_SERVER_SLOT_LEGACY
    #define SIM_SERVER_SLOT_LEGACY 0
#endif
#if !defined SKIN_SERVER_SLOT
    #define SKIN_SERVER_SLOT 6
#endif
#if !defined SKIN_SERVER_SLOT_LEGACY
    #define SKIN_SERVER_SLOT_LEGACY 1
#endif

#if !defined ITEM_TYPE_OTHER
    #define ITEM_TYPE_OTHER 0
#endif
#if !defined ITEM_TYPE_SKIN
    #define ITEM_TYPE_SKIN 1
#endif
#if !defined ITEM_TYPE_SIM
    #define ITEM_TYPE_SIM 2
#endif
#if !defined ITEM_TYPE_PLATE
    #define ITEM_TYPE_PLATE 3
#endif
#if !defined ITEM_TYPE_FOOD
    #define ITEM_TYPE_FOOD 4
#endif
#if !defined ITEM_TYPE_MEDICAL
    #define ITEM_TYPE_MEDICAL 5
#endif
#if !defined ITEM_TYPE_ACCESSORY
    #define ITEM_TYPE_ACCESSORY 6
#endif

#if !defined INVENTORY_ITEM_ACCESSORY
    #define INVENTORY_ITEM_ACCESSORY (201)
#endif
#if !defined INVENTORY_ACCESSORY_ITEM_BASE
    #define INVENTORY_ACCESSORY_ITEM_BASE INVENTORY_ITEM_ACCESSORY
#endif
#if !defined INVENTORY_ACCESSORY_ITEM_LIMIT
    #define INVENTORY_ACCESSORY_ITEM_LIMIT (1200)
#endif

enum E_INVENTORY_ITEM
{
    inv_itemId,
    inv_itemCount,
    inv_itemSlot,
    inv_itemPlate[32],
    inv_itemType,
    inv_itemWeight,
    bool:inv_itemActive,
    inv_activeSlot,
    inv_itemName[64]
}

new g_PlayerInventory[MOD_MAX_PLAYERS][MAX_INVENTORY_SLOTS][E_INVENTORY_ITEM];
new g_PlayerActiveSlots[MOD_MAX_PLAYERS][MAX_ACTIVE_SLOTS][E_INVENTORY_ITEM];
new Float:g_PlayerWeight[MOD_MAX_PLAYERS];
new Float:g_PlayerMaxWeight[MOD_MAX_PLAYERS] = {150.0, ...};
new g_PlayerPhoneNumber[MOD_MAX_PLAYERS];
new g_PlayerMedChest[MOD_MAX_PLAYERS];
new g_PlayerMedChestVirtualSlot[MOD_MAX_PLAYERS];
new MySQL:g_InventoryMySQL;

forward Accessory_OnEquipped(playerid, activeSlot, accessoryId);
forward Accessory_OnUnequipped(playerid, activeSlot);
forward Accessory_OnInventoryLoaded(playerid);
forward bool:Accessory_UseFromInventory(playerid, invSlot);
forward bool:Accessory_CanEquip(playerid, accessoryId);

// #define P_SKIN 1 -- removed: conflicts with PlayerInfo enum
// #define P_PHONE 2 -- removed: conflicts with PlayerInfo enum
// #define P_MED_CHEST 3 -- removed: conflicts with PlayerInfo enum

// stock GetPlayerAccountID -- removed, defined as macro in Bold.pwn

// stock SetPlayerData -- removed, defined as macro in Bold.pwn

// stock GetPlayerData -- removed, defined as macro in Bold.pwn

// stock UpdatePlayerDatabaseInt -- removed, defined as macro in Bold.pwn

// stock GetPlayerPhone -- removed, defined as macro in Bold.pwn

// stock GetPlayerLevel -- removed, defined as macro in Bold.pwn


stock Inventory_Init(MySQL:connection)
{
    g_InventoryMySQL = connection;

    mysql_tquery(g_InventoryMySQL,
        "CREATE TABLE IF NOT EXISTS `items_data` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `item_id` INT NOT NULL UNIQUE, `item_name` VARCHAR(64) NOT NULL, `item_type` INT NOT NULL DEFAULT 0, `item_weight` INT NOT NULL DEFAULT 1, `item_max_stack` INT NOT NULL DEFAULT 999) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        "", "");

    mysql_tquery(g_InventoryMySQL,
        "CREATE TABLE IF NOT EXISTS `player_inventory` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `player_id` INT NOT NULL, `slot` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL DEFAULT 0, `item_count` INT NOT NULL DEFAULT 0, `item_plate` VARCHAR(32) DEFAULT '', `is_active` TINYINT(1) NOT NULL DEFAULT 0, `active_slot` INT NOT NULL DEFAULT -1, KEY `player_id` (`player_id`), KEY `slot` (`slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        "", "");

    return 1;
}

stock Inventory_Reset(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        g_PlayerInventory[playerid][i][inv_itemId] = 0;
        g_PlayerInventory[playerid][i][inv_itemCount] = 0;
        g_PlayerInventory[playerid][i][inv_itemSlot] = i;
        g_PlayerInventory[playerid][i][inv_itemPlate][0] = 0;
        g_PlayerInventory[playerid][i][inv_itemType] = 0;
        g_PlayerInventory[playerid][i][inv_itemWeight] = 0;
        g_PlayerInventory[playerid][i][inv_itemActive] = false;
        g_PlayerInventory[playerid][i][inv_activeSlot] = -1;
    }

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        g_PlayerActiveSlots[playerid][i][inv_itemId] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemCount] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemSlot] = i;
        g_PlayerActiveSlots[playerid][i][inv_itemPlate][0] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemType] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemWeight] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemActive] = false;
        g_PlayerActiveSlots[playerid][i][inv_activeSlot] = -1;
    }

    g_PlayerWeight[playerid] = 0;
    g_PlayerPhoneNumber[playerid] = 0;
    g_PlayerMedChest[playerid] = 0;
    return 1;
}

stock Inventory_HasItem(playerid, item_id)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == item_id) return 1;
    }
    return 0;
}

stock Inventory_FindItemSlot(playerid, item_id)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == item_id) return i;
    }
    return -1;
}

stock Inventory_SyncMedChestFlag(playerid)
{
    SetPlayerData(playerid, P_MED_CHEST, Inventory_HasItem(playerid, 22));
    g_PlayerMedChestVirtualSlot[playerid] = -1;
    return 1;
}

stock Inventory_ApplyMedChestEffect(playerid)
{
    new Float:hp;
    GetPlayerHealth(playerid, hp);
    hp += 60.0;
    if(hp > 100.0) hp = 100.0;
    SetPlayerHealth(playerid, hp);
    return 1;
}

stock bool:Inventory_UseMedChest(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;
    Inventory_ApplyMedChestEffect(playerid);

    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 22)
    {
        removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    }
    else
    {
        usedSlot = Inventory_FindItemSlot(playerid, 22);
        if(usedSlot != -1)
        {
            removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
        }
    }

    if(!removed) return false;

    SetPlayerData(playerid, P_MED_CHEST, 0);
    Inventory_SyncMedChestFlag(playerid);

    if(GetPlayerAccountID(playerid) > 0)
    {
        new query[128];
        mysql_format(g_InventoryMySQL, query, sizeof(query), "UPDATE `users` SET `healme` = 0 WHERE `ID` = %d LIMIT 1", GetPlayerAccountID(playerid));
        mysql_query(g_InventoryMySQL, query, false);
    }

    ShowClientNotification(playerid, 3, 6, 0, 0, "                                    60                 ", "");
    return true;
}

stock bool:Inventory_UseRepairKit(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;

    new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        ShowClientNotification(playerid, 2, 6, 0, 0, "                            ", "");
        return false;
    }

    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 23)
    {
        removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    }
    else
    {
        usedSlot = Inventory_FindItemSlot(playerid, 23);
        if(usedSlot != -1)
        {
            removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
        }
    }

    if(!removed) return false;

    SetVehicleHealth(vehicleid, 1000.0);
    VehicleHP[vehicleid] = 1000.0;
    RepairVehicle(vehicleid);

    if(EngineStalled[vehicleid])
    {
        EngineStalled[vehicleid] = false;
    }

    ShowClientNotification(playerid, 3, 6, 0, 0, "                                      ", "");
    return true;
}
stock GetItemType(itemId)
{
    if(itemId == 134) return ITEM_TYPE_SKIN;
    if(itemId == 58) return ITEM_TYPE_SIM;
    if(itemId == 22 || itemId == 23) return ITEM_TYPE_MEDICAL;
    if(itemId == 135) return ITEM_TYPE_FOOD;
    if(Inventory_IsAccessoryItem(itemId)) return ITEM_TYPE_ACCESSORY;
    if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83) return ITEM_TYPE_PLATE;
    return ITEM_TYPE_OTHER;
}

stock Float:GetItemWeight(itemId)
{
    if(itemId == 134) return 5.0;
    if(itemId == 22) return 2.5; 
    if(itemId == 23) return 5.0;
    if(Inventory_IsAccessoryItem(itemId)) return 3.0; 
    return 5.0; 
}

stock GetItemName(itemId, name[], len = sizeof(name))
{
    switch(itemId)
    {
        case 1: format(name, len, "Documents");
        case 22: format(name, len, "Medkit");
        case 23: format(name, len, "Repair kit");
        case 58: format(name, len, "SIM-card");
        case 59: format(name, len, "Number plate");
        case 81: format(name, len, "Truck plate");
        case 82: format(name, len, "Trailer plate");
        case 83: format(name, len, "Special plate");
        case 134: format(name, len, "Skin");
        case 135: format(name, len, "Food");
        default:
        {
            if(Inventory_IsAccessoryItem(itemId)) format(name, len, "Accessory");
            else format(name, len, "Item %d", itemId);
        }

    }
    return 1;
}

stock bool:Inventory_IsAccessoryItem(itemId)
{
    return (itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT);
}

stock Inv_GetAccIdByItem(itemId)
{
    if(!Inventory_IsAccessoryItem(itemId)) return -1;
    return itemId - INVENTORY_ACCESSORY_ITEM_BASE;
}

stock Float:GetPlayerWeight(playerid)
{
    return g_PlayerWeight[playerid];
}

stock SetPlayerWeight(playerid, Float:weight)
{
    if(weight < 0.0) weight = 0.0;
    g_PlayerWeight[playerid] = weight;
}

stock Float:GetPlayerMaxWeight(playerid)
{
    return g_PlayerMaxWeight[playerid];
}

stock Float:Inventory_GetEntryWeight(item_id, count)
{
    if(item_id <= 0) return 0.0;

    new itemType = GetItemType(item_id);
    if(itemType == ITEM_TYPE_SIM || itemType == ITEM_TYPE_SKIN || itemType == ITEM_TYPE_PLATE || itemType == ITEM_TYPE_ACCESSORY)
    {
        return GetItemWeight(item_id);
    }

    if(count <= 0) return 0.0;
    return GetItemWeight(item_id) * float(count);
}

stock bool:Inventory_CanAddEntryWeight(playerid, item_id, count, bool:notify = true)
{
    new Float:nextWeight = GetPlayerWeight(playerid) + Inventory_GetEntryWeight(item_id, count);
    if(nextWeight > GetPlayerMaxWeight(playerid))
    {
        if(notify) ShowClientNotification(playerid, 2, 5, 0, 0, "               ", "");
        return false;
    }
    return true;
}

stock Inventory_SetItem(playerid, slot, item_id, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;

    g_PlayerInventory[playerid][slot][inv_itemId] = item_id;
    g_PlayerInventory[playerid][slot][inv_itemCount] = count;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    format(g_PlayerInventory[playerid][slot][inv_itemPlate], 32, "%s", plate);
    g_PlayerInventory[playerid][slot][inv_itemType] = GetItemType(item_id);
    g_PlayerInventory[playerid][slot][inv_itemWeight] = floatround(GetItemWeight(item_id), floatround_floor);
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    g_PlayerInventory[playerid][slot][inv_activeSlot] = -1;

    return 1;
}

stock Inventory_SetActiveItem(playerid, activeSlot, item_id, count, const plate[] = "")
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;

    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = item_id;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = count;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemSlot] = activeSlot;
    format(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], 32, "%s", plate);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = GetItemType(item_id);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = floatround(GetItemWeight(item_id), floatround_floor);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = activeSlot;

    return 1;
}

stock Inv_MapSrvSlotToInt(serverSlot)
{
    if(serverSlot == SIM_SERVER_SLOT) return SIM_SLOT;
    if(serverSlot == SKIN_SERVER_SLOT) return SKIN_SLOT;

    if(serverSlot >= 0 && serverSlot <= 5) return serverSlot + 2;

    if(serverSlot >= 2 && serverSlot < MAX_ACTIVE_SLOTS) return serverSlot;

    return -1;
}
stock Inv_MapIntSlotToSrv(internalSlot, itemId)
{
    if(internalSlot == SIM_SLOT && itemId == 58) return SIM_SERVER_SLOT;
    if(internalSlot == SKIN_SLOT && itemId == 134) return SKIN_SERVER_SLOT;

    if(internalSlot >= 2 && internalSlot < MAX_ACTIVE_SLOTS) return internalSlot - 2;
    return internalSlot;
}
stock Inventory_ClearActiveSlot(playerid, activeSlot)
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate][0] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = false;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = -1;
    return 1;
}
stock Inventory_ClearAllActiveSkins(playerid, &oldSkin)
{
    oldSkin = 0;
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] == 134)
        {
            if(oldSkin <= 0) oldSkin = g_PlayerActiveSlots[playerid][i][inv_itemCount];
            Inventory_ClearActiveSlot(playerid, i);
        }
    }
    return 1;
}

stock Inventory_ValidateActiveSlots(playerid)
{
    new simSource = -1, simCount = 0, simPlate[32];
    simPlate[0] = 0;

    new skinSource = -1, skinCount = 0;

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        new itemId = g_PlayerActiveSlots[playerid][i][inv_itemId];
        if(itemId <= 0) continue;

        if(itemId == 58)
        {
            if(simSource == -1 || i == SIM_SLOT)
            {
                simSource = i;
                simCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
                format(simPlate, sizeof(simPlate), "%s", g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
            }
        }
        else if(itemId == 134)
        {
            if(skinSource == -1 || i == SKIN_SLOT)
            {
                skinSource = i;
                skinCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
            }
        }
    }

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        new itemId = g_PlayerActiveSlots[playerid][i][inv_itemId];
        if(itemId <= 0) continue;

        if(itemId == 58)
        {
            if(i != simSource)
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot != -1)
                {
                    Inventory_SetItem(playerid, freeSlot, itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount], g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
                    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount]));
                }
            }
            Inventory_ClearActiveSlot(playerid, i);
            continue;
        }

        if(itemId == 134)
        {
            if(i != skinSource)
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot != -1)
                {
                    Inventory_SetItem(playerid, freeSlot, itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount], g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
                    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount]));
                }
            }
            Inventory_ClearActiveSlot(playerid, i);
            continue;
        }

        if(Inventory_IsAccessoryItem(itemId))
        {
            if(i < 2 || i >= MAX_ACTIVE_SLOTS)
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot != -1)
                {
                    Inventory_SetItem(playerid, freeSlot, itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount], g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
                    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount]));
                }
                Inventory_ClearActiveSlot(playerid, i);
            }
            continue;
        }

        new freeSlot = Inventory_GetFreeSlot(playerid);
        if(freeSlot != -1)
        {
            Inventory_SetItem(playerid, freeSlot, itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount], g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
            SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(itemId, g_PlayerActiveSlots[playerid][i][inv_itemCount]));
        }
        Inventory_ClearActiveSlot(playerid, i);
    }

    if(simSource != -1)
    {
        Inventory_SetActiveItem(playerid, SIM_SLOT, 58, simCount, simPlate);
        new phone = strval(simPlate);
        if(phone <= 0) phone = simCount;
        g_PlayerPhoneNumber[playerid] = phone;
    }

    if(skinSource != -1)
    {
        Inventory_SetActiveItem(playerid, SKIN_SLOT, 134, skinCount, "");
        SetPlayerSkin(playerid, skinCount);
        PlayerInfo[playerid][P_SKIN] = skinCount;
    }

    return 1;
}
stock Inventory_SaveInventoryItem(playerid, slot)
{
    if(g_PlayerInventory[playerid][slot][inv_itemId] <= 0) return 0;

    new q[512];
    mysql_format(g_InventoryMySQL, q, sizeof(q),
        "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,%d,%d,'%e',0,-1)",
        GetPlayerAccountID(playerid), slot,
        g_PlayerInventory[playerid][slot][inv_itemId],
        g_PlayerInventory[playerid][slot][inv_itemCount],
        g_PlayerInventory[playerid][slot][inv_itemPlate]);
    mysql_query(g_InventoryMySQL, q, false);
    return 1;
}

stock Inventory_SaveActiveItem(playerid, activeSlot)
{
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] <= 0) return 0;

    new q[512];
    new serverSlot = Inv_MapIntSlotToSrv(activeSlot, g_PlayerActiveSlots[playerid][activeSlot][inv_itemId]);
    mysql_format(g_InventoryMySQL, q, sizeof(q),
        "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,%d,%d,'%e',1,%d)",
        GetPlayerAccountID(playerid), serverSlot,
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemId],
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount],
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate],
        serverSlot);
    mysql_query(g_InventoryMySQL, q, false);
    return 1;
}

stock Inventory_Save(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    Inventory_ValidateActiveSlots(playerid);

    new q[128];
    mysql_format(g_InventoryMySQL, q, sizeof(q), "DELETE FROM `player_inventory` WHERE `player_id` = %d", GetPlayerAccountID(playerid));
    mysql_query(g_InventoryMySQL, q, false);

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            Inventory_SaveInventoryItem(playerid, i);
        }
    }
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            Inventory_SaveActiveItem(playerid, i);
        }
    }

    Accessory_OnInventoryLoaded(playerid);
    return 1;
}

forward OnInventoryLoad(playerid);
public OnInventoryLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    Inventory_Reset(playerid);

    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        new itemId = cache_get_field_content_int(i, "item_id");
        new count = cache_get_field_content_int(i, "item_count");
        new isActive = cache_get_field_content_int(i, "is_active");
        new activeSlot = Inv_MapSrvSlotToInt(cache_get_field_content_int(i, "active_slot"));
        if(itemId == 58) activeSlot = SIM_SLOT;
        if(itemId == 134) activeSlot = SKIN_SLOT;
        new plate[32];
        cache_get_field_content(i, "item_plate", plate, g_InventoryMySQL, sizeof(plate));

        if(isActive)
        {
            if(activeSlot >= 0 && activeSlot < MAX_ACTIVE_SLOTS)
            {
                Inventory_SetActiveItem(playerid, activeSlot, itemId, count, plate);
                if(itemId == 134 && activeSlot == SKIN_SLOT)
                {
                    SetPlayerSkin(playerid, count);
                    PlayerInfo[playerid][P_SKIN] = count;
                }
                if(itemId == 58 && activeSlot == SIM_SLOT)
                {
                    new phone = strval(plate);
                    if(phone <= 0) phone = count;
                    g_PlayerPhoneNumber[playerid] = phone;
                }
            }
        }
        else
        {
            if(slot >= 0 && slot < MAX_INVENTORY_SLOTS)
            {
                Inventory_SetItem(playerid, slot, itemId, count, plate);
                SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(itemId, count));
            }
        }
    }
    Inventory_ValidateActiveSlots(playerid);
    Inventory_SyncMedChestFlag(playerid);
    Accessory_OnInventoryLoaded(playerid);
    return 1;
}

stock Inventory_Load(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new q[256];
    mysql_format(g_InventoryMySQL, q, sizeof(q),
        "SELECT `slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot` FROM `player_inventory` WHERE `player_id` = %d",
        GetPlayerAccountID(playerid));
    mysql_tquery(g_InventoryMySQL, q, "OnInventoryLoad", "d", playerid);
    return 1;
}

stock Inventory_GetFreeSlot(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 0) return i;
    }
    return -1;
}

stock Inventory_DeleteSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;

    new itemId = g_PlayerInventory[playerid][slot][inv_itemId];
    new cnt = g_PlayerInventory[playerid][slot][inv_itemCount];
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - Inventory_GetEntryWeight(itemId, cnt));

    g_PlayerInventory[playerid][slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemType] = 0;
    g_PlayerInventory[playerid][slot][inv_itemWeight] = 0;

    return 1;
}

stock Inventory_RemoveOneItem(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;

    new itemId = g_PlayerInventory[playerid][slot][inv_itemId];


    new itemType = GetItemType(itemId);
    if(itemType == ITEM_TYPE_SIM || itemType == ITEM_TYPE_SKIN || itemType == ITEM_TYPE_PLATE || itemType == ITEM_TYPE_ACCESSORY)
    {
        return Inventory_DeleteSlot(playerid, slot);
    }

    g_PlayerInventory[playerid][slot][inv_itemCount]--;
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - GetItemWeight(itemId));

    if(g_PlayerInventory[playerid][slot][inv_itemCount] <= 0)
    {
        Inventory_DeleteSlot(playerid, slot);
    }
    return 1;
}

stock Inventory_MoveItem(playerid, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(oldSlot == newSlot) return 1;

    new temp[E_INVENTORY_ITEM];
    temp = g_PlayerInventory[playerid][oldSlot];
    g_PlayerInventory[playerid][oldSlot] = g_PlayerInventory[playerid][newSlot];
    g_PlayerInventory[playerid][newSlot] = temp;

    g_PlayerInventory[playerid][oldSlot][inv_itemSlot] = oldSlot;
    g_PlayerInventory[playerid][newSlot][inv_itemSlot] = newSlot;
    return 1;
}

stock Inventory_AddItemToSlot(playerid, item_id, slot, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] > 0) return 0;

    if(!Inventory_CanAddEntryWeight(playerid, item_id, count)) return 0;

    Inventory_SetItem(playerid, slot, item_id, count, plate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(item_id, count));
    return 1;
}

stock bool:Inventory_AddItem(playerid, item_id, count)
{
    if(item_id <= 0 || count <= 0) return false;
    if(!Inventory_CanAddEntryWeight(playerid, item_id, count)) return false;

    new itemType = GetItemType(item_id);
    if(itemType == ITEM_TYPE_SIM || itemType == ITEM_TYPE_SKIN || itemType == ITEM_TYPE_PLATE || itemType == ITEM_TYPE_ACCESSORY)
    {
        for(new i = 0; i < count; i++)
        {
            new slot = Inventory_GetFreeSlot(playerid);
            if(slot == -1) return false;
            if(!Inventory_AddItemToSlot(playerid, item_id, slot, 1, "")) return false;
        }
        return true;
    }

    for(new s = 0; s < MAX_INVENTORY_SLOTS; s++)
    {
        if(g_PlayerInventory[playerid][s][inv_itemId] == item_id)
        {
            g_PlayerInventory[playerid][s][inv_itemCount] += count;
            SetPlayerWeight(playerid, GetPlayerWeight(playerid) + Inventory_GetEntryWeight(item_id, count));
            return true;
        }
    }

    new slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return false;
    return Inventory_AddItemToSlot(playerid, item_id, slot, count, "") != 0;
}

stock bool:Inventory_AddAccessoryItem(playerid, accessoryId, itemIdOverride = -1)
{
    if(accessoryId < 0) return false;

    new slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return false;

    new accessoryText[16];
    format(accessoryText, sizeof(accessoryText), "%d", accessoryId);
    new invItemId = itemIdOverride;
    if(invItemId <= 0) invItemId = INVENTORY_ACCESSORY_ITEM_BASE + accessoryId;
    return Inventory_AddItemToSlot(playerid, invItemId, slot, 1, accessoryText) != 0;
}
stock Inventory_CountFreeSlots(playerid)
{
    new freeSlots = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 0) freeSlots++;
    }
    return freeSlots;
}

stock bool:Inventory_AddSkinItems(playerid, skinModel, amount)
{
    if(skinModel <= 0 || amount <= 0) return false;
    if(Inventory_CountFreeSlots(playerid) < amount) return false;
    if(!Inventory_CanAddEntryWeight(playerid, 134, amount)) return false;

    for(new i = 0; i < amount; i++)
    {
        new slot = Inventory_GetFreeSlot(playerid);
        if(slot == -1) return false;
        if(!Inventory_AddItemToSlot(playerid, 134, slot, skinModel, "")) return false;
    }
    return true;
}

stock Inventory_SendUseNotification(playerid, item_id)
{
    #pragma unused playerid
    #pragma unused item_id
    return 1;
}

stock bool:Inventory_UseSkinFromSlot(playerid, slot, &newSkinModel)
{
    newSkinModel = 0;

    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    if(g_PlayerInventory[playerid][slot][inv_itemId] != 134) return false;

    new targetSkin = g_PlayerInventory[playerid][slot][inv_itemCount];
    if(targetSkin <= 0) return false;

    new oldActiveSkin = PlayerInfo[playerid][P_SKIN];
    new oldSkinFromSlots;
    Inventory_ClearAllActiveSkins(playerid, oldSkinFromSlots);
    if(oldSkinFromSlots > 0) oldActiveSkin = oldSkinFromSlots;

    if(!Inventory_DeleteSlot(playerid, slot)) return false;

    Inventory_SetActiveItem(playerid, SKIN_SLOT, 134, targetSkin, "");

    SetPlayerSkin(playerid, targetSkin);
    PlayerInfo[playerid][P_SKIN] = targetSkin;
    UpdatePlayerDatabaseInt(playerid, "Skin", targetSkin);

    if(oldActiveSkin > 0 && oldActiveSkin != targetSkin)
    {
        new oldSkinSlot = slot;
        if(!Inventory_SetItem(playerid, oldSkinSlot, 134, oldActiveSkin, ""))
        {
            oldSkinSlot = Inventory_GetFreeSlot(playerid);
            if(oldSkinSlot == -1) return false;
            if(!Inventory_SetItem(playerid, oldSkinSlot, 134, oldActiveSkin, "")) return false;
        }
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(134));
    }

    newSkinModel = targetSkin;
    return true;
}

stock bool:Inventory_UseSIMFromSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    if(g_PlayerInventory[playerid][slot][inv_itemId] != 58) return false;

    new usedCount = g_PlayerInventory[playerid][slot][inv_itemCount];
    new usedPlate[32];
    format(usedPlate, sizeof(usedPlate), "%s", g_PlayerInventory[playerid][slot][inv_itemPlate]);

    new oldActiveCount = 0;
    new oldActivePlate[32];
    oldActivePlate[0] = 0;
    if(g_PlayerActiveSlots[playerid][SIM_SLOT][inv_itemId] == 58)
    {
        oldActiveCount = g_PlayerActiveSlots[playerid][SIM_SLOT][inv_itemCount];
        format(oldActivePlate, sizeof(oldActivePlate), "%s", g_PlayerActiveSlots[playerid][SIM_SLOT][inv_itemPlate]);
    }

    if(!Inventory_DeleteSlot(playerid, slot)) return false;

    if(oldActiveCount > 0)
    {
        if(!Inventory_SetItem(playerid, slot, 58, oldActiveCount, oldActivePlate)) return false;
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(58));
    }

    Inventory_SetActiveItem(playerid, SIM_SLOT, 58, usedCount, usedPlate);

    new phone = strval(usedPlate);
    if(phone <= 0) phone = usedCount;
    g_PlayerPhoneNumber[playerid] = phone;
    return true;
}

stock Inventory_EquipItem(playerid, item_id, invSlot, &activeSlot)
{
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] != item_id) return 0;

    new itemType = GetItemType(item_id);
    new targetSlot = -1;

    switch(itemType)
    {
        case ITEM_TYPE_SIM: targetSlot = SIM_SLOT;
        case ITEM_TYPE_SKIN: targetSlot = SKIN_SLOT;
        case ITEM_TYPE_ACCESSORY:
        {
            new accessoryId = -1;
            if(g_PlayerInventory[playerid][invSlot][inv_itemPlate][0] != 0)
                accessoryId = strval(g_PlayerInventory[playerid][invSlot][inv_itemPlate]);
            if(accessoryId < 0) accessoryId = Inv_GetAccIdByItem(item_id);
            if(accessoryId < 0) accessoryId = g_PlayerInventory[playerid][invSlot][inv_itemCount];

            if(!Accessory_CanEquip(playerid, accessoryId))
                return 0;

            for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
            {
                if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0)
                {
                    targetSlot = s;
                    break;
                }
            }
        }
        default: return 0;
    }

    if(targetSlot < 0 || targetSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(g_PlayerActiveSlots[playerid][targetSlot][inv_itemId] > 0) return 0;

    Inventory_SetActiveItem(playerid, targetSlot,
        g_PlayerInventory[playerid][invSlot][inv_itemId],
        g_PlayerInventory[playerid][invSlot][inv_itemCount],
        g_PlayerInventory[playerid][invSlot][inv_itemPlate]);

    Inventory_DeleteSlot(playerid, invSlot);

    if(item_id == 58)
    {
        new phone = strval(g_PlayerActiveSlots[playerid][targetSlot][inv_itemPlate]);
        if(phone <= 0) phone = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        g_PlayerPhoneNumber[playerid] = phone;
    }
    else if(item_id == 134)
    {
        SetPlayerSkin(playerid, g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount]);
        PlayerInfo[playerid][P_SKIN] = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        UpdatePlayerDatabaseInt(playerid, "Skin", PlayerInfo[playerid][P_SKIN]);
    }
    else if(itemType == ITEM_TYPE_ACCESSORY)
    {
        new accessoryId = -1;
        if(g_PlayerActiveSlots[playerid][targetSlot][inv_itemPlate][0] != 0)
            accessoryId = strval(g_PlayerActiveSlots[playerid][targetSlot][inv_itemPlate]);
        if(accessoryId < 0) accessoryId = Inv_GetAccIdByItem(g_PlayerActiveSlots[playerid][targetSlot][inv_itemId]);
        if(accessoryId < 0) accessoryId = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];

        Accessory_OnEquipped(playerid, targetSlot, accessoryId);
    }

    activeSlot = targetSlot;
    return 1;
}
stock Inventory_MoveFromSlotToInv(playerid, item_id, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerActiveSlots[playerid][oldSlot][inv_itemId] != item_id) return 0;
    if(g_PlayerInventory[playerid][newSlot][inv_itemId] > 0) return 0;

    Inventory_SetItem(playerid, newSlot,
        g_PlayerActiveSlots[playerid][oldSlot][inv_itemId],
        g_PlayerActiveSlots[playerid][oldSlot][inv_itemCount],
        g_PlayerActiveSlots[playerid][oldSlot][inv_itemPlate]);

    if(Inventory_IsAccessoryItem(item_id))
        Accessory_OnUnequipped(playerid, oldSlot);

    if(item_id == 58 && oldSlot == SIM_SLOT)
        g_PlayerPhoneNumber[playerid] = 0;

    Inventory_ClearActiveSlot(playerid, oldSlot);
    return 1;
}

stock Inventory_DeleteFromActiveSlot(playerid, item_id, activeSlot)
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] != item_id) return 0;

    if(Inventory_IsAccessoryItem(item_id))
        Accessory_OnUnequipped(playerid, activeSlot);

    if(item_id == 58 && activeSlot == SIM_SLOT)
        g_PlayerPhoneNumber[playerid] = 0;

    Inventory_ClearActiveSlot(playerid, activeSlot);
    return 1;
}

stock Inventory_EquipSIM(playerid, invSlot)
{
    new activeSlot;
    return Inventory_EquipItem(playerid, 58, invSlot, activeSlot);
}

stock ShowPlayerInventory(playerid)
{
    Inventory_ValidateActiveSlots(playerid);
    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = JSON_Array();
    new Node:JSONObject;

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            itemsArray = JSON_Append(itemsArray, JSON_Array(
                JSON_Int(g_PlayerInventory[playerid][i][inv_itemId]),
                JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]),
                JSON_Int(i),
                JSON_Int(0)
            ));
        }
    }

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Array(
                JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemId]),
                JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemCount]),
                JSON_Int(Inv_MapIntSlotToSrv(i, g_PlayerActiveSlots[playerid][i][inv_itemId])),
                JSON_Int(0)
            ));
        }
    }

    JSONObject = JSON_Object(
        "o", JSON_Int(1),
        "i", JSON_Int(0),
        "n", JSON_String(GetPlayerNameEx(playerid)),
        "lv", JSON_Int(GetPlayerLevel(playerid)),
        "id", JSON_Int(playerid),
        "v", JSON_Int(3),
        "ps", JSON_Int(GetPlayerSkin(playerid)),
        "m", JSON_Int(GetPlayerMoney(playerid)),
        "s", JSON_Int(79),
        "w", JSON_Float(GetPlayerWeight(playerid)),
        "mw", JSON_Float(GetPlayerMaxWeight(playerid)),
        "sl", JSON_Int(MAX_INVENTORY_SLOTS),
        "nm", JSON_Int(GetPlayerPhone(playerid)),
        "en", JSON_String(""),
        "it", itemsArray,
        "ai", activeSlotsArray,
        "wi", JSON_Array()
    );

    ShowPlayerGUI(playerid, 33, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

stock bool:Inventory_HandlePacket(playerid, Node:JSONObject)
{
    new Node:response = JSON_Object();
    new type;
    JSON_GetInt(JSONObject, "t", type);

    new item_id = 0, pos = -1, old_pos = -1, count = 0;
    new bool:ok = false;

    switch(type)
    {
        case 0:
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "s", count);
            JSON_GetInt(JSONObject, "sl", pos);
            if(count <= 0) count = 1;

            if(pos >= 0 && pos < MAX_INVENTORY_SLOTS)
            {
                ok = Inventory_AddItemToSlot(playerid, item_id, pos, count, "") != 0;
            }
            else
            {
                ok = Inventory_AddItem(playerid, item_id, count);
            }

            JSON_SetInt(response, "t", 0);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 4:
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "os", old_pos);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);

            new old_pos_server = old_pos;
            old_pos = Inv_MapSrvSlotToInt(old_pos);

            if(item_id == 134 && (old_pos_server == 6 || old_pos == SKIN_SLOT))
            {
                ok = false;
            }
            else
            {
                ok = Inventory_MoveFromSlotToInv(playerid, item_id, old_pos, pos) != 0;
            }

            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 5:
        {
            new activeSlot;
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "sl", pos);
            ok = Inventory_EquipItem(playerid, item_id, pos, activeSlot) != 0;

            JSON_SetInt(response, "t", 5);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            if(ok)
            {
                JSON_SetInt(response, "i", Inv_MapIntSlotToSrv(activeSlot, item_id));
                JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
            }
        }
        case 18:
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);

            if(pos >= 0 && pos < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][pos][inv_itemId] == item_id)
            {
                ok = Inventory_RemoveOneItem(playerid, pos) != 0;
            }
            else
            {
                new activeSlot = Inv_MapSrvSlotToInt(pos);
                if(activeSlot >= 0 && activeSlot < MAX_ACTIVE_SLOTS)
                {
                    ok = Inventory_DeleteFromActiveSlot(playerid, item_id, activeSlot) != 0;
                }

                if(!ok && pos >= 0 && pos < MAX_ACTIVE_SLOTS)
                {
                    ok = Inventory_DeleteFromActiveSlot(playerid, item_id, pos) != 0;
                }
            }

            JSON_SetInt(response, "t", 18);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 19:
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);

            if(item_id == 22)
            {
                new usedSlot = pos;
                ok = Inventory_UseMedChest(playerid, pos, usedSlot);
                if(ok) Inventory_SendUseNotification(playerid, item_id);
            }
            else if(item_id == 23)
            {
                new usedSlot = pos;
                ok = Inventory_UseRepairKit(playerid, pos, usedSlot);
                if(ok) Inventory_SendUseNotification(playerid, item_id);
            }
            else if(item_id == 134)
            {
                new skinModel;
                ok = Inventory_UseSkinFromSlot(playerid, pos, skinModel);
                if(ok) Inventory_SendUseNotification(playerid, item_id);
            }
            else if(item_id == 58)
            {
                ok = Inventory_UseSIMFromSlot(playerid, pos);
                if(ok) Inventory_SendUseNotification(playerid, item_id);
            }
            else if(Inventory_IsAccessoryItem(item_id))
            {
                ok = Accessory_UseFromInventory(playerid, pos);
                if(ok) Inventory_SendUseNotification(playerid, item_id);
            }
            else
            {
                ok = Inventory_RemoveOneItem(playerid, pos) != 0;
                if(ok) Inventory_SendUseNotification(playerid, item_id);
            }

            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 23:
        {
            JSON_GetInt(JSONObject, "os", old_pos);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            ok = Inventory_MoveItem(playerid, old_pos, pos) != 0;

            JSON_SetInt(response, "t", 23);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            if(ok) JSON_SetInt(response, "i", pos);
        }
        case 32:
        {
            JSON_GetInt(JSONObject, "sl", pos);
            ok = Inventory_EquipSIM(playerid, pos) != 0;
            JSON_SetInt(response, "t", 32);
            JSON_SetInt(response, "s", ok ? 1 : 0);
        }
        default:
        {
            JSON_SetInt(response, "t", type);
            JSON_SetInt(response, "s", 0);
        }
    }

    Inventory_ValidateActiveSlots(playerid);
    Inventory_SyncMedChestFlag(playerid);
    if(ok) Inventory_Save(playerid);
    if(ok && type == 19) ShowPlayerInventory(playerid);

    OnPacketIncoming(playerid, 33, response);
    JSON_Cleanup(response);

    return true;
}

forward OnCheckInvDb(playerid, targetid);
public OnCheckInvDb(playerid, targetid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows, fields;
    cache_get_data(rows, fields);

    new invCount = 0;
    if(rows > 0)
    {
        invCount = cache_get_field_content_int(0, "cnt");
    }

    new msg[144];
    format(msg, sizeof(msg), "DB check -> player: %s | account_id: %d | inventory_rows: %d",
        GetPlayerNameEx(targetid), GetPlayerAccountID(targetid), invCount);
    SendClientMessage(playerid, -1, msg);
    return 1;
}






// Accessory functions implemented in accessory.inc

// ---- Compatibility aliases ----
#define SaveInventoryItem(%0,%1) Inventory_SaveInventoryItem(%0,%1)

stock SyncPlayerPhoneFromInventory(playerid)
{
    new phone = 0;
    if(g_PlayerActiveSlots[playerid][SIM_SLOT][inv_itemId] == 58)
    {
        phone = g_PlayerActiveSlots[playerid][SIM_SLOT][inv_itemCount];
        new plate[32];
        format(plate, 32, "%s", g_PlayerActiveSlots[playerid][SIM_SLOT][inv_itemPlate]);
        if(strval(plate) > 0) phone = strval(plate);
    }
    g_PlayerPhoneNumber[playerid] = phone;
    SetPlayerData(playerid, P_PHONE, phone);
    return phone;
}

stock bool:Inventory_AddSIM(playerid, slot, phoneNumber)
{
    new plateStr[32];
    format(plateStr, sizeof(plateStr), "%d", phoneNumber);
    if(slot >= 0 && slot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][slot][inv_itemId] == 0)
        return Inventory_AddItemToSlot(playerid, 58, slot, phoneNumber, plateStr) != 0;
    return Inventory_AddItem(playerid, 58, 1) != 0;
}

stock bool:Inventory_SwapSkin(playerid, slot)
{
    new newSkin;
    return Inventory_UseSkinFromSlot(playerid, slot, newSkin);
}

stock Inventory_SendSkinUpdatePacket(playerid, skinModel)
{
    #pragma unused skinModel
    ShowPlayerInventory(playerid);
    return 1;
}
cmd:inv(playerid)
{
ShowPlayerInventory(playerid);
}
