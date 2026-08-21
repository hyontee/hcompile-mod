#if defined _inc_event_dacha
    #endinput
#endif
#define _inc_event_dacha

// ============================================================
//  СОБЫТИЕ "ЛЕТНЯЯ ДАЧА" (GUI 30)
// ============================================================

#define EVENT_DACHA_LEVEL_EXP       1000    // exp за 1 уровень дачи
#define EVENT_DACHA_LEVEL_PRICE     239     // цена BC за прокачку на 1 уровень
#define EVENT_DACHA_MAX_LEVEL       8       // TODO: уточнить реальный максимум уровней

// Схема id наград по аналогии с BlackPass (BLACKPASS_STANDARD_REWARD_BASE + level).
// Пока используется только как задел под будущую фактическую выдачу предметов —
// сейчас выдача наград не делается, только отображение статуса "получено".
#define EVENT_DACHA_REWARD_BASE     4000

stock EventDacha_GetRewardInventoryItemId(level)
{
    return EVENT_DACHA_REWARD_BASE + level;
}

enum E_EVENT_DACHA_DATA
{
    bool:EVENT_DACHA_LOADED,
    EVENT_DACHA_LEVEL,
    EVENT_DACHA_EXPERIENCE
};

new g_event_dacha[MAX_PLAYERS][E_EVENT_DACHA_DATA];

// ------------------------------------------------------------
//  Создание таблицы (вызвать один раз при старте гейммода,
//  по аналогии с BlackPass_CreateTables)
// ------------------------------------------------------------
stock EventDacha_CreateTables()
{
    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `event_dacha_players` (`account_id` INT NOT NULL, `level` INT NOT NULL DEFAULT 0, `experience` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
    if(mysql_errno()) printf("[EVENT_DACHA][DB][ERROR] create event_dacha_players errno=%d", mysql_errno());
    return 1;
}

// ------------------------------------------------------------
//  Сброс данных игрока (вызвать при коннекте, до логина)
// ------------------------------------------------------------
stock EventDacha_ResetPlayer(playerid)
{
    g_event_dacha[playerid][EVENT_DACHA_LOADED] = false;
    g_event_dacha[playerid][EVENT_DACHA_LEVEL] = 0;
    g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] = 0;
    return 1;
}

// ------------------------------------------------------------
//  Загрузка данных игрока из БД (вызвать при логине,
//  либо лениво из EventDacha_LoadPlayer при первом обращении)
// ------------------------------------------------------------
forward EventDacha_OnLoadCallback(playerid);
public EventDacha_OnLoadCallback(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new rows;
    cache_get_row_count(rows);

    if(rows > 0)
    {
        new level, experience;
        level = cache_get_field_content_int(0, "level");
        experience = cache_get_field_content_int(0, "experience");

        g_event_dacha[playerid][EVENT_DACHA_LEVEL] = level;
        g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] = experience;
    }
    else
    {
        new query[128];
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO event_dacha_players (account_id, level, experience, created_at, updated_at) VALUES (%d, 0, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP())",
            GetPlayerAccountID(playerid));
        mysql_query(mysql, query, false);

        g_event_dacha[playerid][EVENT_DACHA_LEVEL] = 0;
        g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] = 0;
    }

    g_event_dacha[playerid][EVENT_DACHA_LOADED] = true;
    return 1;
}

stock EventDacha_LoadPlayer(playerid)
{
    if(g_event_dacha[playerid][EVENT_DACHA_LOADED]) return 1;
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new query[128];
    mysql_format(mysql, query, sizeof(query),
        "SELECT level, experience FROM event_dacha_players WHERE account_id=%d LIMIT 1",
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "EventDacha_OnLoadCallback", "d", playerid);
    return 1;
}

// ------------------------------------------------------------
//  Сохранение данных игрока
// ------------------------------------------------------------
stock EventDacha_SavePlayer(playerid)
{
    if(!g_event_dacha[playerid][EVENT_DACHA_LOADED]) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE event_dacha_players SET level=%d, experience=%d, updated_at=UNIX_TIMESTAMP() WHERE account_id=%d LIMIT 1",
        g_event_dacha[playerid][EVENT_DACHA_LEVEL],
        g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE],
        GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return 1;
}

// ------------------------------------------------------------
//  Геттеры
// ------------------------------------------------------------
stock EventDacha_GetLevel(playerid)
{
    return g_event_dacha[playerid][EVENT_DACHA_LEVEL];
}

stock EventDacha_GetProgress(playerid)
{
    return g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE];
}

// ------------------------------------------------------------
//  Выдача опыта события (используется и /givexpevent,
//  и любыми другими источниками опыта в будущем)
// ------------------------------------------------------------
stock EventDacha_GrantExperience(playerid, amount)
{
    if(!g_event_dacha[playerid][EVENT_DACHA_LOADED])
    {
        if(!EventDacha_LoadPlayer(playerid)) return 0;
    }

    if(amount <= 0) return 0;
    if(g_event_dacha[playerid][EVENT_DACHA_LEVEL] >= EVENT_DACHA_MAX_LEVEL) return 0;

    g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] += amount;

    while(g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] >= EVENT_DACHA_LEVEL_EXP && g_event_dacha[playerid][EVENT_DACHA_LEVEL] < EVENT_DACHA_MAX_LEVEL)
    {
        g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] -= EVENT_DACHA_LEVEL_EXP;
        g_event_dacha[playerid][EVENT_DACHA_LEVEL]++;
    }

    if(g_event_dacha[playerid][EVENT_DACHA_LEVEL] >= EVENT_DACHA_MAX_LEVEL)
    {
        g_event_dacha[playerid][EVENT_DACHA_EXPERIENCE] = 0;
    }

    EventDacha_SavePlayer(playerid);
    return 1;
}

