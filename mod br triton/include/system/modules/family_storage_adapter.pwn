#if defined _INC_FAMILY_STORAGE_ADAPTER
    #endinput
#endif
#define _INC_FAMILY_STORAGE_ADAPTER

#define FAM_DIALOG_STORAGE_MAIN             (22940)
#define FAM_DIALOG_STORAGE_SAFE             (22942)
#define FAM_DIALOG_STORAGE_SAFE_TAKE        (22943)
#define FAM_DIALOG_STORAGE_SAFE_PUT         (22944)
#define FAM_DIALOG_STORAGE_SAFE_MONEY       (22945)
#define FAM_DIALOG_STORAGE_SAFE_AMMO        (22946)
#define FAM_DIALOG_STORAGE_SAFE_WEAPON      (22947)
#define FAM_DIALOG_STORAGE_SAFE_ARMOUR      (22948)
#define FAM_DIALOG_STORAGE_SAFE_AMMO_INPUT  (22949)

#define FAMILY_SAFE_ACTION_TAKE             (1)
#define FAMILY_SAFE_ACTION_PUT              (2)

#define FAMILY_WAREHOUSE_MAX_SLOTS          (60)
#define FAMILY_WAREHOUSE_MAX_WEIGHT_KG      (1500)
#define FAMILY_SAFE_MAX_MONEY_AMOUNT        (1000000)

#define PVAR_FAMILY_SAFE_MONEY_ACTION       "family_safe_money_action"
#define PVAR_FAMILY_SAFE_AMMO_ACTION        "family_safe_ammo_action"
#define PVAR_FAMILY_SAFE_WEAPON_INDEX       "family_safe_weapon_index"

#define PVAR_FAMILY_WAREHOUSE_GUI           "family_warehouse_gui"
#define PVAR_FAMILY_WAREHOUSE_ID            "family_warehouse_id"

enum E_FAMILY_WAREHOUSE_SLOT
{
    FWS_SQL_ID,
    FWS_ITEM_ID,
    FWS_ITEM_AMOUNT,
    FWS_ITEM_VALUE
};

new g_family_warehouse[MAX_FAM][FAMILY_WAREHOUSE_MAX_SLOTS][E_FAMILY_WAREHOUSE_SLOT];
new g_family_warehouse_item_value[MAX_FAM][FAMILY_WAREHOUSE_MAX_SLOTS];

#define GetFamilyWarehouseData(%0,%1,%2)   g_family_warehouse[%0][%1][%2]
#define SetFamilyWarehouseData(%0,%1,%2,%3) g_family_warehouse[%0][%1][%2] = %3
#define AddFamilyWarehouseData(%0,%1,%2,%3,%4) g_family_warehouse[%0][%1][%2] %3= %4
#define IsFamilyWarehouseFreeSlot(%0,%1)   !GetFamilyWarehouseData(%0, %1, FWS_SQL_ID)

stock FamilyStorageResetState(playerid)
{
    DeletePVar(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION);
    DeletePVar(playerid, PVAR_FAMILY_SAFE_AMMO_ACTION);
    DeletePVar(playerid, PVAR_FAMILY_SAFE_WEAPON_INDEX);
    return 1;
}

stock FamilyStorageResetWarehouseGui(playerid)
{
    DeletePVar(playerid, PVAR_FAMILY_WAREHOUSE_GUI);
    DeletePVar(playerid, PVAR_FAMILY_WAREHOUSE_ID);
    return 1;
}

stock FamilyStorageIsWarehouseGui(playerid)
{
    return GetPVarInt(playerid, PVAR_FAMILY_WAREHOUSE_GUI) == 1;
}

stock FamilyStorageGetWarehouseFamilyId(playerid)
{
    return GetPVarInt(playerid, PVAR_FAMILY_WAREHOUSE_ID);
}

stock FamilyStorageShowAccessDenied(playerid)
{
    return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
}

stock FamilyStorageShowClosed(playerid)
{
    return ShowNotificationNew(playerid, 2, 6, 0, 0, " ", " ");
}

stock FamilyStorageClampLevel(level)
{
    if(level < 1) return 1;
    if(level > 7) return 7;
    return level;
}

stock FamilyStorageIsValidFamilyId(family_id)
{
    return (family_id >= 0 && family_id < MAX_FAM && GetFamily(family_id, family_database) != -1);
}

stock FamilyStorageGetRankName(playerid, dest[], size)
{
    new family_id = GetPlayerIdFamily(playerid);
    new rank = GetPlayerRangFamily(playerid);

    if(FamilyStorageIsValidFamilyId(family_id) && rank >= 1 && rank <= 5)
        format(dest, size, "%s", family_rang_name[family_id][rank - 1]);
    else
        format(dest, size, "%d ", rank);

    return 1;
}

stock FamilyStorageBuildChatText(playerid, action_text[], dest[], size)
{
    new family_id = GetPlayerIdFamily(playerid);
    new rank_name[24];

    FamilyStorageGetRankName(playerid, rank_name, sizeof(rank_name));
    format(dest, size, "%s %s[%d] %s", rank_name, GetPlayerNameEx(playerid), playerid, action_text);
    return 1;
}

stock FamilyStorageGetWarehouseSqlId(family_id)
{
    if(!FamilyStorageIsValidFamilyId(family_id))
        return -1;

    return GetFamily(family_id, family_database);
}

stock FamilyStorageGetPlatePseudoSlot(family_id, slot)
{
    new family_sql_id = FamilyStorageGetWarehouseSqlId(family_id);

    if(family_sql_id <= 0 || slot < 0 || slot >= FAMILY_WAREHOUSE_MAX_SLOTS)
        return -1;

    return 300000000 + (family_sql_id * 100) + slot;
}

stock FamilyStorageSetWarehouseSlotValue(family_id, slot, value)
{
    g_family_warehouse_item_value[family_id][slot] = value;
    return 1;
}

stock FamilyStorageGetWarehouseSlotValue(family_id, slot)
{
    return g_family_warehouse_item_value[family_id][slot];
}

stock FamilyStorageClearWarehouseCache(family_id)
{
    for(new slot = 0; slot < FAMILY_WAREHOUSE_MAX_SLOTS; slot++)
    {
        SetFamilyWarehouseData(family_id, slot, FWS_SQL_ID, 0);
        SetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID, 0);
        SetFamilyWarehouseData(family_id, slot, FWS_ITEM_AMOUNT, 0);
        SetFamilyWarehouseData(family_id, slot, FWS_ITEM_VALUE, 0);
        FamilyStorageSetWarehouseSlotValue(family_id, slot, 0);
    }
    return 1;
}

stock FamilyStorageRemoveWarehouseItem(family_id, slot)
{
    if(!FamilyStorageIsValidFamilyId(family_id) || slot < 0 || slot >= FAMILY_WAREHOUSE_MAX_SLOTS)
        return 0;

    SetFamilyWarehouseData(family_id, slot, FWS_SQL_ID, 0);
    SetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID, 0);
    SetFamilyWarehouseData(family_id, slot, FWS_ITEM_AMOUNT, 0);
    SetFamilyWarehouseData(family_id, slot, FWS_ITEM_VALUE, 0);
    FamilyStorageSetWarehouseSlotValue(family_id, slot, 0);
    return 1;
}

