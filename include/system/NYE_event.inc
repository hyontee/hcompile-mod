// =============================================================================
//  NEW YEAR EVENT MODULE — "Дед Мороз, Петрович и пропавшие подарки"
//  Архитектура: Pawn.CMD (zcmd), стандартные диалоги SA-MP (ShowPlayerDialog),
//  GUI-кнопка через PlayerTextDraw + SelectTextDraw.
//
//  СЮЖЕТ / АРХИТЕКТУРА ТОЧЕК (по присланным координатам):
//   - Дед Мороз, точка СТАРТ  -> тут берётся задание (интро + кнопка "Взять").
//   - Дед Мороз, точка ФИНИШ  -> тут завершается задание (после 30 подарков).
//   - 6 точек-станций (Петрович/эльфы на вокзалах) -> тут СДАЮТСЯ подарки:
//     клик по кнопке = +1 подарок, деньги, и метка (чекпоинт) ведёт к
//     следующей станции по кругу. После 30-го подарка метка ведёт к финишу
//     Дед Мороза.
//
//  ВАЖНО ПО ИНТЕГРАЦИИ:
//  1) pEventPresents / pEventCompleted / pEventDailyDone реализованы как
//     отдельные массивы (NYE_EventPresents[] и т.д.) — при желании перенеси в
//     свой enum pInfo и SQL (места отмечены TODO_SQL).
//  2) КОНФЛИКТ ИМЁН: в твоём Петрович.pwn уже есть public
//     OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) для
//     ДРУГОГО NPC (обучение новичков). Pawn не даст объявить этот callback
//     дважды в одной сборке. Поэтому здесь это НЕ public, а обычная функция
//     NYE_OnClickPlayerTextDraw(playerid, PlayerText:clickedid).
//     Добавь ОДНУ строку в начало своего существующего callback'a:
//
//         public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
//         {
//             if (NYE_OnClickPlayerTextDraw(playerid, playertextid))
//                 return 1; // клик обработан нашим ивентом — выходим
//
//             // ...дальше твой существующий код (PetroYes/PetroNo и т.п.)
//         }
//
//  3) Модели/скины NPC. Ниже NYE_DED_MOROZ_SKIN и NYE_STATION_NPC_SKIN — заглушки,
//     впиши свои реальные ID скинов (или замени CreateActor-блок на свою
//     систему NPC/FCNPC, если актёры уже созданы в другом месте — тогда
//     просто убери функцию NYE_CreateEventActors() и вызов её в OnGameModeInit,
//     3D-тексты и кнопки всё равно будут работать по чистым координатам).
//  4) Модели/скины NPC. Ниже NYE_DED_MOROZ_SKIN и NYE_STATION_NPC_SKIN — заглушки,
//     впиши свои реальные ID скинов (или замени CreateActor-блок на свою
//     систему NPC/FCNPC, если актёры уже созданы в другом месте — тогда
//     просто убери функцию NYE_CreateEventActors() и вызов её в OnGameModeInit,
//     3D-тексты и кнопки всё равно будут работать по чистым координатам).
//  5) Interior/world из твоих файлов координат везде 0,0 — если у тебя не
//     так, впиши правильные значения в NYE_esInt/NYE_esWorld и NYE_dmInt/NYE_dmWorld.
//  6) OnDialogResponse. В твоём гейммоде уже есть своя система обработки
//     диалогов (компилятор ругался на "cont_OnDialogResponse" — то есть
//     хук-цепочка). Поэтому NYE_OnDialogResponse ниже — НЕ public.
//     Вызови её одной строкой в начале своего настоящего OnDialogResponse
//     (см. комментарий прямо над функцией).
// =============================================================================


// -----------------------------------------------------------------------------
// КОНФИГ
// -----------------------------------------------------------------------------
#define NYE_MAX_EVENT_PRESENTS      30
#define NYE_REWARD_PER_PRESENT      700000
#define NYE_REWARD_FINAL_MONEY      15000000
#define NYE_REWARD_FINAL_DONATE     200          // AZ-Coins / донат-рублей
#define NYE_REWARD_DAILY_FULL_LOOP  3000000

#define NYE_COLOR_EVENT_YELLOW      0xFFD700FF
#define NYE_COLOR_EVENT_GREEN       0x00FF00FF
#define NYE_COLOR_EVENT_RED         0xFF0000FF
#define NYE_COLOR_WHITE             0xFFFFFFFF

#define NYE_DIALOG_DEDMOROZ_INTRO    9001
#define NYE_DIALOG_DEDMOROZ_INFO     9002
#define NYE_DIALOG_TOPEVENT          9003
#define NYE_DIALOG_DAILY_QUEST       9004
#define NYE_DIALOG_STATION 9005

#define NYE_EVENT_INTERACT_RADIUS    3.0

#define NYE_DED_MOROZ_SKIN           89   // Дед Мороз: NPC начала и завершения
#define NYE_STATION_NPC_SKIN         138   // NPC вокзалов новогоднего ивента

#define NYE_NPC_TYPE_NONE            0
#define NYE_NPC_TYPE_DEDMOROZ_START  1
#define NYE_NPC_TYPE_DEDMOROZ_FINISH 2
#define NYE_NPC_TYPE_STATION         3

// -----------------------------------------------------------------------------
// ТОЧКИ ДЕДА МОРОЗА (старт задания / финиш задания)
// Формат исходных координат: x, y, z, angle, interior, world
// -----------------------------------------------------------------------------
enum NYE_e_DedMorozPoint
{
    Float:NYE_dmX,
    Float:NYE_dmY,
    Float:NYE_dmZ,
    Float:NYE_dmAngle,
    NYE_dmInt,
    NYE_dmWorld,
    Text3D:NYE_dmLabel,
    NYE_dmActor
};

