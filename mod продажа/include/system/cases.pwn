

#if defined _cases_included
    #endinput
#endif
#define _cases_included
enum
{
	LOG_TYPE_ADMIN_CHAT = 1,
	LOG_TYPE_ADMIN_ANSWER,
	LOG_TYPE_ADMIN_ACTION,
	LOG_TYPE_SET_ADMIN,
	LOG_TYPE_SET_LEADER,
	LOG_TYPE_SMS_CHAT,
	LOG_TYPE_OOC_CHAT,
	LOG_TYPE_REPORT,
	LOG_TYPE_FRACTION,
	LOG_TYPE_SUPERADMIN_ACTION
}

#include "../include/json.inc"

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

#define CASES_OPEN_ONE  1
#define CASES_OPEN_TEN  2

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


#define MAX_CASES           19
#define MAX_AWARDS_PER_CASE 40
#define MAX_BONUS_PER_CASE  5

new pCasesDust[MAX_PLAYERS];        
new pCasesOpened[MAX_PLAYERS];       
new pCasesSelected[MAX_PLAYERS];     
new pCasesTutorial[MAX_PLAYERS];     
new pCasesCounts[MAX_PLAYERS][MAX_CASES]; 
new pCasesBonusStatus[MAX_PLAYERS][MAX_CASES][MAX_BONUS_PER_CASE]; 
new pCasesGUIOpen[MAX_PLAYERS];      
new pCasesLastAction[MAX_PLAYERS];   
new pCasesLastOpenedIdx[MAX_PLAYERS]; 

new pCasesPendingRewards[MAX_PLAYERS][10]; 
new pCasesPendingCount[MAX_PLAYERS];

enum E_CASE_AWARD {
	aId,
	aRarity,
	aType,
	aInternalId,
	aCount,
	aPriceSprayed,
	aSubcount
}

enum E_CASE_BONUS {
	bId,
	bNumberOpen,
	bRarity,
	bType,
	bInternalId,
	bCount,
	bPriceSprayed
}

enum E_CASE_DATA {
	cId,
	cPriceOne,
	cPriceTen,
	cDiscountOne,
	cDiscountTen,
	cAwardsCount,
	cBonusCount
}

new CaseData[MAX_CASES][E_CASE_DATA];
new CaseAwards[MAX_CASES][MAX_AWARDS_PER_CASE][E_CASE_AWARD];
new CaseBonus[MAX_CASES][MAX_BONUS_PER_CASE][E_CASE_BONUS];

forward Cases_Init();
forward Cases_OnPlayerConnect(playerid);
forward Cases_ShowGUI(playerid);
forward Cases_HideGUI(playerid);
forward Cases_OnPacketIncoming(playerid, const jsonData[]);

stock SendPlayerGUIPacket(playerid, guiid, Node:json)
{
	OnPacketIncoming(playerid, guiid, json);
	return 1;
}

stock Cases_Init()
{
	CaseData[0][cId] = 1;
	CaseData[0][cPriceOne] = 15;
	CaseData[0][cPriceTen] = 150;
	CaseData[0][cDiscountOne] = 0;
	CaseData[0][cDiscountTen] = 0;
	CaseData[0][cAwardsCount] = 20;
	CaseData[0][cBonusCount] = 5;
	Cases_InitCase1Awards();
	Cases_InitCase1Bonus();
	
	CaseData[1][cId] = 2;
	CaseData[1][cPriceOne] = 100;
	CaseData[1][cPriceTen] = 1000;
	CaseData[1][cDiscountOne] = 0;
	CaseData[1][cDiscountTen] = 0;
	CaseData[1][cAwardsCount] = 27;
	CaseData[1][cBonusCount] = 5;
	Cases_InitCase2Awards();
	Cases_InitCase2Bonus();
	
	CaseData[2][cId] = 3;
	CaseData[2][cPriceOne] = 700;
	CaseData[2][cPriceTen] = 7000;
	CaseData[2][cDiscountOne] = 0;
	CaseData[2][cDiscountTen] = 0;
	CaseData[2][cAwardsCount] = 37;
	CaseData[2][cBonusCount] = 5;
	Cases_InitCase3Awards();
	Cases_InitCase3Bonus();
	
	CaseData[3][cId] = 4;
	CaseData[3][cPriceOne] = 1200;
	CaseData[3][cPriceTen] = 12000;
	CaseData[3][cDiscountOne] = 0;
	CaseData[3][cDiscountTen] = 5;
	CaseData[3][cAwardsCount] = 37;
	CaseData[3][cBonusCount] = 5;
	Cases_InitCase4Awards();
	Cases_InitCase4Bonus();
	
	CaseData[4][cId] = 5;
	CaseData[4][cPriceOne] = 10000;
	CaseData[4][cPriceTen] = 100000;
	CaseData[4][cDiscountOne] = 0;
	CaseData[4][cDiscountTen] = 0;
	CaseData[4][cAwardsCount] = 22;
	CaseData[4][cBonusCount] = 5;
	Cases_InitCase5Awards();
	Cases_InitCase5Bonus();

	CaseData[5][cId] = 6;
	CaseData[5][cPriceOne] = 900;
	CaseData[5][cPriceTen] = 9000;
	CaseData[5][cDiscountOne] = 0;
	CaseData[5][cDiscountTen] = 5;
	CaseData[5][cAwardsCount] = 25;
	CaseData[5][cBonusCount] = 5;
	Cases_InitCase6();
	
	for(new i = 6; i < MAX_CASES; i++) {
		CaseData[i][cId] = i + 1;
		CaseData[i][cPriceOne] = 900;
		CaseData[i][cPriceTen] = 9000;
		CaseData[i][cDiscountOne] = 0;
		CaseData[i][cDiscountTen] = 5;
		CaseData[i][cAwardsCount] = 25;
		CaseData[i][cBonusCount] = 5;
	}
	Cases_InitEventCases();
	
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
	pCasesDust[playerid] = 0;
	pCasesOpened[playerid] = 0;
	pCasesSelected[playerid] = 1;
	pCasesTutorial[playerid] = 0;
	pCasesGUIOpen[playerid] = 0;
	pCasesLastAction[playerid] = 0;
	pCasesPendingCount[playerid] = 0;
	pCasesLastOpenedIdx[playerid] = 0;
	
	for(new i = 0; i < MAX_CASES; i++) {
		pCasesCounts[playerid][i] = 0;
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
	if(pCasesCounts[playerid][caseIdx] >= requiredOpens) {
		if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] != 3) {
			return 2; 		}
	}
	
	return 1; 
}

stock Cases_UpdateBonusStates(playerid, caseIdx)
{
	for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++) {
		if(pCasesBonusStatus[playerid][caseIdx][b] != 3) {
			new requiredOpens = CaseBonus[caseIdx][b][bNumberOpen];
			if(pCasesCounts[playerid][caseIdx] >= requiredOpens) {
				pCasesBonusStatus[playerid][caseIdx][b] = 2; 
			} else {
				pCasesBonusStatus[playerid][caseIdx][b] = 1; 
			}
		}
	}
}

stock Cases_BuildCbArray(playerid, Node:cbArray)
{
	for(new c = 0; c < MAX_CASES; c++) {
		for(new b = 0; b < CaseData[c][cBonusCount]; b++) {
			new bonusId = CaseBonus[c][b][bId];
			new bonusState = Cases_GetBonusState(playerid, c, b);
			
			new Node:bonusObj = JSON_Object(
				"id", JSON_Int(bonusId),
				"state", JSON_Int(bonusState)
			);
			JSON_Append(cbArray, bonusObj);
		}
	}
	return 1;
}

stock Cases_ShowGUI(playerid)
{
	new Node:json = JSON_Object(
		"t", JSON_Int(1),
		"bc", JSON_Int(GetPlayerDonateRub(playerid)),
		"pc", JSON_Int(pCasesDust[playerid]),
		"bcc", JSON_Int(pCasesOpened[playerid]),
		"cs", JSON_Int(pCasesSelected[playerid]),
		"i", JSON_Int(pCasesTutorial[playerid])
	);
	
	new Node:ccArray = JSON_Array();
	for(new c = 0; c < MAX_CASES; c++) {
		new Node:caseObj = JSON_Object(
			"id", JSON_Int(CaseData[c][cId]),
			"cot", JSON_Int(pCasesCounts[playerid][c]),
			"du", JSON_Int(0)
		);
		ccArray = JSON_Append(ccArray, caseObj);
	}
	JSON_SetArray(json, "cc", ccArray);
	
	new Node:cbArray = JSON_Array();
	Cases_BuildCbArray(playerid, cbArray);
	JSON_SetArray(json, "cb", cbArray);
	
	ShowPlayerGUI(playerid, GUICases, json);
	pCasesGUIOpen[playerid] = 1;
	JSON_Cleanup(json);
	return 1;
}

