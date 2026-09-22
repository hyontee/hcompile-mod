//>> Файл: bykranin_src/core/inventory/inventory_13.inc  (910 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: EscapeJsonSimple, /reward, rewardsss, AddPlayerCaseReward, FixPlayerZ, SavePlayerCaseRewardDB, SavePlayerCaseRewards
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// helper: заменяет " в src на ' в dest (чтобы безопасно вставлять в JSON)
stock EscapeJsonSimple(dest[], destlen, const src[])
{
    if (destlen <= 0) return 0;
    new di = 0;
    for (new si = 0; si < strlen(src) && di < destlen-1; si++)
    {
        new c = src[si];
        if (c == '"') {
            // заменяем " на одинарную кавычку '
            if (di < destlen-2) { dest[di++] = '\''; }
					else break;
        }
					else if (c == '\\') {
            // пропускаем обратную косую, заменим на /
            if (di < destlen-2) { dest[di++] = '/'; }
					else break;
        }
					else {
            dest[di++] = c;
        }
    }
    dest[di] = '\0';
    return di;
}

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

    ShowNotificationNew(playerid, 3, 2, 0, 0, "Вы переместились на точку!", "");
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

stock InventoryReward_SyncFromDatabase(playerid)
{
    new accountid = GetPlayerAccountID(playerid);
    g_player_case_rewards[playerid][0] = EOS;
    g_PlayerRewardsCount[playerid] = 0;

    if(accountid <= 0) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "SELECT IFNULL(`case_rewards`, '') AS case_rewards FROM `accounts` WHERE `id`=%d LIMIT 1",
        accountid);

    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[CASE REWARDS][ERROR] reload failed player=%d account=%d errno=%d query=%s", playerid, accountid, mysql_errno(), query);
        cache_delete(result);
        return 0;
    }

    if(cache_num_rows(result) > 0)
        cache_get_field_content(0, "case_rewards", g_player_case_rewards[playerid], sizeof(g_player_case_rewards[]));

    cache_delete(result);
    return LoadPlayerCaseRewards(playerid);
}

