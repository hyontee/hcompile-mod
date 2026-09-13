#if defined _DIVER_SYSTEM_INCLUDED
    #endinput
#endif
#define _DIVER_SYSTEM_INCLUDED

// ============================================================
//                  SYSTEM VODOLAZ 
                    TOMARIS X LINE
                    tg @Tomariscrmp X LineStudio001
// ============================================================

// ---------- Настройки ----------
#define DIVER_JOB_SKIN             261
#define DIVER_VEHICLE_MODEL        422

#define DIVER_MIN_REWARD           1500
#define DIVER_MAX_REWARD           3500

#define DIVER_SEARCH_TIME          15
#define DIVER_OBJECTS_COUNT        8

#define DIVER_START_X              2227.84
#define DIVER_START_Y              -2287.61
#define DIVER_START_Z              14.76

// Точка выхода/сдачи груза
#define DIVER_FINISH_X             2224.43
#define DIVER_FINISH_Y             -2284.18
#define DIVER_FINISH_Z             14.76

// ---------- Цвета ----------
#define DIVER_COLOR                0x00BFFFFF
#define DIVER_GREEN                0x33CC66FF
#define DIVER_RED                  0xFF4444FF
#define DIVER_WHITE                0xFFFFFFFF
#define DIVER_YELLOW               0xFFFF00FF

// ---------- Переменные ----------
new bool:DiverWorking[MAX_PLAYERS];
new bool:DiverSearching[MAX_PLAYERS];
new DiverFound[MAX_PLAYERS];

new DiverSearchTimer[MAX_PLAYERS];
new DiverMarker[MAX_PLAYERS];

new DiverVehicle[MAX_PLAYERS];


// ============================================================
//                  ИНИЦИАЛИЗАЦИЯ
// ============================================================

stock Diver_Init()
{
    print("----------------------------------------");
    print("DIVER JOB SYSTEM: loaded");
    print("----------------------------------------");

    return 1;
}


// ============================================================
//                  НАЧАЛО РАБОТЫ
// ============================================================

stock Diver_StartJob(playerid)
{
    if (DiverWorking[playerid])
    {
        SendClientMessage(playerid, DIVER_RED,
            "Вы уже работаете водолазом.");
        return 0;
    }

    DiverWorking[playerid] = true;
    DiverSearching[playerid] = false;
    DiverFound[playerid] = 0;

    SetPlayerSkin(playerid, DIVER_JOB_SKIN);

    SendClientMessage(playerid, DIVER_GREEN,
        "Вы начали работу водолазом.");

    SendClientMessage(playerid, DIVER_WHITE,
        "Отправляйтесь к месту погружения.");

    SendClientMessage(playerid, DIVER_YELLOW,
        "Найдите под водой груз и доставьте его обратно.");

    SetPlayerCheckpoint(
        playerid,
        2221.20,
        -2290.10,
        0.50,
        3.0
    );

    return 1;
}


// ============================================================
//                  ЗАВЕРШЕНИЕ РАБОТЫ
// ============================================================

stock Diver_StopJob(playerid)
{
    if (!DiverWorking[playerid])
    {
        SendClientMessage(playerid, DIVER_RED,
            "Вы не работаете водолазом.");
        return 0;
    }

    DiverWorking[playerid] = false;
    DiverSearching[playerid] = false;
    DiverFound[playerid] = 0;

    if (DiverSearchTimer[playerid] != 0)
    {
        KillTimer(DiverSearchTimer[playerid]);
        DiverSearchTimer[playerid] = 0;
    }

    DisablePlayerCheckpoint(playerid);

    SendClientMessage(playerid, DIVER_WHITE,
        "Вы закончили работу водолазом.");

    return 1;
}


// ============================================================
//                  ПОИСК ГРУЗА
// ============================================================

stock Diver_StartSearch(playerid)
{
    if (!DiverWorking[playerid])
    {
        SendClientMessage(playerid, DIVER_RED,
            "Вы не работаете водолазом.");
        return 0;
    }

    if (DiverSearching[playerid])
    {
        SendClientMessage(playerid, DIVER_YELLOW,
            "Вы уже ищете груз.");
        return 0;
    }

    DiverSearching[playerid] = true;

    SendClientMessage(playerid, DIVER_COLOR,
        "Вы начали поиск под водой.");

    SendClientMessage(playerid, DIVER_WHITE,
        "Поиск займёт некоторое время...");

    DiverSearchTimer[playerid] =
        SetTimerEx("Diver_SearchFinished", DIVER_SEARCH_TIME * 1000, false, "i", playerid);

    return 1;
}


// ============================================================
//                  РЕЗУЛЬТАТ ПОИСКА
// ============================================================

