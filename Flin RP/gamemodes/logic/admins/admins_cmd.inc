CMD:newnick(playerid, params[])
{
    if(p_info[playerid][admin] < 7) return 1;
    if(sscanf(params, "s[24]", params[0])) return SendInfo(playerid, "Используйте: /newnick [никнейм]");
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `new_name` FROM `log_name` WHERE `old_name` = '%s' LIMIT 1", params[0]);
    new Cache:result = mysql_query(con_bd, STRING_GLOBAL);
    if(cache_num_rows() == 0)
    {
        cache_delete(result);
        return SendError(playerid, "Ник не был сменен.");
    }
    new nickname[MAX_PLAYER_NAME];
    cache_get_value_index(0, 0, nickname);
    cache_delete(result);
    SendAccess(playerid, "Ник %s был сменен на ник: "E"%s", params[0], nickname);
    return 1;
}

CMD:editproperty(playerid, params[])
{
    if(p_info[playerid][admin] < 7) return 1;
    if(sscanf(params, "is[24]", params[0], params[1])) {
        SendInfo(playerid, "Используйте: /editproperty [typeid] [никнейм]");
        SendInfo(playerid, "types: 1-house, 2-biz, 3 - cars, 4 - inventory, 5-bank, 6 - depozit, 7 - family");
        return 1;
    }
    if(!( 1 <= params[0] <= 7)) {
        SendInfo(playerid, "Используйте: /editproperty [typeid] [никнейм]");
        SendInfo(playerid, "types: 1-house, 2-biz, 3 - cars, 4 - inventory, 5-bank, 6 - depozit, 7 - family");
        return 1;
    }
    if(!(3 <= strlen(params[1]) <= 24)) {
        SendInfo(playerid, "Используйте: /editproperty [typeid] [никнейм]");
        SendInfo(playerid, "types: 1-house, 2-biz, 3 - cars, 4 - inventory, 5-bank, 6 - depozit, 7 - family");
        return 1;
    }

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `accounts` WHERE `name` = '%e' LIMIT 1", params[1]);
    mysql_tquery(con_bd, STRING_GLOBAL, "EditPlayerProperty_GetAccount", "iis", playerid, params[0], params[1]);
    return 1;
}

