//>> Файл: bykranin_src/core/inventory/inventory_12.inc  (2174 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: UpdateVehicleVisualForPlayer, SetVehicleColor, SetVehicleColorForPlayer, SetVehicleEnableSiren, SetVehicleEnableSirenForPlayer, SetVehicleSiren, SetVehicleSirenForPlayer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock UpdateVehicleVisualForPlayer(playerid, vehicleid)
{
 new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
 if(action_type == VEHICLE_ACTION_TYPE_ADMIN_CAR) return 1;
 if(strlen(vInfo[vehicleid][vNumber][Number]) && strcmp(vInfo[vehicleid][vNumber][Number], "------", true))
 {
  if(vInfo[vehicleid][vNumber][Type] == 0) vInfo[vehicleid][vNumber][Type] = TYPE_RU;
  SetVehicleNumberPlateForPlayer(playerid, vehicleid, vInfo[vehicleid][vNumber][Type], vInfo[vehicleid][vNumber][Number], vInfo[vehicleid][vNumber][Region]);
 }

 // Personal/family tuning has its own authoritative cache. The old generic path
 // indexed vInfo by vehicleid and could send stale/default colors/vinyl AFTER a
 // streamed personal car was recreated, effectively painting the stock visual
 // over the saved one. Leave only non-tuning runtime flags here for these cars.
 if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR || action_type == VEHICLE_ACTION_TYPE_FAMILY_CAR)
 {
  SetVehicleHighLightForPlayer(playerid, vehicleid, 1);
  // IMPORTANT: never auto-enable/send siren state on StreamIn.
  // On this mobile client RPC 167 subtypes 27/26 can latch into endless horn audio.
  return 1;
 }

 SetVehicleTonerForPlayer  (playerid, vehicleid, vInfo[vehicleid][vTonerFront], vInfo[vehicleid][vTonerRear], vInfo[vehicleid][vTonerFrontSide], vInfo[vehicleid][vTonerRearSide]);
 SetVehicleLightColorForPlayer (playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vLightColor]));
 SetVehicleLightingForPlayer  (playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vNeon][0]), RGBA_to_ARGB(vInfo[vehicleid][vNeon][1]), RGBA_to_ARGB(vInfo[vehicleid][vNeon][2]));
 SetVehicleVinylForPlayer  (playerid, vehicleid, vInfo[vehicleid][vVinylTexture]);
 SetVehicleColorForPlayer  (playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vColorBody]), RGBA_to_ARGB(vInfo[vehicleid][vColorWheels]));
 if(vInfo[vehicleid][vStrob] > 0 && vInfo[vehicleid][strab_current] != 0 && EnableStrob[vehicleid]) SetVehicleStroboscopeForPlayer(playerid, vehicleid, vInfo[vehicleid][vStrob]-1);
 else SetVehicleStroboscopeForPlayer(playerid, vehicleid, 5);
 SetVehicleHighLightForPlayer (playerid, vehicleid, 1);
 // IMPORTANT: siren is not a visual property and must not be replayed on StreamIn.
 // Do not send RPC 167 subtype 27/26 here: some mobile clients latch it as a horn.
}
stock SetVehicleColor(vehicleid, body, wheel, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vColorBody] = body;
		vInfo[vehicleid][vColorWheels] = wheel;
	}
	foreach(new playerid: Player) SetVehicleColorForPlayer(playerid, vehicleid, RGBA_to_ARGB(body), RGBA_to_ARGB(wheel)); 
} 

stock SetVehicleColorForPlayer(playerid, vehicleid, body, wheel)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 18);
	BS_WriteValue(bitstream, PR_UINT32, body);
	BS_WriteValue(bitstream, PR_UINT32, wheel);
	BS_WriteValue(bitstream, PR_UINT32, wheel);
	BS_WriteValue(bitstream, PR_UINT32, body); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}
stock SetVehicleEnableSiren(vehicleid, type) //синхронизация включенной сирены
{
	//vInfo[vehicleid][vEnableSiren] = type;
	foreach(new playerid: Player) SetVehicleEnableSirenForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleEnableSirenForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 27);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}
stock SetVehicleSiren(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vSiren] = type;
	foreach(new playerid: Player) SetVehicleSirenForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleSirenForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 26);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}
CMD:nitro(playerid, params[])
{
	SendCarFirmware(playerid, 1009);
    AddVehicleComponent(GetPlayerVehicleID(playerid), 1009);
    return 1;
}
CMD:nitroo(playerid, params[])
{
	SendCarFirmware(playerid, 1008);
    AddVehicleComponent(GetPlayerVehicleID(playerid), 1008);
    return 1;
}
CMD:nitrooo(playerid, params[])
{
	SendCarFirmware(playerid, 1010);
    AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
    return 1;
}


// --- Подфункции для массивов ---

stock JSON:GetCaseArray()
{
    new JSON:arr = JSON_Array();
    for (new i = 1; i <= ACTIVE_CASES_COUNT; i++)
    {
        new JSON:item = JSON_Object();
        JSON_SetInt(item, "id", CaseLogicalIdToClient(i));
        JSON_SetInt(item, "cot", (i == 1) ? 5 : 0);
        JSON_Append(arr, item);
    }
    return arr;
}

stock JSON:GetBonusArray()
{
    new JSON:arr = JSON_Array();
    for (new i = 0; i < 3; i++)
    {
        new JSON:bonusObj = JSON_Object();
        JSON_SetInt(bonusObj, "id", i + 1);
        JSON_SetInt(bonusObj, "type", random(5) + 1);
        JSON_SetInt(bonusObj, "value", (i + 1) * 50);
        JSON_Append(arr, bonusObj);
    }
    return arr;
}

stock JSON:GetRewardArray()
{
    new JSON:arr = JSON_Array();
    for (new i = 0; i < 10; i++)
    {
        new JSON:rewardObj = JSON_Object();
        JSON_SetInt(rewardObj, "id", i + 1);

        new rewardName[32];
        format(rewardName, sizeof(rewardName), "Reward %d", i + 1);
        JSON_SetString(rewardObj, "name", rewardName);

        JSON_SetInt(rewardObj, "rarity", random(5) + 1);
        JSON_SetInt(rewardObj, "render_type", random(2) ? 5 : 11);
        JSON_SetInt(rewardObj, "skin_id", 134);

        JSON_Append(arr, rewardObj);
    }
    return arr;
}

stock JSON:GetSlotsArray()
{
    new JSON:arr = JSON_Array();
    for (new i = 0; i < 2; i++)
    {
        new JSON:slot = JSON_Object();
        JSON_SetInt(slot, "slot_id", i);
        JSON_SetInt(slot, "item_id", random(100) + 1);
        JSON_SetInt(slot, "count", random(5) + 1);
        JSON_Append(arr, slot);
    }
    return arr;
}

// --- Основная функция ---
stock CreateCaseArray(JSON:arr)
{
    for (new i = 1; i <= ACTIVE_CASES_COUNT; i++)
    {
        new JSON:item = JSON_Object();
        JSON_SetInt(item, "id", CaseLogicalIdToClient(i));
        JSON_SetInt(item, "cot", (i == 1) ? 5 : 0);
        JSON_Append(arr, item);
    }
}


