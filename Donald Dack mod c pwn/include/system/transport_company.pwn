#if defined _transport_company_included
    #endinput
#endif
#define _transport_company_included

#include "../include/Pawn.CMD.inc"
#include "../include/streamer.inc"
#include "../include/sscanf2.inc"

#define tc_msg "{FFAE00}[ТК] {FFFFFF}"
#define TC_PRICE 5000000
#define TC_MAX_WORKERS 7
#define TC_MIN_LEVEL 10
#define TC_COMMISSION 20
#define TC_UPDATE_INTERVAL 180000
#define BUS_MODEL_ID 414
#define BUS_SKIN_ID 170
#define MAX_BUS_CAPACITY 20
#define BUS_UNLOAD_TIME 10

enum {
    DIALOG_TC_MAIN = 29100,
    DIALOG_TC_BUY,
    DIALOG_TC_MENU,
    DIALOG_TC_WITHDRAW,
    DIALOG_TC_SELL,
    DIALOG_TC_JOB,
    DIALOG_TC_ORDERS,
    DIALOG_TC_ORDER_CONFIRM,
    DIALOG_TC_INFO
}

enum E_TC_BIZ {
    tcOwnerID,
    tcOwnerName[MAX_PLAYER_NAME],
    tcBalance,
    tcWorkers,
    tcWorkerID[TC_MAX_WORKERS]
}

enum E_PLAYER_TC {
    bool:tcActive,
    tcOrder,
    tcProgress,
    tcTruck,
    tcTrailer,
    tcLevel,
    tcExp,
    tcCompany,
    tcTimer,
    tcTimerCount,
    bool:tcInVehicle,
    bool:tcKicked,
    tcOldSkin,
    Text3D:tcLabel,
    PlayerText:tcGUI[8]
}

new TCBiz[2][E_TC_BIZ];
new PlayerTC[MAX_PLAYERS][E_PLAYER_TC];

new Actor:TCNpc[2];
new Text3D:TCLabel[2];
new TCPickup[2];

static const Float:TCCoords[2][3] = {
    {2327.63, 2009.63, 16.62},
    {-426.06, -1687.60, 41.52}
};

static const Float:TCNpcPos[2][4] = {
    {2332.63, 2008.63, 16.62, 180.0},
    {-430.06, -1688.60, 41.52, 90.0}
};

static const Float:TCSpawn[2][4] = {
    {2313.00, 1992.95, 15.66, 2.06},
    {-406.06, -1689.13, 40.60, 149.76}
};

static const TCNames[2][] = {"Батырево", "Бусаево"};

new const gBusRoutes[6][2] = {
    {0, 1}, {1, 0}, {0, 0}, {1, 1}, {0, 1}, {1, 0}
};

forward TC_UnloadTimer(playerid);
forward TC_UpdateGUI(playerid);

stock TC_UpdateLabel(tkid)
{
    if(TCLabel[tkid] != Text3D:INVALID_3DTEXT_ID)
        Delete3DTextLabel(TCLabel[tkid]);

    new str[256];
    if(TCBiz[tkid][tcOwnerID] != 0)
    {
        format(str, sizeof(str), "{FFCC00}[ ТК %s ]\n{FFFFFF}Владелец: {33DD33}%s\n{FFFFFF}/tcompany - меню\n{FFCC00}/jobtk - устроиться",
            TCNames[tkid], TCBiz[tkid][tcOwnerName]);
    }
    else
    {
        format(str, sizeof(str), "{FFCC00}[ ТК %s ]\n{33DD33}Бизнес свободен!\n{FFFFFF}/buytk - купить за %s",
            TCNames[tkid], FormatMoney(TC_PRICE));
    }

    TCLabel[tkid] = Create3DTextLabel(str, 0xFFFFFFFF, TCNpcPos[tkid][0], TCNpcPos[tkid][1], TCNpcPos[tkid][2] + 1.2, 20.0, 0, 0);
    return 1;
}

stock FormatMoney(amount)
{
    new str[32];
    if(amount >= 1000000) format(str, sizeof(str), "%d.%03d.%03d руб.", amount/1000000, (amount/1000)%1000, amount%1000);
    else if(amount >= 1000) format(str, sizeof(str), "%d.%03d руб.", amount/1000, amount%1000);
    else format(str, sizeof(str), "%d руб.", amount);
    return str;
}

stock TC_CreatePlayerGUI(playerid)
{
    PlayerTC[playerid][tcGUI][0] = CreatePlayerTextDraw(playerid, 498.0, 128.0, "_");
    PlayerTextDrawUseBox(playerid, PlayerTC[playerid][tcGUI][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTC[playerid][tcGUI][0], 0x000000DD);
    PlayerTextDrawTextSize(playerid, PlayerTC[playerid][tcGUI][0], 142.0, 155.0);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][0], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][0], 1.0, 18.0);

    PlayerTC[playerid][tcGUI][1] = CreatePlayerTextDraw(playerid, 569.0, 130.0, "ТРАНСПОРТНАЯ КОМПАНИЯ");
    PlayerTextDrawAlignment(playerid, PlayerTC[playerid][tcGUI][1], 2);
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][1], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][1], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][1], 0.22, 1.4);
    PlayerTextDrawSetOutline(playerid, PlayerTC[playerid][tcGUI][1], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTC[playerid][tcGUI][1], 1);

    PlayerTC[playerid][tcGUI][2] = CreatePlayerTextDraw(playerid, 569.0, 150.0, "____________________");
    PlayerTextDrawAlignment(playerid, PlayerTC[playerid][tcGUI][2], 2);
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][2], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][2], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][2], 0.15, 1.0);

    PlayerTC[playerid][tcGUI][3] = CreatePlayerTextDraw(playerid, 569.0, 162.0, "Стоимость: 0 руб.");
    PlayerTextDrawAlignment(playerid, PlayerTC[playerid][tcGUI][3], 2);
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][3], 0x33DD33FF);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][3], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][3], 0.18, 1.2);
    PlayerTextDrawSetOutline(playerid, PlayerTC[playerid][tcGUI][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTC[playerid][tcGUI][3], 1);

    PlayerTC[playerid][tcGUI][4] = CreatePlayerTextDraw(playerid, 569.0, 178.0, "Маршрут: - -> -");
    PlayerTextDrawAlignment(playerid, PlayerTC[playerid][tcGUI][4], 2);
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][4], 0xFF8800FF);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][4], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][4], 0.15, 1.1);

    PlayerTC[playerid][tcGUI][5] = CreatePlayerTextDraw(playerid, 569.0, 210.0, "____________________");
    PlayerTextDrawAlignment(playerid, PlayerTC[playerid][tcGUI][5], 2);
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][5], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][5], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][5], 0.15, 1.0);

    PlayerTC[playerid][tcGUI][6] = CreatePlayerTextDraw(playerid, 510.0, 222.0, "ld_beat:chit");
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][6], 4);
    PlayerTextDrawTextSize(playerid, PlayerTC[playerid][tcGUI][6], 16.0, 16.0);
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][6], 0x33DD33FF);

    PlayerTC[playerid][tcGUI][7] = CreatePlayerTextDraw(playerid, 532.0, 222.0, "На маршруте");
    PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][7], 0x33DD33FF);
    PlayerTextDrawFont(playerid, PlayerTC[playerid][tcGUI][7], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTC[playerid][tcGUI][7], 0.18, 1.2);
    PlayerTextDrawSetOutline(playerid, PlayerTC[playerid][tcGUI][7], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTC[playerid][tcGUI][7], 1);

    return 1;
}

stock TC_ShowPlayerGUI(playerid)
{
    for(new i = 0; i < 8; i++)
        PlayerTextDrawShow(playerid, PlayerTC[playerid][tcGUI][i]);
    return 1;
}

stock TC_HidePlayerGUI(playerid)
{
    for(new i = 0; i < 8; i++)
        PlayerTextDrawHide(playerid, PlayerTC[playerid][tcGUI][i]);
    return 1;
}

public TC_UpdateGUI(playerid)
{
    if(!PlayerTC[playerid][tcActive]) return 0;

    new str[64];

    if(PlayerTC[playerid][tcTimer] != -1)
    {
        format(str, sizeof(str), "Вернитесь: %dс", PlayerTC[playerid][tcTimerCount]);
        PlayerTextDrawSetString(playerid, PlayerTC[playerid][tcGUI][7], str);
        PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][7], 0xFF4444FF);
        PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][6], 0xFF4444FF);
    }
    else
    {
        PlayerTextDrawSetString(playerid, PlayerTC[playerid][tcGUI][7], "На маршруте");
        PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][7], 0x33DD33FF);
        PlayerTextDrawColor(playerid, PlayerTC[playerid][tcGUI][6], 0x33DD33FF);
    }

    return 1;
}

stock TC_SpawnVehicle(playerid)
{
    if(PlayerTC[playerid][tcTruck] != -1) DestroyVehicle(PlayerTC[playerid][tcTruck]);

    new tkid = PlayerTC[playerid][tcCompany] - 1;
    new vehid = CreateVehicle(BUS_MODEL_ID, TCSpawn[tkid][0], TCSpawn[tkid][1], TCSpawn[tkid][2], TCSpawn[tkid][3], 3, 1, -1);
    PlayerTC[playerid][tcTruck] = vehid;
    PutPlayerInVehicle(playerid, vehid, 0);
    PlayerTC[playerid][tcInVehicle] = true;
    PlayerTC[playerid][tcKicked] = false;

    TC_ShowPlayerGUI(playerid);
    TC_UpdateGUI(playerid);
    return vehid;
}

stock TC_ResetPlayer(playerid)
{
    TC_HidePlayerGUI(playerid);

    if(PlayerTC[playerid][tcTimer] != -1)
    {
        KillTimer(PlayerTC[playerid][tcTimer]);
        PlayerTC[playerid][tcTimer] = -1;
    }
    if(PlayerTC[playerid][tcTruck] != -1)
    {
        DestroyVehicle(PlayerTC[playerid][tcTruck]);
        PlayerTC[playerid][tcTruck] = -1;
    }
    if(PlayerTC[playerid][tcTrailer] != -1)
    {
        DestroyVehicle(PlayerTC[playerid][tcTrailer]);
        PlayerTC[playerid][tcTrailer] = -1;
    }
    if(PlayerTC[playerid][tcActive])
    {
        SetPlayerSkin(playerid, PlayerTC[playerid][tcOldSkin]);
    }

    PlayerTC[playerid][tcActive] = false;
    PlayerTC[playerid][tcOrder] = -1;
    PlayerTC[playerid][tcProgress] = 0;
    PlayerTC[playerid][tcTimerCount] = 0;
    PlayerTC[playerid][tcInVehicle] = false;
    PlayerTC[playerid][tcKicked] = false;
    return 1;
}

public TC_UnloadTimer(playerid)
{
    if(PlayerTC[playerid][tcInVehicle])
    {
        KillTimer(PlayerTC[playerid][tcTimer]);
        PlayerTC[playerid][tcTimer] = -1;
        PlayerTC[playerid][tcTimerCount] = 0;
        TC_UpdateGUI(playerid);
        return 1;
    }

    PlayerTC[playerid][tcTimerCount]--;
    TC_UpdateGUI(playerid);

    if(PlayerTC[playerid][tcTimerCount] <= 0)
    {
        KillTimer(PlayerTC[playerid][tcTimer]);
        PlayerTC[playerid][tcTimer] = -1;
        TC_ResetPlayer(playerid);
        SendClientMessage(playerid, 0xFF4444FF, "Вы не вернулись в транспорт. Заказ отменён.");
    }

    return 1;
}

CMD:buytk(playerid)
{
    new tkid = -1;
    for(new i = 0; i < 2; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, TCNpcPos[i][0], TCNpcPos[i][1], TCNpcPos[i][2]))
        {
            tkid = i;
            break;
        }
    }

    if(tkid == -1) return SendClientMessage(playerid, 0xFF4444FF, "Подойдите к NPC ТК!");
    if(TCBiz[tkid][tcOwnerID] != 0) return SendClientMessage(playerid, 0xFF4444FF, "Эта ТК уже куплена!");
    if(GetPlayerMoney(playerid) < TC_PRICE) return SendClientMessage(playerid, 0xFF4444FF, "Недостаточно денег!");

    new str[256];
    format(str, sizeof(str), "{FFCC00}[ ТК %s ]\n\n{FFFFFF}Купить за {33DD33}%s{FFFFFF}?\nКомиссия с заказов: {FF8800}%d%%", TCNames[tkid], FormatMoney(TC_PRICE), TC_COMMISSION);
    SetPVarInt(playerid, "tc_buy_id", tkid);
    ShowPlayerDialog(playerid, DIALOG_TC_BUY, DIALOG_STYLE_MSGBOX, "{FFCC00}Покупка ТК", str, "Купить", "Отмена");
    return 1;
}

CMD:tcompany(playerid)
{
    new tkid = -1;
    for(new i = 0; i < 2; i++)
    {
        if(TCBiz[i][tcOwnerID] == PlayerTC[playerid][tcCompany])
        {
            tkid = i;
            break;
        }
    }

    if(tkid == -1) return SendClientMessage(playerid, 0xFF4444FF, "Вы не владелец ТК!");

    new str[512];
    format(str, sizeof(str),
        "{FFCC00}[ ТК %s ]\n\n{FFFFFF}Баланс: {33DD33}%s\n{FFFFFF}Сотрудников: {FF8800}%d/%d\n\n{FFFFFF}Снять прибыль\n{FFFFFF}Продать ТК",
        TCNames[tkid], FormatMoney(TCBiz[tkid][tcBalance]), TCBiz[tkid][tcWorkers], TC_MAX_WORKERS);

    SetPVarInt(playerid, "tc_menu_id", tkid);
    ShowPlayerDialog(playerid, DIALOG_TC_MENU, DIALOG_STYLE_LIST, "{FFCC00}Меню владельца", str, "Выбрать", "Закрыть");
    return 1;
}

CMD:jobtk(playerid)
{
    new tkid = -1;
    for(new i = 0; i < 2; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, TCNpcPos[i][0], TCNpcPos[i][1], TCNpcPos[i][2]))
        {
            tkid = i;
            break;
        }
    }

    if(tkid == -1) return SendClientMessage(playerid, 0xFF4444FF, "Подойдите к NPC ТК!");
    if(TCBiz[tkid][tcOwnerID] == 0) return SendClientMessage(playerid, 0xFF4444FF, "ТК не куплена!");
    if(PlayerTC[playerid][tcCompany] != 0) return SendClientMessage(playerid, 0xFF4444FF, "Вы уже работаете в ТК!");
    if(GetPlayerScore(playerid) < TC_MIN_LEVEL) return SendClientMessage(playerid, 0xFF4444FF, "Нужен 10+ уровень!");
    if(TCBiz[tkid][tcWorkers] >= TC_MAX_WORKERS) return SendClientMessage(playerid, 0xFF4444FF, "Нет свободных мест!");

    new str[256];
    format(str, sizeof(str), "{FFCC00}[ ТК %s ]\n\n{FFFFFF}Владелец: {33DD33}%s\n{FFFFFF}Мест: {FF8800}%d/%d\n\n{FFFFFF}Устроиться на работу?",
        TCNames[tkid], TCBiz[tkid][tcOwnerName], TC_MAX_WORKERS - TCBiz[tkid][tcWorkers], TC_MAX_WORKERS);

    SetPVarInt(playerid, "tc_job_id", tkid);
    ShowPlayerDialog(playerid, DIALOG_TC_JOB, DIALOG_STYLE_MSGBOX, "{FFCC00}Устройство в ТК", str, "Устроиться", "Отмена");
    return 1;
}

CMD:tcstats(playerid)
{
    new str[512];
    format(str, sizeof(str),
        "{FFCC00}========== Дальнобойщик ==========\n{FFFFFF}Уровень: {FF8800}%d\n{FFFFFF}Опыт: {FF8800}%d/100\n{FFFFFF}Бонус: {FF8800}%d%%\n{FFCC00}==========================================",
        PlayerTC[playerid][tcLevel], PlayerTC[playerid][tcExp],
        PlayerTC[playerid][tcLevel] > 10 ? (PlayerTC[playerid][tcLevel] - 10) * 5 : 0);
    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "{FFCC00}Статистика", str, "Закрыть", "");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TC_BUY)
    {
        if(!response) { DeletePVar(playerid, "tc_buy_id"); return 1; }
        new tkid = GetPVarInt(playerid, "tc_buy_id");
        DeletePVar(playerid, "tc_buy_id");

        if(TCBiz[tkid][tcOwnerID] != 0) return SendClientMessage(playerid, 0xFF4444FF, "ТК уже куплена!");
        if(GetPlayerMoney(playerid) < TC_PRICE) return SendClientMessage(playerid, 0xFF4444FF, "Недостаточно денег!");

        GivePlayerMoney(playerid, -TC_PRICE);
        TCBiz[tkid][tcOwnerID] = 1;
        GetPlayerName(playerid, TCBiz[tkid][tcOwnerName], MAX_PLAYER_NAME);
        PlayerTC[playerid][tcCompany] = tkid + 1;
        TC_UpdateLabel(tkid);

        SendClientMessage(playerid, 0x33DD33FF, "Вы купили ТК! /tcompany - меню, /jobtk - наём");
        return 1;
    }

    if(dialogid == DIALOG_TC_MENU)
    {
        if(!response) { DeletePVar(playerid, "tc_menu_id"); return 1; }
        new tkid = GetPVarInt(playerid, "tc_menu_id");

        if(listitem == 0)
        {
            new str[128];
            format(str, sizeof(str), "{FFCC00}[ ТК %s ]\n{FFFFFF}Баланс: {33DD33}%s\n\n{FFFFFF}Введите сумму:", TCNames[tkid], FormatMoney(TCBiz[tkid][tcBalance]));
            ShowPlayerDialog(playerid, DIALOG_TC_WITHDRAW, DIALOG_STYLE_INPUT, "{FFCC00}Снять прибыль", str, "Снять", "Назад");
        }
        if(listitem == 1)
        {
            new str[256];
            format(str, sizeof(str), "{FFCC00}[ ТК %s ]\n\n{FFFFFF}Продать за {33DD33}%s{FFFFFF}?", TCNames[tkid], FormatMoney(TC_PRICE / 2));
            ShowPlayerDialog(playerid, DIALOG_TC_SELL, DIALOG_STYLE_MSGBOX, "{FFCC00}Продажа ТК", str, "Продать", "Отмена");
        }
        return 1;
    }

    if(dialogid == DIALOG_TC_WITHDRAW)
    {
        if(!response) return 1;
        new tkid = GetPVarInt(playerid, "tc_menu_id");
        new amount = strval(inputtext);

        if(amount < 1 || amount > TCBiz[tkid][tcBalance])
        {
            SendClientMessage(playerid, 0xFF4444FF, "Неверная сумма!");
            return 1;
        }

        TCBiz[tkid][tcBalance] -= amount;
        GivePlayerMoney(playerid, amount);
        SendClientMessage(playerid, 0x33DD33FF, "Деньги сняты!");
        return 1;
    }

    if(dialogid == DIALOG_TC_SELL)
    {
        if(!response) return 1;
        new tkid = GetPVarInt(playerid, "tc_menu_id");
        DeletePVar(playerid, "tc_menu_id");

        GivePlayerMoney(playerid, TC_PRICE / 2 + TCBiz[tkid][tcBalance]);

        for(new i = 0; i < TC_MAX_WORKERS; i++)
        {
            if(TCBiz[tkid][tcWorkerID][i] != 0)
            {
                foreach(new p : Player)
                {
                    if(PlayerTC[p][tcCompany] == tkid + 1)
                        PlayerTC[p][tcCompany] = 0;
                }
            }
        }

        TCBiz[tkid][tcOwnerID] = 0;
        TCBiz[tkid][tcBalance] = 0;
        TCBiz[tkid][tcWorkers] = 0;
        PlayerTC[playerid][tcCompany] = 0;
        TC_UpdateLabel(tkid);

        SendClientMessage(playerid, 0x33DD33FF, "ТК продана!");
        return 1;
    }

    if(dialogid == DIALOG_TC_JOB)
    {
        if(!response) { DeletePVar(playerid, "tc_job_id"); return 1; }
        new tkid = GetPVarInt(playerid, "tc_job_id");
        DeletePVar(playerid, "tc_job_id");

        if(PlayerTC[playerid][tcCompany] != 0) return SendClientMessage(playerid, 0xFF4444FF, "Вы уже работаете!");
        if(TCBiz[tkid][tcWorkers] >= TC_MAX_WORKERS) return SendClientMessage(playerid, 0xFF4444FF, "Нет мест!");

        TCBiz[tkid][tcWorkerID][TCBiz[tkid][tcWorkers]] = playerid;
        TCBiz[tkid][tcWorkers]++;
        PlayerTC[playerid][tcCompany] = tkid + 1;
        PlayerTC[playerid][tcLevel] = 1;
        PlayerTC[playerid][tcExp] = 0;

        SendClientMessage(playerid, 0x33DD33FF, "Вы устроились в ТК! /tcstats - статистика");
        return 1;
    }

    #if defined tc_dialog_OnDialogResponse
        return tc_dialog_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse tc_dialog_OnDialogResponse
