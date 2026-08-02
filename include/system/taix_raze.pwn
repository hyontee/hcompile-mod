// taxi_system.inc
// ПРОСТО ПОДКЛЮЧИ: #include <taxi_system>

#if defined _taxi_system_included
    #endinput
#endif
#define _taxi_system_included

#include <a_samp>

// ----- КОНСТАНТЫ -----
#define TAXI_WORKER_SKIN 80
#define TAXI_VEHICLE_MODEL 420

// ----- ЦВЕТА -----
#define COLOR_TAXI_GREEN 0x33AA33FF
#define COLOR_TAXI_YELLOW 0xFFFF00AA
#define COLOR_TAXI_RED 0xFF0000FF

// ----- ПЕРЕМЕННЫЕ -----
static pickupTaxi1, pickupTaxi2, pickupTaxi3, pickupTaxi4;
static actorTaxi1, actorTaxi2, actorTaxi3, actorTaxi4;
static bool:IsOnTaxiDuty[MAX_PLAYERS];
static TaxiVehicleID[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

static const Float:TaxiPoints[][4] = {
    {381.964111, 1372.486816, 15.451137, 257.165344},
    {2416.094238, 1395.261108, 12.647074, 3.835940},
    {2433.199218, 1401.884399, 12.003049, 271.723114},
    {385.124420, 1339.311279, 15.154649, 44.982700}
};

static const TaxiNames[][32] = {
    "Центральный таксопарк",
    "Восточный таксопарк",
    "Северный таксопарк",
    "Западный таксопарк"
};

// ----- ПЕРЕХВАТЫВАЕМ СОБЫТИЯ АВТОМАТИЧЕСКИ -----
public OnGameModeInit()
{
    print("  Загрузка системы таксиста...");
    
    pickupTaxi1 = CreatePickup(1318, 1, TaxiPoints[0][0], TaxiPoints[0][1], TaxiPoints[0][2], -1);
    pickupTaxi2 = CreatePickup(1318, 1, TaxiPoints[1][0], TaxiPoints[1][1], TaxiPoints[1][2], -1);
    pickupTaxi3 = CreatePickup(1318, 1, TaxiPoints[2][0], TaxiPoints[2][1], TaxiPoints[2][2], -1);
    pickupTaxi4 = CreatePickup(1318, 1, TaxiPoints[3][0], TaxiPoints[3][1], TaxiPoints[3][2], -1);
    
    actorTaxi1 = CreateActor(TAXI_WORKER_SKIN, TaxiPoints[0][0], TaxiPoints[0][1], TaxiPoints[0][2], TaxiPoints[0][3]);
    actorTaxi2 = CreateActor(TAXI_WORKER_SKIN, TaxiPoints[1][0], TaxiPoints[1][1], TaxiPoints[1][2], TaxiPoints[1][3]);
    actorTaxi3 = CreateActor(TAXI_WORKER_SKIN, TaxiPoints[2][0], TaxiPoints[2][1], TaxiPoints[2][2], TaxiPoints[2][3]);
    actorTaxi4 = CreateActor(TAXI_WORKER_SKIN, TaxiPoints[3][0], TaxiPoints[3][1], TaxiPoints[3][2], TaxiPoints[3][3]);
    
    SetActorInvulnerable(actorTaxi1, true);
    SetActorInvulnerable(actorTaxi2, true);
    SetActorInvulnerable(actorTaxi3, true);
    SetActorInvulnerable(actorTaxi4, true);
    
    print("  Система таксиста загружена!");
    
    #if defined taxi_OnGameModeInit
        return taxi_OnGameModeInit();
    #else
        return 1;
    #endif
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == pickupTaxi1) Taxi_ShowMenu(playerid, 0);
    else if(pickupid == pickupTaxi2) Taxi_ShowMenu(playerid, 1);
    else if(pickupid == pickupTaxi3) Taxi_ShowMenu(playerid, 2);
    else if(pickupid == pickupTaxi4) Taxi_ShowMenu(playerid, 3);
    
    #if defined taxi_OnPlayerPickUpPickup
        return taxi_OnPlayerPickUpPickup(playerid, pickupid);
    #else
        return 1;
    #endif
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(dialogid)
        {
            case 7001:
            {
                switch(listitem)
                {
                    case 0: Taxi_Hire(playerid);
                    case 1: if(IsOnTaxiDuty[playerid]) Taxi_GiveVehicle(playerid);
                    else SendClientMessage(playerid, COLOR_TAXI_RED, "Вы не работаете таксистом!");
                }
                return 1;
            }
            case 7002:
            {
                switch(listitem)
                {
                    case 0: Taxi_GiveVehicle(playerid);
                    case 1: Taxi_ReturnVehicle(playerid);
                    case 2: Taxi_Fire(playerid);
                }
                return 1;
            }
        }
    }
    
    #if defined taxi_OnDialogResponse
        return taxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

public OnPlayerText(playerid, text[])
{
    if(text[0] == '/')
    {
        if(strcmp(text, "/taxi", true) == 0)
        {
            Taxi_Command(playerid);
            return 0;
        }
        if(strcmp(text, "/taxiduty", true) == 0)
        {
            Taxi_DutyCommand(playerid);
            return 0;
        }
    }
    
    #if defined taxi_OnPlayerText
        return taxi_OnPlayerText(playerid, text);
    #else
        return 1;
    #endif
}

public OnPlayerDisconnect(playerid, reason)
{
    if(TaxiVehicleID[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(TaxiVehicleID[playerid]);
        TaxiVehicleID[playerid] = INVALID_VEHICLE_ID;
    }
    IsOnTaxiDuty[playerid] = false;
    
    #if defined taxi_OnPlayerDisconnect
        return taxi_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

// ----- ВНУТРЕННИЕ ФУНКЦИИ -----
static Taxi_ShowMenu(playerid, pointid)
{
    new menuString[512];
    
    if(!IsOnTaxiDuty[playerid])
    {
        format(menuString, sizeof(menuString),
            "Добро пожаловать в %s!\n\n\
            Выберите действие:\n\
            1. Устроиться на работу таксистом\n\
            2. Взять такси (если уже работаете)\n\
            3. Закрыть меню",
            TaxiNames[pointid]
        );
        ShowPlayerDialog(playerid, 7001, DIALOG_STYLE_LIST, "Таксопарк", menuString, "Выбрать", "Отмена");
    }
    else
    {
        format(menuString, sizeof(menuString),
            "Добро пожаловать в %s!\n\n\
            Выберите действие:\n\
            1. Взять такси (рабочее авто)\n\
            2. Сдать такси\n\
            3. Уволиться\n\
            4. Закрыть меню",
            TaxiNames[pointid]
        );
        ShowPlayerDialog(playerid, 7002, DIALOG_STYLE_LIST, "Таксопарк", menuString, "Выбрать", "Отмена");
    }
    return 1;
}

static Taxi_Hire(playerid)
{
    if(IsOnTaxiDuty[playerid])
        return SendClientMessage(playerid, COLOR_TAXI_RED, "Вы уже работаете таксистом!");
    
    IsOnTaxiDuty[playerid] = true;
    SendClientMessage(playerid, COLOR_TAXI_GREEN, "Вы устроились на работу таксистом!");
    SendClientMessage(playerid, COLOR_TAXI_YELLOW, "Подойдите к пикапу чтобы взять машину.");
    SetPlayerColor(playerid, COLOR_TAXI_YELLOW);
    return 1;
}

static Taxi_Fire(playerid)
{
    if(!IsOnTaxiDuty[playerid])
        return SendClientMessage(playerid, COLOR_TAXI_RED, "Вы не работаете таксистом!");
    
    if(TaxiVehicleID[playerid] != INVALID_VEHICLE_ID)
        Taxi_ReturnVehicle(playerid);
    
    IsOnTaxiDuty[playerid] = false;
    SendClientMessage(playerid, COLOR_TAXI_RED, "Вы уволились с работы таксиста!");
    SetPlayerColor(playerid, 0xFFFFFFFF);
    return 1;
}

static Taxi_GiveVehicle(playerid)
{
    if(!IsOnTaxiDuty[playerid])
        return SendClientMessage(playerid, COLOR_TAXI_RED, "Вы не работаете таксистом!");
    
    if(TaxiVehicleID[playerid] != INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_TAXI_RED, "У вас уже есть рабочее такси!");
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    new vehicleid = CreateVehicle(TAXI_VEHICLE_MODEL, x+3, y+2, z, a, 6, 6, 300);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_TAXI_RED, "Ошибка создания такси!");
    
    SetVehicleNumberPlate(vehicleid, "TAXI");
    SetVehicleParamsForPlayer(vehicleid, playerid, true, false);
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    
    PutPlayerInVehicle(playerid, vehicleid, 0);
    TaxiVehicleID[playerid] = vehicleid;
    
    SendClientMessage(playerid, COLOR_TAXI_GREEN, "Вы получили рабочее такси!");
    return 1;
}

static Taxi_ReturnVehicle(playerid)
{
    if(!IsOnTaxiDuty[playerid])
        return SendClientMessage(playerid, COLOR_TAXI_RED, "Вы не работаете таксистом!");
    
    if(TaxiVehicleID[playerid] == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_TAXI_RED, "У вас нет рабочего такси!");
    
    DestroyVehicle(TaxiVehicleID[playerid]);
    TaxiVehicleID[playerid] = INVALID_VEHICLE_ID;
    
    SendClientMessage(playerid, COLOR_TAXI_GREEN, "Вы сдали рабочее такси!");
    return 1;
}

static Taxi_Command(playerid)
{
    if(!IsOnTaxiDuty[playerid])
        return SendClientMessage(playerid, COLOR_TAXI_RED, "Вы не работаете таксистом!");
    
    Taxi_ShowMenu(playerid, 0);
    return 1;
}

static Taxi_DutyCommand(playerid)
{
    if(IsOnTaxiDuty[playerid])
        return SendClientMessage(playerid, COLOR_TAXI_YELLOW, "Вы уже на работе.");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < 4; i++)
    {
        if(GetPlayerDistanceFromPoint(playerid, TaxiPoints[i][0], TaxiPoints[i][1], TaxiPoints[i][2]) < 5.0)
        {
            Taxi_Hire(playerid);
            return 1;
        }
    }
    
    SendClientMessage(playerid, COLOR_TAXI_RED, "Вы должны находиться в таксопарке!");
    return 1;
}

// ----- ХУКИ ДЛЯ СОВМЕСТИМОСТИ -----
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit taxi_OnGameModeInit
#if defined taxi_OnGameModeInit
    forward taxi_OnGameModeInit();
#endif

#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define _ALS_OnPlayerPickUpPickup
#endif
#define OnPlayerPickUpPickup taxi_OnPlayerPickUpPickup
#if defined taxi_OnPlayerPickUpPickup
    forward taxi_OnPlayerPickUpPickup(playerid, pickupid);
#endif

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse taxi_OnDialogResponse
#if defined taxi_OnDialogResponse
    forward taxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

#if defined _ALS_OnPlayerText
    #undef OnPlayerText
#else
    #define _ALS_OnPlayerText
#endif
#define OnPlayerText taxi_OnPlayerText
#if defined taxi_OnPlayerText
    forward taxi_OnPlayerText(playerid, text[]);
#endif

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect taxi_OnPlayerDisconnect
#if defined taxi_OnPlayerDisconnect
    forward taxi_OnPlayerDisconnect(playerid, reason);
#endif