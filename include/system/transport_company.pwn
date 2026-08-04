//AВТОР СИСТЕМЫ : https://t.me/welsistudio
//УЛУЧШЕННАЯ ВЕРСИЯ С СИСТЕМОЙ WAYPOINT НА КАРТЕ

//--------------------------------------------------------
//                      НАСТРОЙКИ
//--------------------------------------------------------
#define tc_msg "{FFAE00}[Транспортная компания] {FFFFFF}"
#define LEVEL_START_TC  2      // Минимальный уровень для работы
#define TC_PRICE        50000  // Цена покупки ТК
#define TC_MAX_SLOTS    7      // Максимум слотов
#define TC_UPDATE_INTERVAL 180000

//--------------------------------------------------------
//                      ИНДЕКСЫ WAYPOINT
//--------------------------------------------------------
#define WAYPOINT_LOADING 1
#define WAYPOINT_UNLOAD  2
//--------------------------------------------------------
//                      КООРДИНАТЫ
//--------------------------------------------------------

// Координаты входов в ТК (Батырево и Бусаево)
new Float:coord_tcompany[2][3] =
{
    {2327.637207, 2009.636962, 16.620204},  // Батырево
    {-426.065887, -1687.605712, 41.526901}   // Бусаево
};

// Координаты выхода из интерьера
new Float:coord_tcompany_exit[3] = {-0.251249, 2500.500000, 2011.005126};

// Координаты пикапа заказов
new Float:coord_tcompany_order[3] = {2.028566, 2503.603271, 2011.005126};

// Координаты спавна трейлеров
new Float:spawn_trailer_tc[2][7][4] =
{
    {
        {2287.05, 2057.90, 15.66, 182.79},
        {2296.59, 2058.41, 15.67, 182.79},
        {2307.05, 2059.09, 15.67, 182.79},
        {2316.68, 2059.64, 15.66, 182.79},
        {2342.84, 2058.12, 15.67, 182.79},
        {2348.80, 2058.29, 15.67, 182.79},
        {2355.14, 2058.69, 15.66, 182.79}
    },
    {
        {-386.51, -1738.53, 40.6, 329.76},
        {-392.66, -1737.33, 40.6, 329.76},
        {-397.25, -1733.01, 40.6, 329.76},
        {-402.83, -1731.03, 40.6, 329.76},
        {-408.05, -1728.22, 40.6, 329.76},
        {-412.63, -1723.96, 40.6, 329.76},
        {-417.88, -1720.82, 40.6, 329.76}
    }
};

// Координаты спавна грузовиков
new Float:spawn_truck_tc[2][7][4] =
{
    {
        {2313.00, 1992.95, 15.66, 2.06},
        {2306.60, 1992.98, 15.67, 2.06},
        {2300.28, 1992.31, 15.66, 2.06},
        {2293.74, 1992.36, 15.67, 2.06},
        {2287.03, 1993.11, 15.66, 2.06},
        {2280.16, 1992.92, 15.67, 2.06},
        {2272.57, 1992.89, 15.67, 2.06}
    },
    {
        {-406.06, -1689.130, 40.6, 149.76},
        {-401.08, -1692.530, 40.6, 149.76},
        {-395.73, -1695.842, 40.6, 149.76},
        {-389.30, -1699.543, 40.6, 149.76},
        {-384.53, -1702.104, 40.6, 149.76},
        {-379.12, -1705.562, 40.6, 149.76},
        {-374.09, -1709.198, 40.6, 149.76}
    }
};

// Глобальные переменные для зон и пикапов
new enter_tcompany[2], exit_tcompany, pickup_orderd_tc;
//--------------------------------------------------------
//                      ENUM'Ы
//--------------------------------------------------------
enum PLAYER_COMPANY
{
    p_TC_Owner,
    p_TC_CompanyID,
    bool:p_TC_Active,
    p_TC_Order,
    p_TC_Progress_Order,
    Text3D:p_TC_Text,
    p_TC_Sphere_Finish,
    p_TC_Truck,
    p_TC_Trailer,
    p_TC_Level,
    p_TC_Exp,
    p_TC_JoinTime,
    p_TC_WaypointID    // ID текущего waypoint
}

enum COMPANY_DATA
{
    c_Owner[MAX_PLAYER_NAME],
    c_OwnerID,
    c_Name[32],
    c_Money,
    c_Members,
    c_MemberIDs[TC_MAX_SLOTS],
    bool:c_Locked,
    c_CreatedAt
}

//--------------------------------------------------------
//                      ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
//--------------------------------------------------------
new player_tc[MAX_PLAYERS][PLAYER_COMPANY];
new CompanyData[TC_MAX_SLOTS][COMPANY_DATA];
new Iterator:Companies<TC_MAX_SLOTS>;

