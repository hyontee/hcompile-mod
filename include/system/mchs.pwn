/*
в public OnVehicleSpawn(vehicleid) рядом с похожими 
    
        case VEHICLE_ACTION_TYPE_RENT_MCHS:
        {
            DestroyVehicle(vehicleid);
        }
*/

/*
в enum // типы авто
добавить в конец
VEHICLE_ACTION_TYPE_RENT_MCHS,
*/

#define     MAX_FIRE                81

#define     SCM                     SendClientMessage
#define     SC                      "{ffff00}| {ffffff}"
#define     USC                     "{ff2400}| {ffffff}"

#define     STATE_ORDER_NO_TAKE     1
#define     STATE_ORDER_TAKE        2
#define     STATE_ORDER_COMPLETED   3
#define     STATE_ORDER_N_COMPLETED 4

#define DIALOG_CANCEL_MCHS         3511

// --------------------------------------------------------------------
// Это координаты базы МЧС для рассчета зарплаты
// --------------------------------------------------------------------
#define MCHS_BASE_X -2571.936035
#define MCHS_BASE_Y -294.636718
#define MCHS_BASE_Z  31.339485

// --------------------------------------------------------------------
// Типы автомобилей (добавлено для исправления ошибок)
// --------------------------------------------------------------------
#define VEHICLE_ACTION_TYPE_MCHS        50  // Автомобили в интерьере МЧС
#define VEHICLE_ACTION_TYPE_RENT_MCHS   51  // Арендованные автомобили МЧС

// --------------------------------------------------------------------
// Общие буферы
// --------------------------------------------------------------------
new String128m[128];
new mString512[512];

new TimerFire[MAX_PLAYERS];
new TimerFireDamage[MAX_PLAYERS];

// --------------------------------------------------------------------
// Пикапы/сферы/маркеры
// --------------------------------------------------------------------
new exit_mchs, enter_mchs, work_mchs, invent_mchs;

// --------------------------------------------------------------------
// Состояния игроков
// --------------------------------------------------------------------
new player_order[MAX_PLAYERS];          // id заказа
new player_veh_mchs[MAX_PLAYERS];       // id выданного транспорта
new bool:player_mchs_active[MAX_PLAYERS];
new bool:press_fire[MAX_PLAYERS];
new bool:player_first_shift[MAX_PLAYERS]; // флаг первого входа в смену

// --------------------------------------------------------------------
// Текстдравы горения игрока
// --------------------------------------------------------------------
new PlayerText:fire_PTD[MAX_PLAYERS];
new Text:fire_TD;

new fire_bg[MAX_PLAYERS];
new fire_anim_timer[MAX_PLAYERS];

// --------------------------------------------------------------------
// Автомобили в интерьере
// --------------------------------------------------------------------
new mchs_inter_vehicle[3];

// --------------------------------------------------------------------
// Огонь (объекты и зоны)
// --------------------------------------------------------------------
new fire_sphere[MAX_FIRE];           // зона тушения (3.8)
new fire_object[MAX_FIRE];           // объект "огонь"
new fire_damage_sphere[MAX_FIRE];    // зона урона (1.5)

// --------------------------------------------------------------------
// Для инвентарной МЧС
// --------------------------------------------------------------------
new bool:player_mchs_armour_cd[MAX_PLAYERS]; // флаг восстановления брони
new TimerMchsArmour[MAX_PLAYERS];            // таймер восстановления

// --------------------------------------------------------------------
// Структуры
// --------------------------------------------------------------------
enum FIRE_STRUCT
{
    F_ID,           // ID FIRE
    Float:F_X,      // X
    Float:F_Y,      // Y
    Float:F_Z,      // Z
    F_ID_Z,         // ID заказа (1..10)
    F_SCORE         // Прогресс (0..10) / -1 потушен
}
enum STRUCT_ORDER_MCHS
{
    MS_IDp,         // playerid, взявший заказ (не аккаунт id)
    MS_State        // STATE_*
}
new order_mchs[10][STRUCT_ORDER_MCHS];

// --------------------------------------------------------------------
// Точки заказов
// --------------------------------------------------------------------
new Float:coord_order[10][3] =
{
    {296.527496,1898.282714,12.099133},
    {-2258.646484,-1115.430419,47.816703},
    {-2365.940917,2569.989990,41.919464},
    {387.455474,1877.942138,10.335917},
    {2543.734375,397.923248,30.621963},
    {1824.506835,705.062805,14.910859},
    {2224.401123,-223.295562,2.491437},
    {2417.199218,-2104.353515,21.976562},
    {2770.004638,-2489.099121,21.671724},
    {1701.338012,2535.687744,15.661165}
};

// Координаты авто в интерьере
new Float:veh_coords_mchs[3][4] = {
    {-2618.205810, -276.231170, 1246.683105, 0.0},
    {-2626.006835, -276.076660, 1246.683105, 0.0},
    {-2633.626464, -276.768371, 1246.683105, 0.0}
};

// координаты выезда из МЧС
new Float:spawn_coords[3][4] = {
    {-2553.254882, -296.120941, 27.252847, 280.0},
    {-2552.659667, -301.350921, 27.252847, 280.0},
    {-2552.169189, -306.443786, 27.260507, 280.0}
};

