main();

#pragma dynamic 65500
#pragma warning disable 239
#pragma warning disable 202
#pragma warning disable 203
#pragma warning disable 213
#pragma warning disable 234
#pragma warning disable 216
#pragma warning disable 219
#pragma warning disable 209
#pragma warning disable 202
#pragma warning disable 201
#pragma warning disable 225
#pragma warning disable 200
#pragma warning disable 211
#pragma warning disable 204
#pragma warning disable 201
#pragma warning disable 208
#pragma warning disable 215
#pragma warning disable 235
#pragma warning disable 217
#pragma warning disable 212
#pragma warning disable 228
#pragma warning disable 205

#include <a_samp>

#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS (150)

#include <a_http>
#include <PawnPlus>
#include <mxINI>
#include "../include/a_mysql.inc"
#include "../include/Pawn.CMD.inc"
#include "../include/Pawn.RakNet.inc"
#include "../include/streamer.inc"
#include "../include/sscanf2.inc"
#include "../include/foreach.inc"
#include "../include/lib/m_crzones.inc"
#include "../include/lib/m_dialog.inc"
#include "../include/mxdate.inc"
#include "../include/fdialog.inc"
#include "../include/fly.inc"
#include "../include/json.inc"

new vWheelAlignmentFront[MAX_VEHICLES], vWheelAlignmentRear[MAX_VEHICLES];
new vWheelDepartureFront[MAX_VEHICLES], vWheelDepartureRear[MAX_VEHICLES];
new vPneumoBought[MAX_VEHICLES], vPneumoMode[MAX_VEHICLES];
stock SendPacketToClient(playerid, guiid, Node:json);
#include "../include/system/cp.pwn"
#include "../include/system/cp_race.pwn"
#include "../include/system/pickup.pwn"
#include "../include/system/vehicle.pwn"
#include "../gamemodes/sile/vehicle_names_map.inc"
#include "../gamemodes/sile/vehicle_prices_map.inc"
#include "../gamemodes/sile/vehicle_handling_map.inc"
#include <voicechat>
#include <pawnraknet>