// Константы
#define TC_LOCALITY_BUSAEVO  2
#define TC_LOCALITY_BATUREVO 1

#define TC_ORDER_NLOAD  0
#define TC_ORDER_NTAKE  1
#define TC_ORDER_TAKE   2

// Типы грузов
#define TC_TYPE_ORDER_COAL       1
#define TC_TYPE_ORDER_METAL      2
#define TC_TYPE_ORDER_OZON       3
#define TC_TYPE_ORDER_PETROL     4
#define TC_TYPE_ORDER_PRODUCTS   5
#define TC_TYPE_ORDER_TECHNOLOGY 6
#define TC_TYPE_ORDER_GLASS      7
#define TC_TYPE_ORDER_BANANS     8
#define TC_TYPE_ORDER_WATERMELON 9

//--------------------------------------------------------
//                      НАЗВАНИЯ ГРУЗОВ
//--------------------------------------------------------
new name_order_TC[9][24] =
{
    {"Уголь"}, {"Металл"}, {"Заказы Озон"}, {"Бензин"},
    {"Продукты"}, {"Электроприборы"}, {"Стекло"}, {"Бананы"}, {"Арбузы"}
};

new salary_order_TC[9][2] =
{
    {130000, 70000}, {100000, 65000}, {145000, 45000},
    {120000, 75000}, {95000, 50000}, {90000, 60000},
    {95000, 150000}, {120000, 70000}, {200000, 100000}
};

