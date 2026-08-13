// ==========================================
// СИСТЕМА ТАКСИ (С ВЫБОРОМ МАШИНЫ)
// ==========================================

#if defined _taxi_system_included
    #endinput
#endif
#define _taxi_system_included

// Диалоги
#define DIALOG_TAXI_MAIN        61000
#define DIALOG_TAXI_CAR         61001
#define DIALOG_TAXI_DEST        61002
#define DIALOG_TAXI_ORDERS_LIST 61003

// Статусы заказов
#define TAXI_ORDER_WAIT         0
#define TAXI_ORDER_TAKEN        1
#define TAXI_ORDER_STARTED      2

// Типы машин
#define TAXI_CAR_ECONOM         0   // Эконом (седан)
#define TAXI_CAR_COMFORT        1   // Комфорт (минивэн)
#define TAXI_CAR_BUSINESS       2   // Бизнес (премиум)

// Стоимость аренды
#define TAXI_RENT_ECONOM        35000
#define TAXI_RENT_COMFORT       55000
#define TAXI_RENT_BUSINESS      85000

// Структура заказа
enum E_TAXI_ORDER
{
    bool:to_active,
    to_passenger,
    to_driver,
    to_status,
    Float:to_pickup_x,
    Float:to_pickup_y,
    Float:to_pickup_z,
    Float:to_dest_x,
    Float:to_dest_y,
    Float:to_dest_z,
    to_fare,
    to_created_at
}

// Данные таксиста
new taxi_driver_vehicle[MAX_PLAYERS];
new bool:taxi_driver_active[MAX_PLAYERS];
new taxi_driver_order[MAX_PLAYERS];
new taxi_driver_name[MAX_PLAYERS][MAX_PLAYER_NAME];
new taxi_driver_car_type[MAX_PLAYERS];

// Данные заказов
new taxi_orders[50][E_TAXI_ORDER];
new taxi_order_id[MAX_PLAYERS];

// Зоны NPC
new taxi_npc_zone[3];
new taxi_npc_actor[3];

// Координаты NPC
new Float:taxi_npc_pos[3][5] = {
    {2223.955810, -1722.221923, 22.320137, 175.358306, 0}, // Южный
    {2415.593994, 1395.244384, 12.687074, 213.710052, 0},  // Батырево
    {381.659240, 1372.845458, 15.491137, 75.819992, 0}      // Арзамас
};

new taxi_npc_name[3][] = {"Южный", "Батырево", "Арзамас"};

// Данные машин
new const taxi_car_models[3] = {420, 418, 560};  // Седан, Минивэн, Суперкар
new const taxi_car_names[3][] = {"Эконом (Седан)", "Комфорт (Минивэн)", "Бизнес (Премиум)"};
new const taxi_car_prices[3] = {35000, 55000, 85000};

// Точки назначения
enum E_TAXI_DEST
{
    td_name[64],
    Float:td_x,
    Float:td_y,
    Float:td_z
}

new const taxi_destinations[][E_TAXI_DEST] = {
    {"Аэропорт", 1145.2, -1720.3, 13.4},
    {"Вокзал Арзамас", -2584.400390, 31.464624, 28.115768},
    {"Вокзал Южный", 1250.0, -1450.0, 13.2},
    {"Вокзал Батырево", 1400.4, -1720.3, 13.2},
    {"Авторынок", 1740.5, -1862.1, 13.5},
    {"Банк Арзамас", 1470.1, -1300.2, 13.2},
    {"Банк Южный", 1550.1, -1670.5, 13.5},
    {"Банк Батырево", 1600.3, -1800.2, 13.5},
    {"Правительство", -878.8411, -1580.0013, 1398.5010},
    {"Госпиталь", 1496.149658, 2527.073730, 2501.000000},
    {"Полиция", -1094.254394, 1523.638549, 1499.947265},
    {"Автосалон", 1822.497070, -143.917648, 15.688644},
    {"Причал Южный", 2566.409179, -2516.000488, 22.119831},
    {"Причал Арзамас", -2457.938476, 1134.409301, 10.855109},
    {"Причал Лыткарино", -2265.864746, -322.510284, 28.101448}
};

// ========== NPC ФУНКЦИИ ==========
stock CreateTaxiNPCs()
{
    for(new i = 0; i < 3; i++)
    {
        taxi_npc_actor[i] = CreateActor(1, taxi_npc_pos[i][0], taxi_npc_pos[i][1], taxi_npc_pos[i][2], taxi_npc_pos[i][3]);
        SetActorVirtualWorld(taxi_npc_actor[i], 0);
        SetActorInvulnerable(taxi_npc_actor[i], true);
        
        new label[128];
        format(label, sizeof label, "{FFFF00}Главный таксист\n{FFFFFF}Подойдите для взаимодействия");
        CreateDynamic3DTextLabel(label, 0xFFFF00FF, taxi_npc_pos[i][0], taxi_npc_pos[i][1], taxi_npc_pos[i][2] + 0.5, 5.0);
        
        taxi_npc_zone[i] = CreateDynamicSphere(taxi_npc_pos[i][0], taxi_npc_pos[i][1], taxi_npc_pos[i][2], 2.0);
    }
    return 1;
}