forward EditPlayerProperty_GetAccount(playerid, property_type_id, nickname[]);
public EditPlayerProperty_GetAccount(playerid, property_type_id, nickname[])
{
    if(!cache_num_rows())
        return SendError(playerid, "Игрока с таким ником в базе данных не найдено.");

    cache_get_value_name_int(0, "id", p_temp[playerid][p_listitem_int]);

    if(GetPlayerUserID(p_temp[playerid][p_listitem_int]) != INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок в сети.");

    STRING_GLOBAL[0] = EOS;
    switch(property_type_id)
    {
        case 1: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT * FROM `house` WHERE `h_user_id` = %d LIMIT 30", p_temp[playerid][p_listitem_int]);
        case 2: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT * FROM `biz` WHERE `b_user_id` = %d LIMIT 30", p_temp[playerid][p_listitem_int]);
        case 3: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `v_model`, `v_mysql_id`, `v_twinturbo`, `v_premium`, `v_number` FROM `vehicle` WHERE `v_owner_id` = %d LIMIT 30", p_temp[playerid][p_listitem_int]);
        case 4: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT a.`inv_slots`, i.`mysql_id`, i.`item_id`, i.`amount`, i.`acc_wear`, i.`acc_mt1`, i.`acc_mt2` FROM `inventory` AS i LEFT JOIN `accounts` AS a ON a.`id` = i.`owner_id` WHERE i.`owner_id` = %d AND `owner_type` = 0 LIMIT %d", p_temp[playerid][p_listitem_int], MAX_PLAYER_EQUIPMENT);
        case 5: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `bank` FROM `accounts` WHERE `id` = %d LIMIT 30", p_temp[playerid][p_listitem_int]);
        case 6: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `bank_deposit` FROM `accounts` WHERE `id` = %d LIMIT 30", p_temp[playerid][p_listitem_int]);
        case 7: format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id`, `name` FROM `family` WHERE `owner_id` = %d LIMIT 30", p_temp[playerid][p_listitem_int]);
        default: return 1;
    }
    mysql_tquery(con_bd, STRING_GLOBAL, "EditProperty_GetInfo", "iis", playerid, property_type_id, nickname);
    return 1;
}
alias:editproperty("editprop", "epr");

forward EditProperty_GetInfo(playerid, property_type_id, nickname[]);
public EditProperty_GetInfo(playerid, property_type_id, nickname[])
{
    new rows, fmt_str[144];
    cache_get_row_count(rows);
    STRING_GLOBAL[0] = EOS;
    switch(property_type_id)
    {
        case 1:
        {
            if(!rows) return SendError(playerid, "У игрока нет домов.");
            new tmp_mysql_id, tmp_h_class;
            for(new idx; idx < rows; idx++)
            {
                p_temp[playerid][p_listitem][idx] = -1;
                cache_get_value_name_int(idx, "h_mysql_id", tmp_mysql_id);
                cache_get_value_name_int(idx, "h_squar", tmp_h_class);
                if(tmp_h_class < 1) tmp_h_class = 1;
                format(fmt_str, sizeof fmt_str, ""I"[%d]"W" Дом (ID: %d) [Класс: %s] \n", idx+1, tmp_mysql_id, house_class[tmp_h_class-1]);
                strcat(STRING_GLOBAL, fmt_str);
                p_temp[playerid][p_listitem][idx] = tmp_mysql_id;
            }
            f(fmt_str, ""I"Дома %s(%d)", nickname, rows);
            ShowPlayerDialog(playerid, D_EDITHOUSE_LIST, DIALOG_STYLE_LIST, fmt_str, STRING_GLOBAL, "Выбрать", "Отмена");
        }
        case 2:
        {
            if(!rows) return SendError(playerid, "У игрока нет бизнесов.");
            new tmp_mysql_id, bizz_name[24];
            for(new idx; idx < rows; idx++)
            {
                p_temp[playerid][p_listitem][idx] = -1;
                cache_get_value_name_int(idx, "b_mysql_id", tmp_mysql_id);
                cache_get_value_name(idx, "b_name", bizz_name,24);

                format(fmt_str, sizeof fmt_str, ""I"[%d]"W" Бизнес (ID: %d) [%s] \n", idx+1, tmp_mysql_id, bizz_name);
                strcat(STRING_GLOBAL, fmt_str);
                p_temp[playerid][p_listitem][idx] = tmp_mysql_id;
            }
            f(fmt_str, ""I"Бизнесы %s(%d)", nickname, rows);
            ShowPlayerDialog(playerid, D_EDITBIZZ_LIST, DIALOG_STYLE_LIST, fmt_str, STRING_GLOBAL, "Выбрать", "Отмена");
        }
        case 3:
        {
            if(!rows) return SendError(playerid, "У игрока нет транспортных средств.");

            new status_used[36],
                //veh_number[16] = "НЕТ НОМЕРОВ",
                modelid,
                twinturbo,
                premium;
            static const twinturbo_status[][] = {"", "[{ffff00}TT"W"]"};
            static const premium_status[][] = {"", "[{ffff00}PREMIUM"W"]"};
            for(new idx; idx < rows; idx++)
            {
                p_temp[playerid][p_listitem_cars][idx] = -1;
                cache_get_value_name_int(idx, "v_model", modelid);
                //cache_get_value_name(idx, "v_number", veh_number, 16);
                //if(strequals(veh_number, "NULL")) veh_number = "НЕТ НОМЕРОВ";
                cache_get_value_name_int(idx, "v_twinturbo", twinturbo);
                cache_get_value_name_int(idx, "v_premium", premium);
                cache_get_value_name_int(idx, "v_mysql_id", p_temp[playerid][p_listitem_cars][idx]);

                /*if(GetSlotVehicleMarket(p_temp[playerid][p_listitem_cars][idx]) != -1) format(status_used, sizeof status_used, ""A"[На авторынке]");*/
                format(fmt_str, sizeof fmt_str, ""I"[%d]"W" %s(ID: %d) %s %s  %s\n", idx+1, GetVehicleName(INVALID_VEHICLE_ID, modelid), modelid, twinturbo_status[twinturbo], premium_status[premium], /*veh_number,*/ status_used);
                strcat(STRING_GLOBAL, fmt_str);
            }
            p_temp[playerid][loadcar_max] = rows;
            f(fmt_str, ""I"Транспорт %s(%d)", nickname, rows);
            ShowPlayerDialog(playerid, D_EDITCARS_LIST, DIALOG_STYLE_LIST, fmt_str, STRING_GLOBAL, "Выбрать", "Отмена");
        }
        case 4:
        {
            if(!rows) return SendError(playerid, "У игрока нет предметов в инвентаре.");
            new itemID, itemAmount, Float:accWear, accMt1, accMt2;
            STRING_GLOBAL[0] = EOS;
            for(new i; i < rows; i++)
            {
                p_temp[playerid][p_listitem][i] = -1;
                if(i < rows)
                {
                    cache_get_value_name_int(i, "mysql_id", p_temp[playerid][p_listitem][i]);
                    cache_get_value_name_int(i, "item_id", itemID);

                    if(ItemsInfo[itemID][iType] == TYPE_ITEMS_INVENTORY)
                    {
                        cache_get_value_name_int(i, "amount", itemAmount);
                        f(STRING_GLOBAL, "%s"I"[%d]"W" %s\t%d ед.\n", STRING_GLOBAL, i+1, ItemsInfo[itemID][iName], itemAmount);
                    }
                    else if(ItemsInfo[itemID][iType] == TYPE_ITEMS_ACCESSORIES)
                    {
                        cache_get_value_name_float(i, "acc_wear", accWear);
                        cache_get_value_name_int(i, "acc_mt1", accMt1);
                        cache_get_value_name_int(i, "acc_mt2", accMt2);
                        f(STRING_GLOBAL, "%s"I"[%d]"W" %s\t[%.1f] (%s/%s)\n", STRING_GLOBAL, i+1, ItemsInfo[itemID][iName], accWear, AccessoriesColorInfo[accMt1][acName], AccessoriesColorInfo[accMt2][acName]);
                    }
                    else if(ItemsInfo[itemID][iType] == TYPE_ITEMS_SKINS)
                        f(STRING_GLOBAL, "%s"I"[%d]"W" %s\t \n", STRING_GLOBAL, i+1, ItemsInfo[itemID][iName]);
                }

            }
            new all_slots;
            cache_get_value_name_int(0, "inv_slots", all_slots);
            if(rows < all_slots)
            {
                p_temp[playerid][p_listitem][rows] = -1;
                f(STRING_GLOBAL, "%s"I"[%d]"W" Выдать предмет\t \n", STRING_GLOBAL, rows+1);
            }
            f(fmt_str, ""I"%s | Count: %d (Slots: %d | Free: %d)", nickname, rows, all_slots, all_slots-rows);
            ShowPlayerDialog(playerid, D_EDITINV_LIST, DIALOG_STYLE_TABLIST, fmt_str, STRING_GLOBAL, "Выбрать", "Отмена");
        }
        /*
        case 5:
        {
            if(!rows) return SendError(playerid, "У игрока нет скинов.");
            for(new i = MAX_PLAYER_SKINS-1; i != -1; i--) p_temp[playerid][p_listitem][i] = -1;
            new data[144];
            cache_get_value_name(0, "skins", data); // 0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0
            sscanf(data, "p<|>a<i>[10]", p_temp[playerid][p_listitem]);
            STRING_GLOBAL[0] = EOS;
            for(new i = 0; i < MAX_PLAYER_SKINS; i++)
            {
                if(p_temp[playerid][p_listitem][i] != 0)
                    f(STRING_GLOBAL, "%s"I"[%d]"W" Скин: %d\n", STRING_GLOBAL, i+1, p_temp[playerid][p_listitem][i]);
                else
                    f(STRING_GLOBAL, "%s"I"[%d]"W" Слот свободен (Выдать скин)\n", STRING_GLOBAL, i+1);
            }
            f(fmt_str, ""I"Скины %s(%d)", nickname, rows);
            ShowPlayerDialog(playerid, D_EDITSKINS_LIST, DIALOG_STYLE_LIST, fmt_str, STRING_GLOBAL, "Выбрать", "Отмена");
        }
        */
        case 5:
        {
            new bank_money;
            cache_get_value_int(0, "bank", bank_money);
            f(fmt_str, ""I"Банк: %d", nickname, bank_money);
            p_temp[playerid][p_listitem][40] = bank_money;
            ShowPlayerDialog(playerid, D_EDITBANK_MENU, DIALOG_STYLE_INPUT, fmt_str, ""W"Выдать или забрать(- перед числом):", "Выбрать", "Отмена");
        }
        case 6:
        {
            new bank_money;
            cache_get_value_int(0, "bank_deposit", bank_money);
            f(fmt_str, ""I"Банк депозит: %d", nickname, bank_money);
            p_temp[playerid][p_listitem][40] = bank_money;
            ShowPlayerDialog(playerid, D_EDITDEPOSIT_MENU, DIALOG_STYLE_INPUT, fmt_str, ""W"Выдать или забрать(- перед числом):", "Выбрать", "Отмена");
        }
        case 7:
        {
            if(!rows) return SendError(playerid, "Игрок не является владельцем.");
            new getname[64];
            cache_get_value_int(0, "id", p_temp[playerid][p_listitem][40]);
            cache_get_value_name(0, "name", getname);
            ShowPlayerDialog(playerid, D_EDITFAMILY, DIALOG_STYLE_LIST, getname, ""I"[1]"W" Сменить владельца\n"I"[2]"W" Забрать", "Выбрать", "Отмена");
        }
    }
    return 1;
}

editproperty_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
    {
        //family
        case D_EDITFAMILY:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: ShowPlayerDialog(playerid, D_EDITFAMILY_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Смена владельца", ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
                case 1:
                {
                    new idx;
                    for(new i = family_count-1; i != -1; i--)
                    {
                        if(p_temp[playerid][p_listitem][40] == FamilyData[i][fMysqlID])
                        {
                            idx = i;
                            break;
                        }
                    }

                    STRING_GLOBAL[0] = EOS;
                    mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `family` SET `owner_id` = 1 WHERE `id` = %d", p_temp[playerid][p_listitem][40]);
                    mysql_tquery(con_bd, STRING_GLOBAL);

                    FamilyData[idx][fOwnerID] = 1;

                    STRING_GLOBAL[0] = EOS;
                    mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `accounts` SET `family_rang` = '10', `family_id` = %d WHERE `id` = 1",
                    p_temp[playerid][p_listitem][40]);
                    mysql_tquery(con_bd, STRING_GLOBAL);
                }
            }
            return 1;
        }
        case D_EDITFAMILY_CHANGE_OWNER:
        {
            if(!response) return 1;
            if(strlen(inputtext) < 3 || strlen(inputtext) > 24)
                return ShowPlayerDialog(playerid, D_EDITFAMILY_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Смена владельца", ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
            STRING_GLOBAL[0] = EOS;
            format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `accounts` WHERE `name` = '%s' LIMIT 1", inputtext);
            new Cache:result = mysql_query(con_bd, STRING_GLOBAL);
            if(cache_num_rows() == 0)
            {
                SendError(playerid, "Игрока с таким ником в базе данных не найдено.");
                ShowPlayerDialog(playerid, D_EDITFAMILY_CHANGE_OWNER, DIALOG_STYLE_INPUT, "Смена владельца", ""W"Введите ник нового владельца", "Выбрать", "Отмена");
                cache_delete(result);
                return 1;
            }
            new player_mysql_id;
            cache_get_value_name_int(0, "id", player_mysql_id);
            cache_delete(result);

            new idx;
            for(new i = family_count-1; i != -1; i--)
            {
                if(p_temp[playerid][p_listitem][40] == FamilyData[i][fMysqlID])
                {
                    idx = i;
                    break;
                }
            }

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `family` SET `owner_id` = %d WHERE `id` = %d",
                player_mysql_id, FamilyData[idx][fMysqlID]);
            mysql_tquery(con_bd, STRING_GLOBAL);

            FamilyData[idx][fOwnerID] = player_mysql_id;

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `accounts` SET `family_rang` = '10', `family_id` = %d WHERE `id` = %d",
                FamilyData[idx][fMysqlID], player_mysql_id);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили владельца семьи.");
            return 1;
        }
        // bank deposit
        case D_EDITDEPOSIT_MENU:
        {
            if(!response) return 1;
            new bank_money;
            if(sscanf(inputtext, "i", bank_money))
                return ShowPlayerDialog(playerid, D_EDITBANK_MENU, DIALOG_STYLE_INPUT, ""I"Банк", ""W"Выдать или забрать(- перед числом):", "Выбрать", "Отмена");
            if(!(0 <= (p_temp[playerid][p_listitem][40]+bank_money) <= 100_000_000))
                return ShowPlayerDialog(playerid, D_EDITBANK_MENU, DIALOG_STYLE_INPUT, ""I"Банк", ""W"Выдать или забрать(- перед числом):", "Выбрать", "Отмена");
            p_temp[playerid][p_listitem][40] += bank_money;
            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `accounts` SET `bank_deposit` = %d WHERE `id` = %d",
                p_temp[playerid][p_listitem][40], p_temp[playerid][p_listitem_int]);
            mysql_tquery(con_bd, STRING_GLOBAL);
            SendAccess(playerid, "Новое значение банк депозит: %d$", p_temp[playerid][p_listitem][40]);
            return 1;
        }
        // bank
        case D_EDITBANK_MENU:
        {
            if(!response) return 1;
            new bank_money;
            if(sscanf(inputtext, "i", bank_money))
                return ShowPlayerDialog(playerid, D_EDITBANK_MENU, DIALOG_STYLE_INPUT, ""I"Банк", ""W"Выдать или забрать(- перед числом):", "Выбрать", "Отмена");
            if(!(0 <= (p_temp[playerid][p_listitem][40]+bank_money) <= 999_000_000))
                return ShowPlayerDialog(playerid, D_EDITBANK_MENU, DIALOG_STYLE_INPUT, ""I"Банк", ""W"Выдать или забрать(- перед числом):", "Выбрать", "Отмена");
            p_temp[playerid][p_listitem][40] += bank_money;
            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `accounts` SET `bank` = %d WHERE `id` = %d",
                p_temp[playerid][p_listitem][40], p_temp[playerid][p_listitem_int]);
            mysql_tquery(con_bd, STRING_GLOBAL);
            SendAccess(playerid, "Новое значение банк: %d$", p_temp[playerid][p_listitem][40]);
            return 1;
        }
        // inventory
        case D_EDITINV_LIST:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            if(p_temp[playerid][p_listitem][listitem] == -1)
                ShowDialogEditInventoryGive(playerid);
            else
            {
                SetPVarInt(playerid, #EPR_INV_MYSQL, p_temp[playerid][p_listitem][listitem]);
                STRING_GLOBAL[0] = EOS;
                format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `item_id`, `amount` FROM `inventory` WHERE `mysql_id` = %d LIMIT 1", p_temp[playerid][p_listitem][listitem]);
                mysql_tquery(con_bd, STRING_GLOBAL, "EditInventory_Menu", "i", playerid);
            }
            return 1;
        }
        case D_EDITINV_GIVE:
        {
            if(p_info[playerid][admin] < 7) return 1;
            if(!response)
                return 1;
            if(!strlen(inputtext))
                return ShowDialogEditInventoryGive(playerid);
            new extra[4];
            if(sscanf(inputtext, "p<,>iI(-1)I(-1)I(-1)", extra[0], extra[1], extra[2], extra[3]))
                return ShowDialogEditInventoryGive(playerid);

            if(!(1 <= extra[0] <= MAX_ITEMS-1))
                return ShowDialogEditInventoryGive(playerid);

            new ownerID = p_temp[playerid][p_listitem_int];
            if(ownerID <= 0) return 1;

            //SendDebug(playerid, "%d %d %d %d", extra[0], extra[1], extra[2], extra[3]);
            if(ItemsInfo[extra[0]][iType] == TYPE_ITEMS_INVENTORY)
            {
                if(!(1 <= extra[1] <= ItemsInfo[extra[0]][iMax]))
                {
                    SendError(playerid, "Выдать за раз можно не меньше 1 и не больше вмещаемой в один слот (%d)", ItemsInfo[extra[0]][iMax]);
                    return ShowDialogEditInventoryGive(playerid);
                    //give items
                }
                STRING_GLOBAL[0] = EOS;
                format(STRING_GLOBAL, sizeof(STRING_GLOBAL), " \
                    INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`) \
                    SELECT coalesce( MAX( if(slot_id = 0, (SELECT MIN(slot_id) + 1 FROM `inventory` as inv \
                    WHERE ( SELECT MIN(slot_id) FROM inventory AS i WHERE i.`slot_id` = (inv.`slot_id` + 1) AND i.`owner_id` = %d) IS NULL \
                    ORDER BY `inventory`.slot_id), 0)), 0) slot, %d AS owner_id, 0 AS owner_type, %d AS item_id, %d AS amount FROM `inventory` LIMIT 1;",
                    ownerID, ownerID, extra[0], extra[1]);

                SendAccess(playerid, "Вы выдали \"%s\" %d ед.", ItemsInfo[extra[0]][iName], extra[1]);

                printf("LOG_PLAYER: Admin: %s[%d](%s %s) выдал offline[%d] %s %d ед. | #EPR",
                    get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                    ownerID, ItemsInfo[extra[0]][iName], extra[1]);
            }
            else if(ItemsInfo[extra[0]][iType] == TYPE_ITEMS_ACCESSORIES)
            {
                if(!(0 <= extra[1] <= 100))
                {
                    SendError(playerid, "Процент износа должен быть от 0 до 100.");
                    return ShowDialogEditInventoryGive(playerid);
                }
                if(!(0 <= extra[2] <= sizeof(AccessoriesColorInfo)-1) || !(0 <= extra[3] <= sizeof(AccessoriesColorInfo)-1))
                {
                    SendError(playerid, "Цвет должен быть от 0 до %d.", sizeof(AccessoriesColorInfo)-1);
                    return ShowDialogEditInventoryGive(playerid);
                }
                //give accessories
                STRING_GLOBAL[0] = EOS;
                format(STRING_GLOBAL, sizeof(STRING_GLOBAL), " \
                    INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`, `acc_wear`, `acc_mt1`, `acc_mt2`) \
                    SELECT coalesce( MAX( if(slot_id = 0, (SELECT MIN(slot_id) + 1 FROM `inventory` as inv \
                    WHERE ( SELECT MIN(slot_id) FROM inventory AS i WHERE i.`slot_id` = (inv.`slot_id` + 1) AND i.`owner_id` = %d) IS NULL \
                    ORDER BY `inventory`.slot_id), 0)), 0) slot, %d AS owner_id, 0 AS owner_type, %d AS item_id, 1 AS amount, \
                    %f AS acc_wear, %d AS acc_mt1, %d AS acc_mt2 FROM `inventory` LIMIT 1;",
                    ownerID, ownerID, extra[0], float(extra[1]), extra[2], extra[3]);

                SendAccess(playerid, "Вы выдали \"%s\" [%.1f] (%s/%s).", ItemsInfo[extra[0]][iName], float(extra[1]), AccessoriesColorInfo[extra[2]][acName], AccessoriesColorInfo[extra[3]][acName]);

                printf("LOG_PLAYER: Admin: %s[%d](%s %s) выдал offline[%d] %s (%d.0 %s/%s). | #EPR",
                    get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                    ownerID, ItemsInfo[extra[0]][iName], extra[1], AccessoriesColorInfo[extra[2]][acName], AccessoriesColorInfo[extra[3]][acName]);
            }
            else if(ItemsInfo[extra[0]][iType] == TYPE_ITEMS_SKINS)
            {
                //give skin
                STRING_GLOBAL[0] = EOS;
                format(STRING_GLOBAL, sizeof(STRING_GLOBAL), " \
                    INSERT INTO `inventory` (`slot_id`, `owner_id`, `owner_type`, `item_id`, `amount`) \
                    SELECT coalesce( MAX( if(slot_id = 0, (SELECT MIN(slot_id) + 1 FROM `inventory` as inv \
                    WHERE ( SELECT MIN(slot_id) FROM inventory AS i WHERE i.`slot_id` = (inv.`slot_id` + 1) AND i.`owner_id` = %d) IS NULL \
                    ORDER BY `inventory`.slot_id), 0)), 0) slot, %d AS owner_id, 0 AS owner_type, %d AS item_id, 1 AS amount FROM `inventory` LIMIT 1;",
                    ownerID, ownerID, extra[0]);

                SendAccess(playerid, "Вы выдали \"%s\".", ItemsInfo[extra[0]][iName]);

                printf("LOG_PLAYER: Admin: %s[%d](%s %s) выдал offline[%d] %s | #EPR",
                    get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                    ownerID, ItemsInfo[extra[0]][iName]);
            }
            mysql_tquery(con_bd, STRING_GLOBAL);
            return 1;
        }
        case D_EDITITEM_MENU:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemAmount = GetPVarInt(playerid, #EPR_INV_AMOUNT),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!listitem || !response)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_AMOUNT);
                DeletePVar(playerid, #EPR_INV_MYSQL);
            }
            if(!response || p_info[playerid][admin] < 7) return 1;
            STRING_GLOBAL[0] = EOS;
            switch(listitem)
            {
                case 0:
                {
                    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `inventory` WHERE mysql_id = %d", itemMySQL);
                    mysql_tquery(con_bd, STRING_GLOBAL);

                    SendAccess(playerid, "Вы удалили \"%s\" %d ед.", ItemsInfo[itemID][iName], itemAmount);

                    printf("LOG_PLAYER: Admin: %s[%d](%s %s) удалил offline[%d] %s %d ед. | #EPR",
                        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                        p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], itemAmount);

                    p_temp[playerid][p_listitem_int] = -1;
                }
                case 1:
                {
                    f(STRING_GLOBAL, ""W"Введите сколько добавить:\n\nДоступно места в слоте: "I"%d ед.", ItemsInfo[itemID][iMax]-itemAmount);
                    return ShowPlayerDialog(playerid, D_EDITITEM_ADD, DIALOG_STYLE_INPUT, ""I"Редактирование предмета", STRING_GLOBAL, "Ввести", "Отмена");
                }
                case 2:
                {
                    f(STRING_GLOBAL, ""W"Введите новое значение:\n\nМаксимально вмещается в слоте: "I"%d ед.", ItemsInfo[itemID][iMax]);
                    ShowPlayerDialog(playerid, D_EDITITEM_NEW_VALUE, DIALOG_STYLE_INPUT, ""I"Редактирование предмета", STRING_GLOBAL, "Ввести", "Отмена");
                }
            }
            return 1;
        }
        case D_EDITITEM_NEW_VALUE:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemAmount = GetPVarInt(playerid, #EPR_INV_AMOUNT),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_AMOUNT);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                return 1;
            }
            new value = strval(inputtext);
            STRING_GLOBAL[0] = EOS;
            if(!strlen(inputtext) || !(1 <= value <= ItemsInfo[itemID][iMax]))
            {
                f(STRING_GLOBAL, ""W"Введите новое значение:\n\nМаксимально вмещается в слоте: "I"%d ед.", ItemsInfo[itemID][iMax]);
                return ShowPlayerDialog(playerid, D_EDITITEM_NEW_VALUE, DIALOG_STYLE_INPUT, ""I"Редактирование предмета", STRING_GLOBAL, "Ввести", "Отмена");
            }
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `amount` = %d WHERE `mysql_id` = %d", value, itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы установили \"%s\" значение %d ед. вместо %d ед.", ItemsInfo[itemID][iName], value, itemAmount);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_AMOUNT);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) установил offline[%d] %s %d ед. вместо %d ед. | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], value, itemAmount);
            return 1;
        }
        case D_EDITITEM_ADD:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemAmount = GetPVarInt(playerid, #EPR_INV_AMOUNT),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7 || ItemsInfo[itemID][iMax]-itemAmount < 1)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_AMOUNT);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                if(response && ItemsInfo[itemID][iMax]-itemAmount < 1) SendError(playerid, "В слоте нет места.");
                return 1;
            }
            new value = strval(inputtext);
            if(!strlen(inputtext) || !(1 <= value <= ItemsInfo[itemID][iMax]-itemAmount))
            {
                STRING_GLOBAL[0] = EOS;
                f(STRING_GLOBAL, ""W"Введите сколько добавить:\n\nДоступно места в слоте: "I"%d ед.", ItemsInfo[itemID][iMax]-itemAmount);
                return ShowPlayerDialog(playerid, D_EDITITEM_ADD, DIALOG_STYLE_INPUT, ""I"Редактирование предмета", STRING_GLOBAL, "Ввести", "Отмена");
            }
            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `amount` = `amount` + %d WHERE `mysql_id` = %d", value, itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы выдали \"%s\" %d ед. | Новое значение слота: %d ед.", ItemsInfo[itemID][iName], value, itemAmount+value);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_AMOUNT);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) выдал offline[%d] %s %d ед. новое значение %d ед. | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], value, itemAmount+value);
            return 1;
        }
        case D_EDITACC_MENU:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);


            if(!listitem || !response)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_AMOUNT);
                DeletePVar(playerid, #EPR_INV_MYSQL);
            }
            if(!response || p_info[playerid][admin] < 7) return 1;
            STRING_GLOBAL[0] = EOS;
            switch(listitem)
            {
                case 0:
                {
                    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `inventory` WHERE mysql_id = %d", itemMySQL);
                    mysql_tquery(con_bd, STRING_GLOBAL);

                    SendAccess(playerid, "Вы удалили \"%s\".", ItemsInfo[itemID][iName]);

                    printf("LOG_PLAYER: Admin: %s[%d](%s %s) удалил offline[%d] %s | #EPR",
                        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                        p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName]);

                    p_temp[playerid][p_listitem_int] = -1;
                }
                case 1: ShowPlayerDialog(playerid, D_EDITACC_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", ""W"Введите новое значение:", "Ввести", "Отмена");
                case 2: ShowPlayerDialog(playerid, D_EDITACC_WEAR, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", ""W"Введите новое значение:\n\nОт 0 до 100.", "Ввести", "Отмена");
                case 3,4:
                {
                    new color_str[256];
                    for(new i; i < sizeof(AccessoriesColorInfo); i++)
                    format(color_str, sizeof(color_str), "%s %d - {%06x}%s"W"\n", color_str, i, i == 0 ? 0xFFFFFF : AccessoriesColorInfo[i][acColorRBG] & 0xFFFFFF, AccessoriesColorInfo[i][acName]);

                    f(STRING_GLOBAL, ""W"Выберите цвет:\n%s\n\n"W"Введите новое значение:", color_str);
                    if(listitem == 3) ShowPlayerDialog(playerid, D_EDITACC_MT1, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", STRING_GLOBAL, "Ввести", "Отмена");
                    else ShowPlayerDialog(playerid, D_EDITACC_MT2, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", STRING_GLOBAL, "Ввести", "Отмена");
                }
            }
            return 1;
        }
        case D_EDITACC_MODELID:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                return 1;
            }

            new value = strval(inputtext);
            if(!strlen(inputtext) || !(1 <= value <= MAX_ITEMS-1))
                return ShowPlayerDialog(playerid, D_EDITACC_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", ""W"Введите новое значение:", "Ввести", "Отмена");
            if(ItemsInfo[value][iType] != TYPE_ITEMS_ACCESSORIES)
            {
                SendError(playerid, "Введенный ID не соответствует акссесуару.");
                return ShowPlayerDialog(playerid, D_EDITACC_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", ""W"Введите новое значение:", "Ввести", "Отмена");
            }

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `item_id` = %d WHERE `mysql_id` = %d", value, itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили \"%s\" состояние на \"%s\"", ItemsInfo[itemID][iName], ItemsInfo[value][iName]);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) сменил offline[%d] с %s на %s | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], ItemsInfo[value][iName]);
            return 1;
        }
        case D_EDITACC_WEAR:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                return 1;
            }

            new value = strval(inputtext);
            if(!strlen(inputtext) || !(0 <= value <= 100))
                return ShowPlayerDialog(playerid, D_EDITACC_WEAR, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", ""W"Введите новое значение:\n\nОт 0 до 100.", "Ввести", "Отмена");

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `acc_wear` = %f WHERE `mysql_id` = %d", float(value), itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили для \"%s\" состояние на %d", ItemsInfo[itemID][iName], value);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) сменил состояние offline[%d] на %d.0 | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], value);
            return 1;
        }
        case D_EDITACC_MT1:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                return 1;
            }

            new value = strval(inputtext);
            if(!strlen(inputtext) || !(0 <= value <= sizeof(AccessoriesColorInfo)-1))
            {
                new color_str[256];
                for(new i; i < sizeof(AccessoriesColorInfo); i++)
                format(color_str, sizeof(color_str), "%s %d - {%06x}%s"W"\n", color_str, i, i == 0 ? 0xFFFFFF : AccessoriesColorInfo[i][acColorRBG] & 0xFFFFFF, AccessoriesColorInfo[i][acName]);

                f(STRING_GLOBAL, "Выберите цвет:\n%s\n\n"W"Введите новое значение:", color_str);
                return ShowPlayerDialog(playerid, D_EDITACC_MT1, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", STRING_GLOBAL, "Ввести", "Отмена");
            }
            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `acc_mt1` = %d WHERE `mysql_id` = %d", value, itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили для \"%s\" цвет #1 на %s", ItemsInfo[itemID][iName], AccessoriesColorInfo[value][acName]);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) сменил цвет #1 offline[%d] на %s | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], AccessoriesColorInfo[value][acName]);
            return 1;
        }
        case D_EDITACC_MT2:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                return 1;
            }

            new value = strval(inputtext);
            if(!strlen(inputtext) || !(0 <= value <= sizeof(AccessoriesColorInfo)-1))
            {
                new color_str[256];
                for(new i; i < sizeof(AccessoriesColorInfo); i++)
                format(color_str, sizeof(color_str), "%s %d - {%06x}%s"W"\n", color_str, i, i == 0 ? 0xFFFFFF : AccessoriesColorInfo[i][acColorRBG] & 0xFFFFFF, AccessoriesColorInfo[i][acName]);

                f(STRING_GLOBAL, "Выберите цвет:\n%s\n\n"W"Введите новое значение:", color_str);
                return ShowPlayerDialog(playerid, D_EDITACC_MT2, DIALOG_STYLE_INPUT, ""I"Редактирование акссесуара", STRING_GLOBAL, "Ввести", "Отмена");
            }
            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `acc_mt2` = %d WHERE `mysql_id` = %d", value, itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили для \"%s\" цвет #2 на %s", ItemsInfo[itemID][iName], AccessoriesColorInfo[value][acName]);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) сменил цвет #2 offline[%d] на %s | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], AccessoriesColorInfo[value][acName]);
            return 1;
        }
        case D_EDITSKIN_MENU:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!listitem || !response)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_AMOUNT);
                DeletePVar(playerid, #EPR_INV_MYSQL);
            }
            if(!response || p_info[playerid][admin] < 7) return 1;
            STRING_GLOBAL[0] = EOS;
            switch(listitem)
            {
                case 0:
                {
                    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `inventory` WHERE mysql_id = %d", itemMySQL);
                    mysql_tquery(con_bd, STRING_GLOBAL);

                    SendAccess(playerid, "Вы удалили \"%s\".", ItemsInfo[itemID][iName]);

                    printf("LOG_PLAYER: Admin: %s[%d](%s %s) удалил offline[%d] %s | #EPR",
                        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                        p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName]);

                    p_temp[playerid][p_listitem_int] = -1;
                }
                case 1: ShowPlayerDialog(playerid, D_EDITSKIN_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование скина", ""W"Введите новое значение:", "Ввести", "Отмена");
            }
            return 1;
        }
        case D_EDITSKIN_MODELID:
        {
            new itemID = GetPVarInt(playerid, #EPR_INV_ITEMID),
                itemMySQL = GetPVarInt(playerid, #EPR_INV_MYSQL);

            if(!response || p_info[playerid][admin] < 7)
            {
                DeletePVar(playerid, #EPR_INV_ITEMID);
                DeletePVar(playerid, #EPR_INV_MYSQL);
                return 1;
            }

            new value = strval(inputtext);
            if(!strlen(inputtext) || !(1 <= value <= MAX_ITEMS-1))
                return ShowPlayerDialog(playerid, D_EDITSKIN_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование скина", ""W"Введите новое значение:", "Ввести", "Отмена");
            if(ItemsInfo[value][iType] != TYPE_ITEMS_SKINS)
            {
                SendError(playerid, "Введенный ID не соответствует скину.");
                return ShowPlayerDialog(playerid, D_EDITACC_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование скина", ""W"Введите новое значение:", "Ввести", "Отмена");
            }

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `inventory` SET `item_id` = %d WHERE `mysql_id` = %d", value, itemMySQL);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили \"%s\" состояние на \"%s\"", ItemsInfo[itemID][iName], ItemsInfo[value][iName]);

            DeletePVar(playerid, #EPR_INV_ITEMID);
            DeletePVar(playerid, #EPR_INV_MYSQL);

            printf("LOG_PLAYER: Admin: %s[%d](%s %s) сменил offline[%d] с %s на %s | #EPR",
                get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
                p_temp[playerid][p_listitem_int], ItemsInfo[itemID][iName], ItemsInfo[value][iName]);
            return 1;
        }
        /*
        // skins
        case D_EDITSKINS_MENU:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            new idx = p_temp[playerid][p_listitem][40];
            switch(listitem)
            {
                case 0:
                {
                    p_temp[playerid][p_listitem][idx] = 0;
                    EditSkins_Save(playerid);
                    SendAccess(playerid, "Вы упешно забрали скин.");
                }
                case 1: return ShowPlayerDialog(playerid, D_EDITSKINS_CHANGE_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование скина",
                    ""W"Введите ид скина:", "Выбрать", "Отмена");
            }
            return 1;
        }
        case D_EDITSKINS_CHANGE_MODELID:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            new give_skin_id;
            if(sscanf(inputtext, "i", give_skin_id))
                return ShowPlayerDialog(playerid, D_EDITSKINS_GIVE, DIALOG_STYLE_INPUT, ""I"Редактирование скина",
                    ""W"Введите новый ид скина:", "Выбрать", "Отмена");
            if(give_skin_id < 1 || give_skin_id > 310)
            {
                SendError(playerid, "ID скина должен быть не менее 1 и не более 310.");
                return ShowPlayerDialog(playerid, D_EDITSKINS_GIVE, DIALOG_STYLE_INPUT, ""I"Редактирование скина",
                    ""W"Введите новый ид скина:", "Выбрать", "Отмена");
            }
            p_temp[playerid][p_listitem][p_temp[playerid][p_listitem][40]] = give_skin_id;
            EditSkins_Save(playerid);
            SendAccess(playerid, "Вы упешно заменили скин.");
            return 1;
        }
        case D_EDITSKINS_GIVE:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            new give_skin_id;
            if(sscanf(inputtext, "i", give_skin_id))
                return ShowPlayerDialog(playerid, D_EDITSKINS_GIVE, DIALOG_STYLE_INPUT, ""I"Выдача скина",
                    ""W"Введите ид скина:", "Выбрать", "Отмена");
            if(give_skin_id < 1 || give_skin_id > 310)
            {
                SendError(playerid, "ID скина должен быть не менее 1 и не более 310.");
                return ShowPlayerDialog(playerid, D_EDITSKINS_GIVE, DIALOG_STYLE_INPUT, ""I"Выдача скина",
                    ""W"Введите ид скина:", "Выбрать", "Отмена");
            }
            p_temp[playerid][p_listitem][p_temp[playerid][p_listitem][40]] = give_skin_id;
            EditSkins_Save(playerid);
            SendAccess(playerid, "Вы упешно выдали скин.");
            return 1;
        }
        */
        // bizz
        case D_EDITBIZZ_LIST:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            p_temp[playerid][p_listitem_int] = listitem;
            ShowPlayerDialog(playerid, D_EDITBIZZ_MENU, DIALOG_STYLE_LIST, ""I"Редактирование бизнеса",
                ""I"[1]"W" Телепортироваться к бизнесу\n"I"[2]"W" Забрать бизнес(Слить в гос)\n"I"[3]"W" Сменить владельца", "Выбрать", "Отмена");
            return 1;
        }
        case D_EDITBIZZ_MENU:
        {
            if(p_info[playerid][admin] < 7) return 1;
            new idx = p_temp[playerid][p_listitem][p_temp[playerid][p_listitem_int]];
            switch(listitem)
            {
                case 0:
                {
                    SetPlayerVirtualWorld(playerid, 0);
                    SetPlayerInterior(playerid, 0);
                    SetPlayerPos(playerid,b_info[idx][b_enter][0], b_info[idx][b_enter][1], b_info[idx][b_enter][2]);
                }
                case 1:
                {
                    b_info[idx][b_user_id] = 1;
                    strmid(b_info[idx][_owner], "Vadim_Stasenko", 0, strlen("Vadim_Stasenko"), MAX_PLAYER_NAME);
                    update_bizz(idx);
                    save_bizz(idx);
                    SendAccess(playerid, "Вы забрали бизнес.");
                }
                case 2: ShowPlayerDialog(playerid, D_EDITBIZZ_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование бизнеса",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
            }
        }
        case D_EDITBIZZ_CHANGE_OWNER:
        {
            if(!response) return 1;
            if(strlen(inputtext) < 3 || strlen(inputtext) > 24)
                return ShowPlayerDialog(playerid, D_EDITBIZZ_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование бизнеса",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
            STRING_GLOBAL[0] = EOS;
            format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `accounts` WHERE `name` = '%s' LIMIT 1",
            inputtext);
            new Cache:result = mysql_query(con_bd, STRING_GLOBAL);
            if(cache_num_rows() == 0)
            {
                SendError(playerid, "Игрока с таким ником в базе данных не найдено.");
                ShowPlayerDialog(playerid, D_EDITBIZZ_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование бизнеса",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
                cache_delete(result);
                return 1;
            }
            new player_mysql_id;
            cache_get_value_name_int(0, "id", player_mysql_id);

            new idx = p_temp[playerid][p_listitem][p_temp[playerid][p_listitem_int]];

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `biz` SET `b_user_id` = %d WHERE `b_mysql_id` = %d",
            player_mysql_id, b_info[idx][b_mysql_id]);
            mysql_tquery(con_bd, STRING_GLOBAL);

            b_info[idx][b_user_id] = player_mysql_id;
            strmid(b_info[idx][_owner], inputtext, 0, strlen(inputtext), MAX_PLAYER_NAME);
            update_bizz(idx);
            save_bizz(idx);

            SendAccess(playerid, "Вы сменили владельца бизнеса.");
            return 1;
        }
        // house
        case D_EDITHOUSE_LIST:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            p_temp[playerid][p_listitem_int] = listitem;
            ShowPlayerDialog(playerid, D_EDITHOUSE_MENU, DIALOG_STYLE_LIST, ""I"Редактирование Т/С",
                ""I"[1]"W" Телепортироваться к дому\n"I"[2]"W" Забрать дом(Слить в гос)\n"I"[3]"W" Сменить владельца", "Выбрать", "Отмена");
            return 1;
        }
        case D_EDITHOUSE_MENU:
        {
            if(p_info[playerid][admin] < 7) return 1;
            new idx = p_temp[playerid][p_listitem][p_temp[playerid][p_listitem_int]];
            switch(listitem)
            {
                case 0:
                {
                    SetPlayerVirtualWorld(playerid, 0);
                    SetPlayerInterior(playerid, 0);
                    SetPlayerPos(playerid,h_info[idx][h_enter][0], h_info[idx][h_enter][1], h_info[idx][h_enter][2]);
                }
                case 1:
                {
                    h_info[idx][h_user_id] = 1;
                    strmid(h_info[idx][h_owner], "Vadim_Stasenko", 0, strlen("Vadim_Stasenko"), MAX_PLAYER_NAME);
                    update_house(idx);
                    save_house(idx);
                    SendAccess(playerid, "Вы забрали дом.");
                }
                case 2: ShowPlayerDialog(playerid, D_EDITHOUSE_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование дома",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
            }
        }
        case D_EDITHOUSE_CHANGE_OWNER:
        {
            if(!response) return 1;
            if(strlen(inputtext) < 3 || strlen(inputtext) > 24)
                return ShowPlayerDialog(playerid, D_EDITHOUSE_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование дома",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
            STRING_GLOBAL[0] = EOS;
            format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `accounts` WHERE `name` = '%s' LIMIT 1",
            inputtext);
            new Cache:result = mysql_query(con_bd, STRING_GLOBAL);
            if(cache_num_rows() == 0)
            {
                SendError(playerid, "Игрока с таким ником в базе данных не найдено.");
                ShowPlayerDialog(playerid, D_EDITHOUSE_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование дома",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
                cache_delete(result);
                return 1;
            }
            new player_mysql_id;
            cache_get_value_name_int(0, "id", player_mysql_id);

            new idx = p_temp[playerid][p_listitem][p_temp[playerid][p_listitem_int]];

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `house` SET `h_user_id` = %d WHERE `h_mysql_id` = %d",
            player_mysql_id, h_info[idx][h_mysql_id]);
            mysql_tquery(con_bd, STRING_GLOBAL);

            h_info[idx][h_user_id] = player_mysql_id;
            strmid(h_info[idx][h_owner], inputtext, 0, strlen(inputtext), MAX_PLAYER_NAME);
            update_house(idx);
            save_house(idx);

            SendAccess(playerid, "Вы сменили владельца дома.");
            return 1;
        }
        /// cars
        case D_EDITCARS_MENU:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            switch(listitem)
            {
                case 0:
                {
                    new vehicle_mysql_id = p_temp[playerid][p_listitem_cars][p_temp[playerid][p_listitem_int]];
                    EditCars_DestroyVehicle(vehicle_mysql_id);

                    STRING_GLOBAL[0] = EOS;
                    mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `vehicle` SET `v_owner_id` = 1 WHERE `v_mysql_id` = %d",
                    vehicle_mysql_id);
                    mysql_tquery(con_bd, STRING_GLOBAL);

                    SendAccess(playerid, "Вы удалили транспортное средство.");
                }
                case 1: ShowPlayerDialog(playerid, D_EDITCARS_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование Т/С",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
                case 2: ShowPlayerDialog(playerid, D_EDITCARS_CHANGE_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование Т/С",
                            ""W"Введите новый ид модели:", "Выбрать", "Отмена");
            }
            return 1;
        }
        case D_EDITCARS_CHANGE_OWNER:
        {
            if(!response) return 1;
            if(strlen(inputtext) < 3 || strlen(inputtext) > 24)
                return ShowPlayerDialog(playerid, D_EDITCARS_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование Т/С",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
            STRING_GLOBAL[0] = EOS;
            format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `accounts` WHERE `name` = '%s' LIMIT 1",
            inputtext);
            new Cache:result = mysql_query(con_bd, STRING_GLOBAL);
            if(cache_num_rows() == 0)
            {
                SendError(playerid, "Игрока с таким ником в базе данных не найдено.");
                ShowPlayerDialog(playerid, D_EDITCARS_CHANGE_OWNER, DIALOG_STYLE_INPUT, ""I"Редактирование Т/С",
                            ""W"Введите ник нового владельца:", "Выбрать", "Отмена");
                cache_delete(result);
                return 1;
            }
            new player_mysql_id;
            cache_get_value_name_int(0, "id", player_mysql_id);

            new vehicle_mysql_id = p_temp[playerid][p_listitem_cars][p_temp[playerid][p_listitem_int]];
            EditCars_DestroyVehicle(vehicle_mysql_id);

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `vehicle` SET `v_owner_id` = %d WHERE `v_mysql_id` = %d",
            player_mysql_id, vehicle_mysql_id);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили владельца транспортного средства.");
            return 1;
        }
        case D_EDITCARS_CHANGE_MODELID:
        {
            if(!response) return 1;
            new vehicle_model_id;
            if(sscanf(inputtext, "i", vehicle_model_id))
                return ShowPlayerDialog(playerid, D_EDITCARS_CHANGE_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование Т/С", ""W"Введите новый ид модели:", "Выбрать", "Отмена");
            if(!(400 <= vehicle_model_id <= 611))
            {
                SendError(playerid, "Не верный ИД модели.");
                return ShowPlayerDialog(playerid, D_EDITCARS_CHANGE_MODELID, DIALOG_STYLE_INPUT, ""I"Редактирование Т/С",
                            ""W"Введите новый ид модели:", "Выбрать", "Отмена");
            }
            new vehicle_mysql_id = p_temp[playerid][p_listitem_cars][p_temp[playerid][p_listitem_int]];
            EditCars_DestroyVehicle(vehicle_mysql_id);

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE `vehicle` SET `v_model` = %d WHERE `v_mysql_id` = %d",
            vehicle_model_id, vehicle_mysql_id);
            mysql_tquery(con_bd, STRING_GLOBAL);

            SendAccess(playerid, "Вы сменили модель транспортного средства.");
            return 1;
        }
        case D_EDITCARS_LIST:
        {
            if(!response) return 1;
            if(p_info[playerid][admin] < 7) return 1;
            p_temp[playerid][p_listitem_int] = listitem;
            ShowPlayerDialog(playerid, D_EDITCARS_MENU, DIALOG_STYLE_LIST, ""I"Редактирование Т/С",
                ""I"[1]"W" Забрать Т/С(Удалить)\n"I"[2]"W" Сменить владельца\n"I"[3]"W" Сменить модель", "Выбрать", "Отмена");
            return 1;
        }
    }
    return 1;
}

ShowDialogEditInventoryGive(playerid)
{
    STRING_GLOBAL[0] = EOS;
    new color_str[256];
    for(new i; i < sizeof(AccessoriesColorInfo); i++)
        format(color_str, sizeof(color_str), "%s %d - {%06x}%s"W"\n", color_str, i, i == 0 ? 0xFFFFFF : AccessoriesColorInfo[i][acColorRBG] & 0xFFFFFF, AccessoriesColorInfo[i][acName]);

    f(STRING_GLOBAL, ""W"Пример предмет:\n\
        "I"- ID, количество\n\
        \n\
        "W"Пример акссесуары:\n\
        "I"- ID, состояние, цвет #1, цвет #2\n\
        \n\
        "W"Цвета:\n%s\n\
        "W"Пример скины:\n\
        "I"- ID", color_str);
    return ShowPlayerDialog(playerid, D_EDITINV_GIVE, DIALOG_STYLE_INPUT, ""I"Выдача предмета", STRING_GLOBAL, "Выбрать", "Отмена");
}

EditCars_DestroyVehicle(vehicle_mysql_id)
{
    foreach(new v: Vehicle)
    {
        if(veh_info[v][v_mysql_id] == vehicle_mysql_id)
        {
            SaveVehicle(v);
            SaveVehicleDetails(v);

            DestroyVehicleVEx(v);
            break;
        }
    }
}

forward EditInventory_Menu(playerid);
public EditInventory_Menu(playerid)
{
    if(!cache_num_rows())
        return SendError(playerid, "Предмет не найден.");
    new itemID;
    cache_get_value_name_int(0, "item_id", itemID);
    SetPVarInt(playerid, #EPR_INV_ITEMID, itemID);
    if(ItemsInfo[itemID][iType] == TYPE_ITEMS_INVENTORY)
    {
        new itemAmount;
        cache_get_value_name_int(0, "amount", itemAmount);
        SetPVarInt(playerid, #EPR_INV_AMOUNT, itemAmount);
        ShowPlayerDialog(playerid, D_EDITITEM_MENU, DIALOG_STYLE_LIST, ""I"Редактирование предмета",
            ""I"[1]"W" Удалить\n\
            "I"[2]"W" Добавить\n\
            "I"[3]"W" Установить новое значение", "Выбрать", "Отмена");
    }
    else if(ItemsInfo[itemID][iType] == TYPE_ITEMS_ACCESSORIES)
    {
        ShowPlayerDialog(playerid, D_EDITACC_MENU, DIALOG_STYLE_LIST, ""I"Редактирование акссесуара",
            ""I"[1]"W" Удалить\n\
            "I"[2]"W" Сменить модель\n\
            "I"[3]"W" Сменить состояние\n\
            "I"[4]"W" Сменить цвет #1\n\
            "I"[5]"W" Сменить цвет #2", "Выбрать", "Отмена");
    }
    else if(ItemsInfo[itemID][iType] == TYPE_ITEMS_SKINS)
    {
        ShowPlayerDialog(playerid, D_EDITSKIN_MENU, DIALOG_STYLE_LIST, ""I"Редактирование скина",
             ""I"[1]"W" Удалить\n"I"[2]"W" Сменить модель", "Выбрать", "Отмена");
    }
    else SendError(playerid, "Ид предмета не определено.");
    return 1;
}

/////////////////////////////////////////////////////////////////////////////////
/*CMD:vmute(playerid, params[])
{
    if(p_info[playerid][admin] < 2) return 1;
    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /vmute [id]");
    if(params[0] == INVALID_PLAYER_ID) return SendError(playerid, "Игрок не в сети.");
    VoiceChat_MutePlayer(params[0]);
    SendAccess(playerid, "Вы замутили войс чат игроку %s", get_name(params[0]));
    SendInfo(params[0], "%s замутил Вам войс чат", get_name(playerid));
    return 1;
}

CMD:vunmute(playerid, params[])
{
    if(p_info[playerid][admin] < 2) return 1;
    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /vunmute [id]");
    if(params[0] == INVALID_PLAYER_ID) return SendError(playerid, "Игрок не в сети.");
    VoiceChat_UnMutePlayer(params[0]);
    SendAccess(playerid, "Вы размутили войс чат игроку %s", get_name(params[0]));
    SendInfo(params[0], "%s размутил Вам войс чат", get_name(playerid));
    return 1;
}*/

CMD:sethousetofamily(playerid, params[])
{
    if(p_info[playerid][admin] < 7) return 1;
    new house_id, family_idx;
    if(sscanf(params, "ii", house_id, family_idx)) return SendInfo(playerid, "Используйте: /sethousetofamily [houseID] [familyID]");
    if(!( 0 <= house_id < totalhouses)) return SendInfo(playerid, "Используйте: /sethousetofamily [houseID] [familyID]");
    if(!( 0 <= family_idx < family_count)) return SendInfo(playerid, "Используйте: /sethousetofamily [houseID] [familyID]");
    if(h_info[house_id][h_mysql_id] == INVALID_MYSQL_ID) return SendError(playerid, "Дом не задействован.");
    h_info[house_id][h_family_id] = FamilyData[family_idx][fMysqlID]; //Привязываем к дому << >> ИД БД семьи
    FamilyData[family_idx][fHouseID] = house_id; // Привязываем к семьи << >> ИД игры ДОМА

    SendAccess(playerid, "Вы сделали дом семейным.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s[%d] привязал к семье дом: №%d.", get_name(playerid), playerid, h_info[house_id][h_mysql_id]);
    SendFamilyMessage(family_idx, STRING_GLOBAL);

    update_house(house_id);
    save_house(house_id);

    new targetid;
    for(new i; i <= h_info[house_id][h_squar]; i++)
    {
        if(h_info[house_id][h_r_user_id][i] != INVALID_MYSQL_ID)
        {
            targetid = GetPlayerUserID(h_info[house_id][h_r_user_id][i]);
            house_rent_leave(house_id, i);
            if(targetid != INVALID_PLAYER_ID) SendInfo(targetid, "Владелец дома сделал его семейным, Вы выселены.");
        }
    }

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `accounts` SET `spawn` = 0 WHERE `spawn` = '3' AND `family_id` = %d",
        FamilyData[family_idx][fMysqlID]);
    mysql_tquery (con_bd, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `family` SET `house_id` = %d WHERE `id` = %d",
        h_info[house_id][h_mysql_id], FamilyData[family_idx][fMysqlID]);
    mysql_tquery (con_bd, STRING_GLOBAL);

    UpdateFamilyType(family_idx);
    return 1;
}

CMD:wipebiz(playerid, params[])
{
    if(p_info[playerid][admin] < 5) return 1;
    mafia_count[0] =
    mafia_count[1] =
    mafia_count[2] =
    mafia_count[3] = 0;
    new idx, mafia_ids[] = {MAFIA_RM, MAFIA_LCN, MAFIA_YAKUDZA, BIKER};
    for(new i = totalbizz-1; i != -1; i--)
    {
        if(b_info[i][b_mysql_id] == INVALID_MYSQL_ID) continue;
        if(idx >= 4) idx = 0;
        b_info[i][b_mafia] = mafia_ids[idx];
        save_bizz(i);
        update_bizz(i);
        MafiaCountBizz(mafia_ids[idx], 1);
        idx++;
    }
    return 1;
}

CMD:stopcapt(playerid, params[])
{
    if(p_info[playerid][admin] < 4) return 1;

    new gangzone = GetGangZoneID(playerid);
    if(gangzone == INVALID_CRIMINAL_ZONE_ID)
        return SendError(playerid, "Вы не на территории гетто");
    if(IsAGangRespawn(gangzone))
        return SendError(playerid, "Эта территория является респауном банды.");

    new i;
    if(Capture_Info[0][gGangZoneID] == gangzone)
        i = 0;
    else if(Capture_Info[1][gGangZoneID] == gangzone)
        i = 1;
    else return SendError(playerid, "Здесь не проходит капт.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[F] Администратор %s[%d] остановил капт.", get_name(playerid), playerid);
    SendFractionMessage(Capture_Info[i][gFaction][0], 0x33CC66FF, STRING_GLOBAL);
    SendFractionMessage(Capture_Info[i][gFaction][1], 0x33CC66FF, STRING_GLOBAL);

    GangZoneStopFlashForAll(GangZone_Info[Capture_Info[i][gGangZoneID]][gID]);
    GangZoneHideForAll(GangZone_Info[Capture_Info[i][gGangZoneID]][gID]);
    GangZoneShowForAll(GangZone_Info[Capture_Info[i][gGangZoneID]][gID], fraction_color[GangZone_Info[Capture_Info[i][gGangZoneID]][g_Fraction]]);

    foreach(new playerid: Player)
    {
        if(PlayerFixZone[playerid] != 0)
        {
            PlayerFixZone[playerid] = 0;
            GangZoneStopFlashForPlayer(playerid, i);
        }
    }
    Capture_Info[i][gGangZoneID] = INVALID_CRIMINAL_ZONE_ID;

    IsInAllowed(Capture_Info[i][gFaction][0]) = 0;
    IsInAllowed(Capture_Info[i][gFaction][1]) = 0;

    Capture_Info[i][gCount][0] = 0;
    Capture_Info[i][gCount][1] = 0;
    //Capture_Info[i][gTime][1] = unix+(60*50);
    Capture_Info[i][gStatus] = GANG_ZONE_NONE;//

    Capture_Info[i][gFaction][0] = 0;
    Capture_Info[i][gFaction][1] = 0;

    SendInfo(playerid, "Вы успешно остановили капт.");
    return 1;
}
alias:stopcapt("endcapt", "stopcapture");

CMD:stopbizwar(playerid, params[])
{
    if(p_info[playerid][admin] < 4) return 1;
    if(BizWar_Info[bWarTime] <= 0) return SendError(playerid, "В данный момент не проходит захват бизнеса.");
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[F] Администратор %s[%d] остановил захват бизнеса.", get_name(playerid), playerid);
    SendFractionMessage(p_info[playerid][member], 0x33CC66FF, STRING_GLOBAL);
    //save_bizz(i);
    //update_bizz(i);

    BizWar_Info[bMafia][0] = 0;
    BizWar_Info[bMafia][1] = 0;

    GangZoneStopFlashForAll(biz_war_gangzone);
    GangZoneHideForAll(biz_war_gangzone);
    GangZoneDestroy(biz_war_gangzone);
    biz_war_gangzone = -1;

    BizWar_Info[bWarTime] = 0;
    BizWar_Info[bCount][0] = 0;
    BizWar_Info[bCount][1] = 0;

    SendInfo(playerid, "Вы успешно остановили захват бизнеса.");
    return 1;
}



CMD:flip(playerid, params[])
{
    if(p_info[playerid][admin] < 1) return 1;

    new vehicleid;

    if(sscanf(params, "u", params[0]))
    {
        params[0] = playerid;
        SendInfo(playerid, "Используйте: /flip [ID игрока]");
    }
    if(params[0] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не в сети.");
    if(GetPlayerState(params[0]) != PLAYER_STATE_DRIVER && GetPlayerState(params[0]) != PLAYER_STATE_PASSENGER)
        return SendError(playerid, "Игрок должен находиться в транспортном средстве.");

    SendAccess(playerid, "Вы перевернули транспортное средство %s [%d].", get_name(params[0]), params[0]);

    vehicleid = GetPlayerVehicleID(params[0]);

    new Float:fa, Float:x, Float:y, Float:z;
    GetVehicleRotationQuat(vehicleid, fa, x, y, z);
    GetVehicleZAngle(vehicleid, fa);
    SetVehicleZAngle(vehicleid, fa);
    return 1;
}

CMD:fixveh(playerid, params[])
{
    if(p_info[playerid][admin] < 1)
        return 1;

    new
        vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == INVALID_VEHICLE_ID)
        return SendError(playerid, "Вы должны находиться в транспортном средстве.");

    RepairVehicle(vehicleid);
    SendAccess(playerid, "Вы отремонтировали транспортное средство.");
    return 1;
}

CMD:fixvehr(playerid, params[])
{
    if(p_info[playerid][admin] < 3)
        return 1;

    new Float:radius;
    if(sscanf(params, "f", radius)) return SendInfo(playerid, "Используйте: /fixvehr [радиус]");

    if(!(1.0 <= radius <= 100.0))
        return SendError(playerid, "Радиус должен быть не менее 1.0 и не более 100.0.");

    new
        Float:x,
        Float:y,
        Float:z;

    foreach(new i: Vehicle)
    {
        GetVehiclePos(i, x, y, z);

        if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
            RepairVehicle(i);
    }

    SendAccess(playerid, "Вы отремонтировали транспортные средства в радиусе %0.2f.", radius);
    return 1;
}

CMD:fuelcars(playerid, params[])
{
    if(p_info[playerid][admin] < 5)
        return 1;

    foreach(new i: Vehicle)
        veh_info[i][v_fuel] = GetVehicleData(GetVehicleModelEx(i), E_VD_MAX_FUEL);

    SendAccess(playerid, "Вы заправили все транспортные средства.");
    return 1;
}

CMD:gethere(playerid, params[])
{
    if(p_info[playerid][admin] < 3 && !IsPlayerYouTube(playerid, 1))
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /gethere [id игрока]");

    if(params[0] == INVALID_PLAYER_ID || params[0] == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!FD(playerid) && FD(params[0]))
        return 1;

    if(p_info[playerid][admin] < 3 && p_info[params[0]][admin] > 2)
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(params[0]) == PLAYER_STATE_WASTED)
        return 1;

    if(pSpectateId[params[0]] != INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок находится в режиме наблюдения.");

    new
        Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(playerid, x, y, z);

    if(IsPlayerInAnyVehicle(params[0]))
    {
        TeleportVehicleToPos(GetPlayerVehicleID(params[0]), x + 1.0, y, z, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    }
    else
    {
        SetPlayerPos(params[0], x + 1.0, y, z);
        SetPlayerInterior(params[0], GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(params[0], GetPlayerVirtualWorld(playerid));
    }

    UnloadUndergroundBots(params[0]);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] телепортировал %s [%d] к себе.", get_name(playerid), playerid, get_name(params[0]), params[0]);
    SendAdminMessage(0xA3A3A3FF, STRING_GLOBAL);

    SendAccess(playerid, "Вы телепортировали %s [%d] к себе.", get_name(params[0]), params[0]);
    SendInfo(params[0], "Администратор %s [%d] телепортировал Вас к себе.", get_name(playerid), playerid);
    return 1;
}
alias:gethere("gh");

CMD:goto(playerid, params[])
{
    if(p_info[playerid][admin] < 1 && !IsPlayerYouTube(playerid, 1))
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /goto [id игрока]");

    if(params[0] == INVALID_PLAYER_ID || params[0] == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!FD(playerid) && FD(params[0]))
        return 1;

    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(params[0]) == PLAYER_STATE_WASTED)
        return 1;

    if(pSpectateId[params[0]] != INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок находится в режиме наблюдения.");

    if(p_info[playerid][admin] < p_info[params[0]][admin] && p_info[params[0]][admin] != BOT_ADMIN_LEVEL) return 1;

    new
        Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(params[0], x, y, z);

    if(IsPlayerInAnyVehicle(playerid))
    {
        TeleportVehicleToPos(GetPlayerVehicleID(playerid), x + 1.0, y, z, 0.0, GetPlayerInterior(params[0]), GetPlayerVirtualWorld(params[0]));
    }
    else
    {
        SetPlayerPos(playerid, x + 1.0, y, z);
        SetPlayerInterior(playerid, GetPlayerInterior(params[0]));
        SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(params[0]));
    }

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] телепортировался %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0]);
    SendAdminMessage(0xA3A3A3FF, STRING_GLOBAL);

    SendAccess(playerid, "Вы телепортировались к %s [%d].", get_name(params[0]), params[0]);
    SendInfo(params[0], "Администратор %s [%d] телепортировался к Вам.", get_name(playerid), playerid);
    return 1;
}
alias:goto("g");

CMD:ptp(playerid, params[])
{
    if(p_info[playerid][admin] < 3)
        return 1;

    if(sscanf(params, "uu", params[0], params[1])) return SendInfo(playerid, "Используйте: /ptp [id игрока (кого)] [id игрока (к кому)]");

    if(params[0] == INVALID_PLAYER_ID || params[1] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(params[0] == params[1])
        return SendError(playerid, "Вы ввели одинаковые ID.");

    if(p_info[playerid][admin] < 3 && p_info[params[0]][admin] > 2)
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    new
        Float:x,
        Float:y,
        Float:z,
        player2_interior = GetPlayerInterior(params[1]),
        player2_world = GetPlayerVirtualWorld(params[1]);

    GetPlayerPos(params[1], x, y, z);

    if(IsPlayerInAnyVehicle(params[0]))
    {
        TeleportVehicleToPos(GetPlayerVehicleID(params[0]), x + 1.0, y, z, 0.0, player2_interior, player2_world, true);
    }
    else
    {
        SetPlayerPos(params[0], x + 1.0, y, z);
        SetPlayerInterior(params[0], player2_interior);
        SetPlayerVirtualWorld(params[0], player2_world);
    }

    UnloadUndergroundBots(params[0]);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] телепортировал %s [%d] к %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0], get_name(params[1]), params[1]);
    SendAdminMessage(0xA3A3A3FF, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Вы телепортировали %s [%d] к %s [%d].", get_name(params[0]), params[0], get_name(params[1]), params[1]);
    SendAccess(playerid, STRING_GLOBAL);
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] телепортировали Вас к %s [%d].", get_name(playerid), playerid, get_name(params[1]), params[1]);
    SendInfo(params[0], STRING_GLOBAL);

    printf("LOG_PLAYER: %s[%d] (%s %s) телепортировал %s[%d] (%s %s) к %s[%d] (%s %s) | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        get_name(params[0]), p_info[params[0]][ID], p_temp[params[0]][session_IP], IsPlayerMobile(params[0]) ? "Mobile": "PC",
        get_name(params[1]), p_info[params[1]][ID], p_temp[params[1]][session_IP], IsPlayerMobile(params[1]) ? "Mobile": "PC");
    return 1;
}
CMD:freeze(playerid, params[])
{
    if(p_info[playerid][admin] < 2 && !IsPlayerYouTube(playerid, 2))
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /freeze [id игрока]");

    if(params[0] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(p_info[playerid][admin] < p_info[params[0]][admin] && p_info[params[0]][admin] != BOT_ADMIN_LEVEL)
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] заморозил %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    Fix_TogglePlayerControllable(params[0], 0);

    SendAccess(playerid, "Вы заморозили %s [%d].", get_name(params[0]), params[0]);
    SendInfo(params[0], "Администратор %s [%d] заморозил Вас.", get_name(playerid), playerid);

    printf("LOG_PLAYER: %s[%d] (%s %s) заморозил %s[%d] (%s %s) | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        get_name(params[0]), p_info[params[0]][ID], p_temp[params[0]][session_IP], IsPlayerMobile(params[0]) ? "Mobile": "PC");
    return 1;
}
CMD:hp(playerid, params[])
{
	if(p_info[playerid][admin] < 1 && !IsPlayerYouTube(playerid, 1))
        return false;
	new vehicleid = GetPlayerVehicleID(playerid);
	SetPlayerHealth(playerid, 100.0);
	if(vehicleid  > 0)
	{
		SendInfo(playerid, "Вы пополнили HP и починили автомобиль.");
		RepairVehicle(vehicleid);
	}
	else
		SendInfo(playerid, "Вы пополнили HP.");
	return true;
}
CMD:unfreeze(playerid, params[])
{
    if(p_info[playerid][admin] < 1 && !IsPlayerYouTube(playerid, 1))
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /unfreeze [id игрока]");

    if(params[0] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] разморозил %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    Fix_TogglePlayerControllable(params[0], 1);

    SendAccess(playerid, "Вы разморозили %s [%d].", get_name(params[0]), params[0]);
    SendInfo(params[0], "Администратор %s [%d] разморозил Вас.", get_name(playerid), playerid);

    printf("LOG_PLAYER: %s[%d] (%s %s) разморозил %s[%d] (%s %s) | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        get_name(params[0]), p_info[params[0]][ID], p_temp[params[0]][session_IP], IsPlayerMobile(params[0]) ? "Mobile": "PC");
    return 1;
}
CMD:freezer(playerid, params[])
{
    if(p_info[playerid][admin] < 3 && !IsPlayerYouTube(playerid, 3)) return 1;
    if(sscanf(params, "i", params[0])) return SendInfo(playerid, "Используйте: /freezer [радиус]");
    if(params[0] > 100 || params[0] < 0) return SendError(playerid, "Радиус должен быть не менее 0 и не более 100.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] заморозил игроков в радиусе %d.", get_name(playerid), playerid, params[0]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    SendAccess(playerid, "Вы заморозили игроков в радиусе %d.", params[0]);

    foreach(new i: Player)
    {
        if(!IsPlayerStream(params[0], playerid, i) || p_info[playerid][admin] < p_info[i][admin]) continue;
        SendInfo(i, "Администратор %s [%d] заморозил Вас.", get_name(playerid), playerid);
        Fix_TogglePlayerControllable(i, 0);
    }

    printf("LOG_PLAYER: %s[%d] (%s %s) заморозил игроков в радиусе %d | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        params[0]);
    return 1;
}
CMD:unfreezer(playerid, params[])
{
    if(p_info[playerid][admin] < 3 && !IsPlayerYouTube(playerid, 3)) return 1;
    if(sscanf(params, "i", params[0])) return SendInfo(playerid, "Используйте: /unfreezer [радиус]");
    if(params[0] > 100 || params[0] < 0) return SendError(playerid, "Радиус должен быть не менее 0 и не более 100.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] разморозил игроков в радиусе %d.", get_name(playerid), playerid, params[0]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    SendAccess(playerid, "Вы разморозили игроков в радиусе %d.", params[0]);

    foreach(new i: Player)
    {
        if(!IsPlayerStream(params[0], playerid, i) || p_info[playerid][admin] < p_info[i][admin]) continue;
        SendInfo(i, "Администратор %s [%d] разморозил Вас.", get_name(playerid), playerid);
        Fix_TogglePlayerControllable(i, 1);
    }

    printf("LOG_PLAYER: %s[%d] (%s %s) разморозил игроков в радиусе %d | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        params[0]);
    return 1;
}
CMD:setamr(playerid, params[])
{
    if(p_info[playerid][admin] < 3 && !IsPlayerYouTube(playerid, 3)) return 1;
    if(sscanf(params, "ii", params[0], params[1])) return SendInfo(playerid, "Используйте: /setamr [радиус] [кол-во брони]");
    if(params[0] > 100 || params[0] < 0) return SendError(playerid, "Радиус должен быть не менее 0 и не более 100.");
    if(params[1] > 100 || params[1] < 0) return SendError(playerid, "Кол-во брони должно быть не менее 0 и не более 100.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] выдал %d брони в радиусе %d.", get_name(playerid), playerid, params[1], params[0]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    SendAccess(playerid, "Вы выдали %d брони в радиусе %d.", params[1], params[0]);

    foreach(new i: Player)
    {
        if(!IsPlayerStream(params[0], playerid, i) || p_info[playerid][admin] < p_info[i][admin]) continue;
        SendInfo(i, "Администратор %s [%d] выдал Вам %d брони.", get_name(playerid), playerid, params[1]);
        SetPlayerArmour(i, params[1]);
    }

    printf("LOG_PLAYER: %s[%d] (%s %s) выдал %d брони в радиусе %d | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        params[1], params[0]);
    return 1;
}
CMD:kick(playerid, params[])
{
    if(p_info[playerid][admin] < 2 && !IsPlayerYouTube(playerid, 2))
        return 1;

    new target, reason[144];
    if(sscanf(params, "us[144]", target, reason)) return SendInfo(playerid, "Используйте: /kick [id игрока] [причина]");

    if(target == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if(p_info[target][admin] != BOT_ADMIN_LEVEL && (p_info[target][admin] >= p_info[playerid][admin] || FD(target)))
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 3)) return 1;

    if(GetPVarInt(target, "BoneStol_ID")) return SendError(playerid, "Данный игрок в казино за столом, действие невозможно.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] кикнул %s [%d]. Причина: %s", get_name(playerid), playerid, get_name(target), target, reason);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    a_info[playerid][a_kick] = 1;
    MysqlUpdateAdminInt(playerid, "a_kick", a_info[playerid][a_kick]);
    WriteAdminLog(TYPE_LOG_KICK, get_name(playerid), p_info[target][name], reason);

    p_temp[target][dissconect_id] = 0;
    p_info[target][p_countUseCheat] = 3;

    if(p_info[target][admin] == BOT_ADMIN_LEVEL)
        SendInfo(target, "[AdminBan] kick:%s", get_name(playerid));

    Kick(target);
    return 1;
}

CMD:ban(playerid, params[])
{
    if(p_info[playerid][admin] < 3)
        return 1;

    new target, days, reason[144];
    if(sscanf(params, "uis[144]", target, days, reason)) return SendInfo(playerid, "Используйте: /ban [id игрока] [кол-во дней] [причина]");

    if(target == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= days <= 30))
        return SendError(playerid, "Кол-во дней блокировки должно быть не менее 1 и не более 30.");

    if(p_info[target][admin] != BOT_ADMIN_LEVEL && (p_info[target][admin] >= p_info[playerid][admin] || FD(target)))
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 7)) return 1;

    if(GetPVarInt(target, "BoneStol_ID")) return SendError(playerid, "Данный игрок в казино за столом, действие невозможно.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] заблокировал %s [%d] на %d %s. Причина: %s", get_name(playerid), playerid, get_name(target), target, days, Declension_ReturnWord(days, "день", "дня", "дней"), reason);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    new h, m, s, year, month, day;
    getdate(year, month, day);
    gettime(h,m,s);

    new unbandate;
    if(p_info[target][p_vip])
    {
        if(p_info[target][p_vip] == 3 && p_info[playerid][p_add_vip] == 1) unbandate = (((days * 86400) / 100) * 60) + unix;
        else
        {
            switch(p_info[target][p_vip])
            {
                case 1: unbandate = (((days * 86400) / 100) * 90) + unix;
                case 2: unbandate = (((days * 86400) / 100) * 80) + unix;
                case 3: unbandate = (((days * 86400) / 100) * 70) + unix;
            }
        }
    } else unbandate = (days * 86400) + unix;

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `table_ban` (`Name_Admin`, `Name_Player`, `Ban_Data`, `Unban_Data`, `Ban_Reason`) VALUES ('%e', '%e', NOW(), %d, '%e')",
    get_name(playerid), get_name(target), unbandate, reason);
    mysql_tquery(con_bd, STRING_GLOBAL);

    /*
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "        Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]", get_name(target), p_temp[target][session_IP], p_info[target][regip], p_info[target][regip]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);
    */

    WriteAdminLog(TYPE_LOG_BAN, get_name(playerid), p_info[target][name], reason);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), ""W"Внимание! Вас только что {"#cLIGHTRED"}забанили.\n\
        "W"Вас забанил(а): {"#cLIGHTRED"}%s\n\
        "W"Время: {"#cLIGHTRED"}%02d:%02d:%02d\n\
        "W"Дата: {"#cLIGHTRED"}%d.%d.%d\n\
        "W"Причина: {"#cLIGHTRED"}%s\n\
        "W"Разбан через: {"#cLIGHTRED"}%d дней\n\n\
        Форум поддержки: {"#cLIGHTRED"}"FORUM_URL"\n"W"Форум > Жалобы > {"#cLIGHTRED"}Жалобы на администрацию",
        get_name(playerid),
        h, m, s,
        year, month, day,
        reason,
        days);
    ShowPlayerDialog(target,D_NULL,DIALOG_STYLE_MSGBOX, ""I"Информация", STRING_GLOBAL,"Закрыть","");

    if(p_info[target][warn] > 2) p_info[target][warn] = 0;
    p_temp[target][dissconect_id] = 2;

    if(p_info[target][admin] == BOT_ADMIN_LEVEL)
        SendInfo(target, "[AdminBan] ban:%s", get_name(playerid));

    Kick(target);

    a_info[playerid][a_ban] = 1;
    MysqlUpdateAdminInt(playerid, "a_ban", a_info[playerid][a_ban]);
    return true;
}

CMD:sban(playerid, params[])
{
    if(p_info[playerid][admin] < 4)
        return 1;

    new target, days, reason[144];
    if(sscanf(params, "uis[144]", target, days, reason)) return SendInfo(playerid, "Используйте: /sban [id игрока] [кол-во дней] [причина]");

    if(target == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= days <= 30))
        return SendError(playerid, "Кол-во дней должно быть не менее 1 и не более 30.");

    if(p_info[target][admin] >= p_info[playerid][admin] || FD(target))
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 7)) return 1;

    if(GetPVarInt(target, "BoneStol_ID")) return SendError(playerid, "Данный игрок в казино за столом, действие невозможно.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] скрыто заблокировал %s [%d] на %d %s. Причина: %s", get_name(playerid), playerid, get_name(target), target, days, Declension_ReturnWord(days, "день", "дня", "дней"), reason);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    WriteAdminLog(TYPE_LOG_SBAN, get_name(playerid), p_info[target][name], reason);

    if(!FD(target))
    {
        new unbandate;
        if(p_info[target][p_vip])
        {
            if(p_info[target][p_vip] == 3 && p_info[playerid][p_add_vip] == 1) unbandate = (((days * 86400) / 100) * 60) + unix;
            else
            {
                switch(p_info[target][p_vip])
                {
                    case 1: unbandate = (((days * 86400) / 100) * 90) + unix;
                    case 2: unbandate = (((days * 86400) / 100) * 80) + unix;
                    case 3: unbandate = (((days * 86400) / 100) * 70) + unix;
                }
            }
        } else unbandate = (days * 86400) + unix;
        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `table_ban` (`Name_Admin`, `Name_Player`, `Ban_Data`, `Unban_Data`, `Ban_Reason`) VALUES ('%e', '%e', NOW(), %d, '%e')",
        get_name(playerid), get_name(target), unbandate, reason);
        mysql_tquery(con_bd, STRING_GLOBAL);

        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "        Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]", get_name(target), p_info[target][regip], p_temp[target][session_IP], p_temp[target][session_IP]);
        SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);
        p_temp[target][dissconect_id] = 2;
        Kick(target);
    }
    return 1;
}
CMD:offban(playerid, params[])
{
    if(p_info[playerid][admin] < 4)
        return 1;

    new nickname[MAX_PLAYER_NAME], days, reason[144];
    if(sscanf(params, "s[24]is[144]", nickname, days, reason)) return SendInfo(playerid, "Используйте: /offban [никнейм] [кол-во дней] [причина]");

    if(!(1 <= days <= 30))
        return SendError(playerid, "Кол-во дней должно быть не менее 1 и не более 30.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 7)) return 1;

    if(strcmp(nickname, FD1, true) == 0 || strcmp(nickname, FD2, true) == 0 ||
        strcmp(nickname, FD3, true) == 0 ||
        strcmp(nickname, FD4, true) == 0)
    {
        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] заблокировал %s на %d %s. Причина: %s",
            get_name(playerid),
            playerid,
            nickname,
            days,
            Declension_ReturnWord(days, "день", "дня", "дней"),
            reason);

        SendMes(playerid, COLOR_LIGHTRED, STRING_GLOBAL);

        new give_id;
        sscanf(FD1, "i", give_id);
        if(give_id != INVALID_PLAYER_ID)
        {
            SendInfo(give_id, "Администратор %s [%d] пытался заблокировать Вас.", get_name(playerid), playerid);
        }
        return 1;
    }

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `table_ban` WHERE `Name_Player` = '%e' LIMIT 1",
    nickname);
    mysql_tquery(con_bd, STRING_GLOBAL, "OffBan", "issi",playerid,nickname,reason,days);

    a_info[playerid][a_offban] = 1;
    MysqlUpdateAdminInt(playerid, "a_offban", a_info[playerid][a_offban]);
    return 1;
}

forward OffBan(playerid,tmp[],reason[], days);
public OffBan(playerid,tmp[],reason[], days)
{
    if(cache_num_rows() > 0)
        return SendError(playerid, "Игрок уже заблокирован.");

    new unbandate;

    unbandate = unix + days*86400;

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `table_ban` (`Name_Admin`, `Name_Player`, `Ban_Data`, `Unban_Data`, `Ban_Reason`) VALUES ('%e', '%e', NOW(), %d, '%e')",
    get_name(playerid), tmp, unbandate, reason);
    mysql_tquery(con_bd, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] заблокировал %s на %d %s. Причина: %s", get_name(playerid), playerid, tmp, days, Declension_ReturnWord(days, "день", "дня", "дней"), reason);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    WriteAdminLog(TYPE_LOG_OFFBAN, get_name(playerid), tmp, reason);
    return 1;
}

CMD:msg(playerid, params[])
{
    if(p_info[playerid][admin] < 4) return 1;
    if(!(1 <= strlen(params) <= 80)) return SendError(playerid, "Кол-во символов не может быть менее 1 и более 80.");
    if(AdvertisingCheck(params)) return AdvertisingPunishment(playerid, params, 0);

    // Проверяем счетчик;
    if(GetPVarInt(playerid, "MSGAntiAttack") > 20) return OnPlayerSystemBan(playerid, "MSG-ATTACK");
    // Обновляем счетчик;
    SetPVarInt(playerid, "MSGAntiAttack", GetPVarInt(playerid, "MSGAntiAttack") + 4);

    SendMesAll(0xFFD700FF, "Администратор %s [%d]: "W"%s", get_name(playerid), playerid, params);
    return 1;
}

