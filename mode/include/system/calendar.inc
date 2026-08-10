#if defined _daily_calendar_included
    #endinput
#endif
#define _daily_calendar_included

#define DAILY_CALENDAR_GUI_ID                (71)
#define DAILY_CALENDAR_OPEN                  (1)
#define DAILY_CALENDAR_CLAIM                 (2)
#define DAILY_CALENDAR_CLOSE                 (3)
#define DAILY_CALENDAR_UPDATE                (4)
#define DAILY_CALENDAR_MAX_DAYS              (30)
#define DAILY_CALENDAR_COOLDOWN               (86400)
#define DAILY_CALENDAR_REFRESH_MS             (1000)
#define DAILY_CALENDAR_PAYLOAD_SIZE           (8192)
#define DAILY_CALENDAR_CLIENT_PACKET_LIMIT    (4096)
#define DAILY_CALENDAR_TIMER_40_MIN           (2400)
#define DAILY_CALENDAR_ADMIN_LEVEL            (6)
#define DAILY_CALENDAR_BUTTON_HIDDEN          (0)
#define DAILY_CALENDAR_BUTTON_CLAIM           (1)

new g_DailyCalendarLastClaim[MAX_PLAYERS];
new g_DailyCalendarClaimedDays[MAX_PLAYERS];
new bool:g_DailyCalendarLoaded[MAX_PLAYERS];
new bool:g_DailyCalendarGUIOpen[MAX_PLAYERS];
new g_DailyCalendarTimer[MAX_PLAYERS];
new g_DailyCalendarLastTimerValue[MAX_PLAYERS];
new g_DailyCalendarPayload[DAILY_CALENDAR_PAYLOAD_SIZE];
forward DailyCalendar_Tick(playerid);

stock DailyCalendar_CreateTable()
{
    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `summer_drive` (`account_id` INT NOT NULL,`last_claim` INT NOT NULL DEFAULT 0,`claimed_days` INT NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        false
    );
    if(mysql_errno())
    {
        printf("[CALENDAR] table create failed, errno=%d", mysql_errno());
        return 0;
    }
    return 1;
}

stock DailyCalendar_StopTimer(playerid)
{
    if(g_DailyCalendarTimer[playerid])
    {
        KillTimer(g_DailyCalendarTimer[playerid]);
        g_DailyCalendarTimer[playerid] = 0;
    }
    g_DailyCalendarLastTimerValue[playerid] = -1;
    return 1;
}

stock DailyCalendar_StartTimer(playerid)
{
    DailyCalendar_StopTimer(playerid);

    if(!IsPlayerConnected(playerid) || !g_DailyCalendarGUIOpen[playerid])
        return 0;

    new current_day = g_DailyCalendarClaimedDays[playerid] + 1;
    if(current_day > DAILY_CALENDAR_MAX_DAYS)
        return 0;

    if(DailyCalendar_GetSecondsLeft(playerid, current_day) <= 0)
        return 0;

    g_DailyCalendarTimer[playerid] = SetTimerEx("DailyCalendar_Tick", DAILY_CALENDAR_REFRESH_MS, true, "i", playerid);
    return g_DailyCalendarTimer[playerid] != 0;
}

stock DailyCalendar_Reset(playerid)
{
    DailyCalendar_StopTimer(playerid);
    g_DailyCalendarLastClaim[playerid] = 0;
    g_DailyCalendarClaimedDays[playerid] = 0;
    g_DailyCalendarLoaded[playerid] = false;
    g_DailyCalendarGUIOpen[playerid] = false;
    return 1;
}

stock DailyCalendar_Close(playerid, bool:send_packet = true)
{
    g_DailyCalendarGUIOpen[playerid] = false;
    DailyCalendar_StopTimer(playerid);

    if(send_packet && IsPlayerConnected(playerid))
        HidePlayerGUI(playerid, DAILY_CALENDAR_GUI_ID);

    return 1;
}

