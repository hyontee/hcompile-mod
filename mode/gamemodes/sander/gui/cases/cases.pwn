#if defined _DOVARD_CASES_ONLY_INC
    #endinput
#endif
#define _DOVARD_CASES_ONLY_INC


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
#define REWARD_TYPE_BC          3
#define REWARD_TYPE_CASE        4
#define REWARD_TYPE_VEHICLE     5
#define REWARD_TYPE_VIP         9
#define REWARD_TYPE_BP_EXP      10
#define REWARD_TYPE_ITEM        11
#define REWARD_TYPE_DUST        21
#define REWARD_TYPE_EVENT_RES   23

#define MAX_CASES               11
#define MAX_AWARDS_PER_CASE     40
#define MAX_BONUS_PER_CASE      5

#define CASES_DUST_REWARD_THRESHOLD 2000
#define CASES_DAILY_EXP             1000
#define CASES_DAILY_LEVEL           4
#define CASES_DAILY_CASE_ID         1
#define CASES_LEGENDARY_CASE_ID     5

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
    cSale,
    cAwardsCount,
    cBonusCount
};

new pCasesDust[MAX_PLAYERS];
new pCasesOpened[MAX_PLAYERS];
new pCasesSelected[MAX_PLAYERS];
new pCasesTutorial[MAX_PLAYERS];
new pCasesOpenedByCase[MAX_PLAYERS][MAX_CASES];
new pCasesExtraOwned[MAX_PLAYERS][MAX_CASES];
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
    SendPacketToClient(playerid, guiid, json);
    return 1;
}


stock Cases_Notify(playerid, type, text[], subtext[] = "")
{
    ShowNotificationSander(playerid, type, 7, -1, -1, text, subtext);
    return 1;
}

