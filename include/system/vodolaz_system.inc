// vodolaz_system.inc

#if defined _vodolaz_system_included
    #endinput
#endif
#define _vodolaz_system_included


// ===== Работа: Водолаз =====
#define VODOLAZ_NOTIFY_ITEM       81
#define VODOLAZ_NOTIFY_CAPTAIN    82

#define DIALOG_VODOLAZ_MAIN       58901
#define DIALOG_VODOLAZ_RENT       58902
#define DIALOG_VODOLAZ_RENT_CONFIRM 58903
#define DIALOG_VODOLAZ_TASKS      58904
#define DIALOG_VODOLAZ_SELL       58909

// ===== Данные работы водолаза =====
new VodolazCaptainArea[4];
new VodolazYgAreas[6];
new VodolazBatAreas1[7];
new VodolazBatAreas2[6];
new VodolazLitAreas1[6];
new VodolazLitAreas2[6];
new VodolazYzkaAreas[7];
new VodolazBoatID[MAX_PLAYERS];

new VodolazBoatPrices[] =
{
    7000,
    15000,
    17000,
    20000,
    45000,
    100000
};

enum E_VODOLAZ_ITEMS
{
    vYgCollected[6],
    vBat1Collected[7],
    vBat2Collected[6],
    vLit1Collected[6],
    vLit2Collected[6],
    vYzkaCollected[7]
}
new VodolazCollected[MAX_PLAYERS][E_VODOLAZ_ITEMS];

new VodolazItemNames[][64] =
{
    "Стиральная машина",
    "Колесо внедорожника",
    "Старинная ваза",
    "Якорь корабля",
    "Мотор лодочный",
    "Золотая цепь"
};

new VodolazItemPrices[] =
{
    21000,
    22000,
    24000,
    23000,
    20000,
    25000
};

new VodolazBoatNames[][32] =
{
    "Гидроцикл",
    "Моторная лодка",
    "Speedy Yacht",
    "Marine Yacht",
    "Sea Yacht",
    "Ocean Yacht"
};

new VodolazBoatModels[] =
{
    473,
    472,
    493,
    452,
    453,
    454
};

new Float:VodolazCrashPoints[6][3] =
{
    {-2469.009277, 579.343261, -0.550000},
    {-1897.012817, -513.759460, -0.550000},
    {1459.005371, -1838.905883, -0.550000},
    {2739.108886, 224.467178, -0.550000},
    {1514.171020, 129.642410, -0.550000},
    {2861.607910, -1165.949462, -0.550000}
};

enum E_VODOLAZ_BOAT_POS
{
    Float:vodoPosX,
    Float:vodoPosY,
    Float:vodoPosZ,
    Float:vodoPosA
}

new VodolazBoatSpawnSouth[][E_VODOLAZ_BOAT_POS] =
{
    {2484.252197, -1235.883178, -0.800403, 36.087886},
    {2499.357177, -1228.727783, -0.544732, 6.103890},
    {2514.747070, -1229.557250, -0.544732, 351.048431},
    {2528.980712, -1235.333496, -0.544748, 321.481231},
    {2537.453857, -1243.588989, -0.801097, 323.264831}
};

new VodolazBoatSpawnA[][E_VODOLAZ_BOAT_POS] =
{
    {681.311767, 155.555221, -0.168156, 184.687622},
    {670.662048, 157.195251, -0.032777, 174.723907},
    {660.937194, 157.427490, -0.032965, 188.136123},
    {650.579589, 157.222229, -0.206876, 187.75630},
    {640.811462, 155.052581, -0.032689, 181.975753}
};

new VodolazBoatSpawnB[][E_VODOLAZ_BOAT_POS] =
{
    {2367.010253, 289.144042, 1.262846, 186.726348},
    {2352.787353, 284.411468, -0.167348, 193.099563},
    {2340.795410, 284.272491, -0.169282, 189.794570},
    {2316.613525, 287.917694, -0.032778, 179.226531},
    {2302.809570, 288.758605, -0.170388, 184.518768}
};

new VodolazBoatSpawnL[][E_VODOLAZ_BOAT_POS] =
{
    {-2519.548339, 363.730804, -0.032780, 268.533996},
    {-2520.387451, 377.281982, -0.165156, 274.241729},
    {-2521.538574, 390.698913, -0.166875, 260.146026},
    {-2539.335937, 363.776123, -0.034559, 88.848045},
    {-2541.254394, 377.489624, -0.162565, 89.772666}
};