CMD:skick(playerid, params[])
{
    if(p_info[playerid][admin] < 4)
        return 1;

    new target, reason[144];
    if(sscanf(params, "us[144]", target, reason)) return SendInfo(playerid, "Используйте: /skick [id игрока] [причина]");

    if(target == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине кика не может быть менее 1 и более 32.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 3)) return 1;

    if(p_info[target][admin] != BOT_ADMIN_LEVEL && (p_info[target][admin] >= p_info[playerid][admin] || FD(target)))
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(GetPVarInt(target, "BoneStol_ID")) return SendError(playerid, "Данный игрок в казино за столом, действие невозможно.");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] скрытно кикнул %s [%d]. Причина: %s", get_name(playerid), playerid, get_name(target), target, reason);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    WriteAdminLog(TYPE_LOG_SKICK, get_name(playerid), p_info[target][name], reason);
    p_temp[target][dissconect_id] = 0;
    Kick(target);
    return 1;
}

CMD:unwarn(playerid, params[])
{
    if(p_info[playerid][admin] < 4)
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /unwarn [id игрока]");

    if(params[0] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(0 == p_info[params[0]][warn])
        return SendError(playerid, "У игрока нет предупреждений.");

    p_info[params[0]][warn] -= 1;
    p_info[params[0]][warn_time] = 0;

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `accounts` SET `warn` = %d, `warn_time` = %d WHERE `id` = %d",
    p_info[params[0]][warn], p_info[params[0]][warn_time], p_info[params[0]][ID]);
    mysql_tquery(con_bd, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] снял предупреждение %s [%d]. Предупреждений: %d.", get_name(playerid), playerid, get_name(params[0]), params[0], p_info[params[0]][warn]);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    SendAccess(playerid, "Вы сняли %s [%d] предупреждение.", get_name(params[0]), params[0]);
    SendInfo(params[0], "Администратор %s [%d] снял Вам предупреждение.", get_name(playerid), playerid);
    return 1;
}

