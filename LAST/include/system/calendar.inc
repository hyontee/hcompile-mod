#if defined _BR_CALENDAR_INC_
    #endinput
#endif
#define _BR_CALENDAR_INC_

forward bool:Calendar_NeedsPlaytimeSession(playerid);
forward bool:Calendar_IsClaimed(playerid, list_type, day_id);

// =============================================================================
//  Календарь наград BR (GUI 71) — данные с api.blackrussia.online/client/calendar.json
//  Все призы уходят в таблицу `rewards` (case_id = CAL_REWARDS_CASE_ID), забор через /reward
// =============================================================================

#define CAL_GUI_ID                    (71)
#define CAL_REWARDS_CASE_ID           (71)
#define CAL_COOLDOWN_SECONDS          (1800)
#define CAL_SEASON_DAYS               (49)
#define CAL_RETURN_DAYS               (21)
#define CAL_MAIN_SLOTS                (21)
#define CAL_BONUS_SLOTS               (5)
#define CAL_RETURN_MAIN_SLOTS         (7)
#define CAL_RETURN_BONUS_SLOTS        (3)
#define CAL_MIN_EPIC_LEVEL            (3)
#define CAL_RETURN_OFFLINE_SEC        (604800)

#define CAL_LIST_SEASON_MAIN          (0)
#define CAL_LIST_SEASON_BONUS         (1)
#define CAL_LIST_RETURN_MAIN          (2)
#define CAL_LIST_RETURN_BONUS         (3)

#define CAL_FLAG_TUTORIAL_DONE        (1)
#define CAL_FLAG_BP_BANNER_DONE       (2)
#define CAL_FLAG_RETURN_ACTIVE        (4)
#define CAL_FLAG_TIMER_STARTED        (8)
#define CAL_FLAG_TIMER_READY          (16)

#define CAL_PLAYTIME_TICK_MS          (1000)

enum E_CAL_AWARD
{
    calType,
    calInternal,
    calCount,
    calSubCount,
    calSpray,
    calEpic,
    calName[48]
};

enum E_CAL_PLAYER
{
    bool:calLoaded,
    calMainDay,
    calReturnDay,
    calLastDayStamp,
    calPlaySecondsLeft,
    calLastLogin,
    calFlags,
    calMainClaimed[CAL_MAIN_SLOTS],
    calBonusClaimed[CAL_BONUS_SLOTS],
    calRetMainClaimed[CAL_RETURN_MAIN_SLOTS],
    calRetBonusClaimed[CAL_RETURN_BONUS_SLOTS]
};

new CalPlayer[MAX_PLAYERS][E_CAL_PLAYER];

// Индексы наград в CalendarAwards (совпадают с award_id в `rewards`)
#define CAL_A_MAIN_1   (0)
#define CAL_A_MAIN_2   (1)
#define CAL_A_MAIN_3   (2)
#define CAL_A_MAIN_4   (3)
#define CAL_A_MAIN_5   (4)
#define CAL_A_MAIN_6   (5)
#define CAL_A_MAIN_7   (6)
#define CAL_A_MAIN_8   (7)
#define CAL_A_MAIN_9   (8)
#define CAL_A_MAIN_10  (9)
#define CAL_A_MAIN_11  (10)
#define CAL_A_MAIN_12  (11)
#define CAL_A_MAIN_13  (12)
#define CAL_A_MAIN_14  (13)
#define CAL_A_MAIN_15  (14)
#define CAL_A_MAIN_16  (15)
#define CAL_A_MAIN_17  (16)
#define CAL_A_MAIN_18  (17)
#define CAL_A_MAIN_19  (18)
#define CAL_A_MAIN_20  (19)
#define CAL_A_MAIN_21  (20)
#define CAL_A_BONUS_5  (21)
#define CAL_A_BONUS_10 (22)
#define CAL_A_BONUS_15 (23)
#define CAL_A_BONUS_20 (24)
#define CAL_A_BONUS_25 (25)
#define CAL_A_RET1     (26)
#define CAL_A_RET2     (27)
#define CAL_A_RET3     (28)
#define CAL_A_RET4     (29)
#define CAL_A_RET5     (30)
#define CAL_A_RET6     (31)
#define CAL_A_RBONUS_2 (32)
#define CAL_A_RBONUS_4 (33)
#define CAL_A_RBONUS_7 (34)
#define CAL_AWARDS_TOTAL (35)

static const CalendarAwards[CAL_AWARDS_TOTAL][E_CAL_AWARD] =
{
    {9, 2, 4, 0, 0, 0, "VIP GOLD"},
    {3, 0, 10, 0, 0, 0, "10 BC"},
    {10, 0, 1000, 0, 0, 0, "1000 BP EXP"},
    {5, 507, 12, 0, 0, 0, "AUDI A4 12ч."},
    {8, 0, 24, 0, 0, 0, "X2 КУПОН 24ч."},
    {2, 0, 10000, 0, 0, 0, "10000 руб."},
    {11, 134, 5500029, 0, 0, 1, "ЛИХАЧ"},
    {9, 1, 4, 0, 0, 0, "VIP SILVER"},
    {3, 0, 10, 0, 0, 0, "10 BC"},
    {10, 0, 1000, 0, 0, 0, "1000 BP EXP"},
    {5, 550, 12, 0, 0, 0, "CAMRY 12ч."},
    {1, 0, 5, 0, 0, 0, "5 EXP"},
    {2, 0, 10000, 0, 0, 0, "10000 руб."},
    {11, 1004, 1, 0, 0, 1, "ОЧКИ СЛАЙДЛИНЗЫ"},
    {9, 1, 4, 0, 0, 0, "VIP SILVER"},
    {3, 0, 15, 0, 0, 0, "15 BC"},
    {10, 0, 1500, 0, 0, 0, "1500 BP EXP"},
    {5, 2584, 12, 0, 0, 0, "KIA K5 12ч."},
    {1, 0, 7, 0, 0, 0, "7 EXP"},
    {2, 0, 15000, 0, 0, 0, "15000 руб."},
    {5, 759, 0, 112, 0, 1, "Chase V100"},
    {4, 2, 1, 0, 0, 0, "КЕЙС БОМЖА"},
    {4, 2, 1, 0, 0, 0, "КЕЙС БОМЖА"},
    {4, 2, 1, 0, 0, 0, "КЕЙС БОМЖА"},
    {4, 2, 2, 0, 0, 0, "КЕЙС БОМЖА X2"},
    {4, 3, 1, 0, 0, 0, "СТАНДАРТНЫЙ КЕЙС"},
    {25, 1, 168, 0, 0, 0, "ПРАВА B 7Д"},
    {2, 0, 10000, 0, 0, 0, "10000 руб."},
    {10, 0, 2000, 0, 0, 0, "2000 BP EXP"},
    {3, 0, 25, 0, 0, 0, "25 BC"},
    {2, 0, 20000, 0, 0, 0, "20000 руб."},
    {4, 1, 2, 0, 0, 0, "ЕЖЕДНЕВНЫЙ X2"},
    {4, 1, 1, 0, 0, 0, "ЕЖЕДНЕВНЫЙ"},
    {4, 2, 1, 0, 0, 0, "КЕЙС БОМЖА"},
    {4, 2, 2, 0, 0, 0, "КЕЙС БОМЖА X2"}
};

