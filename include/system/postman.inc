#if defined _POSTMAN_INCLUDED
#endinput
#endif
#define _POSTMAN_INCLUDED

#define POSTMAN_DIALOG_MAIN 9000
#define POSTMAN_DIALOG_INFO 9001
#define POSTMAN_DIALOG_STATS 9002
#define POSTMAN_SKIN 58
#define POSTMAN_VEHICLE_MODEL 550
#define POSTMAN_MIN_LEVEL 3
#define POSTMAN_STATS_TABLE "postman_stats"
#define POSTMAN_JOB_LEVEL_MAX 3
#define POSTMAN_LEVEL2_DELIVERIES 25
#define POSTMAN_LEVEL3_DELIVERIES 75
#define POSTMAN_DELIVERIES 5
#define POSTMAN_MIN_DISTANCE 300.0
#define POSTMAN_MAX_DISTANCE 1500.0
#define POSTMAN_BASE_COUNT 3
#define POSTMAN_POINT_MAX 50

new bool:PostmanWorking[MAX_PLAYERS];
new bool:PostmanNearBase[MAX_PLAYERS];
new PostmanBase[MAX_PLAYERS];
new PostmanVehicle[MAX_PLAYERS] = { INVALID_VEHICLE_ID, ... };
new PostmanDelivery[MAX_PLAYERS];
new PostmanEarned[MAX_PLAYERS];
new PostmanOldSkin[MAX_PLAYERS];
new PostmanFinishBase[MAX_PLAYERS];
new PostmanRoute[MAX_PLAYERS][POSTMAN_DELIVERIES];
new bool:PostmanUsed[MAX_PLAYERS][POSTMAN_POINT_MAX];
new PostmanBasePickup[POSTMAN_BASE_COUNT];
new PostmanBaseActor[POSTMAN_BASE_COUNT];
new PostmanTimer;
new bool:PostmanInitialized;
new bool:PostmanStatsLoaded[MAX_PLAYERS];
new bool:PostmanStatsLoading[MAX_PLAYERS];
new PostmanJobLevel[MAX_PLAYERS] = { 1, ... };
new PostmanTotalDeliveries[MAX_PLAYERS];
new PostmanTotalEarned[MAX_PLAYERS];

new Float:PostmanBaseData[POSTMAN_BASE_COUNT][8] =
{
    {109.981094, 575.034057, 13.307200, 261.522308, 110.956947, 574.836914, 13.307200, 0.0},
    {-2619.200195, -89.596038, 27.394088, 178.575912, -2619.212158, -90.549095, 27.394088, 0.0},
    {2409.153076, -2140.468994, 22.795974, 178.394210, 2409.044921, -2141.083984, 22.430545, 0.0}
};

new Float:PostmanPoints0[][3] =
{
    {348.237335, 1851.217163, 12.533704},
    {340.474273, 1898.681030, 12.813751},
    {250.823455, 1871.602539, 12.080525},
    {218.528350, 1874.989624, 12.080525},
    {211.615173, 1932.254028, 12.039999},
    {228.531921, 1930.728515, 12.039999},
    {245.337875, 1928.936646, 12.039999},
    {262.244506, 1927.788696, 12.039999},
    {279.279663, 1926.054321, 12.039999},
    {296.315582, 1924.543945, 12.039999},
    {374.029235, 1942.027954, 11.532187},
    {374.159027, 1946.412231, 11.532187},
    {273.881500, 1527.902099, 12.492761},
    {274.539062, 1544.768432, 12.360312},
    {276.996582, 1561.781005, 12.368124},
    {280.409393, 1595.895385, 12.368124},
    {230.102752, 1018.000305, 12.039999},
    {227.858474, 1001.314208, 12.039999},
    {226.253738, 984.161376, 12.039999},
    {223.466033, 968.039672, 12.039999},
    {195.858459, 946.691772, 12.039999},
    {180.134353, 953.302978, 12.039999},
    {164.350173, 959.021911, 12.039999},
    {148.089950, 964.812683, 12.039999},
    {132.311798, 971.017761, 12.039999},
    {116.549957, 977.298767, 12.039999},
    {99.661087, 1019.547912, 12.307606},
    {103.249954, 1035.614746, 12.039999},
    {106.777931, 1052.146728, 12.039999},
    {110.318092, 1068.917236, 12.039999},
    {367.075469, 519.441894, 12.268944},
    {407.101806, 503.768341, 12.261342},
    {511.652740, 461.082794, 12.265326},
    {552.463500, 445.783813, 12.259085},
    {555.938659, 297.367950, 12.497893},
    {557.273742, 278.798706, 12.539999},
    {510.570068, 328.756866, 12.493124},
    {494.974090, 315.605407, 12.743124},
    {497.394500, 278.670349, 12.335994},
    {508.951141, 277.327239, 12.418776},
    {468.828247, 276.639678, 12.370289},
    {457.605651, 276.822265, 12.358937},
    {430.940643, 279.340698, 12.363810},
    {429.377380, 296.971588, 12.493124},
    {446.282684, 330.239013, 12.493124},
    {390.112365, 341.316314, 12.405493},
    {373.629577, 329.178344, 12.491196},
    {384.682037, 288.495544, 12.431456},
    {373.819702, 288.042419, 12.460515},
    {302.642517, 303.968994, 12.539999}
};