stock ShowCase(playerid)
{
    new skill = GetPlayerData(playerid, P_SKILL_MICRO_UZI);
    new addCases = skill / 2000;
    new remainder = skill % 2000;

    if (addCases > 0)
    {
        AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, addCases);
        SetPlayerData(playerid, P_SKILL_MICRO_UZI, remainder);
        UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
        UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
        printf("[CASE] Player %d получил +%d кейсов, остаток %d", playerid, addCases, remainder);
    }
    new JSON:root = JSON_Object();
    JSON_SetInt(root, "o", 1);
    JSON_SetInt(root, "t", 1);

    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    JSON_SetString(root, "n", playerName);

    JSON_SetInt(root, "cs", 1);
    JSON_SetInt(root, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(root, "pc", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
    JSON_SetBool(root, "s", false);
    JSON_SetBool(root, "i", false);
    JSON_SetInt(root, "d", 0);
    JSON_SetInt(root, "btn_type", random(3));

    new ccStr[1024];
    ccStr[0] = '\0';
    strcat(ccStr, "[", sizeof(ccStr));
    
    for (new i = 1; i <= ACTIVE_CASES_COUNT; i++)
    {
        new cot = 0;
        if (i == 5)
            cot = GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE);

        new clientCaseId = CaseLogicalIdToClient(i);
        new temp[64];
        format(temp, sizeof(temp),
            "{\"id\":%d,\"cot\":%d}%s",
            clientCaseId, cot, (i < ACTIVE_CASES_COUNT) ? "," : ""
        );
        strcat(ccStr, temp, sizeof(ccStr));
    }

    strcat(ccStr, "]", sizeof(ccStr));
    new JSON:ccArray = JSON_Array();
    JSON_Parse(ccStr, ccArray);
    JSON_SetArray(root, "cc", ccArray);

    new caseData[512];

    if (isnull(g_player_case[playerid]))
    {
        cache_get_field_content(0, "case", g_player_case[playerid], sizeof(g_player_case[]));
    }
    
    if (isnull(g_player_case[playerid]))
    {
        format(g_player_case[playerid], sizeof(g_player_case[]),
            "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0");
    }
    
    format(caseData, sizeof(caseData), "%s", g_player_case[playerid]);
    
    if (isnull(caseData))
    {
        format(caseData, sizeof(caseData),
            "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0");
    }
    
   new openedCases[MAX_CASES];
   for (new i = 0; i < MAX_CASES; i++) openedCases[i] = 0;
   
   if (strlen(caseData) > 0)
   {
       new tmp[64], idx = 0, pos = 0;
   
       for (new i = 0; i < strlen(caseData) && idx < MAX_CASES; i++)
       {
           if (caseData[i] == ',' || caseData[i] == '\0')
           {
               tmp[pos] = '\0';
               new val = strval(tmp);
               if (val > 300) val = 300;
               openedCases[idx++] = val;
               pos = 0;
           }
					else
           {
               if (pos < sizeof(tmp) - 1)
                   tmp[pos++] = caseData[i];
           }
       }
   
       if (pos > 0 && idx < MAX_CASES)
       {
           tmp[pos] = '\0';
           new val = strval(tmp);
           if (val > 300) val = 300;
           openedCases[idx++] = val;
       }
   }




    if (!IsValidCaseBonusStates(g_player_case_bonus[playerid]))
    {
        InitPlayerCaseBonusStates(g_player_case_bonus[playerid], sizeof(g_player_case_bonus[]));
        new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
    }
    
    // после открытия кейса пересчитываем бонусы текущего кейса
    RefreshCaseBonusStatesForCase(
        g_player_case_bonus[playerid],
        sizeof(g_player_case_bonus[]),
        1,
        openedCases[0]
    );
    
   new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
    
    new cbStr[512];
    BuildCaseBonusJsonForClient(cbStr, sizeof(cbStr), g_player_case_bonus[playerid], 1);
    
    new JSON:cbArray = JSON_Array();
    JSON_Parse(cbStr, cbArray);
    JSON_SetArray(root, "cb", cbArray);
    JSON_SetInt(root, "bcc", openedCases[0]);

    new logStr[1024];
    JSON_Stringify(root, logStr, sizeof(logStr));
    printf("[ShowCase] Player %d root JSON: %s", playerid, logStr);

    ShowPlayerGUI(playerid, 73, root);

    return 1;
}

CMD:casestest(playerid)
{
    ShowCase(playerid);
    return 1;
}


stock InventoryCfg_GetItemWeightX10(item_id)
{
    return TrunkCfg_GetItemWeightX10(item_id);
}

stock TrunkTest_MapInventoryItemToTrunkType(item_id)
{
    if(item_id == 22 || item_id == ITEM_TYPE_MED)
    {
        return 22;
    }

    if(item_id == INV_ITEM_REPAIR_KIT || item_id == 134 || item_id == 58 || Inventory11_IsAccessoryItem(item_id) || Inventory11_IsPlateItem(item_id))
    {
        return item_id;
    }

    return -1;
}

stock TrunkTest_MapTrunkTypeToInventoryItem(trunk_type)
{
    if(trunk_type == 22 || trunk_type == ITEM_TYPE_MED)
    {
        return 22;
    }

    if(trunk_type == INV_ITEM_REPAIR_KIT || trunk_type == 134 || trunk_type == 58 || Inventory11_IsAccessoryItem(trunk_type) || Inventory11_IsPlateItem(trunk_type))
    {
        return trunk_type;
    }

    return -1;
}

stock TrunkTest_GetItemValueFromInventoryData(item_id, model_id, amount, extra_1, old_skin)
{
    if(Inventory11_IsAccessoryItem(item_id))
    {
        new acc_model = extra_1;
        if(acc_model <= 0) acc_model = model_id;
        if(acc_model <= 0) acc_model = Inv11_GetAccModelByItem(item_id);
        return (acc_model > 0) ? acc_model : item_id;
    }

    if(item_id == 134)
    {
        if(old_skin > 0) return old_skin;
        if(model_id > 0) return model_id;
        return 0;
    }

    if(item_id == 58)
    {
        if(extra_1 > 0) return extra_1;
        if(model_id > 0) return model_id;
        if(amount > 1) return amount;
        return 0;
    }

    if(Inventory11_IsPlateItem(item_id))
    {
        if(model_id > 0) return model_id;
        return PlateItemIdToModel(item_id);
    }

    return 0;
}

stock TrunkTest_GetDisplayModelForTrunkItem(item_id, amount, value)
{
    if(item_id == 22)
    {
        return (amount > 0) ? amount : 1;
    }

    if(item_id == 134 || item_id == 58 || Inventory11_IsPlateItem(item_id))
    {
        if(value > 0) return value;
        if(Inventory11_IsPlateItem(item_id)) return PlateItemIdToModel(item_id);
        return item_id;
    }

    if(Inventory11_IsAccessoryItem(item_id))
    {
        return 1;
    }

    if(value > 0) return value;
    return item_id;
}

stock bool:TrunkTest_IsStackableItem(item_id)
{
    return (item_id == 22);
}

stock TrunkTest_SetTrunkSlotValue(vehicleid, slot, value)
{
    g_trunktest_item_value[vehicleid][slot] = value;
    return 1;
}

stock TrunkTest_GetTrunkSlotValue(vehicleid, slot)
{
    return g_trunktest_item_value[vehicleid][slot];
}

stock TrunkTest_GetVehicleCapacityKg(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        return 1000;
    }

    new capacity = TrunkCfg_GetVehicleWeightByModel(GetVehicleModel(vehicleid));
    if(capacity <= 0)
    {
        capacity = 1000;
    }

    return capacity;
}

stock TrunkTest_GetVehicleSlotLimit(vehicleid)
{
    new slots = TrunkTest_GetVehicleCapacityKg(vehicleid) / 10;
    if(slots < 1) slots = 1;
    if(slots > MAX_VEHICLE_TRUNK_SLOTS) slots = MAX_VEHICLE_TRUNK_SLOTS;
    return slots;
}

stock TrunkTest_GetTrunkWeightX10(vehicleid)
{
    new total_weight_x10 = 0;

    for(new slot = 0; slot < MAX_VEHICLE_TRUNK_SLOTS; slot++)
    {
        if(IsTrunkFreeSlot(vehicleid, slot))
        {
            continue;
        }

        new trunk_type = GetTrunkData(vehicleid, slot, VT_ITEM_TYPE);
        new item_id = TrunkTest_MapTrunkTypeToInventoryItem(trunk_type);
        if(item_id <= 0)
        {
            continue;
        }

        new amount = GetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT);
        if(amount <= 0)
        {
            amount = 1;
        }

        new item_weight_x10 = InventoryCfg_GetItemWeightX10(item_id);
        if(item_weight_x10 <= 0)
        {
            item_weight_x10 = 10;
        }

        if(TrunkTest_IsStackableItem(item_id))
        {
            total_weight_x10 += (item_weight_x10 * amount);
        }
        else
        {
            total_weight_x10 += item_weight_x10;
        }
    }

    return total_weight_x10;
}

stock TrunkTest_GetTrunkWeightKg(vehicleid)
{
    new total_weight_x10 = TrunkTest_GetTrunkWeightX10(vehicleid);
    return (total_weight_x10 + 9) / 10;
}

stock bool:TrunkTest_IsPlayerNearVehicleRear(playerid, vehicleid, Float:range = 3.0)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        return false;
    }

    new Float:vx, Float:vy, Float:vz, Float:va;
    new Float:px, Float:py, Float:pz;
    GetVehiclePos(vehicleid, vx, vy, vz);
    GetVehicleZAngle(vehicleid, va);
    GetPlayerPos(playerid, px, py, pz);

    new Float:forward_x = floatsin(-va, degrees);
    new Float:forward_y = floatcos(-va, degrees);
    new Float:dx = px - vx;
    new Float:dy = py - vy;
    new Float:dot = (dx * forward_x) + (dy * forward_y);
    new Float:lateral = floatabs((dx * forward_y) - (dy * forward_x));

    if(dot > -0.35) return false;
    if(lateral > 2.1) return false;

    new Float:rear_offset = 2.2;
    new Float:rear_x = vx - forward_x * rear_offset;
    new Float:rear_y = vy - forward_y * rear_offset;
    new Float:dist = VectorSize(px - rear_x, py - rear_y, pz - vz);
    return (dist <= range);
}


stock bool:TrunkTest_GetNearbyPersonalVehicle(playerid, &vehicleid, Float:range = 5.0)
{
    vehicleid = INVALID_VEHICLE_ID;

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return false;
    }

    vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        return false;
    }

    if(!IsPlayerNearVehicleForPlate(playerid, vehicleid, range))
    {
        vehicleid = INVALID_VEHICLE_ID;
        return false;
    }

    return true;
}

stock bool:TrunkTest_TryOpenNearby(playerid, bool:show_errors = true)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        if(show_errors)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "У вас нет личного транспорта", " ");
        }
        printf("[TRUNKTEST][WARN] open failed: player=%d reason=no_ownable_car", playerid);
        return false;
    }

    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !TrunkTest_IsPlayerNearVehicleRear(playerid, vehicleid, 2.8))
    {
        if(show_errors)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Подойдите к багажнику личного авто", " ");
        }
        printf("[TRUNKTEST][WARN] open failed: player=%d vehicle=%d reason=not_near_car", playerid, vehicleid);
        return false;
    }

    SetPVarInt(playerid, PVAR_TRUNKTEST_VEHICLE, vehicleid);
    printf("[TRUNKTEST] open request: player=%d vehicle=%d", playerid, vehicleid);
    TrunkTest_OpenGui(playerid, vehicleid);
    return true;
}