// ========== ФУНКЦИИ ТАКСИСТА ==========
stock Taxi_ShowCarMenu(playerid)
{
    new list[512];
    for(new i = 0; i < 3; i++)
    {
        new row[128];
        format(row, sizeof row, "%s - %d руб\n", taxi_car_names[i], taxi_car_prices[i]);
        strcat(list, row);
    }
    ShowPlayerDialog(playerid, DIALOG_TAXI_CAR, DIALOG_STYLE_LIST, "Выберите тип такси", list, "Арендовать", "Назад");
    return 1;
}

stock Taxi_StartWork(playerid, car_type)
{
    if(taxi_driver_active[playerid])
        return SendClientMessage(playerid, -1, "Вы уже работаете таксистом");
    
    new price = taxi_car_prices[car_type];
    if(GetPlayerMoneyEx(playerid) < price)
    {
        new msg[128];
        format(msg, sizeof msg, "Для аренды нужно %d руб", price);
        return SendClientMessage(playerid, -1, msg);
    }
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    new model = taxi_car_models[car_type];
    new veh = CreateVehicle(model, x + 3.0, y, z, a, -1, -1, 600);
    if(veh == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Ошибка создания машины");
    
    taxi_driver_vehicle[playerid] = veh;
    taxi_driver_active[playerid] = true;
    taxi_driver_car_type[playerid] = car_type;
    GetPlayerName(playerid, taxi_driver_name[playerid], MAX_PLAYER_NAME);
    
    PutPlayerInVehicle(playerid, veh, 0);
    GivePlayerMoneyEx(playerid, -price, "Аренда такси", true, true);
    
    new msg[128];
    format(msg, sizeof msg, "{33cc33}[Такси]{ffffff} Вы начали работу таксистом! Машина: %s", taxi_car_names[car_type]);
    SendClientMessage(playerid, -1, msg);
    SendClientMessage(playerid, -1, "{33cc33}[Такси]{ffffff} Заказы смотрите через /taxist");
    return 1;
}

stock Taxi_StopWork(playerid)
{
    if(!taxi_driver_active[playerid])
        return SendClientMessage(playerid, -1, "Вы не работаете таксистом");
    
    if(taxi_driver_order[playerid] != -1)
    {
        new order = taxi_driver_order[playerid];
        taxi_orders[order][to_active] = false;
        taxi_driver_order[playerid] = -1;
    }
    
    new veh = taxi_driver_vehicle[playerid];
    if(veh != 0 && IsValidVehicle(veh))
        DestroyVehicle(veh);
    
    taxi_driver_vehicle[playerid] = 0;
    taxi_driver_active[playerid] = false;
    
    SendClientMessage(playerid, -1, "{33cc33}[Такси]{ffffff} Вы завершили работу таксистом");
    return 1;
}

// ========== ФУНКЦИИ ЗАКАЗОВ ==========
stock Taxi_CreateOrder(playerid, dest_index)
{
    if(taxi_order_id[playerid] != -1)
        return SendClientMessage(playerid, -1, "У вас уже есть активный заказ");
    
    // Проверяем есть ли таксисты
    new drivers = 0;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && taxi_driver_active[i])
            drivers++;
    }
    
    if(drivers == 0)
        return SendClientMessage(playerid, -1, "Сейчас нет таксистов, попробуйте позже");
    
    new order_id = -1;
    for(new i = 0; i < 50; i++)
    {
        if(!taxi_orders[i][to_active])
        {
            order_id = i;
            break;
        }
    }
    
    if(order_id == -1)
        return SendClientMessage(playerid, -1, "Слишком много заказов, попробуйте позже");
    
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    
    new fare = 20000 + random(80000);
    
    taxi_orders[order_id][to_active] = true;
    taxi_orders[order_id][to_passenger] = playerid;
    taxi_orders[order_id][to_driver] = -1;
    taxi_orders[order_id][to_status] = TAXI_ORDER_WAIT;
    taxi_orders[order_id][to_pickup_x] = px;
    taxi_orders[order_id][to_pickup_y] = py;
    taxi_orders[order_id][to_pickup_z] = pz;
    taxi_orders[order_id][to_dest_x] = taxi_destinations[dest_index][td_x];
    taxi_orders[order_id][to_dest_y] = taxi_destinations[dest_index][td_y];
    taxi_orders[order_id][to_dest_z] = taxi_destinations[dest_index][td_z];
    taxi_orders[order_id][to_fare] = fare;
    taxi_orders[order_id][to_created_at] = gettime();
    
    taxi_order_id[playerid] = order_id;
    
    new msg[128];
    format(msg, sizeof msg, "{33cc33}[Такси]{ffffff} Заказ создан! Стоимость: {ffff00}%d руб", fare);
    SendClientMessage(playerid, -1, msg);
    SendClientMessage(playerid, -1, "{33cc33}[Такси]{ffffff} Ожидайте таксиста...");
    
    // Уведомляем таксистов
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && taxi_driver_active[i])
        {
            SendClientMessage(i, -1, "{FFCD00}[Диспетчер]{ffffff} Поступил новый заказ! Введите {FFFF00}/taxist");
        }
    }
    
    return 1;
}

stock Taxi_ShowOrdersList(playerid)
{
    new list[2048];
    new count = 0;
    
    format(list, sizeof list, "№\tПассажир\tРасстояние\tЦена\n");
    
    for(new i = 0; i < 50; i++)
    {
        if(!taxi_orders[i][to_active]) continue;
        if(taxi_orders[i][to_status] != TAXI_ORDER_WAIT) continue;
        
        new passenger = taxi_orders[i][to_passenger];
        if(!IsPlayerConnected(passenger)) continue;
        
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(passenger, pname, MAX_PLAYER_NAME);
        
        new Float:dist = GetPlayerDistanceFromPoint(playerid, 
            taxi_orders[i][to_pickup_x], 
            taxi_orders[i][to_pickup_y], 
            taxi_orders[i][to_pickup_z]);
        
        new row[128];
        format(row, sizeof row, "%d\t%s\t%dм\t%d руб\n", i, pname, floatround(dist), taxi_orders[i][to_fare]);
        strcat(list, row);
        count++;
    }
    
    if(count == 0)
        return SendClientMessage(playerid, -1, "Нет активных заказов");
    
    ShowPlayerDialog(playerid, DIALOG_TAXI_ORDERS_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "Доступные заказы", list, "Взять", "Закрыть");
    return 1;
}

stock Taxi_TakeOrder(playerid, order_id)
{
    if(taxi_driver_order[playerid] != -1)
        return SendClientMessage(playerid, -1, "У вас уже есть активный заказ");
    
    if(!taxi_orders[order_id][to_active] || taxi_orders[order_id][to_status] != TAXI_ORDER_WAIT)
        return SendClientMessage(playerid, -1, "Этот заказ уже не доступен");
    
    new passenger = taxi_orders[order_id][to_passenger];
    if(!IsPlayerConnected(passenger))
        return SendClientMessage(playerid, -1, "Пассажир отключился");
    
    taxi_orders[order_id][to_driver] = playerid;
    taxi_orders[order_id][to_status] = TAXI_ORDER_TAKEN;
    taxi_driver_order[playerid] = order_id;
    
    new Float:x = taxi_orders[order_id][to_pickup_x];
    new Float:y = taxi_orders[order_id][to_pickup_y];
    new Float:z = taxi_orders[order_id][to_pickup_z];
    
    SetPlayerCheckpoint(playerid, x, y, z, 7.0);
    
    SendClientMessage(playerid, -1, "{33cc33}[Такси]{ffffff} Вы взяли заказ! Езжайте к клиенту");
    
    new msg[128];
    format(msg, sizeof msg, "{33cc33}[Такси]{ffffff} Таксист %s едет к вам", taxi_driver_name[playerid]);
    SendClientMessage(passenger, -1, msg);
    
    return 1;
}

stock Taxi_CompleteOrder(playerid)
{
    new order = taxi_driver_order[playerid];
    if(order == -1) return 0;
    
    if(!taxi_orders[order][to_active]) return 0;
    
    new passenger = taxi_orders[order][to_passenger];
    new fare = taxi_orders[order][to_fare];
    
    // Списываем деньги с пассажира
    if(IsPlayerConnected(passenger))
    {
        GivePlayerMoneyEx(passenger, -fare, "Оплата такси", true, true);
        SendClientMessage(passenger, -1, "{33cc33}[Такси]{ffffff} Поездка завершена! Спасибо за заказ!");
    }
    
    // Выдаём деньги таксисту
    GivePlayerMoneyEx(playerid, fare, "Оплата такси", true, true);
    
    new msg[128];
    format(msg, sizeof msg, "{33cc33}[Такси]{ffffff} Заказ выполнен! Получено {ffff00}%d руб", fare);
    SendClientMessage(playerid, -1, msg);
    
    DisablePlayerCheckpoint(playerid);
    
    taxi_orders[order][to_active] = false;
    taxi_driver_order[playerid] = -1;
    taxi_order_id[passenger] = -1;
    
    return 1;
}

