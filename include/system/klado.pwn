#if !defined MAX_PLAYER_NAME
    #define MAX_PLAYER_NAME 24
#endif
#if !defined MAX_PLAYERS
    #define MAX_PLAYERS 500
#endif


// --- Цвета, если они еще не определены в твоем гейммоде ---
#if !defined COLOR_WHITE // Защита от переопределения
    #define COLOR_WHITE     0xFFFFFFFF
    #define COLOR_RED       0xFF0000FF
    #define COLOR_GREEN     0xFF00FF00
    #define COLOR_YELLOW    0xFFFF00FF
    #define COLOR_LIGHTBLUE 0xFFADD8E6
#endif

// --- Константы для системы кладоискателя ---
const Float:CLAN_SEARCH_RADIUS = 15.0;

#define MAX_CLAN_SPOTS 8
const Float:KLADO_SPOTS[MAX_CLAN_SPOTS][3] = {
    {-2243.79, -593.78, 39.49}, // (Твои координаты со скрина)
    {-2250.00, -580.00, 39.50}, // Чуть правее, севернее
    {-2235.00, -605.00, 39.40}, // Чуть левее, южнее
    {-2240.00, -570.00, 39.60},
    {-2260.00, -590.00, 39.30},
    {-2230.00, -595.00, 39.55},
    {-2255.00, -575.00, 39.45},
    {-2245.00, -610.00, 39.35}
};

const KladCooldownTime = 3600; // 1 час = 3600 секунд
const KladAnimationTime = 5000; // 5 секунд анимация копания

// --- Структура для хранения данных кладоискателя для каждого игрока НЕЗАВИСИМО от playerid ---
enum E_KLAD_DATA_PERSISTENT
{
    bool:klad_is_searching_P,
    Float:klad_pos_x_P,
    Float:klad_pos_y_P,
    Float:klad_pos_z_P,
    Float:klad_base_x_P,
    Float:klad_base_y_P,
    Float:klad_base_z_P,
    timestamp:klad_cooldown_end_time_P
};

#

define MAX_ACCOUNTS_OR_SLOTS_FOR_KLAD_DATA 500 // Пример: до 500 уникальных игроков
new g_KladPlayerNames[MAX_ACCOUNTS_OR_SLOTS_FOR_KLAD_DATA][MAX_PLAYER_NAME];
new g_KladPersistentData[MAX_ACCOUNTS_OR_SLOTS_FOR_KLAD_DATA][E_KLAD_DATA_PERSISTENT];
new g_KladDataCount = 0;

// --- Данные, привязанные к текущему playerid (для активного сеанса игрока) ---
enum E_KLAD_DATA_SESSION
{
    klad_persistent_idx,
    PlayerText:klad_radar_text,
    bool:klad_is_searching,
    bool:klad_is_digging
};
new KladPlayerSessionData[MAX_PLAYERS][E_KLAD_DATA_SESSION];


// --- Глобальные функции, которые будут использоваться в гейммоде ---
forward Klad_OnGameModeInit();
forward Klad_OnPlayerConnect(playerid);
forward Klad_OnPlayerDisconnect(playerid, reason);
forward Klad_OnPlayerCommandText(playerid, cmdtext[]);

// --- Внутренние паблики, вызываемые таймерами или внутри системы ---
public GiveMoneyAndCleanUp(playerid);
public UpdateKladRadar(playerid);

// --- Вспомогательные функции ---

stock Klad_FindPlayerDataIndex(const pName[])
{
    for(new i = 0; i < g_KladDataCount; i++)
    {
        if(strcmp(g_KladPlayerNames[i], pName, false) == 0)
        {
            return i;
        }
    }
    return -1;
}