stock DailyCalendar_Load(playerid)
{
    if(g_DailyCalendarLoaded[playerid]) return 1;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "SELECT `last_claim`,`claimed_days` FROM `summer_drive` WHERE `account_id`=%d LIMIT 1",
        account_id
    );
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[CALENDAR] load failed account=%d errno=%d", account_id, mysql_errno());
        cache_delete(result);
        return 0;
    }

    if(cache_num_rows())
    {
        g_DailyCalendarLastClaim[playerid] = cache_get_row_int(0, 0);
        g_DailyCalendarClaimedDays[playerid] = cache_get_row_int(0, 1);
    }
    else
    {
        mysql_format(mysql, query, sizeof query,
            "INSERT INTO `summer_drive` (`account_id`,`last_claim`,`claimed_days`) VALUES (%d,0,0)",
            account_id
        );
        mysql_query(mysql, query, false);
    }
    cache_delete(result);

    if(g_DailyCalendarClaimedDays[playerid] < 0) g_DailyCalendarClaimedDays[playerid] = 0;
    if(g_DailyCalendarClaimedDays[playerid] > DAILY_CALENDAR_MAX_DAYS) g_DailyCalendarClaimedDays[playerid] = DAILY_CALENDAR_MAX_DAYS;
    if(g_DailyCalendarLastClaim[playerid] < 0) g_DailyCalendarLastClaim[playerid] = 0;

    g_DailyCalendarLoaded[playerid] = true;
    return 1;
}

stock DailyCalendar_Save(playerid)
{
    if(!g_DailyCalendarLoaded[playerid]) return 0;
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[320];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `summer_drive` (`account_id`,`last_claim`,`claimed_days`) VALUES (%d,%d,%d) ON DUPLICATE KEY UPDATE `last_claim`=VALUES(`last_claim`),`claimed_days`=VALUES(`claimed_days`)",
        account_id,
        g_DailyCalendarLastClaim[playerid],
        g_DailyCalendarClaimedDays[playerid]
    );
    mysql_query(mysql, query, false);
    return mysql_errno() == 0;
}

stock DailyCalendar_GetRewardType(day)
{
    if(day == 7) return 3;
    if(day == 14) return 4;
    if(day == 21) return 2;
    if(day == 30) return 5;
    return 1;
}

stock DailyCalendar_GetRewardAmount(day)
{
    if(day == 7) return 1;
    if(day == 14) return 101;
    if(day == 21) return 22;
    if(day == 30) return 5000;
    return day * 1000;
}

stock DailyCalendar_GiveVIP(playerid, days)
{
    new expires = GetPlayerData(playerid, P_PREMIUM_DATE);
    if(expires < gettime()) expires = gettime();
    expires += days * 86400;

    if(GetPlayerData(playerid, P_PREMIUM) < 1)
        SetPlayerData(playerid, P_PREMIUM, 1);
    SetPlayerData(playerid, P_PREMIUM_DATE, expires);
    UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
    UpdatePlayerDatabaseInt(playerid, "premium_date", expires);
    return 1;
}

stock DailyCalendar_GiveReward(playerid, day)
{
    new reward_type = DailyCalendar_GetRewardType(day);
    new amount = DailyCalendar_GetRewardAmount(day);

    switch(reward_type)
    {
        case 1:
        {
            GivePlayerMoneyEx(playerid, amount);
            new message[96];
            format(message, sizeof message, "Вы получили %d рублей.", amount);
            ShowNotificationSander(playerid, 1, 6, 0, 0, message, "");
        }
        case 2:
        {
            new slot = Inventory_GetFreeSlot(playerid);
            if(slot == -1) return 0;
            if(!Inventory_AddItem(playerid, amount, slot, 1, "")) return 0;
            ShowNotificationSander(playerid, 1, 6, 0, 0, "Вы получили предмет: бинты.", "");
        }
        case 3:
        {
            DailyCalendar_GiveVIP(playerid, amount);
            ShowNotificationSander(playerid, 1, 6, 0, 0, "Вы получили VIP на 1 день.", "");
        }
        case 4:
        {
            new slot = Inventory_GetFreeSlot(playerid);
            if(slot == -1) return 0;
            if(!Inventory_AddItem(playerid, 134, slot, amount, "")) return 0;
            ShowNotificationSander(playerid, 1, 6, 0, 0, "Вы получили новый скин в инвентарь.", "");
        }
        case 5:
        {
            AddPlayerData(playerid, P_EXP, +, amount);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
            new message[96];
            format(message, sizeof message, "Вы получили %d единиц опыта.", amount);
            ShowNotificationSander(playerid, 1, 6, 0, 0, message, "");
        }
    }
    return 1;
}

stock DailyCalendar_GetSecondsLeft(playerid, day)
{
    if(day <= g_DailyCalendarClaimedDays[playerid]) return 0;

    new current_day = g_DailyCalendarClaimedDays[playerid] + 1;
    if(current_day > DAILY_CALENDAR_MAX_DAYS || day < current_day) return 0;

    new current_left = g_DailyCalendarLastClaim[playerid] + DAILY_CALENDAR_COOLDOWN - gettime();
    if(current_left < 0) current_left = 0;

    return current_left + ((day - current_day) * DAILY_CALENDAR_COOLDOWN);
}

stock DailyCalendar_FormatCountdown(seconds, output[], output_size)
{
    if(seconds < 0) seconds = 0;

    new days = seconds / 86400;
    new hours = (seconds % 86400) / 3600;
    new minutes = (seconds % 3600) / 60;
    new secs = seconds % 60;

    if(days > 0)
        format(output, output_size, "%02d:%02d:%02d:%02d", days, hours, minutes, secs);
    else
        format(output, output_size, "%02d:%02d:%02d", hours, minutes, secs);

    return 1;
}

stock DailyCalendar_SendString(playerid, const payload[])
{
    new payload_length = strlen(payload);
    if(payload_length <= 0 || payload_length >= DAILY_CALENDAR_CLIENT_PACKET_LIMIT)
    {
        printf("[CALENDAR] invalid GUI payload player=%d length=%d limit=%d", playerid, payload_length, DAILY_CALENDAR_CLIENT_PACKET_LIMIT);
        return 0;
    }

    SendPacketToClientString(playerid, DAILY_CALENDAR_GUI_ID, payload);
    return 1;
}

stock DailyCalendar_SendAck(playerid, action, success, day = 0)
{
    if(!g_DailyCalendarGUIOpen[playerid]) return 0;

    new payload[256];
    format(payload, sizeof payload,
        "{\"t\":%d,\"ty\":%d,\"s\":%d,\"day\":%d,\"d\":%d,\"id\":%d,\"can_claim\":0,\"available\":0,\"show_button\":0,\"claim_button\":0}",
        action,
        action,
        success,
        day,
        day,
        day
    );
    return DailyCalendar_SendString(playerid, payload);
}

stock DailyCalendar_SendState(playerid, bool:open_gui = false)
{
    if(!DailyCalendar_Load(playerid))
    {
        ShowNotificationSander(playerid, 2, 6, 0, 0, "Календарь временно недоступен.", "");
        return 0;
    }

    new current_day = g_DailyCalendarClaimedDays[playerid] + 1;
    new active_seconds = 0;
    new can_claim = 0;
    new show_timer = 0;
    new over_40_min = 0;
    new active_counter[16];
    format(active_counter, sizeof active_counter, "00:00:00");

    if(current_day <= DAILY_CALENDAR_MAX_DAYS)
    {
        active_seconds = DailyCalendar_GetSecondsLeft(playerid, current_day);
        can_claim = (active_seconds <= 0);
        show_timer = (active_seconds > 0);
        over_40_min = (active_seconds > DAILY_CALENDAR_TIMER_40_MIN);
        DailyCalendar_FormatCountdown(active_seconds, active_counter, sizeof active_counter);
    }

    format(g_DailyCalendarPayload, sizeof g_DailyCalendarPayload, "{\"t\":1,\"s\":1,\"days\":[");

    new item[768];
    for(new day = 1; day <= DAILY_CALENDAR_MAX_DAYS; day++)
    {
        if(day > 1) strcat(g_DailyCalendarPayload, ",", sizeof g_DailyCalendarPayload);

        if(day == current_day && day <= DAILY_CALENDAR_MAX_DAYS)
        {
            format(item, sizeof item,
                "{\"day\":%d,\"id\":%d,\"claimed\":0,\"can_claim\":%d,\"available\":%d,\"is\":%d,\"reward_type\":%d,\"reward_amount\":%d,\"counter\":\"%s\",\"timer\":%d,\"time\":%d,\"show_timer\":%d,\"timer_on_gift\":%d,\"over_40_min\":%d,\"show_button\":%d,\"button\":%d,\"claim_button\":%d,\"button_type\":%d,\"action\":%d,\"ty\":%d}",
                day,
                day,
                can_claim,
                can_claim,
                can_claim,
                DailyCalendar_GetRewardType(day),
                DailyCalendar_GetRewardAmount(day),
                active_counter,
                active_seconds,
                active_seconds,
                show_timer,
                show_timer,
                over_40_min,
                can_claim,
                can_claim ? DAILY_CALENDAR_BUTTON_CLAIM : DAILY_CALENDAR_BUTTON_HIDDEN,
                can_claim,
                DAILY_CALENDAR_CLAIM,
                DAILY_CALENDAR_CLAIM,
                DAILY_CALENDAR_CLAIM
            );
        }
        else
        {
            format(item, sizeof item,
                "{\"day\":%d,\"claimed\":%d,\"can_claim\":0,\"reward_type\":%d,\"reward_amount\":%d}",
                day,
                (day <= g_DailyCalendarClaimedDays[playerid]),
                DailyCalendar_GetRewardType(day),
                DailyCalendar_GetRewardAmount(day)
            );
        }
        strcat(g_DailyCalendarPayload, item, sizeof g_DailyCalendarPayload);
    }

    format(item, sizeof item,
        "],\"progress\":%d,\"max\":%d,\"active_day\":%d,\"claim_day\":%d,\"seconds_left\":%d,\"counter\":\"%s\",\"show_timer\":%d,\"timer_on_gift\":%d,\"over_40_min\":%d,\"can_claim\":%d,\"available\":%d,\"is\":%d,\"show_button\":%d,\"button\":%d,\"claim_button\":%d,\"button_type\":%d,\"action\":%d,\"ty\":%d%s}",
        g_DailyCalendarClaimedDays[playerid],
        DAILY_CALENDAR_MAX_DAYS,
        (current_day <= DAILY_CALENDAR_MAX_DAYS) ? current_day : 0,
        can_claim ? current_day : 0,
        active_seconds,
        active_counter,
        show_timer,
        show_timer,
        over_40_min,
        can_claim,
        can_claim,
        can_claim,
        can_claim,
        can_claim ? DAILY_CALENDAR_BUTTON_CLAIM : DAILY_CALENDAR_BUTTON_HIDDEN,
        can_claim,
        DAILY_CALENDAR_CLAIM,
        DAILY_CALENDAR_CLAIM,
        DAILY_CALENDAR_CLAIM,
        open_gui ? ",\"o\":1" : ""
    );
    strcat(g_DailyCalendarPayload, item, sizeof g_DailyCalendarPayload);

    new payload_length = strlen(g_DailyCalendarPayload);
    if(payload_length <= 0 || payload_length >= DAILY_CALENDAR_CLIENT_PACKET_LIMIT)
    {
        printf("[CALENDAR] GUI state overflow player=%d length=%d limit=%d", playerid, payload_length, DAILY_CALENDAR_CLIENT_PACKET_LIMIT);
        return 0;
    }

    if(open_gui)
    {
        printf("[CALENDAR] gui open fix=12 player=%d gui=%d length=%d progress=%d active_day=%d timer=%d over40=%d",
            playerid,
            DAILY_CALENDAR_GUI_ID,
            payload_length,
            g_DailyCalendarClaimedDays[playerid],
            (current_day <= DAILY_CALENDAR_MAX_DAYS) ? current_day : 0,
            active_seconds,
            over_40_min
        );
    }

    g_DailyCalendarLastTimerValue[playerid] = active_seconds;
    return DailyCalendar_SendString(playerid, g_DailyCalendarPayload);
}

stock DailyCalendar_Open(playerid)
{
    if(!DailyCalendar_Load(playerid))
    {
        ShowNotificationSander(playerid, 2, 6, 0, 0, "Календарь временно недоступен.", "");
        return 0;
    }

    DailyCalendar_StopTimer(playerid);
    g_DailyCalendarGUIOpen[playerid] = true;

    if(!DailyCalendar_SendState(playerid, true))
    {
        g_DailyCalendarGUIOpen[playerid] = false;
        return 0;
    }

    DailyCalendar_StartTimer(playerid);
    return 1;
}

