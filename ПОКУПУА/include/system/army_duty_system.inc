

#if !defined AD_DIALOG_MAIN
    #define AD_DIALOG_MAIN              29600
    #define AD_DIALOG_INFO              29601
    #define AD_DIALOG_TASKS             29602
    #define AD_DIALOG_STAFF             29603
#endif

// Координаты НПС "Дежурный" (OtdelKadrovMO), заданы рядом с 1794.708862,1729.284301,1493.079833
#define AD_NPC_X                (1795.375122)
#define AD_NPC_Y                (1729.511840)
#define AD_NPC_Z                (1493.153564)
#define AD_NPC_RADIUS           (2.5)
#define AD_NPC_VW               (1)
#define AD_NPC_INTERIOR         (1)

#define AD_TASK_COUNT           (3)
#define AD_TASK_COOLDOWN        (86400) // 24 часа

new AD_NpcArea = -1;

new const AD_TaskName[AD_TASK_COUNT][40] =
{
    "Патрулирование территории части",
    "Проверка и учёт боеприпасов",
    "Доставка донесения в штаб"
};

new const AD_TaskReward[AD_TASK_COUNT] =
{
    5000,
    3500,
    4000
};

new AD_TaskCooldown[MAX_PLAYERS][AD_TASK_COUNT];

stock AD_Init()
{
    AD_NpcArea = CreateDynamicSphere(AD_NPC_X, AD_NPC_Y, AD_NPC_Z, AD_NPC_RADIUS, AD_NPC_VW, AD_NPC_INTERIOR, -1);
    print("[AD] Система \"Дежурный по роте\" (армия) инициализирована.");
    return 1;
}

stock AD_ShowMainMenu(playerid)
{
    Dialog
    (
        playerid, AD_DIALOG_MAIN, DIALOG_STYLE_LIST,
        "Дежурный",
        "Информация\nЗадания\nСотрудники",
        "Выбрать", "Отмена"
    );
    return 1;
}

stock AD_CountOnlineArmy()
{
    new count = 0;
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(GetPlayerTeamEx(i) != TEAM_ARMY) continue;
        count++;
    }
    return count;
}

stock AD_ShowInfo(playerid)
{
    new text[256];
    format(text, sizeof text,
        "{FFFFFF}Военнослужащий:\t{FFD700}%s[%d]\n"\
        "{FFFFFF}Звание:\t\t\t{FFD700}%s\n"\
        "{FFFFFF}Сейчас на службе:\t{FFD700}%d чел.",
        GetPlayerNameEx(playerid), playerid,
        GetPlayerJobAndRankName(playerid),
        AD_CountOnlineArmy()
    );

    Dialog(playerid, AD_DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Информация", text, "Закрыть", "");
    return 1;
}

stock AD_ShowTasks(playerid)
{
    new text[512];
    new left;

    for(new i = 0; i < AD_TASK_COUNT; i++)
    {
        if(AD_TaskCooldown[playerid][i] > gettime())
        {
            left = (AD_TaskCooldown[playerid][i] - gettime()) / 60;
            format(text, sizeof text, "%s{FF5252}%s\t{808080}уже получено (%d мин.)\n", text, AD_TaskName[i], left);
        }
        else
        {
            format(text, sizeof text, "%s{FFFFFF}%s\t{00CC00}+%d руб.\n", text, AD_TaskName[i], AD_TaskReward[i]);
        }
    }

    Dialog(playerid, AD_DIALOG_TASKS, DIALOG_STYLE_LIST, "Задания", text, "Выбрать", "Назад");
    return 1;
}

stock AD_ShowStaff(playerid)
{
    new text[1024];
    new count = 0;

    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(GetPlayerTeamEx(i) != TEAM_ARMY) continue;

        format(text, sizeof text, "%s{FFFFFF}%s[%d]\t{FFD700}%s\n", text, GetPlayerNameEx(i), i, GetPlayerJobAndRankName(i));
        count++;
    }

    if(count == 0)
    {
        format(text, sizeof text, "{FFFFFF}Сейчас на службе никого нет.");
    }

    Dialog(playerid, AD_DIALOG_STAFF, DIALOG_STYLE_MSGBOX, "Сотрудники", text, "Закрыть", "");
    return 1;
}

stock AD_HandleDynamicArea(playerid, areaid)
{
    if(areaid != AD_NpcArea) return 0;

    if(GetPlayerTeamEx(playerid) != TEAM_ARMY)
    {
        SendClientMessage(playerid, 0x999999FF, ""USC"Взаимодействие доступно только военнослужащим.");
        return 1;
    }

    AD_ShowMainMenu(playerid);
    return 1;
}

stock AD_HandleKeyPress(playerid, newkeys)
{
    if(!(newkeys & KEY_CROUCH)) return 0;
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerLogged(playerid)) return 0;
    if(!IsPlayerInRangeOfPoint(playerid, AD_NPC_RADIUS + 1.0, AD_NPC_X, AD_NPC_Y, AD_NPC_Z)) return 0;

    if(GetPlayerTeamEx(playerid) != TEAM_ARMY)
    {
        SendClientMessage(playerid, 0x999999FF, ""USC"Взаимодействие доступно только военнослужащим.");
        return 1;
    }

    AD_ShowMainMenu(playerid);
    return 1;
}

stock AD_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == AD_DIALOG_MAIN)
    {
        if(!response) return 1;
        if(GetPlayerTeamEx(playerid) != TEAM_ARMY)
        {
            SendClientMessage(playerid, 0x999999FF, ""USC"Взаимодействие доступно только военнослужащим.");
            return 1;
        }

        switch(listitem)
        {
            case 0: AD_ShowInfo(playerid);
            case 1: AD_ShowTasks(playerid);
            case 2: AD_ShowStaff(playerid);
        }
        return 1;
    }

    if(dialogid == AD_DIALOG_INFO)
    {
        return 1;
    }

    if(dialogid == AD_DIALOG_TASKS)
    {
        if(!response)
        {
            AD_ShowMainMenu(playerid);
            return 1;
        }

        if(listitem < 0 || listitem >= AD_TASK_COUNT) return 1;

        if(GetPlayerTeamEx(playerid) != TEAM_ARMY)
        {
            SendClientMessage(playerid, 0x999999FF, ""USC"Вы больше не являетесь военнослужащим.");
            return 1;
        }

        if(AD_TaskCooldown[playerid][listitem] > gettime())
        {
            SendClientMessage(playerid, 0x999999FF, ""USC"Это задание уже получено, попробуйте позже.");
            return 1;
        }

        GivePlayerMoneyEx(playerid, AD_TaskReward[listitem]);
        AD_TaskCooldown[playerid][listitem] = gettime() + AD_TASK_COOLDOWN;

        new text[160];
        format(text, sizeof text, ""USC"Задание \"%s\" выполнено! Начислено %d руб.", AD_TaskName[listitem], AD_TaskReward[listitem]);
        SendClientMessage(playerid, 0x66CC00FF, text);
        return 1;
    }

    if(dialogid == AD_DIALOG_STAFF)
    {
        return 1;
    }

    return 0;
}

