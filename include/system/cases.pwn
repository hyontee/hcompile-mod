// ==========================================================================
// КОНСТАНТЫ
// ==========================================================================
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

// Типы наград
#define REWARD_TYPE_EXP         1
#define REWARD_TYPE_MONEY       2
#define REWARD_TYPE_BC          3
#define REWARD_TYPE_CASE        4
#define REWARD_TYPE_VEHICLE     5
#define REWARD_TYPE_VIP         9
#define REWARD_TYPE_BP_EXP      10
#define REWARD_TYPE_ITEM        11
#define REWARD_TYPE_DUST        21
#define REWARD_TYPE_EVENT_RES   23

#define MAX_CASES               19
#define MAX_AWARDS_PER_CASE     40
#define MAX_BONUS_PER_CASE      5

// ==========================================================================
// СТРУКТУРЫ
// ==========================================================================
enum E_CASE_AWARD {
    aId,
    aRarity,
    aType,
    aInternalId,
    aCount,
    aPriceSprayed
};

enum E_CASE_BONUS {
    bId,
    bNumberOpen,
    bRarity,
    bType,
    bInternalId,
    bCount,
    bPriceSprayed
};

enum E_CASE_DATA {
    cId,
    cPriceOne,
    cPriceTen,
    cDiscountOne,
    cDiscountTen,
    cAwardsCount,
    cBonusCount
};

// ==========================================================================
// ПЕРЕМЕННЫЕ
// ==========================================================================
static pCasesDust[MAX_PLAYERS];
static pCasesSelected[MAX_PLAYERS];
static pCasesGUIOpen[MAX_PLAYERS];
static pCasesLastAction[MAX_PLAYERS];
static pCasesPendingRewards[MAX_PLAYERS][10];
static pCasesPendingCount[MAX_PLAYERS];
static pCasesOpenedByCase[MAX_PLAYERS][MAX_CASES];
static pCasesLastOpenedIdx[MAX_PLAYERS];

static CaseData[MAX_CASES][E_CASE_DATA];
static CaseAwards[MAX_CASES][MAX_AWARDS_PER_CASE][E_CASE_AWARD];
static CaseBonus[MAX_CASES][MAX_BONUS_PER_CASE][E_CASE_BONUS];

// ==========================================================================
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ==========================================================================
stock GetPlayerDustValue(playerid) {
    return GetPVarInt(playerid, "player_dust");
}

stock AddPlayerDustValue(playerid, amount) {
    new dust = GetPVarInt(playerid, "player_dust");
    dust += amount;
    if(dust < 0) dust = 0;
    SetPVarInt(playerid, "player_dust", dust);
    return dust;
}

stock GetPlayerCaseCountByType(playerid, case_type) {
    switch(case_type) {
        case 1: return GetPlayerData(playerid, P_COUNT_TODAY_CASE);
        case 2: return GetPlayerData(playerid, P_COUNT_BOMJ_CASE);
        case 3: return GetPlayerData(playerid, P_COUNT_STANDART_CASE);
        case 4: return GetPlayerData(playerid, P_COUNT_CAR_CASE);
        case 5: return GetPlayerData(playerid, P_COUNT_OSOBIY_CASE);
    }
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value) {
    if(value < 0) value = 0;
    switch(case_type) {
        case 1: return SetPlayerData(playerid, P_COUNT_TODAY_CASE, value);
        case 2: return SetPlayerData(playerid, P_COUNT_BOMJ_CASE, value);
        case 3: return SetPlayerData(playerid, P_COUNT_STANDART_CASE, value);
        case 4: return SetPlayerData(playerid, P_COUNT_CAR_CASE, value);
        case 5: return SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, value);
    }
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount) {
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
}

// ==========================================================================
// ИНИЦИАЛИЗАЦИЯ КЕЙСОВ
// ==========================================================================
stock Cases_GetIndex(caseId) {
    for(new i = 0; i < MAX_CASES; i++) {
        if(CaseData[i][cId] == caseId) return i;
    }
    return -1;
}

