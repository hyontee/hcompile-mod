new TentIDx[MAX_PLAYERS];

ShowPlayerInventory(playerid)
{
	if(IsTDVisible(playerid) != -1) return 1;
    ShowTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
	return 1;
}

GetInventoryAmount(playerid, item_id, type_inv = EQUIPMENT_INVENTORY_PLAYER)
{
    new iAmountItems, max_slot, min_slot;
    GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
    if(min_slot < max_slot)
    {
        for(new i = max_slot; i != min_slot; i--)
        {
            if(InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID && InventoryPlayer[playerid][i][inv_item_id] == item_id)
                iAmountItems += InventoryPlayer[playerid][i][inv_amount];
        }
    }
    return iAmountItems;
}

GetInventoryFreeItems(playerid, item_id, type_inv = EQUIPMENT_INVENTORY_PLAYER)
{
    new max_value, max_slot, min_slot;
    GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
    if(min_slot >= max_slot) return 0;
    for(new i = max_slot; i != min_slot; i--)
    {
        if( InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID &&
            InventoryPlayer[playerid][i][inv_item_id] == item_id &&
            ItemsInfo[item_id][iType] == TYPE_ITEMS_INVENTORY)
        {
            max_value += (ItemsInfo[item_id][iMax] - InventoryPlayer[playerid][i][inv_amount]);
        }
        if(InventoryPlayer[playerid][i][inv_mysql_id] == INVALID_MYSQL_ID)
        {
            max_value += ItemsInfo[item_id][iMax];
        }
    }
    return max_value;
}