stock Vodolaz_ResetPlayer(playerid)
{
    VodolazBoatID[playerid] = INVALID_VEHICLE_ID;
    SetPlayerData(playerid, P_VODO_ITEMS, 0);
    SetPlayerData(playerid, P_VODO_TIME, 0);
    SetPlayerData(playerid, P_VODO_TASK, 0);

    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vYgCollected][i] = 0;
    for(new i = 0; i < 7; i++) VodolazCollected[playerid][vBat1Collected][i] = 0;
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vBat2Collected][i] = 0;
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vLit1Collected][i] = 0;
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vLit2Collected][i] = 0;
    for(new i = 0; i < 7; i++) VodolazCollected[playerid][vYzkaCollected][i] = 0;
    return 1;
}

stock Vodolaz_DestroyPlayerBoat(playerid)
{
    if(VodolazBoatID[playerid] != INVALID_VEHICLE_ID)
    {
        if(IsValidVehicle(VodolazBoatID[playerid])) DestroyVehicle(VodolazBoatID[playerid]);
        VodolazBoatID[playerid] = INVALID_VEHICLE_ID;
    }
    return 1;
}

stock Vodolaz_ResetCollected(playerid)
{
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vYgCollected][i] = 0;
    for(new i = 0; i < 7; i++) VodolazCollected[playerid][vBat1Collected][i] = 0;
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vBat2Collected][i] = 0;
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vLit1Collected][i] = 0;
    for(new i = 0; i < 6; i++) VodolazCollected[playerid][vLit2Collected][i] = 0;
    for(new i = 0; i < 7; i++) VodolazCollected[playerid][vYzkaCollected][i] = 0;
    return 1;
}

