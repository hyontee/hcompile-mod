/*
 * Full Fix Inventory V3 adapter.
 *
 * Client protocol/layout is based on the supplied Inventory.inc:
 *   - 40 regular slots (client indexes 0..39)
 *   - 8 active slots
 *   - skin in active slot 6
 *   - SIM in active slot 0
 *   - GUI 33 protocol version 3
 *   - nested four-value arrays in `it` and `ai`
 *
 * Persistence intentionally stays on Full Fix's existing tables (`inventory`,
 * `inventory_plates`, `accessories_players`) so Marketplace, trunk, donate,
 * cases and existing player items all keep using one source of truth.
 */

#define FULLFIX_INV_CLIENT_SLOTS   (40)
#define FULLFIX_INV_ACTIVE_SLOTS   (8)
#define FULLFIX_INV_SIM_SLOT       (0)
#define FULLFIX_INV_SKIN_SLOT      (6)
#define FULLFIX_INV_PROTOCOL       (3)
#define FULLFIX_INV_SCREEN         (79)

// In-memory cache of equipped accessories (item_id, model_id per active slot).
// Populated once via InventoryV3_LoadActiveAccessoriesCache (call this from
// OnPlayerSpawn / after login, next to LoadAccessory), then BuildActiveArray
// just reads memory instead of re-querying accessories_players every /inv.
new g_V3ActiveAccItem[MAX_PLAYERS][FULLFIX_INV_ACTIVE_SLOTS];
new g_V3ActiveAccModel[MAX_PLAYERS][FULLFIX_INV_ACTIVE_SLOTS];
new bool:g_V3ActiveAccCacheReady[MAX_PLAYERS];

stock InventoryV3_LoadActiveAccessoriesCache(playerid)
{
    g_V3ActiveAccCacheReady[playerid] = false;
    for(new i = 0; i < FULLFIX_INV_ACTIVE_SLOTS; i++)
    {
        g_V3ActiveAccItem[playerid][i] = 0;
        g_V3ActiveAccModel[playerid][i] = 0;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        g_V3ActiveAccCacheReady[playerid] = true;
        return 0;
    }

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "SELECT slot, bone, acs_id FROM accessories_players WHERE player_id = %d AND slot >= 1 AND slot <= 7 AND slot != 6 ORDER BY slot ASC",
        account_id);
    mysql_tquery(mysql, query, "OnInventoryV3_ActiveAccessoriesLoaded", "i", playerid);
    return 1;
}

forward OnInventoryV3_ActiveAccessoriesLoaded(playerid);
public OnInventoryV3_ActiveAccessoriesLoaded(playerid)
{
    new rows = cache_num_rows();
    printf("[INVENTORY_V3] active accessories cache loaded: player=%d rows=%d", playerid, rows);

    for(new i = 0; i < rows; i++)
    {
        new active_slot = cache_get_field_content_int(i, "slot");
        new acs_id = cache_get_field_content_int(i, "acs_id");

        if(!InvV3_IsActiveAccSlot(active_slot))
        {
            continue;
        }
        if(acs_id < 1 || acs_id >= sizeof(accessory))
        {
            continue;
        }

        new modelid = accessory[acs_id][ID_ACCESSORY];
        new item_id = Inv11_GetAccItemByModel(modelid);

        // Some old /acs items have no explicit mapping entry. Use the real
        // accessory model as the client item id when it is a known accessory.
        if(item_id <= 0 && modelid > 0)
        {
            if(AccessoryGetIndexByModel(modelid) != -1 || FindAccsDataIndexByModel(modelid) != -1)
            {
                item_id = modelid;
            }
        }

        if(item_id <= 0)
        {
            printf("[INVENTORY_V3][WARN] no item_id mapping for accessory model=%d (acs_id=%d), slot skipped: player=%d slot=%d",
                modelid, acs_id, playerid, active_slot);
            continue;
        }

        g_V3ActiveAccItem[playerid][active_slot] = item_id;
        g_V3ActiveAccModel[playerid][active_slot] = modelid;
        printf("[INVENTORY_V3] cached active slot: player=%d slot=%d item=%d model=%d", playerid, active_slot, item_id, modelid);
    }

    g_V3ActiveAccCacheReady[playerid] = true;
    return 1;
}