stock LoadPlayerCaseRewards(playerid)
{
    if (isnull(g_player_case_rewards[playerid]) || strlen(g_player_case_rewards[playerid]) == 0)
    {
        g_PlayerRewardsCount[playerid] = 0;
        g_player_case_rewards[playerid][0] = EOS;
        printf("[CASE REWARDS] Player %d: reward string is empty", playerid);
        return 0;
    }

    printf("[CASE REWARDS] Player %d: loaded from DB: %s", playerid, g_player_case_rewards[playerid]);

    new items[MAX_ITEMS_PER_PLAYER][32];
    new count = explode(items, g_player_case_rewards[playerid], ',', sizeof(items));
    new cleanData[1024];
    cleanData[0] = EOS;

    g_PlayerRewardsCount[playerid] = 0;
    for (new i = 0; i < count && g_PlayerRewardsCount[playerid] < MAX_CASE_REWARDS; i++)
    {
        if (strlen(items[i]) == 0) continue;

        new tmp[3][16];
        new itemCount = explode(tmp, items[i], ':', sizeof(tmp));
        if (itemCount < 2 || itemCount > 3)
        {
            printf("[CASE REWARDS] Player %d: invalid token '%s', skipped", playerid, items[i]);
            continue;
        }

        if (!CaseRewardToken_IsNumber(tmp[0]) || !CaseRewardToken_IsNumber(tmp[1]) || (itemCount == 3 && !CaseRewardToken_IsNumber(tmp[2])))
        {
            printf("[CASE REWARDS] Player %d: non numeric token '%s', skipped", playerid, items[i]);
            continue;
        }

        new caseid = strval(tmp[0]);
        new itemid = strval(tmp[1]);
        new bool:isBonus = (itemCount == 3 && strval(tmp[2]) != 0);

        new resolvedCaseid, resolvedBonus;
        if(!CaseReward_ResolveEntry(caseid, itemid, isBonus, resolvedCaseid, resolvedBonus))
        {
            printf("[CASE REWARDS] Player %d: invalid reward Case:%d Item:%d Bonus:%d, skipped", playerid, caseid, itemid, isBonus);
            continue;
        }

        caseid = resolvedCaseid;
        isBonus = (resolvedBonus != 0);

        g_PlayerRewards[playerid][g_PlayerRewardsCount[playerid]][rCase] = caseid;
        g_PlayerRewards[playerid][g_PlayerRewardsCount[playerid]][rItem] = itemid;
        g_PlayerRewards[playerid][g_PlayerRewardsCount[playerid]][rBonus] = isBonus ? 1 : 0;
        g_PlayerRewardsCount[playerid]++;

        new token[32];
        if(isBonus)
            format(token, sizeof(token), "%d:%d:1", caseid, itemid);
        else
            format(token, sizeof(token), "%d:%d", caseid, itemid);

        if(strlen(cleanData)) strcat(cleanData, ",", sizeof(cleanData));
        strcat(cleanData, token, sizeof(cleanData));

        printf("[CASE REWARDS] Player %d: loaded reward Case:%d Item:%d Bonus:%d (total=%d)",
            playerid,
            caseid,
            itemid,
            isBonus,
            g_PlayerRewardsCount[playerid]
        );
    }

    if(strcmp(g_player_case_rewards[playerid], cleanData, false) != 0)
    {
        format(g_player_case_rewards[playerid], sizeof(g_player_case_rewards[]), "%s", cleanData);
        UpdatePlayerDatabaseString(playerid, "case_rewards", g_player_case_rewards[playerid]);
        printf("[CASE REWARDS] Player %d: normalized rewards string: %s", playerid, g_player_case_rewards[playerid]);
    }

    printf("[CASE REWARDS] Player %d: total loaded rewards: %d", playerid, g_PlayerRewardsCount[playerid]);

    return 1;
}

stock RemovePlayerCaseReward(playerid, caseid, itemid)
{
    if (g_PlayerRewardsCount[playerid] == 0) return 0;

    new newCount = 0;
    new newRewards[MAX_ITEMS_PER_PLAYER][3];
    new bool:removed = false;
    printf("[CASE REWARDS] Player %d: remove reward Case:%d Item:%d", playerid, caseid, itemid);

    for (new i = 0; i < g_PlayerRewardsCount[playerid]; i++)
    {
        if (!removed &&
            g_PlayerRewards[playerid][i][rCase] == caseid &&
            g_PlayerRewards[playerid][i][rItem] == itemid)
        {
            printf("[CASE REWARDS] Player %d: removed reward Case:%d Item:%d Bonus:%d",
                playerid, caseid, itemid, g_PlayerRewards[playerid][i][rBonus]);
            removed = true;
            continue;
        }

        newRewards[newCount][rCase] = g_PlayerRewards[playerid][i][rCase];
        newRewards[newCount][rItem] = g_PlayerRewards[playerid][i][rItem];
        newRewards[newCount][rBonus] = g_PlayerRewards[playerid][i][rBonus];
        newCount++;
    }

    g_PlayerRewardsCount[playerid] = newCount;

    new newData[1024];
    newData[0] = EOS;
    for (new i = 0; i < g_PlayerRewardsCount[playerid]; i++)
    {
        g_PlayerRewards[playerid][i][rCase] = newRewards[i][rCase];
        g_PlayerRewards[playerid][i][rItem] = newRewards[i][rItem];
        g_PlayerRewards[playerid][i][rBonus] = newRewards[i][rBonus];

        new buffer[32];
        if(g_PlayerRewards[playerid][i][rBonus])
            format(buffer, sizeof(buffer), "%d:%d:1",
                g_PlayerRewards[playerid][i][rCase],
                g_PlayerRewards[playerid][i][rItem]);
        else
            format(buffer, sizeof(buffer), "%d:%d",
                g_PlayerRewards[playerid][i][rCase],
                g_PlayerRewards[playerid][i][rItem]);

        if (strlen(newData)) strcat(newData, ",", sizeof(newData));
        strcat(newData, buffer, sizeof(newData));
    }

    format(g_player_case_rewards[playerid], sizeof(g_player_case_rewards[]), "%s", newData);

    new query[1280];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `accounts` SET `case_rewards`='%e' WHERE `id`=%d LIMIT 1",
        g_player_case_rewards[playerid], GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    printf("[CASE REWARDS] Player %d: saved rewards string: %s", playerid, g_player_case_rewards[playerid]);
    printf("[CASE REWARDS] Player %d: current rewards count in g_PlayerRewards: %d", playerid, g_PlayerRewardsCount[playerid]);

    return 1;
}