stock Cases_InitCase1() {
    new idx = 0; // Ежедневный кейс (id: 1)
    CaseData[idx][cId] = 1;
    CaseData[idx][cPriceOne] = 15;
    CaseData[idx][cPriceTen] = 150;
    CaseData[idx][cDiscountOne] = 0;
    CaseData[idx][cDiscountTen] = 0;
    CaseData[idx][cAwardsCount] = 20;
    CaseData[idx][cBonusCount] = 5;
    
    // aId, aRarity, aType, aInternalId, aCount, aPriceSprayed
    CaseAwards[idx][0][aId]=1; CaseAwards[idx][0][aRarity]=1; CaseAwards[idx][0][aType]=REWARD_TYPE_ITEM; CaseAwards[idx][0][aInternalId]=23; CaseAwards[idx][0][aCount]=1; CaseAwards[idx][0][aPriceSprayed]=10;
    CaseAwards[idx][1][aId]=2; CaseAwards[idx][1][aRarity]=1; CaseAwards[idx][1][aType]=REWARD_TYPE_ITEM; CaseAwards[idx][1][aInternalId]=22; CaseAwards[idx][1][aCount]=1; CaseAwards[idx][1][aPriceSprayed]=10;
    CaseAwards[idx][2][aId]=3; CaseAwards[idx][2][aRarity]=1; CaseAwards[idx][2][aType]=REWARD_TYPE_BP_EXP; CaseAwards[idx][2][aInternalId]=1; CaseAwards[idx][2][aCount]=200; CaseAwards[idx][2][aPriceSprayed]=0;
    CaseAwards[idx][3][aId]=4; CaseAwards[idx][3][aRarity]=1; CaseAwards[idx][3][aType]=REWARD_TYPE_ITEM; CaseAwards[idx][3][aInternalId]=21; CaseAwards[idx][3][aCount]=1; CaseAwards[idx][3][aPriceSprayed]=10;
    CaseAwards[idx][4][aId]=5; CaseAwards[idx][4][aRarity]=1; CaseAwards[idx][4][aType]=REWARD_TYPE_MONEY; CaseAwards[idx][4][aInternalId]=1; CaseAwards[idx][4][aCount]=2000; CaseAwards[idx][4][aPriceSprayed]=0;
    CaseAwards[idx][5][aId]=6; CaseAwards[idx][5][aRarity]=1; CaseAwards[idx][5][aType]=REWARD_TYPE_BC; CaseAwards[idx][5][aInternalId]=1; CaseAwards[idx][5][aCount]=5; CaseAwards[idx][5][aPriceSprayed]=0;
    CaseAwards[idx][6][aId]=7; CaseAwards[idx][6][aRarity]=1; CaseAwards[idx][6][aType]=REWARD_TYPE_MONEY; CaseAwards[idx][6][aInternalId]=1; CaseAwards[idx][6][aCount]=3000; CaseAwards[idx][6][aPriceSprayed]=0;
    CaseAwards[idx][7][aId]=8; CaseAwards[idx][7][aRarity]=1; CaseAwards[idx][7][aType]=REWARD_TYPE_BC; CaseAwards[idx][7][aInternalId]=1; CaseAwards[idx][7][aCount]=10; CaseAwards[idx][7][aPriceSprayed]=0;
    CaseAwards[idx][8][aId]=9; CaseAwards[idx][8][aRarity]=1; CaseAwards[idx][8][aType]=REWARD_TYPE_VIP; CaseAwards[idx][8][aInternalId]=1; CaseAwards[idx][8][aCount]=2; CaseAwards[idx][8][aPriceSprayed]=10;
    CaseAwards[idx][9][aId]=10; CaseAwards[idx][9][aRarity]=1; CaseAwards[idx][9][aType]=REWARD_TYPE_BP_EXP; CaseAwards[idx][9][aInternalId]=1; CaseAwards[idx][9][aCount]=300; CaseAwards[idx][9][aPriceSprayed]=0;
    CaseAwards[idx][10][aId]=11; CaseAwards[idx][10][aRarity]=1; CaseAwards[idx][10][aType]=REWARD_TYPE_EXP; CaseAwards[idx][10][aInternalId]=1; CaseAwards[idx][10][aCount]=4; CaseAwards[idx][10][aPriceSprayed]=0;
    CaseAwards[idx][11][aId]=12; CaseAwards[idx][11][aRarity]=2; CaseAwards[idx][11][aType]=REWARD_TYPE_VEHICLE; CaseAwards[idx][11][aInternalId]=462; CaseAwards[idx][11][aCount]=0; CaseAwards[idx][11][aPriceSprayed]=20;
    CaseAwards[idx][12][aId]=13; CaseAwards[idx][12][aRarity]=1; CaseAwards[idx][12][aType]=REWARD_TYPE_BP_EXP; CaseAwards[idx][12][aInternalId]=1; CaseAwards[idx][12][aCount]=500; CaseAwards[idx][12][aPriceSprayed]=0;
    CaseAwards[idx][13][aId]=14; CaseAwards[idx][13][aRarity]=1; CaseAwards[idx][13][aType]=REWARD_TYPE_MONEY; CaseAwards[idx][13][aInternalId]=1; CaseAwards[idx][13][aCount]=20000; CaseAwards[idx][13][aPriceSprayed]=0;
    CaseAwards[idx][14][aId]=15; CaseAwards[idx][14][aRarity]=1; CaseAwards[idx][14][aType]=REWARD_TYPE_BC; CaseAwards[idx][14][aInternalId]=1; CaseAwards[idx][14][aCount]=15; CaseAwards[idx][14][aPriceSprayed]=0;
    CaseAwards[idx][15][aId]=16; CaseAwards[idx][15][aRarity]=1; CaseAwards[idx][15][aType]=REWARD_TYPE_VIP; CaseAwards[idx][15][aInternalId]=2; CaseAwards[idx][15][aCount]=2; CaseAwards[idx][15][aPriceSprayed]=10;
    CaseAwards[idx][16][aId]=17; CaseAwards[idx][16][aRarity]=1; CaseAwards[idx][16][aType]=REWARD_TYPE_BP_EXP; CaseAwards[idx][16][aInternalId]=1; CaseAwards[idx][16][aCount]=500; CaseAwards[idx][16][aPriceSprayed]=0;
    CaseAwards[idx][17][aId]=18; CaseAwards[idx][17][aRarity]=1; CaseAwards[idx][17][aType]=REWARD_TYPE_MONEY; CaseAwards[idx][17][aInternalId]=1; CaseAwards[idx][17][aCount]=30000; CaseAwards[idx][17][aPriceSprayed]=0;
    CaseAwards[idx][18][aId]=19; CaseAwards[idx][18][aRarity]=1; CaseAwards[idx][18][aType]=REWARD_TYPE_EXP; CaseAwards[idx][18][aInternalId]=1; CaseAwards[idx][18][aCount]=6; CaseAwards[idx][18][aPriceSprayed]=0;
    CaseAwards[idx][19][aId]=20; CaseAwards[idx][19][aRarity]=2; CaseAwards[idx][19][aType]=REWARD_TYPE_VEHICLE; CaseAwards[idx][19][aInternalId]=549; CaseAwards[idx][19][aCount]=0; CaseAwards[idx][19][aPriceSprayed]=20;

    // Бонусы (bId, bNumberOpen, bRarity, bType, bInternalId, bCount, bPriceSprayed)
    CaseBonus[idx][0][bId]=101; CaseBonus[idx][0][bNumberOpen]=40; CaseBonus[idx][0][bRarity]=4; CaseBonus[idx][0][bType]=REWARD_TYPE_CASE; CaseBonus[idx][0][bInternalId]=3; CaseBonus[idx][0][bCount]=1;
    CaseBonus[idx][1][bId]=102; CaseBonus[idx][1][bNumberOpen]=30; CaseBonus[idx][1][bRarity]=3; CaseBonus[idx][1][bType]=REWARD_TYPE_DUST; CaseBonus[idx][1][bInternalId]=1; CaseBonus[idx][1][bCount]=50;
    CaseBonus[idx][2][bId]=103; CaseBonus[idx][2][bNumberOpen]=20; CaseBonus[idx][2][bRarity]=2; CaseBonus[idx][2][bType]=REWARD_TYPE_CASE; CaseBonus[idx][2][bInternalId]=2; CaseBonus[idx][2][bCount]=1;
    CaseBonus[idx][3][bId]=104; CaseBonus[idx][3][bNumberOpen]=10; CaseBonus[idx][3][bRarity]=1; CaseBonus[idx][3][bType]=REWARD_TYPE_CASE; CaseBonus[idx][3][bInternalId]=1; CaseBonus[idx][3][bCount]=2;
    CaseBonus[idx][4][bId]=105; CaseBonus[idx][4][bNumberOpen]=5; CaseBonus[idx][4][bRarity]=1; CaseBonus[idx][4][bType]=REWARD_TYPE_CASE; CaseBonus[idx][4][bInternalId]=1; CaseBonus[idx][4][bCount]=1;
}

