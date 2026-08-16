enum ENUM_CASE_AWARDS {
    aType,
    aInternalID,
    aCount,
    aName[32],
    aSprayPrice
};

new CaseDailyAwards[20][ENUM_CASE_AWARDS] = {
    {11, 23, 1, "Рем.комплект", 10},
    {1, 1, 2, "2 EXP", 0},
    {10, 1, 200, "200 BP EXP", 0},
    {11, 21, 1, "Канистра с бензином", 10},
    {2, 1, 4000, "4000 Р", 0},
    {10, 1, 5, "5 BC", 0},
    {2, 1, 8000, "8000 Р", 0},
    {10, 1, 10, "10 BC", 0},
    {9, 1, 2, "VIP SILVER 2Ч.", 10},
    {10, 1, 400, "400 BP EXP", 0},
    {1, 1, 4, "4 EXP", 0},
    {5, 462, 0, "RACER SPORT", 20},
    {10, 1, 500, "500 BP EXP", 0},
    {2, 1, 20000, "20000 Р", 0},
    {10, 1, 15, "15 BC", 0},
    {9, 2, 2, "VIP GOLD 2Ч.", 10},
    {10, 1, 600, "600 BP EXP", 0},
    {2, 1, 30000, "30000 Р", 0},
    {1, 1, 6, "6 EXP", 0},
    {5, 549, 0, "ВАЗ 1111", 20}
};

new CaseSpecialAwards[20][ENUM_CASE_AWARDS] = {
    {5, 410, 0, "Mercedes-Benz C63s", 230},
    {5, 604, 0, "Porsche Panamera S", 260},
    {5, 2389, 0, "BMW M6 F12", 270},
    {5, 2574, 0, "BMW X7 M50i", 290},
    {5, 2586, 0, "Jaguar XK120", 340},
    {5, 2593, 0, "Lamborghini Gallardo", 340},
    {5, 2585, 0, "Mercedes-Benz 300SL", 340},
    {5, 2551, 0, "Lamborghini Urus", 350},
    {5, 2549, 0, "Lamborghini Huracan", 370},
    {5, 2393, 0, "Corvette C8", 370},
    {5, 579, 0, "Mercedes-Benz G65 AMG", 370},
    {5, 2619, 0, "Ferrari 488 Pista", 460},
    {5, 2583, 0, "Rolls-Royce Wraith", 530},
    {5, 669, 0, "Tesla CyberTruck", 570},
    {5, 2564, 0, "Rolls-Royce Cullinan", 570},
    {5, 2591, 0, "Continental GT", 670},
    {5, 2601, 0, "BUGATTI CHIRON", 800},
    {5, 667, 0, "Koenigsegg Regera", 850},
    {5, 666, 0, "Bugatti Veyron", 900},
    {5, 466, 1, "BMW M5 F90 (ППС)", 900}
};

new CaseDriveAwards[25][ENUM_CASE_AWARDS] = {
    {134, 134, 14386, "Бархатные тяги", 100},
    {11, 360, 1, "Кейс черный", 100},
    {11, 946, 1, "Маска Fresh'а", 120},
    {11, 511, 1, "Крылья ангела", 100},
    {11, 945, 1, "Рюкзак Energy", 100},
    {10, 1, 700, "700 BC", 0},
    {10, 1, 7000, "7000 BP EXP", 0},
    {134, 134, 11917, "Хоуми с района", 110},
    {23, 1, 3000, "Елочные шары Х3000", 0},
    {5, 2568, 0, "BMW X5 E53", 110},
    {11, 944, 1, "Сумка SpeedPack", 140},
    {134, 134, 5885, "Искра", 140},
    {134, 134, 5326, "Снеговик", 130},
    {5, 603, 0, "FORD MUSTANG GT", 140},
    {23, 1, 7500, "Елочные шары Х7500", 0},
    {5, 442, 0, "Volvo V60", 170},
    {23, 1, 5000, "Елочные шары Х5000", 0},
    {134, 134, 5884, "Петр Шторм", 160},
    {5, 503, 0, "DODGE DEMON SRT", 230},
    {23, 1, 15000, "Елочные шары Х15000", 0},
    {5, 2603, 0, "Mercedes E63 W212", 250},
    {5, 502, 0, "Nissan GT-R R35", 260},
    {5, 2599, 0, "BMW 750Li", 340},
    {5, 659, 48, "Renault R5 Turbo", 180},
    {5, 661, 49, "Ferrari 812", 490}
};