stock InventoryV3_ClientToDbSlot(client_slot)
{
    if(client_slot < 0 || client_slot >= FULLFIX_INV_CLIENT_SLOTS)
    {
        return -1;
    }
    return client_slot + 1;
}

stock InventoryV3_DbToClientSlot(db_slot)
{
    if(db_slot < 1 || db_slot > FULLFIX_INV_CLIENT_SLOTS)
    {
        return -1;
    }
    return db_slot - 1;
}

stock bool:InvV3_IsActiveAccSlot(slot)
{
    return (slot >= 1 && slot < FULLFIX_INV_ACTIVE_SLOTS && slot != FULLFIX_INV_SKIN_SLOT);
}

stock bool:InventoryV3_HasRegularItemAtClientSlot(playerid, client_slot, item_id)
{
    new db_slot = InventoryV3_ClientToDbSlot(client_slot);
    if(db_slot == -1)
    {
        return false;
    }
    return Inventory11_HasInventoryItemInSlot(playerid, db_slot, item_id);
}

stock InventoryV3_GetSkinModelAtClientSlot(playerid, client_slot)
{
    new db_slot = InventoryV3_ClientToDbSlot(client_slot);
    if(db_slot == -1)
    {
        return -1;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return -1;
    }

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT old_skin, model_id FROM inventory WHERE account_id = %d AND slot = %d AND item_id = 134 LIMIT 1",
        account_id, db_slot
    );

    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[INVENTORY_V3][ERROR] GetSkinModelAtClientSlot failed: player=%d account=%d client_slot=%d db_slot=%d errno=%d",
            playerid, account_id, client_slot, db_slot, mysql_errno());
        cache_delete(result);
        return -1;
    }

    if(cache_num_rows() <= 0)
    {
        cache_delete(result);
        return -1;
    }

    new modelid = cache_get_field_content_int(0, "model_id");
    // `model_id` is the canonical skin model in the current inventory schema.
    // `old_skin` is legacy/previous-skin metadata and must NOT override it.
    if((modelid <= 0 || !IsValidSkinModel(modelid)))
    {
        new legacy_skin = cache_get_field_content_int(0, "old_skin");
        if(legacy_skin > 0 && IsValidSkinModel(legacy_skin))
        {
            modelid = legacy_skin;
        }
    }

    cache_delete(result);

    if(modelid <= 0 || !IsValidSkinModel(modelid))
    {
        return -1;
    }

    return modelid;
}

stock Node:InventoryV3_BuildActiveArray(playerid)
{
    // GUI 16.21 expects `ai` as ONE FLAT JSON ARRAY.
    // Each active item is exactly four consecutive values:
    // [item_id, model/value, active_slot, 0, ...]
    // Do NOT append a JSON_Array() as an element: that creates nested arrays
    // and the client silently leaves the equipped cells empty.
    new Node:activeSlotsArray = JSON_Array();

    // The SIM card is supplied by `nm` and must NOT be synthesized here.
    // This matches the working Black Russia inventory protocol.

    // Currently worn skin: item 134, actual skin model, protocol slot 6.
    new current_skin = GetPlayerSkin(playerid);
    if(current_skin > 0)
    {
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(134));
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(current_skin));
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(FULLFIX_INV_SKIN_SLOT));
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(0));
    }

    // Equipped accessories are stored in accessories_players and are also
    // reflected by the attached-object cache. Keep the existing 1..7 slot
    // support, excluding skin slot 6.
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return activeSlotsArray;
    }

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "SELECT slot, acs_id FROM accessories_players WHERE player_id = %d AND slot >= 1 AND slot <= 7 AND slot != 6 AND bone > 0 ORDER BY slot ASC",
        account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INVENTORY_V3][ERROR] BuildActiveArray failed: player=%d account=%d errno=%d", playerid, account_id, mysql_errno());
        cache_delete(result);
        return activeSlotsArray;
    }

    new rows = cache_num_rows();
    for(new i = 0; i < rows; i++)
    {
        new active_slot = cache_get_field_content_int(i, "slot");
        new acs_id = cache_get_field_content_int(i, "acs_id");

        if(!InvV3_IsActiveAccSlot(active_slot)) continue;
        if(acs_id < 1 || acs_id >= sizeof(accessory)) continue;

        new modelid = accessory[acs_id][ID_ACCESSORY];
        if(modelid <= 0) continue;

        new item_id = Inv11_GetAccItemByModel(modelid);
        if(item_id <= 0)
        {
            // /acs uses accessory index + 1 for some legacy items.
            item_id = acs_id + 1;
        }
        if(item_id <= 0) continue;

        g_V3ActiveAccItem[playerid][active_slot] = item_id;
        g_V3ActiveAccModel[playerid][active_slot] = modelid;

        // IMPORTANT: append four integers directly to the root array.
        // The previous code appended tempArray, producing [[...],[...]].
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(item_id));
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(modelid));
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(active_slot));
        activeSlotsArray = JSON_Append(activeSlotsArray, JSON_Int(0));
    }

    cache_delete(result);
    return activeSlotsArray;
}

