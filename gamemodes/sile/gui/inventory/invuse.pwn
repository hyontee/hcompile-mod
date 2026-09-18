// Максимальное количество слотов в шкафу
#define MAX_USE_SLOTS 80
#define MAX_USE_STORAGE 2000

enum E_USE_STRUCT
{
    use_itemId,
    use_itemCount,
    use_itemSlot,
    use_itemPlate[32],
    use_itemType
}

// Новый массив для шкафов, индексируемый по SQL ID
new g_use_storage[MAX_USE_STORAGE][MAX_USE_SLOTS][E_USE_STRUCT];
new g_use_storage_loaded[MAX_USE_STORAGE]; // Хранит SQL ID дома для каждого индекса
new g_use_storage_count = 0;

// Получение индекса в массиве g_use_storage по SQL ID дома
stock Use_GetStorageIndex(house_sql_id)
{
    // Сначала ищем существующий
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            return i;
        }
    }
    
    // Если не нашли, создаём новый
    if(g_use_storage_count < MAX_USE_STORAGE)
    {
        new index = g_use_storage_count;
        g_use_storage_loaded[index] = house_sql_id;
        g_use_storage_count++;
        return index;
    }
    
    printf("[Use_GetStorageIndex] Нет места для дома с SQL ID %d (лимит: %d)", house_sql_id, MAX_USE_STORAGE);
    return -1;
}

// Загрузка шкафа из БД
stock Use_Load(house_sql_id)
{
    new storage_index = Use_GetStorageIndex(house_sql_id);
    if(storage_index == -1)
    {
        printf("[Use_Load] Не удалось получить индекс для SQL ID %d", house_sql_id);
        return 0;
    }
    
    // Очищаем данные шкафа для этого дома
    for(new i = 0; i < MAX_USE_SLOTS; i++)
    {
        g_use_storage[storage_index][i][use_itemId] = 0;
        g_use_storage[storage_index][i][use_itemCount] = 0;
        g_use_storage[storage_index][i][use_itemSlot] = i;
        g_use_storage[storage_index][i][use_itemPlate][0] = 0;
        g_use_storage[storage_index][i][use_itemType] = 0;
    }
    
    new query[256];
    new Cache:result;
    new rows;
    
    mysql_format(mysql, query, sizeof(query), 
        "SELECT * FROM house_storage WHERE house_id = %d ORDER BY slot ASC", house_sql_id);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    
    for(new i = 0; i < rows && i < MAX_USE_SLOTS; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        if(slot >= 0 && slot < MAX_USE_SLOTS)
        {
            g_use_storage[storage_index][slot][use_itemId] = cache_get_field_content_int(i, "item_id");
            g_use_storage[storage_index][slot][use_itemCount] = cache_get_field_content_int(i, "amount");
            g_use_storage[storage_index][slot][use_itemSlot] = slot;
            g_use_storage[storage_index][slot][use_itemType] = cache_get_field_content_int(i, "item_type");
            cache_get_field_content(i, "item_plate", g_use_storage[storage_index][slot][use_itemPlate], 32);
        }
    }
    
    cache_delete(result);
    return 1;
}

// Сохранение шкафа в БД
stock Use_Save(house_sql_id)
{
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1) return 0;
    
    new query[256];
    new Cache:result;
    new rows;
    
    for(new i = 0; i < MAX_USE_SLOTS; i++)
    {
        if(g_use_storage[storage_index][i][use_itemId] > 0)
        {
            mysql_format(mysql, query, sizeof(query), 
                "SELECT id FROM house_storage WHERE house_id = %d AND slot = %d LIMIT 1", 
                house_sql_id, i);
            result = mysql_query(mysql, query, true);
            rows = cache_num_rows();
            
            if(rows > 0)
            {
                mysql_format(mysql, query, sizeof(query),
                    "UPDATE house_storage SET item_id = %d, amount = %d, item_type = %d, item_plate = '%e' WHERE house_id = %d AND slot = %d",
                    g_use_storage[storage_index][i][use_itemId],
                    g_use_storage[storage_index][i][use_itemCount],
                    g_use_storage[storage_index][i][use_itemType],
                    g_use_storage[storage_index][i][use_itemPlate],
                    house_sql_id, i);
                mysql_query(mysql, query, false);
            }
            else
            {
                mysql_format(mysql, query, sizeof(query),
                    "INSERT INTO house_storage (house_id, slot, item_id, amount, item_type, item_plate) VALUES (%d, %d, %d, %d, %d, '%e')",
                    house_sql_id, i,
                    g_use_storage[storage_index][i][use_itemId],
                    g_use_storage[storage_index][i][use_itemCount],
                    g_use_storage[storage_index][i][use_itemType],
                    g_use_storage[storage_index][i][use_itemPlate]);
                mysql_query(mysql, query, false);
            }
            
            cache_delete(result);
        }
        else
        {
            mysql_format(mysql, query, sizeof(query), 
                "DELETE FROM house_storage WHERE house_id = %d AND slot = %d", 
                house_sql_id, i);
            mysql_query(mysql, query, false);
        }
    }
    return 1;
}