new CaseStandartAwards[37][ENUM_CASE_AWARDS] = {
    {11, 362, 1, "Золотая корона", 90},
    {9, 2, 504, "VIP GOLD 21 дн.", 90},
    {2, 1, 600000, "600000 P", 0},
    {11, 360, 1, "Кейс черный", 90},
    {5, 527, 0, "BMW M3 E46", 100},
    {134, 134, 11962, "Рыбак", 90},
    {10, 1, 600, "600 BC", 0},
    {9, 3, 360, "VIP PLATINUM 15 д.", 100},
    {5, 445, 0, "ACURA TSX", 100},
    {11, 583, 1, "Мопс на спину", 100},
    {134, 134, 14388, "Бархатные тяги особые", 100},
    {11, 508, 1, "Корона демона", 100},
    {134, 134, 11917, "Хоуми с района", 110},
    {5, 589, 0, "VOLKSWAGEN GOLF GTI", 110},
    {5, 2568, 0, "BMW X5 E53", 110},
    {5, 2385, 0, "NISSAN QASHQAI", 120},
    {5, 2623, 0, "TOYOTA CAMRY XV55", 120},
    {5, 2627, 0, "NISSAN SILVIA S15", 120},
    {5, 461, 0, "DUCATI SUPERSPORT S", 130},
    {2, 1, 1000000, "1000000 P", 0},
    {9, 3, 720, "VIP PLATINUM 30 д.", 130},
    {134, 134, 236, "Барыга преступник", 130},
    {5, 2567, 0, "BMW M5 E60", 130},
    {134, 134, 11935, "Мент из клипа", 140},
    {5, 560, 0, "SUBARU WRX STI", 140},
    {134, 134, 5323, "Вурдалаак страшный дед", 140},
    {5, 2584, 0, "KIA K5", 150},
    {5, 2390, 0, "BMW X5M E70", 160},
    {5, 543, 0, "CHEVROLET CAMARO ZL1", 200},
    {5, 2394, 0, "DODGE CHARGER SRT", 200},
    {11, 707, 1, "Маска свина", 220},
    {5, 402, 0, "MERCEDES-BENZ GT63S", 240},
    {5, 2598, 0, "BMW M4 G82", 250},
    {5, 400, 0, "BMW X6M F16", 260},
    {5, 506, 0, "PORSCHE 911 CARRERA S", 270},
    {5, 415, 0, "LAMBORGHINI AVENTADOR S", 400},
    {5, 2543, 0, "TESLA MODEL X", 400}
};

new CaseAutoAwards[31][ENUM_CASE_AWARDS] = {
    {5, 436, 0, "MITSUBISHI LANCER EVO X", 130},
    {5, 2567, 0, "BMW M5 E60", 130},
    {5, 560, 0, "SUBARU WRX STI", 140},
    {5, 550, 0, "TOYOTA CAMRY 3.5", 140},
    {5, 2584, 0, "KIA K5", 150},
    {5, 603, 0, "FORD MUSTANG GT", 150},
    {5, 2552, 0, "TOYOTA SUPRA A80", 150},
    {5, 565, 0, "MERCEDES-BENZ A45 AMG", 150},
    {5, 2609, 0, "MINI COUNTRYMAN", 160},
    {5, 2604, 0, "VOLKSWAGEN PASSAT", 160},
    {5, 551, 0, "ALFA ROMEO GUILIA", 160},
    {5, 2390, 0, "BMW X5M E70", 160},
    {5, 526, 0, "INFINITI Q60S", 160},
    {5, 2620, 0, "LEXUS RCF", 170},
    {5, 2594, 0, "SUBARU BRZ", 180},
    {5, 2621, 0, "XPENG P7", 180},
    {5, 2387, 0, "BMW 3-SERIES G20", 200},
    {5, 480, 0, "BMW Z4 M40I", 200},
    {5, 2394, 0, "DODGE CHARGER SRT", 200},
    {5, 558, 0, "BMW M4 F84", 210},
    {5, 402, 0, "MERCEDES-BENZ GT63S", 240},
    {5, 2598, 0, "BMW M4 G82", 250},
    {5, 502, 0, "NISSAN GT-R R35", 260},
    {5, 2596, 0, "DODGE RAM", 260},
    {5, 400, 0, "BMW X6M F16", 260},
    {5, 604, 0, "PORSCHE PANAMERA S", 260},
    {5, 506, 0, "PORSCHE 911 CARRERA", 270},
    {5, 415, 0, "LAMBORGHINI AVENTADOR S", 400},
    {5, 2543, 0, "TESLA MODEL X", 400},
    {5, 2558, 0, "MERCEDES-BENZ MAYBACH S650", 450},
    {5, 2573, 0, "MERCEDES-BENZ G63 AMG", 430}
};

new CaseBomjAwards[28][ENUM_CASE_AWARDS] = {
    {5, 468, 0, "Aprilla MXV 450", 20},
    {5, 496, 0, "VOLKSWAGEN GOLF GTI 2", 20},
    {2, 1, 75000, "75000 P", 0},
    {5, 404, 0, "BA3 2107", 20},
    {1, 1, 12, "12 EXP", 0},
    {5, 439, 0, "BA3 2108", 20},
    {2, 1, 90000, "90000 P", 0},
    {5, 492, 0, "BA3 2109", 20},
    {5, 547, 0, "BA3 2110", 20},
    {5, 458, 0, "BA3 2114", 20},
    {9, 1, 168, "VIP SILVER 7", 20},
    {5, 491, 0, "BA3 2112", 20},
    {5, 585, 0, "BA3 2115", 20},
    {1, 1, 16, "16 EXP", 0},
    {2, 1, 120000, "120000 P", 0},
    {9, 2, 72, "VIP GOLD 3", 20},
    {5, 536, 0, "VOLVO 242DL", 20},
    {5, 529, 0, "BA3 2170", 20},
    {9, 3, 72, "VIP PLATINUM 3", 20},
    {5, 542, 0, "NIVA URBAN", 20},
    {5, 421, 0, "Mercedes W124", 20},
    {5, 2618, 0, "BMW M3 E36", 20},
    {5, 2548, 0, "LADA VESTA", 30},
    {11, 706, 1, "Glasses", 30},
    {5, 516, 0, "VW POLO", 30},
    {11, 705, 1, "Backpack", 30},
    {134, 134, 252, "Igla", 40},
    {134, 134, 6810, "King", 40}
};

stock GetPlayerDustValue(playerid)
{
    return GetPVarInt(playerid, "player_dust");
}

stock SavePlayerCasesState(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[256];

    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET case_daily=%d,case_bomj=%d,case_standart=%d,case_auto=%d,case_special=%d,case_dust=%d WHERE id=%d LIMIT 1",
        GetPlayerData(playerid, P_CASE_DAILY),
        GetPlayerData(playerid, P_CASE_BOMJ),
        GetPlayerData(playerid, P_CASE_STANDART),
        GetPlayerData(playerid, P_CASE_AUTO),
        GetPlayerData(playerid, P_CASE_SPECIAL),
        GetPlayerDustValue(playerid),
        GetPlayerAccountID(playerid)
    );

    mysql_tquery(mysql, query);
    return 1;
}

