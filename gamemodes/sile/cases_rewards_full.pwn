// Вынесённый модуль: система кейсов и наград
// Исходно находился в файле bylaird-new.pwn

#define PACKET_BLACKRRPC                    252

// --- CASE BONUS: конфигурация и утилиты
#define MAX_CASES               (30)
#define MAX_CASE_BONUSES        (5)
#define CASE_BONUS_STR_LEN      (1024)

#define CASE_BONUS_STATE_LOCKED     (1)
#define CASE_BONUS_STATE_AVAILABLE  (2)
#define CASE_BONUS_STATE_CLAIMED    (3)

stock InitPlayerCaseBonusStates(dest[], destlen)
{
    dest[0] = '\0';

    for (new caseId = 1; caseId <= MAX_CASES; caseId++)
    {
        new part[64];
        format(part, sizeof(part), "%d:1,1,1,1,1", caseId);
        strcat(dest, part, destlen);

        if (caseId != MAX_CASES)
            strcat(dest, "|", destlen);
    }
    return 1;
}

stock IsValidCaseBonusStates(const str[])
{
    if (isnull(str) || !strlen(str))
        return 0;

    new token[64];
    new pos = 0;
    new parsedCases = 0;

    for (new i = 0; ; i++)
    {
        if (str[i] == '|' || str[i] == '\0')
        {
            token[pos] = '\0';
            if (!strlen(token)) return 0;

            new colonPos = -1;
            for (new j = 0; token[j] != '\0'; j++)
            {
                if (token[j] == ':')
                {
                    colonPos = j;
                    break;
                }
            }

            if (colonPos == -1) return 0;

            new left[8], right[32];
            strmid(left, token, 0, colonPos, sizeof(left));
            strmid(right, token, colonPos + 1, strlen(token), sizeof(right));

            new caseId = strval(left);
            if (caseId < 1 || caseId > MAX_CASES) return 0;

            new stateCount = 0;
            new stateBuf[8], sPos = 0;

            for (new k = 0; ; k++)
            {
                if (right[k] == ',' || right[k] == '\0')
                {
                    stateBuf[sPos] = '\0';
                    if (!strlen(stateBuf)) return 0;

                    new st = strval(stateBuf);
                    if (st < 1 || st > 3) return 0;

                    stateCount++;
                    sPos = 0;

                    if (right[k] == '\0')
                        break;
                }
                else
                {
                    if (right[k] < '0' || right[k] > '9')
                        return 0;

                    if (sPos < sizeof(stateBuf) - 1)
                        stateBuf[sPos++] = right[k];
                    else
                        return 0;
                }
            }

            if (stateCount != MAX_CASE_BONUSES)
                return 0;

            parsedCases++;
            pos = 0;

            if (str[i] == '\0')
                break;
        }
        else
        {
            if (pos < sizeof(token) - 1)
                token[pos++] = str[i];
            else
                return 0;
        }
    }

    return (parsedCases == MAX_CASES);
}

stock GetCaseBonusState(const source[], caseId, bonusIndex)
{
    if (caseId < 1 || caseId > MAX_CASES) return CASE_BONUS_STATE_LOCKED;
    if (bonusIndex < 1 || bonusIndex > MAX_CASE_BONUSES) return CASE_BONUS_STATE_LOCKED;

    new token[64];
    new pos = 0;

    for (new i = 0; ; i++)
    {
        if (source[i] == '|' || source[i] == '\0')
        {
            token[pos] = '\0';

            new colonPos = -1;
            for (new j = 0; token[j] != '\0'; j++)
            {
                if (token[j] == ':')
                {
                    colonPos = j;
                    break;
                }
            }

            if (colonPos != -1)
            {
                new left[8], right[32];
                strmid(left, token, 0, colonPos, sizeof(left));
                strmid(right, token, colonPos + 1, strlen(token), sizeof(right));

                if (strval(left) == caseId)
                {
                    new currentBonus = 1;
                    new stateBuf[8], sPos = 0;

                    for (new k = 0; ; k++)
                    {
                        if (right[k] == ',' || right[k] == '\0')
                        {
                            stateBuf[sPos] = '\0';

                            if (currentBonus == bonusIndex)
                                return strval(stateBuf);

                            currentBonus++;
                            sPos = 0;

                            if (right[k] == '\0')
                                break;
                        }
                        else
                        {
                            if (sPos < sizeof(stateBuf) - 1)
                                stateBuf[sPos++] = right[k];
                        }
                    }
                }
            }

            pos = 0;
            if (source[i] == '\0')
                break;
        }
        else
        {
            if (pos < sizeof(token) - 1)
                token[pos++] = source[i];
        }
    }

    return CASE_BONUS_STATE_LOCKED;
}

