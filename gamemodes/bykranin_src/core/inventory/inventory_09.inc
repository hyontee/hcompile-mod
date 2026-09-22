//>> Файл: bykranin_src/core/inventory/inventory_09.inc  (1548 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: Inventory11_FindFirstItemSlotById, Inv11_GetAccItemByModel, Inventory11_NormalizeLegacyAccessorySlots, Inventory11_GetActiveAccessories, Inventory11_GetFreeActiveAccessorySlot, Inventory11_BuildAiJson, Inventory11_SetAiArrayOnJson
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock Inventory11_FindFirstItemSlotById(playerid, item_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return -1;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT slot FROM inventory WHERE account_id = %d AND item_id = %d ORDER BY slot ASC LIMIT 1", account_id, item_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] FindFirstItemSlotById failed errno=%d account_id=%d item=%d query=%s", mysql_errno(), account_id, item_id, query);
        cache_delete(result);
        return -1;
    }

    if(cache_num_rows(result) <= 0)
    {
        cache_delete(result);
        return -1;
    }

    new slot = cache_get_field_content_int(0, "slot");
    cache_delete(result);
    return slot;
}

stock Inv11_GetAccItemByModel(modelid)
{
    for(new i = 0; i < sizeof(AccessoryMapping); i++)
    {
        if(AccessoryMapping[i][2] == modelid)
        {
            return AccessoryMapping[i][1];
        }
    }

    for(new i = 0; i < sizeof(CaseAccessoryRewardMapping); i++)
    {
        if(CaseAccessoryRewardMapping[i][1] == modelid)
        {
            return CaseAccessoryRewardMapping[i][0];
        }
    }

    // World-shop models also need a reverse lookup for equipped slots.
    // Otherwise the active row is skipped and the accessory cannot be removed.
    for(new i = 0; i < sizeof(AccessoryShopInventoryMap); i++)
    {
        if(AccessoryShopInventoryMap[i][0] == modelid)
            return AccessoryShopInventoryMap[i][1];
    }

    if(Inventory11_IsAccessoryItem(modelid))
    {
        return modelid;
    }

    return -1;
}

stock Inventory11_NormalizeLegacyAccessorySlots(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new bool:occupied[INVENTORY11_MAX_ACTIVE_ACCESSORIES + 1];
    new query[448];
    mysql_format(mysql, query, sizeof(query),
        "SELECT slot FROM accessories_players WHERE player_id=%d AND slot BETWEEN 1 AND %d",
        account_id, INVENTORY11_MAX_ACTIVE_ACCESSORIES);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows(result);
    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        if(1 <= slot <= INVENTORY11_MAX_ACTIVE_ACCESSORIES) occupied[slot] = true;
    }
    cache_delete(result);

    new legacy_ids[INVENTORY11_MAX_ACTIVE_ACCESSORIES];
    new legacy_slots[INVENTORY11_MAX_ACTIVE_ACCESSORIES];

    // Слоты 7..9 занимают аксессуары из /giveacs (таблица admin_given_accessories) - их переносить нельзя,
    // иначе они уезжали в слоты 1..4, а запись в admin_given_accessories оставалась "осиротевшей".
    AdminGiveAccessoryEnsureStorage();
    mysql_format(mysql, query, sizeof(query),
        "SELECT id,slot FROM accessories_players WHERE player_id=%d AND slot BETWEEN 5 AND 9 AND slot NOT IN (SELECT physical_slot FROM admin_given_accessories WHERE player_id=%d) ORDER BY slot,id LIMIT %d",
        account_id, account_id, INVENTORY11_MAX_ACTIVE_ACCESSORIES);
    result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }

    rows = cache_num_rows(result);
    if(rows > INVENTORY11_MAX_ACTIVE_ACCESSORIES) rows = INVENTORY11_MAX_ACTIVE_ACCESSORIES;
    for(new i = 0; i < rows; i++)
    {
        legacy_ids[i] = cache_get_field_content_int(i, "id");
        legacy_slots[i] = cache_get_field_content_int(i, "slot");
    }
    cache_delete(result);

    new migrated = 0;
    for(new i = 0; i < rows; i++)
    {
        new target_slot = 0;
        for(new slot = 1; slot <= INVENTORY11_MAX_ACTIVE_ACCESSORIES; slot++)
        {
            if(occupied[slot]) continue;
            target_slot = slot;
            break;
        }
        if(target_slot == 0) break;

        mysql_format(mysql, query, sizeof(query),
            "UPDATE accessories_players SET slot=%d WHERE id=%d AND player_id=%d LIMIT 1",
            target_slot, legacy_ids[i], account_id);
        mysql_query(mysql, query, false);
        if(mysql_errno()) continue;

        occupied[target_slot] = true;
        if(IsPlayerAttachedObjectSlotUsed(playerid, legacy_slots[i]))
            RemovePlayerAttachedObject(playerid, legacy_slots[i]);
        migrated++;
        printf("[INV11][ACS][MIGRATE] player=%d account=%d old_slot=%d new_slot=%d row=%d",
            playerid, account_id, legacy_slots[i], target_slot, legacy_ids[i]);
    }

    return migrated;
}

stock Inventory11_GetActiveAccessories(playerid, &item_1, &model_1, &item_2, &model_2, &item_3, &model_3, &item_4, &model_4)
{
    item_1 = -1;
    model_1 = -1;
    item_2 = -1;
    model_2 = -1;
    item_3 = -1;
    model_3 = -1;
    item_4 = -1;
    model_4 = -1;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return 0;
    }

    if(Inventory11_NormalizeLegacyAccessorySlots(playerid) > 0)
        LoadAccessory(playerid);

    new query[192];
    mysql_format(mysql, query, sizeof(query), "SELECT slot, acs_id FROM accessories_players WHERE player_id = %d AND slot BETWEEN 1 AND %d ORDER BY slot ASC", account_id, INVENTORY11_MAX_ACTIVE_ACCESSORIES);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] GetActiveAccessories failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, query);
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows(result);
    for(new i = 0; i < rows; i++)
    {
        new active_slot = cache_get_field_content_int(i, "slot");
        new acs_id = cache_get_field_content_int(i, "acs_id");

        if(active_slot < 1 || active_slot > INVENTORY11_MAX_ACTIVE_ACCESSORIES)
        {
            continue;
        }

        // acs_id is 0-based in this mod; ID 0 is a valid accessory.
        if(acs_id < 0 || acs_id >= sizeof(accessory))
        {
            continue;
        }

        new modelid = accessory[acs_id][ID_ACCESSORY];
        new item_id = Inv11_GetAccItemByModel(modelid);
        if(modelid <= 0 || item_id <= 0)
        {
            continue;
        }

        switch(active_slot)
        {
            case 1: { item_1 = item_id; model_1 = modelid; }
            case 2: { item_2 = item_id; model_2 = modelid; }
            case 3: { item_3 = item_id; model_3 = modelid; }
            case 4: { item_4 = item_id; model_4 = modelid; }
        }
    }

    cache_delete(result);
    return rows;
}

