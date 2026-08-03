enum ENUM_CASE_AWARDS {
    aId,           // <-- ДОБАВЛЯЕМ ID НАГРАДЫ
    aType,
    aInternalID,
    aCount,
    aName[128],
    aSprayPrice
};

// ==========================================================================
// КЕЙС: ЕЖЕДНЕВНЫЙ КЕЙС (id: 1)
// ==========================================================================
new CaseDailyAwards[20][ENUM_CASE_AWARDS] = {
    {1, 11, 23, 1, "Рем.комплект", 10},
    {2, 11, 22, 1, "Аптечка", 10},
    {3, 10, 1, 200, "200 BP EXP", 0},
    {4, 11, 21, 1, "Канистра с бензином", 10},
    {5, 2, 1, 2000, "2000 Р", 0},
    {6, 3, 1, 5, "5 BC", 0},
    {7, 2, 1, 3000, "3000 Р", 0},
    {8, 3, 1, 10, "10 BC", 0},
    {9, 9, 1, 2, "VIP SILVER 2Ч.", 10},
    {10, 10, 1, 300, "300 BP EXP", 0},
    {11, 1, 1, 4, "4 EXP", 0},
    {12, 5, 462, 0, "RACER SPORT", 20},
    {13, 10, 1, 500, "500 BP EXP", 0},
    {14, 2, 1, 20000, "20000 Р", 0},
    {15, 3, 1, 15, "15 BC", 0},
    {16, 9, 2, 2, "VIP GOLD 2Ч.", 10},
    {17, 10, 1, 500, "500 BP EXP", 0},
    {18, 2, 1, 30000, "30000 Р", 0},
    {19, 1, 1, 6, "6 EXP", 0},
    {20, 5, 549, 0, "ВАЗ 1111", 20}
};

// ==========================================================================
// КЕЙС: КЕЙС БОМЖА (id: 2)
// ==========================================================================
new CaseBomjAwards[27][ENUM_CASE_AWARDS] = {
    {1, 5, 468, 0, "Aprilla MXV 450", 20},
    {2, 5, 496, 0, "VOLKSWAGEN GOLF GTI 2", 20},
    {3, 2, 1, 75000, "75000 Р", 0},
    {4, 5, 28670, 0, "ВАЗ 21099", 20},
    {5, 1, 1, 8, "8 EXP", 0},
    {6, 5, 439, 0, "ВАЗ 2108", 20},
    {7, 2, 1, 90000, "90000 Р", 0},
    {8, 5, 492, 0, "ВАЗ 2109", 20},
    {9, 5, 547, 0, "ВАЗ 2110", 20},
    {10, 5, 458, 0, "ВАЗ 2114", 20},
    {11, 9, 1, 168, "VIP SILVER 7 ДН.", 20},
    {12, 5, 491, 0, "ВАЗ 2112", 20},
    {13, 5, 585, 0, "ВАЗ 2115", 20},
    {14, 1, 1, 12, "12 EXP", 0},
    {15, 2, 1, 120000, "120000 Р", 0},
    {16, 9, 2, 72, "VIP GOLD 3 ДН.", 20},
    {17, 5, 536, 0, "VOLVO 242DL", 20},
    {18, 5, 529, 0, "ВАЗ 2170", 20},
    {19, 9, 3, 72, "VIP PLATINUM 3 ДН.", 20},
    {20, 5, 542, 0, "NIVA URBAN", 20},
    {21, 5, 421, 0, "Mercedes-Benz W124", 20},
    {22, 5, 2618, 0, "BMW M3 E36", 30},
    {23, 5, 419, 0, "Mercedes-Benz E420 W210", 30},
    {24, 11, 705, 1, "РЮКЗАК СИФОНА", 30},
    {25, 5, 546, 0, "HYUNDAI SOLARIS 2021", 30},
    {26, 11, 706, 1, "ПОБИТЫЕ ОЧКИ", 30},
    {27, 11, 134, 6810, "КОРОЛЬ БОМЖЕЙ", 40}
};

