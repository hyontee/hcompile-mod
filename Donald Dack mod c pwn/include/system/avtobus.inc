#if defined _avtobus_included
    #endinput
#endif
#define _avtobus_included

#include <a_samp>

#define avtobus_db_handle mysql

#if !defined avtobus_db_handle
    new MySQL:avtobus_db_handle;
#endif

const BUS_MODEL_ID = 414;
const BUS_SKIN_ID = 170;
const MAX_BUS_CAPACITY = 20;
const BUS_UNLOAD_TIME = 10;
const BUS_POINT_LYTKARINO = 0;
const BUS_POINT_YUZHNY = 1;

enum {
    DIALOG_BUS_MAIN = 19100,
    DIALOG_BUS_INFO,
    DIALOG_BUS_PRICE,
    DIALOG_BUS_CONFIRM
}

static Float:BusNPC_Lytkarino[4] = {-2614.0, -92.0, 29.0, 90.0};
static Float:BusNPC_Yuzhny[4] = {2644.0, -2445.0, 22.0, 270.0};
static Float:BusSpawn_Lytkarino[4] = {-2614.0, -102.0, 29.0, 180.0};
static Float:BusSpawn_Yuzhny[4] = {2647.0, -2450.0, 22.0, 90.0};

enum pBusInfo {
    pBusDriver,
    pBusPrice,
    pBusVehicle,
    pBusPoint,
    pBusTimer,
    pBusTimerCount,
    bool:pBusInVehicle,
    bool:pBusKicked,
    pBusOldSkin,
    PlayerText:pBusGUI[6]
}
static BusInfo[MAX_PLAYERS][pBusInfo];

static BusNPC_Lyt, BusNPC_Yuz;
static Text3D:BusLabel_Lyt = Text3D:INVALID_3DTEXT_ID;
static Text3D:BusLabel_Yuz = Text3D:INVALID_3DTEXT_ID;

forward BusUnloadTimer(playerid);
forward OnBusDataLoad(playerid);

stock Bus_CreateGUI(playerid)
{
    BusInfo[playerid][pBusGUI][0] = CreatePlayerTextDraw(playerid, 500.0, 350.0, "АВТОБУСНИК");
    PlayerTextDrawAlignment(playerid, BusInfo[playerid][pBusGUI][0], 2);
    PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][0], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, BusInfo[playerid][pBusGUI][0], 2);
    PlayerTextDrawLetterSize(playerid, BusInfo[playerid][pBusGUI][0], 0.30, 1.60);
    PlayerTextDrawSetOutline(playerid, BusInfo[playerid][pBusGUI][0], 1);

    BusInfo[playerid][pBusGUI][1] = CreatePlayerTextDraw(playerid, 500.0, 370.0, "Цена: 0 руб.");
    PlayerTextDrawAlignment(playerid, BusInfo[playerid][pBusGUI][1], 2);
    PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][1], 0x33DD33FF);
    PlayerTextDrawFont(playerid, BusInfo[playerid][pBusGUI][1], 2);
    PlayerTextDrawLetterSize(playerid, BusInfo[playerid][pBusGUI][1], 0.20, 1.20);
    PlayerTextDrawSetOutline(playerid, BusInfo[playerid][pBusGUI][1], 1);

    BusInfo[playerid][pBusGUI][2] = CreatePlayerTextDraw(playerid, 500.0, 390.0, "Пассажиров: 0/20");
    PlayerTextDrawAlignment(playerid, BusInfo[playerid][pBusGUI][2], 2);
    PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][2], 0x00AADDFF);
    PlayerTextDrawFont(playerid, BusInfo[playerid][pBusGUI][2], 2);
    PlayerTextDrawLetterSize(playerid, BusInfo[playerid][pBusGUI][2], 0.20, 1.20);
    PlayerTextDrawSetOutline(playerid, BusInfo[playerid][pBusGUI][2], 1);

    BusInfo[playerid][pBusGUI][3] = CreatePlayerTextDraw(playerid, 500.0, 410.0, "Статус: На маршруте");
    PlayerTextDrawAlignment(playerid, BusInfo[playerid][pBusGUI][3], 2);
    PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][3], 0x33DD33FF);
    PlayerTextDrawFont(playerid, BusInfo[playerid][pBusGUI][3], 2);
    PlayerTextDrawLetterSize(playerid, BusInfo[playerid][pBusGUI][3], 0.18, 1.10);
    PlayerTextDrawSetOutline(playerid, BusInfo[playerid][pBusGUI][3], 1);

    BusInfo[playerid][pBusGUI][4] = CreatePlayerTextDraw(playerid, 500.0, 430.0, "/ab текст - объявление");
    PlayerTextDrawAlignment(playerid, BusInfo[playerid][pBusGUI][4], 2);
    PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][4], 0x888888FF);
    PlayerTextDrawFont(playerid, BusInfo[playerid][pBusGUI][4], 1);
    PlayerTextDrawLetterSize(playerid, BusInfo[playerid][pBusGUI][4], 0.15, 1.00);

    BusInfo[playerid][pBusGUI][5] = CreatePlayerTextDraw(playerid, 500.0, 445.0, "/avtobus - меню");
    PlayerTextDrawAlignment(playerid, BusInfo[playerid][pBusGUI][5], 2);
    PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][5], 0x888888FF);
    PlayerTextDrawFont(playerid, BusInfo[playerid][pBusGUI][5], 1);
    PlayerTextDrawLetterSize(playerid, BusInfo[playerid][pBusGUI][5], 0.15, 1.00);

    return 1;
}