new Float:PostmanPoints1[][3] =
{
    {-2470.588378, 72.567031, 26.418479},
    {-2479.260009, 54.085113, 26.415000},
    {-2479.793457, 26.955265, 26.419567},
    {-2479.065673, 1.099376, 26.419567},
    {-2472.214843, -17.473121, 26.462005},
    {-2429.388183, -43.288917, 26.422943},
    {-2406.257568, -49.479843, 26.422943},
    {-2417.923583, 10.621136, 26.612648},
    {-2418.169433, 37.842460, 26.621387},
    {-2401.451416, 96.022003, 26.378295},
    {-2426.656494, 95.238548, 26.414482},
    {-2316.138183, 174.440917, 28.074245},
    {-2262.247558, 132.099441, 28.552616},
    {-2298.495117, 121.415916, 26.611022},
    {-2494.174804, -116.660110, 27.191215},
    {-2439.498779, -128.702438, 26.610927},
    {-2429.967285, -42.595035, 26.422943},
    {-2406.916503, -49.555801, 26.422943}
};

new Float:PostmanPoints2[][3] =
{
    {2433.376953, -2476.489746, 21.972400},
    {2409.736328, -2476.328857, 21.972454},
    {2384.983398, -2476.217773, 21.974037},
    {2349.872802, -2476.145263, 21.970649},
    {2325.280761, -2476.608398, 21.969268},
    {2302.045410, -2476.378173, 21.968723},
    {2265.703857, -2476.167724, 21.968242},
    {2240.710205, -2476.176513, 21.970443},
    {2217.097900, -2476.166259, 21.969306},
    {2242.226318, -2552.190917, 21.829063},
    {2260.768310, -2552.092285, 21.829063},
    {2236.670410, -2576.199218, 21.977500},
    {2251.531982, -2576.119628, 21.977500},
    {2266.318359, -2576.116943, 21.977500},
    {2295.100830, -2577.000732, 21.977500},
    {2316.041992, -2577.131347, 21.977500},
    {2334.302490, -2577.150634, 21.977500},
    {2402.790283, -2027.705078, 21.981418},
    {2402.967529, -2046.155395, 21.997200},
    {2403.003662, -2064.417236, 22.012321},
    {2403.047363, -2083.332031, 22.024375},
    {2402.896484, -2115.409179, 22.018138},
    {2407.957519, -2129.904296, 22.008750},
    {2440.648437, -2115.832275, 22.008750},
    {2421.068359, -2078.969482, 22.016563}
};

stock Postman_GetPointCount(base)
{
    if(base == 0) return sizeof(PostmanPoints0);
    if(base == 1) return sizeof(PostmanPoints1);
    return sizeof(PostmanPoints2);
}

stock Postman_GetPoint(base, index, &Float:x, &Float:y, &Float:z)
{
    if(base == 0)
    {
        x = PostmanPoints0[index][0];
        y = PostmanPoints0[index][1];
        z = PostmanPoints0[index][2];
        return 1;
    }
    if(base == 1)
    {
        x = PostmanPoints1[index][0];
        y = PostmanPoints1[index][1];
        z = PostmanPoints1[index][2];
        return 1;
    }
    x = PostmanPoints2[index][0];
    y = PostmanPoints2[index][1];
    z = PostmanPoints2[index][2];
    return 1;
}

stock Postman_Distance(Float:x1, Float:y1, Float:x2, Float:y2)
{
    return floatround(floatsqroot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)));
}

stock Postman_BuildRouteStep(playerid, depth, lastIndex)
{
    new base = PostmanBase[playerid];
    new count = Postman_GetPointCount(base);
    new tries, index, distance;
    new Float:lx, Float:ly, Float:lz, Float:px, Float:py, Float:pz;

    if(depth >= POSTMAN_DELIVERIES) return 1;

    if(depth > 0) Postman_GetPoint(base, lastIndex, lx, ly, lz);

    for(tries = 0; tries < count * 4; tries++)
    {
        index = random(count);
        if(PostmanUsed[playerid][index]) continue;

        Postman_GetPoint(base, index, px, py, pz);

        if(depth > 0)
        {
            distance = Postman_Distance(lx, ly, px, py);
            if(distance < POSTMAN_MIN_DISTANCE || distance > POSTMAN_MAX_DISTANCE) continue;
        }

        PostmanUsed[playerid][index] = true;
        PostmanRoute[playerid][depth] = index;

        if(Postman_BuildRouteStep(playerid, depth + 1, index)) return 1;

        PostmanUsed[playerid][index] = false;
    }
    return 0;
}

stock Postman_BuildRoute(playerid)
{
    new attempt, i;
    for(attempt = 0; attempt < 100; attempt++)
    {
        for(i = 0; i < POSTMAN_POINT_MAX; i++) PostmanUsed[playerid][i] = false;
        if(Postman_BuildRouteStep(playerid, 0, -1)) return 1;
    }
    return 0;
}

stock Postman_SetGPS(playerid, Float:x, Float:y, Float:z, message[])
{
    return EnablePlayerGPS(playerid, 0, x, y, z, message);
}

stock Postman_SetDeliveryGPS(playerid)
{
    new index = PostmanRoute[playerid][PostmanDelivery[playerid]];
    new Float:x, Float:y, Float:z;
    Postman_GetPoint(PostmanBase[playerid], index, x, y, z);
    return Postman_SetGPS(playerid, x, y, z, "Следующая посылка отмечена на GPS.");
}

stock Postman_GetNearestBase(playerid)
{
    new i, best = 0, distance, bestDistance = 2147483647;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for(i = 0; i < POSTMAN_BASE_COUNT; i++)
    {
        distance = Postman_Distance(x, y, PostmanBaseData[i][0], PostmanBaseData[i][1]);
        if(distance < bestDistance)
        {
            bestDistance = distance;
            best = i;
        }
    }
    return best;
}

stock Postman_GetBaseByPlayer(playerid)
{
    new i;
    for(i = 0; i < POSTMAN_BASE_COUNT; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 4.0, PostmanBaseData[i][0], PostmanBaseData[i][1], PostmanBaseData[i][2]))
            return i;
    }
    return -1;
}

stock Postman_GetJobLevel(playerid)
{
    if(PostmanTotalDeliveries[playerid] >= POSTMAN_LEVEL3_DELIVERIES) return 3;
    if(PostmanTotalDeliveries[playerid] >= POSTMAN_LEVEL2_DELIVERIES) return 2;
    return 1;
}

stock Postman_GetNextLevelTarget(level)
{
    if(level == 1) return POSTMAN_LEVEL2_DELIVERIES;
    if(level == 2) return POSTMAN_LEVEL3_DELIVERIES;
    return 0;
}

stock Postman_GetNextLevelRemaining(playerid)
{
    new target = Postman_GetNextLevelTarget(PostmanJobLevel[playerid]);
    if(target <= 0) return 0;
    new remaining = target - PostmanTotalDeliveries[playerid];
    return remaining > 0 ? remaining : 0;
}

stock Postman_SaveStats(playerid)
{
    if(!PostmanStatsLoaded[playerid] || GetPlayerAccountID(playerid) <= 0) return 0;

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `postman_stats` (`account_id`,`job_level`,`total_deliveries`,`total_earned`) VALUES (%d,%d,%d,%d) ON DUPLICATE KEY UPDATE `job_level`=VALUES(`job_level`),`total_deliveries`=VALUES(`total_deliveries`),`total_earned`=VALUES(`total_earned`)",
        GetPlayerAccountID(playerid), PostmanJobLevel[playerid], PostmanTotalDeliveries[playerid], PostmanTotalEarned[playerid]);
    mysql_tquery(mysql, query);
    return 1;
}

forward Postman_OnStatsLoaded(playerid, account_id, show_main);
public Postman_OnStatsLoaded(playerid, account_id, show_main)
{
    if(!IsPlayerConnected(playerid) || GetPlayerAccountID(playerid) != account_id) return 1;
    PostmanStatsLoading[playerid] = false;
    new rows, fields;
    cache_get_data(rows, fields);
    if(rows > 0)
    {
        PostmanJobLevel[playerid] = cache_get_field_content_int(0, "job_level");
        PostmanTotalDeliveries[playerid] = cache_get_field_content_int(0, "total_deliveries");
        PostmanTotalEarned[playerid] = cache_get_field_content_int(0, "total_earned");
    }
    else
    {
        PostmanJobLevel[playerid] = 1;
        PostmanTotalDeliveries[playerid] = 0;
        PostmanTotalEarned[playerid] = 0;
        new query[256];
        mysql_format(mysql, query, sizeof query, "INSERT IGNORE INTO `postman_stats` (`account_id`,`job_level`,`total_deliveries`,`total_earned`) VALUES (%d,1,0,0)", account_id);
        mysql_tquery(mysql, query);
    }
    PostmanJobLevel[playerid] = Postman_GetJobLevel(playerid);
    PostmanStatsLoaded[playerid] = true;
    Postman_SaveStats(playerid);
    if(show_main) Postman_ShowMain(playerid);
    return 1;
}

stock Postman_LoadStats(playerid, bool:show_main = true)
{
    if(GetPlayerAccountID(playerid) <= 0)
        return SendClientMessage(playerid, 0xFF3333FF, "Не удалось определить аккаунт игрока. Попробуйте ещё раз.");
    if(PostmanStatsLoaded[playerid])
    {
        if(show_main) Postman_ShowMain(playerid);
        return 1;
    }
    if(PostmanStatsLoading[playerid]) return 1;
    PostmanStatsLoading[playerid] = true;
    new account_id = GetPlayerAccountID(playerid);
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `postman_stats` (`account_id` INT NOT NULL, `job_level` TINYINT UNSIGNED NOT NULL DEFAULT 1, `total_deliveries` INT UNSIGNED NOT NULL DEFAULT 0, `total_earned` BIGINT UNSIGNED NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251");
    new query[256];
    mysql_format(mysql, query, sizeof query, "SELECT `job_level`,`total_deliveries`,`total_earned` FROM `postman_stats` WHERE `account_id`=%d LIMIT 1", account_id);
    mysql_tquery(mysql, query, "Postman_OnStatsLoaded", "iii", playerid, account_id, show_main);
    return 1;
}

stock Postman_ShowMain(playerid)
{
    new text[160];
    if(PostmanWorking[playerid])
        format(text, sizeof text, "Инструкция\nЗакончить работу\nСтатистика");
    else
        format(text, sizeof text, "Инструкция\nНачать работу\nСтатистика");
    ShowPlayerDialog(playerid, POSTMAN_DIALOG_MAIN, DIALOG_STYLE_LIST, "Работа почтальона", text, "Выбрать", "Назад");
    return 1;
}

stock Postman_ShowStatistics(playerid)
{
    if(!PostmanStatsLoaded[playerid]) return Postman_LoadStats(playerid, false);
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof name);
    new target = Postman_GetNextLevelTarget(PostmanJobLevel[playerid]);
    new remaining = Postman_GetNextLevelRemaining(playerid);
    new targetText[32];
    if(PostmanJobLevel[playerid] >= POSTMAN_JOB_LEVEL_MAX) format(targetText, sizeof targetText, "Максимальный уровень");
    else format(targetText, sizeof targetText, "%d посылок", target);
    new query[256];
    mysql_format(mysql, query, sizeof query, "SELECT COALESCE(SUM(`total_earned`),0) AS `all_earned` FROM `postman_stats`");
    mysql_tquery(mysql, query, "Postman_OnGlobalStatsLoaded", "i", playerid);
    return 1;
}

