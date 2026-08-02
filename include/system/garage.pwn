// ---------------------------------------------------------------------------
// СИСТЕМА ЕЖЕДНЕВНЫХ ЗАДАНИЙ - С ФИКСОМ РУССКОГО ТЕКСТА
// ---------------------------------------------------------------------------
// ---------- ФИКС РУССКОГО ТЕКСТА В ДИАЛОГАХ ----------
stock ShowDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
    new cap[128], inf[512], btn1[32], btn2[32];
    
    format(cap, sizeof(cap), "%s", caption);
    format(inf, sizeof(inf), "%s", info);
    format(btn1, sizeof(btn1), "%s", button1);
    format(btn2, sizeof(btn2), "%s", button2);
    
    return ShowPlayerDialog(playerid, dialogid, style, cap, inf, btn1, btn2);
}
// ---------- НАСТРОЙКИ ----------
#define DAILY_RESET_TIME    86400
#define MAX_QUESTS_PER_DAY   3

// ---------- ТИПЫ ЗАДАНИЙ ----------
#define QUEST_TYPE_MONEY     1
#define QUEST_TYPE_HANDSHAKE 2

// ---------- ID ДИАЛОГОВ ----------
#define DIALOG_DAILY_MAIN    4500
#define DIALOG_DAILY_QUEST   4501

// ---------- ПРОСТЫЕ МАССИВЫ ----------
new g_PlayerQuestActive[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerQuestType[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerQuestProgress[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerQuestTarget[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerQuestName[MAX_PLAYERS][MAX_QUESTS_PER_DAY][32];
new g_PlayerQuestDesc[MAX_PLAYERS][MAX_QUESTS_PER_DAY][128];
new g_PlayerQuestReward[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerQuestCompleted[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerQuestClaimed[MAX_PLAYERS][MAX_QUESTS_PER_DAY];
new g_PlayerLastUpdate[MAX_PLAYERS];

// ---------- ФУНКЦИИ ----------

// Обновить задания
stock UpdatePlayerDailyQuests(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    new current_time = gettime();
    
    if(current_time - g_PlayerLastUpdate[playerid] < DAILY_RESET_TIME && g_PlayerLastUpdate[playerid] != 0)
    {
        return 0;
    }
    
    g_PlayerLastUpdate[playerid] = current_time;
    
    for(new i = 0; i < MAX_QUESTS_PER_DAY; i++)
    {
        new rand = random(4);
        
        g_PlayerQuestActive[playerid][i] = 1;
        g_PlayerQuestProgress[playerid][i] = 0;
        g_PlayerQuestCompleted[playerid][i] = 0;
        g_PlayerQuestClaimed[playerid][i] = 0;
        
        if(rand == 0)
        {
            g_PlayerQuestType[playerid][i] = QUEST_TYPE_MONEY;
            g_PlayerQuestTarget[playerid][i] = 5000;
            g_PlayerQuestReward[playerid][i] = 15000;
            format(g_PlayerQuestName[playerid][i], 32, "Банкир");
            format(g_PlayerQuestDesc[playerid][i], 128, "Передайте деньги другому игроку");
        }
        else if(rand == 1)
        {
            g_PlayerQuestType[playerid][i] = QUEST_TYPE_MONEY;
            g_PlayerQuestTarget[playerid][i] = 10000;
            g_PlayerQuestReward[playerid][i] = 30000;
            format(g_PlayerQuestName[playerid][i], 32, "Щедрый");
            format(g_PlayerQuestDesc[playerid][i], 128, "Передайте крупную сумму");
        }
        else if(rand == 2)
        {
            g_PlayerQuestType[playerid][i] = QUEST_TYPE_HANDSHAKE;
            g_PlayerQuestTarget[playerid][i] = 3;
            g_PlayerQuestReward[playerid][i] = 5000;
            format(g_PlayerQuestName[playerid][i], 32, "Дружелюбный");
            format(g_PlayerQuestDesc[playerid][i], 128, "Пожмите руку 3 игрокам");
        }
        else if(rand == 3)
        {
            g_PlayerQuestType[playerid][i] = QUEST_TYPE_HANDSHAKE;
            g_PlayerQuestTarget[playerid][i] = 5;
            g_PlayerQuestReward[playerid][i] = 8000;
            format(g_PlayerQuestName[playerid][i], 32, "Компанейский");
            format(g_PlayerQuestDesc[playerid][i], 128, "Пожмите руку 5 игрокам");
        }
    }
    
    SendClientMessage(playerid, 0x33AA33FF, "Новые ежедневные задания доступны! Введите /daily");
    return 1;
}

// Проверить прогресс
stock CheckQuestProgress(playerid, quest_type, value = 1)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    UpdatePlayerDailyQuests(playerid);
    
    for(new i = 0; i < MAX_QUESTS_PER_DAY; i++)
    {
        if(g_PlayerQuestActive[playerid][i] && g_PlayerQuestCompleted[playerid][i] == 0 && g_PlayerQuestType[playerid][i] == quest_type)
        {
            g_PlayerQuestProgress[playerid][i] += value;
            
            if(g_PlayerQuestProgress[playerid][i] >= g_PlayerQuestTarget[playerid][i])
            {
                g_PlayerQuestProgress[playerid][i] = g_PlayerQuestTarget[playerid][i];
                g_PlayerQuestCompleted[playerid][i] = 1;
                
                new str[128];
                format(str, sizeof(str), "Задание '%s' выполнено! Заберите награду в /daily", g_PlayerQuestName[playerid][i]);
                SendClientMessage(playerid, 0x33AA33FF, str);
                PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
            }
        }
    }
    return 1;
}

// Получить награду
stock ClaimQuestReward(playerid, slot)
{
    if(slot < 0 || slot >= MAX_QUESTS_PER_DAY) return 0;
    
    if(g_PlayerQuestCompleted[playerid][slot] == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Задание еще не выполнено!");
        return 0;
    }
    
    if(g_PlayerQuestClaimed[playerid][slot] != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Награда уже получена!");
        return 0;
    }
    
    new money = g_PlayerQuestReward[playerid][slot];
    new name[32];
    format(name, 32, g_PlayerQuestName[playerid][slot]);
    
    // Выдаем деньги
    new reason[128];
    format(reason, sizeof(reason), "Награда за задание %s", name);
    GivePlayerMoneyEx(playerid, money, reason, true, true);
    
    g_PlayerQuestClaimed[playerid][slot] = 1;
    g_PlayerQuestActive[playerid][slot] = 0;
    
    new str[128];
    format(str, sizeof(str), "Награда за '%s': +%d$", name, money);
    SendClientMessage(playerid, 0x33AA33FF, str);
    
    return 1;
}

// Показать меню
stock ShowDailyMenu(playerid)
{
    UpdatePlayerDailyQuests(playerid);
    
    new str[1024];
    new header[64];
    format(header, sizeof(header), "Ежедневные задания | %s", GetPlayerNameEx(playerid));
    
    strcat(str, "Задание\tПрогресс\tСтатус\n");
    
    for(new i = 0; i < MAX_QUESTS_PER_DAY; i++)
    {
        if(g_PlayerQuestActive[playerid][i])
        {
            new status[32];
            new progress[32];
            
            if(g_PlayerQuestCompleted[playerid][i] == 1)
            {
                if(g_PlayerQuestClaimed[playerid][i] == 1)
                    status = "{FF0000}Награда получена";
                else
                    status = "{33AA33}Выполнено!";
            }
            else
            {
                status = "{FFFF00}В процессе";
            }
            
            format(progress, sizeof(progress), "%d/%d", g_PlayerQuestProgress[playerid][i], g_PlayerQuestTarget[playerid][i]);
            format(str, sizeof(str), "%s%s\t%s\t%s\n", str, g_PlayerQuestName[playerid][i], progress, status);
        }
    }
    
    // ИСПОЛЬЗУЕМ ShowDialog ВМЕСТО ShowPlayerDialog
    ShowDialog(playerid, DIALOG_DAILY_MAIN, DIALOG_STYLE_TABLIST_HEADERS, header, str, "Выбрать", "Закрыть");
    return 1;
}

// Показать инфо
stock ShowQuestInfo(playerid, slot)
{
    new str[512];
    
    format(str, sizeof(str),
        "{FFFFFF}Название: {33AA33}%s\n\
        {FFFFFF}Описание: {FFFF00}%s\n\
        {FFFFFF}Прогресс: {FFFF00}%d/%d\n\
        \n\
        {FFFFFF}Награда: {33AA33}+%d$\n\
        \n\
        {FFFFFF}Статус: ",
        g_PlayerQuestName[playerid][slot],
        g_PlayerQuestDesc[playerid][slot],
        g_PlayerQuestProgress[playerid][slot],
        g_PlayerQuestTarget[playerid][slot],
        g_PlayerQuestReward[playerid][slot]);
    
    if(g_PlayerQuestCompleted[playerid][slot] == 1)
    {
        if(g_PlayerQuestClaimed[playerid][slot] == 1)
            strcat(str, "{FF0000}Награда получена");
        else
            strcat(str, "{33AA33}Выполнено (можно получить награду)");
    }
    else
    {
        strcat(str, "{FFFF00}В процессе выполнения");
    }
    
    if(g_PlayerQuestCompleted[playerid][slot] == 1 && g_PlayerQuestClaimed[playerid][slot] == 0)
    {
        // ИСПОЛЬЗУЕМ ShowDialog ВМЕСТО ShowPlayerDialog
        ShowDialog(playerid, DIALOG_DAILY_QUEST, DIALOG_STYLE_MSGBOX, g_PlayerQuestName[playerid][slot], str, "Получить", "Назад");
    }
    else
    {
        // ИСПОЛЬЗУЕМ ShowDialog ВМЕСТО ShowPlayerDialog
        ShowDialog(playerid, DIALOG_DAILY_QUEST, DIALOG_STYLE_MSGBOX, g_PlayerQuestName[playerid][slot], str, "Назад", "");
    }
    
    return 1;
}

// ---------- КОМАНДА ----------
CMD:daily(playerid, params[])
{
    ShowDailyMenu(playerid);
    return 1;
}