stock Vodolaz_Init()
{
    VodolazCaptainArea[0] = CreateDynamicSphere(-2528.527832, 357.601684, 2.100287, 5.0);
    VodolazCaptainArea[1] = CreateDynamicSphere(652.959899, 173.051406, 2.081145, 5.0);
    VodolazCaptainArea[2] = CreateDynamicSphere(2273.179443, 310.147216, 4.039990, 5.0);
    VodolazCaptainArea[3] = CreateDynamicSphere(2501.043701, -1253.509033, 1.436212, 5.0);

    CreateActor(236, 652.252075, 173.563812, 2.041145, 183.585617);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Подойдите для взаимодействия", -1, 652.252075, 173.563812, 2.041145, 15.0, 0);
    CreateActor(236, 2272.684570, 309.651611, 4.000000, 344.699798);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Подойдите для взаимодействия", -1, 2272.684570, 309.651611, 4.000000, 15.0, 0);
    CreateActor(236, 2500.639648, -1252.934204, 1.396202, 207.274276);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Подойдите для взаимодействия", -1, 2500.639648, -1252.934204, 1.396202, 15.0, 0);
    CreateActor(236, -2527.409423, 358.139892, 2.060437, 144.376846);
    Create3DTextLabel("{ffff00}Капитан пирса\n{ffffff}Подойдите для взаимодействия", -1, -2527.409423, 358.139892, 2.060437, 15.0, 0);

    VodolazYgAreas[0] = CreateDynamicSphere(1466.904296, -1824.186645, -17.164403, 3.0);
    VodolazYgAreas[1] = CreateDynamicSphere(1472.079833, -1834.940795, -19.254344, 3.0);
    VodolazYgAreas[2] = CreateDynamicSphere(1472.845581, -1845.868530, -18.554044, 3.0);
    VodolazYgAreas[3] = CreateDynamicSphere(1462.724609, -1837.813354, -19.553617, 3.0);
    VodolazYgAreas[4] = CreateDynamicSphere(1446.883789, -1842.590576, -16.100713, 3.0);
    VodolazYgAreas[5] = CreateDynamicSphere(1454.368652, -1851.529296, -15.718278, 3.0);

    VodolazBatAreas1[0] = CreateDynamicSphere(2752.146972, 221.677474, -23.452600, 3.0);
    VodolazBatAreas1[1] = CreateDynamicSphere(2760.477783, 245.626312, -25.607845, 3.0);
    VodolazBatAreas1[2] = CreateDynamicSphere(2748.700439, 238.873016, -23.258836, 3.0);
    VodolazBatAreas1[3] = CreateDynamicSphere(2719.258544, 236.032180, -23.346479, 3.0);
    VodolazBatAreas1[4] = CreateDynamicSphere(2718.580810, 232.052291, -25.169128, 3.0);
    VodolazBatAreas1[5] = CreateDynamicSphere(2711.500244, 210.675140, -24.449611, 3.0);
    VodolazBatAreas1[6] = CreateDynamicSphere(2716.578369, 209.340133, -20.733572, 3.0);

    VodolazBatAreas2[0] = CreateDynamicSphere(1520.854614, 139.562210, -39.823081, 3.0);
    VodolazBatAreas2[1] = CreateDynamicSphere(1509.491699, 141.896606, -40.452293, 3.0);
    VodolazBatAreas2[2] = CreateDynamicSphere(1516.119995, 142.102798, -40.669239, 3.0);
    VodolazBatAreas2[3] = CreateDynamicSphere(1518.225463, 133.190155, -40.942207, 3.0);
    VodolazBatAreas2[4] = CreateDynamicSphere(1512.053833, 135.413940, -40.162685, 3.0);
    VodolazBatAreas2[5] = CreateDynamicSphere(1506.213867, 119.769546, -36.237327, 3.0);

    VodolazLitAreas1[0] = CreateDynamicSphere(-2468.029052, 586.753845, -46.060962, 3.0);
    VodolazLitAreas1[1] = CreateDynamicSphere(-2463.144531, 575.098999, -45.783679, 3.0);
    VodolazLitAreas1[2] = CreateDynamicSphere(-2469.093505, 572.723022, -46.698123, 3.0);
    VodolazLitAreas1[3] = CreateDynamicSphere(-2472.774414, 579.592773, -46.421581, 3.0);
    VodolazLitAreas1[4] = CreateDynamicSphere(-2490.635009, 571.858337, -43.316829, 3.0);
    VodolazLitAreas1[5] = CreateDynamicSphere(-2488.437011, 570.524291, -40.731388, 3.0);

    VodolazLitAreas2[0] = CreateDynamicSphere(-1917.172607, -518.188293, -23.232200, 3.0);
    VodolazLitAreas2[1] = CreateDynamicSphere(-1910.247558, -527.531066, -22.862688, 3.0);
    VodolazLitAreas2[2] = CreateDynamicSphere(-1908.961303, -522.390319, -27.755836, 3.0);
    VodolazLitAreas2[3] = CreateDynamicSphere(-1899.620727, -515.446289, -28.269762, 3.0);
    VodolazLitAreas2[4] = CreateDynamicSphere(-1894.446044, -518.390930, -28.755828, 3.0);
    VodolazLitAreas2[5] = CreateDynamicSphere(-1901.051513, -507.493560, -28.172092, 3.0);

    VodolazYzkaAreas[0] = CreateDynamicSphere(2894.851074, -1164.413574, -20.902873, 3.0);
    VodolazYzkaAreas[1] = CreateDynamicSphere(2878.929931, -1150.683471, -17.238021, 3.0);
    VodolazYzkaAreas[2] = CreateDynamicSphere(2873.409667, -1147.650268, -9.720733, 3.0);
    VodolazYzkaAreas[3] = CreateDynamicSphere(2845.903076, -1154.326904, -9.028607, 3.0);
    VodolazYzkaAreas[4] = CreateDynamicSphere(2839.530517, -1165.238403, -9.042394, 3.0);
    VodolazYzkaAreas[5] = CreateDynamicSphere(2859.249511, -1172.719604, -5.868109, 3.0);
    VodolazYzkaAreas[6] = CreateDynamicSphere(2870.954833, -1173.163452, -9.505463, 3.0);

    print("[VODOLAZ] Система водолаза загружена.");
    return 1;
}

stock Vodolaz_ShowMainMenu(playerid)
{
    new dbg_lvl = GetPlayerLevel(playerid);
    new dbg_str[64];
    format(dbg_str, sizeof(dbg_str), "[DEBUG] level=%d", dbg_lvl);
    SendClientMessage(playerid, -1, dbg_str);
    if(dbg_lvl < 18) return ShowNotification(playerid, 2, "Для работы требуется 18 уровень!", 6, "", "");

    ShowPlayerDialog(playerid, DIALOG_VODOLAZ_MAIN, DIALOG_STYLE_LIST,
        "{ed4b00}Капитан пирса",
        "{ed4b00}1.{fff7fc}Арендовать лодку\t\t\t\t{dbd5d9}Нажмите для аренды\n{ed4b00}2.{fff7fc}Посмотреть список заданий\t\t\t\t{dbd5d9}Нажмите для просмотра\n{ed4b00}3.{fff7fc}Продажа найденных предметов\t\t\t\t{dbd5d9}Нажмите для продажи",
        "Выбрать", "Закрыть");
    return 1;
}

