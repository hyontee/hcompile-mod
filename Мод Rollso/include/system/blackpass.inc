#define MAX_BP_LEVEL            74
#define BP_EXP_PER_LEVEL        1000
#define MAX_BP_TASKS            17
#define MAX_BP_TOP              15
#define BP_SEASON_NAME          "ТАЙНА"

stock GetPlayerBlackCoin(playerid)
{
    return GetPlayerDonateRub(playerid);
}

stock GivePlayerBlackCoin(playerid, amount)
{
    return GivePlayerDonateRub(playerid, amount, "Black Pass");
}

stock BP_InitDatabase()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `black_pass` (\
        `user_id` INT NOT NULL,\
        `exp` INT DEFAULT 0,\
        `level` INT DEFAULT 0,\
        `premium` TINYINT DEFAULT 0,\
        `total_points` INT DEFAULT 0,\
        `rewards_bitmap0` INT DEFAULT 0,\
        `rewards_bitmap1` INT DEFAULT 0,\
        `rewards_bitmap2` INT DEFAULT 0,\
        `rewards_bitmap3` INT DEFAULT 0,\
        `rewards_bitmap4` INT DEFAULT 0,\
        PRIMARY KEY (`user_id`)\
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        "", "");

    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `black_pass_top` (\
        `user_id` INT NOT NULL,\
        `total_points` INT DEFAULT 0,\
        PRIMARY KEY (`user_id`)\
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        "", "");

    mysql_tquery(mysql,
        "INSERT INTO `black_pass_top` (`user_id`, `total_points`)\
        SELECT `id`, 0 FROM `accounts`\
        ON DUPLICATE KEY UPDATE `user_id` = `user_id`",
        "", "");

    mysql_tquery(mysql,
        "SELECT `user_id`, `total_points` FROM `black_pass_top`\
        ORDER BY `total_points` DESC LIMIT 15",
        "LoadBPTop", "");

    return 1;
}

enum E_BP_DATA
{
    bpID,
    bpExp,
    bpLevel,
    bpPremium,
    bpTotalPoints,
    bpTasks[MAX_BP_TASKS],
    bpTaskProgress[MAX_BP_TASKS],
    bpRewardsBitmap[5]
}

new PlayerBP[MAX_PLAYERS][E_BP_DATA];

enum E_BP_TOP
{
    topUserID,
    topPoints,
    topName[MAX_PLAYER_NAME]
}

new BlackPassTop[MAX_BP_TOP][E_BP_TOP];
new BlackPassTopCount = 0;

stock SendFullBPUpdate(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "o", 1);
    JSON_SetInt(response, "t", -1);
    JSON_SetInt(response, "ty", -1);
    JSON_SetInt(response, "la", 0);
    JSON_SetInt(response, "lc", 0);
    JSON_SetString(response, "sn", BP_SEASON_NAME);

    new leaderName[MAX_PLAYER_NAME];
    if(BlackPassTopCount > 0 && BlackPassTop[0][topUserID] > 0)
        format(leaderName, sizeof(leaderName), "%s", BlackPassTop[0][topName]);
    else
        format(leaderName, sizeof(leaderName), "None");

    JSON_SetString(response, "ln", leaderName);
    JSON_SetInt(response, "lv", PlayerBP[playerid][bpLevel]);
    JSON_SetInt(response, "l", PlayerBP[playerid][bpLevel]);
    JSON_SetInt(response, "ec", PlayerBP[playerid][bpExp]);
    JSON_SetInt(response, "e", PlayerBP[playerid][bpExp]);
    JSON_SetInt(response, "es", BP_EXP_PER_LEVEL);
    JSON_SetInt(response, "a", PlayerBP[playerid][bpPremium]);
    JSON_SetInt(response, "sp", 0);
    JSON_SetInt(response, "is", 0);

    new Node:rewardsArray = JSON_Array();

    for(new level = 1; level <= BP_REWARD_MAX_LEVEL; level++)
    {
        new Node:reward = JSON_Object();
        JSON_SetInt(reward, "id", level);
        JSON_SetInt(reward, "l", level);

        new status = 0;
        if(level <= PlayerBP[playerid][bpLevel])
        {
            status = IsBPRewardTakenRow(playerid, level, BP_REWARD_ROW_STANDARD) ? 1 : 2;
        }

        JSON_SetInt(reward, "is", status);
        JSON_ArrayAppend(rewardsArray, "", reward);
        JSON_Cleanup(reward);
    }

    JSON_SetArray(response, "r", rewardsArray);
    SendPacketToClient(playerid, 22, response);

    JSON_Cleanup(rewardsArray);
    JSON_Cleanup(response);
    return 1;
}