// 0: старт основной цепочки, 1: финал основной цепочки
new NYE_DedMorozPoints[2][NYE_e_DedMorozPoint] =
{
    // СТАРТ — тут берётся задание
    {-442.119506, -151.455337, 26.171566, 318.125244, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID},
    // ФИНИШ — тут завершается задание (после 30 подарков)
    {-1364.688964, -312.992523, 257.768646, 71.472312, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID}
};
#define NYE_DEDMOROZ_START   0
#define NYE_DEDMOROZ_FINISH  1

// -----------------------------------------------------------------------------
// СТАНЦИИ ДОСТАВКИ (6 точек — диалог + метка на следующую станцию)
// -----------------------------------------------------------------------------
enum NYE_e_EventStation
{
    Float:NYE_esX,
    Float:NYE_esY,
    Float:NYE_esZ,
    Float:NYE_esAngle,
    NYE_esInt,
    NYE_esWorld,
    Text3D:NYE_esLabel,
    NYE_esActor
};

new NYE_EventStations[][NYE_e_EventStation] =
{
    {-2647.480712, 1982.734252,  9.980341,   8.738994, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID},
    {  830.975952,  799.027770, 13.163070, 246.598968, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID},
    { 2753.754150,-2439.541748, 21.813438, 103.678894, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID},
    {-2438.963623,  188.383438, 26.135101, 314.915985, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID},
    { 1786.717529, 2533.205566, 14.600519, 209.293609, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID},
    {-2170.725830, 1564.408691,  9.882423, 278.167327, 0, 0, Text3D: INVALID_3DTEXT_ID, INVALID_ACTOR_ID}
};
#define NYE_EVENT_STATION_COUNT (sizeof(NYE_EventStations))

// -----------------------------------------------------------------------------
// ГЛОБАЛЬНОЕ СОСТОЯНИЕ
// -----------------------------------------------------------------------------
new bool:NYE_EventStarted = false;

// Данные по игрокам (замени на enum pInfo при интеграции)
new NYE_EventPresents[MAX_PLAYERS];        // pEventPresents   0..30
new bool:NYE_EventCompleted[MAX_PLAYERS];  // pEventCompleted
new bool:NYE_EventDailyDone[MAX_PLAYERS];  // pEventDailyDone (выполнен ли сегодняшний круг)
new NYE_EventTaskTaken[MAX_PLAYERS];       // взял ли активное задание (0/1)
new NYE_EventCurrentPoint[MAX_PLAYERS];    // индекс следующей станции по кругу
new NYE_EventDailyCount[MAX_PLAYERS];      // сколько подарков сдано в текущем ежедневном круге
new NYE_EventCheckpointSet[MAX_PLAYERS];   // стоит ли у игрока чекпоинт ивента
new NYE_PendingStationIndex[MAX_PLAYERS];  // индекс станции, открытой в диалоге Петровича

