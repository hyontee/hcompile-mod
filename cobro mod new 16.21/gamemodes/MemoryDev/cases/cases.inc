/*enum ENUM_CASE_AWARDS {
    aType,
    aInternalID,
    aCount,
    aName[32],
    aSprayPrice
};

#define pAdminAuth P_ADMIN_LOGGED
#define pAdminLvl P_ADMIN
#define pName P_NAME
#define pExp P_EXP
#define pLevel P_LEVEL
#define pCountTodayCases P_COUNT_TODAY_CASES
#define pCountBomjCases P_COUNT_BOMJ_CASES
#define pCountStandartCases P_COUNT_STANDART_CASES
#define pCountCarCases P_COUNT_CAR_CASES
#define pCountOsobiyCases P_COUNT_OSOBIY_CASES
#define mysql mysql

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

stock AddPlayerDustValue(playerid, amount)
{
    new dust = GetPVarInt(playerid, "player_dust");
    dust += amount;
    if(dust < 0) dust = 0;
    SetPVarInt(playerid, "player_dust", dust);
    return dust;
}

stock GetPlayerBlackCoin(playerid)
{
    return GetPVarInt(playerid, "player_black_coin");
}

stock GivePlayerBlackCoin(playerid, amount)
{
    new bc = GetPVarInt(playerid, "player_black_coin");
    bc += amount;
    if(bc < 0) bc = 0;
    SetPVarInt(playerid, "player_black_coin", bc);
    return bc;
}

stock ResetOpenedCaseRewards(playerid)
{
    SetPVarInt(playerid, "case_open_total", 0);
    return 1;
}

stock AddOpenedCaseReward(playerid, reward_id)
{
    new total = GetPVarInt(playerid, "case_open_total") + 1;
    SetPVarInt(playerid, "case_open_total", total);
    return total;
}

stock GetCaseAwardSprayPriceByIndex(case_type, index)
{
    switch(case_type)
    {
        case 1:
            if(index >= 0 && index < sizeof(CaseDailyAwards)) return CaseDailyAwards[index][aSprayPrice];
        case 2:
            if(index >= 0 && index < sizeof(CaseBomjAwards)) return CaseBomjAwards[index][aSprayPrice];
        case 3:
            if(index >= 0 && index < sizeof(CaseStandartAwards)) return CaseStandartAwards[index][aSprayPrice];
        case 4:
            if(index >= 0 && index < sizeof(CaseAutoAwards)) return CaseAutoAwards[index][aSprayPrice];
        case 5:
            if(index >= 0 && index < sizeof(CaseSpecialAwards)) return CaseSpecialAwards[index][aSprayPrice];
    }
    return 0;
}

stock GetCaseMaxRange(cs_val)
{
    switch(cs_val)
    {
        case 1: return sizeof(CaseDailyAwards);
        case 2: return sizeof(CaseBomjAwards);
        case 3: return sizeof(CaseStandartAwards);
        case 4: return sizeof(CaseAutoAwards);
        case 5: return sizeof(CaseSpecialAwards);
    }
    return 0;
}

stock GetPlayerCaseCountByType(playerid, case_type)
{
    switch(case_type)
    {
        case 1: return g_player[playerid][pCountTodayCases];
        case 2: return g_player[playerid][pCountBomjCases];
        case 3: return g_player[playerid][pCountStandartCases];
        case 4: return g_player[playerid][pCountCarCases];
        case 5: return g_player[playerid][pCountOsobiyCases];
    }
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(value < 0) value = 0;

    switch(case_type)
    {
        case 1: g_player[playerid][pCountTodayCases] = value;
        case 2: g_player[playerid][pCountBomjCases] = value;
        case 3: g_player[playerid][pCountStandartCases] = value;
        case 4: g_player[playerid][pCountCarCases] = value;
        case 5: g_player[playerid][pCountOsobiyCases] = value;
        default: return 0;
    }
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
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
    JSON_SetInt(json, "bc", GetPlayerBlackCoin(playerid));
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
    if(!g_player[playerid][pAdminAuth] || g_player[playerid][pAdminLvl] < 5) return 1;

    new targetid, type_case, count;
    if(sscanf(params, "udd", targetid, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-5] [count]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > 5) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 5.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(targetid, type_case, count);
    SavePlayerAccount(targetid);

    new str[128];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", count, type_case, g_player[targetid][pName]);
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(targetid, COLOR_WHITE, str);
    return 1;
}

CMD:reward(playerid, params[])
{
    SetPVarInt(playerid, "reward_offset", 0);
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT 0, 19", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);

    return 1;
}

forward OnPlayerRewardsLoad(playerid);
public OnPlayerRewardsLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);

    if(rows == 0)
    {
        if(GetPVarInt(playerid, "reward_offset") == 0)
        {
            ShowNotificationNew(playerid, 2, 4, 1, 1, "У вас нет доступных наград!", "");
            
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
        new a_id = cache_get_field_content_int(j, "award_id", mysql);
        new db_id = cache_get_field_content_int(j, "id", mysql);
        new case_id = cache_get_field_content_int(j, "case_id", mysql);
        
        new type, internal, spray_price, name[32];
        new bool:found = false;

        if(case_id == 1 && a_id >= 0 && a_id < 20) {
            type = CaseDailyAwards[a_id][aType];
            internal = CaseDailyAwards[a_id][aInternalID];
            spray_price = CaseDailyAwards[a_id][aSprayPrice];
            spray_price = CaseDailyAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseDailyAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 2 && a_id >= 0 && a_id < 28) {
            type = CaseBomjAwards[a_id][aType];
            internal = CaseBomjAwards[a_id][aInternalID];
            spray_price = CaseBomjAwards[a_id][aSprayPrice];
            spray_price = CaseBomjAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseBomjAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 3 && a_id >= 0 && a_id < 37) {
            type = CaseStandartAwards[a_id][aType];
            internal = CaseStandartAwards[a_id][aInternalID];
            spray_price = CaseStandartAwards[a_id][aSprayPrice];
            spray_price = CaseStandartAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseStandartAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 4 && a_id >= 0 && a_id < 31) {
            type = CaseAutoAwards[a_id][aType];
            internal = CaseAutoAwards[a_id][aInternalID];
            spray_price = CaseAutoAwards[a_id][aSprayPrice];
            spray_price = CaseAutoAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseAutoAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 5 && a_id >= 0 && a_id < 20) {
            type = CaseSpecialAwards[a_id][aType];
            internal = CaseSpecialAwards[a_id][aInternalID];
            spray_price = CaseSpecialAwards[a_id][aSprayPrice];
            spray_price = CaseSpecialAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseSpecialAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 8 && a_id >= 0 && a_id < 25) {
            type = CaseDriveAwards[a_id][aType];
            internal = CaseDriveAwards[a_id][aInternalID];
            spray_price = CaseDriveAwards[a_id][aSprayPrice];
            spray_price = CaseDriveAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseDriveAwards[a_id][aName]);
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
        new a_id = cache_get_field_content_int(0, "award_id", mysql); 
        new case_id = cache_get_field_content_int(0, "case_id", mysql); 
        
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
                ShowNotificationNewNew(playerid, 1, 5, 1, 0, dust_notify, "");
            }
            else
            {
                ShowNotificationNewNew(playerid, 2, 4, 1, 1, "Эту награду нельзя распылить!", "");
                should_delete = false;
            }
        }
        else
        {
            switch(type)
            {
                case 1: {
                    g_player[playerid][pExp] += count;
                    g_player[playerid][pLevel] = (g_player[playerid][pExp] / 4) + 1;
                    SetPlayerScore(playerid, g_player[playerid][pLevel]);
                }
                case 2: GivePlayerMoneyEx(playerid, count); 
                case 5: {
                    new slot = -1;
                    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
                        if(VehicleInfo[playerid][i][vModel] == 0) { slot = i; break; }
                    }
                    if(slot != -1) {
                        VehicleInfo[playerid][slot][vModel] = internal;
                        VehicleInfo[playerid][slot][vPos][0] = 2477.5002;
                        VehicleInfo[playerid][slot][vPos][1] = -741.7479;
                        VehicleInfo[playerid][slot][vPos][2] = 11.3153;
                        VehicleInfo[playerid][slot][vPos][3] = 69.2541;
                        new query[512];
                        mysql_format(mysql, query, sizeof(query), "INSERT INTO `ownable_cars` (`owner_id`, `model`, `x`, `y`, `z`, `a`) VALUES (%d, %d, '%f', '%f', '%f', '%f')", GetPlayerAccountID(playerid), internal, VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1], VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3]);
                        mysql_tquery(mysql, query, "OnCarAwardAdded", "ii", playerid, slot);
                        format(query, 128, "Вы получили транспорт: %s!", name);
                        ShowNotificationNew(playerid, 3, 5, 1, 0, query, "");
                    } else {
                        ShowNotificationNew(playerid, 2, 4, 1, 1, "Нет свободных слотов!", "");
                        should_delete = false; 
                    }
                }
                case 9: {
                    g_player[playerid][pVipType] = internal;
                    g_player[playerid][pVipTime] = count * 60;
                }
                case 11: { // Обычные предметы
                    if(GivePlayerItem(playerid, internal, count)) {
                        new notify[128];
                        format(notify, sizeof(notify), "Вы получили предмет: %s (%d шт.)", name, count);
                        ShowNotificationNew(playerid, 1, 5, 1, 0, notify, "");
                    } else {
                        ShowNotificationNew(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
                        should_delete = false;
                    }
                }
                case 134: {
                    if(GivePlayerSkin(playerid, count)) {
                        new notify[128];
                        format(notify, sizeof(notify), "Вы получили скин: %s", name);
                        ShowNotificationNewNew(playerid, 1, 5, 1, 0, notify, "");
                    } else {
                        ShowNotificationNewNew(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
                        should_delete = false;
                    }
                }
                case 10: GivePlayerBlackCoin(playerid, count);
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
    VehicleInfo[playerid][slot][vDBID] = cache_insert_id();
    return 1;
}
*/
//

stock OpenCase10(playerid, case_id)
{
    new case_sizes[] = {
    20, // case 1
    28, // case 2
    36, // case 3
    31, // case 4
    20, // case 5
    25, // case 6
    25, // case 7
    25, // case 8
    25, // case 9
    25, // case 10
    25, // case 11
    25, // case 12
    25, // case 13
    25, // case 14
    25, // case 15
    25, // case 16
    25, // case 17
    25, // case 18
    25, // case 19
    25, // case 20
    25, // case 21
    25, // case 22
    25, // case 23
    25,  // case 24 (пустой)
    25, // case 25 (АВТО-КЕЙС 3.0)
    6,  // case 26 (КЕЙС С БИЛЕТАМИ ГОНЩИКА)
    53, // case 27 (АВТО-КЕЙС B-C CLASS 24Ч)
    32, // case 28 (АВТО-КЕЙС A-S CLASS 24Ч)
    25, // case 29 (КЕЙС: ЖАРА)
    25  // case 30 (КЕЙС: ПЕКЛО)
};

new Float:chances[][] = {
   {0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05}, // case 1
   {0.029,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.009,0.009,0.005,0.009,0.005,0.009,0.005}, // case 2
   {0.046,0.047,0.047,0.047,0.047,0.024,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.024,0.024,0.024,0.012,0.012,0.012,0.012,0.012,0.012,0.012,0.006,0.006,0.006,0.005,0.01,0.01,0.01,0.01,0.003,0.003}, // case 3
   {0.059,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.008,0.008,0.008,0.008,0.008,0.004,0.004,0.002,0.002,0.001,0.001}, // case 4
   {0.089,0.089,0.089,0.089,0.006,0.089,0.089,0.089,0.089,0.089,0.089,0.016,0.016,0.016,0.016,0.016,0.006,0.006,0.006,0.006}, // case 5
   {0.067,0.067,0.067,0.067,0.033,0.067,0.067,0.067,0.067,0.067,0.067,0.033,0.033,0.027,0.027,0.027,0.027,0.027,0.013,0.027,0.014,0.014,0.014,0.008,0.006}, // case 6
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 7
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 8
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 9
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 10
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 11
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 12
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 13
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 14
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 15
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 16
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 17
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 18
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 19
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 20
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 21
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 22
   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 23

   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 24 (пустой)

   {0.010,0.010,0.010,0.010,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.02,0.02,0.02,0.02,0.08,0.08,0.08,0.05,0.05,0.05,0.05}, // case 25
{0.40,0.24,0.16,0.10,0.07,0.03}, // case 26
{0.05,0.05,0.05,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.015,0.015,0.015,0.015,0.015,0.015,0.01,0.01,0.01,0.01,0.01,0.01,0.008,0.008,0.008,0.008,0.004,0.004,0.003,0.002}, // case 27
 {0.11,0.09,0.08,0.07,0.065,0.06,0.055,0.05,0.045,0.04,0.035,0.025,0.023,0.021,0.019,0.017,0.015,0.013,0.012,0.011,0.01,0.009,0.008,0.007,0.006,0.005,0.004,0.003,0.0025,0.002,0.0015,0.001}, // case 28 // case 28
 {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 29
 {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005} // case 30
};

    new prizes[10];

    // Выбираем 10 случайных призов
    for (new j = 0; j < 10; j++)
    {
        new Float:rand = frandom(1.0);
        new prize_id = -1;
        new Float:cumulative = 0.0;

        for (new i = 0; i < case_sizes[case_id-1]; i++)
        {
            cumulative += chances[case_id-1][i];
            if (rand <= cumulative)
            {
                prize_id = i + 1;
                break;
            }
        }

        if (prize_id == -1) prize_id = 1;
        prizes[j] = prize_id;
    }

    // Формируем JSON-строку для массива призов
    new prStr[512];
    prStr[0] = '\0';
    strcat(prStr, "[", sizeof(prStr));
    for (new i = 0; i < 10; i++)
    {
        format(prStr[strlen(prStr)], sizeof(prStr)-strlen(prStr), "%d%s", prizes[i], (i<9)?"," : "");
    }
    strcat(prStr, "]", sizeof(prStr));

    // Парсим строку в JSON массив
    new Node:prArray = JSON_Array();
    JSON_Parse(prStr, prArray);

    // Создаём response
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 2);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "s", 1);
    JSON_SetArray(response, "pr", prArray);

    OnPacketIncoming(playerid, 73, response);

    // Очистка
    JSON_Cleanup(prArray);
    JSON_Cleanup(response);

    // Лог в консоль
    printf("[Case] Player %d opened case %d -> rewards: ", playerid, case_id);
    for (new i = 0; i < 10; i++) printf("%d ", prizes[i]);
    printf("\n");

    return 1;
}


