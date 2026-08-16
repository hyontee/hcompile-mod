forward SendPacketToClient(playerid, guiid, Node:json);
#define MAX_BP_LEVEL            100
#define BP_EXP_PER_LEVEL        1000
#define MAX_BP_TASKS            17
#define MAX_BP_TOP              15
#define BP_CURRENT_SEASON_ID    1
#define BP_SEASON_END_TS        1785542400
#define BP_DAILY_EXP_LIMIT      5000
#define BP_PREMIUM_EXP_PERCENT  25
#define BP_DAILY_TASKS_COUNT    7
#define BP_WEEKLY_TASKS_COUNT   10
#define BP_SEASON_NAME          "ТАЙНА ШКАТУЛКИ"

#define BP_TASK_DAILY_ONLINE        1
#define BP_TASK_DAILY_WORK          2
#define BP_TASK_DAILY_DRIVE         3
#define BP_TASK_DAILY_EARN          4
#define BP_TASK_DAILY_FISH_HUNT     5
#define BP_TASK_DAILY_CASES         6
#define BP_TASK_DAILY_LOGIN         7
#define BP_TASK_WEEKLY_ONLINE       8
#define BP_TASK_WEEKLY_WORK         9
#define BP_TASK_WEEKLY_EARN         10
#define BP_TASK_WEEKLY_CASES        11
#define BP_TASK_WEEKLY_MARKET       12
#define BP_TASK_WEEKLY_DRIVE        13
#define BP_TASK_WEEKLY_FISH_HUNT    14
#define BP_TASK_WEEKLY_LOGIN_DAYS   15
#define BP_TASK_WEEKLY_EVENTS       16
#define BP_TASK_WEEKLY_FINAL        17

enum E_BP_DATA
{
    bpID,
    bpExp,
    bpLevel,
    bpPremium,
    bpTotalPoints,
    bpSeasonID,
    bpDailyExp,
    bpDailyDate,
    bpWeeklyDate,
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
forward BP_LoadPlayerTasks(playerid);
forward BP_OnPlayerSeasonLogin(playerid);
forward BP_OnMinuteTick(bool:new_day);

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

stock BP_GetToday()
{
    new year, month, day;
    getdate(year, month, day);
    return year * 10000 + month * 100 + day;
}

stock BP_GetWeekKey()
{
    return gettime() / 604800;
}

stock BP_GetDayTimeLeft()
{
    new now = gettime();
    new left = 86400 - (now % 86400);
    if(left < 0) left = 0;
    return left;
}

stock BP_GetWeekTimeLeft()
{
    new now = gettime();
    new left = 604800 - (now % 604800);
    if(left < 0) left = 0;
    return left;
}

stock BP_GetSeasonTimeLeft()
{
    new left = BP_SEASON_END_TS - gettime();
    if(left < 0) left = 0;
    return left;
}

stock BP_IsDailyTask(taskid)
{
    return (taskid >= 1 && taskid <= BP_DAILY_TASKS_COUNT) ? 1 : 0;
}

stock BP_IsWeeklyTask(taskid)
{
    return (taskid > BP_DAILY_TASKS_COUNT && taskid <= MAX_BP_TASKS) ? 1 : 0;
}

stock BP_GetTaskGuiStatus(playerid, taskid)
{
    if(taskid < 1 || taskid > MAX_BP_TASKS) return 0;

    new idx = taskid - 1;
    if(PlayerBP[playerid][bpTasks][idx] == 1) return 1; // claimed/taken
    if(PlayerBP[playerid][bpTaskProgress][idx] >= BP_GetTaskTarget(taskid)) return 2; // ready to claim
    return 0; // active/in progress; status 4 is hidden by BP GUI
}

stock BP_GetTaskTarget(taskid)
{
    switch(taskid)
    {
        case BP_TASK_DAILY_ONLINE: return 30;
        case BP_TASK_DAILY_WORK: return 10;
        case BP_TASK_DAILY_DRIVE: return 20;
        case BP_TASK_DAILY_EARN: return 25000;
        case BP_TASK_DAILY_FISH_HUNT: return 15;
        case BP_TASK_DAILY_CASES: return 1;
        case BP_TASK_DAILY_LOGIN: return 1;
        case BP_TASK_WEEKLY_ONLINE: return 600;
        case BP_TASK_WEEKLY_WORK: return 100;
        case BP_TASK_WEEKLY_EARN: return 500000;
        case BP_TASK_WEEKLY_CASES: return 25;
        case BP_TASK_WEEKLY_MARKET: return 10;
        case BP_TASK_WEEKLY_DRIVE: return 300;
        case BP_TASK_WEEKLY_FISH_HUNT: return 200;
        case BP_TASK_WEEKLY_LOGIN_DAYS: return 14;
        case BP_TASK_WEEKLY_EVENTS: return 10;
        case BP_TASK_WEEKLY_FINAL: return 1;
    }
    return 1;
}

stock BP_GetTaskReward(taskid)
{
    switch(taskid)
    {
        case BP_TASK_DAILY_ONLINE: return 150;
        case BP_TASK_DAILY_WORK: return 250;
        case BP_TASK_DAILY_DRIVE: return 250;
        case BP_TASK_DAILY_EARN: return 300;
        case BP_TASK_DAILY_FISH_HUNT: return 300;
        case BP_TASK_DAILY_CASES: return 250;
        case BP_TASK_DAILY_LOGIN: return 100;
        case BP_TASK_WEEKLY_ONLINE: return 1000;
        case BP_TASK_WEEKLY_WORK: return 1200;
        case BP_TASK_WEEKLY_EARN: return 1500;
        case BP_TASK_WEEKLY_CASES: return 1200;
        case BP_TASK_WEEKLY_MARKET: return 1000;
        case BP_TASK_WEEKLY_DRIVE: return 1250;
        case BP_TASK_WEEKLY_FISH_HUNT: return 1500;
        case BP_TASK_WEEKLY_LOGIN_DAYS: return 2000;
        case BP_TASK_WEEKLY_EVENTS: return 1200;
        case BP_TASK_WEEKLY_FINAL: return 2500;
    }
    return 100;
}

stock BP_CheckDailyReset(playerid)
{
    new today = BP_GetToday();
    if(PlayerBP[playerid][bpDailyDate] == today) return 0;

    PlayerBP[playerid][bpDailyDate] = today;
    PlayerBP[playerid][bpDailyExp] = 0;

    for(new i = 0; i < BP_DAILY_TASKS_COUNT; i++)
    {
        PlayerBP[playerid][bpTasks][i] = 0;
        PlayerBP[playerid][bpTaskProgress][i] = 0;
    }

    if(GetPlayerAccountID(playerid) > 0)
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `black_pass_tasks` WHERE `user_id` = %d AND `season_id` = %d AND `task_id` BETWEEN 1 AND %d",
            GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID, BP_DAILY_TASKS_COUNT);
        mysql_tquery(mysql, query, "", "");
        SavePlayerBP(playerid);
    }
    return 1;
}

stock BP_CheckWeeklyReset(playerid)
{
    new week = BP_GetWeekKey();
    if(PlayerBP[playerid][bpWeeklyDate] == week) return 0;

    PlayerBP[playerid][bpWeeklyDate] = week;

    for(new i = BP_DAILY_TASKS_COUNT; i < MAX_BP_TASKS; i++)
    {
        PlayerBP[playerid][bpTasks][i] = 0;
        PlayerBP[playerid][bpTaskProgress][i] = 0;
    }

    if(GetPlayerAccountID(playerid) > 0)
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `black_pass_tasks` WHERE `user_id` = %d AND `season_id` = %d AND `task_id` BETWEEN %d AND %d",
            GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID, BP_DAILY_TASKS_COUNT + 1, MAX_BP_TASKS);
        mysql_tquery(mysql, query, "", "");
        SavePlayerBP(playerid);
    }
    return 1;
}

stock BP_CheckTaskResets(playerid)
{
    BP_CheckDailyReset(playerid);
    BP_CheckWeeklyReset(playerid);
    return 1;
}

stock BP_SaveTask(playerid, taskid)
{
    if(taskid < 1 || taskid > MAX_BP_TASKS) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new idx = taskid - 1;
    new query[384];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `black_pass_tasks` (`user_id`,`season_id`,`task_id`,`progress`,`claimed`,`updated_date`) VALUES (%d,%d,%d,%d,%d,%d) ON DUPLICATE KEY UPDATE `progress`=%d, `claimed`=%d, `updated_date`=%d",
        GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID, taskid,
        PlayerBP[playerid][bpTaskProgress][idx], PlayerBP[playerid][bpTasks][idx], BP_GetToday(),
        PlayerBP[playerid][bpTaskProgress][idx], PlayerBP[playerid][bpTasks][idx], BP_GetToday());
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock BP_GiveSeasonExp(playerid, amount, bool:premium_bonus = true, bool:ignore_limit = false)
{
    if(amount <= 0) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    BP_CheckTaskResets(playerid);

    if(premium_bonus && PlayerBP[playerid][bpPremium] == 1)
    {
        amount += (amount * BP_PREMIUM_EXP_PERCENT) / 100;
    }

    if(!ignore_limit)
    {
        new left = BP_DAILY_EXP_LIMIT - PlayerBP[playerid][bpDailyExp];
        if(left <= 0)
        {
            ShowNotificationSile(playerid, 2, 5, 0, 0, "Daily Black Pass EXP limit reached", "");
            return 0;
        }
        if(amount > left)
        {
            amount = left;
            ShowNotificationSile(playerid, 2, 5, 0, 0, "Daily Black Pass EXP limit capped reward", "");
        }
        PlayerBP[playerid][bpDailyExp] += amount;
    }

    PlayerBP[playerid][bpExp] += amount;
    PlayerBP[playerid][bpTotalPoints] += amount;
    while(PlayerBP[playerid][bpExp] >= BP_EXP_PER_LEVEL && PlayerBP[playerid][bpLevel] < MAX_BP_LEVEL)
    {
        PlayerBP[playerid][bpExp] -= BP_EXP_PER_LEVEL;
        PlayerBP[playerid][bpLevel]++;
    }
    SavePlayerBP(playerid);
    UpdateBPLeaderboard(playerid);
    return amount;
}

stock GivePlayerBPExp(playerid, amount)
{
    return BP_GiveSeasonExp(playerid, amount, true, false);
}

stock ResetPlayerBP(playerid)
{
    PlayerBP[playerid][bpExp] = 0;
    PlayerBP[playerid][bpLevel] = 0;
    PlayerBP[playerid][bpPremium] = 0;
    PlayerBP[playerid][bpTotalPoints] = 0;
    PlayerBP[playerid][bpSeasonID] = BP_CURRENT_SEASON_ID;
    PlayerBP[playerid][bpDailyExp] = 0;
    PlayerBP[playerid][bpDailyDate] = 0;
    PlayerBP[playerid][bpWeeklyDate] = 0;
    for(new i = 0; i < MAX_BP_TASKS; i++) 
    {
        PlayerBP[playerid][bpTasks][i] = 0;
        PlayerBP[playerid][bpTaskProgress][i] = 0;
    }
    for(new i = 0; i < 5; i++) PlayerBP[playerid][bpRewardsBitmap][i] = 0;
    return 1;
}

stock BP_ResetPlayerSeason(playerid)
{
    ResetPlayerBP(playerid);
    if(GetPlayerAccountID(playerid) > 0)
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query), "DELETE FROM `black_pass_tasks` WHERE `user_id` = %d", GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");
        mysql_format(mysql, query, sizeof(query), "DELETE FROM `bp_reward_sync` WHERE `user_id` = %d", GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");
        SavePlayerBP(playerid);
        BP_CleanupInvalidRewards(playerid);
    }
    return 1;
}

stock UpdateBPLeaderboard(playerid)
{
    if(GetPlayerAccountID(playerid) > 0) SavePlayerBP(playerid);

    new query[384];
    mysql_format(mysql, query, sizeof(query),
        "SELECT bp.user_id, bp.total_points, IFNULL(p.name, '') AS name FROM black_pass bp LEFT JOIN accounts p ON p.id = bp.user_id WHERE bp.season_id = %d ORDER BY bp.total_points DESC LIMIT %d",
        BP_CURRENT_SEASON_ID, MAX_BP_TOP);

    new Cache:result = mysql_query(mysql, query);
    new rows = cache_num_rows();
    BlackPassTopCount = 0;
    for(new i = 0; i < rows && i < MAX_BP_TOP; i++)
    {
        BlackPassTop[i][topUserID] = cache_get_field_content_int(i, "user_id");
        BlackPassTop[i][topPoints] = cache_get_field_content_int(i, "total_points");
        cache_get_field_content(i, "name", BlackPassTop[i][topName], mysql, MAX_PLAYER_NAME);
        if(!strlen(BlackPassTop[i][topName])) format(BlackPassTop[i][topName], MAX_PLAYER_NAME, "ID:%d", BlackPassTop[i][topUserID]);
        BlackPassTopCount++;
    }
    cache_delete(result);
    return 1;
}