// ========== ОБРАБОТЧИК ЗОН ==========
stock Taxi_OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < 3; i++)
    {
        if(areaid == taxi_npc_zone[i])
        {
            new menu[256];
            format(menu, sizeof menu, 
                "Начать смену таксиста\n\
                Закончить смену таксиста\n\
                Выбрать такси");
            
            ShowPlayerDialog(playerid, DIALOG_TAXI_MAIN, DIALOG_STYLE_LIST,
                taxi_npc_name[i], menu, "Выбрать", "Закрыть");
            return 1;
        }
    }
    return 0;
}

// ========== ОБРАБОТЧИК ДИАЛОГОВ ==========
stock Taxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TAXI_MAIN)
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: // Начать смену
            {
                if(taxi_driver_active[playerid])
                    SendClientMessage(playerid, -1, "Вы уже работаете таксистом");
                else
                    Taxi_ShowCarMenu(playerid);
            }
            case 1: // Закончить смену
            {
                Taxi_StopWork(playerid);
            }
            case 2: // Выбрать такси
            {
                if(taxi_driver_active[playerid])
                    SendClientMessage(playerid, -1, "Вы уже работаете таксистом");
                else
                    Taxi_ShowCarMenu(playerid);
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_TAXI_CAR)
    {
        if(!response) return 1;
        
        if(taxi_driver_active[playerid])
            return SendClientMessage(playerid, -1, "Вы уже работаете таксистом");
        
        Taxi_StartWork(playerid, listitem);
        return 1;
    }
    
    if(dialogid == DIALOG_TAXI_ORDERS_LIST)
    {
        if(!response) return 1;
        
        if(!taxi_driver_active[playerid])
            return SendClientMessage(playerid, -1, "Вы не работаете таксистом");
        
        Taxi_TakeOrder(playerid, listitem);
        return 1;
    }
    
    return 0;
}

// ========== ОБРАБОТЧИК ЧЕКПОИНТА ==========
stock Taxi_OnPlayerEnterCheckpoint(playerid)
{
    new order = taxi_driver_order[playerid];
    if(order == -1) return 0;
    
    new status = taxi_orders[order][to_status];
    
    if(status == TAXI_ORDER_TAKEN)
    {
        // Приехали к клиенту
        DisablePlayerCheckpoint(playerid);
        
        SendClientMessage(playerid, -1, "{33cc33}[Такси]{ffffff} Вы приехали к клиенту. Ожидайте посадки...");
        
        new passenger = taxi_orders[order][to_passenger];
        if(IsPlayerConnected(passenger))
        {
            SendClientMessage(passenger, -1, "{33cc33}[Такси]{ffffff} Таксист приехал! Садитесь в машину");
        }
        
        taxi_orders[order][to_status] = TAXI_ORDER_STARTED;
        
        // Устанавливаем чекпоинт на точку назначения
        new Float:x = taxi_orders[order][to_dest_x];
        new Float:y = taxi_orders[order][to_dest_y];
        new Float:z = taxi_orders[order][to_dest_z];
        SetPlayerCheckpoint(playerid, x, y, z, 7.0);
        
        return 1;
    }
    else if(status == TAXI_ORDER_STARTED)
    {
        // Приехали к месту назначения
        Taxi_CompleteOrder(playerid);
        return 1;
    }
    
    return 0;
}

// ========== КОМАНДЫ ==========
CMD:taxi(playerid)
{
    new list[1024];
    for(new i = 0; i < sizeof(taxi_destinations); i++)
    {
        new row[64];
        format(row, sizeof row, "%s\n", taxi_destinations[i][td_name]);
        strcat(list, row);
    }
    
    ShowPlayerDialog(playerid, DIALOG_TAXI_DEST, DIALOG_STYLE_LIST,
        "Куда поедем?", list, "Заказать", "Закрыть");
    return 1;
}

CMD:taxist(playerid)
{
    if(!taxi_driver_active[playerid])
        return SendClientMessage(playerid, -1, "Вы не работаете таксистом");
    
    Taxi_ShowOrdersList(playerid);
    return 1;
}

// ========== ИНИЦИАЛИЗАЦИЯ ==========
stock Taxi_Init()
{
    CreateTaxiNPCs();
    return 1;
}

// ========== ХУКИ ==========
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea Taxi_OnPlayerEnterDynamicArea

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Taxi_OnDialogResponse

#if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint Taxi_OnPlayerEnterCheckpoint

#endif