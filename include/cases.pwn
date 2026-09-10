#if defined _DOXVARD_CASES_ONLY_INC
    #endinput
#endif
#define _DOXVARD_CASES_ONLY_INC

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

#define REWARD_TYPE_EXP         1
#define REWARD_TYPE_MONEY       2
#define REWARD_TYPE_BC          10
#define REWARD_TYPE_CASE        4
#define REWARD_TYPE_VEHICLE     5
#define REWARD_TYPE_VIP         9
#define REWARD_TYPE_BP_EXP      10
#define REWARD_TYPE_ITEM        11
#define REWARD_TYPE_DUST        21
#define REWARD_TYPE_EVENT_RES   23
#define REWARD_TYPE_SKIN        134

#define MAX_CASES               19
#define MAX_AWARDS_PER_CASE     40
#define MAX_BONUS_PER_CASE      5

// Индексы кейсов из cases.inc
#define CASE_DAILY_INDEX    0   // case_id = 1
#define CASE_BOMJ_INDEX     1   // case_id = 2
#define CASE_STANDART_INDEX 2   // case_id = 3
#define CASE_AUTO_INDEX     3   // case_id = 4
#define CASE_SPECIAL_INDEX  4   // case_id = 5
#define CASE_DRIVE_INDEX    5   // case_id = 8

