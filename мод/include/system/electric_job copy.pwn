
// Электрик: работа с рабочим транспортом, заказами, лампами и поиском неполадки.
// Код в CP1251. Основано на старой системе electric_job.pwn, но переписано под нормальный флоу.

#define ELECTRIC_DIALOG_RENT          (3244)
#define ELECTRIC_DIALOG_CLOTHES       (3245)
#define ELECTRIC_DIALOG_JOB           (3246)
#define ELECTRIC_DIALOG_LAMP          (3247)
#define ELECTRIC_DIALOG_FAULT         (3248)
#define ELECTRIC_DIALOG_INFO          (3249)

#define ELECTRIC_SKIN_ID              (206)
#define ELECTRIC_RENT_PRICE           (1000)
#define ELECTRIC_MIN_LEVEL            (7)
#define ELECTRIC_TASK_NONE            (-1)
#define ELECTRIC_TASK_LAMP            (0)
#define ELECTRIC_TASK_FAULT           (1)

new sphere_menu_electric, sphere_arenda_electric, sphere_razdew_electric;
new sphere_exit_for_electric, sphere_enter_for_electric;

new bool:player_electric[MAX_PLAYERS];
new player_arenda_electric[MAX_PLAYERS];
new player_salary_electric[MAX_PLAYERS];
new player_orders_electric[MAX_PLAYERS];
new player_electric_task[MAX_PLAYERS];
new player_electric_stage[MAX_PLAYERS];
new player_electric_fault[MAX_PLAYERS];
new player_electric_ohm[MAX_PLAYERS][4];

#if !defined INVALID_VEHICLE_ID
    #define INVALID_VEHICLE_ID 65535
#endif

enum struct_orders_electric
{
    E_NAME[64],
    Float:E_MULTIPLIER,
    Float:E_X,
    Float:E_Y,
    Float:E_Z,
    E_SPHERE
}

new orders_electric[10][struct_orders_electric] =
{
    {"Замена лампочки у подъезда №1",                  1.0, -244.631195,  998.545166, 12.000000, -1},
    {"Замена лампочки у подъезда №2",                  1.0, -284.473846, 1006.350891, 12.125518, -1},
    {"Поиск неполадки у подъезда №3",                  1.0, -307.238586, 1005.557983, 12.132812, -1},
    {"Поиск неполадки у подъезда №4",                  1.0, -359.540252, 1005.697875, 12.132812, -1},
    {"Неисправность в зарядной станции Tesla №1",      1.3, -2536.122802,-658.716003, 29.775791, -1},
    {"Неисправность в зарядной станции Tesla №2",      1.3,  1054.243530,-779.238525, 41.320312, -1},
    {"Неисправность в зарядной станции Tesla №3",      1.3,  2239.327880,-733.792724, 13.573974, -1},
    {"Сломанный щиток в банке",                        1.5, -2345.448974, -29.695926, 26.682226, -1},
    {"Сломанный щиток в торговом центре",              1.5, -2391.774414,  -6.903286, 26.517688, -1},
    {"Сломанный щиток в больнице",                     2.0,  -236.503936, 551.704528, 13.089560, -1}
};

stock Electric_ResetPlayer(playerid)
{
    if(player_arenda_electric[playerid] != -1 && player_arenda_electric[playerid] != INVALID_VEHICLE_ID)
    {
        if(IsValidVehicle(player_arenda_electric[playerid])) DestroyVehicle(player_arenda_electric[playerid]);
    }

    player_arenda_electric[playerid] = -1;
    player_salary_electric[playerid] = 0;
    player_orders_electric[playerid] = -1;
    player_electric_task[playerid] = ELECTRIC_TASK_NONE;
    player_electric_stage[playerid] = 0;
    player_electric_fault[playerid] = -1;

    DeletePVar(playerid, "electric_action_lock");
    DeletePVar(playerid, "color_wire");
    DeletePVar(playerid, "stage_dialog_wire");
    return 1;
}

stock OrdinaryNewElectric(playerid)
{
    Electric_ResetPlayer(playerid);
    player_electric[playerid] = false;
    return 1;
}

stock Electric_Notify(playerid, type, const text[])
{
    ShowNotificationKirill(playerid, type, 5, 0, 0, text, " ");
    SendClientMessage(playerid, -1, text);
    return 1;
}

stock Electric_IsWorkingVehicle(playerid)
{
    if(player_arenda_electric[playerid] == -1) return 0;
    if(!IsPlayerInAnyVehicle(playerid)) return 0;
    if(GetPlayerVehicleID(playerid) != player_arenda_electric[playerid]) return 0;
    return 1;
}

