#if defined _ELECTRICIAN_INCLUDED
    #endinput
#endif
#define _ELECTRICIAN_INCLUDED



#if !defined MAX_PLAYERS
    #define MAX_PLAYERS 1000
#endif


#define ELECTRICIAN_JOB_VEHICLE_MODEL       552

#define ELECTRICIAN_START_X                 0.0
#define ELECTRICIAN_START_Y                 0.0
#define ELECTRICIAN_START_Z                 0.0

#define ELECTRICIAN_VEHICLE_X               0.0
#define ELECTRICIAN_VEHICLE_Y               0.0
#define ELECTRICIAN_VEHICLE_Z               0.0
#define ELECTRICIAN_VEHICLE_A               0.0

#define ELECTRICIAN_MIN_PAYMENT             500
#define ELECTRICIAN_MAX_PAYMENT             1200

#define ELECTRICIAN_REPAIR_TIME             5000

#define ELECTRICIAN_COLOR                   0xFFD700FF
#define ELECTRICIAN_COLOR_GREEN                         0x33CC33FF
#define ELECTRICIAN_COLOR_RED                           0xFF3333FF
#define ELECTRICIAN_COLOR_WHITE                         0xFFFFFFFF


new bool:ElectricianWorking[MAX_PLAYERS];
new bool:ElectricianRepairing[MAX_PLAYERS];

new ElectricianVehicle[MAX_PLAYERS];
new ElectricianCheckpoint[MAX_PLAYERS];

new ElectricianLevel[MAX_PLAYERS];
new ElectricianExp[MAX_PLAYERS];
new ElectricianCompleted[MAX_PLAYERS];
new ElectricianMoney[MAX_PLAYERS];

new ElectricianRepairTimer[MAX_PLAYERS];


enum e_ELECTRICIAN_POINT
{
    Float:EP_X,
    Float:EP_Y,
    Float:EP_Z,
    Float:EP_A
};

new const ElectricianPoints[][e_ELECTRICIAN_POINT] =
{
    { 1000.0, 1000.0, 10.0, 0.0 },
    { 1100.0, 1050.0, 10.0, 90.0 },
    { 1200.0, 1100.0, 10.0, 180.0 },
    { 1300.0, 1150.0, 10.0, 270.0 },
    { 1400.0, 1200.0, 10.0, 0.0 },
    { 1500.0, 1250.0, 10.0, 90.0 },
    { 1600.0, 1300.0, 10.0, 180.0 },
    { 1700.0, 1350.0, 10.0, 270.0 }
};

#define ELECTRICIAN_POINTS sizeof(ElectricianPoints)


stock Electrician_IsPlayerWorking(playerid)
{
    return ElectricianWorking[playerid];
}

stock Electrician_GetLevel(playerid)
{
    return ElectricianLevel[playerid];
}

stock Electrician_GetExp(playerid)
{
    return ElectricianExp[playerid];
}

stock Electrician_GetCompleted(playerid)
{
    return ElectricianCompleted[playerid];
}


stock Electrician_SetNextPoint(playerid)
{
    if(!ElectricianWorking[playerid])
        return 0;

    new point = random(ELECTRICIAN_POINTS);

    ElectricianCheckpoint[playerid] = point;

    SetPlayerCheckpoint(
        playerid,
        ElectricianPoints[point][EP_X],
        ElectricianPoints[point][EP_Y],
        ElectricianPoints[point][EP_Z],
        4.0
    );

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR,
        "[ЭЛЕКТРИК] Новый заказ получен. Следуйте к месту неисправности."
    );

    return 1;
}


stock Electrician_CreateVehicle(playerid)
{
    if(ElectricianVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(ElectricianVehicle[playerid]);
        ElectricianVehicle[playerid] = INVALID_VEHICLE_ID;
    }

    ElectricianVehicle[playerid] = CreateVehicle(
        ELECTRICIAN_JOB_VEHICLE_MODEL,
        ELECTRICIAN_VEHICLE_X,
        ELECTRICIAN_VEHICLE_Y,
        ELECTRICIAN_VEHICLE_Z,
        ELECTRICIAN_VEHICLE_A,
        1,
        1,
        -1
    );

    SetVehicleNumberPlate(
        ElectricianVehicle[playerid],
        "ELECTRO"
    );

    return 1;
}


stock Electrician_Start(playerid)
{
    if(ElectricianWorking[playerid])
    {
        SendClientMessage(
            playerid,
            ELECTRICIAN_COLOR_RED,
            "[ЭЛЕКТРИК] Вы уже работаете."
        );
        return 0;
    }

    ElectricianWorking[playerid] = true;
    ElectricianRepairing[playerid] = false;

    ElectricianLevel[playerid] = 1;
    ElectricianExp[playerid] = 0;

    Electrician_CreateVehicle(playerid);

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR_GREEN,
        "=========================================="
    );

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR,
        "[ЭЛЕКТРИК] Вы начали рабочую смену."
    );

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR_WHITE,
        "[ЭЛЕКТРИК] Сядьте в рабочий автомобиль и следуйте к заказу."
    );

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR_GREEN,
        "=========================================="
    );

    Electrician_SetNextPoint(playerid);

    return 1;
}


stock Electrician_Stop(playerid)
{
    if(!ElectricianWorking[playerid])
    {
        SendClientMessage(
            playerid,
            ELECTRICIAN_COLOR_RED,
            "[ЭЛЕКТРИК] Вы не работаете."
        );
        return 0;
    }

    ElectricianWorking[playerid] = false;
    ElectricianRepairing[playerid] = false;

    DisablePlayerCheckpoint(playerid);

    if(ElectricianRepairTimer[playerid] != 0)
    {
        KillTimer(ElectricianRepairTimer[playerid]);
        ElectricianRepairTimer[playerid] = 0;
    }

    if(ElectricianVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(ElectricianVehicle[playerid]);
        ElectricianVehicle[playerid] = INVALID_VEHICLE_ID;
    }

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR,
        "[ЭЛЕКТРИК] Вы закончили рабочую смену."
    );

    return 1;
}


stock Electrician_AddExp(playerid, amount)
{
    ElectricianExp[playerid] += amount;

    new required = ElectricianLevel[playerid] * 100;

    if(ElectricianExp[playerid] >= required)
    {
        ElectricianExp[playerid] -= required;
        ElectricianLevel[playerid]++;

        new message[144];

        format(
            message,
            sizeof(message),
            "[ЭЛЕКТРИК] Вы получили новый уровень! Теперь ваш уровень: %d.",
            ElectricianLevel[playerid]
        );

        SendClientMessage(
            playerid,
            ELECTRICIAN_COLOR,
            message
        );
    }

    return 1;
}


stock Electrician_Pay(playerid)
{
    new payment;

    payment = random(
        ELECTRICIAN_MAX_PAYMENT -
        ELECTRICIAN_MIN_PAYMENT +
        1
    ) + ELECTRICIAN_MIN_PAYMENT;

    payment += ElectricianLevel[playerid] * 100;

    GivePlayerMoneyEx(playerid, payment);

    ElectricianMoney[playerid] += payment;
    ElectricianCompleted[playerid]++;

    Electrician_AddExp(playerid, 25);

    new message[144];

    format(
        message,
        sizeof(message),
        "[ЭЛЕКТРИК] Заказ выполнен! Вы получили $%d.",
        payment
    );

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR_GREEN,
        message
    );

    return 1;
}


forward Electrician_FinishRepair(playerid);

public Electrician_FinishRepair(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    ElectricianRepairTimer[playerid] = 0;

    if(!ElectricianWorking[playerid])
        return 0;

    ElectricianRepairing[playerid] = false;

    Electrician_Pay(playerid);

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR,
        "[ЭЛЕКТРИК] Следующий заказ загружается..."
    );

    Electrician_SetNextPoint(playerid);

    return 1;
}


stock Electrician_StartRepair(playerid)
{
    if(!ElectricianWorking[playerid])
        return 0;

    if(ElectricianRepairing[playerid])
        return 0;

    ElectricianRepairing[playerid] = true;

    DisablePlayerCheckpoint(playerid);

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR,
        "[ЭЛЕКТРИК] Вы начали ремонт электрооборудования."
    );

    SendClientMessage(
        playerid,
        ELECTRICIAN_COLOR_WHITE,
        "[ЭЛЕКТРИК] Пожалуйста, подождите..."
    );

    ElectricianRepairTimer[playerid] =
        SetTimerEx(
            "Electrician_FinishRepair",
            ELECTRICIAN_REPAIR_TIME,
            false,
            "i",
            playerid
        );

    return 1;
}


