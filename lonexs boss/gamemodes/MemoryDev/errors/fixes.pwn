// инв

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
        sim_value = GetPlayerPhone(playerid);
        if(sim_value <= 0) sim_value = oldsim_value;

        model_id = oldsim_value;
        extra_1 = oldsim_value;
        extra_2 = sim_value;

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

    new rows = cache_num_rows();
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

    if(Inventory11_IsAccessoryItem(modelid))
    {
        return modelid;
    }

    return -1;
}

// рекон

stock bool:Spectate_CanWatchPlayer(adminid, targetid)
{
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return false;
    if(GetPlayerSecretEx(targetid) >= 1) return false;

    if(adminid != INVALID_PLAYER_ID && GetPlayerAdminEx(targetid) >= 13 && GetPlayerAdminEx(adminid) < 13)
    {
        return false;
    }

    return true;
}

stock ShowSpectateGUI(playerid, targetid, bool:refresh_only = false)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return 0;

    new target_name[MAX_PLAYER_NAME];
    new Float:hp, Float:armor, Float:speed, ping, money, vehicleid, level;
    
    GetPlayerName(targetid, target_name, sizeof(target_name));
    GetPlayerHealth(targetid, hp);
    GetPlayerArmour(targetid, armor);
    ping = GetPlayerPing(targetid);
    money = GetPlayerMoney(targetid);
    vehicleid = GetPlayerVehicleID(targetid);
    speed = GetPlayerSpeed(targetid);
    level = GetPlayerLevel(targetid);

    new Node:info1 = JSON_Object("p", JSON_Int(5), "n", JSON_String("Пинг"), "v", JSON_Int(ping));
    new Node:info2 = JSON_Object("p", JSON_Int(4), "n", JSON_String("Скорость"), "v", JSON_Int(floatround(speed)));
    new Node:info3 = JSON_Object("p", JSON_Int(2), "n", JSON_String("Здоровье"), "v", JSON_Int(floatround(hp)));
    new Node:info4 = JSON_Object("p", JSON_Int(3), "n", JSON_String("Броня"), "v", JSON_Int(floatround(armor)));
    new Node:info5 = JSON_Object("p", JSON_Int(6), "n", JSON_String("Деньги"), "v", JSON_Int(money));
    new Node:info6 = JSON_Object("p", JSON_Int(1), "n", JSON_String("Уровень"), "v", JSON_Int(level));
    new Node:info7 = JSON_Object("p", JSON_Int(7), "n", JSON_String("Транспорт"), "v", JSON_Int(vehicleid));
    
    new Node:pi_array = JSON_Array(info1, info2, info3, info4, info5, info6, info7);
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "id", targetid);
    JSON_SetString(json, "pn", target_name);
    JSON_SetArray(json, "pi", pi_array);
    
    JSON_SetString(json, "tableTitle", "Информация об игроке");
    JSON_SetBool(json, "isShowTable", true);
    JSON_SetString(json, "categoryTitle", "Режим слежения");
    JSON_SetBool(json, "isInterfaceVisible", true);
    
    if(refresh_only)
    {
        UpdatePlayerGUI(playerid, 66, json);
    }
    else
    {
        ShowPlayerGUI(playerid, 66, json);
    }
    
    JSON_Cleanup(json);
    
    return 1;
}