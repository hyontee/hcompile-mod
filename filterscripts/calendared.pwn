#include <a_samp>

#define FILTERSCRIPT

#define DIALOG_CALENDAR_LIST     6002
#define DIALOG_CALENDAR_INFO     6001

#define TOTAL_CALENDAR_DAYS      30
#define CALENDAR_COOLDOWN        86400

#define REWARD_TYPE_MONEY        1
#define REWARD_TYPE_DONATE       2

enum e_calendar_data
{
    cal_last_claim,
    cal_claimed_mask1,
    cal_claimed_mask2
};
new PlayerCalendar[MAX_PLAYERS][e_calendar_data];

// ЕСЛИ У ТЕБЯ ДОНАТ ХРАНИТСЯ ПО-ДРУГОМУ — ЗАМЕНИ ЭТО
new pDonate[MAX_PLAYERS];

new RewardType[TOTAL_CALENDAR_DAYS] =
{
    REWARD_TYPE_MONEY,   // 1
    REWARD_TYPE_DONATE,  // 2
    REWARD_TYPE_MONEY,   // 3
    REWARD_TYPE_DONATE,  // 4
    REWARD_TYPE_MONEY,   // 5
    REWARD_TYPE_DONATE,  // 6
    REWARD_TYPE_MONEY,   // 7
    REWARD_TYPE_DONATE,  // 8
    REWARD_TYPE_MONEY,   // 9
    REWARD_TYPE_DONATE,  // 10
    REWARD_TYPE_MONEY,   // 11
    REWARD_TYPE_DONATE,  // 12
    REWARD_TYPE_MONEY,   // 13
    REWARD_TYPE_DONATE,  // 14
    REWARD_TYPE_MONEY,   // 15
    REWARD_TYPE_DONATE,  // 16
    REWARD_TYPE_MONEY,   // 17
    REWARD_TYPE_DONATE,  // 18
    REWARD_TYPE_MONEY,   // 19
    REWARD_TYPE_DONATE,  // 20
    REWARD_TYPE_MONEY,   // 21
    REWARD_TYPE_DONATE,  // 22
    REWARD_TYPE_MONEY,   // 23
    REWARD_TYPE_DONATE,  // 24
    REWARD_TYPE_MONEY,   // 25
    REWARD_TYPE_DONATE,  // 26
    REWARD_TYPE_MONEY,   // 27
    REWARD_TYPE_DONATE,  // 28
    REWARD_TYPE_MONEY,   // 29
    REWARD_TYPE_DONATE   // 30
};

new RewardAmount[TOTAL_CALENDAR_DAYS] =
{
    1000, 5, 2000, 10, 3000,
    15, 4000, 20, 5000, 25,
    6000, 30, 7000, 35, 8000,
    40, 9000, 45, 10000, 50,
    11000, 55, 12000, 60, 13000,
    65, 14000, 70, 15000, 100
};

new DayColor[TOTAL_CALENDAR_DAYS][] =
{
    "{FF0000}",
    "{0000FF}",
    "{00CC00}",
    "{FFFF00}",
    "{FF9900}",
    "{CC00FF}",
    "{00FFFF}",
    "{FF66CC}",
    "{996633}",
    "{FFFFFF}",
    "{FF3333}",
    "{3366FF}",
    "{33CC33}",
    "{FFD700}",
    "{FF6600}",
    "{9900CC}",
    "{00CCCC}",
    "{FF1493}",
    "{8B4513}",
    "{C0C0C0}",
    "{DC143C}",
    "{1E90FF}",
    "{32CD32}",
    "{FFA500}",
    "{FF4500}",
    "{8A2BE2}",
    "{20B2AA}",
    "{FF69B4}",
    "{A0522D}",
    "{7FFFD4}"
};

public OnFilterScriptInit()
{
    print("[CalendarFS] Загружен.");
    return 1;
}

public OnFilterScriptExit()
{
    print("[CalendarFS] Выгружен.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    LoadPlayerCalendar(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerCalendar(playerid);
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/calendar", true))
    {
        ShowCalendarDialog(playerid);
        return 1;
    }
    if(!strcmp(cmdtext, "/cal", true))
    {
        ShowCalendarDialog(playerid);
        return 1;
    }
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CALENDAR_LIST)
    {
        if(!response) return 1;

        ResetCalendarIfNeeded(playerid);

        new day = listitem + 1;
        if(day < 1 || day > TOTAL_CALENDAR_DAYS) return 1;

        if(IsDayClaimed(playerid, day))
        {
            new text[144];
            format(text, sizeof(text), "Ты уже забрал приз за %d день.", day);
            ShowPlayerDialog(playerid, DIALOG_CALENDAR_INFO, DIALOG_STYLE_MSGBOX, "Календарь", text, "Ок", "");
            return 1;
        }

        new nextday = GetNextAvailableDay(playerid);
        if(day != nextday)
        {
            new text[144];
            format(text, sizeof(text), "Этот день пока недоступен.\nСначала нужно забрать %d день.", nextday);
            ShowPlayerDialog(playerid, DIALOG_CALENDAR_INFO, DIALOG_STYLE_MSGBOX, "Календарь", text, "Ок", "");
            return 1;
        }

        new now = gettime();
        new passed = now - PlayerCalendar[playerid][cal_last_claim];

        if(PlayerCalendar[playerid][cal_last_claim] != 0 && passed < CALENDAR_COOLDOWN)
        {
            new remain = CALENDAR_COOLDOWN - passed;
            new h, m, s, text[180];
            SecondsToTime(remain, h, m, s);

            format(text, sizeof(text),
                "До следующего приза осталось:\n\n%d ч. %d мин. %d сек.",
                h, m, s
            );
            ShowPlayerDialog(playerid, DIALOG_CALENDAR_INFO, DIALOG_STYLE_MSGBOX, "Календарь", text, "Ок", "");
            return 1;
        }

        GiveCalendarReward(playerid, day);
        return 1;
    }
    return 0;
}

stock ShowCalendarDialog(playerid)
{
    ResetCalendarIfNeeded(playerid);

    new dialog[4096];
    new line[180];
    dialog[0] = '\0';

    new nextday = GetNextAvailableDay(playerid);

    for(new day = 1; day <= TOTAL_CALENDAR_DAYS; day++)
    {
        new rewardtext[32];
        GetRewardText(day, rewardtext, sizeof(rewardtext));

        if(IsDayClaimed(playerid, day))
        {
            format(line, sizeof(line), "%s%d день (%s)\t{00CC66}[ПОЛУЧЕНО]\n", DayColor[day - 1], day, rewardtext);
        }
        else if(day == nextday)
        {
            format(line, sizeof(line), "%s%d день (%s)\t{FFD700}[ДОСТУПНО]\n", DayColor[day - 1], day, rewardtext);
        }
        else
        {
            format(line, sizeof(line), "%s%d день (%s)\t{999999}[ЗАКРЫТО]\n", DayColor[day - 1], day, rewardtext);
        }

        strcat(dialog, line);
    }

    ShowPlayerDialog(playerid, DIALOG_CALENDAR_LIST, DIALOG_STYLE_TABLIST, "Ежедневный календарь", dialog, "Выбрать", "Закрыть");
    return 1;
}

stock GiveCalendarReward(playerid, day)
{
    new type = RewardType[day - 1];
    new amount = RewardAmount[day - 1];
    new text[180];

    switch(type)
    {
        case REWARD_TYPE_MONEY:
        {
            GivePlayerMoney(playerid, amount);

            format(text, sizeof(text),
                "Ты забрал приз за %d день!\n\nНаграда: $%d",
                day, amount
            );
        }
        case REWARD_TYPE_DONATE:
        {
            pDonate[playerid] += amount; // ЗАМЕНИ НА СВОЮ СИСТЕМУ ДОНАТА

            format(text, sizeof(text),
                "Ты забрал приз за %d день!\n\nНаграда: %d donate",
                day, amount
            );
        }
    }

    SetDayClaimed(playerid, day, true);
    PlayerCalendar[playerid][cal_last_claim] = gettime();

    SavePlayerCalendar(playerid);

    ShowPlayerDialog(playerid, DIALOG_CALENDAR_INFO, DIALOG_STYLE_MSGBOX, "Приз получен", text, "Ок", "");
    SendClientMessage(playerid, 0x33CCFFAA, "Ты успешно забрал награду из календаря.");
    return 1;
}

stock GetRewardText(day, dest[], size)
{
    new type = RewardType[day - 1];
    new amount = RewardAmount[day - 1];

    switch(type)
    {
        case REWARD_TYPE_MONEY: format(dest, size, "$%d", amount);
        case REWARD_TYPE_DONATE: format(dest, size, "%d donate", amount);
    }
    return 1;
}

stock IsDayClaimed(playerid, day)
{
    if(day < 1 || day > TOTAL_CALENDAR_DAYS) return 0;

    if(day <= 32)
    {
        return (PlayerCalendar[playerid][cal_claimed_mask1] & (1 << (day - 1))) != 0;
    }
    return (PlayerCalendar[playerid][cal_claimed_mask2] & (1 << (day - 33))) != 0;
}

stock SetDayClaimed(playerid, day, bool:value)
{
    if(day < 1 || day > TOTAL_CALENDAR_DAYS) return 0;

    if(day <= 32)
    {
        if(value) PlayerCalendar[playerid][cal_claimed_mask1] |= (1 << (day - 1));
        else PlayerCalendar[playerid][cal_claimed_mask1] &= ~(1 << (day - 1));
    }
    else
    {
        if(value) PlayerCalendar[playerid][cal_claimed_mask2] |= (1 << (day - 33));
        else PlayerCalendar[playerid][cal_claimed_mask2] &= ~(1 << (day - 33));
    }
    return 1;
}

stock GetNextAvailableDay(playerid)
{
    for(new day = 1; day <= TOTAL_CALENDAR_DAYS; day++)
    {
        if(!IsDayClaimed(playerid, day)) return day;
    }
    return 1;
}

stock IsCalendarCompleted(playerid)
{
    for(new day = 1; day <= TOTAL_CALENDAR_DAYS; day++)
    {
        if(!IsDayClaimed(playerid, day)) return 0;
    }
    return 1;
}

stock ResetCalendarIfNeeded(playerid)
{
    if(!IsCalendarCompleted(playerid)) return 1;

    new now = gettime();
    new passed = now - PlayerCalendar[playerid][cal_last_claim];

    if(PlayerCalendar[playerid][cal_last_claim] != 0 && passed >= CALENDAR_COOLDOWN)
    {
        PlayerCalendar[playerid][cal_claimed_mask1] = 0;
        PlayerCalendar[playerid][cal_claimed_mask2] = 0;
        SavePlayerCalendar(playerid);
    }
    return 1;
}

stock SecondsToTime(seconds, &hours, &minutes, &secs)
{
    hours = seconds / 3600;
    minutes = (seconds % 3600) / 60;
    secs = seconds % 60;
    return 1;
}

stock SavePlayerCalendar(playerid)
{
    new name[MAX_PLAYER_NAME], path[64], data[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(path, sizeof(path), "calendar_%s.txt", name);

    new File:f = fopen(path, io_write);
    if(!f) return 0;

    format(data, sizeof(data), "%d\r\n%d\r\n%d\r\n",
        PlayerCalendar[playerid][cal_last_claim],
        PlayerCalendar[playerid][cal_claimed_mask1],
        PlayerCalendar[playerid][cal_claimed_mask2]
    );

    fwrite(f, data);
    fclose(f);
    return 1;
}

stock LoadPlayerCalendar(playerid)
{
    new name[MAX_PLAYER_NAME], path[64], line[64];
    GetPlayerName(playerid, name, sizeof(name));
    format(path, sizeof(path), "calendar_%s.txt", name);

    PlayerCalendar[playerid][cal_last_claim] = 0;
    PlayerCalendar[playerid][cal_claimed_mask1] = 0;
    PlayerCalendar[playerid][cal_claimed_mask2] = 0;

    if(!fexist(path)) return 1;

    new File:f = fopen(path, io_read);
    if(!f) return 1;

    fread(f, line);
    PlayerCalendar[playerid][cal_last_claim] = strval(line);

    line[0] = '\0';
    fread(f, line);
    PlayerCalendar[playerid][cal_claimed_mask1] = strval(line);

    line[0] = '\0';
    fread(f, line);
    PlayerCalendar[playerid][cal_claimed_mask2] = strval(line);

    fclose(f);
    return 1;
}