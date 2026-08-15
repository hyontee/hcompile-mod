#include <a_samp>

#define MAX_TASKS 8
#define BP_PER_TASK 500
#define BLACK_PASS_COST_BC 100 // Стоимость Блек Пасса в Блек Коинах
#define BLACK_PASS_COST_RUB 250000 // Стоимость Блек Пасса в рублях

#define COLOR_GREEN 0x09FF00FF
#define DIALOG_BP   22222
#define DIALOG_TASKS   22220
#define DIALOG_REWARD_BP   22221

new g_Tasks[MAX_TASKS][128]; // Массив заданий
new g_PlayerBP[MAX_PLAYERS]; // Очки Блек Пасса для игроков
new g_PlayerHasBP[MAX_PLAYERS]; // Флаг наличия Блек Пасса у игрока
new g_PlayerBC[MAX_PLAYERS]; // Блек Коины у игроков
new g_PlayerMoney[MAX_PLAYERS]; // Игровая валюта у игроков

// Награды
new g_Rewards[][128] = {
    {"20000?"},
    {"30000?"},
    {"40000?"},
    {"50000?"},
    {"Gold VIP на 3ч"},
    {"Silver VIP на 3ч"},
    {"1000 BP очков"},
    {"15000?"},
    {"Скин 95"},
    {"Машина ID 466"},
    {"25000?"},
    {"10000?"},
    {"Скин ID 24"},
    {"500 BP очков"},
    {"100000?"}
};