stock SavePlayerBP(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[1600];
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `black_pass` (`user_id`,`exp`,`level`,`premium`,`total_points`,`season_id`,`daily_exp`,`daily_date`,`weekly_date`,`rewards_bitmap0`,`rewards_bitmap1`,`rewards_bitmap2`,`rewards_bitmap3`,`rewards_bitmap4`) VALUES (%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d) ON DUPLICATE KEY UPDATE `exp`=VALUES(`exp`), `level`=VALUES(`level`), `premium`=VALUES(`premium`), `total_points`=VALUES(`total_points`), `season_id`=VALUES(`season_id`), `daily_exp`=VALUES(`daily_exp`), `daily_date`=VALUES(`daily_date`), `weekly_date`=VALUES(`weekly_date`), `rewards_bitmap0`=VALUES(`rewards_bitmap0`), `rewards_bitmap1`=VALUES(`rewards_bitmap1`), `rewards_bitmap2`=VALUES(`rewards_bitmap2`), `rewards_bitmap3`=VALUES(`rewards_bitmap3`), `rewards_bitmap4`=VALUES(`rewards_bitmap4`)",
        GetPlayerAccountID(playerid), PlayerBP[playerid][bpExp], PlayerBP[playerid][bpLevel], PlayerBP[playerid][bpPremium], PlayerBP[playerid][bpTotalPoints],
        PlayerBP[playerid][bpSeasonID], PlayerBP[playerid][bpDailyExp], PlayerBP[playerid][bpDailyDate], PlayerBP[playerid][bpWeeklyDate],
        PlayerBP[playerid][bpRewardsBitmap][0], PlayerBP[playerid][bpRewardsBitmap][1], PlayerBP[playerid][bpRewardsBitmap][2], PlayerBP[playerid][bpRewardsBitmap][3], PlayerBP[playerid][bpRewardsBitmap][4]);
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
        PlayerBP[playerid][bpSeasonID] = cache_get_field_content_int(0, "season_id", mysql);
        PlayerBP[playerid][bpDailyExp] = cache_get_field_content_int(0, "daily_exp", mysql);
        PlayerBP[playerid][bpDailyDate] = cache_get_field_content_int(0, "daily_date", mysql);
        PlayerBP[playerid][bpWeeklyDate] = cache_get_field_content_int(0, "weekly_date", mysql);
        PlayerBP[playerid][bpRewardsBitmap][0] = cache_get_field_content_int(0, "rewards_bitmap0", mysql);
        PlayerBP[playerid][bpRewardsBitmap][1] = cache_get_field_content_int(0, "rewards_bitmap1", mysql);
        PlayerBP[playerid][bpRewardsBitmap][2] = cache_get_field_content_int(0, "rewards_bitmap2", mysql);
        PlayerBP[playerid][bpRewardsBitmap][3] = cache_get_field_content_int(0, "rewards_bitmap3", mysql);
        PlayerBP[playerid][bpRewardsBitmap][4] = cache_get_field_content_int(0, "rewards_bitmap4", mysql);

        if(PlayerBP[playerid][bpSeasonID] != BP_CURRENT_SEASON_ID)
        {
            BP_ResetPlayerSeason(playerid);
            printf("[BP_SEASON_RESET] uid=%d season=%d", GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID);
        }

        // Anti-free-BP fix: a clean account must not have level 1 reward for free.
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
        new query[384];
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `black_pass` (`user_id`, `season_id`, `level`, `daily_date`, `weekly_date`, `rewards_bitmap0`, `rewards_bitmap1`, `rewards_bitmap2`, `rewards_bitmap3`, `rewards_bitmap4`) VALUES (%d, %d, 0, 0, 0, 0, 0, 0, 0, 0)",
            GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID);
        mysql_tquery(mysql, query, "", "");
        ResetPlayerBP(playerid);
        printf("[BP_CREATE_PROFILE] uid=%d level=0 season=%d", GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID);
    }

    BP_LoadPlayerTasks(playerid);
    // HOTFIX: do not send/update BP GUI during login/spawn initialization.
    // Call BP_OnPlayerSeasonLogin(playerid) later only after player has fully spawned, if needed.
    UpdateBPLeaderboard(playerid);
    BP_CleanupInvalidRewards(playerid);
    return 1;
}

stock BP_LoadPlayerTasks(playerid)
{
    for(new i = 0; i < MAX_BP_TASKS; i++)
    {
        PlayerBP[playerid][bpTasks][i] = 0;
        PlayerBP[playerid][bpTaskProgress][i] = 0;
    }

    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT `task_id`, `progress`, `claimed` FROM `black_pass_tasks` WHERE `user_id` = %d AND `season_id` = %d",
        GetPlayerAccountID(playerid), BP_CURRENT_SEASON_ID);

    new Cache:result = mysql_query(mysql, query);
    new rows = cache_num_rows();
    for(new i = 0; i < rows; i++)
    {
        new taskid = cache_get_field_content_int(i, "task_id");
        if(taskid < 1 || taskid > MAX_BP_TASKS) continue;

        new idx = taskid - 1;
        PlayerBP[playerid][bpTaskProgress][idx] = cache_get_field_content_int(i, "progress");
        PlayerBP[playerid][bpTasks][idx] = cache_get_field_content_int(i, "claimed");
        if(PlayerBP[playerid][bpTaskProgress][idx] > BP_GetTaskTarget(taskid)) PlayerBP[playerid][bpTaskProgress][idx] = BP_GetTaskTarget(taskid);
    }
    cache_delete(result);
    return 1;
}

stock BP_OnPlayerSeasonLogin(playerid)
{
    new oldDailyDate = PlayerBP[playerid][bpDailyDate];
    new oldWeeklyDate = PlayerBP[playerid][bpWeeklyDate];

    BP_CheckTaskResets(playerid);

    if(oldDailyDate != BP_GetToday())
    {
        BP_AddQuestProgress(playerid, BP_TASK_DAILY_LOGIN, 1);
    }

    if(oldWeeklyDate != BP_GetWeekKey())
    {
        BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_LOGIN_DAYS, 1);
    }
    return 1;
}

stock BP_AddQuestProgress(playerid, taskid, amount = 1)
{
    if(taskid < 1 || taskid > MAX_BP_TASKS) return 0;
    if(amount <= 0) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    BP_CheckTaskResets(playerid);

    new idx = taskid - 1;
    if(PlayerBP[playerid][bpTasks][idx] == 1) return 0;

    new target = BP_GetTaskTarget(taskid);
    if(PlayerBP[playerid][bpTaskProgress][idx] >= target) return 0;

    PlayerBP[playerid][bpTaskProgress][idx] += amount;
    if(PlayerBP[playerid][bpTaskProgress][idx] > target) PlayerBP[playerid][bpTaskProgress][idx] = target;

    BP_SaveTask(playerid, taskid);

    // HOTFIX: progress is saved silently. Do not push GUI packets from background tasks,
    // because packet 22 is shared by Sile UI and can break auth/spawn GUI if sent too early.
    return 1;
}

stock BP_ClaimTaskReward(playerid, taskid)
{
    if(taskid < 1 || taskid > MAX_BP_TASKS) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    BP_CheckTaskResets(playerid);

    new idx = taskid - 1;
    if(PlayerBP[playerid][bpTasks][idx] == 1)
    {
        ShowNotificationSile(playerid, 2, 5, 0, 0, "Black Pass task reward already claimed", "");
        return 1;
    }

    new target = BP_GetTaskTarget(taskid);
    if(PlayerBP[playerid][bpTaskProgress][idx] < target)
    {
        ShowNotificationSile(playerid, 0, 5, 0, 0, "Black Pass task is not completed", "");
        return 0;
    }

    new reward = BP_GetTaskReward(taskid);
    new added = BP_GiveSeasonExp(playerid, reward, true, false);
    if(added <= 0) return 0;

    PlayerBP[playerid][bpTasks][idx] = 1;
    BP_SaveTask(playerid, taskid);

    new msg[128];
    format(msg, sizeof(msg), "Black Pass task reward: +%d EXP", added);
    ShowNotificationSile(playerid, 1, 5, 0, 0, msg, "");
    SendFullBPUpdate(playerid);
    return 1;
}

stock BP_OnMinuteTick(bool:new_day)
{
    #pragma unused new_day
    foreach(new playerid : Player)
    {
        if(!IsPlayerLogged(playerid)) continue;
        // HOTFIX: do not call BP_OnPlayerSeasonLogin from the minute timer.
        BP_AddQuestProgress(playerid, BP_TASK_DAILY_ONLINE, 1);
        BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_ONLINE, 1);
    }
    return 1;
}

stock BP_OnJobFinished(playerid, reward_money = 0)
{
    BP_AddQuestProgress(playerid, BP_TASK_DAILY_WORK, 1);
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_WORK, 1);
    if(reward_money > 0) BP_OnMoneyEarned(playerid, reward_money);
    return 1;
}

