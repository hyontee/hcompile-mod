
#if defined _polia_included
    #endinput
#endif
#define _polia_included

#include <a_samp>


#define FARM_NPC_X             1641.019409
#define FARM_NPC_Y             1328.844970
#define FARM_NPC_Z             12.852707
#define FARM_NPC_A             330.244842
#define FARM_NPC_SKIN          33



#define FARM_PICKUP_MODEL      1275
#define FARM_PICKUP_X          1641.305733
#define FARM_PICKUP_Y          1329.425286
#define FARM_PICKUP_Z          12.901528

#define REQUIRED_LEVEL         5
#define WORKER_SKIN            8
#define GROW_TIME              30000
#define HARVEST_AMOUNT         5
#define SELL_PRICE             285

#define DIALOG_FARM_JOB_MAIN   65001
#define DIALOG_FARM_JOB_HELP   65002

static farm_pickup = -1;
static Text3D:farm_label = Text3D:-1;
static farm_actor = -1;
static farm_job[MAX_PLAYERS];
static farm_old_skin[MAX_PLAYERS];
static farm_melons[MAX_PLAYERS];
static farm_growing[MAX_PLAYERS];
static farm_ready[MAX_PLAYERS];

forward Farm_GrowComplete(playerid);

stock Farm_Init()
{
    
    farm_actor = CreateActor(FARM_NPC_SKIN, FARM_NPC_X, FARM_NPC_Y, FARM_NPC_Z, FARM_NPC_A);

    
    farm_label = Create3DTextLabel(
        "{00FF00}[РАБОТА НА ПОЛЯХ]\n{FFFFFF}Подойдите для взаимодействия",
        0xFFFFFFFF,
        FARM_NPC_X, FARM_NPC_Y, FARM_NPC_Z + 1.0,
        10.0, 0, 0
    );

    
    farm_pickup = CreatePickup(FARM_PICKUP_MODEL, 23, FARM_PICKUP_X, FARM_PICKUP_Y, FARM_PICKUP_Z, -1);
    return 1;
}