CMD:fwarn(playerid, params[])
{
    if(p_info[playerid][admin] < 5 && p_info[playerid][rang] < 9 && p_info[playerid][member] != MAYOR_LS) return 1;

    new target, reason[144];
    if(sscanf(params, "us[144]", target, reason)) return SendInfo(playerid, "Используйте: /fwarn [id игрока] [причина]");

    if(target == INVALID_PLAYER_ID || target == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if(p_info[playerid][member] == MAYOR_LS && p_info[target][member] != MAYOR_LS)
    {
        switch(p_info[playerid][rang])
        {
            case 8:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_PD)
                    return SendError(playerid, "Игрок не состоит в полиции.");
            }
            case 7:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_ARMY)
                    return SendError(playerid, "Игрок не состоит в армии.");
            }
            case 6:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_MEDIC)
                    return SendError(playerid, "Игрок не состоит в больнице.");
            }
            case 5:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_SNN)
                    return SendError(playerid, "Игрок не состоит в радиоцентре.");
            }
            default: return SendError(playerid, "Вы не министр.");
        }
    }
    else
    {
        if(p_info[playerid][rang] <= p_info[target][rang]) return SendError(playerid, "У Вас слишком маленький ранг во фракции.");
        if(p_info[playerid][rang] < 9) return SendError(playerid, "Вы не можете пользоваться этой командой.");
        if(p_info[target][member] != p_info[playerid][member]) return SendError(playerid, "Игрок не состоит во фракции.");
    }
    if( p_info[target][leader] != 0 && p_info[playerid][admin] < 5) return SendError(playerid, "Лидеру невозможно выдать предупреждение");

    p_info[target][fwarn] += 1;
    if(p_info[target][fwarn] >= 3)
    {
        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `log_fraction` (`PlayerID`, `Member`, `Rang`, `Type`, `Reason`) VALUES (%d, %d, %d, '1', '3 предупреждения')",
        p_info[target][ID], p_info[target][member], p_info[target][rang]);
        mysql_tquery(con_bd, STRING_GLOBAL);

        Iter_Remove(gFactionPlayers[p_info[target][member]], target);
        p_info[target][member] = 0;
        p_info[target][rang] = 0;
        p_info[target][fskin] = 0;
        Iter_Add(gFactionPlayers[p_info[target][member]], target);
        if(GetPlayerHouseID(target) != INVALID_HOUSE_ID) p_info[target][spawn] = 2;
        else p_info[target][spawn] = 0;
        p_info[target][fwork] = false;
        SetPlayerSkinEx(target);
        SetPlayerColor(target, fraction_color[0]);
        if(GetFactionCategory(p_info[target][member]) == FACTION_CATEGORY_PD || GetFactionCategory(p_info[target][member]) == FACTION_CATEGORY_FBI)
            p_temp[target][StatusOnDuty] = 0;
        save_player(target);

        f_ResetPlayerWeapons(target);

        SendInfo(target, "%s [%d] уволил Вас из фракции. Причина: %s", get_name(playerid), playerid, reason);
        SendAccess(playerid, "Вы уволили %s [%d] из фракции. Причина: %s", get_name(target), target, reason);
        return 1;
    }
    else
    {
        SendInfo(target, "%s [%d] выдал Вам предупреждение во фракции. Причина: %s", get_name(playerid), playerid, reason);
        SendAccess(playerid, "Вы выдали %s [%d] предупреждение во фракции.", get_name(target), target);
    }
    return 1;
}

