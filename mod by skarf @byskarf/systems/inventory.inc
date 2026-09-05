#if defined _inv_included
    #endinput
#endif
#define _inv_included

#include <a_samp>
#include <a_mysql>
#include "../include/json.inc"
#include "../include/Pawn.RakNet.inc"

#define MAX_TRADE_SLOTS (20)
new moneyTradeP[MAX_PLAYERS];
new moneyTradeT[MAX_PLAYERS];
new tradeFlag[MAX_PLAYERS];
new TradeTimer[MAX_PLAYERS];

enum E_TRADE_DATA
{
    bool:tradeActive,
    tradeTarget,

    tradeMoney,
    bool:tradeReady,

    tradeItemSlot[MAX_TRADE_SLOTS],
    tradeItemId[MAX_TRADE_SLOTS],
    tradeItemCount[MAX_TRADE_SLOTS]
};

new TradeInfo[MAX_PLAYERS][E_TRADE_DATA];

#define MAX_INVENTORY_SLOTS   40
#define MAX_TRUNK_SLOTS    20
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

#define INVENTORY_ACCESSORY_ITEM_BASE   (201)
#define INVENTORY_ACCESSORY_ITEM_LIMIT  (1200)

#define MAX_TRADE_ITEMS 40

static g_TradeItemID[MAX_PLAYERS][MAX_TRADE_ITEMS];
static g_TradeItemCount[MAX_PLAYERS][MAX_TRADE_ITEMS];
static g_TradeItemSlot[MAX_PLAYERS][MAX_TRADE_ITEMS];  

enum E_INVENTORY_ITEM
{
    inv_itemId,
    inv_itemCount,
    inv_itemSlot,
    inv_itemPlate[32],
    inv_itemType,
    inv_itemWeight,
    bool:inv_itemActive,
    inv_activeSlot
}

new g_PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][E_INVENTORY_ITEM];

static g_TradeSlot[MAX_PLAYERS][MAX_TRADE_ITEMS];
static g_TradeCount[MAX_PLAYERS][MAX_TRADE_ITEMS];
static g_TradeItemsCount[MAX_PLAYERS];

enum E_TRUNK_ITEM
{
    inv_itemId,
    inv_itemCount,
    inv_itemSlot,
    inv_itemPlate[32],
    inv_itemType,
    inv_itemWeight,
    bool:inv_itemActive,
    inv_activeSlot
}

new g_PlayerTrunkItems[MAX_PLAYERS][MAX_INVENTORY_SLOTS][E_TRUNK_ITEM];

new g_PlayerActiveSlots[MAX_PLAYERS][MAX_ACTIVE_SLOTS][E_INVENTORY_ITEM];
new Float:g_PlayerWeight[MAX_PLAYERS];
new Float:g_PlayerMaxWeight[MAX_PLAYERS] = {150.0, ...};
new g_PlayerPhoneNumber[MAX_PLAYERS];
new g_PlayerMedChest[MAX_PLAYERS];

forward OnInventoryLoad(playerid);
forward Accessory_OnInventoryLoaded(playerid);
forward bool:Accessory_UseFromInventory(playerid, invSlot);
forward Accessory_SaveAllSlots(playerid);
forward Accessory_LoadAllFromDB(playerid);
forward bool:Inventory_AddAccessoryItem(playerid, accessoryId, itemIdOverride = -1);

stock GetItemType(itemId)
{
    if(itemId == 134) return ITEM_TYPE_SKIN;
    if(itemId == 58) return ITEM_TYPE_SIM;
    if(itemId == 22 || itemId == 23) return ITEM_TYPE_MEDICAL;
    if(itemId == 135) return ITEM_TYPE_FOOD;
    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT) return ITEM_TYPE_ACCESSORY;
    if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83) return ITEM_TYPE_PLATE;
    return ITEM_TYPE_OTHER;
}

stock Float:GetItemWeight(itemId)
{
    if(itemId == 134) return 5.0;
    if(itemId == 22) return 2.5;
    if(itemId == 23) return 5.0;
    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT) return 3.0;
    return 5.0;
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

stock Inventory_ToGuiActiveSlot(activeSlot, itemId)
{
    if(itemId == 58 || activeSlot == SLOT_SIM) return 255;
    if(itemId == 134 || activeSlot == SLOT_SKIN) return 6;
    if(activeSlot >= SLOT_ACCESSORY_START && activeSlot <= SLOT_ACCESSORY_END) return activeSlot - SLOT_ACCESSORY_START;
    return activeSlot;
}

stock Inventory_FromGuiActiveSlot(itemId, guiSlot)
{
    if(itemId == 58 || guiSlot == 255) return SLOT_SIM;
    if(itemId == 134 || guiSlot == 6) return SLOT_SKIN;
    if(Inventory_IsAccessoryItem(itemId))
    {
        if(guiSlot >= 0 && guiSlot <= 5) return guiSlot + SLOT_ACCESSORY_START;
        if(guiSlot >= SLOT_ACCESSORY_START && guiSlot <= SLOT_ACCESSORY_END) return guiSlot;
    }
    return guiSlot;
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
    g_PlayerWeight[playerid] = 0.0;
    g_PlayerPhoneNumber[playerid] = 0;
    g_PlayerMedChest[playerid] = 0;
    return 1;
}

stock Inventory_DeleteSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    new itemId = g_PlayerInventory[playerid][slot][inv_itemId];
    new cnt = g_PlayerInventory[playerid][slot][inv_itemCount];
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - GetItemWeight(itemId) * cnt);
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
    g_PlayerInventory[playerid][slot][inv_itemType] = GetItemType(itemId);
    g_PlayerInventory[playerid][slot][inv_itemWeight] = floatround(GetItemWeight(itemId));
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    g_PlayerInventory[playerid][slot][inv_activeSlot] = -1;
    return 1;
}

stock trunk_SetItem(playerid, slot, itemId, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    g_PlayerTrunkItems[playerid][slot][inv_itemId] = itemId;
    g_PlayerTrunkItems[playerid][slot][inv_itemCount] = count;
    g_PlayerTrunkItems[playerid][slot][inv_itemSlot] = slot;
    format(g_PlayerTrunkItems[playerid][slot][inv_itemPlate], 32, "%s", plate);
    g_PlayerTrunkItems[playerid][slot][inv_itemType] = GetItemType(itemId);
    g_PlayerTrunkItems[playerid][slot][inv_itemWeight] = floatround(GetItemWeight(itemId));
    g_PlayerTrunkItems[playerid][slot][inv_itemActive] = false;
    g_PlayerTrunkItems[playerid][slot][inv_activeSlot] = -1;
    return 1;
}