// ------------------------------------------------------------
//  Заполняет json текущим состоянием игрока: уровень, прогресс
//  опыта и статус "получено" для каждого пройденного уровня.
//  Статус чисто визуальный и производный от текущего уровня —
//  отдельно не хранится и не требует ручного "клейма".
// ------------------------------------------------------------
stock EventDacha_FillStatePacket(playerid, Node:json)
{
    new current_level = EventDacha_GetLevel(playerid);

    JSON_SetInt(json, "level", current_level);
    JSON_SetInt(json, "exp", EventDacha_GetProgress(playerid));
    JSON_SetInt(json, "exp_max", EVENT_DACHA_LEVEL_EXP);

    new Node:r1 = JSON_Int(1 <= current_level);
    new Node:r2 = JSON_Int(2 <= current_level);
    new Node:r3 = JSON_Int(3 <= current_level);
    new Node:r4 = JSON_Int(4 <= current_level);
    new Node:r5 = JSON_Int(5 <= current_level);
    new Node:r6 = JSON_Int(6 <= current_level);
    new Node:r7 = JSON_Int(7 <= current_level);
    new Node:r8 = JSON_Int(8 <= current_level);
    
    new Node:reward_status = JSON_Array(r1, r2, r3, r4, r5, r6, r7, r8);
    JSON_SetArray(json, "reward_status", reward_status);

    JSON_Cleanup(r1); JSON_Cleanup(r2); JSON_Cleanup(r3); JSON_Cleanup(r4);
    JSON_Cleanup(r5); JSON_Cleanup(r6); JSON_Cleanup(r7); JSON_Cleanup(r8);
    JSON_Cleanup(reward_status);
    return 1;
}

// ------------------------------------------------------------
//  Отправка пакета с текущим состоянием (page 1)
// ------------------------------------------------------------
stock EventDacha_SendMainPacket(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "page", 1);
    EventDacha_FillStatePacket(playerid, json);

    ShowPlayerGUI(playerid, 30, json);
    JSON_Cleanup(json);
    return 1;
}

// ------------------------------------------------------------
//  Обработка кнопки "+" (прокачать дачу за донат-валюту)
// ------------------------------------------------------------
stock EventDacha_HandleUpgrade(playerid, Node:response)
{
    JSON_SetInt(response, "page", 1);

    if(EventDacha_GetLevel(playerid) >= EVENT_DACHA_MAX_LEVEL)
    {
        SendClientMessage(playerid, -1, "Дача уже максимального уровня.");
        EventDacha_FillStatePacket(playerid, response);
        return 1;
    }

    if(GetPlayerData(playerid, P_MONEY) < EVENT_DACHA_LEVEL_PRICE)
    {
        SendClientMessage(playerid, -1, "Недостаточно средств для прокачки дачи.");
        EventDacha_FillStatePacket(playerid, response);
        return 1;
    }

    SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - EVENT_DACHA_LEVEL_PRICE);
    EventDacha_GrantExperience(playerid, EVENT_DACHA_LEVEL_EXP);

    EventDacha_FillStatePacket(playerid, response);
    return 1;
}

// ------------------------------------------------------------
//  Главный обработчик пакета GUI 30 — вызывать из case 30
//  основного свитча обработки входящих пакетов
// ------------------------------------------------------------
stock EventDacha_HandlePacket(playerid, Node:json)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(!EventDacha_LoadPlayer(playerid)) return 0;

    new current_page, button_id;
    JSON_GetInt(json, "page", current_page);
    JSON_GetInt(json, "button", button_id);

    new Node:response = JSON_Object();

    switch(button_id)
    {
        case 1: // кнопка "+" — прокачать дачу за BC
        {
            EventDacha_HandleUpgrade(playerid, response);
        }

        default:
        {
            JSON_SetInt(response, "page", 1);
            EventDacha_FillStatePacket(playerid, response);
        }
    }

    OnPacketIncoming(playerid, 30, response);
    JSON_Cleanup(response);
    return 1;
}

// ------------------------------------------------------------
//  Команды
// ------------------------------------------------------------
CMD:dacha(playerid, params[])
{
    printf("[EVENT_DACHA] CMD:dacha called by %d", playerid);

    if(!EventDacha_LoadPlayer(playerid))
    {
        printf("[EVENT_DACHA] LoadPlayer FAILED for %d", playerid);
        return 1;
    }

    printf("[EVENT_DACHA] LoadPlayer OK, sending packet");
    return EventDacha_SendMainPacket(playerid);
}

CMD:givexpevent(playerid, params[])
{
    new targetid, amount;
    if(sscanf(params, "ud", targetid, amount))
        return SendClientMessage(playerid, -1, "Использование: /givexpevent [id] [количество]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Игрок не в сети.");

    if(!EventDacha_LoadPlayer(targetid))
        return SendClientMessage(playerid, -1, "Данные игрока по событию ещё не загружены.");

    EventDacha_GrantExperience(targetid, amount);

    SendClientMessage(playerid, -1, "Опыт события выдан.");
    SendClientMessage(targetid, -1, "Вам выдан опыт летнего события.");
    return 1;
}

CMD:eventt(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "page", 1);
    EventDacha_FillStatePacket(playerid, json);

    ShowPlayerGUI(playerid, 30, json);
    JSON_Cleanup(json);
    return 1;
}