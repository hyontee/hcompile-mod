#if defined _gordeev_inv_included
    #endinput
#endif
#define _gordeev_inv_included

#if !defined DIALOG_INV_MAIN
    #define DIALOG_INV_MAIN         (29662)
    #define DIALOG_INV_SKINS        (29789)
    #define DIALOG_INV_SKIN_ACTION  (29790)
    #define DIALOG_INV_RESOURCES    (29791)
    #define DIALOG_INV_RESOURCE_ACT (29792)
    #define DIALOG_BUY_NUMBER_MAIN  (29793)
    #define DIALOG_BUY_NUMBER_INPUT (29794)
#endif

#if !defined NUMBER_PRICE_RANDOM_RU
    #define NUMBER_PRICE_RANDOM_RU  (500000)
    #define NUMBER_PRICE_CUSTOM_RU  (750000)
#endif

enum E_PLAYER_NUMBER_RESOURCE
{
    PNR_SQL_ID,
    PNR_NUMBER[16]
}

new g_player_number_resource[MAX_PLAYERS][32][E_PLAYER_NUMBER_RESOURCE];
new g_player_number_resource_count[MAX_PLAYERS];

stock ShowInventoryMainDialog(playerid)
{
    return Dialog
    (
        playerid, DIALOG_INV_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{FFD700}Инвентарь {FFFFFF}| Выберите нужное Вам меню инвентаря",
        "№\tКатегория\tОписание кнопки\n"\
        "{FFD700}1\t{FFFFFF}Мои скины\t{BEBEBE}Просмотр скинов\n"\
        "{FFD700}2\t{FFFFFF}Мои аксессуары\t{BEBEBE}Просмотр аксессуаров\n"\
        "{FFD700}3\t{FFFFFF}Мои ресурсы\t{BEBEBE}Просмотр купленных номеров",
        "Выбрать", "Отмена"
    );
}

CMD:inv(playerid)
{
    if(!IsPlayerLogged(playerid) || GetPlayerAccountID(playerid) <= 0)
    {
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Инвентарь доступен только после авторизации.");
    }

    return ShowInventoryMainDialog(playerid);
}

stock bool:IsPlayerNearOwnableCarTrunk(playerid, vehicleid)
{
    new Float:x, Float:y, Float:z;
    new Float:angle, Float:distance;
    GetCoordVehicle(vehicleid, VEHICLE_COORD_TYPE_BOOT, x, y, z, angle, distance);
    return IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z);
}

stock GetPlayerOwnableCarSafe(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return INVALID_VEHICLE_ID;
    }
    if(!IsAOwnableCar(vehicleid))
    {
        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
        return INVALID_VEHICLE_ID;
    }
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(!(0 <= index < MAX_OWNABLE_CARS) || GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
    {
        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
        return INVALID_VEHICLE_ID;
    }
    return vehicleid;
}

stock SyncPlayerSkinFromInventory(playerid)
{
    if(!IsPlayerLogged(playerid)) return 0;
    if(1 <= GetPlayerTeamEx(playerid) < MAX_ORG) return 0;

    new query[144], Cache:result;

    mysql_format(mysql, query, sizeof query, "SELECT skin_id FROM inventory_skins WHERE owner_skin=%d AND use_skin=1 ORDER BY id DESC LIMIT 1", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);

    if(cache_num_rows())
    {
        new skin_id = cache_get_field_content_int(0, "skin_id");
        if(0 <= skin_id <= 311 && skin_id != GetPlayerData(playerid, P_SKIN))
        {
            SetPlayerData(playerid, P_SKIN, skin_id);
            UpdatePlayerDatabaseInt(playerid, "skin", skin_id);
        }
    }

    cache_delete(result);
    return 1;
}

stock myskins(playerid)
{
    new fmt_text[2048], Cache: result, id;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM inventory_skins WHERE owner_skin='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();

    if(!rows)
    {
        ShowNotification(playerid, 2, "У Вас нет никаких скинов", 5, "", "");
        CheckSkinPlayer(playerid);
    }
    else
    {
        new query[150], skin_id, use, skin_use[50];

        format(fmt_text, sizeof fmt_text, "№\t[Игровой ID]\tСтатус скина\n");

        for(new i; i < rows; i++)
        {
            id = cache_get_field_content_int(i, "id");
            skin_id = cache_get_field_content_int(i, "skin_id");
            use = cache_get_field_content_int(i, "use_skin");

            if(use > 0) format(skin_use, sizeof skin_use, "{8EF674}[ надет ]");
            else format(skin_use, sizeof skin_use, "{BEBEBE}[ можно надеть ]");

            format(query, sizeof query, "%d\t[%d]\t%s\n", i + 1, skin_id, skin_use);
            strcat(fmt_text, query);
            SetPlayerListitemValue(playerid, i, id);
        }

        Dialog
        (
            playerid, DIALOG_INV_SKINS, DIALOG_STYLE_TABLIST_HEADERS,
            "{FA8072}Инвентарь {FFFFFF}| Выберите игровой скин из списка ниже",
            fmt_text,
            "Выбрать", "Закрыть"
        );
    }

    cache_delete(result);
    return 1;
}

stock ShowPlayerBuyNumberMainDialog(playerid)
{
    return Dialog
    (
        playerid, DIALOG_BUY_NUMBER_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF5A5A}Покупка номеров",
        "№\tТип номерного знака\tОписание\n"\
        "1\tСлучайный номерной знак\tСгенерировать случайный номер\n"\
        "2\tИндивидуальный номерной знак\tВвести собственный номер",
        "Выбрать", "Закрыть"
    );
}

stock LoadPlayerNumberResources(playerid)
{
    new query[160], Cache:result;
    g_player_number_resource_count[playerid] = 0;

    mysql_format(mysql, query, sizeof query, "SELECT id, plate_number FROM player_number_inventory WHERE player_id=%d ORDER BY id ASC LIMIT 32", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);

    for(new i; i < cache_num_rows() && i < 32; i++)
    {
        g_player_number_resource_count[playerid]++;
        g_player_number_resource[playerid][i][PNR_SQL_ID] = cache_get_field_content_int(i, "id");
        cache_get_field_content(i, "plate_number", g_player_number_resource[playerid][i][PNR_NUMBER], mysql, 16);
    }
    cache_delete(result);
    return 1;
}

stock GivePlayerNumberResource(playerid, const number[])
{
    new query[160];
    mysql_format(mysql, query, sizeof query, "INSERT INTO player_number_inventory (player_id, plate_number) VALUES (%d, '%e')", GetPlayerAccountID(playerid), number);
    mysql_query(mysql, query, false);
    if(mysql_errno()) return 0;

    LoadPlayerNumberResources(playerid);
    return 1;
}

stock DeletePlayerNumResourceSlot(playerid, slot)
{
    if(!(0 <= slot < g_player_number_resource_count[playerid])) return 0;

    new query[96];
    mysql_format(mysql, query, sizeof query, "DELETE FROM player_number_inventory WHERE id=%d LIMIT 1", g_player_number_resource[playerid][slot][PNR_SQL_ID]);
    mysql_query(mysql, query, false);
    if(mysql_errno()) return 0;

    LoadPlayerNumberResources(playerid);
    return 1;
}

stock ShowPlayerNumberResources(playerid)
{
    LoadPlayerNumberResources(playerid);

    if(!g_player_number_resource_count[playerid])
        return ShowNotification(playerid, 2, "У Вас нет купленных номерных знаков", 4, "", "");

    new fmt_text[2048], row[96];
    format(fmt_text, sizeof fmt_text, "№\tТип\tНомерной знак\n");

    for(new i; i < g_player_number_resource_count[playerid]; i++)
    {
        format(row, sizeof row, "%d\tНомер\t%s 17\n", i + 1, g_player_number_resource[playerid][i][PNR_NUMBER]);
        strcat(fmt_text, row);
        SetPlayerListitemValue(playerid, i, i);
    }

    return Dialog(playerid, DIALOG_INV_RESOURCES, DIALOG_STYLE_TABLIST_HEADERS, "{FA8072}Инвентарь {FFFFFF}| Мои ресурсы", fmt_text, "Выбрать", "Закрыть");
}

stock BuyPlayerRandomNumberResource(playerid)
{
    new number[16], query[128], Cache:result;

    for(new attempt = 0; attempt < 20; attempt++)
    {
        format(number, sizeof number, GenerateCarNumber());

        mysql_format(mysql, query, sizeof query, "SELECT id FROM ownable_cars WHERE number='%e' LIMIT 1", number);
        result = mysql_query(mysql, query, true);

        if(!cache_num_rows())
        {
            cache_delete(result);
            break;
        }

        cache_delete(result);
        number[0] = EOS;
    }

    if(!number[0])
    {
        return ShowNotification(playerid, 2, "Не удалось подобрать свободный номер. Попробуйте еще раз", 4, "", "");
    }

    if(GetPlayerMoneyEx(playerid) < NUMBER_PRICE_RANDOM_RU)
    {
        new fmt_text[128];
        format(fmt_text, sizeof fmt_text, "Недостаточно денег. Для покупки необходимо %d рублей", NUMBER_PRICE_RANDOM_RU);
        return ShowNotification(playerid, 2, fmt_text, 4, "", "");
    }

    if(!GivePlayerNumberResource(playerid, number))
        return SendClientMessage(playerid, -1, "Ошибка SQL при выдаче номерного знака");

    GivePlayerMoneyEx(playerid, -NUMBER_PRICE_RANDOM_RU, "Покупка номерного знака", true, true);

    new fmt_text[144];
    format(fmt_text, sizeof fmt_text, "Вы успешно купили номер '%s 17' за %d рублей", number, NUMBER_PRICE_RANDOM_RU);
    return ShowNotification(playerid, 3, fmt_text, 5, "", "");
}

stock BuyPlayerCustomNumberResource(playerid, const number[])
{
    new query[128], Cache:result;

    if(GetPlayerMoneyEx(playerid) < NUMBER_PRICE_CUSTOM_RU)
    {
        new fmt_text[128];
        format(fmt_text, sizeof fmt_text, "Недостаточно денег. Для покупки необходимо %d рублей", NUMBER_PRICE_CUSTOM_RU);
        return ShowNotification(playerid, 2, fmt_text, 4, "", "");
    }

    mysql_format(mysql, query, sizeof query, "SELECT id FROM ownable_cars WHERE number='%e' LIMIT 1", number);
    result = mysql_query(mysql, query, true);
    if(cache_num_rows())
    {
        cache_delete(result);
        return ShowNotification(playerid, 2, "Данный номер уже занят", 4, "", "");
    }
    cache_delete(result);

    if(!GivePlayerNumberResource(playerid, number))
        return SendClientMessage(playerid, -1, "Ошибка SQL при выдаче номерного знака");

    GivePlayerMoneyEx(playerid, -NUMBER_PRICE_CUSTOM_RU, "Покупка номерного знака", true, true);

    new fmt_text[144];
    format(fmt_text, sizeof fmt_text, "Вы успешно купили номер '%s 17' за %d рублей", number, NUMBER_PRICE_CUSTOM_RU);
    return ShowNotification(playerid, 3, fmt_text, 5, "", "");
}

stock ApplyPlayerNumberResource(playerid, slot)
{
    if(!(0 <= slot < g_player_number_resource_count[playerid]))
        return SendClientMessage(playerid, -1, "Номерной знак не найден");

    new vehicleid = GetPlayerOwnableCarSafe(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");

    if(!(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == vehicleid) && !IsPlayerNearOwnableCarTrunk(playerid, vehicleid))
        return SendClientMessage(playerid, 0x999999FF, "Вы не можете установить номерной знак");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(strcmp(g_ownable_car[index][OC_NUMBER], "------", true))
        return SendClientMessage(playerid, 0x999999FF, "Сначала снимите текущий номерной знак");

    format(g_ownable_car[index][OC_NUMBER], 8, g_player_number_resource[playerid][slot][PNR_NUMBER]);
    BT_SetNumPlate(vehicleid, 1, g_player_number_resource[playerid][slot][PNR_NUMBER], "17");

    new query[160];
    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET number='%e' WHERE id=%d LIMIT 1", g_player_number_resource[playerid][slot][PNR_NUMBER], GetOwnableCarData(index, OC_SQL_ID));
    mysql_query(mysql, query, false);

    DeletePlayerNumResourceSlot(playerid, slot);
    return ShowNotification(playerid, 3, "Номерной знак успешно установлен на транспорт", 4, "", "");
}

stock CheckSkinPlayer(playerid)
{
    new query[144], Cache:result;

    mysql_format(mysql, query, sizeof query, "SELECT * FROM inventory_skins WHERE owner_skin = %d", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);

    new rows = cache_num_rows();
    cache_delete(result);

    if(!rows)
    {
        mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id,use_skin) VALUES (%d,%d,1)", GetPlayerAccountID(playerid), GetPlayerSkinEx(playerid));
        mysql_query(mysql, query, false);

        if(mysql_errno()) return SCM(playerid, -1, "CheckSkinPlayer | SQL ERROR 1");

        ShowNotification(playerid, 3, "Одежда добавлена в инвентарь", 5, "", "");
        return 1;
    }

    return 0;
}

stock GivePlayerOwnableSkin(playerid, skinid)
{
    new query[144];

    mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id,use_skin) VALUES (%d,%d,0)", GetPlayerAccountID(playerid), skinid);
    mysql_query(mysql, query, false);

    if(mysql_errno()) return SCM(playerid, -1, "GivePlayerOwnableSkin | SQL ERROR");

    ShowNotification(playerid, 3, "Одежда добавлена в инвентарь", 5, "", "");
    return 1;
}

stock ShowOwnableSkinLoadDialog(playerid, id)
{
    SetPVarInt(playerid, "ownableskin_id", id);

    Dialog
    (
        playerid, DIALOG_INV_SKIN_ACTION, DIALOG_STYLE_TABLIST_HEADERS,
        "{FA8072}Инвентарь {FFFFFF}| Выберите действие для взаимодействия со скином",
        "№\tДействие\tОписание кнопки\n"\
        "{FA8072}1.\t{FFFFFF}Использовать\t{DCDCDC}Надеть этот скин на персонажа\n"\
        "{FA8072}2.\t{FFFFFF}Удалить\t{DCDCDC}Удалить скин из инвентаря",
        "Выбрать", "Закрыть"
    );
    return 1;
}

stock Inv_HandleDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_INV_MAIN:
        {
            if(!response) return 1;

            switch(listitem)
            {
                case 0: return myskins(playerid);
                case 1: return callcmd::myacs(playerid);
                case 2: return ShowPlayerNumberResources(playerid);
            }
            return 1;
        }
        case DIALOG_INV_SKINS:
        {
            if(!response) return 1;

            new id = GetPlayerListitemValue(playerid, listitem);
            if(id <= 0) return SendClientMessage(playerid, -1, "Скин не найден");

            return ShowOwnableSkinLoadDialog(playerid, id);
        }
        case DIALOG_INV_SKIN_ACTION:
        {
            if(!response) return 1;

            new id = GetPVarInt(playerid, "ownableskin_id");
            if(id <= 0) return SendClientMessage(playerid, -1, "Скин не найден");

            new query[196], Cache: result;

            mysql_format(mysql, query, sizeof query, "SELECT skin_id, use_skin FROM inventory_skins WHERE id=%d LIMIT 1", id);
            result = mysql_query(mysql, query, true);

            if(!cache_num_rows())
            {
                cache_delete(result);
                return SendClientMessage(playerid, -1, "Этот скин больше не существует");
            }

            new skin_id = cache_get_field_content_int(0, "skin_id");
            cache_delete(result);

            switch(listitem)
            {
                case 0:
                {
                    mysql_format(mysql, query, sizeof query, "UPDATE inventory_skins SET use_skin=0 WHERE owner_skin=%d", GetPlayerAccountID(playerid));
                    mysql_query(mysql, query, false);

                    mysql_format(mysql, query, sizeof query, "UPDATE inventory_skins SET use_skin=1 WHERE id=%d", id);
                    mysql_query(mysql, query, false);

                    SetPlayerData(playerid, P_SKIN, skin_id);
                    UpdatePlayerDatabaseInt(playerid, "skin", skin_id);
                    SetPlayerSkinInit(playerid);

                    ShowNotification(playerid, 3, "Вы надели скин из инвентаря", 5, "", "");
                }
                case 1:
                {
                    mysql_format(mysql, query, sizeof query, "DELETE FROM inventory_skins WHERE id=%d LIMIT 1", id);
                    mysql_query(mysql, query, false);
                    ShowNotification(playerid, 3, "Скин удален из инвентаря", 5, "", "");
                }
            }

            DeletePVar(playerid, "ownableskin_id");
            return myskins(playerid);
        }
        case DIALOG_INV_RESOURCES:
        {
            if(!response) return 1;

            new slot = GetPlayerListitemValue(playerid, listitem);
            if(!(0 <= slot < g_player_number_resource_count[playerid])) return SendClientMessage(playerid, -1, "Номерной знак не найден");

            SetPVarInt(playerid, "number_resource_slot", slot);
            return Dialog
            (
                playerid, DIALOG_INV_RESOURCE_ACT, DIALOG_STYLE_TABLIST_HEADERS,
                "{FA8072}Инвентарь {FFFFFF}| Действие с номерным знаком",
                "№\tДействие\tОписание действия\n"\
                "{FA8072}1.\t{FFFFFF}Установить\tУстановить номерной знак на личное авто",
                "Выбрать", "Закрыть"
            );
        }
        case DIALOG_INV_RESOURCE_ACT:
        {
            if(!response) return 1;

            new slot = GetPVarInt(playerid, "number_resource_slot");
            if(!(0 <= slot < g_player_number_resource_count[playerid])) return SendClientMessage(playerid, -1, "Номерной знак не найден");

            switch(listitem)
            {
                case 0: return ApplyPlayerNumberResource(playerid, slot);
            }
            return 1;
        }
        case DIALOG_BUY_NUMBER_MAIN:
        {
            if(!response) return 1;

            switch(listitem)
            {
                case 0: return BuyPlayerRandomNumberResource(playerid);
                case 1: return Dialog(playerid, DIALOG_BUY_NUMBER_INPUT, DIALOG_STYLE_INPUT, "{FF5A5A}Покупка номера", "{FFFFFF}Введите желаемый номер в формате {FFCC00}A123BC", "Продолжить", "Назад");
            }
            return 1;
        }
        case DIALOG_BUY_NUMBER_INPUT:
        {
            if(!response) return ShowPlayerBuyNumberMainDialog(playerid);

            if(!IsACarNumber(inputtext)) return ShowNotification(playerid, 2, "Указанный номер не соответствует формату A123BC", 4, "", "");
            return BuyPlayerCustomNumberResource(playerid, inputtext);
        }
    }

    return 0;
}
