/// АВТОР СЛИВА @TomarisCRMP 

#if defined _GAME_CLUB_INCLUDED
    #endinput
#endif
#define _GAME_CLUB_INCLUDED

#define GC_MAX_PLAYERS MAX_PLAYERS

#define GC_DIALOG_MAIN       6100
#define GC_DIALOG_GAMES      6101
#define GC_DIALOG_STATS      6102
#define GC_DIALOG_RULES      6103
#define GC_DIALOG_NUMBER     6104
#define GC_DIALOG_MEMORY     6105
#define GC_DIALOG_REACTION   6106
#define GC_DIALOG_RESULT     6107

#define GC_POINTS_NUMBER     10
#define GC_POINTS_MEMORY     15
#define GC_POINTS_REACTION   5
#define GC_COOLDOWN          5

#define GC_COLOR_GREEN       0x5CFF72FF
#define GC_COLOR_RED         0xFF5555FF
#define GC_COLOR_YELLOW      0xFFD84AFF
#define GC_COLOR_WHITE       0xFFFFFFFF

// Координаты Game Club
#define GC_X                 1265.0
#define GC_Y                 -1447.0
#define GC_Z                 13.0
#define GC_INTERIOR          0
#define GC_WORLD             0

new bool:GC_Inside[GC_MAX_PLAYERS];
new GC_Points[GC_MAX_PLAYERS];
new GC_Wins[GC_MAX_PLAYERS];
new GC_Games[GC_MAX_PLAYERS];
new GC_LastGame[GC_MAX_PLAYERS];

new GC_Number[GC_MAX_PLAYERS];
new GC_MemoryNumber[GC_MAX_PLAYERS];
new GC_ReactionReady[GC_MAX_PLAYERS];

stock GC_ResetPlayer(playerid)
{
    GC_Inside[playerid] = false;
    GC_Points[playerid] = 0;
    GC_Wins[playerid] = 0;
    GC_Games[playerid] = 0;
    GC_LastGame[playerid] = 0;
    GC_Number[playerid] = 0;
    GC_MemoryNumber[playerid] = 0;
    GC_ReactionReady[playerid] = 0;
    return 1;
}

stock GC_Enter(playerid)
{
    GC_Inside[playerid] = true;

    SetPlayerInterior(playerid, GC_INTERIOR);
    SetPlayerVirtualWorld(playerid, GC_WORLD);

    SetPlayerPos(playerid, GC_X, GC_Y, GC_Z);
    SetCameraBehindPlayer(playerid);

    SendClientMessage(
        playerid,
        GC_COLOR_GREEN,
        "Game Club: Добро пожаловать!"
    );

    GC_ShowMain(playerid);
    return 1;
}

stock GC_Exit(playerid)
{
    GC_Inside[playerid] = false;

    SendClientMessage(
        playerid,
        GC_COLOR_YELLOW,
        "Game Club: Вы вышли из клуба."
    );

    return 1;
}

stock GC_ShowMain(playerid)
{
    ShowPlayerDialog(
        playerid,
        GC_DIALOG_MAIN,
        DIALOG_STYLE_LIST,
        "Game Club",
        "Игры\nМоя статистика\nПравила\nВыйти",
        "Выбрать",
        "Закрыть"
    );

    return 1;
}

stock GC_ShowGames(playerid)
{
    ShowPlayerDialog(
        playerid,
        GC_DIALOG_GAMES,
        DIALOG_STYLE_LIST,
        "Game Club - Мини-игры",
        "Угадай число\nЗапомни число\nБыстрая реакция",
        "Играть",
        "Назад"
    );

    return 1;
}

stock GC_CanPlay(playerid)
{
    if(!GC_Inside[playerid])
    {
        SendClientMessage(
            playerid,
            GC_COLOR_RED,
            "Вы не находитесь в Game Club."
        );

        return 0;
    }

    new passed = gettime() - GC_LastGame[playerid];

    if(passed < GC_COOLDOWN)
    {
        new message[96];

        format(
            message,
            sizeof(message),
            "Подождите %d сек. перед следующей игрой.",
            GC_COOLDOWN - passed
        );

        SendClientMessage(
            playerid,
            GC_COLOR_RED,
            message
        );

        return 0;
    }

    GC_LastGame[playerid] = gettime();
    GC_Games[playerid]++;

    return 1;
}

stock GC_StartNumber(playerid)
{
    if(!GC_CanPlay(playerid))
        return 1;

    GC_Number[playerid] = random(10) + 1;

    ShowPlayerDialog(
        playerid,
        GC_DIALOG_NUMBER,
        DIALOG_STYLE_INPUT,
        "Game Club - Угадай число",
        "Я загадал число от 1 до 10.\n\nВведите свой вариант:",
        "Проверить",
        "Отмена"
    );

    return 1;
}

stock GC_StartMemory(playerid)
{
    if(!GC_CanPlay(playerid))
        return 1;

    GC_MemoryNumber[playerid] = random(9000) + 1000;

    new text[256];

    format(
        text,
        sizeof(text),
        "Запомните число:\n\n%d\n\n"
        "Нажмите «Далее», когда запомните его.",
        GC_MemoryNumber[playerid]
    );

    ShowPlayerDialog(
        playerid,
        GC_DIALOG_MEMORY,
        DIALOG_STYLE_MSGBOX,
        "Game Club - Память",
        text,
        "Далее",
        "Отмена"
    );

    return 1;
}

stock GC_StartReaction(playerid)
{
    if(!GC_CanPlay(playerid))
        return 1;

    GC_ReactionReady[playerid] = 1;

    ShowPlayerDialog(
        playerid,
        GC_DIALOG_REACTION,
        DIALOG_STYLE_MSGBOX,
        "Game Club - Реакция",
        "Нажмите «Готово» как можно быстрее.",
        "Готово",
        "Отмена"
    );

    return 1;
}

stock GC_ShowStats(playerid)
{
    new text[256];

    new percent = 0;

    if(GC_Games[playerid] > 0)
        percent =
            GC_Wins[playerid] * 100 / GC_Games[playerid];

    format(
        text,
        sizeof(text),
        "Ваша статистика:\n\n"
        "Очки: %d\n"
        "Победы: %d\n"
        "Всего игр: %d\n"
        "Процент побед: %d%%",
        GC_Points[playerid],
        GC_Wins[playerid],
        GC_Games[playerid],
        percent
    );

    ShowPlayerDialog(
        playerid,
        GC_DIALOG_STATS,
        DIALOG_STYLE_MSGBOX,
        "Game Club - Статистика",
        text,
        "Назад",
        ""
    );

    return 1;
}

stock GC_ShowRules(playerid)
{
    ShowPlayerDialog(
        playerid,
        GC_DIALOG_RULES,
        DIALOG_STYLE_MSGBOX,
        "Game Club - Правила",
        "1. Все мини-игры бесплатные.\n"
        "2. За победы начисляются очки.\n"
        "3. Между играми действует задержка.\n"
        "4. Запрещены баги и сторонние программы.",
        "