stock Inventory11_GetFreeActiveAccessorySlot(playerid, modelid, &active_slot)
{
    active_slot = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new bool:occupied[INVENTORY11_MAX_ACTIVE_ACCESSORIES + 1];
    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "SELECT slot, acs_id FROM accessories_players WHERE player_id = %d AND slot BETWEEN 1 AND %d ORDER BY slot ASC",
        account_id, INVENTORY11_MAX_ACTIVE_ACCESSORIES);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] GetFreeActiveAccessorySlot failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, query);
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows(result);
    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        new acs_id = cache_get_field_content_int(i, "acs_id");
        if(slot < 1 || slot > INVENTORY11_MAX_ACTIVE_ACCESSORIES) continue;

        occupied[slot] = true;

        if(acs_id >= 0 && acs_id < sizeof(accessory) && accessory[acs_id][ID_ACCESSORY] == modelid)
        {
            active_slot = slot;
            cache_delete(result);
            return 2; // already equipped
        }
    }
    cache_delete(result);

    for(new slot = 1; slot <= INVENTORY11_MAX_ACTIVE_ACCESSORIES; slot++)
    {
        if(occupied[slot]) continue;
        active_slot = slot;
        return 1;
    }

    return 0; // no free slots
}

stock bool:Inventory11_BuildAiJson(playerid, ai_json[], ai_size)
{
    new item_1, model_1, item_2, model_2, item_3, model_3, item_4, model_4;
    Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2, item_3, model_3, item_4, model_4);

    format(ai_json, ai_size, "[134,%d,6,0,0", GetPlayerSkin(playerid));

    new temp[64];
    if(item_1 > 0 && model_1 > 0)
    {
        format(temp, sizeof(temp), ",%d,%d,1,0,0", item_1, model_1);
        strcat(ai_json, temp, ai_size);
    }

    if(item_2 > 0 && model_2 > 0)
    {
        format(temp, sizeof(temp), ",%d,%d,2,0,0", item_2, model_2);
        strcat(ai_json, temp, ai_size);
    }

    if(item_3 > 0 && model_3 > 0)
    {
        format(temp, sizeof(temp), ",%d,%d,3,0,0", item_3, model_3);
        strcat(ai_json, temp, ai_size);
    }

    if(item_4 > 0 && model_4 > 0)
    {
        format(temp, sizeof(temp), ",%d,%d,4,0,0", item_4, model_4);
        strcat(ai_json, temp, ai_size);
    }

    strcat(ai_json, "]", ai_size);
    return true;
}

stock Inventory11_SetAiArrayOnJson(playerid, json_obj)
{
    new ai_json[320];
    Inventory11_BuildAiJson(playerid, ai_json, sizeof(ai_json));

    new Node:aiArray = JSON_Array();
    JSON_Parse(ai_json, aiArray);
    JSON_SetArray(json_obj, "ai", aiArray);
    return 1;
}

stock bool:Inventory11_HasInventoryItemInSlot(playerid, slot, item_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[180];
    mysql_format(mysql, query, sizeof(query), "SELECT 1 FROM inventory WHERE account_id = %d AND slot = %d AND item_id = %d LIMIT 1", account_id, slot, item_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] HasInventoryItemInSlot failed errno=%d account_id=%d slot=%d item=%d query=%s", mysql_errno(), account_id, slot, item_id, query);
        cache_delete(result);
        return false;
    }

    new bool:has_item = (cache_num_rows(result) > 0);
    cache_delete(result);
    return has_item;
}

stock bool:Inventory11_MoveActiveAccessoryToInventorySlot(playerid, item_id, active_slot, inventory_slot, &modelid)
{
    modelid = 0;

    if(active_slot < 1 || active_slot > INVENTORY11_MAX_ACTIVE_ACCESSORIES)
    {
        return false;
    }

    if(inventory_slot < 1 || inventory_slot > Inventory11_GetMaxSlots(playerid))
    {
        printf("[INV11][WARN] MoveActiveAccessory invalid inventory slot: player=%d active_slot=%d inv_slot=%d item=%d", playerid, active_slot, inventory_slot, item_id);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Выберите другой слот в инвентаре", " ");
        return false;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[320];
    mysql_format(mysql, query, sizeof(query), "SELECT acs_id FROM accessories_players WHERE player_id = %d AND bone > 0 AND slot = %d LIMIT 1", account_id, active_slot);
    new Cache:active_result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] MoveActiveAccessory SELECT active failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, active_slot, query);
        cache_delete(active_result);
        return false;
    }

    if(cache_num_rows() <= 0)
    {
        cache_delete(active_result);
        return false;
    }

    new acs_id = cache_get_field_content_int(0, "acs_id");
    cache_delete(active_result);

    if(acs_id < 0 || acs_id >= sizeof(accessory))
    {
        printf("[INV11][ERROR] MoveActiveAccessory invalid acs_id=%d player=%d slot=%d", acs_id, playerid, active_slot);
        return false;
    }

    modelid = accessory[acs_id][ID_ACCESSORY];
    new inv_item_id = Inv11_GetAccItemByModel(modelid);
    if(inv_item_id <= 0) inv_item_id = item_id;

    mysql_format(mysql, query, sizeof(query), "SELECT 1 FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, inventory_slot);
    new Cache:slot_result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] MoveActiveAccessory SELECT target failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, inventory_slot, query);
        cache_delete(slot_result);
        return false;
    }

    if(cache_num_rows() > 0)
    {
        cache_delete(slot_result);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Слот инвентаря занят", " ");
        return false;
    }
    cache_delete(slot_result);

    // Accessory in inventory must have amount=1 and model in extra_1.
    mysql_format(mysql, query, sizeof(query), "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin, sim, oldsim) VALUES (%d, %d, 1, %d, 1, %d, 0, 0, 0, 0, 0)", account_id, inv_item_id, inventory_slot, modelid);
    mysql_query(mysql, query, false);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] MoveActiveAccessory INSERT inventory failed errno=%d account_id=%d item=%d slot=%d model=%d query=%s", mysql_errno(), account_id, inv_item_id, inventory_slot, modelid, query);
        return false;
    }

    mysql_format(mysql, query, sizeof(query), "DELETE FROM accessories_players WHERE player_id = %d AND slot = %d LIMIT 1", account_id, active_slot);
    mysql_query(mysql, query, false);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] MoveActiveAccessory DELETE active failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, active_slot, query);

        mysql_format(mysql, query, sizeof(query), "DELETE FROM inventory WHERE account_id = %d AND slot = %d AND item_id = %d LIMIT 1", account_id, inventory_slot, inv_item_id);
        mysql_query(mysql, query, false);
        return false;
    }

    if(IsPlayerAttachedObjectSlotUsed(playerid, active_slot))
    {
        RemovePlayerAttachedObject(playerid, active_slot);
    }



    printf("[INV11] MoveActiveAccessory success: player=%d item=%d model=%d active_slot=%d inv_slot=%d", playerid, inv_item_id, modelid, active_slot, inventory_slot);
    return true;
}