stock Electric_GetOrderByArea(areaid)
{
    for(new i = 0; i < sizeof orders_electric; i++)
    {
        if(orders_electric[i][E_SPHERE] == areaid) return i;
    }
    return -1;
}

stock IsPlayerInOrdersElectric(playerid)
{
    for(new p = 0; p < sizeof orders_electric; p++)
    {
        if(orders_electric[p][E_SPHERE] != -1 && IsPlayerInDynamicArea(playerid, orders_electric[p][E_SPHERE])) return p;
    }
    return -1;
}

stock Electric_FinishOrder(playerid)
{
    new text[160];

    if(player_orders_electric[playerid] == -1) return 1;

    GivePlayerMoneyEx(playerid, player_salary_electric[playerid]);

    format(text, sizeof text, "{00FF00}|{FFFFFF} Заказ выполнен. Вы получили {FFFF00}%d {FFFFFF}рублей. Возьмите новый заказ: {FFFF00}/eorders", player_salary_electric[playerid]);
    SendClientMessage(playerid, -1, text);
    ShowNotificationKirill(playerid, 3, 5, 0, 0, "Заказ электрика выполнен. Деньги начислены.", " ");

    player_orders_electric[playerid] = -1;
    player_salary_electric[playerid] = 0;
    player_electric_task[playerid] = ELECTRIC_TASK_NONE;
    player_electric_stage[playerid] = 0;
    player_electric_fault[playerid] = -1;
    return 1;
}

stock Electric_FailOrder(playerid, const reason[])
{
    new text[160];
    format(text, sizeof text, "{FF6347}|{FFFFFF} Заказ провален: %s. Возьмите новый заказ: {FFFF00}/eorders", reason);
    SendClientMessage(playerid, -1, text);
    ShowNotificationKirill(playerid, 2, 5, 0, 0, "Заказ электрика провален.", " ");

    player_orders_electric[playerid] = -1;
    player_salary_electric[playerid] = 0;
    player_electric_task[playerid] = ELECTRIC_TASK_NONE;
    player_electric_stage[playerid] = 0;
    player_electric_fault[playerid] = -1;
    return 1;
}

stock Electric_ShowLampDialog(playerid)
{
    switch(player_electric_stage[playerid])
    {
        case 0:
        {
            Dialog(playerid, ELECTRIC_DIALOG_LAMP, DIALOG_STYLE_MSGBOX,
                "Электрик | Замените лампочку",
                "Подсказка: нажмите на сломанную лампу, чтобы ее снять.\n\n"
                "В вашем наборе есть новая лампочка. Сначала снимите старую лампу.",
                "Снять", "Отмена");
        }
        case 1:
        {
            Dialog(playerid, ELECTRIC_DIALOG_LAMP, DIALOG_STYLE_MSGBOX,
                "Электрик | Замените лампочку",
                "Сломанная лампа снята.\n\n"
                "Теперь установите новую лампочку из набора инструментов.",
                "Поставить", "Отмена");
        }
    }
    return 1;
}

stock Electric_BuildFaultText(playerid, output[], size)
{
    format(output, size,
        "Узел №1\t%d,%02d Ohm\n"
        "Узел №2\t%d,%02d Ohm\n"
        "Узел №3\t%d,%02d Ohm\n"
        "Узел №4\t%d,%02d Ohm",
        player_electric_ohm[playerid][0] / 100, player_electric_ohm[playerid][0] % 100,
        player_electric_ohm[playerid][1] / 100, player_electric_ohm[playerid][1] % 100,
        player_electric_ohm[playerid][2] / 100, player_electric_ohm[playerid][2] % 100,
        player_electric_ohm[playerid][3] / 100, player_electric_ohm[playerid][3] % 100
    );
    return 1;
}

stock Electric_ShowFaultDialog(playerid)
{
    new list[256];
    Electric_BuildFaultText(playerid, list, sizeof list);

    Dialog(playerid, ELECTRIC_DIALOG_FAULT, DIALOG_STYLE_TABLIST,
        "Электрик | Найдите неполадку",
        list,
        "Выбрать", "Отмена");

    SendClientMessage(playerid, -1, "{FFFF00}Подсказка:{FFFFFF} подключите вольтметр и выберите узел с неправильным сопротивлением.");
    return 1;
}