stock Inventory_SetActiveItem(playerid, activeSlot, itemId, count, const plate[] = "")
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = itemId;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = count;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemSlot] = activeSlot;
    format(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], 32, "%s", plate);
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
    new Float:weightAdd = GetItemWeight(itemId) * count;
    Inventory_SetItem(playerid, slot, itemId, count, plate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weightAdd);
    return 1;
}

stock bool:Inventory_AddItem(playerid, itemId, count)
{
    if(itemId <= 0 || count <= 0) return false;
    new Float:weightAdd = GetItemWeight(itemId) * count;
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return false;
    new itemType = GetItemType(itemId);
    if(itemType == ITEM_TYPE_SIM || itemType == ITEM_TYPE_SKIN || itemType == ITEM_TYPE_PLATE || itemType == ITEM_TYPE_ACCESSORY)
    {
        for(new i = 0; i < count; i++)
        {
            new slot = Inventory_GetFreeSlot(playerid);
            if(slot == -1) return false;
            new plateStr[12];
            if(itemType == ITEM_TYPE_SIM) valstr(plateStr, (g_PlayerPhoneNumber[playerid] > 0) ? g_PlayerPhoneNumber[playerid] : 0);
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
    if(skinModel < 0) return false;
    new Float:weightAdd = GetItemWeight(134);
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
    new skin = GetPlayerSkin(playerid);
    if(skin <= 0 || skin > 311) skin = GetPlayerSkin(playerid);
    if(skin <= 0 || skin > 311) skin = 1;

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemId] != 134)
    {
        Inventory_SetActiveItem(playerid, SLOT_SKIN, 134, skin, "");
        SetPlayerSkin(playerid, skin);

        return 1;
    }

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] <= 0 || g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] > 311)
    {
        g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] = skin;
    }

    SetPlayerSkin(playerid, g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount]);
   
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
            ShowNotification(playerid, 2, 5, 0, 0, "Нет места в инвентаре", "");
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
    if(itemId == 58)
    {
        new phone = strval(g_PlayerActiveSlots[playerid][targetSlot][inv_itemPlate]);
        if(phone <= 0) phone = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        g_PlayerPhoneNumber[playerid] = phone;
        ShowNotification(playerid, 3, 5, 0, 0, "Вы надели SIM-карту", "");
    }
    else if(itemId == 134)
    {
        new skinId = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        SetPlayerSkin(playerid, skinId);
        SetPlayerData(playerid, P_SKIN, skinId);
	UpdatePlayerDatabaseInt(playerid, "skin", skinId);
       
        ShowNotification(playerid, 3, 5, 0, 0, "Вы надели скин", "");
    }
    activeSlot = targetSlot;
    return 1;
}

stock Inventory_MoveFromSlotToInv(playerid, itemId, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerActiveSlots[playerid][oldSlot][inv_itemId] != itemId) return 0;
    if(g_PlayerInventory[playerid][newSlot][inv_itemId] > 0) return 0;
    if(itemId == 134 && oldSlot == SLOT_SKIN) return 0;

    Inventory_SetItem(playerid, newSlot, g_PlayerActiveSlots[playerid][oldSlot][inv_itemId], g_PlayerActiveSlots[playerid][oldSlot][inv_itemCount], g_PlayerActiveSlots[playerid][oldSlot][inv_itemPlate]);

    if(Inventory_IsAccessoryItem(itemId)) RemovePlayerAttachedObject(playerid, oldSlot);

    if(itemId == 58 && oldSlot == SLOT_SIM)
    {
        g_PlayerPhoneNumber[playerid] = 0;
        ShowNotification(playerid, 3, 5, 0, 0, "Вы сняли SIM-карту", "");
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
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] != itemId) return 0;
    if(itemId == 134 && activeSlot == SLOT_SKIN) return 0;

    if(Inventory_IsAccessoryItem(itemId)) RemovePlayerAttachedObject(playerid, activeSlot);

    if(itemId == 58 && activeSlot == SLOT_SIM)
    {
        g_PlayerPhoneNumber[playerid] = 0;
        ShowNotification(playerid, 3, 5, 0, 0, "Вы удалили SIM-карту", "");
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
    ShowNotification(playerid, 3, 6, 0, 0, "Вы использовали аптечку", "");
    ApplyAnimation(playerid, "PED", "gum_eat", 3.0, 0, 0, 0, 0, 0, 1);
    g_PlayerMedChest[playerid] = 0;
    return true;
}

stock Inventory_UseRepairKit(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;
    new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0);
    if(vehicleid == INVALID_VEHICLE_ID) { ShowNotification(playerid, 2, 6, 0, 0, "Подойдите ближе к транспорту", ""); return false; }
    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 23) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    else { usedSlot = Inventory_FindItemSlot(playerid, 23); if(usedSlot != -1) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0); }
    if(!removed) return false;
    SetVehicleHealth(vehicleid, 1000.0);
    RepairVehicle(vehicleid);
    ShowNotification(playerid, 3, 6, 0, 0, "Транспорт отремонтирован", "");
    return true;
}

stock bool:Inventory_UseSkinFromSlot(playerid, slot, &newSkinModel)
{
    newSkinModel = 0;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    if(g_PlayerInventory[playerid][slot][inv_itemId] != 134) return false;

    new targetSkin = g_PlayerInventory[playerid][slot][inv_itemCount];
    if(targetSkin <= 0 || targetSkin > 311) return false;

    new oldSkin = GetPlayerSkin(playerid);
    if(oldSkin <= 0 || oldSkin > 311) oldSkin = GetPlayerSkin(playerid);

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemId] == 134)
    {
        new freeSlot = Inventory_GetFreeSlot(playerid);
        if(freeSlot == -1) return false;
        new oldActiveSkin = g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount];
        if(oldActiveSkin <= 0 || oldActiveSkin > 311) oldActiveSkin = oldSkin;
        Inventory_SetItem(playerid, freeSlot, 134, oldActiveSkin, "");
        SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(134));
        Inventory_ClearActiveSlot(playerid, SLOT_SKIN);
    }

    if(!Inventory_DeleteSlot(playerid, slot)) return false;

    Inventory_SetActiveItem(playerid, SLOT_SKIN, 134, targetSkin, "");
    SetPlayerSkin(playerid, targetSkin);
    
    SetPlayerData(playerid, P_SKIN, targetSkin);
	UpdatePlayerDatabaseInt(playerid, "skin", targetSkin);

    ShowNotification(playerid, 3, 5, 0, 0, "Вы переоделись", "");
    return true;
}

