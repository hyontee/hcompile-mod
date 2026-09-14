
#define tc_msg "{FFAE00}[Транспортная компания] {FFFFFF}"

#define LEVEL_START_TC  10 //Поменяйте на уровень с которого будет доступен дальнобойщик

enum PLAYER_COMPANY
{
    p_TC_Owner,
    p_TC_Copmany,
    bool:p_TC_Active,

    p_TC_Order,
    p_TC_Progress_Order,
    Text3D:p_TC_Text,
    p_TC_Sphere_Finish,

    p_TC_Truck,
    p_TC_Trailer,
    p_TC_Level,
    p_TC_Exp
};

new player_tc[MAX_PLAYERS][PLAYER_COMPANY];

#define GetPlayerIncreaseTC(%0)   (player_tc[%0][p_TC_Level]-10) * 5


#define TC_LOCALITY_BUSAEVO    2
#define TC_LOCALITY_BATUREVO  1

#define TC_ORDER_NLOAD 0
#define TC_ORDER_NTAKE 1
#define TC_ORDER_TAKE 2

#define TC_TYPE_ORDER_COAL 1
#define TC_TYPE_ORDER_METAL 2
#define TC_TYPE_ORDER_OZON 3
#define TC_TYPE_ORDER_PETROL 4
#define TC_TYPE_ORDER_PRODUCTS 5
#define TC_TYPE_ORDER_TECHNOLOGY 6
#define TC_TYPE_ORDER_GLASS 7
#define TC_TYPE_ORDER_BANANS 8
#define TC_TYPE_ORDER_WATERMELON 9

new name_order_TC[9][24] =
{
    {"Уголь"},
    {"Металл"},
    {"Заказы Озон"},
    {"Бензин"},
    {"Продукты"},
    {"Электроприборы"},
    {"Стекло"},
    {"Бананы"},
    {"Арбузы"}
};

new salary_order_TC[9][2] =
{
    {40000, 10000},
    {35000, 10000},
    {50000, 5000},

    {65000, 35000},
    {50000, 50000},
    {90000, 30000},

    {95000, 15000},
    {120000, 120000},
    {200000, 10000}
};

new type_trailer[9] = {450,435,-1,584,-1,435,591,-1,-1};
new type_truck[9] = {403,403,498,403,498,403,403,413,413};