stock Electric_StartMiniGame(playerid, order)
{
    if(order < 0 || order >= sizeof orders_electric) return 0;
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Выйдите из транспорта, чтобы начать ремонт.");

    ApplyAnimationEx(playerid, "INT_SHOP", "shop_shelf", 3.1, 1, 1, 1, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);

    player_electric_stage[playerid] = 0;

    if(order == 0 || order == 1)
    {
        player_electric_task[playerid] = ELECTRIC_TASK_LAMP;
        SetTimerEx("Electric_OpenLampTask", 2000, false, "i", playerid);
    }
    else
    {
        player_electric_task[playerid] = ELECTRIC_TASK_FAULT;
        player_electric_fault[playerid] = random(4);

        for(new i = 0; i < 4; i++)
        {
            player_electric_ohm[playerid][i] = 410 + random(80); // 4.10 - 4.89
        }
        player_electric_ohm[playerid][player_electric_fault[playerid]] = 790 + random(90); // 7.90 - 8.79

        SetTimerEx("Electric_OpenFaultTask", 2000, false, "i", playerid);
    }

    return 1;
}

forward Electric_OpenLampTask(playerid);
public Electric_OpenLampTask(playerid)
{
    ClearAnimations(playerid);
    if(!IsPlayerConnected(playerid)) return 1;
    if(player_orders_electric[playerid] == -1) return 1;
    Electric_ShowLampDialog(playerid);
    return 1;
}