stock BP_OnMoneyEarned(playerid, amount)
{
    if(amount <= 0) return 0;
    BP_AddQuestProgress(playerid, BP_TASK_DAILY_EARN, amount);
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_EARN, amount);
    return 1;
}

stock BP_OnVehicleDistance(playerid, kilometers)
{
    if(kilometers <= 0) return 0;
    BP_AddQuestProgress(playerid, BP_TASK_DAILY_DRIVE, kilometers);
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_DRIVE, kilometers);
    return 1;
}

stock BP_OnFishOrHunt(playerid, amount = 1)
{
    BP_AddQuestProgress(playerid, BP_TASK_DAILY_FISH_HUNT, amount);
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_FISH_HUNT, amount);
    return 1;
}

stock BP_OnCaseOpened(playerid, amount = 1)
{
    BP_AddQuestProgress(playerid, BP_TASK_DAILY_CASES, amount);
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_CASES, amount);
    return 1;
}

stock BP_OnMarketAction(playerid, amount = 1)
{
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_MARKET, amount);
    return 1;
}

stock BP_OnEventComplete(playerid, amount = 1)
{
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_EVENTS, amount);
    return 1;
}

stock BP_CompleteFinalGoal(playerid)
{
    BP_AddQuestProgress(playerid, BP_TASK_WEEKLY_FINAL, 1);
    return 1;
}

forward LoadBPTop();
public LoadBPTop()
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    BlackPassTopCount = 0;
    for(new i = 0; i < rows && i < MAX_BP_TOP; i++)
    {
        BlackPassTop[i][topUserID] = cache_get_field_content_int(i, "user_id");
        BlackPassTop[i][topPoints] = cache_get_field_content_int(i, "total_points");
        cache_get_field_content(i, "name", BlackPassTop[i][topName], mysql, MAX_PLAYER_NAME);
        if(!strlen(BlackPassTop[i][topName])) format(BlackPassTop[i][topName], MAX_PLAYER_NAME, "ID:%d", BlackPassTop[i][topUserID]);
        BlackPassTopCount++;
    }
    print("[Black Pass] Top loaded.");
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
    BP_SyncAvailableRewardsToReward(playerid, true);
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
    BP_GiveSeasonExp(targetid, exp, false, true);
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
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `black_pass` (`user_id` INT PRIMARY KEY, `exp` INT DEFAULT 0, `level` INT DEFAULT 0, `premium` INT DEFAULT 0, `total_points` INT DEFAULT 0, `season_id` INT DEFAULT 1, `daily_exp` INT DEFAULT 0, `daily_date` INT DEFAULT 0, `weekly_date` INT DEFAULT 0, `rewards_bitmap0` INT DEFAULT 0, `rewards_bitmap1` INT DEFAULT 0, `rewards_bitmap2` INT DEFAULT 0, `rewards_bitmap3` INT DEFAULT 0, `rewards_bitmap4` INT DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `premium` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `total_points` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `season_id` INT DEFAULT 1", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `daily_exp` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `daily_date` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `weekly_date` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap0` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap1` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap2` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap3` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap4` INT DEFAULT 0", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `black_pass_tasks` (`user_id` INT NOT NULL, `season_id` INT NOT NULL DEFAULT 1, `task_id` INT NOT NULL, `progress` INT NOT NULL DEFAULT 0, `claimed` TINYINT NOT NULL DEFAULT 0, `updated_date` INT NOT NULL DEFAULT 0, PRIMARY KEY (`user_id`,`season_id`,`task_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `black_pass_top` (`user_id` INT PRIMARY KEY, `total_points` INT DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `bp_reward_sync` (`user_id` INT NOT NULL, `level` INT NOT NULL, `premium` TINYINT NOT NULL DEFAULT 0, PRIMARY KEY (`user_id`,`level`,`premium`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");

    new query[384];
    mysql_format(mysql, query, sizeof(query),
        "SELECT bp.user_id, bp.total_points, IFNULL(p.name, '') AS name FROM black_pass bp LEFT JOIN accounts p ON p.id = bp.user_id WHERE bp.season_id = %d ORDER BY bp.total_points DESC LIMIT %d",
        BP_CURRENT_SEASON_ID, MAX_BP_TOP);
    mysql_tquery(mysql, query, "LoadBPTop", "");
    return 1;
}