stock Klad_GetOrCreatePlayerDataIndex(const pName[])
{
    new idx = Klad_FindPlayerDataIndex(pName);
    if(idx != -1)
    {
        return idx;
    }

    if(g_KladDataCount >= MAX_ACCOUNTS_OR_SLOTS_FOR_KLAD_DATA)
    {
        idx = MAX_ACCOUNTS_OR_SLOTS_FOR_KLAD_DATA - 1;
    }
    else
    {
        idx = g_KladDataCount;
        g_KladDataCount++;
    }

    strmid(g_KladPlayerNames[idx], pName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
    g_KladPersistentData[idx][klad_is_searching_P] = false;
    g_KladPersistentData[idx][klad_cooldown_end_time_P] = 0;
    
    g_KladPersistentData[idx][klad_pos_x_P] = 0.0;
    g_KladPersistentData[idx][klad_pos_y_P] = 0.0;
    g_KladPersistentData[idx][klad_pos_z_P] = 0.0;
    g_KladPersistentData[idx][klad_base_x_P] = 0.0;
    g_KladPersistentData[idx][klad_base_y_P] = 0.0;
    g_KladPersistentData[idx][klad_base_z_P] = 0.0;

    return idx;
}

stock Float:random_float(Float:min = 0.0, Float:max = 1.0)
{
    return (float(random(floatround((max - min) * 1000.0))) / 1000.0) + min;
}

// --- ИМПЛЕМЕНТАЦИЯ ФУНКЦИЙ ---

public Klad_OnGameModeInit()
{
    randomize();
    g_KladDataCount = 0;
    return 1;
}

public Klad_OnPlayerConnect(playerid)
{
    new pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pName, sizeof(pName));

    new persistent_idx = Klad_GetOrCreatePlayerDataIndex(pName);
    KladPlayerSessionData[playerid][klad_persistent_idx] = persistent_idx;

    KladPlayerSessionData[playerid][klad_is_searching] = false;
    KladPlayerSessionData[playerid][klad_is_digging] = false;

    KladPlayerSessionData[playerid][klad_radar_text] = TextDrawCreate(0.0, 300.0, " ");
    TextDrawLetterSize(KladPlayerSessionData[playerid][klad_radar_text], 0.30, 1.20);
    TextDrawColor(KladPlayerSessionData[playerid][klad_radar_text], COLOR_YELLOW);
    TextDrawSetShadow(KladPlayerSessionData[playerid][klad_radar_text], 0);
    TextDrawSetOutline(KladPlayerSessionData[playerid][klad_radar_text], 1);
    TextDrawFont(KladPlayerSessionData[playerid][klad_radar_text], 1);
    TextDrawSetProportional(KladPlayerSessionData[playerid][klad_radar_text], 1);
    TextDrawHideForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);

    RemovePlayerMapIcon(playerid, 25);
    TextDrawHideForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);

    if(g_KladPersistentData[persistent_idx][klad_is_searching_P]) {
        SendClientMessage(playerid, COLOR_YELLOW, "Вы продолжаете поиск клада. Используйте /dig, когда найдете его, или /cancelklad.");
    }
    return 1;
}

