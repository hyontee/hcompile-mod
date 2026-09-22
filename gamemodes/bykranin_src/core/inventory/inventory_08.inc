//>> Файл: bykranin_src/core/inventory/inventory_08.inc  (1663 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: /donate, donatess, RestorePlayerPromotions, Inv11Trade_ResetOfferSlot, Inv11Trade_ClearOffers, Inv11Trade_ResetInvite, Inv11Trade_ResetSession
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:donate(playerid)
{
	new JSON:donate_outcoming_json = JSON_Object(), donate_outcoming_data[512], promotions_array_len;

	JSON_ArrayLength(g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY], promotions_array_len);

	if(promotions_array_len == 0)
	{
		RestorePlayerPromotions(playerid);
	}

	JSON_SetInt(donate_outcoming_json, "o", 1); // значение, чтобы открыть гуи, прописывать нужно в каждую систему
	JSON_SetInt(donate_outcoming_json, "a", 1); // A_GET_PREMIUM_STATUS - статус премиум аккаунта
	JSON_SetInt(donate_outcoming_json, "cl", 1488); // CL_MARATHON_LEVEL - уровень марафона
	JSON_SetInt(donate_outcoming_json, "d", 0); // D_GET_TASK_ID - ID задачи
	JSON_SetInt(donate_outcoming_json, "ec", 0); // EC_GET_VALUE_OF_EXPERIENCE - количество опыта
	JSON_SetInt(donate_outcoming_json, "es", 0); // ES_EXPERIENCE - опыт
	JSON_SetInt(donate_outcoming_json, "e", 0); // E_GET_VALUE_OF_EXPERIENCE - значение опыта
	JSON_SetInt(donate_outcoming_json, "id", 122); // ID_ITEM_ID - ID предмета
	JSON_SetInt(donate_outcoming_json, "is", 0); // IS_IS_REWARD_STANDART - флаг стандартной награды
	JSON_SetInt(donate_outcoming_json, "k", 0); // K_CURRENT_PAGE - текущая страница
	JSON_SetInt(donate_outcoming_json, "la", 0); // LA_CURRENT_LAYOUT - текущий layout
	JSON_SetInt(donate_outcoming_json, "lc", 0); // LC_CURRENT_LAYOUT - текущий layout
	JSON_SetInt(donate_outcoming_json, "ln", 222); // LN_GET_LEADER_OF_SEASON - лидер сезона
	JSON_SetInt(donate_outcoming_json, "lt", 0); // LT_IS_AWARD - флаг наличия награды
	JSON_SetInt(donate_outcoming_json, "lv", GetPlayerLevel(playerid)); // LV_GET_LEVEL - уровень
	JSON_SetInt(donate_outcoming_json, "l", GetPlayerLevel(playerid)); // L_GET_LEVEL - уровень
	JSON_SetInt(donate_outcoming_json, "mtd", 1488); // MTD_MARATHON_DAYS_TIMER - таймер дней марафона
	JSON_SetInt(donate_outcoming_json, "ns", 222); // NS_TOP_PLAYERS - топ игроков
	JSON_SetInt(donate_outcoming_json, "op", 0); // OP_PRICE_TITLE - название цены
	JSON_SetInt(donate_outcoming_json, "pi", 0); // PI_GET_TASK_STATUS - статус задачи
	JSON_SetInt(donate_outcoming_json, "ps", 0); // PS_IS_REWARD_PREMIUM - флаг премиум награды
	JSON_SetInt(donate_outcoming_json, "p", 1337); // P_BP_LEVELS_TO_BUY - уровни для покупки
	JSON_SetInt(donate_outcoming_json, "pp", 1337); // P_PREMIUM_DELUXE_PRICE - цена премиум deluxe
	JSON_SetInt(donate_outcoming_json, "sn", 222); // SN_GET_BP_NAME - название блэкпасса
	JSON_SetInt(donate_outcoming_json, "sp", 0); // SP_SHOW_SPLIT - флаг отображения разделения
	JSON_SetInt(donate_outcoming_json, "s", 0); // S_OPERATION_STATUS - статус операции
	JSON_SetInt(donate_outcoming_json, "tk", 0); // TASKS_LIST_KEY - список задач
	JSON_SetInt(donate_outcoming_json, "sb", 0); // TASK_COMMAND - команда задачи
	JSON_SetInt(donate_outcoming_json, "tb", 0); // TASK_ID - ID задачи
	JSON_SetInt(donate_outcoming_json, "tc", 0); // TC_COMPLETED_TASKS - завершенные задачи
	JSON_SetInt(donate_outcoming_json, "td", 1337); // TD_GET_SEASON_TIMER - таймер сезона
	JSON_SetInt(donate_outcoming_json, "th", 2334); // TH_TIMER_MS - таймер в мс
	JSON_SetInt(donate_outcoming_json, "tm", 0); // TM_GET_TASK_TIMER - таймер задачи
	JSON_SetInt(donate_outcoming_json, "ty", 0); // TY_MAIN_TYPE - основной тип
	JSON_SetInt(donate_outcoming_json, "t", 0); // T_KEY - ключ

	if(strcmp("None", GetPlayerData(playerid, P_EMAIL)))
	{
		JSON_SetString(donate_outcoming_json, "em", GetPlayerData(playerid, P_EMAIL));
	}

	JSON_SetString(donate_outcoming_json, "nm", GetPlayerNameEx(playerid));

	JSON_SetInt(donate_outcoming_json, "ds", 0); // если будете делать систему х2, пропишите на нужную переменную, которая хранит текущую акцию на сервере
	JSON_SetInt(donate_outcoming_json, "sv", 1); // сюда вставляйте id своего сервера (для более норм типов, которые хоть чутка шарят)

	JSON_SetInt(donate_outcoming_json, "r", GetPlayerMoney(playerid));
	JSON_SetInt(donate_outcoming_json, "d", GetPlayerDonateRub(playerid));

	JSON_SetArray(donate_outcoming_json, "s", g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY]);

	JSON_SetInt(donate_outcoming_json, "p", GetPlayerData(playerid, P_SALE_TIME)); // время к получению подарка, сколько осталось пользователю

    ShowPlayerGUI(playerid, 22, donate_outcoming_json);
}