stock Cases_DBInit()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `player_cases` (        `user_id` INT NOT NULL,        `dust` INT NOT NULL DEFAULT 0,        `opened_count` INT NOT NULL DEFAULT 0,        `selected_case` INT NOT NULL DEFAULT 1,        `tutorial` TINYINT NOT NULL DEFAULT 0,        `case_counts` TEXT,        `opened_by_case` TEXT,        `bonus_status` TEXT,        PRIMARY KEY (`user_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;"
    );
    return 1;
}

stock Cases_GiveDust(playerid, amount)
{
    if(amount <= 0) return 0;
    pCasesDust[playerid] += amount;
    Cases_CheckDustReward(playerid);
    Cases_SavePlayer(playerid);
    if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
    return 1;
}

stock Cases_AddToPlayer(playerid, caseIdx, amount)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(caseIdx < 0 || caseIdx >= MAX_CASES) return 0;
    if(amount <= 0) return 0;
    AddPlayerCaseCountByType(playerid, CaseData[caseIdx][cId], amount);
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

stock Cases_FindAwardDetails(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardRarity, &rewardSpray, &rewardSubcount)
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
                rewardSpray = CaseAwards[lastIdx][i][aPriceSprayed];
                rewardSubcount = CaseAwards[lastIdx][i][aSubcount];
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
                rewardSpray = CaseAwards[c][i][aPriceSprayed];
                rewardSubcount = CaseAwards[c][i][aSubcount];
                return 1;
            }
        }
    }
    return 0;
}

stock Cases_FindAwardById(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardRarity)
{
    new rewardSpray, rewardSubcount;
    return Cases_FindAwardDetails(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount);
}

stock Cases_QueueReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount, isBonus)
{
    #pragma unused rewardSubcount
    #pragma unused isBonus

    if(!BPR_IsReady(playerid))
    {
        Cases_Notify(playerid, 2, "Хранилище наград ещё загружается", "Повторите действие через секунду.");
        return 0;
    }
    if(!BPR_CanAcceptRewards(playerid, 1))
    {
        Cases_Notify(playerid, 2, "Хранилище /reward заполнено", "Заберите или распылите часть наград.");
        return 0;
    }

    if(rewardCount <= 0) rewardCount = 1;
    if(rewardRarity < 1) rewardRarity = 1;

    new rewardName[64];
    Cases_GetRewardDisplayName(rewardType, rewardValue, rewardCount, rewardName, sizeof(rewardName));

    new imageId = rewardValue;
    new quantity = rewardCount;
    new daysLeft = 365;
    new skinModel = -1;

    switch(rewardType)
    {
        case REWARD_TYPE_EXP, REWARD_TYPE_MONEY, REWARD_TYPE_BC, REWARD_TYPE_BP_EXP, REWARD_TYPE_DUST, REWARD_TYPE_EVENT_RES:
        {
            imageId = 0;
            daysLeft = 0;
        }
        case REWARD_TYPE_CASE:
        {
            daysLeft = 0;
        }
        case REWARD_TYPE_VEHICLE:
        {
            quantity = 1;
            daysLeft = 365;
        }
        case REWARD_TYPE_VIP:
        {
            // cases.json stores VIP duration in hours and VIP level in internalId.
            daysLeft = (rewardCount + 23) / 24;
            if(daysLeft < 1) daysLeft = 1;
        }
        case REWARD_TYPE_ITEM:
        {
            if(rewardValue == 134)
            {
                skinModel = rewardCount;
                quantity = 1;
            }
            daysLeft = 365;
        }
        default:
        {
            Cases_Notify(playerid, 2, "Неизвестный тип награды", "Награда не была удалена.");
            return 0;
        }
    }

    if(!BPR_GiveReward(playerid, rewardType, imageId, rewardName, rewardRarity, quantity, daysLeft, rewardSpray, skinModel))
        return 0;

    new notifyText[128];
    format(notifyText, sizeof(notifyText), "Добавлено в /reward: %s", rewardName);
    Cases_Notify(playerid, 3, notifyText, "Заберите награду командой /reward.");
    return 1;
}

stock Cases_Init()
{
    for(new i = 0; i < MAX_CASES; i++)
    {
        CaseData[i][cId] = 0;
        CaseData[i][cPriceOne] = 0;
        CaseData[i][cPriceTen] = 0;
        CaseData[i][cDiscountOne] = 0;
        CaseData[i][cDiscountTen] = 0;
        CaseData[i][cSale] = 0;
        CaseData[i][cAwardsCount] = 0;
        CaseData[i][cBonusCount] = 0;
    }

    CaseData[0][cId] = 1;
    CaseData[0][cPriceOne] = 15;
    CaseData[0][cPriceTen] = 150;
    CaseData[0][cDiscountOne] = 0;
    CaseData[0][cDiscountTen] = 0;
    CaseData[0][cSale] = 0;
    CaseData[0][cAwardsCount] = 20;
    CaseData[0][cBonusCount] = 5;
    Cases_InitCase1Data();

    CaseData[1][cId] = 2;
    CaseData[1][cPriceOne] = 100;
    CaseData[1][cPriceTen] = 1000;
    CaseData[1][cDiscountOne] = 0;
    CaseData[1][cDiscountTen] = 0;
    CaseData[1][cSale] = 1;
    CaseData[1][cAwardsCount] = 28;
    CaseData[1][cBonusCount] = 5;
    Cases_InitCase2Data();

    CaseData[2][cId] = 3;
    CaseData[2][cPriceOne] = 700;
    CaseData[2][cPriceTen] = 7000;
    CaseData[2][cDiscountOne] = 0;
    CaseData[2][cDiscountTen] = 0;
    CaseData[2][cSale] = 1;
    CaseData[2][cAwardsCount] = 37;
    CaseData[2][cBonusCount] = 5;
    Cases_InitCase3Data();

    CaseData[3][cId] = 4;
    CaseData[3][cPriceOne] = 1200;
    CaseData[3][cPriceTen] = 12000;
    CaseData[3][cDiscountOne] = 0;
    CaseData[3][cDiscountTen] = 5;
    CaseData[3][cSale] = 1;
    CaseData[3][cAwardsCount] = 31;
    CaseData[3][cBonusCount] = 5;
    Cases_InitCase4Data();

    CaseData[4][cId] = 5;
    CaseData[4][cPriceOne] = 10000;
    CaseData[4][cPriceTen] = 100000;
    CaseData[4][cDiscountOne] = 0;
    CaseData[4][cDiscountTen] = 0;
    CaseData[4][cSale] = 0;
    CaseData[4][cAwardsCount] = 20;
    CaseData[4][cBonusCount] = 5;
    Cases_InitCase5Data();

    CaseData[5][cId] = 6;
    CaseData[5][cPriceOne] = 900;
    CaseData[5][cPriceTen] = 9000;
    CaseData[5][cDiscountOne] = 0;
    CaseData[5][cDiscountTen] = 0;
    CaseData[5][cSale] = 1;
    CaseData[5][cAwardsCount] = 25;
    CaseData[5][cBonusCount] = 5;
    Cases_InitCase6Data();

    CaseData[6][cId] = 7;
    CaseData[6][cPriceOne] = 900;
    CaseData[6][cPriceTen] = 9000;
    CaseData[6][cDiscountOne] = 0;
    CaseData[6][cDiscountTen] = 0;
    CaseData[6][cSale] = 1;
    CaseData[6][cAwardsCount] = 25;
    CaseData[6][cBonusCount] = 5;
    Cases_InitCase7Data();

    CaseData[7][cId] = 8;
    CaseData[7][cPriceOne] = 900;
    CaseData[7][cPriceTen] = 9000;
    CaseData[7][cDiscountOne] = 0;
    CaseData[7][cDiscountTen] = 5;
    CaseData[7][cSale] = 1;
    CaseData[7][cAwardsCount] = 25;
    CaseData[7][cBonusCount] = 5;
    Cases_InitCase8Data();

    CaseData[8][cId] = 9;
    CaseData[8][cPriceOne] = 900;
    CaseData[8][cPriceTen] = 9000;
    CaseData[8][cDiscountOne] = 0;
    CaseData[8][cDiscountTen] = 5;
    CaseData[8][cSale] = 1;
    CaseData[8][cAwardsCount] = 25;
    CaseData[8][cBonusCount] = 5;
    Cases_InitCase9Data();

    CaseData[9][cId] = 10;
    CaseData[9][cPriceOne] = 900;
    CaseData[9][cPriceTen] = 9000;
    CaseData[9][cDiscountOne] = 0;
    CaseData[9][cDiscountTen] = 5;
    CaseData[9][cSale] = 1;
    CaseData[9][cAwardsCount] = 25;
    CaseData[9][cBonusCount] = 5;
    Cases_InitCase10Data();

    CaseData[10][cId] = 11;
    CaseData[10][cPriceOne] = 900;
    CaseData[10][cPriceTen] = 9000;
    CaseData[10][cDiscountOne] = 0;
    CaseData[10][cDiscountTen] = 5;
    CaseData[10][cSale] = 1;
    CaseData[10][cAwardsCount] = 25;
    CaseData[10][cBonusCount] = 5;
    Cases_InitCase11Data();

    printf("[Cases] loaded %d cases from cases.json profile", MAX_CASES);
    return 1;
}


stock Cases_GetIndex(caseId)
{
    for(new i = 0; i < MAX_CASES; i++) {
        if(CaseData[i][cId] == caseId) return i;
    }
    return -1;
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
        case 6: return GetPlayerData(playerid, P_COUNT_DOP_CASE1);
    }

    new idx = Cases_GetIndex(case_type);
    if(idx == -1) return 0;
    return pCasesExtraOwned[playerid][idx];
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
            return 1;
        }
        case 2:
        {
            SetPlayerData(playerid, P_COUNT_BOMJ_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countbomjcases", value);
            return 1;
        }
        case 3:
        {
            SetPlayerData(playerid, P_COUNT_STANDART_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countstancases", value);
            return 1;
        }
        case 4:
        {
            SetPlayerData(playerid, P_COUNT_CAR_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countcarcases", value);
            return 1;
        }
        case 5:
        {
            SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, value);
            UpdatePlayerDatabaseInt(playerid, "countosobcases", value);
            return 1;
        }
        case 6:
        {
            SetPlayerData(playerid, P_COUNT_DOP_CASE1, value);
            UpdatePlayerDatabaseInt(playerid, "countdopcases1", value);
            return 1;
        }
    }

    new idx = Cases_GetIndex(case_type);
    if(idx == -1) return 0;
    pCasesExtraOwned[playerid][idx] = value;
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
}

stock Cases_OnPlayerConnect(playerid)
{
    pCasesDust[playerid] = 0;
    pCasesOpened[playerid] = 0;
    pCasesSelected[playerid] = CASES_DAILY_CASE_ID;
    pCasesTutorial[playerid] = 0;
    pCasesGUIOpen[playerid] = 0;
    pCasesLastAction[playerid] = 0;
    pCasesPendingCount[playerid] = 0;
    pCasesLastOpenedIdx[playerid] = 0;

    for(new i = 0; i < MAX_CASES; i++)
    {
        pCasesExtraOwned[playerid][i] = 0;
        pCasesOpenedByCase[playerid][i] = 0;
        for(new j = 0; j < MAX_BONUS_PER_CASE; j++)
        {
            pCasesBonusStatus[playerid][i][j] = 1;
        }
    }

    for(new i = 0; i < 10; i++)
    {
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


stock Cases_BuildCbArray(playerid, caseIdx, &Node:cbArray)
{
    if(caseIdx < 0 || caseIdx >= MAX_CASES) return 0;

    for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++)
    {
        new Node:bonusObj = JSON_Object(
            "id", JSON_Int(CaseBonus[caseIdx][b][bId]),
            "state", JSON_Int(Cases_GetBonusState(playerid, caseIdx, b))
        );
        cbArray = JSON_Append(cbArray, JSON_Array(bonusObj));
    }
    return 1;
}

stock Cases_ShowGUI(playerid)
{
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1)
    {
        selectedIdx = 0;
        pCasesSelected[playerid] = CaseData[0][cId];
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", pCasesDust[playerid]);
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", pCasesTutorial[playerid]);

    new Node:ccArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++)
    {
        new Node:ccObj = JSON_Object(
            "id", JSON_Int(CaseData[c][cId]),
            "cot", JSON_Int(GetPlayerCaseCountByType(playerid, CaseData[c][cId])),
            "du", JSON_Int(CaseData[c][cSale])
        );
        ccArray = JSON_Append(ccArray, JSON_Array(ccObj));
    }
    JSON_SetArray(json, "cc", ccArray);

    new Node:cbArray = JSON_Array();
    Cases_BuildCbArray(playerid, selectedIdx, cbArray);
    JSON_SetArray(json, "cb", cbArray);

    ShowPlayerGUI(playerid, GUICases, json);
    pCasesGUIOpen[playerid] = 1;
    JSON_Cleanup(json);
    return 1;
}

stock Cases_UpdateGUI(playerid)
{
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) return Cases_ShowGUI(playerid);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", pCasesDust[playerid]);
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", pCasesTutorial[playerid]);

    new Node:ccArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++)
    {
        new Node:ccObj = JSON_Object(
            "id", JSON_Int(CaseData[c][cId]),
            "cot", JSON_Int(GetPlayerCaseCountByType(playerid, CaseData[c][cId])),
            "du", JSON_Int(CaseData[c][cSale])
        );
        ccArray = JSON_Append(ccArray, JSON_Array(ccObj));
    }
    JSON_SetArray(json, "cc", ccArray);

    new Node:cbArray = JSON_Array();
    Cases_BuildCbArray(playerid, selectedIdx, cbArray);
    JSON_SetArray(json, "cb", cbArray);

    Cases_SendPacket(playerid, GUICases, json);
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
	new Node:json = JSON_Object(
		"t", JSON_Int(2),
		"s", JSON_Int(0),
		"bid", JSON_Int(bannerId)
	);
	
	ShowPlayerGUI(playerid, GUICases, json);
	JSON_Cleanup(json);
	return 1;
}


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

    if(actionType == CASES_TYPE_OPEN || actionType == CASES_TYPE_OPEN_SUPER || actionType == CASES_TYPE_SELECT)
    {
        new currentTick = GetTickCount();
        if(currentTick - pCasesLastAction[playerid] < 400)
        {
            JSON_Cleanup(json);
            return 0;
        }
        pCasesLastAction[playerid] = currentTick;
    }

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
            Cases_Notify(playerid, 2, "Недостаточно BC", "Откройте донат-магазин.");
        }
        case CASES_TYPE_OPEN_SUPER:
        {
            Cases_OpenCase(playerid, CASES_LEGENDARY_CASE_ID, CASES_OPEN_ONE);
        }
        case CASES_TYPE_GET_BONUS:
        {
            new bonusId = 0;
            JSON_GetInt(json, "b", bonusId);
            Cases_GetBonus(playerid, bonusId);
        }
        case CASES_TYPE_FROM_BANNER:
        {
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



stock Cases_SendBonusPulse(playerid, caseIdx)
{
    if(caseIdx < 0 || caseIdx >= MAX_CASES) return 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", pCasesDust[playerid]);
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][caseIdx]);
    JSON_SetInt(json, "cs", CaseData[caseIdx][cId]);

    new Node:cbArray = JSON_Array();
    Cases_BuildCbArray(playerid, caseIdx, cbArray);
    JSON_SetArray(json, "cb", cbArray);

    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);
    return 1;
}

stock Cases_OpenCase(playerid, caseId, openType)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1) return 0;

    if(openType != CASES_OPEN_ONE && openType != CASES_OPEN_TEN)
        openType = CASES_OPEN_ONE;

    new openCount = (openType == CASES_OPEN_ONE) ? 1 : 10;

    if(pCasesPendingCount[playerid] > 0)
    {
        Cases_Notify(playerid, 2, "Сначала завершите текущее открытие", "Заберите или распылите выпавшие награды.");
        return 0;
    }

    if(!BPR_IsReady(playerid))
    {
        Cases_Notify(playerid, 2, "Хранилище наград ещё загружается", "Повторите открытие через секунду.");
        return 0;
    }
    if(!BPR_CanAcceptRewards(playerid, openCount))
    {
        new freeSlots = BPR_GetFreeSlots(playerid), limitText[96];
        format(limitText, sizeof(limitText), "Свободно мест: %d. Требуется: %d.", freeSlots, openCount);
        Cases_Notify(playerid, 2, "Недостаточно места в /reward", limitText);
        return 0;
    }

    new rewardIds[10];
    new ownedCount = GetPlayerCaseCountByType(playerid, caseId);

    if(ownedCount >= openCount)
    {
        AddPlayerCaseCountByType(playerid, caseId, -openCount);
    }
    else
    {
        if(ownedCount > 0 || !CaseData[idx][cSale])
        {
            new Node:errorJson = JSON_Object(
                "t", JSON_Int(CASES_TYPE_OPEN),
                "s", JSON_Int(0),
                "d", JSON_Int(0)
            );
            Cases_SendPacket(playerid, GUICases, errorJson);
            JSON_Cleanup(errorJson);
            return 0;
        }

        new price = (openType == CASES_OPEN_ONE) ? CaseData[idx][cPriceOne] : CaseData[idx][cPriceTen];
        new discount = (openType == CASES_OPEN_ONE) ? CaseData[idx][cDiscountOne] : CaseData[idx][cDiscountTen];
        price -= price * discount / 100;

        if(GetPlayerDonateRub(playerid) < price)
        {
            new Node:errorJson = JSON_Object(
                "t", JSON_Int(CASES_TYPE_OPEN),
                "s", JSON_Int(-1),
                "d", JSON_Int(1)
            );
            Cases_SendPacket(playerid, GUICases, errorJson);
            JSON_Cleanup(errorJson);
            return 0;
        }
        GivePlayerDonateRub(playerid, -price, "Cases: open", true, true);
    }

    for(new r = 0; r < openCount; r++)
    {
        rewardIds[r] = Cases_GetRandomReward(idx);
        pCasesPendingRewards[playerid][r] = rewardIds[r];
    }
    pCasesPendingCount[playerid] = openCount;
    pCasesOpened[playerid] += openCount;
    pCasesOpenedByCase[playerid][idx] += openCount;
    pCasesLastOpenedIdx[playerid] = idx;
    pCasesSelected[playerid] = caseId;

    Cases_UpdateBonusStates(playerid, idx);

    new prStr[256];
    prStr[0] = EOS;
    for(new r = 0; r < openCount; r++)
    {
        new tmp[16];
        if(r > 0) strcat(prStr, ",");
        format(tmp, sizeof(tmp), "%d", rewardIds[r]);
        strcat(prStr, tmp);
    }

    new jsonStr[1024];
    format(jsonStr, sizeof(jsonStr), "{\"t\":%d,\"s\":1,\"bc\":%d,\"pc\":%d,\"bcc\":%d,\"cs\":%d,\"type\":%d,\"pr\":[%s]}",
        CASES_TYPE_OPEN,
        GetPlayerDonateRub(playerid),
        pCasesDust[playerid],
        pCasesOpenedByCase[playerid][idx],
        caseId,
        openType,
        prStr
    );

    new Node:json;
    if(JSON_Parse(jsonStr, json) != 0)
    {
        printf("[CASES] response parse failed for player=%d case=%d", playerid, caseId);
        return 0;
    }

    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);
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
    new rewardCount = pCasesDust[playerid] / CASES_DUST_REWARD_THRESHOLD;
    if(rewardCount <= 0) return 0;
    if(!BPR_IsReady(playerid) || !BPR_CanAcceptRewards(playerid, 1)) return 0;

    if(!BPR_GiveCase(playerid, CASES_LEGENDARY_CASE_ID, "Особый кейс", 5, rewardCount))
        return 0;

    pCasesDust[playerid] -= rewardCount * CASES_DUST_REWARD_THRESHOLD;

    new str[128];
    format(str, sizeof(str), "Особый кейс x%d добавлен в /reward.", rewardCount);
    Cases_Notify(playerid, 3, "Награда за пыль готова", str);

    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;

    new Node:json = JSON_Object(
        "t", JSON_Int(CASES_TYPE_OPEN_SUPER),
        "s", JSON_Int(1),
        "bc", JSON_Int(GetPlayerDonateRub(playerid)),
        "pc", JSON_Int(pCasesDust[playerid]),
        "bcc", JSON_Int(pCasesOpenedByCase[playerid][selectedIdx])
    );
    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);

    Cases_SavePlayer(playerid);
    if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
    return 1;
}

stock Cases_FindPendingIndex(playerid, rewardId)
{
    for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
    {
        if(pCasesPendingRewards[playerid][i] == rewardId)
            return i;
    }
    return -1;
}

stock Cases_ConsumePendingReward(playerid, rewardId)
{
    new idx = Cases_FindPendingIndex(playerid, rewardId);
    if(idx == -1) return 0;
    pCasesPendingRewards[playerid][idx] = 0;
    return 1;
}

stock Cases_CompactPendingRewards(playerid)
{
    new writeIndex = 0;
    for(new readIndex = 0; readIndex < 10; readIndex++)
    {
        if(pCasesPendingRewards[playerid][readIndex] <= 0) continue;
        if(writeIndex != readIndex)
        {
            pCasesPendingRewards[playerid][writeIndex] = pCasesPendingRewards[playerid][readIndex];
            pCasesPendingRewards[playerid][readIndex] = 0;
        }
        writeIndex++;
    }
    for(new i = writeIndex; i < 10; i++) pCasesPendingRewards[playerid][i] = 0;
    pCasesPendingCount[playerid] = writeIndex;
    return writeIndex;
}

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


stock Cases_SprayReward(playerid, rewardId)
{
    new rewardType, rewardValue, rewardCount, rewardRarity;
    if(!Cases_FindAwardById(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardRarity)) return 0;

    new sprayPrice = 0;
    new lastIdx = pCasesLastOpenedIdx[playerid];

    if(lastIdx >= 0 && lastIdx < MAX_CASES)
    {
        for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++)
        {
            if(CaseAwards[lastIdx][i][aId] == rewardId)
            {
                sprayPrice = CaseAwards[lastIdx][i][aPriceSprayed];
                break;
            }
        }
    }

    if(sprayPrice <= 0)
    {
        for(new c = 0; c < MAX_CASES; c++)
        {
            for(new i = 0; i < CaseData[c][cAwardsCount]; i++)
            {
                if(CaseAwards[c][i][aId] == rewardId)
                {
                    sprayPrice = CaseAwards[c][i][aPriceSprayed];
                    break;
                }
            }
            if(sprayPrice > 0) break;
        }
    }

    if(sprayPrice <= 0) return 0;

    pCasesDust[playerid] += sprayPrice;
    Cases_CheckDustReward(playerid);
    return sprayPrice;
}



stock Cases_GetRewardDisplayName(rewardType, rewardValue, rewardCount, dest[], destSize)
{
    switch(rewardType)
    {
        case REWARD_TYPE_EXP:
        {
            format(dest, destSize, "Опыт: %d", rewardCount);
            return 1;
        }
        case REWARD_TYPE_MONEY:
        {
            format(dest, destSize, "Деньги: %d", rewardCount);
            return 1;
        }
        case REWARD_TYPE_BC:
        {
            format(dest, destSize, "BC: %d", rewardCount);
            return 1;
        }
        case REWARD_TYPE_CASE:
        {
            switch(rewardValue)
            {
                case 1: format(dest, destSize, "Ежедневный кейс");
                case 2: format(dest, destSize, "Кейс бомжа");
                case 3: format(dest, destSize, "Стандартный кейс");
                case 4: format(dest, destSize, "Авто-кейс");
                case 5: format(dest, destSize, "Особый кейс");
                case 6: format(dest, destSize, "Драйв кейс");
                default: format(dest, destSize, "Кейс #%d", rewardValue);
            }
            return 1;
        }
        case REWARD_TYPE_VEHICLE:
        {
            new vehName[32];
            GetVehicleModelName(rewardValue, vehName, sizeof(vehName));
            format(dest, destSize, "%s", vehName);
            return 1;
        }
        case REWARD_TYPE_VIP:
        {
            if(rewardCount >= 24 && rewardCount % 24 == 0)
                format(dest, destSize, "VIP на %d дн.", rewardCount / 24);
            else
                format(dest, destSize, "VIP на %d ч.", rewardCount);
            return 1;
        }
        case REWARD_TYPE_BP_EXP:
        {
            format(dest, destSize, "Опыт Battle Pass: %d", rewardCount);
            return 1;
        }
        case REWARD_TYPE_ITEM:
        {
            new itemName[64];
            GetItemName(rewardValue, itemName, sizeof(itemName));
            if(rewardValue >= 19000 && rewardValue <= 19999)
                format(dest, destSize, "Аксессуар: %s", itemName);
            else if(strlen(itemName) > 0)
                format(dest, destSize, "%s", itemName);
            else
                format(dest, destSize, "Предмет #%d", rewardValue);
            return 1;
        }
        case REWARD_TYPE_DUST:
        {
            format(dest, destSize, "Пыль: %d", rewardCount);
            return 1;
        }
        case REWARD_TYPE_EVENT_RES:
        {
            format(dest, destSize, "Ивент-ресурс: %d", rewardCount);
            return 1;
        }
    }
    format(dest, destSize, "Награда #%d", rewardValue);
    return 1;
}

stock Cases_TakeRewards(playerid, const jsonData[])
{
    new takeRewards[10], sprayRewards[10];
    new takeCount = Cases_ExtractIntArray(jsonData, "bt1", takeRewards, 10);
    new sprayCount = Cases_ExtractIntArray(jsonData, "bt2", sprayRewards, 10);
    new totalDustGained = 0;
    new queuedCount = 0;
    new failedCount = 0;

    if(!BPR_IsReady(playerid))
    {
        Cases_Notify(playerid, 2, "Хранилище наград ещё загружается", "Повторите действие через секунду.");
        return 0;
    }

    if(takeCount == 0 && sprayCount == 0 && pCasesPendingCount[playerid] > 0)
    {
        for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
            takeRewards[takeCount++] = pCasesPendingRewards[playerid][i];
    }

    for(new i = 0; i < takeCount; i++)
    {
        new rewardId = takeRewards[i];
        if(rewardId <= 0) continue;

        // Only a reward that actually exists in the current case result may be
        // moved to /reward. This also keeps duplicate reward IDs safe: every
        // occurrence consumes exactly one pending slot.
        new pendingIdx = Cases_FindPendingIndex(playerid, rewardId);
        if(pendingIdx == -1) continue;

        new rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount;
        if(!Cases_FindAwardDetails(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount))
            continue;

        if(Cases_QueueReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount, 0))
        {
            pCasesPendingRewards[playerid][pendingIdx] = 0;
            queuedCount++;
        }
        else failedCount++;
    }

    for(new i = 0; i < sprayCount; i++)
    {
        if(sprayRewards[i] <= 0) continue;
        new pendingIdx = Cases_FindPendingIndex(playerid, sprayRewards[i]);
        if(pendingIdx == -1) continue;

        new sprayValue = Cases_SprayReward(playerid, sprayRewards[i]);
        if(sprayValue > 0)
        {
            pCasesPendingRewards[playerid][pendingIdx] = 0;
            totalDustGained += sprayValue;
        }
    }

    // Rewards omitted by the client are also queued into /reward instead of being lost.
    for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
    {
        new pendingReward = pCasesPendingRewards[playerid][i];
        if(pendingReward <= 0) continue;

        new rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount;
        if(!Cases_FindAwardDetails(playerid, pendingReward, rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount))
            continue;

        if(Cases_QueueReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, rewardSpray, rewardSubcount, 0))
        {
            pCasesPendingRewards[playerid][i] = 0;
            queuedCount++;
        }
        else failedCount++;
    }

    Cases_CheckDustReward(playerid);

    Cases_CompactPendingRewards(playerid);

    Cases_SavePlayer(playerid);

    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", CASES_TYPE_TAKE_REWARDS);
    JSON_SetInt(response, "s", failedCount == 0 ? 1 : 0);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "pc", pCasesDust[playerid]);
    JSON_SetInt(response, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    Cases_SendPacket(playerid, GUICases, response);
    JSON_Cleanup(response);

    if(queuedCount > 0)
    {
        new str[96];
        format(str, sizeof(str), "В /reward добавлено наград: %d", queuedCount);
        Cases_Notify(playerid, 3, str, "");
    }
    if(totalDustGained > 0)
    {
        new str[64];
        format(str, sizeof(str), "Получено пыли: %d", totalDustGained);
        Cases_Notify(playerid, 3, str, "");
    }
    if(failedCount > 0)
        Cases_Notify(playerid, 2, "Не все награды добавлены", "Освободите место в /reward и повторите получение.");
    return failedCount == 0;
}

stock Cases_GetBonus(playerid, bonusId)
{
    new caseIdx = Cases_GetIndex(pCasesSelected[playerid]), bonusIdx = -1;
    if(caseIdx == -1) caseIdx = 0;

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
        new Node:json = JSON_Object("t", JSON_Int(CASES_TYPE_GET_BONUS), "s", JSON_Int(0));
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }

    if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] == 3)
    {
        new Node:json = JSON_Object("t", JSON_Int(CASES_TYPE_GET_BONUS), "s", JSON_Int(0));
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }

    new requiredOpens = CaseBonus[caseIdx][bonusIdx][bNumberOpen];
    if(pCasesOpenedByCase[playerid][caseIdx] < requiredOpens)
    {
        new Node:json = JSON_Object("t", JSON_Int(CASES_TYPE_GET_BONUS), "s", JSON_Int(0));
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        return 0;
    }

    pCasesBonusStatus[playerid][caseIdx][bonusIdx] = 3;
    if(!Cases_QueueReward(
        playerid,
        CaseBonus[caseIdx][bonusIdx][bType],
        CaseBonus[caseIdx][bonusIdx][bInternalId],
        CaseBonus[caseIdx][bonusIdx][bCount],
        CaseBonus[caseIdx][bonusIdx][bRarity],
        CaseBonus[caseIdx][bonusIdx][bPriceSprayed],
        0,
        1
    ))
    {
        pCasesBonusStatus[playerid][caseIdx][bonusIdx] = 2;
        new Node:errorJson = JSON_Object("t", JSON_Int(CASES_TYPE_GET_BONUS), "s", JSON_Int(0));
        Cases_SendPacket(playerid, GUICases, errorJson);
        JSON_Cleanup(errorJson);
        return 0;
    }

    new Node:json = JSON_Object(
        "t", JSON_Int(CASES_TYPE_GET_BONUS),
        "s", JSON_Int(1),
        "bc", JSON_Int(GetPlayerDonateRub(playerid)),
        "pc", JSON_Int(pCasesDust[playerid]),
        "bcc", JSON_Int(pCasesOpenedByCase[playerid][caseIdx])
    );
    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);

    Cases_SavePlayer(playerid);
    return 1;
}


stock Cases_InitCase1Data()
{
    CaseAwards[0][0][aId]=1; CaseAwards[0][0][aRarity]=1; CaseAwards[0][0][aType]=11; CaseAwards[0][0][aInternalId]=23; CaseAwards[0][0][aCount]=1; CaseAwards[0][0][aPriceSprayed]=10; CaseAwards[0][0][aSubcount]=0;
    CaseAwards[0][1][aId]=2; CaseAwards[0][1][aRarity]=1; CaseAwards[0][1][aType]=1; CaseAwards[0][1][aInternalId]=1; CaseAwards[0][1][aCount]=2; CaseAwards[0][1][aPriceSprayed]=0; CaseAwards[0][1][aSubcount]=0;
    CaseAwards[0][2][aId]=3; CaseAwards[0][2][aRarity]=1; CaseAwards[0][2][aType]=10; CaseAwards[0][2][aInternalId]=1; CaseAwards[0][2][aCount]=200; CaseAwards[0][2][aPriceSprayed]=0; CaseAwards[0][2][aSubcount]=0;
    CaseAwards[0][3][aId]=4; CaseAwards[0][3][aRarity]=1; CaseAwards[0][3][aType]=11; CaseAwards[0][3][aInternalId]=21; CaseAwards[0][3][aCount]=1; CaseAwards[0][3][aPriceSprayed]=10; CaseAwards[0][3][aSubcount]=0;
    CaseAwards[0][4][aId]=5; CaseAwards[0][4][aRarity]=1; CaseAwards[0][4][aType]=2; CaseAwards[0][4][aInternalId]=1; CaseAwards[0][4][aCount]=4000; CaseAwards[0][4][aPriceSprayed]=0; CaseAwards[0][4][aSubcount]=0;
    CaseAwards[0][5][aId]=6; CaseAwards[0][5][aRarity]=1; CaseAwards[0][5][aType]=3; CaseAwards[0][5][aInternalId]=1; CaseAwards[0][5][aCount]=5; CaseAwards[0][5][aPriceSprayed]=0; CaseAwards[0][5][aSubcount]=0;
    CaseAwards[0][6][aId]=7; CaseAwards[0][6][aRarity]=1; CaseAwards[0][6][aType]=2; CaseAwards[0][6][aInternalId]=1; CaseAwards[0][6][aCount]=8000; CaseAwards[0][6][aPriceSprayed]=0; CaseAwards[0][6][aSubcount]=0;
    CaseAwards[0][7][aId]=8; CaseAwards[0][7][aRarity]=1; CaseAwards[0][7][aType]=3; CaseAwards[0][7][aInternalId]=1; CaseAwards[0][7][aCount]=10; CaseAwards[0][7][aPriceSprayed]=0; CaseAwards[0][7][aSubcount]=0;
    CaseAwards[0][8][aId]=9; CaseAwards[0][8][aRarity]=1; CaseAwards[0][8][aType]=9; CaseAwards[0][8][aInternalId]=1; CaseAwards[0][8][aCount]=2; CaseAwards[0][8][aPriceSprayed]=10; CaseAwards[0][8][aSubcount]=0;
    CaseAwards[0][9][aId]=10; CaseAwards[0][9][aRarity]=1; CaseAwards[0][9][aType]=10; CaseAwards[0][9][aInternalId]=1; CaseAwards[0][9][aCount]=400; CaseAwards[0][9][aPriceSprayed]=0; CaseAwards[0][9][aSubcount]=0;
    CaseAwards[0][10][aId]=11; CaseAwards[0][10][aRarity]=1; CaseAwards[0][10][aType]=1; CaseAwards[0][10][aInternalId]=1; CaseAwards[0][10][aCount]=4; CaseAwards[0][10][aPriceSprayed]=0; CaseAwards[0][10][aSubcount]=0;
    CaseAwards[0][11][aId]=12; CaseAwards[0][11][aRarity]=1; CaseAwards[0][11][aType]=5; CaseAwards[0][11][aInternalId]=462; CaseAwards[0][11][aCount]=0; CaseAwards[0][11][aPriceSprayed]=20; CaseAwards[0][11][aSubcount]=0;
    CaseAwards[0][12][aId]=13; CaseAwards[0][12][aRarity]=1; CaseAwards[0][12][aType]=10; CaseAwards[0][12][aInternalId]=1; CaseAwards[0][12][aCount]=500; CaseAwards[0][12][aPriceSprayed]=0; CaseAwards[0][12][aSubcount]=0;
    CaseAwards[0][13][aId]=14; CaseAwards[0][13][aRarity]=1; CaseAwards[0][13][aType]=2; CaseAwards[0][13][aInternalId]=1; CaseAwards[0][13][aCount]=20000; CaseAwards[0][13][aPriceSprayed]=0; CaseAwards[0][13][aSubcount]=0;
    CaseAwards[0][14][aId]=15; CaseAwards[0][14][aRarity]=1; CaseAwards[0][14][aType]=3; CaseAwards[0][14][aInternalId]=1; CaseAwards[0][14][aCount]=15; CaseAwards[0][14][aPriceSprayed]=0; CaseAwards[0][14][aSubcount]=0;
    CaseAwards[0][15][aId]=16; CaseAwards[0][15][aRarity]=1; CaseAwards[0][15][aType]=9; CaseAwards[0][15][aInternalId]=2; CaseAwards[0][15][aCount]=2; CaseAwards[0][15][aPriceSprayed]=10; CaseAwards[0][15][aSubcount]=0;
    CaseAwards[0][16][aId]=17; CaseAwards[0][16][aRarity]=1; CaseAwards[0][16][aType]=10; CaseAwards[0][16][aInternalId]=1; CaseAwards[0][16][aCount]=600; CaseAwards[0][16][aPriceSprayed]=0; CaseAwards[0][16][aSubcount]=0;
    CaseAwards[0][17][aId]=18; CaseAwards[0][17][aRarity]=1; CaseAwards[0][17][aType]=2; CaseAwards[0][17][aInternalId]=1; CaseAwards[0][17][aCount]=30000; CaseAwards[0][17][aPriceSprayed]=0; CaseAwards[0][17][aSubcount]=0;
    CaseAwards[0][18][aId]=19; CaseAwards[0][18][aRarity]=1; CaseAwards[0][18][aType]=1; CaseAwards[0][18][aInternalId]=1; CaseAwards[0][18][aCount]=6; CaseAwards[0][18][aPriceSprayed]=0; CaseAwards[0][18][aSubcount]=0;
    CaseAwards[0][19][aId]=20; CaseAwards[0][19][aRarity]=1; CaseAwards[0][19][aType]=5; CaseAwards[0][19][aInternalId]=549; CaseAwards[0][19][aCount]=0; CaseAwards[0][19][aPriceSprayed]=20; CaseAwards[0][19][aSubcount]=0;
    CaseBonus[0][0][bId]=1; CaseBonus[0][0][bNumberOpen]=40; CaseBonus[0][0][bRarity]=4; CaseBonus[0][0][bType]=4; CaseBonus[0][0][bInternalId]=3; CaseBonus[0][0][bCount]=1; CaseBonus[0][0][bPriceSprayed]=0;
    CaseBonus[0][1][bId]=2; CaseBonus[0][1][bNumberOpen]=30; CaseBonus[0][1][bRarity]=4; CaseBonus[0][1][bType]=4; CaseBonus[0][1][bInternalId]=3; CaseBonus[0][1][bCount]=1; CaseBonus[0][1][bPriceSprayed]=0;
    CaseBonus[0][2][bId]=3; CaseBonus[0][2][bNumberOpen]=20; CaseBonus[0][2][bRarity]=2; CaseBonus[0][2][bType]=4; CaseBonus[0][2][bInternalId]=2; CaseBonus[0][2][bCount]=2; CaseBonus[0][2][bPriceSprayed]=0;
    CaseBonus[0][3][bId]=4; CaseBonus[0][3][bNumberOpen]=10; CaseBonus[0][3][bRarity]=2; CaseBonus[0][3][bType]=4; CaseBonus[0][3][bInternalId]=2; CaseBonus[0][3][bCount]=1; CaseBonus[0][3][bPriceSprayed]=0;
    CaseBonus[0][4][bId]=5; CaseBonus[0][4][bNumberOpen]=5; CaseBonus[0][4][bRarity]=1; CaseBonus[0][4][bType]=4; CaseBonus[0][4][bInternalId]=1; CaseBonus[0][4][bCount]=1; CaseBonus[0][4][bPriceSprayed]=0;
}

stock Cases_InitCase2Data()
{
    CaseAwards[1][0][aId]=1; CaseAwards[1][0][aRarity]=1; CaseAwards[1][0][aType]=5; CaseAwards[1][0][aInternalId]=468; CaseAwards[1][0][aCount]=0; CaseAwards[1][0][aPriceSprayed]=20; CaseAwards[1][0][aSubcount]=0;
    CaseAwards[1][1][aId]=2; CaseAwards[1][1][aRarity]=1; CaseAwards[1][1][aType]=5; CaseAwards[1][1][aInternalId]=496; CaseAwards[1][1][aCount]=0; CaseAwards[1][1][aPriceSprayed]=20; CaseAwards[1][1][aSubcount]=0;
    CaseAwards[1][2][aId]=3; CaseAwards[1][2][aRarity]=1; CaseAwards[1][2][aType]=2; CaseAwards[1][2][aInternalId]=1; CaseAwards[1][2][aCount]=75000; CaseAwards[1][2][aPriceSprayed]=0; CaseAwards[1][2][aSubcount]=0;
    CaseAwards[1][3][aId]=4; CaseAwards[1][3][aRarity]=1; CaseAwards[1][3][aType]=5; CaseAwards[1][3][aInternalId]=404; CaseAwards[1][3][aCount]=0; CaseAwards[1][3][aPriceSprayed]=20; CaseAwards[1][3][aSubcount]=0;
    CaseAwards[1][4][aId]=5; CaseAwards[1][4][aRarity]=1; CaseAwards[1][4][aType]=1; CaseAwards[1][4][aInternalId]=1; CaseAwards[1][4][aCount]=12; CaseAwards[1][4][aPriceSprayed]=0; CaseAwards[1][4][aSubcount]=0;
    CaseAwards[1][5][aId]=6; CaseAwards[1][5][aRarity]=1; CaseAwards[1][5][aType]=5; CaseAwards[1][5][aInternalId]=439; CaseAwards[1][5][aCount]=0; CaseAwards[1][5][aPriceSprayed]=20; CaseAwards[1][5][aSubcount]=0;
    CaseAwards[1][6][aId]=7; CaseAwards[1][6][aRarity]=1; CaseAwards[1][6][aType]=2; CaseAwards[1][6][aInternalId]=1; CaseAwards[1][6][aCount]=90000; CaseAwards[1][6][aPriceSprayed]=0; CaseAwards[1][6][aSubcount]=0;
    CaseAwards[1][7][aId]=8; CaseAwards[1][7][aRarity]=1; CaseAwards[1][7][aType]=5; CaseAwards[1][7][aInternalId]=492; CaseAwards[1][7][aCount]=0; CaseAwards[1][7][aPriceSprayed]=20; CaseAwards[1][7][aSubcount]=0;
    CaseAwards[1][8][aId]=9; CaseAwards[1][8][aRarity]=1; CaseAwards[1][8][aType]=5; CaseAwards[1][8][aInternalId]=547; CaseAwards[1][8][aCount]=0; CaseAwards[1][8][aPriceSprayed]=20; CaseAwards[1][8][aSubcount]=0;
    CaseAwards[1][9][aId]=10; CaseAwards[1][9][aRarity]=1; CaseAwards[1][9][aType]=5; CaseAwards[1][9][aInternalId]=458; CaseAwards[1][9][aCount]=0; CaseAwards[1][9][aPriceSprayed]=20; CaseAwards[1][9][aSubcount]=0;
    CaseAwards[1][10][aId]=11; CaseAwards[1][10][aRarity]=1; CaseAwards[1][10][aType]=9; CaseAwards[1][10][aInternalId]=1; CaseAwards[1][10][aCount]=168; CaseAwards[1][10][aPriceSprayed]=20; CaseAwards[1][10][aSubcount]=0;
    CaseAwards[1][11][aId]=12; CaseAwards[1][11][aRarity]=1; CaseAwards[1][11][aType]=5; CaseAwards[1][11][aInternalId]=491; CaseAwards[1][11][aCount]=0; CaseAwards[1][11][aPriceSprayed]=20; CaseAwards[1][11][aSubcount]=0;
    CaseAwards[1][12][aId]=13; CaseAwards[1][12][aRarity]=1; CaseAwards[1][12][aType]=5; CaseAwards[1][12][aInternalId]=585; CaseAwards[1][12][aCount]=0; CaseAwards[1][12][aPriceSprayed]=20; CaseAwards[1][12][aSubcount]=0;
    CaseAwards[1][13][aId]=14; CaseAwards[1][13][aRarity]=1; CaseAwards[1][13][aType]=1; CaseAwards[1][13][aInternalId]=1; CaseAwards[1][13][aCount]=16; CaseAwards[1][13][aPriceSprayed]=0; CaseAwards[1][13][aSubcount]=0;
    CaseAwards[1][14][aId]=15; CaseAwards[1][14][aRarity]=1; CaseAwards[1][14][aType]=2; CaseAwards[1][14][aInternalId]=1; CaseAwards[1][14][aCount]=120000; CaseAwards[1][14][aPriceSprayed]=0; CaseAwards[1][14][aSubcount]=0;
    CaseAwards[1][15][aId]=16; CaseAwards[1][15][aRarity]=1; CaseAwards[1][15][aType]=9; CaseAwards[1][15][aInternalId]=2; CaseAwards[1][15][aCount]=72; CaseAwards[1][15][aPriceSprayed]=20; CaseAwards[1][15][aSubcount]=0;
    CaseAwards[1][16][aId]=17; CaseAwards[1][16][aRarity]=1; CaseAwards[1][16][aType]=5; CaseAwards[1][16][aInternalId]=536; CaseAwards[1][16][aCount]=0; CaseAwards[1][16][aPriceSprayed]=20; CaseAwards[1][16][aSubcount]=0;
    CaseAwards[1][17][aId]=18; CaseAwards[1][17][aRarity]=1; CaseAwards[1][17][aType]=5; CaseAwards[1][17][aInternalId]=529; CaseAwards[1][17][aCount]=0; CaseAwards[1][17][aPriceSprayed]=20; CaseAwards[1][17][aSubcount]=0;
    CaseAwards[1][18][aId]=19; CaseAwards[1][18][aRarity]=1; CaseAwards[1][18][aType]=9; CaseAwards[1][18][aInternalId]=3; CaseAwards[1][18][aCount]=72; CaseAwards[1][18][aPriceSprayed]=20; CaseAwards[1][18][aSubcount]=0;
    CaseAwards[1][19][aId]=20; CaseAwards[1][19][aRarity]=1; CaseAwards[1][19][aType]=5; CaseAwards[1][19][aInternalId]=542; CaseAwards[1][19][aCount]=0; CaseAwards[1][19][aPriceSprayed]=20; CaseAwards[1][19][aSubcount]=0;
    CaseAwards[1][20][aId]=21; CaseAwards[1][20][aRarity]=1; CaseAwards[1][20][aType]=5; CaseAwards[1][20][aInternalId]=421; CaseAwards[1][20][aCount]=0; CaseAwards[1][20][aPriceSprayed]=20; CaseAwards[1][20][aSubcount]=0;
    CaseAwards[1][21][aId]=22; CaseAwards[1][21][aRarity]=2; CaseAwards[1][21][aType]=5; CaseAwards[1][21][aInternalId]=2618; CaseAwards[1][21][aCount]=0; CaseAwards[1][21][aPriceSprayed]=20; CaseAwards[1][21][aSubcount]=0;
    CaseAwards[1][22][aId]=23; CaseAwards[1][22][aRarity]=2; CaseAwards[1][22][aType]=5; CaseAwards[1][22][aInternalId]=2548; CaseAwards[1][22][aCount]=0; CaseAwards[1][22][aPriceSprayed]=30; CaseAwards[1][22][aSubcount]=0;
    CaseAwards[1][23][aId]=24; CaseAwards[1][23][aRarity]=3; CaseAwards[1][23][aType]=11; CaseAwards[1][23][aInternalId]=706; CaseAwards[1][23][aCount]=1; CaseAwards[1][23][aPriceSprayed]=30; CaseAwards[1][23][aSubcount]=0;
    CaseAwards[1][24][aId]=25; CaseAwards[1][24][aRarity]=2; CaseAwards[1][24][aType]=5; CaseAwards[1][24][aInternalId]=516; CaseAwards[1][24][aCount]=0; CaseAwards[1][24][aPriceSprayed]=30; CaseAwards[1][24][aSubcount]=0;
    CaseAwards[1][25][aId]=26; CaseAwards[1][25][aRarity]=3; CaseAwards[1][25][aType]=11; CaseAwards[1][25][aInternalId]=705; CaseAwards[1][25][aCount]=1; CaseAwards[1][25][aPriceSprayed]=30; CaseAwards[1][25][aSubcount]=0;
    CaseAwards[1][26][aId]=27; CaseAwards[1][26][aRarity]=3; CaseAwards[1][26][aType]=11; CaseAwards[1][26][aInternalId]=134; CaseAwards[1][26][aCount]=252; CaseAwards[1][26][aPriceSprayed]=40; CaseAwards[1][26][aSubcount]=0;
    CaseAwards[1][27][aId]=28; CaseAwards[1][27][aRarity]=3; CaseAwards[1][27][aType]=11; CaseAwards[1][27][aInternalId]=134; CaseAwards[1][27][aCount]=6810; CaseAwards[1][27][aPriceSprayed]=40; CaseAwards[1][27][aSubcount]=0;
    CaseBonus[1][0][bId]=1; CaseBonus[1][0][bNumberOpen]=40; CaseBonus[1][0][bRarity]=5; CaseBonus[1][0][bType]=5; CaseBonus[1][0][bInternalId]=467; CaseBonus[1][0][bCount]=0; CaseBonus[1][0][bPriceSprayed]=100;
    CaseBonus[1][1][bId]=2; CaseBonus[1][1][bNumberOpen]=30; CaseBonus[1][1][bRarity]=3; CaseBonus[1][1][bType]=21; CaseBonus[1][1][bInternalId]=1; CaseBonus[1][1][bCount]=150; CaseBonus[1][1][bPriceSprayed]=0;
    CaseBonus[1][2][bId]=3; CaseBonus[1][2][bNumberOpen]=20; CaseBonus[1][2][bRarity]=3; CaseBonus[1][2][bType]=4; CaseBonus[1][2][bInternalId]=2; CaseBonus[1][2][bCount]=2; CaseBonus[1][2][bPriceSprayed]=0;
    CaseBonus[1][3][bId]=4; CaseBonus[1][3][bNumberOpen]=10; CaseBonus[1][3][bRarity]=3; CaseBonus[1][3][bType]=21; CaseBonus[1][3][bInternalId]=1; CaseBonus[1][3][bCount]=100; CaseBonus[1][3][bPriceSprayed]=0;
    CaseBonus[1][4][bId]=5; CaseBonus[1][4][bNumberOpen]=5; CaseBonus[1][4][bRarity]=3; CaseBonus[1][4][bType]=4; CaseBonus[1][4][bInternalId]=2; CaseBonus[1][4][bCount]=1; CaseBonus[1][4][bPriceSprayed]=0;
}

stock Cases_InitCase3Data()
{
    CaseAwards[2][0][aId]=1; CaseAwards[2][0][aRarity]=2; CaseAwards[2][0][aType]=11; CaseAwards[2][0][aInternalId]=362; CaseAwards[2][0][aCount]=1; CaseAwards[2][0][aPriceSprayed]=90; CaseAwards[2][0][aSubcount]=0;
    CaseAwards[2][1][aId]=2; CaseAwards[2][1][aRarity]=2; CaseAwards[2][1][aType]=9; CaseAwards[2][1][aInternalId]=2; CaseAwards[2][1][aCount]=504; CaseAwards[2][1][aPriceSprayed]=90; CaseAwards[2][1][aSubcount]=0;
    CaseAwards[2][2][aId]=3; CaseAwards[2][2][aRarity]=2; CaseAwards[2][2][aType]=2; CaseAwards[2][2][aInternalId]=1; CaseAwards[2][2][aCount]=600000; CaseAwards[2][2][aPriceSprayed]=0; CaseAwards[2][2][aSubcount]=0;
    CaseAwards[2][3][aId]=4; CaseAwards[2][3][aRarity]=2; CaseAwards[2][3][aType]=11; CaseAwards[2][3][aInternalId]=360; CaseAwards[2][3][aCount]=1; CaseAwards[2][3][aPriceSprayed]=90; CaseAwards[2][3][aSubcount]=0;
    CaseAwards[2][4][aId]=5; CaseAwards[2][4][aRarity]=2; CaseAwards[2][4][aType]=5; CaseAwards[2][4][aInternalId]=527; CaseAwards[2][4][aCount]=0; CaseAwards[2][4][aPriceSprayed]=100; CaseAwards[2][4][aSubcount]=0;
    CaseAwards[2][5][aId]=6; CaseAwards[2][5][aRarity]=2; CaseAwards[2][5][aType]=11; CaseAwards[2][5][aInternalId]=134; CaseAwards[2][5][aCount]=11962; CaseAwards[2][5][aPriceSprayed]=90; CaseAwards[2][5][aSubcount]=0;
    CaseAwards[2][6][aId]=7; CaseAwards[2][6][aRarity]=2; CaseAwards[2][6][aType]=3; CaseAwards[2][6][aInternalId]=1; CaseAwards[2][6][aCount]=600; CaseAwards[2][6][aPriceSprayed]=0; CaseAwards[2][6][aSubcount]=0;
    CaseAwards[2][7][aId]=8; CaseAwards[2][7][aRarity]=2; CaseAwards[2][7][aType]=9; CaseAwards[2][7][aInternalId]=3; CaseAwards[2][7][aCount]=360; CaseAwards[2][7][aPriceSprayed]=100; CaseAwards[2][7][aSubcount]=0;
    CaseAwards[2][8][aId]=9; CaseAwards[2][8][aRarity]=2; CaseAwards[2][8][aType]=5; CaseAwards[2][8][aInternalId]=445; CaseAwards[2][8][aCount]=0; CaseAwards[2][8][aPriceSprayed]=100; CaseAwards[2][8][aSubcount]=0;
    CaseAwards[2][9][aId]=10; CaseAwards[2][9][aRarity]=2; CaseAwards[2][9][aType]=11; CaseAwards[2][9][aInternalId]=583; CaseAwards[2][9][aCount]=1; CaseAwards[2][9][aPriceSprayed]=100; CaseAwards[2][9][aSubcount]=0;
    CaseAwards[2][10][aId]=11; CaseAwards[2][10][aRarity]=2; CaseAwards[2][10][aType]=11; CaseAwards[2][10][aInternalId]=134; CaseAwards[2][10][aCount]=14388; CaseAwards[2][10][aPriceSprayed]=100; CaseAwards[2][10][aSubcount]=0;
    CaseAwards[2][11][aId]=12; CaseAwards[2][11][aRarity]=2; CaseAwards[2][11][aType]=11; CaseAwards[2][11][aInternalId]=508; CaseAwards[2][11][aCount]=1; CaseAwards[2][11][aPriceSprayed]=100; CaseAwards[2][11][aSubcount]=0;
    CaseAwards[2][12][aId]=13; CaseAwards[2][12][aRarity]=2; CaseAwards[2][12][aType]=11; CaseAwards[2][12][aInternalId]=134; CaseAwards[2][12][aCount]=11917; CaseAwards[2][12][aPriceSprayed]=110; CaseAwards[2][12][aSubcount]=0;
    CaseAwards[2][13][aId]=14; CaseAwards[2][13][aRarity]=2; CaseAwards[2][13][aType]=5; CaseAwards[2][13][aInternalId]=589; CaseAwards[2][13][aCount]=0; CaseAwards[2][13][aPriceSprayed]=110; CaseAwards[2][13][aSubcount]=0;
    CaseAwards[2][14][aId]=15; CaseAwards[2][14][aRarity]=2; CaseAwards[2][14][aType]=5; CaseAwards[2][14][aInternalId]=2568; CaseAwards[2][14][aCount]=0; CaseAwards[2][14][aPriceSprayed]=110; CaseAwards[2][14][aSubcount]=0;
    CaseAwards[2][15][aId]=16; CaseAwards[2][15][aRarity]=2; CaseAwards[2][15][aType]=5; CaseAwards[2][15][aInternalId]=2385; CaseAwards[2][15][aCount]=0; CaseAwards[2][15][aPriceSprayed]=120; CaseAwards[2][15][aSubcount]=0;
    CaseAwards[2][16][aId]=17; CaseAwards[2][16][aRarity]=2; CaseAwards[2][16][aType]=5; CaseAwards[2][16][aInternalId]=2623; CaseAwards[2][16][aCount]=0; CaseAwards[2][16][aPriceSprayed]=120; CaseAwards[2][16][aSubcount]=0;
    CaseAwards[2][17][aId]=18; CaseAwards[2][17][aRarity]=2; CaseAwards[2][17][aType]=5; CaseAwards[2][17][aInternalId]=2627; CaseAwards[2][17][aCount]=0; CaseAwards[2][17][aPriceSprayed]=120; CaseAwards[2][17][aSubcount]=0;
    CaseAwards[2][18][aId]=19; CaseAwards[2][18][aRarity]=2; CaseAwards[2][18][aType]=5; CaseAwards[2][18][aInternalId]=461; CaseAwards[2][18][aCount]=0; CaseAwards[2][18][aPriceSprayed]=130; CaseAwards[2][18][aSubcount]=0;
    CaseAwards[2][19][aId]=20; CaseAwards[2][19][aRarity]=2; CaseAwards[2][19][aType]=2; CaseAwards[2][19][aInternalId]=1; CaseAwards[2][19][aCount]=1000000; CaseAwards[2][19][aPriceSprayed]=0; CaseAwards[2][19][aSubcount]=0;
    CaseAwards[2][20][aId]=21; CaseAwards[2][20][aRarity]=3; CaseAwards[2][20][aType]=9; CaseAwards[2][20][aInternalId]=3; CaseAwards[2][20][aCount]=720; CaseAwards[2][20][aPriceSprayed]=130; CaseAwards[2][20][aSubcount]=0;
    CaseAwards[2][21][aId]=22; CaseAwards[2][21][aRarity]=3; CaseAwards[2][21][aType]=11; CaseAwards[2][21][aInternalId]=134; CaseAwards[2][21][aCount]=236; CaseAwards[2][21][aPriceSprayed]=130; CaseAwards[2][21][aSubcount]=0;
    CaseAwards[2][22][aId]=23; CaseAwards[2][22][aRarity]=3; CaseAwards[2][22][aType]=5; CaseAwards[2][22][aInternalId]=2567; CaseAwards[2][22][aCount]=0; CaseAwards[2][22][aPriceSprayed]=130; CaseAwards[2][22][aSubcount]=0;
    CaseAwards[2][23][aId]=24; CaseAwards[2][23][aRarity]=3; CaseAwards[2][23][aType]=11; CaseAwards[2][23][aInternalId]=134; CaseAwards[2][23][aCount]=11935; CaseAwards[2][23][aPriceSprayed]=140; CaseAwards[2][23][aSubcount]=0;
    CaseAwards[2][24][aId]=25; CaseAwards[2][24][aRarity]=3; CaseAwards[2][24][aType]=5; CaseAwards[2][24][aInternalId]=560; CaseAwards[2][24][aCount]=0; CaseAwards[2][24][aPriceSprayed]=140; CaseAwards[2][24][aSubcount]=0;
    CaseAwards[2][25][aId]=26; CaseAwards[2][25][aRarity]=3; CaseAwards[2][25][aType]=11; CaseAwards[2][25][aInternalId]=134; CaseAwards[2][25][aCount]=5323; CaseAwards[2][25][aPriceSprayed]=140; CaseAwards[2][25][aSubcount]=0;
    CaseAwards[2][26][aId]=27; CaseAwards[2][26][aRarity]=3; CaseAwards[2][26][aType]=5; CaseAwards[2][26][aInternalId]=2584; CaseAwards[2][26][aCount]=0; CaseAwards[2][26][aPriceSprayed]=150; CaseAwards[2][26][aSubcount]=0;
    CaseAwards[2][27][aId]=28; CaseAwards[2][27][aRarity]=3; CaseAwards[2][27][aType]=5; CaseAwards[2][27][aInternalId]=2390; CaseAwards[2][27][aCount]=0; CaseAwards[2][27][aPriceSprayed]=160; CaseAwards[2][27][aSubcount]=0;
    CaseAwards[2][28][aId]=29; CaseAwards[2][28][aRarity]=3; CaseAwards[2][28][aType]=5; CaseAwards[2][28][aInternalId]=543; CaseAwards[2][28][aCount]=0; CaseAwards[2][28][aPriceSprayed]=200; CaseAwards[2][28][aSubcount]=0;
    CaseAwards[2][29][aId]=30; CaseAwards[2][29][aRarity]=3; CaseAwards[2][29][aType]=5; CaseAwards[2][29][aInternalId]=2394; CaseAwards[2][29][aCount]=0; CaseAwards[2][29][aPriceSprayed]=200; CaseAwards[2][29][aSubcount]=0;
    CaseAwards[2][30][aId]=31; CaseAwards[2][30][aRarity]=4; CaseAwards[2][30][aType]=11; CaseAwards[2][30][aInternalId]=707; CaseAwards[2][30][aCount]=1; CaseAwards[2][30][aPriceSprayed]=220; CaseAwards[2][30][aSubcount]=0;
    CaseAwards[2][31][aId]=32; CaseAwards[2][31][aRarity]=4; CaseAwards[2][31][aType]=5; CaseAwards[2][31][aInternalId]=402; CaseAwards[2][31][aCount]=0; CaseAwards[2][31][aPriceSprayed]=240; CaseAwards[2][31][aSubcount]=0;
    CaseAwards[2][32][aId]=33; CaseAwards[2][32][aRarity]=4; CaseAwards[2][32][aType]=5; CaseAwards[2][32][aInternalId]=2598; CaseAwards[2][32][aCount]=0; CaseAwards[2][32][aPriceSprayed]=250; CaseAwards[2][32][aSubcount]=0;
    CaseAwards[2][33][aId]=34; CaseAwards[2][33][aRarity]=4; CaseAwards[2][33][aType]=5; CaseAwards[2][33][aInternalId]=400; CaseAwards[2][33][aCount]=0; CaseAwards[2][33][aPriceSprayed]=260; CaseAwards[2][33][aSubcount]=0;
    CaseAwards[2][34][aId]=35; CaseAwards[2][34][aRarity]=4; CaseAwards[2][34][aType]=5; CaseAwards[2][34][aInternalId]=506; CaseAwards[2][34][aCount]=0; CaseAwards[2][34][aPriceSprayed]=270; CaseAwards[2][34][aSubcount]=0;
    CaseAwards[2][35][aId]=36; CaseAwards[2][35][aRarity]=5; CaseAwards[2][35][aType]=5; CaseAwards[2][35][aInternalId]=415; CaseAwards[2][35][aCount]=0; CaseAwards[2][35][aPriceSprayed]=400; CaseAwards[2][35][aSubcount]=0;
    CaseAwards[2][36][aId]=37; CaseAwards[2][36][aRarity]=5; CaseAwards[2][36][aType]=5; CaseAwards[2][36][aInternalId]=2543; CaseAwards[2][36][aCount]=0; CaseAwards[2][36][aPriceSprayed]=400; CaseAwards[2][36][aSubcount]=0;
    CaseBonus[2][0][bId]=1; CaseBonus[2][0][bNumberOpen]=40; CaseBonus[2][0][bRarity]=5; CaseBonus[2][0][bType]=5; CaseBonus[2][0][bInternalId]=2581; CaseBonus[2][0][bCount]=0; CaseBonus[2][0][bPriceSprayed]=400;
    CaseBonus[2][1][bId]=2; CaseBonus[2][1][bNumberOpen]=30; CaseBonus[2][1][bRarity]=4; CaseBonus[2][1][bType]=21; CaseBonus[2][1][bInternalId]=1; CaseBonus[2][1][bCount]=300; CaseBonus[2][1][bPriceSprayed]=0;
    CaseBonus[2][2][bId]=3; CaseBonus[2][2][bNumberOpen]=20; CaseBonus[2][2][bRarity]=4; CaseBonus[2][2][bType]=4; CaseBonus[2][2][bInternalId]=3; CaseBonus[2][2][bCount]=2; CaseBonus[2][2][bPriceSprayed]=0;
    CaseBonus[2][3][bId]=4; CaseBonus[2][3][bNumberOpen]=10; CaseBonus[2][3][bRarity]=3; CaseBonus[2][3][bType]=21; CaseBonus[2][3][bInternalId]=1; CaseBonus[2][3][bCount]=200; CaseBonus[2][3][bPriceSprayed]=0;
    CaseBonus[2][4][bId]=5; CaseBonus[2][4][bNumberOpen]=5; CaseBonus[2][4][bRarity]=4; CaseBonus[2][4][bType]=4; CaseBonus[2][4][bInternalId]=3; CaseBonus[2][4][bCount]=1; CaseBonus[2][4][bPriceSprayed]=0;
}

stock Cases_InitCase4Data()
{
    CaseAwards[3][0][aId]=1; CaseAwards[3][0][aRarity]=3; CaseAwards[3][0][aType]=5; CaseAwards[3][0][aInternalId]=436; CaseAwards[3][0][aCount]=0; CaseAwards[3][0][aPriceSprayed]=130; CaseAwards[3][0][aSubcount]=0;
    CaseAwards[3][1][aId]=2; CaseAwards[3][1][aRarity]=3; CaseAwards[3][1][aType]=5; CaseAwards[3][1][aInternalId]=2567; CaseAwards[3][1][aCount]=0; CaseAwards[3][1][aPriceSprayed]=130; CaseAwards[3][1][aSubcount]=0;
    CaseAwards[3][2][aId]=3; CaseAwards[3][2][aRarity]=3; CaseAwards[3][2][aType]=5; CaseAwards[3][2][aInternalId]=560; CaseAwards[3][2][aCount]=0; CaseAwards[3][2][aPriceSprayed]=140; CaseAwards[3][2][aSubcount]=0;
    CaseAwards[3][3][aId]=4; CaseAwards[3][3][aRarity]=3; CaseAwards[3][3][aType]=5; CaseAwards[3][3][aInternalId]=550; CaseAwards[3][3][aCount]=0; CaseAwards[3][3][aPriceSprayed]=140; CaseAwards[3][3][aSubcount]=0;
    CaseAwards[3][4][aId]=5; CaseAwards[3][4][aRarity]=3; CaseAwards[3][4][aType]=5; CaseAwards[3][4][aInternalId]=2584; CaseAwards[3][4][aCount]=0; CaseAwards[3][4][aPriceSprayed]=150; CaseAwards[3][4][aSubcount]=0;
    CaseAwards[3][5][aId]=6; CaseAwards[3][5][aRarity]=3; CaseAwards[3][5][aType]=5; CaseAwards[3][5][aInternalId]=603; CaseAwards[3][5][aCount]=0; CaseAwards[3][5][aPriceSprayed]=150; CaseAwards[3][5][aSubcount]=0;
    CaseAwards[3][6][aId]=7; CaseAwards[3][6][aRarity]=3; CaseAwards[3][6][aType]=5; CaseAwards[3][6][aInternalId]=2552; CaseAwards[3][6][aCount]=0; CaseAwards[3][6][aPriceSprayed]=150; CaseAwards[3][6][aSubcount]=0;
    CaseAwards[3][7][aId]=8; CaseAwards[3][7][aRarity]=3; CaseAwards[3][7][aType]=5; CaseAwards[3][7][aInternalId]=565; CaseAwards[3][7][aCount]=0; CaseAwards[3][7][aPriceSprayed]=150; CaseAwards[3][7][aSubcount]=0;
    CaseAwards[3][8][aId]=9; CaseAwards[3][8][aRarity]=3; CaseAwards[3][8][aType]=5; CaseAwards[3][8][aInternalId]=2609; CaseAwards[3][8][aCount]=0; CaseAwards[3][8][aPriceSprayed]=160; CaseAwards[3][8][aSubcount]=0;
    CaseAwards[3][9][aId]=10; CaseAwards[3][9][aRarity]=3; CaseAwards[3][9][aType]=5; CaseAwards[3][9][aInternalId]=2604; CaseAwards[3][9][aCount]=0; CaseAwards[3][9][aPriceSprayed]=160; CaseAwards[3][9][aSubcount]=0;
    CaseAwards[3][10][aId]=11; CaseAwards[3][10][aRarity]=3; CaseAwards[3][10][aType]=5; CaseAwards[3][10][aInternalId]=551; CaseAwards[3][10][aCount]=0; CaseAwards[3][10][aPriceSprayed]=160; CaseAwards[3][10][aSubcount]=0;
    CaseAwards[3][11][aId]=12; CaseAwards[3][11][aRarity]=3; CaseAwards[3][11][aType]=5; CaseAwards[3][11][aInternalId]=2390; CaseAwards[3][11][aCount]=0; CaseAwards[3][11][aPriceSprayed]=160; CaseAwards[3][11][aSubcount]=0;
    CaseAwards[3][12][aId]=13; CaseAwards[3][12][aRarity]=3; CaseAwards[3][12][aType]=5; CaseAwards[3][12][aInternalId]=526; CaseAwards[3][12][aCount]=0; CaseAwards[3][12][aPriceSprayed]=160; CaseAwards[3][12][aSubcount]=0;
    CaseAwards[3][13][aId]=14; CaseAwards[3][13][aRarity]=3; CaseAwards[3][13][aType]=5; CaseAwards[3][13][aInternalId]=2620; CaseAwards[3][13][aCount]=0; CaseAwards[3][13][aPriceSprayed]=170; CaseAwards[3][13][aSubcount]=0;
    CaseAwards[3][14][aId]=15; CaseAwards[3][14][aRarity]=3; CaseAwards[3][14][aType]=5; CaseAwards[3][14][aInternalId]=2594; CaseAwards[3][14][aCount]=0; CaseAwards[3][14][aPriceSprayed]=180; CaseAwards[3][14][aSubcount]=0;
    CaseAwards[3][15][aId]=16; CaseAwards[3][15][aRarity]=3; CaseAwards[3][15][aType]=5; CaseAwards[3][15][aInternalId]=2621; CaseAwards[3][15][aCount]=0; CaseAwards[3][15][aPriceSprayed]=180; CaseAwards[3][15][aSubcount]=0;
    CaseAwards[3][16][aId]=17; CaseAwards[3][16][aRarity]=3; CaseAwards[3][16][aType]=5; CaseAwards[3][16][aInternalId]=2387; CaseAwards[3][16][aCount]=0; CaseAwards[3][16][aPriceSprayed]=200; CaseAwards[3][16][aSubcount]=0;
    CaseAwards[3][17][aId]=18; CaseAwards[3][17][aRarity]=3; CaseAwards[3][17][aType]=5; CaseAwards[3][17][aInternalId]=480; CaseAwards[3][17][aCount]=0; CaseAwards[3][17][aPriceSprayed]=200; CaseAwards[3][17][aSubcount]=0;
    CaseAwards[3][18][aId]=19; CaseAwards[3][18][aRarity]=3; CaseAwards[3][18][aType]=5; CaseAwards[3][18][aInternalId]=2394; CaseAwards[3][18][aCount]=0; CaseAwards[3][18][aPriceSprayed]=200; CaseAwards[3][18][aSubcount]=0;
    CaseAwards[3][19][aId]=20; CaseAwards[3][19][aRarity]=3; CaseAwards[3][19][aType]=5; CaseAwards[3][19][aInternalId]=558; CaseAwards[3][19][aCount]=0; CaseAwards[3][19][aPriceSprayed]=210; CaseAwards[3][19][aSubcount]=0;
    CaseAwards[3][20][aId]=21; CaseAwards[3][20][aRarity]=4; CaseAwards[3][20][aType]=5; CaseAwards[3][20][aInternalId]=402; CaseAwards[3][20][aCount]=0; CaseAwards[3][20][aPriceSprayed]=240; CaseAwards[3][20][aSubcount]=0;
    CaseAwards[3][21][aId]=22; CaseAwards[3][21][aRarity]=4; CaseAwards[3][21][aType]=5; CaseAwards[3][21][aInternalId]=2598; CaseAwards[3][21][aCount]=0; CaseAwards[3][21][aPriceSprayed]=250; CaseAwards[3][21][aSubcount]=0;
    CaseAwards[3][22][aId]=23; CaseAwards[3][22][aRarity]=4; CaseAwards[3][22][aType]=5; CaseAwards[3][22][aInternalId]=502; CaseAwards[3][22][aCount]=0; CaseAwards[3][22][aPriceSprayed]=260; CaseAwards[3][22][aSubcount]=0;
    CaseAwards[3][23][aId]=24; CaseAwards[3][23][aRarity]=4; CaseAwards[3][23][aType]=5; CaseAwards[3][23][aInternalId]=2596; CaseAwards[3][23][aCount]=0; CaseAwards[3][23][aPriceSprayed]=260; CaseAwards[3][23][aSubcount]=0;
    CaseAwards[3][24][aId]=25; CaseAwards[3][24][aRarity]=4; CaseAwards[3][24][aType]=5; CaseAwards[3][24][aInternalId]=400; CaseAwards[3][24][aCount]=0; CaseAwards[3][24][aPriceSprayed]=260; CaseAwards[3][24][aSubcount]=0;
    CaseAwards[3][25][aId]=26; CaseAwards[3][25][aRarity]=4; CaseAwards[3][25][aType]=5; CaseAwards[3][25][aInternalId]=763; CaseAwards[3][25][aCount]=0; CaseAwards[3][25][aPriceSprayed]=280; CaseAwards[3][25][aSubcount]=0;
    CaseAwards[3][26][aId]=27; CaseAwards[3][26][aRarity]=4; CaseAwards[3][26][aType]=5; CaseAwards[3][26][aInternalId]=506; CaseAwards[3][26][aCount]=0; CaseAwards[3][26][aPriceSprayed]=270; CaseAwards[3][26][aSubcount]=0;
    CaseAwards[3][27][aId]=28; CaseAwards[3][27][aRarity]=5; CaseAwards[3][27][aType]=5; CaseAwards[3][27][aInternalId]=757; CaseAwards[3][27][aCount]=0; CaseAwards[3][27][aPriceSprayed]=400; CaseAwards[3][27][aSubcount]=0;
    CaseAwards[3][28][aId]=29; CaseAwards[3][28][aRarity]=5; CaseAwards[3][28][aType]=5; CaseAwards[3][28][aInternalId]=752; CaseAwards[3][28][aCount]=0; CaseAwards[3][28][aPriceSprayed]=400; CaseAwards[3][28][aSubcount]=0;
    CaseAwards[3][29][aId]=30; CaseAwards[3][29][aRarity]=5; CaseAwards[3][29][aType]=5; CaseAwards[3][29][aInternalId]=760; CaseAwards[3][29][aCount]=0; CaseAwards[3][29][aPriceSprayed]=450; CaseAwards[3][29][aSubcount]=0;
    CaseAwards[3][30][aId]=31; CaseAwards[3][30][aRarity]=5; CaseAwards[3][30][aType]=5; CaseAwards[3][30][aInternalId]=661; CaseAwards[3][30][aCount]=0; CaseAwards[3][30][aPriceSprayed]=430; CaseAwards[3][30][aSubcount]=0;
    CaseBonus[3][0][bId]=1; CaseBonus[3][0][bNumberOpen]=40; CaseBonus[3][0][bRarity]=5; CaseBonus[3][0][bType]=5; CaseBonus[3][0][bInternalId]=668; CaseBonus[3][0][bCount]=0; CaseBonus[3][0][bPriceSprayed]=500;
    CaseBonus[3][1][bId]=2; CaseBonus[3][1][bNumberOpen]=30; CaseBonus[3][1][bRarity]=4; CaseBonus[3][1][bType]=21; CaseBonus[3][1][bInternalId]=1; CaseBonus[3][1][bCount]=500; CaseBonus[3][1][bPriceSprayed]=0;
    CaseBonus[3][2][bId]=3; CaseBonus[3][2][bNumberOpen]=20; CaseBonus[3][2][bRarity]=4; CaseBonus[3][2][bType]=4; CaseBonus[3][2][bInternalId]=4; CaseBonus[3][2][bCount]=2; CaseBonus[3][2][bPriceSprayed]=0;
    CaseBonus[3][3][bId]=4; CaseBonus[3][3][bNumberOpen]=10; CaseBonus[3][3][bRarity]=4; CaseBonus[3][3][bType]=21; CaseBonus[3][3][bInternalId]=1; CaseBonus[3][3][bCount]=300; CaseBonus[3][3][bPriceSprayed]=0;
    CaseBonus[3][4][bId]=5; CaseBonus[3][4][bNumberOpen]=5; CaseBonus[3][4][bRarity]=4; CaseBonus[3][4][bType]=4; CaseBonus[3][4][bInternalId]=4; CaseBonus[3][4][bCount]=1; CaseBonus[3][4][bPriceSprayed]=0;
}

stock Cases_InitCase5Data()
{
    CaseAwards[4][0][aId]=1; CaseAwards[4][0][aRarity]=4; CaseAwards[4][0][aType]=5; CaseAwards[4][0][aInternalId]=410; CaseAwards[4][0][aCount]=0; CaseAwards[4][0][aPriceSprayed]=230; CaseAwards[4][0][aSubcount]=0;
    CaseAwards[4][1][aId]=2; CaseAwards[4][1][aRarity]=4; CaseAwards[4][1][aType]=5; CaseAwards[4][1][aInternalId]=604; CaseAwards[4][1][aCount]=0; CaseAwards[4][1][aPriceSprayed]=260; CaseAwards[4][1][aSubcount]=0;
    CaseAwards[4][2][aId]=3; CaseAwards[4][2][aRarity]=4; CaseAwards[4][2][aType]=5; CaseAwards[4][2][aInternalId]=2389; CaseAwards[4][2][aCount]=0; CaseAwards[4][2][aPriceSprayed]=270; CaseAwards[4][2][aSubcount]=0;
    CaseAwards[4][3][aId]=4; CaseAwards[4][3][aRarity]=4; CaseAwards[4][3][aType]=5; CaseAwards[4][3][aInternalId]=2574; CaseAwards[4][3][aCount]=0; CaseAwards[4][3][aPriceSprayed]=290; CaseAwards[4][3][aSubcount]=0;
    CaseAwards[4][4][aId]=5; CaseAwards[4][4][aRarity]=5; CaseAwards[4][4][aType]=5; CaseAwards[4][4][aInternalId]=765; CaseAwards[4][4][aCount]=0; CaseAwards[4][4][aPriceSprayed]=850; CaseAwards[4][4][aSubcount]=80;
    CaseAwards[4][5][aId]=6; CaseAwards[4][5][aRarity]=4; CaseAwards[4][5][aType]=5; CaseAwards[4][5][aInternalId]=2593; CaseAwards[4][5][aCount]=0; CaseAwards[4][5][aPriceSprayed]=340; CaseAwards[4][5][aSubcount]=0;
    CaseAwards[4][6][aId]=7; CaseAwards[4][6][aRarity]=4; CaseAwards[4][6][aType]=5; CaseAwards[4][6][aInternalId]=2585; CaseAwards[4][6][aCount]=0; CaseAwards[4][6][aPriceSprayed]=340; CaseAwards[4][6][aSubcount]=0;
    CaseAwards[4][7][aId]=8; CaseAwards[4][7][aRarity]=4; CaseAwards[4][7][aType]=5; CaseAwards[4][7][aInternalId]=2551; CaseAwards[4][7][aCount]=0; CaseAwards[4][7][aPriceSprayed]=350; CaseAwards[4][7][aSubcount]=0;
    CaseAwards[4][8][aId]=9; CaseAwards[4][8][aRarity]=4; CaseAwards[4][8][aType]=5; CaseAwards[4][8][aInternalId]=2549; CaseAwards[4][8][aCount]=0; CaseAwards[4][8][aPriceSprayed]=370; CaseAwards[4][8][aSubcount]=0;
    CaseAwards[4][9][aId]=10; CaseAwards[4][9][aRarity]=4; CaseAwards[4][9][aType]=5; CaseAwards[4][9][aInternalId]=2393; CaseAwards[4][9][aCount]=0; CaseAwards[4][9][aPriceSprayed]=370; CaseAwards[4][9][aSubcount]=0;
    CaseAwards[4][10][aId]=11; CaseAwards[4][10][aRarity]=4; CaseAwards[4][10][aType]=5; CaseAwards[4][10][aInternalId]=579; CaseAwards[4][10][aCount]=0; CaseAwards[4][10][aPriceSprayed]=370; CaseAwards[4][10][aSubcount]=0;
    CaseAwards[4][11][aId]=12; CaseAwards[4][11][aRarity]=5; CaseAwards[4][11][aType]=5; CaseAwards[4][11][aInternalId]=2619; CaseAwards[4][11][aCount]=0; CaseAwards[4][11][aPriceSprayed]=460; CaseAwards[4][11][aSubcount]=0;
    CaseAwards[4][12][aId]=13; CaseAwards[4][12][aRarity]=5; CaseAwards[4][12][aType]=5; CaseAwards[4][12][aInternalId]=657; CaseAwards[4][12][aCount]=0; CaseAwards[4][12][aPriceSprayed]=400; CaseAwards[4][12][aSubcount]=23;
    CaseAwards[4][13][aId]=14; CaseAwards[4][13][aRarity]=5; CaseAwards[4][13][aType]=5; CaseAwards[4][13][aInternalId]=669; CaseAwards[4][13][aCount]=0; CaseAwards[4][13][aPriceSprayed]=570; CaseAwards[4][13][aSubcount]=0;
    CaseAwards[4][14][aId]=15; CaseAwards[4][14][aRarity]=5; CaseAwards[4][14][aType]=5; CaseAwards[4][14][aInternalId]=2564; CaseAwards[4][14][aCount]=0; CaseAwards[4][14][aPriceSprayed]=570; CaseAwards[4][14][aSubcount]=0;
    CaseAwards[4][15][aId]=16; CaseAwards[4][15][aRarity]=5; CaseAwards[4][15][aType]=5; CaseAwards[4][15][aInternalId]=2591; CaseAwards[4][15][aCount]=0; CaseAwards[4][15][aPriceSprayed]=670; CaseAwards[4][15][aSubcount]=0;
    CaseAwards[4][16][aId]=17; CaseAwards[4][16][aRarity]=5; CaseAwards[4][16][aType]=5; CaseAwards[4][16][aInternalId]=2601; CaseAwards[4][16][aCount]=0; CaseAwards[4][16][aPriceSprayed]=800; CaseAwards[4][16][aSubcount]=0;
    CaseAwards[4][17][aId]=18; CaseAwards[4][17][aRarity]=5; CaseAwards[4][17][aType]=5; CaseAwards[4][17][aInternalId]=667; CaseAwards[4][17][aCount]=0; CaseAwards[4][17][aPriceSprayed]=850; CaseAwards[4][17][aSubcount]=0;
    CaseAwards[4][18][aId]=19; CaseAwards[4][18][aRarity]=5; CaseAwards[4][18][aType]=5; CaseAwards[4][18][aInternalId]=666; CaseAwards[4][18][aCount]=0; CaseAwards[4][18][aPriceSprayed]=900; CaseAwards[4][18][aSubcount]=0;
    CaseAwards[4][19][aId]=20; CaseAwards[4][19][aRarity]=5; CaseAwards[4][19][aType]=5; CaseAwards[4][19][aInternalId]=466; CaseAwards[4][19][aCount]=0; CaseAwards[4][19][aPriceSprayed]=900; CaseAwards[4][19][aSubcount]=1;
    CaseBonus[4][0][bId]=1; CaseBonus[4][0][bNumberOpen]=25; CaseBonus[4][0][bRarity]=5; CaseBonus[4][0][bType]=5; CaseBonus[4][0][bInternalId]=665; CaseBonus[4][0][bCount]=0; CaseBonus[4][0][bPriceSprayed]=500;
    CaseBonus[4][1][bId]=2; CaseBonus[4][1][bNumberOpen]=20; CaseBonus[4][1][bRarity]=5; CaseBonus[4][1][bType]=21; CaseBonus[4][1][bInternalId]=1; CaseBonus[4][1][bCount]=1500; CaseBonus[4][1][bPriceSprayed]=0;
    CaseBonus[4][2][bId]=3; CaseBonus[4][2][bNumberOpen]=15; CaseBonus[4][2][bRarity]=5; CaseBonus[4][2][bType]=4; CaseBonus[4][2][bInternalId]=5; CaseBonus[4][2][bCount]=2; CaseBonus[4][2][bPriceSprayed]=0;
    CaseBonus[4][3][bId]=4; CaseBonus[4][3][bNumberOpen]=10; CaseBonus[4][3][bRarity]=5; CaseBonus[4][3][bType]=21; CaseBonus[4][3][bInternalId]=1; CaseBonus[4][3][bCount]=1000; CaseBonus[4][3][bPriceSprayed]=0;
    CaseBonus[4][4][bId]=5; CaseBonus[4][4][bNumberOpen]=5; CaseBonus[4][4][bRarity]=5; CaseBonus[4][4][bType]=4; CaseBonus[4][4][bInternalId]=5; CaseBonus[4][4][bCount]=1; CaseBonus[4][4][bPriceSprayed]=0;
}

stock Cases_InitCase6Data()
{
    CaseAwards[5][0][aId]=1; CaseAwards[5][0][aRarity]=2; CaseAwards[5][0][aType]=11; CaseAwards[5][0][aInternalId]=134; CaseAwards[5][0][aCount]=12293; CaseAwards[5][0][aPriceSprayed]=100; CaseAwards[5][0][aSubcount]=0;
    CaseAwards[5][1][aId]=2; CaseAwards[5][1][aRarity]=2; CaseAwards[5][1][aType]=11; CaseAwards[5][1][aInternalId]=508; CaseAwards[5][1][aCount]=1; CaseAwards[5][1][aPriceSprayed]=100; CaseAwards[5][1][aSubcount]=0;
    CaseAwards[5][2][aId]=3; CaseAwards[5][2][aRarity]=2; CaseAwards[5][2][aType]=11; CaseAwards[5][2][aInternalId]=511; CaseAwards[5][2][aCount]=1; CaseAwards[5][2][aPriceSprayed]=100; CaseAwards[5][2][aSubcount]=0;
    CaseAwards[5][3][aId]=4; CaseAwards[5][3][aRarity]=2; CaseAwards[5][3][aType]=10; CaseAwards[5][3][aInternalId]=1; CaseAwards[5][3][aCount]=6000; CaseAwards[5][3][aPriceSprayed]=0; CaseAwards[5][3][aSubcount]=0;
    CaseAwards[5][4][aId]=5; CaseAwards[5][4][aRarity]=2; CaseAwards[5][4][aType]=11; CaseAwards[5][4][aInternalId]=890; CaseAwards[5][4][aCount]=1; CaseAwards[5][4][aPriceSprayed]=100; CaseAwards[5][4][aSubcount]=0;
    CaseAwards[5][5][aId]=6; CaseAwards[5][5][aRarity]=2; CaseAwards[5][5][aType]=11; CaseAwards[5][5][aInternalId]=360; CaseAwards[5][5][aCount]=1; CaseAwards[5][5][aPriceSprayed]=100; CaseAwards[5][5][aSubcount]=0;
    CaseAwards[5][6][aId]=7; CaseAwards[5][6][aRarity]=2; CaseAwards[5][6][aType]=3; CaseAwards[5][6][aInternalId]=1; CaseAwards[5][6][aCount]=700; CaseAwards[5][6][aPriceSprayed]=0; CaseAwards[5][6][aSubcount]=0;
    CaseAwards[5][7][aId]=8; CaseAwards[5][7][aRarity]=2; CaseAwards[5][7][aType]=11; CaseAwards[5][7][aInternalId]=134; CaseAwards[5][7][aCount]=11917; CaseAwards[5][7][aPriceSprayed]=110; CaseAwards[5][7][aSubcount]=0;
    CaseAwards[5][8][aId]=9; CaseAwards[5][8][aRarity]=2; CaseAwards[5][8][aType]=10; CaseAwards[5][8][aInternalId]=1; CaseAwards[5][8][aCount]=7000; CaseAwards[5][8][aPriceSprayed]=0; CaseAwards[5][8][aSubcount]=0;
    CaseAwards[5][9][aId]=10; CaseAwards[5][9][aRarity]=2; CaseAwards[5][9][aType]=5; CaseAwards[5][9][aInternalId]=2568; CaseAwards[5][9][aCount]=0; CaseAwards[5][9][aPriceSprayed]=110; CaseAwards[5][9][aSubcount]=0;
    CaseAwards[5][10][aId]=11; CaseAwards[5][10][aRarity]=2; CaseAwards[5][10][aType]=2; CaseAwards[5][10][aInternalId]=1; CaseAwards[5][10][aCount]=750000; CaseAwards[5][10][aPriceSprayed]=0; CaseAwards[5][10][aSubcount]=0;
    CaseAwards[5][11][aId]=12; CaseAwards[5][11][aRarity]=2; CaseAwards[5][11][aType]=11; CaseAwards[5][11][aInternalId]=891; CaseAwards[5][11][aCount]=1; CaseAwards[5][11][aPriceSprayed]=120; CaseAwards[5][11][aSubcount]=0;
    CaseAwards[5][12][aId]=13; CaseAwards[5][12][aRarity]=2; CaseAwards[5][12][aType]=10; CaseAwards[5][12][aInternalId]=1; CaseAwards[5][12][aCount]=9000; CaseAwards[5][12][aPriceSprayed]=0; CaseAwards[5][12][aSubcount]=0;
    CaseAwards[5][13][aId]=14; CaseAwards[5][13][aRarity]=2; CaseAwards[5][13][aType]=11; CaseAwards[5][13][aInternalId]=134; CaseAwards[5][13][aCount]=236; CaseAwards[5][13][aPriceSprayed]=130; CaseAwards[5][13][aSubcount]=0;
    CaseAwards[5][14][aId]=15; CaseAwards[5][14][aRarity]=3; CaseAwards[5][14][aType]=11; CaseAwards[5][14][aInternalId]=892; CaseAwards[5][14][aCount]=1; CaseAwards[5][14][aPriceSprayed]=130; CaseAwards[5][14][aSubcount]=0;
    CaseAwards[5][15][aId]=16; CaseAwards[5][15][aRarity]=3; CaseAwards[5][15][aType]=11; CaseAwards[5][15][aInternalId]=134; CaseAwards[5][15][aCount]=6889; CaseAwards[5][15][aPriceSprayed]=130; CaseAwards[5][15][aSubcount]=0;
    CaseAwards[5][16][aId]=17; CaseAwards[5][16][aRarity]=3; CaseAwards[5][16][aType]=11; CaseAwards[5][16][aInternalId]=134; CaseAwards[5][16][aCount]=6888; CaseAwards[5][16][aPriceSprayed]=140; CaseAwards[5][16][aSubcount]=0;
    CaseAwards[5][17][aId]=18; CaseAwards[5][17][aRarity]=3; CaseAwards[5][17][aType]=5; CaseAwards[5][17][aInternalId]=603; CaseAwards[5][17][aCount]=0; CaseAwards[5][17][aPriceSprayed]=140; CaseAwards[5][17][aSubcount]=0;
    CaseAwards[5][18][aId]=19; CaseAwards[5][18][aRarity]=3; CaseAwards[5][18][aType]=5; CaseAwards[5][18][aInternalId]=656; CaseAwards[5][18][aCount]=0; CaseAwards[5][18][aPriceSprayed]=160; CaseAwards[5][18][aSubcount]=22;
    CaseAwards[5][19][aId]=20; CaseAwards[5][19][aRarity]=3; CaseAwards[5][19][aType]=5; CaseAwards[5][19][aInternalId]=2625; CaseAwards[5][19][aCount]=0; CaseAwards[5][19][aPriceSprayed]=180; CaseAwards[5][19][aSubcount]=0;
    CaseAwards[5][20][aId]=21; CaseAwards[5][20][aRarity]=3; CaseAwards[5][20][aType]=5; CaseAwards[5][20][aInternalId]=503; CaseAwards[5][20][aCount]=0; CaseAwards[5][20][aPriceSprayed]=230; CaseAwards[5][20][aSubcount]=0;
    CaseAwards[5][21][aId]=22; CaseAwards[5][21][aRarity]=4; CaseAwards[5][21][aType]=5; CaseAwards[5][21][aInternalId]=2598; CaseAwards[5][21][aCount]=0; CaseAwards[5][21][aPriceSprayed]=250; CaseAwards[5][21][aSubcount]=0;
    CaseAwards[5][22][aId]=23; CaseAwards[5][22][aRarity]=4; CaseAwards[5][22][aType]=5; CaseAwards[5][22][aInternalId]=502; CaseAwards[5][22][aCount]=0; CaseAwards[5][22][aPriceSprayed]=260; CaseAwards[5][22][aSubcount]=0;
    CaseAwards[5][23][aId]=24; CaseAwards[5][23][aRarity]=4; CaseAwards[5][23][aType]=5; CaseAwards[5][23][aInternalId]=451; CaseAwards[5][23][aCount]=0; CaseAwards[5][23][aPriceSprayed]=340; CaseAwards[5][23][aSubcount]=0;
    CaseAwards[5][24][aId]=25; CaseAwards[5][24][aRarity]=5; CaseAwards[5][24][aType]=5; CaseAwards[5][24][aInternalId]=657; CaseAwards[5][24][aCount]=0; CaseAwards[5][24][aPriceSprayed]=400; CaseAwards[5][24][aSubcount]=23;
    CaseBonus[5][0][bId]=1; CaseBonus[5][0][bNumberOpen]=40; CaseBonus[5][0][bRarity]=5; CaseBonus[5][0][bType]=5; CaseBonus[5][0][bInternalId]=658; CaseBonus[5][0][bCount]=0; CaseBonus[5][0][bPriceSprayed]=100;
    CaseBonus[5][1][bId]=2; CaseBonus[5][1][bNumberOpen]=30; CaseBonus[5][1][bRarity]=4; CaseBonus[5][1][bType]=21; CaseBonus[5][1][bInternalId]=1; CaseBonus[5][1][bCount]=350; CaseBonus[5][1][bPriceSprayed]=0;
    CaseBonus[5][2][bId]=3; CaseBonus[5][2][bNumberOpen]=20; CaseBonus[5][2][bRarity]=4; CaseBonus[5][2][bType]=4; CaseBonus[5][2][bInternalId]=6; CaseBonus[5][2][bCount]=2; CaseBonus[5][2][bPriceSprayed]=0;
    CaseBonus[5][3][bId]=4; CaseBonus[5][3][bNumberOpen]=10; CaseBonus[5][3][bRarity]=4; CaseBonus[5][3][bType]=21; CaseBonus[5][3][bInternalId]=1; CaseBonus[5][3][bCount]=200; CaseBonus[5][3][bPriceSprayed]=0;
    CaseBonus[5][4][bId]=5; CaseBonus[5][4][bNumberOpen]=5; CaseBonus[5][4][bRarity]=4; CaseBonus[5][4][bType]=4; CaseBonus[5][4][bInternalId]=6; CaseBonus[5][4][bCount]=1; CaseBonus[5][4][bPriceSprayed]=0;
}

stock Cases_InitCase7Data()
{
    CaseAwards[6][0][aId]=1; CaseAwards[6][0][aRarity]=2; CaseAwards[6][0][aType]=11; CaseAwards[6][0][aInternalId]=134; CaseAwards[6][0][aCount]=12293; CaseAwards[6][0][aPriceSprayed]=100; CaseAwards[6][0][aSubcount]=0;
    CaseAwards[6][1][aId]=2; CaseAwards[6][1][aRarity]=2; CaseAwards[6][1][aType]=11; CaseAwards[6][1][aInternalId]=360; CaseAwards[6][1][aCount]=1; CaseAwards[6][1][aPriceSprayed]=100; CaseAwards[6][1][aSubcount]=0;
    CaseAwards[6][2][aId]=3; CaseAwards[6][2][aRarity]=2; CaseAwards[6][2][aType]=11; CaseAwards[6][2][aInternalId]=940; CaseAwards[6][2][aCount]=1; CaseAwards[6][2][aPriceSprayed]=120; CaseAwards[6][2][aSubcount]=0;
    CaseAwards[6][3][aId]=4; CaseAwards[6][3][aRarity]=2; CaseAwards[6][3][aType]=11; CaseAwards[6][3][aInternalId]=511; CaseAwards[6][3][aCount]=1; CaseAwards[6][3][aPriceSprayed]=100; CaseAwards[6][3][aSubcount]=0;
    CaseAwards[6][4][aId]=5; CaseAwards[6][4][aRarity]=2; CaseAwards[6][4][aType]=11; CaseAwards[6][4][aInternalId]=939; CaseAwards[6][4][aCount]=1; CaseAwards[6][4][aPriceSprayed]=100; CaseAwards[6][4][aSubcount]=0;
    CaseAwards[6][5][aId]=6; CaseAwards[6][5][aRarity]=2; CaseAwards[6][5][aType]=3; CaseAwards[6][5][aInternalId]=1; CaseAwards[6][5][aCount]=700; CaseAwards[6][5][aPriceSprayed]=0; CaseAwards[6][5][aSubcount]=0;
    CaseAwards[6][6][aId]=7; CaseAwards[6][6][aRarity]=2; CaseAwards[6][6][aType]=10; CaseAwards[6][6][aInternalId]=1; CaseAwards[6][6][aCount]=7000; CaseAwards[6][6][aPriceSprayed]=0; CaseAwards[6][6][aSubcount]=0;
    CaseAwards[6][7][aId]=8; CaseAwards[6][7][aRarity]=2; CaseAwards[6][7][aType]=11; CaseAwards[6][7][aInternalId]=134; CaseAwards[6][7][aCount]=11917; CaseAwards[6][7][aPriceSprayed]=110; CaseAwards[6][7][aSubcount]=0;
    CaseAwards[6][8][aId]=9; CaseAwards[6][8][aRarity]=2; CaseAwards[6][8][aType]=23; CaseAwards[6][8][aInternalId]=1; CaseAwards[6][8][aCount]=3000; CaseAwards[6][8][aPriceSprayed]=0; CaseAwards[6][8][aSubcount]=0;
    CaseAwards[6][9][aId]=10; CaseAwards[6][9][aRarity]=2; CaseAwards[6][9][aType]=5; CaseAwards[6][9][aInternalId]=2568; CaseAwards[6][9][aCount]=0; CaseAwards[6][9][aPriceSprayed]=110; CaseAwards[6][9][aSubcount]=0;
    CaseAwards[6][10][aId]=11; CaseAwards[6][10][aRarity]=3; CaseAwards[6][10][aType]=11; CaseAwards[6][10][aInternalId]=938; CaseAwards[6][10][aCount]=1; CaseAwards[6][10][aPriceSprayed]=140; CaseAwards[6][10][aSubcount]=0;
    CaseAwards[6][11][aId]=12; CaseAwards[6][11][aRarity]=3; CaseAwards[6][11][aType]=11; CaseAwards[6][11][aInternalId]=134; CaseAwards[6][11][aCount]=6868; CaseAwards[6][11][aPriceSprayed]=140; CaseAwards[6][11][aSubcount]=0;
    CaseAwards[6][12][aId]=13; CaseAwards[6][12][aRarity]=3; CaseAwards[6][12][aType]=11; CaseAwards[6][12][aInternalId]=134; CaseAwards[6][12][aCount]=236; CaseAwards[6][12][aPriceSprayed]=130; CaseAwards[6][12][aSubcount]=0;
    CaseAwards[6][13][aId]=14; CaseAwards[6][13][aRarity]=3; CaseAwards[6][13][aType]=5; CaseAwards[6][13][aInternalId]=603; CaseAwards[6][13][aCount]=0; CaseAwards[6][13][aPriceSprayed]=140; CaseAwards[6][13][aSubcount]=0;
    CaseAwards[6][14][aId]=15; CaseAwards[6][14][aRarity]=3; CaseAwards[6][14][aType]=23; CaseAwards[6][14][aInternalId]=1; CaseAwards[6][14][aCount]=7500; CaseAwards[6][14][aPriceSprayed]=0; CaseAwards[6][14][aSubcount]=0;
    CaseAwards[6][15][aId]=16; CaseAwards[6][15][aRarity]=3; CaseAwards[6][15][aType]=5; CaseAwards[6][15][aInternalId]=2625; CaseAwards[6][15][aCount]=0; CaseAwards[6][15][aPriceSprayed]=180; CaseAwards[6][15][aSubcount]=0;
    CaseAwards[6][16][aId]=17; CaseAwards[6][16][aRarity]=3; CaseAwards[6][16][aType]=23; CaseAwards[6][16][aInternalId]=1; CaseAwards[6][16][aCount]=5000; CaseAwards[6][16][aPriceSprayed]=0; CaseAwards[6][16][aSubcount]=0;
    CaseAwards[6][17][aId]=18; CaseAwards[6][17][aRarity]=4; CaseAwards[6][17][aType]=11; CaseAwards[6][17][aInternalId]=134; CaseAwards[6][17][aCount]=6867; CaseAwards[6][17][aPriceSprayed]=160; CaseAwards[6][17][aSubcount]=0;
    CaseAwards[6][18][aId]=19; CaseAwards[6][18][aRarity]=4; CaseAwards[6][18][aType]=5; CaseAwards[6][18][aInternalId]=503; CaseAwards[6][18][aCount]=0; CaseAwards[6][18][aPriceSprayed]=230; CaseAwards[6][18][aSubcount]=0;
    CaseAwards[6][19][aId]=20; CaseAwards[6][19][aRarity]=4; CaseAwards[6][19][aType]=23; CaseAwards[6][19][aInternalId]=1; CaseAwards[6][19][aCount]=15000; CaseAwards[6][19][aPriceSprayed]=0; CaseAwards[6][19][aSubcount]=0;
    CaseAwards[6][20][aId]=21; CaseAwards[6][20][aRarity]=4; CaseAwards[6][20][aType]=5; CaseAwards[6][20][aInternalId]=2598; CaseAwards[6][20][aCount]=0; CaseAwards[6][20][aPriceSprayed]=250; CaseAwards[6][20][aSubcount]=0;
    CaseAwards[6][21][aId]=22; CaseAwards[6][21][aRarity]=4; CaseAwards[6][21][aType]=5; CaseAwards[6][21][aInternalId]=502; CaseAwards[6][21][aCount]=0; CaseAwards[6][21][aPriceSprayed]=260; CaseAwards[6][21][aSubcount]=0;
    CaseAwards[6][22][aId]=23; CaseAwards[6][22][aRarity]=4; CaseAwards[6][22][aType]=5; CaseAwards[6][22][aInternalId]=451; CaseAwards[6][22][aCount]=0; CaseAwards[6][22][aPriceSprayed]=340; CaseAwards[6][22][aSubcount]=0;
    CaseAwards[6][23][aId]=24; CaseAwards[6][23][aRarity]=4; CaseAwards[6][23][aType]=5; CaseAwards[6][23][aInternalId]=633; CaseAwards[6][23][aCount]=0; CaseAwards[6][23][aPriceSprayed]=180; CaseAwards[6][23][aSubcount]=35;
    CaseAwards[6][24][aId]=25; CaseAwards[6][24][aRarity]=5; CaseAwards[6][24][aType]=5; CaseAwards[6][24][aInternalId]=632; CaseAwards[6][24][aCount]=0; CaseAwards[6][24][aPriceSprayed]=490; CaseAwards[6][24][aSubcount]=34;
    CaseBonus[6][0][bId]=1; CaseBonus[6][0][bNumberOpen]=40; CaseBonus[6][0][bRarity]=5; CaseBonus[6][0][bType]=5; CaseBonus[6][0][bInternalId]=634; CaseBonus[6][0][bCount]=0; CaseBonus[6][0][bPriceSprayed]=200;
    CaseBonus[6][1][bId]=2; CaseBonus[6][1][bNumberOpen]=30; CaseBonus[6][1][bRarity]=4; CaseBonus[6][1][bType]=23; CaseBonus[6][1][bInternalId]=1; CaseBonus[6][1][bCount]=10000; CaseBonus[6][1][bPriceSprayed]=0;
    CaseBonus[6][2][bId]=3; CaseBonus[6][2][bNumberOpen]=20; CaseBonus[6][2][bRarity]=4; CaseBonus[6][2][bType]=4; CaseBonus[6][2][bInternalId]=7; CaseBonus[6][2][bCount]=2; CaseBonus[6][2][bPriceSprayed]=0;
    CaseBonus[6][3][bId]=4; CaseBonus[6][3][bNumberOpen]=10; CaseBonus[6][3][bRarity]=4; CaseBonus[6][3][bType]=23; CaseBonus[6][3][bInternalId]=1; CaseBonus[6][3][bCount]=5000; CaseBonus[6][3][bPriceSprayed]=0;
    CaseBonus[6][4][bId]=5; CaseBonus[6][4][bNumberOpen]=5; CaseBonus[6][4][bRarity]=4; CaseBonus[6][4][bType]=4; CaseBonus[6][4][bInternalId]=7; CaseBonus[6][4][bCount]=1; CaseBonus[6][4][bPriceSprayed]=0;
}

stock Cases_InitCase8Data()
{
    CaseAwards[7][0][aId]=1; CaseAwards[7][0][aRarity]=2; CaseAwards[7][0][aType]=11; CaseAwards[7][0][aInternalId]=134; CaseAwards[7][0][aCount]=14386; CaseAwards[7][0][aPriceSprayed]=100; CaseAwards[7][0][aSubcount]=0;
    CaseAwards[7][1][aId]=2; CaseAwards[7][1][aRarity]=2; CaseAwards[7][1][aType]=11; CaseAwards[7][1][aInternalId]=360; CaseAwards[7][1][aCount]=1; CaseAwards[7][1][aPriceSprayed]=100; CaseAwards[7][1][aSubcount]=0;
    CaseAwards[7][2][aId]=3; CaseAwards[7][2][aRarity]=2; CaseAwards[7][2][aType]=11; CaseAwards[7][2][aInternalId]=946; CaseAwards[7][2][aCount]=1; CaseAwards[7][2][aPriceSprayed]=120; CaseAwards[7][2][aSubcount]=0;
    CaseAwards[7][3][aId]=4; CaseAwards[7][3][aRarity]=2; CaseAwards[7][3][aType]=11; CaseAwards[7][3][aInternalId]=511; CaseAwards[7][3][aCount]=1; CaseAwards[7][3][aPriceSprayed]=100; CaseAwards[7][3][aSubcount]=0;
    CaseAwards[7][4][aId]=5; CaseAwards[7][4][aRarity]=2; CaseAwards[7][4][aType]=11; CaseAwards[7][4][aInternalId]=945; CaseAwards[7][4][aCount]=1; CaseAwards[7][4][aPriceSprayed]=100; CaseAwards[7][4][aSubcount]=0;
    CaseAwards[7][5][aId]=6; CaseAwards[7][5][aRarity]=2; CaseAwards[7][5][aType]=3; CaseAwards[7][5][aInternalId]=1; CaseAwards[7][5][aCount]=700; CaseAwards[7][5][aPriceSprayed]=0; CaseAwards[7][5][aSubcount]=0;
    CaseAwards[7][6][aId]=7; CaseAwards[7][6][aRarity]=2; CaseAwards[7][6][aType]=10; CaseAwards[7][6][aInternalId]=1; CaseAwards[7][6][aCount]=7000; CaseAwards[7][6][aPriceSprayed]=0; CaseAwards[7][6][aSubcount]=0;
    CaseAwards[7][7][aId]=8; CaseAwards[7][7][aRarity]=2; CaseAwards[7][7][aType]=11; CaseAwards[7][7][aInternalId]=134; CaseAwards[7][7][aCount]=11917; CaseAwards[7][7][aPriceSprayed]=110; CaseAwards[7][7][aSubcount]=0;
    CaseAwards[7][8][aId]=9; CaseAwards[7][8][aRarity]=2; CaseAwards[7][8][aType]=23; CaseAwards[7][8][aInternalId]=1; CaseAwards[7][8][aCount]=3000; CaseAwards[7][8][aPriceSprayed]=0; CaseAwards[7][8][aSubcount]=0;
    CaseAwards[7][9][aId]=10; CaseAwards[7][9][aRarity]=2; CaseAwards[7][9][aType]=5; CaseAwards[7][9][aInternalId]=2568; CaseAwards[7][9][aCount]=0; CaseAwards[7][9][aPriceSprayed]=110; CaseAwards[7][9][aSubcount]=0;
    CaseAwards[7][10][aId]=11; CaseAwards[7][10][aRarity]=3; CaseAwards[7][10][aType]=11; CaseAwards[7][10][aInternalId]=944; CaseAwards[7][10][aCount]=1; CaseAwards[7][10][aPriceSprayed]=140; CaseAwards[7][10][aSubcount]=0;
    CaseAwards[7][11][aId]=12; CaseAwards[7][11][aRarity]=3; CaseAwards[7][11][aType]=11; CaseAwards[7][11][aInternalId]=134; CaseAwards[7][11][aCount]=5885; CaseAwards[7][11][aPriceSprayed]=140; CaseAwards[7][11][aSubcount]=0;
    CaseAwards[7][12][aId]=13; CaseAwards[7][12][aRarity]=3; CaseAwards[7][12][aType]=11; CaseAwards[7][12][aInternalId]=134; CaseAwards[7][12][aCount]=5326; CaseAwards[7][12][aPriceSprayed]=130; CaseAwards[7][12][aSubcount]=0;
    CaseAwards[7][13][aId]=14; CaseAwards[7][13][aRarity]=3; CaseAwards[7][13][aType]=5; CaseAwards[7][13][aInternalId]=603; CaseAwards[7][13][aCount]=0; CaseAwards[7][13][aPriceSprayed]=140; CaseAwards[7][13][aSubcount]=0;
    CaseAwards[7][14][aId]=15; CaseAwards[7][14][aRarity]=3; CaseAwards[7][14][aType]=23; CaseAwards[7][14][aInternalId]=1; CaseAwards[7][14][aCount]=7500; CaseAwards[7][14][aPriceSprayed]=0; CaseAwards[7][14][aSubcount]=0;
    CaseAwards[7][15][aId]=16; CaseAwards[7][15][aRarity]=3; CaseAwards[7][15][aType]=5; CaseAwards[7][15][aInternalId]=442; CaseAwards[7][15][aCount]=0; CaseAwards[7][15][aPriceSprayed]=170; CaseAwards[7][15][aSubcount]=0;
    CaseAwards[7][16][aId]=17; CaseAwards[7][16][aRarity]=3; CaseAwards[7][16][aType]=23; CaseAwards[7][16][aInternalId]=1; CaseAwards[7][16][aCount]=5000; CaseAwards[7][16][aPriceSprayed]=0; CaseAwards[7][16][aSubcount]=0;
    CaseAwards[7][17][aId]=18; CaseAwards[7][17][aRarity]=4; CaseAwards[7][17][aType]=11; CaseAwards[7][17][aInternalId]=134; CaseAwards[7][17][aCount]=5884; CaseAwards[7][17][aPriceSprayed]=160; CaseAwards[7][17][aSubcount]=0;
    CaseAwards[7][18][aId]=19; CaseAwards[7][18][aRarity]=4; CaseAwards[7][18][aType]=5; CaseAwards[7][18][aInternalId]=503; CaseAwards[7][18][aCount]=0; CaseAwards[7][18][aPriceSprayed]=230; CaseAwards[7][18][aSubcount]=0;
    CaseAwards[7][19][aId]=20; CaseAwards[7][19][aRarity]=4; CaseAwards[7][19][aType]=23; CaseAwards[7][19][aInternalId]=1; CaseAwards[7][19][aCount]=15000; CaseAwards[7][19][aPriceSprayed]=0; CaseAwards[7][19][aSubcount]=0;
    CaseAwards[7][20][aId]=21; CaseAwards[7][20][aRarity]=4; CaseAwards[7][20][aType]=5; CaseAwards[7][20][aInternalId]=2603; CaseAwards[7][20][aCount]=0; CaseAwards[7][20][aPriceSprayed]=250; CaseAwards[7][20][aSubcount]=0;
    CaseAwards[7][21][aId]=22; CaseAwards[7][21][aRarity]=4; CaseAwards[7][21][aType]=5; CaseAwards[7][21][aInternalId]=502; CaseAwards[7][21][aCount]=0; CaseAwards[7][21][aPriceSprayed]=260; CaseAwards[7][21][aSubcount]=0;
    CaseAwards[7][22][aId]=23; CaseAwards[7][22][aRarity]=4; CaseAwards[7][22][aType]=5; CaseAwards[7][22][aInternalId]=2599; CaseAwards[7][22][aCount]=0; CaseAwards[7][22][aPriceSprayed]=340; CaseAwards[7][22][aSubcount]=0;
    CaseAwards[7][23][aId]=24; CaseAwards[7][23][aRarity]=4; CaseAwards[7][23][aType]=5; CaseAwards[7][23][aInternalId]=659; CaseAwards[7][23][aCount]=0; CaseAwards[7][23][aPriceSprayed]=180; CaseAwards[7][23][aSubcount]=48;
    CaseAwards[7][24][aId]=25; CaseAwards[7][24][aRarity]=5; CaseAwards[7][24][aType]=5; CaseAwards[7][24][aInternalId]=661; CaseAwards[7][24][aCount]=0; CaseAwards[7][24][aPriceSprayed]=490; CaseAwards[7][24][aSubcount]=49;
    CaseBonus[7][0][bId]=1; CaseBonus[7][0][bNumberOpen]=40; CaseBonus[7][0][bRarity]=5; CaseBonus[7][0][bType]=5; CaseBonus[7][0][bInternalId]=660; CaseBonus[7][0][bCount]=0; CaseBonus[7][0][bPriceSprayed]=200;
    CaseBonus[7][1][bId]=2; CaseBonus[7][1][bNumberOpen]=30; CaseBonus[7][1][bRarity]=4; CaseBonus[7][1][bType]=23; CaseBonus[7][1][bInternalId]=1; CaseBonus[7][1][bCount]=10000; CaseBonus[7][1][bPriceSprayed]=0;
    CaseBonus[7][2][bId]=3; CaseBonus[7][2][bNumberOpen]=20; CaseBonus[7][2][bRarity]=4; CaseBonus[7][2][bType]=4; CaseBonus[7][2][bInternalId]=8; CaseBonus[7][2][bCount]=2; CaseBonus[7][2][bPriceSprayed]=0;
    CaseBonus[7][3][bId]=4; CaseBonus[7][3][bNumberOpen]=10; CaseBonus[7][3][bRarity]=4; CaseBonus[7][3][bType]=23; CaseBonus[7][3][bInternalId]=1; CaseBonus[7][3][bCount]=5000; CaseBonus[7][3][bPriceSprayed]=0;
    CaseBonus[7][4][bId]=5; CaseBonus[7][4][bNumberOpen]=5; CaseBonus[7][4][bRarity]=4; CaseBonus[7][4][bType]=4; CaseBonus[7][4][bInternalId]=8; CaseBonus[7][4][bCount]=1; CaseBonus[7][4][bPriceSprayed]=0;
}

stock Cases_InitCase9Data()
{
    CaseAwards[8][0][aId]=1; CaseAwards[8][0][aRarity]=2; CaseAwards[8][0][aType]=11; CaseAwards[8][0][aInternalId]=134; CaseAwards[8][0][aCount]=11960; CaseAwards[8][0][aPriceSprayed]=120; CaseAwards[8][0][aSubcount]=0;
    CaseAwards[8][1][aId]=2; CaseAwards[8][1][aRarity]=2; CaseAwards[8][1][aType]=11; CaseAwards[8][1][aInternalId]=360; CaseAwards[8][1][aCount]=1; CaseAwards[8][1][aPriceSprayed]=100; CaseAwards[8][1][aSubcount]=0;
    CaseAwards[8][2][aId]=3; CaseAwards[8][2][aRarity]=2; CaseAwards[8][2][aType]=11; CaseAwards[8][2][aInternalId]=324; CaseAwards[8][2][aCount]=1; CaseAwards[8][2][aPriceSprayed]=90; CaseAwards[8][2][aSubcount]=0;
    CaseAwards[8][3][aId]=4; CaseAwards[8][3][aRarity]=2; CaseAwards[8][3][aType]=11; CaseAwards[8][3][aInternalId]=511; CaseAwards[8][3][aCount]=1; CaseAwards[8][3][aPriceSprayed]=100; CaseAwards[8][3][aSubcount]=0;
    CaseAwards[8][4][aId]=5; CaseAwards[8][4][aRarity]=4; CaseAwards[8][4][aType]=11; CaseAwards[8][4][aInternalId]=966; CaseAwards[8][4][aCount]=1; CaseAwards[8][4][aPriceSprayed]=100; CaseAwards[8][4][aSubcount]=0;
    CaseAwards[8][5][aId]=6; CaseAwards[8][5][aRarity]=2; CaseAwards[8][5][aType]=3; CaseAwards[8][5][aInternalId]=1; CaseAwards[8][5][aCount]=700; CaseAwards[8][5][aPriceSprayed]=0; CaseAwards[8][5][aSubcount]=0;
    CaseAwards[8][6][aId]=7; CaseAwards[8][6][aRarity]=2; CaseAwards[8][6][aType]=10; CaseAwards[8][6][aInternalId]=1; CaseAwards[8][6][aCount]=5000; CaseAwards[8][6][aPriceSprayed]=0; CaseAwards[8][6][aSubcount]=0;
    CaseAwards[8][7][aId]=8; CaseAwards[8][7][aRarity]=2; CaseAwards[8][7][aType]=11; CaseAwards[8][7][aInternalId]=134; CaseAwards[8][7][aCount]=11917; CaseAwards[8][7][aPriceSprayed]=110; CaseAwards[8][7][aSubcount]=0;
    CaseAwards[8][8][aId]=9; CaseAwards[8][8][aRarity]=2; CaseAwards[8][8][aType]=23; CaseAwards[8][8][aInternalId]=1; CaseAwards[8][8][aCount]=3000; CaseAwards[8][8][aPriceSprayed]=0; CaseAwards[8][8][aSubcount]=0;
    CaseAwards[8][9][aId]=10; CaseAwards[8][9][aRarity]=2; CaseAwards[8][9][aType]=5; CaseAwards[8][9][aInternalId]=2568; CaseAwards[8][9][aCount]=0; CaseAwards[8][9][aPriceSprayed]=110; CaseAwards[8][9][aSubcount]=0;
    CaseAwards[8][10][aId]=11; CaseAwards[8][10][aRarity]=3; CaseAwards[8][10][aType]=11; CaseAwards[8][10][aInternalId]=965; CaseAwards[8][10][aCount]=1; CaseAwards[8][10][aPriceSprayed]=140; CaseAwards[8][10][aSubcount]=0;
    CaseAwards[8][11][aId]=12; CaseAwards[8][11][aRarity]=3; CaseAwards[8][11][aType]=11; CaseAwards[8][11][aInternalId]=134; CaseAwards[8][11][aCount]=5894; CaseAwards[8][11][aPriceSprayed]=140; CaseAwards[8][11][aSubcount]=0;
    CaseAwards[8][12][aId]=13; CaseAwards[8][12][aRarity]=3; CaseAwards[8][12][aType]=11; CaseAwards[8][12][aInternalId]=134; CaseAwards[8][12][aCount]=5365; CaseAwards[8][12][aPriceSprayed]=140; CaseAwards[8][12][aSubcount]=0;
    CaseAwards[8][13][aId]=14; CaseAwards[8][13][aRarity]=3; CaseAwards[8][13][aType]=5; CaseAwards[8][13][aInternalId]=603; CaseAwards[8][13][aCount]=0; CaseAwards[8][13][aPriceSprayed]=140; CaseAwards[8][13][aSubcount]=0;
    CaseAwards[8][14][aId]=15; CaseAwards[8][14][aRarity]=3; CaseAwards[8][14][aType]=23; CaseAwards[8][14][aInternalId]=1; CaseAwards[8][14][aCount]=7500; CaseAwards[8][14][aPriceSprayed]=0; CaseAwards[8][14][aSubcount]=0;
    CaseAwards[8][15][aId]=16; CaseAwards[8][15][aRarity]=3; CaseAwards[8][15][aType]=5; CaseAwards[8][15][aInternalId]=2625; CaseAwards[8][15][aCount]=0; CaseAwards[8][15][aPriceSprayed]=180; CaseAwards[8][15][aSubcount]=0;
    CaseAwards[8][16][aId]=17; CaseAwards[8][16][aRarity]=3; CaseAwards[8][16][aType]=23; CaseAwards[8][16][aInternalId]=1; CaseAwards[8][16][aCount]=5000; CaseAwards[8][16][aPriceSprayed]=0; CaseAwards[8][16][aSubcount]=0;
    CaseAwards[8][17][aId]=18; CaseAwards[8][17][aRarity]=4; CaseAwards[8][17][aType]=11; CaseAwards[8][17][aInternalId]=134; CaseAwards[8][17][aCount]=5893; CaseAwards[8][17][aPriceSprayed]=160; CaseAwards[8][17][aSubcount]=0;
    CaseAwards[8][18][aId]=19; CaseAwards[8][18][aRarity]=4; CaseAwards[8][18][aType]=5; CaseAwards[8][18][aInternalId]=503; CaseAwards[8][18][aCount]=0; CaseAwards[8][18][aPriceSprayed]=230; CaseAwards[8][18][aSubcount]=0;
    CaseAwards[8][19][aId]=20; CaseAwards[8][19][aRarity]=4; CaseAwards[8][19][aType]=23; CaseAwards[8][19][aInternalId]=1; CaseAwards[8][19][aCount]=15000; CaseAwards[8][19][aPriceSprayed]=0; CaseAwards[8][19][aSubcount]=0;
    CaseAwards[8][20][aId]=21; CaseAwards[8][20][aRarity]=4; CaseAwards[8][20][aType]=5; CaseAwards[8][20][aInternalId]=2553; CaseAwards[8][20][aCount]=0; CaseAwards[8][20][aPriceSprayed]=240; CaseAwards[8][20][aSubcount]=0;
    CaseAwards[8][21][aId]=22; CaseAwards[8][21][aRarity]=4; CaseAwards[8][21][aType]=5; CaseAwards[8][21][aInternalId]=502; CaseAwards[8][21][aCount]=0; CaseAwards[8][21][aPriceSprayed]=260; CaseAwards[8][21][aSubcount]=0;
    CaseAwards[8][22][aId]=23; CaseAwards[8][22][aRarity]=4; CaseAwards[8][22][aType]=5; CaseAwards[8][22][aInternalId]=429; CaseAwards[8][22][aCount]=0; CaseAwards[8][22][aPriceSprayed]=330; CaseAwards[8][22][aSubcount]=0;
    CaseAwards[8][23][aId]=24; CaseAwards[8][23][aRarity]=4; CaseAwards[8][23][aType]=5; CaseAwards[8][23][aInternalId]=756; CaseAwards[8][23][aCount]=0; CaseAwards[8][23][aPriceSprayed]=160; CaseAwards[8][23][aSubcount]=60;
    CaseAwards[8][24][aId]=25; CaseAwards[8][24][aRarity]=5; CaseAwards[8][24][aType]=5; CaseAwards[8][24][aInternalId]=755; CaseAwards[8][24][aCount]=0; CaseAwards[8][24][aPriceSprayed]=600; CaseAwards[8][24][aSubcount]=59;
    CaseBonus[8][0][bId]=1; CaseBonus[8][0][bNumberOpen]=40; CaseBonus[8][0][bRarity]=5; CaseBonus[8][0][bType]=5; CaseBonus[8][0][bInternalId]=573; CaseBonus[8][0][bCount]=0; CaseBonus[8][0][bPriceSprayed]=400;
    CaseBonus[8][1][bId]=2; CaseBonus[8][1][bNumberOpen]=30; CaseBonus[8][1][bRarity]=4; CaseBonus[8][1][bType]=23; CaseBonus[8][1][bInternalId]=1; CaseBonus[8][1][bCount]=10000; CaseBonus[8][1][bPriceSprayed]=0;
    CaseBonus[8][2][bId]=3; CaseBonus[8][2][bNumberOpen]=20; CaseBonus[8][2][bRarity]=4; CaseBonus[8][2][bType]=4; CaseBonus[8][2][bInternalId]=9; CaseBonus[8][2][bCount]=2; CaseBonus[8][2][bPriceSprayed]=0;
    CaseBonus[8][3][bId]=4; CaseBonus[8][3][bNumberOpen]=10; CaseBonus[8][3][bRarity]=4; CaseBonus[8][3][bType]=23; CaseBonus[8][3][bInternalId]=1; CaseBonus[8][3][bCount]=5000; CaseBonus[8][3][bPriceSprayed]=0;
    CaseBonus[8][4][bId]=5; CaseBonus[8][4][bNumberOpen]=5; CaseBonus[8][4][bRarity]=4; CaseBonus[8][4][bType]=4; CaseBonus[8][4][bInternalId]=9; CaseBonus[8][4][bCount]=1; CaseBonus[8][4][bPriceSprayed]=0;
}

stock Cases_InitCase10Data()
{
    CaseAwards[9][0][aId]=1; CaseAwards[9][0][aRarity]=2; CaseAwards[9][0][aType]=11; CaseAwards[9][0][aInternalId]=134; CaseAwards[9][0][aCount]=12291; CaseAwards[9][0][aPriceSprayed]=100; CaseAwards[9][0][aSubcount]=0;
    CaseAwards[9][1][aId]=2; CaseAwards[9][1][aRarity]=2; CaseAwards[9][1][aType]=11; CaseAwards[9][1][aInternalId]=360; CaseAwards[9][1][aCount]=1; CaseAwards[9][1][aPriceSprayed]=100; CaseAwards[9][1][aSubcount]=0;
    CaseAwards[9][2][aId]=3; CaseAwards[9][2][aRarity]=2; CaseAwards[9][2][aType]=5; CaseAwards[9][2][aInternalId]=2384; CaseAwards[9][2][aCount]=0; CaseAwards[9][2][aPriceSprayed]=110; CaseAwards[9][2][aSubcount]=0;
    CaseAwards[9][3][aId]=4; CaseAwards[9][3][aRarity]=2; CaseAwards[9][3][aType]=11; CaseAwards[9][3][aInternalId]=583; CaseAwards[9][3][aCount]=1; CaseAwards[9][3][aPriceSprayed]=100; CaseAwards[9][3][aSubcount]=0;
    CaseAwards[9][4][aId]=5; CaseAwards[9][4][aRarity]=2; CaseAwards[9][4][aType]=11; CaseAwards[9][4][aInternalId]=134; CaseAwards[9][4][aCount]=252; CaseAwards[9][4][aPriceSprayed]=110; CaseAwards[9][4][aSubcount]=0;
    CaseAwards[9][5][aId]=6; CaseAwards[9][5][aRarity]=2; CaseAwards[9][5][aType]=3; CaseAwards[9][5][aInternalId]=1; CaseAwards[9][5][aCount]=700; CaseAwards[9][5][aPriceSprayed]=0; CaseAwards[9][5][aSubcount]=0;
    CaseAwards[9][6][aId]=7; CaseAwards[9][6][aRarity]=2; CaseAwards[9][6][aType]=2; CaseAwards[9][6][aInternalId]=1; CaseAwards[9][6][aCount]=900000; CaseAwards[9][6][aPriceSprayed]=0; CaseAwards[9][6][aSubcount]=0;
    CaseAwards[9][7][aId]=8; CaseAwards[9][7][aRarity]=2; CaseAwards[9][7][aType]=11; CaseAwards[9][7][aInternalId]=134; CaseAwards[9][7][aCount]=11917; CaseAwards[9][7][aPriceSprayed]=110; CaseAwards[9][7][aSubcount]=0;
    CaseAwards[9][8][aId]=9; CaseAwards[9][8][aRarity]=2; CaseAwards[9][8][aType]=10; CaseAwards[9][8][aInternalId]=1; CaseAwards[9][8][aCount]=6000; CaseAwards[9][8][aPriceSprayed]=0; CaseAwards[9][8][aSubcount]=0;
    CaseAwards[9][9][aId]=10; CaseAwards[9][9][aRarity]=2; CaseAwards[9][9][aType]=5; CaseAwards[9][9][aInternalId]=2568; CaseAwards[9][9][aCount]=0; CaseAwards[9][9][aPriceSprayed]=110; CaseAwards[9][9][aSubcount]=0;
    CaseAwards[9][10][aId]=11; CaseAwards[9][10][aRarity]=2; CaseAwards[9][10][aType]=11; CaseAwards[9][10][aInternalId]=970; CaseAwards[9][10][aCount]=1; CaseAwards[9][10][aPriceSprayed]=120; CaseAwards[9][10][aSubcount]=0;
    CaseAwards[9][11][aId]=12; CaseAwards[9][11][aRarity]=2; CaseAwards[9][11][aType]=11; CaseAwards[9][11][aInternalId]=134; CaseAwards[9][11][aCount]=14388; CaseAwards[9][11][aPriceSprayed]=100; CaseAwards[9][11][aSubcount]=0;
    CaseAwards[9][12][aId]=13; CaseAwards[9][12][aRarity]=3; CaseAwards[9][12][aType]=11; CaseAwards[9][12][aInternalId]=134; CaseAwards[9][12][aCount]=6895; CaseAwards[9][12][aPriceSprayed]=140; CaseAwards[9][12][aSubcount]=0;
    CaseAwards[9][13][aId]=14; CaseAwards[9][13][aRarity]=3; CaseAwards[9][13][aType]=5; CaseAwards[9][13][aInternalId]=603; CaseAwards[9][13][aCount]=0; CaseAwards[9][13][aPriceSprayed]=140; CaseAwards[9][13][aSubcount]=0;
    CaseAwards[9][14][aId]=15; CaseAwards[9][14][aRarity]=3; CaseAwards[9][14][aType]=10; CaseAwards[9][14][aInternalId]=1; CaseAwards[9][14][aCount]=7000; CaseAwards[9][14][aPriceSprayed]=0; CaseAwards[9][14][aSubcount]=0;
    CaseAwards[9][15][aId]=16; CaseAwards[9][15][aRarity]=3; CaseAwards[9][15][aType]=5; CaseAwards[9][15][aInternalId]=2382; CaseAwards[9][15][aCount]=0; CaseAwards[9][15][aPriceSprayed]=180; CaseAwards[9][15][aSubcount]=0;
    CaseAwards[9][16][aId]=17; CaseAwards[9][16][aRarity]=3; CaseAwards[9][16][aType]=2; CaseAwards[9][16][aInternalId]=1; CaseAwards[9][16][aCount]=1200000; CaseAwards[9][16][aPriceSprayed]=0; CaseAwards[9][16][aSubcount]=0;
    CaseAwards[9][17][aId]=18; CaseAwards[9][17][aRarity]=4; CaseAwards[9][17][aType]=11; CaseAwards[9][17][aInternalId]=134; CaseAwards[9][17][aCount]=5898; CaseAwards[9][17][aPriceSprayed]=230; CaseAwards[9][17][aSubcount]=0;
    CaseAwards[9][18][aId]=19; CaseAwards[9][18][aRarity]=4; CaseAwards[9][18][aType]=5; CaseAwards[9][18][aInternalId]=503; CaseAwards[9][18][aCount]=0; CaseAwards[9][18][aPriceSprayed]=230; CaseAwards[9][18][aSubcount]=0;
    CaseAwards[9][19][aId]=20; CaseAwards[9][19][aRarity]=3; CaseAwards[9][19][aType]=10; CaseAwards[9][19][aInternalId]=1; CaseAwards[9][19][aCount]=10000; CaseAwards[9][19][aPriceSprayed]=0; CaseAwards[9][19][aSubcount]=0;
    CaseAwards[9][20][aId]=21; CaseAwards[9][20][aRarity]=4; CaseAwards[9][20][aType]=5; CaseAwards[9][20][aInternalId]=2617; CaseAwards[9][20][aCount]=0; CaseAwards[9][20][aPriceSprayed]=340; CaseAwards[9][20][aSubcount]=0;
    CaseAwards[9][21][aId]=22; CaseAwards[9][21][aRarity]=4; CaseAwards[9][21][aType]=5; CaseAwards[9][21][aInternalId]=502; CaseAwards[9][21][aCount]=0; CaseAwards[9][21][aPriceSprayed]=260; CaseAwards[9][21][aSubcount]=0;
    CaseAwards[9][22][aId]=23; CaseAwards[9][22][aRarity]=4; CaseAwards[9][22][aType]=5; CaseAwards[9][22][aInternalId]=429; CaseAwards[9][22][aCount]=0; CaseAwards[9][22][aPriceSprayed]=330; CaseAwards[9][22][aSubcount]=0;
    CaseAwards[9][23][aId]=24; CaseAwards[9][23][aRarity]=5; CaseAwards[9][23][aType]=5; CaseAwards[9][23][aInternalId]=470; CaseAwards[9][23][aCount]=0; CaseAwards[9][23][aPriceSprayed]=700; CaseAwards[9][23][aSubcount]=0;
    CaseAwards[9][24][aId]=25; CaseAwards[9][24][aRarity]=5; CaseAwards[9][24][aType]=5; CaseAwards[9][24][aInternalId]=758; CaseAwards[9][24][aCount]=0; CaseAwards[9][24][aPriceSprayed]=390; CaseAwards[9][24][aSubcount]=68;
    CaseBonus[9][0][bId]=1; CaseBonus[9][0][bNumberOpen]=40; CaseBonus[9][0][bRarity]=5; CaseBonus[9][0][bType]=5; CaseBonus[9][0][bInternalId]=614; CaseBonus[9][0][bCount]=0; CaseBonus[9][0][bPriceSprayed]=330;
    CaseBonus[9][1][bId]=2; CaseBonus[9][1][bNumberOpen]=30; CaseBonus[9][1][bRarity]=4; CaseBonus[9][1][bType]=21; CaseBonus[9][1][bInternalId]=1; CaseBonus[9][1][bCount]=400; CaseBonus[9][1][bPriceSprayed]=0;
    CaseBonus[9][2][bId]=3; CaseBonus[9][2][bNumberOpen]=20; CaseBonus[9][2][bRarity]=4; CaseBonus[9][2][bType]=4; CaseBonus[9][2][bInternalId]=10; CaseBonus[9][2][bCount]=2; CaseBonus[9][2][bPriceSprayed]=0;
    CaseBonus[9][3][bId]=4; CaseBonus[9][3][bNumberOpen]=10; CaseBonus[9][3][bRarity]=4; CaseBonus[9][3][bType]=21; CaseBonus[9][3][bInternalId]=1; CaseBonus[9][3][bCount]=300; CaseBonus[9][3][bPriceSprayed]=0;
    CaseBonus[9][4][bId]=5; CaseBonus[9][4][bNumberOpen]=5; CaseBonus[9][4][bRarity]=4; CaseBonus[9][4][bType]=4; CaseBonus[9][4][bInternalId]=10; CaseBonus[9][4][bCount]=1; CaseBonus[9][4][bPriceSprayed]=0;
}

stock Cases_InitCase11Data()
{
    CaseAwards[10][0][aId]=1; CaseAwards[10][0][aRarity]=2; CaseAwards[10][0][aType]=11; CaseAwards[10][0][aInternalId]=134; CaseAwards[10][0][aCount]=14388; CaseAwards[10][0][aPriceSprayed]=100; CaseAwards[10][0][aSubcount]=0;
    CaseAwards[10][1][aId]=2; CaseAwards[10][1][aRarity]=2; CaseAwards[10][1][aType]=11; CaseAwards[10][1][aInternalId]=360; CaseAwards[10][1][aCount]=1; CaseAwards[10][1][aPriceSprayed]=100; CaseAwards[10][1][aSubcount]=0;
    CaseAwards[10][2][aId]=3; CaseAwards[10][2][aRarity]=2; CaseAwards[10][2][aType]=11; CaseAwards[10][2][aInternalId]=295; CaseAwards[10][2][aCount]=1; CaseAwards[10][2][aPriceSprayed]=80; CaseAwards[10][2][aSubcount]=0;
    CaseAwards[10][3][aId]=4; CaseAwards[10][3][aRarity]=2; CaseAwards[10][3][aType]=11; CaseAwards[10][3][aInternalId]=709; CaseAwards[10][3][aCount]=1; CaseAwards[10][3][aPriceSprayed]=100; CaseAwards[10][3][aSubcount]=0;
    CaseAwards[10][4][aId]=5; CaseAwards[10][4][aRarity]=3; CaseAwards[10][4][aType]=11; CaseAwards[10][4][aInternalId]=979; CaseAwards[10][4][aCount]=1; CaseAwards[10][4][aPriceSprayed]=140; CaseAwards[10][4][aSubcount]=0;
    CaseAwards[10][5][aId]=6; CaseAwards[10][5][aRarity]=2; CaseAwards[10][5][aType]=3; CaseAwards[10][5][aInternalId]=1; CaseAwards[10][5][aCount]=800; CaseAwards[10][5][aPriceSprayed]=0; CaseAwards[10][5][aSubcount]=0;
    CaseAwards[10][6][aId]=7; CaseAwards[10][6][aRarity]=2; CaseAwards[10][6][aType]=2; CaseAwards[10][6][aInternalId]=1; CaseAwards[10][6][aCount]=900000; CaseAwards[10][6][aPriceSprayed]=0; CaseAwards[10][6][aSubcount]=0;
    CaseAwards[10][7][aId]=8; CaseAwards[10][7][aRarity]=2; CaseAwards[10][7][aType]=11; CaseAwards[10][7][aInternalId]=134; CaseAwards[10][7][aCount]=252; CaseAwards[10][7][aPriceSprayed]=110; CaseAwards[10][7][aSubcount]=0;
    CaseAwards[10][8][aId]=9; CaseAwards[10][8][aRarity]=2; CaseAwards[10][8][aType]=23; CaseAwards[10][8][aInternalId]=1; CaseAwards[10][8][aCount]=3000; CaseAwards[10][8][aPriceSprayed]=0; CaseAwards[10][8][aSubcount]=0;
    CaseAwards[10][9][aId]=10; CaseAwards[10][9][aRarity]=2; CaseAwards[10][9][aType]=5; CaseAwards[10][9][aInternalId]=2568; CaseAwards[10][9][aCount]=0; CaseAwards[10][9][aPriceSprayed]=110; CaseAwards[10][9][aSubcount]=0;
    CaseAwards[10][10][aId]=11; CaseAwards[10][10][aRarity]=2; CaseAwards[10][10][aType]=11; CaseAwards[10][10][aInternalId]=978; CaseAwards[10][10][aCount]=1; CaseAwards[10][10][aPriceSprayed]=220; CaseAwards[10][10][aSubcount]=0;
    CaseAwards[10][11][aId]=12; CaseAwards[10][11][aRarity]=2; CaseAwards[10][11][aType]=11; CaseAwards[10][11][aInternalId]=134; CaseAwards[10][11][aCount]=7773; CaseAwards[10][11][aPriceSprayed]=140; CaseAwards[10][11][aSubcount]=0;
    CaseAwards[10][12][aId]=13; CaseAwards[10][12][aRarity]=3; CaseAwards[10][12][aType]=11; CaseAwards[10][12][aInternalId]=134; CaseAwards[10][12][aCount]=19262; CaseAwards[10][12][aPriceSprayed]=140; CaseAwards[10][12][aSubcount]=0;
    CaseAwards[10][13][aId]=14; CaseAwards[10][13][aRarity]=3; CaseAwards[10][13][aType]=5; CaseAwards[10][13][aInternalId]=603; CaseAwards[10][13][aCount]=0; CaseAwards[10][13][aPriceSprayed]=140; CaseAwards[10][13][aSubcount]=0;
    CaseAwards[10][14][aId]=15; CaseAwards[10][14][aRarity]=3; CaseAwards[10][14][aType]=23; CaseAwards[10][14][aInternalId]=1; CaseAwards[10][14][aCount]=7500; CaseAwards[10][14][aPriceSprayed]=0; CaseAwards[10][14][aSubcount]=0;
    CaseAwards[10][15][aId]=16; CaseAwards[10][15][aRarity]=3; CaseAwards[10][15][aType]=5; CaseAwards[10][15][aInternalId]=442; CaseAwards[10][15][aCount]=0; CaseAwards[10][15][aPriceSprayed]=170; CaseAwards[10][15][aSubcount]=0;
    CaseAwards[10][16][aId]=17; CaseAwards[10][16][aRarity]=3; CaseAwards[10][16][aType]=23; CaseAwards[10][16][aInternalId]=1; CaseAwards[10][16][aCount]=5000; CaseAwards[10][16][aPriceSprayed]=0; CaseAwards[10][16][aSubcount]=0;
    CaseAwards[10][17][aId]=18; CaseAwards[10][17][aRarity]=4; CaseAwards[10][17][aType]=11; CaseAwards[10][17][aInternalId]=134; CaseAwards[10][17][aCount]=7772; CaseAwards[10][17][aPriceSprayed]=230; CaseAwards[10][17][aSubcount]=0;
    CaseAwards[10][18][aId]=19; CaseAwards[10][18][aRarity]=4; CaseAwards[10][18][aType]=5; CaseAwards[10][18][aInternalId]=503; CaseAwards[10][18][aCount]=0; CaseAwards[10][18][aPriceSprayed]=230; CaseAwards[10][18][aSubcount]=0;
    CaseAwards[10][19][aId]=20; CaseAwards[10][19][aRarity]=4; CaseAwards[10][19][aType]=23; CaseAwards[10][19][aInternalId]=1; CaseAwards[10][19][aCount]=15000; CaseAwards[10][19][aPriceSprayed]=0; CaseAwards[10][19][aSubcount]=0;
    CaseAwards[10][20][aId]=21; CaseAwards[10][20][aRarity]=4; CaseAwards[10][20][aType]=5; CaseAwards[10][20][aInternalId]=505; CaseAwards[10][20][aCount]=0; CaseAwards[10][20][aPriceSprayed]=240; CaseAwards[10][20][aSubcount]=0;
    CaseAwards[10][21][aId]=22; CaseAwards[10][21][aRarity]=4; CaseAwards[10][21][aType]=5; CaseAwards[10][21][aInternalId]=502; CaseAwards[10][21][aCount]=0; CaseAwards[10][21][aPriceSprayed]=260; CaseAwards[10][21][aSubcount]=0;
    CaseAwards[10][22][aId]=23; CaseAwards[10][22][aRarity]=4; CaseAwards[10][22][aType]=5; CaseAwards[10][22][aInternalId]=490; CaseAwards[10][22][aCount]=0; CaseAwards[10][22][aPriceSprayed]=290; CaseAwards[10][22][aSubcount]=0;
    CaseAwards[10][23][aId]=24; CaseAwards[10][23][aRarity]=3; CaseAwards[10][23][aType]=5; CaseAwards[10][23][aInternalId]=2392; CaseAwards[10][23][aCount]=0; CaseAwards[10][23][aPriceSprayed]=220; CaseAwards[10][23][aSubcount]=69;
    CaseAwards[10][24][aId]=25; CaseAwards[10][24][aRarity]=5; CaseAwards[10][24][aType]=5; CaseAwards[10][24][aInternalId]=772; CaseAwards[10][24][aCount]=0; CaseAwards[10][24][aPriceSprayed]=670; CaseAwards[10][24][aSubcount]=71;
    CaseBonus[10][0][bId]=1; CaseBonus[10][0][bNumberOpen]=40; CaseBonus[10][0][bRarity]=5; CaseBonus[10][0][bType]=5; CaseBonus[10][0][bInternalId]=438; CaseBonus[10][0][bCount]=0; CaseBonus[10][0][bPriceSprayed]=320;
    CaseBonus[10][1][bId]=2; CaseBonus[10][1][bNumberOpen]=30; CaseBonus[10][1][bRarity]=4; CaseBonus[10][1][bType]=23; CaseBonus[10][1][bInternalId]=1; CaseBonus[10][1][bCount]=10000; CaseBonus[10][1][bPriceSprayed]=0;
    CaseBonus[10][2][bId]=3; CaseBonus[10][2][bNumberOpen]=20; CaseBonus[10][2][bRarity]=4; CaseBonus[10][2][bType]=4; CaseBonus[10][2][bInternalId]=11; CaseBonus[10][2][bCount]=2; CaseBonus[10][2][bPriceSprayed]=0;
    CaseBonus[10][3][bId]=4; CaseBonus[10][3][bNumberOpen]=10; CaseBonus[10][3][bRarity]=4; CaseBonus[10][3][bType]=23; CaseBonus[10][3][bInternalId]=1; CaseBonus[10][3][bCount]=5000; CaseBonus[10][3][bPriceSprayed]=0;
    CaseBonus[10][4][bId]=5; CaseBonus[10][4][bNumberOpen]=5; CaseBonus[10][4][bRarity]=4; CaseBonus[10][4][bType]=4; CaseBonus[10][4][bInternalId]=11; CaseBonus[10][4][bCount]=1; CaseBonus[10][4][bPriceSprayed]=0;
}

stock Cases_SavePlayer(playerid)
{
    new accountId = GetPlayerAccountID(playerid);
    if(accountId <= 0) return 0;

    new ccStr[384];
    ccStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ccStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", GetPlayerCaseCountByType(playerid, CaseData[i][cId]));
        strcat(ccStr, tmp);
    }

    new ocStr[384];
    ocStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ocStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", pCasesOpenedByCase[playerid][i]);
        strcat(ocStr, tmp);
    }

    new cbStr[768];
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

    new query[1800];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `player_cases` (`user_id`,`dust`,`opened_count`,`selected_case`,`tutorial`,`case_counts`,`opened_by_case`,`bonus_status`) VALUES (%d,%d,%d,%d,%d,'%e','%e','%e') ON DUPLICATE KEY UPDATE `dust`=%d,`opened_count`=%d,`selected_case`=%d,`tutorial`=%d,`case_counts`='%e',`opened_by_case`='%e',`bonus_status`='%e'",
        accountId,
        pCasesDust[playerid],
        pCasesOpened[playerid],
        pCasesSelected[playerid],
        pCasesTutorial[playerid],
        ccStr,
        ocStr,
        cbStr,
        pCasesDust[playerid],
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
    new rows, fields;
    cache_get_data(rows, fields);

    if(rows <= 0)
    {
        Cases_SavePlayer(playerid);
        return 1;
    }

    pCasesDust[playerid] = cache_get_field_content_int(0, "dust");
    pCasesOpened[playerid] = cache_get_field_content_int(0, "opened_count");
    pCasesSelected[playerid] = cache_get_field_content_int(0, "selected_case");
    pCasesTutorial[playerid] = cache_get_field_content_int(0, "tutorial");

    if(Cases_GetIndex(pCasesSelected[playerid]) == -1)
        pCasesSelected[playerid] = CASES_DAILY_CASE_ID;

    new ccStr[384];
    cache_get_field_content(0, "case_counts", ccStr, mysql, sizeof(ccStr));
    if(strlen(ccStr) > 0)
    {
        new idx = 0, pos = 0, len = strlen(ccStr), tmp[16];
        while(pos < len && idx < MAX_CASES)
        {
            new end = pos;
            while(end < len && ccStr[end] != ',') end++;
            strmid(tmp, ccStr, pos, end, sizeof(tmp));
            SetPlayerCaseCountByType(playerid, CaseData[idx][cId], strval(tmp));
            idx++;
            pos = end + 1;
        }
    }

    new ocStr[384];
    cache_get_field_content(0, "opened_by_case", ocStr, mysql, sizeof(ocStr));
    if(strlen(ocStr) > 0)
    {
        new idx = 0, pos = 0, len = strlen(ocStr), tmp[16];
        while(pos < len && idx < MAX_CASES)
        {
            new end = pos;
            while(end < len && ocStr[end] != ',') end++;
            strmid(tmp, ocStr, pos, end, sizeof(tmp));
            pCasesOpenedByCase[playerid][idx] = strval(tmp);
            idx++;
            pos = end + 1;
        }
    }

    new cbStr[768];
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

    for(new c = 0; c < MAX_CASES; c++)
        Cases_UpdateBonusStates(playerid, c);

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

CMD:cases(playerid, params[])
{
    Cases_ShowGUI(playerid);
    return 1;
}


CMD:givedust(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа.");

    new to_player, amount;
    if(sscanf(params, "ud", to_player, amount))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givedust [id игрока] [количество]");

    if(!IsPlayerConnected(to_player))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    if(amount <= 0)
        return SendClientMessage(playerid, COLOR_RED, "Количество пыли должно быть больше 0.");

    pCasesDust[to_player] += amount;
    Cases_CheckDustReward(to_player);
    Cases_SavePlayer(to_player);

    if(pCasesGUIOpen[to_player])
        Cases_UpdateGUI(to_player);

    new msg[144];
    format(msg, sizeof(msg), "Вы выдали игроку %s %d пыли. Сейчас у него: %d пыли.",
        GetPlayerNameEx(to_player), amount, pCasesDust[to_player]);
    Cases_Notify(playerid, 3, msg, "");

    format(msg, sizeof(msg), "Администратор выдал вам %d пыли. Сейчас у вас: %d пыли.",
        amount, pCasesDust[to_player]);
    Cases_Notify(to_player, 3, msg, "");

    return 1;
}

CMD:setdust(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа.");

    new to_player, amount;
    if(sscanf(params, "ud", to_player, amount))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /setdust [id игрока] [количество]");

    if(!IsPlayerConnected(to_player))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    if(amount < 0)
        return SendClientMessage(playerid, COLOR_RED, "Количество пыли не может быть меньше 0.");

    pCasesDust[to_player] = amount;
    Cases_CheckDustReward(to_player);
    Cases_SavePlayer(to_player);

    if(pCasesGUIOpen[to_player])
        Cases_UpdateGUI(to_player);

    new msg[144];
    format(msg, sizeof(msg), "Вы установили игроку %s %d пыли. Сейчас у него: %d пыли.",
        GetPlayerNameEx(to_player), amount, pCasesDust[to_player]);
    Cases_Notify(playerid, 3, msg, "");

    format(msg, sizeof(msg), "Администратор установил вам %d пыли. Сейчас у вас: %d пыли.",
        amount, pCasesDust[to_player]);
    Cases_Notify(to_player, 3, msg, "");

    return 1;
}


CMD:setcase(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа.");

    new to_player, case_type, amount;
    if(sscanf(params, "udd", to_player, case_type, amount))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /setcase [id игрока] [тип кейса 1-11] [количество]");

    if(!IsPlayerConnected(to_player))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    if(case_type < 1 || case_type > MAX_CASES)
        return SendClientMessage(playerid, COLOR_RED, "Тип кейса должен быть от 1 до 11.");

    if(amount < 0)
        return SendClientMessage(playerid, COLOR_RED, "Количество не может быть меньше 0.");

    SetPlayerCaseCountByType(to_player, case_type, amount);
    Cases_SavePlayer(to_player);

    if(pCasesGUIOpen[to_player])
        Cases_UpdateGUI(to_player);

    new caseName[48];
    switch(case_type)
    {
        case 1: format(caseName, sizeof(caseName), "Ежедневный кейс");
        case 2: format(caseName, sizeof(caseName), "Кейс бомжа");
        case 3: format(caseName, sizeof(caseName), "Стандартный кейс");
        case 4: format(caseName, sizeof(caseName), "Авто-кейс");
        case 5: format(caseName, sizeof(caseName), "Особый кейс");
        case 6: format(caseName, sizeof(caseName), "Драйв кейс");
        default: format(caseName, sizeof(caseName), "Кейс #%d", case_type);
    }

    new msg[128];
    format(msg, sizeof(msg), "%s: %d", caseName, amount);
    Cases_Notify(playerid, 3, "Количество кейсов установлено", msg);
    Cases_Notify(to_player, 3, "Ваши кейсы обновлены", msg);
    return 1;
}

CMD:giveallcases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа.");

    new to_player, amount;
    if(sscanf(params, "ud", to_player, amount))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /giveallcases [id игрока] [количество каждого кейса]");

    if(!IsPlayerConnected(to_player))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    if(amount <= 0)
        return SendClientMessage(playerid, COLOR_RED, "Количество должно быть больше 0.");

    for(new case_type = 1; case_type <= MAX_CASES; case_type++)
    {
        AddPlayerCaseCountByType(to_player, case_type, amount);
    }

    Cases_SavePlayer(to_player);

    if(pCasesGUIOpen[to_player])
        Cases_UpdateGUI(to_player);

    new msg[96];
    format(msg, sizeof(msg), "Все кейсы x%d", amount);
    Cases_Notify(playerid, 3, "Кейсы выданы игроку", msg);
    Cases_Notify(to_player, 3, "Вы получили набор кейсов", msg);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new to_player, type_case, count;
    if(sscanf(params, "udd", to_player, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-11] [count]");

    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > MAX_CASES) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 11.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(to_player, type_case, count);
    SavePlayerAccount(to_player);

    new str[128];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", count, type_case, GetPlayerNameEx(to_player));
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(to_player, COLOR_WHITE, str);
    
    if(pCasesGUIOpen[to_player]) Cases_UpdateGUI(to_player);
    
    return 1;
}