stock bool:FamilyStorageIsWarehouseAllowedItem(item_id)
{
    if(item_id == 22 || item_id == 58 || item_id == 134)
        return true;

    if(Inventory11_IsAccessoryItem(item_id) || Inventory11_IsPlateItem(item_id))
        return true;

    return false;
}

stock bool:FamilyStorageIsStackableItem(item_id)
{
    return (item_id == 22);
}

stock FamilyStorageFindBusySlot(family_id, item_id)
{
    for(new slot = 0; slot < FAMILY_WAREHOUSE_MAX_SLOTS; slot++)
    {
        if(IsFamilyWarehouseFreeSlot(family_id, slot))
            continue;

        if(GetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID) == item_id)
            return slot;
    }
    return -1;
}

stock FamilyStorageLoadWarehouse(playerid, family_id)
{
    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    new family_sql_id = FamilyStorageGetWarehouseSqlId(family_id);
    if(family_sql_id <= 0)
        return 0;

    FamilyStorageClearWarehouseCache(family_id);

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT slot, item_id, amount, value FROM family_storage_items WHERE family_id = %d ORDER BY slot ASC", family_sql_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[FAMILY_STORAGE][ERROR] load failed: player=%d family=%d sql=%d errno=%d query=%s", playerid, family_id, family_sql_id, mysql_errno(), query);
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        if(slot < 0 || slot >= FAMILY_WAREHOUSE_MAX_SLOTS)
            continue;

        new item_id = cache_get_field_content_int(i, "item_id");
        new amount = cache_get_field_content_int(i, "amount");
        new value = cache_get_field_content_int(i, "value");

        if(!FamilyStorageIsWarehouseAllowedItem(item_id))
            continue;

        if(amount <= 0)
            amount = 1;

        SetFamilyWarehouseData(family_id, slot, FWS_SQL_ID, 1);
        SetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID, item_id);
        SetFamilyWarehouseData(family_id, slot, FWS_ITEM_AMOUNT, amount);
        SetFamilyWarehouseData(family_id, slot, FWS_ITEM_VALUE, value);
        FamilyStorageSetWarehouseSlotValue(family_id, slot, value);
    }

    cache_delete(result);
    return 1;
}

stock bool:FamilyStorageSaveWarehouseSlot(playerid, family_id, slot)
{
    if(!FamilyStorageIsValidFamilyId(family_id) || slot < 0 || slot >= FAMILY_WAREHOUSE_MAX_SLOTS)
        return false;

    new family_sql_id = FamilyStorageGetWarehouseSqlId(family_id);
    if(family_sql_id <= 0)
        return false;

    new plate_pseudo_slot = FamilyStorageGetPlatePseudoSlot(family_id, slot);
    new query[320];

    if(IsFamilyWarehouseFreeSlot(family_id, slot))
    {
        mysql_format(mysql, query, sizeof(query), "DELETE FROM family_storage_items WHERE family_id = %d AND slot = %d", family_sql_id, slot);
        mysql_query(mysql, query, true);

        if(mysql_errno())
        {
            printf("[FAMILY_STORAGE][ERROR] delete failed: player=%d family=%d slot=%d errno=%d query=%s", playerid, family_id, slot, mysql_errno(), query);
            return false;
        }

        if(plate_pseudo_slot > 0)
            Inventory11_DeletePlateData(playerid, plate_pseudo_slot);

        return true;
    }

    new item_id = GetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID);
    new amount = GetFamilyWarehouseData(family_id, slot, FWS_ITEM_AMOUNT);
    new value = FamilyStorageGetWarehouseSlotValue(family_id, slot);

    if(amount <= 0)
        amount = 1;

    if(!Inventory11_IsPlateItem(item_id) && plate_pseudo_slot > 0)
        Inventory11_DeletePlateData(playerid, plate_pseudo_slot);

    mysql_format
    (
        mysql,
        query,
        sizeof(query),
        "INSERT INTO family_storage_items (family_id, slot, item_id, amount, value) VALUES (%d, %d, %d, %d, %d) ON DUPLICATE KEY UPDATE item_id = VALUES(item_id), amount = VALUES(amount), value = VALUES(value)",
        family_sql_id,
        slot,
        item_id,
        amount,
        value
    );
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[FAMILY_STORAGE][ERROR] upsert failed: player=%d family=%d slot=%d errno=%d query=%s", playerid, family_id, slot, mysql_errno(), query);
        return false;
    }

    return true;
}

stock FamilyStorageWhWeightX10(family_id)
{
    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    new total_weight_x10 = 0;

    for(new slot = 0; slot < FAMILY_WAREHOUSE_MAX_SLOTS; slot++)
    {
        if(IsFamilyWarehouseFreeSlot(family_id, slot))
            continue;

        new item_id = GetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID);
        new amount = GetFamilyWarehouseData(family_id, slot, FWS_ITEM_AMOUNT);

        if(amount <= 0)
            amount = 1;

        new item_weight_x10 = InventoryCfg_GetItemWeightX10(item_id);
        if(item_weight_x10 <= 0)
            item_weight_x10 = 10;

        if(FamilyStorageIsStackableItem(item_id))
            total_weight_x10 += item_weight_x10 * amount;
        else
            total_weight_x10 += item_weight_x10;
    }

    return total_weight_x10;
}

stock FamilyStorageWhWeightKg(family_id)
{
    return (FamilyStorageWhWeightX10(family_id) + 9) / 10;
}

stock FamilyStorageBuildWarehouseJson(playerid, family_id, out_json[], out_size)
{
    format(out_json, out_size, "[");

    new loaded = 0;

    for(new slot = 0; slot < FAMILY_WAREHOUSE_MAX_SLOTS; slot++)
    {
        if(IsFamilyWarehouseFreeSlot(family_id, slot))
            continue;

        new item_id = GetFamilyWarehouseData(family_id, slot, FWS_ITEM_ID);
        new amount = GetFamilyWarehouseData(family_id, slot, FWS_ITEM_AMOUNT);
        new value = FamilyStorageGetWarehouseSlotValue(family_id, slot);

        if(amount <= 0 || !FamilyStorageIsWarehouseAllowedItem(item_id))
            continue;

        new model_id = TrunkTest_GetDisplayModelForTrunkItem(item_id, amount, value);
        new extra_1 = 0;
        new extra_2 = 0;

        if(Inventory11_IsPlateItem(item_id))
        {
            new plate_slot_key = FamilyStorageGetPlatePseudoSlot(family_id, slot);
            new plate_type = PlateCountryToType(PlateItemIdToCountry(item_id));
            new plate[16], region[8], plate_text[32];

            if(plate_slot_key > 0 && Inventory11_GetPlateData(playerid, plate_slot_key, plate_type, plate, sizeof(plate), region, sizeof(region)))
            {
                Inv11Trade_BuildPlateText(plate_type, plate, region, plate_text, sizeof(plate_text));
                Inventory11_AppendPlateItemToJson(out_json, out_size, PlateTypeToItemId(plate_type), plate_text, slot);
                loaded++;
                continue;
            }
        }

        if(Inventory11_IsAccessoryItem(item_id))
        {
            extra_1 = (value > 0) ? value : Inv11_GetAccModelByItem(item_id);
            if(extra_1 <= 0) extra_1 = item_id;
            model_id = 1;
        }
        else if(item_id == 58)
        {
            extra_1 = (value > 0) ? value : model_id;
        }

        Inventory11_AppendItemToJson(out_json, out_size, item_id, model_id, slot, extra_1, extra_2);
        loaded++;
    }

    new len = strlen(out_json);
    if(len > 1 && out_json[len - 1] == ',')
        out_json[len - 1] = '\0';

    strcat(out_json, "]", out_size);
    return loaded;
}

stock FamilyStorageOpenWarehouseGui(playerid)
{
    new family_id = GetPlayerIdFamily(playerid);

    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    if(GetPlayerRangFamily(playerid) != 5)
        return FamilyStorageShowAccessDenied(playerid);

    if(!FamilyStorageLoadWarehouse(playerid, family_id))
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "    ", " ");

    new Node:JSONObject = JSON_Object();
    new it_json[8192];
    new ic_json[4096];

    TrunkTest_BuildInventoryJson(playerid, it_json, sizeof(it_json));
    FamilyStorageBuildWarehouseJson(playerid, family_id, ic_json, sizeof(ic_json));

    new Node:itArray = JSON_Array();
    JSON_Parse(it_json, itArray);
    JSON_SetArray(JSONObject, "it", itArray);

    new Node:icArray = JSON_Array();
    JSON_Parse(ic_json, icArray);
    JSON_SetArray(JSONObject, "ic", icArray);

    JSON_SetInt(JSONObject, "tb", 2);
    JSON_SetInt(JSONObject, "w", Inventory11_GetCurrentWeightKg(playerid));
    JSON_SetInt(JSONObject, "mw", Inventory11_GetMaxWeightKg(playerid));
    JSON_SetInt(JSONObject, "bw", FamilyStorageWhWeightKg(family_id));
    JSON_SetInt(JSONObject, "cw", FAMILY_WAREHOUSE_MAX_WEIGHT_KG);
    JSON_SetInt(JSONObject, "sl", Inventory11_GetMaxSlots(playerid));
    JSON_SetInt(JSONObject, "sb", FAMILY_WAREHOUSE_MAX_SLOTS);
    JSON_SetInt(JSONObject, "nm", GetPlayerPhone(playerid));

    Inventory11_SetAiArrayOnJson(playerid, JSONObject);

    SetPVarInt(playerid, PVAR_FAMILY_WAREHOUSE_GUI, 1);
    SetPVarInt(playerid, PVAR_FAMILY_WAREHOUSE_ID, family_id);

    DeletePVar(playerid, PVAR_TRUNKTEST_VEHICLE);
    ShowPlayerGUI(playerid, GUICarsTrunkOrCloset, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

stock bool:FamilyStorageMoveInventoryToWarehouse(playerid, family_id, req_item_id, old_slot, new_slot, req_value)
{
    if(new_slot < 0 || new_slot >= FAMILY_WAREHOUSE_MAX_SLOTS)
        return false;

    if(!FamilyStorageLoadWarehouse(playerid, family_id))
        return false;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
        return false;

    new query[320];
    mysql_format(mysql, query, sizeof(query), "SELECT item_id, model_id, amount, extra_1, extra_2, old_skin FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, old_slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[FAMILY_STORAGE][ERROR] inv->storage select failed: player=%d slot=%d errno=%d query=%s", playerid, old_slot, mysql_errno(), query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows() <= 0)
    {
        cache_delete(result);
        return false;
    }

    new item_id = cache_get_field_content_int(0, "item_id");
    new model_id = cache_get_field_content_int(0, "model_id");
    new amount = cache_get_field_content_int(0, "amount");
    new extra_1 = cache_get_field_content_int(0, "extra_1");
    new extra_2 = cache_get_field_content_int(0, "extra_2");
    new old_skin = cache_get_field_content_int(0, "old_skin");
    cache_delete(result);

    if(req_item_id > 0 && req_item_id != item_id)
        printf("[FAMILY_STORAGE][WARN] inv->storage item mismatch: player=%d req=%d db=%d slot=%d", playerid, req_item_id, item_id, old_slot);

    if(!FamilyStorageIsWarehouseAllowedItem(item_id))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "      ", " ");
        return false;
    }

    if(amount <= 0)
        amount = 1;

    new bool:is_stackable = FamilyStorageIsStackableItem(item_id);
    new move_amount = req_value;

    if(!is_stackable)
    {
        move_amount = 1;
    }
    else
    {
        if(move_amount <= 0) move_amount = 1;
        if(move_amount > amount) move_amount = amount;
        if(move_amount <= 0) return false;
    }

    new item_weight_x10 = InventoryCfg_GetItemWeightX10(item_id);
    if(item_weight_x10 <= 0) item_weight_x10 = 10;

    new add_weight_x10 = item_weight_x10 * (is_stackable ? move_amount : 1);
    if(FamilyStorageWhWeightX10(family_id) + add_weight_x10 > (FAMILY_WAREHOUSE_MAX_WEIGHT_KG * 10))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "    ", " ");
        return false;
    }

    new item_value = TrunkTest_GetItemValueFromInventoryData(item_id, model_id, amount, extra_1, old_skin);
    new target_slot = new_slot;

    new storage_plate_slot = -1;
    new storage_plate_type = TYPE_RU;
    new storage_plate[16], storage_region[8];
    storage_plate[0] = '\0';
    storage_region[0] = '\0';
    new bool:has_storage_plate = false;

    if(Inventory11_IsPlateItem(item_id))
    {
        storage_plate_slot = FamilyStorageGetPlatePseudoSlot(family_id, target_slot);
        has_storage_plate = Inventory11_GetPlateData(playerid, old_slot, storage_plate_type, storage_plate, sizeof(storage_plate), storage_region, sizeof(storage_region));
    }

    if(is_stackable)
    {
        new busy_slot = FamilyStorageFindBusySlot(family_id, item_id);

        if(busy_slot != -1 && busy_slot != new_slot)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
            return false;
        }

        if(busy_slot == -1 && !IsFamilyWarehouseFreeSlot(family_id, new_slot))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
            return false;
        }

        if(busy_slot != -1)
        {
            target_slot = busy_slot;
            AddFamilyWarehouseData(family_id, target_slot, FWS_ITEM_AMOUNT, +, move_amount);

            if(FamilyStorageGetWarehouseSlotValue(family_id, target_slot) <= 0 && item_value > 0)
            {
                FamilyStorageSetWarehouseSlotValue(family_id, target_slot, item_value);
                SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_VALUE, item_value);
            }
        }
        else
        {
            SetFamilyWarehouseData(family_id, target_slot, FWS_SQL_ID, 1);
            SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_ID, item_id);
            SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_AMOUNT, move_amount);
            SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_VALUE, item_value);
            FamilyStorageSetWarehouseSlotValue(family_id, target_slot, item_value);
        }
    }
    else
    {
        if(!IsFamilyWarehouseFreeSlot(family_id, target_slot))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
            return false;
        }

        SetFamilyWarehouseData(family_id, target_slot, FWS_SQL_ID, 1);
        SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_ID, item_id);
        SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_AMOUNT, 1);
        SetFamilyWarehouseData(family_id, target_slot, FWS_ITEM_VALUE, item_value);
        FamilyStorageSetWarehouseSlotValue(family_id, target_slot, item_value);
    }

    if(!FamilyStorageSaveWarehouseSlot(playerid, family_id, target_slot))
        return false;

    if(Inventory11_IsPlateItem(item_id) && storage_plate_slot > 0 && has_storage_plate)
    {
        if(!Inventory11_SavePlateData(playerid, storage_plate_slot, storage_plate_type, storage_plate, storage_region))
        {
            printf("[FAMILY_STORAGE][ERROR] inv->storage save plate failed: player=%d family=%d slot=%d", playerid, family_id, target_slot);
            return false;
        }
    }

    if(is_stackable && amount > move_amount)
    {
        new left_amount = amount - move_amount;
        if(left_amount < 1) left_amount = 1;

        mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET amount = %d, model_id = %d WHERE account_id = %d AND slot = %d LIMIT 1", left_amount, left_amount, account_id, old_slot);
        mysql_query(mysql, query, true);

        if(mysql_errno())
        {
            printf("[FAMILY_STORAGE][ERROR] inv->storage update inventory amount failed: player=%d slot=%d errno=%d query=%s", playerid, old_slot, mysql_errno(), query);
            return false;
        }
    }
    else if(!Inventory11_DeleteSlotFromDatabase(playerid, old_slot))
    {
        printf("[FAMILY_STORAGE][ERROR] inv->storage delete inventory slot failed: player=%d slot=%d", playerid, old_slot);
        return false;
    }

    return true;
}

stock bool:FamilyStorageMoveWarehouseToInventory(playerid, family_id, old_slot, new_slot, req_item_id, req_value)
{
    if(old_slot < 0 || old_slot >= FAMILY_WAREHOUSE_MAX_SLOTS)
        return false;

    if(new_slot < 1 || new_slot > Inventory11_GetMaxSlots(playerid))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
        return false;
    }

    if(!FamilyStorageLoadWarehouse(playerid, family_id))
        return false;

    if(IsFamilyWarehouseFreeSlot(family_id, old_slot))
        return false;

    if(TrunkTest_IsInventorySlotBusy(playerid, new_slot))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "    ", " ");
        return false;
    }

    new item_id = GetFamilyWarehouseData(family_id, old_slot, FWS_ITEM_ID);
    if(!FamilyStorageIsWarehouseAllowedItem(item_id))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "      ", " ");
        return false;
    }

    if(req_item_id > 0 && req_item_id != item_id)
        printf("[FAMILY_STORAGE][WARN] storage->inv item mismatch: player=%d req=%d db=%d slot=%d", playerid, req_item_id, item_id, old_slot);

    new amount = GetFamilyWarehouseData(family_id, old_slot, FWS_ITEM_AMOUNT);
    if(amount <= 0)
        return false;

    new bool:is_stackable = FamilyStorageIsStackableItem(item_id);
    new move_amount = req_value;

    if(!is_stackable)
    {
        move_amount = 1;
    }
    else
    {
        if(move_amount <= 0) move_amount = 1;
        if(move_amount > amount) move_amount = amount;
        if(move_amount <= 0) return false;
    }

    new item_value = FamilyStorageGetWarehouseSlotValue(family_id, old_slot);
    if(item_value <= 0)
        item_value = GetFamilyWarehouseData(family_id, old_slot, FWS_ITEM_VALUE);

    new storage_plate_slot = -1;
    new storage_plate_type = TYPE_RU;
    new storage_plate[16], storage_region[8];
    storage_plate[0] = '\0';
    storage_region[0] = '\0';
    new bool:has_storage_plate = false;

    if(Inventory11_IsPlateItem(item_id))
    {
        storage_plate_slot = FamilyStorageGetPlatePseudoSlot(family_id, old_slot);
        if(storage_plate_slot > 0)
            has_storage_plate = Inventory11_GetPlateData(playerid, storage_plate_slot, storage_plate_type, storage_plate, sizeof(storage_plate), storage_region, sizeof(storage_region));
    }

    new model_id = TrunkTest_GetDisplayModelForTrunkItem(item_id, move_amount, item_value);
    new extra_1 = 0;
    new old_skin = 0;

    if(Inventory11_IsAccessoryItem(item_id))
    {
        extra_1 = (item_value > 0) ? item_value : Inv11_GetAccModelByItem(item_id);
        if(extra_1 <= 0) extra_1 = item_id;
        model_id = 1;
        move_amount = 1;
    }
    else if(item_id == 58)
    {
        model_id = (item_value > 0) ? item_value : model_id;
        if(model_id <= 0) model_id = 1;
        extra_1 = model_id;
        move_amount = 1;
    }
    else if(item_id == 134)
    {
        old_skin = (item_value > 0) ? item_value : model_id;
        if(old_skin <= 0) old_skin = model_id;
        if(model_id <= 0) model_id = old_skin;
        move_amount = 1;
    }
    else if(Inventory11_IsPlateItem(item_id))
    {
        if(model_id <= 0) model_id = PlateItemIdToModel(item_id);
        move_amount = 1;
    }

    if(!Inventory11_CanAddItemWeight(playerid, item_id, move_amount))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
        return false;
    }

    if(!TrunkTest_InsertInventoryItemAtSlot(playerid, new_slot, item_id, model_id, move_amount, extra_1, 0, old_skin))
        return false;

    if(Inventory11_IsPlateItem(item_id) && has_storage_plate)
    {
        if(!Inventory11_SavePlateData(playerid, new_slot, storage_plate_type, storage_plate, storage_region))
        {
            printf("[FAMILY_STORAGE][ERROR] storage->inv save plate failed: player=%d family=%d slot=%d", playerid, family_id, old_slot);
            return false;
        }
    }

    new left_amount = amount - move_amount;
    if(left_amount <= 0)
    {
        FamilyStorageRemoveWarehouseItem(family_id, old_slot);

        if(Inventory11_IsPlateItem(item_id) && storage_plate_slot > 0)
            Inventory11_DeletePlateData(playerid, storage_plate_slot);
    }
    else
    {
        SetFamilyWarehouseData(family_id, old_slot, FWS_ITEM_AMOUNT, left_amount);
    }

    if(!FamilyStorageSaveWarehouseSlot(playerid, family_id, old_slot))
        return false;

    return true;
}

stock FamilyStorageHandleWarehouseSlotToInventory(playerid, type, ga, os, ns, family_id, Node:resp)
{
    new slot_item = ga;
    new active_slot = os;
    new target_slot = ns;
    new bool:ok = false;

    if(slot_item == 134 || slot_item == 122)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "  ", " ");
    }
    else if(!Inventory11_IsAccessoryItem(slot_item))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, " ", " ");
    }
    else
    {
        if(active_slot == 0)
            active_slot = 1;

        if(active_slot < 1 || active_slot > 2)
            active_slot = 1;

        if(target_slot < 1 || target_slot > Inventory11_GetMaxSlots(playerid))
            target_slot = TrunkTest_GetFreeInventorySlot(playerid);

        if(target_slot == -1)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
        }
        else
        {
            new item_weight_x10 = InventoryCfg_GetItemWeightX10(slot_item);
            if(item_weight_x10 <= 0) item_weight_x10 = 10;

            if(Inventory11_GetCurrentWeightX10(playerid) + item_weight_x10 > (Inventory11_GetMaxWeightKg(playerid) * 10))
            {
                ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
            }
            else
            {
                new moved_model = 0;
                new used_slot = active_slot;

                if(!Inventory11_MoveActiveAccessoryToInventorySlot(playerid, slot_item, used_slot, target_slot, moved_model))
                {
                    used_slot = (used_slot == 1) ? 2 : 1;

                    if(!Inventory11_MoveActiveAccessoryToInventorySlot(playerid, slot_item, used_slot, target_slot, moved_model))
                    {
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "  ", " ");
                    }
                    else
                    {
                        ok = true;
                    }
                }
                else
                {
                    ok = true;
                }
            }
        }
    }

    JSON_SetInt(resp, "t", type);
    JSON_SetInt(resp, "s", ok ? 1 : 0);

    if(ok)
    {
        JSON_SetInt(resp, "w", Inventory11_GetCurrentWeightKg(playerid));
        JSON_SetInt(resp, "bw", FamilyStorageWhWeightKg(family_id));
    }

    OnPacketIncoming(playerid, 34, resp);
    return ok;
}

stock FamilyStorageHandleInventoryPacket(playerid, Node:json)
{
    if(!FamilyStorageIsWarehouseGui(playerid))
        return 0;

    new family_id = FamilyStorageGetWarehouseFamilyId(playerid);
    if(!FamilyStorageIsValidFamilyId(family_id))
    {
        FamilyStorageResetWarehouseGui(playerid);
        return 1;
    }

    if(GetPlayerRangFamily(playerid) != 5)
    {
        HidePlayerGUI(playerid, GUICarsTrunkOrCloset);
        FamilyStorageResetWarehouseGui(playerid);
        FamilyStorageShowAccessDenied(playerid);
        return 1;
    }

    new type = -1;
    JSON_GetInt(json, "t", type);

    if(type == 8)
    {
        // Client can send t=8 during internal GUI refresh; keep family warehouse context.
        return 1;
    }

    if(type == 3 || type == 4 || type == 5 || type == 6 || type == 7)
        return 1;

    new ga = 0, os = -1, ns = -1, value = 0;
    JSON_GetInt(json, "ga", ga);
    JSON_GetInt(json, "os", os);
    JSON_GetInt(json, "ns", ns);
    JSON_GetInt(json, "v", value);

    if(ns == -1)
        JSON_GetInt(json, "s", ns);

    new bool:ok = false;
    new Node:resp = JSON_Object();

    switch(type)
    {
        case 0: ok = FamilyStorageMoveInventoryToWarehouse(playerid, family_id, ga, os, ns, value);
        case 1: ok = FamilyStorageMoveWarehouseToInventory(playerid, family_id, os, ns, ga, value);
        case 2, 9:
        {
            ok = FamilyStorageHandleWarehouseSlotToInventory(playerid, type, ga, os, ns, family_id, resp);
            JSON_Cleanup(resp);

            if(ok)
                FamilyStorageOpenWarehouseGui(playerid);

            return 1;
        }
        default:
        {
            JSON_SetInt(resp, "t", type);
            JSON_SetInt(resp, "s", 0);
            OnPacketIncoming(playerid, 34, resp);
            JSON_Cleanup(resp);
            return 1;
        }
    }

    JSON_SetInt(resp, "t", type);
    JSON_SetInt(resp, "s", ok ? 1 : 0);

    if(ok)
    {
        JSON_SetInt(resp, "w", Inventory11_GetCurrentWeightKg(playerid));
        JSON_SetInt(resp, "bw", FamilyStorageWhWeightKg(family_id));
    }

    OnPacketIncoming(playerid, 34, resp);
    JSON_Cleanup(resp);

    if(ok)
        FamilyStorageOpenWarehouseGui(playerid);

    return 1;
}

stock FamilyStorageShowSettingsDialog(playerid)
{
    DeletePVar(playerid, "select_get_dostup");

    ShowPlayerDialog
    (
        playerid, 2230, DIALOG_STYLE_LIST,
        "{E0584B} ",
        "1.  \n"\
        "2.  \n"\
        "3.  ",
        "", ""
    );
    return 1;
}

stock FamilyStorageShowAccessInfo(playerid)
{
    new text[512];

    if(GetPlayerRangFamily(playerid) == 5)
    {
        format(text, sizeof(text), "{FFFFFF}            .");
    }
    else
    {
        format
        (
            text, sizeof(text),
            "{FFFFFF} : %s\n"\
            "{FFFFFF}: %d\n"\
            "{FFFFFF}: %d\n"\
            "{FFFFFF}: %d\n"\
            "{FFFFFF}: %d\n"\
            "{FFFFFF}: %d\n"\
            "{FFFFFF}: %d",
            GetPlayerFamily(playerid, ACCESS_GIVE) ? ("{66CC66}") : ("{FF6666}"),
            GetPlayerFamily(playerid, ACCESS_MONEY),
            GetPlayerFamily(playerid, ACCESS_PATRON),
            GetPlayerFamily(playerid, ACCESS_ARMOUR),
            GetPlayerFamily(playerid, ACCESS_MATERIAL),
            GetPlayerFamily(playerid, ACCESS_HEATH_KIT),
            GetPlayerFamily(playerid, ACCESS_MASK)
        );
    }

    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "{E0584B}   ", text, "", "");
    return 1;
}

stock FamilyStorageShowMainDialog(playerid)
{
    new text[256];

    FamilyStorageResetState(playerid);

    if(GetPlayerRangFamily(playerid) == 5)
    {
        format
        (
            text, sizeof(text),
            "1. \n"\
            "2. \n"\
            "3.    \n"\
            "4.  "
        );
    }
    else
    {
        format
        (
            text, sizeof(text),
            "1. \n"\
            "2. \n"\
            "3.    "
        );
    }

    ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_MAIN, DIALOG_STYLE_LIST, "{E0584B} ", text, "", "");
    return 1;
}

stock FamilyStorageShowSafeDialog(playerid)
{
    new family_id = GetPlayerIdFamily(playerid);
    new text[256];

    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    format
    (
        text, sizeof(text),
        "%s\n"\
        "1. \n"\
        "2. \n"\
        "3. ",
        GetFamily(family_id, family_status_storage) ? ("{33CC66}| {FFFFFF} {33CC66}") : ("{E0584B}| {FFFFFF} {E0584B}")
    );

    ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE, DIALOG_STYLE_LIST, "{E0584B}", text, "", "");
    return 1;
}

stock FamilyStorageShowSafeTakeDialog(playerid)
{
    ShowPlayerDialog
    (
        playerid, FAM_DIALOG_STORAGE_SAFE_TAKE, DIALOG_STYLE_LIST,
        "{E0584B}   ",
        "{FFFF00}|{FFFF00} {FFFFFF}\n"\
        "{FFFF00}|{FFFF00} {FFFFFF}\n"\
        "{FFFF00}|{FFFF00} {FFFFFF}",
        "", ""
    );
    return 1;
}

stock FamilyStorageShowSafePutDialog(playerid)
{
    ShowPlayerDialog
    (
        playerid, FAM_DIALOG_STORAGE_SAFE_PUT, DIALOG_STYLE_LIST,
        "{E0584B}   ",
        "{FFFF00}|{FFFF00} {FFFFFF}\n"\
        "{FFFF00}|{FFFF00} {FFFFFF}\n"\
        "{FFFF00}|{FFFF00} {FFFFFF}",
        "", ""
    );
    return 1;
}

stock FamilyStorageShowAmmoActionDialog(playerid, action_type)
{
    SetPVarInt(playerid, PVAR_FAMILY_SAFE_AMMO_ACTION, action_type);

    ShowPlayerDialog
    (
        playerid, FAM_DIALOG_STORAGE_SAFE_AMMO, DIALOG_STYLE_LIST,
        action_type == FAMILY_SAFE_ACTION_TAKE ? "{E0584B} " : "{E0584B} ",
        action_type == FAMILY_SAFE_ACTION_TAKE ?
        ("{FFFFFF}1. \n{FFFFFF}2. ") :
        ("{FFFFFF}1. \n{FFFFFF}2. "),
        "", ""
    );
    return 1;
}

stock FamilyStorageShowAmmoInfo(playerid)
{
    new family_id = GetPlayerIdFamily(playerid);
    new text[256];

    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    format
    (
        text, sizeof(text),
        "{FFFFFF}   :\n"\
        "-   \n"\
        "-   \n"\
        "-   \n"\
        "-   \n\n"\
        ": %d .",
        GetFamily(family_id, family_patron)
    );

    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "{E0584B}  ", text, "", "");
    return 1;
}

stock FamilyStorageShowWeaponDialog(playerid)
{
    ShowPlayerDialog
    (
        playerid, FAM_DIALOG_STORAGE_SAFE_WEAPON, DIALOG_STYLE_LIST,
        "{E0584B} ",
        "1. Desert Eagle\n"\
        "2. AK-47\n"\
        "3. MP5\n"\
        "4. Shotgun\n"\
        "5. Country Rifle\n"\
        "6. Sniper Rifle\n"\
        "7. M4",
        "", ""
    );
    return 1;
}

stock FamilyStorageHasTakeAccess(playerid, access_type, amount)
{
    if(GetPlayerRangFamily(playerid) == 5)
        return 1;

    switch(access_type)
    {
        case ACCESS_MONEY:  return GetPlayerFamily(playerid, ACCESS_MONEY) >= amount;
        case ACCESS_PATRON: return GetPlayerFamily(playerid, ACCESS_PATRON) >= amount;
        case ACCESS_ARMOUR: return GetPlayerFamily(playerid, ACCESS_ARMOUR) >= amount;
    }

    return 0;
}

stock FamilyStorageConsumeAccess(playerid, access_type, amount)
{
    if(GetPlayerRangFamily(playerid) == 5)
        return 1;

    AddPlayerFamily(playerid, access_type, -, amount);
    UpdateAccessPlayerFamily(playerid);
    return 1;
}

stock FamilyStorageHandleTakeMoney(playerid, amount)
{
    new family_id = GetPlayerIdFamily(playerid);
    new chat_text[200], action_text[96], notif_text[96];

    if(!FamilyStorageIsValidFamilyId(family_id) || amount <= 0)
        return 0;

    if(amount > FAMILY_SAFE_MAX_MONEY_AMOUNT)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   1  1000000 .", " ");

    if(GetFamily(family_id, family_money) < amount)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");

    if(!FamilyStorageHasTakeAccess(playerid, ACCESS_MONEY, amount))
        return FamilyStorageShowAccessDenied(playerid);

    FamilyStorageConsumeAccess(playerid, ACCESS_MONEY, amount);
    AddFamily(family_id, family_money, -, amount);
    UpdateColumnFamilyInt(GetFamily(family_id, family_database), "money", GetFamily(family_id, family_money));
    GivePlayerMoneyEx(playerid, amount, " ", true, true);

    format(action_text, sizeof(action_text), " %d .", amount);
    FamilyStorageBuildChatText(playerid, action_text, chat_text, sizeof(chat_text));
    SendFamilyMessage(family_id, chat_text);
    SendFamilyLog(type_log_money, playerid, -1, chat_text);

    format(notif_text, sizeof(notif_text), "  %d ", amount);
    ShowNotificationNew(playerid, 3, 6, 0, 0, notif_text, " ");
    return 1;
}

stock FamilyStorageHandlePutMoney(playerid, amount)
{
    new family_id = GetPlayerIdFamily(playerid);
    new chat_text[200], action_text[96], notif_text[96];
    new limit, limit_text[96];

    if(!FamilyStorageIsValidFamilyId(family_id) || amount <= 0)
        return 0;

    if(amount > FAMILY_SAFE_MAX_MONEY_AMOUNT)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   1  1000000 .", " ");

    if(GetPlayerMoneyEx(playerid) < amount)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");

    limit = count_money_level[FamilyStorageClampLevel(GetFamily(family_id, family_lvl_storage)) - 1];
    if((GetFamily(family_id, family_money) + amount) > limit)
    {
        format(limit_text, sizeof(limit_text), " ,   %d ", limit);
        return ShowNotificationNew(playerid, 2, 6, 0, 0, limit_text, " ");
    }

    AddFamily(family_id, family_money, +, amount);
    UpdateColumnFamilyInt(GetFamily(family_id, family_database), "money", GetFamily(family_id, family_money));
    GivePlayerMoneyEx(playerid, -amount, "  ", true, true);

    format(action_text, sizeof(action_text), " %d .", amount);
    FamilyStorageBuildChatText(playerid, action_text, chat_text, sizeof(chat_text));
    SendFamilyMessage(family_id, chat_text);
    SendFamilyLog(type_log_money, playerid, -1, chat_text);

    format(notif_text, sizeof(notif_text), "  %d ", amount);
    ShowNotificationNew(playerid, 2, 6, 0, 0, notif_text, " ");
    return 1;
}

stock FamilyStorageHandleTakeArmour(playerid)
{
    new family_id = GetPlayerIdFamily(playerid);
    new chat_text[200];

    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    if(GetFamily(family_id, family_armour) < 1)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");

    if(!FamilyStorageHasTakeAccess(playerid, ACCESS_ARMOUR, 1))
        return FamilyStorageShowAccessDenied(playerid);

    FamilyStorageConsumeAccess(playerid, ACCESS_ARMOUR, 1);
    AddFamily(family_id, family_armour, -, 1);
    UpdateColumnFamilyInt(GetFamily(family_id, family_database), "armour", GetFamily(family_id, family_armour));
    SetPlayerArmour(playerid, 100.0);

    FamilyStorageBuildChatText(playerid, " .", chat_text, sizeof(chat_text));
    SendFamilyMessage(family_id, chat_text);
    SendFamilyLog(type_log_armour, playerid, -1, chat_text);
    ShowNotificationNew(playerid, 3, 6, 0, 0, "  ", " ");
    return 1;
}