stock SetCaseBonusState(sourceDest[], destlen, caseId, bonusIndex, newState)
{
    if (caseId < 1 || caseId > MAX_CASES) return 0;
    if (bonusIndex < 1 || bonusIndex > MAX_CASE_BONUSES) return 0;
    if (newState < 1 || newState > 3) return 0;

    if (!IsValidCaseBonusStates(sourceDest))
        InitPlayerCaseBonusStates(sourceDest, destlen);

    new finalStr[CASE_BONUS_STR_LEN];
    finalStr[0] = '\0';

    new token[64];
    new pos = 0;

    for (new i = 0; ; i++)
    {
        if (sourceDest[i] == '|' || sourceDest[i] == '\0')
        {
            token[pos] = '\0';

            new outToken[64];
            format(outToken, sizeof(outToken), "%s", token);

            new colonPos = -1;
            for (new j = 0; token[j] != '\0'; j++)
            {
                if (token[j] == ':')
                {
                    colonPos = j;
                    break;
                }
            }

            if (colonPos != -1)
            {
                new left[8], right[32];
                strmid(left, token, 0, colonPos, sizeof(left));
                strmid(right, token, colonPos + 1, strlen(token), sizeof(right));

                if (strval(left) == caseId)
                {
                    new buffer[32];
                    buffer[0] = '\0';

                    new currentBonus = 1;
                    new stateBuf[8], sPos = 0;

                    for (new k = 0; ; k++)
                    {
                        if (right[k] == ',' || right[k] == '\0')
                        {
                            stateBuf[sPos] = '\0';

                            new writeVal = strval(stateBuf);
                            if (currentBonus == bonusIndex)
                                writeVal = newState;

                            new tmp[8];
                            format(tmp, sizeof(tmp), "%d", writeVal);
                            strcat(buffer, tmp, sizeof(buffer));

                            if (right[k] == ',')
                                strcat(buffer, ",", sizeof(buffer));

                            currentBonus++;
                            sPos = 0;

                            if (right[k] == '\0')
                                break;
                        }
                        else
                        {
                            if (sPos < sizeof(stateBuf) - 1)
                                stateBuf[sPos++] = right[k];
                        }
                    }

                    format(outToken, sizeof(outToken), "%d:%s", caseId, buffer);
                }
            }

            strcat(finalStr, outToken, sizeof(finalStr));
            if (sourceDest[i] == '|')
                strcat(finalStr, "|", sizeof(finalStr));

            pos = 0;

            if (sourceDest[i] == '\0')
                break;
        }
        else
        {
            if (pos < sizeof(token) - 1)
                token[pos++] = sourceDest[i];
        }
    }

    format(sourceDest, destlen, "%s", finalStr);
    return 1;
}

stock GetCaseBonusRequiredOpenCount(bonusIndex)
{
    new thresholds[5] = {40, 30, 20, 10, 5};

    if (bonusIndex < 1 || bonusIndex > 5)
        return 999999;

    return thresholds[bonusIndex - 1];
}

stock RefreshCaseBonusStatesForCase(bonusStr[], len, caseId, openedCount)
{
    if (!IsValidCaseBonusStates(bonusStr))
        InitPlayerCaseBonusStates(bonusStr, len);

    for (new i = 1; i <= MAX_CASE_BONUSES; i++)
    {
        new currentState = GetCaseBonusState(bonusStr, caseId, i);

        if (currentState == CASE_BONUS_STATE_CLAIMED)
            continue;

        new needOpen = GetCaseBonusRequiredOpenCount(i);

        if (openedCount >= needOpen)
            SetCaseBonusState(bonusStr, len, caseId, i, CASE_BONUS_STATE_AVAILABLE);
        else
            SetCaseBonusState(bonusStr, len, caseId, i, CASE_BONUS_STATE_LOCKED);
    }

    return 1;
}

stock BuildCaseBonusJsonForClient(dest[], destlen, const bonusStr[], caseId)
{
    dest[0] = '\0';
    strcat(dest, "[", destlen);

    for (new i = 1; i <= MAX_CASE_BONUSES; i++)
    {
        new st = GetCaseBonusState(bonusStr, caseId, i);

        new temp[64];
        format(temp, sizeof(temp),
            "{\"id\":%d,\"state\":%d}%s",
            i, st, (i < MAX_CASE_BONUSES) ? "," : ""
        );
        strcat(dest, temp, destlen);
    }

    strcat(dest, "]", destlen);
    return 1;
}

// --- CASE / REWARDS: переменные и работа с наградами
#define MAX_CASE_REWARDS 1000
enum eReward
{
    rCase,
    rItem, 
    rBonus
}

new g_PlayerRewards[MAX_PLAYERS][MAX_CASE_REWARDS][eReward];
new g_PlayerRewardsCount[MAX_PLAYERS];
new g_player_case_rewards[MAX_PLAYERS][1024];
new g_player_case_rewards_bonus[MAX_PLAYERS][1024];
new g_player_case_bonus[MAX_PLAYERS][1024];
forward BlackPass_GetRewardInventoryData(itemid, name[], name_len, &type, &internal, &count, &rarity, &price);
forward BlackPass_AddDust(playerid, amount);
forward BlackPass_GrantExperience(playerid, experience);
forward BlackPass_SendLevelSyncPacket(playerid, level = -1, exp_value = -1);

// Сохранение бонусной награды игрока (копия из bylaird-new.pwn)
enum E_CASE_BONUS_NUM {
    CB_ID, CB_NUMBEROPEN, CB_RARITY, CB_TYPE, CB_INTERNALID, CB_COUNT, CB_PRICESPRAYED
};

stock SavePlayerCaseBonusReward(playerid, caseIndex, bonusIndex)
{
    if (caseIndex < 1 || caseIndex > MAX_CASES) return 0;
    if (bonusIndex < 1 || bonusIndex > 5) return 0;

    new bonusId         = GetCaseBonusNumeric(caseIndex - 1, bonusIndex - 1, CB_ID);
    new bonusType       = GetCaseBonusNumeric(caseIndex - 1, bonusIndex - 1, CB_TYPE);
    new bonusInternalId = GetCaseBonusNumeric(caseIndex - 1, bonusIndex - 1, CB_INTERNALID);
    new bonusCount      = GetCaseBonusNumeric(caseIndex - 1, bonusIndex - 1, CB_COUNT);

    if (bonusId <= 0 || bonusType <= 0)
    {
        printf("[CASE BONUS] Некорректный бонус: player=%d case=%d bonus=%d id=%d type=%d",
            playerid, caseIndex, bonusIndex, bonusId, bonusType);
        return 0;
    }

    switch (bonusType)
    {
        case 5: // машина
        {
            new query[256];
            mysql_format(mysql, query, sizeof(query),
                "INSERT INTO `player_case_bonus_rewards` (`player_id`, `case_id`, `bonus_id`, `bonus_type`, `internal_id`, `item_count`) VALUES (%d, %d, %d, %d, %d, %d)",
                GetPlayerAccountID(playerid),
                caseIndex,
                bonusId,
                bonusType,
                bonusInternalId,
                bonusCount
            );
            mysql_tquery(mysql, query);
            AddPlayerCaseReward(playerid, caseIndex, bonusId, true);
            printf("[CASE BONUS] Машина сохранена в rewards: player=%d case=%d bonus=%d internal=%d count=%d",
                playerid, caseIndex, bonusId, bonusInternalId, bonusCount);
        }
        case 4:
        {
            if (bonusInternalId == 5){
                AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, bonusCount);
                UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
                return 1;
            }
            new query[256];
            mysql_format(mysql, query, sizeof(query),
                "INSERT INTO `player_case_bonus_rewards` (`player_id`, `case_id`, `bonus_id`, `bonus_type`, `internal_id`, `item_count`) VALUES (%d, %d, %d, %d, %d, %d)",
                GetPlayerAccountID(playerid),
                caseIndex,
                bonusId,
                bonusType,
                bonusInternalId,
                bonusCount
            );
            mysql_tquery(mysql, query);
            AddPlayerCaseReward(playerid, caseIndex, bonusId, true);
        }
        case 21, 23:
        {
            AddPlayerData(playerid, P_SKILL_MICRO_UZI, +, bonusCount);
            UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));

            new skill = GetPlayerData(playerid, P_SKILL_MICRO_UZI);
            new addCases = skill / 2000;
            new remainder = skill % 2000;

            if (addCases > 0)
            {
                AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, addCases);
                SetPlayerData(playerid, P_SKILL_MICRO_UZI, remainder);

                UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", remainder);
                UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
            }
        }
        case 2:
        {
            GivePlayerMoneyEx(playerid, bonusCount, "", true, true);
        }
        
        default:
        {
            printf("[CASE BONUS] TODO bonus type=%d player=%d case=%d bonus=%d internal=%d count=%d",
                bonusType, playerid, caseIndex, bonusId, bonusInternalId, bonusCount);
        }
    }

    return 1;
}