stock Inventory11_OpenAccessoryEditor(playerid, slot, acs_id, modelid, bone, Float:x, Float:y, Float:z, Float:rX, Float:rY, Float:rZ, Float:scale)
{
    for(new a; a < 12; a++) SendClientMessage(playerid, 0xFFFFFFFF, "");
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);

    SetPVarInt(playerid, "slot", slot);
    SetPVarInt(playerid, "acs_id", acs_id);
    SetPVarInt(playerid, "bone", bone);
    DeletePVar(playerid, "inv_acs_db_id");
    SetPVarInt(playerid, "edit_modelid", modelid);

    SetPVarFloat(playerid, "edit_x", x);
    SetPVarFloat(playerid, "edit_y", y);
    SetPVarFloat(playerid, "edit_z", z);
    SetPVarFloat(playerid, "edit_rX", rX);
    SetPVarFloat(playerid, "edit_rY", rY);
    SetPVarFloat(playerid, "edit_rZ", rZ);
    SetPVarFloat(playerid, "edit_scale", scale);

    HidePlayerGUI(playerid, 33);
    HidePlayerGUI(playerid, GUICarsTrunkOrCloset);
    HideHud(playerid);
    SelectTextDraw(playerid, 0xFF5252FF);

    for(new i; i < 11; i++) TextDrawShowForPlayer(playerid, acss_fix_TD[i]);
    TextDrawShowForPlayer(playerid, acss_fix_TD[17]);
    TextDrawShowForPlayer(playerid, acss_fix_TD[24]);
    TextDrawShowForPlayer(playerid, acss_fix_TD[25]);

    new acs_coords[18];
    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_x"));

    acss_coords_fix_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
    PlayerTextDrawLetterSize(playerid, acss_coords_fix_PTD[playerid][0], 0.3000, 1.6000);
    PlayerTextDrawAlignment(playerid, acss_coords_fix_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, acss_coords_fix_PTD[playerid][0], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, acss_coords_fix_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, acss_coords_fix_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, acss_coords_fix_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, acss_coords_fix_PTD[playerid][0], 0);
    SetPVarInt(playerid, "acss_coords_td_created", 1);
    PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);

    SetPVarInt(playerid, "acss_fix_TD_use", 1);
    TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
    AccessoryEditSetMovementLock(playerid, true);
    return 1;
}

stock bool:Inv11_OpenAccEditorBySlot(playerid, slot)
{
    if(slot < 1 || slot > INVENTORY11_MAX_ACTIVE_ACCESSORIES)
    {
        return false;
    }

    if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
    {
        return false;
    }

    new modelid = floatround(gPlayerTempAccData[playerid][slot][0]);
    new bone = floatround(gPlayerTempAccData[playerid][slot][1]);
    new Float:x = gPlayerTempAccData[playerid][slot][2];
    new Float:y = gPlayerTempAccData[playerid][slot][3];
    new Float:z = gPlayerTempAccData[playerid][slot][4];
    new Float:rX = gPlayerTempAccData[playerid][slot][5];
    new Float:rY = gPlayerTempAccData[playerid][slot][6];
    new Float:rZ = gPlayerTempAccData[playerid][slot][7];
    new Float:scale = gPlayerTempAccData[playerid][slot][8];

    if(scale <= 0.0) scale = 1.0;

    new acs_id = AccessoryGetIndexByModel(modelid);
    if(acs_id < 0 || acs_id >= sizeof(accessory))
    {
        return false;
    }

    Inventory11_OpenAccessoryEditor(playerid, slot, acs_id, modelid, bone, x, y, z, rX, rY, rZ, scale);
    return true;
}
stock bool:Inventory11_EquipAccessoryFromInventory(playerid, inventory_slot, item_id, &active_slot, &modelid)
{
    active_slot = 0;
    modelid = 0;

    if(!Inv11_GetAccModelBySlot(playerid, inventory_slot, item_id, modelid))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось прочитать аксессуар", " ");
        return false;
    }

    new slot_state = Inventory11_GetFreeActiveAccessorySlot(playerid, modelid, active_slot);
    if(slot_state == 2)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Этот аксессуар уже надет", " ");
        return false;
    }

    if(slot_state == 0 || active_slot < 1 || active_slot > INVENTORY11_MAX_ACTIVE_ACCESSORIES)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Можно надеть только 4 аксессуара", " ");
        return false;
    }

    new acs_id = AccessoryGetIndexByModel(modelid);
    if(acs_id < 0 || acs_id >= sizeof(accessory))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Неверная модель аксессуара", " ");
        return false;
    }

    new bone = accessory[acs_id][BONE_ACCESSORY];

    new Float:x = 0.01, Float:y = 0.01, Float:z = 0.01;
    new Float:rX = 0.01, Float:rY = 0.01, Float:rZ = 0.01;
    new Float:scale_x = 1.01, Float:scale_y = 1.01, Float:scale_z = 1.01;
    new bool:has_saved_transform = false;

    for(new temp_slot = 0; temp_slot < MAX_PLAYER_ATTACHED_OBJECTS; temp_slot++)
    {
        if(floatround(gPlayerTempAccData[playerid][temp_slot][0]) != modelid)
        {
            continue;
        }

        if(gPlayerTempAccData[playerid][temp_slot][8] <= 0.0)
        {
            continue;
        }

        bone = floatround(gPlayerTempAccData[playerid][temp_slot][1]);
        x = gPlayerTempAccData[playerid][temp_slot][2];
        y = gPlayerTempAccData[playerid][temp_slot][3];
        z = gPlayerTempAccData[playerid][temp_slot][4];
        rX = gPlayerTempAccData[playerid][temp_slot][5];
        rY = gPlayerTempAccData[playerid][temp_slot][6];
        rZ = gPlayerTempAccData[playerid][temp_slot][7];
        scale_x = gPlayerTempAccData[playerid][temp_slot][8];
        scale_y = gPlayerTempAccData[playerid][temp_slot][9];
        scale_z = gPlayerTempAccData[playerid][temp_slot][10];
        has_saved_transform = true;
        break;
    }

    if(!has_saved_transform)
    {
        new acc_index = FindAccsDataIndexByModel(modelid);
        if(acc_index != -1)
        {
            bone = AccsData[acc_index][accBone];
            x = AccsData[acc_index][accX];
            y = AccsData[acc_index][accY];
            z = AccsData[acc_index][accZ];
            rX = AccsData[acc_index][accRotX];
            rY = AccsData[acc_index][accRotY];
            rZ = AccsData[acc_index][accRotZ];
            scale_x = AccsData[acc_index][accScaleX];
            scale_y = AccsData[acc_index][accScaleY];
            scale_z = AccsData[acc_index][accScaleZ];
        }
    }
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[320];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM accessories_players WHERE player_id = %d AND slot = %d", account_id, active_slot);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] EquipAccessory delete slot failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, active_slot, query);
    }

    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO accessories_players (player_id, slot, bone, acs_id, x, y, z, rX, rY, rZ, scale) VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f)",
        account_id, active_slot, bone, acs_id, x, y, z, rX, rY, rZ, scale_x);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] EquipAccessory insert failed errno=%d account_id=%d slot=%d item=%d model=%d query=%s", mysql_errno(), account_id, active_slot, item_id, modelid, query);
        return false;
    }

    if(IsPlayerAttachedObjectSlotUsed(playerid, active_slot))
    {
        RemovePlayerAttachedObject(playerid, active_slot);
    }
	if (bone < 1 || modelid < 1){
		return false;
	}
