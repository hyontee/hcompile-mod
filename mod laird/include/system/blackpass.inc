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
    pBlackPass,
    bpPremium,
    bpTotalPoints,
    bpTasks[MAX_BP_TASKS],
    bpTaskProgress[MAX_BP_TASKS],
    bpRewardsBitmap[4]
}

new PlayerBPBP[MAX_PlayerBPS][E_BP_DATA];

enum E_BP_TOP
{
    topUserID,
    topPoints,
    topName[MAX_PlayerBP_NAME]
}

new BlackPassTop[MAX_BP_TOP][E_BP_TOP];
new BlackPassTopCount = 0;

stock GetPlayerBPBPExp(PlayerBPid) return PlayerBPBP[PlayerBPid][bpExp];
stock GetPlayerBPBPLevel(PlayerBPid) return PlayerBPBP[PlayerBPid][bpLevel];
stock GetPlayerBPBPStatus(PlayerBPid) return PlayerBPBP[PlayerBPid][bpPremium];

stock IsBPRewardTaken(PlayerBPid, level)
{
    if(level < 1 || level > MAX_BP_LEVEL) return 0;
    new slot = (level-1) / 32;
    new bit = (level-1) % 32;
    return (PlayerBPBP[PlayerBPid][bpRewardsBitmap][slot] & (1<<bit)) ? 1 : 0;
}

stock SetBPRewardTaken(PlayerBPid, level, bool:taken)
{
    if(level < 1 || level > MAX_BP_LEVEL) return 0;
    new slot = (level-1) / 32;
    new bit = (level-1) % 32;
    if(taken) PlayerBPBP[PlayerBPid][bpRewardsBitmap][slot] |= (1<<bit);
    else PlayerBPBP[PlayerBPid][bpRewardsBitmap][slot] &= ~(1<<bit);
    return 1;
}

stock GivePlayerBPBPExp(PlayerBPid, amount)
{
    PlayerBPBP[PlayerBPid][bpExp] += amount;
    PlayerBPBP[PlayerBPid][bpTotalPoints] += amount;
    while(PlayerBPBP[PlayerBPid][bpExp] >= BP_EXP_PER_LEVEL && PlayerBPBP[PlayerBPid][bpLevel] < MAX_BP_LEVEL)
    {
        PlayerBPBP[PlayerBPid][bpExp] -= BP_EXP_PER_LEVEL;
        PlayerBPBP[PlayerBPid][bpLevel]++;
    }
    SavePlayerBPBP(PlayerBPid);
    UpdateBPLeaderboard(PlayerBPid);
    return 1;
}

stock ResetPlayerBPBP(PlayerBPid)
{
    PlayerBPBP[PlayerBPid][bpExp] = 0;
    PlayerBPBP[PlayerBPid][bpLevel] = 1;
    PlayerBPBP[PlayerBPid][bpPremium] = 0;
    PlayerBPBP[PlayerBPid][bpTotalPoints] = 0;
    for(new i = 0; i < MAX_BP_TASKS; i++) 
    {
        PlayerBPBP[PlayerBPid][bpTasks][i] = 0;
        PlayerBPBP[PlayerBPid][bpTaskProgress][i] = 0;
    }
    for(new i = 0; i < 4; i++) PlayerBPBP[PlayerBPid][bpRewardsBitmap][i] = 0;
    return 1;
}



stock UpdateBPLeaderboard(PlayerBPid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `black_pass_top` (`user_id`, `total_points`) VALUES (%d, %d) ON DUPLICATE KEY UPDATE `total_points` = %d", PlayerBPBP[PlayerBPid][pID], PlayerBPBP[PlayerBPid][bpTotalPoints], PlayerBPBP[PlayerBPid][bpTotalPoints]);
   mysql_tquery(mysql, query, "", "");
    
    new Cache:result = mysql_query(mysql, "SELECT user_id, total_points FROM black_pass_top ORDER BY total_points DESC LIMIT 15");
    new rows = cache_num_rows();
    BlackPassTopCount = 0;
    for(new i = 0; i < rows && i < MAX_BP_TOP; i++)
    {
        BlackPassTop[i][topUserID] = cache_get_field_content_int(i, "user_id");
        BlackPassTop[i][topPoints] = cache_get_field_content_int(i, "total_points");
        new name_q[128];
        mysql_format(mysql, name_q, sizeof(name_q), "SELECT `name` FROM `PlayerBPs` WHERE `id` = %d", BlackPassTop[i][topUserID]);
        new Cache:name_res = mysql_query(mysql, name_q);
        if(cache_num_rows() > 0) cache_get_field_content(0, "name", BlackPassTop[i][topName], mysql, MAX_PlayerBP_NAME);
        else format(BlackPassTop[i][topName], MAX_PlayerBP_NAME, "ID:%d", BlackPassTop[i][topUserID]);
        cache_delete(name_res);
        BlackPassTopCount++;
    }
    cache_delete(result);
    return 1;
}


