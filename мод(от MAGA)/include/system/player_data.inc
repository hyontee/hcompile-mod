// player_data.inc
#if defined _player_data_included
    #endinput
#endif
#define _player_data_included

// ===== ЦВЕТА =====
#define COLOUR_GREY   0xAFAFAFFF
#define COLOUR_RED    0xFF0000FF
#define COLOUR_WHITE  0xFFFFFFFF
#define COLOUR_BLACK  0x000000FF
#define COLOUR_BLUE   0x0000FFFF
#define COLOUR_YELLOW 0xFFFF00FF
#define COLOUR_GREEN  0x00FF00FF
#define COLOUR_PEEL   0xAFDFEFFF
#define COLOUR_HALF   0x80FFFFFF

#define COLOR_GREY    COLOUR_GREY
#define COLOR_RED     COLOUR_RED
#define COLOR_WHITE   COLOUR_WHITE
#define COLOR_BLACK   COLOUR_BLACK
#define COLOR_BLUE    COLOUR_BLUE
#define COLOR_YELLOW  COLOUR_YELLOW
#define COLOR_GREEN   COLOUR_GREEN

// ===== MySQL HANDLE =====
new db_handle;

// ===== НАСТРОЙКИ =====
#define MAX_PLAYER_VEHICLES 10
#define MAX_PLAYER_NAME 24

// ===== ДАННЫЕ ИГРОКА =====
enum player_data {
    pID,
    pName[MAX_PLAYER_NAME],
    pAdminAuth,
    pAdminLvl,
    pCountTodayCases,
    pCountBomjCases,
    pCountStandartCases,
    pCountCarCases,
    pCountOsobiyCases,
    pExp,
    pLevel,
    pVipType,
    pVipTime,
    pBlackCoin,
    pMoney,
    pKills,
    pDeaths
}

new Player[MAX_PLAYERS][player_data];

// ===== ТРАНСПОРТ =====
enum v_data {
    vDBID,
    vModel,
    vPos[4]
}

new VehicleInfo[MAX_PLAYERS][MAX_PLAYER_VEHICLES][v_data];

// ===== ФУНКЦИИ =====

// BlackCoin
stock GetPlayerBlackCoin(playerid) {
    return Player[playerid][pBlackCoin];
}

stock GivePlayerBlackCoin(playerid, amount) {
    Player[playerid][pBlackCoin] += amount;
    return 1;
}

// PlayEvent
stock PlayEvent(playerid, eventid, value1 = 0, value2 = 0, value3 = 0) {
    return 1;
}

// Деньги
stock GivePlayerMoneyEx(playerid, amount) {
    GivePlayerMoney(playerid, amount);
    Player[playerid][pMoney] += amount;
    return 1;
}

// Сохранение
stock SavePlayerAccount(playerid) {
    return 1;
}

// Уведомления
stock ShowNotification(playerid, type, time, sound, icon, const text[], const action[]) {
    SendClientMessage(playerid, COLOUR_WHITE, text);
    return 1;
}

// Packet
stock OnPacketIncoming(playerid, packetid, node) {
    return 1;
}

// Предметы
stock GivePlayerItem(playerid, itemid, count) {
    return 1;
}

stock GivePlayerSkin(playerid, skinid) {
    return 1;
}

// Отключаем конфликты с Pawn.CMD
#if defined pc_cmd_cases
    #undef pc_cmd_cases
#endif

#if defined pc_cmd_givecases
    #undef pc_cmd_givecases
#endif

#if defined pc_cmd_reward
    #undef pc_cmd_reward
#endif

// Чтобы команды работали с Pawn.CMD
#define CMD:%0(%1) pc_cmd_%0(%1)