static const CalMainDayAward[CAL_MAIN_SLOTS] =
{
    CAL_A_MAIN_1, CAL_A_MAIN_2, CAL_A_MAIN_3, CAL_A_MAIN_4, CAL_A_MAIN_5,
    CAL_A_MAIN_6, CAL_A_MAIN_7, CAL_A_MAIN_8, CAL_A_MAIN_9, CAL_A_MAIN_10,
    CAL_A_MAIN_11, CAL_A_MAIN_12, CAL_A_MAIN_13, CAL_A_MAIN_14, CAL_A_MAIN_15,
    CAL_A_MAIN_16, CAL_A_MAIN_17, CAL_A_MAIN_18, CAL_A_MAIN_19, CAL_A_MAIN_20,
    CAL_A_MAIN_21
};

static const CalBonusDayId[CAL_BONUS_SLOTS] = {5, 10, 15, 20, 25};
static const CalBonusDayAward[CAL_BONUS_SLOTS] =
{
    CAL_A_BONUS_5, CAL_A_BONUS_10, CAL_A_BONUS_15, CAL_A_BONUS_20, CAL_A_BONUS_25
};

static const CalReturnMainAward[CAL_RETURN_MAIN_SLOTS] =
{
    CAL_A_RET1, CAL_A_RET2, CAL_A_RET3, CAL_A_RET4, CAL_A_RET5, CAL_A_RET6, (-1)
};

static const CalReturnBonusDayId[CAL_RETURN_BONUS_SLOTS] = {2, 4, 7};
static const CalReturnBonusAward[CAL_RETURN_BONUS_SLOTS] =
{
    CAL_A_RBONUS_2, CAL_A_RBONUS_4, CAL_A_RBONUS_7
};

// --- вспомогательные ---

stock Calendar_ResetPlayer(playerid)
{
    CalPlayer[playerid][calLoaded] = false;
    CalPlayer[playerid][calMainDay] = 1;
    CalPlayer[playerid][calReturnDay] = 1;
    CalPlayer[playerid][calLastDayStamp] = 0;
    CalPlayer[playerid][calPlaySecondsLeft] = 0;
    CalPlayer[playerid][calLastLogin] = 0;
    CalPlayer[playerid][calFlags] = 0;

    for(new i = 0; i < CAL_MAIN_SLOTS; i++) CalPlayer[playerid][calMainClaimed][i] = 0;
    for(new i = 0; i < CAL_BONUS_SLOTS; i++) CalPlayer[playerid][calBonusClaimed][i] = 0;
    for(new i = 0; i < CAL_RETURN_MAIN_SLOTS; i++) CalPlayer[playerid][calRetMainClaimed][i] = 0;
    for(new i = 0; i < CAL_RETURN_BONUS_SLOTS; i++) CalPlayer[playerid][calRetBonusClaimed][i] = 0;
    return 1;
}

stock Calendar_GetDayStamp()
{
    return floatround(float(gettime()) / 86400.0, floatround_floor);
}

stock Calendar_SecondsUntilMidnight()
{
    new h, m, s;
    gettime(h, m, s);
    return (86400 - ((h * 3600) + (m * 60) + s));
}

stock Calendar_FormatPlaytime(sec, dest[], len)
{
    if(sec < 0) sec = 0;
    new m = sec / 60;
    new s = sec % 60;
    format(dest, len, "%d мин. %d сек.", m, s);
    return 1;
}

stock bool:Calendar_IsPlaytimeReady(playerid)
{
    if(CalPlayer[playerid][calFlags] & CAL_FLAG_TIMER_READY) return true;
    if((CalPlayer[playerid][calFlags] & CAL_FLAG_TIMER_STARTED) && CalPlayer[playerid][calPlaySecondsLeft] <= 0)
        return true;
    return false;
}

stock bool:Calendar_IsPlaytimeRunning(playerid)
{
    return (CalPlayer[playerid][calFlags] & CAL_FLAG_TIMER_STARTED) != 0
        && CalPlayer[playerid][calPlaySecondsLeft] > 0;
}

stock bool:Calendar_PlaytimeRequiredForDay(playerid, list_type, day_id)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN: return (day_id == CalPlayer[playerid][calMainDay]);
        case CAL_LIST_RETURN_MAIN: return (day_id == CalPlayer[playerid][calReturnDay]);
    }
    return false;
}

stock bool:Calendar_IsSeasonFullyComplete(playerid)
{
    for(new i = 1; i <= CAL_MAIN_SLOTS; i++)
    {
        if(!Calendar_IsClaimed(playerid, CAL_LIST_SEASON_MAIN, i))
            return false;
    }
    return true;
}

stock Calendar_GetClientTimerSeconds(playerid)
{
    if(Calendar_IsSeasonFullyComplete(playerid))
        return -1;

    if(Calendar_IsPlaytimeRunning(playerid))
        return CalPlayer[playerid][calPlaySecondsLeft];

    if(Calendar_IsPlaytimeReady(playerid))
        return 0;

    if(Calendar_NeedsPlaytimeSession(playerid))
    {
        if(CalPlayer[playerid][calFlags] & CAL_FLAG_TIMER_STARTED)
            return CalPlayer[playerid][calPlaySecondsLeft];
        return 0;
    }
    return -1;
}