#if defined CMD
CMD:electrician(playerid, params[])
{
    if(ElectricianWorking[playerid])
    {
        SendClientMessage(
            playerid,
            ELECTRICIAN_COLOR_RED,
            "[ЭЛЕКТРИК] Вы уже работаете."
        );

        return 1;
    }

    Electrician_Start(playerid);

    return 1;
}

CMD:electrics(playerid, params[])
{
    Electrician_Start(playerid);
    return 1;
}

CMD:electricoff(playerid, params[])
{
    Electrician_Stop(playerid);

    return 1;
}
#endif


stock Electrician_OnPlayerEnterCheckpoint(playerid)
{
    if(!ElectricianWorking[playerid])
        return 0;

    if(ElectricianRepairing[playerid])
        return 0;

    if(IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(
            playerid,
            ELECTRICIAN_COLOR_RED,
            "[ЭЛЕКТРИК] Выйдите из автомобиля."
        );

        return 1;
    }

    Electrician_StartRepair(playerid);

    return 1;
}


stock Electrician_IsJobVehicle(playerid)
{
    if(ElectricianVehicle[playerid] == INVALID_VEHICLE_ID)
        return 0;

    if(GetPlayerVehicleID(playerid) != ElectricianVehicle[playerid])
        return 0;

    return 1;
}


stock Electrician_ShowStats(playerid)
{
    new text[512];

    format(
        text,
        sizeof(text),
        "\
        {FFFFFF}Статистика электрика\n\n\
        {FFD700}Уровень: {FFFFFF}%d\n\
        {FFD700}Опыт: {FFFFFF}%d\n\
        {FFD700}Выполнено заказов: {FFFFFF}%d\n\
        {FFD700}Заработано: {FFFFFF}$%d",
        ElectricianLevel[playerid],
        ElectricianExp[playerid],
        ElectricianCompleted[playerid],
        ElectricianMoney[playerid]
    );

    ShowPlayerDialog(
        playerid,
        1999,
        DIALOG_STYLE_MSGBOX,
        "Электрик — статистика",
        text,
        "Закрыть",
        ""
    );

    return 1;
}


stock Electrician_InitPlayer(playerid)
{
    ElectricianWorking[playerid] = false;
    ElectricianRepairing[playerid] = false;

    ElectricianVehicle[playerid] = INVALID_VEHICLE_ID;
    ElectricianCheckpoint[playerid] = -1;

    ElectricianLevel[playerid] = 1;
    ElectricianExp[playerid] = 0;
    ElectricianCompleted[playerid] = 0;
    ElectricianMoney[playerid] = 0;

    ElectricianRepairTimer[playerid] = 0;

    return 1;
}

public OnPlayerConnect(playerid)
{
    Electrician_InitPlayer(playerid);

    #if defined electric_OnPlayerConnect
        return electric_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
#undef OnPlayerConnect
#else
#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect electric_OnPlayerConnect
#if defined electric_OnPlayerConnect
forward electric_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(ElectricianVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(ElectricianVehicle[playerid]);
        ElectricianVehicle[playerid] = INVALID_VEHICLE_ID;
    }

    if(ElectricianRepairTimer[playerid] != 0)
    {
        KillTimer(ElectricianRepairTimer[playerid]);
        ElectricianRepairTimer[playerid] = 0;
    }

    ElectricianWorking[playerid] = false;
    ElectricianRepairing[playerid] = false;

    #if defined electric_OnPlayerDisconnect
        return electric_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
#undef OnPlayerDisconnect
#else
#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect electric_OnPlayerDisconnect
#if defined electric_OnPlayerDisconnect
forward electric_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerEnterCheckpoint(playerid)
{
    Electrician_OnPlayerEnterCheckpoint(playerid);

    #if defined electric_OnPlayerEnterCheckpoint
        return electric_OnPlayerEnterCheckpoint(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerEnterCheckpoint
#undef OnPlayerEnterCheckpoint
#else
#define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint electric_OnPlayerEnterCheckpoint
#if defined electric_OnPlayerEnterCheckpoint
forward electric_OnPlayerEnterCheckpoint(playerid);
#endif