new type_trailer[9] = {450, 435, -1, 584, -1, 435, 591, -1, -1};
new type_truck[9] = {403, 403, 498, 403, 498, 403, 403, 413, 413};
new open_order_lvl[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

//--------------------------------------------------------
//                      СТРУКТУРА ЗАКАЗА
//--------------------------------------------------------
enum ORDER_TC
{
    o_TC_Type,
    o_TC_Locality,
    Float:o_TC_FinishPos[3],
    o_TC_Status,
    o_TC_Salary,
    o_TC_Finish[54],
    o_TC_TakenBy,
    Float:o_TC_LoadPos[3]  // Добавляем позицию загрузки для waypoint
}

//--------------------------------------------------------
//                      ЗАКАЗЫ
//--------------------------------------------------------
new orders_tc[40][ORDER_TC];

//--------------------------------------------------------
//      СИСТЕМА WAYPOINT (РАБОТАЕТ НА SA:MP 0.3.7+)
//--------------------------------------------------------

// Отправка waypoint на карту игроку
stock SendCreateWayPoint(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id=0, color=0xFFFF00AA, Float:dist=0.0, interior=-1)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, waypoint_id,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z,
        PR_UINT32, icon_id,
        PR_UINT32, color,
        PR_FLOAT, dist,
        PR_INT8, interior
    );
    PR_SendRPC(bs, playerid, 169, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

// Удаление waypoint с карты
stock SendDestroyWayPoint(playerid, waypoint_id)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, waypoint_id);
    PR_SendRPC(bs, playerid, 170, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

// Очистка всех waypoint игрока
stock ClearPlayerWaypoints(playerid)
{
    for(new i = 1; i <= 10; i++)
    {
        SendDestroyWayPoint(playerid, i);
    }
    player_tc[playerid][p_TC_WaypointID] = 0;
    return 1;
}

//--------------------------------------------------------
//                      ФУНКЦИИ РАБОТЫ С map icon
//--------------------------------------------------------
// Альтернативный способ - стандартная метка на карте (работает на всех клиентах)
stock SetPlayerMapMarker(playerid, Float:x, Float:y, Float:z, type=0, color=0xFFAE00)
{
    // Используем SetPlayerMapIcon для стандартной метки
    // Удаляем старую метку если есть
    if(player_tc[playerid][p_TC_WaypointID] > 0)
    {
        RemovePlayerMapIcon(playerid, player_tc[playerid][p_TC_WaypointID]);
    }

    // Создаём новую метку (ID от 1 до 99)
    player_tc[playerid][p_TC_WaypointID] = 1;
    for(new i = 1; i < 100; i++)
    {
        if(IsValidMapIcon(playerid, i)) continue;
        player_tc[playerid][p_TC_WaypointID] = i;
        break;
    }

    SetPlayerMapIcon(playerid, player_tc[playerid][p_TC_WaypointID], x, y, z, type, color, MAPICON_LOCAL);
    return 1;
}

stock RemovePlayerMapMarker(playerid)
{
    if(player_tc[playerid][p_TC_WaypointID] > 0)
    {
        RemovePlayerMapIcon(playerid, player_tc[playerid][p_TC_WaypointID]);
        player_tc[playerid][p_TC_WaypointID] = 0;
    }
    return 1;
}

//--------------------------------------------------------
//                      ИНИЦИАЛИЗАЦИЯ ЗАКАЗОВ
//--------------------------------------------------------
public OnGameModeInit()
{
    print("[TC_SYSTEM] Система дальнобойщика загружается...");

    // Инициализация всех заказов
    InitOrdersArray();

    SetTimer("CREATE_TABLE_COMPANY", 2900, false);

    // Создание входов в ТК
    for(new i; i < 2; i++)
    {
        CreateDynamicPickup(19135, 23, coord_tcompany[i][0], coord_tcompany[i][1], coord_tcompany[i][2], 0, 0);
        enter_tcompany[i] = CreateDynamicSphere(coord_tcompany[i][0], coord_tcompany[i][1], coord_tcompany[i][2], 2.0);

        new label_text[128];
        if(i == 0)
            format(label_text, sizeof label_text, ""tc_msg"\nВход в ТК {FFAE00}Батырево");
        else
            format(label_text, sizeof label_text, ""tc_msg"\nВход в ТК {FFAE00}Бусаево");

        Create3DTextLabel(label_text, -1,
            coord_tcompany[i][0], coord_tcompany[i][1], coord_tcompany[i][2], 10.0, 0);
    }

    // Выход из интерьера (общий для обоих миров)
    CreateDynamicPickup(19135, 23, coord_tcompany_exit[0], coord_tcompany_exit[1], coord_tcompany_exit[2], -1, 1);
    exit_tcompany = CreateDynamicSphere(coord_tcompany_exit[0], coord_tcompany_exit[1], coord_tcompany_exit[2], 1.0, -1, 1);
    Create3DTextLabel(""tc_msg"\nВыход из здания", -1,
        coord_tcompany_exit[0], coord_tcompany_exit[1], coord_tcompany_exit[2], 10.0, -1);

    // Пикап заказов (создаём для каждого мира)
    for(new i = 0; i < 2; i++)
    {
        CreateDynamicPickup(1274, 23, coord_tcompany_order[0], coord_tcompany_order[1], coord_tcompany_order[2], i+1, 1);
        pickup_orderd_tc = CreateDynamicSphere(coord_tcompany_order[0], coord_tcompany_order[1], coord_tcompany_order[2], 2.0, -1, 1);

        new label_text[128];
        if(i == 0)
            format(label_text, sizeof label_text, ""tc_msg"\nЗаказы для дальнобойщиков\n{FFFFFF}Населённый пункт: {FFAE00}Батырево");
        else
            format(label_text, sizeof label_text, ""tc_msg"\nЗаказы для дальнобойщиков\n{FFFFFF}Населённый пункт: {FFAE00}Бусаево");

        Create3DTextLabel(label_text, -1,
            coord_tcompany_order[0], coord_tcompany_order[1], coord_tcompany_order[2], 4.0, i+1);
    }

    // Обновление заказов
    UpdateOrderTC();
    SetTimer("UpdateOrderTC", TC_UPDATE_INTERVAL, true);

    #if defined tc_OnGameModeInit
        return tc_OnGameModeInit();
    #else
        return 1;
    #endif
}

//--------------------------------------------------------
//                      ИНИЦИАЛИЗАЦИЯ МАССИВА ЗАКАЗОВ
//--------------------------------------------------------
InitOrdersArray()
{
    // Координаты загрузки для каждого типа груза и локации
    new Float:loading_order_TC[9][2][3] =
    {
        {{2369.750000,1726.099243,13.457622}, {2369.750000,1726.099243,13.457622}},
        {{2058.106445,-2604.110351,10.619886}, {-2435.133056,2719.154785,39.636734}},
        {{598.226501,1757.621826,11.861831}, {-1311.768554,-1559.364135,60.801376}},
        {{1774.182983,2297.474853,15.664278}, {1774.182983,2297.474853,15.664278}},
        {{2738.700439,-2316.699707,17.697065}, {2738.700439,-2316.699707,17.697065}},
        {{-995.730895,2151.722656,44.348934}, {-995.730895,2151.722656,44.348934}},
        {{-995.730895,2151.722656,44.348934}, {-995.730895,2151.722656,44.348934}},
        {{598.226501,1757.621826,11.861831}, {-1311.768554,-1559.364135,60.801376}},
        {{598.226501,1757.621826,11.861831}, {-1311.768554,-1559.364135,60.801376}}
    };

    // Координаты финиша для каждого заказа (оставляем как в оригинале)
    // ... (тут координаты из оригинального массива orders_tc)

    // Заполняем массив заказов
    // Копируем из оригинального кода координаты финиша
    // ...

    return 1;
}

//--------------------------------------------------------
//                  ФУНКЦИИ WAYPOINT ДЛЯ ЗАКАЗОВ
//--------------------------------------------------------
stock SetPlayerLoadingWaypoint(playerid, orderid, locality, type)
{
    new Float:x, Float:y, Float:z;

    // Получаем координаты загрузки
    GetLoadingCoordsForOrder(orderid, locality, type, x, y, z);

    // Создаём waypoint с иконкой 56 (грузовик) или 58 (склад)
    SendCreateWayPoint(playerid, WAYPOINT_LOADING, x, y, z, 58, 0x00FF00AA, 50.0, -1);

    // Добавляем стандартную метку на карту для совместимости
    SetPlayerMapMarker(playerid, x, y, z, 58, 0x00FF00);

    SendClientMessage(playerid, -1, ""tc_msg"На карте отмечена {00FF00}зелёная метка {FFFFFF}- точка {FFAE00}загрузки{FFFFFF}.");
    return 1;
}

stock SetPlayerUnloadingWaypoint(playerid, orderid)
{
    new Float:x = orders_tc[orderid][o_TC_FinishPos][0];
    new Float:y = orders_tc[orderid][o_TC_FinishPos][1];
    new Float:z = orders_tc[orderid][o_TC_FinishPos][2];

    // Создаём waypoint с иконкой 55 (цель/флаг)
    SendCreateWayPoint(playerid, WAYPOINT_UNLOAD, x, y, z, 55, 0xFF0000AA, 50.0, -1);

    // Добавляем стандартную метку на карту
    SetPlayerMapMarker(playerid, x, y, z, 55, 0x0000FF);

    SendClientMessage(playerid, -1, ""tc_msg"На карте отмечена {0000FF}синяя метка {FFFFFF}- точка {FFAE00}разгрузки{FFFFFF}.");
    return 1;
}

stock ClearOrderWaypoints(playerid)
{
    SendDestroyWayPoint(playerid, WAYPOINT_LOADING);
    SendDestroyWayPoint(playerid, WAYPOINT_UNLOAD);
    RemovePlayerMapMarker(playerid);
    return 1;
}

//--------------------------------------------------------
//          ОБРАБОТЧИК ВХОДА В ЗОНУ (С WAYPOINT)
//--------------------------------------------------------
public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == enter_tcompany[0] || areaid == enter_tcompany[1])
    {
        new world = (areaid == enter_tcompany[0]) ? 1 : 2;
        SetPlayerVirtualWorld(playerid, world);
        SetPlayerInterior(playerid, 1);
        SetPlayerPos(playerid, -0.251249, 2501.8, 2011.005126);
        SetPlayerFacingAngle(playerid, 0.857749);

        // Удаляем waypoint при входе в здание
        ClearOrderWaypoints(playerid);
    }

    if(areaid == exit_tcompany)
    {
        new world = GetPlayerVirtualWorld(playerid);
        if(world == 2)
            SetPlayerPosEx(playerid, -426.906463, -1688.774536, 41.029911, 151.296875);
        else
            SetPlayerPosEx(playerid, 2327.662353, 2011.768310, 16.121875, 354.957916);

        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
    }

    if(areaid == pickup_orderd_tc)
    {
        if(player_tc[playerid][p_TC_Active])
            return SendClientMessage(playerid, -1, ""tc_msg"Сначала выполните текущий заказ!");

        new Locality = (GetPlayerVirtualWorld(playerid) == 2) ? TC_LOCALITY_BUSAEVO : TC_LOCALITY_BATUREVO;
        ShowDialogOrders(playerid, Locality);
    }

    if(areaid == player_tc[playerid][p_TC_Sphere_Finish])
    {
        if(player_tc[playerid][p_TC_Active] && player_tc[playerid][p_TC_Order] != -1)
        {
            ProcessOrderFinish(playerid, areaid);
        }
    }

    #if defined tc_OnPlayerEnterDynamicArea
        return tc_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}