// ==========================================================================
// КЕЙС: СТАНДАРТНЫЙ КЕЙС (id: 3)
// ==========================================================================
new CaseStandartAwards[37][ENUM_CASE_AWARDS] = {
    {1, 11, 363, 1, "КОРОНА КОРОЛЯ", 90},
    {2, 9, 2, 504, "VIP GOLD 21 ДН.", 90},
    {3, 2, 1, 600000, "600000 Р", 0},
    {4, 11, 360, 1, "КЕЙС ЧЕРНЫЙ", 90},
    {5, 5, 527, 0, "BMW M3 E46", 100},
    {6, 3, 1, 600, "600 BC", 0},
    {7, 9, 3, 360, "VIP PLATINUM 15 Д.", 100},
    {8, 5, 445, 0, "ACURA TSX", 100},
    {9, 11, 583, 1, "МОПС НА СПИНУ", 100},
    {10, 11, 134, 14386, "БАРХАТНЫЕ ТЯГИ СПОРТИВНЫЕ", 100},
    {11, 11, 508, 1, "КОРОНА ДЕМОНА", 100},
    {12, 11, 134, 11917, "ХОУМИ С РАЙОНА", 110},
    {13, 5, 589, 0, "VOLKSWAGEN GOLF GTI", 110},
    {14, 5, 2568, 0, "BMW X5 E53", 110},
    {15, 11, 134, 11961, "РЫБАЧКА", 140},
    {16, 5, 2385, 0, "NISSAN QASHQAI", 120},
    {17, 5, 28695, 0, "NISSAN TEANA J32", 120},
    {18, 5, 2627, 0, "NISSAN SILVIA S15", 120},
    {19, 5, 461, 0, "DUCATI SUPERSPORT S", 130},
    {20, 2, 1, 1000000, "1000000 Р", 0},
    {21, 9, 3, 720, "VIP PLATINUM 30 Д.", 130},
    {22, 11, 134, 236, "БАРЫГА ПРЕСТУПНИК", 130},
    {23, 5, 2567, 0, "BMW M5 E60", 130},
    {24, 11, 134, 11935, "МЕНТ ИЗ КЛИПА", 140},
    {25, 5, 560, 0, "SUBARU WRX STI", 140},
    {26, 11, 134, 19262, "ОПАСНЫЙ МУЖЧИНА", 140},
    {27, 5, 2584, 0, "KIA K5", 150},
    {28, 5, 2390, 0, "BMW X5M E70", 160},
    {29, 5, 543, 0, "CHEVROLET CAMARO ZL1", 200},
    {30, 5, 480, 0, "BMW Z4 M40i ", 200},
    {31, 11, 707, 1, "МАСКА СВИНА", 220},
    {32, 5, 402, 0, "MERCEDES-BENZ GT63S", 240},
    {33, 5, 2598, 0, "BMW M4 G82", 250},
    {34, 5, 400, 0, "BMW X6M F16", 260},
    {35, 5, 506, 0, "PORSCHE 911 CARRERA S", 270},
    {36, 5, 415, 0, "LAMBORGHINI AVENTADOR S", 400},
    {37, 5, 2543, 0, "TESLA MODEL X", 400}
};

// ==========================================================================
// КЕЙС: АВТО-КЕЙС 2.0 (id: 4)
// ==========================================================================
new CaseAutoAwards[37][ENUM_CASE_AWARDS] = {
    {1, 5, 436, 0, "MITSUBISHI LANCER EVO X", 130},
    {2, 5, 2567, 0, "BMW M5 E60", 130},
    {3, 5, 560, 0, "SUBARU WRX STI", 140},
    {4, 5, 550, 0, "TOYOTA CAMRY 3.5", 140},
    {5, 5, 28671, 113, "HAVAL F7X", 150},
    {6, 5, 603, 0, "FORD MUSTANG GT", 150},
    {7, 5, 2552, 0, "TOYOTA SUPRA A80", 150},
    {8, 5, 565, 0, "MERCEDES-BENZ A45 AMG", 150},
    {9, 5, 2609, 0, "MINI COUNTRYMAN", 160},
    {10, 5, 2604, 0, "VOLKSWAGEN PASSAT", 160},
    {11, 5, 551, 0, "ALFA ROMEO GUILIA", 160},
    {12, 5, 2390, 0, "BMW X5M E70", 160},
    {13, 5, 526, 0, "INFINITI Q60S", 160},
    {14, 5, 2620, 0, "LEXUS RCF", 170},
    {15, 5, 2594, 0, "SUBARU BRZ", 180},
    {16, 5, 2621, 0, "XPENG P7", 180},
    {17, 5, 2387, 0, "BMW 3-SERIES G20", 200},
    {18, 5, 480, 0, "BMW Z4 M40I", 200},
    {19, 5, 2394, 0, "DODGE CHARGER SRT", 200},
    {20, 5, 558, 0, "BMW M4 F84", 210},
    {21, 5, 28694, 134, "ZEERK 001", 450},
    {22, 5, 28697, 135, "LEXUS IS500F PERFOMANCE", 450},
    {23, 5, 402, 0, "MERCEDES-BENZ GT63S", 240},
    {24, 5, 505, 0, "CADILLAC ESCALADE IV", 240},
    {25, 5, 2598, 0, "BMW M4 G82", 250},
    {26, 5, 400, 0, "BMW X6M F16", 260},
    {27, 5, 2547, 0, "TOYOTA LAND CRUISER 200", 250},
    {28, 5, 506, 0, "PORSCHE 911 CARRERA", 270},
    {29, 5, 763, 0, "Volkswagen Touareg 2022", 280},
    {30, 5, 28693, 133, "AUDI E-TRON GT", 450},
    {31, 5, 415, 0, "LAMBORGHINI AVENTADOR S", 400},
    {32, 5, 2543, 0, "TESLA MODEL X", 400},
    {33, 5, 2573, 0, "MERCEDES-BENZ G63 AMG", 430},
    {34, 5, 2558, 0, "MERCEDES-BENZ MAYBACH S650", 450},
    {35, 5, 2597, 0, "AURUS SENAT", 450},
    {36, 5, 2558, 0, "MERCEDES-BENZ MB S650", 450},
    {37, 5, 28672, 0, "MERCEDES-BENZ G63 AMG BRABUS", 450}
};

// ==========================================================================
// КЕЙС: ОСОБЫЙ КЕЙС (id: 5)
// ==========================================================================
new CaseSpecialAwards[22][ENUM_CASE_AWARDS] = {
    {1, 5, 410, 0, "Mercedes-Benz C63s", 230},
    {2, 5, 604, 0, "Porsche Panamera S", 260},
    {3, 5, 2389, 0, "BMW M6 F12", 270},
    {4, 5, 2574, 0, "BMW X7 M50i", 290},
    {5, 5, 451, 0, "McLaren 600 LT", 340},
    {6, 5, 2626, 0, "Porsche Cayenne S", 350},
    {7, 5, 2551, 0, "Lamborghini Urus", 350},
    {8, 5, 2549, 0, "Lamborghini Huracan", 370},
    {9, 5, 2393, 0, "Chevrolet Corvette C8", 370},
    {10, 5, 579, 0, "Mercedes-Benz G65 AMG", 370},
    {11, 5, 2619, 0, "Ferrari 488 Pista", 460},
    {12, 5, 657, 23, "Pagani Zonda 2002", 490},
    {13, 5, 669, 0, "Tesla CyberTruck", 570},
    {14, 5, 2564, 0, "Rolls-Royce Cullinan", 570},
    {15, 5, 765, 0, "Mercedes-Benz G63 AMG 6x6", 600},
    {16, 5, 2591, 0, "BENTLEY Continental GT", 670},
    {17, 5, 2607, 0, "BMW M1", 750},
    {18, 5, 2601, 0, "BUGATTI CHIRON", 800},
    {19, 5, 667, 0, "Koenigsegg Regera", 850},
    {20, 5, 2570, 0, "Bugatti Divo", 900},
    {21, 5, 666, 0, "Bugatti Veyron", 900},
    {22, 5, 466, 1, "BMW M5 F90 (ППС)", 900}
};

// ==========================================================================
// КЕЙС: ДРАЙВ (id: 8) - добавляем ID
// ==========================================================================
new CaseDriveAwards[25][ENUM_CASE_AWARDS] = {
    {1, 11, 134, 14386, "Бархатные тяги спортивные", 100},
    {2, 11, 360, 1, "Кейс черный", 100},
    {3, 11, 946, 1, "Маска Fresh'а", 120},
    {4, 11, 511, 1, "Крылья ангела", 100},
    {5, 11, 945, 1, "Рюкзак Energy", 100},
    {6, 3, 1, 700, "700 BC", 0},
    {7, 10, 1, 7000, "7000 BP EXP", 0},
    {8, 11, 134, 11917, "Хоуми с района", 110},
    {9, 23, 1, 3000, "Багровые кристаллы Х3000", 0},
    {10, 5, 2568, 0, "BMW X5 E53", 110},
    {11, 11, 944, 1, "Сумка SpeedPack", 140},
    {12, 11, 134, 5885, "Искра", 140},
    {13, 11, 134, 5326, "Снеговик не растает", 130},
    {14, 5, 603, 0, "FORD MUSTANG GT", 140},
    {15, 23, 1, 7500, "Багровые кристаллы Х7500", 0},
    {16, 5, 442, 0, "Volvo V60", 170},
    {17, 23, 1, 5000, "Багровые кристаллы Х5000", 0},
    {18, 11, 134, 5884, "Петр Шторм", 160},
    {19, 5, 503, 0, "DODGE DEMON SRT", 230},
    {20, 23, 1, 15000, "Багровые кристаллы Х15000", 0},
    {21, 5, 2603, 0, "Mercedes-Benz E63 W212", 250},
    {22, 5, 502, 0, "Nissan GT-R R35", 260},
    {23, 5, 2599, 0, "BMW 7-Series 750Li", 340},
    {24, 5, 659, 48, "Renault R5 Turbo 3E", 180},
    {25, 5, 661, 49, "Ferrari 812 Superfast", 490}
};

// ========== ИСПРАВЛЕННАЯ ФУНКЦИЯ ПОИСКА НАГРАДЫ ПО ID ==========

// ---------- GUI КОНСТАНТЫ ----------
#if !defined GUICases
    #define GUICases 73
#endif

#define CASES_TYPE_SELECT       1
#define CASES_TYPE_OPEN         2
#define CASES_TYPE_TAKE_REWARDS 3
#define CASES_TYPE_GO_DONATE    4
#define CASES_TYPE_OPEN_SUPER   5
#define CASES_TYPE_OPEN_BP      6
#define CASES_TYPE_GET_BONUS    7
#define CASES_TYPE_FROM_BANNER  8

#define CASES_OPEN_ONE          1
#define CASES_OPEN_TEN          2

// ---------- ПЕРЕМЕННЫЕ ДЛЯ PENDING НАГРАД ----------
static pCasesPendingRewards[MAX_PLAYERS][10];
static pCasesPendingCount[MAX_PLAYERS];
static pCasesLastOpenedIdx[MAX_PLAYERS];

// ---------- GUI ПЕРЕМЕННЫЕ ----------
static pCasesSelected[MAX_PLAYERS];
static pCasesGUIOpen[MAX_PLAYERS];
static pCasesLastAction[MAX_PLAYERS];

// ---------- ВАШИ ФУНКЦИИ ----------
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

stock GetPlayerCaseCountByType(playerid, case_type)
{
    switch(case_type)
    {
        case 1: return GetPlayerData(playerid, P_COUNT_TODAY_CASE);
        case 2: return GetPlayerData(playerid, P_COUNT_BOMJ_CASE);
        case 3: return GetPlayerData(playerid, P_COUNT_STANDART_CASE);
        case 4: return GetPlayerData(playerid, P_COUNT_CAR_CASE);
        case 5: return GetPlayerData(playerid, P_COUNT_OSOBIY_CASE);
    }
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(value < 0) value = 0;

    switch(case_type)
    {
        case 1: return SetPlayerData(playerid, P_COUNT_TODAY_CASE, value);
        case 2: return SetPlayerData(playerid, P_COUNT_BOMJ_CASE, value);
        case 3: return SetPlayerData(playerid, P_COUNT_STANDART_CASE, value);
        case 4: return SetPlayerData(playerid, P_COUNT_CAR_CASE, value);
        case 5: return SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, value);
        default: return 0;
    }
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
}

// ========== ФУНКЦИИ ДЛЯ РАСПЫЛЕНИЯ (из dovard_cases_only) ==========

stock Cases_FindAwardById(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardPriceSprayed)
{
    // Поиск в CaseDailyAwards
    for(new i = 0; i < 20; i++) {
        if(CaseDailyAwards[i][aId] == rewardId) {
            rewardType = CaseDailyAwards[i][aType];
            rewardValue = CaseDailyAwards[i][aInternalID];
            rewardCount = CaseDailyAwards[i][aCount];
            rewardPriceSprayed = CaseDailyAwards[i][aSprayPrice];
            return 1;
        }
    }
    
    // Поиск в CaseBomjAwards
    for(new i = 0; i < 27; i++) {
        if(CaseBomjAwards[i][aId] == rewardId) {
            rewardType = CaseBomjAwards[i][aType];
            rewardValue = CaseBomjAwards[i][aInternalID];
            rewardCount = CaseBomjAwards[i][aCount];
            rewardPriceSprayed = CaseBomjAwards[i][aSprayPrice];
            return 1;
        }
    }
    
    // Поиск в CaseStandartAwards
    for(new i = 0; i < 37; i++) {
        if(CaseStandartAwards[i][aId] == rewardId) {
            rewardType = CaseStandartAwards[i][aType];
            rewardValue = CaseStandartAwards[i][aInternalID];
            rewardCount = CaseStandartAwards[i][aCount];
            rewardPriceSprayed = CaseStandartAwards[i][aSprayPrice];
            return 1;
        }
    }
    
    // Поиск в CaseAutoAwards
    for(new i = 0; i < 37; i++) {
        if(CaseAutoAwards[i][aId] == rewardId) {
            rewardType = CaseAutoAwards[i][aType];
            rewardValue = CaseAutoAwards[i][aInternalID];
            rewardCount = CaseAutoAwards[i][aCount];
            rewardPriceSprayed = CaseAutoAwards[i][aSprayPrice];
            return 1;
        }
    }
    
    // Поиск в CaseSpecialAwards
    for(new i = 0; i < 22; i++) {
        if(CaseSpecialAwards[i][aId] == rewardId) {
            rewardType = CaseSpecialAwards[i][aType];
            rewardValue = CaseSpecialAwards[i][aInternalID];
            rewardCount = CaseSpecialAwards[i][aCount];
            rewardPriceSprayed = CaseSpecialAwards[i][aSprayPrice];
            return 1;
        }
    }
    
    // Поиск в CaseDriveAwards
    for(new i = 0; i < 25; i++) {
        if(CaseDriveAwards[i][aId] == rewardId) {
            rewardType = CaseDriveAwards[i][aType];
            rewardValue = CaseDriveAwards[i][aInternalID];
            rewardCount = CaseDriveAwards[i][aCount];
            rewardPriceSprayed = CaseDriveAwards[i][aSprayPrice];
            return 1;
        }
    }
    
    // Добавьте поиск по остальным кейсам (ToThePeaks, RealmOfDarkness, Spring, Blitz, CaseNo5, Beach, FirstManeuver, SecondManeuver, School, PrologueOfMystery, EpilogueOfMystery, Founder, Defender, Thunder, VoiceOfTheStreets)
    
    return 0;
}

// Распыление награды и получение пыли
stock Cases_SprayReward(playerid, rewardId)
{
    new rewardType, rewardValue, rewardCount, rewardPriceSprayed;
    if(!Cases_FindAwardById(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardPriceSprayed)) 
        return 0;
    
    if(rewardPriceSprayed > 0)
    {
        AddPlayerDustValue(playerid, rewardPriceSprayed);  // rewardPriceSprayed = aSprayPrice
        return rewardPriceSprayed;  // возвращаем количество полученной пыли
    }
    return 0;
}

// Извлечение массива целых чисел из JSON строки
stock Cases_ExtractIntArray(const source[], const key[], dest[], maxCount)
{
    new needle[32];
    format(needle, sizeof(needle), "\"%s\":[", key);
    new start = strfind(source, needle, true);
    if(start == -1) return 0;
    start += strlen(needle);

    new count = 0;
    new len = strlen(source);
    new token[24];
    new tokenLen = 0;

    for(new i = start; i < len && count < maxCount; i++)
    {
        new ch = source[i];
        if(ch == ']')
        {
            if(tokenLen > 0)
            {
                token[tokenLen] = EOS;
                dest[count++] = strval(token);
            }
            break;
        }
        if((ch >= '0' && ch <= '9') || ch == '-')
        {
            if(tokenLen < sizeof(token) - 1) token[tokenLen++] = ch;
        }
        else
        {
            if(tokenLen > 0)
            {
                token[tokenLen] = EOS;
                dest[count++] = strval(token);
                tokenLen = 0;
            }
        }
    }
    return count;
}

// Выдача награды (эмиттер)
stock Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardPriceSprayed)
{
    // Здесь нужно реализовать выдачу награды
    // Пример для разных типов:
    switch(rewardType)
    {
        case 1: // EXP
        {
            // Выдача опыта
            printf("[Cases] Player %d got EXP: %d", playerid, rewardCount);
        }
        case 2: // Money
        {
            GivePlayerMoneyEx(playerid, rewardCount);
        }
        case 5: // Vehicle
        {
            // Выдача транспорта
            printf("[Cases] Player %d got vehicle: %d", playerid, rewardValue);
        }
        case 9: // VIP
        {
            // Выдача VIP
            printf("[Cases] Player %d got VIP type %d for %d minutes", playerid, rewardValue, rewardCount);
        }
        case 10: // BP EXP
        {
            GivePlayerDonateRub(playerid, rewardCount);
        }
        case 11: // Item
        {
            // Выдача предмета
            printf("[Cases] Player %d got item %d x%d", playerid, rewardValue, rewardCount);
        }
        case 23: 
{
}
        case 134: // Skin
        {
            // Выдача скина
            printf("[Cases] Player %d got skin: %d", playerid, rewardCount);
        }
    }
    return 1;
}

// ========== GUI ФУНКЦИИ ==========

stock Cases_Init()
{
    printf("[Cases] System initialized");
    return 1;
}

stock Cases_OnPlayerConnect(playerid)
{
    pCasesSelected[playerid] = 1;
    pCasesGUIOpen[playerid] = 0;
    pCasesLastAction[playerid] = 0;
    pCasesPendingCount[playerid] = 0;
    pCasesLastOpenedIdx[playerid] = 0;
    for(new i = 0; i < 10; i++) {
        pCasesPendingRewards[playerid][i] = 0;
    }
    return 1;
}

stock Cases_SavePlayer(playerid)
{
    return 1;
}

stock Cases_LoadPlayer(playerid)
{
    return 1;
}

stock Cases_ShowGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetBool(json, "s", false);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "cs", 2);
    JSON_SetInt(json, "i", 1);

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
    
    SendPacketToClient(playerid, GUICases, json);
    JSON_Cleanup(json);
    pCasesGUIOpen[playerid] = 1;
    return 1;
}

stock Cases_UpdateGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetBool(json, "s", false);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "cs", 2);
    JSON_SetInt(json, "i", 1);

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
    
    SendPacketToClient(playerid, GUICases, json);
    JSON_Cleanup(json);
    return 1;
}

stock Cases_SelectCase(playerid, caseId)
{
    pCasesSelected[playerid] = caseId;
    Cases_UpdateGUI(playerid);
}

stock Cases_OpenCase(playerid, caseId, openType)
{
    new currentTime = gettime();
    if(currentTime - pCasesLastAction[playerid] < 1) return 0;
    pCasesLastAction[playerid] = currentTime;
    
    new openCount = (openType == CASES_OPEN_ONE) ? 1 : 10;
    new ownedCount = GetPlayerCaseCountByType(playerid, caseId);
    
    if(ownedCount < openCount)
    {
        new Node:json = JSON_Object(
				"t", JSON_Int(CASES_TYPE_OPEN),
				"s", JSON_Int(-1),
				"d", JSON_Int(1)
			);
        SendPacketToClient(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }
    
    AddPlayerCaseCountByType(playerid, caseId, -openCount);
    
    // Сохраняем индекс открытого кейса
    pCasesLastOpenedIdx[playerid] = caseId;
    
    // Получаем массив наград для этого кейса
    new awardsCount = 0;
    new awardsArray[37][ENUM_CASE_AWARDS]; // Максимальный размер
    
    switch(caseId)
    {
        case 1: // Ежедневный кейс
        {
            awardsCount = 20;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = CaseDailyAwards[i][aId];
                awardsArray[i][aType] = CaseDailyAwards[i][aType];
                awardsArray[i][aInternalID] = CaseDailyAwards[i][aInternalID];
                awardsArray[i][aCount] = CaseDailyAwards[i][aCount];
                awardsArray[i][aSprayPrice] = CaseDailyAwards[i][aSprayPrice];
            }
        }
        case 2: // Кейс бомжа
        {
            awardsCount = 27;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = CaseBomjAwards[i][aId];
                awardsArray[i][aType] = CaseBomjAwards[i][aType];
                awardsArray[i][aInternalID] = CaseBomjAwards[i][aInternalID];
                awardsArray[i][aCount] = CaseBomjAwards[i][aCount];
                awardsArray[i][aSprayPrice] = CaseBomjAwards[i][aSprayPrice];
            }
        }
        case 3: // Стандартный кейс
        {
            awardsCount = 37;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = CaseStandartAwards[i][aId];
                awardsArray[i][aType] = CaseStandartAwards[i][aType];
                awardsArray[i][aInternalID] = CaseStandartAwards[i][aInternalID];
                awardsArray[i][aCount] = CaseStandartAwards[i][aCount];
                awardsArray[i][aSprayPrice] = CaseStandartAwards[i][aSprayPrice];
            }
        }
        case 4: // Авто-кейс
        {
            awardsCount = 37;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = CaseAutoAwards[i][aId];
                awardsArray[i][aType] = CaseAutoAwards[i][aType];
                awardsArray[i][aInternalID] = CaseAutoAwards[i][aInternalID];
                awardsArray[i][aCount] = CaseAutoAwards[i][aCount];
                awardsArray[i][aSprayPrice] = CaseAutoAwards[i][aSprayPrice];
            }
        }
        case 5: // Особый кейс
        {
            awardsCount = 22;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = CaseSpecialAwards[i][aId];
                awardsArray[i][aType] = CaseSpecialAwards[i][aType];
                awardsArray[i][aInternalID] = CaseSpecialAwards[i][aInternalID];
                awardsArray[i][aCount] = CaseSpecialAwards[i][aCount];
                awardsArray[i][aSprayPrice] = CaseSpecialAwards[i][aSprayPrice];
            }
        }
        case 8: // Драйв кейс
        {
            awardsCount = 25;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = CaseDriveAwards[i][aId];
                awardsArray[i][aType] = CaseDriveAwards[i][aType];
                awardsArray[i][aInternalID] = CaseDriveAwards[i][aInternalID];
                awardsArray[i][aCount] = CaseDriveAwards[i][aCount];
                awardsArray[i][aSprayPrice] = CaseDriveAwards[i][aSprayPrice];
            }
        }
        // Добавьте остальные кейсы (6,7,9-21) по аналогии
        default:
        {
            awardsCount = 20;
            for(new i = 0; i < awardsCount; i++) {
                awardsArray[i][aId] = i + 1;
                awardsArray[i][aType] = 2;
                awardsArray[i][aInternalID] = 1;
                awardsArray[i][aCount] = 10000;
                awardsArray[i][aSprayPrice] = 0;
            }
        }
    }
    
    // Генерируем награды
    new rewardIds[10];
    for(new i = 0; i < openCount; i++)
    {
        // Выбираем случайную награду из массива этого кейса
        new randomIndex = random(awardsCount);
        rewardIds[i] = awardsArray[randomIndex][aId];
        pCasesPendingRewards[playerid][i] = rewardIds[i];
    }
    pCasesPendingCount[playerid] = openCount;
    
    new prStr[128];
    prStr[0] = '\0';
    for(new r = 0; r < openCount; r++) {
        new tmp[16];
        if(r > 0) strcat(prStr, ",");
        format(tmp, sizeof(tmp), "%d", rewardIds[r]);
        strcat(prStr, tmp);
    }
    
    new jsonStr[512];
    format(jsonStr, sizeof(jsonStr), 
        "{\"t\":%d,\"s\":1,\"bc\":%d,\"pc\":%d,\"cs\":%d,\"type\":%d,\"pr\":[%s]}",
        CASES_TYPE_OPEN, GetPlayerDonateRub(playerid), GetPlayerDustValue(playerid), pCasesSelected[playerid],
        openType, prStr);
    
    new Node:json;
    JSON_Parse(jsonStr, json);
    
    SendPacketToClient(playerid, GUICases, json);
    JSON_Cleanup(json);
    
    SavePlayerAccount(playerid);
    return 1;
}

// ========== ОСНОВНАЯ ФУНКЦИЯ ВЗЯТИЯ НАГРАД С РАСПЫЛЕНИЕМ ==========
stock Cases_TakeRewards(playerid, const jsonData[])
{
    new takeRewards[10], sprayRewards[10];
    new takeCount = Cases_ExtractIntArray(jsonData, "bt1", takeRewards, 10);
    new sprayCount = Cases_ExtractIntArray(jsonData, "bt2", sprayRewards, 10);
    new totalDustGained = 0;
    
    // Если клиент не отправил списки, но есть ожидающие награды - берем их
    if(takeCount == 0 && sprayCount == 0 && pCasesPendingCount[playerid] > 0)
    {
        for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
        {
            takeRewards[takeCount++] = pCasesPendingRewards[playerid][i];
        }
    }
    
    // Выдача наград (взять)
    for(new i = 0; i < takeCount; i++)
    {
        if(takeRewards[i] <= 0) continue;
        
        new rewardType, rewardValue, rewardCount, rewardPriceSprayed;
        if(Cases_FindAwardById(playerid, takeRewards[i], rewardType, rewardValue, rewardCount, rewardPriceSprayed))
        {
            Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardPriceSprayed);
        }
    }
    
    // РАСПЫЛЕНИЕ наград и получение пыли
    for(new i = 0; i < sprayCount; i++)
    {
        if(sprayRewards[i] > 0)
        {
            new dustAmount = Cases_SprayReward(playerid, sprayRewards[i]);
            if(dustAmount > 0)
            {
                totalDustGained += dustAmount;
                new dustNotify[128];
                format(dustNotify, sizeof(dustNotify), "Вы распылили награду и получили %d пыли.", dustAmount);
                SendClientMessage(playerid, 0xFFFF00FF, dustNotify);
            }
            else
            {
                SendClientMessage(playerid, 0xFF0000FF, "Эту награду нельзя распылить!");
            }
        }
    }
    
    // Очищаем ожидающие награды
    pCasesPendingCount[playerid] = 0;
    for(new i = 0; i < 10; i++) pCasesPendingRewards[playerid][i] = 0;
    
    // Проверяем обмен пыли на специальные кейсы (1500 пыли = 1 спец кейс)
    Cases_CheckDustExchange(playerid);
    
    Cases_SavePlayer(playerid);
    SavePlayerAccount(playerid);
    
    // Отправляем ответ клиенту
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", CASES_TYPE_TAKE_REWARDS);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
    
    new Node:cc_array = JSON_Array();
    
    for (new i = 1; i <= 5; i++)
    {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));

        new Node:tempArray = JSON_Array(cc_obj);

        cc_array = JSON_Append(cc_array, tempArray);
    }
    JSON_SetArray(response, "cc", cc_array);
    
    SendPacketToClient(playerid, GUICases, response);
    JSON_Cleanup(response);
    
    if(totalDustGained > 0)
    {
        new str[64];
        format(str, sizeof(str), "Всего получено пыли: %d", totalDustGained);
        SendClientMessage(playerid, 0x00FF00FF, str);
    }
    
    return 1;
}

// ========== ОБМЕН ПЫЛИ НА СПЕЦИАЛЬНЫЕ КЕЙСЫ ==========
stock Cases_CheckDustExchange(playerid)
{
    new exchanged = 0;
    new dustValue = GetPlayerDustValue(playerid);
    
    // Каждые 1500 пыли даем 1 специальный кейс (case_type = 5)
    while(dustValue >= 1500)
    {
        dustValue -= 1500;
        AddPlayerCaseCountByType(playerid, 5, 1);
        exchanged++;
    }
    
    if(exchanged > 0)
    {
        // Обновляем значение пыли
        SetPVarInt(playerid, "player_dust", dustValue);
        
        new str[96];
        format(str, sizeof(str), "Вы обменяли пыль и получили %d специальных кейсов!", exchanged);
        SendClientMessage(playerid, 0x00FF00FF, str);
        
        // Обновляем GUI
        Cases_UpdateGUI(playerid);
    }
    return exchanged;
}

// ---------- ГЛАВНАЯ ФУНКЦИЯ ОБРАБОТКИ GUI ПАКЕТОВ ----------
stock Cases_SendPacketToClient(playerid, const jsonData[])
{
    new Node:json;
    if(JSON_Parse(jsonData, json) != 0) return 0;
    
    new closeVal = 0;
    JSON_GetInt(json, "c", closeVal);
    if(closeVal == 1)
    {
        pCasesGUIOpen[playerid] = 0;
        JSON_Cleanup(json);
        return 1;
    }
    
    new actionType = 0;
    JSON_GetInt(json, "t", actionType);
    
    switch(actionType)
    {
        case CASES_TYPE_SELECT:
        {
            new caseId = 0;
            JSON_GetInt(json, "cs", caseId);
            Cases_SelectCase(playerid, caseId);
        }
        case CASES_TYPE_OPEN:
        {
            new caseId = 0, openType = 0;
            JSON_GetInt(json, "cs", caseId);
            JSON_GetInt(json, "type", openType);
            Cases_OpenCase(playerid, caseId, openType);
        }
        case CASES_TYPE_TAKE_REWARDS:
        {
            Cases_TakeRewards(playerid, jsonData);
        }
        case CASES_TYPE_GO_DONATE:
        {
            new donateType = 0;
            JSON_GetInt(json, "d", donateType);
            if(donateType == 2)
            {
                SendClientMessage(playerid, 0xFFFF00FF, "Open donate shop to buy BC.");
            }
        }
        case CASES_TYPE_FROM_BANNER:
        {
            Cases_UpdateGUI(playerid);
        }
    }
    
    JSON_Cleanup(json);
    return 1;
}

// ---------- КОМАНДЫ ----------
CMD:cases(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && 
       strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0 && 
       strcmp(GetPlayerNameEx(playerid), "Danya_Test", true) != 0) 
    {
        SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа");
        return 1;
    } 
    
    Cases_ShowGUI(playerid);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new to_player, type_case, count;
    if(sscanf(params, "udd", to_player, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-5] [count]");

    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > 5) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 5.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(to_player, type_case, count);
    SavePlayerAccount(to_player);

    new str[128];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", count, type_case, GetPlayerNameEx(to_player));
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(to_player, COLOR_WHITE, str);
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

// ---------- CALLBACKS ----------
forward OnPlayerRewardsLoad(playerid);
public OnPlayerRewardsLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);

    if(rows == 0)
    {
        if(GetPVarInt(playerid, "reward_offset") == 0)
        {
            ShowNotificationKirill(playerid, 2, 4, 1, 1, "У вас нет доступных наград!", "");
            
            new Node:emptyObj = JSON_Object();
            JSON_SetInt(emptyObj, "o", 1);
            JSON_SetInt(emptyObj, "pc", GetPlayerDustValue(playerid));
            JSON_SetArray(emptyObj, "pr", JSON_Array());
            SendPacketToClient(playerid, 74, emptyObj);
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
            format(name, 32, "%s", CaseDailyAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 2 && a_id >= 0 && a_id < 28) {
            type = CaseBomjAwards[a_id][aType];
            internal = CaseBomjAwards[a_id][aInternalID];
            spray_price = CaseBomjAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseBomjAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 3 && a_id >= 0 && a_id < 37) {
            type = CaseStandartAwards[a_id][aType];
            internal = CaseStandartAwards[a_id][aInternalID];
            spray_price = CaseStandartAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseStandartAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 4 && a_id >= 0 && a_id < 31) {
            type = CaseAutoAwards[a_id][aType];
            internal = CaseAutoAwards[a_id][aInternalID];
            spray_price = CaseAutoAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseAutoAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 5 && a_id >= 0 && a_id < 20) {
            type = CaseSpecialAwards[a_id][aType];
            internal = CaseSpecialAwards[a_id][aInternalID];
            spray_price = CaseSpecialAwards[a_id][aSprayPrice];
            format(name, 32, "%s", CaseSpecialAwards[a_id][aName]);
            found = true;
        }
        else if(case_id == 8 && a_id >= 0 && a_id < 25) {
            type = CaseDriveAwards[a_id][aType];
            internal = CaseDriveAwards[a_id][aInternalID];
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
            JSON_Append(prArray, item);
            JSON_Cleanup(item);
        }
    }

    JSON_SetArray(JSONObject, "pr", prArray);
    SendPacketToClient(playerid, 74, JSONObject);
    JSON_Cleanup(JSONObject);
    JSON_Cleanup(prArray);
    return 1;
}

stock ResetPlayerCase(playerid)
{
    SetPlayerData(playerid, P_COUNT_TODAY_CASE, 0);
    SetPlayerData(playerid, P_COUNT_BOMJ_CASE, 0);
    SetPlayerData(playerid, P_COUNT_STANDART_CASE, 0);
    SetPlayerData(playerid, P_COUNT_CAR_CASE, 0);
    SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, 0);
}