stock bool:Inventory_UseSIMFromSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS || g_PlayerInventory[playerid][slot][inv_itemId] != 58) return false;
    new usedCount = g_PlayerInventory[playerid][slot][inv_itemCount];
    new usedPlate[32]; format(usedPlate, 32, "%s", g_PlayerInventory[playerid][slot][inv_itemPlate]);
    new oldActiveCount = 0, oldActivePlate[32];
    if(g_PlayerActiveSlots[playerid][SLOT_SIM][inv_itemId] == 58)
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
            Inventory_SetItem(playerid, freeSlot, 58, oldActiveCount, oldActivePlate);
            SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(58));
        }
        else ShowNotification(playerid, 2, 5, 0, 0, "Нет места для старой SIM-карты", "");
    }
    Inventory_SetActiveItem(playerid, SLOT_SIM, 58, usedCount, usedPlate);
    new phone = strval(usedPlate); if(phone <= 0) phone = usedCount;
    g_PlayerPhoneNumber[playerid] = phone;
    ShowNotification(playerid, 3, 5, 0, 0, "Вы активировали SIM-карту", "");
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
        if(isActive)
        {
            new fixedActiveSlot = Inventory_GetCorrectActiveSlot(playerid, itemId, activeSlot);

            if(fixedActiveSlot >= 0 && fixedActiveSlot < MAX_ACTIVE_SLOTS)
            {
                Inventory_SetActiveItem(playerid, fixedActiveSlot, itemId, count, plate);

                if(itemId == 134 && fixedActiveSlot == SLOT_SKIN)
                {
                    SetPlayerSkin(playerid, count);
                }

                if(itemId == 58 && fixedActiveSlot == SLOT_SIM)
                {
                    new phone = strval(plate);
                    if(phone <= 0) phone = count;
                    g_PlayerPhoneNumber[playerid] = phone;
                }
            }
            else
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot != -1)
                {
                    Inventory_SetItem(playerid, freeSlot, itemId, count, plate);
                    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId) * count);
                }
            }
        }
        else
        {
            if(slot >= 0 && slot < MAX_INVENTORY_SLOTS)
            {
                Inventory_SetItem(playerid, slot, itemId, count, plate);
                SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId) * count);
            }
        }
    }
    g_PlayerMedChest[playerid] = (Inventory_FindItemSlot(playerid, 22) != -1);
    Inventory_EnsureCurrentSkin(playerid);
//    Accessory_OnInventoryLoaded(playerid);
    Inventory_Save(playerid);
    return 1;
}

stock Inventory_Load(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    new q[256];
    mysql_format(mysql, q, sizeof(q), "SELECT `slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot` FROM `player_inventory` WHERE `player_id` = %d", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, q, "OnInventoryLoad", "d", playerid);
   // Accessory_LoadAllFromDB(playerid);
    return 1;
}

stock GetPlayerTrunkVehicle(playerid)
{
    return GetPVarInt(playerid, "TRUNK_VEHICLE_ID");
}

stock trunk_Reset(playerid)
{
    for(new i; i < MAX_INVENTORY_SLOTS; i++)
    {
        g_PlayerTrunkItems[playerid][i][inv_itemId] = 0;
        g_PlayerTrunkItems[playerid][i][inv_itemCount] = 0;
        g_PlayerTrunkItems[playerid][i][inv_itemSlot] = 0;
        g_PlayerTrunkItems[playerid][i][inv_itemPlate][0] = EOS;
        g_PlayerTrunkItems[playerid][i][inv_itemType] = 0;
        g_PlayerTrunkItems[playerid][i][inv_itemWeight] = 0;
        g_PlayerTrunkItems[playerid][i][inv_itemActive] = false;
        g_PlayerTrunkItems[playerid][i][inv_activeSlot] = -1;
    }
    return 1;
}

stock Trunk_GetFreeSlot(playerid)
{
    for(new i; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerTrunkItems[playerid][i][inv_itemId] == 0)
            return i;
    }

    return -1;
}

stock Trunk_DeleteSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS)
        return 0;

    g_PlayerTrunkItems[playerid][slot][inv_itemId] = 0;
    g_PlayerTrunkItems[playerid][slot][inv_itemCount] = 0;
    g_PlayerTrunkItems[playerid][slot][inv_itemPlate][0] = EOS;
    g_PlayerTrunkItems[playerid][slot][inv_itemType] = 0;
    g_PlayerTrunkItems[playerid][slot][inv_itemWeight] = 0;

    return 1;
}

stock Trunk_Load(playerid)
{
    new vehicleid = GetPlayerTrunkVehicle(playerid);

    if(vehicleid <= 0)
        return 0;

    trunk_Reset(playerid);

    new query[256];

    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM `vehicle_trunk_inventory` WHERE `vehicle_id` = %d",
        vehicleid
    );

    mysql_tquery(mysql, query, "OnTrunkLoad", "d", playerid);

    return 1;
}

forward OnTrunkLoad(playerid);
public OnTrunkLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    for(new i; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");

        if(slot < 0 || slot >= MAX_INVENTORY_SLOTS)
            continue;

        g_PlayerTrunkItems[playerid][slot][inv_itemId]
            = cache_get_field_content_int(i, "item_id");

        g_PlayerTrunkItems[playerid][slot][inv_itemCount]
            = cache_get_field_content_int(i, "item_count");

        cache_get_field_content
        (
            i,
            "item_plate",
            g_PlayerTrunkItems[playerid][slot][inv_itemPlate],
            32
        );
    }
    trunk_Save(playerid);
    return 1;
}

stock trunk_Save(playerid)
{
    new vehicleid = GetPlayerTrunkVehicle(playerid);

    if(vehicleid <= 0)
        return 0;

    new query[512];

    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `vehicle_trunk_inventory` WHERE `vehicle_id` = %d",
        vehicleid
    );

    mysql_query(mysql, query);

    for(new i; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerTrunkItems[playerid][i][inv_itemId] <= 0)
            continue;

        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `vehicle_trunk_inventory` \
            (`vehicle_id`,`slot`,`item_id`,`item_count`,`item_plate`) \
            VALUES (%d,%d,%d,%d,'%e')",
            vehicleid,
            i,
            g_PlayerTrunkItems[playerid][i][inv_itemId],
            g_PlayerTrunkItems[playerid][i][inv_itemCount],
            g_PlayerTrunkItems[playerid][i][inv_itemPlate]
        );

        mysql_query(mysql, query);
    }

    return 1;
}

