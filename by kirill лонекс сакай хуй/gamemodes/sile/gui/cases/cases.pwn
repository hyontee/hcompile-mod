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

#define MAX_CASES               29
#define MAX_AWARDS_PER_CASE     61
#define MAX_BONUS_PER_CASE      5

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
new pCasesOwned[MAX_PLAYERS][MAX_CASES];
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
    SendPacketToClient(playerid, guiid, json);
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
    Cases_SavePlayer(playerid);
    return 1;
}

stock Cases_AddToPlayer(playerid, caseIdx, amount)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(caseIdx < 0 || caseIdx >= MAX_CASES) return 0;
    if(amount == 0) return 0;

    new caseType = CaseData[caseIdx][cId];
    if(caseType <= 0) return 0;

    return AddPlayerCaseCountByType(playerid, caseType, amount);
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

stock Cases_FindAwardById(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardRarity)
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



stock Cases_IsPendingReward(playerid, rewardId)
{
    for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
    {
        if(pCasesPendingRewards[playerid][i] == rewardId) return 1;
    }
    return 0;
}

stock Cases_AddRewardToRewardStorage(playerid, caseId, awardId)
{
    if(GetPlayerAccountID(playerid) <= 0 || caseId <= 0 || awardId <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `rewards` (`uid`, `award_id`, `case_id`) VALUES (%d, %d, %d)",
        GetPlayerAccountID(playerid), awardId, caseId);
    mysql_tquery(mysql, query);
    return 1;
}

stock Cases_InitGeneratedFromJson()
{
    // case json id 1
    CaseData[0][cId] = 1;
    CaseData[0][cPriceOne] = 15;
    CaseData[0][cPriceTen] = 150;
    CaseData[0][cDiscountOne] = 0;
    CaseData[0][cDiscountTen] = 0;
    CaseData[0][cAwardsCount] = 20;
    CaseData[0][cBonusCount] = 5;
    CaseAwards[0][0][aId] = 1; CaseAwards[0][0][aRarity] = 1; CaseAwards[0][0][aType] = 11; CaseAwards[0][0][aInternalId] = 23; CaseAwards[0][0][aCount] = 1; CaseAwards[0][0][aPriceSprayed] = 10; CaseAwards[0][0][aSubcount] = 0;
    CaseAwards[0][1][aId] = 2; CaseAwards[0][1][aRarity] = 1; CaseAwards[0][1][aType] = 11; CaseAwards[0][1][aInternalId] = 22; CaseAwards[0][1][aCount] = 1; CaseAwards[0][1][aPriceSprayed] = 10; CaseAwards[0][1][aSubcount] = 0;
    CaseAwards[0][2][aId] = 3; CaseAwards[0][2][aRarity] = 1; CaseAwards[0][2][aType] = 10; CaseAwards[0][2][aInternalId] = 1; CaseAwards[0][2][aCount] = 200; CaseAwards[0][2][aPriceSprayed] = 0; CaseAwards[0][2][aSubcount] = 0;
    CaseAwards[0][3][aId] = 4; CaseAwards[0][3][aRarity] = 1; CaseAwards[0][3][aType] = 11; CaseAwards[0][3][aInternalId] = 21; CaseAwards[0][3][aCount] = 1; CaseAwards[0][3][aPriceSprayed] = 10; CaseAwards[0][3][aSubcount] = 0;
    CaseAwards[0][4][aId] = 5; CaseAwards[0][4][aRarity] = 1; CaseAwards[0][4][aType] = 2; CaseAwards[0][4][aInternalId] = 1; CaseAwards[0][4][aCount] = 2000; CaseAwards[0][4][aPriceSprayed] = 0; CaseAwards[0][4][aSubcount] = 0;
    CaseAwards[0][5][aId] = 6; CaseAwards[0][5][aRarity] = 1; CaseAwards[0][5][aType] = 3; CaseAwards[0][5][aInternalId] = 1; CaseAwards[0][5][aCount] = 5; CaseAwards[0][5][aPriceSprayed] = 0; CaseAwards[0][5][aSubcount] = 0;
    CaseAwards[0][6][aId] = 7; CaseAwards[0][6][aRarity] = 1; CaseAwards[0][6][aType] = 2; CaseAwards[0][6][aInternalId] = 1; CaseAwards[0][6][aCount] = 3000; CaseAwards[0][6][aPriceSprayed] = 0; CaseAwards[0][6][aSubcount] = 0;
    CaseAwards[0][7][aId] = 8; CaseAwards[0][7][aRarity] = 1; CaseAwards[0][7][aType] = 3; CaseAwards[0][7][aInternalId] = 1; CaseAwards[0][7][aCount] = 10; CaseAwards[0][7][aPriceSprayed] = 0; CaseAwards[0][7][aSubcount] = 0;
    CaseAwards[0][8][aId] = 9; CaseAwards[0][8][aRarity] = 1; CaseAwards[0][8][aType] = 9; CaseAwards[0][8][aInternalId] = 1; CaseAwards[0][8][aCount] = 2; CaseAwards[0][8][aPriceSprayed] = 10; CaseAwards[0][8][aSubcount] = 0;
    CaseAwards[0][9][aId] = 10; CaseAwards[0][9][aRarity] = 1; CaseAwards[0][9][aType] = 10; CaseAwards[0][9][aInternalId] = 1; CaseAwards[0][9][aCount] = 300; CaseAwards[0][9][aPriceSprayed] = 0; CaseAwards[0][9][aSubcount] = 0;
    CaseAwards[0][10][aId] = 11; CaseAwards[0][10][aRarity] = 1; CaseAwards[0][10][aType] = 1; CaseAwards[0][10][aInternalId] = 1; CaseAwards[0][10][aCount] = 4; CaseAwards[0][10][aPriceSprayed] = 0; CaseAwards[0][10][aSubcount] = 0;
    CaseAwards[0][11][aId] = 12; CaseAwards[0][11][aRarity] = 1; CaseAwards[0][11][aType] = 5; CaseAwards[0][11][aInternalId] = 462; CaseAwards[0][11][aCount] = 0; CaseAwards[0][11][aPriceSprayed] = 20; CaseAwards[0][11][aSubcount] = 0;
    CaseAwards[0][12][aId] = 13; CaseAwards[0][12][aRarity] = 1; CaseAwards[0][12][aType] = 10; CaseAwards[0][12][aInternalId] = 1; CaseAwards[0][12][aCount] = 500; CaseAwards[0][12][aPriceSprayed] = 0; CaseAwards[0][12][aSubcount] = 0;
    CaseAwards[0][13][aId] = 14; CaseAwards[0][13][aRarity] = 1; CaseAwards[0][13][aType] = 2; CaseAwards[0][13][aInternalId] = 1; CaseAwards[0][13][aCount] = 20000; CaseAwards[0][13][aPriceSprayed] = 0; CaseAwards[0][13][aSubcount] = 0;
    CaseAwards[0][14][aId] = 15; CaseAwards[0][14][aRarity] = 1; CaseAwards[0][14][aType] = 3; CaseAwards[0][14][aInternalId] = 1; CaseAwards[0][14][aCount] = 15; CaseAwards[0][14][aPriceSprayed] = 0; CaseAwards[0][14][aSubcount] = 0;
    CaseAwards[0][15][aId] = 16; CaseAwards[0][15][aRarity] = 1; CaseAwards[0][15][aType] = 9; CaseAwards[0][15][aInternalId] = 2; CaseAwards[0][15][aCount] = 2; CaseAwards[0][15][aPriceSprayed] = 10; CaseAwards[0][15][aSubcount] = 0;
    CaseAwards[0][16][aId] = 17; CaseAwards[0][16][aRarity] = 1; CaseAwards[0][16][aType] = 10; CaseAwards[0][16][aInternalId] = 1; CaseAwards[0][16][aCount] = 500; CaseAwards[0][16][aPriceSprayed] = 0; CaseAwards[0][16][aSubcount] = 0;
    CaseAwards[0][17][aId] = 18; CaseAwards[0][17][aRarity] = 1; CaseAwards[0][17][aType] = 2; CaseAwards[0][17][aInternalId] = 1; CaseAwards[0][17][aCount] = 30000; CaseAwards[0][17][aPriceSprayed] = 0; CaseAwards[0][17][aSubcount] = 0;
    CaseAwards[0][18][aId] = 19; CaseAwards[0][18][aRarity] = 1; CaseAwards[0][18][aType] = 1; CaseAwards[0][18][aInternalId] = 1; CaseAwards[0][18][aCount] = 6; CaseAwards[0][18][aPriceSprayed] = 0; CaseAwards[0][18][aSubcount] = 0;
    CaseAwards[0][19][aId] = 20; CaseAwards[0][19][aRarity] = 1; CaseAwards[0][19][aType] = 5; CaseAwards[0][19][aInternalId] = 549; CaseAwards[0][19][aCount] = 0; CaseAwards[0][19][aPriceSprayed] = 20; CaseAwards[0][19][aSubcount] = 0;
    CaseBonus[0][0][bId] = 1; CaseBonus[0][0][bNumberOpen] = 40; CaseBonus[0][0][bRarity] = 4; CaseBonus[0][0][bType] = 4; CaseBonus[0][0][bInternalId] = 3; CaseBonus[0][0][bCount] = 1; CaseBonus[0][0][bPriceSprayed] = 0;
    CaseBonus[0][1][bId] = 2; CaseBonus[0][1][bNumberOpen] = 30; CaseBonus[0][1][bRarity] = 3; CaseBonus[0][1][bType] = 21; CaseBonus[0][1][bInternalId] = 1; CaseBonus[0][1][bCount] = 50; CaseBonus[0][1][bPriceSprayed] = 0;
    CaseBonus[0][2][bId] = 3; CaseBonus[0][2][bNumberOpen] = 20; CaseBonus[0][2][bRarity] = 2; CaseBonus[0][2][bType] = 4; CaseBonus[0][2][bInternalId] = 2; CaseBonus[0][2][bCount] = 1; CaseBonus[0][2][bPriceSprayed] = 0;
    CaseBonus[0][3][bId] = 4; CaseBonus[0][3][bNumberOpen] = 10; CaseBonus[0][3][bRarity] = 1; CaseBonus[0][3][bType] = 4; CaseBonus[0][3][bInternalId] = 1; CaseBonus[0][3][bCount] = 2; CaseBonus[0][3][bPriceSprayed] = 0;
    CaseBonus[0][4][bId] = 5; CaseBonus[0][4][bNumberOpen] = 5; CaseBonus[0][4][bRarity] = 1; CaseBonus[0][4][bType] = 4; CaseBonus[0][4][bInternalId] = 1; CaseBonus[0][4][bCount] = 1; CaseBonus[0][4][bPriceSprayed] = 0;

    // case json id 2
    CaseData[1][cId] = 2;
    CaseData[1][cPriceOne] = 100;
    CaseData[1][cPriceTen] = 1000;
    CaseData[1][cDiscountOne] = 0;
    CaseData[1][cDiscountTen] = 0;
    CaseData[1][cAwardsCount] = 27;
    CaseData[1][cBonusCount] = 5;
    CaseAwards[1][0][aId] = 1; CaseAwards[1][0][aRarity] = 1; CaseAwards[1][0][aType] = 5; CaseAwards[1][0][aInternalId] = 468; CaseAwards[1][0][aCount] = 0; CaseAwards[1][0][aPriceSprayed] = 20; CaseAwards[1][0][aSubcount] = 0;
    CaseAwards[1][1][aId] = 2; CaseAwards[1][1][aRarity] = 1; CaseAwards[1][1][aType] = 5; CaseAwards[1][1][aInternalId] = 496; CaseAwards[1][1][aCount] = 0; CaseAwards[1][1][aPriceSprayed] = 20; CaseAwards[1][1][aSubcount] = 0;
    CaseAwards[1][2][aId] = 3; CaseAwards[1][2][aRarity] = 1; CaseAwards[1][2][aType] = 2; CaseAwards[1][2][aInternalId] = 1; CaseAwards[1][2][aCount] = 75000; CaseAwards[1][2][aPriceSprayed] = 0; CaseAwards[1][2][aSubcount] = 0;
    CaseAwards[1][3][aId] = 4; CaseAwards[1][3][aRarity] = 1; CaseAwards[1][3][aType] = 5; CaseAwards[1][3][aInternalId] = 28670; CaseAwards[1][3][aCount] = 0; CaseAwards[1][3][aPriceSprayed] = 20; CaseAwards[1][3][aSubcount] = 0;
    CaseAwards[1][4][aId] = 5; CaseAwards[1][4][aRarity] = 1; CaseAwards[1][4][aType] = 1; CaseAwards[1][4][aInternalId] = 1; CaseAwards[1][4][aCount] = 8; CaseAwards[1][4][aPriceSprayed] = 0; CaseAwards[1][4][aSubcount] = 0;
    CaseAwards[1][5][aId] = 6; CaseAwards[1][5][aRarity] = 1; CaseAwards[1][5][aType] = 5; CaseAwards[1][5][aInternalId] = 439; CaseAwards[1][5][aCount] = 0; CaseAwards[1][5][aPriceSprayed] = 20; CaseAwards[1][5][aSubcount] = 0;
    CaseAwards[1][6][aId] = 7; CaseAwards[1][6][aRarity] = 1; CaseAwards[1][6][aType] = 2; CaseAwards[1][6][aInternalId] = 1; CaseAwards[1][6][aCount] = 90000; CaseAwards[1][6][aPriceSprayed] = 0; CaseAwards[1][6][aSubcount] = 0;
    CaseAwards[1][7][aId] = 8; CaseAwards[1][7][aRarity] = 1; CaseAwards[1][7][aType] = 5; CaseAwards[1][7][aInternalId] = 492; CaseAwards[1][7][aCount] = 0; CaseAwards[1][7][aPriceSprayed] = 20; CaseAwards[1][7][aSubcount] = 0;
    CaseAwards[1][8][aId] = 9; CaseAwards[1][8][aRarity] = 1; CaseAwards[1][8][aType] = 5; CaseAwards[1][8][aInternalId] = 547; CaseAwards[1][8][aCount] = 0; CaseAwards[1][8][aPriceSprayed] = 20; CaseAwards[1][8][aSubcount] = 0;
    CaseAwards[1][9][aId] = 10; CaseAwards[1][9][aRarity] = 1; CaseAwards[1][9][aType] = 5; CaseAwards[1][9][aInternalId] = 458; CaseAwards[1][9][aCount] = 0; CaseAwards[1][9][aPriceSprayed] = 20; CaseAwards[1][9][aSubcount] = 0;
    CaseAwards[1][10][aId] = 11; CaseAwards[1][10][aRarity] = 1; CaseAwards[1][10][aType] = 9; CaseAwards[1][10][aInternalId] = 1; CaseAwards[1][10][aCount] = 168; CaseAwards[1][10][aPriceSprayed] = 20; CaseAwards[1][10][aSubcount] = 0;
    CaseAwards[1][11][aId] = 12; CaseAwards[1][11][aRarity] = 1; CaseAwards[1][11][aType] = 5; CaseAwards[1][11][aInternalId] = 491; CaseAwards[1][11][aCount] = 0; CaseAwards[1][11][aPriceSprayed] = 20; CaseAwards[1][11][aSubcount] = 0;
    CaseAwards[1][12][aId] = 13; CaseAwards[1][12][aRarity] = 1; CaseAwards[1][12][aType] = 5; CaseAwards[1][12][aInternalId] = 585; CaseAwards[1][12][aCount] = 0; CaseAwards[1][12][aPriceSprayed] = 20; CaseAwards[1][12][aSubcount] = 0;
    CaseAwards[1][13][aId] = 14; CaseAwards[1][13][aRarity] = 1; CaseAwards[1][13][aType] = 1; CaseAwards[1][13][aInternalId] = 1; CaseAwards[1][13][aCount] = 12; CaseAwards[1][13][aPriceSprayed] = 0; CaseAwards[1][13][aSubcount] = 0;
    CaseAwards[1][14][aId] = 15; CaseAwards[1][14][aRarity] = 1; CaseAwards[1][14][aType] = 2; CaseAwards[1][14][aInternalId] = 1; CaseAwards[1][14][aCount] = 120000; CaseAwards[1][14][aPriceSprayed] = 0; CaseAwards[1][14][aSubcount] = 0;
    CaseAwards[1][15][aId] = 16; CaseAwards[1][15][aRarity] = 1; CaseAwards[1][15][aType] = 9; CaseAwards[1][15][aInternalId] = 2; CaseAwards[1][15][aCount] = 72; CaseAwards[1][15][aPriceSprayed] = 20; CaseAwards[1][15][aSubcount] = 0;
    CaseAwards[1][16][aId] = 17; CaseAwards[1][16][aRarity] = 1; CaseAwards[1][16][aType] = 5; CaseAwards[1][16][aInternalId] = 536; CaseAwards[1][16][aCount] = 0; CaseAwards[1][16][aPriceSprayed] = 20; CaseAwards[1][16][aSubcount] = 0;
    CaseAwards[1][17][aId] = 18; CaseAwards[1][17][aRarity] = 1; CaseAwards[1][17][aType] = 5; CaseAwards[1][17][aInternalId] = 529; CaseAwards[1][17][aCount] = 0; CaseAwards[1][17][aPriceSprayed] = 20; CaseAwards[1][17][aSubcount] = 0;
    CaseAwards[1][18][aId] = 19; CaseAwards[1][18][aRarity] = 1; CaseAwards[1][18][aType] = 9; CaseAwards[1][18][aInternalId] = 3; CaseAwards[1][18][aCount] = 72; CaseAwards[1][18][aPriceSprayed] = 20; CaseAwards[1][18][aSubcount] = 0;
    CaseAwards[1][19][aId] = 20; CaseAwards[1][19][aRarity] = 1; CaseAwards[1][19][aType] = 5; CaseAwards[1][19][aInternalId] = 542; CaseAwards[1][19][aCount] = 0; CaseAwards[1][19][aPriceSprayed] = 20; CaseAwards[1][19][aSubcount] = 0;
    CaseAwards[1][20][aId] = 21; CaseAwards[1][20][aRarity] = 1; CaseAwards[1][20][aType] = 5; CaseAwards[1][20][aInternalId] = 421; CaseAwards[1][20][aCount] = 0; CaseAwards[1][20][aPriceSprayed] = 20; CaseAwards[1][20][aSubcount] = 0;
    CaseAwards[1][21][aId] = 22; CaseAwards[1][21][aRarity] = 2; CaseAwards[1][21][aType] = 5; CaseAwards[1][21][aInternalId] = 2618; CaseAwards[1][21][aCount] = 0; CaseAwards[1][21][aPriceSprayed] = 30; CaseAwards[1][21][aSubcount] = 0;
    CaseAwards[1][22][aId] = 23; CaseAwards[1][22][aRarity] = 2; CaseAwards[1][22][aType] = 5; CaseAwards[1][22][aInternalId] = 419; CaseAwards[1][22][aCount] = 0; CaseAwards[1][22][aPriceSprayed] = 30; CaseAwards[1][22][aSubcount] = 0;
    CaseAwards[1][23][aId] = 24; CaseAwards[1][23][aRarity] = 3; CaseAwards[1][23][aType] = 11; CaseAwards[1][23][aInternalId] = 705; CaseAwards[1][23][aCount] = 1; CaseAwards[1][23][aPriceSprayed] = 30; CaseAwards[1][23][aSubcount] = 0;
    CaseAwards[1][24][aId] = 25; CaseAwards[1][24][aRarity] = 2; CaseAwards[1][24][aType] = 5; CaseAwards[1][24][aInternalId] = 546; CaseAwards[1][24][aCount] = 0; CaseAwards[1][24][aPriceSprayed] = 30; CaseAwards[1][24][aSubcount] = 0;
    CaseAwards[1][25][aId] = 26; CaseAwards[1][25][aRarity] = 3; CaseAwards[1][25][aType] = 11; CaseAwards[1][25][aInternalId] = 706; CaseAwards[1][25][aCount] = 1; CaseAwards[1][25][aPriceSprayed] = 30; CaseAwards[1][25][aSubcount] = 0;
    CaseAwards[1][26][aId] = 27; CaseAwards[1][26][aRarity] = 3; CaseAwards[1][26][aType] = 11; CaseAwards[1][26][aInternalId] = 134; CaseAwards[1][26][aCount] = 6810; CaseAwards[1][26][aPriceSprayed] = 40; CaseAwards[1][26][aSubcount] = 0;
    CaseBonus[1][0][bId] = 1; CaseBonus[1][0][bNumberOpen] = 40; CaseBonus[1][0][bRarity] = 5; CaseBonus[1][0][bType] = 5; CaseBonus[1][0][bInternalId] = 467; CaseBonus[1][0][bCount] = 0; CaseBonus[1][0][bPriceSprayed] = 100;
    CaseBonus[1][1][bId] = 2; CaseBonus[1][1][bNumberOpen] = 30; CaseBonus[1][1][bRarity] = 3; CaseBonus[1][1][bType] = 21; CaseBonus[1][1][bInternalId] = 1; CaseBonus[1][1][bCount] = 100; CaseBonus[1][1][bPriceSprayed] = 0;
    CaseBonus[1][2][bId] = 3; CaseBonus[1][2][bNumberOpen] = 20; CaseBonus[1][2][bRarity] = 3; CaseBonus[1][2][bType] = 4; CaseBonus[1][2][bInternalId] = 2; CaseBonus[1][2][bCount] = 2; CaseBonus[1][2][bPriceSprayed] = 0;
    CaseBonus[1][3][bId] = 4; CaseBonus[1][3][bNumberOpen] = 10; CaseBonus[1][3][bRarity] = 3; CaseBonus[1][3][bType] = 21; CaseBonus[1][3][bInternalId] = 1; CaseBonus[1][3][bCount] = 50; CaseBonus[1][3][bPriceSprayed] = 0;
    CaseBonus[1][4][bId] = 5; CaseBonus[1][4][bNumberOpen] = 5; CaseBonus[1][4][bRarity] = 3; CaseBonus[1][4][bType] = 4; CaseBonus[1][4][bInternalId] = 2; CaseBonus[1][4][bCount] = 1; CaseBonus[1][4][bPriceSprayed] = 0;

    // case json id 3
    CaseData[2][cId] = 3;
    CaseData[2][cPriceOne] = 700;
    CaseData[2][cPriceTen] = 7000;
    CaseData[2][cDiscountOne] = 0;
    CaseData[2][cDiscountTen] = 0;
    CaseData[2][cAwardsCount] = 37;
    CaseData[2][cBonusCount] = 5;
    CaseAwards[2][0][aId] = 1; CaseAwards[2][0][aRarity] = 2; CaseAwards[2][0][aType] = 11; CaseAwards[2][0][aInternalId] = 363; CaseAwards[2][0][aCount] = 1; CaseAwards[2][0][aPriceSprayed] = 90; CaseAwards[2][0][aSubcount] = 0;
    CaseAwards[2][1][aId] = 2; CaseAwards[2][1][aRarity] = 2; CaseAwards[2][1][aType] = 9; CaseAwards[2][1][aInternalId] = 2; CaseAwards[2][1][aCount] = 504; CaseAwards[2][1][aPriceSprayed] = 90; CaseAwards[2][1][aSubcount] = 0;
    CaseAwards[2][2][aId] = 3; CaseAwards[2][2][aRarity] = 2; CaseAwards[2][2][aType] = 2; CaseAwards[2][2][aInternalId] = 1; CaseAwards[2][2][aCount] = 600000; CaseAwards[2][2][aPriceSprayed] = 0; CaseAwards[2][2][aSubcount] = 0;
    CaseAwards[2][3][aId] = 4; CaseAwards[2][3][aRarity] = 2; CaseAwards[2][3][aType] = 11; CaseAwards[2][3][aInternalId] = 360; CaseAwards[2][3][aCount] = 1; CaseAwards[2][3][aPriceSprayed] = 90; CaseAwards[2][3][aSubcount] = 0;
    CaseAwards[2][4][aId] = 5; CaseAwards[2][4][aRarity] = 2; CaseAwards[2][4][aType] = 5; CaseAwards[2][4][aInternalId] = 527; CaseAwards[2][4][aCount] = 0; CaseAwards[2][4][aPriceSprayed] = 100; CaseAwards[2][4][aSubcount] = 0;
    CaseAwards[2][5][aId] = 6; CaseAwards[2][5][aRarity] = 2; CaseAwards[2][5][aType] = 3; CaseAwards[2][5][aInternalId] = 1; CaseAwards[2][5][aCount] = 600; CaseAwards[2][5][aPriceSprayed] = 0; CaseAwards[2][5][aSubcount] = 0;
    CaseAwards[2][6][aId] = 7; CaseAwards[2][6][aRarity] = 2; CaseAwards[2][6][aType] = 9; CaseAwards[2][6][aInternalId] = 3; CaseAwards[2][6][aCount] = 360; CaseAwards[2][6][aPriceSprayed] = 100; CaseAwards[2][6][aSubcount] = 0;
    CaseAwards[2][7][aId] = 8; CaseAwards[2][7][aRarity] = 2; CaseAwards[2][7][aType] = 5; CaseAwards[2][7][aInternalId] = 445; CaseAwards[2][7][aCount] = 0; CaseAwards[2][7][aPriceSprayed] = 100; CaseAwards[2][7][aSubcount] = 0;
    CaseAwards[2][8][aId] = 9; CaseAwards[2][8][aRarity] = 2; CaseAwards[2][8][aType] = 11; CaseAwards[2][8][aInternalId] = 583; CaseAwards[2][8][aCount] = 1; CaseAwards[2][8][aPriceSprayed] = 100; CaseAwards[2][8][aSubcount] = 0;
    CaseAwards[2][9][aId] = 10; CaseAwards[2][9][aRarity] = 2; CaseAwards[2][9][aType] = 11; CaseAwards[2][9][aInternalId] = 134; CaseAwards[2][9][aCount] = 14386; CaseAwards[2][9][aPriceSprayed] = 100; CaseAwards[2][9][aSubcount] = 0;
    CaseAwards[2][10][aId] = 11; CaseAwards[2][10][aRarity] = 2; CaseAwards[2][10][aType] = 11; CaseAwards[2][10][aInternalId] = 508; CaseAwards[2][10][aCount] = 1; CaseAwards[2][10][aPriceSprayed] = 100; CaseAwards[2][10][aSubcount] = 0;
    CaseAwards[2][11][aId] = 12; CaseAwards[2][11][aRarity] = 2; CaseAwards[2][11][aType] = 11; CaseAwards[2][11][aInternalId] = 134; CaseAwards[2][11][aCount] = 11917; CaseAwards[2][11][aPriceSprayed] = 110; CaseAwards[2][11][aSubcount] = 0;
    CaseAwards[2][12][aId] = 13; CaseAwards[2][12][aRarity] = 2; CaseAwards[2][12][aType] = 5; CaseAwards[2][12][aInternalId] = 589; CaseAwards[2][12][aCount] = 0; CaseAwards[2][12][aPriceSprayed] = 110; CaseAwards[2][12][aSubcount] = 0;
    CaseAwards[2][13][aId] = 14; CaseAwards[2][13][aRarity] = 2; CaseAwards[2][13][aType] = 5; CaseAwards[2][13][aInternalId] = 2568; CaseAwards[2][13][aCount] = 0; CaseAwards[2][13][aPriceSprayed] = 110; CaseAwards[2][13][aSubcount] = 0;
    CaseAwards[2][14][aId] = 15; CaseAwards[2][14][aRarity] = 2; CaseAwards[2][14][aType] = 11; CaseAwards[2][14][aInternalId] = 134; CaseAwards[2][14][aCount] = 11961; CaseAwards[2][14][aPriceSprayed] = 140; CaseAwards[2][14][aSubcount] = 0;
    CaseAwards[2][15][aId] = 16; CaseAwards[2][15][aRarity] = 2; CaseAwards[2][15][aType] = 5; CaseAwards[2][15][aInternalId] = 2385; CaseAwards[2][15][aCount] = 0; CaseAwards[2][15][aPriceSprayed] = 120; CaseAwards[2][15][aSubcount] = 0;
    CaseAwards[2][16][aId] = 17; CaseAwards[2][16][aRarity] = 2; CaseAwards[2][16][aType] = 5; CaseAwards[2][16][aInternalId] = 28695; CaseAwards[2][16][aCount] = 0; CaseAwards[2][16][aPriceSprayed] = 120; CaseAwards[2][16][aSubcount] = 0;
    CaseAwards[2][17][aId] = 18; CaseAwards[2][17][aRarity] = 2; CaseAwards[2][17][aType] = 5; CaseAwards[2][17][aInternalId] = 2627; CaseAwards[2][17][aCount] = 0; CaseAwards[2][17][aPriceSprayed] = 120; CaseAwards[2][17][aSubcount] = 0;
    CaseAwards[2][18][aId] = 19; CaseAwards[2][18][aRarity] = 2; CaseAwards[2][18][aType] = 5; CaseAwards[2][18][aInternalId] = 461; CaseAwards[2][18][aCount] = 0; CaseAwards[2][18][aPriceSprayed] = 130; CaseAwards[2][18][aSubcount] = 0;
    CaseAwards[2][19][aId] = 20; CaseAwards[2][19][aRarity] = 2; CaseAwards[2][19][aType] = 2; CaseAwards[2][19][aInternalId] = 1; CaseAwards[2][19][aCount] = 1000000; CaseAwards[2][19][aPriceSprayed] = 0; CaseAwards[2][19][aSubcount] = 0;
    CaseAwards[2][20][aId] = 21; CaseAwards[2][20][aRarity] = 3; CaseAwards[2][20][aType] = 9; CaseAwards[2][20][aInternalId] = 3; CaseAwards[2][20][aCount] = 720; CaseAwards[2][20][aPriceSprayed] = 130; CaseAwards[2][20][aSubcount] = 0;
    CaseAwards[2][21][aId] = 22; CaseAwards[2][21][aRarity] = 3; CaseAwards[2][21][aType] = 11; CaseAwards[2][21][aInternalId] = 134; CaseAwards[2][21][aCount] = 236; CaseAwards[2][21][aPriceSprayed] = 130; CaseAwards[2][21][aSubcount] = 0;
    CaseAwards[2][22][aId] = 23; CaseAwards[2][22][aRarity] = 3; CaseAwards[2][22][aType] = 5; CaseAwards[2][22][aInternalId] = 2567; CaseAwards[2][22][aCount] = 0; CaseAwards[2][22][aPriceSprayed] = 130; CaseAwards[2][22][aSubcount] = 0;
    CaseAwards[2][23][aId] = 24; CaseAwards[2][23][aRarity] = 3; CaseAwards[2][23][aType] = 11; CaseAwards[2][23][aInternalId] = 134; CaseAwards[2][23][aCount] = 11935; CaseAwards[2][23][aPriceSprayed] = 140; CaseAwards[2][23][aSubcount] = 0;
    CaseAwards[2][24][aId] = 25; CaseAwards[2][24][aRarity] = 3; CaseAwards[2][24][aType] = 5; CaseAwards[2][24][aInternalId] = 560; CaseAwards[2][24][aCount] = 0; CaseAwards[2][24][aPriceSprayed] = 140; CaseAwards[2][24][aSubcount] = 0;
    CaseAwards[2][25][aId] = 26; CaseAwards[2][25][aRarity] = 3; CaseAwards[2][25][aType] = 11; CaseAwards[2][25][aInternalId] = 134; CaseAwards[2][25][aCount] = 19262; CaseAwards[2][25][aPriceSprayed] = 140; CaseAwards[2][25][aSubcount] = 0;
    CaseAwards[2][26][aId] = 27; CaseAwards[2][26][aRarity] = 3; CaseAwards[2][26][aType] = 5; CaseAwards[2][26][aInternalId] = 2584; CaseAwards[2][26][aCount] = 0; CaseAwards[2][26][aPriceSprayed] = 150; CaseAwards[2][26][aSubcount] = 0;
    CaseAwards[2][27][aId] = 28; CaseAwards[2][27][aRarity] = 3; CaseAwards[2][27][aType] = 5; CaseAwards[2][27][aInternalId] = 2390; CaseAwards[2][27][aCount] = 0; CaseAwards[2][27][aPriceSprayed] = 160; CaseAwards[2][27][aSubcount] = 0;
    CaseAwards[2][28][aId] = 29; CaseAwards[2][28][aRarity] = 3; CaseAwards[2][28][aType] = 5; CaseAwards[2][28][aInternalId] = 543; CaseAwards[2][28][aCount] = 0; CaseAwards[2][28][aPriceSprayed] = 200; CaseAwards[2][28][aSubcount] = 0;
    CaseAwards[2][29][aId] = 30; CaseAwards[2][29][aRarity] = 3; CaseAwards[2][29][aType] = 5; CaseAwards[2][29][aInternalId] = 480; CaseAwards[2][29][aCount] = 0; CaseAwards[2][29][aPriceSprayed] = 200; CaseAwards[2][29][aSubcount] = 0;
    CaseAwards[2][30][aId] = 31; CaseAwards[2][30][aRarity] = 4; CaseAwards[2][30][aType] = 11; CaseAwards[2][30][aInternalId] = 707; CaseAwards[2][30][aCount] = 1; CaseAwards[2][30][aPriceSprayed] = 220; CaseAwards[2][30][aSubcount] = 0;
    CaseAwards[2][31][aId] = 32; CaseAwards[2][31][aRarity] = 4; CaseAwards[2][31][aType] = 5; CaseAwards[2][31][aInternalId] = 402; CaseAwards[2][31][aCount] = 0; CaseAwards[2][31][aPriceSprayed] = 240; CaseAwards[2][31][aSubcount] = 0;
    CaseAwards[2][32][aId] = 33; CaseAwards[2][32][aRarity] = 4; CaseAwards[2][32][aType] = 5; CaseAwards[2][32][aInternalId] = 2598; CaseAwards[2][32][aCount] = 0; CaseAwards[2][32][aPriceSprayed] = 250; CaseAwards[2][32][aSubcount] = 0;
    CaseAwards[2][33][aId] = 34; CaseAwards[2][33][aRarity] = 4; CaseAwards[2][33][aType] = 5; CaseAwards[2][33][aInternalId] = 400; CaseAwards[2][33][aCount] = 0; CaseAwards[2][33][aPriceSprayed] = 260; CaseAwards[2][33][aSubcount] = 0;
    CaseAwards[2][34][aId] = 35; CaseAwards[2][34][aRarity] = 4; CaseAwards[2][34][aType] = 5; CaseAwards[2][34][aInternalId] = 506; CaseAwards[2][34][aCount] = 0; CaseAwards[2][34][aPriceSprayed] = 270; CaseAwards[2][34][aSubcount] = 0;
    CaseAwards[2][35][aId] = 36; CaseAwards[2][35][aRarity] = 5; CaseAwards[2][35][aType] = 5; CaseAwards[2][35][aInternalId] = 415; CaseAwards[2][35][aCount] = 0; CaseAwards[2][35][aPriceSprayed] = 400; CaseAwards[2][35][aSubcount] = 0;
    CaseAwards[2][36][aId] = 37; CaseAwards[2][36][aRarity] = 5; CaseAwards[2][36][aType] = 5; CaseAwards[2][36][aInternalId] = 2543; CaseAwards[2][36][aCount] = 0; CaseAwards[2][36][aPriceSprayed] = 400; CaseAwards[2][36][aSubcount] = 0;
    CaseBonus[2][0][bId] = 1; CaseBonus[2][0][bNumberOpen] = 40; CaseBonus[2][0][bRarity] = 5; CaseBonus[2][0][bType] = 5; CaseBonus[2][0][bInternalId] = 2581; CaseBonus[2][0][bCount] = 0; CaseBonus[2][0][bPriceSprayed] = 400;
    CaseBonus[2][1][bId] = 2; CaseBonus[2][1][bNumberOpen] = 30; CaseBonus[2][1][bRarity] = 4; CaseBonus[2][1][bType] = 21; CaseBonus[2][1][bInternalId] = 1; CaseBonus[2][1][bCount] = 250; CaseBonus[2][1][bPriceSprayed] = 0;
    CaseBonus[2][2][bId] = 3; CaseBonus[2][2][bNumberOpen] = 20; CaseBonus[2][2][bRarity] = 4; CaseBonus[2][2][bType] = 4; CaseBonus[2][2][bInternalId] = 3; CaseBonus[2][2][bCount] = 2; CaseBonus[2][2][bPriceSprayed] = 0;
    CaseBonus[2][3][bId] = 4; CaseBonus[2][3][bNumberOpen] = 10; CaseBonus[2][3][bRarity] = 3; CaseBonus[2][3][bType] = 21; CaseBonus[2][3][bInternalId] = 1; CaseBonus[2][3][bCount] = 150; CaseBonus[2][3][bPriceSprayed] = 0;
    CaseBonus[2][4][bId] = 5; CaseBonus[2][4][bNumberOpen] = 5; CaseBonus[2][4][bRarity] = 4; CaseBonus[2][4][bType] = 4; CaseBonus[2][4][bInternalId] = 3; CaseBonus[2][4][bCount] = 1; CaseBonus[2][4][bPriceSprayed] = 0;

    // case json id 4
    CaseData[3][cId] = 4;
    CaseData[3][cPriceOne] = 1200;
    CaseData[3][cPriceTen] = 12000;
    CaseData[3][cDiscountOne] = 0;
    CaseData[3][cDiscountTen] = 5;
    CaseData[3][cAwardsCount] = 37;
    CaseData[3][cBonusCount] = 5;
    CaseAwards[3][0][aId] = 1; CaseAwards[3][0][aRarity] = 3; CaseAwards[3][0][aType] = 5; CaseAwards[3][0][aInternalId] = 436; CaseAwards[3][0][aCount] = 0; CaseAwards[3][0][aPriceSprayed] = 130; CaseAwards[3][0][aSubcount] = 0;
    CaseAwards[3][1][aId] = 2; CaseAwards[3][1][aRarity] = 3; CaseAwards[3][1][aType] = 5; CaseAwards[3][1][aInternalId] = 2567; CaseAwards[3][1][aCount] = 0; CaseAwards[3][1][aPriceSprayed] = 130; CaseAwards[3][1][aSubcount] = 0;
    CaseAwards[3][2][aId] = 3; CaseAwards[3][2][aRarity] = 3; CaseAwards[3][2][aType] = 5; CaseAwards[3][2][aInternalId] = 560; CaseAwards[3][2][aCount] = 0; CaseAwards[3][2][aPriceSprayed] = 140; CaseAwards[3][2][aSubcount] = 0;
    CaseAwards[3][3][aId] = 4; CaseAwards[3][3][aRarity] = 3; CaseAwards[3][3][aType] = 5; CaseAwards[3][3][aInternalId] = 550; CaseAwards[3][3][aCount] = 0; CaseAwards[3][3][aPriceSprayed] = 140; CaseAwards[3][3][aSubcount] = 0;
    CaseAwards[3][4][aId] = 5; CaseAwards[3][4][aRarity] = 3; CaseAwards[3][4][aType] = 5; CaseAwards[3][4][aInternalId] = 28671; CaseAwards[3][4][aCount] = 0; CaseAwards[3][4][aPriceSprayed] = 150; CaseAwards[3][4][aSubcount] = 113;
    CaseAwards[3][5][aId] = 6; CaseAwards[3][5][aRarity] = 3; CaseAwards[3][5][aType] = 5; CaseAwards[3][5][aInternalId] = 603; CaseAwards[3][5][aCount] = 0; CaseAwards[3][5][aPriceSprayed] = 150; CaseAwards[3][5][aSubcount] = 0;
    CaseAwards[3][6][aId] = 7; CaseAwards[3][6][aRarity] = 3; CaseAwards[3][6][aType] = 5; CaseAwards[3][6][aInternalId] = 2552; CaseAwards[3][6][aCount] = 0; CaseAwards[3][6][aPriceSprayed] = 150; CaseAwards[3][6][aSubcount] = 0;
    CaseAwards[3][7][aId] = 8; CaseAwards[3][7][aRarity] = 3; CaseAwards[3][7][aType] = 5; CaseAwards[3][7][aInternalId] = 565; CaseAwards[3][7][aCount] = 0; CaseAwards[3][7][aPriceSprayed] = 150; CaseAwards[3][7][aSubcount] = 0;
    CaseAwards[3][8][aId] = 9; CaseAwards[3][8][aRarity] = 3; CaseAwards[3][8][aType] = 5; CaseAwards[3][8][aInternalId] = 2609; CaseAwards[3][8][aCount] = 0; CaseAwards[3][8][aPriceSprayed] = 160; CaseAwards[3][8][aSubcount] = 0;
    CaseAwards[3][9][aId] = 10; CaseAwards[3][9][aRarity] = 3; CaseAwards[3][9][aType] = 5; CaseAwards[3][9][aInternalId] = 2604; CaseAwards[3][9][aCount] = 0; CaseAwards[3][9][aPriceSprayed] = 160; CaseAwards[3][9][aSubcount] = 0;
    CaseAwards[3][10][aId] = 11; CaseAwards[3][10][aRarity] = 3; CaseAwards[3][10][aType] = 5; CaseAwards[3][10][aInternalId] = 551; CaseAwards[3][10][aCount] = 0; CaseAwards[3][10][aPriceSprayed] = 160; CaseAwards[3][10][aSubcount] = 0;
    CaseAwards[3][11][aId] = 12; CaseAwards[3][11][aRarity] = 3; CaseAwards[3][11][aType] = 5; CaseAwards[3][11][aInternalId] = 2390; CaseAwards[3][11][aCount] = 0; CaseAwards[3][11][aPriceSprayed] = 160; CaseAwards[3][11][aSubcount] = 0;
    CaseAwards[3][12][aId] = 13; CaseAwards[3][12][aRarity] = 3; CaseAwards[3][12][aType] = 5; CaseAwards[3][12][aInternalId] = 526; CaseAwards[3][12][aCount] = 0; CaseAwards[3][12][aPriceSprayed] = 160; CaseAwards[3][12][aSubcount] = 0;
    CaseAwards[3][13][aId] = 14; CaseAwards[3][13][aRarity] = 3; CaseAwards[3][13][aType] = 5; CaseAwards[3][13][aInternalId] = 2620; CaseAwards[3][13][aCount] = 0; CaseAwards[3][13][aPriceSprayed] = 170; CaseAwards[3][13][aSubcount] = 0;
    CaseAwards[3][14][aId] = 15; CaseAwards[3][14][aRarity] = 3; CaseAwards[3][14][aType] = 5; CaseAwards[3][14][aInternalId] = 2594; CaseAwards[3][14][aCount] = 0; CaseAwards[3][14][aPriceSprayed] = 180; CaseAwards[3][14][aSubcount] = 0;
    CaseAwards[3][15][aId] = 16; CaseAwards[3][15][aRarity] = 3; CaseAwards[3][15][aType] = 5; CaseAwards[3][15][aInternalId] = 2621; CaseAwards[3][15][aCount] = 0; CaseAwards[3][15][aPriceSprayed] = 180; CaseAwards[3][15][aSubcount] = 0;
    CaseAwards[3][16][aId] = 17; CaseAwards[3][16][aRarity] = 3; CaseAwards[3][16][aType] = 5; CaseAwards[3][16][aInternalId] = 2387; CaseAwards[3][16][aCount] = 0; CaseAwards[3][16][aPriceSprayed] = 200; CaseAwards[3][16][aSubcount] = 0;
    CaseAwards[3][17][aId] = 18; CaseAwards[3][17][aRarity] = 3; CaseAwards[3][17][aType] = 5; CaseAwards[3][17][aInternalId] = 480; CaseAwards[3][17][aCount] = 0; CaseAwards[3][17][aPriceSprayed] = 200; CaseAwards[3][17][aSubcount] = 0;
    CaseAwards[3][18][aId] = 19; CaseAwards[3][18][aRarity] = 3; CaseAwards[3][18][aType] = 5; CaseAwards[3][18][aInternalId] = 2394; CaseAwards[3][18][aCount] = 0; CaseAwards[3][18][aPriceSprayed] = 200; CaseAwards[3][18][aSubcount] = 0;
    CaseAwards[3][19][aId] = 20; CaseAwards[3][19][aRarity] = 3; CaseAwards[3][19][aType] = 5; CaseAwards[3][19][aInternalId] = 558; CaseAwards[3][19][aCount] = 0; CaseAwards[3][19][aPriceSprayed] = 210; CaseAwards[3][19][aSubcount] = 0;
    CaseAwards[3][20][aId] = 21; CaseAwards[3][20][aRarity] = 4; CaseAwards[3][20][aType] = 5; CaseAwards[3][20][aInternalId] = 28694; CaseAwards[3][20][aCount] = 0; CaseAwards[3][20][aPriceSprayed] = 450; CaseAwards[3][20][aSubcount] = 134;
    CaseAwards[3][21][aId] = 22; CaseAwards[3][21][aRarity] = 4; CaseAwards[3][21][aType] = 5; CaseAwards[3][21][aInternalId] = 28697; CaseAwards[3][21][aCount] = 0; CaseAwards[3][21][aPriceSprayed] = 450; CaseAwards[3][21][aSubcount] = 135;
    CaseAwards[3][22][aId] = 23; CaseAwards[3][22][aRarity] = 4; CaseAwards[3][22][aType] = 5; CaseAwards[3][22][aInternalId] = 402; CaseAwards[3][22][aCount] = 0; CaseAwards[3][22][aPriceSprayed] = 240; CaseAwards[3][22][aSubcount] = 0;
    CaseAwards[3][23][aId] = 24; CaseAwards[3][23][aRarity] = 4; CaseAwards[3][23][aType] = 5; CaseAwards[3][23][aInternalId] = 505; CaseAwards[3][23][aCount] = 0; CaseAwards[3][23][aPriceSprayed] = 240; CaseAwards[3][23][aSubcount] = 0;
    CaseAwards[3][24][aId] = 25; CaseAwards[3][24][aRarity] = 4; CaseAwards[3][24][aType] = 5; CaseAwards[3][24][aInternalId] = 2598; CaseAwards[3][24][aCount] = 0; CaseAwards[3][24][aPriceSprayed] = 250; CaseAwards[3][24][aSubcount] = 0;
    CaseAwards[3][25][aId] = 26; CaseAwards[3][25][aRarity] = 4; CaseAwards[3][25][aType] = 5; CaseAwards[3][25][aInternalId] = 400; CaseAwards[3][25][aCount] = 0; CaseAwards[3][25][aPriceSprayed] = 260; CaseAwards[3][25][aSubcount] = 0;
    CaseAwards[3][26][aId] = 27; CaseAwards[3][26][aRarity] = 4; CaseAwards[3][26][aType] = 5; CaseAwards[3][26][aInternalId] = 2547; CaseAwards[3][26][aCount] = 0; CaseAwards[3][26][aPriceSprayed] = 250; CaseAwards[3][26][aSubcount] = 0;
    CaseAwards[3][27][aId] = 28; CaseAwards[3][27][aRarity] = 4; CaseAwards[3][27][aType] = 5; CaseAwards[3][27][aInternalId] = 506; CaseAwards[3][27][aCount] = 0; CaseAwards[3][27][aPriceSprayed] = 270; CaseAwards[3][27][aSubcount] = 0;
    CaseAwards[3][28][aId] = 29; CaseAwards[3][28][aRarity] = 4; CaseAwards[3][28][aType] = 5; CaseAwards[3][28][aInternalId] = 763; CaseAwards[3][28][aCount] = 0; CaseAwards[3][28][aPriceSprayed] = 280; CaseAwards[3][28][aSubcount] = 0;
    CaseAwards[3][29][aId] = 30; CaseAwards[3][29][aRarity] = 4; CaseAwards[3][29][aType] = 5; CaseAwards[3][29][aInternalId] = 28693; CaseAwards[3][29][aCount] = 0; CaseAwards[3][29][aPriceSprayed] = 450; CaseAwards[3][29][aSubcount] = 133;
    CaseAwards[3][30][aId] = 31; CaseAwards[3][30][aRarity] = 5; CaseAwards[3][30][aType] = 5; CaseAwards[3][30][aInternalId] = 415; CaseAwards[3][30][aCount] = 0; CaseAwards[3][30][aPriceSprayed] = 400; CaseAwards[3][30][aSubcount] = 0;
    CaseAwards[3][31][aId] = 32; CaseAwards[3][31][aRarity] = 5; CaseAwards[3][31][aType] = 5; CaseAwards[3][31][aInternalId] = 2543; CaseAwards[3][31][aCount] = 0; CaseAwards[3][31][aPriceSprayed] = 400; CaseAwards[3][31][aSubcount] = 0;
    CaseAwards[3][32][aId] = 33; CaseAwards[3][32][aRarity] = 5; CaseAwards[3][32][aType] = 5; CaseAwards[3][32][aInternalId] = 2573; CaseAwards[3][32][aCount] = 0; CaseAwards[3][32][aPriceSprayed] = 430; CaseAwards[3][32][aSubcount] = 0;
    CaseAwards[3][33][aId] = 34; CaseAwards[3][33][aRarity] = 5; CaseAwards[3][33][aType] = 5; CaseAwards[3][33][aInternalId] = 2558; CaseAwards[3][33][aCount] = 0; CaseAwards[3][33][aPriceSprayed] = 450; CaseAwards[3][33][aSubcount] = 0;
    CaseAwards[3][34][aId] = 35; CaseAwards[3][34][aRarity] = 5; CaseAwards[3][34][aType] = 5; CaseAwards[3][34][aInternalId] = 2597; CaseAwards[3][34][aCount] = 0; CaseAwards[3][34][aPriceSprayed] = 450; CaseAwards[3][34][aSubcount] = 0;
    CaseAwards[3][35][aId] = 36; CaseAwards[3][35][aRarity] = 5; CaseAwards[3][35][aType] = 5; CaseAwards[3][35][aInternalId] = 2558; CaseAwards[3][35][aCount] = 0; CaseAwards[3][35][aPriceSprayed] = 450; CaseAwards[3][35][aSubcount] = 0;
    CaseAwards[3][36][aId] = 37; CaseAwards[3][36][aRarity] = 5; CaseAwards[3][36][aType] = 5; CaseAwards[3][36][aInternalId] = 28672; CaseAwards[3][36][aCount] = 0; CaseAwards[3][36][aPriceSprayed] = 450; CaseAwards[3][36][aSubcount] = 0;
    CaseBonus[3][0][bId] = 1; CaseBonus[3][0][bNumberOpen] = 40; CaseBonus[3][0][bRarity] = 5; CaseBonus[3][0][bType] = 5; CaseBonus[3][0][bInternalId] = 668; CaseBonus[3][0][bCount] = 0; CaseBonus[3][0][bPriceSprayed] = 500;
    CaseBonus[3][1][bId] = 2; CaseBonus[3][1][bNumberOpen] = 30; CaseBonus[3][1][bRarity] = 4; CaseBonus[3][1][bType] = 21; CaseBonus[3][1][bInternalId] = 1; CaseBonus[3][1][bCount] = 500; CaseBonus[3][1][bPriceSprayed] = 0;
    CaseBonus[3][2][bId] = 3; CaseBonus[3][2][bNumberOpen] = 20; CaseBonus[3][2][bRarity] = 4; CaseBonus[3][2][bType] = 4; CaseBonus[3][2][bInternalId] = 4; CaseBonus[3][2][bCount] = 2; CaseBonus[3][2][bPriceSprayed] = 0;
    CaseBonus[3][3][bId] = 4; CaseBonus[3][3][bNumberOpen] = 10; CaseBonus[3][3][bRarity] = 4; CaseBonus[3][3][bType] = 21; CaseBonus[3][3][bInternalId] = 1; CaseBonus[3][3][bCount] = 300; CaseBonus[3][3][bPriceSprayed] = 0;
    CaseBonus[3][4][bId] = 5; CaseBonus[3][4][bNumberOpen] = 5; CaseBonus[3][4][bRarity] = 4; CaseBonus[3][4][bType] = 4; CaseBonus[3][4][bInternalId] = 4; CaseBonus[3][4][bCount] = 1; CaseBonus[3][4][bPriceSprayed] = 0;

    // case json id 5
    CaseData[4][cId] = 5;
    CaseData[4][cPriceOne] = 10000;
    CaseData[4][cPriceTen] = 100000;
    CaseData[4][cDiscountOne] = 0;
    CaseData[4][cDiscountTen] = 0;
    CaseData[4][cAwardsCount] = 22;
    CaseData[4][cBonusCount] = 5;
    CaseAwards[4][0][aId] = 1; CaseAwards[4][0][aRarity] = 4; CaseAwards[4][0][aType] = 5; CaseAwards[4][0][aInternalId] = 410; CaseAwards[4][0][aCount] = 0; CaseAwards[4][0][aPriceSprayed] = 230; CaseAwards[4][0][aSubcount] = 0;
    CaseAwards[4][1][aId] = 2; CaseAwards[4][1][aRarity] = 4; CaseAwards[4][1][aType] = 5; CaseAwards[4][1][aInternalId] = 604; CaseAwards[4][1][aCount] = 0; CaseAwards[4][1][aPriceSprayed] = 260; CaseAwards[4][1][aSubcount] = 0;
    CaseAwards[4][2][aId] = 3; CaseAwards[4][2][aRarity] = 4; CaseAwards[4][2][aType] = 5; CaseAwards[4][2][aInternalId] = 2389; CaseAwards[4][2][aCount] = 0; CaseAwards[4][2][aPriceSprayed] = 270; CaseAwards[4][2][aSubcount] = 0;
    CaseAwards[4][3][aId] = 4; CaseAwards[4][3][aRarity] = 4; CaseAwards[4][3][aType] = 5; CaseAwards[4][3][aInternalId] = 2574; CaseAwards[4][3][aCount] = 0; CaseAwards[4][3][aPriceSprayed] = 290; CaseAwards[4][3][aSubcount] = 0;
    CaseAwards[4][4][aId] = 5; CaseAwards[4][4][aRarity] = 4; CaseAwards[4][4][aType] = 5; CaseAwards[4][4][aInternalId] = 451; CaseAwards[4][4][aCount] = 0; CaseAwards[4][4][aPriceSprayed] = 340; CaseAwards[4][4][aSubcount] = 0;
    CaseAwards[4][5][aId] = 6; CaseAwards[4][5][aRarity] = 4; CaseAwards[4][5][aType] = 5; CaseAwards[4][5][aInternalId] = 2626; CaseAwards[4][5][aCount] = 0; CaseAwards[4][5][aPriceSprayed] = 350; CaseAwards[4][5][aSubcount] = 0;
    CaseAwards[4][6][aId] = 7; CaseAwards[4][6][aRarity] = 4; CaseAwards[4][6][aType] = 5; CaseAwards[4][6][aInternalId] = 2551; CaseAwards[4][6][aCount] = 0; CaseAwards[4][6][aPriceSprayed] = 350; CaseAwards[4][6][aSubcount] = 0;
    CaseAwards[4][7][aId] = 8; CaseAwards[4][7][aRarity] = 4; CaseAwards[4][7][aType] = 5; CaseAwards[4][7][aInternalId] = 2549; CaseAwards[4][7][aCount] = 0; CaseAwards[4][7][aPriceSprayed] = 370; CaseAwards[4][7][aSubcount] = 0;
    CaseAwards[4][8][aId] = 9; CaseAwards[4][8][aRarity] = 4; CaseAwards[4][8][aType] = 5; CaseAwards[4][8][aInternalId] = 2393; CaseAwards[4][8][aCount] = 0; CaseAwards[4][8][aPriceSprayed] = 370; CaseAwards[4][8][aSubcount] = 0;
    CaseAwards[4][9][aId] = 10; CaseAwards[4][9][aRarity] = 4; CaseAwards[4][9][aType] = 5; CaseAwards[4][9][aInternalId] = 579; CaseAwards[4][9][aCount] = 0; CaseAwards[4][9][aPriceSprayed] = 370; CaseAwards[4][9][aSubcount] = 0;
    CaseAwards[4][10][aId] = 11; CaseAwards[4][10][aRarity] = 5; CaseAwards[4][10][aType] = 5; CaseAwards[4][10][aInternalId] = 2619; CaseAwards[4][10][aCount] = 0; CaseAwards[4][10][aPriceSprayed] = 460; CaseAwards[4][10][aSubcount] = 0;
    CaseAwards[4][11][aId] = 12; CaseAwards[4][11][aRarity] = 5; CaseAwards[4][11][aType] = 5; CaseAwards[4][11][aInternalId] = 657; CaseAwards[4][11][aCount] = 0; CaseAwards[4][11][aPriceSprayed] = 490; CaseAwards[4][11][aSubcount] = 23;
    CaseAwards[4][12][aId] = 13; CaseAwards[4][12][aRarity] = 5; CaseAwards[4][12][aType] = 5; CaseAwards[4][12][aInternalId] = 669; CaseAwards[4][12][aCount] = 0; CaseAwards[4][12][aPriceSprayed] = 570; CaseAwards[4][12][aSubcount] = 0;
    CaseAwards[4][13][aId] = 14; CaseAwards[4][13][aRarity] = 5; CaseAwards[4][13][aType] = 5; CaseAwards[4][13][aInternalId] = 2564; CaseAwards[4][13][aCount] = 0; CaseAwards[4][13][aPriceSprayed] = 570; CaseAwards[4][13][aSubcount] = 0;
    CaseAwards[4][14][aId] = 15; CaseAwards[4][14][aRarity] = 5; CaseAwards[4][14][aType] = 5; CaseAwards[4][14][aInternalId] = 765; CaseAwards[4][14][aCount] = 0; CaseAwards[4][14][aPriceSprayed] = 600; CaseAwards[4][14][aSubcount] = 0;
    CaseAwards[4][15][aId] = 16; CaseAwards[4][15][aRarity] = 5; CaseAwards[4][15][aType] = 5; CaseAwards[4][15][aInternalId] = 2591; CaseAwards[4][15][aCount] = 0; CaseAwards[4][15][aPriceSprayed] = 670; CaseAwards[4][15][aSubcount] = 0;
    CaseAwards[4][16][aId] = 17; CaseAwards[4][16][aRarity] = 5; CaseAwards[4][16][aType] = 5; CaseAwards[4][16][aInternalId] = 2607; CaseAwards[4][16][aCount] = 0; CaseAwards[4][16][aPriceSprayed] = 750; CaseAwards[4][16][aSubcount] = 0;
    CaseAwards[4][17][aId] = 18; CaseAwards[4][17][aRarity] = 5; CaseAwards[4][17][aType] = 5; CaseAwards[4][17][aInternalId] = 2601; CaseAwards[4][17][aCount] = 0; CaseAwards[4][17][aPriceSprayed] = 800; CaseAwards[4][17][aSubcount] = 0;
    CaseAwards[4][18][aId] = 19; CaseAwards[4][18][aRarity] = 5; CaseAwards[4][18][aType] = 5; CaseAwards[4][18][aInternalId] = 667; CaseAwards[4][18][aCount] = 0; CaseAwards[4][18][aPriceSprayed] = 850; CaseAwards[4][18][aSubcount] = 0;
    CaseAwards[4][19][aId] = 20; CaseAwards[4][19][aRarity] = 5; CaseAwards[4][19][aType] = 5; CaseAwards[4][19][aInternalId] = 2570; CaseAwards[4][19][aCount] = 0; CaseAwards[4][19][aPriceSprayed] = 900; CaseAwards[4][19][aSubcount] = 0;
    CaseAwards[4][20][aId] = 21; CaseAwards[4][20][aRarity] = 5; CaseAwards[4][20][aType] = 5; CaseAwards[4][20][aInternalId] = 666; CaseAwards[4][20][aCount] = 0; CaseAwards[4][20][aPriceSprayed] = 900; CaseAwards[4][20][aSubcount] = 0;
    CaseAwards[4][21][aId] = 22; CaseAwards[4][21][aRarity] = 5; CaseAwards[4][21][aType] = 5; CaseAwards[4][21][aInternalId] = 466; CaseAwards[4][21][aCount] = 0; CaseAwards[4][21][aPriceSprayed] = 900; CaseAwards[4][21][aSubcount] = 1;
    CaseBonus[4][0][bId] = 1; CaseBonus[4][0][bNumberOpen] = 25; CaseBonus[4][0][bRarity] = 5; CaseBonus[4][0][bType] = 5; CaseBonus[4][0][bInternalId] = 665; CaseBonus[4][0][bCount] = 0; CaseBonus[4][0][bPriceSprayed] = 500;
    CaseBonus[4][1][bId] = 2; CaseBonus[4][1][bNumberOpen] = 20; CaseBonus[4][1][bRarity] = 5; CaseBonus[4][1][bType] = 21; CaseBonus[4][1][bInternalId] = 1; CaseBonus[4][1][bCount] = 1500; CaseBonus[4][1][bPriceSprayed] = 0;
    CaseBonus[4][2][bId] = 3; CaseBonus[4][2][bNumberOpen] = 15; CaseBonus[4][2][bRarity] = 5; CaseBonus[4][2][bType] = 4; CaseBonus[4][2][bInternalId] = 5; CaseBonus[4][2][bCount] = 2; CaseBonus[4][2][bPriceSprayed] = 0;
    CaseBonus[4][3][bId] = 4; CaseBonus[4][3][bNumberOpen] = 10; CaseBonus[4][3][bRarity] = 5; CaseBonus[4][3][bType] = 21; CaseBonus[4][3][bInternalId] = 1; CaseBonus[4][3][bCount] = 1000; CaseBonus[4][3][bPriceSprayed] = 0;
    CaseBonus[4][4][bId] = 5; CaseBonus[4][4][bNumberOpen] = 5; CaseBonus[4][4][bRarity] = 5; CaseBonus[4][4][bType] = 4; CaseBonus[4][4][bInternalId] = 5; CaseBonus[4][4][bCount] = 1; CaseBonus[4][4][bPriceSprayed] = 0;

    // case json id 6
    CaseData[5][cId] = 6;
    CaseData[5][cPriceOne] = 900;
    CaseData[5][cPriceTen] = 9000;
    CaseData[5][cDiscountOne] = 0;
    CaseData[5][cDiscountTen] = 5;
    CaseData[5][cAwardsCount] = 25;
    CaseData[5][cBonusCount] = 5;
    CaseAwards[5][0][aId] = 1; CaseAwards[5][0][aRarity] = 2; CaseAwards[5][0][aType] = 11; CaseAwards[5][0][aInternalId] = 134; CaseAwards[5][0][aCount] = 12293; CaseAwards[5][0][aPriceSprayed] = 100; CaseAwards[5][0][aSubcount] = 0;
    CaseAwards[5][1][aId] = 2; CaseAwards[5][1][aRarity] = 2; CaseAwards[5][1][aType] = 11; CaseAwards[5][1][aInternalId] = 508; CaseAwards[5][1][aCount] = 1; CaseAwards[5][1][aPriceSprayed] = 100; CaseAwards[5][1][aSubcount] = 0;
    CaseAwards[5][2][aId] = 3; CaseAwards[5][2][aRarity] = 2; CaseAwards[5][2][aType] = 11; CaseAwards[5][2][aInternalId] = 511; CaseAwards[5][2][aCount] = 1; CaseAwards[5][2][aPriceSprayed] = 100; CaseAwards[5][2][aSubcount] = 0;
    CaseAwards[5][3][aId] = 4; CaseAwards[5][3][aRarity] = 2; CaseAwards[5][3][aType] = 10; CaseAwards[5][3][aInternalId] = 1; CaseAwards[5][3][aCount] = 6000; CaseAwards[5][3][aPriceSprayed] = 0; CaseAwards[5][3][aSubcount] = 0;
    CaseAwards[5][4][aId] = 5; CaseAwards[5][4][aRarity] = 2; CaseAwards[5][4][aType] = 11; CaseAwards[5][4][aInternalId] = 890; CaseAwards[5][4][aCount] = 1; CaseAwards[5][4][aPriceSprayed] = 100; CaseAwards[5][4][aSubcount] = 0;
    CaseAwards[5][5][aId] = 6; CaseAwards[5][5][aRarity] = 2; CaseAwards[5][5][aType] = 11; CaseAwards[5][5][aInternalId] = 360; CaseAwards[5][5][aCount] = 1; CaseAwards[5][5][aPriceSprayed] = 100; CaseAwards[5][5][aSubcount] = 0;
    CaseAwards[5][6][aId] = 7; CaseAwards[5][6][aRarity] = 2; CaseAwards[5][6][aType] = 3; CaseAwards[5][6][aInternalId] = 1; CaseAwards[5][6][aCount] = 700; CaseAwards[5][6][aPriceSprayed] = 0; CaseAwards[5][6][aSubcount] = 0;
    CaseAwards[5][7][aId] = 8; CaseAwards[5][7][aRarity] = 2; CaseAwards[5][7][aType] = 11; CaseAwards[5][7][aInternalId] = 134; CaseAwards[5][7][aCount] = 11917; CaseAwards[5][7][aPriceSprayed] = 110; CaseAwards[5][7][aSubcount] = 0;
    CaseAwards[5][8][aId] = 9; CaseAwards[5][8][aRarity] = 2; CaseAwards[5][8][aType] = 10; CaseAwards[5][8][aInternalId] = 1; CaseAwards[5][8][aCount] = 7000; CaseAwards[5][8][aPriceSprayed] = 0; CaseAwards[5][8][aSubcount] = 0;
    CaseAwards[5][9][aId] = 10; CaseAwards[5][9][aRarity] = 2; CaseAwards[5][9][aType] = 5; CaseAwards[5][9][aInternalId] = 2568; CaseAwards[5][9][aCount] = 0; CaseAwards[5][9][aPriceSprayed] = 110; CaseAwards[5][9][aSubcount] = 0;
    CaseAwards[5][10][aId] = 11; CaseAwards[5][10][aRarity] = 2; CaseAwards[5][10][aType] = 2; CaseAwards[5][10][aInternalId] = 1; CaseAwards[5][10][aCount] = 750000; CaseAwards[5][10][aPriceSprayed] = 0; CaseAwards[5][10][aSubcount] = 0;
    CaseAwards[5][11][aId] = 12; CaseAwards[5][11][aRarity] = 2; CaseAwards[5][11][aType] = 11; CaseAwards[5][11][aInternalId] = 891; CaseAwards[5][11][aCount] = 1; CaseAwards[5][11][aPriceSprayed] = 120; CaseAwards[5][11][aSubcount] = 0;
    CaseAwards[5][12][aId] = 13; CaseAwards[5][12][aRarity] = 2; CaseAwards[5][12][aType] = 10; CaseAwards[5][12][aInternalId] = 1; CaseAwards[5][12][aCount] = 9000; CaseAwards[5][12][aPriceSprayed] = 0; CaseAwards[5][12][aSubcount] = 0;
    CaseAwards[5][13][aId] = 14; CaseAwards[5][13][aRarity] = 3; CaseAwards[5][13][aType] = 11; CaseAwards[5][13][aInternalId] = 134; CaseAwards[5][13][aCount] = 236; CaseAwards[5][13][aPriceSprayed] = 130; CaseAwards[5][13][aSubcount] = 0;
    CaseAwards[5][14][aId] = 15; CaseAwards[5][14][aRarity] = 3; CaseAwards[5][14][aType] = 11; CaseAwards[5][14][aInternalId] = 892; CaseAwards[5][14][aCount] = 1; CaseAwards[5][14][aPriceSprayed] = 130; CaseAwards[5][14][aSubcount] = 0;
    CaseAwards[5][15][aId] = 16; CaseAwards[5][15][aRarity] = 3; CaseAwards[5][15][aType] = 11; CaseAwards[5][15][aInternalId] = 134; CaseAwards[5][15][aCount] = 6889; CaseAwards[5][15][aPriceSprayed] = 130; CaseAwards[5][15][aSubcount] = 0;
    CaseAwards[5][16][aId] = 17; CaseAwards[5][16][aRarity] = 3; CaseAwards[5][16][aType] = 11; CaseAwards[5][16][aInternalId] = 134; CaseAwards[5][16][aCount] = 6888; CaseAwards[5][16][aPriceSprayed] = 140; CaseAwards[5][16][aSubcount] = 0;
    CaseAwards[5][17][aId] = 18; CaseAwards[5][17][aRarity] = 3; CaseAwards[5][17][aType] = 5; CaseAwards[5][17][aInternalId] = 603; CaseAwards[5][17][aCount] = 0; CaseAwards[5][17][aPriceSprayed] = 140; CaseAwards[5][17][aSubcount] = 0;
    CaseAwards[5][18][aId] = 19; CaseAwards[5][18][aRarity] = 3; CaseAwards[5][18][aType] = 5; CaseAwards[5][18][aInternalId] = 656; CaseAwards[5][18][aCount] = 0; CaseAwards[5][18][aPriceSprayed] = 160; CaseAwards[5][18][aSubcount] = 22;
    CaseAwards[5][19][aId] = 20; CaseAwards[5][19][aRarity] = 3; CaseAwards[5][19][aType] = 5; CaseAwards[5][19][aInternalId] = 2625; CaseAwards[5][19][aCount] = 0; CaseAwards[5][19][aPriceSprayed] = 180; CaseAwards[5][19][aSubcount] = 0;
    CaseAwards[5][20][aId] = 21; CaseAwards[5][20][aRarity] = 3; CaseAwards[5][20][aType] = 5; CaseAwards[5][20][aInternalId] = 503; CaseAwards[5][20][aCount] = 0; CaseAwards[5][20][aPriceSprayed] = 230; CaseAwards[5][20][aSubcount] = 0;
    CaseAwards[5][21][aId] = 22; CaseAwards[5][21][aRarity] = 4; CaseAwards[5][21][aType] = 5; CaseAwards[5][21][aInternalId] = 2598; CaseAwards[5][21][aCount] = 0; CaseAwards[5][21][aPriceSprayed] = 250; CaseAwards[5][21][aSubcount] = 0;
    CaseAwards[5][22][aId] = 23; CaseAwards[5][22][aRarity] = 4; CaseAwards[5][22][aType] = 5; CaseAwards[5][22][aInternalId] = 502; CaseAwards[5][22][aCount] = 0; CaseAwards[5][22][aPriceSprayed] = 260; CaseAwards[5][22][aSubcount] = 0;
    CaseAwards[5][23][aId] = 24; CaseAwards[5][23][aRarity] = 4; CaseAwards[5][23][aType] = 5; CaseAwards[5][23][aInternalId] = 451; CaseAwards[5][23][aCount] = 0; CaseAwards[5][23][aPriceSprayed] = 340; CaseAwards[5][23][aSubcount] = 0;
    CaseAwards[5][24][aId] = 25; CaseAwards[5][24][aRarity] = 5; CaseAwards[5][24][aType] = 5; CaseAwards[5][24][aInternalId] = 657; CaseAwards[5][24][aCount] = 0; CaseAwards[5][24][aPriceSprayed] = 400; CaseAwards[5][24][aSubcount] = 23;
    CaseBonus[5][0][bId] = 1; CaseBonus[5][0][bNumberOpen] = 40; CaseBonus[5][0][bRarity] = 5; CaseBonus[5][0][bType] = 5; CaseBonus[5][0][bInternalId] = 658; CaseBonus[5][0][bCount] = 0; CaseBonus[5][0][bPriceSprayed] = 100;
    CaseBonus[5][1][bId] = 2; CaseBonus[5][1][bNumberOpen] = 30; CaseBonus[5][1][bRarity] = 4; CaseBonus[5][1][bType] = 21; CaseBonus[5][1][bInternalId] = 1; CaseBonus[5][1][bCount] = 350; CaseBonus[5][1][bPriceSprayed] = 0;
    CaseBonus[5][2][bId] = 3; CaseBonus[5][2][bNumberOpen] = 20; CaseBonus[5][2][bRarity] = 4; CaseBonus[5][2][bType] = 4; CaseBonus[5][2][bInternalId] = 6; CaseBonus[5][2][bCount] = 2; CaseBonus[5][2][bPriceSprayed] = 0;
    CaseBonus[5][3][bId] = 4; CaseBonus[5][3][bNumberOpen] = 10; CaseBonus[5][3][bRarity] = 4; CaseBonus[5][3][bType] = 21; CaseBonus[5][3][bInternalId] = 1; CaseBonus[5][3][bCount] = 200; CaseBonus[5][3][bPriceSprayed] = 0;
    CaseBonus[5][4][bId] = 5; CaseBonus[5][4][bNumberOpen] = 5; CaseBonus[5][4][bRarity] = 4; CaseBonus[5][4][bType] = 4; CaseBonus[5][4][bInternalId] = 6; CaseBonus[5][4][bCount] = 1; CaseBonus[5][4][bPriceSprayed] = 0;

    // case json id 7
    CaseData[6][cId] = 7;
    CaseData[6][cPriceOne] = 900;
    CaseData[6][cPriceTen] = 9000;
    CaseData[6][cDiscountOne] = 0;
    CaseData[6][cDiscountTen] = 5;
    CaseData[6][cAwardsCount] = 25;
    CaseData[6][cBonusCount] = 5;
    CaseAwards[6][0][aId] = 1; CaseAwards[6][0][aRarity] = 2; CaseAwards[6][0][aType] = 11; CaseAwards[6][0][aInternalId] = 134; CaseAwards[6][0][aCount] = 12293; CaseAwards[6][0][aPriceSprayed] = 100; CaseAwards[6][0][aSubcount] = 0;
    CaseAwards[6][1][aId] = 2; CaseAwards[6][1][aRarity] = 2; CaseAwards[6][1][aType] = 11; CaseAwards[6][1][aInternalId] = 360; CaseAwards[6][1][aCount] = 1; CaseAwards[6][1][aPriceSprayed] = 100; CaseAwards[6][1][aSubcount] = 0;
    CaseAwards[6][2][aId] = 3; CaseAwards[6][2][aRarity] = 2; CaseAwards[6][2][aType] = 11; CaseAwards[6][2][aInternalId] = 940; CaseAwards[6][2][aCount] = 1; CaseAwards[6][2][aPriceSprayed] = 120; CaseAwards[6][2][aSubcount] = 0;
    CaseAwards[6][3][aId] = 4; CaseAwards[6][3][aRarity] = 2; CaseAwards[6][3][aType] = 11; CaseAwards[6][3][aInternalId] = 511; CaseAwards[6][3][aCount] = 1; CaseAwards[6][3][aPriceSprayed] = 100; CaseAwards[6][3][aSubcount] = 0;
    CaseAwards[6][4][aId] = 5; CaseAwards[6][4][aRarity] = 2; CaseAwards[6][4][aType] = 11; CaseAwards[6][4][aInternalId] = 939; CaseAwards[6][4][aCount] = 1; CaseAwards[6][4][aPriceSprayed] = 100; CaseAwards[6][4][aSubcount] = 0;
    CaseAwards[6][5][aId] = 6; CaseAwards[6][5][aRarity] = 2; CaseAwards[6][5][aType] = 3; CaseAwards[6][5][aInternalId] = 1; CaseAwards[6][5][aCount] = 700; CaseAwards[6][5][aPriceSprayed] = 0; CaseAwards[6][5][aSubcount] = 0;
    CaseAwards[6][6][aId] = 7; CaseAwards[6][6][aRarity] = 2; CaseAwards[6][6][aType] = 10; CaseAwards[6][6][aInternalId] = 1; CaseAwards[6][6][aCount] = 7000; CaseAwards[6][6][aPriceSprayed] = 0; CaseAwards[6][6][aSubcount] = 0;
    CaseAwards[6][7][aId] = 8; CaseAwards[6][7][aRarity] = 2; CaseAwards[6][7][aType] = 11; CaseAwards[6][7][aInternalId] = 134; CaseAwards[6][7][aCount] = 11917; CaseAwards[6][7][aPriceSprayed] = 110; CaseAwards[6][7][aSubcount] = 0;
    CaseAwards[6][8][aId] = 9; CaseAwards[6][8][aRarity] = 2; CaseAwards[6][8][aType] = 23; CaseAwards[6][8][aInternalId] = 1; CaseAwards[6][8][aCount] = 3000; CaseAwards[6][8][aPriceSprayed] = 0; CaseAwards[6][8][aSubcount] = 0;
    CaseAwards[6][9][aId] = 10; CaseAwards[6][9][aRarity] = 2; CaseAwards[6][9][aType] = 5; CaseAwards[6][9][aInternalId] = 2568; CaseAwards[6][9][aCount] = 0; CaseAwards[6][9][aPriceSprayed] = 110; CaseAwards[6][9][aSubcount] = 0;
    CaseAwards[6][10][aId] = 11; CaseAwards[6][10][aRarity] = 3; CaseAwards[6][10][aType] = 11; CaseAwards[6][10][aInternalId] = 938; CaseAwards[6][10][aCount] = 1; CaseAwards[6][10][aPriceSprayed] = 140; CaseAwards[6][10][aSubcount] = 0;
    CaseAwards[6][11][aId] = 12; CaseAwards[6][11][aRarity] = 3; CaseAwards[6][11][aType] = 11; CaseAwards[6][11][aInternalId] = 134; CaseAwards[6][11][aCount] = 6868; CaseAwards[6][11][aPriceSprayed] = 140; CaseAwards[6][11][aSubcount] = 0;
    CaseAwards[6][12][aId] = 13; CaseAwards[6][12][aRarity] = 3; CaseAwards[6][12][aType] = 11; CaseAwards[6][12][aInternalId] = 134; CaseAwards[6][12][aCount] = 236; CaseAwards[6][12][aPriceSprayed] = 130; CaseAwards[6][12][aSubcount] = 0;
    CaseAwards[6][13][aId] = 14; CaseAwards[6][13][aRarity] = 3; CaseAwards[6][13][aType] = 5; CaseAwards[6][13][aInternalId] = 603; CaseAwards[6][13][aCount] = 0; CaseAwards[6][13][aPriceSprayed] = 140; CaseAwards[6][13][aSubcount] = 0;
    CaseAwards[6][14][aId] = 15; CaseAwards[6][14][aRarity] = 3; CaseAwards[6][14][aType] = 23; CaseAwards[6][14][aInternalId] = 1; CaseAwards[6][14][aCount] = 7500; CaseAwards[6][14][aPriceSprayed] = 0; CaseAwards[6][14][aSubcount] = 0;
    CaseAwards[6][15][aId] = 16; CaseAwards[6][15][aRarity] = 3; CaseAwards[6][15][aType] = 5; CaseAwards[6][15][aInternalId] = 2625; CaseAwards[6][15][aCount] = 0; CaseAwards[6][15][aPriceSprayed] = 180; CaseAwards[6][15][aSubcount] = 0;
    CaseAwards[6][16][aId] = 17; CaseAwards[6][16][aRarity] = 3; CaseAwards[6][16][aType] = 23; CaseAwards[6][16][aInternalId] = 1; CaseAwards[6][16][aCount] = 5000; CaseAwards[6][16][aPriceSprayed] = 0; CaseAwards[6][16][aSubcount] = 0;
    CaseAwards[6][17][aId] = 18; CaseAwards[6][17][aRarity] = 4; CaseAwards[6][17][aType] = 11; CaseAwards[6][17][aInternalId] = 134; CaseAwards[6][17][aCount] = 6867; CaseAwards[6][17][aPriceSprayed] = 160; CaseAwards[6][17][aSubcount] = 0;
    CaseAwards[6][18][aId] = 19; CaseAwards[6][18][aRarity] = 4; CaseAwards[6][18][aType] = 5; CaseAwards[6][18][aInternalId] = 503; CaseAwards[6][18][aCount] = 0; CaseAwards[6][18][aPriceSprayed] = 230; CaseAwards[6][18][aSubcount] = 0;
    CaseAwards[6][19][aId] = 20; CaseAwards[6][19][aRarity] = 4; CaseAwards[6][19][aType] = 23; CaseAwards[6][19][aInternalId] = 1; CaseAwards[6][19][aCount] = 15000; CaseAwards[6][19][aPriceSprayed] = 0; CaseAwards[6][19][aSubcount] = 0;
    CaseAwards[6][20][aId] = 21; CaseAwards[6][20][aRarity] = 4; CaseAwards[6][20][aType] = 5; CaseAwards[6][20][aInternalId] = 2598; CaseAwards[6][20][aCount] = 0; CaseAwards[6][20][aPriceSprayed] = 250; CaseAwards[6][20][aSubcount] = 0;
    CaseAwards[6][21][aId] = 22; CaseAwards[6][21][aRarity] = 4; CaseAwards[6][21][aType] = 5; CaseAwards[6][21][aInternalId] = 502; CaseAwards[6][21][aCount] = 0; CaseAwards[6][21][aPriceSprayed] = 260; CaseAwards[6][21][aSubcount] = 0;
    CaseAwards[6][22][aId] = 23; CaseAwards[6][22][aRarity] = 4; CaseAwards[6][22][aType] = 5; CaseAwards[6][22][aInternalId] = 451; CaseAwards[6][22][aCount] = 0; CaseAwards[6][22][aPriceSprayed] = 340; CaseAwards[6][22][aSubcount] = 0;
    CaseAwards[6][23][aId] = 24; CaseAwards[6][23][aRarity] = 4; CaseAwards[6][23][aType] = 5; CaseAwards[6][23][aInternalId] = 633; CaseAwards[6][23][aCount] = 0; CaseAwards[6][23][aPriceSprayed] = 180; CaseAwards[6][23][aSubcount] = 35;
    CaseAwards[6][24][aId] = 25; CaseAwards[6][24][aRarity] = 5; CaseAwards[6][24][aType] = 5; CaseAwards[6][24][aInternalId] = 632; CaseAwards[6][24][aCount] = 0; CaseAwards[6][24][aPriceSprayed] = 490; CaseAwards[6][24][aSubcount] = 34;
    CaseBonus[6][0][bId] = 1; CaseBonus[6][0][bNumberOpen] = 40; CaseBonus[6][0][bRarity] = 5; CaseBonus[6][0][bType] = 5; CaseBonus[6][0][bInternalId] = 634; CaseBonus[6][0][bCount] = 0; CaseBonus[6][0][bPriceSprayed] = 200;
    CaseBonus[6][1][bId] = 2; CaseBonus[6][1][bNumberOpen] = 30; CaseBonus[6][1][bRarity] = 4; CaseBonus[6][1][bType] = 23; CaseBonus[6][1][bInternalId] = 1; CaseBonus[6][1][bCount] = 10000; CaseBonus[6][1][bPriceSprayed] = 0;
    CaseBonus[6][2][bId] = 3; CaseBonus[6][2][bNumberOpen] = 20; CaseBonus[6][2][bRarity] = 4; CaseBonus[6][2][bType] = 4; CaseBonus[6][2][bInternalId] = 7; CaseBonus[6][2][bCount] = 2; CaseBonus[6][2][bPriceSprayed] = 0;
    CaseBonus[6][3][bId] = 4; CaseBonus[6][3][bNumberOpen] = 10; CaseBonus[6][3][bRarity] = 4; CaseBonus[6][3][bType] = 23; CaseBonus[6][3][bInternalId] = 1; CaseBonus[6][3][bCount] = 5000; CaseBonus[6][3][bPriceSprayed] = 0;
    CaseBonus[6][4][bId] = 5; CaseBonus[6][4][bNumberOpen] = 5; CaseBonus[6][4][bRarity] = 4; CaseBonus[6][4][bType] = 4; CaseBonus[6][4][bInternalId] = 7; CaseBonus[6][4][bCount] = 1; CaseBonus[6][4][bPriceSprayed] = 0;

    // case json id 8
    CaseData[7][cId] = 8;
    CaseData[7][cPriceOne] = 900;
    CaseData[7][cPriceTen] = 9000;
    CaseData[7][cDiscountOne] = 0;
    CaseData[7][cDiscountTen] = 5;
    CaseData[7][cAwardsCount] = 25;
    CaseData[7][cBonusCount] = 5;
    CaseAwards[7][0][aId] = 1; CaseAwards[7][0][aRarity] = 2; CaseAwards[7][0][aType] = 11; CaseAwards[7][0][aInternalId] = 134; CaseAwards[7][0][aCount] = 14386; CaseAwards[7][0][aPriceSprayed] = 100; CaseAwards[7][0][aSubcount] = 0;
    CaseAwards[7][1][aId] = 2; CaseAwards[7][1][aRarity] = 2; CaseAwards[7][1][aType] = 11; CaseAwards[7][1][aInternalId] = 360; CaseAwards[7][1][aCount] = 1; CaseAwards[7][1][aPriceSprayed] = 100; CaseAwards[7][1][aSubcount] = 0;
    CaseAwards[7][2][aId] = 3; CaseAwards[7][2][aRarity] = 2; CaseAwards[7][2][aType] = 11; CaseAwards[7][2][aInternalId] = 946; CaseAwards[7][2][aCount] = 1; CaseAwards[7][2][aPriceSprayed] = 120; CaseAwards[7][2][aSubcount] = 0;
    CaseAwards[7][3][aId] = 4; CaseAwards[7][3][aRarity] = 2; CaseAwards[7][3][aType] = 11; CaseAwards[7][3][aInternalId] = 511; CaseAwards[7][3][aCount] = 1; CaseAwards[7][3][aPriceSprayed] = 100; CaseAwards[7][3][aSubcount] = 0;
    CaseAwards[7][4][aId] = 5; CaseAwards[7][4][aRarity] = 2; CaseAwards[7][4][aType] = 11; CaseAwards[7][4][aInternalId] = 945; CaseAwards[7][4][aCount] = 1; CaseAwards[7][4][aPriceSprayed] = 100; CaseAwards[7][4][aSubcount] = 0;
    CaseAwards[7][5][aId] = 6; CaseAwards[7][5][aRarity] = 2; CaseAwards[7][5][aType] = 3; CaseAwards[7][5][aInternalId] = 1; CaseAwards[7][5][aCount] = 700; CaseAwards[7][5][aPriceSprayed] = 0; CaseAwards[7][5][aSubcount] = 0;
    CaseAwards[7][6][aId] = 7; CaseAwards[7][6][aRarity] = 2; CaseAwards[7][6][aType] = 10; CaseAwards[7][6][aInternalId] = 1; CaseAwards[7][6][aCount] = 7000; CaseAwards[7][6][aPriceSprayed] = 0; CaseAwards[7][6][aSubcount] = 0;
    CaseAwards[7][7][aId] = 8; CaseAwards[7][7][aRarity] = 2; CaseAwards[7][7][aType] = 11; CaseAwards[7][7][aInternalId] = 134; CaseAwards[7][7][aCount] = 11917; CaseAwards[7][7][aPriceSprayed] = 110; CaseAwards[7][7][aSubcount] = 0;
    CaseAwards[7][8][aId] = 9; CaseAwards[7][8][aRarity] = 2; CaseAwards[7][8][aType] = 23; CaseAwards[7][8][aInternalId] = 1; CaseAwards[7][8][aCount] = 3000; CaseAwards[7][8][aPriceSprayed] = 0; CaseAwards[7][8][aSubcount] = 0;
    CaseAwards[7][9][aId] = 10; CaseAwards[7][9][aRarity] = 2; CaseAwards[7][9][aType] = 5; CaseAwards[7][9][aInternalId] = 2568; CaseAwards[7][9][aCount] = 0; CaseAwards[7][9][aPriceSprayed] = 110; CaseAwards[7][9][aSubcount] = 0;
    CaseAwards[7][10][aId] = 11; CaseAwards[7][10][aRarity] = 3; CaseAwards[7][10][aType] = 11; CaseAwards[7][10][aInternalId] = 944; CaseAwards[7][10][aCount] = 1; CaseAwards[7][10][aPriceSprayed] = 140; CaseAwards[7][10][aSubcount] = 0;
    CaseAwards[7][11][aId] = 12; CaseAwards[7][11][aRarity] = 3; CaseAwards[7][11][aType] = 11; CaseAwards[7][11][aInternalId] = 134; CaseAwards[7][11][aCount] = 5885; CaseAwards[7][11][aPriceSprayed] = 140; CaseAwards[7][11][aSubcount] = 0;
    CaseAwards[7][12][aId] = 13; CaseAwards[7][12][aRarity] = 3; CaseAwards[7][12][aType] = 11; CaseAwards[7][12][aInternalId] = 134; CaseAwards[7][12][aCount] = 5326; CaseAwards[7][12][aPriceSprayed] = 130; CaseAwards[7][12][aSubcount] = 0;
    CaseAwards[7][13][aId] = 14; CaseAwards[7][13][aRarity] = 3; CaseAwards[7][13][aType] = 5; CaseAwards[7][13][aInternalId] = 603; CaseAwards[7][13][aCount] = 0; CaseAwards[7][13][aPriceSprayed] = 140; CaseAwards[7][13][aSubcount] = 0;
    CaseAwards[7][14][aId] = 15; CaseAwards[7][14][aRarity] = 3; CaseAwards[7][14][aType] = 23; CaseAwards[7][14][aInternalId] = 1; CaseAwards[7][14][aCount] = 7500; CaseAwards[7][14][aPriceSprayed] = 0; CaseAwards[7][14][aSubcount] = 0;
    CaseAwards[7][15][aId] = 16; CaseAwards[7][15][aRarity] = 3; CaseAwards[7][15][aType] = 5; CaseAwards[7][15][aInternalId] = 442; CaseAwards[7][15][aCount] = 0; CaseAwards[7][15][aPriceSprayed] = 170; CaseAwards[7][15][aSubcount] = 0;
    CaseAwards[7][16][aId] = 17; CaseAwards[7][16][aRarity] = 3; CaseAwards[7][16][aType] = 23; CaseAwards[7][16][aInternalId] = 1; CaseAwards[7][16][aCount] = 5000; CaseAwards[7][16][aPriceSprayed] = 0; CaseAwards[7][16][aSubcount] = 0;
    CaseAwards[7][17][aId] = 18; CaseAwards[7][17][aRarity] = 4; CaseAwards[7][17][aType] = 11; CaseAwards[7][17][aInternalId] = 134; CaseAwards[7][17][aCount] = 5884; CaseAwards[7][17][aPriceSprayed] = 160; CaseAwards[7][17][aSubcount] = 0;
    CaseAwards[7][18][aId] = 19; CaseAwards[7][18][aRarity] = 4; CaseAwards[7][18][aType] = 5; CaseAwards[7][18][aInternalId] = 503; CaseAwards[7][18][aCount] = 0; CaseAwards[7][18][aPriceSprayed] = 230; CaseAwards[7][18][aSubcount] = 0;
    CaseAwards[7][19][aId] = 20; CaseAwards[7][19][aRarity] = 4; CaseAwards[7][19][aType] = 23; CaseAwards[7][19][aInternalId] = 1; CaseAwards[7][19][aCount] = 15000; CaseAwards[7][19][aPriceSprayed] = 0; CaseAwards[7][19][aSubcount] = 0;
    CaseAwards[7][20][aId] = 21; CaseAwards[7][20][aRarity] = 4; CaseAwards[7][20][aType] = 5; CaseAwards[7][20][aInternalId] = 2603; CaseAwards[7][20][aCount] = 0; CaseAwards[7][20][aPriceSprayed] = 250; CaseAwards[7][20][aSubcount] = 0;
    CaseAwards[7][21][aId] = 22; CaseAwards[7][21][aRarity] = 4; CaseAwards[7][21][aType] = 5; CaseAwards[7][21][aInternalId] = 502; CaseAwards[7][21][aCount] = 0; CaseAwards[7][21][aPriceSprayed] = 260; CaseAwards[7][21][aSubcount] = 0;
    CaseAwards[7][22][aId] = 23; CaseAwards[7][22][aRarity] = 4; CaseAwards[7][22][aType] = 5; CaseAwards[7][22][aInternalId] = 2599; CaseAwards[7][22][aCount] = 0; CaseAwards[7][22][aPriceSprayed] = 340; CaseAwards[7][22][aSubcount] = 0;
    CaseAwards[7][23][aId] = 24; CaseAwards[7][23][aRarity] = 4; CaseAwards[7][23][aType] = 5; CaseAwards[7][23][aInternalId] = 659; CaseAwards[7][23][aCount] = 0; CaseAwards[7][23][aPriceSprayed] = 180; CaseAwards[7][23][aSubcount] = 48;
    CaseAwards[7][24][aId] = 25; CaseAwards[7][24][aRarity] = 5; CaseAwards[7][24][aType] = 5; CaseAwards[7][24][aInternalId] = 661; CaseAwards[7][24][aCount] = 0; CaseAwards[7][24][aPriceSprayed] = 490; CaseAwards[7][24][aSubcount] = 49;
    CaseBonus[7][0][bId] = 1; CaseBonus[7][0][bNumberOpen] = 40; CaseBonus[7][0][bRarity] = 5; CaseBonus[7][0][bType] = 5; CaseBonus[7][0][bInternalId] = 660; CaseBonus[7][0][bCount] = 0; CaseBonus[7][0][bPriceSprayed] = 200;
    CaseBonus[7][1][bId] = 2; CaseBonus[7][1][bNumberOpen] = 30; CaseBonus[7][1][bRarity] = 4; CaseBonus[7][1][bType] = 23; CaseBonus[7][1][bInternalId] = 1; CaseBonus[7][1][bCount] = 10000; CaseBonus[7][1][bPriceSprayed] = 0;
    CaseBonus[7][2][bId] = 3; CaseBonus[7][2][bNumberOpen] = 20; CaseBonus[7][2][bRarity] = 4; CaseBonus[7][2][bType] = 4; CaseBonus[7][2][bInternalId] = 8; CaseBonus[7][2][bCount] = 2; CaseBonus[7][2][bPriceSprayed] = 0;
    CaseBonus[7][3][bId] = 4; CaseBonus[7][3][bNumberOpen] = 10; CaseBonus[7][3][bRarity] = 4; CaseBonus[7][3][bType] = 23; CaseBonus[7][3][bInternalId] = 1; CaseBonus[7][3][bCount] = 5000; CaseBonus[7][3][bPriceSprayed] = 0;
    CaseBonus[7][4][bId] = 5; CaseBonus[7][4][bNumberOpen] = 5; CaseBonus[7][4][bRarity] = 4; CaseBonus[7][4][bType] = 4; CaseBonus[7][4][bInternalId] = 8; CaseBonus[7][4][bCount] = 1; CaseBonus[7][4][bPriceSprayed] = 0;

    // case json id 9
    CaseData[8][cId] = 9;
    CaseData[8][cPriceOne] = 900;
    CaseData[8][cPriceTen] = 9000;
    CaseData[8][cDiscountOne] = 0;
    CaseData[8][cDiscountTen] = 5;
    CaseData[8][cAwardsCount] = 25;
    CaseData[8][cBonusCount] = 5;
    CaseAwards[8][0][aId] = 1; CaseAwards[8][0][aRarity] = 2; CaseAwards[8][0][aType] = 11; CaseAwards[8][0][aInternalId] = 134; CaseAwards[8][0][aCount] = 11960; CaseAwards[8][0][aPriceSprayed] = 120; CaseAwards[8][0][aSubcount] = 0;
    CaseAwards[8][1][aId] = 2; CaseAwards[8][1][aRarity] = 2; CaseAwards[8][1][aType] = 11; CaseAwards[8][1][aInternalId] = 360; CaseAwards[8][1][aCount] = 1; CaseAwards[8][1][aPriceSprayed] = 90; CaseAwards[8][1][aSubcount] = 0;
    CaseAwards[8][2][aId] = 3; CaseAwards[8][2][aRarity] = 2; CaseAwards[8][2][aType] = 11; CaseAwards[8][2][aInternalId] = 324; CaseAwards[8][2][aCount] = 1; CaseAwards[8][2][aPriceSprayed] = 90; CaseAwards[8][2][aSubcount] = 0;
    CaseAwards[8][3][aId] = 4; CaseAwards[8][3][aRarity] = 2; CaseAwards[8][3][aType] = 11; CaseAwards[8][3][aInternalId] = 511; CaseAwards[8][3][aCount] = 1; CaseAwards[8][3][aPriceSprayed] = 100; CaseAwards[8][3][aSubcount] = 0;
    CaseAwards[8][4][aId] = 5; CaseAwards[8][4][aRarity] = 2; CaseAwards[8][4][aType] = 3; CaseAwards[8][4][aInternalId] = 1; CaseAwards[8][4][aCount] = 700; CaseAwards[8][4][aPriceSprayed] = 0; CaseAwards[8][4][aSubcount] = 0;
    CaseAwards[8][5][aId] = 6; CaseAwards[8][5][aRarity] = 2; CaseAwards[8][5][aType] = 2; CaseAwards[8][5][aInternalId] = 1; CaseAwards[8][5][aCount] = 900000; CaseAwards[8][5][aPriceSprayed] = 0; CaseAwards[8][5][aSubcount] = 0;
    CaseAwards[8][6][aId] = 7; CaseAwards[8][6][aRarity] = 2; CaseAwards[8][6][aType] = 11; CaseAwards[8][6][aInternalId] = 134; CaseAwards[8][6][aCount] = 11917; CaseAwards[8][6][aPriceSprayed] = 110; CaseAwards[8][6][aSubcount] = 0;
    CaseAwards[8][7][aId] = 8; CaseAwards[8][7][aRarity] = 2; CaseAwards[8][7][aType] = 11; CaseAwards[8][7][aInternalId] = 362; CaseAwards[8][7][aCount] = 1; CaseAwards[8][7][aPriceSprayed] = 90; CaseAwards[8][7][aSubcount] = 0;
    CaseAwards[8][8][aId] = 9; CaseAwards[8][8][aRarity] = 2; CaseAwards[8][8][aType] = 5; CaseAwards[8][8][aInternalId] = 2568; CaseAwards[8][8][aCount] = 0; CaseAwards[8][8][aPriceSprayed] = 110; CaseAwards[8][8][aSubcount] = 0;
    CaseAwards[8][9][aId] = 10; CaseAwards[8][9][aRarity] = 3; CaseAwards[8][9][aType] = 11; CaseAwards[8][9][aInternalId] = 965; CaseAwards[8][9][aCount] = 1; CaseAwards[8][9][aPriceSprayed] = 140; CaseAwards[8][9][aSubcount] = 0;
    CaseAwards[8][10][aId] = 11; CaseAwards[8][10][aRarity] = 3; CaseAwards[8][10][aType] = 11; CaseAwards[8][10][aInternalId] = 134; CaseAwards[8][10][aCount] = 5894; CaseAwards[8][10][aPriceSprayed] = 140; CaseAwards[8][10][aSubcount] = 0;
    CaseAwards[8][11][aId] = 12; CaseAwards[8][11][aRarity] = 3; CaseAwards[8][11][aType] = 11; CaseAwards[8][11][aInternalId] = 134; CaseAwards[8][11][aCount] = 5365; CaseAwards[8][11][aPriceSprayed] = 140; CaseAwards[8][11][aSubcount] = 0;
    CaseAwards[8][12][aId] = 13; CaseAwards[8][12][aRarity] = 3; CaseAwards[8][12][aType] = 5; CaseAwards[8][12][aInternalId] = 603; CaseAwards[8][12][aCount] = 0; CaseAwards[8][12][aPriceSprayed] = 150; CaseAwards[8][12][aSubcount] = 0;
    CaseAwards[8][13][aId] = 14; CaseAwards[8][13][aRarity] = 3; CaseAwards[8][13][aType] = 2; CaseAwards[8][13][aInternalId] = 1; CaseAwards[8][13][aCount] = 1200000; CaseAwards[8][13][aPriceSprayed] = 0; CaseAwards[8][13][aSubcount] = 0;
    CaseAwards[8][14][aId] = 15; CaseAwards[8][14][aRarity] = 3; CaseAwards[8][14][aType] = 5; CaseAwards[8][14][aInternalId] = 2625; CaseAwards[8][14][aCount] = 0; CaseAwards[8][14][aPriceSprayed] = 180; CaseAwards[8][14][aSubcount] = 0;
    CaseAwards[8][15][aId] = 16; CaseAwards[8][15][aRarity] = 3; CaseAwards[8][15][aType] = 2; CaseAwards[8][15][aInternalId] = 1; CaseAwards[8][15][aCount] = 1500000; CaseAwards[8][15][aPriceSprayed] = 0; CaseAwards[8][15][aSubcount] = 0;
    CaseAwards[8][16][aId] = 17; CaseAwards[8][16][aRarity] = 3; CaseAwards[8][16][aType] = 11; CaseAwards[8][16][aInternalId] = 134; CaseAwards[8][16][aCount] = 5893; CaseAwards[8][16][aPriceSprayed] = 160; CaseAwards[8][16][aSubcount] = 0;
    CaseAwards[8][17][aId] = 18; CaseAwards[8][17][aRarity] = 3; CaseAwards[8][17][aType] = 5; CaseAwards[8][17][aInternalId] = 756; CaseAwards[8][17][aCount] = 0; CaseAwards[8][17][aPriceSprayed] = 160; CaseAwards[8][17][aSubcount] = 60;
    CaseAwards[8][18][aId] = 19; CaseAwards[8][18][aRarity] = 4; CaseAwards[8][18][aType] = 11; CaseAwards[8][18][aInternalId] = 966; CaseAwards[8][18][aCount] = 1; CaseAwards[8][18][aPriceSprayed] = 220; CaseAwards[8][18][aSubcount] = 0;
    CaseAwards[8][19][aId] = 20; CaseAwards[8][19][aRarity] = 4; CaseAwards[8][19][aType] = 5; CaseAwards[8][19][aInternalId] = 503; CaseAwards[8][19][aCount] = 0; CaseAwards[8][19][aPriceSprayed] = 230; CaseAwards[8][19][aSubcount] = 0;
    CaseAwards[8][20][aId] = 21; CaseAwards[8][20][aRarity] = 4; CaseAwards[8][20][aType] = 2; CaseAwards[8][20][aInternalId] = 1; CaseAwards[8][20][aCount] = 3000000; CaseAwards[8][20][aPriceSprayed] = 0; CaseAwards[8][20][aSubcount] = 0;
    CaseAwards[8][21][aId] = 22; CaseAwards[8][21][aRarity] = 4; CaseAwards[8][21][aType] = 5; CaseAwards[8][21][aInternalId] = 2553; CaseAwards[8][21][aCount] = 0; CaseAwards[8][21][aPriceSprayed] = 240; CaseAwards[8][21][aSubcount] = 0;
    CaseAwards[8][22][aId] = 23; CaseAwards[8][22][aRarity] = 4; CaseAwards[8][22][aType] = 5; CaseAwards[8][22][aInternalId] = 502; CaseAwards[8][22][aCount] = 0; CaseAwards[8][22][aPriceSprayed] = 260; CaseAwards[8][22][aSubcount] = 0;
    CaseAwards[8][23][aId] = 24; CaseAwards[8][23][aRarity] = 4; CaseAwards[8][23][aType] = 5; CaseAwards[8][23][aInternalId] = 429; CaseAwards[8][23][aCount] = 0; CaseAwards[8][23][aPriceSprayed] = 330; CaseAwards[8][23][aSubcount] = 0;
    CaseAwards[8][24][aId] = 25; CaseAwards[8][24][aRarity] = 5; CaseAwards[8][24][aType] = 5; CaseAwards[8][24][aInternalId] = 755; CaseAwards[8][24][aCount] = 0; CaseAwards[8][24][aPriceSprayed] = 600; CaseAwards[8][24][aSubcount] = 59;
    CaseBonus[8][0][bId] = 1; CaseBonus[8][0][bNumberOpen] = 40; CaseBonus[8][0][bRarity] = 5; CaseBonus[8][0][bType] = 5; CaseBonus[8][0][bInternalId] = 573; CaseBonus[8][0][bCount] = 0; CaseBonus[8][0][bPriceSprayed] = 400;
    CaseBonus[8][1][bId] = 2; CaseBonus[8][1][bNumberOpen] = 30; CaseBonus[8][1][bRarity] = 3; CaseBonus[8][1][bType] = 2; CaseBonus[8][1][bInternalId] = 1; CaseBonus[8][1][bCount] = 2500000; CaseBonus[8][1][bPriceSprayed] = 0;
    CaseBonus[8][2][bId] = 3; CaseBonus[8][2][bNumberOpen] = 20; CaseBonus[8][2][bRarity] = 4; CaseBonus[8][2][bType] = 4; CaseBonus[8][2][bInternalId] = 9; CaseBonus[8][2][bCount] = 2; CaseBonus[8][2][bPriceSprayed] = 0;
    CaseBonus[8][3][bId] = 4; CaseBonus[8][3][bNumberOpen] = 10; CaseBonus[8][3][bRarity] = 3; CaseBonus[8][3][bType] = 2; CaseBonus[8][3][bInternalId] = 1; CaseBonus[8][3][bCount] = 1200000; CaseBonus[8][3][bPriceSprayed] = 0;
    CaseBonus[8][4][bId] = 5; CaseBonus[8][4][bNumberOpen] = 5; CaseBonus[8][4][bRarity] = 4; CaseBonus[8][4][bType] = 4; CaseBonus[8][4][bInternalId] = 9; CaseBonus[8][4][bCount] = 1; CaseBonus[8][4][bPriceSprayed] = 0;

    // case json id 10
    CaseData[9][cId] = 10;
    CaseData[9][cPriceOne] = 900;
    CaseData[9][cPriceTen] = 9000;
    CaseData[9][cDiscountOne] = 0;
    CaseData[9][cDiscountTen] = 5;
    CaseData[9][cAwardsCount] = 25;
    CaseData[9][cBonusCount] = 5;
    CaseAwards[9][0][aId] = 1; CaseAwards[9][0][aRarity] = 2; CaseAwards[9][0][aType] = 11; CaseAwards[9][0][aInternalId] = 134; CaseAwards[9][0][aCount] = 12291; CaseAwards[9][0][aPriceSprayed] = 100; CaseAwards[9][0][aSubcount] = 0;
    CaseAwards[9][1][aId] = 2; CaseAwards[9][1][aRarity] = 2; CaseAwards[9][1][aType] = 11; CaseAwards[9][1][aInternalId] = 360; CaseAwards[9][1][aCount] = 1; CaseAwards[9][1][aPriceSprayed] = 100; CaseAwards[9][1][aSubcount] = 0;
    CaseAwards[9][2][aId] = 3; CaseAwards[9][2][aRarity] = 2; CaseAwards[9][2][aType] = 5; CaseAwards[9][2][aInternalId] = 2384; CaseAwards[9][2][aCount] = 0; CaseAwards[9][2][aPriceSprayed] = 110; CaseAwards[9][2][aSubcount] = 0;
    CaseAwards[9][3][aId] = 4; CaseAwards[9][3][aRarity] = 2; CaseAwards[9][3][aType] = 11; CaseAwards[9][3][aInternalId] = 583; CaseAwards[9][3][aCount] = 1; CaseAwards[9][3][aPriceSprayed] = 100; CaseAwards[9][3][aSubcount] = 0;
    CaseAwards[9][4][aId] = 5; CaseAwards[9][4][aRarity] = 2; CaseAwards[9][4][aType] = 11; CaseAwards[9][4][aInternalId] = 134; CaseAwards[9][4][aCount] = 252; CaseAwards[9][4][aPriceSprayed] = 110; CaseAwards[9][4][aSubcount] = 0;
    CaseAwards[9][5][aId] = 6; CaseAwards[9][5][aRarity] = 2; CaseAwards[9][5][aType] = 3; CaseAwards[9][5][aInternalId] = 1; CaseAwards[9][5][aCount] = 700; CaseAwards[9][5][aPriceSprayed] = 0; CaseAwards[9][5][aSubcount] = 0;
    CaseAwards[9][6][aId] = 7; CaseAwards[9][6][aRarity] = 2; CaseAwards[9][6][aType] = 2; CaseAwards[9][6][aInternalId] = 1; CaseAwards[9][6][aCount] = 900000; CaseAwards[9][6][aPriceSprayed] = 0; CaseAwards[9][6][aSubcount] = 0;
    CaseAwards[9][7][aId] = 8; CaseAwards[9][7][aRarity] = 2; CaseAwards[9][7][aType] = 11; CaseAwards[9][7][aInternalId] = 134; CaseAwards[9][7][aCount] = 11917; CaseAwards[9][7][aPriceSprayed] = 110; CaseAwards[9][7][aSubcount] = 0;
    CaseAwards[9][8][aId] = 9; CaseAwards[9][8][aRarity] = 2; CaseAwards[9][8][aType] = 10; CaseAwards[9][8][aInternalId] = 1; CaseAwards[9][8][aCount] = 6000; CaseAwards[9][8][aPriceSprayed] = 0; CaseAwards[9][8][aSubcount] = 0;
    CaseAwards[9][9][aId] = 10; CaseAwards[9][9][aRarity] = 2; CaseAwards[9][9][aType] = 5; CaseAwards[9][9][aInternalId] = 2568; CaseAwards[9][9][aCount] = 0; CaseAwards[9][9][aPriceSprayed] = 110; CaseAwards[9][9][aSubcount] = 0;
    CaseAwards[9][10][aId] = 11; CaseAwards[9][10][aRarity] = 2; CaseAwards[9][10][aType] = 11; CaseAwards[9][10][aInternalId] = 970; CaseAwards[9][10][aCount] = 1; CaseAwards[9][10][aPriceSprayed] = 120; CaseAwards[9][10][aSubcount] = 0;
    CaseAwards[9][11][aId] = 12; CaseAwards[9][11][aRarity] = 2; CaseAwards[9][11][aType] = 11; CaseAwards[9][11][aInternalId] = 134; CaseAwards[9][11][aCount] = 14388; CaseAwards[9][11][aPriceSprayed] = 100; CaseAwards[9][11][aSubcount] = 0;
    CaseAwards[9][12][aId] = 13; CaseAwards[9][12][aRarity] = 3; CaseAwards[9][12][aType] = 11; CaseAwards[9][12][aInternalId] = 134; CaseAwards[9][12][aCount] = 6895; CaseAwards[9][12][aPriceSprayed] = 140; CaseAwards[9][12][aSubcount] = 0;
    CaseAwards[9][13][aId] = 14; CaseAwards[9][13][aRarity] = 3; CaseAwards[9][13][aType] = 5; CaseAwards[9][13][aInternalId] = 603; CaseAwards[9][13][aCount] = 0; CaseAwards[9][13][aPriceSprayed] = 140; CaseAwards[9][13][aSubcount] = 0;
    CaseAwards[9][14][aId] = 15; CaseAwards[9][14][aRarity] = 3; CaseAwards[9][14][aType] = 10; CaseAwards[9][14][aInternalId] = 1; CaseAwards[9][14][aCount] = 7000; CaseAwards[9][14][aPriceSprayed] = 0; CaseAwards[9][14][aSubcount] = 0;
    CaseAwards[9][15][aId] = 16; CaseAwards[9][15][aRarity] = 3; CaseAwards[9][15][aType] = 5; CaseAwards[9][15][aInternalId] = 2382; CaseAwards[9][15][aCount] = 0; CaseAwards[9][15][aPriceSprayed] = 180; CaseAwards[9][15][aSubcount] = 0;
    CaseAwards[9][16][aId] = 17; CaseAwards[9][16][aRarity] = 3; CaseAwards[9][16][aType] = 2; CaseAwards[9][16][aInternalId] = 1; CaseAwards[9][16][aCount] = 1200000; CaseAwards[9][16][aPriceSprayed] = 0; CaseAwards[9][16][aSubcount] = 0;
    CaseAwards[9][17][aId] = 18; CaseAwards[9][17][aRarity] = 4; CaseAwards[9][17][aType] = 11; CaseAwards[9][17][aInternalId] = 134; CaseAwards[9][17][aCount] = 5898; CaseAwards[9][17][aPriceSprayed] = 230; CaseAwards[9][17][aSubcount] = 0;
    CaseAwards[9][18][aId] = 19; CaseAwards[9][18][aRarity] = 4; CaseAwards[9][18][aType] = 5; CaseAwards[9][18][aInternalId] = 503; CaseAwards[9][18][aCount] = 0; CaseAwards[9][18][aPriceSprayed] = 230; CaseAwards[9][18][aSubcount] = 0;
    CaseAwards[9][19][aId] = 20; CaseAwards[9][19][aRarity] = 3; CaseAwards[9][19][aType] = 10; CaseAwards[9][19][aInternalId] = 1; CaseAwards[9][19][aCount] = 10000; CaseAwards[9][19][aPriceSprayed] = 0; CaseAwards[9][19][aSubcount] = 0;
    CaseAwards[9][20][aId] = 21; CaseAwards[9][20][aRarity] = 4; CaseAwards[9][20][aType] = 5; CaseAwards[9][20][aInternalId] = 2617; CaseAwards[9][20][aCount] = 0; CaseAwards[9][20][aPriceSprayed] = 340; CaseAwards[9][20][aSubcount] = 0;
    CaseAwards[9][21][aId] = 22; CaseAwards[9][21][aRarity] = 4; CaseAwards[9][21][aType] = 5; CaseAwards[9][21][aInternalId] = 502; CaseAwards[9][21][aCount] = 0; CaseAwards[9][21][aPriceSprayed] = 260; CaseAwards[9][21][aSubcount] = 0;
    CaseAwards[9][22][aId] = 23; CaseAwards[9][22][aRarity] = 4; CaseAwards[9][22][aType] = 5; CaseAwards[9][22][aInternalId] = 429; CaseAwards[9][22][aCount] = 0; CaseAwards[9][22][aPriceSprayed] = 330; CaseAwards[9][22][aSubcount] = 0;
    CaseAwards[9][23][aId] = 24; CaseAwards[9][23][aRarity] = 5; CaseAwards[9][23][aType] = 5; CaseAwards[9][23][aInternalId] = 470; CaseAwards[9][23][aCount] = 0; CaseAwards[9][23][aPriceSprayed] = 700; CaseAwards[9][23][aSubcount] = 0;
    CaseAwards[9][24][aId] = 25; CaseAwards[9][24][aRarity] = 5; CaseAwards[9][24][aType] = 5; CaseAwards[9][24][aInternalId] = 758; CaseAwards[9][24][aCount] = 0; CaseAwards[9][24][aPriceSprayed] = 390; CaseAwards[9][24][aSubcount] = 68;
    CaseBonus[9][0][bId] = 1; CaseBonus[9][0][bNumberOpen] = 40; CaseBonus[9][0][bRarity] = 5; CaseBonus[9][0][bType] = 5; CaseBonus[9][0][bInternalId] = 614; CaseBonus[9][0][bCount] = 0; CaseBonus[9][0][bPriceSprayed] = 330;
    CaseBonus[9][1][bId] = 2; CaseBonus[9][1][bNumberOpen] = 30; CaseBonus[9][1][bRarity] = 4; CaseBonus[9][1][bType] = 21; CaseBonus[9][1][bInternalId] = 1; CaseBonus[9][1][bCount] = 400; CaseBonus[9][1][bPriceSprayed] = 0;
    CaseBonus[9][2][bId] = 3; CaseBonus[9][2][bNumberOpen] = 20; CaseBonus[9][2][bRarity] = 4; CaseBonus[9][2][bType] = 4; CaseBonus[9][2][bInternalId] = 10; CaseBonus[9][2][bCount] = 2; CaseBonus[9][2][bPriceSprayed] = 0;
    CaseBonus[9][3][bId] = 4; CaseBonus[9][3][bNumberOpen] = 10; CaseBonus[9][3][bRarity] = 4; CaseBonus[9][3][bType] = 21; CaseBonus[9][3][bInternalId] = 1; CaseBonus[9][3][bCount] = 300; CaseBonus[9][3][bPriceSprayed] = 0;
    CaseBonus[9][4][bId] = 5; CaseBonus[9][4][bNumberOpen] = 5; CaseBonus[9][4][bRarity] = 4; CaseBonus[9][4][bType] = 4; CaseBonus[9][4][bInternalId] = 10; CaseBonus[9][4][bCount] = 1; CaseBonus[9][4][bPriceSprayed] = 0;

    // case json id 11
    CaseData[10][cId] = 11;
    CaseData[10][cPriceOne] = 900;
    CaseData[10][cPriceTen] = 9000;
    CaseData[10][cDiscountOne] = 0;
    CaseData[10][cDiscountTen] = 5;
    CaseData[10][cAwardsCount] = 25;
    CaseData[10][cBonusCount] = 5;
    CaseAwards[10][0][aId] = 1; CaseAwards[10][0][aRarity] = 2; CaseAwards[10][0][aType] = 11; CaseAwards[10][0][aInternalId] = 134; CaseAwards[10][0][aCount] = 14388; CaseAwards[10][0][aPriceSprayed] = 100; CaseAwards[10][0][aSubcount] = 0;
    CaseAwards[10][1][aId] = 2; CaseAwards[10][1][aRarity] = 2; CaseAwards[10][1][aType] = 11; CaseAwards[10][1][aInternalId] = 360; CaseAwards[10][1][aCount] = 1; CaseAwards[10][1][aPriceSprayed] = 100; CaseAwards[10][1][aSubcount] = 0;
    CaseAwards[10][2][aId] = 3; CaseAwards[10][2][aRarity] = 2; CaseAwards[10][2][aType] = 11; CaseAwards[10][2][aInternalId] = 295; CaseAwards[10][2][aCount] = 1; CaseAwards[10][2][aPriceSprayed] = 80; CaseAwards[10][2][aSubcount] = 0;
    CaseAwards[10][3][aId] = 4; CaseAwards[10][3][aRarity] = 2; CaseAwards[10][3][aType] = 11; CaseAwards[10][3][aInternalId] = 709; CaseAwards[10][3][aCount] = 1; CaseAwards[10][3][aPriceSprayed] = 100; CaseAwards[10][3][aSubcount] = 0;
    CaseAwards[10][4][aId] = 5; CaseAwards[10][4][aRarity] = 3; CaseAwards[10][4][aType] = 11; CaseAwards[10][4][aInternalId] = 979; CaseAwards[10][4][aCount] = 1; CaseAwards[10][4][aPriceSprayed] = 140; CaseAwards[10][4][aSubcount] = 0;
    CaseAwards[10][5][aId] = 6; CaseAwards[10][5][aRarity] = 2; CaseAwards[10][5][aType] = 3; CaseAwards[10][5][aInternalId] = 1; CaseAwards[10][5][aCount] = 800; CaseAwards[10][5][aPriceSprayed] = 0; CaseAwards[10][5][aSubcount] = 0;
    CaseAwards[10][6][aId] = 7; CaseAwards[10][6][aRarity] = 2; CaseAwards[10][6][aType] = 2; CaseAwards[10][6][aInternalId] = 1; CaseAwards[10][6][aCount] = 900000; CaseAwards[10][6][aPriceSprayed] = 0; CaseAwards[10][6][aSubcount] = 0;
    CaseAwards[10][7][aId] = 8; CaseAwards[10][7][aRarity] = 2; CaseAwards[10][7][aType] = 11; CaseAwards[10][7][aInternalId] = 134; CaseAwards[10][7][aCount] = 252; CaseAwards[10][7][aPriceSprayed] = 110; CaseAwards[10][7][aSubcount] = 0;
    CaseAwards[10][8][aId] = 9; CaseAwards[10][8][aRarity] = 2; CaseAwards[10][8][aType] = 23; CaseAwards[10][8][aInternalId] = 1; CaseAwards[10][8][aCount] = 3000; CaseAwards[10][8][aPriceSprayed] = 0; CaseAwards[10][8][aSubcount] = 0;
    CaseAwards[10][9][aId] = 10; CaseAwards[10][9][aRarity] = 2; CaseAwards[10][9][aType] = 5; CaseAwards[10][9][aInternalId] = 2568; CaseAwards[10][9][aCount] = 0; CaseAwards[10][9][aPriceSprayed] = 110; CaseAwards[10][9][aSubcount] = 0;
    CaseAwards[10][10][aId] = 11; CaseAwards[10][10][aRarity] = 2; CaseAwards[10][10][aType] = 11; CaseAwards[10][10][aInternalId] = 978; CaseAwards[10][10][aCount] = 1; CaseAwards[10][10][aPriceSprayed] = 220; CaseAwards[10][10][aSubcount] = 0;
    CaseAwards[10][11][aId] = 12; CaseAwards[10][11][aRarity] = 2; CaseAwards[10][11][aType] = 11; CaseAwards[10][11][aInternalId] = 134; CaseAwards[10][11][aCount] = 7773; CaseAwards[10][11][aPriceSprayed] = 140; CaseAwards[10][11][aSubcount] = 0;
    CaseAwards[10][12][aId] = 13; CaseAwards[10][12][aRarity] = 3; CaseAwards[10][12][aType] = 11; CaseAwards[10][12][aInternalId] = 134; CaseAwards[10][12][aCount] = 19262; CaseAwards[10][12][aPriceSprayed] = 140; CaseAwards[10][12][aSubcount] = 0;
    CaseAwards[10][13][aId] = 14; CaseAwards[10][13][aRarity] = 3; CaseAwards[10][13][aType] = 5; CaseAwards[10][13][aInternalId] = 603; CaseAwards[10][13][aCount] = 0; CaseAwards[10][13][aPriceSprayed] = 140; CaseAwards[10][13][aSubcount] = 0;
    CaseAwards[10][14][aId] = 15; CaseAwards[10][14][aRarity] = 3; CaseAwards[10][14][aType] = 23; CaseAwards[10][14][aInternalId] = 1; CaseAwards[10][14][aCount] = 7500; CaseAwards[10][14][aPriceSprayed] = 0; CaseAwards[10][14][aSubcount] = 0;
    CaseAwards[10][15][aId] = 16; CaseAwards[10][15][aRarity] = 3; CaseAwards[10][15][aType] = 5; CaseAwards[10][15][aInternalId] = 442; CaseAwards[10][15][aCount] = 0; CaseAwards[10][15][aPriceSprayed] = 170; CaseAwards[10][15][aSubcount] = 0;
    CaseAwards[10][16][aId] = 17; CaseAwards[10][16][aRarity] = 3; CaseAwards[10][16][aType] = 23; CaseAwards[10][16][aInternalId] = 1; CaseAwards[10][16][aCount] = 5000; CaseAwards[10][16][aPriceSprayed] = 0; CaseAwards[10][16][aSubcount] = 0;
    CaseAwards[10][17][aId] = 18; CaseAwards[10][17][aRarity] = 4; CaseAwards[10][17][aType] = 11; CaseAwards[10][17][aInternalId] = 134; CaseAwards[10][17][aCount] = 7772; CaseAwards[10][17][aPriceSprayed] = 230; CaseAwards[10][17][aSubcount] = 0;
    CaseAwards[10][18][aId] = 19; CaseAwards[10][18][aRarity] = 4; CaseAwards[10][18][aType] = 5; CaseAwards[10][18][aInternalId] = 503; CaseAwards[10][18][aCount] = 0; CaseAwards[10][18][aPriceSprayed] = 230; CaseAwards[10][18][aSubcount] = 0;
    CaseAwards[10][19][aId] = 20; CaseAwards[10][19][aRarity] = 4; CaseAwards[10][19][aType] = 23; CaseAwards[10][19][aInternalId] = 1; CaseAwards[10][19][aCount] = 15000; CaseAwards[10][19][aPriceSprayed] = 0; CaseAwards[10][19][aSubcount] = 0;
    CaseAwards[10][20][aId] = 21; CaseAwards[10][20][aRarity] = 4; CaseAwards[10][20][aType] = 5; CaseAwards[10][20][aInternalId] = 505; CaseAwards[10][20][aCount] = 0; CaseAwards[10][20][aPriceSprayed] = 240; CaseAwards[10][20][aSubcount] = 0;
    CaseAwards[10][21][aId] = 22; CaseAwards[10][21][aRarity] = 4; CaseAwards[10][21][aType] = 5; CaseAwards[10][21][aInternalId] = 502; CaseAwards[10][21][aCount] = 0; CaseAwards[10][21][aPriceSprayed] = 260; CaseAwards[10][21][aSubcount] = 0;
    CaseAwards[10][22][aId] = 23; CaseAwards[10][22][aRarity] = 4; CaseAwards[10][22][aType] = 5; CaseAwards[10][22][aInternalId] = 490; CaseAwards[10][22][aCount] = 0; CaseAwards[10][22][aPriceSprayed] = 290; CaseAwards[10][22][aSubcount] = 0;
    CaseAwards[10][23][aId] = 24; CaseAwards[10][23][aRarity] = 3; CaseAwards[10][23][aType] = 5; CaseAwards[10][23][aInternalId] = 2392; CaseAwards[10][23][aCount] = 0; CaseAwards[10][23][aPriceSprayed] = 220; CaseAwards[10][23][aSubcount] = 69;
    CaseAwards[10][24][aId] = 25; CaseAwards[10][24][aRarity] = 5; CaseAwards[10][24][aType] = 5; CaseAwards[10][24][aInternalId] = 772; CaseAwards[10][24][aCount] = 0; CaseAwards[10][24][aPriceSprayed] = 670; CaseAwards[10][24][aSubcount] = 71;
    CaseBonus[10][0][bId] = 1; CaseBonus[10][0][bNumberOpen] = 40; CaseBonus[10][0][bRarity] = 5; CaseBonus[10][0][bType] = 5; CaseBonus[10][0][bInternalId] = 438; CaseBonus[10][0][bCount] = 0; CaseBonus[10][0][bPriceSprayed] = 320;
    CaseBonus[10][1][bId] = 2; CaseBonus[10][1][bNumberOpen] = 30; CaseBonus[10][1][bRarity] = 4; CaseBonus[10][1][bType] = 23; CaseBonus[10][1][bInternalId] = 1; CaseBonus[10][1][bCount] = 10000; CaseBonus[10][1][bPriceSprayed] = 0;
    CaseBonus[10][2][bId] = 3; CaseBonus[10][2][bNumberOpen] = 20; CaseBonus[10][2][bRarity] = 4; CaseBonus[10][2][bType] = 4; CaseBonus[10][2][bInternalId] = 11; CaseBonus[10][2][bCount] = 2; CaseBonus[10][2][bPriceSprayed] = 0;
    CaseBonus[10][3][bId] = 4; CaseBonus[10][3][bNumberOpen] = 10; CaseBonus[10][3][bRarity] = 4; CaseBonus[10][3][bType] = 23; CaseBonus[10][3][bInternalId] = 1; CaseBonus[10][3][bCount] = 5000; CaseBonus[10][3][bPriceSprayed] = 0;
    CaseBonus[10][4][bId] = 5; CaseBonus[10][4][bNumberOpen] = 5; CaseBonus[10][4][bRarity] = 4; CaseBonus[10][4][bType] = 4; CaseBonus[10][4][bInternalId] = 11; CaseBonus[10][4][bCount] = 1; CaseBonus[10][4][bPriceSprayed] = 0;

    // case json id 12
    CaseData[11][cId] = 12;
    CaseData[11][cPriceOne] = 900;
    CaseData[11][cPriceTen] = 9000;
    CaseData[11][cDiscountOne] = 0;
    CaseData[11][cDiscountTen] = 5;
    CaseData[11][cAwardsCount] = 25;
    CaseData[11][cBonusCount] = 5;
    CaseAwards[11][0][aId] = 1; CaseAwards[11][0][aRarity] = 2; CaseAwards[11][0][aType] = 11; CaseAwards[11][0][aInternalId] = 134; CaseAwards[11][0][aCount] = 11961; CaseAwards[11][0][aPriceSprayed] = 120; CaseAwards[11][0][aSubcount] = 0;
    CaseAwards[11][1][aId] = 2; CaseAwards[11][1][aRarity] = 2; CaseAwards[11][1][aType] = 11; CaseAwards[11][1][aInternalId] = 360; CaseAwards[11][1][aCount] = 1; CaseAwards[11][1][aPriceSprayed] = 100; CaseAwards[11][1][aSubcount] = 0;
    CaseAwards[11][2][aId] = 3; CaseAwards[11][2][aRarity] = 2; CaseAwards[11][2][aType] = 11; CaseAwards[11][2][aInternalId] = 915; CaseAwards[11][2][aCount] = 1; CaseAwards[11][2][aPriceSprayed] = 120; CaseAwards[11][2][aSubcount] = 0;
    CaseAwards[11][3][aId] = 4; CaseAwards[11][3][aRarity] = 2; CaseAwards[11][3][aType] = 11; CaseAwards[11][3][aInternalId] = 916; CaseAwards[11][3][aCount] = 1; CaseAwards[11][3][aPriceSprayed] = 100; CaseAwards[11][3][aSubcount] = 0;
    CaseAwards[11][4][aId] = 5; CaseAwards[11][4][aRarity] = 3; CaseAwards[11][4][aType] = 11; CaseAwards[11][4][aInternalId] = 990; CaseAwards[11][4][aCount] = 1; CaseAwards[11][4][aPriceSprayed] = 140; CaseAwards[11][4][aSubcount] = 0;
    CaseAwards[11][5][aId] = 6; CaseAwards[11][5][aRarity] = 2; CaseAwards[11][5][aType] = 3; CaseAwards[11][5][aInternalId] = 1; CaseAwards[11][5][aCount] = 800; CaseAwards[11][5][aPriceSprayed] = 0; CaseAwards[11][5][aSubcount] = 0;
    CaseAwards[11][6][aId] = 7; CaseAwards[11][6][aRarity] = 2; CaseAwards[11][6][aType] = 2; CaseAwards[11][6][aInternalId] = 1; CaseAwards[11][6][aCount] = 900000; CaseAwards[11][6][aPriceSprayed] = 0; CaseAwards[11][6][aSubcount] = 0;
    CaseAwards[11][7][aId] = 8; CaseAwards[11][7][aRarity] = 2; CaseAwards[11][7][aType] = 11; CaseAwards[11][7][aInternalId] = 134; CaseAwards[11][7][aCount] = 252; CaseAwards[11][7][aPriceSprayed] = 110; CaseAwards[11][7][aSubcount] = 0;
    CaseAwards[11][8][aId] = 9; CaseAwards[11][8][aRarity] = 2; CaseAwards[11][8][aType] = 23; CaseAwards[11][8][aInternalId] = 1; CaseAwards[11][8][aCount] = 3000; CaseAwards[11][8][aPriceSprayed] = 0; CaseAwards[11][8][aSubcount] = 0;
    CaseAwards[11][9][aId] = 10; CaseAwards[11][9][aRarity] = 2; CaseAwards[11][9][aType] = 5; CaseAwards[11][9][aInternalId] = 2568; CaseAwards[11][9][aCount] = 0; CaseAwards[11][9][aPriceSprayed] = 110; CaseAwards[11][9][aSubcount] = 0;
    CaseAwards[11][10][aId] = 11; CaseAwards[11][10][aRarity] = 4; CaseAwards[11][10][aType] = 11; CaseAwards[11][10][aInternalId] = 991; CaseAwards[11][10][aCount] = 1; CaseAwards[11][10][aPriceSprayed] = 220; CaseAwards[11][10][aSubcount] = 0;
    CaseAwards[11][11][aId] = 12; CaseAwards[11][11][aRarity] = 3; CaseAwards[11][11][aType] = 11; CaseAwards[11][11][aInternalId] = 134; CaseAwards[11][11][aCount] = 5500008; CaseAwards[11][11][aPriceSprayed] = 140; CaseAwards[11][11][aSubcount] = 0;
    CaseAwards[11][12][aId] = 13; CaseAwards[11][12][aRarity] = 3; CaseAwards[11][12][aType] = 11; CaseAwards[11][12][aInternalId] = 134; CaseAwards[11][12][aCount] = 6893; CaseAwards[11][12][aPriceSprayed] = 140; CaseAwards[11][12][aSubcount] = 0;
    CaseAwards[11][13][aId] = 14; CaseAwards[11][13][aRarity] = 3; CaseAwards[11][13][aType] = 5; CaseAwards[11][13][aInternalId] = 603; CaseAwards[11][13][aCount] = 0; CaseAwards[11][13][aPriceSprayed] = 140; CaseAwards[11][13][aSubcount] = 0;
    CaseAwards[11][14][aId] = 15; CaseAwards[11][14][aRarity] = 3; CaseAwards[11][14][aType] = 23; CaseAwards[11][14][aInternalId] = 1; CaseAwards[11][14][aCount] = 7500; CaseAwards[11][14][aPriceSprayed] = 0; CaseAwards[11][14][aSubcount] = 0;
    CaseAwards[11][15][aId] = 16; CaseAwards[11][15][aRarity] = 3; CaseAwards[11][15][aType] = 5; CaseAwards[11][15][aInternalId] = 442; CaseAwards[11][15][aCount] = 0; CaseAwards[11][15][aPriceSprayed] = 170; CaseAwards[11][15][aSubcount] = 0;
    CaseAwards[11][16][aId] = 17; CaseAwards[11][16][aRarity] = 3; CaseAwards[11][16][aType] = 23; CaseAwards[11][16][aInternalId] = 1; CaseAwards[11][16][aCount] = 5000; CaseAwards[11][16][aPriceSprayed] = 0; CaseAwards[11][16][aSubcount] = 0;
    CaseAwards[11][17][aId] = 18; CaseAwards[11][17][aRarity] = 4; CaseAwards[11][17][aType] = 11; CaseAwards[11][17][aInternalId] = 134; CaseAwards[11][17][aCount] = 5500007; CaseAwards[11][17][aPriceSprayed] = 230; CaseAwards[11][17][aSubcount] = 0;
    CaseAwards[11][18][aId] = 19; CaseAwards[11][18][aRarity] = 4; CaseAwards[11][18][aType] = 5; CaseAwards[11][18][aInternalId] = 503; CaseAwards[11][18][aCount] = 0; CaseAwards[11][18][aPriceSprayed] = 230; CaseAwards[11][18][aSubcount] = 0;
    CaseAwards[11][19][aId] = 20; CaseAwards[11][19][aRarity] = 4; CaseAwards[11][19][aType] = 23; CaseAwards[11][19][aInternalId] = 1; CaseAwards[11][19][aCount] = 15000; CaseAwards[11][19][aPriceSprayed] = 0; CaseAwards[11][19][aSubcount] = 0;
    CaseAwards[11][20][aId] = 21; CaseAwards[11][20][aRarity] = 4; CaseAwards[11][20][aType] = 5; CaseAwards[11][20][aInternalId] = 622; CaseAwards[11][20][aCount] = 0; CaseAwards[11][20][aPriceSprayed] = 240; CaseAwards[11][20][aSubcount] = 0;
    CaseAwards[11][21][aId] = 22; CaseAwards[11][21][aRarity] = 4; CaseAwards[11][21][aType] = 5; CaseAwards[11][21][aInternalId] = 502; CaseAwards[11][21][aCount] = 0; CaseAwards[11][21][aPriceSprayed] = 260; CaseAwards[11][21][aSubcount] = 0;
    CaseAwards[11][22][aId] = 23; CaseAwards[11][22][aRarity] = 4; CaseAwards[11][22][aType] = 5; CaseAwards[11][22][aInternalId] = 2582; CaseAwards[11][22][aCount] = 0; CaseAwards[11][22][aPriceSprayed] = 290; CaseAwards[11][22][aSubcount] = 0;
    CaseAwards[11][23][aId] = 24; CaseAwards[11][23][aRarity] = 3; CaseAwards[11][23][aType] = 5; CaseAwards[11][23][aInternalId] = 28662; CaseAwards[11][23][aCount] = 0; CaseAwards[11][23][aPriceSprayed] = 200; CaseAwards[11][23][aSubcount] = 98;
    CaseAwards[11][24][aId] = 25; CaseAwards[11][24][aRarity] = 5; CaseAwards[11][24][aType] = 5; CaseAwards[11][24][aInternalId] = 28661; CaseAwards[11][24][aCount] = 0; CaseAwards[11][24][aPriceSprayed] = 670; CaseAwards[11][24][aSubcount] = 97;
    CaseBonus[11][0][bId] = 1; CaseBonus[11][0][bNumberOpen] = 40; CaseBonus[11][0][bRarity] = 5; CaseBonus[11][0][bType] = 5; CaseBonus[11][0][bInternalId] = 28663; CaseBonus[11][0][bCount] = 0; CaseBonus[11][0][bPriceSprayed] = 320;
    CaseBonus[11][1][bId] = 2; CaseBonus[11][1][bNumberOpen] = 30; CaseBonus[11][1][bRarity] = 4; CaseBonus[11][1][bType] = 23; CaseBonus[11][1][bInternalId] = 1; CaseBonus[11][1][bCount] = 10000; CaseBonus[11][1][bPriceSprayed] = 0;
    CaseBonus[11][2][bId] = 3; CaseBonus[11][2][bNumberOpen] = 20; CaseBonus[11][2][bRarity] = 4; CaseBonus[11][2][bType] = 4; CaseBonus[11][2][bInternalId] = 12; CaseBonus[11][2][bCount] = 2; CaseBonus[11][2][bPriceSprayed] = 0;
    CaseBonus[11][3][bId] = 4; CaseBonus[11][3][bNumberOpen] = 10; CaseBonus[11][3][bRarity] = 4; CaseBonus[11][3][bType] = 23; CaseBonus[11][3][bInternalId] = 1; CaseBonus[11][3][bCount] = 5000; CaseBonus[11][3][bPriceSprayed] = 0;
    CaseBonus[11][4][bId] = 5; CaseBonus[11][4][bNumberOpen] = 5; CaseBonus[11][4][bRarity] = 4; CaseBonus[11][4][bType] = 4; CaseBonus[11][4][bInternalId] = 12; CaseBonus[11][4][bCount] = 1; CaseBonus[11][4][bPriceSprayed] = 0;

    // case json id 13
    CaseData[12][cId] = 13;
    CaseData[12][cPriceOne] = 900;
    CaseData[12][cPriceTen] = 9000;
    CaseData[12][cDiscountOne] = 0;
    CaseData[12][cDiscountTen] = 5;
    CaseData[12][cAwardsCount] = 25;
    CaseData[12][cBonusCount] = 5;
    CaseAwards[12][0][aId] = 1; CaseAwards[12][0][aRarity] = 2; CaseAwards[12][0][aType] = 11; CaseAwards[12][0][aInternalId] = 134; CaseAwards[12][0][aCount] = 11917; CaseAwards[12][0][aPriceSprayed] = 110; CaseAwards[12][0][aSubcount] = 0;
    CaseAwards[12][1][aId] = 2; CaseAwards[12][1][aRarity] = 4; CaseAwards[12][1][aType] = 11; CaseAwards[12][1][aInternalId] = 919; CaseAwards[12][1][aCount] = 1; CaseAwards[12][1][aPriceSprayed] = 230; CaseAwards[12][1][aSubcount] = 0;
    CaseAwards[12][2][aId] = 3; CaseAwards[12][2][aRarity] = 2; CaseAwards[12][2][aType] = 11; CaseAwards[12][2][aInternalId] = 917; CaseAwards[12][2][aCount] = 1; CaseAwards[12][2][aPriceSprayed] = 100; CaseAwards[12][2][aSubcount] = 0;
    CaseAwards[12][3][aId] = 4; CaseAwards[12][3][aRarity] = 2; CaseAwards[12][3][aType] = 11; CaseAwards[12][3][aInternalId] = 159; CaseAwards[12][3][aCount] = 1; CaseAwards[12][3][aPriceSprayed] = 90; CaseAwards[12][3][aSubcount] = 0;
    CaseAwards[12][4][aId] = 5; CaseAwards[12][4][aRarity] = 4; CaseAwards[12][4][aType] = 11; CaseAwards[12][4][aInternalId] = 999; CaseAwards[12][4][aCount] = 1; CaseAwards[12][4][aPriceSprayed] = 240; CaseAwards[12][4][aSubcount] = 0;
    CaseAwards[12][5][aId] = 6; CaseAwards[12][5][aRarity] = 2; CaseAwards[12][5][aType] = 3; CaseAwards[12][5][aInternalId] = 1; CaseAwards[12][5][aCount] = 800; CaseAwards[12][5][aPriceSprayed] = 0; CaseAwards[12][5][aSubcount] = 0;
    CaseAwards[12][6][aId] = 7; CaseAwards[12][6][aRarity] = 2; CaseAwards[12][6][aType] = 2; CaseAwards[12][6][aInternalId] = 1; CaseAwards[12][6][aCount] = 900000; CaseAwards[12][6][aPriceSprayed] = 0; CaseAwards[12][6][aSubcount] = 0;
    CaseAwards[12][7][aId] = 8; CaseAwards[12][7][aRarity] = 2; CaseAwards[12][7][aType] = 11; CaseAwards[12][7][aInternalId] = 134; CaseAwards[12][7][aCount] = 252; CaseAwards[12][7][aPriceSprayed] = 110; CaseAwards[12][7][aSubcount] = 0;
    CaseAwards[12][8][aId] = 9; CaseAwards[12][8][aRarity] = 2; CaseAwards[12][8][aType] = 23; CaseAwards[12][8][aInternalId] = 1; CaseAwards[12][8][aCount] = 3000; CaseAwards[12][8][aPriceSprayed] = 0; CaseAwards[12][8][aSubcount] = 0;
    CaseAwards[12][9][aId] = 10; CaseAwards[12][9][aRarity] = 2; CaseAwards[12][9][aType] = 5; CaseAwards[12][9][aInternalId] = 2568; CaseAwards[12][9][aCount] = 0; CaseAwards[12][9][aPriceSprayed] = 110; CaseAwards[12][9][aSubcount] = 0;
    CaseAwards[12][10][aId] = 11; CaseAwards[12][10][aRarity] = 3; CaseAwards[12][10][aType] = 11; CaseAwards[12][10][aInternalId] = 1000; CaseAwards[12][10][aCount] = 1; CaseAwards[12][10][aPriceSprayed] = 160; CaseAwards[12][10][aSubcount] = 0;
    CaseAwards[12][11][aId] = 12; CaseAwards[12][11][aRarity] = 4; CaseAwards[12][11][aType] = 11; CaseAwards[12][11][aInternalId] = 1001; CaseAwards[12][11][aCount] = 1; CaseAwards[12][11][aPriceSprayed] = 220; CaseAwards[12][11][aSubcount] = 0;
    CaseAwards[12][12][aId] = 13; CaseAwards[12][12][aRarity] = 3; CaseAwards[12][12][aType] = 11; CaseAwards[12][12][aInternalId] = 134; CaseAwards[12][12][aCount] = 5500025; CaseAwards[12][12][aPriceSprayed] = 160; CaseAwards[12][12][aSubcount] = 0;
    CaseAwards[12][13][aId] = 14; CaseAwards[12][13][aRarity] = 3; CaseAwards[12][13][aType] = 5; CaseAwards[12][13][aInternalId] = 603; CaseAwards[12][13][aCount] = 0; CaseAwards[12][13][aPriceSprayed] = 140; CaseAwards[12][13][aSubcount] = 0;
    CaseAwards[12][14][aId] = 15; CaseAwards[12][14][aRarity] = 3; CaseAwards[12][14][aType] = 23; CaseAwards[12][14][aInternalId] = 1; CaseAwards[12][14][aCount] = 7500; CaseAwards[12][14][aPriceSprayed] = 0; CaseAwards[12][14][aSubcount] = 0;
    CaseAwards[12][15][aId] = 16; CaseAwards[12][15][aRarity] = 3; CaseAwards[12][15][aType] = 5; CaseAwards[12][15][aInternalId] = 442; CaseAwards[12][15][aCount] = 0; CaseAwards[12][15][aPriceSprayed] = 170; CaseAwards[12][15][aSubcount] = 0;
    CaseAwards[12][16][aId] = 17; CaseAwards[12][16][aRarity] = 3; CaseAwards[12][16][aType] = 23; CaseAwards[12][16][aInternalId] = 1; CaseAwards[12][16][aCount] = 5000; CaseAwards[12][16][aPriceSprayed] = 0; CaseAwards[12][16][aSubcount] = 0;
    CaseAwards[12][17][aId] = 18; CaseAwards[12][17][aRarity] = 4; CaseAwards[12][17][aType] = 11; CaseAwards[12][17][aInternalId] = 134; CaseAwards[12][17][aCount] = 5500026; CaseAwards[12][17][aPriceSprayed] = 230; CaseAwards[12][17][aSubcount] = 0;
    CaseAwards[12][18][aId] = 19; CaseAwards[12][18][aRarity] = 4; CaseAwards[12][18][aType] = 5; CaseAwards[12][18][aInternalId] = 503; CaseAwards[12][18][aCount] = 0; CaseAwards[12][18][aPriceSprayed] = 230; CaseAwards[12][18][aSubcount] = 0;
    CaseAwards[12][19][aId] = 20; CaseAwards[12][19][aRarity] = 4; CaseAwards[12][19][aType] = 23; CaseAwards[12][19][aInternalId] = 1; CaseAwards[12][19][aCount] = 15000; CaseAwards[12][19][aPriceSprayed] = 0; CaseAwards[12][19][aSubcount] = 0;
    CaseAwards[12][20][aId] = 21; CaseAwards[12][20][aRarity] = 4; CaseAwards[12][20][aType] = 5; CaseAwards[12][20][aInternalId] = 622; CaseAwards[12][20][aCount] = 0; CaseAwards[12][20][aPriceSprayed] = 240; CaseAwards[12][20][aSubcount] = 0;
    CaseAwards[12][21][aId] = 22; CaseAwards[12][21][aRarity] = 4; CaseAwards[12][21][aType] = 5; CaseAwards[12][21][aInternalId] = 502; CaseAwards[12][21][aCount] = 0; CaseAwards[12][21][aPriceSprayed] = 260; CaseAwards[12][21][aSubcount] = 0;
    CaseAwards[12][22][aId] = 23; CaseAwards[12][22][aRarity] = 4; CaseAwards[12][22][aType] = 5; CaseAwards[12][22][aInternalId] = 2582; CaseAwards[12][22][aCount] = 0; CaseAwards[12][22][aPriceSprayed] = 290; CaseAwards[12][22][aSubcount] = 0;
    CaseAwards[12][23][aId] = 24; CaseAwards[12][23][aRarity] = 3; CaseAwards[12][23][aType] = 5; CaseAwards[12][23][aInternalId] = 480; CaseAwards[12][23][aCount] = 0; CaseAwards[12][23][aPriceSprayed] = 210; CaseAwards[12][23][aSubcount] = 0;
    CaseAwards[12][24][aId] = 25; CaseAwards[12][24][aRarity] = 5; CaseAwards[12][24][aType] = 5; CaseAwards[12][24][aInternalId] = 28680; CaseAwards[12][24][aCount] = 0; CaseAwards[12][24][aPriceSprayed] = 570; CaseAwards[12][24][aSubcount] = 108;
    CaseBonus[12][0][bId] = 1; CaseBonus[12][0][bNumberOpen] = 40; CaseBonus[12][0][bRarity] = 5; CaseBonus[12][0][bType] = 5; CaseBonus[12][0][bInternalId] = 28681; CaseBonus[12][0][bCount] = 0; CaseBonus[12][0][bPriceSprayed] = 320;
    CaseBonus[12][1][bId] = 2; CaseBonus[12][1][bNumberOpen] = 30; CaseBonus[12][1][bRarity] = 4; CaseBonus[12][1][bType] = 23; CaseBonus[12][1][bInternalId] = 1; CaseBonus[12][1][bCount] = 10000; CaseBonus[12][1][bPriceSprayed] = 0;
    CaseBonus[12][2][bId] = 3; CaseBonus[12][2][bNumberOpen] = 20; CaseBonus[12][2][bRarity] = 4; CaseBonus[12][2][bType] = 4; CaseBonus[12][2][bInternalId] = 13; CaseBonus[12][2][bCount] = 2; CaseBonus[12][2][bPriceSprayed] = 0;
    CaseBonus[12][3][bId] = 4; CaseBonus[12][3][bNumberOpen] = 10; CaseBonus[12][3][bRarity] = 4; CaseBonus[12][3][bType] = 23; CaseBonus[12][3][bInternalId] = 1; CaseBonus[12][3][bCount] = 5000; CaseBonus[12][3][bPriceSprayed] = 0;
    CaseBonus[12][4][bId] = 5; CaseBonus[12][4][bNumberOpen] = 5; CaseBonus[12][4][bRarity] = 4; CaseBonus[12][4][bType] = 4; CaseBonus[12][4][bInternalId] = 13; CaseBonus[12][4][bCount] = 1; CaseBonus[12][4][bPriceSprayed] = 0;

    // case json id 14
    CaseData[13][cId] = 14;
    CaseData[13][cPriceOne] = 900;
    CaseData[13][cPriceTen] = 9000;
    CaseData[13][cDiscountOne] = 0;
    CaseData[13][cDiscountTen] = 5;
    CaseData[13][cAwardsCount] = 25;
    CaseData[13][cBonusCount] = 5;
    CaseAwards[13][0][aId] = 1; CaseAwards[13][0][aRarity] = 2; CaseAwards[13][0][aType] = 11; CaseAwards[13][0][aInternalId] = 134; CaseAwards[13][0][aCount] = 14388; CaseAwards[13][0][aPriceSprayed] = 100; CaseAwards[13][0][aSubcount] = 0;
    CaseAwards[13][1][aId] = 2; CaseAwards[13][1][aRarity] = 2; CaseAwards[13][1][aType] = 11; CaseAwards[13][1][aInternalId] = 924; CaseAwards[13][1][aCount] = 1; CaseAwards[13][1][aPriceSprayed] = 100; CaseAwards[13][1][aSubcount] = 0;
    CaseAwards[13][2][aId] = 3; CaseAwards[13][2][aRarity] = 2; CaseAwards[13][2][aType] = 11; CaseAwards[13][2][aInternalId] = 304; CaseAwards[13][2][aCount] = 1; CaseAwards[13][2][aPriceSprayed] = 90; CaseAwards[13][2][aSubcount] = 0;
    CaseAwards[13][3][aId] = 4; CaseAwards[13][3][aRarity] = 2; CaseAwards[13][3][aType] = 11; CaseAwards[13][3][aInternalId] = 159; CaseAwards[13][3][aCount] = 1; CaseAwards[13][3][aPriceSprayed] = 90; CaseAwards[13][3][aSubcount] = 0;
    CaseAwards[13][4][aId] = 5; CaseAwards[13][4][aRarity] = 4; CaseAwards[13][4][aType] = 11; CaseAwards[13][4][aInternalId] = 1002; CaseAwards[13][4][aCount] = 1; CaseAwards[13][4][aPriceSprayed] = 240; CaseAwards[13][4][aSubcount] = 0;
    CaseAwards[13][5][aId] = 6; CaseAwards[13][5][aRarity] = 2; CaseAwards[13][5][aType] = 3; CaseAwards[13][5][aInternalId] = 1; CaseAwards[13][5][aCount] = 800; CaseAwards[13][5][aPriceSprayed] = 0; CaseAwards[13][5][aSubcount] = 0;
    CaseAwards[13][6][aId] = 7; CaseAwards[13][6][aRarity] = 2; CaseAwards[13][6][aType] = 2; CaseAwards[13][6][aInternalId] = 1; CaseAwards[13][6][aCount] = 900000; CaseAwards[13][6][aPriceSprayed] = 0; CaseAwards[13][6][aSubcount] = 0;
    CaseAwards[13][7][aId] = 8; CaseAwards[13][7][aRarity] = 2; CaseAwards[13][7][aType] = 11; CaseAwards[13][7][aInternalId] = 134; CaseAwards[13][7][aCount] = 252; CaseAwards[13][7][aPriceSprayed] = 130; CaseAwards[13][7][aSubcount] = 0;
    CaseAwards[13][8][aId] = 9; CaseAwards[13][8][aRarity] = 2; CaseAwards[13][8][aType] = 23; CaseAwards[13][8][aInternalId] = 1; CaseAwards[13][8][aCount] = 3000; CaseAwards[13][8][aPriceSprayed] = 0; CaseAwards[13][8][aSubcount] = 0;
    CaseAwards[13][9][aId] = 10; CaseAwards[13][9][aRarity] = 2; CaseAwards[13][9][aType] = 5; CaseAwards[13][9][aInternalId] = 2568; CaseAwards[13][9][aCount] = 0; CaseAwards[13][9][aPriceSprayed] = 110; CaseAwards[13][9][aSubcount] = 0;
    CaseAwards[13][10][aId] = 11; CaseAwards[13][10][aRarity] = 3; CaseAwards[13][10][aType] = 11; CaseAwards[13][10][aInternalId] = 1003; CaseAwards[13][10][aCount] = 1; CaseAwards[13][10][aPriceSprayed] = 160; CaseAwards[13][10][aSubcount] = 0;
    CaseAwards[13][11][aId] = 12; CaseAwards[13][11][aRarity] = 3; CaseAwards[13][11][aType] = 11; CaseAwards[13][11][aInternalId] = 134; CaseAwards[13][11][aCount] = 5500028; CaseAwards[13][11][aPriceSprayed] = 160; CaseAwards[13][11][aSubcount] = 0;
    CaseAwards[13][12][aId] = 13; CaseAwards[13][12][aRarity] = 3; CaseAwards[13][12][aType] = 11; CaseAwards[13][12][aInternalId] = 134; CaseAwards[13][12][aCount] = 11935; CaseAwards[13][12][aPriceSprayed] = 140; CaseAwards[13][12][aSubcount] = 0;
    CaseAwards[13][13][aId] = 14; CaseAwards[13][13][aRarity] = 3; CaseAwards[13][13][aType] = 5; CaseAwards[13][13][aInternalId] = 603; CaseAwards[13][13][aCount] = 0; CaseAwards[13][13][aPriceSprayed] = 140; CaseAwards[13][13][aSubcount] = 0;
    CaseAwards[13][14][aId] = 15; CaseAwards[13][14][aRarity] = 3; CaseAwards[13][14][aType] = 23; CaseAwards[13][14][aInternalId] = 1; CaseAwards[13][14][aCount] = 7500; CaseAwards[13][14][aPriceSprayed] = 0; CaseAwards[13][14][aSubcount] = 0;
    CaseAwards[13][15][aId] = 16; CaseAwards[13][15][aRarity] = 3; CaseAwards[13][15][aType] = 5; CaseAwards[13][15][aInternalId] = 442; CaseAwards[13][15][aCount] = 0; CaseAwards[13][15][aPriceSprayed] = 170; CaseAwards[13][15][aSubcount] = 0;
    CaseAwards[13][16][aId] = 17; CaseAwards[13][16][aRarity] = 3; CaseAwards[13][16][aType] = 23; CaseAwards[13][16][aInternalId] = 1; CaseAwards[13][16][aCount] = 5000; CaseAwards[13][16][aPriceSprayed] = 0; CaseAwards[13][16][aSubcount] = 0;
    CaseAwards[13][17][aId] = 18; CaseAwards[13][17][aRarity] = 4; CaseAwards[13][17][aType] = 11; CaseAwards[13][17][aInternalId] = 134; CaseAwards[13][17][aCount] = 5500027; CaseAwards[13][17][aPriceSprayed] = 230; CaseAwards[13][17][aSubcount] = 0;
    CaseAwards[13][18][aId] = 19; CaseAwards[13][18][aRarity] = 4; CaseAwards[13][18][aType] = 5; CaseAwards[13][18][aInternalId] = 503; CaseAwards[13][18][aCount] = 0; CaseAwards[13][18][aPriceSprayed] = 230; CaseAwards[13][18][aSubcount] = 0;
    CaseAwards[13][19][aId] = 20; CaseAwards[13][19][aRarity] = 4; CaseAwards[13][19][aType] = 23; CaseAwards[13][19][aInternalId] = 1; CaseAwards[13][19][aCount] = 15000; CaseAwards[13][19][aPriceSprayed] = 0; CaseAwards[13][19][aSubcount] = 0;
    CaseAwards[13][20][aId] = 21; CaseAwards[13][20][aRarity] = 4; CaseAwards[13][20][aType] = 5; CaseAwards[13][20][aInternalId] = 2553; CaseAwards[13][20][aCount] = 0; CaseAwards[13][20][aPriceSprayed] = 240; CaseAwards[13][20][aSubcount] = 0;
    CaseAwards[13][21][aId] = 22; CaseAwards[13][21][aRarity] = 4; CaseAwards[13][21][aType] = 5; CaseAwards[13][21][aInternalId] = 502; CaseAwards[13][21][aCount] = 0; CaseAwards[13][21][aPriceSprayed] = 260; CaseAwards[13][21][aSubcount] = 0;
    CaseAwards[13][22][aId] = 23; CaseAwards[13][22][aRarity] = 4; CaseAwards[13][22][aType] = 5; CaseAwards[13][22][aInternalId] = 490; CaseAwards[13][22][aCount] = 0; CaseAwards[13][22][aPriceSprayed] = 290; CaseAwards[13][22][aSubcount] = 0;
    CaseAwards[13][23][aId] = 24; CaseAwards[13][23][aRarity] = 3; CaseAwards[13][23][aType] = 5; CaseAwards[13][23][aInternalId] = 2388; CaseAwards[13][23][aCount] = 0; CaseAwards[13][23][aPriceSprayed] = 210; CaseAwards[13][23][aSubcount] = 0;
    CaseAwards[13][24][aId] = 25; CaseAwards[13][24][aRarity] = 5; CaseAwards[13][24][aType] = 5; CaseAwards[13][24][aInternalId] = 28682; CaseAwards[13][24][aCount] = 0; CaseAwards[13][24][aPriceSprayed] = 670; CaseAwards[13][24][aSubcount] = 110;
    CaseBonus[13][0][bId] = 1; CaseBonus[13][0][bNumberOpen] = 40; CaseBonus[13][0][bRarity] = 5; CaseBonus[13][0][bType] = 5; CaseBonus[13][0][bInternalId] = 28683; CaseBonus[13][0][bCount] = 0; CaseBonus[13][0][bPriceSprayed] = 320;
    CaseBonus[13][1][bId] = 2; CaseBonus[13][1][bNumberOpen] = 30; CaseBonus[13][1][bRarity] = 4; CaseBonus[13][1][bType] = 23; CaseBonus[13][1][bInternalId] = 1; CaseBonus[13][1][bCount] = 10000; CaseBonus[13][1][bPriceSprayed] = 0;
    CaseBonus[13][2][bId] = 3; CaseBonus[13][2][bNumberOpen] = 20; CaseBonus[13][2][bRarity] = 4; CaseBonus[13][2][bType] = 4; CaseBonus[13][2][bInternalId] = 14; CaseBonus[13][2][bCount] = 2; CaseBonus[13][2][bPriceSprayed] = 0;
    CaseBonus[13][3][bId] = 4; CaseBonus[13][3][bNumberOpen] = 10; CaseBonus[13][3][bRarity] = 4; CaseBonus[13][3][bType] = 23; CaseBonus[13][3][bInternalId] = 1; CaseBonus[13][3][bCount] = 5000; CaseBonus[13][3][bPriceSprayed] = 0;
    CaseBonus[13][4][bId] = 5; CaseBonus[13][4][bNumberOpen] = 5; CaseBonus[13][4][bRarity] = 4; CaseBonus[13][4][bType] = 4; CaseBonus[13][4][bInternalId] = 14; CaseBonus[13][4][bCount] = 1; CaseBonus[13][4][bPriceSprayed] = 0;

    // case json id 15
    CaseData[14][cId] = 15;
    CaseData[14][cPriceOne] = 900;
    CaseData[14][cPriceTen] = 9000;
    CaseData[14][cDiscountOne] = 0;
    CaseData[14][cDiscountTen] = 5;
    CaseData[14][cAwardsCount] = 25;
    CaseData[14][cBonusCount] = 5;
    CaseAwards[14][0][aId] = 1; CaseAwards[14][0][aRarity] = 2; CaseAwards[14][0][aType] = 11; CaseAwards[14][0][aInternalId] = 134; CaseAwards[14][0][aCount] = 11917; CaseAwards[14][0][aPriceSprayed] = 110; CaseAwards[14][0][aSubcount] = 0;
    CaseAwards[14][1][aId] = 2; CaseAwards[14][1][aRarity] = 2; CaseAwards[14][1][aType] = 11; CaseAwards[14][1][aInternalId] = 362; CaseAwards[14][1][aCount] = 1; CaseAwards[14][1][aPriceSprayed] = 90; CaseAwards[14][1][aSubcount] = 0;
    CaseAwards[14][2][aId] = 3; CaseAwards[14][2][aRarity] = 3; CaseAwards[14][2][aType] = 11; CaseAwards[14][2][aInternalId] = 303; CaseAwards[14][2][aCount] = 1; CaseAwards[14][2][aPriceSprayed] = 90; CaseAwards[14][2][aSubcount] = 0;
    CaseAwards[14][3][aId] = 4; CaseAwards[14][3][aRarity] = 2; CaseAwards[14][3][aType] = 11; CaseAwards[14][3][aInternalId] = 169; CaseAwards[14][3][aCount] = 1; CaseAwards[14][3][aPriceSprayed] = 80; CaseAwards[14][3][aSubcount] = 0;
    CaseAwards[14][4][aId] = 5; CaseAwards[14][4][aRarity] = 2; CaseAwards[14][4][aType] = 3; CaseAwards[14][4][aInternalId] = 1; CaseAwards[14][4][aCount] = 800; CaseAwards[14][4][aPriceSprayed] = 0; CaseAwards[14][4][aSubcount] = 0;
    CaseAwards[14][5][aId] = 6; CaseAwards[14][5][aRarity] = 2; CaseAwards[14][5][aType] = 2; CaseAwards[14][5][aInternalId] = 1; CaseAwards[14][5][aCount] = 900000; CaseAwards[14][5][aPriceSprayed] = 0; CaseAwards[14][5][aSubcount] = 0;
    CaseAwards[14][6][aId] = 7; CaseAwards[14][6][aRarity] = 2; CaseAwards[14][6][aType] = 5; CaseAwards[14][6][aInternalId] = 2568; CaseAwards[14][6][aCount] = 0; CaseAwards[14][6][aPriceSprayed] = 110; CaseAwards[14][6][aSubcount] = 0;
    CaseAwards[14][7][aId] = 8; CaseAwards[14][7][aRarity] = 3; CaseAwards[14][7][aType] = 11; CaseAwards[14][7][aInternalId] = 134; CaseAwards[14][7][aCount] = 236; CaseAwards[14][7][aPriceSprayed] = 130; CaseAwards[14][7][aSubcount] = 0;
    CaseAwards[14][8][aId] = 9; CaseAwards[14][8][aRarity] = 3; CaseAwards[14][8][aType] = 11; CaseAwards[14][8][aInternalId] = 134; CaseAwards[14][8][aCount] = 5500044; CaseAwards[14][8][aPriceSprayed] = 160; CaseAwards[14][8][aSubcount] = 0;
    CaseAwards[14][9][aId] = 10; CaseAwards[14][9][aRarity] = 3; CaseAwards[14][9][aType] = 11; CaseAwards[14][9][aInternalId] = 134; CaseAwards[14][9][aCount] = 6895; CaseAwards[14][9][aPriceSprayed] = 140; CaseAwards[14][9][aSubcount] = 0;
    CaseAwards[14][10][aId] = 11; CaseAwards[14][10][aRarity] = 3; CaseAwards[14][10][aType] = 5; CaseAwards[14][10][aInternalId] = 603; CaseAwards[14][10][aCount] = 0; CaseAwards[14][10][aPriceSprayed] = 140; CaseAwards[14][10][aSubcount] = 0;
    CaseAwards[14][11][aId] = 12; CaseAwards[14][11][aRarity] = 3; CaseAwards[14][11][aType] = 2; CaseAwards[14][11][aInternalId] = 1; CaseAwards[14][11][aCount] = 1200000; CaseAwards[14][11][aPriceSprayed] = 0; CaseAwards[14][11][aSubcount] = 0;
    CaseAwards[14][12][aId] = 13; CaseAwards[14][12][aRarity] = 3; CaseAwards[14][12][aType] = 5; CaseAwards[14][12][aInternalId] = 442; CaseAwards[14][12][aCount] = 0; CaseAwards[14][12][aPriceSprayed] = 170; CaseAwards[14][12][aSubcount] = 0;
    CaseAwards[14][13][aId] = 14; CaseAwards[14][13][aRarity] = 3; CaseAwards[14][13][aType] = 2; CaseAwards[14][13][aInternalId] = 1; CaseAwards[14][13][aCount] = 1500000; CaseAwards[14][13][aPriceSprayed] = 0; CaseAwards[14][13][aSubcount] = 0;
    CaseAwards[14][14][aId] = 15; CaseAwards[14][14][aRarity] = 3; CaseAwards[14][14][aType] = 5; CaseAwards[14][14][aInternalId] = 2388; CaseAwards[14][14][aCount] = 0; CaseAwards[14][14][aPriceSprayed] = 210; CaseAwards[14][14][aSubcount] = 0;
    CaseAwards[14][15][aId] = 16; CaseAwards[14][15][aRarity] = 3; CaseAwards[14][15][aType] = 11; CaseAwards[14][15][aInternalId] = 1019; CaseAwards[14][15][aCount] = 1; CaseAwards[14][15][aPriceSprayed] = 180; CaseAwards[14][15][aSubcount] = 0;
    CaseAwards[14][16][aId] = 17; CaseAwards[14][16][aRarity] = 4; CaseAwards[14][16][aType] = 11; CaseAwards[14][16][aInternalId] = 1017; CaseAwards[14][16][aCount] = 1; CaseAwards[14][16][aPriceSprayed] = 220; CaseAwards[14][16][aSubcount] = 0;
    CaseAwards[14][17][aId] = 18; CaseAwards[14][17][aRarity] = 4; CaseAwards[14][17][aType] = 11; CaseAwards[14][17][aInternalId] = 1018; CaseAwards[14][17][aCount] = 1; CaseAwards[14][17][aPriceSprayed] = 240; CaseAwards[14][17][aSubcount] = 0;
    CaseAwards[14][18][aId] = 19; CaseAwards[14][18][aRarity] = 4; CaseAwards[14][18][aType] = 11; CaseAwards[14][18][aInternalId] = 134; CaseAwards[14][18][aCount] = 5500043; CaseAwards[14][18][aPriceSprayed] = 230; CaseAwards[14][18][aSubcount] = 0;
    CaseAwards[14][19][aId] = 20; CaseAwards[14][19][aRarity] = 4; CaseAwards[14][19][aType] = 5; CaseAwards[14][19][aInternalId] = 503; CaseAwards[14][19][aCount] = 0; CaseAwards[14][19][aPriceSprayed] = 230; CaseAwards[14][19][aSubcount] = 0;
    CaseAwards[14][20][aId] = 21; CaseAwards[14][20][aRarity] = 4; CaseAwards[14][20][aType] = 2; CaseAwards[14][20][aInternalId] = 1; CaseAwards[14][20][aCount] = 3000000; CaseAwards[14][20][aPriceSprayed] = 0; CaseAwards[14][20][aSubcount] = 0;
    CaseAwards[14][21][aId] = 22; CaseAwards[14][21][aRarity] = 4; CaseAwards[14][21][aType] = 5; CaseAwards[14][21][aInternalId] = 2553; CaseAwards[14][21][aCount] = 0; CaseAwards[14][21][aPriceSprayed] = 240; CaseAwards[14][21][aSubcount] = 0;
    CaseAwards[14][22][aId] = 23; CaseAwards[14][22][aRarity] = 4; CaseAwards[14][22][aType] = 5; CaseAwards[14][22][aInternalId] = 502; CaseAwards[14][22][aCount] = 0; CaseAwards[14][22][aPriceSprayed] = 260; CaseAwards[14][22][aSubcount] = 0;
    CaseAwards[14][23][aId] = 24; CaseAwards[14][23][aRarity] = 4; CaseAwards[14][23][aType] = 5; CaseAwards[14][23][aInternalId] = 490; CaseAwards[14][23][aCount] = 0; CaseAwards[14][23][aPriceSprayed] = 290; CaseAwards[14][23][aSubcount] = 0;
    CaseAwards[14][24][aId] = 25; CaseAwards[14][24][aRarity] = 5; CaseAwards[14][24][aType] = 5; CaseAwards[14][24][aInternalId] = 28689; CaseAwards[14][24][aCount] = 0; CaseAwards[14][24][aPriceSprayed] = 750; CaseAwards[14][24][aSubcount] = 119;
    CaseBonus[14][0][bId] = 1; CaseBonus[14][0][bNumberOpen] = 40; CaseBonus[14][0][bRarity] = 5; CaseBonus[14][0][bType] = 5; CaseBonus[14][0][bInternalId] = 28690; CaseBonus[14][0][bCount] = 0; CaseBonus[14][0][bPriceSprayed] = 320;
    CaseBonus[14][1][bId] = 2; CaseBonus[14][1][bNumberOpen] = 30; CaseBonus[14][1][bRarity] = 3; CaseBonus[14][1][bType] = 2; CaseBonus[14][1][bInternalId] = 1; CaseBonus[14][1][bCount] = 1200000; CaseBonus[14][1][bPriceSprayed] = 0;
    CaseBonus[14][2][bId] = 3; CaseBonus[14][2][bNumberOpen] = 20; CaseBonus[14][2][bRarity] = 4; CaseBonus[14][2][bType] = 4; CaseBonus[14][2][bInternalId] = 15; CaseBonus[14][2][bCount] = 2; CaseBonus[14][2][bPriceSprayed] = 0;
    CaseBonus[14][3][bId] = 4; CaseBonus[14][3][bNumberOpen] = 10; CaseBonus[14][3][bRarity] = 3; CaseBonus[14][3][bType] = 2; CaseBonus[14][3][bInternalId] = 1; CaseBonus[14][3][bCount] = 2500000; CaseBonus[14][3][bPriceSprayed] = 0;
    CaseBonus[14][4][bId] = 5; CaseBonus[14][4][bNumberOpen] = 5; CaseBonus[14][4][bRarity] = 4; CaseBonus[14][4][bType] = 4; CaseBonus[14][4][bInternalId] = 15; CaseBonus[14][4][bCount] = 1; CaseBonus[14][4][bPriceSprayed] = 0;

    // case json id 16
    CaseData[15][cId] = 16;
    CaseData[15][cPriceOne] = 900;
    CaseData[15][cPriceTen] = 9000;
    CaseData[15][cDiscountOne] = 0;
    CaseData[15][cDiscountTen] = 5;
    CaseData[15][cAwardsCount] = 25;
    CaseData[15][cBonusCount] = 5;
    CaseAwards[15][0][aId] = 1; CaseAwards[15][0][aRarity] = 2; CaseAwards[15][0][aType] = 11; CaseAwards[15][0][aInternalId] = 134; CaseAwards[15][0][aCount] = 252; CaseAwards[15][0][aPriceSprayed] = 110; CaseAwards[15][0][aSubcount] = 0;
    CaseAwards[15][1][aId] = 2; CaseAwards[15][1][aRarity] = 2; CaseAwards[15][1][aType] = 11; CaseAwards[15][1][aInternalId] = 144; CaseAwards[15][1][aCount] = 1; CaseAwards[15][1][aPriceSprayed] = 70; CaseAwards[15][1][aSubcount] = 0;
    CaseAwards[15][2][aId] = 3; CaseAwards[15][2][aRarity] = 2; CaseAwards[15][2][aType] = 11; CaseAwards[15][2][aInternalId] = 138; CaseAwards[15][2][aCount] = 1; CaseAwards[15][2][aPriceSprayed] = 90; CaseAwards[15][2][aSubcount] = 0;
    CaseAwards[15][3][aId] = 4; CaseAwards[15][3][aRarity] = 2; CaseAwards[15][3][aType] = 11; CaseAwards[15][3][aInternalId] = 663; CaseAwards[15][3][aCount] = 1; CaseAwards[15][3][aPriceSprayed] = 100; CaseAwards[15][3][aSubcount] = 0;
    CaseAwards[15][4][aId] = 5; CaseAwards[15][4][aRarity] = 2; CaseAwards[15][4][aType] = 3; CaseAwards[15][4][aInternalId] = 1; CaseAwards[15][4][aCount] = 700; CaseAwards[15][4][aPriceSprayed] = 0; CaseAwards[15][4][aSubcount] = 0;
    CaseAwards[15][5][aId] = 6; CaseAwards[15][5][aRarity] = 2; CaseAwards[15][5][aType] = 2; CaseAwards[15][5][aInternalId] = 1; CaseAwards[15][5][aCount] = 900000; CaseAwards[15][5][aPriceSprayed] = 0; CaseAwards[15][5][aSubcount] = 0;
    CaseAwards[15][6][aId] = 7; CaseAwards[15][6][aRarity] = 2; CaseAwards[15][6][aType] = 5; CaseAwards[15][6][aInternalId] = 2568; CaseAwards[15][6][aCount] = 0; CaseAwards[15][6][aPriceSprayed] = 110; CaseAwards[15][6][aSubcount] = 0;
    CaseAwards[15][7][aId] = 8; CaseAwards[15][7][aRarity] = 3; CaseAwards[15][7][aType] = 11; CaseAwards[15][7][aInternalId] = 303; CaseAwards[15][7][aCount] = 1; CaseAwards[15][7][aPriceSprayed] = 90; CaseAwards[15][7][aSubcount] = 0;
    CaseAwards[15][8][aId] = 9; CaseAwards[15][8][aRarity] = 3; CaseAwards[15][8][aType] = 11; CaseAwards[15][8][aInternalId] = 134; CaseAwards[15][8][aCount] = 236; CaseAwards[15][8][aPriceSprayed] = 130; CaseAwards[15][8][aSubcount] = 0;
    CaseAwards[15][9][aId] = 10; CaseAwards[15][9][aRarity] = 3; CaseAwards[15][9][aType] = 11; CaseAwards[15][9][aInternalId] = 134; CaseAwards[15][9][aCount] = 5500056; CaseAwards[15][9][aPriceSprayed] = 180; CaseAwards[15][9][aSubcount] = 0;
    CaseAwards[15][10][aId] = 11; CaseAwards[15][10][aRarity] = 3; CaseAwards[15][10][aType] = 11; CaseAwards[15][10][aInternalId] = 134; CaseAwards[15][10][aCount] = 6895; CaseAwards[15][10][aPriceSprayed] = 140; CaseAwards[15][10][aSubcount] = 0;
    CaseAwards[15][11][aId] = 12; CaseAwards[15][11][aRarity] = 3; CaseAwards[15][11][aType] = 5; CaseAwards[15][11][aInternalId] = 603; CaseAwards[15][11][aCount] = 0; CaseAwards[15][11][aPriceSprayed] = 140; CaseAwards[15][11][aSubcount] = 0;
    CaseAwards[15][12][aId] = 13; CaseAwards[15][12][aRarity] = 3; CaseAwards[15][12][aType] = 23; CaseAwards[15][12][aInternalId] = 1; CaseAwards[15][12][aCount] = 7500; CaseAwards[15][12][aPriceSprayed] = 0; CaseAwards[15][12][aSubcount] = 0;
    CaseAwards[15][13][aId] = 14; CaseAwards[15][13][aRarity] = 3; CaseAwards[15][13][aType] = 5; CaseAwards[15][13][aInternalId] = 442; CaseAwards[15][13][aCount] = 0; CaseAwards[15][13][aPriceSprayed] = 170; CaseAwards[15][13][aSubcount] = 0;
    CaseAwards[15][14][aId] = 15; CaseAwards[15][14][aRarity] = 3; CaseAwards[15][14][aType] = 23; CaseAwards[15][14][aInternalId] = 1; CaseAwards[15][14][aCount] = 5000; CaseAwards[15][14][aPriceSprayed] = 0; CaseAwards[15][14][aSubcount] = 0;
    CaseAwards[15][15][aId] = 16; CaseAwards[15][15][aRarity] = 3; CaseAwards[15][15][aType] = 5; CaseAwards[15][15][aInternalId] = 2388; CaseAwards[15][15][aCount] = 0; CaseAwards[15][15][aPriceSprayed] = 210; CaseAwards[15][15][aSubcount] = 0;
    CaseAwards[15][16][aId] = 17; CaseAwards[15][16][aRarity] = 4; CaseAwards[15][16][aType] = 11; CaseAwards[15][16][aInternalId] = 1030; CaseAwards[15][16][aCount] = 1; CaseAwards[15][16][aPriceSprayed] = 240; CaseAwards[15][16][aSubcount] = 0;
    CaseAwards[15][17][aId] = 18; CaseAwards[15][17][aRarity] = 4; CaseAwards[15][17][aType] = 11; CaseAwards[15][17][aInternalId] = 1029; CaseAwards[15][17][aCount] = 1; CaseAwards[15][17][aPriceSprayed] = 240; CaseAwards[15][17][aSubcount] = 0;
    CaseAwards[15][18][aId] = 19; CaseAwards[15][18][aRarity] = 4; CaseAwards[15][18][aType] = 11; CaseAwards[15][18][aInternalId] = 134; CaseAwards[15][18][aCount] = 5500057; CaseAwards[15][18][aPriceSprayed] = 230; CaseAwards[15][18][aSubcount] = 0;
    CaseAwards[15][19][aId] = 20; CaseAwards[15][19][aRarity] = 4; CaseAwards[15][19][aType] = 5; CaseAwards[15][19][aInternalId] = 503; CaseAwards[15][19][aCount] = 0; CaseAwards[15][19][aPriceSprayed] = 230; CaseAwards[15][19][aSubcount] = 0;
    CaseAwards[15][20][aId] = 21; CaseAwards[15][20][aRarity] = 4; CaseAwards[15][20][aType] = 23; CaseAwards[15][20][aInternalId] = 1; CaseAwards[15][20][aCount] = 15000; CaseAwards[15][20][aPriceSprayed] = 0; CaseAwards[15][20][aSubcount] = 0;
    CaseAwards[15][21][aId] = 22; CaseAwards[15][21][aRarity] = 4; CaseAwards[15][21][aType] = 5; CaseAwards[15][21][aInternalId] = 2553; CaseAwards[15][21][aCount] = 0; CaseAwards[15][21][aPriceSprayed] = 240; CaseAwards[15][21][aSubcount] = 0;
    CaseAwards[15][22][aId] = 23; CaseAwards[15][22][aRarity] = 4; CaseAwards[15][22][aType] = 5; CaseAwards[15][22][aInternalId] = 2547; CaseAwards[15][22][aCount] = 0; CaseAwards[15][22][aPriceSprayed] = 250; CaseAwards[15][22][aSubcount] = 0;
    CaseAwards[15][23][aId] = 24; CaseAwards[15][23][aRarity] = 4; CaseAwards[15][23][aType] = 5; CaseAwards[15][23][aInternalId] = 490; CaseAwards[15][23][aCount] = 0; CaseAwards[15][23][aPriceSprayed] = 290; CaseAwards[15][23][aSubcount] = 0;
    CaseAwards[15][24][aId] = 25; CaseAwards[15][24][aRarity] = 5; CaseAwards[15][24][aType] = 5; CaseAwards[15][24][aInternalId] = 28706; CaseAwards[15][24][aCount] = 0; CaseAwards[15][24][aPriceSprayed] = 570; CaseAwards[15][24][aSubcount] = 131;
    CaseBonus[15][0][bId] = 1; CaseBonus[15][0][bNumberOpen] = 40; CaseBonus[15][0][bRarity] = 5; CaseBonus[15][0][bType] = 5; CaseBonus[15][0][bInternalId] = 28707; CaseBonus[15][0][bCount] = 0; CaseBonus[15][0][bPriceSprayed] = 320;
    CaseBonus[15][1][bId] = 2; CaseBonus[15][1][bNumberOpen] = 30; CaseBonus[15][1][bRarity] = 4; CaseBonus[15][1][bType] = 23; CaseBonus[15][1][bInternalId] = 1; CaseBonus[15][1][bCount] = 10000; CaseBonus[15][1][bPriceSprayed] = 0;
    CaseBonus[15][2][bId] = 3; CaseBonus[15][2][bNumberOpen] = 20; CaseBonus[15][2][bRarity] = 4; CaseBonus[15][2][bType] = 4; CaseBonus[15][2][bInternalId] = 16; CaseBonus[15][2][bCount] = 2; CaseBonus[15][2][bPriceSprayed] = 0;
    CaseBonus[15][3][bId] = 4; CaseBonus[15][3][bNumberOpen] = 10; CaseBonus[15][3][bRarity] = 4; CaseBonus[15][3][bType] = 23; CaseBonus[15][3][bInternalId] = 1; CaseBonus[15][3][bCount] = 5000; CaseBonus[15][3][bPriceSprayed] = 0;
    CaseBonus[15][4][bId] = 5; CaseBonus[15][4][bNumberOpen] = 5; CaseBonus[15][4][bRarity] = 4; CaseBonus[15][4][bType] = 4; CaseBonus[15][4][bInternalId] = 16; CaseBonus[15][4][bCount] = 1; CaseBonus[15][4][bPriceSprayed] = 0;

    // case json id 17
    CaseData[16][cId] = 17;
    CaseData[16][cPriceOne] = 900;
    CaseData[16][cPriceTen] = 9000;
    CaseData[16][cDiscountOne] = 0;
    CaseData[16][cDiscountTen] = 5;
    CaseData[16][cAwardsCount] = 25;
    CaseData[16][cBonusCount] = 5;
    CaseAwards[16][0][aId] = 1; CaseAwards[16][0][aRarity] = 2; CaseAwards[16][0][aType] = 11; CaseAwards[16][0][aInternalId] = 134; CaseAwards[16][0][aCount] = 252; CaseAwards[16][0][aPriceSprayed] = 110; CaseAwards[16][0][aSubcount] = 0;
    CaseAwards[16][1][aId] = 2; CaseAwards[16][1][aRarity] = 2; CaseAwards[16][1][aType] = 11; CaseAwards[16][1][aInternalId] = 143; CaseAwards[16][1][aCount] = 1; CaseAwards[16][1][aPriceSprayed] = 80; CaseAwards[16][1][aSubcount] = 0;
    CaseAwards[16][2][aId] = 3; CaseAwards[16][2][aRarity] = 2; CaseAwards[16][2][aType] = 11; CaseAwards[16][2][aInternalId] = 139; CaseAwards[16][2][aCount] = 1; CaseAwards[16][2][aPriceSprayed] = 110; CaseAwards[16][2][aSubcount] = 0;
    CaseAwards[16][3][aId] = 4; CaseAwards[16][3][aRarity] = 2; CaseAwards[16][3][aType] = 11; CaseAwards[16][3][aInternalId] = 663; CaseAwards[16][3][aCount] = 1; CaseAwards[16][3][aPriceSprayed] = 100; CaseAwards[16][3][aSubcount] = 0;
    CaseAwards[16][4][aId] = 5; CaseAwards[16][4][aRarity] = 2; CaseAwards[16][4][aType] = 3; CaseAwards[16][4][aInternalId] = 1; CaseAwards[16][4][aCount] = 700; CaseAwards[16][4][aPriceSprayed] = 0; CaseAwards[16][4][aSubcount] = 0;
    CaseAwards[16][5][aId] = 6; CaseAwards[16][5][aRarity] = 2; CaseAwards[16][5][aType] = 2; CaseAwards[16][5][aInternalId] = 1; CaseAwards[16][5][aCount] = 900000; CaseAwards[16][5][aPriceSprayed] = 0; CaseAwards[16][5][aSubcount] = 0;
    CaseAwards[16][6][aId] = 7; CaseAwards[16][6][aRarity] = 2; CaseAwards[16][6][aType] = 5; CaseAwards[16][6][aInternalId] = 2568; CaseAwards[16][6][aCount] = 0; CaseAwards[16][6][aPriceSprayed] = 110; CaseAwards[16][6][aSubcount] = 0;
    CaseAwards[16][7][aId] = 8; CaseAwards[16][7][aRarity] = 3; CaseAwards[16][7][aType] = 11; CaseAwards[16][7][aInternalId] = 303; CaseAwards[16][7][aCount] = 1; CaseAwards[16][7][aPriceSprayed] = 90; CaseAwards[16][7][aSubcount] = 0;
    CaseAwards[16][8][aId] = 9; CaseAwards[16][8][aRarity] = 3; CaseAwards[16][8][aType] = 11; CaseAwards[16][8][aInternalId] = 134; CaseAwards[16][8][aCount] = 11958; CaseAwards[16][8][aPriceSprayed] = 120; CaseAwards[16][8][aSubcount] = 0;
    CaseAwards[16][9][aId] = 10; CaseAwards[16][9][aRarity] = 3; CaseAwards[16][9][aType] = 11; CaseAwards[16][9][aInternalId] = 134; CaseAwards[16][9][aCount] = 5500058; CaseAwards[16][9][aPriceSprayed] = 180; CaseAwards[16][9][aSubcount] = 0;
    CaseAwards[16][10][aId] = 11; CaseAwards[16][10][aRarity] = 3; CaseAwards[16][10][aType] = 11; CaseAwards[16][10][aInternalId] = 1033; CaseAwards[16][10][aCount] = 1; CaseAwards[16][10][aPriceSprayed] = 160; CaseAwards[16][10][aSubcount] = 0;
    CaseAwards[16][11][aId] = 12; CaseAwards[16][11][aRarity] = 3; CaseAwards[16][11][aType] = 5; CaseAwards[16][11][aInternalId] = 603; CaseAwards[16][11][aCount] = 0; CaseAwards[16][11][aPriceSprayed] = 140; CaseAwards[16][11][aSubcount] = 0;
    CaseAwards[16][12][aId] = 13; CaseAwards[16][12][aRarity] = 3; CaseAwards[16][12][aType] = 23; CaseAwards[16][12][aInternalId] = 1; CaseAwards[16][12][aCount] = 7500; CaseAwards[16][12][aPriceSprayed] = 0; CaseAwards[16][12][aSubcount] = 0;
    CaseAwards[16][13][aId] = 14; CaseAwards[16][13][aRarity] = 3; CaseAwards[16][13][aType] = 5; CaseAwards[16][13][aInternalId] = 442; CaseAwards[16][13][aCount] = 0; CaseAwards[16][13][aPriceSprayed] = 170; CaseAwards[16][13][aSubcount] = 0;
    CaseAwards[16][14][aId] = 15; CaseAwards[16][14][aRarity] = 3; CaseAwards[16][14][aType] = 23; CaseAwards[16][14][aInternalId] = 1; CaseAwards[16][14][aCount] = 5000; CaseAwards[16][14][aPriceSprayed] = 0; CaseAwards[16][14][aSubcount] = 0;
    CaseAwards[16][15][aId] = 16; CaseAwards[16][15][aRarity] = 3; CaseAwards[16][15][aType] = 5; CaseAwards[16][15][aInternalId] = 2388; CaseAwards[16][15][aCount] = 0; CaseAwards[16][15][aPriceSprayed] = 210; CaseAwards[16][15][aSubcount] = 0;
    CaseAwards[16][16][aId] = 17; CaseAwards[16][16][aRarity] = 4; CaseAwards[16][16][aType] = 11; CaseAwards[16][16][aInternalId] = 1031; CaseAwards[16][16][aCount] = 1; CaseAwards[16][16][aPriceSprayed] = 240; CaseAwards[16][16][aSubcount] = 0;
    CaseAwards[16][17][aId] = 18; CaseAwards[16][17][aRarity] = 4; CaseAwards[16][17][aType] = 11; CaseAwards[16][17][aInternalId] = 1032; CaseAwards[16][17][aCount] = 1; CaseAwards[16][17][aPriceSprayed] = 240; CaseAwards[16][17][aSubcount] = 0;
    CaseAwards[16][18][aId] = 19; CaseAwards[16][18][aRarity] = 4; CaseAwards[16][18][aType] = 11; CaseAwards[16][18][aInternalId] = 134; CaseAwards[16][18][aCount] = 5500059; CaseAwards[16][18][aPriceSprayed] = 230; CaseAwards[16][18][aSubcount] = 0;
    CaseAwards[16][19][aId] = 20; CaseAwards[16][19][aRarity] = 4; CaseAwards[16][19][aType] = 5; CaseAwards[16][19][aInternalId] = 503; CaseAwards[16][19][aCount] = 0; CaseAwards[16][19][aPriceSprayed] = 230; CaseAwards[16][19][aSubcount] = 0;
    CaseAwards[16][20][aId] = 21; CaseAwards[16][20][aRarity] = 4; CaseAwards[16][20][aType] = 23; CaseAwards[16][20][aInternalId] = 1; CaseAwards[16][20][aCount] = 15000; CaseAwards[16][20][aPriceSprayed] = 0; CaseAwards[16][20][aSubcount] = 0;
    CaseAwards[16][21][aId] = 22; CaseAwards[16][21][aRarity] = 4; CaseAwards[16][21][aType] = 5; CaseAwards[16][21][aInternalId] = 2553; CaseAwards[16][21][aCount] = 0; CaseAwards[16][21][aPriceSprayed] = 240; CaseAwards[16][21][aSubcount] = 0;
    CaseAwards[16][22][aId] = 23; CaseAwards[16][22][aRarity] = 4; CaseAwards[16][22][aType] = 5; CaseAwards[16][22][aInternalId] = 2547; CaseAwards[16][22][aCount] = 0; CaseAwards[16][22][aPriceSprayed] = 250; CaseAwards[16][22][aSubcount] = 0;
    CaseAwards[16][23][aId] = 24; CaseAwards[16][23][aRarity] = 4; CaseAwards[16][23][aType] = 5; CaseAwards[16][23][aInternalId] = 490; CaseAwards[16][23][aCount] = 0; CaseAwards[16][23][aPriceSprayed] = 290; CaseAwards[16][23][aSubcount] = 0;
    CaseAwards[16][24][aId] = 25; CaseAwards[16][24][aRarity] = 5; CaseAwards[16][24][aType] = 5; CaseAwards[16][24][aInternalId] = 28708; CaseAwards[16][24][aCount] = 0; CaseAwards[16][24][aPriceSprayed] = 800; CaseAwards[16][24][aSubcount] = 136;
    CaseBonus[16][0][bId] = 1; CaseBonus[16][0][bNumberOpen] = 40; CaseBonus[16][0][bRarity] = 5; CaseBonus[16][0][bType] = 5; CaseBonus[16][0][bInternalId] = 28709; CaseBonus[16][0][bCount] = 0; CaseBonus[16][0][bPriceSprayed] = 320;
    CaseBonus[16][1][bId] = 2; CaseBonus[16][1][bNumberOpen] = 30; CaseBonus[16][1][bRarity] = 4; CaseBonus[16][1][bType] = 23; CaseBonus[16][1][bInternalId] = 1; CaseBonus[16][1][bCount] = 10000; CaseBonus[16][1][bPriceSprayed] = 0;
    CaseBonus[16][2][bId] = 3; CaseBonus[16][2][bNumberOpen] = 20; CaseBonus[16][2][bRarity] = 4; CaseBonus[16][2][bType] = 4; CaseBonus[16][2][bInternalId] = 17; CaseBonus[16][2][bCount] = 2; CaseBonus[16][2][bPriceSprayed] = 0;
    CaseBonus[16][3][bId] = 4; CaseBonus[16][3][bNumberOpen] = 10; CaseBonus[16][3][bRarity] = 4; CaseBonus[16][3][bType] = 23; CaseBonus[16][3][bInternalId] = 1; CaseBonus[16][3][bCount] = 5000; CaseBonus[16][3][bPriceSprayed] = 0;
    CaseBonus[16][4][bId] = 5; CaseBonus[16][4][bNumberOpen] = 5; CaseBonus[16][4][bRarity] = 4; CaseBonus[16][4][bType] = 4; CaseBonus[16][4][bInternalId] = 17; CaseBonus[16][4][bCount] = 1; CaseBonus[16][4][bPriceSprayed] = 0;

    // case json id 18
    CaseData[17][cId] = 18;
    CaseData[17][cPriceOne] = 900;
    CaseData[17][cPriceTen] = 9000;
    CaseData[17][cDiscountOne] = 0;
    CaseData[17][cDiscountTen] = 5;
    CaseData[17][cAwardsCount] = 25;
    CaseData[17][cBonusCount] = 5;
    CaseAwards[17][0][aId] = 1; CaseAwards[17][0][aRarity] = 2; CaseAwards[17][0][aType] = 11; CaseAwards[17][0][aInternalId] = 134; CaseAwards[17][0][aCount] = 14388; CaseAwards[17][0][aPriceSprayed] = 100; CaseAwards[17][0][aSubcount] = 0;
    CaseAwards[17][1][aId] = 2; CaseAwards[17][1][aRarity] = 2; CaseAwards[17][1][aType] = 11; CaseAwards[17][1][aInternalId] = 533; CaseAwards[17][1][aCount] = 1; CaseAwards[17][1][aPriceSprayed] = 70; CaseAwards[17][1][aSubcount] = 0;
    CaseAwards[17][2][aId] = 3; CaseAwards[17][2][aRarity] = 2; CaseAwards[17][2][aType] = 11; CaseAwards[17][2][aInternalId] = 281; CaseAwards[17][2][aCount] = 1; CaseAwards[17][2][aPriceSprayed] = 90; CaseAwards[17][2][aSubcount] = 0;
    CaseAwards[17][3][aId] = 4; CaseAwards[17][3][aRarity] = 2; CaseAwards[17][3][aType] = 11; CaseAwards[17][3][aInternalId] = 301; CaseAwards[17][3][aCount] = 1; CaseAwards[17][3][aPriceSprayed] = 90; CaseAwards[17][3][aSubcount] = 0;
    CaseAwards[17][4][aId] = 5; CaseAwards[17][4][aRarity] = 2; CaseAwards[17][4][aType] = 3; CaseAwards[17][4][aInternalId] = 1; CaseAwards[17][4][aCount] = 700; CaseAwards[17][4][aPriceSprayed] = 0; CaseAwards[17][4][aSubcount] = 0;
    CaseAwards[17][5][aId] = 6; CaseAwards[17][5][aRarity] = 2; CaseAwards[17][5][aType] = 2; CaseAwards[17][5][aInternalId] = 1; CaseAwards[17][5][aCount] = 900000; CaseAwards[17][5][aPriceSprayed] = 0; CaseAwards[17][5][aSubcount] = 0;
    CaseAwards[17][6][aId] = 7; CaseAwards[17][6][aRarity] = 2; CaseAwards[17][6][aType] = 5; CaseAwards[17][6][aInternalId] = 2568; CaseAwards[17][6][aCount] = 0; CaseAwards[17][6][aPriceSprayed] = 110; CaseAwards[17][6][aSubcount] = 0;
    CaseAwards[17][7][aId] = 8; CaseAwards[17][7][aRarity] = 2; CaseAwards[17][7][aType] = 11; CaseAwards[17][7][aInternalId] = 313; CaseAwards[17][7][aCount] = 1; CaseAwards[17][7][aPriceSprayed] = 90; CaseAwards[17][7][aSubcount] = 0;
    CaseAwards[17][8][aId] = 9; CaseAwards[17][8][aRarity] = 3; CaseAwards[17][8][aType] = 11; CaseAwards[17][8][aInternalId] = 134; CaseAwards[17][8][aCount] = 5325; CaseAwards[17][8][aPriceSprayed] = 140; CaseAwards[17][8][aSubcount] = 0;
    CaseAwards[17][9][aId] = 10; CaseAwards[17][9][aRarity] = 3; CaseAwards[17][9][aType] = 11; CaseAwards[17][9][aInternalId] = 134; CaseAwards[17][9][aCount] = 5500070; CaseAwards[17][9][aPriceSprayed] = 180; CaseAwards[17][9][aSubcount] = 0;
    CaseAwards[17][10][aId] = 11; CaseAwards[17][10][aRarity] = 3; CaseAwards[17][10][aType] = 11; CaseAwards[17][10][aInternalId] = 134; CaseAwards[17][10][aCount] = 6895; CaseAwards[17][10][aPriceSprayed] = 140; CaseAwards[17][10][aSubcount] = 0;
    CaseAwards[17][11][aId] = 12; CaseAwards[17][11][aRarity] = 3; CaseAwards[17][11][aType] = 5; CaseAwards[17][11][aInternalId] = 603; CaseAwards[17][11][aCount] = 0; CaseAwards[17][11][aPriceSprayed] = 140; CaseAwards[17][11][aSubcount] = 0;
    CaseAwards[17][12][aId] = 13; CaseAwards[17][12][aRarity] = 3; CaseAwards[17][12][aType] = 23; CaseAwards[17][12][aInternalId] = 1; CaseAwards[17][12][aCount] = 7500; CaseAwards[17][12][aPriceSprayed] = 0; CaseAwards[17][12][aSubcount] = 0;
    CaseAwards[17][13][aId] = 14; CaseAwards[17][13][aRarity] = 3; CaseAwards[17][13][aType] = 5; CaseAwards[17][13][aInternalId] = 442; CaseAwards[17][13][aCount] = 0; CaseAwards[17][13][aPriceSprayed] = 170; CaseAwards[17][13][aSubcount] = 0;
    CaseAwards[17][14][aId] = 15; CaseAwards[17][14][aRarity] = 3; CaseAwards[17][14][aType] = 23; CaseAwards[17][14][aInternalId] = 1; CaseAwards[17][14][aCount] = 5000; CaseAwards[17][14][aPriceSprayed] = 0; CaseAwards[17][14][aSubcount] = 0;
    CaseAwards[17][15][aId] = 16; CaseAwards[17][15][aRarity] = 3; CaseAwards[17][15][aType] = 5; CaseAwards[17][15][aInternalId] = 2388; CaseAwards[17][15][aCount] = 0; CaseAwards[17][15][aPriceSprayed] = 210; CaseAwards[17][15][aSubcount] = 0;
    CaseAwards[17][16][aId] = 17; CaseAwards[17][16][aRarity] = 4; CaseAwards[17][16][aType] = 11; CaseAwards[17][16][aInternalId] = 1053; CaseAwards[17][16][aCount] = 1; CaseAwards[17][16][aPriceSprayed] = 240; CaseAwards[17][16][aSubcount] = 0;
    CaseAwards[17][17][aId] = 18; CaseAwards[17][17][aRarity] = 4; CaseAwards[17][17][aType] = 11; CaseAwards[17][17][aInternalId] = 1054; CaseAwards[17][17][aCount] = 1; CaseAwards[17][17][aPriceSprayed] = 240; CaseAwards[17][17][aSubcount] = 0;
    CaseAwards[17][18][aId] = 19; CaseAwards[17][18][aRarity] = 4; CaseAwards[17][18][aType] = 11; CaseAwards[17][18][aInternalId] = 134; CaseAwards[17][18][aCount] = 5500071; CaseAwards[17][18][aPriceSprayed] = 230; CaseAwards[17][18][aSubcount] = 0;
    CaseAwards[17][19][aId] = 20; CaseAwards[17][19][aRarity] = 4; CaseAwards[17][19][aType] = 5; CaseAwards[17][19][aInternalId] = 503; CaseAwards[17][19][aCount] = 0; CaseAwards[17][19][aPriceSprayed] = 230; CaseAwards[17][19][aSubcount] = 0;
    CaseAwards[17][20][aId] = 21; CaseAwards[17][20][aRarity] = 4; CaseAwards[17][20][aType] = 23; CaseAwards[17][20][aInternalId] = 1; CaseAwards[17][20][aCount] = 15000; CaseAwards[17][20][aPriceSprayed] = 0; CaseAwards[17][20][aSubcount] = 0;
    CaseAwards[17][21][aId] = 22; CaseAwards[17][21][aRarity] = 4; CaseAwards[17][21][aType] = 5; CaseAwards[17][21][aInternalId] = 2553; CaseAwards[17][21][aCount] = 0; CaseAwards[17][21][aPriceSprayed] = 240; CaseAwards[17][21][aSubcount] = 0;
    CaseAwards[17][22][aId] = 23; CaseAwards[17][22][aRarity] = 4; CaseAwards[17][22][aType] = 5; CaseAwards[17][22][aInternalId] = 2547; CaseAwards[17][22][aCount] = 0; CaseAwards[17][22][aPriceSprayed] = 250; CaseAwards[17][22][aSubcount] = 0;
    CaseAwards[17][23][aId] = 24; CaseAwards[17][23][aRarity] = 4; CaseAwards[17][23][aType] = 5; CaseAwards[17][23][aInternalId] = 490; CaseAwards[17][23][aCount] = 0; CaseAwards[17][23][aPriceSprayed] = 290; CaseAwards[17][23][aSubcount] = 0;
    CaseAwards[17][24][aId] = 25; CaseAwards[17][24][aRarity] = 5; CaseAwards[17][24][aType] = 5; CaseAwards[17][24][aInternalId] = 28717; CaseAwards[17][24][aCount] = 0; CaseAwards[17][24][aPriceSprayed] = 700; CaseAwards[17][24][aSubcount] = 148;
    CaseBonus[17][0][bId] = 1; CaseBonus[17][0][bNumberOpen] = 40; CaseBonus[17][0][bRarity] = 5; CaseBonus[17][0][bType] = 5; CaseBonus[17][0][bInternalId] = 28718; CaseBonus[17][0][bCount] = 0; CaseBonus[17][0][bPriceSprayed] = 320;
    CaseBonus[17][1][bId] = 2; CaseBonus[17][1][bNumberOpen] = 30; CaseBonus[17][1][bRarity] = 4; CaseBonus[17][1][bType] = 23; CaseBonus[17][1][bInternalId] = 1; CaseBonus[17][1][bCount] = 10000; CaseBonus[17][1][bPriceSprayed] = 0;
    CaseBonus[17][2][bId] = 3; CaseBonus[17][2][bNumberOpen] = 20; CaseBonus[17][2][bRarity] = 4; CaseBonus[17][2][bType] = 4; CaseBonus[17][2][bInternalId] = 18; CaseBonus[17][2][bCount] = 2; CaseBonus[17][2][bPriceSprayed] = 0;
    CaseBonus[17][3][bId] = 4; CaseBonus[17][3][bNumberOpen] = 10; CaseBonus[17][3][bRarity] = 4; CaseBonus[17][3][bType] = 23; CaseBonus[17][3][bInternalId] = 1; CaseBonus[17][3][bCount] = 5000; CaseBonus[17][3][bPriceSprayed] = 0;
    CaseBonus[17][4][bId] = 5; CaseBonus[17][4][bNumberOpen] = 5; CaseBonus[17][4][bRarity] = 4; CaseBonus[17][4][bType] = 4; CaseBonus[17][4][bInternalId] = 18; CaseBonus[17][4][bCount] = 1; CaseBonus[17][4][bPriceSprayed] = 0;

    // case json id 19
    CaseData[18][cId] = 19;
    CaseData[18][cPriceOne] = 900;
    CaseData[18][cPriceTen] = 9000;
    CaseData[18][cDiscountOne] = 0;
    CaseData[18][cDiscountTen] = 5;
    CaseData[18][cAwardsCount] = 25;
    CaseData[18][cBonusCount] = 5;
    CaseAwards[18][0][aId] = 1; CaseAwards[18][0][aRarity] = 2; CaseAwards[18][0][aType] = 11; CaseAwards[18][0][aInternalId] = 134; CaseAwards[18][0][aCount] = 14386; CaseAwards[18][0][aPriceSprayed] = 100; CaseAwards[18][0][aSubcount] = 0;
    CaseAwards[18][1][aId] = 2; CaseAwards[18][1][aRarity] = 2; CaseAwards[18][1][aType] = 11; CaseAwards[18][1][aInternalId] = 522; CaseAwards[18][1][aCount] = 1; CaseAwards[18][1][aPriceSprayed] = 70; CaseAwards[18][1][aSubcount] = 0;
    CaseAwards[18][2][aId] = 3; CaseAwards[18][2][aRarity] = 2; CaseAwards[18][2][aType] = 11; CaseAwards[18][2][aInternalId] = 287; CaseAwards[18][2][aCount] = 1; CaseAwards[18][2][aPriceSprayed] = 90; CaseAwards[18][2][aSubcount] = 0;
    CaseAwards[18][3][aId] = 4; CaseAwards[18][3][aRarity] = 2; CaseAwards[18][3][aType] = 11; CaseAwards[18][3][aInternalId] = 309; CaseAwards[18][3][aCount] = 1; CaseAwards[18][3][aPriceSprayed] = 90; CaseAwards[18][3][aSubcount] = 0;
    CaseAwards[18][4][aId] = 5; CaseAwards[18][4][aRarity] = 2; CaseAwards[18][4][aType] = 3; CaseAwards[18][4][aInternalId] = 1; CaseAwards[18][4][aCount] = 700; CaseAwards[18][4][aPriceSprayed] = 0; CaseAwards[18][4][aSubcount] = 0;
    CaseAwards[18][5][aId] = 6; CaseAwards[18][5][aRarity] = 2; CaseAwards[18][5][aType] = 2; CaseAwards[18][5][aInternalId] = 1; CaseAwards[18][5][aCount] = 900000; CaseAwards[18][5][aPriceSprayed] = 0; CaseAwards[18][5][aSubcount] = 0;
    CaseAwards[18][6][aId] = 7; CaseAwards[18][6][aRarity] = 2; CaseAwards[18][6][aType] = 5; CaseAwards[18][6][aInternalId] = 2568; CaseAwards[18][6][aCount] = 0; CaseAwards[18][6][aPriceSprayed] = 110; CaseAwards[18][6][aSubcount] = 0;
    CaseAwards[18][7][aId] = 8; CaseAwards[18][7][aRarity] = 2; CaseAwards[18][7][aType] = 11; CaseAwards[18][7][aInternalId] = 313; CaseAwards[18][7][aCount] = 1; CaseAwards[18][7][aPriceSprayed] = 90; CaseAwards[18][7][aSubcount] = 0;
    CaseAwards[18][8][aId] = 9; CaseAwards[18][8][aRarity] = 3; CaseAwards[18][8][aType] = 11; CaseAwards[18][8][aInternalId] = 134; CaseAwards[18][8][aCount] = 5326; CaseAwards[18][8][aPriceSprayed] = 140; CaseAwards[18][8][aSubcount] = 0;
    CaseAwards[18][9][aId] = 10; CaseAwards[18][9][aRarity] = 3; CaseAwards[18][9][aType] = 11; CaseAwards[18][9][aInternalId] = 1058; CaseAwards[18][9][aCount] = 1; CaseAwards[18][9][aPriceSprayed] = 160; CaseAwards[18][9][aSubcount] = 0;
    CaseAwards[18][10][aId] = 11; CaseAwards[18][10][aRarity] = 3; CaseAwards[18][10][aType] = 5; CaseAwards[18][10][aInternalId] = 603; CaseAwards[18][10][aCount] = 0; CaseAwards[18][10][aPriceSprayed] = 140; CaseAwards[18][10][aSubcount] = 0;
    CaseAwards[18][11][aId] = 12; CaseAwards[18][11][aRarity] = 3; CaseAwards[18][11][aType] = 23; CaseAwards[18][11][aInternalId] = 1; CaseAwards[18][11][aCount] = 7500; CaseAwards[18][11][aPriceSprayed] = 0; CaseAwards[18][11][aSubcount] = 0;
    CaseAwards[18][12][aId] = 13; CaseAwards[18][12][aRarity] = 3; CaseAwards[18][12][aType] = 5; CaseAwards[18][12][aInternalId] = 442; CaseAwards[18][12][aCount] = 0; CaseAwards[18][12][aPriceSprayed] = 170; CaseAwards[18][12][aSubcount] = 0;
    CaseAwards[18][13][aId] = 14; CaseAwards[18][13][aRarity] = 3; CaseAwards[18][13][aType] = 23; CaseAwards[18][13][aInternalId] = 1; CaseAwards[18][13][aCount] = 5000; CaseAwards[18][13][aPriceSprayed] = 0; CaseAwards[18][13][aSubcount] = 0;
    CaseAwards[18][14][aId] = 15; CaseAwards[18][14][aRarity] = 3; CaseAwards[18][14][aType] = 5; CaseAwards[18][14][aInternalId] = 2388; CaseAwards[18][14][aCount] = 0; CaseAwards[18][14][aPriceSprayed] = 210; CaseAwards[18][14][aSubcount] = 0;
    CaseAwards[18][15][aId] = 16; CaseAwards[18][15][aRarity] = 4; CaseAwards[18][15][aType] = 11; CaseAwards[18][15][aInternalId] = 134; CaseAwards[18][15][aCount] = 5500073; CaseAwards[18][15][aPriceSprayed] = 220; CaseAwards[18][15][aSubcount] = 0;
    CaseAwards[18][16][aId] = 17; CaseAwards[18][16][aRarity] = 3; CaseAwards[18][16][aType] = 5; CaseAwards[18][16][aInternalId] = 28720; CaseAwards[18][16][aCount] = 0; CaseAwards[18][16][aPriceSprayed] = 200; CaseAwards[18][16][aSubcount] = 153;
    CaseAwards[18][17][aId] = 18; CaseAwards[18][17][aRarity] = 4; CaseAwards[18][17][aType] = 11; CaseAwards[18][17][aInternalId] = 134; CaseAwards[18][17][aCount] = 5500072; CaseAwards[18][17][aPriceSprayed] = 220; CaseAwards[18][17][aSubcount] = 0;
    CaseAwards[18][18][aId] = 19; CaseAwards[18][18][aRarity] = 4; CaseAwards[18][18][aType] = 11; CaseAwards[18][18][aInternalId] = 1055; CaseAwards[18][18][aCount] = 1; CaseAwards[18][18][aPriceSprayed] = 220; CaseAwards[18][18][aSubcount] = 0;
    CaseAwards[18][19][aId] = 20; CaseAwards[18][19][aRarity] = 4; CaseAwards[18][19][aType] = 11; CaseAwards[18][19][aInternalId] = 1056; CaseAwards[18][19][aCount] = 1; CaseAwards[18][19][aPriceSprayed] = 220; CaseAwards[18][19][aSubcount] = 0;
    CaseAwards[18][20][aId] = 21; CaseAwards[18][20][aRarity] = 4; CaseAwards[18][20][aType] = 11; CaseAwards[18][20][aInternalId] = 134; CaseAwards[18][20][aCount] = 5500074; CaseAwards[18][20][aPriceSprayed] = 220; CaseAwards[18][20][aSubcount] = 0;
    CaseAwards[18][21][aId] = 22; CaseAwards[18][21][aRarity] = 4; CaseAwards[18][21][aType] = 23; CaseAwards[18][21][aInternalId] = 1; CaseAwards[18][21][aCount] = 15000; CaseAwards[18][21][aPriceSprayed] = 0; CaseAwards[18][21][aSubcount] = 0;
    CaseAwards[18][22][aId] = 23; CaseAwards[18][22][aRarity] = 4; CaseAwards[18][22][aType] = 5; CaseAwards[18][22][aInternalId] = 2553; CaseAwards[18][22][aCount] = 0; CaseAwards[18][22][aPriceSprayed] = 240; CaseAwards[18][22][aSubcount] = 0;
    CaseAwards[18][23][aId] = 24; CaseAwards[18][23][aRarity] = 4; CaseAwards[18][23][aType] = 5; CaseAwards[18][23][aInternalId] = 2547; CaseAwards[18][23][aCount] = 0; CaseAwards[18][23][aPriceSprayed] = 250; CaseAwards[18][23][aSubcount] = 0;
    CaseAwards[18][24][aId] = 25; CaseAwards[18][24][aRarity] = 5; CaseAwards[18][24][aType] = 5; CaseAwards[18][24][aInternalId] = 28719; CaseAwards[18][24][aCount] = 0; CaseAwards[18][24][aPriceSprayed] = 800; CaseAwards[18][24][aSubcount] = 152;
    CaseBonus[18][0][bId] = 1; CaseBonus[18][0][bNumberOpen] = 40; CaseBonus[18][0][bRarity] = 5; CaseBonus[18][0][bType] = 5; CaseBonus[18][0][bInternalId] = 28721; CaseBonus[18][0][bCount] = 0; CaseBonus[18][0][bPriceSprayed] = 320;
    CaseBonus[18][1][bId] = 2; CaseBonus[18][1][bNumberOpen] = 30; CaseBonus[18][1][bRarity] = 4; CaseBonus[18][1][bType] = 23; CaseBonus[18][1][bInternalId] = 1; CaseBonus[18][1][bCount] = 10000; CaseBonus[18][1][bPriceSprayed] = 0;
    CaseBonus[18][2][bId] = 3; CaseBonus[18][2][bNumberOpen] = 20; CaseBonus[18][2][bRarity] = 4; CaseBonus[18][2][bType] = 4; CaseBonus[18][2][bInternalId] = 19; CaseBonus[18][2][bCount] = 2; CaseBonus[18][2][bPriceSprayed] = 0;
    CaseBonus[18][3][bId] = 4; CaseBonus[18][3][bNumberOpen] = 10; CaseBonus[18][3][bRarity] = 4; CaseBonus[18][3][bType] = 23; CaseBonus[18][3][bInternalId] = 1; CaseBonus[18][3][bCount] = 5000; CaseBonus[18][3][bPriceSprayed] = 0;
    CaseBonus[18][4][bId] = 5; CaseBonus[18][4][bNumberOpen] = 5; CaseBonus[18][4][bRarity] = 4; CaseBonus[18][4][bType] = 4; CaseBonus[18][4][bInternalId] = 19; CaseBonus[18][4][bCount] = 1; CaseBonus[18][4][bPriceSprayed] = 0;

    // case json id 20
    CaseData[19][cId] = 20;
    CaseData[19][cPriceOne] = 900;
    CaseData[19][cPriceTen] = 9000;
    CaseData[19][cDiscountOne] = 0;
    CaseData[19][cDiscountTen] = 5;
    CaseData[19][cAwardsCount] = 25;
    CaseData[19][cBonusCount] = 5;
    CaseAwards[19][0][aId] = 1; CaseAwards[19][0][aRarity] = 2; CaseAwards[19][0][aType] = 11; CaseAwards[19][0][aInternalId] = 134; CaseAwards[19][0][aCount] = 252; CaseAwards[19][0][aPriceSprayed] = 110; CaseAwards[19][0][aSubcount] = 0;
    CaseAwards[19][1][aId] = 2; CaseAwards[19][1][aRarity] = 2; CaseAwards[19][1][aType] = 11; CaseAwards[19][1][aInternalId] = 917; CaseAwards[19][1][aCount] = 1; CaseAwards[19][1][aPriceSprayed] = 100; CaseAwards[19][1][aSubcount] = 0;
    CaseAwards[19][2][aId] = 3; CaseAwards[19][2][aRarity] = 2; CaseAwards[19][2][aType] = 11; CaseAwards[19][2][aInternalId] = 916; CaseAwards[19][2][aCount] = 1; CaseAwards[19][2][aPriceSprayed] = 100; CaseAwards[19][2][aSubcount] = 0;
    CaseAwards[19][3][aId] = 4; CaseAwards[19][3][aRarity] = 2; CaseAwards[19][3][aType] = 11; CaseAwards[19][3][aInternalId] = 918; CaseAwards[19][3][aCount] = 1; CaseAwards[19][3][aPriceSprayed] = 100; CaseAwards[19][3][aSubcount] = 0;
    CaseAwards[19][4][aId] = 5; CaseAwards[19][4][aRarity] = 2; CaseAwards[19][4][aType] = 3; CaseAwards[19][4][aInternalId] = 1; CaseAwards[19][4][aCount] = 700; CaseAwards[19][4][aPriceSprayed] = 0; CaseAwards[19][4][aSubcount] = 0;
    CaseAwards[19][5][aId] = 6; CaseAwards[19][5][aRarity] = 2; CaseAwards[19][5][aType] = 2; CaseAwards[19][5][aInternalId] = 1; CaseAwards[19][5][aCount] = 900000; CaseAwards[19][5][aPriceSprayed] = 0; CaseAwards[19][5][aSubcount] = 0;
    CaseAwards[19][6][aId] = 7; CaseAwards[19][6][aRarity] = 2; CaseAwards[19][6][aType] = 5; CaseAwards[19][6][aInternalId] = 2568; CaseAwards[19][6][aCount] = 0; CaseAwards[19][6][aPriceSprayed] = 110; CaseAwards[19][6][aSubcount] = 0;
    CaseAwards[19][7][aId] = 8; CaseAwards[19][7][aRarity] = 2; CaseAwards[19][7][aType] = 11; CaseAwards[19][7][aInternalId] = 304; CaseAwards[19][7][aCount] = 1; CaseAwards[19][7][aPriceSprayed] = 90; CaseAwards[19][7][aSubcount] = 0;
    CaseAwards[19][8][aId] = 9; CaseAwards[19][8][aRarity] = 2; CaseAwards[19][8][aType] = 11; CaseAwards[19][8][aInternalId] = 134; CaseAwards[19][8][aCount] = 14388; CaseAwards[19][8][aPriceSprayed] = 100; CaseAwards[19][8][aSubcount] = 0;
    CaseAwards[19][9][aId] = 10; CaseAwards[19][9][aRarity] = 3; CaseAwards[19][9][aType] = 11; CaseAwards[19][9][aInternalId] = 134; CaseAwards[19][9][aCount] = 236; CaseAwards[19][9][aPriceSprayed] = 130; CaseAwards[19][9][aSubcount] = 0;
    CaseAwards[19][10][aId] = 11; CaseAwards[19][10][aRarity] = 3; CaseAwards[19][10][aType] = 11; CaseAwards[19][10][aInternalId] = 134; CaseAwards[19][10][aCount] = 19262; CaseAwards[19][10][aPriceSprayed] = 140; CaseAwards[19][10][aSubcount] = 0;
    CaseAwards[19][11][aId] = 12; CaseAwards[19][11][aRarity] = 3; CaseAwards[19][11][aType] = 5; CaseAwards[19][11][aInternalId] = 603; CaseAwards[19][11][aCount] = 0; CaseAwards[19][11][aPriceSprayed] = 140; CaseAwards[19][11][aSubcount] = 0;
    CaseAwards[19][12][aId] = 13; CaseAwards[19][12][aRarity] = 3; CaseAwards[19][12][aType] = 11; CaseAwards[19][12][aInternalId] = 134; CaseAwards[19][12][aCount] = 11935; CaseAwards[19][12][aPriceSprayed] = 140; CaseAwards[19][12][aSubcount] = 0;
    CaseAwards[19][13][aId] = 14; CaseAwards[19][13][aRarity] = 3; CaseAwards[19][13][aType] = 5; CaseAwards[19][13][aInternalId] = 2382; CaseAwards[19][13][aCount] = 0; CaseAwards[19][13][aPriceSprayed] = 180; CaseAwards[19][13][aSubcount] = 0;
    CaseAwards[19][14][aId] = 15; CaseAwards[19][14][aRarity] = 4; CaseAwards[19][14][aType] = 11; CaseAwards[19][14][aInternalId] = 134; CaseAwards[19][14][aCount] = 5500083; CaseAwards[19][14][aPriceSprayed] = 240; CaseAwards[19][14][aSubcount] = 0;
    CaseAwards[19][15][aId] = 16; CaseAwards[19][15][aRarity] = 2; CaseAwards[19][15][aType] = 11; CaseAwards[19][15][aInternalId] = 360; CaseAwards[19][15][aCount] = 1; CaseAwards[19][15][aPriceSprayed] = 90; CaseAwards[19][15][aSubcount] = 0;
    CaseAwards[19][16][aId] = 17; CaseAwards[19][16][aRarity] = 4; CaseAwards[19][16][aType] = 11; CaseAwards[19][16][aInternalId] = 134; CaseAwards[19][16][aCount] = 5500063; CaseAwards[19][16][aPriceSprayed] = 240; CaseAwards[19][16][aSubcount] = 0;
    CaseAwards[19][17][aId] = 18; CaseAwards[19][17][aRarity] = 4; CaseAwards[19][17][aType] = 11; CaseAwards[19][17][aInternalId] = 134; CaseAwards[19][17][aCount] = 5500062; CaseAwards[19][17][aPriceSprayed] = 230; CaseAwards[19][17][aSubcount] = 0;
    CaseAwards[19][18][aId] = 19; CaseAwards[19][18][aRarity] = 4; CaseAwards[19][18][aType] = 11; CaseAwards[19][18][aInternalId] = 1043; CaseAwards[19][18][aCount] = 1; CaseAwards[19][18][aPriceSprayed] = 220; CaseAwards[19][18][aSubcount] = 0;
    CaseAwards[19][19][aId] = 20; CaseAwards[19][19][aRarity] = 4; CaseAwards[19][19][aType] = 5; CaseAwards[19][19][aInternalId] = 503; CaseAwards[19][19][aCount] = 0; CaseAwards[19][19][aPriceSprayed] = 230; CaseAwards[19][19][aSubcount] = 0;
    CaseAwards[19][20][aId] = 21; CaseAwards[19][20][aRarity] = 4; CaseAwards[19][20][aType] = 11; CaseAwards[19][20][aInternalId] = 1044; CaseAwards[19][20][aCount] = 1; CaseAwards[19][20][aPriceSprayed] = 220; CaseAwards[19][20][aSubcount] = 0;
    CaseAwards[19][21][aId] = 22; CaseAwards[19][21][aRarity] = 4; CaseAwards[19][21][aType] = 5; CaseAwards[19][21][aInternalId] = 429; CaseAwards[19][21][aCount] = 0; CaseAwards[19][21][aPriceSprayed] = 330; CaseAwards[19][21][aSubcount] = 0;
    CaseAwards[19][22][aId] = 23; CaseAwards[19][22][aRarity] = 4; CaseAwards[19][22][aType] = 5; CaseAwards[19][22][aInternalId] = 2547; CaseAwards[19][22][aCount] = 0; CaseAwards[19][22][aPriceSprayed] = 250; CaseAwards[19][22][aSubcount] = 0;
    CaseAwards[19][23][aId] = 24; CaseAwards[19][23][aRarity] = 5; CaseAwards[19][23][aType] = 5; CaseAwards[19][23][aInternalId] = 28724; CaseAwards[19][23][aCount] = 0; CaseAwards[19][23][aPriceSprayed] = 400; CaseAwards[19][23][aSubcount] = 139;
    CaseAwards[19][24][aId] = 25; CaseAwards[19][24][aRarity] = 5; CaseAwards[19][24][aType] = 5; CaseAwards[19][24][aInternalId] = 28723; CaseAwards[19][24][aCount] = 0; CaseAwards[19][24][aPriceSprayed] = 570; CaseAwards[19][24][aSubcount] = 141;
    CaseBonus[19][0][bId] = 1; CaseBonus[19][0][bNumberOpen] = 40; CaseBonus[19][0][bRarity] = 5; CaseBonus[19][0][bType] = 5; CaseBonus[19][0][bInternalId] = 28725; CaseBonus[19][0][bCount] = 0; CaseBonus[19][0][bPriceSprayed] = 320;
    CaseBonus[19][1][bId] = 2; CaseBonus[19][1][bNumberOpen] = 30; CaseBonus[19][1][bRarity] = 3; CaseBonus[19][1][bType] = 2; CaseBonus[19][1][bInternalId] = 1; CaseBonus[19][1][bCount] = 2500000; CaseBonus[19][1][bPriceSprayed] = 0;
    CaseBonus[19][2][bId] = 3; CaseBonus[19][2][bNumberOpen] = 20; CaseBonus[19][2][bRarity] = 4; CaseBonus[19][2][bType] = 4; CaseBonus[19][2][bInternalId] = 20; CaseBonus[19][2][bCount] = 2; CaseBonus[19][2][bPriceSprayed] = 0;
    CaseBonus[19][3][bId] = 4; CaseBonus[19][3][bNumberOpen] = 10; CaseBonus[19][3][bRarity] = 4; CaseBonus[19][3][bType] = 21; CaseBonus[19][3][bInternalId] = 0; CaseBonus[19][3][bCount] = 300; CaseBonus[19][3][bPriceSprayed] = 0;
    CaseBonus[19][4][bId] = 5; CaseBonus[19][4][bNumberOpen] = 5; CaseBonus[19][4][bRarity] = 4; CaseBonus[19][4][bType] = 4; CaseBonus[19][4][bInternalId] = 20; CaseBonus[19][4][bCount] = 1; CaseBonus[19][4][bPriceSprayed] = 0;

    // case json id 21
    CaseData[20][cId] = 21;
    CaseData[20][cPriceOne] = 900;
    CaseData[20][cPriceTen] = 9000;
    CaseData[20][cDiscountOne] = 0;
    CaseData[20][cDiscountTen] = 5;
    CaseData[20][cAwardsCount] = 25;
    CaseData[20][cBonusCount] = 5;
    CaseAwards[20][0][aId] = 1; CaseAwards[20][0][aRarity] = 2; CaseAwards[20][0][aType] = 11; CaseAwards[20][0][aInternalId] = 134; CaseAwards[20][0][aCount] = 11917; CaseAwards[20][0][aPriceSprayed] = 110; CaseAwards[20][0][aSubcount] = 0;
    CaseAwards[20][1][aId] = 2; CaseAwards[20][1][aRarity] = 2; CaseAwards[20][1][aType] = 11; CaseAwards[20][1][aInternalId] = 367; CaseAwards[20][1][aCount] = 1; CaseAwards[20][1][aPriceSprayed] = 70; CaseAwards[20][1][aSubcount] = 0;
    CaseAwards[20][2][aId] = 3; CaseAwards[20][2][aRarity] = 2; CaseAwards[20][2][aType] = 11; CaseAwards[20][2][aInternalId] = 361; CaseAwards[20][2][aCount] = 1; CaseAwards[20][2][aPriceSprayed] = 90; CaseAwards[20][2][aSubcount] = 0;
    CaseAwards[20][3][aId] = 4; CaseAwards[20][3][aRarity] = 2; CaseAwards[20][3][aType] = 11; CaseAwards[20][3][aInternalId] = 918; CaseAwards[20][3][aCount] = 1; CaseAwards[20][3][aPriceSprayed] = 100; CaseAwards[20][3][aSubcount] = 0;
    CaseAwards[20][4][aId] = 5; CaseAwards[20][4][aRarity] = 2; CaseAwards[20][4][aType] = 3; CaseAwards[20][4][aInternalId] = 1; CaseAwards[20][4][aCount] = 700; CaseAwards[20][4][aPriceSprayed] = 0; CaseAwards[20][4][aSubcount] = 0;
    CaseAwards[20][5][aId] = 6; CaseAwards[20][5][aRarity] = 2; CaseAwards[20][5][aType] = 2; CaseAwards[20][5][aInternalId] = 1; CaseAwards[20][5][aCount] = 900000; CaseAwards[20][5][aPriceSprayed] = 0; CaseAwards[20][5][aSubcount] = 0;
    CaseAwards[20][6][aId] = 7; CaseAwards[20][6][aRarity] = 2; CaseAwards[20][6][aType] = 5; CaseAwards[20][6][aInternalId] = 2568; CaseAwards[20][6][aCount] = 0; CaseAwards[20][6][aPriceSprayed] = 110; CaseAwards[20][6][aSubcount] = 0;
    CaseAwards[20][7][aId] = 8; CaseAwards[20][7][aRarity] = 2; CaseAwards[20][7][aType] = 11; CaseAwards[20][7][aInternalId] = 324; CaseAwards[20][7][aCount] = 1; CaseAwards[20][7][aPriceSprayed] = 90; CaseAwards[20][7][aSubcount] = 0;
    CaseAwards[20][8][aId] = 9; CaseAwards[20][8][aRarity] = 2; CaseAwards[20][8][aType] = 11; CaseAwards[20][8][aInternalId] = 134; CaseAwards[20][8][aCount] = 14386; CaseAwards[20][8][aPriceSprayed] = 100; CaseAwards[20][8][aSubcount] = 0;
    CaseAwards[20][9][aId] = 10; CaseAwards[20][9][aRarity] = 3; CaseAwards[20][9][aType] = 11; CaseAwards[20][9][aInternalId] = 134; CaseAwards[20][9][aCount] = 236; CaseAwards[20][9][aPriceSprayed] = 130; CaseAwards[20][9][aSubcount] = 0;
    CaseAwards[20][10][aId] = 11; CaseAwards[20][10][aRarity] = 3; CaseAwards[20][10][aType] = 2; CaseAwards[20][10][aInternalId] = 1; CaseAwards[20][10][aCount] = 1200000; CaseAwards[20][10][aPriceSprayed] = 0; CaseAwards[20][10][aSubcount] = 0;
    CaseAwards[20][11][aId] = 12; CaseAwards[20][11][aRarity] = 3; CaseAwards[20][11][aType] = 5; CaseAwards[20][11][aInternalId] = 603; CaseAwards[20][11][aCount] = 0; CaseAwards[20][11][aPriceSprayed] = 150; CaseAwards[20][11][aSubcount] = 0;
    CaseAwards[20][12][aId] = 13; CaseAwards[20][12][aRarity] = 3; CaseAwards[20][12][aType] = 11; CaseAwards[20][12][aInternalId] = 134; CaseAwards[20][12][aCount] = 11935; CaseAwards[20][12][aPriceSprayed] = 140; CaseAwards[20][12][aSubcount] = 0;
    CaseAwards[20][13][aId] = 14; CaseAwards[20][13][aRarity] = 3; CaseAwards[20][13][aType] = 2; CaseAwards[20][13][aInternalId] = 1; CaseAwards[20][13][aCount] = 1500000; CaseAwards[20][13][aPriceSprayed] = 0; CaseAwards[20][13][aSubcount] = 0;
    CaseAwards[20][14][aId] = 15; CaseAwards[20][14][aRarity] = 3; CaseAwards[20][14][aType] = 5; CaseAwards[20][14][aInternalId] = 2388; CaseAwards[20][14][aCount] = 0; CaseAwards[20][14][aPriceSprayed] = 210; CaseAwards[20][14][aSubcount] = 0;
    CaseAwards[20][15][aId] = 16; CaseAwards[20][15][aRarity] = 4; CaseAwards[20][15][aType] = 11; CaseAwards[20][15][aInternalId] = 134; CaseAwards[20][15][aCount] = 5500081; CaseAwards[20][15][aPriceSprayed] = 230; CaseAwards[20][15][aSubcount] = 0;
    CaseAwards[20][16][aId] = 17; CaseAwards[20][16][aRarity] = 4; CaseAwards[20][16][aType] = 11; CaseAwards[20][16][aInternalId] = 1066; CaseAwards[20][16][aCount] = 1; CaseAwards[20][16][aPriceSprayed] = 230; CaseAwards[20][16][aSubcount] = 0;
    CaseAwards[20][17][aId] = 18; CaseAwards[20][17][aRarity] = 4; CaseAwards[20][17][aType] = 11; CaseAwards[20][17][aInternalId] = 134; CaseAwards[20][17][aCount] = 5500082; CaseAwards[20][17][aPriceSprayed] = 220; CaseAwards[20][17][aSubcount] = 0;
    CaseAwards[20][18][aId] = 19; CaseAwards[20][18][aRarity] = 4; CaseAwards[20][18][aType] = 11; CaseAwards[20][18][aInternalId] = 1067; CaseAwards[20][18][aCount] = 1; CaseAwards[20][18][aPriceSprayed] = 220; CaseAwards[20][18][aSubcount] = 0;
    CaseAwards[20][19][aId] = 20; CaseAwards[20][19][aRarity] = 4; CaseAwards[20][19][aType] = 5; CaseAwards[20][19][aInternalId] = 503; CaseAwards[20][19][aCount] = 0; CaseAwards[20][19][aPriceSprayed] = 230; CaseAwards[20][19][aSubcount] = 0;
    CaseAwards[20][20][aId] = 21; CaseAwards[20][20][aRarity] = 4; CaseAwards[20][20][aType] = 2; CaseAwards[20][20][aInternalId] = 1; CaseAwards[20][20][aCount] = 3000000; CaseAwards[20][20][aPriceSprayed] = 0; CaseAwards[20][20][aSubcount] = 0;
    CaseAwards[20][21][aId] = 22; CaseAwards[20][21][aRarity] = 4; CaseAwards[20][21][aType] = 5; CaseAwards[20][21][aInternalId] = 2553; CaseAwards[20][21][aCount] = 0; CaseAwards[20][21][aPriceSprayed] = 240; CaseAwards[20][21][aSubcount] = 0;
    CaseAwards[20][22][aId] = 23; CaseAwards[20][22][aRarity] = 4; CaseAwards[20][22][aType] = 5; CaseAwards[20][22][aInternalId] = 2547; CaseAwards[20][22][aCount] = 0; CaseAwards[20][22][aPriceSprayed] = 250; CaseAwards[20][22][aSubcount] = 0;
    CaseAwards[20][23][aId] = 24; CaseAwards[20][23][aRarity] = 4; CaseAwards[20][23][aType] = 5; CaseAwards[20][23][aInternalId] = 490; CaseAwards[20][23][aCount] = 0; CaseAwards[20][23][aPriceSprayed] = 290; CaseAwards[20][23][aSubcount] = 0;
    CaseAwards[20][24][aId] = 25; CaseAwards[20][24][aRarity] = 5; CaseAwards[20][24][aType] = 5; CaseAwards[20][24][aInternalId] = 28731; CaseAwards[20][24][aCount] = 0; CaseAwards[20][24][aPriceSprayed] = 800; CaseAwards[20][24][aSubcount] = 161;
    CaseBonus[20][0][bId] = 1; CaseBonus[20][0][bNumberOpen] = 40; CaseBonus[20][0][bRarity] = 5; CaseBonus[20][0][bType] = 5; CaseBonus[20][0][bInternalId] = 28732; CaseBonus[20][0][bCount] = 0; CaseBonus[20][0][bPriceSprayed] = 320;
    CaseBonus[20][1][bId] = 2; CaseBonus[20][1][bNumberOpen] = 30; CaseBonus[20][1][bRarity] = 3; CaseBonus[20][1][bType] = 2; CaseBonus[20][1][bInternalId] = 1; CaseBonus[20][1][bCount] = 2500000; CaseBonus[20][1][bPriceSprayed] = 0;
    CaseBonus[20][2][bId] = 3; CaseBonus[20][2][bNumberOpen] = 20; CaseBonus[20][2][bRarity] = 4; CaseBonus[20][2][bType] = 4; CaseBonus[20][2][bInternalId] = 21; CaseBonus[20][2][bCount] = 2; CaseBonus[20][2][bPriceSprayed] = 0;
    CaseBonus[20][3][bId] = 4; CaseBonus[20][3][bNumberOpen] = 10; CaseBonus[20][3][bRarity] = 3; CaseBonus[20][3][bType] = 2; CaseBonus[20][3][bInternalId] = 1; CaseBonus[20][3][bCount] = 1200000; CaseBonus[20][3][bPriceSprayed] = 0;
    CaseBonus[20][4][bId] = 5; CaseBonus[20][4][bNumberOpen] = 5; CaseBonus[20][4][bRarity] = 4; CaseBonus[20][4][bType] = 4; CaseBonus[20][4][bInternalId] = 21; CaseBonus[20][4][bCount] = 1; CaseBonus[20][4][bPriceSprayed] = 0;

    // case json id 22
    CaseData[21][cId] = 22;
    CaseData[21][cPriceOne] = 900;
    CaseData[21][cPriceTen] = 9000;
    CaseData[21][cDiscountOne] = 0;
    CaseData[21][cDiscountTen] = 5;
    CaseData[21][cAwardsCount] = 25;
    CaseData[21][cBonusCount] = 5;
    CaseAwards[21][0][aId] = 1; CaseAwards[21][0][aRarity] = 2; CaseAwards[21][0][aType] = 11; CaseAwards[21][0][aInternalId] = 376; CaseAwards[21][0][aCount] = 1; CaseAwards[21][0][aPriceSprayed] = 70; CaseAwards[21][0][aSubcount] = 0;
    CaseAwards[21][1][aId] = 2; CaseAwards[21][1][aRarity] = 2; CaseAwards[21][1][aType] = 11; CaseAwards[21][1][aInternalId] = 365; CaseAwards[21][1][aCount] = 1; CaseAwards[21][1][aPriceSprayed] = 80; CaseAwards[21][1][aSubcount] = 0;
    CaseAwards[21][2][aId] = 3; CaseAwards[21][2][aRarity] = 2; CaseAwards[21][2][aType] = 11; CaseAwards[21][2][aInternalId] = 304; CaseAwards[21][2][aCount] = 1; CaseAwards[21][2][aPriceSprayed] = 90; CaseAwards[21][2][aSubcount] = 0;
    CaseAwards[21][3][aId] = 4; CaseAwards[21][3][aRarity] = 2; CaseAwards[21][3][aType] = 11; CaseAwards[21][3][aInternalId] = 914; CaseAwards[21][3][aCount] = 1; CaseAwards[21][3][aPriceSprayed] = 100; CaseAwards[21][3][aSubcount] = 0;
    CaseAwards[21][4][aId] = 5; CaseAwards[21][4][aRarity] = 2; CaseAwards[21][4][aType] = 11; CaseAwards[21][4][aInternalId] = 134; CaseAwards[21][4][aCount] = 14388; CaseAwards[21][4][aPriceSprayed] = 100; CaseAwards[21][4][aSubcount] = 0;
    CaseAwards[21][5][aId] = 6; CaseAwards[21][5][aRarity] = 2; CaseAwards[21][5][aType] = 11; CaseAwards[21][5][aInternalId] = 134; CaseAwards[21][5][aCount] = 11917; CaseAwards[21][5][aPriceSprayed] = 110; CaseAwards[21][5][aSubcount] = 0;
    CaseAwards[21][6][aId] = 7; CaseAwards[21][6][aRarity] = 2; CaseAwards[21][6][aType] = 3; CaseAwards[21][6][aInternalId] = 1; CaseAwards[21][6][aCount] = 700; CaseAwards[21][6][aPriceSprayed] = 0; CaseAwards[21][6][aSubcount] = 0;
    CaseAwards[21][7][aId] = 8; CaseAwards[21][7][aRarity] = 2; CaseAwards[21][7][aType] = 5; CaseAwards[21][7][aInternalId] = 2568; CaseAwards[21][7][aCount] = 0; CaseAwards[21][7][aPriceSprayed] = 110; CaseAwards[21][7][aSubcount] = 0;
    CaseAwards[21][8][aId] = 9; CaseAwards[21][8][aRarity] = 2; CaseAwards[21][8][aType] = 2; CaseAwards[21][8][aInternalId] = 1; CaseAwards[21][8][aCount] = 900000; CaseAwards[21][8][aPriceSprayed] = 0; CaseAwards[21][8][aSubcount] = 0;
    CaseAwards[21][9][aId] = 10; CaseAwards[21][9][aRarity] = 3; CaseAwards[21][9][aType] = 11; CaseAwards[21][9][aInternalId] = 134; CaseAwards[21][9][aCount] = 236; CaseAwards[21][9][aPriceSprayed] = 130; CaseAwards[21][9][aSubcount] = 0;
    CaseAwards[21][10][aId] = 11; CaseAwards[21][10][aRarity] = 3; CaseAwards[21][10][aType] = 11; CaseAwards[21][10][aInternalId] = 134; CaseAwards[21][10][aCount] = 11935; CaseAwards[21][10][aPriceSprayed] = 140; CaseAwards[21][10][aSubcount] = 0;
    CaseAwards[21][11][aId] = 12; CaseAwards[21][11][aRarity] = 3; CaseAwards[21][11][aType] = 2; CaseAwards[21][11][aInternalId] = 1; CaseAwards[21][11][aCount] = 1200000; CaseAwards[21][11][aPriceSprayed] = 0; CaseAwards[21][11][aSubcount] = 0;
    CaseAwards[21][12][aId] = 13; CaseAwards[21][12][aRarity] = 3; CaseAwards[21][12][aType] = 5; CaseAwards[21][12][aInternalId] = 603; CaseAwards[21][12][aCount] = 0; CaseAwards[21][12][aPriceSprayed] = 150; CaseAwards[21][12][aSubcount] = 0;
    CaseAwards[21][13][aId] = 14; CaseAwards[21][13][aRarity] = 3; CaseAwards[21][13][aType] = 2; CaseAwards[21][13][aInternalId] = 1; CaseAwards[21][13][aCount] = 1500000; CaseAwards[21][13][aPriceSprayed] = 0; CaseAwards[21][13][aSubcount] = 0;
    CaseAwards[21][14][aId] = 15; CaseAwards[21][14][aRarity] = 3; CaseAwards[21][14][aType] = 11; CaseAwards[21][14][aInternalId] = 134; CaseAwards[21][14][aCount] = 5500100; CaseAwards[21][14][aPriceSprayed] = 200; CaseAwards[21][14][aSubcount] = 0;
    CaseAwards[21][15][aId] = 16; CaseAwards[21][15][aRarity] = 3; CaseAwards[21][15][aType] = 5; CaseAwards[21][15][aInternalId] = 2388; CaseAwards[21][15][aCount] = 0; CaseAwards[21][15][aPriceSprayed] = 210; CaseAwards[21][15][aSubcount] = 0;
    CaseAwards[21][16][aId] = 17; CaseAwards[21][16][aRarity] = 4; CaseAwards[21][16][aType] = 11; CaseAwards[21][16][aInternalId] = 1081; CaseAwards[21][16][aCount] = 1; CaseAwards[21][16][aPriceSprayed] = 220; CaseAwards[21][16][aSubcount] = 0;
    CaseAwards[21][17][aId] = 18; CaseAwards[21][17][aRarity] = 4; CaseAwards[21][17][aType] = 11; CaseAwards[21][17][aInternalId] = 134; CaseAwards[21][17][aCount] = 5500099; CaseAwards[21][17][aPriceSprayed] = 220; CaseAwards[21][17][aSubcount] = 0;
    CaseAwards[21][18][aId] = 19; CaseAwards[21][18][aRarity] = 4; CaseAwards[21][18][aType] = 11; CaseAwards[21][18][aInternalId] = 1082; CaseAwards[21][18][aCount] = 1; CaseAwards[21][18][aPriceSprayed] = 220; CaseAwards[21][18][aSubcount] = 0;
    CaseAwards[21][19][aId] = 20; CaseAwards[21][19][aRarity] = 4; CaseAwards[21][19][aType] = 2; CaseAwards[21][19][aInternalId] = 1; CaseAwards[21][19][aCount] = 3000000; CaseAwards[21][19][aPriceSprayed] = 0; CaseAwards[21][19][aSubcount] = 0;
    CaseAwards[21][20][aId] = 21; CaseAwards[21][20][aRarity] = 4; CaseAwards[21][20][aType] = 5; CaseAwards[21][20][aInternalId] = 503; CaseAwards[21][20][aCount] = 0; CaseAwards[21][20][aPriceSprayed] = 230; CaseAwards[21][20][aSubcount] = 0;
    CaseAwards[21][21][aId] = 22; CaseAwards[21][21][aRarity] = 4; CaseAwards[21][21][aType] = 5; CaseAwards[21][21][aInternalId] = 2553; CaseAwards[21][21][aCount] = 0; CaseAwards[21][21][aPriceSprayed] = 240; CaseAwards[21][21][aSubcount] = 0;
    CaseAwards[21][22][aId] = 23; CaseAwards[21][22][aRarity] = 4; CaseAwards[21][22][aType] = 5; CaseAwards[21][22][aInternalId] = 2547; CaseAwards[21][22][aCount] = 0; CaseAwards[21][22][aPriceSprayed] = 250; CaseAwards[21][22][aSubcount] = 0;
    CaseAwards[21][23][aId] = 24; CaseAwards[21][23][aRarity] = 4; CaseAwards[21][23][aType] = 5; CaseAwards[21][23][aInternalId] = 490; CaseAwards[21][23][aCount] = 0; CaseAwards[21][23][aPriceSprayed] = 290; CaseAwards[21][23][aSubcount] = 0;
    CaseAwards[21][24][aId] = 25; CaseAwards[21][24][aRarity] = 5; CaseAwards[21][24][aType] = 5; CaseAwards[21][24][aInternalId] = 28738; CaseAwards[21][24][aCount] = 0; CaseAwards[21][24][aPriceSprayed] = 750; CaseAwards[21][24][aSubcount] = 169;
    CaseBonus[21][0][bId] = 1; CaseBonus[21][0][bNumberOpen] = 40; CaseBonus[21][0][bRarity] = 5; CaseBonus[21][0][bType] = 5; CaseBonus[21][0][bInternalId] = 28739; CaseBonus[21][0][bCount] = 0; CaseBonus[21][0][bPriceSprayed] = 320;
    CaseBonus[21][1][bId] = 2; CaseBonus[21][1][bNumberOpen] = 30; CaseBonus[21][1][bRarity] = 3; CaseBonus[21][1][bType] = 2; CaseBonus[21][1][bInternalId] = 1; CaseBonus[21][1][bCount] = 2500000; CaseBonus[21][1][bPriceSprayed] = 0;
    CaseBonus[21][2][bId] = 3; CaseBonus[21][2][bNumberOpen] = 20; CaseBonus[21][2][bRarity] = 4; CaseBonus[21][2][bType] = 4; CaseBonus[21][2][bInternalId] = 22; CaseBonus[21][2][bCount] = 2; CaseBonus[21][2][bPriceSprayed] = 0;
    CaseBonus[21][3][bId] = 4; CaseBonus[21][3][bNumberOpen] = 10; CaseBonus[21][3][bRarity] = 3; CaseBonus[21][3][bType] = 2; CaseBonus[21][3][bInternalId] = 1; CaseBonus[21][3][bCount] = 1200000; CaseBonus[21][3][bPriceSprayed] = 0;
    CaseBonus[21][4][bId] = 5; CaseBonus[21][4][bNumberOpen] = 5; CaseBonus[21][4][bRarity] = 4; CaseBonus[21][4][bType] = 4; CaseBonus[21][4][bInternalId] = 22; CaseBonus[21][4][bCount] = 1; CaseBonus[21][4][bPriceSprayed] = 0;

    // case json id 23
    CaseData[22][cId] = 23;
    CaseData[22][cPriceOne] = 900;
    CaseData[22][cPriceTen] = 9000;
    CaseData[22][cDiscountOne] = 0;
    CaseData[22][cDiscountTen] = 5;
    CaseData[22][cAwardsCount] = 25;
    CaseData[22][cBonusCount] = 5;
    CaseAwards[22][0][aId] = 1; CaseAwards[22][0][aRarity] = 2; CaseAwards[22][0][aType] = 11; CaseAwards[22][0][aInternalId] = 368; CaseAwards[22][0][aCount] = 1; CaseAwards[22][0][aPriceSprayed] = 70; CaseAwards[22][0][aSubcount] = 0;
    CaseAwards[22][1][aId] = 2; CaseAwards[22][1][aRarity] = 2; CaseAwards[22][1][aType] = 11; CaseAwards[22][1][aInternalId] = 362; CaseAwards[22][1][aCount] = 1; CaseAwards[22][1][aPriceSprayed] = 90; CaseAwards[22][1][aSubcount] = 0;
    CaseAwards[22][2][aId] = 3; CaseAwards[22][2][aRarity] = 3; CaseAwards[22][2][aType] = 11; CaseAwards[22][2][aInternalId] = 303; CaseAwards[22][2][aCount] = 1; CaseAwards[22][2][aPriceSprayed] = 90; CaseAwards[22][2][aSubcount] = 0;
    CaseAwards[22][3][aId] = 4; CaseAwards[22][3][aRarity] = 2; CaseAwards[22][3][aType] = 11; CaseAwards[22][3][aInternalId] = 917; CaseAwards[22][3][aCount] = 1; CaseAwards[22][3][aPriceSprayed] = 100; CaseAwards[22][3][aSubcount] = 0;
    CaseAwards[22][4][aId] = 5; CaseAwards[22][4][aRarity] = 2; CaseAwards[22][4][aType] = 11; CaseAwards[22][4][aInternalId] = 134; CaseAwards[22][4][aCount] = 14388; CaseAwards[22][4][aPriceSprayed] = 100; CaseAwards[22][4][aSubcount] = 0;
    CaseAwards[22][5][aId] = 6; CaseAwards[22][5][aRarity] = 2; CaseAwards[22][5][aType] = 11; CaseAwards[22][5][aInternalId] = 134; CaseAwards[22][5][aCount] = 11917; CaseAwards[22][5][aPriceSprayed] = 110; CaseAwards[22][5][aSubcount] = 0;
    CaseAwards[22][6][aId] = 7; CaseAwards[22][6][aRarity] = 2; CaseAwards[22][6][aType] = 3; CaseAwards[22][6][aInternalId] = 1; CaseAwards[22][6][aCount] = 700; CaseAwards[22][6][aPriceSprayed] = 0; CaseAwards[22][6][aSubcount] = 0;
    CaseAwards[22][7][aId] = 8; CaseAwards[22][7][aRarity] = 2; CaseAwards[22][7][aType] = 5; CaseAwards[22][7][aInternalId] = 2568; CaseAwards[22][7][aCount] = 0; CaseAwards[22][7][aPriceSprayed] = 110; CaseAwards[22][7][aSubcount] = 0;
    CaseAwards[22][8][aId] = 9; CaseAwards[22][8][aRarity] = 2; CaseAwards[22][8][aType] = 2; CaseAwards[22][8][aInternalId] = 1; CaseAwards[22][8][aCount] = 900000; CaseAwards[22][8][aPriceSprayed] = 0; CaseAwards[22][8][aSubcount] = 0;
    CaseAwards[22][9][aId] = 10; CaseAwards[22][9][aRarity] = 3; CaseAwards[22][9][aType] = 11; CaseAwards[22][9][aInternalId] = 134; CaseAwards[22][9][aCount] = 236; CaseAwards[22][9][aPriceSprayed] = 130; CaseAwards[22][9][aSubcount] = 0;
    CaseAwards[22][10][aId] = 11; CaseAwards[22][10][aRarity] = 3; CaseAwards[22][10][aType] = 11; CaseAwards[22][10][aInternalId] = 134; CaseAwards[22][10][aCount] = 11935; CaseAwards[22][10][aPriceSprayed] = 140; CaseAwards[22][10][aSubcount] = 0;
    CaseAwards[22][11][aId] = 12; CaseAwards[22][11][aRarity] = 3; CaseAwards[22][11][aType] = 2; CaseAwards[22][11][aInternalId] = 1; CaseAwards[22][11][aCount] = 1200000; CaseAwards[22][11][aPriceSprayed] = 0; CaseAwards[22][11][aSubcount] = 0;
    CaseAwards[22][12][aId] = 13; CaseAwards[22][12][aRarity] = 3; CaseAwards[22][12][aType] = 5; CaseAwards[22][12][aInternalId] = 603; CaseAwards[22][12][aCount] = 0; CaseAwards[22][12][aPriceSprayed] = 150; CaseAwards[22][12][aSubcount] = 0;
    CaseAwards[22][13][aId] = 14; CaseAwards[22][13][aRarity] = 3; CaseAwards[22][13][aType] = 2; CaseAwards[22][13][aInternalId] = 1; CaseAwards[22][13][aCount] = 1500000; CaseAwards[22][13][aPriceSprayed] = 0; CaseAwards[22][13][aSubcount] = 0;
    CaseAwards[22][14][aId] = 15; CaseAwards[22][14][aRarity] = 3; CaseAwards[22][14][aType] = 5; CaseAwards[22][14][aInternalId] = 2388; CaseAwards[22][14][aCount] = 0; CaseAwards[22][14][aPriceSprayed] = 210; CaseAwards[22][14][aSubcount] = 0;
    CaseAwards[22][15][aId] = 16; CaseAwards[22][15][aRarity] = 4; CaseAwards[22][15][aType] = 11; CaseAwards[22][15][aInternalId] = 134; CaseAwards[22][15][aCount] = 5500102; CaseAwards[22][15][aPriceSprayed] = 220; CaseAwards[22][15][aSubcount] = 0;
    CaseAwards[22][16][aId] = 17; CaseAwards[22][16][aRarity] = 4; CaseAwards[22][16][aType] = 11; CaseAwards[22][16][aInternalId] = 1083; CaseAwards[22][16][aCount] = 1; CaseAwards[22][16][aPriceSprayed] = 220; CaseAwards[22][16][aSubcount] = 0;
    CaseAwards[22][17][aId] = 18; CaseAwards[22][17][aRarity] = 4; CaseAwards[22][17][aType] = 11; CaseAwards[22][17][aInternalId] = 134; CaseAwards[22][17][aCount] = 5500101; CaseAwards[22][17][aPriceSprayed] = 220; CaseAwards[22][17][aSubcount] = 0;
    CaseAwards[22][18][aId] = 19; CaseAwards[22][18][aRarity] = 4; CaseAwards[22][18][aType] = 11; CaseAwards[22][18][aInternalId] = 1084; CaseAwards[22][18][aCount] = 1; CaseAwards[22][18][aPriceSprayed] = 220; CaseAwards[22][18][aSubcount] = 0;
    CaseAwards[22][19][aId] = 20; CaseAwards[22][19][aRarity] = 4; CaseAwards[22][19][aType] = 2; CaseAwards[22][19][aInternalId] = 1; CaseAwards[22][19][aCount] = 3000000; CaseAwards[22][19][aPriceSprayed] = 0; CaseAwards[22][19][aSubcount] = 0;
    CaseAwards[22][20][aId] = 21; CaseAwards[22][20][aRarity] = 4; CaseAwards[22][20][aType] = 5; CaseAwards[22][20][aInternalId] = 28741; CaseAwards[22][20][aCount] = 0; CaseAwards[22][20][aPriceSprayed] = 220; CaseAwards[22][20][aSubcount] = 172;
    CaseAwards[22][21][aId] = 22; CaseAwards[22][21][aRarity] = 4; CaseAwards[22][21][aType] = 5; CaseAwards[22][21][aInternalId] = 503; CaseAwards[22][21][aCount] = 0; CaseAwards[22][21][aPriceSprayed] = 230; CaseAwards[22][21][aSubcount] = 0;
    CaseAwards[22][22][aId] = 23; CaseAwards[22][22][aRarity] = 4; CaseAwards[22][22][aType] = 5; CaseAwards[22][22][aInternalId] = 2553; CaseAwards[22][22][aCount] = 0; CaseAwards[22][22][aPriceSprayed] = 240; CaseAwards[22][22][aSubcount] = 0;
    CaseAwards[22][23][aId] = 24; CaseAwards[22][23][aRarity] = 4; CaseAwards[22][23][aType] = 5; CaseAwards[22][23][aInternalId] = 490; CaseAwards[22][23][aCount] = 0; CaseAwards[22][23][aPriceSprayed] = 290; CaseAwards[22][23][aSubcount] = 0;
    CaseAwards[22][24][aId] = 25; CaseAwards[22][24][aRarity] = 5; CaseAwards[22][24][aType] = 5; CaseAwards[22][24][aInternalId] = 28740; CaseAwards[22][24][aCount] = 0; CaseAwards[22][24][aPriceSprayed] = 700; CaseAwards[22][24][aSubcount] = 171;
    CaseBonus[22][0][bId] = 1; CaseBonus[22][0][bNumberOpen] = 40; CaseBonus[22][0][bRarity] = 5; CaseBonus[22][0][bType] = 5; CaseBonus[22][0][bInternalId] = 28742; CaseBonus[22][0][bCount] = 0; CaseBonus[22][0][bPriceSprayed] = 320;
    CaseBonus[22][1][bId] = 2; CaseBonus[22][1][bNumberOpen] = 30; CaseBonus[22][1][bRarity] = 3; CaseBonus[22][1][bType] = 2; CaseBonus[22][1][bInternalId] = 1; CaseBonus[22][1][bCount] = 2500000; CaseBonus[22][1][bPriceSprayed] = 0;
    CaseBonus[22][2][bId] = 3; CaseBonus[22][2][bNumberOpen] = 20; CaseBonus[22][2][bRarity] = 4; CaseBonus[22][2][bType] = 4; CaseBonus[22][2][bInternalId] = 23; CaseBonus[22][2][bCount] = 2; CaseBonus[22][2][bPriceSprayed] = 0;
    CaseBonus[22][3][bId] = 4; CaseBonus[22][3][bNumberOpen] = 10; CaseBonus[22][3][bRarity] = 3; CaseBonus[22][3][bType] = 2; CaseBonus[22][3][bInternalId] = 1; CaseBonus[22][3][bCount] = 1200000; CaseBonus[22][3][bPriceSprayed] = 0;
    CaseBonus[22][4][bId] = 5; CaseBonus[22][4][bNumberOpen] = 5; CaseBonus[22][4][bRarity] = 4; CaseBonus[22][4][bType] = 4; CaseBonus[22][4][bInternalId] = 23; CaseBonus[22][4][bCount] = 1; CaseBonus[22][4][bPriceSprayed] = 0;

    // case json id 25
    CaseData[23][cId] = 25;
    CaseData[23][cPriceOne] = 2000;
    CaseData[23][cPriceTen] = 20000;
    CaseData[23][cDiscountOne] = 0;
    CaseData[23][cDiscountTen] = 25;
    CaseData[23][cAwardsCount] = 25;
    CaseData[23][cBonusCount] = 5;
    CaseAwards[23][0][aId] = 1; CaseAwards[23][0][aRarity] = 3; CaseAwards[23][0][aType] = 5; CaseAwards[23][0][aInternalId] = 436; CaseAwards[23][0][aCount] = 0; CaseAwards[23][0][aPriceSprayed] = 130; CaseAwards[23][0][aSubcount] = 0;
    CaseAwards[23][1][aId] = 2; CaseAwards[23][1][aRarity] = 3; CaseAwards[23][1][aType] = 5; CaseAwards[23][1][aInternalId] = 2567; CaseAwards[23][1][aCount] = 0; CaseAwards[23][1][aPriceSprayed] = 130; CaseAwards[23][1][aSubcount] = 0;
    CaseAwards[23][2][aId] = 3; CaseAwards[23][2][aRarity] = 3; CaseAwards[23][2][aType] = 5; CaseAwards[23][2][aInternalId] = 2631; CaseAwards[23][2][aCount] = 0; CaseAwards[23][2][aPriceSprayed] = 140; CaseAwards[23][2][aSubcount] = 0;
    CaseAwards[23][3][aId] = 4; CaseAwards[23][3][aRarity] = 3; CaseAwards[23][3][aType] = 5; CaseAwards[23][3][aInternalId] = 565; CaseAwards[23][3][aCount] = 0; CaseAwards[23][3][aPriceSprayed] = 150; CaseAwards[23][3][aSubcount] = 0;
    CaseAwards[23][4][aId] = 5; CaseAwards[23][4][aRarity] = 4; CaseAwards[23][4][aType] = 5; CaseAwards[23][4][aInternalId] = 28694; CaseAwards[23][4][aCount] = 0; CaseAwards[23][4][aPriceSprayed] = 220; CaseAwards[23][4][aSubcount] = 0;
    CaseAwards[23][5][aId] = 6; CaseAwards[23][5][aRarity] = 4; CaseAwards[23][5][aType] = 5; CaseAwards[23][5][aInternalId] = 402; CaseAwards[23][5][aCount] = 0; CaseAwards[23][5][aPriceSprayed] = 240; CaseAwards[23][5][aSubcount] = 0;
    CaseAwards[23][6][aId] = 7; CaseAwards[23][6][aRarity] = 4; CaseAwards[23][6][aType] = 5; CaseAwards[23][6][aInternalId] = 505; CaseAwards[23][6][aCount] = 0; CaseAwards[23][6][aPriceSprayed] = 240; CaseAwards[23][6][aSubcount] = 0;
    CaseAwards[23][7][aId] = 8; CaseAwards[23][7][aRarity] = 4; CaseAwards[23][7][aType] = 5; CaseAwards[23][7][aInternalId] = 2598; CaseAwards[23][7][aCount] = 0; CaseAwards[23][7][aPriceSprayed] = 250; CaseAwards[23][7][aSubcount] = 0;
    CaseAwards[23][8][aId] = 9; CaseAwards[23][8][aRarity] = 4; CaseAwards[23][8][aType] = 5; CaseAwards[23][8][aInternalId] = 2547; CaseAwards[23][8][aCount] = 0; CaseAwards[23][8][aPriceSprayed] = 250; CaseAwards[23][8][aSubcount] = 0;
    CaseAwards[23][9][aId] = 10; CaseAwards[23][9][aRarity] = 4; CaseAwards[23][9][aType] = 5; CaseAwards[23][9][aInternalId] = 28697; CaseAwards[23][9][aCount] = 0; CaseAwards[23][9][aPriceSprayed] = 260; CaseAwards[23][9][aSubcount] = 0;
    CaseAwards[23][10][aId] = 11; CaseAwards[23][10][aRarity] = 4; CaseAwards[23][10][aType] = 5; CaseAwards[23][10][aInternalId] = 400; CaseAwards[23][10][aCount] = 0; CaseAwards[23][10][aPriceSprayed] = 260; CaseAwards[23][10][aSubcount] = 0;
    CaseAwards[23][11][aId] = 12; CaseAwards[23][11][aRarity] = 4; CaseAwards[23][11][aType] = 5; CaseAwards[23][11][aInternalId] = 506; CaseAwards[23][11][aCount] = 0; CaseAwards[23][11][aPriceSprayed] = 260; CaseAwards[23][11][aSubcount] = 0;
    CaseAwards[23][12][aId] = 13; CaseAwards[23][12][aRarity] = 4; CaseAwards[23][12][aType] = 5; CaseAwards[23][12][aInternalId] = 763; CaseAwards[23][12][aCount] = 0; CaseAwards[23][12][aPriceSprayed] = 260; CaseAwards[23][12][aSubcount] = 0;
    CaseAwards[23][13][aId] = 14; CaseAwards[23][13][aRarity] = 4; CaseAwards[23][13][aType] = 5; CaseAwards[23][13][aInternalId] = 28693; CaseAwards[23][13][aCount] = 0; CaseAwards[23][13][aPriceSprayed] = 260; CaseAwards[23][13][aSubcount] = 0;
    CaseAwards[23][14][aId] = 15; CaseAwards[23][14][aRarity] = 5; CaseAwards[23][14][aType] = 5; CaseAwards[23][14][aInternalId] = 415; CaseAwards[23][14][aCount] = 0; CaseAwards[23][14][aPriceSprayed] = 260; CaseAwards[23][14][aSubcount] = 0;
    CaseAwards[23][15][aId] = 16; CaseAwards[23][15][aRarity] = 5; CaseAwards[23][15][aType] = 5; CaseAwards[23][15][aInternalId] = 2543; CaseAwards[23][15][aCount] = 0; CaseAwards[23][15][aPriceSprayed] = 260; CaseAwards[23][15][aSubcount] = 0;
    CaseAwards[23][16][aId] = 17; CaseAwards[23][16][aRarity] = 5; CaseAwards[23][16][aType] = 5; CaseAwards[23][16][aInternalId] = 2573; CaseAwards[23][16][aCount] = 0; CaseAwards[23][16][aPriceSprayed] = 260; CaseAwards[23][16][aSubcount] = 0;
    CaseAwards[23][17][aId] = 18; CaseAwards[23][17][aRarity] = 5; CaseAwards[23][17][aType] = 5; CaseAwards[23][17][aInternalId] = 2558; CaseAwards[23][17][aCount] = 0; CaseAwards[23][17][aPriceSprayed] = 260; CaseAwards[23][17][aSubcount] = 0;
    CaseAwards[23][18][aId] = 19; CaseAwards[23][18][aRarity] = 5; CaseAwards[23][18][aType] = 5; CaseAwards[23][18][aInternalId] = 2558; CaseAwards[23][18][aCount] = 0; CaseAwards[23][18][aPriceSprayed] = 260; CaseAwards[23][18][aSubcount] = 0;
    CaseAwards[23][19][aId] = 20; CaseAwards[23][19][aRarity] = 5; CaseAwards[23][19][aType] = 5; CaseAwards[23][19][aInternalId] = 28751; CaseAwards[23][19][aCount] = 0; CaseAwards[23][19][aPriceSprayed] = 260; CaseAwards[23][19][aSubcount] = 0;
    CaseAwards[23][20][aId] = 21; CaseAwards[23][20][aRarity] = 5; CaseAwards[23][20][aType] = 5; CaseAwards[23][20][aInternalId] = 28672; CaseAwards[23][20][aCount] = 0; CaseAwards[23][20][aPriceSprayed] = 260; CaseAwards[23][20][aSubcount] = 0;
    CaseAwards[23][21][aId] = 22; CaseAwards[23][21][aRarity] = 5; CaseAwards[23][21][aType] = 5; CaseAwards[23][21][aInternalId] = 411; CaseAwards[23][21][aCount] = 0; CaseAwards[23][21][aPriceSprayed] = 260; CaseAwards[23][21][aSubcount] = 0;
    CaseAwards[23][22][aId] = 23; CaseAwards[23][22][aRarity] = 5; CaseAwards[23][22][aType] = 5; CaseAwards[23][22][aInternalId] = 541; CaseAwards[23][22][aCount] = 0; CaseAwards[23][22][aPriceSprayed] = 260; CaseAwards[23][22][aSubcount] = 0;
    CaseAwards[23][23][aId] = 24; CaseAwards[23][23][aRarity] = 5; CaseAwards[23][23][aType] = 5; CaseAwards[23][23][aInternalId] = 2579; CaseAwards[23][23][aCount] = 0; CaseAwards[23][23][aPriceSprayed] = 260; CaseAwards[23][23][aSubcount] = 0;
    CaseAwards[23][24][aId] = 25; CaseAwards[23][24][aRarity] = 5; CaseAwards[23][24][aType] = 5; CaseAwards[23][24][aInternalId] = 2597; CaseAwards[23][24][aCount] = 0; CaseAwards[23][24][aPriceSprayed] = 260; CaseAwards[23][24][aSubcount] = 0;
    CaseBonus[23][0][bId] = 1; CaseBonus[23][0][bNumberOpen] = 40; CaseBonus[23][0][bRarity] = 5; CaseBonus[23][0][bType] = 5; CaseBonus[23][0][bInternalId] = 28752; CaseBonus[23][0][bCount] = 0; CaseBonus[23][0][bPriceSprayed] = 500;
    CaseBonus[23][1][bId] = 2; CaseBonus[23][1][bNumberOpen] = 30; CaseBonus[23][1][bRarity] = 5; CaseBonus[23][1][bType] = 21; CaseBonus[23][1][bInternalId] = 1; CaseBonus[23][1][bCount] = 1000; CaseBonus[23][1][bPriceSprayed] = 0;
    CaseBonus[23][2][bId] = 3; CaseBonus[23][2][bNumberOpen] = 20; CaseBonus[23][2][bRarity] = 5; CaseBonus[23][2][bType] = 4; CaseBonus[23][2][bInternalId] = 25; CaseBonus[23][2][bCount] = 2; CaseBonus[23][2][bPriceSprayed] = 200;
    CaseBonus[23][3][bId] = 4; CaseBonus[23][3][bNumberOpen] = 10; CaseBonus[23][3][bRarity] = 5; CaseBonus[23][3][bType] = 21; CaseBonus[23][3][bInternalId] = 1; CaseBonus[23][3][bCount] = 500; CaseBonus[23][3][bPriceSprayed] = 0;
    CaseBonus[23][4][bId] = 5; CaseBonus[23][4][bNumberOpen] = 5; CaseBonus[23][4][bRarity] = 5; CaseBonus[23][4][bType] = 4; CaseBonus[23][4][bInternalId] = 25; CaseBonus[23][4][bCount] = 1; CaseBonus[23][4][bPriceSprayed] = 200;

    // case json id 26
    CaseData[24][cId] = 26;
    CaseData[24][cPriceOne] = 450;
    CaseData[24][cPriceTen] = 4500;
    CaseData[24][cDiscountOne] = 0;
    CaseData[24][cDiscountTen] = 25;
    CaseData[24][cAwardsCount] = 6;
    CaseData[24][cBonusCount] = 5;
    CaseAwards[24][0][aId] = 1; CaseAwards[24][0][aRarity] = 2; CaseAwards[24][0][aType] = 34; CaseAwards[24][0][aInternalId] = 0; CaseAwards[24][0][aCount] = 1; CaseAwards[24][0][aPriceSprayed] = 0; CaseAwards[24][0][aSubcount] = 0;
    CaseAwards[24][1][aId] = 2; CaseAwards[24][1][aRarity] = 3; CaseAwards[24][1][aType] = 34; CaseAwards[24][1][aInternalId] = 0; CaseAwards[24][1][aCount] = 3; CaseAwards[24][1][aPriceSprayed] = 0; CaseAwards[24][1][aSubcount] = 0;
    CaseAwards[24][2][aId] = 3; CaseAwards[24][2][aRarity] = 3; CaseAwards[24][2][aType] = 34; CaseAwards[24][2][aInternalId] = 0; CaseAwards[24][2][aCount] = 5; CaseAwards[24][2][aPriceSprayed] = 0; CaseAwards[24][2][aSubcount] = 0;
    CaseAwards[24][3][aId] = 4; CaseAwards[24][3][aRarity] = 4; CaseAwards[24][3][aType] = 34; CaseAwards[24][3][aInternalId] = 0; CaseAwards[24][3][aCount] = 10; CaseAwards[24][3][aPriceSprayed] = 0; CaseAwards[24][3][aSubcount] = 0;
    CaseAwards[24][4][aId] = 5; CaseAwards[24][4][aRarity] = 4; CaseAwards[24][4][aType] = 34; CaseAwards[24][4][aInternalId] = 0; CaseAwards[24][4][aCount] = 20; CaseAwards[24][4][aPriceSprayed] = 0; CaseAwards[24][4][aSubcount] = 0;
    CaseAwards[24][5][aId] = 6; CaseAwards[24][5][aRarity] = 5; CaseAwards[24][5][aType] = 34; CaseAwards[24][5][aInternalId] = 0; CaseAwards[24][5][aCount] = 30; CaseAwards[24][5][aPriceSprayed] = 0; CaseAwards[24][5][aSubcount] = 0;
    CaseBonus[24][0][bId] = 1; CaseBonus[24][0][bNumberOpen] = 40; CaseBonus[24][0][bRarity] = 5; CaseBonus[24][0][bType] = 34; CaseBonus[24][0][bInternalId] = 1; CaseBonus[24][0][bCount] = 30; CaseBonus[24][0][bPriceSprayed] = 0;
    CaseBonus[24][1][bId] = 2; CaseBonus[24][1][bNumberOpen] = 30; CaseBonus[24][1][bRarity] = 5; CaseBonus[24][1][bType] = 34; CaseBonus[24][1][bInternalId] = 1; CaseBonus[24][1][bCount] = 30; CaseBonus[24][1][bPriceSprayed] = 0;
    CaseBonus[24][2][bId] = 3; CaseBonus[24][2][bNumberOpen] = 20; CaseBonus[24][2][bRarity] = 4; CaseBonus[24][2][bType] = 34; CaseBonus[24][2][bInternalId] = 1; CaseBonus[24][2][bCount] = 20; CaseBonus[24][2][bPriceSprayed] = 0;
    CaseBonus[24][3][bId] = 4; CaseBonus[24][3][bNumberOpen] = 10; CaseBonus[24][3][bRarity] = 4; CaseBonus[24][3][bType] = 34; CaseBonus[24][3][bInternalId] = 1; CaseBonus[24][3][bCount] = 20; CaseBonus[24][3][bPriceSprayed] = 0;
    CaseBonus[24][4][bId] = 5; CaseBonus[24][4][bNumberOpen] = 5; CaseBonus[24][4][bRarity] = 3; CaseBonus[24][4][bType] = 34; CaseBonus[24][4][bInternalId] = 1; CaseBonus[24][4][bCount] = 10; CaseBonus[24][4][bPriceSprayed] = 0;

    // case json id 27
    CaseData[25][cId] = 27;
    CaseData[25][cPriceOne] = 150;
    CaseData[25][cPriceTen] = 1500;
    CaseData[25][cDiscountOne] = 0;
    CaseData[25][cDiscountTen] = 15;
    CaseData[25][cAwardsCount] = 53;
    CaseData[25][cBonusCount] = 5;
    CaseAwards[25][0][aId] = 1; CaseAwards[25][0][aRarity] = 1; CaseAwards[25][0][aType] = 5; CaseAwards[25][0][aInternalId] = 649; CaseAwards[25][0][aCount] = 24; CaseAwards[25][0][aPriceSprayed] = 10; CaseAwards[25][0][aSubcount] = 0;
    CaseAwards[25][1][aId] = 2; CaseAwards[25][1][aRarity] = 1; CaseAwards[25][1][aType] = 5; CaseAwards[25][1][aInternalId] = 654; CaseAwards[25][1][aCount] = 24; CaseAwards[25][1][aPriceSprayed] = 10; CaseAwards[25][1][aSubcount] = 0;
    CaseAwards[25][2][aId] = 3; CaseAwards[25][2][aRarity] = 1; CaseAwards[25][2][aType] = 5; CaseAwards[25][2][aInternalId] = 650; CaseAwards[25][2][aCount] = 24; CaseAwards[25][2][aPriceSprayed] = 10; CaseAwards[25][2][aSubcount] = 0;
    CaseAwards[25][3][aId] = 4; CaseAwards[25][3][aRarity] = 2; CaseAwards[25][3][aType] = 5; CaseAwards[25][3][aInternalId] = 529; CaseAwards[25][3][aCount] = 24; CaseAwards[25][3][aPriceSprayed] = 10; CaseAwards[25][3][aSubcount] = 0;
    CaseAwards[25][4][aId] = 5; CaseAwards[25][4][aRarity] = 2; CaseAwards[25][4][aType] = 5; CaseAwards[25][4][aInternalId] = 540; CaseAwards[25][4][aCount] = 24; CaseAwards[25][4][aPriceSprayed] = 10; CaseAwards[25][4][aSubcount] = 0;
    CaseAwards[25][5][aId] = 6; CaseAwards[25][5][aRarity] = 2; CaseAwards[25][5][aType] = 5; CaseAwards[25][5][aInternalId] = 559; CaseAwards[25][5][aCount] = 24; CaseAwards[25][5][aPriceSprayed] = 10; CaseAwards[25][5][aSubcount] = 0;
    CaseAwards[25][6][aId] = 7; CaseAwards[25][6][aRarity] = 2; CaseAwards[25][6][aType] = 5; CaseAwards[25][6][aInternalId] = 562; CaseAwards[25][6][aCount] = 24; CaseAwards[25][6][aPriceSprayed] = 10; CaseAwards[25][6][aSubcount] = 0;
    CaseAwards[25][7][aId] = 8; CaseAwards[25][7][aRarity] = 2; CaseAwards[25][7][aType] = 5; CaseAwards[25][7][aInternalId] = 28730; CaseAwards[25][7][aCount] = 24; CaseAwards[25][7][aPriceSprayed] = 10; CaseAwards[25][7][aSubcount] = 0;
    CaseAwards[25][8][aId] = 9; CaseAwards[25][8][aRarity] = 2; CaseAwards[25][8][aType] = 5; CaseAwards[25][8][aInternalId] = 28677; CaseAwards[25][8][aCount] = 24; CaseAwards[25][8][aPriceSprayed] = 10; CaseAwards[25][8][aSubcount] = 0;
    CaseAwards[25][9][aId] = 10; CaseAwards[25][9][aRarity] = 2; CaseAwards[25][9][aType] = 5; CaseAwards[25][9][aInternalId] = 28737; CaseAwards[25][9][aCount] = 24; CaseAwards[25][9][aPriceSprayed] = 10; CaseAwards[25][9][aSubcount] = 0;
    CaseAwards[25][10][aId] = 11; CaseAwards[25][10][aRarity] = 2; CaseAwards[25][10][aType] = 5; CaseAwards[25][10][aInternalId] = 28702; CaseAwards[25][10][aCount] = 24; CaseAwards[25][10][aPriceSprayed] = 10; CaseAwards[25][10][aSubcount] = 0;
    CaseAwards[25][11][aId] = 12; CaseAwards[25][11][aRarity] = 2; CaseAwards[25][11][aType] = 5; CaseAwards[25][11][aInternalId] = 28658; CaseAwards[25][11][aCount] = 24; CaseAwards[25][11][aPriceSprayed] = 10; CaseAwards[25][11][aSubcount] = 0;
    CaseAwards[25][12][aId] = 13; CaseAwards[25][12][aRarity] = 2; CaseAwards[25][12][aType] = 5; CaseAwards[25][12][aInternalId] = 28688; CaseAwards[25][12][aCount] = 24; CaseAwards[25][12][aPriceSprayed] = 10; CaseAwards[25][12][aSubcount] = 0;
    CaseAwards[25][13][aId] = 14; CaseAwards[25][13][aRarity] = 2; CaseAwards[25][13][aType] = 5; CaseAwards[25][13][aInternalId] = 771; CaseAwards[25][13][aCount] = 24; CaseAwards[25][13][aPriceSprayed] = 10; CaseAwards[25][13][aSubcount] = 0;
    CaseAwards[25][14][aId] = 15; CaseAwards[25][14][aRarity] = 3; CaseAwards[25][14][aType] = 5; CaseAwards[25][14][aInternalId] = 28678; CaseAwards[25][14][aCount] = 24; CaseAwards[25][14][aPriceSprayed] = 10; CaseAwards[25][14][aSubcount] = 0;
    CaseAwards[25][15][aId] = 16; CaseAwards[25][15][aRarity] = 3; CaseAwards[25][15][aType] = 5; CaseAwards[25][15][aInternalId] = 749; CaseAwards[25][15][aCount] = 24; CaseAwards[25][15][aPriceSprayed] = 10; CaseAwards[25][15][aSubcount] = 0;
    CaseAwards[25][16][aId] = 17; CaseAwards[25][16][aRarity] = 3; CaseAwards[25][16][aType] = 5; CaseAwards[25][16][aInternalId] = 477; CaseAwards[25][16][aCount] = 24; CaseAwards[25][16][aPriceSprayed] = 10; CaseAwards[25][16][aSubcount] = 0;
    CaseAwards[25][17][aId] = 18; CaseAwards[25][17][aRarity] = 3; CaseAwards[25][17][aType] = 5; CaseAwards[25][17][aInternalId] = 28699; CaseAwards[25][17][aCount] = 24; CaseAwards[25][17][aPriceSprayed] = 10; CaseAwards[25][17][aSubcount] = 0;
    CaseAwards[25][18][aId] = 19; CaseAwards[25][18][aRarity] = 3; CaseAwards[25][18][aType] = 5; CaseAwards[25][18][aInternalId] = 28728; CaseAwards[25][18][aCount] = 24; CaseAwards[25][18][aPriceSprayed] = 10; CaseAwards[25][18][aSubcount] = 0;
    CaseAwards[25][19][aId] = 20; CaseAwards[25][19][aRarity] = 3; CaseAwards[25][19][aType] = 5; CaseAwards[25][19][aInternalId] = 28685; CaseAwards[25][19][aCount] = 24; CaseAwards[25][19][aPriceSprayed] = 10; CaseAwards[25][19][aSubcount] = 0;
    CaseAwards[25][20][aId] = 21; CaseAwards[25][20][aRarity] = 3; CaseAwards[25][20][aType] = 5; CaseAwards[25][20][aInternalId] = 621; CaseAwards[25][20][aCount] = 24; CaseAwards[25][20][aPriceSprayed] = 10; CaseAwards[25][20][aSubcount] = 0;
    CaseAwards[25][21][aId] = 22; CaseAwards[25][21][aRarity] = 3; CaseAwards[25][21][aType] = 5; CaseAwards[25][21][aInternalId] = 28674; CaseAwards[25][21][aCount] = 24; CaseAwards[25][21][aPriceSprayed] = 10; CaseAwards[25][21][aSubcount] = 0;
    CaseAwards[25][22][aId] = 23; CaseAwards[25][22][aRarity] = 3; CaseAwards[25][22][aType] = 5; CaseAwards[25][22][aInternalId] = 767; CaseAwards[25][22][aCount] = 24; CaseAwards[25][22][aPriceSprayed] = 10; CaseAwards[25][22][aSubcount] = 0;
    CaseAwards[25][23][aId] = 24; CaseAwards[25][23][aRarity] = 3; CaseAwards[25][23][aType] = 5; CaseAwards[25][23][aInternalId] = 764; CaseAwards[25][23][aCount] = 24; CaseAwards[25][23][aPriceSprayed] = 10; CaseAwards[25][23][aSubcount] = 0;
    CaseAwards[25][24][aId] = 25; CaseAwards[25][24][aRarity] = 3; CaseAwards[25][24][aType] = 5; CaseAwards[25][24][aInternalId] = 28669; CaseAwards[25][24][aCount] = 24; CaseAwards[25][24][aPriceSprayed] = 10; CaseAwards[25][24][aSubcount] = 0;
    CaseAwards[25][25][aId] = 26; CaseAwards[25][25][aRarity] = 3; CaseAwards[25][25][aType] = 5; CaseAwards[25][25][aInternalId] = 28700; CaseAwards[25][25][aCount] = 24; CaseAwards[25][25][aPriceSprayed] = 10; CaseAwards[25][25][aSubcount] = 0;
    CaseAwards[25][26][aId] = 27; CaseAwards[25][26][aRarity] = 3; CaseAwards[25][26][aType] = 5; CaseAwards[25][26][aInternalId] = 769; CaseAwards[25][26][aCount] = 24; CaseAwards[25][26][aPriceSprayed] = 10; CaseAwards[25][26][aSubcount] = 0;
    CaseAwards[25][27][aId] = 28; CaseAwards[25][27][aRarity] = 3; CaseAwards[25][27][aType] = 5; CaseAwards[25][27][aInternalId] = 28656; CaseAwards[25][27][aCount] = 24; CaseAwards[25][27][aPriceSprayed] = 10; CaseAwards[25][27][aSubcount] = 0;
    CaseAwards[25][28][aId] = 29; CaseAwards[25][28][aRarity] = 3; CaseAwards[25][28][aType] = 5; CaseAwards[25][28][aInternalId] = 28712; CaseAwards[25][28][aCount] = 24; CaseAwards[25][28][aPriceSprayed] = 10; CaseAwards[25][28][aSubcount] = 0;
    CaseAwards[25][29][aId] = 30; CaseAwards[25][29][aRarity] = 3; CaseAwards[25][29][aType] = 5; CaseAwards[25][29][aInternalId] = 28729; CaseAwards[25][29][aCount] = 24; CaseAwards[25][29][aPriceSprayed] = 10; CaseAwards[25][29][aSubcount] = 0;
    CaseAwards[25][30][aId] = 31; CaseAwards[25][30][aRarity] = 3; CaseAwards[25][30][aType] = 5; CaseAwards[25][30][aInternalId] = 28675; CaseAwards[25][30][aCount] = 24; CaseAwards[25][30][aPriceSprayed] = 10; CaseAwards[25][30][aSubcount] = 0;
    CaseAwards[25][31][aId] = 32; CaseAwards[25][31][aRarity] = 3; CaseAwards[25][31][aType] = 5; CaseAwards[25][31][aInternalId] = 759; CaseAwards[25][31][aCount] = 24; CaseAwards[25][31][aPriceSprayed] = 10; CaseAwards[25][31][aSubcount] = 0;
    CaseAwards[25][32][aId] = 33; CaseAwards[25][32][aRarity] = 3; CaseAwards[25][32][aType] = 5; CaseAwards[25][32][aInternalId] = 768; CaseAwards[25][32][aCount] = 24; CaseAwards[25][32][aPriceSprayed] = 10; CaseAwards[25][32][aSubcount] = 0;
    CaseAwards[25][33][aId] = 34; CaseAwards[25][33][aRarity] = 3; CaseAwards[25][33][aType] = 5; CaseAwards[25][33][aInternalId] = 28676; CaseAwards[25][33][aCount] = 24; CaseAwards[25][33][aPriceSprayed] = 10; CaseAwards[25][33][aSubcount] = 0;
    CaseAwards[25][34][aId] = 35; CaseAwards[25][34][aRarity] = 3; CaseAwards[25][34][aType] = 5; CaseAwards[25][34][aInternalId] = 678; CaseAwards[25][34][aCount] = 24; CaseAwards[25][34][aPriceSprayed] = 10; CaseAwards[25][34][aSubcount] = 0;
    CaseAwards[25][35][aId] = 36; CaseAwards[25][35][aRarity] = 3; CaseAwards[25][35][aType] = 5; CaseAwards[25][35][aInternalId] = 28683; CaseAwards[25][35][aCount] = 24; CaseAwards[25][35][aPriceSprayed] = 10; CaseAwards[25][35][aSubcount] = 0;
    CaseAwards[25][36][aId] = 37; CaseAwards[25][36][aRarity] = 3; CaseAwards[25][36][aType] = 5; CaseAwards[25][36][aInternalId] = 760; CaseAwards[25][36][aCount] = 24; CaseAwards[25][36][aPriceSprayed] = 10; CaseAwards[25][36][aSubcount] = 0;
    CaseAwards[25][37][aId] = 38; CaseAwards[25][37][aRarity] = 3; CaseAwards[25][37][aType] = 5; CaseAwards[25][37][aInternalId] = 751; CaseAwards[25][37][aCount] = 24; CaseAwards[25][37][aPriceSprayed] = 10; CaseAwards[25][37][aSubcount] = 0;
    CaseAwards[25][38][aId] = 39; CaseAwards[25][38][aRarity] = 3; CaseAwards[25][38][aType] = 5; CaseAwards[25][38][aInternalId] = 28667; CaseAwards[25][38][aCount] = 24; CaseAwards[25][38][aPriceSprayed] = 10; CaseAwards[25][38][aSubcount] = 0;
    CaseAwards[25][39][aId] = 40; CaseAwards[25][39][aRarity] = 4; CaseAwards[25][39][aType] = 5; CaseAwards[25][39][aInternalId] = 28735; CaseAwards[25][39][aCount] = 24; CaseAwards[25][39][aPriceSprayed] = 10; CaseAwards[25][39][aSubcount] = 0;
    CaseAwards[25][40][aId] = 41; CaseAwards[25][40][aRarity] = 4; CaseAwards[25][40][aType] = 5; CaseAwards[25][40][aInternalId] = 28694; CaseAwards[25][40][aCount] = 24; CaseAwards[25][40][aPriceSprayed] = 10; CaseAwards[25][40][aSubcount] = 0;
    CaseAwards[25][41][aId] = 42; CaseAwards[25][41][aRarity] = 4; CaseAwards[25][41][aType] = 5; CaseAwards[25][41][aInternalId] = 28732; CaseAwards[25][41][aCount] = 24; CaseAwards[25][41][aPriceSprayed] = 10; CaseAwards[25][41][aSubcount] = 0;
    CaseAwards[25][42][aId] = 43; CaseAwards[25][42][aRarity] = 4; CaseAwards[25][42][aType] = 5; CaseAwards[25][42][aInternalId] = 2547; CaseAwards[25][42][aCount] = 24; CaseAwards[25][42][aPriceSprayed] = 10; CaseAwards[25][42][aSubcount] = 0;
    CaseAwards[25][43][aId] = 44; CaseAwards[25][43][aRarity] = 4; CaseAwards[25][43][aType] = 5; CaseAwards[25][43][aInternalId] = 2550; CaseAwards[25][43][aCount] = 24; CaseAwards[25][43][aPriceSprayed] = 10; CaseAwards[25][43][aSubcount] = 0;
    CaseAwards[25][44][aId] = 45; CaseAwards[25][44][aRarity] = 4; CaseAwards[25][44][aType] = 5; CaseAwards[25][44][aInternalId] = 763; CaseAwards[25][44][aCount] = 24; CaseAwards[25][44][aPriceSprayed] = 10; CaseAwards[25][44][aSubcount] = 0;
    CaseAwards[25][45][aId] = 46; CaseAwards[25][45][aRarity] = 4; CaseAwards[25][45][aType] = 5; CaseAwards[25][45][aInternalId] = 28664; CaseAwards[25][45][aCount] = 24; CaseAwards[25][45][aPriceSprayed] = 10; CaseAwards[25][45][aSubcount] = 0;
    CaseAwards[25][46][aId] = 47; CaseAwards[25][46][aRarity] = 4; CaseAwards[25][46][aType] = 5; CaseAwards[25][46][aInternalId] = 28660; CaseAwards[25][46][aCount] = 24; CaseAwards[25][46][aPriceSprayed] = 10; CaseAwards[25][46][aSubcount] = 0;
    CaseAwards[25][47][aId] = 48; CaseAwards[25][47][aRarity] = 4; CaseAwards[25][47][aType] = 5; CaseAwards[25][47][aInternalId] = 28665; CaseAwards[25][47][aCount] = 24; CaseAwards[25][47][aPriceSprayed] = 10; CaseAwards[25][47][aSubcount] = 0;
    CaseAwards[25][48][aId] = 49; CaseAwards[25][48][aRarity] = 4; CaseAwards[25][48][aType] = 5; CaseAwards[25][48][aInternalId] = 28668; CaseAwards[25][48][aCount] = 24; CaseAwards[25][48][aPriceSprayed] = 10; CaseAwards[25][48][aSubcount] = 0;
    CaseAwards[25][49][aId] = 50; CaseAwards[25][49][aRarity] = 5; CaseAwards[25][49][aType] = 5; CaseAwards[25][49][aInternalId] = 28672; CaseAwards[25][49][aCount] = 24; CaseAwards[25][49][aPriceSprayed] = 10; CaseAwards[25][49][aSubcount] = 0;
    CaseAwards[25][50][aId] = 51; CaseAwards[25][50][aRarity] = 5; CaseAwards[25][50][aType] = 5; CaseAwards[25][50][aInternalId] = 28666; CaseAwards[25][50][aCount] = 24; CaseAwards[25][50][aPriceSprayed] = 10; CaseAwards[25][50][aSubcount] = 0;
    CaseAwards[25][51][aId] = 52; CaseAwards[25][51][aRarity] = 5; CaseAwards[25][51][aType] = 5; CaseAwards[25][51][aInternalId] = 28680; CaseAwards[25][51][aCount] = 24; CaseAwards[25][51][aPriceSprayed] = 10; CaseAwards[25][51][aSubcount] = 0;
    CaseAwards[25][52][aId] = 53; CaseAwards[25][52][aRarity] = 5; CaseAwards[25][52][aType] = 5; CaseAwards[25][52][aInternalId] = 765; CaseAwards[25][52][aCount] = 24; CaseAwards[25][52][aPriceSprayed] = 10; CaseAwards[25][52][aSubcount] = 0;
    CaseBonus[25][0][bId] = 1; CaseBonus[25][0][bNumberOpen] = 40; CaseBonus[25][0][bRarity] = 5; CaseBonus[25][0][bType] = 4; CaseBonus[25][0][bInternalId] = 27; CaseBonus[25][0][bCount] = 5; CaseBonus[25][0][bPriceSprayed] = 0;
    CaseBonus[25][1][bId] = 2; CaseBonus[25][1][bNumberOpen] = 30; CaseBonus[25][1][bRarity] = 5; CaseBonus[25][1][bType] = 4; CaseBonus[25][1][bInternalId] = 27; CaseBonus[25][1][bCount] = 5; CaseBonus[25][1][bPriceSprayed] = 0;
    CaseBonus[25][2][bId] = 3; CaseBonus[25][2][bNumberOpen] = 20; CaseBonus[25][2][bRarity] = 5; CaseBonus[25][2][bType] = 4; CaseBonus[25][2][bInternalId] = 27; CaseBonus[25][2][bCount] = 5; CaseBonus[25][2][bPriceSprayed] = 0;
    CaseBonus[25][3][bId] = 4; CaseBonus[25][3][bNumberOpen] = 10; CaseBonus[25][3][bRarity] = 5; CaseBonus[25][3][bType] = 4; CaseBonus[25][3][bInternalId] = 27; CaseBonus[25][3][bCount] = 5; CaseBonus[25][3][bPriceSprayed] = 0;
    CaseBonus[25][4][bId] = 5; CaseBonus[25][4][bNumberOpen] = 5; CaseBonus[25][4][bRarity] = 5; CaseBonus[25][4][bType] = 4; CaseBonus[25][4][bInternalId] = 27; CaseBonus[25][4][bCount] = 5; CaseBonus[25][4][bPriceSprayed] = 0;

    // case json id 28
    CaseData[26][cId] = 28;
    CaseData[26][cPriceOne] = 250;
    CaseData[26][cPriceTen] = 2500;
    CaseData[26][cDiscountOne] = 0;
    CaseData[26][cDiscountTen] = 15;
    CaseData[26][cAwardsCount] = 32;
    CaseData[26][cBonusCount] = 5;
    CaseAwards[26][0][aId] = 1; CaseAwards[26][0][aRarity] = 4; CaseAwards[26][0][aType] = 5; CaseAwards[26][0][aInternalId] = 503; CaseAwards[26][0][aCount] = 24; CaseAwards[26][0][aPriceSprayed] = 10; CaseAwards[26][0][aSubcount] = 0;
    CaseAwards[26][1][aId] = 2; CaseAwards[26][1][aRarity] = 3; CaseAwards[26][1][aType] = 5; CaseAwards[26][1][aInternalId] = 745; CaseAwards[26][1][aCount] = 24; CaseAwards[26][1][aPriceSprayed] = 10; CaseAwards[26][1][aSubcount] = 0;
    CaseAwards[26][2][aId] = 3; CaseAwards[26][2][aRarity] = 4; CaseAwards[26][2][aType] = 5; CaseAwards[26][2][aInternalId] = 752; CaseAwards[26][2][aCount] = 24; CaseAwards[26][2][aPriceSprayed] = 10; CaseAwards[26][2][aSubcount] = 0;
    CaseAwards[26][3][aId] = 4; CaseAwards[26][3][aRarity] = 4; CaseAwards[26][3][aType] = 5; CaseAwards[26][3][aInternalId] = 28701; CaseAwards[26][3][aCount] = 24; CaseAwards[26][3][aPriceSprayed] = 10; CaseAwards[26][3][aSubcount] = 0;
    CaseAwards[26][4][aId] = 5; CaseAwards[26][4][aRarity] = 4; CaseAwards[26][4][aType] = 5; CaseAwards[26][4][aInternalId] = 28713; CaseAwards[26][4][aCount] = 24; CaseAwards[26][4][aPriceSprayed] = 10; CaseAwards[26][4][aSubcount] = 0;
    CaseAwards[26][5][aId] = 6; CaseAwards[26][5][aRarity] = 4; CaseAwards[26][5][aType] = 5; CaseAwards[26][5][aInternalId] = 28736; CaseAwards[26][5][aCount] = 24; CaseAwards[26][5][aPriceSprayed] = 10; CaseAwards[26][5][aSubcount] = 0;
    CaseAwards[26][6][aId] = 7; CaseAwards[26][6][aRarity] = 4; CaseAwards[26][6][aType] = 5; CaseAwards[26][6][aInternalId] = 28710; CaseAwards[26][6][aCount] = 24; CaseAwards[26][6][aPriceSprayed] = 10; CaseAwards[26][6][aSubcount] = 0;
    CaseAwards[26][7][aId] = 8; CaseAwards[26][7][aRarity] = 4; CaseAwards[26][7][aType] = 5; CaseAwards[26][7][aInternalId] = 28733; CaseAwards[26][7][aCount] = 24; CaseAwards[26][7][aPriceSprayed] = 10; CaseAwards[26][7][aSubcount] = 0;
    CaseAwards[26][8][aId] = 9; CaseAwards[26][8][aRarity] = 4; CaseAwards[26][8][aType] = 5; CaseAwards[26][8][aInternalId] = 551; CaseAwards[26][8][aCount] = 24; CaseAwards[26][8][aPriceSprayed] = 10; CaseAwards[26][8][aSubcount] = 0;
    CaseAwards[26][9][aId] = 10; CaseAwards[26][9][aRarity] = 4; CaseAwards[26][9][aType] = 5; CaseAwards[26][9][aInternalId] = 28720; CaseAwards[26][9][aCount] = 24; CaseAwards[26][9][aPriceSprayed] = 10; CaseAwards[26][9][aSubcount] = 0;
    CaseAwards[26][10][aId] = 11; CaseAwards[26][10][aRarity] = 4; CaseAwards[26][10][aType] = 5; CaseAwards[26][10][aInternalId] = 502; CaseAwards[26][10][aCount] = 24; CaseAwards[26][10][aPriceSprayed] = 10; CaseAwards[26][10][aSubcount] = 0;
    CaseAwards[26][11][aId] = 12; CaseAwards[26][11][aRarity] = 5; CaseAwards[26][11][aType] = 5; CaseAwards[26][11][aInternalId] = 533; CaseAwards[26][11][aCount] = 24; CaseAwards[26][11][aPriceSprayed] = 10; CaseAwards[26][11][aSubcount] = 0;
    CaseAwards[26][12][aId] = 13; CaseAwards[26][12][aRarity] = 5; CaseAwards[26][12][aType] = 5; CaseAwards[26][12][aInternalId] = 2393; CaseAwards[26][12][aCount] = 24; CaseAwards[26][12][aPriceSprayed] = 10; CaseAwards[26][12][aSubcount] = 0;
    CaseAwards[26][13][aId] = 14; CaseAwards[26][13][aRarity] = 5; CaseAwards[26][13][aType] = 5; CaseAwards[26][13][aInternalId] = 740; CaseAwards[26][13][aCount] = 24; CaseAwards[26][13][aPriceSprayed] = 10; CaseAwards[26][13][aSubcount] = 0;
    CaseAwards[26][14][aId] = 15; CaseAwards[26][14][aRarity] = 5; CaseAwards[26][14][aType] = 5; CaseAwards[26][14][aInternalId] = 632; CaseAwards[26][14][aCount] = 24; CaseAwards[26][14][aPriceSprayed] = 10; CaseAwards[26][14][aSubcount] = 0;
    CaseAwards[26][15][aId] = 16; CaseAwards[26][15][aRarity] = 5; CaseAwards[26][15][aType] = 5; CaseAwards[26][15][aInternalId] = 28723; CaseAwards[26][15][aCount] = 24; CaseAwards[26][15][aPriceSprayed] = 10; CaseAwards[26][15][aSubcount] = 0;
    CaseAwards[26][16][aId] = 17; CaseAwards[26][16][aRarity] = 5; CaseAwards[26][16][aType] = 5; CaseAwards[26][16][aInternalId] = 661; CaseAwards[26][16][aCount] = 24; CaseAwards[26][16][aPriceSprayed] = 10; CaseAwards[26][16][aSubcount] = 0;
    CaseAwards[26][17][aId] = 18; CaseAwards[26][17][aRarity] = 5; CaseAwards[26][17][aType] = 5; CaseAwards[26][17][aInternalId] = 28704; CaseAwards[26][17][aCount] = 24; CaseAwards[26][17][aPriceSprayed] = 10; CaseAwards[26][17][aSubcount] = 0;
    CaseAwards[26][18][aId] = 19; CaseAwards[26][18][aRarity] = 5; CaseAwards[26][18][aType] = 5; CaseAwards[26][18][aInternalId] = 28706; CaseAwards[26][18][aCount] = 24; CaseAwards[26][18][aPriceSprayed] = 10; CaseAwards[26][18][aSubcount] = 0;
    CaseAwards[26][19][aId] = 20; CaseAwards[26][19][aRarity] = 5; CaseAwards[26][19][aType] = 5; CaseAwards[26][19][aInternalId] = 28723; CaseAwards[26][19][aCount] = 24; CaseAwards[26][19][aPriceSprayed] = 10; CaseAwards[26][19][aSubcount] = 0;
    CaseAwards[26][20][aId] = 21; CaseAwards[26][20][aRarity] = 5; CaseAwards[26][20][aType] = 5; CaseAwards[26][20][aInternalId] = 755; CaseAwards[26][20][aCount] = 24; CaseAwards[26][20][aPriceSprayed] = 10; CaseAwards[26][20][aSubcount] = 0;
    CaseAwards[26][21][aId] = 22; CaseAwards[26][21][aRarity] = 5; CaseAwards[26][21][aType] = 5; CaseAwards[26][21][aInternalId] = 28705; CaseAwards[26][21][aCount] = 24; CaseAwards[26][21][aPriceSprayed] = 10; CaseAwards[26][21][aSubcount] = 0;
    CaseAwards[26][22][aId] = 23; CaseAwards[26][22][aRarity] = 5; CaseAwards[26][22][aType] = 5; CaseAwards[26][22][aInternalId] = 28661; CaseAwards[26][22][aCount] = 24; CaseAwards[26][22][aPriceSprayed] = 10; CaseAwards[26][22][aSubcount] = 0;
    CaseAwards[26][23][aId] = 24; CaseAwards[26][23][aRarity] = 5; CaseAwards[26][23][aType] = 5; CaseAwards[26][23][aInternalId] = 28682; CaseAwards[26][23][aCount] = 24; CaseAwards[26][23][aPriceSprayed] = 10; CaseAwards[26][23][aSubcount] = 0;
    CaseAwards[26][24][aId] = 25; CaseAwards[26][24][aRarity] = 5; CaseAwards[26][24][aType] = 5; CaseAwards[26][24][aInternalId] = 596; CaseAwards[26][24][aCount] = 24; CaseAwards[26][24][aPriceSprayed] = 10; CaseAwards[26][24][aSubcount] = 0;
    CaseAwards[26][25][aId] = 26; CaseAwards[26][25][aRarity] = 5; CaseAwards[26][25][aType] = 5; CaseAwards[26][25][aInternalId] = 28717; CaseAwards[26][25][aCount] = 24; CaseAwards[26][25][aPriceSprayed] = 10; CaseAwards[26][25][aSubcount] = 0;
    CaseAwards[26][26][aId] = 27; CaseAwards[26][26][aRarity] = 5; CaseAwards[26][26][aType] = 5; CaseAwards[26][26][aInternalId] = 28740; CaseAwards[26][26][aCount] = 24; CaseAwards[26][26][aPriceSprayed] = 10; CaseAwards[26][26][aSubcount] = 0;
    CaseAwards[26][27][aId] = 28; CaseAwards[26][27][aRarity] = 5; CaseAwards[26][27][aType] = 5; CaseAwards[26][27][aInternalId] = 28689; CaseAwards[26][27][aCount] = 24; CaseAwards[26][27][aPriceSprayed] = 10; CaseAwards[26][27][aSubcount] = 0;
    CaseAwards[26][28][aId] = 29; CaseAwards[26][28][aRarity] = 5; CaseAwards[26][28][aType] = 5; CaseAwards[26][28][aInternalId] = 28738; CaseAwards[26][28][aCount] = 24; CaseAwards[26][28][aPriceSprayed] = 10; CaseAwards[26][28][aSubcount] = 0;
    CaseAwards[26][29][aId] = 30; CaseAwards[26][29][aRarity] = 5; CaseAwards[26][29][aType] = 5; CaseAwards[26][29][aInternalId] = 28708; CaseAwards[26][29][aCount] = 24; CaseAwards[26][29][aPriceSprayed] = 10; CaseAwards[26][29][aSubcount] = 0;
    CaseAwards[26][30][aId] = 31; CaseAwards[26][30][aRarity] = 5; CaseAwards[26][30][aType] = 5; CaseAwards[26][30][aInternalId] = 28719; CaseAwards[26][30][aCount] = 24; CaseAwards[26][30][aPriceSprayed] = 10; CaseAwards[26][30][aSubcount] = 0;
    CaseAwards[26][31][aId] = 32; CaseAwards[26][31][aRarity] = 5; CaseAwards[26][31][aType] = 5; CaseAwards[26][31][aInternalId] = 2570; CaseAwards[26][31][aCount] = 24; CaseAwards[26][31][aPriceSprayed] = 10; CaseAwards[26][31][aSubcount] = 0;
    CaseBonus[26][0][bId] = 1; CaseBonus[26][0][bNumberOpen] = 40; CaseBonus[26][0][bRarity] = 5; CaseBonus[26][0][bType] = 4; CaseBonus[26][0][bInternalId] = 28; CaseBonus[26][0][bCount] = 5; CaseBonus[26][0][bPriceSprayed] = 0;
    CaseBonus[26][1][bId] = 2; CaseBonus[26][1][bNumberOpen] = 30; CaseBonus[26][1][bRarity] = 5; CaseBonus[26][1][bType] = 4; CaseBonus[26][1][bInternalId] = 28; CaseBonus[26][1][bCount] = 5; CaseBonus[26][1][bPriceSprayed] = 0;
    CaseBonus[26][2][bId] = 3; CaseBonus[26][2][bNumberOpen] = 20; CaseBonus[26][2][bRarity] = 5; CaseBonus[26][2][bType] = 4; CaseBonus[26][2][bInternalId] = 28; CaseBonus[26][2][bCount] = 5; CaseBonus[26][2][bPriceSprayed] = 0;
    CaseBonus[26][3][bId] = 4; CaseBonus[26][3][bNumberOpen] = 10; CaseBonus[26][3][bRarity] = 5; CaseBonus[26][3][bType] = 4; CaseBonus[26][3][bInternalId] = 28; CaseBonus[26][3][bCount] = 5; CaseBonus[26][3][bPriceSprayed] = 0;
    CaseBonus[26][4][bId] = 5; CaseBonus[26][4][bNumberOpen] = 5; CaseBonus[26][4][bRarity] = 5; CaseBonus[26][4][bType] = 4; CaseBonus[26][4][bInternalId] = 28; CaseBonus[26][4][bCount] = 5; CaseBonus[26][4][bPriceSprayed] = 0;

    // case json id 24
    CaseData[27][cId] = 24;
    CaseData[27][cPriceOne] = 900;
    CaseData[27][cPriceTen] = 9000;
    CaseData[27][cDiscountOne] = 0;
    CaseData[27][cDiscountTen] = 5;
    CaseData[27][cAwardsCount] = 25;
    CaseData[27][cBonusCount] = 5;
    CaseAwards[27][0][aId] = 1; CaseAwards[27][0][aRarity] = 2; CaseAwards[27][0][aType] = 11; CaseAwards[27][0][aInternalId] = 367; CaseAwards[27][0][aCount] = 1; CaseAwards[27][0][aPriceSprayed] = 70; CaseAwards[27][0][aSubcount] = 0;
    CaseAwards[27][1][aId] = 2; CaseAwards[27][1][aRarity] = 2; CaseAwards[27][1][aType] = 11; CaseAwards[27][1][aInternalId] = 187; CaseAwards[27][1][aCount] = 1; CaseAwards[27][1][aPriceSprayed] = 80; CaseAwards[27][1][aSubcount] = 0;
    CaseAwards[27][2][aId] = 3; CaseAwards[27][2][aRarity] = 2; CaseAwards[27][2][aType] = 11; CaseAwards[27][2][aInternalId] = 326; CaseAwards[27][2][aCount] = 1; CaseAwards[27][2][aPriceSprayed] = 90; CaseAwards[27][2][aSubcount] = 0;
    CaseAwards[27][3][aId] = 4; CaseAwards[27][3][aRarity] = 2; CaseAwards[27][3][aType] = 11; CaseAwards[27][3][aInternalId] = 134; CaseAwards[27][3][aCount] = 12291; CaseAwards[27][3][aPriceSprayed] = 100; CaseAwards[27][3][aSubcount] = 0;
    CaseAwards[27][4][aId] = 5; CaseAwards[27][4][aRarity] = 2; CaseAwards[27][4][aType] = 11; CaseAwards[27][4][aInternalId] = 134; CaseAwards[27][4][aCount] = 14388; CaseAwards[27][4][aPriceSprayed] = 100; CaseAwards[27][4][aSubcount] = 0;
    CaseAwards[27][5][aId] = 6; CaseAwards[27][5][aRarity] = 2; CaseAwards[27][5][aType] = 11; CaseAwards[27][5][aInternalId] = 709; CaseAwards[27][5][aCount] = 1; CaseAwards[27][5][aPriceSprayed] = 100; CaseAwards[27][5][aSubcount] = 0;
    CaseAwards[27][6][aId] = 7; CaseAwards[27][6][aRarity] = 2; CaseAwards[27][6][aType] = 3; CaseAwards[27][6][aInternalId] = 1; CaseAwards[27][6][aCount] = 700; CaseAwards[27][6][aPriceSprayed] = 0; CaseAwards[27][6][aSubcount] = 0;
    CaseAwards[27][7][aId] = 8; CaseAwards[27][7][aRarity] = 2; CaseAwards[27][7][aType] = 5; CaseAwards[27][7][aInternalId] = 2568; CaseAwards[27][7][aCount] = 0; CaseAwards[27][7][aPriceSprayed] = 110; CaseAwards[27][7][aSubcount] = 0;
    CaseAwards[27][8][aId] = 9; CaseAwards[27][8][aRarity] = 2; CaseAwards[27][8][aType] = 2; CaseAwards[27][8][aInternalId] = 1; CaseAwards[27][8][aCount] = 900000; CaseAwards[27][8][aPriceSprayed] = 0; CaseAwards[27][8][aSubcount] = 0;
    CaseAwards[27][9][aId] = 10; CaseAwards[27][9][aRarity] = 3; CaseAwards[27][9][aType] = 11; CaseAwards[27][9][aInternalId] = 134; CaseAwards[27][9][aCount] = 236; CaseAwards[27][9][aPriceSprayed] = 130; CaseAwards[27][9][aSubcount] = 0;
    CaseAwards[27][10][aId] = 11; CaseAwards[27][10][aRarity] = 3; CaseAwards[27][10][aType] = 11; CaseAwards[27][10][aInternalId] = 134; CaseAwards[27][10][aCount] = 11935; CaseAwards[27][10][aPriceSprayed] = 140; CaseAwards[27][10][aSubcount] = 0;
    CaseAwards[27][11][aId] = 12; CaseAwards[27][11][aRarity] = 3; CaseAwards[27][11][aType] = 2; CaseAwards[27][11][aInternalId] = 1; CaseAwards[27][11][aCount] = 1200000; CaseAwards[27][11][aPriceSprayed] = 0; CaseAwards[27][11][aSubcount] = 0;
    CaseAwards[27][12][aId] = 13; CaseAwards[27][12][aRarity] = 3; CaseAwards[27][12][aType] = 5; CaseAwards[27][12][aInternalId] = 603; CaseAwards[27][12][aCount] = 0; CaseAwards[27][12][aPriceSprayed] = 150; CaseAwards[27][12][aSubcount] = 0;
    CaseAwards[27][13][aId] = 14; CaseAwards[27][13][aRarity] = 3; CaseAwards[27][13][aType] = 2; CaseAwards[27][13][aInternalId] = 1; CaseAwards[27][13][aCount] = 1500000; CaseAwards[27][13][aPriceSprayed] = 0; CaseAwards[27][13][aSubcount] = 0;
    CaseAwards[27][14][aId] = 15; CaseAwards[27][14][aRarity] = 3; CaseAwards[27][14][aType] = 5; CaseAwards[27][14][aInternalId] = 2388; CaseAwards[27][14][aCount] = 0; CaseAwards[27][14][aPriceSprayed] = 210; CaseAwards[27][14][aSubcount] = 0;
    CaseAwards[27][15][aId] = 16; CaseAwards[27][15][aRarity] = 3; CaseAwards[27][15][aType] = 11; CaseAwards[27][15][aInternalId] = 1093; CaseAwards[27][15][aCount] = 1; CaseAwards[27][15][aPriceSprayed] = 200; CaseAwards[27][15][aSubcount] = 0;
    CaseAwards[27][16][aId] = 17; CaseAwards[27][16][aRarity] = 4; CaseAwards[27][16][aType] = 11; CaseAwards[27][16][aInternalId] = 134; CaseAwards[27][16][aCount] = 5500107; CaseAwards[27][16][aPriceSprayed] = 220; CaseAwards[27][16][aSubcount] = 0;
    CaseAwards[27][17][aId] = 18; CaseAwards[27][17][aRarity] = 4; CaseAwards[27][17][aType] = 11; CaseAwards[27][17][aInternalId] = 1092; CaseAwards[27][17][aCount] = 1; CaseAwards[27][17][aPriceSprayed] = 220; CaseAwards[27][17][aSubcount] = 0;
    CaseAwards[27][18][aId] = 19; CaseAwards[27][18][aRarity] = 4; CaseAwards[27][18][aType] = 11; CaseAwards[27][18][aInternalId] = 1091; CaseAwards[27][18][aCount] = 1; CaseAwards[27][18][aPriceSprayed] = 220; CaseAwards[27][18][aSubcount] = 0;
    CaseAwards[27][19][aId] = 20; CaseAwards[27][19][aRarity] = 4; CaseAwards[27][19][aType] = 2; CaseAwards[27][19][aInternalId] = 1; CaseAwards[27][19][aCount] = 3000000; CaseAwards[27][19][aPriceSprayed] = 0; CaseAwards[27][19][aSubcount] = 0;
    CaseAwards[27][20][aId] = 21; CaseAwards[27][20][aRarity] = 4; CaseAwards[27][20][aType] = 5; CaseAwards[27][20][aInternalId] = 503; CaseAwards[27][20][aCount] = 0; CaseAwards[27][20][aPriceSprayed] = 240; CaseAwards[27][20][aSubcount] = 0;
    CaseAwards[27][21][aId] = 22; CaseAwards[27][21][aRarity] = 4; CaseAwards[27][21][aType] = 5; CaseAwards[27][21][aInternalId] = 2553; CaseAwards[27][21][aCount] = 0; CaseAwards[27][21][aPriceSprayed] = 230; CaseAwards[27][21][aSubcount] = 0;
    CaseAwards[27][22][aId] = 23; CaseAwards[27][22][aRarity] = 4; CaseAwards[27][22][aType] = 11; CaseAwards[27][22][aInternalId] = 134; CaseAwards[27][22][aCount] = 5500108; CaseAwards[27][22][aPriceSprayed] = 220; CaseAwards[27][22][aSubcount] = 0;
    CaseAwards[27][23][aId] = 24; CaseAwards[27][23][aRarity] = 4; CaseAwards[27][23][aType] = 5; CaseAwards[27][23][aInternalId] = 490; CaseAwards[27][23][aCount] = 0; CaseAwards[27][23][aPriceSprayed] = 290; CaseAwards[27][23][aSubcount] = 0;
    CaseAwards[27][24][aId] = 25; CaseAwards[27][24][aRarity] = 5; CaseAwards[27][24][aType] = 5; CaseAwards[27][24][aInternalId] = 28749; CaseAwards[27][24][aCount] = 0; CaseAwards[27][24][aPriceSprayed] = 750; CaseAwards[27][24][aSubcount] = 190;
    CaseBonus[27][0][bId] = 1; CaseBonus[27][0][bNumberOpen] = 40; CaseBonus[27][0][bRarity] = 5; CaseBonus[27][0][bType] = 5; CaseBonus[27][0][bInternalId] = 28750; CaseBonus[27][0][bCount] = 0; CaseBonus[27][0][bPriceSprayed] = 320;
    CaseBonus[27][1][bId] = 2; CaseBonus[27][1][bNumberOpen] = 30; CaseBonus[27][1][bRarity] = 3; CaseBonus[27][1][bType] = 2; CaseBonus[27][1][bInternalId] = 1; CaseBonus[27][1][bCount] = 2500000; CaseBonus[27][1][bPriceSprayed] = 0;
    CaseBonus[27][2][bId] = 3; CaseBonus[27][2][bNumberOpen] = 20; CaseBonus[27][2][bRarity] = 4; CaseBonus[27][2][bType] = 4; CaseBonus[27][2][bInternalId] = 24; CaseBonus[27][2][bCount] = 2; CaseBonus[27][2][bPriceSprayed] = 0;
    CaseBonus[27][3][bId] = 4; CaseBonus[27][3][bNumberOpen] = 10; CaseBonus[27][3][bRarity] = 3; CaseBonus[27][3][bType] = 2; CaseBonus[27][3][bInternalId] = 1; CaseBonus[27][3][bCount] = 1200000; CaseBonus[27][3][bPriceSprayed] = 0;
    CaseBonus[27][4][bId] = 5; CaseBonus[27][4][bNumberOpen] = 5; CaseBonus[27][4][bRarity] = 4; CaseBonus[27][4][bType] = 4; CaseBonus[27][4][bInternalId] = 24; CaseBonus[27][4][bCount] = 1; CaseBonus[27][4][bPriceSprayed] = 0;

    // case json id 29 - Hunter Case
    CaseData[28][cId] = 29;
    CaseData[28][cPriceOne] = 650;
    CaseData[28][cPriceTen] = 6500;
    CaseData[28][cDiscountOne] = 0;
    CaseData[28][cDiscountTen] = 5;
    CaseData[28][cAwardsCount] = 20;
    CaseData[28][cBonusCount] = 5;
    CaseAwards[28][0][aId] = 1; CaseAwards[28][0][aRarity] = 1; CaseAwards[28][0][aType] = 2; CaseAwards[28][0][aInternalId] = 1; CaseAwards[28][0][aCount] = 300000; CaseAwards[28][0][aPriceSprayed] = 0; CaseAwards[28][0][aSubcount] = 0;
    CaseAwards[28][1][aId] = 2; CaseAwards[28][1][aRarity] = 1; CaseAwards[28][1][aType] = 3; CaseAwards[28][1][aInternalId] = 1; CaseAwards[28][1][aCount] = 100; CaseAwards[28][1][aPriceSprayed] = 0; CaseAwards[28][1][aSubcount] = 0;
    CaseAwards[28][2][aId] = 3; CaseAwards[28][2][aRarity] = 1; CaseAwards[28][2][aType] = 10; CaseAwards[28][2][aInternalId] = 1; CaseAwards[28][2][aCount] = 1000; CaseAwards[28][2][aPriceSprayed] = 0; CaseAwards[28][2][aSubcount] = 0;
    CaseAwards[28][3][aId] = 4; CaseAwards[28][3][aRarity] = 1; CaseAwards[28][3][aType] = 9; CaseAwards[28][3][aInternalId] = 1; CaseAwards[28][3][aCount] = 24; CaseAwards[28][3][aPriceSprayed] = 30; CaseAwards[28][3][aSubcount] = 0;
    CaseAwards[28][4][aId] = 5; CaseAwards[28][4][aRarity] = 2; CaseAwards[28][4][aType] = 4; CaseAwards[28][4][aInternalId] = 2; CaseAwards[28][4][aCount] = 1; CaseAwards[28][4][aPriceSprayed] = 0; CaseAwards[28][4][aSubcount] = 0;
    CaseAwards[28][5][aId] = 6; CaseAwards[28][5][aRarity] = 2; CaseAwards[28][5][aType] = 21; CaseAwards[28][5][aInternalId] = 1; CaseAwards[28][5][aCount] = 100; CaseAwards[28][5][aPriceSprayed] = 0; CaseAwards[28][5][aSubcount] = 0;
    CaseAwards[28][6][aId] = 7; CaseAwards[28][6][aRarity] = 2; CaseAwards[28][6][aType] = 11; CaseAwards[28][6][aInternalId] = 22; CaseAwards[28][6][aCount] = 3; CaseAwards[28][6][aPriceSprayed] = 25; CaseAwards[28][6][aSubcount] = 0;
    CaseAwards[28][7][aId] = 8; CaseAwards[28][7][aRarity] = 2; CaseAwards[28][7][aType] = 11; CaseAwards[28][7][aInternalId] = 23; CaseAwards[28][7][aCount] = 3; CaseAwards[28][7][aPriceSprayed] = 25; CaseAwards[28][7][aSubcount] = 0;
    CaseAwards[28][8][aId] = 9; CaseAwards[28][8][aRarity] = 2; CaseAwards[28][8][aType] = 11; CaseAwards[28][8][aInternalId] = 21; CaseAwards[28][8][aCount] = 2; CaseAwards[28][8][aPriceSprayed] = 25; CaseAwards[28][8][aSubcount] = 0;
    CaseAwards[28][9][aId] = 10; CaseAwards[28][9][aRarity] = 2; CaseAwards[28][9][aType] = 5; CaseAwards[28][9][aInternalId] = 542; CaseAwards[28][9][aCount] = 0; CaseAwards[28][9][aPriceSprayed] = 80; CaseAwards[28][9][aSubcount] = 0;
    CaseAwards[28][10][aId] = 11; CaseAwards[28][10][aRarity] = 2; CaseAwards[28][10][aType] = 5; CaseAwards[28][10][aInternalId] = 458; CaseAwards[28][10][aCount] = 0; CaseAwards[28][10][aPriceSprayed] = 90; CaseAwards[28][10][aSubcount] = 0;
    CaseAwards[28][11][aId] = 12; CaseAwards[28][11][aRarity] = 3; CaseAwards[28][11][aType] = 2; CaseAwards[28][11][aInternalId] = 1; CaseAwards[28][11][aCount] = 700000; CaseAwards[28][11][aPriceSprayed] = 0; CaseAwards[28][11][aSubcount] = 0;
    CaseAwards[28][12][aId] = 13; CaseAwards[28][12][aRarity] = 3; CaseAwards[28][12][aType] = 3; CaseAwards[28][12][aInternalId] = 1; CaseAwards[28][12][aCount] = 250; CaseAwards[28][12][aPriceSprayed] = 0; CaseAwards[28][12][aSubcount] = 0;
    CaseAwards[28][13][aId] = 14; CaseAwards[28][13][aRarity] = 3; CaseAwards[28][13][aType] = 9; CaseAwards[28][13][aInternalId] = 2; CaseAwards[28][13][aCount] = 48; CaseAwards[28][13][aPriceSprayed] = 70; CaseAwards[28][13][aSubcount] = 0;
    CaseAwards[28][14][aId] = 15; CaseAwards[28][14][aRarity] = 3; CaseAwards[28][14][aType] = 4; CaseAwards[28][14][aInternalId] = 3; CaseAwards[28][14][aCount] = 1; CaseAwards[28][14][aPriceSprayed] = 0; CaseAwards[28][14][aSubcount] = 0;
    CaseAwards[28][15][aId] = 16; CaseAwards[28][15][aRarity] = 3; CaseAwards[28][15][aType] = 5; CaseAwards[28][15][aInternalId] = 603; CaseAwards[28][15][aCount] = 0; CaseAwards[28][15][aPriceSprayed] = 150; CaseAwards[28][15][aSubcount] = 0;
    CaseAwards[28][16][aId] = 17; CaseAwards[28][16][aRarity] = 4; CaseAwards[28][16][aType] = 5; CaseAwards[28][16][aInternalId] = 560; CaseAwards[28][16][aCount] = 0; CaseAwards[28][16][aPriceSprayed] = 180; CaseAwards[28][16][aSubcount] = 0;
    CaseAwards[28][17][aId] = 18; CaseAwards[28][17][aRarity] = 4; CaseAwards[28][17][aType] = 11; CaseAwards[28][17][aInternalId] = 134; CaseAwards[28][17][aCount] = 11962; CaseAwards[28][17][aPriceSprayed] = 180; CaseAwards[28][17][aSubcount] = 0;
    CaseAwards[28][18][aId] = 19; CaseAwards[28][18][aRarity] = 4; CaseAwards[28][18][aType] = 5; CaseAwards[28][18][aInternalId] = 579; CaseAwards[28][18][aCount] = 0; CaseAwards[28][18][aPriceSprayed] = 250; CaseAwards[28][18][aSubcount] = 0;
    CaseAwards[28][19][aId] = 20; CaseAwards[28][19][aRarity] = 5; CaseAwards[28][19][aType] = 5; CaseAwards[28][19][aInternalId] = 415; CaseAwards[28][19][aCount] = 0; CaseAwards[28][19][aPriceSprayed] = 400; CaseAwards[28][19][aSubcount] = 0;
    CaseBonus[28][0][bId] = 1; CaseBonus[28][0][bNumberOpen] = 40; CaseBonus[28][0][bRarity] = 5; CaseBonus[28][0][bType] = 5; CaseBonus[28][0][bInternalId] = 579; CaseBonus[28][0][bCount] = 0; CaseBonus[28][0][bPriceSprayed] = 300;
    CaseBonus[28][1][bId] = 2; CaseBonus[28][1][bNumberOpen] = 30; CaseBonus[28][1][bRarity] = 4; CaseBonus[28][1][bType] = 3; CaseBonus[28][1][bInternalId] = 1; CaseBonus[28][1][bCount] = 500; CaseBonus[28][1][bPriceSprayed] = 0;
    CaseBonus[28][2][bId] = 3; CaseBonus[28][2][bNumberOpen] = 20; CaseBonus[28][2][bRarity] = 4; CaseBonus[28][2][bType] = 4; CaseBonus[28][2][bInternalId] = 3; CaseBonus[28][2][bCount] = 2; CaseBonus[28][2][bPriceSprayed] = 0;
    CaseBonus[28][3][bId] = 4; CaseBonus[28][3][bNumberOpen] = 10; CaseBonus[28][3][bRarity] = 3; CaseBonus[28][3][bType] = 21; CaseBonus[28][3][bInternalId] = 1; CaseBonus[28][3][bCount] = 300; CaseBonus[28][3][bPriceSprayed] = 0;
    CaseBonus[28][4][bId] = 5; CaseBonus[28][4][bNumberOpen] = 5; CaseBonus[28][4][bRarity] = 4; CaseBonus[28][4][bType] = 4; CaseBonus[28][4][bInternalId] = 29; CaseBonus[28][4][bCount] = 1; CaseBonus[28][4][bPriceSprayed] = 0;


    return 1;
}

stock Cases_ApplyHunterVisibleSlotFix()
{
    // Visible client slot fix: use existing case id 21 instead of hidden new id 29.
    new caseIdx = Cases_GetIndex(21);
    if(caseIdx == -1) caseIdx = 20;

    CaseData[caseIdx][cId] = 21;
    CaseData[caseIdx][cPriceOne] = 650;
    CaseData[caseIdx][cPriceTen] = 6500;
    CaseData[caseIdx][cDiscountOne] = 0;
    CaseData[caseIdx][cDiscountTen] = 0;
    CaseData[caseIdx][cAwardsCount] = 20;
    CaseData[caseIdx][cBonusCount] = 5;

    for(new a = 0; a < MAX_AWARDS_PER_CASE; a++)
    {
        CaseAwards[caseIdx][a][aId] = 0;
        CaseAwards[caseIdx][a][aRarity] = 0;
        CaseAwards[caseIdx][a][aType] = 0;
        CaseAwards[caseIdx][a][aInternalId] = 0;
        CaseAwards[caseIdx][a][aCount] = 0;
        CaseAwards[caseIdx][a][aPriceSprayed] = 0;
        CaseAwards[caseIdx][a][aSubcount] = 0;
    }
    for(new b = 0; b < MAX_BONUS_PER_CASE; b++)
    {
        CaseBonus[caseIdx][b][bId] = 0;
        CaseBonus[caseIdx][b][bNumberOpen] = 0;
        CaseBonus[caseIdx][b][bRarity] = 0;
        CaseBonus[caseIdx][b][bType] = 0;
        CaseBonus[caseIdx][b][bInternalId] = 0;
        CaseBonus[caseIdx][b][bCount] = 0;
        CaseBonus[caseIdx][b][bPriceSprayed] = 0;
    }

    CaseAwards[caseIdx][0][aId] = 1; CaseAwards[caseIdx][0][aRarity] = 1; CaseAwards[caseIdx][0][aType] = 2; CaseAwards[caseIdx][0][aInternalId] = 1; CaseAwards[caseIdx][0][aCount] = 150000; CaseAwards[caseIdx][0][aPriceSprayed] = 0; CaseAwards[caseIdx][0][aSubcount] = 0;
    CaseAwards[caseIdx][1][aId] = 2; CaseAwards[caseIdx][1][aRarity] = 1; CaseAwards[caseIdx][1][aType] = 2; CaseAwards[caseIdx][1][aInternalId] = 1; CaseAwards[caseIdx][1][aCount] = 300000; CaseAwards[caseIdx][1][aPriceSprayed] = 0; CaseAwards[caseIdx][1][aSubcount] = 0;
    CaseAwards[caseIdx][2][aId] = 3; CaseAwards[caseIdx][2][aRarity] = 1; CaseAwards[caseIdx][2][aType] = 3; CaseAwards[caseIdx][2][aInternalId] = 1; CaseAwards[caseIdx][2][aCount] = 50; CaseAwards[caseIdx][2][aPriceSprayed] = 0; CaseAwards[caseIdx][2][aSubcount] = 0;
    CaseAwards[caseIdx][3][aId] = 4; CaseAwards[caseIdx][3][aRarity] = 1; CaseAwards[caseIdx][3][aType] = 11; CaseAwards[caseIdx][3][aInternalId] = 22; CaseAwards[caseIdx][3][aCount] = 1; CaseAwards[caseIdx][3][aPriceSprayed] = 10; CaseAwards[caseIdx][3][aSubcount] = 0;
    CaseAwards[caseIdx][4][aId] = 5; CaseAwards[caseIdx][4][aRarity] = 1; CaseAwards[caseIdx][4][aType] = 11; CaseAwards[caseIdx][4][aInternalId] = 23; CaseAwards[caseIdx][4][aCount] = 1; CaseAwards[caseIdx][4][aPriceSprayed] = 10; CaseAwards[caseIdx][4][aSubcount] = 0;
    CaseAwards[caseIdx][5][aId] = 6; CaseAwards[caseIdx][5][aRarity] = 2; CaseAwards[caseIdx][5][aType] = 9; CaseAwards[caseIdx][5][aInternalId] = 1; CaseAwards[caseIdx][5][aCount] = 72; CaseAwards[caseIdx][5][aPriceSprayed] = 30; CaseAwards[caseIdx][5][aSubcount] = 0;
    CaseAwards[caseIdx][6][aId] = 7; CaseAwards[caseIdx][6][aRarity] = 2; CaseAwards[caseIdx][6][aType] = 2; CaseAwards[caseIdx][6][aInternalId] = 1; CaseAwards[caseIdx][6][aCount] = 700000; CaseAwards[caseIdx][6][aPriceSprayed] = 0; CaseAwards[caseIdx][6][aSubcount] = 0;
    CaseAwards[caseIdx][7][aId] = 8; CaseAwards[caseIdx][7][aRarity] = 2; CaseAwards[caseIdx][7][aType] = 3; CaseAwards[caseIdx][7][aInternalId] = 1; CaseAwards[caseIdx][7][aCount] = 150; CaseAwards[caseIdx][7][aPriceSprayed] = 0; CaseAwards[caseIdx][7][aSubcount] = 0;
    CaseAwards[caseIdx][8][aId] = 9; CaseAwards[caseIdx][8][aRarity] = 2; CaseAwards[caseIdx][8][aType] = 4; CaseAwards[caseIdx][8][aInternalId] = 3; CaseAwards[caseIdx][8][aCount] = 1; CaseAwards[caseIdx][8][aPriceSprayed] = 0; CaseAwards[caseIdx][8][aSubcount] = 0;
    CaseAwards[caseIdx][9][aId] = 10; CaseAwards[caseIdx][9][aRarity] = 3; CaseAwards[caseIdx][9][aType] = 9; CaseAwards[caseIdx][9][aInternalId] = 2; CaseAwards[caseIdx][9][aCount] = 72; CaseAwards[caseIdx][9][aPriceSprayed] = 50; CaseAwards[caseIdx][9][aSubcount] = 0;
    CaseAwards[caseIdx][10][aId] = 11; CaseAwards[caseIdx][10][aRarity] = 3; CaseAwards[caseIdx][10][aType] = 2; CaseAwards[caseIdx][10][aInternalId] = 1; CaseAwards[caseIdx][10][aCount] = 1000000; CaseAwards[caseIdx][10][aPriceSprayed] = 0; CaseAwards[caseIdx][10][aSubcount] = 0;
    CaseAwards[caseIdx][11][aId] = 12; CaseAwards[caseIdx][11][aRarity] = 3; CaseAwards[caseIdx][11][aType] = 3; CaseAwards[caseIdx][11][aInternalId] = 1; CaseAwards[caseIdx][11][aCount] = 300; CaseAwards[caseIdx][11][aPriceSprayed] = 0; CaseAwards[caseIdx][11][aSubcount] = 0;
    CaseAwards[caseIdx][12][aId] = 13; CaseAwards[caseIdx][12][aRarity] = 3; CaseAwards[caseIdx][12][aType] = 5; CaseAwards[caseIdx][12][aInternalId] = 492; CaseAwards[caseIdx][12][aCount] = 0; CaseAwards[caseIdx][12][aPriceSprayed] = 120; CaseAwards[caseIdx][12][aSubcount] = 0;
    CaseAwards[caseIdx][13][aId] = 14; CaseAwards[caseIdx][13][aRarity] = 3; CaseAwards[caseIdx][13][aType] = 5; CaseAwards[caseIdx][13][aInternalId] = 542; CaseAwards[caseIdx][13][aCount] = 0; CaseAwards[caseIdx][13][aPriceSprayed] = 130; CaseAwards[caseIdx][13][aSubcount] = 0;
    CaseAwards[caseIdx][14][aId] = 15; CaseAwards[caseIdx][14][aRarity] = 4; CaseAwards[caseIdx][14][aType] = 5; CaseAwards[caseIdx][14][aInternalId] = 2618; CaseAwards[caseIdx][14][aCount] = 0; CaseAwards[caseIdx][14][aPriceSprayed] = 220; CaseAwards[caseIdx][14][aSubcount] = 0;
    CaseAwards[caseIdx][15][aId] = 16; CaseAwards[caseIdx][15][aRarity] = 4; CaseAwards[caseIdx][15][aType] = 9; CaseAwards[caseIdx][15][aInternalId] = 3; CaseAwards[caseIdx][15][aCount] = 168; CaseAwards[caseIdx][15][aPriceSprayed] = 150; CaseAwards[caseIdx][15][aSubcount] = 0;
    CaseAwards[caseIdx][16][aId] = 17; CaseAwards[caseIdx][16][aRarity] = 4; CaseAwards[caseIdx][16][aType] = 2; CaseAwards[caseIdx][16][aInternalId] = 1; CaseAwards[caseIdx][16][aCount] = 2000000; CaseAwards[caseIdx][16][aPriceSprayed] = 0; CaseAwards[caseIdx][16][aSubcount] = 0;
    CaseAwards[caseIdx][17][aId] = 18; CaseAwards[caseIdx][17][aRarity] = 4; CaseAwards[caseIdx][17][aType] = 3; CaseAwards[caseIdx][17][aInternalId] = 1; CaseAwards[caseIdx][17][aCount] = 600; CaseAwards[caseIdx][17][aPriceSprayed] = 0; CaseAwards[caseIdx][17][aSubcount] = 0;
    CaseAwards[caseIdx][18][aId] = 19; CaseAwards[caseIdx][18][aRarity] = 5; CaseAwards[caseIdx][18][aType] = 5; CaseAwards[caseIdx][18][aInternalId] = 2568; CaseAwards[caseIdx][18][aCount] = 0; CaseAwards[caseIdx][18][aPriceSprayed] = 350; CaseAwards[caseIdx][18][aSubcount] = 0;
    CaseAwards[caseIdx][19][aId] = 20; CaseAwards[caseIdx][19][aRarity] = 5; CaseAwards[caseIdx][19][aType] = 11; CaseAwards[caseIdx][19][aInternalId] = 134; CaseAwards[caseIdx][19][aCount] = 58; CaseAwards[caseIdx][19][aPriceSprayed] = 200; CaseAwards[caseIdx][19][aSubcount] = 0;

    CaseBonus[caseIdx][0][bId] = 1; CaseBonus[caseIdx][0][bNumberOpen] = 40; CaseBonus[caseIdx][0][bRarity] = 5; CaseBonus[caseIdx][0][bType] = 5; CaseBonus[caseIdx][0][bInternalId] = 2568; CaseBonus[caseIdx][0][bCount] = 0; CaseBonus[caseIdx][0][bPriceSprayed] = 350;
    CaseBonus[caseIdx][1][bId] = 2; CaseBonus[caseIdx][1][bNumberOpen] = 30; CaseBonus[caseIdx][1][bRarity] = 4; CaseBonus[caseIdx][1][bType] = 3; CaseBonus[caseIdx][1][bInternalId] = 1; CaseBonus[caseIdx][1][bCount] = 600; CaseBonus[caseIdx][1][bPriceSprayed] = 0;
    CaseBonus[caseIdx][2][bId] = 3; CaseBonus[caseIdx][2][bNumberOpen] = 20; CaseBonus[caseIdx][2][bRarity] = 3; CaseBonus[caseIdx][2][bType] = 4; CaseBonus[caseIdx][2][bInternalId] = 3; CaseBonus[caseIdx][2][bCount] = 2; CaseBonus[caseIdx][2][bPriceSprayed] = 0;
    CaseBonus[caseIdx][3][bId] = 4; CaseBonus[caseIdx][3][bNumberOpen] = 10; CaseBonus[caseIdx][3][bRarity] = 3; CaseBonus[caseIdx][3][bType] = 3; CaseBonus[caseIdx][3][bInternalId] = 1; CaseBonus[caseIdx][3][bCount] = 300; CaseBonus[caseIdx][3][bPriceSprayed] = 0;
    CaseBonus[caseIdx][4][bId] = 5; CaseBonus[caseIdx][4][bNumberOpen] = 5; CaseBonus[caseIdx][4][bRarity] = 3; CaseBonus[caseIdx][4][bType] = 4; CaseBonus[caseIdx][4][bInternalId] = 21; CaseBonus[caseIdx][4][bCount] = 1; CaseBonus[caseIdx][4][bPriceSprayed] = 0;
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
        CaseData[i][cAwardsCount] = 0;
        CaseData[i][cBonusCount] = 0;

        for(new a = 0; a < MAX_AWARDS_PER_CASE; a++)
        {
            CaseAwards[i][a][aId] = 0;
            CaseAwards[i][a][aRarity] = 0;
            CaseAwards[i][a][aType] = 0;
            CaseAwards[i][a][aInternalId] = 0;
            CaseAwards[i][a][aCount] = 0;
            CaseAwards[i][a][aPriceSprayed] = 0;
            CaseAwards[i][a][aSubcount] = 0;
        }

        for(new b = 0; b < MAX_BONUS_PER_CASE; b++)
        {
            CaseBonus[i][b][bId] = 0;
            CaseBonus[i][b][bNumberOpen] = 0;
            CaseBonus[i][b][bRarity] = 0;
            CaseBonus[i][b][bType] = 0;
            CaseBonus[i][b][bInternalId] = 0;
            CaseBonus[i][b][bCount] = 0;
            CaseBonus[i][b][bPriceSprayed] = 0;
        }
    }

    Cases_InitGeneratedFromJson();
    Cases_ApplyHunterVisibleSlotFix();

    printf("[Cases] System initialized from scriptfiles/cases.json data: %d cases", MAX_CASES);
    return 1;
}

stock Cases_GetIndex(caseId)
{
    for(new i = 0; i < MAX_CASES; i++) {
        if(CaseData[i][cId] == caseId) return i;
    }
    return -1;
}

stock Cases_SyncBaseAccountCaseCounts(playerid)
{
    new idx;
    idx = Cases_GetIndex(1); if(idx != -1) pCasesOwned[playerid][idx] = GetPlayerData(playerid, P_COUNT_TODAY_CASE);
    idx = Cases_GetIndex(2); if(idx != -1) pCasesOwned[playerid][idx] = GetPlayerData(playerid, P_COUNT_BOMJ_CASE);
    idx = Cases_GetIndex(3); if(idx != -1) pCasesOwned[playerid][idx] = GetPlayerData(playerid, P_COUNT_STANDART_CASE);
    idx = Cases_GetIndex(4); if(idx != -1) pCasesOwned[playerid][idx] = GetPlayerData(playerid, P_COUNT_CAR_CASE);
    idx = Cases_GetIndex(5); if(idx != -1) pCasesOwned[playerid][idx] = GetPlayerData(playerid, P_COUNT_OSOBIY_CASE);
    idx = Cases_GetIndex(6); if(idx != -1) pCasesOwned[playerid][idx] = GetPlayerData(playerid, P_COUNT_DOP_CASE1);
    return 1;
}

stock GetPlayerCaseCountByType(playerid, case_type)
{
    new idx = Cases_GetIndex(case_type);
    if(idx != -1) return pCasesOwned[playerid][idx];
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(value < 0) value = 0;

    new idx = Cases_GetIndex(case_type);
    if(idx != -1) pCasesOwned[playerid][idx] = value;

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
        case 6:
        {
            SetPlayerData(playerid, P_COUNT_DOP_CASE1, value);
            UpdatePlayerDatabaseInt(playerid, "countdopcases1", value);
        }
    }
    return (idx != -1);
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
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
		pCasesOwned[playerid][i] = 0;
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
			cbArray = JSON_Append(cbArray, bonusObj);
		}
	}
	return 1;
}

stock Cases_ShowGUI(playerid)
{
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) {
        selectedIdx = 0;
        pCasesSelected[playerid] = CaseData[selectedIdx][cId];
    }
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", pCasesDust[playerid]);
    JSON_SetInt(json, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", 0);
    
    new Node:ccArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++) 
	{
		new caseId = CaseData[c][cId];
        if(caseId == 0) continue;
        
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", caseId);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, caseId));
        new Node:tempArray = JSON_Array(cc_obj);
        ccArray = JSON_Append(ccArray, tempArray);
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
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;
    
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
		new caseId = CaseData[c][cId];
        if(caseId == 0) continue;
        
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", caseId);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, caseId));
        new Node:tempArray = JSON_Array(cc_obj);
        ccArray = JSON_Append(ccArray, tempArray);
    }
    JSON_SetArray(json, "cc", ccArray);
    
    new Node:cbArray = JSON_Array();
    Cases_BuildCbArray(playerid, cbArray);
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
			Cases_TakeRewards(playerid, jsonData);
		}
		case CASES_TYPE_GO_DONATE: {
			new donateType = 0;
			JSON_GetInt(json, "d", donateType);
			if(donateType == 2) {
				SendClientMessage(playerid, 0xFFFF00FF, "Open donate shop to buy BC.");
			}
		}
		case CASES_TYPE_OPEN_SUPER: {
			AddPlayerCaseCountByType(playerid, 5, 1);
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
    if(idx == -1)
    {
        caseId = 1;
        idx = Cases_GetIndex(caseId);
        if(idx == -1) return 0;
    }

    pCasesSelected[playerid] = caseId;
    Cases_UpdateGUI(playerid);
    return 1;
}


stock Cases_OpenCase(playerid, caseId, openType)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1 && pCasesSelected[playerid] > 0)
    {
        caseId = pCasesSelected[playerid];
        idx = Cases_GetIndex(caseId);
    }
    if(idx == -1)
    {
        caseId = 1;
        idx = Cases_GetIndex(caseId);
    }
    if(idx == -1)
    {
        new Node:err = JSON_Object();
        JSON_SetInt(err, "t", CASES_TYPE_OPEN);
        JSON_SetInt(err, "s", -1);
        JSON_SetInt(err, "d", 1);
        Cases_SendPacket(playerid, GUICases, err);
        JSON_Cleanup(err);
        return 0;
    }

    if(openType != CASES_OPEN_ONE && openType != CASES_OPEN_TEN) openType = CASES_OPEN_ONE;

    new openCount = (openType == CASES_OPEN_ONE) ? 1 : 10;
    new rewardIds[10];
    new useOwnedCases = 0;
    new ownedCount = GetPlayerCaseCountByType(playerid, caseId);

    if(ownedCount > 0)
    {
        if(ownedCount < openCount)
        {
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

    if(useOwnedCases)
    {
        AddPlayerCaseCountByType(playerid, caseId, -openCount);
    }
    else
    {
        new price = (openType == CASES_OPEN_ONE) ? CaseData[idx][cPriceOne] : CaseData[idx][cPriceTen];
        new discount = (openType == CASES_OPEN_ONE) ? CaseData[idx][cDiscountOne] : CaseData[idx][cDiscountTen];
        price = price - (price * discount / 100);

        if(GetPlayerDonateRub(playerid) < price)
        {
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

    for(new r = 0; r < 10; r++) pCasesPendingRewards[playerid][r] = 0;
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

    /*
        APK strict mode: Simple Russia 16.21.0 expects result packet exactly as:
        {"t":2,"s":1,"bc":...,"pc":...,"bcc":...,"cs":...,"type":1/2,"pr":[awardId...]}
        Long roulette arrays can crash Compose, so `pr` contains only the real opened rewards:
        1 id for x1, 10 ids for x10. Rewards are stored in /reward immediately.
    */
    for(new r = 0; r < openCount; r++)
    {
        Cases_AddRewardToRewardStorage(playerid, caseId, rewardIds[r]);
    }

    new prStr[256];
    prStr[0] = '\0';
    for(new r = 0; r < openCount; r++)
    {
        new tmp[16];
        if(r > 0) strcat(prStr, ",");
        format(tmp, sizeof(tmp), "%d", rewardIds[r]);
        strcat(prStr, tmp);
    }

    // Rewards already moved to /reward on open; client take/spray packet must not duplicate them.
    pCasesPendingCount[playerid] = 0;
    for(new r = 0; r < 10; r++) pCasesPendingRewards[playerid][r] = 0;

    new jsonStr[1024];
    format(jsonStr, sizeof(jsonStr),
        "{\"t\":%d,\"s\":1,\"bc\":%d,\"pc\":%d,\"bcc\":%d,\"cs\":%d,\"type\":%d,\"pr\":[%s]}",
        CASES_TYPE_OPEN, GetPlayerDonateRub(playerid), pCasesDust[playerid],
        pCasesOpenedByCase[playerid][idx], caseId, openType, prStr);

    new Node:json;
    if(JSON_Parse(jsonStr, json) != 0)
    {
        printf("[CASES] ERROR: Failed to parse open JSON: %s", jsonStr);
        return 0;
    }

    Cases_SendPacket(playerid, GUICases, json);
    JSON_Cleanup(json);

    Cases_SavePlayer(playerid);
    printf("[Cases] Player %d opened case %d, rewards saved to /reward", playerid, caseId);
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

    while(pCasesDust[playerid] >= 2000)
    {
        pCasesDust[playerid] -= 2000;
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
        new Node:json = JSON_Object(
            "t", JSON_Int(CASES_TYPE_OPEN_SUPER),
            "s", JSON_Int(0),
            "bc", JSON_Int(GetPlayerDonateRub(playerid)),
            "pc", JSON_Int(pCasesDust[playerid]),
            "bcc", JSON_Int(pCasesOpenedByCase[playerid][selectedIdx])
        );
        Cases_SendPacket(playerid, GUICases, json);
        JSON_Cleanup(json);
        if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
        Cases_SavePlayer(playerid);
        return 1;
    }
    return 0;
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

    new lastIdx = pCasesLastOpenedIdx[playerid];
    if(lastIdx >= 0 && lastIdx < MAX_CASES)
    {
        for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++)
        {
            if(CaseAwards[lastIdx][i][aId] == rewardId)
            {
                pCasesDust[playerid] += CaseAwards[lastIdx][i][aPriceSprayed];
                return CaseAwards[lastIdx][i][aPriceSprayed];
            }
        }
    }

    for(new c = 0; c < MAX_CASES; c++)
    {
        for(new i = 0; i < CaseData[c][cAwardsCount]; i++)
        {
            if(CaseAwards[c][i][aId] == rewardId)
            {
                pCasesDust[playerid] += CaseAwards[c][i][aPriceSprayed];
                return CaseAwards[c][i][aPriceSprayed];
            }
        }
    }
    return 0;
}

stock Cases_TakeRewards(playerid, const jsonData[])
{
    new takeRewards[10], sprayRewards[10];
    new takeCount = Cases_ExtractIntArray(jsonData, "bt1", takeRewards, 10);
    new sprayCount = Cases_ExtractIntArray(jsonData, "bt2", sprayRewards, 10);
    new totalDustGained = 0, storedRewards = 0;

    if(takeCount == 0 && sprayCount == 0 && pCasesPendingCount[playerid] > 0)
    {
        for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
        {
            takeRewards[takeCount++] = pCasesPendingRewards[playerid][i];
        }
    }

    new lastIdx = pCasesLastOpenedIdx[playerid];
    new caseId = (lastIdx >= 0 && lastIdx < MAX_CASES) ? CaseData[lastIdx][cId] : pCasesSelected[playerid];

    for(new i = 0; i < takeCount; i++)
    {
        if(takeRewards[i] <= 0) continue;
        if(!Cases_IsPendingReward(playerid, takeRewards[i])) continue;
        if(Cases_AddRewardToRewardStorage(playerid, caseId, takeRewards[i])) storedRewards++;
    }

    for(new i = 0; i < sprayCount; i++)
    {
        if(sprayRewards[i] <= 0) continue;
        if(!Cases_IsPendingReward(playerid, sprayRewards[i])) continue;
        totalDustGained += Cases_SprayReward(playerid, sprayRewards[i]);
    }

    Cases_CheckDustReward(playerid);

    pCasesPendingCount[playerid] = 0;
    for(new i = 0; i < 10; i++) pCasesPendingRewards[playerid][i] = 0;

    Cases_SavePlayer(playerid);

    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", CASES_TYPE_TAKE_REWARDS);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "pc", pCasesDust[playerid]);
    JSON_SetInt(response, "bcc", pCasesOpenedByCase[playerid][selectedIdx]);
    Cases_SendPacket(playerid, GUICases, response);
    JSON_Cleanup(response);

    if(storedRewards > 0)
    {
        new str[96];
        format(str, sizeof(str), "Rewards moved to /reward: %d", storedRewards);
        SendClientMessage(playerid, 0x66CC00FF, str);
    }
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
    Cases_AddRewardToRewardStorage(playerid, CaseData[caseIdx][cId], CaseBonus[caseIdx][bonusIdx][bId]);
    SendClientMessage(playerid, 0x66CC00FF, "Bonus reward moved to /reward.");

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
    for(new c = 6; c < MAX_CASES; c++) 
	{
        if(CaseData[c][cId] != 0 && CaseData[c][cId] != c+1) 
		{
            
            continue;
        }
     
        CaseData[c][cId] = c + 1;
        CaseData[c][cPriceOne] = 900;
        CaseData[c][cPriceTen] = 9000;
        CaseData[c][cDiscountOne] = 0;
        CaseData[c][cDiscountTen] = 5;
        CaseData[c][cAwardsCount] = 25;
        CaseData[c][cBonusCount] = 5;
        
        for(new i = 0; i < 25; i++) {
            CaseAwards[c][i][aId] = i + 1;
            CaseAwards[c][i][aRarity] = (i < 10) ? 2 : ((i < 18) ? 3 : ((i < 23) ? 4 : 5));
            CaseAwards[c][i][aType] = (i % 3 == 0) ? 5 : ((i % 3 == 1) ? 11 : 2);
            CaseAwards[c][i][aInternalId] = 500 + i;
            CaseAwards[c][i][aCount] = (CaseAwards[c][i][aType] == 2) ? 100000 * (i + 1) : 1;
            CaseAwards[c][i][aPriceSprayed] = 100 + (i * 10);
        }
        
        CaseBonus[c][0][bId] = (c+1)*100+1; 
        CaseBonus[c][0][bNumberOpen] = 40; 
        CaseBonus[c][0][bRarity] = 5; 
        CaseBonus[c][0][bType] = 5; 
        CaseBonus[c][0][bInternalId] = 600+c; 
        CaseBonus[c][0][bCount] = 0; 
        CaseBonus[c][0][bPriceSprayed] = 300;
        
        CaseBonus[c][1][bId] = (c+1)*100+2; 
        CaseBonus[c][1][bNumberOpen] = 30; 
        CaseBonus[c][1][bRarity] = 4; 
        CaseBonus[c][1][bType] = 21; 
        CaseBonus[c][1][bInternalId] = 1; 
        CaseBonus[c][1][bCount] = 350; 
        CaseBonus[c][1][bPriceSprayed] = 0;
        
        CaseBonus[c][2][bId] = (c+1)*100+3; 
        CaseBonus[c][2][bNumberOpen] = 20; 
        CaseBonus[c][2][bRarity] = 4; 
        CaseBonus[c][2][bType] = 4; 
        CaseBonus[c][2][bInternalId] = c+1; 
        CaseBonus[c][2][bCount] = 2; 
        CaseBonus[c][2][bPriceSprayed] = 0;
        
        CaseBonus[c][3][bId] = (c+1)*100+4; 
        CaseBonus[c][3][bNumberOpen] = 10; 
        CaseBonus[c][3][bRarity] = 4; 
        CaseBonus[c][3][bType] = 21; 
        CaseBonus[c][3][bInternalId] = 1; 
        CaseBonus[c][3][bCount] = 200; 
        CaseBonus[c][3][bPriceSprayed] = 0;
        
        CaseBonus[c][4][bId] = (c+1)*100+5; 
        CaseBonus[c][4][bNumberOpen] = 5; 
        CaseBonus[c][4][bRarity] = 4; 
        CaseBonus[c][4][bType] = 4; 
        CaseBonus[c][4][bInternalId] = c+1; 
        CaseBonus[c][4][bCount] = 1; 
        CaseBonus[c][4][bPriceSprayed] = 0;
    }
}

stock Cases_SavePlayer(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new ccStr[1024];
    ccStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ccStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", pCasesOwned[playerid][i]);
        strcat(ccStr, tmp);
    }

    new ocStr[1024];
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

    new query[4096];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO player_cases (user_id, dust, opened_count, selected_case, tutorial, case_counts, opened_by_case, bonus_status) \
        VALUES (%d, %d, %d, %d, %d, '%e', '%e', '%e') \
        ON DUPLICATE KEY UPDATE dust=%d, opened_count=%d, selected_case=%d, tutorial=%d, case_counts='%e', opened_by_case='%e', bonus_status='%e'",
        GetPlayerAccountID(playerid),
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
    if(cache_num_rows())
    {
        pCasesDust[playerid] = cache_get_field_content_int(0, "dust");
        pCasesOpened[playerid] = cache_get_field_content_int(0, "opened_count");
        pCasesSelected[playerid] = cache_get_field_content_int(0, "selected_case");
        pCasesTutorial[playerid] = cache_get_field_content_int(0, "tutorial");

        new ccStr[1024];
        cache_get_field_content(0, "case_counts", ccStr, mysql, sizeof(ccStr));
        if(strlen(ccStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(ccStr), tmp[16];
            while(pos < len && idx < MAX_CASES)
            {
                new end = pos;
                while(end < len && ccStr[end] != ',') end++;
                strmid(tmp, ccStr, pos, end, sizeof(tmp));
                pCasesOwned[playerid][idx++] = strval(tmp);
                pos = end + 1;
            }
        }

        new ocStr[1024];
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
    Cases_SyncBaseAccountCaseCounts(playerid);

    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM player_cases WHERE user_id = %d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Cases_OnPlayerLoad", "d", playerid);
    return 1;
}

CMD:cases(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 1;

    Cases_ShowGUI(playerid);
    return 1;
}

CMD:givehuntercase(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new to_player, count;
    if(sscanf(params, "ud", to_player, count))
        return SendClientMessage(playerid, COLOR_GREY, "Use: /givehuntercase [id] [count]");

    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, COLOR_RED, "Player not found.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count must be greater than 0.");

    AddPlayerCaseCountByType(to_player, 21, count);
    pCasesSelected[to_player] = 21;
    Cases_SavePlayer(to_player);
    SavePlayerAccount(to_player);

    SendClientMessage(playerid, COLOR_WHITE, "Hunter case issued.");
    SendClientMessage(to_player, COLOR_WHITE, "Admin issued Hunter Case to you.");

    if(pCasesGUIOpen[to_player]) Cases_UpdateGUI(to_player);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new to_player, type_case, count;
    if(sscanf(params, "udd", to_player, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Use: /givecases [id] [case_id] [count]");

    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(Cases_GetIndex(type_case) == -1) return SendClientMessage(playerid, COLOR_RED, "Invalid case_id.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(to_player, type_case, count);
    pCasesSelected[to_player] = type_case;
    Cases_SavePlayer(to_player);
    SavePlayerAccount(to_player);

    new str[128];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", count, type_case, GetPlayerNameEx(to_player));
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(to_player, COLOR_WHITE, str);
    
    if(pCasesGUIOpen[to_player]) Cases_UpdateGUI(to_player);
    
    return 1;
}