stock bool:TrunkTest_ResolveContext(playerid, vehicleid, &account_id, &oc_id)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return false;
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return false;
    account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS)
    {
        return false;
    }

    oc_id = GetOwnableCarData(index, OC_SQL_ID);
    if(oc_id <= 0)
    {
        return false;
    }

    return true;
}
stock TrunkTest_GetPlatePseudoSlotByOc(oc_id, trunk_slot)
{
    if(oc_id <= 0 || trunk_slot < 0 || trunk_slot >= MAX_VEHICLE_TRUNK_SLOTS)
    {
        return -1;
    }

    // Keep trunk plate metadata in inventory_plates with virtual slots.
    return 200000000 + (oc_id * 100) + trunk_slot;
}

stock TrunkTest_GetPlatePseudoSlot(playerid, vehicleid, trunk_slot)
{
    new account_id, oc_id;
    if(!TrunkTest_ResolveContext(playerid, vehicleid, account_id, oc_id))
    {
        return -1;
    }

    return TrunkTest_GetPlatePseudoSlotByOc(oc_id, trunk_slot);
}

stock TrunkTest_ClearVehicleCache(vehicleid)
{
    for(new slot = 0; slot < MAX_VEHICLE_TRUNK_SLOTS; slot++)
    {
        SetTrunkData(vehicleid, slot, VT_SQL_ID, 0);
        SetTrunkData(vehicleid, slot, VT_ITEM_TYPE, 0);
        SetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT, 0);
        SetTrunkData(vehicleid, slot, VT_ITEM_VALUE, 0);
        TrunkTest_SetTrunkSlotValue(vehicleid, slot, 0);
    }
    return 1;
}

stock bool:TrunkTest_LoadVehicleFromDatabase(playerid, vehicleid)
{
    new account_id, oc_id;
    if(!TrunkTest_ResolveContext(playerid, vehicleid, account_id, oc_id))
    {
        return false;
    }

    TrunkTest_ClearVehicleCache(vehicleid);

    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT slot, item_id, amount, value FROM trunkcar WHERE acc_id = %d AND oc_id = %d ORDER BY slot ASC", account_id, oc_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[TRUNKTEST][ERROR] load trunkcar failed: player=%d account_id=%d oc_id=%d errno=%d query=%s", playerid, account_id, oc_id, mysql_errno(), query);
        cache_delete(result);
        return false;
    }

    new rows = cache_num_rows(result);
    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        if(slot < 0 || slot >= MAX_VEHICLE_TRUNK_SLOTS) continue;

        new item_id = cache_get_field_content_int(i, "item_id");
        new amount = cache_get_field_content_int(i, "amount");
        new value = cache_get_field_content_int(i, "value");
        new trunk_type = TrunkTest_MapInventoryItemToTrunkType(item_id);

        if(trunk_type <= 0) continue;
        if(amount <= 0) amount = 1;

        SetTrunkData(vehicleid, slot, VT_SQL_ID, 1);
        SetTrunkData(vehicleid, slot, VT_ITEM_TYPE, trunk_type);
        SetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT, amount);
        SetTrunkData(vehicleid, slot, VT_ITEM_VALUE, value);
        TrunkTest_SetTrunkSlotValue(vehicleid, slot, value);
    }

    cache_delete(result);
    return true;
}

stock bool:TrunkTest_SaveSlotToDatabase(playerid, vehicleid, slot)
{
    if(slot < 0 || slot >= MAX_VEHICLE_TRUNK_SLOTS)
    {
        return false;
    }

    new account_id, oc_id;
    if(!TrunkTest_ResolveContext(playerid, vehicleid, account_id, oc_id))
    {
        return false;
    }

    new plate_pseudo_slot = TrunkTest_GetPlatePseudoSlotByOc(oc_id, slot);
    new query[320];

        if(IsTrunkFreeSlot(vehicleid, slot))
    {
        mysql_format(mysql, query, sizeof(query), "DELETE FROM trunkcar WHERE acc_id = %d AND oc_id = %d AND slot = %d", account_id, oc_id, slot);
        mysql_query(mysql, query, true);

        if(mysql_errno())
        {
            printf("[TRUNKTEST][ERROR] trunkcar delete failed: player=%d slot=%d errno=%d query=%s", playerid, slot, mysql_errno(), query);
            return false;
        }

        if(plate_pseudo_slot > 0)
        {
            Inventory11_DeletePlateData(playerid, plate_pseudo_slot);
        }

        return true;
    }

    new trunk_type = GetTrunkData(vehicleid, slot, VT_ITEM_TYPE);
        new item_id = TrunkTest_MapTrunkTypeToInventoryItem(trunk_type);
    if(item_id <= 0)
    {
        return false;
    }

    if(!Inventory11_IsPlateItem(item_id) && plate_pseudo_slot > 0)
    {
        Inventory11_DeletePlateData(playerid, plate_pseudo_slot);
    }

    new amount = GetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT);
    if(amount <= 0) amount = 1;

    new value = TrunkTest_GetTrunkSlotValue(vehicleid, slot);

    mysql_format(mysql, query, sizeof(query), "INSERT INTO trunkcar (acc_id, oc_id, slot, item_id, amount, value) VALUES (%d, %d, %d, %d, %d, %d) ON DUPLICATE KEY UPDATE item_id = VALUES(item_id), amount = VALUES(amount), value = VALUES(value)", account_id, oc_id, slot, item_id, amount, value);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[TRUNKTEST][ERROR] trunkcar upsert failed: player=%d slot=%d errno=%d query=%s", playerid, slot, mysql_errno(), query);
        return false;
    }

    return true;
}
stock TrunkTest_GetCurrentTrunkAmount(vehicleid)
{
    new total = 0;
    for(new slot = 0; slot < MAX_VEHICLE_TRUNK_SLOTS; slot++)
    {
        if(IsTrunkFreeSlot(vehicleid, slot)) continue;
        total += GetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT);
    }
    return total;
}

stock bool:TrunkTest_IsInventorySlotBusy(playerid, slot)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return true;
    }

    new query[180];
    mysql_format(mysql, query, sizeof(query), "SELECT 1 FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[TRUNKTEST][ERROR] slot busy check failed: player=%d account_id=%d slot=%d errno=%d query=%s", playerid, account_id, slot, mysql_errno(), query);
        cache_delete(result);
        return true;
    }

    new bool:is_busy = (cache_num_rows(result) > 0);
    cache_delete(result);
    return is_busy;
}

stock TrunkTest_GetFreeInventorySlot(playerid)
{
    for(new slot = 1; slot <= Inventory11_GetMaxSlots(playerid); slot++)
    {
        if(!TrunkTest_IsInventorySlotBusy(playerid, slot))
        {
            return slot;
        }
    }
    return -1;
}

stock bool:TrunkTest_InsertInventoryItemAtSlot(playerid, slot, item_id, model_id, amount, extra_1, extra_2, old_skin)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    if(TrunkTest_IsInventorySlotBusy(playerid, slot))
    {
        return false;
    }

    if(!Inventory11_CanAddItemWeight(playerid, item_id, amount))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");
        return false;
    }

    new query[320];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO inventory (account_id, item_id, model_id, slot, amount, extra_1, extra_2, source_internal_id, old_skin, sim, oldsim) VALUES (%d, %d, %d, %d, %d, %d, %d, 0, %d, 0, 0)", account_id, item_id, model_id, slot, amount, extra_1, extra_2, old_skin);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[TRUNKTEST][ERROR] insert inventory failed: player=%d account_id=%d item=%d slot=%d errno=%d query=%s", playerid, account_id, item_id, slot, mysql_errno(), query);
        return false;
    }

    if(item_id == 134 && old_skin > 0)
    {
        Inventory11_SetSkinModelByPos(playerid, slot, old_skin);
    }

    return true;
}