InventoryDivide(playerid, slot_id, value)
{
    new free_slot = GetFreeSlotInventory(playerid, EQUIPMENT_INVENTORY_PLAYER);
    if(free_slot == -1) return SendError(playerid, "В инвентаре нет свободного места.");
    if(InventoryPlayer[playerid][slot_id][inv_amount] < value)
        return SendError(playerid, "Произошла ошибка: 10.01.22-1444");
    if(value < 1)
        return SendError(playerid, "Произошла ошибка: 10.01.22-1445");
    //give
    InventoryPlayer[playerid][free_slot][inv_amount]     = value;
    InventoryPlayer[playerid][free_slot][inv_slot_id]    = free_slot;
    InventoryPlayer[playerid][free_slot][inv_item_id]    = InventoryPlayer[playerid][slot_id][inv_item_id];
    InventoryPlayer[playerid][free_slot][inv_status_use] = 0;

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`) VALUES (%d, %d, %d, %d, %d)",
       InventoryPlayer[playerid][free_slot][inv_slot_id], p_info[playerid][ID], INVENTORY_OWNER_TYPE_PLAYER,
       InventoryPlayer[playerid][free_slot][inv_item_id], InventoryPlayer[playerid][free_slot][inv_amount]);
    mysql_tquery(con_bd, STRING_GLOBAL, "GetInventoryMysqlID", "ii", playerid, free_slot);

    //take
    InventoryPlayer[playerid][slot_id][inv_amount] -= value;
    if(InventoryPlayer[playerid][slot_id][inv_amount] > 0)
    {
        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d",
            InventoryPlayer[playerid][slot_id][inv_amount], InventoryPlayer[playerid][slot_id][inv_mysql_id]);
        mysql_tquery(con_bd, STRING_GLOBAL, "Equipment_Update", "i", playerid);
    }
    else
    {
        if(InventoryPlayer[playerid][slot_id][inv_amount] < 0) SendError(playerid, "Багоюз! Обратитесь на форум, дабы избежать бан! КОД: 1001-1500.");
        DropPlayerEquipment(playerid, slot_id);
        Equipment_Update(playerid);
    }
    printf("LOG_PLAYER: %s[%d](%s %s) разделил <%s> из %d ед на %d ед. и %d ед. | #Inventory#Div",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        ItemsInfo[InventoryPlayer[playerid][slot_id][inv_item_id]][iName],
        InventoryPlayer[playerid][slot_id][inv_amount]+value, InventoryPlayer[playerid][free_slot][inv_amount], value);
    return 1;
}

InventoryMerge(playerid, old_slot, new_slot)
{
    new iFreeItems = ItemsInfo[InventoryPlayer[playerid][new_slot][inv_item_id]][iMax]-InventoryPlayer[playerid][new_slot][inv_amount];

    if(iFreeItems >= InventoryPlayer[playerid][old_slot][inv_amount])
    {
        InventoryPlayer[playerid][new_slot][inv_amount] += InventoryPlayer[playerid][old_slot][inv_amount];
        InventoryPlayer[playerid][old_slot][inv_amount] = 0;

        if(InventoryPlayer[playerid][old_slot][inv_market_buy_price] > 0 || InventoryPlayer[playerid][old_slot][inv_market_buy_amount] > 0)
        {
            InventoryPlayer[playerid][new_slot][inv_market_buy_price] = InventoryPlayer[playerid][old_slot][inv_market_buy_price];
            InventoryPlayer[playerid][new_slot][inv_market_buy_amount] = InventoryPlayer[playerid][old_slot][inv_market_buy_amount];
        }
        if(InventoryPlayer[playerid][old_slot][inv_market_sell_price] > 0 || InventoryPlayer[playerid][old_slot][inv_market_sell_amount] > 0)
        {
            InventoryPlayer[playerid][new_slot][inv_market_sell_price] = InventoryPlayer[playerid][old_slot][inv_market_sell_price];
            InventoryPlayer[playerid][new_slot][inv_market_sell_amount] = InventoryPlayer[playerid][old_slot][inv_market_sell_amount];
        }

        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d",
            InventoryPlayer[playerid][new_slot][inv_amount], InventoryPlayer[playerid][new_slot][inv_mysql_id]);
        mysql_tquery(con_bd, STRING_GLOBAL, "Equipment_Update", "i", playerid);

        DropPlayerEquipment(playerid, old_slot);
    }
    else
    {
        InventoryPlayer[playerid][new_slot][inv_amount] += iFreeItems;
        InventoryPlayer[playerid][old_slot][inv_amount] -= iFreeItems;

        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL),
            "UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d;\
            UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d;",
            InventoryPlayer[playerid][new_slot][inv_amount], InventoryPlayer[playerid][new_slot][inv_mysql_id],
            InventoryPlayer[playerid][old_slot][inv_amount], InventoryPlayer[playerid][old_slot][inv_mysql_id]);
        mysql_tquery(con_bd, STRING_GLOBAL, "Equipment_Update", "i", playerid);
    }
    printf("LOG_PLAYER: %s[%d](%s %s) обьеденил <%s> в %d ед. | #Inventory#Uni",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        ItemsInfo[InventoryPlayer[playerid][new_slot][inv_item_id]][iName],
        InventoryPlayer[playerid][new_slot][inv_amount]);
    return 1;
}

GetFreeSlotInventory(playerid, type_inv)
{
    new max_slot, min_slot;
    GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
    max_slot++, min_slot++;
    if(min_slot >= max_slot) return -1;

    for(new i = min_slot; i < max_slot; i++)
    {
        if(InventoryPlayer[playerid][i][inv_mysql_id] == INVALID_MYSQL_ID &&
            InventoryPlayer[playerid][i][inv_item_id] == 0 &&
            InventoryPlayer[playerid][i][inv_market_sell_price] == 0 &&
            InventoryPlayer[playerid][i][inv_market_buy_price] == 0)
        {
            return i;
        }
    }
    return -1;
}

forward GetInventoryMysqlID(playerid, slot_id);
public GetInventoryMysqlID(playerid, slot_id)
{
    InventoryPlayer[playerid][slot_id][inv_mysql_id] = cache_insert_id();

    new slot_skin_id = GetPVarInt(playerid, #INV_SKIN_USE)-1;
    if(slot_skin_id == slot_id)
    {
        SetPlayerSkinUse(playerid, slot_skin_id);
        DeletePVar(playerid, #INV_SKIN_USE);
    }

    Equipment_Update(playerid);
    return 1;
}
////////////////////////////////////////////////
TransferPlayerSkins(playerid)
{
    new status_skin;
    for(new i; i < MAX_PLAYER_SKINS; i++)
    {
        if(p_info[playerid][skins][i] == 0) continue;
        status_skin = i == p_info[playerid][active_skin_id] ? 1 : 0;
        if(GivePlayerInventory(playerid, p_info[playerid][skins][i], .reason = "перенос из old inventory", .status_use = status_skin))
        {
            if(status_skin)
            {
                p_info[playerid][active_skin_id] = -1;
                MysqlUpdatePlayerInt(playerid, "active_skin_id", p_info[playerid][active_skin_id]);
            }
            p_info[playerid][skins][i] = 0;
        }
    }

    STRING_GLOBAL[0] = EOS;
    for(new i; i < MAX_PLAYER_SKINS; i++) f(STRING_GLOBAL, "%s%i%s", STRING_GLOBAL, p_info[playerid][skins][i], i == MAX_PLAYER_SKINS-1 ? "":"|");
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `accounts` SET `skins` = '%s' WHERE `id` = %d", STRING_GLOBAL, p_info[playerid][ID]);
    mysql_tquery(con_bd, STRING_GLOBAL);
    return 1;
}

SetPlayerSkinUse(playerid, new_slot)
{
    if(ItemsInfo[InventoryPlayer[playerid][new_slot][inv_item_id]][iType] != TYPE_ITEMS_SKINS)
        return SendError(playerid, "Тип не соответствует одежде. Обратитесь на форум.");

    if(InventoryPlayer[playerid][new_slot][inv_status_use] == 0 && InventoryPlayer[playerid][new_slot][inv_skin_wear] == 0)
        return SendError(playerid, "Данная одежда слишком грязная, постирайте её в прачечной.");

    InventoryPlayer[playerid][new_slot][inv_status_use] = !InventoryPlayer[playerid][new_slot][inv_status_use];

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `status_use` = %d WHERE `mysql_id` = %d",
        InventoryPlayer[playerid][new_slot][inv_status_use], InventoryPlayer[playerid][new_slot][inv_mysql_id]);
    mysql_tquery(con_bd, STRING_GLOBAL);

    new max_slot, min_slot;
    GetSlotInfoInventory(playerid, EQUIPMENT_INVENTORY_PLAYER, max_slot, min_slot);
    if(min_slot < max_slot)
    {
        for(new i = max_slot; i != min_slot; i--)
        {
            if(i == new_slot) continue;
            if(InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID &&
                ItemsInfo[InventoryPlayer[playerid][i][inv_item_id]][iType] == TYPE_ITEMS_SKINS &&
                InventoryPlayer[playerid][i][inv_status_use] == 1)
            {
                InventoryPlayer[playerid][i][inv_status_use] = 0;

                STRING_GLOBAL[0] = EOS;
                mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `status_use` = %d WHERE `mysql_id` = %d",
                    InventoryPlayer[playerid][i][inv_status_use], InventoryPlayer[playerid][i][inv_mysql_id]);
                mysql_tquery(con_bd, STRING_GLOBAL);
                break;
            }
        }
    }
    SetPlayerSkinEx(playerid);

    Equipment_Update(playerid);
    Equipment_Info(playerid);
    return 1;
}

SetPlayerSkinEx(playerid)
{
    //if(!p_info[playerid][loggedIn]) return 1;
    if(p_info[playerid][member] > 0 && p_info[playerid][fwork] == true)
    {
        if(p_info[playerid][fskin] == 0) SetPlayerFractionSkin(playerid);
        else SetPlayerSkin(playerid, p_info[playerid][fskin]);
    }
    else
    {
        new family_idx = p_temp[playerid][family_game_id],
            family_rang_id = GetFamilyRang(playerid)-1,
            skin_id = GetFamilySkinID(p_info[playerid][sex], family_idx, family_rang_id);
        if(p_info[playerid][p_settings][SKIN_DEFAULT] == 1 && family_idx != -1 && skin_id != INVALID_SKIN_ID)
            SetPlayerSkin(playerid, skin_id);
        else
        {
            new skin_id = GetPlayerUseSkinID(playerid);
            if(skin_id == INVALID_SKIN_ID) skin_id = p_info[playerid][sex] == 2 ? 252 : 251;
            if(skin_id == 74) skin_id = 0;
            SetPlayerSkin(playerid, skin_id);
        }
    }
    if(p_temp[playerid][rob_house_idx] == -1 && p_temp[playerid][rob_bank_idx] == -1 && p_temp[playerid][rob_fuel_idx] == -1 && p_temp[playerid][cossack_robbers_register] != 2) AttachToPlayerAccOrCostume(playerid, INVALID_PLAYER_ID);
    return 1;
}

GetPlayerUseSkinID(playerid)
{
    new max_slot, min_slot;
    GetSlotInfoInventory(playerid, EQUIPMENT_INVENTORY_PLAYER, max_slot, min_slot);
    if(min_slot >= max_slot) return INVALID_SKIN_ID;//SendError(playerid, "Количество слотов инвентаря не определено.");
    for(new i = max_slot; i != min_slot; i--)
    {
        if(InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID &&
            ItemsInfo[InventoryPlayer[playerid][i][inv_item_id]][iType] == TYPE_ITEMS_SKINS &&
            InventoryPlayer[playerid][i][inv_status_use] != 0)
        return InventoryPlayer[playerid][i][inv_item_id];
    }
    return INVALID_SKIN_ID;
}
////////////////////////////////////////////////
UsePlayerInventoryItems(playerid, idx)
{
	if(!GetInventoryAmount(playerid, idx)) return SendError(playerid, "У Вас нет \"%s\".", ItemsInfo[idx][iName]);
	switch(idx)
	{
		case 627, 628, 634, 637, 635, 640, 641, 645, 647 .. 651, 682, 685 .. 687, 689 .. 691, 700 .. 717, 734: return SendError(playerid, "Данный предмет нельзя использовать.");
		case 629: callcmd::usedrugs(playerid, "/0");
		case 646: callcmd::cdrugs(playerid, "/0");
		case 630: callcmd::pour(playerid, "/0");
		case 631: callcmd::repaircar(playerid, "/0");
		case 632: callcmd::healme(playerid, "/0");
		case 633: callcmd::mask(playerid, "/0");
		case 636: callcmd::tie(playerid, "/0");
		case 638: callcmd::eat(playerid, "1");
		case 639: callcmd::eat(playerid, "2");
		case 642 .. 644:
		{
            HideTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
			SetTimerEx("Fix_ShowPlayerRoulette", 500, false, "dd", playerid, idx);
		}
		case 652: callcmd::smoke(playerid, "/0");
		case 653:
        {
            HideTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
            callcmd::hookah(playerid, "/0");
        }
        case 654 .. 673:
		{
            HideTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
			SetTimerEx("Fix_ShowPlayerCase", 500, false, "dd", playerid, idx);
		}
		case 674 .. 678:
		{
            HideTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
			SetTimerEx("Fix_ShowPlayerPhone", 500, false, "dd", playerid, idx);
		}
		case 679, 680:
        {
            HideTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
            callcmd::tent(playerid, "/0");
        }
		case 681: callcmd::ipremium(playerid, "/0");
		case 683: callcmd::reanimate(playerid, "/0");
		case 684: callcmd::fish(playerid, "/0");
		case 688: callcmd::fish(playerid, "/0");
		case 694:
        {
            HideTextDrawForPlayer(playerid, TD_ID_INVENTORY_PLAYER);
            callcmd::bonfire(playerid, "/0");
        }
		case 695: callcmd::drink(playerid, "1");
		case 696: callcmd::drink(playerid, "2");
		case 697: callcmd::drink(playerid, "3");
		case 698: callcmd::drink(playerid, "4");
		case 699: callcmd::drink(playerid, "5");
        case 718 .. 728: OnPlayerOpenCasket(playerid, idx);
        case 729: AccessoriesPlayerList(playerid, ACCESSORIES_ID_PREMIUM);
        case 730:
        {
            if(!GivePlayerInventory(playerid, 730, -1)) return 1;
            if(p_info[playerid][battle_info][0] == 1) return SendError(playerid, "У Вас уже есть Premium.");
            p_info[playerid][battle_info][0] = 1;
            SavePlayerBattlePass(playerid, BATTLEPASS_TYPE_INFO);
            SendAccess(playerid, "Вы активировали Battle Pass Premium.");
        }
        case 731:
        {
            if(!GivePlayerInventory(playerid, 731, -1)) return 1;
            if(p_info[playerid][battle_info][1] == 1) return SendError(playerid, "У Вас уже есть ускоритель опыта.");
            p_info[playerid][battle_info][1] = 1;
            SavePlayerBattlePass(playerid, BATTLEPASS_TYPE_INFO);
            SendAccess(playerid, "Вы активировали ускоритель опыта.");
        }
        case 732:
        {
            if(p_info[playerid][p_vip] != 3) return SendError(playerid, "У Вас нет \"VIP Gold\" или выше. Приобрести: /donate");
            if(!GivePlayerInventory(playerid, 732, -1)) return 1;
            new list_idx[] = {721, 722, 723, 724, 725, 726, 727, 728}, items_idx = list_idx[random(sizeof(list_idx))], items_count = 10;
            if(!GivePlayerInventory(playerid, items_idx, items_count)) return SendError(playerid, "В инвентаре нет места.");
            SendMes(playerid, COLOR_YELLOW, "[ИНВЕНТАРЬ]: "W"В инвентарь добавлен предмет {"#cYELLOW"}\"%s\"."W" Количество: {"#cYELLOW"}%d.", ItemsInfo[items_idx][iName], items_count);
            SendMesAll(COLOR_LIGHTRED, "[ADD VIP]: "W"%s [%d] активировал(-а) ADD VIP на 30 дней.", get_name(playerid), playerid);
            if(p_info[playerid][p_add_vip] != 1) p_info[playerid][p_add_vip_time] = 0;
            p_info[playerid][p_add_vip] = 1;
            if(p_info[playerid][p_add_vip_time]) p_info[playerid][p_add_vip_time] += 86400 * 30;
            else p_info[playerid][p_add_vip_time] = (gettime() + (86400 * 30));
        }
        case 733:
        {
            if(!GivePlayerInventory(playerid, 733, -1)) return 1;
            SendMesAll(COLOR_LIGHTRED, "[МУЗЫКАЛЬНАЯ ПОДПИСКА]: "W"%s [%d] активировал(-а) музыкальную подписку на 30 дней.", get_name(playerid), playerid);
            p_info[playerid][p_flin_music] = 1;
            if(p_info[playerid][p_flin_music_time]) p_info[playerid][p_flin_music_time] += 86400 * 30;
            else p_info[playerid][p_flin_music_time] = (gettime() + (86400 * 30));
        }
        case 735, 736:
        {
            SetPVarInt(playerid, "LoadResourcesHouseIDx", idx);
            HousePlayerList(playerid, HOUSE_ID_RESOURCES);
        }
        case 737: SkinsPlayerList(playerid, SKINS_ID_PREMIUM);
        case 738:
        {
            if(p_info[playerid][p_vip] != 3) return SendError(playerid, "У Вас нет \"VIP Gold\" или выше. Приобрести: /donate");
            if(!GivePlayerInventory(playerid, 738, -1)) return 1;
            new list_idx[] = {721, 722, 723, 724, 725, 726, 727, 728}, items_idx = list_idx[random(sizeof(list_idx))], items_count = 10;
            if(!GivePlayerInventory(playerid, items_idx, items_count)) return SendError(playerid, "В инвентаре нет места.");
            SendMes(playerid, COLOR_YELLOW, "[ИНВЕНТАРЬ]: "W"В инвентарь добавлен предмет {"#cYELLOW"}\"%s\"."W" Количество: {"#cYELLOW"}%d.", ItemsInfo[items_idx][iName], items_count);
            SendMesAll(COLOR_LIGHTRED, "[ADD VIP]: "W"%s [%d] активировал(-а) ADD VIP навсегда.", get_name(playerid), playerid);
            if(p_info[playerid][p_add_vip] != 1) p_info[playerid][p_add_vip_time] = 0;
            p_info[playerid][p_add_vip] = 1;
            if(p_info[playerid][p_add_vip_time]) p_info[playerid][p_add_vip_time] += 86400 * 3650;
            else p_info[playerid][p_add_vip_time] = (gettime() + (86400 * 3650));
        }
		default: return SendError(playerid, "Произошла ошибка, повторите операцию.");
	}
	return 1;
}
////////////////////////////////////////////////
forward Fix_ShowPlayerRoulette(playerid, idx);
public Fix_ShowPlayerRoulette(playerid, idx)
{
	ShowPlayerRoulette(playerid, idx-(TRANSFER_ITEMS+15));
	return 1;
}

forward Fix_ShowPlayerCase(playerid, idx);
public Fix_ShowPlayerCase(playerid, idx)
{
	ShowPlayerCase(playerid, idx-(TRANSFER_ITEMS+27));
	return 1;
}

forward Fix_ShowPlayerPhone(playerid, idx);
public Fix_ShowPlayerPhone(playerid, idx)
{
	ShowPlayerPhone(playerid, idx);
	return 1;
}

CMD:inventory(playerid, params[])
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return SendError(playerid, "В транспортном средстве нельзя пользоваться инвентарем.");
	ShowPlayerInventory(playerid);
	return 1;
}
alias:inventory("inv", "acc", "accessories", "skin", "skins");

LoadPlayerInventory(playerid)
{
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL),
        "SELECT * FROM `inventory` WHERE `owner_id` = %d AND `owner_type` = %d ORDER BY `slot_id` ASC", p_info[playerid][ID], INVENTORY_OWNER_TYPE_PLAYER);
    mysql_tquery(con_bd, STRING_GLOBAL, "LoadInventoryData", "ii", playerid, EQUIPMENT_INVENTORY_PLAYER);
}

forward LoadInventoryData(playerid, type_inv);
public LoadInventoryData(playerid, type_inv)
{
    new rows;
    cache_get_row_count(rows);
    if(rows)
    {
        new data[128], temp_slot,
            max_slot, min_slot;
        GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
        if(min_slot >= max_slot) return 0;
        min_slot++, max_slot++;
        for(new i; i < rows; i++)
        {
            cache_get_value_name_int(i, "slot_id", temp_slot);
            if(temp_slot >= max_slot)
            {
                SendError(playerid, "Не возможно загрузить информацию слот: %d", temp_slot);
                continue;
            }
            InventoryPlayer[playerid][temp_slot][inv_slot_id] = temp_slot;
            cache_get_value_name_int(i, "mysql_id",         InventoryPlayer[playerid][temp_slot][inv_mysql_id]);
            cache_get_value_name_int(i, "item_id",          InventoryPlayer[playerid][temp_slot][inv_item_id]);
            cache_get_value_name_int(i, "amount",           InventoryPlayer[playerid][temp_slot][inv_amount]);
 
            if(ItemsInfo[InventoryPlayer[playerid][temp_slot][inv_item_id]][iType] == TYPE_ITEMS_ACCESSORIES)
            {
                cache_get_value_name_int(i, "status_use",       InventoryPlayer[playerid][temp_slot][inv_status_use]);
                cache_get_value_name_int(i, "acc_slot",         InventoryPlayer[playerid][temp_slot][inv_acc_slot]);
 
                cache_get_value_name_int(i, "acc_mt1",          InventoryPlayer[playerid][temp_slot][inv_acc_mt][0]);
                cache_get_value_name_int(i, "acc_mt2",          InventoryPlayer[playerid][temp_slot][inv_acc_mt][1]);
                cache_get_value_name_float(i, "acc_wear",       InventoryPlayer[playerid][temp_slot][inv_acc_wear]);

                cache_get_value_name_int(i, "inv_acc_premium",  InventoryPlayer[playerid][temp_slot][inv_acc_premium]);

                cache_get_value_name(i, "acc_pos", data);
                sscanf(data, "p<|>a<f>[9]",                     InventoryPlayer[playerid][temp_slot][inv_acc_pos]);
            }
            else if(ItemsInfo[InventoryPlayer[playerid][temp_slot][inv_item_id]][iType] == TYPE_ITEMS_SKINS)
            {
                cache_get_value_name_int(i, "status_use",       InventoryPlayer[playerid][temp_slot][inv_status_use]);
                cache_get_value_name_float(i, "skin_wear",      InventoryPlayer[playerid][temp_slot][inv_skin_wear]);

                cache_get_value_name_int(i, "inv_skin_premium", InventoryPlayer[playerid][temp_slot][inv_skin_premium]);
            }
        }
        if(max_slot < MAX_EQUIPMENT_ALL)
        {
            for(new i = max_slot; i < MAX_EQUIPMENT_ALL; i++)
                Equipment_PlayerClear(playerid, i);
        }
    }
    if(type_inv == EQUIPMENT_INVENTORY_PLAYER)
    {
        TransferPlayerSkins(playerid);
        SetPlayerSkinEx(playerid);
    }
    else
        Equipment_Left(playerid, type_inv);
    return 1;
}

GivePlayerInventory(playerid, id, amount = 1, Float:wear = 100.0, mc1 = 0, mc2 = 0, reason[] = "", status_use = 0, type_inv = EQUIPMENT_INVENTORY_PLAYER, premium = 0)
{
    if(id < 1)
    {
        SendError(playerid, "Не верный ID предмета.");
        return 0;
    }
    if(!(EQUIPMENT_INVENTORY_PLAYER <= type_inv < EQUIPMENT_INVENTORY_ALL))
    {
        SendError(playerid, "Не определен тип инвентаря.");
        return 0;
    }
    switch(ItemsInfo[id][iType])
    {
        case TYPE_ITEMS_INVENTORY:
        {
            if(!ProcessChangePlayerInventory(playerid, id, amount, type_inv))
            {
                if(amount > 0) SendError(playerid, "В инвентаре нет места для предмета.");
                return 0;
            }
            if(strlen(reason) != 0)
            {
                new ownerID;
                switch(type_inv)
                {
                    case EQUIPMENT_INVENTORY_PLAYER:
                        printf("LOG_PLAYER: %s[%d](%s %s) получил/потерял <%s> %d ед. за <%s> | #Inventory#Change",
                            get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                            ItemsInfo[id][iName], abs(amount), reason);
                    case EQUIPMENT_INVENTORY_HOUSE:
                    {
                        ownerID = p_temp[playerid][p_house_id];
                        printf("LOG_PLAYER: %s[%d](%s %s) положил/взял <%s> %d ед. в доме (%d) за <%s> | #Inventory #Change",
                            get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                            ItemsInfo[id][iName], abs(amount), ownerID, reason);
                    }
                    case EQUIPMENT_INVENTORY_VEHICLE:
                    {
                        new vehicleid = GetPVarInt(playerid, #BOOT_VEHICLEID);
                        ownerID = veh_info[vehicleid][v_mysql_id];
                        printf("LOG_PLAYER: %s[%d](%s %s) положил/взял <%s> %d ед. в автомобиле <%s>(%d)[%d] за <%s> | #Inventory #Change",
                            get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                            ItemsInfo[id][iName], abs(amount), GetVehicleName(vehicleid), GetVehicleModelEx(vehicleid), ownerID, reason);
                    }
                    case EQUIPMENT_INVENTORY_TRASHBOX:
                    {
                        ownerID = p_temp[playerid][trash_id];
                        printf("LOG_PLAYER: %s[%d](%s %s) положил/взял <%s> %d ед. в мусорку (%d) за <%s> | #Inventory #Change",
                            get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                            ItemsInfo[id][iName], abs(amount), ownerID, reason);
                    }
                }
            }
        }
        case TYPE_ITEMS_ACCESSORIES:
        {
            if(amount > 0)
            {
                if(!ProcessGivePlayerAccessories(playerid, id, wear, mc1, mc2, type_inv, premium))
                {
                    SendError(playerid, "В инвентаре нет места для акссесуара.");
                    return 0;
                }
                if(strlen(reason) != 0)
                    printf("LOG_PLAYER: %s[%d](%s %s) получил <%s>(%d) [%.1f] (%s/%s) за <%s> | #Inventory#Change",
                        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                        ItemsInfo[id][iName], id, wear, AccessoriesColorInfo[mc1][acName], AccessoriesColorInfo[mc2][acName], reason);
            }
            else
            {
                new max_slot, min_slot;
                GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
                if(min_slot >= max_slot) return 0;
                for(new i = max_slot; i != min_slot; i--)
                {
                    if(InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID && InventoryPlayer[playerid][i][inv_item_id] == id)
                    {
                        DropPlayerEquipment(playerid, i);
                        return 1;
                    }
                }
                return 0;
            }
        }
        case TYPE_ITEMS_SKINS:
        {
            if(amount > 0)
            {
                if(!ProcessGivePlayerSkins(playerid, id, wear, status_use, type_inv, premium))
                {
                    SendError(playerid, "В инвентаре нет места для скина.");
                    return 0;
                }
                if(strlen(reason) != 0)
                    printf("LOG_PLAYER: %s[%d](%s %s) получил <%s>(%d) за <%s> | #Inventory#Change",
                        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                        ItemsInfo[id][iName], id, reason);
            }
            else
            {
                new max_slot, min_slot;
                GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
                if(min_slot >= max_slot) return 0;
                for(new i = max_slot; i != min_slot; i--)
                {
                    if(InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID && InventoryPlayer[playerid][i][inv_item_id] == id)
                    {
                        DropPlayerEquipment(playerid, i);
                        return 1;
                    }
                }
                return 0;
            }
        }
    }
    return 1;
}

ProcessGivePlayerSkins(playerid, skin_id, Float:wear, status_use, type_inv, premium)
{
    new free_slot = GetFreeSlotInventory(playerid, type_inv);
    if(free_slot == -1) return 0;
    InventoryPlayer[playerid][free_slot][inv_slot_id]       = free_slot;
    InventoryPlayer[playerid][free_slot][inv_item_id]       = skin_id;
    InventoryPlayer[playerid][free_slot][inv_amount]        = 1;
    InventoryPlayer[playerid][free_slot][inv_status_use]    =
    InventoryPlayer[playerid][free_slot][inv_acc_mt][0]     =
    InventoryPlayer[playerid][free_slot][inv_acc_mt][1]     = 0;
    InventoryPlayer[playerid][free_slot][inv_acc_wear]      = 100.0;
    InventoryPlayer[playerid][free_slot][inv_skin_wear]     = wear;
    InventoryPlayer[playerid][free_slot][inv_acc_premium]   = 0;
    InventoryPlayer[playerid][free_slot][inv_skin_premium]  = premium;
    for(new i = 8; i != -1; i--) InventoryPlayer[playerid][free_slot][inv_acc_pos][i] = 0.0;

    new ownerID, ownerType;
    switch(type_inv)
    {
        case EQUIPMENT_INVENTORY_PLAYER:
        {
            ownerID = p_info[playerid][ID];
            ownerType = INVENTORY_OWNER_TYPE_PLAYER;
        }
        case EQUIPMENT_INVENTORY_HOUSE:
        {
            ownerID = p_temp[playerid][p_house_id];
            ownerType = INVENTORY_OWNER_TYPE_HOUSE;
        }
        case EQUIPMENT_INVENTORY_VEHICLE:
        {
            ownerID = veh_info[GetPVarInt(playerid, #BOOT_VEHICLEID)][v_mysql_id];
            ownerType = INVENTORY_OWNER_TYPE_VEHICLE;
        }
        case EQUIPMENT_INVENTORY_TRASHBOX:
        {
            ownerID = p_temp[playerid][trash_id];
            ownerType = INVENTORY_OWNER_TYPE_TRASHBOX;
        }
    }

    if(status_use)
        SetPVarInt(playerid, #INV_SKIN_USE, free_slot+1);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL),
        "INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`, `acc_mt1`, `acc_mt2`, `acc_wear`, `skin_wear`, `inv_acc_premium`, `inv_skin_premium`) \
            VALUES (%d, %d, %d, %d, %d, 0, 0, 100.0, %f, 0, %d)",
        InventoryPlayer[playerid][free_slot][inv_slot_id], ownerID, ownerType,
        skin_id, InventoryPlayer[playerid][free_slot][inv_amount], InventoryPlayer[playerid][free_slot][inv_skin_wear], InventoryPlayer[playerid][free_slot][inv_skin_premium]);
    mysql_tquery(con_bd, STRING_GLOBAL, "GetInventoryMysqlID", "ii", playerid, free_slot);
    return 1;
}

