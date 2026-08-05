#if defined _GORDEEV_INC_INCLUDED
    #endinput
#endif
#define _GORDEEV_INC_INCLUDED

#if !defined _samp_included
    #error "Compile gamemodes/byreytiz.pwn (or filterscript), not gordeev.inc directly."
#endif

#include "json.inc"


// ==================== WOUND SYSTEM (������� �������) ====================
// ���� �������� (���� "t" � JSON)
#define WOUND_ACTION_NEED_HELP          1   // "����� ������"
#define WOUND_ACTION_NEED_HOSPITAL      2   // "����� ��������������"
#define WOUND_ACTION_NOT_DISPLAY        3   // "������ �� ����������"
#define WOUND_ACTION_DISMISS_INTERFACE  4   // ������ ������ ���������

// �������� ���������� ������ "��������������"
#define WOUND_TIME_DEFAULT              15  // ������ (��������� ����������)
#define WOUND_TIME_NEED_HELP            30  // ������ (����� "����� ������")

// ���������� ��������
#define WOUND_HOSPITAL_X    1468.011840
#define WOUND_HOSPITAL_Y    -2500.338134
#define WOUND_HOSPITAL_Z    2501.000000
#define WOUND_HOSPITAL_A    0.0

#define REG_STAGE_NONE          0   // ����������� �� ������
#define REG_STAGE_PASSWORD      1   // ������ ������
#define REG_STAGE_REFER         2   // ������� ������
#define REG_STAGE_SEX           3   // ��� ������
#define REG_STAGE_SKIN          4   // ���� ������ (����������� ���������)

// ����: ��� �� ����� ��� ��������� � �������� (����� �� �����������)
new bool:g_wound_sent_to_hospital[MAX_PLAYERS];

// ==================== �������� GUI ������� ====================

// ==================== ��������� ����� �� ������� � ������� ====================
// ������ ����� ��������� �������: t=1 (�������� ����������) ��� t=2 (������� ���������)

// ==================== �������� � �������� ====================
stock TeleportPlayerToHospital(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(g_wound_sent_to_hospital[playerid]) return 0; // ������ �� ������������
    
    g_wound_sent_to_hospital[playerid] = true;
    
    // ������������� � �������� � ��������� ��������� (1) � ������������ ���� (1)
    // ��������: ��������� ���������� Z! 2501.000000 � ��� ����� ������. 
    // ������ �����, ��� ������ ���� 10.000000 ��� 11.000000.
    SetPlayerPosEx(playerid, 1468.011840, 2500.338134, 2501.000000, 273.362365, 1, 1, false);
    
    SetPlayerHealth(playerid, 25.0);
    
    // �����������: ���� � ��� ���� ���� �������������� � ���� ������, ���������������� ������ ����:
    // SetPlayerData(playerid, P_HOSPITAL, true);
    
    ShowNotificationNew(playerid, 3, 5, -1, -1, "�� ���� ���������� � ��������", "");
    
    SendWoundSystemPacketToClient(playerid, WOUND_ACTION_NEED_HOSPITAL);
    
    return 1;
}

//------------------------------------------------------------

new car_game_ids[][2] = {
    {5, 555},
    {6, 549},
    {7, 401},
    {8, 479},
    {9, 496},
    {10, 404},
    {11, 458},
    {12, 585},
    {13, 536},
    {14, 529},
    {15, 534},
    {16, 542},
    {17, 540},
    {18, 559},
    {19, 421},
    {20, 2554},
    {21, 2548},
    {22, 419},
    {23, 562},
    {24, 507},
    {25, 426},
    {26, 516},
    {27, 467},
    {28, 527},
    {29, 445},
    {30, 589},
    {31, 587},
    {32, 436},
    {33, 560},
    {34, 550},
    {35, 603},
    {36, 2552},
    {37, 565},
    {38, 551},
    {39, 526},
    {40, 442},
    {41, 489},
    {42, 543},
    {43, 480},
    {44, 558},
    {45, 495},
    {46, 475},
    {47, 503},
    {48, 410},
    {49, 402},
    {50, 2553},
    {51, 505},
    {52, 2547},
    {53, 502},
    {54, 400},
    {55, 604},
    {56, 405},
    {57, 506},
    {58, 2550},
    {59, 466},
    {60, 2545},
    {61, 490},
    {62, 420},
    {63, 533},
    {64, 2546},
    {65, 494},
    {66, 429},
    {67, 451},
    {68, 2544},
    {69, 2551},
    {70, 2549},
    {71, 579},
    {72, 541},
    {73, 411},
    {74, 415},
    {75, 2543},
    {76, 462},
    {77, 468},
    {78, 461},
    {79, 463},
    {80, 523},
    {81, 586},
    {82, 521},
    {83, 581},
    {84, 522},
    {85, 582},
    {86, 529},
    {87, 470},
    {88, 416},
    {89, 516},
    {90, 466},
    {195, 440},
    {201, 413},
    {202, 418},
    {211, 2555},
    {212, 2557},
    {213, 2565},
    {214, 2566},
    {215, 2560},
    {216, 2561},
    {217, 2568},
    {218, 2567},
    {219, 2559},
    {220, 2558},
    {221, 2564},
    {222, 2563},
    {223, 2570},
    {224, 2569},
    {275, 2571},
    {276, 2572},
    {327, 2574},
    {328, 2575},
    {329, 2573},
    {330, 2577},
    {331, 2576},
    {347, 2580},
    {348, 2584},
    {349, 2582},
    {350, 2579},
    {351, 2578},
    {352, 2581},
    {353, 2583},
    {366, 2586},
    {367, 2585},
    {400, 412},
    {401, 439},
    {402, 492},
    {403, 547},
    {404, 491},
    {405, 546},
    {406, 2589},
    {407, 2588},
    {408, 2587},
    {409, 483},
    {410, 2590},
    {411, 2591},
    {413, 452},
    {414, 453},
    {415, 454},
    {416, 472},
    {417, 473},
    {418, 493},
    {424, 2592},
    {426, 2594},
    {427, 2596},
    {428, 2595},
    {429, 2593},
    {444, 2597},
    {445, 2598},
    {446, 2599},
    {447, 2600},
    {448, 2601},
    {449, 2602},
    {450, 2603},
    {451, 2604},
    {452, 2607},
    {453, 2608},
    {454, 2609},
    {455, 2610},
    {456, 2611},
    {459, 448},
    {460, 2616},
    {461, 2617},
    {465, 2618},
    {466, 2619},
    {467, 2620},
    {468, 2621},
    {469, 2622},
    {470, 2623},
    {471, 2624},
    {472, 2625},
    {473, 2626},
    {474, 2627},
    {484, 434},
    {485, 2377},
    {498, 2380},
    {499, 2381},
    {500, 2385},
    {501, 2386},
    {502, 2387},
    {503, 2388},
    {504, 2389},
    {505, 2390},
    {506, 2391},
    {507, 2392},
    {508, 2393},
    {509, 2394},
    {510, 2382},
    {511, 2383},
    {512, 2384},
    {522, 614},
    {523, 613},
    {524, 622}
};

new clothes_game_ids[][2] = {
    {210, 122},
    {209, 270},
    {344, 302},
    {345, 301},
    {338, 89},
    {339, 88},
    {341, 10},
    {342, 92},
    {343, 99},
    {231, 208},
    {535, 6871},
    {536, 6872},
    {529, 6894},
    {337, 243},
    {527, 6892},
    {425, 5362},
    {346, 2},
    {333, 129},
    {334, 130},
    {335, 24},
    {340, 197},
    {336, 245},
    {316, 165},
    {317, 166},
    {318, 174},
    {319, 5},
    {320, 267},
    {321, 283},
    {325, 162},
    {326, 210},
    {390, 310},
    {395, 18624},
    {396, 18625},
    {398, 18628},
    {397, 18626},
    {232, 199},
    {233, 264},
    {234, 262},
    {235, 62},
    {391, 18621},
    {392, 311},
    {393, 18620},
    {394, 18623},
    {98, 200},
    {99, 234},
    {100, 249},
    {101, 235},
    {332, 196},
    {322, 49},
    {323, 53},
    {324, 160},
    {207, 48},
    {236, 298},
    {237, 266},
    {399, 18606},
    {312, 106},
    {230, 175},
    {95, 202},
    {314, 109},
    {528, 6895},
    {526, 6896},
    {525, 6893},
    {519, 6832},
    {513, 19262},
    {419, 5323},
    {430, 5326},
    {431, 5325},
    {96, 204},
    {97, 229},
    {203, 57},
    {480, 11934},
    {481, 11933},
    {482, 11935},
    {483, 11944},
    {488, 11953},
    {489, 11948},
    {490, 11951},
    {491, 11947},
    {492, 11957},
    {497, 11959},
    {313, 108},
    {311, 95},
    {206, 236},
    {93, 220},
    {94, 225},
    {229, 231},
    {516, 11961},
    {517, 11962},
    {486, 11956},
    {487, 11958},
    {208, 63},
    {91, 23},
    {92, 22},
    {420, 5367},
    {421, 5365},
    {514, 19273},
    {515, 6780},
    {475, 11917},
    {205, 252},
    {462, 12293},
    {463, 12291},
    {457, 14386},
    {458, 14388},
    {228, 269},
    {315, 110},
    {225, 86},
    {226, 224},
    {227, 232}
};
new accessories_game_ids[][2] = {
    {531, 2656},   // internalId, modelId - Надувной жилет
    {534, 677},    // Советская шапка
    {533, 676},    // Очки люкс
    {530, 2655},   // Шлем велосипедиста
    {532, 2657},   // Очки звездочки
    {518, 16055},  // Лапка анимированная
    {493, 9824},   // Веселая тыква
    {494, 9826},   // Маска зомби
    {495, 9827},   // Кукла вуду
    {496, 9828},   // Призрачный портал
    {476, 11919},  // Акула на голову
    {478, 11923},  // Мопс на спину
    {422, 13883},  // Корона демона
    {423, 14575},  // Крылья ангела
    {368, 18509},  // Кейс
    {361, 18504},  // Тролль с париком
    {362, 18505},  // �?нопланетянин с париком
    {308, 18411},  // Голубой посох
    {369, 18510},  // Кейс черный
    {370, 18511},  // Кейс серый
    {371, 18512},  // Золотая корона
    {372, 18513},  // Корона короля
    {277, 18233},  // Деревянный посох
    {279, 18243},  // Карамельная конфета
    {285, 18285},  // Посох-зонт
    {287, 18346},  // Синий посох со льдом
    {288, 18347},  // Синий посох со снежинкой
    {289, 18348},  // Голубой посох со льдом
    {290, 18369},  // Новогодний топорик
    {291, 18375},  // Новогодняя палочка
    {292, 18377},  // Очки-сердечки
    {293, 18378},  // Рюкзак 'Котик'
    {294, 18379},  // Рюкзак 'Санта-Клауса'
    {298, 18389},  // Новогодняя шапка
    {299, 18390},  // Очки моргающие глаза
    {300, 18391},  // Очки Пламя
    {301, 18392},  // Прямые очки с огнем
    {302, 18396},  // Шапка гнома
    {303, 18397},  // Зеленая маска
    {304, 18401},  // Очки с салютом
    {305, 18404},  // Прямые очки матрица
    {306, 18409},  // Очки падающие снежинки
    {307, 18410},  // Очки веселый Сквиди
    {309, 18412},  // Очки санрайз у воды
    {310, 18414},  // Прямые очки WARNING
    {274, 15158},  // Кепка
    {253, 15157},  // Рюкзак
    {266, 15151},  // Маска ведущего
    {373, 18514},  // Серебряная корона
    {374, 18515},  // Лавровый венец
    {375, 18516},  // Диадема
    {357, 18500},  // Маска клоуна
    {358, 18501},  // Маска клоуна
    {359, 18502},  // Лицо тролля
    {360, 18503},  // �?нопланетянин
    {363, 18506},  // Очки с носом
    {278, 18232},  // Берет
    {280, 18250},  // Белая панама с сигарой
    {295, 18383},  // Черная панама с сигарой
    {296, 18384},  // Серая панама с сигарой
    {297, 18385},  // Темная панама с сигарой
    {281, 18263},  // Белая панама от
    {282, 18264},  // Черная панама от
    {283, 18273},  // Высокая панама от
    {284, 18279},  // Черная шапка
    {286, 18286},  // Кандибобер
    {247, 15141},  // Шляпа
    {248, 15144},  // Неоновая маска (красная)
    {249, 15152},  // Неоновая маска синяя
    {250, 15154},  // Неоновая маска зеленая
    {251, 15153},  // Неоновая маска фиолетовая
    {252, 15155},  // Неоновая маска оранжевая
    {477, 11922},  // ГеймБой
    {479, 11925},  // Летняя доска
    {463, 13801},  // Катюша
    {464, 13803},  // Рюкзак солдатик
    {432, 14589},  // Маска оленя
    {433, 14591},  // Белые рога
    {434, 14592},  // Уши эльфа
    {436, 14596},  // Маска елочки
    {437, 14597},  // Рождественские рога
    {438, 14598},  // Маска Деда Мороза
    {439, 14603},  // Шапка-Ушанка
    {440, 4160},   // Новогодний кекс
    {441, 4161},   // Новогодний мишка
    {442, 4162},   // Маска Снегурочка
    {443, 4163},   // Маска Снеговика
    {435, 4165},   // Сумка Снеговика
    {376, 18517},  // Очки Доллар
    {377, 18518},  // Очки День рождения
    {379, 18520},  // Неоновые очки
    {380, 18521},  // Неоновые очки
    {381, 18522},  // Неоновые очки
    {383, 18524},  // Неоновые очки
    {384, 18525},  // Неоновые очки
    {385, 18526},  // Очки пиксели
    {386, 18527},  // Шар сердце
    {389, 18530},  // Шар сердце 2
    {354, 18497},  // Шарик красный
    {365, 18508},  // Парик клоуна красный
    {241, 15135},  // Шляпа ведьмы (светящаяся)
    {242, 15136},  // Шляпа ведьмы (светящаяся)
    {255, 15143},  // Красная коса
    {265, 15159},  // Маска квадрата
    {355, 18498},  // Очки 'Выпуклые глаза'
    {356, 18499},  // Очки 'Обычные глаза'
    {364, 18507},  // Нос клоуна
    {264, 15161},  // Маска треугольника
    {267, 15149},  // Метла
    {259, 15145},  // Маска Джейсона
    {260, 15146},  // Маска Ведьмы
    {261, 15147}   // Маска Пилы
};


// Support both local project layout and standard include search path.
#tryinclude "../../include/gordeev_guard.inc"
#if !defined _GORDEEV_GUARD_API_INCLUDED
    #tryinclude "gordeev_guard.inc"
#endif
#if !defined _GORDEEV_GUARD_API_INCLUDED
    // Fallback: keep runtime bridge available even if include path on build host differs.
    #define _GORDEEV_GUARD_API_INCLUDED
    native GordeevGuardLoaded();
    native GordeevGuardProof(challenge);
    native Gordeev_ShowPlayerGUI(playerid, guiid, Node:json);
    native Gordeev_HidePlayerGUI(playerid, guiid);
    native Gordeev_OnPacketIncoming(playerid, guiid, Node:json);
    native Gordeev_SendGuiPacket(playerid, guiid, const payload[]);
    native Gordeev_SendTurnLight(playerid, vehicleid, turnStatus);
#endif

#if !defined GORDEEV_PLUGIN_TRANSPORT
    // 0 = keep current Pawn transport only (safe default),
    // 1 = try plugin bridge first, then fallback to Pawn transport.
    #define GORDEEV_PLUGIN_TRANSPORT 0
#endif

#if !defined GORDEEV_PLUGIN_TURNLIGHTS
    // 0 = keep Pawn-only turnlight transport
    // 1 = try plugin turnlight bridge first, then fallback to Pawn transport.
    #define GORDEEV_PLUGIN_TURNLIGHTS 1
#endif

// GUI IDs from mode usupov/server/aboba.inc
#if !defined BrDialogVoice
    #define BrDialogVoice 0
#endif
#if !defined BrDialogPlates
    #define BrDialogPlates 1
#endif
#if !defined BrDialogFuelFill
    #define BrDialogFuelFill 2
#endif
#if !defined BrDialogDiner
    #define BrDialogDiner 3
#endif
#if !defined BrDialogHack
    #define BrDialogHack 4
#endif
#if !defined BrDialogRobbery
    #define BrDialogRobbery 5
#endif
#if !defined BrDialogRent
    #define BrDialogRent 6
#endif
#if !defined BrDialogWires
    #define BrDialogWires 7
#endif
#if !defined BrDialogPipes
    #define BrDialogPipes 8
#endif
#if !defined BrAudioDialog
    #define BrAudioDialog 9
#endif
#if !defined BrDialogWindow
    #define BrDialogWindow 10
#endif
#if !defined BrChooseServerDialog
    #define BrChooseServerDialog 11
#endif
#if !defined BrFingerPrintDialog
    #define BrFingerPrintDialog 12
#endif
#if !defined BrNotification
    #define BrNotification 13
#endif
#if !defined BrDialogMenu
    #define BrDialogMenu 14
#endif
#if !defined BrDialogDance
    #define BrDialogDance 15
#endif
#if !defined BrDialogTaxi
    #define BrDialogTaxi 16
#endif
#if !defined BrDialogTaxiOrder
    #define BrDialogTaxiOrder 17
#endif
#if !defined BrDialogTaxiRating
    #define BrDialogTaxiRating 18
#endif
#if !defined BrDialogGraphicsSetting
    #define BrDialogGraphicsSetting 19
#endif
#if !defined BrCaptcha
    #define BrCaptcha 20
#endif
#if !defined BrDialogMap
    #define BrDialogMap 21
#endif
#if !defined GUIDonate
    #define GUIDonate 22
#endif
#if !defined BrDialogSawmill
    #define BrDialogSawmill 23
#endif
#if !defined GUISmiEditor
    #define GUISmiEditor 24
#endif
#if !defined GUIPlayersList
    #define GUIPlayersList 25
#endif
#if !defined BrNewCaptcha
    #define BrNewCaptcha 26
#endif
#if !defined GUIRadialMenuForCar
    #define GUIRadialMenuForCar 27
#endif
#if !defined GUITuning
    #define GUITuning 28
#endif
#if !defined GUIHalloween
    #define GUIHalloween 30
#endif
#if !defined GUIHalloweenGame
    #define GUIHalloweenGame 31
#endif
#if !defined HudManager
    #define HudManager 32
#endif
#if !defined GUIUsersInventory
    #define GUIUsersInventory 33
#endif
#if !defined GUICarsTrunkOrCloset
    #define GUICarsTrunkOrCloset 34
#endif
#if !defined GUIBlackPassBanner
    #define GUIBlackPassBanner 35
#endif
#if !defined GUISocialInteraction
    #define GUISocialInteraction 36
#endif
#if !defined GUIDrivingSchool
    #define GUIDrivingSchool 37
#endif
#if !defined GUIRegistration
    #define GUIRegistration 38
#endif
#if !defined GUITutorial
    #define GUITutorial 39
#endif
#if !defined GUIWoundSystem
    #define GUIWoundSystem 40
#endif
#if !defined GUIVipAccount
    #define GUIVipAccount 41
#endif
#if !defined GUIEntertainmentSystem
    #define GUIEntertainmentSystem 42
#endif
#if !defined GUIFamilySystem
    #define GUIFamilySystem 45
#endif
#if !defined GUIFractionSystem
    #define GUIFractionSystem 46
#endif
#if !defined GUISpawnLocation
    #define GUISpawnLocation 50
#endif
#if !defined GUIOpenURL
    #define GUIOpenURL 51
#endif
#if !defined GUISocialNetworkLink
    #define GUISocialNetworkLink 52
#endif
#if !defined GUIInviteBanner
    #define GUIInviteBanner 55
#endif
#if !defined GUI_PANEL_INFO
    #define GUI_PANEL_INFO 70
#endif
#if !defined GUICases
    #define GUICases 73
#endif
#if !defined GUI_BP_REWARDS
    #define GUI_BP_REWARDS 74
#endif
#if !defined PACKET_BLACKRRPC
    #define PACKET_BLACKRRPC 252
#endif

#if !defined GUI_JSON_BUFFER
    #define GUI_JSON_BUFFER 8192
#endif

static g_gordeev_gui_outgoing[GUI_JSON_BUFFER];
static g_gordeev_gui_incoming[GUI_JSON_BUFFER];
static g_gordeev_tuning_center[MAX_PLAYERS];
static Float:g_gordeev_tune_return_x[MAX_PLAYERS];
static Float:g_gordeev_tune_return_y[MAX_PLAYERS];
static Float:g_gordeev_tune_return_z[MAX_PLAYERS];
static Float:g_gordeev_tune_return_a[MAX_PLAYERS];
static g_gordeev_tune_return_int[MAX_PLAYERS];
static g_gordeev_tune_return_vw[MAX_PLAYERS];
static bool:g_gordeev_tune_ret_hasveh[MAX_PLAYERS];
static g_gordeev_tune_comfort[MAX_VEHICLES];
static g_gordeev_tune_sport[MAX_VEHICLES];
static g_gordeev_tune_drift[MAX_VEHICLES];
static g_gordeev_tune_sportplus[MAX_VEHICLES];
static g_gordeev_tune_nitro[MAX_VEHICLES];
static bool:g_gordeev_tune_has_strob[MAX_VEHICLES];
static g_gordeev_tune_strob_type[MAX_VEHICLES];
static bool:g_gordeev_tune_has_pneumo[MAX_VEHICLES];
static bool:g_gordeev_tune_has_hydraulics[MAX_VEHICLES];
static bool:g_gordeev_tune_has_launch[MAX_VEHICLES];
static g_gordeev_radial_chip_mode[MAX_VEHICLES];
static g_gordeev_radial_susp_mode[MAX_VEHICLES];
static bool:g_gordeev_radial_high_on[MAX_VEHICLES];
static bool:g_gordeev_radial_strob_on[MAX_VEHICLES];
static bool:g_gordeev_radial_neon_on[MAX_VEHICLES];
static bool:g_gordeev_radial_launch_on[MAX_VEHICLES];


#define GORDEEV_TUNING_CENTER_STAIL   (1)
#define GORDEEV_TUNING_CENTER_TEX     (2)
#define GORDEEV_TUNING_CENTER_SHINKA  (3)
#define GORDEEV_TUNING_CENTER_STO     (4)

#define GORDEEV_TUNE_OP_CLOSE_MENU                    (0)
#define GORDEEV_TUNE_OP_BUY_COLOR                     (1)
#define GORDEEV_TUNE_OP_BUY_COLOR_WITH_TRANSPARENCY   (2)
#define GORDEEV_TUNE_OP_BUY_VINYL                     (3)
#define GORDEEV_TUNE_OP_DIAGNOSTIC                    (6)
#define GORDEEV_TUNE_OP_BUY_DETAIL                    (7)
#define GORDEEV_TUNE_OP_REPAIR_DETAIL                 (8)
#define GORDEEV_TUNE_OP_INSTALL_DETAIL                (10)
#define GORDEEV_TUNE_OP_BUY_COLLAPSE                  (12)
#define GORDEEV_TUNE_OP_SAVE_CAR                      (19)
#define GORDEEV_TUNE_OP_GET_NEW_COLORS                (20)
#define GORDEEV_TUNE_OP_PREVIEW_DETAIL                (22)
#define GORDEEV_TUNE_OP_PREVIEW_COLOR                 (23)
#define GORDEEV_TUNE_OP_PREVIEW_COLLAPSE              (24)
#define GORDEEV_TUNE_OP_PREVIEW_VINYL                 (25)
#define GORDEEV_TUNE_OP_GET_START_VINYLS              (26)
#define GORDEEV_TUNE_OP_GET_COLLAPSE                  (28)
#define GORDEEV_TUNE_OP_LISTEN_SOUND                  (29)