stock Vodolaz_ShowRentMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_VODOLAZ_RENT, DIALOG_STYLE_TABLIST_HEADERS,
        "{ed4b00}Капитан пирса{fff7fc} | Аренда",
        "№ Название\tСтоимость\tДействие\n{ed4b00}1.{fff7fc}Гидроцикл\t7000руб.\t{dbd5d9}Нажмите для аренды\n{ed4b00}2.{fff7fc}Моторная лодка\t15000руб\t{dbd5d9}Нажмите для аренды\n{ed4b00}3.{fff7fc}Speedy Yacht\t17000руб.\t{dbd5d9}Нажмите для аренды\n{ed4b00}4.{fff7fc}Marine Yacht\t20000руб\t{dbd5d9}Нажмите для аренды\n{ed4b00}5.{fff7fc}Sea Yacht\t45000руб.\t{dbd5d9}Нажмите для аренды\n{ed4b00}6.{fff7fc}Ocean Yacht\t100000руб.\t{dbd5d9}Нажмите для аренды",
        "Выбор", "Отмена");
    return 1;
}

stock Vodolaz_CreateBoat(playerid)
{
    new boat = GetPVarInt(playerid, "vodocar");
    if(boat < 0 || boat >= sizeof(VodolazBoatModels)) return 0;
    if(GetPlayerMoneyEx(playerid) < VodolazBoatPrices[boat]) return SendClientMessage(playerid, COLOR_RED, "У вас недостаточно денег для аренды лодки.");

    Vodolaz_DestroyPlayerBoat(playerid);

    new modelid = VodolazBoatModels[boat];
    new rand;
    new Float:spawnX, Float:spawnY, Float:spawnZ, Float:spawnA;

    if(IsPlayerInRangeOfPoint(playerid, 50.0, 2501.043701, -1253.509033, 1.436212))
    {
        rand = random(sizeof(VodolazBoatSpawnSouth));
        spawnX = VodolazBoatSpawnSouth[rand][vodoPosX];
        spawnY = VodolazBoatSpawnSouth[rand][vodoPosY];
        spawnZ = VodolazBoatSpawnSouth[rand][vodoPosZ];
        spawnA = VodolazBoatSpawnSouth[rand][vodoPosA];
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, -2528.527832, 357.601684, 2.100287))
    {
        rand = random(sizeof(VodolazBoatSpawnL));
        spawnX = VodolazBoatSpawnL[rand][vodoPosX];
        spawnY = VodolazBoatSpawnL[rand][vodoPosY];
        spawnZ = VodolazBoatSpawnL[rand][vodoPosZ];
        spawnA = VodolazBoatSpawnL[rand][vodoPosA];
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, 652.959899, 173.051406, 2.081145))
    {
        rand = random(sizeof(VodolazBoatSpawnA));
        spawnX = VodolazBoatSpawnA[rand][vodoPosX];
        spawnY = VodolazBoatSpawnA[rand][vodoPosY];
        spawnZ = VodolazBoatSpawnA[rand][vodoPosZ];
        spawnA = VodolazBoatSpawnA[rand][vodoPosA];
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, 2273.179443, 310.147216, 4.039990))
    {
        rand = random(sizeof(VodolazBoatSpawnB));
        spawnX = VodolazBoatSpawnB[rand][vodoPosX];
        spawnY = VodolazBoatSpawnB[rand][vodoPosY];
        spawnZ = VodolazBoatSpawnB[rand][vodoPosZ];
        spawnA = VodolazBoatSpawnB[rand][vodoPosA];
    }
    else return SendClientMessage(playerid, COLOR_RED, "Вы не находитесь рядом с точкой создания лодки!");

    new vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnA, -1, -1, -1, 1);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return SendClientMessage(playerid, COLOR_RED, "Ошибка создания транспорта!");

    VodolazBoatID[playerid] = vehicleid;
    GivePlayerMoneyEx(playerid, -VodolazBoatPrices[boat]);
    SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
    SendClientMessage(playerid, 0x66CC66FF, "Лодка арендована. Отправляйтесь к месту крушения через меню заданий.");
    return 1;
}