stock Cases_UpdateGUI(playerid)
{
	new Node:json = JSON_Object(
		"t", JSON_Int(1),
		"bc", JSON_Int(GetPlayerDonateRub(playerid)),
		"pc", JSON_Int(pCasesDust[playerid]),
		"bcc", JSON_Int(pCasesOpened[playerid]),
		"cs", JSON_Int(pCasesSelected[playerid]),
		"i", JSON_Int(pCasesTutorial[playerid])
	);
	
	new Node:ccArray = JSON_Array();
	for(new c = 0; c < MAX_CASES; c++) {
		new Node:caseObj = JSON_Object(
			"id", JSON_Int(CaseData[c][cId]),
			"cot", JSON_Int(pCasesCounts[playerid][c]),
			"du", JSON_Int(0)
		);
		ccArray = JSON_Append(ccArray, caseObj);
	}
	JSON_SetArray(json, "cc", ccArray);
	
	new Node:cbArray = JSON_Array();
	Cases_BuildCbArray(playerid, cbArray);
	JSON_SetArray(json, "cb", cbArray);
	
	SendPlayerGUIPacket(playerid, GUICases, json);
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

stock Cases_OnPacketIncoming(playerid, const jsonData[])
{
	new currentTime = gettime();
	if(currentTime - pCasesLastAction[playerid] < 1) {
		return 0;
	}
	pCasesLastAction[playerid] = currentTime;
	
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
				SendClientMessage(playerid, 0xFFFF00FF, "                                      BC");
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
	
	if(pCasesCounts[playerid][idx] > 0) {
		if(pCasesCounts[playerid][idx] < openCount) {
			new Node:json = JSON_Object(
				"t", JSON_Int(CASES_TYPE_OPEN),
				"s", JSON_Int(-1),
				"d", JSON_Int(1)
			);
			SendPlayerGUIPacket(playerid, GUICases, json);
			JSON_Cleanup(json);
			return 0;
		}
		useOwnedCases = 1;
	}
	
	if(useOwnedCases) {
		pCasesCounts[playerid][idx] -= openCount;
	} else {
		new price = (openType == CASES_OPEN_ONE) ? CaseData[idx][cPriceOne] : CaseData[idx][cPriceTen];
		new discount = (openType == CASES_OPEN_ONE) ? CaseData[idx][cDiscountOne] : CaseData[idx][cDiscountTen];
		price = price - (price * discount / 100);
		
		if(GetPlayerDonateRub(playerid) < price) {
			new Node:json = JSON_Object(
				"t", JSON_Int(CASES_TYPE_OPEN),
				"s", JSON_Int(-1),
				"d", JSON_Int(1)
			);
			SendPlayerGUIPacket(playerid, GUICases, json);
			JSON_Cleanup(json);
			return 0;
		}
		
		GivePlayerDonateRub(playerid, -price);
	}
	
	for(new r = 0; r < openCount; r++) {
		rewardIds[r] = Cases_GetRandomReward(idx);
		pCasesPendingRewards[playerid][r] = rewardIds[r];
	}
	pCasesPendingCount[playerid] = openCount;
	
	pCasesOpened[playerid] += openCount;
	pCasesLastOpenedIdx[playerid] = idx; //                                 
	
	Cases_UpdateBonusStates(playerid, idx);
	
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
		"{\"t\":%d,\"s\":1,\"bc\":%d,\"pc\":%d,\"bcc\":%d,\"cs\":%d,\"type\":%d,\"pr\":[%s]}",
		CASES_TYPE_OPEN, GetPlayerDonateRub(playerid), pCasesDust[playerid], pCasesOpened[playerid],
		pCasesSelected[playerid], openType, prStr);
	
	new Node:json;
	JSON_Parse(jsonStr, json);
	
	SendPlayerGUIPacket(playerid, GUICases, json);
	JSON_Cleanup(json);
	
	printf("[Cases] Player %d opened case %d, rewards: [%s]", playerid, caseId, prStr);
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
	if(pCasesDust[playerid] >= 2000) {
		pCasesDust[playerid] -= 2000;
		
		pCasesCounts[playerid][4] += 1;
		
		SendClientMessage(playerid, 0xFFFF00FF, "           !             2000                            !");
		
		if(pCasesGUIOpen[playerid]) {
			Cases_UpdateGUI(playerid);
		}
		
		printf("[Cases] Player %d received special case for 2000 dust", playerid);
		return 1;
	}
	return 0;
}

stock Cases_TakeRewards(playerid, Node:json)
{
	new totalDustGained = 0;
	
	new Node:bt1Array;
	if(JSON_GetArray(json, "bt1", bt1Array) == 0) {
		new length = 0;
		JSON_ArrayLength(bt1Array, length);
		
		for(new i = 0; i < length; i++) {
			new Node:itemNode;
			if(JSON_ArrayObject(bt1Array, i, itemNode) == 0) {
				new rewardId = 0;
				JSON_GetInt(itemNode, "", rewardId);
				if(rewardId > 0) {
					Cases_GiveReward(playerid, rewardId);
				}
			}
		}
	}
	
	new Node:bt2Array;
	if(JSON_GetArray(json, "bt2", bt2Array) == 0) {
		new length = 0;
		JSON_ArrayLength(bt2Array, length);
		
		for(new i = 0; i < length; i++) {
			new Node:itemNode;
			if(JSON_ArrayObject(bt2Array, i, itemNode) == 0) {
				new rewardId = 0;
				JSON_GetInt(itemNode, "", rewardId);
				if(rewardId > 0) {
					new dustGained = Cases_SprayReward(playerid, rewardId);
					totalDustGained += dustGained;
				}
			}
		}
	}
	
	Cases_CheckDustReward(playerid);
	
	pCasesPendingCount[playerid] = 0;
	for(new i = 0; i < 10; i++) {
		pCasesPendingRewards[playerid][i] = 0;
	}
	
	new Node:response = JSON_Object(
		"t", JSON_Int(CASES_TYPE_TAKE_REWARDS),
		"s", JSON_Int(1),
		"bc", JSON_Int(GetPlayerDonateRub(playerid)),
		"pc", JSON_Int(pCasesDust[playerid])
	);
	SendPlayerGUIPacket(playerid, GUICases, response);
	JSON_Cleanup(response);
	
	if(totalDustGained > 0) {
		new str[64];
		format(str, sizeof(str), "             : %d", totalDustGained);
		SendClientMessage(playerid, 0xFFFF00FF, str);
	}
	
	return 1;
}

stock Cases_GiveReward(playerid, rewardId)
{
	new lastIdx = pCasesLastOpenedIdx[playerid];
	if(lastIdx >= 0 && lastIdx < MAX_CASES) {
		for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++) {
			if(CaseAwards[lastIdx][i][aId] == rewardId) {
				return Cases_GiveRewardInternal(playerid, lastIdx, i);
			}
		}
	}
	
	for(new c = 0; c < MAX_CASES; c++) {
		for(new i = 0; i < CaseData[c][cAwardsCount]; i++) {
			if(CaseAwards[c][i][aId] == rewardId) {
				return Cases_GiveRewardInternal(playerid, c, i);
			}
		}
	}
	return 0;
}