stock donatess(playerid){
	
	new JSON:donate_outcoming_json = JSON_Object(), donate_outcoming_data[512], promotions_array_len;

	JSON_ArrayLength(g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY], promotions_array_len);

	if(promotions_array_len == 0)
	{
		RestorePlayerPromotions(playerid);
	}

	JSON_SetInt(donate_outcoming_json, "o", 1); // значение, чтобы открыть гуи, прописывать нужно в каждую систему
	JSON_SetInt(donate_outcoming_json, "a", 1); // A_GET_PREMIUM_STATUS - статус премиум аккаунта
	JSON_SetInt(donate_outcoming_json, "cl", 1488); // CL_MARATHON_LEVEL - уровень марафона
	JSON_SetInt(donate_outcoming_json, "d", 0); // D_GET_TASK_ID - ID задачи
	JSON_SetInt(donate_outcoming_json, "ec", 0); // EC_GET_VALUE_OF_EXPERIENCE - количество опыта
	JSON_SetInt(donate_outcoming_json, "es", 0); // ES_EXPERIENCE - опыт
	JSON_SetInt(donate_outcoming_json, "e", 0); // E_GET_VALUE_OF_EXPERIENCE - значение опыта
	JSON_SetInt(donate_outcoming_json, "id", 122); // ID_ITEM_ID - ID предмета
	JSON_SetInt(donate_outcoming_json, "is", 0); // IS_IS_REWARD_STANDART - флаг стандартной награды
	JSON_SetInt(donate_outcoming_json, "k", 0); // K_CURRENT_PAGE - текущая страница
	JSON_SetInt(donate_outcoming_json, "la", 0); // LA_CURRENT_LAYOUT - текущий layout
	JSON_SetInt(donate_outcoming_json, "lc", 0); // LC_CURRENT_LAYOUT - текущий layout
	JSON_SetInt(donate_outcoming_json, "ln", 222); // LN_GET_LEADER_OF_SEASON - лидер сезона
	JSON_SetInt(donate_outcoming_json, "lt", 0); // LT_IS_AWARD - флаг наличия награды
	JSON_SetInt(donate_outcoming_json, "lv", GetPlayerLevel(playerid)); // LV_GET_LEVEL - уровень
	JSON_SetInt(donate_outcoming_json, "l", GetPlayerLevel(playerid)); // L_GET_LEVEL - уровень
	JSON_SetInt(donate_outcoming_json, "mtd", 1488); // MTD_MARATHON_DAYS_TIMER - таймер дней марафона
	JSON_SetInt(donate_outcoming_json, "ns", 222); // NS_TOP_PLAYERS - топ игроков
	JSON_SetInt(donate_outcoming_json, "op", 0); // OP_PRICE_TITLE - название цены
	JSON_SetInt(donate_outcoming_json, "pi", 0); // PI_GET_TASK_STATUS - статус задачи
	JSON_SetInt(donate_outcoming_json, "ps", 0); // PS_IS_REWARD_PREMIUM - флаг премиум награды
	JSON_SetInt(donate_outcoming_json, "p", 1337); // P_BP_LEVELS_TO_BUY - уровни для покупки
	JSON_SetInt(donate_outcoming_json, "pp", 1337); // P_PREMIUM_DELUXE_PRICE - цена премиум deluxe
	JSON_SetInt(donate_outcoming_json, "sn", 222); // SN_GET_BP_NAME - название блэкпасса
	JSON_SetInt(donate_outcoming_json, "sp", 0); // SP_SHOW_SPLIT - флаг отображения разделения
	JSON_SetInt(donate_outcoming_json, "s", 0); // S_OPERATION_STATUS - статус операции
	JSON_SetInt(donate_outcoming_json, "tk", 0); // TASKS_LIST_KEY - список задач
	JSON_SetInt(donate_outcoming_json, "sb", 0); // TASK_COMMAND - команда задачи
	JSON_SetInt(donate_outcoming_json, "tb", 0); // TASK_ID - ID задачи
	JSON_SetInt(donate_outcoming_json, "tc", 0); // TC_COMPLETED_TASKS - завершенные задачи
	JSON_SetInt(donate_outcoming_json, "td", 1337); // TD_GET_SEASON_TIMER - таймер сезона
	JSON_SetInt(donate_outcoming_json, "th", 2334); // TH_TIMER_MS - таймер в мс
	JSON_SetInt(donate_outcoming_json, "tm", 0); // TM_GET_TASK_TIMER - таймер задачи
	JSON_SetInt(donate_outcoming_json, "ty", 0); // TY_MAIN_TYPE - основной тип
	JSON_SetInt(donate_outcoming_json, "t", 0); // T_KEY - ключ

	if(strcmp("None", GetPlayerData(playerid, P_EMAIL)))
	{
		JSON_SetString(donate_outcoming_json, "em", GetPlayerData(playerid, P_EMAIL));
	}

	JSON_SetString(donate_outcoming_json, "nm", GetPlayerNameEx(playerid));

	JSON_SetInt(donate_outcoming_json, "ds", 0); // если будете делать систему х2, пропишите на нужную переменную, которая хранит текущую акцию на сервере
	JSON_SetInt(donate_outcoming_json, "sv", 1); // сюда вставляйте id своего сервера (для более норм типов, которые хоть чутка шарят)

	JSON_SetInt(donate_outcoming_json, "r", GetPlayerMoney(playerid));
	JSON_SetInt(donate_outcoming_json, "d", GetPlayerDonateRub(playerid));

	JSON_SetArray(donate_outcoming_json, "s", g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY]);

	JSON_SetInt(donate_outcoming_json, "p", GetPlayerData(playerid, P_SALE_TIME)); // время к получению подарка, сколько осталось пользователю

    ShowPlayerGUI(playerid, 22, donate_outcoming_json);

}
public: RestorePlayerPromotions(playerid)
{
	g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY] = JSON_Array();

	for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
	{
		g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY] = JSON_Append(g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY], JSON_Array(
			JSON_Int(g_player_added_promotions_data[playerid][i][0]),
			JSON_Int(g_player_added_promotions_data[playerid][i][1]),
			JSON_Int(g_player_added_promotions_data[playerid][i][2])
		));
	}
}

stock Inv11Trade_ResetOfferSlot(playerid, slot)
{
    if(slot < 1 || slot > INV11_TRADE_MAX_INV_SLOTS) return 0;

    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_VALUE] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE_TYPE] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE][0] = '\0';
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_REGION][0] = '\0';
    return 1;
}

stock Inv11Trade_ClearOffers(playerid)
{
    for(new slot = 1; slot <= INV11_TRADE_MAX_INV_SLOTS; slot++)
    {
        Inv11Trade_ResetOfferSlot(playerid, slot);
    }
    return 1;
}

stock Inv11Trade_ResetInvite(playerid)
{
    g_inv11_trade_invite_from[playerid] = -1;
    g_inv11_trade_invite_to[playerid] = -1;
    g_inv11_trade_invite_time[playerid] = 0;

    g_inv11_trade_dialog_count[playerid] = 0;
    for(new i = 0; i < INV11_TRADE_NEARBY_MAX; i++)
    {
        g_inv11_trade_dialog_target[playerid][i] = -1;
    }
    return 1;
}

stock Inv11Trade_ResetSession(playerid)
{
    g_inv11_trade_active[playerid] = false;
    g_inv11_trade_starting[playerid] = false;
    g_inv11_trade_apply[playerid] = false;
    g_inv11_trade_confirm[playerid] = false;
    g_inv11_trade_money[playerid] = 0;
    g_inv11_trade_partner[playerid] = -1;
    g_inv11_trade_started_at[playerid] = 0;
    Inv11Trade_ClearOffers(playerid);
    return 1;
}

stock Inv11Trade_ResetPlayer(playerid)
{
    Inv11Trade_ResetInvite(playerid);
    Inv11Trade_ResetSession(playerid);
    return 1;
}

stock bool:Inv11Trade_IsTradeItem(item_id)
{
    if(item_id == 22 || item_id == INV_ITEM_REPAIR_KIT || item_id == 58 || item_id == 134) return true;
    if(Inventory11_IsAccessoryItem(item_id)) return true;
    if(Inventory11_IsPlateItem(item_id)) return true;
    return false;
}

stock Float:Inv11Trade_GetDistance(playerid, targetid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    return GetPlayerDistanceFromPoint(targetid, x, y, z);
}

stock bool:Inv11Trade_IsNear(playerid, targetid, Float:range = INV11_TRADE_NEAR_RANGE)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return false;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || GetPlayerState(targetid) != PLAYER_STATE_ONFOOT) return false;
    return (Inv11Trade_GetDistance(playerid, targetid) <= range);
}