stock Vodolaz_StartTask(playerid)
{
    if(VodolazBoatID[playerid] == INVALID_VEHICLE_ID || !IsValidVehicle(VodolazBoatID[playerid])) return SendClientMessage(playerid, COLOR_RED, "Сначала арендуйте лодку!");

    if(GetPlayerData(playerid, P_VODO_TIME) > gettime())
    {
        ShowNotification(playerid, 2, "Не более 2-ух раз в час!", 5, "", "");
        return 1;
    }

    new rand = random(sizeof(VodolazCrashPoints));
    Vodolaz_ResetCollected(playerid);
    SetPVarInt(playerid, "vodomesto", rand);
    SetPVarInt(playerid, "VodolazTaskStarted", 1);
    SetPlayerSkin(playerid, 5344);
    SetPlayerGPSInfo(playerid, G_POS_X, VodolazCrashPoints[rand][0]);
    SetPlayerGPSInfo(playerid, G_POS_Y, VodolazCrashPoints[rand][1]);
    SetPlayerGPSInfo(playerid, G_POS_Z, VodolazCrashPoints[rand][2]);
    SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_ON);
    SendClientMessage(playerid, -1, "Место крушения отмечено у вас на GPS. Соберите предметы под водой.");
    return 1;
}

stock Vodolaz_CountItemsLeft(playerid, zone)
{
    new left = 0;
    switch(zone)
    {
        case 0: for(new i = 0; i < sizeof(VodolazYgAreas); i++) if(!VodolazCollected[playerid][vYgCollected][i]) left++;
        case 1: for(new i = 0; i < sizeof(VodolazBatAreas1); i++) if(!VodolazCollected[playerid][vBat1Collected][i]) left++;
        case 2: for(new i = 0; i < sizeof(VodolazBatAreas2); i++) if(!VodolazCollected[playerid][vBat2Collected][i]) left++;
        case 3: for(new i = 0; i < sizeof(VodolazLitAreas1); i++) if(!VodolazCollected[playerid][vLit1Collected][i]) left++;
        case 4: for(new i = 0; i < sizeof(VodolazLitAreas2); i++) if(!VodolazCollected[playerid][vLit2Collected][i]) left++;
        case 5: for(new i = 0; i < sizeof(VodolazYzkaAreas); i++) if(!VodolazCollected[playerid][vYzkaCollected][i]) left++;
    }
    return left;
}

stock Vodolaz_AfterCollect(playerid, zone)
{
    AddPlayerData(playerid, P_VODO_ITEMS, +, 1);
    SavePlayerAccount(playerid);
    SendClientMessage(playerid, 0x66CC66FF, "Вы подняли предмет.");

    new left = Vodolaz_CountItemsLeft(playerid, zone);
    if(left > 0)
    {
        new msg[96];
        format(msg, sizeof(msg), "Осталось собрать предметов в этой зоне: {FF9900}%d", left);
        SendClientMessage(playerid, -1, msg);
        return 1;
    }

    new closest = 0;
    new Float:closest_dist = 999999.0;
    new Float:captains[4][3] =
    {
        {-2528.527832, 357.601684, 2.100287},
        {652.959899, 173.051406, 2.081145},
        {2273.179443, 310.147216, 4.039990},
        {2501.043701, -1253.509033, 1.436212}
    };

    for(new i = 0; i < 4; i++)
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, captains[i][0], captains[i][1], captains[i][2]);
        if(dist < closest_dist)
        {
            closest_dist = dist;
            closest = i;
        }
    }

    SetPlayerGPSInfo(playerid, G_POS_X, captains[closest][0]);
    SetPlayerGPSInfo(playerid, G_POS_Y, captains[closest][1]);
    SetPlayerGPSInfo(playerid, G_POS_Z, captains[closest][2]);
    SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_ON);
    SendClientMessage(playerid, -1, "Вы собрали все предметы в этой зоне. Маршрут к капитану установлен на GPS.");
    DeletePVar(playerid, "VodolazTaskStarted");

    AddPlayerData(playerid, P_VODO_TASK, +, 1);
    if(GetPlayerData(playerid, P_VODO_TASK) >= 2)
    {
        SetPlayerData(playerid, P_VODO_TASK, 0);
        SetPlayerData(playerid, P_VODO_TIME, gettime() + 3600);
        SendClientMessage(playerid, -1, "Лимит заданий водолаза исчерпан. Следующее задание будет доступно через 1 час.");
    }
    SavePlayerAccount(playerid);
    return 1;
}