//--------------------------------------------------------
//              ОБРАБОТЧИК ЗАВЕРШЕНИЯ ЗАКАЗА
//--------------------------------------------------------
ProcessOrderFinish(playerid, areaid)
{
    new vehicle = GetPlayerVehicleID(playerid);
    if(vehicle != player_tc[playerid][p_TC_Truck])
        return SendClientMessage(playerid, -1, ""tc_msg"Вы должны быть в своём рабочем транспорте!");

    new id = player_tc[playerid][p_TC_Order];

    // Проверка прицепа для грузовиков которым он нужен
    if(GetVehicleModel(vehicle) == 403)
    {
        new trailer = GetVehicleTrailer(vehicle);
        if(!trailer || player_tc[playerid][p_TC_Trailer] != trailer)
            return SendClientMessage(playerid, -1, ""tc_msg"У вас отсутствует или не ваш прицеп!");
    }

    switch(player_tc[playerid][p_TC_Progress_Order])
    {
        case 2: // Погрузка
        {
            GameTextForPlayer(playerid, "~y~ПОДОЖДИТЕ...~n~ПРИЦЕП ЗАГРУЖАЕТСЯ", 4000, 3);
            TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
            SetVehicleSpeed(vehicle, 0);
            SetVehicleParamsEx(vehicle, false, false, false, false, false, false, false);
            TogglePlayerControllable(playerid, false);

            SetTimerEx("LoadTrailerTC", 5000, false, "i", playerid);
            DisablePlayerCheckpoint(playerid);

            // Удаляем waypoint погрузки
            ClearOrderWaypoints(playerid);
        }
        case 3: // Разгрузка
        {
            GameTextForPlayer(playerid, "~y~ПОДОЖДИТЕ...~n~ПРИЦЕП РАЗГРУЖАЕТСЯ", 4000, 3);
            TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
            SetVehicleSpeed(vehicle, 0);
            SetVehicleParamsEx(vehicle, false, false, false, false, false, false, false);
            TogglePlayerControllable(playerid, false);

            SetTimerEx("LoadTrailerTC", 5000, false, "i", playerid);
            DisablePlayerCheckpoint(playerid);

            // Удаляем waypoint разгрузки
            ClearOrderWaypoints(playerid);
        }
    }
}

