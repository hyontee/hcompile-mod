forward SendPacketToClient(playerid, guiid, Node:json);
#define MAX_BP_LEVEL            100
#define BP_EXP_PER_LEVEL        1000
#define MAX_BP_TASKS            17
#define MAX_BP_TOP              15
#define BP_SEASON_NAME          "ТАЙНА ШКАТУЛКИ"

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

forward SendFullBPUpdate(playerid);
forward BP_ClaimRewardToReward(playerid, level, premium);
forward BP_SyncAvailableRewardsToReward(playerid, bool:notify);
forward BP_CleanupInvalidRewards(playerid);
forward BP_IsRewardQueued(playerid, level, premium);

stock GetPlayerBPExp(playerid) return PlayerBP[playerid][bpExp];
stock GetPlayerBPLevel(playerid) return PlayerBP[playerid][bpLevel];
stock GetPlayerBPStatus(playerid) return PlayerBP[playerid][bpPremium];

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
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `black_pass` WHERE `user_id` = %d", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnPlayerBPLoaded", "i", playerid);
    return 1;
}

forward OnPlayerBPLoaded(playerid);
public OnPlayerBPLoaded(playerid)
{
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

    new maxLevel = PlayerBP[playerid][bpLevel];
    if(maxLevel < 0) maxLevel = 0;
    if(maxLevel > BP_REWARD_MAX_LEVEL) maxLevel = BP_REWARD_MAX_LEVEL;

    new query[512];

    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `rewards` WHERE `uid` = %d AND `case_id` = %d AND `award_id` > %d",
        GetPlayerAccountID(playerid), BP_REWARD_CASE_STANDARD, maxLevel);
    mysql_tquery(mysql, query, "", "");

    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `bp_reward_sync` WHERE `user_id` = %d AND `premium` = 0 AND `level` > %d",
        GetPlayerAccountID(playerid), maxLevel);
    mysql_tquery(mysql, query, "", "");

    if(PlayerBP[playerid][bpPremium] != 1)
    {
        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `rewards` WHERE `uid` = %d AND `case_id` = %d",
            GetPlayerAccountID(playerid), BP_REWARD_CASE_PREMIUM);
        mysql_tquery(mysql, query, "", "");

        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `bp_reward_sync` WHERE `user_id` = %d AND `premium` = 1",
            GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");
    }
    else
    {
        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `rewards` WHERE `uid` = %d AND `case_id` = %d AND `award_id` > %d",
            GetPlayerAccountID(playerid), BP_REWARD_CASE_PREMIUM, maxLevel);
        mysql_tquery(mysql, query, "", "");

        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `bp_reward_sync` WHERE `user_id` = %d AND `premium` = 1 AND `level` > %d",
            GetPlayerAccountID(playerid), maxLevel);
        mysql_tquery(mysql, query, "", "");
    }

    return 1;
}

stock BP_SyncAvailableRewardsToReward(playerid, bool:notify)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new maxLevel = PlayerBP[playerid][bpLevel];
    if(maxLevel > BP_REWARD_MAX_LEVEL) maxLevel = BP_REWARD_MAX_LEVEL;
    if(maxLevel < 1) return 0;

    new processed = 0;
    for(new level = 1; level <= maxLevel; level++)
    {
        if(!IsBPRewardTakenRow(playerid, level, 0) && !BP_IsRewardQueued(playerid, level, 0))
        {
            if(BP_AddRewardToRewardList(playerid, level, 0)) processed++;
        }

        if(PlayerBP[playerid][bpPremium] == 1)
        {
            if(!IsBPRewardTakenRow(playerid, level, 1) && !BP_IsRewardQueued(playerid, level, 1))
            {
                if(BP_AddRewardToRewardList(playerid, level, 1)) processed++;
            }
        }
    }

    if(processed > 0)
    {
        if(notify)
        {
            new msg[144];
            format(msg, sizeof(msg), "BP-награды добавлены в /bprewardall: %d", processed);
            ShowNotificationSile(playerid, 1, 5, 0, 0, msg, "");
        }
        printf("[BP_REWARD_QUEUE_SYNC] player=%d uid=%d processed=%d level=%d premium=%d", playerid, GetPlayerAccountID(playerid), processed, PlayerBP[playerid][bpLevel], PlayerBP[playerid][bpPremium]);
    }
    return processed;
}

stock BP_BuyPremium(playerid)
{
    if(PlayerBP[playerid][bpPremium] == 1)
    {
        ShowNotificationSile(playerid, 2, 4, 1, 1, "Premium Black Pass уже активен", "");
        SendFullBPUpdate(playerid);
        return 1;
    }

    if(GetPlayerDonateRub(playerid) < BP_PREMIUM_PRICE)
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Недостаточно Black Coin!", "");
        return 0;
    }

    GivePlayerDonateRub(playerid, -BP_PREMIUM_PRICE, "Black Pass Premium", true, true);
    PlayerBP[playerid][bpPremium] = 1;
    SavePlayerBP(playerid);
    SavePlayerAccount(playerid);
    ShowNotificationSile(playerid, 1, 5, 0, 0, "Вы купили Premium Black Pass", "");
    SendFullBPUpdate(playerid);
    return 1;
}

stock GiveBPRewardByLevel(playerid, level)
{
    if(level < 1 || level > BP_REWARD_MAX_LEVEL) return 0;
    return BP_ClaimRewardToReward(playerid, level, 0);
}

stock BP_IsRewardQueued(playerid, level, premium)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    if(level < 1 || level > BP_REWARD_MAX_LEVEL) return 0;

    new case_id = premium ? BP_REWARD_CASE_PREMIUM : BP_REWARD_CASE_STANDARD;
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT 1 FROM `rewards` WHERE `uid` = %d AND `award_id` = %d AND `case_id` = %d LIMIT 1",
        GetPlayerAccountID(playerid), level, case_id);

    new Cache:result = mysql_query(mysql, query);
    new exists = cache_num_rows();
    cache_delete(result);
    return exists > 0;
}

stock BP_ClaimRewardToReward(playerid, level, premium)
{
    if(level < 1 || level > BP_REWARD_MAX_LEVEL)
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Invalid Black Pass reward", "");
        return 0;
    }

    if(level > PlayerBP[playerid][bpLevel])
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Black Pass level is not reached", "");
        return 0;
    }

    if(premium == 1 && PlayerBP[playerid][bpPremium] != 1)
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Premium Black Pass is not active", "");
        return 0;
    }

    if(BP_IsRewardQueued(playerid, level, premium))
    {
        ShowNotificationSile(playerid, 2, 5, 0, 0, "Награда уже добавлена или получена через /bprewardall", "");
        return 1;
    }

    new type, internal, count, spray_price, name[32];
    new row = premium ? BP_REWARD_ROW_PREMIUM : BP_REWARD_ROW_STANDARD;
    if(!BP_GetRewardData(row, level, type, internal, count, spray_price, name, sizeof(name)))
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Black Pass reward data not found", "");
        return 0;
    }

    if(!BP_AddRewardToRewardList(playerid, level, premium))
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Не удалось добавить BP-награду в /bprewardall", "");
        return 0;
    }

    new str[144], rowName[16];
    if(premium == 1) format(rowName, sizeof(rowName), "Premium");
    else format(rowName, sizeof(rowName), "Standard");

    format(str, sizeof(str), "%s BP уровень %d добавлен в /bprewardall", rowName, level);
    ShowNotificationSile(playerid, 1, 5, 0, 0, str, "");
    printf("[BP_REWARD_QUEUE] player=%d uid=%d level=%d premium=%d added_to_bprewardall=1", playerid, GetPlayerAccountID(playerid), level, premium);

    // Важно: саму награду в окне Black Pass не помечаем как полученную.
    // Игрок забирает её уже через /bprewardall.
    return 1;
}

stock SendFullBPUpdate(playerid)
{
    new Node:full = JSON_Object();
    JSON_SetInt(full, "t", -2);
    SendPacketToClient(playerid, 22, full);
    JSON_Cleanup(full);
}


CMD:bprewardall(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 1;

    SetPVarInt(playerid, "reward_view_bp", 1);
    SetPVarInt(playerid, "reward_offset", 0);

    // Синхронизирует доступные награды Black Pass в /reward,
    // но не выдаёт их сразу: игрок забирает их через список наград.
    BP_SyncAvailableRewardsToReward(playerid, true);
    return Rewards_LoadPage(playerid, 0);
}

CMD:bpclaimall(playerid, params[])
{
    #pragma unused params
    return callcmd::bprewardall(playerid, "");
}

CMD:syncbp(playerid, params[])
{
    #pragma unused params
    return callcmd::bprewardall(playerid, "");
}

CMD:lvlbp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5) return 1;
    new targetid, level;
    if(sscanf(params, "ui", targetid, level)) return SendClientMessage(playerid, -1, "{FF9900}Используйте: /lvlbp [id] [уровень]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети!");
    if(level < 1 || level > MAX_BP_LEVEL) return SendClientMessage(playerid, -1, "{FF0000}Неверный уровень!");
    PlayerBP[targetid][bpLevel] = level;
    PlayerBP[targetid][bpExp] = 0;
    SavePlayerBP(targetid);
    UpdateBPLeaderboard(targetid);
    SendFullBPUpdate(targetid);
    new str[128];
    format(str, sizeof(str), "[A] Вы установили игроку %s %d уровень Black Pass.", GetPlayerNameEx(targetid), level);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:expbp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5) return 1;
    new targetid, exp;
    if(sscanf(params, "ui", targetid, exp)) return SendClientMessage(playerid, -1, "{FF9900}Используйте: /expbp [id] [опыт]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети!");
    GivePlayerBPExp(targetid, exp);
    SendFullBPUpdate(targetid);
    new str[128];
    format(str, sizeof(str), "[A] Вы выдали игроку %s %d опыта Black Pass.", GetPlayerNameEx(targetid), exp);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:premiumbp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5) return 1;
    new targetid, status;
    if(sscanf(params, "ui", targetid, status)) return SendClientMessage(playerid, -1, "{FF9900}Используйте: /premiumbp [id] [0-1]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети!");
    if(status < 0 || status > 1) return SendClientMessage(playerid, -1, "{FF0000}Используйте 0 для снятия или 1 для выдачи!");
    PlayerBP[targetid][bpPremium] = status;
    SavePlayerBP(targetid);
    SendFullBPUpdate(targetid);
    new str[128];
    format(str, sizeof(str), "[A] Вы %s статус PREMIUM для %s.", (status == 1 ? ("{66CC66}выдали") : ("{FF0000}забрали")), GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, str);
    return 1;
}

//shram
//shram
//shram
//shram
//shram
//shramip
//shramip
// by @shramip
//shramip

stock BlackPass_DBInit()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `black_pass` (`user_id` INT PRIMARY KEY, `exp` INT DEFAULT 0, `level` INT DEFAULT 0, `premium` INT DEFAULT 0, `total_points` INT DEFAULT 0, `rewards_bitmap0` INT DEFAULT 0, `rewards_bitmap1` INT DEFAULT 0, `rewards_bitmap2` INT DEFAULT 0, `rewards_bitmap3` INT DEFAULT 0, `rewards_bitmap4` INT DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `premium` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `total_points` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap0` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap1` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap2` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap3` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap4` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `black_pass_top` (`user_id` INT PRIMARY KEY, `total_points` INT DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `bp_reward_sync` (`user_id` INT NOT NULL, `level` INT NOT NULL, `premium` TINYINT NOT NULL DEFAULT 0, PRIMARY KEY (`user_id`,`level`,`premium`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "INSERT INTO `black_pass_top` (`user_id`, `total_points`) SELECT `id`, 0 FROM `accounts` ON DUPLICATE KEY UPDATE `total_points` = `total_points`", "", "");
    mysql_tquery(mysql, "SELECT user_id, total_points FROM black_pass_top ORDER BY total_points DESC LIMIT 15", "LoadBPTop", "");
    return 1;
}
