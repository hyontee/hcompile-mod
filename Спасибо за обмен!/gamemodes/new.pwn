#include <a_samp>
#include <a_mysql>
#include <float>
#include "json.inc"
#include "../include/Pawn.CMD.inc"
#include "../include/foreach.inc"
#include "../include/Pawn.RakNet.inc"
#include "../include/streamer.inc"
#include "../include/sscanf2.inc"
#pragma tabsize 0

forward DestroyVehicleTimer(playerid, seconds);

// ----- енум ----- //

enum E_AHELP_DATA
{
    aLevel,
    aShort[24],
    aFull[32],
    aDesc[96]
};

new const AHelpData[][E_AHELP_DATA] =
{
    {1, "/admins",      "/admins",      "Список администраторов в сети"},
    {1, "/a",           "/a",           "Чат администрации"},
    {1, "/pm",          "/pm",          "Личное сообщение игроку"},
    {1, "/ask",         "/ask",         "Ответить на вопрос игрока"},
    {1, "/rep",         "/rep",         "Взять жалобу игрока"},
    {1, "/sp",          "/sp",          "Проследить за игроком"},

    {2, "/goto",        "/goto",        "Телепорт к игроку"},
    {2, "/gethere",     "/gethere",     "Телепортировать игрока к себе"},
    {2, "/kick",        "/kick",        "Кикнуть игрока"},
    {2, "/mute",        "/mute",        "Выдать мут игроку"},
    {2, "/warn",        "/warn",        "Выдать предупреждение"},
    {2, "/jail",        "/jail",        "Посадить игрока в деморган"},

    {3, "/ban",         "/ban",         "Выдать бан игроку"},
    {3, "/veh",         "/veh",         "Создать транспорт"},
    {3, "/flip",        "/flip",        "Перевернуть транспорт"},
    {3, "/vget",        "/vget",        "Телепортировать транспорт"},
    {3, "/setskin",     "/setskin",     "Изменить скин игроку"},
    {3, "/spec",        "/spec",        "Начать слежку за игроком"},

    {4, "/givecash",    "/givecash",    "Выдать вирты игроку"},
    {4, "/givedonate",  "/givedonate",  "Выдать донат валюту"},
    {4, "/givegun",     "/givegun",     "Выдать оружие игроку"},
    {4, "/givecases",   "/givecases",   "Выдать кейсы игроку"},
    {4, "/sethp",       "/sethp",       "Изменить здоровье игроку"},
    {4, "/setarmour",   "/setarmour",   "Изменить броню игроку"},

    {5, "/permban",     "/permban",     "Выдать вечный бан"},
    {5, "/offban",      "/offban",      "Забанить оффлайн игрока"},
    {5, "/unban",       "/unban",       "Разбанить игрока"},
    {5, "/setnick",     "/setnick",     "Изменить ник игроку"},
    {5, "/reloadacc",   "/reloadacc",   "Перезагрузить аккаунт"},
    {5, "/setadmin",    "/setadmin",    "Выдать уровень администрации"},

    {6, "/makeleader",  "/makeleader",  "Назначить лидера"},
    {6, "/setfamily",   "/setfamily",   "Выдать семью игроку"},
    {6, "/delacc",      "/delacc",      "Удалить аккаунт"},
    {6, "/gmx",         "/gmx",         "Перезапустить сервер"},
    {6, "/respawncars", "/respawncars", "Респавн всего транспорта"},
    {6, "/slapall",     "/slapall",     "Наказать всех игроков"}
};

enum E_Calendar
{
    calID,
    calPlayerID,
    calRewardID,
    calCollected
}

#define MAX_AF_FORMS           50
#define AF_COMMAND_LEN         32
#define AF_PARAMS_LEN          256

enum E_AF_FORM
{
    afID,
    afSenderID,
    afSenderName[MAX_PLAYER_NAME],
    afCommand[AF_COMMAND_LEN],
    afParams[AF_PARAMS_LEN],
    afCreated,
    afUsed
}
new AF_Forms[MAX_AF_FORMS][E_AF_FORM];
new AF_NextID = 1;
new AF_Total = 0;

// структура диалогов
enum
{
    DIALOG_UNUSED = 0,
    DIALOG_ADMIN_REG,
    DIALOG_ADMIN_LOGIN,
    DIALOG_MY_CARS,
    DIALOG_CAR_ACTION,
    DIALOG_BUY_CAR_CONFIRM,
    DIALOG_MAP_TP,
	DIALOG_BUYHOUSE,
	DIALOG_ENTER_HOUSE,
	DIALOG_MENU_HOUSE,
	DIALOG_PROMO_MAIN,
	PROMO_PRISE,
    ENTER_PROMOCODE,
    DIALOG_CLEAR_CHAT,
};

#define DIALOG_FACTORY_JOB      2407
#define DIALOG_FACTORY_INFO     2408
#define FACTORY_JOB_SKIN        8   
#define MAX_RAW_POINTS          2     
#define MAX_CRAFT_POINTS        8 
new factory_pickup;
new bool:IsFactoryWorker[MAX_PLAYERS];
new bool:IsCrafting[MAX_PLAYERS];
new PlayerRawKg[MAX_PLAYERS];     
new PlayerProductKg[MAX_PLAYERS]; 
new Float:FactorySalary[MAX_PLAYERS];
new RawAreas[MAX_RAW_POINTS];
new CraftAreas[MAX_CRAFT_POINTS];
new DropArea;
new CalendarRewards[MAX_PLAYERS][50][E_Calendar]; // пример: 50 наград на игрока
new CalendarCount[MAX_PLAYERS];
new Float:RawPos[MAX_RAW_POINTS][3] = {
    {-1.763348,-14.060258,1381.060180},
    {-1.832186,-18.905225,1381.060180}
};

new Float:CraftPos[MAX_CRAFT_POINTS][3] = {

    {-5.911403,9.464936,1381.060180},
    {-5.915160,4.709179,1381.060180},
    {-5.863016,-0.853082,1381.060180},
    {-5.916202,-6.017959,1381.060180},
    {-12.629467,-6.176221,1381.060180},
    {-12.329383,-0.958108,1381.060180},
    {-12.335878,4.372862,1381.060180},
    {-12.332511,9.517305,1381.060180}
};

new Float:DropProductPos[3] = {-9.039176,22.822807,1381.060180};

new factory_area;

#define MAX_TRANSPORT_SPOTS 20

enum t_spot
{
    Float:tPickupX,
    Float:tPickupY,
    Float:tPickupZ,
    Float:tSpawnX,
    Float:tSpawnY,
    Float:tSpawnZ,
    Float:tSpawnAngle,
    tPickup,
    tLabel,
    tZone
}

new DestroyCarTimer[MAX_PLAYERS];
new bool:InDestroyZone[MAX_PLAYERS];
new PlayerDestroyVehicle[MAX_PLAYERS];
new TransportSpots[MAX_TRANSPORT_SPOTS][t_spot];
new TotalTransportSpots = 0;
new RentVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new RentTimer[MAX_PLAYERS];

forward RemoveRentVehicle(playerid);

new db_handle;
// ------- rega ne trogay ------- //
new bool:gSimpleAuthPassed[MAX_PLAYERS];

// ---- макс слоты ---- //
#define MAX_PLAYER_VEHICLES 50

// ------ прошивки ---- //
#if !defined VF_SPORTA
    #define VF_SPORTA      (1)
    #define VF_DRIFTA      (2)
    #define VF_COMFORTA    (4)
    #define VF_SPORTPLUSA  (8)
    #define VF_STROB_ON    (16)
    #define VF_DALNIY_ON   (32)
#endif

// структура транспорта
enum v_info
{
    vID,
    vDBID,
    vModel,
    vColor[2],
    vBodyColor,
    vDiskColor,
    vWheel,
    vPrice,
    Float:vPos[4], // X, Y, Z, Angle
    bool:vSpawned,
	vSport,
    vDrift,
    vComfort,
    vSportPlus,
    bool:vSportA,
    bool:vDriftA,
    bool:vComfortA,
    bool:vSportPlusA,
    vNitro,
    vWindFront,
    vWindRear,
    vNeonMain,
    vNeon1,
    vNeon2,
    vLightsColor,
    vStrob,
    bool:vStrobState,
    vVinyl[16],
    vDalniysvet,
    bool:Dalniysvet,
    Float:vClearance,
    Float:vClearanceFront,
    Float:vClearanceRear,
    vWheelModel,
    Float:vOffsetFront,
    Float:vOffsetRear,
    Float:vCamberFront,
    Float:vCamberRear,
    Float:vWheelWidthFront,
    Float:vWheelWidthRear,
    Float:vWheelRadius,
    vHydraInstalled,
    vPnevmoInstalled,
    vHydra,
    vPnevmo
}
new VehicleInfo[MAX_PLAYERS][MAX_PLAYER_VEHICLES][v_info];

// структура игрока
enum p_info
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[65],
    pLevel,
    pSkin,
    pMoney,
    pAdminLvl,
    pAdminPass,
    pAdminPrefix[32],
    bool:pAdminAuth,
    pAdminVeh,
    pMuteTime,
    pJailTime,
    pWarns,
    pBanTime,
    pExp,
    pBanReason[64],
    pBanAdmin[24],
    pSecondsHour,
    pSecondsToday,
    pSecondsYesterday,
    pBC,
    pSimCard,
    pVodoItems,
    pVodoTime,
    pVodoTask,
    pVipType,
    pVipTime,
    pLoginAttempts,
    pCountTodayCases,
    pCountBomjCases,
    pCountStandartCases,
    pCountCarCases,
    pCountOsobiyCases,
    pGiftDelay
}
new Player[MAX_PLAYERS][p_info];

enum E_VEHICLE_PARAMS_STRUCT
{
    V_ENGINE,
    V_LIGHTS,
    V_ALARM,
    V_LOCK,
    V_BONNET,
    V_BOOT,
    V_OBJECTIVE
};
new bool:g_vehicle_params[MAX_VEHICLES][E_VEHICLE_PARAMS_STRUCT];

new Admin3DText[MAX_PLAYERS] = {INVALID_3DTEXT_ID, ...};

new TurnSignalState[MAX_VEHICLES];
new bool:TurnSignalBlinkOn[MAX_VEHICLES];
new TurnSignalDriver[MAX_VEHICLES];
new TurnSignalModel[MAX_VEHICLES];

#define MAX_HOUSES 1000

enum h_info {
    hID,
    hOwnerID,
    hOwnerName[24],
    hType,
    hPrice,
    Float:hEntX,
    Float:hEntY,
    Float:hEntZ,
    Float:hExitX,
    Float:hExitY,
    Float:hExitZ,
    Float:hExitA,
    hPickup,
    Text3D:hLabel,
    bool:hLock
}
new HouseInfo[MAX_HOUSES][h_info];
new TotalHouses = 0;

enum E_H_INT_DATA {
    iName[32],
    Float:iX,
    Float:iY,
    Float:iZ,
    Float:iA,
    iInt
}

new HouseInteriors[7][E_H_INT_DATA] = {
    {"Деревенский", 2491.4910, 1003.5193, 1499.5813, 268.0, 1},
    {"Эконом", 2903.2188, 1498.0972, 2001.0000, 268.0, 1},
    {"Средний", 667.4174, 29.3543, 1024.1985, 268.0, 1},
    {"Средний+", 994.7635, 2021.9585, 1561.0112, 268.0, 1},
    {"Высокий", -2.3367, 483.5531, 1381.0022, 270.0, 1},
    {"Наивысший", 10.3718, 2494.1458, 1540.9941, 0.0, 1},
    {"Премиум", 294.7161, 2139.3115, 1765.4641, 0.0, 1}
};

main()
{
    print("----------------------------------");
    print("    BR BONUS STARTED    ");
    print("----------------------------------");
}

new PayDayMinutesCount = 0;
new Float:RandomSpawns[][] = {
    {844.8248, 794.6372, 13.3816, 69.8335},
    {1804.63, 2518.68, 14.64, 119.86},
    {2740.7158, -2441.7961, 21.7810, 289.5002},
    {-2430.7253, 204.7393, 26.0951, 171.7708}
};

new Float:MapTPPos[MAX_PLAYERS][3];
new pickup_salon_high;
new pickup_salon_medium;
new pickup_salon_low;
new bool:InStailing[MAX_PLAYERS];
new bool:bizCreated = false;
new Float:bizX, Float:bizY, Float:bizZ;
new bizPickup = -1;
new Text3D:bizLabel = Text3D:-1;
new bizOwnerID = 0;
new bizBalance = 0;
const BIZ_PRICE = 1000000;

// ------ дефайны --------- //
#define COLOR_RED    0xE0584BFF
#define COLOR_GREY   0xAAAAAAFF
#define COLOR_WHITE  0xFFFFFFFF
#define ADMIN_COLOR 0x87CEEBFF
#define UNIV_COLOR 0xFF999999
#define DIALOG_AF_MAIN          (6200)
#define DIALOG_AF_COMMANDS      (6201)
#define DIALOG_AF_INPUT_PARAMS  (6202)
#define DIALOG_AF_CONFIRM       (6203)
#define DIALOG_AF_LIST          (6204)
#define DIALOG_AF_ACCEPT        (6205)
#define DIALOG_TRANSPORT_MENU 2200
#define DIALOG_PERSONAL_CARS 2201
#define ZONE_RADIUS 60.0
#define PACKET_CALENDAR_GUI 7
#define DIALOG_AHELP_MAIN 28600
#define DIALOG_AHELP_LIST 28601
#define AHELP_MODE_SHORT 1
#define AHELP_MODE_FULL 2
// ----- настройки ---- //
#define MEMORY_HOST "127.0.0.1"
#define MEMORY_USER "user42575"
#define MEMORY_PSW "kCjWsDIFXN3j"
#define MEMORY_DATABASE "user42575"
#define X2_SYSTEM 1

// ----- инклуды ------ //
#include "../include/system/autosalon.inc"
#include "../include/system/vehiclenames.inc"
#include "../include/system/cases.inc"
#include "../include/system/shinka.inc"
#include "../include/system/stailing.inc"
#include "../include/system/inv.inc"
#include "../include/system/vodolaz_system.inc"
#include "../include/system/acs.inc"
#include "../include/system/market.inc"
#include "../include/system/family_c6_compat.inc"
#include "../include/system/spawn.inc"
#include "../include/system/donate.inc"
#include "../include/system/blackpass.inc"
#include "../include/system/admintools.inc"
#include "../include/system/promocode"
#include "../include/system/techcenter.inc"
// ------ gui // rpc ----- //
#include "../gamemodes/memory-brb/gui/family/family.pwn"
#include "../gamemodes/memory-brb/gui/family/family_addition.pwn"
#include "../gamemodes/memory-brb/gui/family/family_commands_c6.pwn"
#include "../gamemodes/memory-brb/rpc/rpc-functions.inc"

// ------ паблики ---- //
public OnGameModeInit()
{
    db_handle = mysql_connect(MEMORY_HOST, MEMORY_USER, MEMORY_DATABASE, MEMORY_PSW);
    if(mysql_errno() != 0) print("[MySQL информация ] Ошибкв подключения, проверьте подключилили вы базу данных");
    else {
        print("[MySQL информация] Подключение успешно");
        mysql_tquery(db_handle, "SET NAMES cp1251", "", "");
    }

    mysql_tquery(db_handle, "SET CHARACTER SET cp1251", "", "");
    // ---- внедрение скриптов ---- //
    FamilyC6_SQLInit();
    Inventory_Init();
    Accessory_Init();
    Marketplace_Init();
    Vodolaz_Init();
    CreateEditAccessoryTD();
    
    FamilyC6_AddColumnIfMissing("players", "exp", "`exp` INT DEFAULT 0");
    FamilyC6_AddColumnIfMissing("players", "vodopr", "`vodopr` INT DEFAULT 0");
    FamilyC6_AddColumnIfMissing("players", "vodotime", "`vodotime` INT DEFAULT 0");
    FamilyC6_AddColumnIfMissing("players", "vodozadanie", "`vodozadanie` INT DEFAULT 0");

    TotalTransportSpots = 0;
    TransportSpots[TotalTransportSpots][tPickupX] = 853.9973; TransportSpots[TotalTransportSpots][tPickupY] = 828.8482; TransportSpots[TotalTransportSpots][tPickupZ] = 13.3554;
    TransportSpots[TotalTransportSpots][tSpawnX] = 876.5883; TransportSpots[TotalTransportSpots][tSpawnY] = 852.4995; TransportSpots[TotalTransportSpots][tSpawnZ] = 13.4839; TransportSpots[TotalTransportSpots][tSpawnAngle] = 159.3482;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 1978.0; TransportSpots[TotalTransportSpots][tPickupY] = -1440.0; TransportSpots[TotalTransportSpots][tPickupZ] = 13.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 1982.0; TransportSpots[TotalTransportSpots][tSpawnY] = -1444.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 13.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 1175.0; TransportSpots[TotalTransportSpots][tPickupY] = -1326.0; TransportSpots[TotalTransportSpots][tPickupZ] = 14.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 1179.0; TransportSpots[TotalTransportSpots][tSpawnY] = -1330.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 14.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 1546.0; TransportSpots[TotalTransportSpots][tPickupY] = -1614.0; TransportSpots[TotalTransportSpots][tPickupZ] = 13.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 1550.0; TransportSpots[TotalTransportSpots][tSpawnY] = -1618.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 13.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 2175.0; TransportSpots[TotalTransportSpots][tPickupY] = -2285.0; TransportSpots[TotalTransportSpots][tPickupZ] = 13.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 2179.0; TransportSpots[TotalTransportSpots][tSpawnY] = -2289.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 13.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 2477.0; TransportSpots[TotalTransportSpots][tPickupY] = -718.0; TransportSpots[TotalTransportSpots][tPickupZ] = 12.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 2481.0; TransportSpots[TotalTransportSpots][tSpawnY] = -722.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 12.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 2315.0; TransportSpots[TotalTransportSpots][tPickupY] = -2615.0; TransportSpots[TotalTransportSpots][tPickupZ] = 21.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 2319.0; TransportSpots[TotalTransportSpots][tSpawnY] = -2619.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 21.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 1280.0; TransportSpots[TotalTransportSpots][tPickupY] = -1276.0; TransportSpots[TotalTransportSpots][tPickupZ] = 13.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 1284.0; TransportSpots[TotalTransportSpots][tSpawnY] = -1280.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 13.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 1100.0; TransportSpots[TotalTransportSpots][tPickupY] = -1500.0; TransportSpots[TotalTransportSpots][tPickupZ] = 15.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 1104.0; TransportSpots[TotalTransportSpots][tSpawnY] = -1504.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 15.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;
    TransportSpots[TotalTransportSpots][tPickupX] = 1000.0; TransportSpots[TotalTransportSpots][tPickupY] = -1200.0; TransportSpots[TotalTransportSpots][tPickupZ] = 14.0;
    TransportSpots[TotalTransportSpots][tSpawnX] = 1004.0; TransportSpots[TotalTransportSpots][tSpawnY] = -1204.0; TransportSpots[TotalTransportSpots][tSpawnZ] = 14.0; TransportSpots[TotalTransportSpots][tSpawnAngle] = 90.0;
    TotalTransportSpots++;

    for(new i = 0; i < TotalTransportSpots; i++)
    {
        TransportSpots[i][tPickup] = CreateDynamicPickup(19131, 23, TransportSpots[i][tPickupX], TransportSpots[i][tPickupY], TransportSpots[i][tPickupZ], 0, -1);
        new label[128];
        format(label, sizeof(label), "{DD5757}BR BONUS | {808080}Транспорт\n{FFFFFF}Подойдите чтобы открыть меню");
        TransportSpots[i][tLabel] = CreateDynamic3DTextLabel(label, 0xFFFF00FF, TransportSpots[i][tPickupX], TransportSpots[i][tPickupY], TransportSpots[i][tPickupZ] + 0.5, 5.0);  
        TransportSpots[i][tZone] = CreateDynamicSphere(TransportSpots[i][tSpawnX], TransportSpots[i][tSpawnY], TransportSpots[i][tSpawnZ], ZONE_RADIUS);
    }
    //printf("[TRANSPORT] Создано %d точек вызова транспорта", TotalTransportSpots);

    CreateActor(8, -20.656753, -17.561384, 1381.059692, 89.247047);
	factory_area = CreateDynamicSphere(-21.626913, -17.373409, 1381.059692, 1.0);
	Create3DTextLabel("{FF9900}Михалыч (Начальник цеха)\n{FFFFFF}Подойдите поближе", -1, -20.656753, -17.561384, 1381.059692, 10.0, 0);
	Create3DTextLabel("{00FF00}Сдача готовой продукции\n{FFFFFF}Подойдите поближе", -1, DropProductPos[0], DropProductPos[1], DropProductPos[2], 10.0, 0);
	DropArea = CreateDynamicSphere(DropProductPos[0], DropProductPos[1], DropProductPos[2], 1.0);
	for(new i = 0; i < MAX_RAW_POINTS; i++)
	{
	    Create3DTextLabel("{FFFF00}Склад сырья\n{FFFFFF}Подойдите поближе", -1, RawPos[i][0], RawPos[i][1], RawPos[i][2], 10.0, 0);
	    RawAreas[i] = CreateDynamicSphere(RawPos[i][0], RawPos[i][1], RawPos[i][2], 1.0);
	}
	for(new i = 0; i < MAX_CRAFT_POINTS; i++)
	{
	    Create3DTextLabel("{FFFF00}Станок\n{FFFFFF}Для работы подойдите поближе", -1, CraftPos[i][0], CraftPos[i][1], CraftPos[i][2], 10.0, 0);
	    CraftAreas[i] = CreateDynamicSphere(CraftPos[i][0], CraftPos[i][1], CraftPos[i][2], 1.0);
	}

    AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

    SetTimer("UpdateVehicleTurnSignals", 500, true);

    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        TurnSignalDriver[i] = INVALID_PLAYER_ID;
        TurnSignalModel[i] = 0;
    }

    SetTimer("GiftTimer", 1000, true);
    SetTimer("UpdatePunishments", 60000, true);
    SetTimer("DoubleTimeTimer", 300000, true);
    mysql_tquery(db_handle, "SELECT * FROM black_pass ORDER BY total_points DESC LIMIT 15", "LoadBPTop", "");
    mysql_tquery(db_handle, "SELECT * FROM houses", "LoadHouses", "");
    // ------ пикапы // актёры ----- //
    pickup_salon_high = CreateDynamicPickup(19134, 23, 660.6171, 2667.5517, 14.5011, 0, 0);
    pickup_salon_medium = CreateDynamicPickup(19134, 23, 1410.6278, 459.6904, 13.2030, 0, 0);
    pickup_salon_low = CreateDynamicPickup(19134, 23, 2477.0832, -718.5198, 12.7074, 0, 0);
    CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -426.2352, 1005.4126, 14.8, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -420.0545, 1005.4092, 14.8, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -413.5492, 1005.5430, 14.8, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.418945,-2607.487304,21.808467, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.424804,-2613.460937,21.808467, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.318603,-2619.407470,21.808467, 9.0, _, _, _, -1, -1);

    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `black_pass` (`user_id` INT PRIMARY KEY, `exp` INT DEFAULT 0, `level` INT DEFAULT 1, `premium` INT DEFAULT 0, `total_points` INT DEFAULT 0, `rewards_bitmap0` INT DEFAULT 0, `rewards_bitmap1` INT DEFAULT 0, `rewards_bitmap2` INT DEFAULT 0, `rewards_bitmap3` INT DEFAULT 0)");
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `black_pass_top` (`user_id` INT PRIMARY KEY, `total_points` INT DEFAULT 0)");
    mysql_tquery(db_handle, "INSERT INTO `black_pass_top` (`user_id`, `total_points`) SELECT `id`, 0 FROM `players` ON DUPLICATE KEY UPDATE `total_points` = 0");
    mysql_tquery(db_handle, "SELECT user_id, total_points FROM black_pass_top ORDER BY total_points DESC LIMIT 15", "LoadBPTop", "");
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `player_accessories` (`id` INT AUTO_INCREMENT PRIMARY KEY, `account_id` INT NOT NULL, `active_slot` INT NOT NULL, `accessory_id` INT NOT NULL, `bone` INT NOT NULL, `x` FLOAT NOT NULL DEFAULT 0.0, `y` FLOAT NOT NULL DEFAULT 0.0, `z` FLOAT NOT NULL DEFAULT 0.0, `rx` FLOAT NOT NULL DEFAULT 0.0, `ry` FLOAT NOT NULL DEFAULT 0.0, `rz` FLOAT NOT NULL DEFAULT 0.0, `scale` FLOAT NOT NULL DEFAULT 1.0, UNIQUE KEY `unique_slot` (`account_id`, `active_slot`))", "", "");

    SetGameModeText("BR BONUS");
    return 1;
}