// Инициализация заданий
public OnGameModeInit() {
    UpdateTasks(); // Обновляем задания при старте игры

    // Начальная инициализация игроков
    for(new i = 0; i < MAX_PLAYERS; i++) {
        g_PlayerBP[i] = 0;
        g_PlayerHasBP[i] = false;
        g_PlayerBC[i] = 0; // Инициализация Блек Коинов (например, можно добавить логику получения)
        g_PlayerMoney[i] = 0; // Инициализация игровой валюты
    }
    #if defined bp_OnGameModeInit
        return bp_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit bp_OnGameModeInit
#if defined bp_OnGameModeInit
    forward bp_OnGameModeInit();
#endif

stock strcpy(dest[], const source[], pos = 0, maxlength = sizeof dest)
    return strins((dest[0] = EOS, dest), source, pos, maxlength);

// Обновление заданий каждые 12 часов
public UpdateTasks() {
    // Пример заданий (половина легких, половина трудных)
    strcpy(g_Tasks[0], "Собрать 10 трав");
    strcpy(g_Tasks[1], "Пробежать 1 км");
    strcpy(g_Tasks[2], "Убить 5 врагов");
    strcpy(g_Tasks[3], "Собрать 5 предметов");
    
    strcpy(g_Tasks[4], "Завершить миссию за 5 минут");
    strcpy(g_Tasks[5], "Убить босса без урона");
    strcpy(g_Tasks[6], "Пробежать марафон за 10 минут");
    strcpy(g_Tasks[7], "Собрать редкие предметы");

    // Логика для обновления заданий каждую половину суток должна быть реализована здесь
}


    
// Открытие меню Блек Пасса
public ShowBlackPassMenu(playerid) {
    new dialog[1024];
    format(dialog, sizeof(dialog), "Блек Пасс\n\n");

    for(new i = 0; i < MAX_TASKS; i++) {
        format(dialog, sizeof(dialog), "%s%d. %s\n", dialog, i + 1, g_Tasks[i]);
    }
    
    format(dialog, sizeof(dialog), "%s\nВыберите задание, чтобы выполнить его.", dialog);
    
    ShowPlayerDialog(playerid, DIALOG_BP, DIALOG_STYLE_LIST, "Блек Пасс", dialog, "Выбрать", "Закрыть");
}

// Выполнение задания игроком
public CompleteTask(playerid, taskid) {
    if(taskid < 0 || taskid >= MAX_TASKS) return;

    // Начисление очков
    g_PlayerBP[playerid] += BP_PER_TASK;
    
    // Логика уведомления игрока о выполнении задания
    SendClientMessage(playerid, COLOR_GREEN, "Вы выполнили задание и получили 500 BP!");
}

// Получение награды
public ClaimReward(playerid, rewardid) {
    if(rewardid < 0 || rewardid >= sizeof(g_Rewards)) return;

    // Логика выдачи награды игроку
    SendClientMessage(playerid, COLOR_YELLOW, "Вы получили награду: %s", g_Rewards[rewardid]);
}

// Команда /bp для открытия меню Блек Пасса
public OnPlayerCommandText(playerid, cmdtext[]) {
    if(strcmp(cmdtext, "/bp", true) == 0) {
        if (!g_PlayerHasBP[playerid]) {
            SendClientMessage(playerid, COLOR_RED, "У вас нет Блек Пасса. Купите его за 100 BC или 250000?.");
            return 1;
        }
        ShowBlackPassMenu(playerid);
        return 1;
    }
    
    if(strcmp(cmdtext, "/rewardbp", true) == 0) {
        new dialog[1024];
        format(dialog, sizeof(dialog), "Награды Блек Пасса\n\n");

        for(new i = 0; i < sizeof(g_Rewards); i++) {
            format(dialog, sizeof(dialog), "%s%d. %s\n", dialog, i + 1, g_Rewards[i]);
        }
        
        ShowPlayerDialog(playerid, DIALOG_REWARD_BP, DIALOG_STYLE_MSGBOX, "Награды Блек Пасса", dialog, "Закрыть", "");
        return 1;
        
            }

    if(strcmp(cmdtext, "/bptasks", true) == 0) {
        new dialog[1024];
        format(dialog, sizeof(dialog), "Задания Блек Пасса\n\n");

        for(new i = 0; i < MAX_TASKS; i++) {
            format(dialog, sizeof(dialog), "%s%d. %s\n", dialog, i + 1, g_Tasks[i]);
        }
        
        ShowPlayerDialog(playerid, DIALOG_TASKS, DIALOG_STYLE_MSGBOX, "Задания Блек Пасса", dialog, "Закрыть", "");
        return 1;
    }

    if(strcmp(cmdtext, "/buybpcoin", true) == 0) {
        if (g_PlayerBC[playerid] < BLACK_PASS_COST_BC) {
            SendClientMessage(playerid, COLOR_RED, "Недостаточно Блек Коинов для покупки Блек Пасса.");
            return 1;
        }

        g_PlayerBC[playerid] -= BLACK_PASS_COST_BC;
        g_PlayerHasBP[playerid] = true;
        SendClientMessage(playerid, COLOR_GREEN, "Вы купили Блек Пасс за %d BC!", BLACK_PASS_COST_BC);
        return 1;
    }

    if(strcmp(cmdtext, "/buybpiv", true) == 0) {
        if (g_PlayerMoney[playerid] < BLACK_PASS_COST_RUB) {
            SendClientMessage(playerid, COLOR_RED, "Недостаточно денег для покупки Блек Пасса.");
            return 1;
        }

        g_PlayerMoney[playerid] -= BLACK_PASS_COST_RUB;
        g_PlayerHasBP[playerid] = true;
        SendClientMessage(playerid, COLOR_GREEN, "Вы купили Блек Пасс за %d?!", BLACK_PASS_COST_RUB);
        return 1;
    }

    if(strcmp(cmdtext, "/givefullbp", true) == 0) {
        if(GetPlayerAdminEx(playerid) < 12) return 0; // Проверка уровня администрирования

        new targetPlayer;
        if(!sscanf(cmdtext, "{s[23]}d", targetPlayer)) {
            g_PlayerBP[targetPlayer] += BP_PER_TASK * MAX_TASKS; // Выдаем все очки Блек Пасса
            SendClientMessage(targetPlayer, COLOR_GREEN, "Администратор выдал вам полный Блек Пасс!");
            SendClientMessage(playerid, COLOR_YELLOW, "Вы выдали полный Блек Пасс игроку %d.", targetPlayer);
            return 1;
        }
    }
    #if defined bp_OnPlayerCommandText
        return bp_OnPlayerCommandText(playerid, cmdtext);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText bp_OnPlayerCommandText
#if defined bp_OnPlayerCommandText
    forward bp_OnPlayerCommandText(playerid, cmdtext[]);
#endif
// Обработка выбора задания из меню Блек Пасса
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_BP && response) {
        new selectedTask;
        //GetPlayerDialogResponse(playerid, selectedTask);
        CompleteTask(playerid, listitem); // Индексирование с нуля
        return 1;
    }
    #if defined bp_OnDialogResponse
return bp_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse bp_OnDialogResponse
#if defined bp_OnDialogResponse
forward bp_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif