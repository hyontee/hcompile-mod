/*
    include/system/seks.pwn
    "Романтика/Интим по согласию" (без откровенных описаний)

    ВАЖНО:
    Я НЕ делаю систему с подробным описанием сексуальных действий.
    Здесь всё в стиле RP и без 18+ деталей: "обнимают", "целуют", "уединяются", "проводят время наедине".

    Под твой мод Prime Russia:
      - команды Pawn.CMD (CMD:...)
      - используется Action(...) как /me
      - проверка пола через GetPlayerSex (0=муж, 1=жен) и требует противоположный пол
      - защита: дистанция, занятость, таймаут заявки

    Команды:
      /sex <id>     — предложить "интим" игроку противоположного пола (по согласию)
      /sexyes       — принять
      /sexno        — отказать
      /sexstop      — остановить сцену (для любого из участников)

    Кодировка: Windows-1251 (Cyrillic)
*/

#include <a_samp>

#define RS_COLOR_OK    0xA7F542FF
#define RS_COLOR_ERR   0xFF6B6BFF
#define RS_COLOR_INFO  0xFFB020FF

#define RS_DIST_REQ    (3.5)     // дистанция для предложения/сцены
#define RS_REQ_TIMEOUT (30)      // секунд до авто-отмены заявки

static RS_RequestFrom[MAX_PLAYERS];    // кто предложил мне (playerid) или -1
static RS_RequestTick[MAX_PLAYERS];    // тик заявки

static bool:RS_InScene[MAX_PLAYERS];   // участник сцены
static RS_Partner[MAX_PLAYERS];        // партнёр
static RS_Step[MAX_PLAYERS];           // шаг сценки (0..)
static RS_Timer = 0;

// ---------- утилиты ----------
stock RS_Send(playerid, color, const msg[])
{
    return SendClientMessage(playerid, color, msg);
}

stock bool:RS_IsConnected(playerid)
{
    return (playerid >= 0 && playerid < MAX_PLAYERS && IsPlayerConnected(playerid));
}

stock bool:RS_InRange(playerid, targetid, Float:dist)
{
    new Float:x, Float:y, Float:z;
    new Float:tx, Float:ty, Float:tz;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerPos(targetid, tx, ty, tz);
    return (VectorSize(x-tx, y-ty, z-tz) <= dist);
}

stock RS_ResetRequest(playerid)
{
    RS_RequestFrom[playerid] = -1;
    RS_RequestTick[playerid] = 0;
    return 1;
}

stock RS_EndScene(playerid, bool:notify=true)
{
    if (!RS_InScene[playerid]) return 1;

    new p = RS_Partner[playerid];

    RS_InScene[playerid] = false;
    RS_Partner[playerid] = -1;
    RS_Step[playerid] = 0;

    if (notify) RS_Send(playerid, RS_COLOR_INFO, "[RP] Сцена остановлена.");

    if (RS_IsConnected(p) && RS_InScene[p] && RS_Partner[p] == playerid)
    {
        RS_InScene[p] = false;
        RS_Partner[p] = -1;
        RS_Step[p] = 0;
        if (notify) RS_Send(p, RS_COLOR_INFO, "[RP] Сцена остановлена.");
    }

    return 1;
}

stock RS_StartGlobalTimer()
{
    if (!RS_Timer) RS_Timer = SetTimer("RS_Tick", 900, true);
    return 1;
}

stock RS_StopGlobalTimerIfIdle()
{
    // если нет активных заявок и сцен — таймер можно выключить
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (RS_RequestFrom[i] != -1) return 1;
        if (RS_InScene[i]) return 1;
    }
    if (RS_Timer)
    {
        KillTimer(RS_Timer);
        RS_Timer = 0;
    }
    return 1;
}

// ---------- логика ----------
stock RS_Offer(playerid, targetid)
{
    if (!RS_IsConnected(targetid) || targetid == playerid)
        return RS_Send(playerid, RS_COLOR_ERR, "[RP] Игрок не найден.");

    if (RS_InScene[playerid] || RS_InScene[targetid])
        return RS_Send(playerid, RS_COLOR_ERR, "[RP] Кто-то уже занят сценой.");

    if (RS_RequestFrom[targetid] != -1)
        return RS_Send(playerid, RS_COLOR_ERR, "[RP] У игрока уже есть активное предложение.");

    // противоположный пол
    if (GetPlayerSex(playerid) == GetPlayerSex(targetid))
        return RS_Send(playerid, RS_COLOR_ERR, "[RP] Можно предлагать только игроку противоположного пола.");

    if (!RS_InRange(playerid, targetid, RS_DIST_REQ))
        return RS_Send(playerid, RS_COLOR_ERR, "[RP] Подойди ближе к игроку.");

    RS_RequestFrom[targetid] = playerid;
    RS_RequestTick[targetid] = GetTickCount();

    new n1[MAX_PLAYER_NAME], n2[MAX_PLAYER_NAME];
    GetPlayerName(playerid, n1, sizeof n1);
    GetPlayerName(targetid, n2, sizeof n2);

    RS_Send(playerid, RS_COLOR_OK, "[RP] Предложение отправлено. Жди ответа (/sexyes или /sexno).");

    new msg[144];
    format(msg, sizeof msg, "[RP] %s предлагает тебе романтическую сцену. /sexyes принять, /sexno отказать.", n1);
    RS_Send(targetid, RS_COLOR_INFO, msg);

    RS_StartGlobalTimer();
    return 1;
}