new open_order_lvl[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

enum ORDER_TC
{
    o_TC_Type,
    o_TC_Locality,
    Float:o_TC_FinishPos[3],
    o_TC_Status,
    o_TC_Salary,
    o_TC_Finish[54]
};


new orders_tc[40][ORDER_TC] = 
{
    {TC_TYPE_ORDER_COAL, TC_LOCALITY_BUSAEVO, {-2435.133789,2712.665527,39.636734}, TC_ORDER_NLOAD, 0, "Склад \"г.Эдово\""},
    {TC_TYPE_ORDER_COAL, TC_LOCALITY_BUSAEVO, {598.226501,1757.621826,11.861831}, TC_ORDER_NLOAD, 0, "Контейнерная площадка"},
    {TC_TYPE_ORDER_METAL, TC_LOCALITY_BUSAEVO, {-2210.867187,-415.374481,29.209861}, TC_ORDER_NLOAD, 0, "Городское строительство \"г.Арзамас\""},
    {TC_TYPE_ORDER_METAL, TC_LOCALITY_BUSAEVO, {2058.106445,-2604.110351,10.619886}, TC_ORDER_NLOAD, 0, "Депо \"г.Южный\""},
    {TC_TYPE_ORDER_METAL, TC_LOCALITY_BUSAEVO, {2738.700439,-2316.699707,17.697065}, TC_ORDER_NLOAD, 0, "Склад \"г.Южный\""},
    {TC_TYPE_ORDER_OZON, TC_LOCALITY_BUSAEVO, {-2401.122314,10.525905,25.986291}, TC_ORDER_NLOAD, 0, "Пункт выдачи №1"},
    {TC_TYPE_ORDER_OZON, TC_LOCALITY_BUSAEVO, {144.481414,383.239746,15.635400}, TC_ORDER_NLOAD, 0, "Пункт выдачи №4"},
    {TC_TYPE_ORDER_PETROL, TC_LOCALITY_BUSAEVO, {2273.441162,-704.361145,13.17}, TC_ORDER_NLOAD, 0, "АЗС №1"},
    {TC_TYPE_ORDER_PETROL, TC_LOCALITY_BUSAEVO, {2746.985351,730.965515,30.781}, TC_ORDER_NLOAD, 0, "АЗС №2"},
    {TC_TYPE_ORDER_PRODUCTS, TC_LOCALITY_BUSAEVO, {2329.867675,-1923.195190,21.90}, TC_ORDER_NLOAD, 0, "Продуктовый магазин №1"},
    {TC_TYPE_ORDER_PRODUCTS, TC_LOCALITY_BUSAEVO, {-508.971923,-1560.070434,41.18}, TC_ORDER_NLOAD, 0, "Продуктовый магазин №2"},
    {TC_TYPE_ORDER_PRODUCTS, TC_LOCALITY_BUSAEVO, {100.912979,816.841613,12.01930}, TC_ORDER_NLOAD, 0, "Продуктовый магазин №3"},
    {TC_TYPE_ORDER_TECHNOLOGY, TC_LOCALITY_BUSAEVO, {-2437.050781,-172.995223,27.44}, TC_ORDER_NLOAD, 0, "Супермаркет \"г.Лыткарино\""},
    {TC_TYPE_ORDER_TECHNOLOGY, TC_LOCALITY_BUSAEVO, {-2476.282226,2772.179199,37.43}, TC_ORDER_NLOAD, 0, "Торговый центр \"г.Эдово\""},
    {TC_TYPE_ORDER_GLASS, TC_LOCALITY_BUSAEVO, {-2210.867187,-415.374481,29.209861}, TC_ORDER_NLOAD, 0, "Городское строительство \"г.Арзамас\""},
    {TC_TYPE_ORDER_GLASS, TC_LOCALITY_BUSAEVO, {-24.590059,1805.262939,9.197439}, TC_ORDER_NLOAD, 0, "Городское строительство \"г.Лыткарино\""},
    {TC_TYPE_ORDER_GLASS, TC_LOCALITY_BUSAEVO, {598.226501,1757.621826,11.861831}, TC_ORDER_NLOAD, 0, "Контейнерная площадка"},
    {TC_TYPE_ORDER_BANANS, TC_LOCALITY_BUSAEVO, {-2420.096923,-263.920196,26.99}, TC_ORDER_NLOAD, 0, "Супермаркет \"г.Лыткарино\""},
    {TC_TYPE_ORDER_BANANS, TC_LOCALITY_BUSAEVO, {568.488647,947.387084,11.64748}, TC_ORDER_NLOAD, 0, "Азбука Вкуса \"г.Арзамас\""},
    {TC_TYPE_ORDER_WATERMELON, TC_LOCALITY_BUSAEVO, {-2639.756835,2879.549072,37.632}, TC_ORDER_NLOAD, 0, "Неизвестный заказчик"},
    {TC_TYPE_ORDER_COAL,  TC_LOCALITY_BATUREVO, {-995.730895,2151.722656,44.348934}, TC_ORDER_NLOAD, 0, "Завод \"г.Арзамас\""},
    {TC_TYPE_ORDER_COAL,  TC_LOCALITY_BATUREVO, {598.226501,1757.621826,11.861831}, TC_ORDER_NLOAD, 0, "Контейнерная площадка"},
    {TC_TYPE_ORDER_METAL, TC_LOCALITY_BATUREVO, {-24.590059,1805.262939,9.197439}, TC_ORDER_NLOAD, 0, "Городское строительство \"г.Лыткарино\""},
    {TC_TYPE_ORDER_METAL, TC_LOCALITY_BATUREVO, {2058.106445,-2604.110351,10.619886}, TC_ORDER_NLOAD, 0, "Депо \"г.Южный\""},
    {TC_TYPE_ORDER_METAL, TC_LOCALITY_BATUREVO, {-2435.133789,2712.665527,39.636734}, TC_ORDER_NLOAD, 0, "Склад \"г.Эдово\""},
    {TC_TYPE_ORDER_OZON,  TC_LOCALITY_BATUREVO, {-2399.693603,-0.686437,25.999822}, TC_ORDER_NLOAD, 0, "Пункт выдачи №2"},
    {TC_TYPE_ORDER_OZON,  TC_LOCALITY_BATUREVO, {676.783447,273.557373,12.856797}, TC_ORDER_NLOAD, 0, "Пункт выдачи №3"},
    {TC_TYPE_ORDER_PETROL,  TC_LOCALITY_BATUREVO, {2606.705078,2578.849121,16.18}, TC_ORDER_NLOAD, 0, "АЗС №3"},
    {TC_TYPE_ORDER_PETROL,  TC_LOCALITY_BATUREVO, {-2503.146972,-693.505493,29.3}, TC_ORDER_NLOAD, 0, "АЗС №4"},
    {TC_TYPE_ORDER_PRODUCTS,  TC_LOCALITY_BATUREVO, {-15.615036,954.794677,11.682}, TC_ORDER_NLOAD, 0, "Продуктовый магазин №5"},
    {TC_TYPE_ORDER_PRODUCTS,  TC_LOCALITY_BATUREVO, {409.448211,1940.463623,8.148}, TC_ORDER_NLOAD, 0, "Продуктовый магазин №4"},
    {TC_TYPE_ORDER_PRODUCTS,  TC_LOCALITY_BATUREVO, {-1738.667602,764.833312,35.3}, TC_ORDER_NLOAD, 0, "Продуктовый магазин №6"},
    {TC_TYPE_ORDER_TECHNOLOGY, TC_LOCALITY_BATUREVO, {2721.642089,-1630.229980,23.10}, TC_ORDER_NLOAD, 0, "Строительная компания"},
    {TC_TYPE_ORDER_TECHNOLOGY, TC_LOCALITY_BATUREVO, {225.049224,375.714019,15.59920}, TC_ORDER_NLOAD, 0, "Склад магазинов \"г.Арзамас\""},
    {TC_TYPE_ORDER_GLASS,  TC_LOCALITY_BATUREVO, {-2210.867187,-415.374481,29.209861}, TC_ORDER_NLOAD, 0, "Городское строительство \"г.Арзамас\""},
    {TC_TYPE_ORDER_GLASS,  TC_LOCALITY_BATUREVO, {-24.590059,1805.262939,9.197439}, TC_ORDER_NLOAD, 0, "Городское строительство \"г.Лыткарино\""},
    {TC_TYPE_ORDER_GLASS,  TC_LOCALITY_BATUREVO, {598.226501,1757.621826,11.861831}, TC_ORDER_NLOAD, 0, "Контейнерная площадка"},
    {TC_TYPE_ORDER_BANANS,  TC_LOCALITY_BATUREVO, {134.547683,610.323303,11.58130}, TC_ORDER_NLOAD, 0, "Пятёрочка \"г.Арзамас\""},
    {TC_TYPE_ORDER_BANANS,  TC_LOCALITY_BATUREVO, {-2420.196289,-238.634353,26.99}, TC_ORDER_NLOAD, 0, "Супермаркет \"г.Лыткарино\""},
    {TC_TYPE_ORDER_WATERMELON, TC_LOCALITY_BATUREVO, {-2534.645263,1749.024536,53.025}, TC_ORDER_NLOAD, 0, "Неизвестный заказчик"}
};

new enter_tcompany[2], exit_tcompany, pickup_orderd_tc;

new Float:loading_order_TC[9][2][3] =
{
    {{2369.750000,1726.099243,13.457622},   {2369.750000,1726.099243,13.457622}},
    {{2058.106445,-2604.110351,10.619886},  {-2435.133056,2719.154785,39.636734}},
    {{598.226501,1757.621826,11.861831},    {-1311.768554,-1559.364135,60.801376}},
    {{1774.182983,2297.474853,15.664278},   {1774.182983,2297.474853,15.664278}},
    {{2738.700439,-2316.699707,17.697065},  {2738.700439,-2316.699707,17.697065}},
    {{-995.730895,2151.722656,44.348934},   {-995.730895,2151.722656,44.348934}},
    {{-995.730895,2151.722656,44.348934},   {-995.730895,2151.722656,44.348934}},
    {{598.226501,1757.621826,11.861831},    {-1311.768554,-1559.364135,60.801376}},
    {{598.226501,1757.621826,11.861831},    {-1311.768554,-1559.364135,60.801376}}
};

new Float:coord_tcompany[2][3] =
{
    {2327.637207,2009.636962,16.620204},
    {-426.065887,-1687.605712,41.526901}
};

new Float:coord_tcompany_exit[3] = {-0.251249,2500.500000,2011.005126};
new Float:coord_tcompany_order[3] = {2.028566,2503.603271,2011.005126};

new Float:spawn_trailer_tc[2][7][4] =
{
    {
       {2287.05,2057.90,15.66,182.79},
       {2296.59,2058.41,15.67,182.79},
       {2307.05,2059.09,15.67,182.79},
       {2316.68,2059.64,15.66,182.79},
       {2342.84,2058.12,15.67,182.79},
       {2348.80,2058.29,15.67,182.79},
       {2355.14,2058.69,15.66,182.79}
    },
    {
       {-386.51,-1738.53,40.6,329.76},
       {-392.66,-1737.33,40.6,329.76},
       {-397.25,-1733.01,40.6,329.76},
       {-402.83,-1731.03,40.6,329.76},
       {-408.05,-1728.22,40.6,329.76},
       {-412.63,-1723.96,40.6,329.76},
       {-417.88,-1720.82,40.6,329.76}
    }
};

new Float:spawn_truck_tc[2][7][4] = 
{
    {
       {2313.00,1992.95,15.66,2.06},
       {2306.60,1992.98,15.67,2.06},
       {2300.28,1992.31,15.66,2.06},
       {2293.74,1992.36,15.67,2.06},
       {2287.03,1993.11,15.66,2.06},
       {2280.16,1992.92,15.67,2.06},
       {2272.57,1992.89,15.67,2.06}
    },
    {
       {-406.06,-1689.130,40.6,149.76},
       {-401.08,-1692.530,40.6,149.76},
       {-395.73,-1695.842,40.6,149.76},
       {-389.30,-1699.543,40.6,149.76},
       {-384.53,-1702.104,40.6,149.76},
       {-379.12,-1705.562,40.6,149.76},
       {-374.09,-1709.198,40.6,149.76}
    }
};

public CREATE_TABLE_COMPANY()
{
    mysql_query(mysql, "SELECT * FROM accounts WHERE progress_company AND t_company AND tc_owner", false);

    if(mysql_errno()) mysql_query(mysql, "ALTER TABLE `accounts` ADD `progress_company` FLOAT NOT NULL DEFAULT '1.0' AFTER `job`, ADD `t_company` INT NOT NULL DEFAULT\
     '-1' AFTER `progress_company`, ADD `tc_owner` INT NOT NULL DEFAULT '-1' AFTER `t_company`", false);

    return 1;
}

public LoadPlayerProgressTC(playerid)
{
    new string[124], Cache:cache;
    mysql_format(mysql, string, sizeof string, "SELECT progress_company FROM accounts WHERE id=%d", GetPlayerAccountID(playerid));
    cache = mysql_query(mysql, string);

    new Float:float_progress = cache_get_row_float(0, 0);

    sscanf(floatttostring(float_progress), "P<.>dd", player_tc[playerid][p_TC_Level],player_tc[playerid][p_TC_Exp]);

    printf("[SYSTEM] Player:%d | Level_TC: %d | Exp_TC: %d", playerid, player_tc[playerid][p_TC_Level],player_tc[playerid][p_TC_Exp]);

    cache_delete(cache);
    return 1;
}

stock GivePlayerExpTC(playerid, count)
{
    new exp_player = player_tc[playerid][p_TC_Exp], level_up;

    exp_player += count;

    if(exp_player >= 100)
    {
        level_up = exp_player / 100; 
        new exp_remainder = exp_player % 100;

        player_tc[playerid][p_TC_Level] += level_up;
        player_tc[playerid][p_TC_Exp] = exp_remainder;
    }
    else {
        player_tc[playerid][p_TC_Exp] += count;
    }

    new string[12], query[84];

    format(string, sizeof string, "%d.%d", player_tc[playerid][p_TC_Level], player_tc[playerid][p_TC_Exp]);

    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET progress_company=%2f WHERE id=%d", floatstr(string), GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    if(!mysql_errno())
    {
        new message[144];
        format(message, sizeof message, ""tc_msg"Вы получили {FFAE00}%d{FFFFFF} опыт(a) дальнобойщика.", count);
        SendClientMessage(playerid, -1, message);

        if(level_up) {
            format(message, sizeof message, ""tc_msg"Поздравляем! Вы получили {FFAE00}%d{FFFFFF} уровень дальнобойщика. Ваш заработок увеличен",
            player_tc[playerid][p_TC_Level]);
            SendClientMessage(playerid, -1, message);
        }

        format(message, sizeof message, ""tc_msg"На данный момент у вас {FFAE00}%d{FFFFFF} уровень и {FFAE00}%d{FFFFFF} опыта дальнобойщика.",
        player_tc[playerid][p_TC_Level], player_tc[playerid][p_TC_Exp]);
        SendClientMessage(playerid, -1, message);
    }

    return 1;
}

stock floatttostring(Float:float)
{
    new string[32];
    format(string, sizeof string, "%.2f", float);
    return string;
}

public OnPlayerConnect(playerid)
{
    SetTimerEx("LoadPlayerProgressTC", 3000, false, "i", playerid);
    #if defined tc_OnPlayerConnect
        return tc_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect tc_OnPlayerConnect
#if defined tc_OnPlayerConnect
    forward tc_OnPlayerConnect(playerid);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == enter_tcompany[0] || areaid == enter_tcompany[1])
    {
        if(areaid == enter_tcompany[0]) SetPlayerVirtualWorld(playerid, 1);
        else SetPlayerVirtualWorld(playerid, 2);

        SetPlayerInterior(playerid, 1);
        SetPlayerPos(playerid, -0.251249,2501.8,2011.005126);
        SetPlayerFacingAngle(playerid, 0.857749);
    }
    if(areaid == exit_tcompany)
    {
        if(GetPlayerVirtualWorld(playerid) == 2) SetPlayerPosEx(playerid, -426.906463,-1688.774536,41.029911,151.296875, 0, 0);
        else SetPlayerPosEx(playerid, 2327.662353,2011.768310,16.121875,354.957916, 0, 0);
    }
    if(areaid == pickup_orderd_tc)
    {
        new Locality;
        if(GetPlayerVirtualWorld(playerid) == 2) Locality = TC_LOCALITY_BUSAEVO;
        else Locality = TC_LOCALITY_BATUREVO;

        ShowDialogOrders(playerid, Locality);
    }

    if(areaid == player_tc[playerid][p_TC_Sphere_Finish])
    {
        if(player_tc[playerid][p_TC_Progress_Order] && player_tc[playerid][p_TC_Order] != -1)
        {
            new vehicle = GetPlayerVehicleID(playerid);

            if(vehicle != player_tc[playerid][p_TC_Truck])
                return SendClientMessage(playerid, -1, ""tc_msg"Вы должны находится в своём рабочем транспорте.");

            new id = player_tc[playerid][p_TC_Order], type = orders_tc[id][o_TC_Type], locality = orders_tc[id][o_TC_Locality];

            if(GetVehicleModel(vehicle) == 403)
            {
                new trailer = GetVehicleTrailer(vehicle);

                if(!trailer) 
                    return SendClientMessage(playerid, -1, ""tc_msg"У вас отсуствует прицеп.");

                if(player_tc[playerid][p_TC_Trailer] != trailer)
                    return SendClientMessage(playerid, -1, ""tc_msg"Это не ваш прицеп.");
            }
            switch(player_tc[playerid][p_TC_Progress_Order])
            {
                case 2:
                {       
                    GameTextForPlayer(playerid, "~y~ПОДОЖДИТЕ...~n~ПРИЦЕП ЗАГРУЖАЕТСЯ", 4000, 3);
                    TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
                    SetVehicleSpeed(vehicle, 0);
                    SetVehicleParam(vehicle, V_ENGINE, false);

                    SetTimerEx("LoadTrailerTC", 5000, false, "i", playerid);
                    DisablePlayerCheckpoint(playerid);

                    TogglePlayerControllable(playerid, false);
                }
                case 3:
                {
                    GameTextForPlayer(playerid, "~y~ПОДОЖДИТЕ...~n~ПРИЦЕП РАЗГРУЖАЕТСЯ", 4000, 3);
        
                    TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
                    SetVehicleSpeed(vehicle, 0);
                    SetVehicleParam(vehicle, V_ENGINE, false);
                    SetTimerEx("LoadTrailerTC", 5000, false, "i", playerid);
                    DisablePlayerCheckpoint(playerid);
                    TogglePlayerControllable(playerid, false);
                }
            }
        }
    }
    #if defined tc_OnPlayerEnterDynamicArea
        return tc_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea tc_OnPlayerEnterDynamicArea
#if defined tc_OnPlayerEnterDynamicArea
    forward tc_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnGameModeInit()
{
    print("[SYSTEM] Система работы дальнобойщика загружена.");
    SetTimer("CREATE_TABLE_COMPANY", 2900, false);
    
    for(new i, string[114]; i < 2; i++)
    {
        CreateDynamicPickup(19135, 23, coord_tcompany[i][0], coord_tcompany[i][1], coord_tcompany[i][2], 0, 0);
        enter_tcompany[i] = CreateDynamicSphere(coord_tcompany[i][0], coord_tcompany[i][1], coord_tcompany[i][2], 2.0, 0, 0);
        Create3DTextLabel(""tc_msg"\nВход в здание", -1, coord_tcompany[i][0], coord_tcompany[i][1], coord_tcompany[i][2], 10.0, 0);

        CreateDynamicPickup(19135, 23, coord_tcompany_exit[0], coord_tcompany_exit[1], coord_tcompany_exit[2], i+1, 1);
        exit_tcompany = CreateDynamicSphere(coord_tcompany_exit[0], coord_tcompany_exit[1], coord_tcompany_exit[2], 1.0, -1, 1);
        Create3DTextLabel(""tc_msg"\nВыход из здания", -1, coord_tcompany_exit[0], coord_tcompany_exit[1], coord_tcompany_exit[2], 10.0, i+1);

        CreateDynamicPickup(1274, 23, coord_tcompany_order[0], coord_tcompany_order[1], coord_tcompany_order[2], i, 1);
        pickup_orderd_tc = CreateDynamicSphere(coord_tcompany_order[0], coord_tcompany_order[1], coord_tcompany_order[2], 2.0, -1, 1);
        
        if(!i) format(string, sizeof string, ""tc_msg"\nЗаказы для дальнобойщиков\n{FFFFFF}Населённый пункт:{FFAE00} Батырево");
        else format(string, sizeof string, ""tc_msg"\nЗаказы для дальнобойщиков\n{FFFFFF}Населённый пункт:{FFAE00} Бусаево");
        
        Create3DTextLabel(string, -1, coord_tcompany_order[0], coord_tcompany_order[1], coord_tcompany_order[2], 4.0, i+1);
    }

    // Исправленные акторы без лишних параметров
    CreateDynamicActor(228, -2639.756835,2879.549072,37.632812,177.616, false);
    CreateDynamicActor(89, -2534.645263,1749.024536,53.025150,299.114, false);

    for(new i; i < 2; i++)
    {
        for(new e,order_lvl[3]; e < 3; e++)
        {
            if(order_lvl[e] >= 5) continue;

            for(new o, type, salary; o < sizeof orders_tc; o++)
            {
                if(orders_tc[o][o_TC_Locality] != i+1) continue;
                else if(!(open_order_lvl[e][0] <= orders_tc[o][o_TC_Type] <= open_order_lvl[e][2])) continue;       
                else if(orders_tc[o][o_TC_Status] != TC_ORDER_NLOAD) continue; 

                orders_tc[o][o_TC_Status] = TC_ORDER_NTAKE;
                type = orders_tc[o][o_TC_Type]-1;
                orders_tc[o][o_TC_Salary] = random(salary_order_TC[type][1]) + salary_order_TC[type][0];
                order_lvl[e]++; 
            } 
        } 
    }

    SetTimer("UpdateOrderTC", 2000*60, true);

    #if defined tc_OnGameModeInit
        return tc_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit tc_OnGameModeInit
#if defined tc_OnGameModeInit
    forward tc_OnGameModeInit();
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 2902)
    {
        if(!response) return 1;
        
        new id = GetPlayerListitemValue(playerid, listitem);
        new string[484], salary_txt[114] = "", salary = orders_tc[id][o_TC_Salary];
        new level_txt[78], level;
        new player_level = player_tc[playerid][p_TC_Level];

        switch(orders_tc[id][o_TC_Type])
        {
            case TC_TYPE_ORDER_COAL: level = 1;
            case TC_TYPE_ORDER_METAL: level = 1;
            case TC_TYPE_ORDER_OZON: level = 1;
            case TC_TYPE_ORDER_PETROL: level = 2;
            case TC_TYPE_ORDER_PRODUCTS: level = 2;
            case TC_TYPE_ORDER_TECHNOLOGY: level = 2;
            case TC_TYPE_ORDER_GLASS: level = 3;
            case TC_TYPE_ORDER_BANANS: level = 3;
            case TC_TYPE_ORDER_WATERMELON: level = 3;
        }

        if(player_level < level)
            format(level_txt, sizeof level_txt, "{FF0000}(Требуется %d уровень дальнобойщика)", level);
 