// Добавление предмета в шкаф
stock Use_AddItem(house_sql_id, slot, item_id, count, const plate[] = "")
{
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1) return 0;
    
    if(slot < 0 || slot >= MAX_USE_SLOTS) return 0;
    
    // Проверяем, есть ли уже такой предмет в шкафу
    for(new i = 0; i < MAX_USE_SLOTS; i++)
    {
        if(g_use_storage[storage_index][i][use_itemId] == item_id)
        {
            new new_count = g_use_storage[storage_index][i][use_itemCount] + count;
            g_use_storage[storage_index][i][use_itemCount] = new_count;
            
            new query[256];
            mysql_format(mysql, query, sizeof(query),
                "UPDATE house_storage SET amount = %d WHERE house_id = %d AND slot = %d",
                new_count, house_sql_id, i);
            mysql_query(mysql, query, false);
            return 1;
        }
    }
    
    g_use_storage[storage_index][slot][use_itemId] = item_id;
    g_use_storage[storage_index][slot][use_itemCount] = count;
    g_use_storage[storage_index][slot][use_itemSlot] = slot;
    g_use_storage[storage_index][slot][use_itemType] = GetItemType(item_id);
    
    if(strlen(plate) > 0)
        format(g_use_storage[storage_index][slot][use_itemPlate], 32, plate);
    
    return 1;
}

// Удаление одного предмета из шкафа
stock Use_RemoveOneItem(house_sql_id, slot)
{
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1) return 0;
    
    if(slot < 0 || slot >= MAX_USE_SLOTS) return 0;
    if(g_use_storage[storage_index][slot][use_itemId] == 0) return 0;
    
    new current_count = g_use_storage[storage_index][slot][use_itemCount];
    
    if(current_count <= 1)
    {
        g_use_storage[storage_index][slot][use_itemId] = 0;
        g_use_storage[storage_index][slot][use_itemCount] = 0;
        g_use_storage[storage_index][slot][use_itemSlot] = slot;
        g_use_storage[storage_index][slot][use_itemPlate][0] = 0;
        g_use_storage[storage_index][slot][use_itemType] = 0;
        
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "DELETE FROM house_storage WHERE house_id = %d AND slot = %d",
            house_sql_id, slot);
        mysql_query(mysql, query, false);
    }
    else
    {
        new new_count = current_count - 1;
        g_use_storage[storage_index][slot][use_itemCount] = new_count;
        
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "UPDATE house_storage SET amount = %d WHERE house_id = %d AND slot = %d",
            new_count, house_sql_id, slot);
        mysql_query(mysql, query, false);
    }
    
    return 1;
}

// Удаление нескольких предметов
stock Use_RemoveItem(house_sql_id, slot, count)
{
    for(new i = 0; i < count; i++)
    {
        if(!Use_RemoveOneItem(house_sql_id, slot))
            return 0;
    }
    return 1;
}

// Полное удаление предмета
stock Use_DeleteItemCompletely(house_sql_id, slot)
{
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1) return 0;
    
    if(slot < 0 || slot >= MAX_USE_SLOTS) return 0;
    if(g_use_storage[storage_index][slot][use_itemId] == 0) return 0;
    
    g_use_storage[storage_index][slot][use_itemId] = 0;
    g_use_storage[storage_index][slot][use_itemCount] = 0;
    g_use_storage[storage_index][slot][use_itemSlot] = slot;
    g_use_storage[storage_index][slot][use_itemPlate][0] = 0;
    g_use_storage[storage_index][slot][use_itemType] = 0;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM house_storage WHERE house_id = %d AND slot = %d",
        house_sql_id, slot);
    mysql_query(mysql, query, false);
    
    return 1;
}

