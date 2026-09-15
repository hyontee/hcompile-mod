#if defined _LUCKSHERY_INC_
    #endinput
#endif
#define _LUCKSHERY_INC_

#define LUCKSHERY_MIN_PLAYERS 3
#define LUCKSHERY_MONEY_MIN 2500
#define LUCKSHERY_MONEY_MAX 10000
#define LUCKSHERY_BC_MIN 10
#define LUCKSHERY_BC_MAX 25
#define LUCKSHERY_JACKPOT_MONEY 25000
#define LUCKSHERY_JACKPOT_BC 100

new g_luckshery_last_hour = -1;

forward Luckshery_Timer();

stock Luckshery_Init()
{
    g_luckshery_last_hour = -1;
    SetTimer("Luckshery_Timer", 60000, true);
    return 1;
}

public Luckshery_Timer()
{
    new hour, minute, second;
    gettime(hour, minute, second);

    if(minute != 0)
        return 1;

    new current_hour = gettime() / 3600;
    if(current_hour == g_luckshery_last_hour)
        return 1;

    g_luckshery_last_hour = current_hour;

    new online_count;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        online_count++;
    }

    if(online_count < LUCKSHERY_MIN_PLAYERS)
    {
        SendClientMessageToAll(0xAAAAAAFF, "[LUCK] Розыгрыш не состоялся: на сервере должно быть минимум 3 игрока.");
        return 1;
    }

    new target = INVALID_PLAYER_ID;
    new target_index = random(online_count);
    new current_index;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;

        if(current_index == target_index)
        {
            target = i;
            break;
        }
        current_index++;
    }

    if(target == INVALID_PLAYER_ID)
        return 1;

    new roll = random(100);
    new prize_money;
    new prize_bc;
    new message[256];

    if(roll < 75)
    {
        prize_money = LUCKSHERY_MONEY_MIN + random(LUCKSHERY_MONEY_MAX - LUCKSHERY_MONEY_MIN + 1);
        GivePlayerMoneyEx(target, prize_money, "Часовая удача", true, true);

        format(message, sizeof(message), "{00FF00}[LUCK] {FFFFFF}Каждый час сервер выбирает счастливчика! Сейчас им стал %s и получил %d руб.", GetPlayerNameEx(target), prize_money);
    }
    else if(roll < 95)
    {
        prize_bc = LUCKSHERY_BC_MIN + random(LUCKSHERY_BC_MAX - LUCKSHERY_BC_MIN + 1);
        GivePlayerDonateRub(target, prize_bc, "Часовая удача", true, true);

        format(message, sizeof(message), "{00FFFF}[LUCK] {FFFFFF}Каждый час сервер выбирает счастливчика! Сейчас им стал %s и получил %d BC.", GetPlayerNameEx(target), prize_bc);
    }
    else
    {
        GivePlayerMoneyEx(target, LUCKSHERY_JACKPOT_MONEY, "Джекпот часовой удачи", true, true);
        GivePlayerDonateRub(target, LUCKSHERY_JACKPOT_BC, "Джекпот часовой удачи", true, true);

        format(message, sizeof(message), "{FFFF00}[LUCK] {FFFFFF}ДЖЕКПОТ! Счастливчиком часа стал %s! Приз: %d руб. + %d BC!", GetPlayerNameEx(target), LUCKSHERY_JACKPOT_MONEY, LUCKSHERY_JACKPOT_BC);
    }

    SendClientMessageToAll(-1, message);
    return 1;
}
