#if defined _danya_included
    #endinput
#endif
#define _danya_included

#include "../include/Pawn.CMD.inc"
#include "../include/streamer.inc"

#define DANYA_SKIN_ID 18
#define MAX_DANYA_NPC 10
#define DANYA_ANNOUNCE_TIME 600000

enum {
    DIALOG_DANYA = 29200
}

enum pDanyaInfo {
    bool:pDanyaUsed
}
static DanyaInfo[MAX_PLAYERS][pDanyaInfo];

enum E_DANYA_NPC {
    DanyaActor,
    Text3D:DanyaLabel,
    DanyaArea,
    DanyaPrize
}

static DanyaNPC[MAX_DANYA_NPC][E_DANYA_NPC];
static DanyaActiveNPC = -1;

static PlayerText:DanyaSpinTD[MAX_PLAYERS][12];
static DanyaSpinTimer[MAX_PLAYERS] = {-1, ...};
static DanyaSpinPos[MAX_PLAYERS] = {0, ...};
static DanyaWinPrize[MAX_PLAYERS] = {-1, ...};

static const Float:DanyaSpawns[10][3] = {
    {-419.06, -238.28, 38.20},
    {-1011.38, 777.00, 13.94},
    {152.16, -2413.33, 33.18},
    {-563.28, -1630.91, 41.32},
    {846.63, -2576.87, 41.70},
    {-56.38, -1214.29, 17.59},
    {1877.65, -1876.23, 22.77},
    {-2633.21, 2319.77, 12.37},
    {1085.29, -1825.68, 17.49},
    {-1527.55, 2531.36, 62.44}
};

static DanyaPrizeNames[8][32] = {
    "5.000.000 руб.", "VIP на 7 дней", "10.000.000 руб.",
    "Скин администратора", "3.000.000 руб.", "Премиум машина 1",
    "Премиум машина 2", "Премиум машина 3"
};

static DanyaPrizeMoney[8] = {
    5000000, 0, 10000000,
    0, 3000000, 0,
    0, 0
};

static DanyaPrizeCar[8] = {
    -1, -1, -1,
    -1, -1, 2591,
    2590, 2591
};

forward Danya_SpawnRandom();
forward Danya_HideCurrent();
forward Danya_Announce();
forward Danya_SpinUpdate(playerid);
forward Danya_SpinEnd(playerid);

stock Danya_CreateSpinTD(playerid)
{
    DanyaSpinTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.0, 100.0, "ld_dual:white");
    PlayerTextDrawFont(playerid, DanyaSpinTD[playerid][0], 4);
    PlayerTextDrawTextSize(playerid, DanyaSpinTD[playerid][0], 300.0, 250.0);
    PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][0], 0x000000DD);

    DanyaSpinTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.0, 105.0, "РУЛЕТКА ДАНИ BRAIN");
    PlayerTextDrawAlignment(playerid, DanyaSpinTD[playerid][1], 2);
    PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][1], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, DanyaSpinTD[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, DanyaSpinTD[playerid][1], 0.35, 1.80);
    PlayerTextDrawSetOutline(playerid, DanyaSpinTD[playerid][1], 2);

    DanyaSpinTD[playerid][2] = CreatePlayerTextDraw(playerid, 320.0, 130.0, "____________________________");
    PlayerTextDrawAlignment(playerid, DanyaSpinTD[playerid][2], 2);
    PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][2], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, DanyaSpinTD[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, DanyaSpinTD[playerid][2], 0.20, 1.00);

    for(new i = 3; i < 10; i++)
    {
        DanyaSpinTD[playerid][i] = CreatePlayerTextDraw(playerid, 320.0, 145.0 + (i-3)*25.0, " ");
        PlayerTextDrawAlignment(playerid, DanyaSpinTD[playerid][i], 2);
        PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][i], 0x888888FF);
        PlayerTextDrawFont(playerid, DanyaSpinTD[playerid][i], 2);
        PlayerTextDrawLetterSize(playerid, DanyaSpinTD[playerid][i], 0.18, 1.20);
    }

    DanyaSpinTD[playerid][10] = CreatePlayerTextDraw(playerid, 320.0, 310.0, "____________________________");
    PlayerTextDrawAlignment(playerid, DanyaSpinTD[playerid][10], 2);
    PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][10], 0xFFCC00FF);
    PlayerTextDrawFont(playerid, DanyaSpinTD[playerid][10], 1);
    PlayerTextDrawLetterSize(playerid, DanyaSpinTD[playerid][10], 0.15, 1.00);

    DanyaSpinTD[playerid][11] = CreatePlayerTextDraw(playerid, 320.0, 320.0, "Подождите...");
    PlayerTextDrawAlignment(playerid, DanyaSpinTD[playerid][11], 2);
    PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][11], 0xFFFFFFFF);
    PlayerTextDrawFont(playerid, DanyaSpinTD[playerid][11], 2);
    PlayerTextDrawLetterSize(playerid, DanyaSpinTD[playerid][11], 0.18, 1.20);

    return 1;
}