if (bone >0 && modelid > 0){
    SetPlayerAttachedObject(playerid, active_slot, modelid, bone, x, y, z, rX, rY, rZ, scale_x, scale_y, scale_z);
}
    gPlayerTempAccData[playerid][active_slot][0] = float(modelid);
    gPlayerTempAccData[playerid][active_slot][1] = float(bone);
    gPlayerTempAccData[playerid][active_slot][2] = x;
    gPlayerTempAccData[playerid][active_slot][3] = y;
    gPlayerTempAccData[playerid][active_slot][4] = z;
    gPlayerTempAccData[playerid][active_slot][5] = rX;
    gPlayerTempAccData[playerid][active_slot][6] = rY;
    gPlayerTempAccData[playerid][active_slot][7] = rZ;
    gPlayerTempAccData[playerid][active_slot][8] = scale_x;
    gPlayerTempAccData[playerid][active_slot][9] = scale_y;
    gPlayerTempAccData[playerid][active_slot][10] = scale_z;


    return true;
}
stock Inventory11_AddItemToDatabase(playerid, item_id, model_id, amount, extra_1, extra_2)
{
    new account_id = GetPlayerAccountID(playerid);
    printf("[INV11][TRACE] AddItemToDatabase start: player=%d account_id=%d item=%d model=%d amount=%d extra_1=%d extra_2=%d errno_pre=%d", playerid, account_id, item_id, model_id, amount, extra_1, extra_2, mysql_errno());

    if(account_id <= 0)
    {
        printf("[INV11][ERROR] AddItemToDatabase skipped: invalid account_id=%d player=%d item=%d errno=%d", account_id, playerid, item_id, mysql_errno());
        return -1;
    }

    if(model_id <= 0)
    {
        model_id = item_id;
    }

    if(amount <= 0)
    {
        amount = 1;
    }


    if(!Inventory11_CanAddItemWeight(playerid, item_id, amount))
    {
        printf("[INV11][WARN] AddItemToDatabase blocked by weight: player=%d item=%d amount=%d current=%d max=%d", playerid, item_id, amount, Inventory11_GetCurrentWeightKg(playerid), Inventory11_GetMaxWeightKg(playerid));
        return -1;
    }
    new sim_value = 0;
    new oldsim_value = 0;
    if(item_id == 58)
    {
        oldsim_value = extra_1;
        if(oldsim_value <= 0) oldsim_value = model_id;
        sim_value = oldsim_value;

        model_id = oldsim_value;
        extra_1 = oldsim_value;
        extra_2 = 0;

        printf("[INV11][TRACE] AddItem SIM normalized: player=%d oldsim=%d sim=%d model=%d extra_1=%d extra_2=%d", playerid, oldsim_value, sim_value, model_id, extra_1, extra_2);
    }

    if(item_id == 22)
    {
        new stack_query[196];
        mysql_format(mysql, stack_query, sizeof(stack_query), "SELECT slot, amount FROM inventory WHERE account_id = %d AND item_id = 22 ORDER BY slot ASC LIMIT 1", account_id);
        printf("[INV11][SQL] AddItem medkit SELECT: %s", stack_query);
        new Cache:stack_result = mysql_query(mysql, stack_query, true);

        if(mysql_errno())
        {
            printf("[INV11][ERROR] AddItemToDatabase medkit SELECT failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, stack_query);
            cache_delete(stack_result);
            return -1;
        }

        printf("[INV11][TRACE] AddItem medkit SELECT rows=%d errno=%d", cache_num_rows(), mysql_errno());

        if(cache_num_rows() > 0)
        {
            new stack_slot = cache_get_field_content_int(0, "slot");
            new stack_amount = cache_get_field_content_int(0, "amount");
            cache_delete(stack_result);

            if(stack_amount <= 0) stack_amount = 0;
            new next_amount = stack_amount + amount;

            mysql_format(mysql, stack_query, sizeof(stack_query), "UPDATE inventory SET amount = %d, model_id = %d WHERE account_id = %d AND slot = %d LIMIT 1", next_amount, next_amount, account_id, stack_slot);
            printf("[INV11][SQL] AddItem medkit UPDATE: %s", stack_query);
            mysql_query(mysql, stack_query, true);

            if(mysql_errno())
            {
                printf("[INV11][ERROR] AddItemToDatabase medkit UPDATE failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, stack_slot, stack_query);
                return -1;
            }

            printf("[INV11][TRACE] Medkit stack updated: player=%d account_id=%d slot=%d amount=%d errno=%d", playerid, account_id, stack_slot, next_amount, mysql_errno());
            return stack_slot;
        }

        cache_delete(stack_result);
        model_id = amount;
    }

    new query[384];
    new next_slot = 0;
    new bool:used_slots[INVENTORY11_MAX_SLOTS + 1];

    for(new s = 1; s <= INVENTORY11_MAX_SLOTS; s++)
    {
        used_slots[s] = false;
    }

    mysql_format(mysql, query, sizeof(query), "SELECT slot FROM inventory WHERE account_id = %d AND slot BETWEEN 1 AND %d ORDER BY slot ASC", account_id, Inventory11_GetMaxSlots(playerid));
    printf("[INV11][SQL] AddItem SELECT slots: %s", query);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] AddItemToDatabase SELECT slots failed errno=%d account_id=%d item=%d query=%s", mysql_errno(), account_id, item_id, query);
        cache_delete(result);
        return -1;
    }

    new rows = cache_num_rows(result);
    printf("[INV11][TRACE] AddItem slots rows=%d errno=%d", rows, mysql_errno());

    for(new i = 0; i < rows; i++)
    {
        new slot_value = cache_get_field_content_int(i, "slot");
        if(slot_value >= 1 && slot_value <= Inventory11_GetMaxSlots(playerid))
        {
            used_slots[slot_value] = true;
        }
    }
    cache_delete(result);

    for(new s = 1; s <= Inventory11_GetMaxSlots(playerid); s++)
    {
        if(!used_slots[s])
        {
            next_slot = s;
            break;
        }
    }

    printf("[INV11][TRACE] AddItem selected slot=%d player=%d account_id=%d item=%d", next_slot, playerid, account_id, item_id);

    if(next_slot == 0)
    {
        printf("[INV11][ERROR] AddItemToDatabase failed: inventory full account_id=%d player=%d item=%d errno=%d", account_id, playerid, item_id, mysql_errno());
        return -1;
    }

    mysql_format(mysql, query, sizeof(query), "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin, sim, oldsim) VALUES (%d, %d, %d, %d, %d, %d, %d, 0, 0, %d, %d)", account_id, item_id, model_id, next_slot, amount, extra_1, extra_2, sim_value, oldsim_value);
    printf("[INV11][SQL] AddItem INSERT: %s", query);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] AddItemToDatabase INSERT failed errno=%d account_id=%d item=%d slot=%d query=%s", mysql_errno(), account_id, item_id, next_slot, query);
        return -1;
    }

    printf("[INV11] AddItemToDatabase success: player=%d account_id=%d item=%d slot=%d amount=%d extra_1=%d extra_2=%d errno=%d", playerid, account_id, item_id, next_slot, amount, extra_1, extra_2, mysql_errno());
    return next_slot;
}

stock bool:Inventory11_ConsumeMedkitBySlot(playerid, slot, &left_amount)
{
    left_amount = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT amount FROM inventory WHERE account_id = %d AND slot = %d AND item_id = 22 LIMIT 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] ConsumeMedkit SELECT failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) <= 0)
    {
        cache_delete(result);
        return false;
    }

    new current_amount = cache_get_field_content_int(0, "amount");
    cache_delete(result);

    if(current_amount <= 1)
    {
        mysql_format(mysql, query, sizeof(query), "DELETE FROM inventory WHERE account_id = %d AND slot = %d AND item_id = 22 LIMIT 1", account_id, slot);
        mysql_query(mysql, query, false);

        if(mysql_errno())
        {
            printf("[INV11][ERROR] ConsumeMedkit DELETE failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
            return false;
        }

        left_amount = 0;
        return true;
    }

    left_amount = current_amount - 1;
    mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET amount = %d, model_id = %d WHERE account_id = %d AND slot = %d AND item_id = 22 LIMIT 1", left_amount, left_amount, account_id, slot);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] ConsumeMedkit UPDATE failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        return false;
    }

    return true;
}
stock bool:Inventory11_GetSimBySlot(playerid, slot, &sim_number)
{
    sim_number = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT sim, oldsim, model_id, extra_1 FROM inventory WHERE account_id = %d AND slot = %d AND item_id = 58 LIMIT 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] GetSimBySlot failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) <= 0)
    {
        cache_delete(result);
        return false;
    }

    sim_number = cache_get_field_content_int(0, "oldsim");
    if(sim_number <= 0) sim_number = cache_get_field_content_int(0, "model_id");
    if(sim_number <= 0) sim_number = cache_get_field_content_int(0, "extra_1");
    if(sim_number <= 0) sim_number = cache_get_field_content_int(0, "sim");
    cache_delete(result);

    return (sim_number > 0);
}

stock bool:Inventory11_SetSimBySlot(playerid, slot, current_number)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[256];
    new inv_sim = 0;

    mysql_format(mysql, query, sizeof(query), "SELECT sim, oldsim, model_id, extra_1 FROM inventory WHERE account_id = %d AND slot = %d AND item_id = 58 LIMIT 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] SetSimBySlot SELECT failed errno=%d account_id=%d slot=%d current=%d query=%s", mysql_errno(), account_id, slot, current_number, query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) > 0)
    {
        inv_sim = cache_get_field_content_int(0, "oldsim");
        if(inv_sim <= 0) inv_sim = cache_get_field_content_int(0, "model_id");
        if(inv_sim <= 0) inv_sim = cache_get_field_content_int(0, "extra_1");
        if(inv_sim <= 0) inv_sim = cache_get_field_content_int(0, "sim");
    }
    cache_delete(result);

    if(inv_sim <= 0)
    {
        return false;
    }

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET sim = %d, oldsim = %d, model_id = %d, extra_1 = %d, extra_2 = %d WHERE account_id = %d AND slot = %d AND item_id = 58 LIMIT 1", inv_sim, current_number, current_number, current_number, inv_sim, account_id, slot);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] SetSimBySlot failed errno=%d account_id=%d slot=%d current=%d query=%s", mysql_errno(), account_id, slot, current_number, query);
        return false;
    }

    return true;
}


stock bool:Inventory11_IsSimNumberReserved(sim_number)
{
    if(sim_number <= 0) return true;

    // A SIM removed from an account for an active auction is still reserved.
    for(new slot; slot < MAX_AUCTION_SLOT; slot++)
    {
        if(auction_slot[slot][SLOT_TYPE] == TYPE_SUM_NUMBER && auction_slot[slot][NUMBER_SUM] == sim_number)
            return true;
    }

    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "SELECT id FROM accounts WHERE phone=%d OR sim=%d LIMIT 1",
        sim_number, sim_number);
    new Cache:account_result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][SIM][ERROR] reserve accounts check failed errno=%d number=%d query=%s", mysql_errno(), sim_number, query);
        cache_delete(account_result);
        return true;
    }

    new bool:reserved = (cache_num_rows(account_result) > 0);
    cache_delete(account_result);
    if(reserved) return true;

    // Do not use COALESCE here: legacy SIM rows can contain different historic
    // values in these columns, and the requested number may not be the first one.
    mysql_format(mysql, query, sizeof(query),
        "SELECT id FROM inventory WHERE item_id=58 AND (oldsim=%d OR model_id=%d OR extra_1=%d OR sim=%d OR extra_2=%d) LIMIT 1",
        sim_number, sim_number, sim_number, sim_number, sim_number);
    new Cache:inventory_result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][SIM][ERROR] reserve inventory check failed errno=%d number=%d query=%s", mysql_errno(), sim_number, query);
        cache_delete(inventory_result);
        return true;
    }

    reserved = (cache_num_rows(inventory_result) > 0);
    cache_delete(inventory_result);
    if(reserved) return true;

    // Covers active lots after a restart and the short interval before their
    // in-memory slots are restored.
    mysql_format(mysql, query, sizeof(query),
        "SELECT id FROM auction_lots WHERE item_type=%d AND item_database_id=%d AND status IN ('active','processing') LIMIT 1",
        TYPE_SUM_NUMBER, sim_number);
    new Cache:auction_result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][SIM][ERROR] reserve auction check failed errno=%d number=%d query=%s", mysql_errno(), sim_number, query);
        cache_delete(auction_result);
        return true;
    }

    reserved = (cache_num_rows(auction_result) > 0);
    cache_delete(auction_result);
    return reserved;
}

stock bool:Inventory11_PlayerHasPhoneDevice(playerid)
{
    if(GetPlayerPhone(playerid) > 0 || GetPlayerData(playerid, P_QUEST_2) > 0)
        return true;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return false;

    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT sim FROM accounts WHERE id = %d LIMIT 1", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][SIM][ERROR] phone device check failed errno=%d player=%d account=%d", mysql_errno(), playerid, account_id);
        cache_delete(result);
        return false;
    }

    new stored_sim = 0;
    if(cache_num_rows(result) > 0)
        stored_sim = cache_get_field_content_int(0, "sim");
    cache_delete(result);

    // V12 marker: phone exists, but the SIM tray is empty.
    return (stored_sim == -1);
}

stock bool:Inventory11_MoveActiveSimToInventorySlot(playerid, inventory_slot, &sim_number)
{
    sim_number = GetPlayerPhone(playerid);
    if(sim_number <= 0)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "В телефоне нет SIM-карты", " ");
        return false;
    }

    // The SIM equip slot is not a DB inventory row. If the dropped target is
    // invalid or occupied, use the first free inventory slot instead of
    // rejecting the removal and leaving the SIM stuck in the phone.
    if(inventory_slot < 1 || inventory_slot > Inventory11_GetMaxSlots(playerid) || TrunkTest_IsInventorySlotBusy(playerid, inventory_slot))
    {
        new fallback_slot = TrunkTest_GetFreeInventorySlot(playerid);
        if(fallback_slot < 1 || fallback_slot > Inventory11_GetMaxSlots(playerid))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Выберите свободный слот инвентаря", " ");
            return false;
        }
        printf("[INV11][SIM] active->inventory target fallback: player=%d requested=%d fallback=%d", playerid, inventory_slot, fallback_slot);
        inventory_slot = fallback_slot;
    }

    if(!Inventory11_CanAddItemWeight(playerid, 58, 1))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Превышен максимальный вес инвентаря", " ");
        return false;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return false;

    new query[384];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin, sim, oldsim) VALUES (%d, 58, %d, %d, 1, %d, 0, 0, 0, %d, %d)",
        account_id, sim_number, inventory_slot, sim_number, sim_number, sim_number);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][SIM][ERROR] active->inventory INSERT failed errno=%d player=%d number=%d slot=%d query=%s", mysql_errno(), playerid, sim_number, inventory_slot, query);
        return false;
    }

    mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET phone = 0, sim = -1 WHERE id = %d LIMIT 1", account_id);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        mysql_format(mysql, query, sizeof(query), "DELETE FROM inventory WHERE account_id = %d AND slot = %d AND item_id = 58 LIMIT 1", account_id, inventory_slot);
        mysql_query(mysql, query, false);
        printf("[INV11][SIM][ERROR] active->inventory account update failed player=%d number=%d slot=%d", playerid, sim_number, inventory_slot);
        return false;
    }

    SetPlayerData(playerid, P_PHONE, 0);
    printf("[INV11][SIM] active->inventory success player=%d number=%d slot=%d", playerid, sim_number, inventory_slot);
    return true;
}

stock bool:Inventory11_AddSkinToInventory(playerid, modelid, source_internal_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        printf("[INV11][ERROR] AddSkinToInventory skipped: invalid account_id=%d player=%d model=%d", account_id, playerid, modelid);
        return false;
    }

    if(modelid <= 0 || !IsValidSkinModel(modelid))
    {
        printf("[INV11][ERROR] AddSkinToInventory skipped: invalid model=%d player=%d", modelid, playerid);
        return false;
    }


    if(!Inventory11_CanAddItemWeight(playerid, 134, 1))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Инвентарь переполнен, освободите место", " ");
        return false;
    }
    new query[384];
    new next_slot = 1;

    mysql_format(mysql, query, sizeof(query), "SELECT IFNULL(MAX(slot), 0) + 1 AS next_slot FROM inventory WHERE account_id = %d", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] AddSkinToInventory SELECT failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) > 0)
    {
        next_slot = cache_get_field_content_int(0, "next_slot");
    }
    cache_delete(result);

    mysql_format(mysql, query, sizeof(query), "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin) VALUES (%d, 134, %d, %d, 1, 0, 0, %d, 0)", account_id, modelid, next_slot, source_internal_id);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] AddSkinToInventory INSERT failed errno=%d account_id=%d model=%d slot=%d query=%s", mysql_errno(), account_id, modelid, next_slot, query);
        return false;
    }

    Inventory11_SetSkinModelByPos(playerid, next_slot, modelid);
    printf("[INV11] AddSkinToInventory success: player=%d account_id=%d model=%d slot=%d src=%d", playerid, account_id, modelid, next_slot, source_internal_id);
    return true;
}

