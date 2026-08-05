// ==========================================
// СИСТЕМА ПОДЪЕЗДОВ И КВАРТИР
// ==========================================

#define MAX_ENTRANCE_FLATS      (200) // максимальное кол-во квартир в подъездах
#define MAX_ENTRANCE_FLATS_PER_ENTRANCE (4) // кол-во квартир на один подъезд

enum E_ENTRANCE_FLAT_STRUCT
{
    EF_SQL_ID,
    EF_ENTRANCE_ID,
    EF_FLAT_NUMBER,
    EF_OWNER_ID,
    EF_OWNER_NAME[24],
    EF_RENT_DATE,
    EF_RENT_PRICE,
    EF_LOCK_STATUS,
    Float: EF_POS_X,
    Float: EF_POS_Y,
    Float: EF_POS_Z,
    Float: EF_EXIT_POS_X,
    Float: EF_EXIT_POS_Y,
    Float: EF_EXIT_POS_Z,
    Float: EF_EXIT_ANGLE,
    EF_PICKUP_ID,
    EF_MAP_ICON,
    Text3D: EF_LABEL,
    EF_INTERIOR,
    EF_VIRTUAL_WORLD
};

new g_entrance_flat[MAX_ENTRANCE_FLATS][E_ENTRANCE_FLAT_STRUCT];
new g_entrance_flat_loaded;

// Позиции квартир (уже есть в коде)
new const Float: g_entrance_flat_pos[4][6] =
{
    { // 1 квартира
        553.0098, 25.2907, 1049.2656,
        558.6488, 25.2916, 180.0
    },
    { // 2 квартира
        554.5970, 26.6261, 1049.2656,
        558.6488, 25.2916, 180.0
    },
    { // 3 квартира
        565.1951, 26.6265, 1049.2656,
        558.6488, 25.2916, 180.0
    },
    { // 4 квартира
        567.2014, 25.2727, 1049.2656,
        558.6488, 25.2916, 180.0
    }
};

// Создание пикапов для квартир
stock CreateEntranceFlatPickup(flat_id)
{
    if(flat_id < 0 || flat_id >= MAX_ENTRANCE_FLATS) return 0;
    
    DestroyPickup(g_entrance_flat[flat_id][EF_PICKUP_ID]);
    
    g_entrance_flat[flat_id][EF_PICKUP_ID] = CreatePickup(
        1273, // иконка двери
        23,
        g_entrance_flat[flat_id][EF_POS_X],
        g_entrance_flat[flat_id][EF_POS_Y],
        g_entrance_flat[flat_id][EF_POS_Z],
        -1,
        PICKUP_ACTION_TYPE_ENTRANCE_FLAT,
        flat_id
    );
    
    // Создание 3D текста
    if(g_entrance_flat[flat_id][EF_LABEL] != Text3D:-1)
        DestroyDynamic3DTextLabel(g_entrance_flat[flat_id][EF_LABEL]);
    
    new label_text[128];
    if(g_entrance_flat[flat_id][EF_OWNER_ID] > 0)
        format(label_text, sizeof(label_text), "{FFFFFF}Квартира №%d\n{FFD700}Владелец: %s", 
            g_entrance_flat[flat_id][EF_FLAT_NUMBER],
            g_entrance_flat[flat_id][EF_OWNER_NAME]);
    else
        format(label_text, sizeof(label_text), "{FFFFFF}Квартира №%d\n{FF0000}Свободна", 
            g_entrance_flat[flat_id][EF_FLAT_NUMBER]);
    
    g_entrance_flat[flat_id][EF_LABEL] = CreateDynamic3DTextLabel(
        label_text,
        0xFFFFFFFF,
        g_entrance_flat[flat_id][EF_POS_X],
        g_entrance_flat[flat_id][EF_POS_Y],
        g_entrance_flat[flat_id][EF_POS_Z] + 0.5,
        15.0
    );
    
    return 1;
}

