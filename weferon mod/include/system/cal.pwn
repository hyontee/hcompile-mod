#if defined _calendar_included
    #endinput
#endif
#define _calendar_included

#define CALENDAR_SCREEN_ID 71
#define CALENDAR_TIMER_UPDATE 1000

#define CALENDAR_KEY_DAYS_GAME "dp"
#define CALENDAR_KEY_TOTAL_DAYS "td"
#define CALENDAR_KEY_SECONDS_FOR_NEW_DAY "tu"
#define CALENDAR_KEY_SECONDS_FOR_REWARD "tp"
#define CALENDAR_KEY_DAYS_FOR_END_SEASON "d"
#define CALENDAR_KEY_HOURS_LEFT "hl"
#define CALENDAR_KEY_CURRENT_LEVEL "lv"
#define CALENDAR_KEY_LEVEL_MINIMUM "pl"
#define CALENDAR_KEY_IS_SHOWING_NEW_SEASON_BP "bn"
#define CALENDAR_KEY_EVENT_NAME "en"
#define CALENDAR_KEY_TYPE "t"
#define CALENDAR_KEY_BUTTON "b"
#define CALENDAR_KEY_STATUS_MAIN_REWARDS "ml"
#define CALENDAR_KEY_REWARD_INDEX "ri"
#define CALENDAR_KEY_REWARD_ID "id"
#define CALENDAR_KEY_REWARD_FROM_LIST "l"

#define TYPE_UPDATE_MAIN_REWARDS 1
#define TYPE_BUTTON_CLICK 1
#define TYPE_GET_REWARD 2

#define BUTTON_EXIT_ID 2
#define BUTTON_BLACK_PASS_ID 1

#define REWARD_STATE_NONE 0
#define REWARD_STATE_NOT_RECEIVED 1
#define REWARD_STATE_NOT_RECEIVED_LOW_LEVEL 2
#define REWARD_STATE_AVAILABLE_NORM_LEVEL 3
#define REWARD_STATE_AVAILABLE_LOW_LEVEL 4
#define REWARD_STATE_RECEIVED 5
#define REWARD_STATE_NORM_TIMER 6
#define REWARD_STATE_EPIC_TIMER_NORM_LEVEL 7
#define REWARD_STATE_EPIC_TIMER_LOW_LEVEL 8

#define REWARD_STATE_TIMER REWARD_STATE_EPIC_TIMER_NORM_LEVEL

#define CALENDAR_TOTAL_DAYS 35
#define CALENDAR_TIMER_DURATION 1200

static 
    g_CalendarCurrentDay[MAX_PLAYERS],
    g_CalendarTotalDays[MAX_PLAYERS],
    g_CalendarSecondsForNewDay[MAX_PLAYERS],
    g_CalendarDaysForEndSeason[MAX_PLAYERS],
    g_CalendarHoursLeft[MAX_PLAYERS],
    g_CalendarCurrentLevel[MAX_PLAYERS],
    g_CalendarMinRewardLevel[MAX_PLAYERS],
    g_CalendarTimerSeconds[MAX_PLAYERS],
    g_CalendarRewardIndex[MAX_PLAYERS],
    g_CalendarRewardState[MAX_PLAYERS][CALENDAR_TOTAL_DAYS],
    g_CalendarIsShowBanner[MAX_PLAYERS],
    bool:g_CalendarVisible[MAX_PLAYERS],
    g_CalendarTimerID[MAX_PLAYERS];

forward CalendarTimerUpdate(playerid);
forward ShowRewardDialog(playerid, day_index);

static stock InitPlayerCalendar(playerid)
{
    g_CalendarTotalDays[playerid] = CALENDAR_TOTAL_DAYS;
    g_CalendarCurrentDay[playerid] = 1;
    g_CalendarSecondsForNewDay[playerid] = 32738;
    g_CalendarDaysForEndSeason[playerid] = CALENDAR_TOTAL_DAYS - 1;
    g_CalendarHoursLeft[playerid] = 1094;
    
    g_CalendarCurrentLevel[playerid] = 21;
    g_CalendarMinRewardLevel[playerid] = 4;
    
    g_CalendarIsShowBanner[playerid] = 1;
    g_CalendarVisible[playerid] = false;
    
    g_CalendarTimerSeconds[playerid] = CALENDAR_TIMER_DURATION;
    g_CalendarRewardIndex[playerid] = 0;
    
    for(new i = 0; i < CALENDAR_TOTAL_DAYS; i++)
    {
        if(i == 0)
        {
            g_CalendarRewardState[playerid][i] = REWARD_STATE_TIMER;
        }
        else if(i < 5)
        {
            g_CalendarRewardState[playerid][i] = REWARD_STATE_RECEIVED;
        }
        else
        {
            g_CalendarRewardState[playerid][i] = REWARD_STATE_NOT_RECEIVED;
        }
    }
    
    if(g_CalendarTimerID[playerid] == 0)
    {
        g_CalendarTimerID[playerid] = SetTimerEx("CalendarTimerUpdate", CALENDAR_TIMER_UPDATE, true, "i", playerid);
    }
}