stock SavePlayerBPBP(PlayerBPid)
{
    new query[1024];
    mysql_format(mysql, query, sizeof(query), 
        "UPDATE `black_pass` SET `exp` = %d, `level` = %d, `premium` = %d, `total_points` = %d, `rewards_bitmap0` = %d, `rewards_bitmap1` = %d, `rewards_bitmap2` = %d, `rewards_bitmap3` = %d WHERE `user_id` = %d",
        PlayerBPBP[PlayerBPid][bpExp], PlayerBPBP[PlayerBPid][bpLevel], PlayerBPBP[PlayerBPid][bpPremium], PlayerBPBP[PlayerBPid][bpTotalPoints],
        PlayerBPBP[PlayerBPid][bpRewardsBitmap][0], PlayerBPBP[PlayerBPid][bpRewardsBitmap][1], PlayerBPBP[PlayerBPid][bpRewardsBitmap][2], PlayerBPBP[PlayerBPid][bpRewardsBitmap][3],
        PlayerBPBP[PlayerBPid][pID]);
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock LoadPlayerBPBP(PlayerBPid)
{
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `black_pass` WHERE `user_id` = %d", PlayerBP[PlayerBPid][pID]);
    mysql_tquery(mysql, query, "OnPlayerBPBPLoaded", "i", PlayerBPid);
    return 1;
}

forward OnPlayerBPBPLoaded(PlayerBPid);
public OnPlayerBPBPLoaded(PlayerBPid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(rows > 0)
    {
        PlayerBPBP[PlayerBPid][bpExp] = cache_get_field_content_int(0, "exp", mysql);
        PlayerBPBP[PlayerBPid][bpLevel] = cache_get_field_content_int(0, "level", mysql);
        PlayerBPBP[PlayerBPid][bpPremium] = cache_get_field_content_int(0, "premium", mysql);
        PlayerBPBP[PlayerBPid][bpTotalPoints] = cache_get_field_content_int(0, "total_points", mysql);
        PlayerBPBP[PlayerBPid][bpRewardsBitmap][0] = cache_get_field_content_int(0, "rewards_bitmap0", mysql);
        PlayerBPBP[PlayerBPid][bpRewardsBitmap][1] = cache_get_field_content_int(0, "rewards_bitmap1", mysql);
        PlayerBPBP[PlayerBPid][bpRewardsBitmap][2] = cache_get_field_content_int(0, "rewards_bitmap2", mysql);
        PlayerBPBP[PlayerBPid][bpRewardsBitmap][3] = cache_get_field_content_int(0, "rewards_bitmap3", mysql);
    }
    else
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `black_pass` (`user_id`, `level`, `rewards_bitmap0`, `rewards_bitmap1`, `rewards_bitmap2`, `rewards_bitmap3`) VALUES (%d, 1, 0, 0, 0, 0)", PlayerBP[PlayerBPid][pID]);
        mysql_tquery(mysql, query, "", "");
        ResetPlayerBPBP(PlayerBPid);
    }
    UpdateBPLeaderboard(PlayerBPid);
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
        mysql_format(mysql, name_q, sizeof(name_q), "SELECT `name` FROM `PlayerBPs` WHERE `id` = %d", BlackPassTop[i][topUserID]);
        new Cache:name_res = mysql_query(mysql, name_q);
        if(cache_num_rows() > 0) cache_get_field_content(0, "name", BlackPassTop[i][topName], mysql, MAX_PlayerBP_NAME);
        else format(BlackPassTop[i][topName], MAX_PlayerBP_NAME, "ID:%d", BlackPassTop[i][topUserID]);
        cache_delete(name_res);
    }
    BlackPassTopCount = rows;
    if(BlackPassTopCount > MAX_BP_TOP) BlackPassTopCount = MAX_BP_TOP;
    print("[Black Pass] Топ лидеров успешно загружен.");
    return 1;
}