stock FamilyStorageHandlePutArmour(playerid)
{
    new family_id = GetPlayerIdFamily(playerid);
    new chat_text[200];
    new limit;
    new Float:armour;

    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    GetPlayerArmour(playerid, armour);
    if(armour < 20.0)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");

    limit = count_armour_level[FamilyStorageClampLevel(GetFamily(family_id, family_lvl_storage)) - 1];
    if((GetFamily(family_id, family_armour) + 1) > limit)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "  ", " ");

    AddFamily(family_id, family_armour, +, 1);
    UpdateColumnFamilyInt(GetFamily(family_id, family_database), "armour", GetFamily(family_id, family_armour));
    SetPlayerArmour(playerid, 0.0);

    FamilyStorageBuildChatText(playerid, " .", chat_text, sizeof(chat_text));
    SendFamilyMessage(family_id, chat_text);
    SendFamilyLog(type_log_armour, playerid, -1, chat_text);
    ShowNotificationNew(playerid, 3, 6, 0, 0, "  ", " ");
    return 1;
}

stock FamilyStorageHandleTakeAmmo(playerid, weapon_index, ammo_count)
{
    new family_id = GetPlayerIdFamily(playerid);
    new chat_text[200], action_text[96], notif_text[96];

    if(!FamilyStorageIsValidFamilyId(family_id) || weapon_index < 0 || weapon_index >= sizeof(count_weapon_level) || ammo_count <= 0)
        return 0;

    if(GetFamily(family_id, family_patron) < ammo_count)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");

    if(!FamilyStorageHasTakeAccess(playerid, ACCESS_PATRON, ammo_count))
        return FamilyStorageShowAccessDenied(playerid);

    FamilyStorageConsumeAccess(playerid, ACCESS_PATRON, ammo_count);
    AddFamily(family_id, family_patron, -, ammo_count);
    UpdateColumnFamilyInt(GetFamily(family_id, family_database), "patron", GetFamily(family_id, family_patron));
    GivePlayerWeapon(playerid, count_weapon_level[weapon_index], ammo_count);

    format(action_text, sizeof(action_text), " %d   %s.", ammo_count, name_weapon_family[weapon_index]);
    FamilyStorageBuildChatText(playerid, action_text, chat_text, sizeof(chat_text));
    SendFamilyMessage(family_id, chat_text);
    SendFamilyLog(type_log_patron, playerid, -1, chat_text);

    format(notif_text, sizeof(notif_text), "  %d ", ammo_count);
    ShowNotificationNew(playerid, 3, 6, 0, 0, notif_text, " ");
    return 1;
}

stock FamilyStorageHandlePutAmmo(playerid, ammo_count)
{
    new family_id = GetPlayerIdFamily(playerid);
    new chat_text[200], action_text[96], notif_text[96];
    new weapon = GetPlayerWeapon(playerid);
    new ammo = GetPlayerAmmo(playerid);
    new limit;
    new slot_weapon_native = 0, slot_ammo_native = 0;
    new slot_weapon_ac = 0, slot_ammo_ac = 0;
    new slot_ammo_found = -1;

    if(!FamilyStorageIsValidFamilyId(family_id) || ammo_count <= 0)
        return 0;

    switch(weapon)
    {
        case 24, 25, 29, 30, 31, 33, 34:
        {
        }
        default:
        {
            printf("[FAMILY_STORAGE][PUT_AMMO] player=%d invalid current weapon=%d current_ammo=%d request=%d", playerid, weapon, ammo, ammo_count);
            return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
        }
    }

    printf("[FAMILY_STORAGE][PUT_AMMO] player=%d current_weapon=%d current_ammo=%d request=%d", playerid, weapon, ammo, ammo_count);

    for(new i = 0; i < 12; i++)
    {
        GetPlayerWeaponData(playerid, i, slot_weapon_native, slot_ammo_native);
        GetPlayerWeaponDataAC(playerid, i, slot_weapon_ac, slot_ammo_ac);
        printf("[FAMILY_STORAGE][PUT_AMMO] player=%d slot=%d native_weapon=%d native_ammo=%d ac_weapon=%d ac_ammo=%d current_weapon=%d current_ammo=%d request=%d", playerid, i, slot_weapon_native, slot_ammo_native, slot_weapon_ac, slot_ammo_ac, weapon, ammo, ammo_count);

        if(slot_weapon_native == weapon && slot_ammo_native > slot_ammo_found)
            slot_ammo_found = slot_ammo_native;

        if(slot_weapon_ac == weapon && slot_ammo_ac > slot_ammo_found)
            slot_ammo_found = slot_ammo_ac;
    }

    if(slot_ammo_found > ammo)
        ammo = slot_ammo_found;

    printf("[FAMILY_STORAGE][PUT_AMMO] player=%d final_weapon=%d final_ammo=%d request=%d family=%d", playerid, weapon, ammo, ammo_count, family_id);

    if(ammo < ammo_count)
    {
        printf("[FAMILY_STORAGE][PUT_AMMO] player=%d insufficient ammo: final_ammo=%d request=%d", playerid, ammo, ammo_count);
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "   ", " ");
    }

    limit = count_patron_level[FamilyStorageClampLevel(GetFamily(family_id, family_lvl_weapon)) - 1];
    if((GetFamily(family_id, family_patron) + ammo_count) > limit)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "  ", " ");

    AddFamily(family_id, family_patron, +, ammo_count);
    UpdateColumnFamilyInt(GetFamily(family_id, family_database), "patron", GetFamily(family_id, family_patron));
    SetPlayerAmmo(playerid, weapon, ammo - ammo_count);

    format(action_text, sizeof(action_text), " %d .", ammo_count);
    FamilyStorageBuildChatText(playerid, action_text, chat_text, sizeof(chat_text));
    SendFamilyMessage(family_id, chat_text);
    SendFamilyLog(type_log_patron, playerid, -1, chat_text);

    format(notif_text, sizeof(notif_text), "  %d ", ammo_count);
    ShowNotificationNew(playerid, 3, 6, 0, 0, notif_text, " ");
    return 1;
}
stock FamilyStorageHandleGuiAction(playerid, Node:request)
{
    new selected = -1;

    if(JSON_GetType(request, "r") != JSON_NODE_NUMBER)
    {
        HidePlayerGUI(playerid, 45);
        return FamilyStorageShowMainDialog(playerid);
    }

    JSON_GetInt(request, "r", selected);

    if(selected == 0)
    {
        HidePlayerGUI(playerid, 45);
        return FamilyStorageShowSafeDialog(playerid);
    }

    if(selected == 1)
    {
        if(GetPlayerRangFamily(playerid) != 5)
            return FamilyStorageShowAccessDenied(playerid);

        HidePlayerGUI(playerid, 45);
        return FamilyStorageOpenWarehouseGui(playerid);
    }

    HidePlayerGUI(playerid, 45);
    return FamilyStorageShowMainDialog(playerid);
}