stock Inventory_MoveToTrunk(playerid, invSlot, old, count)
{
    if(invSlot == -1)
        return 0;

    new itemid = g_PlayerInventory[playerid][old][inv_itemId];

    if(itemid == 58)
    {
        trunk_SetItem
        (
            playerid,
            invSlot,
            itemid,
            g_PlayerInventory[playerid][old][inv_itemCount],
            g_PlayerInventory[playerid][old][inv_itemPlate]
        );

        Inventory_DeleteSlot(playerid, old);
        trunk_Save(playerid);
        return 1;
    }

    if(itemid != 134)
    {
        for(new i; i < MAX_INVENTORY_SLOTS; i++)
        {
            if(i == invSlot)
                continue;

            if(g_PlayerTrunkItems[playerid][i][inv_itemId] == itemid)
            {
                invSlot = i;
                break;
            }
        }
    }

    if(count > g_PlayerInventory[playerid][old][inv_itemCount])
        count = g_PlayerInventory[playerid][old][inv_itemCount];

    if(itemid != 134
    && g_PlayerTrunkItems[playerid][invSlot][inv_itemId] == itemid)
    {
        g_PlayerTrunkItems[playerid][invSlot][inv_itemCount] += count;
    }
    else
    {
        trunk_SetItem
        (
            playerid,
            invSlot,
            itemid,
            count,
            g_PlayerInventory[playerid][old][inv_itemPlate]
        );
    }

    new remain = g_PlayerInventory[playerid][old][inv_itemCount] - count;

    if(remain <= 0)
        Inventory_DeleteSlot(playerid, old);
    else
        g_PlayerInventory[playerid][old][inv_itemCount] = remain;

    trunk_Save(playerid);
    return 1;
}