stock GiveBPRewardByLevel(PlayerBPid, level)
{
    new rewardExp = 100;
    new rewardMoney = 10000;
    new rewardBC = 50;
    if(level % 10 == 0)
    {
        rewardExp = 500;
        rewardMoney = 50000;
        rewardBC = 200;
    }
    GivePlayerBPBPExp(PlayerBPid, rewardExp);
    GivePlayerBPMoneyEx(PlayerBPid, rewardMoney);
    GivePlayerBPBlackCoin(PlayerBPid, rewardBC);
    new str[128];
    format(str, sizeof(str), "{E0584B}BAZE RUSSIA {FFFFFF}| Вы получили награду за %d уровень: %d EXP, %d руб., %d BC.", level, rewardExp, rewardMoney, rewardBC);
    SendClientMessage(PlayerBPid, -1, str);
    return 1;
}

stock SendFullBPUpdate(PlayerBPid)
{
    new Node:full = JSON_Object();
    JSON_SetInt(full, "t", -2);
    OnPacketIncoming(PlayerBPid, 22, full);
    JSON_Cleanup(full);
}

CMD:lvlbp(PlayerBPid, params[])
{
    if(PlayerBP[PlayerBPid][pAdminLvl] < 5) return 1;
    new targetid, level;
    if(sscanf(params, "ui", targetid, level)) return SendClientMessage(PlayerBPid, -1, "{FF9900}Используйте: /lvlbp [id] [уровень]");
    if(!IsPlayerBPConnected(targetid)) return SendClientMessage(PlayerBPid, -1, "{FF0000}Игрок не в сети!");
    if(level < 1 || level > MAX_BP_LEVEL) return SendClientMessage(PlayerBPid, -1, "{FF0000}Неверный уровень!");
    PlayerBPBP[targetid][bpLevel] = level;
    PlayerBPBP[targetid][bpExp] = 0;
    SavePlayerBPBP(targetid);
    UpdateBPLeaderboard(targetid);
    SendFullBPUpdate(targetid);
    new str[128];
    format(str, sizeof(str), "[A] Вы установили игроку %s %d уровень Black Pass.", PlayerBP[targetid][pName], level);
    SendClientMessage(PlayerBPid, -1, str);
    return 1;
}

CMD:expbp(PlayerBPid, params[])
{
    if(PlayerBP[PlayerBPid][pAdminLvl] < 5) return 1;
    new targetid, exp;
    if(sscanf(params, "ui", targetid, exp)) return SendClientMessage(PlayerBPid, -1, "{FF9900}Используйте: /expbp [id] [опыт]");
    if(!IsPlayerBPConnected(targetid)) return SendClientMessage(PlayerBPid, -1, "{FF0000}Игрок не в сети!");
    GivePlayerBPBPExp(targetid, exp);
    SendFullBPUpdate(targetid);
    new str[128];
    format(str, sizeof(str), "[A] Вы выдали игроку %s %d опыта Black Pass.", PlayerBP[targetid][pName], exp);
    SendClientMessage(PlayerBPid, -1, str);
    return 1;
}

CMD:premiumbp(PlayerBPid, params[])
{
    if(PlayerBP[PlayerBPid][pAdminLvl] < 5) return 1;
    new targetid, status;
    if(sscanf(params, "ui", targetid, status)) return SendClientMessage(PlayerBPid, -1, "{FF9900}Используйте: /premiumbp [id] [0-1]");
    if(!IsPlayerBPConnected(targetid)) return SendClientMessage(PlayerBPid, -1, "{FF0000}Игрок не в сети!");
    if(status < 0 || status > 1) return SendClientMessage(PlayerBPid, -1, "{FF0000}Используйте 0 для снятия или 1 для выдачи!");
    PlayerBPBP[targetid][bpPremium] = status;
    SavePlayerBPBP(targetid);
    SendFullBPUpdate(targetid);
    new str[128];
    format(str, sizeof(str), "[A] Вы %s статус PREMIUM для %s.", (status == 1 ? ("{66CC66}выдали") : ("{FF0000}забрали")), PlayerBP[targetid][pName]);
    SendClientMessage(PlayerBPid, -1, str);
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