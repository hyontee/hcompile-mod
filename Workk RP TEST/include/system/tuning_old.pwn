
//==============================================================================
//  СИСТЕМА СТО (АВТОСЕРВИС) - ПОЛНАЯ ВЕРСИЯ
//  С ОТОБРАЖЕНИЕМ СТАТУСА ГАРАЖЕЙ
//==============================================================================

// ---------- НАСТРОЙКИ ----------
#define BUSINESS_STO            1

#define DIALOG_STO_MAIN         12350
#define DIALOG_STO_PAINT        12351
#define DIALOG_STO_NITRO        12352
#define DIALOG_STO_FAR          12353
#define DIALOG_STO_DISK         12354
#define DIALOG_STO_LAUNCH       12355
#define DIALOG_STO_RAZVAL       12356
#define DIALOG_STO_RAZMER       12357
#define DIALOG_STO_SHIRINA      12358
#define DIALOG_STO_HYDRA        12359
#define DIALOG_STO_INFO         12360
#define DIALOG_STO_GARAGE       12361

#define STO_INTERIOR            1
#define STO_VIRTUAL_WORLD       152
//-------------------------------

// ---------- ПОЗИЦИИ ----------
new Float:g_sto_positions[][4] =
{
    {1873.560058, -127.698204, 15.695312, 297.235137} // Пикап входа
};

// ---------- ГАРАЖИ (НОВЫЕ КООРДИНАТЫ) ----------
new Float:g_sto_garage_pos[][4] =
{
    {1864.738037, -108.550071, 15.724743, 301.584533}, // Гараж 1
    {1867.051269, -113.572753, 15.721641, 289.774871}, // Гараж 2
    {1869.347167, -118.566085, 15.718059, 293.928100}, // Гараж 3
    {1871.296142, -122.835014, 15.713640, 295.290405}  // Гараж 4
};

new Float:g_sto_exit_pos[][4] =
{
    {1868.0150, -124.3506, 15.6880, 116.8298},
    {1865.8472, -120.0419, 15.6731, 114.6306},
    {1863.4740, -115.1540, 15.6288, 115.4123},
    {1861.3612, -110.0618, 15.6346, 116.4446}
};

// ---------- ПЕРЕМЕННЫЕ ----------
new g_sto_business_id = -1;
new g_sto_pickup;
new g_sto_label;
new g_sto_garage_label[4];      // 3D текст над каждым гаражом
new g_sto_garage_pickup[4];     // Пикап на каждом гараже
new g_sto_area[4];
new bool:g_sto_inside[MAX_PLAYERS];
new bool:g_sto_garage_busy[4];  // Статус гаража
new g_sto_garage_owner[4];      // Владелец гаража

// ---------- ДАННЫЕ ТЮНИНГА ----------
new g_nitro_data[][3] =
{
    {1009, 5000, 1},
    {1008, 10000, 2},
    {1010, 15000, 3}
};

new g_disk_data[][2] =
{
    {1073, 2000},
    {1074, 2000},
    {1075, 2000}
};

new g_far_colors[][3] =
{
    {255, 0, 0},
    {0, 255, 0},
    {0, 0, 255},
    {255, 0, 132},
    {255, 191, 0},
    {255, 102, 0},
    {255, 255, 254}
};

// ============================================================================
//  ОБНОВЛЕНИЕ СТАТУСА ГАРАЖЕЙ
// ============================================================================
stock STO_UpdateGarageLabels()
{
    new label_text[128];
    
    for(new i = 0; i < 4; i++)
    {
        if(g_sto_garage_busy[i])
        {
            format(label_text, sizeof(label_text),
                "{FFFF00}Гараж №%d{FFFFFF}\n{FF6600}Статус: Занят",
                i + 1
            );
        }
        else
        {
            format(label_text, sizeof(label_text),
                "{FFFF00}Гараж №%d{FFFFFF}\n{66CC00}Статус: Свободен",
                i + 1
            );
        }
        
        if(g_sto_garage_label[i] != Text3D:INVALID_3DTEXT_ID)
        {
            UpdateDynamic3DTextLabelText(g_sto_garage_label[i], -1, label_text);
        }
    }
    return 1;
}

// ============================================================================
//  ЗАГРУЗКА БИЗНЕСА
// ============================================================================
stock STO_LoadBusiness()
{
    new query[128];
    format(query, sizeof(query), "SELECT id FROM business WHERE type = %d", BUSINESS_STO);
    
    new Cache:result = mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        g_sto_business_id = cache_get_field_content_int(0, "id");
    }
    else
    {
        new rent_time = (gettime() - (gettime() % 86400)) + 86400;
        format(query, sizeof(query),
            "INSERT INTO business (name, type, owner_id, price, enter_price, balance, rent_time, `lock`) VALUES ('Автосервис', %d, 0, 1500000, 0, 0, %d, 0)",
            BUSINESS_STO, rent_time
        );
        mysql_query(mysql, query);
        g_sto_business_id = cache_insert_id();
    }
    
    cache_delete(result);
    return 1;
}

// ============================================================================
//  СОЗДАНИЕ ПИКАПОВ И МЕТОК
// ============================================================================
stock STO_CreatePickup()
{
    // Пикап входа
    g_sto_pickup = CreateDynamicPickup(19134, 23, 
        g_sto_positions[0][0], g_sto_positions[0][1], g_sto_positions[0][2], 0);
    
    g_sto_label = CreateDynamic3DTextLabel(
        "{FFFF00}Автосервис{FFFFFF}\n{66CC00}Подойдите чтобы войти",
        -1,
        g_sto_positions[0][0], g_sto_positions[0][1], g_sto_positions[0][2] + 0.5,
        10.0
    );
    
    // Создаем гаражи
    new label_text[128];
    for(new i = 0; i < 4; i++)
    {
        // Пикап на каждом гараже
        g_sto_garage_pickup[i] = CreateDynamicPickup(19135, 23,
            g_sto_garage_pos[i][0],
            g_sto_garage_pos[i][1],
            g_sto_garage_pos[i][2],
            0
        );
        
        // 3D текст над гаражом
        format(label_text, sizeof(label_text),
            "{FFFF00}Гараж №%d{FFFFFF}\n{66CC00}Статус: Свободен",
            i + 1
        );
        
        g_sto_garage_label[i] = CreateDynamic3DTextLabel(
            label_text,
            -1,
            g_sto_garage_pos[i][0],
            g_sto_garage_pos[i][1],
            g_sto_garage_pos[i][2] + 0.8,
            15.0
        );
        
        // Зона для выхода
        g_sto_area[i] = CreateDynamicSphere(
            g_sto_exit_pos[i][0],
            g_sto_exit_pos[i][1],
            g_sto_exit_pos[i][2],
            2.0
        );
        
        g_sto_garage_busy[i] = false;
        g_sto_garage_owner[i] = INVALID_PLAYER_ID;
    }
    
    return 1;
}

// ============================================================================
//  УДАЛЕНИЕ ПИКАПОВ
// ============================================================================
stock STO_DestroyPickup()
{
    if(g_sto_pickup) DestroyDynamicPickup(g_sto_pickup);
    if(g_sto_label) DestroyDynamic3DTextLabel(g_sto_label);
    
    for(new i = 0; i < 4; i++)
    {
        if(g_sto_garage_pickup[i]) DestroyDynamicPickup(g_sto_garage_pickup[i]);
        if(g_sto_garage_label[i]) DestroyDynamic3DTextLabel(g_sto_garage_label[i]);
        if(g_sto_area[i]) DestroyDynamicArea(g_sto_area[i]);
    }
    return 1;
}

// ============================================================================
//  ЗАНЯТЬ/ОСВОБОДИТЬ ГАРАЖ
// ============================================================================
stock STO_SetGarageBusy(garage_id, playerid, bool:busy)
{
    if(garage_id < 0 || garage_id > 3) return 0;
    
    g_sto_garage_busy[garage_id] = busy;
    
    if(busy)
    {
        g_sto_garage_owner[garage_id] = playerid;
    }
    else
    {
        g_sto_garage_owner[garage_id] = INVALID_PLAYER_ID;
    }
    
    STO_UpdateGarageLabels();
    return 1;
}

// ============================================================================
//  ПОКАЗ МЕНЮ ВЫБОРА ГАРАЖА
// ============================================================================
stock STO_ShowGarageMenu(playerid)
{
    new info[512];
    format(info, sizeof(info),
        "1. Гараж №1 - %s\n"\
        "2. Гараж №2 - %s\n"\
        "3. Гараж №3 - %s\n"\
        "4. Гараж №4 - %s",
        g_sto_garage_busy[0] ? "{FF6600}Занят" : "{66CC00}Свободен",
        g_sto_garage_busy[1] ? "{FF6600}Занят" : "{66CC00}Свободен",
        g_sto_garage_busy[2] ? "{FF6600}Занят" : "{66CC00}Свободен",
        g_sto_garage_busy[3] ? "{FF6600}Занят" : "{66CC00}Свободен"
    );
    
    ShowPlayerDialog(playerid, DIALOG_STO_GARAGE, DIALOG_STYLE_LIST,
        "{FF6347}Выберите гараж", info, "Выбрать", "Назад");
    return 1;
}

// ============================================================================
//  ПОКАЗ МЕНЮ
// ============================================================================
stock STO_ShowMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_STO_MAIN, DIALOG_STYLE_LIST,
        "{FF6347}Автосервис",
        "1. Перекрасить элементы\n"\
        "2. Установить нитро\n"\
        "3. Цвет фар\n"\
        "4. Установить диски\n"\
        "5. Лаунч-контроль\n"\
        "6. Развал колес\n"\
        "7. Размер колес\n"\
        "8. Ширина колес\n"\
        "9. Гидравлика\n"\
        "10. Информация",
        "Выбрать", "Выйти"
    );
    return 1;
}

// ============================================================================
//  ВХОД В СТО
// ============================================================================
stock STO_Enter(playerid)
{
    if(g_sto_business_id == -1) return 0;
    if(g_sto_inside[playerid]) return 0;
    
    if(IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, -1, "{FF6600}Выйдите из транспорта!");
        return 0;
    }
    
    new query[128], enter_price = 0, lock_status = 0;
    format(query, sizeof(query), "SELECT `lock`, enter_price FROM business WHERE id = %d", g_sto_business_id);
    new Cache:result = mysql_query(mysql, query);
    
    lock_status = cache_get_field_content_int(0, "lock");
    enter_price = cache_get_field_content_int(0, "enter_price");
    cache_delete(result);
    
    if(lock_status)
    {
        SendClientMessage(playerid, -1, "{FF6600}Автосервис закрыт!");
        return 0;
    }
    
    if(enter_price > 0 && GetPlayerMoneyEx(playerid) < enter_price)
    {
        SendClientMessage(playerid, -1, "{FF6600}У вас недостаточно денег для входа!");
        return 0;
    }
    
    if(enter_price > 0)
    {
        GivePlayerMoneyEx(playerid, -enter_price);
        
        new balance;
        format(query, sizeof(query), "SELECT balance FROM business WHERE id = %d", g_sto_business_id);
        result = mysql_query(mysql, query);
        balance = cache_get_field_content_int(0, "balance");
        cache_delete(result);
        
        balance += enter_price;
        format(query, sizeof(query), "UPDATE business SET balance = %d WHERE id = %d", balance, g_sto_business_id);
        mysql_query(mysql, query);
    }
    
    // Телепорт в интерьер
    SetPlayerPos(playerid, 999.987854, 2489.679443, 1499.304687);
    SetPlayerInterior(playerid, STO_INTERIOR);
    SetPlayerVirtualWorld(playerid, STO_VIRTUAL_WORLD);
    SetCameraBehindPlayer(playerid);
    
    g_sto_inside[playerid] = true;
    
    SendClientMessage(playerid, -1, "{66CC00}Добро пожаловать в Автосервис!");
    STO_ShowGarageMenu(playerid);
    return 1;
}

// ============================================================================
//  ЗАЕХАТЬ В ГАРАЖ
// ============================================================================
stock STO_EnterGarage(playerid, garage_id)
{
    if(!g_sto_inside[playerid]) return 0;
    if(garage_id < 0 || garage_id > 3) return 0;
    
    if(g_sto_garage_busy[garage_id]) 
    {
        SendClientMessage(playerid, -1, "{FF6600}Этот гараж уже занят!");
        return 0;
    }
    
    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        SendClientMessage(playerid, -1, "{FF6600}У вас нет личного транспорта!");
        return 0;
    }
    
    // Занимаем гараж
    STO_SetGarageBusy(garage_id, playerid, true);
    
    // Телепорт машины в гараж
    new world = playerid + 1000;
    SetVehiclePos(vehicleid, 995.735229, 1001.658935, 1500.155761);
    SetVehicleZAngle(vehicleid, 177.443664);
    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, world);
    
    // Телепорт игрока
    SetPlayerPos(playerid, 999.656250, 998.227416, 1501.000000);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, world);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    
    PutPlayerInVehicle(playerid, vehicleid, 0);
    
    SendClientMessage(playerid, -1, "{66CC00}Вы заехали в гараж!");
    STO_ShowMenu(playerid);
    return 1;
}

// ============================================================================
//  ВЫХОД ИЗ СТО
// ============================================================================
stock STO_Exit(playerid)
{
    if(!g_sto_inside[playerid]) return 0;
    
    // Освобождаем гараж
    for(new i = 0; i < 4; i++)
    {
        if(g_sto_garage_owner[i] == playerid)
        {
            STO_SetGarageBusy(i, playerid, false);
        }
    }
    
    SetPlayerPos(playerid, g_sto_positions[0][0] + 2.0, g_sto_positions[0][1] + 2.0, g_sto_positions[0][2]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
    
    g_sto_inside[playerid] = false;
    
    SendClientMessage(playerid, -1, "{66CC00}Вы покинули Автосервис.");
    return 1;
}

// ============================================================================
//  ВЫХОД НА МАШИНЕ
// ============================================================================
stock STO_ExitWithVehicle(playerid, vehicleid)
{
    if(!g_sto_inside[playerid]) return 0;
    
    // Освобождаем гараж
    for(new i = 0; i < 4; i++)
    {
        if(g_sto_garage_owner[i] == playerid)
        {
            STO_SetGarageBusy(i, playerid, false);
        }
    }
    
    new slot = random(4);
    SetVehiclePos(vehicleid,
        g_sto_exit_pos[slot][0],
        g_sto_exit_pos[slot][1],
        g_sto_exit_pos[slot][2]
    );
    SetVehicleZAngle(vehicleid, g_sto_exit_pos[slot][3]);
    LinkVehicleToInterior(vehicleid, 0);
    SetVehicleVirtualWorld(vehicleid, 0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    
    g_sto_inside[playerid] = false;
    SendClientMessage(playerid, -1, "{66CC00}Вы покинули Автосервис на машине.");
    return 1;
}

// ============================================================================
//  ИНИЦИАЛИЗАЦИЯ
// ============================================================================
stock STO_Init()
{
    STO_LoadBusiness();
    STO_CreatePickup();
    STO_UpdateGarageLabels();
    print("[STO] Автосервис загружен!");
    return 1;
}

// ============================================================================
//  ОБРАБОТЧИК ПИКАПА
// ============================================================================
stock STO_OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    // Пикап входа
    if(pickupid == g_sto_pickup)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            SendClientMessage(playerid, -1, "{FF6600}Выйдите из транспорта!");
            return 1;
        }
        STO_Enter(playerid);
        return 1;
    }
    
    // Пикапы гаражей
    for(new i = 0; i < 4; i++)
    {
        if(pickupid == g_sto_garage_pickup[i])
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                SendClientMessage(playerid, -1, "{FF6600}Выйдите из транспорта!");
                return 1;
            }
            
            if(g_sto_inside[playerid])
            {
                STO_EnterGarage(playerid, i);
                return 1;
            }
            else
            {
                SendClientMessage(playerid, -1, "{FF6600}Сначала войдите в Автосервис через главный вход!");
                return 1;
            }
        }
    }
    
    return 0;
}

// ============================================================================
//  ОБРАБОТЧИК ЗОН
// ============================================================================
stock STO_OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < 4; i++)
    {
        if(areaid == g_sto_area[i])
        {
            if(g_sto_inside[playerid])
            {
                if(IsPlayerInAnyVehicle(playerid))
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    STO_ExitWithVehicle(playerid, vehicleid);
                }
                else
                {
                    STO_Exit(playerid);
                }
            }
            return 1;
        }
    }
    return 0;
}

// ============================================================================
//  ОБРАБОТЧИК ДИАЛОГОВ
// ============================================================================
stock STO_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    // ==================== ВЫБОР ГАРАЖА ====================
    if(dialogid == DIALOG_STO_GARAGE)
    {
        if(!response) return STO_Exit(playerid);
        
        if(listitem >= 0 && listitem < 4)
        {
            STO_EnterGarage(playerid, listitem);
        }
        return 1;
    }
    
    // ==================== ГЛАВНОЕ МЕНЮ ====================
    if(dialogid == DIALOG_STO_MAIN)
    {
        if(!response) 
        {
            STO_ShowGarageMenu(playerid);
            return 1;
        }
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, -1, "{FF6600}У вас нет личного транспорта!");
            STO_ShowGarageMenu(playerid);
            return 1;
        }
        
        switch(listitem)
        {
            case 0: ShowPlayerDialog(playerid, DIALOG_STO_PAINT, DIALOG_STYLE_LIST,
                "{FF6347}Перекраска", "1. Кузов (5000 руб.)\n2. Колеса (5000 руб.)", "Выбрать", "Назад");
            case 1: ShowPlayerDialog(playerid, DIALOG_STO_NITRO, DIALOG_STYLE_LIST,
                "{FF6347}Нитро", "1. Nitro X2 (5000 руб.)\n2. Nitro X5 (10000 руб.)\n3. Nitro X10 (15000 руб.)\n4. Удалить (1000 руб.)", "Выбрать", "Назад");
            case 2: ShowPlayerDialog(playerid, DIALOG_STO_FAR, DIALOG_STYLE_LIST,
                "{FF6347}Цвет фар", "1. Красный (5000 руб.)\n2. Зеленый (5000 руб.)\n3. Синий (5000 руб.)\n4. Розовый (5000 руб.)\n5. Желтый (5000 руб.)\n6. Оранжевый (5000 руб.)\n7. Белый (5000 руб.)", "Выбрать", "Назад");
            case 3: ShowPlayerDialog(playerid, DIALOG_STO_DISK, DIALOG_STYLE_LIST,
                "{FF6347}Диски", "1. Диски 1 (2000 руб.)\n2. Диски 2 (2000 руб.)\n3. Диски 3 (2000 руб.)", "Выбрать", "Назад");
            case 4: ShowPlayerDialog(playerid, DIALOG_STO_LAUNCH, DIALOG_STYLE_LIST,
                "{FF6347}Лаунч", "1. Установить (20000 руб.)\n2. Удалить (1000 руб.)", "Выбрать", "Назад");
            case 5: ShowPlayerDialog(playerid, DIALOG_STO_RAZVAL, DIALOG_STYLE_INPUT,
                "{FF6347}Развал", "Введите значение от 1 до 100\nСтоимость: 20000 руб.", "Применить", "Назад");
            case 6: ShowPlayerDialog(playerid, DIALOG_STO_RAZMER, DIALOG_STYLE_INPUT,
                "{FF6347}Размер", "Введите значение от 10 до 30\nСтоимость: 20000 руб.", "Применить", "Назад");
            case 7: ShowPlayerDialog(playerid, DIALOG_STO_SHIRINA, DIALOG_STYLE_INPUT,
                "{FF6347}Ширина", "Введите значение от 173 до 300\nСтоимость: 20000 руб.", "Применить", "Назад");
            case 8: ShowPlayerDialog(playerid, DIALOG_STO_HYDRA, DIALOG_STYLE_LIST,
                "{FF6347}Гидравлика", "1. Установить (40000 руб.)\n2. Удалить (1000 руб.)", "Выбрать", "Назад");
            case 9: 
            {
                new info[512], owner_name[24];
                new owner_id = GetBusinessData(g_sto_business_id, B_OWNER_ID);
                new enter_price = GetBusinessData(g_sto_business_id, B_ENTER_PRICE);
                new lock_status = GetBusinessData(g_sto_business_id, B_LOCK_STATUS);
                
                if(owner_id == 0) format(owner_name, sizeof(owner_name), "Не куплен");
                else GetBusinessDataName(g_sto_business_id, B_OWNER_NAME, owner_name);
                
                format(info, sizeof(info),
                    "{FFFFFF}Автосервис\n\n"\
                    "{66CC00}Владелец: {FFFFFF}%s\n"\
                    "{66CC00}Статус: {FFFFFF}%s\n"\
                    "{66CC00}Цена входа: {FFFFFF}%d руб.",
                    owner_name,
                    lock_status ? "{FF6600}Закрыт" : "{66CC00}Открыт",
                    enter_price
                );
                ShowPlayerDialog(playerid, DIALOG_STO_INFO, DIALOG_STYLE_MSGBOX,
                    "Информация", info, "ОК", "");
            }
        }
        return 1;
    }
    
    // ==================== ПОКРАСКА ====================
    if(dialogid == DIALOG_STO_PAINT)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid == INVALID_VEHICLE_ID) return 1;
        
        if(GetPlayerMoneyEx(playerid) < 5000)
        {
            SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
            return STO_ShowMenu(playerid);
        }
        
        new idx = GetPVarInt(playerid, "ownablecar_id");
        new query[256];
        
        if(listitem == 0)
        {
            SetOwnableCarData(vehicleid, OC_COLOR_1, 0);
            ChangeVehicleColor(vehicleid, 0, GetOwnableCarData(vehicleid, OC_COLOR_2));
            mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET color_1 = 0 WHERE id = %d", idx);
            SendClientMessage(playerid, -1, "{66CC00}Кузов перекрашен!");
        }
        else
        {
            SetOwnableCarData(vehicleid, OC_COLOR_2, 0);
            ChangeVehicleColor(vehicleid, GetOwnableCarData(vehicleid, OC_COLOR_1), 0);
            mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET color_2 = 0 WHERE id = %d", idx);
            SendClientMessage(playerid, -1, "{66CC00}Колеса перекрашены!");
        }
        
        mysql_query(mysql, query);
        GivePlayerMoneyEx(playerid, -5000);
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== НИТРО ====================
    if(dialogid == DIALOG_STO_NITRO)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid == INVALID_VEHICLE_ID) return 1;
        
        new idx = GetPVarInt(playerid, "ownablecar_id");
        new query[256];
        
        if(listitem == 3)
        {
            if(GetPlayerMoneyEx(playerid) < 1000)
            {
                SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
                return STO_ShowMenu(playerid);
            }
            
            RemoveVehicleComponent(vehicleid, 1009);
            RemoveVehicleComponent(vehicleid, 1008);
            RemoveVehicleComponent(vehicleid, 1010);
            mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET nitro = 0 WHERE id = %d", idx);
            GivePlayerMoneyEx(playerid, -1000);
            SendClientMessage(playerid, -1, "{66CC00}Нитро удалено!");
        }
        else
        {
            new price = g_nitro_data[listitem][1];
            if(GetPlayerMoneyEx(playerid) < price)
            {
                SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
                return STO_ShowMenu(playerid);
            }
            
            AddVehicleComponent(vehicleid, g_nitro_data[listitem][0]);
            mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET nitro = %d WHERE id = %d", g_nitro_data[listitem][2], idx);
            GivePlayerMoneyEx(playerid, -price);
            SendClientMessage(playerid, -1, "{66CC00}Нитро установлено!");
        }
        
        mysql_query(mysql, query);
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== ЦВЕТ ФАР ====================
    if(dialogid == DIALOG_STO_FAR)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid == INVALID_VEHICLE_ID) return 1;
        
        if(GetPlayerMoneyEx(playerid) < 5000)
        {
            SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
            return STO_ShowMenu(playerid);
        }
        
        new idx = GetPVarInt(playerid, "ownablecar_id");
        new query[256];
        
        SetVehicleLightsColors(vehicleid, g_far_colors[listitem][0], g_far_colors[listitem][1], g_far_colors[listitem][2]);
        mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET fars = %d WHERE id = %d", listitem + 1, idx);
        mysql_query(mysql, query);
        GivePlayerMoneyEx(playerid, -5000);
        SendClientMessage(playerid, -1, "{66CC00}Цвет фар изменен!");
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== ДИСКИ ====================
    if(dialogid == DIALOG_STO_DISK)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid == INVALID_VEHICLE_ID) return 1;
        
        new price = g_disk_data[listitem][1];
        if(GetPlayerMoneyEx(playerid) < price)
        {
            SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
            return STO_ShowMenu(playerid);
        }
        
        new idx = GetPVarInt(playerid, "ownablecar_id");
        new query[256];
        
        AddVehicleComponent(vehicleid, g_disk_data[listitem][0]);
        mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET diski = %d WHERE id = %d", listitem + 1, idx);
        mysql_query(mysql, query);
        GivePlayerMoneyEx(playerid, -price);
        SendClientMessage(playerid, -1, "{66CC00}Диски установлены!");
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== ЛАУНЧ ====================
    if(dialogid == DIALOG_STO_LAUNCH)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        if(listitem == 0)
        {
            if(GetPlayerMoneyEx(playerid) < 20000)
            {
                SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
                return STO_ShowMenu(playerid);
            }
            GivePlayerMoneyEx(playerid, -20000);
            SendClientMessage(playerid, -1, "{66CC00}Лаунч установлен!");
        }
        else
        {
            if(GetPlayerMoneyEx(playerid) < 1000)
            {
                SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
                return STO_ShowMenu(playerid);
            }
            GivePlayerMoneyEx(playerid, -1000);
            SendClientMessage(playerid, -1, "{66CC00}Лаунч удален!");
        }
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== РАЗВАЛ ====================
    if(dialogid == DIALOG_STO_RAZVAL)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new value = strval(inputtext);
        if(value < 1 || value > 100)
        {
            SendClientMessage(playerid, -1, "{FF6600}Значение от 1 до 100!");
            return STO_ShowMenu(playerid);
        }
        
        if(GetPlayerMoneyEx(playerid) < 20000)
        {
            SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
            return STO_ShowMenu(playerid);
        }
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid != INVALID_VEHICLE_ID)
        {
            SetVehicleWheelAngle(vehicleid, 0, value);
            SetVehicleWheelAngle(vehicleid, 1, value);
        }
        
        GivePlayerMoneyEx(playerid, -20000);
        SendClientMessage(playerid, -1, "{66CC00}Развал установлен!");
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== РАЗМЕР ====================
    if(dialogid == DIALOG_STO_RAZMER)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new value = strval(inputtext);
        if(value < 10 || value > 30)
        {
            SendClientMessage(playerid, -1, "{FF6600}Значение от 10 до 30!");
            return STO_ShowMenu(playerid);
        }
        
        if(GetPlayerMoneyEx(playerid) < 20000)
        {
            SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
            return STO_ShowMenu(playerid);
        }
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid != INVALID_VEHICLE_ID)
        {
            SetVehicleWheelSize(vehicleid, float(value) / 10.0);
        }
        
        GivePlayerMoneyEx(playerid, -20000);
        SendClientMessage(playerid, -1, "{66CC00}Размер установлен!");
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== ШИРИНА ====================
    if(dialogid == DIALOG_STO_SHIRINA)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        new value = strval(inputtext);
        if(value < 173 || value > 300)
        {
            SendClientMessage(playerid, -1, "{FF6600}Значение от 173 до 300!");
            return STO_ShowMenu(playerid);
        }
        
        if(GetPlayerMoneyEx(playerid) < 20000)
        {
            SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
            return STO_ShowMenu(playerid);
        }
        
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid != INVALID_VEHICLE_ID)
        {
            SetVehicleWidthWheel(vehicleid, value);
        }
        
        GivePlayerMoneyEx(playerid, -20000);
        SendClientMessage(playerid, -1, "{66CC00}Ширина установлена!");
        STO_ShowMenu(playerid);
        return 1;
    }
    
    // ==================== ГИДРАВЛИКА ====================
    if(dialogid == DIALOG_STO_HYDRA)
    {
        if(!response) return STO_ShowMenu(playerid);
        
        if(listitem == 0)
        {
            if(GetPlayerMoneyEx(playerid) < 40000)
            {
                SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
                return STO_ShowMenu(playerid);
            }
            GivePlayerMoneyEx(playerid, -40000);
            SendClientMessage(playerid, -1, "{66CC00}Гидравлика установлена!");
        }
        else
        {
            if(GetPlayerMoneyEx(playerid) < 1000)
            {
                SendClientMessage(playerid, -1, "{FF6600}Недостаточно денег!");
                return STO_ShowMenu(playerid);
            }
            GivePlayerMoneyEx(playerid, -1000);
            SendClientMessage(playerid, -1, "{66CC00}Гидравлика удалена!");
        }
        STO_ShowMenu(playerid);
        return 1;
    }
    
    return 0;
}