// Создание всех квартир для подъезда
stock CreateEntranceFlats(entrance_id, Float: entrance_x, Float: entrance_y, Float: entrance_z, entrance_interior, entrance_vw)
{
    new flat_id = g_entrance_flat_loaded;
    
    for(new i = 0; i < MAX_ENTRANCE_FLATS_PER_ENTRANCE && flat_id < MAX_ENTRANCE_FLATS; i++)
    {
        SetEntranceFlatData(flat_id, EF_SQL_ID, 0);
        SetEntranceFlatData(flat_id, EF_ENTRANCE_ID, entrance_id);
        SetEntranceFlatData(flat_id, EF_FLAT_NUMBER, i + 1);
        SetEntranceFlatData(flat_id, EF_OWNER_ID, 0);
        SetEntranceFlatData(flat_id, EF_OWNER_NAME, "Nobody");
        SetEntranceFlatData(flat_id, EF_RENT_DATE, 0);
        SetEntranceFlatData(flat_id, EF_RENT_PRICE, 500);
        SetEntranceFlatData(flat_id, EF_LOCK_STATUS, 0);
        
        // Позиция входа в квартиру (у подъезда)
        SetEntranceFlatData(flat_id, EF_POS_X, entrance_x + float(i * 2));
        SetEntranceFlatData(flat_id, EF_POS_Y, entrance_y);
        SetEntranceFlatData(flat_id, EF_POS_Z, entrance_z);
        
        // Позиция выхода из квартиры (внутри)
        SetEntranceFlatData(flat_id, EF_EXIT_POS_X, g_entrance_flat_pos[i][0]);
        SetEntranceFlatData(flat_id, EF_EXIT_POS_Y, g_entrance_flat_pos[i][1]);
        SetEntranceFlatData(flat_id, EF_EXIT_POS_Z, g_entrance_flat_pos[i][2]);
        SetEntranceFlatData(flat_id, EF_EXIT_ANGLE, g_entrance_flat_pos[i][3]);
        
        SetEntranceFlatData(flat_id, EF_INTERIOR, entrance_interior);
        SetEntranceFlatData(flat_id, EF_VIRTUAL_WORLD, entrance_vw);
        SetEntranceFlatData(flat_id, EF_PICKUP_ID, -1);
        SetEntranceFlatData(flat_id, EF_LABEL, Text3D:-1);
        
        CreateEntranceFlatPickup(flat_id);
        
        g_entrance_flat_loaded++;
        flat_id++;
    }
    
    return 1;
}

// Вход в квартиру
stock EnterFlat(playerid, flat_id)
{
    if(flat_id < 0 || flat_id >= MAX_ENTRANCE_FLATS) return 0;
    
    new Float: x = GetEntranceFlatData(flat_id, EF_EXIT_POS_X);
    new Float: y = GetEntranceFlatData(flat_id, EF_EXIT_POS_Y);
    new Float: z = GetEntranceFlatData(flat_id, EF_EXIT_POS_Z);
    new Float: angle = GetEntranceFlatData(flat_id, EF_EXIT_ANGLE);
    new interior = GetEntranceFlatData(flat_id, EF_INTERIOR);
    new vw = GetEntranceFlatData(flat_id, EF_VIRTUAL_WORLD);
    
    SetPlayerPosEx(playerid, x, y, z, angle, interior, vw);
    SetPlayerData(playerid, P_IN_FLAT, flat_id);
    
    new msg[128];
    format(msg, sizeof(msg), "{FFFFFF}Вы вошли в квартиру №%d", GetEntranceFlatData(flat_id, EF_FLAT_NUMBER));
    SendClientMessage(playerid, -1, msg);
    
    return 1;
}

// Выход из квартиры
stock ExitFlat(playerid)
{
    new flat_id = GetPlayerData(playerid, P_IN_FLAT);
    if(flat_id < 0 || flat_id >= MAX_ENTRANCE_FLATS) return 0;
    
    new Float: x = GetEntranceFlatData(flat_id, EF_POS_X);
    new Float: y = GetEntranceFlatData(flat_id, EF_POS_Y);
    new Float: z = GetEntranceFlatData(flat_id, EF_POS_Z);
    
    SetPlayerPosEx(playerid, x, y, z, 0.0, 0, 0);
    SetPlayerData(playerid, P_IN_FLAT, -1);
    
    SendClientMessage(playerid, -1, "{FFFFFF}Вы вышли из квартиры");
    
    return 1;
}