stock Cases_InitAll() {
    Cases_InitCase1();
    printf("[Cases] System initialized");
    return 1;
}

// ==========================================================================
// ВЫБОР СЛУЧАЙНОЙ НАГРАДЫ
// ==========================================================================
stock Cases_GetRandomReward(caseIdx) {
    new totalWeight = 0;
    new awardsCount = CaseData[caseIdx][cAwardsCount];
    
    for(new i = 0; i < awardsCount; i++) {
        new rarity = CaseAwards[caseIdx][i][aRarity];
        new weight = 100 - (rarity * 15);
        if(weight < 5) weight = 5;
        totalWeight += weight;
    }
    
    new roll = random(totalWeight);
    new cumulative = 0;
    
    for(new i = 0; i < awardsCount; i++) {
        new rarity = CaseAwards[caseIdx][i][aRarity];
        new weight = 100 - (rarity * 15);
        if(weight < 5) weight = 5;
        cumulative += weight;
        
        if(roll < cumulative) {
            return CaseAwards[caseIdx][i][aId];
        }
    }
    return CaseAwards[caseIdx][0][aId];
}

// ==========================================================================
// ПОИСК НАГРАДЫ ПО ID
// ==========================================================================
stock Cases_FindAwardById(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardPriceSprayed) {
    new lastIdx = pCasesLastOpenedIdx[playerid];
    if(lastIdx >= 0 && lastIdx < MAX_CASES) {
        for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++) {
            if(CaseAwards[lastIdx][i][aId] == rewardId) {
                rewardType = CaseAwards[lastIdx][i][aType];
                rewardValue = CaseAwards[lastIdx][i][aInternalId];
                rewardCount = CaseAwards[lastIdx][i][aCount];
                rewardPriceSprayed = CaseAwards[lastIdx][i][aPriceSprayed];
                return 1;
            }
        }
    }
    for(new c = 0; c < MAX_CASES; c++) {
        for(new i = 0; i < CaseData[c][cAwardsCount]; i++) {
            if(CaseAwards[c][i][aId] == rewardId) {
                rewardType = CaseAwards[c][i][aType];
                rewardValue = CaseAwards[c][i][aInternalId];
                rewardCount = CaseAwards[c][i][aCount];
                rewardPriceSprayed = CaseAwards[c][i][aPriceSprayed];
                return 1;
            }
        }
    }
    return 0;
}

