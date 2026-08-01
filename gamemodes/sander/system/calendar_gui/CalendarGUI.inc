#if defined _SANDER_CALENDAR_GUI
    #endinput
#endif
#define _SANDER_CALENDAR_GUI

#define CALENDAR_GUI_ID                  (71)
#define CALENDAR_MAX_DAYS                (30)
#define CALENDAR_SECONDS_IN_DAY          (86400)
#define CALENDAR_REWARD_CASE_ID          (1)     // rewards are queued into the existing /reward system
#define CALENDAR_MIN_BONUS_LEVEL         (1)

// Values used by the Android Calendar GUI. Main states are CommonRewardState values.
// Bonus states are CalendarBonusRewardState values from calendar.zip.
#define CALENDAR_MAIN_STATE_NOT_RECEIVED (0)
#define CALENDAR_MAIN_STATE_TIMER        (1)
#define CALENDAR_MAIN_STATE_AVAILABLE    (2)
#define CALENDAR_MAIN_STATE_RECEIVED     (3)
#define CALENDAR_BONUS_STATE_NOT_RECEIVED (0)
#define CALENDAR_BONUS_STATE_AVAILABLE   (2)
#define CALENDAR_BONUS_STATE_RECEIVED    (4)

new bool:g_CalendarLoaded[MAX_PLAYERS];
new bool:g_CalendarOpened[MAX_PLAYERS];
new g_CalendarSeason[MAX_PLAYERS];
new g_CalendarMainMask[MAX_PLAYERS];
new g_CalendarBonusMask[MAX_PLAYERS];
new g_CalendarReturnMainMask[MAX_PLAYERS];
new g_CalendarReturnBonusMask[MAX_PLAYERS];
new g_CalendarLastClaim[MAX_PLAYERS];

forward CalendarGUI_OnLoad(playerid);
forward CalendarGUI_SyncTimer();

stock CalendarGUI_Init()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `calendar_progress` (`account_id` INT NOT NULL, `season_id` INT NOT NULL DEFAULT 0, `main_mask` INT NOT NULL DEFAULT 0, `bonus_mask` INT NOT NULL DEFAULT 0, `return_main_mask` INT NOT NULL DEFAULT 0, `return_bonus_mask` INT NOT NULL DEFAULT 0, `last_claim_time` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", "", "");

    SetTimer("CalendarGUI_SyncTimer", 60000, true);
    return 1;
}

stock CalendarGUI_ResetPlayer(playerid)
{
    g_CalendarLoaded[playerid] = false;
    g_CalendarOpened[playerid] = false;
    g_CalendarSeason[playerid] = 0;
    g_CalendarMainMask[playerid] = 0;
    g_CalendarBonusMask[playerid] = 0;
    g_CalendarReturnMainMask[playerid] = 0;
    g_CalendarReturnBonusMask[playerid] = 0;
    g_CalendarLastClaim[playerid] = 0;
    return 1;
}

stock CalendarGUI_GetSeasonId()
{
    return gettime() / (CALENDAR_SECONDS_IN_DAY * CALENDAR_MAX_DAYS);
}

stock CalendarGUI_GetCurrentDay()
{
    return ((gettime() / CALENDAR_SECONDS_IN_DAY) % CALENDAR_MAX_DAYS) + 1;
}

stock CalendarGUI_GetSecondsForNewDay()
{
    new seconds = CALENDAR_SECONDS_IN_DAY - (gettime() % CALENDAR_SECONDS_IN_DAY);
    if(seconds <= 0 || seconds > CALENDAR_SECONDS_IN_DAY) seconds = CALENDAR_SECONDS_IN_DAY;
    return seconds;
}

stock CalendarGUI_GetSecondsForReward(playerid)
{
    new current_day = CalendarGUI_GetCurrentDay();
    if(!CalendarGUI_IsClaimed(g_CalendarMainMask[playerid], current_day)) return 0;
    return CalendarGUI_GetSecondsForNewDay();
}