forward Diver_SearchFinished(playerid);

public Diver_SearchFinished(playerid)
{
    if (!IsPlayerConnected(playerid))
        return 0;

    DiverSearchTimer[playerid] = 0;
    DiverSearching[playerid] = false;

    if (!DiverWorking[playerid])
        return 0;

    DiverFound[playerid]++;

    new string[144];

    format(
        string,
        sizeof(string),
        "Груз найден! Всего найдено: %d/%d.",
        DiverFound[playerid],
        DIVER_OBJECTS_COUNT
    );

    SendClientMessage(playerid, DIVER_GREEN, string);

    if (DiverFound[playerid] >= DIVER_OBJECTS_COUNT)
    {
        SendClientMessage(
            playerid,
            DIVER_YELLOW,
            "Вы собрали весь груз. Вернитесь к месту сдачи."
        );

        SetPlayerCheckpoint(
            playerid,
            DIVER_FINISH_X,
            DIVER_FINISH_Y,
            DIVER_FINISH_Z,
            3.0
        );
    }
    else
    {
        SetPlayerCheckpoint(
            playerid,
            2221.20,
            -2290.10,
            0.50,
            3.0
        );
    }

    return 1;
}


// ============================================================
//                  СДАЧА ГРУЗА
// ============================================================

stock Diver_FinishJob(playerid)
{
    if (!DiverWorking[playerid])
    {
        SendClientMessage(playerid, DIVER_RED,
            "Вы не работаете водолазом.");
        return 0;
    }

    if (DiverFound[playerid] < DIVER_OBJECTS_COUNT)
    {
        SendClientMessage(
            playerid,
            DIVER_RED,
            "Вы ещё не собрали весь груз."
        );

        return 0;
    }

    new reward =
        random(DIVER_MAX_REWARD - DIVER_MIN_REWARD + 1)
        + DIVER_MIN_REWARD;

    // --------------------------------------------------------
    // ВАЖНО:
    // Здесь используется GivePlayerMoney.
    // Если в твоём моде своя система денег,
    // замени эту строку на свою функцию.
    // --------------------------------------------------------

    GivePlayerMoney(playerid, reward);

    new string[144];

    format(
        string,
        sizeof(string),
        "Работа завершена! Вы получили $%d.",
        reward
    );

    SendClientMessage(playerid, DIVER_GREEN, string);

    DiverFound[playerid] = 0;

    SetPlayerCheckpoint(
        playerid,
        2221.20,
        -2290.10,
        0.50,
        3.0
    );

    return 1;
}


// ============================================================
//                  КОМАНДА /DIVER
// ============================================================

stock Diver_Command(playerid)
{
    if (!DiverWorking[playerid])
    {
        Diver_StartJob(playerid);
    }
    else
    {
        Diver_StopJob(playerid);
    }

    return 1;
}


// ============================================================
//                  CHECKPOINT
// ============================================================

stock Diver_Checkpoint(playerid)
{
    if (!DiverWorking[playerid])
        return 0;

    if (DiverFound[playerid] >= DIVER_OBJECTS_COUNT)
    {
        Diver_FinishJob(playerid);
        return 1;
    }

    Diver_StartSearch(playerid);

    return 1;
}


// ============================================================
//                  ОЧИСТКА ИГРОКА
// ============================================================

stock Diver_PlayerDisconnect(playerid)
{
    if (DiverSearchTimer[playerid] != 0)
    {
        KillTimer(DiverSearchTimer[playerid]);
        DiverSearchTimer[playerid] = 0;
    }

    DiverWorking[playerid] = false;
    DiverSearching[playerid] = false;
    DiverFound[playerid] = 0;

    return 1;
}


// ============================================================
//                  ИНФОРМАЦИЯ
// ============================================================

stock Diver_ShowInfo(playerid)
{
    new string[512];

    format(
        string,
        sizeof(string),
        "\
        {00BFFFFF}ВОДОЛАЗ\n\n\
        {FFFFFF}Работа: {33CC66}%s\n\
        {FFFFFF}Найдено груза: {FFFF00}%d/%d\n\n\
        {FFFFFF}За каждый полный рейс вы получите:\n\
        {33CC66}$%d - $%d\n\n\
        {FFFFFF}Команда: {FFFF00}/diver",
        DiverWorking[playerid] ? ("работаете") : ("не работаете"),
        DiverFound[playerid],
        DIVER_OBJECTS_COUNT,
        DIVER_MIN_REWARD,
        DIVER_MAX_REWARD
    );

    ShowPlayerDialog(
        playerid,
        9811,
        DIALOG_STYLE_MSGBOX,
        "Работа водолазом",
        string,
        "Закрыть",
        ""
    );

    return 1;
}