stock Cases_GiveRewardInternal(playerid, caseIdx, awardIdx)
{
	new rewardType = CaseAwards[caseIdx][awardIdx][aType];
	new count = CaseAwards[caseIdx][awardIdx][aCount];
	new internalId = CaseAwards[caseIdx][awardIdx][aInternalId];
			
	switch(rewardType) {
		case REWARD_TYPE_EXP: {
			new str[64];
			format(str, sizeof(str), "         %d EXP!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_MONEY: {
			GivePlayerMoneyEx(playerid, count, "?????", true, true);
			new str[64];
			format(str, sizeof(str), "         $%d!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_BC: {
	    	GivePlayerDonateRub(playerid, count);
			new str[64];
			format(str, sizeof(str), "         %d BC!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_CASE: {
			new str[64];
			format(str, sizeof(str), "                  %d!", internalId);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_VEHICLE: {
			new str[64];
			format(str, sizeof(str), "                   (       %d)!", internalId);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_VIP: {
			new str[64];
			format(str, sizeof(str), "        VIP    %d      !", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_BP_EXP: {
			new str[64];
			format(str, sizeof(str), "         %d BP EXP!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_ITEM: {
			new str[64];
			format(str, sizeof(str), "                (ID %d) x%d!", internalId, count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_DUST: {
			pCasesDust[playerid] += count;
			new str[64];
			format(str, sizeof(str), "         %d     !", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_EVENT_RES: {
			new str[64];
			format(str, sizeof(str), "                       x%d!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		default: {
			new str[64];
			format(str, sizeof(str), "                      %d!", rewardType);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
	}
	return 1;
}

stock Cases_SprayReward(playerid, rewardId)
{
	new lastIdx = pCasesLastOpenedIdx[playerid];
	if(lastIdx >= 0 && lastIdx < MAX_CASES) {
		for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++) {
			if(CaseAwards[lastIdx][i][aId] == rewardId) {
				new dustAmount = CaseAwards[lastIdx][i][aPriceSprayed];
				pCasesDust[playerid] += dustAmount;
				return dustAmount;
			}
		}
	}
	
	for(new c = 0; c < MAX_CASES; c++) {
		for(new i = 0; i < CaseData[c][cAwardsCount]; i++) {
			if(CaseAwards[c][i][aId] == rewardId) {
				new dustAmount = CaseAwards[c][i][aPriceSprayed];
				pCasesDust[playerid] += dustAmount;
				return dustAmount;
			}
		}
	}
	return 0;
}


stock Cases_GetBonus(playerid, bonusId)
{
	new caseIdx = -1, bonusIdx = -1;
	
	for(new c = 0; c < MAX_CASES; c++) {
		for(new b = 0; b < CaseData[c][cBonusCount]; b++) {
			if(CaseBonus[c][b][bId] == bonusId) {
				caseIdx = c;
				bonusIdx = b;
				break;
			}
		}
		if(caseIdx != -1) break;
	}
	
	if(caseIdx == -1 || bonusIdx == -1) {
		new Node:json = JSON_Object(
			"t", JSON_Int(CASES_TYPE_GET_BONUS),
			"s", JSON_Int(0)
		);
		SendPlayerGUIPacket(playerid, GUICases, json);
		JSON_Cleanup(json);
		return 0;
	}
	
	new i = bonusIdx;
	
	if(pCasesBonusStatus[playerid][caseIdx][i] == 3) {
		new Node:json = JSON_Object(
			"t", JSON_Int(CASES_TYPE_GET_BONUS),
			"s", JSON_Int(0)
		);
		SendPlayerGUIPacket(playerid, GUICases, json);
		JSON_Cleanup(json);
		return 0;
	}
	
	new requiredOpens = CaseBonus[caseIdx][i][bNumberOpen];
	if(pCasesCounts[playerid][caseIdx] < requiredOpens) {
		new Node:json = JSON_Object(
			"t", JSON_Int(CASES_TYPE_GET_BONUS),
			"s", JSON_Int(0)
		);
		SendPlayerGUIPacket(playerid, GUICases, json);
		JSON_Cleanup(json);
		return 0;
	}
	
	new bonusType = CaseBonus[caseIdx][i][bType];
	new count = CaseBonus[caseIdx][i][bCount];
	new internalId = CaseBonus[caseIdx][i][bInternalId];
	#pragma unused internalId
	
	switch(bonusType) {
		case REWARD_TYPE_VEHICLE: {
			SendClientMessage(playerid, 0x00FF00FF, "Вы выиграли жигуль!");
		}
		case REWARD_TYPE_DUST: {
			pCasesDust[playerid] += count;
			new str[64];
			format(str, sizeof(str), "Вы выиграли %d столько хуев в жопу!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_CASE: {
			new str[64];
			format(str, sizeof(str), "Тип кейса %d пидарас!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_EVENT_RES: {
			SendClientMessage(playerid, 0x00FF00FF, "Я тя в рот: ебал!");
		}
		case REWARD_TYPE_MONEY: {
			GivePlayerMoneyEx(playerid, count, "Скоко скоко денег?", true, true);
			new str[64];
			format(str, sizeof(str), "Правильно вот стоко $%d!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_BC: {
		    GivePlayerDonateRub(playerid, count);
			new str[64];
			format(str, sizeof(str), "За скок продаш себя в рабство? %d BC!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_VIP: {
			new str[64];
			format(str, sizeof(str), "Вы проебали свою VIP с %d попытки!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_EXP: {
			new str[64];
			format(str, sizeof(str), "Вас выебало за столько %d EXP!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_BP_EXP: {
			new str[64];
			format(str, sizeof(str), "Ди нах у нас бп нету %d BP EXP!", count);
			SendClientMessage(playerid, 0x00FF00FF, str);
		}
		case REWARD_TYPE_ITEM: {
			SendClientMessage(playerid, 0x00FF00FF, "Спасибо: пидор за нихуя!");
		}
	}
	
	pCasesBonusStatus[playerid][caseIdx][i] = 3;
	
	new Node:json = JSON_Object(
		"t", JSON_Int(CASES_TYPE_GET_BONUS),
		"s", JSON_Int(1),
		"bc", JSON_Int(GetPlayerDonateRub(playerid)),
		"pc", JSON_Int(pCasesDust[playerid])
	);
	SendPlayerGUIPacket(playerid, GUICases, json);
	JSON_Cleanup(json);
	
	printf("[Cases] Player %d claimed bonus %d from case %d", playerid, bonusId, CaseData[caseIdx][cId]);
	return 1;
}

stock Cases_InitCase1Awards()
{
	CaseAwards[0][0][aId]=1; CaseAwards[0][0][aRarity]=1; CaseAwards[0][0][aType]=11; CaseAwards[0][0][aInternalId]=23; CaseAwards[0][0][aCount]=1; CaseAwards[0][0][aPriceSprayed]=10;
	CaseAwards[0][1][aId]=2; CaseAwards[0][1][aRarity]=1; CaseAwards[0][1][aType]=11; CaseAwards[0][1][aInternalId]=22; CaseAwards[0][1][aCount]=1; CaseAwards[0][1][aPriceSprayed]=10;
	CaseAwards[0][2][aId]=3; CaseAwards[0][2][aRarity]=1; CaseAwards[0][2][aType]=10; CaseAwards[0][2][aInternalId]=1; CaseAwards[0][2][aCount]=200; CaseAwards[0][2][aPriceSprayed]=0;
	CaseAwards[0][3][aId]=4; CaseAwards[0][3][aRarity]=1; CaseAwards[0][3][aType]=11; CaseAwards[0][3][aInternalId]=21; CaseAwards[0][3][aCount]=1; CaseAwards[0][3][aPriceSprayed]=10;
	CaseAwards[0][4][aId]=5; CaseAwards[0][4][aRarity]=1; CaseAwards[0][4][aType]=2; CaseAwards[0][4][aInternalId]=1; CaseAwards[0][4][aCount]=2000; CaseAwards[0][4][aPriceSprayed]=0;
	CaseAwards[0][5][aId]=6; CaseAwards[0][5][aRarity]=1; CaseAwards[0][5][aType]=3; CaseAwards[0][5][aInternalId]=1; CaseAwards[0][5][aCount]=5; CaseAwards[0][5][aPriceSprayed]=0;
	CaseAwards[0][6][aId]=7; CaseAwards[0][6][aRarity]=1; CaseAwards[0][6][aType]=2; CaseAwards[0][6][aInternalId]=1; CaseAwards[0][6][aCount]=3000; CaseAwards[0][6][aPriceSprayed]=0;
	CaseAwards[0][7][aId]=8; CaseAwards[0][7][aRarity]=1; CaseAwards[0][7][aType]=3; CaseAwards[0][7][aInternalId]=1; CaseAwards[0][7][aCount]=10; CaseAwards[0][7][aPriceSprayed]=0;
	CaseAwards[0][8][aId]=9; CaseAwards[0][8][aRarity]=1; CaseAwards[0][8][aType]=9; CaseAwards[0][8][aInternalId]=1; CaseAwards[0][8][aCount]=2; CaseAwards[0][8][aPriceSprayed]=10;
	CaseAwards[0][9][aId]=10; CaseAwards[0][9][aRarity]=1; CaseAwards[0][9][aType]=10; CaseAwards[0][9][aInternalId]=1; CaseAwards[0][9][aCount]=300; CaseAwards[0][9][aPriceSprayed]=0;
	CaseAwards[0][10][aId]=11; CaseAwards[0][10][aRarity]=1; CaseAwards[0][10][aType]=1; CaseAwards[0][10][aInternalId]=1; CaseAwards[0][10][aCount]=4; CaseAwards[0][10][aPriceSprayed]=0;
	CaseAwards[0][11][aId]=12; CaseAwards[0][11][aRarity]=1; CaseAwards[0][11][aType]=5; CaseAwards[0][11][aInternalId]=462; CaseAwards[0][11][aCount]=0; CaseAwards[0][11][aPriceSprayed]=20;
	CaseAwards[0][12][aId]=13; CaseAwards[0][12][aRarity]=1; CaseAwards[0][12][aType]=10; CaseAwards[0][12][aInternalId]=1; CaseAwards[0][12][aCount]=500; CaseAwards[0][12][aPriceSprayed]=0;
	CaseAwards[0][13][aId]=14; CaseAwards[0][13][aRarity]=1; CaseAwards[0][13][aType]=2; CaseAwards[0][13][aInternalId]=1; CaseAwards[0][13][aCount]=20000; CaseAwards[0][13][aPriceSprayed]=0;
	CaseAwards[0][14][aId]=15; CaseAwards[0][14][aRarity]=1; CaseAwards[0][14][aType]=3; CaseAwards[0][14][aInternalId]=1; CaseAwards[0][14][aCount]=15; CaseAwards[0][14][aPriceSprayed]=0;
	CaseAwards[0][15][aId]=16; CaseAwards[0][15][aRarity]=1; CaseAwards[0][15][aType]=9; CaseAwards[0][15][aInternalId]=2; CaseAwards[0][15][aCount]=2; CaseAwards[0][15][aPriceSprayed]=10;
	CaseAwards[0][16][aId]=17; CaseAwards[0][16][aRarity]=1; CaseAwards[0][16][aType]=10; CaseAwards[0][16][aInternalId]=1; CaseAwards[0][16][aCount]=500; CaseAwards[0][16][aPriceSprayed]=0;
	CaseAwards[0][17][aId]=18; CaseAwards[0][17][aRarity]=1; CaseAwards[0][17][aType]=2; CaseAwards[0][17][aInternalId]=1; CaseAwards[0][17][aCount]=30000; CaseAwards[0][17][aPriceSprayed]=0;
	CaseAwards[0][18][aId]=19; CaseAwards[0][18][aRarity]=1; CaseAwards[0][18][aType]=1; CaseAwards[0][18][aInternalId]=1; CaseAwards[0][18][aCount]=6; CaseAwards[0][18][aPriceSprayed]=0;
	CaseAwards[0][19][aId]=20; CaseAwards[0][19][aRarity]=1; CaseAwards[0][19][aType]=5; CaseAwards[0][19][aInternalId]=549; CaseAwards[0][19][aCount]=0; CaseAwards[0][19][aPriceSprayed]=20;
}

stock Cases_InitCase1Bonus()
{
	CaseBonus[0][0][bId]=101; CaseBonus[0][0][bNumberOpen]=40; CaseBonus[0][0][bRarity]=4; CaseBonus[0][0][bType]=4; CaseBonus[0][0][bInternalId]=3; CaseBonus[0][0][bCount]=1; CaseBonus[0][0][bPriceSprayed]=0;
	CaseBonus[0][1][bId]=102; CaseBonus[0][1][bNumberOpen]=30; CaseBonus[0][1][bRarity]=3; CaseBonus[0][1][bType]=21; CaseBonus[0][1][bInternalId]=1; CaseBonus[0][1][bCount]=50; CaseBonus[0][1][bPriceSprayed]=0;
	CaseBonus[0][2][bId]=103; CaseBonus[0][2][bNumberOpen]=20; CaseBonus[0][2][bRarity]=2; CaseBonus[0][2][bType]=4; CaseBonus[0][2][bInternalId]=2; CaseBonus[0][2][bCount]=1; CaseBonus[0][2][bPriceSprayed]=0;
	CaseBonus[0][3][bId]=104; CaseBonus[0][3][bNumberOpen]=10; CaseBonus[0][3][bRarity]=1; CaseBonus[0][3][bType]=4; CaseBonus[0][3][bInternalId]=1; CaseBonus[0][3][bCount]=2; CaseBonus[0][3][bPriceSprayed]=0;
	CaseBonus[0][4][bId]=105; CaseBonus[0][4][bNumberOpen]=5; CaseBonus[0][4][bRarity]=1; CaseBonus[0][4][bType]=4; CaseBonus[0][4][bInternalId]=1; CaseBonus[0][4][bCount]=1; CaseBonus[0][4][bPriceSprayed]=0;
}
stock Cases_InitCase2Awards()
{
	CaseAwards[1][0][aId]=1; CaseAwards[1][0][aRarity]=1; CaseAwards[1][0][aType]=5; CaseAwards[1][0][aInternalId]=468; CaseAwards[1][0][aCount]=0; CaseAwards[1][0][aPriceSprayed]=20;
	CaseAwards[1][1][aId]=2; CaseAwards[1][1][aRarity]=1; CaseAwards[1][1][aType]=5; CaseAwards[1][1][aInternalId]=496; CaseAwards[1][1][aCount]=0; CaseAwards[1][1][aPriceSprayed]=20;
	CaseAwards[1][2][aId]=3; CaseAwards[1][2][aRarity]=1; CaseAwards[1][2][aType]=2; CaseAwards[1][2][aInternalId]=1; CaseAwards[1][2][aCount]=75000; CaseAwards[1][2][aPriceSprayed]=0;
	CaseAwards[1][3][aId]=4; CaseAwards[1][3][aRarity]=1; CaseAwards[1][3][aType]=5; CaseAwards[1][3][aInternalId]=28670; CaseAwards[1][3][aCount]=0; CaseAwards[1][3][aPriceSprayed]=20;
	CaseAwards[1][4][aId]=5; CaseAwards[1][4][aRarity]=1; CaseAwards[1][4][aType]=1; CaseAwards[1][4][aInternalId]=1; CaseAwards[1][4][aCount]=8; CaseAwards[1][4][aPriceSprayed]=0;
	CaseAwards[1][5][aId]=6; CaseAwards[1][5][aRarity]=1; CaseAwards[1][5][aType]=5; CaseAwards[1][5][aInternalId]=439; CaseAwards[1][5][aCount]=0; CaseAwards[1][5][aPriceSprayed]=20;
	CaseAwards[1][6][aId]=7; CaseAwards[1][6][aRarity]=1; CaseAwards[1][6][aType]=2; CaseAwards[1][6][aInternalId]=1; CaseAwards[1][6][aCount]=90000; CaseAwards[1][6][aPriceSprayed]=0;
	CaseAwards[1][7][aId]=8; CaseAwards[1][7][aRarity]=1; CaseAwards[1][7][aType]=5; CaseAwards[1][7][aInternalId]=492; CaseAwards[1][7][aCount]=0; CaseAwards[1][7][aPriceSprayed]=20;
	CaseAwards[1][8][aId]=9; CaseAwards[1][8][aRarity]=1; CaseAwards[1][8][aType]=5; CaseAwards[1][8][aInternalId]=547; CaseAwards[1][8][aCount]=0; CaseAwards[1][8][aPriceSprayed]=20;
	CaseAwards[1][9][aId]=10; CaseAwards[1][9][aRarity]=1; CaseAwards[1][9][aType]=5; CaseAwards[1][9][aInternalId]=458; CaseAwards[1][9][aCount]=0; CaseAwards[1][9][aPriceSprayed]=20;
	CaseAwards[1][10][aId]=11; CaseAwards[1][10][aRarity]=1; CaseAwards[1][10][aType]=9; CaseAwards[1][10][aInternalId]=1; CaseAwards[1][10][aCount]=168; CaseAwards[1][10][aPriceSprayed]=20;
	CaseAwards[1][11][aId]=12; CaseAwards[1][11][aRarity]=1; CaseAwards[1][11][aType]=5; CaseAwards[1][11][aInternalId]=491; CaseAwards[1][11][aCount]=0; CaseAwards[1][11][aPriceSprayed]=20;
	CaseAwards[1][12][aId]=13; CaseAwards[1][12][aRarity]=1; CaseAwards[1][12][aType]=5; CaseAwards[1][12][aInternalId]=585; CaseAwards[1][12][aCount]=0; CaseAwards[1][12][aPriceSprayed]=20;
	CaseAwards[1][13][aId]=14; CaseAwards[1][13][aRarity]=1; CaseAwards[1][13][aType]=1; CaseAwards[1][13][aInternalId]=1; CaseAwards[1][13][aCount]=12; CaseAwards[1][13][aPriceSprayed]=0;
	CaseAwards[1][14][aId]=15; CaseAwards[1][14][aRarity]=1; CaseAwards[1][14][aType]=2; CaseAwards[1][14][aInternalId]=1; CaseAwards[1][14][aCount]=120000; CaseAwards[1][14][aPriceSprayed]=0;
	CaseAwards[1][15][aId]=16; CaseAwards[1][15][aRarity]=1; CaseAwards[1][15][aType]=9; CaseAwards[1][15][aInternalId]=2; CaseAwards[1][15][aCount]=72; CaseAwards[1][15][aPriceSprayed]=20;
	CaseAwards[1][16][aId]=17; CaseAwards[1][16][aRarity]=1; CaseAwards[1][16][aType]=5; CaseAwards[1][16][aInternalId]=536; CaseAwards[1][16][aCount]=0; CaseAwards[1][16][aPriceSprayed]=20;
	CaseAwards[1][17][aId]=18; CaseAwards[1][17][aRarity]=1; CaseAwards[1][17][aType]=5; CaseAwards[1][17][aInternalId]=529; CaseAwards[1][17][aCount]=0; CaseAwards[1][17][aPriceSprayed]=20;
	CaseAwards[1][18][aId]=19; CaseAwards[1][18][aRarity]=1; CaseAwards[1][18][aType]=9; CaseAwards[1][18][aInternalId]=3; CaseAwards[1][18][aCount]=72; CaseAwards[1][18][aPriceSprayed]=20;
	CaseAwards[1][19][aId]=20; CaseAwards[1][19][aRarity]=1; CaseAwards[1][19][aType]=5; CaseAwards[1][19][aInternalId]=542; CaseAwards[1][19][aCount]=0; CaseAwards[1][19][aPriceSprayed]=20;
	CaseAwards[1][20][aId]=21; CaseAwards[1][20][aRarity]=1; CaseAwards[1][20][aType]=5; CaseAwards[1][20][aInternalId]=421; CaseAwards[1][20][aCount]=0; CaseAwards[1][20][aPriceSprayed]=20;
	CaseAwards[1][21][aId]=22; CaseAwards[1][21][aRarity]=2; CaseAwards[1][21][aType]=5; CaseAwards[1][21][aInternalId]=2618; CaseAwards[1][21][aCount]=0; CaseAwards[1][21][aPriceSprayed]=30;
	CaseAwards[1][22][aId]=23; CaseAwards[1][22][aRarity]=2; CaseAwards[1][22][aType]=5; CaseAwards[1][22][aInternalId]=419; CaseAwards[1][22][aCount]=0; CaseAwards[1][22][aPriceSprayed]=30;
	CaseAwards[1][23][aId]=24; CaseAwards[1][23][aRarity]=3; CaseAwards[1][23][aType]=11; CaseAwards[1][23][aInternalId]=705; CaseAwards[1][23][aCount]=1; CaseAwards[1][23][aPriceSprayed]=30;
	CaseAwards[1][24][aId]=25; CaseAwards[1][24][aRarity]=2; CaseAwards[1][24][aType]=5; CaseAwards[1][24][aInternalId]=546; CaseAwards[1][24][aCount]=0; CaseAwards[1][24][aPriceSprayed]=30;
	CaseAwards[1][25][aId]=26; CaseAwards[1][25][aRarity]=3; CaseAwards[1][25][aType]=11; CaseAwards[1][25][aInternalId]=706; CaseAwards[1][25][aCount]=1; CaseAwards[1][25][aPriceSprayed]=30;
	CaseAwards[1][26][aId]=27; CaseAwards[1][26][aRarity]=3; CaseAwards[1][26][aType]=11; CaseAwards[1][26][aInternalId]=134; CaseAwards[1][26][aCount]=6810; CaseAwards[1][26][aPriceSprayed]=40;
}

stock Cases_InitCase2Bonus()
{
	CaseBonus[1][0][bId]=201; CaseBonus[1][0][bNumberOpen]=40; CaseBonus[1][0][bRarity]=5; CaseBonus[1][0][bType]=5; CaseBonus[1][0][bInternalId]=467; CaseBonus[1][0][bCount]=0; CaseBonus[1][0][bPriceSprayed]=100;
	CaseBonus[1][1][bId]=202; CaseBonus[1][1][bNumberOpen]=30; CaseBonus[1][1][bRarity]=3; CaseBonus[1][1][bType]=21; CaseBonus[1][1][bInternalId]=1; CaseBonus[1][1][bCount]=100; CaseBonus[1][1][bPriceSprayed]=0;
	CaseBonus[1][2][bId]=203; CaseBonus[1][2][bNumberOpen]=20; CaseBonus[1][2][bRarity]=3; CaseBonus[1][2][bType]=4; CaseBonus[1][2][bInternalId]=2; CaseBonus[1][2][bCount]=2; CaseBonus[1][2][bPriceSprayed]=0;
	CaseBonus[1][3][bId]=204; CaseBonus[1][3][bNumberOpen]=10; CaseBonus[1][3][bRarity]=3; CaseBonus[1][3][bType]=21; CaseBonus[1][3][bInternalId]=1; CaseBonus[1][3][bCount]=50; CaseBonus[1][3][bPriceSprayed]=0;
	CaseBonus[1][4][bId]=205; CaseBonus[1][4][bNumberOpen]=5; CaseBonus[1][4][bRarity]=3; CaseBonus[1][4][bType]=4; CaseBonus[1][4][bInternalId]=2; CaseBonus[1][4][bCount]=1; CaseBonus[1][4][bPriceSprayed]=0;
}
stock Cases_InitCase3Awards()
{
	CaseAwards[2][0][aId]=1; CaseAwards[2][0][aRarity]=2; CaseAwards[2][0][aType]=11; CaseAwards[2][0][aInternalId]=363; CaseAwards[2][0][aCount]=1; CaseAwards[2][0][aPriceSprayed]=90;
	CaseAwards[2][1][aId]=2; CaseAwards[2][1][aRarity]=2; CaseAwards[2][1][aType]=9; CaseAwards[2][1][aInternalId]=2; CaseAwards[2][1][aCount]=504; CaseAwards[2][1][aPriceSprayed]=90;
	CaseAwards[2][2][aId]=3; CaseAwards[2][2][aRarity]=2; CaseAwards[2][2][aType]=2; CaseAwards[2][2][aInternalId]=1; CaseAwards[2][2][aCount]=600000; CaseAwards[2][2][aPriceSprayed]=0;
	CaseAwards[2][3][aId]=4; CaseAwards[2][3][aRarity]=2; CaseAwards[2][3][aType]=11; CaseAwards[2][3][aInternalId]=360; CaseAwards[2][3][aCount]=1; CaseAwards[2][3][aPriceSprayed]=90;
	CaseAwards[2][4][aId]=5; CaseAwards[2][4][aRarity]=2; CaseAwards[2][4][aType]=5; CaseAwards[2][4][aInternalId]=527; CaseAwards[2][4][aCount]=0; CaseAwards[2][4][aPriceSprayed]=100;
	CaseAwards[2][5][aId]=6; CaseAwards[2][5][aRarity]=2; CaseAwards[2][5][aType]=3; CaseAwards[2][5][aInternalId]=1; CaseAwards[2][5][aCount]=600; CaseAwards[2][5][aPriceSprayed]=0;
	CaseAwards[2][6][aId]=7; CaseAwards[2][6][aRarity]=2; CaseAwards[2][6][aType]=9; CaseAwards[2][6][aInternalId]=3; CaseAwards[2][6][aCount]=360; CaseAwards[2][6][aPriceSprayed]=100;
	CaseAwards[2][7][aId]=8; CaseAwards[2][7][aRarity]=2; CaseAwards[2][7][aType]=5; CaseAwards[2][7][aInternalId]=445; CaseAwards[2][7][aCount]=0; CaseAwards[2][7][aPriceSprayed]=100;
	CaseAwards[2][8][aId]=9; CaseAwards[2][8][aRarity]=2; CaseAwards[2][8][aType]=11; CaseAwards[2][8][aInternalId]=583; CaseAwards[2][8][aCount]=1; CaseAwards[2][8][aPriceSprayed]=100;
	CaseAwards[2][9][aId]=10; CaseAwards[2][9][aRarity]=2; CaseAwards[2][9][aType]=11; CaseAwards[2][9][aInternalId]=134; CaseAwards[2][9][aCount]=14386; CaseAwards[2][9][aPriceSprayed]=100;
	CaseAwards[2][10][aId]=11; CaseAwards[2][10][aRarity]=2; CaseAwards[2][10][aType]=11; CaseAwards[2][10][aInternalId]=508; CaseAwards[2][10][aCount]=1; CaseAwards[2][10][aPriceSprayed]=100;
	CaseAwards[2][11][aId]=12; CaseAwards[2][11][aRarity]=2; CaseAwards[2][11][aType]=11; CaseAwards[2][11][aInternalId]=134; CaseAwards[2][11][aCount]=11917; CaseAwards[2][11][aPriceSprayed]=110;
	CaseAwards[2][12][aId]=13; CaseAwards[2][12][aRarity]=2; CaseAwards[2][12][aType]=5; CaseAwards[2][12][aInternalId]=589; CaseAwards[2][12][aCount]=0; CaseAwards[2][12][aPriceSprayed]=110;
	CaseAwards[2][13][aId]=14; CaseAwards[2][13][aRarity]=2; CaseAwards[2][13][aType]=5; CaseAwards[2][13][aInternalId]=2568; CaseAwards[2][13][aCount]=0; CaseAwards[2][13][aPriceSprayed]=110;
	CaseAwards[2][14][aId]=15; CaseAwards[2][14][aRarity]=2; CaseAwards[2][14][aType]=11; CaseAwards[2][14][aInternalId]=134; CaseAwards[2][14][aCount]=11961; CaseAwards[2][14][aPriceSprayed]=140;
	CaseAwards[2][15][aId]=16; CaseAwards[2][15][aRarity]=2; CaseAwards[2][15][aType]=5; CaseAwards[2][15][aInternalId]=2385; CaseAwards[2][15][aCount]=0; CaseAwards[2][15][aPriceSprayed]=120;
	CaseAwards[2][16][aId]=17; CaseAwards[2][16][aRarity]=2; CaseAwards[2][16][aType]=5; CaseAwards[2][16][aInternalId]=28695; CaseAwards[2][16][aCount]=0; CaseAwards[2][16][aPriceSprayed]=120;
	CaseAwards[2][17][aId]=18; CaseAwards[2][17][aRarity]=2; CaseAwards[2][17][aType]=5; CaseAwards[2][17][aInternalId]=2627; CaseAwards[2][17][aCount]=0; CaseAwards[2][17][aPriceSprayed]=120;
	CaseAwards[2][18][aId]=19; CaseAwards[2][18][aRarity]=2; CaseAwards[2][18][aType]=5; CaseAwards[2][18][aInternalId]=461; CaseAwards[2][18][aCount]=0; CaseAwards[2][18][aPriceSprayed]=130;
	CaseAwards[2][19][aId]=20; CaseAwards[2][19][aRarity]=2; CaseAwards[2][19][aType]=2; CaseAwards[2][19][aInternalId]=1; CaseAwards[2][19][aCount]=1000000; CaseAwards[2][19][aPriceSprayed]=0;
	CaseAwards[2][20][aId]=21; CaseAwards[2][20][aRarity]=3; CaseAwards[2][20][aType]=9; CaseAwards[2][20][aInternalId]=3; CaseAwards[2][20][aCount]=720; CaseAwards[2][20][aPriceSprayed]=130;
	CaseAwards[2][21][aId]=22; CaseAwards[2][21][aRarity]=3; CaseAwards[2][21][aType]=11; CaseAwards[2][21][aInternalId]=134; CaseAwards[2][21][aCount]=236; CaseAwards[2][21][aPriceSprayed]=130;
	CaseAwards[2][22][aId]=23; CaseAwards[2][22][aRarity]=3; CaseAwards[2][22][aType]=5; CaseAwards[2][22][aInternalId]=2567; CaseAwards[2][22][aCount]=0; CaseAwards[2][22][aPriceSprayed]=130;
	CaseAwards[2][23][aId]=24; CaseAwards[2][23][aRarity]=3; CaseAwards[2][23][aType]=11; CaseAwards[2][23][aInternalId]=134; CaseAwards[2][23][aCount]=11935; CaseAwards[2][23][aPriceSprayed]=140;
	CaseAwards[2][24][aId]=25; CaseAwards[2][24][aRarity]=3; CaseAwards[2][24][aType]=5; CaseAwards[2][24][aInternalId]=560; CaseAwards[2][24][aCount]=0; CaseAwards[2][24][aPriceSprayed]=140;
	CaseAwards[2][25][aId]=26; CaseAwards[2][25][aRarity]=3; CaseAwards[2][25][aType]=11; CaseAwards[2][25][aInternalId]=134; CaseAwards[2][25][aCount]=19262; CaseAwards[2][25][aPriceSprayed]=140;
	CaseAwards[2][26][aId]=27; CaseAwards[2][26][aRarity]=3; CaseAwards[2][26][aType]=5; CaseAwards[2][26][aInternalId]=2584; CaseAwards[2][26][aCount]=0; CaseAwards[2][26][aPriceSprayed]=150;
	CaseAwards[2][27][aId]=28; CaseAwards[2][27][aRarity]=3; CaseAwards[2][27][aType]=5; CaseAwards[2][27][aInternalId]=2390; CaseAwards[2][27][aCount]=0; CaseAwards[2][27][aPriceSprayed]=160;
	CaseAwards[2][28][aId]=29; CaseAwards[2][28][aRarity]=3; CaseAwards[2][28][aType]=5; CaseAwards[2][28][aInternalId]=543; CaseAwards[2][28][aCount]=0; CaseAwards[2][28][aPriceSprayed]=200;
	CaseAwards[2][29][aId]=30; CaseAwards[2][29][aRarity]=3; CaseAwards[2][29][aType]=5; CaseAwards[2][29][aInternalId]=480; CaseAwards[2][29][aCount]=0; CaseAwards[2][29][aPriceSprayed]=200;
	CaseAwards[2][30][aId]=31; CaseAwards[2][30][aRarity]=4; CaseAwards[2][30][aType]=11; CaseAwards[2][30][aInternalId]=707; CaseAwards[2][30][aCount]=1; CaseAwards[2][30][aPriceSprayed]=220;
	CaseAwards[2][31][aId]=32; CaseAwards[2][31][aRarity]=4; CaseAwards[2][31][aType]=5; CaseAwards[2][31][aInternalId]=402; CaseAwards[2][31][aCount]=0; CaseAwards[2][31][aPriceSprayed]=240;
	CaseAwards[2][32][aId]=33; CaseAwards[2][32][aRarity]=4; CaseAwards[2][32][aType]=5; CaseAwards[2][32][aInternalId]=2598; CaseAwards[2][32][aCount]=0; CaseAwards[2][32][aPriceSprayed]=250;
	CaseAwards[2][33][aId]=34; CaseAwards[2][33][aRarity]=4; CaseAwards[2][33][aType]=5; CaseAwards[2][33][aInternalId]=400; CaseAwards[2][33][aCount]=0; CaseAwards[2][33][aPriceSprayed]=260;
	CaseAwards[2][34][aId]=35; CaseAwards[2][34][aRarity]=4; CaseAwards[2][34][aType]=5; CaseAwards[2][34][aInternalId]=506; CaseAwards[2][34][aCount]=0; CaseAwards[2][34][aPriceSprayed]=270;
	CaseAwards[2][35][aId]=36; CaseAwards[2][35][aRarity]=5; CaseAwards[2][35][aType]=5; CaseAwards[2][35][aInternalId]=415; CaseAwards[2][35][aCount]=0; CaseAwards[2][35][aPriceSprayed]=400;
	CaseAwards[2][36][aId]=37; CaseAwards[2][36][aRarity]=5; CaseAwards[2][36][aType]=5; CaseAwards[2][36][aInternalId]=2543; CaseAwards[2][36][aCount]=0; CaseAwards[2][36][aPriceSprayed]=400;
}

stock Cases_InitCase3Bonus()
{
	CaseBonus[2][0][bId]=301; CaseBonus[2][0][bNumberOpen]=40; CaseBonus[2][0][bRarity]=5; CaseBonus[2][0][bType]=5; CaseBonus[2][0][bInternalId]=2581; CaseBonus[2][0][bCount]=0; CaseBonus[2][0][bPriceSprayed]=400;
	CaseBonus[2][1][bId]=302; CaseBonus[2][1][bNumberOpen]=30; CaseBonus[2][1][bRarity]=4; CaseBonus[2][1][bType]=21; CaseBonus[2][1][bInternalId]=1; CaseBonus[2][1][bCount]=250; CaseBonus[2][1][bPriceSprayed]=0;
	CaseBonus[2][2][bId]=303; CaseBonus[2][2][bNumberOpen]=20; CaseBonus[2][2][bRarity]=4; CaseBonus[2][2][bType]=4; CaseBonus[2][2][bInternalId]=3; CaseBonus[2][2][bCount]=2; CaseBonus[2][2][bPriceSprayed]=0;
	CaseBonus[2][3][bId]=304; CaseBonus[2][3][bNumberOpen]=10; CaseBonus[2][3][bRarity]=3; CaseBonus[2][3][bType]=21; CaseBonus[2][3][bInternalId]=1; CaseBonus[2][3][bCount]=150; CaseBonus[2][3][bPriceSprayed]=0;
	CaseBonus[2][4][bId]=305; CaseBonus[2][4][bNumberOpen]=5; CaseBonus[2][4][bRarity]=4; CaseBonus[2][4][bType]=4; CaseBonus[2][4][bInternalId]=3; CaseBonus[2][4][bCount]=1; CaseBonus[2][4][bPriceSprayed]=0;
}

stock Cases_InitCase4Awards()
{
	CaseAwards[3][0][aId]=1; CaseAwards[3][0][aRarity]=3; CaseAwards[3][0][aType]=5; CaseAwards[3][0][aInternalId]=436; CaseAwards[3][0][aCount]=0; CaseAwards[3][0][aPriceSprayed]=130;
	CaseAwards[3][1][aId]=2; CaseAwards[3][1][aRarity]=3; CaseAwards[3][1][aType]=5; CaseAwards[3][1][aInternalId]=2567; CaseAwards[3][1][aCount]=0; CaseAwards[3][1][aPriceSprayed]=130;
	CaseAwards[3][2][aId]=3; CaseAwards[3][2][aRarity]=3; CaseAwards[3][2][aType]=5; CaseAwards[3][2][aInternalId]=560; CaseAwards[3][2][aCount]=0; CaseAwards[3][2][aPriceSprayed]=140;
	CaseAwards[3][3][aId]=4; CaseAwards[3][3][aRarity]=3; CaseAwards[3][3][aType]=5; CaseAwards[3][3][aInternalId]=550; CaseAwards[3][3][aCount]=0; CaseAwards[3][3][aPriceSprayed]=140;
	CaseAwards[3][4][aId]=5; CaseAwards[3][4][aRarity]=3; CaseAwards[3][4][aType]=5; CaseAwards[3][4][aInternalId]=28671; CaseAwards[3][4][aCount]=0; CaseAwards[3][4][aPriceSprayed]=150;
	CaseAwards[3][5][aId]=6; CaseAwards[3][5][aRarity]=3; CaseAwards[3][5][aType]=5; CaseAwards[3][5][aInternalId]=603; CaseAwards[3][5][aCount]=0; CaseAwards[3][5][aPriceSprayed]=150;
	CaseAwards[3][6][aId]=7; CaseAwards[3][6][aRarity]=3; CaseAwards[3][6][aType]=5; CaseAwards[3][6][aInternalId]=2552; CaseAwards[3][6][aCount]=0; CaseAwards[3][6][aPriceSprayed]=150;
	CaseAwards[3][7][aId]=8; CaseAwards[3][7][aRarity]=3; CaseAwards[3][7][aType]=5; CaseAwards[3][7][aInternalId]=565; CaseAwards[3][7][aCount]=0; CaseAwards[3][7][aPriceSprayed]=150;
	CaseAwards[3][8][aId]=9; CaseAwards[3][8][aRarity]=3; CaseAwards[3][8][aType]=5; CaseAwards[3][8][aInternalId]=2609; CaseAwards[3][8][aCount]=0; CaseAwards[3][8][aPriceSprayed]=160;
	CaseAwards[3][9][aId]=10; CaseAwards[3][9][aRarity]=3; CaseAwards[3][9][aType]=5; CaseAwards[3][9][aInternalId]=2604; CaseAwards[3][9][aCount]=0; CaseAwards[3][9][aPriceSprayed]=160;
	CaseAwards[3][10][aId]=11; CaseAwards[3][10][aRarity]=3; CaseAwards[3][10][aType]=5; CaseAwards[3][10][aInternalId]=551; CaseAwards[3][10][aCount]=0; CaseAwards[3][10][aPriceSprayed]=160;
	CaseAwards[3][11][aId]=12; CaseAwards[3][11][aRarity]=3; CaseAwards[3][11][aType]=5; CaseAwards[3][11][aInternalId]=2390; CaseAwards[3][11][aCount]=0; CaseAwards[3][11][aPriceSprayed]=160;
	CaseAwards[3][12][aId]=13; CaseAwards[3][12][aRarity]=3; CaseAwards[3][12][aType]=5; CaseAwards[3][12][aInternalId]=526; CaseAwards[3][12][aCount]=0; CaseAwards[3][12][aPriceSprayed]=160;
	CaseAwards[3][13][aId]=14; CaseAwards[3][13][aRarity]=3; CaseAwards[3][13][aType]=5; CaseAwards[3][13][aInternalId]=2620; CaseAwards[3][13][aCount]=0; CaseAwards[3][13][aPriceSprayed]=170;
	CaseAwards[3][14][aId]=15; CaseAwards[3][14][aRarity]=3; CaseAwards[3][14][aType]=5; CaseAwards[3][14][aInternalId]=2594; CaseAwards[3][14][aCount]=0; CaseAwards[3][14][aPriceSprayed]=180;
	CaseAwards[3][15][aId]=16; CaseAwards[3][15][aRarity]=3; CaseAwards[3][15][aType]=5; CaseAwards[3][15][aInternalId]=2621; CaseAwards[3][15][aCount]=0; CaseAwards[3][15][aPriceSprayed]=180;
	CaseAwards[3][16][aId]=17; CaseAwards[3][16][aRarity]=3; CaseAwards[3][16][aType]=5; CaseAwards[3][16][aInternalId]=2387; CaseAwards[3][16][aCount]=0; CaseAwards[3][16][aPriceSprayed]=200;
	CaseAwards[3][17][aId]=18; CaseAwards[3][17][aRarity]=3; CaseAwards[3][17][aType]=5; CaseAwards[3][17][aInternalId]=480; CaseAwards[3][17][aCount]=0; CaseAwards[3][17][aPriceSprayed]=200;
	CaseAwards[3][18][aId]=19; CaseAwards[3][18][aRarity]=3; CaseAwards[3][18][aType]=5; CaseAwards[3][18][aInternalId]=2394; CaseAwards[3][18][aCount]=0; CaseAwards[3][18][aPriceSprayed]=200;
	CaseAwards[3][19][aId]=20; CaseAwards[3][19][aRarity]=3; CaseAwards[3][19][aType]=5; CaseAwards[3][19][aInternalId]=558; CaseAwards[3][19][aCount]=0; CaseAwards[3][19][aPriceSprayed]=210;
	CaseAwards[3][20][aId]=21; CaseAwards[3][20][aRarity]=4; CaseAwards[3][20][aType]=5; CaseAwards[3][20][aInternalId]=28694; CaseAwards[3][20][aCount]=0; CaseAwards[3][20][aPriceSprayed]=450;
	CaseAwards[3][21][aId]=22; CaseAwards[3][21][aRarity]=4; CaseAwards[3][21][aType]=5; CaseAwards[3][21][aInternalId]=28697; CaseAwards[3][21][aCount]=0; CaseAwards[3][21][aPriceSprayed]=450;
	CaseAwards[3][22][aId]=23; CaseAwards[3][22][aRarity]=4; CaseAwards[3][22][aType]=5; CaseAwards[3][22][aInternalId]=402; CaseAwards[3][22][aCount]=0; CaseAwards[3][22][aPriceSprayed]=240;
	CaseAwards[3][23][aId]=24; CaseAwards[3][23][aRarity]=4; CaseAwards[3][23][aType]=5; CaseAwards[3][23][aInternalId]=505; CaseAwards[3][23][aCount]=0; CaseAwards[3][23][aPriceSprayed]=240;
	CaseAwards[3][24][aId]=25; CaseAwards[3][24][aRarity]=4; CaseAwards[3][24][aType]=5; CaseAwards[3][24][aInternalId]=2598; CaseAwards[3][24][aCount]=0; CaseAwards[3][24][aPriceSprayed]=250;
	CaseAwards[3][25][aId]=26; CaseAwards[3][25][aRarity]=4; CaseAwards[3][25][aType]=5; CaseAwards[3][25][aInternalId]=400; CaseAwards[3][25][aCount]=0; CaseAwards[3][25][aPriceSprayed]=260;
	CaseAwards[3][26][aId]=27; CaseAwards[3][26][aRarity]=4; CaseAwards[3][26][aType]=5; CaseAwards[3][26][aInternalId]=2547; CaseAwards[3][26][aCount]=0; CaseAwards[3][26][aPriceSprayed]=250;
	CaseAwards[3][27][aId]=28; CaseAwards[3][27][aRarity]=4; CaseAwards[3][27][aType]=5; CaseAwards[3][27][aInternalId]=506; CaseAwards[3][27][aCount]=0; CaseAwards[3][27][aPriceSprayed]=270;
	CaseAwards[3][28][aId]=29; CaseAwards[3][28][aRarity]=4; CaseAwards[3][28][aType]=5; CaseAwards[3][28][aInternalId]=763; CaseAwards[3][28][aCount]=0; CaseAwards[3][28][aPriceSprayed]=280;
	CaseAwards[3][29][aId]=30; CaseAwards[3][29][aRarity]=4; CaseAwards[3][29][aType]=5; CaseAwards[3][29][aInternalId]=28693; CaseAwards[3][29][aCount]=0; CaseAwards[3][29][aPriceSprayed]=450;
	CaseAwards[3][30][aId]=31; CaseAwards[3][30][aRarity]=5; CaseAwards[3][30][aType]=5; CaseAwards[3][30][aInternalId]=415; CaseAwards[3][30][aCount]=0; CaseAwards[3][30][aPriceSprayed]=400;
	CaseAwards[3][31][aId]=32; CaseAwards[3][31][aRarity]=5; CaseAwards[3][31][aType]=5; CaseAwards[3][31][aInternalId]=2543; CaseAwards[3][31][aCount]=0; CaseAwards[3][31][aPriceSprayed]=400;
	CaseAwards[3][32][aId]=33; CaseAwards[3][32][aRarity]=5; CaseAwards[3][32][aType]=5; CaseAwards[3][32][aInternalId]=2573; CaseAwards[3][32][aCount]=0; CaseAwards[3][32][aPriceSprayed]=430;
	CaseAwards[3][33][aId]=34; CaseAwards[3][33][aRarity]=5; CaseAwards[3][33][aType]=5; CaseAwards[3][33][aInternalId]=2558; CaseAwards[3][33][aCount]=0; CaseAwards[3][33][aPriceSprayed]=450;
	CaseAwards[3][34][aId]=35; CaseAwards[3][34][aRarity]=5; CaseAwards[3][34][aType]=5; CaseAwards[3][34][aInternalId]=2597; CaseAwards[3][34][aCount]=0; CaseAwards[3][34][aPriceSprayed]=450;
	CaseAwards[3][35][aId]=36; CaseAwards[3][35][aRarity]=5; CaseAwards[3][35][aType]=5; CaseAwards[3][35][aInternalId]=2558; CaseAwards[3][35][aCount]=0; CaseAwards[3][35][aPriceSprayed]=450;
	CaseAwards[3][36][aId]=37; CaseAwards[3][36][aRarity]=5; CaseAwards[3][36][aType]=5; CaseAwards[3][36][aInternalId]=28672; CaseAwards[3][36][aCount]=0; CaseAwards[3][36][aPriceSprayed]=450;
}

stock Cases_InitCase4Bonus()
{
	CaseBonus[3][0][bId]=401; CaseBonus[3][0][bNumberOpen]=40; CaseBonus[3][0][bRarity]=5; CaseBonus[3][0][bType]=5; CaseBonus[3][0][bInternalId]=668; CaseBonus[3][0][bCount]=0; CaseBonus[3][0][bPriceSprayed]=500;
	CaseBonus[3][1][bId]=402; CaseBonus[3][1][bNumberOpen]=30; CaseBonus[3][1][bRarity]=4; CaseBonus[3][1][bType]=21; CaseBonus[3][1][bInternalId]=1; CaseBonus[3][1][bCount]=500; CaseBonus[3][1][bPriceSprayed]=0;
	CaseBonus[3][2][bId]=403; CaseBonus[3][2][bNumberOpen]=20; CaseBonus[3][2][bRarity]=4; CaseBonus[3][2][bType]=4; CaseBonus[3][2][bInternalId]=4; CaseBonus[3][2][bCount]=2; CaseBonus[3][2][bPriceSprayed]=0;
	CaseBonus[3][3][bId]=404; CaseBonus[3][3][bNumberOpen]=10; CaseBonus[3][3][bRarity]=4; CaseBonus[3][3][bType]=21; CaseBonus[3][3][bInternalId]=1; CaseBonus[3][3][bCount]=300; CaseBonus[3][3][bPriceSprayed]=0;
	CaseBonus[3][4][bId]=405; CaseBonus[3][4][bNumberOpen]=5; CaseBonus[3][4][bRarity]=4; CaseBonus[3][4][bType]=4; CaseBonus[3][4][bInternalId]=4; CaseBonus[3][4][bCount]=1; CaseBonus[3][4][bPriceSprayed]=0;
}

stock Cases_InitCase5Awards()
{
	CaseAwards[4][0][aId]=1; CaseAwards[4][0][aRarity]=4; CaseAwards[4][0][aType]=5; CaseAwards[4][0][aInternalId]=410; CaseAwards[4][0][aCount]=0; CaseAwards[4][0][aPriceSprayed]=230;
	CaseAwards[4][1][aId]=2; CaseAwards[4][1][aRarity]=4; CaseAwards[4][1][aType]=5; CaseAwards[4][1][aInternalId]=604; CaseAwards[4][1][aCount]=0; CaseAwards[4][1][aPriceSprayed]=260;
	CaseAwards[4][2][aId]=3; CaseAwards[4][2][aRarity]=4; CaseAwards[4][2][aType]=5; CaseAwards[4][2][aInternalId]=2389; CaseAwards[4][2][aCount]=0; CaseAwards[4][2][aPriceSprayed]=270;
	CaseAwards[4][3][aId]=4; CaseAwards[4][3][aRarity]=4; CaseAwards[4][3][aType]=5; CaseAwards[4][3][aInternalId]=2574; CaseAwards[4][3][aCount]=0; CaseAwards[4][3][aPriceSprayed]=290;
	CaseAwards[4][4][aId]=5; CaseAwards[4][4][aRarity]=4; CaseAwards[4][4][aType]=5; CaseAwards[4][4][aInternalId]=451; CaseAwards[4][4][aCount]=0; CaseAwards[4][4][aPriceSprayed]=340;
	CaseAwards[4][5][aId]=6; CaseAwards[4][5][aRarity]=4; CaseAwards[4][5][aType]=5; CaseAwards[4][5][aInternalId]=2626; CaseAwards[4][5][aCount]=0; CaseAwards[4][5][aPriceSprayed]=350;
	CaseAwards[4][6][aId]=7; CaseAwards[4][6][aRarity]=4; CaseAwards[4][6][aType]=5; CaseAwards[4][6][aInternalId]=2551; CaseAwards[4][6][aCount]=0; CaseAwards[4][6][aPriceSprayed]=350;
	CaseAwards[4][7][aId]=8; CaseAwards[4][7][aRarity]=4; CaseAwards[4][7][aType]=5; CaseAwards[4][7][aInternalId]=2549; CaseAwards[4][7][aCount]=0; CaseAwards[4][7][aPriceSprayed]=370;
	CaseAwards[4][8][aId]=9; CaseAwards[4][8][aRarity]=4; CaseAwards[4][8][aType]=5; CaseAwards[4][8][aInternalId]=2393; CaseAwards[4][8][aCount]=0; CaseAwards[4][8][aPriceSprayed]=370;
	CaseAwards[4][9][aId]=10; CaseAwards[4][9][aRarity]=4; CaseAwards[4][9][aType]=5; CaseAwards[4][9][aInternalId]=579; CaseAwards[4][9][aCount]=0; CaseAwards[4][9][aPriceSprayed]=370;
	CaseAwards[4][10][aId]=11; CaseAwards[4][10][aRarity]=5; CaseAwards[4][10][aType]=5; CaseAwards[4][10][aInternalId]=2619; CaseAwards[4][10][aCount]=0; CaseAwards[4][10][aPriceSprayed]=460;
	CaseAwards[4][11][aId]=12; CaseAwards[4][11][aRarity]=5; CaseAwards[4][11][aType]=5; CaseAwards[4][11][aInternalId]=657; CaseAwards[4][11][aCount]=0; CaseAwards[4][11][aPriceSprayed]=490;
	CaseAwards[4][12][aId]=13; CaseAwards[4][12][aRarity]=5; CaseAwards[4][12][aType]=5; CaseAwards[4][12][aInternalId]=669; CaseAwards[4][12][aCount]=0; CaseAwards[4][12][aPriceSprayed]=570;
	CaseAwards[4][13][aId]=14; CaseAwards[4][13][aRarity]=5; CaseAwards[4][13][aType]=5; CaseAwards[4][13][aInternalId]=2564; CaseAwards[4][13][aCount]=0; CaseAwards[4][13][aPriceSprayed]=570;
	CaseAwards[4][14][aId]=15; CaseAwards[4][14][aRarity]=5; CaseAwards[4][14][aType]=5; CaseAwards[4][14][aInternalId]=765; CaseAwards[4][14][aCount]=0; CaseAwards[4][14][aPriceSprayed]=600;
	CaseAwards[4][15][aId]=16; CaseAwards[4][15][aRarity]=5; CaseAwards[4][15][aType]=5; CaseAwards[4][15][aInternalId]=2591; CaseAwards[4][15][aCount]=0; CaseAwards[4][15][aPriceSprayed]=670;
	CaseAwards[4][16][aId]=17; CaseAwards[4][16][aRarity]=5; CaseAwards[4][16][aType]=5; CaseAwards[4][16][aInternalId]=2607; CaseAwards[4][16][aCount]=0; CaseAwards[4][16][aPriceSprayed]=750;
	CaseAwards[4][17][aId]=18; CaseAwards[4][17][aRarity]=5; CaseAwards[4][17][aType]=5; CaseAwards[4][17][aInternalId]=2601; CaseAwards[4][17][aCount]=0; CaseAwards[4][17][aPriceSprayed]=800;
	CaseAwards[4][18][aId]=19; CaseAwards[4][18][aRarity]=5; CaseAwards[4][18][aType]=5; CaseAwards[4][18][aInternalId]=667; CaseAwards[4][18][aCount]=0; CaseAwards[4][18][aPriceSprayed]=850;
	CaseAwards[4][19][aId]=20; CaseAwards[4][19][aRarity]=5; CaseAwards[4][19][aType]=5; CaseAwards[4][19][aInternalId]=2570; CaseAwards[4][19][aCount]=0; CaseAwards[4][19][aPriceSprayed]=900;
	CaseAwards[4][20][aId]=21; CaseAwards[4][20][aRarity]=5; CaseAwards[4][20][aType]=5; CaseAwards[4][20][aInternalId]=666; CaseAwards[4][20][aCount]=0; CaseAwards[4][20][aPriceSprayed]=900;
	CaseAwards[4][21][aId]=22; CaseAwards[4][21][aRarity]=5; CaseAwards[4][21][aType]=5; CaseAwards[4][21][aInternalId]=466; CaseAwards[4][21][aCount]=0; CaseAwards[4][21][aPriceSprayed]=900;
}

stock Cases_InitCase5Bonus()
{
	CaseBonus[4][0][bId]=501; CaseBonus[4][0][bNumberOpen]=25; CaseBonus[4][0][bRarity]=5; CaseBonus[4][0][bType]=5; CaseBonus[4][0][bInternalId]=665; CaseBonus[4][0][bCount]=0; CaseBonus[4][0][bPriceSprayed]=500;
	CaseBonus[4][1][bId]=502; CaseBonus[4][1][bNumberOpen]=20; CaseBonus[4][1][bRarity]=5; CaseBonus[4][1][bType]=21; CaseBonus[4][1][bInternalId]=1; CaseBonus[4][1][bCount]=1500; CaseBonus[4][1][bPriceSprayed]=0;
	CaseBonus[4][2][bId]=503; CaseBonus[4][2][bNumberOpen]=15; CaseBonus[4][2][bRarity]=5; CaseBonus[4][2][bType]=4; CaseBonus[4][2][bInternalId]=5; CaseBonus[4][2][bCount]=2; CaseBonus[4][2][bPriceSprayed]=0;
	CaseBonus[4][3][bId]=504; CaseBonus[4][3][bNumberOpen]=10; CaseBonus[4][3][bRarity]=5; CaseBonus[4][3][bType]=21; CaseBonus[4][3][bInternalId]=1; CaseBonus[4][3][bCount]=1000; CaseBonus[4][3][bPriceSprayed]=0;
	CaseBonus[4][4][bId]=505; CaseBonus[4][4][bNumberOpen]=5; CaseBonus[4][4][bRarity]=5; CaseBonus[4][4][bType]=4; CaseBonus[4][4][bInternalId]=5; CaseBonus[4][4][bCount]=1; CaseBonus[4][4][bPriceSprayed]=0;
}

stock Cases_InitCase6()
{
	CaseAwards[5][0][aId]=1; CaseAwards[5][0][aRarity]=2; CaseAwards[5][0][aType]=11; CaseAwards[5][0][aInternalId]=134; CaseAwards[5][0][aCount]=12293; CaseAwards[5][0][aPriceSprayed]=100;
	CaseAwards[5][1][aId]=2; CaseAwards[5][1][aRarity]=2; CaseAwards[5][1][aType]=11; CaseAwards[5][1][aInternalId]=508; CaseAwards[5][1][aCount]=1; CaseAwards[5][1][aPriceSprayed]=100;
	CaseAwards[5][2][aId]=3; CaseAwards[5][2][aRarity]=2; CaseAwards[5][2][aType]=11; CaseAwards[5][2][aInternalId]=511; CaseAwards[5][2][aCount]=1; CaseAwards[5][2][aPriceSprayed]=100;
	CaseAwards[5][3][aId]=4; CaseAwards[5][3][aRarity]=2; CaseAwards[5][3][aType]=10; CaseAwards[5][3][aInternalId]=1; CaseAwards[5][3][aCount]=6000; CaseAwards[5][3][aPriceSprayed]=0;
	CaseAwards[5][4][aId]=5; CaseAwards[5][4][aRarity]=2; CaseAwards[5][4][aType]=3; CaseAwards[5][4][aInternalId]=1; CaseAwards[5][4][aCount]=700; CaseAwards[5][4][aPriceSprayed]=0;
	for(new i = 5; i < 25; i++) {
		CaseAwards[5][i][aId] = i + 1;
		CaseAwards[5][i][aRarity] = (i < 15) ? 2 : ((i < 20) ? 3 : 4);
		CaseAwards[5][i][aType] = 5;
		CaseAwards[5][i][aInternalId] = 500 + i;
		CaseAwards[5][i][aCount] = 0;
		CaseAwards[5][i][aPriceSprayed] = 100 + (i * 10);
	}
	
	CaseBonus[5][0][bId]=601; CaseBonus[5][0][bNumberOpen]=40; CaseBonus[5][0][bRarity]=5; CaseBonus[5][0][bType]=5; CaseBonus[5][0][bInternalId]=658; CaseBonus[5][0][bCount]=0; CaseBonus[5][0][bPriceSprayed]=100;
	CaseBonus[5][1][bId]=602; CaseBonus[5][1][bNumberOpen]=30; CaseBonus[5][1][bRarity]=4; CaseBonus[5][1][bType]=21; CaseBonus[5][1][bInternalId]=1; CaseBonus[5][1][bCount]=350; CaseBonus[5][1][bPriceSprayed]=0;
	CaseBonus[5][2][bId]=603; CaseBonus[5][2][bNumberOpen]=20; CaseBonus[5][2][bRarity]=4; CaseBonus[5][2][bType]=4; CaseBonus[5][2][bInternalId]=6; CaseBonus[5][2][bCount]=2; CaseBonus[5][2][bPriceSprayed]=0;
	CaseBonus[5][3][bId]=604; CaseBonus[5][3][bNumberOpen]=10; CaseBonus[5][3][bRarity]=4; CaseBonus[5][3][bType]=21; CaseBonus[5][3][bInternalId]=1; CaseBonus[5][3][bCount]=200; CaseBonus[5][3][bPriceSprayed]=0;
	CaseBonus[5][4][bId]=605; CaseBonus[5][4][bNumberOpen]=5; CaseBonus[5][4][bRarity]=4; CaseBonus[5][4][bType]=4; CaseBonus[5][4][bInternalId]=6; CaseBonus[5][4][bCount]=1; CaseBonus[5][4][bPriceSprayed]=0;
}

stock Cases_InitEventCases()
{
	for(new c = 6; c < MAX_CASES; c++) {
		for(new i = 0; i < 25; i++) {
			CaseAwards[c][i][aId] = i + 1;
			CaseAwards[c][i][aRarity] = (i < 10) ? 2 : ((i < 18) ? 3 : ((i < 23) ? 4 : 5));
			CaseAwards[c][i][aType] = (i % 3 == 0) ? 5 : ((i % 3 == 1) ? 11 : 2);
			CaseAwards[c][i][aInternalId] = 500 + i;
			CaseAwards[c][i][aCount] = (CaseAwards[c][i][aType] == 2) ? 100000 * (i + 1) : 1;
			CaseAwards[c][i][aPriceSprayed] = 100 + (i * 10);
		}
		
		CaseBonus[c][0][bId]=(c+1)*100+1; CaseBonus[c][0][bNumberOpen]=40; CaseBonus[c][0][bRarity]=5; CaseBonus[c][0][bType]=5; CaseBonus[c][0][bInternalId]=600+c; CaseBonus[c][0][bCount]=0; CaseBonus[c][0][bPriceSprayed]=300;
		CaseBonus[c][1][bId]=(c+1)*100+2; CaseBonus[c][1][bNumberOpen]=30; CaseBonus[c][1][bRarity]=4; CaseBonus[c][1][bType]=21; CaseBonus[c][1][bInternalId]=1; CaseBonus[c][1][bCount]=350; CaseBonus[c][1][bPriceSprayed]=0;
		CaseBonus[c][2][bId]=(c+1)*100+3; CaseBonus[c][2][bNumberOpen]=20; CaseBonus[c][2][bRarity]=4; CaseBonus[c][2][bType]=4; CaseBonus[c][2][bInternalId]=c+1; CaseBonus[c][2][bCount]=2; CaseBonus[c][2][bPriceSprayed]=0;
		CaseBonus[c][3][bId]=(c+1)*100+4; CaseBonus[c][3][bNumberOpen]=10; CaseBonus[c][3][bRarity]=4; CaseBonus[c][3][bType]=21; CaseBonus[c][3][bInternalId]=1; CaseBonus[c][3][bCount]=200; CaseBonus[c][3][bPriceSprayed]=0;
		CaseBonus[c][4][bId]=(c+1)*100+5; CaseBonus[c][4][bNumberOpen]=5; CaseBonus[c][4][bRarity]=4; CaseBonus[c][4][bType]=4; CaseBonus[c][4][bInternalId]=c+1; CaseBonus[c][4][bCount]=1; CaseBonus[c][4][bPriceSprayed]=0;
	}
}


CMD:cases(playerid, params[])
{
	Cases_ShowGUI(playerid);
	return 1;
}

CMD:givedust(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, 0xFF0000FF, "Еблан ты не адм!");

	extract params -> new to_player, amount; else return SendClientMessage(playerid, 0xCECECEFF, "Выебать пидора: /givedust [id пидора] [Количество пиздюлей]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Кхм кхм чет странно ты не на серве а как так");

	if(!(1 <= amount <= 10000)) return SendClientMessage(playerid, 0xCECECEFF, "Выебать человека сколько раз от 1 до 10000 Не выебал пидор");

	pCasesDust[to_player] += amount;

	new reason[144];
	format(reason, sizeof reason, "Кто ты пидор %s Правильно ты хуесос %d Да да ты", GetPlayerNameEx(playerid), amount);
	SendClientMessage(to_player, 0x00FF00FF, reason);

	format(reason, sizeof reason, "Сьебался в страхе %d Сьебался %s", amount, GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x00FF00FF, reason);

	format(reason, sizeof reason, "[A] %s[%d] Еблан %s[%d] Хуесос %d, Пидор %d Ахуевший",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, amount, pCasesDust[to_player]);
	SendMessageToAdmins(reason, 0x999999FF);

	format(reason, sizeof reason, "Я ебу что ли %s[acc:%d] %d Ты лох", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), amount);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}
CMD:givecases(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, 0xFF0000FF, "Иди нахуй ты не адм!");

	extract params -> new to_player, case_id, amount; else return SendClientMessage(playerid, 0xCECECEFF, "Введите: /givecases [id пиздюка] [id пиздюка] [количество]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Ты не на серве то пошел нахуй");

	new caseIdx = Cases_GetIndex(case_id);
	if(caseIdx == -1) return SendClientMessage(playerid, 0xCECECEFF, "айди не тот пидарас");

	if(!(1 <= amount <= 10000)) return SendClientMessage(playerid, 0xCECECEFF, "Выберите количество пиздюлей от 1 до 10000");

	pCasesCounts[to_player][caseIdx] += amount;

	new reason[144];
	format(reason, sizeof reason, "Скоко раз %s идете нахуй %d именно ты (ID %d)", GetPlayerNameEx(playerid), amount, case_id);
	SendClientMessage(to_player, 0x00FF00FF, reason);

	format(reason, sizeof reason, "Кто ты воин %d Ты хуесос (ID %d) Да да именно ты %s", amount, case_id, GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x00FF00FF, reason);

	format(reason, sizeof reason, "[A] %s[%d] Адм иди нахуй %s[%d] Айдииии пиздим %d (ID %d), Бум ты пидарас %d",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, amount, case_id, pCasesCounts[to_player][caseIdx]);
	SendMessageToAdmins(reason, 0x999999FF);

	format(reason, sizeof reason, "А че это %s[acc:%d] %d Че ж это (ID %d)", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), amount, case_id);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	if(pCasesGUIOpen[to_player]) {
		Cases_UpdateGUI(to_player);
	}

	return 1;
}
CMD:mybc(playerid, params[])
{
	new str[256];
	SendClientMessage(playerid, 0xFFFF00FF, "Ди нах");
	format(str, sizeof(str), "BC: %d | Не ебу что это: %d |ХУЕСОС: %d", GetPlayerDonateRub(playerid), pCasesDust[playerid], pCasesOpened[playerid]);
	SendClientMessage(playerid, 0xFFFFFFFF, str);
	
	
	for(new i = 0; i < 6; i++) { 
		if(pCasesCounts[playerid][i] > 0) {
			new bonusClaimed = 0;
			for(new b = 0; b < MAX_BONUS_PER_CASE; b++) {
				if(pCasesBonusStatus[playerid][i][b] == 3) bonusClaimed++;
			}
			format(str, sizeof(str), "Ты сосал %d: Ты лох %d Хуесос, Еблан: %d/5", CaseData[i][cId], pCasesCounts[playerid][i], bonusClaimed);
			SendClientMessage(playerid, 0xAAAAAAFF, str);
		}
	}
	return 1;
}
CMD:casesdebug(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return SendClientMessage(playerid, 0xFF0000FF, "Ди нах вы не адм!");
	
	new str[128];
	SendClientMessage(playerid, 0xFFFF00FF, "Это дебаг ок да?");
	format(str, sizeof(str), "Вы все геи: %d | GUI А ХУЙ ВАМ: %d | Pending ты лох: %d", 
		pCasesSelected[playerid], pCasesGUIOpen[playerid], pCasesPendingCount[playerid]);
	SendClientMessage(playerid, 0xFFFFFFFF, str);
	
	if(pCasesPendingCount[playerid] > 0) {
		new rewards[128] = "Pending: ";
		for(new i = 0; i < pCasesPendingCount[playerid]; i++) {
			format(str, sizeof(str), "%d ", pCasesPendingRewards[playerid][i]);
			strcat(rewards, str);
		}
		SendClientMessage(playerid, 0xAAAAAAFF, rewards);
	}
	return 1;
}
stock Cases_SavePlayer(playerid)
{
	if(GetPlayerAccountID(playerid) <= 0) return 0;
	
	new ccStr[256];
	for(new i = 0; i < MAX_CASES; i++) {
		if(i > 0) strcat(ccStr, ",");
		new tmp[16];
		format(tmp, sizeof(tmp), "%d", pCasesCounts[playerid][i]);
		strcat(ccStr, tmp);
	}
	new cbStr[512];
	for(new c = 0; c < MAX_CASES; c++) {
		for(new b = 0; b < MAX_BONUS_PER_CASE; b++) {
			if(c > 0 || b > 0) strcat(cbStr, ",");
			new tmp[8];
			format(tmp, sizeof(tmp), "%d", pCasesBonusStatus[playerid][c][b]);
			strcat(cbStr, tmp);
		}
	}
	
	new query[1024];
	mysql_format(mysql, query, sizeof(query),
		"INSERT INTO player_cases (user_id, bc_balance, dust, opened_count, selected_case, tutorial, case_counts, bonus_status) \
		VALUES (%d, %d, %d, %d, %d, %d, '%e', '%e') \
		ON DUPLICATE KEY UPDATE dust=%d, opened_count=%d, selected_case=%d, tutorial=%d, case_counts='%e', bonus_status='%e'",
		GetPlayerAccountID(playerid), GetPlayerDonateRub(playerid), pCasesDust[playerid], pCasesOpened[playerid],
		pCasesSelected[playerid], pCasesTutorial[playerid], ccStr, cbStr,
        pCasesDust[playerid], pCasesOpened[playerid],
		pCasesSelected[playerid], pCasesTutorial[playerid], ccStr, cbStr);
	mysql_tquery(mysql, query, "", "");
	return 1;
}
forward Cases_OnPlayerLoad(playerid);
public Cases_OnPlayerLoad(playerid)
{
	new rows;
	cache_get_row_count(rows);
	
	if(rows > 0) {
		pCasesDust[playerid] = cache_get_field_content_int(0, "dust");
		pCasesOpened[playerid] = cache_get_field_content_int(0, "opened_count");
		pCasesSelected[playerid] = cache_get_field_content_int(0, "selected_case");
		pCasesTutorial[playerid] = cache_get_field_content_int(0, "tutorial");
		
		new ccStr[256];
		cache_get_field_content(0, "case_counts", ccStr);
		if(strlen(ccStr) > 0) {
			new idx = 0, pos = 0;
			new tmp[16];
			while(pos < strlen(ccStr) && idx < MAX_CASES) {
				new end = pos;
				while(end < strlen(ccStr) && ccStr[end] != ',') end++;
				strmid(tmp, ccStr, pos, end);
				pCasesCounts[playerid][idx] = strval(tmp);
				idx++;
				pos = end + 1;
			}
		}
		
		new cbStr[512];
		cache_get_field_content(0, "bonus_status", cbStr);
		if(strlen(cbStr) > 0) {
			new idx = 0, pos = 0;
			new tmp[8];
			while(pos < strlen(cbStr) && idx < MAX_CASES * MAX_BONUS_PER_CASE) {
				new end = pos;
				while(end < strlen(cbStr) && cbStr[end] != ',') end++;
				strmid(tmp, cbStr, pos, end);
				new c = idx / MAX_BONUS_PER_CASE;
				new b = idx % MAX_BONUS_PER_CASE;
				pCasesBonusStatus[playerid][c][b] = strval(tmp);
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
	mysql_format(mysql, query, sizeof(query),
		"SELECT * FROM player_cases WHERE user_id = %d LIMIT 1",
		GetPlayerAccountID(playerid));
	mysql_tquery(mysql, query, "Cases_OnPlayerLoad", "d", playerid);
	return 1;
}