forward Postman_OnGlobalStatsLoaded(playerid);
public Postman_OnGlobalStatsLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new all_earned = 0, rows, fields;
    cache_get_data(rows, fields);
    if(rows > 0) all_earned = cache_get_field_content_int(0, "all_earned");
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof name);
    new target = Postman_GetNextLevelTarget(PostmanJobLevel[playerid]);
    new remaining = Postman_GetNextLevelRemaining(playerid);
    new targetText[32];
    if(PostmanJobLevel[playerid] >= POSTMAN_JOB_LEVEL_MAX) format(targetText, sizeof targetText, "Максимальный уровень");
    else format(targetText, sizeof targetText, "%d посылок", target);
    new text[768];
    format(text, sizeof text, "Ник: {FFFF00}%s\n\nУровень работника-почтальона: {33CC33}%d/3\nВсего развезено посылок: {FFFFFF}%d\nПосылок осталось до следующего уровня: {FFFFFF}%d\nВсего посылок для повышения следующего уровня: {FFFFFF}%s\nВсего заработано на работе: {33CC33}%d \xf0\xf3\xe1.\nВсего заработали все игроки на работе: {33CC33}%d \xf0\xf3\xe1.", name, PostmanJobLevel[playerid], PostmanTotalDeliveries[playerid], remaining, targetText, PostmanTotalEarned[playerid], all_earned);
    ShowPlayerDialog(playerid, POSTMAN_DIALOG_STATS, DIALOG_STYLE_MSGBOX, "Статистика почтальона", text, "Назад", "");
    return 1;
}

stock Postman_ShowInfo(playerid)
{
    ShowPlayerDialog(playerid, POSTMAN_DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Работа почтальона",
        "Работа доступна с 3 уровня. После начала смены вам выдаётся скин 58 и рабочий автомобиль модели 550.\n\nВам необходимо доставить 5 посылок. GPS будет последовательно вести к разным точкам доставки. Расстояние между последовательными адресами — от 300 до 1500 метров.\n\nПосле пятой доставки GPS проложит путь к ближайшей базе. После возвращения зарплата будет выплачена автоматически.",
        "Назад", "");
    return 1;
}

stock Postman_Start(playerid, base)
{
    if(GetPlayerData(playerid, P_LEVEL) < POSTMAN_MIN_LEVEL)
        return SendClientMessage(playerid, 0xFF3333FF, "Для работы почтальоном требуется 3 уровень.");

    if(PostmanWorking[playerid])
        return SendClientMessage(playerid, 0xFF3333FF, "Вы уже работаете почтальоном.");

    if(!PostmanStatsLoaded[playerid])
        return SendClientMessage(playerid, 0xFF3333FF, "Статистика почтальона ещё загружается. Откройте диалог ещё раз через секунду.");

    PostmanBase[playerid] = base;

    if(!Postman_BuildRoute(playerid))
        return SendClientMessage(playerid, 0xFF3333FF, "Не удалось построить маршрут доставки.");

    PostmanWorking[playerid] = true;
    PostmanDelivery[playerid] = 0;
    PostmanEarned[playerid] = 0;
    PostmanFinishBase[playerid] = -1;
    PostmanOldSkin[playerid] = GetPlayerData(playerid, P_SKIN);

    new jobSkin = 58;
    new jobVehicle = 550;
    if(PostmanJobLevel[playerid] == 2)
    {
        jobSkin = 101;
        jobVehicle = 589;
    }
    else if(PostmanJobLevel[playerid] >= 3)
    {
        jobSkin = 103;
        jobVehicle = 603;
    }

    SetPlayerData(playerid, P_SKIN, jobSkin);
    SetPlayerSkinInit(playerid);

    new Float:spawnX = PostmanBaseData[base][0] + (5.0 * floatsin(-PostmanBaseData[base][3], degrees));
    new Float:spawnY = PostmanBaseData[base][1] + (5.0 * floatcos(-PostmanBaseData[base][3], degrees));
    new Float:spawnZ = PostmanBaseData[base][2];

    PostmanVehicle[playerid] = CreateVehicle(jobVehicle, spawnX, spawnY, spawnZ, PostmanBaseData[base][3], 1, 1, -1);

    Postman_SetDeliveryGPS(playerid);
    SendClientMessage(playerid, 0xFFFF00FF, "Вам выдана рабочая машина. Садитесь в автомобиль и начинайте доставку.");
    return 1;
}