// Аренда квартиры
stock RentFlat(playerid, flat_id)
{
    if(flat_id < 0 || flat_id >= MAX_ENTRANCE_FLATS) return 0;
    
    if(GetEntranceFlatData(flat_id, EF_OWNER_ID) > 0)
    {
        SendClientMessage(playerid, COLOR_RED, "{FF0000}Эта квартира уже занята!");
        return 0;
    }
    
    new rent_price = GetEntranceFlatData(flat_id, EF_RENT_PRICE);
    
    if(GetPlayerMoneyEx(playerid) < rent_price)
    {
        new msg[128];
        format(msg, sizeof(msg), "{FF0000}Недостаточно денег! Нужно %d$", rent_price);
        SendClientMessage(playerid, COLOR_RED, msg);
        return 0;
    }
    
    // Списание денег
    GivePlayerMoneyEx(playerid, -rent_price, "Аренда квартиры", true, true);
    
    // Установка владельца
    SetEntranceFlatData(flat_id, EF_OWNER_ID, GetPlayerAccountID(playerid));
    GetPlayerNameEx(playerid, g_entrance_flat[flat_id][EF_OWNER_NAME]);
    SetEntranceFlatData(flat_id, EF_RENT_DATE, gettime() + (7 * 86400)); // 7 дней
    
    // Обновление пикапа
    CreateEntranceFlatPickup(flat_id);
    
    new msg[128];
    format(msg, sizeof(msg), "{66CC00}Вы успешно арендовали квартиру №%d на 7 дней!", GetEntranceFlatData(flat_id, EF_FLAT_NUMBER));
    SendClientMessage(playerid, COLOR_GREEN, msg);
    
    return 1;
}

// Обработка подхвата пикапа квартиры
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    // ... существующий код ...
    
    // Проверка на пикап квартиры
    for(new i = 0; i < g_entrance_flat_loaded; i++)
    {
        if(g_entrance_flat[i][EF_PICKUP_ID] == pickupid)
        {
            if(GetPlayerData(playerid, P_IN_FLAT) != -1)
            {
                // Игрок в квартире - выходим
                ExitFlat(playerid);
            }
            else
            {
                // Игрок снаружи - показываем меню
                ShowFlatMenu(playerid, i);
            }
            return 1;
        }
    }
    
    return 1;
}

// Показ меню квартиры
stock ShowFlatMenu(playerid, flat_id)
{
    new dialog_text[512];
    new owner_name[24];
    GetEntranceFlatData(flat_id, EF_OWNER_NAME, owner_name);
    
    if(GetEntranceFlatData(flat_id, EF_OWNER_ID) > 0)
    {
        format(dialog_text, sizeof(dialog_text),
            "{FFFFFF}Квартира №%d\n"
            "{FFD700}Владелец: %s\n"
            "{FFFFFF}Статус: {66CC00}Занята\n"
            "\n"
            "{FF0000}Эта квартира уже арендована!",
            GetEntranceFlatData(flat_id, EF_FLAT_NUMBER),
            owner_name
        );
        
        Dialog(playerid, DIALOG_FLAT_INFO, DIALOG_STYLE_MSGBOX, 
            "{FFD700}Информация о квартире", dialog_text, "Закрыть", "");
    }
    else
    {
        new rent_price = GetEntranceFlatData(flat_id, EF_RENT_PRICE);
        format(dialog_text, sizeof(dialog_text),
            "{FFFFFF}Квартира №%d\n"
            "{FF0000}Статус: Свободна\n"
            "{FFD700}Стоимость аренды: %d$\n"
            "{FFFFFF}Срок: 7 дней\n"
            "\n"
            "{66CC00}Нажмите 'Арендовать' для заселения",
            GetEntranceFlatData(flat_id, EF_FLAT_NUMBER),
            rent_price
        );
        
        Dialog(playerid, DIALOG_FLAT_RENT, DIALOG_STYLE_MSGBOX, 
            "{FFD700}Аренда квартиры", dialog_text, "Арендовать", "Закрыть");
        SetPVarInt(playerid, "rent_flat_id", flat_id);
    }
    
    return 1;
}