#define OC_VEHICLE_ID   0
new bool:agmtestActive[MAX_PLAYERS];
#define VEHICLE_START_ENGINE 100
new g_HandshakeOffer[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
#define DIALOG_CAR_SELECT 9877
#define DIALOG_SKINDON_SELECT 9876
#define DIALOG_TAXI_SPAWN 55201
#define DIALOG_LICENSE_B 9865
#define DIALOG_LICENSE_B_DONE 9864
#define DIALOG_WEDDING_MENU 58231
#define DIALOG_WEDDING_INFO 58232
#define DIALOG_WEDDING_RINGS 58233

//BlackJack start
#define MAX_BJ_LOBBY 6

#define		DSI		DIALOG_STYLE_INPUT
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define 	DSP		DIALOG_STYLE_PASSWORD
#define 	DST		DIALOG_STYLE_TABLIST
//------------------------------------------------------------------------------
#define CWHITE 		0xFFFFFFFF
#define CRED 		0xFF0000FF
#define CCYAN 		0x0000FFFF
#define CPINK 		0xFF00FFFF
#define CBLUE 		0x00FFFFFF
#define CYELLOW 	0xFFFF00FF
#define CGREY 		0x7F7F7FFF
#define CGREEN   	0x00FF00FF
#define CORANGE 	0xFF8000FF
#define CGOLD		0xFFD700FF
#define CDSB		0x00BFFFFF
#define CPURPLE     0xF7619300
#define CLRED    	0xFF3030FF

//------------------------------���� �����--------------------------------------

#define cRR         0x3CB371FF
#define cFF         0x6495EDFF

//______________________________________________________________________________
//------------------------------------------------------------------------------
#define CW          "{FFFFFF}"
#define CR          "{FF0000}"
#define CBB         "{0000FF}"
#define CP          "{FF00FF}"
#define CB          "{00FFFF}"
#define CY          "{FFFF00}"
#define CGRY		"{7F7F7F}"
#define CG	        "{00FF00}"
#define CO          "{FF8000}"
#define CGLD		"{FFD700}"
//------------------------------------------------------------------------------
#define CDG         "{006400}"
#define CDO         "{FF8C00}"
#define CLR         "{FF3030}"
#define cBi			"{3399FF}"

new Text:bj_fon;

new Text:bj_double;
new Text:bj_stop;
new Text:bj_play;
new Text:bj_take;
new Text:bj_exit;
new Text:bj_dealer_score;
new Text:bj_help;

new Text:bj_log_text[MAX_BJ_LOBBY+1][2];
new Text:bj_table_ready[MAX_BJ_LOBBY+1][5];

new Text:bj_text_bet[2];
new Text:bj_text_start_time;
new Text:bj_text_start_timer[MAX_BJ_LOBBY+1];

new Text:bj_text_bj_table[MAX_BJ_LOBBY+1][4];
new Text:bj_text_point_table[MAX_BJ_LOBBY+1][4];

new Text:bj_dealer_card[MAX_BJ_LOBBY+1][4];
new Text:bj_result_table[MAX_BJ_LOBBY+1][4];
//new Text:bj_
new const WelcomeMessages[][128] =
{
    "����� ���������� �� {FFFF00}SIMPLE RUSSIA,{FFFFFF} - ������ {008ECC}KAZAN!",
    "������� �� ��������� � ��������� � ����� ��������� ������ {FFFF00}t.me/simpleonline",
    "������ ������������ ���� ��� �� �������� ����� �� ���������� ������� � �����������!",
    "��� ��������� ������� ����� �������� � ��� ������ ��������� ���� ����� - {FFFF00}#����",
    "����������� ������� {FFFF00}/quest {FFFFFF}��� ���������� �������!",
    "�� ���������� ������� �� �������� {FFFF00}������,{FFFF00}BC,{FFFFFF}� ����� {FFFF00}����������� ����"
};

forward OnLogsFetched(playerid, page);


new PlayerText:bj_bet[MAX_PLAYERS]; //������
new PlayerText:bj_money[MAX_PLAYERS]; //������ ������

new PlayerText:bj_dealer_point[MAX_PLAYERS];

new PlayerText:bj_members_name[MAX_PLAYERS][4]; //���� ����������

new PlayerText:bj_card_table[MAX_PLAYERS][5][4]; //����� ������ �����

new PlayerText:bj_panel_info[MAX_PLAYERS];


#define MAX_DPS_POSTS 10

enum e_dps_post
{
    Float:DPS_X,
    Float:DPS_Y,
    Float:DPS_Z,
    DPS_AREA_ID
}
new DPSPosts[MAX_DPS_POSTS][e_dps_post];
new TotalDPSPosts = 0;

new Text3D: BlackJackText[MAX_BJ_LOBBY+1];

new Float:BlackJackPos[MAX_BJ_LOBBY+1][3] =
{
	{0.0,0.0,0.0},
	{2508.173583,2464.578857,2499.664062},
	{2512.847412,2461.920166,2499.664062},
	{2509.147949,2455.435302,2499.664062},
	{2514.589843,2455.347167,2499.664062},
	{2512.984375,2448.713623,2499.664062},
	{2508.083984,2445.854980,2499.664062}
};

enum BJ_Card_struct
{
	Pointscore,
	Cardtexture[32]
}

new BlackJackCard[13][4][BJ_Card_struct] =
{
	{{2, "txd:cards2c"}, {2, "txd:cards2d"}, {2, "txd:cards2h"}, {2, "txd:cards2s"}}, //������
	{{3, "txd:cards3c"}, {3, "txd:cards3d"}, {3, "txd:cards3h"}, {3, "txd:cards3s"}}, //������
	{{4, "txd:cards4c"}, {4, "txd:cards4d"}, {4, "txd:cards4h"}, {4, "txd:cards4s"}}, //��������
	{{5, "txd:cards5c"}, {5, "txd:cards5d"}, {5, "txd:cards5h"}, {5, "txd:cards5s"}}, //�������
	{{6, "txd:cards6c"}, {6, "txd:cards6d"}, {6, "txd:cards6h"}, {6, "txd:cards6s"}}, //��������
	{{7, "txd:cards7c"}, {7, "txd:cards7d"}, {7, "txd:cards7h"}, {7, "txd:cards7s"}}, //�������
	{{8, "txd:cards8c"}, {8, "txd:cards8d"}, {8, "txd:cards8h"}, {8, "txd:cards8s"}}, //���������
	{{9, "txd:cards9c"}, {9, "txd:cards9d"}, {9, "txd:cards9h"}, {9, "txd:cards9s"}}, //�������
	{{10, "txd:cards10c"}, {10, "txd:cards10d"}, {10, "txd:cards10h"}, {10, "txd:cards10s"}}, //�������

	{{10, "txd:cardsjc"}, {10, "txd:cardsjd"}, {10, "txd:cardsjh"}, {10, "txd:cardsjs"}}, //�����
	{{10, "txd:cardsqc"}, {10, "txd:cardsqd"}, {10, "txd:cardsqh"}, {10, "txd:cardsqs"}}, //����
	{{10, "txd:cardskc"}, {10, "txd:cardskd"}, {10, "txd:cardskh"}, {10, "txd:cardsks"}}, //������
	{{11, "txd:cardsac"}, {11, "txd:cardsad"}, {11, "txd:cardsah"}, {11, "txd:cardsas"}}  //���
};


enum BJ_Lobby
{
	bool:ActivedLobby,
	bool:StartedLobby,
	StartTimer,
	StageLobby,
	DealerPoint,

	DealerTurnGived,
	TableTurn,
	TableTurnTime,

	Table1Id,
	Table2Id,
	Table3Id,
	Table4Id,

	Table1Point,
	Table2Point,
	Table3Point,
	Table4Point,

	Table1Result,
	Table2Result,
	Table3Result,
	Table4Result,
}
new BlackJackLobby[MAX_BJ_LOBBY+1][BJ_Lobby];

enum P_BJ_Info
{
	bool:OnLobby,
	pBJLobby,
	pBJTable,
	pBJBet,

	pBJTakedCard,
}
new pBJInfo[MAX_PLAYERS][P_BJ_Info];
//blackjack end
new TuningGUITimer[MAX_PLAYERS];

#define DIALOG_NEON 6789

#define DIALOG_TUNING_MAIN 1000
#define DIALOG_TINT 1001
#define DIALOG_VINYL 1002
#define DIALOG_SUSPENSION_BIAS 1003
#define DIALOG_WHEEL_RADIUS 1004
#define DIALOG_CAMBER 1006
#define DIALOG_WHEEL_OFFSET 1007
#define DIALOG_WHEEL_WIDTH 1008
#define DIALOG_STROBOSCOPE 1010
#define DIALOG_HYDRAULICS 1011
#define DIALOG_LAUNCH_CONTROL 1012
#define DIALOG_EXHAUST 1013
#define DIALOG_SIREN_TOGGLE 1015
#define DIALOG_DRIFT 1016
#define DIALOG_NUMBER_PLATE 1017
#define DIALOG_HORN_SOUND 1018

#define DIALOG_MEDCARD 1106

new GZCheckTimerId = -1;

#define MAX_RENT_ZONES 100
#define MAX_PARKING_PER_ZONE 5
new FamilyAreaID;

new PlayerText:money_PTD[MAX_PLAYERS][2];
new UpdateZp[MAX_PLAYERS];
new ChekUpdateddd[MAX_PLAYERS];
new PlayerZP[MAX_PLAYERS];

new NumberAreaID;


static bool:player_unlock_notif_shown[MAX_PLAYERS];

new bool: g_WhitelistEnabled = false;
new g_WhitelistCount = 0;
new g_WhitelistNames[MAX_PLAYER_NAME][MAX_PLAYERS];
new g_WhitelistFile[64] = "whitelist.ini";

forward LoadWhitelist();
forward SaveWhitelist();
forward IsPlayerInWhitelist(playerid);
forward ShowWhitelistDialog(playerid);

new playerautosalon[MAX_PLAYERS];
new bool:playertestdrive[MAX_PLAYERS];
new vehicletestdrive[MAX_PLAYERS];
new worldplayertestdrive[MAX_PLAYERS];
new openguiplates[MAX_PLAYERS];
new restart_timer = -1;
new restart_countdown = 0;
new bool:restart_active = false;

new MiningTimer[MAX_PLAYERS];
new DeliveryTimerOrder[MAX_PLAYERS];
new DeliveryTimerMoney[MAX_PLAYERS];

#define MAX_CONT 12
#define CLR_RED 0xFF0000FF
#define CLR_GREEN 0x00FF00FF
#define CLR_YELLOW 0xFFFF00FF
#define CLR_WHITE 0xFFFFFFFF
#define DIALOG_CONT_BET 19996

enum PrizeInfo
{
    PRIZE_REGION,
    PRIZE_ID,
    PRIZE_NAME[64],
    PRIZE_PRICE,
};

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
new cInfo[MAX_CONT + 1][Cont_Info];

enum P_Info
{
    BetUseCont,
    BuyUseCont,
}
new pInfo[MAX_PLAYERS][P_Info];
new Text3D:ContsText[MAX_CONT + 1];
new ContsZone[MAX_CONT + 1];
new ContsTimer[MAX_CONT + 1];

new contstartact;

new Text:cont_fon;
new Text:cont_take;
new Text:cont_sell;
new Text:cont_close;
new Text:cont_name[MAX_CONT + 1];
new Text:cont_price[MAX_CONT + 1];
new Text:cont_model[MAX_CONT + 1];
new bool:g_cont_reward_processing[MAX_PLAYERS];

enum RegionPrizes {
    REGION_RUSSIA = 1,
    REGION_CHINA,
    REGION_DUBAI,
    REGION_GERMANY
};
new const cSkin_Info[][PrizeInfo] = {
    {REGION_RUSSIA, 152, "������", 236000},
    {REGION_RUSSIA, 240, "������", 90000},
    {REGION_RUSSIA, 182, "������", 175000},
    {REGION_RUSSIA, 85, "������", 36000},
    {REGION_RUSSIA, 7, "������", 45000},
    {REGION_RUSSIA, 91, "������", 38610},
    {REGION_RUSSIA, 56, "������", 105300},
    {REGION_RUSSIA, 129, "������", 1000000},
    {REGION_RUSSIA, 75, "������", 500000},
    {REGION_RUSSIA, 66, "������", 133333},
    {REGION_RUSSIA, 45, "������", 80000},
    {REGION_RUSSIA, 78, "������", 50000},

    {REGION_DUBAI, 300, "������", 1000000},
    {REGION_DUBAI, 211, "������", 5000000},
    {REGION_DUBAI, 99, "������", 3500000},
    {REGION_DUBAI, 102, "������", 600000},
    {REGION_DUBAI, 125, "������", 1000000},
    {REGION_DUBAI, 101, "������", 3850000}
};
new const cCar_Info[][PrizeInfo] = {
    {REGION_RUSSIA, 404, "VAZ 2107", 50000},
    {REGION_RUSSIA, 555, "ZAZ 968", 20000},
    {REGION_RUSSIA, 401, "VAZ 2101", 42000},
    {REGION_RUSSIA, 401, "Lada Granta", 320000},
    {REGION_RUSSIA, 413, "Gazelle 3221", 1500000},

    {REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {REGION_CHINA, 523, "Yamaha FZ-10", 3905000},
    {REGION_CHINA, 522, "Kawasaki Ninja H2R", 3500000},
    {REGION_CHINA, 526, "Infiniti Q60S", 1700000},
    {REGION_CHINA, 603, "Ford Mustang GT", 1500000},
    {REGION_CHINA, 562, "Nissan Skyline R34", 500000},
    {REGION_CHINA, 502, "Nissan GT-R R35", 7110000},
    {REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {REGION_CHINA, 445, "Acura TSX", 1035000},
    {REGION_CHINA, 527, "BMW M3 E46", 945000},

    {REGION_DUBAI, 494, "BMW I8 EDrive", 11850000},
    {REGION_DUBAI, 2549, "Lamborghini Huracan", 14850000},
    {REGION_DUBAI, 2551, "Lamborghini Urus", 13770000},
    {REGION_DUBAI, 400, "BMW X6M F16", 7740000},
    {REGION_DUBAI, 505, "Cadillac Escalade", 6480000},
    {REGION_DUBAI, 475, "Audi Q7", 5400000},
    {REGION_DUBAI, 466, "BMW M5 F90", 8910000},
    {REGION_DUBAI, 502, "Nissan GT-R R35", 7110000},
    {REGION_DUBAI, 604, "Porsche Panamera S", 8100000},
    {REGION_DUBAI, 480, "BMW Z4 M40i", 4410000},
    {REGION_DUBAI, 470, "��� ����", 30000000},
    {REGION_DUBAI, 500, "��� 69", 30000000},
    {REGION_DUBAI, 596, "BMW M5 F90 (���)", 30000000},
    {REGION_DUBAI, 490, "Range Rover SVR", 9000000},
    {REGION_DUBAI, 429, "Mercedes-Benz GT-R", 12150000},

    {REGION_GERMANY, 461, "Ducati SuperSport S", 1647000},
    {REGION_GERMANY, 445, "Acura TSX", 1035000},
    {REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {REGION_GERMANY, 523, "Yamaha FZ-10", 3905000},
    {REGION_GERMANY, 400, "BMW X6M F16", 7740000},
    {REGION_GERMANY, 402, "Mercedes Benz GT63s", 6320000},
    {REGION_GERMANY, 480, "BMW Z4 M40i", 4410000},
    {REGION_GERMANY, 445, "Acura TSX", 1035000},
    {REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {REGION_GERMANY, 565, "Mercedes-Benz A45 AMG", 2200000},
    {REGION_GERMANY, 445, "Acura TSX", 1035000},
    {REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {REGION_GERMANY, 415, "Lamborghini Aventador S", 10000000}
};
enum RegionInfo
{
    RegionName[15],
    ClothesPrice,
    VehiclePrice,
    ContModelId,
    VorotaModelId,
};
new const g_RegionData[5][RegionInfo] =
{
    {"", 0, 0},
    {"������", 100000, 200000, 934, 933},
    {"�����", 900000, 2000000, 954, 953},
    {"�����", 4350000, 9000000, 956, 955},
    {"��������", 900000, 2000000, 958, 957}
};
new Float: cContsPos[12][12] =
{
    {655.80, 1740.00, 12.79000, 0.0,   650.40, 1738.10, 10.94, 0.0,   650.50, 1741.93, 10.94, 180.0},
    {655.80, 1732.00, 12.79000, 0.0,   650.40, 1730.10, 10.94, 0.0,   650.50, 1733.93, 10.94, 180.0},
    {655.80, 1724.00, 12.79000, 0.0,   650.40, 1722.10, 10.94, 0.0,   650.50, 1725.93, 10.94, 180.0},
    {655.80, 1716.00, 12.79000, 0.0,   650.40, 1714.10, 10.94, 0.0,   650.50, 1717.93, 10.94, 180.0},
    {655.80, 1708.00, 12.79000, 0.0,   650.40, 1706.10, 10.94, 0.0,   650.50, 1709.93, 10.94, 180.0},
    {655.80, 1700.00, 12.79000, 0.0,   650.40, 1698.10, 10.94, 0.0,   650.50, 1701.93, 10.94, 180.0},
    {655.80, 1692.00, 12.79000, 0.0,   650.40, 1690.10, 10.94, 0.0,   650.50, 1693.93, 10.94, 180.0},
    {655.80, 1684.00, 12.79000, 0.0,   650.40, 1682.10, 10.94, 0.0,   650.50, 1685.93, 10.94, 180.0},
    {655.80, 1676.00, 12.79000, 0.0,   650.40, 1674.10, 10.94, 0.0,   650.50, 1677.93, 10.94, 180.0},
    {655.80, 1668.00, 12.79000, 0.0,   650.40, 1666.10, 10.94, 0.0,   650.50, 1669.93, 10.94, 180.0},
    {655.80, 1660.00, 12.79000, 0.0,   650.40, 1658.10, 10.94, 0.0,   650.50, 1661.93, 10.94, 180.0},
    {630.90, 1705.00, 12.79000, 180.0, 625.45, 1703.10, 10.94, 180.0, 625.55, 1706.93, 10.94, 0.0}
};

new Float: ContBuyTextPos[12][3] =
{
    {648.80, 1740.00, 12.79000},
    {648.80, 1732.00, 12.79000},
    {648.80, 1724.00, 12.79000},
    {648.80, 1716.00, 12.79000},
    {648.80, 1708.00, 12.79000},
    {648.80, 1700.00, 12.79000},
    {648.80, 1692.00, 12.79000},
    {648.80, 1684.00, 12.79000},
    {648.80, 1676.00, 12.79000},
    {648.80, 1668.00, 12.79000},
    {648.80, 1660.00, 12.79000},
    {630.90, 1705.00, 12.79000}
};

forward TimerSecondUpdateCont(contid, moneystart[]);
forward SpawnNewCont(contid);
forward AutoDeleteOpenedCont(contid);
forward CorrectTimerMinute();
stock SpawnCont(contid);
stock ResetContInfo(contid);

new ContArea[MAX_CONT + 1];

stock ConvertMoney(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, ".", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}

new MikhailArea[4];
new MikhailActor[4];

new HelpArea[4];
new HelpActor[4];

enum e_rent_zone
{
    Float:RENT_PICKUP_X,
    Float:RENT_PICKUP_Y,
    Float:RENT_PICKUP_Z,
    RENT_PARKING_COUNT
}

enum e_parking_data
{
    Float:PARKING_X,
    Float:PARKING_Y,
    Float:PARKING_Z,
    Float:PARKING_A,
    bool:PARKING_BUSY,
    PARKING_VEHICLE
}
new
    Float:last_vx[MAX_PLAYERS],
    Float:last_vy[MAX_PLAYERS],
    Float:last_vz[MAX_PLAYERS];

new RentZones[MAX_RENT_ZONES][e_rent_zone];
new ParkingSlots[MAX_RENT_ZONES][MAX_PARKING_PER_ZONE][e_parking_data];
new TotalRentZones = 0;

new AudioURL[256] = "https://muzkz.com/uploads/files/2024-01/1706164617_erbolat-kudajbergen-men-kazakpyn.mp3;
new CCMessage[128] = "{FFCD00}��� ��� ������ ���������������: {FFFFFF}%s";


new RazdewPravo, RazdewGibddYuzhny, RazdewGibddNij, RazdewUmvd, RazdewBolkaArz, RazdewBolkaLit, RazdewSmi, RazdewOpgArz, RazdewOpgLit, RazdewOpgBat, RazdewFsin, RazdewArmia, RazdewFsb;

new Float:ATM_Positions[][] = {
    {1551.044067, 411.322357, 1001.039306, 1, 0}
};

new ATM_Areas[sizeof(ATM_Positions)];

enum
{
	CH_ADMIN,
	CH_TESTDRIVE,
	CH_RESTART1,
	CH_RESTART2,
	CH_RESTART3,
	CH_RESTART4,
	CH_RESTART5,
	CH_RESTART6,
}

#define SERVER_NAME 	"Green Kazakhstan"
#define SERVER_SITE 	"t.me/"
#define SERVER_MAP_NAME "v16.54.0"
#define SERVER_VERSION	"12.1 (F1)"
#define SERVER_VK       "t.me/"
#define SERVER_TG       "t.me/

#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "user43718"
#define MYSQL_PASS "yWPu0iRmpsPs"
#define MYSQL_DB   "user43718"

#define COLOR_WHITE     0xFFFFFFFF
#define COLOR_YELLOW    0xFFFF00FF
#define COLOR_RED       0xFF0000FF
#define COLOR_GREEN     0x33CC33FF
#define COLOR_ADMIN     0xFF6600FF
#define MAX_ADMIN_LEVEL (14)

new const g_AdminLevelNames[MAX_ADMIN_LEVEL + 1][64] =
{
    "�����",
    "������� ���������",
    "���������",
    "������� ���������",
    "�������������",
    "������� �������������",
    "��/���",
    "������� �������������",
    "����������� ����������",
    "���. �������� ��������������",
    "������� �������������",
    "������� �������",
    "����������� ����������",
    "�����������",
    "����������"
};

enum
{
    DIALOG_REGISTER = 1,
    DIALOG_LOGIN,
    DIALOG_GENDER,
    DIALOG_SPAWN,
    DIALOG_ADMIN_HELP,
    DIALOG_ADMINS_LIST,
    DIALOG_PLAYER_MENU,
    DIALOG_ADMIN_LOGIN,
    DIALOG_ADMIN_REG
}

new Float:g_Spawns[][4] =
{
    {846.602600, 796.555847, 13.400512, 50.0},
    {2740.712158, -2441.565185, 21.774286, 50.0},
    {-2429.236083, 203.175277, 26.096101, 50.0},
    {1801.694091, 2523.137695, 14.602633, 50.0},
    {-2667.526611, 2006.567016, 11.197804, 50.0},
    {-2159.371093, 1558.103271, 9.840852, 50.0}
};


enum E_PLAYER_DATA
{
    pID,
    bool:pLogged,
    pPassword[64],
    pSkin,
    pGender,
    pColor,
    pColorStr[7],

    pMoney,
    pAdmin,
    pAdminPass,
    pAdminWarn,
    pAdminLoginAttempts,
    bool:pAdminAuth,
    bool:pAdminDuty,
    bool:pMuted,
    pMuteExpire,
    bool:pFrozen,
    bool:pJailed,
    pJailExpire,
    bool:pBanned,
    pBanReason[128],
    pIP[16]
}

new gPlayerData[MAX_PLAYERS][E_PLAYER_DATA];
new g_SQLHandle;

forward ResetPlayerData(playerid);
forward SendWelcomeMessages(playerid);
forward SaveAccount(playerid);
forward OnAccountCheck(playerid);
forward OnAccountRegister(playerid);
forward OnAccountLogin(playerid);
forward UnfreezePlayer(playerid);
forward SpawnPlayerAtRandomPoint(playerid);
forward MoneySyncTick();
forward JailTick(playerid);
forward MuteTick(playerid);

main()
{
    print("\n----------------------------------");
    print(" ��� � 0 By workk ������");
    print("----------------------------------\n");
}

public OnGameModeInit()
{
    SetGameModeText("Workk RP MySQL");
    ShowNameTags(1);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);

    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);

    g_SQLHandle = _:mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);
    if(mysql_errno(g_SQLHandle) != 0)
    {
        printf("[MySQL] Connection Error!");
    }
    else
    {
        printf("[MySQL] Connected successfully to %s", MYSQL_DB);
    }

    AddPlayerClass(0, g_Spawns[0][0], g_Spawns[0][1], g_Spawns[0][2], g_Spawns[0][3], 0, 0, 0, 0, 0, 0);

    SetTimer("MoneySyncTick", 30000, true);

    SummerEvent_Init();
    return 1;
}

public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged])
        {
            SaveAccount(i);
        }
    }
    mysql_close(g_SQLHandle);
    return 1;
}