stock AddPlayerDustValue(playerid, amount)
{
    new dust = GetPVarInt(playerid, "player_dust");
    dust += amount;

    if(dust < 0) dust = 0;

    if(dust >= 2000)
    {
        new reward = dust / 2000;
        new remainder = dust % 2000;

        AddPlayerCaseCountByType(playerid, 5, reward);

        new msg[144];
        format(msg, sizeof(msg),
            "Вы накопили %d пыли и получили %d особый кейс",
            dust, reward
        );

        ShowNotificationMisters(playerid,  3, 6, 0, 0, msg, "");

        dust = remainder;
    }

    SetPVarInt(playerid, "player_dust", dust);
    SavePlayerCasesState(playerid);
    return dust;
}

stock GetPlayerCaseCountByType(playerid, case_type)
{
    switch(case_type)
    {
        case 1: return GetPlayerData(playerid, P_CASE_DAILY);
        case 2: return GetPlayerData(playerid, P_CASE_BOMJ);
        case 3: return GetPlayerData(playerid, P_CASE_STANDART);
        case 4: return GetPlayerData(playerid, P_CASE_AUTO);
        case 5: return GetPlayerData(playerid, P_CASE_SPECIAL);
    }
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(value < 0) value = 0;

    switch(case_type)
    {
        case 1: SetPlayerData(playerid, P_CASE_DAILY, value);
        case 2: SetPlayerData(playerid, P_CASE_BOMJ, value);
        case 3: SetPlayerData(playerid, P_CASE_STANDART, value);
        case 4: SetPlayerData(playerid, P_CASE_AUTO, value);
        case 5: SetPlayerData(playerid, P_CASE_SPECIAL, value);
        default: return 0;
    }

    SavePlayerCasesState(playerid);
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(
        playerid,
        case_type,
        GetPlayerCaseCountByType(playerid, case_type) + amount
    );
}

stock Node:BuildPlayerCasesArray(playerid)
{
    new Node:cc_array = JSON_Array();

    for(new i = 1; i <= 5; i++)
    {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));
        
        new Node:inner_array = JSON_Array(cc_obj);

        new Node:wrapper_array = JSON_Array(inner_array);

        cc_array = JSON_Append(cc_array, wrapper_array);
    }
    return cc_array;
}

CMD:cases(playerid, params[])
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetBool(json, "s", false);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));

    new Node:cc_array = JSON_Array();
    
    for (new i = 1; i <= 5; i++)
    {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));

        new Node:tempArray = JSON_Array(cc_obj);

        cc_array = JSON_Append(cc_array, tempArray);
    }
    JSON_SetArray(json, "cc", cc_array);

    OnPacketIncoming(playerid, 73, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, type_case, count;

    if(sscanf(params, "udd", targetid, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case 1-5] [count]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    if(type_case < 1 || type_case > 5)
        return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 5.");

    if(count <= 0)
        return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(targetid, type_case, count);
    SavePlayerCasesState(targetid);

    new str[144];
    format(str, sizeof(str),
        "Вы выдали %d %s кейс игроку %s.",
        count,
        GetCaseName(type_case),
        GetPlayerNameEx(targetid)
    );
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str),
        "Вы получили %d %s кейс",
        count,
        GetCaseName(type_case)
    );
    ShowNotificationCases(targetid, 1, 5, 1, 0, str, "");

    new reason[256];

    format(reason, sizeof reason,
        "[A] %s[%d] выдал %d %s кейс игроку %s[%d] (итого: %d)",
        GetPlayerNameEx(playerid),
        playerid,
        count,
        GetCaseName(type_case),
        GetPlayerNameEx(targetid),
        targetid,
        GetPlayerCaseCountByType(targetid, type_case)
    );

    SendClientMessageToAll(0x999999FF, reason);

    return 1;
}