stock Inventory11_SaveDonatSkinToDatabase(playerid, internal_id, modelid)
{
    new account_id = GetPlayerAccountID(playerid);

    if(!Inventory11_CanAddItemWeight(playerid, 134, 1))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Инвентарь переполнен, освободите место", " ");
        return 0;
    }
    if(account_id <= 0)
    {
        printf("[INV11][ERROR] BuyPlayerSkin skipped save: invalid account_id=%d player=%d model=%d", account_id, playerid, modelid);
        return 0;
    }

    new query[384];
    new next_slot = 1;
    new bool:inventory_saved = true;

    mysql_format(mysql, query, sizeof(query), "SELECT IFNULL(MAX(slot), 0) + 1 AS next_slot FROM inventory WHERE account_id = %d", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] SELECT inventory next_slot failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, query);
        inventory_saved = false;
    }
					else if(cache_num_rows(result) > 0)
    {
        next_slot = cache_get_field_content_int(0, "next_slot");
    }
    cache_delete(result);

    if(inventory_saved)
    {
        mysql_format(mysql, query, sizeof(query), "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin) VALUES (%d, 134, %d, %d, 1, 0, 0, %d, 0)", account_id, modelid, next_slot, internal_id);
        mysql_query(mysql, query, false);

        if(mysql_errno())
        {
            printf("[INV11][ERROR] INSERT inventory failed errno=%d account_id=%d model=%d slot=%d query=%s", mysql_errno(), account_id, modelid, next_slot, query);
            inventory_saved = false;
        }
    }

    mysql_format(mysql, query, sizeof(query), "INSERT INTO invskins (account_id, internal_id, modelid) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE modelid = VALUES(modelid), purchased_at = CURRENT_TIMESTAMP", account_id, internal_id, modelid);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] UPSERT invskins failed errno=%d account_id=%d internal_id=%d model=%d query=%s", mysql_errno(), account_id, internal_id, modelid, query);
    }

    printf("[INV11] Saved donated skin: player=%d account_id=%d internal_id=%d item=134 model=%d slot=%d inventory_saved=%d", playerid, account_id, internal_id, modelid, next_slot, inventory_saved);
    return 1;
}

stock Inventory11_MoveSkinToInventorySlot(playerid, slot, modelid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        printf("[INV11][ERROR] Move active skin skipped: invalid account_id=%d player=%d slot=%d model=%d", account_id, playerid, slot, modelid);
        return 0;
    }

    if(modelid <= 0)
    {
        printf("[INV11][WARN] Move active skin skipped: invalid model=%d player=%d slot=%d", modelid, playerid, slot);
        return 0;
    }

    new query[512];

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET item_id = 134, old_skin = %d, amount = 1, extra_1 = 0, extra_2 = 0 WHERE account_id = %d AND slot = %d LIMIT 1", modelid, account_id, slot);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] MOVE active skin update-slot failed errno=%d account_id=%d slot=%d model=%d query=%s", mysql_errno(), account_id, slot, modelid, query);
        return 0;
    }

    mysql_format(mysql, query, sizeof(query), "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin) SELECT %d, 134, %d, %d, 1, 0, 0, %d, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1)", account_id, modelid, slot, modelid, account_id, slot);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] MOVE active skin insert-fallback failed errno=%d account_id=%d slot=%d model=%d query=%s", mysql_errno(), account_id, slot, modelid, query);
        return 0;
    }

    Inventory11_SetSkinModelByPos(playerid, slot, modelid);
    printf("[INV11] Active skin persisted in inventory slot: player=%d account_id=%d slot=%d model=%d", playerid, account_id, slot, modelid);
    return 1;
}
stock Inventory11_SwapSlotsInDatabase(playerid, old_slot, new_slot)
{
    if(old_slot == new_slot)
    {
        return 1;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        printf("[INV11][ERROR] Slot move skipped: invalid account_id=%d player=%d old=%d new=%d", account_id, playerid, old_slot, new_slot);
        return 0;
    }

    new query[196];
    new temp_slot = 500000 + old_slot;

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET slot = %d WHERE account_id = %d AND slot = %d", temp_slot, account_id, old_slot);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] MOVE step1 failed errno=%d account_id=%d old=%d new=%d query=%s", mysql_errno(), account_id, old_slot, new_slot, query);
        return 0;
    }

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET slot = %d WHERE account_id = %d AND slot = %d", old_slot, account_id, new_slot);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] MOVE step2 failed errno=%d account_id=%d old=%d new=%d query=%s", mysql_errno(), account_id, old_slot, new_slot, query);
        return 0;
    }

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET slot = %d WHERE account_id = %d AND slot = %d", new_slot, account_id, temp_slot);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] MOVE step3 failed errno=%d account_id=%d old=%d new=%d query=%s", mysql_errno(), account_id, old_slot, new_slot, query);
        return 0;
    }

    if(!Inventory11_SwapPlateDataSlots(playerid, old_slot, new_slot))
    {
        printf("[INV11][WARN] Plate slot sync failed: player=%d old=%d new=%d", playerid, old_slot, new_slot);
    }

    new old_pvar[24], new_pvar[24];
    new old_has_skin = 0, new_has_skin = 0;
    new old_skin_model = -1, new_skin_model = -1;

    format(old_pvar, sizeof(old_pvar), "inv11_skin_%d", old_slot);
    format(new_pvar, sizeof(new_pvar), "inv11_skin_%d", new_slot);

    if(GetPVarType(playerid, old_pvar))
    {
        old_has_skin = 1;
        old_skin_model = GetPVarInt(playerid, old_pvar);
    }

    if(GetPVarType(playerid, new_pvar))
    {
        new_has_skin = 1;
        new_skin_model = GetPVarInt(playerid, new_pvar);
    }

    if(old_has_skin)
    {
        SetPVarInt(playerid, new_pvar, old_skin_model);
    }
					else if(GetPVarType(playerid, new_pvar))
    {
        DeletePVar(playerid, new_pvar);
    }

    if(new_has_skin)
    {
        SetPVarInt(playerid, old_pvar, new_skin_model);
    }
					else if(GetPVarType(playerid, old_pvar))
    {
        DeletePVar(playerid, old_pvar);
    }

    printf("[INV11] Slot move synced: player=%d old=%d new=%d old_skin=%d new_skin=%d", playerid, old_slot, new_slot, old_skin_model, new_skin_model);
    return 1;
}

stock Inventory11_DeleteSlotFromDatabase(playerid, slot)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        printf("[INV11][ERROR] Delete slot skipped: invalid account_id=%d player=%d slot=%d", account_id, playerid, slot);
        return 0;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM inventory WHERE account_id = %d AND slot = %d", account_id, slot);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] DELETE slot failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        return 0;
    }

    Inventory11_DeletePlateData(playerid, slot);

    new pvar_name[24];
    format(pvar_name, sizeof(pvar_name), "inv11_skin_%d", slot);
    if(GetPVarType(playerid, pvar_name))
    {
        DeletePVar(playerid, pvar_name);
    }

    printf("[INV11] Slot deleted from DB: player=%d account_id=%d slot=%d", playerid, account_id, slot);
    return 1;
}
public: BuyPlayerSkin(playerid, internal_id, game_id)
{
    printf("[INV11] BuyPlayerSkin start: player=%d internal_id=%d model_id=%d", playerid, internal_id, game_id);

    if(!Inventory11_SaveDonatSkinToDatabase(playerid, internal_id, game_id))
    {
        printf("[INV11][WARN] BuyPlayerSkin blocked: player=%d internal_id=%d model_id=%d", playerid, internal_id, game_id);
        return 0;
    }

    printf("[INV11] BuyPlayerSkin complete (not equipped): player=%d model_id=%d", playerid, game_id);
    return 1;
}