stock Vodolaz_TryCollectItem(playerid)
{
    if(GetPVarInt(playerid, "VodolazTaskStarted") != 1)
        return SendClientMessage(playerid, COLOR_RED, "Сначала возьмите задание у капитана пирса.");

    new rand = GetPVarInt(playerid, "vodomesto");
    if(rand < 0 || rand >= sizeof(VodolazCrashPoints)) rand = 0;

    if(!IsPlayerInRangeOfPoint(playerid, 200.0, VodolazCrashPoints[rand][0], VodolazCrashPoints[rand][1], VodolazCrashPoints[rand][2]))
        return SendClientMessage(playerid, COLOR_RED, "Отправляйтесь на место крушения. Оно отмечено у вас в GPS.");

    for(new i = 0; i < sizeof(VodolazYgAreas); i++)
    {
        if(IsPlayerInDynamicArea(playerid, VodolazYgAreas[i]))
        {
            if(VodolazCollected[playerid][vYgCollected][i]) return SendClientMessage(playerid, COLOR_GREY, "Вы уже собирали этот предмет!");
            VodolazCollected[playerid][vYgCollected][i] = 1;
            return Vodolaz_AfterCollect(playerid, 0);
        }
    }

    for(new i = 0; i < sizeof(VodolazBatAreas1); i++)
    {
        if(IsPlayerInDynamicArea(playerid, VodolazBatAreas1[i]))
        {
            if(VodolazCollected[playerid][vBat1Collected][i]) return SendClientMessage(playerid, COLOR_GREY, "Вы уже собирали этот предмет!");
            VodolazCollected[playerid][vBat1Collected][i] = 1;
            return Vodolaz_AfterCollect(playerid, 1);
        }
    }

    for(new i = 0; i < sizeof(VodolazBatAreas2); i++)
    {
        if(IsPlayerInDynamicArea(playerid, VodolazBatAreas2[i]))
        {
            if(VodolazCollected[playerid][vBat2Collected][i]) return SendClientMessage(playerid, COLOR_GREY, "Вы уже собирали этот предмет!");
            VodolazCollected[playerid][vBat2Collected][i] = 1;
            return Vodolaz_AfterCollect(playerid, 2);
        }
    }

    for(new i = 0; i < sizeof(VodolazLitAreas1); i++)
    {
        if(IsPlayerInDynamicArea(playerid, VodolazLitAreas1[i]))
        {
            if(VodolazCollected[playerid][vLit1Collected][i]) return SendClientMessage(playerid, COLOR_GREY, "Вы уже собирали этот предмет!");
            VodolazCollected[playerid][vLit1Collected][i] = 1;
            return Vodolaz_AfterCollect(playerid, 3);
        }
    }

    for(new i = 0; i < sizeof(VodolazLitAreas2); i++)
    {
        if(IsPlayerInDynamicArea(playerid, VodolazLitAreas2[i]))
        {
            if(VodolazCollected[playerid][vLit2Collected][i]) return SendClientMessage(playerid, COLOR_GREY, "Вы уже собирали этот предмет!");
            VodolazCollected[playerid][vLit2Collected][i] = 1;
            return Vodolaz_AfterCollect(playerid, 4);
        }
    }

    for(new i = 0; i < sizeof(VodolazYzkaAreas); i++)
    {
        if(IsPlayerInDynamicArea(playerid, VodolazYzkaAreas[i]))
        {
            if(VodolazCollected[playerid][vYzkaCollected][i]) return SendClientMessage(playerid, COLOR_GREY, "Вы уже собирали этот предмет!");
            VodolazCollected[playerid][vYzkaCollected][i] = 1;
            return Vodolaz_AfterCollect(playerid, 5);
        }
    }

    return SendClientMessage(playerid, COLOR_GREY, "Вы не находитесь рядом с предметом для поднятия!");
}

stock Vodolaz_ShowSellItems(playerid)
{
    new items = GetPlayerData(playerid, P_VODO_ITEMS);
    if(items <= 0) return SendClientMessage(playerid, COLOR_GREY, "У вас нет предметов для продажи!");

    new dialog_text[2048];
    format(dialog_text, sizeof(dialog_text), "№\tНазвание\tСтоимость\n");

    for(new i = 0; i < items && i < 25; i++)
    {
        new idx = i % sizeof(VodolazItemNames);
        format(dialog_text, sizeof(dialog_text), "%s%d\t%s\t%d рублей\n", dialog_text, i + 1, VodolazItemNames[idx], VodolazItemPrices[idx]);
    }

    SetPVarInt(playerid, "Vodolaz_ItemsCount", items);
    ShowPlayerDialog(playerid, DIALOG_VODOLAZ_SELL, DIALOG_STYLE_TABLIST_HEADERS,
        "{ed4b00}Капитан пирса{fff7fc} | Продажа предметов",
        dialog_text,
        "Выбрать", "Закрыть");
    return 1;
}

