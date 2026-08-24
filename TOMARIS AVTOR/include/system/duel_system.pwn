// ==============================================
//              DUEL SYSTEM
// ==============================================

// ============ ПЕРЕМЕННЫЕ ============
new g_DuelRequest[MAX_PLAYERS];
new g_DuelTarget[MAX_PLAYERS];
new bool:g_InDuel[MAX_PLAYERS];
new g_DuelBet[MAX_PLAYERS];

// ============ ОПРЕДЕЛЕНИЯ ДИАЛОГОВ ============
#define DIALOG_DUEL_REQUEST 5000
#define DIALOG_DUEL_BET 5102

// ============ КОМАНДА /duel ============
CMD:duel(playerid, params[])
{
    new targetid;

    if(sscanf(params, "d", targetid))
        return SendClientMessage(playerid, -1, "Используйте: /duel [id игрока]");

    if(!IsPlayerConnected(targetid) || targetid == playerid)
        return SendClientMessage(playerid, -1, "Игрок не найден");

    if(g_InDuel[playerid] || g_InDuel[targetid])
        return SendClientMessage(playerid, -1, "Кто-то уже находится в дуэли");

    g_DuelRequest[playerid] = targetid;

    ShowPlayerDialog(playerid,
        DIALOG_DUEL_BET,
        DIALOG_STYLE_INPUT,
        "Ставка на дуэль",
        "Введите сумму ставки\n\nМинимум: 1000\nМаксимум: 100000",
        "Далее",
        "Отмена");

    return 1;
}

// ============ ФУНКЦИЯ ИНИЦИАЛИЗАЦИИ ============
stock Duel_Init()
{
    print("[DuelSystem] Система дуэли загружена!");
    return 1;
}

// ============ ФУНКЦИЯ ДЛЯ ОЧИСТКИ ============
stock Duel_Reset(playerid)
{
    g_DuelRequest[playerid] = 0;
    g_DuelTarget[playerid] = 0;
    g_InDuel[playerid] = false;
    g_DuelBet[playerid] = 0;
    return 1;
}