CMD:reward(playerid, params[])
{
    new query[128];
    SetPVarInt(playerid, "reward_offset", 0);
    mysql_format(mysql, query, sizeof(query),
    "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT 0, 19",
    GetPlayerData(playerid, P_ACCOUNT_ID)
);
mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);

    return 1;
}

forward OnPlayerRewardsLoad(playerid);
public OnPlayerRewardsLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    if(rows == 0)
    {
        if(GetPVarInt(playerid, "reward_offset") == 0)
        {
            ShowNotificationCases(playerid, 2, 4, 1, 1, "У вас нет доступных наград!", "");
            
            new Node:emptyObj = JSON_Object();
            JSON_SetInt(emptyObj, "o", 1);
            JSON_SetInt(emptyObj, "pc", GetPlayerDustValue(playerid));
            JSON_SetArray(emptyObj, "pr", JSON_Array());
            OnPacketIncoming(playerid, 74, emptyObj);
            JSON_Cleanup(emptyObj);
        }
        return 1;
    }

    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(JSONObject, "next_page", (rows > 18) ? 1 : 0);

    new Node:prArray = JSON_Array();
    new display_rows = (rows > 18) ? 18 : rows;

    for(new j = 0; j < display_rows; j++)
{
    new a_id = cache_get_field_content_int(j, "award_id");
    new db_id = cache_get_field_content_int(j, "id");
    new case_id = cache_get_field_content_int(j, "case_id");

    new type, internal, spray_price, name[32];
    new bool:found = false;

    if(case_id == 1 && a_id >= 0 && a_id < 20)
    {
        type = CaseDailyAwards[a_id][aType];
        internal = CaseDailyAwards[a_id][aInternalID];
        spray_price = CaseDailyAwards[a_id][aSprayPrice];
        format(name, sizeof(name), "%s", CaseDailyAwards[a_id][aName]);
        found = true;
    }
    else if(case_id == 2 && a_id >= 0 && a_id < 28)
    {
        type = CaseBomjAwards[a_id][aType];
        internal = CaseBomjAwards[a_id][aInternalID];
        spray_price = CaseBomjAwards[a_id][aSprayPrice];
        format(name, sizeof(name), "%s", CaseBomjAwards[a_id][aName]);
        found = true;
    }
    else if(case_id == 3 && a_id >= 0 && a_id < 37)
    {
        type = CaseStandartAwards[a_id][aType];
        internal = CaseStandartAwards[a_id][aInternalID];
        spray_price = CaseStandartAwards[a_id][aSprayPrice];
        format(name, sizeof(name), "%s", CaseStandartAwards[a_id][aName]);
        found = true;
    }
    else if(case_id == 4 && a_id >= 0 && a_id < 31)
    {
        type = CaseAutoAwards[a_id][aType];
        internal = CaseAutoAwards[a_id][aInternalID];
        spray_price = CaseAutoAwards[a_id][aSprayPrice];
        format(name, sizeof(name), "%s", CaseAutoAwards[a_id][aName]);
        found = true;
    }
    else if(case_id == 5 && a_id >= 0 && a_id < 20)
    {
        type = CaseSpecialAwards[a_id][aType];
        internal = CaseSpecialAwards[a_id][aInternalID];
        spray_price = CaseSpecialAwards[a_id][aSprayPrice];
        format(name, sizeof(name), "%s", CaseSpecialAwards[a_id][aName]);
        found = true;
    }
    else if(case_id == 8 && a_id >= 0 && a_id < 25)
    {
        type = CaseDriveAwards[a_id][aType];
        internal = CaseDriveAwards[a_id][aInternalID];
        spray_price = CaseDriveAwards[a_id][aSprayPrice];
        format(name, sizeof(name), "%s", CaseDriveAwards[a_id][aName]);
        found = true;
    }

    if(found)
    {
        new Node:item = JSON_Object();
        JSON_SetInt(item, "el", internal);
        JSON_SetInt(item, "id", db_id);
        JSON_SetString(item, "n", name);
        JSON_SetInt(item, "st", 1);
        JSON_SetInt(item, "td", type);
        JSON_SetInt(item, "sp", spray_price);

        new Node:tempArray = JSON_Array(item);
        prArray = JSON_Append(prArray, tempArray);
    }
}

    JSON_SetArray(JSONObject, "pr", prArray);
    OnPacketIncoming(playerid, 74, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

forward OnRewardDebug(playerid, db_id, reward_action);
public OnRewardDebug(playerid, db_id, reward_action)
{
    new rows = cache_num_rows();
    if(rows > 0)
    {
        new a_id = cache_get_field_content_int(0, "award_id"); 
new case_id = cache_get_field_content_int(0, "case_id"); 
        
        new type, count, internal, spray_price, name[32];
        new bool:valid = false;

        if(case_id == 1 && a_id >= 0 && a_id < 20) {
            type = CaseDailyAwards[a_id][aType];
            count = CaseDailyAwards[a_id][aCount];
            internal = CaseDailyAwards[a_id][aInternalID];
            spray_price = CaseDailyAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseDailyAwards[a_id][aName]);
            valid = true;
        }
        else if(case_id == 2 && a_id >= 0 && a_id < 28) {
            type = CaseBomjAwards[a_id][aType];
            count = CaseBomjAwards[a_id][aCount];
            internal = CaseBomjAwards[a_id][aInternalID];
            spray_price = CaseBomjAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseBomjAwards[a_id][aName]);
            valid = true;
        }
        else if(case_id == 3 && a_id >= 0 && a_id < 37) {
            type = CaseStandartAwards[a_id][aType];
            count = CaseStandartAwards[a_id][aCount];
            internal = CaseStandartAwards[a_id][aInternalID];
            spray_price = CaseStandartAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseStandartAwards[a_id][aName]);
            valid = true;
        }
        else if(case_id == 4 && a_id >= 0 && a_id < 31) {
            type = CaseAutoAwards[a_id][aType];
            count = CaseAutoAwards[a_id][aCount];
            internal = CaseAutoAwards[a_id][aInternalID];
            spray_price = CaseAutoAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseAutoAwards[a_id][aName]);
            valid = true;
        }
        else if(case_id == 5 && a_id >= 0 && a_id < 20) {
            type = CaseSpecialAwards[a_id][aType];
            count = CaseSpecialAwards[a_id][aCount];
            internal = CaseSpecialAwards[a_id][aInternalID];
            spray_price = CaseSpecialAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseSpecialAwards[a_id][aName]);
            valid = true;
        }
        else if(case_id == 8 && a_id >= 0 && a_id < 25) {
            type = CaseDriveAwards[a_id][aType];
            count = CaseDriveAwards[a_id][aCount];
            internal = CaseDriveAwards[a_id][aInternalID];
            spray_price = CaseDriveAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseDriveAwards[a_id][aName]);
            valid = true;
        }

        if(!valid) return 1;

        new bool:should_delete = true;

        if(reward_action == 3)
        {
            if(spray_price > 0)
            {
                new got_dust = AddPlayerDustValue(playerid, spray_price);
                new dust_notify[128];
                format(dust_notify, sizeof(dust_notify), "Вы распылили награду и получили %d пыли.", spray_price, got_dust);
                ShowNotificationMisters(playerid,  3, 6, 0, 0, dust_notify, "");
            }
            else
            {
                ShowNotificationCases(playerid, 2, 4, 1, 1, "Эту награду нельзя распылить!", "");
                should_delete = false;
            }
        }
        else
        {
            switch(type)
            {
                case 1: {
                    new exp = GetPlayerData(playerid, P_EXP) + count;
new level = (exp / 4) + 1;

SetPlayerData(playerid, P_EXP, exp);
SetPlayerData(playerid, P_LEVEL, level);
SetPlayerScore(playerid, level);
                }
                case 2: GivePlayerMoneyEx(playerid, count); 
                                case 5: {
                    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
                    {
                        ShowNotificationMisters(playerid,  2, 6, 0, 0, "Нет свободного слота для транспорта. Купите слот и заберите награду позже.", "");
                        should_delete = false;
                    }
                    else
                    {
                        new game_id = internal;
                        if(game_id == -1)
                        {
                            ShowNotificationCases(playerid, 2, 4, 1, 1, "Ошибка награды: модель транспорта не найдена.", "");
                            should_delete = false;
                        }
                        else
                        {
                            BuyPlayerCar(playerid, internal, game_id, 0);
                            ShowNotificationMisters(playerid,  3, 6, 0, 0, "Транспорт добавлен в список личных ТС.", "");
                        }
                    }
                }
                case 9: {
                    SetPlayerData(playerid, P_PREMIUM, internal);
SetPlayerData(playerid, P_PREMIUM_TIME, count * 60);
                }
                case 11: { // Обычные предметы аксы и скины
                   /* if(GivePlayerItem(playerid, internal, count)) {
                        new notify[128];
                        format(notify, sizeof(notify), "Вы получили предмет: %s (%d шт.)", name, count);
                        ShowNotificationCases(playerid, 1, 5, 1, 0, notify, "");
                    } else {
                        ShowNotificationCases(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
                        should_delete = false;
                    } */
                }
                case 134: {
                    if(SetPlayerSkin(playerid, count)) {
                        new notify[128];
                        format(notify, sizeof(notify), "Вы получили скин: %s", name);
                        ShowNotificationCases(playerid, 1, 5, 1, 0, notify, "");
                    } else {
                        ShowNotificationCases(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
                        should_delete = false;
                    }
                }
                case 10: GivePlayerDonateRub(playerid, count);
            }
        }

        if(should_delete) {
            SavePlayerAccount(playerid);
            new d_query[128];
            mysql_format(mysql, d_query, sizeof(d_query), "DELETE FROM `rewards` WHERE `id` = %d", db_id);
mysql_tquery(mysql, d_query, "", "");

            new Node:res = JSON_Object();
            JSON_SetInt(res, "t", 4); 
            JSON_SetInt(res, "s", 1); 
            JSON_SetInt(res, "id", db_id);
            JSON_SetInt(res, "pc", GetPlayerDustValue(playerid));
            OnPacketIncoming(playerid, 74, res);
            JSON_Cleanup(res);
        }
    }
    return 1;
}
forward OnCarAwardAdded(playerid, slot);
public OnCarAwardAdded(playerid, slot)
{
//    VehicleInfo[playerid][slot][vDBID] = cache_insert_id();
    return 1;
}

stock GetCaseMaxRange(case_id)
{
    switch(case_id)
    {
        case 1: return 20;
        case 2: return 28;
        case 3: return 37;
        case 4: return 31;
        case 5: return 20;
        case 8: return 25;
    }
    return 0;
}

stock GetCaseAwardSprayPriceByIndex(case_id, award_id)
{
    if(award_id < 0) return 0;

    switch(case_id)
    {
        case 1: if(award_id < sizeof(CaseDailyAwards)) return CaseDailyAwards[award_id][aSprayPrice];
        case 2: if(award_id < sizeof(CaseBomjAwards)) return CaseBomjAwards[award_id][aSprayPrice];
        case 3: if(award_id < sizeof(CaseStandartAwards)) return CaseStandartAwards[award_id][aSprayPrice];
        case 4: if(award_id < sizeof(CaseAutoAwards)) return CaseAutoAwards[award_id][aSprayPrice];
        case 5: if(award_id < sizeof(CaseSpecialAwards)) return CaseSpecialAwards[award_id][aSprayPrice];
        case 8: if(award_id < sizeof(CaseDriveAwards)) return CaseDriveAwards[award_id][aSprayPrice];
    }
    return 0;
}

stock ResetOpenedCaseRewards(playerid)
{
    for(new i = 1; i <= 100; i++)
    {
        new key[24];
        format(key, sizeof(key), "open_case_%d", i);
        DeletePVar(playerid, key);
    }
    DeletePVar(playerid, "case_open_total");
    return 1;
}