public DailyCalendar_Tick(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_DailyCalendarGUIOpen[playerid])
    {
        DailyCalendar_StopTimer(playerid);
        return 0;
    }

    new current_day = g_DailyCalendarClaimedDays[playerid] + 1;
    if(current_day > DAILY_CALENDAR_MAX_DAYS)
    {
        DailyCalendar_StopTimer(playerid);
        return 0;
    }

    new seconds_left = DailyCalendar_GetSecondsLeft(playerid, current_day);
    if(seconds_left == g_DailyCalendarLastTimerValue[playerid])
        return 1;

    DailyCalendar_SendState(playerid, false);

    if(seconds_left <= 0)
        DailyCalendar_StopTimer(playerid);

    return 1;
}

stock DailyCalendar_HandlePacket(playerid, Node:json)
{
    new close_value = 0;
    JSON_GetInt(json, "c", close_value);
    if(close_value == 1)
        return DailyCalendar_Close(playerid, false);

    new action = -1;
    JSON_GetInt(json, "t", action);

    new action_alias = -1;
    JSON_GetInt(json, "ty", action_alias);
    if(action < 0 && action_alias >= 0) action = action_alias;
    if(action < 0) JSON_GetInt(json, "action", action);
    if(action < 0) JSON_GetInt(json, "button_type", action);

    if(action == DAILY_CALENDAR_CLOSE)
        return DailyCalendar_Close(playerid, false);

    new requested_day = 0;
    JSON_GetInt(json, "day", requested_day);
    if(requested_day <= 0) JSON_GetInt(json, "d", requested_day);
    if(requested_day <= 0) JSON_GetInt(json, "id", requested_day);
    if(requested_day <= 0) JSON_GetInt(json, "claim_day", requested_day);
    if(requested_day <= 0) JSON_GetInt(json, "reward_id", requested_day);
    if(requested_day <= 0) JSON_GetInt(json, "level", requested_day);

    new claim_signal = 0;
    JSON_GetInt(json, "claim", claim_signal);
    if(!claim_signal) JSON_GetInt(json, "get", claim_signal);
    if(!claim_signal) JSON_GetInt(json, "receive", claim_signal);
    if(!claim_signal) JSON_GetInt(json, "claim_button", claim_signal);

    // GUI 71 builds differ between client revisions. Some send t=2/day,
    // some send ty=2/id, and some send only the selected gift id.
    if(action == DAILY_CALENDAR_CLAIM || action_alias == DAILY_CALENDAR_CLAIM || claim_signal == 1)
        action = DAILY_CALENDAR_CLAIM;
    else if(action < 0 && requested_day > 0)
        action = DAILY_CALENDAR_CLAIM;

    if(action == DAILY_CALENDAR_OPEN || action == DAILY_CALENDAR_UPDATE)
    {
        if(!g_DailyCalendarGUIOpen[playerid]) return 1;
        return DailyCalendar_SendState(playerid, false);
    }

    if(action != DAILY_CALENDAR_CLAIM)
        return DailyCalendar_SendAck(playerid, action, 0, requested_day);

    if(!g_DailyCalendarGUIOpen[playerid] || !DailyCalendar_Load(playerid))
        return 1;

    new current_day = g_DailyCalendarClaimedDays[playerid] + 1;
    if(requested_day <= 0) requested_day = current_day;

    if(g_DailyCalendarClaimedDays[playerid] >= DAILY_CALENDAR_MAX_DAYS || requested_day != current_day)
        return DailyCalendar_SendAck(playerid, action, 0, requested_day);

    new seconds_left = DailyCalendar_GetSecondsLeft(playerid, current_day);
    if(seconds_left > 0)
    {
        new message[128], countdown[16];
        DailyCalendar_FormatCountdown(seconds_left, countdown, sizeof countdown);
        format(message, sizeof message, "До следующей награды осталось %s.", countdown);
        ShowNotificationSander(playerid, 2, 6, 0, 0, message, "");
        return DailyCalendar_SendAck(playerid, action, 0, requested_day);
    }

    new reward_type = DailyCalendar_GetRewardType(current_day);
    if((reward_type == 2 || reward_type == 4) && Inventory_GetFreeSlot(playerid) == -1)
    {
        ShowNotificationSander(playerid, 2, 6, 0, 0, "Освободите место в инвентаре.", "");
        return DailyCalendar_SendAck(playerid, action, 0, requested_day);
    }

    if(!DailyCalendar_GiveReward(playerid, current_day))
        return DailyCalendar_SendAck(playerid, action, 0, requested_day);

    g_DailyCalendarLastClaim[playerid] = gettime();
    g_DailyCalendarClaimedDays[playerid]++;
    if(!DailyCalendar_Save(playerid))
        printf("[CALENDAR] claim persistence failed account=%d day=%d", GetPlayerAccountID(playerid), current_day);

    printf("[CALENDAR] claim player=%d day=%d progress=%d", playerid, current_day, g_DailyCalendarClaimedDays[playerid]);
    DailyCalendar_SendAck(playerid, action, 1, requested_day);
    DailyCalendar_SendState(playerid, false);
    DailyCalendar_StartTimer(playerid);
    return 1;
}

stock DailyCalendar_AdminSetLevel(adminid, targetid, level, bool:add_levels)
{
    if(GetPlayerAdminEx(adminid) < DAILY_CALENDAR_ADMIN_LEVEL)
    {
        SendClientMessage(adminid, 0xFF5533FF, "Команда доступна администраторам 6 уровня и выше.");
        return 0;
    }

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
    {
        SendClientMessage(adminid, 0x999999FF, "Игрок не найден или не авторизован.");
        return 0;
    }

    if(level < 0 || level > DAILY_CALENDAR_MAX_DAYS)
    {
        SendClientMessage(adminid, 0x999999FF, "Уровень календаря должен быть от 0 до 30.");
        return 0;
    }

    if(!DailyCalendar_Load(targetid))
    {
        SendClientMessage(adminid, 0xFF5533FF, "Не удалось загрузить календарь игрока.");
        return 0;
    }

    new old_level = g_DailyCalendarClaimedDays[targetid];
    new new_level = level;

    if(add_levels)
    {
        new_level = old_level + level;
        if(new_level > DAILY_CALENDAR_MAX_DAYS) new_level = DAILY_CALENDAR_MAX_DAYS;
    }

    g_DailyCalendarClaimedDays[targetid] = new_level;

    // The next gift is immediately available after an admin changes progress.
    // At level 30 the calendar is complete and has no active timer.
    g_DailyCalendarLastClaim[targetid] = 0;

    if(!DailyCalendar_Save(targetid))
    {
        SendClientMessage(adminid, 0xFF5533FF, "Не удалось сохранить уровень календаря.");
        return 0;
    }

    if(g_DailyCalendarGUIOpen[targetid])
    {
        DailyCalendar_SendState(targetid, false);
        DailyCalendar_StartTimer(targetid);
    }

    new text[192];
    format(text, sizeof text, "Вы установили игроку %s[%d] уровень календаря: %d (было %d).", GetPlayerNameEx(targetid), targetid, new_level, old_level);
    SendClientMessage(adminid, 0x66CC00FF, text);

    format(text, sizeof text, "Администратор %s[%d] установил вам уровень календаря: %d.", GetPlayerNameEx(adminid), adminid, new_level);
    SendClientMessage(targetid, 0x3399FFFF, text);

    format(text, sizeof text, "[A] %s[%d] изменил %s[%d] уровень календаря с %d на %d", GetPlayerNameEx(adminid), adminid, GetPlayerNameEx(targetid), targetid, old_level, new_level);
    SendMessageToAdmins(text, 0x999999FF);

    format(text, sizeof text, "Изменил %s[acc:%d] уровень календаря с %d на %d", GetPlayerNameEx(targetid), GetPlayerAccountID(targetid), old_level, new_level);
    SendLog(adminid, LOG_TYPE_ADMIN_ACTION, text);

    printf("[CALENDAR] admin=%d target=%d old=%d new=%d add=%d", adminid, targetid, old_level, new_level, add_levels);
    return 1;
}

CMD:calendar(playerid, params[])
{
    #pragma unused params
    return DailyCalendar_Open(playerid);
}

CMD:setcallevel(playerid, params[])
{
    extract params -> new targetid, level; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setcallevel [id] [уровень 0-30]");
    return DailyCalendar_AdminSetLevel(playerid, targetid, level, false);
}

CMD:givecallevel(playerid, params[])
{
    extract params -> new targetid, levels; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecallevel [id] [количество 0-30]");
    return DailyCalendar_AdminSetLevel(playerid, targetid, levels, true);
}