// GUI-кнопка "Взаимодействие" — универсальная, текст меняется под тип NPC
new PlayerText:NYE_EventButton[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new bool:NYE_EventButtonShown[MAX_PLAYERS];
new NYE_NearestType[MAX_PLAYERS];   // NPC_TYPE_* — какой NPC сейчас рядом
new NYE_NearestIndex[MAX_PLAYERS];  // индекс станции, если NYE_NearestType == NYE_NPC_TYPE_STATION

new NYE_EventProximityTimer = -1;

// ТОП-10
enum NYE_e_TopEntry
{
    NYE_TopName[MAX_PLAYER_NAME],
    NYE_TopPresents
};
new NYE_TopEvent[10][NYE_e_TopEntry];

// -----------------------------------------------------------------------------
// ФОРВАРДЫ
// -----------------------------------------------------------------------------
forward NYE_UpdateEventLabels();
forward NYE_RefreshTopEventList();
forward NYE_OnPlayerEnterCheckpoint(playerid);
forward NYE_SetEventCheckpointToStation(playerid, index);
forward NYE_TakeMainQuest(playerid);
forward NYE_FinishMainEvent(playerid);
forward NYE_DeliverPresentAtStation(playerid, stationIndex);
forward NYE_CheckEventNPCProximity();
forward NYE_ShowEventButton(playerid, type, index);
forward NYE_HideEventButton(playerid);
forward NYE_SavePlayerEventData(playerid); // TODO_SQL
forward NYE_LoadPlayerEventData(playerid); // TODO_SQL

// Проверка админки — подставь свою систему уровней/прав
// Диапазон уровней админки, которым доступны /startevent и /stopevent
#define EVENT_ADMIN_MIN_LEVEL 12
#define EVENT_ADMIN_MAX_LEVEL 14

// Замени GetPlayerAdminEx(playerid) на своё реальное поле уровня админки,
// если оно называется иначе (pAdminLevel, pAdmLevel, AccountData и т.п.)
NYE_IsEventAdmin(playerid)
{
    if (!IsPlayerConnected(playerid)) return false;

    if (GetPlayerAdminEx(playerid) >= EVENT_ADMIN_MIN_LEVEL &&
        GetPlayerAdminEx(playerid) <= EVENT_ADMIN_MAX_LEVEL)
    {
        return true;
    }
    return false;
}

// -----------------------------------------------------------------------------
// 3D-ТЕКСТЫ НАД NPC
// -----------------------------------------------------------------------------
public NYE_UpdateEventLabels()
{
    new statusText[128];
    if (NYE_EventStarted)
        format(statusText, sizeof(statusText), "{FF0000}Новогодний ивент\n{00FF00}Статус: Открыт");
    else
        format(statusText, sizeof(statusText), "{FF0000}Новогодний ивент\n{FF0000}Статус: Закрыто");

    // Дед Мороз
    for (new i = 0; i < 2; i++)
    {
        if (NYE_DedMorozPoints[i][NYE_dmLabel] != Text3D: INVALID_3DTEXT_ID)
            Delete3DTextLabel(NYE_DedMorozPoints[i][NYE_dmLabel]);

        NYE_DedMorozPoints[i][NYE_dmLabel] = Create3DTextLabel(statusText,
            NYE_EventStarted ? NYE_COLOR_EVENT_GREEN : NYE_COLOR_EVENT_RED,
            NYE_DedMorozPoints[i][NYE_dmX], NYE_DedMorozPoints[i][NYE_dmY], NYE_DedMorozPoints[i][NYE_dmZ] + 0.9,
            20.0, 0, 0);
    }

    // Станции
    for (new i = 0; i < NYE_EVENT_STATION_COUNT; i++)
    {
        if (NYE_EventStations[i][NYE_esLabel] != Text3D: INVALID_3DTEXT_ID)
            Delete3DTextLabel(NYE_EventStations[i][NYE_esLabel]);

        NYE_EventStations[i][NYE_esLabel] = Create3DTextLabel(statusText,
            NYE_EventStarted ? NYE_COLOR_EVENT_GREEN : NYE_COLOR_EVENT_RED,
            NYE_EventStations[i][NYE_esX], NYE_EventStations[i][NYE_esY], NYE_EventStations[i][NYE_esZ] + 0.9,
            20.0, 0, 0);
    }
    return 1;
}

// -----------------------------------------------------------------------------
// СОЗДАНИЕ АКТЁРОВ (можно убрать, если NPC уже созданы у тебя иначе)
// -----------------------------------------------------------------------------
NYE_CreateEventActors()
{
    for (new i = 0; i < 2; i++)
    {
        if (NYE_DedMorozPoints[i][NYE_dmActor] == INVALID_ACTOR_ID)
        {
            NYE_DedMorozPoints[i][NYE_dmActor] = CreateActor(NYE_DED_MOROZ_SKIN,
                NYE_DedMorozPoints[i][NYE_dmX], NYE_DedMorozPoints[i][NYE_dmY], NYE_DedMorozPoints[i][NYE_dmZ],
                NYE_DedMorozPoints[i][NYE_dmAngle]);
            SetActorVirtualWorld(NYE_DedMorozPoints[i][NYE_dmActor], NYE_DedMorozPoints[i][NYE_dmWorld]);
            // Если нужен interior: SetActorInterior не существует в стандартном API —
            // используй SetActorPos/виртуальный мир + свою систему интерьеров.
        }
    }

    for (new i = 0; i < NYE_EVENT_STATION_COUNT; i++)
    {
        if (NYE_EventStations[i][NYE_esActor] == INVALID_ACTOR_ID)
        {
            NYE_EventStations[i][NYE_esActor] = CreateActor(NYE_STATION_NPC_SKIN,
                NYE_EventStations[i][NYE_esX], NYE_EventStations[i][NYE_esY], NYE_EventStations[i][NYE_esZ],
                NYE_EventStations[i][NYE_esAngle]);
            SetActorVirtualWorld(NYE_EventStations[i][NYE_esActor], NYE_EventStations[i][NYE_esWorld]);
        }
    }
    return 1;
}

// -----------------------------------------------------------------------------
// OnGameModeInit / OnPlayerConnect / OnPlayerDisconnect — вызвать из основного мода
// -----------------------------------------------------------------------------
public NYE_OnGameModeInit()
{
    for (new i = 0; i < 2; i++)
    {
        NYE_DedMorozPoints[i][NYE_dmLabel] = Text3D: INVALID_3DTEXT_ID;
        NYE_DedMorozPoints[i][NYE_dmActor] = INVALID_ACTOR_ID;
    }
    for (new i = 0; i < NYE_EVENT_STATION_COUNT; i++)
    {
        NYE_EventStations[i][NYE_esLabel] = Text3D: INVALID_3DTEXT_ID;
        NYE_EventStations[i][NYE_esActor] = INVALID_ACTOR_ID;
    }

    NYE_CreateEventActors();   // убери эту строку, если актёры создаются у тебя в другом месте
    NYE_UpdateEventLabels();

    for (new i = 0; i < 10; i++)
    {
        NYE_TopEvent[i][NYE_TopName][0] = EOS;
        NYE_TopEvent[i][NYE_TopPresents] = 0;
    }

    if (NYE_EventProximityTimer == -1)
    {
        NYE_EventProximityTimer = SetTimer("NYE_CheckEventNPCProximity", 300, true);
    }
    return 1;
}

public NYE_OnPlayerConnect(playerid)
{
    NYE_EventPresents[playerid] = 0;
    NYE_EventCompleted[playerid] = false;
    NYE_EventDailyDone[playerid] = false;
    NYE_EventTaskTaken[playerid] = 0;
    NYE_EventCurrentPoint[playerid] = 0;
    NYE_EventDailyCount[playerid] = 0;
    NYE_EventCheckpointSet[playerid] = 0;
    NYE_PendingStationIndex[playerid] = -1;
    NYE_EventButton[playerid] = PlayerText: INVALID_TEXT_DRAW;
    NYE_EventButtonShown[playerid] = false;
    NYE_NearestType[playerid] = NYE_NPC_TYPE_NONE;
    NYE_NearestIndex[playerid] = -1;

    NYE_LoadPlayerEventData(playerid); // TODO_SQL
    return 1;
}

public NYE_OnPlayerDisconnect(playerid)
{
    if (NYE_EventButton[playerid] != PlayerText: INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, NYE_EventButton[playerid]);
        NYE_EventButton[playerid] = PlayerText: INVALID_TEXT_DRAW;
    }
    NYE_EventButtonShown[playerid] = false;

    NYE_SavePlayerEventData(playerid); // TODO_SQL
    return 1;
}

// -----------------------------------------------------------------------------
// SQL — заглушки
// -----------------------------------------------------------------------------
public NYE_LoadPlayerEventData(playerid)
{
    // mysql_format(...); mysql_tquery(g_SQL, query, "OnEventDataLoaded", "d", playerid);
    return 1;
}

public NYE_SavePlayerEventData(playerid)
{
    // mysql_format(...); mysql_tquery(g_SQL, query);
    return 1;
}

// -----------------------------------------------------------------------------
// GUI-КНОПКА (появляется у любого NPC ивента, текст зависит от типа)
// -----------------------------------------------------------------------------
NYE_CreateEventButtonIfNeeded(playerid)
{
    if (NYE_EventButton[playerid] != PlayerText: INVALID_TEXT_DRAW)
        return 1;

    new PlayerText:td = CreatePlayerTextDraw(playerid, 320.0, 400.0, "_");
    PlayerTextDrawUseBox(playerid, td, 1);
    PlayerTextDrawBoxColor(playerid, td, 0x00000099);
    PlayerTextDrawTextSize(playerid, td, 260.0, 0.0);
    PlayerTextDrawLetterSize(playerid, td, 0.25, 1.1);
    PlayerTextDrawAlignment(playerid, td, 2);
    PlayerTextDrawColor(playerid, td, NYE_COLOR_EVENT_YELLOW);
    PlayerTextDrawSetShadow(playerid, td, 0);
    PlayerTextDrawSetOutline(playerid, td, 1);
    PlayerTextDrawSetSelectable(playerid, td, true);

    NYE_EventButton[playerid] = td;
    return 1;
}

public NYE_ShowEventButton(playerid, type, index)
{
    NYE_CreateEventButtonIfNeeded(playerid);

    new text[128];
    switch (type)
    {
        case NYE_NPC_TYPE_DEDMOROZ_START:  format(text, sizeof(text), "~y~[ NYE ]~w~ Event start");
        case NYE_NPC_TYPE_DEDMOROZ_FINISH: format(text, sizeof(text), "~y~[ NYE ]~w~ Finish event");
        case NYE_NPC_TYPE_STATION:
        {
            if (NYE_EventStarted) format(text, sizeof(text), "~y~[ NYE ]~w~ New Year event");
            else format(text, sizeof(text), "~y~[ NYE ]~w~ Event unavailable");
        }
        default: format(text, sizeof(text), "~y~[ NYE ]~w~ Interaction");
    }
    PlayerTextDrawSetString(playerid, NYE_EventButton[playerid], text);

    if (!NYE_EventButtonShown[playerid])
    {
        PlayerTextDrawShow(playerid, NYE_EventButton[playerid]);
        SelectTextDraw(playerid, NYE_COLOR_EVENT_YELLOW);
        NYE_EventButtonShown[playerid] = true;
    }

    NYE_NearestType[playerid] = type;
    NYE_NearestIndex[playerid] = index;
    return 1;
}

public NYE_HideEventButton(playerid)
{
    if (NYE_EventButtonShown[playerid])
    {
        if (NYE_EventButton[playerid] != PlayerText: INVALID_TEXT_DRAW)
            PlayerTextDrawHide(playerid, NYE_EventButton[playerid]);

        CancelSelectTextDraw(playerid);
        NYE_EventButtonShown[playerid] = false;
    }
    NYE_NearestType[playerid] = NYE_NPC_TYPE_NONE;
    NYE_NearestIndex[playerid] = -1;
    return 1;
}

// Таймер: раз в 300 мс проверяет близость к любому NPC ивента
public NYE_CheckEventNPCProximity()
{
    for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if (!IsPlayerConnected(playerid)) continue;

        new bool:found = false;

        // Station NPCs stay interactable even when the event is disabled.
        if (!NYE_EventStarted)
        {
            for (new i = 0; i < NYE_EVENT_STATION_COUNT; i++)
            {
                if (IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS,
                    NYE_EventStations[i][NYE_esX], NYE_EventStations[i][NYE_esY], NYE_EventStations[i][NYE_esZ]))
                {
                    NYE_ShowEventButton(playerid, NYE_NPC_TYPE_STATION, i);
                    found = true;
                    break;
                }
            }

            if (!found && NYE_EventButtonShown[playerid])
                NYE_HideEventButton(playerid);

            continue;
        }

        // Дед Мороз — старт
        if (IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS,
            NYE_DedMorozPoints[NYE_DEDMOROZ_START][NYE_dmX], NYE_DedMorozPoints[NYE_DEDMOROZ_START][NYE_dmY], NYE_DedMorozPoints[NYE_DEDMOROZ_START][NYE_dmZ]))
        {
            NYE_ShowEventButton(playerid, NYE_NPC_TYPE_DEDMOROZ_START, NYE_DEDMOROZ_START);
            found = true;
        }
        // Дед Мороз — финиш
        else if (IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS,
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmX], NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmY], NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmZ]))
        {
            NYE_ShowEventButton(playerid, NYE_NPC_TYPE_DEDMOROZ_FINISH, NYE_DEDMOROZ_FINISH);
            found = true;
        }
        else
        {
            // Станции
            for (new i = 0; i < NYE_EVENT_STATION_COUNT; i++)
            {
                if (IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS,
                    NYE_EventStations[i][NYE_esX], NYE_EventStations[i][NYE_esY], NYE_EventStations[i][NYE_esZ]))
                {
                    NYE_ShowEventButton(playerid, NYE_NPC_TYPE_STATION, i);
                    found = true;
                    break;
                }
            }
        }

        if (!found && NYE_EventButtonShown[playerid])
        {
            NYE_HideEventButton(playerid);
        }
    }
    return 1;
}

