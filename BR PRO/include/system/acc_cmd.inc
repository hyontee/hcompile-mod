CMD:wear(playerid, params[])
{
    new accessoryId;

    if(sscanf(params, "i", accessoryId))
    {
        SendClientMessage(playerid, 0xFF9900FF, "Используйте: /wear [ID аксессуара]");
        SendClientMessage(playerid, 0xCECECEFF, "Пример: /wear 0 - надеть Крылья бабочки");
        SendClientMessage(playerid, 0xCECECEFF, "Чтобы узнать ID аксессуара, используйте /acclist");
        return 1;
    }

    if(accessoryId < 0 || accessoryId >= sizeof(accessory))
    {
        new errorMsg[128];
        format(errorMsg, sizeof(errorMsg), "Аксессуара с ID %d не существует. Допустимые ID: 0 - %d", 
               accessoryId, sizeof(accessory) - 1);
        SendClientMessage(playerid, 0xFF0000FF, errorMsg);
        return 1;
    }

    if(GetPlayerAccountID(playerid) <= 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка: вы не авторизованы.");
        return 1;
    }

    new freeSlot = -1;
    for(new s = MIN_ACCESSORY_SLOT; s <= MAX_ACCESSORY_SLOT; s++)
    {
        if(!IsPlayerAttachedObjectSlotUsed(playerid, s))
        {
            freeSlot = s;
            break;
        }
    }

    if(freeSlot == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "У вас нет свободных слотов для аксессуаров.");
        SendClientMessage(playerid, 0xCECECEFF, "Используйте /myacs чтобы снять ненужные аксессуары.");
        return 1;
    }

    if(!Accessory_CanEquip(playerid, accessoryId))
    {
        return 1;
    }

    new deleteQuery[128];
    mysql_format(mysql, deleteQuery, sizeof(deleteQuery),
        "DELETE FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d",
        GetPlayerAccountID(playerid), freeSlot);
    mysql_query(mysql, deleteQuery, false);

    Accessory_OnEquipped(playerid, freeSlot, accessoryId);
    SetPVarInt(playerid, "acs_id_in_slot", accessoryId);

    new message[256];
    format(message, sizeof(message), "Вы надели аксессуар: {FF9900}%s {66CC33}(ID: %d)", 
           accessory[accessoryId][NAME_ACCESSORY], accessoryId);
    SendClientMessage(playerid, 0x66CC33FF, message);

    format(message, sizeof(message), "Слот: %d | Кость: %d", freeSlot, accessory[accessoryId][BONE_ACCESSORY]);
    SendClientMessage(playerid, 0xCECECEFF, message);

    SendClientMessage(playerid, 0xFFFF00FF, "Чтобы отредактировать положение аксессуара, используйте:");
    SendClientMessage(playerid, 0xFFFF00FF, "/myacs - выбрать из списка или /accedit [слот]");

    ApplyAnimation(playerid, "PED", "IDLE_chat", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:acclist(playerid, params[])
{
    SendClientMessage(playerid, 0xFFFF00FF, "");
    SendClientMessage(playerid, 0xFFFF00FF, "Список аксессуаров (ID - Название)");
    SendClientMessage(playerid, 0xFFFF00FF, "");

    new total = sizeof(accessory);
    new displayCount = (total > 20) ? 20 : total;
    
    for(new i = 0; i < displayCount; i++)
    {
        new listmsg[128];
        format(listmsg, sizeof(listmsg), "{CECECE}ID {FF9900}%d {CECECE}- %s", i, accessory[i][NAME_ACCESSORY]);
        SendClientMessage(playerid, 0xCECECEFF, listmsg);
    }

    if(total > 20)
    {
        SendClientMessage(playerid, 0xCECECEFF, "... и еще много других.");
        SendClientMessage(playerid, 0xFFFF00FF, "Полный список отправлен в консоль (клавиша `)");
        
        for(new i = 0; i < total; i++)
        {
            new consolmsg[128];
            format(consolmsg, sizeof(consolmsg), "ID %d: %s", i, accessory[i][NAME_ACCESSORY]);
            SendClientMessage(playerid, 0xAAAAAAFF, consolmsg);
        }
    }

    SendClientMessage(playerid, 0xFFFF00FF, "");
    SendClientMessage(playerid, 0x66CC33FF, "Используйте: /wear [ID] чтобы надеть аксессуар");
    return 1;
}

CMD:removeacc(playerid, params[])
{
    new slot;

    if(sscanf(params, "i", slot))
    {
        SendClientMessage(playerid, 0xFF9900FF, "Используйте: /removeacc [слот]");
        SendClientMessage(playerid, 0xCECECEFF, "Пример: /removeacc 2 - снять аксессуар из слота 2");
        return 1;
    }

    if(slot < MIN_ACCESSORY_SLOT || slot > MAX_ACCESSORY_SLOT)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Неверный слот. Используйте слоты со 2 по 9.");
        return 1;
    }

    if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
    {
        SendClientMessage(playerid, 0xFF0000FF, "В этом слоте нет аксессуара.");
        return 1;
    }

    Accessory_OnUnequipped(playerid, slot);
    DeletePVar(playerid, "acs_id_in_slot");

    SendClientMessage(playerid, 0x66CC33FF, "Аксессуар снят.");
    return 1;
}

CMD:accedit(playerid, params[])
{
    new slot;
    if(sscanf(params, "i", slot))
        return SendClientMessage(playerid, -1, "Используйте: /accedit [слот 2-9]"), 1;

    if(slot < MIN_ACCESSORY_SLOT || slot > MAX_ACCESSORY_SLOT)
        return SendClientMessage(playerid, -1, "Неверный слот. Используйте слоты 2-9."), 1;

    if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
        return SendClientMessage(playerid, -1, "В этом слоте нет аксессуара."), 1;

    return Accessory_StartEditor(playerid, slot);
}

CMD:myacs1(playerid, params[])
{
    new list[1024];
    format(list, sizeof(list), "Слот\tАксессуар\n");

    new count = 0;
    for(new s = MIN_ACCESSORY_SLOT; s <= MAX_ACCESSORY_SLOT; s++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, s))
        {
            new acs = GetPVarInt(playerid, "acs_id_in_slot");
            new acs_name[32] = "Неизвестный";
            
            if(acs >= 0 && acs < sizeof(accessory))
            {
                format(acs_name, sizeof(acs_name), "%s", accessory[acs][NAME_ACCESSORY]);
            }
            else
            {
                new modelid, index, bone;
                #if defined GetPlayerAttachedObject
                GetPlayerAttachedObject(playerid, s, modelid, index, bone);
                for(new i = 0; i < sizeof(accessory); i++)
                {
                    if(accessory[i][ID_ACCESSORY] == modelid)
                    {
                        format(acs_name, sizeof(acs_name), "%s", accessory[i][NAME_ACCESSORY]);
                        break;
                    }
                }
                #endif
            }

            new row[128];
            format(row, sizeof(row), "%d\t%s\n", s, acs_name);
            strcat(list, row, sizeof(list));
            count++;
        }
    }

    if(count <= 0)
        return SendClientMessage(playerid, -1, "У вас нет надетых аксессуаров."), 1;

    ShowPlayerDialog(playerid, ACCESSORY_DIALOG_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Мои аксессуары", list, "Выбрать", "Закрыть");
    return 1;
}