// ==========================================
//          РАБОТА ЭЛЕКТРИКА
// ==========================================

new sphere_menu_electric, sphere_arenda_electric, sphere_razdew_electric;
new sphere_exit_for_electric, sphere_enter_for_electric;

new bool:player_electric[MAX_PLAYERS];
new player_arenda_electric[MAX_PLAYERS];
new player_salary_electric[MAX_PLAYERS];
new player_orders_electric[MAX_PLAYERS];

enum struct_orders_electric
{
    E_NAME[42],
    Float:E_MULTIPLIER,
    Float:E_X,        
    Float:E_Y,    
    Float:E_Z,
    E_SPHERE
}

new Float:coord_houses_electric[4][3] =
{
    {-244.631195,998.545166,12.000000},
    {-284.473846,1006.350891,12.125518},
    {-307.238586,1005.557983,12.132812},
    {-359.540252,1005.697875,12.132812}
};

new orders_electric[10][struct_orders_electric] = 
{
    {"Сломанный щиток в подъезде 1", 1.0,                      559.875244,27.876850,1049.265625, -1},
    {"Сломанный щиток в подъезде 2", 1.0,                      559.875244,27.876850,1049.265625, -1},
    {"Сломанный щиток в подъезде 3", 1.0,                      559.875244,27.876850,1049.265625, -1},
    {"Сломанный щиток в подъезде 4", 1.0,                      559.875244,27.876850,1049.265625, -1},
    {"Неисправность в зарядной станции Tesla 1", 1.3,          -2536.122802,-658.716003,29.775791, -1},
    {"Неисправность в зарядной станции Tesla 2", 1.3,          1054.243530,-779.238525,41.320312, -1},
    {"Неисправность в зарядной станции Tesla 3", 1.3,          2239.327880,-733.792724,13.573974, -1},
    {"Сломанный щиток в Лыткаринском Банке", 1.5,             -2345.448974,-29.695926,26.682226, -1},
    {"Сломанный щиток в Торговом центре", 1.5,                -2391.774414,-6.903286,26.517688, -1},
    {"Сломанный щиток в Больнице", 2.0,                         -236.503936,551.704528,13.089560, -1}
};




// ==========================================
//          СОЗДАНИЕ ОБЪЕКТОВ
// ==========================================

stock CreateElectric()
{
    for(new e = 0; e < sizeof orders_electric; e++)
    {
        CreateDynamicPickup(19198, 23, orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z], -1, -1);
        orders_electric[e][E_SPHERE] = CreateDynamicSphere(orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z], 1.5, -1, -1);
        if(orders_electric[e][E_MULTIPLIER] == 1.3) 
            Create3DTextLabel("Зарядная станция", -1, orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z], 10.0, 0);
        else 
            CreateDynamic3DTextLabel("Электрический щиток", -1, orders_electric[e][E_X], orders_electric[e][E_Y], orders_electric[e][E_Z], 10.0);
    }

    CreateActor(84, -2477.608886,361.562500,1501.085937, 264.647674);
    sphere_menu_electric = CreateDynamicSphere(-2477.608886,361.562500,1501.085937, 3.0, 1, 1);

    CreateDynamicPickup(19131, 23, -2548.372802,-442.577972,27.999729, 0, 0);
    sphere_arenda_electric = CreateDynamicSphere(-2548.372802,-442.577972,27.999729, 3.0, 0, 0);
    Create3DTextLabel("Аренда транспорта", -1, -2548.372802,-442.577972,27.999729, 10.0, 0);

    CreateDynamicPickup(1275, 23, -2465.773925,352.950286,1501.085937, 1, 1);
    sphere_razdew_electric = CreateDynamicSphere(-2465.773925,352.950286,1501.085937, 3.0, 1, 1);
    Create3DTextLabel("Раздевалка", -1, -2465.773925,352.950286,1501.085937, 10.0, 1);    

    sphere_enter_for_electric = CreateDynamicSphere(-2542.872558,-424.708251,28.280979, 1.0, 0, 0);
    Create3DTextLabel("Вход", -1, -2542.872558,-424.708251,28.280979, 10.0, 0);
    sphere_exit_for_electric = CreateDynamicSphere(-2479.000732,352.865173,1501.085937, 1.0, 1, 1); 
    CreateDynamicPickup(19134, 23, -2542.872558,-424.708251,28.280979, 0, 0);
    CreateDynamicPickup(19134, 23, -2479.000732,352.865173,1501.085937, 1, 1);
    
    return 1;
}