stock Bus_ShowGUI(playerid)
{
    for(new i = 0; i < 6; i++)
        PlayerTextDrawShow(playerid, BusInfo[playerid][pBusGUI][i]);
    return 1;
}

stock Bus_HideGUI(playerid)
{
    for(new i = 0; i < 6; i++)
        PlayerTextDrawHide(playerid, BusInfo[playerid][pBusGUI][i]);
    return 1;
}

stock Bus_UpdateGUI(playerid)
{
    if(!BusInfo[playerid][pBusDriver]) return 0;

    new str[64];
    new vehid = BusInfo[playerid][pBusVehicle];

    format(str, sizeof(str), "Цена: %d руб.", BusInfo[playerid][pBusPrice]);
    PlayerTextDrawSetString(playerid, BusInfo[playerid][pBusGUI][1], str);

    new count = 0;
    if(vehid != -1)
    {
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehid && GetPlayerState(i) == PLAYER_STATE_PASSENGER)
                count++;
        }
    }
    format(str, sizeof(str), "Пассажиров: %d/%d", count, MAX_BUS_CAPACITY);
    PlayerTextDrawSetString(playerid, BusInfo[playerid][pBusGUI][2], str);

    if(BusInfo[playerid][pBusTimer] != -1)
    {
        format(str, sizeof(str), "Статус: Вернитесь! %dс", BusInfo[playerid][pBusTimerCount]);
        PlayerTextDrawSetString(playerid, BusInfo[playerid][pBusGUI][3], str);
        PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][3], 0xFF4444FF);
    }
    else
    {
        PlayerTextDrawSetString(playerid, BusInfo[playerid][pBusGUI][3], "Статус: На маршруте");
        PlayerTextDrawColor(playerid, BusInfo[playerid][pBusGUI][3], 0x33DD33FF);
    }

    return 1;
}

stock SaveBusData(playerid)
{
    new pName[MAX_PLAYER_NAME], query[200];
    GetPlayerName(playerid, pName, sizeof(pName));
    mysql_format(avtobus_db_handle, query, sizeof(query),
        "INSERT INTO `bus_drivers` (`name`, `price`, `point`) VALUES ('%e', %d, %d) \
         ON DUPLICATE KEY UPDATE `price` = VALUES(`price`), `point` = VALUES(`point`)",
        pName, BusInfo[playerid][pBusPrice], BusInfo[playerid][pBusPoint]);
    mysql_tquery(avtobus_db_handle, query);
}

stock ResetBusData(playerid)
{
    Bus_HideGUI(playerid);
    DestroyBusVehicle(playerid);
    if(BusInfo[playerid][pBusDriver] == 1)
    {
        SetPlayerSkin(playerid, BusInfo[playerid][pBusOldSkin]);
    }
    if(BusInfo[playerid][pBusTimer] != -1)
    {
        KillTimer(BusInfo[playerid][pBusTimer]);
        BusInfo[playerid][pBusTimer] = -1;
    }
    BusInfo[playerid][pBusDriver] = 0;
    BusInfo[playerid][pBusPrice] = 0;
    BusInfo[playerid][pBusVehicle] = -1;
    BusInfo[playerid][pBusPoint] = -1;
    BusInfo[playerid][pBusTimerCount] = 0;
    BusInfo[playerid][pBusInVehicle] = false;
    BusInfo[playerid][pBusKicked] = false;
}

stock DestroyBusVehicle(playerid)
{
    new vehid = BusInfo[playerid][pBusVehicle];
    if(vehid != -1)
    {
        DestroyVehicle(vehid);
        BusInfo[playerid][pBusVehicle] = -1;
    }
}