// ==========================================================================
// ВЫДАЧА НАГРАДЫ
// ==========================================================================
stock Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardPriceSprayed) {
    switch(rewardType) {
        case REWARD_TYPE_EXP: {
            printf("[Cases] Player %d got EXP: %d", playerid, rewardCount);
        }
        case REWARD_TYPE_MONEY: {
            GivePlayerMoneyEx(playerid, rewardCount);
        }
        case REWARD_TYPE_BC: {
            GivePlayerDonateRub(playerid, rewardCount);
        }
        case REWARD_TYPE_VEHICLE: {
            printf("[Cases] Player %d got vehicle: %d", playerid, rewardValue);
        }
        case REWARD_TYPE_VIP: {
            printf("[Cases] Player %d got VIP type %d for %d minutes", playerid, rewardValue, rewardCount);
        }
        case REWARD_TYPE_BP_EXP: {
            GivePlayerDonateRub(playerid, rewardCount);
        }
        case REWARD_TYPE_ITEM: {
            printf("[Cases] Player %d got item %d x%d", playerid, rewardValue, rewardCount);
        }
    }
    return 1;
}

// ==========================================================================
// РАСПЫЛЕНИЕ НАГРАДЫ
// ==========================================================================
stock Cases_SprayReward(playerid, rewardId) {
    new rewardType, rewardValue, rewardCount, rewardPriceSprayed;
    if(!Cases_FindAwardById(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardPriceSprayed)) 
        return 0;
    
    if(rewardPriceSprayed > 0) {
        AddPlayerDustValue(playerid, rewardPriceSprayed);
        return rewardPriceSprayed;
    }
    return 0;
}

