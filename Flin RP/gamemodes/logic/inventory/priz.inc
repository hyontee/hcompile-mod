forward OnPlayerShowPriz(playerid);
public OnPlayerShowPriz(playerid)
{
    if(cache_num_rows())
    {
        for(new i; i < cache_num_rows(); i++)
        {
            cache_get_value_name_int(i, "id", Prize[playerid][i][0]);
            cache_get_value_name_int(i, "itemID", Prize[playerid][i][1]);
            cache_get_value_name_int(i, "extraData1", Prize[playerid][i][2]);
            cache_get_value_name_int(i, "extraData2", Prize[playerid][i][3]);
            cache_get_value_name_int(i, "extraData3", Prize[playerid][i][4]);
            cache_get_value_name_int(i, "price", Prize[playerid][i][5]);
            cache_get_value_name_int(i, "sell_block", Prize[playerid][i][6]);
        }
        ShowPriz(playerid, cache_num_rows());
    } else SendError(playerid, "У Вас нет призов.");
    return 1;
}

ShowPriz(playerid, count)
{
    STRING_GLOBAL[0] = EOS;
    for(new i = 0; i < count; i++)
    {
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s%d. %s\n", STRING_GLOBAL, i + 1, GetPrizeItemsName(Prize[playerid][i][1], Prize[playerid][i][2], Prize[playerid][i][3], Prize[playerid][i][4]));
    }
    ShowPlayerDialog(playerid, D_TAKE_PRIZ, DIALOG_STYLE_LIST, ""I"Список призов", STRING_GLOBAL, "Далее", "Отмена");
    return 1;
}

InsertRoulettePriz(playerid, type, userID, itemID, extraData1 = 0, extraData2 = 0, extraData3 = 0, price = 0, sell_block = 0)
{
    #pragma unused price

    if(playerid != INVALID_PLAYER_ID)
    {
        SendInfo(playerid, "Вы выиграли: %s.", GetPrizeItemsName(itemID, extraData1, extraData2, extraData3));

        printf("LOG_PLAYER: %s[%d](%s %s) выиграл %s. Тип: %d | #GetRoulette",
        get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC", GetPrizeItemsName(itemID, extraData1, extraData2, extraData3), type);

        SendInfo(playerid, "Чтобы забрать приз, введите /priz");
    }
    else
    {
        printf("LOG_PLAYER: Номер аккаунта [%d] выиграл %s. Тип: %d | #GetRoulette",
        userID, GetPrizeItemsName(itemID, extraData1, extraData2, extraData3), type);
    }
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `roulette` (`userID`, `itemID`, `extraData1`, `extraData2`, `extraData3`, `price`, `sell_block`) VALUES (%d, %d, %d, %d, %d, %d, %d)",
    userID, itemID, extraData1, extraData2, extraData3, price, sell_block);
    mysql_tquery(con_bd, STRING_GLOBAL);
    return 1;
}

GivePlayerRoulettePrize(playerid, number, idx, prize, count, count2, count3 = 0, price = 0, sell_block = 0)
{
    if(Prize[playerid][number][0] == 0 && Prize[playerid][number][1] == 0 && Prize[playerid][number][2] == 0)
        return SendError(playerid, "Произошла ошибка (Prize - #3). Сообщите в тех. раздел.");

    #pragma unused count3
    #pragma unused price
    switch(prize)
    {
        case TYPE_NEW_PRIZE_EXP:
        {
            p_info[playerid][exp] += count;
            PlayerLevelUpdateCheck(playerid);
        }
        case TYPE_NEW_PRIZE_MONEY, TYPE_NEW_PRIZE_U_MONEY:
        {
            SetPlayerMoney(playerid, count, true, "забрал /priz");
        }
        case TYPE_NEW_PRIZE_DONATE, TYPE_NEW_PRIZE_U_DONATE:
        {
            p_info[playerid][flinmoney] += count;
            MysqlUpdatePlayerInt(playerid, "flinmoney", p_info[playerid][flinmoney]);

            if(p_temp[playerid][TextDrawRoulette] == true) UpdatePlayerRouletteInfo(playerid);
        }
        case TYPE_NEW_PRIZE_INVENTORY:
        {
            if(!GivePlayerInventory(playerid, count2, count, .reason = "забрал /priz"))
                return 0;
        }
        case TYPE_NEW_PRIZE_U_SKIN, TYPE_NEW_PRIZE_SKIN, TYPE_NEW_PRIZE_ACCESSORIES:
        {
            if(!GivePlayerInventory(playerid, count, .reason = "забрал /priz"))
                return 0;
        }
        case TYPE_NEW_PRIZE_VEHICLE:
        {
            SendInfo(playerid, "Выберите необходимый слот из предложенного списка.");
            AddVehicleToPlayer(playerid, count, sell_block == 0 ? count2 : 4, price);
        }
        case TYPE_NEW_PRIZE_U_VEHICLE:
        {
            SendInfo(playerid, "Выберите необходимый слот из предложенного списка.");
            AddVehicleToPlayer(playerid, count, sell_block == 0 ? count2 : 4, price);
        }
        case TYPE_NEW_PRIZE_VIP:
        {
            new temp_vip_idx = count + 1;
            if(p_info[playerid][p_vip] > 0 && temp_vip_idx < p_info[playerid][p_vip]) return SendError(playerid, "У Вас уже есть VIP статус уровнем выше.");
            if(p_info[playerid][p_vip] != temp_vip_idx) p_info[playerid][p_vip_time] = 0;
            p_info[playerid][p_vip] = temp_vip_idx;
            if(p_info[playerid][p_vip_time]) p_info[playerid][p_vip_time] += 86400 * count2;
            else p_info[playerid][p_vip_time] = (gettime() + (86400 * count2));
        }
        default: return SendError(playerid, "Произошла ошибка (Prize - #1). Сообщите в тех. раздел.");
    }

    SendAccess(playerid, "Вы забрали: %s.", GetPrizeItemsName(prize, count, count2, count3));

    printf("LOG_PLAYER: %s[%d](%s %s) забрал %s | #GiveRoulette",
    get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC", GetPrizeItemsName(prize, count, count2, count3));

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `roulette` SET `activated` = 1 WHERE `id` = %d LIMIT 1",
    idx);
    mysql_tquery(con_bd, STRING_GLOBAL);

    for(new i; i < 50; i++)
    {
        Prize[playerid][i][0] = 0;
        Prize[playerid][i][1] = 0;
        Prize[playerid][i][2] = 0;
        Prize[playerid][i][3] = 0;
        Prize[playerid][i][4] = 0;
        Prize[playerid][i][5] = 0;
        Prize[playerid][i][6] = 0;
    }

    PrizeMySQLCheck[playerid] = gettime();
    return 1;
}