#define GORDEEV_RADIAL_OP_DISMISS                     (0)
#define GORDEEV_RADIAL_OP_PARKING                     (1)
#define GORDEEV_RADIAL_OP_KEY                         (2)
#define GORDEEV_RADIAL_OP_DOORS                       (3)
#define GORDEEV_RADIAL_OP_SUSPENSION                  (4)
#define GORDEEV_RADIAL_OP_LAUNCH                      (5)
#define GORDEEV_RADIAL_OP_ENGINE                      (6)
#define GORDEEV_RADIAL_OP_TURBO                       (7)
#define GORDEEV_RADIAL_OP_DRIFT                       (8)
#define GORDEEV_RADIAL_OP_COMFORT                     (9)
#define GORDEEV_RADIAL_OP_SPORT                       (10)
#define GORDEEV_RADIAL_OP_SPORTPLUS                   (11)
#define GORDEEV_RADIAL_OP_NEON                        (12)
#define GORDEEV_RADIAL_OP_HIGHLIGHT                   (13)
#define GORDEEV_RADIAL_OP_HEADLIGHTS                  (14)
#define GORDEEV_RADIAL_OP_STROBOSCOPE                 (15)
#define GORDEEV_RADIAL_OP_PNEUMO_1                    (16)
#define GORDEEV_RADIAL_OP_PNEUMO_2                    (17)
#define GORDEEV_RADIAL_OP_PNEUMO_3                    (18)
#define GORDEEV_RADIAL_OP_HYDRAULICS                  (19)

#define GORDEEV_RADIAL_CHIP_DEFAULT                   (0x3DCCCCCD)
#define GORDEEV_RADIAL_CHIP_COMFORT                   (0x3F666666)
#define GORDEEV_RADIAL_CHIP_DRIFT                     (0x3F800000)
#define GORDEEV_RADIAL_CHIP_SPORT                     (0x3F4CCCCD)
#define GORDEEV_RADIAL_CHIP_SPORTPLUS                 (0x3F7AE148)

#define GORDEEV_SELECTOR_COLOR_BODY                   (0)
#define GORDEEV_SELECTOR_COLOR_DISCS_1                (1)
#define GORDEEV_SELECTOR_VINYL                        (2)
#define GORDEEV_SELECTOR_TONING_FRONT                 (3)
#define GORDEEV_SELECTOR_TONING_BACK                  (4)
#define GORDEEV_SELECTOR_HORN                         (7)
#define GORDEEV_SELECTOR_EXHAUST_SOUND                (9)
#define GORDEEV_SELECTOR_COLOR_LIGHT                  (10)
#define GORDEEV_SELECTOR_COLOR_NEON_ALL               (11)
#define GORDEEV_SELECTOR_COLOR_NEON_LEFT              (12)
#define GORDEEV_SELECTOR_COLOR_NEON_RIGHT             (13)
#define GORDEEV_SELECTOR_STROBOSCOPE                  (14)
#define GORDEEV_SELECTOR_FULL_CLEARANCE               (22)
#define GORDEEV_SELECTOR_INDIVIDUAL_CLEARANCE         (23)
#define GORDEEV_SELECTOR_DEPARTURE_FRONT              (24)
#define GORDEEV_SELECTOR_DEPARTURE_BACK               (25)
#define GORDEEV_SELECTOR_COLLAPSE_FRONT               (26)
#define GORDEEV_SELECTOR_COLLAPSE_BACK                (27)
#define GORDEEV_SELECTOR_WIDTH_FRONT                  (28)
#define GORDEEV_SELECTOR_WIDTH_BACK                   (29)
#define GORDEEV_SELECTOR_RADIUS                       (30)
#define GORDEEV_SELECTOR_COLOR_DISCS_2                (32)
#define GORDEEV_SELECTOR_DIFFERENTIAL                 (36)
#define GORDEEV_SELECTOR_BRAKERS                      (37)
#define GORDEEV_SELECTOR_AIR_FILTER                   (38)
#define GORDEEV_SELECTOR_ENGINE                       (39)
#define GORDEEV_SELECTOR_SUPERCHARGER                 (40)

forward CreatePlayerAccount(playerid);
forward LoadPlayerData(playerid);
forward SavePlayerGraphicSettings(playerid);
forward LoadPlayerGraphicSettings(playerid);
forward BT_SetColor(veh, body, wheel);
forward BT_SetToner(veh, front, rear, front_side, back_side);
forward BT_SetLightColor(veh, color);
forward BT_SetNeonColor(veh, center, right, left);
forward BT_SetStroboscope(veh, tune_type);
forward BT_SetHighLight(veh, tune_type);
forward BT_SetWheelAlign(veh, front, rear);
forward BT_SetWheelDeparture(veh, front, rear);
forward BT_SetWheelWidth(veh, front, rear);
forward BT_SetWheelRadius(veh, radius);
forward BT_SetClearance(veh, clearance);
forward BT_SetSeparateClearance(veh, clearance);
forward BT_SetHorn(veh, horn_id);
forward BT_SetExhaust(veh, tune_type);
forward SetVehicleVinyl(vehicleid, texture[], setvalue=0);
forward GivePlayerMoneyEx(playerid, money, description[]="None", bool:save=true, bool:game_text=true);
forward GivePlayerDonate(playerid, donate, description[]="None", bool:save=true);
forward GordeevRadialLoadVehicleData(vehicleid, &high_light, &stroboscope_type, &chip_drift, &chip_comfort, &chip_sport, &chip_sportplus, &has_pneumo, &has_hydraulics, &has_launch);
forward GordeevRadialSaveLighting(vehicleid, high_light, stroboscope_type);
forward GordeevRadialSaveChipUnlock(vehicleid, chip_type, enabled);
forward GRadialSaveSuspUnlock(vehicleid, suspension_type, enabled);

static const g_gordeev_vinyl_names[][] = {
    "remapbody8", "remapbody5", "remapbody32", "remapbody40", "remapbody21", "remapbody29",
    "remapbody41", "remapbody6", "remapbody31", "remapbody19", "remapbody28", "remapbody30",
    "remapbody11", "remapbody12", "remapbody15", "remapbody26", "remapbody16", "remapbody13",
    "remapbody18", "remapbody35", "remapbody10", "remapbody17", "remapbody38", "remapbody2",
    "remapbody23", "remapbody36", "remapbody4", "remapbody14", "remapbody37", "remapbody20",
    "remapbody7", "remapbody25", "remapbody39", "remapbody1", "remapbody33", "remapbody9",
    "remapbody22", "remapbody24", "remapbody34", "remapbody42", "remapbody47", "remapbody48",
    "remapbody43", "remapbody44", "remapbody49", "remapbody51", "remapbody45", "remapbody46",
    "remaphbody1", "remaphbody2", "remaphbody3", "remaphbody4", "remaphbody5", "remaphbody6",
    "remaphbody7", "remaphbody8", "remaphbody9", "remaphbody10", "remaphbody11", "remapnbody1",
    "remapnbody2", "remapnbody3", "remapnbody4", "remapnbody5", "remapnbody6", "remapnbody7",
    "remapnbody8", "remapnbody9", "remapnbody10", "remapnbody11", "remapnbody12", "remapnbody13",
    "remapnbody14", "remapnbody15", "remapnbody16", "remapnbody17", "remapmbody1", "remapmbody2",
    "remapmbody3", "remapmbody4", "remapmbody5", "remapmbody6", "remapmbody7", "remapmbody8",
    "remapmbody9", "remapmbody10", "remapmbody11", "remapmbody12", "remapmbody13", "remapmbody14",
    "remapmbody15", "remapmbody16", "remapmbody17", "", "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "remapnbody18", "remapnbody19", "remapnbody20", "remapnbody21",
    "remapnbody22", "remapnbody23", "remapnbody24", "remapnbody25", "remapnbody26", "remapnbody27"
};

stock Gordeev_LocalProof(challenge)

{

    new v = challenge ^ 0x9E3779B9;
    v = v * 1664525 + 1013904223;
    v ^= 0xA5C31D2F;
    v = (v << 7) | (v >>> 25);
    v ^= 0x3C6EF372;
    v += 0x7A13C9EF;
    v ^= (v >>> 16);
    return v;
}

stock bool:Gordeev_RequirePluginOrShutdown()

{

    if (GordeevGuardLoaded() != 1)

{

        print("[GORDEEV-LOG] guard plugin not loaded -> shutdown");
        SendRconCommand("exit");
        return false;
    }

    new challenge = random(2147483647);
    new expected = Gordeev_LocalProof(challenge);
    new response = GordeevGuardProof(challenge);
    if (response != expected)

{

        new dbg[128];
        format(dbg, sizeof(dbg), "[GORDEEV-LOG] guard proof mismatch: c=%d e=%d r=%d", challenge, expected, response);
        print(dbg);
        print("[GORDEEV-LOG] guard proof mismatch -> shutdown");
        SendRconCommand("exit");
        return false;
    }

    return true;
}

stock bool:Gordeev_TryPluginSendGui(playerid, guiid, const payload[])

{

#if GORDEEV_PLUGIN_TRANSPORT
    #if defined _GORDEEV_GUARD_API_INCLUDED
        return (Gordeev_SendGuiPacket(playerid, guiid, payload) == 1);
    #else
        return false;
    #endif
#else
    #pragma unused playerid
    #pragma unused guiid
    #pragma unused payload
    return false;
#endif
}

stock bool:Gordeev_TryPluginSendTurnLight(playerid, vehicleid, turnStatus)

{

#if GORDEEV_PLUGIN_TURNLIGHTS
    #if defined _GORDEEV_GUARD_API_INCLUDED
        return (Gordeev_SendTurnLight(playerid, vehicleid, turnStatus) == 1);
    #else
        return false;
    #endif
#else
    #pragma unused playerid
    #pragma unused vehicleid
    #pragma unused turnStatus
    return false;
#endif
}

stock ShowPlayerGUI(playerid, guiid, Node:json)

{

    if(!IsPlayerConnected(playerid)) return 0;

    g_gordeev_gui_outgoing[0] = '\0';
    JSON_Stringify(json, g_gordeev_gui_outgoing, sizeof(g_gordeev_gui_outgoing));

    if(Gordeev_TryPluginSendGui(playerid, guiid, g_gordeev_gui_outgoing))

{

        return 1;
    }

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);
    BS_WriteValue(bitstream, PR_UINT16, guiid);
    BS_WriteValue(bitstream, PR_UINT32, strlen(g_gordeev_gui_outgoing));
    BS_WriteValue(bitstream, PR_STRING, g_gordeev_gui_outgoing);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
    return 1;
}

stock HidePlayerGUI(playerid, guiid)

{

    new Node:json = JSON_Object();
    JSON_SetInt(json, "c", 1);
    OnPacketIncoming(playerid, guiid, json);
    JSON_Cleanup(json);
    return 1;
}

stock OnPacketIncoming(playerid, guiid, Node:json)

{

    if(!IsPlayerConnected(playerid)) return 0;

    new close_cmd;
    if(JSON_GetInt(json, "c", close_cmd) && close_cmd == 1)

{

        new has_t;
        if(!JSON_GetInt(json, "t", has_t))

{

            JSON_SetInt(json, "t", guiid);
        }
    }

    g_gordeev_gui_outgoing[0] = '\0';
    JSON_Stringify(json, g_gordeev_gui_outgoing, sizeof(g_gordeev_gui_outgoing));

    if(Gordeev_TryPluginSendGui(playerid, guiid, g_gordeev_gui_outgoing))

{

        return 1;
    }

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);
    BS_WriteValue(bitstream, PR_UINT16, guiid);
    BS_WriteValue(bitstream, PR_UINT32, strlen(g_gordeev_gui_outgoing));
    BS_WriteValue(bitstream, PR_STRING, g_gordeev_gui_outgoing);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
    return 1;
}

stock ShowPlayerGUINew(playerid, guiid, Node:json)

{

    JSON_SetInt(json, "o", 1);
    return OnPacketIncoming(playerid, guiid, json);
}

stock IsValidSkinModel(modelid)
{
    if (modelid < 0 || modelid > 10000000) return 0;
    if (modelid == 3 || modelid == 4 || modelid == 5 || modelid == 6 || modelid == 8) return 0;
    return 1;
}

// ����������� API ����������� �� old mode usupov.
stock ShowNotificationNew(playerid, notify_type, duration, notif_id = 0, subId = 0, caption[] = "", btnCaption[] = "")

{

    if(!IsPlayerConnected(playerid)) return 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", notify_type);
    JSON_SetInt(json, "d", duration);
    JSON_SetInt(json, "s", notif_id);
    JSON_SetInt(json, "b", subId);
    JSON_SetString(json, "i", caption, strlen(caption));
    JSON_SetString(json, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUINew(playerid, BrNotification, json);
    JSON_Cleanup(json);

    // Fallback ��� �������� byreytiz UI (brnotification.inc).
    ShowNotification(playerid, notify_type, caption, duration, (notif_id == NOTIFY_RENT_MOPED) ? ("/rentbike") : ((notif_id == NOTIFY_ENGINE) ? ("/e") : ((notif_id == NOTIFY_EXCHANGE_REQUEST) ? ("/_yes_author_welsi_ex") : (""))), btnCaption);
    return 1;
}

stock Gordeev_GuiAck(playerid)

{

    new Node:response = JSON_Object();
    OnPacketIncoming(playerid, GUIRegistration, response);
    JSON_Cleanup(response);
    return 1;
}

stock Gordeev_OpenAuthGUI(playerid, bool:has_account)

{

    if(!IsPlayerConnected(playerid)) return 0;
    SetPVarInt(playerid, "gordeev_auth_gui", 1);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "r", has_account ? 1 : 0);
    ShowPlayerGUI(playerid, GUIRegistration, json);
    JSON_Cleanup(json);
    return 1;
}

stock Gordeev_CloseAuthGUI(playerid)

{

    DeletePVar(playerid, "gordeev_auth_gui");
    new Node:json = JSON_Object();
    JSON_SetInt(json, "c", 1);
    ShowPlayerGUI(playerid, GUIRegistration, json);
    JSON_Cleanup(json);
    return 1;
}


stock Accessory_GetItemIdByModel(modelid)
{
    
    switch(modelid)
    {
        case 907: return 1;
        case 908: return 2;
        case 909: return 3;
        case 910: return 8;
        case 911: return 18;
        case 912: return 4;
        case 913: return 19;
        case 914: return 9;
        case 915: return 13;
        case 916: return 5;
        case 917: return 14;
        case 918: return 7;
        case 919: return 10;
        case 920: return 20;
        case 921: return 11;
        case 922: return 15;
        case 923: return 12;
        case 924: return 16;
        case 925: return 17;
        case 926: return 6;
        case 939: return 25;
        case 944: return 24;
        case 945: return 26;
        case 946: return 27;
        case 967: return 35;
        case 968: return 36;
        case 969: return 37;
        case 970: return 48;
        case 971: return 49;
        case 972: return 50;
        case 973: return 51;
        case 974: return 52;
        case 975: return 53;
        case 976: return 54;
        case 977: return 55;
        case 978: return 56;
        case 979: return 38;
        case 980: return 39;
        case 981: return 40;
        case 982: return 41;
        case 983: return 57;
        case 984: return 42;
        case 985: return 30;
        case 986: return 31;
        case 987: return 43;
        case 988: return 44;
        case 989: return 45;
        case 990: return 32;
        case 992: return 46;
        case 993: return 47;
        case 994: return 33;
        case 995: return 34;
        case 997: return 58;
        case 1194: return 60;
        case 1195: return 61;
        case 1196: return 62;
        case 1197: return 63;
        case 1198: return 64;
        case 1199: return 65;
        case 1210: return 346;
        case 1212: return 162;
        case 1230: return 704;
        case 1231: return 703;
        case 1328: return 724;
        case 1329: return 725;
        case 1330: return 726;
        case 1377: return 586;
        case 1378: return 587;
        case 1379: return 588;
        case 1380: return 589;
        case 1381: return 590;
        case 1382: return 591;
        case 1383: return 592;
        case 1384: return 593;
        case 1385: return 594;
        case 1386: return 595;
        case 1387: return 596;
        case 1388: return 597;
        case 1389: return 598;
        case 1390: return 599;
        case 1650: return 21;
        case 1651: return 891;
        case 1652: return 890;
        case 1653: return 892;
        case 1654: return 80;
        case 1699: return 68;
        case 1701: return 69;
        case 1702: return 70;
        case 1703: return 71;
        case 1704: return 72;
        case 1705: return 73;
        case 1706: return 74;
        case 1707: return 75;
        case 1708: return 76;
        case 1709: return 77;
        case 1710: return 78;
        case 1711: return 79;
        case 1716: return 67;
        case 1720: return 84;
        case 1721: return 85;
        case 1722: return 86;
        case 1723: return 87;
        case 1724: return 88;
        case 1725: return 89;
        case 1726: return 90;
        case 1727: return 96;
        case 1728: return 97;
        case 1729: return 98;
        case 1730: return 99;
        case 1731: return 100;
        case 1732: return 101;
        case 1733: return 106;
        case 1734: return 107;
        case 1735: return 108;
        case 1736: return 109;
        case 1737: return 110;
        case 1743: return 102;
        case 1744: return 103;
        case 1745: return 104;
        case 1746: return 105;
        case 1747: return 91;
        case 1748: return 92;
        case 1749: return 93;
        case 1750: return 94;
        case 1751: return 95;
        case 1754: return 59;
        case 1755: return 81;
        case 1756: return 82;
        case 1757: return 83;
        case 1776: return 115;
        case 1777: return 114;
        case 1778: return 113;
        case 1779: return 112;
        case 1783: return 111;
        case 1789: return 119;
        case 1790: return 118;
        case 1791: return 120;
        case 1795: return 117;
        case 1975: return 921;
        case 1978: return 749;
        case 1979: return 745;
        case 1980: return 742;
        case 1981: return 750;
        case 1982: return 737;
        case 1983: return 752;
        case 1984: return 732;
        case 1985: return 747;
        case 1986: return 735;
        case 1987: return 739;
        case 1988: return 757;
        case 1989: return 759;
        case 1990: return 746;
        case 1991: return 730;
        case 1992: return 733;
        case 1993: return 751;
        case 1995: return 743;
        case 1996: return 744;
        case 1997: return 729;
        case 1998: return 738;
        case 1999: return 741;
        case 2001: return 731;
        case 2002: return 753;
        case 2003: return 740;
        case 2004: return 758;
        case 2005: return 734;
        case 2006: return 736;
        case 2007: return 748;
        case 2008: return 754;
        case 2646: return 66;
        case 2649: return 780;
        case 2655: return 914;
        case 2656: return 915;
        case 2657: return 916;
        case 3153: return 728;
        case 3154: return 727;
        case 4084: return 632;
        case 4085: return 631;
        case 4086: return 635;
        case 4087: return 633;
        case 4088: return 636;
        case 4089: return 634;
        case 4090: return 638;
        case 4091: return 640;
        case 4092: return 639;
        case 4093: return 641;
        case 4094: return 637;
        case 4096: return 621;
        case 4097: return 619;
        case 4098: return 618;
        case 4099: return 627;
        case 4100: return 623;
        case 4101: return 624;
        case 4102: return 620;
        case 4103: return 613;
        case 4104: return 628;
        case 4105: return 615;
        case 4106: return 629;
        case 4107: return 625;
        case 4108: return 626;
        case 4109: return 616;
        case 4110: return 617;
        case 4111: return 630;
        case 4112: return 614;
        case 4113: return 645;
        case 4114: return 644;
        case 4115: return 646;
        case 4116: return 643;
        case 4117: return 642;
        case 4119: return 622;
        case 4158: return 529;
        case 4159: return 530;
        case 4160: return 531;
        case 4161: return 532;
        case 4162: return 533;
        case 4163: return 534;
        case 4164: return 535;
        case 4165: return 536;
        case 4166: return 537;
        case 4196: return 490;
        case 4197: return 491;
        case 4198: return 492;
        case 4199: return 493;
        case 4200: return 494;
        case 4201: return 495;
        case 4202: return 496;
        case 4203: return 497;
        case 4204: return 498;
        case 4205: return 499;
        case 4206: return 500;
        case 4207: return 501;
        case 4208: return 502;
        case 4231: return 477;
        case 4232: return 485;
        case 4233: return 488;
        case 4234: return 487;
        case 4235: return 489;
        case 4236: return 486;
        case 4237: return 484;
        case 4238: return 483;
        case 4239: return 482;
        case 4240: return 481;
        case 4241: return 480;
        case 4242: return 478;
        case 4243: return 479;
        case 4359: return 705;
        case 4360: return 706;
        case 4361: return 707;
        case 4372: return 927;
        case 4542: return 928;
        case 4543: return 929;
        case 4544: return 933;
        case 4545: return 935;
        case 4546: return 938;
        case 4547: return 940;
        case 4548: return 934;
        case 4549: return 941;
        case 4550: return 926;
        case 4699: return 953;
        case 4700: return 954;
        case 4701: return 957;
        case 4702: return 946;
        case 4859: return 919;
        case 4860: return 925;
        case 4861: return 922;
        case 4862: return 920;
        case 4863: return 923;
        case 4864: return 924;
        case 5270: return 797;
        case 5271: return 802;
        case 5272: return 798;
        case 5273: return 788;
        case 5274: return 796;
        case 5275: return 764;
        case 5278: return 800;
        case 5280: return 781;
        case 5281: return 787;
        case 5283: return 761;
        case 5284: return 765;
        case 5285: return 774;
        case 5286: return 762;
        case 5287: return 766;
        case 5288: return 801;
        case 5289: return 769;
        case 5291: return 767;
        case 5292: return 799;
        case 5371: return 463;
        case 5372: return 464;
        case 5373: return 465;
        case 5374: return 466;
        case 5375: return 467;
        case 5376: return 468;
        case 5377: return 469;
        case 5378: return 470;
        case 5379: return 471;
        case 5380: return 472;
        case 5381: return 473;
        case 5382: return 474;
        case 5383: return 475;
        case 5384: return 476;
        case 5431: return 462;
        case 5822: return 778;
        case 5826: return 771;
        case 5828: return 772;
        case 5830: return 791;
        case 6101: return 887;
        case 6102: return 888;
        case 6103: return 889;
        case 6169: return 668;
        case 6170: return 669;
        case 6171: return 670;
        case 6172: return 671;
        case 6173: return 672;
        case 6174: return 673;
        case 6175: return 674;
        case 6176: return 675;
        case 6177: return 676;
        case 6178: return 677;
        case 6179: return 678;
        case 6180: return 679;
        case 6181: return 680;
        case 662: return 686;
        case 663: return 687;
        case 676: return 917;
        case 677: return 918;
        case 7327: return 391;
        case 7328: return 392;
        case 7329: return 393;
        case 7330: return 394;
        case 7331: return 395;
        case 7332: return 396;
        case 7333: return 397;
        case 7334: return 398;
        case 7335: return 399;
        case 7336: return 400;
        case 7337: return 401;
        case 7338: return 402;
        case 7339: return 403;
        case 7340: return 404;
        case 7341: return 405;
        case 7342: return 406;
        case 7343: return 407;
        case 7344: return 408;
        case 7345: return 409;
        case 7346: return 410;
        case 7347: return 411;
        case 7348: return 412;
        case 7349: return 413;
        case 7350: return 414;
        case 7351: return 415;
        case 7352: return 416;
        case 7353: return 417;
        case 7354: return 418;
        case 7355: return 419;
        case 7356: return 420;
        case 7357: return 421;
        case 7358: return 422;
        case 7359: return 423;
        case 7360: return 424;
        case 7361: return 425;
        case 7362: return 426;
        case 7363: return 427;
        case 7364: return 428;
        case 7365: return 429;
        case 7366: return 430;
        case 7367: return 431;
        case 7368: return 432;
        case 7369: return 433;
        case 7370: return 434;
        case 7371: return 435;
        case 7372: return 436;
        case 7373: return 437;
        case 7374: return 438;
        case 7375: return 439;
        case 7376: return 440;
        case 7377: return 441;
        case 7378: return 442;
        case 7379: return 443;
        case 7380: return 444;
        case 7381: return 445;
        case 7382: return 446;
        case 7383: return 447;
        case 7384: return 448;
        case 7385: return 449;
        case 7386: return 450;
        case 7387: return 451;
        case 7388: return 452;
        case 7389: return 453;
        case 7390: return 454;
        case 7391: return 455;
        case 7392: return 456;
        case 7393: return 457;
        case 7394: return 458;
        case 7395: return 459;
        case 7396: return 460;
        case 7397: return 461;
        case 7712: return 932;
        case 7727: return 936;
        case 7729: return 937;
        case 780: return 702;
        case 781: return 701;
        case 786: return 681;
        case 787: return 682;
        case 788: return 683;
        case 789: return 684;
        case 790: return 685;
        case 791: return 912;
        case 792: return 913;
        case 9376: return 647;
        case 9377: return 648;
        case 9378: return 649;
        case 9379: return 650;
        case 9380: return 651;
        case 9381: return 652;
        case 9382: return 653;
        case 9383: return 654;
        case 9384: return 655;
        case 9385: return 656;
        case 9386: return 657;
        case 9387: return 658;
        case 9388: return 659;
        case 9406: return 688;
        case 9407: return 689;
        case 9408: return 690;
        case 9409: return 691;
        case 9410: return 692;
        case 9794: return 600;
        case 9795: return 601;
        case 9796: return 602;
        case 9797: return 603;
        case 9798: return 604;
        case 9799: return 605;
        case 9800: return 606;
        case 9801: return 607;
        case 9802: return 608;
        case 9803: return 609;
        case 9804: return 610;
        case 9805: return 611;
        case 9806: return 612;
        case 9824: return 660;
        case 9825: return 661;
        case 9826: return 662;
        case 9827: return 663;
        case 9828: return 664;
        case 9960: return 760;
        case 9964: return 793;
        case 9966: return 763;
        case 9969: return 790;
        case 9972: return 770;
        case 9973: return 804;
        case 9974: return 794;
        case 9975: return 776;
        case 9980: return 803;
        case 9984: return 777;
        case 9990: return 775;
        case 9992: return 789;
        case 9993: return 784;
        case 9994: return 782;
        case 9997: return 795;
        case 9998: return 783;
        case 9999: return 773;
        case 10000: return 792;
        case 10001: return 768;
        case 10002: return 785;
        case 100001: return 116;
        case 100006: return 1009;
        case 100007: return 1010;
        case 100034: return 1022;
        case 100035: return 1021;
        case 100065: return 1023;
        case 100066: return 1024;
        case 100067: return 1025;
        case 100068: return 1026;
        case 100069: return 1027;
        case 100070: return 1028;
        case 100071: return 1029;
        case 100072: return 1030;
        case 100073: return 1031;
        case 100074: return 1032;
        case 100075: return 1033;
        case 100076: return 1034;
        case 100077: return 1043;
        case 100078: return 1044;
        case 100079: return 1045;
        case 100101: return 1046;
        case 100102: return 1047;
        case 100103: return 1048;
        case 100104: return 1049;
        case 100105: return 1050;
        case 100106: return 1051;
        case 100107: return 1052;
        case 100108: return 1053;
        case 100109: return 1054;
        case 100110: return 1055;
        case 100111: return 1056;
        case 100112: return 1057;
        case 100113: return 1058;
        case 100162: return 1062;
        case 100163: return 1063;
        case 100164: return 1064;
        case 100165: return 1065;
        case 100166: return 1066;
        case 100167: return 1067;
        case 100169: return 1073;
        case 100170: return 1068;
        case 100171: return 1069;
        case 100189: return 1075;
        case 10488: return 943;
        case 10492: return 939;
        case 10493: return 930;
        case 10494: return 931;
        case 10836: return 122;
        case 10916: return 964;
        case 10952: return 121;
        case 11292: return 958;
        case 11304: return 965;
        case 11328: return 962;
        case 11919: return 579;
        case 11920: return 580;
        case 11921: return 581;
        case 11922: return 582;
        case 11923: return 583;
        case 11924: return 584;
        case 11925: return 585;
        case 12222: return 125;
        case 12223: return 126;
        case 12224: return 127;
        case 12225: return 129;
        case 12226: return 128;
        case 12227: return 131;
        case 12228: return 132;
        case 12229: return 123;
        case 12231: return 130;
        case 12233: return 124;
        case 12301: return 910;
        case 12302: return 905;
        case 12303: return 909;
        case 12304: return 907;
        case 12306: return 908;
        case 12307: return 911;
        case 12308: return 906;
        case 12635: return 133;
        case 13266: return 561;
        case 13628: return 345;
        case 13735: return 550;
        case 13736: return 551;
        case 13737: return 552;
        case 13738: return 553;
        case 13739: return 554;
        case 13740: return 555;
        case 13741: return 556;
        case 13742: return 557;
        case 13743: return 558;
        case 13744: return 559;
        case 13745: return 560;
        case 13746: return 540;
        case 13747: return 541;
        case 13748: return 542;
        case 13749: return 543;
        case 13750: return 544;
        case 13751: return 545;
        case 13752: return 546;
        case 13753: return 547;
        case 13754: return 548;
        case 13755: return 549;
        case 13761: return 538;
        case 13762: return 539;
        case 13801: return 576;
        case 13802: return 577;
        case 13803: return 578;
        case 13804: return 563;
        case 13805: return 564;
        case 13806: return 565;
        case 13807: return 566;
        case 13808: return 567;
        case 13809: return 568;
        case 13810: return 569;
        case 13811: return 570;
        case 13812: return 571;
        case 13813: return 572;
        case 13814: return 573;
        case 13815: return 574;
        case 13816: return 575;
        case 13879: return 504;
        case 13880: return 505;
        case 13881: return 506;
        case 13882: return 507;
        case 13883: return 508;
        case 13884: return 510;
        case 13885: return 512;
        case 13897: return 562;
        case 13908: return 503;
        case 14265: return 961;
        case 14266: return 960;
        case 14574: return 509;
        case 14575: return 511;
        case 14589: return 513;
        case 14590: return 514;
        case 14591: return 515;
        case 14592: return 516;
        case 14593: return 517;
        case 14594: return 518;
        case 14595: return 519;
        case 14596: return 520;
        case 14597: return 521;
        case 14598: return 522;
        case 14599: return 523;
        case 14600: return 524;
        case 14601: return 525;
        case 14602: return 526;
        case 14603: return 527;
        case 14604: return 528;
        case 14630: return 955;
        case 14641: return 942;
        case 14642: return 956;
        case 14643: return 945;
        case 14644: return 951;
        case 14645: return 947;
        case 14646: return 952;
        case 14647: return 944;
        case 14648: return 950;
        case 14671: return 723;
        case 14672: return 722;
        case 14790: return 948;
        case 14791: return 949;
        case 15055: return 966;
        case 15056: return 959;
        case 15057: return 963;
        case 15058: return 967;
        case 15134: return 135;
        case 15135: return 136;
        case 15136: return 137;
        case 15137: return 138;
        case 15138: return 139;
        case 15139: return 140;
        case 15140: return 141;
        case 15141: return 142;
        case 15142: return 143;
        case 15143: return 144;
        case 15144: return 145;
        case 15145: return 146;
        case 15146: return 147;
        case 15147: return 148;
        case 15148: return 149;
        case 15149: return 150;
        case 15150: return 155;
        case 15151: return 159;
        case 15152: return 151;
        case 15153: return 152;
        case 15154: return 153;
        case 15155: return 154;
        case 15157: return 160;
        case 15158: return 161;
        case 15159: return 158;
        case 15160: return 156;
        case 15161: return 157;
        case 15446: return 693;
        case 15447: return 694;
        case 15448: return 695;
        case 15449: return 696;
        case 15626: return 976;
        case 15627: return 977;
        case 15628: return 981;
        case 15629: return 982;
        case 15630: return 971;
        case 15631: return 972;
        case 15632: return 973;
        case 15633: return 974;
        case 15634: return 975;
        case 15635: return 978;
        case 15636: return 979;
        case 15638: return 980;
        case 16026: return 877;
        case 16027: return 878;
        case 16028: return 879;
        case 16029: return 880;
        case 16030: return 881;
        case 16031: return 882;
        case 16032: return 883;
        case 16033: return 884;
        case 16034: return 885;
        case 16035: return 886;
        case 16045: return 708;
        case 16055: return 709;
        case 16699: return 970;
        case 17509: return 969;
        case 17510: return 968;
        case 17983: return 328;
        case 17984: return 329;
        case 17985: return 330;
        case 17986: return 331;
        case 17987: return 332;
        case 17988: return 333;
        case 17989: return 334;
        case 17990: return 335;
        case 17991: return 336;
        case 17992: return 337;
        case 17993: return 338;
        case 17994: return 339;
        case 17995: return 340;
        case 17996: return 341;
        case 17997: return 342;
        case 17998: return 343;
        case 17999: return 344;
        case 18226: return 163;
        case 18227: return 164;
        case 18228: return 165;
        case 18229: return 166;
        case 18230: return 167;
        case 18231: return 168;
        case 18232: return 169;
        case 18233: return 170;
        case 18234: return 171;
        case 18235: return 172;
        case 18236: return 173;
        case 18237: return 174;
        case 18238: return 175;
        case 18239: return 176;
        case 18240: return 177;
        case 18241: return 178;
        case 18242: return 179;
        case 18243: return 180;
        case 18244: return 181;
        case 18245: return 182;
        case 18246: return 183;
        case 18247: return 184;
        case 18248: return 185;
        case 18249: return 186;
        case 18250: return 187;
        case 18251: return 188;
        case 18252: return 189;
        case 18253: return 190;
        case 18254: return 191;
        case 18255: return 192;
        case 18256: return 193;
        case 18257: return 194;
        case 18258: return 195;
        case 18259: return 196;
        case 18260: return 197;
        case 18261: return 198;
        case 18262: return 199;
        case 18263: return 200;
        case 18264: return 201;
        case 18265: return 202;
        case 18266: return 203;
        case 18267: return 204;
        case 18268: return 205;
        case 18269: return 206;
        case 18270: return 207;
        case 18271: return 208;
        case 18272: return 209;
        case 18273: return 210;
        case 18274: return 211;
        case 18275: return 212;
        case 18276: return 213;
        case 18277: return 214;
        case 18278: return 215;
        case 18279: return 216;
        case 18282: return 217;
        case 18283: return 218;
        case 18284: return 219;
        case 18285: return 220;
        case 18286: return 221;
        case 18287: return 222;
        case 18288: return 223;
        case 18289: return 224;
        case 18290: return 225;
        case 18291: return 226;
        case 18292: return 227;
        case 18293: return 228;
        case 18294: return 229;
        case 18295: return 230;
        case 18296: return 231;
        case 18298: return 232;
        case 18300: return 233;
        case 18301: return 234;
        case 18302: return 235;
        case 18306: return 236;
        case 18307: return 237;
        case 18310: return 238;
        case 18312: return 239;
        case 18313: return 240;
        case 18315: return 242;
        case 18318: return 241;
        case 18319: return 243;
        case 18322: return 244;
        case 18328: return 245;
        case 18329: return 246;
        case 18330: return 247;
        case 18331: return 248;
        case 18332: return 249;
        case 18333: return 250;
        case 18334: return 251;
        case 18335: return 252;
        case 18336: return 253;
        case 18337: return 254;
        case 18338: return 255;
        case 18339: return 256;
        case 18340: return 257;
        case 18341: return 258;
        case 18342: return 259;
        case 18343: return 260;
        case 18344: return 261;
        case 18345: return 262;
        case 18346: return 263;
        case 18347: return 264;
        case 18348: return 265;
        case 18349: return 266;
        case 18350: return 267;
        case 18351: return 268;
        case 18352: return 269;
        case 18353: return 270;
        case 18354: return 271;
        case 18355: return 272;
        case 18356: return 273;
        case 18357: return 274;
        case 18358: return 275;
        case 18364: return 277;
        case 18365: return 278;
        case 18366: return 276;
        case 18367: return 279;
        case 18368: return 280;
        case 18369: return 281;
        case 18370: return 282;
        case 18371: return 283;
        case 18372: return 284;
        case 18373: return 285;
        case 18374: return 286;
        case 18375: return 287;
        case 18376: return 288;
        case 18377: return 289;
        case 18378: return 290;
        case 18379: return 291;
        case 18380: return 292;
        case 18381: return 293;
        case 18382: return 294;
        case 18383: return 295;
        case 18384: return 296;
        case 18385: return 297;
        case 18386: return 298;
        case 18387: return 299;
        case 18388: return 300;
        case 18389: return 301;
        case 18390: return 302;
        case 18391: return 303;
        case 18392: return 304;
        case 18393: return 305;
        case 18394: return 306;
        case 18395: return 307;
        case 18396: return 308;
        case 18397: return 309;
        case 18398: return 310;
        case 18399: return 311;
        case 18400: return 312;
        case 18401: return 313;
        case 18402: return 314;
        case 18403: return 315;
        case 18404: return 316;
        case 18405: return 317;
        case 18406: return 318;
        case 18407: return 319;
        case 18408: return 320;
        case 18409: return 321;
        case 18410: return 322;
        case 18411: return 323;
        case 18412: return 324;
        case 18413: return 325;
        case 18414: return 326;
        case 18415: return 327;
        case 18497: return 347;
        case 18498: return 348;
        case 18499: return 349;
        case 18500: return 350;
        case 18501: return 351;
        case 18502: return 352;
        case 18503: return 353;
        case 18504: return 354;
        case 18505: return 355;
        case 18506: return 356;
        case 18507: return 357;
        case 18508: return 358;
        case 18509: return 359;
        case 18510: return 360;
        case 18511: return 361;
        case 18512: return 362;
        case 18513: return 363;
        case 18514: return 364;
        case 18515: return 365;
        case 18516: return 366;
        case 18517: return 367;
        case 18518: return 368;
        case 18519: return 369;
        case 18520: return 370;
        case 18521: return 371;
        case 18522: return 372;
        case 18523: return 373;
        case 18524: return 374;
        case 18525: return 375;
        case 18526: return 376;
        case 18527: return 377;
        case 18528: return 378;
        case 18529: return 379;
        case 18530: return 380;
        case 18567: return 381;
        case 18568: return 382;
        case 18569: return 383;
        case 18570: return 384;
        case 18571: return 385;
        case 18572: return 386;
        case 18573: return 387;
        case 18574: return 388;
        case 18575: return 389;
        case 18576: return 390;
        case 19211: return 665;
        case 19212: return 666;
        case 19213: return 667;
        case 19632: return 29;
        case 19882: return 28;
        case 31949: return 983;
        case 31961: return 991;
        case 31962: return 985;
        case 31963: return 984;
        case 31964: return 992;
        case 31965: return 990;
        case 31966: return 989;
        case 31967: return 986;
        case 31969: return 988;
        case 31970: return 987;
        case 32129: return 999;
        case 32130: return 1001;
        case 32131: return 994;
        case 32132: return 995;
        case 32133: return 996;
        case 32134: return 997;
        case 32135: return 998;
        case 32136: return 1000;
        case 32137: return 1002;
        case 32138: return 1003;
        case 32139: return 1004;
        case 32144: return 1005;
        case 32154: return 993;
        case 32171: return 1008;
        case 32404: return 1007;
        case 32405: return 756;
        case 32414: return 1013;
        case 32415: return 1014;
        case 32416: return 1015;
        case 32417: return 1016;
        case 32418: return 1017;
        case 32419: return 1018;
        case 32420: return 1019;
        case 32421: return 1020;
        case 32423: return 755;
    }

    printf("[ACCESSORY] No item ID found for model: %d", modelid);
    return -1;
}

stock Accessory_GetModelIdByItemId(itemId)
{
    
    switch(itemId)
    {
        // Рюкзаки и сумки (itemId -> modelid)
        case 1: return 907;      // Рюкзак LV
        case 2: return 908;      // Рюкзак Puma(фиолетовый)
        case 3: return 909;      // Рюкзак Nike(желтый)
        case 4: return 912;      // Поясная сумка Gucci
        case 5: return 916;      // Спортивная сумка Supreme(красная)
        case 6: return 926;      // Рюкзак Gucci(разноцветный)
        case 7: return 918;      // Сумка Gucci(с павлином)
        case 8: return 910;      // Кепка Gucci(красная)
        case 9: return 914;      // Кепка Россия(белая)
        case 10: return 919;     // Кепка Спартак(белая)
        case 11: return 921;     // Кепка BlackRussia(черная)
        case 12: return 923;     // Кепка ЦСКА(черная)
        case 13: return 915;     // Авиаторы с фиолетовыми линзам
        case 14: return 917;     // Маленькие авиаторы с фиолет
        case 15: return 922;     // Черные очки с черными линзами
        case 16: return 924;     // Маленькие авиаторы с черными 
        case 17: return 925;     // Черные очки с прозрачными линзами
        case 18: return 911;     // Поясная сумка 'Nike'
        case 19: return 913;     // Поясная сумка 'TheNorthFace'
        case 20: return 920;     // Поясная сумка 'LV'
        case 30: return 985;     // Apple Watch 5 series (черные)
        case 31: return 986;     // Apple Watch 5 series (белые)
        case 32: return 990;     // Часы 'Silver Casio'
        case 33: return 994;     // Часы 'Black Casio'
        case 34: return 995;     // Часы 'Gold Casio'
        case 35: return 967;     // Акустическая гитара
        case 36: return 968;     // Black Electro
        case 37: return 969;     // High Rock
        case 38: return 979;     // Tony Hawk
        case 39: return 980;     // HooPla
        case 40: return 981;     // Доска - скейтборд
        case 41: return 982;     // Rise
        case 42: return 984;     // Женская сумка (черная)
        case 43: return 987;     // Женская сумка (оранжевая)
        case 44: return 988;     // Женская сумка (красная)
        case 45: return 989;     // Женская сумка (голубая)
        case 46: return 992;     // Женская сумка (зеленая)
        case 47: return 993;     // Женская сумка (фиолетовая)
        case 48: return 970;     // Black Cute
        case 49: return 971;     // White Cute
        case 50: return 972;     // Anti Social Club
        case 51: return 973;     // Purple Smile
        case 52: return 974;     // Red Smile
        case 53: return 975;     // Black Smile
        case 54: return 976;     // Белая маска
        case 55: return 977;     // Черная маска
        case 56: return 978;     // BlackRussia маска (черная)
        case 57: return 983;     // BlackRussia маска (белая)
        case 60: return 1194;    // Фиолетовая призрачная кепка
        case 61: return 1195;    // Красная призрачная кепка
        case 62: return 1196;    // Голубая призрачная кепка
        case 63: return 1197;    // Рюкзак 'Scared Smile' (Голубой)
        case 64: return 1198;    // Рюкзак 'Scared Smile' (Фиолетовый)
        case 65: return 1199;    // Рюкзак 'Scared Smile' (Красный)
        case 66: return 2646;    // Лекарство
        case 67: return 1716;    // Конфеты
        case 68: return 1699;    // Хоккейная маска 1
        case 69: return 1701;    // Хоккейная маска 2
        case 70: return 1702;    // Зеленая маска зомби
        case 71: return 1703;    // Красная маска Дьявола
        case 72: return 1704;    // Оранжевая маска Дьявола
        case 73: return 1705;    // Черная маска Дьявола
        case 74: return 1706;    // Темная маска тыквы
        case 75: return 1707;    // Зеленая маска тыквы
        case 76: return 1708;    // Оранжевая маска тыквы
        case 77: return 1709;    // Маска зомби 1
        case 78: return 1710;    // Маска зомби 2
        case 79: return 1711;    // Маска зомби 3
        case 84: return 1720;    // Новогодняя шапка 1
        case 85: return 1721;    // Новогодняя шапка 2
        case 86: return 1722;    // Новогодняя шапка 3
        case 87: return 1723;    // Новогодняя шапка 4
        case 88: return 1724;    // Новогодняя шапка 5
        case 89: return 1725;    // Новогодняя шапка 6
        case 90: return 1726;    // Новогодняя шапка 7
        case 91: return 1747;    // Шапка 'Hello Kitty' 1
        case 92: return 1748;    // Шапка 'Hello Kitty' 2
        case 93: return 1749;    // Шапка 'Hello Kitty' 3
        case 94: return 1750;    // Шапка 'Hello Kitty' 4
        case 95: return 1751;    // Шапка 'Hello Kitty' 5
        case 96: return 1727;    // Новогодний шарф 1
        case 97: return 1728;    // Новогодний шарф 2
        case 98: return 1729;    // Новогодний шарф 3
        case 99: return 1730;    // Новогодний шарф 4
        case 100: return 1731;   // Новогодний шарф 5
        case 101: return 1732;   // Новогодний шарф 6
        case 102: return 1743;   // Зимняя шапка 1
        case 103: return 1744;   // Зимняя шапка 2
        case 104: return 1745;   // Зимняя шапка 3
        case 105: return 1746;   // Зимняя шапка 4
        case 106: return 1733;   // Зимняя шапка 5
        case 107: return 1734;   // Зимняя шапка 6
        case 108: return 1735;   // Зимняя шапка 7
        case 109: return 1736;   // Зимняя шапка 8
        case 110: return 1737;   // Зимняя шапка 9
        case 111: return 1783;   // Маска снеговика
        case 112: return 1779;   // Новогодняя маска 1
        case 113: return 1778;   // Новогодняя маска 2
        case 114: return 1777;   // Новогодняя маска 3
        case 115: return 1776;   // Новогодняя маска 4
        case 135: return 15134;  // Рюкзак инопланетянина
        case 136: return 15135;  // Шапка ведьмы
        case 137: return 15136;  // Шапка ведьмы
        case 138: return 15137;  // Шапка ведьмы
        case 139: return 15138;  // Шапка с брелком-привидением
        case 140: return 15139;  // Шапка с брелком-пауком
        case 141: return 15140;  // Шляпа коричневая
        case 142: return 15141;  // Распределяющая шляпа из Гарри
        case 143: return 15142;  // Коса 1
        case 144: return 15143;  // Коса 2
        case 145: return 15144;  // Маска светящаяся красная
        case 146: return 15145;  // Маска Джейсона(хоккейная)
        case 147: return 15146;  // Белая маска (плачущая)
        case 148: return 15147;  // Маска Билли
        case 149: return 15148;  // Маска Дали
        case 150: return 15149;  // Метла
        case 151: return 15152;  // Маска светящаяся голубая
        case 152: return 15153;  // Маска светящаяся фиолетовая
        case 153: return 15154;  // Маска светящаяся зеленая
        case 154: return 15155;  // Маска светящаяся оранжевая
        case 155: return 15150;  // Рюкзак 'FNAF'
        case 156: return 15160;  // Маска Круга
        case 157: return 15161;  // Маска Треугольника
        case 158: return 15159;  // Маска Квадрата
        case 159: return 15151;  // Маска Ведущего
        case 160: return 15157;  // Рюкзак Скуби
        case 161: return 15158;  // Кепка Скуби
        case 162: return 1212;   // Деньги
        case 163: return 18226;  // Серая шапка 'Adidas'
        case 164: return 18227;  // Красная шапка 'Adidas'
        case 165: return 18228;  // Черная шапка 'Adidas'
        case 166: return 18229;  // Красная шапка 'Nike'
        case 167: return 18230;  // Черная шапка 'Nike'
        case 168: return 18231;  // Серая шапка 'Nike'
        case 169: return 18232;  // Берет 'Gucci'
        case 170: return 18233;  // Деревянный посох
        case 171: return 18234;  // Зеленая шапка с помпоном
        case 172: return 18235;  // Оранжевая шапка с помпоном
        case 173: return 18236;  // Черная шапка 'Calvin Klein'
        case 174: return 18237;  // Синяя шапка 'Calvin Klein'
        case 175: return 18238;  // Красная шапка 'Calvin Klein'
        case 176: return 18239;  // Оранжевая шапка 'Calvin Klein'
        case 177: return 18240;  // Серая шапка 'Calvin Klein'
        case 178: return 18241;  // Фиолетовая шапка 'Calvin Klein'
        case 179: return 18242;  // Зеленая шапка 'Calvin Klein'
        case 180: return 18243;  // Карамельная конфета
        case 181: return 18244;  // Черная зимняя кепка
        case 182: return 18245;  // Камуфляжная зимняя кепка
        case 183: return 18246;  // Красная зимняя кепка
        case 184: return 18247;  // Зеленая зимняя кепка
        case 185: return 18248;  // Синяя зимняя кепка
        case 186: return 18249;  // Коричневая зимняя кепка
        case 187: return 18250;  // Белая панама с сигарой
        case 188: return 18251;  // Красный зимний рюкзак с узором
        case 189: return 18252;  // Красный зимний рюкзак олень
        case 190: return 18253;  // Синий зимний рюкзак с узором
        case 191: return 18254;  // Синий зимний рюкзак олень
        case 192: return 18255;  // Зеленый зимний рюкзак с узором
        case 193: return 18256;  // Зеленый зимний рюкзак-олень
        case 194: return 18257;  // Красная шапка 'Puma'
        case 195: return 18258;  // Черная шапка 'Puma'
        case 196: return 18259;  // Желтая шапка 'Puma'
        case 197: return 18260;  // Белая шапка 'Puma'
        case 198: return 18261;  // Зеленая шапка 'Puma'
        case 199: return 18262;  // Синяя шапка 'Puma'
        case 200: return 18263;  // Белая панама 'Gucci'
        case 201: return 18264;  // Черная панама 'Gucci'
        case 202: return 18265;  // Черная панама 'Adidas'
        case 203: return 18266;  // Синяя панама 'Adidas'
        case 204: return 18267;  // Красная панама 'Adidas'
        case 205: return 18268;  // Низкая шапка желтая
        case 206: return 18269;  // Низкая шапка синяя
        case 207: return 18270;  // Низкая шапка зеленая
        case 208: return 18271;  // Низкая шапка красная
        case 209: return 18272;  // Низкая шапка серая
        case 210: return 18273;  // Высокая панама 'Gucci'
        case 211: return 18274;  // Черная панама 'Nike'
        case 212: return 18275;  // Белая панама 'Nike'
        case 213: return 18276;  // Красная панама 'Nike'
        case 214: return 18277;  // Синяя панама 'Nike'
        case 215: return 18278;  // Зеленая панама 'Nike'
        case 216: return 18279;  // Черная шапка 'LV'
        case 217: return 18282;  // Белая шапка 'LV'
        case 218: return 18283;  // Красная шапка 'LV'
        case 219: return 18284;  // Синяя шапка 'LV'
        case 220: return 18285;  // Новогодний посох-зонт
        case 221: return 18286;  // Кандибобер красный
        case 222: return 18287;  // Кандибобер синий
        case 223: return 18288;  // Кандибобер желтый
        case 224: return 18289;  // Кандибобер серый
        case 225: return 18290;  // Кандибобер розовый
        case 226: return 18291;  // Серая панама
        case 227: return 18292;  // Красные наушники на голову
        case 228: return 18293;  // Фиолетовые наушники на голову
        case 229: return 18294;  // Светло фиолетовые наушники на голову
        case 230: return 18295;  // Желтые наушники на голову
        case 231: return 18296;  // Красные наушники на голову
        case 232: return 18298;  // Серые наушники-пингвин
        case 233: return 18300;  // Серые наушники-пингвин
        case 234: return 18301;  // Фиолетовые наушники-пингвин
        case 235: return 18302;  // Фиолетовые наушники-пингвин
        case 236: return 18306;  // Синие наушники-пингвин
        case 237: return 18307;  // Красные наушники-пингвин
        case 238: return 18310;  // Зеленые наушники-пингвин
        case 239: return 18312;  // Желтые наушники-пингвин
        case 240: return 18313;  // Кремовые наушники-пингвин
        case 241: return 18318;  // Красные наушники
        case 242: return 18315;  // Синие наушники-пингвин
        case 243: return 18319;  // Зеленые наушники-пингвин
        case 244: return 18322;  // Желтые наушники
        case 245: return 18328;  // Красные наушники с ушками
        case 246: return 18329;  // Фиолетовые наушники с ушками
        case 247: return 18330;  // Сиреневые наушники с ушками
        case 248: return 18331;  // Оранжевые наушники с ушками
        case 249: return 18332;  // Синие наушники с ушками
        case 250: return 18333;  // Красная зимняя кепка
        case 251: return 18334;  // Зелено-синяя зимняя кепка
        case 252: return 18335;  // Светлая зимняя кепка
        case 253: return 18336;  // Сине-зелено-красная зимняя кепка
        case 254: return 18337;  // Красно-зеленая зимняя кепка
        case 255: return 18338;  // Коричневый шарф
        case 256: return 18339;  // Синий шарф
        case 257: return 18340;  // Зеленый шарф
        case 258: return 18341;  // Черный шарф
        case 259: return 18342;  // Коричневый шарф
        case 260: return 18343;  // Белый шарф
        case 261: return 18344;  // Черный шарф
        case 262: return 18345;  // Шарф Gucci
        case 263: return 18346;  // Синий посох со льдом
        case 264: return 18347;  // Синий посох со снежинкой
        case 265: return 18348;  // Голубой посох со льдом
        case 266: return 18349;  // Коричневая шапка 'TNF'
        case 267: return 18350;  // Черная шапка 'TNF'
        case 268: return 18351;  // Белая шапка 'TNF'
        case 269: return 18352;  // Синяя шапка 'TNF'
        case 270: return 18353;  // Зеленая шапка 'TNF'
        case 271: return 18354;  // Красная шапка с помпоном
        case 272: return 18355;  // Салатовая шапка с помпоном
        case 273: return 18356;  // Зеленая шапка с помпоном
        case 274: return 18357;  // Синяя шапка с помпоном
        case 275: return 18358;  // Фиолетовая шапка с помпоном
        case 276: return 18366;  // Синяя шапка с помпоном и узором
        case 277: return 18364;  // Красная шапка с красным помпоном
        case 278: return 18365;  // Красная шапка с белым помпоном
        case 279: return 18367;  // Зеленая шапка с белым помпоном
        case 280: return 18368;  // Бирюзовая шапка с белым помпоном
        case 281: return 18369;  // Новогодний топорик
        case 282: return 18370;  // Голубая шапка с помпоном
        case 283: return 18371;  // Красная шапка с помпоном
        case 284: return 18372;  // Фиолетово-зеленая шапка с помпоном
        case 285: return 18373;  // Синяя шапка с красным помпоном
        case 286: return 18374;  // Черная шапка с помпоном
        case 287: return 18375;  // Новогодняя палочка с кристаллом
        case 288: return 18376;  // Разноцветная шапка для пацанов
        case 289: return 18377;  // Очки-сердечки
        case 290: return 18378;  // Рюкзак 'Котик'
        case 291: return 18379;  // Рюкзак Санта-Клауса
        case 292: return 18380;  // Розовые очки 'Крылья летучей мыши'
        case 293: return 18381;  // Очки 'Red Bloody'
        case 294: return 18382;  // Очки 'Крылья бабочки'
        case 295: return 18383;  // Черная панама с сигарой
        case 296: return 18384;  // Серая панама с сигарой
        case 297: return 18385;  // Темная панама с сигарой
        case 298: return 18386;  // Очки 'Глаза кошки'
        case 299: return 18387;  // Очки 'Облака с грозой'
        case 300: return 18388;  // Очки 'Новогодние с рогами'
        case 301: return 18389;  // Новогодняя шапка с рогами
        case 302: return 18390;  // Очки 'Моргающие глаза'
        case 303: return 18391;  // Очки 'Пламя'
        case 304: return 18392;  // Прямые очки 'Огонь'
        case 305: return 18393;  // Очки 'Оранжевые огни'
        case 306: return 18394;  // Розовые очки-сердечки
        case 307: return 18395;  // Голубые очки-звездочки
        case 308: return 18396;  // Шапка гнома с бородой
        case 309: return 18397;  // Гринч
        case 310: return 18398;  // Новогодняя шапка с гирляндой
        case 311: return 18399;  // Гребешок с ушками и рогами
        case 312: return 18400;  // Коричневый гребешок с ушками 
        case 313: return 18401;  // Очки 'Анимированный салют'
        case 314: return 18402;  // Маска кошечки
        case 315: return 18403;  // Маска тигра
        case 316: return 18404;  // Прямые очки 'Матрица'
        case 317: return 18405;  // Рюкзак 'Олаф'
        case 318: return 18406;  // Рюкзак Новогоднего оленя
        case 319: return 18407;  // Борода
        case 320: return 18408;  // Шарф с тигровой шерстью
        case 321: return 18409;  // Очки с падающими снежинками
        case 322: return 18410;  // Очки 'Сквидвард'
        case 323: return 18411;  // Голубой посох со снежинкой
        case 324: return 18412;  // Очки 'Санрайз у воды'
        case 325: return 18413;  // Новогодняя шапка птички
        case 326: return 18414;  // Прямые очки 'WARNING'
        case 327: return 18415;  // Очки 'голубые крылья'
        case 328: return 17983;  // Зеленый берет
        case 329: return 17984;  // Красный берет
        case 330: return 17985;  // Синий берет
        case 331: return 17986;  // Салатовый берет
        case 332: return 17987;  // Желтый берет
        case 333: return 17988;  // Красная шапка 'Sport'
        case 334: return 17989;  // Голубая шапка 'Sport'
        case 335: return 17990;  // Светлая панама
        case 336: return 17991;  // Темная панама
        case 337: return 17992;  // Черная шапка-ушанка
        case 338: return 17993;  // Кремовая шапка-ушанка
        case 339: return 17994;  // Красная шапка-ушанка
        case 340: return 17995;  // Синяя шапка-ушанка
        case 341: return 17996;  // Зеленая шапка-ушанка
        case 342: return 17997;  // Черная шапка с помпоном
        case 343: return 17998;  // Белая шапка с помпоном
        case 344: return 17999;  // Серая шапка с помпоном
        case 345: return 13628;  // Бомба
        case 346: return 1210;   // Документы
        case 347: return 18497;  // Шарик
        case 348: return 18498;  // Очки 'Выпуклые глаза'
        case 349: return 18499;  // Очки 'Обычные глаза'
        case 350: return 18500;  // Маска клоуна
        case 351: return 18501;  // Маска клоуна
        case 352: return 18502;  // Лицо тролля
        case 353: return 18503;  // �?нопланетянин
        case 354: return 18504;  // Лицо тролля с париком
        case 355: return 18505;  // �?нопланетянин с париком
        case 356: return 18506;  // Очки с носом
        case 357: return 18507;  // Нос клоуна
        case 358: return 18508;  // Парик клоуна
        case 359: return 18509;  // Кейс Макита
        case 360: return 18510;  // Кейс черный
        case 361: return 18511;  // Кейс серый
        case 362: return 18512;  // Золотая корона
        case 363: return 18513;  // Корона короля
        case 364: return 18514;  // Серебряная корона
        case 365: return 18515;  // Лавровый венец
        case 366: return 18516;  // Диадема
        case 367: return 18517;  // Очки Доллар
        case 368: return 18518;  // Очки День рождения
        case 369: return 18519;  // Праздничный колпак
        case 370: return 18520;  // Неоновые очки
        case 371: return 18521;  // Неоновые очки
        case 372: return 18522;  // Неоновые очки
        case 373: return 18523;  // Неоновые очки
        case 374: return 18524;  // Неоновые очки
        case 375: return 18525;  // Неоновые очки
        case 376: return 18526;  // Очки пиксели
        case 377: return 18527;  // Шар
        case 378: return 18528;  // Шар звезда
        case 379: return 18529;  // Шар нота
        case 380: return 18530;  // Шар сердце
        case 381: return 18567;  // Самолет
        case 382: return 18568;  // Самолет
        case 383: return 18569;  // Шлем
        case 384: return 18570;  // Панама
        case 385: return 18571;  // Панама
        case 386: return 18572;  // Фуражка
        case 387: return 18573;  // Пилотка
        case 388: return 18574;  // Кепка
        case 389: return 18575;  // Кепка
        case 390: return 18576;  // Вертолет
        case 391: return 7327;   // Бандана
        case 392: return 7328;   // Бандана
        case 393: return 7329;   // Бандана
        case 394: return 7330;   // Бандана на лицо
        case 395: return 7331;   // Бандана
        case 396: return 7332;   // Бандана
        case 397: return 7333;   // Бандана
        case 398: return 7334;   // Бандана
        case 399: return 7335;   // Кепка
        case 400: return 7336;   // Кепка
        case 401: return 7337;   // Кепка
        case 402: return 7338;   // Кепка
        case 403: return 7339;   // Кепка
        case 404: return 7340;   // Кепка
        case 405: return 7341;   // Кепка
        case 406: return 7342;   // Шапка
        case 407: return 7343;   // Панама
        case 408: return 7344;   // Панама
        case 409: return 7345;   // Панама
        case 410: return 7346;   // Панама
        case 411: return 7347;   // Панама
        case 412: return 7348;   // Панама
        case 413: return 7349;   // Панама
        case 414: return 7350;   // Панама
        case 415: return 7351;   // Кепка для питья
        case 416: return 7352;   // Кепка для питья
        case 417: return 7353;   // Кепка для питья
        case 418: return 7354;   // Кепка для питья
        case 419: return 7355;   // Шляпка
        case 420: return 7356;   // Шляпка
        case 421: return 7357;   // Шляпка
        case 422: return 7358;   // Шляпка
        case 423: return 7359;   // Треуголка
        case 424: return 7360;   // Сомбреро
        case 425: return 7361;   // Наушники
        case 426: return 7362;   // Арбузный шлем
        case 427: return 7363;   // Велосипедный шлем
        case 428: return 7364;   // Зонт-шляпа
        case 429: return 7365;   // Маска для дайвинга
        case 430: return 7366;   // Маска для дайвинга
        case 431: return 7367;   // Кожаный кейс
        case 432: return 7368;   // Кожаный кейс
        case 433: return 7369;   // Кожаный кейс
        case 434: return 7370;   // Маска курицы
        case 435: return 7371;   // Маска голубя
        case 436: return 7372;   // Маска
        case 437: return 7373;   // Маска
        case 438: return 7374;   // Маска медведя
        case 439: return 7375;   // Самурайская маска
        case 440: return 7376;   // Самурайский шлем
        case 441: return 7377;   // Самурайская Катана
        case 442: return 7378;   // Самурайская Катана
        case 443: return 7379;   // Самурайская шляпа
        case 444: return 7380;   // Самурайская шляпа
        case 445: return 7381;   // Самурайская шляпа
        case 446: return 7382;   // �?ндейский головной убор
        case 447: return 7383;   // Доска для серфинга
        case 448: return 7384;   // Доска для серфинга
        case 449: return 7385;   // Доска для серфинга
        case 450: return 7386;   // Доска для серфинга
        case 451: return 7387;   // Акула
        case 452: return 7388;   // Попугай
        case 453: return 7389;   // Попугай
        case 454: return 7390;   // Электрогитара
        case 455: return 7391;   // Электрогитара
        case 456: return 7392;   // Электрогитара
        case 457: return 7393;   // Электрогитара
        case 458: return 7394;   // Скейт
        case 459: return 7395;   // Скейт
        case 460: return 7396;   // Скейт
        case 461: return 7397;   // Пакет на голову
        case 463: return 5371;   // Шляпа тьмы
        case 464: return 5372;   // Пиратская шляпа
        case 465: return 5373;   // Шляпа ночи
        case 466: return 5374;   // Череп воробья
        case 467: return 5375;   // Обезьяна
        case 468: return 5376;   // Меч смерти
        case 469: return 5377;   // Меч темных сил
        case 470: return 5378;   // Меч короля пиратов
        case 471: return 5379;   // Красная бандана
        case 472: return 5380;   // Подзорная труба
        case 473: return 5381;   // Пистолет черных душ
        case 474: return 5382;   // Пистолет черной смерти
        case 475: return 5383;   // Легендарная шляпа
        case 476: return 5384;   // Фонарь пирата
        case 477: return 4231;   // Удочка
        case 478: return 4242;   // Ваза
        case 479: return 4243;   // Ваза
        case 480: return 4241;   // Золотая чашка
        case 481: return 4240;   // Бронзовая чашка
        case 482: return 4239;   // Компас
        case 483: return 4238;   // Будильник
        case 484: return 4237;   // Колесо
        case 485: return 4232;   // Аккумулятор
        case 486: return 4236;   // Стиральная машина
        case 487: return 4234;   // Двигатель
        case 488: return 4233;   // Камера
        case 489: return 4235;   // Бензопила
        case 490: return 4196;   // Крылья бабочки
        case 491: return 4197;   // Маска пчелы
        case 492: return 4198;   // Кленовая корона
        case 493: return 4199;   // Рюкзак реактивный
        case 494: return 4200;   // Сумка с листьями
        case 495: return 4201;   // Метла
        case 496: return 4202;   // Ушанка
        case 497: return 4203;   // Рюкзак
        case 498: return 4204;   // Рюкзак
        case 499: return 4205;   // Подсолнух
        case 500: return 4206;   // Черный зонт
        case 501: return 4207;   // Осенний зонт
        case 502: return 4208;   // Розовый зонт
        case 503: return 13908;  // Маска Кощея
        case 504: return 13879;  // Маска Бабы Яги
        case 505: return 13880;  // Маска Вурдалака
        case 506: return 13881;  // Черный ворон
        case 507: return 13882;  // Маска Демона
        case 508: return 13883;  // Корона Демона
        case 509: return 14574;  // Крылья Демона
        case 510: return 13884;  // Вилы Демона
        case 511: return 14575;  // Крылья ангела
        case 512: return 13885;  // Крылья летучей мыши
        case 513: return 14589;  // Маска новогоднего оленя
        case 514: return 14590;  // Маска новогодняя печенька
        case 515: return 14591;  // Белые рога с ушами
        case 516: return 14592;  // Уши эльфа
        case 517: return 14593;  // Карамельные крылья
        case 518: return 14594;  // Новогодний кейс
        case 519: return 14595;  // Рождественский кот
        case 520: return 14596;  // Маска новогодняя елочка
        case 521: return 14597;  // Рождественские рога
        case 522: return 14598;  // Маска Деда Мороза
        case 523: return 14599;  // Маска Лесного гнома
        case 524: return 14600;  // Детские рога с печеньками
        case 525: return 14601;  // Рождественская сумка
        case 526: return 14602;  // Тёплая новогодняя шапка
        case 527: return 14603;  // Новогодняя шапка ушанка
        case 528: return 14604;  // Шапка новогодняя елочка
        case 529: return 4158;   // Очки Новогодняя елочка
        case 530: return 4159;   // Маска полярного пингвина
        case 531: return 4160;   // Маска новогодний кекс
        case 532: return 4161;   // Маска Новогодний мишка
        case 533: return 4162;   // Маска Снегурочка
        case 534: return 4163;   // Маска снеговика
        case 535: return 4164;   // Теплый новогодний шарф
        case 536: return 4165;   // Сумка из головы снеговика
        case 537: return 4166;   // Сумка елочки
        case 538: return 13761;  // Корзина цветов
        case 539: return 13762;  // Венок
        case 540: return 13746;  // Рюкзак Океан
        case 541: return 13747;  // Рюкзак Глаза
        case 542: return 13748;  // Очки Gold Man
        case 543: return 13749;  // Очки Gold Salad
        case 544: return 13750;  // Рюкзак Cosmo
        case 545: return 13751;  // Рюкзак Сердце
        case 546: return 13752;  // Очки Pink Queen
        case 547: return 13753;  // Очки Purple Energy
        case 548: return 13754;  // Очки Red Power
        case 549: return 13755;  // Турист. рюкзак
        case 550: return 13735;  // Сумка Мона Лиза
        case 551: return 13736;  // Венок
        case 552: return 13737;  // Сумка Калифорния
        case 553: return 13738;  // Сумка Поляна
        case 554: return 13739;  // Сумка Апельсин
        case 555: return 13740;  // Кейс Градиент
        case 556: return 13741;  // Сумка сад
        case 557: return 13742;  // Кейс Весенняя палитра
        case 558: return 13743;  // Змей
        case 559: return 13744;  // Бабочки
        case 560: return 13745;  // Кейс Чистое небо
        case 561: return 13266;  // Маска Крейта
        case 562: return 13897;  // Рюкзак '3 года вместе'
        case 563: return 13804;  // Круг Крокодил
        case 564: return 13805;  // Круг Единорог
        case 565: return 13806;  // Рюкзак Электроник
        case 566: return 13807;  // Сумка Первое Мая
        case 567: return 13808;  // Круг Фламинго
        case 568: return 13809;  // Рюкзак Гром
        case 569: return 13810;  // Рюкзак май. цветы
        case 570: return 13811;  // Сумка майские розы
        case 571: return 13812;  // Сумка Мир Май
        case 572: return 13813;  // Сумка Молот
        case 573: return 13814;  // Серфборд Лагуна
        case 574: return 13815;  // Серфборд Сияние
        case 575: return 13816;  // Сумка Серп
        case 576: return 13801;  // Катюша
        case 577: return 13802;  // Щит
        case 578: return 13803;  // Рюкзак Солдатик
        case 579: return 11919;  // Акула на голову
        case 580: return 11920;  // Пляжная шляпа
        case 581: return 11921;  // Пляжные очки
        case 582: return 11922;  // Геймбой
        case 583: return 11923;  // Мопс
        case 584: return 11924;  // Летний рюкзак
        case 585: return 11925;  // Летняя доска
        case 586: return 1377;   // Муляж Арбалета
        case 587: return 1378;   // Маска Кролика
        case 588: return 1379;   // Охотничий рюкзак
        case 589: return 1380;   // Медвежья маска
        case 590: return 1381;   // Заячья маска
        case 591: return 1382;   // Охотничья маска
        case 592: return 1383;   // Охотничий пояс
        case 593: return 1384;   // Пояс Дробь
        case 594: return 1385;   // Охотничий чехол
        case 595: return 1386;   // Муляж топора
        case 596: return 1387;   // Орел
        case 597: return 1388;   // Охотничья панама
        case 598: return 1389;   // Боевой рюкзак
        case 599: return 1390;   // Охотничья шляпа
        case 600: return 9794;   // Наушники RC
        case 601: return 9795;   // Шлем PNG
        case 602: return 9796;   // Рюкзак OffRoad
        case 603: return 9797;   // Сумка Гонщика
        case 604: return 9798;   // Сумка Cosmic
        case 605: return 9799;   // Сумка Champions
        case 606: return 9800;   // Рюкзак Orange
        case 607: return 9801;   // Сумка Пилота
        case 608: return 9802;   // Кубок Победителя
        case 609: return 9803;   // Очки Pink Racer
        case 610: return 9804;   // Шлем пилота
        case 611: return 9805;   // Очки Black Cobra
        case 612: return 9806;   // Розовый Шлем
        case 613: return 4103;   // Дырявый ботинок
        case 614: return 4112;   // Водоросли
        case 615: return 4105;   // Костистый угорь
        case 616: return 4109;   // Подуст
        case 617: return 4110;   // Глухарь
        case 618: return 4098;   // Карась
        case 619: return 4097;   // Щука
        case 620: return 4102;   // Окунь
        case 621: return 4096;   // Кета
        case 622: return 4119;   // Налим
        case 623: return 4100;   // Осетр
        case 624: return 4101;   // Сом
        case 625: return 4107;   // Таймень
        case 626: return 4108;   // Лосось
        case 627: return 4099;   // Белуга
        case 628: return 4104;   // Стерлядь
        case 629: return 4106;   // Каменный хариус
        case 630: return 4111;   // Золотая рыбка
        case 631: return 4085;   // Бамбуковая удочка
        case 632: return 4084;   // Адаптивная удочка
        case 633: return 4087;   // Королевская удочка
        case 634: return 4089;   // Технологическая удочка
        case 635: return 4086;   // Карбоновая удочка
        case 636: return 4088;   // Легендарная удочка
        case 637: return 4094;   // Старый хлеб
        case 638: return 4090;   // Черви
        case 639: return 4092;   // �?скуственный мотыль
        case 640: return 4091;   // �?митация насекомых
        case 641: return 4093;   // Мерцающий воблер
        case 642: return 4117;   // Быстрый крючок
        case 643: return 4116;   // Супер-удар
        case 644: return 4114;   // Темный камуфляж
        case 645: return 4113;   // Магнум-мормышка
        case 646: return 4115;   // Мастер-трофеев
        case 647: return 9376;   // Розовый рюкзак оборотня
        case 648: return 9377;   // Кошачьи ушки
        case 649: return 9378;   // Проклятая ворона
        case 650: return 9379;   // Летучая мышь
        case 651: return 9380;   // Маска дяди
        case 652: return 9381;   // Рука
        case 653: return 9382;   // Маска
        case 654: return 9383;   // Моргенштерн
        case 655: return 9384;   // Ядовитый паук
        case 656: return 9385;   // Маска оборотня
        case 657: return 9386;   // Крылья демона 2023
        case 658: return 9387;   // Рюкзак готический
        case 659: return 9388;   // Сумка волка
        case 660: return 9824;   // Весёлая тыква
        case 661: return 9825;   // Рюкзак Хеллоуинская ночь
        case 662: return 9826;   // Маска Вампир
        case 663: return 9827;   // Кукла Вуду
        case 664: return 9828;   // Рюкзак Призрачный портал
        case 665: return 19211;  // Красный Кристалл
        case 666: return 19212;  // Синий Кристалл
        case 667: return 19213;  // Зеленый Кристалл
        case 668: return 6169;   // Крылья Дракона
        case 669: return 6170;   // Крылья Феи
        case 670: return 6171;   // Рюкзак Буран
        case 671: return 6172;   // Шарф Моё рождество
        case 672: return 6173;   // Маска Black Santa
        case 673: return 6174;   // Маска Пепе
        case 674: return 6175;   // Рождественские рожки
        case 675: return 6176;   // Маска котика
        case 676: return 6177;   // Маска дракона
        case 677: return 6178;   // Новогодняя корона
        case 678: return 6179;   // Сумка Арт от Санты
        case 679: return 6180;   // Сумка Как раньше
        case 680: return 6181;   // Рюкзак Подарочки
        case 681: return 786;    // Новогодний поезд
        case 682: return 787;    // Маска Зеленый дракон
        case 683: return 788;    // Рюкзак Щелкунчик
        case 684: return 789;    // Мешок с подарками
        case 685: return 790;    // Новогодний дракон
        case 686: return 662;    // НГ Ушанка 2024
        case 687: return 663;    // Горн. очки 2024
        case 688: return 9406;   // Катана на спину
        case 689: return 9407;   // Миниатюрный дирижабль
        case 690: return 9408;   // Маска гепарда
        case 691: return 9409;   // Маска лисы
        case 692: return 9410;   // Рюкзак Subway
        case 693: return 15446;  // Сумка Sunrise
        case 694: return 15447;  // Розовая кепка
        case 695: return 15448;  // Маска крокодила
        case 696: return 15449;  // Маска петуха
        case 697: return 1094;   // Рюкзак Color bang
        case 698: return 1095;   // Бензопила в стиле Punk
        case 699: return 1205;   // Пляжная панама
        case 700: return 1206;   // Сумка Pink Style
        case 701: return 781;    // BR VISUALS MAX 
        case 702: return 780;    // БРОНЕЖ�?ЛЕТ SUNRAY
        case 703: return 1231;   // ОЧК�? Л�?ДЕРА
        case 704: return 1230;   // Ж�?ЛЕТ ГЕРОЯ
        case 705: return 4359;   // Рюкзак Сифона
        case 706: return 4360;   // ПОБ�?ТЫЕ ОЧК�?
        case 707: return 4361;   // МАСКА СВ�?НА
        case 708: return 16045;  // Рюкзак BLACK BRICK
        case 709: return 16055;  // Анимированная Лапка
        case 710: return 4784;   // Бандана Ниндзя
        case 711: return 4785;   // Свиток за спину
        case 712: return 4786;   // Маска-бензопила
        case 713: return 4787;   // Черный меч
        case 714: return 4788;   // Демонические рожки
        case 715: return 4789;   // Гигантская фляга
        case 716: return 4790;   // Гитарный кейс
        case 717: return 4791;   // Очки героя
        case 718: return 4792;   // Парные катаны
        case 719: return 4793;   // Загадочный сундук
        case 720: return 4794;   // Шляпа пирата
        case 721: return 4795;   // Школьный ранец
        case 722: return 14672;  // Маска кузнеца
        case 723: return 14671;  // Шапка Военного
        case 724: return 1328;   // Подарочный топор
        case 725: return 1329;   // Панамка блогера
        case 726: return 1330;   // Шапка-ушанка
        case 727: return 3154;   // Победная клюшка
        case 728: return 3153;   // Баскетбольный рюкзак
        case 729: return 1997;   // Балалайка
        case 730: return 1991;   // Боксерский шлем старшего брата
        case 731: return 2001;   // Деревянная корона
        case 732: return 1984;   // Деревянный шлем
        case 733: return 1992;   // Детский спасательный жилет
        case 734: return 2005;   // Камера от тракторного колеса
        case 735: return 1986;   // Кепка Таксист
        case 736: return 2006;   // Маска пакет
        case 737: return 1982;   // Правая боксерская перчатка
        case 738: return 1998;   // Рога оленя
        case 739: return 1987;   // Шапка ушанка
        case 740: return 2003;   // Банная шапка BLACK RUSSIA
        case 741: return 1999;   // Банный веник
        case 742: return 1980;   // Баян
        case 743: return 1995;   // Военная пилотка
        case 744: return 1996;   // Деревянный автомат AK-47
        case 745: return 1979;   // Деревянный меч
        case 746: return 1990;   // Маска Ведро
        case 747: return 1985;   // Маска из мешковины
        case 748: return 2007;   // Маска кабана
        case 749: return 1978;   // Мягкая игрушка Голубь
        case 750: return 1981;   // Солдатская каска
        case 751: return 1993;   // Шляпа рыбака
        case 752: return 1983;   // Кухонная сковорода
        case 753: return 2002;   // Маска Пугало огородное
        case 754: return 2008;   // Мексиканская гитара
        case 755: return 32423;  // Мягкая игрушка Дух дома
        case 756: return 32405;  // Рюкзак �?мпортный
        case 757: return 1988;   // Шлем Череп
        case 758: return 2004;   // Маска Ленин
        case 759: return 1989;   // Маска Сталин
        case 760: return 9960;   // Краска
        case 761: return 5283;   // Алюминий
        case 762: return 5286;   // ВВ-40
        case 763: return 9966;   // Железо
        case 764: return 5275;   // Клей
        case 765: return 5284;   // Кожа
        case 766: return 5287;   // Крепеж
        case 767: return 5291;   // Нити
        case 768: return 10001;  // Пиломатериалы
        case 769: return 5289;   // Пластик
        case 770: return 9972;   // Резина
        case 771: return 5826;   // Блок управления
        case 772: return 5828;   // Ботинки
        case 773: return 9999;   // Двигатель Мотоцикл
        case 774: return 5285;   // Качественная кожа
        case 775: return 9990;   // Колесо Мотоцикл
        case 776: return 9975;   // Маскировочная сеть
        case 777: return 9984;   // Рама Внедорожный мотоцикл
        case 778: return 5822;   // Руль Мотоцикл
        case 779: return 5283;   // Сталь
        case 780: return 2649;   // Ткань
        case 781: return 5280;   // Шестерни
        case 782: return 9994;   // Двигатель Автомобиль
        case 783: return 9998;   // Колесо Автомобиль
        case 784: return 9993;   // Колесо Внедорожник
        case 785: return 10002;  // Руль Автомобиль
        case 786: return 5828;   // Туфли
        case 787: return 5281;   // Сварочный аппарат
        case 788: return 5273;   // Углепластик
        case 789: return 9992;   // Колесо Спортивный автомобиль
        case 790: return 9969;   // Кузов Внедорожник
        case 791: return 5830;   // Улучшенный блок управления
        case 792: return 10000;  // Двигатель Спортивный автомобиль
        case 793: return 9964;   // Кузов Спортивный автомобиль
        case 794: return 9974;   // Бокситы
        case 795: return 9997;   // Древесина
        case 796: return 5274;   // Железная руда
        case 797: return 5270;   // Металлолом
        case 798: return 5272;   // Обрезки резины
        case 799: return 5292;   // Пластиковая бутылка
        case 800: return 5278;   // Радиодетали
        case 801: return 5288;   // Реагенты
        case 802: return 5271;   // Текстильное волокно
        case 803: return 9980;   // Шкура животного
        case 804: return 9973;   // �?нструкция Алюминий
        case 805: return 9973;   // �?нструкция Балалайка
        case 806: return 9973;   // �?нструкция Боксерский шлем старшего брата
        case 807: return 9973;   // �?нструкция ВВ-40
        case 808: return 9973;   // �?нструкция Деревянная корона
        case 809: return 9973;   // �?нструкция Деревянный шлем
        case 810: return 9973;   // �?нструкция Детский спасательный жилет
        case 811: return 9973;   // �?нструкция Железо
        case 812: return 9973;   // �?нструкция Камера от тракторного колеса
        case 813: return 9973;   // �?нструкция Кепка Таксист
        case 814: return 9973;   // �?нструкция Клей
        case 815: return 9973;   // �?нструкция Кожа
        case 816: return 9973;   // �?нструкция Краска
        case 817: return 9973;   // �?нструкция Крепеж
        case 818: return 9973;   // �?нструкция Маска пакет
        case 819: return 9973;   // �?нструкция Нити
        case 820: return 9973;   // �?нструкция Пиломатериалы
        case 821: return 9973;   // �?нструкция Пластик
        case 822: return 9973;   // �?нструкция Правая боксерская перчатка
        case 823: return 9973;   // �?нструкция Резина
        case 824: return 9973;   // �?нструкция Рога оленя
        case 825: return 9973;   // �?нструкция Шапка ушанка
        case 826: return 9973;   // �?нструкция Банная шапка BLACK RUSSIA
        case 827: return 9973;   // �?нструкция Банный веник
        case 828: return 9973;   // �?нструкция Баян
        case 829: return 9973;   // �?нструкция Блок управления
        case 830: return 9973;   // �?нструкция Ботинки
        case 831: return 9973;   // �?нструкция Анаконда
        case 832: return 9973;   // �?нструкция Военная пилотка
        case 833: return 9973;   // �?нструкция Двигатель Мотоцикла
        case 834: return 9973;   // �?нструкция Деревянный автомат AK-47
        case 835: return 9973;   // �?нструкция Деревянный меч
        case 836: return 9973;   // �?нструкция Качественная кожа
        case 837: return 9973;   // �?нструкция Колесо Мотоцикла
        case 838: return 9973;   // �?нструкция Образ Егерь
        case 839: return 9973;   // �?нструкция Маска
        case 840: return 9973;   // �?нструкция Маска Ведро
        case 841: return 9973;   // �?нструкция Маска из мешковины
        case 842: return 9973;   // �?нструкция Маска кабана
        case 843: return 9973;   // �?нструкция Маскировочная сеть
        case 844: return 9973;   // �?нструкция Мягкая игрушка Голубь
        case 845: return 9973;   // �?нструкция Рама Внедорожного мотоцикла
        case 846: return 9973;   // �?нструкция Руль Мотоцикла
        case 847: return 9973;   // �?нструкция Солдатская каска
        case 848: return 9973;   // �?нструкция Сталь
        case 849: return 9973;   // �?нструкция Ткань
        case 850: return 9973;   // �?нструкция Шестерни
        case 851: return 9973;   // �?нструкция Шляпа рыбака
        case 852: return 9973;   // �?нструкция Двигатель Автомобиля
        case 853: return 9973;   // �?нструкция Колесо Автомобиля
        case 854: return 9973;   // �?нструкция Колесо Внедорожника
        case 855: return 9973;   // �?нструкция Образ Местный Шериф
        case 856: return 9973;   // �?нструкция Кухонная сковорода
        case 857: return 9973;   // �?нструкция Маска Пугало огородное
        case 858: return 9973;   // �?нструкция Мексиканская гитара
        case 859: return 9973;   // �?нструкция Руль Автомобиля
        case 860: return 9973;   // �?нструкция Бекас
        case 861: return 9973;   // �?нструкция Туфли
        case 862: return 9973;   // �?нструкция Сварочный аппарат
        case 863: return 9973;   // �?нструкция Углепластик
        case 864: return 9973;   // �?нструкция Медведь
        case 865: return 9973;   // �?нструкция Колесо Спортивного автомобиля
        case 866: return 9973;   // �?нструкция Образ Щёголь
        case 867: return 9973;   // �?нструкция Кузов Внедорожника
        case 868: return 9973;   // �?нструкция Мягкая игрушка Дух дома
        case 869: return 9973;   // �?нструкция Улучшенный блок управления
        case 870: return 9973;   // �?нструкция Рюкзак �?мпортный
        case 871: return 9973;   // �?нструкция Шлем Череп
        case 872: return 9973;   // �?нструкция Двигатель Спортивного автомобиля
        case 873: return 9973;   // �?нструкция Кузов Спортивного автомобиля
        case 874: return 9973;   // �?нструкция Маска Ленин
        case 875: return 9973;   // �?нструкция Маска Сталин
        case 876: return 9973;   // �?нструкция Волколак
        case 877: return 16026;  // Рюкзак ColorBlock
        case 878: return 16027;  // Шляпа изгнанника
        case 879: return 16028;  // Рюкзак Футболиста
        case 880: return 16029;  // Доска спасателя
        case 881: return 16030;  // BR Mix Blue
        case 882: return 16031;  // Шлем MotoRise
        case 883: return 16032;  // Очки SpeedPulse
        case 884: return 16033;  // Спортивная бейсболка
        case 885: return 16034;  // Теннисная ракетка
        case 886: return 16035;  // Рюкзак туриста
        case 887: return 6101;   // Respirator
        case 888: return 6102;   // Gamer Backpack
        case 889: return 6103;   // Boost Glasses
        case 890: return 1652;   // Маска дайвера
        case 891: return 1651;   // Рюкзак Боксера
        case 892: return 1653;   // Водяной пистолет
        case 893: return 9973;   // �?нструкция Двигатель Моторной лодки
        case 894: return 9973;   // �?нструкция Корпус Деревянной лодки
        case 895: return 9973;   // �?нструкция Лахтак
        case 896: return 9973;   // �?нструкция Водостойкая ткань
        case 897: return 9973;   // �?нструкция Рама Багги
        case 898: return 9973;   // �?нструкция Рама Мотоцикла
        case 899: return 9973;   // �?нструкция Кузов Автомобиля
        case 900: return 9973;   // �?нструкция Корпус Металлической лодки
        case 901: return 9973;   // �?нструкция Каракал
        case 902: return 9973;   // �?нструкция Крайт
        case 903: return 9973;   // �?нструкция Ларга
        case 904: return 9973;   // �?нструкция Акиба
        case 905: return 12302;  // Двигатель Моторной лодки
        case 906: return 12308;  // Корпус Деревянной лодки
        case 907: return 12304;  // Водостойкая ткань
        case 908: return 12306;  // Рама Багги
        case 909: return 12303;  // Рама Мотоцикла
        case 910: return 12301;  // Кузов Автомобиля
        case 911: return 12307;  // Корпус Металлической лодки
        case 912: return 791;    // Рюкзак Наследие
        case 913: return 792;    // Кепка Финиш
        case 914: return 2655;   // Шлем велосипедиста
        case 915: return 2656;   // Надувной жилет
        case 916: return 2657;   // Очки звездочки
        case 917: return 676;    // Очки Люкс
        case 918: return 677;    // Советская шапка
        case 919: return 4859;   // Шлем MVP
        case 920: return 4862;   // Тактический пояс
        case 921: return 1975;   // Полицейская дубинка
        case 922: return 4861;   // Фуражка Агента
        case 923: return 4863;   // Шлем MechaCat
        case 924: return 4864;   // Рюкзак Fuel
        case 925: return 4860;   // Жилет Superior
        case 926: return 4550;   // Очки одержимого
        case 927: return 4372;   // Темный шар рюкзак
        case 928: return 4542;   // Дьявольские очки
        case 929: return 4543;   // Посох Одержимого
        case 930: return 10493;  // Маска Clownade
        case 931: return 10494;  // Рюкзак Ghost
        case 932: return 7712;   // Рюкзак Механика
        case 933: return 4544;   // Крылья Демона 2024
        case 934: return 4548;   // Убийственный Топор
        case 935: return 4545;   // Защитный Амулет
        case 936: return 7727;   // Кот-Колпак
        case 937: return 7729;   // Жилет Skeleton
        case 938: return 4546;   // Книга Тайн
        case 939: return 10492;  // Шлем Bunny
        case 940: return 4547;   // Живая Росянка
        case 941: return 4549;   // Ловец Духов
        case 942: return 14641;  // Шлем Speedster
        case 943: return 10488;  // Сумка CrossTrack
        case 944: return 14647;  // Сумка SpeedPack
        case 945: return 14643;  // Рюкзак Energy
        case 946: return 4702;   // Маска Fresh'а
        case 947: return 14645;  // Шарф Racing
        case 948: return 14790;  // Жилет SnakeSkin
        case 949: return 14791;  // Голова Монстра
        case 950: return 14648;  // Шлем Победитель
        case 951: return 14644;  // Очки Street
        case 952: return 14646;  // Пояс Nitro
        case 953: return 4699;   // Маска SnowVision
        case 954: return 4700;   // Шлем DeathSnake
        case 955: return 14630;  // Рюкзак Techno
        case 956: return 14642;  // Скоростные крылья
        case 957: return 4701;   // Нагрудник Racing Heart
        case 958: return 11292;  // Винтажная кепка
        case 959: return 15056;  // Колчан на ногу
        case 960: return 14266;  // Сова на плечо
        case 961: return 14265;  // Нерабочий Арбалет
        case 962: return 11328;  // Рюкзак-жилет
        case 963: return 15057;  // Рюкзак Жидкое золото
        case 964: return 10916;  // Мото-очки
        case 965: return 11304;  // Маска Чилл
        case 966: return 15055;  // Сумка мажора
        case 967: return 15058;  // Шляпа охотника
        case 968: return 17510;  // Маска Дух леса
        case 969: return 17509;  // Рюкзак Следопыта
        case 970: return 16699;  // Рюкзак Танкиста
        case 971: return 15630;  // Маска Погодь
        case 972: return 15631;  // Бита Выключатель
        case 973: return 15632;  // Муляж АК-47
        case 974: return 15633;  // Мегафон
        case 975: return 15634;  // Рюкзак Копилка
        case 976: return 15626;  // Рюкзак Матрешка
        case 977: return 15627;  // Голова Клоуна
        case 978: return 15635;  // Электрическая дубинка
        case 979: return 15636;  // Кепка-платок Браток
        case 980: return 15638;  // Сумка Замок
        case 981: return 15628;  // Рюкзак Крысагент
        case 982: return 15629;  // Подарочная Шляпа №5
        case 983: return 31949;  // Берет 80
        case 984: return 31963;  // Круг Дитя заката
        case 985: return 31962;  // Рюкзак Shark
        case 986: return 31967;  // Голова Лягушки
        case 987: return 31970;  // Сумка Кастет
        case 988: return 31969;  // Попугай на плечо
        case 989: return 31966;  // Шляпа Солнечный Зайчик
        case 990: return 31965;  // Кулон Драконий камень
        case 991: return 31961;  // Рюкзак Олигарха
        case 992: return 31964;  // Маска Жу-жу-жу
        case 993: return 32154;  // Камера ЦОДД
        case 994: return 32131;  // Очки Лихача
        case 995: return 32132;  // Сумка Починил!
        case 996: return 32133;  // Жилет Детектива
        case 997: return 32134;  // Рюкзак На старт!
        case 998: return 32135;  // Шлем Рейсера
        case 999: return 32129;  // Рюкзак Ускорение
        case 1000: return 32136; // Голова ОКАК
        case 1001: return 32130; // Сумка Мастера
        case 1002: return 32137; // Маска Metal Dragon
        case 1003: return 32138; // Рюкзак Дрифтера
        case 1004: return 32139; // Очки СлайдЛинзы
        case 1005: return 32144; // Мегафон
        case 1006: return 32154; // Стационарный радар
        case 1007: return 32404; // Улика
        case 1008: return 32171; // Путевой лист
        case 1009: return 100006;// Ордер
        case 1010: return 100007;// Бланк Ордера
        case 1011: return 9973;  // �?нструкция Койот
        case 1012: return 9973;  // �?нструкция Слейпнир
        case 1013: return 32414; // Кепка Шпаргалка
        case 1014: return 32415; // Сумка Архив
        case 1015: return 32416; // Рюкзак Спорт�?нвентарь
        case 1016: return 32417; // Голова �?гры на уме
        case 1017: return 32418; // Сумка Чемпиона
        case 1018: return 32419; // Рюкзак для вечеринок
        case 1019: return 32420; // Кепка Школьника
        case 1020: return 32421; // Рюкзак Доставщика
        case 1021: return 100035;// Сумка Бизнесмена
        case 1022: return 100034;// Рюкзак Городской
        case 1023: return 100065;// Кепка Блогера
        case 1024: return 100066;// Сумка Медиума
        case 1025: return 100067;// Рюкзак Выжившего
        case 1026: return 100068;// Крылья Дьявола
        case 1027: return 100069;// Маска Лик смерти
        case 1028: return 100070;// Рюкзак Страх детства
        case 1029: return 100071;// Цилиндр Доп. �?нтеллект
        case 1030: return 100072;// Мистический Амулет
        case 1031: return 100073;// Рюкзак Гробик
        case 1032: return 100074;// Сумка Котел с зельем
        case 1033: return 100075;// Рюкзак Монстр
        case 1034: return 100076;// Очки Dragon
        case 1035: return 9973;  // Билет �?ллюзии
        case 1036: return 9973;  // �?нструкция Хиш-Миш
        case 1037: return 9973;  // �?нструкция Страх детства
        case 1038: return 9974;  // Осколки Тьмы
        case 1039: return 0;     // Оружие
        case 1040: return 0;     // Патроны
        case 1041: return 0;     // Снаряжение
        case 1042: return 0;     // Обвесы
        case 1043: return 100077;// Маска Чумного доктора
        case 1044: return 100078;// Маска Призрака
        case 1045: return 100079;// Шава в руку
        case 1046: return 100101;// Голова Пингвин
        case 1047: return 100102;// Новогодняя трость
        case 1048: return 100103;// Снежная сова на плечо
        case 1049: return 100104;// Рюкзак Снежный-друг
        case 1050: return 100105;// Голова Снеговичок
        case 1051: return 100106;// Голова Щелкунчик
        case 1052: return 100107;// Конек защитника
        case 1053: return 100108;// Сноуборд за спину
        case 1054: return 100109;// Рюкзак Снежный шар
        case 1055: return 100110;// Шлем Мороз
        case 1056: return 100111;// Рюкзак Медведь
        case 1057: return 100112;// Рюкзак Праздничный
        case 1058: return 100113;// Голова Коня
        case 1059: return 9973;  // �?нструкция Полярник Клаус
        case 1060: return 9973;  // �?нструкция Конек Защитника
        case 1061: return 9974;  // Праздничная энергия
        case 1062: return 100162;// Маска Кепарик
        case 1063: return 100163;// Сумка Блатной номер
        case 1064: return 100164;// Жилет Мама сшила
        case 1065: return 100165;// Рюкзак плеер
        case 1066: return 100166;// Кейс Рентген
        case 1067: return 100167;// Балаклава Криминал
        case 1068: return 100170;// Рюкзак Крафт
        case 1069: return 100171;// Панама Творческая
        case 1070: return 9973;  // �?нструкция Рюкзак Крафт
        case 1071: return 9973;  // �?нструкция Панама Творческая
        case 1072: return 9974;  // Синяя сталь
        case 1073: return 100169;// Рюкзак Безопасность
        case 1074: return 9974;  // Винил
        case 1075: return 100189;// Разнарядка
        case 1076: return 9973;  // Таинственный ключ
        case 1085: return 9974;  // Праздничный набор
    }

    printf("[ACCESSORY] No model found for item ID: %d", itemId);
    return -1;
}


stock bool:Gordeev_ValidateRegPassword(playerid, const password[])
{
    new str_len = strlen(password);
    if(!(6 <= str_len <= 15))

{
        ShowNotificationNew(playerid, 2, 5, -1, -1, "����� ������ ������ ���� �� 6 �� 15 ��������", "");
        return false;
    }
    if(strfind(password, "%") != -1 || strfind(password, " ") != -1)

{
        ShowNotificationNew(playerid, 2, 5, -1, -1, "������ �������� ������������ ������� ��� �������", "");
        return false;
    }
    if(IsNumeric(GetPlayerNameEx(playerid)))
{
        ShowNotificationNew(playerid, 2, 5, -1, -1, "��� �� ������ �������� ������ �� ����", "");
        Kick:(playerid);
        return false;
    }
    return true;
}

stock Gordeev_FinishRegSkin(playerid, skin_id)

{

    if(GetPlayerData(playerid, P_ACCOUNT_STATE) != ACCOUNT_STATE_REG_SKIN) return 0;

    SetPlayerData(playerid, P_SKIN, skin_id);

    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    if(mysql_errno())

{

        ShowNotificationNew(playerid, 2, 5, -1, -1, "������ ���������� �����", "");
        return 0;
    }

    new bonus_money = bonuscash;
    new bonus_donate = bonusdon;
    new bonus_lvl = bonuslvl;

    SetPlayerData(playerid, P_MONEY, bonus_money);
    UpdatePlayerDatabaseInt(playerid, "money", bonus_money);

    SetPlayerData(playerid, P_SELECT_SKIN, -1);

    SetPlayerData(playerid, P_DRIVING_LIC, vodprava);
    UpdatePlayerDatabaseInt(playerid, "driving_lic", vodprava);

    if(licoresh == 1)

{

        SetPlayerData(playerid, P_DRIVING_LIC, 3);
        UpdatePlayerDatabaseInt(playerid, "driving_lic", 3);
    }

    SetPlayerData(playerid, P_DONATE_MONEY, bonus_donate);
    UpdatePlayerDatabaseInt(playerid, "donate_current", bonus_donate);

    SetPlayerData(playerid, P_LEVEL, bonus_lvl);
    UpdatePlayerDatabaseInt(playerid, "level", bonus_lvl);

    HidePlayerSelectPanel(playerid);
    HidePlayerSelectPanelPrice(playerid);
    SetPlayerData(playerid, P_SELECT_SKIN, -1);
    SetPlayerData(playerid, P_AUTH_TIME, -1);
    SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_LOGIN);
    SetPlayerLogged(playerid, true);

    Gordeev_CloseAuthGUI(playerid);

    SetPlayerSpawnInit(playerid);
    SpawnPlayer(playerid);
    SetPlayerInit(playerid);
    StartTraining(playerid);
    return 1;
}

stock Gordeev_TryLoginByPassword(playerid, password[])

{

    new hash[65];
    SHA256_PassHash(password, GetPlayerData(playerid, P_SALT), hash, sizeof hash);

    if(strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))

{

        new attemps = GetPlayerData(playerid, P_PASS_ATTEMPS);
        AddPlayerData(playerid, P_PASS_ATTEMPS, -, 1);

        if(attemps <= 0)

{

            ShowNotificationNew(playerid, 2, 5, -1, -1, "����� ������� �����������", "");
            Kick:(playerid);
            return 0;
        }

        new fmt_text[96];
        format(fmt_text, sizeof fmt_text, "�������� ������. �������� �������: %d", attemps);
        ShowNotificationNew(playerid, 2, 5, -1, -1, fmt_text, "");
        return 0;
    }

    // � GUI-������ ������� ������ �������� ���������.
    SetPlayerData(playerid, P_AUTH_TIME, -1);
    Gordeev_CloseAuthGUI(playerid);
    SetPlayerLogged(playerid, true);
    CallLocalFunction("LoadPlayerData", "i", playerid);
    return 1;
}


stock Gordeev_GetVehiclePriceByModel(modelid)

{

    if(modelid < 400 || modelid > 611) return 0;
    return GetVehicleInfo(modelid - 400, VI_PRICE);
}

stock Gordeev_GetBodyPaintCost(price)

{

    return (price / 100) + 10000;
}

stock Gordeev_GetUnivCost(price)

{

    return (price / 100) + 10000 + 40000;
}

stock Gordeev_GetDalniyCost(price)

{

    return (price / 1000) + 10000;
}

stock Gordeev_GetDoubleCost(price)

{

    return ((price / 100) + 10000) * 2;
}

stock Gordeev_GetExtraCost(price)

{

    return (price / 100) + 20000;
}

stock Gordeev_GetDonatCost(price)

{

    return (((price / 100) + 50000) * 3) / 1000;
}

stock bool:GRadialIsFullSetInstalled(mask)

{

    return ((mask & 31) == 31);
}

stock Gordeev_RadialNotify(playerid, text[])

{

    ShowNotificationNew(playerid, 2, 4, -1, -1, text, "");
    return 1;
}

stock Gordeev_RadialSyncVehicleData(vehicleid)

{

    if(!IsValidVehicle(vehicleid)) return 0;

    new high_light = 0,
        stroboscope_type = 0,
        chip_drift = 0,
        chip_comfort = 0,
        chip_sport = 0,
        chip_sportplus = 0,
        has_pneumo = 0,
        has_hydraulics = 0,
        has_launch = 0;

    GordeevRadialLoadVehicleData
    (
        vehicleid,
        high_light,
        stroboscope_type,
        chip_drift,
        chip_comfort,
        chip_sport,
        chip_sportplus,
        has_pneumo,
        has_hydraulics,
        has_launch
    );

    if(vInfo[vehicleid][vHighLights] > 0)

{

        high_light = 1;
    }

    if(vInfo[vehicleid][vLaunchControl] > 0) has_launch = 1;

    g_gordeev_tune_has_launch[vehicleid] = bool:has_launch;

    g_gordeev_tune_drift[vehicleid] = (chip_drift > 0) ? 31 : 0;
    g_gordeev_tune_comfort[vehicleid] = (chip_comfort > 0) ? 31 : 0;
    g_gordeev_tune_sport[vehicleid] = (chip_sport > 0) ? 31 : 0;
    g_gordeev_tune_sportplus[vehicleid] = (chip_sportplus > 0) ? 31 : 0;

    g_gordeev_tune_has_pneumo[vehicleid] = bool:has_pneumo;
    g_gordeev_tune_has_hydraulics[vehicleid] = bool:has_hydraulics;

    if(high_light <= 0)

{

        g_gordeev_radial_high_on[vehicleid] = false;
    }

    if(stroboscope_type >= 1 && stroboscope_type <= 4)

{

        g_gordeev_tune_has_strob[vehicleid] = true;
        g_gordeev_tune_strob_type[vehicleid] = stroboscope_type;
    }
    else

{

        g_gordeev_tune_has_strob[vehicleid] = false;
        g_gordeev_tune_strob_type[vehicleid] = 0;
        g_gordeev_radial_strob_on[vehicleid] = false;
    }

    if(!g_gordeev_tune_has_launch[vehicleid])

{

        g_gordeev_radial_launch_on[vehicleid] = false;
    }

    new current_chip_mode = g_gordeev_radial_chip_mode[vehicleid];
    if(current_chip_mode >= GORDEEV_RADIAL_OP_DRIFT && current_chip_mode <= GORDEEV_RADIAL_OP_SPORTPLUS)

{

        new bool:chip_available = false;
        switch(current_chip_mode)

{

            case GORDEEV_RADIAL_OP_DRIFT: chip_available = GRadialIsFullSetInstalled(g_gordeev_tune_drift[vehicleid]);
            case GORDEEV_RADIAL_OP_COMFORT: chip_available = GRadialIsFullSetInstalled(g_gordeev_tune_comfort[vehicleid]);
            case GORDEEV_RADIAL_OP_SPORT: chip_available = GRadialIsFullSetInstalled(g_gordeev_tune_sport[vehicleid]);
            case GORDEEV_RADIAL_OP_SPORTPLUS: chip_available = GRadialIsFullSetInstalled(g_gordeev_tune_sportplus[vehicleid]);
        }

        if(!chip_available)

{

            g_gordeev_radial_chip_mode[vehicleid] = 0;
        }
    }

    new current_susp_mode = g_gordeev_radial_susp_mode[vehicleid];
    if(current_susp_mode >= GORDEEV_RADIAL_OP_PNEUMO_1 && current_susp_mode <= GORDEEV_RADIAL_OP_HYDRAULICS)

{

        new bool:susp_available = true;
        if(current_susp_mode == GORDEEV_RADIAL_OP_HYDRAULICS) susp_available = g_gordeev_tune_has_hydraulics[vehicleid];
        else susp_available = g_gordeev_tune_has_pneumo[vehicleid];

        if(!susp_available)

{

            g_gordeev_radial_susp_mode[vehicleid] = 0;
        }
    }

    return 1;
}

stock Gordeev_RadialSendState(playerid, type, state_value)

{

    new Node:json_response = JSON_Object();
    JSON_SetInt(json_response, "t", type);
    JSON_SetInt(json_response, "s", state_value);
    OnPacketIncoming(playerid, GUIRadialMenuForCar, json_response);
    JSON_Cleanup(json_response);
    return 1;
}

stock Gordeev_RadialSendTurboReset(playerid)

{

    for(new i2569 = GORDEEV_RADIAL_OP_DRIFT; i2569 <= GORDEEV_RADIAL_OP_SPORTPLUS; i2569++)

{

        Gordeev_RadialSendState(playerid, i2569, 0);
    }
    return 1;
}

stock GRadialSendSuspReset(playerid)

{

    for(new i2582 = GORDEEV_RADIAL_OP_PNEUMO_1; i2582 <= GORDEEV_RADIAL_OP_HYDRAULICS; i2582++)

{

        Gordeev_RadialSendState(playerid, i2582, 0);
    }
    return 1;
}

stock Gordeev_RadialFinalize(playerid, Node:json_radial_data)

{

    OnPacketIncoming(playerid, GUIRadialMenuForCar, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}
stock Gordeev_RadialResolveVehicle(playerid)

{

    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsValidVehicle(vehicleid)) return vehicleid;

    vehicleid = GetPlayerOwnableCar(playerid);
    if(IsValidVehicle(vehicleid))

{

        new Float:x, Float:y, Float:z;
        GetVehiclePos(vehicleid, x, y, z);
        if(IsPlayerInRangeOfPoint(playerid, 8.0, x, y, z)) return vehicleid;
    }

    vehicleid = GetPlayerAllowedCar(playerid);
    if(IsValidVehicle(vehicleid))

{

        new Float:x, Float:y, Float:z;
        GetVehiclePos(vehicleid, x, y, z);
        if(IsPlayerInRangeOfPoint(playerid, 8.0, x, y, z)) return vehicleid;
    }

    return INVALID_VEHICLE_ID;
}

stock bool:Gordeev_RadialEnsureDriver(playerid, vehicleid)

{

    if(GetPlayerVehicleID(playerid) != vehicleid || GetPlayerVehicleSeat(playerid) != 0)

{

        Gordeev_RadialNotify(playerid, "������ �� ���� ����������");
        return false;
    }
    return true;
}

stock Gordeev_RadialPushCurrentState(playerid, vehicleid)

{

    if(!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid)) return 0;

    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_DOORS, (GetVehicleParam(vehicleid, V_LOCK) == VEHICLE_PARAM_ON) ? 1 : 0);
    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_ENGINE, (GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON) ? 1 : 0);
    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_HEADLIGHTS, (GetVehicleParam(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON) ? 1 : 0);
    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_LAUNCH, g_gordeev_radial_launch_on[vehicleid] ? 1 : 0);

    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_NEON, g_gordeev_radial_neon_on[vehicleid] ? 1 : 0);
    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_HIGHLIGHT, g_gordeev_radial_high_on[vehicleid] ? 1 : 0);
    Gordeev_RadialSendState(playerid, GORDEEV_RADIAL_OP_STROBOSCOPE, g_gordeev_radial_strob_on[vehicleid] ? 1 : 0);

    for(new i2658 = GORDEEV_RADIAL_OP_DRIFT; i2658 <= GORDEEV_RADIAL_OP_SPORTPLUS; i2658++)

{

        Gordeev_RadialSendState(playerid, i2658, (g_gordeev_radial_chip_mode[vehicleid] == i2658) ? 1 : 0);
    }

    for(new i2665 = GORDEEV_RADIAL_OP_PNEUMO_1; i2665 <= GORDEEV_RADIAL_OP_HYDRAULICS; i2665++)

{

        Gordeev_RadialSendState(playerid, i2665, (g_gordeev_radial_susp_mode[vehicleid] == i2665) ? 1 : 0);
    }

    return 1;
}

stock Gordeev_OpenVehicleRadial(playerid)

{

    new vehicleid = Gordeev_RadialResolveVehicle(playerid);
    if(!IsValidVehicle(vehicleid))

{

        Gordeev_RadialNotify(playerid, "����� ��� ���������� ����������");
        return 0;
    }

    Gordeev_RadialSyncVehicleData(vehicleid);

    if(vehicleid == GetPlayerOwnableCar(playerid))

{

        if(tune_highlight[playerid] > 0)

{

            vInfo[vehicleid][vHighLights] = 1;
        }

        if(tune_stroboscope[playerid] >= 1 && tune_stroboscope[playerid] <= 4)

{

            g_gordeev_tune_has_strob[vehicleid] = true;
            g_gordeev_tune_strob_type[vehicleid] = tune_stroboscope[playerid];
        }
    }

    new Node:json_data = JSON_Object();
    new Node:state_array = JSON_Array();

    if(GetVehicleParam(vehicleid, V_LOCK) == VEHICLE_PARAM_ON)

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_DOORS));
    }

    if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_ENGINE));
    }

    if(GetVehicleParam(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON)

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_HEADLIGHTS));
    }

    if(g_gordeev_radial_launch_on[vehicleid])

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_LAUNCH));
    }

    if(g_gordeev_radial_chip_mode[vehicleid] >= GORDEEV_RADIAL_OP_DRIFT && g_gordeev_radial_chip_mode[vehicleid] <= GORDEEV_RADIAL_OP_SPORTPLUS)

{

        state_array = JSON_Append(state_array, JSON_Int(g_gordeev_radial_chip_mode[vehicleid]));
    }

    if(g_gordeev_radial_neon_on[vehicleid])

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_NEON));
    }

    if(g_gordeev_radial_high_on[vehicleid])

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_HIGHLIGHT));
    }

    if(g_gordeev_radial_strob_on[vehicleid])

{

        state_array = JSON_Append(state_array, JSON_Int(GORDEEV_RADIAL_OP_STROBOSCOPE));
    }

    if(g_gordeev_radial_susp_mode[vehicleid] >= GORDEEV_RADIAL_OP_PNEUMO_1 && g_gordeev_radial_susp_mode[vehicleid] <= GORDEEV_RADIAL_OP_HYDRAULICS)

{

        state_array = JSON_Append(state_array, JSON_Int(g_gordeev_radial_susp_mode[vehicleid]));
    }

    JSON_SetArray(json_data, "s", state_array);
    ShowPlayerGUINew(playerid, GUIRadialMenuForCar, json_data);
    Gordeev_RadialPushCurrentState(playerid, vehicleid);
    JSON_Cleanup(json_data);
    return 1;
}

stock Gordeev_HandleRadialPacket(playerid, Node:json)

{

    new type = -1;
    JSON_GetInt(json, "t", type);

    if(type == GORDEEV_RADIAL_OP_DISMISS)

{

        return 1;
    }

    new vehicleid = Gordeev_RadialResolveVehicle(playerid);
    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "t", type);
    JSON_SetInt(json_radial_data, "s", 0);

    switch(type)

{

        case GORDEEV_RADIAL_OP_PARKING:

{

            if(!IsValidVehicle(vehicleid) || !Gordeev_RadialEnsureDriver(playerid, vehicleid))

{

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            callcmd::park(playerid, "");
            JSON_SetInt(json_radial_data, "s", 1);
        }
        case GORDEEV_RADIAL_OP_KEY:

{

            if(!IsValidVehicle(vehicleid) || GetPlayerVehicleID(playerid) != vehicleid)

{

                Gordeev_RadialNotify(playerid, "��� ����� ����� ���������� � ����������");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            callcmd::key(playerid, "");

            JSON_SetInt(json_radial_data, "s", 1);
        }
        case GORDEEV_RADIAL_OP_DOORS:

{

            if(!IsValidVehicle(vehicleid))

{

                Gordeev_RadialNotify(playerid, "����� ��� ���������� ����������");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            callcmd::lock(playerid, "");
            JSON_SetInt(json_radial_data, "s", (GetVehicleParam(vehicleid, V_LOCK) == VEHICLE_PARAM_ON) ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_SUSPENSION, GORDEEV_RADIAL_OP_TURBO:

{

            JSON_SetInt(json_radial_data, "s", 1);
        }
        case GORDEEV_RADIAL_OP_LAUNCH:

{

            if(!IsValidVehicle(vehicleid) || !Gordeev_RadialEnsureDriver(playerid, vehicleid))

{

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            new bool:has_launch = (launch[playerid] > 0 || vInfo[vehicleid][vLaunchControl] > 0 || g_gordeev_tune_has_launch[vehicleid]);
            if(!has_launch)

{

                Gordeev_RadialNotify(playerid, "� ���� �� ���������� launch-control");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            g_gordeev_radial_launch_on[vehicleid] = !g_gordeev_radial_launch_on[vehicleid];
            BT_SetLaunchControlTune(vehicleid, g_gordeev_radial_launch_on[vehicleid] ? 1 : 0);
            JSON_SetInt(json_radial_data, "s", g_gordeev_radial_launch_on[vehicleid] ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_ENGINE:

{

            if(!IsValidVehicle(vehicleid) || !Gordeev_RadialEnsureDriver(playerid, vehicleid))

{

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            callcmd::e(playerid, "");
            JSON_SetInt(json_radial_data, "s", (GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON) ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_DRIFT..GORDEEV_RADIAL_OP_SPORTPLUS:

{

            if(!IsValidVehicle(vehicleid) || !Gordeev_RadialEnsureDriver(playerid, vehicleid))

{

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            new bool:has_parts = false;
            new tune_name[24] = "";

            switch(type)

{

                case GORDEEV_RADIAL_OP_DRIFT:

{

                    has_parts = GRadialIsFullSetInstalled(g_gordeev_tune_drift[vehicleid]);
                    format(tune_name, sizeof(tune_name), "DRIFT");
                }
                case GORDEEV_RADIAL_OP_COMFORT:

{

                    has_parts = GRadialIsFullSetInstalled(g_gordeev_tune_comfort[vehicleid]);
                    format(tune_name, sizeof(tune_name), "COMFORT");
                }
                case GORDEEV_RADIAL_OP_SPORT:

{

                    has_parts = GRadialIsFullSetInstalled(g_gordeev_tune_sport[vehicleid]);
                    format(tune_name, sizeof(tune_name), "SPORT");
                }
                case GORDEEV_RADIAL_OP_SPORTPLUS:

{

                    has_parts = GRadialIsFullSetInstalled(g_gordeev_tune_sportplus[vehicleid]);
                    format(tune_name, sizeof(tune_name), "SPORT+");
                }
            }

            if(!has_parts)

{

                new fmt_notify[96];
                format(fmt_notify, sizeof(fmt_notify), "� ���� �� ����������� �������� %s", tune_name);
                Gordeev_RadialNotify(playerid, fmt_notify);
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            if(g_gordeev_radial_chip_mode[vehicleid] == type)

{

                g_gordeev_radial_chip_mode[vehicleid] = 0;
                BT_SetChipTune(vehicleid, GORDEEV_RADIAL_CHIP_DEFAULT);
                SetVehicleAcceleration(vehicleid, 0.0);
                JSON_SetInt(json_radial_data, "s", 0);
            }
            else

{

                Gordeev_RadialSendTurboReset(playerid);

                g_gordeev_radial_chip_mode[vehicleid] = type;
                switch(type)

{

                    case GORDEEV_RADIAL_OP_DRIFT:

{

                        BT_SetChipTune(vehicleid, GORDEEV_RADIAL_CHIP_DRIFT);
                        SetVehicleAcceleration(vehicleid, 0.0);
                    }
                    case GORDEEV_RADIAL_OP_COMFORT:

{

                        BT_SetChipTune(vehicleid, GORDEEV_RADIAL_CHIP_COMFORT);
                        SetVehicleAcceleration(vehicleid, 31.8);
                    }
                    case GORDEEV_RADIAL_OP_SPORT:

{

                        BT_SetChipTune(vehicleid, GORDEEV_RADIAL_CHIP_SPORT);
                        SetVehicleAcceleration(vehicleid, 35.0);
                    }
                    case GORDEEV_RADIAL_OP_SPORTPLUS:

{

                        BT_SetChipTune(vehicleid, GORDEEV_RADIAL_CHIP_SPORTPLUS);
                        SetVehicleAcceleration(vehicleid, 36.0);
                    }
                }

                JSON_SetInt(json_radial_data, "s", 1);
            }
        }
        case GORDEEV_RADIAL_OP_NEON:

        {

            if(!IsValidVehicle(vehicleid))

            {

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            new bool:has_neon = (vInfo[vehicleid][vNeon][0] > 0 || vInfo[vehicleid][vNeon][1] > 0 || vInfo[vehicleid][vNeon][2] > 0);
            if(!has_neon)

            {

                Gordeev_RadialNotify(playerid, "� ���� �� ���������� ����");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            g_gordeev_radial_neon_on[vehicleid] = !g_gordeev_radial_neon_on[vehicleid];

            if(g_gordeev_radial_neon_on[vehicleid])

            {

                BT_SetNeonColor(vehicleid, vInfo[vehicleid][vNeon][0], vInfo[vehicleid][vNeon][1], vInfo[vehicleid][vNeon][2]);
            }
            else

            {

                BT_SetNeonColor(vehicleid, 0, 0, 0);
            }

            JSON_SetInt(json_radial_data, "s", g_gordeev_radial_neon_on[vehicleid] ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_HIGHLIGHT:

{

            if(!IsValidVehicle(vehicleid))

            {

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            new bool:has_highlight = (vInfo[vehicleid][vHighLights] > 0 || g_gordeev_radial_high_on[vehicleid]);
            if(vehicleid == GetPlayerOwnableCar(playerid) && tune_highlight[playerid] > 0)

            {

                has_highlight = true;
            }

            if(!has_highlight)

            {

                Gordeev_RadialNotify(playerid, "� ���� �� ���������� ������� ����");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            g_gordeev_radial_high_on[vehicleid] = !g_gordeev_radial_high_on[vehicleid];
            BT_SetHighLight(vehicleid, g_gordeev_radial_high_on[vehicleid] ? 1 : 0);
            JSON_SetInt(json_radial_data, "s", g_gordeev_radial_high_on[vehicleid] ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_HEADLIGHTS:

        {

            if(!IsValidVehicle(vehicleid) || !Gordeev_RadialEnsureDriver(playerid, vehicleid))

            {

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            callcmd::l(playerid, "");
            JSON_SetInt(json_radial_data, "s", (GetVehicleParam(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON) ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_STROBOSCOPE:

        {

            if(!IsValidVehicle(vehicleid))

            {

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            new bool:has_strob = g_gordeev_tune_has_strob[vehicleid];
            new strob_type = g_gordeev_tune_strob_type[vehicleid];

            if(vehicleid == GetPlayerOwnableCar(playerid) && tune_stroboscope[playerid] >= 1 && tune_stroboscope[playerid] <= 4)

            {

                has_strob = true;
                strob_type = tune_stroboscope[playerid];
            }

            if(!has_strob)

            {

                Gordeev_RadialNotify(playerid, "� ���� �� ���������� ����������");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            g_gordeev_radial_strob_on[vehicleid] = !g_gordeev_radial_strob_on[vehicleid];
            if(strob_type < 1 || strob_type > 4) strob_type = 1;

            if(g_gordeev_radial_strob_on[vehicleid])

            {

                BT_SetStroboscope(vehicleid, strob_type);
            }
            else

            {

                BT_SetStroboscope(vehicleid, 5);
            }

            JSON_SetInt(json_radial_data, "s", g_gordeev_radial_strob_on[vehicleid] ? 1 : 0);
        }
        case GORDEEV_RADIAL_OP_PNEUMO_1..GORDEEV_RADIAL_OP_HYDRAULICS:

        {

            if(!IsValidVehicle(vehicleid) || !Gordeev_RadialEnsureDriver(playerid, vehicleid))

            {

                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            new bool:has_pneumo = g_gordeev_tune_has_pneumo[vehicleid];
            new bool:has_hydraulics = g_gordeev_tune_has_hydraulics[vehicleid];

            if(type == GORDEEV_RADIAL_OP_HYDRAULICS && !has_hydraulics)

            {

                Gordeev_RadialNotify(playerid, "� ���� �� ����������� ������");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            if(type != GORDEEV_RADIAL_OP_HYDRAULICS && !has_pneumo)

            {

                Gordeev_RadialNotify(playerid, "� ���� �� ����������� ����������");
                return Gordeev_RadialFinalize(playerid, json_radial_data);
            }

            if(g_gordeev_radial_susp_mode[vehicleid] == type)

            {

                g_gordeev_radial_susp_mode[vehicleid] = 0;
                BT_SetHydraulics(vehicleid, 0);
                JSON_SetInt(json_radial_data, "s", 0);
            }
            else

{

                new hydra_type = 0;
                GRadialSendSuspReset(playerid);

                switch(type)

{

                    case GORDEEV_RADIAL_OP_PNEUMO_1:

{

                        hydra_type = 1;
                        g_gordeev_tune_has_pneumo[vehicleid] = true;
                        GRadialSaveSuspUnlock(vehicleid, GORDEEV_RADIAL_OP_PNEUMO_1, 1);
                    }
                    case GORDEEV_RADIAL_OP_PNEUMO_2:

{

                        hydra_type = 2;
                        g_gordeev_tune_has_pneumo[vehicleid] = true;
                        GRadialSaveSuspUnlock(vehicleid, GORDEEV_RADIAL_OP_PNEUMO_2, 1);
                    }
                    case GORDEEV_RADIAL_OP_PNEUMO_3:

{

                        hydra_type = 3;
                        g_gordeev_tune_has_pneumo[vehicleid] = true;
                        GRadialSaveSuspUnlock(vehicleid, GORDEEV_RADIAL_OP_PNEUMO_3, 1);
                    }
                    case GORDEEV_RADIAL_OP_HYDRAULICS:

{

                        hydra_type = 4;
                        g_gordeev_tune_has_hydraulics[vehicleid] = true;
                        GRadialSaveSuspUnlock(vehicleid, GORDEEV_RADIAL_OP_HYDRAULICS, 1);
                    }
                }

                g_gordeev_radial_susp_mode[vehicleid] = type;
                BT_SetHydraulics(vehicleid, hydra_type);
                JSON_SetInt(json_radial_data, "s", 1);
            }
        }
    }

    OnPacketIncoming(playerid, GUIRadialMenuForCar, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}
IPacket:252(playerid, BitStream:bitstream)

{

    new header, guiid;
    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length, json_data[256];
    BS_ReadValue(bitstream, PR_UINT32, length);
    if(length <= 0 || length >= sizeof(g_gordeev_gui_incoming))

{

        return 1;
    }

    BS_ReadValue(bitstream, PR_STRING, g_gordeev_gui_incoming, length);
    g_gordeev_gui_incoming[length] = '\0';

    if(guiid == GUIDrivingSchool)
    {
        printf("[DrivingSchool][RawPacket] player=%d len=%d payload=%s", playerid, length, g_gordeev_gui_incoming);
    }

    new Node:json = JSON_Object();
    JSON_Parse(g_gordeev_gui_incoming, json);
    new Node:JSONObject = json;
    switch(guiid)

    {

        // � IPacket:252 ����� ������������ case
case BrNotification:
{
    new notify_id = -1;
    JSON_GetInt(JSONObject, "s", notify_id);
    
    if(notify_id == NOTIFY_RENT_MOPED)
    {
        if(!TryOpenRentBikeNotifyMenu(playerid))
        {
            ShowNotification(playerid, 2, "�������� ����� � ������", 4, "", "");
        }
        JSON_Cleanup(JSONObject);
        return 1;
    }
    
    if(notify_id == NOTIFY_ENGINE)
    {
        callcmd::e(playerid, "");
        JSON_Cleanup(JSONObject);
        return 1;
    }
    
  // ��������� ����������� "������� �����"
    if(notify_id == NOTIFY_EXCHANGE_REQUEST)
    {
        callcmd::_yes_author_welsi_ex(playerid, "");
        JSON_Cleanup(JSONObject);
        return 1;
    }
    if(notify_id == NOTIFY_OPEN_DOORS)
{
    new vehicleid = INVALID_VEHICLE_ID;
    
    // �������� ������� ������
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    
    // ���� ��������� ������ ���� ������ � ������� 5 ������
    new Float:min_distance = 5.0;
    
    for(new vid = 1; vid < MAX_VEHICLES; vid++)
    {
        if(!IsValidVehicle(vid)) continue;
        
        // ���������, ��� ��� ������ ����
        if(GetVehicleData(vid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) continue;
        
        // ��������� ���������
        new index = GetVehicleData(vid, V_ACTION_ID);
        if(index == -1) continue;
        
        if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
        
        // ��������� ����������
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(vid, vx, vy, vz);
        new Float:dist = GetPlayerDistanceFromPoint(playerid, vx, vy, vz);
        
        if(dist < min_distance)
        {
            min_distance = dist;
            vehicleid = vid;
        }
    }
    
    // ���� ����� ���� � ��� ������������� ������
    if(vehicleid != INVALID_VEHICLE_ID)
    {
        // ���������, ��� ����� �������
        if(GetVehicleParam(vehicleid, V_LOCK) == VEHICLE_PARAM_ON)
        {
            // ��������� �����
            SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_OFF);
            
            // ��������� ��������� ��� ���� �������
            SetVehicleParamsEx
            (
                vehicleid,
                GetVehicleParamEx(vehicleid, V_ENGINE),
                GetVehicleParamEx(vehicleid, V_LIGHTS),
                GetVehicleParamEx(vehicleid, V_ALARM),
                VEHICLE_PARAM_OFF, // V_LOCK = 0 (�������)
                GetVehicleParamEx(vehicleid, V_BONNET),
                GetVehicleParamEx(vehicleid, V_BOOT),
                GetVehicleParamEx(vehicleid, V_OBJECTIVE)
            );
            
            // �����������
            ShowNotificationNew(playerid, 3, 5, -1, -1, "����� ���������� �������", "");
        }
        else
        {
            ShowNotificationNew(playerid, 2, 5, -1, -1, "����� ��� �������", "");
        }
    }
    else
    {
        ShowNotificationNew(playerid, 2, 5, -1, -1, "������ ��������� �� ������ ����������", "");
    }
    
    JSON_Cleanup(JSONObject);
    return 1;
}
    
    // ��������� ����������� "������ ���������� �����"
    if(notify_id == NOTIFY_MED_BED)
    {
        new bedid = -1;
        JSON_GetInt(JSONObject, "b", bedid);

        if(bedid < 0 || bedid >= sizeof g_med_bed_pos || g_med_bed_used[bedid] || GetPlayerData(playerid, P_OCCUPIED_BED) != -1 || GetPlayerHealthEx(playerid) >= 75.0 || !IsPlayerInRangeOfPoint(playerid, 2.5, g_med_bed_pos[bedid][0], g_med_bed_pos[bedid][1], g_med_bed_pos[bedid][2]))
        {
            JSON_Cleanup(JSONObject);
            return 1;
        }

        MedBed_SetOccupied(playerid, bedid);

        new fmt_msg[192];
        format(fmt_msg, sizeof fmt_msg, "�� ������ ����� �%d. � ����������� �� ��������� �������� ������� ����� ������ �����", bedid + 1);
        SendClientMessage(playerid, 0x32a44bFF, fmt_msg);

        SendClientMessage(playerid, -1, "����� ���������� ��������� � ����� ��� ������� �� ������� ��������");

        SetTimer("HospitalTreatment", (random(5) + 1) * 1000, false);

        JSON_Cleanup(JSONObject);
        return 1;
    }

    if(notify_id >= NOTIFY_OFFER_HANDSHAKE && notify_id <= NOTIFY_OFFER_JAIL_FREE)
    {
        callcmd::yes(playerid, "");
        JSON_Cleanup(JSONObject);
        return 1;
    }
    
    if(notify_id == NOTIFY_FARMER_INTERACT)
{
    // ���������, ��������� �� ����� ����� � ���
    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1640.030273, 1297.462280, 12.098575))
    {
        // ��������� ������� ������� (1 �������)
        new current_time = GetTickCount();
        if(current_time - g_FarmerDialogCooldown[playerid] < 1000) // 1000 �� = 1 �������
        {
            JSON_Cleanup(JSONObject);
            return 1;
        }
        
        g_FarmerDialogCooldown[playerid] = current_time;
        
        // ��������� ���� �������
        ShowFarmerMainMenu(playerid);
    }
    else
    {
        ShowNotificationNew(playerid, 2, 3, -1, -1, "�� ������ �� ����������!", "");
    }
    
    JSON_Cleanup(JSONObject);
    return 1;
}

    if(notify_id == NOTIFY_ENGINE_START)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid != INVALID_VEHICLE_ID && GetPlayerData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        {
            new index = GetVehicleData(vehicleid, V_ACTION_ID);
            if(index != -1 && GetOwnableCarData(index, OC_OWNER_ID) == GetPlayerAccountID(playerid))
            {
                SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
                ShowNotificationNew(playerid, 3, 5, -1, -1, "��������� �������", "");
            }
        }
        JSON_Cleanup(JSONObject);
        return 1;
    }
}

        case GUIRadialMenuForCar:
        {
            Gordeev_HandleRadialPacket(playerid, json);
            JSON_Cleanup(json);
            return 1;
        }
        case GUIDrivingSchool:
        {
            new result = DrivingSchool_HandleGuiPacket(playerid, json);
            JSON_Cleanup(json);
            return result;
        }
        case 19:
{
            new water = 2, carrefl = 2, drawdist = 75, sky = 1, aa = 1, lowerdd = 0, lowercars = 0;

            if(!JSON_GetInt(json, "w", water)) JSON_GetInt(json, "water", water);
            if(!JSON_GetInt(json, "carrefl", carrefl)) JSON_GetInt(json, "carrefl", carrefl);
            if(!JSON_GetInt(json, "d", drawdist)) JSON_GetInt(json, "drawdist", drawdist);
            if(!JSON_GetInt(json, "s", sky)) JSON_GetInt(json, "sky", sky);
            if(!JSON_GetInt(json, "a", aa)) JSON_GetInt(json, "aa", aa);
            if(!JSON_GetInt(json, "l", lowerdd)) JSON_GetInt(json, "lowerdd", lowerdd);
            if(!JSON_GetInt(json, "z", lowercars)) JSON_GetInt(json, "lowercars", lowercars);

            SetPVarInt(playerid, "gfx_water", water);
            SetPVarInt(playerid, "gfx_reflections", carrefl);
            SetPVarInt(playerid, "gfx_distance", drawdist);
            SetPVarInt(playerid, "gfx_sky", sky);
            SetPVarInt(playerid, "gfx_aa", aa);
            SetPVarInt(playerid, "gfx_lower_dd", lowerdd);
            SetPVarInt(playerid, "gfx_lower_cars", lowercars);

            SavePlayerGraphicSettings(playerid);

            if(sky == 1)
            {
                SetPlayerWeather(playerid, 10);
            }

            SendClientMessage(playerid, -1, "Graphics settings saved!");
            JSON_Cleanup(json);
            return 1;
        }

        case 31:
{
    new type;
    JSON_GetInt(JSONObject, "t", type);
    
    if(type == 0)
    {
        new success;
        JSON_GetInt(JSONObject, "s", success);
        
        if(success == 1)
        {
                if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_MINER_LOAD)
                {
                    return 0;
                } 
                SetPlayerTempJobState(playerid, TEMP_JOB_STATE_NONE);
                ShowTutorialHintGUI(playerid, "������ ���� �� �����,\n��� ���������");   
                ClearAnimations(playerid);
                SetPlayerMinerJobUnLoadCP(playerid);
                SendCreateWayPoint(playerid, 1, 557.1261, 515.9763, 999.7144, 85, 1, 30000.0, 1);
                if(MiningTimer[playerid] != -1)
                {
                KillTimer(MiningTimer[playerid]);
                MiningTimer[playerid] = -1;
                }
        } 
    }
}

case GUIWoundSystem: // case 40:
        {
            new action_code = -1;
            JSON_GetInt(JSONObject, "t", action_code);
            
            switch(action_code)
            {
                case WOUND_ACTION_NEED_HELP: // 1 - "����� ������"
                {
                    // ����������� ������
                    ShowNotificationNew(playerid, 3, 5, -1, -1, "�� ������� �� ������", "");
                    
                    // ��������� ���������
                    new fmt_msg[144];
                    format(fmt_msg, sizeof(fmt_msg), "[SOS] %s[%d] ��������� � ������!", GetPlayerNameEx(playerid), playerid);
                    SendMessageInLocal(playerid, fmt_msg, 0xFF0000FF, 50.0);
                    
                    // ������ ���������� ���������� ������ �� 30 ������ (���������� t=1 �������)
                    SendWoundSystemPacketToClient(playerid, WOUND_ACTION_NEED_HELP);
                }
                case WOUND_ACTION_NEED_HOSPITAL: // 2 - "����� ��������������"
                {
                    // ������������� ������ � ��������
                    TeleportPlayerToHospital(playerid);
                }
                case WOUND_ACTION_NOT_DISPLAY: // 3 - "������ �� ����������"
                {
                    // ����� ������ �� ���������� ������ � ����� ��������� � ��
                    // ���� ������ ��������
                    printf("[WoundSystem] ����� %s[%d] ������ �� ���������� ������", GetPlayerNameEx(playerid), playerid);
                }
                case WOUND_ACTION_DISMISS_INTERFACE: // 4 - ������ ������ ���������
                {
                    // ������ �������� � �������� � ������ �� ������
                }
            }
        }

           	 case 50:
{
    new spawn_id, Float:XposSpawn, Float:YposSpawn, Float:ZposSpawn, 
          Float:AposSpawn, WorldSpawn, IntSpawn, DomSpawn[MAX_PLAYERS] = 4;
    
    printf("[DEBUG] Case 50 triggered for player %d", playerid);
    JSON_GetInt(JSONObject, "t", spawn_id);
    printf("[DEBUG] Player %d spawn_id = %d", playerid, spawn_id);

    switch(spawn_id)
    {
        case 1: // ������
        {
            new spawn_id_int = random(5);
            printf("[DEBUG] Case 1 (������) for player %d, random index = %d", playerid, spawn_id_int);
            
            XposSpawn = spawn_pos_data[spawn_id_int][0];
            YposSpawn = spawn_pos_data[spawn_id_int][1];
            ZposSpawn = spawn_pos_data[spawn_id_int][2];
            AposSpawn = spawn_pos_data[spawn_id_int][3];
            WorldSpawn = 0;
            IntSpawn = 0;
            
            printf("[DEBUG] Spawn position: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f", 
                   XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
        }
        case 0: // �����������
        {
            new team_id = GetPlayerTeamEx(playerid);
            printf("[DEBUG] Case 0 (�����������) for player %d, team_id = %d", playerid, team_id);
            
            XposSpawn = GetTeamData(team_id, O_SPAWN)[0];
            YposSpawn = GetTeamData(team_id, O_SPAWN)[1];
            ZposSpawn = GetTeamData(team_id, O_SPAWN)[2];
            AposSpawn = GetTeamData(team_id, O_SPAWN)[3];
            IntSpawn = GetTeamData(team_id, O_SPAWN_INT);
            WorldSpawn = GetTeamData(team_id, O_SPAWN_VW);
            
            printf("[DEBUG] Team spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f, Int=%d, VW=%d", 
                   XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn);
        }
        case 2: // ��������� �������
        {
            printf("[DEBUG] Case 2 (��������� �������) for player %d", playerid);
            
            XposSpawn = GetPlayerData(playerid, P_LAST_POS_X);
            YposSpawn = GetPlayerData(playerid, P_LAST_POS_Y);
            ZposSpawn = GetPlayerData(playerid, P_LAST_POS_Z);
            AposSpawn = GetPlayerData(playerid, P_LAST_POS_A);
            WorldSpawn = 0;
            IntSpawn = 0;
            
            printf("[DEBUG] Last position: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f", 
                   XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
        }
        case 4: // ���
        {
            new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
            printf("[DEBUG] Case 4 (���) for player %d, house_id = %d", playerid, house_id);
            
            if(house_id == -1)
            {
                printf("[DEBUG] Player %d has no house, using random spawn", playerid);
                new spawn_id_int = random(5);
                XposSpawn = spawn_pos_data[spawn_id_int][0];
                YposSpawn = spawn_pos_data[spawn_id_int][1];
                ZposSpawn = spawn_pos_data[spawn_id_int][2];
                AposSpawn = spawn_pos_data[spawn_id_int][3];
                WorldSpawn = 0;
                IntSpawn = 0;
                
                printf("[DEBUG] Random spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f", 
                       XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
                return 1;
            }
            
            new type = GetHouseData(house_id, H_TYPE);
            printf("[DEBUG] House ID %d, type = %d", house_id, type);
            
            XposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_X);
            YposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Y);
            ZposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Z);
            AposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE);
            IntSpawn = GetHouseTypeInfo(type, HT_INTERIOR);
            WorldSpawn = house_id + 2000;
            DomSpawn[playerid] = 4;
            SetPlayerData(playerid, P_IN_HOUSE, house_id);
            printf("[DEBUG] House spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f, Int=%d, VW=%d (house_id=%d+2000)", 
                   XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn, house_id);
        }
        case 6: // ��� �����
        {
            new fam_id = GetPlayerIdFamily(playerid);
            printf("[DEBUG] Case 6 (��� �����) for player %d, fam_id = %d", playerid, fam_id);
            
            if(fam_id == -1 || family[fam_id][family_house] == -1)
            {
                printf("[DEBUG] Player %d no family (fam_id=%d) or family has no house (family_house=%d)", 
                       playerid, fam_id, (fam_id != -1) ? family[fam_id][family_house] : -1);
                
                new spawn_id_int = random(5);
                XposSpawn = spawn_pos_data[spawn_id_int][0];
                YposSpawn = spawn_pos_data[spawn_id_int][1];
                ZposSpawn = spawn_pos_data[spawn_id_int][2];
                AposSpawn = spawn_pos_data[spawn_id_int][3];
                WorldSpawn = 0;
                IntSpawn = 0;
                
                printf("[DEBUG] Random spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f", 
                       XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
                return 1;
            }
            
            new house_id = GetHouseIndexBySQLID(family[fam_id][family_house]);
            printf("[DEBUG] Family %d, house SQL ID = %d, house index = %d", 
                   fam_id, family[fam_id][family_house], house_id);
            
            new type = GetHouseData(house_id, H_TYPE);
            printf("[DEBUG] Family house ID %d, type = %d", house_id, type);
            
            XposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_X);
            YposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Y);
            ZposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Z);
            AposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE);
            IntSpawn = GetHouseTypeInfo(type, HT_INTERIOR);
            WorldSpawn = house_id + 2000;
            DomSpawn[playerid] = 6;
            SetPlayerData(playerid, P_IN_HOUSE, house_id);
            printf("[DEBUG] Family house spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f, Int=%d, VW=%d (house_id=%d+2000)", 
                   XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn, house_id);
        }
        default:
        {
            printf("[DEBUG] Unknown spawn_id %d for player %d", spawn_id, playerid);
        }
    }

    printf("[DEBUG] Final spawn setup for player %d: Pos(%.2f, %.2f, %.2f, %.2f), Int=%d, VW=%d, DomSpawn=%d", 
           playerid, XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn, DomSpawn[playerid]);

    SetSpawnInfo(playerid, 0, GetPlayerSkinEx(playerid), 
                 XposSpawn, YposSpawn, ZposSpawn, AposSpawn,
                 0, 0, 0, 0, 0, 0);
    
    SetPlayerInterior(playerid, IntSpawn);
    SetPlayerVirtualWorld(playerid, WorldSpawn);
    
    SetPlayerPosEx(playerid, XposSpawn, YposSpawn, ZposSpawn, 
                   AposSpawn, IntSpawn, WorldSpawn);
                   
    if(DomSpawn[playerid] == 4)
    {
        new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
        printf("[DEBUG] Setting player %d in house (type 4), house_id = %d", playerid, house_id);
        SetPlayerData(playerid, P_IN_HOUSE, house_id);
    }
    else if(DomSpawn[playerid] == 6)
    {
        new fam_id = GetPlayerIdFamily(playerid);
        new house_id = GetHouseIndexBySQLID(family[fam_id][family_house]);
        printf("[DEBUG] Setting player %d in family house (type 6), fam_id=%d, house_id=%d", 
               playerid, fam_id, house_id);
        SetPlayerData(playerid, P_IN_HOUSE, house_id);
    }
    
    if(GetPlayerData(playerid, P_WORK_DAY) == 1)
    {
   	SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
    }
    else
    {
   	SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
    }
    
    printf("[DEBUG] Sending response packet to player %d", playerid);
    new Node:json_response = JSON_Object();
    JSON_SetInt(json_response, "c", 1);
    SendPacketToClient(playerid, 50, json_response);
    JSON_Cleanup(json_response);
    
    printf("[DEBUG] Case 50 completed for player %d", playerid);
}
        case 22:
        {
            new type;
            JSON_GetInt(JSONObject, "t", type);

            switch(type)
            {
                case 2:
                {
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return 1;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}� ����������", "������ ������� � ����������.", "�������", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200);
                    UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    new Node:json_packet_data = JSON_Object();
                    JSON_SetInt(json_packet_data, "t", 2);
                    JSON_SetInt(json_packet_data, "p", GetPlayerData(playerid, P_SALE_TIME));
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 22, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                }
                case 0:
                {
                    new price, internal_id;

                    JSON_GetInt(JSONObject, "p", internal_id);
                    JSON_GetInt(JSONObject, "m", price);

                    new result = GetPlayerDonateRub(playerid) - price;

                    if(GetPlayerDonateRub(playerid) < price || result < 0)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 0);
                        JSON_SetInt(json_packet_data, "k", 1);
                        JSON_SetString(json_packet_data, "m", "��� ����� ��� ������� ������\n��������� ������.");
                        JSON_SetString(json_packet_data, "n", "�� ������ ��������� �� � ������� {FFFF00}������.");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    switch(internal_id)
                    {
                        case 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,195,201,202,211,212,213,214,215,216,217,218,219,220,221,222,223,224,275,276,327,328,329,330,331,347,348,349,350,351,352,353,366,367,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484,485,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,522,523,524:                        {
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);
                                JSON_SetString(json_packet_data, "m", "������");
                                JSON_SetString(json_packet_data, "n", "� ��� ������������ ������ ��� ����������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }

                            BuyPlayerCar(playerid, internal_id, FindGameId(internal_id, car_game_ids, sizeof(car_game_ids)), 0);
                            GivePlayerDonateRub(playerid, -price);

                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                            JSON_SetString(json_packet_data, "m", "�� ������� ��������� ����������!");
                            JSON_SetString(json_packet_data, "n", "��� ���� ����� ��������� ����,\n����������� /car");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }
                        case 210,209,344,345,338,339,341,342,343,231,535,536,529,337,527,425,346,333,334,335,340,336,316,317,318,319,320,321,325,326,390,395,396,398,397,232,233,234,235,391,392,393,394,98,99,100,101,332,322,323,324,207,236,237,399,312,230,95,314,528,526,525,519,513,419,430,431,96,97,203,480,481,482,483,488,489,490,491,492,497,313,311,206,93,94,229,516,517,486,487,208,91,92,420,421,514,515,475,205,462,463,457,458,228,315,225,226,227:
                        {
                        new game_id = FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids));
                        
                        // printf("[DEBUG] �������: internal_id=%d, game_id=%d", internal_id, game_id);
                        
                        if(game_id == -1)
                        {
                            SendClientMessage(playerid, -1, "������: �� ������ game_id ��� ����� �����");
                            return 1;
                        }
                        
                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 1);
                        JSON_SetInt(json_packet_data, "g", internal_id);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                        JSON_SetString(json_packet_data, "m", "�� ������� ��������� ������");
                        JSON_SetString(json_packet_data, "n", "��� ���� ����� ����� �, ����������� ��������� (/inv)");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);

                        GivePlayerOwnableSkin(playerid, game_id); // �������� game_id, � �� internal_id
                        GivePlayerDonateRub(playerid, -price);
                    }
                    case 531,534,533,530,532,518,493,494,495,496,476,478,422,423,368,361,362,308,369,370,371,372,277,279,285,287,288,289,290,291,292,293,294,298,299,300,301,302,303,304,305,306,307,309,310,274,253,266,373,374,375,357,358,359,360,363,278,280,295,296,297,281,282,283,284,286,247,248,249,250,251,252,477,479,464,432,433,434,436,437,438,439,440,441,442,443,435,376,377,379,380,381,383,384,385,386,389,354,365,241,242,255,265,355,356,364,264,267,259,260,261:
                    {
                        new modelid = GetModelIdByInternalId(internal_id);
                        
                        if(modelid == -1)
                        {
                            SendClientMessage(playerid, -1, "{FAD201}������:{FFFFFF} �������� ���������.");
                            return 1;
                        }
                        
                        if(GivePlayerOwnableAccessory(playerid, modelid))
                        {
                            GivePlayerDonateRub(playerid, -price);
                            
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                            JSON_SetString(json_packet_data, "m", "�� ������� ��������� ���������!");
                            JSON_SetString(json_packet_data, "n", "��� ���� ����� ����� �, ����������� ��������� (/inv)");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }
                        else
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 0);
                            JSON_SetInt(json_packet_data, "k", -1);
                            JSON_SetString(json_packet_data, "m", "������");
                            JSON_SetString(json_packet_data, "n", "� ��� ��� ���� ���� ���������");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }
                    
                    }
                        case 102:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�� ��������� ������: �������� ���");
                                JSON_SetString(json_packet_data, "n", "���������� � �������:");
                                ShowPlayerChangeNameDialog(playerid);
                                GivePlayerDonateRub(playerid, -50, "����� ����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 103:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "�� ������ ������: ������ ��������������");
                                SetPlayerData(playerid, P_WARN, 0);
                                SetPlayerData(playerid, P_WARN_TIME, 0);
                                UpdatePlayerDatabaseInt(playerid, "warn", 0);
                                UpdatePlayerDatabaseInt(playerid, "warn_time", 0);
                                GivePlayerDonateRub(playerid, -100, "����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 104:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 150)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "�� ������ ������ ��� ��������");
                                SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
                                GivePlayerDonateRub(playerid, -150, "������������ �����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 106:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 75)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "�� ������ ������: ����������");
                                SetPlayerData(playerid, P_HEALTH, 100);
                                SetPlayerHealthEx(playerid, 100);
                                GivePlayerDonateRub(playerid, -75, "��������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 107:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "�������� ��� ����� � �������:");
                              //  buyfamname(playerid);
                                GivePlayerDonateRub(playerid, -100, "����� ����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 108:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "����� ����� ������ ����� ��������");
                                // GivePlayerDonateRub(playerid, -100, "����� ����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                               // obmenfam(playerid);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 109:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 130)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "�� ������ ������ ������� �����");
                                GivePlayerDonateRub(playerid, -130, "����� ��������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 111:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 500)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ ������ ����������");
                             //   SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ���-�������!");
                                GivePlayerDonateRub(playerid, 0, "", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 112:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 1000)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ ������ ����������!");
                                // SendClientMessage(playerid, 0xCECECEFF, "�� ��������� �������-������, ����������� /anymusic");
                                GivePlayerDonateRub(playerid, 0, "1", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 113:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 2500)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ ����������");
                           //     SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ���. ���� ��� ����");
                                GivePlayerDonateRub(playerid, 0, "���. ���� ����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 114:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5000)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ ����������");
                       //         SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ���. ���� ��� ����������");
                                GivePlayerDonateRub(playerid, 0, "���. ���� ����������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 115:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ ����������");
                       //         SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ������������ ������!");
                      //          GivePlayerDonateRub(playerid, -300, "������������ ������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 116:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ � ����������");
                       //         SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ���. ������");
                           //     GivePlayerDonateRub(playerid, -300, "���. ������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 117:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����������");
                                JSON_SetString(json_packet_data, "n", "����������� � ��");
                             //   SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ���. ����");
                        //        GivePlayerDonateRub(playerid, -100, "���. ����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 118:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "�������� ������ �� ����:");
                            //     SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ����� �������");
                                GivePlayerDonateRub(playerid, -50, "����� �������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 119:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "������ ����������");
                         //       SendClientMessage(playerid, 0xCECECEFF, "�� ��������� �������-���");
                              //  GivePlayerDonateRub(playerid, -5, "�������-���", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 120:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "������ ����������");
                                JSON_SetString(json_packet_data, "n", "����� �� ������");
                     //           SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ���. ���� ��� ���� � ������!");
                            //    GivePlayerDonateRub(playerid, -300, "���. ���� ���� � ������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 121:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "����� �� ������");
                                JSON_SetString(json_packet_data, "n", "����������");
                      //          SendClientMessage(playerid, 0xCECECEFF, "�� ��������� ����� ����");
                                //GivePlayerDonateRub(playerid, -50, "����� ����", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 122:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "�������� ��������");
                                JSON_SetString(json_packet_data, "n", "��������� +1 ���� �� ���������");
                                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                           //     new fmt_text[200];
                            //    format(fmt_text, sizeof(fmt_text), "�� ��������� ���� ��� ����������. ���������� ��������� ������: %d", GetPlayerData(playerid, P_CAR_SLOTS));
                     //           SendClientMessage(playerid, 0x66CC00FF, fmt_text);
                                GivePlayerDonateRub(playerid, -100, "���. ���� ����������", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 123:
                        {
                            if(GetPlayerDonateRub(playerid) >= 85)
                            {
                                //callcmd::number(playerid, "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                            }
                        }
                        case 124:
                        {
                            if(GetPlayerDonateRub(playerid) >= 70)
                            {
                                callcmd::buyphonenum(playerid, "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "������������ �������");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                            }
                        }
                        case 179:
                        {
                            BuyPlayerCar(playerid, 12, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "���������", price, internal_id);
                        }
                        case 181:
                        {
                            BuyPlayerCar(playerid, 22, 419, 0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "������", price, internal_id);
                        }
                        case 183:
                        {
                            BuyPlayerCar(playerid, 23, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�������", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 28, 527, 0);
                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "��������", price, internal_id);
                        }
                        case 269:
                        {
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "��������", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoneyEx(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�������", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoneyEx(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�� �������", price, internal_id);
                        }
                        case 178:
                        {
                            GivePlayerMoneyEx(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "����������", price, internal_id);
                        }
                    }
                }
            }
        }
    

        case GUIRegistration:
          {
            new t;
            JSON_GetInt(json, "t", t);
            switch(t)
          {
               case -1:
                {
                    new skin_id;
                    JSON_GetInt(json, "i", skin_id);
                    SetPlayerSkin(playerid, skin_id);

                    JSON_Cleanup(json);
                    return 1;
                }
                case 1:
                {
                    new email[128], password[24];
                    JSON_GetString(json, "s", email);
                    JSON_GetString(json, "p", password);

                    if(!Gordeev_ValidateRegPassword(playerid, password))
                    {
                        JSON_Cleanup(json);
                        return 1;
                    }
                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);

                    if(strlen(email) != 0)
                    {
                        strmid(GetPlayerData(playerid, P_EMAIL), email, 0, strlen(email), 65);
                    }
                    Gordeev_GuiAck(playerid);
                    JSON_Cleanup(json);
                    return 1;
                }
                case 3:
                {
                    new gender;
                    JSON_GetInt(json, "r", gender);
                    SetPlayerData(playerid, P_SEX, gender);
                    if(CreatePlayerAccount(playerid))
                    {

                        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);
                        SetSpawnInfo(playerid, 0, 0, 332.2033, -174.1066, 999.6743, 1.0, 0, 0, 0, 0, 0, 0);
                        SpawnPlayer(playerid);
                        Gordeev_GuiAck(playerid);
                    }
                    else
                    {

                        ShowNotificationNew(playerid, 2, 5, -1, -1, "������ ��� �������� ��������, ���������� �����!", "");
                        JSON_Cleanup(json);
                        return 1;
                    }
                    JSON_Cleanup(json);
                    return 1;
                }
                case 4:
                {
                    new invite_nick[MAX_PLAYER_NAME];
                    JSON_GetString(json, "s", invite_nick);
                    if(strlen(invite_nick) == 0)
                    {

                        Gordeev_GuiAck(playerid);
                        JSON_Cleanup(json);
                        return 1;
                    }
                    new query[75], Cache:result;
                    mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
                    result = mysql_query(mysql, query);

                    if(cache_num_rows())

                    {
                        SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
                    }
                    cache_delete(result);
                    if(!GetPlayerData(playerid, P_REFER))
                    {

                        ShowNotificationNew(playerid, 2, 5, -1, -1, "������ ������ �� ����������!", "");
                        JSON_Cleanup(json);
                        return 1;
                    }
                    Gordeev_GuiAck(playerid);
                    JSON_Cleanup(json);
                    return 1;
                }
                case 5:
                {

                    new final_skin;
                    JSON_GetInt(json, "r", final_skin);

                    Gordeev_FinishRegSkin(playerid, final_skin);
                    JSON_Cleanup(json);
                    return 1;
                }
                case 6:
                {

                    new password[24], hash[65], auto_login;

                    JSON_GetString(json, "s", password);
                    JSON_GetInt(json, "r", auto_login);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);
                    SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

                    if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))

                    {

                        SetPlayerData(playerid, P_AUTH_TIME, -1);
                        Gordeev_CloseAuthGUI(playerid);
                        SetPlayerLogged(playerid, true);
                        LoadPlayerData(playerid);

                    }
                    else

                    {

                        ShowNotificationNew(playerid, 2, 5, -1, -1, "�������� ������!", "");
                    }

                    JSON_Cleanup(json);
                    return 1;
                }
            }
        }
    }
    JSON_Cleanup(json);
    return 1;
}


public FindGameId(internalId, array[][], array_size)
{
    for(new i = 0; i < array_size; i++)
    {
        if(array[i][0] == internalId)
        {
            return array[i][1];
        }
    }
    return -1;
}

public BuyPlayerCar(playerid, internal_id, game_id, color)
{
    if(game_id == -1)
    {
        return 1;
    }

    new free_car_id = GetFreeOwnableCarID();
    new Float:pos_x = 2498.205810;
    new Float:pos_y = -742.256042;
    new Float:pos_z = 12.164166;
    new Float:angle = 356.240051;

    SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(free_car_id, OC_MODEL_ID, game_id);
    SetOwnableCarData(free_car_id, OC_COLOR_1, color);
    SetOwnableCarData(free_car_id, OC_COLOR_2, 0);
    SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
    SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
    SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
    SetOwnableCarData(free_car_id, OC_ANGLE, angle);

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "regerds_test_number", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());

    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new database_query[256];
    format(database_query, sizeof(database_query), "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
        GetPlayerAccountID(playerid), game_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
}

// public BuyPlayerSkin(playerid, internal_id, game_id)
// {
//     //SetPlayerData(playerid, P_SKIN, game_id); // Сохраняем в данные игрока
//     SetPlayerSkin(playerid, game_id); // Надеваем скин на клиента

//     // Сохраняем скин в базу данных
//     new query[256];
//     format(query, sizeof query, "UPDATE accounts SET skin = %d WHERE id = %d", game_id, GetPlayerAccountID(playerid));
//     mysql_query(mysql, query, false);
// }

public ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), json_data[512];
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Покупка набора");
    JSON_SetString(json_packet_data, "n", pack_name);
    JSON_Stringify(json_packet_data, json_data);
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}


stock bool:GetDonateVipByInternalId(internal_id, &vip_level, &vip_days, vip_name[], vip_name_size = 32)
{
    vip_level = 0;
    vip_days = 0;
    vip_name[0] = '\0';

    switch(internal_id)
    {
        case 128, 184: vip_level = 1, vip_days = 3;
        case 129: vip_level = 1, vip_days = 7;
        case 130: vip_level = 1, vip_days = 15;
        case 131: vip_level = 1, vip_days = 30;
        case 132, 190: vip_level = 2, vip_days = 3;
        case 133: vip_level = 2, vip_days = 7;
        case 134: vip_level = 2, vip_days = 15;
        case 135: vip_level = 2, vip_days = 30;
        case 136, 192: vip_level = 3, vip_days = 3;
        case 137: vip_level = 3, vip_days = 7;
        case 138: vip_level = 3, vip_days = 15;
        case 139: vip_level = 3, vip_days = 30;
        case 186: vip_level = 1, vip_days = 2;
        case 188: vip_level = 1, vip_days = 3;
        default: return false;
    }

    switch(vip_level)
    {
        case 1: format(vip_name, vip_name_size, "VIP Silver");
        case 2: format(vip_name, vip_name_size, "VIP Gold");
        case 3: format(vip_name, vip_name_size, "VIP Platinum");
        default: format(vip_name, vip_name_size, "VIP");
    }

    return true;
}

stock GivePlayerDonateVip(playerid, vip_level, vip_days)
{
    new current_time = gettime();
    new old_premium_date = GetPlayerData(playerid, P_PREMIUM_DATE);
    new premium_date = old_premium_date;
    new premium_level = GetPlayerPremium(playerid);
    new final_level = vip_level;

    if(old_premium_date > current_time && premium_level > final_level)
    {
        final_level = premium_level;
    }

    if(premium_date < current_time)
    {
        premium_date = current_time;
    }

    premium_date += vip_days * 86400;

    SetPlayerData(playerid, P_PREMIUM, final_level);
    SetPlayerData(playerid, P_VIP_STATUS, final_level);
    SetPlayerData(playerid, P_PREMIUM_DATE, premium_date);

    UpdatePlayerDatabaseInt(playerid, "premium", final_level);
    UpdatePlayerDatabaseInt(playerid, "premium_date", premium_date);
}

stock ShowSuccesfullBuyVip(playerid, internal_id, vip_name[], vip_days)
{
    new Node:JSONObject = JSON_Object(), json_data[512];
    new premium_day, premium_month, premium_year;
    new message[128];

    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), premium_year, premium_month, premium_day);

    format(message, sizeof(message), "%s �� %d ��. �� %02d.%02d.%d", vip_name, vip_days, premium_day, premium_month, premium_year);

    JSON_SetInt(JSONObject, "t", 0);
    JSON_SetInt(JSONObject, "y", 1);
    JSON_SetInt(JSONObject, "g", internal_id);
    JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(JSONObject, "m", "������� ���������");
    JSON_SetString(JSONObject, "n", message);
    JSON_Stringify(JSONObject, json_data);
    SendPacketToClient(playerid, 22, JSONObject);
    JSON_Cleanup(JSONObject);
}

// CMD:testuved(playerid)
// {
//  ShowNotificationLaird(playerid, OFFER_ENGINE, 6, 0, 0, "Взаимодействие", "");
//  return 1;
// } 
// public BuyPlayerSkin(playerid, internal_id, game_id)
// {
//     GivePlayerOwnableSkin(playerid, game_id);
// }
public BuyPlayerSkin(playerid, internal_id, game_id)
{
    GivePlayerOwnableSkin(playerid, game_id);
}

stock GetModelIdByInternalId(internal_id)
{
    for(new i = 0; i < sizeof(accessories_game_ids); i++)
    {
        if(accessories_game_ids[i][0] == internal_id)
        {
            return accessories_game_ids[i][1]; // Возвращаем modelId
        }
    }
    return -1;
}


stock ShowWoundSystemGUI(playerid, killerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    // �������� ������� ������
    new killer_name[MAX_PLAYER_NAME];
    if(killerid != INVALID_PLAYER_ID && IsPlayerConnected(killerid))
    {
        GetPlayerName(killerid, killer_name, sizeof(killer_name));
    }
    else
    {
        killer_name = "�����������";
    }
    
    // ���������� ���� �������� � ��������
    g_wound_sent_to_hospital[playerid] = false;
    
    // ��������� ��������� JSON (��� � ������������: "p" = ���, "id" = ID, "h" = ���� ������� �������)
    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);                                          // ������� GUI
    JSON_SetInt(json, "g", 0);                                          // ������
    JSON_SetString(json, "p", killer_name, strlen(killer_name));        // ������� ������
    JSON_SetInt(json, "id", killerid);                                  // ID ������
    JSON_SetInt(json, "h", 0);                                          // ���������� ������ � �����������
    
    // ���������� �������
    SendPacketToClient(playerid, GUIWoundSystem, json);
    JSON_Cleanup(json);
    
    return 1;
}
stock SendWoundSystemPacketToClient(playerid, action_code)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", action_code);
    
    SendPacketToClient(playerid, GUIWoundSystem, json);
    JSON_Cleanup(json);
    
    return 1;
}