stock Postman_Stop(playerid, bool:pay)
{
    new money = PostmanEarned[playerid];

    if(!PostmanWorking[playerid]) return 0;

    DisablePlayerGPS(playerid);
    DisablePlayerCheckpoint(playerid);

    if(pay && money > 0)
        GivePlayerMoneyEx(playerid, money, "Зарплата почтальона");

    if(PostmanVehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(PostmanVehicle[playerid]))
        DestroyVehicle(PostmanVehicle[playerid]);

    PostmanVehicle[playerid] = INVALID_VEHICLE_ID;

    SetPlayerData(playerid, P_SKIN, PostmanOldSkin[playerid]);
    SetPlayerSkinInit(playerid);

    PostmanWorking[playerid] = false;
    PostmanDelivery[playerid] = 0;
    PostmanEarned[playerid] = 0;
    PostmanFinishBase[playerid] = -1;

    return money;
}

stock Postman_Deliver(playerid)
{
    if(!PostmanWorking[playerid] || PostmanDelivery[playerid] >= POSTMAN_DELIVERIES) return 0;

    new reward;
    if(PostmanJobLevel[playerid] == 1) reward = 1300 + random(401);
    else if(PostmanJobLevel[playerid] == 2) reward = 1700 + random(401);
    else reward = 2100 + random(401);

    PostmanEarned[playerid] += reward;
    PostmanTotalDeliveries[playerid]++;
    PostmanTotalEarned[playerid] += reward;
    PostmanDelivery[playerid]++;

    new oldLevel = PostmanJobLevel[playerid];
    PostmanJobLevel[playerid] = Postman_GetJobLevel(playerid);
    Postman_SaveStats(playerid);

    if(PostmanJobLevel[playerid] > oldLevel)
    {
        new levelMessage[128];
        format(levelMessage, sizeof levelMessage, "Поздравляем! Вы повысили уровень работника-почтальона до %d.", PostmanJobLevel[playerid]);
        SendClientMessage(playerid, 0x33CC33FF, levelMessage);
    }

    if(PostmanDelivery[playerid] < POSTMAN_DELIVERIES)
        return Postman_SetDeliveryGPS(playerid);

    PostmanFinishBase[playerid] = Postman_GetNearestBase(playerid);

    return Postman_SetGPS(
        playerid,
        PostmanBaseData[PostmanFinishBase[playerid]][0],
        PostmanBaseData[PostmanFinishBase[playerid]][1],
        PostmanBaseData[PostmanFinishBase[playerid]][2],
        "Все посылки доставлены. GPS ведёт на ближайшую базу."
    );
}

forward Postman_Tick();
public Postman_Tick()
{
    new playerid, base, finishBase, index, money;
    new Float:x, Float:y, Float:z, Float:px, Float:py, Float:pz;

    for(playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid))
        {
            if(PostmanWorking[playerid] && PostmanVehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(PostmanVehicle[playerid]))
                DestroyVehicle(PostmanVehicle[playerid]);

            PostmanWorking[playerid] = false;
            PostmanVehicle[playerid] = INVALID_VEHICLE_ID;
            PostmanNearBase[playerid] = false;
            continue;
        }

        base = Postman_GetBaseByPlayer(playerid);

        if(base != -1)
        {
            PostmanNearBase[playerid] = true;

            if(PostmanWorking[playerid] && PostmanDelivery[playerid] >= POSTMAN_DELIVERIES)
            {
                finishBase = PostmanFinishBase[playerid];

                if(base == finishBase)
                {
                    money = Postman_Stop(playerid, true);

                    new message[96];
                    format(message, sizeof message, "Рабочая смена завершена. Вы заработали %d в‚Ѕ.", money);
                    SendClientMessage(playerid, 0x33CC33FF, message);
                }
            }
        }
        else
        {
            PostmanNearBase[playerid] = false;
        }

        if(PostmanWorking[playerid] && PostmanDelivery[playerid] < POSTMAN_DELIVERIES)
        {
            index = PostmanRoute[playerid][PostmanDelivery[playerid]];
            Postman_GetPoint(PostmanBase[playerid], index, px, py, pz);

            GetPlayerPos(playerid, x, y, z);

            if(Postman_Distance(x, y, px, py) <= 5)
            {
                Postman_Deliver(playerid);
                SendClientMessage(playerid, 0x33CC33FF, "Посылка доставлена.");
            }
        }
    }
    return 1;
}