stock Vodolaz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_VODOLAZ_MAIN)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: return Vodolaz_ShowRentMenu(playerid);
            case 1:
            {
                ShowPlayerDialog(playerid, DIALOG_VODOLAZ_TASKS, DIALOG_STYLE_LIST,
                    "{ed4b00}Капитан пирса{fff7fc} | Список заданий",
                    "{ed4b00}1.{ffffff}Добыча предметов (водолаз)",
                    "Выбрать", "Назад");
                return 1;
            }
            case 2: return Vodolaz_ShowSellItems(playerid);
        }
        return 1;
    }

    if(dialogid == DIALOG_VODOLAZ_RENT)
    {
        if(!response) return Vodolaz_ShowMainMenu(playerid);
        if(listitem < 0 || listitem >= sizeof(VodolazBoatNames)) return 1;
        SetPVarInt(playerid, "vodocar", listitem);

        new text[384];
        format(text, sizeof(text), "Вы действительно желаете взять в аренду {f0de41}%s {ffffff}за {f0de41}%d {ffffff}рублей на {f0de41}1 час?\n\n{ffffff}Вы сможете продлить аренду лодки на любом причале.", VodolazBoatNames[listitem], VodolazBoatPrices[listitem]);
        ShowPlayerDialog(playerid, DIALOG_VODOLAZ_RENT_CONFIRM, DIALOG_STYLE_MSGBOX,
            "{ed4b00}Капитан пирса{fff7fc} | Аренда",
            text,
            "Выбрать", "Назад");
        return 1;
    }

    if(dialogid == DIALOG_VODOLAZ_RENT_CONFIRM)
    {
        if(!response) return Vodolaz_ShowMainMenu(playerid);
        return Vodolaz_CreateBoat(playerid);
    }

    if(dialogid == DIALOG_VODOLAZ_TASKS)
    {
        if(!response) return Vodolaz_ShowMainMenu(playerid);
        if(listitem == 0) return Vodolaz_StartTask(playerid);
        return 1;
    }

    if(dialogid == DIALOG_VODOLAZ_SELL)
    {
        if(!response) return 1;
        new items = GetPlayerData(playerid, P_VODO_ITEMS);
        if(items <= 0) return SendClientMessage(playerid, COLOR_GREY, "У вас больше нет предметов для продажи!");

        new idx = listitem % sizeof(VodolazItemPrices);
        new price = VodolazItemPrices[idx];
        AddPlayerData(playerid, P_VODO_ITEMS, -, 1);
        GivePlayerMoneyEx(playerid, price);
        SavePlayerAccount(playerid);

        new msg[144];
        format(msg, sizeof(msg), "Вы продали {FF9900}%s {FFFFFF}за {00FF00}%d рублей{FFFFFF}! Осталось предметов: {FF9900}%d", VodolazItemNames[idx], price, GetPlayerData(playerid, P_VODO_ITEMS));
        SendClientMessage(playerid, -1, msg);
        return 1;
    }

    return 0;
}

stock Vodolaz_OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < sizeof(VodolazYgAreas); i++)
    {
        if(areaid == VodolazYgAreas[i])
        {
            if(VodolazCollected[playerid][vYgCollected][i]) return ShowNotification(playerid, 4, "Предмет уже собран", 6, "", "");
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_TryCollectItem(playerid);
        }
    }

    for(new i = 0; i < sizeof(VodolazBatAreas1); i++)
    {
        if(areaid == VodolazBatAreas1[i])
        {
            if(VodolazCollected[playerid][vBat1Collected][i]) return ShowNotification(playerid, 4, "Предмет уже собран", 6, "", "");
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_TryCollectItem(playerid);
        }
    }

    for(new i = 0; i < sizeof(VodolazBatAreas2); i++)
    {
        if(areaid == VodolazBatAreas2[i])
        {
            if(VodolazCollected[playerid][vBat2Collected][i]) return ShowNotification(playerid, 4, "Предмет уже собран", 6, "", "");
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_TryCollectItem(playerid);
        }
    }

    for(new i = 0; i < sizeof(VodolazLitAreas1); i++)
    {
        if(areaid == VodolazLitAreas1[i])
        {
            if(VodolazCollected[playerid][vLit1Collected][i]) return ShowNotification(playerid, 4, "Предмет уже собран", 6, "", "");
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_TryCollectItem(playerid);
        }
    }

    for(new i = 0; i < sizeof(VodolazLitAreas2); i++)
    {
        if(areaid == VodolazLitAreas2[i])
        {
            if(VodolazCollected[playerid][vLit2Collected][i]) return ShowNotification(playerid, 4, "Предмет уже собран", 6, "", "");
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_TryCollectItem(playerid);
        }
    }

    for(new i = 0; i < sizeof(VodolazYzkaAreas); i++)
    {
        if(areaid == VodolazYzkaAreas[i])
        {
            if(VodolazCollected[playerid][vYzkaCollected][i]) return ShowNotification(playerid, 4, "Предмет уже собран", 6, "", "");
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_TryCollectItem(playerid);
        }
    }

    for(new i = 0; i < sizeof(VodolazCaptainArea); i++)
    {
        if(areaid == VodolazCaptainArea[i])
        {
            ShowNotification(playerid, 4, "Взаимодействовать", 6, "", "");
            return Vodolaz_ShowMainMenu(playerid);
        }
    }
    return 0;
}

