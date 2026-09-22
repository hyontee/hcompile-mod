#if defined _GOLDEN_TRACE_EVENT
    #endinput
#endif
#define _GOLDEN_TRACE_EVENT

/*
    ============================================================
    EVENT: "ПРОВОДНИК ЗОЛОТОГО СЛЕДА"
    Интеграция для bykranin.pwn
    Версия: 1.0

    Команда: /golden
    Срок события: до 30.11.2026

    Все координаты и награды находятся в начале файла.
    ============================================================
*/

#define GOLDEN_COLOR_WHITE       (0xFFFFFFFF)
#define GOLDEN_COLOR_GREEN       (0x55FF55FF)
#define GOLDEN_COLOR_RED         (0xFF5555FF)
#define GOLDEN_COLOR_YELLOW      (0xFFFF00FF)
#define GOLDEN_COLOR_GREY        (0xAAAAAAFF)

#define GOLDEN_EVENT_START_X       (1532.50)
#define GOLDEN_EVENT_START_Y       (-1674.30)
#define GOLDEN_EVENT_START_Z       (13.55)

#define GOLDEN_EVENT_CLUE1_X      (1277.00)
#define GOLDEN_EVENT_CLUE1_Y      (-1340.00)
#define GOLDEN_EVENT_CLUE1_Z      (13.00)

#define GOLDEN_EVENT_CLUE2_X      (1150.00)
#define GOLDEN_EVENT_CLUE2_Y      (-1180.00)
#define GOLDEN_EVENT_CLUE2_Z      (32.00)

#define GOLDEN_EVENT_CLUE3_X      (1070.00)
#define GOLDEN_EVENT_CLUE3_Y      (-1050.00)
#define GOLDEN_EVENT_CLUE3_Z      (31.00)

#define GOLDEN_EVENT_REWARD       (25000)
#define GOLDEN_EVENT_CP_SIZE      (3.0)

#define GOLDEN_DIALOG_START       (49600)
#define GOLDEN_DIALOG_CLUE1       (49601)
#define GOLDEN_DIALOG_CLUE2       (49602)
#define GOLDEN_DIALOG_CLUE3       (49603)
#define GOLDEN_DIALOG_FINISH      (49604)
#define GOLDEN_DIALOG_INFO        (49605)

new bool:g_GoldenActive[MAX_PLAYERS];
new g_GoldenStage[MAX_PLAYERS];
new g_GoldenPickup = -1;
new g_GoldenReturnPickup = -1;

forward GoldenEvent_LoadPlayer(playerid);
forward GoldenEvent_LoadDB(playerid);
forward GoldenEvent_Save(playerid);

stock GoldenEvent_IsAvailable()
{
    new year, month, day;
    getdate(year, month, day);

    if(year > 2026) return 0;
    if(year == 2026 && month > 11) return 0;
    if(year == 2026 && month == 11 && day > 30) return 0;

    return 1;
}

stock GoldenEvent_ResetPlayer(playerid)
{
    g_GoldenActive[playerid] = false;
    g_GoldenStage[playerid] = 0;
    DeletePVar(playerid, "golden_stage");
    DeletePVar(playerid, "golden_loaded");
    DisablePlayerCheckpoint(playerid);
    return 1;
}

stock GoldenEvent_GetStage(playerid)
{
    return g_GoldenStage[playerid];
}

stock GoldenEvent_SetStage(playerid, stage)
{
    g_GoldenStage[playerid] = stage;
    SetPVarInt(playerid, "golden_stage", stage);
    return 1;
}

stock GoldenEvent_ShowStart(playerid)
{
    ShowPlayerDialog(
        playerid,
        GOLDEN_DIALOG_START,
        DIALOG_STYLE_MSGBOX,
        "Проводник \"Золотого следа\"",
        "Старый тракт редко бывает тихим, но после последней грозы\n\
там произошло что-то странное. Связь пропала, на дороге\n\
остались свежие следы, а несколько человек слышали машину\n\
глубокой ночью.\n\n\
Я не знаю, что именно случилось. Лесник Григорий был рядом\n\
одним из первых. Если хотите узнать, что произошло —\n\
я покажу вам, с чего начать поиски.",
        "Далее",
        "Позже"
    );
    return 1;
}

