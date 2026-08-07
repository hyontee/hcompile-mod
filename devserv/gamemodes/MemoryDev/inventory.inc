#if defined _inv_included
    #endinput
#endif
#define _inv_included

#include <a_samp>
#include <a_mysql>
#include "../include/json.inc"
#include "../include/Pawn.RakNet.inc"

#define db_handle mysql
#define pMoney P_MONEY
#define pID P_ACCOUNT_ID
#define pSkin P_SKIN
#define pAdminAuth P_ADMIN_LOGGED
#define pAdminLvl P_ADMIN
#define pExp P_EXP
#define pLevel P_LEVEL

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

#define INVENTORY_ACCESSORY_ITEM_BASE   (201)
#define INVENTORY_ACCESSORY_ITEM_LIMIT  (1200)

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

stock Inventory_Init()
{
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `player_inventory` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `player_id` INT NOT NULL, `slot` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL DEFAULT 0, `item_count` INT NOT NULL DEFAULT 0, `item_plate` VARCHAR(32) DEFAULT '', `is_active` TINYINT(1) NOT NULL DEFAULT 0, `active_slot` INT NOT NULL DEFAULT -1, KEY `player_id` (`player_id`), KEY `slot` (`slot`), KEY `active_slot` (`active_slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `player_accessories` (`id` INT AUTO_INCREMENT PRIMARY KEY, `account_id` INT NOT NULL, `active_slot` INT NOT NULL, `accessory_id` INT NOT NULL, `bone` INT NOT NULL, `x` FLOAT NOT NULL DEFAULT 0.0, `y` FLOAT NOT NULL DEFAULT 0.0, `z` FLOAT NOT NULL DEFAULT 0.0, `rx` FLOAT NOT NULL DEFAULT 0.0, `ry` FLOAT NOT NULL DEFAULT 0.0, `rz` FLOAT NOT NULL DEFAULT 0.0, `scale` FLOAT NOT NULL DEFAULT 1.0, UNIQUE KEY `unique_slot` (`account_id`, `active_slot`), KEY `account_id` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");
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
    g_PlayerWeight[playerid] = 0.0;
    g_PlayerPhoneNumber[playerid] = 0;
    g_PlayerMedChest[playerid] = 0;
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
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - GetItemWeight(itemId) * cnt);
    g_PlayerInventory[playerid][slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemType] = 0;
    g_PlayerInventory[playerid][slot][inv_itemWeight] = 0;
    return 1;
}
//������� by @shramip
//������� by @shramipshramip
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
    if(GetPlayerWeight(playerid) + weightAdd > GetPlayerMaxWeight(playerid)) return 0;
    Inventory_SetItem(playerid, slot, itemId, count, plate);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weightAdd);
    return 1;
}

stock Float:Inventory_GetItemTotalWeight(itemId, count)
{
    if(count <= 0) return 0.0;
    return GetItemWeight(itemId) * float(count);
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
    if(skinModel < 0 || skinModel > 311) return false;
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
    new skin = Player[playerid][pSkin];
    if(skin <= 0 || skin > 311) skin = GetPlayerSkin(playerid);
    if(skin <= 0 || skin > 311) skin = 1;

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemId] != 134)
    {
        Inventory_SetActiveItem(playerid, SLOT_SKIN, 134, skin, "");
        SetPlayerSkin(playerid, skin);
        Player[playerid][pSkin] = skin;
        return 1;
    }

    if(g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] <= 0 || g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] > 311)
    {
        g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount] = skin;
    }

    SetPlayerSkin(playerid, g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount]);
    Player[playerid][pSkin] = g_PlayerActiveSlots[playerid][SLOT_SKIN][inv_itemCount];
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
            ShowNotificationMemory(playerid, 2, 5, 0, 0, "��� ����� � ���������", "");
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
        ShowNotificationMemory(playerid, 1, 5, 0, 0, "�� ������ SIM-�����", "");
    }
    else if(itemId == 134)
    {
        new skinId = g_PlayerActiveSlots[playerid][targetSlot][inv_itemCount];
        SetPlayerSkin(playerid, skinId);
        Player[playerid][pSkin] = skinId;
        new query[128];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `skin` = %d WHERE `id` = %d LIMIT 1", skinId, Player[playerid][pID]);
        mysql_query(db_handle, query);
        ShowNotificationMemory(playerid, 1, 5, 0, 0, "�� ������ ����", "");
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
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + GetItemWeight(itemId));

    if(Inventory_IsAccessoryItem(itemId)) RemovePlayerAttachedObject(playerid, oldSlot);

    if(itemId == 58 && oldSlot == SLOT_SIM)
    {
        g_PlayerPhoneNumber[playerid] = 0;
        ShowNotificationMemory(playerid, 1, 5, 0, 0, "�� ����� SIM-�����", "");
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
        ShowNotificationMemory(playerid, 1, 5, 0, 0, "�� ������� SIM-�����", "");
    }

    Inventory_ClearActiveSlot(playerid, activeSlot);
    return 1;
}

stock Inventory_UseMedChest(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;
    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 22) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    else { usedSlot = Inventory_FindItemSlot(playerid, 22); if(usedSlot != -1) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0); }
    if(!removed) return false;
    new Float:hp; GetPlayerHealth(playerid, hp);
    hp += 60.0; if(hp > 100.0) hp = 100.0; SetPlayerHealth(playerid, hp);
    ShowNotificationMemory(playerid, 3, 6, 0, 0, "�� ������������ �������", "");
    ApplyAnimation(playerid, "PED", "gum_eat", 3.0, 0, 0, 0, 0, 0, 1);
    g_PlayerMedChest[playerid] = 0;
    return true;
}

stock Inventory_UseRepairKit(playerid, requestedSlot, &usedSlot)
{
    usedSlot = requestedSlot;
    new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0);
    if(vehicleid == INVALID_VEHICLE_ID) { ShowNotificationMemory(playerid, 2, 6, 0, 0, "��������� ����� � ����������", ""); return false; }
    new bool:removed = false;
    if(usedSlot >= 0 && usedSlot < MAX_INVENTORY_SLOTS && g_PlayerInventory[playerid][usedSlot][inv_itemId] == 23) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0);
    else { usedSlot = Inventory_FindItemSlot(playerid, 23); if(usedSlot != -1) removed = (Inventory_RemoveOneItem(playerid, usedSlot) != 0); }
    if(!removed) return false;
    SetVehicleHealth(vehicleid, 1000.0);
    RepairVehicle(vehicleid);
    ShowNotificationMemory(playerid, 3, 6, 0, 0, "��������� �������", "");
    return true;
}

//������� by @shramip
//������� by ���� �����

stock bool:Inventory_UseSkinFromSlot(playerid, slot, &newSkinModel)
{
    newSkinModel = 0;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    if(g_PlayerInventory[playerid][slot][inv_itemId] != 134) return false;

    new targetSkin = g_PlayerInventory[playerid][slot][inv_itemCount];
    if(targetSkin <= 0 || targetSkin > 311) return false;

    new oldSkin = Player[playerid][pSkin];
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
    Player[playerid][pSkin] = targetSkin;
    newSkinModel = targetSkin;

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `skin` = %d WHERE `id` = %d LIMIT 1", targetSkin, Player[playerid][pID]);
    mysql_query(db_handle, query);

    ShowNotificationMemory(playerid, 1, 5, 0, 0, "�� �����������", "");
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
        else ShowNotificationMemory(playerid, 2, 5, 0, 0, "��� ����� ��� ������ SIM-�����", "");
    }
    Inventory_SetActiveItem(playerid, SLOT_SIM, 58, usedCount, usedPlate);
    new phone = strval(usedPlate); if(phone <= 0) phone = usedCount;
    g_PlayerPhoneNumber[playerid] = phone;
    ShowNotificationMemory(playerid, 1, 5, 0, 0, "�� ������������ SIM-�����", "");
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
                    Player[playerid][pSkin] = count;
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
    Accessory_OnInventoryLoaded(playerid);
    Inventory_Save(playerid);
    return 1;
}

stock Inventory_Load(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;
    new q[256];
    mysql_format(db_handle, q, sizeof(q), "SELECT `slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot` FROM `player_inventory` WHERE `player_id` = %d", Player[playerid][pID]);
    mysql_tquery(db_handle, q, "OnInventoryLoad", "d", playerid);
    Accessory_LoadAllFromDB(playerid);
    return 1;
}

stock Inventory_Save(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;
    new q[256];
    mysql_format(db_handle, q, sizeof(q), "DELETE FROM `player_inventory` WHERE `player_id` = %d", Player[playerid][pID]);
    mysql_query(db_handle, q);
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            mysql_format(db_handle, q, sizeof(q), "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,%d,%d,'%e',0,-1)", Player[playerid][pID], i, g_PlayerInventory[playerid][i][inv_itemId], g_PlayerInventory[playerid][i][inv_itemCount], g_PlayerInventory[playerid][i][inv_itemPlate]);
            mysql_query(db_handle, q);
        }
    }
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            mysql_format(db_handle, q, sizeof(q), "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,%d,%d,'%e',1,%d)", Player[playerid][pID], i, g_PlayerActiveSlots[playerid][i][inv_itemId], g_PlayerActiveSlots[playerid][i][inv_itemCount], g_PlayerActiveSlots[playerid][i][inv_itemPlate], i);
            mysql_query(db_handle, q);
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
    new Node:json = JSON_Object("o", JSON_Int(1), "i", JSON_Int(0), "n", JSON_String(Player[playerid][P_NAME]), "lv", JSON_Int(Player[playerid][pLevel]), "id", JSON_Int(playerid), "v", JSON_Int(3), "ps", JSON_Int(Player[playerid][pSkin]), "m", JSON_Int(Player[playerid][pMoney]), "s", JSON_Int(79), "w", JSON_Float(GetPlayerWeight(playerid)), "mw", JSON_Float(GetPlayerMaxWeight(playerid)), "sl", JSON_Int(MAX_INVENTORY_SLOTS), "nm", JSON_Int(g_PlayerPhoneNumber[playerid]), "en", JSON_String(""), "it", itemsArray, "ai", activeSlotsArray, "wi", JSON_Array());
    OnPacketIncoming(playerid, 33, json);
    JSON_Cleanup(json);
    return 1;
}

stock bool:Inventory_HandlePacket(playerid, Node:JSONObject)
{
    new Node:response = JSON_Object();
    new type; JSON_GetInt(JSONObject, "t", type);
    new itemId = 0, pos = -1, oldPos = -1, count = 0;
    new bool:ok = false;
    switch(type)
    {
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
                ok = Accessory_UseFromInventory(playerid, pos);
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

CMD:giveitem(playerid, params[])
{
    new targetid, itemId, count = 1;
    if(sscanf(params, "uiD(1)", targetid, itemId, count)) return SendClientMessage(playerid, -1, "�������������: /giveitem [id] [item_id] [���-��]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(Inventory_AddItem(targetid, itemId, count))
    {
        Inventory_Save(targetid);
        ShowPlayerInventory(targetid);
        new msg[128];
        format(msg, sizeof(msg), "�� ������ ������� %d x%d ������ %s", itemId, count, Player[targetid][P_NAME]);
        SendClientMessage(playerid, -1, msg);
        ShowNotificationMemory(targetid, 1, 5, 0, 0, "�� �������� ������� � ���������", "");
    }
    else SendClientMessage(playerid, -1, "�� ������� ������ �������");
    return 1;
}

CMD:addskin(playerid, params[])
{
    new targetid, skinId;
    if(sscanf(params, "ui", targetid, skinId)) return SendClientMessage(playerid, -1, "�������������: /addskin [id] [id �����]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(skinId < 0 || skinId > 311) return SendClientMessage(playerid, -1, "�������� ID ����� (0-311)");
    if(Inventory_AddSkinItem(targetid, skinId))
    {
        Inventory_Save(targetid);
        ShowPlayerInventory(targetid);
        new msg[128];
        format(msg, sizeof(msg), "�� ������ ���� %d ������ %s", skinId, Player[targetid][P_NAME]);
        SendClientMessage(playerid, -1, msg);
        ShowNotificationMemory(targetid, 1, 5, 0, 0, "�� �������� ���� � ���������", "");
    }
    else SendClientMessage(playerid, -1, "�� ������� ������ ���� (���� ����� ��� �������)");
    return 1;
}

CMD:givesim(playerid, params[])
{
    new targetid, number;
    if(sscanf(params, "ui", targetid, number)) return SendClientMessage(playerid, -1, "�������������: /givesim [id] [�����]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(number < 1000 || number > 999999999) return SendClientMessage(playerid, -1, "����� �� 1000 �� 999999999");
    new slot = Inventory_GetFreeSlot(targetid);
    if(slot == -1) return SendClientMessage(playerid, -1, "� ������ ��� ��������� ������");
    new plate[12];
    format(plate, sizeof(plate), "%d", number);
    Inventory_SetItem(targetid, slot, 58, number, plate);
    SetPlayerWeight(targetid, GetPlayerWeight(targetid) + GetItemWeight(58));
    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);
    new msg[128];
    format(msg, sizeof(msg), "�� ������ SIM-����� � ������� %d ������ %s", number, Player[targetid][P_NAME]);
    SendClientMessage(playerid, -1, msg);
    ShowNotificationMemory(targetid, 1, 5, 0, 0, "�� �������� SIM-����� � ���������", "");
    return 1;
}

CMD:givenz(playerid, params[])
{
    new targetid, number[8], region[4];
    if(sscanf(params, "us[8]s[3]", targetid, number, region)) return SendClientMessage(playerid, -1, "�������������: /givenz [id] [�����] [������]");
    if(!IsPlayerConnected(targetid)) return 1;
    new slot = Inventory_GetFreeSlot(targetid);
    if(slot == -1) return SendClientMessage(playerid, -1, "� ������ ��� ��������� ������");
    new plate_data[32];
    format(plate_data, sizeof(plate_data), "%s|%s", number, region);
    Inventory_SetItem(targetid, slot, 59, 1, plate_data);
    SetPlayerWeight(targetid, GetPlayerWeight(targetid) + GetItemWeight(59));
    Inventory_Save(targetid);
    ShowPlayerInventory(targetid);
    new msg[128];
    format(msg, sizeof(msg), "�� ������ �������� ���� '%s %s' ������ %s", number, region, Player[targetid][P_NAME]);
    SendClientMessage(playerid, -1, msg);
    ShowNotificationMemory(targetid, 1, 5, 0, 0, "�� �������� �������� ���� � ���������", "");
    return 1;
}

//������� by @shramip
//������� by @shramip
//������� by @shramip
//������� by @shramip
//������� by @shramip

stock GivePlayerItem(playerid, itemid, count) { return Inventory_AddItem(playerid, itemid, count); }
stock GivePlayerSkin(playerid, skinid) { return Inventory_AddSkinItem(playerid, skinid); }