// --------------------------------------------------------------------
// База всех очагов
// --------------------------------------------------------------------
new Float:all_fire[MAX_FIRE][FIRE_STRUCT] =
{
    {0, 0.0, 0.0, 0.0, 0, 10},
    {1, 296.527496,1898.282714,12.099133,   1, 0},
    {2, 287.150451,1897.891967,12.107488,   1, 0},
    {3, 299.703460,1889.404785,12.161455,   1, 0},
    {4, 308.130676,1901.933959,12.074846,   1, 0},
    {5, 308.673797,1894.766845,12.146845,   1, 0},
    {6, 305.295654,1884.358154,12.203125,   1, 0},
    {7, 287.741882,1885.584350,12.189496,   1, 0},
    {8, 281.275207,1895.371826,12.131278,   1, 0},
    {9, -2264.829833,-1110.535156,47.711894,   2, 0},
    {10, -2264.829833,-1110.535156,47.711894,   2, 0},
    {11, -2260.946777,-1104.783569,48.124774,   2, 0},
    {12, -2260.316406,-1099.853271,48.168872,   2, 0},
    {13, -2255.228271,-1101.148925,48.203521,   2, 0},
    {14, -2252.199462,-1106.071411,48.194992,   2, 0},
    {15, -2246.708251,-1110.401000,48.216037,   2, 0},
    {16, -2247.292724,-1114.759277,48.069347,   2, 0},
    {17, -2362.677001,2565.405029,41.897556,   3, 0},
    {18, -2359.813964,2566.807617,41.919990,   3, 0},
    {19, -2357.175781,2572.038085,41.647781,   3, 0},
    {20, -2353.051025,2568.935791,41.650463,   3, 0},
    {21, -2351.055664,2563.098388,41.876743,   3, 0},
    {22, -2353.513916,2558.136718,41.939636,   3, 0},
    {23, -2346.276123,2553.455078,41.567752,   3, 0},
    {24, -2353.776123,2547.344726,41.889331,   3, 0},
    {25, 385.210235,1876.408325,10.591158,   4, 0},
    {26, 382.728881,1879.659790,10.969162,   4, 0},
    {27, 386.901367,1885.191284,10.522723,   4, 0},
    {28, 378.082336,1887.075195,11.700300,   4, 0},
    {29, 376.377197,1869.499633,11.552527,   4, 0},
    {30, 380.473419,1866.827514,11.024223,   4, 0},
    {31, 379.309631,1861.054809,11.102409,   4, 0},
    {32, 374.755371,1861.072631,11.636733,   4, 0},
    {33, 2550.495605,403.438140,28.995994,   5, 0},
    {34, 2552.929687,409.582885,26.708543,   5, 0},
    {35, 2550.058105,414.792572,25.602706,   5, 0},
    {36, 2544.914794,416.106872,25.553398,   5, 0},
    {37, 2539.236328,412.607543,26.534297,   5, 0},
    {38, 2529.128906,409.210479,28.130754,   5, 0},
    {39, 2533.128662,420.413909,25.777967,   5, 0},
    {40, 2543.224121,420.316284,25.090774,   5, 0},
    {41, 1819.207275,706.325195,14.928386,   6, 0},
    {42, 1812.996215,704.661621,15.077613,   6, 0},
    {43, 1811.236938,699.815551,15.048868,   6, 0},
    {44, 1804.111450,695.152648,14.817768,   6, 0},
    {45, 1808.579833,688.292419,14.395690,   6, 0},
    {46, 1820.534301,690.473571,14.331215,   6, 0},
    {47, 1824.118896,694.789855,14.511970,   6, 0},
    {48, 1821.996582,685.015502,14.166062,   6, 0},
    {49, 2222.886230,-226.391784,2.484841,   7, 0},
    {50, 2226.503906,-228.676376,2.491437,   7, 0},
    {51, 2230.528076,-233.092758,2.972958,   7, 0},
    {52, 2231.772705,-237.435180,3.326279,   7, 0},
    {53, 2224.223876,-238.367065,2.475771,   7, 0},
    {54, 2219.859863,-236.204055,2.441738,   7, 0},
    {55, 2221.118652,-244.523620,2.396505,   7, 0},
    {56, 2238.254150,-235.821960,2.513052,   7, 0},
    {57, 2431.572265,-2115.169921,21.778125,   8, 0},
    {58, 2428.911132,-2116.033691,21.976043,   8, 0},
    {59, 2420.474609,-2099.238281,21.984371,   8, 0},
    {60, 2424.272216,-2098.486083,21.968750,   8, 0},
    {61, 2424.424072,-2101.433837,21.976562,   8, 0},
    {62, 2419.159912,-2113.688964,21.977762,   8, 0},
    {63, 2421.660888,-2118.918212,21.968750,   8, 0},
    {64, 2418.361572,-2119.936035,21.968750,   8, 0},
    {65, 2772.707763,-2492.270019,21.790222,   9, 0},
    {66, 2768.835449,-2494.677978,21.821174,   9, 0},
    {67, 2773.885253,-2499.070312,21.871408,   9, 0},
    {68, 2776.607666,-2495.907714,21.831602,   9, 0},
    {69, 2766.460205,-2502.332763,21.875295,   9, 0},
    {70, 2763.528564,-2498.260498,21.864973,   9, 0},
    {71, 2771.390380,-2503.564208,21.873313,   9, 0},
    {72, 2767.151611,-2509.623046,21.874898,   9, 0},
    {73, 1700.797241,2531.345703,15.571876,   10, 0},
    {74, 1702.867431,2527.150634,15.442232,   10, 0},
    {75, 1706.938476,2525.129638,15.423177,   10, 0},
    {76, 1712.064697,2526.882568,15.429267,   10, 0},
    {77, 1713.981445,2532.720214,15.460651,   10, 0},
    {78, 1706.634643,2529.126464,15.445849,   10, 0},
    {79, 1699.315429,2528.131835,15.539705,   10, 0},
    {80, 1697.395019,2530.831787,15.645612,   10, 0}
};