stock AddOpenedCaseReward(playerid, reward_ui_id)
{
    if(reward_ui_id <= 0 || reward_ui_id > 100) return 0;

    new key[24];
    format(key, sizeof(key), "open_case_%d", reward_ui_id);

    SetPVarInt(playerid, key, GetPVarInt(playerid, key) + 1);
    SetPVarInt(playerid, "case_open_total", GetPVarInt(playerid, "case_open_total") + 1);
    return 1;
}

stock ConsumeOpenedCaseReward(playerid, reward_ui_id)
{
    if(reward_ui_id <= 0 || reward_ui_id > 100) return false;

    new key[24];
    format(key, sizeof(key), "open_case_%d", reward_ui_id);

    new cnt = GetPVarInt(playerid, key);
    if(cnt <= 0) return false;

    SetPVarInt(playerid, key, cnt - 1);

    new total = GetPVarInt(playerid, "case_open_total");
    if(total > 0) SetPVarInt(playerid, "case_open_total", total - 1);
    return true;
}

stock ShowNotificationCases(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    OnPacketIncoming(playerid, 13, JSONObject);
}

stock GiveAllPlayersCases(playerid, case_type, count)
{
    if (case_type < 1 || case_type > 5)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Тип кейса должен быть от 1 до 5.");

    if (count <= 0)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Количество должно быть больше 0.");

    if (count > 1000)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Лимит: максимум 1000 кейсов за раз.");

    new text[64], razdacha[192];

    format(text, sizeof text, "Раздача кейсов от %s", GetPlayerNameEx(playerid));

    foreach (new i : Player)
    {
        if (!IsPlayerLogged(i)) continue;

        AddPlayerCaseCountByType(i, case_type, count);
        SavePlayerCasesState(i);

        new msg[144];
        format(msg, sizeof msg,
            "Вы получили %d %s кейс",
            count,
            GetCaseName(case_type)
        );

        ShowNotificationCases(i, 1, 5, 1, 0, msg, "");
    }

    format(razdacha, sizeof razdacha,
        "{FF4500}[РАЗДАЧА КЕЙСОВ]{FFFFFF} Администратор {00BFFF}%s {FFFFFF}выдал всем игрокам по {FFD700}%d %s кейс!",
        GetPlayerNameEx(playerid),
        count,
        GetCaseName(case_type)
    );
    SendClientMessageToAll(-1, razdacha);

    new adminmsg[192];

format(adminmsg, sizeof adminmsg,
    "[A] %s[%d] выдал всем игрокам %d %s кейс",
    GetPlayerNameEx(playerid),
    playerid,
    count,
    GetCaseName(case_type),
    count
);

foreach (new i : Player)
{
    if (GetPlayerAdminEx(i) >= 1)
    {
        SendClientMessage(i, 0x999999FF, adminmsg);
    }
}

    printf("[РАЗДАЧА КЕЙСОВ] %s выдал всем по %d %s кейс",
        GetPlayerNameEx(playerid),
        count,
        GetCaseName(case_type)
    );

    return 1;
}

stock GetCaseName(case_type)
{
    new name[32];

    switch(case_type)
    {
        case 1: format(name, sizeof name, "ежедневный");
        case 2: format(name, sizeof name, "бомжа");
        case 3: format(name, sizeof name, "стандартный");
        case 4: format(name, sizeof name, "авто");
        case 5: format(name, sizeof name, "особый");
        default: format(name, sizeof name, "неизвестный");
    }

    return name;
}

CMD:giveallcases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new type, count;

    if (sscanf(params, "dd", type, count))
        return SendClientMessage(playerid, -1, "Используйте: /giveallcases [type 1-5] [count]");

    return GiveAllPlayersCases(playerid, type, count);
}