stock Trunk_MoveToInventory(playerid, invSlot, old, count)
{
    if(invSlot == -1)
        return 0;

    new itemid = g_PlayerTrunkItems[playerid][old][inv_itemId];

    if(itemid == 58)
    {
        Inventory_SetItem
        (
            playerid,
            invSlot,
            itemid,
            g_PlayerTrunkItems[playerid][old][inv_itemCount],
            g_PlayerTrunkItems[playerid][old][inv_itemPlate]
        );

        Trunk_DeleteSlot(playerid, old);
        trunk_Save(playerid);
        return 1;
    }

    if(itemid != 134)
    {
        for(new i; i < MAX_INVENTORY_SLOTS; i++)
        {
            if(i == invSlot)
                continue;

            if(g_PlayerInventory[playerid][i][inv_itemId] == itemid)
            {
                invSlot = i;
                break;
            }
        }
    }

    if(count > g_PlayerTrunkItems[playerid][old][inv_itemCount])
        count = g_PlayerTrunkItems[playerid][old][inv_itemCount];

    if(itemid != 134
    && g_PlayerInventory[playerid][invSlot][inv_itemId] == itemid)
    {
        g_PlayerInventory[playerid][invSlot][inv_itemCount] += count;
    }
    else
    {
        Inventory_SetItem
        (
            playerid,
            invSlot,
            itemid,
            count,
            g_PlayerTrunkItems[playerid][old][inv_itemPlate]
        );
    }

    new remain = g_PlayerTrunkItems[playerid][old][inv_itemCount] - count;

    if(remain <= 0)
        Trunk_DeleteSlot(playerid, old);
    else
        g_PlayerTrunkItems[playerid][old][inv_itemCount] = remain;

    trunk_Save(playerid);
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
   // Accessory_SaveAllSlots(playerid);
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
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    new Node:json = JSON_Object("o", JSON_Int(1), "i", JSON_Int(0), "n", JSON_String(name), "lv", JSON_Int(GetPlayerLevel(playerid)), "id", JSON_Int(playerid), "v", JSON_Int(3), "ps", JSON_Int(GetPlayerSkin(playerid)), "m", JSON_Int(GetPlayerMoneyEx(playerid)), "s", JSON_Int(79), "sl", JSON_Int(MAX_INVENTORY_SLOTS), "nm", JSON_Int(g_PlayerPhoneNumber[playerid]), "en", JSON_String(""), "it", itemsArray, "ai", activeSlotsArray, "wi", JSON_Array());
    OnPacketIncoming(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock bool:trunk_HandlePacket(playerid, Node:JSONObject)
{
    new Node:json = JSON_Object();
    new MenuBID;
    JSON_GetInt(JSONObject, "t", MenuBID);
    new itemId, pos, oldPos, count, ipos;
    JSON_GetInt(JSONObject, "ga", itemId); 
    JSON_GetInt(JSONObject, "mw", count); 
    JSON_GetInt(JSONObject, "v", count); 
    JSON_GetInt(JSONObject, "ns", ipos);
    JSON_GetInt(JSONObject, "os", oldPos);

//new text[350];
//format(text, sizeof(text), "w %d mw %d cw %d nw %d type %d", pos, count, cwi, nwi, MenuBID);
//ShowNotification(playerid, 4, 6, -1, -1, text, "");

    switch(MenuBID)
    {        
        case 0:
        {      
           Inventory_MoveToTrunk(playerid, ipos, oldPos, count);
           ShowNotification(playerid, 3, 6, 0, 0, "Предмет успешно перемещён в багажник", "ок");          
           ShowPlayerTrunkGUI(playerid, 1);
           JSON_Cleanup(json);
           return true;
        }
        case 1:
        {
            Trunk_MoveToInventory(playerid, ipos, oldPos, count);
            ShowNotification(playerid, 3, 6, 0, 0, "Предмет успешно перемещён в инвентарь", "ок");
            ShowPlayerTrunkGUI(playerid, 1);
            JSON_Cleanup(json);
            return true;
        }
        case 8:
        {
            JSON_Cleanup(json);
            return true;
         } 
     }
 }
   
stock bool:Inventory_HandlePacket(playerid, Node:JSONObject)
{
    new Node:response = JSON_Object();
    new type; JSON_GetInt(JSONObject, "t", type);
    
    new itemId = 0, pos = -1, oldPos = -1, count = 0;
    new bool:ok = false;
    switch(type)
    {
        case 25:
        {
            ShowTradeDialog(playerid);
        }
        case 0:
        {
            JSON_GetInt(JSONObject, "ga", itemId); JSON_GetInt(JSONObject, "s", count); JSON_GetInt(JSONObject, "sl", pos);
            if(count <= 0) count = 1;
            if(pos >= 0 && pos < MAX_INVENTORY_SLOTS) ok = Inventory_AddItemToSlot(playerid, pos, itemId, count, "") != 0;
            else ok = Inventory_AddItem(playerid, itemId, count);
            JSON_SetInt(response, "t", 0); JSON_SetInt(response, "s", ok ? 1 : 0); JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 4:
        {
            JSON_GetInt(JSONObject, "ga", itemId); JSON_GetInt(JSONObject, "os", oldPos); JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            oldPos = Inventory_FromGuiActiveSlot(itemId, oldPos);
            ok = Inventory_MoveFromSlotToInv(playerid, itemId, oldPos, pos) != 0;
            JSON_SetInt(response, "t", 4); JSON_SetInt(response, "s", ok ? 1 : 0); JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 5:
        {
            new activeSlot;
            JSON_GetInt(JSONObject, "ga", itemId); JSON_GetInt(JSONObject, "sl", pos);
            ok = Inventory_EquipItem(playerid, itemId, pos, activeSlot) != 0;
            JSON_SetInt(response, "t", 5); JSON_SetInt(response, "s", ok ? 1 : 0);
            if(ok)
            {
                JSON_SetInt(response, "i", Inventory_ToGuiActiveSlot(activeSlot, itemId));
                JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
            }
        }
        case 18:
        {
            JSON_GetInt(JSONObject, "ga", itemId); JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            if(pos >= 0 && pos < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][pos][inv_itemId] == itemId)
            {
                ok = Inventory_RemoveOneItem(playerid, pos) != 0;
            }
            else
            {
                new activePos = Inventory_FromGuiActiveSlot(itemId, pos);
                if(activePos >= 0 && activePos < MAX_ACTIVE_SLOTS)
                {
                    ok = Inventory_DeleteFromActiveSlot(playerid, itemId, activePos) != 0;
                }
            }
            JSON_SetInt(response, "t", 18); JSON_SetInt(response, "s", ok ? 1 : 0); JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 19:
        {
            JSON_GetInt(JSONObject, "ga", itemId); JSON_GetInt(JSONObject, "sl", pos);
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
            else if(itemId == 58)
            {
                ok = Inventory_UseSIMFromSlot(playerid, pos);
            }
            else if(Inventory_IsAccessoryItem(itemId))
            {
    //            ok = Accessory_UseFromInventory(playerid, pos);
            }
            else
            {
                ok = Inventory_RemoveOneItem(playerid, pos) != 0;
            }
            JSON_SetInt(response, "t", 19); JSON_SetInt(response, "s", ok ? 1 : 0); JSON_SetFloat(response, "w", GetPlayerWeight(playerid));
        }
        case 23:
        {
            JSON_GetInt(JSONObject, "os", oldPos); JSON_GetInt(JSONObject, "sl", pos);
            if(pos == -1) JSON_GetInt(JSONObject, "s", pos);
            ok = Inventory_MoveItem(playerid, oldPos, pos) != 0;
            JSON_SetInt(response, "t", 23); JSON_SetInt(response, "s", ok ? 1 : 0); if(ok) JSON_SetInt(response, "i", pos);
        }
        default: { JSON_SetInt(response, "t", type); JSON_SetInt(response, "s", 0); }
    }
    if(ok) { Inventory_Save(playerid); if(type == 19) ShowPlayerInventory(playerid); }
    OnPacketIncoming(playerid, 33, response);
    JSON_Cleanup(response);
    return true;
}

CMD:inv(playerid) return ShowPlayerInventory(playerid);

stock FindInventorySlotByItem(playerid, itemid, count)
{
    for(new i; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(!g_PlayerInventory[playerid][i][inv_itemActive])
            continue;

        if(g_PlayerInventory[playerid][i][inv_itemId] != itemid)
            continue;

        if(g_PlayerInventory[playerid][i][inv_itemCount] != count)
            continue;

        return i;
    }

    return -1;
}

stock ClearTradeItems(playerid)
{
    g_TradeItemsCount[playerid] = 0;
    for(new i = 0; i < MAX_TRADE_ITEMS; i++)
    {
        g_TradeItemID[playerid][i] = 0;
        g_TradeItemCount[playerid][i] = 0;
        g_TradeItemSlot[playerid][i] = 0;  // Очищаем слот
    }
}

stock AddTradeItem(playerid, itemid, count, tradeslot)
{
    if(g_TradeItemsCount[playerid] >= MAX_TRADE_ITEMS)
        return 0;
    
    new idx = g_TradeItemsCount[playerid];
    g_TradeItemID[playerid][idx] = itemid;
    g_TradeItemCount[playerid][idx] = count;
    g_TradeItemSlot[playerid][idx] = tradeslot; 
    g_TradeItemsCount[playerid]++;
    
    return 1;
}

stock GetTradeItem(playerid, slot, &itemid, &count, &tradeslot)
{
    if(slot >= g_TradeItemsCount[playerid])
        return 0;
    
    itemid = g_TradeItemID[playerid][slot];
    count = g_TradeItemCount[playerid][slot];
    tradeslot = g_TradeItemSlot[playerid][slot];
    return 1;
}

stock Trade_SendMyItem(playerid, itemid, count, tradeslot)
{
AddTradeSlot(playerid, tradeslot, count);
    new Node:json = JSON_Object();
    
    JSON_SetInt(json, "t", 5);
    JSON_SetInt(json, "ga", itemid);
    JSON_SetInt(json, "os", tradeslot);
    
    if(count > 1)
    {
        JSON_SetInt(json, "s", 1);
        JSON_SetInt(json, "v", count);
        JSON_SetInt(json, "i", tradeslot);
    }
    else
    {
        JSON_SetInt(json, "s", count);
    }
    
    OnPacketIncoming(playerid, 33, json);
    JSON_Cleanup(json);
}

forward CheckTrade(playerid, targetid);
public CheckTrade(playerid, targetid)
{
    if(Confirm[playerid] == 0)
    {
        KillTimer(TradeTimer[playerid]);
        TradeTimer[playerid] = 0;
        return;
    }
   
    if(Confirm[targetid] == 1)
    {
        new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 26);
    JSON_SetInt(json, "s", 1);
    OnPacketIncoming(playerid, 33, json);
    OnPacketIncoming(targetid, 33, json);
    
    ShowNotification(playerid, 3, 5, 0, 0, "Теперь нужно нажать на кнопку ''Подтвердить''", "");
    ShowNotification(targetid, 3, 5, 0, 0, "Теперь нужно нажать на кнопку ''Подтвердить''", "");
    
        Confirm[playerid] = 0;
        Confirm[targetid] = 0;
       
        KillTimer(TradeTimer[playerid]);
        TradeTimer[playerid] = 0;
        
        if(TradeTimer[targetid] != 0)
        {
            KillTimer(TradeTimer[targetid]);
            TradeTimer[targetid] = 0;
        }
    }
}

stock AddAllTradeItemsToInventory(playerid)
{
    for(new i = 0; i < g_TradeItemsCount[playerid]; i++)
    {
        if(g_TradeItemID[playerid][i] > 0 && g_TradeItemCount[playerid][i] > 0)
        {
            new slot = Inventory_GetFreeSlot(playerid);
            Inventory_SetItem(playerid, slot, g_TradeItemID[playerid][i], g_TradeItemCount[playerid][i], "");
            Inventory_Save(playerid);
        }
    }
}

stock AddTradeSlot(playerid, slot, count)
{
    if(g_TradeItemsCount[playerid] >= MAX_TRADE_ITEMS)
        return 0;
    
    new idx = g_TradeItemsCount[playerid];
    g_TradeSlot[playerid][idx] = slot;
    g_TradeCount[playerid][idx] = count;
    g_TradeItemsCount[playerid]++;
    return 1;
}

stock ProcessTradeItems(playerid)
{
    if(g_TradeItemsCount[playerid] == 0)
        return 0;
    
    for(new i = 0; i < g_TradeItemsCount[playerid]; i++)
    {
        new slot = g_TradeSlot[playerid][i];
        new count = g_TradeCount[playerid][i];
               
        g_PlayerInventory[playerid][slot][inv_itemCount] -= count;
        Inventory_Save(playerid);
        
        if(g_PlayerInventory[playerid][slot][inv_itemCount] <= 0)
        {
            Inventory_DeleteSlot(playerid, slot);
            Inventory_Save(playerid);
        }
    }
    return 1;
}

stock HasTradeSlots(playerid)
{
    return (g_TradeItemsCount[playerid] > 0);
}

stock bool:trade_HandlePacket(playerid, Node:JSONObject)
{
    new Node:json = JSON_Object();
    new type; JSON_GetInt(JSONObject, "t", type);
    
    new money_gui = 0, g_money = 0;
    JSON_GetInt(JSONObject, "gm", g_money);
    JSON_GetInt(JSONObject, "em", money_gui);
    new targetid = GetPVarInt(playerid, "TradePID");
    
    switch(type)
    {
    case 8:
{    
    if(Confirm[playerid] == 0)
    {
        Confirm[playerid] = 1;
        ShowNotification(playerid, 3, 5, 0, 0, "Вам нужно подождать, пока другой игрок примет трейд", "");
        
        TradeTimer[playerid] = SetTimerEx("CheckTrade", 500, 1, "ii", playerid, targetid);
    }
}
case 26:
{
   new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 9);
    JSON_SetInt(json, "s", 1);    
    OnPacketIncoming(playerid, 33, json);
    OnPacketIncoming(targetid, 33, json);
    JSON_Cleanup(json);    
}
case 16:
{
   HidePlayerGUI(targetid, 33);
   SetPVarInt(playerid, "InTrade", 2);
   SetPVarInt(targetid, "InTrade", 2);
   ShowNotification(targetid, 2, 5, 0, 0, "Игрок отменил трейд", "");   
}
case 7:
{   
   SetPVarInt(playerid, "InTrade", 2);
   SetPVarInt(targetid, "InTrade", 2);

   HidePlayerGUI(playerid, 33);
   ShowInventoryGUIForExchange(playerid, targetid);

   HidePlayerGUI(targetid, 33);
   ShowInventoryGUIForExchange(targetid, playerid);
   ShowNotification(targetid, 2, 5, 0, 0, "Игрок очистил предметы обмена", "");   
}
case 9:
    {
    if(Confirm[playerid] == 0)
    {    
       if(Confirm[targetid] == 1)
       {                              
           Confirm[targetid] = 0;
           Confirm[playerid] = 0;       
           SetPVarInt(playerid, "InTrade", 2);
           SetPVarInt(targetid, "InTrade", 2);           
           HidePlayerGUI(playerid, 33);
           HidePlayerGUI(targetid, 33);
           ShowNotification(targetid, 3, 5, 0, 0, "Трейд завершён", "");
           ShowNotification(playerid, 3, 5, 0, 0, "Трейд завершён", "");
           
          AddAllTradeItemsToInventory(playerid);
          AddAllTradeItemsToInventory(targetid);
          
           if(HasTradeSlots(playerid))
        {
            ProcessTradeItems(playerid);
        }
        
        if(HasTradeSlots(targetid))
        {
            ProcessTradeItems(targetid);
        }                                                      
        
         ClearTradeSlots(playerid);
         ClearTradeSlots(targetid);
         ClearTradeItems(playerid);
         ClearTradeItems(targetid);
         
         ProcessTradeMoney(playerid, targetid);
           return true;
         }
        Confirm[playerid] = 1;        
        ShowNotification(targetid, 3, 5, 0, 0, "Другой игрок уже готов провести трейд", "");
     }
}
    case 31:
    {
        new email[128];
        JSON_GetString(JSONObject, "tx", email);
        JSON_SetInt(json, "t", 31);
        utf8_to_cp1251(email);
        JSON_SetString(json, "tx", email, sizeof(email));
         
         if (strlen(email) > 0) {
         OnPacketIncoming(targetid, 33, json);
         OnPacketIncoming(playerid, 33, json);
         JSON_Cleanup(json);    
        }
   }    
       case 5:
{
    new itemid, count, tradeslot;
    JSON_GetInt(JSONObject, "ga", itemid);
    JSON_GetInt(JSONObject, "s", count);
    JSON_GetInt(JSONObject, "os", tradeslot);
    
    Trade_SendMyItem(playerid, itemid, count, tradeslot, targetid);
    CreateItemForTrade(targetid, itemid, count, tradeslot);    
}

case 6:
{
    TUpdateExchangeStatusMoney(targetid, 3, 1, money_gui, moneyTradeP[playerid]);             
    PUpdateExchangeStatusMoney(playerid, 3, 1, money_gui, moneyTradeT[playerid]);     
}

}
    JSON_Cleanup(json);    
    return true;
}

stock ClearTradeSlots(playerid)
{
    g_TradeItemsCount[playerid] = 0;
}

stock PUpdateExchangeStatusMoney(playerid, type, status, money, id)
{
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "s", status);
    JSON_SetInt(JSONObject, "em", money);
    JSON_SetInt(JSONObject, "gm", id);
    
    new text2[50];
    format(text2, sizeof(text2), "Вы поставили предоплату в размере %d рублей", money);
    ShowNotification(playerid, 3, 6, 0, 0, text2, "ок"); 
    
    moneyTradeP[playerid] = money;
    
    OnPacketIncoming(playerid, 33, JSONObject);
    JSON_Cleanup(JSONObject);
}

stock TUpdateExchangeStatusMoney(playerid, type, status, money, id)
{
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "s", status);
    JSON_SetInt(JSONObject, "em", id);
    JSON_SetInt(JSONObject, "gm", money);
    
    new text[50];
    format(text, sizeof(text), "Игрок поставил предоплату в размере %d рублей", money);
    ShowNotification(playerid, 3, 6, 0, 0, text, "ок");
     
    moneyTradeT[playerid] = money;
    
    OnPacketIncoming(playerid, 33, JSONObject);
    JSON_Cleanup(JSONObject);
}

stock ProcessTradeMoney(playerid, targetid)
{
    if(moneyTradeP[playerid] > 0)
    {
        GivePlayerMoneyEx(playerid, -moneyTradeP[playerid]);
        GivePlayerMoneyEx(targetid, moneyTradeP[playerid]);
    }
    
    if(moneyTradeT[playerid] > 0)
    {
        GivePlayerMoneyEx(playerid, moneyTradeT[playerid]);
        GivePlayerMoneyEx(targetid, -moneyTradeT[playerid]);
    }
   
    moneyTradeP[playerid] = 0;
    moneyTradeT[playerid] = 0;
}

stock CreateItemForTrade(playerid, itemid, count, tradeslot)
{
     new Node:json = JSON_Object();     
     AddTradeItem(playerid, itemid, count, tradeslot);
     
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "ga", itemid);
    JSON_SetInt(json, "s", count);
    JSON_SetInt(json, "os", tradeslot);
    OnPacketIncoming(playerid, 33, json);
    JSON_Cleanup(json);    
}

CMD:giveitem(playerid, params[])
{
       if(GetPlayerAdminEx(playerid) < 13) return 1;
       
    new targetid, itemId, count = 1;
    if(sscanf(params, "uiD(1)", targetid, itemId, count)) return SendClientMessage(playerid, -1, "Использование: /giveitem [id] [item_id] [кол-во]");
    if(!IsPlayerConnected(targetid)) return 1;    
        new slot = Inventory_GetFreeSlot(targetid);
        Inventory_SetItem(targetid, slot, itemId, count, "");
        Inventory_Save(targetid);
        ShowPlayerInventory(targetid);
        ShowNotification(targetid, 3, 5, 0, 0, "Вы получили предмет в инвентарь", "");
    return 1;
}

CMD:addskin(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;
    new targetid, skinId;
    if(sscanf(params, "ui", targetid, skinId)) return SendClientMessage(playerid, -1, "Использование: /addskin [id] [id скина]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(skinId < 0 || skinId > 311) return SendClientMessage(playerid, -1, "Неверный ID скина (0-311)");
       new slot = Inventory_GetFreeSlot(targetid);
        Inventory_SetItem(targetid, slot, 134, skinId, "");
        Inventory_Save(targetid);
        new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
        ShowPlayerInventory(targetid);        
        ShowNotification(targetid, 3, 5, 0, 0, "Вы получили скин в инвентарь", "");
    return 1;
}

CMD:givesim(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;
    new targetid, number;
    if(sscanf(params, "ui", targetid, number)) return SendClientMessage(playerid, -1, "Использование: /givesim [id] [номер]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(number < 1000 || number > 999999999) return SendClientMessage(playerid, -1, "Номер от 1000 до 999999999");
    new slot = Inventory_GetFreeSlot(targetid);
    if(slot == -1) return SendClientMessage(playerid, -1, "У игрока нет свободных слотов");
    new plate[12];
    format(plate, sizeof(plate), "%d", number);
    Inventory_SetItem(targetid, slot, 58, number, plate);
    SetPlayerWeight(targetid, GetPlayerWeight(targetid) + GetItemWeight(58));
    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    ShowNotification(targetid, 3, 5, 0, 0, "Вы получили SIM-карту в инвентарь", "");
    return 1;
}

CMD:givenz(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;
    new targetid, number[8], region[4];
    if(sscanf(params, "us[8]s[3]", targetid, number, region)) return SendClientMessage(playerid, -1, "Использование: /givenz [id] [номер] [регион]");
    if(!IsPlayerConnected(targetid)) return 1;
    new slot = Inventory_GetFreeSlot(targetid);
    if(slot == -1) return SendClientMessage(playerid, -1, "У игрока нет свободных слотов");
    new plate_data[32];
    format(plate_data, sizeof(plate_data), "%s|%s", number, region);
    Inventory_SetItem(targetid, slot, 59, 1, plate_data);
    SetPlayerWeight(targetid, GetPlayerWeight(targetid) + GetItemWeight(59));
    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);
    
    ShowNotification(targetid, 3, 5, 0, 0, "Вы получили номерной знак в инвентарь", "");
    return 1;
}

stock InventoryUpdateExchangeStatus(playerid, type, status, money, m)
{
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "s", status);
    JSON_SetInt(JSONObject, "em", money);
    JSON_SetInt(JSONObject, "gm", m);   
    JSON_Cleanup(JSONObject);
}

stock ShowTradeDialog(playerid) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    new str[2048];
    new count = 0;
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(i == playerid) continue;
        
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(i, px, py, pz);
        
        new Float:dist = floatsqroot((px-x)*(px-x) + (py-y)*(py-y) + (pz-z)*(pz-z));
        
        if(dist <= 30.0)
        {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(i, name, sizeof(name));
            new buf[128];
            format(buf, sizeof(buf), "%s[%d] (%.0f)м.\n", name, i, dist);
            strcat(str, buf);
            count++;
        }
    }
    
    if(count == 0)
        return ShowNotification(playerid, 2, 6, 0, 0, "Ближайшие игроки не найдены", "ок");
    
    ShowPlayerDialog(playerid, 8543, DIALOG_STYLE_LIST, "{FFFF00}Ближайшие игроки", str, "Выбрать", "Закрыть");
    return 1;
}