stock SpawnBusForPlayer(playerid)
{
    DestroyBusVehicle(playerid);

    new Float:x, Float:y, Float:z, Float:angle;
    
    if(BusInfo[playerid][pBusPoint] == BUS_POINT_LYTKARINO)
    {
        x = BusSpawn_Lytkarino[0];
        y = BusSpawn_Lytkarino[1];
        z = BusSpawn_Lytkarino[2];
        angle = BusSpawn_Lytkarino[3];
    }
    else
    {
        x = BusSpawn_Yuzhny[0];
        y = BusSpawn_Yuzhny[1];
        z = BusSpawn_Yuzhny[2];
        angle = BusSpawn_Yuzhny[3];
    }

    new vehid = CreateVehicle(BUS_MODEL_ID, x, y, z, angle, 3, 1, -1);
    BusInfo[playerid][pBusVehicle] = vehid;
    PutPlayerInVehicle(playerid, vehid, 0);
    BusInfo[playerid][pBusInVehicle] = true;
    BusInfo[playerid][pBusKicked] = false;

    Bus_ShowGUI(playerid);
    Bus_UpdateGUI(playerid);
    return vehid;
}

public OnBusDataLoad(playerid)
{
    if(cache_num_rows() > 0)
    {
        BusInfo[playerid][pBusPrice] = cache_get_row_int(0, 0);
        BusInfo[playerid][pBusPoint] = cache_get_row_int(0, 1);
    }
    return 1;
}

public BusUnloadTimer(playerid)
{
    if(BusInfo[playerid][pBusInVehicle])
    {
        KillTimer(BusInfo[playerid][pBusTimer]);
        BusInfo[playerid][pBusTimer] = -1;
        BusInfo[playerid][pBusTimerCount] = 0;
        Bus_UpdateGUI(playerid);
        return 1;
    }

    BusInfo[playerid][pBusTimerCount]--;
    Bus_UpdateGUI(playerid);

    if(BusInfo[playerid][pBusTimerCount] <= 0)
    {
        KillTimer(BusInfo[playerid][pBusTimer]);
        BusInfo[playerid][pBusTimer] = -1;

        DestroyBusVehicle(playerid);
        ResetBusData(playerid);

        SendClientMessage(playerid, 0xFF0000FF, "Автобус выгружен. Вы уволены.");
        GameTextForPlayer(playerid, "~r~Автобус выгружен!", 2000, 3);
    }

    return 1;
}

CMD:avtobus(playerid, params[])
{
    new bool:near_npc = false;
    new point = -1;

    if(IsPlayerInRangeOfPoint(playerid, 5.0, BusNPC_Lytkarino[0], BusNPC_Lytkarino[1], BusNPC_Lytkarino[2]))
    {
        near_npc = true;
        point = BUS_POINT_LYTKARINO;
    }
    if(IsPlayerInRangeOfPoint(playerid, 5.0, BusNPC_Yuzhny[0], BusNPC_Yuzhny[1], BusNPC_Yuzhny[2]))
    {
        near_npc = true;
        point = BUS_POINT_YUZHNY;
    }

    if(!near_npc)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы слишком далеко от Вадима!");
        return 1;
    }

    if(BusInfo[playerid][pBusDriver] == 1)
    {
        ShowPlayerDialog(playerid, DIALOG_BUS_MAIN + 10, DIALOG_STYLE_LIST, "Автобусник", "Продолжить работу\nУволиться", "Выбрать", "Закрыть");
        return 1;
    }

    BusInfo[playerid][pBusPoint] = point;
    ShowPlayerDialog(playerid, DIALOG_BUS_MAIN, DIALOG_STYLE_LIST, "Автобусник", "Устроиться на работу\nИнформация о работе", "Выбрать", "Закрыть");
    return 1;
}

CMD:ab(playerid, params[])
{
    if(BusInfo[playerid][pBusDriver] != 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы не автобусник!");
        return 1;
    }

    if(isnull(params))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Используйте: /ab [текст объявления]");
        return 1;
    }

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);

    new str[256];
    format(str, sizeof(str), "[АВТОБУС] %s: %s (Цена: %dр)", name, params, BusInfo[playerid][pBusPrice]);
    SendClientMessageToAll(0xFFCC00FF, str);
    return 1;
}