enum E_CASE_AWARD {
    aId,
    aRarity,
    aType,
    aInternalId,
    aCount,
    aPriceSprayed,
    aSubcount
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


new pCasesDust[MAX_PLAYERS];
new pCasesOpened[MAX_PLAYERS];
new pCasesSelected[MAX_PLAYERS];
new pCasesTutorial[MAX_PLAYERS];
new pCasesCounts[MAX_PLAYERS][MAX_CASES];
new pCasesOpenedByCase[MAX_PLAYERS][MAX_CASES];
new pCasesBonusStatus[MAX_PLAYERS][MAX_CASES][MAX_BONUS_PER_CASE];
new pCasesGUIOpen[MAX_PLAYERS];
new pCasesLastAction[MAX_PLAYERS];
new pCasesLastOpenedIdx[MAX_PLAYERS];
new pCasesPendingRewards[MAX_PLAYERS][10];
new pCasesPendingCount[MAX_PLAYERS];

new CaseData[MAX_CASES][E_CASE_DATA];
new CaseAwards[MAX_CASES][MAX_AWARDS_PER_CASE][E_CASE_AWARD];
new CaseBonus[MAX_CASES][MAX_BONUS_PER_CASE][E_CASE_BONUS];

forward Cases_OnPlayerLoad(playerid);

stock Cases_SendPacket(playerid, guiid, Node:json)
{
    OnPacketIncoming(playerid, guiid, json);
    return 1;
}

stock GetPlayerDustValue(playerid)
{
    return GetPVarInt(playerid, "player_dust");
}

stock Cases_DBInit()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `player_cases` ( \
        `user_id` INT NOT NULL, \
        `dust` INT NOT NULL DEFAULT 0, \
        `opened_count` INT NOT NULL DEFAULT 0, \
        `selected_case` INT NOT NULL DEFAULT 1, \
        `tutorial` TINYINT NOT NULL DEFAULT 0, \
        `case_counts` TEXT, \
        `opened_by_case` TEXT, \
        `bonus_status` TEXT, \
        PRIMARY KEY (`user_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;"
    );
    return 1;
}

stock Cases_GiveDust(playerid, amount)
{
    if(amount <= 0) return 0;
    new dust = GetPlayerDustValue(playerid) + amount;
    SetPVarInt(playerid, "player_dust", dust);
    Cases_SavePlayer(playerid);
    return 1;
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
        case 8: return GetPlayerData(playerid, P_COUNT_CAR_CASE);
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
        case 8: return SetPlayerData(playerid, P_COUNT_CAR_CASE, value);
        default: return 0;
    }
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
}

stock Cases_AddToPlayer(playerid, caseIdx, amount)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(caseIdx < 0 || caseIdx >= MAX_CASES) return 0;
    if(amount <= 0) return 0;
    
    new case_id = CaseData[caseIdx][cId];
    AddPlayerCaseCountByType(playerid, case_id, amount);
    return 1;
}

stock Cases_GivePlayerCaseById(playerid, caseId, amount)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1) return 0;
    Cases_AddToPlayer(playerid, idx, amount);
    Cases_SavePlayer(playerid);
    if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
    return 1;
}

stock Cases_FindAwardById(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardRarity, &sprayPrice)
{
    new lastIdx = pCasesLastOpenedIdx[playerid];
    if(lastIdx >= 0 && lastIdx < MAX_CASES)
    {
        for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++)
        {
            if(CaseAwards[lastIdx][i][aId] == rewardId)
            {
                rewardType = CaseAwards[lastIdx][i][aType];
                rewardValue = CaseAwards[lastIdx][i][aInternalId];
                rewardCount = CaseAwards[lastIdx][i][aCount];
                rewardRarity = CaseAwards[lastIdx][i][aRarity];
                sprayPrice = CaseAwards[lastIdx][i][aPriceSprayed];
                return 1;
            }
        }
    }

    for(new c = 0; c < MAX_CASES; c++)
    {
        for(new i = 0; i < CaseData[c][cAwardsCount]; i++)
        {
            if(CaseAwards[c][i][aId] == rewardId)
            {
                rewardType = CaseAwards[c][i][aType];
                rewardValue = CaseAwards[c][i][aInternalId];
                rewardCount = CaseAwards[c][i][aCount];
                rewardRarity = CaseAwards[c][i][aRarity];
                sprayPrice = CaseAwards[c][i][aPriceSprayed];
                return 1;
            }
        }
    }
    return 0;
}

stock Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus)
{
    if(funcidx("Cases_OnRewardTaken") != -1)
    {
        CallLocalFunction("Cases_OnRewardTaken", "iiiiii", playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus);
        return 1;
    }

    printf("[Cases] WARNING: public Cases_OnRewardTaken(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus) is not implemented.");
    return 0;
}

stock Cases_Init()
{
    // Кейс 1 (Ежедневный) - соответствует CaseDailyAwards
    CaseData[CASE_DAILY_INDEX][cId] = 1;
    CaseData[CASE_DAILY_INDEX][cPriceOne] = 15;
    CaseData[CASE_DAILY_INDEX][cPriceTen] = 150;
    CaseData[CASE_DAILY_INDEX][cDiscountOne] = 0;
    CaseData[CASE_DAILY_INDEX][cDiscountTen] = 0;
    CaseData[CASE_DAILY_INDEX][cAwardsCount] = 20;
    CaseData[CASE_DAILY_INDEX][cBonusCount] = 5;
    Cases_InitCase1Awards();
    Cases_InitCase1Bonus();
    
    // Кейс 2 (Бомж) - соответствует CaseBomjAwards
    CaseData[CASE_BOMJ_INDEX][cId] = 2;
    CaseData[CASE_BOMJ_INDEX][cPriceOne] = 100;
    CaseData[CASE_BOMJ_INDEX][cPriceTen] = 1000;
    CaseData[CASE_BOMJ_INDEX][cDiscountOne] = 0;
    CaseData[CASE_BOMJ_INDEX][cDiscountTen] = 0;
    CaseData[CASE_BOMJ_INDEX][cAwardsCount] = 28;
    CaseData[CASE_BOMJ_INDEX][cBonusCount] = 5;
    Cases_InitCase2Awards();
    Cases_InitCase2Bonus();
    
    // Кейс 3 (Стандарт) - соответствует CaseStandartAwards
    CaseData[CASE_STANDART_INDEX][cId] = 3;
    CaseData[CASE_STANDART_INDEX][cPriceOne] = 700;
    CaseData[CASE_STANDART_INDEX][cPriceTen] = 7000;
    CaseData[CASE_STANDART_INDEX][cDiscountOne] = 0;
    CaseData[CASE_STANDART_INDEX][cDiscountTen] = 0;
    CaseData[CASE_STANDART_INDEX][cAwardsCount] = 37;
    CaseData[CASE_STANDART_INDEX][cBonusCount] = 5;
    Cases_InitCase3Awards();
    Cases_InitCase3Bonus();
    
    // Кейс 4 (Авто) - соответствует CaseAutoAwards
    CaseData[CASE_AUTO_INDEX][cId] = 4;
    CaseData[CASE_AUTO_INDEX][cPriceOne] = 1200;
    CaseData[CASE_AUTO_INDEX][cPriceTen] = 12000;
    CaseData[CASE_AUTO_INDEX][cDiscountOne] = 0;
    CaseData[CASE_AUTO_INDEX][cDiscountTen] = 5;
    CaseData[CASE_AUTO_INDEX][cAwardsCount] = 31;
    CaseData[CASE_AUTO_INDEX][cBonusCount] = 5;
    Cases_InitCase4Awards();
    Cases_InitCase4Bonus();
    
    // Кейс 5 (Особый) - соответствует CaseSpecialAwards
    CaseData[CASE_SPECIAL_INDEX][cId] = 5;
    CaseData[CASE_SPECIAL_INDEX][cPriceOne] = 10000;
    CaseData[CASE_SPECIAL_INDEX][cPriceTen] = 100000;
    CaseData[CASE_SPECIAL_INDEX][cDiscountOne] = 0;
    CaseData[CASE_SPECIAL_INDEX][cDiscountTen] = 0;
    CaseData[CASE_SPECIAL_INDEX][cAwardsCount] = 20;
    CaseData[CASE_SPECIAL_INDEX][cBonusCount] = 5;
    Cases_InitCase5Awards();
    Cases_InitCase5Bonus();

    // Кейс 8 (Драйв) - соответствует CaseDriveAwards
    CaseData[CASE_DRIVE_INDEX][cId] = 8;
    CaseData[CASE_DRIVE_INDEX][cPriceOne] = 900;
    CaseData[CASE_DRIVE_INDEX][cPriceTen] = 9000;
    CaseData[CASE_DRIVE_INDEX][cDiscountOne] = 0;
    CaseData[CASE_DRIVE_INDEX][cDiscountTen] = 5;
    CaseData[CASE_DRIVE_INDEX][cAwardsCount] = 25;
    CaseData[CASE_DRIVE_INDEX][cBonusCount] = 5;
    Cases_InitCase6Awards(); // Используем как CaseDriveAwards
    Cases_InitCase6Bonus();
    
    printf("[Cases] System initialized with %d cases", MAX_CASES);
    return 1;
}

stock Cases_GetIndex(caseId)
{
    for(new i = 0; i < MAX_CASES; i++) {
        if(CaseData[i][cId] == caseId) return i;
    }
    return -1;
}

stock Cases_OnPlayerConnect(playerid)
{
    SetPVarInt(playerid, "player_dust", 0);
    pCasesOpened[playerid] = 0;
    pCasesSelected[playerid] = 1;
    pCasesTutorial[playerid] = 0;
    pCasesGUIOpen[playerid] = 0;
    pCasesLastAction[playerid] = 0;
    pCasesPendingCount[playerid] = 0;
    pCasesLastOpenedIdx[playerid] = 0;
    
    for(new i = 0; i < MAX_CASES; i++) {
        pCasesOpenedByCase[playerid][i] = 0;
        for(new j = 0; j < MAX_BONUS_PER_CASE; j++) {
            pCasesBonusStatus[playerid][i][j] = 1;
        }
    }
    
    for(new i = 0; i < 10; i++) {
        pCasesPendingRewards[playerid][i] = 0;
    }
    
    return 1;
}

stock Cases_GetBonusState(playerid, caseIdx, bonusIdx)
{
    if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] == 3) {
        return 3;
    }
    
    new requiredOpens = CaseBonus[caseIdx][bonusIdx][bNumberOpen];
    if(pCasesOpenedByCase[playerid][caseIdx] >= requiredOpens) {
        if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] != 3) {
            return 2;
        }
    }
    
    return 1;
}

stock Cases_UpdateBonusStates(playerid, caseIdx)
{
    for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++) {
        if(pCasesBonusStatus[playerid][caseIdx][b] != 3) {
            new requiredOpens = CaseBonus[caseIdx][b][bNumberOpen];
            if(pCasesOpenedByCase[playerid][caseIdx] >= requiredOpens) {
                pCasesBonusStatus[playerid][caseIdx][b] = 2;
            } else {
                pCasesBonusStatus[playerid][caseIdx][b] = 1;
            }
        }
    }
}

stock Node:BuildCasesArray(playerid)
{
    new Node:cc_array = JSON_Array();
    
    // Кейсы 1-5 и 8 как в cases.inc
    new caseIds[] = {1, 2, 3, 4, 5, 8};
    
    for(new i = 0; i < sizeof(caseIds); i++)
    {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", caseIds[i]);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, caseIds[i]));
        
        new Node:tempArray = JSON_Array();
        JSON_Append(tempArray, cc_obj);
        JSON_Append(cc_array, tempArray);
    }
    
    return cc_array;
}

stock Cases_ShowGUI(playerid)
{
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = CASE_DAILY_INDEX;
    
    new Node:json = JSON_Object();
    
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetBool(json, "s", false);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", pCasesTutorial[playerid]);
    
    new Node:cc_array = BuildCasesArray(playerid);
    JSON_SetArray(json, "cc", cc_array);
    
    new Node:cbArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++) {
        for(new b = 0; b < CaseData[c][cBonusCount]; b++) {
            new Node:bonusObj = JSON_Object();
            JSON_SetInt(bonusObj, "b", CaseBonus[c][b][bId]);
            JSON_SetInt(bonusObj, "state", Cases_GetBonusState(playerid, c, b));
            JSON_Append(cbArray, bonusObj);
        }
    }
    JSON_SetArray(json, "cb", cbArray);
    
    OnPacketIncoming(playerid, GUICases, json);
    JSON_Cleanup(json);
    
    pCasesGUIOpen[playerid] = 1;
    return 1;
}

stock Cases_UpdateGUI(playerid)
{
    if(!pCasesGUIOpen[playerid]) return 0;
    
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = CASE_DAILY_INDEX;
    
    new Node:json = JSON_Object();
    
    JSON_SetInt(json, "t", 1);
    JSON_SetBool(json, "s", false);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", pCasesTutorial[playerid]);
    
    new Node:cc_array = BuildCasesArray(playerid);
    JSON_SetArray(json, "cc", cc_array);
    
    new Node:cbArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++) {
        for(new b = 0; b < CaseData[c][cBonusCount]; b++) {
            new Node:bonusObj = JSON_Object();
            JSON_SetInt(bonusObj, "b", CaseBonus[c][b][bId]);
            JSON_SetInt(bonusObj, "state", Cases_GetBonusState(playerid, c, b));
            JSON_Append(cbArray, bonusObj);
        }
    }
    JSON_SetArray(json, "cb", cbArray);
    
    OnPacketIncoming(playerid, GUICases, json);
    JSON_Cleanup(json);
    
    return 1;
}

stock Cases_HideGUI(playerid)
{
    if(!pCasesGUIOpen[playerid]) return 0;
    HidePlayerGUI(playerid, GUICases);
    pCasesGUIOpen[playerid] = 0;
    return 1;
}

stock Cases_ShowBanner(playerid, bannerId)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 2);
    JSON_SetInt(json, "s", 0);
    JSON_SetInt(json, "bid", bannerId);
    
    ShowPlayerGUI(playerid, GUICases, json);
    JSON_Cleanup(json);
    return 1;
}

stock Cases_OnPacketIncoming(playerid, const jsonData[])
{
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
    if(actionType == CASES_TYPE_OPEN || actionType == CASES_TYPE_OPEN_SUPER || actionType == CASES_TYPE_SELECT)
    {
        if(currentTime - pCasesLastAction[playerid] < 1)
        {
            JSON_Cleanup(json);
            return 0;
        }
        pCasesLastAction[playerid] = currentTime;
    }
    
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
            Cases_TakeRewards(playerid, json);
        }
        case CASES_TYPE_GO_DONATE: {
            new donateType = 0;
            JSON_GetInt(json, "d", donateType);
            if(donateType == 2) {
                SendClientMessage(playerid, 0xFFFF00FF, "Open donate shop to buy BC.");
            }
        }
        case CASES_TYPE_OPEN_SUPER: {
            Cases_OpenCase(playerid, 5, CASES_OPEN_ONE);
        }
        case CASES_TYPE_GET_BONUS: {
            new bonusId = 0;
            JSON_GetInt(json, "b", bonusId);
            Cases_GetBonus(playerid, bonusId);
        }
        case CASES_TYPE_FROM_BANNER: {
            Cases_UpdateGUI(playerid);
        }
    }
    
    JSON_Cleanup(json);
    return 1;
}

stock Cases_SelectCase(playerid, caseId)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1) return 0;

    pCasesSelected[playerid] = caseId;
    Cases_UpdateGUI(playerid);
    return 1;
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
    new useOwnedCases = 0;
    
    if(GetPlayerCaseCountByType(playerid, caseId) > 0) {
        if(GetPlayerCaseCountByType(playerid, caseId) < openCount) {
            new Node:json = JSON_Object();
            JSON_SetInt(json, "t", CASES_TYPE_OPEN);
            JSON_SetInt(json, "s", -1);
            JSON_SetInt(json, "d", 1);
            Cases_SendPacket(playerid, GUICases, json);
            JSON_Cleanup(json);
            return 0;
        }
        useOwnedCases = 1;
    }
    
    if(useOwnedCases) {
        AddPlayerCaseCountByType(playerid, caseId, -openCount);
    } else {
        new price = (openType == CASES_OPEN_ONE) ? CaseData[idx][cPriceOne] : CaseData[idx][cPriceTen];
        new discount = (openType == CASES_OPEN_ONE) ? CaseData[idx][cDiscountOne] : CaseData[idx][cDiscountTen];
        price = price - (price * discount / 100);
        
        if(GetPlayerDonateRub(playerid) < price) {
            new Node:json = JSON_Object();
            JSON_SetInt(json, "t", CASES_TYPE_OPEN);
            JSON_SetInt(json, "s", -1);
            JSON_SetInt(json, "d", 1);
            Cases_SendPacket(playerid, GUICases, json);
            JSON_Cleanup(json);
            return 0;
        }
        
        GivePlayerDonateRub(playerid, -price, "Cases: open", true, true);
    }
    
    for(new r = 0; r < openCount; r++) {
        rewardIds[r] = Cases_GetRandomReward(idx);
        pCasesPendingRewards[playerid][r] = rewardIds[r];
    }
    pCasesPendingCount[playerid] = openCount;
    
    pCasesOpened[playerid] += openCount;
    pCasesOpenedByCase[playerid][idx] += openCount;
    pCasesLastOpenedIdx[playerid] = idx;
    
    Cases_UpdateBonusStates(playerid, idx);
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", CASES_TYPE_OPEN);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][idx]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "type", openType);
    
    new Node:prArray = JSON_Array();
    for(new r = 0; r < openCount; r++) {
        new Node:rewardWrapper = JSON_Array();
        JSON_Append(rewardWrapper, JSON_Int(rewardIds[r]));
        JSON_Append(prArray, rewardWrapper);
    }
    JSON_SetArray(json, "pr", prArray);
    
    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);
    
    printf("[Cases] Player %d opened case %d, rewards count: %d", playerid, caseId, openCount);
    Cases_SavePlayer(playerid);
    return 1;
}

stock Cases_GetRandomReward(caseIdx)
{
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

stock Cases_CheckDustReward(playerid)
{
    new rewarded = 0;
    new specialIdx = Cases_GetIndex(5);
    if(specialIdx == -1) return 0;

    while(GetPlayerDustValue(playerid) >= 1500)
    {
        Cases_GiveDust(playerid, -1500);
        AddPlayerCaseCountByType(playerid, 5, 1);
        rewarded++;
    }

    if(rewarded > 0)
    {
        new str[96];
        format(str, sizeof(str), "Special cases received: %d", rewarded);
        SendClientMessage(playerid, 0xFFFF00FF, str);
        
        new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
        if(selectedIdx == -1) selectedIdx = specialIdx;
        
        new Node:json = JSON_Object();
        JSON_SetInt(json, "t", CASES_TYPE_OPEN_SUPER);
        JSON_SetInt(json, "s", 0);
        JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
        JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
        JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
        
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        
        if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
        Cases_SavePlayer(playerid);
        return 1;
    }
    return 0;
}

stock Cases_SprayReward(playerid, rewardId)
{
    new rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice;
    if(!Cases_FindAwardById(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice)) return 0;

    if(sprayPrice > 0)
    {
        Cases_GiveDust(playerid, sprayPrice);
        return sprayPrice;
    }
    return 0;
}

stock Cases_TakeRewards(playerid, Node:json)
{
    new takeCount = 0, sprayCount = 0;
    new takeRewards[10], sprayRewards[10];
    
    // Получаем массивы наград
    new Node:bt1_array;
    if(JSON_GetArray(json, "bt1", bt1_array))
    {
        new len;
        JSON_ArrayLength(bt1_array, len);
        for(new i = 0; i < len && i < 10; i++)
        {
            new Node:elem, rewardId;
            JSON_ArrayObject(bt1_array, i, elem);
            JSON_GetNodeInt(elem, rewardId);
            takeRewards[takeCount++] = rewardId;
        }
    }
    
    new Node:bt2_array;
    if(JSON_GetArray(json, "bt2", bt2_array))
    {
        new len;
        JSON_ArrayLength(bt2_array, len);
        for(new i = 0; i < len && i < 10; i++)
        {
            new Node:elem, rewardId;
            JSON_ArrayObject(bt2_array, i, elem);
            JSON_GetNodeInt(elem, rewardId);
            sprayRewards[sprayCount++] = rewardId;
        }
    }
    
    // Если нет данных в JSON, используем pending rewards
    if(takeCount == 0 && sprayCount == 0 && pCasesPendingCount[playerid] > 0)
    {
        for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
        {
            takeRewards[takeCount++] = pCasesPendingRewards[playerid][i];
        }
    }
    
    new totalDustGained = 0;
    
    // Обрабатываем взятие наград
    for(new i = 0; i < takeCount; i++)
    {
        if(takeRewards[i] <= 0) continue;
        
        new rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice;
        if(Cases_FindAwardById(playerid, takeRewards[i], rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice))
        {
            Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, 0);
        }
    }
    
    // Обрабатываем распыление
    for(new i = 0; i < sprayCount; i++)
    {
        if(sprayRewards[i] > 0) 
            totalDustGained += Cases_SprayReward(playerid, sprayRewards[i]);
    }
    
    Cases_CheckDustReward(playerid);
    
    // Очищаем pending rewards
    pCasesPendingCount[playerid] = 0;
    for(new i = 0; i < 10; i++) 
        pCasesPendingRewards[playerid][i] = 0;
    
    Cases_SavePlayer(playerid);
    
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = CASE_DAILY_INDEX;
    
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", CASES_TYPE_TAKE_REWARDS);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(response, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    
    Cases_SendPacket(playerid, GUICases, response);
    JSON_Cleanup(response);
    
    if(totalDustGained > 0)
    {
        new str[64];
        format(str, sizeof(str), "Dust received: %d", totalDustGained);
        SendClientMessage(playerid, 0xFFFF00FF, str);
    }
    return 1;
}

stock Cases_GetBonus(playerid, bonusId)
{
    new caseIdx = Cases_GetIndex(pCasesSelected[playerid]), bonusIdx = -1;
    if(caseIdx == -1) caseIdx = CASE_DAILY_INDEX;

    for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++)
    {
        if(CaseBonus[caseIdx][b][bId] == bonusId)
        {
            bonusIdx = b;
            break;
        }
    }

    if(bonusIdx == -1)
    {
        for(new c = 0; c < MAX_CASES; c++)
        {
            for(new b = 0; b < CaseData[c][cBonusCount]; b++)
            {
                if(CaseBonus[c][b][bId] == bonusId)
                {
                    caseIdx = c;
                    bonusIdx = b;
                    break;
                }
            }
            if(bonusIdx != -1) break;
        }
    }

    if(caseIdx == -1 || bonusIdx == -1)
    {
        new Node:json = JSON_Object();
        JSON_SetInt(json, "t", CASES_TYPE_GET_BONUS);
        JSON_SetInt(json, "s", 0);
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }

    if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] == 3)
    {
        new Node:json = JSON_Object();
        JSON_SetInt(json, "t", CASES_TYPE_GET_BONUS);
        JSON_SetInt(json, "s", 0);
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }

    new requiredOpens = CaseBonus[caseIdx][bonusIdx][bNumberOpen];
    if(pCasesOpenedByCase[playerid][caseIdx] < requiredOpens)
    {
        new Node:json = JSON_Object();
        JSON_SetInt(json, "t", CASES_TYPE_GET_BONUS);
        JSON_SetInt(json, "s", 0);
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }

    pCasesBonusStatus[playerid][caseIdx][bonusIdx] = 3;
    Cases_EmitReward(
        playerid,
        CaseBonus[caseIdx][bonusIdx][bType],
        CaseBonus[caseIdx][bonusIdx][bInternalId],
        CaseBonus[caseIdx][bonusIdx][bCount],
        CaseBonus[caseIdx][bonusIdx][bRarity],
        1
    );

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", CASES_TYPE_GET_BONUS);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][caseIdx]);
    
    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);

    Cases_SavePlayer(playerid);
    return 1;
}

// Инициализация наград из CaseDailyAwards (case_id = 1)
stock Cases_InitCase1Awards()
{
    // Данные из CaseDailyAwards в cases.inc
    CaseAwards[CASE_DAILY_INDEX][0][aId] = 1;   CaseAwards[CASE_DAILY_INDEX][0][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][0][aType] = 11; CaseAwards[CASE_DAILY_INDEX][0][aInternalId] = 23; 
    CaseAwards[CASE_DAILY_INDEX][0][aCount] = 1; CaseAwards[CASE_DAILY_INDEX][0][aPriceSprayed] = 10;
    
    CaseAwards[CASE_DAILY_INDEX][1][aId] = 2;   CaseAwards[CASE_DAILY_INDEX][1][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][1][aType] = 1; CaseAwards[CASE_DAILY_INDEX][1][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][1][aCount] = 2; CaseAwards[CASE_DAILY_INDEX][1][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][2][aId] = 3;   CaseAwards[CASE_DAILY_INDEX][2][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][2][aType] = 10; CaseAwards[CASE_DAILY_INDEX][2][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][2][aCount] = 200; CaseAwards[CASE_DAILY_INDEX][2][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][3][aId] = 4;   CaseAwards[CASE_DAILY_INDEX][3][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][3][aType] = 11; CaseAwards[CASE_DAILY_INDEX][3][aInternalId] = 21; 
    CaseAwards[CASE_DAILY_INDEX][3][aCount] = 1; CaseAwards[CASE_DAILY_INDEX][3][aPriceSprayed] = 10;
    
    CaseAwards[CASE_DAILY_INDEX][4][aId] = 5;   CaseAwards[CASE_DAILY_INDEX][4][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][4][aType] = 2; CaseAwards[CASE_DAILY_INDEX][4][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][4][aCount] = 4000; CaseAwards[CASE_DAILY_INDEX][4][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][5][aId] = 6;   CaseAwards[CASE_DAILY_INDEX][5][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][5][aType] = 10; CaseAwards[CASE_DAILY_INDEX][5][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][5][aCount] = 5; CaseAwards[CASE_DAILY_INDEX][5][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][6][aId] = 7;   CaseAwards[CASE_DAILY_INDEX][6][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][6][aType] = 2; CaseAwards[CASE_DAILY_INDEX][6][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][6][aCount] = 8000; CaseAwards[CASE_DAILY_INDEX][6][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][7][aId] = 8;   CaseAwards[CASE_DAILY_INDEX][7][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][7][aType] = 10; CaseAwards[CASE_DAILY_INDEX][7][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][7][aCount] = 10; CaseAwards[CASE_DAILY_INDEX][7][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][8][aId] = 9;   CaseAwards[CASE_DAILY_INDEX][8][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][8][aType] = 9; CaseAwards[CASE_DAILY_INDEX][8][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][8][aCount] = 2; CaseAwards[CASE_DAILY_INDEX][8][aPriceSprayed] = 10;
    
    CaseAwards[CASE_DAILY_INDEX][9][aId] = 10;  CaseAwards[CASE_DAILY_INDEX][9][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][9][aType] = 10; CaseAwards[CASE_DAILY_INDEX][9][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][9][aCount] = 400; CaseAwards[CASE_DAILY_INDEX][9][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][10][aId] = 11; CaseAwards[CASE_DAILY_INDEX][10][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][10][aType] = 1; CaseAwards[CASE_DAILY_INDEX][10][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][10][aCount] = 4; CaseAwards[CASE_DAILY_INDEX][10][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][11][aId] = 12; CaseAwards[CASE_DAILY_INDEX][11][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][11][aType] = 5; CaseAwards[CASE_DAILY_INDEX][11][aInternalId] = 462; 
    CaseAwards[CASE_DAILY_INDEX][11][aCount] = 0; CaseAwards[CASE_DAILY_INDEX][11][aPriceSprayed] = 20;
    
    CaseAwards[CASE_DAILY_INDEX][12][aId] = 13; CaseAwards[CASE_DAILY_INDEX][12][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][12][aType] = 10; CaseAwards[CASE_DAILY_INDEX][12][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][12][aCount] = 500; CaseAwards[CASE_DAILY_INDEX][12][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][13][aId] = 14; CaseAwards[CASE_DAILY_INDEX][13][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][13][aType] = 2; CaseAwards[CASE_DAILY_INDEX][13][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][13][aCount] = 20000; CaseAwards[CASE_DAILY_INDEX][13][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][14][aId] = 15; CaseAwards[CASE_DAILY_INDEX][14][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][14][aType] = 10; CaseAwards[CASE_DAILY_INDEX][14][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][14][aCount] = 15; CaseAwards[CASE_DAILY_INDEX][14][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][15][aId] = 16; CaseAwards[CASE_DAILY_INDEX][15][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][15][aType] = 9; CaseAwards[CASE_DAILY_INDEX][15][aInternalId] = 2; 
    CaseAwards[CASE_DAILY_INDEX][15][aCount] = 2; CaseAwards[CASE_DAILY_INDEX][15][aPriceSprayed] = 10;
    
    CaseAwards[CASE_DAILY_INDEX][16][aId] = 17; CaseAwards[CASE_DAILY_INDEX][16][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][16][aType] = 10; CaseAwards[CASE_DAILY_INDEX][16][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][16][aCount] = 600; CaseAwards[CASE_DAILY_INDEX][16][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][17][aId] = 18; CaseAwards[CASE_DAILY_INDEX][17][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][17][aType] = 2; CaseAwards[CASE_DAILY_INDEX][17][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][17][aCount] = 30000; CaseAwards[CASE_DAILY_INDEX][17][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][18][aId] = 19; CaseAwards[CASE_DAILY_INDEX][18][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][18][aType] = 1; CaseAwards[CASE_DAILY_INDEX][18][aInternalId] = 1; 
    CaseAwards[CASE_DAILY_INDEX][18][aCount] = 6; CaseAwards[CASE_DAILY_INDEX][18][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DAILY_INDEX][19][aId] = 20; CaseAwards[CASE_DAILY_INDEX][19][aRarity] = 1; 
    CaseAwards[CASE_DAILY_INDEX][19][aType] = 5; CaseAwards[CASE_DAILY_INDEX][19][aInternalId] = 549; 
    CaseAwards[CASE_DAILY_INDEX][19][aCount] = 0; CaseAwards[CASE_DAILY_INDEX][19][aPriceSprayed] = 20;
}

// Инициализация наград из CaseBomjAwards (case_id = 2)
stock Cases_InitCase2Awards()
{
    // Данные из CaseBomjAwards в cases.inc
    CaseAwards[CASE_BOMJ_INDEX][0][aId] = 1;   CaseAwards[CASE_BOMJ_INDEX][0][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][0][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][0][aInternalId] = 468; 
    CaseAwards[CASE_BOMJ_INDEX][0][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][0][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][1][aId] = 2;   CaseAwards[CASE_BOMJ_INDEX][1][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][1][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][1][aInternalId] = 496; 
    CaseAwards[CASE_BOMJ_INDEX][1][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][1][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][2][aId] = 3;   CaseAwards[CASE_BOMJ_INDEX][2][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][2][aType] = 2; CaseAwards[CASE_BOMJ_INDEX][2][aInternalId] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][2][aCount] = 75000; CaseAwards[CASE_BOMJ_INDEX][2][aPriceSprayed] = 0;
    
    CaseAwards[CASE_BOMJ_INDEX][3][aId] = 4;   CaseAwards[CASE_BOMJ_INDEX][3][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][3][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][3][aInternalId] = 404; 
    CaseAwards[CASE_BOMJ_INDEX][3][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][3][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][4][aId] = 5;   CaseAwards[CASE_BOMJ_INDEX][4][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][4][aType] = 1; CaseAwards[CASE_BOMJ_INDEX][4][aInternalId] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][4][aCount] = 12; CaseAwards[CASE_BOMJ_INDEX][4][aPriceSprayed] = 0;
    
    CaseAwards[CASE_BOMJ_INDEX][5][aId] = 6;   CaseAwards[CASE_BOMJ_INDEX][5][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][5][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][5][aInternalId] = 439; 
    CaseAwards[CASE_BOMJ_INDEX][5][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][5][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][6][aId] = 7;   CaseAwards[CASE_BOMJ_INDEX][6][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][6][aType] = 2; CaseAwards[CASE_BOMJ_INDEX][6][aInternalId] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][6][aCount] = 90000; CaseAwards[CASE_BOMJ_INDEX][6][aPriceSprayed] = 0;
    
    CaseAwards[CASE_BOMJ_INDEX][7][aId] = 8;   CaseAwards[CASE_BOMJ_INDEX][7][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][7][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][7][aInternalId] = 492; 
    CaseAwards[CASE_BOMJ_INDEX][7][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][7][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][8][aId] = 9;   CaseAwards[CASE_BOMJ_INDEX][8][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][8][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][8][aInternalId] = 547; 
    CaseAwards[CASE_BOMJ_INDEX][8][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][8][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][9][aId] = 10;  CaseAwards[CASE_BOMJ_INDEX][9][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][9][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][9][aInternalId] = 458; 
    CaseAwards[CASE_BOMJ_INDEX][9][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][9][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][10][aId] = 11; CaseAwards[CASE_BOMJ_INDEX][10][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][10][aType] = 9; CaseAwards[CASE_BOMJ_INDEX][10][aInternalId] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][10][aCount] = 168; CaseAwards[CASE_BOMJ_INDEX][10][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][11][aId] = 12; CaseAwards[CASE_BOMJ_INDEX][11][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][11][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][11][aInternalId] = 491; 
    CaseAwards[CASE_BOMJ_INDEX][11][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][11][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][12][aId] = 13; CaseAwards[CASE_BOMJ_INDEX][12][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][12][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][12][aInternalId] = 585; 
    CaseAwards[CASE_BOMJ_INDEX][12][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][12][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][13][aId] = 14; CaseAwards[CASE_BOMJ_INDEX][13][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][13][aType] = 1; CaseAwards[CASE_BOMJ_INDEX][13][aInternalId] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][13][aCount] = 16; CaseAwards[CASE_BOMJ_INDEX][13][aPriceSprayed] = 0;
    
    CaseAwards[CASE_BOMJ_INDEX][14][aId] = 15; CaseAwards[CASE_BOMJ_INDEX][14][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][14][aType] = 2; CaseAwards[CASE_BOMJ_INDEX][14][aInternalId] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][14][aCount] = 120000; CaseAwards[CASE_BOMJ_INDEX][14][aPriceSprayed] = 0;
    
    CaseAwards[CASE_BOMJ_INDEX][15][aId] = 16; CaseAwards[CASE_BOMJ_INDEX][15][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][15][aType] = 9; CaseAwards[CASE_BOMJ_INDEX][15][aInternalId] = 2; 
    CaseAwards[CASE_BOMJ_INDEX][15][aCount] = 72; CaseAwards[CASE_BOMJ_INDEX][15][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][16][aId] = 17; CaseAwards[CASE_BOMJ_INDEX][16][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][16][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][16][aInternalId] = 536; 
    CaseAwards[CASE_BOMJ_INDEX][16][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][16][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][17][aId] = 18; CaseAwards[CASE_BOMJ_INDEX][17][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][17][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][17][aInternalId] = 529; 
    CaseAwards[CASE_BOMJ_INDEX][17][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][17][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][18][aId] = 19; CaseAwards[CASE_BOMJ_INDEX][18][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][18][aType] = 9; CaseAwards[CASE_BOMJ_INDEX][18][aInternalId] = 3; 
    CaseAwards[CASE_BOMJ_INDEX][18][aCount] = 72; CaseAwards[CASE_BOMJ_INDEX][18][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][19][aId] = 20; CaseAwards[CASE_BOMJ_INDEX][19][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][19][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][19][aInternalId] = 542; 
    CaseAwards[CASE_BOMJ_INDEX][19][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][19][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][20][aId] = 21; CaseAwards[CASE_BOMJ_INDEX][20][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][20][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][20][aInternalId] = 421; 
    CaseAwards[CASE_BOMJ_INDEX][20][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][20][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][21][aId] = 22; CaseAwards[CASE_BOMJ_INDEX][21][aRarity] = 1; 
    CaseAwards[CASE_BOMJ_INDEX][21][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][21][aInternalId] = 2618; 
    CaseAwards[CASE_BOMJ_INDEX][21][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][21][aPriceSprayed] = 20;
    
    CaseAwards[CASE_BOMJ_INDEX][22][aId] = 23; CaseAwards[CASE_BOMJ_INDEX][22][aRarity] = 2; 
    CaseAwards[CASE_BOMJ_INDEX][22][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][22][aInternalId] = 2548; 
    CaseAwards[CASE_BOMJ_INDEX][22][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][22][aPriceSprayed] = 30;
    
    CaseAwards[CASE_BOMJ_INDEX][23][aId] = 24; CaseAwards[CASE_BOMJ_INDEX][23][aRarity] = 2; 
    CaseAwards[CASE_BOMJ_INDEX][23][aType] = 11; CaseAwards[CASE_BOMJ_INDEX][23][aInternalId] = 706; 
    CaseAwards[CASE_BOMJ_INDEX][23][aCount] = 1; CaseAwards[CASE_BOMJ_INDEX][23][aPriceSprayed] = 30;
    
    CaseAwards[CASE_BOMJ_INDEX][24][aId] = 25; CaseAwards[CASE_BOMJ_INDEX][24][aRarity] = 2; 
    CaseAwards[CASE_BOMJ_INDEX][24][aType] = 5; CaseAwards[CASE_BOMJ_INDEX][24][aInternalId] = 516; 
    CaseAwards[CASE_BOMJ_INDEX][24][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][24][aPriceSprayed] = 30;
    
    CaseAwards[CASE_BOMJ_INDEX][25][aId] = 26; CaseAwards[CASE_BOMJ_INDEX][25][aRarity] = 2; 
    CaseAwards[CASE_BOMJ_INDEX][25][aType] = 11; CaseAwards[CASE_BOMJ_INDEX][25][aInternalId] = 705; 
    CaseAwards[CASE_BOMJ_INDEX][25][aCount] = 1; CaseAwards[CASE_BOMJ_INDEX][25][aPriceSprayed] = 30;
    
    CaseAwards[CASE_BOMJ_INDEX][26][aId] = 27; CaseAwards[CASE_BOMJ_INDEX][26][aRarity] = 3; 
    CaseAwards[CASE_BOMJ_INDEX][26][aType] = 134; CaseAwards[CASE_BOMJ_INDEX][26][aInternalId] = 252; 
    CaseAwards[CASE_BOMJ_INDEX][26][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][26][aPriceSprayed] = 40;
    
    CaseAwards[CASE_BOMJ_INDEX][27][aId] = 28; CaseAwards[CASE_BOMJ_INDEX][27][aRarity] = 3; 
    CaseAwards[CASE_BOMJ_INDEX][27][aType] = 134; CaseAwards[CASE_BOMJ_INDEX][27][aInternalId] = 6810; 
    CaseAwards[CASE_BOMJ_INDEX][27][aCount] = 0; CaseAwards[CASE_BOMJ_INDEX][27][aPriceSprayed] = 40;
}

// Инициализация наград из CaseStandartAwards (case_id = 3)
stock Cases_InitCase3Awards()
{
    // Данные из CaseStandartAwards в cases.inc
    CaseAwards[CASE_STANDART_INDEX][0][aId] = 1;   CaseAwards[CASE_STANDART_INDEX][0][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][0][aType] = 11; CaseAwards[CASE_STANDART_INDEX][0][aInternalId] = 362; 
    CaseAwards[CASE_STANDART_INDEX][0][aCount] = 1; CaseAwards[CASE_STANDART_INDEX][0][aPriceSprayed] = 90;
    
    CaseAwards[CASE_STANDART_INDEX][1][aId] = 2;   CaseAwards[CASE_STANDART_INDEX][1][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][1][aType] = 9; CaseAwards[CASE_STANDART_INDEX][1][aInternalId] = 2; 
    CaseAwards[CASE_STANDART_INDEX][1][aCount] = 504; CaseAwards[CASE_STANDART_INDEX][1][aPriceSprayed] = 90;
    
    CaseAwards[CASE_STANDART_INDEX][2][aId] = 3;   CaseAwards[CASE_STANDART_INDEX][2][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][2][aType] = 2; CaseAwards[CASE_STANDART_INDEX][2][aInternalId] = 1; 
    CaseAwards[CASE_STANDART_INDEX][2][aCount] = 600000; CaseAwards[CASE_STANDART_INDEX][2][aPriceSprayed] = 0;
    
    CaseAwards[CASE_STANDART_INDEX][3][aId] = 4;   CaseAwards[CASE_STANDART_INDEX][3][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][3][aType] = 11; CaseAwards[CASE_STANDART_INDEX][3][aInternalId] = 360; 
    CaseAwards[CASE_STANDART_INDEX][3][aCount] = 1; CaseAwards[CASE_STANDART_INDEX][3][aPriceSprayed] = 90;
    
    CaseAwards[CASE_STANDART_INDEX][4][aId] = 5;   CaseAwards[CASE_STANDART_INDEX][4][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][4][aType] = 5; CaseAwards[CASE_STANDART_INDEX][4][aInternalId] = 527; 
    CaseAwards[CASE_STANDART_INDEX][4][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][4][aPriceSprayed] = 100;
    
    CaseAwards[CASE_STANDART_INDEX][5][aId] = 6;   CaseAwards[CASE_STANDART_INDEX][5][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][5][aType] = 134; CaseAwards[CASE_STANDART_INDEX][5][aInternalId] = 11962; 
    CaseAwards[CASE_STANDART_INDEX][5][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][5][aPriceSprayed] = 90;
    
    CaseAwards[CASE_STANDART_INDEX][6][aId] = 7;   CaseAwards[CASE_STANDART_INDEX][6][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][6][aType] = 10; CaseAwards[CASE_STANDART_INDEX][6][aInternalId] = 1; 
    CaseAwards[CASE_STANDART_INDEX][6][aCount] = 600; CaseAwards[CASE_STANDART_INDEX][6][aPriceSprayed] = 0;
    
    CaseAwards[CASE_STANDART_INDEX][7][aId] = 8;   CaseAwards[CASE_STANDART_INDEX][7][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][7][aType] = 9; CaseAwards[CASE_STANDART_INDEX][7][aInternalId] = 3; 
    CaseAwards[CASE_STANDART_INDEX][7][aCount] = 360; CaseAwards[CASE_STANDART_INDEX][7][aPriceSprayed] = 100;
    
    CaseAwards[CASE_STANDART_INDEX][8][aId] = 9;   CaseAwards[CASE_STANDART_INDEX][8][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][8][aType] = 5; CaseAwards[CASE_STANDART_INDEX][8][aInternalId] = 445; 
    CaseAwards[CASE_STANDART_INDEX][8][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][8][aPriceSprayed] = 100;
    
    CaseAwards[CASE_STANDART_INDEX][9][aId] = 10;  CaseAwards[CASE_STANDART_INDEX][9][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][9][aType] = 11; CaseAwards[CASE_STANDART_INDEX][9][aInternalId] = 583; 
    CaseAwards[CASE_STANDART_INDEX][9][aCount] = 1; CaseAwards[CASE_STANDART_INDEX][9][aPriceSprayed] = 100;
    
    CaseAwards[CASE_STANDART_INDEX][10][aId] = 11; CaseAwards[CASE_STANDART_INDEX][10][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][10][aType] = 134; CaseAwards[CASE_STANDART_INDEX][10][aInternalId] = 14388; 
    CaseAwards[CASE_STANDART_INDEX][10][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][10][aPriceSprayed] = 100;
    
    CaseAwards[CASE_STANDART_INDEX][11][aId] = 12; CaseAwards[CASE_STANDART_INDEX][11][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][11][aType] = 11; CaseAwards[CASE_STANDART_INDEX][11][aInternalId] = 508; 
    CaseAwards[CASE_STANDART_INDEX][11][aCount] = 1; CaseAwards[CASE_STANDART_INDEX][11][aPriceSprayed] = 100;
    
    CaseAwards[CASE_STANDART_INDEX][12][aId] = 13; CaseAwards[CASE_STANDART_INDEX][12][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][12][aType] = 134; CaseAwards[CASE_STANDART_INDEX][12][aInternalId] = 11917; 
    CaseAwards[CASE_STANDART_INDEX][12][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][12][aPriceSprayed] = 110;
    
    CaseAwards[CASE_STANDART_INDEX][13][aId] = 14; CaseAwards[CASE_STANDART_INDEX][13][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][13][aType] = 5; CaseAwards[CASE_STANDART_INDEX][13][aInternalId] = 589; 
    CaseAwards[CASE_STANDART_INDEX][13][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][13][aPriceSprayed] = 110;
    
    CaseAwards[CASE_STANDART_INDEX][14][aId] = 15; CaseAwards[CASE_STANDART_INDEX][14][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][14][aType] = 5; CaseAwards[CASE_STANDART_INDEX][14][aInternalId] = 2568; 
    CaseAwards[CASE_STANDART_INDEX][14][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][14][aPriceSprayed] = 110;
    
    CaseAwards[CASE_STANDART_INDEX][15][aId] = 16; CaseAwards[CASE_STANDART_INDEX][15][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][15][aType] = 5; CaseAwards[CASE_STANDART_INDEX][15][aInternalId] = 2385; 
    CaseAwards[CASE_STANDART_INDEX][15][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][15][aPriceSprayed] = 120;
    
    CaseAwards[CASE_STANDART_INDEX][16][aId] = 17; CaseAwards[CASE_STANDART_INDEX][16][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][16][aType] = 5; CaseAwards[CASE_STANDART_INDEX][16][aInternalId] = 2623; 
    CaseAwards[CASE_STANDART_INDEX][16][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][16][aPriceSprayed] = 120;
    
    CaseAwards[CASE_STANDART_INDEX][17][aId] = 18; CaseAwards[CASE_STANDART_INDEX][17][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][17][aType] = 5; CaseAwards[CASE_STANDART_INDEX][17][aInternalId] = 2627; 
    CaseAwards[CASE_STANDART_INDEX][17][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][17][aPriceSprayed] = 120;
    
    CaseAwards[CASE_STANDART_INDEX][18][aId] = 19; CaseAwards[CASE_STANDART_INDEX][18][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][18][aType] = 5; CaseAwards[CASE_STANDART_INDEX][18][aInternalId] = 461; 
    CaseAwards[CASE_STANDART_INDEX][18][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][18][aPriceSprayed] = 130;
    
    CaseAwards[CASE_STANDART_INDEX][19][aId] = 20; CaseAwards[CASE_STANDART_INDEX][19][aRarity] = 2; 
    CaseAwards[CASE_STANDART_INDEX][19][aType] = 2; CaseAwards[CASE_STANDART_INDEX][19][aInternalId] = 1; 
    CaseAwards[CASE_STANDART_INDEX][19][aCount] = 1000000; CaseAwards[CASE_STANDART_INDEX][19][aPriceSprayed] = 0;
    
    CaseAwards[CASE_STANDART_INDEX][20][aId] = 21; CaseAwards[CASE_STANDART_INDEX][20][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][20][aType] = 9; CaseAwards[CASE_STANDART_INDEX][20][aInternalId] = 3; 
    CaseAwards[CASE_STANDART_INDEX][20][aCount] = 720; CaseAwards[CASE_STANDART_INDEX][20][aPriceSprayed] = 130;
    
    CaseAwards[CASE_STANDART_INDEX][21][aId] = 22; CaseAwards[CASE_STANDART_INDEX][21][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][21][aType] = 134; CaseAwards[CASE_STANDART_INDEX][21][aInternalId] = 236; 
    CaseAwards[CASE_STANDART_INDEX][21][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][21][aPriceSprayed] = 130;
    
    CaseAwards[CASE_STANDART_INDEX][22][aId] = 23; CaseAwards[CASE_STANDART_INDEX][22][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][22][aType] = 5; CaseAwards[CASE_STANDART_INDEX][22][aInternalId] = 2567; 
    CaseAwards[CASE_STANDART_INDEX][22][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][22][aPriceSprayed] = 130;
    
    CaseAwards[CASE_STANDART_INDEX][23][aId] = 24; CaseAwards[CASE_STANDART_INDEX][23][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][23][aType] = 134; CaseAwards[CASE_STANDART_INDEX][23][aInternalId] = 11935; 
    CaseAwards[CASE_STANDART_INDEX][23][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][23][aPriceSprayed] = 140;
    
    CaseAwards[CASE_STANDART_INDEX][24][aId] = 25; CaseAwards[CASE_STANDART_INDEX][24][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][24][aType] = 5; CaseAwards[CASE_STANDART_INDEX][24][aInternalId] = 560; 
    CaseAwards[CASE_STANDART_INDEX][24][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][24][aPriceSprayed] = 140;
    
    CaseAwards[CASE_STANDART_INDEX][25][aId] = 26; CaseAwards[CASE_STANDART_INDEX][25][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][25][aType] = 134; CaseAwards[CASE_STANDART_INDEX][25][aInternalId] = 5323; 
    CaseAwards[CASE_STANDART_INDEX][25][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][25][aPriceSprayed] = 140;
    
    CaseAwards[CASE_STANDART_INDEX][26][aId] = 27; CaseAwards[CASE_STANDART_INDEX][26][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][26][aType] = 5; CaseAwards[CASE_STANDART_INDEX][26][aInternalId] = 2584; 
    CaseAwards[CASE_STANDART_INDEX][26][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][26][aPriceSprayed] = 150;
    
    CaseAwards[CASE_STANDART_INDEX][27][aId] = 28; CaseAwards[CASE_STANDART_INDEX][27][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][27][aType] = 5; CaseAwards[CASE_STANDART_INDEX][27][aInternalId] = 2390; 
    CaseAwards[CASE_STANDART_INDEX][27][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][27][aPriceSprayed] = 160;
    
    CaseAwards[CASE_STANDART_INDEX][28][aId] = 29; CaseAwards[CASE_STANDART_INDEX][28][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][28][aType] = 5; CaseAwards[CASE_STANDART_INDEX][28][aInternalId] = 543; 
    CaseAwards[CASE_STANDART_INDEX][28][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][28][aPriceSprayed] = 200;
    
    CaseAwards[CASE_STANDART_INDEX][29][aId] = 30; CaseAwards[CASE_STANDART_INDEX][29][aRarity] = 3; 
    CaseAwards[CASE_STANDART_INDEX][29][aType] = 5; CaseAwards[CASE_STANDART_INDEX][29][aInternalId] = 2394; 
    CaseAwards[CASE_STANDART_INDEX][29][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][29][aPriceSprayed] = 200;
    
    CaseAwards[CASE_STANDART_INDEX][30][aId] = 31; CaseAwards[CASE_STANDART_INDEX][30][aRarity] = 4; 
    CaseAwards[CASE_STANDART_INDEX][30][aType] = 11; CaseAwards[CASE_STANDART_INDEX][30][aInternalId] = 707; 
    CaseAwards[CASE_STANDART_INDEX][30][aCount] = 1; CaseAwards[CASE_STANDART_INDEX][30][aPriceSprayed] = 220;
    
    CaseAwards[CASE_STANDART_INDEX][31][aId] = 32; CaseAwards[CASE_STANDART_INDEX][31][aRarity] = 4; 
    CaseAwards[CASE_STANDART_INDEX][31][aType] = 5; CaseAwards[CASE_STANDART_INDEX][31][aInternalId] = 402; 
    CaseAwards[CASE_STANDART_INDEX][31][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][31][aPriceSprayed] = 240;
    
    CaseAwards[CASE_STANDART_INDEX][32][aId] = 33; CaseAwards[CASE_STANDART_INDEX][32][aRarity] = 4; 
    CaseAwards[CASE_STANDART_INDEX][32][aType] = 5; CaseAwards[CASE_STANDART_INDEX][32][aInternalId] = 2598; 
    CaseAwards[CASE_STANDART_INDEX][32][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][32][aPriceSprayed] = 250;
    
    CaseAwards[CASE_STANDART_INDEX][33][aId] = 34; CaseAwards[CASE_STANDART_INDEX][33][aRarity] = 4; 
    CaseAwards[CASE_STANDART_INDEX][33][aType] = 5; CaseAwards[CASE_STANDART_INDEX][33][aInternalId] = 400; 
    CaseAwards[CASE_STANDART_INDEX][33][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][33][aPriceSprayed] = 260;
    
    CaseAwards[CASE_STANDART_INDEX][34][aId] = 35; CaseAwards[CASE_STANDART_INDEX][34][aRarity] = 4; 
    CaseAwards[CASE_STANDART_INDEX][34][aType] = 5; CaseAwards[CASE_STANDART_INDEX][34][aInternalId] = 506; 
    CaseAwards[CASE_STANDART_INDEX][34][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][34][aPriceSprayed] = 270;
    
    CaseAwards[CASE_STANDART_INDEX][35][aId] = 36; CaseAwards[CASE_STANDART_INDEX][35][aRarity] = 5; 
    CaseAwards[CASE_STANDART_INDEX][35][aType] = 5; CaseAwards[CASE_STANDART_INDEX][35][aInternalId] = 415; 
    CaseAwards[CASE_STANDART_INDEX][35][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][35][aPriceSprayed] = 400;
    
    CaseAwards[CASE_STANDART_INDEX][36][aId] = 37; CaseAwards[CASE_STANDART_INDEX][36][aRarity] = 5; 
    CaseAwards[CASE_STANDART_INDEX][36][aType] = 5; CaseAwards[CASE_STANDART_INDEX][36][aInternalId] = 2543; 
    CaseAwards[CASE_STANDART_INDEX][36][aCount] = 0; CaseAwards[CASE_STANDART_INDEX][36][aPriceSprayed] = 400;
}

// Инициализация наград из CaseAutoAwards (case_id = 4)
stock Cases_InitCase4Awards()
{
    // Данные из CaseAutoAwards в cases.inc
    CaseAwards[CASE_AUTO_INDEX][0][aId] = 1;   CaseAwards[CASE_AUTO_INDEX][0][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][0][aType] = 5; CaseAwards[CASE_AUTO_INDEX][0][aInternalId] = 436; 
    CaseAwards[CASE_AUTO_INDEX][0][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][0][aPriceSprayed] = 130;
    
    CaseAwards[CASE_AUTO_INDEX][1][aId] = 2;   CaseAwards[CASE_AUTO_INDEX][1][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][1][aType] = 5; CaseAwards[CASE_AUTO_INDEX][1][aInternalId] = 2567; 
    CaseAwards[CASE_AUTO_INDEX][1][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][1][aPriceSprayed] = 130;
    
    CaseAwards[CASE_AUTO_INDEX][2][aId] = 3;   CaseAwards[CASE_AUTO_INDEX][2][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][2][aType] = 5; CaseAwards[CASE_AUTO_INDEX][2][aInternalId] = 560; 
    CaseAwards[CASE_AUTO_INDEX][2][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][2][aPriceSprayed] = 140;
    
    CaseAwards[CASE_AUTO_INDEX][3][aId] = 4;   CaseAwards[CASE_AUTO_INDEX][3][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][3][aType] = 5; CaseAwards[CASE_AUTO_INDEX][3][aInternalId] = 550; 
    CaseAwards[CASE_AUTO_INDEX][3][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][3][aPriceSprayed] = 140;
    
    CaseAwards[CASE_AUTO_INDEX][4][aId] = 5;   CaseAwards[CASE_AUTO_INDEX][4][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][4][aType] = 5; CaseAwards[CASE_AUTO_INDEX][4][aInternalId] = 2584; 
    CaseAwards[CASE_AUTO_INDEX][4][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][4][aPriceSprayed] = 150;
    
    CaseAwards[CASE_AUTO_INDEX][5][aId] = 6;   CaseAwards[CASE_AUTO_INDEX][5][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][5][aType] = 5; CaseAwards[CASE_AUTO_INDEX][5][aInternalId] = 603; 
    CaseAwards[CASE_AUTO_INDEX][5][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][5][aPriceSprayed] = 150;
    
    CaseAwards[CASE_AUTO_INDEX][6][aId] = 7;   CaseAwards[CASE_AUTO_INDEX][6][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][6][aType] = 5; CaseAwards[CASE_AUTO_INDEX][6][aInternalId] = 2552; 
    CaseAwards[CASE_AUTO_INDEX][6][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][6][aPriceSprayed] = 150;
    
    CaseAwards[CASE_AUTO_INDEX][7][aId] = 8;   CaseAwards[CASE_AUTO_INDEX][7][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][7][aType] = 5; CaseAwards[CASE_AUTO_INDEX][7][aInternalId] = 565; 
    CaseAwards[CASE_AUTO_INDEX][7][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][7][aPriceSprayed] = 150;
    
    CaseAwards[CASE_AUTO_INDEX][8][aId] = 9;   CaseAwards[CASE_AUTO_INDEX][8][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][8][aType] = 5; CaseAwards[CASE_AUTO_INDEX][8][aInternalId] = 2609; 
    CaseAwards[CASE_AUTO_INDEX][8][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][8][aPriceSprayed] = 160;
    
    CaseAwards[CASE_AUTO_INDEX][9][aId] = 10;  CaseAwards[CASE_AUTO_INDEX][9][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][9][aType] = 5; CaseAwards[CASE_AUTO_INDEX][9][aInternalId] = 2604; 
    CaseAwards[CASE_AUTO_INDEX][9][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][9][aPriceSprayed] = 160;
    
    CaseAwards[CASE_AUTO_INDEX][10][aId] = 11; CaseAwards[CASE_AUTO_INDEX][10][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][10][aType] = 5; CaseAwards[CASE_AUTO_INDEX][10][aInternalId] = 551; 
    CaseAwards[CASE_AUTO_INDEX][10][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][10][aPriceSprayed] = 160;
    
    CaseAwards[CASE_AUTO_INDEX][11][aId] = 12; CaseAwards[CASE_AUTO_INDEX][11][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][11][aType] = 5; CaseAwards[CASE_AUTO_INDEX][11][aInternalId] = 2390; 
    CaseAwards[CASE_AUTO_INDEX][11][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][11][aPriceSprayed] = 160;
    
    CaseAwards[CASE_AUTO_INDEX][12][aId] = 13; CaseAwards[CASE_AUTO_INDEX][12][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][12][aType] = 5; CaseAwards[CASE_AUTO_INDEX][12][aInternalId] = 526; 
    CaseAwards[CASE_AUTO_INDEX][12][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][12][aPriceSprayed] = 160;
    
    CaseAwards[CASE_AUTO_INDEX][13][aId] = 14; CaseAwards[CASE_AUTO_INDEX][13][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][13][aType] = 5; CaseAwards[CASE_AUTO_INDEX][13][aInternalId] = 2620; 
    CaseAwards[CASE_AUTO_INDEX][13][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][13][aPriceSprayed] = 170;
    
    CaseAwards[CASE_AUTO_INDEX][14][aId] = 15; CaseAwards[CASE_AUTO_INDEX][14][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][14][aType] = 5; CaseAwards[CASE_AUTO_INDEX][14][aInternalId] = 2594; 
    CaseAwards[CASE_AUTO_INDEX][14][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][14][aPriceSprayed] = 180;
    
    CaseAwards[CASE_AUTO_INDEX][15][aId] = 16; CaseAwards[CASE_AUTO_INDEX][15][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][15][aType] = 5; CaseAwards[CASE_AUTO_INDEX][15][aInternalId] = 2621; 
    CaseAwards[CASE_AUTO_INDEX][15][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][15][aPriceSprayed] = 180;
    
    CaseAwards[CASE_AUTO_INDEX][16][aId] = 17; CaseAwards[CASE_AUTO_INDEX][16][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][16][aType] = 5; CaseAwards[CASE_AUTO_INDEX][16][aInternalId] = 2387; 
    CaseAwards[CASE_AUTO_INDEX][16][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][16][aPriceSprayed] = 200;
    
    CaseAwards[CASE_AUTO_INDEX][17][aId] = 18; CaseAwards[CASE_AUTO_INDEX][17][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][17][aType] = 5; CaseAwards[CASE_AUTO_INDEX][17][aInternalId] = 480; 
    CaseAwards[CASE_AUTO_INDEX][17][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][17][aPriceSprayed] = 200;
    
    CaseAwards[CASE_AUTO_INDEX][18][aId] = 19; CaseAwards[CASE_AUTO_INDEX][18][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][18][aType] = 5; CaseAwards[CASE_AUTO_INDEX][18][aInternalId] = 2394; 
    CaseAwards[CASE_AUTO_INDEX][18][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][18][aPriceSprayed] = 200;
    
    CaseAwards[CASE_AUTO_INDEX][19][aId] = 20; CaseAwards[CASE_AUTO_INDEX][19][aRarity] = 3; 
    CaseAwards[CASE_AUTO_INDEX][19][aType] = 5; CaseAwards[CASE_AUTO_INDEX][19][aInternalId] = 558; 
    CaseAwards[CASE_AUTO_INDEX][19][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][19][aPriceSprayed] = 210;
    
    CaseAwards[CASE_AUTO_INDEX][20][aId] = 21; CaseAwards[CASE_AUTO_INDEX][20][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][20][aType] = 5; CaseAwards[CASE_AUTO_INDEX][20][aInternalId] = 402; 
    CaseAwards[CASE_AUTO_INDEX][20][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][20][aPriceSprayed] = 240;
    
    CaseAwards[CASE_AUTO_INDEX][21][aId] = 22; CaseAwards[CASE_AUTO_INDEX][21][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][21][aType] = 5; CaseAwards[CASE_AUTO_INDEX][21][aInternalId] = 2598; 
    CaseAwards[CASE_AUTO_INDEX][21][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][21][aPriceSprayed] = 250;
    
    CaseAwards[CASE_AUTO_INDEX][22][aId] = 23; CaseAwards[CASE_AUTO_INDEX][22][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][22][aType] = 5; CaseAwards[CASE_AUTO_INDEX][22][aInternalId] = 502; 
    CaseAwards[CASE_AUTO_INDEX][22][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][22][aPriceSprayed] = 260;
    
    CaseAwards[CASE_AUTO_INDEX][23][aId] = 24; CaseAwards[CASE_AUTO_INDEX][23][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][23][aType] = 5; CaseAwards[CASE_AUTO_INDEX][23][aInternalId] = 2596; 
    CaseAwards[CASE_AUTO_INDEX][23][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][23][aPriceSprayed] = 260;
    
    CaseAwards[CASE_AUTO_INDEX][24][aId] = 25; CaseAwards[CASE_AUTO_INDEX][24][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][24][aType] = 5; CaseAwards[CASE_AUTO_INDEX][24][aInternalId] = 400; 
    CaseAwards[CASE_AUTO_INDEX][24][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][24][aPriceSprayed] = 260;
    
    CaseAwards[CASE_AUTO_INDEX][25][aId] = 26; CaseAwards[CASE_AUTO_INDEX][25][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][25][aType] = 5; CaseAwards[CASE_AUTO_INDEX][25][aInternalId] = 604; 
    CaseAwards[CASE_AUTO_INDEX][25][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][25][aPriceSprayed] = 260;
    
    CaseAwards[CASE_AUTO_INDEX][26][aId] = 27; CaseAwards[CASE_AUTO_INDEX][26][aRarity] = 4; 
    CaseAwards[CASE_AUTO_INDEX][26][aType] = 5; CaseAwards[CASE_AUTO_INDEX][26][aInternalId] = 506; 
    CaseAwards[CASE_AUTO_INDEX][26][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][26][aPriceSprayed] = 270;
    
    CaseAwards[CASE_AUTO_INDEX][27][aId] = 28; CaseAwards[CASE_AUTO_INDEX][27][aRarity] = 5; 
    CaseAwards[CASE_AUTO_INDEX][27][aType] = 5; CaseAwards[CASE_AUTO_INDEX][27][aInternalId] = 415; 
    CaseAwards[CASE_AUTO_INDEX][27][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][27][aPriceSprayed] = 400;
    
    CaseAwards[CASE_AUTO_INDEX][28][aId] = 29; CaseAwards[CASE_AUTO_INDEX][28][aRarity] = 5; 
    CaseAwards[CASE_AUTO_INDEX][28][aType] = 5; CaseAwards[CASE_AUTO_INDEX][28][aInternalId] = 2543; 
    CaseAwards[CASE_AUTO_INDEX][28][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][28][aPriceSprayed] = 400;
    
    CaseAwards[CASE_AUTO_INDEX][29][aId] = 30; CaseAwards[CASE_AUTO_INDEX][29][aRarity] = 5; 
    CaseAwards[CASE_AUTO_INDEX][29][aType] = 5; CaseAwards[CASE_AUTO_INDEX][29][aInternalId] = 2558; 
    CaseAwards[CASE_AUTO_INDEX][29][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][29][aPriceSprayed] = 450;
    
    CaseAwards[CASE_AUTO_INDEX][30][aId] = 31; CaseAwards[CASE_AUTO_INDEX][30][aRarity] = 5; 
    CaseAwards[CASE_AUTO_INDEX][30][aType] = 5; CaseAwards[CASE_AUTO_INDEX][30][aInternalId] = 2573; 
    CaseAwards[CASE_AUTO_INDEX][30][aCount] = 0; CaseAwards[CASE_AUTO_INDEX][30][aPriceSprayed] = 430;
}

// Инициализация наград из CaseSpecialAwards (case_id = 5)
stock Cases_InitCase5Awards()
{
    // Данные из CaseSpecialAwards в cases.inc
    CaseAwards[CASE_SPECIAL_INDEX][0][aId] = 1;   CaseAwards[CASE_SPECIAL_INDEX][0][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][0][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][0][aInternalId] = 410; 
    CaseAwards[CASE_SPECIAL_INDEX][0][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][0][aPriceSprayed] = 230;
    
    CaseAwards[CASE_SPECIAL_INDEX][1][aId] = 2;   CaseAwards[CASE_SPECIAL_INDEX][1][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][1][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][1][aInternalId] = 604; 
    CaseAwards[CASE_SPECIAL_INDEX][1][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][1][aPriceSprayed] = 260;
    
    CaseAwards[CASE_SPECIAL_INDEX][2][aId] = 3;   CaseAwards[CASE_SPECIAL_INDEX][2][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][2][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][2][aInternalId] = 2389; 
    CaseAwards[CASE_SPECIAL_INDEX][2][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][2][aPriceSprayed] = 270;
    
    CaseAwards[CASE_SPECIAL_INDEX][3][aId] = 4;   CaseAwards[CASE_SPECIAL_INDEX][3][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][3][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][3][aInternalId] = 2574; 
    CaseAwards[CASE_SPECIAL_INDEX][3][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][3][aPriceSprayed] = 290;
    
    CaseAwards[CASE_SPECIAL_INDEX][4][aId] = 5;   CaseAwards[CASE_SPECIAL_INDEX][4][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][4][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][4][aInternalId] = 2586; 
    CaseAwards[CASE_SPECIAL_INDEX][4][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][4][aPriceSprayed] = 340;
    
    CaseAwards[CASE_SPECIAL_INDEX][5][aId] = 6;   CaseAwards[CASE_SPECIAL_INDEX][5][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][5][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][5][aInternalId] = 2593; 
    CaseAwards[CASE_SPECIAL_INDEX][5][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][5][aPriceSprayed] = 340;
    
    CaseAwards[CASE_SPECIAL_INDEX][6][aId] = 7;   CaseAwards[CASE_SPECIAL_INDEX][6][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][6][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][6][aInternalId] = 2585; 
    CaseAwards[CASE_SPECIAL_INDEX][6][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][6][aPriceSprayed] = 340;
    
    CaseAwards[CASE_SPECIAL_INDEX][7][aId] = 8;   CaseAwards[CASE_SPECIAL_INDEX][7][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][7][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][7][aInternalId] = 2551; 
    CaseAwards[CASE_SPECIAL_INDEX][7][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][7][aPriceSprayed] = 350;
    
    CaseAwards[CASE_SPECIAL_INDEX][8][aId] = 9;   CaseAwards[CASE_SPECIAL_INDEX][8][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][8][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][8][aInternalId] = 2549; 
    CaseAwards[CASE_SPECIAL_INDEX][8][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][8][aPriceSprayed] = 370;
    
    CaseAwards[CASE_SPECIAL_INDEX][9][aId] = 10;  CaseAwards[CASE_SPECIAL_INDEX][9][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][9][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][9][aInternalId] = 2393; 
    CaseAwards[CASE_SPECIAL_INDEX][9][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][9][aPriceSprayed] = 370;
    
    CaseAwards[CASE_SPECIAL_INDEX][10][aId] = 11; CaseAwards[CASE_SPECIAL_INDEX][10][aRarity] = 4; 
    CaseAwards[CASE_SPECIAL_INDEX][10][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][10][aInternalId] = 579; 
    CaseAwards[CASE_SPECIAL_INDEX][10][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][10][aPriceSprayed] = 370;
    
    CaseAwards[CASE_SPECIAL_INDEX][11][aId] = 12; CaseAwards[CASE_SPECIAL_INDEX][11][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][11][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][11][aInternalId] = 2619; 
    CaseAwards[CASE_SPECIAL_INDEX][11][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][11][aPriceSprayed] = 460;
    
    CaseAwards[CASE_SPECIAL_INDEX][12][aId] = 13; CaseAwards[CASE_SPECIAL_INDEX][12][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][12][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][12][aInternalId] = 2583; 
    CaseAwards[CASE_SPECIAL_INDEX][12][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][12][aPriceSprayed] = 530;
    
    CaseAwards[CASE_SPECIAL_INDEX][13][aId] = 14; CaseAwards[CASE_SPECIAL_INDEX][13][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][13][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][13][aInternalId] = 669; 
    CaseAwards[CASE_SPECIAL_INDEX][13][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][13][aPriceSprayed] = 570;
    
    CaseAwards[CASE_SPECIAL_INDEX][14][aId] = 15; CaseAwards[CASE_SPECIAL_INDEX][14][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][14][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][14][aInternalId] = 2564; 
    CaseAwards[CASE_SPECIAL_INDEX][14][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][14][aPriceSprayed] = 570;
    
    CaseAwards[CASE_SPECIAL_INDEX][15][aId] = 16; CaseAwards[CASE_SPECIAL_INDEX][15][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][15][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][15][aInternalId] = 2591; 
    CaseAwards[CASE_SPECIAL_INDEX][15][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][15][aPriceSprayed] = 670;
    
    CaseAwards[CASE_SPECIAL_INDEX][16][aId] = 17; CaseAwards[CASE_SPECIAL_INDEX][16][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][16][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][16][aInternalId] = 2601; 
    CaseAwards[CASE_SPECIAL_INDEX][16][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][16][aPriceSprayed] = 800;
    
    CaseAwards[CASE_SPECIAL_INDEX][17][aId] = 18; CaseAwards[CASE_SPECIAL_INDEX][17][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][17][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][17][aInternalId] = 667; 
    CaseAwards[CASE_SPECIAL_INDEX][17][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][17][aPriceSprayed] = 850;
    
    CaseAwards[CASE_SPECIAL_INDEX][18][aId] = 19; CaseAwards[CASE_SPECIAL_INDEX][18][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][18][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][18][aInternalId] = 666; 
    CaseAwards[CASE_SPECIAL_INDEX][18][aCount] = 0; CaseAwards[CASE_SPECIAL_INDEX][18][aPriceSprayed] = 900;
    
    CaseAwards[CASE_SPECIAL_INDEX][19][aId] = 20; CaseAwards[CASE_SPECIAL_INDEX][19][aRarity] = 5; 
    CaseAwards[CASE_SPECIAL_INDEX][19][aType] = 5; CaseAwards[CASE_SPECIAL_INDEX][19][aInternalId] = 466; 
    CaseAwards[CASE_SPECIAL_INDEX][19][aCount] = 1; CaseAwards[CASE_SPECIAL_INDEX][19][aPriceSprayed] = 900;
}

// Инициализация наград из CaseDriveAwards (case_id = 8)
stock Cases_InitCase6Awards()
{
    // Данные из CaseDriveAwards в cases.inc
    CaseAwards[CASE_DRIVE_INDEX][0][aId] = 1;   CaseAwards[CASE_DRIVE_INDEX][0][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][0][aType] = 134; CaseAwards[CASE_DRIVE_INDEX][0][aInternalId] = 14386; 
    CaseAwards[CASE_DRIVE_INDEX][0][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][0][aPriceSprayed] = 100;
    
    CaseAwards[CASE_DRIVE_INDEX][1][aId] = 2;   CaseAwards[CASE_DRIVE_INDEX][1][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][1][aType] = 11; CaseAwards[CASE_DRIVE_INDEX][1][aInternalId] = 360; 
    CaseAwards[CASE_DRIVE_INDEX][1][aCount] = 1; CaseAwards[CASE_DRIVE_INDEX][1][aPriceSprayed] = 100;
    
    CaseAwards[CASE_DRIVE_INDEX][2][aId] = 3;   CaseAwards[CASE_DRIVE_INDEX][2][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][2][aType] = 11; CaseAwards[CASE_DRIVE_INDEX][2][aInternalId] = 946; 
    CaseAwards[CASE_DRIVE_INDEX][2][aCount] = 1; CaseAwards[CASE_DRIVE_INDEX][2][aPriceSprayed] = 120;
    
    CaseAwards[CASE_DRIVE_INDEX][3][aId] = 4;   CaseAwards[CASE_DRIVE_INDEX][3][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][3][aType] = 11; CaseAwards[CASE_DRIVE_INDEX][3][aInternalId] = 511; 
    CaseAwards[CASE_DRIVE_INDEX][3][aCount] = 1; CaseAwards[CASE_DRIVE_INDEX][3][aPriceSprayed] = 100;
    
    CaseAwards[CASE_DRIVE_INDEX][4][aId] = 5;   CaseAwards[CASE_DRIVE_INDEX][4][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][4][aType] = 11; CaseAwards[CASE_DRIVE_INDEX][4][aInternalId] = 945; 
    CaseAwards[CASE_DRIVE_INDEX][4][aCount] = 1; CaseAwards[CASE_DRIVE_INDEX][4][aPriceSprayed] = 100;
    
    CaseAwards[CASE_DRIVE_INDEX][5][aId] = 6;   CaseAwards[CASE_DRIVE_INDEX][5][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][5][aType] = 10; CaseAwards[CASE_DRIVE_INDEX][5][aInternalId] = 1; 
    CaseAwards[CASE_DRIVE_INDEX][5][aCount] = 700; CaseAwards[CASE_DRIVE_INDEX][5][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DRIVE_INDEX][6][aId] = 7;   CaseAwards[CASE_DRIVE_INDEX][6][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][6][aType] = 10; CaseAwards[CASE_DRIVE_INDEX][6][aInternalId] = 1; 
    CaseAwards[CASE_DRIVE_INDEX][6][aCount] = 7000; CaseAwards[CASE_DRIVE_INDEX][6][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DRIVE_INDEX][7][aId] = 8;   CaseAwards[CASE_DRIVE_INDEX][7][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][7][aType] = 134; CaseAwards[CASE_DRIVE_INDEX][7][aInternalId] = 11917; 
    CaseAwards[CASE_DRIVE_INDEX][7][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][7][aPriceSprayed] = 110;
    
    CaseAwards[CASE_DRIVE_INDEX][8][aId] = 9;   CaseAwards[CASE_DRIVE_INDEX][8][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][8][aType] = 23; CaseAwards[CASE_DRIVE_INDEX][8][aInternalId] = 1; 
    CaseAwards[CASE_DRIVE_INDEX][8][aCount] = 3000; CaseAwards[CASE_DRIVE_INDEX][8][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DRIVE_INDEX][9][aId] = 10;  CaseAwards[CASE_DRIVE_INDEX][9][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][9][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][9][aInternalId] = 2568; 
    CaseAwards[CASE_DRIVE_INDEX][9][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][9][aPriceSprayed] = 110;
    
    CaseAwards[CASE_DRIVE_INDEX][10][aId] = 11; CaseAwards[CASE_DRIVE_INDEX][10][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][10][aType] = 11; CaseAwards[CASE_DRIVE_INDEX][10][aInternalId] = 944; 
    CaseAwards[CASE_DRIVE_INDEX][10][aCount] = 1; CaseAwards[CASE_DRIVE_INDEX][10][aPriceSprayed] = 140;
    
    CaseAwards[CASE_DRIVE_INDEX][11][aId] = 12; CaseAwards[CASE_DRIVE_INDEX][11][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][11][aType] = 134; CaseAwards[CASE_DRIVE_INDEX][11][aInternalId] = 5885; 
    CaseAwards[CASE_DRIVE_INDEX][11][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][11][aPriceSprayed] = 140;
    
    CaseAwards[CASE_DRIVE_INDEX][12][aId] = 13; CaseAwards[CASE_DRIVE_INDEX][12][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][12][aType] = 134; CaseAwards[CASE_DRIVE_INDEX][12][aInternalId] = 5326; 
    CaseAwards[CASE_DRIVE_INDEX][12][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][12][aPriceSprayed] = 130;
    
    CaseAwards[CASE_DRIVE_INDEX][13][aId] = 14; CaseAwards[CASE_DRIVE_INDEX][13][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][13][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][13][aInternalId] = 603; 
    CaseAwards[CASE_DRIVE_INDEX][13][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][13][aPriceSprayed] = 140;
    
    CaseAwards[CASE_DRIVE_INDEX][14][aId] = 15; CaseAwards[CASE_DRIVE_INDEX][14][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][14][aType] = 23; CaseAwards[CASE_DRIVE_INDEX][14][aInternalId] = 1; 
    CaseAwards[CASE_DRIVE_INDEX][14][aCount] = 7500; CaseAwards[CASE_DRIVE_INDEX][14][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DRIVE_INDEX][15][aId] = 16; CaseAwards[CASE_DRIVE_INDEX][15][aRarity] = 3; 
    CaseAwards[CASE_DRIVE_INDEX][15][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][15][aInternalId] = 442; 
    CaseAwards[CASE_DRIVE_INDEX][15][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][15][aPriceSprayed] = 170;
    
    CaseAwards[CASE_DRIVE_INDEX][16][aId] = 17; CaseAwards[CASE_DRIVE_INDEX][16][aRarity] = 2; 
    CaseAwards[CASE_DRIVE_INDEX][16][aType] = 23; CaseAwards[CASE_DRIVE_INDEX][16][aInternalId] = 1; 
    CaseAwards[CASE_DRIVE_INDEX][16][aCount] = 5000; CaseAwards[CASE_DRIVE_INDEX][16][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DRIVE_INDEX][17][aId] = 18; CaseAwards[CASE_DRIVE_INDEX][17][aRarity] = 3; 
    CaseAwards[CASE_DRIVE_INDEX][17][aType] = 134; CaseAwards[CASE_DRIVE_INDEX][17][aInternalId] = 5884; 
    CaseAwards[CASE_DRIVE_INDEX][17][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][17][aPriceSprayed] = 160;
    
    CaseAwards[CASE_DRIVE_INDEX][18][aId] = 19; CaseAwards[CASE_DRIVE_INDEX][18][aRarity] = 3; 
    CaseAwards[CASE_DRIVE_INDEX][18][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][18][aInternalId] = 503; 
    CaseAwards[CASE_DRIVE_INDEX][18][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][18][aPriceSprayed] = 230;
    
    CaseAwards[CASE_DRIVE_INDEX][19][aId] = 20; CaseAwards[CASE_DRIVE_INDEX][19][aRarity] = 3; 
    CaseAwards[CASE_DRIVE_INDEX][19][aType] = 23; CaseAwards[CASE_DRIVE_INDEX][19][aInternalId] = 1; 
    CaseAwards[CASE_DRIVE_INDEX][19][aCount] = 15000; CaseAwards[CASE_DRIVE_INDEX][19][aPriceSprayed] = 0;
    
    CaseAwards[CASE_DRIVE_INDEX][20][aId] = 21; CaseAwards[CASE_DRIVE_INDEX][20][aRarity] = 3; 
    CaseAwards[CASE_DRIVE_INDEX][20][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][20][aInternalId] = 2603; 
    CaseAwards[CASE_DRIVE_INDEX][20][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][20][aPriceSprayed] = 250;
    
    CaseAwards[CASE_DRIVE_INDEX][21][aId] = 22; CaseAwards[CASE_DRIVE_INDEX][21][aRarity] = 4; 
    CaseAwards[CASE_DRIVE_INDEX][21][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][21][aInternalId] = 502; 
    CaseAwards[CASE_DRIVE_INDEX][21][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][21][aPriceSprayed] = 260;
    
    CaseAwards[CASE_DRIVE_INDEX][22][aId] = 23; CaseAwards[CASE_DRIVE_INDEX][22][aRarity] = 4; 
    CaseAwards[CASE_DRIVE_INDEX][22][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][22][aInternalId] = 2599; 
    CaseAwards[CASE_DRIVE_INDEX][22][aCount] = 0; CaseAwards[CASE_DRIVE_INDEX][22][aPriceSprayed] = 340;
    
    CaseAwards[CASE_DRIVE_INDEX][23][aId] = 24; CaseAwards[CASE_DRIVE_INDEX][23][aRarity] = 3; 
    CaseAwards[CASE_DRIVE_INDEX][23][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][23][aInternalId] = 659; 
    CaseAwards[CASE_DRIVE_INDEX][23][aCount] = 48; CaseAwards[CASE_DRIVE_INDEX][23][aPriceSprayed] = 180;
    
    CaseAwards[CASE_DRIVE_INDEX][24][aId] = 25; CaseAwards[CASE_DRIVE_INDEX][24][aRarity] = 5; 
    CaseAwards[CASE_DRIVE_INDEX][24][aType] = 5; CaseAwards[CASE_DRIVE_INDEX][24][aInternalId] = 661; 
    CaseAwards[CASE_DRIVE_INDEX][24][aCount] = 49; CaseAwards[CASE_DRIVE_INDEX][24][aPriceSprayed] = 490;
}

// Инициализация бонусов для кейсов
stock Cases_InitCase1Bonus()
{
    CaseBonus[CASE_DAILY_INDEX][0][bId]=101; CaseBonus[CASE_DAILY_INDEX][0][bNumberOpen]=40; CaseBonus[CASE_DAILY_INDEX][0][bRarity]=4; 
    CaseBonus[CASE_DAILY_INDEX][0][bType]=4; CaseBonus[CASE_DAILY_INDEX][0][bInternalId]=3; CaseBonus[CASE_DAILY_INDEX][0][bCount]=1; 
    CaseBonus[CASE_DAILY_INDEX][0][bPriceSprayed]=0;
    
    CaseBonus[CASE_DAILY_INDEX][1][bId]=102; CaseBonus[CASE_DAILY_INDEX][1][bNumberOpen]=30; CaseBonus[CASE_DAILY_INDEX][1][bRarity]=3; 
    CaseBonus[CASE_DAILY_INDEX][1][bType]=21; CaseBonus[CASE_DAILY_INDEX][1][bInternalId]=1; CaseBonus[CASE_DAILY_INDEX][1][bCount]=50; 
    CaseBonus[CASE_DAILY_INDEX][1][bPriceSprayed]=0;
    
    CaseBonus[CASE_DAILY_INDEX][2][bId]=103; CaseBonus[CASE_DAILY_INDEX][2][bNumberOpen]=20; CaseBonus[CASE_DAILY_INDEX][2][bRarity]=2; 
    CaseBonus[CASE_DAILY_INDEX][2][bType]=4; CaseBonus[CASE_DAILY_INDEX][2][bInternalId]=2; CaseBonus[CASE_DAILY_INDEX][2][bCount]=1; 
    CaseBonus[CASE_DAILY_INDEX][2][bPriceSprayed]=0;
    
    CaseBonus[CASE_DAILY_INDEX][3][bId]=104; CaseBonus[CASE_DAILY_INDEX][3][bNumberOpen]=10; CaseBonus[CASE_DAILY_INDEX][3][bRarity]=1; 
    CaseBonus[CASE_DAILY_INDEX][3][bType]=4; CaseBonus[CASE_DAILY_INDEX][3][bInternalId]=1; CaseBonus[CASE_DAILY_INDEX][3][bCount]=2; 
    CaseBonus[CASE_DAILY_INDEX][3][bPriceSprayed]=0;
    
    CaseBonus[CASE_DAILY_INDEX][4][bId]=105; CaseBonus[CASE_DAILY_INDEX][4][bNumberOpen]=5; CaseBonus[CASE_DAILY_INDEX][4][bRarity]=1; 
    CaseBonus[CASE_DAILY_INDEX][4][bType]=4; CaseBonus[CASE_DAILY_INDEX][4][bInternalId]=1; CaseBonus[CASE_DAILY_INDEX][4][bCount]=1; 
    CaseBonus[CASE_DAILY_INDEX][4][bPriceSprayed]=0;
}

stock Cases_InitCase2Bonus()
{
    CaseBonus[CASE_BOMJ_INDEX][0][bId]=201; CaseBonus[CASE_BOMJ_INDEX][0][bNumberOpen]=40; CaseBonus[CASE_BOMJ_INDEX][0][bRarity]=5; 
    CaseBonus[CASE_BOMJ_INDEX][0][bType]=5; CaseBonus[CASE_BOMJ_INDEX][0][bInternalId]=467; CaseBonus[CASE_BOMJ_INDEX][0][bCount]=0; 
    CaseBonus[CASE_BOMJ_INDEX][0][bPriceSprayed]=100;
    
    CaseBonus[CASE_BOMJ_INDEX][1][bId]=202; CaseBonus[CASE_BOMJ_INDEX][1][bNumberOpen]=30; CaseBonus[CASE_BOMJ_INDEX][1][bRarity]=3; 
    CaseBonus[CASE_BOMJ_INDEX][1][bType]=21; CaseBonus[CASE_BOMJ_INDEX][1][bInternalId]=1; CaseBonus[CASE_BOMJ_INDEX][1][bCount]=100; 
    CaseBonus[CASE_BOMJ_INDEX][1][bPriceSprayed]=0;
    
    CaseBonus[CASE_BOMJ_INDEX][2][bId]=203; CaseBonus[CASE_BOMJ_INDEX][2][bNumberOpen]=20; CaseBonus[CASE_BOMJ_INDEX][2][bRarity]=3; 
    CaseBonus[CASE_BOMJ_INDEX][2][bType]=4; CaseBonus[CASE_BOMJ_INDEX][2][bInternalId]=2; CaseBonus[CASE_BOMJ_INDEX][2][bCount]=2; 
    CaseBonus[CASE_BOMJ_INDEX][2][bPriceSprayed]=0;
    
    CaseBonus[CASE_BOMJ_INDEX][3][bId]=204; CaseBonus[CASE_BOMJ_INDEX][3][bNumberOpen]=10; CaseBonus[CASE_BOMJ_INDEX][3][bRarity]=3; 
    CaseBonus[CASE_BOMJ_INDEX][3][bType]=21; CaseBonus[CASE_BOMJ_INDEX][3][bInternalId]=1; CaseBonus[CASE_BOMJ_INDEX][3][bCount]=50; 
    CaseBonus[CASE_BOMJ_INDEX][3][bPriceSprayed]=0;
    
    CaseBonus[CASE_BOMJ_INDEX][4][bId]=205; CaseBonus[CASE_BOMJ_INDEX][4][bNumberOpen]=5; CaseBonus[CASE_BOMJ_INDEX][4][bRarity]=3; 
    CaseBonus[CASE_BOMJ_INDEX][4][bType]=4; CaseBonus[CASE_BOMJ_INDEX][4][bInternalId]=2; CaseBonus[CASE_BOMJ_INDEX][4][bCount]=1; 
    CaseBonus[CASE_BOMJ_INDEX][4][bPriceSprayed]=0;
}

stock Cases_InitCase3Bonus()
{
    CaseBonus[CASE_STANDART_INDEX][0][bId]=301; CaseBonus[CASE_STANDART_INDEX][0][bNumberOpen]=40; CaseBonus[CASE_STANDART_INDEX][0][bRarity]=5; 
    CaseBonus[CASE_STANDART_INDEX][0][bType]=5; CaseBonus[CASE_STANDART_INDEX][0][bInternalId]=2581; CaseBonus[CASE_STANDART_INDEX][0][bCount]=0; 
    CaseBonus[CASE_STANDART_INDEX][0][bPriceSprayed]=400;
    
    CaseBonus[CASE_STANDART_INDEX][1][bId]=302; CaseBonus[CASE_STANDART_INDEX][1][bNumberOpen]=30; CaseBonus[CASE_STANDART_INDEX][1][bRarity]=4; 
    CaseBonus[CASE_STANDART_INDEX][1][bType]=21; CaseBonus[CASE_STANDART_INDEX][1][bInternalId]=1; CaseBonus[CASE_STANDART_INDEX][1][bCount]=250; 
    CaseBonus[CASE_STANDART_INDEX][1][bPriceSprayed]=0;
    
    CaseBonus[CASE_STANDART_INDEX][2][bId]=303; CaseBonus[CASE_STANDART_INDEX][2][bNumberOpen]=20; CaseBonus[CASE_STANDART_INDEX][2][bRarity]=4; 
    CaseBonus[CASE_STANDART_INDEX][2][bType]=4; CaseBonus[CASE_STANDART_INDEX][2][bInternalId]=3; CaseBonus[CASE_STANDART_INDEX][2][bCount]=2; 
    CaseBonus[CASE_STANDART_INDEX][2][bPriceSprayed]=0;
    
    CaseBonus[CASE_STANDART_INDEX][3][bId]=304; CaseBonus[CASE_STANDART_INDEX][3][bNumberOpen]=10; CaseBonus[CASE_STANDART_INDEX][3][bRarity]=3; 
    CaseBonus[CASE_STANDART_INDEX][3][bType]=21; CaseBonus[CASE_STANDART_INDEX][3][bInternalId]=1; CaseBonus[CASE_STANDART_INDEX][3][bCount]=150; 
    CaseBonus[CASE_STANDART_INDEX][3][bPriceSprayed]=0;
    
    CaseBonus[CASE_STANDART_INDEX][4][bId]=305; CaseBonus[CASE_STANDART_INDEX][4][bNumberOpen]=5; CaseBonus[CASE_STANDART_INDEX][4][bRarity]=4; 
    CaseBonus[CASE_STANDART_INDEX][4][bType]=4; CaseBonus[CASE_STANDART_INDEX][4][bInternalId]=3; CaseBonus[CASE_STANDART_INDEX][4][bCount]=1; 
    CaseBonus[CASE_STANDART_INDEX][4][bPriceSprayed]=0;
}

stock Cases_InitCase4Bonus()
{
    CaseBonus[CASE_AUTO_INDEX][0][bId]=401; CaseBonus[CASE_AUTO_INDEX][0][bNumberOpen]=40; CaseBonus[CASE_AUTO_INDEX][0][bRarity]=5; 
    CaseBonus[CASE_AUTO_INDEX][0][bType]=5; CaseBonus[CASE_AUTO_INDEX][0][bInternalId]=668; CaseBonus[CASE_AUTO_INDEX][0][bCount]=0; 
    CaseBonus[CASE_AUTO_INDEX][0][bPriceSprayed]=500;
    
    CaseBonus[CASE_AUTO_INDEX][1][bId]=402; CaseBonus[CASE_AUTO_INDEX][1][bNumberOpen]=30; CaseBonus[CASE_AUTO_INDEX][1][bRarity]=4; 
    CaseBonus[CASE_AUTO_INDEX][1][bType]=21; CaseBonus[CASE_AUTO_INDEX][1][bInternalId]=1; CaseBonus[CASE_AUTO_INDEX][1][bCount]=500; 
    CaseBonus[CASE_AUTO_INDEX][1][bPriceSprayed]=0;
    
    CaseBonus[CASE_AUTO_INDEX][2][bId]=403; CaseBonus[CASE_AUTO_INDEX][2][bNumberOpen]=20; CaseBonus[CASE_AUTO_INDEX][2][bRarity]=4; 
    CaseBonus[CASE_AUTO_INDEX][2][bType]=4; CaseBonus[CASE_AUTO_INDEX][2][bInternalId]=4; CaseBonus[CASE_AUTO_INDEX][2][bCount]=2; 
    CaseBonus[CASE_AUTO_INDEX][2][bPriceSprayed]=0;
    
    CaseBonus[CASE_AUTO_INDEX][3][bId]=404; CaseBonus[CASE_AUTO_INDEX][3][bNumberOpen]=10; CaseBonus[CASE_AUTO_INDEX][3][bRarity]=4; 
    CaseBonus[CASE_AUTO_INDEX][3][bType]=21; CaseBonus[CASE_AUTO_INDEX][3][bInternalId]=1; CaseBonus[CASE_AUTO_INDEX][3][bCount]=300; 
    CaseBonus[CASE_AUTO_INDEX][3][bPriceSprayed]=0;
    
    CaseBonus[CASE_AUTO_INDEX][4][bId]=405; CaseBonus[CASE_AUTO_INDEX][4][bNumberOpen]=5; CaseBonus[CASE_AUTO_INDEX][4][bRarity]=4; 
    CaseBonus[CASE_AUTO_INDEX][4][bType]=4; CaseBonus[CASE_AUTO_INDEX][4][bInternalId]=4; CaseBonus[CASE_AUTO_INDEX][4][bCount]=1; 
    CaseBonus[CASE_AUTO_INDEX][4][bPriceSprayed]=0;
}

stock Cases_InitCase5Bonus()
{
    CaseBonus[CASE_SPECIAL_INDEX][0][bId]=501; CaseBonus[CASE_SPECIAL_INDEX][0][bNumberOpen]=25; CaseBonus[CASE_SPECIAL_INDEX][0][bRarity]=5; 
    CaseBonus[CASE_SPECIAL_INDEX][0][bType]=5; CaseBonus[CASE_SPECIAL_INDEX][0][bInternalId]=665; CaseBonus[CASE_SPECIAL_INDEX][0][bCount]=0; 
    CaseBonus[CASE_SPECIAL_INDEX][0][bPriceSprayed]=500;
    
    CaseBonus[CASE_SPECIAL_INDEX][1][bId]=502; CaseBonus[CASE_SPECIAL_INDEX][1][bNumberOpen]=20; CaseBonus[CASE_SPECIAL_INDEX][1][bRarity]=5; 
    CaseBonus[CASE_SPECIAL_INDEX][1][bType]=21; CaseBonus[CASE_SPECIAL_INDEX][1][bInternalId]=1; CaseBonus[CASE_SPECIAL_INDEX][1][bCount]=1500; 
    CaseBonus[CASE_SPECIAL_INDEX][1][bPriceSprayed]=0;
    
    CaseBonus[CASE_SPECIAL_INDEX][2][bId]=503; CaseBonus[CASE_SPECIAL_INDEX][2][bNumberOpen]=15; CaseBonus[CASE_SPECIAL_INDEX][2][bRarity]=5; 
    CaseBonus[CASE_SPECIAL_INDEX][2][bType]=4; CaseBonus[CASE_SPECIAL_INDEX][2][bInternalId]=5; CaseBonus[CASE_SPECIAL_INDEX][2][bCount]=2; 
    CaseBonus[CASE_SPECIAL_INDEX][2][bPriceSprayed]=0;
    
    CaseBonus[CASE_SPECIAL_INDEX][3][bId]=504; CaseBonus[CASE_SPECIAL_INDEX][3][bNumberOpen]=10; CaseBonus[CASE_SPECIAL_INDEX][3][bRarity]=5; 
    CaseBonus[CASE_SPECIAL_INDEX][3][bType]=21; CaseBonus[CASE_SPECIAL_INDEX][3][bInternalId]=1; CaseBonus[CASE_SPECIAL_INDEX][3][bCount]=1000; 
    CaseBonus[CASE_SPECIAL_INDEX][3][bPriceSprayed]=0;
    
    CaseBonus[CASE_SPECIAL_INDEX][4][bId]=505; CaseBonus[CASE_SPECIAL_INDEX][4][bNumberOpen]=5; CaseBonus[CASE_SPECIAL_INDEX][4][bRarity]=5; 
    CaseBonus[CASE_SPECIAL_INDEX][4][bType]=4; CaseBonus[CASE_SPECIAL_INDEX][4][bInternalId]=5; CaseBonus[CASE_SPECIAL_INDEX][4][bCount]=1; 
    CaseBonus[CASE_SPECIAL_INDEX][4][bPriceSprayed]=0;
}

stock Cases_InitCase6Bonus()
{
    CaseBonus[CASE_DRIVE_INDEX][0][bId]=601; CaseBonus[CASE_DRIVE_INDEX][0][bNumberOpen]=40; CaseBonus[CASE_DRIVE_INDEX][0][bRarity]=5; 
    CaseBonus[CASE_DRIVE_INDEX][0][bType]=5; CaseBonus[CASE_DRIVE_INDEX][0][bInternalId]=658; CaseBonus[CASE_DRIVE_INDEX][0][bCount]=0; 
    CaseBonus[CASE_DRIVE_INDEX][0][bPriceSprayed]=100;
    
    CaseBonus[CASE_DRIVE_INDEX][1][bId]=602; CaseBonus[CASE_DRIVE_INDEX][1][bNumberOpen]=30; CaseBonus[CASE_DRIVE_INDEX][1][bRarity]=4; 
    CaseBonus[CASE_DRIVE_INDEX][1][bType]=21; CaseBonus[CASE_DRIVE_INDEX][1][bInternalId]=1; CaseBonus[CASE_DRIVE_INDEX][1][bCount]=350; 
    CaseBonus[CASE_DRIVE_INDEX][1][bPriceSprayed]=0;
    
    CaseBonus[CASE_DRIVE_INDEX][2][bId]=603; CaseBonus[CASE_DRIVE_INDEX][2][bNumberOpen]=20; CaseBonus[CASE_DRIVE_INDEX][2][bRarity]=4; 
    CaseBonus[CASE_DRIVE_INDEX][2][bType]=4; CaseBonus[CASE_DRIVE_INDEX][2][bInternalId]=6; CaseBonus[CASE_DRIVE_INDEX][2][bCount]=2; 
    CaseBonus[CASE_DRIVE_INDEX][2][bPriceSprayed]=0;
    
    CaseBonus[CASE_DRIVE_INDEX][3][bId]=604; CaseBonus[CASE_DRIVE_INDEX][3][bNumberOpen]=10; CaseBonus[CASE_DRIVE_INDEX][3][bRarity]=4; 
    CaseBonus[CASE_DRIVE_INDEX][3][bType]=21; CaseBonus[CASE_DRIVE_INDEX][3][bInternalId]=1; CaseBonus[CASE_DRIVE_INDEX][3][bCount]=200; 
    CaseBonus[CASE_DRIVE_INDEX][3][bPriceSprayed]=0;
    
    CaseBonus[CASE_DRIVE_INDEX][4][bId]=605; CaseBonus[CASE_DRIVE_INDEX][4][bNumberOpen]=5; CaseBonus[CASE_DRIVE_INDEX][4][bRarity]=4; 
    CaseBonus[CASE_DRIVE_INDEX][4][bType]=4; CaseBonus[CASE_DRIVE_INDEX][4][bInternalId]=6; CaseBonus[CASE_DRIVE_INDEX][4][bCount]=1; 
    CaseBonus[CASE_DRIVE_INDEX][4][bPriceSprayed]=0;
}

// Сохранение и загрузка данных игрока
stock Cases_SavePlayer(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new ccStr[512];
    ccStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ccStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", GetPlayerCaseCountByType(playerid, CaseData[i][cId]));
        strcat(ccStr, tmp);
    }

    new ocStr[512];
    ocStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ocStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", pCasesOpenedByCase[playerid][i]);
        strcat(ocStr, tmp);
    }

    new cbStr[1024];
    cbStr[0] = EOS;
    for(new c = 0; c < MAX_CASES; c++)
    {
        for(new b = 0; b < MAX_BONUS_PER_CASE; b++)
        {
            if(c > 0 || b > 0) strcat(cbStr, ",");
            new tmp[8];
            format(tmp, sizeof(tmp), "%d", pCasesBonusStatus[playerid][c][b]);
            strcat(cbStr, tmp);
        }
    }

    new query[2048];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO player_cases (user_id, dust, opened_count, selected_case, tutorial, case_counts, opened_by_case, bonus_status) \
        VALUES (%d, %d, %d, %d, %d, '%e', '%e', '%e') \
        ON DUPLICATE KEY UPDATE dust=%d, opened_count=%d, selected_case=%d, tutorial=%d, case_counts='%e', opened_by_case='%e', bonus_status='%e'",
        GetPlayerAccountID(playerid),
        GetPlayerDustValue(playerid),
        pCasesOpened[playerid],
        pCasesSelected[playerid],
        pCasesTutorial[playerid],
        ccStr,
        ocStr,
        cbStr,
        GetPlayerDustValue(playerid),
        pCasesOpened[playerid],
        pCasesSelected[playerid],
        pCasesTutorial[playerid],
        ccStr,
        ocStr,
        cbStr
    );
    mysql_tquery(mysql, query);
    return 1;
}

public Cases_OnPlayerLoad(playerid)
{
    if(cache_num_rows())
    {
        SetPVarInt(playerid, "player_dust", cache_get_field_content_int(0, "dust"));
        pCasesOpened[playerid] = cache_get_field_content_int(0, "opened_count");
        pCasesSelected[playerid] = cache_get_field_content_int(0, "selected_case");
        pCasesTutorial[playerid] = cache_get_field_content_int(0, "tutorial");

        new ccStr[512];
        cache_get_field_content(0, "case_counts", ccStr, mysql, sizeof(ccStr));
        if(strlen(ccStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(ccStr), tmp[16];
            while(pos < len && idx < MAX_CASES)
            {
                new end = pos;
                while(end < len && ccStr[end] != ',') end++;
                strmid(tmp, ccStr, pos, end, sizeof(tmp));
                AddPlayerCaseCountByType(playerid, CaseData[idx][cId], strval(tmp));
                idx++;
                pos = end + 1;
            }
        }

        new ocStr[512];
        cache_get_field_content(0, "opened_by_case", ocStr, mysql, sizeof(ocStr));
        if(strlen(ocStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(ocStr), tmp[16];
            while(pos < len && idx < MAX_CASES)
            {
                new end = pos;
                while(end < len && ocStr[end] != ',') end++;
                strmid(tmp, ocStr, pos, end, sizeof(tmp));
                pCasesOpenedByCase[playerid][idx++] = strval(tmp);
                pos = end + 1;
            }
        }

        new cbStr[1024];
        cache_get_field_content(0, "bonus_status", cbStr, mysql, sizeof(cbStr));
        if(strlen(cbStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(cbStr), tmp[8];
            while(pos < len && idx < MAX_CASES * MAX_BONUS_PER_CASE)
            {
                new end = pos;
                while(end < len && cbStr[end] != ',') end++;
                strmid(tmp, cbStr, pos, end, sizeof(tmp));
                pCasesBonusStatus[playerid][idx / MAX_BONUS_PER_CASE][idx % MAX_BONUS_PER_CASE] = strval(tmp);
                idx++;
                pos = end + 1;
            }
        }
    }
    return 1;
}

stock Cases_LoadPlayer(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM player_cases WHERE user_id = %d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Cases_OnPlayerLoad", "d", playerid);
    return 1;
}
CMD:givecases1(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) 
        return SendClientMessage(playerid, COLOR_GREY, "У вас нет прав для использования этой команды.");

    new target, case_type, amount;
    if(sscanf(params, "udd", target, case_type, amount))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [тип_кейса] [количество]");

    if(!IsPlayerConnected(target))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    // Проверяем существование кейса
    new case_index = Cases_GetIndex(case_type);
    if(case_index == -1)
    {
        new str[128];
        format(str, sizeof(str), "Кейс с типом %d не существует. Доступные типы:", case_type);
        SendClientMessage(playerid, COLOR_RED, str);
        
        // Показываем доступные кейсы
        new available[256] = "1 (Ежедневный), 2 (Бомж), 3 (Стандарт), 4 (Авто), 5 (Особый), 8 (Драйв)";
        SendClientMessage(playerid, COLOR_WHITE, available);
        return 1;
    }

    if(amount <= 0)
        return SendClientMessage(playerid, COLOR_RED, "Количество должно быть больше 0.");

    // Выдаем кейсы
    Cases_GivePlayerCaseById(target, case_type, amount);

    // Логирование
    new admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(target, target_name, sizeof(target_name));

    
    // Уведомление админа
    new str[128];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", amount, case_type, target_name);
    SendClientMessage(playerid, -1, str);

    // Уведомление игрока
    new case_name[32];
    switch(case_type)
    {
        case 1: case_name = "Ежедневный";
        case 2: case_name = "Бомж";
        case 3: case_name = "Стандартный";
        case 4: case_name = "Авто";
        case 5: case_name = "Особый";
        case 8: case_name = "Драйв";
        default: format(case_name, sizeof(case_name), "тип %d", case_type);
    }

    format(str, sizeof(str), "Администратор выдал вам %d %s кейс(ов).", amount, case_name);
    SendClientMessage(target, COLOR_YELLOW, str);

    // Обновляем GUI если открыт
    if(pCasesGUIOpen[target])
        Cases_UpdateGUI(target);

    return 1;
}

// Альтернативная команда для выдачи пыли (если нужна)
CMD:givedust(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) 
        return SendClientMessage(playerid, COLOR_GREY, "У вас нет прав для использования этой команды.");

    new target, amount;
    if(sscanf(params, "ud", target, amount))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givedust [id] [количество]");

    if(!IsPlayerConnected(target))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    if(amount <= 0)
        return SendClientMessage(playerid, COLOR_RED, "Количество должно быть больше 0.");

    Cases_GiveDust(target, amount);

    new admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(target, target_name, sizeof(target_name));

    new str[128];
    format(str, sizeof(str), "Вы выдали %d пыли игроку %s.", amount, target_name);
    SendClientMessage(playerid, -10 , str);

    format(str, sizeof(str), "Администратор выдал вам %d пыли.", amount);
    SendClientMessage(target, COLOR_YELLOW, str);

    // Обновляем GUI если открыт
    if(pCasesGUIOpen[target])
        Cases_UpdateGUI(target);

    return 1;
}

// Команда для просмотра статистики кейсов игрока (для админов)
CMD:casesinfo(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) 
        return SendClientMessage(playerid, COLOR_GREY, "У вас нет прав для использования этой команды.");

    new target;
    if(sscanf(params, "u", target))
        target = playerid;

    if(!IsPlayerConnected(target))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    new target_name[MAX_PLAYER_NAME];
    GetPlayerName(target, target_name, sizeof(target_name));

    new str[512];
    format(str, sizeof(str), "=== Статистика кейсов игрока %s ===", target_name);
    SendClientMessage(playerid, -1, str);

    format(str, sizeof(str), "Пыль: %d | Всего открыто: %d", GetPlayerDustValue(target), pCasesOpened[target]);
    SendClientMessage(playerid, COLOR_WHITE, str);

    SendClientMessage(playerid, COLOR_WHITE, "Количество кейсов:");
    
    // Показываем все доступные кейсы
    new caseIds[] = {1, 2, 3, 4, 5, 8};
    new caseNames[][] = {"Ежедневный", "Бомж", "Стандартный", "Авто", "Особый", "Драйв"};
    
    for(new i = 0; i < sizeof(caseIds); i++)
    {
        new count = GetPlayerCaseCountByType(target, caseIds[i]);
        new opened = 0;
        
        new idx = Cases_GetIndex(caseIds[i]);
        if(idx != -1)
            opened = pCasesOpenedByCase[target][idx];
            
        format(str, sizeof(str), "%s (тип %d): %d шт. | Открыто: %d раз", 
            caseNames[i], caseIds[i], count, opened);
        SendClientMessage(playerid, COLOR_GREY, str);
    }

    return 1;
}