stock SendInventoryPage(playerid, startIndex, types)
{
    // GUI 74 is shared with marketplace rewards. Explicitly switch packet
    // routing back to the BlackPass/case-reward inventory before every page.
    SetPVarInt(playerid, "reward_gui_mode", 1);

    new JSON:root = JSON_Object();
    JSON_SetInt(root, "t", types);

    if (startIndex == 0)
    {
        g_player_inventory_count[playerid] = 0;
        g_player_pr_array[playerid] = JSON_Array();
        InventoryReward_SyncFromDatabase(playerid);
    }

    new JSON:prArray = JSON_Array();

    const maxItemsPerPage = 12;
    new addedItems = 0;
    new matchedItems = 0;
    new filter = g_player_filter[playerid];

    for (new i = 0; i < g_PlayerRewardsCount[playerid]; i++)
    {
        new caseIndex = g_PlayerRewards[playerid][i][rCase]-1;
        new itemId    = g_PlayerRewards[playerid][i][rItem];

        if (g_PlayerRewards[playerid][i][rCase] == 99)
        {
            new type, internalId, count, rarity, price;
            new name[CA_NAME_LEN];
            if (!BlackPass_GetRewardInventoryData(itemId, name, sizeof(name), type, internalId, count, rarity, price))
                continue;

            new bool:pass = true;
            switch (filter)
            {
                case 1: pass = (type == 11 && count > 1);
                case 2: pass = (type == 9);
                case 3: pass = (type == 11 && count == 1 && internalId != 21);
                case 4: pass = (type == 5);
                case 5: pass = (type == 2 || type == 3);
                case 6: pass = !((type == 11 && internalId == 21) || type == 9 || type == 5 || type == 2 || type == 3);
                default: pass = true;
            }

            if (!pass)
                continue;

            matchedItems++;

            if (matchedItems <= startIndex)
                continue;

            if (addedItems >= maxItemsPerPage)
                break;

            if (strlen(name) > 11)
            {
                new shortName[CA_NAME_LEN];
                strmid(shortName, name, 0, 9, sizeof(shortName));
                format(name, sizeof(name), "%s...", shortName);
            }

            new idx = g_player_inventory_count[playerid];
            g_player_inventory[playerid][idx][item_ids]          = itemId;
            g_player_inventory[playerid][idx][item_types]        = type;
            g_player_inventory[playerid][idx][item_internals]    = internalId;
            g_player_inventory[playerid][idx][item_counts]       = count;
            g_player_inventory[playerid][idx][item_case_indexs]  = 98;
            g_player_inventory[playerid][idx][item_prices]       = price;

            new imageInternal = internalId;
            if ((type == 1 || type == 2 || type == 3 || type == 8 || type == 10 || type == 21) && imageInternal <= 0)
            {
                imageInternal = 1;
            }

            new itemC = count;
            new itemCt = 0;
            new itemDs = 30;
            if (type == 5 || type == 9)
            {
                itemC = 0;
                itemCt = count;
            }
            else if (type == 11)
            {
                if (internalId == 134)
                {
                    itemC = count;
                }
                else
                {
                    itemC = 0;
                }
            }

            new JSON:itemNode = JSON_Object(
                "id", JSON_Int(idx),
                "n",  JSON_String(name),
                "td", JSON_Int(type),
                "el", JSON_Int(imageInternal),
                "c",  JSON_Int(itemC),
                "ds", JSON_Int(itemDs),
                "sp", JSON_Int(price),
                "r",  JSON_Int(rarity),
                "ct", JSON_Int(itemCt),
                "els", JSON_Array(),
                "st", JSON_Int(0)
            );

            prArray = JSON_Append(prArray, JSON_Array(itemNode));
            g_player_pr_array[playerid] = JSON_Append(g_player_pr_array[playerid], JSON_Array(itemNode));
            g_player_inventory_count[playerid]++;
            addedItems++;
            continue;
        }

        new bool:isBonusReward = (g_PlayerRewards[playerid][i][rBonus] != 0);
        new itemCountInCase = isBonusReward ? GetCaseBonusesCount(caseIndex) : GetCaseItemsCount(caseIndex);

        for (new j = 0; j < itemCountInCase; j++)
        {
            if (isBonusReward)
            {
                if (GetCaseBonusNumeric(caseIndex, j, CB_ID) != itemId)
                    continue;
            }
            else
            {
                if (GetCaseItemNumeric(caseIndex, j, CA_ID) != itemId)
                    continue;
            }

            new type       = isBonusReward ? GetCaseBonusNumeric(caseIndex, j, CB_TYPE) : GetCaseItemNumeric(caseIndex, j, CA_TYPE);
            new internalId = isBonusReward ? GetCaseBonusNumeric(caseIndex, j, CB_INTERNALID) : GetCaseItemNumeric(caseIndex, j, CA_INTERNALID);
            new count      = isBonusReward ? GetCaseBonusNumeric(caseIndex, j, CB_COUNT) : GetCaseItemNumeric(caseIndex, j, CA_COUNT);

            new bool:pass = true;
            switch (filter)
            {
                case 1: pass = (type == 11 && count > 1);
                case 2: pass = (type == 9);
                case 3: pass = (type == 11 && count == 1 && internalId != 21);
                case 4: pass = (type == 5);
                case 5: pass = (type == 2 || type == 3);
                case 6: pass = !((type == 11 && internalId == 21) || type == 9 || type == 5 || type == 2 || type == 3 || type == 4);
                default: pass = true;
            }

            if (!pass)
                continue;

            matchedItems++;

            if (matchedItems <= startIndex)
                break;

            if (addedItems >= maxItemsPerPage)
                break;

            new name[CA_NAME_LEN];
            if(isBonusReward)
                GetCaseBonusName(name, sizeof(name), caseIndex, j);
            else
                GetCaseItemName(name, sizeof(name), caseIndex, j);
            if (strlen(name) > 11)
            {
                new shortName[CA_NAME_LEN];
                strmid(shortName, name, 0, 9, sizeof(shortName));
                format(name, sizeof(name), "%s...", shortName);
            }

            new rarity = isBonusReward ? GetCaseBonusNumeric(caseIndex, j, CB_RARITY) : GetCaseItemNumeric(caseIndex, j, CA_RARITY);
            new price  = isBonusReward ? GetCaseBonusNumeric(caseIndex, j, CB_PRICESPRAYED) : GetCaseItemNumeric(caseIndex, j, CA_PRICESPRAYED);
            new idx = g_player_inventory_count[playerid];

            g_player_inventory[playerid][idx][item_ids]          = itemId;
            g_player_inventory[playerid][idx][item_types]        = type;
            g_player_inventory[playerid][idx][item_internals]    = internalId;
            g_player_inventory[playerid][idx][item_counts]       = count;
            g_player_inventory[playerid][idx][item_case_indexs]  = caseIndex;
            g_player_inventory[playerid][idx][item_prices]       = price;

            new JSON:itemNode = JSON_Object(
                "id", JSON_Int(idx),
                "n",  JSON_String(name),
                "td", JSON_Int(type),
                "el", JSON_Int(internalId),
                "c",  JSON_Int(count),
                "sp", JSON_Int(price),
                "r",  JSON_Int(rarity),
                "st", JSON_Int(0)
            );

            prArray = JSON_Append(prArray, JSON_Array(itemNode));
            g_player_pr_array[playerid] = JSON_Append(g_player_pr_array[playerid], JSON_Array(itemNode));

            g_player_inventory_count[playerid]++;
            addedItems++;
            break;
        }

        if (addedItems >= maxItemsPerPage)
            break;
    }

    JSON_SetArray(root, "pr", prArray);

    new JSON:flArray = JSON_Array();
    JSON_SetArray(root, "fl", flArray);

    new nextStartIndex = startIndex + maxItemsPerPage;
    g_player_inv_offset[playerid] = nextStartIndex;

    JSON_SetInt(root, "pz", nextStartIndex);
    JSON_SetInt(root, "has_more", (matchedItems > nextStartIndex));

    if (startIndex < maxItemsPerPage && filter == 0)
        ShowPlayerGUI(playerid, BpRewardsGuiFragment, root);
    else
        OnPacketIncoming(playerid, 74, root);

    JSON_Cleanup(root);
    return 1;
}

stock RemovePlayerItem(playerid, itemid, caseIndex)
{
    new rewardsStr[4096];
    format(rewardsStr, sizeof(rewardsStr), "%s", g_player_case_rewards[playerid]);

    new newData[4096], token[512];
    new caseBuffer[512];
    new offset = 0;

    newData[0] = '\0';

    for (new i = 0; split(rewardsStr, token, i, '|'); i++)
    {
        if (i == caseIndex)
        {
            new buffer[128][32];
            new count = explode(buffer, token, ',', sizeof(buffer));
            caseBuffer[0] = '\0';

            for (new j = 0; j < count; j++)
            {
                if (strval(buffer[j]) == itemid) continue;

                if (strlen(caseBuffer))
                    strcat(caseBuffer, ",", sizeof(caseBuffer)); // между предметами ставим запятую

                strcat(caseBuffer, buffer[j], sizeof(caseBuffer));
            }

            if (strlen(newData))
                strcat(newData, "|", sizeof(newData)); // между кейсами ставим |

            strcat(newData, caseBuffer, sizeof(newData));
        }
					else
        {
            if (strlen(newData))
                strcat(newData, "|", sizeof(newData));

            strcat(newData, token, sizeof(newData));
        }
    }

    // Записываем обратно
    format(g_player_case_rewards[playerid], sizeof(g_player_case_rewards[]), "%s", newData);
    UpdatePlayerDatabaseString(playerid, "case_rewards", g_player_case_rewards[playerid]);

    printf("[INV][DELETE] Removed item %d from case %d for player %d -> %s",
        itemid, caseIndex, playerid, g_player_case_rewards[playerid]);
}

stock GiveInventoryReward(playerid, id, type, internal, count)
{
    new result = 1;

    switch (type)
    {
        case 1:
        {
            AddPlayerData(playerid, P_EXP, +, count);

            if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
            {
                SetPlayerData(playerid, P_EXP, 0);
                AddPlayerData(playerid, P_LEVEL, +, 1);
                SetPlayerLevelInit(playerid);
                UpdatePlayerDatabaseInt(playerid, "level", GetPlayerLevel(playerid));
            }

            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
        }
        case 2:
        {
            GivePlayerMoneyEx(playerid, count, "BlackPass reward", true, true);
        }
        case 3:
        {
            GivePlayerDonateRub(playerid, count);
        }
        case 4:
        {
            AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, count);
            UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
            ShowCase(playerid);
        }
        case 5:
        {
            if(BuyPlayerCar(playerid, internal, internal, 1) == -1)
            {
                result = 0;
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось выдать транспорт", " ");
            }
        }
        case 8:
        {
            SetPlayerX2(playerid, 1, count);
        }
        case 9:
        {
            new expires_at = GetPlayerData(playerid, P_PREMIUM_DATE);
            if(expires_at < gettime()) expires_at = gettime();
            expires_at += count * 3600;
            if(GetPlayerPremium(playerid) < internal) SetPlayerData(playerid, P_PREMIUM, internal);
            SetPlayerData(playerid, P_PREMIUM_DATE, expires_at);
            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerPremium(playerid));
            UpdatePlayerDatabaseInt(playerid, "premium_date", expires_at);
        }
        case 10:
        {
            new levels_to_add = count / BLACKPASS_LEVEL_EXP;
            if(levels_to_add <= 0) levels_to_add = 1;

            new old_level = BlackPass_GetCurrentLevel(playerid);
            new new_level = BlackPass_AddLevelsWithReset(playerid, levels_to_add);
            BlackPass_SendLevelSyncRange(playerid, old_level, new_level);
        }
        case 11:
        {
            if (count > 1)
            {
                if(!Inventory11_CanAddItemWeight(playerid, 134, 1))
                {
                    result = 0;
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Инвентарь заполнен", " ");
                }
                else
                {
                    new bool:skin_added = Inventory11_AddSkinToInventory(playerid, count, internal);
                    if(skin_added)
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Новая одежда была добавлена в Ваш инвентарь", " ");
                    }
					else
                    {
                        result = 0;
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Ошибка выдачи одежды", " ");
                    }
                }
            }
            else if (internal != 21)
            {
                new inv_item_id = -1;
                new acc_modelid = -1;

                if(Inv11_ResolveAccessoryReward(internal, inv_item_id, acc_modelid))
                {
                    printf("[INV11][REWARD][TRACE] Accessory resolve: player=%d internal=%d item=%d model=%d", playerid, internal, inv_item_id, acc_modelid);
                    new inv_slot = Inventory11_AddItemToDatabase(playerid, inv_item_id, acc_modelid, 1, 0, 0);
                    if (inv_slot != -1)
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Аксессуар добавлен в инвентарь", " ");
                    }
					else
                    {
                        result = 0;
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Ошибка выдачи аксессуара", " ");
                        printf("[INV11][REWARD][ERROR] Accessory add failed: player=%d internal=%d item=%d model=%d", playerid, internal, inv_item_id, acc_modelid);
                    }
                }
                else
                {
                    new inv_slot = Inventory11_AddItemToDatabase(playerid, internal, internal, 1, 0, 0);
                    if(inv_slot != -1)
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Предмет добавлен в инвентарь", " ");
                    }
					else
                    {
                        result = 0;
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Ошибка выдачи предмета", " ");
                        printf("[INV11][REWARD][ERROR] Item add failed: player=%d internal=%d", playerid, internal);
                    }
                }
            }
        }
        case 21, 23:
        {
            AddPlayerData(playerid, P_SKILL_MICRO_UZI, +, count);
            UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
            ShowCase(playerid);
        }
        default:
        {
            result = 0;
            printf("[INV][REWARD] player %d unknown reward type %d id %d", playerid, type, id);
        }
    }

    return result;
}
stock ShowPlayerDialog_Example(playerid)
{
    new JSON:root = JSON_Object();

    JSON_SetInt(root, "a", 1);
    JSON_SetInt(root, "f", 2);
    JSON_SetInt(root, "o", 1);

    new JSON:acArray = JSON_Array();
    new JSON:acItem = JSON_Object("id", JSON_Int(24));
    JSON_Append(acArray, acItem);
    JSON_SetArray(root, "ac", acArray);

    new JSON:nArray = JSON_Array();
    new JSON:nItem = JSON_Object("id", JSON_Int(3));
    JSON_Append(nArray, nItem);
    JSON_SetArray(root, "n", nArray);

    new JSON:dObj = JSON_Object();
    JSON_SetInt(dObj, "ar", 1);
    JSON_SetInt(dObj, "av", 15);
    JSON_SetInt(dObj, "bg", 9);
    JSON_SetInt(dObj, "exm", 28);
    JSON_SetInt(dObj, "exp", 4);
    JSON_SetString(dObj, "fn", "");
    JSON_SetInt(dObj, "lv", GetPlayerLevel(playerid));
    JSON_SetInt(dObj, "v", 0);
    
    // Добавляем новые элементы меню
    JSON_SetInt(dObj, "i5", 1);   // информация
    JSON_SetInt(dObj, "i100", 1); // фракции
    JSON_SetInt(dObj, "i8", 1);   // вызов такси
    JSON_SetInt(dObj, "i12", 1);  // анимация
    JSON_SetInt(dObj, "i13", 1);  // донат
    JSON_SetInt(dObj, "i18", 1);  // календарь
    JSON_SetInt(dObj, "i19", 1);  // тариф
    JSON_SetInt(dObj, "i22", 1);  // добыча
    JSON_SetInt(dObj, "i11", 1);  // инвентарь
    JSON_SetInt(dObj, "i21", 1);  // маркетплейс
    JSON_SetInt(dObj, "i15", 1);  // промокод
    JSON_SetInt(dObj, "i14", 1);  // транспорт
    JSON_SetInt(dObj, "i7", 1);   // навигатор
    JSON_SetInt(dObj, "i17", 1);  // семья
    JSON_SetInt(dObj, "i25", 1);  // новости
    JSON_SetInt(dObj, "i20", 1);  // токены
    JSON_SetInt(dObj, "i9", 1);   // меню
    JSON_SetInt(dObj, "i24", 1);  // событие
    JSON_SetInt(dObj, "i16", 1);  // жалоба
    
    JSON_SetObject(root, "d", dObj);

    // Отправляем на клиент, ID пакета 113
    ShowPlayerGUI(playerid, 113, root);

    new jsonStr[512];
    JSON_Stringify(root, jsonStr, sizeof(jsonStr), false);
    printf("[DEBUG] Sent GUI packet to %d: %s", playerid, jsonStr);

    JSON_Cleanup(root);
}