stock Calendar_SetGuiOpen(playerid, bool:open)
{
    if(open) SetPVarInt(playerid, "cal_gui_open", 1);
    else DeletePVar(playerid, "cal_gui_open");
    return 1;
}

stock bool:Calendar_IsGuiOpen(playerid)
{
    return GetPVarInt(playerid, "cal_gui_open") != 0;
}

stock Calendar_NotifyPlaytimeReady(playerid)
{
    ShowNotification(playerid, 1, 5, 1, 0,
        "Вы отыграли нужное время! Откройте календарь и заберите награду.",
        "Календарь");
    return 1;
}

stock bool:Calendar_NeedsPlaytimeSession(playerid)
{
    if(!Calendar_IsClaimed(playerid, CAL_LIST_SEASON_MAIN, CalPlayer[playerid][calMainDay]))
        return true;
    if(Calendar_IsReturnPlayer(playerid)
        && !Calendar_IsClaimed(playerid, CAL_LIST_RETURN_MAIN, CalPlayer[playerid][calReturnDay]))
        return true;
    return false;
}

stock Calendar_StartPlaytimeTimer(playerid)
{
    if(!CalPlayer[playerid][calLoaded] || Player[playerid][pID] <= 0) return 0;
    if(Calendar_IsPlaytimeReady(playerid)) return 1;
    if(!Calendar_NeedsPlaytimeSession(playerid)) return 0;

    if(CalPlayer[playerid][calFlags] & CAL_FLAG_TIMER_STARTED) return 1;

    CalPlayer[playerid][calFlags] |= CAL_FLAG_TIMER_STARTED;
    CalPlayer[playerid][calFlags] &= ~CAL_FLAG_TIMER_READY;
    if(CalPlayer[playerid][calPlaySecondsLeft] <= 0)
        CalPlayer[playerid][calPlaySecondsLeft] = CAL_COOLDOWN_SECONDS;

    new tbuf[48], msg[128];
    Calendar_FormatPlaytime(CalPlayer[playerid][calPlaySecondsLeft], tbuf, sizeof(tbuf));
    format(msg, sizeof(msg), "{E0584B}[КАЛЕНДАРЬ]{FFFFFF} До награды осталось: %s (только время в игре).", tbuf);
    SendClientMessage(playerid, COLOR_WHITE, msg);
    Calendar_Save(playerid);
    return 1;
}

stock Calendar_ResetPlaytimeForNewDay(playerid)
{
    CalPlayer[playerid][calPlaySecondsLeft] = CAL_COOLDOWN_SECONDS;
    CalPlayer[playerid][calFlags] &= ~(CAL_FLAG_TIMER_STARTED | CAL_FLAG_TIMER_READY);
    return 1;
}

forward Calendar_PlaytimeTick();
public Calendar_PlaytimeTick()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!CalPlayer[i][calLoaded] || Player[i][pID] <= 0) continue;
        if(!Calendar_IsPlaytimeRunning(i)) continue;

        CalPlayer[i][calPlaySecondsLeft]--;
        if(CalPlayer[i][calPlaySecondsLeft] > 0) continue;

        CalPlayer[i][calPlaySecondsLeft] = 0;
        CalPlayer[i][calFlags] |= CAL_FLAG_TIMER_READY;
        Calendar_NotifyPlaytimeReady(i);
        Calendar_Save(i);

        if(Calendar_IsGuiOpen(i))
        {
            Calendar_SendUpdate(i, 1);
            Calendar_SendOpenJson(i);
        }
    }
    return 1;
}

stock Calendar_OnGameModeInit()
{
    SetTimer("Calendar_PlaytimeTick", CAL_PLAYTIME_TICK_MS, true);
    return 1;
}

stock Calendar_IsReturnPlayer(playerid)
{
    if(CalPlayer[playerid][calFlags] & CAL_FLAG_RETURN_ACTIVE) return 1;
    if(CalPlayer[playerid][calLastLogin] <= 0) return 0;
    return (gettime() - CalPlayer[playerid][calLastLogin] >= CAL_RETURN_OFFLINE_SEC);
}

stock Calendar_GetAwardIndex(list_type, day_id)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN:
        {
            if(day_id < 1 || day_id > CAL_MAIN_SLOTS) return -1;
            return CalMainDayAward[day_id - 1];
        }
        case CAL_LIST_SEASON_BONUS:
        {
            for(new i = 0; i < CAL_BONUS_SLOTS; i++)
            {
                if(CalBonusDayId[i] == day_id) return CalBonusDayAward[i];
            }
        }
        case CAL_LIST_RETURN_MAIN:
        {
            if(day_id < 1 || day_id > CAL_RETURN_MAIN_SLOTS) return -1;
            return CalReturnMainAward[day_id - 1];
        }
        case CAL_LIST_RETURN_BONUS:
        {
            for(new i = 0; i < CAL_RETURN_BONUS_SLOTS; i++)
            {
                if(CalReturnBonusDayId[i] == day_id) return CalReturnBonusAward[i];
            }
        }
    }
    return -1;
}

stock bool:Calendar_IsClaimed(playerid, list_type, day_id)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN:
        {
            if(day_id < 1 || day_id > CAL_MAIN_SLOTS) return true;
            return CalPlayer[playerid][calMainClaimed][day_id - 1] != 0;
        }
        case CAL_LIST_SEASON_BONUS:
        {
            for(new i = 0; i < CAL_BONUS_SLOTS; i++)
            {
                if(CalBonusDayId[i] == day_id) return CalPlayer[playerid][calBonusClaimed][i] != 0;
            }
        }
        case CAL_LIST_RETURN_MAIN:
        {
            if(day_id < 1 || day_id > CAL_RETURN_MAIN_SLOTS) return true;
            return CalPlayer[playerid][calRetMainClaimed][day_id - 1] != 0;
        }
        case CAL_LIST_RETURN_BONUS:
        {
            for(new i = 0; i < CAL_RETURN_BONUS_SLOTS; i++)
            {
                if(CalReturnBonusDayId[i] == day_id) return CalPlayer[playerid][calRetBonusClaimed][i] != 0;
            }
        }
    }
    return true;
}