// -----------------------------------------------------------------------------
// ОБРАБОТКА КЛИКА ПО КНОПКЕ (НЕ public! см. пометку в шапке файла)
// -----------------------------------------------------------------------------
NYE_OnClickPlayerTextDraw(playerid, PlayerText:clickedid)
{
    if (clickedid != NYE_EventButton[playerid] || clickedid == PlayerText: INVALID_TEXT_DRAW)
        return 0; // не наша кнопка — пусть обрабатывает дальше твой код

    new type = NYE_NearestType[playerid];
    new index = NYE_NearestIndex[playerid];

    NYE_HideEventButton(playerid);

    switch (type)
    {
        case NYE_NPC_TYPE_DEDMOROZ_START:  NYE_TakeMainQuest(playerid); // сама решит: интро / инфо / ежедневка
        case NYE_NPC_TYPE_DEDMOROZ_FINISH: NYE_TryFinishAtDedMoroz(playerid);
        case NYE_NPC_TYPE_STATION:         NYE_ShowStationDialog(playerid, index);
    }
    return 1; // клик обработан
}

// -----------------------------------------------------------------------------
// ДЕД МОРОЗ — СТАРТ (взятие задания / инфо / ежедневка)
// -----------------------------------------------------------------------------
public NYE_TakeMainQuest(playerid)
{
    if (!NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_EVENT_RED, "Дед Мороз: \"Ивент сейчас закрыт, загляни позже!\"");
        return 1;
    }

    // Основной сюжет уже пройден -> предлагаем ежедневку
    if (NYE_EventCompleted[playerid])
    {
        if (NYE_EventDailyDone[playerid])
        {
            ShowPlayerDialog(playerid, NYE_DIALOG_DEDMOROZ_INFO, DIALOG_STYLE_MSGBOX,
                "Дед Мороз",
                "Дед Мороз улыбается:\n\"На сегодня подарков больше нет, отдыхай! Приходи завтра.\"",
                "Закрыть", "");
            return 1;
        }

        new str[400];
        format(str, sizeof(str),
            "Дед Мороз:\n\"Готов ещё раз пробежаться с подарками? За штуку — %d руб.,\n\
            а за целый круг по станциям — бонус %d руб.!\"\n\nСегодня сдано: %d / %d",
            NYE_REWARD_PER_PRESENT, NYE_REWARD_DAILY_FULL_LOOP, NYE_EventDailyCount[playerid], NYE_EVENT_STATION_COUNT);

        ShowPlayerDialog(playerid, NYE_DIALOG_DAILY_QUEST, DIALOG_STYLE_MSGBOX,
            "Дед Мороз — ежедневное задание", str, "Взять подарки", "Закрыть");
        return 1;
    }

    // Задание уже взято, но не завершено
    if (NYE_EventTaskTaken[playerid])
    {
        new str[300];
        format(str, sizeof(str),
            "Дед Мороз:\n\"Ты уже в пути! Собрано %d / %d подарков.\nСледуй за меткой на станции.\"",
            NYE_EventPresents[playerid], NYE_MAX_EVENT_PRESENTS);
        ShowPlayerDialog(playerid, NYE_DIALOG_DEDMOROZ_INFO, DIALOG_STYLE_MSGBOX,
            "Дед Мороз", str, "Закрыть", "");
        return 1;
    }

    // Первый заход — сюжетное интро
    new str[700];
    format(str, sizeof(str),
        "Дед Мороз, потирая замёрзшие руки, вздыхает у разбитых санок:\n\n\
        \"Беда-беда! Мои сани развалились прямо над городом, и все подарки\n\
        рассыпались по округе! Мой помощник Петрович уже собирает их по\n\
        вокзалам, но одному ему не справиться...\n\n\
        Помоги нам — доставь %d подарков по станциям! За каждый — %d руб.,\n\
        а как соберёшь всё до последнего — получишь %d руб. и %d донат-рублей!\"",
        NYE_MAX_EVENT_PRESENTS, NYE_REWARD_PER_PRESENT, NYE_REWARD_FINAL_MONEY, NYE_REWARD_FINAL_DONATE);

    ShowPlayerDialog(playerid, NYE_DIALOG_DEDMOROZ_INTRO, DIALOG_STYLE_MSGBOX,
        "Дед Мороз — Новогодний ивент", str, "Взять задание", "Закрыть");
    return 1;
}

// Попытка завершить задание у финишной точки Деда Мороза
NYE_TryFinishAtDedMoroz(playerid)
{
    if (!NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_EVENT_RED, "Ивент сейчас закрыт.");
        return 1;
    }

    if (NYE_EventCompleted[playerid])
    {
        SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW, "Дед Мороз: \"Ты уже спас этот Новый Год, дружище!\"");
        return 1;
    }

    if (!NYE_EventTaskTaken[playerid] || NYE_EventPresents[playerid] < NYE_MAX_EVENT_PRESENTS)
    {
        new str[128];
        format(str, sizeof(str),
            "Дед Мороз: \"Пока не все подарки собраны (%d / %d). Возвращайся, когда закончишь!\"",
            NYE_EventPresents[playerid], NYE_MAX_EVENT_PRESENTS);
        SendClientMessage(playerid, NYE_COLOR_WHITE, str);
        return 1;
    }

    NYE_FinishMainEvent(playerid);
    return 1;
}