CMD:vodogo(playerid)
{
    if(!IsPlayerLogged(playerid)) return 1;
    return Vodolaz_ShowMainMenu(playerid);
}

CMD:vodolaz(playerid)
{
    SendClientMessage(playerid, -1, "[DEBUG] cmd vodolaz");
    if(!IsPlayerLogged(playerid)) { SendClientMessage(playerid, -1, "[DEBUG] not logged"); return 1; }
    return Vodolaz_ShowMainMenu(playerid);
}

CMD:vodopremd(playerid)
{
    if(!IsPlayerLogged(playerid)) return 1;
    return Vodolaz_TryCollectItem(playerid);
}

CMD:vodopredmpokaz(playerid)
{
    if(!IsPlayerLogged(playerid)) return 1;
    return Vodolaz_ShowSellItems(playerid);
}

stock Admin_SetPlayerGameLevel(adminid, targetid, level)
{
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(adminid, 0xFF3333FF, "Игрок не найден.");
        return 1;
    }

    if(level < 1 || level > 100)
    {
        SendClientMessage(adminid, 0xFF3333FF, "Уровень должен быть от 1 до 100.");
        return 1;
    }

    SetPlayerData(targetid, P_LEVEL, level);
    SetPlayerData(targetid, P_EXP, 0);
    SetPlayerScore(targetid, level);
    SavePlayerAccount(targetid);

    new str[160];
    format(str, sizeof(str), "{3399FF}Вы установили игроку %s[%d] игровой уровень %d.", GetPlayerNameEx(targetid), targetid, level);
    SendClientMessage(adminid, -1, str);

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] установил вам игровой уровень %d.", GetPlayerNameEx(adminid), adminid, level);
    SendClientMessage(targetid, -1, str);

    format(str, sizeof(str), "[A] %s[%d] установил игроку %s[%d] игровой уровень %d.", GetPlayerNameEx(adminid), adminid, GetPlayerNameEx(targetid), targetid, level);
    foreach(new i : Player) { if(GetPlayerAdminEx(i) >= 1) SendClientMessage(i, 0xFF4B4BFF, str); }
    return 1;
}

CMD:setlevel(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 1;
    if(!GetPlayerData(playerid, P_ADMIN_LOGGED) || GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, level;
    if(sscanf(params, "ui", targetid, level)) return SendClientMessage(playerid, -1, "{999999}Используйте: /setlevel [id] [уровень 1-100]");

    return Admin_SetPlayerGameLevel(playerid, targetid, level);
}

CMD:givelevel(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 1;
    if(!GetPlayerData(playerid, P_ADMIN_LOGGED) || GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, amount;
    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, -1, "{999999}Используйте: /givelevel [id] [кол-во уровней]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF3333FF, "Игрок не найден.");
    if(amount == 0) return SendClientMessage(playerid, 0xFF3333FF, "Количество уровней не может быть 0.");

    new new_level = GetPlayerLevel(targetid) + amount;
    return Admin_SetPlayerGameLevel(playerid, targetid, new_level);
}

CMD:giveexp(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 1;
    if(!GetPlayerData(playerid, P_ADMIN_LOGGED) || GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, exp;
    if(sscanf(params, "ui", targetid, exp)) return SendClientMessage(playerid, -1, "{999999}Используйте: /giveexp [id] [кол-во EXP]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF3333FF, "Игрок не найден.");
    if(exp <= 0) return SendClientMessage(playerid, 0xFF3333FF, "EXP должен быть больше 0.");

    AddPlayerData(targetid, P_EXP, +, exp);

    new str[160];
    format(str, sizeof(str), "{3399FF}Вы выдали игроку %s[%d] %d EXP.", GetPlayerNameEx(targetid), targetid, exp);
    SendClientMessage(playerid, -1, str);

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам %d EXP.", GetPlayerNameEx(playerid), playerid, exp);
    SendClientMessage(targetid, -1, str);
    return 1;
}