forward BP_ClaimRewardToReward(playerid, level, premium);
forward BP_SyncAvailableRewardsToReward(playerid, bool:notify);
forward BP_CleanupInvalidRewards(playerid);
forward BP_IsRewardQueued(playerid, level, premium);

stock GetPlayerBPExp(playerid) return PlayerBP[playerid][bpExp];
stock GetPlayerBPLevel(playerid) return PlayerBP[playerid][bpLevel];
stock GetPlayerBPStatus(playerid) return PlayerBP[playerid][bpPremium];

stock BP_Open(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    SendFullBPUpdate(playerid);
    return 1;
}

CMD:blackpass(playerid, params[])
{
    #pragma unused params
    BP_Open(playerid);
    return 1;
}

stock IsBPRewardTaken(playerid, level)
{
    if(level < 1 || level > MAX_BP_LEVEL) return 0;
    new slot = (level-1) / 32;
    new bit = (level-1) % 32;
    return (PlayerBP[playerid][bpRewardsBitmap][slot] & (1<<bit)) ? 1 : 0;
}

stock SetBPRewardTaken(playerid, level, bool:taken)
{
    if(level < 1 || level > MAX_BP_LEVEL) return 0;
    new slot = (level-1) / 32;
    new bit = (level-1) % 32;
    if(taken) PlayerBP[playerid][bpRewardsBitmap][slot] |= (1<<bit);
    else PlayerBP[playerid][bpRewardsBitmap][slot] &= ~(1<<bit);
    return 1;
}

stock GivePlayerBPExp(playerid, amount)
{
    if(amount <= 0) return 0;

    new multiplier_until = GetPVarInt(playerid, "bp_x2_exp_until");
    if(multiplier_until > gettime())
        amount *= 2;

    PlayerBP[playerid][bpExp] += amount;
    PlayerBP[playerid][bpTotalPoints] += amount;
    while(PlayerBP[playerid][bpExp] >= BP_EXP_PER_LEVEL && PlayerBP[playerid][bpLevel] < MAX_BP_LEVEL)
    {
        PlayerBP[playerid][bpExp] -= BP_EXP_PER_LEVEL;
        PlayerBP[playerid][bpLevel]++;
    }
    SavePlayerBP(playerid);
    UpdateBPLeaderboard(playerid);
    return 1;
}

stock ResetPlayerBP(playerid)
{
    PlayerBP[playerid][bpExp] = 0;
    PlayerBP[playerid][bpLevel] = 0;
    PlayerBP[playerid][bpPremium] = 0;
    PlayerBP[playerid][bpTotalPoints] = 0;
    for(new i = 0; i < MAX_BP_TASKS; i++) 
    {
        PlayerBP[playerid][bpTasks][i] = 0;
        PlayerBP[playerid][bpTaskProgress][i] = 0;
    }
    for(new i = 0; i < 5; i++) PlayerBP[playerid][bpRewardsBitmap][i] = 0;
    return 1;
}

stock UpdateBPLeaderboard(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `black_pass_top` (`user_id`, `total_points`) VALUES (%d, %d) ON DUPLICATE KEY UPDATE `total_points` = %d", GetPlayerAccountID(playerid), PlayerBP[playerid][bpTotalPoints], PlayerBP[playerid][bpTotalPoints]);
    mysql_tquery(mysql, query, "", "");
    
    new Cache:result = mysql_query(mysql, "SELECT user_id, total_points FROM black_pass_top ORDER BY total_points DESC LIMIT 15");
    new rows = cache_num_rows();
    BlackPassTopCount = 0;
    for(new i = 0; i < rows && i < MAX_BP_TOP; i++)
    {
        BlackPassTop[i][topUserID] = cache_get_field_content_int(i, "user_id");
        BlackPassTop[i][topPoints] = cache_get_field_content_int(i, "total_points");
        new name_q[128];
        mysql_format(mysql, name_q, sizeof(name_q), "SELECT `name` FROM `accounts` WHERE `id` = %d", BlackPassTop[i][topUserID]);
        new Cache:name_res = mysql_query(mysql, name_q);
        if(cache_num_rows() > 0) cache_get_field_content(0, "name", BlackPassTop[i][topName], mysql, MAX_PLAYER_NAME);
        else format(BlackPassTop[i][topName], MAX_PLAYER_NAME, "ID:%d", BlackPassTop[i][topUserID]);
        cache_delete(name_res);
        BlackPassTopCount++;
    }
    cache_delete(result);
    return 1;
}