// Создание экрана огня
stock CreateFireScreen(playerid)
{
    fire_PTD[playerid] = CreatePlayerTextDraw(playerid, -10.8332, 0.0666, "_"); // пусто
    PlayerTextDrawLetterSize(playerid, fire_PTD[playerid], 3.9287, 51.2533);
    PlayerTextDrawTextSize(playerid, fire_PTD[playerid], 654.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, fire_PTD[playerid], 1);
    PlayerTextDrawColor(playerid, fire_PTD[playerid], -1);
    PlayerTextDrawUseBox(playerid, fire_PTD[playerid], 1);
    PlayerTextDrawBoxColor(playerid, fire_PTD[playerid], -16777166);
    PlayerTextDrawSetOutline(playerid, fire_PTD[playerid], 10);
    PlayerTextDrawBackgroundColor(playerid, fire_PTD[playerid], 10);
    PlayerTextDrawFont(playerid, fire_PTD[playerid], 1);
    PlayerTextDrawSetProportional(playerid, fire_PTD[playerid], 1);
    PlayerTextDrawSetShadow(playerid, fire_PTD[playerid], 0);

    // Стартовые параметры анимации
    fire_bg[playerid] = 10;
}

// Показ с пульсацией
stock ShowFireScreen(playerid)
{
    PlayerTextDrawShow(playerid, fire_PTD[playerid]);
    SendPlayerHudFoneFire(playerid, 1);
    if(fire_anim_timer[playerid]) KillTimer(fire_anim_timer[playerid]);
    fire_anim_timer[playerid] = SetTimerEx("AnimateFireScreen", 100, true, "i", playerid);
}

// Полное скрытие
stock HideFireScreen(playerid)
{
    PlayerTextDrawHide(playerid, fire_PTD[playerid]);
    SendPlayerHudFoneFire(playerid, 0);
    if(fire_anim_timer[playerid]) { KillTimer(fire_anim_timer[playerid]); fire_anim_timer[playerid] = 0; }
}

forward AnimateFireScreen(playerid);
public AnimateFireScreen(playerid)
{
    PlayerTextDrawHide(playerid, fire_PTD[playerid]);

    if(fire_bg[playerid] < 10) 
    {
        fire_bg[playerid] = 10;
        PlayerTextDrawBackgroundColor(playerid, fire_PTD[playerid], fire_bg[playerid]);
        PlayerTextDrawShow(playerid, fire_PTD[playerid]);
        return 1;
    }
    if(fire_bg[playerid] >= 10 || fire_bg[playerid] != 70)
    {
        fire_bg[playerid] += 10;
        PlayerTextDrawBackgroundColor(playerid, fire_PTD[playerid], fire_bg[playerid]);
        PlayerTextDrawShow(playerid, fire_PTD[playerid]);
        return 1;
    }
    if(fire_bg[playerid] >= 70)
    {
        fire_bg[playerid] = 10;
        PlayerTextDrawBackgroundColor(playerid, fire_PTD[playerid], fire_bg[playerid]);
        PlayerTextDrawShow(playerid, fire_PTD[playerid]);
        return 1;
    }
    return 1;
}

public OnGameModeInit()
{
    print("[WERTON_MCHS] Система огня и работа МЧС загружена");

    for(new i = 0; i < MAX_FIRE; i++)
    {
        fire_object[i] = 0;
        fire_sphere[i] = 0;
        fire_damage_sphere[i] = 0;
    }
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        player_order[p] = -1;
        player_veh_mchs[p] = 0;
        player_mchs_active[p] = false;
        player_first_shift[p] = false;
        press_fire[p] = false;
        TimerFire[p] = 0;
        TimerFireDamage[p] = 0;
    }

    SetTimer("LoadMchs",         6000, false);
    SetTimer("LoadOrdersMchs",   5000, false);
    SetTimer("TimerMchs",    60000*5, true);

    #if defined mchs_OnGameModeInit
        return mchs_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit mchs_OnGameModeInit
#if defined mchs_OnGameModeInit
    forward mchs_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    player_order[playerid] = -1;
    player_veh_mchs[playerid] = 0;
    player_mchs_active[playerid] = false;
    player_first_shift[playerid] = false;
    press_fire[playerid] = false;
    TimerFire[playerid] = 0;
    TimerFireDamage[playerid] = 0;

    #if defined mchs_OnPlayerConnect
        return mchs_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect mchs_OnPlayerConnect
#if defined mchs_OnPlayerConnect
    forward mchs_OnPlayerConnect(playerid);
#endif

forward LoadMchs();
public LoadMchs()
{
    exit_mchs = CreatePickup(1318, 23, -2600.141113, -283.324401, 1246.680419);

    enter_mchs = CreatePickup(1318, 23, -2558.123535, -284.654937, 27.354429);
    CreateDynamic3DTextLabel("{ffff00}Вход в здание МЧС\n\n{ffffff}Подойдите чтобы{ffff00} войти.", 0xFFBB00FF, -2558.123535, -284.654937, 27.354429, 5.0);

    work_mchs = CreatePickup(1275, 23, -2615.917724, -282.265045, 1252.043823);
    CreateDynamic3DTextLabel("{ffff00}Гардероб МЧС\n\n{ffffff}Подойдите для{ffff00} взаимодействия.", 0xFFBB00FF, -2615.917724, -282.265045, 1252.043823, 5.0);

    invent_mchs = CreateDynamicSphere(-2608.042480, -282.297698, 1252.043823, 2.0);
    CreateDynamic3DTextLabel("{ffff00}Склад МЧС\n\n{ffffff}Подойдите чтобы взять огнетушитель.", 0xFFEE00FF, -2608.042480, -282.297698, 1252.043823, 5.0);

    mchs_inter_vehicle[0] = CreateVehicle(407, -2618.205810, -276.231170, 1246.683105, 0.0, 17, 0, -1, 0, VEHICLE_ACTION_TYPE_MCHS);
    mchs_inter_vehicle[1] = CreateVehicle(407, -2626.006835, -276.076660, 1246.683105, 0.0, 17, 0, -1, 0, VEHICLE_ACTION_TYPE_MCHS);
    mchs_inter_vehicle[2] = CreateVehicle(407, -2633.626464, -276.768371, 1246.683105, 0.0, 17, 0, -1, 0, VEHICLE_ACTION_TYPE_MCHS);

    LinkVehicleToInterior(mchs_inter_vehicle[0], 1);
    LinkVehicleToInterior(mchs_inter_vehicle[1], 1);
    LinkVehicleToInterior(mchs_inter_vehicle[2], 1);

    SetVehicleData(mchs_inter_vehicle[0], V_FUEL, 0);
    SetVehicleData(mchs_inter_vehicle[1], V_FUEL, 0);
    SetVehicleData(mchs_inter_vehicle[2], V_FUEL, 0);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
    {
        case VEHICLE_ACTION_TYPE_MCHS:
        {
            LinkVehicleToInterior(vehicleid, 1);
            SetVehicleVirtualWorld(vehicleid, 0);
            return 1;
        }
    }

    #if defined mchs_OnVehicleSpawn
        return mchs_OnVehicleSpawn(vehicleid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define _ALS_OnVehicleSpawn
#endif
#define OnVehicleSpawn mchs_OnVehicleSpawn
#if defined mchs_OnVehicleSpawn
    forward mchs_OnVehicleSpawn(vehicleid);
#endif

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(pickupid == exit_mchs)
    {
        SetPlayerPosEx(playerid, -2556.406005, -284.757751, 27.354429, 275.161071, 0, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    if(pickupid == enter_mchs)
    {
        SetPlayerPos(playerid, -2600.153564, -281.323333, 1246.680419);
        SetPlayerFacingAngle(playerid, 5.0);
        SetCameraBehindPlayer(playerid);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 1);
        SCM(playerid, -1, ""SC"Для{ffff00} устройства{ffffff} или{ffff00} начала рабочего дня{ffffff} - отправляйтесь в гардероб расположенный на{ffff00} 2-м этаже.");
        SCM(playerid, -1, ""SC"Для более подробной информации по МЧС, отправляйтесь в{ffff00} учебный класс{ffffff} находящийся на{ffff00} 2-м этаже.");
    }
    if(pickupid == work_mchs)
    {
        Dialog(
            playerid, 3501, DIALOG_STYLE_LIST,
            "{FF6347}"SERVER_NAME" {FFFFFF}| МЧС",
            "{EB4C42} #1. {FFFFFF}Начать/закончить рабочий день\n"\
            "{EB4C42} #2. {FFFFFF}Информация",
            "Выбрать", "Отмена"
        );
    }

    #if defined mchs_OnPlayerPickUpPickupEx
        return mchs_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx mchs_OnPlayerPickUpPickupEx
#if defined mchs_OnPlayerPickUpPickupEx
    forward mchs_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    new vehicle_type_mchs = GetVehicleData(vehicleid, V_ACTION_TYPE);

    switch(vehicle_type_mchs)
	{
        case VEHICLE_ACTION_TYPE_MCHS:
        {
            if(!player_mchs_active[playerid])
            {
                SCM(playerid, -1, ""USC"Сначала начните смену в гардеробе!");
                RemovePlayerFromVehicle(playerid);
                return 1;
            }

            new rand = random(3);
            new newveh = CreateVehicle(
                407,
                spawn_coords[rand][0], spawn_coords[rand][1], spawn_coords[rand][2],
                spawn_coords[rand][3],
                   17, 0, -1, 0, VEHICLE_ACTION_TYPE_RENT_MCHS
            );

            SetPlayerInterior(playerid, 0);
            PutPlayerInVehicle(playerid, newveh, 0);
            SCM(playerid, -1, ""SC"Вы успешно арендовали транспорт МЧС");
            SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
            
            player_veh_mchs[playerid] = newveh;
            return 1;
        }
    }

    #if defined mchs_OnPlayerEnterVehicle
        return mchs_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerEnterVehicle
    #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle mchs_OnPlayerEnterVehicle
#if defined mchs_OnPlayerEnterVehicle
    forward mchs_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(TimerFire[playerid]) { KillTimer(TimerFire[playerid]); TimerFire[playerid] = 0; }
    if(TimerFireDamage[playerid]) { KillTimer(TimerFireDamage[playerid]); TimerFireDamage[playerid] = 0; }

    if(player_order[playerid] != -1)
    {
        new id = player_order[playerid];
        order_mchs[id][MS_State] = STATE_ORDER_N_COMPLETED;
        endOrders(id);

        if(player_veh_mchs[playerid] != 0)
        {
            DestroyVehicle(player_veh_mchs[playerid]);
            player_veh_mchs[playerid] = 0;
        }

        mysql_format(mysql, String128m, sizeof String128m,
            "DELETE FROM order_mchs WHERE id = %d AND id_player = %d",
            id, GetPlayerAccountID(playerid));
        mysql_query(mysql, String128m, false);
        if(mysql_errno()) print("Ошибка в запросе 6");

        player_order[playerid] = -1;
    }

    #if defined mchs_OnPlayerDisconnect
        return mchs_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect mchs_OnPlayerDisconnect
#if defined mchs_OnPlayerDisconnect
    forward mchs_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < MAX_FIRE; i++)
    {
        if(areaid == fire_damage_sphere[i] && all_fire[i][F_SCORE] != -1)
        {
            if(!TimerFireDamage[playerid])
            {
                TimerFireDamage[playerid] = SetTimerEx("DamageFromFire", 1000, true, "i", playerid);
                if(!fire_PTD[playerid]) CreateFireScreen(playerid);
                ShowFireScreen(playerid);
            }
            break;
        }
    }
    if(areaid == invent_mchs)
    {
        if(!player_mchs_active[playerid]) 
            return SCM(playerid, -1, ""USC" Сначала начните смену");

        new exting_ammo = GetPlayerAmmo(playerid);
        new Float:armor;
        GetPlayerArmour(playerid, armor);

        new dialog_str[256];
        format(dialog_str, sizeof(dialog_str),
            "{EB4C42} #1. {FFFFFF}Огнетушитель \t\t %d/15000\n"\
            "{EB4C42} #2. {FFFFFF}Восстановить костюм \t%.1f/100.0",
            exting_ammo, armor
        );

        Dialog(
            playerid, 3502, DIALOG_STYLE_LIST,
            "{FF6347}"SERVER_NAME" {FFFFFF}| Инвентарная МЧС",
            dialog_str,
            "Выбрать", "Отмена"
        );
    }

    #if defined mchs_OnPlayerEnterDynamicArea
        return mchs_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea mchs_OnPlayerEnterDynamicArea
#if defined mchs_OnPlayerEnterDynamicArea
    forward mchs_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for(new i = 0; i < MAX_FIRE; i++)
    {
        if(areaid == fire_damage_sphere[i])
        {
            if(TimerFireDamage[playerid])
            {
                KillTimer(TimerFireDamage[playerid]);
                TimerFireDamage[playerid] = 0;
                HideFireScreen(playerid);
            }
            break;
        }
    }

    #if defined mchs_OnPlayerLeaveDynamicArea
        return mchs_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea
#else
    #define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea mchs_OnPlayerLeaveDynamicArea
#if defined mchs_OnPlayerLeaveDynamicArea
    forward mchs_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public DamageFromFire(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(player_mchs_active[playerid])
    {
        new Float:armour;
        GetPlayerArmour(playerid, armour);

        if(armour > 0.0)
        {
            new Float:new_armour = armour - 5.0;
            if(new_armour < 0.0) new_armour = 0.0;
            SetPlayerArmour(playerid, new_armour);
        }
        else
        {
            new Float:hp;
            GetPlayerHealth(playerid, hp);
            SetPlayerHealth(playerid, hp - 10.0);
        }
    }
    else
    {
        new Float:hp;
        GetPlayerHealth(playerid, hp);
        SetPlayerHealth(playerid, hp - 10.0);
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 3500)
    {
        if(response)
        {
            new id = GetPlayerListitemValue(playerid, listitem);

            if(id < 0 || id > 9) return 1;
            if(order_mchs[id][MS_State] != STATE_ORDER_NO_TAKE) 
            {
                SCM(playerid, -1, ""USC"Этот заказ уже кто-то взял!");
                return 1;
            }

            EnablePlayerGPS(playerid, 55, coord_order[id][0], coord_order[id][1], coord_order[id][2], "Местоположение заказа отмечено на карте!");

            player_order[playerid] = id;
            order_mchs[id][MS_IDp] = playerid;
            order_mchs[id][MS_State] = STATE_ORDER_TAKE;

            mysql_format(mysql, String128m, sizeof String128m,
                "UPDATE order_mchs SET id_player = %d, state = %d WHERE id = %d",
                GetPlayerAccountID(playerid), STATE_ORDER_TAKE, id);
            mysql_query(mysql, String128m, false);
            
            LoadFireOrder(id + 1);
            SCM(playerid, -1, ""SC"Вы взяли заказ #" #id ". Следуйте на точку!");
        }
    }
    if(dialogid == 3501)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    new sex = bool:GetPlayerSex(playerid);

                    if(player_mchs_active[playerid])
                    {
                        player_mchs_active[playerid] = false;
                        SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
                        EndMchsShift(playerid);

                        if(player_order[playerid] != -1)
                        {
                            endOrders(player_order[playerid]);
                            order_mchs[player_order[playerid]][MS_State] = STATE_ORDER_N_COMPLETED;
                            player_order[playerid] = -1;
                        }
                        
                        if(player_veh_mchs[playerid] != 0)
                        {
                            DestroyVehicle(player_veh_mchs[playerid]);
                            player_veh_mchs[playerid] = 0;
                        }
                        
                        SCM(playerid, -1, ""SC"Вы завершили рабочую смену.");
                    }
                    else
                    {
                        player_mchs_active[playerid] = true;
                        player_order[playerid] = -1;
                        StartMchsShift(playerid);
                        
                        if(sex == false) SetPlayerSkin(playerid, 19276);
                        else SetPlayerSkin(playerid, 19901);
                        
                        SCM(playerid, -1, ""SC"Вы начали рабочую смену. Используйте {ffff00}/meslist {ffffff}для просмотра заказов!");
                        SCM(playerid, -1, ""SC"Не забудьте взять огнетушитель на складе и арендовать транспорт!");
                    }
                }
                case 1:
                {
                    Dialog(
                        playerid, -1, DIALOG_STYLE_MSGBOX,
                        "Информация о работе в МЧС",
                        "{FFFFFF}Инструкция по работе в МЧС:\n\n"\
                        "{EB4C42}1. {FFFFFF}Начните смену в гардеробе\n"\
                        "{EB4C42}2. {FFFFFF}Возьмите огнетушитель на складе\n"\
                        "{EB4C42}3. {FFFFFF}Арендуйте транспорт (сядьте в авто на 1-м этаже)\n"\
                        "{EB4C42}4. {FFFFFF}Возьмите заказ через {ffff00}/meslist\n"\
                        "{EB4C42}5. {FFFFFF}Тушите огонь, удерживая ЛКМ\n"\
                        "{EB4C42}6. {FFFFFF}За полностью потушенный заказ - зарплата",
                        "Понятно", ""
                    );
                }
            }
        }
    }
    if(dialogid == 3502 && response)
    {
        switch(listitem)
        {
            case 0:
            {
                new weapon, ammo;
                new found_extinguisher = 0;
                for(new i = 0; i < 13; i++)
                {
                    GetPlayerWeaponData(playerid, i, weapon, ammo);
                    
                    if(weapon == 42)
                    {
                        found_extinguisher = 1;
                        if(ammo >= 15000) return SCM(playerid, -1, ""SC"У вас уже максимальное количество патронов в огнетушителе!");
                        GivePlayerWeapon(playerid, 42, 5000);
                        SCM(playerid, -1, ""SC"Вы взяли огнетушитель. Боезапас восполнен!");
                        return 1;
                    }
                }
                if(found_extinguisher == 0)
                {
                    GivePlayerWeapon(playerid, 42, 5000);
                    SCM(playerid, -1, ""SC"Вы взяли огнетушитель. Боезапас восполнен!");
                }
            }
            case 1:
            {
                new Float:armour;
                GetPlayerArmour(playerid, armour);

                if(armour >= 80) return SCM(playerid, -1, ""SC"Ваш костюм еще целый.");

                if(player_mchs_armour_cd[playerid]) return SCM(playerid, -1, ""SC"Вы недавно восстанавливали костюм! Подождите 5 минут.");

                SetPlayerArmour(playerid, 100.0);
                SCM(playerid, -1, ""SC"Вы восстановили костюм МЧС!");
                player_mchs_armour_cd[playerid] = true;
                if(TimerMchsArmour[playerid]) KillTimer(TimerMchsArmour[playerid]);
                TimerMchsArmour[playerid] = SetTimerEx("ResetMchsArmourCD", 300000, false, "i", playerid);
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_CANCEL_MCHS)
    {
        if(response)
        {
            new id = player_order[playerid];
            if(id >= 20) return player_order[playerid] = -1;
            if(id != -1)
            {
                endOrders(id);
                order_mchs[id][MS_State] = STATE_ORDER_NO_TAKE;
                order_mchs[id][MS_IDp] = -1;

                mysql_format(mysql, String128m, sizeof String128m, 
                    "UPDATE order_mchs SET id_player = 0, state = %d WHERE id = %d", 
                    STATE_ORDER_NO_TAKE, id);
                mysql_query(mysql, String128m, false);

                player_order[playerid] = -1;
                SCM(playerid, -1, ""USC"Заказ отменён. Оплата не начислена.");
            }
        }
    }

    #if defined mchs_OnDialogResponse
        return mchs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse mchs_OnDialogResponse
#if defined mchs_OnDialogResponse
    forward mchs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_FIRE))
    {
        if(GetPlayerWeapon(playerid) == 42 && IsPlayerInRangeOfAnyFire(playerid) >= 1)
        {
            if(!TimerFire[playerid])
                TimerFire[playerid] = SetTimerEx("HandleFirePress", 1000, true, "i", playerid);
        }
    }
    else if((oldkeys & KEY_FIRE))
    {
        if(TimerFire[playerid])
        {
            KillTimer(TimerFire[playerid]);
            TimerFire[playerid] = 0;
        }
    }

    #if defined mchs_OnPlayerKeyStateChange
        return mchs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange mchs_OnPlayerKeyStateChange
#if defined mchs_OnPlayerKeyStateChange
    forward mchs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public HandleFirePress(playerid)
{
    if(GetPlayerWeapon(playerid) != 42) return 1;

    new idx = IsPlayerInRangeOfAnyFire(playerid);
    if(idx < 1) return 1;

    new id = player_order[playerid];
    if(id == -1) return 1;

    if(all_fire[idx][F_ID_Z] != id + 1) return 1;
    if(all_fire[idx][F_SCORE] == -1) return 1;

    if(all_fire[idx][F_SCORE] < 10)
    {
        all_fire[idx][F_SCORE]++;
        new text[34];
        format(text, sizeof text, "~y~Прогресс: ~w~%d/10", all_fire[idx][F_SCORE]);
        GameTextForPlayer(playerid, text, 3000, 5);
    }

    if(all_fire[idx][F_SCORE] >= 10)
    {
        all_fire[idx][F_SCORE] = -1;

        if(fire_object[idx]) { DestroyObject(fire_object[idx]); fire_object[idx] = 0; }
        if(fire_sphere[idx]) { DestroyDynamicArea(fire_sphere[idx]); fire_sphere[idx] = 0; }
        if(fire_damage_sphere[idx]) { DestroyDynamicArea(fire_damage_sphere[idx]); fire_damage_sphere[idx] = 0; }

        SCM(playerid, -1, ""SC"Вы потушили огонь!");

        if(TimerFire[playerid])
        {
            KillTimer(TimerFire[playerid]);
            TimerFire[playerid] = 0;
        }

        if(Order(id + 1))
        {
            SCM(playerid, -1, ""SC"Вы полностью{ffff00} выполнили заказ!{ffffff} Можете взять новый через {ffff00}/meslist");

            endOrders(id);
            player_order[playerid] = -1;
            order_mchs[id][MS_State] = STATE_ORDER_COMPLETED;

            mysql_format(mysql, String128m, sizeof String128m, 
                "UPDATE order_mchs SET state = %d WHERE id = %d", 
                STATE_ORDER_COMPLETED, id);
            mysql_query(mysql, String128m, false);

            new Float:px, Float:py, Float:pz;
            GetPlayerPos(playerid, px, py, pz);

            new Float:dist = floatsqroot(
                floatpower(px - MCHS_BASE_X, 2.0) +
                floatpower(py - MCHS_BASE_Y, 2.0) +
                floatpower(pz - MCHS_BASE_Z, 2.0)
            );

            new money = floatround(10000 + dist * 2.0);

            if(money < 15000) money = 15000;
            if(money > 35000) money = 35000;

            money = money + 910000;

            GivePlayerMoneyEx(playerid, money);

            format(String128m, sizeof String128m, ""SC"Вы получили зарплату {FFFF00}%d рублей{ffffff} за потушенный пожар (расстояние: %.1f м)", money, dist);
            SCM(playerid, -1, String128m);
        }
    }
    return 1;
}