forward Electric_OpenFaultTask(playerid);
public Electric_OpenFaultTask(playerid)
{
    ClearAnimations(playerid);
    if(!IsPlayerConnected(playerid)) return 1;
    if(player_orders_electric[playerid] == -1) return 1;
    Electric_ShowFaultDialog(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    OrdinaryNewElectric(playerid);
    #if defined e_OnPlayerDisconnect
        return e_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect e_OnPlayerDisconnect
#if defined e_OnPlayerDisconnect
    forward e_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerConnect(playerid)
{
    OrdinaryNewElectric(playerid);
    #if defined e_OnPlayerConnect
        return e_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect e_OnPlayerConnect
#if defined e_OnPlayerConnect
    forward e_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn(playerid)
{
    if(player_electric[playerid] && GetPlayerSkin(playerid) == ELECTRIC_SKIN_ID) SetPlayerSkinInit(playerid);
    OrdinaryNewElectric(playerid);
    #if defined e_OnPlayerSpawn
        return e_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn e_OnPlayerSpawn
#if defined e_OnPlayerSpawn
    forward e_OnPlayerSpawn(playerid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == ELECTRIC_DIALOG_RENT)
    {
        if(response)
        {
            if(!player_electric[playerid]) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Сначала устройтесь на работу электрика.");
            if(player_arenda_electric[playerid] != -1) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Вы уже арендовали рабочий транспорт.");
            if(GetPlayerMoneyEx(playerid) < ELECTRIC_RENT_PRICE) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Недостаточно денег для аренды транспорта.");

            player_arenda_electric[playerid] = CreateVehicle(428, -2570.248291, -452.710601, 27.108392, 179.166900, 6, 6, 0);
            PutPlayerInVehicle(playerid, player_arenda_electric[playerid], 0);
            GivePlayerMoneyEx(playerid, -ELECTRIC_RENT_PRICE);
            Electric_Notify(playerid, 3, "Вы арендовали рабочий транспорт. Чтобы взять заказ, используйте /eorders.");
        }
        return 1;
    }

    if(dialogid == ELECTRIC_DIALOG_CLOTHES)
    {
        if(response)
        {
            if(!player_electric[playerid]) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Сначала устройтесь на работу электрика.");
            if(GetPlayerSkin(playerid) == ELECTRIC_SKIN_ID)
            {
                SetPlayerSkinInit(playerid);
                Electric_Notify(playerid, 3, "Вы переоделись обратно в свою одежду.");
            }
            else
            {
                SetPlayerSkin(playerid, ELECTRIC_SKIN_ID);
                Electric_Notify(playerid, 3, "Вы переоделись в рабочую форму электрика.");
                EnablePlayerGPS(playerid, 55, -2548.372802, -442.577972, 27.999729, "Арендуйте рабочий транспорт");
            }
        }
        return 1;
    }

    if(dialogid == ELECTRIC_DIALOG_JOB)
    {
        if(response)
        {
            if(!player_electric[playerid])
            {
                player_electric[playerid] = true;
                Electric_ResetPlayer(playerid);
                player_electric[playerid] = true;
                Electric_Notify(playerid, 3, "Вы устроились на работу электрика.");
                EnablePlayerGPS(playerid, 55, -2465.773925, 352.950286, 1501.085937, "Переоденьтесь в рабочую форму");
            }
            else
            {
                OrdinaryNewElectric(playerid);
                if(GetPlayerSkin(playerid) == ELECTRIC_SKIN_ID) SetPlayerSkinInit(playerid);
                Electric_Notify(playerid, 3, "Вы уволились с работы электрика.");
            }
        }
        return 1;
    }

    if(dialogid == ELECTRIC_DIALOG_LAMP)
    {
        if(!response) return Electric_FailOrder(playerid, "ремонт отменен");
        if(player_electric_task[playerid] != ELECTRIC_TASK_LAMP) return 1;

        switch(player_electric_stage[playerid])
        {
            case 0:
            {
                player_electric_stage[playerid] = 1;
                Electric_ShowLampDialog(playerid);
            }
            case 1:
            {
                player_electric_stage[playerid] = 0;
                Electric_FinishOrder(playerid);
            }
        }
        return 1;
    }

    if(dialogid == ELECTRIC_DIALOG_FAULT)
    {
        if(!response) return Electric_FailOrder(playerid, "диагностика отменена");
        if(player_electric_task[playerid] != ELECTRIC_TASK_FAULT) return 1;

        if(listitem == player_electric_fault[playerid])
        {
            Electric_FinishOrder(playerid);
        }
        else
        {
            SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Вы выбрали исправный узел. Проверьте схему внимательнее.");
            ShowNotificationKirill(playerid, 2, 5, 0, 0, "Неправильный узел. Попробуйте ещё раз.", " ");
            Electric_ShowFaultDialog(playerid);
        }
        return 1;
    }

    if(dialogid == ELECTRIC_DIALOG_INFO) return 1;

    #if defined e_OnDialogResponse
        return e_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse e_OnDialogResponse
#if defined e_OnDialogResponse
    forward e_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == sphere_enter_for_electric)
    {
        SetPlayerPosEx(playerid, -2477.525390, 353.286193, 1501.085937, 264.647674, 1, 1);
        ShowNotificationKirill(playerid, 3, 4, 1, 1, "Вы вошли в помещение электриков.", " ");
    }
    else if(areaid == sphere_exit_for_electric)
    {
        SetPlayerPosEx(playerid, -2541.825683, -424.392333, 28.291095, 267.011932, 0, 0);
        ShowNotificationKirill(playerid, 3, 4, 1, 1, "Вы вышли из помещения электриков.", " ");
    }
    else if(areaid == sphere_arenda_electric)
    {
        if(player_electric[playerid])
        {
            Dialog(playerid, ELECTRIC_DIALOG_RENT, DIALOG_STYLE_MSGBOX,
                "Электрик | Начальник парковки",
                "Вы действительно хотите арендовать рабочий транспорт?\n\n"
                "Стоимость аренды: {FFFF00}1000 {FFFFFF}рублей\n"
                "После аренды сядьте в транспорт и используйте {FFFF00}/eorders{FFFFFF}.",
                "Арендовать", "Назад");
        }
        else SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Сначала устройтесь на работу электрика.");
    }
    else if(areaid == sphere_razdew_electric)
    {
        if(player_electric[playerid])
        {
            Dialog(playerid, ELECTRIC_DIALOG_CLOTHES, DIALOG_STYLE_MSGBOX,
                "Электрик | Раздевалка",
                "Переодеться в рабочую форму / снять рабочую форму?",
                "Далее", "Назад");
        }
    }
    else if(areaid == sphere_menu_electric)
    {
        if(GetPlayerLevel(playerid) >= ELECTRIC_MIN_LEVEL)
        {
            if(!player_electric[playerid])
            {
                Dialog(playerid, ELECTRIC_DIALOG_JOB, DIALOG_STYLE_MSGBOX,
                    "Электрик | Сан Саныч",
                    "Вы хотите устроиться на работу электрика?\n\n"
                    "Вам нужно будет арендовать транспорт, ездить по заявкам, менять лампочки и искать неполадки в щитках.",
                    "Устроиться", "Назад");
            }
            else
            {
                Dialog(playerid, ELECTRIC_DIALOG_JOB, DIALOG_STYLE_MSGBOX,
                    "Электрик | Сан Саныч",
                    "Вы действительно хотите уволиться с работы электрика?",
                    "Уволиться", "Назад");
            }
        }
        else SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Работа электрика доступна с 7 уровня.");
    }
    else
    {
        new order = Electric_GetOrderByArea(areaid);
        if(order != -1)
        {
            if(!player_electric[playerid]) return 1;
            if(player_orders_electric[playerid] == -1) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Сначала возьмите заказ: {FFFF00}/eorders");
            if(player_orders_electric[playerid] != order) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Это не ваш заказ.");
            Electric_StartMiniGame(playerid, order);
            return 1;
        }
    }

    #if defined e_OnPlayerEnterDynamicArea
        return e_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea e_OnPlayerEnterDynamicArea
#if defined e_OnPlayerEnterDynamicArea
    forward e_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnGameModeInit()
{
    print("[W_SYSTEM] Работа электрика загружена.");
    CreateElectric();
    #if defined e_OnGameModeInit
        return e_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit e_OnGameModeInit
#if defined e_OnGameModeInit
    forward e_OnGameModeInit();
#endif

stock CreateElectric()
{
    for(new e = 0; e < sizeof orders_electric; e++)
    {
        CreateDynamicPickup(19198, 23, orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z], -1, -1);
        orders_electric[e][E_SPHERE] = CreateDynamicSphere(orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z], 2.0, -1, -1);

        if(e == 0 || e == 1)
        {
            CreateDynamic3DTextLabel("{FFFF00}Сломанная лампочка\n{FFFFFF}Подойдите для взаимодействия", -1, orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z] + 0.6, 10.0);
        }
        else
        {
            CreateDynamic3DTextLabel("{FFFF00}Электрический щиток\n{FFFFFF}Подойдите для взаимодействия", -1, orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z] + 0.6, 10.0);
        }
    }

    CreateActorEx("{FFFF00}Сан Саныч\n\n{818181}[Работа электрика]", "", 84, -2477.608886, 361.562500, 1501.085937, 264.647674, 1, 1);
    sphere_menu_electric = CreateDynamicSphere(-2477.608886, 361.562500, 1501.085937, 3.0, 1, 1);

    CreateActorEx("{FFFF00}Начальник парковки\n\n{818181}[Аренда транспорта]", "", 84, -2548.372802, -442.577972, 27.999729, 180.0, 0, 0);
    CreateDynamicPickup(19131, 23, -2548.372802, -442.577972, 27.999729, 0, 0);
    sphere_arenda_electric = CreateDynamicSphere(-2548.372802, -442.577972, 27.999729, 3.0, 0, 0);
    CreateDynamic3DTextLabel("{FFFF00}Начальник парковки\n{FFFFFF}Подойдите для взаимодействия", -1, -2548.372802, -442.577972, 28.799729, 10.0, 0, 0);

    CreateDynamicPickup(1275, 23, -2465.773925, 352.950286, 1501.085937, 1, 1);
    sphere_razdew_electric = CreateDynamicSphere(-2465.773925, 352.950286, 1501.085937, 3.0, 1, 1);
    CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Нажмите для взаимодействия", -1, -2465.773925, 352.950286, 1501.685937, 10.0, 1, 1);

    sphere_enter_for_electric = CreateDynamicSphere(-2542.872558, -424.708251, 28.280979, 1.0, 0, 0);
    sphere_exit_for_electric = CreateDynamicSphere(-2479.000732, 352.865173, 1501.085937, 1.0, 1, 1);
    CreateDynamicPickup(19134, 23, -2542.872558, -424.708251, 28.280979, 0, 0);
    CreateDynamicPickup(19134, 23, -2479.000732, 352.865173, 1501.085937, 1, 1);
    CreateDynamic3DTextLabel("{FFFF00}Вход\n{FFFFFF}[Работа электрика]", -1, -2542.872558, -424.708251, 28.880979, 10.0, 0, 0);
    CreateDynamic3DTextLabel("{FFFF00}Выход\n{FFFFFF}[Работа электрика]", -1, -2479.000732, 352.865173, 1501.685937, 10.0, 1, 1);
    return 1;
}