// Call this whenever equip/unequip changes an active accessory slot,
// so the in-memory cache stays in sync with accessories_players.
stock InventoryV3_SetActiveAccessoryCache(playerid, active_slot, item_id, modelid)
{
    if(active_slot < 0 || active_slot >= FULLFIX_INV_ACTIVE_SLOTS) return 0;
    g_V3ActiveAccItem[playerid][active_slot] = item_id;
    g_V3ActiveAccModel[playerid][active_slot] = modelid;
    return 1;
}

stock InventoryV3_UpdateSkinSlot(playerid)
{
    new Node:skin_response = JSON_Object();

    // Build the FULL active array (skin + all equipped accessories),
    // otherwise every skin refresh (incl. every spawn) wipes the
    // accessories out of the sidebar/phone preview on the client.
    new Node:aiResponse = InventoryV3_BuildActiveArray(playerid);

    JSON_SetInt(skin_response, "s", 1);
    JSON_SetInt(skin_response, "ps", GetPlayerSkin(playerid));
    JSON_SetArray(skin_response, "ai", aiResponse);

    OnPacketIncoming(playerid, 33, skin_response);

    JSON_Cleanup(skin_response);
    return 1;
}


stock ShowPlayerInventoryV3(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        ShowNotificationLaird(playerid, 2, 6, 0, 0, "\xc2\xfb \xe2 \xf2\xf0\xe0\xed\xf1\xef\xee\xf0\xf2\xe5.", " ");
        return 1;
    }

    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = InventoryV3_BuildActiveArray(playerid);
    new Node:JSONObject = JSON_Object();
    new Node:tempArray;

    Inventory11_ResetSkinSlots(playerid);

    new account_id = GetPlayerAccountID(playerid);
    if(account_id > 0)
    {
        new query[320];
        mysql_format(mysql, query, sizeof(query),
            "SELECT item_id, model_id, old_skin, slot, amount, extra_1, extra_2, sim, oldsim FROM inventory WHERE account_id = %d AND slot >= 1 AND slot <= %d ORDER BY slot ASC",
            account_id, FULLFIX_INV_CLIENT_SLOTS);
        new Cache:result = mysql_query(mysql, query, true);

        if(!mysql_errno())
        {
            new rows = cache_num_rows();
            for(new i = 0; i < rows; i++)
            {
                // Plate lookup performs another query, so reactivate this cache each loop.
                cache_set_active(result);

                new item_id = cache_get_field_content_int(i, "item_id");
                new model_id = cache_get_field_content_int(i, "model_id");
                new old_skin = cache_get_field_content_int(i, "old_skin");
                new db_slot = cache_get_field_content_int(i, "slot");
                new amount = cache_get_field_content_int(i, "amount");
                new extra_1 = cache_get_field_content_int(i, "extra_1");
                new sim_value = cache_get_field_content_int(i, "sim");
                new oldsim_value = cache_get_field_content_int(i, "oldsim");
                new client_slot = InventoryV3_DbToClientSlot(db_slot);

                if(client_slot == -1 || item_id <= 0)
                {
                    continue;
                }
                if(amount <= 0)
                {
                    amount = 1;
                }

                // Recover old plate rows where model was accidentally written as item id.
                if(!Inventory11_IsPlateItem(item_id))
                {
                    new remap_item = PlateModelToItemId(item_id);
                    if(remap_item == -1)
                    {
                        remap_item = PlateModelToItemId(model_id);
                    }
                    if(remap_item != -1)
                    {
                        item_id = remap_item;
                    }
                }

                if(Inventory11_IsPlateItem(item_id))
                {
                    new plate_type = PlateCountryToType(PlateItemIdToCountry(item_id));
                    new plate[16], region[8], plate_text[32];
                    if(Inventory11_GetPlateData(playerid, db_slot, plate_type, plate, sizeof(plate), region, sizeof(region)))
                    {
                        Inv11Trade_BuildPlateText(plate_type, plate, region, plate_text, sizeof(plate_text));
                        tempArray = JSON_Array(
                            JSON_Int(PlateTypeToItemId(plate_type)),
                            JSON_String(plate_text),
                            JSON_Int(client_slot),
                            JSON_Int(0)
                        );
                        itemsArray = JSON_Append(itemsArray, tempArray);
                        continue;
                    }
                }

                new item_count = amount;
                if(item_id == 134)
                {
                    // Current DB schema stores the actual skin model in model_id.
                    // old_skin is previous/legacy metadata and must not replace it.
                    item_count = model_id;
                    if(item_count <= 0 || !IsValidSkinModel(item_count))
                    {
                        if(old_skin > 0 && IsValidSkinModel(old_skin)) item_count = old_skin;
                    }
                    Inventory11_SetSkinModelByPos(playerid, client_slot, item_count);
                }
                else if(item_id == 58)
                {
                    item_count = (oldsim_value > 0) ? oldsim_value : ((model_id > 0) ? model_id : extra_1);
                    if(item_count <= 0)
                    {
                        item_count = (sim_value > 0) ? sim_value : 1;
                    }
                }
                else if(Inventory11_IsAccessoryItem(item_id))
                {
                    // The second value is rendered by the 16.21 client as the
                    // quantity badge. Do NOT send the accessory model here:
                    // otherwise the inventory displays values like 7729,
                    // 14574, 14593 instead of the real amount (usually 1).
                    // The actual accessory model remains stored in DB extra_1
                    // / model_id and is used by equip/trade code separately.
                    item_count = amount;
                    if(item_count <= 0) item_count = 1;
                }

                tempArray = JSON_Array(
                    JSON_Int(item_id),
                    JSON_Int(item_count),
                    JSON_Int(client_slot),
                    JSON_Int(0)
                );
                itemsArray = JSON_Append(itemsArray, tempArray);
            }
        }
        else
        {
            printf("[INVENTORY_V3][ERROR] inventory load failed: player=%d account=%d errno=%d", playerid, account_id, mysql_errno());
        }
        cache_delete(result);
    }

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "i", 0);
    JSON_SetString(JSONObject, "n", name);
    JSON_SetInt(JSONObject, "lv", GetPlayerLevel(playerid));
    JSON_SetInt(JSONObject, "id", playerid);
    JSON_SetInt(JSONObject, "v", FULLFIX_INV_PROTOCOL);
    JSON_SetInt(JSONObject, "ps", GetPlayerSkin(playerid));
    JSON_SetInt(JSONObject, "m", GetPlayerMoney(playerid));
    JSON_SetInt(JSONObject, "s", FULLFIX_INV_SCREEN);
    JSON_SetInt(JSONObject, "w", Inventory11_GetCurrentWeightKg(playerid));
    JSON_SetInt(JSONObject, "mw", Inventory11_GetMaxWeightKg(playerid));
    JSON_SetInt(JSONObject, "sl", FULLFIX_INV_CLIENT_SLOTS);
    JSON_SetInt(JSONObject, "nm", GetPlayerPhone(playerid));
    JSON_SetString(JSONObject, "en", "");
    JSON_SetArray(JSONObject, "it", itemsArray);
    JSON_SetArray(JSONObject, "ai", activeSlotsArray);

    ShowPlayerGUI(playerid, 33, JSONObject);
    return 1;
}

stock ShowPlayerNewInventoryV3(playerid)
{
    return ShowPlayerInventoryV3(playerid);
}