stock LoadFireOrder(id)
{
    if(id < 1 || id > 10) return 0;

    order_mchs[id - 1][MS_State] = STATE_ORDER_TAKE;

    for(new i = 0; i < MAX_FIRE; i++)
    {
        if(all_fire[i][F_ID_Z] != id) continue;

        if(!fire_object[i])
            fire_object[i] = CreateObject(18691, all_fire[i][F_X], all_fire[i][F_Y], all_fire[i][F_Z] - 2.0, 0.0, 0.0, 0.0, 10.0);

        if(!fire_sphere[i])
            fire_sphere[i] = CreateDynamicSphere(all_fire[i][F_X], all_fire[i][F_Y], all_fire[i][F_Z], 3.8);

        if(!fire_damage_sphere[i])
            fire_damage_sphere[i] = CreateDynamicSphere(all_fire[i][F_X], all_fire[i][F_Y], all_fire[i][F_Z], 1.5);

        if(all_fire[i][F_SCORE] == -1) all_fire[i][F_SCORE] = 0;
    }
    printf("[MCHS] Заказ %d загружен", id);
    return 1;
}

public LoadOrdersMchs()
{
    print("[MCHS] Загрузка заказов МЧС...");
    
    mysql_format(mysql, String128m, sizeof String128m, "DELETE FROM order_mchs");
    mysql_query(mysql, String128m, false);
    
    if(mysql_errno()) 
    {
        print("Ошибка в запросе 5");
        return 1;
    }

    new orders_count = 3 + random(3);
    new bool:used_ids[10] = {false, ...};
    
    for(new i = 0; i < orders_count; i++)
    {
        new order_id = random(10);
        
        while(used_ids[order_id])
        {
            order_id++;
            if(order_id >= 10) order_id = 0;
        }
        
        if(!used_ids[order_id])
        {
            used_ids[order_id] = true;
            LoadOrderInMesList(order_id);
        }
    }
    
    printf("[MCHS] Загружено %d заказов", orders_count);
    return 1;
}