stock Farm_OnPlayerPickUpPickupEx(playerid, pickupid)
{
    if(pickupid != farm_pickup) return 0;

    if(GetPlayerLevel(playerid) < REQUIRED_LEVEL)
    {
        new str[64];
        format(str, sizeof(str), "{FF0000}Для работы на полях нужен %d уровень.", REQUIRED_LEVEL);
        SendClientMessage(playerid, -1, str);
        return 1;
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_FARM_JOB_MAIN,
        DIALOG_STYLE_LIST,
        "Работа на полях",
        "Инструкция\nНачать/Закончить работу",
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

stock Farm_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_FARM_JOB_MAIN)
    {
        if(!response) return 1;

        switch(listitem)
        {
            case 0:
            {
                ShowPlayerDialog(
                    playerid,
                    DIALOG_FARM_JOB_HELP,
                    DIALOG_STYLE_MSGBOX,
                    "Инструкция — работа на полях",
                    "{FFFFFF}1. Устройтесь на работу через это меню.\n\n{FFFFFF}2. На синем пикапе находится рабочая раздевалка.\n\n{FFFFFF}3. {00FF00}/arbuzplant {FFFFFF}— посадить 5 арбузов.\n{FFFFFF}4. Через 30 секунд арбузы вырастут.\n{FFFFFF}5. {00FF00}/arbuzka {FFFFFF}— собрать выросшие арбузы.\n{FFFFFF}6. {00FF00}/sellarbuz {FFFFFF}— продать собранные арбузы.\n\n{FFFFFF}Цена одного арбуза: {FFFF00}285 руб.{FFFFFF}\nРост арбузов: {FFFF00}30 секунд{FFFFFF}.\n\n{FFFFFF}Чтобы закончить работу, снова откройте это меню и выберите «Начать/Закончить работу».",
                    "Назад",
                    ""
                );
            }
            case 1:
            {
                if(farm_job[playerid])
                {
                    farm_job[playerid] = 0;
                    farm_growing[playerid] = 0;
                    farm_ready[playerid] = 0;
                    SetPlayerSkin(playerid, farm_old_skin[playerid]);
                    SendClientMessage(playerid, 0xFFFF00FF, "Вы закончили работу на полях.");
                }
                else
                {
                    farm_old_skin[playerid] = GetPlayerSkin(playerid);
                    farm_job[playerid] = 1;
                    SetPlayerSkin(playerid, WORKER_SKIN);
                    SendClientMessage(playerid, 0x00FF00FF, "Вы устроились на работу на полях.");
                    SendClientMessage(playerid, 0xFFFF00FF, "Для помощи снова подойдите к рабочей точке и откройте «Инструкция». ");
                }
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_FARM_JOB_HELP)
    {
        
        if(response || !response)
        {
            ShowPlayerDialog(
                playerid,
                DIALOG_FARM_JOB_MAIN,
                DIALOG_STYLE_LIST,
                "Работа на полях",
                "Инструкция\nНачать/Закончить работу",
                "Выбрать",
                "Закрыть"
            );
        }
        return 1;
    }

    return 0;
}

CMD:arbuzplant(playerid, params[])
{
    #pragma unused params

    if(!farm_job[playerid]) return SendClientMessage(playerid, 0xFF0000FF, "Вы не работаете на полях.");
    if(farm_growing[playerid]) return SendClientMessage(playerid, 0xFFA500FF, "Арбузы уже растут. Подождите 30 секунд.");
    if(farm_melons[playerid] + HARVEST_AMOUNT > 100) return SendClientMessage(playerid, 0xFF0000FF, "Слишком много арбузов. Продайте их командой /sellarbuz.");

    farm_growing[playerid] = 1;
    ApplyAnimation(playerid, "GRAVEYARD", "PRY_LOOP", 4.1, 0, 0, 0, 0, 0, 1);
    TogglePlayerControllable(playerid, 0);
    SendClientMessage(playerid, 0xFFFF00FF, "Сажаем 5 арбузов... Подождите 30 секунд.");
    SetTimerEx("Farm_GrowComplete", GROW_TIME, false, "i", playerid);
    return 1;
}

CMD:arbuzka(playerid, params[])
{
    #pragma unused params

    if(!farm_job[playerid]) return SendClientMessage(playerid, 0xFF0000FF, "Вы не работаете на полях.");
    if(farm_ready[playerid] == 0) return SendClientMessage(playerid, 0xFFA500FF, "Нет выросших арбузов.");

    farm_melons[playerid] += farm_ready[playerid];
    new str[96];
    format(str, sizeof(str), "Собрано %d арбузов. Всего: %d.", farm_ready[playerid], farm_melons[playerid]);
    SendClientMessage(playerid, 0x00FF00FF, str);
    farm_ready[playerid] = 0;
    return 1;
}

CMD:sellarbuz(playerid, params[])
{
    #pragma unused params

    if(!farm_job[playerid]) return SendClientMessage(playerid, 0xFF0000FF, "Вы не работаете на полях.");
    if(farm_melons[playerid] == 0) return SendClientMessage(playerid, 0xFF0000FF, "У вас нет арбузов.");

    new money = farm_melons[playerid] * SELL_PRICE;
    GivePlayerMoney(playerid, money);

    new str[96];
    format(str, sizeof(str), "Продано %d арбузов за %d руб.", farm_melons[playerid], money);
    SendClientMessage(playerid, 0x00FF00FF, str);
    farm_melons[playerid] = 0;
    return 1;
}

public Farm_GrowComplete(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    farm_growing[playerid] = 0;
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);

    if(!farm_job[playerid]) return 1;

    farm_ready[playerid] = HARVEST_AMOUNT;
    SendClientMessage(playerid, 0x00FF00FF, "5 арбузов выросли! Соберите их командой /arbuzka.");
    return 1;
}