#if defined tc_dialog_OnDialogResponse
    forward tc_dialog_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnGameModeInit()
{
    for(new i = 0; i < 2; i++)
    {
        TCNpc[i] = CreateActor(18, TCNpcPos[i][0], TCNpcPos[i][1], TCNpcPos[i][2], TCNpcPos[i][3]);
        TCBiz[i][tcOwnerID] = 0;
        TCBiz[i][tcBalance] = 0;
        TCBiz[i][tcWorkers] = 0;
        TC_UpdateLabel(i);

        TCPickup[i] = CreatePickup(1239, 1, TCNpcPos[i][0], TCNpcPos[i][1], TCNpcPos[i][2], 0);
    }

    #if defined tc_init_OnGameModeInit
        return tc_init_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit tc_init_OnGameModeInit
#if defined tc_init_OnGameModeInit
    forward tc_init_OnGameModeInit();
#endif

public OnGameModeExit()
{
    for(new i = 0; i < 2; i++)
    {
        if(TCNpc[i] != -1) DestroyActor(TCNpc[i]);
        if(TCLabel[i] != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(TCLabel[i]);
    }

    #if defined tc_exit_OnGameModeExit
        return tc_exit_OnGameModeExit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit tc_exit_OnGameModeExit
#if defined tc_exit_OnGameModeExit
    forward tc_exit_OnGameModeExit();
#endif

public OnPlayerConnect(playerid)
{
    PlayerTC[playerid][tcLevel] = 1;
    PlayerTC[playerid][tcExp] = 0;
    PlayerTC[playerid][tcCompany] = 0;
    PlayerTC[playerid][tcActive] = false;
    PlayerTC[playerid][tcTruck] = -1;
    PlayerTC[playerid][tcTrailer] = -1;
    PlayerTC[playerid][tcTimer] = -1;
    TC_CreatePlayerGUI(playerid);

    #if defined tc_connect_OnPlayerConnect
        return tc_connect_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect tc_connect_OnPlayerConnect
#if defined tc_connect_OnPlayerConnect
    forward tc_connect_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerTC[playerid][tcCompany] > 0)
    {
        new tkid = PlayerTC[playerid][tcCompany] - 1;
        for(new i = 0; i < TC_MAX_WORKERS; i++)
        {
            if(TCBiz[tkid][tcWorkerID][i] == playerid)
            {
                TCBiz[tkid][tcWorkerID][i] = 0;
                TCBiz[tkid][tcWorkers]--;
                break;
            }
        }
    }

    TC_ResetPlayer(playerid);

    #if defined tc_disconnect_OnPlayerDisconnect
        return tc_disconnect_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect tc_disconnect_OnPlayerDisconnect
#if defined tc_disconnect_OnPlayerDisconnect
    forward tc_disconnect_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(PlayerTC[playerid][tcActive] && oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
    {
        PlayerTC[playerid][tcInVehicle] = false;
        PlayerTC[playerid][tcTimerCount] = BUS_UNLOAD_TIME;

        KillTimer(PlayerTC[playerid][tcTimer]);
        PlayerTC[playerid][tcTimer] = SetTimerEx("TC_UnloadTimer", 1000, true, "d", playerid);
        TC_UpdateGUI(playerid);
    }

    if(PlayerTC[playerid][tcActive] && newstate == PLAYER_STATE_DRIVER)
    {
        PlayerTC[playerid][tcInVehicle] = true;
        PlayerTC[playerid][tcKicked] = false;

        if(PlayerTC[playerid][tcTimer] != -1)
        {
            KillTimer(PlayerTC[playerid][tcTimer]);
            PlayerTC[playerid][tcTimer] = -1;
            PlayerTC[playerid][tcTimerCount] = 0;
            TC_UpdateGUI(playerid);
            SendClientMessage(playerid, 0x33DD33FF, "Вы вернулись в транспорт. Работа продолжается.");
        }
    }

    #if defined tc_state_OnPlayerStateChange
        return tc_state_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange tc_state_OnPlayerStateChange
#if defined tc_state_OnPlayerStateChange
    forward tc_state_OnPlayerStateChange(playerid, newstate, oldstate);
#endif