stock LoadOrderInMesList(id)
{
    if(id < 0 || id > 9) 
    {
        printf("[ERROR] LoadOrderInMesList: неверный ID %d", id);
        return 0;
    }

    order_mchs[id][MS_State] = STATE_ORDER_NO_TAKE;
    order_mchs[id][MS_IDp] = -1;

    mysql_format(mysql, String128m, sizeof String128m,
        "INSERT INTO order_mchs (id, id_player, state) VALUES (%d, 0, %d)",
        id, STATE_ORDER_NO_TAKE);
    mysql_query(mysql, String128m, false);
    
    if(mysql_errno()) 
    {
        printf("Ошибка в запросе 3 для ID %d", id);
        return 0;
    }
    
    printf("[MCHS] Заказ %d загружен в список", id);
    return 1;
}

stock IsPlayerInRangeOfAnyFire(playerid)
{
    for(new idx = 1; idx < MAX_FIRE; idx++)
    {
        if(fire_sphere[idx] && IsPlayerInDynamicArea(playerid, fire_sphere[idx]))
            return idx;
    }
    return 0;
}

public PressedFire(playerid) return OnPlayerKeyStateChange(playerid, KEY_FIRE, 0);

stock Order(id)
{
    if(id < 1 || id > 10) return 0;

    new fire_c = 0;
    for(new i = 0; i < MAX_FIRE; i++)
    {
        if(all_fire[i][F_ID_Z] != id) continue;
        if(all_fire[i][F_SCORE] == -1) fire_c++;
    }
    return (fire_c == 8);
}

stock endOrders(id)
{
    if(id < 0 || id > 9) return 0;

    for(new i = 0; i < MAX_FIRE; i++)
    {
        if(all_fire[i][F_ID_Z] != (id + 1)) continue;

        if(all_fire[i][F_SCORE] != -1)
        {
            if(fire_object[i]) { DestroyObject(fire_object[i]); fire_object[i] = 0; }
            if(fire_sphere[i]) { DestroyDynamicArea(fire_sphere[i]); fire_sphere[i] = 0; }
            if(fire_damage_sphere[i]) { DestroyDynamicArea(fire_damage_sphere[i]); fire_damage_sphere[i] = 0; }
        }
        all_fire[i][F_SCORE] = 0;
    }
    return 1;
}