stock Danya_ShowSpinTD(playerid)
{
    for(new i = 0; i < 12; i++)
        PlayerTextDrawShow(playerid, DanyaSpinTD[playerid][i]);
    return 1;
}

stock Danya_HideSpinTD(playerid)
{
    for(new i = 0; i < 12; i++)
        PlayerTextDrawHide(playerid, DanyaSpinTD[playerid][i]);
    return 1;
}

public Danya_SpinUpdate(playerid)
{
    DanyaSpinPos[playerid]++;

    for(new i = 3; i < 10; i++)
        PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][i], 0x888888FF);

    new mid = 3 + (DanyaSpinPos[playerid] % 7);
    PlayerTextDrawColor(playerid, DanyaSpinTD[playerid][mid], 0xFFCC00FF);
    PlayerTextDrawSetString(playerid, DanyaSpinTD[playerid][11], "Крутим...");

    if(DanyaSpinPos[playerid] >= 20 + DanyaWinPrize[playerid])
    {
        KillTimer(DanyaSpinTimer[playerid]);
        DanyaSpinTimer[playerid] = -1;
        Danya_SpinEnd(playerid);
    }

    return 1;
}

public Danya_SpinEnd(playerid)
{
    new prize = DanyaWinPrize[playerid];
    Danya_HideSpinTD(playerid);
    DanyaInfo[playerid][pDanyaUsed] = true;

    new str[256];
    if(DanyaPrizeMoney[prize] > 0)
    {
        GivePlayerMoney(playerid, DanyaPrizeMoney[prize]);
        format(str, sizeof(str), "{FFCC00}[Даня Brain] {FFFFFF}Ты выиграл {33DD33}%s{FFFFFF}!", DanyaPrizeNames[prize]);
        SendClientMessage(playerid, -1, str);
    }
    else if(DanyaPrizeCar[prize] != -1)
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        CreateVehicle(DanyaPrizeCar[prize], x+3.0, y, z, 0.0, -1, -1, -1);
        format(str, sizeof(str), "{FFCC00}[Даня Brain] {FFFFFF}Ты выиграл {33DD33}%s{FFFFFF}! Машина заспавнена рядом.", DanyaPrizeNames[prize]);
        SendClientMessage(playerid, -1, str);
    }
    else if(prize == 3)
    {
        SetPlayerSkin(playerid, 122);
        format(str, sizeof(str), "{FFCC00}[Даня Brain] {FFFFFF}Ты выиграл {33DD33}Скин администратора{FFFFFF}!");
        SendClientMessage(playerid, -1, str);
    }
    else
    {
        format(str, sizeof(str), "{FFCC00}[Даня Brain] {FFFFFF}Ты выиграл {33DD33}%s{FFFFFF}! Обратись к администратору.", DanyaPrizeNames[prize]);
        SendClientMessage(playerid, -1, str);
    }

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(str, sizeof(str), "{FFCC00}[Даня Brain] {FFFFFF}%s выиграл {33DD33}%s{FFFFFF}!", name, DanyaPrizeNames[prize]);
    SendClientMessageToAll(-1, str);

    Danya_HideCurrent();
    return 1;
}