public OnPlayerConnect(playerid)
{
    ResetPlayerData(playerid);
    GetPlayerIp(playerid, gPlayerData[playerid][pIP], 16);

    SummerEvent_OnPlayerConnect(playerid);
    TogglePlayerSpectating(playerid, 1);

    if(mysql_errno(g_SQLHandle) != 0)
    {
        SendClientMessage(playerid, COLOR_RED, "������ ���� ������. ���������� ����� �����.");
        Kick(playerid);
        return 1;
    }

    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(g_SQLHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e' LIMIT 1", name);
    mysql_tquery(g_SQLHandle, query, "OnAccountCheck", "i", playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(gPlayerData[playerid][pLogged])
    {
        SaveAccount(playerid);
    }
    ResetPlayerData(playerid);
    SummerEvent_OnPlayerDisconnect(playerid, reason);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!gPlayerData[playerid][pLogged])
    {
        Kick(playerid);
        return 1;
    }

    SetPlayerColor(playerid, gPlayerData[playerid][pColor]);
    SetPlayerVelocity(playerid, 0.0, 0.0, 0.0);
    ClearAnimations(playerid);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerHealth(playerid, 100.0);

    if(gPlayerData[playerid][pFrozen])
    {
        TogglePlayerControllable(playerid, false);
    }

    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SummerEvent_OnPlayerDeath(playerid, killerid, reason);
    return 1;
}

public OnPlayerUpdate(playerid)
{
    SummerEvent_OnPlayerUpdate(playerid);
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(!gPlayerData[playerid][pLogged]) return 0;

    if(gPlayerData[playerid][pMuted])
    {
        SendClientMessage(playerid, COLOR_ADMIN, "�� �� ������ ������ � ���: �� � ����.");
        return 0;
    }

    new name[MAX_PLAYER_NAME], chatStr[256];
    GetPlayerName(playerid, name, sizeof(name));

    if(gPlayerData[playerid][pAdmin] > 0 && gPlayerData[playerid][pAdminDuty])
    {
        format(chatStr, sizeof(chatStr), "- %s ({FF6600}%s{FFFFFF} [%s]) [{%s}%d{FFFFFF}]",
            text, name, g_AdminLevelNames[gPlayerData[playerid][pAdmin]], gPlayerData[playerid][pColorStr], playerid);
    }
    else
    {
        format(chatStr, sizeof(chatStr), "- %s ({%s}%s{FFFFFF}) [{%s}%d{FFFFFF}]", text, gPlayerData[playerid][pColorStr], name, gPlayerData[playerid][pColorStr], playerid);
    }
    SendClientMessageToAll(COLOR_WHITE, chatStr);

    return 0;
}

public OnAccountCheck(playerid)
{
    new rows = cache_num_rows();
    if(rows > 0)
    {
        cache_get_value_name(0, "password", gPlayerData[playerid][pPassword], 64);
        cache_get_value_name_int(0, "id", gPlayerData[playerid][pID]);

        new banned, banExpire;
        cache_get_value_name_int(0, "banned", banned);
        cache_get_value_name_int(0, "ban_expire", banExpire);

        if(banned)
        {
            if(banExpire > 0 && gettime() >= banExpire)
            {
                new unbanQuery[192];
                mysql_format(g_SQLHandle, unbanQuery, sizeof(unbanQuery),
                    "UPDATE `users` SET `banned` = 0, `ban_reason` = '', `ban_expire` = 0 WHERE `id` = %d LIMIT 1",
                    gPlayerData[playerid][pID]);
                mysql_tquery(g_SQLHandle, unbanQuery);
            }
            else
            {
                new reason[128], kickMsg[192];
                cache_get_value_name(0, "ban_reason", reason, 128);
                if(banExpire > 0)
                    format(kickMsg, sizeof(kickMsg), "�� ��������. �������: %s | ��: %s", reason, "���� �������� �������");
                else
                    format(kickMsg, sizeof(kickMsg), "�� ��������. �������: %s", reason);

                SendClientMessage(playerid, COLOR_RED, kickMsg);
                SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
                return 1;
            }
        }

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�����������", "{FFFFFF}��� ������� ���������������!\n������� ��� ������:", "�����", "�����");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "�����������", "{FFFFFF}����� ���������� �� Workk RP!\n���������� ������ ��� �����������:", "�����", "�����");
    }
    return 1;
}

forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
    if(IsPlayerConnected(playerid)) Kick(playerid);
    return 1;
}

public OnAccountRegister(playerid)
{
    gPlayerData[playerid][pID] = cache_insert_id();
    gPlayerData[playerid][pLogged] = true;

    ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST,
        "Workk RP | ����� ����",
        "{FFFFFF}�� ��������� �����������, ������ �������� ��� ������ ���������.\n\n�������\n�������",
        "�������", "�����");
    return 1;
}

public OnAccountLogin(playerid)
{
    cache_get_value_name_int(0, "skin", gPlayerData[playerid][pSkin]);
    cache_get_value_name_int(0, "gender", gPlayerData[playerid][pGender]);
    cache_get_value_name_int(0, "money", gPlayerData[playerid][pMoney]);
    cache_get_value_name_int(0, "admin", gPlayerData[playerid][pAdmin]);
    cache_get_value_name_int(0, "admin_pass", gPlayerData[playerid][pAdminPass]);
    cache_get_value_name_int(0, "admin_warn", gPlayerData[playerid][pAdminWarn]);

    gPlayerData[playerid][pAdminAuth] = false;
    gPlayerData[playerid][pAdminDuty] = false;
    gPlayerData[playerid][pAdminLoginAttempts] = 0;

    new muteExpire, jailExpire;
    cache_get_value_name_int(0, "mute_expire", muteExpire);
    cache_get_value_name_int(0, "jail_expire", jailExpire);

    if(gettime() < muteExpire)
    {
        gPlayerData[playerid][pMuted] = true;
        gPlayerData[playerid][pMuteExpire] = muteExpire;
        SetTimerEx("MuteTick", (muteExpire - gettime()) * 1000, false, "i", playerid);
    }

    if(gettime() < jailExpire)
    {
        gPlayerData[playerid][pJailed] = true;
        gPlayerData[playerid][pJailExpire] = jailExpire;
        SetTimerEx("JailTick", (jailExpire - gettime()) * 1000, false, "i", playerid);
    }

    if(gPlayerData[playerid][pAdmin] > MAX_ADMIN_LEVEL) gPlayerData[playerid][pAdmin] = MAX_ADMIN_LEVEL;

    gPlayerData[playerid][pLogged] = true;
    SpawnPlayerAtRandomPoint(playerid);
    SendWelcomeMessages(playerid);

    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, gPlayerData[playerid][pMoney]);

    if(gPlayerData[playerid][pJailed])
    {
        SendClientMessage(playerid, COLOR_ADMIN, "�� ���������� � ������.");
    }

    if(gPlayerData[playerid][pAdmin] > 0)
    {
        Admin_AuthorizationComplete(playerid);
    }

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(SummerEvent_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
        return 1;

    if(Admin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
        return 1;

    if(dialogid == DIALOG_REGISTER)
    {
        if(!response)
        {
            Kick(playerid);
            return 1;
        }

        if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "�����������", "{FFFFFF}������ ������ ���� �� 4 �� 32 ��������!\n������� ������ �����:", "�����", "�����");
            return 1;
        }

        new name[MAX_PLAYER_NAME], query[256];
        GetPlayerName(playerid, name, sizeof(name));
        format(gPlayerData[playerid][pPassword], 64, "%s", inputtext);

        gPlayerData[playerid][pSkin] = 78;
        gPlayerData[playerid][pGender] = 0;

        mysql_format(g_SQLHandle, query, sizeof(query), "INSERT INTO `users` (`name`, `password`, `skin`, `gender`, `money`, `admin`) VALUES ('%e', '%e', %d, %d, %d, %d)", name, inputtext, 78, 0, 5000, 0);
        mysql_tquery(g_SQLHandle, query, "OnAccountRegister", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_LOGIN)
    {
        if(!response)
        {
            Kick(playerid);
            return 1;
        }

        if(!strcmp(inputtext, gPlayerData[playerid][pPassword], false))
        {
            new name[MAX_PLAYER_NAME], query[128];
            GetPlayerName(playerid, name, sizeof(name));
            mysql_format(g_SQLHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e' LIMIT 1", name);
            mysql_tquery(g_SQLHandle, query, "OnAccountLogin", "i", playerid);
        }
        else
        {
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�����������", "{FF0000}�������� ������!\n{FFFFFF}������� ������ �����:", "�����", "�����");
        }
        return 1;
    }

    if(dialogid == DIALOG_GENDER)
    {
        if(!response)
        {
            Kick(playerid);
            return 1;
        }

        if(listitem == 0)
        {
            gPlayerData[playerid][pSkin] = 78;
            gPlayerData[playerid][pGender] = 0;
        }
        else
        {
            gPlayerData[playerid][pSkin] = 135;
            gPlayerData[playerid][pGender] = 1;
        }

        new query[128];
        mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `skin` = %d, `gender` = %d WHERE `id` = %d",
            gPlayerData[playerid][pSkin], gPlayerData[playerid][pGender], gPlayerData[playerid][pID]);
        mysql_tquery(g_SQLHandle, query);

        gPlayerData[playerid][pMoney] = 5000;
        SpawnPlayerAtRandomPoint(playerid);
        SendWelcomeMessages(playerid);
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, gPlayerData[playerid][pMoney]);
        return 1;
    }

    if(dialogid == DIALOG_SPAWN)
    {
        if(!response) return 1;

        SetPlayerPos(playerid, g_Spawns[listitem][0], g_Spawns[listitem][1], g_Spawns[listitem][2]);
        SetPlayerFacingAngle(playerid, g_Spawns[listitem][3]);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerHealth(playerid, 100.0);
        SetCameraBehindPlayer(playerid);

        SendClientMessage(playerid, COLOR_WHITE, "�� ��������������� �� ��������� �����.");
        return 1;
    }

    return 1;
}

CMD:spawn(playerid, params[])
{
    ShowSpawnDialog(playerid);
    return 1;
}

ShowSpawnDialog(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_SPAWN, DIALOG_STYLE_LIST,
        "����� ����� ������",
        "����� 1\n����� 2\n����� 3\n����� 4\n����� 5\n����� 6",
        "�������", "�������");
    return 1;
}

public UnfreezePlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    ClearAnimations(playerid);
    if(!gPlayerData[playerid][pFrozen])
        TogglePlayerControllable(playerid, true);
    return 1;
}

public SpawnPlayerAtRandomPoint(playerid)
{
    new rand = random(sizeof(g_Spawns));

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    SetSpawnInfo(playerid, 0, gPlayerData[playerid][pSkin],
        g_Spawns[rand][0], g_Spawns[rand][1], g_Spawns[rand][2], g_Spawns[rand][3],
        0, 0, 0, 0, 0, 0);

    TogglePlayerSpectating(playerid, 0);
    TogglePlayerControllable(playerid, false);

    SpawnPlayer(playerid);

    SetPlayerSkin(playerid, gPlayerData[playerid][pSkin]);
    SetPlayerColor(playerid, gPlayerData[playerid][pColor]);
    SetCameraBehindPlayer(playerid);

    SetTimerEx("UnfreezePlayer", 500, false, "i", playerid);
    return 1;
}

public ResetPlayerData(playerid)
{
    gPlayerData[playerid][pID] = 0;
    gPlayerData[playerid][pLogged] = false;
    gPlayerData[playerid][pPassword][0] = '\0';
    gPlayerData[playerid][pSkin] = 78;
    gPlayerData[playerid][pGender] = 0;
    gPlayerData[playerid][pColor] = COLOR_WHITE;
    format(gPlayerData[playerid][pColorStr], 7, "FFFFFF");

    gPlayerData[playerid][pMoney] = 0;
    gPlayerData[playerid][pAdmin] = 0;
    gPlayerData[playerid][pAdminPass] = 0;
    gPlayerData[playerid][pAdminWarn] = 0;
    gPlayerData[playerid][pAdminLoginAttempts] = 0;
    gPlayerData[playerid][pAdminAuth] = false;
    gPlayerData[playerid][pAdminDuty] = false;
    gPlayerData[playerid][pMuted] = false;
    gPlayerData[playerid][pMuteExpire] = 0;
    gPlayerData[playerid][pFrozen] = false;
    gPlayerData[playerid][pJailed] = false;
    gPlayerData[playerid][pJailExpire] = 0;
    gPlayerData[playerid][pBanned] = false;
    gPlayerData[playerid][pBanReason][0] = '\0';
    return 1;
}