//--------------------------------------------------------
//              ЗАГРУЗКА/РАЗГРУЗКА ТРЕЙЛЕРА
//--------------------------------------------------------
public LoadTrailerTC(playerid)
{
    new id = player_tc[playerid][p_TC_Order];

    switch(player_tc[playerid][p_TC_Progress_Order])
    {
        case 2: // После погрузки - создаём точку разгрузки с waypoint
        {
            new Float:x = orders_tc[id][o_TC_FinishPos][0];
            new Float:y = orders_tc[id][o_TC_FinishPos][1];
            new Float:z = orders_tc[id][o_TC_FinishPos][2];

            SetPlayerCheckpoint(playerid, x, y, z, 10.0);

            if(IsValidDynamic3DTextLabel(player_tc[playerid][p_TC_Text]))
                DestroyDynamic3DTextLabel(player_tc[playerid][p_TC_Text]);
            if(IsValidDynamicArea(player_tc[playerid][p_TC_Sphere_Finish]))
                DestroyDynamicArea(player_tc[playerid][p_TC_Sphere_Finish]);

            // Создаём 3D текст для точки разгрузки
            player_tc[playerid][p_TC_Text] = CreateDynamic3DTextLabel(
                "{FFAE00}ТОЧКА РАЗГРУЗКИ\n{FFFFFF}Подъедьте ближе", -1,
                x, y, z, 15.0);

            player_tc[playerid][p_TC_Sphere_Finish] = CreateDynamicSphere(x, y, z, 8.0);

            // СОЗДАЁМ WAYPOINT НА КАРТЕ ДЛЯ РАЗГРУЗКИ
            SetPlayerUnloadingWaypoint(playerid, id);

            SendClientMessage(playerid, -1, ""tc_msg"Точка разгрузки отмечена на карте {0000FF}синей меткой{FFFFFF}. Удачной дороги!");

            // Запускаем двигатель
            new vehicle = GetPlayerVehicleID(playerid);
            SetVehicleParamsEx(vehicle, true, false, false, false, false, false, false);

            player_tc[playerid][p_TC_Progress_Order] = 3;
        }
        case 3: // После разгрузки - завершаем заказ
        {
            new vehicle = player_tc[playerid][p_TC_Truck];

            if(IsValidVehicle(player_tc[playerid][p_TC_Trailer]))
            {
                DetachTrailerFromVehicle(player_tc[playerid][p_TC_Trailer]);
                DestroyVehicle(player_tc[playerid][p_TC_Trailer]);
                player_tc[playerid][p_TC_Trailer] = -1;
            }

            SendClientMessage(playerid, -1, ""tc_msg"Вы успешно выполнили заказ!");

            new salary = orders_tc[id][o_TC_Salary];
            new string[144];

            // Бонус за высокий уровень
            if(player_tc[playerid][p_TC_Level] > 10)
            {
                new bonus = (player_tc[playerid][p_TC_Level] - 10) * 5;
                new procent = salary / 100 * bonus;
                salary += procent;

                format(string, sizeof string, ""tc_msg"Бонус за {FFAE00}+%d%% {FFFFFF}(уровень %d)",
                    bonus, player_tc[playerid][p_TC_Level]);
                SendClientMessage(playerid, -1, string);
            }

            GivePlayerMoneyEx(playerid, salary);
            format(string, sizeof string, ""tc_msg"Вы получили {FFAE00}%d {FFFFFF}руб.", salary);
            SendClientMessage(playerid, -1, string);

            GivePlayerExpTC(playerid, random(10) + 1);

            // Освобождаем заказ
            orders_tc[id][o_TC_Status] = TC_ORDER_NTAKE;
            orders_tc[id][o_TC_TakenBy] = -1;

            // Сбрасываем данные игрока
            ResetPlayerOrder(playerid);

            // Очищаем waypoint
            ClearOrderWaypoints(playerid);

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehicleParamsEx(vehicleid, true, false, false, false, false, false, false);
        }
    }

    TogglePlayerControllable(playerid, true);
    TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);
}