stock SavePlayerBP(playerid)
{
    new query[1024];
    mysql_format(mysql, query, sizeof(query), 
        "UPDATE `black_pass` SET `exp` = %d, `level` = %d, `premium` = %d, `total_points` = %d, `rewards_bitmap0` = %d, `rewards_bitmap1` = %d, `rewards_bitmap2` = %d, `rewards_bitmap3` = %d, `rewards_bitmap4` = %d WHERE `user_id` = %d",
        PlayerBP[playerid][bpExp], PlayerBP[playerid][bpLevel], PlayerBP[playerid][bpPremium], PlayerBP[playerid][bpTotalPoints],
        PlayerBP[playerid][bpRewardsBitmap][0], PlayerBP[playerid][bpRewardsBitmap][1], PlayerBP[playerid][bpRewardsBitmap][2], PlayerBP[playerid][bpRewardsBitmap][3], PlayerBP[playerid][bpRewardsBitmap][4],
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock LoadPlayerBP(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    ResetPlayerBP(playerid);

    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM `black_pass` WHERE `user_id` = %d LIMIT 1", account_id);
    mysql_tquery(mysql, query, "OnPlayerBPLoaded", "ii", playerid, account_id);
    return 1;
}

forward OnPlayerBPLoaded(playerid, account_id);
public OnPlayerBPLoaded(playerid, account_id)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerAccountID(playerid) != account_id) return 1;
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(rows > 0)
    {
        PlayerBP[playerid][bpExp] = cache_get_field_content_int(0, "exp", mysql);
        PlayerBP[playerid][bpLevel] = cache_get_field_content_int(0, "level", mysql);
        PlayerBP[playerid][bpPremium] = cache_get_field_content_int(0, "premium", mysql);
        PlayerBP[playerid][bpTotalPoints] = cache_get_field_content_int(0, "total_points", mysql);
        PlayerBP[playerid][bpRewardsBitmap][0] = cache_get_field_content_int(0, "rewards_bitmap0", mysql);
        PlayerBP[playerid][bpRewardsBitmap][1] = cache_get_field_content_int(0, "rewards_bitmap1", mysql);
        PlayerBP[playerid][bpRewardsBitmap][2] = cache_get_field_content_int(0, "rewards_bitmap2", mysql);
        PlayerBP[playerid][bpRewardsBitmap][3] = cache_get_field_content_int(0, "rewards_bitmap3", mysql);
        PlayerBP[playerid][bpRewardsBitmap][4] = cache_get_field_content_int(0, "rewards_bitmap4", mysql);

        // Anti-free-BP fix: a clean account must not have level 1 reward for free.
        // Level 1 is opened only after 1000 BP EXP or after buying a BP level slot.
        if(PlayerBP[playerid][bpLevel] == 1 && PlayerBP[playerid][bpExp] == 0 && PlayerBP[playerid][bpTotalPoints] == 0)
        {
            PlayerBP[playerid][bpLevel] = 0;
            SavePlayerBP(playerid);
        }
        if(PlayerBP[playerid][bpLevel] < 0) PlayerBP[playerid][bpLevel] = 0;
        if(PlayerBP[playerid][bpLevel] > MAX_BP_LEVEL) PlayerBP[playerid][bpLevel] = MAX_BP_LEVEL;
    }
    else
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `black_pass` (`user_id`, `level`, `rewards_bitmap0`, `rewards_bitmap1`, `rewards_bitmap2`, `rewards_bitmap3`, `rewards_bitmap4`) VALUES (%d, 0, 0, 0, 0, 0, 0)", GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");
        ResetPlayerBP(playerid);
        printf("[BP_CREATE_PROFILE] uid=%d level=0", GetPlayerAccountID(playerid));
    }
    UpdateBPLeaderboard(playerid);
    BP_CleanupInvalidRewards(playerid);
    return 1;
}

forward LoadBPTop();
public LoadBPTop()
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    for(new i = 0; i < rows && i < MAX_BP_TOP; i++)
    {
        BlackPassTop[i][topUserID] = cache_get_field_content_int(i, "user_id");
        BlackPassTop[i][topPoints] = cache_get_field_content_int(i, "total_points");
        new name_q[128];
        mysql_format(mysql, name_q, sizeof(name_q), "SELECT `name` FROM `accounts` WHERE `id` = %d", BlackPassTop[i][topUserID]);
        new Cache:name_res = mysql_query(mysql, name_q);
        if(cache_num_rows() > 0) cache_get_field_content(0, "name", BlackPassTop[i][topName], mysql, MAX_PLAYER_NAME);
        else format(BlackPassTop[i][topName], MAX_PLAYER_NAME, "ID:%d", BlackPassTop[i][topUserID]);
        cache_delete(name_res);
    }
    BlackPassTopCount = rows;
    if(BlackPassTopCount > MAX_BP_TOP) BlackPassTopCount = MAX_BP_TOP;
    print("[Black Pass] Топ лидеров успешно загружен.");
    return 1;
}