stock GoldenEvent_SetCheckpoint(playerid, Float:x, Float:y, Float:z)
{
    SetPlayerCheckpoint(playerid, x, y, z, GOLDEN_EVENT_CP_SIZE);
    return 1;
}

stock GoldenEvent_Start(playerid)
{
    if(!GoldenEvent_IsAvailable())
    {
        SendClientMessage(playerid, GOLDEN_COLOR_RED, "Событие \"Золотой след\" уже завершено.");
        return 1;
    }

    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, GOLDEN_COLOR_RED, "Сначала авторизуйтесь.");
        return 1;
    }

    if(!IsPlayerInRangeOfPoint(playerid, 4.0,
        GOLDEN_EVENT_START_X,
        GOLDEN_EVENT_START_Y,
        GOLDEN_EVENT_START_Z))
    {
        SendClientMessage(playerid, GOLDEN_COLOR_GREY,
            "Подойдите к проводнику \"Золотого следа\".");
        return 1;
    }

    if(g_GoldenActive[playerid])
    {
        SendClientMessage(playerid, GOLDEN_COLOR_YELLOW,
            "Вы уже проходите это событие.");
        return 1;
    }

    if(g_GoldenStage[playerid] >= 5)
    {
        SendClientMessage(playerid, GOLDEN_COLOR_YELLOW,
            "Вы уже завершили \"Золотой след\".");
        return 1;
    }

    g_GoldenActive[playerid] = true;

    if(g_GoldenStage[playerid] <= 0)
    {
        GoldenEvent_SetStage(playerid, 1);
        GoldenEvent_Save(playerid);
    }

    GoldenEvent_ShowStart(playerid);
    return 1;
}

stock GoldenEvent_ShowClue1(playerid)
{
    ShowPlayerDialog(
        playerid,
        GOLDEN_DIALOG_CLUE1,
        DIALOG_STYLE_MSGBOX,
        "Золотой след — старая дорога",
        "Вы добрались до старого тракта.\n\n\
На земле действительно видны свежие следы шин. Они уходят\n\
в сторону леса. Рядом лежит небольшой металлический предмет.\n\n\
Заберите улику и продолжайте расследование.",
        "Продолжить",
        "Позже"
    );
    return 1;
}

stock GoldenEvent_ShowClue2(playerid)
{
    ShowPlayerDialog(
        playerid,
        GOLDEN_DIALOG_CLUE2,
        DIALOG_STYLE_MSGBOX,
        "Золотой след — лес",
        "Следы привели вас глубже в лес.\n\n\
Здесь вы нашли повреждённую рацию. Последний сигнал был\n\
передан именно отсюда. Значит, Григорий был совсем рядом.\n\n\
Осмотрите следующую точку.",
        "Продолжить",
        "Позже"
    );
    return 1;
}

stock GoldenEvent_ShowClue3(playerid)
{
    ShowPlayerDialog(
        playerid,
        GOLDEN_DIALOG_CLUE3,
        DIALOG_STYLE_MSGBOX,
        "Золотой след — последняя улика",
        "Под старым деревом обнаружена последняя улика.\n\n\
Теперь вы знаете, куда направился автомобиль. Но узнать\n\
всю правду сможет только Григорий.\n\n\
Вернитесь к проводнику.",
        "Вернуться",
        "Позже"
    );
    return 1;
}

stock GoldenEvent_ShowFinish(playerid)
{
    ShowPlayerDialog(
        playerid,
        GOLDEN_DIALOG_FINISH,
        DIALOG_STYLE_MSGBOX,
        "Проводник \"Золотого следа\"",
        "Вы нашли все улики и вернулись к Григорию.\n\n\
Он внимательно выслушал вас и подтвердил, что найденные\n\
следы связаны с той самой машиной.\n\n\
Расследование завершено. Проводник благодарит вас\n\
за помощь.",
        "Получить награду",
        "Позже"
    );
    return 1;
}

stock GoldenEvent_ShowInfo(playerid)
{
    new text[768];

    format(
        text,
        sizeof(text),
        "{FFFFFF}Событие: {FFA500}\"Проводник Золотого следа\"{FFFFFF}\n\n\
        Пройдите сюжетную цепочку, найдите три улики\n\
        и вернитесь к проводнику.\n\n\
        {FFFF00}Награда: {FFFFFF}$%d\n\
        {FFFF00}Доступно до: {FFFFFF}30.11.2026\n\n\
        {AAAAAA}Этап: %d/7",
        GOLDEN_EVENT_REWARD,
        g_GoldenStage[playerid]
    );

    ShowPlayerDialog(
        playerid,
        GOLDEN_DIALOG_INFO,
        DIALOG_STYLE_MSGBOX,
        "Золотой след",
        text,
        "Закрыть",
        ""
    );

    return 1;
}

public GoldenEvent_LoadPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!IsPlayerLogged(playerid))
    {
        SetTimerEx("GoldenEvent_LoadPlayer", 3000, false, "i", playerid);
        return 1;
    }

    new query[256];
    mysql_format(
        mysql,
        query,
        sizeof(query),
        "SELECT stage FROM golden_event_progress WHERE account_id=%d LIMIT 1",
        GetPlayerAccountID(playerid)
    );

    mysql_tquery(
        mysql,
        query,
        "GoldenEvent_LoadDB",
        "i",
        playerid
    );

    return 1;
}

public GoldenEvent_LoadDB(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    g_GoldenStage[playerid] = 0;

    if(cache_num_rows() > 0)
    {
        g_GoldenStage[playerid] = cache_get_field_content_int(0, "stage");
    }

    SetPVarInt(playerid, "golden_stage", g_GoldenStage[playerid]);
    SetPVarInt(playerid, "golden_loaded", 1);

    return 1;
}

public GoldenEvent_Save(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!IsPlayerLogged(playerid)) return 1;

    new query[256];

    mysql_format(
        mysql,
        query,
        sizeof(query),
        "INSERT INTO golden_event_progress (account_id, stage) VALUES (%d,%d) \
        ON DUPLICATE KEY UPDATE stage=VALUES(stage)",
        GetPlayerAccountID(playerid),
        g_GoldenStage[playerid]
    );

    mysql_tquery(mysql, query);
    return 1;
}

CMD:golden(playerid, params[])
{
    #pragma unused params

    if(!GoldenEvent_IsAvailable())
    {
        SendClientMessage(playerid, GOLDEN_COLOR_RED,
            "Событие \"Золотой след\" уже завершено.");
        return 1;
    }

    return GoldenEvent_Start(playerid);
}

CMD:goldeninfo(playerid, params[])
{
    #pragma unused params
    return GoldenEvent_ShowInfo(playerid);
}

stock GoldenEvent_OnGameModeInit()
{
    mysql_tquery(
        mysql,
        "CREATE TABLE IF NOT EXISTS golden_event_progress (account_id INT NOT NULL PRIMARY KEY, stage TINYINT NOT NULL DEFAULT 0)"
    );

    if(g_GoldenPickup == -1)
    {
        g_GoldenPickup = CreatePickup(
            1274,
            1,
            GOLDEN_EVENT_START_X,
            GOLDEN_EVENT_START_Y,
            GOLDEN_EVENT_START_Z,
            -1
        );
    }

    Create3DTextLabel(
        "{FFA500}ПРОВОДНИК\n{FFFFFF}\"ЗОЛОТОГО СЛЕДА\"\n{AAAAAA}/golden",
        GOLDEN_COLOR_WHITE,
        GOLDEN_EVENT_START_X,
        GOLDEN_EVENT_START_Y,
        GOLDEN_EVENT_START_Z + 1.0,
        20.0,
        0,
        1
    );

    print("[GOLDEN_EVENT] Event \"Zolotoy sled\" loaded.");
    return 1;
}

stock GoldenEvent_OnPlayerConnect(playerid)
{
    GoldenEvent_ResetPlayer(playerid);

    SetTimerEx(
        "GoldenEvent_LoadPlayer",
        5000,
        false,
        "i",
        playerid
    );

    return 1;
}

stock GoldenEvent_OnPlayerDisconnect(playerid)
{
    if(g_GoldenActive[playerid])
    {
        GoldenEvent_Save(playerid);
    }

    GoldenEvent_ResetPlayer(playerid);
    return 1;
}

stock GoldenEvent_OnPlayerEnterCheckpoint(playerid)
{
    if(!g_GoldenActive[playerid])
    {
        return 0;
    }

    switch(g_GoldenStage[playerid])
    {
        case 2:
        {
            DisablePlayerCheckpoint(playerid);
            GoldenEvent_SetStage(playerid, 3);
            GoldenEvent_Save(playerid);
            GoldenEvent_ShowClue1(playerid);
            return 1;
        }

        case 3:
        {
            DisablePlayerCheckpoint(playerid);
            GoldenEvent_SetStage(playerid, 4);
            GoldenEvent_Save(playerid);
            GoldenEvent_ShowClue2(playerid);
            return 1;
        }

        case 4:
        {
            DisablePlayerCheckpoint(playerid);
            GoldenEvent_SetStage(playerid, 5);
            GoldenEvent_Save(playerid);
            GoldenEvent_ShowClue3(playerid);
            return 1;
        }

        case 6:
        {
            DisablePlayerCheckpoint(playerid);
            GoldenEvent_ShowFinish(playerid);
            return 1;
        }
    }

    return 0;
}

stock GoldenEvent_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem, inputtext

    switch(dialogid)
    {
        case GOLDEN_DIALOG_START:
        {
            if(!response)
            {
                g_GoldenActive[playerid] = false;
                DisablePlayerCheckpoint(playerid);
                SendClientMessage(playerid, GOLDEN_COLOR_GREY,
                    "Вы отложили расследование. Вернитесь к проводнику позже.");
                return 1;
            }

            GoldenEvent_SetStage(playerid, 2);
            GoldenEvent_Save(playerid);

            GoldenEvent_SetCheckpoint(
                playerid,
                GOLDEN_EVENT_CLUE1_X,
                GOLDEN_EVENT_CLUE1_Y,
                GOLDEN_EVENT_CLUE1_Z
            );

            SendClientMessage(playerid, GOLDEN_COLOR_YELLOW,
                "Новое задание: найдите первую улику на старой дороге.");
            return 1;
        }

        case GOLDEN_DIALOG_CLUE1:
        {
            if(!response) return 1;

            GoldenEvent_SetCheckpoint(
                playerid,
                GOLDEN_EVENT_CLUE2_X,
                GOLDEN_EVENT_CLUE2_Y,
                GOLDEN_EVENT_CLUE2_Z
            );

            SendClientMessage(playerid, GOLDEN_COLOR_YELLOW,
                "Новое задание: следуйте к месту последнего сигнала.");
            return 1;
        }

        case GOLDEN_DIALOG_CLUE2:
        {
            if(!response) return 1;

            GoldenEvent_SetCheckpoint(
                playerid,
                GOLDEN_EVENT_CLUE3_X,
                GOLDEN_EVENT_CLUE3_Y,
                GOLDEN_EVENT_CLUE3_Z
            );

            SendClientMessage(playerid, GOLDEN_COLOR_YELLOW,
                "Новое задание: найдите последнюю улику.");
            return 1;
        }

        case GOLDEN_DIALOG_CLUE3:
        {
            if(!response) return 1;

            GoldenEvent_SetStage(playerid, 6);
            GoldenEvent_Save(playerid);

            GoldenEvent_SetCheckpoint(
                playerid,
                GOLDEN_EVENT_START_X,
                GOLDEN_EVENT_START_Y,
                GOLDEN_EVENT_START_Z
            );

            SendClientMessage(playerid, GOLDEN_COLOR_YELLOW,
                "Новое задание: вернитесь к проводнику.");
            return 1;
        }

        case GOLDEN_DIALOG_FINISH:
        {
            if(!response) return 1;

            if(g_GoldenStage[playerid] != 6)
            {
                return 1;
            }

            g_GoldenStage[playerid] = 7;
            g_GoldenActive[playerid] = false;
            SetPVarInt(playerid, "golden_stage", 7);
            DisablePlayerCheckpoint(playerid);

            GivePlayerMoneyEx(playerid, GOLDEN_EVENT_REWARD);
            GoldenEvent_Save(playerid);

            SendClientMessage(
                playerid,
                GOLDEN_COLOR_GREEN,
                "Вы завершили событие \"Золотой след\"!"
            );

            SendClientMessage(
                playerid,
                GOLDEN_COLOR_YELLOW,
                "Награда: $25.000."
            );

            return 1;
        }

        case GOLDEN_DIALOG_INFO:
        {
            return 1;
        }
    }

    return 0;
}