SellPlayerRoulettePrize(playerid, idx, prize, count, count2, count3 = 0, price = 0, sell_block = 0)
{
    #pragma unused sell_block
    switch(prize)
    {
        case 7 .. 11:
        {
            p_info[playerid][flinmoney] += price;
            MysqlUpdatePlayerInt(playerid, "flinmoney", p_info[playerid][flinmoney]);
        }
        default: return SendError(playerid, "Произошла ошибка (Prize - #3). Сообщите в тех. раздел.");
    }

    SendAccess(playerid, "Вы продали приз %s за %d "NAME_DONATE".", GetPrizeItemsName(prize, count, count2, count3), price);

    printf("LOG_PLAYER: %s[%d](%s %s) продал %s за %d "NAME_DONATE" | #SellRoulette",
    get_name(playerid), p_info[playerid][ID], p_temp[playerid][session_IP], IsPlayerMobile(playerid) ? "Mobile": "PC", GetPrizeItemsName(prize, count, count2, count3), price);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `roulette` SET `activated` = '2' WHERE `id` = %d LIMIT 1",
    idx);
    mysql_tquery(con_bd, STRING_GLOBAL);

    for(new i; i < 50; i++)
    {
        Prize[playerid][i][0] = 0;
        Prize[playerid][i][1] = 0;
        Prize[playerid][i][2] = 0;
        Prize[playerid][i][3] = 0;
        Prize[playerid][i][4] = 0;
        Prize[playerid][i][5] = 0;
        Prize[playerid][i][6] = 0;
    }

    PrizeMySQLCheck[playerid] = gettime();
    return 1;
}

GetPrizeItemsName(prize, count, count2 = 0, count3 = 0)
{
    #pragma unused count3
    new str[256];
    switch(prize)
    {
        case TYPE_NEW_PRIZE_EXP, TYPE_NEW_PRIZE_DONATE, TYPE_NEW_PRIZE_U_DONATE, TYPE_NEW_PRIZE_SKIN, TYPE_NEW_PRIZE_U_SKIN:
        {
            format(str, sizeof(str), "%s: %d", TypePrizeName[prize], count);
        }
        case TYPE_NEW_PRIZE_MONEY, TYPE_NEW_PRIZE_U_MONEY:
        {
            format(str, sizeof(str), "%s: %d$", TypePrizeName[prize], count);
        }
        case TYPE_NEW_PRIZE_INVENTORY:
        {
            format(str, sizeof(str), "%s: %s %d ед.", TypePrizeName[prize], ItemsInfo[count2][iName], count);
        }
        case TYPE_NEW_PRIZE_ACCESSORIES:
        {
            format(str, sizeof(str), "%s: %s", TypePrizeName[prize], ItemsInfo[count][iName]);
        }
        case TYPE_NEW_PRIZE_VEHICLE, TYPE_NEW_PRIZE_U_VEHICLE:
        {
            format(str, sizeof(str), "%s: %s", TypePrizeName[prize], GetVehicleName(INVALID_VEHICLE_ID, count));
        }
        case TYPE_NEW_PRIZE_VIP:
        {
            format(str, sizeof(str), "%s: %s, %d дн.", TypePrizeName[prize], TypeVIPName[count], count2);
        }
        default: str = "Нет";
    }
    return str;
}

CMD:priz(playerid, params[])
{
    if(PrizeMySQLCheck[playerid] > gettime()) return SendError(playerid, "Нельзя использовать команду так часто, попробуйте через %d сек.", PrizeMySQLCheck[playerid] - gettime());
    PrizeMySQLCheck[playerid] = gettime() + 15;
    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT * FROM `roulette` WHERE `userID` = %d AND `activated` = 0 LIMIT 50",
    p_info[playerid][ID]);
    mysql_tquery(con_bd, STRING_GLOBAL, "OnPlayerShowPriz", "d", playerid);
    return 1;
}