stock Inv11Trade_GetExchangeValue(item_id, model_id, amount, extra_1, extra_2, old_skin, sim_value, oldsim_value)
{
    if(item_id == 22)
    {
        return (amount > 0) ? amount : 1;
    }

    if(item_id == 58)
    {
        if(oldsim_value > 0) return oldsim_value;
        if(model_id > 0) return model_id;
        if(extra_1 > 0) return extra_1;
        if(sim_value > 0) return sim_value;
        if(extra_2 > 0) return extra_2;
        return 0;
    }

    if(item_id == 134)
    {
        if(old_skin > 0) return old_skin;
        if(model_id > 0) return model_id;
        return 0;
    }

    if(Inventory11_IsAccessoryItem(item_id))
    {
        if(extra_1 > 0) return extra_1;
        if(model_id > 1) return model_id;
        return Inv11_GetAccModelByItem(item_id);
    }

    return 1;
}

stock Inv11Trade_BuildPlateText(plate_type, plate[], region[], out_text[], out_size)
{
    new display_plate[16];
    FormatPlateByTypeForDisplay(plate_type, plate, display_plate, sizeof(display_plate));

    if(PlateTypeUsesRegion(plate_type) && strlen(region))
        format(out_text, out_size, "%s %s", display_plate, region);
    else
        format(out_text, out_size, "%s", display_plate);

    return 1;
}

stock bool:Inv11Trade_GetInventorySlotData(playerid, slot, &item_id, &model_id, &amount, &extra_1, &extra_2, &old_skin, &sim_value, &oldsim_value)
{
    item_id = 0;
    model_id = 0;
    amount = 0;
    extra_1 = 0;
    extra_2 = 0;
    old_skin = 0;
    sim_value = 0;
    oldsim_value = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT item_id, model_id, amount, extra_1, extra_2, old_skin, sim, oldsim FROM inventory WHERE account_id = %d AND slot = %d LIMIT 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][TRADE][ERROR] GetInventorySlotData failed: player=%d slot=%d errno=%d query=%s", playerid, slot, mysql_errno(), query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) <= 0)
    {
        cache_delete(result);
        return false;
    }

    item_id = cache_get_field_content_int(0, "item_id");
    model_id = cache_get_field_content_int(0, "model_id");
    amount = cache_get_field_content_int(0, "amount");
    extra_1 = cache_get_field_content_int(0, "extra_1");
    extra_2 = cache_get_field_content_int(0, "extra_2");
    old_skin = cache_get_field_content_int(0, "old_skin");
    sim_value = cache_get_field_content_int(0, "sim");
    oldsim_value = cache_get_field_content_int(0, "oldsim");

    cache_delete(result);
    return true;
}

stock Inv11Trade_SendStatus(playerid, status)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new JSON:resp = JSON_Object();
    JSON_SetInt(resp, "t", 7);
    JSON_SetInt(resp, "s", status);
    OnPacketIncoming(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendBothApplied(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new JSON:resp = JSON_Object();
    JSON_SetInt(resp, "t", 26);
    OnPacketIncoming(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendOpenExchange(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

    new JSON:resp = JSON_Object();
    JSON_SetInt(resp, "t", 17);
    JSON_SetString(resp, "en", GetPlayerNameEx(targetid));
    OnPacketIncoming(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendPartnerItem(playerid, packet_type, item_id, item_value, plate_text[])
{
    if(!IsPlayerConnected(playerid)) return 0;

    new JSON:resp = JSON_Object();
    JSON_SetInt(resp, "t", packet_type);
    JSON_SetInt(resp, "ga", item_id);
    JSON_SetInt(resp, "s", item_value);
    if(strlen(plate_text))
    {
        JSON_SetString(resp, "nt", plate_text, strlen(plate_text));
    }
    OnPacketIncoming(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendPartnerMoney(playerid, money_value)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new JSON:resp = JSON_Object();
    JSON_SetInt(resp, "t", 3);
    JSON_SetInt(resp, "gm", money_value);
    OnPacketIncoming(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_ResetApplyState(playerid, targetid)
{
    new had_apply = 0;
    if(g_inv11_trade_apply[playerid] || g_inv11_trade_apply[targetid] || g_inv11_trade_confirm[playerid] || g_inv11_trade_confirm[targetid])
    {
        had_apply = 1;
    }

    g_inv11_trade_apply[playerid] = false;
    g_inv11_trade_apply[targetid] = false;
    g_inv11_trade_confirm[playerid] = false;
    g_inv11_trade_confirm[targetid] = false;

    if(had_apply)
    {
        Inv11Trade_SendStatus(playerid, 2);
        Inv11Trade_SendStatus(targetid, 2);
    }
    return 1;
}

stock Inv11Trade_EndSession(playerid, targetid, status_player = 4, status_target = 4)
{
    if(IsPlayerConnected(playerid)) Inv11Trade_SendStatus(playerid, status_player);
    if(IsPlayerConnected(targetid)) Inv11Trade_SendStatus(targetid, status_target);

    Inv11Trade_ResetSession(playerid);
    Inv11Trade_ResetSession(targetid);
    return 1;
}

stock bool:Inv11Trade_StartSession(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return false;
    if(g_inv11_trade_active[playerid] || g_inv11_trade_active[targetid]) return false;

    Inv11Trade_ResetSession(playerid);
    Inv11Trade_ResetSession(targetid);

    g_inv11_trade_invite_from[playerid] = -1;
    g_inv11_trade_invite_from[targetid] = -1;
    g_inv11_trade_invite_to[playerid] = -1;
    g_inv11_trade_invite_to[targetid] = -1;
    g_inv11_trade_invite_time[playerid] = 0;
    g_inv11_trade_invite_time[targetid] = 0;

    g_inv11_trade_starting[playerid] = true;
    g_inv11_trade_starting[targetid] = true;

    // Refresh both inventory interfaces before trade activation.
    // Old GUI instance can send type=16 on destroy, so activate trade after refresh.
    Inventory11(playerid);
    Inventory11(targetid);

    g_inv11_trade_active[playerid] = true;
    g_inv11_trade_active[targetid] = true;
    g_inv11_trade_partner[playerid] = targetid;
    g_inv11_trade_partner[targetid] = playerid;
    g_inv11_trade_started_at[playerid] = gettime();
    g_inv11_trade_started_at[targetid] = g_inv11_trade_started_at[playerid];
    g_inv11_trade_starting[playerid] = false;
    g_inv11_trade_starting[targetid] = false;

    Inv11Trade_SendOpenExchange(playerid, targetid);
    Inv11Trade_SendOpenExchange(targetid, playerid);

    printf("[INV11][TRADE] session started: %d <-> %d start_ts=%d", playerid, targetid, g_inv11_trade_started_at[playerid]);
    return true;
}

forward CarPass_HandleNotifyClick(playerid, notify_type, notify_id, notify_sub_id);

stock CarPass_ResetInvite(playerid)
{
    g_carpass_invite_from[playerid] = -1;
    g_carpass_invite_time[playerid] = 0;
    return 1;
}

stock BuildCarPassDialogText(ownerid, dialog_text[], size)
{
    new vehicleid = GetPlayerOwnableCar(ownerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        vehicleid = GetPlayerVehicleID(ownerid);
    }
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0 || !IsValidVehicle(vehicleid)) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new model_id = GetVehicleModel(vehicleid);
    if(model_id <= 0) model_id = GetVehicleData(vehicleid, V_MODELID);
    if(model_id <= 0) return 0;

    new bool:valid_ownable_index = (index >= 0 && index < MAX_OWNABLE_CARS);
    new bool:valid_vehicle_info = (model_id >= 400 && (model_id - 400) < sizeof(g_vehicle_info));
    new firmware_name[16], nitro_name[24], number_text[32], pdv_text[24], antiradar_text[24], own_number[32], model_name[48], dlg_line[256];
    new year, month, day, car_price;

    own_number[0] = EOS;
    dialog_text[0] = EOS;

    if(valid_ownable_index) format(own_number, sizeof own_number, "%s", GetOwnableCarData(index, OC_NUMBER));

    if(valid_ownable_index)
    {
        switch(GetOwnableCarData(index, OC_FSTATE))
        {
            case FSTATE_DRIFT: format(firmware_name, sizeof firmware_name, "Drift");
            case FSTATE_COMFORT: format(firmware_name, sizeof firmware_name, "Comfort");
            case FSTATE_SPORT: format(firmware_name, sizeof firmware_name, "Sport");
            case FSTATE_SPORT_PLUS: format(firmware_name, sizeof firmware_name, "Sport+");
            default: format(firmware_name, sizeof firmware_name, "Стандарт");
        }

        switch(GetOwnableCarData(index, OC_NITRO))
        {
            case 1: format(nitro_name, sizeof nitro_name, "x2");
            case 2: format(nitro_name, sizeof nitro_name, "x5");
            case 3: format(nitro_name, sizeof nitro_name, "x10");
            default: format(nitro_name, sizeof nitro_name, "не установлено");
        }

        format(pdv_text, sizeof pdv_text, ((GetOwnableCarData(index, OC_PDVRADAR) & 1) != 0) ? ("установлено") : ("не установлено"));
        format(antiradar_text, sizeof antiradar_text, ((GetOwnableCarData(index, OC_PDVRADAR) & 2) != 0) ? ("установлено") : ("не установлено"));
    }
    else
    {
        format(firmware_name, sizeof firmware_name, "Стандарт");
        format(nitro_name, sizeof nitro_name, "не установлено");
        format(pdv_text, sizeof pdv_text, "не установлено");
        format(antiradar_text, sizeof antiradar_text, "не установлено");
    }

    if(strlen(own_number)) format(number_text, sizeof number_text, "%s", own_number);
    else format(number_text, sizeof number_text, "не установлен");

    getdate(year, month, day);
    GetVehicleModelName(model_id, model_name, sizeof model_name);
    car_price = valid_vehicle_info ? GetVehicleInfo(model_id - 400, VI_PRICE) : GetSellCarPriceByModel(model_id);

    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Владелец:\t\t{FFFF00}%s\n", GetPlayerNameEx(ownerid));
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Транспорт:\t{FFFF00}%s [%d]\n", model_name, vehicleid);
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Номер:\t\t{FFFF00}%s\n", number_text);
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Пробег:\t\t{FFFF00}%04d км.\n", floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_ceil));
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Гос. стоимость:\t{FFFF00}%d руб.\n", car_price);
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Прошивка:\t{FFFF00}%s\n", firmware_name);
    strcat(dialog_text, dlg_line, size);
    strcat(dialog_text, "{FFFFFF}Тип топлива:\t{FFFF00}98\n", size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Нитро:\t\t{FFFF00}%s\n", nitro_name);
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}ПДВ:\t\t{FFFF00}%s\n", pdv_text);
    strcat(dialog_text, dlg_line, size);
    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Антирадар:\t{FFFF00}%s\n\n", antiradar_text);
    strcat(dialog_text, dlg_line, size);

    strcat(dialog_text, "{FFFFFF}Диагностика:\n", size);
    strcat(dialog_text, "{FFFFFF}Износ двигателя:        {FFFF00}0 из 10000\n", size);
    strcat(dialog_text, "{FFFFFF}Износ воздушного фильтра:        {FFFF00}0 из 3000\n", size);
    strcat(dialog_text, "{FFFFFF}Износ топливной системы:        {FFFF00}0 из 10000\n", size);
    strcat(dialog_text, "{FFFFFF}Износ трансмиссии:        {FFFF00}0 из 10000\n", size);
    strcat(dialog_text, "{FFFFFF}Износ подвески автомобиля:        {FFFF00}0 из 12400\n", size);
    strcat(dialog_text, "{FFFFFF}Износ свечей зажигания:        {FFFF00}0 из 7000\n", size);
    strcat(dialog_text, "{FFFFFF}Износ аккумулятора:        {FFFF00}0 из 100\n", size);

    format(dlg_line, sizeof(dlg_line), "{FFFFFF}Выполнена:        {FFFF00}%04d.%d.%d", year, month, day);
    strcat(dialog_text, dlg_line, size);
    return 1;
}


stock CarPass_HandleNotifyClick(playerid, notify_type, notify_id, notify_sub_id)
{
    new inviter = g_carpass_invite_from[playerid];
    if(inviter == -1) return 0;
    if(inviter != notify_id && inviter != notify_sub_id) return 0;
    if(notify_type != 0) return 1;

    if(!IsPlayerConnected(inviter) || !IsPlayerLogged(inviter))
    {
        CarPass_ResetInvite(playerid);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
        return 1;
    }

    if(gettime() - g_carpass_invite_time[playerid] > CARPASS_INVITE_TIMEOUT)
    {
        CarPass_ResetInvite(playerid);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Предложение устарело", " ");
        return 1;
    }

    if(!IsPlayerInRangeOfPlayer(playerid, inviter, CARPASS_INVITE_RANGE))
    {
        CarPass_ResetInvite(playerid);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок находится слишком далеко", " ");
        return 1;
    }

    new dialog_text[2048];
    if(!BuildCarPassDialogText(inviter, dialog_text, sizeof dialog_text))
    {
        CarPass_ResetInvite(playerid);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "У игрока нет загруженного личного транспорта", " ");
        return 1;
    }

    new action_text[96];
    format(action_text, sizeof action_text, "%s показал свой тех.паспорт", GetPlayerNameEx(inviter));
    Action(inviter, action_text, _, false);
    ShowPlayerDialog(playerid, DIALOG_CARPASS_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "{FF8C00}Тех. паспорт", dialog_text, "Закрыть", "");
    CarPass_ResetInvite(playerid);
    return 1;
}


stock bool:Inv11Trade_OpenNearbyDialog(playerid)
{
    if(g_inv11_trade_active[playerid])
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы уже участвуете в трейде", " ");
        return false;
    }

    g_inv11_trade_dialog_count[playerid] = 0;
    for(new i = 0; i < INV11_TRADE_NEARBY_MAX; i++)
    {
        g_inv11_trade_dialog_target[playerid][i] = -1;
    }

    new list_text[4096];
    list_text[0] = '\0';

    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(i == playerid) continue;
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(g_inv11_trade_active[i]) continue;

        new Float:dist = Inv11Trade_GetDistance(playerid, i);
        if(dist > INV11_TRADE_NEAR_RANGE) continue;

        if(count >= INV11_TRADE_NEARBY_MAX) break;

        g_inv11_trade_dialog_target[playerid][count] = i;

        new line_text[128];
        format(line_text, sizeof(line_text), "%d. %s[%d] - %.6f метров\n", count + 1, GetPlayerNameEx(i), i, dist);
        strcat(list_text, line_text, sizeof(list_text));

        count++;
    }

    g_inv11_trade_dialog_count[playerid] = count;

    if(count <= 0)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Подходящих игроков для трейда поблизости - нет.", " ");
        return false;
    }

    ShowPlayerDialog(playerid, DIALOG_INV11_TRADE_SELECT, DIALOG_STYLE_LIST, "{FF0000}Трейд", list_text, "Далее", "Выйти");
    return true;
}

stock bool:Inv11Trade_HandleNotifyClick(playerid, notify_id, notify_sub_id)
{
    new inviter = g_inv11_trade_invite_from[playerid];
    if(inviter == -1) return false;

    if(inviter != notify_id && inviter != notify_sub_id) return false;

    if(!IsPlayerConnected(inviter) || !IsPlayerLogged(inviter))
    {
        Inv11Trade_ResetInvite(playerid);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
        return true;
    }

    if(gettime() - g_inv11_trade_invite_time[playerid] > INV11_TRADE_INVITE_TIMEOUT)
    {
        Inv11Trade_ResetInvite(playerid);
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Предложение трейда устарело", " ");
        return true;
    }

    new dialog_text[144];
    format(dialog_text, sizeof(dialog_text), "Игрок %s предлагает Вам трейд, Вы согласны?", GetPlayerNameEx(inviter));
    ShowPlayerDialog(playerid, DIALOG_INV11_TRADE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF0000}Трейд", dialog_text, "Далее", "Отмена");
    return true;
}

stock bool:Inv11Trade_MoveInvToExchange(playerid, item_id, slot, req_value, response)
{
    JSON_SetInt(response, "t", 5);
    JSON_SetInt(response, "w", Inventory11_GetCurrentWeightKg(playerid));

    if(!g_inv11_trade_active[playerid])
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new targetid = g_inv11_trade_partner[playerid];
    if(targetid == -1 || !IsPlayerConnected(targetid))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(slot < 1 || slot > INV11_TRADE_MAX_INV_SLOTS)
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new db_item, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim;
    if(!Inv11Trade_GetInventorySlotData(playerid, slot, db_item, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(db_item != item_id || !Inv11Trade_IsTradeItem(db_item))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new offer_used = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED];
    new send_value = 1;
    new partner_plate_text[32];
    partner_plate_text[0] = '\0';

    if(db_item == 22)
    {
        new offered = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT];
        new available = db_amount - offered;
        if(available <= 0)
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        new move_amount = req_value;
        if(move_amount <= 0) move_amount = 1;
        if(move_amount > available) move_amount = available;
        if(move_amount <= 0)
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        if(!offer_used)
        {
            g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] = 1;
            g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] = db_item;
            g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_VALUE] = 0;
        }

        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = offered + move_amount;
        send_value = move_amount;
    }
					else
    {
        if(offer_used)
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        new offer_value = Inv11Trade_GetExchangeValue(db_item, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim);
        if((db_item == 58 || db_item == 134) && offer_value <= 0)
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] = 1;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] = db_item;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = 1;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_VALUE] = offer_value;

        if(Inventory11_IsPlateItem(db_item))
        {
            new plate_type = PlateCountryToType(PlateItemIdToCountry(db_item));
            new plate[16], region[8];
            if(Inventory11_GetPlateData(playerid, slot, plate_type, plate, sizeof(plate), region, sizeof(region)))
            {
                g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE_TYPE] = plate_type;
                format(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE], 16, "%s", plate);
                format(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_REGION], 8, "%s", region);
                Inv11Trade_BuildPlateText(plate_type, plate, region, partner_plate_text, sizeof(partner_plate_text));
            }
            send_value = 1;
        }
					else if(db_item == 58 || db_item == 134)
        {
            send_value = offer_value;
        }
					else
        {
            send_value = 1;
        }
    }

    JSON_SetInt(response, "s", 1);

    Inv11Trade_SendPartnerItem(targetid, 0, db_item, send_value, partner_plate_text);
    Inv11Trade_ResetApplyState(playerid, targetid);

    printf("[INV11][TRADE] inv->exchange: player=%d target=%d slot=%d item=%d val=%d", playerid, targetid, slot, db_item, send_value);
    return true;
}

stock bool:Inv11Trade_MoveExchangeToInv(playerid, item_id, slot, req_value, response)
{
    JSON_SetInt(response, "t", 24);
    JSON_SetInt(response, "w", Inventory11_GetCurrentWeightKg(playerid));

    if(!g_inv11_trade_active[playerid])
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new targetid = g_inv11_trade_partner[playerid];
    if(targetid == -1 || !IsPlayerConnected(targetid))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(slot < 1 || slot > INV11_TRADE_MAX_INV_SLOTS)
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(!g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED])
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] != item_id)
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new send_value = 1;
    new plate_text[32];
    plate_text[0] = '\0';

    if(item_id == 22)
    {
        new offered = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT];
        new move_amount = req_value;
        if(move_amount <= 0) move_amount = 1;
        if(move_amount > offered) move_amount = offered;
        if(move_amount <= 0)
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = offered - move_amount;
        if(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] <= 0)
        {
            Inv11Trade_ResetOfferSlot(playerid, slot);
        }

        send_value = move_amount;
    }
					else
    {
        if(item_id == 58 || item_id == 134)
        {
            send_value = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_VALUE];
        }
					else
        {
            send_value = 1;
        }

        if(Inventory11_IsPlateItem(item_id))
        {
            new plate_type = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE_TYPE];
            Inv11Trade_BuildPlateText(plate_type, g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE], g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_REGION], plate_text, sizeof(plate_text));
        }

        Inv11Trade_ResetOfferSlot(playerid, slot);
    }

    JSON_SetInt(response, "s", 1);

    Inv11Trade_SendPartnerItem(targetid, 1, item_id, send_value, plate_text);
    Inv11Trade_ResetApplyState(playerid, targetid);

    printf("[INV11][TRADE] exchange->inv: player=%d target=%d slot=%d item=%d val=%d", playerid, targetid, slot, item_id, send_value);
    return true;
}

stock bool:Inv11Trade_TransferDirection(fromid, toid)
{
    new account_id = GetPlayerAccountID(fromid);
    if(account_id <= 0) return false;

    for(new slot = 1; slot <= INV11_TRADE_MAX_INV_SLOTS; slot++)
    {
        if(!g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_USED]) continue;

        new item_id = g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_ITEM_ID];
        new offer_amount = g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_AMOUNT];
        new offer_value = g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_VALUE];
        if(offer_amount <= 0) offer_amount = 1;

        new db_item, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim;
        if(!Inv11Trade_GetInventorySlotData(fromid, slot, db_item, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim))
        {
            printf("[INV11][TRADE][ERROR] TransferDirection slot missing: player=%d slot=%d", fromid, slot);
            return false;
        }

        if(db_item != item_id)
        {
            printf("[INV11][TRADE][ERROR] TransferDirection mismatch: player=%d slot=%d db_item=%d offer_item=%d", fromid, slot, db_item, item_id);
            return false;
        }

        if(item_id == 22)
        {
            if(db_amount < offer_amount)
            {
                printf("[INV11][TRADE][ERROR] TransferDirection medkit amount mismatch: player=%d slot=%d db=%d offer=%d", fromid, slot, db_amount, offer_amount);
                return false;
            }

            if(db_amount == offer_amount)
            {
                if(!Inventory11_DeleteSlotFromDatabase(fromid, slot))
                {
                    return false;
                }
            }
					else
            {
                new left_amount = db_amount - offer_amount;
                new query[192];
                mysql_format(mysql, query, sizeof(query), "UPDATE inventory SET amount = %d, model_id = %d WHERE account_id = %d AND slot = %d AND item_id = 22 LIMIT 1", left_amount, left_amount, account_id, slot);
                mysql_query(mysql, query, true);
                if(mysql_errno())
                {
                    printf("[INV11][TRADE][ERROR] TransferDirection medkit update failed: player=%d slot=%d errno=%d query=%s", fromid, slot, mysql_errno(), query);
                    return false;
                }
            }

            if(Inventory11_AddItemToDatabase(toid, 22, offer_amount, offer_amount, 0, 0) == -1)
            {
                printf("[INV11][TRADE][ERROR] TransferDirection add medkit failed: from=%d to=%d amount=%d", fromid, toid, offer_amount);
                return false;
            }
            continue;
        }

        if(!Inventory11_DeleteSlotFromDatabase(fromid, slot))
        {
            return false;
        }

        new add_slot = -1;
        if(item_id == 58)
        {
            if(offer_value <= 0) offer_value = Inv11Trade_GetExchangeValue(item_id, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim);
            add_slot = Inventory11_AddItemToDatabase(toid, 58, 1, 1, offer_value, 0);
        }
					else if(item_id == 134)
        {
            if(offer_value <= 0) offer_value = Inv11Trade_GetExchangeValue(item_id, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim);
            add_slot = Inventory11_AddItemToDatabase(toid, 134, offer_value, 1, 0, 0);
        }
					else if(Inventory11_IsAccessoryItem(item_id))
        {
            if(offer_value <= 0) offer_value = Inv11Trade_GetExchangeValue(item_id, db_model, db_amount, db_extra_1, db_extra_2, db_old_skin, db_sim, db_oldsim);
            add_slot = Inventory11_AddItemToDatabase(toid, item_id, 1, 1, offer_value, 0);
        }
					else if(Inventory11_IsPlateItem(item_id))
        {
            new plate_type = g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_PLATE_TYPE];
            if(plate_type <= 0)
            {
                plate_type = PlateCountryToType(PlateItemIdToCountry(item_id));
            }

            add_slot = Inventory11_AddItemToDatabase(toid, item_id, PlateItemIdToModel(item_id), 1, 0, 0);
            if(add_slot != -1)
            {
                if(!Inventory11_SavePlateData(toid, add_slot, plate_type, g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_PLATE], g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_REGION]))
                {
                    printf("[INV11][TRADE][ERROR] TransferDirection save plate failed: from=%d to=%d slot=%d", fromid, toid, add_slot);
                    return false;
                }
            }
        }
					else
        {
            add_slot = Inventory11_AddItemToDatabase(toid, item_id, db_model, 1, db_extra_1, db_extra_2);
        }

        if(add_slot == -1)
        {
            printf("[INV11][TRADE][ERROR] TransferDirection add item failed: from=%d to=%d item=%d", fromid, toid, item_id);
            return false;
        }
    }

    return true;
}

stock bool:Inv11Trade_Finalize(playerid, targetid)
{
    new money_player = g_inv11_trade_money[playerid];
    new money_target = g_inv11_trade_money[targetid];

    if(money_player < 0) money_player = 0;
    if(money_target < 0) money_target = 0;

    if(GetPlayerMoneyEx(playerid) < money_player || GetPlayerMoneyEx(targetid) < money_target)
    {
        printf("[INV11][TRADE][ERROR] Finalize not enough money: p=%d(%d/%d) t=%d(%d/%d)", playerid, GetPlayerMoneyEx(playerid), money_player, targetid, GetPlayerMoneyEx(targetid), money_target);
        return false;
    }

    if(!Inv11Trade_TransferDirection(playerid, targetid)) return false;
    if(!Inv11Trade_TransferDirection(targetid, playerid)) return false;

    if(money_player > 0)
    {
        GivePlayerMoneyEx(playerid, -money_player, "Трейд", true, true);
        GivePlayerMoneyEx(targetid, money_player, "Трейд", true, true);
    }

    if(money_target > 0)
    {
        GivePlayerMoneyEx(targetid, -money_target, "Трейд", true, true);
        GivePlayerMoneyEx(playerid, money_target, "Трейд", true, true);
    }

    return true;
}

stock Inv11Trade_OnDisconnect(playerid)
{
    new partner = g_inv11_trade_partner[playerid];
    if(partner != -1 && g_inv11_trade_active[playerid])
    {
        if(IsPlayerConnected(partner))
        {
            Inv11Trade_SendStatus(partner, 4);
            ShowNotificationNew(partner, 2, 6, 0, 0, "Игрок вышел из трейда", " ");
            Inv11Trade_ResetSession(partner);
        }
    }

    new invite_to = g_inv11_trade_invite_to[playerid];
    if(invite_to != -1 && IsPlayerConnected(invite_to) && g_inv11_trade_invite_from[invite_to] == playerid)
    {
        g_inv11_trade_invite_from[invite_to] = -1;
        g_inv11_trade_invite_time[invite_to] = 0;
    }

    new invite_from = g_inv11_trade_invite_from[playerid];
    if(invite_from != -1 && IsPlayerConnected(invite_from) && g_inv11_trade_invite_to[invite_from] == playerid)
    {
        g_inv11_trade_invite_to[invite_from] = -1;
    }

    Inv11Trade_ResetPlayer(playerid);
    return 1;
}