CMD:eorders(playerid)
{
    if(!player_electric[playerid]) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Вы не работаете электриком.");
    if(player_orders_electric[playerid] != -1) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Сначала выполните предыдущий заказ.");
    if(GetPlayerSkin(playerid) != ELECTRIC_SKIN_ID) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Переоденьтесь в рабочую форму, чтобы взять заказ.");
    if(player_arenda_electric[playerid] == -1) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Сначала арендуйте рабочий транспорт.");
    if(!Electric_IsWorkingVehicle(playerid)) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Вы должны находиться в рабочем транспорте.");

    player_orders_electric[playerid] = random(sizeof orders_electric);

    new p = player_orders_electric[playerid], text[180];
    new Float:dist = GetPlayerDistanceFromPoint(playerid, orders_electric[p][E_X], orders_electric[p][E_Y], orders_electric[p][E_Z]);
    new Float:salary = orders_electric[p][E_MULTIPLIER] * (floatround(dist) * 3) + 2500 + random(2500);
    player_salary_electric[playerid] = floatround(salary);

    format(text, sizeof text, "Ваш заказ: {FFFF00}%s{FFFFFF}. Оплата: {FFFF00}%d рублей", orders_electric[p][E_NAME], player_salary_electric[playerid]);
    SendClientMessage(playerid, -1, text);
    ShowNotificationKirill(playerid, 3, 5, 0, 0, "Новый заказ электрика принят. Езжайте на точку.", " ");
    EnablePlayerGPS(playerid, 55, orders_electric[p][E_X], orders_electric[p][E_Y], orders_electric[p][E_Z], "На карте отмечен ваш заказ");
    return 1;
}