stock TrunkTest_BuildInventoryJson(playerid, out_json[], out_size)
{
    format(out_json, out_size, "[");
    Inventory11_ResetSkinSlots(playerid);

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        strcat(out_json, "]", out_size);
        return 0;
    }

    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT item_id, model_id, slot, amount, extra_1, extra_2, old_skin, sim, oldsim FROM inventory WHERE account_id = %d ORDER BY slot ASC", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[TRUNKTEST][ERROR] build it query failed: player=%d account_id=%d errno=%d query=%s", playerid, account_id, mysql_errno(), query);
        cache_delete(result);
        strcat(out_json, "]", out_size);
        return 0;
    }

    new rows = cache_num_rows(result);
    new loaded = 0;

    for(new i = 0; i < rows; i++)
    {

        new item_id = cache_get_field_content_int(i, "item_id");
        new model_id = cache_get_field_content_int(i, "model_id");
        new old_skin = cache_get_field_content_int(i, "old_skin");
        new slot = cache_get_field_content_int(i, "slot");
        new amount = cache_get_field_content_int(i, "amount");
        new extra_1 = cache_get_field_content_int(i, "extra_1");
        new extra_2 = cache_get_field_content_int(i, "extra_2");
        new sim_value = cache_get_field_content_int(i, "sim");
        new oldsim_value = cache_get_field_content_int(i, "oldsim");

        if(item_id != 134 && item_id != 58 && item_id != 22 && !Inventory11_IsAccessoryItem(item_id) && !Inventory11_IsPlateItem(item_id))
        {
            continue;
        }

        if(item_id == 58)
        {
            new active_sim = (sim_value > 0) ? sim_value : extra_2;
            new inv_sim = (oldsim_value > 0) ? oldsim_value : ((model_id > 0) ? model_id : extra_1);

            extra_1 = inv_sim;
            extra_2 = 0;
            if(model_id <= 0) model_id = inv_sim;
        }

        new effective_model = model_id;
        if(item_id == 22)
        {
            effective_model = (amount > 0) ? amount : 1;
        }
					else if(item_id == 134)
        {
            new skin_model = (old_skin > 0) ? old_skin : model_id;
            if(skin_model <= 0) skin_model = model_id;
            Inventory11_SetSkinModelByPos(playerid, slot, skin_model);
            effective_model = skin_model;
        }
					else if(Inventory11_IsPlateItem(item_id))
        {
            new plate_type = PlateCountryToType(PlateItemIdToCountry(item_id));
            new plate[16], region[8], plate_text[32];

            if(Inventory11_GetPlateData(playerid, slot, plate_type, plate, sizeof(plate), region, sizeof(region)))
            {
                Inv11Trade_BuildPlateText(plate_type, plate, region, plate_text, sizeof(plate_text));

                Inventory11_AppendPlateItemToJson(out_json, out_size, PlateTypeToItemId(plate_type), plate_text, slot);
                loaded++;
                continue;
            }

            effective_model = (model_id > 0) ? model_id : PlateItemIdToModel(item_id);
        }
					else if(Inventory11_IsAccessoryItem(item_id))
        {
            effective_model = 1;

            if(extra_1 <= 0)
            {
                if(amount > 1)
                {
                    extra_1 = amount;
                }
					else
                {
                    extra_1 = (model_id > 0) ? model_id : Inv11_GetAccModelByItem(item_id);
                }
            }

            if(extra_1 > 0 && (model_id <= 0 || model_id > 1))
            {
                model_id = 1;
            }
        }
					else if(effective_model <= 0)
        {
            effective_model = item_id;
        }

        extra_2 = 0;
        Inventory11_AppendItemToJson(out_json, out_size, item_id, effective_model, slot, extra_1, extra_2);
        loaded++;
    }

    cache_delete(result);

    new len = strlen(out_json);
    if(len > 1 && out_json[len - 1] == ',')
    {
        out_json[len - 1] = '\0';
    }
    strcat(out_json, "]", out_size);
    return loaded;
}

stock TrunkTest_BuildTrunkJson(playerid, vehicleid, out_json[], out_size)
{
    format(out_json, out_size, "[");

    new loaded = 0;
    new slot_limit = TrunkTest_GetVehicleSlotLimit(vehicleid);
    for(new slot = 0; slot < slot_limit; slot++)
    {
        if(IsTrunkFreeSlot(vehicleid, slot))
        {
            continue;
        }

        new trunk_type = GetTrunkData(vehicleid, slot, VT_ITEM_TYPE);
        new inv_item_id = TrunkTest_MapTrunkTypeToInventoryItem(trunk_type);
        if(inv_item_id <= 0)
        {
            printf("[TRUNKTEST][WARN] skip trunk slot: vehicle=%d slot=%d trunk_type=%d", vehicleid, slot, trunk_type);
            continue;
        }

        new amount = GetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT);
        if(amount <= 0)
        {
            continue;
        }

        new value = TrunkTest_GetTrunkSlotValue(vehicleid, slot);
        if(value <= 0)
        {
            value = GetTrunkData(vehicleid, slot, VT_ITEM_VALUE);
        }

                new model_id = TrunkTest_GetDisplayModelForTrunkItem(inv_item_id, amount, value);
        new extra_1 = 0;
        new extra_2 = 0;

        if(Inventory11_IsPlateItem(inv_item_id))
        {
            new plate_slot_key = TrunkTest_GetPlatePseudoSlot(playerid, vehicleid, slot);
            new plate_type = PlateCountryToType(PlateItemIdToCountry(inv_item_id));
            new plate[16], region[8], plate_text[32];

            if(plate_slot_key > 0 && Inventory11_GetPlateData(playerid, plate_slot_key, plate_type, plate, sizeof(plate), region, sizeof(region)))
            {
                Inv11Trade_BuildPlateText(plate_type, plate, region, plate_text, sizeof(plate_text));

                Inventory11_AppendPlateItemToJson(out_json, out_size, PlateTypeToItemId(plate_type), plate_text, slot);
                loaded++;
                continue;
            }
        }

        if(Inventory11_IsAccessoryItem(inv_item_id))
        {
            extra_1 = (value > 0) ? value : Inv11_GetAccModelByItem(inv_item_id);
            if(extra_1 <= 0) extra_1 = inv_item_id;
            model_id = 1;
        }
					else if(inv_item_id == 58)
        {
            extra_1 = (value > 0) ? value : model_id;
            extra_2 = 0;
        }

        Inventory11_AppendItemToJson(out_json, out_size, inv_item_id, model_id, slot, extra_1, extra_2);
        loaded++;
    }

    new len = strlen(out_json);
    if(len > 1 && out_json[len - 1] == ',')
    {
        out_json[len - 1] = '\0';
    }
    strcat(out_json, "]", out_size);
    return loaded;
}

stock TrunkTest_OpenGui(playerid, vehicleid)
{
    TrunkTest_LoadVehicleFromDatabase(playerid, vehicleid);

    new JSON:JSONObject = JSON_Object();

    new it_json[8192];
    new ic_json[2048];

    new it_loaded = TrunkTest_BuildInventoryJson(playerid, it_json, sizeof(it_json));
    new ic_loaded = TrunkTest_BuildTrunkJson(playerid, vehicleid, ic_json, sizeof(ic_json));

    new JSON:itArray = JSON_Array();
    JSON_Parse(it_json, itArray);
    JSON_SetArray(JSONObject, "it", itArray);

    new JSON:icArray = JSON_Array();
    JSON_Parse(ic_json, icArray);
    JSON_SetArray(JSONObject, "ic", icArray);

    new trunk_capacity_kg = TrunkTest_GetVehicleCapacityKg(vehicleid);
    new trunk_slots = TrunkTest_GetVehicleSlotLimit(vehicleid);

    JSON_SetInt(JSONObject, "tb", 0);
    JSON_SetInt(JSONObject, "w", Inventory11_GetCurrentWeightKg(playerid));
    JSON_SetInt(JSONObject, "mw", Inventory11_GetMaxWeightKg(playerid));
    JSON_SetInt(JSONObject, "bw", TrunkTest_GetTrunkWeightKg(vehicleid));
    JSON_SetInt(JSONObject, "cw", trunk_capacity_kg);
    JSON_SetInt(JSONObject, "sl", Inventory11_GetMaxSlots(playerid));
    JSON_SetInt(JSONObject, "sb", trunk_slots);
    JSON_SetInt(JSONObject, "nm", GetPlayerPhone(playerid));

    Inventory11_SetAiArrayOnJson(playerid, JSONObject);

    printf("[TRUNKTEST] open gui: player=%d vehicle=%d it_loaded=%d ic_loaded=%d", playerid, vehicleid, it_loaded, ic_loaded);
    printf("[TRUNKTEST] it=%s", it_json);
    printf("[TRUNKTEST] ic=%s", ic_json);

    ShowPlayerGUI(playerid, GUICarsTrunkOrCloset, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

stock bool:TrunkTest_MoveInventoryToTrunk(playerid, vehicleid, req_item_id, old_slot, new_slot, req_value)
{
    if(new_slot < 0 || new_slot >= MAX_VEHICLE_TRUNK_SLOTS)
    {
        return false;
    }

    new trunk_slots = TrunkTest_GetVehicleSlotLimit(vehicleid);
    if(new_slot >= trunk_slots)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно места в багажнике", " ");
        return false;
    }

    if(!TrunkTest_LoadVehicleFromDatabase(playerid, vehicleid))
    {
        return false;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[320];
    mysql_format(mysql, query, sizeof(query), "SELECT item_id, model_id, amount, extra_1, extra_2, old_skin FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, old_slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[TRUNKTEST][ERROR] inv->trunk SELECT failed: player=%d slot=%d errno=%d query=%s", playerid, old_slot, mysql_errno(), query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) <= 0)
    {
        cache_delete(result);
        return false;
    }

    new item_id = cache_get_field_content_int(0, "item_id");
    new model_id = cache_get_field_content_int(0, "model_id");
    new amount = cache_get_field_content_int(0, "amount");
    new extra_1 = cache_get_field_content_int(0, "extra_1");
    new old_skin = cache_get_field_content_int(0, "old_skin");
    cache_delete(result);

    if(req_item_id > 0 && req_item_id != item_id)
    {
        printf("[TRUNKTEST][WARN] inv->trunk item mismatch: player=%d req=%d db=%d slot=%d", playerid, req_item_id, item_id, old_slot);
    }

    new trunk_type = TrunkTest_MapInventoryItemToTrunkType(item_id);
    if(trunk_type <= 0)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Этот предмет нельзя положить в багажник", " ");
        printf("[TRUNKTEST][WARN] inv->trunk unsupported item: player=%d item=%d", playerid, item_id);
        return false;
    }

    if(amount <= 0) amount = 1;

    new bool:is_stackable = TrunkTest_IsStackableItem(item_id);
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
    if(item_weight_x10 <= 0)
    {
        item_weight_x10 = 10;
    }

    new add_weight_x10 = item_weight_x10 * (is_stackable ? move_amount : 1);
    new current_weight_x10 = TrunkTest_GetTrunkWeightX10(vehicleid);
    new capacity_x10 = TrunkTest_GetVehicleCapacityKg(vehicleid) * 10;

    if(current_weight_x10 + add_weight_x10 > capacity_x10)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно места в багажнике", " ");
        return false;
    }

    new item_value = TrunkTest_GetItemValueFromInventoryData(item_id, model_id, amount, extra_1, old_skin);
    new target_slot = new_slot;

    new trunk_plate_slot = -1;
    new trunk_plate_type = TYPE_RU;
    new trunk_plate[16], trunk_region[8];
    trunk_plate[0] = '\0';
    trunk_region[0] = '\0';
    new bool:has_trunk_plate = false;

    if(Inventory11_IsPlateItem(item_id))
    {
        trunk_plate_slot = TrunkTest_GetPlatePseudoSlot(playerid, vehicleid, target_slot);
        has_trunk_plate = Inventory11_GetPlateData(playerid, old_slot, trunk_plate_type, trunk_plate, sizeof(trunk_plate), trunk_region, sizeof(trunk_region));
    }

    if(is_stackable)
    {
        new busy_slot = GetTrunkBusySlot(vehicleid, trunk_type);
        if(busy_slot >= trunk_slots)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно места в багажнике", " ");
            return false;
        }
        if(busy_slot != -1 && busy_slot != new_slot)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Выберите другой слот багажника", " ");
            printf("[TRUNKTEST][WARN] inv->trunk wrong target slot: player=%d vehicle=%d item=%d busy_slot=%d req_slot=%d", playerid, vehicleid, item_id, busy_slot, new_slot);
            return false;
        }

        if(busy_slot == -1 && !IsTrunkFreeSlot(vehicleid, new_slot))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Слот багажника уже занят", " ");
            printf("[TRUNKTEST][WARN] inv->trunk target occupied: player=%d vehicle=%d req_slot=%d", playerid, vehicleid, new_slot);
            return false;
        }

        if(busy_slot != -1)
        {
            target_slot = busy_slot;
            AddTrunkData(vehicleid, target_slot, VT_ITEM_AMOUNT, +, move_amount);
            if(TrunkTest_GetTrunkSlotValue(vehicleid, target_slot) <= 0 && item_value > 0)
            {
                TrunkTest_SetTrunkSlotValue(vehicleid, target_slot, item_value);
                SetTrunkData(vehicleid, target_slot, VT_ITEM_VALUE, item_value);
            }
        }
					else
        {
            SetTrunkData(vehicleid, target_slot, VT_SQL_ID, 1);
            SetTrunkData(vehicleid, target_slot, VT_ITEM_TYPE, trunk_type);
            SetTrunkData(vehicleid, target_slot, VT_ITEM_AMOUNT, move_amount);
            SetTrunkData(vehicleid, target_slot, VT_ITEM_VALUE, item_value);
            TrunkTest_SetTrunkSlotValue(vehicleid, target_slot, item_value);
        }
    }
					else
    {
        if(!IsTrunkFreeSlot(vehicleid, target_slot))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Слот багажника уже занят", " ");
            printf("[TRUNKTEST][WARN] inv->trunk non-stack target occupied: player=%d vehicle=%d req_slot=%d", playerid, vehicleid, target_slot);
            return false;
        }

        SetTrunkData(vehicleid, target_slot, VT_SQL_ID, 1);
        SetTrunkData(vehicleid, target_slot, VT_ITEM_TYPE, trunk_type);
        SetTrunkData(vehicleid, target_slot, VT_ITEM_AMOUNT, 1);
        SetTrunkData(vehicleid, target_slot, VT_ITEM_VALUE, item_value);
        TrunkTest_SetTrunkSlotValue(vehicleid, target_slot, item_value);
    }

        if(!TrunkTest_SaveSlotToDatabase(playerid, vehicleid, target_slot))
    {
        return false;
    }

    if(Inventory11_IsPlateItem(item_id) && trunk_plate_slot > 0)
    {
        if(has_trunk_plate)
        {
            if(!Inventory11_SavePlateData(playerid, trunk_plate_slot, trunk_plate_type, trunk_plate, trunk_region))
            {
                printf("[TRUNKTEST][ERROR] inv->trunk save plate meta failed: player=%d vehicle=%d slot=%d key=%d", playerid, vehicleid, target_slot, trunk_plate_slot);
                return false;
            }
        }
					else
        {
            printf("[TRUNKTEST][WARN] inv->trunk plate meta missing in inventory: player=%d slot=%d item=%d", playerid, old_slot, item_id);
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
            printf("[TRUNKTEST][ERROR] inv->trunk update inventory amount failed: player=%d slot=%d errno=%d query=%s", playerid, old_slot, mysql_errno(), query);
            return false;
        }
    }
					else
    {
        if(!Inventory11_DeleteSlotFromDatabase(playerid, old_slot))
        {
            printf("[TRUNKTEST][ERROR] inv->trunk delete slot failed: player=%d slot=%d", playerid, old_slot);
            return false;
        }
    }

    printf("[TRUNKTEST] inv->trunk success: player=%d vehicle=%d item=%d amount=%d inv_slot=%d trunk_slot=%d", playerid, vehicleid, item_id, move_amount, old_slot, target_slot);
    return true;
}
stock bool:TrunkTest_MoveTrunkToInventory(playerid, vehicleid, req_item_id, old_slot, new_slot, req_value)
{
    if(old_slot < 0 || old_slot >= MAX_VEHICLE_TRUNK_SLOTS)
    {
        return false;
    }

    if(new_slot < 1 || new_slot > Inventory11_GetMaxSlots(playerid))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");
        return false;
    }

    if(!TrunkTest_LoadVehicleFromDatabase(playerid, vehicleid))
    {
        return false;
    }

    if(IsTrunkFreeSlot(vehicleid, old_slot))
    {
        return false;
    }

    if(TrunkTest_IsInventorySlotBusy(playerid, new_slot))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Выберите другой слот в инвентаре", " ");
        printf("[TRUNKTEST][WARN] trunk->inv target occupied: player=%d slot=%d", playerid, new_slot);
        return false;
    }

    new trunk_type = GetTrunkData(vehicleid, old_slot, VT_ITEM_TYPE);
    new inv_item_id = TrunkTest_MapTrunkTypeToInventoryItem(trunk_type);
    if(inv_item_id <= 0)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Этот предмет нельзя взять из багажника", " ");
        printf("[TRUNKTEST][WARN] trunk->inv unsupported trunk type: player=%d vehicle=%d trunk_type=%d", playerid, vehicleid, trunk_type);
        return false;
    }

    if(req_item_id > 0 && req_item_id != inv_item_id)
    {
        printf("[TRUNKTEST][WARN] trunk->inv item mismatch: player=%d req=%d mapped=%d slot=%d", playerid, req_item_id, inv_item_id, old_slot);
    }

    new amount = GetTrunkData(vehicleid, old_slot, VT_ITEM_AMOUNT);
    if(amount <= 0)
    {
        return false;
    }

    new bool:is_stackable = TrunkTest_IsStackableItem(inv_item_id);

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

        new item_value = TrunkTest_GetTrunkSlotValue(vehicleid, old_slot);
    if(item_value <= 0)
    {
        item_value = GetTrunkData(vehicleid, old_slot, VT_ITEM_VALUE);
    }

    new trunk_plate_slot = -1;
    new trunk_plate_type = TYPE_RU;
    new trunk_plate[16], trunk_region[8];
    trunk_plate[0] = '\0';
    trunk_region[0] = '\0';
    new bool:has_trunk_plate = false;

    if(Inventory11_IsPlateItem(inv_item_id))
    {
        trunk_plate_slot = TrunkTest_GetPlatePseudoSlot(playerid, vehicleid, old_slot);
        if(trunk_plate_slot > 0)
        {
            has_trunk_plate = Inventory11_GetPlateData(playerid, trunk_plate_slot, trunk_plate_type, trunk_plate, sizeof(trunk_plate), trunk_region, sizeof(trunk_region));
        }
    }

    new model_id = TrunkTest_GetDisplayModelForTrunkItem(inv_item_id, move_amount, item_value);
    new extra_1 = 0;
    new old_skin = 0;

    if(Inventory11_IsAccessoryItem(inv_item_id))
    {
        extra_1 = (item_value > 0) ? item_value : Inv11_GetAccModelByItem(inv_item_id);
        if(extra_1 <= 0) extra_1 = inv_item_id;
        model_id = 1;
        move_amount = 1;
    }
					else if(inv_item_id == 58)
    {
        model_id = (item_value > 0) ? item_value : model_id;
        if(model_id <= 0) model_id = 1;
        extra_1 = model_id;
        move_amount = 1;
    }
					else if(inv_item_id == 134)
    {
        old_skin = (item_value > 0) ? item_value : model_id;
        if(old_skin <= 0) old_skin = model_id;
        if(model_id <= 0) model_id = old_skin;
        move_amount = 1;
    }
					else if(Inventory11_IsPlateItem(inv_item_id))
    {
        if(model_id <= 0) model_id = PlateItemIdToModel(inv_item_id);
        move_amount = 1;
    }


    if(!Inventory11_CanAddItemWeight(playerid, inv_item_id, move_amount))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");
        return false;
    }
        if(!TrunkTest_InsertInventoryItemAtSlot(playerid, new_slot, inv_item_id, model_id, move_amount, extra_1, 0, old_skin))
    {
        printf("[TRUNKTEST][ERROR] trunk->inv insert inventory failed: player=%d inv_slot=%d item=%d amount=%d", playerid, new_slot, inv_item_id, move_amount);
        return false;
    }

    if(Inventory11_IsPlateItem(inv_item_id))
    {
        if(has_trunk_plate)
        {
            if(!Inventory11_SavePlateData(playerid, new_slot, trunk_plate_type, trunk_plate, trunk_region))
            {
                printf("[TRUNKTEST][ERROR] trunk->inv save plate meta failed: player=%d trunk_slot=%d inv_slot=%d", playerid, old_slot, new_slot);
                return false;
            }
        }
					else
        {
            printf("[TRUNKTEST][WARN] trunk->inv plate meta missing: player=%d vehicle=%d trunk_slot=%d", playerid, vehicleid, old_slot);
        }
    }

    new left_amount = amount - move_amount;
        if(left_amount <= 0)
    {
        RemoveTrunkItem(vehicleid, old_slot);
        TrunkTest_SetTrunkSlotValue(vehicleid, old_slot, 0);

        if(Inventory11_IsPlateItem(inv_item_id) && trunk_plate_slot > 0)
        {
            Inventory11_DeletePlateData(playerid, trunk_plate_slot);
        }
    }
					else
    {
        SetTrunkData(vehicleid, old_slot, VT_ITEM_AMOUNT, left_amount);
    }

    if(!TrunkTest_SaveSlotToDatabase(playerid, vehicleid, old_slot))
    {
        return false;
    }

    printf("[TRUNKTEST] trunk->inv success: player=%d vehicle=%d item=%d amount=%d trunk_slot=%d inv_slot=%d", playerid, vehicleid, inv_item_id, move_amount, old_slot, new_slot);
    return true;
}
stock Inventory11(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы в транспорте.", " ");
        return 1;
    }

    new Node:JSONObject = JSON_Object();
    new name[MAX_PLAYER_NAME];
    new current_weight = Inventory11_GetCurrentWeightKg(playerid);

    GetPlayerName(playerid, name, sizeof(name));

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetString(JSONObject, "n", name);
    JSON_SetInt(JSONObject, "lv", GetPlayerLevel(playerid));
    JSON_SetInt(JSONObject, "id", playerid);
    JSON_SetInt(JSONObject, "w", current_weight);
    JSON_SetInt(JSONObject, "mw", Inventory11_GetMaxWeightKg(playerid));
    JSON_SetInt(JSONObject, "s", 0);
    JSON_SetInt(JSONObject, "sl", Inventory11_GetMaxSlots(playerid));
    JSON_SetInt(JSONObject, "v", 0);
    JSON_SetInt(JSONObject, "i", 0);
    JSON_SetInt(JSONObject, "m", GetPlayerMoney(playerid));
    JSON_SetInt(JSONObject, "nm", GetPlayerPhone(playerid));
    JSON_SetInt(JSONObject, "ps", GetPlayerSkin(playerid));

    Inventory11_ResetSkinSlots(playerid);

    new it_json[8192] = "[";
    new account_id = GetPlayerAccountID(playerid);
    if(account_id > 0)
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query), "SELECT item_id, model_id, slot, amount, extra_1, extra_2, old_skin, sim, oldsim FROM inventory WHERE account_id = %d ORDER BY slot ASC", account_id);
        new Cache:result = mysql_query(mysql, query, true);

        new rows = 0;
        new loaded = 0;
        new skipped = 0;

        if(mysql_errno())
        {
            printf("[INV11][ERROR] SELECT inventory failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, query);
        }
					else
        {
            rows = cache_num_rows(result);

            for(new i = 0; i < rows; i++)
            {
                // Nested queries can switch the active cache; restore the inventory result before reading the row.
                cache_set_active(result);
                new item_id = cache_get_field_content_int(i, "item_id");
                new model_id = cache_get_field_content_int(i, "model_id");
                new old_skin = cache_get_field_content_int(i, "old_skin");
                new slot = cache_get_field_content_int(i, "slot");
                new amount = cache_get_field_content_int(i, "amount");
                new extra_1 = cache_get_field_content_int(i, "extra_1");
                new extra_2 = cache_get_field_content_int(i, "extra_2");
                new sim_value = cache_get_field_content_int(i, "sim");
                new oldsim_value = cache_get_field_content_int(i, "oldsim");

                printf("[INV11][TRACE] Load row[%d]: player=%d slot=%d item=%d model=%d amount=%d extra1=%d extra2=%d old_skin=%d sim=%d oldsim=%d", i, playerid, slot, item_id, model_id, amount, extra_1, extra_2, old_skin, sim_value, oldsim_value);

                // Auto-recover legacy/corrupted plate rows where item_id can be stored as model id.
                if(!Inventory11_IsPlateItem(item_id))
                {
                    new remap_item = PlateModelToItemId(item_id);
                    if(remap_item != -1)
                    {
                        printf("[INV11][WARN] Load row[%d] remap item_id by model-value: old_item=%d -> new_item=%d", i, item_id, remap_item);
                        item_id = remap_item;
                    }
					else
                    {
                        remap_item = PlateModelToItemId(model_id);
                        if(remap_item != -1)
                        {
                            printf("[INV11][WARN] Load row[%d] remap item_id by model_id: old_item=%d model=%d -> new_item=%d", i, item_id, model_id, remap_item);
                            item_id = remap_item;
                        }
                    }
                }

                if(item_id != 134 && item_id != 58 && item_id != 22 && item_id != INV_ITEM_REPAIR_KIT && !Inventory11_IsAccessoryItem(item_id) && !Inventory11_IsPlateItem(item_id))
                {
                    printf("[INV11][WARN] Skip row[%d]: player=%d slot=%d item=%d model=%d amount=%d extra1=%d extra2=%d", i, playerid, slot, item_id, model_id, amount, extra_1, extra_2);
                    skipped++;
                    continue;
                }

                if(item_id == 58)
                {
                    new active_sim = (sim_value > 0) ? sim_value : extra_2;
                    new inv_sim = (oldsim_value > 0) ? oldsim_value : ((model_id > 0) ? model_id : extra_1);

                    extra_1 = inv_sim;
                    extra_2 = 0;
                    if(model_id <= 0) model_id = inv_sim;
                }

                new effective_model = model_id;
                if(item_id == 22)
                {
                    effective_model = (amount > 0) ? amount : 1;
                }
					else if(item_id == 134)
                {
                    new skin_model = (old_skin > 0) ? old_skin : model_id;
                    if(skin_model <= 0) skin_model = model_id;
                    Inventory11_SetSkinModelByPos(playerid, slot, skin_model);
                    effective_model = skin_model;
                }
					else if(Inventory11_IsPlateItem(item_id))
                {
                    new plate_type = PlateCountryToType(PlateItemIdToCountry(item_id));
                    new plate[16], region[8], plate_text[32];

                    if(Inventory11_GetPlateData(playerid, slot, plate_type, plate, sizeof(plate), region, sizeof(region)))
                    {
                        Inv11Trade_BuildPlateText(plate_type, plate, region, plate_text, sizeof(plate_text));

                        Inventory11_AppendPlateItemToJson(it_json, sizeof(it_json), PlateTypeToItemId(plate_type), plate_text, slot);
                        printf("[INV11] Load plate: player=%d slot=%d item=%d text=%s type=%d", playerid, slot, PlateTypeToItemId(plate_type), plate_text, plate_type);
                        loaded++;
                        continue;
                    }

                    effective_model = (model_id > 0) ? model_id : PlateItemIdToModel(item_id);
                }
					else if(Inventory11_IsAccessoryItem(item_id))
                {
                    // For accessory items, client uses the second value as amount.
                    // Always show amount=1, keep model in extra_1.
                    effective_model = 1;

                    if(extra_1 <= 0)
                    {
                        if(amount > 1)
                        {
                            extra_1 = amount;
                        }
					else
                        {
                            extra_1 = (model_id > 0) ? model_id : Inv11_GetAccModelByItem(item_id);
                        }
                    }

                    if(extra_1 > 0 && (model_id <= 0 || model_id > 1))
                    {
                        model_id = 1;
                    }
                }
					else if(effective_model <= 0)
                {
                    effective_model = item_id;
                }

                extra_2 = 0;
                Inventory11_AppendItemToJson(it_json, sizeof(it_json), item_id, effective_model, slot, extra_1, extra_2);
                printf("[INV11] Load item: player=%d slot=%d item=%d base_model=%d old_skin=%d effective=%d", playerid, slot, item_id, model_id, old_skin, effective_model);
                loaded++;
            }
        }

        cache_delete(result);
        printf("[INV11] Load from DB: player=%d account_id=%d rows=%d loaded=%d skipped=%d", playerid, account_id, rows, loaded, skipped);
    }
					else
    {
        printf("[INV11][WARN] Inventory11 open with invalid account_id=%d player=%d", account_id, playerid);
    }

    new len = strlen(it_json);
    if(len > 1 && it_json[len - 1] == ',')
    {
        it_json[len - 1] = '\0';
    }
    strcat(it_json, "]", sizeof(it_json));

    new Node:itArray = JSON_Array();
    JSON_Parse(it_json, itArray);
    JSON_SetArray(JSONObject, "it", itArray);
    printf("[INV11] Final it JSON player=%d: %s", playerid, it_json);

    Inventory11_SetAiArrayOnJson(playerid, JSONObject);

    new current_weapon = GetPlayerWeapon(playerid);
    new current_ammo = GetPlayerAmmo(playerid);
    if(current_ammo < 0) current_ammo = 0;

    new Node:wiArray = JSON_Array(
        JSON_Int(1039), JSON_Int(current_weapon), JSON_Int(2), JSON_Int(current_ammo), JSON_Int(current_ammo)
    );
    JSON_SetArray(JSONObject, "wi", wiArray);

    ShowPlayerGUI(playerid, 33, JSONObject);
}

stock GetInventory11SkinModelByPos(playerid, pos)
{
    new pvar_name[24];
    format(pvar_name, sizeof(pvar_name), "inv11_skin_%d", pos);

    if(GetPVarType(playerid, pvar_name))
    {
        new modelid = GetPVarInt(playerid, pvar_name);
        printf("[INV11] Resolve model by slot: player=%d slot=%d item=134 model=%d", playerid, pos, modelid);
        return modelid;
    }

    printf("[INV11][WARN] Resolve model failed: player=%d slot=%d item=134", playerid, pos);
    return -1;
}

CMD:inv(playerid, params[])
{
    Inventory11(playerid);
    return 1;
}


stock inssssv(playerid)
{
    Inventory11(playerid);
    return 1;
}

stock Inventory11_GetCurrentWeightX10(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return 0;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT item_id, amount FROM inventory WHERE account_id = %d", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] weight SELECT failed errno=%d account_id=%d query=%s", mysql_errno(), account_id, query);
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows(result);
    new total_weight_x10 = 0;
    for(new i = 0; i < rows; i++)
    {
        new item_id = cache_get_field_content_int(i, "item_id");
        new amount = cache_get_field_content_int(i, "amount");

        if(amount <= 0) amount = 1;

        new item_weight_x10 = InventoryCfg_GetItemWeightX10(item_id);
        if(item_weight_x10 <= 0)
        {
            item_weight_x10 = 10;
        }

        if(item_id == 22)
        {
            total_weight_x10 += item_weight_x10 * amount;
        }
        else
        {
            total_weight_x10 += item_weight_x10;
        }
    }

    cache_delete(result);

    new item_1, model_1, item_2, model_2, item_3, model_3, item_4, model_4;
    Inventory11_GetActiveAccessories(playerid, item_1, model_1, item_2, model_2, item_3, model_3, item_4, model_4);

    if(item_1 > 0) total_weight_x10 += Inventory11_GetItemWeightX10(item_1, 1);
    if(item_2 > 0) total_weight_x10 += Inventory11_GetItemWeightX10(item_2, 1);
    if(item_3 > 0) total_weight_x10 += Inventory11_GetItemWeightX10(item_3, 1);
    if(item_4 > 0) total_weight_x10 += Inventory11_GetItemWeightX10(item_4, 1);

    if(GetPlayerSkin(playerid) > 0)
    {
        total_weight_x10 += Inventory11_GetItemWeightX10(134, 1);
    }

    return total_weight_x10;
}