public SendWelcomeMessages(playerid)
{
    SendClientMessage(playerid, COLOR_WHITE, "����� ���������� �� {FFFF00}Workk RP");
    SendClientMessage(playerid, COLOR_WHITE, "�������� ����� ����������: {FFFF00}t.me/dev_workkrp");
    SendClientMessage(playerid, COLOR_WHITE, "�������� ����� Workk'�: {FFFF00}t.me/crmp_workk");
    return 1;
}

public SaveAccount(playerid)
{
    if(!gPlayerData[playerid][pLogged]) return 0;

    new query[400];
    mysql_format(g_SQLHandle, query, sizeof(query),
        "UPDATE `users` SET `skin` = %d, `gender` = %d, `money` = %d, `admin` = %d, `admin_pass` = %d, `admin_warn` = %d, `mute_expire` = %d, `jail_expire` = %d WHERE `id` = %d",
        gPlayerData[playerid][pSkin],
        gPlayerData[playerid][pGender],
        gPlayerData[playerid][pMoney],
        gPlayerData[playerid][pAdmin],
        gPlayerData[playerid][pAdminPass],
        gPlayerData[playerid][pAdminWarn],
        gPlayerData[playerid][pMuteExpire],
        gPlayerData[playerid][pJailExpire],
        gPlayerData[playerid][pID]
    );
    mysql_tquery(g_SQLHandle, query);
    return 1;
}

// ������ 30 ������ ����������� �������� ������ ������ (GivePlayerMoney � �.�.
// �� ����� ������/�������) � pMoney � ��������� � ����.
public MoneySyncTick()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged])
        {
            gPlayerData[i][pMoney] = GetPlayerMoney(i);
            SaveAccount(i);
        }
    }
    return 1;
}

public MuteTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    gPlayerData[playerid][pMuted] = false;
    gPlayerData[playerid][pMuteExpire] = 0;
    SendClientMessage(playerid, COLOR_GREEN, "��� ��� ����, �� ����� ������ ������ � ���.");
    return 1;
}

public JailTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    gPlayerData[playerid][pJailed] = false;
    gPlayerData[playerid][pJailExpire] = 0;
    SpawnPlayerAtRandomPoint(playerid);
    SendClientMessage(playerid, COLOR_GREEN, "�� ����������� �� ������.");
    return 1;
}

stock IsPlayerLoggedIn(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    return gPlayerData[playerid][pLogged];
}

stock GetPlayerLevel(playerid)
{
    if(!gPlayerData[playerid][pAdminAuth])
        return 0;

    return gPlayerData[playerid][pAdmin];
}

stock SetPlayerLevel(playerid, level)
{
    if(level < 0) level = 0;
    if(level > MAX_ADMIN_LEVEL) level = MAX_ADMIN_LEVEL;
    gPlayerData[playerid][pAdmin] = level;
    SaveAccount(playerid);
    return 1;
}

stock GetPlayerLevelName(playerid)
{
    return g_AdminLevelNames[gPlayerData[playerid][pAdmin]];
}

stock bool:IsPlayerOnDuty(playerid)
{
    return gPlayerData[playerid][pAdminDuty];
}

stock SetPlayerDuty(playerid, bool:toggle)
{
    gPlayerData[playerid][pAdminDuty] = toggle;
    return 1;
}

stock GetPlayerMoneyEx(playerid)
{
    return gPlayerData[playerid][pMoney];
}

stock GivePlayerMoneyEx(playerid, amount)
{
    GivePlayerMoney(playerid, amount);
    gPlayerData[playerid][pMoney] = GetPlayerMoney(playerid);
    SaveAccount(playerid);
    return 1;
}

stock SetPlayerMoneyEx(playerid, amount)
{
    if(amount < 0) amount = 0;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, amount);
    gPlayerData[playerid][pMoney] = amount;
    SaveAccount(playerid);
    return 1;
}

stock bool:IsPlayerMuted(playerid)
{
    return gPlayerData[playerid][pMuted];
}

stock SetPlayerMuted(playerid, seconds, reason[])
{
    #pragma unused reason
    gPlayerData[playerid][pMuted] = true;
    gPlayerData[playerid][pMuteExpire] = gettime() + seconds;
    SetTimerEx("MuteTick", seconds * 1000, false, "i", playerid);
    return 1;
}

stock SetPlayerUnmuted(playerid)
{
    gPlayerData[playerid][pMuted] = false;
    gPlayerData[playerid][pMuteExpire] = 0;
    return 1;
}

stock bool:IsPlayerFrozenEx(playerid)
{
    return gPlayerData[playerid][pFrozen];
}

stock SetPlayerFrozenEx(playerid, bool:toggle)
{
    gPlayerData[playerid][pFrozen] = toggle;
    TogglePlayerControllable(playerid, !toggle);
    return 1;
}

stock SetPlayerJailedEx(playerid, seconds)
{
    gPlayerData[playerid][pJailed] = true;
    gPlayerData[playerid][pJailExpire] = gettime() + seconds;
    SetTimerEx("JailTick", seconds * 1000, false, "i", playerid);
    return 1;
}

stock SetPlayerUnjailedEx(playerid)
{
    gPlayerData[playerid][pJailed] = false;
    gPlayerData[playerid][pJailExpire] = 0;
    SpawnPlayerAtRandomPoint(playerid);
    return 1;
}

stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock BanPlayerEx(playerid, reason[])
{
    new query[256], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `banned` = 1, `ban_reason` = '%e' WHERE `id` = %d", reason, gPlayerData[playerid][pID]);
    mysql_tquery(g_SQLHandle, query);

    new kickMsg[160];
    format(kickMsg, sizeof(kickMsg), "�� ��������. �������: %s", reason);
    SendClientMessage(playerid, COLOR_RED, kickMsg);
    SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
    return 1;
}

stock UnbanPlayerEx(name[])
{
    new query[256];
    mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `banned` = 0, `ban_reason` = '' WHERE `name` = '%e'", name);
    mysql_tquery(g_SQLHandle, query);
    return 1;
}
// �������� 
#include "Workk/autumn_event.inc"
#include "Workk/admin.inc"
#include "Workk/chat.inc"

public OnRconCommand(cmd[])
{
    new pos = strfind(cmd, " ", true);
    if(pos == -1) return 0;

    new cmdname[32];
    strmid(cmdname, cmd, 0, pos, 32);

    if(!strcmp(cmdname, "setlevel", true))
    {
        new name[MAX_PLAYER_NAME], level, query[128];
        if(sscanf(cmd[pos + 1], "s[24]d", name, level)) return 1;

        mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `admin` = %d WHERE `name` = '%e'", level, name);
        mysql_tquery(g_SQLHandle, query);

        printf("[RCON] ������ %s ��������� ������� ������� %d (������� � ���� ��� ��������� �����).", name, level);
        return 1;
    }
    return 0;
}