stock Calendar_SetClaimed(playerid, list_type, day_id)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN:
        {
            if(day_id >= 1 && day_id <= CAL_MAIN_SLOTS)
                CalPlayer[playerid][calMainClaimed][day_id - 1] = 1;
        }
        case CAL_LIST_SEASON_BONUS:
        {
            for(new i = 0; i < CAL_BONUS_SLOTS; i++)
            {
                if(CalBonusDayId[i] == day_id) CalPlayer[playerid][calBonusClaimed][i] = 1;
            }
        }
        case CAL_LIST_RETURN_MAIN:
        {
            if(day_id >= 1 && day_id <= CAL_RETURN_MAIN_SLOTS)
                CalPlayer[playerid][calRetMainClaimed][day_id - 1] = 1;
        }
        case CAL_LIST_RETURN_BONUS:
        {
            for(new i = 0; i < CAL_RETURN_BONUS_SLOTS; i++)
            {
                if(CalReturnBonusDayId[i] == day_id) CalPlayer[playerid][calRetBonusClaimed][i] = 1;
            }
        }
    }
    return 1;
}

stock Calendar_IsDayUnlocked(playerid, list_type, day_id)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN: return (day_id <= CalPlayer[playerid][calMainDay]);
        case CAL_LIST_SEASON_BONUS: return (day_id <= CalPlayer[playerid][calMainDay]);
        case CAL_LIST_RETURN_MAIN: return (day_id <= CalPlayer[playerid][calReturnDay]);
        case CAL_LIST_RETURN_BONUS: return (day_id <= CalPlayer[playerid][calReturnDay]);
    }
    return false;
}

stock Calendar_GetMainStatus(playerid, day_index)
{
    new day_id = day_index + 1;
    new award_idx = CalMainDayAward[day_index];
    new bool:epic = (CalendarAwards[award_idx][calEpic] != 0);
    new bool:low = (Player[playerid][pLevel] < CAL_MIN_EPIC_LEVEL);

    if(Calendar_IsClaimed(playerid, CAL_LIST_SEASON_MAIN, day_id)) return epic ? 10 : 3;

    if(!Calendar_IsDayUnlocked(playerid, CAL_LIST_SEASON_MAIN, day_id))
        return epic ? (low ? 4 : 5) : 0;

    if(day_id == CalPlayer[playerid][calMainDay])
    {
        if(Calendar_IsPlaytimeRunning(playerid))
            return epic ? (low ? 6 : 7) : 1;
        if(Calendar_IsPlaytimeReady(playerid))
            return epic ? (low ? 8 : 9) : 2;
        return epic ? (low ? 4 : 5) : 0;
    }
    return epic ? (low ? 4 : 5) : 0;
}

stock Calendar_GetBonusStatus(playerid, bonus_index)
{
    new day_id = CalBonusDayId[bonus_index];
    if(Calendar_IsClaimed(playerid, CAL_LIST_SEASON_BONUS, day_id)) return 4;
    if(!Calendar_IsDayUnlocked(playerid, CAL_LIST_SEASON_BONUS, day_id)) return 0;
    if(Player[playerid][pLevel] < CAL_MIN_EPIC_LEVEL) return 1;
    if(day_id == CalPlayer[playerid][calMainDay] && !Calendar_IsPlaytimeReady(playerid))
    {
        if(Calendar_IsPlaytimeRunning(playerid)) return 0;
        return 0;
    }
    return 2;
}

stock Calendar_GetReturnMainStatus(playerid, day_index)
{
    new day_id = day_index + 1;
    new award_idx = CalReturnMainAward[day_index];
    new bool:epic = (award_idx == -1 || CalendarAwards[award_idx][calEpic] != 0);
    new bool:low = (Player[playerid][pLevel] < CAL_MIN_EPIC_LEVEL);

    if(Calendar_IsClaimed(playerid, CAL_LIST_RETURN_MAIN, day_id)) return epic ? 10 : 3;
    if(!Calendar_IsDayUnlocked(playerid, CAL_LIST_RETURN_MAIN, day_id)) return epic ? (low ? 4 : 5) : 0;
    if(day_id == CalPlayer[playerid][calReturnDay])
    {
        if(Calendar_IsPlaytimeRunning(playerid)) return epic ? (low ? 6 : 7) : 1;
        if(Calendar_IsPlaytimeReady(playerid)) return epic ? (low ? 8 : 9) : 2;
        return epic ? (low ? 4 : 5) : 0;
    }
    return epic ? (low ? 4 : 5) : 0;
}

stock Calendar_GetReturnBonusStatus(playerid, bonus_index)
{
    new day_id = CalReturnBonusDayId[bonus_index];
    if(Calendar_IsClaimed(playerid, CAL_LIST_RETURN_BONUS, day_id)) return 4;
    if(!Calendar_IsDayUnlocked(playerid, CAL_LIST_RETURN_BONUS, day_id)) return 0;
    if(Player[playerid][pLevel] < CAL_MIN_EPIC_LEVEL) return 1;
    return 2;
}

stock Calendar_TickDays(playerid)
{
    if(!CalPlayer[playerid][calLoaded] || Player[playerid][pID] <= 0) return 0;

    new stamp = Calendar_GetDayStamp();
    if(CalPlayer[playerid][calLastDayStamp] == 0) CalPlayer[playerid][calLastDayStamp] = stamp;

    if(stamp > CalPlayer[playerid][calLastDayStamp])
    {
        if(CalPlayer[playerid][calMainDay] < CAL_MAIN_SLOTS)
            CalPlayer[playerid][calMainDay]++;
        if(Calendar_IsReturnPlayer(playerid) && CalPlayer[playerid][calReturnDay] < CAL_RETURN_MAIN_SLOTS)
            CalPlayer[playerid][calReturnDay]++;
        CalPlayer[playerid][calLastDayStamp] = stamp;
        Calendar_ResetPlaytimeForNewDay(playerid);
    }
    CalPlayer[playerid][calLastLogin] = gettime();
    return 1;
}

stock bool:Calendar_GetRewardMeta(award_idx, &type, &count, &internal, &spray_price, name[], name_len)
{
    if(award_idx < 0 || award_idx >= CAL_AWARDS_TOTAL) return false;
    type = CalendarAwards[award_idx][calType];
    count = CalendarAwards[award_idx][calCount];
    internal = CalendarAwards[award_idx][calInternal];
    spray_price = CalendarAwards[award_idx][calSpray];
    format(name, name_len, "%s", CalendarAwards[award_idx][calName]);
    return true;
}

stock Calendar_InsertReward(playerid, award_idx)
{
    if(award_idx < 0 || award_idx >= CAL_AWARDS_TOTAL || Player[playerid][pID] <= 0) return 0;
    new query[192];
    mysql_format(db_handle, query, sizeof(query),
        "INSERT INTO `rewards` (`uid`, `award_id`, `case_id`) \
        SELECT %d, %d, %d FROM DUAL \
        WHERE (SELECT COUNT(*) FROM `rewards` WHERE `uid` = %d) < 100000",
        Player[playerid][pID], award_idx, CAL_REWARDS_CASE_ID, Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");
    return 1;
}

stock Calendar_GrantReturnPack(playerid)
{
    Calendar_InsertReward(playerid, CAL_A_RET1);
    Calendar_InsertReward(playerid, CAL_A_RET2);
    Calendar_InsertReward(playerid, 25); // стандартный из пака — award 25
    Calendar_InsertReward(playerid, CAL_A_RET4);
    return 1;
}

stock Calendar_ApplyRewardDirect(playerid, award_idx)
{
    if(award_idx < 0 || award_idx >= CAL_AWARDS_TOTAL) return 0;

    new type = CalendarAwards[award_idx][calType];
    new internal = CalendarAwards[award_idx][calInternal];
    new count = CalendarAwards[award_idx][calCount];
    new sub = CalendarAwards[award_idx][calSubCount];
    new name[48];
    format(name, sizeof(name), "%s", CalendarAwards[award_idx][calName]);

    switch(type)
    {
        case 1:
        {
            Player[playerid][pExp] += count;
            Player[playerid][pLevel] = (Player[playerid][pExp] / 4) + 1;
            SetPlayerScore(playerid, Player[playerid][pLevel]);
        }
        case 2: GivePlayerMoneyEx(playerid, count);
        case 3: GivePlayerBlackCoin(playerid, count);
        case 4: AddPlayerCaseCountByType(playerid, internal, count);
        case 5:
        {
            if(count == 0 && sub > 0)
            {
                if(GivePlayerSkin(playerid, sub))
                {
                    new notify[96];
                    format(notify, sizeof(notify), "Вы получили скин: %s", name);
                    ShowNotification(playerid, 1, 5, 1, 0, notify, "");
                }
                else ShowNotification(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
                return 1;
            }
            new slot = Player_FindFreeCarSlot(playerid);
            if(slot == -1)
            {
                new cal_slot_msg[160];
                Player_FillNoCarSlotMessage(playerid, cal_slot_msg, sizeof cal_slot_msg);
                ShowNotification(playerid, 2, 4, 1, 1, cal_slot_msg, "");
                return 0;
            }
            VehicleInfo_ClearSlot(playerid, slot, false);
            VehicleInfo[playerid][slot][vModel] = internal;
            VehicleInfo[playerid][slot][vPrice] = 0;
            VehicleInfo[playerid][slot][vColor][0] = 1;
            VehicleInfo[playerid][slot][vColor][1] = 1;
            new query[512];
            mysql_format(db_handle, query, sizeof(query),
                "INSERT INTO `ownable_cars` (`owner_id`, `owner_name`, `model`, `price`, `color1`, `color2`, `body_color`, `disk_color`, `wheel`, `vinyl`, `nitro`, `x`, `y`, `z`, `a`) \
                VALUES (%d, '%e', %d, 0, 1, 1, 0, 0, 0, '', 0, '2477.5', '-741.7', '11.3', '69.2')",
                Player[playerid][pID], Player[playerid][pName], internal);
            mysql_tquery(db_handle, query, "OnCarAwardAdded", "ii", playerid, slot);
            new notify[96];
            format(notify, sizeof(notify), "Вы получили транспорт: %s", name);
            ShowNotification(playerid, 3, 5, 1, 0, notify, "");
        }
        case 8: SetPlayerX2(playerid, true, count);
        case 9:
        {
            Player[playerid][pVipType] = internal;
            Player[playerid][pVipTime] = count * 3600;
        }
        case 10: GivePlayerExp(playerid, count);
        case 11:
        {
            if(count > 10000)
            {
                if(GivePlayerSkin(playerid, count))
                {
                    new notify[96];
                    format(notify, sizeof(notify), "Вы получили скин: %s", name);
                    ShowNotification(playerid, 1, 5, 1, 0, notify, "");
                }
                else ShowNotification(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
            }
            else if(GivePlayerItem(playerid, internal, count))
            {
                new notify[96];
                format(notify, sizeof(notify), "Вы получили: %s", name);
                ShowNotification(playerid, 1, 5, 1, 0, notify, "");
            }
            else ShowNotification(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
        }
        case 25: Lic_SetPlayerLicense(playerid, internal, floatround(count / 24.0, floatround_ceil));
        case 134:
        {
            if(GivePlayerSkin(playerid, count))
            {
                new notify[96];
                format(notify, sizeof(notify), "Вы получили скин: %s", name);
                ShowNotification(playerid, 1, 5, 1, 0, notify, "");
            }
            else ShowNotification(playerid, 2, 4, 1, 1, "Инвентарь полон!", "");
        }
    }
    return 1;
}

stock Calendar_BuildStatusArray(playerid, Node:arr, list_type)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN:
        {
            for(new i = 0; i < CAL_MAIN_SLOTS; i++)
                JSON_ArrayAppend(arr, "", JSON_Int(Calendar_GetMainStatus(playerid, i)));
        }
        case CAL_LIST_SEASON_BONUS:
        {
            for(new i = 0; i < CAL_BONUS_SLOTS; i++)
                JSON_ArrayAppend(arr, "", JSON_Int(Calendar_GetBonusStatus(playerid, i)));
        }
        case CAL_LIST_RETURN_MAIN:
        {
            for(new i = 0; i < CAL_RETURN_MAIN_SLOTS; i++)
                JSON_ArrayAppend(arr, "", JSON_Int(Calendar_GetReturnMainStatus(playerid, i)));
        }
        case CAL_LIST_RETURN_BONUS:
        {
            for(new i = 0; i < CAL_RETURN_BONUS_SLOTS; i++)
                JSON_ArrayAppend(arr, "", JSON_Int(Calendar_GetReturnBonusStatus(playerid, i)));
        }
    }
    return 1;
}

stock Calendar_FillOpenFields(playerid, Node:root)
{
    new Node:ml = JSON_Array();
    new Node:bl = JSON_Array();
    new Node:vml = JSON_Array();
    new Node:vbl = JSON_Array();

    Calendar_BuildStatusArray(playerid, ml, CAL_LIST_SEASON_MAIN);
    Calendar_BuildStatusArray(playerid, bl, CAL_LIST_SEASON_BONUS);
    Calendar_BuildStatusArray(playerid, vml, CAL_LIST_RETURN_MAIN);
    Calendar_BuildStatusArray(playerid, vbl, CAL_LIST_RETURN_BONUS);

    JSON_SetArray(root, "ml", ml);
    JSON_SetArray(root, "bl", bl);
    JSON_SetArray(root, "vml", vml);
    JSON_SetArray(root, "vbl", vbl);

    JSON_SetInt(root, "d", CAL_SEASON_DAYS - CalPlayer[playerid][calMainDay]);
    JSON_SetInt(root, "vd", CAL_RETURN_DAYS - CalPlayer[playerid][calReturnDay]);
    JSON_SetInt(root, "tu", Calendar_SecondsUntilMidnight());
    JSON_SetInt(root, "tp", Calendar_GetClientTimerSeconds(playerid));
    JSON_SetInt(root, "dp", CalPlayer[playerid][calMainDay]);
    JSON_SetInt(root, "vs", CalPlayer[playerid][calReturnDay]);
    JSON_SetInt(root, "pl", CAL_MIN_EPIC_LEVEL);
    JSON_SetInt(root, "lv", Player[playerid][pLevel]);
    JSON_SetInt(root, "bn", (CalPlayer[playerid][calFlags] & CAL_FLAG_BP_BANNER_DONE) ? 0 : 1);
    JSON_SetInt(root, "i", (CalPlayer[playerid][calFlags] & CAL_FLAG_TUTORIAL_DONE) ? 0 : 1);
    return 1;
}

stock Calendar_SendOpenJson(playerid)
{
    Calendar_TickDays(playerid);

    new Node:root = JSON_Object();
    Calendar_FillOpenFields(playerid, root);
    OnPacketIncoming(playerid, CAL_GUI_ID, root);
    JSON_Cleanup(root);
    return 1;
}

stock Calendar_SendUpdate(playerid, pkt_type)
{
    new Node:root = JSON_Object();
    JSON_SetInt(root, "t", pkt_type);

    switch(pkt_type)
    {
        case 1:
        {
            new Node:ml = JSON_Array();
            Calendar_BuildStatusArray(playerid, ml, CAL_LIST_SEASON_MAIN);
            JSON_SetArray(root, "ml", ml);
        }
        case 3:
        {
            new Node:bl = JSON_Array();
            Calendar_BuildStatusArray(playerid, bl, CAL_LIST_SEASON_BONUS);
            JSON_SetArray(root, "bl", bl);
        }
        case 4:
        {
            new Node:vml = JSON_Array();
            new Node:vbl = JSON_Array();
            Calendar_BuildStatusArray(playerid, vml, CAL_LIST_RETURN_MAIN);
            Calendar_BuildStatusArray(playerid, vbl, CAL_LIST_RETURN_BONUS);
            JSON_SetArray(root, "vml", vml);
            JSON_SetArray(root, "vbl", vbl);
        }
    }
    OnPacketIncoming(playerid, CAL_GUI_ID, root);
    JSON_Cleanup(root);
    return 1;
}

stock Calendar_IndexToDayId(list_type, index)
{
    switch(list_type)
    {
        case CAL_LIST_SEASON_MAIN, CAL_LIST_RETURN_MAIN:
        {
            return index + 1;
        }
        case CAL_LIST_SEASON_BONUS:
        {
            if(index < 0 || index >= CAL_BONUS_SLOTS) return -1;
            return CalBonusDayId[index];
        }
        case CAL_LIST_RETURN_BONUS:
        {
            if(index < 0 || index >= CAL_RETURN_BONUS_SLOTS) return -1;
            return CalReturnBonusDayId[index];
        }
    }
    return -1;
}

stock bool:Calendar_CanClaim(playerid, list_type, day_id)
{
    if(!CalPlayer[playerid][calLoaded] || Player[playerid][pID] <= 0) return false;
    if(day_id < 1 || Calendar_IsClaimed(playerid, list_type, day_id)) return false;
    if(!Calendar_IsDayUnlocked(playerid, list_type, day_id)) return false;

    if(list_type == CAL_LIST_SEASON_MAIN)
    {
        if(day_id != CalPlayer[playerid][calMainDay]) return false;
        if(!Calendar_IsPlaytimeReady(playerid)) return false;
    }
    else if(list_type == CAL_LIST_RETURN_MAIN)
    {
        if(day_id != CalPlayer[playerid][calReturnDay]) return false;
        if(!Calendar_IsPlaytimeReady(playerid)) return false;
    }
    else if(list_type == CAL_LIST_SEASON_BONUS)
    {
        if(CalPlayer[playerid][calMainDay] < day_id) return false;
        if(day_id == CalPlayer[playerid][calMainDay] && !Calendar_IsPlaytimeReady(playerid)) return false;
    }
    else if(list_type == CAL_LIST_RETURN_BONUS)
    {
        if(CalPlayer[playerid][calReturnDay] < day_id) return false;
    }

    new award_idx = Calendar_GetAwardIndex(list_type, day_id);
    if(award_idx < 0) return false;

    if(CalendarAwards[award_idx][calEpic] && Player[playerid][pLevel] < CAL_MIN_EPIC_LEVEL)
        return false;
    return true;
}

stock Calendar_TryClaim(playerid, screen_t, list_type, slot_index)
{
    if(Player[playerid][pID] <= 0) return 0;

    if(screen_t == 4) list_type += 2;

    new day_id = Calendar_IndexToDayId(list_type, slot_index);
    if(day_id < 1)
    {
        ShowNotification(playerid, 2, 4, 1, 1, "Неверная награда календаря.", "");
        return 0;
    }

    if(!Calendar_CanClaim(playerid, list_type, day_id))
    {
        if(Calendar_PlaytimeRequiredForDay(playerid, list_type, day_id) && Calendar_IsPlaytimeRunning(playerid))
        {
            new tbuf[48], msg[128];
            Calendar_FormatPlaytime(CalPlayer[playerid][calPlaySecondsLeft], tbuf, sizeof(tbuf));
            format(msg, sizeof(msg), "До получения награды осталось: %s (игровое время).", tbuf);
            ShowNotification(playerid, 2, 4, 1, 1, msg, "");
        }
        else
            ShowNotification(playerid, 2, 4, 1, 1, "Награда пока недоступна.", "");
        return 0;
    }

    if(list_type == CAL_LIST_RETURN_MAIN && day_id == 7)
    {
        Calendar_GrantReturnPack(playerid);
        Calendar_SetClaimed(playerid, list_type, day_id);
    }
    else
    {
        new award_idx = Calendar_GetAwardIndex(list_type, day_id);
        if(award_idx < 0) return 0;
        Calendar_InsertReward(playerid, award_idx);
        Calendar_SetClaimed(playerid, list_type, day_id);
    }

    Calendar_ResetPlaytimeForNewDay(playerid);
    Calendar_Save(playerid);

    new notify[128];
    format(notify, sizeof(notify), "Награда календаря в разделе «Награды». Откройте /reward и нажмите «Забрать».");
    ShowNotification(playerid, 1, 5, 1, 0, notify, "");

    if(screen_t == 4) Calendar_SendUpdate(playerid, 4);
    else if(list_type == CAL_LIST_SEASON_BONUS) Calendar_SendUpdate(playerid, 3);
    else Calendar_SendUpdate(playerid, 1);
    return 1;
}

stock Calendar_HandleGuiPacket(playerid, Node:json)
{
    if(Player[playerid][pID] <= 0) { JSON_Cleanup(json); return 1; }

    new pkt_t = 0, btn = 0, day_id = 0, list_from = 0;
    JSON_GetInt(json, "t", pkt_t);
    JSON_GetInt(json, "b", btn);
    JSON_GetInt(json, "id", day_id);
    JSON_GetInt(json, "l", list_from);

    switch(pkt_t)
    {
        case 0:
        {
            Calendar_SendOpenJson(playerid);
        }
        case 1:
        {
            if(btn == 2)
            {
                Calendar_SetGuiOpen(playerid, false);
                return 1;
            }
            if(!(CalPlayer[playerid][calFlags] & CAL_FLAG_TUTORIAL_DONE))
                CalPlayer[playerid][calFlags] |= CAL_FLAG_TUTORIAL_DONE;
            Calendar_Save(playerid);
        }
        case 2: Calendar_TryClaim(playerid, 2, list_from, day_id);
        case 4: Calendar_TryClaim(playerid, 4, list_from, day_id);
        default: Calendar_SendOpenJson(playerid);
    }
    return 1;
}

stock Calendar_Show(playerid)
{
    if(Player[playerid][pID] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "Сначала войдите в аккаунт.");

    Calendar_TickDays(playerid);
    Calendar_StartPlaytimeTimer(playerid);
    Calendar_SetGuiOpen(playerid, true);

    new Node:root = JSON_Object();
    JSON_SetInt(root, "o", 1);
    Calendar_FillOpenFields(playerid, root);
    OnPacketIncoming(playerid, CAL_GUI_ID, root);
    JSON_Cleanup(root);

    if(Calendar_IsPlaytimeReady(playerid))
        SendClientMessage(playerid, COLOR_WHITE, "{E0584B}[КАЛЕНДАРЬ]{FFFFFF} Награда доступна — заберите её в окне календаря.");
    return 1;
}

// --- MySQL ---

stock Calendar_ParseClaimString(dest[], const src[], max_slots)
{
    for(new i = 0; i < max_slots; i++) dest[i] = 0;
    if(!strlen(src)) return 1;
    new len = strlen(src);
    if(len > max_slots) len = max_slots;
    for(new i = 0; i < len; i++)
        dest[i] = (src[i] == '1') ? 1 : 0;
    return 1;
}

stock Calendar_FormatClaimString(dest[], dest_len, const data[], max_slots)
{
    dest[0] = EOS;
    for(new i = 0; i < max_slots; i++)
    {
        new piece[2];
        format(piece, sizeof(piece), "%d", data[i] ? 1 : 0);
        strcat(dest, piece, dest_len);
    }
    return 1;
}

forward OnCalendarPlayerLoaded(playerid);
public OnCalendarPlayerLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows = cache_num_rows();
    if(rows == 0)
    {
        CalPlayer[playerid][calLoaded] = true;
        CalPlayer[playerid][calLastDayStamp] = Calendar_GetDayStamp();
        CalPlayer[playerid][calPlaySecondsLeft] = CAL_COOLDOWN_SECONDS;
        Calendar_Save(playerid);
        return 1;
    }

    CalPlayer[playerid][calMainDay] = cache_get_field_content_int(0, "main_day", db_handle);
    CalPlayer[playerid][calReturnDay] = cache_get_field_content_int(0, "return_day", db_handle);
    CalPlayer[playerid][calLastDayStamp] = cache_get_field_content_int(0, "last_day_stamp", db_handle);
    CalPlayer[playerid][calPlaySecondsLeft] = cache_get_field_content_int(0, "play_timer_end", db_handle);
    CalPlayer[playerid][calLastLogin] = cache_get_field_content_int(0, "last_login", db_handle);
    CalPlayer[playerid][calFlags] = cache_get_field_content_int(0, "flags", db_handle);

    if(CalPlayer[playerid][calPlaySecondsLeft] > CAL_COOLDOWN_SECONDS + 60)
        CalPlayer[playerid][calPlaySecondsLeft] = CAL_COOLDOWN_SECONDS;
    if(CalPlayer[playerid][calPlaySecondsLeft] < 0)
        CalPlayer[playerid][calPlaySecondsLeft] = 0;
    if(CalPlayer[playerid][calPlaySecondsLeft] == 0 && (CalPlayer[playerid][calFlags] & CAL_FLAG_TIMER_STARTED))
        CalPlayer[playerid][calFlags] |= CAL_FLAG_TIMER_READY;

    new tmp[64];
    cache_get_field_content(0, "main_claimed", tmp, db_handle, sizeof(tmp));
    Calendar_ParseClaimString(CalPlayer[playerid][calMainClaimed], tmp, CAL_MAIN_SLOTS);
    cache_get_field_content(0, "bonus_claimed", tmp, db_handle, sizeof(tmp));
    Calendar_ParseClaimString(CalPlayer[playerid][calBonusClaimed], tmp, CAL_BONUS_SLOTS);
    cache_get_field_content(0, "return_main_claimed", tmp, db_handle, sizeof(tmp));
    Calendar_ParseClaimString(CalPlayer[playerid][calRetMainClaimed], tmp, CAL_RETURN_MAIN_SLOTS);
    cache_get_field_content(0, "return_bonus_claimed", tmp, db_handle, sizeof(tmp));
    Calendar_ParseClaimString(CalPlayer[playerid][calRetBonusClaimed], tmp, CAL_RETURN_BONUS_SLOTS);

    if(CalPlayer[playerid][calMainDay] < 1) CalPlayer[playerid][calMainDay] = 1;
    if(CalPlayer[playerid][calReturnDay] < 1) CalPlayer[playerid][calReturnDay] = 1;
    CalPlayer[playerid][calLoaded] = true;
    Calendar_TickDays(playerid);
    return 1;
}

stock Calendar_Load(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;
    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "SELECT * FROM `calendar_players` WHERE `uid` = %d LIMIT 1", Player[playerid][pID]);
    mysql_tquery(db_handle, query, "OnCalendarPlayerLoaded", "i", playerid);
    return 1;
}

stock Calendar_Save(playerid)
{
    if(!CalPlayer[playerid][calLoaded] || Player[playerid][pID] <= 0) return 0;

    new main_s[32], bonus_s[16], ret_main_s[16], ret_bonus_s[16];
    Calendar_FormatClaimString(main_s, sizeof(main_s), CalPlayer[playerid][calMainClaimed], CAL_MAIN_SLOTS);
    Calendar_FormatClaimString(bonus_s, sizeof(bonus_s), CalPlayer[playerid][calBonusClaimed], CAL_BONUS_SLOTS);
    Calendar_FormatClaimString(ret_main_s, sizeof(ret_main_s), CalPlayer[playerid][calRetMainClaimed], CAL_RETURN_MAIN_SLOTS);
    Calendar_FormatClaimString(ret_bonus_s, sizeof(ret_bonus_s), CalPlayer[playerid][calRetBonusClaimed], CAL_RETURN_BONUS_SLOTS);

    new query[640];
    mysql_format(db_handle, query, sizeof(query),
        "INSERT INTO `calendar_players` (`uid`, `main_day`, `return_day`, `last_day_stamp`, `play_timer_end`, `last_login`, `flags`, \
        `main_claimed`, `bonus_claimed`, `return_main_claimed`, `return_bonus_claimed`) \
        VALUES (%d, %d, %d, %d, %d, %d, %d, '%e', '%e', '%e', '%e') \
        ON DUPLICATE KEY UPDATE \
        `main_day`=%d, `return_day`=%d, `last_day_stamp`=%d, `play_timer_end`=%d, `last_login`=%d, `flags`=%d, \
        `main_claimed`='%e', `bonus_claimed`='%e', `return_main_claimed`='%e', `return_bonus_claimed`='%e'",
        Player[playerid][pID], CalPlayer[playerid][calMainDay], CalPlayer[playerid][calReturnDay],
        CalPlayer[playerid][calLastDayStamp], CalPlayer[playerid][calPlaySecondsLeft], gettime(), CalPlayer[playerid][calFlags],
        main_s, bonus_s, ret_main_s, ret_bonus_s,
        CalPlayer[playerid][calMainDay], CalPlayer[playerid][calReturnDay],
        CalPlayer[playerid][calLastDayStamp], CalPlayer[playerid][calPlaySecondsLeft], gettime(), CalPlayer[playerid][calFlags],
        main_s, bonus_s, ret_main_s, ret_bonus_s);
    mysql_tquery(db_handle, query, "", "");
    return 1;
}

stock Calendar_OnConnect(playerid)
{
    Calendar_ResetPlayer(playerid);
    return 1;
}

stock Calendar_OnDisconnect(playerid)
{
    Calendar_SetGuiOpen(playerid, false);
    if(CalPlayer[playerid][calLoaded]) Calendar_Save(playerid);
    Calendar_ResetPlayer(playerid);
    return 1;
}

stock Calendar_EnsureTable()
{
    mysql_tquery(db_handle,
        "CREATE TABLE IF NOT EXISTS `calendar_players` ( \
        `uid` INT NOT NULL, \
        `main_day` INT NOT NULL DEFAULT 1, \
        `return_day` INT NOT NULL DEFAULT 1, \
        `last_day_stamp` INT NOT NULL DEFAULT 0, \
        `play_timer_end` INT NOT NULL DEFAULT 1800, \
        `last_login` INT NOT NULL DEFAULT 0, \
        `flags` INT NOT NULL DEFAULT 0, \
        `main_claimed` VARCHAR(64) NOT NULL DEFAULT '', \
        `bonus_claimed` VARCHAR(16) NOT NULL DEFAULT '', \
        `return_main_claimed` VARCHAR(16) NOT NULL DEFAULT '', \
        `return_bonus_claimed` VARCHAR(16) NOT NULL DEFAULT '', \
        PRIMARY KEY (`uid`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    return 1;
}

CMD:calendar(playerid, params[])
{
    return Calendar_Show(playerid);
}