enum E_CASE_AWARD_NUM {
	CA_ID, CA_RARITY, CA_TYPE, CA_INTERNALID, CA_COUNT, CA_PRICESPRAYED
};

const CASE_COUNT = 30;
const MAX_CASE_ITEMS = 60;
const CA_NAME_LEN = 64;

new CaseAwardsNum[CASE_COUNT][MAX_CASE_ITEMS][6] = {
	// Case 0 (ID 1)
	{
		{1, 1, 11, 23, 1, 10},
		{2, 1, 11, 22, 1, 10},
		{3, 1, 10, 1, 200, 0},
		{4, 1, 11, 21, 1, 10},
		{5, 1, 2, 1, 2000, 0},
		{6, 1, 3, 1, 5, 0},
		{7, 1, 2, 1, 3000, 0},
		{8, 1, 3, 1, 10, 0},
		{9, 1, 9, 1, 2, 10},
		{10, 1, 10, 1, 300, 0},
		{11, 1, 1, 1, 4, 0},
		{12, 1, 5, 462, 0, 20},
		{13, 1, 10, 1, 500, 0},
		{14, 1, 2, 1, 20000, 0},
		{15, 1, 3, 1, 15, 0},
		{16, 1, 9, 2, 2, 10},
		{17, 1, 10, 1, 500, 0},
		{18, 1, 2, 1, 30000, 0},
		{19, 1, 1, 1, 6, 0},
		{20, 1, 5, 549, 0, 20},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 1 (ID 2)
	{
		{1, 1, 5, 468, 0, 20},
		{2, 1, 5, 496, 0, 20},
		{3, 1, 2, 1, 75000, 0},
		{4, 1, 5, 28670, 0, 20},
		{5, 1, 1, 1, 8, 0},
		{6, 1, 5, 439, 0, 20},
		{7, 1, 2, 1, 90000, 0},
		{8, 1, 5, 492, 0, 20},
		{9, 1, 5, 547, 0, 20},
		{10, 1, 5, 458, 0, 20},
		{11, 1, 9, 1, 168, 20},
		{12, 1, 5, 491, 0, 20},
		{13, 1, 5, 585, 0, 20},
		{14, 1, 1, 1, 12, 0},
		{15, 1, 2, 1, 120000, 0},
		{16, 1, 9, 2, 72, 20},
		{17, 1, 5, 536, 0, 20},
		{18, 1, 5, 529, 0, 20},
		{19, 1, 9, 3, 72, 20},
		{20, 1, 5, 542, 0, 20},
		{21, 1, 5, 421, 0, 20},
		{22, 2, 5, 2618, 0, 30},
		{23, 2, 5, 419, 0, 30},
		{24, 3, 11, 705, 1, 30},
		{25, 2, 5, 546, 0, 30},
		{26, 3, 11, 706, 1, 30},
		{27, 3, 11, 134, 6810, 40},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 2 (ID 3)
	{
		{1, 2, 11, 363, 1, 90},
		{2, 2, 9, 2, 504, 90},
		{3, 2, 2, 1, 600000, 0},
		{4, 2, 11, 360, 1, 90},
		{5, 2, 5, 527, 0, 100},
		{6, 2, 3, 1, 600, 0},
		{7, 2, 9, 3, 360, 100},
		{8, 2, 5, 445, 0, 100},
		{9, 2, 11, 583, 1, 100},
		{10, 2, 11, 134, 14386, 100},
		{11, 2, 11, 508, 1, 100},
		{12, 2, 11, 134, 11917, 110},
		{13, 2, 5, 589, 0, 110},
		{14, 2, 5, 2568, 0, 110},
		{15, 2, 11, 134, 11961, 140},
		{16, 2, 5, 2385, 0, 120},
		{17, 2, 5, 28695, 0, 120},
		{18, 2, 5, 2627, 0, 120},
		{19, 2, 5, 461, 0, 130},
		{20, 2, 2, 1, 1000000, 0},
		{21, 3, 9, 3, 720, 130},
		{22, 3, 11, 134, 236, 130},
		{23, 3, 5, 2567, 0, 130},
		{24, 3, 11, 134, 11935, 140},
		{25, 3, 5, 560, 0, 140},
		{26, 3, 11, 134, 19262, 140},
		{27, 3, 5, 2584, 0, 150},
		{28, 3, 5, 2390, 0, 160},
		{29, 3, 5, 543, 0, 200},
		{30, 3, 5, 480, 0, 200},
		{31, 4, 11, 707, 1, 220},
		{32, 4, 5, 402, 0, 240},
		{33, 4, 5, 2598, 0, 250},
		{34, 4, 5, 400, 0, 260},
		{35, 4, 5, 506, 0, 270},
		{36, 5, 5, 415, 0, 400},
		{37, 5, 5, 2543, 0, 400},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 3 (ID 4)
	{
		{1, 3, 5, 436, 0, 130},
		{2, 3, 5, 2567, 0, 130},
		{3, 3, 5, 560, 0, 140},
		{4, 3, 5, 550, 0, 140},
		{5, 3, 5, 28671, 0, 150},
		{6, 3, 5, 603, 0, 150},
		{7, 3, 5, 2552, 0, 150},
		{8, 3, 5, 565, 0, 150},
		{9, 3, 5, 2609, 0, 160},
		{10, 3, 5, 2604, 0, 160},
		{11, 3, 5, 551, 0, 160},
		{12, 3, 5, 2390, 0, 160},
		{13, 3, 5, 526, 0, 160},
		{14, 3, 5, 2620, 0, 170},
		{15, 3, 5, 2594, 0, 180},
		{16, 3, 5, 2621, 0, 180},
		{17, 3, 5, 2387, 0, 200},
		{18, 3, 5, 480, 0, 200},
		{19, 3, 5, 2394, 0, 200},
		{20, 3, 5, 558, 0, 210},
		{21, 4, 5, 28694, 0, 450},
		{22, 4, 5, 28697, 0, 450},
		{23, 4, 5, 402, 0, 240},
		{24, 4, 5, 505, 0, 240},
		{25, 4, 5, 2598, 0, 250},
		{26, 4, 5, 400, 0, 260},
		{27, 4, 5, 2547, 0, 250},
		{28, 4, 5, 506, 0, 270},
		{29, 4, 5, 763, 0, 280},
		{30, 4, 5, 28693, 0, 450},
		{31, 5, 5, 415, 0, 400},
		{32, 5, 5, 2543, 0, 400},
		{33, 5, 5, 2573, 0, 430},
		{34, 5, 5, 2558, 0, 450},
		{35, 5, 5, 2597, 0, 450},
		{36, 5, 5, 2558, 0, 450},
		{37, 5, 5, 28672, 0, 450},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 4 (ID 5)
	{
		{1, 4, 5, 410, 0, 230},
		{2, 4, 5, 604, 0, 260},
		{3, 4, 5, 2389, 0, 270},
		{4, 4, 5, 2574, 0, 290},
		{5, 4, 5, 451, 0, 340},
		{6, 4, 5, 2626, 0, 350},
		{7, 4, 5, 2551, 0, 350},
		{8, 4, 5, 2549, 0, 370},
		{9, 4, 5, 2393, 0, 370},
		{10, 4, 5, 579, 0, 370},
		{11, 5, 5, 2619, 0, 460},
		{12, 5, 5, 657, 0, 490},
		{13, 5, 5, 669, 0, 570},
		{14, 5, 5, 2564, 0, 570},
		{15, 5, 5, 765, 0, 600},
		{16, 5, 5, 2591, 0, 670},
		{17, 5, 5, 2607, 0, 750},
		{18, 5, 5, 2601, 0, 800},
		{19, 5, 5, 667, 0, 850},
		{20, 5, 5, 2570, 0, 900},
		{21, 5, 5, 666, 0, 900},
		{22, 5, 5, 466, 0, 900},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 5 (ID 6)
	{
		{1, 2, 11, 134, 12293, 100},
		{2, 2, 11, 508, 1, 100},
		{3, 2, 11, 511, 1, 100},
		{4, 2, 10, 1, 6000, 0},
		{5, 2, 11, 890, 1, 100},
		{6, 2, 11, 360, 1, 100},
		{7, 2, 3, 1, 700, 0},
		{8, 2, 11, 134, 11917, 110},
		{9, 2, 10, 1, 7000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 2, 2, 1, 750000, 0},
		{12, 2, 11, 891, 1, 120},
		{13, 2, 10, 1, 9000, 0},
		{14, 2, 11, 134, 236, 130},
		{15, 3, 11, 892, 1, 130},
		{16, 3, 11, 134, 6889, 130},
		{17, 3, 11, 134, 6888, 140},
		{18, 3, 5, 603, 0, 140},
		{19, 3, 5, 656, 0, 160},
		{20, 3, 5, 2625, 0, 180},
		{21, 3, 5, 503, 0, 230},
		{22, 4, 5, 2598, 0, 250},
		{23, 4, 5, 502, 0, 260},
		{24, 4, 5, 451, 0, 340},
		{25, 5, 5, 657, 0, 400},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 6 (ID 7)
	{
		{1, 2, 11, 134, 12293, 100},
		{2, 2, 11, 360, 1, 100},
		{3, 2, 11, 940, 1, 120},
		{4, 2, 11, 511, 1, 100},
		{5, 2, 11, 939, 1, 100},
		{6, 2, 3, 1, 700, 0},
		{7, 2, 10, 1, 7000, 0},
		{8, 2, 11, 134, 11917, 110},
		{9, 2, 23, 1, 3000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 3, 11, 938, 1, 140},
		{12, 3, 11, 134, 6868, 140},
		{13, 3, 11, 134, 236, 130},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 23, 1, 7500, 0},
		{16, 3, 5, 2625, 0, 180},
		{17, 3, 23, 1, 5000, 0},
		{18, 4, 11, 134, 6867, 160},
		{19, 4, 5, 503, 0, 230},
		{20, 4, 23, 1, 15000, 0},
		{21, 4, 5, 2598, 0, 250},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 451, 0, 340},
		{24, 4, 5, 633, 0, 180},
		{25, 5, 5, 632, 0, 490},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 7 (ID 8)
	{
		{1, 2, 11, 134, 14386, 100},
		{2, 2, 11, 360, 1, 100},
		{3, 2, 11, 946, 1, 120},
		{4, 2, 11, 511, 1, 100},
		{5, 2, 11, 945, 1, 100},
		{6, 2, 3, 1, 700, 0},
		{7, 2, 10, 1, 7000, 0},
		{8, 2, 11, 134, 11917, 110},
		{9, 2, 23, 1, 3000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 3, 11, 944, 1, 140},
		{12, 3, 11, 134, 5885, 140},
		{13, 3, 11, 134, 5326, 130},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 23, 1, 7500, 0},
		{16, 3, 5, 442, 0, 170},
		{17, 3, 23, 1, 5000, 0},
		{18, 4, 11, 134, 5884, 160},
		{19, 4, 5, 503, 0, 230},
		{20, 4, 23, 1, 15000, 0},
		{21, 4, 5, 2603, 0, 250},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 2599, 0, 340},
		{24, 4, 5, 659, 0, 180},
		{25, 5, 5, 661, 0, 490},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 8 (ID 9)
	{
		{1, 2, 11, 134, 11960, 120},
		{2, 2, 11, 360, 1, 90},
		{3, 2, 11, 324, 1, 90},
		{4, 2, 11, 511, 1, 100},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 11, 134, 11917, 110},
		{8, 2, 11, 362, 1, 90},
		{9, 2, 5, 2568, 0, 110},
		{10, 3, 11, 965, 1, 140},
		{11, 3, 11, 134, 5894, 140},
		{12, 3, 11, 134, 5365, 140},
		{13, 3, 5, 603, 0, 150},
		{14, 3, 2, 1, 1200000, 0},
		{15, 3, 5, 2625, 0, 180},
		{16, 3, 2, 1, 1500000, 0},
		{17, 3, 11, 134, 5893, 160},
		{18, 3, 5, 756, 0, 160},
		{19, 4, 11, 966, 1, 220},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 2, 1, 3000000, 0},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 502, 0, 260},
		{24, 4, 5, 429, 0, 330},
		{25, 5, 5, 755, 0, 600},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 9 (ID 10)
	{
		{1, 2, 11, 134, 12291, 100},
		{2, 2, 11, 360, 1, 100},
		{3, 2, 5, 2384, 0, 110},
		{4, 2, 11, 583, 1, 100},
		{5, 2, 11, 134, 252, 110},
		{6, 2, 3, 1, 700, 0},
		{7, 2, 2, 1, 900000, 0},
		{8, 2, 11, 134, 11917, 110},
		{9, 2, 10, 1, 6000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 2, 11, 970, 1, 120},
		{12, 2, 11, 134, 14388, 100},
		{13, 3, 11, 134, 6895, 140},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 10, 1, 7000, 0},
		{16, 3, 5, 2382, 0, 180},
		{17, 3, 2, 1, 1200000, 0},
		{18, 4, 11, 134, 5898, 230},
		{19, 4, 5, 503, 0, 230},
		{20, 3, 10, 1, 10000, 0},
		{21, 4, 5, 2617, 0, 340},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 429, 0, 330},
		{24, 5, 5, 470, 0, 700},
		{25, 5, 5, 758, 0, 390},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 10 (ID 11)
	{
		{1, 2, 11, 134, 14388, 100},
		{2, 2, 11, 360, 1, 100},
		{3, 2, 11, 295, 1, 80},
		{4, 2, 11, 709, 1, 100},
		{5, 3, 11, 979, 1, 140},
		{6, 2, 3, 1, 800, 0},
		{7, 2, 2, 1, 900000, 0},
		{8, 2, 11, 134, 252, 110},
		{9, 2, 23, 1, 3000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 2, 11, 978, 1, 220},
		{12, 2, 11, 134, 7773, 140},
		{13, 3, 11, 134, 19262, 140},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 23, 1, 7500, 0},
		{16, 3, 5, 442, 0, 170},
		{17, 3, 23, 1, 5000, 0},
		{18, 4, 11, 134, 7772, 230},
		{19, 4, 5, 503, 0, 230},
		{20, 4, 23, 1, 15000, 0},
		{21, 4, 5, 505, 0, 240},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 490, 0, 290},
		{24, 3, 5, 2392, 0, 220},
		{25, 5, 5, 772, 0, 670},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 11 (ID 12)
	{
		{1, 2, 11, 134, 11961, 120},
		{2, 2, 11, 360, 1, 100},
		{3, 2, 11, 915, 1, 120},
		{4, 2, 11, 916, 1, 100},
		{5, 3, 11, 990, 1, 140},
		{6, 2, 3, 1, 800, 0},
		{7, 2, 2, 1, 900000, 0},
		{8, 2, 11, 134, 252, 110},
		{9, 2, 23, 1, 3000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 4, 11, 991, 1, 220},
		{12, 3, 11, 134, 5500008, 140},
		{13, 3, 11, 134, 6893, 140},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 23, 1, 7500, 0},
		{16, 3, 5, 442, 0, 170},
		{17, 3, 23, 1, 5000, 0},
		{18, 4, 11, 134, 5500007, 230},
		{19, 4, 5, 503, 0, 230},
		{20, 4, 23, 1, 15000, 0},
		{21, 4, 5, 622, 0, 240},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 2582, 0, 290},
		{24, 3, 5, 28662, 0, 200},
		{25, 5, 5, 28661, 0, 670},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 12 (ID 13)
	{
		{1, 2, 11, 134, 11917, 110},
		{2, 4, 11, 919, 1, 230},
		{3, 2, 11, 917, 1, 100},
		{4, 2, 11, 159, 1, 90},
		{5, 4, 11, 999, 1, 240},
		{6, 2, 3, 1, 800, 0},
		{7, 2, 2, 1, 900000, 0},
		{8, 2, 11, 134, 252, 110},
		{9, 2, 23, 1, 3000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 3, 11, 1000, 1, 160},
		{12, 4, 11, 1001, 1, 220},
		{13, 3, 11, 134, 5500025, 160},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 23, 1, 7500, 0},
		{16, 3, 5, 442, 0, 170},
		{17, 3, 23, 1, 5000, 0},
		{18, 4, 11, 134, 5500026, 230},
		{19, 4, 5, 503, 0, 230},
		{20, 4, 23, 1, 15000, 0},
		{21, 4, 5, 622, 0, 240},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 2582, 0, 290},
		{24, 3, 5, 480, 0, 210},
		{25, 5, 5, 28680, 0, 570},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 13 (ID 14)
	{
		{1, 2, 11, 134, 14388, 100},
		{2, 2, 11, 924, 1, 100},
		{3, 2, 11, 304, 1, 90},
		{4, 2, 11, 159, 1, 90},
		{5, 4, 11, 1002, 1, 240},
		{6, 2, 3, 1, 800, 0},
		{7, 2, 2, 1, 900000, 0},
		{8, 3, 11, 134, 252, 130},
		{9, 2, 23, 1, 3000, 0},
		{10, 2, 5, 2568, 0, 110},
		{11, 3, 11, 1003, 1, 160},
		{12, 3, 11, 134, 5500028, 160},
		{13, 3, 11, 134, 11935, 140},
		{14, 3, 5, 603, 0, 140},
		{15, 3, 23, 1, 7500, 0},
		{16, 3, 5, 442, 0, 170},
		{17, 3, 23, 1, 5000, 0},
		{18, 4, 11, 134, 5500027, 230},
		{19, 4, 5, 503, 0, 230},
		{20, 4, 23, 1, 15000, 0},
		{21, 4, 5, 2553, 0, 240},
		{22, 4, 5, 502, 0, 260},
		{23, 4, 5, 490, 0, 290},
		{24, 3, 5, 2388, 0, 210},
		{25, 5, 5, 28682, 0, 670},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 14 (ID 15)
	{
		{1, 2, 11, 134, 11917, 110},
		{2, 2, 11, 362, 1, 90},
		{3, 2, 11, 303, 1, 90},
		{4, 2, 11, 169, 1, 80},
		{5, 2, 3, 1, 800, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 3, 11, 134, 236, 130},
		{9, 3, 11, 134, 5500044, 160},
		{10, 3, 11, 134, 6895, 140},
		{11, 3, 5, 603, 0, 140},
		{12, 3, 2, 1, 1200000, 0},
		{13, 3, 5, 442, 0, 170},
		{14, 3, 2, 1, 1500000, 0},
		{15, 3, 5, 2388, 0, 210},
		{16, 3, 11, 1019, 1, 180},
		{17, 4, 11, 1017, 1, 220},
		{18, 4, 11, 1018, 1, 240},
		{19, 4, 11, 134, 5500043, 230},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 2, 1, 3000000, 0},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 502, 0, 260},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28689, 0, 750},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 15 (ID 16)
	{
		{1, 2, 11, 134, 252, 110},
		{2, 2, 11, 144, 1, 70},
		{3, 2, 11, 138, 1, 90},
		{4, 2, 11, 663, 1, 100},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 3, 11, 303, 1, 90},
		{9, 3, 11, 134, 236, 130},
		{10, 3, 11, 134, 5500056, 180},
		{11, 3, 11, 134, 6895, 140},
		{12, 3, 5, 603, 0, 140},
		{13, 3, 23, 1, 7500, 0},
		{14, 3, 5, 442, 0, 170},
		{15, 3, 23, 1, 5000, 0},
		{16, 3, 5, 2388, 0, 210},
		{17, 4, 11, 1030, 1, 240},
		{18, 4, 11, 1029, 1, 240},
		{19, 4, 11, 134, 5500057, 230},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 23, 1, 15000, 0},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 2547, 0, 250},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28706, 0, 570},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 16 (ID 17)
	{
		{1, 2, 11, 134, 252, 110},
		{2, 2, 11, 143, 1, 80},
		{3, 2, 11, 139, 1, 110},
		{4, 2, 11, 663, 1, 100},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 3, 11, 303, 1, 90},
		{9, 3, 11, 134, 11958, 120},
		{10, 3, 11, 134, 5500058, 180},
		{11, 3, 11, 1033, 1, 160},
		{12, 3, 5, 603, 0, 140},
		{13, 3, 23, 1, 7500, 0},
		{14, 3, 5, 442, 0, 170},
		{15, 3, 23, 1, 5000, 0},
		{16, 3, 5, 2388, 0, 210},
		{17, 4, 11, 1031, 1, 240},
		{18, 4, 11, 1032, 1, 240},
		{19, 4, 11, 134, 5500059, 230},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 23, 1, 15000, 0},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 2547, 0, 250},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28708, 0, 800},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 17 (ID 18)
	{
		{1, 2, 11, 134, 14388, 100},
		{2, 2, 11, 533, 1, 70},
		{3, 2, 11, 281, 1, 90},
		{4, 2, 11, 301, 1, 90},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 2, 11, 313, 1, 90},
		{9, 3, 11, 134, 5325, 140},
		{10, 3, 11, 134, 5500070, 180},
		{11, 3, 11, 134, 6895, 140},
		{12, 3, 5, 603, 0, 140},
		{13, 3, 23, 1, 7500, 0},
		{14, 3, 5, 442, 0, 170},
		{15, 3, 23, 1, 5000, 0},
		{16, 3, 5, 2388, 0, 210},
		{17, 4, 11, 1053, 1, 240},
		{18, 4, 11, 1054, 1, 240},
		{19, 4, 11, 134, 5500071, 230},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 23, 1, 15000, 0},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 2547, 0, 250},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28717, 0, 700},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 18 (ID 19)
	{
		{1, 2, 11, 134, 14386, 100},
		{2, 2, 11, 522, 1, 70},
		{3, 2, 11, 287, 1, 90},
		{4, 2, 11, 309, 1, 90},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 2, 11, 313, 1, 90},
		{9, 3, 11, 134, 5326, 140},
		{10, 3, 11, 1058, 1, 160},
		{11, 3, 5, 603, 0, 140},
		{12, 3, 23, 1, 7500, 0},
		{13, 3, 5, 442, 0, 170},
		{14, 3, 23, 1, 5000, 0},
		{15, 3, 5, 2388, 0, 210},
		{16, 4, 11, 134, 5500073, 220},
		{17, 3, 5, 28720, 0, 200},
		{18, 4, 11, 134, 5500072, 220},
		{19, 4, 11, 1055, 1, 220},
		{20, 4, 11, 1056, 1, 220},
		{21, 4, 11, 134, 5500074, 220},
		{22, 4, 23, 1, 15000, 0},
		{23, 4, 5, 2553, 0, 240},
		{24, 4, 5, 2547, 0, 250},
		{25, 5, 5, 28719, 0, 800},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 19 (ID 20)
	{
		{1, 2, 11, 134, 252, 110},
		{2, 2, 11, 917, 1, 100},
		{3, 2, 11, 916, 1, 100},
		{4, 2, 11, 918, 1, 100},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 2, 11, 304, 1, 90},
		{9, 2, 11, 134, 14388, 100},
		{10, 3, 11, 134, 236, 130},
		{11, 3, 11, 134, 19262, 140},
		{12, 3, 5, 603, 0, 140},
		{13, 3, 11, 134, 11935, 140},
		{14, 3, 5, 2382, 0, 180},
		{15, 4, 11, 134, 5500083, 240},
		{16, 2, 11, 360, 1, 90},
		{17, 4, 11, 134, 5500063, 240},
		{18, 4, 11, 134, 5500062, 230},
		{19, 4, 11, 1043, 1, 220},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 11, 1044, 1, 220},
		{22, 4, 5, 429, 0, 330},
		{23, 4, 5, 2547, 0, 250},
		{24, 5, 5, 28724, 0, 400},
		{25, 5, 5, 28723, 0, 570},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 20 (ID 21)
	{
		{1, 2, 11, 134, 11917, 110},
		{2, 2, 11, 367, 1, 70},
		{3, 2, 11, 361, 1, 90},
		{4, 2, 11, 918, 1, 100},
		{5, 2, 3, 1, 700, 0},
		{6, 2, 2, 1, 900000, 0},
		{7, 2, 5, 2568, 0, 110},
		{8, 2, 11, 324, 1, 90},
		{9, 2, 11, 134, 14386, 100},
		{10, 3, 11, 134, 236, 130},
		{11, 3, 2, 1, 1200000, 0},
		{12, 3, 5, 603, 0, 150},
		{13, 3, 11, 134, 11935, 140},
		{14, 3, 2, 1, 1500000, 0},
		{15, 3, 5, 2388, 0, 210},
		{16, 4, 11, 134, 5500081, 230},
		{17, 4, 11, 1066, 1, 230},
		{18, 4, 11, 134, 5500082, 220},
		{19, 4, 11, 1067, 1, 220},
		{20, 4, 5, 503, 0, 230},
		{21, 4, 2, 1, 3000000, 0},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 2547, 0, 250},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28731, 0, 800},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 21 (ID 22)
	{
		{1, 2, 11, 376, 1, 70},
		{2, 2, 11, 365, 1, 80},
		{3, 2, 11, 304, 1, 90},
		{4, 2, 11, 914, 1, 100},
		{5, 2, 11, 134, 14388, 100},
		{6, 2, 11, 134, 11917, 110},
		{7, 2, 3, 1, 700, 0},
		{8, 2, 5, 2568, 0, 110},
		{9, 2, 2, 1, 900000, 0},
		{10, 3, 11, 134, 236, 130},
		{11, 3, 11, 134, 11935, 140},
		{12, 3, 2, 1, 1200000, 0},
		{13, 3, 5, 603, 0, 150},
		{14, 3, 2, 1, 1500000, 0},
		{15, 3, 11, 134, 5500100, 200},
		{16, 3, 5, 2388, 0, 210},
		{17, 4, 11, 1081, 1, 220},
		{18, 4, 11, 134, 5500099, 220},
		{19, 4, 11, 1082, 1, 220},
		{20, 4, 2, 1, 3000000, 0},
		{21, 4, 5, 503, 0, 230},
		{22, 4, 5, 2553, 0, 240},
		{23, 4, 5, 2547, 0, 250},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28738, 0, 750},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 22 (ID 23)
	{
		{1, 2, 11, 368, 1, 70},
		{2, 2, 11, 362, 1, 90},
		{3, 2, 11, 303, 1, 90},
		{4, 2, 11, 917, 1, 100},
		{5, 2, 11, 134, 14388, 100},
		{6, 2, 11, 134, 11917, 110},
		{7, 2, 3, 1, 700, 0},
		{8, 2, 5, 2568, 0, 110},
		{9, 2, 2, 1, 900000, 0},
		{10, 3, 11, 134, 236, 130},
		{11, 3, 11, 134, 11935, 140},
		{12, 3, 2, 1, 1200000, 0},
		{13, 3, 5, 603, 0, 150},
		{14, 3, 2, 1, 1500000, 0},
		{15, 3, 5, 2388, 0, 210},
		{16, 4, 11, 134, 5500102, 220},
		{17, 4, 11, 1083, 1, 220},
		{18, 4, 11, 134, 5500101, 220},
		{19, 4, 11, 1084, 1, 220},
		{20, 4, 2, 1, 3000000, 0},
		{21, 4, 5, 28741, 0, 220},
		{22, 4, 5, 503, 0, 230},
		{23, 4, 5, 2553, 0, 240},
		{24, 4, 5, 490, 0, 290},
		{25, 5, 5, 28740, 0, 700},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 23 (ID 24)
	{
    {1, 2, 11, 367, 1, 70},
    {2, 2, 11, 187, 1, 80},
    {3, 2, 11, 326, 1, 90},
    {4, 2, 11, 134, 12291, 100},
    {5, 2, 11, 134, 14388, 100},
    {6, 2, 11, 709, 1, 100},
    {7, 2, 3, 1, 700, 0},
    {8, 2, 5, 2568, 0, 110},
    {9, 2, 2, 1, 900000, 0},
    {10, 3, 11, 134, 236, 130},
    {11, 3, 11, 134, 11935, 140},
    {12, 3, 2, 1, 1200000, 0},
    {13, 3, 5, 603, 0, 150},
    {14, 3, 2, 1, 1500000, 0},
    {15, 3, 5, 2388, 0, 210},
    {16, 3, 11, 1093, 1, 200},
    {17, 4, 11, 134, 5500107, 220},
    {18, 4, 11, 1092, 1, 220},
    {19, 4, 11, 1091, 1, 220},
    {20, 4, 2, 1, 3000000, 0},
    {21, 4, 5, 503, 0, 240},
    {22, 4, 5, 2553, 0, 230},
    {23, 4, 11, 134, 5500108, 220},
    {24, 4, 5, 490, 0, 290},
    {25, 5, 5, 28749, 0, 750},

   {0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
},
	// Case 24 (ID 25)
	{
		{1, 3, 5, 436, 0, 130},
		{2, 3, 5, 2567, 0, 130},
		{3, 3, 5, 2631, 0, 140},
		{4, 3, 5, 565, 0, 150},
		{5, 4, 5, 28694, 0, 220},
		{6, 4, 5, 402, 0, 240},
		{7, 4, 5, 505, 0, 240},
		{8, 4, 5, 2598, 0, 250},
		{9, 4, 5, 2547, 0, 250},
		{10, 4, 5, 28697, 0, 260},
		{11, 4, 5, 400, 0, 260},
		{12, 4, 5, 506, 0, 260},
		{13, 4, 5, 763, 0, 260},
		{14, 4, 5, 28693, 0, 260},
		{15, 5, 5, 415, 0, 260},
		{16, 5, 5, 2543, 0, 260},
		{17, 5, 5, 2573, 0, 260},
		{18, 5, 5, 2558, 0, 260},
		{19, 5, 5, 2558, 0, 260},
		{20, 5, 5, 28751, 0, 260},
		{21, 5, 5, 28672, 0, 260},
		{22, 5, 5, 411, 0, 260},
		{23, 5, 5, 541, 0, 260},
		{24, 5, 5, 2579, 0, 260},
		{25, 5, 5, 2597, 0, 260},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 25 (ID 26)
	{
		{1, 2, 34, 0, 1, 0},
		{2, 3, 34, 0, 3, 0},
		{3, 3, 34, 0, 5, 0},
		{4, 4, 34, 0, 10, 0},
		{5, 4, 34, 0, 20, 0},
		{6, 5, 34, 0, 30, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 26 (ID 27)
	{
		{1, 1, 5, 649, 24, 10},
		{2, 1, 5, 654, 24, 10},
		{3, 1, 5, 650, 24, 10},
		{4, 2, 5, 529, 24, 10},
		{5, 2, 5, 540, 24, 10},
		{6, 2, 5, 559, 24, 10},
		{7, 2, 5, 562, 24, 10},
		{8, 2, 5, 28730, 24, 10},
		{9, 2, 5, 28677, 24, 10},
		{10, 2, 5, 28737, 24, 10},
		{11, 2, 5, 28702, 24, 10},
		{12, 2, 5, 28658, 24, 10},
		{13, 2, 5, 28688, 24, 10},
		{14, 2, 5, 771, 24, 10},
		{15, 3, 5, 28678, 24, 10},
		{16, 3, 5, 749, 24, 10},
		{17, 3, 5, 477, 24, 10},
		{18, 3, 5, 28699, 24, 10},
		{19, 3, 5, 28728, 24, 10},
		{20, 3, 5, 28685, 24, 10},
		{21, 3, 5, 621, 24, 10},
		{22, 3, 5, 28674, 24, 10},
		{23, 3, 5, 767, 24, 10},
		{24, 3, 5, 764, 24, 10},
		{25, 3, 5, 28669, 24, 10},
		{26, 3, 5, 28700, 24, 10},
		{27, 3, 5, 769, 24, 10},
		{28, 3, 5, 28656, 24, 10},
		{29, 3, 5, 28712, 24, 10},
		{30, 3, 5, 28729, 24, 10},
		{31, 3, 5, 28675, 24, 10},
		{32, 3, 5, 759, 24, 10},
		{33, 3, 5, 768, 24, 10},
		{34, 3, 5, 28676, 24, 10},
		{35, 3, 5, 678, 24, 10},
		{36, 3, 5, 28683, 24, 10},
		{37, 3, 5, 760, 24, 10},
		{38, 3, 5, 751, 24, 10},
		{39, 3, 5, 28667, 24, 10},
		{40, 4, 5, 28735, 24, 10},
		{41, 4, 5, 28694, 24, 10},
		{42, 4, 5, 28732, 24, 10},
		{43, 4, 5, 2547, 24, 10},
		{44, 4, 5, 2550, 24, 10},
		{45, 4, 5, 763, 24, 10},
		{46, 4, 5, 28664, 24, 10},
		{47, 4, 5, 28660, 24, 10},
		{48, 4, 5, 28665, 24, 10},
		{49, 4, 5, 28668, 24, 10},
		{50, 5, 5, 28672, 24, 10},
		{51, 5, 5, 28666, 24, 10},
		{52, 5, 5, 28680, 24, 10},
		{53, 5, 5, 765, 24, 10},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
	},
	// Case 27 (ID 28)
	{
		{1, 4, 5, 503, 24, 10},
		{2, 3, 5, 745, 24, 10},
		{3, 4, 5, 752, 24, 10},
		{4, 4, 5, 28701, 24, 10},
		{5, 4, 5, 28713, 24, 10},
		{6, 4, 5, 28736, 24, 10},
		{7, 4, 5, 28710, 24, 10},
		{8, 4, 5, 28733, 24, 10},
		{9, 4, 5, 551, 24, 10},
		{10, 4, 5, 28720, 24, 10},
		{11, 4, 5, 502, 24, 10},
		{12, 5, 5, 533, 24, 10},
		{13, 5, 5, 2393, 24, 10},
		{14, 5, 5, 740, 24, 10},
		{15, 5, 5, 632, 24, 10},
		{16, 5, 5, 28723, 24, 10},
		{17, 5, 5, 661, 24, 10},
		{18, 5, 5, 28704, 24, 10},
		{19, 5, 5, 28706, 24, 10},
		{20, 5, 5, 28723, 24, 10},
		{21, 5, 5, 755, 24, 10},
		{22, 5, 5, 28705, 24, 10},
		{23, 5, 5, 28661, 24, 10},
		{24, 5, 5, 28682, 24, 10},
		{25, 5, 5, 596, 24, 10},
		{26, 5, 5, 28717, 24, 10},
		{27, 5, 5, 28740, 24, 10},
		{28, 5, 5, 28689, 24, 10},
		{29, 5, 5, 28738, 24, 10},
		{30, 5, 5, 28708, 24, 10},
		{31, 5, 5, 28719, 24, 10},
		{32, 5, 5, 2570, 24, 10},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0}
},
// Case 28 (ID 29)
{
{1, 2, 11, 371, 1, 70},
{2, 2, 11, 297, 1, 80},
{3, 2, 11, 324, 1, 90},
{4, 2, 11, 134, 11917, 110},
{5, 2, 11, 134, 14388, 100},
{6, 2, 11, 511, 1, 100},
{7, 2, 3, 1, 700, 0},
{8, 2, 5, 2568, 0, 110},
{9, 2, 2, 1, 900000, 0},
{10, 3, 23, 1, 5000, 0},
{11, 3, 11, 134, 11935, 140},
{12, 3, 23, 1, 7500, 0},
{13, 3, 5, 603, 0, 150},
{14, 3, 5, 442, 0, 170},
{15, 3, 5, 2388, 0, 210},
{16, 3, 11, 134, 5500116, 220},
{17, 4, 5, 526, 0, 200},
{18, 4, 11, 1103, 1, 220},
{19, 4, 11, 134, 5500115, 220},
{20, 4, 11, 1104, 1, 220},
{21, 4, 23, 1, 15000, 0},
{22, 4, 5, 2553, 0, 240},
{23, 4, 5, 503, 0, 230},
{24, 4, 5, 490, 0, 290},
{25, 5, 5, 28764, 0, 750},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0}
},
// Case 29 (ID 30)
{
{1, 2, 11, 370, 1, 70},
{2, 2, 11, 187, 1, 80},
{3, 2, 11, 324, 1, 90},
{4, 2, 11, 134, 11917, 110},
{5, 2, 11, 134, 14388, 100},
{6, 2, 11, 915, 1, 120},
{7, 2, 3, 1, 700, 0},
{8, 2, 5, 2568, 0, 110},
{9, 2, 2, 1, 900000, 0},
{10, 3, 23, 1, 5000, 0},
{11, 3, 11, 134, 11935, 140},
{12, 3, 23, 1, 7500, 0},
{13, 3, 5, 603, 0, 150},
{14, 3, 5, 442, 0, 170},
{15, 3, 5, 2388, 0, 210},
{16, 4, 5, 526, 0, 200},
{17, 3, 11, 134, 5500118, 220},
{18, 4, 11, 134, 5500117, 220},
{19, 4, 11, 1106, 1, 220},
{20, 4, 11, 1105, 1, 220},
{21, 4, 23, 1, 15000, 0},
{22, 4, 5, 2553, 0, 240},
{23, 4, 5, 503, 0, 230},
{24, 4, 5, 490, 0, 290},
{25, 5, 5, 28765, 0, 750},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0}
}
};

new CaseAwardNames[CASE_COUNT][MAX_CASE_ITEMS][CA_NAME_LEN] = {
	// Case 0 names
	{
		"Рем.комплект",
		"Аптечка",
		"200 BP EXP",
		"Канистра с бензином",
		"2000 Р",
		"5 BC",
		"3000 Р",
		"10 BC",
		"VIP SILVER 2Ч.",
		"300 BP EXP",
		"4 EXP",
		"RACER SPORT",
		"500 BP EXP",
		"20000 Р",
		"15 BC",
		"VIP GOLD 2Ч.",
		"500 BP EXP",
		"30000 Р",
		"6 EXP",
		"ВАЗ 1111",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 1 names
	{
		"Aprilla MXV 450",
		"VOLKSWAGEN GOLF GTI 2",
		"75000 Р",
		"ВАЗ 21099",
		"8 EXP",
		"ВАЗ 2108",
		"90000 Р",
		"ВАЗ 2109",
		"ВАЗ 2110",
		"ВАЗ 2114",
		"VIP SILVER 7 ДН.",
		"ВАЗ 2112",
		"ВАЗ 2115",
		"12 EXP",
		"120000 Р",
		"VIP GOLD 3 ДН.",
		"VOLVO 242DL",
		"ВАЗ 2170",
		"VIP PLATINUM 3 ДН.",
		"NIVA URBAN",
		"Mercedes-Benz W124",
		"BMW M3 E36",
		"Mercedes-Benz E420 W210",
		"РЮКЗАК СИФОНА",
		"HYUNDAI SOLARIS 2021",
		"ПОБИТЫЕ ОЧКИ",
		"КОРОЛЬ БОМЖЕЙ",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 2 names
	{
		"КОРОНА КОРОЛЯ",
		"VIP GOLD 21 ДН.",
		"600000 Р",
		"КЕЙС ЧЕРНЫЙ",
		"BMW M3 E46",
		"600 BC",
		"VIP PLATINUM 15 Д.",
		"ACURA TSX",
		"МОПС НА СПИНУ",
		"БАРХАТНЫЕ ТЯГИ СПОРТИВНЫЕ",
		"КОРОНА ДЕМОНА",
		"ХОУМИ С РАЙОНА",
		"VOLKSWAGEN GOLF GTI",
		"BMW X5 E53",
		"РЫБАЧКА",
		"NISSAN QASHQAI",
		"NISSAN TEANA J32",
		"NISSAN SILVIA S15",
		"DUCATI SUPERSPORT S",
		"1000000 Р",
		"VIP PLATINUM 30 Д.",
		"БАРЫГА ПРЕСТУПНИК",
		"BMW M5 E60",
		"МЕНТ ИЗ КЛИПА",
		"SUBARU WRX STI",
		"ОПАСНЫЙ МУЖЧИНА",
		"KIA K5",
		"BMW X5M E70",
		"CHEVROLET CAMARO ZL1",
		"BMW Z4 M40i ",
		"МАСКА СВИНА",
		"MERCEDES-BENZ GT63S",
		"BMW M4 G82",
		"BMW X6M F16",
		"PORSCHE 911 CARRERA S",
		"LAMBORGHINI AVENTADOR S",
		"TESLA MODEL X",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 3 names
	{
		"MITSUBISHI LANCER EVO X",
		"BMW M5 E60",
		"SUBARU WRX STI",
		"TOYOTA CAMRY 3.5",
		"HAVAL F7X",
		"FORD MUSTANG GT",
		"TOYOTA SUPRA A80",
		"MERCEDES-BENZ A45 AMG",
		"MINI COUNTRYMAN",
		"VOLKSWAGEN PASSAT",
		"ALFA ROMEO GUILIA",
		"BMW X5M E70",
		"INFINITI Q60S",
		"LEXUS RCF",
		"SUBARU BRZ",
		"XPENG P7",
		"BMW 3-SERIES G20",
		"BMW Z4 M40I",
		"DODGE CHARGER SRT",
		"BMW M4 F84",
		"ZEERK 001",
		"LEXUS IS500F PERFOMANCE",
		"MERCEDES-BENZ GT63S",
		"CADILLAC ESCALADE IV",
		"BMW M4 G82",
		"BMW X6M F16",
		"TOYOTA LAND CRUISER 200",
		"PORSCHE 911 CARRERA",
		"Volkswagen Touareg 2022",
		"AUDI E-TRON GT",
		"LAMBORGHINI AVENTADOR S",
		"TESLA MODEL X",
		"MERCEDES-BENZ G63 AMG",
		"MERCEDES-BENZ MAYBACH S650",
		"AURUS SENAT",
		"MERCEDES-BENZ MB S650",
		"MERCEDES-BENZ G63 AMG BRABUS",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 4 names
	{
		"Mercedes-Benz C63s",
		"Porsche Panamera S",
		"BMW M6 F12",
		"BMW X7 M50i",
		"McLaren 600 LT",
		"Porsche Cayenne S",
		"Lamborghini Urus",
		"Lamborghini Huracan",
		"Chevrolet Corvette C8",
		"Mercedes-Benz G65 AMG",
		"Ferrari 488 Pista",
		"Pagani Zonda 2002",
		"Tesla CyberTruck",
		"Rolls-Royce Cullinan",
		"Mercedes-Benz G63 AMG 6x6",
		"BENTLEY Continental GT",
		"BMW M1",
		"BUGATTI CHIRON",
		"Koenigsegg Regera",
		"Bugatti Divo",
		"Bugatti Veyron",
		"BMW M5 F90 (ППС)",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 5 names
	{
		"Емеля",
		"Корона демона",
		"Крылья ангела",
		"6000 BP EXP",
		"Маска дайвера",
		"Кейс черный",
		"700 BC",
		"Хоуми с района",
		"7000 BP EXP",
		"BMW X5 E53",
		"750000 Р",
		"Рюкзак Боксера",
		"9000 BP EXP",
		"Барыга преступник",
		"Водяной пистолет",
		"Модница Ребекка",
		"Качок Джонс",
		"FORD Mustang GT",
		"Nissan 240SX",
		"INFINITI FX50S",
		"DODGE DEMON SRT",
		"BMW M4 G82",
		"Nissan GT-R R35",
		"McLaren 600 LT",
		"Pagani Zonda 2002",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 6 names
	{
		"Емеля",
		"Кейс черный",
		"Живая Росянка",
		"Крылья ангела",
		"Шлем Bunny",
		"700 BC",
		"7000 BP EXP",
		"Хоуми с района",
		"Багровые кристаллы Х3000",
		"BMW X5 E53",
		"Книга Тайн",
		"Токсичная",
		"Барыга преступник",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"INFINITI FX50S",
		"Багровые кристаллы Х5000",
		"Ванко Одержимый",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"BMW M4 G82",
		"Nissan GT-R R35",
		"McLaren 600 LT",
		"Mitsubishi Ecliplse",
		"SCG 003",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 7 names
	{
		"Бархатные тяги спортивные",
		"Кейс черный",
		"Маска Fresh'а",
		"Крылья ангела",
		"Рюкзак Energy",
		"700 BC",
		"7000 BP EXP",
		"Хоуми с района",
		"Багровые кристаллы Х3000",
		"BMW X5 E53",
		"Сумка SpeedPack",
		"Искра",
		"Снеговик не растает",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Петр Шторм",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Mercedes-Benz E63 W212",
		"Nissan GT-R R35",
		"BMW 7-Series 750Li",
		"Renault R5 Turbo 3E",
		"Ferrari 812 Superfast",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 8 names
	{
		"Рыбак",
		"Кейс черный",
		"Очки Санрайз у воды",
		"Крылья ангела",
		"700 BC",
		"900000 Р",
		"Хоуми с района",
		"Золотая корона",
		"BMW X5 E53",
		"Маска Чилл",
		"Леха",
		"Маньяк с мешком",
		"FORD Mustang GT",
		"1200000 Р",
		"INFINITI FX50S",
		"1500000 Р",
		"Серый",
		"Toyota GT86",
		"Сумка мажора",
		"DODGE DEMON SRT",
		"3000000 Р",
		"Audi Q7",
		"Nissan GT-R R35",
		"Mercedes-Benz GT-R",
		"Porsche 918 Spyder",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 9 names
	{
		"Солдатка Красавица",
		"Кейс черный",
		"Вездеход Монстр",
		"МОПС НА СПИНУ",
		"Игла преступник",
		"700 BC",
		"900000 Р",
		"Хоуми с района",
		"6000 BP EXP",
		"BMW X5 E53",
		"Рюкзак Танкиста",
		"Бархатные тяги особые",
		"Сотрудник Фирмы",
		"FORD MUSTANG GT",
		"7000 BP EXP",
		"NIVA 4x4 Storm",
		"1200000 Р",
		"Танковый Ас",
		"DODGE DEMON SRT",
		"10000 BP EXP",
		"Hummer Humvee",
		"Nissan GT-R R35",
		"Mercedes-Benz GT-R",
		"ГАЗ ТИГР",
		"Урал ИМЗ 8 Блиц",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 10 names
	{
		"Бархатные тяги особые",
		"Кейс черный",
		"Черная панама с сигарой",
		"Анимированная Лапка",
		"Кепка-платок Браток",
		"800 BC",
		"900000 Р",
		"Игла преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Электрическая дубинка",
		"Дядя Жора",
		"Опасный мужчина",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Громов",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Cadillac Escalade IV",
		"Nissan GT-R R35",
		"Range Rover SVR",
		"Toyota Supra A90",
		"BMW M5 CS",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 11 names
	{
		"Рыбачка",
		"Кейс черный",
		"Надувной жилет",
		"Очки звездочки",
		"Кулон Драконий камень",
		"800 BC",
		"900000 Р",
		"Игла преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Рюкзак Олигарха",
		"Менеджер клуба",
		"Горячий мужчина",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Варя",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi S5 Coupe 2020",
		"Nissan GT-R R35",
		"Mercedes-Benz CLS63 AMG",
		"BMW X5M F85",
		"Ferrari SF90 Stradale Spider",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 12 names
	{
		"Хоуми с района",
		"Шлем MVP",
		"Очки люкс",
		"Маска ведущего",
		"Рюкзак ускорение",
		"800 BC",
		"900000 Р",
		"Игла преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Голова ОКАК",
		"Сумка Мастера",
		"Шторм Похудевший",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Луна Гонщица",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi S5 Coupe 2020",
		"Nissan GT-R R35",
		"Mercedes-Benz CLS63 AMG",
		"BMW Z4 M40i",
		"Ferrari 308 GTB",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 13 names
	{
		"Бархатные тяги особые",
		"Рюкзак Fuel",
		"Прямые очки 'Огонь'",
		"Маска ведущего",
		"Маска Metal Dragon",
		"800 BC",
		"900000 Р",
		"Барыга преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Рюкзак Дрифтера",
		"Санек Брат",
		"Мент из клипа",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Руслан Дрифтер",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi Q7",
		"Nissan GT-R R35",
		"Range Rover SVR",
		"BMW M5 F10",
		"Lamborghini Countach 2022",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 14 names
	{
		"Хоуми с района",
		"Золотая корона",
		"Очки 'Пламя'",
		"Берет 'Gucci'",
		"800 BC",
		"900000 Р",
		"BMW X5 E53",
		"Барыга преступник",
		"Вика Отличница",
		"Сотрудник Фирмы",
		"FORD MUSTANG GT",
		"1200000 Р",
		"Volvo V60",
		"1500000 Р",
		"BMW M5 F10",
		"Кепка Школьника",
		"Сумка Чемпиона",
		"Рюкзак для вечеринок",
		"Тяжелый Форвард",
		"DODGE DEMON SRT",
		"3000000 Р",
		"Audi Q7",
		"Nissan GT-R R35",
		"Range Rover SVR",
		"Bugatti Centodieci",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 15 names
	{
		"Игла преступник",
		"Красная коса",
		"Шапка ведьмы",
		"Кукла Вуду",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки 'Пламя'",
		"Барыга преступник",
		"Охотник на нечисть",
		"Сотрудник Фирмы",
		"FORD Mustang GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"BMW M5 F10",
		"Мистический Амулет",
		"Цилиндр Доп. Интеллект",
		"Полина Ученая",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"BMW M4 CSL",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 16 names
	{
		"Игла преступник",
		"Железная коса",
		"Шапка с привидением",
		"Кукла Вуду",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки 'Пламя'",
		"Пчелка убийца",
		"Анна Нокс",
		"Рюкзак Монстр",
		"FORD Mustang GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"BMW M5 F10",
		"Рюкзак Гробик",
		"Сумка Котел с зельем",
		"Антиквар Фогг",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"Lamborghini Veneno 2013",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 17 names
	{
		"Бархатные тяги особые",
		"Маска Снегурочка",
		"Новогодний топорик",
		"Новогодняя шапка с рогами",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки салют",
		"Новогодний пингвин",
		"Алина Зимина",
		"Сотрудник Фирмы",
		"FORD Mustang GT",
		"Праздничные звезды Х7500",
		"Volvo V60",
		"Праздничные звезды Х5000",
		"BMW M5 F10",
		"Сноуборд за спину",
		"Рюкзак Снежный шар",
		"Тима Зимин",
		"DODGE DEMON SRT",
		"Праздничные звезды Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"McLaren P1",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 18 names
	{
		"Бархатные тяги спортивные",
		"Маска Деда Мороза",
		"Новогодняя палочка с кристаллом",
		"Гринч",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки Анимированный салют",
		"Снеговик не растает",
		"Голова Коня",
		"FORD Mustang GT",
		"Праздничные звезды Х7500",
		"Volvo V60",
		"Праздничные звезды Х5000",
		"BMW M5 F10",
		"Руслан Джерси",
		"Ford Mustang GT3",
		"Виктор Гонщик",
		"Шлем Мороз",
		"Рюкзак Медведь",
		"Зимняя Луна",
		"Праздничные звезды Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Porsche Mission R",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 19 names
	{
		"Игла преступник",
		"Очки люкс",
		"Очки звездочки",
		"Советская шапка",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Прямые очки 'Огонь'",
		"Бархатные тяги спортивные",
		"Барыга преступник",
		"Опасный мужчина",
		"FORD Mustang GT",
		"Мент из клипа",
		"NIVA 4x4 Storm",
		"Косплей Майора",
		"Кейс черный",
		"Олег Рубцов",
		"Грабитель в маске",
		"Маска Чумного доктора",
		"DODGE DEMON SRT",
		"Маска Призрака",
		"Mercedes-Benz GT-R",
		"Toyota Land Cruiser 200",
		"Audi A8 Police",
		"Lamborghini Aventador SV 2017",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 20 names
	{
		"Хоуми с района",
		"Очки Доллар",
		"Кейс серый",
		"Советская шапка",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки Санрайз у воды",
		"Бархатные тяги спортивные",
		"Барыга преступник",
		"1200000 Р",
		"FORD Mustang GT",
		"Мент из клипа",
		"1500000 Р",
		"BMW M5 F10",
		"Артур Игоревич",
		"Кейс Рентген",
		"Рино",
		"Балаклава Криминал",
		"DODGE DEMON SRT",
		"3000000 Р",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"Rolls Royce Spectre",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 21 names
	{
		"Очки пиксели",
		"Лавровый венец",
		"Прямые очки 'Огонь'",
		"Шлем велосипедиста",
		"Бархатные тяги особые",
		"Хоуми с района",
		"700 BC",
		"BMW X5 E53",
		"900000 Р",
		"Барыга преступник",
		"Мент из клипа",
		"1200000 Р",
		"FORD Mustang GT",
		"1500000 Р",
		"Ночная Орхидея",
		"BMW M5 F10",
		"Жетон на шею",
		"Анна Организатор",
		"Рюкзак Уличный",
		"3000000 Р",
		"DODGE DEMON SRT",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"Lamborghini Centenario",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 22 names
	{
		"Очки День рождения",
		"Золотая корона",
		"Очки 'Пламя'",
		"Очки люкс",
		"Бархатные тяги особые",
		"Хоуми с района",
		"700 BC",
		"BMW X5 E53",
		"900000 Р",
		"Барыга преступник",
		"Мент из клипа",
		"1200000 Р",
		"FORD Mustang GT",
		"1500000 Р",
		"BMW M5 F10",
		"Доминик",
		"Очки Горение",
		"Городской Хищник",
		"Мопс на плечо",
		"3000000 Р",
		"Mitsubishi Galant 8",
		"DODGE DEMON SRT",
		"Audi Q7",
		"Range Rover SVR",
		"Toyota Custom BodyKit",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	{
    "Очки Доллар",
    "Белая панама с сигарой",
    "Прямые очки 'WARNING'",
    "Солдатка Красавица",
    "Бархатные тяги особые",
    "Анимированная Лапка",
    "700 BC",
    "BMW X5 E53",
    "900000 Р",
    "Барыга преступник",
    "Мент из клипа",
    "1200000 Р",
    "FORD Mustang GT",
    "1500000 Р",
    "BMW M5 F10",
    "Рюкзак Верный друг",
    "Маша Оперативница",
    "Маска Крысы",
    "Полицейский щит",
    "3000000 Р",
    "DODGE DEMON SRT",
    "Audi Q7",
    "Таинственный Незнакомец",
    "Range Rover SVR",
    "BMW X7 Police 6x6",

   "",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
},

	// Case 24 names
	{
		"MITSUBISHI LANCER EVO X",
		"BMW M5 E60",
		"SUBARU WRX STI",
		"Mercedes-Benz A45 AMG",
		"Zeekr 001",
		"Mercedes-Benz GT63s",
		"Cadillac Escalade IV",
		"BMW M4 G82",
		"Toyota Land Cruiser 200",
		"Lexus IS500F Performance",
		"BMW X6M F16",
		"Porsche 911 Carrera",
		"Volkswagen Touareg 2022",
		"Audi e-tron GT",
		"LAMBORGHINI AVENTADOR S",
		"TESLA MODEL X",
		"MERCEDES-BENZ G63 AMG",
		"MERCEDES-BENZ MAYBACH S650",
		"Mercedes-Benz MB S650",
		"Koenigsegg Sadair's Spear",
		"Mercedes-Benz G 63 AMG Brabus",
		"Aston Martin DB11",
		"Ferrari 488 GTB",
		"BMW M8 F93 Gran Coupe",
		"Aurus Senat",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 25 names
	{
		"Билет гонщика х1",
		"Билет гонщика  х3",
		"Билет гонщика  х5",
		"Билет гонщика  х10",
		"Билет гонщика  х20",
		"Билет гонщика х30",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 26 names
	{
		"Каракал (24 ч)",
		"Слейпнир (24 ч)",
		"Койот (24 ч)",
		"VAZ 2170 (24 ч)",
		"Mazda Sedan 3 (24 ч)",
		"Toyota Mark II (24 ч)",
		"Nissan Skyline R34 (24 ч)",
		"VAZ-2105 Street 1996 (24 ч)",
		"VAZ 2106 (Hoonicorn style) (24 ч)",
		"Audi Quattro 80 B2 (24 ч)",
		"Dodge Charger R/T 1969 (24 ч)",
		"Buick GSX 1970 (24 ч)",
		"BMW E28 Alpina (24 ч)",
		"ГАЗ-21 Coupe (24 ч)",
		"Volvo 240 GL (24 ч)",
		"Dodge Demon SRT Off-Road (24 ч)",
		"Mazda RX-7 (24 ч)",
		"Cadillac Miller-Meteor 1959 Ecto-1 (24 ч)",
		"Honda RD1 CR-V 5 (24 ч)",
		"Chevrolet Camaro Z28 (24 ч)",
		"Honda Civic VIII (24 ч)",
		"Mitsubishi Lancer EVO 7 (24 ч)",
		"Lincoln Town Car (24 ч)",
		"BMW Alpina B12 E32 (24 ч)",
		"Mercedes-Benz w211 (24 ч)",
		"Jeep Cherokee 1993 (24 ч)",
		"Lamborghini LM002 (24 ч)",
		"Jeep Wrangler Rubicon (24 ч)",
		"Mercedes-Benz X-Class (24 ч)",
		"Mercedes-Benz 500 SL R107 (24 ч)",
		"Dodge Charger Police (24 ч)",
		"Toyota Chaser Tourer v 100 (24 ч)",
		"Mercedes Benz g500 Police (24 ч)",
		"Mazda RX7 Veilside (24 ч)",
		"Subaru Levorg (24 ч)",
		"Subaru Impreza II WRX STi (24 ч)",
		"Land Rover Range Rover III (24 ч)",
		"Hummer H2 (24 ч)",
		"Tank 500 (24 ч)",
		"Toyota Altezza (24 ч)",
		"Zeekr 001 (24 ч)",
		"Hummer H3T Alpha (24 ч)",
		"Toyota Land Cruiser 200 (24 ч)",
		"Mercedes-Benz GLS 400 (24 ч)",
		"Volkswagen Touareg 2022 (24 ч)",
		"Hyundai Grandeur (24 ч)",
		"Audi RS Q e-tron Dacar (24 ч)",
		"Ford Explorer (24 ч)",
		"Ford Mondeo (24 ч)",
		"Mercedes-Benz G63 AMG (24 ч)",
		"Xiaomi su7 (24 ч)",
		"Ferrari 308 GTB (24 ч)",
		"Mercedes-Benz G63 AMG 6x6 (24 ч)",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 27 names
	{
		"Dodge Demon SRT (24 ч)",
		"Dodge Viper GTC (24 ч)",
		"Mercedes-AMG E63 S Wagon (24 ч)",
		"Mercedes-Benz SL65 AMG (24 ч)",
		"BMW M8 Competition Coupe (24 ч)",
		"Mercedes AMG GT (24 ч)",
		"Lamborghini Reventon (24 ч)",
		"Ferrari F50 (24 ч)",
		"Alfa Romeo Guilia (24 ч)",
		"Ford Mustang GT3 (24 ч)",
		"Nissan GT-R R35 (24 ч)",
		"Audi R8 V10 (24 ч)",
		"Chevrolet Corvette C8 (24 ч)",
		"Audi R8 LMS GT2 (24 ч)",
		"SCG 003 (24 ч)",
		"Lamborghini Aventador S (24 ч)",
		"Ferrari 812 Superfast (24 ч)",
		"Lincoln Phaeton HOT-ROD 1932 (24 ч)",
		"BMW M4 CSL (24 ч)",
		"Lamborghini Aventador SV 2017 (24 ч)",
		"Porsche 918 Spyder (24 ч)",
		"Koenigsegg CCXR (24 ч)",
		"Ferrari SF90 Stradale Spider (24 ч)",
		"Lamborghini Countach (2022) (24 ч)",
		"BMW M5 F90 (24 ч)",
		"McLaren P1 (24 ч)",
		"Toyota Custom BodyKit (24 ч)",
		"Bugatti Centodieci (24 ч)",
		"Lamborghini Centenario (24 ч)",
		"Lamborghini Veneno 2013 (24 ч)",
		"Porsche Mission R (24 ч)",
		"Bugatti Divo (24 ч)",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
},
// Case 28 names
{
"Неоновые очки",
"Темная панама с сигарой",
"Очки 'Санрайз у воды'",
"Хоуми с района",
"Бархатные тяги особые",
"Крылья ангела",
"700 BC",
"BMW X5 E53",
"900000 Р",
"Тропиксы Х5000",
"Мент из клипа",
"Тропиксы Х7500",
"FORD Mustang GT",
"Volvo V60",
"BMW M5 F10",
"Солнечная тусовщица",
"Infiniti Q60S",
"Пляжное полотенце",
"Пляжный заводила",
"Сумка Божья коровка",
"Тропиксы Х15000",
"Audi Q7",
"DODGE DEMON SRT",
"Range Rover SVR",
"BMW M5 G90",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
""
},
// Case 29 names
{
"Неоновые очки",
"Белая панама с сигарой",
"Очки 'Санрайз у воды'",
"Хоуми с района",
"Бархатные тяги особые",
"Надувной жилет",
"700 BC",
"BMW X5 E53",
"900000 Р",
"Тропиксы Х5000",
"Мент из клипа",
"Тропиксы Х7500",
"FORD Mustang GT",
"Volvo V60",
"BMW M5 F10",
"Infiniti Q60S",
"Азамат Весельчак",
"Летняя милаха",
"Сумка Аквариум",
"Маска Тики",
"Тропиксы Х15000",
"Audi Q7",
"DODGE DEMON SRT",
"Range Rover SVR",
"McLaren Senna",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
""
}

};

new CaseItemsCount[CASE_COUNT] = {20, 28, 37, 35, 22, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 6, 53, 32, 25, 25};
stock GetCaseItemsCount(caseIndex)
{
	if (caseIndex < 0 || caseIndex >= CASE_COUNT) return 0;
	return CaseItemsCount[caseIndex];
}

stock GetCaseItemNumeric(caseIndex, itemIndex, field)
{
	if (caseIndex < 0 || caseIndex >= CASE_COUNT) return -1;
	if (itemIndex < 0 || itemIndex >= MAX_CASE_ITEMS) return -1;
	if (field < 0 || field >= 6) return -1;
	return CaseAwardsNum[caseIndex][itemIndex][field];
}

stock GetCaseItemName(dest[], destlen, caseIndex, itemIndex)
{
    if (destlen <= 0) return 0;
    if (caseIndex < 0 || caseIndex >= CASE_COUNT) { dest[0]=0; return 0; }
    if (itemIndex < 0 || itemIndex >= MAX_CASE_ITEMS) { dest[0]=0; return 0; }
    format(dest, destlen, "%s", CaseAwardNames[caseIndex][itemIndex]);
    return strlen(dest);
}



const CASE_BONUS_COUNT = 30;
const MAX_CASE_BONUS_ITEMS = 5;
const CB_NAME_LEN = 64;

new CaseBonusNames[CASE_BONUS_COUNT][MAX_CASE_BONUS_ITEMS][CB_NAME_LEN] = {
	// Case 0 bonus names (ЕЖЕДНЕВНЫЙ КЕЙС)
	{
		"СТАНДАРТНЫЙ КЕЙС Х1",
		"ПЫЛЬ Х50",
		"КЕЙС БОМЖА Х1",
		"ЕЖЕДНЕВНЫЙ КЕЙС Х2",
		"ЕЖЕДНЕВНЫЙ КЕЙС Х1"
	},
	// Case 1 bonus names (КЕЙС БОМЖА)
	{
		"Mercedes-Benz S600 W140",
		"ПЫЛЬ Х100",
		"КЕЙС БОМЖА Х2",
		"ПЫЛЬ Х50",
		"КЕЙС БОМЖА Х1"
	},
	// Case 2 bonus names (СТАНДАРТНЫЙ КЕЙС)
	{
		"PORSCHE TAYCAN",
		"ПЫЛЬ Х250",
		"СТАНДАРТНЫЙ КЕЙС Х2",
		"ПЫЛЬ Х150",
		"СТАНДАРТНЫЙ КЕЙС Х1"
	},
	// Case 3 bonus names (АВТО-КЕЙС 2.0)
	{
		"Ferrari LaFerrari",
		"ПЫЛЬ Х500",
		"АВТО-КЕЙС 2.0 Х2",
		"ПЫЛЬ Х300",
		"АВТО-КЕЙС 2.0 Х1"
	},
	// Case 4 bonus names (ОСОБЫЙ КЕЙС)
	{
		"Bugatti W16 Mistral",
		"ПЫЛЬ Х1500",
		"ОСОБЫЙ КЕЙС Х2",
		"ПЫЛЬ Х1000",
		"ОСОБЫЙ КЕЙС Х1"
	},
	// Case 5 bonus names (КЕЙС: К ВЕРШИНАМ)
	{
		"KIA Carnival",
		"ПЫЛЬ Х350",
		"КЕЙС: К ВЕРШИНАМ Х2",
		"ПЫЛЬ Х200",
		"КЕЙС: К ВЕРШИНАМ Х1"
	},
	// Case 6 bonus names (КЕЙС: ОБЛАСТЬ ТЬМЫ)
	{
		"Smart Fortwo 2",
		"Багровые кристаллы Х10000",
		"КЕЙС: ОБЛАСТЬ ТЬМЫ Х2",
		"Багровые кристаллы Х5000",
		"КЕЙС: ОБЛАСТЬ ТЬМЫ Х1"
	},
	// Case 7 bonus names (КЕЙС: ДРАЙВ)
	{
		"Boss 302 Mustang",
		"Багровые кристаллы Х10000",
		"КЕЙС: ДРАЙВ Х2",
		"Багровые кристаллы Х5000",
		"КЕЙС: ДРАЙВ Х1"
	},
	// Case 8 bonus names (КЕЙС: ВЕСЕННИЙ)
	{
		"Puch Pinzgauer 710K",
		"2500000 Р",
		"КЕЙС: ВЕСЕННИЙ Х2",
		"1200000 Р",
		"КЕЙС: ВЕСЕННИЙ Х1"
	},
	// Case 9 bonus names (КЕЙС: БЛИЦ)
	{
		"ЗИЛ 4104",
		"ПЫЛЬ Х400",
		"КЕЙС: БЛИЦ Х2",
		"ПЫЛЬ Х300",
		"КЕЙС: БЛИЦ Х1"
	},
	// Case 10 bonus names (КЕЙС: ДЕЛО №5)
	{
		"Gaz 2402",
		"Багровые кристаллы X10000",
		"КЕЙС: ДЕЛО №5 Х2",
		"Багровые кристаллы X5000",
		"КЕЙС: ДЕЛО №5 Х1"
	},
	// Case 11 bonus names (КЕЙС: ПЛЯЖНЫЙ)
	{
		"Mercedes-Benz R230",
		"Багровые кристаллы X10000",
		"КЕЙС: ПЛЯЖНЫЙ Х2",
		"Багровые кристаллы X5000",
		"КЕЙС: ПЛЯЖНЫЙ Х1"
	},
	// Case 12 bonus names (КЕЙС: ПЕРВЫЙ МАНЕВР)
	{
		"Toyota Supra A70 mk3 ",
		"Багровые кристаллы X10000",
		"КЕЙС: ПЕРВЫЙ МАНЕВР Х2",
		"Багровые кристаллы X5000",
		"КЕЙС: ПЕРВЫЙ МАНЕВР Х1"
	},
	// Case 13 bonus names (КЕЙС: ВТОРОЙ МАНЕВР)
	{
		"Subaru Impreza II WRX STi",
		"Багровые кристаллы X10000",
		"КЕЙС: ВТОРОЙ МАНЕВР Х2",
		"Багровые кристаллы X5000",
		"КЕЙС: ВТОРОЙ МАНЕВР Х1"
	},
	// Case 14 bonus names (КЕЙС: ШКОЛЬНЫЙ)
	{
		"International S 1700 School bus",
		"1200000 Р",
		"КЕЙС: ШКОЛЬНЫЙ Х2",
		"2500000 Р",
		"КЕЙС: ШКОЛЬНЫЙ Х1"
	},
	// Case 15 bonus names (КЕЙС: ПРОЛОГ ТАЙНЫ)
	{
		"Ford Econoline Club Wagon",
		"Багровые кристаллы X10000",
		"КЕЙС: ПРОЛОГ ТАЙНЫ Х2",
		"Багровые кристаллы X5000",
		"КЕЙС: ПРОЛОГ ТАЙНЫ Х1"
	},
	// Case 16 bonus names (КЕЙС: ЭПИЛОГ ТАЙНЫ)
	{
		"Cadillac Escalade V",
		"Багровые кристаллы X10000",
		"КЕЙС: ЭПИЛОГ ТАЙНЫ Х2",
		"Багровые кристаллы X5000",
		"КЕЙС: ЭПИЛОГ ТАЙНЫ Х1"
	},
	// Case 17 bonus names (КЕЙС: ОСНОВАТЕЛЯ)
	{
		"Can-Am Outlander MAX 6X6 XT 1000",
		"Праздничные звезды X10000",
		"КЕЙС: ОСНОВАТЕЛЯ Х2",
		"Праздничные звезды X5000",
		"КЕЙС: ОСНОВАТЕЛЯ Х1"
	},
	// Case 18 bonus names (КЕЙС: ЗАЩИТНИКА)
	{
		"VAZ 2109 Turbo Edition",
		"Праздничные звезды X10000",
		"КЕЙС: ЗАЩИТНИКА Х2",
		"Праздничные звезды X5000",
		"КЕЙС: ЗАЩИТНИКА Х1"
	},
	// Case 19 bonus names (КЕЙС: ГРОМ)
	{
		"GMC Vandura",
		"2500000 Р",
		"КЕЙС: ГРОМ Х2",
		"ПЫЛЬ X300",
		"КЕЙС: ГРОМ Х1"
	},
	// Case 20 bonus names (КЕЙС: ГОЛОС УЛИЦ)
	{
		"Hummer H3T Alpha",
		"2500000 Р",
		"КЕЙС: ГОЛОС УЛИЦ Х2",
		"1200000 Р",
		"КЕЙС: ГОЛОС УЛИЦ Х1"
	},
	// Case 21 bonus names (КЕЙС: ТУРБО)
	{
		"Chevrolet Astro Van Lowrider",
		"2500000 Р",
		"КЕЙС: ТУРБО Х2",
		"1200000 Р",
		"КЕЙС: ТУРБО Х1"
	},
	// Case 22 bonus names (КЕЙС: НИТРО)
	{
		"Plymouth GTX 1971",
		"2500000 Р",
		"КЕЙС: НИТРО Х2",
		"1200000 Р",
		"КЕЙС: НИТРО Х1"
	},
	// Case 23 (ID 24) — ПУСТОЙ
    // Case 23 bonus names (КЕЙС: ДЕТЕКТИВ)
{
    "MARTT",
    "2500000 Р",
    "КЕЙС: ДЕТЕКТИВ Х2",
    "1200000 Р",
    "КЕЙС: ДЕТЕКТИВ Х1"
},

    // Case 24
    {
        "Maserati GranTurism",
        "Пыль х1000",
        "АВТО-КЕЙС 3.0 X2",
        "Пыль х500",
        "АВТО-КЕЙС 3.0 X1"
    },

    // Case 25
    {
        "Билет гонщика  х30",
        "Билет гонщика  х30",
        "Билет гонщика  х20",
        "Билет гонщика  х20",
        "Билет гонщика  х10"
    },

    // Case 26
    {
        "АВТО-КЕЙС B-C CLASS 24Ч Х5",
        "АВТО-КЕЙС B-C CLASS 24Ч Х5",
        "АВТО-КЕЙС B-C CLASS 24Ч Х5",
        "АВТО-КЕЙС B-C CLASS 24Ч Х5",
        "АВТО-КЕЙС B-C CLASS 24Ч Х5"
    },

    // Case 27
    {
        "АВТО-КЕЙС A-S CLASS 24Ч Х5",
        "АВТО-КЕЙС A-S CLASS 24Ч Х5",
        "АВТО-КЕЙС A-S CLASS 24Ч Х5",
        "АВТО-КЕЙС A-S CLASS 24Ч Х5",
        "АВТО-КЕЙС A-S CLASS 24Ч Х5"
    },
// Case 28 bonus names (КЕЙС: ЖАРА)
{
"Volkswagen Dune Buggy 1965",
"Тропиксы Х10000",
"КЕЙС: ЖАРА Х2",
"Тропиксы Х5000",
"КЕЙС: ЖАРА Х1"
},
// Case 29 bonus names (КЕЙС: ПЕКЛО)
{
"Volkswagen Dune Buggy 1965",
"Тропиксы Х10000",
"КЕЙС: ПЕКЛО Х2",
"Тропиксы Х5000",
"КЕЙС: ПЕКЛО Х1"
}
};

new CaseBonusesNum[CASE_BONUS_COUNT][MAX_CASE_BONUS_ITEMS][7] = {
	// Case 0 bonuses (ЕЖЕДНЕВНЫЙ КЕЙС)
	{
		{1, 40, 4, 4, 3, 1, 0},
		{2, 30, 3, 21, 1, 50, 0},
		{3, 20, 2, 4, 2, 1, 0},
		{4, 10, 1, 4, 1, 2, 0},
		{5, 5, 1, 4, 1, 1, 0}
	},
	// Case 1 bonuses (КЕЙС БОМЖА)
	{
		{1, 40, 5, 5, 467, 0, 100},
		{2, 30, 3, 21, 1, 100, 0},
		{3, 20, 3, 4, 2, 2, 0},
		{4, 10, 3, 21, 1, 50, 0},
		{5, 5, 3, 4, 2, 1, 0}
	},
	// Case 2 bonuses (СТАНДАРТНЫЙ КЕЙС)
	{
		{1, 40, 5, 5, 2581, 0, 400},
		{2, 30, 4, 21, 1, 250, 0},
		{3, 20, 4, 4, 3, 2, 0},
		{4, 10, 3, 21, 1, 150, 0},
		{5, 5, 4, 4, 3, 1, 0}
	},
	// Case 3 bonuses (АВТО-КЕЙС 2.0)
	{
		{1, 40, 5, 5, 668, 0, 500},
		{2, 30, 4, 21, 1, 500, 0},
		{3, 20, 4, 4, 4, 2, 0},
		{4, 10, 4, 21, 1, 300, 0},
		{5, 5, 4, 4, 4, 1, 0}
	},
	// Case 4 bonuses (ОСОБЫЙ КЕЙС)
	{
		{1, 25, 5, 5, 665, 0, 500},
		{2, 20, 5, 21, 1, 1500, 0},
		{3, 15, 5, 4, 5, 2, 0},
		{4, 10, 5, 21, 1, 1000, 0},
		{5, 5, 5, 4, 5, 1, 0}
	},
	// Case 5 bonuses (КЕЙС: К ВЕРШИНАМ)
	{
		{1, 40, 5, 5, 658, 0, 100},
		{2, 30, 4, 21, 1, 350, 0},
		{3, 20, 4, 4, 6, 2, 0},
		{4, 10, 4, 21, 1, 200, 0},
		{5, 5, 4, 4, 6, 1, 0}
	},
	// Case 6 bonuses (КЕЙС: ОБЛАСТЬ ТЬМЫ)
	{
		{1, 40, 5, 5, 634, 0, 200},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 7, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 7, 1, 0}
	},
	// Case 7 bonuses (КЕЙС: ДРАЙВ)
	{
		{1, 40, 5, 5, 660, 0, 200},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 8, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 8, 1, 0}
	},
	// Case 8 bonuses (КЕЙС: ВЕСЕННИЙ)
	{
		{1, 40, 5, 5, 573, 0, 400},
		{2, 30, 3, 2, 1, 2500000, 0},
		{3, 20, 4, 4, 9, 2, 0},
		{4, 10, 3, 2, 1, 1200000, 0},
		{5, 5, 4, 4, 9, 1, 0}
	},
	// Case 9 bonuses (КЕЙС: БЛИЦ)
	{
		{1, 40, 5, 5, 614, 0, 330},
		{2, 30, 4, 21, 1, 400, 0},
		{3, 20, 4, 4, 10, 2, 0},
		{4, 10, 4, 21, 1, 300, 0},
		{5, 5, 4, 4, 10, 1, 0}
	},
	// Case 10 bonuses (КЕЙС: ДЕЛО №5)
	{
		{1, 40, 5, 5, 438, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 11, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 11, 1, 0}
	},
	// Case 11 bonuses (КЕЙС: ПЛЯЖНЫЙ)
	{
		{1, 40, 5, 5, 28663, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 12, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 12, 1, 0}
	},
	// Case 12 bonuses (КЕЙС: ПЕРВЫЙ МАНЕВР)
	{
		{1, 40, 5, 5, 28681, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 13, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 13, 1, 0}
	},
	// Case 13 bonuses (КЕЙС: ВТОРОЙ МАНЕВР)
	{
		{1, 40, 5, 5, 28683, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 14, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 14, 1, 0}
	},
	// Case 14 bonuses (КЕЙС: ШКОЛЬНЫЙ)
	{
		{1, 40, 5, 5, 28690, 0, 320},
		{2, 30, 3, 2, 1, 1200000, 0},
		{3, 20, 4, 4, 15, 2, 0},
		{4, 10, 3, 2, 1, 2500000, 0},
		{5, 5, 4, 4, 15, 1, 0}
	},
	// Case 15 bonuses (КЕЙС: ПРОЛОГ ТАЙНЫ)
	{
		{1, 40, 5, 5, 28707, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 16, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 16, 1, 0}
	},
	// Case 16 bonuses (КЕЙС: ЭПИЛОГ ТАЙНЫ)
	{
		{1, 40, 5, 5, 28709, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 17, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 17, 1, 0}
	},
	// Case 17 bonuses (КЕЙС: ОСНОВАТЕЛЯ)
	{
		{1, 40, 5, 5, 28718, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 18, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 18, 1, 0}
	},
	// Case 18 bonuses (КЕЙС: ЗАЩИТНИКА)
	{
		{1, 40, 5, 5, 28721, 0, 320},
		{2, 30, 4, 23, 1, 10000, 0},
		{3, 20, 4, 4, 19, 2, 0},
		{4, 10, 4, 23, 1, 5000, 0},
		{5, 5, 4, 4, 19, 1, 0}
	},
	// Case 19 bonuses (КЕЙС: ГРОМ)
	{
		{1, 40, 5, 5, 28725, 0, 320},
		{2, 30, 3, 2, 1, 2500000, 0},
		{3, 20, 4, 4, 20, 2, 0},
		{4, 10, 4, 21, 0, 300, 0},
		{5, 5, 4, 4, 20, 1, 0}
	},
	// Case 20 bonuses (КЕЙС: ГОЛОС УЛИЦ)
	{
		{1, 40, 5, 5, 28732, 0, 320},
		{2, 30, 3, 2, 1, 2500000, 0},
		{3, 20, 4, 4, 21, 2, 0},
		{4, 10, 3, 2, 1, 1200000, 0},
		{5, 5, 4, 4, 21, 1, 0}
	},
	// Case 21 bonuses (КЕЙС: ТУРБО)
	{
		{1, 40, 5, 5, 28739, 0, 320},
		{2, 30, 3, 2, 1, 2500000, 0},
		{3, 20, 4, 4, 22, 2, 0},
		{4, 10, 3, 2, 1, 1200000, 0},
		{5, 5, 4, 4, 22, 1, 0}
	},
	// Case 22 bonuses (КЕЙС: НИТРО)
	{
		{1, 40, 5, 5, 28742, 0, 320},
		{2, 30, 3, 2, 1, 2500000, 0},
		{3, 20, 4, 4, 23, 2, 0},
		{4, 10, 3, 2, 1, 1200000, 0},
		{5, 5, 4, 4, 23, 1, 0}
	},
	// Case 23 bonuses (КЕЙС: ДЕТЕКТИВ)
{
    {1, 40, 5, 5, 28750, 0, 320},
    {2, 30, 3, 2, 1, 2500000, 0},
    {3, 20, 4, 4, 24, 2, 0},
    {4, 10, 3, 2, 1, 1200000, 0},
    {5, 5, 4, 4, 24, 1, 0}
},

    // Case 24
    {
        {1, 40, 5, 5, 28752, 0, 500},
        {2, 30, 5, 21, 1, 1000, 0},
        {3, 20, 5, 4, 20, 2, 200},
        {4, 10, 5, 21, 1, 500, 0},
        {5, 5, 5, 4, 20, 1, 200}
    },

    // Case 25
    {
        {1, 40, 4, 34, 1, 30, 0},
        {2, 30, 4, 34, 1, 30, 0},
        {3, 20, 4, 34, 1, 20, 0},
        {4, 10, 4, 34, 1, 20, 0},
        {5, 5, 4, 34, 1, 10, 0}
    },

    // Case 26
    {
        {1, 40, 5, 4, 27, 5, 0},
        {2, 30, 5, 4, 27, 5, 0},
        {3, 20, 5, 4, 27, 5, 0},
        {4, 10, 5, 4, 27, 5, 0},
        {5, 5, 5, 4, 27, 5, 0}
    },

    // Case 27
    {
        {1, 40, 5, 4, 28, 5, 0},
        {2, 30, 5, 4, 28, 5, 0},
        {3, 20, 5, 4, 28, 5, 0},
        {4, 10, 5, 4, 28, 5, 0},
        {5, 5, 5, 4, 28, 5, 0}
    },
// Case 28 bonuses (КЕЙС: ЖАРА)
{
{1, 40, 5, 5, 28763, 0, 320},
{2, 30, 3, 23, 1, 10000, 0},
{3, 20, 4, 4, 29, 2, 0},
{4, 10, 3, 23, 1, 5000, 0},
{5, 5, 4, 4, 29, 1, 0}
},
// Case 29 bonuses (КЕЙС: ПЕКЛО)
{
{1, 40, 5, 5, 28763, 0, 320},
{2, 30, 3, 23, 1, 10000, 0},
{3, 20, 4, 4, 30, 2, 0},
{4, 10, 3, 23, 1, 5000, 0},
{5, 5, 4, 4, 30, 1, 0}
}
};
	
new CaseBonusesCount[CASE_BONUS_COUNT] = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5};

stock GetCaseBonusesCount(caseIndex)
{
	if (caseIndex < 0 || caseIndex >= CASE_BONUS_COUNT) return 0;
	return CaseBonusesCount[caseIndex];
}

stock GetCaseBonusNumeric(caseIndex, itemIndex, field)
{
	if (caseIndex < 0 || caseIndex >= CASE_BONUS_COUNT) return -1;
	if (itemIndex < 0 || itemIndex >= MAX_CASE_BONUS_ITEMS) return -1;
	if (field < 0 || field >= 7) return -1;
	return CaseBonusesNum[caseIndex][itemIndex][field];
}

stock GetCaseBonusName(dest[], destlen, caseIndex, itemIndex)
{
	if (destlen <= 0) return 0;
	if (caseIndex < 0 || caseIndex >= CASE_BONUS_COUNT) { dest[0]=0; return 0; }
	if (itemIndex < 0 || itemIndex >= MAX_CASE_BONUS_ITEMS) { dest[0]=0; return 0; }
	format(dest, destlen, "%s", CaseBonusNames[caseIndex][itemIndex]);
	return strlen(dest);
}

stock explode(dest[][], const source[], delimiter = ',', size = sizeof(dest))
{
    new idx = 0, len = strlen(source), start = 0;
    for (new i = 0; i <= len && idx < size; i++)
    {
        if (source[i] == delimiter || source[i] == '\0')
        {
            strmid(dest[idx], source, start, i, 32);
            idx++;
            start = i + 1;
        }
    }
    return idx;
}

stock split(const source[], dest[], part, delimiter = '|')
{
    new len = strlen(source), start = 0, current = 0;
    for (new i = 0; i <= len; i++)
    {
        if (source[i] == delimiter || source[i] == '\0')
        {
            if (current == part)
            {
                strmid(dest, source, start, i, 256);
                return 1;
            }
            current++;
            start = i + 1;
        }
    }
    dest[0] = '\0';
    return 0;
}




stock GetCaseBonusForIndex(const str[], index, output[], output_size)
{
    output[0] = '\0';
    new tmp[256];
    new idx = 0; // 0-based
    new pos = 0;
    new len = strlen(str);

    for (new i = 0; i <= len; i++)
    {
        if (i == len || str[i] == '|')
        {
            tmp[pos] = '\0';
            if (idx == index)
            {
                format(output, output_size, "%s", tmp);
                return 1;
            }
            pos = 0;
            idx++;
        }
					else if (pos < sizeof(tmp)-1)
        {
            tmp[pos++] = str[i];
        }
    }
    return 0;
}

stock GiveCaseSkills(playerid, const jsonStr[], case_id)
{
    printf("[DEBUG] GiveCaseSkills: playerid=%d, case_id=%d", playerid, case_id);
    printf("[DEBUG] raw jsonStr = %s", jsonStr);

    // --- ищем массив bt2 ---
    new start = strfind(jsonStr, "\"bt2\":[");
    if (start == -1)
    {
        printf("[DEBUG] bt2 не найден в строке");
        return 0;
    }

    start += 7; // пропускаем "bt2":[
    new end = start;

    while (jsonStr[end] && jsonStr[end] != ']')
        end++;

    if (jsonStr[end] != ']')
    {
        printf("[DEBUG] не найдена закрывающая скобка ]");
        return 0;
    }

    // вырезаем подстроку bt2
    new bt2Str[512];
    strmid(bt2Str, jsonStr, start, end, sizeof(bt2Str));
    printf("[DEBUG] bt2Str = '%s'", bt2Str);

    // парсим числа
    new items[64];
    new item_count = 0;
    new num = 0, innum = 0;

    for (new i = 0; i < strlen(bt2Str); i++)
    {
        new ch = bt2Str[i];
        if (ch >= '0' && ch <= '9')
        {
            num = num * 10 + (ch - '0');
            innum = 1;
        }
					else if (innum)
        {
            if (item_count < sizeof(items))
                items[item_count++] = num;

            num = 0;
            innum = 0;
        }
    }

    if (innum && item_count < sizeof(items))
        items[item_count++] = num;

    printf("[DEBUG] найдено %d элементов в bt2", item_count);
    for (new i = 0; i < item_count; i++)
        printf("[DEBUG] item[%d] = %d", i, items[i]);

    // --- обработка скиллов ---
    for (new i = 0; i < item_count; i++)
    {
        new item = items[i];
        new addSkill = 0;

        if (case_id >= 1 && case_id <= CASE_COUNT)
        {
            if (item >= 1 && item <= MAX_CASE_ITEMS)
            {
                addSkill = CaseAwardsNum[case_id - 1][item - 1][CA_PRICESPRAYED];
            }
        }

        if (addSkill > 0)
        {
            AddPlayerData(playerid, P_SKILL_MICRO_UZI, +, addSkill);
			UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
            printf("[CASE] Player %d получил +%d Micro Uzi skill (item %d, case %d)", playerid, addSkill, item, case_id);
			new skill = GetPlayerData(playerid, P_SKILL_MICRO_UZI);
            new addCases = skill / 2000;
            
            // Считаем остаток
            new remainder = skill % 2000;
            if (addCases > 0)
            {
                AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, addCases);
                SetPlayerData(playerid, P_SKILL_MICRO_UZI, remainder);
				UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
				UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
                printf("[CASE] Player %d получил +%d кейсов, остаток %d", playerid, addCases, remainder);
            }

        }
    }

    return 1;
}



stock OpenCase(playerid, case_id)
{    
new case_sizes[] = {
    20, // case 1
    28, // case 2
    36, // case 3
    31, // case 4
    20, // case 5
    25, // case 6
    25, // case 7
    25, // case 8
    25, // case 9
    25, // case 10
    25, // case 11
    25, // case 12
    25, // case 13
    25, // case 14
    25, // case 15
    25, // case 16
    25, // case 17
    25, // case 18
    25, // case 19
    25, // case 20
    25, // case 21
    25, // case 22
    25, // case 23
    25,  // case 24 (пустой)
    25, // case 25 (АВТО-КЕЙС 3.0)
    6,  // case 26 (КЕЙС С БИЛЕТАМИ ГОНЩИКА)
    53, // case 27 (АВТО-КЕЙС B-C CLASS 24Ч)
    32, // case 28 (АВТО-КЕЙС A-S CLASS 24Ч)
    25, // case 29 (КЕЙС: ЖАРА)
    25  // case 30 (КЕЙС: ПЕКЛО)
};

new Float:chances[][] = {
   {0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05}, // case 1
   {0.029,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.009,0.009,0.005,0.009,0.005,0.009,0.005}, // case 2
   {0.046,0.047,0.047,0.047,0.047,0.024,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.024,0.024,0.024,0.012,0.012,0.012,0.012,0.012,0.012,0.012,0.006,0.006,0.006,0.005,0.01,0.01,0.01,0.01,0.003,0.003}, // case 3
   {0.059,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.008,0.008,0.008,0.008,0.008,0.004,0.004,0.002,0.002,0.001,0.001}, // case 4
   {0.089,0.089,0.089,0.089,0.006,0.089,0.089,0.089,0.089,0.089,0.089,0.016,0.016,0.016,0.016,0.016,0.006,0.006,0.006,0.006}, // case 5
   {0.067,0.067,0.067,0.067,0.033,0.067,0.067,0.067,0.067,0.067,0.067,0.033,0.033,0.027,0.027,0.027,0.027,0.027,0.013,0.027,0.014,0.014,0.014,0.008,0.006}, // case 6
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 7
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 8
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 9
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 10
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 11
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 12
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 13
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 14
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 15
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 16
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 17
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 18
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 19
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 20
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 21
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 22
   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 23

   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 24 (пустой)

  {0.010,0.010,0.010,0.010,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.02,0.02,0.02,0.02,0.02,0.08,0.05,0.05,0.05,0.05,0.05},  // case 25
{0.40,0.24,0.16,0.10,0.07,0.03}, // case 26
{0.05,0.05,0.05,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.015,0.015,0.015,0.015,0.015,0.015,0.01,0.01,0.01,0.01,0.01,0.01,0.008,0.008,0.008,0.008,0.004,0.004,0.003,0.002}, // case 27
{0.11,0.09,0.08,0.07,0.065,0.06,0.055,0.05,0.045,0.04,0.035,0.025,0.023,0.021,0.019,0.017,0.015,0.013,0.012,0.011,0.01,0.009,0.008,0.007,0.006,0.005,0.004,0.003,0.0025,0.002,0.0015,0.001}, // case 28
{0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 29
{0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005} // case 30
};


    new Float:rand = frandom(1.0);
    new prize_id = -1;
    new Float:cumulative = 0.0;

    for (new i = 0; i < case_sizes[case_id-1]; i++)
    {
        cumulative += chances[case_id-1][i];
        if (rand <= cumulative)
        {
            prize_id = i + 1;
            break;
        }
    }

    if (prize_id == -1) prize_id = 1; // подстраховка
	new Node:response = JSON_Object(); 
	JSON_SetInt(response, "t", 2); 
	JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid)); 
	JSON_SetInt(response, "s", 1); 
	new Node:prArray = JSON_Array(JSON_Int(prize_id)); 
	JSON_SetArray(response, "pr", prArray); 
	OnPacketIncoming(playerid, 73, response); JSON_Cleanup(response);
    JSON_Cleanup(response);
    printf("[Case] Player %d opened case %d -> reward %d (rand: %.3f)", playerid, case_id, prize_id, rand);
    return 1;
}
	
//

CMD:reward(playerid)
{
	g_player_inventory_count[playerid] = 0;
    g_player_inv_offset[playerid] = 0;
    g_player_filter[playerid] = 0; // 0 = Все
    SendInventoryPage(playerid, 0, 0);
    return 1;
}
stock rewardsss(playerid)
{
	g_player_inventory_count[playerid] = 0;
    g_player_inv_offset[playerid] = 0;
    g_player_filter[playerid] = 0; // 0 = Все
    SendInventoryPage(playerid, 0, 0);
    return 1;
}
stock AddPlayerCaseReward(playerid, caseid, itemid, bool:isBonus = false)
{
    if (itemid <= 0) return 0;
    if (g_PlayerRewardsCount[playerid] >= MAX_CASE_REWARDS) return 0;

    new resolvedCaseid, resolvedBonus;
    if(!CaseReward_ResolveEntry(caseid, itemid, isBonus, resolvedCaseid, resolvedBonus))
    {
        printf("[CASE REWARDS][ERROR] Player %d: invalid add reward Case:%d Item:%d Bonus:%d",
            playerid, caseid, itemid, isBonus);
        return 0;
    }

    caseid = resolvedCaseid;
    isBonus = (resolvedBonus != 0);

    new idx = g_PlayerRewardsCount[playerid];
    g_PlayerRewards[playerid][idx][rCase]  = caseid;
    g_PlayerRewards[playerid][idx][rItem]  = itemid;
    g_PlayerRewards[playerid][idx][rBonus] = isBonus ? 1 : 0;
    g_PlayerRewardsCount[playerid]++;

    SavePlayerCaseRewardDB(playerid, caseid, itemid, isBonus);

    printf("[CASE REWARDS] Player %d: added reward %d to case %d bonus=%d (total=%d)",
        playerid, itemid, caseid, isBonus, g_PlayerRewardsCount[playerid]);

    return 1;
}
forward FixPlayerZ(playerid);
public FixPlayerZ(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    // ?? вот это ключ
    SetPlayerPosFindZ(playerid, pos[playerid][0], pos[playerid][1], pos[playerid][2]);

    ShowNotification(playerid, 3, "Вы переместились на точку!", 2, "", "");
    return 1;
}
stock SavePlayerCaseRewardDB(playerid, caseid, itemid, bool:isBonus = false)
{
    new rewardStr[32];
    if(isBonus)
        format(rewardStr, sizeof(rewardStr), "%d:%d:1", caseid, itemid);
    else
        format(rewardStr, sizeof(rewardStr), "%d:%d", caseid, itemid);

    new accountid = GetPlayerAccountID(playerid);
    new query[384];

    mysql_format(mysql, query, sizeof(query),
        "UPDATE `accounts` SET `case_rewards`=IF(IFNULL(`case_rewards`,'')='', '%e', CONCAT(`case_rewards`, ',', '%e')) WHERE `id`=%d LIMIT 1",
        rewardStr, rewardStr, accountid);

    mysql_query(mysql, query, false);

    printf("[CASE REWARDS] Player %d: saved reward %s", playerid, rewardStr);
}

stock SavePlayerCaseRewards(playerid)
{
    new str[1024];
    str[0] = EOS;

    for (new i = 0; i < g_PlayerRewardsCount[playerid]; i++)
    {
        new tmp[32];
        if(g_PlayerRewards[playerid][i][rBonus])
            format(tmp, sizeof(tmp), "%d:%d:1",
                g_PlayerRewards[playerid][i][rCase],
                g_PlayerRewards[playerid][i][rItem]);
        else
            format(tmp, sizeof(tmp), "%d:%d",
                g_PlayerRewards[playerid][i][rCase],
                g_PlayerRewards[playerid][i][rItem]);

        if (strlen(str))
            strcat(str, ",", sizeof(str));

        strcat(str, tmp, sizeof(str));
    }

    printf("[CASE REWARDS] Player %d: saved rewards length %d", 
        playerid, strlen(str));
    printf("[CASE REWARDS] Player %d: %s", playerid, str);

    UpdatePlayerDatabaseString(playerid, "case_rewards", str);
}

#define MAX_ITEMS_PER_PLAYER 1000
stock bool:CaseRewardToken_IsNumber(const token[])
{
    if(token[0] == EOS) return false;

    for(new i = 0; token[i] != EOS; i++)
    {
        if(token[i] < '0' || token[i] > '9')
            return false;
    }

    return true;
}

stock bool:CaseReward_IsValidEntry(caseid, itemid, bool:isBonus = false)
{
    if(itemid <= 0) return false;

    if(caseid == 99)
    {
        new type, internal, count, rarity, price, name[CA_NAME_LEN];
        return bool:BlackPass_GetRewardInventoryData(itemid, name, sizeof(name), type, internal, count, rarity, price);
    }

    if(caseid < 1 || caseid > MAX_CASES) return false;

    new caseIndex = caseid - 1;
    if(isBonus)
    {
        for(new i = 0; i < GetCaseBonusesCount(caseIndex); i++)
        {
            if(GetCaseBonusNumeric(caseIndex, i, CB_ID) == itemid)
                return true;
        }
    }
    else
    {
        for(new i = 0; i < GetCaseItemsCount(caseIndex); i++)
        {
            if(GetCaseItemNumeric(caseIndex, i, CA_ID) == itemid)
                return true;
        }
    }

    return false;
}

stock bool:CaseReward_ResolveEntry(caseid, itemid, bool:isBonus, &resolvedCaseid, &resolvedBonus)
{
    resolvedCaseid = caseid;
    resolvedBonus = isBonus ? 1 : 0;

    if(CaseReward_IsValidEntry(caseid, itemid, isBonus))
        return true;

    if(!isBonus && CaseReward_IsValidEntry(caseid, itemid, true))
    {
        resolvedBonus = 1;
        return true;
    }

    new type, internal, count, rarity, price;
    new name[CA_NAME_LEN];
    if(BlackPass_GetRewardInventoryData(itemid, name, sizeof(name), type, internal, count, rarity, price))
    {
        resolvedCaseid = 99;
        resolvedBonus = 0;
        return true;
    }

    return false;
}