//--------------------------------------------------------
//              СБРОС ЗАКАЗА ИГРОКА
//--------------------------------------------------------
stock ResetPlayerOrder(playerid)
{
    player_tc[playerid][p_TC_Active] = false;
    player_tc[playerid][p_TC_Order] = -1;
    player_tc[playerid][p_TC_Progress_Order] = 0;

    if(IsValidVehicle(player_tc[playerid][p_TC_Truck]))
        DestroyVehicle(player_tc[playerid][p_TC_Truck]);
    player_tc[playerid][p_TC_Truck] = -1;

    if(IsValidVehicle(player_tc[playerid][p_TC_Trailer]))
        DestroyVehicle(player_tc[playerid][p_TC_Trailer]);
    player_tc[playerid][p_TC_Trailer] = -1;

    if(IsValidDynamic3DTextLabel(player_tc[playerid][p_TC_Text]))
        DestroyDynamic3DTextLabel(player_tc[playerid][p_TC_Text]);
    player_tc[playerid][p_TC_Text] = Text3D:-1;

    if(IsValidDynamicArea(player_tc[playerid][p_TC_Sphere_Finish]))
        DestroyDynamicArea(player_tc[playerid][p_TC_Sphere_Finish]);
    player_tc[playerid][p_TC_Sphere_Finish] = -1;

    // Очищаем waypoint
    ClearOrderWaypoints(playerid);
}

//--------------------------------------------------------
//              ВЗЯТИЕ ЗАКАЗА (С WAYPOINT)
//--------------------------------------------------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 2902) // Список заказов
    {
        if(!response) return 1;

        new id = GetPlayerListitemValue(playerid, listitem);

        // Проверка что заказ ещё доступен
        if(orders_tc[id][o_TC_Status] != TC_ORDER_NTAKE)
        {
            SendClientMessage(playerid, -1, ""tc_msg"Этот заказ уже кто-то взял!");
            return 1;
        }

        new player_level = player_tc[playerid][p_TC_Level];
        new required_level = GetRequiredLevelForOrder(orders_tc[id][o_TC_Type]);

        new string[512];
        new salary = orders_tc[id][o_TC_Salary];
        new bonus_text[128] = "";

        if(player_level > 10)
        {
            new bonus = GetPlayerIncreaseTC(playerid);
            new procent = salary / 100 * bonus;
            salary += procent;
            format(bonus_text, sizeof bonus_text, "\n{FFFFFF}С бонусом: {FFAE00}%d руб{FFFFFF} (+%d%%)", salary, bonus);
        }

        format(string, sizeof string,
            "{FFFFFF}Груз: {FFAE00}%s\n\
            {FFFFFF}Разгрузка: {FFAE00}%s\n\
            {FFFFFF}Требуемый уровень: {FFAE00}%d\n\
            {FFFFFF}Ваш уровень: {FFAE00}%d\n\
            {FFFFFF}Оплата: {FFAE00}%d руб%s\n\n\
            {FFFFFF}Вы уверены, что хотите взять этот заказ?",
            name_order_TC[orders_tc[id][o_TC_Type]-1],
            orders_tc[id][o_TC_Finish],
            required_level, player_level,
            orders_tc[id][o_TC_Salary], bonus_text
        );

        SetPVarInt(playerid, "selected_order", id);
        Dialog(playerid, 2903, DIALOG_STYLE_MSGBOX, "{FFAE00}Подтверждение заказа", string, "Взять", "Отмена");
    }

    if(dialogid == 2903) // Подтверждение заказа
    {
        if(!response)
        {
            DeletePVar(playerid, "selected_order");
            return 1;
        }

        new id = GetPVarInt(playerid, "selected_order");
        DeletePVar(playerid, "selected_order");

        // Повторная проверка доступности
        if(orders_tc[id][o_TC_Status] != TC_ORDER_NTAKE)
        {
            SendClientMessage(playerid, -1, ""tc_msg"Этот заказ уже недоступен!");
            return 1;
        }

        new player_level = player_tc[playerid][p_TC_Level];
        new required_level = GetRequiredLevelForOrder(orders_tc[id][o_TC_Type]);

        if(player_level < required_level && required_level > 0)
        {
            SendClientMessage(playerid, -1, ""tc_msg"Ваш уровень дальнобойщика слишком низок для этого заказа!");
            return 1;
        }

        StartOrder(playerid, id);
    }

    #if defined tc_OnDialogResponse
        return tc_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

//--------------------------------------------------------
//              СТАРТ ЗАКАЗА
//--------------------------------------------------------
StartOrder(playerid, orderid)
{
    new plant = GetPlayerVirtualWorld(playerid) - 1;
    if(plant < 0 || plant > 1) plant = 0;

    new r = random(7);
    new type = orders_tc[orderid][o_TC_Type] - 1;

    // Сохраняем информацию о заказе
    player_tc[playerid][p_TC_Active] = true;
    player_tc[playerid][p_TC_Order] = orderid;
    player_tc[playerid][p_TC_Progress_Order] = 1;

    // Отмечаем заказ как взятый
    orders_tc[orderid][o_TC_Status] = TC_ORDER_TAKE;
    orders_tc[orderid][o_TC_TakenBy] = playerid;

    // Спавним грузовик
    player_tc[playerid][p_TC_Truck] = CreateVehicle(
        type_truck[type],
        spawn_truck_tc[plant][r][0],
        spawn_truck_tc[plant][r][1],
        spawn_truck_tc[plant][r][2],
        spawn_truck_tc[plant][r][3],
        random(225), 0, 0
    );

    // Добавляем владельца к грузовику (для отображения компании)
    SetVehicleOwnerName(player_tc[playerid][p_TC_Truck], GetPlayerNameEx(playerid));

    PutPlayerInVehicle(playerid, player_tc[playerid][p_TC_Truck], 0);

    // Если нужен прицеп
    if(type_trailer[type] != -1)
    {
        SetPlayerCheckpoint(playerid,
            spawn_trailer_tc[plant][r][0],
            spawn_trailer_tc[plant][r][1],
            spawn_trailer_tc[plant][r][2], 7.0);

        player_tc[playerid][p_TC_Trailer] = CreateVehicle(
            type_trailer[type],
            spawn_trailer_tc[plant][r][0],
            spawn_trailer_tc[plant][r][1],
            spawn_trailer_tc[plant][r][2],
            spawn_trailer_tc[plant][r][3],
            random(225), 0, 0
        );

        SetVehicleOwnerName(player_tc[playerid][p_TC_Trailer], GetPlayerNameEx(playerid));

        SendClientMessage(playerid, -1, ""tc_msg"Заберите прицеп, отмеченный на карте, после чего езжайте к точке загрузки.");
    }
    else
    {
        // Если прицеп не нужен - сразу едем на загрузку
        new Float:x, Float:y, Float:z;
        GetLoadingCoordsForOrder(orderid, plant, type, x, y, z);

        SetPlayerCheckpoint(playerid, x, y, z, 10.0);
        player_tc[playerid][p_TC_Progress_Order] = 2;

        // СОЗДАЁМ WAYPOINT НА КАРТЕ ДЛЯ ЗАГРУЗКИ
        SetPlayerLoadingWaypoint(playerid, orderid, plant, type);

        // Создаём 3D текст
        player_tc[playerid][p_TC_Text] = CreateDynamic3DTextLabel(
            "{FFAE00}ТОЧКА ЗАГРУЗКИ\n{FFFFFF}Подъедьте ближе", -1,
            x, y, z, 15.0, _, _, _, 0, 0, playerid);

        player_tc[playerid][p_TC_Sphere_Finish] = CreateDynamicSphere(x, y, z, 5.0);

        SendClientMessage(playerid, -1, ""tc_msg"Отправляйтесь к точке загрузки, отмеченной {00FF00}зелёной меткой{FFFFFF} на карте.");
    }

    return 1;
}

//--------------------------------------------------------
//          ОБРАБОТЧИК ПРИЦЕПА (ДЛЯ WAYPOINT)
//--------------------------------------------------------
public OnTrailerUpdate(playerid, vehicleid)
{
    if(player_tc[playerid][p_TC_Progress_Order] == 1 && player_tc[playerid][p_TC_Order] != -1)
    {
        new id = player_tc[playerid][p_TC_Order];
        new type = orders_tc[id][o_TC_Type] - 1;
        new locality = orders_tc[id][o_TC_Locality] - 1;

        new Float:x, Float:y, Float:z;
        GetLoadingCoordsForOrder(id, locality, type, x, y, z);

        SetPlayerCheckpoint(playerid, x, y, z, 10.0);
        player_tc[playerid][p_TC_Progress_Order] = 2;

        // СОЗДАЁМ WAYPOINT НА КАРТЕ ПОСЛЕ ПОДЦЕПКИ ПРИЦЕПА
        SetPlayerLoadingWaypoint(playerid, id, locality, type);

        // Создаём 3D текст
        player_tc[playerid][p_TC_Text] = CreateDynamic3DTextLabel(
            "{FFAE00}ТОЧКА ЗАГРУЗКИ\n{FFFFFF}Подъедьте ближе", -1,
            x, y, z, 15.0);

        player_tc[playerid][p_TC_Sphere_Finish] = CreateDynamicSphere(x, y, z, 5.0);

        SendClientMessage(playerid, -1, ""tc_msg"Отправляйтесь к точке загрузки, отмеченной {00FF00}зелёной меткой{FFFFFF} на карте.");
    }

    #if defined tc_OnTrailerUpdate
        return tc_OnTrailerUpdate(playerid, vehicleid);
    #else
        return 1;
    #endif
}