public CalendarTimerUpdate(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    if(g_CalendarTimerSeconds[playerid] > 0)
    {
        g_CalendarTimerSeconds[playerid]--;
        
        if(g_CalendarTimerSeconds[playerid] == 0)
        {
            new day_index = g_CalendarRewardIndex[playerid];
            if(day_index >= 0 && day_index < CALENDAR_TOTAL_DAYS)
            {
                g_CalendarRewardState[playerid][day_index] = REWARD_STATE_AVAILABLE_NORM_LEVEL;
                
                if(g_CalendarVisible[playerid])
                {
                    ShowCalendar(playerid);
                }
                
                ShowRewardDialog(playerid, day_index);
            }
        }
    }
    return 1;
}

static stock ShowCalendar(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    new Node:root = JSON_Object();
    
    JSON_SetInt(root, "o", 1);
    JSON_SetInt(root, CALENDAR_KEY_TYPE, TYPE_UPDATE_MAIN_REWARDS);
    JSON_SetInt(root, CALENDAR_KEY_DAYS_GAME, g_CalendarCurrentDay[playerid]);
    JSON_SetInt(root, CALENDAR_KEY_TOTAL_DAYS, g_CalendarTotalDays[playerid]);
    JSON_SetInt(root, CALENDAR_KEY_SECONDS_FOR_NEW_DAY, g_CalendarSecondsForNewDay[playerid]);
    JSON_SetInt(root, CALENDAR_KEY_DAYS_FOR_END_SEASON, g_CalendarDaysForEndSeason[playerid]);
    JSON_SetInt(root, CALENDAR_KEY_HOURS_LEFT, g_CalendarHoursLeft[playerid]);
    
    JSON_SetInt(root, CALENDAR_KEY_CURRENT_LEVEL, g_CalendarCurrentLevel[playerid]);
    JSON_SetInt(root, CALENDAR_KEY_LEVEL_MINIMUM, g_CalendarMinRewardLevel[playerid]);
    
    if(g_CalendarRewardIndex[playerid] >= 0 && 
       g_CalendarRewardIndex[playerid] < CALENDAR_TOTAL_DAYS &&
       g_CalendarRewardState[playerid][g_CalendarRewardIndex[playerid]] != REWARD_STATE_AVAILABLE_NORM_LEVEL)
    {
        JSON_SetInt(root, CALENDAR_KEY_SECONDS_FOR_REWARD, g_CalendarTimerSeconds[playerid]);
        JSON_SetInt(root, CALENDAR_KEY_REWARD_INDEX, g_CalendarRewardIndex[playerid]);
    }
    else
    {
        JSON_SetInt(root, CALENDAR_KEY_SECONDS_FOR_REWARD, 0);
        JSON_SetInt(root, CALENDAR_KEY_REWARD_INDEX, -1);
    }
    
    new statusString[512];
    statusString = "[";
    
    for(new i = 0; i < CALENDAR_TOTAL_DAYS; i++)
    {
        new num[4];
        format(num, sizeof(num), "%d", g_CalendarRewardState[playerid][i]);
        strcat(statusString, num);
        
        if(i < CALENDAR_TOTAL_DAYS - 1)
            strcat(statusString, ",");
    }
    strcat(statusString, "]");
    
    JSON_SetString(root, CALENDAR_KEY_STATUS_MAIN_REWARDS, statusString);
    
    JSON_SetInt(root, CALENDAR_KEY_IS_SHOWING_NEW_SEASON_BP, g_CalendarIsShowBanner[playerid]);
    
    JSON_SetString(root, CALENDAR_KEY_EVENT_NAME, "НОВОГОДНЕЕ ЧУДО");
    
    JSON_SetString(root, "bp_title", "НОВЫЙ СЕЗОН!");
    JSON_SetString(root, "bp_subtitle", "BLACK PASS");
    JSON_SetString(root, "bp_vehicle", "Volkswagen T2");
    JSON_SetString(root, "bp_mileage", "4580 M");
    
    ShowPlayerGUI(playerid, CALENDAR_SCREEN_ID, root);
    
    g_CalendarVisible[playerid] = true;
    
    return 1;
}

static stock ShowRewardDialog(playerid, day_index)
{
    new Node:root = JSON_Object();
    
    JSON_SetInt(root, "t", TYPE_GET_REWARD);
    JSON_SetInt(root, "l", 1);
    JSON_SetInt(root, "id", 1000 + day_index);
    JSON_SetString(root, "title", "1000 BP EXP");
    JSON_SetString(root, "subtitle", "BP");
    JSON_SetString(root, "button", "ПОЛУЧИТЬ");
    JSON_SetInt(root, "day", day_index + 1);
    
    ShowPlayerGUI(playerid, 1000, root);
    
    return 1;
}

static stock GiveDayReward(playerid, day_index)
{
    if(day_index != g_CalendarRewardIndex[playerid]) 
    {
        return 0;
    }
    
    if(g_CalendarRewardState[playerid][day_index] == REWARD_STATE_AVAILABLE_NORM_LEVEL)
    {
        g_CalendarRewardState[playerid][day_index] = REWARD_STATE_RECEIVED;
        
        new Node:root = JSON_Object();
        JSON_SetInt(root, "type", 1001);
        JSON_SetString(root, "status", "success");
        JSON_SetString(root, "message", "Награда получена!");
        ShowPlayerGUI(playerid, 1000, root);
        
        if(day_index + 1 < CALENDAR_TOTAL_DAYS)
        {
            g_CalendarCurrentDay[playerid] = day_index + 2;
            g_CalendarDaysForEndSeason[playerid] = CALENDAR_TOTAL_DAYS - (day_index + 2);
            g_CalendarRewardIndex[playerid] = day_index + 1;
            g_CalendarRewardState[playerid][day_index + 1] = REWARD_STATE_TIMER;
            g_CalendarTimerSeconds[playerid] = CALENDAR_TIMER_DURATION;
        }
        else
        {
            g_CalendarTimerSeconds[playerid] = 0;
            g_CalendarRewardIndex[playerid] = -1;
        }
        
        if(g_CalendarVisible[playerid])
            ShowCalendar(playerid);
            
        return 1;
    }
    else
    {
        return 0;
    }
}

static stock HandleCalendarPacket(playerid, Node:root)
{
    new type = JSON_GetInt(root, CALENDAR_KEY_TYPE);
    
    switch(type)
    {
        case TYPE_BUTTON_CLICK:
        {
            new button = JSON_GetInt(root, CALENDAR_KEY_BUTTON);
            if(button == BUTTON_EXIT_ID)
            {
                g_CalendarVisible[playerid] = false;
            }
        }
        
        case TYPE_GET_REWARD:
        {
            new reward_id = JSON_GetInt(root, CALENDAR_KEY_REWARD_ID);
            new day_index = reward_id - 1000;
            
            GiveDayReward(playerid, day_index);
        }
    }
    return 1;
}

public OnPlayerReceiveGUI(playerid, gui_id, Node:root)
{
    if(gui_id == CALENDAR_SCREEN_ID)
    {
        HandleCalendarPacket(playerid, root);
    }

    #if defined Cal_OnPlayerReceiveGUI
        return Cal_OnPlayerReceiveGUI(playerid, gui_id, root);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerReceiveGUI
    #undef OnPlayerReceiveGUI
#else
    #define _ALS_OnPlayerReceiveGUI
#endif
#define OnPlayerReceiveGUI Cal_OnPlayerReceiveGUI
#if defined Cal_OnPlayerReceiveGUI
    forward Cal_OnPlayerReceiveGUI(playerid, gui_id, Node:root);
#endif

public OnPlayerConnect(playerid)
{
    InitPlayerCalendar(playerid);

    #if defined Cal_OnPlayerConnect
        return Cal_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Cal_OnPlayerConnect
#if defined Cal_OnPlayerConnect
    forward Cal_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(g_CalendarTimerID[playerid] != 0)
    {
        KillTimer(g_CalendarTimerID[playerid]);
        g_CalendarTimerID[playerid] = 0;
    }

    #if defined Cal_OnPlayerDisconnect
        return Cal_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Cal_OnPlayerDisconnect
#if defined Cal_OnPlayerDisconnect
    forward Cal_OnPlayerDisconnect(playerid, reason);
#endif

CMD:calendarlil(playerid)
{
    ShowCalendar(playerid);
    return 1;
}