CMD:electric(playerid)
{
    if(!player_electric[playerid])
    {
        if(GetPlayerLevel(playerid) < ELECTRIC_MIN_LEVEL) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Работа электрика доступна с 7 уровня.");
        player_electric[playerid] = true;
        Electric_ResetPlayer(playerid);
        player_electric[playerid] = true;
        Electric_Notify(playerid, 3, "Вы устроились на работу электрика. Езжайте в раздевалку и арендуйте транспорт.");
        EnablePlayerGPS(playerid, 55, -2465.773925, 352.950286, 1501.085937, "Переоденьтесь в рабочую форму");
    }
    else
    {
        OrdinaryNewElectric(playerid);
        if(GetPlayerSkin(playerid) == ELECTRIC_SKIN_ID) SetPlayerSkinInit(playerid);
        Electric_Notify(playerid, 3, "Вы уволились с работы электрика.");
    }
    return 1;
}

CMD:eljob(playerid)
{
    return cmd_electric(playerid);
}
CMD:erent(playerid)
{
    if(!player_electric[playerid]) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Вы не работаете электриком.");
    Dialog(playerid, ELECTRIC_DIALOG_RENT, DIALOG_STYLE_MSGBOX,
        "Электрик | Начальник парковки",
        "Вы действительно хотите арендовать рабочий транспорт?\nСтоимость: {FFFF00}1000 {FFFFFF}рублей.",
        "Арендовать", "Назад");
    return 1;
}

CMD:eform(playerid)
{
    if(!player_electric[playerid]) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} Вы не работаете электриком.");
    Dialog(playerid, ELECTRIC_DIALOG_CLOTHES, DIALOG_STYLE_MSGBOX,
        "Электрик | Раздевалка",
        "Переодеться в рабочую форму / снять рабочую форму?",
        "Далее", "Назад");
    return 1;
}

CMD:ecancel(playerid)
{
    if(!player_electric[playerid]) return 1;
    if(player_orders_electric[playerid] == -1) return SendClientMessage(playerid, -1, "{FF6347}|{FFFFFF} У вас нет активного заказа.");
    player_orders_electric[playerid] = -1;
    player_salary_electric[playerid] = 0;
    player_electric_task[playerid] = ELECTRIC_TASK_NONE;
    player_electric_stage[playerid] = 0;
    player_electric_fault[playerid] = -1;
    SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF} Вы отменили текущий заказ электрика.");
    return 1;
}

CMD:ehelp(playerid)
{
    Dialog(playerid, ELECTRIC_DIALOG_INFO, DIALOG_STYLE_MSGBOX,
        "Электрик | Помощь",
        "1. Устройтесь на работу у Сан Саныча.\n"
        "2. Переоденьтесь в рабочую форму.\n"
        "3. Арендуйте рабочий транспорт у начальника парковки.\n"
        "4. Используйте /eorders, чтобы взять заказ.\n"
        "5. На точке замените лампу или найдите неисправный узел.",
        "Понятно", "");
    return 1;
}

// Старое имя оставлено, чтобы не ломать возможные вызовы из других частей мода.
forward NextStageElectric(playerid);
public NextStageElectric(playerid)
{
    if(player_orders_electric[playerid] == -1) return 1;
    Electric_StartMiniGame(playerid, player_orders_electric[playerid]);
    return 1;
}