stock Postman_Init()
{
    new i;
    if(PostmanInitialized) return 1;
    PostmanInitialized = true;

    for(i = 0; i < POSTMAN_BASE_COUNT; i++)
    {
        PostmanBaseActor[i] = CreateActor(
            34,
            PostmanBaseData[i][0],
            PostmanBaseData[i][1],
            PostmanBaseData[i][2],
            PostmanBaseData[i][3]
        );

        PostmanBasePickup[i] = CreatePickup(
            1275,
            23,
            PostmanBaseData[i][4],
            PostmanBaseData[i][5],
            PostmanBaseData[i][6],
            -1
        );
    }

    PostmanTimer = SetTimer("Postman_Tick", 500, true);
    return 1;
}

stock Postman_OnDialogResponse(playerid, dialogid, response, listitem)
{
    if(dialogid == POSTMAN_DIALOG_MAIN)
    {
        if(!response)
        {
            ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
            return 1;
        }
        if(listitem == 0) return Postman_ShowInfo(playerid);
        if(listitem == 1)
        {
            if(PostmanWorking[playerid])
            {
                new money = Postman_Stop(playerid, true);
                new message[96];
                format(message, sizeof message, "Вы закончили работу. Заработано: %d \xf0\xf3\xe1.", money);
                SendClientMessage(playerid, 0x33CC33FF, message);
            }
            else
            {
                new base = Postman_GetBaseByPlayer(playerid);
                if(base == -1) return SendClientMessage(playerid, 0xFF3333FF, "Подойдите к базе почты.");
                Postman_Start(playerid, base);
            }
            return 1;
        }
        if(listitem == 2)
        {
            if(!PostmanStatsLoaded[playerid]) return Postman_LoadStats(playerid, true);
            return Postman_ShowStatistics(playerid);
        }
        return 1;
    }
    if(dialogid == POSTMAN_DIALOG_INFO || dialogid == POSTMAN_DIALOG_STATS) return Postman_ShowMain(playerid);
    return 0;
}

public OnGameModeInit()
{
    Postman_Init();

    if(funcidx("Postman_GM_OnGameModeInit") != -1)
        return CallLocalFunction("Postman_GM_OnGameModeInit", "");

    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Postman_GM_OnGameModeInit
forward Postman_GM_OnGameModeInit();

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new result = Postman_OnDialogResponse(playerid, dialogid, response, listitem);

    if(result)
        return 1;

    if(funcidx("Postman_GM_OnDialogResponse") != -1)
        return CallLocalFunction("Postman_GM_OnDialogResponse", "dddds", playerid, dialogid, response, listitem, inputtext);

    return 0;
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Postman_GM_OnDialogResponse
forward Postman_GM_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

stock Postman_OnPlayerPickUpPickupEx(playerid, pickupid)
{
    if(pickupid != PostmanBasePickup[0] &&
       pickupid != PostmanBasePickup[1] &&
       pickupid != PostmanBasePickup[2])
        return 0;

    return Postman_LoadStats(playerid, true);
}

stock Postman_OnPlayerEnterCheckpoint(playerid)
{
    // Почтальон использует GPS и собственную проверку расстояния в Postman_Tick().
    // Оставляем 0, чтобы не ломать общий обработчик чекпоинтов.
    #pragma unused playerid
    return 0;
}

stock Postman_OnPlayerDisconnect(playerid, reason)
{
    #pragma unused reason

    if(PostmanWorking[playerid])
        Postman_Stop(playerid, false);
    Postman_SaveStats(playerid);
    PostmanStatsLoaded[playerid] = false;
    PostmanStatsLoading[playerid] = false;
    PostmanJobLevel[playerid] = 1;
    PostmanTotalDeliveries[playerid] = 0;
    PostmanTotalEarned[playerid] = 0;

    return 1;
}