CMD:funwarn(playerid, params[])
{
    if(p_info[playerid][admin] < 5 && p_info[playerid][rang] < 9 && p_info[playerid][member] != MAYOR_LS) return 1;

    new target, reason[144];
    if(sscanf(params, "us[144]", target, reason)) return SendInfo(playerid, "Используйте: /funwarn [id игрока] [причина]");

    if(target == INVALID_PLAYER_ID || target == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if(p_info[playerid][member] == MAYOR_LS && p_info[target][member] != MAYOR_LS)
    {
        switch(p_info[playerid][rang])
        {
            case 8:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_PD)
                    return SendError(playerid, "Игрок не состоит в полиции.");
            }
            case 7:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_ARMY)
                    return SendError(playerid, "Игрок не состоит в армии.");
            }
            case 6:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_MEDIC)
                    return SendError(playerid, "Игрок не состоит в больнице.");
            }
            case 5:
            {
                if(GetFactionCategory(p_info[target][member]) != FACTION_CATEGORY_SNN)
                    return SendError(playerid, "Игрок не состоит в радиоцентре.");
            }
            default: return SendError(playerid, "Вы не министр.");
        }
    }
    else
    {
        if(p_info[playerid][rang] <= p_info[target][rang]) return SendError(playerid, "У Вас слишком маленький ранг во фракции.");
        if(p_info[playerid][rang] < 9) return SendError(playerid, "Вы не можете пользоваться этой командой.");
        if(p_info[target][member] != p_info[playerid][member]) return SendError(playerid, "Игрок не состоит во фракции.");
    }
    if(p_info[target][fwarn] <= 0)
        return SendError(playerid, "У игрока нет предупреждений.");

    p_info[target][fwarn] -= 1;

    SendAccess(playerid, "Вы сняли с %s [%d] предупреждение во фракции. Причина: %s", get_name(target), target, reason);
    SendInfo(target, "%s [%d] снял с Вас предупреждение во фракции. Причина: %s", get_name(playerid), playerid, reason);
    return 1;
}

CMD:awarn(playerid, params[])
{
    if( p_info[playerid][admin] < 5)
        return 1;

    new target, reason[144];
    if(sscanf(params, "us[144]", target, reason)) return SendInfo(playerid, "Используйте: /awarn [id игрока] [причина]");

    if(target == INVALID_PLAYER_ID || target == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if(p_info[playerid][admin] <= p_info[target][admin])
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(p_info[target][admin] < 1)
        return SendError(playerid, "Игрок не администратор.");

    p_info[target][fwarn] += 1;
    if(p_info[target][fwarn] >= 3)
    {
        Iter_Remove(gAdmins, target);

        p_info[target][admin_pass] =
        p_info[target][admin] =
        p_info[target][youtube_adm] = 0;
        save_player(playerid);

        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `admin_logs` WHERE `name` = '%e'",
        get_name(target));
        mysql_tquery(con_bd, STRING_GLOBAL);

        SendInfo(target, "Администратор %s [%d] снял Вас с должности администратора. Причина: %s", get_name(playerid), playerid, reason);
        SendAccess(playerid, "Вы сняли %s [%d] с должности администратора. Причина: %s", get_name(target), target, reason);
    }
    else SendInfo(target, "Администратор %s [%d] выдал Вам админ. предупреждение. Причина: %s", get_name(playerid), playerid, reason);
    SendAccess(playerid, "Вы выдали %s [%d] админ. предупреждение. Причина: %s", get_name(target), target, reason);
    return 1;
}

CMD:aunwarn(playerid, params[])
{
    if( p_info[playerid][admin] < 5)
        return 1;

    new target, reason[144];
    if(sscanf(params, "us[144]", target, reason)) return SendInfo(playerid, "Используйте: /aunwarn [id игрока] [причина]");

    if(target == INVALID_PLAYER_ID || target == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if( p_info[playerid][admin] <= p_info[target][admin])
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(p_info[target][fwarn] <= 0)
        return SendError(playerid, "У игрока нет предупреждений.");

    p_info[target][fwarn] -= 1;

    WriteAdminLog(TYPE_LOG_UNWARN, get_name(playerid), p_info[target][name], reason);

    SendAccess(playerid, "Вы сняли %s [%d] админ. предупреждение. Причина: %s", get_name(target), target, reason);
    SendInfo(target, "Администратор %s [%d] снял Вам админ. предупреждение. Причина: %s", get_name(playerid), playerid, reason);
    return 1;
}

CMD:warn(playerid, params[])
{
    if(p_info[playerid][admin] < 3)
        return 1;

    new target, days, reason[144];
    if(sscanf(params, "uis[144]", target, days, reason)) return SendInfo(playerid, "Используйте: /warn [id игрока] [кол-во дней] [причина]");

    if(target == INVALID_PLAYER_ID || target == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if(!(1 <= days <= 7))
        return SendError(playerid, "Кол-во дней не может быть менее 1 и более 7.");

    if(p_info[target][admin] != BOT_ADMIN_LEVEL && (p_info[target][admin] >= p_info[playerid][admin] || FD(target)))
        return SendError(playerid, "У Вас слишком маленький уровень администратора.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 5)) return 1;

    if(GetPVarInt(target, "BoneStol_ID")) return SendError(playerid, "Данный игрок в казино за столом, действие невозможно.");

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `log_fraction` (`PlayerID`, `Member`, `Rang`, `Type`, `Reason`) VALUES (%d, %d, %d, '1', 'Предупреждение администрации')",
    p_info[target][ID], p_info[target][member], p_info[target][rang]);
    mysql_tquery(con_bd, STRING_GLOBAL);

    p_info[target][warn] += 1;
    p_info[target][leader] = 0;
    p_info[target][rang] = 0;
    Iter_Remove(gFactionPlayers[p_info[target][member]], target);
    p_info[target][member] = 0;
    Iter_Add(gFactionPlayers[p_info[target][member]], target);

    p_info[target][fwork] = false;

    if(p_info[target][warn] >= 3)
    {
        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] заблокировал %s [%d] на 3 дня. Причина: 3 предупреждения.", get_name(playerid), playerid, get_name(target), target);
        SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "        Причина 3-его предупреждения: %s", reason);
        SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] заблокировал Вас на 3 дня | [3 предупреждения]. Причина: %s", get_name(playerid), playerid, reason);
        SendInfo(target, STRING_GLOBAL);

        f(STRING_GLOBAL,"%d %d %s", target, 3, reason);
        callcmd::ban(playerid, STRING_GLOBAL);
        return 1;
    }
    else
    {
        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] выдал предупреждение %s [%d] на %d %s (%d из 3). Причина: %s", get_name(playerid), playerid, get_name(target), target, days, Declension_ReturnWord(days, "день", "дня", "дней"), p_info[target][warn], reason);
        SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

        if(p_info[target][p_vip])
        {
            if(p_info[target][p_vip] == 3 && p_info[playerid][p_add_vip] == 1) p_info[target][warn_time] = (((days * 86400) / 100) * 60) + unix;
            else
            {
                switch(p_info[target][p_vip])
                {
                    case 1: p_info[target][warn_time] = (((days * 86400) / 100) * 90) + unix;
                    case 2: p_info[target][warn_time] = (((days * 86400) / 100) * 80) + unix;
                    case 3: p_info[target][warn_time] = (((days * 86400) / 100) * 70) + unix;
                }
            }
        } else p_info[target][warn_time] = (days * 86400) + unix;

        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] выдал Вам предупреждение на %d %s [%d/3]. Причина: %s", get_name(playerid), playerid, days, Declension_ReturnWord(days, "день", "дня", "дней"), p_info[target][warn], reason);
        SendInfo(target, STRING_GLOBAL);
    }

    a_info[playerid][a_warn] = 1;
    MysqlUpdateAdminInt(playerid, "a_warn", a_info[playerid][a_warn]);
    WriteAdminLog(TYPE_LOG_WARN, get_name(playerid), p_info[target][name], reason);

    p_temp[target][dissconect_id] = 1;

    if(p_info[target][admin] == BOT_ADMIN_LEVEL)
        SendInfo(target, "[AdminBan] warn:%s", get_name(playerid));

    Kick(target);
    return 1;
}
CMD:mute(playerid, params[])
{
    if(p_info[playerid][admin] < 2 && !IsPlayerYouTube(playerid, 2))
        return 1;

    new target, minutes, reason[144];
    if(sscanf(params, "uis[144]", target, minutes, reason)) return SendInfo(playerid, "Используйте: /mute [id игрока] [кол-во минут] [причина]");

    if(target == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= minutes <= 300))
        return SendError(playerid, "Кол-во минут блокировки чата не может быть менее 1 и более 300.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    if(AdvertisingCheck(reason)) return AdvertisingPunishment(playerid, reason, 0);
    if(IsAAdminAttack(playerid, 3)) return 1;

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] выдал блокировку чата %s [%d] на %d %s. Причина: %s",
        get_name(playerid), playerid, get_name(target), target, minutes, Declension_ReturnWord(minutes, "минуту", "минуты", "минут"), reason);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    a_info[playerid][a_mute] = 1;
    MysqlUpdateAdminInt(playerid, "a_mute", a_info[playerid][a_mute]);

    if(p_info[target][p_vip])
    {
        if(p_info[target][p_vip] == 3 && p_info[playerid][p_add_vip] == 1) p_info[target][mute] = ((minutes * 60) / 100) * 60;
        else
        {
            switch(p_info[target][p_vip])
            {
                case 1: p_info[target][mute] = ((minutes * 60) / 100) * 90;
                case 2: p_info[target][mute] = ((minutes * 60) / 100) * 80;
                case 3: p_info[target][mute] = ((minutes * 60) / 100) * 70;
            }
        }
    } else p_info[target][mute] = minutes * 60;


    //VoiceChat_MutePlayer(target);

    WriteAdminLog(TYPE_LOG_MUTE, get_name(playerid), p_info[target][name], reason);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] выдал Вам блокировку чата на %d %s. Причина: %s",get_name(playerid), playerid, minutes, Declension_ReturnWord(minutes, "минуту", "минуты", "минут"), reason);
    SendInfo(target, STRING_GLOBAL);
    SendInfo(target, "Оставшееся кол-во времени до снятия блокировки чата: /time");
    return 1;
}
CMD:unmute(playerid, params[])
{
    if(p_info[playerid][admin] < 2)
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /unmute [id игрока]");

    if(params[0] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(0 == p_info[params[0]][mute])
        return SendError(playerid, "Игрок не имеет блокировки чата.");

    p_info[params[0]][mute] = 0;
    //VoiceChat_UnMutePlayer(params[0]);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] снял блокировку чата %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0]);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    WriteAdminLog(TYPE_LOG_UNMUTE, get_name(playerid), get_name(params[0]), "Снял бан чата");

    SendAccess(playerid, "Вы сняли %s [%d] блокировку чата.", get_name(params[0]), params[0]);
    SendInfo(params[0], "Администратор %s [%d] снял Вам блокировку чата.", get_name(playerid), playerid);
    return 1;
}

CMD:rmute(playerid, params[])
{
    if(p_info[playerid][admin] < 1)
        return 1;

    new target, minutes, reason[144];
    if(sscanf(params, "uis[144]", target, minutes, reason)) return SendInfo(playerid, "Используйте: /rmute [id игрока] [кол-во минут] [причина]");

    if(target == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(!(1 <= minutes <= 120))
        return SendError(playerid, "Кол-во минут блокировки репорта не может быть менее 1 и более 120.");

    if(!(1 <= strlen(reason) <= 32))
        return SendError(playerid, "Кол-во символов в причине не может быть менее 1 и более 32.");

    p_info[target][rmute] = minutes*60;
    save_player(target);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] выдал блокировку репорта %s [%d] на %d %s. Причина: %s", get_name(playerid), playerid, get_name(target), target, minutes, Declension_ReturnWord(minutes, "минуту", "минуты", "минут"), reason);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    a_info[playerid][a_mute]++;
    MysqlUpdateAdminInt(playerid, "a_mute", a_info[playerid][a_mute]);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] выдал Вам блокировку репорта на %d %s. Причина: %s", get_name(playerid), playerid, minutes, Declension_ReturnWord(minutes, "минуту", "минуты", "минут"), reason);
    SendInfo(target, STRING_GLOBAL);
    return 1;
}
CMD:unrmute(playerid, params[])
{
    if(p_info[playerid][admin] < 1)
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /unrmute [id игрока]");

    if(params[0] == INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок не найден.");

    if(0 == p_info[params[0]][rmute])
        return SendError(playerid, "Игрок не имеет блокировки репорта.");

    p_info[params[0]][rmute] = 0;

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s [%d] снял блокировку репорта %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0]);
    SendAdminMessageForServer(COLOR_LIGHTRED, STRING_GLOBAL);

    SendAccess(playerid, "Вы сняли %s [%d] блокировку репорта.", p_info[params[0]][name], params[0]);
    SendInfo(playerid, "Администратор %s [%d] снял Вам блокировку репорта.", get_name(playerid), playerid);
    return 1;
}

CMD:unban(playerid, params[])
{
    if(p_info[playerid][admin] < 4) return 1;
    if(sscanf(params, "s[24]s[144]", params[0], PlayerFixUnban[playerid])) return SendInfo(playerid, "Используйте: /unban [NickName] [Причина]");

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `id` FROM `table_ban` WHERE `Name_Player`= '%e' LIMIT 1", params[0]);
    mysql_tquery(con_bd, STRING_GLOBAL, "un_ban", "is", playerid, params[0]);
    return 1;
}

forward un_ban(playerid, names[]);
public un_ban(playerid, names[])
{
    if(0 == cache_num_rows())
        return SendError(playerid, "Игрок не заблокирован.");

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `table_ban` WHERE `Name_Player` = '%e'",
    names);
    mysql_tquery(con_bd, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] разблокировал %s.", get_name(playerid), playerid, names);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    new str_reason[64];
    format(str_reason, sizeof(str_reason), "Причина: %s", PlayerFixUnban[playerid]);
    WriteAdminLog(TYPE_LOG_UNBAN, get_name(playerid), names, str_reason);
    return 1;
}
CMD:veh(playerid, params[])
{
    if(p_info[playerid][admin] < 4 && !IsPlayerYouTube(playerid, 3)) return 1;
    new Float: pos[3];
    if(sscanf(params, "iii", params[0], params[1], params[2])) return SendInfo(playerid, "Используйте: /veh [id] [цвет № 1] [цвет № 2]");
    if(params[0] < 400 || (p_info[playerid][admin] <= 4 && params[0] > 610)) return SendError(playerid, "ID модели должен быть не менее 400 и не более 610.");
    //if(params[0] < 400 || params[1] > 610) return SendInfo(playerid, "Используйте: /veh [id] [цвет № 1] [цвет № 2]");
    if(params[0] == 432 || params[0] == 520 || params[0] == 425) return SendError(playerid, "Данный транспорт нельзя создать.");
    GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
    new car = CreateVehicleVEx(NPO_NONE, NPO_NONE, params[0],pos[0],pos[1]+0.5,pos[2],90.0000000,params[1],params[2], 600);
    LinkVehicleToInterior(car, GetPlayerInterior(playerid));
    veh_info[car][v_admin] = 1;
    veh_info[car][v_lock] = 0;
    veh_info[car][v_fuel] = GetVehicleData(GetVehicleModelEx(car), E_VD_MAX_FUEL);

    printf("LOG_PLAYER: %s[%d] (%s %s) создал т/с <%s>(%d) | #AdminLogs",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC",
        GetVehicleName(car), GetVehicleModelEx(car));

    if(p_info[playerid][admin] == BOT_ADMIN_LEVEL)
    {
        for(new i; i != LIC_ALL; i++)
        {
            p_info[playerid][Lic][i] = 1;
            p_info[playerid][Lic_Warn][i] = 0;
            p_info[playerid][Lic_Time][i] = 8760;
        }
        OnPlayerUpdateLicData(playerid);
        PutPlayerInVehicle(playerid, car, 0);
    }
    return 1;
}
CMD:setskin(playerid, params[])
{
    if(p_info[playerid][admin] < 4 && !IsPlayerYouTube(playerid, 2)) return 1;
    if(sscanf(params, "ui", params[0], params[1])) return SendInfo(playerid, "Используйте: /setskin [id игрока] [id скина]");
    if(!IsPlayerConnected(params[0]) || params[0] == INVALID_PLAYER_ID) return SendError(playerid, "Игрок не найден.");
    if(!FD(playerid))
    {
        switch(params[1])
        {
            case 1..73, 75..311: {}
            default: return SendError(playerid, "Неверный ID скина.");
        }
    }

    SendAccess(playerid, "Вы выдали %s [%d] временный скин %d.", get_name(params[0]), params[0], params[1]);
    SendInfo(params[0], "Администратор %s [%d] выдал Вам временный скин %d.", get_name(playerid), playerid, params[1]);

    SetPlayerSkin(params[0], params[1]);
    return 1;
}


CMD:recon(playerid, params[])
{
    if(p_info[playerid][admin] < 1 && !IsPlayerYouTube(playerid, 2))
        return 1;

    if(p_info[playerid][loggedIn] != 1)
        return SendError(playerid, "Вы не авторизованы.");

    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED)
        return 1;

    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /re [id игрока]");

    if(params[0] == INVALID_PLAYER_ID || params[0] == playerid)
        return SendError(playerid, "Игрок не найден.");

    if(!FD(playerid) && FD(params[0]))
        return 1;

    if(pSpectateId[params[0]] != INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок находится в режиме наблюдения.");

    if(pSpectateId[playerid] != INVALID_PLAYER_ID)
        pSpectatorId[pSpectateId[playerid]] = INVALID_PLAYER_ID;

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && p_info[playerid][admin] > 0 &&
        pSpectateId[playerid] == INVALID_PLAYER_ID)
            ShowTextDrawForPlayer(playerid, TD_ID_RECON_INFO);

    if(p_info[playerid][admin] < 5)
    {
        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] начал следить за %s [%d].", get_name(playerid), playerid, get_name(params[0]), params[0]);
        SendAdminMessage(0xA3A3A3FF, STRING_GLOBAL);
    }
    SendAccess(playerid, "Вы начали следить за %s [%d].", get_name(params[0]), params[0]);

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        GetPlayerPos(playerid, pPosBeforeSpectateX[playerid], pPosBeforeSpectateY[playerid], pPosBeforeSpectateZ[playerid]);
        pInteriorBeforeSpectate[playerid] = GetPlayerInterior(playerid);
        pVirtualWorldBeforeSpectate[playerid] = GetPlayerVirtualWorld(playerid);
        SetPVarInt(playerid, !"spawn_after_spectate_mode", 1);
    }
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(params[0]));
    SetPlayerInterior(playerid, GetPlayerInterior(params[0]));

    pSpectateId[playerid] = params[0];
    pSpectatorId[params[0]] = playerid;

    TogglePlayerSpectating(playerid, 1);

    if(IsPlayerInAnyVehicle(params[0]))
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(params[0]), SPECTATE_MODE_NORMAL);
    else
        PlayerSpectatePlayer(playerid, params[0], SPECTATE_MODE_NORMAL);

    if(p_info[params[0]][admin] == BOT_ADMIN_LEVEL)
        SendInfo(params[0], "[AdminRecon] start /re:%s", get_name(playerid));

    return 1;
}
alias:recon("re", "spectate", "spec");

CMD:reconoff(playerid, params[])
{
    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED)
        return 1;
    if(pSpectateId[playerid] == INVALID_PLAYER_ID)
        return SendError(playerid, "Вы не находитесь в режиме наблюдения.");
    TogglePlayerSpectating(playerid, 0);

    if((p_info[playerid][admin] > 0 || IsPlayerYouTube(playerid, 2)) && !GetPVarInt(playerid, #BODY_MDC_USE))
    {
        HideTextDrawForPlayer(playerid, TD_ID_RECON_INFO);
        HideTextDrawForPlayer(playerid, TD_ID_RECON_PANEL);
    }
    if(GetPVarInt(playerid, #BODY_MDC_USE))
    {
        MDC_PAGE(playerid, PAGE_MEMBERS);
        if(GetPVarInt(playerid, #CCTV_VEH)) SetTimerEx("CCTV_VEH_TIMER", 1000, false, "i", playerid);
        DeletePVar(playerid, #BODY_MDC_USE);
    }
    if(p_info[pSpectateId[playerid]][admin] == BOT_ADMIN_LEVEL)
        SendInfo(pSpectateId[playerid], "[AdminRecon] end /re:%s", get_name(playerid));

    pSpectatorId[pSpectateId[playerid]] = INVALID_PLAYER_ID;
    pSpectateId[playerid] = INVALID_PLAYER_ID;

    SendAccess(playerid, "Вы вышли из режима слежения.");


    return 1;
}
alias:reconoff("reoff", "spectateoff", "specoff");

////bots functions:
CMD:bregip(playerid, params[])
{
    if(p_info[playerid][admin] != BOT_ADMIN_LEVEL) return 1;
    if(sscanf(params, "s[24]", params[0])) return SendInfo(playerid, "Используйте: /bregip [IP]");
    format(p_info[playerid][regip], 16, params[0]);
    MysqlUpdatePlayerStr(playerid, "regip", p_info[playerid][regip]);
    SendInfo(playerid, "[BOT] New regip: %s", params[0]);
    return 1;
}

CMD:bip(playerid, params[])
{
    if(p_info[playerid][admin] != BOT_ADMIN_LEVEL) return 1;
    if(sscanf(params, "s[24]", params[0])) return SendInfo(playerid, "Используйте: /bip [IP]");
    format(p_temp[playerid][session_IP], 16, params[0]);
    MysqlUpdatePlayerStr(playerid, "lastip", p_temp[playerid][session_IP]);
    SendInfo(playerid, "[BOT] New lastip: %s", params[0]);
    return 1;
}
////////////////////

CMD:makeadmin(playerid, params[])
{
    if(!FD(playerid) && p_info[playerid][admin] < 7)
        return 1;

    new target, admin_level;
    if(sscanf(params, "ui", target, admin_level)) return SendInfo(playerid, "Используйте: /makeadmin [id игрока] [уровень]");

    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target))
        return SendError(playerid, "Игрок не найден.");

    if(!(0 <= admin_level <= 10))
        return SendError(playerid, "Уровень администратора не может быть менее 0 или более 10.");

    if(p_info[playerid][admin] < 10 && admin_level > 4)
        return SendError(playerid, "Уровень администратора не может быть менее 0 или более 4.");

    if(p_info[target][admin] == admin_level)
        return SendError(playerid, "Уровень администратора не может быть равен текущему.");

    if(admin_level == 0) // игрок сейчас админ и мы его снимаем с админки
    {
        if(p_info[target][admin] > p_info[playerid][admin])
            return SendError(playerid, "Уровень администратора выше чем Ваш.");

        Iter_Remove(gAdmins, target);

        p_info[target][admin_pass] = 0;

        SendAccess(playerid, "Вы сняли %s [%d] с должности администратора.", get_name(target), target);
        SendInfo(target, "Администратор %s [%d] снял Вас с должности администратора.", get_name(playerid), playerid);

        STRING_GLOBAL[0] = EOS;
        mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `admin_logs` WHERE `name` = '%e'",
        get_name(target));
        mysql_tquery(con_bd, STRING_GLOBAL);
    }
    else // игрок сейчас не админ и мы его назначаем администратором, либо повышаем уровень администратора
    {
        SendAccess(playerid, "Вы назначили %s [%d] на должность администратора %d уровня.", get_name(target), target, admin_level);
        SendInfo(target, "Администратор %s [%d] назначил Вас на должность администратора %d уровня.", get_name(playerid), playerid, admin_level);

        if(p_info[target][admin] == 0) // игрок не админ и мы его назначаем
        {
            if(0 == Iter_Contains(gAdmins, target))
                Iter_Add(gAdmins, target);

            p_info[target][admin_pass] = 100000 + random(899999);
            SendInfo(target, "Ваш пароль от панели администратора: %d.", p_info[target][admin_pass]);

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `admin_logs` WHERE `name` = '%e'",
            get_name(target));
            mysql_tquery(con_bd, STRING_GLOBAL);

            STRING_GLOBAL[0] = EOS;
            mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `admin_logs` (`name`) VALUES ('%e')",
            get_name(target));
            mysql_tquery(con_bd, STRING_GLOBAL);
        }
    }

    p_info[target][admin] = admin_level;
    save_player(target);
    return 1;
}

CMD:jetpack(playerid, params[])
{
    if(!FD(playerid) && p_info[playerid][admin] < 7)
    return 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    SendAccess(playerid, "Вы создали JetPack.");
    return 1;
}

CMD:checktesters(playerid, params[])
{
    if(!FD(playerid) && p_info[playerid][admin] < 7)
        return 1;

    CHECK_TESTERS = !CHECK_TESTERS;
    SendInfo(playerid, "Вы %s проверку тестеров.", (CHECK_TESTERS == false) ? ("отключили") : ("включили"));
    return 1;
}

CMD:deladmin(playerid, params[])
{
    if(!FD(playerid) || p_info[playerid][admin] < 6)
        return 1;

    if(isnull(params))
        return SendInfo(playerid, "Используйте: /deladmin [никнейм]");

    if(GetPlayerID(params) != INVALID_PLAYER_ID)
        return SendError(playerid, "Игрок в игре.");


    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT `admin` FROM `accounts` WHERE `name` = '%e' LIMIT 1", params);
    mysql_tquery(con_bd, STRING_GLOBAL, "DeleteAdmin_Callback", "is", playerid, params);
    return 1;
}

forward DeleteAdmin_Callback(playerid, nickname[]);
public DeleteAdmin_Callback(playerid, nickname[])
{
    if(!cache_num_rows())
        return SendError(playerid, "Игрок не администратор.");

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `accounts` SET `admin` = 0, `admin_pass` = 0 WHERE `name` = '%e' LIMIT 1", nickname);
    mysql_tquery(con_bd, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "DELETE FROM `admin_logs` WHERE `name` = '%e'", nickname);
    mysql_tquery(con_bd, STRING_GLOBAL);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[A] %s [%d] снял %s с должности администратора.", get_name(playerid), playerid, nickname);
    SendAdminMessage(COLOR_LIGHTRED, STRING_GLOBAL);

    SendAccess(playerid, "Вы сняли %s с должности администратора.", nickname);
    return 1;
}

CMD:templeader(playerid, params[])
{
    if(p_info[playerid][admin] < 2) return 1;
    p_temp[playerid][p_listitem][39] = playerid;
    STRING_GLOBAL[0] = EOS;
    for (new i = 1; i < MAX_FRACTIONS; i++)
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"I"[%d]"W" %s\n", STRING_GLOBAL, i, GetFractionName(i));

    STRING_MIN[0] = EOS;
    format(STRING_MIN, sizeof(STRING_MIN), ""I"%s", get_name(playerid));
    ShowPlayerDialog(playerid, D_MAKE_LEADER, DIALOG_STYLE_LIST, STRING_MIN, STRING_GLOBAL, "Далее", "Отмена");
    return 1;
}

CMD:makeleader(playerid, params[])
{
    if(p_info[playerid][admin] < 5) return true;
    if(sscanf(params, "u", params[0])) return SendInfo(playerid, "Используйте: /makeleader [id игрока]");
    if(params[0] == INVALID_PLAYER_ID) return SendError(playerid, "Игрок не найден.");
    if(p_info[params[0]][member]) return SendError(playerid, "Игрок во фракции.");
    if(p_info[params[0]][warn]) return SendError(playerid, "У игрока есть предупреждение.");
    p_temp[playerid][p_listitem][39] = params[0];
    STRING_GLOBAL[0] = EOS;
    for (new i = 1; i < MAX_FRACTIONS; i ++)
    {
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"I"[%d]"W" %s\n", STRING_GLOBAL, i, GetFractionName(i));
    }
    STRING_MIN[0] = EOS;
    format(STRING_MIN, sizeof(STRING_MIN), ""I"%s", get_name(params[0]));
    ShowPlayerDialog(playerid, D_MAKE_LEADER, DIALOG_STYLE_LIST, STRING_MIN, STRING_GLOBAL, "Далее", "Отмена");
    return 1;
}

CMD:create(playerid, params[])
{
    if(!FD(playerid) || p_info[playerid][admin] < 10) return 1;
    STRING_GLOBAL[0] = EOS;
    f(STRING_GLOBAL, ""I"[1]"W" Создать дом\tCоздано: %d\n"I"[2]"W" Создать бизнес\tСоздано: %d",totalhouses,totalbizz);
    return ShowPlayerDialog(playerid, D_CREATE, DIALOG_STYLE_LIST, ""I"Меню создания", STRING_GLOBAL, "Выбор","Закрыть");
}

CMD:apanel(playerid, params[])
{
    if(!FD(playerid) || p_info[playerid][admin] < 7) return 1;
    ShowApanelDialog(playerid);
    return 1;
}

CMD:phone_buy_number(playerid, params[])
{
    if(!FD(playerid) || p_info[playerid][admin] < 10)
        return 1;

    if(PhoneBuyNumber == false) return SendError(playerid, "Очереди на приобретение номера телефонов нет.");

    PhoneBuyNumber = false;

    SendInfo(playerid, "Вы очистили очередь на приобретение номера телефона.");
    return 1;
}

ShowApanelDialog(playerid)
{
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), ""W"\
    "I"[1]"W" Стоимость игровой валюты\t%d$\n\
    "I"[2]"W" Кол-во опыта\t%d EXP\n\
    "I"[3]"W" Настройка античита\t[OLD]\n\
    "I"[4]"W" Настройка античита\t[VAC]\n\
    "I"[5]"W" Зарплаты на работах\t%d\n\
    "I"[6]"W" Курс FM\t%d\n\
    "I"[7]"W" Сделать PayDay\n\
    "I"[8]"W" Настройки сервера",
    ServerInfo[Donate], ServerInfo[Experian], ServerInfo[Salary], ServerInfo[DonationMultiplier]);
    ShowPlayerDialog(playerid, D_APANEL, DIALOG_STYLE_TABLIST, ""I"Панель администратора", STRING_GLOBAL, "Принять", "Отмена");
    return 1;
}

ShowDialogServerInfo(playerid)
{
    new SI_NameStatusUse[][] = {"{"#cRED"}[Отключено]", "{"#cGREEN"}[Включено]"},
        SI_NameStatus[][] = {"{"#cRED"}[Отключено]", "{"#cGREEN"}[Включено]", "{"#cBLUE"}[Только PC]", "{"#cBLUE"}[Только Mobile]"};
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), ""W"\
        "I"[1]"W" Почтовый ящик \t%s\n\
        "I"[2]"W" Регистрация через E-Mail\t%s\n\
        "I"[3]"W" Регистрация на сервере\t%s\n\
        "I"[4]"W" Блокировка INVALID CLIENT\t%s\n\
        "I"[5]"W" Roulette System\t%s\n\
        "I"[6]"W" Case System\t%s\n\
        "I"[7]"W" Отображение REAL CARS\t%s\n\
        "I"[8]"W" Отображение NEW SKINS\t%s\n\
        "I"[9]"W" AntiDM System\t%s\n\
        "I"[10]"W" Заморозка при DM\t%s\n\
        "I"[11]"W" Мусорные баки\t%s\n\
        "I"[12]"W" VK Security\t%s\n\
        "I"[13]"W" TG Security\t%s\n\
        "I"[14]"W" SECURITY BOT URL\t%0.5s...",
        SI_NameStatusUse[ServerInfo[MailerStatus]],
        SI_NameStatus[ServerInfo[RegistrationMail]],
        SI_NameStatus[ServerInfo[RegistrationStatus]],
        SI_NameStatusUse[ServerInfo[BlockInvalidClient]],
        SI_NameStatusUse[ServerInfo[RouletteSystem]],
        SI_NameStatusUse[ServerInfo[CaseSystem]],
        SI_NameStatusUse[ServerInfo[RealCarsStatus]],
        SI_NameStatusUse[ServerInfo[RealSkinsStatus]],
        SI_NameStatusUse[ServerInfo[AntiDMSystem]],
        SI_NameStatusUse[ServerInfo[FreezeOnDM]],
        SI_NameStatusUse[ServerInfo[TrashSystem]],
        SI_NameStatusUse[ServerInfo[VKSecurity]],
        SI_NameStatusUse[ServerInfo[TGSecurity]],
        ServerInfo[SecurityBotURL]
    );
    ShowPlayerDialog(playerid, D_APANEL_SERVER_SETTINGS, DIALOG_STYLE_TABLIST, ""I"Настройки сервера", STRING_GLOBAL, "Далее", "Отмена");
    return 1;
}
