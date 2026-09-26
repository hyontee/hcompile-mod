// duel_system.inc
#if defined _duel_system_included
    #endinput
#endif
#define _duel_system_included


#define MAX_DUELS 10
#define MAX_DUEL_PRIZE 2000000
#define DUEL_COUNTDOWN 5
#define DUEL_WEAPON 24
#define DUEL_AMMO 1000
#define BASE_WORLD 1000

enum duelInfo
{
    bool:duelActive,
    duelPrize,
    duelPlayers[2],
    duelWorld,
    duelTimer,
    duelCountdown,
    bool:duelStarted
};

static DuelInfo[MAX_DUELS][duelInfo];

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit duel_OnGameModeInit
forward duel_OnGameModeInit();

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect duel_OnPlayerDisconnect
forward duel_OnPlayerDisconnect(playerid, reason);

#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath duel_OnPlayerDeath
forward duel_OnPlayerDeath(playerid, killerid, reason);

public duel_OnGameModeInit()
{
    for(new i = 0; i < MAX_DUELS; i++)
    {
        DuelInfo[i][duelActive] = false;
        DuelInfo[i][duelPlayers][0] = INVALID_PLAYER_ID;
        DuelInfo[i][duelPlayers][1] = INVALID_PLAYER_ID;
    }
    print("Дуэльная система загружена!");
    
    #if defined duel_OnGameModeInit
        return duel_OnGameModeInit();
    #else
        return 1;
    #endif
}

public duel_OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < MAX_DUELS; i++)
    {
        if(DuelInfo[i][duelActive])
        {
            for(new j = 0; j < 2; j++)
            {
                if(DuelInfo[i][duelPlayers][j] == playerid)
                {
                    new otherplayer = (j == 0) ? DuelInfo[i][duelPlayers][1] : DuelInfo[i][duelPlayers][0];
                    new string[128];
                    
                    if(otherplayer != INVALID_PLAYER_ID && IsPlayerConnected(otherplayer))
                    {
                        GivePlayerMoney(otherplayer, DuelInfo[i][duelPrize]);
                        ResetPlayerWeapons(otherplayer);
                        SetPlayerVirtualWorld(otherplayer, 0);
                        SetPlayerInterior(otherplayer, 0);
                        SetPlayerHealth(otherplayer, 100);
                        SetPlayerArmour(otherplayer, 0);
                        TogglePlayerControllable(otherplayer, true);
                        SetCameraBehindPlayer(otherplayer);
                        
                        format(string, sizeof(string), "Дуэль #%d отменена. Соперник вышел. Вы получили %d руб. назад!", i, DuelInfo[i][duelPrize]);
                        SendClientMessage(otherplayer, 0x00FF00AA, string);
                    }
                    
                    KillTimer(DuelInfo[i][duelTimer]);
                    DuelInfo[i][duelActive] = false;
                    DuelInfo[i][duelPlayers][0] = INVALID_PLAYER_ID;
                    DuelInfo[i][duelPlayers][1] = INVALID_PLAYER_ID;
                    
                    format(string, sizeof(string), "Дуэль #%d отменена - игрок вышел!", i);
                    SendClientMessageToAll(0xFF0000AA, string);
                    break;
                }
            }
        }
    }
    
    #if defined duel_OnPlayerDisconnect
        return duel_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

public duel_OnPlayerDeath(playerid, killerid, reason)
{
    for(new i = 0; i < MAX_DUELS; i++)
    {
        if(DuelInfo[i][duelActive] && DuelInfo[i][duelStarted])
        {
            for(new j = 0; j < 2; j++)
            {
                if(DuelInfo[i][duelPlayers][j] == playerid)
                {
                    new winner = (j == 0) ? DuelInfo[i][duelPlayers][1] : DuelInfo[i][duelPlayers][0];
                    new prize = DuelInfo[i][duelPrize] * 2;
                    new string[128];
                    
                    if(IsPlayerConnected(winner))
                    {
                        GivePlayerMoney(winner, prize);
                        format(string, sizeof(string), "Поздравляем! Вы выиграли дуэль #%d и получаете %d руб.!", i, prize);
                        SendClientMessage(winner, 0x00FF00AA, string);
                        
                        ResetPlayerWeapons(winner);
                        SetPlayerVirtualWorld(winner, 0);
                        SetPlayerInterior(winner, 0);
                        SetPlayerHealth(winner, 100);
                        SetPlayerArmour(winner, 0);
                        SetCameraBehindPlayer(winner);
                        TogglePlayerControllable(winner, true);
                    }
                    
                    format(string, sizeof(string), "Игрок %s выиграл дуэль #%d и получает %d руб.!", 
                        GetPlayerName(winner), i, prize);
                    SendClientMessageToAll(0x00FF00AA, string);
                    
                    if(IsPlayerConnected(playerid))
                    {
                        ResetPlayerWeapons(playerid);
                        SetPlayerVirtualWorld(playerid, 0);
                        SetPlayerInterior(playerid, 0);
                        SetPlayerHealth(playerid, 100);
                        SetPlayerArmour(playerid, 0);
                        SetCameraBehindPlayer(playerid);
                        TogglePlayerControllable(playerid, true);
                    }
                    
                    DuelInfo[i][duelActive] = false;
                    DuelInfo[i][duelStarted] = false;
                    DuelInfo[i][duelPlayers][0] = INVALID_PLAYER_ID;
                    DuelInfo[i][duelPlayers][1] = INVALID_PLAYER_ID;
                    
                    KillTimer(DuelInfo[i][duelTimer]);
                    break;
                }
            }
        }
    }
    
    #if defined duel_OnPlayerDeath
        return duel_OnPlayerDeath(playerid, killerid, reason);
    #else
        return 1;
    #endif
}

forward CheckDuelStart(slot);
public CheckDuelStart(slot)
{
    if(DuelInfo[slot][duelActive] && DuelInfo[slot][duelPlayers][1] == INVALID_PLAYER_ID)
    {
        DuelInfo[slot][duelActive] = false;
        
        if(IsPlayerConnected(DuelInfo[slot][duelPlayers][0]))
        {
            GivePlayerMoney(DuelInfo[slot][duelPlayers][0], DuelInfo[slot][duelPrize]);
        }
        
        new string[128];
        format(string, sizeof(string), "Дуэль #%d отменена - не нашлось второго игрока!", slot);
        SendClientMessageToAll(0xFF0000AA, string);
        
        DuelInfo[slot][duelPlayers][0] = INVALID_PLAYER_ID;
    }
}

forward DuelCountdown(slot);
public DuelCountdown(slot)
{
    if(!DuelInfo[slot][duelActive]) return;
    
    DuelInfo[slot][duelCountdown]--;
    
    new string[128];
    if(DuelInfo[slot][duelCountdown] > 0)
    {
        format(string, sizeof(string), "До начала дуэли: %d", DuelInfo[slot][duelCountdown]);
        if(IsPlayerConnected(DuelInfo[slot][duelPlayers][0])) SendClientMessage(DuelInfo[slot][duelPlayers][0], 0xFFFF00AA, string);
        if(IsPlayerConnected(DuelInfo[slot][duelPlayers][1])) SendClientMessage(DuelInfo[slot][duelPlayers][1], 0xFFFF00AA, string);
    }
    else
    {
        if(IsPlayerConnected(DuelInfo[slot][duelPlayers][0])) 
        {
            SendClientMessage(DuelInfo[slot][duelPlayers][0], 0x00FF00AA, "Дуэль началась!");
            TogglePlayerControllable(DuelInfo[slot][duelPlayers][0], true);
            SetCameraBehindPlayer(DuelInfo[slot][duelPlayers][0]);
        }
        if(IsPlayerConnected(DuelInfo[slot][duelPlayers][1])) 
        {
            SendClientMessage(DuelInfo[slot][duelPlayers][1], 0x00FF00AA, "Дуэль началась!");
            TogglePlayerControllable(DuelInfo[slot][duelPlayers][1], true);
            SetCameraBehindPlayer(DuelInfo[slot][duelPlayers][1]);
        }
        
        DuelInfo[slot][duelStarted] = true;
        KillTimer(DuelInfo[slot][duelTimer]);
    }
}