// Поиск свободного слота
stock Use_GetFreeSlot(house_sql_id)
{
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1) return -1;
    
    for(new i = 0; i < MAX_USE_SLOTS; i++)
    {
        if(g_use_storage[storage_index][i][use_itemId] == 0)
        {
            return i;
        }
    }
    return -1;
}

// Очистка всех данных шкафа
stock Use_Reset(house_sql_id)
{
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1) return 0;
    
    for(new i = 0; i < MAX_USE_SLOTS; i++)
    {
        g_use_storage[storage_index][i][use_itemId] = 0;
        g_use_storage[storage_index][i][use_itemCount] = 0;
        g_use_storage[storage_index][i][use_itemSlot] = i;
        g_use_storage[storage_index][i][use_itemType] = 0;
        g_use_storage[storage_index][i][use_itemPlate][0] = 0;
    }
    return 1;
}

// Показать GUI шкафа
stock ShowPlayerUseGUI(playerid, house_sql_id)
{
    SetPVarInt(playerid, "use_house_id", house_sql_id);
    
    new Node:json = JSON_Object(), 
        Node:tempArray, 
        Node:itemsArray = JSON_Array(), 
        Node:activeSlotsArray = JSON_Array(), 
        Node:storageSlotsArray = JSON_Array();
    
    // Инвентарь игрока
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerInventory[playerid][i][inv_itemId];
            
            if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_String(g_PlayerInventory[playerid][i][inv_itemPlate]),
                    JSON_Int(i),
                    JSON_Int(3)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]), 
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            itemsArray = JSON_Append(itemsArray, tempArray);
        }
    }
    
    // Активные слоты игрока
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerActiveSlots[playerid][i][inv_itemId];
            new itemCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
            
            if(itemId == 134)
            {
                tempArray = JSON_Array(
                    JSON_Int(134),
                    JSON_Int(GetPlayerSkin(playerid)),
                    JSON_Int(6),
                    JSON_Int(1)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(itemCount),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            if(strlen(g_PlayerActiveSlots[playerid][i][inv_itemPlate]) > 0)
            {
                JSON_SetString(tempArray, "nt", g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
            }
            
            activeSlotsArray = JSON_Append(activeSlotsArray, tempArray);
        }
    }
    
    // Шкаф (хранилище дома) - ищем по SQL ID
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == house_sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index != -1)
    {
        for(new i = 0; i < MAX_USE_SLOTS; i++)
        {
            if(g_use_storage[storage_index][i][use_itemId] > 0)
            {
                new itemId = g_use_storage[storage_index][i][use_itemId];
                
                if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
                {
                    tempArray = JSON_Array(
                        JSON_Int(itemId),
                        JSON_String(g_use_storage[storage_index][i][use_itemPlate]),
                        JSON_Int(i),
                        JSON_Int(3)
                    );
                }
                else
                {
                    tempArray = JSON_Array(
                        JSON_Int(itemId),
                        JSON_Int(g_use_storage[storage_index][i][use_itemCount]),
                        JSON_Int(i),
                        JSON_Int(0)
                    );
                }
                
                storageSlotsArray = JSON_Append(storageSlotsArray, tempArray);
            }
        }
    }
    
    json = JSON_Object
    (
        "o", JSON_Int(1),
        "tb", JSON_Int(1),
        "w", JSON_Int(0),
        "mw", JSON_Int(150),
        "bw", JSON_Int(0),
        "cw", JSON_Int(1500),
        "sl", JSON_Int(40),
        "nm", JSON_Int(GetPlayerPhone(playerid)), 
        "it", itemsArray,
        "sb", JSON_Int(80),
        "ai", activeSlotsArray, 
        "ic", storageSlotsArray
    );
    
    SetPVarInt(playerid, "typeinv", 2);
    SendPacketToClient(playerid, 34, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:usegui(playerid, params[])
{
    new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);

    if(house_id == -1) 
        return SendClientMessage(playerid, 0x999999FF, "Функция доступна только владельцам недвижимости");

    if(GetPlayerInHouse(playerid) != house_id) 
        return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в своём доме");

    if(GetHouseData(house_id, H_IMPROVEMENTS) < 5) 
        return SendClientMessage(playerid, 0x999999FF, "Необходим 5 уровень улучшений для дома");

    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GetHouseData(house_id, H_STORE_X), GetHouseData(house_id, H_STORE_Y), GetHouseData(house_id, H_STORE_Z)))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у своего шкафа");
    
    new sql_id = GetHouseData(house_id, H_SQL_ID);
    
    // Убеждаемся, что данные шкафа загружены
    new storage_index = -1;
    for(new i = 0; i < g_use_storage_count; i++)
    {
        if(g_use_storage_loaded[i] == sql_id)
        {
            storage_index = i;
            break;
        }
    }
    
    if(storage_index == -1)
    {
        // Если шкаф ещё не загружен, загружаем его
        Use_Load(sql_id);
    }
    
    ShowPlayerUseGUI(playerid, sql_id);
    
    return 1;
}