// ==========================================
//          КОМАНДЫ
// ==========================================

CMD:eorders(playerid)
{
    if(!player_electric[playerid]) return 1;
    if(player_orders_electric[playerid] != -1) 
        return SendClientMessage(playerid, -1, "Сначала выполните предыдущий заказ");
    if(GetPlayerSkin(playerid) != 206) 
        return SendClientMessage(playerid, -1, "Переоденьтесь в рабочую форму чтобы взять заказ");
    if(player_arenda_electric[playerid] == -1) 
        return SendClientMessage(playerid, -1, "Сначала арендуйте рабочий транспорт");
    if(GetPlayerVehicleID(playerid) != player_arenda_electric[playerid]) 
        return SendClientMessage(playerid, -1, "Вы должны находиться в рабочем транспорте");

    player_orders_electric[playerid] = random(10);
    new p = player_orders_electric[playerid];
    new Float:dist = GetPlayerDistanceFromPoint(playerid, orders_electric[p][E_X], orders_electric[p][E_Y], orders_electric[p][E_Z]);
    new Float:salary = orders_electric[player_orders_electric[playerid]][E_MULTIPLIER] * (floatround(dist) * 3) + random(2500);
    player_salary_electric[playerid] = floatround(salary);
    
    new text[148];
    format(text, sizeof text, "Ваш заказ: %s. Зарплата: %d", orders_electric[p][E_NAME], player_salary_electric[playerid]);
    SendClientMessage(playerid, -1, text);

    return 1;
}

// ==========================================
//          СТОКИ
// ==========================================

stock IsPlayerInOrdersElectric(playerid)
{
    for(new p = 0; p < sizeof orders_electric; p++)
    {
        if(IsPlayerInDynamicArea(playerid, orders_electric[p][E_SPHERE])) return p;
    }
    return -1;
}

stock OrdinaryNewElectric(playerid)
{
    if(player_arenda_electric[playerid] != -1) 
    {
        DestroyVehicle(player_arenda_electric[playerid]);
        player_arenda_electric[playerid] = -1;
    }
    player_electric[playerid] = false;
    player_salary_electric[playerid] = 0;
    player_orders_electric[playerid] = -1;
    if(GetPVarInt(playerid, "color_wire")) 
        DeletePVar(playerid, "color_wire");
    if(GetPVarInt(playerid, "stage_dialog_wire"))
        DeletePVar(playerid, "stage_dialog_wire");
    return 1;
}

// ==========================================
//          ТАЙМЕРЫ
// ==========================================

forward NextStageElectric(playerid);
public NextStageElectric(playerid)
{
    ClearAnimations(playerid);
    new r = random(3);
    new wire[16];
    new text[184];
    switch(r)
    {
        case 0: wire = "Красный";
        case 1: wire = "Синий";
        case 2: wire = "Зеленый";
    }
    SetPVarInt(playerid, "color_wire", r);
    format(text, sizeof text, "В последствии изучения проблемы:\nвы поняли что неисправен %s провод", wire);
    ShowPlayerDialog
    (
        playerid, 3247, DIALOG_STYLE_MSGBOX, 
        "Электрик | Информация о щитке",
        text,
        "Далее", ""
    );
}

// ==========================================
//          ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ==========================================

stock GetPlayerLevelElectric(playerid)
{
    #if defined GetPlayerLevel
        return GetPlayerLevel(playerid);
    #else
        return 1;
    #endif
}