//--------------------------------------------------------
//          ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
//--------------------------------------------------------
stock GetRequiredLevelForOrder(type)
{
    switch(type)
    {
        case 1..3: return 1;
        case 4..6: return 5;
        case 7..9: return 10;
    }
    return 1;
}

stock GetLoadingCoordsForOrder(orderid, locality, type, &Float:x, &Float:y, &Float:z)
{
    // Массив координат загрузки из оригинального кода
    new Float:loading_coords[9][2][3] =
    {
        {{2369.750000,1726.099243,13.457622}, {2369.750000,1726.099243,13.457622}},
        {{2058.106445,-2604.110351,10.619886}, {-2435.133056,2719.154785,39.636734}},
        {{598.226501,1757.621826,11.861831}, {-1311.768554,-1559.364135,60.801376}},
        {{1774.182983,2297.474853,15.664278}, {1774.182983,2297.474853,15.664278}},
        {{2738.700439,-2316.699707,17.697065}, {2738.700439,-2316.699707,17.697065}},
        {{-995.730895,2151.722656,44.348934}, {-995.730895,2151.722656,44.348934}},
        {{-995.730895,2151.722656,44.348934}, {-995.730895,2151.722656,44.348934}},
        {{598.226501,1757.621826,11.861831}, {-1311.768554,-1559.364135,60.801376}},
        {{598.226501,1757.621826,11.861831}, {-1311.768554,-1559.364135,60.801376}}
    };

    if(type >= 0 && type < 9 && locality >= 0 && locality < 2)
    {
        x = loading_coords[type][locality][0];
        y = loading_coords[type][locality][1];
        z = loading_coords[type][locality][2];
    }
    return 1;
}

stock GetPlayerIncreaseTC(playerid)
{
    return (player_tc[playerid][p_TC_Level] - 10) * 5;
}

//--------------------------------------------------------
//              КОМАНДА /TCSTATS (ОБНОВЛЕНА)
//--------------------------------------------------------
CMD:tcstats(playerid)
{
    new string[512];

    format(string, sizeof string,
        "{FFAE00}========== Статистика дальнобойщика ==========\n\
        {FFFFFF}Уровень: {FFAE00}%d\n\
        {FFFFFF}Опыт: {FFAE00}%d/100\n\
        {FFFFFF}До следующего уровня: {FFAE00}%d\n\
        {FFFFFF}Бонус к зарплате: {FFAE00}%d%%\n\
        {FFFFFF}Всего выполнено заказов: {FFAE00}%d\n\
        {FFAE00}==========================================",
        player_tc[playerid][p_TC_Level],
        player_tc[playerid][p_TC_Exp],
        100 - player_tc[playerid][p_TC_Exp],
        (player_tc[playerid][p_TC_Level] > 10) ? ((player_tc[playerid][p_TC_Level] - 10) * 5) : 0,
        GetPVarInt(playerid, "tc_completed_orders")
    );

    Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, "{FFAE00}Статистика", string, "Закрыть", "");
    return 1;
}

//--------------------------------------------------------
//              ОБРАБОТКА ВЫХОДА ИГРОКА
//--------------------------------------------------------
public OnPlayerDisconnect(playerid, reason)
{
    // Очищаем waypoint при выходе
    ClearOrderWaypoints(playerid);

    // Освобождаем заказ если был активен
    if(player_tc[playerid][p_TC_Active] && player_tc[playerid][p_TC_Order] != -1)
    {
        new orderid = player_tc[playerid][p_TC_Order];
        orders_tc[orderid][o_TC_Status] = TC_ORDER_NTAKE;
        orders_tc[orderid][o_TC_TakenBy] = -1;
    }

    // Удаляем транспорт
    if(IsValidVehicle(player_tc[playerid][p_TC_Truck]))
        DestroyVehicle(player_tc[playerid][p_TC_Truck]);
    if(IsValidVehicle(player_tc[playerid][p_TC_Trailer]))
        DestroyVehicle(player_tc[playerid][p_TC_Trailer]);

    #if defined tc_OnPlayerDisconnect
        return tc_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