// Админская команда для добавления предметов в шкаф
CMD:giveuse(playerid, params[])
{
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) 
        return ShowNotificationSile(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");
    
    new house_sql_id, item_id, count, slot;
    
    if(sscanf(params, "iii", house_sql_id, item_id, count))
    {
        SendClientMessage(playerid, -1, "Использование: /giveuse [house_sql_id] [item_id] [count]");
        return 1;
    }
    
    if(item_id <= 0 || count <= 0 || count > 1000)
    {
        SendClientMessage(playerid, -1, "Неверный ID предмета или количество (1-1000)");
        return 1;
    }
    
    slot = Use_GetFreeSlot(house_sql_id);
    if(slot == -1)
    {
        SendClientMessage(playerid, -1, "Шкаф полон!");
        return 1;
    }
    
    Use_AddItem(house_sql_id, slot, item_id, count, "");
    Use_Save(house_sql_id);
    
    new msg[128];
    format(msg, sizeof(msg), "Вы выдали в шкаф (house_id: %d) предмет %d в количестве %d шт. (слот %d)", 
        house_sql_id, item_id, count, slot);
    SendClientMessage(playerid, -1, msg);
    
    return 1;
}

// Обработчик пакета для шкафа
stock PacketIncomingUse(playerid, Node:JSONObject)
{
    new Node:response = JSON_Object();
    new type, item_id, count, old_pos, pos, item_plate[32];
    
    JSON_GetInt(JSONObject, "t", type);
    
    switch(type)
    {
        case 0: // Из инвентаря в шкаф
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "os", old_pos);
            JSON_GetInt(JSONObject, "ns", pos);
            JSON_GetInt(JSONObject, "v", count);
            
            new house_sql_id = GetPVarInt(playerid, "use_house_id");
            new debug_msg[256];
            
            if(house_sql_id == 0)
            {
                ShowNotificationSile(playerid, 2, 6, -1, -1, "Ошибка: ID дома не найден", "");
                JSON_SetInt(response, "t", 0);
                JSON_SetInt(response, "s", 0);
                SendPacketToClient(playerid, 34, response);
                JSON_Cleanup(response);
                return 1;
            }
            
            if(item_id == 134) // Скин
            {
                new skin_model = g_PlayerInventory[playerid][old_pos][inv_itemCount];
                
                if(!IsValidSkinModel(skin_model))
                {
                    format(debug_msg, sizeof(debug_msg), "Ошибка: Невалидный скин (model: %d, слот: %d)", skin_model, old_pos);
                    ShowNotificationSile(playerid, 2, 6, -1, -1, debug_msg, "");
                    JSON_SetInt(response, "t", 0);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 34, response);
                    JSON_Cleanup(response);
                    return 1;
                }
                
                Use_AddItem(house_sql_id, pos, 134, skin_model, "");
                Inventory_DeleteItemCompletely(playerid, old_pos);
                Use_Save(house_sql_id);
            }
            else if(item_id == 58) // SIM-карта
            {
                if(g_PlayerInventory[playerid][old_pos][inv_itemId] != item_id)
                {
                    format(debug_msg, sizeof(debug_msg), "Ошибка: Предмет не в слоте (ожидался %d, слот %d)", item_id, old_pos);
                    ShowNotificationSile(playerid, 2, 6, -1, -1, debug_msg, "");
                    JSON_SetInt(response, "t", 0);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 34, response);
                    JSON_Cleanup(response);
                    return 1;
                }
                
                new phone_number = g_PlayerInventory[playerid][old_pos][inv_itemCount];
                Inventory_DeleteItemCompletely(playerid, old_pos);
                Use_AddItem(house_sql_id, pos, item_id, phone_number, "");
                Use_Save(house_sql_id);
            }
            else if(item_id == 59 || item_id == 83) // Номера с регионом
            {
                new fmtn[32];
                format(fmtn, sizeof(fmtn), "%s", g_PlayerInventory[playerid][old_pos][inv_itemPlate]);
                Use_AddItem(house_sql_id, pos, item_id, 1, fmtn);
                Inventory_DeleteItemCompletely(playerid, old_pos);
                Use_Save(house_sql_id);
            }
            else if(item_id == 81 || item_id == 82) // Номера без региона
            {
                new fmtn[32];
                format(fmtn, sizeof(fmtn), "%s", g_PlayerInventory[playerid][old_pos][inv_itemPlate]);
                Use_AddItem(house_sql_id, pos, item_id, 1, fmtn);
                Inventory_DeleteItemCompletely(playerid, old_pos);
                Use_Save(house_sql_id);
            }
            else // Обычные предметы
            {
                if(g_PlayerInventory[playerid][old_pos][inv_itemId] != item_id)
                {
                    format(debug_msg, sizeof(debug_msg), "Ошибка: ID предмета не совпадает (ожидался %d, в слоте %d)", item_id, old_pos);
                    ShowNotificationSile(playerid, 2, 6, -1, -1, debug_msg, "");
                    JSON_SetInt(response, "t", 0);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 34, response);
                    JSON_Cleanup(response);
                    return 1;
                }
                
                if(g_PlayerInventory[playerid][old_pos][inv_itemCount] < count)
                {
                    format(debug_msg, sizeof(debug_msg), "Ошибка: Недостаточно предметов (нужно %d, есть %d, ID: %d)", count, g_PlayerInventory[playerid][old_pos][inv_itemCount], item_id);
                    ShowNotificationSile(playerid, 2, 6, -1, -1, debug_msg, "");
                    JSON_SetInt(response, "t", 0);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 34, response);
                    JSON_Cleanup(response);
                    return 1;
                }
                
                format(item_plate, 32, g_PlayerInventory[playerid][old_pos][inv_itemPlate]);
                
                if(count == 1)
                    Inventory_RemoveOneItem(playerid, old_pos);
                else
                    Inventory_RemoveItem(playerid, old_pos, count);
                
                Use_AddItem(house_sql_id, pos, item_id, count, item_plate);
                Use_Save(house_sql_id);
            }
            
            JSON_SetInt(response, "t", 0);
            JSON_SetInt(response, "s", 1);
            SendPacketToClient(playerid, 34, response);
            JSON_Cleanup(response);
        }
        
        case 1: // Из шкафа в инвентарь
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "os", old_pos);
            JSON_GetInt(JSONObject, "ns", pos);
            JSON_GetInt(JSONObject, "v", count);
            
            new house_sql_id = GetPVarInt(playerid, "use_house_id");
            new debug_msg[256];
            
            if(house_sql_id == 0)
            {
                ShowNotificationSile(playerid, 2, 6, -1, -1, "Ошибка: ID дома не найден", "");
                JSON_SetInt(response, "t", 1);
                JSON_SetInt(response, "s", 0);
                SendPacketToClient(playerid, 34, response);
                JSON_Cleanup(response);
                return 1;
            }
            
            // Получаем индекс хранилища
            new storage_index = -1;
            for(new i = 0; i < g_use_storage_count; i++)
            {
                if(g_use_storage_loaded[i] == house_sql_id)
                {
                    storage_index = i;
                    break;
                }
            }
            
            if(storage_index == -1)
            {
                ShowNotificationSile(playerid, 2, 6, -1, -1, "Ошибка: Шкаф не найден", "");
                JSON_SetInt(response, "t", 1);
                JSON_SetInt(response, "s", 0);
                SendPacketToClient(playerid, 34, response);
                JSON_Cleanup(response);
                return 1;
            }
            
            if(g_use_storage[storage_index][old_pos][use_itemId] != item_id)
            {
                format(debug_msg, sizeof(debug_msg), "Ошибка: ID не совпадает (ожидался %d, в шкафу %d, слот %d)", 
                    item_id, g_use_storage[storage_index][old_pos][use_itemId], old_pos);
                ShowNotificationSile(playerid, 2, 6, -1, -1, debug_msg, "");
                JSON_SetInt(response, "t", 1);
                JSON_SetInt(response, "s", 0);
                SendPacketToClient(playerid, 34, response);
                JSON_Cleanup(response);
                return 1;
            }
            
            if(item_id == 134) // Скин
            {
                new skin_model = g_use_storage[storage_index][old_pos][use_itemCount];
                
                // Проверяем лимит скинов в инвентаре
                new skin_count = 0;
                for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
                {
                    if(g_PlayerInventory[playerid][i][inv_itemId] == 134)
                        skin_count++;
                }
                
                if(skin_count >= 3)
                {
                    ShowNotificationSile(playerid, 2, 6, -1, -1, "Нельзя иметь больше 3 скинов в инвентаре", "");
                    JSON_SetInt(response, "t", 1);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 34, response);
                    JSON_Cleanup(response);
                    return 1;
                }
                
                Use_DeleteItemCompletely(house_sql_id, old_pos);
                Inventory_AddItem(playerid, 134, pos, skin_model, "");
                Use_Save(house_sql_id);
            }
            else if(item_id == 58) // SIM-карта
            {
                new phone_number = g_use_storage[storage_index][old_pos][use_itemCount];
                Use_DeleteItemCompletely(house_sql_id, old_pos);
                Inventory_AddItem(playerid, item_id, pos, phone_number, "");
                Use_Save(house_sql_id);
            }
            else if(item_id == 59 || item_id == 83) // Номера с регионом
            {
                new fmtn[32];
                format(fmtn, sizeof(fmtn), "%s", g_use_storage[storage_index][old_pos][use_itemPlate]);
                Use_DeleteItemCompletely(house_sql_id, old_pos);
                Inventory_AddItem(playerid, item_id, pos, 1, fmtn);
                Use_Save(house_sql_id);
            }
            else if(item_id == 81 || item_id == 82) // Номера без региона
            {
                new fmtn[32];
                format(fmtn, sizeof(fmtn), "%s", g_use_storage[storage_index][old_pos][use_itemPlate]);
                Use_DeleteItemCompletely(house_sql_id, old_pos);
                Inventory_AddItem(playerid, item_id, pos, 1, fmtn);
                Use_Save(house_sql_id);
            }
            else // Обычные предметы
            {
                // Проверка лимитов
                new current_count = 0;
                new max_limit = 0;
                
                switch(item_id)
                {
                    case 21: max_limit = 1;
                    case 22: max_limit = 5;
                    case 23: max_limit = 3;
                    case 116: max_limit = 3;
                    default: max_limit = 999;
                }
                
                for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
                {
                    if(g_PlayerInventory[playerid][i][inv_itemId] == item_id)
                    {
                        current_count += g_PlayerInventory[playerid][i][inv_itemCount];
                    }
                }
                
                if(max_limit != 999 && current_count + count > max_limit)
                {
                    format(debug_msg, sizeof(debug_msg), "Ошибка: Лимит предмета (ID: %d, макс: %d, текущий: %d, попытка: %d)", 
                        item_id, max_limit, current_count, count);
                    ShowNotificationSile(playerid, 2, 6, -1, -1, debug_msg, "");
                    JSON_SetInt(response, "t", 1);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 34, response);
                    JSON_Cleanup(response);
                    return 1;
                }
                
                // Проверяем, есть ли такой предмет в инвентаре
                new found_slot = -1;
                for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
                {
                    if(g_PlayerInventory[playerid][i][inv_itemId] == item_id)
                    {
                        found_slot = i;
                        break;
                    }
                }
                
                Use_RemoveItem(house_sql_id, old_pos, count);
                
                if(found_slot != -1)
                {
                    new new_count = g_PlayerInventory[playerid][found_slot][inv_itemCount] + count;
                    g_PlayerInventory[playerid][found_slot][inv_itemCount] = new_count;
                    
                    new query[256];
                    mysql_format(mysql, query, sizeof(query),
                        "UPDATE player_inventory SET item_count = %d WHERE player_id = %d AND slot = %d AND is_active = 0",
                        new_count, GetPlayerAccountID(playerid), found_slot);
                    mysql_query(mysql, query, false);
                }
                else
                {
                    Inventory_AddItem(playerid, item_id, pos, count, "");
                }
                
                Use_Save(house_sql_id);
            }
            
            JSON_SetInt(response, "t", 1);
            JSON_SetInt(response, "s", 1);
            SendPacketToClient(playerid, 34, response);
            JSON_Cleanup(response);
        }
        
        case 8: // Закрыть
        {
            DeletePVar(playerid, "use_house_id");
            SetPVarInt(playerid, "typeinv", 0);
            ShowNotificationSile(playerid, 2, 4, -1, -1, "Шкаф закрыт", "");
            
            JSON_SetInt(response, "t", 8);
            JSON_SetInt(response, "s", 1);
            SendPacketToClient(playerid, 34, response);
            JSON_Cleanup(response);
        }
    }
    
    return 1;
}