public Klad_OnPlayerDisconnect(playerid, reason)
{
    new persistent_idx = KladPlayerSessionData[playerid][klad_persistent_idx];
    if(persistent_idx != -1)
    {
        // Не сбрасываем klad_is_searching_P, чтобы статус сохранялся.
    } else {
        printf("Klad_OnPlayerDisconnect: persistent_idx = -1 for play

erid %d", playerid);
    }

    if(KladPlayerSessionData[playerid][klad_radar_text] != PlayerText:INVALID_TEXT_DRAW)
    {
        TextDrawDestroy(KladPlayerSessionData[playerid][klad_radar_text]);
        KladPlayerSessionData[playerid][klad_radar_text] = PlayerText:INVALID_TEXT_DRAW;
    }
    RemovePlayerMapIcon(playerid, 25);

    new timerid = GetTimerEx("UpdateKladRadar", "i", playerid);
    if(timerid != -1) KillTimer(timerid);

    return 1;
}

public Klad_OnPlayerCommandText(playerid, cmdtext[])
{
    new persistent_idx = KladPlayerSessionData[playerid][klad_persistent_idx];
    if (persistent_idx == -1) {
        SendClientMessage(playerid, COLOR_RED, "Ошибка системы кладов: данные не загружены. Переподключитесь.");
        return 1;
    }

    if(strcmp(cmdtext, "/klado", true) == 0)
    {
        if(KladPlayerSessionData[playerid][klad_is_searching])
        {
            SendClientMessage(playerid, COLOR_RED, "Вы уже ищете клад! Найдите его или пропишите /cancelklad.");
            return 1;
        }

        new current_time = gettime();
        if(g_KladPersistentData[persistent_idx][klad_cooldown_end_time_P] > current_time)
        {
            new remaining_time = g_KladPersistentData[persistent_idx][klad_cooldown_end_time_P] - current_time;
            new hours = remaining_time / 3600;
            new minutes = (remaining_time % 3600) / 60;
            new seconds = remaining_time % 60;
            new str_cooldown[128];

            if (hours > 0) format(str_cooldown, sizeof(str_cooldown), "Вы сможете взять новый заказ на клад через: %02d:%02d:%02d", hours, minutes, seconds);
            else format(str_cooldown, sizeof(str_cooldown), "Вы сможете взять новый заказ на клад через: %02d:%02d", minutes, seconds);

            SendClientMessage(playerid, COLOR_LIGHTBLUE, str_cooldown);
            return 1;
        }

        new random_spot_index = random(MAX_CLAN_SPOTS);

        g_KladPersistentData[persistent_idx][klad_base_x_P] = KLADO_SPOTS[random_spot_index][0];
        g_KladPersistentData[persistent_idx][klad_base_y_P] = KLADO_SPOTS[random_spot_index][1];
        g_KladPersistentData[persistent_idx][klad_base_z_P] = KLADO_SPOTS[random_spot_index][2];

        new Float:angle = random_float(0.0, 360.0);
        new Float:distance_from_base = random_float(0.0, CLAN_SEARCH_RADIUS);

        g_KladPersistentData[persistent_idx][klad_pos_x_P] = g_KladPersistentData[persistent_idx][klad_base_x_P] + (distance_from_base * floatsin(angle, degrees));
        g_KladPersistentData[persistent_idx][klad_pos_y_P] = g_KladPersistentData[persistent_idx][klad_base_y_P] + (distance_from_base * floatcos(angle, degrees));

        GetGroundZFor3DCoord(g_KladPersistentData[persistent_idx][klad_pos_x_P], g_KladPersistentData[persistent_idx][klad_pos_y_P], g_KladPersistentData[persistent_idx][klad_base_z_P] + 1.0, g_KladPersistentData[persistent_idx][klad_pos_z_P]);
        g_KladPersistentData[persistent_idx][klad_pos_z_P] += 1.0;

        KladPlayerSessionData[playerid][klad_is_searching] = true;
        g_KladPersistentData[persistent_idx][klad_is_searching_P] = true;

        SetPlayerMapIcon(playerid, 25, g_KladPersistentData[persistent_idx][klad_base_x_P], g_KladPersistentData[persistent_idx][klad_base_y_P], g_KladPersistentData[persistent_idx][klad_base_z_P], 0, 0);

        SendClientMessage(playerid, COLOR_WHITE, "На карте появилась метка - это примерный центр поиска.");
        new str_info[256];
        format(str_info, sizeof(str_info), "Клад спрятан где-то в радиусе %.1f метров от этой метки!", CLAN_SEARCH_RADIUS);
        SendClientMessage(playerid, COLOR_GREEN, str_info);

        TextDrawShowForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
        new timerid = GetTimerEx("UpdateKladRadar", "i", playerid);
        if(timerid != -1) KillTimer(timerid);
        SetTimerEx("UpdateKladRadar", 1000, true, "i", playerid);
        return 1;
    }
    if(strcmp(cmdtext, "/dig", true) == 0)
    {
        if(KladPlayerSessionData[playerid][klad_is_digging])
        {
            SendCl

ientMessage(playerid, COLOR_RED, "Вы уже копаете! Дождитесь завершения.");
            return 1;
        }
        
        if(!g_KladPersistentData[persistent_idx][klad_is_searching_P])
        {
            SendClientMessage(playerid, COLOR_RED, "Вы не ищете клад. Используйте /klado для создания заказа.");
            return 1;
        }
        
        if(!KladPlayerSessionData[playerid][klad_is_searching])
        {
            KladPlayerSessionData[playerid][klad_is_searching] = true;
            SetPlayerMapIcon(playerid, 25, g_KladPersistentData[persistent_idx][klad_base_x_P], g_KladPersistentData[persistent_idx][klad_base_y_P], g_KladPersistentData[persistent_idx][klad_base_z_P], 0, 0);
            TextDrawShowForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
            new timerid = GetTimerEx("UpdateKladRadar", "i", playerid);
            if(timerid != -1) KillTimer(timerid);
            SetTimerEx("UpdateKladRadar", 1000, true, "i", playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "Поиск клада возобновлен. Радар и метка активированы.");
        }


        new Float:player_x, Float:player_y, Float:player_z;
        GetPlayerPos(playerid, player_x, player_y, player_z);

        new Float:distance = GetDistanceBetweenCoords(
            player_x, player_y, player_z,
            g_KladPersistentData[persistent_idx][klad_pos_x_P],
            g_KladPersistentData[persistent_idx][klad_pos_y_P],
            g_KladPersistentData[persistent_idx][klad_pos_z_P]
        );

        if(distance <= 3.0)
        {
            SendClientMessage(playerid, COLOR_WHITE, "Копаем... Не двигайтесь!");
            PlayAnimation(playerid, "PED", "FIRE_EXTINGUISH", 4.0, 0, 0, 1, 0, 0);
            
            KladPlayerSessionData[playerid][klad_is_digging] = true;
            SetTimerEx("GiveMoneyAndCleanUp", KladAnimationTime, false, "i", playerid);

            g_KladPersistentData[persistent_idx][klad_cooldown_end_time_P] = gettime() + KladCooldownTime;
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "Здесь пусто. Продолжайте искать!");
            new str_dist[128];
            format(str_dist, sizeof(str_dist), "До клада еще %.2f метров.", distance);
            SendClientMessage(playerid, COLOR_YELLOW, str_dist);
        }
        return 1;
    }
    
    if(strcmp(cmdtext, "/cancelklad", true) == 0)
    {
        if(g_KladPersistentData[persistent_idx][klad_is_searching_P] || KladPlayerSessionData[playerid][klad_is_digging])
        {
            KladPlayerSessionData[playerid][klad_is_searching] = false;
            g_KladPersistentData[persistent_idx][klad_is_searching_P] = false;
            KladPlayerSessionData[playerid][klad_is_digging] = false;

            RemovePlayerMapIcon(playerid, 25);
            TextDrawHideForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
            ClearAnimations(playerid, 1);

            new timerid_radar = GetTimerEx("UpdateKladRadar", "i", playerid);
            if(timerid != -1) KillTimer(timerid);

            new timerid_money = GetTimerEx("GiveMoneyAndCleanUp", "i", playerid);
            if(timerid != -1) KillTimer(timerid);

            SendClientMessage(playerid, COLOR_WHITE, "Вы отменили поиск клада.");
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "Вы сейчас не ищете клад.");
        }
        return 1;
    }
    return 0;
}

public GiveMoneyAndCleanUp(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new persistent_idx = KladPlayerSessionData[playerid][klad_persistent_idx];
    if (persistent_idx == -1) return 1;

    ClearAnimations(playerid, 1);

    GivePlayerMoney(playerid, 16500);
    SendClientMessage(playerid, COLOR_GREEN, "Вы получили 16500 денег за найденный клад!");

    RemovePlayerMapIcon(playerid, 25);
    TextDrawHideForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
    
    KladPlayerSessionData[playerid][klad_is_searching] = false;
    g_KladPersistentData[persistent_idx][klad_is_searching_P] = false;
    KladPlayerSessionData[playerid][klad_is_digging] = false;

    new timerid_radar = GetTimerEx("UpdateKladRadar", "i", playerid);
    if(timerid != -1) KillTimer(timerid);
    
    return 1;
}

public UpdateKladRadar(playerid)
{
    if(!IsPlayerConnected(playerid)) {
        TextDrawHideForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
        return KillTimer(GetTimer());
    }

    new persistent_idx = KladPlayerSessionData[playerid][klad_persistent_idx];
    if (persistent_idx == -1 || !KladPlayerSessionData[playerid][klad_is_searching]) {
        TextDrawHideForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
        return KillTimer(GetTimer());
    }

    new Float:player_x, Float:player_y, Float:player_z;
    GetPlayerPos(playerid, player_x, player_y, player_z);

    new Float:distance = GetDistanceBetweenCoords(
        player_x, player_y, player_z,
        g_KladPersistentData[persistent_idx][klad_pos_x_P],
        g_KladPersistentData[persistent_idx][klad_pos_y_P],
        g_KladPersistentData[persistent_idx][klad_pos_z_P]
    );

    new text_buffer[64];
    if (distance <= 5.0)
    {
        format(text_buffer, sizeof(text_buffer), "~g~Горячо! (%.1fm)", distance);
        TextDrawColor(KladPlayerSessionData[playerid][klad_radar_text], COLOR_GREEN);
    }
    else if (distance <= 10.0)
    {
        format(text_buffer, sizeof(text_buffer), "~y~Тепло! (%.1fm)", distance);
        TextDrawColor(KladPlayerSessionData[playerid][klad_radar_text], COLOR_YELLOW);
    }
    else
    {
        format(text_buffer, sizeof(text_buffer), "~r~Холодно. (%.1fm)", distance);
        TextDrawColor(KladPlayerSessionData[playerid][klad_radar_text], COLOR_RED);
    }

    TextDrawSetString(KladPlayerSessionData[playerid][klad_radar_text], text_buffer);
    TextDrawShowForPlayer(playerid, KladPlayerSessionData[playerid][klad_radar_text]);
    return 1;
}