#if defined _PRIME_CASES_REWARD_SYSTEM
    #endinput
#endif
#define _PRIME_CASES_REWARD_SYSTEM

// Fresh cases/rewards system from CASES file. Old BP reward include is disabled in laird.pwn.

enum Player_Cases
{
    pCountTodayCases,
    pCountBomjCases,
    pCountStandartCases,
    pCountCarCases,
    pCountOsobiyCases
};
new g_player_cases[MAX_PLAYERS][Player_Cases];

enum ENUM_CASE_AWARDS {
    aType,
    aInternalID,
    aCount,
    aName[64],
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

stock Cases_ResetPlayerRuntime(playerid)
{
    g_player_cases[playerid][pCountTodayCases] = 0;
    g_player_cases[playerid][pCountBomjCases] = 0;
    g_player_cases[playerid][pCountStandartCases] = 0;
    g_player_cases[playerid][pCountCarCases] = 0;
    g_player_cases[playerid][pCountOsobiyCases] = 0;
    return 1;
}

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

stock NormalizeRewardCaseType(case_type)
{
    // BP reward data may store event/detective case as 24, but the active /cases counter uses dop-case slot 6.
    if(case_type == 24) return 6;
    return case_type;
}

stock GetPlayerCaseCountByType(playerid, case_type)
{
    switch(case_type)
    {
        case 1: return GetPlayerData(playerid, P_COUNT_TODAY_CASE);
        case 2: return GetPlayerData(playerid, P_COUNT_BOMJ_CASE);
        case 3: return GetPlayerData(playerid, P_COUNT_STANDART_CASE);
        case 4: return GetPlayerData(playerid, P_COUNT_CAR_CASE);
        case 5: return GetPlayerData(playerid, P_COUNT_OSOBIY_CASE);
        case 6, 24: return GetPlayerData(playerid, P_COUNT_DOP_CASE1);
    }
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(value < 0) value = 0;

    switch(case_type)
    {
        case 1:
        {
            SetPlayerData(playerid, P_COUNT_TODAY_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "counttodaycases", value);
        }
        case 2:
        {
            SetPlayerData(playerid, P_COUNT_BOMJ_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countbomjcases", value);
        }
        case 3:
        {
            SetPlayerData(playerid, P_COUNT_STANDART_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countstancases", value);
        }
        case 4:
        {
            SetPlayerData(playerid, P_COUNT_CAR_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countcarcases", value);
        }
        case 5:
        {
            SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countosobcases", value);
        }
        case 6, 24:
        {
            SetPlayerData(playerid, P_COUNT_DOP_CASE1, value);
            UpdatePlayerDatabaseInt(playerid, "countdopcases1", value);
        }
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
    new case_ids[] = {1, 2, 3, 4, 5, 6};

    for(new idx = 0; idx < sizeof(case_ids); idx++)
    {
        new case_id = case_ids[idx];
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", case_id);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, case_id));

        new Node:inner_array = JSON_Array(cc_obj);
        new Node:wrapper_array = JSON_Array(inner_array);
        cc_array = JSON_Append(cc_array, wrapper_array);
    }
    return cc_array;
}


stock BlackPass_ResolveRewardItemId(case_id, award_id)
{
    // Current BP rewards are stored as case_id 99 + full virtual item id (1001/2001/3001...).
    if(case_id == BLACKPASS_REWARD_CASE_ID) return award_id;

    // Compatibility with earlier BP queue attempts: case_id 90/91 + level number.
    if(case_id == 90) return BLACKPASS_STANDARD_REWARD_BASE + award_id;
    if(case_id == 91) return BLACKPASS_PREMIUM_REWARD_BASE + award_id;

    return award_id;
}

stock bool:BlackPass_IsRewardCaseId(case_id)
{
    if(case_id == BLACKPASS_REWARD_CASE_ID) return true;
    if(case_id == 90 || case_id == 91) return true;
    return false;
}

stock GetCaseAwardsCount(case_id)
{
    switch(case_id)
    {
        case 1: return sizeof(CaseDailyAwards);
        case 2: return sizeof(CaseBomjAwards);
        case 3: return sizeof(CaseStandartAwards);
        case 4: return sizeof(CaseAutoAwards);
        case 5: return sizeof(CaseSpecialAwards);
        case 6, 8, 24: return sizeof(CaseDriveAwards);
        case 90, 91: return BLACKPASS_MAX_LEVELS;
        case 99: return 3004;
    }
    return 0;
}

stock bool:GetCaseAwardData(case_id, award_index, &award_type, &internal_id, &award_count, award_name[], name_size, &spray_price)
{
    if(award_index < 0) return false;

    switch(case_id)
    {
        case 90, 91, 99:
        {
            new rarity;
            new bp_itemid = BlackPass_ResolveRewardItemId(case_id, award_index);
            if(!BlackPass_GetRewardInventoryData(bp_itemid, award_name, name_size, award_type, internal_id, award_count, rarity, spray_price)) return false;
            return true;
        }
        case 1:
        {
            if(award_index >= sizeof(CaseDailyAwards)) return false;
            award_type = CaseDailyAwards[award_index][aType];
            internal_id = CaseDailyAwards[award_index][aInternalID];
            award_count = CaseDailyAwards[award_index][aCount];
            spray_price = CaseDailyAwards[award_index][aSprayPrice];
            format(award_name, name_size, "%s", CaseDailyAwards[award_index][aName]);
            return true;
        }
        case 2:
        {
            if(award_index >= sizeof(CaseBomjAwards)) return false;
            award_type = CaseBomjAwards[award_index][aType];
            internal_id = CaseBomjAwards[award_index][aInternalID];
            award_count = CaseBomjAwards[award_index][aCount];
            spray_price = CaseBomjAwards[award_index][aSprayPrice];
            format(award_name, name_size, "%s", CaseBomjAwards[award_index][aName]);
            return true;
        }
        case 3:
        {
            if(award_index >= sizeof(CaseStandartAwards)) return false;
            award_type = CaseStandartAwards[award_index][aType];
            internal_id = CaseStandartAwards[award_index][aInternalID];
            award_count = CaseStandartAwards[award_index][aCount];
            spray_price = CaseStandartAwards[award_index][aSprayPrice];
            format(award_name, name_size, "%s", CaseStandartAwards[award_index][aName]);
            return true;
        }
        case 4:
        {
            if(award_index >= sizeof(CaseAutoAwards)) return false;
            award_type = CaseAutoAwards[award_index][aType];
            internal_id = CaseAutoAwards[award_index][aInternalID];
            award_count = CaseAutoAwards[award_index][aCount];
            spray_price = CaseAutoAwards[award_index][aSprayPrice];
            format(award_name, name_size, "%s", CaseAutoAwards[award_index][aName]);
            return true;
        }
        case 5:
        {
            if(award_index >= sizeof(CaseSpecialAwards)) return false;
            award_type = CaseSpecialAwards[award_index][aType];
            internal_id = CaseSpecialAwards[award_index][aInternalID];
            award_count = CaseSpecialAwards[award_index][aCount];
            spray_price = CaseSpecialAwards[award_index][aSprayPrice];
            format(award_name, name_size, "%s", CaseSpecialAwards[award_index][aName]);
            return true;
        }
        case 6, 8, 24:
        {
            if(award_index >= sizeof(CaseDriveAwards)) return false;
            award_type = CaseDriveAwards[award_index][aType];
            internal_id = CaseDriveAwards[award_index][aInternalID];
            award_count = CaseDriveAwards[award_index][aCount];
            spray_price = CaseDriveAwards[award_index][aSprayPrice];
            format(award_name, name_size, "%s", CaseDriveAwards[award_index][aName]);
            return true;
        }
    }
    return false;
}

stock GetCaseAwardSprayDustByIndex(case_id, award_index)
{
    new award_type, internal_id, award_count, spray_price, award_name[64];
    if(!GetCaseAwardData(case_id, award_index, award_type, internal_id, award_count, award_name, sizeof(award_name), spray_price)) return 0;
    return spray_price;
}


stock RewardGui_GetDisplayType(reward_type)
{
    switch(reward_type)
    {
        // Skins are rendered by the reward GUI as inventory preview with SKIN_EL = 134.
        case 134: return 11;
    }
    return reward_type;
}

stock RewardGui_GetImageElement(reward_type, internal_id, reward_count)
{
    switch(reward_type)
    {
        // Cases must stay prize type 4 and use `el` as the original case type.
        // This keeps daily/bomj/standard/auto/special/event case images correct in /reward.
        case 4: return internal_id;

        // Skin image rendering expects el = 134 and c = skin model id.
        case 134: return 134;
    }
    return internal_id;
}

stock RewardGui_GetSkinModelId(reward_type, reward_count)
{
    if(reward_type == 134) return reward_count;
    return reward_count;
}

stock bool:BlackPass_GiveCaseRewardToCases(playerid, case_type, amount, const reward_name[])
{
    new real_case_type = NormalizeRewardCaseType(case_type);

    if(real_case_type < 1 || real_case_type > 6 || amount <= 0)
    {
        ShowNotification(playerid, 2, "\xcd\xe5 \xf3\xe4\xe0\xeb\xee\xf1\xfc \xed\xe0\xf7\xe8\xf1\xeb\xe8\xf2\xfc \xea\xe5\xe9\xf1 BlackPass \xe2 /cases!", 4, "", "");
        return false;
    }

    AddPlayerCaseCountByType(playerid, real_case_type, amount);
    SavePlayerAccount(playerid);

    new text[144];
    format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 %d \xea\xe5\xe9\xf1(\xee\xe2) BlackPass: %s. \xce\xed \xe4\xee\xe1\xe0\xe2\xeb\xe5\xed \xe2 /cases.", amount, reward_name);
    ShowNotification(playerid, 3, text, 5, "", "");
    return true;
}

stock ShowCasesGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", 2);
    JSON_SetInt(json, "cs", 1);
    JSON_SetInt(json, "i", 0);
    JSON_SetArray(json, "cc", BuildPlayerCasesArray(playerid));
    SendPacketToClient(playerid, 73, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:cases(playerid, params[])
{
    ShowCasesGUI(playerid);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new to_player, type_case, count;
    if(sscanf(params, "udd", to_player, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-6] [count]");

    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > 6) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть 1-6.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(to_player, type_case, count);

    new str[144];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", count, type_case, GetPlayerNameEx(to_player));
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(to_player, COLOR_WHITE, str);
    return 1;
}

CMD:reward(playerid, params[])
{
    SetPVarInt(playerid, "reward_offset", 0);
    new query[160];
    mysql_format(mysql, query, sizeof(query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d ORDER BY `id` ASC LIMIT 0, 15", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);
    return 1;
}

forward OnPlayerRewardsLoad(playerid);
public OnPlayerRewardsLoad(playerid)
{
    new rows = cache_num_rows();

    if(rows == 0)
    {
        new current_offset = GetPVarInt(playerid, "reward_offset");
        if(current_offset > 0)
        {
            current_offset -= 15;
            if(current_offset < 0) current_offset = 0;
            SetPVarInt(playerid, "reward_offset", current_offset);

            new reload_query[160];
            mysql_format(mysql, reload_query, sizeof(reload_query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d ORDER BY `id` ASC LIMIT %d, 15", GetPlayerAccountID(playerid), current_offset);
            mysql_tquery(mysql, reload_query, "OnPlayerRewardsLoad", "i", playerid);
            return 1;
        }

        new Node:emptyObj = JSON_Object();
        JSON_SetInt(emptyObj, "o", 1);
        JSON_SetInt(emptyObj, "pc", GetPlayerDustValue(playerid));
        JSON_SetArray(emptyObj, "pr", JSON_Array());
        SendPacketToClient(playerid, 74, emptyObj);
        JSON_Cleanup(emptyObj);
        return 1;
    }

    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "pc", GetPlayerDustValue(playerid));

    new Node:prArray = JSON_Array();
    new display_rows = rows;
    if(display_rows > 15) display_rows = 15;

    for(new j = 0; j < display_rows; j++)
    {
        new a_id = cache_get_field_content_int(j, "award_id");
        new db_id = cache_get_field_content_int(j, "id");
        new case_id = cache_get_field_content_int(j, "case_id");

        new type, internal, spray_price, count, name[64];
        if(!GetCaseAwardData(case_id, a_id, type, internal, count, name, sizeof(name), spray_price)) continue;

        new Node:item = JSON_Object();
        // Reward GUI protocol:
        // td = prize type, el = image element/id, ct = quantity.
        // For skins, key c is the skin model id. For legacy compatibility we keep c filled as well.
        JSON_SetInt(item, "ct", count);
        JSON_SetInt(item, "c", RewardGui_GetSkinModelId(type, count));
        JSON_SetInt(item, "el", RewardGui_GetImageElement(type, internal, count));
        JSON_SetInt(item, "id", db_id);
        JSON_SetString(item, "n", name);
        JSON_SetInt(item, "st", 1);
        JSON_SetInt(item, "td", RewardGui_GetDisplayType(type));
        JSON_SetInt(item, "sp", spray_price);

        new Node:tempArray = JSON_Array(item);
        prArray = JSON_Append(prArray, tempArray);
        JSON_Cleanup(item);
    }

    JSON_SetArray(JSONObject, "pr", prArray);
    SendPacketToClient(playerid, 74, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

stock GiveCaseRewardCar(playerid, modelid)
{
    if(modelid <= 0) return 0;

    new free_car_id = GetFreeOwnableCarID();
    if(free_car_id == -1) return 0;

    new Float:pos_x = 2498.205810;
    new Float:pos_y = -742.256042;
    new Float:pos_z = 12.164166;
    new Float:angle = 356.240051;
    new color = 0;

    SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(free_car_id, OC_MODEL_ID, modelid);
    SetOwnableCarData(free_car_id, OC_COLOR_1, color);
    SetOwnableCarData(free_car_id, OC_COLOR_2, color);
    SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
    SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
    SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
    SetOwnableCarData(free_car_id, OC_ANGLE, angle);
    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());
    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
    strmid(g_ownable_car[free_car_id][OC_NUMBER], "", 0, 8, 8);
    ResetFreshOwnableTuningData(free_car_id);

    new database_query[640];
    mysql_format(mysql, database_query, sizeof(database_query), "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time,vinilcar,tuning_stroboscope,tuning_vinyl) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d','-1','-1','-1')", GetPlayerAccountID(playerid), modelid, color, color, pos_x, pos_y, pos_z, angle, gettime());
    mysql_tquery(mysql, database_query);
    return 1;
}

stock GiveCaseInventoryItem(playerid, itemid, count, const name[])
{
    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
    {
        ShowNotification(playerid, 2, "Нет свободного места в инвентаре!", 4, "", "");
        return 0;
    }
    Inventory_AddItem(playerid, itemid, freeSlot, count, name);
    SaveInventoryItem(playerid, freeSlot);
    return 1;
}

stock GiveCaseVip(playerid, vip_level, vip_hours)
{
    if(vip_level < 1) vip_level = 1;
    if(vip_hours <= 0) vip_hours = 24;

    new add_time = vip_hours * 3600;
    if(GetPlayerData(playerid, P_PREMIUM_DATE) > gettime()) AddPlayerData(playerid, P_PREMIUM_DATE, +, add_time);
    else SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + add_time);

    if(GetPlayerData(playerid, P_PREMIUM) < vip_level) SetPlayerData(playerid, P_PREMIUM, vip_level);
    UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
    return 1;
}

stock bool:BlackPass_GiveRewardFromRewardGui(playerid, itemid, reward_action)
{
    new type, internal, count, rarity, spray_price, name[64];
    if(!BlackPass_GetRewardInventoryData(itemid, name, sizeof(name), type, internal, count, rarity, spray_price)) return false;

    if(reward_action == 3)
    {
        if(spray_price > 0)
        {
            AddPlayerDustValue(playerid, spray_price);
            new dust_notify[128];
            format(dust_notify, sizeof(dust_notify), "\xc2\xfb \xf0\xe0\xf1\xef\xfb\xeb\xe8\xeb\xe8 \xed\xe0\xe3\xf0\xe0\xe4\xf3 BlackPass \xe8 \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 %d \xef\xfb\xeb\xe8.", spray_price);
            ShowNotification(playerid, 1, dust_notify, 5, "", "");
            return true;
        }

        ShowNotification(playerid, 2, "\xdd\xf2\xf3 \xed\xe0\xe3\xf0\xe0\xe4\xf3 BlackPass \xed\xe5\xeb\xfc\xe7\xff \xf0\xe0\xf1\xef\xfb\xeb\xe8\xf2\xfc!", 4, "", "");
        return false;
    }

    switch(type)
    {
        case 1:
        {
            AddPlayerData(playerid, P_EXP, +, count);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
            new text[96];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 %d EXP!", count);
            ShowNotification(playerid, 3, text, 5, "", "");
        }
        case 2:
        {
            GivePlayerMoneyEx(playerid, count, "BlackPass reward", true, true);
        }
        case 3:
        {
            GivePlayerDonateRub(playerid, count, "BlackPass reward", true, true);
            new text[96];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 %d BC!", count);
            ShowNotification(playerid, 3, text, 5, "", "");
        }
        case 4:
        {
            // BP case rewards are credited to the real /cases counters from cases2.pwn.
            if(!BlackPass_GiveCaseRewardToCases(playerid, internal, count, name)) return false;
        }
        case 5:
        {
            if(GiveCaseRewardCar(playerid, internal))
            {
                new text[128];
                format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 \xf2\xf0\xe0\xed\xf1\xef\xee\xf0\xf2: %s!", name);
                ShowNotification(playerid, 3, text, 5, "", "");
                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
            }
            else return false;
        }
        case 8:
        {
            SetPlayerX2(playerid, 1, 1);
            new text[128];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 \xe1\xee\xed\xf3\xf1: %s", name);
            ShowNotification(playerid, 3, text, 5, "", "");
        }
        case 9:
        {
            GiveCaseVip(playerid, internal, count);
            new text[96];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 VIP \xed\xe0 %d \xf7.", count);
            ShowNotification(playerid, 3, text, 5, "", "");
        }
        case 10:
        {
            BlackPass_GrantExperience(playerid, count);
            new text[96];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 %d BP EXP!", count);
            ShowNotification(playerid, 3, text, 5, "", "");
        }
        case 11:
        {
            if(internal == 134)
            {
                if(!GiveCaseInventoryItem(playerid, 134, count, name)) return false;
            }
            else if(!GiveCaseInventoryItem(playerid, internal, count, name)) return false;
        }
        case 21:
        {
            AddPlayerDustValue(playerid, count);
            new text[96];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 %d \xef\xfb\xeb\xe8.", count);
            ShowNotification(playerid, 3, text, 5, "", "");
        }
        case 34:
        {
            if(!GiveCaseInventoryItem(playerid, 34, count, name)) return false;
        }
        case 134:
        {
            if(!GiveCaseInventoryItem(playerid, 134, internal, name)) return false;
        }
        default:
        {
            new text[128];
            format(text, sizeof(text), "\xc2\xfb \xef\xee\xeb\xf3\xf7\xe8\xeb\xe8 \xed\xe0\xe3\xf0\xe0\xe4\xf3 BlackPass: %s", name);
            ShowNotification(playerid, 1, text, 5, "", "");
        }
    }
    return true;
}

forward OnRewardDebug(playerid, db_id, reward_action);
public OnRewardDebug(playerid, db_id, reward_action)
{
    new rows = cache_num_rows();
    if(rows <= 0) return 1;

    new a_id = cache_get_field_content_int(0, "award_id");
    new case_id = cache_get_field_content_int(0, "case_id");

    new type, count, internal, spray_price, name[64];
    if(!GetCaseAwardData(case_id, a_id, type, internal, count, name, sizeof(name), spray_price)) return 1;

    new bool:should_delete = true;

    if(BlackPass_IsRewardCaseId(case_id))
    {
        should_delete = BlackPass_GiveRewardFromRewardGui(playerid, BlackPass_ResolveRewardItemId(case_id, a_id), reward_action);
    }
    else if(reward_action == 3)
    {
        if(spray_price > 0)
        {
            AddPlayerDustValue(playerid, spray_price);
            new dust_notify[128];
            format(dust_notify, sizeof(dust_notify), "Вы распылили награду и получили %d пыли.", spray_price);
            ShowNotification(playerid, 1, dust_notify, 5, "", "");
        }
        else
        {
            ShowNotification(playerid, 2, "Эту награду нельзя распылить!", 4, "", "");
            should_delete = false;
        }
    }
    else
    {
        switch(type)
        {
            case 1:
            {
                AddPlayerData(playerid, P_EXP, +, count);
                UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
                new text[96];
                format(text, sizeof(text), "Вы получили %d EXP!", count);
                ShowNotification(playerid, 3, text, 5, "", "");
            }
            case 2:
            {
                GivePlayerMoneyEx(playerid, count);
            }
            case 4:
            {
                if(!BlackPass_GiveCaseRewardToCases(playerid, internal, count, name)) should_delete = false;
            }
            case 5:
            {
                if(GiveCaseRewardCar(playerid, internal))
                {
                    new text[128];
                    format(text, sizeof(text), "Вы получили транспорт: %s!", name);
                    ShowNotification(playerid, 3, text, 5, "", "");
                    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                }
                else
                {
                    ShowNotification(playerid, 2, "Не удалось выдать транспорт!", 4, "", "");
                    should_delete = false;
                }
            }
            case 9:
            {
                GiveCaseVip(playerid, internal, count);
                new text[96];
                format(text, sizeof(text), "Вы получили VIP на %d ч.", count);
                ShowNotification(playerid, 3, text, 5, "", "");
            }
            case 10:
            {
                GivePlayerDonateRub(playerid, count);
            }
            case 11:
            {
                if(GiveCaseInventoryItem(playerid, internal, count, name))
                {
                    new text[128];
                    format(text, sizeof(text), "Вы получили предмет: %s (%d шт.)", name, count);
                    ShowNotification(playerid, 1, text, 5, "", ">>");
                }
                else should_delete = false;
            }
            case 134:
            {
                if(GiveCaseInventoryItem(playerid, 134, internal, name))
                {
                    new text[128];
                    format(text, sizeof(text), "Вы получили скин: %s", name);
                    ShowNotification(playerid, 1, text, 5, "", "");
                }
                else should_delete = false;
            }
            default:
            {
                new text[128];
                format(text, sizeof(text), "Вы получили награду: %s", name);
                ShowNotification(playerid, 1, text, 5, "", "");
            }
        }
    }

    if(should_delete)
    {
        SavePlayerAccount(playerid);
        new d_query[128];
        mysql_format(mysql, d_query, sizeof(d_query), "DELETE FROM `rewards` WHERE `id` = %d", db_id);
        mysql_tquery(mysql, d_query);

        new Node:res = JSON_Object();
        JSON_SetInt(res, "t", 4);
        JSON_SetInt(res, "s", 1);
        JSON_SetInt(res, "id", db_id);
        JSON_SetInt(res, "pc", GetPlayerDustValue(playerid));
        SendPacketToClient(playerid, 74, res);
        JSON_Cleanup(res);
    }
    return 1;
}

CMD:givereward(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 9) return ShowNotification(playerid, 2, "У вас нет доступа к использованию данной команды", 3, "", "");

    new to_player, award, case_type;
    if(sscanf(params, "udd", to_player, award, case_type))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givereward [ID игрока] [айди награды] [Айди кейса]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return ShowNotification(playerid, 2, "Такого игрока нет", 4, " ", "");

    GiveRewardsFromGUI(to_player, award, case_type);

    new fmt_msg[144];
    format(fmt_msg, sizeof(fmt_msg), "{3399FF}%s выдал Вам %d награду кейса %d", GetPlayerNameEx(playerid), award, case_type);
    SendClientMessage(to_player, -1, fmt_msg);

    format(fmt_msg, sizeof(fmt_msg), "{3399FF}Вы выдали %s %d награду кейса %d", GetPlayerNameEx(to_player), award, case_type);
    SendClientMessage(playerid, -1, fmt_msg);
    return 1;
}

stock GiveRewardsFromGUI(playerid, reward, case_type)
{
    new query[160];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO rewards (uid, award_id, case_id) VALUES (%d, %d, %d)", GetPlayerAccountID(playerid), reward - 1, case_type);
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock ResetPlayerCase(playerid)
{
    SetPlayerCaseCountByType(playerid, 1, 0);
    SetPlayerCaseCountByType(playerid, 2, 0);
    SetPlayerCaseCountByType(playerid, 3, 0);
    SetPlayerCaseCountByType(playerid, 4, 0);
    SetPlayerCaseCountByType(playerid, 5, 0);
    SetPlayerCaseCountByType(playerid, 6, 0);
    return 1;
}