stock Danya_HideCurrent()
{
    if(DanyaActiveNPC >= 0)
    {
        if(DanyaNPC[DanyaActiveNPC][DanyaActor] != -1) DestroyActor(DanyaNPC[DanyaActiveNPC][DanyaActor]);
        if(DanyaNPC[DanyaActiveNPC][DanyaLabel] != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(DanyaNPC[DanyaActiveNPC][DanyaLabel]);
        if(DanyaNPC[DanyaActiveNPC][DanyaArea] != -1) DestroyDynamicArea(DanyaNPC[DanyaActiveNPC][DanyaArea]);
    }
    DanyaActiveNPC = -1;
    return 1;
}

stock Danya_SpawnRandom()
{
    Danya_HideCurrent();

    new r = random(10);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && !DanyaInfo[i][pDanyaUsed])
            PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
    }

    DanyaActiveNPC = r;
    DanyaNPC[r][DanyaActor] = CreateActor(DANYA_SKIN_ID, DanyaSpawns[r][0], DanyaSpawns[r][1], DanyaSpawns[r][2], random(360));
    DanyaNPC[r][DanyaPrize] = random(8);

    new str[256];
    format(str, sizeof(str), "{FFCC00}[ Даня Brain ]\n{FFFFFF}Подойди и испытай удачу!\n{33DD33}Приз: случайный");
    DanyaNPC[r][DanyaLabel] = Create3DTextLabel(str, 0xFFFFFFFF, DanyaSpawns[r][0], DanyaSpawns[r][1], DanyaSpawns[r][2] + 1.2, 20.0, 0, 0);
    DanyaNPC[r][DanyaArea] = CreateDynamicSphere(DanyaSpawns[r][0], DanyaSpawns[r][1], DanyaSpawns[r][2], 3.0, 0, 0);

    format(str, sizeof(str), "{FFCC00}[Даня Brain] {FFFFFF}Я появился на карте! Найди меня и испытай удачу в рулетке!");
    SendClientMessageToAll(-1, str);

    SetTimer("Danya_Announce", DANYA_ANNOUNCE_TIME + random(300000), false);
    return 1;
}

public Danya_Announce()
{
    SendClientMessageToAll(-1, "{FFCC00}[Даня Brain] {FFFFFF}Скоро я появлюсь в случайном месте! Готовьтесь к рулетке!");
    SetTimer("Danya_SpawnRandom", 30000, false);
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(DanyaActiveNPC >= 0 && areaid == DanyaNPC[DanyaActiveNPC][DanyaArea])
    {
        if(DanyaInfo[playerid][pDanyaUsed])
        {
            SendClientMessage(playerid, 0xFF4444FF, "Даня Brain: Ты уже испытал удачу, брат!");
            return 1;
        }
        if(DanyaSpinTimer[playerid] != -1)
        {
            SendClientMessage(playerid, 0xFF4444FF, "Даня Brain: Подожди, рулетка ещё крутится!");
            return 1;
        }

        DanyaWinPrize[playerid] = random(8);
        DanyaSpinPos[playerid] = 0;
        Danya_CreateSpinTD(playerid);
        Danya_ShowSpinTD(playerid);

        for(new i = 3; i < 10; i++)
        {
            new r = random(8);
            PlayerTextDrawSetString(playerid, DanyaSpinTD[playerid][i], DanyaPrizeNames[r]);
        }
        PlayerTextDrawSetString(playerid, DanyaSpinTD[playerid][3 + 2], DanyaPrizeNames[DanyaWinPrize[playerid]]);

        DanyaSpinTimer[playerid] = SetTimerEx("Danya_SpinUpdate", 100, true, "d", playerid);
        return 1;
    }

    #if defined db_OnPlayerEnterDynamicArea
        return db_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea db_OnPlayerEnterDynamicArea
#if defined db_OnPlayerEnterDynamicArea
    forward db_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

public OnGameModeInit()
{
    for(new i = 0; i < MAX_DANYA_NPC; i++)
    {
        DanyaNPC[i][DanyaActor] = -1;
        DanyaNPC[i][DanyaLabel] = Text3D:INVALID_3DTEXT_ID;
        DanyaNPC[i][DanyaArea] = -1;
    }

    SetTimer("Danya_Announce", 30000, false);

    #if defined db_OnGameModeInit
        return db_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit db_OnGameModeInit
#if defined db_OnGameModeInit
    forward db_OnGameModeInit();
#endif

public OnGameModeExit()
{
    Danya_HideCurrent();

    #if defined db_OnGameModeExit
        return db_OnGameModeExit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit db_OnGameModeExit
#if defined db_OnGameModeExit
    forward db_OnGameModeExit();
#endif

public OnPlayerConnect(playerid)
{
    DanyaInfo[playerid][pDanyaUsed] = false;
    DanyaSpinTimer[playerid] = -1;

    #if defined db_OnPlayerConnect
        return db_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect db_OnPlayerConnect
#if defined db_OnPlayerConnect
    forward db_OnPlayerConnect(playerid);
#endif