stock bool:Inv11Trade_HandlePacket(playerid, json, response, &refresh_inventory_after_response, &send_response)
{
    new type = -1;
    JSON_GetInt(json, "t", type);

    if(type != 5 && type != 6 && type != 7 && type != 8 && type != 9 && type != 16 && type != 24 && type != 25 && type != 27 && type != 31)
    {
        return false;
    }

    new targetid = g_inv11_trade_partner[playerid];

    switch(type)
    {
        case 25:
        {
            new ok = Inv11Trade_OpenNearbyDialog(playerid);
            JSON_SetInt(response, "t", 25);
            JSON_SetInt(response, "s", ok ? 1 : 0);
            return true;
        }

        case 31:
        {
            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid))
            {
                send_response = 0;
                return true;
            }

            new tx[144];
            JSON_GetString(json, "tx", tx, sizeof(tx));
            if(!strlen(tx))
            {
                send_response = 0;
                return true;
            }

            new text[192];
            format(text, sizeof(text), "%s: %s", GetPlayerNameEx(playerid), tx);

            new JSON:packet = JSON_Object();
            JSON_SetInt(packet, "t", 31);
            JSON_SetString(packet, "tx", text);
            OnPacketIncoming(playerid, 33, packet);
            OnPacketIncoming(targetid, 33, packet);
            JSON_Cleanup(packet);

            send_response = 0;
            return true;
        }

        case 16:
        {
            if(g_inv11_trade_starting[playerid])
            {
                printf("[INV11][TRADE] ignore close packet t=16 while starting: player=%d", playerid);
                send_response = 0;
                return true;
            }

            if(g_inv11_trade_active[playerid] && targetid != -1)
            {
                new started_at = g_inv11_trade_started_at[playerid];
                new since_start = (started_at > 0) ? (gettime() - started_at) : 9999;
                if(started_at > 0 && since_start <= INV11_TRADE_CLOSE_GRACE)
                {
                    printf("[INV11][TRADE] ignore close packet t=16 in grace: player=%d target=%d since=%d", playerid, targetid, since_start);
                    send_response = 0;
                    return true;
                }

                printf("[INV11][TRADE] close packet t=16 end session: player=%d target=%d", playerid, targetid);
                Inv11Trade_EndSession(playerid, targetid, 4, 4);
                send_response = 0;
                return true;
            }

            if(g_inv11_trade_active[playerid])
            {
                printf("[INV11][TRADE] close packet t=16 with invalid partner, reset session: player=%d target=%d", playerid, targetid);
                Inv11Trade_ResetSession(playerid);
                send_response = 0;
                return true;
            }

            JSON_SetInt(response, "t", 16);
            JSON_SetInt(response, "s", 1);
            return true;
        }

        case 7:
        {
            if(g_inv11_trade_starting[playerid])
            {
                printf("[INV11][TRADE] ignore close packet t=7 while starting: player=%d", playerid);
                send_response = 0;
                return true;
            }

            if(g_inv11_trade_active[playerid] && targetid != -1)
            {
                new started_at = g_inv11_trade_started_at[playerid];
                new since_start = (started_at > 0) ? (gettime() - started_at) : 9999;
                if(started_at > 0 && since_start <= INV11_TRADE_CLOSE_GRACE)
                {
                    printf("[INV11][TRADE] ignore close packet t=7 in grace: player=%d target=%d since=%d", playerid, targetid, since_start);
                    send_response = 0;
                    return true;
                }

                printf("[INV11][TRADE] close packet t=7 end session: player=%d target=%d", playerid, targetid);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы отменили обмен", " ");
                if(IsPlayerConnected(targetid))
                {
                    ShowNotificationNew(targetid, 2, 6, 0, 0, "Игрок отменил обмен", " ");
                }
                Inv11Trade_EndSession(playerid, targetid, 4, 4);
                send_response = 0;
                return true;
            }

            if(g_inv11_trade_active[playerid])
            {
                printf("[INV11][TRADE] close packet t=7 with invalid partner, reset session: player=%d target=%d", playerid, targetid);
                Inv11Trade_ResetSession(playerid);
                send_response = 0;
                return true;
            }

            JSON_SetInt(response, "t", 7);
            JSON_SetInt(response, "s", 4);
            return true;
        }

        case 6:
        {
            JSON_SetInt(response, "t", 6);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid))
            {
                JSON_SetInt(response, "s", 0);
                return true;
            }

            new money_offer = 0;
            JSON_GetInt(json, "em", money_offer);
            if(money_offer < 0) money_offer = 0;

            if(money_offer > INV11_TRADE_MAX_MONEY || money_offer > GetPlayerMoneyEx(playerid))
            {
                JSON_SetInt(response, "s", 0);
                return true;
            }

            if(g_inv11_trade_money[playerid] != money_offer)
            {
                g_inv11_trade_money[playerid] = money_offer;
                Inv11Trade_ResetApplyState(playerid, targetid);
            }

            Inv11Trade_SendPartnerMoney(targetid, money_offer);
            JSON_SetInt(response, "s", 1);
            return true;
        }

        case 5:
        {
            new item_id = 0, req_value = 0, slot = -1;
            JSON_GetInt(json, "ga", item_id);
            JSON_GetInt(json, "s", req_value);
            JSON_GetInt(json, "os", slot);
            if(slot == 0) slot = 1;

            Inv11Trade_MoveInvToExchange(playerid, item_id, slot, req_value, response);
            return true;
        }

        case 24:
        {
            new item_id = 0, req_value = 0, slot = -1;
            JSON_GetInt(json, "ga", item_id);
            JSON_GetInt(json, "s", req_value);
            JSON_GetInt(json, "sl", slot);
            if(slot == -1) JSON_GetInt(json, "os", slot);
            if(slot == 0) slot = 1;

            Inv11Trade_MoveExchangeToInv(playerid, item_id, slot, req_value, response);
            return true;
        }

        case 27:
        {
            JSON_SetInt(response, "t", 27);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid))
            {
                JSON_SetInt(response, "s", 0);
                return true;
            }

            new item_id = 0, old_pos = -1, pos = -1;
            JSON_GetInt(json, "ga", item_id);
            JSON_GetInt(json, "os", old_pos);
            JSON_GetInt(json, "s", pos);
        if(old_pos == 0) old_pos = 1;
        if(pos == 0) pos = 1;

            new bool:db_ok = false;
            new active_model = 0;
            new bool:is_active_acc_move = (Inventory11_IsAccessoryItem(item_id) && (old_pos >= 1 && old_pos <= INVENTORY11_MAX_ACTIVE_ACCESSORIES) && !Inventory11_HasInventoryItemInSlot(playerid, old_pos, item_id));

            if(is_active_acc_move)
            {
                db_ok = Inventory11_MoveActiveAccessoryToInventorySlot(playerid, item_id, old_pos, pos, active_model);
                if(db_ok)
                {
                    Inventory11_SetAiArrayOnJson(playerid, response);
                    refresh_inventory_after_response = 1;
                }
            }
					else
            {
                db_ok = Inventory11_SwapSlotsInDatabase(playerid, old_pos, pos);
            }

            JSON_SetInt(response, "s", db_ok ? 1 : 0);
            JSON_SetInt(response, "nw", 200);
            JSON_SetInt(response, "ns", 20);

            if(db_ok)
            {
                Inv11Trade_ResetApplyState(playerid, targetid);
            }

            return true;
        }

        case 8:
        {
            JSON_SetInt(response, "t", 8);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid))
            {
                JSON_SetInt(response, "s", 0);
                return true;
            }

            g_inv11_trade_apply[playerid] = true;
            g_inv11_trade_confirm[playerid] = false;
            JSON_SetInt(response, "s", 1);

            if(g_inv11_trade_apply[targetid])
            {
                JSON_SetInt(response, "t", 26);
                Inv11Trade_SendBothApplied(targetid);
                ShowNotificationNew(targetid, 3, 6, 0, 0, "Теперь нужно нажать кнопку Подтвердить", " ");
            }
					else
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вам нужно подождать пока другой игрок подтвердит трейд", " ");
            }

            return true;
        }

        case 9:
        {
            JSON_SetInt(response, "t", 9);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid) || !g_inv11_trade_apply[playerid] || !g_inv11_trade_apply[targetid])
            {
                JSON_SetInt(response, "s", 0);
                return true;
            }

            g_inv11_trade_confirm[playerid] = true;
            JSON_SetInt(response, "s", 1);

            if(g_inv11_trade_confirm[targetid])
            {
                if(Inv11Trade_Finalize(playerid, targetid))
                {
                    Inv11Trade_EndSession(playerid, targetid, 4, 4);
                    Inventory11(playerid);
                    Inventory11(targetid);
                    ShowNotificationNew(playerid, 3, 6, 0, 0, "Обмен прошел успешно", " ");
                    ShowNotificationNew(targetid, 3, 6, 0, 0, "Обмен прошел успешно", " ");
                    // Keep response packet for confirmer: some client builds keep dialog blocked without t=9 response.
                    send_response = 1;
                }
					else
                {
                    Inv11Trade_ResetApplyState(playerid, targetid);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось завершить трейд", " ");
                    ShowNotificationNew(targetid, 2, 6, 0, 0, "Не удалось завершить трейд", " ");
                    JSON_SetInt(response, "s", 0);
                }
            }

            return true;
        }
    }

    return false;
}

stock Inventory11_ResetSkinSlots(playerid)
{
    new pvar_name[24];
    for(new slot = 0; slot < 128; slot++)
    {
        format(pvar_name, sizeof(pvar_name), "inv11_skin_%d", slot);
        if(GetPVarType(playerid, pvar_name))
        {
            DeletePVar(playerid, pvar_name);
        }
    }
    return 1;
}