public TimerMchs()
{
    print("[MCHS] Проверка и обновление заказов...");
    
    for(new z = 0; z < sizeof(order_mchs); z++)
    {
        if(order_mchs[z][MS_State] == STATE_ORDER_TAKE) continue;
        if(order_mchs[z][MS_State] == STATE_ORDER_NO_TAKE) continue;
        
        order_mchs[z][MS_State] = STATE_ORDER_NO_TAKE;
        order_mchs[z][MS_IDp] = -1;

        mysql_format(mysql, String128m, sizeof String128m,
            "INSERT INTO order_mchs (id, id_player, state) VALUES (%d, 0, %d)",
            z, STATE_ORDER_NO_TAKE);
        mysql_query(mysql, String128m, false);
        
        if(mysql_errno()) 
        {
            printf("Ошибка в запросе 4 для ID %d", z);
        }
        else
        {
            printf("[MCHS] Создан новый заказ: %d", z);
        }
    }
    return 1;
}

stock DialogMhsc(playerid, dialogid, style, title[], text[], button[], button2[])
{
    if(style == 5) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "...", "...", "...", "");
    ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
    return 1;
}

// ИСПРАВЛЕННАЯ КОМАНДА /meslist
CMD:meslist(playerid)
{
    if(!player_mchs_active[playerid])
    {
        SCM(playerid, -1, ""USC" Сначала устройтесь в МЧС (подойдите к гардеробу на 2-м этаже)");
        return 1;
    }

    if(player_order[playerid] != -1)
    {
        format(mString512, sizeof mString512, 
            "{FFFFFF}У вас уже есть действующий заказ #%d.\n\nОтменить его?\n\n{FF6347}ВНИМАНИЕ:{FFFFFF} за невыполненный заказ оплата не начисляется.", 
            player_order[playerid] + 1);
        return Dialog(playerid, DIALOG_CANCEL_MCHS, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {FFFFFF}| МЧС", mString512, "Отменить", "Назад");
    }

    mysql_format(mysql, mString512, sizeof mString512, "SELECT * FROM order_mchs WHERE `state` = %d", STATE_ORDER_NO_TAKE);
    new Cache:result = mysql_query(mysql, mString512, true);

    if(mysql_errno())
    {
        print("Ошибка в запросе 4");
        return 1;
    }

    new rows = cache_num_rows();

    if(rows == 0)
    {
        SCM(playerid, -1, ""SC"На данный момент заказов нет. Ожидайте новые вызовы...");
        return 1;
    }

    new id, list[512], text[128];
    new Float:dista;
    list[0] = EOS;

    for(new r = 0; r < rows; r++)
    {
        id = cache_get_field_content_int(r, "id");
        
        if(id < 0 || id > 9) 
        {
            printf("[WARNING] Неверный ID заказа в БД: %d", id);
            continue;
        }

        if(order_mchs[id][MS_State] != STATE_ORDER_NO_TAKE)
        {
            continue;
        }

        dista = GetPlayerDistanceFromPoint(playerid, coord_order[id][0], coord_order[id][1], coord_order[id][2]);

        format(text, sizeof text, "{FFFFFF}Заказ #%d\t{B3B3B3}%.1f м\n", id + 1, dista);
        strcat(list, text);
        SetPlayerListitemValue(playerid, r, id);
    }

    if(strlen(list) == 0)
    {
        SCM(playerid, -1, ""SC"Нет доступных заказов в данный момент.");
        return 1;
    }

    Dialog(playerid, 3500, DIALOG_STYLE_LIST, "{FF6347}"SERVER_NAME" {FFFFFF}| Доступные заказы МЧС", list, "Взять", "Отмена");
    return 1;
}

// Отладочная команда для админов
CMD:mchstest(playerid)
{
    if(!IsPlayerAdmin(playerid)) return 1;
    
    printf("=== ОТЛАДКА МЧС ===");
    printf("player_mchs_active[%d] = %s", playerid, player_mchs_active[playerid] ? "true" : "false");
    printf("player_order[%d] = %d", playerid, player_order[playerid]);
    
    for(new i = 0; i < 10; i++)
    {
        printf("order_mchs[%d] - state: %d, player: %d", i, order_mchs[i][MS_State], order_mchs[i][MS_IDp]);
    }
    
    SCM(playerid, -1, ""SC"Отладочная информация выведена в консоль");
    return 1;
}

forward ResetMchsArmourCD(playerid);
public ResetMchsArmourCD(playerid)
{
    player_mchs_armour_cd[playerid] = false;
    return 1;
}

stock StartMchsShift(playerid)
{
    player_mchs_active[playerid] = true;
    SetPlayerArmour(playerid, 100.0);
}

stock EndMchsShift(playerid)
{
    player_mchs_active[playerid] = false;
    SetPlayerArmour(playerid, 0.0);
    ResetPlayerWeapons(playerid);
}

stock SendPlayerHudFoneFire(playerid, value)
{
    value -= 1;
    if(value > 0) return 1;

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 33); 
    BS_WriteValue(bitstream, PR_UINT8, value); 
    PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    return BS_Delete(bitstream); 
}

public CountDownFire(playerid) 
{
    press_fire[playerid] = false;
    return 1;
}