stock Inventory11_SendSkinUpdatePacket(playerid, modelid)
{
    new JSON:skin_response = JSON_Object();
    JSON_SetInt(skin_response, "t", 33);
    JSON_SetInt(skin_response, "s", 1);
    JSON_SetInt(skin_response, "ps", modelid);

    Inventory11_SetAiArrayOnJson(playerid, skin_response);

    OnPacketIncoming(playerid, 33, skin_response);
    JSON_Cleanup(skin_response);
    return 1;
}

stock ShowClientNotification(playerid, type, duration, id, sub_id, message[])
{
    new JSON:json_notification_data = JSON:JSON_Object();

    JSON_SetInt(json_notification_data, "o", 1);
    JSON_SetInt(json_notification_data, "t", type);
    JSON_SetInt(json_notification_data, "d", duration);
    JSON_SetInt(json_notification_data, "s", id);
    JSON_SetInt(json_notification_data, "b", sub_id);

    JSON_SetString(json_notification_data, "i", message, strlen(message));


    OnPacketIncoming(playerid, 13, json_notification_data);
}
stock Float:frandom(Float:max)
{
    return float(random(10000)) / 10000.0 * max;
}

stock OpenCase10(playerid, case_id)
{
    new case_sizes[] = {
    20, // case 1
    28, // case 2
    36, // case 3
    31, // case 4
    20, // case 5
    25, // case 6
    24, // case 7
    25, // case 8
    25, // case 9
    25, // case 10
    25, // case 11
    25, // case 12
    25, // case 13
    25, // case 14
    25, // case 15
    25, // case 16
    25, // case 17
    25, // case 18
    25, // case 19
    25, // case 20
    25, // case 21
    25, // case 22
    25, // case 23
    25,  // case 24 (пустой)
    25, // case 25 (АВТО-КЕЙС 3.0)
    6,  // case 26 (КЕЙС С БИЛЕТАМИ ГОНЩИКА)
    53, // case 27 (АВТО-КЕЙС B-C CLASS)
    32, // case 28 (АВТО-КЕЙС A-S CLASS)
    25, // case 29 (КЕЙС: ЖАРА)
    25  // case 30 (КЕЙС: ПЕКЛО)
};

new Float:chances[][] = {
   {0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05}, // case 1
   {0.029,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.009,0.009,0.005,0.009,0.005,0.009,0.005}, // case 2
   {0.046,0.047,0.047,0.047,0.047,0.024,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.024,0.024,0.024,0.012,0.012,0.012,0.012,0.012,0.012,0.012,0.006,0.006,0.006,0.005,0.01,0.01,0.01,0.01,0.003,0.003}, // case 3
   {0.059,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.008,0.008,0.008,0.008,0.008,0.004,0.004,0.002,0.002,0.001,0.001}, // case 4
   {0.089,0.089,0.089,0.089,0.006,0.089,0.089,0.089,0.089,0.089,0.089,0.016,0.016,0.016,0.016,0.016,0.006,0.006,0.006,0.006}, // case 5
   {0.067,0.067,0.067,0.067,0.033,0.067,0.067,0.067,0.067,0.067,0.067,0.033,0.033,0.027,0.027,0.027,0.027,0.027,0.013,0.027,0.014,0.014,0.014,0.008,0.006}, // case 6
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 7
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 8
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 9
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 10
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 11
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 12
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 13
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 14
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 15
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 16
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 17
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 18
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 19
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 20
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 21
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 22
   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 23

   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 24 (пустой)

   {0.010,0.010,0.010,0.010,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.02,0.02,0.02,0.02,0.08,0.08,0.08,0.05,0.05,0.05,0.05}, // case 25
{0.40,0.24,0.16,0.10,0.07,0.03}, // case 26
{0.05,0.05,0.05,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.015,0.015,0.015,0.015,0.015,0.015,0.01,0.01,0.01,0.01,0.01,0.01,0.008,0.008,0.008,0.008,0.004,0.004,0.003,0.002}, // case 27
 {0.11,0.09,0.08,0.07,0.065,0.06,0.055,0.05,0.045,0.04,0.035,0.025,0.023,0.021,0.019,0.017,0.015,0.013,0.012,0.011,0.01,0.009,0.008,0.007,0.006,0.005,0.004,0.003,0.0025,0.002,0.0015,0.001}, // case 28 // case 28
 {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 29
 {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005} // case 30
};

    new prizes[10];
    new case_data_index = ResolveCaseDataIndex(case_id - 1);
    if (case_data_index < 0 || case_data_index >= sizeof(case_sizes)) return 0;

    // Выбираем 10 случайных призов
    for (new j = 0; j < 10; j++)
    {
        new Float:rand = frandom(1.0);
        new prize_id = -1;
        new Float:cumulative = 0.0;

        if (case_id >= 6 && case_id <= 11)
        {
            prize_id = random(case_sizes[case_data_index]) + 1;
        }
        else
        {
            for (new i = 0; i < case_sizes[case_data_index]; i++)
            {
                cumulative += chances[case_data_index][i];
                if (rand <= cumulative)
                {
                    prize_id = i + 1;
                    break;
                }
            }
        }

        if (prize_id == -1) prize_id = 1;
        prizes[j] = prize_id;
    }

    // Формируем JSON-строку для массива призов
    new prStr[512];
    prStr[0] = '\0';
    strcat(prStr, "[", sizeof(prStr));
    for (new i = 0; i < 10; i++)
    {
        format(prStr[strlen(prStr)], sizeof(prStr)-strlen(prStr), "%d%s", prizes[i], (i<9)?"," : "");
    }
    strcat(prStr, "]", sizeof(prStr));

    // Парсим строку в JSON массив
    new JSON:prArray = JSON_Array();
    JSON_Parse(prStr, prArray);

    // Создаём response
    new JSON:response = JSON_Object();
    JSON_SetInt(response, "t", 2);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "s", 1);
    JSON_SetArray(response, "pr", prArray);

    OnPacketIncoming(playerid, 73, response);

    // Очистка
    JSON_Cleanup(response);

    // Лог в консоль
    printf("[Case] Player %d opened case %d -> rewards: ", playerid, case_id);
    for (new i = 0; i < 10; i++) printf("%d ", prizes[i]);
    printf("\n");

    return 1;
}


enum E_CASE_AWARD_NUM {
	CA_ID, CA_RARITY, CA_TYPE, CA_INTERNALID, CA_COUNT, CA_PRICESPRAYED
};

const CASE_COUNT = 30;
const MAX_CASE_ITEMS = 60;
const CA_NAME_LEN = 64;