stock FamilyStorage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new family_id = GetPlayerIdFamily(playerid);
    new amount = 0;
    new chat_text[200];

    if(!FamilyStorageIsValidFamilyId(family_id))
        return 0;

    switch(dialogid)
    {
        case FAM_DIALOG_STORAGE_MAIN:
        {
            if(!response) return 1;

            switch(listitem)
            {
                case 0:
                {
                    if(GetPlayerRangFamily(playerid) != 5)
                        return FamilyStorageShowAccessDenied(playerid);

                    return FamilyStorageOpenWarehouseGui(playerid);
                }
                case 1: return FamilyStorageShowSafeDialog(playerid);
                case 2: return FamilyStorageShowAccessInfo(playerid);
                case 3:
                {
                    if(GetPlayerRangFamily(playerid) != 5)
                        return FamilyStorageShowAccessDenied(playerid);

                    return FamilyStorageShowSettingsDialog(playerid);
                }
            }
            return 1;
        }
        case FAM_DIALOG_STORAGE_SAFE:
        {
            if(!response) return 1;

            switch(listitem)
            {
                case 0:
                {
                    if(GetPlayerRangFamily(playerid) != 5)
                        return FamilyStorageShowAccessDenied(playerid);

                    SetFamily(family_id, family_status_storage, GetFamily(family_id, family_status_storage) ? 0 : 1);
                    FamilyStorageBuildChatText(playerid, GetFamily(family_id, family_status_storage) ? " ." : " .", chat_text, sizeof(chat_text));
                    SendFamilyMessage(family_id, chat_text);
                    return 1;
                }
                case 1:
                {
                    if(!GetFamily(family_id, family_status_storage) && GetPlayerRangFamily(playerid) != 5)
                        return FamilyStorageShowClosed(playerid);

                    return FamilyStorageShowSafeTakeDialog(playerid);
                }
                case 2:
                {
                    if(!GetFamily(family_id, family_status_storage) && GetPlayerRangFamily(playerid) != 5)
                        return FamilyStorageShowClosed(playerid);

                    return FamilyStorageShowSafePutDialog(playerid);
                }
                case 3:
                {
                    if(GetPlayerRangFamily(playerid) == 5)
                        return FamilyStorageShowSettingsDialog(playerid);

                    return FamilyStorageShowAccessInfo(playerid);
                }
            }
            return 1;
        }
        case FAM_DIALOG_STORAGE_SAFE_TAKE:
        {
            if(!response) return FamilyStorageShowSafeDialog(playerid);

            switch(listitem)
            {
                case 0:
                {
                    SetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION, FAMILY_SAFE_ACTION_TAKE);
                    return ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE_MONEY, DIALOG_STYLE_INPUT, "{E0584B} ", "{FFFFFF} - :", "", "");
                }
                case 1: return FamilyStorageShowAmmoActionDialog(playerid, FAMILY_SAFE_ACTION_TAKE);
                case 2:
                {
                    SetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION, FAMILY_SAFE_ACTION_TAKE);
                    return ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE_ARMOUR, DIALOG_STYLE_MSGBOX, "{E0584B} ", "{FFFFFF}     ?", "", "");
                }
            }
            return 1;
        }
        case FAM_DIALOG_STORAGE_SAFE_PUT:
        {
            if(!response) return FamilyStorageShowSafeDialog(playerid);

            switch(listitem)
            {
                case 0:
                {
                    SetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION, FAMILY_SAFE_ACTION_PUT);
                    return ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE_MONEY, DIALOG_STYLE_INPUT, "{E0584B} ", "{FFFFFF} - :", "", "");
                }
                case 1: return FamilyStorageShowAmmoActionDialog(playerid, FAMILY_SAFE_ACTION_PUT);
                case 2:
                {
                    SetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION, FAMILY_SAFE_ACTION_PUT);
                    return ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE_ARMOUR, DIALOG_STYLE_MSGBOX, "{E0584B} ", "{FFFFFF}     ?", "", "");
                }
            }
            return 1;
        }
        case FAM_DIALOG_STORAGE_SAFE_MONEY:
        {
            if(!response) return FamilyStorageShowSafeDialog(playerid);

            amount = strval(inputtext);
            if(amount <= 0)
                return ShowNotificationNew(playerid, 2, 6, 0, 0, "  ", " ");

            if(amount > FAMILY_SAFE_MAX_MONEY_AMOUNT)
            {
                if(GetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION) == FAMILY_SAFE_ACTION_PUT)
                    return ShowNotificationNew(playerid, 2, 6, 0, 0, "   1  1000000 .", " ");

                return ShowNotificationNew(playerid, 2, 6, 0, 0, "   1  1000000 .", " ");
            }

            if(GetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION) == FAMILY_SAFE_ACTION_PUT)
                return FamilyStorageHandlePutMoney(playerid, amount);

            return FamilyStorageHandleTakeMoney(playerid, amount);
        }
        case FAM_DIALOG_STORAGE_SAFE_AMMO:
        {
            if(!response) return FamilyStorageShowSafeDialog(playerid);

            if(listitem == 0)
                return FamilyStorageShowAmmoInfo(playerid);

            if(GetPVarInt(playerid, PVAR_FAMILY_SAFE_AMMO_ACTION) == FAMILY_SAFE_ACTION_PUT)
                return ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE_AMMO_INPUT, DIALOG_STYLE_INPUT, "{E0584B} ", "{FFFFFF} - ,   :", "", "");

            return FamilyStorageShowWeaponDialog(playerid);
        }
        case FAM_DIALOG_STORAGE_SAFE_WEAPON:
        {
            if(!response) return FamilyStorageShowSafeDialog(playerid);

            SetPVarInt(playerid, PVAR_FAMILY_SAFE_WEAPON_INDEX, listitem);
            format(chat_text, sizeof(chat_text), "{FFFFFF}  - ,  %d", GetFamily(family_id, family_patron));
            return ShowPlayerDialog(playerid, FAM_DIALOG_STORAGE_SAFE_AMMO_INPUT, DIALOG_STYLE_INPUT, "{E0584B} ", chat_text, "", "");
        }
        case FAM_DIALOG_STORAGE_SAFE_AMMO_INPUT:
        {
            if(!response)
            {
                if(GetPVarInt(playerid, PVAR_FAMILY_SAFE_AMMO_ACTION) == FAMILY_SAFE_ACTION_PUT)
                    return FamilyStorageShowAmmoActionDialog(playerid, FAMILY_SAFE_ACTION_PUT);

                return FamilyStorageShowWeaponDialog(playerid);
            }

            amount = strval(inputtext);
            if(amount <= 0)
                return ShowNotificationNew(playerid, 2, 6, 0, 0, "  ", " ");

            if(GetPVarInt(playerid, PVAR_FAMILY_SAFE_AMMO_ACTION) == FAMILY_SAFE_ACTION_PUT)
                return FamilyStorageHandlePutAmmo(playerid, amount);

            return FamilyStorageHandleTakeAmmo(playerid, GetPVarInt(playerid, PVAR_FAMILY_SAFE_WEAPON_INDEX), amount);
        }
        case FAM_DIALOG_STORAGE_SAFE_ARMOUR:
        {
            if(!response) return FamilyStorageShowSafeDialog(playerid);

            if(GetPVarInt(playerid, PVAR_FAMILY_SAFE_MONEY_ACTION) == FAMILY_SAFE_ACTION_PUT)
                return FamilyStorageHandlePutArmour(playerid);

            return FamilyStorageHandleTakeArmour(playerid);
        }
    }

    return 0;
}