public OnGameModeExit()
{
    mysql_close(db_handle);
    return 1;
}

public OnPlayerConnect(playerid)
{
    gSimpleAuthPassed[playerid] = false;
    Player[playerid][pLoginAttempts] = 0;
    Player[playerid][pID] = 0;
    Player[playerid][pLevel] = 0;
    Player[playerid][pExp] = 0;
    Player[playerid][pMoney] = 0;
    Player[playerid][pCountTodayCases] = 0;
    Player[playerid][pCountBomjCases] = 0;
    Player[playerid][pCountStandartCases] = 0;
    Player[playerid][pCountCarCases] = 0;
    Player[playerid][pCountOsobiyCases] = 0;
    Player[playerid][pAdminLvl] = 0;
    Player[playerid][pAdminAuth] = false;
    Player[playerid][pSkin] = 0;
    format(Player[playerid][pName], MAX_PLAYER_NAME, "");
    GetPlayerName(playerid, Player[playerid][pName], MAX_PLAYER_NAME);

    SendClientMessage(playerid, -1, "{66CC66}| {ffffff}Добро пожаловать на {00CCFF}BR BONUS!");

    Player[playerid][pAdminVeh] = INVALID_VEHICLE_ID;

    Vodolaz_ResetPlayer(playerid);
    
    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `players` WHERE `name` = '%e' LIMIT 1", Player[playerid][pName]);
    mysql_tquery(db_handle, query, "CheckPlayerAccount", "i", playerid);

    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    gSimpleAuthPassed[playerid] = false;
    if(RentVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(RentVehicle[playerid]);
        RentVehicle[playerid] = INVALID_VEHICLE_ID;
    }
    KillTimer(RentTimer[playerid]);

    if(Admin3DText[playerid] != INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(Admin3DText[playerid]);
        Admin3DText[playerid] = INVALID_3DTEXT_ID;
    }
    
    // ------ сохранение чего-либо ---- //
    
    Accessory_SaveAllSlots(playerid);
    KillTimer(DestroyCarTimer[playerid]);
    Inventory_Save(playerid);
    Vodolaz_DestroyPlayerBoat(playerid);
    StopPlayerVehicleTurnSignal(playerid);
    SavePlayerAccount(playerid);
    SavePlayerBP(playerid);

    return 1;
}

public OnPlayerSpawn(playerid)
{
#if X2_SYSTEM
    SetPlayerX2(playerid, true, 0);
#endif
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

    SetCameraBehindPlayer(playerid);

    if(Player[playerid][pAdminAuth] && Player[playerid][pAdminLvl] > 0)
        UpdateAdmin3DText(playerid);

    TogglePlayerSpectating(playerid, false);
    TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, -1, "{66CC66}| {00CCFF}[DEBUG] Client « BR BONUS » started!");
    SetPlayerSkin(playerid, Player[playerid][pSkin]);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);

    Accessory_OnPlayerSpawn(playerid);
    NewsStart(playerid);

    if(Player[playerid][pAdminLvl] > 0 && !Player[playerid][pAdminAuth]) ShowAdminLogin(playerid);
    return 1;
}