stock Inventory11_GetCurrentWeightKg(playerid)
{
    return (Inventory11_GetCurrentWeightX10(playerid) + 9) / 10;
}

stock GetItemWeight(item_id)
{
    new weight_x10 = InventoryCfg_GetItemWeightX10(item_id);
    if(weight_x10 <= 0)
    {
        weight_x10 = 10;
    }
    return (weight_x10 + 9) / 10;
}

#include "../include/marketplace.inc"

#define MAX_DAMAGED_SPEED_KMH  (35.0)
#define MAX_DAMAGED_SPEED_MS   (9.72) // 30 / 3.6
new gLastVehicleDamageTicks[MAX_PLAYERS];
forward VehicleSpeedLimiter();
public VehicleSpeedLimiter()
{
    for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if (!IsPlayerConnected(playerid)) continue;
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) continue;

        new vehicleid = GetPlayerVehicleID(playerid);
        if (vehicleid == INVALID_VEHICLE_ID) continue;

        new Float:health;
        GetVehicleHealth(vehicleid, health);

        if (health <= 270.0)
        {
            new Float:vx, Float:vy, Float:vz;
            GetVehicleVelocity(vehicleid, vx, vy, vz);

            new Float:speed = floatsqroot(vx*vx + vy*vy + vz*vz);
            new Float:kmh = speed * 181.5;

            printf("[LIMIT] player=%d vehicle=%d hp=%.2f speed=%.2f kmh",
                playerid, vehicleid, health, kmh);

            if (speed > 0.1653)
            {
                new Float:k = 0.1653 / speed;
                SetVehicleVelocity(vehicleid, vx * k, vy * k, vz * k);
                printf("[LIMIT] speed reduced for vehicle %d", vehicleid);
				new tick = GetTickCount();

                if (tick - gLastVehicleDamageTicks[playerid] < 1000)
                {
                    return 0;
                }
        
                gLastVehicleDamageTicks[playerid] = tick;
				ShowNotificationNew(playerid, 2, 6, 0, 0, "Двигатель неисправен!", "OK");

            }
        }
    }
    return 1;
}
new gLastVehicleDamageTick[MAX_PLAYERS];

stock ApplyVehicleDamage(playerid, vehicleid, Float:damage, damagedPiece)
{
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    if (health > 270.0){
    health -= damage;
    if (health < 0.0) health = 0.0;
	
	if (health <= 270.0){
		ShowNotificationNew(playerid, 2, 6, 0, 0, "Ваш двигатель был заглушен", "OK");
		health = 270.0;
		SetVehicleHealth(vehicleid, 270.0);
		return 1;
	}
    SetVehicleHealth(vehicleid, health);

    printf("[VehicleDamage] player=%d vehicle=%d damage=%.2f piece=%d hp=%.2f",
        playerid, vehicleid, damage, damagedPiece, health);
	}
    return 1;
}




stock GetNewPropertyStartRentTime()
{
	new cur_time = gettime();
	return (cur_time - (cur_time % 86400)) + (3 * 86400);
}

stock GetNewPropertyRentDaysLeft(rent_time)
{
	new cur_time = gettime();
	if(rent_time <= cur_time) return 0;

	new days = ((rent_time - cur_time) / 86400) + 1;
	if(days > HNEW_MAX_RENT_DAYS) days = HNEW_MAX_RENT_DAYS;
	return days;
}

stock GetNewHouseRentPrice(houseid)
{
	if(!(0 <= houseid < HOUSES_FOR_SALE_COUNT)) return 0;
	new h = GetHouseData(gHouseType[houseid]);
	return HouseData[h][hPriceP];
}

stock GetNewFlatRentPrice(flatids)
{
	if(!(0 <= flatids < 200000)) return 0;
	new real_flatid = g_flat_real_id[flatids];
	new houseid = real_flatid / 1000;
	if(!(0 <= houseid < FLATS_FOR_SALE_COUNT)) return 0;
	new h = gFlatType[houseid] - 1;
	return FlatData[h][hPriceP];
}

stock SetPlayerNewPropertyPayContext(playerid, property_type, property_id)
{
	SetPVarInt(playerid, "hnew_pay_type", property_type);
	SetPVarInt(playerid, "hnew_pay_id", property_id);
	return 1;
}

stock ClearPlayerNewPropertyPayContext(playerid)
{
	DeletePVar(playerid, "hnew_pay_type");
	DeletePVar(playerid, "hnew_pay_id");
	return 1;
}

stock ResetNewHouseToGov(houseid)
{
	if(!(0 <= houseid < HOUSES_FOR_SALE_COUNT) || !gHouseOwned[houseid]) return 0;

	new owner_id = gHouseOwnerID[houseid];
	new query[192];
	format(query, sizeof query, "DELETE FROM bought_houses WHERE house_id=%d AND (kv=0 OR kv IS NULL) LIMIT 1", houseid);
	mysql_tquery(mysql, query);

	gHouseOwned[houseid] = false;
	gHouseOwnerID[houseid] = 0;
	gHouseRentTime[houseid] = 0;
	format(gHouseOwner[houseid], 24, "Nobody");
	g_house_new_opens[houseid] = false;
	g_house_new_apt[houseid] = false;
	g_house_new_remont[houseid] = false;
	g_house_new_shkaf[houseid] = false;

	new owner_player = GetPlayerIDBySqlID(owner_id);
	if(owner_player != INVALID_PLAYER_ID)
	{
		SetPlayerData(owner_player, P_HOUSE_SELECTED, 0);
		UpdatePlayerDatabaseInt(owner_player, "house_selected", 0);
		SendClientMessage(owner_player, 0xB5B500FF, "Ваш дом был выставлен в гос. из-за неоплаченного налога");
	}

	if(gHouseSalePickup[houseid] != 0) DestroyPickup(gHouseSalePickup[houseid]);
	gHouseSalePickup[houseid] = CreatePickup(1273, PICKUP_TYPE_DEFAULT, gHousesForSale[houseid][0], gHousesForSale[houseid][1], gHousesForSale[houseid][2], 0, PICKUP_ACTION_TYPE_HOUSE_NEW, houseid);
	return 1;
}