stock BP_GetRewardClaimIndex(level, premium)
{
    if(level < 1 || level > BP_REWARD_MAX_LEVEL) return -1;
    return (premium ? BP_REWARD_MAX_LEVEL : 0) + (level - 1);
}

stock IsBPRewardTakenRow(playerid, level, premium)
{
    new idx = BP_GetRewardClaimIndex(level, premium);
    if(idx < 0) return 1;

    new slot = idx / 32;
    new bit = idx % 32;
    if(slot < 0 || slot >= 5) return 1;

    return (PlayerBP[playerid][bpRewardsBitmap][slot] & (1 << bit)) ? 1 : 0;
}

stock SetBPRewardTakenRow(playerid, level, premium, bool:taken)
{
    new idx = BP_GetRewardClaimIndex(level, premium);
    if(idx < 0) return 0;

    new slot = idx / 32;
    new bit = idx % 32;
    if(slot < 0 || slot >= 5) return 0;

    if(taken) PlayerBP[playerid][bpRewardsBitmap][slot] |= (1 << bit);
    else PlayerBP[playerid][bpRewardsBitmap][slot] &= ~(1 << bit);
    return 1;
}

stock BP_CleanupInvalidRewards(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    return 1;
}

stock BP_SyncAvailableRewardsToReward(playerid, bool:notify)
{
    // Награды Black Pass выдаются в существующую систему /reward
    // только после явного нажатия "Получить" в интерфейсе Black Pass.
    return 0;
}

stock BP_BuyPremium(playerid)
{
    if(PlayerBP[playerid][bpPremium] == 1)
    {
        ShowNotification(playerid, 2, "Premium Black Pass уже активен", 4, "", "");
        SendFullBPUpdate(playerid);
        return 1;
    }

    if(GetPlayerBlackCoin(playerid) < BP_PREMIUM_PRICE)
    {
        ShowNotification(playerid, 0, "Недостаточно Black Coin!", 5, "", "");
        return 0;
    }

    GivePlayerBlackCoin(playerid, -BP_PREMIUM_PRICE);
    PlayerBP[playerid][bpPremium] = 1;
    SavePlayerBP(playerid);

    ShowNotification(playerid, 1, "Вы приобрели Premium Black Pass", 5, "", "");
    SendFullBPUpdate(playerid);
    return 1;
}

stock BP_IsRewardQueued(playerid, level, premium)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    return IsBPRewardTakenRow(playerid, level, premium);
}

stock BP_ClaimRewardToReward(playerid, level, premium)
{
    if(!IsPlayerConnected(playerid)) return 0;

    if(level < 1 || level > BP_REWARD_MAX_LEVEL)
    {
        ShowNotification(playerid, 0, "Некорректная награда Black Pass", 5, "", "");
        return 0;
    }

    if(level > PlayerBP[playerid][bpLevel])
    {
        ShowNotification(playerid, 0, "Этот уровень Black Pass ещё не достигнут", 5, "", "");
        return 0;
    }

    if(premium == 1 && PlayerBP[playerid][bpPremium] != 1)
    {
        ShowNotification(playerid, 0, "Premium Black Pass не активирован", 5, "", "");
        return 0;
    }

    if(IsBPRewardTakenRow(playerid, level, premium))
    {
        ShowNotification(playerid, 2, "Эта награда Black Pass уже получена", 5, "", "");
        return 1;
    }

    if(!BP_AddRewardToRewardList(playerid, level, premium))
    {
        ShowNotification(playerid, 0, "Не удалось добавить BP-награду в /reward. Возможно, список наград переполнен.", 5, "", "");
        return 0;
    }

    SetBPRewardTakenRow(playerid, level, premium, true);
    SavePlayerBP(playerid);

    new str[144], rowName[16];
    if(premium == 1) format(rowName, sizeof(rowName), "Premium");
    else format(rowName, sizeof(rowName), "Standard");

    format(str, sizeof(str), "%s-награда Black Pass %d добавлена в /reward",
        rowName, level);
    ShowNotification(playerid, 1, str, 5, "", "");

    return 1;
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
    SendPacketToClient(playerid, guiid, json);
    return 1;
}