stock CalendarGUI_GetBit(day)
{
    if(day < 1 || day > CALENDAR_MAX_DAYS) return 0;
    return (1 << (day - 1));
}

stock bool:CalendarGUI_IsClaimed(mask, day)
{
    new bit = CalendarGUI_GetBit(day);
    if(bit == 0) return false;
    return ((mask & bit) != 0);
}

stock CalendarGUI_AddClaimBit(mask, day)
{
    new bit = CalendarGUI_GetBit(day);
    if(bit == 0) return mask;
    return (mask | bit);
}

stock CalendarGUI_GetMainStatus(playerid, day, bool:come_back)
{
    new mask = come_back ? g_CalendarReturnMainMask[playerid] : g_CalendarMainMask[playerid];
    if(CalendarGUI_IsClaimed(mask, day)) return CALENDAR_MAIN_STATE_RECEIVED;

    new current_day = CalendarGUI_GetCurrentDay();
    if(day == current_day) return CALENDAR_MAIN_STATE_AVAILABLE;
    if(day > current_day) return CALENDAR_MAIN_STATE_TIMER;
    return CALENDAR_MAIN_STATE_NOT_RECEIVED;
}

stock CalendarGUI_GetBonusStatus(playerid, day, bool:come_back)
{
    new mask = come_back ? g_CalendarReturnBonusMask[playerid] : g_CalendarBonusMask[playerid];
    if(CalendarGUI_IsClaimed(mask, day)) return CALENDAR_BONUS_STATE_RECEIVED;

    new current_day = CalendarGUI_GetCurrentDay();
    if(day == current_day && GetPlayerData(playerid, P_LEVEL) >= CALENDAR_MIN_BONUS_LEVEL)
        return CALENDAR_BONUS_STATE_AVAILABLE;

    return CALENDAR_BONUS_STATE_NOT_RECEIVED;
}

stock Node:CalendarGUI_BuildMainStatusArray(playerid, bool:come_back)
{
    new Node:arr = JSON_Array();
    for(new day = 1; day <= CALENDAR_MAX_DAYS; day++)
    {
        arr = JSON_Append(arr, JSON_Array(JSON_Int(CalendarGUI_GetMainStatus(playerid, day, come_back))));
    }
    return arr;
}

stock Node:CalendarGUI_BuildBonusStatusArray(playerid, bool:come_back)
{
    new Node:arr = JSON_Array();
    for(new day = 1; day <= CALENDAR_MAX_DAYS; day++)
    {
        arr = JSON_Append(arr, JSON_Array(JSON_Int(CalendarGUI_GetBonusStatus(playerid, day, come_back))));
    }
    return arr;
}

stock CalendarGUI_SavePlayer(playerid)
{
    if(!IsPlayerLogged(playerid)) return 0;

    new query[768];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `calendar_progress` (`account_id`,`season_id`,`main_mask`,`bonus_mask`,`return_main_mask`,`return_bonus_mask`,`last_claim_time`,`updated_at`) VALUES (%d,%d,%d,%d,%d,%d,%d,%d) ON DUPLICATE KEY UPDATE `season_id`=%d,`main_mask`=%d,`bonus_mask`=%d,`return_main_mask`=%d,`return_bonus_mask`=%d,`last_claim_time`=%d,`updated_at`=%d",
        GetPlayerAccountID(playerid), g_CalendarSeason[playerid], g_CalendarMainMask[playerid], g_CalendarBonusMask[playerid],
        g_CalendarReturnMainMask[playerid], g_CalendarReturnBonusMask[playerid], g_CalendarLastClaim[playerid], gettime(),
        g_CalendarSeason[playerid], g_CalendarMainMask[playerid], g_CalendarBonusMask[playerid],
        g_CalendarReturnMainMask[playerid], g_CalendarReturnBonusMask[playerid], g_CalendarLastClaim[playerid], gettime()
    );
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock CalendarGUI_LoadPlayer(playerid)
{
    if(!IsPlayerLogged(playerid))
    {
        ShowNotification(playerid, 2, "\xd1\xed\xe0\xf7\xe0\xeb\xe0 \xe0\xe2\xf2\xee\xf0\xe8\xe7\xf3\xe9\xf2\xe5\xf1\xfc.", 4, "", "");
        return 0;
    }

    new query[192];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `calendar_progress` WHERE `account_id`=%d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "CalendarGUI_OnLoad", "i", playerid);
    return 1;
}