stock ResetNewFlatToGov(flatids)
{
	if(!(0 <= flatids < 200000) || !gFlatOwned[flatids]) return 0;

	new owner_id = gFlatOwnerID[flatids];
	new real_flatid = g_flat_real_id[flatids];
	new query[192];
	format(query, sizeof query, "DELETE FROM bought_houses WHERE house_id=%d AND kv=1 LIMIT 1", real_flatid);
	mysql_tquery(mysql, query);

	gFlatOwned[flatids] = false;
	gFlatOwnerID[flatids] = 0;
	gFlatRentTime[flatids] = 0;
	format(gFlatOwner[flatids], 24, "Nobody");
	g_flat_new_opens[flatids] = false;
	g_flat_new_apt[flatids] = false;
	g_flat_new_remont[flatids] = false;
	g_flat_new_shkaf[flatids] = false;
	g_flat_real_id[flatids] = 0;

	new owner_player = GetPlayerIDBySqlID(owner_id);
	if(owner_player != INVALID_PLAYER_ID)
	{
		SetPlayerData(owner_player, P_HOUSE_SELECTED, 0);
		UpdatePlayerDatabaseInt(owner_player, "house_selected", 0);
		SendClientMessage(owner_player, 0xB5B500FF, "Ваша квартира была выставлена в гос. из-за неоплаченного налога");
	}
	return 1;
}

stock SellDebtorsNewProperties()
{
	new cur_time = gettime();
	for(new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
	{
		if(gHouseOwned[i] && gHouseRentTime[i] > 0 && gHouseRentTime[i] <= cur_time)
		{
			ResetNewHouseToGov(i);
		}
	}
	for(new i = 0; i < 200000; i++)
	{
		if(gFlatOwned[i] && gFlatRentTime[i] > 0 && gFlatRentTime[i] <= cur_time)
		{
			ResetNewFlatToGov(i);
		}
	}
	return 1;
}

stock LoadHousesBought()
{
    print("[DEBUG] LoadHousesBought called");
    mysql_tquery(mysql, "SELECT * FROM bought_houses", "OnHousesLoad");
    return 1;
}

forward OnHousesLoad();
public OnHousesLoad()
{
    print("[DEBUG] OnHousesLoad called");

    new rows = cache_num_rows();
    printf("[DEBUG] rows: %d", rows);

    for (new i = 0; i < rows; i++)
    {
        new house_id = cache_get_field_content_int(i, "house_id");
		new isKV = cache_get_field_content_int(i, "kv");
		if (isKV == 1){
			if(house_id < 0)
			{
				printf("[HOUSES][WARNING] Invalid flat house_id=%d at row=%d", house_id, i);
				continue;
			}
			new houseids = house_id / 1000;
            new floor   = (house_id % 1000) / 10;
            new flatidx = (house_id % 10) + (4*(floor-1));
	        new flatids = (houseids * 100) + (floor * 10) + flatidx;
			if(floor < 1 || flatids < 0 || flatids >= sizeof gFlatOwned)
			{
				printf("[HOUSES][WARNING] Invalid flat index=%d house_id=%d floor=%d row=%d", flatids, house_id, floor, i);
				continue;
			}
			gFlatOwnerID[flatids] = cache_get_field_content_int(i, "account_id");
            cache_get_field_content(i, "owner_name", gFlatOwner[flatids]);
            gFlatOwned[flatids] = true;
		    g_flat_new_opens[flatids] = cache_get_field_content_int(i, "is_open");
		    g_flat_new_apt[flatids] = cache_get_field_content_int(i, "apt");
		    g_flat_new_remont[flatids] = cache_get_field_content_int(i, "remont");
		    g_flat_new_shkaf[flatids] = cache_get_field_content_int(i, "shkaf");
			g_flat_real_id[flatids] = house_id;
			gFlatRentTime[flatids] = cache_get_field_content_int(i, "rent_time");
			if(gFlatRentTime[flatids] <= 0)
			{
				gFlatRentTime[flatids] = GetNewPropertyStartRentTime();
				new query[160];
				format(query, sizeof query, "UPDATE bought_houses SET rent_time=%d WHERE house_id=%d AND kv=1 LIMIT 1", gFlatRentTime[flatids], house_id);
				mysql_tquery(mysql, query);
			}
			
		}else{
		if(house_id < 0 || house_id >= HOUSES_FOR_SALE_COUNT)
		{
			printf("[HOUSES][WARNING] Invalid house_id=%d at row=%d", house_id, i);
			continue;
		}
        gHouseOwnerID[house_id] = cache_get_field_content_int(i, "account_id");
        cache_get_field_content(i, "owner_name", gHouseOwner[house_id]);
        gHouseOwned[house_id] = true;
		g_house_new_opens[house_id] = cache_get_field_content_int(i, "is_open");
		g_house_new_apt[house_id] = cache_get_field_content_int(i, "apt");
		g_house_new_remont[house_id] = cache_get_field_content_int(i, "remont");
		g_house_new_shkaf[house_id] = cache_get_field_content_int(i, "shkaf");
		gHouseRentTime[house_id] = cache_get_field_content_int(i, "rent_time");
		if(gHouseRentTime[house_id] <= 0)
		{
			gHouseRentTime[house_id] = GetNewPropertyStartRentTime();
			new query[160];
			format(query, sizeof query, "UPDATE bought_houses SET rent_time=%d WHERE house_id=%d AND (kv=0 OR kv IS NULL) LIMIT 1", gHouseRentTime[house_id], house_id);
			mysql_tquery(mysql, query);
		}
		}
    }

    printf("[HOUSES] Загружено домов: %d", rows);

    CreateAllSaleRealtyPickups();
	for (new i = 0; i < rows; i++)
    {
        new house_id = cache_get_field_content_int(i, "house_id");
        new isKV = cache_get_field_content_int(i, "kv");
    
        if (isKV == 1)
        {
            new houseids = house_id / 1000;
            new floor   = (house_id % 1000) / 10;
            new flatidx = (house_id % 10) + (4*(floor-1));
	        new flatids = (houseids * 100) + (floor * 10) + flatidx;
            
			if (g_flat_new_remont[flatids]){
				
			
			CreateDynamicActionPickup(
                1,
                23,
                FlatData[5-1][hEnterX],
                FlatData[5-1][hEnterY],
                FlatData[5-1][hEnterZ],
                house_id,
                PICKUP_ACTION_TYPE_FLAT_EXITS,
                house_id
            );
			if (g_flat_new_apt[flatids]){
                CreatePickup(
                    1240,
                    PICKUP_TYPE_DEFAULT,
                    FlatData[5-1][hMedX],
                    FlatData[5-1][hMedY],
                    FlatData[5-1][hMedZ],
                    house_id,
                    PICKUP_ACTION_TYPE_HOUSE_MED,
                    0
                );
		    }
		    if (g_flat_new_shkaf[flatids]){
		    	CreateDynamic3DTextLabel("{DFB941}Шкаф", 0xDFB941FF,
                    FlatData[5-1][hWardrobeX],
                    FlatData[5-1][hWardrobeY],
                    FlatData[5-1][hWardrobeZ],
                    10.0,
                    INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, house_id, 1
                );
		    }
			}else{
				CreateDynamicActionPickup(
                1,
                23,
                FlatData[gFlatType[houseids]-1][hEnterX],
                FlatData[gFlatType[houseids]-1][hEnterY],
                FlatData[gFlatType[houseids]-1][hEnterZ],
                house_id,
                PICKUP_ACTION_TYPE_FLAT_EXITS,
                house_id
            );
			if (g_flat_new_apt[flatids]){
                CreatePickup(
                    1240,
                    PICKUP_TYPE_DEFAULT,
                    FlatData[gFlatType[houseids]-1][hMedX],
                    FlatData[gFlatType[houseids]-1][hMedY],
                    FlatData[gFlatType[houseids]-1][hMedZ],
                    house_id,
                    PICKUP_ACTION_TYPE_HOUSE_MED,
                    0
                );
		    }
		    if (g_flat_new_shkaf[flatids]){
		    	CreateDynamic3DTextLabel("{DFB941}Шкаф", 0xDFB941FF,
                    FlatData[gFlatType[houseids]-1][hWardrobeX],
                    FlatData[gFlatType[houseids]-1][hWardrobeY],
                    FlatData[gFlatType[houseids]-1][hWardrobeZ],
                    10.0,
                    INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, house_id, 1
                );
		    }
			}
        }
    }
    return 1;
}




stock GetHouseData(type)
{
    if(type < 0 || type >= sizeof(HouseData))
        return -1;

    return type;
}