public OnGameModeInit()
{
    BusNPC_Lyt = CreateActor(BUS_SKIN_ID, BusNPC_Lytkarino[0], BusNPC_Lytkarino[1], BusNPC_Lytkarino[2], BusNPC_Lytkarino[3]);
    BusNPC_Yuz = CreateActor(BUS_SKIN_ID, BusNPC_Yuzhny[0], BusNPC_Yuzhny[1], BusNPC_Yuzhny[2], BusNPC_Yuzhny[3]);

    BusLabel_Lyt = Create3DTextLabel("{FFCC00}[ Вадим ]\n{FFFFFF}Для информации - /avtobus", 0xFFFFFFFF, BusNPC_Lytkarino[0], BusNPC_Lytkarino[1], BusNPC_Lytkarino[2] + 1.0, 20.0, 0, 0);
    BusLabel_Yuz = Create3DTextLabel("{FFCC00}[ Вадим ]\n{FFFFFF}Для информации - /avtobus", 0xFFFFFFFF, BusNPC_Yuzhny[0], BusNPC_Yuzhny[1], BusNPC_Yuzhny[2] + 1.0, 20.0, 0, 0);

    CreatePickup(1239, 1, BusNPC_Lytkarino[0], BusNPC_Lytkarino[1], BusNPC_Lytkarino[2], 0);
    CreatePickup(1239, 1, BusNPC_Yuzhny[0], BusNPC_Yuzhny[1], BusNPC_Yuzhny[2], 0);

    #if defined Avtobus_OnGameModeInit
        return Avtobus_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Avtobus_OnGameModeInit
#if defined Avtobus_OnGameModeInit
    forward Avtobus_OnGameModeInit();
#endif

public OnGameModeExit()
{
    if(BusNPC_Lyt != -1) DestroyActor(BusNPC_Lyt);
    if(BusNPC_Yuz != -1) DestroyActor(BusNPC_Yuz);

    if(BusLabel_Lyt != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(BusLabel_Lyt);
    if(BusLabel_Yuz != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(BusLabel_Yuz);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SaveBusData(i);
            ResetBusData(i);
        }
    }

    #if defined Avtobus_OnGameModeExit
        return Avtobus_OnGameModeExit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit Avtobus_OnGameModeExit
#if defined Avtobus_OnGameModeExit
    forward Avtobus_OnGameModeExit();
#endif

public OnPlayerConnect(playerid)
{
    BusInfo[playerid][pBusDriver] = 0;
    BusInfo[playerid][pBusPrice] = 0;
    BusInfo[playerid][pBusVehicle] = -1;
    BusInfo[playerid][pBusPoint] = -1;
    BusInfo[playerid][pBusTimer] = -1;
    BusInfo[playerid][pBusTimerCount] = 0;
    BusInfo[playerid][pBusInVehicle] = false;
    BusInfo[playerid][pBusKicked] = false;
    BusInfo[playerid][pBusOldSkin] = 0;

    Bus_CreateGUI(playerid);

    new pName[MAX_PLAYER_NAME], query[150];
    GetPlayerName(playerid, pName, sizeof(pName));
    mysql_format(avtobus_db_handle, query, sizeof(query), "SELECT `price`, `point` FROM `bus_drivers` WHERE `name` = '%e' LIMIT 1", pName);
    mysql_tquery(avtobus_db_handle, query, "OnBusDataLoad", "i", playerid);

    #if defined Avtobus_OnPlayerConnect
        return Avtobus_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Avtobus_OnPlayerConnect
#if defined Avtobus_OnPlayerConnect
    forward Avtobus_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    SaveBusData(playerid);
    ResetBusData(playerid);

    #if defined Avtobus_OnPlayerDisconnect
        return Avtobus_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Avtobus_OnPlayerDisconnect
#if defined Avtobus_OnPlayerDisconnect
    forward Avtobus_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(BusInfo[playerid][pBusDriver] == 1 && oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
    {
        if(BusInfo[playerid][pBusKicked]) return 1;

        BusInfo[playerid][pBusInVehicle] = false;
        BusInfo[playerid][pBusTimerCount] = BUS_UNLOAD_TIME;

        KillTimer(BusInfo[playerid][pBusTimer]);
        BusInfo[playerid][pBusTimer] = SetTimerEx("BusUnloadTimer", 1000, true, "d", playerid);
        Bus_UpdateGUI(playerid);
    }

    if(BusInfo[playerid][pBusDriver] == 1 && newstate == PLAYER_STATE_DRIVER)
    {
        BusInfo[playerid][pBusInVehicle] = true;
        BusInfo[playerid][pBusKicked] = false;

        if(BusInfo[playerid][pBusTimer] != -1)
        {
            KillTimer(BusInfo[playerid][pBusTimer]);
            BusInfo[playerid][pBusTimer] = -1;
            BusInfo[playerid][pBusTimerCount] = 0;
            Bus_UpdateGUI(playerid);
            SendClientMessage(playerid, 0x33AA33FF, "Вы вернулись в автобус. Таймер остановлен.");
        }
    }

    if(newstate == PLAYER_STATE_PASSENGER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(BusInfo[i][pBusDriver] == 1 && BusInfo[i][pBusVehicle] == vehicleid && i != playerid)
            {
                if(GetPlayerMoney(playerid) < BusInfo[i][pBusPrice])
                {
                    new str[128];
                    format(str, sizeof(str), "У вас недостаточно денег! Билет стоит %dр", BusInfo[i][pBusPrice]);
                    SendClientMessage(playerid, 0xFF0000FF, str);
                    RemovePlayerFromVehicle(playerid);
                    return 1;
                }

                GivePlayerMoney(playerid, -BusInfo[i][pBusPrice]);
                GivePlayerMoney(i, BusInfo[i][pBusPrice]);

                new name_driver[MAX_PLAYER_NAME], name_pass[MAX_PLAYER_NAME];
                GetPlayerName(i, name_driver, MAX_PLAYER_NAME);
                GetPlayerName(playerid, name_pass, MAX_PLAYER_NAME);

                new str[256];
                format(str, sizeof(str), "Вы оплатили проезд: %dр. Водитель: %s", BusInfo[i][pBusPrice], name_driver);
                SendClientMessage(playerid, 0x33AA33FF, str);

                format(str, sizeof(str), "Пассажир %s оплатил проезд: +%dр", name_pass, BusInfo[i][pBusPrice]);
                SendClientMessage(i, 0x33AA33FF, str);

                Bus_UpdateGUI(i);
                return 1;
            }
        }
    }

    #if defined Avtobus_OnPlayerStateChange
        return Avtobus_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange Avtobus_OnPlayerStateChange
#if defined Avtobus_OnPlayerStateChange
    forward Avtobus_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BUS_MAIN + 10)
    {
        if(response)
        {
            if(listitem == 0)
            {
                SendClientMessage(playerid, 0xFFFF00FF, "Вы продолжаете работать. Развозите пассажиров!");
                return 1;
            }
            if(listitem == 1)
            {
                SaveBusData(playerid);
                ResetBusData(playerid);
                SendClientMessage(playerid, 0xFF0000FF, "Вы уволились с работы автобусника.");
                return 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_BUS_MAIN)
    {
        if(response)
        {
            if(listitem == 0)
            {
                ShowPlayerDialog(playerid, DIALOG_BUS_PRICE, DIALOG_STYLE_INPUT, "Цена билета", "Введите цену билета (от 1 до 100.000):", "Ввод", "Отмена");
                return 1;
            }
            if(listitem == 1)
            {
                ShowPlayerDialog(playerid, DIALOG_BUS_INFO, DIALOG_STYLE_MSGBOX, "Информация",
                    "{FFFFFF}Автобусник - работа на городском транспорте\n\n\
                    Две точки: Лыткарино и Южный\n\
                    Машина: автобус \n\
                    Цена билета: от 1 до 100.000р\n\n\
                    Выйдя из автобуса, у вас есть 10 секунд чтобы вернуться обратно, иначе автобус выгрузится.\n\n\
                    Команды:\n\
                    /avtobus - меню работы\n\
                    /ab - объявление в чат",
                    "Понятно", "");
                return 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_BUS_PRICE)
    {
        if(!response) return 1;

        new price = strval(inputtext);

        if(price < 1 || price > 100000)
        {
            ShowPlayerDialog(playerid, DIALOG_BUS_PRICE, DIALOG_STYLE_INPUT, "Цена билета", "Цена от 1 до 100.000 рублей!\nВведите цену билета:", "Ввод", "Отмена");
            return 1;
        }

        BusInfo[playerid][pBusDriver] = 1;
        BusInfo[playerid][pBusPrice] = price;
        BusInfo[playerid][pBusOldSkin] = GetPlayerSkin(playerid);
        SetPlayerSkin(playerid, BUS_SKIN_ID);
        SpawnBusForPlayer(playerid);

        SaveBusData(playerid);

        new str[256];
        format(str, sizeof(str), "Вы устроились автобусником! Цена билета: %dр. Возите пассажиров!", price);
        SendClientMessage(playerid, 0x33AA33FF, str);
        SendClientMessage(playerid, 0xFFFF00FF, "Напишите /ab [текст] для объявления в чат");
        return 1;
    }

    #if defined Avtobus_OnDialogResponse
        return Avtobus_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Avtobus_OnDialogResponse
#if defined Avtobus_OnDialogResponse
    forward Avtobus_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif