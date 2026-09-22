//>> Файл: bykranin_src/core/decl/globals_01.inc  (814 строк)
//>> Тема: макросы, константы, enum и глобальные массивы (данные, без логики)
//>> Внутри: ApplyServerBranding, BrandedShowPlayerDialog, BrandedSendClientMessage, BrandedSendClientMessageToAll, BrandedPlayerTextDrawSetString
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
#define PlatesGuiFragment                   1
#define GUIFuelFill                         2
#define BrDialogDiner                       3
#define BrDialogHack                        4
#define BrDialogRobbery                     5
#define RentGuiFragment                     6
#define BrDialogWires                       7
#define BrDialogPipes                       8
#define BrAudioDialog                       9
#define BrDialogWindow                      10
#define ChooseServerGuiFragment             11
#define BrFingerPrintDialog                 12
#define GUINotificationNewStyle             13
#define MenuComposeGUIFragment              14
#define BrDialogDance                       15
#define TaxiFragment                        16
#define TaxiOrderFragment                   17
#define TaxiRatingFragment                  18
#define TaxiMapFragment                     21
#define GUIDonate                           22
#define BrDialogSawmill                     23
#define GUISmiEditor                        24
#define GUIPlayersList                      25
#define BrNewCaptcha                        26
#define GUIRadialMenuForCar                 27
#define GUITuning                           28
#define HolidayEventsGuiFragment            30
#define GUIMiniGameEventsGame               31
#define HudManager 							32
#define GUIUsersInventory                   33
#define GUICarsTrunkOrCloset                34
#define BlackPassBannerComposeGUIFragment   35
#define GUISocialInteraction                36
#define GUIDrivingSchool                    37
#define GUIRegistration                     38
#define TutorialGuiFragment                 39
#define GUIWoundSystem                      40  // Система ранений/смерти
#define GUIVipAccount                       41
#define GUIEntertainmentSystem              42
#define GUIEntertainmentSystemFinalWindow   43
#define GUIFamilySystem                     45
#define GUIFractionSystem                   46
#define MenuSettingMainUiFragment           47
#define CraftGuiFragment                    49
#define GUISpawnLocation                    50
#define GUISocialNetworkLink                52
#define ElectricGuiFragment                 56
#define CatchStreamerGUIFragment            57
#define GUIGasmanGame                       58
#define FishingGUIFragment                  59
#define YotubePlayerFragment                61
#define InteractionWithNpcGUIFragment       63
#define HalloweenAwardGuiFragment           64
#define ActiveTaskGuiFragment               65
#define AdminToolsGuiFragment               66
#define BrSimBannerComposeGUIFragment       67
#define UpgradeObjectEventGuiFragment       68
#define GiftsGuiFragment                    69
#define PanelInfoGuiFragment                70
#define CalendarGUIFragment                 71
#define RateAppComposeGUIFragment           72
#define CasesGUIFragment                    73
#define BpRewardsGuiFragment                74
#define TanpinBannerGuiFragment             75
#define VideoPlayerGuiFragment              76
#define MarketplaceGuiFragment              77
#define ClickerGuiFragment                  79
#define ChatGuiFragment                     80
#define ModuleDialogGuiFragment             81
#define RatingGuiFragment                   82


#define INTERACTION_WITH_NPC_BUTTON_GRAY 2
#define INTERACTION_WITH_NPC_BUTTON_GREEN 1
#define INTERACTION_WITH_NPC_BUTTON_RED 3
#define INTERACTION_WITH_NPC_BUTTON_SKIP 0
new g_SpecSavedSkin[MAX_PLAYERS];
new bool:g_SpecSkinHidden[MAX_PLAYERS];


#define PACKET_BLACKRRPC                    252
#define MAX_COLOR_ID 127
new g_VehicleNumberPlate[MAX_VEHICLES][8];
new g_VehicleRegion[MAX_VEHICLES][4];
// -- pr
#define OC_VEHICLE_ID   0

#define DIALOG_TUNING 5000

#define TYPE_RU 1
#define TYPE_UA 2
#define TYPE_BY 3
#define TYPE_KZ 4

new gPlayerCountry[MAX_PLAYERS]; // страна, выбранная игроком

#define INV_ITEM_REPAIR_KIT 23
#define INV_ITEM_PLATE_RU 59
#define INV_ITEM_PLATE_UA 81
#define INV_ITEM_PLATE_BY 82
#define INV_ITEM_PLATE_KZ 83

#define INV_MODEL_PLATE_RU 1754
#define INV_MODEL_PLATE_UA 1755
#define INV_MODEL_PLATE_BY 1756
#define INV_MODEL_PLATE_KZ 1757

#define PVAR_PLATE_BUY_ACCESS "plate_buy_bc_access"
#define PVAR_PLATE_CONFIRM_SLOT "inv11_plate_confirm_slot"
#define PVAR_PLATE_CONFIRM_ITEM "inv11_plate_confirm_item"
#define PVAR_PLATE_BC_PRICE "plate_bc_price"
#define PVAR_PLATE_DRAFT_RU_NUMBER "plate_draft_ru_num"
#define PVAR_PLATE_DRAFT_RU_REGION "plate_draft_ru_reg"
#define PVAR_PLATE_DRAFT_UA_NUMBER "plate_draft_ua_num"
#define PVAR_PLATE_DRAFT_UA_REGION "plate_draft_ua_reg"
#define PVAR_PLATE_DRAFT_BY_NUMBER "plate_draft_by_num"
#define PVAR_PLATE_DRAFT_BY_REGION "plate_draft_by_reg"
#define PVAR_PLATE_DRAFT_KZ_NUMBER "plate_draft_kz_num"
#define PVAR_PLATE_DRAFT_KZ_REGION "plate_draft_kz_reg"
#define PVAR_PLATE_DRAFT_DB_LOADED "plate_draft_db_loaded"
#define PVAR_TRUNKTEST_VEHICLE "trunktest_vehicle"
#define PVAR_TRUNKTEST_HINT_TICK "trunktest_hint_tick"
#define PVAR_TRUNKTEST_HINT_VEHICLE "trunktest_hint_vehicle"
#define PVAR_TRUNKTEST_HINT_SHOWN "trunktest_hint_shown"
#define PVAR_CARLOCK_HINT_VEHICLE "carlock_hint_vehicle"
#define PVAR_CARLOCK_HINT_SHOWN "carlock_hint_shown"
#define PVAR_CARLOCK_HINT_TICK "carlock_hint_tick"
#define PVAR_CARLOCK_EXIT_TICK "carlock_exit_tick"
#define PVAR_TRUNKTEST_EXIT_TICK "trunktest_exit_tick"

#define OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED (1 << 20)

#define DIALOG_INV11_TRADE_SELECT 34110
#define DIALOG_INV11_TRADE_CONFIRM 34111
#define DIALOG_CARPASS_VIEW 34112
#define DIALOG_ANTIDM_ZONES 34160
#define DIALOG_ANTIDM_INFO 34161
#define CARPASS_INVITE_RANGE (5.0)
#define CARPASS_INVITE_TIMEOUT 30
#define COLOR_CARPASS 0x1577A8FF

#define INV11_TRADE_NEARBY_MAX 64
#define INV11_TRADE_MAX_INV_SLOTS 26
#define INV11_TRADE_NEAR_RANGE (5.0)
#define INV11_TRADE_INVITE_TIMEOUT 30
#define INV11_TRADE_MAX_MONEY 20000000
#define INV11_TRADE_CLOSE_GRACE 3

enum E_INV11_TRADE_OFFER
{
    INV11_TRADE_OFFER_USED,
    INV11_TRADE_OFFER_ITEM_ID,
    INV11_TRADE_OFFER_AMOUNT,
    INV11_TRADE_OFFER_VALUE,
    INV11_TRADE_OFFER_PLATE_TYPE,
    INV11_TRADE_OFFER_PLATE[16],
    INV11_TRADE_OFFER_REGION[8]
};

new g_inv11_trade_dialog_count[MAX_PLAYERS];
new g_inv11_trade_dialog_target[MAX_PLAYERS][INV11_TRADE_NEARBY_MAX];

new g_inv11_trade_invite_from[MAX_PLAYERS] = {-1, ...};
new g_inv11_trade_invite_to[MAX_PLAYERS] = {-1, ...};
new g_inv11_trade_invite_time[MAX_PLAYERS];

new g_inv11_trade_partner[MAX_PLAYERS] = {-1, ...};
new bool:g_inv11_trade_active[MAX_PLAYERS];
new bool:g_inv11_trade_starting[MAX_PLAYERS];
new bool:g_inv11_trade_apply[MAX_PLAYERS];
new bool:g_inv11_trade_confirm[MAX_PLAYERS];
new g_inv11_trade_money[MAX_PLAYERS];
new g_inv11_trade_offer[MAX_PLAYERS][INV11_TRADE_MAX_INV_SLOTS + 1][E_INV11_TRADE_OFFER];
new g_inv11_trade_started_at[MAX_PLAYERS];

new g_carpass_invite_from[MAX_PLAYERS] = {-1, ...};
new g_carpass_invite_time[MAX_PLAYERS];

new vehicles[100];
new Text:casino_TD[1];
new Text:TD_1223[4];
new PlayerText:PTD_1223[MAX_PLAYERS][4]; // Кликабельные текстдравы для каждого игрока

#define DIALOG_CASINO_TABLE_SETBET 29990
#define DIALOG_CASINO_TABLE_TARGET 29991
#define DIALOG_CASINO_JOB_SELECT 29992
#define DIALOG_CASINO_JOB_QUIT 29993
#define DIALOG_CASINO_EMPLOYEES 29994
#define DIALOG_CASINO_HIRE_MANAGER 29995
#define DIALOG_CASINO_FIRE_MANAGER 29996
#define DIALOG_CASINO_HIRE_DEALER 29997
#define DIALOG_CASINO_FIRE_DEALER 29998
#define DIALOG_CASINO_MANAGER_MENU 29999
#define DIALOG_CASINO_MANAGER_HIRE 30000
#define DIALOG_CASINO_MANAGER_FIRE 30001
#define DIALOG_CASINO_WITHDRAW_PROFIT 30002
new Text:casino_dice_bg;
new Text:casino_dice_title;
new Text:casino_dice_info;
new Text:casino_dice_btn_setbet;
new Text:casino_dice_btn_start;
new Text:casino_dice_btn_exit;
new Text:casino_dice_players;
new Text:casino_dice_timer;
new Text:casino_dice_table;
new Text:casino_dice_bet;
new Text:casino_dice_bank;
new Text:casino_dice_members[5];
new Text:casino_dice_members_ready[5];
new PlayerText:casino_dice_balance[MAX_PLAYERS];
#define ADMINTOOLS_BTN_STAT (10)

//НАСТРОЙКИ СЕРВЕРА
#define SERVER_NAME     "VING RUSSIA"
#define SERVER_SITE     "t.me/vingbonusnew"
#define SERVER_MAP_NAME "v16.40.0"
#define SERVER_VERSION  "Release"
#define SERVER_TG       "t.me/vingbonusnew"
#define SERVER_VK       "t.me/vingbonusnew"

// ----------------НАЗВАНИЕ АДМИН ЛВЛОВ------------------------------------------------------------------------
#define ADM_LVL1_NAME   "Младший модератор"       // 1 лвл адм
#define ADM_LVL2_NAME   "Модератор"               // 2 лвл адм
#define ADM_LVL3_NAME   "Старший модератор"       // 3 лвл адм
#define ADM_LVL4_NAME   "Администратор"           // 4 лвл адм
#define ADM_LVL5_NAME   "Старший администратор"   // 5 лвл адм (обычный)
#define ADM_LVL6_NAME   "ГС/ЗГС"// 6 лвл адм (главный следящий)
#define ADM_LVL7_NAME   "Куратор администрации"   // 7 лвл адм
#define ADM_LVL8_NAME   "Технический специалист"  // 8 лвл адм
#define ADM_LVL9_NAME   "Зам. главного администратора" // 9 лвл адм
#define ADM_LVL10_NAME  "Главный администратор"   // 10 лвл адм
#define ADM_LVL11_NAME  "Команда проекта" // 11 лвл адм (если нужно)
#define ADM_LVL12_NAME  "Заместитель основателя"  // 12 лвл адм
#define ADM_LVL13_NAME  "Разработчик" // 13 лвл адм

//=========================ПОДКЛЮЧЕНИЕ БД=======================================

enum MYSQL_SETTINGS
{
	KRANIN_HOST,
	KRANIN_USERNAME,
    KRANIN_PASSWORD,
	KRANIN_DATABASE
}
new MySQLSettings[MYSQL_SETTINGS][30];

//=========================НАЗВАНИЯ СЕРВЕРА=====================================

enum NAME_SERVER
{
	KRANIN_NAME,
	KRANIN_TG,
	KRANIN_VK,
	KRANIN_SITE
}
new NameServer[NAME_SERVER][30];
new AudioURL[256];
new CCMessage[128];

stock ApplyServerBranding(text[], size)
{
    new pos;
    while((pos = strfind(text, "{SERVER_NAME}", true)) != -1)
    {
        strdel(text, pos, pos + 13);
        strins(text, NameServer[KRANIN_NAME], pos, size);
    }
    while((pos = strfind(text, "{SERVER_SITE}", true)) != -1)
    {
        strdel(text, pos, pos + 13);
        strins(text, NameServer[KRANIN_SITE], pos, size);
    }
    while((pos = strfind(text, "{SERVER_TG}", true)) != -1)
    {
        strdel(text, pos, pos + 11);
        strins(text, NameServer[KRANIN_TG], pos, size);
    }
    while((pos = strfind(text, "{SERVER_VK}", true)) != -1)
    {
        strdel(text, pos, pos + 11);
        strins(text, NameServer[KRANIN_VK], pos, size);
    }
    return 1;
}

stock BrandedShowPlayerDialog(playerid, dialogid, style, const caption[], const info[], button1[], button2[])
{
    new branded_caption[128], branded_info[4096];
    format(branded_caption, sizeof branded_caption, "%s", caption);
    format(branded_info, sizeof branded_info, "%s", info);
    ApplyServerBranding(branded_caption, sizeof branded_caption);
    ApplyServerBranding(branded_info, sizeof branded_info);
    return ShowPlayerDialog(playerid, dialogid, style, branded_caption, branded_info, button1, button2);
}

stock BrandedSendClientMessage(playerid, color, const message[])
{
    new branded_message[256];
    format(branded_message, sizeof branded_message, "%s", message);
    ApplyServerBranding(branded_message, sizeof branded_message);
    return SendClientMessage(playerid, color, branded_message);
}

stock BrandedSendClientMessageToAll(color, const message[])
{
    new branded_message[256];
    format(branded_message, sizeof branded_message, "%s", message);
    ApplyServerBranding(branded_message, sizeof branded_message);
    return SendClientMessageToAll(color, branded_message);
}

stock BrandedPlayerTextDrawSetString(playerid, PlayerText:text, const string[])
{
    new branded_string[256];
    format(branded_string, sizeof branded_string, "%s", string);
    ApplyServerBranding(branded_string, sizeof branded_string);
    return PlayerTextDrawSetString(playerid, text, branded_string);
}

#define ShowPlayerDialog BrandedShowPlayerDialog
#define SendClientMessage BrandedSendClientMessage
#define SendClientMessageToAll BrandedSendClientMessageToAll
#define PlayerTextDrawSetString BrandedPlayerTextDrawSetString

new bool:IsPlaying[MAX_PLAYERS]; // Флаг для каждого игрока

new bool:gWhitelist; // laird
new TEST_SERVER = 0;
new bonus_money;
new bonus_donate;
new bonus_lvl;
new vip_type;

//////////////////контики
#define MAX_CONT 15
#define CLR_RED 0xFF0000FF
#define CLR_GREEN 0x00FF00FF
#define CLR_YELLOW 0xFF5252FF
#define CLR_WHITE 0xFFFFFFFF
#define DIALOG_CONT_BET 19996
#define DIALOG_CONT_NATIVE_BID 29900
#define DIALOG_CONT_NATIVE_REWARD 29901
// структура для информации о призах
enum PrizeInfo
{
    PRIZE_REGION,        // Регион приза
    PRIZE_ID,            // ID скина или модели ТС
    PRIZE_NAME[64],      // Имя приза
    PRIZE_PRICE,         // Цена приза
};

// для информации о контейнере
enum Cont_Info
{
    ContObjectId,
    ContObjectDoorLId,
    ContObjectDoorRId,
    ContObjectOdejdaId,
    ContVehicleId,
    ContVehicleColor,

    ContRegion,
    ItemType,
    Item,
    ContPrice,
    ItemPrice,
    
    bool:Saled,
    SaleTime,

    BetPrice,
    BetedId,
    BetedName[MAX_PLAYER_NAME],
};
new cInfo[MAX_CONT + 1][Cont_Info]; // +1, так как индексы используются с 1 до MAX_CONT

enum P_Info
{
    BetUseCont,
    BuyUseCont,
    CasinoDiceBet,
    CasinoDiceTable,
    bool:CasinoDiceUiOpen,
    bool:CasinoDealerJob,
    bool:CasinoManagerJob,
    bool:CasinoDiceBetPaid,
    CasinoDiceBetPaidTable
}
new pInfo[MAX_PLAYERS][P_Info];
new Text3D:ContsText[MAX_CONT + 1];
new ContsZone[MAX_CONT + 1];
new ContsTimer[MAX_CONT + 1];
new ContsRespawnTimer[MAX_CONT + 1];
const MAX_RECENT_SPAWN_STATES = MAX_PLAYERS;
const RECENT_SPAWN_EXPIRE_TIME = 15 * 60;
new g_recent_spawn_account_id[MAX_RECENT_SPAWN_STATES];
new g_recent_spawn_time[MAX_RECENT_SPAWN_STATES];
new Float:g_recent_spawn_x[MAX_RECENT_SPAWN_STATES];
new Float:g_recent_spawn_y[MAX_RECENT_SPAWN_STATES];
new Float:g_recent_spawn_z[MAX_RECENT_SPAWN_STATES];
new Float:g_recent_spawn_angle[MAX_RECENT_SPAWN_STATES];
new g_recent_spawn_interior[MAX_RECENT_SPAWN_STATES];
new g_recent_spawn_world[MAX_RECENT_SPAWN_STATES];

new Text:cont_fon;
new Text:cont_take;
new Text:cont_sell;
new Text:cont_close;
new Text:cont_name[MAX_CONT + 1];
new Text:cont_price[MAX_CONT + 1];
new Text:cont_model[MAX_CONT + 1];


enum RegionPrizes {
    REGION_RUSSIA = 1,
    REGION_CHINA,
    REGION_DUBAI,
    REGION_GERMANY
};
new const cSkin_Info[][PrizeInfo] = {
    // Россия
    {_:REGION_RUSSIA, 152, "Одежда", 236000},
    {_:REGION_RUSSIA, 240, "Одежда", 90000},
    {_:REGION_RUSSIA, 182, "Одежда", 175000},
    {_:REGION_RUSSIA, 85, "Одежда", 36000},
    {_:REGION_RUSSIA, 7, "Одежда", 45000},
    {_:REGION_RUSSIA, 91, "Одежда", 38610},
    {_:REGION_RUSSIA, 56, "Одежда", 105300},
    {_:REGION_RUSSIA, 122, "Одежда", 1000000},
    {_:REGION_RUSSIA, 75, "Одежда", 500000},
    {_:REGION_RUSSIA, 66, "Одежда", 133333},
    {_:REGION_RUSSIA, 45, "Одежда", 80000},
    {_:REGION_RUSSIA, 78, "Одежда", 50000},

    // Дубай
    {_:REGION_DUBAI, 300, "Одежда", 1000000},
    {_:REGION_DUBAI, 211, "Одежда", 5000000},
    {_:REGION_DUBAI, 99, "Одежда", 3500000},
    {_:REGION_DUBAI, 102, "Одежда", 600000},
    {_:REGION_DUBAI, 125, "Одежда", 1000000},
    {_:REGION_DUBAI, 101, "Одежда", 3850000}
};
#define DIALOG_BIZ_RENT_SELECT 5401
new const cCar_Info[][PrizeInfo] = {
    // Россия
    {_:REGION_RUSSIA, 404, "VAZ 2107", 50000},
    {_:REGION_RUSSIA, 555, "ZAZ 968", 20000},
    {_:REGION_RUSSIA, 401, "VAZ 2101", 42000},
    {_:REGION_RUSSIA, 401, "Lada Granta", 320000},
    {_:REGION_RUSSIA, 413, "Gazelle 3221", 1500000},

    // Китай
    {_:REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {_:REGION_CHINA, 523, "Yamaha FZ-10", 3905000},
    {_:REGION_CHINA, 522, "Kawasaki Ninja H2R", 3500000},
    {_:REGION_CHINA, 526, "Infiniti Q60S", 1700000},
    {_:REGION_CHINA, 603, "Ford Mustang GT", 1500000},
    {_:REGION_CHINA, 562, "Nissan Skyline R34", 500000},
    {_:REGION_CHINA, 502, "Nissan GT-R R35", 7110000},
    {_:REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {_:REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {_:REGION_CHINA, 445, "Acura TSX", 1035000},
    {_:REGION_CHINA, 527, "BMW M3 E46", 945000},

    // Дубай
    {_:REGION_DUBAI, 494, "BMW I8 EDrive", 11850000},
    {_:REGION_DUBAI, 2549, "Lamborghini Huracan", 14850000},
    {_:REGION_DUBAI, 2551, "Lamborghini Urus", 13770000},
    {_:REGION_DUBAI, 400, "BMW X6M F16", 7740000},
    {_:REGION_DUBAI, 505, "Cadillac Escalade", 6480000},
    {_:REGION_DUBAI, 475, "Audi Q7", 5400000},
    {_:REGION_DUBAI, 466, "BMW M5 F90", 8910000},
    {_:REGION_DUBAI, 502, "Nissan GT-R R35", 7110000},
    {_:REGION_DUBAI, 604, "Porsche Panamera S", 8100000},
    {_:REGION_DUBAI, 480, "BMW Z4 M40i", 4410000},
    {_:REGION_DUBAI, 470, "ГАЗ Тигр", 30000000},
    {_:REGION_DUBAI, 500, "ГАЗ 69", 30000000},
    {_:REGION_DUBAI, 596, "BMW M5 F90 (ППС)", 30000000},
    {_:REGION_DUBAI, 490, "Range Rover SVR", 0},
    {_:REGION_DUBAI, 429, "Mercedes-Benz GT-R", 12150000},

    {_:REGION_DUBAI, 2569, "Bugatti La Noire", 1000000000},
    {_:REGION_DUBAI, 2570, "Bugatti Divo", 380000000},
    {_:REGION_DUBAI, 2601, "Bugatti Chiron", 210000000},
    {_:REGION_DUBAI, 2600, "Bentley Mulliner Bacalar", 125000000},
    {_:REGION_DUBAI, 28731, "Rolls Royce Spectre", 80000000},
    {_:REGION_DUBAI, 28708, "Lamborghini Veneno 2013", 80000000},
    {_:REGION_DUBAI, 28719, "Porsche Mission R", 80000000},
    {_:REGION_DUBAI, 28689, "Bugatti Centodieci", 70000000},
    {_:REGION_DUBAI, 2607, "BMW M1", 70000000},
    {_:REGION_DUBAI, 665, "Bugatti W16 Mistral", 60000000},
    {_:REGION_DUBAI, 28716, "Chevrolet Camaro 2026", 60000000},
    {_:REGION_DUBAI, 28717, "McLaren P1", 60000000},
    {_:REGION_DUBAI, 28705, "Koenigsegg CCXR", 60000000},
    {_:REGION_DUBAI, 2591, "Bentley Continental GT", 55000000},
    {_:REGION_DUBAI, 772, "BMW M5 CS", 55000000},
    {_:REGION_DUBAI, 28682, "Lamborghini Countach (2022)", 55000000},
    {_:REGION_DUBAI, 28661, "Ferrari SF90 Stradale Spider", 55000000},
    {_:REGION_DUBAI, 666, "Bugatti Veyron", 50000000},
    {_:REGION_DUBAI, 2563, "Rolls-Royce Phantom", 50000000},
    {_:REGION_DUBAI, 755, "Porsche 918 Spyder", 45000000},
    {_:REGION_DUBAI, 765, "Mercedes-Benz G63 AMG 6x6", 45000000},
    {_:REGION_DUBAI, 667, "Koenigsegg Regera", 45000000},
    {_:REGION_DUBAI, 28672, "Mercedes-Benz G 63 AMG Brabus", 44000000},
    {_:REGION_DUBAI, 661, "Ferrari 812 Superfast", 40000000},
    {_:REGION_DUBAI, 28704, "Lincoln Phaeton HOT-ROD 1932", 40000000},
    {_:REGION_DUBAI, 28680, "Ferrari 308 GTB", 40000000},
    {_:REGION_DUBAI, 28706, "BMW M4 CSL", 40000000},
    {_:REGION_DUBAI, 2564, "Rolls-Royce Cullinan", 40000000},
    {_:REGION_DUBAI, 28723, "Lamborghini Aventador SV 2017", 40000000},
    {_:REGION_DUBAI, 631, "Hot-Road F132", 40000000},
    {_:REGION_DUBAI, 598, "Volkswagen Jetta", 35000000},
    {_:REGION_DUBAI, 2583, "Rolls-Royce Wraith", 35000000},
    {_:REGION_DUBAI, 657, "Pagani Zonda", 30000000},
    {_:REGION_DUBAI, 632, "SCG 003", 30000000},
    {_:REGION_DUBAI, 2597, "Aurus Senat", 30000000},
    {_:REGION_DUBAI, 416, "Mercedes-Benz Sprinter", 30000000},
    {_:REGION_DUBAI, 2619, "Ferrari 488 Pista", 26000000},
    {_:REGION_DUBAI, 2558, "Mercedes-Benz MB S650", 25000000},
    {_:REGION_DUBAI, 2590, "Mercedes-Benz EQS580", 24000000},
    {_:REGION_DUBAI, 2573, "Mercedes-Benz G63 AMG", 23000000},
    {_:REGION_DUBAI, 2543, "Tesla Model X", 21000000},
    {_:REGION_DUBAI, 28679, "Lenco BearCat G2", 20000000},
    {_:REGION_DUBAI, 669, "Tesla CyberTruck", 20000000},
    {_:REGION_DUBAI, 28660, "Audi RS Q e-tron Dacar", 20000000},
    {_:REGION_DUBAI, 415, "Lamborghini Aventador S", 20000000},
    {_:REGION_DUBAI, 28724, "Audi A8 Police", 20000000},
    {_:REGION_DUBAI, 668, "Ferrari LaFerrari", 20000000},
    {_:REGION_DUBAI, 582, "Ford Transit", 20000000},
    {_:REGION_DUBAI, 597, "ВАЗ 2170", 20000000},
    {_:REGION_DUBAI, 740, "Audi R8 LMS GT2", 20000000},
    {_:REGION_DUBAI, 2579, "BMW M8 F93 Gran Coupe", 19000000},
    {_:REGION_DUBAI, 411, "Aston Martin DB11", 18500000},
    {_:REGION_DUBAI, 2581, "Porsche Taycan Turbo S", 18300000},
    {_:REGION_DUBAI, 541, "Ferrari 488 GTB", 17500000},
    {_:REGION_DUBAI, 2578, "BMW M8 F92", 17200000},
    {_:REGION_DUBAI, 579, "Mercedes-Benz G65 AMG", 17050000},
    {_:REGION_DUBAI, 679, "Audi A8 2022", 17000000},
    {_:REGION_DUBAI, 2393, "Chevrolet Corvette C8", 17000000},
    {_:REGION_DUBAI, 680, "Range Rover Velar", 15000000},
    {_:REGION_DUBAI, 2544, "Tesla Model S", 15000000},
    {_:REGION_DUBAI, 2386, "Audi RS6 C8", 14800000},
    {_:REGION_DUBAI, 2626, "Porsche Cayenne S", 14700000},
    {_:REGION_DUBAI, 2599, "BMW 7-Series 750Li", 14300000},
    {_:REGION_DUBAI, 451, "McLaren 600LT", 14000000},
    {_:REGION_DUBAI, 2391, "BMW X5M G05", 13000000},
    {_:REGION_DUBAI, 28693, "Audi e-tron GT", 12000000},
    {_:REGION_DUBAI, 2572, "Raesr Tachyon 2019", 12000000},
    {_:REGION_DUBAI, 2559, "Cadillac Escalade", 11500000},
    {_:REGION_DUBAI, 2546, "Mercedes-Benz E63S", 11500000},
    {_:REGION_DUBAI, 2575, "Lexus LX570", 11455000},
    {_:REGION_DUBAI, 533, "Audi R8 V10", 11000000},
    {_:REGION_DUBAI, 2574, "BMW X7 M50i", 10500000},
    {_:REGION_DUBAI, 2582, "Mercedes-Benz CLS63 AMG", 10300000},
    {_:REGION_DUBAI, 420, "Audi RS6 C7 Рестайлинг", 10000000},
    {_:REGION_DUBAI, 2545, "Audi RS7 Sport", 9500000},
    {_:REGION_DUBAI, 763, "Volkswagen Touareg 2022", 9300000},
    {_:REGION_DUBAI, 2550, "Mercedes-Benz GLS 400", 9150000},
    {_:REGION_DUBAI, 506, "Porsche 911 Carrera S", 9000000},
    {_:REGION_DUBAI, 2602, "Chevrolet Tahoe RST", 8900000},
    {_:REGION_DUBAI, 2389, "BMW M6 F12", 8700000},
    {_:REGION_DUBAI, 405, "Audi RS6", 8500000},
    {_:REGION_DUBAI, 614, "ЗИЛ 4104", 8500000},
    {_:REGION_DUBAI, 28697, "Lexus IS500F Performance", 8000000},
    {_:REGION_DUBAI, 2593, "Lamborghini Gallardo", 8000000},
    {_:REGION_DUBAI, 2547, "Toyota Land Cruiser 200", 7800000},
    {_:REGION_DUBAI, 2598, "BMW M4 G82", 7700000},
    {_:REGION_DUBAI, 2603, "Mercedes-Benz E63 W212", 7500000},
    {_:REGION_DUBAI, 28667, "Tank 500", 7500000},
    {_:REGION_DUBAI, 402, "Mercedes-Benz GT63s", 7000000},
    {_:REGION_DUBAI, 622, "AUDI S5 Coupe 2020", 7000000},
    {_:REGION_DUBAI, 28732, "Hummer H3T Alpha", 7000000},
    {_:REGION_DUBAI, 2571, "Volkswagen Station Delux", 7000000},
    {_:REGION_DUBAI, 2586, "Jaguar XK120 Roadster", 7000000},
    {_:REGION_DUBAI, 2617, "Hummer Humvee", 7000000},
    {_:REGION_DUBAI, 2585, "Mercedes-Benz 300SL Coupe", 7000000},
    {_:REGION_DUBAI, 434, "Ford 1933 HotRod", 7000000},
    {_:REGION_DUBAI, 2377, "Lykan HyperSport", 7000000},
    {_:REGION_DUBAI, 2553, "Audi Q7", 7000000},
    {_:REGION_DUBAI, 613, "Lincoln Navigator", 6500000},
    {_:REGION_DUBAI, 410, "Mercedes-Benz C63s AMG", 6200000},
    {_:REGION_DUBAI, 503, "Dodge Demon SRT", 6100000},
    {_:REGION_DUBAI, 2595, "Porsche 911 Singer", 6000000},
    {_:REGION_DUBAI, 28694, "Zeekr 001", 6000000},
    {_:REGION_DUBAI, 2392, "Toyota Supra A90", 5900000},
    {_:REGION_DUBAI, 495, "Ford Raptor F-150", 5757000},
    {_:REGION_DUBAI, 558, "BMW M4 F84", 5500000},
    {_:REGION_DUBAI, 2608, "Jeep Wrangler", 5300000},
    {_:REGION_DUBAI, 2622, "Ford Mustang Mach E", 5200000},
    {_:REGION_DUBAI, 2388, "BMW M5 F10", 5100000},
    {_:REGION_DUBAI, 28720, "Ford Mustang GT3", 5000000},
    {_:REGION_DUBAI, 2592, "Lotus Exige Halloween", 5000000},
    {_:REGION_DUBAI, 2606, "AC Shelby Cobra", 5000000},
    {_:REGION_DUBAI, 660, "Boss 302 Mustang", 5000000},
    {_:REGION_DUBAI, 630, "FORD FALCON XB", 5000000},
    {_:REGION_DUBAI, 28690, "International S 1700 School bus", 5000000},
    {_:REGION_DUBAI, 2394, "Dodge Charger SRT", 5000000},
    {_:REGION_DUBAI, 28662, "BMW X5M F85", 5000000},
    {_:REGION_DUBAI, 2577, "Morris Minor", 5000000},
    {_:REGION_DUBAI, 28709, "Cadillac Escalade V", 5000000},
    {_:REGION_DUBAI, 2387, "BMW 3-Series G20", 4700000},
    {_:REGION_DUBAI, 543, "Chevrolet Camaro ZL1", 4600000},
    {_:REGION_DUBAI, 658, "KIA Carnival", 4400000},
    {_:REGION_DUBAI, 489, "Volvo XC90", 4200000},
    {_:REGION_DUBAI, 633, "Mitsubishi Eclipse", 4000000},
    {_:REGION_DUBAI, 576, "Marussia B2", 4000000},
    {_:REGION_DUBAI, 28721, "VAZ 2109 Turbo Edition", 4000000},
    {_:REGION_DUBAI, 757, "Marussia B2", 4000000},
    {_:REGION_DUBAI, 2596, "Dodge RAM TRX", 4000000},
    {_:REGION_DUBAI, 659, "Renault R5 Turbo 3E 2022", 3600000},
    {_:REGION_DUBAI, 28725, "GMC Vandura", 3500000},
    {_:REGION_DUBAI, 739, "Toyota Celica", 3500000},
    {_:REGION_DUBAI, 656, "Nissan 240SX", 3000000},
    {_:REGION_DUBAI, 28663, "Mercedes-Benz R230", 3000000},
    {_:REGION_DUBAI, 756, "Toyota GT86", 3000000},
    {_:REGION_DUBAI, 28707, "Ford Econoline Club Wagon", 3000000},
    {_:REGION_DUBAI, 438, "Gaz 2402 Halloween", 3000000},
    {_:REGION_DUBAI, 28683, "Subaru Impreza II WRX STi", 3000000},
    {_:REGION_DUBAI, 2609, "Mini Cooper", 2850000},
    {_:REGION_DUBAI, 28722, "Volkswagen T2", 2700000},
    {_:REGION_DUBAI, 28681, "Toyota Supra A70 mk3", 2500000},
    {_:REGION_DUBAI, 637, "Ferrari 330 p4", 2500000},
    {_:REGION_DUBAI, 28671, "Haval F7X", 2500000},
    {_:REGION_DUBAI, 625, "Hudson Hornet", 2500000},
    {_:REGION_DUBAI, 766, "Marussia B1", 2200000},
    {_:REGION_DUBAI, 28710, "Lamborghini Reventon", 2200000},
    {_:REGION_DUBAI, 28654, "Lamborghini Miura Roadster", 2200000},
    {_:REGION_DUBAI, 28698, "Ferrari Dino 246 GT", 2200000},
    {_:REGION_DUBAI, 28684, "Bentley Azure mk2", 2200000},
    {_:REGION_DUBAI, 28673, "Porsche 930", 2100000},
    {_:REGION_DUBAI, 28726, "BMW 635CSi (E24) 2025", 2100000},
    {_:REGION_DUBAI, 742, "Porsche GT3 RS 992", 2100000},
    {_:REGION_DUBAI, 2594, "Subaru BRZ", 2000000},
    {_:REGION_DUBAI, 748, "Lancia Stratos", 2000000},
    {_:REGION_DUBAI, 617, "BMW M4 GT3", 1800000},
    {_:REGION_DUBAI, 770, "Mercedes-Benz S-Class w221", 1700000},
    {_:REGION_DUBAI, 28676, "Mazda RX7 Veilside", 1700000},
    {_:REGION_DUBAI, 2605, "Ferrari California T", 1690000},
    {_:REGION_DUBAI, 2632, "Toyota Hilux Dakar", 1690000},
    {_:REGION_DUBAI, 624, "Mercedes-Benz AMG Project One", 1600000},
    {_:REGION_DUBAI, 28657, "BMW M4 Convertible", 1600000},
    {_:REGION_DUBAI, 28687, "Mercedes-Benz CLS 55 AMG", 1600000},
    {_:REGION_DUBAI, 28701, "Mercedes-Benz SL65 AMG", 1600000},
    {_:REGION_DUBAI, 28713, "BMW M8 Competition Coupe", 1600000},
    {_:REGION_DUBAI, 2398, "Flanker F", 1600000},
    {_:REGION_DUBAI, 768, "Mercedes Benz g500 Police", 1500000},
    {_:REGION_DUBAI, 752, "Mercedes-AMG E63 S Wagon", 1400000},
    {_:REGION_DUBAI, 615, "Mercedes-Benz CLK-GTR", 1400000},
    {_:REGION_DUBAI, 746, "Lamborghini Countach", 1400000},
    {_:REGION_DUBAI, 628, "Lamborghini Murcielago", 1400000},
    {_:REGION_DUBAI, 769, "Lamborghini LM002", 1300000},
    {_:REGION_DUBAI, 28656, "Jeep Wrangler Rubicon", 1300000},
    {_:REGION_DUBAI, 28712, "Mercedes-Benz X-Class", 1300000},
    {_:REGION_DUBAI, 28700, "Jeep Cherokee 1993", 1300000},
    {_:REGION_DUBAI, 28675, "Dodge Charger Police", 1300000},
    {_:REGION_DUBAI, 28686, "Jeep Grand Cherokee SRT8", 1300000},
    {_:REGION_DUBAI, 28729, "Mercedes-Benz 500 SL R107", 1300000},
    {_:REGION_DUBAI, 2633, "Ford GT Sport", 1200000},
    {_:REGION_DUBAI, 671, "Lotus Emira", 1200000},
    {_:REGION_DUBAI, 2373, "Lamborghini Diablo SV", 1200000},
    {_:REGION_DUBAI, 545, "Daewoo Matiz Sport", 1200000},
    {_:REGION_DUBAI, 673, "Toyota AE86", 1200000},
    {_:REGION_DUBAI, 674, "Nissan Skyline R32", 1200000},
    {_:REGION_DUBAI, 670, "Acura NSX 2023", 1200000},
    {_:REGION_DUBAI, 2371, "Chevrolet Corvette C6", 1200000},
    {_:REGION_DUBAI, 2372, "Mercedes-Benz SLR McLaren", 1200000},
    {_:REGION_DUBAI, 639, "Chevrolet Camaro SS", 1200000},
    {_:REGION_DUBAI, 751, "Hummer H2", 1200000},
    {_:REGION_DUBAI, 2407, "DeLorean DMC", 1200000},
    {_:REGION_DUBAI, 2374, "Ford Mustang Eleanor", 1200000},
    {_:REGION_DUBAI, 2375, "Bugatti Type 57SC Atlantic", 1200000},
    {_:REGION_DUBAI, 642, "BMW M3 G81", 1200000},
    {_:REGION_DUBAI, 2406, "Ferrari Enzo", 1200000},
    {_:REGION_DUBAI, 2405, "Honda NSX", 1200000},
    {_:REGION_DUBAI, 2404, "Ferrari Testarossa", 1200000},
    {_:REGION_DUBAI, 2403, "Mercedes-Benz SLS AMG", 1200000},
    {_:REGION_DUBAI, 2402, "Hennessey Venom GT", 1200000},
    {_:REGION_DUBAI, 2401, "Ferrari F40", 1200000},
    {_:REGION_DUBAI, 2400, "Saleen S7", 1200000},
    {_:REGION_DUBAI, 2399, "Lamborghini Sesto Elemento", 1200000},
    {_:REGION_DUBAI, 2397, "Nissan 370Z", 1200000},
    {_:REGION_DUBAI, 2396, "Mazda RX-8", 1200000},
    {_:REGION_DUBAI, 2395, "Mitsubishi Lancer Evo 8", 1200000},
    {_:REGION_DUBAI, 641, "Ford Bronco VI", 1200000},
    {_:REGION_DUBAI, 2631, "Subaru WRX STI Rally", 1200000},
    {_:REGION_DUBAI, 602, "Brawn GP F1", 1200000},
    {_:REGION_DUBAI, 2630, "Москвич 412 Rally", 1200000},
    {_:REGION_DUBAI, 745, "Dodge Viper GTC", 1200000},
    {_:REGION_DUBAI, 764, "BMW Alpina B12 E32", 1200000},
    {_:REGION_DUBAI, 767, "Lincoln Town Car", 1200000},
    {_:REGION_DUBAI, 618, "Ford Torino", 1200000},
    {_:REGION_DUBAI, 616, "Chevrolet Silverado 6x6", 1200000},
    {_:REGION_DUBAI, 672, "Mazda MX-5 Miata", 1200000},
    {_:REGION_DUBAI, 629, "Dodge Ice Charger", 1100000},
    {_:REGION_DUBAI, 28674, "Mitsubishi Lancer EVO 7", 1100000},
    {_:REGION_DUBAI, 28699, "Cadillac Miller-Meteor 1959 Ecto-1", 1100000},
    {_:REGION_DUBAI, 627, "Ferrari Daytona", 1100000},
    {_:REGION_DUBAI, 28728, "Honda RD1 CR-V 5", 1100000},
    {_:REGION_DUBAI, 626, "Chevrolet 3100 Tow Truck", 1100000},
    {_:REGION_DUBAI, 28711, "Jeep Grand Wagoneer 1990", 1100000},
    {_:REGION_DUBAI, 28655, "Volkswagen Beetle Baja Bug", 1100000},
    {_:REGION_DUBAI, 28685, "Chevrolet Camaro Z28", 1100000},
    {_:REGION_DUBAI, 635, "Chevrolet Bel Air", 1100000},
    {_:REGION_DUBAI, 28678, "Volvo 240 GL", 1000000},
    {_:REGION_DUBAI, 744, "Toyota Tundra Nascar", 1000000},
    {_:REGION_DUBAI, 477, "Mazda RX-7", 1000000},
    {_:REGION_DUBAI, 749, "Dodge Demon SRT Off-Road", 1000000},
    {_:REGION_DUBAI, 612, "Ford Crown Victoria", 1000000},
    {_:REGION_DUBAI, 743, "Mercedes-Benz 190E Evo II", 1000000},
    {_:REGION_DUBAI, 747, "BMW 3.5 CSL 1974", 900000},
    {_:REGION_DUBAI, 771, "ГАЗ-21 Coupe", 900000},
    {_:REGION_DUBAI, 753, "Иж-2715", 900000},
    {_:REGION_DUBAI, 28658, "Buick GSX 1970", 800000},
    {_:REGION_DUBAI, 28688, "BMW E28 Alpina", 800000},
    {_:REGION_DUBAI, 28677, "VAZ 2106 (Hoonicorn style)", 800000},
    {_:REGION_DUBAI, 28702, "Dodge Charger R/T 1969", 800000},
    {_:REGION_DUBAI, 28714, "Fiat mini 500", 800000},
    {_:REGION_DUBAI, 28730, "VAZ-2105 Street 1996", 800000},
    {_:REGION_DUBAI, 619, "Lada Kalina Sport", 700000},
    {_:REGION_DUBAI, 2408, "Peugeot 406", 300000},
    {_:REGION_DUBAI, 567, "Chevrolet Impala 1967", 300000},
    {_:REGION_DUBAI, 2409, "Honda S2000", 300000},
    {_:REGION_DUBAI, 647, "Медведь", 100000},
    {_:REGION_DUBAI, 646, "Бекас", 100000},
    {_:REGION_DUBAI, 648, "Волколак", 100000},
    {_:REGION_DUBAI, 654, "Слейпнир", 100000},
    {_:REGION_DUBAI, 650, "Койот", 100000},
    {_:REGION_DUBAI, 649, "Каракал", 100000},
    // Германия
    {_:REGION_GERMANY, 461, "Ducati SuperSport S", 1647000},
    {_:REGION_GERMANY, 445, "Acura TSX", 1035000},
    {_:REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {_:REGION_GERMANY, 523, "Yamaha FZ-10", 3905000},
    {_:REGION_GERMANY, 400, "BMW X6M F16", 7740000},
    {_:REGION_GERMANY, 402, "Mercedes Benz GT63s", 6320000},
    {_:REGION_GERMANY, 480, "BMW Z4 M40i", 4410000},
    {_:REGION_GERMANY, 445, "Acura TSX", 1035000},
    {_:REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {_:REGION_GERMANY, 565, "Mercedes-Benz A45 AMG", 2200000},
    {_:REGION_GERMANY, 445, "Acura TSX", 1035000},
    {_:REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {_:REGION_GERMANY, 415, "Lamborghini Aventador S", 10000000}
};
// структура для хранения информации о регионах
enum RegionInfo
{
    RegionName[15],
    ClothesPrice,
    VehiclePrice,
    ContModelId,
    VorotaModelId,
};
// Новый массив с данными о регионах и ценах
new const g_RegionData[5][RegionInfo] =
{   // {Name, Price skin, Price car, Model, Model vor}
    {"", 0, 0},
    {"Россия", 100000, 200000, 934, 933},
    {"Китай", 900000, 2000000, 954, 953},
    {"Дубай", 4350000, 9000000, 956, 955},
    {"Германия", 900000, 2000000, 958, 957}
};
// правая + 128, левая - 128
new Float: cContsPos[MAX_CONT][12] =
{   //{X,       Y,         Z,      Angel,     X Vor1,Y Vor1,Z Vor1, A,      X Vor2, Y Vor2, Z Vor2,  A}
    {690.51898,1738.27002,12.73000,0.00000,   685.03,1736.35,10.94,0.0,      685.16,1740.18,10.94,-181.0},
    {690.51898,1731.78003,12.73000,0.00000,   685.02,1729.86,10.94,0.0,      685.13,1733.69,10.94,-180.0},
    {665.81897,1726.96997,12.73000,270.00000, 663.90,1732.45,10.94,-90.0,    667.73,1732.33,10.94,90.0},
    {680.23999,1694.77002,12.73000,270.00000, 678.42,1700.18,10.94957,-89.0, 682.15,1700.08,10.94,89.0},
    {672.75598,1694.77002,12.73000,270.00000, 670.84,1700.21,10.94,-90.0,    674.67,1700.11,10.94,90.0},
    {665.81897,1694.77002,12.73000,270.00000, 663.90,1700.18,10.94,-89.0,    667.72,1700.10,10.94,90.0},
    {655.51898,1676.51001,12.73000,0.00000,   650.07,1674.59,10.94,0.0,      650.17,1678.42,10.94,180.0},
    {655.51898,1669.80005,12.73000,0.00000,   650.07,1667.88,10.94,0.0,      650.16,1671.71,10.94,180.0},
    {655.51898,1663.40002,12.73000,0.00000,   650.05,1661.48,10.94,0.0,      650.20,1665.31,10.94,180.0},
    {631.91901,1709.30005,12.73000,180.00000, 637.38,1711.21,10.94,180.0,    637.34,1707.45,10.94,0.0},
    {631.91901,1702.55005,12.73000,180.00000, 637.39,1704.46,11.04,-180.0,   637.25,1700.63,11.04,0.0},
    {631.91901,1695.93994,12.73000,180.00000, 637.43,1697.85,11.04,181.0,    637.35,1694.02,11.04,0.0},
    {690.51898,1725.38000,12.73000,0.00000,   685.02,1723.46,10.94,0.0,      685.13,1727.29,10.94,-180.0},
    {658.88200,1694.77002,12.73000,270.00000, 656.96,1700.18,10.94,-89.0,    660.79,1700.10,10.94,90.0},
    {631.91901,1689.33000,12.73000,180.00000, 637.43,1691.24,11.04,181.0,    637.35,1687.41,11.04,0.0}
};
new Float: ContBuyTextPos[MAX_CONT][3] =
{
    {683.51898, 1738.27002, 12.73000},
    {683.51898, 1731.78003, 12.73000},
    {665.81897, 1733.96997, 12.73000},
    {680.23999, 1701.77002, 12.73000},
    {672.75598, 1701.77002, 12.73000},
    {665.81897, 1701.77002, 12.73000},
    {648.51898, 1676.51001, 12.73000},
    {648.51898, 1669.80005, 12.73000},
    {648.51898, 1663.40002, 12.73000},
    {638.91901, 1709.30005, 12.73000},
    {638.91901, 1702.55005, 12.73000},
    {638.91901, 1695.93994, 12.73000},
    {683.51898, 1725.38000, 12.73000},
    {658.88200, 1701.77002, 12.73000},
    {638.91901, 1689.33000, 12.73000}
};
new const Float:g_cont_reward_park_pickup[4] = {629.247680, 1669.418701, 12.162509, 292.974365};
new const Float:g_cont_reward_park_slots[3][4] =
{
    {611.675292, 1691.160766, 12.162509, 89.072891},
    {612.117675, 1694.490356, 12.162509, 88.153366},
    {612.053833, 1698.455200, 12.162509, 92.536682}
};
forward TimerSecondUpdateCont(contid, moneystart[]);
forward SpawnNewCont(contid);
forward CorrectTimerMinute();
forward Case1SecondSpawnTimer(playerid);
forward SpawnSetVWZero(playerid);
forward SpectateGUIRefresh(playerid, session);
forward SpectateAttachDelayed(playerid, targetid, actor_session, target_session);
new ContArea[MAX_CONT + 1]; // Dynamic Areas для контейнеров