stock Inventory11_SetSkinModelByPos(playerid, pos, modelid)
{
    new pvar_name[24];
    format(pvar_name, sizeof(pvar_name), "inv11_skin_%d", pos);
    SetPVarInt(playerid, pvar_name, modelid);
    printf("[INV11] player=%d slot=%d item=134 model=%d", playerid, pos, modelid);
    return 1;
}

stock Inventory11_AppendItemToJson(json_str[], json_size, item_id, model_id, slot, extra_1, extra_2)
{
    new temp[80];
    format(temp, sizeof(temp), "%d,%d,%d,%d,%d,", item_id, model_id, slot, extra_1, extra_2);
    strcat(json_str, temp, json_size);
    return 1;
}

stock Inventory11_AppendPlateItemToJson(json_str[], json_size, item_id, plate_text[], slot)
{
    new temp[128];
    format(temp, sizeof(temp), "%d,\"%s\",%d,0,0,", item_id, plate_text, slot);
    strcat(json_str, temp, json_size);
    return 1;
}



stock Inventory11_GetAccessoryAddWeightByModel(modelid)
{
    if(modelid <= 0)
    {
        return 0;
    }

    for(new i = 0; i < sizeof(Inventory11AccessoryAddWeightByModel); i++)
    {
        if(Inventory11AccessoryAddWeightByModel[i][0] == modelid)
        {
            return Inventory11AccessoryAddWeightByModel[i][1];
        }
    }

    return 0;
}

stock Inventory11_GetAdditionalWeightKg(playerid)
{
    new add_weight = 0;

    for(new slot = 0; slot < MAX_PLAYER_ATTACHED_OBJECTS; slot++)
    {
        if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
        {
            continue;
        }

        new modelid = floatround(gPlayerTempAccData[playerid][slot][0]);
        if(modelid <= 0)
        {
            continue;
        }

        add_weight += Inventory11_GetAccessoryAddWeightByModel(modelid);
    }

    return add_weight;
}

stock Inventory11_GetMaxWeightKg(playerid)
{
    new max_weight = INVENTORY11_MAX_WEIGHT_KG + Inventory11_GetAdditionalWeightKg(playerid);
    if(max_weight < INVENTORY11_MAX_WEIGHT_KG)
    {
        max_weight = INVENTORY11_MAX_WEIGHT_KG;
    }
    return max_weight;
}

stock Inventory11_GetMaxSlots(playerid)
{
    new slots = INVENTORY11_BASE_SLOTS + (Inventory11_GetAdditionalWeightKg(playerid) / 10);
    if(slots < INVENTORY11_BASE_SLOTS)
    {
        slots = INVENTORY11_BASE_SLOTS;
    }
    if(slots > INVENTORY11_MAX_SLOTS)
    {
        slots = INVENTORY11_MAX_SLOTS;
    }
    return slots;
}

stock Inventory11_GetItemWeightX10(item_id, amount = 1)
{
    if(amount <= 0)
    {
        amount = 1;
    }

    new item_weight_x10 = InventoryCfg_GetItemWeightX10(item_id);
    if(item_weight_x10 <= 0)
    {
        item_weight_x10 = 10;
    }

    if(item_id == 22)
    {
        return item_weight_x10 * amount;
    }

    return item_weight_x10;
}

stock bool:Inventory11_CanAddItemWeight(playerid, item_id, amount = 1)
{
    new add_weight_x10 = Inventory11_GetItemWeightX10(item_id, amount);
    new max_weight_x10 = Inventory11_GetMaxWeightKg(playerid) * 10;

    return (Inventory11_GetCurrentWeightX10(playerid) + add_weight_x10 <= max_weight_x10);
}

stock bool:Inventory11_IsAccessoryItem(item_id)
{
    return (Inv11_GetAccModelByItem(item_id) > 0);
}

stock Inv11_GetAccModelByItem(item_id)
{
    for(new i = 0; i < sizeof(AccessoryMapping); i++)
    {
        if(AccessoryMapping[i][1] == item_id)
        {
            return AccessoryMapping[i][2];
        }
    }

    for(new i = 0; i < sizeof(CaseAccessoryRewardMapping); i++)
    {
        if(CaseAccessoryRewardMapping[i][0] == item_id)
        {
            return CaseAccessoryRewardMapping[i][1];
        }
    }

    // Accessories sold by the world shops use their own item-id table.
    // Without this lookup the database row exists, but the inventory loader skips it.
    for(new i = 0; i < sizeof(AccessoryShopInventoryMap); i++)
    {
        if(AccessoryShopInventoryMap[i][1] == item_id)
        {
            return AccessoryShopInventoryMap[i][0];
        }
    }

    return -1;
}
stock bool:Inv11_ResolveAccessoryReward(internal, &item_id, &modelid)
{
    item_id = -1;
    modelid = -1;

    // Case rewards usually pass inventory item id in internal.
    for(new i = 0; i < sizeof(AccessoryMapping); i++)
    {
        if(AccessoryMapping[i][1] == internal)
        {
            item_id = AccessoryMapping[i][1];
            modelid = AccessoryMapping[i][2];
            return true;
        }
    }

    for(new i = 0; i < sizeof(CaseAccessoryRewardMapping); i++)
    {
        if(CaseAccessoryRewardMapping[i][0] == internal)
        {
            item_id = internal;
            modelid = CaseAccessoryRewardMapping[i][1];
            return true;
        }
    }

    // Fallback for flows where internal is donate internal id.
    for(new i = 0; i < sizeof(AccessoryMapping); i++)
    {
        if(AccessoryMapping[i][0] == internal)
        {
            item_id = AccessoryMapping[i][1];
            modelid = AccessoryMapping[i][2];
            return true;
        }
    }

    if(AccessoryGetIndexByModel(internal) != -1)
    {
        item_id = internal;
        modelid = internal;
        return true;
    }

    return false;
}

stock bool:Inv11_GetAccModelBySlot(playerid, slot, item_id, &modelid)
{
    modelid = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return false;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT model_id, extra_1 FROM inventory WHERE account_id = %d AND slot = %d AND item_id = %d LIMIT 1", account_id, slot, item_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] GetAccessoryModelBySlot failed errno=%d account_id=%d slot=%d item=%d query=%s", mysql_errno(), account_id, slot, item_id, query);
        cache_delete(result);
        return false;
    }

    if(cache_num_rows(result) > 0)
    {
        new db_model = cache_get_field_content_int(0, "model_id");
        new db_extra = cache_get_field_content_int(0, "extra_1");

        // For Inventory11 accessories, real model should be in extra_1.
        // model_id can be 1 (amount placeholder), so do not use it blindly.
        if(db_extra > 0)
        {
            modelid = db_extra;
        }
					else if(db_model > 1)
        {
            modelid = db_model;
        }
					else if(db_model > 0 && FindAccsDataIndexByModel(db_model) != -1)
        {
            modelid = db_model;
        }
    }

    cache_delete(result);

    // Fallback for clients that send slot=0 and for legacy rows.
    if(modelid <= 0 && FindAccsDataIndexByModel(item_id) != -1)
    {
        modelid = item_id;
    }

    if(modelid <= 0)
    {
        modelid = Inv11_GetAccModelByItem(item_id);
    }

    // Mapping may be stale for some items (e.g. ga differs from actual model in current build).
    if(modelid > 0 && AccessoryGetIndexByModel(modelid) == -1 && FindAccsDataIndexByModel(item_id) != -1)
    {
        printf("[INV11][WARN] Accessory model fallback by item: player=%d item=%d mapped_model=%d", playerid, item_id, modelid);
        modelid = item_id;
    }

    return (modelid > 0);
}