stock ShowInventoryGUIForExchange(playerid, targetid)
{
        new Node:itemsArray = JSON_Array();
        new Node:activeSlotsArray = JSON_Array();
        
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
                new guiActiveSlot = Inventory_ToGuiActiveSlot(i, g_PlayerActiveSlots[playerid][i][inv_itemId]);
                activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Array(
                    JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemId]), 
                    JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemCount]), 
                    JSON_Int(guiActiveSlot), 
                    JSON_Int(0)
                ));
            }
        }
        
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        
        new Node:json = JSON_Object(
            "i", JSON_Int(1), 
            "nm", JSON_Int(5), 
            "n", JSON_String(name), 
            "lv", JSON_Int(GetPlayerLevel(playerid)), 
            "id", JSON_Int(playerid), 
            "v", JSON_Int(3), 
            "ps", JSON_Int(GetPlayerSkin(playerid)), 
            "m", JSON_Int(GetPlayerMoneyEx(playerid)), 
            "s", JSON_Int(79), 
            "sl", JSON_Int(MAX_INVENTORY_SLOTS), 
            "pn", JSON_Int(g_PlayerPhoneNumber[playerid]),
            "en", JSON_String(GetPlayerNameEx(targetid)),
            "it", itemsArray,             
            "ai", activeSlotsArray,
            "wi", JSON_Array()
        );
        KillTimer(TradeTimer[targetid]);
        TradeTimer[targetid] = 0;
        ClearTradeItems(playerid);
        ShowPlayerGUI(playerid, 33, json);
        SetPVarInt(playerid, "InTrade", 3);
        SetPVarInt(targetid, "InTrade", 3);
        SetPVarInt(playerid, "TradePID", targetid);

        moneyTradeP[playerid] = 0;
        moneyTradeT[playerid] = 0;
        moneyTradeP[targetid] = 0;
        moneyTradeT[targetid] = 0;
        tradeFlag[playerid] = 0; 
        tradeFlag[targetid] = 0;
        
        ShowNotification(targetid, 3, 6, 0, 0, "Вы начали трейд", "ок");
        ShowNotification(playerid, 3, 6, 0, 0, "Вы начали трейд", "ок");
        JSON_Cleanup(json);
        return 1;
}

stock Inventory_GetFreeSlot(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 0 && 
           g_PlayerInventory[playerid][i][inv_itemCount] == 0)
            return i;
    }
    return -1;
}

CMD:trunk(playerid, params[])
{
    ShowPlayerTrunkGUI(playerid, 1);
    return 1;
}

stock ShowPlayerTrunkGUI(playerid, status) { 
    new vehicleid = GetPlayerOwnableCar(playerid);

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        new Float: carX, Float: carY, Float: carZ;
        GetVehiclePos(vehicleid, carX, carY, carZ);
       
        new Float: playerX, Float: playerY, Float: playerZ;
        GetPlayerPos(playerid, playerX, playerY, playerZ);
        
        new Float: distance = floatsqroot(floatpower(playerX - carX, 2) + floatpower(playerY - carY, 2) + floatpower(playerZ - carZ, 2));       
        if(distance > 5.0)
        {
            SendClientMessage(playerid, -1, "Ваш транспорт слишком далеко от вас или он не загружен.");
            return 1;
        }
       
        new Float: carAngle;
        GetVehicleZAngle(vehicleid, carAngle);
       
        new Float: trunkX = carX - (2.5 * floatsin(-carAngle, degrees));
        new Float: trunkY = carY - (2.5 * floatcos(-carAngle, degrees));
       
        new Float: trunkDistance = floatsqroot(floatpower(playerX - trunkX, 2) + floatpower(playerY - trunkY, 2) + floatpower(playerZ - carZ, 2));
        
        if(trunkDistance > 2.5)
        {
            SendClientMessage(playerid, -1, "Вы должны быть возле багажника автомобиля!");
            return 1;
        }
        
        new Node:itemsArray = JSON_Array();
        new Node:bitemsArray = JSON_Array();
        new Node:activeSlotsArray = JSON_Array();
        
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
        
        for(new i = 0; i < MAX_TRUNK_SLOTS; i++) 
        {
            if(g_PlayerTrunkItems[playerid][i][inv_itemId] > 0) 
            {
                bitemsArray = JSON_Append(bitemsArray, JSON_Array(
                    JSON_Int(g_PlayerTrunkItems[playerid][i][inv_itemId]), 
                    JSON_Int(g_PlayerTrunkItems[playerid][i][inv_itemCount]), 
                    JSON_Int(i), 
                    JSON_Int(0)
                ));
            }
        }
        
        for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
        {
            if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
            {
                new guiActiveSlot = Inventory_ToGuiActiveSlot(i, g_PlayerActiveSlots[playerid][i][inv_itemId]);
                activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Array(
                    JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemId]), 
                    JSON_Int(g_PlayerActiveSlots[playerid][i][inv_itemCount]), 
                    JSON_Int(guiActiveSlot), 
                    JSON_Int(0)
                ));
            }
        }
        
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        
        new Node:json = JSON_Object(
            "o", JSON_Int(status), 
            "sb", JSON_Int(MAX_TRUNK_SLOTS), 
            "i", JSON_Int(0), 
            "n", JSON_String(name), 
            "lv", JSON_Int(GetPlayerLevel(playerid)), 
            "id", JSON_Int(playerid), 
            "v", JSON_Int(3), 
            "ps", JSON_Int(GetPlayerSkin(playerid)), 
            "m", JSON_Int(GetPlayerMoneyEx(playerid)), 
            "s", JSON_Int(79), 
            "sl", JSON_Int(MAX_INVENTORY_SLOTS), 
            "nm", JSON_Int(g_PlayerPhoneNumber[playerid]), 
            "en", JSON_String(""), 
            "it", itemsArray, 
            "ai", activeSlotsArray, 
            "ic", bitemsArray,
            "wi", JSON_Array()
        );
        
        OnPacketIncoming(playerid, 34, json);
        JSON_Cleanup(json);
        return 1;
    }
    else return SendClientMessage(playerid, -1, "Ваш транспорт не загружен на сервер");
}