// polia.inc подключения крч.
#if defined _polia_included
    #endinput
#endif
#define _polia_included

#include <a_samp>
#include <zcmd>

#define FARM_PICKUP 1314
#define FARM_X 1642.323974
#define FARM_Y 1330.526733
#define FARM_Z 12.901528
#define REQUIRED_LEVEL 5
#define WORKER_SKIN 8
#define GROW_TIME 8000
#define HARVEST_AMOUNT 5
#define SELL_PRICE 1000000
#define DIALOG_JOIN 9991

static farm_pickup, farm_label;
static farm_job[MAX_PLAYERS], farm_melons[MAX_PLAYERS], farm_growing[MAX_PLAYERS], farm_ready[MAX_PLAYERS];

forward Farm_GrowComplete(playerid);

stock Farm_Init()
{
    farm_pickup = CreatePickup(FARM_PICKUP, 23, FARM_X, FARM_Y, FARM_Z, -1);
    farm_label = Create3DTextLabel("{FF5252}Работа поля\n{DCDCDC}[Подойдите]", 0xFFFFFFFF, FARM_X, FARM_Y, FARM_Z+0.7, 10.0, 0, 0);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == farm_pickup)
    {
        if(farm_job[playerid]) return 1;
        if(GetPlayerLevel(playerid) < REQUIRED_LEVEL)
        {
            new str[64]; format(str, 64, "Нужен %d уровень.", REQUIRED_LEVEL);
            SendClientMessage(playerid, 0xFF0000FF, str);
            return 1;
        }
        ShowPlayerDialog(playerid, DIALOG_JOIN, DIALOG_STYLE_MSGBOX, "Работа на полях", "Устроиться фермером?\nСкин 8 и команды: /arbuzplant, /arbuzka, /sellarbuz", "Да", "Нет");
        return 1;
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_JOIN && response)
    {
        farm_job[playerid] = 1;
        SetPlayerSkin(playerid, WORKER_SKIN);
        SendClientMessage(playerid, 0x00FF00FF, "Вы устроились на работу 'Поля'. Скин выдан.");
        SendClientMessage(playerid, 0xFFFF00FF, "Команды: /arbuzplant, /arbuzka, /sellarbuz.");
        return 1;
    }
    return 0;
}

CMD:arbuzplant(playerid, params[])
{
    if(!farm_job[playerid]) return SendClientMessage(playerid, 0xFF0000FF, "Не работаете на полях.");
    if(farm_growing[playerid]) return SendClientMessage(playerid, 0xFFA500FF, "Арбузы уже растут (8 сек).");
    if(farm_melons[playerid] + HARVEST_AMOUNT > 100) return SendClientMessage(playerid, 0xFF0000FF, "Слишком много арбузов. Продайте /sellarbuz.");
    farm_growing[playerid] = 1;
    ApplyAnimation(playerid, "GRAVEYARD", "PRY_LOOP", 4.1, 0, 0, 0, 0, 0, 1);
    TogglePlayerControllable(playerid, 0);
    SendClientMessage(playerid, 0xFFFF00FF, "Сажаем 5 арбузов... 8 секунд.");
    SetTimerEx("Farm_GrowComplete", GROW_TIME, false, "i", playerid);
    return 1;
}

CMD:arbuzka(playerid, params[])
{
    if(!farm_job[playerid]) return SendClientMessage(playerid, 0xFF0000FF, "Не работаете на полях.");
    if(farm_ready[playerid] == 0) return SendClientMessage(playerid, 0xFFA500FF, "Нет выросших арбузов.");
    farm_melons[playerid] += farm_ready[playerid];
    new str[64]; format(str, 64, "Собрано %d арбузов. Всего: %d", farm_ready[playerid], farm_melons[playerid]);
    SendClientMessage(playerid, 0x00FF00FF, str);
    farm_ready[playerid] = 0;
    return 1;
}

CMD:sellarbuz(playerid, params[])
{
    if(!farm_job[playerid]) return SendClientMessage(playerid, 0xFF0000FF, "Не работаете на полях.");
    if(farm_melons[playerid] == 0) return SendClientMessage(playerid, 0xFF0000FF, "Нет арбузов.");
    new money = farm_melons[playerid] * SELL_PRICE;
    GivePlayerMoney(playerid, money);
    new str[64]; format(str, 64, "Продано %d арбузов за %d.", farm_melons[playerid], money);
    SendClientMessage(playerid, 0x00FF00FF, str);
    farm_melons[playerid] = 0;
    return 1;
}

public Farm_GrowComplete(playerid)
{
    farm_growing[playerid] = 0;
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);
    farm_ready[playerid] = HARVEST_AMOUNT;
    SendClientMessage(playerid, 0x00FF00FF, "5 арбузов выросли! Соберите /arbuzka.");
}

static GetPlayerLevel(playerid)
{
    #if defined GetPlayerLevel
        return GetPlayerLevel(playerid);
    #else
        return 5;
    #endif
}
#endif


////тд и новачка