// -----------------------------------------------------------------------------
// СТАНЦИИ — СЮЖЕТНЫЙ ДИАЛОГ ПЕТРОВИЧА (открывается по клику на кнопку)
// -----------------------------------------------------------------------------
NYE_ShowStationDialog(playerid, stationIndex)
{
    if (!NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_EVENT_RED, "Ивент сейчас закрыт.");
        return 1;
    }

    if (!NYE_EventTaskTaken[playerid] && !NYE_EventCompleted[playerid])
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "Сначала возьми задание у Деда Мороза!");
        return 1;
    }

    if (NYE_EventCompleted[playerid] && NYE_EventDailyDone[playerid])
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "На сегодня подарков больше нет. Приходи завтра!");
        return 1;
    }

    NYE_PendingStationIndex[playerid] = stationIndex;

    new str[600];

    if (!NYE_EventCompleted[playerid])
    {
        format(str, sizeof(str),
            "Петрович отряхивает снег с ушанки и хлопает тебя по плечу:\n\n\
            \"О, привёз ещё один! Молодец, не подведи Деда Мороза!\n\
            Клади подарок сюда, я его сразу отправлю по адресу.\"\n\n\
            Собрано подарков: %d / %d",
            NYE_EventPresents[playerid], NYE_MAX_EVENT_PRESENTS);
    }
    else
    {
        format(str, sizeof(str),
            "Петрович хитро подмигивает:\n\n\
            \"Опять решил помочь? Уважаю! Такими темпами Новый Год\n\
            будет самым весёлым в этом городе.\"\n\n\
            Сегодняшний круг: %d / %d",
            NYE_EventDailyCount[playerid], NYE_EVENT_STATION_COUNT);
    }

    ShowPlayerDialog(playerid, NYE_DIALOG_STATION, DIALOG_STYLE_MSGBOX,
        "Новогоднийивент", str, "Сдать подарок", "Позже");
    return 1;
}

// -----------------------------------------------------------------------------
// СТАНЦИИ — СДАЧА ПОДАРКА
// -----------------------------------------------------------------------------
public NYE_DeliverPresentAtStation(playerid, stationIndex)
{
    if (!NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_EVENT_RED, "Ивент сейчас закрыт.");
        return 1;
    }

    if (!NYE_EventTaskTaken[playerid] && !NYE_EventCompleted[playerid])
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "Сначала возьми задание у Деда Мороза!");
        return 1;
    }

    // --- Основной ивент (до 30 подарков) ---
    if (!NYE_EventCompleted[playerid])
    {
        NYE_EventPresents[playerid]++;
        GivePlayerMoneyEx(playerid, NYE_REWARD_PER_PRESENT, "NYE present");

        new str[128];
        format(str, sizeof(str), "Подарок доставлен! (+%d руб.) Собрано: %d / %d",
            NYE_REWARD_PER_PRESENT, NYE_EventPresents[playerid], NYE_MAX_EVENT_PRESENTS);
        SendClientMessage(playerid, NYE_COLOR_EVENT_GREEN, str);

        if (NYE_EventPresents[playerid] >= NYE_MAX_EVENT_PRESENTS)
        {
            DisablePlayerCheckpoint(playerid);
            NYE_EventCheckpointSet[playerid] = 0;

            SetPlayerCheckpoint(playerid,
                NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmX],
                NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmY],
                NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmZ], 3.0);
            NYE_EventCheckpointSet[playerid] = 1;

            SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW,
                "Все 30 подарков собраны! Возвращайся к Дед Морозу — метка укажет путь!");
        }
        else
        {
            NYE_EventCurrentPoint[playerid] = (stationIndex + 1) % NYE_EVENT_STATION_COUNT;
            NYE_SetEventCheckpointToStation(playerid, NYE_EventCurrentPoint[playerid]);
        }
    }
    // --- Ежедневное задание ---
    else
    {
        if (NYE_EventDailyDone[playerid])
        {
            SendClientMessage(playerid, NYE_COLOR_WHITE, "На сегодня подарков больше нет. Приходи завтра!");
            return 1;
        }

        GivePlayerMoneyEx(playerid, NYE_REWARD_PER_PRESENT, "NYE present");
        NYE_EventDailyCount[playerid]++;

        new str[128];
        format(str, sizeof(str), "Подарок доставлен! (+%d руб.) Круг: %d / %d",
            NYE_REWARD_PER_PRESENT, NYE_EventDailyCount[playerid], NYE_EVENT_STATION_COUNT);
        SendClientMessage(playerid, NYE_COLOR_EVENT_GREEN, str);

        if (NYE_EventDailyCount[playerid] >= NYE_EVENT_STATION_COUNT)
        {
            NYE_EventDailyDone[playerid] = true;
            DisablePlayerCheckpoint(playerid);
            NYE_EventCheckpointSet[playerid] = 0;

            GivePlayerMoneyEx(playerid, NYE_REWARD_DAILY_FULL_LOOP, "NYE daily reward");
            format(str, sizeof(str), "Круг завершён! Бонус: +%d руб. Приходи завтра!", NYE_REWARD_DAILY_FULL_LOOP);
            SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW, str);
        }
        else
        {
            NYE_EventCurrentPoint[playerid] = (stationIndex + 1) % NYE_EVENT_STATION_COUNT;
            NYE_SetEventCheckpointToStation(playerid, NYE_EventCurrentPoint[playerid]);
        }
    }

    NYE_SavePlayerEventData(playerid); // TODO_SQL
    NYE_RefreshTopEventList();
    return 1;
}

public NYE_OnPlayerEnterCheckpoint(playerid)
{
    if (!NYE_EventStarted || !NYE_EventCheckpointSet[playerid])
        return 0;

    if (!NYE_EventCompleted[playerid] &&
        NYE_EventTaskTaken[playerid] &&
        NYE_EventPresents[playerid] < NYE_MAX_EVENT_PRESENTS &&
        NYE_EventCurrentPoint[playerid] >= 0 &&
        NYE_EventCurrentPoint[playerid] < NYE_EVENT_STATION_COUNT &&
        IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS + 1.5,
            NYE_EventStations[NYE_EventCurrentPoint[playerid]][NYE_esX],
            NYE_EventStations[NYE_EventCurrentPoint[playerid]][NYE_esY],
            NYE_EventStations[NYE_EventCurrentPoint[playerid]][NYE_esZ]))
    {
        NYE_DeliverPresentAtStation(playerid, NYE_EventCurrentPoint[playerid]);
        return 1;
    }

    if (NYE_EventPresents[playerid] >= NYE_MAX_EVENT_PRESENTS &&
        IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS + 1.5,
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmX],
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmY],
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmZ]))
    {
        NYE_TryFinishAtDedMoroz(playerid);
        return 1;
    }

    return 0;
}