// Обработка диалогов
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    // ... существующий код ...
    
    switch(dialogid)
    {
        case DIALOG_FLAT_RENT:
        {
            if(response)
            {
                new flat_id = GetPVarInt(playerid, "rent_flat_id");
                RentFlat(playerid, flat_id);
            }
            DeletePVar(playerid, "rent_flat_id");
            return 1;
        }
    }
    
    return 0;
}

// Загрузка квартир из базы
stock LoadEntranceFlats()
{
    new query[256];
    new Cache: result;
    
    result = mysql_query(mysql, "SELECT * FROM entrance_flats", true);
    new rows = cache_num_rows();
    
    for(new i = 0; i < rows && i < MAX_ENTRANCE_FLATS; i++)
    {
        SetEntranceFlatData(i, EF_SQL_ID, cache_get_field_content_int(i, "id"));
        SetEntranceFlatData(i, EF_ENTRANCE_ID, cache_get_field_content_int(i, "entrance_id"));
        SetEntranceFlatData(i, EF_FLAT_NUMBER, cache_get_field_content_int(i, "flat_number"));
        SetEntranceFlatData(i, EF_OWNER_ID, cache_get_field_content_int(i, "owner_id"));
        cache_get_field_content(i, "owner_name", g_entrance_flat[i][EF_OWNER_NAME], mysql, 24);
        SetEntranceFlatData(i, EF_RENT_DATE, cache_get_field_content_int(i, "rent_date"));
        SetEntranceFlatData(i, EF_RENT_PRICE, cache_get_field_content_int(i, "rent_price"));
        SetEntranceFlatData(i, EF_LOCK_STATUS, cache_get_field_content_int(i, "lock_status"));
        SetEntranceFlatData(i, EF_POS_X, cache_get_field_content_float(i, "pos_x"));
        SetEntranceFlatData(i, EF_POS_Y, cache_get_field_content_float(i, "pos_y"));
        SetEntranceFlatData(i, EF_POS_Z, cache_get_field_content_float(i, "pos_z"));
        SetEntranceFlatData(i, EF_EXIT_POS_X, cache_get_field_content_float(i, "exit_pos_x"));
        SetEntranceFlatData(i, EF_EXIT_POS_Y, cache_get_field_content_float(i, "exit_pos_y"));
        SetEntranceFlatData(i, EF_EXIT_POS_Z, cache_get_field_content_float(i, "exit_pos_z"));
        SetEntranceFlatData(i, EF_EXIT_ANGLE, cache_get_field_content_float(i, "exit_angle"));
        SetEntranceFlatData(i, EF_INTERIOR, cache_get_field_content_int(i, "interior"));
        SetEntranceFlatData(i, EF_VIRTUAL_WORLD, cache_get_field_content_int(i, "virtual_world"));
        
        CreateEntranceFlatPickup(i);
    }
    
    g_entrance_flat_loaded = rows;
    cache_delete(result);
    
    printf("[EntranceFlats] Загружено квартир: %d", g_entrance_flat_loaded);
    return 1;
}

// Добавь в enum игрока
// P_IN_FLAT, // ID квартиры в которой находится игрок

// Добавь дефолтное значение в g_player_default_values
// -1, // P_IN_FLAT

// SQL таблица:
/*
CREATE TABLE IF NOT EXISTS `entrance_flats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrance_id` int(11) NOT NULL,
  `flat_number` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL DEFAULT '0',
  `owner_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `rent_date` int(11) NOT NULL DEFAULT '0',
  `rent_price` int(11) NOT NULL DEFAULT '500',
  `lock_status` int(11) NOT NULL DEFAULT '0',
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `exit_pos_x` float NOT NULL,
  `exit_pos_y` float NOT NULL,
  `exit_pos_z` float NOT NULL,
  `exit_angle` float NOT NULL,
  `interior` int(11) NOT NULL,
  `virtual_world` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
*/