// ==========================================================================
// ОБМЕН ПЫЛИ НА КЕЙСЫ
// ==========================================================================
stock Cases_CheckDustExchange(playerid) {
    new exchanged = 0;
    new dustValue = GetPlayerDustValue(playerid);
    
    while(dustValue >= 1500) {
        dustValue -= 1500;
        AddPlayerCaseCountByType(playerid, 5, 1);
        exchanged++;
    }
    
    if(exchanged > 0) {
        SetPVarInt(playerid, "player_dust", dustValue);
        new str[96];
        format(str, sizeof(str), "Вы обменяли пыль и получили %d специальных кейсов!", exchanged);
        SendClientMessage(playerid, 0x00FF00FF, str);
        Cases_UpdateGUI(playerid);
    }
    return exchanged;
}

// ==========================================================================
// ИЗВЛЕЧЕНИЕ МАССИВА ИЗ JSON
// ==========================================================================
stock Cases_ExtractIntArray(const source[], const key[], dest[], maxCount) {
    new needle[32];
    format(needle, sizeof(needle), "\"%s\":[", key);
    new start = strfind(source, needle, true);
    if(start == -1) return 0;
    start += strlen(needle);
    
    new count = 0;
    new len = strlen(source);
    new token[24];
    new tokenLen = 0;
    
    for(new i = start; i < len && count < maxCount; i++) {
        new ch = source[i];
        if(ch == ']') {
            if(tokenLen > 0) {
                token[tokenLen] = EOS;
                dest[count++] = strval(token);
            }
            break;
        }
        if((ch >= '0' && ch <= '9') || ch == '-') {
            if(tokenLen < sizeof(token) - 1) token[tokenLen++] = ch;
        } else {
            if(tokenLen > 0) {
                token[tokenLen] = EOS;
                dest[count++] = strval(token);
                tokenLen = 0;
            }
        }
    }
    return count;
}


stock Cases_OpenCase(playerid, caseId, openType)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1) return 0;

    if(openType != CASES_OPEN_ONE && openType != CASES_OPEN_TEN) {
        openType = CASES_OPEN_ONE;
    }
    
    new openCount = (openType == CASES_OPEN_ONE) ? 1 : 10;
    new rewardIds[10];
    new rewardRarities[10];
    new useOwnedCases = 0;
    
    // Проверяем наличие кейсов у игрока
    if(GetPlayerCaseCountByType(playerid, caseId) > 0) {
        if(GetPlayerCaseCountByType(playerid, caseId) < openCount) {
            // Отправляем ошибку клиенту
            new Node:json = JSON_Object(
				"t", JSON_Int(CASES_TYPE_OPEN),
				"s", JSON_Int(-1),
				"d", JSON_Int(1)
			);
			SendPacketToClient(playerid, GUICases, json);
            JSON_Cleanup(json);
            return 0;
        }
        useOwnedCases = 1;
    }
    
    // Списываем кейсы или BC
    if(useOwnedCases) {
        AddPlayerCaseCountByType(playerid, caseId, -openCount);
    } else {
        new price = 100;
        new discount = (openType == CASES_OPEN_ONE) ? CaseData[idx][cDiscountOne] : CaseData[idx][cDiscountTen];
        price = price - (price * discount / 100);
        
        if(GetPlayerDonateRub(playerid) < price) {
            new Node:json = JSON_Object();
            new Node:json = JSON_Object(
				"t", JSON_Int(CASES_TYPE_OPEN),
				"s", JSON_Int(-1),
				"d", JSON_Int(1)
			);
            SendPacketToClient(playerid, GUICases, json);
            JSON_Cleanup(json);
            return 0;
        }
        
        GivePlayerDonateRub(playerid, -price, "Cases: open", true, true);
    }
    
    // Генерируем награды
    for(new i = 0; i < openCount; i++) {
        rewardIds[i] = Cases_GetRandomReward(idx);
        pCasesPendingRewards[playerid][i] = rewardIds[i];
        
        // Находим редкость награды
        for(new j = 0; j < CaseData[idx][cAwardsCount]; j++) {
            if(CaseAwards[idx][j][aId] == rewardIds[i]) {
                rewardRarities[i] = CaseAwards[idx][j][aRarity];
                break;
            }
        }
    }
    pCasesPendingCount[playerid] = openCount;
    
    // Обновляем счётчики открытий для бонусов
    pCasesOpenedByCase[playerid][idx] += openCount;
    pCasesLastOpenedIdx[playerid] = idx;
    
    // Формируем JSON для клиента (как ожидает CasesViewModel)
    // Формат: {"t":2, "s":1, "bc":число, "pc":число, "bcc":число, "cs":число, "type":число, "pr":[1,2,3]}
    new prStr[256];
    prStr[0] = '\0';
    
    for(new i = 0; i < openCount; i++) {
        new tmp[16];
        if(i > 0) strcat(prStr, ",");
        format(tmp, sizeof(tmp), "%d", rewardIds[i]);
        strcat(prStr, tmp);
    }
    new jsonStr[512];
	format(jsonStr, sizeof(jsonStr), 
		"{\"t\":%d,\"s\":1,\"bc\":%d,\"pc\":%d,\"bcc\":%d,\"cs\":%d,\"type\":%d,\"pr\":[%s]}",
		CASES_TYPE_OPEN, GetPlayerDonateRub(playerid), GetPlayerDustValue(playerid), pCasesOpenedByCase[playerid][idx],
		pCasesSelected[playerid], openType, rewardIds[i]);
    
    SendPacketToClientString(playerid, GUICases, jsonStr);
    JSON_Cleanup(json);
    
    printf("[Cases] Player %d opened case %d, rewards: [%s]", playerid, caseId, prStr);
    Cases_SavePlayer(playerid);
    return 1;
}


stock Cases_TakeRewards(playerid, const jsonData[])
{
    new takeRewards[10], sprayRewards[10];
    new takeCount = Cases_ExtractIntArray(jsonData, "bt1", takeRewards, 10);
    new sprayCount = Cases_ExtractIntArray(jsonData, "bt2", sprayRewards, 10);
    new totalDustGained = 0;
    
    // Если клиент не отправил списки, но есть ожидающие награды - берём их
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
    
    // Распыление наград
    for(new i = 0; i < sprayCount; i++)
    {
        if(sprayRewards[i] > 0)
        {
            new dustAmount = Cases_SprayReward(playerid, sprayRewards[i]);
            if(dustAmount > 0)
            {
                totalDustGained += dustAmount;
            }
        }
    }
    
    // Очищаем ожидающие награды
    pCasesPendingCount[playerid] = 0;
    for(new i = 0; i < 10; i++) pCasesPendingRewards[playerid][i] = 0;
    
    // Проверяем обмен пыли на специальные кейсы
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
        JSON_Append(cc_array, cc_obj);
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


// ==========================================================================
// GUI ФУНКЦИИ
// ==========================================================================
stock Cases_ShowGUI(playerid) {
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][0]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", 0);
    
    new Node:cc_array = JSON_Array();
    for (new i = 1; i <= 5; i++) {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));
        JSON_Append(cc_array, cc_obj);
    }
    JSON_SetArray(json, "cc", cc_array);
    
    new Node:cbArray = JSON_Array();
    for (new c = 0; c < MAX_CASES; c++) {
        for (new b = 0; b < CaseData[c][cBonusCount]; b++) {
            new Node:bonusObj = JSON_Object();
            JSON_SetInt(bonusObj, "b", CaseBonus[c][b][bId]);
            JSON_SetInt(bonusObj, "state", Cases_GetBonusState(playerid, c, b));
            JSON_Append(cbArray, bonusObj);
        }
    }
    JSON_SetArray(json, "cb", cbArray);
    
    SendPacketToClient(playerid, GUICases, json);
    JSON_Cleanup(json);
    pCasesGUIOpen[playerid] = 1;
    return 1;
}

stock Cases_UpdateGUI(playerid) {
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][0]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    
    new Node:cc_array = JSON_Array();
    for (new i = 1; i <= 5; i++) {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));
        JSON_Append(cc_array, cc_obj);
    }
    JSON_SetArray(json, "cc", cc_array);
    
    new Node:cbArray = JSON_Array();
    for (new c = 0; c < MAX_CASES; c++) {
        for (new b = 0; b < CaseData[c][cBonusCount]; b++) {
            new Node:bonusObj = JSON_Object();
            JSON_SetInt(bonusObj, "b", CaseBonus[c][b][bId]);
            JSON_SetInt(bonusObj, "state", Cases_GetBonusState(playerid, c, b));
            JSON_Append(cbArray, bonusObj);
        }
    }
    JSON_SetArray(json, "cb", cbArray);
    
    SendPacketToClient(playerid, GUICases, json);
    JSON_Cleanup(json);
    return 1;
}

stock Cases_SelectCase(playerid, caseId) {
    pCasesSelected[playerid] = caseId;
    Cases_UpdateGUI(playerid);
    return 1;
}

// ==========================================================================
// ОБРАБОТКА ПАКЕТОВ ОТ КЛИЕНТА
// ==========================================================================
stock Cases_SendPacketToClient(playerid, const jsonData[]) {
    new Node:json;
    if(JSON_Parse(jsonData, json) != 0) return 0;
    
    new closeVal = 0;
    JSON_GetInt(json, "c", closeVal);
    if(closeVal == 1) {
        pCasesGUIOpen[playerid] = 0;
        JSON_Cleanup(json);
        return 1;
    }
    
    new actionType = 0;
    JSON_GetInt(json, "t", actionType);
    
    new currentTime = gettime();
    if(actionType == CASES_TYPE_OPEN && currentTime - pCasesLastAction[playerid] < 1) {
        JSON_Cleanup(json);
        return 0;
    }
    pCasesLastAction[playerid] = currentTime;
    
    switch(actionType) {
        case CASES_TYPE_SELECT: {
            new caseId = 0;
            JSON_GetInt(json, "cs", caseId);
            Cases_SelectCase(playerid, caseId);
        }
        case CASES_TYPE_OPEN: {
            new caseId = 0, openType = 0;
            JSON_GetInt(json, "cs", caseId);
            JSON_GetInt(json, "type", openType);
            Cases_OpenCase(playerid, caseId, openType);
        }
        case CASES_TYPE_TAKE_REWARDS: {
            Cases_TakeRewards(playerid, jsonData);
        }
        case CASES_TYPE_GO_DONATE: {
            new donateType = 0;
            JSON_GetInt(json, "d", donateType);
            if(donateType == 2) {
                SendClientMessage(playerid, 0xFFFF00FF, "Open donate shop to buy BC.");
            }
        }
        case CASES_TYPE_FROM_BANNER: {
            Cases_UpdateGUI(playerid);
        }
    }
    new debg[2054];
    JSON_Stringify(json, debg, sizeof(debg));
    printf("cases cases %s", debug);
    JSON_Cleanup(json);
    return 1;
}

// ==========================================================================
// ПОДКЛЮЧЕНИЕ ИГРОКА
// ==========================================================================
stock Cases_OnPlayerConnect(playerid) {
    pCasesDust[playerid] = 0;
    pCasesSelected[playerid] = 1;
    pCasesGUIOpen[playerid] = 0;
    pCasesLastAction[playerid] = 0;
    pCasesPendingCount[playerid] = 0;
    pCasesLastOpenedIdx[playerid] = 0;
    
    for(new i = 0; i < MAX_CASES; i++) {
        pCasesOpenedByCase[playerid][i] = 0;
    }
    for(new i = 0; i < 10; i++) {
        pCasesPendingRewards[playerid][i] = 0;
    }
    return 1;
}

// ==========================================================================
// КОМАНДЫ
// ==========================================================================
CMD:cases(playerid, params[]) {
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && 
       strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0 && 
       strcmp(GetPlayerNameEx(playerid), "Danya_Test", true) != 0) {
        SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа");
        return 1;
    }
    Cases_ShowGUI(playerid);
    return 1;
}

CMD:givecases(playerid, params[]) {
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

stock ResetPlayerCase(playerid)
{
    SetPlayerData(playerid, P_COUNT_TODAY_CASE, 0);
    SetPlayerData(playerid, P_COUNT_BOMJ_CASE, 0);
    SetPlayerData(playerid, P_COUNT_STANDART_CASE, 0);
    SetPlayerData(playerid, P_COUNT_CAR_CASE, 0);
    SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, 0);
}