CMD:goto(playerid, params[])
{
    if(!SRAdmin_TeleportAllowed(playerid)) return 1;
    new targetid;
    if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, -1, "Используйте: /goto [id игрока]");
    if(!SRAdmin_TeleportTarget(playerid, targetid)) return 1;
    return SRAdmin_MoveNear(playerid, playerid, targetid);
}

alias:goto("g")

CMD:gethere(playerid, params[])
{
    if(!SRAdmin_TeleportAllowed(playerid)) return 1;
    new targetid;
    if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, -1, "Используйте: /gethere [id игрока]");
    if(!SRAdmin_TeleportTarget(playerid, targetid)) return 1;
    if(GetPlayerAdminEx(targetid) > 0 && SRAdmin_Level(targetid) == 0) return 1;
    if(SRAdmin_Level(targetid) > SRAdmin_Level(playerid))
        return SendClientMessage(playerid, -1, "Нельзя телепортировать к себе администратора выше вашего уровня.");
    return SRAdmin_MoveNear(playerid, targetid, playerid);
}

alias:gethere("gh")


CMD:updatevisual(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, -1, "Для обновления визуала выйдите из транспорта.");
    if(g_stability_visual_timer[playerid]) return 1;
    new interior = GetPlayerInterior(playerid);
    new world = GetPlayerVirtualWorld(playerid);
    if(world > 2147482647) return 1;

    // Re-stream only this player. Never move other players' vehicles between worlds.
    g_stability_visual_timer[playerid] = SetTimerEx("RestorePlayerAndVehicles", 100, false,
        "iiii", playerid, interior, world, g_BRAuthEpoch[playerid]);
    if(!g_stability_visual_timer[playerid]) return 1;
    SetPlayerVirtualWorld(playerid, world + 1000);
    return 1;
}