stock ShowAdminLogin(playerid)
{
    if(Player[playerid][pAdminPass] == 0)
    {
        ShowPlayerDialog(playerid, DIALOG_ADMIN_REG, DIALOG_STYLE_INPUT,
            "{E0584B}BR BONUS | Регистрация",
            "{FFFFFF}Вы были назначены администратором проекта.\n"\
            "Придумайте секретный пароль, состоящий из {E0584B}4-х цифр{FFFFFF}, и введите его ниже:",
            "Далее", "Отмена");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_ADMIN_LOGIN, DIALOG_STYLE_PASSWORD,
            "{E0584B}BR BONUS | Авторизация",
            "{FFFFFF}Введите Ваш административный пароль, указанный при регистрации.\n"\
            "Пароль должен состоять из {E0584B}4-х цифр{FFFFFF}:",
            "Далее", "Отмена");
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(Vodolaz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;

    if(Trade_HandleDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    
    if(dialogid == DIALOG_AHELP_MAIN)
    {
        if(listitem == 0) ShowAHelpPage(playerid, AHELP_MODE_SHORT, 1);
        else if(listitem == 1) ShowAHelpPage(playerid, AHELP_MODE_FULL, 1);
        return 1;
    }
    
    if(dialogid == DIALOG_AHELP_LIST)
    {
        if(!response) return 1;

        new mode = GetPVarInt(playerid, "AHELP_MODE");
        new page = GetPVarInt(playerid, "AHELP_PAGE");
        new adminlvl = GetPlayerAdminLevel(playerid);
        new count = GetAHelpCountByLevel(page);

        if(listitem < count)
        {
            ShowAHelpPage(playerid, mode, page);
            return 1;
        }

         new navIndex = count;

        if(page > 1)
        {
            if(listitem == navIndex)
            {
                ShowAHelpPage(playerid, mode, page - 1);
                return 1;
            }
            navIndex++;
        }

        if(page < 6)
        {
            if(listitem == navIndex)
            {
                if(page + 1 > adminlvl)
                {
                    ShowAHelpPage(playerid, mode, page);
                    return 1;
                }

                ShowAHelpPage(playerid, mode, page + 1);
                return 1;
            }
        }

        return 1;
    }
    if(Accessory_HandleDialog(playerid, dialogid, response, listitem, inputtext)) return 1;

    if(HandleAdminToolsDialog(playerid, dialogid, response, listitem, inputtext)) return 1;

    if(dialogid == DIALOG_TRANSPORT_MENU)
    {
        if(!response) return 1;
        if(listitem == 0)
        {
            new spot = GetPVarInt(playerid, "transport_spot_id");
            if(spot < 0 || spot >= TotalTransportSpots) return 1;
            if(RentVehicle[playerid] != INVALID_VEHICLE_ID)
            {
                DestroyVehicle(RentVehicle[playerid]);
                KillTimer(RentTimer[playerid]);
            }
            RentVehicle[playerid] = CreateVehicle(522, TransportSpots[spot][tSpawnX], TransportSpots[spot][tSpawnY], TransportSpots[spot][tSpawnZ], TransportSpots[spot][tSpawnAngle], random(126), random(126), 60000);
            SetVehicleParamsEx(RentVehicle[playerid], 1, 0, 0, 0, 0, 0, 0);
            PutPlayerInVehicle(playerid, RentVehicle[playerid], 0);
            ShowNotification(playerid, 1, 5, 0, 0, "Вы успешно арендовали мотоцикл", "");
        }
        if(listitem == 1)
        {
            new list[1024];
            format(list, sizeof(list), "{DD5757}номер\t{DD5757}наименование\t{DD5757}номерной знак\n");
            new count = 0;
            for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
            {
                if(VehicleInfo[playerid][i][vModel] == 0) continue;
                new plate[32];
                format(plate, sizeof(plate), "[%s | %d]", GetVehicleNameByModel(VehicleInfo[playerid][i][vModel]), i + 1);
                format(list, sizeof(list), "%s#%d\t%s\t%s\n", list, i + 1, GetVehicleNameByModel(VehicleInfo[playerid][i][vModel]), plate);
                count++;
            }
            if(count == 0)
            {
                ShowNotification(playerid, 0, 5, 0, 0, "У вас нет личного транспорта", "");
                return 1;
            }
            ShowPlayerDialog(playerid, DIALOG_PERSONAL_CARS, DIALOG_STYLE_TABLIST_HEADERS, "{DD5757}Личный транспорт", list, "Выбрать", "Назад");
        }
        return 1;
    }
    
    if(dialogid == DIALOG_CLEAR_CHAT)
        {
            if (response)
            {
                switch (listitem)
                {
                    case 0:
                    {
                        for (new i = 0; i < 20; i++) SendClientMessageToAll(-1, "");
                        SendClientMessageToAll(0xFFCD00FF, "Чат был очищен администрацией");
                    }
                    case 1:
                    {
                        for (new i = 0; i < 20; i++) SendClientMessageToAll(-1, "");
                        //new fmt_str[128];
         //eerrrotii!!!!               //format(fmt_str, sizeof fmt_str, "Чат был очищен администратором %s", p_info[playerid][pName]);
                        //SendClientMessageToAll(0xFFCD00FF, fmt_str);
                    }
                    case 2:
                    {
                        for (new i = 0; i < 12; i++) SendClientMessageToAll(-1, "");
                        SendClientMessageToAll(0xFFCD00FF, "Чат был очищен администрацией");
                    }
                }
            }
            return 1;
        }
        
    if(dialogid == DIALOG_PERSONAL_CARS)
    {
        if(!response) return 1;
        new spot = GetPVarInt(playerid, "transport_spot_id");
        if(spot < 0 || spot >= TotalTransportSpots) return 1;
        new car_index = -1, found = 0;
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
        {
            if(VehicleInfo[playerid][i][vModel] == 0) continue;
            if(found == listitem)
            {
                car_index = i;
                break;
            }
            found++;
        }
        if(car_index == -1) return 1;
        if(VehicleInfo[playerid][car_index][vSpawned] && VehicleInfo[playerid][car_index][vID] != INVALID_VEHICLE_ID)
        {
            SetVehiclePos(VehicleInfo[playerid][car_index][vID], TransportSpots[spot][tSpawnX], TransportSpots[spot][tSpawnY], TransportSpots[spot][tSpawnZ]);
            SetVehicleZAngle(VehicleInfo[playerid][car_index][vID], TransportSpots[spot][tSpawnAngle]);
            PutPlayerInVehicle(playerid, VehicleInfo[playerid][car_index][vID], 0);
            ShowNotification(playerid, 1, 5, 0, 0, "Вы успешно заспавнили личный транспорт", "");
        }
        else
        {
            if(VehicleInfo[playerid][car_index][vID] != INVALID_VEHICLE_ID) DestroyVehicle(VehicleInfo[playerid][car_index][vID]);
            VehicleInfo[playerid][car_index][vID] = CreateVehicle(VehicleInfo[playerid][car_index][vModel], TransportSpots[spot][tSpawnX], TransportSpots[spot][tSpawnY], TransportSpots[spot][tSpawnZ], TransportSpots[spot][tSpawnAngle], VehicleInfo[playerid][car_index][vColor][0], VehicleInfo[playerid][car_index][vColor][1], 60000);
            VehicleInfo[playerid][car_index][vSpawned] = true;
            SetVehicleParamsInit(VehicleInfo[playerid][car_index][vID]);
            PutPlayerInVehicle(playerid, VehicleInfo[playerid][car_index][vID], 0);
            ShowNotification(playerid, 1, 5, 0, 0, "Вы успешно заспавнили личный транспорт", "");
        }
        return 1;
    }
    
    if(dialogid == DIALOG_AF_MAIN)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: AF_ShowList(playerid);
            case 1:
            {
                new commands[] = 
                    "Кикнуть\nЗапретить чат\nПосадить\nВыдать предупреждение\nЗабанить\nЗабанить навсегда\nВернуть доступ к чату\nВытащить из тюрьмы\nЗаспаванит\nРазбанить\nПодбросить\nЗаморозить\nРазморозить";
                ShowPlayerDialog(playerid, DIALOG_AF_COMMANDS, DIALOG_STYLE_LIST,
                    "{E0584B}BR BONUS {FFFFFF}| Выберите команду",
                    commands, "Далее", "Назад");
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_AF_COMMANDS)
    {
        if(!response) return AF_ShowMainMenu(playerid);
        new command[32];
        switch(listitem)
        {
            case 0: command = "kick";
            case 1: command = "mute";
            case 2: command = "jail";
            case 3: command = "warn";
            case 4: command = "ban";
            case 5: command = "permban";
            case 6: command = "unmute";
            case 7: command = "unjail";
            case 8: command = "spawn";
            case 9: command = "unban";
            case 10: command = "slap";
            case 11: command = "freeze";
            case 12: command = "unfreeze";
            default: return 1;
        }
        SetPVarString(playerid, "AF_Command", command);
        
        new info[256];
        if(!strcmp(command, "kick"))
            info = "Требуемые данные: [id игрока / ник] [причина]";
        else if(!strcmp(command, "mute"))
            info = "Требуемые данные: [id игрока / ник] [количество минут] [причина]";
        else if(!strcmp(command, "jail"))
            info = "Требуемые данные: [id игрока / ник] [количество минут] [причина]";
        else if(!strcmp(command, "warn"))
            info = "Требуемые данные: [id игрока / ник] [причина]";
        else if(!strcmp(command, "ban"))
            info = "Требуемые данные: [id игрока / ник] [дни] [причина]";
        else if(!strcmp(command, "permban"))
            info = "Требуемые данные: [id игрока / ник] [причина]";
        else if(!strcmp(command, "unmute") || !strcmp(command, "unjail") || !strcmp(command, "spawn") || !strcmp(command, "unban") || !strcmp(command, "unfreeze"))
            info = "Требуемые данные: [id игрока / ник]";
        else if(!strcmp(command, "slap"))
            info = "Требуемые данные: [id игрока / ник]";
        else if(!strcmp(command, "freeze"))
            info = "Требуемые данные: [id игрока / ник]";
        else
            info = "Требуемые данные: [id игрока / ник]";
        
        ShowPlayerDialog(playerid, DIALOG_AF_INPUT_PARAMS, DIALOG_STYLE_INPUT,
            "{E0584B}BR BONUS {FFFFFF}| Параметры команды",
            info, "Далее", "Назад");
        return 1;
    }
    
    if(dialogid == DIALOG_AF_INPUT_PARAMS)
    {
        if(!response) return AF_ShowMainMenu(playerid);
        new command[32];
        GetPVarString(playerid, "AF_Command", command, sizeof(command));
        if(isnull(inputtext))
        {
            ShowPlayerDialog(playerid, DIALOG_AF_INPUT_PARAMS, DIALOG_STYLE_INPUT,
                "{E0584B}BR BONUS {FFFFFF}| Параметры команды",
                "Параметры не могут быть пустыми!\nТребуемые данные: ...", "Далее", "Назад");
            return 1;
        }
        SetPVarString(playerid, "AF_Params", inputtext);
        
        new preview[256];
        format(preview, sizeof(preview), "{FFFFFF}Форма: {E0584B}/%s %s{FFFFFF}\n\nВы действительно хотите отправить получившуюся форму администрации сервера?", command, inputtext);
        ShowPlayerDialog(playerid, DIALOG_AF_CONFIRM, DIALOG_STYLE_MSGBOX,
            "{E0584B}BR BONUS {FFFFFF}| Подтверждение", preview, "Далее", "Назад");
        return 1;
    }
    
    if(dialogid == DIALOG_AF_CONFIRM)
    {
        if(!response) return AF_ShowMainMenu(playerid);
        new command[32], params[256];
        GetPVarString(playerid, "AF_Command", command, sizeof(command));
        GetPVarString(playerid, "AF_Params", params, sizeof(params));
        new formid = AF_SaveForm(playerid, command, params);
        if(formid == -1)
        {
            SendClientMessage(playerid, COLOR_RED, "Ошибка: превышен лимит активных форм.");
            return 1;
        }
        SendClientMessage(playerid, -1, "{66CC66}Форма успешно отправлена. Ожидайте реакции администрации.");
        new log[256];
        format(log, sizeof(log), "[A] Администратор %s[%d] создал форму #%d: /%s %s", Player[playerid][pName], playerid, formid, command, params);
        SendAdminLog(log);
        DeletePVar(playerid, "AF_Command");
        DeletePVar(playerid, "AF_Params");
        return 1;
    }
    
    if(dialogid == DIALOG_AF_LIST)
    {
        if(!response) return AF_ShowMainMenu(playerid);
        new formid = strval(inputtext);
        new idx = AF_FindFormByID(formid);
        if(idx == -1)
        {
            SendClientMessage(playerid, COLOR_RED, "Форма не найдена или уже обработана.");
            AF_ShowList(playerid);
            return 1;
        }
        SetPVarInt(playerid, "AF_AcceptIdx", idx);
        new sender[MAX_PLAYER_NAME];
        GetPlayerName(AF_Forms[idx][afSenderID], sender, sizeof(sender));
        new preview[512];
        format(preview, sizeof(preview), "{FFFFFF}Форма #{id}\n{FFFFFF}Отправитель: {E0584B}%s\n{FFFFFF}Команда: {E0584B}/%s %s\n\nВы действительно хотите принять эту форму и выдать наказание?", sender, AF_Forms[idx][afCommand], AF_Forms[idx][afParams]);
        ShowPlayerDialog(playerid, DIALOG_AF_ACCEPT, DIALOG_STYLE_MSGBOX,
            "{E0584B}BR BONUS {FFFFFF}| Принятие формы", preview, "Да", "Нет");
        return 1;
    }
    
    if(dialogid == DIALOG_AF_ACCEPT)
    {
        if(!response) return AF_ShowList(playerid);
        new idx = GetPVarInt(playerid, "AF_AcceptIdx");
        if(idx == -1 || !AF_Forms[idx][afUsed])
        {
            SendClientMessage(playerid, COLOR_RED, "Форма уже обработана.");
            return 1;
        }
        new command[32], params[256];
        format(command, sizeof(command), AF_Forms[idx][afCommand]);
        format(params, sizeof(params), AF_Forms[idx][afParams]);
        new senderid = AF_Forms[idx][afSenderID];
        new sendername[MAX_PLAYER_NAME];
        GetPlayerName(senderid, sendername, sizeof(sendername));
        
        new required_level = 0;
        if(!strcmp(command, "kick")) required_level = 3;
        else if(!strcmp(command, "mute")) required_level = 2;
        else if(!strcmp(command, "jail")) required_level = 2;
        else if(!strcmp(command, "warn")) required_level = 2;
        else if(!strcmp(command, "ban")) required_level = 2;
        else if(!strcmp(command, "permban")) required_level = 5;
        else if(!strcmp(command, "unmute")) required_level = 1;
        else if(!strcmp(command, "unjail")) required_level = 2;
        else if(!strcmp(command, "spawn")) required_level = 1;
        else if(!strcmp(command, "unban")) required_level = 4;
        else if(!strcmp(command, "slap")) required_level = 1;
        else if(!strcmp(command, "freeze")) required_level = 1;
        else if(!strcmp(command, "unfreeze")) required_level = 1;
        else required_level = 5;
        
        if(Player[playerid][pAdminLvl] < required_level)
        {
            SendClientMessage(playerid, COLOR_RED, "У вас недостаточно прав для выполнения этой команды!");
            return 1;
        }
        
        new final_params[512], short_sender[32];
        GetShortSenderName(senderid, short_sender, sizeof(short_sender));
        if(!strcmp(command, "kick") || !strcmp(command, "mute") || !strcmp(command, "jail") || !strcmp(command, "warn") || !strcmp(command, "ban") || !strcmp(command, "permban"))
        {
            new temp[256], reason_part[128];
            strcat(temp, params);
            new last_space = -1;
            for(new i = 0; temp[i]; i++) if(temp[i] == ' ') last_space = i;
            if(last_space != -1)
            {
                format(reason_part, sizeof(reason_part), "%s by %s", temp[last_space+1], short_sender);
                strmid(final_params, temp, 0, last_space+1);
                strcat(final_params, reason_part);
            }
            else
            {
                format(final_params, sizeof(final_params), "%s by %s", params, short_sender);
            }
        }
        else
        {
            format(final_params, sizeof(final_params), "%s", params);
        }
        
        new funcname[32];
        format(funcname, sizeof(funcname), "cmd_%s", command);
        new ret = CallLocalFunction(funcname, "is", playerid, final_params);
        
        if(ret)
        {
            new msg[256];
            format(msg, sizeof(msg), "{CCCCCC}[A] Администратор %s[%d] принял форму #%d от %s[%d] (/%s %s)", Player[playerid][pName], playerid, AF_Forms[idx][afID], sendername, senderid, command, params);
            SendAdminLog(msg);
            
            if(IsPlayerConnected(senderid))
            {
                format(msg, sizeof(msg), "{66CC66}Ваша форма #%d была принята администратором %s[%d]. Наказание применено.", AF_Forms[idx][afID], Player[playerid][pName], playerid);
                SendClientMessage(senderid, -1, msg);
            }
            AF_DeleteForm(idx);
            SendClientMessage(playerid, -1, "{66CC66}Форма успешно принята и выполнена.");
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "Ошибка при выполнении команды. Проверьте правильность параметров.");
        }
        DeletePVar(playerid, "AF_AcceptIdx");
        AF_ShowList(playerid);
        return 1;
    }

    if(dialogid == DIALOG_FACTORY_JOB)
    {
        if(!response) return 1;
        
        if(listitem == 0) 
        {
            if(IsFactoryWorker[playerid])
            {
                IsFactoryWorker[playerid] = false;
                IsCrafting[playerid] = false;
                PlayerRawKg[playerid] = 0;
                PlayerProductKg[playerid] = 0;
                
                SetPlayerSkin(playerid, Player[playerid][pSkin]); 
                RemovePlayerAttachedObject(playerid, 1);
                
                if(FactorySalary[playerid] > 0) GiveFactorySalary(playerid);
                else SendClientMessage(playerid, -1, "{FF0000}Вы уволились с завода, не заработав ни копейки.");
            }
            else
            {
                IsFactoryWorker[playerid] = true;
                FactorySalary[playerid] = 0.0;
                SetPlayerSkin(playerid, FACTORY_JOB_SKIN);
                SendClientMessage(playerid, -1, "{00FF00}Вы устроились на завод! Бегите к складу сырья.");
            }
        }
        else if(listitem == 1) 
        {
            ShowPlayerDialog(playerid, DIALOG_FACTORY_INFO, DIALOG_STYLE_MSGBOX, "{FF9900}Михалыч вещает:", 
                "{FFFFFF}Здаров, работяга! Впитывай пока я добрый.\n\
                Завод - не стул в офисе просиживать, тут нужно работать не покладая рук\n\n\
                Твоя задача простая: подходишь к складу, берешь сырье,\n\
                тащишь к станку, точишь деталь и несешь на склад готовой продукции.\n\
                Плачу щедро, от 100 до 150 рублей за килограмм годной детали.\n\
                Отработаешь смену без косяков — вечером на жигулевское с рыбкой точно хватит.\n\
                Ну че стоим? Иди щегол!", "Понял", "");
        }
    }

    if(dialogid == DIALOG_PROMO_MAIN)
    {
        if(!response) return 1;
        if(listitem == 0) // Активировать промокод
        {
            ShowPlayerDialog(playerid, ENTER_PROMOCODE, DIALOG_STYLE_INPUT,
            "{E0584B}Промокод",
            "{FFFFFF}Введите промокод для того чтобы получить приз:",
            "Ввести", "Выйти");
        }
    }
        
    if(dialogid == ENTER_PROMOCODE)
    {
        if(!response) return 1;
        if(isnull(inputtext))
        {
            return ShowPlayerDialog(playerid, ENTER_PROMOCODE, DIALOG_STYLE_INPUT,
                "{E0584B}Промокод",
                "{FFFFFF}Введите промокод для того чтобы получить приз:",
                "Ввести", "Выйти");
        }

        new msg[800];
	    msg[0] = '\0';
        format(msg, sizeof(msg),
            "{FFFFFF}Поздравляем!\n\n\
            Вы успешно активировали промокод {FFFF00}#%s{FFFFFF}.\n\n\
            Нужно выполнить: отыграть {FFFF00}1{FFFFFF} часов игры, Вы получите:\n\
            {E0584B}1. {FFFF00}VIP Gold {FFFFFF}на {FFFF00}12 {FFFFFF}ч.\n\
            {E0584B}2. {FFFFFF}автомобиль {FFFF00}BMW M5 F90 {FFFFFF}на {FFFF00}12 {FFFFFF}ч.\n\
            {E0584B}3. {FFFF00}15.000 {FFFFFF}рублей\n\
            {E0584B}4. {FFFFFF}скин {FFFF00}99 {FFFFFF}на {FFFF00}12 {FFFFFF}ч.\n\
            {E0584B}5. {FFFFFF}аксессуар {FFFF00}Очки с падающими снежинками {FFFFFF}на {FFFF00}12 {FFFFFF}ч.\n\n\
            Забрать приз после отыгрыша Вы сможете перейдя - /promo -> Забрать призы\n\n\
            Приятной игры на {E0584B}BR BONUS!", inputtext);

        ShowPlayerDialog(playerid, PROMO_PRISE, DIALOG_STYLE_MSGBOX, "{E0584B}BR BONUS{FFFFFF} | Активация промокода", msg, "Закрыть", "");
        return 1;
    }
    
	if(dialogid == DIALOG_BUYHOUSE)
	{
        if(!response) return 1;
        new id = GetPVarInt(playerid, "BuyHouseID");
        for(new h = 0; h < TotalHouses; h++)
    {
        if(HouseInfo[h][hOwnerID] == Player[playerid][pID])
        {
            return ShowNotification(playerid, 0, 5, 0, 0, "У Вас уже имеется личный дом!", "");
        }
    }
        if(Player[playerid][pMoney] < HouseInfo[id][hPrice]) return ShowNotification(playerid, 0, 5, 0, 0, "Недостаточно денег!", "");

        GivePlayerMoneyEx(playerid, -HouseInfo[id][hPrice]);
        HouseInfo[id][hOwnerID] = Player[playerid][pID];
        format(HouseInfo[id][hOwnerName], 24, "%s", Player[playerid][pName]);

        new query[128];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `houses` SET owner_id=%d, owner_name='%e' WHERE id=%d", HouseInfo[id][hOwnerID], HouseInfo[id][hOwnerName], HouseInfo[id][hID]);
        mysql_tquery(db_handle, query, "", "");

        UpdateHouseStatus(id);
        return 1;
    }

	if(dialogid == DIALOG_ENTER_HOUSE)
    {
        if(!response) return 1;
        new i = GetPVarInt(playerid, "InHouseID");

        if(HouseInfo[i][hLock] && HouseInfo[i][hOwnerID] != Player[playerid][pID])
            return GameTextForPlayer(playerid, "~r~Locked", 2000, 1);

        new t = HouseInfo[i][hType];
        SetPlayerPos(playerid, HouseInteriors[t][iX], HouseInteriors[t][iY], HouseInteriors[t][iZ]);
        SetPlayerFacingAngle(playerid, HouseInteriors[t][iA]);
        SetPlayerInterior(playerid, HouseInteriors[t][iInt]);
        SetPlayerVirtualWorld(playerid, HouseInfo[i][hID] + 500);
        return 1;
    }

	if(dialogid == DIALOG_MENU_HOUSE)
	{
        if(!response) return 1;
        new i = GetPVarInt(playerid, "ManageHouseID");
        if(listitem == 0) {
            HouseInfo[i][hLock] = !HouseInfo[i][hLock];
        }
        if(listitem == 1) {
            SetGPSMarker(playerid, HouseInfo[i][hEntX], HouseInfo[i][hEntY], HouseInfo[i][hEntZ]);
        }
        return 1;
    }
    
    if(dialogid == DIALOG_MAP_TP)
    {
        if(response)
        {
            if(Player[playerid][pAdminAuth] && Player[playerid][pAdminLvl] >= 1)
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new interior = GetPlayerInterior(playerid);
                new virtualworld = GetPlayerVirtualWorld(playerid);

                if(IsPlayerInAnyVehicle(playerid))
                {
                    SetVehiclePos(vehicleid, MapTPPos[playerid][0], MapTPPos[playerid][1], MapTPPos[playerid][2]);
                    SetVehicleVirtualWorld(vehicleid, virtualworld);
                    LinkVehicleToInterior(vehicleid, interior);
                }
                else
                {
                    SetPlayerPos(playerid, MapTPPos[playerid][0], MapTPPos[playerid][1], MapTPPos[playerid][2]);
                }

                SetPlayerInterior(playerid, interior);
                SetPlayerVirtualWorld(playerid, virtualworld);

                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы были телепортированы на отмеченную метку.");
            }
        }
        return 1;
    }
    
	if(dialogid == DIALOG_BUY_CAR_CONFIRM)
	{
		if(!response) return 1;

		new id = GetPVarInt(playerid, "BuyCarID");
		new slot = -1;

		for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
			if(VehicleInfo[playerid][i][vModel] == 0) { slot = i; break; }
		}

		if(slot == -1) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Нет свободных слотов!");

		new car_model, car_price;
		if(p_SalonType[playerid] == 0) {
			car_model = SalonCars[id][sModel];
			car_price = SalonCars[id][sPrice];
		} else if(p_SalonType[playerid] == 1) {
			car_model = MediumSalonCars[id][sModel];
			car_price = MediumSalonCars[id][sPrice];
		} else {
			car_model = LowSalonCars[id][sModel];
			car_price = LowSalonCars[id][sPrice];
		}

		if(Player[playerid][pMoney] < car_price) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Недостаточно денег!");

		GivePlayerMoneyEx(playerid, -car_price);

		VehicleInfo[playerid][slot][vModel] = car_model;
		VehicleInfo[playerid][slot][vPrice] = car_price;
		VehicleInfo[playerid][slot][vColor][0] = p_SalonColor[playerid][0];
		VehicleInfo[playerid][slot][vColor][1] = p_SalonColor[playerid][1];
		VehicleInfo[playerid][slot][vSpawned] = true;
		VehicleInfo[playerid][slot][vNitro] = 0;

		new query[256];
		mysql_format(db_handle, query, sizeof(query),
			"INSERT INTO `ownable_cars` (`owner_id`, `model`, `price`, `color1`, `color2`) VALUES (%d, %d, %d, %d, %d)",
			Player[playerid][pID], car_model, car_price, p_SalonColor[playerid][0], p_SalonColor[playerid][1]);

		mysql_tquery(db_handle, query, "OnCarPurchased", "ii", playerid, slot);

		DeletePVar(playerid, "BuyCarID");
		HideAvtosalon(playerid);
		return 1;
	}
	else if(dialogid == DIALOG_MY_CARS)
    {
        if(!response) return 1;

        new page = GetPVarInt(playerid, "CarMenuPage");
        new total_cars = 0;
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
            if(VehicleInfo[playerid][i][vModel] != 0) total_cars++;
        }

        new cars_on_page = 0;
        new start_idx = page * 10;

        if(total_cars > start_idx) {
            cars_on_page = total_cars - start_idx;
            if(cars_on_page > 10) cars_on_page = 10;
        }

        if(listitem == cars_on_page)
        {
            if(total_cars > (page + 1) * 10) return ShowPlayerCars(playerid, page + 1);
            else return ShowPlayerCars(playerid, page - 1);
        }
        if(listitem == cars_on_page + 1) 
        {
            return ShowPlayerCars(playerid, page - 1);
        }

        new car_slot = -1, found_idx = 0, current_list_idx = 0;
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
        {
            if(VehicleInfo[playerid][i][vModel] == 0) continue;

            if(found_idx >= start_idx && found_idx < start_idx + 10)
            {
                if(listitem == current_list_idx)
                {
                    car_slot = i;
                    break;
                }
                current_list_idx++;
            }
            found_idx++;
        }

        if(car_slot != -1)
        {
            SetPVarInt(playerid, "SelectedCarSlot", car_slot);
            ShowCarActionMenu(playerid, car_slot);
        }
        return 1;
    }
	else if(dialogid == DIALOG_CAR_ACTION)
	{
		if(!response)
		{
			if(VehicleInfo[playerid][GetPVarInt(playerid, "SelectedCarSlot")][vSpawned]) return 1;
			return ShowPlayerCars(playerid, GetPVarInt(playerid, "CarMenuPage"));
		}

		new slot = GetPVarInt(playerid, "SelectedCarSlot");
		switch(listitem)
		{
			case 0:
			{
				if(VehicleInfo[playerid][slot][vID] == INVALID_VEHICLE_ID || !VehicleInfo[playerid][slot][vSpawned])
					return ShowNotification(playerid, 0, 5, 0, 0, "Сначало загрузите машину!", "");

				new Float:x, Float:y, Float:z;
				GetVehiclePos(VehicleInfo[playerid][slot][vID], x, y, z);
				SetGPSMarker(playerid, x, y, z);
			}
			case 1:
			{
				if(VehicleInfo[playerid][slot][vSpawned])
				{
					if(VehicleInfo[playerid][slot][vID] != INVALID_VEHICLE_ID)
					{
						DestroyVehicle(VehicleInfo[playerid][slot][vID]);
						VehicleInfo[playerid][slot][vID] = INVALID_VEHICLE_ID;
					}
                    VehicleInfo[playerid][slot][vSportA] = false;
                    VehicleInfo[playerid][slot][vDriftA] = false;
                    VehicleInfo[playerid][slot][vComfortA] = false;
                    VehicleInfo[playerid][slot][vSportPlusA] = false;
					VehicleInfo[playerid][slot][vSpawned] = false;
                    VehicleInfo[playerid][slot][vStrobState] = false;
					VehicleInfo[playerid][slot][Dalniysvet] = false;
					SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Ваша машина была выгружена.");
				}
				else
				{
					for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
					{
						if(VehicleInfo[playerid][i][vSpawned])
							return ShowNotification(playerid, 0, 5, 0, 0, "У Вас уже загружена машина", "");
					}

					VehicleInfo[playerid][slot][vID] = CreateVehicle(
						VehicleInfo[playerid][slot][vModel],
						VehicleInfo[playerid][slot][vPos][0],
						VehicleInfo[playerid][slot][vPos][1],
						VehicleInfo[playerid][slot][vPos][2],
						VehicleInfo[playerid][slot][vPos][3],
						VehicleInfo[playerid][slot][vColor][0],
						VehicleInfo[playerid][slot][vColor][1],
						-1
					);
					
                    VehicleInfo[playerid][slot][vStrobState] = false;
					VehicleInfo[playerid][slot][Dalniysvet] = false;
					
					SetVehicleParamsInit(VehicleInfo[playerid][slot][vID]);

					if(VehicleInfo[playerid][slot][vWheel] > 0)
						AddVehicleComponent(VehicleInfo[playerid][slot][vID], VehicleInfo[playerid][slot][vWheel]);

					VehicleInfo[playerid][slot][vSpawned] = true;
					SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Ваша машина была загружена.");
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_ADMIN_REG)
	{
		if(!response) return 1;
		if(strlen(inputtext) != 4 || strval(inputtext) < 1000) return ShowAdminLogin(playerid);

		Player[playerid][pAdminPass] = strval(inputtext);
		TogglePlayerControllable(playerid, true);
		SavePlayerAccount(playerid);
		ShowAdminLogin(playerid);
		return 1;
	}
	else if(dialogid == DIALOG_ADMIN_LOGIN)
    {
        if(!response) return 1;
        if(strval(inputtext) != Player[playerid][pAdminPass]) return ShowAdminLogin(playerid);

        Player[playerid][pAdminAuth] = true;
        TogglePlayerControllable(playerid, true);

        new str[160];
        format(str, sizeof(str),
            "{7CFC00}[Alogin]: %s[%d] авторизовался как %s",
            Player[playerid][pName],
            playerid,
            Player[playerid][pAdminPrefix]
        );

        SendAdminMessage(COLOR_GREY, str);
        return 1;
    }
    return 0;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    for(new i = 0; i < TotalTransportSpots; i++)
    {
        if(pickupid == TransportSpots[i][tPickup])
        {
            if(GetPVarInt(playerid, "TransportMenuDelay") > gettime()) return 1;
            SetPVarInt(playerid, "TransportMenuDelay", gettime() + 3);
            SetPVarInt(playerid, "transport_spot_id", i);
            ShowPlayerDialog(playerid, DIALOG_TRANSPORT_MENU, DIALOG_STYLE_TABLIST_HEADERS, "{DD5757}BR BONUS {808080}| Транспорт", "{DD5757}номер\t{DD5757}доступное действие\t{DD5757}стоимость\n#1\tАрендовать мотоцикл\tбесплатно\n#2\tВызвать личный транспорт\tбесплатно", "Выбрать", "Отмена");
            return 1;
        }
    }
  
    for(new i = 0; i < TotalHouses; i++)
    {
        if(pickupid == HouseInfo[i][hPickup])
        {
            SetPVarInt(playerid, "PickupDelay", gettime() + 5);

            if(HouseInfo[i][hOwnerID] == 0)
            {
                SetPVarInt(playerid, "BuyHouseID", i);
                new str[512];
                str = "Название\tИнформация\n";
                format(str, sizeof(str), "%s{FFFFFF}Тип:\t{66CC66}%s\n", str, HouseInteriors[HouseInfo[i][hType]][iName]);
                format(str, sizeof(str), "%s{FFFFFF}Номер дома:\t{66CC66}%d\n", str, HouseInfo[i][hID]);
                format(str, sizeof(str), "%s{FFFFFF}Стоимость:\t{66CC66}%d руб\n", str, HouseInfo[i][hPrice]);
                format(str, sizeof(str), "%s{FFFFFF}Ежедневная квартплата:\t{66CC66}%d руб", str, HouseInfo[i][hPrice] / 150);

                ShowPlayerDialog(playerid, DIALOG_BUYHOUSE, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BR BONUS {FFFFFF}| Покупка", str, "Купить", "Отмена");
            }
            else
            {
                SetPVarInt(playerid, "InHouseID", i);
                new str[250];
                format(str, sizeof(str),
                    "{FFFFFF}Вы уверены, что хотите войти в этот дом?\n\n"\
                    "{FFFFFF}Номер дома: {E0584B}%d\n"\
                    "{FFFFFF}Владелец: {E0584B}%s",
                    HouseInfo[i][hID], HouseInfo[i][hOwnerName]
                );

                ShowPlayerDialog(playerid, DIALOG_ENTER_HOUSE, DIALOG_STYLE_MSGBOX,
                    "{E0584B}BR BONUS {FFFFFF}| Вход в дом",
                    str, "Войти", "Отмена");
            }
            return 1;
        }
    }
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vSpawned])
        {
            SendClientMessage(playerid, COLOR_RED, "[Автосалон] Ошибка: Сначала выгрузите свой транспорт (/car)!");
            return 1;
        }
    }

    if(pickupid == pickup_salon_high)
    {
        p_SalonType[playerid] = 0;
        OpenAutoSalon(playerid);
        SendClientMessage(playerid, -1, "{FFD700}[Автосалон]{FFFFFF} Добро пожаловать в салон Высокого класса!");
    }
    else if(pickupid == pickup_salon_medium)
    {
        p_SalonType[playerid] = 1;
        OpenAutoSalon(playerid);
        SendClientMessage(playerid, -1, "{C0C0C0}[Автосалон]{FFFFFF} Добро пожаловать в салон Среднего класса!");
    }
    else if(pickupid == pickup_salon_low)
    {
        p_SalonType[playerid] = 2;
        OpenAutoSalon(playerid);
        SendClientMessage(playerid, -1, "{CD7F32}[Автосалон]{FFFFFF} Добро пожаловать в салон Низкого класса!");
    }
    return 1;
}

forward OnAccountRegisterSetID(playerid);
public OnAccountRegisterSetID(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new mysql_id = cache_insert_id();
    if(mysql_id > 0)
    {
        Player[playerid][pID] = mysql_id;
    }
    return 1;
}

forward OnAccountRegister(playerid);
public OnAccountRegister(playerid)
{
    Player[playerid][pID] = cache_insert_id();

    Player[playerid][pLevel] = 1;
    Player[playerid][pExp] = 0;
    Player[playerid][pMoney] = 150000;
    Player[playerid][pCountTodayCases] = 0;
    Player[playerid][pCountBomjCases] = 1;
    Player[playerid][pCountStandartCases] = 0;
    Player[playerid][pCountCarCases] = 0;
    Player[playerid][pCountOsobiyCases] = 0;
    Player[playerid][pAdminLvl] = 0;
    Player[playerid][pAdminPass] = 0;
    Player[playerid][pVodoItems] = 0;
    Player[playerid][pVodoTime] = 0;
    Player[playerid][pVodoTask] = 0;
    format(Player[playerid][pAdminPrefix], 32, "None");

    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);

    //printf("[MySQL] Аккаунт %s зарегистирован. ID: %d", Player[playerid][pName], Player[playerid][pID]);
    return 1;
}

forward OnAccountLoad(playerid);
public OnAccountLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    if(rows > 0)
    {
        Player[playerid][pID] = cache_get_field_content_int(0, "id", db_handle);
        Player[playerid][pLevel] = cache_get_field_content_int(0, "level", db_handle);
        Player[playerid][pExp] = cache_get_field_content_int(0, "exp", db_handle);
        Player[playerid][pSkin] = cache_get_field_content_int(0, "skin", db_handle);
        Player[playerid][pMoney] = cache_get_field_content_int(0, "money", db_handle);
        Player[playerid][pBC] = cache_get_field_content_int(0, "bc", db_handle);
        Player[playerid][pCountTodayCases] = cache_get_field_content_int(0, "counttodaycases", db_handle);
        Player[playerid][pCountBomjCases] = cache_get_field_content_int(0, "countbomjcases", db_handle);
        Player[playerid][pCountStandartCases] = cache_get_field_content_int(0, "countstandartcases", db_handle);
        Player[playerid][pCountCarCases] = cache_get_field_content_int(0, "countcarcases", db_handle);
        Player[playerid][pCountOsobiyCases] = cache_get_field_content_int(0, "countosobiycases", db_handle);
        Player[playerid][pSimCard] = cache_get_field_content_int(0, "sim_card", db_handle);
        Player[playerid][pVodoItems] = cache_get_field_content_int(0, "vodopr", db_handle);
        Player[playerid][pVodoTime] = cache_get_field_content_int(0, "vodotime", db_handle);
        Player[playerid][pVodoTask] = cache_get_field_content_int(0, "vodozadanie", db_handle);
        Player[playerid][pVipType] = cache_get_field_content_int(0, "vip_type", db_handle);
        Player[playerid][pVipTime] = cache_get_field_content_int(0, "vip_time", db_handle);
		SetPVarInt(playerid, "player_dust", cache_get_field_content_int(0, "dust", db_handle));
        Player[playerid][pAdminLvl] = cache_get_field_content_int(0, "admlvl", db_handle);
        Player[playerid][pAdminPass] = cache_get_field_content_int(0, "admpass", db_handle);
        cache_get_field_content(0, "admprefix", Player[playerid][pAdminPrefix], db_handle, 32);
        
        Player[playerid][pGiftDelay] = cache_get_field_content_int(0, "giftdelay", db_handle);

        Player[playerid][pMuteTime] = cache_get_field_content_int(0, "mute_time", db_handle);
        Player[playerid][pJailTime] = cache_get_field_content_int(0, "jail_time", db_handle);
        Player[playerid][pWarns] = cache_get_field_content_int(0, "warns", db_handle);
        Player[playerid][pBanTime] = cache_get_field_content_int(0, "ban_time", db_handle);
        cache_get_field_content(0, "ban_reason", Player[playerid][pBanReason], db_handle, 64);
        cache_get_field_content(0, "ban_admin", Player[playerid][pBanAdmin], db_handle, 24);

        LoadPlayerBP(playerid);
        Accessory_LoadAllFromDB(playerid);
        Inventory_Load(playerid);

        if(Player[playerid][pBanTime] > 0)
        {
            new string[512], days = Player[playerid][pBanTime] / 1440;
            new hours = (Player[playerid][pBanTime] % 1440) / 60;
            new time_str[64];

            if(Player[playerid][pBanTime] >= 100000) format(time_str, sizeof(time_str), "Навсегда");
            else format(time_str, sizeof(time_str), "%d дн. %d час.", days, hours);

            format(string, sizeof(string),
                "{FFFFFF}Ваш аккаунт заблокирован на сервере {E0584B}BR BONUS{FFFFFF}\n\n"\
                "Причина: {E0584B}%s\n"\
                "Администратор: {FFFFFF}%s\n"\
                "Срок: {FFFFFF}%s\n\n"\
                "Если вы не согласны с наказанием, обратитесь на форум.",
                Player[playerid][pBanReason], Player[playerid][pBanAdmin], time_str);

            ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}BR BONUS | Блокировка", string, "Понятно", "");
            SetTimerEx("KickPublic", 500, false, "i", playerid);
            return 1;
        }
        
        gSimpleAuthPassed[playerid] = true;

        new Node:res = JSON_Object();
        JSON_SetInt(res, "c", 1);
        OnPacketIncoming(playerid, 38, res);
        JSON_Cleanup(res);

        new q[128];
        mysql_format(db_handle, q, sizeof(q), "SELECT * FROM `ownable_cars` WHERE `owner_id` = %d", Player[playerid][pID]);
        mysql_tquery(db_handle, q, "LoadPlayerVehicles", "i", playerid);
        SetTimerEx("LoadPlayerFamily", 500, false, "i", playerid);

        LoadPlayerBP(playerid);

        TogglePlayerSpectating(playerid, false);
        TogglePlayerControllable(playerid, true);

        if(Player[playerid][pSkin] <= 0) Player[playerid][pSkin] = 74;
        new rand = random(sizeof(RandomSpawns));
        SetSpawnInfo(playerid, 0, Player[playerid][pSkin], RandomSpawns[rand][0], RandomSpawns[rand][1], RandomSpawns[rand][2], RandomSpawns[rand][3], 0, 0, 0, 0, 0, 0);
        SpawnPlayer(playerid);
        return 1;
    }
    else
    {
        Player[playerid][pLoginAttempts]++;
        if(Player[playerid][pLoginAttempts] >= 3)
        {
            new Node:res = JSON_Object();
        	JSON_SetInt(res, "c", 1);
        	OnPacketIncoming(playerid, 38, res);
       		JSON_Cleanup(res);
            ShowNotification(playerid, 1, 5, 0, 0, "Вы были кикнуты за превышение попыток ввода пароля!", "");
            SetTimerEx("KickPublic", 500, false, "i", playerid);
        }
        else
        {
            new string[128];
            format(string, sizeof(string), "Неверный пароль! Попыток осталось: %d", 3 - Player[playerid][pLoginAttempts]);
            ShowNotification(playerid, 0, 5, 0, 0, string, "");
        }
    }
    return 1;
}

forward CheckPlayerAccount(playerid);
public CheckPlayerAccount(playerid)
{
    if(gSimpleAuthPassed[playerid]) return 1;
    new rows, fields;
    cache_get_data(rows, fields, db_handle);

    new Node:j = JSON_Object();
    JSON_SetInt(j, "o", 1);
    JSON_SetInt(j, "r", (rows > 0) ? 1 : 0);
    OnPacketIncoming(playerid, 38, j);
    JSON_Cleanup(j);

    return 1;
}

public DestroyVehicleTimer(playerid, seconds)
{
    if(seconds > 0)
    {
        seconds--;
        new fmt_text[145];
        format(fmt_text, sizeof(fmt_text), "Покиньте территорию парковки.\nВремени осталось %d сек.", seconds);
        managerplay(playerid, fmt_text);
        
        KillTimer(DestroyCarTimer[playerid]);
        DestroyCarTimer[playerid] = SetTimerEx("DestroyVehicleTimer", 1000, false, "ii", playerid, seconds);
    }
    else
    {
        if(IsPlayerConnected(playerid) && IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == PlayerDestroyVehicle[playerid])
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            RemovePlayerFromVehicle(playerid);
            DestroyVehicle(vehicleid);
            if(vehicleid == RentVehicle[playerid]) RentVehicle[playerid] = INVALID_VEHICLE_ID;
            ShowNotification(playerid, 1, 5, 0, 0, "Транспорт удалён за нарушение парковки", "");
        }
        managerstop(playerid);
        InDestroyZone[playerid] = false;
        KillTimer(DestroyCarTimer[playerid]);
    }
}

forward GiftTimer();
public GiftTimer()
{
    for(new i = GetPlayerPoolSize(); i >= 0; i--)
    {
        if(!IsPlayerConnected(i) || Player[i][pID] == 0) continue;

        if(Player[i][pGiftDelay] > 0)
        {
            Player[i][pGiftDelay] --;
        }
    }
    return 1;
}
// ----- оч важный сток НЕ ТРОГУТЬ --- //
stock SavePlayerAccount(playerid)
{
    if(Player[playerid][pID] == 0) return 0;

    new query[1400];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `players` SET \
        `level`=%d, `exp`=%d, `skin`=%d, `money`=%d, `bc`=%d, `sim_card`=%d, \
        `admlvl`=%d, `admpass`=%d, `admprefix`='%e', \
        `mute_time`=%d, `jail_time`=%d, `warns`=%d, \
        `ban_time`=%d, `ban_reason`='%e', `ban_admin`='%e', \
        `vip_type`=%d, `vip_time`=%d, `vodopr`=%d, `vodotime`=%d, `vodozadanie`=%d, `dust`=%d \
        WHERE `id`=%d",
        Player[playerid][pLevel], Player[playerid][pExp], Player[playerid][pSkin],
        Player[playerid][pMoney], Player[playerid][pBC], Player[playerid][pSimCard],
        Player[playerid][pAdminLvl], Player[playerid][pAdminPass], Player[playerid][pAdminPrefix],
        Player[playerid][pMuteTime], Player[playerid][pJailTime], Player[playerid][pWarns],
        Player[playerid][pBanTime], Player[playerid][pBanReason], Player[playerid][pBanAdmin],
        Player[playerid][pVipType], Player[playerid][pVipTime], Player[playerid][pVodoItems], Player[playerid][pVodoTime], Player[playerid][pVodoTask], GetPVarInt(playerid, "player_dust"),
        Player[playerid][pID]
    );
    mysql_tquery(db_handle, query, "", "");

    new case_query[400];
    mysql_format(db_handle, case_query, sizeof(case_query),
        "UPDATE `players` SET `counttodaycases`=%d, `countbomjcases`=%d, `countstandartcases`=%d, \
        `countcarcases`=%d, `countosobiycases`=%d, `giftdelay`=%d WHERE `id`=%d",
        Player[playerid][pCountTodayCases],
        Player[playerid][pCountBomjCases],
        Player[playerid][pCountStandartCases],
        Player[playerid][pCountCarCases],
        Player[playerid][pCountOsobiyCases],
        Player[playerid][pGiftDelay],
        Player[playerid][pID]
    );
    mysql_tquery(db_handle, case_query, "", "");

    return 1;
}

stock LoadAndAttachAccessories(playerid)
{
    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `player_accessories` WHERE `uid` = %d", Player[playerid][pID]);
    mysql_tquery(db_handle, query, "OnAccessoriesLoaded", "i", playerid);
}

forward OnAccessoriesLoaded(playerid);
forward LoadPlayerVehicles(playerid);
public OnAccessoriesLoaded(playerid)
{
    new rows = cache_num_rows();
    for(new i = 0; i < rows && i < 10; i++)
    {
        new modelid = cache_get_field_content_int(i, "modelid");
        new bone = cache_get_field_content_int(i, "bone");
        new Float:px = cache_get_field_content_float(i, "pos_x");
        new Float:py = cache_get_field_content_float(i, "pos_y");
        new Float:pz = cache_get_field_content_float(i, "pos_z");
        new Float:rx = cache_get_field_content_float(i, "rot_x");
        new Float:ry = cache_get_field_content_float(i, "rot_y");
        new Float:rz = cache_get_field_content_float(i, "rot_z");
        new Float:sc = cache_get_field_content_float(i, "scale");

        SetPlayerAttachedObject(playerid, i, modelid, bone, px, py, pz, rx, ry, rz, sc, sc, sc);
    }
}

public LoadPlayerVehicles(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    
   	//printf("[DEBUG] Машин найдено: %d", rows);

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        VehicleInfo[playerid][i][vModel] = 0;
        VehicleInfo[playerid][i][vID] = INVALID_VEHICLE_ID;
        VehicleInfo[playerid][i][vSpawned] = false;
        VehicleInfo[playerid][i][vVinyl][0] = '\0';
        VehicleInfo[playerid][i][vStrob] = 5;
    }

    for(new i = 0; i < rows && i < MAX_PLAYER_VEHICLES; i++)
    {
        VehicleInfo[playerid][i][vDBID] = cache_get_field_content_int(i, "id", db_handle);
        VehicleInfo[playerid][i][vModel] = cache_get_field_content_int(i, "model", db_handle);
        VehicleInfo[playerid][i][vColor][0] = cache_get_field_content_int(i, "color1", db_handle);
        VehicleInfo[playerid][i][vColor][1] = cache_get_field_content_int(i, "color2", db_handle);
        VehicleInfo[playerid][i][vBodyColor] = cache_get_field_content_int(i, "body_color", db_handle);
        VehicleInfo[playerid][i][vDiskColor] = cache_get_field_content_int(i, "disk_color", db_handle);
        VehicleInfo[playerid][i][vWheel] = cache_get_field_content_int(i, "wheel", db_handle);
        VehicleInfo[playerid][i][vWindFront] = cache_get_field_content_int(i, "pered_windcolor", db_handle);
        VehicleInfo[playerid][i][vWindRear] = cache_get_field_content_int(i, "zadni_windcolor", db_handle);
        VehicleInfo[playerid][i][vNeonMain] = cache_get_field_content_int(i, "neon_main", db_handle);
        VehicleInfo[playerid][i][vNeon1] = cache_get_field_content_int(i, "neon1", db_handle);
        VehicleInfo[playerid][i][vNeon2] = cache_get_field_content_int(i, "neon2", db_handle);
        VehicleInfo[playerid][i][vLightsColor] = cache_get_field_content_int(i, "lights_color", db_handle);
        VehicleInfo[playerid][i][vStrob] = cache_get_field_content_int(i, "strob", db_handle);
        if(VehicleInfo[playerid][i][vStrob] == 0) VehicleInfo[playerid][i][vStrob] = 5;

        cache_get_field_content(i, "vinyl", VehicleInfo[playerid][i][vVinyl], db_handle, 32);
        VehicleInfo[playerid][i][vSport] = cache_get_field_content_int(i, "sport", db_handle);
        VehicleInfo[playerid][i][vDrift] = cache_get_field_content_int(i, "drift", db_handle);
        VehicleInfo[playerid][i][vComfort] = cache_get_field_content_int(i, "comfort", db_handle);
        VehicleInfo[playerid][i][vSportPlus] = cache_get_field_content_int(i, "sport_plus", db_handle);
        VehicleInfo[playerid][i][vNitro] = cache_get_field_content_int(i, "nitro", db_handle);
        VehicleInfo[playerid][i][vPos][0] = cache_get_field_content_float(i, "x", db_handle);
        VehicleInfo[playerid][i][vPos][1] = cache_get_field_content_float(i, "y", db_handle);
        VehicleInfo[playerid][i][vPos][2] = cache_get_field_content_float(i, "z", db_handle);
        VehicleInfo[playerid][i][vPos][3] = cache_get_field_content_float(i, "a", db_handle);
        VehicleInfo[playerid][i][vDalniysvet] = cache_get_field_content_int(i, "dalniysvet", db_handle);
        VehicleInfo[playerid][i][vClearance] = cache_get_field_content_float(i, "clearance", db_handle);
        VehicleInfo[playerid][i][vClearanceFront] = cache_get_field_content_float(i, "clearance_front", db_handle);
        VehicleInfo[playerid][i][vClearanceRear] = cache_get_field_content_float(i, "clearance_rear", db_handle);
        VehicleInfo[playerid][i][vWheelModel] = cache_get_field_content_int(i, "wheel_model_id", db_handle);
        VehicleInfo[playerid][i][vOffsetFront] = cache_get_field_content_float(i, "offset_front", db_handle);
        VehicleInfo[playerid][i][vOffsetRear] = cache_get_field_content_float(i, "offset_rear", db_handle);
        VehicleInfo[playerid][i][vCamberFront] = cache_get_field_content_float(i, "camber_front", db_handle);
        VehicleInfo[playerid][i][vCamberRear] = cache_get_field_content_float(i, "camber_rear", db_handle);
        VehicleInfo[playerid][i][vWheelWidthFront] = cache_get_field_content_float(i, "wheel_width_front", db_handle);
        VehicleInfo[playerid][i][vWheelWidthRear] = cache_get_field_content_float(i, "wheel_width_rear", db_handle);
        VehicleInfo[playerid][i][vWheelRadius] = cache_get_field_content_float(i, "wheel_radius", db_handle);
        VehicleInfo[playerid][i][vHydra] = cache_get_field_content_int(i, "hydra", db_handle);
        VehicleInfo[playerid][i][vPnevmo] = cache_get_field_content_int(i, "pnevmo", db_handle);
        VehicleInfo[playerid][i][vHydraInstalled] = cache_get_field_content_int(i, "hydra");
        VehicleInfo[playerid][i][vPnevmoInstalled] = cache_get_field_content_int(i, "pnevmo");

        VehicleInfo[playerid][i][vID] = INVALID_VEHICLE_ID;
        VehicleInfo[playerid][i][vSpawned] = false;
    }

    if(Player[playerid][pJailTime] > 0) JailSystem(playerid);

    new Node:res = JSON_Object();
    JSON_SetInt(res, "c", 1);
    OnPacketIncoming(playerid, 38, res);
    JSON_Cleanup(res);

    return 1;
}

forward DoubleTimeTimer();
public DoubleTimeTimer()
{
    PayDayMinutesCount++;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;

        ShowDoubleTime(i);

        Player[i][pSecondsHour] += 300;

        if(PayDayMinutesCount >= 12)
        {
            if(Player[i][pSecondsHour] >= 900)
            {
                new exp_amount = 1;
                new bc_amount = 0;

                if(Player[i][pVipTime] > 0)
                {
                    Player[i][pVipTime] -= 60;
                    if(Player[i][pVipTime] < 0) Player[i][pVipTime] = 0;

                    switch(Player[i][pVipType])
                    {
                        case 1: { bc_amount = 200; exp_amount = 1; }
                        case 2: { bc_amount = 500; exp_amount = 2; }
                        case 3: { bc_amount = 800; exp_amount = 3; }
                    }
                }

                Player[i][pExp] += exp_amount;
                Player[i][pLevel] = (Player[i][pExp] / 4) + 1;
                SetPlayerScore(i, Player[i][pLevel]);

                if(bc_amount > 0) GivePlayerBlackCoin(i, bc_amount);

                SendClientMessage(i, 0xFFFF00FF, "--------- PAYDAY ---------");

                if(Player[i][pVipTime] == 0 && Player[i][pVipType] > 0)
                {
                    Player[i][pVipType] = 0;
                    SendClientMessage(i, 0xFF0000FF, "Срок действие Вашего VIP статуса истек!");
                }
            }
            Player[i][pSecondsHour] = 0;
        }
    }

    if(PayDayMinutesCount >= 12) PayDayMinutesCount = 0;
    return 1;
}

new Float:SalonSpawnCoordsLow[][] = {
    {2491.3955, -760.3754, 11.3192, 359.3163},
    {2491.6113, -741.9573, 11.3309, 359.3163},
    {2498.1772, -760.7000, 11.3195, 359.3163},
    {2498.1313, -742.0123, 11.3729, 359.3163},
    {2505.1767, -760.3374, 11.3196, 359.3163},
    {2505.3037, -742.1876, 11.3587, 359.3163},
    {2515.1606, -760.1191, 11.3196, 359.3163},
    {2515.1691, -742.4080, 11.3610, 359.3163}
};

new Float:SalonSpawnCoordsHigh[][] = {
    {670.1483, 2642.4289, 12.6087, 120.5313},
    {666.0426, 2635.0915, 12.6087, 120.5313},
    {661.5058, 2628.1518, 12.6087, 120.5313},
    {655.0651, 2616.9050, 12.6087, 120.5313},
    {591.9766, 2680.5249, 12.6087, 120.5313},
    {582.9478, 2665.9633, 12.6087, 120.5313},
    {565.5269, 2635.7612, 12.6087, 120.5313}
};

new Float:SalonSpawnCoordsMedium[][] = {
    {1375.0767, 435.0506, 12.6733, 50.5162},
    {1391.7937, 425.2384, 12.6749, 50.5162},
    {1403.1876, 435.3938, 12.6725, 50.5162},
    {1386.5764, 444.5348, 12.6747, 50.5162},
    {1372.5307, 453.2572, 12.6748, 50.5162},
    {1364.8300, 493.3633, 12.6745, 50.5162},
    {1370.7468, 505.6065, 12.6734, 50.5162}
};

forward OnCarPurchased(playerid, slot);
public OnCarPurchased(playerid, slot)
{
    VehicleInfo[playerid][slot][vDBID] = cache_insert_id();
    new r;

    if(p_SalonType[playerid] == 0)
    {
        r = random(sizeof(SalonSpawnCoordsHigh));
        for(new i=0; i<4; i++) VehicleInfo[playerid][slot][vPos][i] = SalonSpawnCoordsHigh[r][i];
    }
    else if(p_SalonType[playerid] == 1)
    {
        r = random(sizeof(SalonSpawnCoordsMedium));
        for(new i=0; i<4; i++) VehicleInfo[playerid][slot][vPos][i] = SalonSpawnCoordsMedium[r][i];
    }
    else
    {
        r = random(sizeof(SalonSpawnCoordsLow));
        for(new i=0; i<4; i++) VehicleInfo[playerid][slot][vPos][i] = SalonSpawnCoordsLow[r][i];
    }

    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `ownable_cars` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f' WHERE `id`='%d'",
        VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1],
        VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3],
        VehicleInfo[playerid][slot][vDBID]);
    mysql_tquery(db_handle, query);

    VehicleInfo[playerid][slot][vID] = CreateVehicle(
        VehicleInfo[playerid][slot][vModel],
        VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1],
        VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3],
        VehicleInfo[playerid][slot][vColor][0], VehicleInfo[playerid][slot][vColor][1], -1
    );
    
    if(p_SalonWheelID[playerid] > 0)
    {
        new wheelid = SalonWheels[p_SalonWheelID[playerid]];
        AddVehicleComponent(VehicleInfo[playerid][slot][vID], wheelid);
        VehicleInfo[playerid][slot][vWheel] = wheelid;

        mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `wheel`='%d' WHERE `id`='%d'", wheelid, VehicleInfo[playerid][slot][vDBID]);
        mysql_tquery(db_handle, query);
    }

    VehicleInfo[playerid][slot][vSpawned] = true;
    SendClientMessage(playerid, COLOR_WHITE, "Транспорт куплен и доставлен на парковку!");
    
    if(VehicleInfo[playerid][slot][vNitro] > 0)
{
    AddVehicleComponent(VehicleInfo[playerid][slot][vID], 1007 + VehicleInfo[playerid][slot][vNitro]);
}
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(Accessory_HandleTextDraw(playerid, clickedid)) return 1;
    if(Accessory_MarketHandleTextDraw(playerid, clickedid)) return 1;

    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == avtsln_PTD[playerid][0])
    {
        new id = p_SalonCarID[playerid], car_price, car_name[32];
        if(p_SalonType[playerid] == 0) { car_price = SalonCars[id][sPrice]; strmid(car_name, SalonCars[id][sName], 0, strlen(SalonCars[id][sName]), 32); }
        else if(p_SalonType[playerid] == 1) { car_price = MediumSalonCars[id][sPrice]; strmid(car_name, MediumSalonCars[id][sName], 0, strlen(MediumSalonCars[id][sName]), 32); }
        else { car_price = LowSalonCars[id][sPrice]; strmid(car_name, LowSalonCars[id][sName], 0, strlen(LowSalonCars[id][sName]), 32); }

        if(Player[playerid][pMoney] < car_price) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] У вас недостаточно денег!");

        new slot = -1;
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) if(VehicleInfo[playerid][i][vModel] == 0) { slot = i; break; }
        if(slot == -1) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] У вас нет свободных слотов!");

        new string[256];
        format(string, sizeof(string), "{FFFFFF}Параметр\t{FFFFFF}Значение\n{FFFFFF}Модель\t{FF4A4A}%s\n{FFFFFF}Цена\t{00FF00}%d RUB\n{FFFFFF}Цвет 1\t{66CC66}%d\n{FFFFFF}Цвет 2\t{66CC66}%d", car_name, car_price, p_SalonColor[playerid][0], p_SalonColor[playerid][1]);
        SetPVarInt(playerid, "BuyCarID", id);
        ShowPlayerDialog(playerid, DIALOG_BUY_CAR_CONFIRM, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BR BONUS {FFFFFF}| Автосалон", string, "Купить", "Отмена");
        return 1;
    }

    if(playertextid == avtsln_PTD[playerid][1]) return HideAvtosalon(playerid);

    if(playertextid == avtsln_PTD[playerid][3])
    {
        new max_id = (p_SalonType[playerid] == 0) ? sizeof(SalonCars) : (p_SalonType[playerid] == 1) ? sizeof(MediumSalonCars) : sizeof(LowSalonCars);
        p_SalonCarID[playerid] = (p_SalonCarID[playerid] >= max_id - 1) ? 0 : p_SalonCarID[playerid] + 1;
        UpdateSalonVehicle(playerid, true);
        return 1;
    }

    if(playertextid == avtsln_PTD[playerid][4])
    {
        new max_id = (p_SalonType[playerid] == 0) ? sizeof(SalonCars) : (p_SalonType[playerid] == 1) ? sizeof(MediumSalonCars) : sizeof(LowSalonCars);
        p_SalonCarID[playerid] = (p_SalonCarID[playerid] <= 0) ? max_id - 1 : p_SalonCarID[playerid] - 1;
        UpdateSalonVehicle(playerid, true);
        return 1;
    }

    if(playertextid == avtsln_PTD[playerid][8]) { p_SalonColor[playerid][0] = (p_SalonColor[playerid][0] >= 126) ? 0 : p_SalonColor[playerid][0] + 1; ChangeVehicleColor(p_BuyCar[playerid], p_SalonColor[playerid][0], p_SalonColor[playerid][1]); return 1; }
    if(playertextid == avtsln_PTD[playerid][10]) { p_SalonColor[playerid][0] = (p_SalonColor[playerid][0] <= 0) ? 126 : p_SalonColor[playerid][0] - 1; ChangeVehicleColor(p_BuyCar[playerid], p_SalonColor[playerid][0], p_SalonColor[playerid][1]); return 1; }
    if(playertextid == avtsln_PTD[playerid][7]) { p_SalonWheelID[playerid] = (p_SalonWheelID[playerid] >= sizeof(SalonWheels)-1) ? 0 : p_SalonWheelID[playerid] + 1; UpdateSalonVehicle(playerid, false); return 1; }
    if(playertextid == avtsln_PTD[playerid][9]) { p_SalonWheelID[playerid] = (p_SalonWheelID[playerid] <= 0) ? sizeof(SalonWheels)-1 : p_SalonWheelID[playerid] - 1; UpdateSalonVehicle(playerid, false); return 1; }

    return 0;
}

stock SendAdminMessage(color, string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && Player[i][pAdminAuth]) SendClientMessage(i, color, string);
    return 1;
}

stock ProxDetector(Float:radi, playerid, string[], color)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
            if(IsPlayerInRangeOfPoint(i, radi, x, y, z)) SendClientMessage(i, color, string);
    }
    return 1;
}

forward SetRandomSpawn(playerid);
public SetRandomSpawn(playerid)
{
    new r = random(sizeof(RandomSpawns));
    SetCameraBehindPlayer(playerid);
    SetPlayerPos(playerid, RandomSpawns[r][0], RandomSpawns[r][1], RandomSpawns[r][2]);
    SetPlayerFacingAngle(playerid, RandomSpawns[r][3]);
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(Player[playerid][pMuteTime] > 0)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "У Вас имеется мут!", "");

        SetPlayerChatBubble(playerid, "(( MUTED ))", 0xE0584BFF, 10.0, 5000);

        return 0;
    }

    new s[144];
    format(s, sizeof(s), "%s[%d]: %s", Player[playerid][pName], playerid, text);
    ProxDetector(20.0, playerid, s, COLOR_WHITE);

    return 0;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "Введенная вами команда не найдена!", "");
        return 0;
    }
    return 1;
}

stock ShowNotificationMemory(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    OnPacketIncoming(playerid, 13, JSONObject);
}

stock GivePlayerMoneyEx(playerid, amount)
{
    Player[playerid][pMoney] += amount;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);

    new fmt_str[64];
    if (amount < 0)
    {
        format(fmt_str, sizeof(fmt_str), "{00CCFF}[Информация] {FFFFFF}Вы потратили %d рублей.", -amount);
        ShowNotification(playerid, 0, 5, 0, 1, fmt_str, "");
    }
    else
    {
        format(fmt_str, sizeof(fmt_str), "{00CCFF}[Информация] {FFFFFF}Вы получили %d рублей.", amount);
        ShowNotification(playerid, 1, 5, 0, 1, fmt_str, "");
    }

    SavePlayerAccount(playerid);
    return 1;
}

stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    if(IsPlayerConnected(playerid))
    {
        format(name, sizeof(name), "%s", Player[playerid][pName]);
    }
    return name;
}

stock GetPlayerMoneyEx(playerid)
{
    return Player[playerid][pMoney];
}

public OnPlayerEnterCheckpoint(playerid)
{
    DisablePlayerCheckpoint(playerid);
    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for(new i = 0; i < TotalTransportSpots; i++)
    {
        if(areaid == TransportSpots[i][tZone] && InDestroyZone[playerid])
        {
            InDestroyZone[playerid] = false;
            managerstop(playerid);
            KillTimer(DestroyCarTimer[playerid]);
            return 1;
        }
    }
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < TotalTransportSpots; i++)
{
    if(areaid == TransportSpots[i][tZone] && IsPlayerInAnyVehicle(playerid))
    {
        if(GetPlayerVehicleID(playerid) == RentVehicle[playerid])
        {
            InDestroyZone[playerid] = true;
            PlayerDestroyVehicle[playerid] = GetPlayerVehicleID(playerid);
            
            new fmt_text[145];
            format(fmt_text, sizeof(fmt_text), "Покиньте территорию парковки.\nВремени осталось 30 сек.");
            managerplay(playerid, fmt_text);
            
            KillTimer(DestroyCarTimer[playerid]);
            DestroyCarTimer[playerid] = SetTimerEx("DestroyVehicleTimer", 1000, false, "ii", playerid, 30);
            return 1;
        }
    }
}

    if(Vodolaz_OnPlayerEnterDynamicArea(playerid, areaid)) return 1;

    if(areaid == factory_area)
    {
        new dialogStr[128];
        if(IsFactoryWorker[playerid]) format(dialogStr, sizeof(dialogStr), "Уволиться с завода\nИнформация о работе");
        else format(dialogStr, sizeof(dialogStr), "Устроиться на завод\nИнформация о работе");
        
        ShowPlayerDialog(playerid, DIALOG_FACTORY_JOB, DIALOG_STYLE_LIST, "{FF9900}Завод", dialogStr, "Выбрать", "Отмена");
        return 1;
    }

    if(!IsFactoryWorker[playerid] || IsCrafting[playerid]) return 1;


    if(PlayerRawKg[playerid] == 0 && PlayerProductKg[playerid] == 0)
    {
        for(new i = 0; i < MAX_RAW_POINTS; i++)
        {
            if(areaid == RawAreas[i])
            {
                PlayerRawKg[playerid] = 10 + random(16); // От 10 до 25 кг
                ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
                SetPlayerAttachedObject(playerid, 1, 1220, 5, 0.0, 0.2, 0.0, 0.0, 0.0, 0.0); 
                
                new str[128];
                format(str, sizeof(str), "{FFFF00}Вы взяли %d кг сырья. Несите его к любому свободному станку.", PlayerRawKg[playerid]);
                SendClientMessage(playerid, -1, str);
                return 1;
            }
        }
    }

    if(PlayerRawKg[playerid] > 0)
    {
        for(new i = 0; i < MAX_CRAFT_POINTS; i++)
        {
            if(areaid == CraftAreas[i])
            {
                StartFactoryCrafting(playerid);
                return 1;
            }
        }
    }

    if(PlayerProductKg[playerid] > 0)
    {
        if(areaid == DropArea)
        {
            FinishFactoryDrop(playerid);
            return 1;
        }
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    //загрушка, убираю говнокод
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(Player[playerid][pAdminAuth] && Player[playerid][pAdminLvl] >= 1)
    {
        MapTPPos[playerid][0] = fX;
        MapTPPos[playerid][1] = fY;
        MapTPPos[playerid][2] = fZ;

        ShowPlayerDialog(playerid, DIALOG_MAP_TP, DIALOG_STYLE_MSGBOX,
            "{E0584B}Телепортация",
            "{FFFFFF}Вы действительно хотите телепортироваться в указанную точку?",
            "Да", "Отмена");
    }
    return 1;
}
public OnVehicleStreamIn(vehicleid, forplayerid)
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
        {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid)
            {
                if(VehicleInfo[i][v][vBodyColor] != 0 || VehicleInfo[i][v][vDiskColor] != 0)
                {
                    new BitStream:bs = BS_New();
                    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x12, PR_UINT32, VehicleInfo[i][v][vBodyColor], PR_UINT32, VehicleInfo[i][v][vDiskColor], PR_UINT32, VehicleInfo[i][v][vDiskColor], PR_UINT32, VehicleInfo[i][v][vDiskColor]);
                    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    BS_Delete(bs);
                }

                if(VehicleInfo[i][v][vLightsColor] != 0)
                {
                    SetVehicleLightsColorHEX(forplayerid, vehicleid, VehicleInfo[i][v][vLightsColor]);
                }

                if(VehicleInfo[i][v][vWindFront] != 0 || VehicleInfo[i][v][vWindRear] != 0)
                {
                    new BitStream:bs = BS_New();
                    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x00, PR_UINT32, VehicleInfo[i][v][vWindFront], PR_UINT32, VehicleInfo[i][v][vWindRear], PR_UINT32, VehicleInfo[i][v][vWindFront], PR_UINT32, VehicleInfo[i][v][vWindRear]);
                    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    BS_Delete(bs);
                }

                if(VehicleInfo[i][v][vNeonMain] != 0 || VehicleInfo[i][v][vNeon1] != 0 || VehicleInfo[i][v][vNeon2] != 0)
                {
                    new BitStream:bs = BS_New();
                    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x09, PR_UINT32, VehicleInfo[i][v][vNeonMain], PR_UINT32, VehicleInfo[i][v][vNeon1], PR_UINT32, VehicleInfo[i][v][vNeon2]);
                    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    BS_Delete(bs);
                }
                
				if(VehicleInfo[i][v][vVinyl][0] != '\0')
                {
                    SetVehicleVinylForPlayer(forplayerid, vehicleid, VehicleInfo[i][v][vVinyl]);
                }
                
                if(VehicleInfo[i][v][vDalniysvet])
                {
                    SetVehicleDlaniy(forplayerid, vehicleid, VehicleInfo[i][v][Dalniysvet] ? 1 : 0);
                }

                new type_to_send = (VehicleInfo[i][v][vStrobState]) ? VehicleInfo[i][v][vStrob] : 5;
                SetVehicleStroboscopeForPlayer(forplayerid, vehicleid, type_to_send);
                return 1;
            }
        }
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_CROUCH)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, -426.235290, 1005.412658, 12.307508) ||
           IsPlayerInRangeOfPoint(playerid, 5.0, -420.054534, 1005.409240, 12.307003) ||
           IsPlayerInRangeOfPoint(playerid, 5.0, -413.549285, 1005.543029, 12.326748))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(!vehicleid) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны находиться в личном транспорте");

            if(GetPlayerVehicleSlot(playerid, vehicleid) == -1)
                return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны быть за рулем своего личного транспорта");

            callcmd::techcentergui(playerid, "");
            return 1;
        }

        if(IsPlayerInRangeOfPoint(playerid, 5.0, 2311.418945, -2607.487304, 21.808467) ||
           IsPlayerInRangeOfPoint(playerid, 5.0, 2311.424804, -2613.460937, 21.808467))
        {
 			new vehicleid = GetPlayerVehicleID(playerid);
            if(GetPlayerVehicleSlot(playerid, vehicleid) == -1)
            if(!vehicleid) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Доступно только на личном транспорте!");

            callcmd::tungui(playerid, "");
            return 1;
        }
    }
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
{
    if(GetPlayerVehicleID(playerid) == RentVehicle[playerid])
    {
        KillTimer(RentTimer[playerid]);
        RentTimer[playerid] = SetTimerEx("RemoveRentVehicle", 90000, 0, "i", playerid);
        ShowNotification(playerid, 1, 5, 0, 0, "Вы слезли с мотоцикла он будет удален через 90 секунд!", "");
    }
}
if(newstate == PLAYER_STATE_DRIVER)
{
    if(GetPlayerVehicleID(playerid) == RentVehicle[playerid])
    {
        KillTimer(RentTimer[playerid]);
    }
}

    if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
    {
        StopPlayerVehicleTurnSignal(playerid);
    }

    for(new i = 0; i <= GetPlayerPoolSize(); i++)
    {
        if(IsPlayerConnected(i) && GetPVarInt(i, "IsSpectating") && GetPVarInt(i, "SpectatingID") == playerid)
        {
            if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
            {
                PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
            }
            else if(newstate == PLAYER_STATE_ONFOOT)
            {
                PlayerSpectatePlayer(i, playerid);
            }
        }
    }
    if(oldstate == PLAYER_STATE_DRIVER)
    {
        new old_vehicleid = GetPlayerVehicleID(playerid);
        if(old_vehicleid != INVALID_VEHICLE_ID)
        {
            SetVehicleAcceleration(old_vehicleid, 0.0);
            SetVehicleDriftMode(playerid, old_vehicleid, false);
        }
    }

	if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new slot = GetPlayerVehicleSlot(playerid, vehicleid);
        new owner = playerid;

        if(slot != -1)
        {
            new nitro_type = VehicleInfo[playerid][slot][vNitro];
            if(nitro_type > 0)
            {
                new component_id = 1007 + nitro_type;
                if(!GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO))
                {
                    AddVehicleComponent(vehicleid, component_id);
                }
            }
        }
        else
        {
            for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
            {
                if(!IsPlayerConnected(i)) continue;
                slot = GetPlayerVehicleSlot(i, vehicleid);
                if(slot != -1)
                {
                    owner = i;
                    break;
                }
            }
        }

        if(slot != -1)
        {
            if(VehicleInfo[owner][slot][vComfortA]) SetVehicleAcceleration(vehicleid, 31.8);
            else if(VehicleInfo[owner][slot][vSportA]) SetVehicleAcceleration(vehicleid, 35.0);
            else if(VehicleInfo[owner][slot][vSportPlusA]) SetVehicleAcceleration(vehicleid, 36.0);
            else SetVehicleAcceleration(vehicleid, 0.0);

            SetVehicleDriftMode(playerid, vehicleid, VehicleInfo[owner][slot][vDriftA]);
        }
    }
    return 1;
}

CMD:car(playerid)
{
    new spawned_slot = -1;
    new total_cars = 0;

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vModel] != 0)
        {
            total_cars++;

            if(VehicleInfo[playerid][i][vSpawned])
            {
                spawned_slot = i;
                break;
            }
        }
    }

    if(spawned_slot != -1)
    {
        SetPVarInt(playerid, "SelectedCarSlot", spawned_slot);
        ShowCarActionMenu(playerid, spawned_slot);
    }
    else
    {
        if(total_cars == 0)
        {
            ShowNotification(playerid, 0, 5, 0, 0, "У вас нет личного транспорта!", "");
        }
        else
        {
            DeletePVar(playerid, "CarMenuPage");
            ShowPlayerCars(playerid, 0);
        }
    }
    return 1;
}

stock ShowPlayerCars(playerid, page)
{
    new string[1536], count = 0, total = 0;
    format(string, sizeof(string), "Модель    Состояние    Слот\n");

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vModel] == 0) continue;

        if(total >= page * 10 && count < 10)
        {
            format(string, sizeof(string), "%s{FFFFFF}%s    %s    {AAAAAA}#%d\n",
                string,
                GetVehicleNameByModel(VehicleInfo[playerid][i][vModel]),
                (VehicleInfo[playerid][i][vSpawned]) ? ("{4682B4}Загружен") : ("{E0584B}Выгружен"),
                i + 1
            );
            count++;
        }
        total++;
    }

    if(total == 0) return SendClientMessage(playerid, COLOR_RED, "У вас нет личного транспорта!");

    if(total > (page + 1) * 10)
        strcat(string, "{FF9900}>>>    Следующая страница     \n");

    if(page > 0)
        strcat(string, "{FF9900}<<<    Предыдущая страница     \n");

    SetPVarInt(playerid, "CarMenuPage", page);
    ShowPlayerDialog(playerid, DIALOG_MY_CARS, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BR BONUS {FFFFFF}| Транспорты", string, "Выбрать", "Отмена");
    return 1;
}

// ------ варнинги сосут ----- //
#pragma warning disable 208
#pragma warning disable 200
#pragma warning disable 224
// -------------------------------------- //

stock ShowCarActionMenu(playerid, car_slot)
{
    new menu_str[256];
    strcat(menu_str, "Действие с т/с\n");
    strcat(menu_str, "Отметить на GPS\n");

    if(VehicleInfo[playerid][car_slot][vSpawned] == true)
    {
        strcat(menu_str, "Выгрузить транспорт");
    }
    else
    {
        strcat(menu_str, "Заспавнить транспорт");
    }

    ShowPlayerDialog(playerid, DIALOG_CAR_ACTION, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BR BONUS {FFFFFF}| Управление", menu_str, "Далее", "Назад");
    return 1;
}

stock SetGPSMarker(playerid, Float:x, Float:y, Float:z)
{
    if(!IsPlayerConnected(playerid) || playerid == INVALID_PLAYER_ID)
        return 0;

    new BitStream:bs = BS_New();

    if(bs == BitStream:0)
        return 0;

    BS_WriteValue(bs,
        PR_UINT8, 26,
        PR_UINT32, 0x00FFFFFF,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z
    );

    if(IsPlayerConnected(playerid))
    {
        PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    }
    SetPlayerCheckpoint(playerid, x, y, z, 4.0);
    ShowNotification(playerid, 3, 5, 0, 1, "GPS отмечено на карте", "");

    BS_Delete(bs);
    return 1;
}

CMD:mycoord(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;

    new Float:x, Float:y, Float:z, Float:a;
    new str[144];

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    format(str, sizeof(str), "{FFFF00}| {FFFFFF}Вы находитесь на координатах: X: %.4f | Y: %.4f | Z: %.4f | A: %.4f", x, y, z, a);

    SendClientMessage(playerid, -1, str);

    new log_str[180];
    format(log_str, sizeof(log_str), "[COORD LOG] Админ %s[%d]: %.4f, %.4f, %.4f, %.4f", Player[playerid][pName], playerid, x, y, z, a);
    print(log_str);

    return 1;
}

CMD:park(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Вы должны быть в машине!");

    new vehid = GetPlayerVehicleID(playerid);
    new slot = -1;

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
        if(VehicleInfo[playerid][i][vID] == vehid) {
            slot = i;
            break;
        }
    }

    if(slot == -1) return SendClientMessage(playerid, COLOR_RED, "Это не ваш личный транспорт!");

    GetVehiclePos(vehid, VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1], VehicleInfo[playerid][slot][vPos][2]);
    GetVehicleZAngle(vehid, VehicleInfo[playerid][slot][vPos][3]);

    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `ownable_cars` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f' WHERE `id`='%d'",
        VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1],
        VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3],
        VehicleInfo[playerid][slot][vDBID]);
    mysql_tquery(db_handle, query);

    SendClientMessage(playerid, COLOR_WHITE, "Транспорт припаркован!");
    return 1;
}

CMD:radial(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return 1;

    new vehicleid = GetPlayerVehicleID(playerid);
    new owner = -1, slot = -1;
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
        {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid)
            {
                owner = i;
                slot = v;
                break;
            }
        }
        if(owner != -1) break;
    }

    new Node:radial_json = JSON_Object();
    new Node:Info = JSON_Array();

    JSON_SetInt(radial_json, "o", 1);

    Info = JSON_Append(Info, JSON_Array(JSON_Int(1)));

    if(GetVehicleParam(vehicleid, V_LOCK))   Info = JSON_Append(Info, JSON_Array(JSON_Int(3)));
    if(GetVehicleParam(vehicleid, V_ENGINE)) Info = JSON_Append(Info, JSON_Array(JSON_Int(6)));
    if(GetVehicleParam(vehicleid, V_LIGHTS)) Info = JSON_Append(Info, JSON_Array(JSON_Int(14)));

    if(slot != -1)
    {
        if(VehicleInfo[owner][slot][vDriftA])     Info = JSON_Append(Info, JSON_Array(JSON_Int(8), JSON_Int(1)));
        if(VehicleInfo[owner][slot][vComfortA])   Info = JSON_Append(Info, JSON_Array(JSON_Int(9), JSON_Int(1)));
        if(VehicleInfo[owner][slot][vSportA])     Info = JSON_Append(Info, JSON_Array(JSON_Int(10), JSON_Int(1)));
        if(VehicleInfo[owner][slot][vSportPlusA]) Info = JSON_Append(Info, JSON_Array(JSON_Int(11), JSON_Int(1)));
        
        if(VehicleInfo[owner][slot][vStrob] > 0)
        {
            if(VehicleInfo[owner][slot][vStrobState]) Info = JSON_Append(Info, JSON_Array(JSON_Int(15)));
        }
        
        if(VehicleInfo[owner][slot][vDalniysvet] > 0)
        {
            Info = JSON_Append(Info, JSON_Array(JSON_Int(13)));
        }
    }

    JSON_SetArray(radial_json, "s", Info);

    OnPacketIncoming(playerid, 27, radial_json);

    JSON_Cleanup(radial_json);
    JSON_Cleanup(Info);

    return 1;
}

stock SetVehicleParamsInit(vehicleid)
{
    g_vehicle_params[vehicleid][V_ENGINE]    = true;
    g_vehicle_params[vehicleid][V_LIGHTS]    = false; 
    g_vehicle_params[vehicleid][V_ALARM]     = false;
    g_vehicle_params[vehicleid][V_LOCK]      = false; 
    g_vehicle_params[vehicleid][V_BONNET]    = false;
    g_vehicle_params[vehicleid][V_BOOT]      = false;
    g_vehicle_params[vehicleid][V_OBJECTIVE] = false;

    SetVehicleParamsEx(vehicleid, 1, 0, 0, 0, 0, 0, 0);
    return 1;
}

stock GetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid)
{
    return _:g_vehicle_params[vehicleid][paramid];
}

stock SetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid, set_value)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    g_vehicle_params[vehicleid][paramid] = bool:set_value;

    switch(paramid)
    {
        case V_ENGINE:    engine = set_value;
        case V_LIGHTS:    lights = set_value;
        case V_ALARM:     alarm = set_value;
        case V_LOCK:      doors = set_value;
        case V_BONNET:    bonnet = set_value;
        case V_BOOT:      boot = set_value;
        case V_OBJECTIVE: objective = set_value;
    }

    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}

stock IsABike(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
    return (model == 481 || model == 509 || model == 510);
}

alias:e("en")
CMD:e(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    if(IsABike(vehicleid)) return 1;

    SetVehicleParam(vehicleid, V_ENGINE, !GetVehicleParam(vehicleid, V_ENGINE));
    return 1;
}

CMD:lk(playerid)
{
    new vehicleid = INVALID_VEHICLE_ID;
    if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);
    else
    {
        for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
        {
            if(!GetVehicleModel(i)) continue;
            new Float:pos[3];
            GetVehiclePos(i, pos[0], pos[1], pos[2]);
            if(IsPlayerInRangeOfPoint(playerid, 4.0, pos[0], pos[1], pos[2])) { vehicleid = i; break; }
        }
    }

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "Поблизости нет транспорта!", "");
        return 1;
    }

    new bool:canAccess = false;
    if(Player[playerid][pAdminVeh] == vehicleid) canAccess = true;

    if(!canAccess)
    {
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
        {
            if(VehicleInfo[playerid][i][vSpawned] && VehicleInfo[playerid][i][vID] == vehicleid)
            {
                canAccess = true;
                break;
            }
        }
    }

    if(!canAccess)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "У вас нет ключей от этого транспорта!", "");
        return 1;
    }

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    new name[MAX_PLAYER_NAME], str[128];
    GetPlayerName(playerid, name, sizeof(name));

    if(doors)
    {
        SetVehicleParam(vehicleid, V_LOCK, 0);
        format(str, sizeof(str), "{FF90FF}%s открыл(а) транспорт", name);
        PlayAudioStreamURL(playerid, "vehicle_sound_alarm.mp3");
    }
    else
    {
        SetVehicleParam(vehicleid, V_LOCK, 1);
        format(str, sizeof(str), "{FF90FF}%s закрыл(а) транспорт", name);
        PlayAudioStreamURL(playerid, "vehicle_sound_door.mp3");
    }

    SendClientMessage(playerid, 0xFFFF90FF, str);
    return 1;
}

CMD:l(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    new new_lights = !lights;
    SetVehicleParam(vehicleid, V_LIGHTS, new_lights);

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerStreamedIn(vehicleid, i)) continue;

        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(!IsPlayerConnected(p)) continue;
            for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
            {
                if(VehicleInfo[p][v][vSpawned] && VehicleInfo[p][v][vID] == vehicleid)
                {
                    if(new_lights == 1)
                    {
                        if(VehicleInfo[p][v][vLightsColor] != 0)
                        {
                            SetVehicleLightsColorHEX(i, vehicleid, VehicleInfo[p][v][vLightsColor]);
                        }
                    }
                }
            }
        }
    }
    return 1;
}

CMD:askin(playerid)
{
	if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;

	if(GetPlayerSkin(playerid) == 122)
	{
		SetPlayerSkin(playerid, Player[playerid][pSkin]);
		SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы {FFFF00}сняли{FFFFFF} с себя скин {FFFF00}администратора.");
	}
	else
	{
		SetPlayerSkin(playerid, 122);
		SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы{FFFF00} надели{FFFFFF} на себя скин {FFFF00}администратора.");
	}
	return 1;
}


forward UpdatePunishments();
public UpdatePunishments()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || Player[i][pID] == 0) continue;

        new bool:changed = false;

        if(Player[i][pMuteTime] > 0)
        {
            Player[i][pMuteTime]--;
            changed = true;
        }

        if(Player[i][pJailTime] > 0)
        {
            Player[i][pJailTime]--;
            changed = true;

            if(Player[i][pJailTime] <= 0)
            {
                SetPlayerPos(i, 1345.0, 123.0, 1245.0);
                SetPlayerInterior(i, 0);
                SetPlayerVirtualWorld(i, 0);
                SendClientMessage(i, COLOR_WHITE, "{4682B4}[Информация] {FFFFFF}Срок вашего заключения окончен. Не нарушайте!");
            }
        }

        if(changed)
        {
            new query[128];
            mysql_format(db_handle, query, sizeof(query),
                "UPDATE `players` SET `mute_time` = %d, `jail_time` = %d WHERE `id` = %d",
                Player[i][pMuteTime], Player[i][pJailTime], Player[i][pID]);
            mysql_tquery(db_handle, query);
        }
    }
    return 1;
}

// ----- информирую что ---- //

stock managerplay(playerid, guitxt[])
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "m", 0);
    JSON_SetString(json, "s", guitxt);
    ShowPlayerGUI(playerid, 39, json);
    JSON_Cleanup(json);
}

stock managerstop(playerid)
{
    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    JSON_SetInt(close_json, "t", 4);
    OnPacketIncoming(playerid, 39, close_json);
    JSON_Cleanup(close_json);
}

stock JailSystem(playerid)
{
    SetPlayerPos(playerid, -972.276489, 513.131103, 592.786071);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);
    SendClientMessage(playerid, COLOR_RED, "Вы отбываете наказание в деморгане. Используйте /time для просмотра срока.");
    return 1;
}

CMD:time(playerid)
{
    new hour, minute, second, day, month, year;
    gettime(hour, minute, second);
    getdate(year, month, day);

    static const month_names[][] = {"", "января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"};
    static const day_names[][] = {"Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"};

    new a = (14 - month) / 12;
    new y = year - a;
    new m = month + 12 * a - 2;
    new day_of_week = (day + y + y/4 - y/100 + y/400 + (31*m)/12) % 7;

    new str[1024], info[128];
    
    format(info, sizeof(info), "{FFFFFF}Сегодняшняя дата: {FFFF00}%d %s %dг.\n", day, month_names[month], year);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}День недели: {FFFF00}%s\n", day_names[day_of_week]);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}Текущее время: {FFFF00}%02d:%02d:%02d\n\n", hour, minute, second);
    strcat(str, info);

    format(info, sizeof(info), "{FFFFFF}Время в игре за час: {FFFF00}%d мин.\n", Player[playerid][pSecondsHour] / 60);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}Время в игре сегодня: {FFFF00}%d мин.\n", Player[playerid][pSecondsToday] / 60);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}Время в игре за вчера: {FFFF00}%d мин.\n", Player[playerid][pSecondsYesterday] / 60);
    strcat(str, info);

    if(Player[playerid][pJailTime] > 0)
    {
        format(info, sizeof(info), "\n{E0584B}До конца заключения: {FFFFFF}%d мин.", Player[playerid][pJailTime]);
        strcat(str, info);
    }
    if(Player[playerid][pMuteTime] > 0)
    {
        format(info, sizeof(info), "\n{E0584B}До конца мута: {FFFFFF}%d мин.", Player[playerid][pMuteTime]);
        strcat(str, info);
    }

    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}BR BONUS | Точное время", str, "Закрыть", "");
    return 1;
}

stock ShowDoubleTime(playerid)
{
    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}При получении зарплаты на каждой из доступных работ она будет умножаться в {33cc66}X2 {99cc00}раза.");

    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}Каждый 'PayDay' на сервере Вы будете получать в {33cc66}X2 {99cc00}раза больше очков опыта (EXP).");

    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}При пополнении баланса аккаунта (Black Coin) сумма пополнения будет умножаться в {33cc66}X2 {99cc00}раза!");

    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}Пополнить счет своего игрового аккаунта можно прямо в лаунчере, или через сайт: {33cc66}none.online");
    return 1;
}

stock GetExpToNextLevel(playerid)
{
    return 8 + (Player[playerid][pLevel] - 1) * 4;
}

stock GivePlayerExp(playerid, amount)
{
    if(amount <= 0) return 0;

#if X2_SYSTEM
    new total_gain = amount * 2;
#else
    new total_gain = amount;
#endif

    Player[playerid][pExp] += total_gain;

    new needed = GetExpToNextLevel(playerid);

    while(Player[playerid][pExp] >= needed)
    {
        Player[playerid][pExp] -= needed;
        Player[playerid][pLevel]++;
        needed = GetExpToNextLevel(playerid);

        new str[128];
        format(str, sizeof(str), "{3399FF}Поздравляем! Ваш игровой уровень был повышен: %d", Player[playerid][pLevel]);
        SendClientMessage(playerid, -1, str);
        SetPlayerScore(playerid, Player[playerid][pLevel]);
    }

    SavePlayerAccount(playerid);
    return 1;
}

CMD:payday(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 6 || !Player[playerid][pAdminAuth])
        return 1;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;

        else
        {
            GivePlayerExp(i, 1);
            SendClientMessage(i, -1, "{FF9900}========= PayDay =========");
        }

        Player[i][pSecondsHour] = 0;
    }

    new str[128];
    format(str, sizeof(str), "{FF9933}[A] Администратор %s[%d] активировал внеплановый PayDay.", Player[playerid][pName], playerid);
    SendAdminMessage(-1, str);

    return 1;
}

stock SetPlayerX2(playerid, bool:enable, time)
{
    if(!IsPlayerConnected(playerid) || playerid == INVALID_PLAYER_ID)
        return 0;

    new BitStream:bs = BS_New();
    if(bs == BitStream:0)
        return 0;

    BS_WriteValue(bs,
        PR_UINT8, 0x18,
        PR_UINT8, enable,
        PR_UINT8, time
    );

    if(IsPlayerConnected(playerid))
    {
        PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    }

    BS_Delete(bs);
    return 1;
}

stock GetPlayerBlackCoin(playerid)
{
    if(playerid == INVALID_PLAYER_ID) return 0;
    return Player[playerid][pBC];
}

stock GivePlayerBlackCoin(playerid, amount)
{
    if(playerid == INVALID_PLAYER_ID) return 0;

    Player[playerid][pBC] += amount;

    new fmt_str[64];
    if (amount < 0)
    {
        format(fmt_str, sizeof(fmt_str), "Вы потратили %d BC.", -amount);
        ShowNotification(playerid, 0, 5, 0, 1, fmt_str, "");
    }
    else
    {
        format(fmt_str, sizeof(fmt_str), "Вы получили %d BC.", amount);
        ShowNotification(playerid, 1, 5, 0, 1, fmt_str, "");
    }

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `bc` = %d WHERE `id` = %d", Player[playerid][pBC], Player[playerid][pID]);
    mysql_tquery(db_handle, query);

    return 1;
}

CMD:v(playerid, params[])
{
    if(Player[playerid][pVipType] < 1 || Player[playerid][pVipTime] <= 0)
        return ShowNotification(playerid, 0, 5, 0, 0, "У Вас нет vip-статуса!", "");

    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /v [текст]");

    new str[144], vip_name[24];
    switch(Player[playerid][pVipType])
    {
        case 1: vip_name = "Silver VIP";
        case 2: vip_name = "Gold VIP";
        case 3: vip_name = "Platinum VIP";
        default: vip_name = "VIP";
    }

    format(str, sizeof(str), "[%s] %s[%d]: %s", vip_name, Player[playerid][pName], playerid, params);

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(Player[i][pVipType] > 0 || Player[i][pAdminLvl] > 0)
            {
                SendClientMessage(i, 0xFFD700FF, str);
            }
        }
    }
    return 1;
}

stock GivePlayerWeaponEx(playerid, weaponid, ammo)
{
    if(weaponid < 1 || weaponid > 46) return 0;

    Player[playerid][pWeapon][GetWeaponSlot(weaponid)] = weaponid;
    Player[playerid][pAmmo][GetWeaponSlot(weaponid)] += ammo;

    GivePlayerWeapon(playerid, weaponid, ammo);
    
    return 1;
}

stock GetWeaponSlot(weaponid)
{
    new slot;
    switch(weaponid)
    {
        case 0, 1: slot = 0;
        case 2..9: slot = 1;
        case 10..15: slot = 10;
        case 16..18, 39: slot = 8;
        case 22..24: slot = 2;
        case 25..27: slot = 3;
        case 28, 29, 32: slot = 4;
        case 30, 31: slot = 5;
        case 33, 34: slot = 6;
        case 35..38: slot = 7;
        case 40: slot = 12;
        case 41..43: slot = 9;
        case 44..46: slot = 11;
    }
    return slot;
}

stock GiveSimCard(playerid, simnumber)
{
    if(!IsPlayerConnected(playerid)) return 0;

    Player[playerid][pSimCard] = simnumber;

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `sim_card` = %d WHERE `id` = %d", simnumber, Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");

    new str[64];
    format(str, sizeof(str), "Вы получили сим-карту с номером: %d", simnumber);
    ShowNotification(playerid, 1, 5, 0, 1, str, "");
    return 1;
}

stock GetPlayerSimCard(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    return Player[playerid][pSimCard];
}

stock SetVehicleMainColorHEX(playerid, vehicleid, color)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    if(bs == BitStream:0) return 0;

    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x12,
        PR_UINT32, color
    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleDiskColorHEX(playerid, vehicleid, color)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new body_color = 0;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) {
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++) {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid) {
                body_color = VehicleInfo[i][v][vBodyColor];
                break;
            }
        }
    }

    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x12,
        PR_UINT32, body_color,
        PR_UINT32, color,
        PR_UINT32, color,
        PR_UINT32, color
    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock UpdateVehicleTint(playerid, vehicleid, front, rear)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x00,
        PR_UINT32, front,
        PR_UINT32, rear,
        PR_UINT32, front,
        PR_UINT32, rear
    );
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleLightsColorHEX(playerid, vehicleid, color)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    if(bs == BitStream:0) return 0;

    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x08,
        PR_UINT32, color
    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock UpdateVehicleNeon(playerid, vehicleid, main, left, right)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x09,
        PR_UINT32, main,
        PR_UINT32, left,
        PR_UINT32, right
    );
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleStroboscopeForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 19);

	BS_WriteValue(bitstream, PR_UINT32, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

stock SetVehicleVinylForPlayer(playerid, vehicleid, texture[])
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 12);

	BS_WriteValue(bitstream, PR_UINT8, strlen(texture));
	BS_WriteValue(bitstream, PR_STRING, texture);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

stock SetVehicleDlaniy(playerid, vehicleid, value)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8, 22,
        PR_UINT8, value
    );
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SetVehicleSuspension(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 1);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleSuspensionBias(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 2);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleSuspensionForce(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 1);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelSize(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 3);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelAngle(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 10);
    BS_WriteValue(bitstream, PR_FLOAT, front);
    BS_WriteValue(bitstream, PR_FLOAT, rear);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelWidth(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 16);
    BS_WriteValue(bitstream, PR_FLOAT, front);
    BS_WriteValue(bitstream, PR_FLOAT, rear);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelCamber(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 0x0A);
    BS_WriteValue(bitstream, PR_FLOAT, front);
    BS_WriteValue(bitstream, PR_FLOAT, rear);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleHydraulic(playerid, vehicleid, bool:enable)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 21);
    BS_WriteValue(bitstream, PR_UINT8, enable ? 1 : 0);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}
stock SetVehicleWheelSizeAdditive(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 0x11); // case 17 (WheelSizeAdditive)
    BS_WriteValue(bitstream, PR_FLOAT, front); // передние колеса
    BS_WriteValue(bitstream, PR_FLOAT, rear);  // задние колеса
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SendCreateWayPoint(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id, color, Float:dist, interior)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(
        bs,
        PR_UINT16, waypoint_id,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z,
        PR_UINT32, icon_id,
        PR_UINT32, color,
        PR_FLOAT, dist,
        PR_UINT8, interior
    );
    PR_SendRPC(bs, playerid, 169, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:waypoint(playerid)
{
    SendCreateWayPoint(playerid, 0, 1000.0, 1000.0, 10.0, 85, 27, 5000.0, 0);
    return 1;
}

stock PlayAudioStreamURL(playerid, const url[])
{
    new BitStream:bs = BS_New();
    new len = strlen(url);

    BS_WriteValue(bs, PR_INT32, 1);
    BS_WriteValue(bs, PR_UINT8, len);
    BS_WriteValue(bs, PR_STRING, url);
    BS_WriteValue(bs, PR_INT32, 0);
    BS_WriteValue(bs, PR_FLOAT, 1.0);
    BS_WriteValue(bs, PR_UINT8, 0);

    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:htp(playerid, params[])
{
    new type;
    if(sscanf(params, "d", type)) return SendClientMessage(playerid, -1, "Используйте: /htp [0-6]");
    if(type < 0 || type > 6) return SendClientMessage(playerid, -1, "ID типа дома может быть от 0 до 6");

    switch(type)
    {
        case 0: SetPlayerPos(playerid, 2491.4910, 1003.5193, 1499.5813), SetPlayerFacingAngle(playerid, 268.0); // Деревенский
        case 1: SetPlayerPos(playerid, 2903.2188, 1498.0972, 2001.0000), SetPlayerFacingAngle(playerid, 268.0); // Эконом
        case 2: SetPlayerPos(playerid, 667.4174, 29.3543, 1024.1985), SetPlayerFacingAngle(playerid, 268.0);    // Средний 1
        case 3: SetPlayerPos(playerid, 994.7635, 2021.9585, 1561.0112), SetPlayerFacingAngle(playerid, 268.0); // Средний 2
        case 4: SetPlayerPos(playerid, -2.3367, 483.5531, 1381.0022), SetPlayerFacingAngle(playerid, 270.0);   // Высокий
        case 5: SetPlayerPos(playerid, 10.3718, 2494.1458, 1540.9941), SetPlayerFacingAngle(playerid, 0.0);     // Наивысший
        case 6: SetPlayerPos(playerid, 294.7161, 2139.3115, 1765.4641), SetPlayerFacingAngle(playerid, 0.0);   // Премиум
    }

    SetPlayerInterior(playerid, 1); // Во всех твоих данных указан интерьер ID 1
    SetPlayerVirtualWorld(playerid, 0); // Ставим в общий мир

    new str[64];
    format(str, sizeof(str), "Вы телепортированы в интерьер типа №%d", type);
    SendClientMessage(playerid, 0xFFFF00FF, str);
    return 1;
}

forward LoadHouses();
public LoadHouses() {
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    for(new i = 0; i < rows; i++) {
        HouseInfo[i][hID] = cache_get_field_content_int(i, "id", db_handle);
        HouseInfo[i][hOwnerID] = cache_get_field_content_int(i, "owner_id", db_handle);
        cache_get_field_content(i, "owner_name", HouseInfo[i][hOwnerName], db_handle, 24);
        HouseInfo[i][hType] = cache_get_field_content_int(i, "type", db_handle);
        HouseInfo[i][hPrice] = cache_get_field_content_int(i, "price", db_handle);
        HouseInfo[i][hEntX] = cache_get_field_content_float(i, "ent_x", db_handle);
        HouseInfo[i][hEntY] = cache_get_field_content_float(i, "ent_y", db_handle);
        HouseInfo[i][hEntZ] = cache_get_field_content_float(i, "ent_z", db_handle);
        HouseInfo[i][hExitX] = cache_get_field_content_float(i, "exit_x", db_handle);
        HouseInfo[i][hExitY] = cache_get_field_content_float(i, "exit_y", db_handle);
        HouseInfo[i][hExitZ] = cache_get_field_content_float(i, "exit_z", db_handle);
        HouseInfo[i][hExitA] = cache_get_field_content_float(i, "exit_a", db_handle);
        UpdateHouseStatus(i);
        TotalHouses++;
    }
    //printf("Загружено домов: %d", TotalHouses);
    return 1;
}

stock UpdateHouseStatus(id)
{
    if(HouseInfo[id][hPickup] != 0) DestroyDynamicPickup(HouseInfo[id][hPickup]);
    if(HouseInfo[id][hLabel] != Text3D:INVALID_3DTEXT_ID) DestroyDynamic3DTextLabel(HouseInfo[id][hLabel]);

    new str[256];
    if(HouseInfo[id][hOwnerID] == 0)
    {
        HouseInfo[id][hPickup] = CreateDynamicPickup(1273, 23, HouseInfo[id][hEntX], HouseInfo[id][hEntY], HouseInfo[id][hEntZ], 0, 0);
        format(str, sizeof(str), "{FFFF00}« Деревенский дом »\n{FFFF00}« {FFFFFF}Дом свободен {FFFFFF}| Номер: {FFFF00}%d", HouseInfo[id][hID]);
    }
    else
    {
        HouseInfo[id][hPickup] = CreateDynamicPickup(1272, 23, HouseInfo[id][hEntX], HouseInfo[id][hEntY], HouseInfo[id][hEntZ], 0, 0);
        format(str, sizeof(str), "{FFFF00}« Деревенский дом »\n{FFFFFF}Владелец: {FFFF00}%s", HouseInfo[id][hOwnerName]);
    }
    HouseInfo[id][hLabel] = CreateDynamic3DTextLabel(str, -1, HouseInfo[id][hEntX], HouseInfo[id][hEntY], HouseInfo[id][hEntZ] + 0.8, 12.0);
    return 1;
}

CMD:addhouse(playerid, params[]) {
    if(Player[playerid][pAdminLvl] < 5) return 1;
    new htype, hprice;
    if(sscanf(params, "dd", htype, hprice)) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: /addhouse [0-6] [цена]");
    if(htype < 0 || htype > 6) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Тип дома от 0 до 6!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new i = TotalHouses;
    HouseInfo[i][hType] = htype;
    HouseInfo[i][hPrice] = hprice;
    HouseInfo[i][hEntX] = x;
    HouseInfo[i][hEntY] = y;
    HouseInfo[i][hEntZ] = z;
    HouseInfo[i][hOwnerID] = 0;
    format(HouseInfo[i][hOwnerName], 24, "None");

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "INSERT INTO `houses` (type, price, ent_x, ent_y, ent_z) VALUES (%d, %d, '%f', '%f', '%f')", htype, hprice, x, y, z);
    mysql_tquery(db_handle, query, "OnHouseCreated", "i", i);
    return 1;
}

forward OnHouseCreated(id);
public OnHouseCreated(id) {
    HouseInfo[id][hID] = cache_insert_id();
    UpdateHouseStatus(id);
    TotalHouses++;
}

CMD:sethouseexit(playerid, params[]) {
    if(Player[playerid][pAdminLvl] < 5) return 1;
    new hid;
    if(sscanf(params, "d", hid)) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: /sethouseexit [id дома]");

    new slot = -1;
    for(new i=0; i<TotalHouses; i++) if(HouseInfo[i][hID] == hid) { slot = i; break; }
    if(slot == -1) return ShowNotification(playerid, 0, 5, 0, 0, "Дом не найден!", "");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    HouseInfo[slot][hExitX] = x; HouseInfo[slot][hExitY] = y; HouseInfo[slot][hExitZ] = z; HouseInfo[slot][hExitA] = a;

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `houses` SET exit_x='%f', exit_y='%f', exit_z='%f', exit_a='%f' WHERE id=%d", x, y, z, a, hid);
    mysql_tquery(db_handle, query, "", "");
    SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Координаты выхода установлены!");
    return 1;
}

CMD:exit(playerid) {
    new i = GetPVarInt(playerid, "InHouseID");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, HouseInteriors[HouseInfo[i][hType]][iX], HouseInteriors[HouseInfo[i][hType]][iY], HouseInteriors[HouseInfo[i][hType]][iZ])) return 1;

    SetPlayerPos(playerid, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ]);
    SetPlayerFacingAngle(playerid, HouseInfo[i][hExitA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    DeletePVar(playerid, "InHouseID");
    return 1;
}

CMD:house(playerid)
{
    new houseid = -1;
    for(new i = 0; i < TotalHouses; i++)
    {
        if(HouseInfo[i][hOwnerID] == Player[playerid][pID])
        {
            houseid = i;
            break;
        }
    }

    if(houseid == -1) return ShowNotification(playerid, 0, 5, 0, 0, "У вас нет личного дома!", "");

    SetPVarInt(playerid, "ManageHouseID", houseid);

    new str[512];
    str = "Название    Информация\n";
    format(str, sizeof(str), "%s{FFFFFF}1. Состояние двери    {E0584B}%s\n", str, (HouseInfo[houseid][hLock]) ? ("Закрыта") : ("Открыта"));
    format(str, sizeof(str), "%s{FFFFFF}2. Найти дом    {E0584B}GPS", str);

    ShowPlayerDialog(playerid, DIALOG_MENU_HOUSE, DIALOG_STYLE_TABLIST_HEADERS,
        "{E0584B}BR BONUS {FFFFFF}| Управление",
        str, "Выбрать", "Закрыть"
    );
    return 1;
}


CMD:donate(playerid)
{
    new Node:donate_json = JSON_Object();

    JSON_SetInt(donate_json, "o", 1);
    JSON_SetInt(donate_json, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(donate_json, "d", GetPlayerBlackCoin(playerid));
    JSON_SetInt(donate_json, "ds", 1);
    JSON_SetString(donate_json, "em", "");
    JSON_SetInt(donate_json, "k", 0);
    JSON_SetInt(donate_json, "lc", 0);
    JSON_SetInt(donate_json, "sv", 1);
    JSON_SetInt(donate_json, "p", Player[playerid][pGiftDelay]);
    JSON_SetString(donate_json, "nm", GetPlayerNameEx(playerid));

    new Node:i_array = JSON_Array();
    JSON_SetArray(donate_json, "i", i_array);

    new Node:s_array = JSON_Array(
        JSON_Int(94), JSON_Int(65362), JSON_Int(40),
        JSON_Int(448), JSON_Int(65362), JSON_Int(29),
        JSON_Int(544), JSON_Int(65362), JSON_Int(35)
    );
    JSON_SetArray(donate_json, "s", s_array);

    OnPacketIncoming(playerid, 22, donate_json);

    JSON_Cleanup(donate_json);
    return 1;
}

CMD:blackpass(playerid)
{
    new Node:donate_json = JSON_Object();

    JSON_SetInt(donate_json, "o", 1);
    JSON_SetInt(donate_json, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(donate_json, "d", GetPlayerBlackCoin(playerid));
    JSON_SetInt(donate_json, "ds", 1);
    JSON_SetString(donate_json, "em", "");
    JSON_SetInt(donate_json, "k", 0);
    JSON_SetInt(donate_json, "lc", 4);
    JSON_SetInt(donate_json, "sv", 1);
    JSON_SetInt(donate_json, "p", Player[playerid][pGiftDelay]);
    JSON_SetString(donate_json, "nm", GetPlayerNameEx(playerid));

    new Node:s_array = JSON_Array(
        JSON_Int(94), JSON_Int(65362), JSON_Int(40),
        JSON_Int(448), JSON_Int(65362), JSON_Int(29),
        JSON_Int(544), JSON_Int(65362), JSON_Int(35)
    );
    JSON_SetArray(donate_json, "s", s_array);

    OnPacketIncoming(playerid, 22, donate_json);

    JSON_Cleanup(donate_json);

    new Node:json = JSON_Object();

    JSON_SetInt(json, "ec", PlayerBP[playerid][bpExp]);
    JSON_SetInt(json, "a", PlayerBP[playerid][bpPremium]);
    JSON_SetInt(json, "is", 0);
    JSON_SetInt(json, "la", 0);
    JSON_SetString(json, "ln", BlackPassTop[0][topName]);
    JSON_SetInt(json, "lv", PlayerBP[playerid][bpLevel]);
    JSON_SetInt(json, "ps", 0);
    JSON_SetString(json, "sn", BP_SEASON_NAME);
    JSON_SetInt(json, "sp", 0);
    JSON_SetInt(json, "t", -1);
    JSON_SetInt(json, "td", 2505600);
    JSON_SetInt(json, "ty", -1);
    JSON_SetInt(json, "s", 1);
    
    OnPacketIncoming(playerid, 22, json);

    JSON_Cleanup(json);

    return 1;
}

CMD:tablet(playerid)
{
    new Node:tablet_json = JSON_Object();

    JSON_SetInt(tablet_json, "a", 1);

    new Node:ac_array = JSON_Array(
        JSON_Object("id", JSON_Int(17)),
        JSON_Object("id", JSON_Int(24))
    );
    JSON_SetArray(tablet_json, "ac", ac_array);

    new Node:d_obj = JSON_Object();
    JSON_SetInt(d_obj, "ar", 1);
    JSON_SetInt(d_obj, "av", 1);
    JSON_SetInt(d_obj, "bg", 1);
    JSON_SetInt(d_obj, "exm", 8);
    JSON_SetInt(d_obj, "exp", 0);
    JSON_SetString(d_obj, "fn", "Отсутствует");
    JSON_SetInt(d_obj, "lv", 1);
    JSON_SetInt(d_obj, "v", 0);
    JSON_SetObject(tablet_json, "d", d_obj);

    JSON_SetInt(tablet_json, "i", 1);

    new Node:n_array = JSON_Array();
    JSON_SetArray(tablet_json, "n", n_array);

    JSON_SetInt(tablet_json, "o", 1);

    OnPacketIncoming(playerid, 113, tablet_json);

    JSON_Cleanup(tablet_json);
    return 1;
}


CMD:createbizz(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    if(bizCreated)
    {
        if(bizPickup != -1) DestroyDynamicPickup(bizPickup);
        if(bizLabel != Text3D:-1) DestroyDynamic3DTextLabel(bizLabel);
    }
    GetPlayerPos(playerid, bizX, bizY, bizZ);
    bizPickup = CreateDynamicPickup(19132, 23, bizX, bizY, bizZ, 0, 0);
    bizOwnerID = 0;
    bizBalance = 0;
    bizCreated = true;
    UpdateBizLabel();
    SendClientMessage(playerid, 0x66CC00FF, "Бизнес создан. Используйте /buystail для покупки.");
    return 1;
}

CMD:buystail(playerid, params[])
{
    if(!bizCreated) return SendClientMessage(playerid, 0xFF6666FF, "Бизнес ещё не создан.");
    if(bizOwnerID != 0) return SendClientMessage(playerid, 0xFF6666FF, "Бизнес уже куплен.");
    if(Player[playerid][pMoney] < BIZ_PRICE) return SendClientMessage(playerid, 0xFF6666FF, "Недостаточно денег (1 000 000 руб.).");
    GivePlayerMoneyEx(playerid, -BIZ_PRICE);
    bizOwnerID = playerid;
    UpdateBizLabel();
    SendClientMessage(playerid, 0x66CC00FF, "Вы купили бизнес! Доход от тюнинга будет поступать на его баланс.");
    return 1;
}

CMD:bbis(playerid, params[])
{
    if(!bizCreated) return SendClientMessage(playerid, 0xFF6666FF, "Бизнес не создан.");
    if(bizOwnerID == 0) return SendClientMessage(playerid, 0xFF6666FF, "Бизнес на аукционе.");
    new str[128];
    format(str, sizeof(str), "Баланс бизнеса #1 Стайлинг центр: %d руб.", bizBalance);
    SendClientMessage(playerid, 0x66CC00FF, str);
    return 1;
}

CMD:bis(playerid, params[])
{
    if(!bizCreated) return SendClientMessage(playerid, 0xFF6666FF, "Бизнес не создан.");
    if(bizOwnerID != playerid) return SendClientMessage(playerid, 0xFF6666FF, "Вы не владелец.");
    if(bizBalance <= 0) return SendClientMessage(playerid, 0xFF6666FF, "На балансе бизнеса нет денег.");
    new amount = bizBalance;
    bizBalance = 0;
    GivePlayerMoneyEx(playerid, amount);
    UpdateBizLabel();
    SendClientMessage(playerid, 0x66CC00FF, "Вы сняли все деньги с бизнеса.");
    return 1;
}

stock AddBizRevenue(amount)
{
    if(!bizCreated || bizOwnerID == 0) return 0;
    bizBalance += amount;
    return 1;
}

stock UpdateBizLabel()
{
    if(bizLabel != Text3D:-1) DestroyDynamic3DTextLabel(bizLabel);
    new str[128];
    if(bizOwnerID == 0)
    {
        format(str, sizeof(str), "{FFFF00}#1 Стайлинг центр\n{FFFFFF}Бизнес находится на аукционе\nЦена: 1 000 000 руб.");
    }
    else
    {
        new ownerName[MAX_PLAYER_NAME];
        if(IsPlayerConnected(bizOwnerID))
            GetPlayerName(bizOwnerID, ownerName, sizeof(ownerName));
        else
            format(ownerName, sizeof(ownerName), "Неизвестно");
        format(str, sizeof(str), "{FFFF00}#1 Стайлинг центр\n{FFFFFF}Владелец: %s", ownerName);
    }
    bizLabel = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, bizX, bizY, bizZ + 1.0, 15.0);
    return 1;
}

stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
}

CMD:cc(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_CLEAR_CHAT, DIALOG_STYLE_LIST,
                     "Очистка чата",
                     "1.\tОчистка чата без никнейма\n2. \tОчистка чата  никнеймом\n3. \tОчистка от имени проекта",
                     "Далее", "Закрыть");

    return 1;
}

CMD:ahelp(playerid, params[])
{
    if(GetPlayerAdminLevel(playerid) < 1) return 1;

    ShowAHelpMain(playerid);
    return 1;
}

public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
    if(rpcid != 97) return 1;

    new action;
    new actionSubtype;

    if(!BS_ReadUint32(bs, action))
    {
        return 1;
    }

    if(action == 3)
    {
        new vehicleid;
        new turnStatus;

        if(!BS_ReadUint16(bs, vehicleid)) return 1;
        if(!BS_ReadUint8(bs, turnStatus)) return 1;

        if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;
        if(!IsValidVehicle(vehicleid)) return 1;
        if(GetPlayerVehicleID(playerid) != vehicleid) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
        if(turnStatus < 1 || turnStatus > 3) return 1;

        if(TurnSignalState[vehicleid] == turnStatus && TurnSignalDriver[vehicleid] == playerid)
        {
            StopVehicleTurnSignal(vehicleid);
        }
        else
        {
            StopVehicleTurnSignal(vehicleid);
            StartVehicleTurnSignal(playerid, vehicleid, turnStatus);
        }
        return 1;
    }

    if(action == 4)
    {
        callcmd::radial(playerid);
        return 1;
    }

        if(action == 14)
        {
            if(!BS_ReadUint8(bs, actionSubtype))
            {
                return 1;
            }

            switch(actionSubtype) // щассс
            {
                case 0: // m3mory
                {
                   callcmd::blackpass(playerid, "");
                }
                case 1: // m3mory
                {
                    SendClientMessage(playerid, -1, "{00FFFF}Данная функция находится а разработке.");
                }
                case 2: //by m3mory
                {
                    callcmd::donate(playerid, "");
                }
                case 4: // мэмори 
                {
                    callcmd::tablet(playerid, "");
                }
            }
        }

    return 1;
}


stock SendVehicleTurnLight(playerid, vehicleid, status)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 12);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, status);
    PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SendVehicleTurnLightForAll(vehicleid, status)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        SendVehicleTurnLight(i, vehicleid, status);
    }
    return 1;
}

stock ResetVehicleTurnSignalData(vehicleid)
{
    TurnSignalState[vehicleid] = 0;
    TurnSignalBlinkOn[vehicleid] = false;
    TurnSignalDriver[vehicleid] = INVALID_PLAYER_ID;
    TurnSignalModel[vehicleid] = 0;
    return 1;
}

stock StopVehicleTurnSignal(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;

    if(IsValidVehicle(vehicleid))
    {
        SendVehicleTurnLightForAll(vehicleid, 0);
    }

    ResetVehicleTurnSignalData(vehicleid);
    return 1;
}

stock StartVehicleTurnSignal(playerid, vehicleid, status)
{
    TurnSignalState[vehicleid] = status;
    TurnSignalBlinkOn[vehicleid] = true;
    TurnSignalDriver[vehicleid] = playerid;
    TurnSignalModel[vehicleid] = GetVehicleModel(vehicleid);
    SendVehicleTurnLightForAll(vehicleid, status);
    return 1;
}

stock StopPlayerVehicleTurnSignal(playerid)
{
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(TurnSignalDriver[vehicleid] != playerid) continue;
        StopVehicleTurnSignal(vehicleid);
    }
    return 1;
}

forward UpdateVehicleTurnSignals();
public UpdateVehicleTurnSignals()
{
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(TurnSignalState[vehicleid] < 1 || TurnSignalState[vehicleid] > 3) continue;

        if(!IsValidVehicle(vehicleid))
        {
            ResetVehicleTurnSignalData(vehicleid);
            continue;
        }

        new driverid = TurnSignalDriver[vehicleid];
        if(driverid == INVALID_PLAYER_ID || !IsPlayerConnected(driverid))
        {
            StopVehicleTurnSignal(vehicleid);
            continue;
        }

        if(GetPlayerState(driverid) != PLAYER_STATE_DRIVER)
        {
            StopVehicleTurnSignal(vehicleid);
            continue;
        }

        if(GetPlayerVehicleID(driverid) != vehicleid)
        {
            StopVehicleTurnSignal(vehicleid);
            continue;
        }

        if(GetVehicleModel(vehicleid) != TurnSignalModel[vehicleid])
        {
            StopVehicleTurnSignal(vehicleid);
            continue;
        }

        if(TurnSignalBlinkOn[vehicleid])
        {
            TurnSignalBlinkOn[vehicleid] = false;
            SendVehicleTurnLightForAll(vehicleid, 0);
        }
        else
        {
            TurnSignalBlinkOn[vehicleid] = true;
            SendVehicleTurnLightForAll(vehicleid, TurnSignalState[vehicleid]);
        }
    }
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    StopVehicleTurnSignal(vehicleid);
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    StopVehicleTurnSignal(vehicleid);
    return 1;
}

CMD:gpspr(playerid)
{
    metkarps(playerid, 0, 1000.0, 1000.0, 10.0, 67, 27, 5000.0, 0);
    return 1;
}

stock SendDestroyWayPoint(playerid, waypoint_id)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, waypoint_id);
    PR_SendRPC(bs, playerid, 170, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock metkarps(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id, color, Float:dist, interior)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(
        bs,
        PR_UINT16, waypoint_id,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z,
        PR_UINT32, icon_id,
        PR_UINT32, color,
        PR_FLOAT, dist,
        PR_UINT8, interior
    );
    PR_SendRPC(bs, playerid, 169, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock IsValidVehicle(vehicleid)
{
    return GetVehicleModel(vehicleid) != 0;
}

CMD:testmarket(playerid, params[])
{
    #pragma unused params
    return Market_Open(playerid);
}

CMD:market(playerid, params[])
{
    #pragma unused params
    return Market_Open(playerid);
}

CMD:marketplace(playerid, params[])
{
    #pragma unused params
    return Market_Open(playerid);
}

CMD:mp(playerid, params[])
{
    #pragma unused params
    return Market_Open(playerid);
}

CMD:addmp(playerid, params[])
{
    new slot, price;
    if(sscanf(params, "ii", slot, price)) return SendClientMessage(playerid, -1, "{999999}Используйте: /addmp [слот инвентаря] [цена]");
    return Market_PublishSource(playerid, slot, price, 0);
}

CMD:spgui(playerid, params[])
{
    #pragma unused params
    return SpawnLocation_OpenGUI(playerid);
}

forward ShowAuthorMessage();
public ShowAuthorMessage()
{
    SendClientMessageToAll(0x0080FFFF, "{00CCFF}[Напоминание] {FFFFFF}Автор мода мэмори.");
    return 1;
}

CMD:kick(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 3) return 1;
    new targetid, reason[64], str[128];
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /kick [id] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    format(str, sizeof(str), "{E0584B}Администратор %s кикнул игрока %s. Причина: %s", Player[playerid][pName], Player[targetid][pName], reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] кикнул %s[%d] причина: %s", Player[playerid][pName], playerid, Player[targetid][pName], targetid, reason);
    SendAdminMessage(-1, str);
    Kick(targetid);
    return 1;
}

CMD:ban(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, days, reason[64], str[128];
    if(sscanf(params, "uds[64]", targetid, days, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /ban [id] [дни] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pBanTime] = days * 1440;
    format(Player[targetid][pBanReason], 64, reason);
    format(Player[targetid][pBanAdmin], 24, Player[playerid][pName]);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "{E0584B}Администратор %s забанил игрока %s на %d дн. Причина: %s", Player[playerid][pName], Player[targetid][pName], days, reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] забанил игрока %s[%d] на %d дн. Причина: %s", Player[playerid][pName], playerid, Player[targetid][pName], targetid, days, reason);
    SendAdminMessage(-1, str);
    Kick(targetid);
    return 1;
}

CMD:permban(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    new targetid, reason[64], str[128];
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /permban [id] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pBanTime] = 999999;
    format(Player[targetid][pBanReason], 64, reason);
    format(Player[targetid][pBanAdmin], 24, Player[playerid][pName]);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "{E0584B}Администратор %s выдал пермоментную игроку %s Причина: %s", Player[playerid][pName], Player[targetid][pName], reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] забанил игрока %s[%d] навсегда Причина: %s", Player[playerid][pName], playerid, Player[targetid][pName], targetid, reason);
    SendAdminMessage(-1, str);
    Kick(targetid);
    return 1;
}

CMD:mute(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, mtime, reason[64], str[128];
    if(sscanf(params, "uds[64]", targetid, mtime, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /mute [id] [мин] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pMuteTime] = mtime;
    format(str, sizeof(str), "{E0584B}Администратор %s выдал мут игроку %s на %d мин. Причина: %s", Player[playerid][pName], Player[targetid][pName], mtime, reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал мут игроку %s[%d] на %d мин. Причина: %s", Player[playerid][pName], playerid, Player[targetid][pName], targetid, mtime, reason);
    SendAdminMessage(-1, str);
    SavePlayerAccount(targetid);
    return 1;
}

CMD:jail(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, jtime, reason[64], str[128];
    if(sscanf(params, "uds[64]", targetid, jtime, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /jail [id] [мин] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pJailTime] = jtime;
    JailSystem(targetid);
    format(str, sizeof(str), "{E0584B}Администратор %s посадил игрока %s в деморган на %d мин. Причина: %s", Player[playerid][pName], Player[targetid][pName], jtime, reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] посадил игрока %s[%d] в деморган на %d мин. Причина: %s", Player[playerid][pName], playerid, Player[targetid][pName], targetid, jtime, reason);
    SendAdminMessage(-1, str);
    SavePlayerAccount(targetid);
    return 1;
}

CMD:warn(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, reason[64], str[128];
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /warn [id] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pWarns]++;
    format(str, sizeof(str), "{E0584B}Администратор %s выдал предупреждение игроку %s Причина: %s (%d/3)", Player[playerid][pName], Player[targetid][pName], reason, Player[targetid][pWarns]);
    SendClientMessageToAll(0xFF4B4BFF, str);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал предупреждение игроку %s[%d] (причина: %s) (%d/3)", Player[playerid][pName], playerid, Player[targetid][pName], targetid, reason, Player[targetid][pWarns]);
    SendAdminMessage(-1, str);
    if(Player[targetid][pWarns] >= 3)
    {
        Player[targetid][pWarns] = 0;
        Player[targetid][pBanTime] = 14400;
        format(Player[targetid][pBanReason], 64, "3/3 Warns");
        format(Player[targetid][pBanAdmin], 24, "Система");
        SavePlayerAccount(targetid);
        Kick(targetid);
    }
    return 1;
}

CMD:givecash(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    new targetid, amount, str[128];
    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, -1, "{999999}Используйте: /givecash [id] [сумма]");
    if(!IsPlayerConnected(targetid)) return 1;
    GivePlayerMoneyEx(targetid, amount);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал %d рублей %s[%d]", Player[playerid][pName], playerid, amount, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы выдали %d рублей игроку %s[%d].", amount, Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам %d рублей.", Player[playerid][pName], playerid, amount);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:givedonate(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    new targetid, amount, str[128];
    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, -1, "{999999}Используйте: /givedonate [id] [сумма]");
    if(!IsPlayerConnected(targetid)) return 1;
    GivePlayerBlackCoin(targetid, amount);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал %d BlackCoins %s[%d]", Player[playerid][pName], playerid, amount, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы выдали %d BlackCoins игроку %s[%d].", amount, Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам %d BlackCoins.", Player[playerid][pName], playerid, amount);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:givegun(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, weaponid, ammo, str[144];
    if(sscanf(params, "uii", targetid, weaponid, ammo)) return SendClientMessage(playerid, -1, "{999999}Используйте: /givegun [id] [id оружия] [патроны]");
    if(!IsPlayerConnected(targetid)) return 1;
    if(weaponid < 1 || weaponid > 46) return SendClientMessage(playerid, -1, "{999999}Неверный ID оружия (1-46).");
    GivePlayerWeapon(targetid, weaponid, ammo);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал оружие %d (%d патр.) %s[%d]", Player[playerid][pName], playerid, weaponid, ammo, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы выдали оружие %d (%d патронов) игроку %s[%d].", weaponid, ammo, Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам оружие %d (%d патронов).", Player[playerid][pName], playerid, weaponid, ammo);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    new targetid, type_case, count, str[128];
    if(sscanf(params, "udd", targetid, type_case, count)) return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-5] [count]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > 5) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 5.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");
    AddPlayerCaseCountByType(targetid, type_case, count);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал %d кейс(ов) типа %d игроку %s[%d]", Player[playerid][pName], playerid, count, type_case, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы выдали %d кейс(ов) типа %d игроку %s[%d].", count, type_case, Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам %d кейс(ов) типа %d.", Player[playerid][pName], playerid, count, type_case);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:setskin(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 3) return 1;
    new targetid, skinid, str[128];
    if(sscanf(params, "ui", targetid, skinid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /setskin [id игрока] [id скина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pSkin] = skinid;
    SetPlayerSkin(targetid, skinid);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] установил постоянный скин %d для %s[%d]", Player[playerid][pName], playerid, skinid, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы установили игроку %s[%d] постоянный скин %d.", Player[targetid][pName], targetid, skinid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] установил вам постоянный скин %d.", Player[playerid][pName], playerid, skinid);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:skin(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, skinid, str[128];
    if(sscanf(params, "ud", targetid, skinid)) return SendClientMessage(playerid, -1, "{999999} Используйте: /skin [ид игрока] [ид скина]");
    if(!IsPlayerConnected(targetid)) return 1;
    SetPlayerSkin(targetid, skinid);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] выдал временный скин %d для %s[%d]", Player[playerid][pName], playerid, skinid, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы выдали временный скин %d игроку %s[%d].", skinid, Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам временный скин %d.", Player[playerid][pName], playerid, skinid);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:veh(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new modelid, color1, color2, str[128];
    if(sscanf(params, "ddd", modelid, color1, color2)) return SendClientMessage(playerid, -1, "{999999}Используйте: /veh [id модели] [цвет 1] [цвет 2]");
    if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, 0xFF4B4BFF, "ID машины должен быть от 400 до 611!");
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    if(Player[playerid][pAdminVeh] != INVALID_VEHICLE_ID) DestroyVehicle(Player[playerid][pAdminVeh]);
    Player[playerid][pAdminVeh] = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
    SetVehicleParamsInit(Player[playerid][pAdminVeh]);
    PutPlayerInVehicle(playerid, Player[playerid][pAdminVeh], 0);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] создал временый транспорт %d (ID:%d)", Player[playerid][pName], playerid, modelid, Player[playerid][pAdminVeh]);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{00CCFF}[Информация] {FFFFFF}Вы создали транспорт %d.", modelid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:goto(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /goto [id]");
    if(!IsPlayerConnected(targetid)) return 1;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(playerid, x + 1.5, y, z);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] телепортировался к %s[%d]", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы телепортировались к игроку %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}
alias:goto("g")

CMD:gethere(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /gethere [id]");
    if(!IsPlayerConnected(targetid)) return 1;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(targetid, x + 1.5, y, z);
    SetPlayerInterior(targetid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] телепортировал %s[%d] к себе", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы телепортировали игрока %s[%d] к себе.", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}
alias:gethere("gh")

CMD:flip(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) targetid = playerid;
    if(!IsPlayerInAnyVehicle(targetid)) return 1;
    new Float:a;
    GetVehicleZAngle(GetPlayerVehicleID(targetid), a);
    SetVehicleZAngle(GetPlayerVehicleID(targetid), a);
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] флипнул транспорт %s[%d]", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы флипнули транспорт игрока %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    if(targetid != playerid)
    {
        format(str, sizeof(str), "{3399FF}Администратор %s[%d] перевернул ваш транспорт.", Player[playerid][pName], playerid);
        SendClientMessage(targetid, -1, str);
    }
    return 1;
}

CMD:vget(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /vget [ID игрока]");
    if(!IsPlayerConnected(targetid)) return 1;
    new vehicle_slot = -1;
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[targetid][i][vSpawned] && VehicleInfo[targetid][i][vID] != INVALID_VEHICLE_ID)
        {
            vehicle_slot = i;
            break;
        }
    }
    if(vehicle_slot == -1) return SendClientMessage(playerid, 0xFF4B4BFF, "У игрока нет заспавненного личного транспорта!");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetVehiclePos(VehicleInfo[targetid][vehicle_slot][vID], x + 2.0, y, z + 1.0);
    SetVehicleVirtualWorld(VehicleInfo[targetid][vehicle_slot][vID], GetPlayerVirtualWorld(targetid));
    LinkVehicleToInterior(VehicleInfo[targetid][vehicle_slot][vID], GetPlayerInterior(targetid));
    format(str, sizeof(str), "{CCCCCC}[A] Администратор %s[%d] телепортировал личный транспорт %s[%d] к нему.", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(-1, str);
    format(str, sizeof(str), "{3399FF}Вы телепортировали личный транспорт игрока %s[%d] к нему.", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

stock UpdateAdmin3DText(playerid)
{
    if(Admin3DText[playerid] != INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(Admin3DText[playerid]);
        Admin3DText[playerid] = INVALID_3DTEXT_ID;
    }

    if(Player[playerid][pAdminLvl] < 1 || !Player[playerid][pAdminAuth]) return 1;

    new level = Player[playerid][pAdminLvl];
    new text[64];
    format(text, sizeof(text), "{FFFFFF}Администратор {DD5757}%d уровня", level);

    Admin3DText[playerid] = CreateDynamic3DTextLabel(
        text, 0xFFFFFFFF, 0.0, 0.0, 0.0, 15.0,
        .attachedplayer = playerid, .testlos = 1
    );
    return 1;
}

CMD:deltex(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;

    if(Admin3DText[playerid] != INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(Admin3DText[playerid]);
        Admin3DText[playerid] = INVALID_3DTEXT_ID;
        SendClientMessage(playerid, -1, "{E0584B}BR BONUS {FFFFFF}| Метка удалена.");
    }
    else SendClientMessage(playerid, -1, "{E0584B}BR BONUS {FFFFFF}| У вас нет активной метки.");
    return 1;
}

forward StartFactoryCrafting(playerid);
public StartFactoryCrafting(playerid)
{
    IsCrafting[playerid] = true;
    TogglePlayerControllable(playerid, 0);
    RemovePlayerAttachedObject(playerid, 1); // Убираем коробку
    
    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 1, 1, 1); 
    SendClientMessage(playerid, -1, "{00FFFF}Вы начали точить деталь... Ожидайте 15 секунд.");
    
    SetTimerEx("OnFactoryCraftFinished", 15000, false, "i", playerid);
}

forward OnFactoryCraftFinished(playerid);
public OnFactoryCraftFinished(playerid)
{
    if(!IsFactoryWorker[playerid]) return 0;

    IsCrafting[playerid] = false;
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);

    new raw = PlayerRawKg[playerid];
    PlayerRawKg[playerid] = 0;

    new multiplier = 1 + random(3); 
    PlayerProductKg[playerid] = raw * multiplier;

    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
    SetPlayerAttachedObject(playerid, 1, 2969, 5, 0.0, 0.2, 0.0, 0.0, 0.0, 0.0);

    new str[128];
    format(str, sizeof(str), "{00FF00}Отлично! Вы выточили %d кг продукта. Несите его на склад.", PlayerProductKg[playerid]);
    SendClientMessage(playerid, -1, str);
    
    return 1;
}

forward FinishFactoryDrop(playerid);
public FinishFactoryDrop(playerid)
{
    new prodKg = PlayerProductKg[playerid];
    PlayerProductKg[playerid] = 0;
    
    ClearAnimations(playerid);
    RemovePlayerAttachedObject(playerid, 1);

    new price_per_kg = 100 + random(51); 
    new earned = prodKg * price_per_kg;

    FactorySalary[playerid] += float(earned);

    new str[128];
    format(str, sizeof(str), "{FFD400}Вы сдали %d кг деталей (по %d руб/кг). Заработано: %d руб. (Баланс смены: %d руб.)", 
        prodKg, price_per_kg, earned, floatround(FactorySalary[playerid]));
    SendClientMessage(playerid, -1, str);
}

forward GiveFactorySalary(playerid);
public GiveFactorySalary(playerid)
{
    new salary = floatround(FactorySalary[playerid]);
    FactorySalary[playerid] = 0.0;
    
    GivePlayerMoney(playerid, salary);
    
    new str[128];
    format(str, sizeof(str), "{FFFF00} Вы получили зарплату за смену: {00FF00}%d руб.", salary);
    SendClientMessage(playerid, -1, str);
}

stock GetShortSenderName(playerid, dest[], len)
{
    new name[MAX_PLAYER_NAME], pos = -1;
    GetPlayerName(playerid, name, sizeof(name));
    for(new i = 0; name[i]; i++) if(name[i] == '_') { pos = i; break; }
    if(pos != -1 && name[pos+1])
    {
        format(dest, len, "%c. %s", name[0], name[pos+1]);
    }
    else
    {
        format(dest, len, "%s", name);
    }
    return 1;
}

stock AF_SaveForm(playerid, const command[], const params[])
{
    if(AF_Total >= MAX_AF_FORMS) return -1;
    new idx = -1;
    for(new i = 0; i < MAX_AF_FORMS; i++)
        if(!AF_Forms[i][afUsed]) { idx = i; break; }
    if(idx == -1) return -1;
    AF_Forms[idx][afID] = AF_NextID++;
    AF_Forms[idx][afSenderID] = playerid;
    GetPlayerName(playerid, AF_Forms[idx][afSenderName], MAX_PLAYER_NAME);
    format(AF_Forms[idx][afCommand], AF_COMMAND_LEN, "%s", command);
    format(AF_Forms[idx][afParams], AF_PARAMS_LEN, "%s", params);
    AF_Forms[idx][afCreated] = gettime();
    AF_Forms[idx][afUsed] = 1;
    AF_Total++;
    return AF_Forms[idx][afID];
}

stock AF_DeleteForm(idx)
{
    if(idx < 0 || idx >= MAX_AF_FORMS) return 0;
    if(!AF_Forms[idx][afUsed]) return 0;
    AF_Forms[idx][afUsed] = 0;
    AF_Total--;
    return 1;
}

stock AF_ShowList(playerid)
{
    new dialog[2048], count = 0;
    strcat(dialog, "ID\tОтправитель\tКоманда\tПараметры\n");
    for(new i = 0; i < MAX_AF_FORMS; i++)
    {
        if(!AF_Forms[i][afUsed]) continue;
        new params_display[64];
        strmid(params_display, AF_Forms[i][afParams], 0, 40);
        format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%s\n",
            dialog, AF_Forms[i][afID], AF_Forms[i][afSenderName], AF_Forms[i][afCommand], params_display);
        count++;
    }
    if(count == 0) strcat(dialog, "Нет активных форм");
    ShowPlayerDialog(playerid, DIALOG_AF_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "{E0584B}BR BONUS {FFFFFF}| Список форм", dialog, "Принять", "Назад");
    return 1;
}

stock AF_FindFormByID(formid)
{
    for(new i = 0; i < MAX_AF_FORMS; i++)
        if(AF_Forms[i][afUsed] && AF_Forms[i][afID] == formid)
            return i;
    return -1;
}

stock SendAdminLog(const message[])
{
    new msg[256];
    format(msg, sizeof(msg), "{CCCCCC}%s", message);
    SendAdminMessage(-1, msg);
}

CMD:af(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 1 || !Player[playerid][pAdminAuth])
        return SendClientMessage(playerid, COLOR_GREY, "Команда доступна только администраторам.");
    
    ShowPlayerDialog(playerid, DIALOG_AF_MAIN, DIALOG_STYLE_LIST,
        "{E0584B}BR BONUS {FFFFFF}| Админ-формы",
        "Поместить список отправленных форм\nСоздать форму для администрации",
        "Выбрать", "Закрыть");
    return 1;
}

stock AF_ShowMainMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_AF_MAIN, DIALOG_STYLE_LIST,
        "{E0584B}BR BONUS {FFFFFF}| Админ-формы",
        "Поместить список отправленных форм\nСоздать форму для администрации",
        "Выбрать", "Закрыть");
    return 1;
}

stock GetPlayerAdminLevel(playerid)
{
    return Player[playerid][pAdminLvl];
}

stock GetAHelpCountByLevel(level)
{
    new count;
    for(new i = 0; i < sizeof(AHelpData); i++)
    {
        if(AHelpData[i][aLevel] == level) count++;
    }
    return count;
}

stock GetAHelpTextByIndex(level, index, mode, cmd[], cmd_size, desc[], desc_size)
{
    new pos;
    for(new i = 0; i < sizeof(AHelpData); i++)
    {
        if(AHelpData[i][aLevel] != level) continue;

        if(pos == index)
        {
            if(mode == AHELP_MODE_SHORT) format(cmd, cmd_size, "%s", AHelpData[i][aShort]);
            else format(cmd, cmd_size, "%s", AHelpData[i][aFull]);

            format(desc, desc_size, "%s", AHelpData[i][aDesc]);
            return 1;
        }
        pos++;
    }
    return 0;
}

stock ShowAHelpPage(playerid, mode, page)
{
    new adminlvl = GetPlayerAdminLevel(playerid);

    if(page < 1) page = 1;
    if(page > 6) page = 6;

    new title[128], string[4096], line[196];
    new count = GetAHelpCountByLevel(page);
    new cmd[64], desc[96];
    new row = 0;

    if(mode == AHELP_MODE_SHORT)
    {
        format(title, sizeof(title), "{DD5757}BR BONUS | {FFFFFF}Сокращенные команды [%d ур.]", page);
    }
    else
    {
        format(title, sizeof(title), "{DD5757}BR BONUS | {FFFFFF}Все команды [%d ур.]", page);
    }

    string[0] = EOS;
    strcat(string, "{DD5757}Номер\t{DD5757}Наименование\t{DD5757}Описание\n");

    for(new i = 0; i < count; i++)
    {
        GetAHelpTextByIndex(page, i, mode, cmd, sizeof(cmd), desc, sizeof(desc));
        row++;

        if(page <= adminlvl)
        {
            format(line, sizeof(line), "{FFFFFF}№%d\t{FFFFFF}%s\t{FFFFFF}%s\n", row, cmd, desc);
        }
        else
        {
            format(line, sizeof(line), "{FFFFFF}№%d\t{FFFFFF}%s\t{DD5757}Недоступно\n", row, cmd);
        }

        strcat(string, line);
    }

    if(page > 1)
    {
        row++;
        format(line, sizeof(line), "{DD5757}№%d\t{DD5757}Назад\t{FFFFFF}Вернуться на %d уровень\n", row, page - 1);
        strcat(string, line);
    }

    if(page < 6)
    {
        row++;

        if(page + 1 <= adminlvl)
        {
            format(line, sizeof(line), "{DD5757}№%d\t{DD5757}Далее\t{FFFFFF}Перейти на %d уровень\n", row, page + 1);
        }
        else
        {
            format(line, sizeof(line), "{DD5757}№%d\t{DD5757}Далее\t{DD5757}Недоступно\n", row);
        }

        strcat(string, line);
    }

    ShowPlayerDialog(playerid, DIALOG_AHELP_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        title,
        string,
        "Выбрать",
        "Закрыть"
    );

    SetPVarInt(playerid, "AHELP_MODE", mode);
    SetPVarInt(playerid, "AHELP_PAGE", page);
    return 1;
}

stock ShowAHelpMain(playerid)
{
    new string[512];

    string[0] = EOS;

    strcat(string, "{DD5757}Номер\t{DD5757}Наименование\t{DD5757}Доступное действие\n");
    strcat(string, "{DD5757}#1\t{FFFFFF}Сокращенные команды\t{FFFFFF}Нажмите для просмотра\n");
    strcat(string, "{DD5757}#2\t{FFFFFF}Все команды\t{FFFFFF}Нажмите для просмотра");

    ShowPlayerDialog(playerid, DIALOG_AHELP_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{DD5757}BR BONUS {FFFFFF}| Команды администратора",
        string,
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

CMD:givecal(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 2) return 1;

    new target, rewardID;
    if(sscanf(params, "ii", target, rewardID)) return SendClientMessage(playerid, -1, "Использование: /givecal <id игрока> <id награды>");

    new index = CalendarCount[target];
    CalendarRewards[target][index][calID] = index;
    CalendarRewards[target][index][calPlayerID] = target;
    CalendarRewards[target][index][calRewardID] = rewardID;
    CalendarRewards[target][index][calCollected] = 0;
    CalendarCount[target]++;

    SendClientMessage(playerid, -1, "Награда добавлена игроку.");
    return 1;
}

public Calendar_CollectReward(playerid, rewardID)
{
    for(new i = 0; i < CalendarCount[playerid]; i++)
    {
        if(CalendarRewards[playerid][i][calRewardID] == rewardID &&
           CalendarRewards[playerid][i][calCollected] == 0)
        {
            CalendarRewards[playerid][i][calCollected] = 1;

            switch(rewardID)
{
    case 1:
    {
        GivePlayerMoneyEx(playerid, 10000);
    }
    case 2:
    {
        GivePlayerBlackCoin(playerid, 50);
    }
    case 3:
    {
        GivePlayerExp(playerid, 5);
    }
}
            ShowPlayerCalendar(playerid); // обновление GUI
            return 1;
        }
    }
    return 0;
}

CMD:calendar(playerid, params[])
{
    ShowPlayerCalendar(playerid);
    return 1;
}

stock ShowPlayerCalendar(playerid)
{
    new Node:response = JSON_Object();
    new Node:rewardsArray = JSON_Array();

    for(new i = 0; i < CalendarCount[playerid]; i++)
    {
        new Node:rewardNode = JSON_Object();
        JSON_SetInt(rewardNode, "id", CalendarRewards[playerid][i][calRewardID]);
        JSON_SetInt(rewardNode, "collected", CalendarRewards[playerid][i][calCollected]);
        JSON_ArrayAppend(rewardsArray, "", rewardNode);
    }

    JSON_SetArray(response, "rewards", rewardsArray);
    OnPacketIncoming(playerid, 71, response); // <- правильный ID GUI
    JSON_Cleanup(rewardsArray);
    JSON_Cleanup(response);
}

public RemoveRentVehicle(playerid)
{
    if(RentVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(RentVehicle[playerid]);
        RentVehicle[playerid] = INVALID_VEHICLE_ID;
        ShowNotification(playerid, 1, 5, 0, 0, "Арендованный транспорт был удалён системой", "");
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{
    Trunk_CheckNearOwnVehicle(playerid);
    return 1;
}

stock NewsStart(playerid)
{
    SetTimerEx("NewsStart_Delayed", 10000, false, "d", playerid);
}

forward NewsStart_Delayed(playerid);
public NewsStart_Delayed(playerid)
{
    callcmd::newsstart(playerid, "");
}

CMD:newsstart(playerid, params[])
{
    new json1[] = "\
    {\
        \"b\":[\
            {\"btn\":0,\"id\":1,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0},{\"aid\":5,\"s\":0}],\"sh\":1,\"t\":0},\
            {\"btn\":0,\"id\":2,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0}],\"sh\":1,\"t\":0},\
            {\"btn\":0,\"id\":3,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0}],\"sh\":1,\"t\":0},\
            {\"btn\":0,\"id\":4,\"n\":0,\"p\":0,\"r\":[],\"sh\":1,\"t\":67642},\
            {\"btn\":0,\"id\":5,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0}],\"sh\":1,\"t\":0},\
            {\"btn\":0,\"id\":13,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0},{\"aid\":5,\"s\":0}],\"sh\":1,\"t\":0},\
            {\"btn\":1,\"id\":14,\"n\":1,\"p\":0,\"r\":[{\"aid\":1,\"s\":0,\"t\":0},{\"aid\":2,\"s\":0,\"t\":0},{\"aid\":3,\"s\":0,\"t\":0},{\"aid\":4,\"s\":0,\"t\":0},{\"aid\":5,\"s\":0,\"t\":0}],\"sh\":1,\"t\":67642}\
        ],\
        \"o\":1\
    }";

    new Node:json;
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));

    JSON_Parse(json1, json);
    ShowPlayerGUI(playerid, 116, json);
    JSON_Cleanup(json);

    return 1;
}
