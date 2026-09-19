#if defined _inv_included
    #endinput
#endif
#define _inv_included


#if !defined DIALOG_TRADE_NEAR_PLAYERS
    #define DIALOG_TRADE_NEAR_PLAYERS 28750
#endif

#if !defined TRADE_MAX_NEAR_PLAYERS
    #define TRADE_MAX_NEAR_PLAYERS 20
#endif

#if !defined TRADE_NOTIFY_ACCEPT
    #define TRADE_NOTIFY_ACCEPT 7
#endif

#define MAX_INVENTORY_SLOTS   40
#define MAX_ACTIVE_SLOTS       8

#define SLOT_SIM               0
#define SLOT_SKIN              1
#define SLOT_ACCESSORY_START   2
#define SLOT_ACCESSORY_END     7

#define ITEM_TYPE_OTHER        0
#define ITEM_TYPE_SKIN         1
#define ITEM_TYPE_SIM          2
#define ITEM_TYPE_PLATE        3
#define ITEM_TYPE_FOOD         4
#define ITEM_TYPE_MEDICAL      5
#define ITEM_TYPE_ACCESSORY    6

#define INVENTORY_ITEM_SIM      58
#define INVENTORY_ITEM_SIM_BAD_V14 255

#define MAX_TRADE_SLOTS 12

#define SendPacketToClient(%0,%1,%2) ShowPlayerGUI(%0,%1,%2)

enum e_TRADE_DATA
{
    trade_Partner,
    bool:trade_IsOpen,
    bool:trade_Confirmed,
    trade_Money,
    trade_Items[MAX_TRADE_SLOTS],
    trade_ItemId[MAX_TRADE_SLOTS],
    trade_ItemCount[MAX_TRADE_SLOTS]
};

new TradeData[MAX_PLAYERS][e_TRADE_DATA];

stock Accessory_GetModelIdByItemId(itemId)
{
    new accessoryId = Accessory_GetAccIdByInvItem(itemId);
    if(accessoryId >= 0 && accessoryId < sizeof(accessory))
    {
        return accessory[accessoryId][ID_ACCESSORY];
    }
    return -1;
}

stock bool:Inventory_IsSIMItem(itemId)
{
    return (itemId == INVENTORY_ITEM_SIM);
}

#define INVENTORY_ACCESSORY_ITEM_BASE   (201)
#define INVENTORY_ACCESSORY_ITEM_LIMIT  (1600)

enum E_INVENTORY_ITEM
{
    inv_itemId,
    inv_itemCount,
    inv_itemSlot,
    inv_itemPlate[32],
    inv_itemName[64],
    inv_itemType,
    inv_itemWeight,
    bool:inv_itemActive,
    inv_activeSlot
}

new g_PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][E_INVENTORY_ITEM];
new g_PlayerActiveSlots[MAX_PLAYERS][MAX_ACTIVE_SLOTS][E_INVENTORY_ITEM];
new Float:g_PlayerWeight[MAX_PLAYERS];
new Float:g_PlayerMaxWeight[MAX_PLAYERS] = {150.0, ...};
new g_PlayerPhoneNumber[MAX_PLAYERS];
new g_PlayerMedChest[MAX_PLAYERS];


#define TRADE_MAX_ITEMS 20

new bool:g_TradeActive[MAX_PLAYERS];
new bool:g_TradeReady[MAX_PLAYERS];
new g_TradePartner[MAX_PLAYERS];
new g_TradeMoney[MAX_PLAYERS];
new g_TradeItemsCount[MAX_PLAYERS];
new g_TradeItemId[MAX_PLAYERS][TRADE_MAX_ITEMS];
new g_TradeItemCount[MAX_PLAYERS][TRADE_MAX_ITEMS];
new g_TradeItemSlot[MAX_PLAYERS][TRADE_MAX_ITEMS];
new g_TradeItemPlate[MAX_PLAYERS][TRADE_MAX_ITEMS][32];
new g_TradeNearList[MAX_PLAYERS][TRADE_MAX_NEAR_PLAYERS];
new g_TradeNearCount[MAX_PLAYERS];
new g_TradeInviteFrom[MAX_PLAYERS];
new g_TradeOfferItemSlot[MAX_PLAYERS];



#define MAX_TRUNK_SLOTS 40
#define TRUNK_OPEN_DISTANCE 5.0
#define TRUNK_REAR_OFFSET 2.3
#define TRUNK_REAR_CHECK_DISTANCE 2.8

#if !defined TRUNK_GUI
    #define TRUNK_GUI      2
#endif
new g_TrunkVehicleDB[MAX_PLAYERS];
new g_TrunkItems[MAX_PLAYERS][MAX_TRUNK_SLOTS][E_INVENTORY_ITEM];
new Float:g_TrunkWeight[MAX_PLAYERS];
new Float:g_TrunkMaxWeight[MAX_PLAYERS] = {150.0, ...};
new bool:g_TrunkNotifyZone[MAX_PLAYERS];



// SHINKA_INVENTORY_COMPAT_SYMBOLS_V2
stock InventoryTrade_Cancel(playerid, bool:closeGui = true)
{
    return Trade_Cancel(playerid, closeGui);
}

stock SaveActiveSlotItem(playerid, slot)
{
    #pragma unused slot
    return Inventory_Save(playerid);
}

stock ResetPlayerInventory(playerid)
{
    return Inventory_Reset(playerid);
}

stock Trunk_LoadVehicle(vehicleid, oc_id)
{
    #pragma unused vehicleid
    #pragma unused oc_id
    return 1;
}

stock Trunk_SaveVehicle(vehicleid, oc_id)
{
    #pragma unused vehicleid
    #pragma unused oc_id
    return 1;
}

forward OnInventoryLoad(playerid);
forward Trunk_GlobalTimer();



stock SaveInventoryItem(playerid, slot)
{
    #pragma unused slot
    return Inventory_Save(playerid);
}

stock JoinPlate(const plate[], const region[], output[], output_size)
{
    if(output_size <= 0) return 0;
    output[0] = 0;
    if(strlen(region) > 0)
    {
        format(output, output_size, "%s|%s", plate, region);
    }
    else
    {
        format(output, output_size, "%s", plate);
    }
    return 1;
}

// --- Target mod compatibility layer ---
stock Accessory_GetAccIdByInvItem(itemId)
{
    if(itemId <= 0) return -1;
    if(Accessory_GetModelIdByItemId(itemId) != -1) return itemId;
    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT) return itemId - INVENTORY_ACCESSORY_ITEM_BASE;
    return -1;
}

stock Accessory_OnUnequipped(playerid, activeSlot)
{
    if(0 <= activeSlot < MAX_PLAYER_ATTACHED_OBJECTS) RemovePlayerAttachedObject(playerid, activeSlot);
    return 1;
}

stock Accessory_DeleteSlotFromDB(playerid, activeSlot)
{
    #pragma unused playerid
    #pragma unused activeSlot
    return 1;
}

stock Accessory_SaveAllSlots(playerid)
{
    #pragma unused playerid
    return 1;
}

stock Accessory_LoadAllFromDB(playerid)
{
    #pragma unused playerid
    return 1;
}

stock Accessory_OnInventoryLoaded(playerid)
{
    for(new activeSlot = SLOT_ACCESSORY_START; activeSlot <= SLOT_ACCESSORY_END; activeSlot++)
    {
        new itemId = g_PlayerActiveSlots[playerid][activeSlot][inv_itemId];
        if(itemId <= 0) continue;
        new modelId = Accessory_GetModelIdByItemId(itemId);
        if(modelId == -1) continue;
        if(0 <= activeSlot < MAX_PLAYER_ATTACHED_OBJECTS)
        {
            RemovePlayerAttachedObject(playerid, activeSlot);
            SetPlayerAttachedObject(playerid, activeSlot, modelId, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);
        }
    }
    return 1;
}

stock bool:Accessory_UseFromInventory(playerid, invSlot)
{
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return false;

    new itemId = g_PlayerInventory[playerid][invSlot][inv_itemId];
    if(itemId <= 0) return false;
    if(!Inventory_IsAccessoryItem(itemId)) return false;

    new activeSlot = -1;
    for(new s = SLOT_ACCESSORY_START; s <= SLOT_ACCESSORY_END; s++)
    {
        if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0)
        {
            activeSlot = s;
            break;
        }
    }
    if(activeSlot == -1)
    {
        SendClientMessage(playerid, -1, "Accessory editor: no free accessory slot.");
        return false;
    }

    new modelId = Accessory_GetModelIdByItemId(itemId);
    if(modelId == -1)
    {
        SendClientMessage(playerid, -1, "Accessory editor: model not found for inventory item.");
        return false;
    }

    new bone = 1;
    for(new a = 0; a < sizeof(accessory); a++)
    {
        if(accessory[a][ID_ACCESSORY] == modelId)
        {
            bone = accessory[a][BONE_ACCESSORY];
            break;
        }
    }

    new Node:closeInv = JSON_Object("o", JSON_Int(0), "s", JSON_Int(79));
    SendPacketToClient(playerid, 33, closeInv);
    JSON_Cleanup(closeInv);

    SetPVarInt(playerid, "inv_slot", invSlot);
    SetPVarInt(playerid, "item_id", itemId);
    SetPVarInt(playerid, "model_id", modelId);
    SetPVarInt(playerid, "modelid", modelId);
    SetPVarInt(playerid, "target_slot", activeSlot);
    SetPVarInt(playerid, "target_bone", bone);
    SetPVarInt(playerid, "slot", activeSlot);
    SetPVarInt(playerid, "bone", bone);
    SetPVarInt(playerid, "updateacs", 0);
    SetPVarInt(playerid, "acs_use", 1);

    SetPVarFloat(playerid, "num_1", 0.0);
    SetPVarFloat(playerid, "num_2", 0.0);
    SetPVarFloat(playerid, "num_3", 0.0);
    SetPVarFloat(playerid, "num_4", 0.0);
    SetPVarFloat(playerid, "num_5", 0.0);
    SetPVarFloat(playerid, "num_6", 0.0);
    SetPVarFloat(playerid, "num_7", 1.0);
    SetPVarFloat(playerid, "num_8", 1.0);
    SetPVarFloat(playerid, "num_9", 1.0);

    if(0 <= activeSlot < MAX_PLAYER_ATTACHED_OBJECTS)
    {
        RemovePlayerAttachedObject(playerid, activeSlot);
        SetPlayerAttachedObject(playerid, activeSlot, modelId, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);
    }

    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
    CreateAcsTextDraw(playerid);
    SendClientMessage(playerid, -1, "Accessory editor: textdraw editor opened. Save to wear accessory.");

    return true;
}

stock Inventory_RemoveItem(playerid, slot, count)
{
    if(count <= 0) return 0;
    for(new i = 0; i < count; i++)
    {
        if(!Inventory_RemoveOneItem(playerid, slot)) return 0;
    }
    Inventory_Save(playerid);
    return 1;
}

stock Inventory_DeleteItem(playerid, slot)
{
    new result = Inventory_DeleteSlot(playerid, slot);
    if(result) Inventory_Save(playerid);
    return result;
}

stock Inventory_GetItemID(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    return g_PlayerInventory[playerid][slot][inv_itemId];
}

stock Inventory_GetItemCount(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    return g_PlayerInventory[playerid][slot][inv_itemCount];
}

stock GetPlayerActiveSlots(playerid)
{
    new count = 0;
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++) if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0) count++;
    return count;
}

stock GetPlayerPhoneNumber(playerid) return g_PlayerPhoneNumber[playerid];
stock SetPlayerPhoneNumber(playerid, number) return Inventory_SetPlayerSIM(playerid, number);

stock GetItemName(itemId, name[], len = sizeof(name))
{
    Trade_GetItemName(itemId, name, len);
    return 1;
}

stock Inventory_AddSIM(playerid, slot, phoneNumber)
{
    if(slot >= 0 && slot < MAX_INVENTORY_SLOTS)
    {
        new plate[16]; valstr(plate, phoneNumber);
        return Inventory_AddItemToSlot(playerid, slot, INVENTORY_ITEM_SIM, 1, plate);
    }
    return Inventory_AddSIMCard(playerid, phoneNumber);
}

stock Inventory_AddNumberPlate(playerid, slot, item_id, const plate_text[])
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return 0;
    return Inventory_AddItemToSlot(playerid, slot, item_id, 1, plate_text);
}

stock Inventory_RemoveAccessoryItem(playerid, slot)
{
    return Inventory_DeleteItem(playerid, slot);
}
// --- End target mod compatibility layer ---

stock Inv_ShowNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));
    SendPacketToClient(playerid, 13, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

stock GetItemType(itemId)
{
    if(itemId == 134) return ITEM_TYPE_SKIN;
    if(Inventory_IsSIMItem(itemId)) return ITEM_TYPE_SIM;
    if(itemId == 22 || itemId == 23) return ITEM_TYPE_MEDICAL;
    if(itemId == 135) return ITEM_TYPE_FOOD;
    if(Accessory_GetAccIdByInvItem(itemId) >= 0) return ITEM_TYPE_ACCESSORY;
    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT) return ITEM_TYPE_ACCESSORY;
    switch(itemId)
    {
        case 145..161, 169..170, 180, 187, 200..424, 426, 428, 431..436: return ITEM_TYPE_ACCESSORY;
        case 438..451, 454..459, 464, 466..467, 470, 475..476, 490, 493..494: return ITEM_TYPE_ACCESSORY;
        case 497..502, 508..511, 513, 515..517, 520..522, 527, 531..534, 536: return ITEM_TYPE_ACCESSORY;
        case 576, 578..579, 582..583, 585, 660..664, 682, 685, 709: return ITEM_TYPE_ACCESSORY;
        case 914..918, 939, 944..946, 949: return ITEM_TYPE_ACCESSORY;
    }
    if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83) return ITEM_TYPE_PLATE;
    return ITEM_TYPE_OTHER;
}

stock bool:Inventory_IsSingleSlotItem(itemId)
{
    switch(GetItemType(itemId))
    {
        case ITEM_TYPE_SIM, ITEM_TYPE_SKIN, ITEM_TYPE_PLATE, ITEM_TYPE_ACCESSORY: return true;
    }
    return false;
}

stock Inventory_GetWeightAmount(itemId, count)
{
    if(count <= 0) return 0;
    if(Inventory_IsSingleSlotItem(itemId)) return 1;
    return count;
}

stock Float:GetItemWeight(itemId)
{
    if(Inventory_IsSIMItem(itemId)) return 1.0;
    if(itemId == 134) return 5.0;
    if(itemId == 22) return 2.5;
    if(itemId == 23) return 5.0;
    if(Accessory_GetAccIdByInvItem(itemId) >= 0) return 3.0;
    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT) return 3.0;
    switch(itemId)
    {
        case 145..161, 169..170, 180, 187, 200..424, 426, 428, 431..436: return 3.0;
        case 438..451, 454..459, 464, 466..467, 470, 475..476, 490, 493..494: return 3.0;
        case 497..502, 508..511, 513, 515..517, 520..522, 527, 531..534, 536: return 3.0;
        case 576, 578..579, 582..583, 585, 660..664, 682, 685, 709: return 3.0;
        case 914..918, 939, 944..946, 949: return 3.0;
    }
    return 5.0;
}

stock bool:Inventory_IsAccessoryItem(itemId)
{
    if(Accessory_GetAccIdByInvItem(itemId) >= 0) return true;
    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT) return true;
    switch(itemId)
    {
        case 145..161, 169..170, 180, 187, 200..424, 426, 428, 431..436: return true;
        case 438..451, 454..459, 464, 466..467, 470, 475..476, 490, 493..494: return true;
        case 497..502, 508..511, 513, 515..517, 520..522, 527, 531..534, 536: return true;
        case 576, 578..579, 582..583, 585, 660..664, 682, 685, 709: return true;
        case 914..918, 939, 944..946, 949: return true;
    }
    return false;
}

stock Inv_GetAccIdByItem(itemId)
{
    if(!Inventory_IsAccessoryItem(itemId)) return -1;
    return itemId - INVENTORY_ACCESSORY_ITEM_BASE;
}

stock Inventory_ToGuiActiveSlot(activeSlot, itemId)
{
    if(Inventory_IsSIMItem(itemId) || activeSlot == SLOT_SIM) return 255;
    if(itemId == 134 || activeSlot == SLOT_SKIN) return 6;
    if(activeSlot >= SLOT_ACCESSORY_START && activeSlot <= SLOT_ACCESSORY_END) return activeSlot - SLOT_ACCESSORY_START;
    return activeSlot;
}

stock Inventory_FromGuiActiveSlot(itemId, guiSlot)
{
    if(Inventory_IsSIMItem(itemId) || guiSlot == 255) return SLOT_SIM;
    if(itemId == 134 || guiSlot == 6) return SLOT_SKIN;
    if(Inventory_IsAccessoryItem(itemId))
    {
        if(guiSlot >= 0 && guiSlot <= 5) return guiSlot + SLOT_ACCESSORY_START;
        if(guiSlot >= SLOT_ACCESSORY_START && guiSlot <= SLOT_ACCESSORY_END) return guiSlot;
    }
    return guiSlot;
}

stock Inventory_ResolveActiveSlotFromGui(playerid, itemId, guiSlot)
{
    new slot = Inventory_FromGuiActiveSlot(itemId, guiSlot);

    if(slot >= 0 && slot < MAX_ACTIVE_SLOTS)
    {
        if(g_PlayerActiveSlots[playerid][slot][inv_itemId] == itemId) return slot;
        if(Inventory_IsAccessoryItem(g_PlayerActiveSlots[playerid][slot][inv_itemId]) && (itemId <= 0 || Inventory_IsAccessoryItem(itemId))) return slot;
    }

    if(guiSlot >= 0 && guiSlot <= 5)
    {
        new accSlot = guiSlot + SLOT_ACCESSORY_START;
        if(accSlot >= SLOT_ACCESSORY_START && accSlot <= SLOT_ACCESSORY_END)
        {
            if(Inventory_IsAccessoryItem(g_PlayerActiveSlots[playerid][accSlot][inv_itemId])) return accSlot;
        }
    }

    return slot;
}

stock Inventory_GetCorrectActiveSlot(playerid, itemId, activeSlot)
{
    switch(GetItemType(itemId))
    {
        case ITEM_TYPE_SIM: return SLOT_SIM;
        case ITEM_TYPE_SKIN: return SLOT_SKIN;
        case ITEM_TYPE_ACCESSORY:
        {
            if(activeSlot >= SLOT_ACCESSORY_START && activeSlot <= SLOT_ACCESSORY_END && g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] == 0)
            {
                return activeSlot;
            }

            for(new s = SLOT_ACCESSORY_START; s <= SLOT_ACCESSORY_END; s++)
            {
                if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0) return s;
            }
            return -1;
        }
    }
    return -1;
}

stock bool:Inventory_AddAccessoryItem(playerid, accessoryId, itemIdOverride = -1)
{
    if(accessoryId < 0) return false;

    new itemId = itemIdOverride;
    if(itemId <= 0) itemId = INVENTORY_ACCESSORY_ITEM_BASE + accessoryId;

    new Float:weightAdd = GetItemWeight(itemId);
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return false;

    new slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return false;

    new plateStr[12];
    valstr(plateStr, accessoryId);

    return Inventory_AddItemToSlot(playerid, slot, itemId, 1, plateStr) != 0;
}


stock Float:GetPlayerWeight(playerid) { return g_PlayerWeight[playerid]; }
stock SetPlayerWeight(playerid, Float:weight) { if(weight < 0.0) weight = 0.0; g_PlayerWeight[playerid] = weight; }
stock Float:GetPlayerMaxWeight(playerid) { return g_PlayerMaxWeight[playerid]; }

stock GetNearestVehicleToPlayer(playerid, Float:max_distance)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    new nearest = INVALID_VEHICLE_ID;
    new Float:nearest_dist = max_distance + 1.0;
    for(new v = 1; v < MAX_VEHICLES; v++)
    {
        if(!GetVehicleModel(v)) continue;
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(v, vx, vy, vz);
        new Float:dist = VectorSize(px - vx, py - vy, pz - vz);
        if(dist < nearest_dist)
        {
            nearest_dist = dist;
            nearest = v;
        }
    }
    return (nearest_dist <= max_distance) ? nearest : INVALID_VEHICLE_ID;
}

stock Inventory_Init(connection = 0)
{
    #pragma unused connection
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `player_inventory` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `player_id` INT NOT NULL, `slot` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL DEFAULT 0, `item_count` INT NOT NULL DEFAULT 0, `item_plate` VARCHAR(32) DEFAULT '', `is_active` TINYINT(1) NOT NULL DEFAULT 0, `active_slot` INT NOT NULL DEFAULT -1, KEY `player_id` (`player_id`), KEY `slot` (`slot`), KEY `active_slot` (`active_slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `player_accessories` (`id` INT AUTO_INCREMENT PRIMARY KEY, `account_id` INT NOT NULL, `active_slot` INT NOT NULL, `accessory_id` INT NOT NULL, `bone` INT NOT NULL, `x` FLOAT NOT NULL DEFAULT 0.0, `y` FLOAT NOT NULL DEFAULT 0.0, `z` FLOAT NOT NULL DEFAULT 0.0, `rx` FLOAT NOT NULL DEFAULT 0.0, `ry` FLOAT NOT NULL DEFAULT 0.0, `rz` FLOAT NOT NULL DEFAULT 0.0, `scale` FLOAT NOT NULL DEFAULT 1.0, UNIQUE KEY `unique_slot` (`account_id`, `active_slot`), KEY `account_id` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `vehicle_trunk_items` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `vehicle_dbid` INT NOT NULL, `slot` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL DEFAULT 0, `item_count` INT NOT NULL DEFAULT 0, `item_plate` VARCHAR(32) DEFAULT '', KEY `vehicle_dbid` (`vehicle_dbid`), UNIQUE KEY `unique_vehicle_slot` (`vehicle_dbid`,`slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `inventory_items` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `item_id` INT NOT NULL, `name` VARCHAR(64) NOT NULL DEFAULT '', `type` INT NOT NULL DEFAULT 0, `weight` INT NOT NULL DEFAULT 0, UNIQUE KEY `uniq_item_id` (`item_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
    mysql_tquery(mysql, "INSERT INTO `inventory_items` (`item_id`,`name`,`type`,`weight`) VALUES (58,'SIM-card',2,1) ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`type`=VALUES(`type`),`weight`=VALUES(`weight`)", "", "");
    return 1;
}

stock Inventory_Reset(playerid)
{
    Trade_ResetInviteData(playerid);
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
    g_PlayerWeight[playerid] = 0.0;
    g_PlayerPhoneNumber[playerid] = 0;
    g_PlayerMedChest[playerid] = 0;
    g_TradeActive[playerid] = false;
    g_TradeReady[playerid] = false;
    g_TradePartner[playerid] = -1;
    g_TradeMoney[playerid] = 0;
    g_TradeItemsCount[playerid] = 0;
    for(new t = 0; t < TRADE_MAX_ITEMS; t++)
    {
        g_TradeItemId[playerid][t] = 0;
        g_TradeItemCount[playerid][t] = 0;
        g_TradeItemSlot[playerid][t] = -1;
        g_TradeItemPlate[playerid][t][0] = EOS;
    }
    g_TrunkVehicleDB[playerid] = 0;
    g_TrunkWeight[playerid] = 0.0;
    g_TrunkNotifyZone[playerid] = false;
    for(new tr = 0; tr < MAX_TRUNK_SLOTS; tr++)
    {
        g_TrunkItems[playerid][tr][inv_itemId] = 0;
        g_TrunkItems[playerid][tr][inv_itemCount] = 0;
        g_TrunkItems[playerid][tr][inv_itemSlot] = tr;
        g_TrunkItems[playerid][tr][inv_itemPlate][0] = EOS;
        g_TrunkItems[playerid][tr][inv_itemType] = 0;
        g_TrunkItems[playerid][tr][inv_itemWeight] = 0;
        g_TrunkItems[playerid][tr][inv_itemActive] = false;
        g_TrunkItems[playerid][tr][inv_activeSlot] = -1;
    }
    return 1;
}

stock Inventory_GetFreeSlot(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) if(g_PlayerInventory[playerid][i][inv_itemId] == 0) return i;
    return -1;
}

stock Inventory_DeleteSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    new itemId = g_PlayerInventory[playerid][slot][inv_itemId];
    new cnt = g_PlayerInventory[playerid][slot][inv_itemCount];
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, cnt));
    g_PlayerInventory[playerid][slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemName][0] = 0;
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
    if(itemType == ITEM_TYPE_SIM || itemType == ITEM_TYPE_SKIN || itemType == ITEM_TYPE_PLATE || itemType == ITEM_TYPE_ACCESSORY) return Inventory_DeleteSlot(playerid, slot);
    g_PlayerInventory[playerid][slot][inv_itemCount]--;
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - GetItemWeight(itemId));
    if(g_PlayerInventory[playerid][slot][inv_itemCount] <= 0) Inventory_DeleteSlot(playerid, slot);
    return 1;
}

stock Inventory_SetItem(playerid, slot, itemId, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    g_PlayerInventory[playerid][slot][inv_itemId] = itemId;
    g_PlayerInventory[playerid][slot][inv_itemCount] = count;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    format(g_PlayerInventory[playerid][slot][inv_itemPlate], 32, "%s", plate);
    GetItemName(itemId, g_PlayerInventory[playerid][slot][inv_itemName], 64);
    g_PlayerInventory[playerid][slot][inv_itemType] = GetItemType(itemId);
    g_PlayerInventory[playerid][slot][inv_itemWeight] = floatround(GetItemWeight(itemId));
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    g_PlayerInventory[playerid][slot][inv_activeSlot] = -1;
    return 1;
}

stock Inventory_SetActiveItem(playerid, activeSlot, itemId, count, const plate[] = "")
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = itemId;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = count;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemSlot] = activeSlot;
    format(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], 32, "%s", plate);
    GetItemName(itemId, g_PlayerActiveSlots[playerid][activeSlot][inv_itemName], 64);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = GetItemType(itemId);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = floatround(GetItemWeight(itemId));
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = activeSlot;
    return 1;
}

stock Inventory_ClearActiveSlot(playerid, activeSlot)
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate][0] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemName][0] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = false;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = -1;
    return 1;
}

stock Inventory_AddItemToSlot(playerid, slot, itemId, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] > 0) return 0;
    new Float:weightAdd = GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count);
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return 0;
    Inventory_SetItem(playerid, slot, itemId, count, plate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weightAdd);
    return 1;
}

stock Inventory_SetPlayerSIM(playerid, number, bool:save = true)
{
    if(number < 0) number = 0;

    g_PlayerPhoneNumber[playerid] = number;
    SetPlayerData(playerid, P_PHONE, number);

    if(save && GetPlayerAccountID(playerid) > 0)
    {
        new query[128];
        mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `phone` = %d WHERE `id` = %d LIMIT 1", number, GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");
    }
    return 1;
}

stock bool:Inventory_AddSIMCard(playerid, simNumber)
{
    if(simNumber < 1000 || simNumber > 999999999) return false;

    new Float:weightAdd = GetItemWeight(INVENTORY_ITEM_SIM);
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return false;

    new slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return false;

    new plate[16];
    format(plate, sizeof(plate), "%d", simNumber);

    Inventory_SetItem(playerid, slot, INVENTORY_ITEM_SIM, 1, plate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weightAdd);
    return true;
}

stock bool:Inventory_AddItem(playerid, itemId, slot_or_count, count = -1, const plate[] = "")
{
    new forcedSlot = -1;
    if(count == -1)
    {
        count = slot_or_count;
    }
    else
    {
        forcedSlot = slot_or_count;
    }

    if(itemId <= 0 || count <= 0) return false;
    if(forcedSlot >= 0 && forcedSlot < MAX_INVENTORY_SLOTS)
    {
        return Inventory_AddItemToSlot(playerid, forcedSlot, itemId, count, plate);
    }
    if(Inventory_IsSIMItem(itemId)) itemId = INVENTORY_ITEM_SIM;

    new itemType = GetItemType(itemId);

    if(itemType == ITEM_TYPE_ACCESSORY)
    {
        new accessoryId = Accessory_GetAccIdByInvItem(itemId);
        if(accessoryId >= 0)
        {
            for(new i = 0; i < count; i++)
            {
                if(!Inventory_AddAccessoryItem(playerid, accessoryId, itemId)) return false;
            }
            return true;
        }
    }

    new Float:weightAdd = GetItemWeight(itemId) * count;
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return false;

    if(itemType == ITEM_TYPE_SIM || itemType == ITEM_TYPE_SKIN || itemType == ITEM_TYPE_PLATE || itemType == ITEM_TYPE_ACCESSORY)
    {
        for(new i = 0; i < count; i++)
        {
            new slot = Inventory_GetFreeSlot(playerid);
            if(slot == -1) return false;
            new plateStr[12];
            if(itemType == ITEM_TYPE_SIM)
            {
                new simNumber = (g_PlayerPhoneNumber[playerid] > 0) ? g_PlayerPhoneNumber[playerid] : (100000 + random(900000));
                valstr(plateStr, simNumber);
            }
            else plateStr[0] = 0;
            if(!Inventory_AddItemToSlot(playerid, slot, itemId, 1, plateStr)) return false;
        }
        return true;
    }
    for(new s = 0; s < MAX_INVENTORY_SLOTS; s++)
        if(g_PlayerInventory[playerid][s][inv_itemId] == itemId)
        {
            g_PlayerInventory[playerid][s][inv_itemCount] += count;
            SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weightAdd);
            return true;
        }
    new slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return false;
    return Inventory_AddItemToSlot(playerid, slot, itemId, count, "");
}

stock bool:Inventory_AddSkinItem(playerid, skinModel)
{
    if(skinModel < 0 || skinModel > 30000) return false;
    new Float:weightAdd = GetItemWeight(134);
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return false;
    new slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return false;
    new plateStr[12];
    valstr(plateStr, skinModel);
    Inventory_SetItem(playerid, slot, 134, skinModel, plateStr);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weightAdd);
    return true;
}

stock Inventory_EnsureCurrentSkin(playerid)
{
    new skin = GetPlayerData(playerid, P_SKIN);
    if(skin <= 0) skin = GetPlayerSkin(playerid);
    if(skin <= 0 || skin > 30000) skin = 1;

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemId] != 134)
    {
        Inventory_SetActiveItem(playerid, SLOT_SKIN, 134, skin, "");
        SetPlayerSkin(playerid, skin);
        SetPlayerData(playerid, P_SKIN, skin);
        return 1;
    }

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] <= 0 || g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] > 30000)
    {
        g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] = skin;
    }

    SetPlayerSkin(playerid, g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount]);
    SetPlayerData(playerid, P_SKIN, g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount]);
    return 1;
}

stock Inventory_EquipItem(playerid, itemId, invSlot, &activeSlot)
{
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] != itemId) return 0;
    new itemType = GetItemType(itemId);
    new targetSlot = -1;
    switch(itemType)
    {
        case ITEM_TYPE_SIM: targetSlot = SLOT_SIM;
        case ITEM_TYPE_SKIN: targetSlot = SLOT_SKIN;
        case ITEM_TYPE_ACCESSORY:
            for(new s = SLOT_ACCESSORY_START; s <= SLOT_ACCESSORY_END; s++) 
                if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0) { targetSlot = s; break; }
        default: return 0;
    }
    if(targetSlot == -1 || targetSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(g_PlayerActiveSlots[playerid][targetSlot][inv_itemId] > 0)
    {
        new freeSlot = Inventory_GetFreeSlot(playerid);
        if(freeSlot == -1)
        {
            Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
            return 0;
        }
        Inventory_MoveFromSlotToInv(playerid, g_PlayerActiveSlots[playerid][targetSlot][inv_itemId], targetSlot, freeSlot);
    }
    new equipItemId = g_PlayerInventory[playerid][invSlot][inv_itemId];
    new equipCount = g_PlayerInventory[playerid][invSlot][inv_itemCount];
    new equipPlate[32];
    format(equipPlate, sizeof(equipPlate), "%s", g_PlayerInventory[playerid][invSlot][inv_itemPlate]);

    Inventory_SetActiveItem(playerid, targetSlot, equipItemId, equipCount, equipPlate);
    Inventory_DeleteSlot(playerid, invSlot);
    if(Inventory_IsSIMItem(itemId))
    {
        new phone = strval(g_PlayerActiveSlots[playerid][targetSlot][inv_itemPlate]);
        if(phone <= 0) phone = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        Inventory_SetPlayerSIM(playerid, phone);
        Inv_ShowNotification(playerid, 1, 5, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ SIM-пїЅпїЅпїЅпїЅпїЅ", "");
    }
    else if(itemId == 134)
    {
        new skinId = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        SetPlayerSkin(playerid, skinId);
        SetPlayerData(playerid, P_SKIN, skinId);
        new query[128];
        mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `skin` = %d WHERE `id` = %d LIMIT 1", skinId, GetPlayerAccountID(playerid));
        mysql_query(mysql, query);
        Inv_ShowNotification(playerid, 1, 5, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", "");
    }
    activeSlot = targetSlot;
    return 1;
}

stock Inventory_MoveFromSlotToInv(playerid, itemId, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][newSlot][inv_itemId] > 0) return 0;

    new storedItemId = g_PlayerActiveSlots[playerid][oldSlot][inv_itemId];
    if(storedItemId <= 0) return 0;

    if(storedItemId != itemId)
    {
        if(!(Inventory_IsAccessoryItem(storedItemId) && (itemId <= 0 || Inventory_IsAccessoryItem(itemId)))) return 0;
        itemId = storedItemId;
    }

    if(itemId == 134 && oldSlot == SLOT_SKIN) return 0;

    new moveCount = g_PlayerActiveSlots[playerid][oldSlot][inv_itemCount];
    new movePlate[32];
    format(movePlate, sizeof(movePlate), "%s", g_PlayerActiveSlots[playerid][oldSlot][inv_itemPlate]);

    Inventory_SetItem(playerid, newSlot, storedItemId, moveCount, movePlate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(storedItemId) * Inventory_GetWeightAmount(storedItemId, moveCount));

    if(Inventory_IsAccessoryItem(storedItemId))
    {
        Accessory_OnUnequipped(playerid, oldSlot);
        Accessory_DeleteSlotFromDB(playerid, oldSlot);
    }

    if(Inventory_IsSIMItem(storedItemId) && oldSlot == SLOT_SIM)
    {
        Inventory_SetPlayerSIM(playerid, 0);
        Inv_ShowNotification(playerid, 1, 5, 0, 0, "SIM-card removed", "");
    }

    Inventory_ClearActiveSlot(playerid, oldSlot);
    return 1;
}

stock Inventory_MoveItem(playerid, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(oldSlot == newSlot) return 1;
    new tmp[E_INVENTORY_ITEM];
    tmp = g_PlayerInventory[playerid][oldSlot];
    g_PlayerInventory[playerid][oldSlot] = g_PlayerInventory[playerid][newSlot];
    g_PlayerInventory[playerid][newSlot] = tmp;
    g_PlayerInventory[playerid][oldSlot][inv_itemSlot] = oldSlot;
    g_PlayerInventory[playerid][newSlot][inv_itemSlot] = newSlot;
    return 1;
}

stock Inventory_DeleteFromActiveSlot(playerid, itemId, activeSlot)
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;

    new storedItemId = g_PlayerActiveSlots[playerid][activeSlot][inv_itemId];
    if(storedItemId <= 0) return 0;

    if(storedItemId != itemId)
    {
        if(!(Inventory_IsAccessoryItem(storedItemId) && (itemId <= 0 || Inventory_IsAccessoryItem(itemId)))) return 0;
        itemId = storedItemId;
    }

    if(itemId == 134 && activeSlot == SLOT_SKIN) return 0;

    if(Inventory_IsAccessoryItem(storedItemId))
    {
        Accessory_OnUnequipped(playerid, activeSlot);
        Accessory_DeleteSlotFromDB(playerid, activeSlot);
    }

    if(Inventory_IsSIMItem(storedItemId) && activeSlot == SLOT_SIM)
    {
        Inventory_SetPlayerSIM(playerid, 0);
        Inv_ShowNotification(playerid, 1, 5, 0, 0, "SIM-card deleted", "");
    }

    Inventory_ClearActiveSlot(playerid, activeSlot);
    return 1;
}

stock Inventory_UseMedChest(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;
    new Float:hp; GetPlayerHealth(playerid, hp);
    hp += 60.0; if(hp > 100.0) hp = 100.0; SetPlayerHealth(playerid, hp);
    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 22) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    else { usedSlot = Inventory_FindItemSlot(playerid, 22); if(usedSlot != -1) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0); }
    if(!removed) return false;
    Inv_ShowNotification(playerid, 3, 6, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
    ApplyAnimation(playerid, "PED", "gum_eat", 3.0, 0, 0, 0, 0, 0, 1);
    g_PlayerMedChest[playerid] = 0;
    return true;
}

stock Inventory_UseRepairKit(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;
    new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0);
    if(vehicleid == INVALID_VEHICLE_ID) { Inv_ShowNotification(playerid, 2, 6, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", ""); return false; }
    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 23) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    else { usedSlot = Inventory_FindItemSlot(playerid, 23); if(usedSlot != -1) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0); }
    if(!removed) return false;
    SetVehicleHealth(vehicleid, 1000.0);
    RepairVehicle(vehicleid);
    Inv_ShowNotification(playerid, 3, 6, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
    return true;
}

stock bool:Inventory_UseSkinFromSlot(playerid, slot, &newSkinModel)
{
    newSkinModel = 0;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    if(g_PlayerInventory[playerid][slot][inv_itemId] != 134) return false;

    new targetSkin = g_PlayerInventory[playerid][slot][inv_itemCount];
    if(targetSkin <= 0 || targetSkin > 30000) return false;

    new oldSkin = GetPlayerData(playerid, P_SKIN);
    if(oldSkin <= 0) oldSkin = GetPlayerSkin(playerid);

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemId] == 134)
    {
        new freeSlot = Inventory_GetFreeSlot(playerid);
        if(freeSlot == -1) return false;
        new oldActiveSkin = g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount];
        if(oldActiveSkin <= 0 || oldActiveSkin > 30000) oldActiveSkin = oldSkin;
        Inventory_SetItem(playerid, freeSlot, 134, oldActiveSkin, "");
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(134));
        Inventory_ClearActiveSlot(playerid, SLOT_SKIN);
    }

    if(!Inventory_DeleteSlot(playerid, slot)) return false;

    Inventory_SetActiveItem(playerid, SLOT_SKIN, 134, targetSkin, "");
    SetPlayerSkin(playerid, targetSkin);
    SetPlayerData(playerid, P_SKIN, targetSkin);
    newSkinModel = targetSkin;

    new query[128];
    mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `skin` = %d WHERE `id` = %d LIMIT 1", targetSkin, GetPlayerAccountID(playerid));
    mysql_query(mysql, query);

    Inv_ShowNotification(playerid, 1, 5, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
    return true;
}

stock bool:Inventory_UseSIMFromSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS || !Inventory_IsSIMItem(g_PlayerInventory[playerid][slot][inv_itemId])) return false;
    new usedCount = g_PlayerInventory[playerid][slot][inv_itemCount];
    new usedPlate[32]; format(usedPlate, 32, "%s", g_PlayerInventory[playerid][slot][inv_itemPlate]);
    new oldActiveCount = 0, oldActivePlate[32];
    if(Inventory_IsSIMItem(g_PlayerActiveSlots[playerid][SLOT_SIM][inv_itemId]))
    {
        oldActiveCount = g_PlayerActiveSlots[playerid][SLOT_SIM][inv_itemCount];
        format(oldActivePlate, 32, "%s", g_PlayerActiveSlots[playerid][SLOT_SIM][inv_itemPlate]);
        Inventory_ClearActiveSlot(playerid, SLOT_SIM);
    }
    if(!Inventory_DeleteSlot(playerid, slot)) return false;
    if(oldActiveCount > 0)
    {
        new freeSlot = Inventory_GetFreeSlot(playerid);
        if(freeSlot != -1)
        {
            Inventory_SetItem(playerid, freeSlot, INVENTORY_ITEM_SIM, 1, oldActivePlate);
            SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(INVENTORY_ITEM_SIM));
        }
        else Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ SIM-пїЅпїЅпїЅпїЅпїЅ", "");
    }
    Inventory_SetActiveItem(playerid, SLOT_SIM, INVENTORY_ITEM_SIM, 1, usedPlate);
    new phone = strval(usedPlate); if(phone <= 0) phone = usedCount;
    Inventory_SetPlayerSIM(playerid, phone);
    Inv_ShowNotification(playerid, 1, 5, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ SIM-пїЅпїЅпїЅпїЅпїЅ", "");
    return true;
}

stock Inventory_FindItemSlot(playerid, itemId)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) if(g_PlayerInventory[playerid][i][inv_itemId] == itemId) return i;
    return -1;
}

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
        new activeSlot = cache_get_field_content_int(i, "active_slot");
        new plate[32];
        cache_get_field_content(i, "item_plate", plate, 32);

        if(itemId == INVENTORY_ITEM_SIM_BAD_V14)
        {
            new oldSimNumber = strval(plate);
            if(oldSimNumber >= 1000 && oldSimNumber <= 999999999)
            {
                itemId = INVENTORY_ITEM_SIM;
                count = 1;
            }
        }

        if(Inventory_IsSIMItem(itemId))
        {
            if(plate[0] == EOS && count > 1) valstr(plate, count);
            itemId = INVENTORY_ITEM_SIM;
            count = 1;
        }

        if(isActive)
        {
            new fixedActiveSlot = Inventory_GetCorrectActiveSlot(playerid, itemId, activeSlot);

            if(fixedActiveSlot >= 0 && fixedActiveSlot < MAX_ACTIVE_SLOTS)
            {
                Inventory_SetActiveItem(playerid, fixedActiveSlot, itemId, count, plate);

                if(itemId == 134 && fixedActiveSlot == SLOT_SKIN)
                {
                    SetPlayerSkin(playerid, count);
                    SetPlayerData(playerid, P_SKIN, count);
                }

                if(Inventory_IsSIMItem(itemId) && fixedActiveSlot == SLOT_SIM)
                {
                    new phone = strval(plate);
                    if(phone <= 0) phone = count;
                    Inventory_SetPlayerSIM(playerid, phone, false);
                }
            }
            else
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot != -1)
                {
                    Inventory_SetItem(playerid, freeSlot, itemId, count, plate);
                    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count));
                }
            }
        }
        else
        {
            if(slot >= 0 && slot < MAX_INVENTORY_SLOTS)
            {
                Inventory_SetItem(playerid, slot, itemId, count, plate);
                SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count));
            }
        }
    }
    g_PlayerMedChest[playerid] = (Inventory_FindItemSlot(playerid, 22) != -1);
    Inventory_EnsureCurrentSkin(playerid);
    Accessory_OnInventoryLoaded(playerid);
    Inventory_Save(playerid);
    return 1;
}

stock Inventory_Load(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    new q[256];
    mysql_format(mysql, q, sizeof(q), "SELECT `slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot` FROM `player_inventory` WHERE `player_id` = %d", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, q, "OnInventoryLoad", "d", playerid);
    Accessory_LoadAllFromDB(playerid);
    return 1;
}

stock Inventory_Save(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    new q[256];
    mysql_format(mysql, q, sizeof(q), "DELETE FROM `player_inventory` WHERE `player_id` = %d", GetPlayerAccountID(playerid));
    mysql_query(mysql, q);
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            mysql_format(mysql, q, sizeof(q), "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,%d,%d,'%e',0,-1)", GetPlayerAccountID(playerid), i, g_PlayerInventory[playerid][i][inv_itemId], g_PlayerInventory[playerid][i][inv_itemCount], g_PlayerInventory[playerid][i][inv_itemPlate]);
            mysql_query(mysql, q);
        }
    }
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            mysql_format(mysql, q, sizeof(q), "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,%d,%d,'%e',1,%d)", GetPlayerAccountID(playerid), i, g_PlayerActiveSlots[playerid][i][inv_itemId], g_PlayerActiveSlots[playerid][i][inv_itemCount], g_PlayerActiveSlots[playerid][i][inv_itemPlate], i);
            mysql_query(mysql, q);
        }
    }
    Accessory_SaveAllSlots(playerid);
    return 1;
}

stock ShowPlayerInventory(playerid)
{
    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = JSON_Array();
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) if(g_PlayerInventory[playerid][i][inv_itemId] > 0) itemsArray = JSON_Append(itemsArray, JSON_Array(JSON_Int(g_PlayerInventory[playerid][i][inv_itemId]), JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]), JSON_Int(i), JSON_Int(0)));
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new guiActiveSlot = Inventory_ToGuiActiveSlot(i, g_PlayerActiveSlots[playerid][i][inv_itemId]);
            activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Array(JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemId]), JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemCount]), JSON_Int(guiActiveSlot), JSON_Int(0)));
        }
    }
    new Node:json = JSON_Object("o", JSON_Int(1), "i", JSON_Int(0), "n", JSON_String(GetPlayerNameEx(playerid)), "lv", JSON_Int(GetPlayerLevel(playerid)), "id", JSON_Int(playerid), "v", JSON_Int(3), "ps", JSON_Int(GetPlayerData(playerid, P_SKIN)), "m", JSON_Int(GetPlayerMoneyEx(playerid)), "s", JSON_Int(79), "w", JSON_Float(GetPlayerWeight(playerid)), "mw", JSON_Float(GetPlayerMaxWeight(playerid)), "sl", JSON_Int(MAX_INVENTORY_SLOTS), "nm", JSON_Int(g_PlayerPhoneNumber[playerid]), "en", JSON_String(""), "it", itemsArray, "ai", activeSlotsArray, "wi", JSON_Array());
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}


stock Trade_Reset(playerid)
{
    g_TradeActive[playerid] = false;
    g_TradeReady[playerid] = false;
    g_TradePartner[playerid] = -1;
    g_TradeMoney[playerid] = 0;
    g_TradeItemsCount[playerid] = 0;
    for(new i = 0; i < TRADE_MAX_ITEMS; i++)
    {
        g_TradeItemId[playerid][i] = 0;
        g_TradeItemCount[playerid][i] = 0;
        g_TradeItemSlot[playerid][i] = -1;
        g_TradeItemPlate[playerid][i][0] = EOS;
    }
    return 1;
}

stock Trade_GetItemName(itemId, name[], size)
{
    switch(GetItemType(itemId))
    {
        case ITEM_TYPE_SKIN: format(name, size, "пїЅпїЅпїЅпїЅ");
        case ITEM_TYPE_SIM: format(name, size, "SIM-пїЅпїЅпїЅпїЅпїЅ");
        case ITEM_TYPE_ACCESSORY: format(name, size, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
        case ITEM_TYPE_PLATE: format(name, size, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ");
        case ITEM_TYPE_FOOD: format(name, size, "пїЅпїЅпїЅ");
        case ITEM_TYPE_MEDICAL: format(name, size, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
        default: format(name, size, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅ %d", itemId);
    }
    return 1;
}

stock Trade_SendSimple(playerid, type, status = 1)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", type);
    JSON_SetInt(json, "s", status);
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_SendOpen(playerid, targetid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 17);
    JSON_SetString(json, "en", GetPlayerNameEx(targetid), strlen(GetPlayerNameEx(targetid)));
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_SendClose(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 16);
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_SendOtherMoney(playerid, money)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 3);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "gm", money);
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_SendOtherAdd(playerid, itemId, count)
{
    new name[64];
    Trade_GetItemName(itemId, name, sizeof(name));
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "ga", itemId);
    JSON_SetInt(json, "s", count);
    JSON_SetString(json, "nt", name, strlen(name));
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_SendOtherRemove(playerid, itemId, count)
{
    new name[64];
    Trade_GetItemName(itemId, name, sizeof(name));
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "ga", itemId);
    JSON_SetInt(json, "s", count);
    JSON_SetString(json, "nt", name, strlen(name));
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_UpdatePair(playerid)
{
    if(!g_TradeActive[playerid]) return 1;

    new targetid = g_TradePartner[playerid];
    if(!IsPlayerConnected(targetid) || !g_TradeActive[targetid]) return 1;

    ShowPlayerInventoryTrade(playerid, targetid);
    ShowPlayerInventoryTrade(targetid, playerid);
    Trade_SendOtherMoney(playerid, g_TradeMoney[targetid]);
    Trade_SendOtherMoney(targetid, g_TradeMoney[playerid]);

    for(new i = 0; i < g_TradeItemsCount[targetid]; i++)
    {
        if(g_TradeItemId[targetid][i] > 0)
        {
            Trade_SendOtherAdd(playerid, g_TradeItemId[targetid][i], g_TradeItemCount[targetid][i]);
        }
    }

    for(new i = 0; i < g_TradeItemsCount[playerid]; i++)
    {
        if(g_TradeItemId[playerid][i] > 0)
        {
            Trade_SendOtherAdd(targetid, g_TradeItemId[playerid][i], g_TradeItemCount[playerid][i]);
        }
    }

    Trade_SendSimple(playerid, g_TradeReady[playerid] ? 8 : 7, 1);
    Trade_SendSimple(targetid, g_TradeReady[targetid] ? 8 : 7, 1);
    return 1;
}

stock ShowPlayerInventoryTrade(playerid, targetid)
{
    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = JSON_Array();

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            itemsArray = JSON_Append(itemsArray, JSON_Array(JSON_Int(g_PlayerInventory[playerid][i][inv_itemId]), JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]), JSON_Int(i), JSON_Int(0)));
        }
    }

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new guiActiveSlot = Inventory_ToGuiActiveSlot(i, g_PlayerActiveSlots[playerid][i][inv_itemId]);
            activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Array(JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemId]), JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemCount]), JSON_Int(guiActiveSlot), JSON_Int(0)));
        }
    }

    new Node:json = JSON_Object("o", JSON_Int(1), "i", JSON_Int(1), "n", JSON_String(GetPlayerNameEx(playerid)), "lv", JSON_Int(GetPlayerLevel(playerid)), "id", JSON_Int(playerid), "v", JSON_Int(3), "ps", JSON_Int(GetPlayerData(playerid, P_SKIN)), "m", JSON_Int(GetPlayerMoneyEx(playerid)), "s", JSON_Int(79), "w", JSON_Float(GetPlayerWeight(playerid)), "mw", JSON_Float(GetPlayerMaxWeight(playerid)), "sl", JSON_Int(MAX_INVENTORY_SLOTS), "nm", JSON_Int(g_PlayerPhoneNumber[playerid]), "en", JSON_String(GetPlayerNameEx(targetid)), "it", itemsArray, "ai", activeSlotsArray, "wi", JSON_Array());
    SendPacketToClient(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trade_Start(playerid, targetid)
{
    if(playerid == targetid) return 0;
    if(!IsPlayerConnected(targetid)) return 0;
    if(g_TradeActive[playerid] || g_TradeActive[targetid]) return 0;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(targetid, 10.0, x, y, z)) return 0;

    Trade_Reset(playerid);
    Trade_Reset(targetid);

    g_TradeActive[playerid] = true;
    g_TradeActive[targetid] = true;
    g_TradePartner[playerid] = targetid;
    g_TradePartner[targetid] = playerid;

    ShowPlayerInventoryTrade(playerid, targetid);
    ShowPlayerInventoryTrade(targetid, playerid);

    Trade_SendOpen(playerid, targetid);
    Trade_SendOpen(targetid, playerid);
    Trade_SendSimple(playerid, 7, 1);
    Trade_SendSimple(targetid, 7, 1);
    return 1;
}

stock Trade_RestoreItem(playerid, itemId, count, const plate[], oldSlot)
{
    if(count <= 0) return 0;

    new slot = -1;
    if(oldSlot >= 0 && oldSlot < MAX_INVENTORY_SLOTS)
    {
        if(g_PlayerInventory[playerid][oldSlot][inv_itemId] == 0) slot = oldSlot;
        else if(g_PlayerInventory[playerid][oldSlot][inv_itemId] == itemId && strcmp(g_PlayerInventory[playerid][oldSlot][inv_itemPlate], plate, true) == 0) slot = oldSlot;
    }

    if(slot == -1) slot = Inventory_GetFreeSlot(playerid);
    if(slot == -1) return 0;

    if(g_PlayerInventory[playerid][slot][inv_itemId] == itemId && strcmp(g_PlayerInventory[playerid][slot][inv_itemPlate], plate, true) == 0)
    {
        if(Inventory_IsSingleSlotItem(itemId)) return 0;
        g_PlayerInventory[playerid][slot][inv_itemCount] += count;
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count));
        return 1;
    }

    Inventory_SetItem(playerid, slot, itemId, count, plate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count));
    return 1;
}

stock Trade_Cancel(playerid, bool:closeGui = true)
{
    if(!g_TradeActive[playerid]) return 1;

    new targetid = g_TradePartner[playerid];

    for(new i = 0; i < g_TradeItemsCount[playerid]; i++)
    {
        if(g_TradeItemId[playerid][i] > 0)
        {
            Trade_RestoreItem(playerid, g_TradeItemId[playerid][i], g_TradeItemCount[playerid][i], g_TradeItemPlate[playerid][i], g_TradeItemSlot[playerid][i]);
        }
    }

    if(IsPlayerConnected(targetid))
    {
        for(new i = 0; i < g_TradeItemsCount[targetid]; i++)
        {
            if(g_TradeItemId[targetid][i] > 0)
            {
                Trade_RestoreItem(targetid, g_TradeItemId[targetid][i], g_TradeItemCount[targetid][i], g_TradeItemPlate[targetid][i], g_TradeItemSlot[targetid][i]);
            }
        }
        Inventory_Save(targetid);
        if(closeGui) Trade_SendClose(targetid);
        Trade_Reset(targetid);
    }

    Inventory_Save(playerid);
    if(closeGui) Trade_SendClose(playerid);
    Trade_Reset(playerid);
    return 1;
}

stock Trade_AddFromInventory(playerid, itemId, slot, count)
{
    if(!g_TradeActive[playerid]) return 0;
    if(g_TradeReady[playerid]) return 0;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] != itemId) return 0;

    new bool:singleSlotItem = Inventory_IsSingleSlotItem(itemId);
    if(singleSlotItem) count = g_PlayerInventory[playerid][slot][inv_itemCount];
    else
    {
        if(count <= 0) count = 1;
        if(count > g_PlayerInventory[playerid][slot][inv_itemCount]) count = g_PlayerInventory[playerid][slot][inv_itemCount];
    }
    if(count <= 0) return 0;
    if(g_TradeItemsCount[playerid] >= TRADE_MAX_ITEMS) return 0;

    new idx = g_TradeItemsCount[playerid]++;
    g_TradeItemId[playerid][idx] = itemId;
    g_TradeItemCount[playerid][idx] = count;
    g_TradeItemSlot[playerid][idx] = slot;
    format(g_TradeItemPlate[playerid][idx], 32, "%s", g_PlayerInventory[playerid][slot][inv_itemPlate]);

    if(count >= g_PlayerInventory[playerid][slot][inv_itemCount])
    {
        Inventory_DeleteSlot(playerid, slot);
    }
    else
    {
        g_PlayerInventory[playerid][slot][inv_itemCount] -= count;
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) - GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count));
    }

    g_TradeReady[playerid] = false;
    new targetid = g_TradePartner[playerid];
    if(IsPlayerConnected(targetid))
    {
        g_TradeReady[targetid] = false;
        Trade_SendOtherAdd(targetid, itemId, count);
        Trade_SendSimple(targetid, 7, 1);
    }
    Inventory_Save(playerid);
    Trade_UpdatePair(playerid);
    return 1;
}

stock Trade_RemoveFromExchange(playerid, itemId, oldSlot, count)
{
    if(!g_TradeActive[playerid]) return 0;
    if(g_TradeReady[playerid]) return 0;
    if(count <= 0) count = 1;

    new idx = -1;
    for(new i = 0; i < g_TradeItemsCount[playerid]; i++)
    {
        if(g_TradeItemId[playerid][i] == itemId)
        {
            if(oldSlot < 0 || g_TradeItemSlot[playerid][i] == oldSlot)
            {
                idx = i;
                break;
            }
        }
    }
    if(idx == -1) return 0;
    if(count > g_TradeItemCount[playerid][idx]) count = g_TradeItemCount[playerid][idx];

    if(!Trade_RestoreItem(playerid, itemId, count, g_TradeItemPlate[playerid][idx], g_TradeItemSlot[playerid][idx])) return 0;

    g_TradeItemCount[playerid][idx] -= count;
    if(g_TradeItemCount[playerid][idx] <= 0)
    {
        for(new i = idx; i < g_TradeItemsCount[playerid] - 1; i++)
        {
            g_TradeItemId[playerid][i] = g_TradeItemId[playerid][i + 1];
            g_TradeItemCount[playerid][i] = g_TradeItemCount[playerid][i + 1];
            g_TradeItemSlot[playerid][i] = g_TradeItemSlot[playerid][i + 1];
            format(g_TradeItemPlate[playerid][i], 32, "%s", g_TradeItemPlate[playerid][i + 1]);
        }
        g_TradeItemsCount[playerid]--;
    }

    g_TradeReady[playerid] = false;
    new targetid = g_TradePartner[playerid];
    if(IsPlayerConnected(targetid))
    {
        g_TradeReady[targetid] = false;
        Trade_SendOtherRemove(targetid, itemId, count);
        Trade_SendSimple(targetid, 7, 1);
    }
    Inventory_Save(playerid);
    Trade_UpdatePair(playerid);
    return 1;
}

stock Trade_SetMoney(playerid, amount)
{
    if(!g_TradeActive[playerid]) return 0;
    if(amount < 0) amount = 0;
    if(amount > GetPlayerMoneyEx(playerid)) return 0;
    g_TradeMoney[playerid] = amount;
    g_TradeReady[playerid] = false;

    new targetid = g_TradePartner[playerid];
    if(IsPlayerConnected(targetid))
    {
        g_TradeReady[targetid] = false;
        Trade_SendOtherMoney(targetid, amount);
        Trade_SendSimple(targetid, 7, 1);
    }
    Trade_UpdatePair(playerid);
    return 1;
}

stock Trade_Finalize(playerid)
{
    if(!g_TradeActive[playerid]) return 0;

    new targetid = g_TradePartner[playerid];
    if(!IsPlayerConnected(targetid) || !g_TradeActive[targetid] || g_TradePartner[targetid] != playerid)
    {
        Trade_Cancel(playerid);
        return 0;
    }

    if(g_TradeMoney[playerid] > GetPlayerMoneyEx(playerid) || g_TradeMoney[targetid] > GetPlayerMoneyEx(targetid))
    {
        Trade_Cancel(playerid);
        return 0;
    }

    g_TradeReady[playerid] = true;
    Trade_SendSimple(playerid, 8, 1);
    Trade_SendSimple(targetid, 26, 1);
    Trade_UpdatePair(playerid);

    if(!g_TradeReady[targetid]) return 1;

    for(new i = 0; i < g_TradeItemsCount[playerid]; i++)
    {
        if(g_TradeItemId[playerid][i] > 0)
        {
            if(!Trade_RestoreItem(targetid, g_TradeItemId[playerid][i], g_TradeItemCount[playerid][i], g_TradeItemPlate[playerid][i], -1))
            {
                Trade_Cancel(playerid);
                return 0;
            }
        }
    }

    for(new i = 0; i < g_TradeItemsCount[targetid]; i++)
    {
        if(g_TradeItemId[targetid][i] > 0)
        {
            if(!Trade_RestoreItem(playerid, g_TradeItemId[targetid][i], g_TradeItemCount[targetid][i], g_TradeItemPlate[targetid][i], -1))
            {
                Trade_Cancel(playerid);
                return 0;
            }
        }
    }

    if(g_TradeMoney[playerid] > 0)
    {
        GivePlayerMoneyEx(playerid, -g_TradeMoney[playerid]);
        GivePlayerMoneyEx(targetid, g_TradeMoney[playerid]);
    }
    if(g_TradeMoney[targetid] > 0)
    {
        GivePlayerMoneyEx(targetid, -g_TradeMoney[targetid]);
        GivePlayerMoneyEx(playerid, g_TradeMoney[targetid]);
    }

    Inventory_Save(playerid);
    Inventory_Save(targetid);
    ShowPlayerInventory(playerid);
    ShowPlayerInventory(targetid);

    Trade_SendClose(playerid);
    Trade_SendClose(targetid);
    Trade_Reset(playerid);
    Trade_Reset(targetid);
    return 1;
}


stock Trunk_Reset(playerid)
{
    g_TrunkWeight[playerid] = 0.0;
    for(new i = 0; i < MAX_TRUNK_SLOTS; i++)
    {
        g_TrunkItems[playerid][i][inv_itemId] = 0;
        g_TrunkItems[playerid][i][inv_itemCount] = 0;
        g_TrunkItems[playerid][i][inv_itemSlot] = i;
        g_TrunkItems[playerid][i][inv_itemPlate][0] = EOS;
        g_TrunkItems[playerid][i][inv_itemType] = 0;
        g_TrunkItems[playerid][i][inv_itemWeight] = 0;
        g_TrunkItems[playerid][i][inv_itemActive] = false;
        g_TrunkItems[playerid][i][inv_activeSlot] = -1;
    }
    return 1;
}

stock Trunk_GetFreeSlot(playerid)
{
    for(new i = 0; i < MAX_TRUNK_SLOTS; i++)
    {
        if(g_TrunkItems[playerid][i][inv_itemId] == 0) return i;
    }
    return -1;
}

stock Trunk_SetItem(playerid, slot, itemId, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_TRUNK_SLOTS) return 0;
    g_TrunkItems[playerid][slot][inv_itemId] = itemId;
    g_TrunkItems[playerid][slot][inv_itemCount] = count;
    g_TrunkItems[playerid][slot][inv_itemSlot] = slot;
    format(g_TrunkItems[playerid][slot][inv_itemPlate], 32, "%s", plate);
    g_TrunkItems[playerid][slot][inv_itemType] = GetItemType(itemId);
    g_TrunkItems[playerid][slot][inv_itemWeight] = floatround(GetItemWeight(itemId));
    g_TrunkItems[playerid][slot][inv_itemActive] = false;
    g_TrunkItems[playerid][slot][inv_activeSlot] = -1;
    return 1;
}

stock Trunk_ClearSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_TRUNK_SLOTS) return 0;
    if(g_TrunkItems[playerid][slot][inv_itemId] == 0) return 0;
    new itemId = g_TrunkItems[playerid][slot][inv_itemId];
    new count = g_TrunkItems[playerid][slot][inv_itemCount];
    g_TrunkWeight[playerid] -= GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count);
    if(g_TrunkWeight[playerid] < 0.0) g_TrunkWeight[playerid] = 0.0;
    g_TrunkItems[playerid][slot][inv_itemId] = 0;
    g_TrunkItems[playerid][slot][inv_itemCount] = 0;
    g_TrunkItems[playerid][slot][inv_itemPlate][0] = EOS;
    g_TrunkItems[playerid][slot][inv_itemType] = 0;
    g_TrunkItems[playerid][slot][inv_itemWeight] = 0;
    return 1;
}

stock Trunk_GetVehicleRearPoint(vehicleid, &Float:x, &Float:y, &Float:z)
{
    new Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);

    x -= floatsin(-a, degrees) * TRUNK_REAR_OFFSET;
    y -= floatcos(-a, degrees) * TRUNK_REAR_OFFSET;
    return 1;
}

stock Trunk_GetVehicleDBID(playerid)
{
    if(IsPlayerInAnyVehicle(playerid)) return 0;

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new nearest_dbid = 0;
    new Float:nearest_dist = TRUNK_REAR_CHECK_DISTANCE + 1.0;

    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(!IsValidVehicle(vehicleid)) continue;
        if(!GetVehicleModel(vehicleid)) continue;
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) continue;

        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(index < 0 || index >= MAX_OWNABLE_CARS) continue;
        if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid)) continue;

        new Float:x, Float:y, Float:z;
        Trunk_GetVehicleRearPoint(vehicleid, x, y, z);

        new Float:dist = VectorSize(px - x, py - y, pz - z);

        if(dist < nearest_dist)
        {
            nearest_dist = dist;
            nearest_dbid = GetOwnableCarData(index, OC_SQL_ID);
            if(nearest_dbid <= 0) nearest_dbid = index + 1;
        }
    }

    if(nearest_dist > TRUNK_REAR_CHECK_DISTANCE) return 0;
    return nearest_dbid;
}

stock Trunk_Load(playerid, vehicle_dbid)
{
    Trunk_Reset(playerid);
    g_TrunkVehicleDB[playerid] = vehicle_dbid;
    if(vehicle_dbid <= 0) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT `slot`,`item_id`,`item_count`,`item_plate` FROM `vehicle_trunk_items` WHERE `vehicle_dbid` = %d", vehicle_dbid);
    new Cache:result = mysql_query(mysql, query);
    new rows = cache_num_rows();

    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot", mysql);
        if(slot < 0 || slot >= MAX_TRUNK_SLOTS) continue;

        new itemId = cache_get_field_content_int(i, "item_id", mysql);
        new count = cache_get_field_content_int(i, "item_count", mysql);
        new plate[32];
        cache_get_field_content(i, "item_plate", plate, mysql, sizeof(plate));

        if(itemId <= 0 || count <= 0) continue;
        Trunk_SetItem(playerid, slot, itemId, count, plate);
        g_TrunkWeight[playerid] += GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count);
    }

    cache_delete(result);
    return 1;
}

stock Trunk_Save(playerid)
{
    new vehicle_dbid = g_TrunkVehicleDB[playerid];
    if(vehicle_dbid <= 0) return 0;

    new query[512];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM `vehicle_trunk_items` WHERE `vehicle_dbid` = %d", vehicle_dbid);
    mysql_tquery(mysql, query, "", "");

    for(new i = 0; i < MAX_TRUNK_SLOTS; i++)
    {
        if(g_TrunkItems[playerid][i][inv_itemId] <= 0) continue;

        mysql_format(mysql, query, sizeof(query), "INSERT INTO `vehicle_trunk_items` (`vehicle_dbid`,`slot`,`item_id`,`item_count`,`item_plate`) VALUES (%d,%d,%d,%d,'%e')", vehicle_dbid, i, g_TrunkItems[playerid][i][inv_itemId], g_TrunkItems[playerid][i][inv_itemCount], g_TrunkItems[playerid][i][inv_itemPlate]);
        mysql_tquery(mysql, query, "", "");
    }
    return 1;
}

stock ShowPlayerTrunk(playerid)
{
    if(g_TrunkVehicleDB[playerid] <= 0) return 0;

    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = JSON_Array();
    new Node:trunkArray = JSON_Array();

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            itemsArray = JSON_Append(itemsArray, JSON_Array(JSON_Int(g_PlayerInventory[playerid][i][inv_itemId]), JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]), JSON_Int(i), JSON_Int(0)));
        }
    }

    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new guiActiveSlot = Inventory_ToGuiActiveSlot(i, g_PlayerActiveSlots[playerid][i][inv_itemId]);
            activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Array(JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemId]), JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemCount]), JSON_Int(guiActiveSlot), JSON_Int(0)));
        }
    }

    for(new i = 0; i < MAX_TRUNK_SLOTS; i++)
    {
        if(g_TrunkItems[playerid][i][inv_itemId] > 0)
        {
            trunkArray = JSON_Append(trunkArray, JSON_Array(JSON_Int(g_TrunkItems[playerid][i][inv_itemId]), JSON_Int(g_TrunkItems[playerid][i][inv_itemCount]), JSON_Int(i), JSON_Int(0)));
        }
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "tb", 0);
    JSON_SetFloat(json, "w", GetPlayerWeight(playerid));
    JSON_SetFloat(json, "mw", GetPlayerMaxWeight(playerid));
    JSON_SetFloat(json, "bw", g_TrunkWeight[playerid]);
    JSON_SetFloat(json, "cw", g_TrunkMaxWeight[playerid]);
    JSON_SetInt(json, "sl", MAX_INVENTORY_SLOTS);
    JSON_SetInt(json, "sb", MAX_TRUNK_SLOTS);
    JSON_SetInt(json, "nm", MAX_ACTIVE_SLOTS);
    JSON_SetArray(json, "it", itemsArray);
    JSON_SetArray(json, "ic", trunkArray);
    JSON_SetArray(json, "ai", activeSlotsArray);

    SendPacketToClient(playerid, 34, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trunk_Response(playerid, type, status)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", type);
    JSON_SetInt(json, "s", status);
    JSON_SetInt(json, "w", floatround(GetPlayerWeight(playerid)));
    JSON_SetInt(json, "bw", floatround(g_TrunkWeight[playerid]));
    JSON_SetInt(json, "mw", floatround(GetPlayerMaxWeight(playerid)));
    JSON_SetInt(json, "cw", floatround(g_TrunkMaxWeight[playerid]));
    JSON_SetInt(json, "nw", floatround(GetPlayerMaxWeight(playerid)));
    JSON_SetInt(json, "ns", MAX_INVENTORY_SLOTS);
    SendPacketToClient(playerid, 34, json);
    JSON_Cleanup(json);
    return 1;
}

stock Trunk_FindStackSlot(playerid, itemId, const plate[])
{
    if(Inventory_IsSingleSlotItem(itemId)) return -1;

    for(new i = 0; i < MAX_TRUNK_SLOTS; i++)
    {
        if(g_TrunkItems[playerid][i][inv_itemId] != itemId) continue;
        if(strcmp(g_TrunkItems[playerid][i][inv_itemPlate], plate, true) == 0) return i;
    }
    return -1;
}

stock Inventory_FindStackSlot(playerid, itemId, const plate[])
{
    if(Inventory_IsSingleSlotItem(itemId)) return -1;

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] != itemId) continue;
        if(strcmp(g_PlayerInventory[playerid][i][inv_itemPlate], plate, true) == 0) return i;
    }
    return -1;
}

stock Trunk_MoveInvToTrunk(playerid, itemId, invSlot, trunkSlot, count)
{
    if(g_TrunkVehicleDB[playerid] <= 0) return 0;
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] != itemId) return 0;

    new bool:singleSlotItem = Inventory_IsSingleSlotItem(itemId);
    if(singleSlotItem) count = g_PlayerInventory[playerid][invSlot][inv_itemCount];
    else if(count <= 0 || count > g_PlayerInventory[playerid][invSlot][inv_itemCount]) count = g_PlayerInventory[playerid][invSlot][inv_itemCount];

    new plate[32];
    format(plate, sizeof(plate), "%s", g_PlayerInventory[playerid][invSlot][inv_itemPlate]);

    if(trunkSlot < 0 || trunkSlot >= MAX_TRUNK_SLOTS)
    {
        trunkSlot = Trunk_FindStackSlot(playerid, itemId, plate);
        if(trunkSlot == -1) trunkSlot = Trunk_GetFreeSlot(playerid);
    }
    if(trunkSlot == -1) return 0;

    if(g_TrunkItems[playerid][trunkSlot][inv_itemId] != 0)
    {
        if(singleSlotItem) return 0;
        if(g_TrunkItems[playerid][trunkSlot][inv_itemId] != itemId) return 0;
        if(strcmp(g_TrunkItems[playerid][trunkSlot][inv_itemPlate], plate, true) != 0) return 0;
    }

    new Float:addWeight = GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count);
    if(g_TrunkWeight[playerid] + addWeight > g_TrunkMaxWeight[playerid]) return 0;

    if(g_TrunkItems[playerid][trunkSlot][inv_itemId] == 0) Trunk_SetItem(playerid, trunkSlot, itemId, count, plate);
    else g_TrunkItems[playerid][trunkSlot][inv_itemCount] += count;

    g_TrunkWeight[playerid] += addWeight;

    if(singleSlotItem || count >= g_PlayerInventory[playerid][invSlot][inv_itemCount]) Inventory_DeleteSlot(playerid, invSlot);
    else
    {
        g_PlayerInventory[playerid][invSlot][inv_itemCount] -= count;
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) - addWeight);
    }

    Inventory_Save(playerid);
    Trunk_Save(playerid);
    return 1;
}

stock Trunk_MoveTrunkToInv(playerid, itemId, trunkSlot, invSlot, count)
{
    if(g_TrunkVehicleDB[playerid] <= 0) return 0;
    if(trunkSlot < 0 || trunkSlot >= MAX_TRUNK_SLOTS) return 0;
    if(g_TrunkItems[playerid][trunkSlot][inv_itemId] != itemId) return 0;

    new bool:singleSlotItem = Inventory_IsSingleSlotItem(itemId);
    if(singleSlotItem) count = g_TrunkItems[playerid][trunkSlot][inv_itemCount];
    else if(count <= 0 || count > g_TrunkItems[playerid][trunkSlot][inv_itemCount]) count = g_TrunkItems[playerid][trunkSlot][inv_itemCount];

    new plate[32];
    format(plate, sizeof(plate), "%s", g_TrunkItems[playerid][trunkSlot][inv_itemPlate]);

    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS)
    {
        invSlot = Inventory_FindStackSlot(playerid, itemId, plate);
        if(invSlot == -1) invSlot = Inventory_GetFreeSlot(playerid);
    }
    if(invSlot == -1) return 0;

    if(g_PlayerInventory[playerid][invSlot][inv_itemId] != 0)
    {
        if(singleSlotItem) return 0;
        if(g_PlayerInventory[playerid][invSlot][inv_itemId] != itemId) return 0;
        if(strcmp(g_PlayerInventory[playerid][invSlot][inv_itemPlate], plate, true) != 0) return 0;
    }

    new Float:addWeight = GetItemWeight(itemId) * Inventory_GetWeightAmount(itemId, count);
    if(GetPlayerWeight(playerid) + addWeight > GetPlayerMaxWeight(playerid)) return 0;

    if(g_PlayerInventory[playerid][invSlot][inv_itemId] == 0) Inventory_SetItem(playerid, invSlot, itemId, count, plate);
    else g_PlayerInventory[playerid][invSlot][inv_itemCount] += count;

    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + addWeight);

    if(singleSlotItem || count >= g_TrunkItems[playerid][trunkSlot][inv_itemCount]) Trunk_ClearSlot(playerid, trunkSlot);
    else
    {
        g_TrunkItems[playerid][trunkSlot][inv_itemCount] -= count;
        g_TrunkWeight[playerid] -= addWeight;
        if(g_TrunkWeight[playerid] < 0.0) g_TrunkWeight[playerid] = 0.0;
    }

    Inventory_Save(playerid);
    Trunk_Save(playerid);
    return 1;
}

stock Trunk_MoveInventorySlot(playerid, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(oldSlot == newSlot) return 1;
    if(g_PlayerInventory[playerid][oldSlot][inv_itemId] <= 0) return 0;
    if(g_PlayerInventory[playerid][newSlot][inv_itemId] > 0) return 0;

    g_PlayerInventory[playerid][newSlot] = g_PlayerInventory[playerid][oldSlot];
    g_PlayerInventory[playerid][newSlot][inv_itemSlot] = newSlot;

    g_PlayerInventory[playerid][oldSlot][inv_itemId] = 0;
    g_PlayerInventory[playerid][oldSlot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][oldSlot][inv_itemSlot] = oldSlot;
    g_PlayerInventory[playerid][oldSlot][inv_itemPlate][0] = EOS;
    g_PlayerInventory[playerid][oldSlot][inv_itemType] = 0;
    g_PlayerInventory[playerid][oldSlot][inv_itemWeight] = 0;
    g_PlayerInventory[playerid][oldSlot][inv_itemActive] = false;
    g_PlayerInventory[playerid][oldSlot][inv_activeSlot] = -1;

    Inventory_Save(playerid);
    return 1;
}

stock Trunk_MoveTrunkSlot(playerid, oldSlot, newSlot)
{
    if(g_TrunkVehicleDB[playerid] <= 0) return 0;
    if(oldSlot < 0 || oldSlot >= MAX_TRUNK_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_TRUNK_SLOTS) return 0;
    if(oldSlot == newSlot) return 1;
    if(g_TrunkItems[playerid][oldSlot][inv_itemId] <= 0) return 0;
    if(g_TrunkItems[playerid][newSlot][inv_itemId] > 0) return 0;

    g_TrunkItems[playerid][newSlot] = g_TrunkItems[playerid][oldSlot];
    g_TrunkItems[playerid][newSlot][inv_itemSlot] = newSlot;

    g_TrunkItems[playerid][oldSlot][inv_itemId] = 0;
    g_TrunkItems[playerid][oldSlot][inv_itemCount] = 0;
    g_TrunkItems[playerid][oldSlot][inv_itemSlot] = oldSlot;
    g_TrunkItems[playerid][oldSlot][inv_itemPlate][0] = EOS;
    g_TrunkItems[playerid][oldSlot][inv_itemType] = 0;
    g_TrunkItems[playerid][oldSlot][inv_itemWeight] = 0;
    g_TrunkItems[playerid][oldSlot][inv_itemActive] = false;
    g_TrunkItems[playerid][oldSlot][inv_activeSlot] = -1;

    Trunk_Save(playerid);
    return 1;
}


stock bool:Trunk_HandlePacket(playerid, Node:JSONObject)
{
    new type;
    JSON_GetInt(JSONObject, "t", type);

    new itemId = 0, oldPos = -1, newPos = -1, count = 0;
    new ok = 0;

    switch(type)
    {
        case 0:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            if(itemId <= 0) JSON_GetInt(JSONObject, "i", itemId);
            if(itemId <= 0) JSON_GetInt(JSONObject, "id", itemId);

            JSON_GetInt(JSONObject, "os", oldPos);
            if(oldPos == -1) JSON_GetInt(JSONObject, "sl", oldPos);
            if(oldPos == -1) JSON_GetInt(JSONObject, "o", oldPos);

            JSON_GetInt(JSONObject, "ns", newPos);
            if(newPos == -1) JSON_GetInt(JSONObject, "bs", newPos);

            JSON_GetInt(JSONObject, "v", count);
            if(count <= 0) JSON_GetInt(JSONObject, "c", count);

            new sValue = -1;
            JSON_GetInt(JSONObject, "s", sValue);
            if(newPos == -1 && count > 0) newPos = sValue;
            else if(count <= 0) count = sValue;

            ok = Trunk_MoveInvToTrunk(playerid, itemId, oldPos, newPos, count);
            Trunk_Response(playerid, 0, ok ? 1 : 0);
            if(ok) ShowPlayerTrunk(playerid);
            return true;
        }
        case 1:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            if(itemId <= 0) JSON_GetInt(JSONObject, "i", itemId);
            if(itemId <= 0) JSON_GetInt(JSONObject, "id", itemId);

            JSON_GetInt(JSONObject, "os", oldPos);
            if(oldPos == -1) JSON_GetInt(JSONObject, "sl", oldPos);
            if(oldPos == -1) JSON_GetInt(JSONObject, "bs", oldPos);
            if(oldPos == -1) JSON_GetInt(JSONObject, "o", oldPos);

            JSON_GetInt(JSONObject, "ns", newPos);

            JSON_GetInt(JSONObject, "v", count);
            if(count <= 0) JSON_GetInt(JSONObject, "c", count);

            new sValue = -1;
            JSON_GetInt(JSONObject, "s", sValue);
            if(newPos == -1 && count > 0) newPos = sValue;
            else if(count <= 0) count = sValue;

            ok = Trunk_MoveTrunkToInv(playerid, itemId, oldPos, newPos, count);
            Trunk_Response(playerid, 1, ok ? 1 : 0);
            if(ok) ShowPlayerTrunk(playerid);
            return true;
        }
        case 2:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "os", oldPos);
            JSON_GetInt(JSONObject, "s", newPos);
            oldPos = Inventory_ResolveActiveSlotFromGui(playerid, itemId, oldPos);
            ok = Inventory_MoveFromSlotToInv(playerid, itemId, oldPos, newPos);
            if(ok) Inventory_Save(playerid);
            Trunk_Response(playerid, 2, ok ? 1 : 0);
            return true;
        }
        case 9:
        {
            JSON_GetInt(JSONObject, "s", newPos);
            ok = Inventory_MoveFromSlotToInv(playerid, INVENTORY_ITEM_SIM, SLOT_SIM, newPos);
            if(ok) Inventory_Save(playerid);
            Trunk_Response(playerid, 9, ok ? 1 : 0);
            return true;
        }
        case 23:
        {
            JSON_GetInt(JSONObject, "os", oldPos);
            JSON_GetInt(JSONObject, "s", newPos);
            if(newPos == -1) JSON_GetInt(JSONObject, "ns", newPos);
            ok = Trunk_MoveInventorySlot(playerid, oldPos, newPos);
            Trunk_Response(playerid, 23, ok ? 1 : 0);
            if(ok) ShowPlayerTrunk(playerid);
            return true;
        }
        case 24:
        {
            JSON_GetInt(JSONObject, "os", oldPos);
            JSON_GetInt(JSONObject, "s", newPos);
            if(newPos == -1) JSON_GetInt(JSONObject, "ns", newPos);
            ok = Trunk_MoveTrunkSlot(playerid, oldPos, newPos);
            Trunk_Response(playerid, 24, ok ? 1 : 0);
            if(ok) ShowPlayerTrunk(playerid);
            return true;
        }
        case 8:
        {
            Trunk_Save(playerid);
            g_TrunkVehicleDB[playerid] = 0;
            new Node:json = JSON_Object();
            JSON_SetInt(json, "t", 8);
            JSON_SetInt(json, "s", 1);
            SendPacketToClient(playerid, 34, json);
            JSON_Cleanup(json);
            return true;
        }
    }
    return false;
}

stock bool:Inventory_HandlePacket(playerid, Node:JSONObject)
{
    new Node:response = JSON_Object();
    new type;
    JSON_GetInt(JSONObject, "t", type);
    new itemId = 0, pos = -1, oldPos = -1, count = 0;
    new bool:ok = false;

    new mode;
    JSON_GetInt(JSONObject, "mode", mode);

    if(mode == 1)
    {
        new targetid;
        JSON_GetInt(JSONObject, "target_id", targetid);
        
        if(!IsPlayerConnected(targetid))
        {
            Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ", "");
            return true;
        }
        
        if(TradeData[playerid][trade_IsOpen] || TradeData[targetid][trade_IsOpen])
        {
            Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ", "");
            return true;
        }
        
        new Node:requestJson = JSON_Object();
        JSON_SetInt(requestJson, "mode", 2);
        JSON_SetInt(requestJson, "from", playerid);
        JSON_SetString(requestJson, "from_name", GetPlayerNameEx(playerid));
        JSON_SetInt(requestJson, "item_id", GetPVarInt(playerid, "Trade_ItemId"));
        JSON_SetInt(requestJson, "item_count", GetPVarInt(playerid, "Trade_ItemCount"));
        ShowPlayerGUI(targetid, 33, requestJson);
        JSON_Cleanup(requestJson);
        
        SetPVarInt(targetid, "Trade_From", playerid);
        SetPVarInt(targetid, "Trade_ItemSlot", GetPVarInt(playerid, "Trade_ItemSlot"));
        SetPVarInt(targetid, "Trade_ItemId", GetPVarInt(playerid, "Trade_ItemId"));
        SetPVarInt(targetid, "Trade_ItemCount", GetPVarInt(playerid, "Trade_ItemCount"));
        
        Inv_ShowNotification(playerid, 3, 6, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
        return true;
    }

    if(mode == 2)
    {
        new action;
        JSON_GetInt(JSONObject, "action", action);
        
        if(action == 1)
        {
            new from = GetPVarInt(playerid, "Trade_From");
            if(!IsPlayerConnected(from))
            {
                Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ", "");
                return true;
            }
            
            StartTrade(from, playerid, GetPVarInt(playerid, "Trade_ItemSlot"));
        }
        else
        {
            new from = GetPVarInt(playerid, "Trade_From");
            if(IsPlayerConnected(from))
            {
                Inv_ShowNotification(from, 2, 5, 0, 0, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ", "");
            }
        }
        
        DeletePVar(playerid, "Trade_From");
        DeletePVar(playerid, "Trade_ItemSlot");
        DeletePVar(playerid, "Trade_ItemId");
        DeletePVar(playerid, "Trade_ItemCount");
        return true;
    }

    if(mode == 3)
    {
        new action, slot, money;
        JSON_GetInt(JSONObject, "action", action);
        
        switch(action)
        {
            case 1:
            {
                JSON_GetInt(JSONObject, "slot", slot);
                AddToTrade(playerid, slot);
            }
            case 2:
            {
                JSON_GetInt(JSONObject, "slot", slot);
                RemoveFromTrade(playerid, slot);
            }
            case 3:
            {
                JSON_GetInt(JSONObject, "money", money);
                AddMoneyToTrade(playerid, money);
            }
            case 4: ConfirmTrade(playerid);
            case 5: CloseTrade(playerid);
        }
        return true;
    }

    if(type == 2)
    {
        new slot;
        JSON_GetInt(JSONObject, "sl", slot);
        
        if(g_PlayerInventory[playerid][slot][inv_itemId] == 0)
        {
            Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
            return true;
        }
        
        if(TradeData[playerid][trade_IsOpen])
        {
            Inv_ShowNotification(playerid, 2, 5, 0, 0, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
            return true;
        }
        
        SetPVarInt(playerid, "Trade_ItemSlot", slot);
        SetPVarInt(playerid, "Trade_ItemId", g_PlayerInventory[playerid][slot][inv_itemId]);
        SetPVarInt(playerid, "Trade_ItemCount", g_PlayerInventory[playerid][slot][inv_itemCount]);
        
        ShowNearbyPlayersList(playerid);
        
        JSON_SetInt(response, "t", 2);
        JSON_SetInt(response, "s", 1);
        OnPacketIncoming(playerid, 33, response);
        return true;
    }

    switch(type)
    {
        case 0:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "s", count);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "os", pos);
            if(count <= 0) count = 1;

            if(g_TradeActive[playerid])
            {
                ok = Trade_AddFromInventory(playerid, itemId, pos, count) != 0;
            }
            else
            {
                if(pos >= 0 && pos < MAX_INVENTORY_SLOTS) ok = Inventory_AddItemToSlot(playerid, pos, itemId, count, "") != 0;
                else ok = Inventory_AddItem(playerid, itemId, count);
            }

            JSON_SetInt(response, "t", 0);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 4:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "os", oldPos);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            oldPos = Inventory_ResolveActiveSlotFromGui(playerid, itemId, oldPos);
            ok = Inventory_MoveFromSlotToInv(playerid, itemId, oldPos, pos) != 0;
            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
            JSON_SetInt(response, "nw", floatround(GetPlayerMaxWeight(playerid)));
            JSON_SetInt(response, "ns", MAX_ACTIVE_SLOTS);
        }
        case 5:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "s", count);
            JSON_GetInt(JSONObject, "os", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "sl", pos);
            if(g_TradeActive[playerid])
            {
                ok = Trade_AddFromInventory(playerid, itemId, pos, count) != 0;
                JSON_SetInt(response, "t", 5);
                JSON_SetInt(response, "s", ok ? 1 : 0);
                JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
            }
            else
            {
                new activeSlot;
                JSON_GetInt(JSONObject, "sl", pos);
                ok = Inventory_EquipItem(playerid, itemId, pos, activeSlot) != 0;
                JSON_SetInt(response, "t", 5);
                JSON_SetInt(response, "s", ok ? 1 : 0);
                if(ok)
                {
                    JSON_SetInt(response, "i", Inventory_ToGuiActiveSlot(activeSlot, itemId));
                    JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
                }
            }
        }
        case 3, 6:
        {
            new money;
            JSON_GetInt(JSONObject, "em", money);
            if(money == 0) JSON_GetInt(JSONObject, "m", money);
            ok = Trade_SetMoney(playerid, money) != 0;
            JSON_SetInt(response, "t", type);
            JSON_SetInt(response, "s", ok ? 1 : 0);
        }
        case 7:
        {
            JSON_SetInt(response, "t", 7);
            JSON_SetInt(response, "s", g_TradeActive[playerid] ? 1 : 0);
        }
        case 8:
        {
            ok = Trade_Finalize(playerid) != 0;
            JSON_Cleanup(response);
            return true;
        }
        case 9, 16, 34:
        {
            if(g_TradeActive[playerid]) Trade_Cancel(playerid);
            else
            {
                JSON_SetInt(response, "t", 16);
                SendPacketToClient(playerid, 33, response);
            }
            JSON_Cleanup(response);
            return true;
        }
        case 18:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            if(pos >= 0 && pos < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][pos][inv_itemId] == itemId)
            {
                ok = Inventory_RemoveOneItem(playerid, pos) != 0;
            }
            else
            {
                new activePos = Inventory_ResolveActiveSlotFromGui(playerid, itemId, pos);
                if(activePos >= 0 && activePos < MAX_ACTIVE_SLOTS)
                {
                    ok = Inventory_DeleteFromActiveSlot(playerid, itemId, activePos) != 0;
                }
            }
            JSON_SetInt(response, "t", 18);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 19:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            if(itemId == 22)
            {
                new usedSlot;
                ok = Inventory_UseMedChest(playerid, pos, usedSlot);
            }
            else if(itemId == 23)
            {
                new usedSlot;
                ok = Inventory_UseRepairKit(playerid, pos, usedSlot);
            }
            else if(itemId == 134)
            {
                new skinModel;
                ok = Inventory_UseSkinFromSlot(playerid, pos, skinModel);
            }
            else if(Inventory_IsSIMItem(itemId))
            {
                ok = Inventory_UseSIMFromSlot(playerid, pos);
            }
            else if(Inventory_IsAccessoryItem(itemId))
            {
                ok = Accessory_UseFromInventory(playerid, pos);
            }
            else
            {
                ok = Inventory_RemoveOneItem(playerid, pos) != 0;
            }
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 23:
        {
            JSON_GetInt(JSONObject, "os", oldPos);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            ok = Inventory_MoveItem(playerid, oldPos, pos) != 0;
            JSON_SetInt(response, "t", 23);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            if(ok) JSON_SetInt(response, "i", pos);
        }
        case 1, 24:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "s", count);
            JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "os", pos);
            ok = Trade_RemoveFromExchange(playerid, itemId, pos, count) != 0;
            JSON_SetInt(response, "t", type);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 25:
        {
            if(g_TradeActive[playerid]) Trade_Cancel(playerid);
            JSON_Cleanup(response);
            return true;
        }
        case 27:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "os", oldPos);
            JSON_GetInt(JSONObject, "s", pos);
            oldPos = Inventory_ResolveActiveSlotFromGui(playerid, itemId, oldPos);
            if(g_TradeActive[playerid] && oldPos >= 0 && oldPos < MAX_ACTIVE_SLOTS && g_PlayerActiveSlots[playerid][oldPos][inv_itemId] == itemId)
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot != -1)
                {
                    ok = Inventory_MoveFromSlotToInv(playerid, itemId, oldPos, freeSlot) != 0;
                    if(ok) ok = Trade_AddFromInventory(playerid, itemId, freeSlot, 1) != 0;
                }
            }
            else
            {
                ok = Inventory_MoveFromSlotToInv(playerid, itemId, oldPos, pos) != 0;
            }
            JSON_SetInt(response, "t", 27);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            JSON_SetInt(response, "nw", floatround(GetPlayerMaxWeight(playerid)));
            JSON_SetInt(response, "ns", MAX_ACTIVE_SLOTS);
        }
        case 31:
        {
            new text[128];
            JSON_GetString(JSONObject, "tx", text, sizeof(text));
            if(g_TradeActive[playerid] && strlen(text) > 0)
            {
                new targetid = g_TradePartner[playerid];
                if(IsPlayerConnected(targetid))
                {
                   
                }
            }
            JSON_Cleanup(response);
            return true;
        }
        case 32:
        {
            JSON_GetInt(JSONObject, "ga", itemId);
            JSON_GetInt(JSONObject, "s", pos);
            pos = Inventory_ResolveActiveSlotFromGui(playerid, itemId, pos);
            new freeSlot = Inventory_GetFreeSlot(playerid);
            if(freeSlot != -1) ok = Inventory_MoveFromSlotToInv(playerid, itemId, pos, freeSlot) != 0;
            JSON_SetInt(response, "t", 32);
            JSON_SetInt(response, "s", ok ? 1 : 0);
        }
        default:
        {
            JSON_SetInt(response, "t", type);
            JSON_SetInt(response, "s", 0);
        }
    }

    if(ok)
    {
        Inventory_Save(playerid);
        if(type == 19 && !GetPVarInt(playerid, "acs_use")) ShowPlayerInventory(playerid);
    }

    SendPacketToClient(playerid, 33, response);
    JSON_Cleanup(response);
    return true;
}

CMD:inv(playerid) return ShowPlayerInventory(playerid);


stock Trunk_CheckNearOwnVehicle(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new vehicle_dbid = Trunk_GetVehicleDBID(playerid);

    if(vehicle_dbid > 0)
    {
        if(!g_TrunkNotifyZone[playerid])
        {
            g_TrunkNotifyZone[playerid] = true;
            Inv_ShowNotification(playerid, 4, 6, TRUNK_GUI, 0, "Открыть багажник транспорта", ">>");
        }
    }
    else
    {
        g_TrunkNotifyZone[playerid] = false;
    }
    return 1;
}

public Trunk_GlobalTimer()
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        Trunk_CheckNearOwnVehicle(i);
    }
    return 1;
}

CMD:trunk(playerid, params[])
{
    new vehicle_dbid = Trunk_GetVehicleDBID(playerid);
    if(vehicle_dbid <= 0) return 1;
    Trunk_Load(playerid, vehicle_dbid);
    ShowPlayerTrunk(playerid);
    return 1;
}



stock Trade_Notify(playerid, type, text[])
{
    new notify_text[144];
    format(notify_text, sizeof(notify_text), "%s", text);

    if(type == 4)
    {
        Inv_ShowNotification(playerid, 4, 6, TRADE_NOTIFY_ACCEPT, 0, notify_text, ">>");
    }
    else
    {
        Inv_ShowNotification(playerid, 3, 5, 0, 1, notify_text, "");
    }
    return 1;
}

stock Trade_NotifyInvite(playerid, inviterid)
{
    new notify_text[144];
    format(notify_text, sizeof(notify_text), "Игрок %s предложил вам обмен", GetPlayerNameEx(inviterid));
    Inv_ShowNotification(playerid, 4, 6, TRADE_NOTIFY_ACCEPT, 0, notify_text, ">>");
    return 1;
}

stock Trade_ResetInviteData(playerid)
{
    g_TradeNearCount[playerid] = 0;
    g_TradeInviteFrom[playerid] = INVALID_PLAYER_ID;
    g_TradeOfferItemSlot[playerid] = -1;

    for(new i = 0; i < TRADE_MAX_NEAR_PLAYERS; i++)
    {
        g_TradeNearList[playerid][i] = INVALID_PLAYER_ID;
    }
    return 1;
}

stock Trade_IsPlayerNearForExchange(playerid, targetid)
{
    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid)) return 0;
    if(targetid == playerid) return 0;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z)) return 0;
    return 1;
}

stock Trade_ShowNearPlayersDialog(playerid, invSlot)
{
    g_TradeNearCount[playerid] = 0;
    g_TradeOfferItemSlot[playerid] = invSlot;

    new string[1024];
    new line[96];

    string[0] = EOS;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!Trade_IsPlayerNearForExchange(playerid, i)) continue;

        if(g_TradeNearCount[playerid] >= TRADE_MAX_NEAR_PLAYERS) break;

        g_TradeNearList[playerid][g_TradeNearCount[playerid]] = i;

        format(line, sizeof(line), "{DD5757}%d. {FFFFFF}%s[%d]\n", g_TradeNearCount[playerid] + 1, GetPlayerNameEx(i), i);
        strcat(string, line);

        g_TradeNearCount[playerid]++;
    }

    if(g_TradeNearCount[playerid] <= 0)
    {
        Trade_Notify(playerid, 3, "Игроков для обмена рядом не найдено");
        return 1;
    }

    ShowPlayerDialog(playerid, DIALOG_TRADE_NEAR_PLAYERS, DIALOG_STYLE_LIST,
        "{DD5757}Обмен",
        string,
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

stock Trade_SendInvite(playerid, targetid, invSlot = -1)
{
    if(!Trade_IsPlayerNearForExchange(playerid, targetid))
    {
        Trade_Notify(playerid, 3, "Игрок находится дальше 10 метров");
        return 1;
    }

    if(g_TradeActive[playerid] || g_TradeActive[targetid] || g_TradePartner[playerid] != -1 || g_TradePartner[targetid] != -1)
    {
        Trade_Notify(playerid, 3, "Один из игроков уже находится в обмене");
        return 1;
    }

    g_TradeInviteFrom[targetid] = playerid;
    g_TradeOfferItemSlot[playerid] = invSlot;

    Trade_NotifyInvite(targetid, playerid);
    Trade_Notify(playerid, 3, "Вы отправили предложение трейда, ожидайте принятия");

    return 1;
}

stock Trade_AcceptInvite(playerid)
{
    new targetid = g_TradeInviteFrom[playerid];

    if(targetid == INVALID_PLAYER_ID || targetid == -1 || !IsPlayerConnected(targetid))
    {
        Trade_Notify(playerid, 3, "У вас нет активного предложения обмена");
        return 1;
    }

    if(!Trade_IsPlayerNearForExchange(playerid, targetid))
    {
        Trade_Notify(playerid, 3, "Игрок находится дальше 10 метров");
        g_TradeInviteFrom[playerid] = INVALID_PLAYER_ID;
        return 1;
    }

    if(!Trade_Start(playerid, targetid)) return 1;

    Trade_Notify(playerid, 3, "Обмен начался!");
    Trade_Notify(targetid, 3, "Обмен начался!");

    g_TradeInviteFrom[playerid] = INVALID_PLAYER_ID;
    g_TradeInviteFrom[targetid] = INVALID_PLAYER_ID;

    if(g_TradeOfferItemSlot[targetid] >= 0)
    {
        new offerSlot = g_TradeOfferItemSlot[targetid];
        if(offerSlot >= 0 && offerSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[targetid][offerSlot][inv_itemId] > 0)
        {
            Trade_AddFromInventory(targetid, g_PlayerInventory[targetid][offerSlot][inv_itemId], offerSlot, 1);
        }
        g_TradeOfferItemSlot[targetid] = -1;
    }

    return 1;
}

stock Trade_OnPlayerClickExchangeItem(playerid, invSlot)
{
    return Trade_ShowNearPlayersDialog(playerid, invSlot);
}

CMD:accepttrade(playerid, params[])
{
    return Trade_AcceptInvite(playerid);
}

CMD:atrade(playerid, params[])
{
    return Trade_AcceptInvite(playerid);
}

CMD:exchange(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) return 1;
    if(!IsPlayerConnected(targetid)) return 1;
    return Trade_SendInvite(playerid, targetid, -1);
}

CMD:trade(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) return 1;
    if(!IsPlayerConnected(targetid)) return 1;
    return Trade_SendInvite(playerid, targetid, -1);
}


stock InventoryTrade_NotificationClick(playerid, id, sub_id)
{
    if(id == TRADE_NOTIFY_ACCEPT || sub_id == TRADE_NOTIFY_ACCEPT)
    {
        return Trade_AcceptInvite(playerid);
    }
    return 0;
}


stock Trade_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TRADE_NEAR_PLAYERS)
    {
        if(!response) return 1;

        if(listitem < 0 || listitem >= g_TradeNearCount[playerid]) return 1;

        new targetid = g_TradeNearList[playerid][listitem];
        if(!IsPlayerConnected(targetid)) return 1;

        return Trade_SendInvite(playerid, targetid, g_TradeOfferItemSlot[playerid]);
    }
    return 0;
}


CMD:giveitem(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, itemId, count = 1;
    if(sscanf(params, "uiD(1)", targetid, itemId, count))
    {
        SendClientMessage(playerid, -1, "Использование: /giveitem [id] [item_id] [кол-во]");
        SendClientMessage(playerid, -1, "SIM-карта: /giveitem [id] 58 [номер]");
        return 1;
    }

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "Игрок не найден.");
    if(itemId <= 0) return SendClientMessage(playerid, -1, "Неверный item_id.");

    new bool:ok = false;

    if(Inventory_IsSIMItem(itemId))
    {
        if(count < 1000 || count > 999999999) return SendClientMessage(playerid, -1, "Для SIM используй: /giveitem [id] 58 [номер от 1000 до 999999999]");
        ok = Inventory_AddSIMCard(targetid, count);
        if(ok)
        {
            Inventory_Save(targetid);
            ShowPlayerInventory(targetid);
            new msg[144];
            format(msg, sizeof(msg), "Вы выдали SIM-карту с номером %d игроку %s", count, GetPlayerNameEx(targetid));
            SendClientMessage(playerid, -1, msg);
            Inv_ShowNotification(targetid, 1, 5, 0, 0, "Вы получили SIM-карту в инвентарь", "");
        }
        else SendClientMessage(playerid, -1, "Не удалось выдать SIM-карту: нет места или превышен вес.");
        return 1;
    }

    if(count <= 0) return SendClientMessage(playerid, -1, "Количество должно быть больше 0.");

    new accessoryId = Accessory_GetAccIdByInvItem(itemId);
    if(accessoryId >= 0)
    {
        ok = true;
        for(new i = 0; i < count; i++)
        {
            if(!Inventory_AddAccessoryItem(targetid, accessoryId, itemId))
            {
                ok = false;
                break;
            }
        }
    }
    else
    {
        ok = Inventory_AddItem(targetid, itemId, count);
    }
    if(ok)
    {
        Inventory_Save(targetid);
        ShowPlayerInventory(targetid);
        new msg[144];
        format(msg, sizeof(msg), "Вы выдали предмет %d x%d игроку %s", itemId, count, GetPlayerNameEx(targetid));
        SendClientMessage(playerid, -1, msg);
        Inv_ShowNotification(targetid, 1, 5, 0, 0, "Вы получили предмет в инвентарь", "");
    }
    else SendClientMessage(playerid, -1, "Не удалось выдать предмет: нет места или превышен вес.");
    return 1;
}


CMD:addskin(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;
    new targetid, skinId;
    if(sscanf(params, "ui", targetid, skinId)) return SendClientMessage(playerid, -1, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ: /addskin [id] [id пїЅпїЅпїЅпїЅпїЅ]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(skinId < 0 || skinId > 311) return SendClientMessage(playerid, -1, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ID пїЅпїЅпїЅпїЅпїЅ (0-311)");
    if(Inventory_AddSkinItem(targetid, skinId))
    {
        Inventory_Save(targetid);
        ShowPlayerInventory(targetid);
        new msg[128];
        format(msg, sizeof(msg), "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ %d пїЅпїЅпїЅпїЅпїЅпїЅ %s", skinId, GetPlayerNameEx(targetid));
        SendClientMessage(playerid, -1, msg);
        Inv_ShowNotification(targetid, 1, 5, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
    }
    else SendClientMessage(playerid, -1, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ)");
    return 1;
}

CMD:giveacc(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, accessoryId;
    if(sscanf(params, "ui", targetid, accessoryId)) return SendClientMessage(playerid, -1, "Usage: /giveacc [id] [accessory_id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "Player not found.");
    if(accessoryId < 0) return SendClientMessage(playerid, -1, "Invalid accessory_id.");

    if(!Inventory_AddAccessoryItem(targetid, accessoryId)) return SendClientMessage(playerid, -1, "Failed to give accessory: no space, invalid ID or overweight.");

    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);

    new msg[144];
    format(msg, sizeof(msg), "You gave accessory ID %d to %s", accessoryId, GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, msg);
    Inv_ShowNotification(targetid, 1, 5, 0, 0, "Accessory added to inventory", "");
    return 1;
}


CMD:givesim(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, number;
    if(sscanf(params, "ui", targetid, number)) return SendClientMessage(playerid, -1, "Использование: /givesim [id] [номер]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "Игрок не найден.");
    if(number < 1000 || number > 999999999) return SendClientMessage(playerid, -1, "Номер от 1000 до 999999999.");

    if(!Inventory_AddSIMCard(targetid, number)) return SendClientMessage(playerid, -1, "Не удалось выдать SIM-карту: нет места или превышен вес.");

    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);

    new msg[144];
    format(msg, sizeof(msg), "Вы выдали SIM-карту с номером %d игроку %s", number, GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, msg);
    Inv_ShowNotification(targetid, 1, 5, 0, 0, "Вы получили SIM-карту в инвентарь", "");
    return 1;
}


CMD:givenz(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;
    new targetid, number[8], region[4];
    if(sscanf(params, "us[8]s[3]", targetid, number, region)) return SendClientMessage(playerid, -1, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ: /givenz [id] [пїЅпїЅпїЅпїЅпїЅ] [пїЅпїЅпїЅпїЅпїЅпїЅ]");
    if(!IsPlayerConnected(targetid)) return 1;
    new slot = Inventory_GetFreeSlot(targetid);
    if(slot == -1) return SendClientMessage(playerid, -1, "пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ");
    new plate_data[32];
    format(plate_data, sizeof(plate_data), "%s|%s", number, region);
    Inventory_SetItem(targetid, slot, 59, 1, plate_data);
    SetPlayerWeight(targetid, GetPlayerWeight(targetid) + GetItemWeight(59));
    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);
    new msg[128];
    format(msg, sizeof(msg), "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ '%s %s' пїЅпїЅпїЅпїЅпїЅпїЅ %s", number, region, GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, msg);
    Inv_ShowNotification(targetid, 1, 5, 0, 0, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", "");
    return 1;
}


stock GivePlayerItem(playerid, itemid, count)
{
    if(count <= 0) return 0;

    if(Inventory_IsSIMItem(itemid))
    {
        new simNumber = count;
        if(simNumber < 1000 || simNumber > 999999999) simNumber = 100000 + random(900000);
        return Inventory_AddSIMCard(playerid, simNumber);
    }

    new acc = Accessory_GetAccIdByInvItem(itemid);
    if(acc >= 0)
    {
        for(new i = 0; i < count; i++)
        {
            if(!Inventory_AddAccessoryItem(playerid, acc, itemid)) return 0;
        }
        return 1;
    }

    return Inventory_AddItem(playerid, itemid, count);
}
stock GivePlayerSkin(playerid, skinid) { return Inventory_AddSkinItem(playerid, skinid); }

stock StartTrade(p1, p2, slot)
{
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        TradeData[p1][trade_Items][i] = -1;
        TradeData[p1][trade_ItemId][i] = 0;
        TradeData[p1][trade_ItemCount][i] = 0;
        TradeData[p2][trade_Items][i] = -1;
        TradeData[p2][trade_ItemId][i] = 0;
        TradeData[p2][trade_ItemCount][i] = 0;
    }
    
    TradeData[p1][trade_Items][0] = slot;
    TradeData[p1][trade_ItemId][0] = GetPVarInt(p1, "Trade_ItemId");
    TradeData[p1][trade_ItemCount][0] = GetPVarInt(p1, "Trade_ItemCount");
    
    TradeData[p1][trade_Partner] = p2;
    TradeData[p2][trade_Partner] = p1;
    TradeData[p1][trade_IsOpen] = true;
    TradeData[p2][trade_IsOpen] = true;
    TradeData[p1][trade_Confirmed] = false;
    TradeData[p2][trade_Confirmed] = false;
    TradeData[p1][trade_Money] = 0;
    TradeData[p2][trade_Money] = 0;
    
    DeletePVar(p1, "Trade_ItemSlot");
    DeletePVar(p1, "Trade_ItemId");
    DeletePVar(p1, "Trade_ItemCount");
    
    OpenTradeGUI(p1);
    OpenTradeGUI(p2);
}

stock OpenTradeGUI(playerid)
{
    new target = TradeData[playerid][trade_Partner];
    if(target == -1) return;
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "mode", 3);
    JSON_SetInt(json, "target_id", target);
    JSON_SetString(json, "target_name", GetPlayerNameEx(target));
    JSON_SetInt(json, "my_confirmed", TradeData[playerid][trade_Confirmed]);
    JSON_SetInt(json, "his_confirmed", TradeData[target][trade_Confirmed]);
    JSON_SetInt(json, "my_money", TradeData[playerid][trade_Money]);
    JSON_SetInt(json, "his_money", TradeData[target][trade_Money]);
    
    ShowPlayerGUI(playerid, 33, json);
    JSON_Cleanup(json);
}

stock AddToTrade(playerid, inv_slot)
{
    if(!TradeData[playerid][trade_IsOpen]) return;
    if(TradeData[playerid][trade_Confirmed])
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Вы уже подтвердили обмен", "");
        return;
    }
    
    new empty = -1;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(TradeData[playerid][trade_Items][i] == -1)
        {
            empty = i;
            break;
        }
    }
    
    if(empty == -1)
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Все ячейки обмена заполнены", "");
        return;
    }
    
    TradeData[playerid][trade_Items][empty] = inv_slot;
    TradeData[playerid][trade_ItemId][empty] = g_PlayerInventory[playerid][inv_slot][inv_itemId];
    TradeData[playerid][trade_ItemCount][empty] = g_PlayerInventory[playerid][inv_slot][inv_itemCount];
    
    TradeData[playerid][trade_Confirmed] = false;
    new target = TradeData[playerid][trade_Partner];
    TradeData[target][trade_Confirmed] = false;
    
    OpenTradeGUI(playerid);
    OpenTradeGUI(target);
    
    Inv_ShowNotification(playerid, 3, 5, 0, 0, "Предмет добавлен в обмен", "");
}

stock RemoveFromTrade(playerid, trade_slot)
{
    if(!TradeData[playerid][trade_IsOpen]) return;
    if(TradeData[playerid][trade_Confirmed])
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Вы уже подтвердили обмен", "");
        return;
    }
    
    if(TradeData[playerid][trade_Items][trade_slot] == -1) return;
    
    TradeData[playerid][trade_Items][trade_slot] = -1;
    TradeData[playerid][trade_ItemId][trade_slot] = 0;
    TradeData[playerid][trade_ItemCount][trade_slot] = 0;
    
    TradeData[playerid][trade_Confirmed] = false;
    new target = TradeData[playerid][trade_Partner];
    TradeData[target][trade_Confirmed] = false;
    
    OpenTradeGUI(playerid);
    OpenTradeGUI(target);
    
    Inv_ShowNotification(playerid, 3, 5, 0, 0, "Предмет убран из обмена", "");
}

stock AddMoneyToTrade(playerid, amount)
{
    if(!TradeData[playerid][trade_IsOpen]) return;
    if(TradeData[playerid][trade_Confirmed])
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Вы уже подтвердили обмен", "");
        return;
    }
    
    if(amount <= 0)
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Сумма должна быть больше 0", "");
        return;
    }
    
    if(amount > GetPlayerMoneyEx(playerid))
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Недостаточно денег", "");
        return;
    }
    
    TradeData[playerid][trade_Money] = amount;
    TradeData[playerid][trade_Confirmed] = false;
    new target = TradeData[playerid][trade_Partner];
    TradeData[target][trade_Confirmed] = false;
    
    OpenTradeGUI(playerid);
    OpenTradeGUI(target);
    
    Inv_ShowNotification(playerid, 3, 5, 0, 0, "Деньги добавлены в обмен", "");
}

stock ConfirmTrade(playerid)
{
    if(!TradeData[playerid][trade_IsOpen]) return;
    
    new target = TradeData[playerid][trade_Partner];
    
    if(TradeData[playerid][trade_Confirmed])
    {
        TradeData[playerid][trade_Confirmed] = false;
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Вы отменили подтверждение", "");
        OpenTradeGUI(playerid);
        OpenTradeGUI(target);
        return;
    }
    
    TradeData[playerid][trade_Confirmed] = true;
    Inv_ShowNotification(playerid, 3, 5, 0, 0, "Вы подтвердили обмен. Ожидание партнера...", "");
    OpenTradeGUI(playerid);
    OpenTradeGUI(target);
    
    if(TradeData[playerid][trade_Confirmed] && TradeData[target][trade_Confirmed])
    {
        FinalizeTrade(playerid, target);
    }
}

stock FinalizeTrade(p1, p2)
{
    if(GetPlayerMoneyEx(p1) < TradeData[p1][trade_Money])
    {
        Inv_ShowNotification(p1, 2, 5, 0, 0, "Недостаточно денег", "");
        Inv_ShowNotification(p2, 2, 5, 0, 0, "У игрока недостаточно денег", "");
        CloseTrade(p1);
        CloseTrade(p2);
        return;
    }
    
    if(GetPlayerMoneyEx(p2) < TradeData[p2][trade_Money])
    {
        Inv_ShowNotification(p1, 2, 5, 0, 0, "У игрока недостаточно денег", "");
        Inv_ShowNotification(p2, 2, 5, 0, 0, "Недостаточно денег", "");
        CloseTrade(p1);
        CloseTrade(p2);
        return;
    }
    
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(TradeData[p1][trade_Items][i] != -1)
        {
            new slot = TradeData[p1][trade_Items][i];
            Inventory_AddItem(p2, TradeData[p1][trade_ItemId][i], TradeData[p1][trade_ItemCount][i]);
            Inventory_DeleteSlot(p1, slot);
        }
        
        if(TradeData[p2][trade_Items][i] != -1)
        {
            new slot = TradeData[p2][trade_Items][i];
            Inventory_AddItem(p1, TradeData[p2][trade_ItemId][i], TradeData[p2][trade_ItemCount][i]);
            Inventory_DeleteSlot(p2, slot);
        }
    }
    
    if(TradeData[p1][trade_Money] > 0)
    {
        GivePlayerMoneyEx(p1, -TradeData[p1][trade_Money]);
        GivePlayerMoneyEx(p2, TradeData[p1][trade_Money]);
    }
    
    if(TradeData[p2][trade_Money] > 0)
    {
        GivePlayerMoneyEx(p2, -TradeData[p2][trade_Money]);
        GivePlayerMoneyEx(p1, TradeData[p2][trade_Money]);
    }
    
    Inventory_Save(p1);
    Inventory_Save(p2);
    
    Inv_ShowNotification(p1, 3, 6, 0, 0, "Обмен успешно завершен", "");
    Inv_ShowNotification(p2, 3, 6, 0, 0, "Обмен успешно завершен", "");
    
    CloseTrade(p1);
    CloseTrade(p2);
}

stock CloseTrade(playerid)
{
    if(!TradeData[playerid][trade_IsOpen]) return;
    
    TradeData[playerid][trade_IsOpen] = false;
    new target = TradeData[playerid][trade_Partner];
    
    if(target != -1 && IsPlayerConnected(target) && TradeData[target][trade_IsOpen])
    {
        TradeData[target][trade_IsOpen] = false;
        Inv_ShowNotification(target, 2, 5, 0, 0, "Партнер закрыл окно обмена", "");
        
        new Node:closeJson = JSON_Object();
        JSON_SetInt(closeJson, "mode", 4);
        ShowPlayerGUI(target, 33, closeJson);
        JSON_Cleanup(closeJson);
    }
    
    new Node:closeJson = JSON_Object();
    JSON_SetInt(closeJson, "mode", 4);
    ShowPlayerGUI(playerid, 33, closeJson);
    JSON_Cleanup(closeJson);
    
    Inv_ShowNotification(playerid, 2, 5, 0, 0, "Обмен закрыт", "");
}

stock ShowNearbyPlayersList(playerid)
{
    new count = 0;
    new Float:x, Float:y, Float:z;
    new Node:playersArray = JSON_Array();
    new Node:json = JSON_Object();
    
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(i == playerid) continue;
        if(!IsPlayerInRangeOfPoint(i, 10.0, x, y, z)) continue;
        if(TradeData[i][trade_IsOpen]) continue;
        
        new Node:p = JSON_Object();
        JSON_SetInt(p, "id", i);
        JSON_SetString(p, "name", GetPlayerNameEx(i));
        JSON_Append(playersArray, p);
        JSON_Cleanup(p);
        count++;
    }
    
    if(count == 0)
    {
        Inv_ShowNotification(playerid, 2, 5, 0, 0, "Рядом нет игроков", "");
        return;
    }
    
    JSON_SetInt(json, "mode", 1);
    JSON_SetArray(json, "players", playersArray);
    JSON_SetInt(json, "item_id", GetPVarInt(playerid, "Trade_ItemId"));
    JSON_SetInt(json, "item_count", GetPVarInt(playerid, "Trade_ItemCount"));
    
    ShowPlayerGUI(playerid, 33, json);
    JSON_Cleanup(json);
}