ProcessChangePlayerInventory(playerid, item_id, amount, type_inv)
{
    if(amount == 0) return 0;
    new max_slot, min_slot;
    GetSlotInfoInventory(playerid, type_inv, max_slot, min_slot);
    if(min_slot >= max_slot) return 0;

    new iAmountItems, iTempAmount, iInvCells, arraySlots[MAX_EQUIPMENT_ALL],
        ownerID, ownerType;
    if(amount > 0) // код для выдачи предметов инвентаря
    {
        for(new i = max_slot; i != min_slot; i--)
        {
            if((InventoryPlayer[playerid][i][inv_mysql_id] == INVALID_MYSQL_ID &&
                    (InventoryPlayer[playerid][i][inv_item_id] == 0 || InventoryPlayer[playerid][i][inv_item_id] == item_id)
                ) || (InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID && InventoryPlayer[playerid][i][inv_item_id] == item_id))
            {
                iTempAmount = ItemsInfo[item_id][iMax]-InventoryPlayer[playerid][i][inv_amount];
                if(iTempAmount != 0)
                {
                    iAmountItems += iTempAmount;
                    arraySlots[iInvCells] = i;
                    iInvCells++;
                }
            }
        }
        if(amount > iAmountItems) return 0;
        for(new i = iInvCells-1; i != -1; i--)
        {
            iTempAmount = ItemsInfo[item_id][iMax]-InventoryPlayer[playerid][arraySlots[i]][inv_amount];
            if(amount < iTempAmount) iTempAmount = amount;
            InventoryPlayer[playerid][arraySlots[i]][inv_amount] += iTempAmount;
            amount -= iTempAmount;

            if(InventoryPlayer[playerid][arraySlots[i]][inv_mysql_id] == INVALID_MYSQL_ID)
            {
                InventoryPlayer[playerid][arraySlots[i]][inv_slot_id]    = arraySlots[i];
                InventoryPlayer[playerid][arraySlots[i]][inv_item_id]    = item_id;
                InventoryPlayer[playerid][arraySlots[i]][inv_status_use] = 0;

                switch(type_inv)
                {
                    case EQUIPMENT_INVENTORY_PLAYER:
                    {
                        ownerID = p_info[playerid][ID];
                        ownerType = INVENTORY_OWNER_TYPE_PLAYER;
                    }
                    case EQUIPMENT_INVENTORY_HOUSE:
                    {
                        ownerID = p_temp[playerid][p_house_id];
                        ownerType = INVENTORY_OWNER_TYPE_HOUSE;
                    }
                    case EQUIPMENT_INVENTORY_VEHICLE:
                    {
                        ownerID = veh_info[GetPVarInt(playerid, #BOOT_VEHICLEID)][v_mysql_id];
                        ownerType = INVENTORY_OWNER_TYPE_VEHICLE;
                    }
                    case EQUIPMENT_INVENTORY_TRASHBOX:
                    {
                        ownerID = p_temp[playerid][trash_id];
                        ownerType = INVENTORY_OWNER_TYPE_TRASHBOX;
                    }
                }

                STRING_GLOBAL[0] = EOS;
                mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`) VALUES (%d, %d, %d, %d, %d)",
                   InventoryPlayer[playerid][arraySlots[i]][inv_slot_id], ownerID, ownerType,
                   InventoryPlayer[playerid][arraySlots[i]][inv_item_id], InventoryPlayer[playerid][arraySlots[i]][inv_amount]);
                mysql_tquery(con_bd, STRING_GLOBAL, "GetInventoryMysqlID", "ii", playerid, arraySlots[i]);
            }
            else
            {
                STRING_GLOBAL[0] = EOS;
                mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d",
                    InventoryPlayer[playerid][arraySlots[i]][inv_amount], InventoryPlayer[playerid][arraySlots[i]][inv_mysql_id]);
                mysql_tquery(con_bd, STRING_GLOBAL, "Equipment_Update", "i", playerid);
            }
            if(amount == 0) break;
        }
        if(amount > 0) {
            SendError(playerid, "Произошла не известная ошибка: 090122.");
            return 0;
        }
    }
    else
    { // для отнимания предметов инвентаря
        for(new i = max_slot; i != min_slot; i--)
        {
            if(InventoryPlayer[playerid][i][inv_mysql_id] != INVALID_MYSQL_ID && InventoryPlayer[playerid][i][inv_item_id] == item_id)
            {
                iAmountItems += InventoryPlayer[playerid][i][inv_amount];
                arraySlots[iInvCells] = i;
                iInvCells++;
            }
        }
        amount = abs(amount);
        if(iAmountItems < amount)
        {
            SendError(playerid, "В инвентаре нет достаточного количества предметов.");
            return 0;
        }
        for(new i = iInvCells-1; i != -1; i--)
        {
            iTempAmount = InventoryPlayer[playerid][arraySlots[i]][inv_amount];
            if(amount < iTempAmount) iTempAmount = amount;
            InventoryPlayer[playerid][arraySlots[i]][inv_amount] -= iTempAmount;
            amount -= iTempAmount;

            if(InventoryPlayer[playerid][arraySlots[i]][inv_amount] == 0)
                DropPlayerEquipment(playerid, arraySlots[i]);
            else
            {
                STRING_GLOBAL[0] = EOS;
                mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d",
                    InventoryPlayer[playerid][arraySlots[i]][inv_amount], InventoryPlayer[playerid][arraySlots[i]][inv_mysql_id]);
                mysql_tquery(con_bd, STRING_GLOBAL, "Equipment_Update", "i", playerid);
            }
            if(amount == 0) break;
        }
        if(amount != 0) {
            SendError(playerid, "Произошла не известная ошибка: 19.01-17:00.");
            return 0;
        }
    }
    return 1;
}

ProcessGivePlayerAccessories(playerid, accessories_idx, Float:wear, mc1, mc2, type_inv, premium)
{
    new free_slot = GetFreeSlotInventory(playerid, type_inv);
    if(free_slot == -1) return 0;
    InventoryPlayer[playerid][free_slot][inv_slot_id]       = free_slot;
    InventoryPlayer[playerid][free_slot][inv_item_id]       = accessories_idx;
    InventoryPlayer[playerid][free_slot][inv_amount]        = 1;
    InventoryPlayer[playerid][free_slot][inv_status_use]    = 0;
    InventoryPlayer[playerid][free_slot][inv_acc_mt][0]     = mc1;
    InventoryPlayer[playerid][free_slot][inv_acc_mt][1]     = mc2;
    InventoryPlayer[playerid][free_slot][inv_acc_wear]      = wear;
    InventoryPlayer[playerid][free_slot][inv_skin_wear]     = 100.0;
    InventoryPlayer[playerid][free_slot][inv_acc_premium]   = premium;
    InventoryPlayer[playerid][free_slot][inv_skin_premium]  = 0;
    for(new i = 8; i != -1; i--) InventoryPlayer[playerid][free_slot][inv_acc_pos][i] = 0.0;

    new ownerID, ownerType;
    switch(type_inv)
    {
        case EQUIPMENT_INVENTORY_PLAYER:
        {
            ownerID = p_info[playerid][ID];
            ownerType = INVENTORY_OWNER_TYPE_PLAYER;
        }
        case EQUIPMENT_INVENTORY_HOUSE:
        {
            ownerID = p_temp[playerid][p_house_id];
            ownerType = INVENTORY_OWNER_TYPE_HOUSE;
        }
        case EQUIPMENT_INVENTORY_VEHICLE:
        {
            ownerID = veh_info[GetPVarInt(playerid, #BOOT_VEHICLEID)][v_mysql_id];
            ownerType = INVENTORY_OWNER_TYPE_VEHICLE;
        }
        case EQUIPMENT_INVENTORY_TRASHBOX:
        {
            ownerID = p_temp[playerid][trash_id];
            ownerType = INVENTORY_OWNER_TYPE_TRASHBOX;
        }
    }

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL),
        "INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`, `acc_mt1`, `acc_mt2`, `acc_wear`, `skin_wear`, `inv_acc_premium`, `inv_skin_premium`) \
            VALUES (%d, %d, %d, %d, %d, %d, %d, %f, 100.0, %d, 0)",
        InventoryPlayer[playerid][free_slot][inv_slot_id], ownerID, ownerType,
        accessories_idx, InventoryPlayer[playerid][free_slot][inv_amount], mc1, mc2, InventoryPlayer[playerid][free_slot][inv_acc_wear], InventoryPlayer[playerid][free_slot][inv_acc_premium]);
    mysql_tquery(con_bd, STRING_GLOBAL, "GetInventoryMysqlID", "ii", playerid, free_slot);
    return 1;
}

GetSlotInfoInventory(playerid, type_inv, &max_slot, &min_slot)
{
    //if(!p_info[playerid][loggedIn]) return 1;
    max_slot = -1, min_slot = -1;
    switch(type_inv)
    {
        case EQUIPMENT_INVENTORY_PLAYER:
        {
            max_slot = p_info[playerid][inv_slots]-1;
        }
        case EQUIPMENT_INVENTORY_HOUSE:
        {
            new houseId = p_temp[playerid][p_house_id];
            if(houseId != INVALID_HOUSE_ID)
            {
                max_slot = MAX_PLAYER_EQUIPMENT+h_info[houseId][h_squar]*5-1;
                min_slot = MAX_PLAYER_EQUIPMENT-1;
            }
            else SendError(playerid, "Код ошибки: 1095 (Обратитесь к администрации)");
        }
        case EQUIPMENT_INVENTORY_VEHICLE:
        {
            new vehicleid = GetPVarInt(playerid, #BOOT_VEHICLEID);
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                max_slot = MAX_PLAYER_EQUIPMENT;
                new vehicle_class = GetVehicleData(GetVehicleModelEx(vehicleid), E_VD_CLASS);
                switch(vehicle_class)
                {
                    case VEHICLE_CLASS_NOPE, VEHICLE_CLASS_C, VEHICLE_CLASS_B: max_slot += (vehicle_class+1)*5-1;
                    default: max_slot += 20-1;
                }
                min_slot = MAX_PLAYER_EQUIPMENT-1;
            }
            else SendError(playerid, "Код ошибки: 1096 (Обратитесь к администрации)");
        }
        case EQUIPMENT_INVENTORY_TRASHBOX:
        {
            new trashbox = p_temp[playerid][trash_id];
            if(trashbox != -1)
            {
                max_slot = MAX_EQUIPMENT_ALL-1;
                min_slot = MAX_PLAYER_EQUIPMENT-1;
            }
            else SendError(playerid, "Код ошибки: 1097 (Обратитесь к администрации)");
        }
        default: return 1;
    }
    if(min_slot >= max_slot) SendError(playerid, "Неверное количество слотов инвентаря.");
    return 1;
}
/*
    new max_slot, min_slot;
    GetSlotInfoInventory(playerid, EQUIPMENT_INVENTORY_PLAYER, max_slot, min_slot);
    if(min_slot >= max_slot) return 1;
*/
////////////////////////////////////////////////////////
ClearInventoryItems(owner_id, type_owner)
{
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `inventory` WHERE `owner_id` = %d AND `owner_type` = %d", owner_id, type_owner);
    mysql_tquery(con_bd, STRING_GLOBAL);
}

cmd:cleartrashbox(playerid, params[])
{
    if(p_info[playerid][admin] < 6) return 1;
    for(new i = 20-1; i != -1; i--) ClearInventoryItems(i, INVENTORY_OWNER_TYPE_TRASHBOX);
    return 1;
}