public NYE_SetEventCheckpointToStation(playerid, index)
{
    SetPlayerCheckpoint(playerid,
        NYE_EventStations[index][NYE_esX], NYE_EventStations[index][NYE_esY], NYE_EventStations[index][NYE_esZ], 3.0);
    NYE_EventCheckpointSet[playerid] = 1;
    return 1;
}

// -----------------------------------------------------------------------------
// ОБРАБОТКА ДИАЛОГОВ
// -----------------------------------------------------------------------------
// НЕ public — в твоём гейммоде уже есть система хуков для OnDialogResponse
// (судя по ошибке компиляции про "cont_OnDialogResponse"). Вызови эту функцию
// ОДНОЙ строкой в начале своего настоящего OnDialogResponse (или в первом хуке):
//
//     public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
//     {
//         if (NYE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
//             return 1;
//         // ...дальше твой существующий код
//     }
//
// Если у тебя система хуков через y_hooks (макрос `hook`), то там обычно можно
// просто добавить ещё один `hook OnDialogResponse(...)` в отдельном файле —
// в этом случае можешь вернуть слово `public` этой функции и переименовать
// `public` -> `hook`, если инклюд y_hooks подключён.
NYE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
    {
        case NYE_DIALOG_DEDMOROZ_INTRO:
        {
            if (!response) return 1;

            NYE_EventTaskTaken[playerid] = 1;
            NYE_EventCurrentPoint[playerid] = 0;
            SendClientMessage(playerid, NYE_COLOR_EVENT_GREEN,
                "Дед Мороз вручил тебе задание! Следуй за меткой к первой станции.");
            NYE_SetEventCheckpointToStation(playerid, 0);
            return 1;
        }

        case NYE_DIALOG_DAILY_QUEST:
        {
            if (!response) return 1;

            NYE_EventDailyCount[playerid] = 0;
            NYE_EventCurrentPoint[playerid] = 0;
            SendClientMessage(playerid, NYE_COLOR_EVENT_GREEN,
                "Дед Мороз выдал новую партию подарков! Следуй за меткой.");
            NYE_SetEventCheckpointToStation(playerid, 0);
            return 1;
        }

        case NYE_DIALOG_TOPEVENT: return 1;
        case NYE_DIALOG_DEDMOROZ_INFO: return 1;

        case NYE_DIALOG_STATION:
        {
            if (!response) return 1; // "Позже" — просто закрыли диалог

            if (NYE_PendingStationIndex[playerid] != -1)
            {
                NYE_DeliverPresentAtStation(playerid, NYE_PendingStationIndex[playerid]);
                NYE_PendingStationIndex[playerid] = -1;
            }
            return 1;
        }
    }
    return 0;
}

// -----------------------------------------------------------------------------
// ЗАВЕРШЕНИЕ ОСНОВНОГО ИВЕНТА
// -----------------------------------------------------------------------------
public NYE_FinishMainEvent(playerid)
{
    NYE_EventCompleted[playerid] = true;
    NYE_EventTaskTaken[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    NYE_EventCheckpointSet[playerid] = 0;

    GivePlayerMoneyEx(playerid, NYE_REWARD_FINAL_MONEY, "NYE final reward");
    // Донат-валюта — подставь свою функцию:
    GivePlayerDonate(playerid, NYE_REWARD_FINAL_DONATE, "NYE final donate reward");

    new name[MAX_PLAYER_NAME], str[256];
    GetPlayerName(playerid, name, sizeof(name));

    format(str, sizeof(str),
        "{FFD700}ПОЗДРАВЛЯЕМ! Ты собрал все 30 подарков и спас Новый Год!\nПолучено: %d руб. и %d донат-рублей!",
        NYE_REWARD_FINAL_MONEY, NYE_REWARD_FINAL_DONATE);
    SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW, str);

    format(str, sizeof(str), "{FFD700}%s собрал все 30 подарков и спас Новый Год!", name);
    SendClientMessageToAll(NYE_COLOR_EVENT_YELLOW, str);

    NYE_SavePlayerEventData(playerid); // TODO_SQL
    NYE_RefreshTopEventList();
    return 1;
}

// -----------------------------------------------------------------------------
// ТОП-10
// -----------------------------------------------------------------------------
public NYE_RefreshTopEventList()
{
    // Топ по онлайн-игрокам. Для честного топа по всем (в т.ч. офлайн)
    // сделай выборку из SQL (ORDER BY pEventPresents DESC LIMIT 10).
    for (new i = 0; i < 10; i++)
    {
        NYE_TopEvent[i][NYE_TopName][0] = EOS;
        NYE_TopEvent[i][NYE_TopPresents] = -1;
    }

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;

        new presents = NYE_EventPresents[i];
        if (presents <= 0) continue;

        for (new slot = 0; slot < 10; slot++)
        {
            if (presents > NYE_TopEvent[slot][NYE_TopPresents])
            {
                for (new k = 9; k > slot; k--)
                {
                    format(NYE_TopEvent[k][NYE_TopName], MAX_PLAYER_NAME, "%s", NYE_TopEvent[k - 1][NYE_TopName]);
                    NYE_TopEvent[k][NYE_TopPresents] = NYE_TopEvent[k - 1][NYE_TopPresents];
                }
                GetPlayerName(i, NYE_TopEvent[slot][NYE_TopName], MAX_PLAYER_NAME);
                NYE_TopEvent[slot][NYE_TopPresents] = presents;
                break;
            }
        }
    }
    return 1;
}