public CalendarGUI_OnLoad(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;

    new current_season = CalendarGUI_GetSeasonId();
    new rows = cache_num_rows();

    if(rows > 0)
    {
        g_CalendarSeason[playerid] = cache_get_field_content_int(0, "season_id");
        g_CalendarMainMask[playerid] = cache_get_field_content_int(0, "main_mask");
        g_CalendarBonusMask[playerid] = cache_get_field_content_int(0, "bonus_mask");
        g_CalendarReturnMainMask[playerid] = cache_get_field_content_int(0, "return_main_mask");
        g_CalendarReturnBonusMask[playerid] = cache_get_field_content_int(0, "return_bonus_mask");
        g_CalendarLastClaim[playerid] = cache_get_field_content_int(0, "last_claim_time");
    }
    else
    {
        g_CalendarSeason[playerid] = current_season;
        g_CalendarMainMask[playerid] = 0;
        g_CalendarBonusMask[playerid] = 0;
        g_CalendarReturnMainMask[playerid] = 0;
        g_CalendarReturnBonusMask[playerid] = 0;
        g_CalendarLastClaim[playerid] = 0;
    }

    if(g_CalendarSeason[playerid] != current_season)
    {
        g_CalendarSeason[playerid] = current_season;
        g_CalendarMainMask[playerid] = 0;
        g_CalendarBonusMask[playerid] = 0;
        g_CalendarReturnMainMask[playerid] = 0;
        g_CalendarReturnBonusMask[playerid] = 0;
        g_CalendarLastClaim[playerid] = 0;
    }

    g_CalendarLoaded[playerid] = true;
    CalendarGUI_SavePlayer(playerid);
    CalendarGUI_Show(playerid);
    return 1;
}

stock CalendarGUI_Open(playerid)
{
    if(!IsPlayerLogged(playerid))
    {
        ShowNotification(playerid, 2, "\xd1\xed\xe0\xf7\xe0\xeb\xe0 \xe0\xe2\xf2\xee\xf0\xe8\xe7\xf3\xe9\xf2\xe5\xf1\xfc.", 4, "", "");
        return 1;
    }

    if(!g_CalendarLoaded[playerid]) return CalendarGUI_LoadPlayer(playerid);
    return CalendarGUI_Show(playerid);
}

stock CalendarGUI_Show(playerid)
{
    new current_day = CalendarGUI_GetCurrentDay();
    new Node:root = JSON_Object();

    JSON_SetInt(root, "o", 1);
    JSON_SetInt(root, "t", 1);
    JSON_SetInt(root, "bn", 0);
    JSON_SetInt(root, "i", 0);
    JSON_SetInt(root, "d", CALENDAR_MAX_DAYS - current_day + 1);
    JSON_SetInt(root, "vd", 0);
    JSON_SetInt(root, "tu", CalendarGUI_GetSecondsForNewDay());
    JSON_SetInt(root, "tp", CalendarGUI_GetSecondsForReward(playerid));
    JSON_SetInt(root, "dp", current_day);
    JSON_SetInt(root, "vs", 0);
    JSON_SetInt(root, "pl", CALENDAR_MIN_BONUS_LEVEL);
    JSON_SetInt(root, "lv", GetPlayerData(playerid, P_LEVEL));
    JSON_SetArray(root, "ml", CalendarGUI_BuildMainStatusArray(playerid, false));
    JSON_SetArray(root, "bl", CalendarGUI_BuildBonusStatusArray(playerid, false));
    JSON_SetArray(root, "vml", CalendarGUI_BuildMainStatusArray(playerid, true));
    JSON_SetArray(root, "vbl", CalendarGUI_BuildBonusStatusArray(playerid, true));

    ShowPlayerGUI(playerid, CALENDAR_GUI_ID, root);
    JSON_Cleanup(root);
    g_CalendarOpened[playerid] = true;
    return 1;
}

stock CalendarGUI_SendStatus(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid) || !g_CalendarLoaded[playerid]) return 0;

    new current_day = CalendarGUI_GetCurrentDay();
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "tu", CalendarGUI_GetSecondsForNewDay());
    JSON_SetInt(json, "tp", CalendarGUI_GetSecondsForReward(playerid));
    JSON_SetInt(json, "dp", current_day);
    JSON_SetInt(json, "d", CALENDAR_MAX_DAYS - current_day + 1);
    JSON_SetInt(json, "lv", GetPlayerData(playerid, P_LEVEL));
    JSON_SetArray(json, "ml", CalendarGUI_BuildMainStatusArray(playerid, false));
    JSON_SetArray(json, "bl", CalendarGUI_BuildBonusStatusArray(playerid, false));
    JSON_SetArray(json, "vml", CalendarGUI_BuildMainStatusArray(playerid, true));
    JSON_SetArray(json, "vbl", CalendarGUI_BuildBonusStatusArray(playerid, true));
    SendPacketToClient(playerid, CALENDAR_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

stock CalendarGUI_GetAwardId(day, bool:bonus)
{
    if(day < 1) day = 1;
    if(day > CALENDAR_MAX_DAYS) day = CALENDAR_MAX_DAYS;

    // CaseDailyAwards has 20 entries, GiveRewardsFromGUI expects 1-based award id.
    if(bonus) return (((day + 9) % 20) + 1);
    return (((day - 1) % 20) + 1);
}

stock CalendarGUI_QueueReward(playerid, day, bool:bonus)
{
    new award = CalendarGUI_GetAwardId(day, bonus);
    GiveRewardsFromGUI(playerid, award, CALENDAR_REWARD_CASE_ID);
    ShowNotification(playerid, 1, "\xcd\xe0\xe3\xf0\xe0\xe4\xe0 \xea\xe0\xeb\xe5\xed\xe4\xe0\xf0\xff \xe4\xee\xe1\xe0\xe2\xeb\xe5\xed\xe0 \xe2 /reward.", 5, "", "");
    return 1;
}

stock CalendarGUI_Claim(playerid, day, bool:bonus, bool:come_back)
{
    if(!IsPlayerLogged(playerid)) return 0;
    if(!g_CalendarLoaded[playerid])
    {
        CalendarGUI_LoadPlayer(playerid);
        return 1;
    }

    if(day < 1 || day > CALENDAR_MAX_DAYS)
    {
        ShowNotification(playerid, 2, "\xcd\xe5\xe2\xe5\xf0\xed\xfb\xe9 \xe4\xe5\xed\xfc \xea\xe0\xeb\xe5\xed\xe4\xe0\xf0\xff.", 4, "", "");
        return 1;
    }

    new current_day = CalendarGUI_GetCurrentDay();
    if(day != current_day)
    {
        ShowNotification(playerid, 2, "\xdd\xf2\xe0 \xed\xe0\xe3\xf0\xe0\xe4\xe0 \xf1\xe5\xe3\xee\xe4\xed\xff \xed\xe5\xe4\xee\xf1\xf2\xf3\xef\xed\xe0.", 4, "", "");
        CalendarGUI_SendStatus(playerid);
        return 1;
    }

    if(bonus && GetPlayerData(playerid, P_LEVEL) < CALENDAR_MIN_BONUS_LEVEL)
    {
        ShowNotification(playerid, 2, "\xc2\xe0\xf8 \xf3\xf0\xee\xe2\xe5\xed\xfc \xf1\xeb\xe8\xf8\xea\xee\xec \xed\xe8\xe7\xea\xe8\xe9 \xe4\xeb\xff \xe1\xee\xed\xf3\xf1\xed\xee\xe9 \xed\xe0\xe3\xf0\xe0\xe4\xfb.", 4, "", "");
        return 1;
    }

    if(!come_back)
    {
        if(!bonus)
        {
            if(CalendarGUI_IsClaimed(g_CalendarMainMask[playerid], day))
            {
                ShowNotification(playerid, 2, "\xdd\xf2\xe0 \xed\xe0\xe3\xf0\xe0\xe4\xe0 \xf3\xe6\xe5 \xef\xee\xeb\xf3\xf7\xe5\xed\xe0.", 4, "", "");
                return 1;
            }
            g_CalendarMainMask[playerid] = CalendarGUI_AddClaimBit(g_CalendarMainMask[playerid], day);
        }
        else
        {
            if(CalendarGUI_IsClaimed(g_CalendarBonusMask[playerid], day))
            {
                ShowNotification(playerid, 2, "\xc1\xee\xed\xf3\xf1\xed\xe0\xff \xed\xe0\xe3\xf0\xe0\xe4\xe0 \xf3\xe6\xe5 \xef\xee\xeb\xf3\xf7\xe5\xed\xe0.", 4, "", "");
                return 1;
            }
            g_CalendarBonusMask[playerid] = CalendarGUI_AddClaimBit(g_CalendarBonusMask[playerid], day);
        }
    }
    else
    {
        if(!bonus)
        {
            if(CalendarGUI_IsClaimed(g_CalendarReturnMainMask[playerid], day))
            {
                ShowNotification(playerid, 2, "\xcd\xe0\xe3\xf0\xe0\xe4\xe0 \xe7\xe0 \xe2\xee\xe7\xe2\xf0\xe0\xf9\xe5\xed\xe8\xe5 \xf3\xe6\xe5 \xef\xee\xeb\xf3\xf7\xe5\xed\xe0.", 4, "", "");
                return 1;
            }
            g_CalendarReturnMainMask[playerid] = CalendarGUI_AddClaimBit(g_CalendarReturnMainMask[playerid], day);
        }
        else
        {
            if(CalendarGUI_IsClaimed(g_CalendarReturnBonusMask[playerid], day))
            {
                ShowNotification(playerid, 2, "\xc1\xee\xed\xf3\xf1 \xe7\xe0 \xe2\xee\xe7\xe2\xf0\xe0\xf9\xe5\xed\xe8\xe5 \xf3\xe6\xe5 \xef\xee\xeb\xf3\xf7\xe5\xed.", 4, "", "");
                return 1;
            }
            g_CalendarReturnBonusMask[playerid] = CalendarGUI_AddClaimBit(g_CalendarReturnBonusMask[playerid], day);
        }
    }

    g_CalendarLastClaim[playerid] = gettime();
    CalendarGUI_SavePlayer(playerid);
    CalendarGUI_QueueReward(playerid, day, bonus);
    CalendarGUI_SendStatus(playerid);
    return 1;
}

stock CalendarGUI_ClaimPacket(playerid, reward_id, from_list, bool:come_back)
{
    new day = reward_id + 1; // Android sends preview item position, it is 0-based.
    if(day < 1 || day > CALENDAR_MAX_DAYS) day = reward_id;

    new bool:bonus = false;
    if(from_list == 2) bonus = true;
    return CalendarGUI_Claim(playerid, day, bonus, come_back);
}

stock CalendarGUI_OnPacket(playerid, Node:JSONObject)
{
    new type;
    JSON_GetInt(JSONObject, "t", type);

    switch(type)
    {
        case 1:
        {
            new button;
            JSON_GetInt(JSONObject, "b", button);
            if(button == 1) SendClientMessage(playerid, 0xCECECEFF, "\xc8\xf1\xef\xee\xeb\xfc\xe7\xf3\xe9\xf2\xe5 /blackpass, \xf7\xf2\xee\xe1\xfb \xee\xf2\xea\xf0\xfb\xf2\xfc Black Pass.");
            if(button == 2) g_CalendarOpened[playerid] = false;
        }
        case 2:
        {
            new reward_id, from_list;
            JSON_GetInt(JSONObject, "id", reward_id);
            JSON_GetInt(JSONObject, "l", from_list);
            CalendarGUI_ClaimPacket(playerid, reward_id, from_list, false);
        }
        case 4:
        {
            new reward_id, from_list;
            JSON_GetInt(JSONObject, "id", reward_id);
            JSON_GetInt(JSONObject, "l", from_list);
            CalendarGUI_ClaimPacket(playerid, reward_id, from_list, true);
        }
        default:
        {
            CalendarGUI_SendStatus(playerid);
        }
    }
    return 1;
}

public CalendarGUI_SyncTimer()
{
    foreach(new playerid : Player)
    {
        if(g_CalendarOpened[playerid] && IsPlayerLogged(playerid))
        {
            if(!g_CalendarLoaded[playerid]) CalendarGUI_LoadPlayer(playerid);
            else CalendarGUI_SendStatus(playerid);
        }
    }
    return 1;
}

stock CalendarGUI_ShowDialog(playerid)
{
    new current_day = CalendarGUI_GetCurrentDay();
    new str[512];
    format(str, sizeof(str), "Calendar day: %d/%d\nTime to new day: %d sec\nMain claimed: %s\nBonus claimed: %s\n\nUse /calclaim %d 0 for main reward.\nUse /calclaim %d 1 for bonus reward.\nRewards are added to /reward.",
        current_day,
        CALENDAR_MAX_DAYS,
        CalendarGUI_GetSecondsForNewDay(),
        CalendarGUI_IsClaimed(g_CalendarMainMask[playerid], current_day) ? ("yes") : ("no"),
        CalendarGUI_IsClaimed(g_CalendarBonusMask[playerid], current_day) ? ("yes") : ("no"),
        current_day,
        current_day
    );
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Calendar", str, "OK", "");
    return 1;
}

CMD:calendar(playerid, params[])
{
    return CalendarGUI_Open(playerid);
}

CMD:cal(playerid, params[])
{
    return CalendarGUI_Open(playerid);
}

CMD:daily(playerid, params[])
{
    return CalendarGUI_Open(playerid);
}

CMD:calendarsync(playerid, params[])
{
    if(!g_CalendarLoaded[playerid]) return CalendarGUI_LoadPlayer(playerid);
    CalendarGUI_SendStatus(playerid);
    ShowNotification(playerid, 1, "\xca\xe0\xeb\xe5\xed\xe4\xe0\xf0\xfc \xf1\xe8\xed\xf5\xf0\xee\xed\xe8\xe7\xe8\xf0\xee\xe2\xe0\xed \xf1 \xf1\xe5\xf0\xe2\xe5\xf0\xed\xfb\xec \xe2\xf0\xe5\xec\xe5\xed\xe5\xec.", 4, "", "");
    return 1;
}

CMD:cald(playerid, params[])
{
    if(!g_CalendarLoaded[playerid]) return CalendarGUI_LoadPlayer(playerid);
    return CalendarGUI_ShowDialog(playerid);
}

CMD:calclaim(playerid, params[])
{
    new day, bonus;
    if(sscanf(params, "dD(0)", day, bonus))
        return SendClientMessage(playerid, 0xCECECEFF, "\xc8\xf1\xef\xee\xeb\xfc\xe7\xee\xe2\xe0\xed\xe8\xe5: /calclaim [\xe4\xe5\xed\xfc] [0-\xee\xe1\xfb\xf7\xed\xe0\xff / 1-\xe1\xee\xed\xf3\xf1]");

    return CalendarGUI_Claim(playerid, day, bonus != 0, false);
}