CMD:duels(playerid, params[])
{
    if(GetPlayerMoney(playerid) < 5000) 
        return SendClientMessage(playerid, 0xFF0000AA, "Нужно минимум 5000 руб. для создания дуэли!");
    
    new prize;
    if(sscanf(params, "i", prize)) 
        return SendClientMessage(playerid, 0xFFFFFFFF, "Использование: /duels [сумма приза]");
    
    if(prize < 5000 || prize > MAX_DUEL_PRIZE) 
        return SendClientMessage(playerid, 0xFF0000AA, "Приз должен быть от 5,000 до 2,000,000 руб.!");
    
    if(GetPlayerMoney(playerid) < prize) 
        return SendClientMessage(playerid, 0xFF0000AA, "У вас недостаточно денег для такого приза!");
    
    new slot = -1;
    for(new i = 0; i < MAX_DUELS; i++)
    {
        if(!DuelInfo[i][duelActive])
        {
            slot = i;
            break;
        }
    }
    
    if(slot == -1) return SendClientMessage(playerid, 0xFF0000AA, "Все слоты для дуэлей заняты!");
    
    DuelInfo[slot][duelActive] = true;
    DuelInfo[slot][duelPrize] = prize;
    DuelInfo[slot][duelPlayers][0] = playerid;
    DuelInfo[slot][duelPlayers][1] = INVALID_PLAYER_ID;
    DuelInfo[slot][duelWorld] = BASE_WORLD + slot;
    DuelInfo[slot][duelCountdown] = 0;
    DuelInfo[slot][duelStarted] = false;
    
    GivePlayerMoney(playerid, -prize);
    
    new string[256];
    format(string, sizeof(string), "Дуэль #%d создана! Приз: %d руб. Напишите {FFFFFF}/joinduel %d{00FF00} чтобы присоединиться", 
        slot, prize, slot);
    SendClientMessageToAll(0x00FF00AA, string);
    
    DuelInfo[slot][duelTimer] = SetTimerEx("CheckDuelStart", 30000, false, "i", slot);
    return 1;
}

CMD:joinduel(playerid, params[])
{
    new slot;
    if(sscanf(params, "i", slot))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Использование: /joinduel [номер дуэли]");
    
    if(slot < 0 || slot >= MAX_DUELS)
        return SendClientMessage(playerid, 0xFF0000AA, "Неверный номер дуэли!");
    
    if(!DuelInfo[slot][duelActive])
        return SendClientMessage(playerid, 0xFF0000AA, "Эта дуэль не активна!");
    
    if(DuelInfo[slot][duelPlayers][1] != INVALID_PLAYER_ID)
        return SendClientMessage(playerid, 0xFF0000AA, "В этой дуэли уже есть второй игрок!");
    
    if(GetPlayerMoney(playerid) < DuelInfo[slot][duelPrize])
    {
        new string[128];
        format(string, sizeof(string), "Нужно %d руб. для участия в дуэли!", DuelInfo[slot][duelPrize]);
        return SendClientMessage(playerid, 0xFF0000AA, string);
    }
    
    DuelInfo[slot][duelPlayers][1] = playerid;
    GivePlayerMoney(playerid, -DuelInfo[slot][duelPrize]);
    
    new string[256];
    format(string, sizeof(string), "Игрок %s присоединился к дуэли #%d! Приз: %d руб.", 
        GetPlayerName(playerid), slot, DuelInfo[slot][duelPrize]);
    SendClientMessageToAll(0x00FF00AA, string);
    
    KillTimer(DuelInfo[slot][duelTimer]);
    
    // Телепортируем игроков на арену
    new Float:pos1[4] = {1924.660400, -1894.134033, 56.461780, 94.463844};
    new Float:pos2[4] = {1910.443725, -1894.867553, 56.461780, 266.288635};
    
    // Первый игрок
    if(IsPlayerConnected(DuelInfo[slot][duelPlayers][0]))
    {
        SetPlayerPos(DuelInfo[slot][duelPlayers][0], pos1[0], pos1[1], pos1[2]);
        SetPlayerFacingAngle(DuelInfo[slot][duelPlayers][0], pos1[3]);
        SetPlayerVirtualWorld(DuelInfo[slot][duelPlayers][0], DuelInfo[slot][duelWorld]);
        SetPlayerInterior(DuelInfo[slot][duelPlayers][0], 0);
    }
    
    // Второй игрок
    if(IsPlayerConnected(DuelInfo[slot][duelPlayers][1]))
    {
        SetPlayerPos(DuelInfo[slot][duelPlayers][1], pos2[0], pos2[1], pos2[2]);
        SetPlayerFacingAngle(DuelInfo[slot][duelPlayers][1], pos2[3]);
        SetPlayerVirtualWorld(DuelInfo[slot][duelPlayers][1], DuelInfo[slot][duelWorld]);
        SetPlayerInterior(DuelInfo[slot][duelPlayers][1], 0);
    }
    
    // Выдаем оружие и броню
    for(new i = 0; i < 2; i++)
    {
        if(IsPlayerConnected(DuelInfo[slot][duelPlayers][i]))
        {
            ResetPlayerWeapons(DuelInfo[slot][duelPlayers][i]);
            GivePlayerWeapon(DuelInfo[slot][duelPlayers][i], DUEL_WEAPON, DUEL_AMMO);
            SetPlayerHealth(DuelInfo[slot][duelPlayers][i], 100.0);
            SetPlayerArmour(DuelInfo[slot][duelPlayers][i], 100.0);
            TogglePlayerControllable(DuelInfo[slot][duelPlayers][i], false);
            SetCameraBehindPlayer(DuelInfo[slot][duelPlayers][i]);
        }
    }
    
    // Запускаем отсчет
    DuelInfo[slot][duelCountdown] = DUEL_COUNTDOWN;
    DuelInfo[slot][duelTimer] = SetTimerEx("DuelCountdown", 1000, true, "i", slot);
    
    if(IsPlayerConnected(DuelInfo[slot][duelPlayers][0])) 
        SendClientMessage(DuelInfo[slot][duelPlayers][0], 0xFFFF00AA, "Дуэль начинается! Приготовьтесь...");
    if(IsPlayerConnected(DuelInfo[slot][duelPlayers][1])) 
        SendClientMessage(DuelInfo[slot][duelPlayers][1], 0xFFFF00AA, "Дуэль начинается! Приготовьтесь...");
    
    return 1;
}

CMD:duelinfo(playerid)
{
    SendClientMessage(playerid, 0xFFFF00AA, "=== АКТИВНЫЕ ДУЭЛИ ===");
    new count = 0;
    for(new i = 0; i < MAX_DUELS; i++)
    {
        if(DuelInfo[i][duelActive])
        {
            new string[128];
            if(DuelInfo[i][duelPlayers][1] == INVALID_PLAYER_ID)
            {
                format(string, sizeof(string), "Дуэль #%d - Приз: %d руб. (Ожидает второго игрока)", i, DuelInfo[i][duelPrize]);
            }
            else
            {
                format(string, sizeof(string), "Дуэль #%d - Приз: %d руб. (Идет)", i, DuelInfo[i][duelPrize]);
            }
            SendClientMessage(playerid, 0x00FF00AA, string);
            count++;
        }
    }
    
    if(count == 0)
    {
        SendClientMessage(playerid, 0xFF0000AA, "Активных дуэлей нет!");
    }
    return 1;
}