CMD:topevent(playerid, params[])
{
    NYE_RefreshTopEventList();

    new str[1024];
    strcat(str, "#\tНикнейм\tПодарки\n");

    for (new i = 0; i < 10; i++)
    {
        new topLine[128];
        if (NYE_TopEvent[i][NYE_TopPresents] >= 0)
            format(topLine, sizeof(topLine), "%d\t%s\t%d\n", i + 1, NYE_TopEvent[i][NYE_TopName], NYE_TopEvent[i][NYE_TopPresents]);
        else
            format(topLine, sizeof(topLine), "%d\t---\t-\n", i + 1);
        strcat(str, topLine);
    }

    ShowPlayerDialog(playerid, NYE_DIALOG_TOPEVENT, DIALOG_STYLE_TABLIST_HEADERS,
        "ТОП-10 Новогоднего ивента", str, "Закрыть", "");
    return 1;
}

// -----------------------------------------------------------------------------
// РЕЗЕРВНЫЕ КОМАНДЫ (на случай если кнопка не сработала)
// -----------------------------------------------------------------------------
CMD:dedmoroz(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS,
        NYE_DedMorozPoints[NYE_DEDMOROZ_START][NYE_dmX], NYE_DedMorozPoints[NYE_DEDMOROZ_START][NYE_dmY], NYE_DedMorozPoints[NYE_DEDMOROZ_START][NYE_dmZ]))
    {
        NYE_TakeMainQuest(playerid);
        return 1;
    }
    if (IsPlayerInRangeOfPoint(playerid, NYE_EVENT_INTERACT_RADIUS,
        NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmX], NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmY], NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmZ]))
    {
        NYE_TryFinishAtDedMoroz(playerid);
        return 1;
    }
    SendClientMessage(playerid, NYE_COLOR_WHITE, "Ты недостаточно близко к Деду Морозу.");
    return 1;
}

CMD:epoint(playerid, params[])
{
    if (!NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_EVENT_RED, "Event is disabled.");
        return 1;
    }

    if (!NYE_EventTaskTaken[playerid] && !NYE_EventCompleted[playerid])
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "Take the New Year event quest first.");
        return 1;
    }

    if (NYE_EventCompleted[playerid])
    {
        if (NYE_EventDailyDone[playerid])
        {
            SendClientMessage(playerid, NYE_COLOR_WHITE, "Daily event task is already completed.");
            return 1;
        }

        NYE_EventCurrentPoint[playerid] = NYE_EventDailyCount[playerid] % NYE_EVENT_STATION_COUNT;
        NYE_SetEventCheckpointToStation(playerid, NYE_EventCurrentPoint[playerid]);
        SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW, "GPS point set to the next station.");
        return 1;
    }

    if (NYE_EventPresents[playerid] >= NYE_MAX_EVENT_PRESENTS)
    {
        SetPlayerCheckpoint(playerid,
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmX],
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmY],
            NYE_DedMorozPoints[NYE_DEDMOROZ_FINISH][NYE_dmZ], 3.0);
        NYE_EventCheckpointSet[playerid] = 1;
        SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW, "GPS point set to the event finish.");
        return 1;
    }

    NYE_SetEventCheckpointToStation(playerid, NYE_EventCurrentPoint[playerid]);
    SendClientMessage(playerid, NYE_COLOR_EVENT_YELLOW, "GPS point set to the next station.");
    return 1;
}

// -----------------------------------------------------------------------------
// АДМИН-КОМАНДЫ
// -----------------------------------------------------------------------------
stock NYE_DoStartEvent(playerid)
{
    if (!NYE_IsEventAdmin(playerid))
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "У тебя нет доступа к этой команде.");
        return 1;
    }
    if (NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "Ивент уже запущен.");
        return 1;
    }

    NYE_EventStarted = true;
    NYE_UpdateEventLabels();
    NYE_CheckEventNPCProximity(); // сразу показать кнопки тем, кто уже стоит рядом

    SendClientMessageToAll(NYE_COLOR_EVENT_GREEN,
        "Новогодний ивент запущен! Найди Деда Мороза — рядом появится кнопка!");
    return 1;
}

CMD:startevent(playerid, params[])
{
    return NYE_DoStartEvent(playerid);
}

// Алиас под исходное название из первого промпта
CMD:stertevent(playerid, params[])
{
    return NYE_DoStartEvent(playerid);
}

CMD:stopevent(playerid, params[])
{
    if (!NYE_IsEventAdmin(playerid))
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "У тебя нет доступа к этой команде.");
        return 1;
    }
    if (!NYE_EventStarted)
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "Ивент уже остановлен.");
        return 1;
    }

    NYE_EventStarted = false;
    NYE_UpdateEventLabels();

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (NYE_EventButtonShown[i]) NYE_HideEventButton(i);
    }

    SendClientMessageToAll(NYE_COLOR_EVENT_RED, "Новогодний ивент завершён администрацией.");
    return 1;
}

// Ручной сброс ежедневного круга (пока нет автоматической привязки к смене дня)
CMD:resetdailyevent(playerid, params[])
{
    if (!NYE_IsEventAdmin(playerid))
    {
        SendClientMessage(playerid, NYE_COLOR_WHITE, "У тебя нет доступа к этой команде.");
        return 1;
    }

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        NYE_EventDailyDone[i] = false;
        NYE_EventDailyCount[i] = 0;
    }
    SendClientMessage(playerid, NYE_COLOR_EVENT_GREEN, "Ежедневный круг ивента сброшен для всех онлайн-игроков.");
    return 1;
}