stock RS_Accept(playerid)
{
    new from = RS_RequestFrom[playerid];
    if (!RS_IsConnected(from))
    {
        RS_ResetRequest(playerid);
        RS_Send(playerid, RS_COLOR_ERR, "[RP] Предложение уже недействительно.");
        RS_StopGlobalTimerIfIdle();
        return 1;
    }

    if (RS_InScene[playerid] || RS_InScene[from])
    {
        RS_ResetRequest(playerid);
        RS_Send(playerid, RS_COLOR_ERR, "[RP] Сцена не может начаться (кто-то занят).");
        RS_StopGlobalTimerIfIdle();
        return 1;
    }

    if (!RS_InRange(playerid, from, RS_DIST_REQ))
    {
        RS_Send(playerid, RS_COLOR_ERR, "[RP] Подойдите ближе друг к другу.");
        return 1;
    }

    // старт сцены
    RS_ResetRequest(playerid);

    RS_InScene[playerid] = true;
    RS_InScene[from] = true;

    RS_Partner[playerid] = from;
    RS_Partner[from] = playerid;

    RS_Step[playerid] = 0;
    RS_Step[from] = 0;

    // первая реплика
    new nm[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nm, sizeof nm);

    new act[128];
    format(act, sizeof act, "нежно улыбается %s", nm);
    Action(from, act);

    Action(playerid, "подходит ближе и смотрит в глаза");

    RS_Send(playerid, RS_COLOR_OK, "[RP] Сцена началась. Остановить: /sexstop");
    RS_Send(from, RS_COLOR_OK, "[RP] Сцена началась. Остановить: /sexstop");

    RS_StartGlobalTimer();
    return 1;
}

stock RS_Deny(playerid)
{
    new from = RS_RequestFrom[playerid];
    if (from == -1) return RS_Send(playerid, RS_COLOR_INFO, "[RP] Активных предложений нет.");

    RS_ResetRequest(playerid);

    if (RS_IsConnected(from))
        RS_Send(from, RS_COLOR_INFO, "[RP] Игрок отказал.");

    RS_Send(playerid, RS_COLOR_INFO, "[RP] Ты отказал.");
    RS_StopGlobalTimerIfIdle();
    return 1;
}

// ---------- тикер ----------
forward RS_Tick();
public RS_Tick()
{
    // таймауты заявок
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (RS_RequestFrom[i] == -1) continue;

        if (!RS_IsConnected(i) || !RS_IsConnected(RS_RequestFrom[i]))
        {
            RS_ResetRequest(i);
            continue;
        }

        if (GetTickCount() - RS_RequestTick[i] > RS_REQ_TIMEOUT * 1000)
        {
            new from = RS_RequestFrom[i];
            RS_ResetRequest(i);

            RS_Send(i, RS_COLOR_INFO, "[RP] Предложение истекло.");
            RS_Send(from, RS_COLOR_INFO, "[RP] Предложение истекло.");
        }
    }

    // шаги сцен (мягкий RP, без 18+)
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!RS_InScene[i]) continue;

        new p = RS_Partner[i];
        if (!RS_IsConnected(p) || !RS_InScene[p] || RS_Partner[p] != i)
        {
            RS_EndScene(i, false);
            continue;
        }

        // только один раз на пару: пусть "ведущим" будет меньший id
        if (i > p) continue;

        // если далеко — останавливаем
        if (!RS_InRange(i, p, RS_DIST_REQ + 1.5))
        {
            RS_Send(i, RS_COLOR_INFO, "[RP] Вы отошли слишком далеко — сцена остановлена.");
            RS_Send(p, RS_COLOR_INFO, "[RP] Вы отошли слишком далеко — сцена остановлена.");
            RS_EndScene(i, false);
            continue;
        }

        new step = RS_Step[i];
        // шаги раз в тик: 0..3 и потом стоп
        switch (step)
        {
            case 0:
            {
                Action(i, "аккуратно берёт за руку");
                Action(p, "делает шаг навстречу");
            }
            case 1:
            {
                Action(i, "нежно обнимает");
                Action(p, "прижимается ближе");
            }
            case 2:
            {
                Action(i, "целует в щёку");
                Action(p, "улыбается и отвечает взаимностью");
            }
            case 3:
            {
                Action(i, "уединяется вместе с партнёром, проводя время наедине");
                Action(p, "уединяется вместе с партнёром, проводя время наедине");
                RS_Send(i, RS_COLOR_OK, "[RP] Сцена завершена.");
                RS_Send(p, RS_COLOR_OK, "[RP] Сцена завершена.");
                RS_EndScene(i, false);
            }
            default:
            {
                RS_EndScene(i, false);
            }
        }

        RS_Step[i] = step + 1;
        RS_Step[p] = RS_Step[i];
    }

    RS_StopGlobalTimerIfIdle();
    return 1;
}

// ---------- команды ----------
CMD:sex(playerid, params[])
{
    new targetid = -1;
    if (sscanf(params, "d", targetid))
        return RS_Send(playerid, RS_COLOR_INFO, "Используйте: /sex [id]");

    return RS_Offer(playerid, targetid);
}

CMD:sexyes(playerid, params[])
{
    #pragma unused params
    if (RS_RequestFrom[playerid] == -1)
        return RS_Send(playerid, RS_COLOR_INFO, "[RP] Нет активного предложения.");

    return RS_Accept(playerid);
}

CMD:sexno(playerid, params[])
{
    #pragma unused params
    return RS_Deny(playerid);
}

CMD:sexstop(playerid, params[])
{
    #pragma unused params
    RS_EndScene(playerid, true);
    RS_StopGlobalTimerIfIdle();
    return 1;
}

// ---------- сброс на выход ----------
stock RS_OnPlayerDisconnect(playerid)
{
    RS_ResetRequest(playerid);
    RS_EndScene(playerid, false);
    return 1;
}
