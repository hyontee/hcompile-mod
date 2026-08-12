#if defined _casino_included
	#endinput
#endif
#define _casino_included
#define AI_CreateActor CreateDynamicActor

static const Float:CasinoRouletteTablePos[] = 
	{ 0.00, 7.24, 13.8 }
;
static const Float:CasinoRouletteChipsPos[][2] = {
	{ 1950.216918, 1742.510498 }, // 0
	{ 1950.367065, 1742.270263 }, // 1
	{ 1950.367065, 1742.510498 }, // 2
	{ 1950.367065, 1742.750732 }, // 3
	{ 1950.521118, 1742.270263 }, // 4
	{ 1950.521118, 1742.510498 }, // 5
	{ 1950.521118, 1742.750732 }, // 6
	{ 1950.675170, 1742.270263 }, // 7
	{ 1950.675170, 1742.510498 }, // 8
	{ 1950.675170, 1742.750732 }, // 9
	{ 1950.829223, 1742.270263 }, // 10
	{ 1950.829223, 1742.510498 }, // 11
	{ 1950.829223, 1742.750732 }, // 12
	{ 1950.983276, 1742.270263 }, // 13
	{ 1950.983276, 1742.510498 }, // 14
	{ 1950.983276, 1742.750732 }, // 15
	{ 1951.137329, 1742.270263 }, // 16
	{ 1951.137329, 1742.510498 }, // 17
	{ 1951.137329, 1742.750732 }, // 18
	{ 1951.291381, 1742.270263 }, // 19
	{ 1951.291381, 1742.510498 }, // 20
	{ 1951.291381, 1742.750732 }, // 21
	{ 1951.445434, 1742.270263 }, // 22
	{ 1951.445434, 1742.510498 }, // 23
	{ 1951.445434, 1742.750732 }, // 24
	{ 1951.599487, 1742.270263 }, // 25
	{ 1951.599487, 1742.510498 }, // 26
	{ 1951.599487, 1742.750732 }, // 27
	{ 1951.753540, 1742.270263 }, // 28
	{ 1951.753540, 1742.510498 }, // 29
	{ 1951.753540, 1742.750732 }, // 30
	{ 1951.907592, 1742.270263 }, // 31
	{ 1951.907592, 1742.510498 }, // 32
	{ 1951.907592, 1742.750732 }, // 33
	{ 1952.061645, 1742.270263 }, // 34
	{ 1952.061645, 1742.510498 }, // 35
	{ 1952.061645, 1742.750732 }, // 36
	{ 1951.361450, 1741.779785 }, // BLACK
	{ 1951.061401, 1741.779785 }, // RED
	{ 1950.601196, 1742.020019 }, //  1st-12
	{ 1951.221191, 1742.020019 }, //  2nd-12
	{ 1951.831787, 1742.020019 }, //  3rd-12
	{ 1950.451416, 1741.779785 }, // 1-18
	{ 1951.971923, 1741.779785 }, // 19-36
	{ 1950.751342, 1741.779785 }, // EVEN
	{ 1951.661621, 1741.779785 }, // ODD
	{ 1952.215698, 1742.270263 }, // 3to1
	{ 1952.215698, 1742.510498 }, // 3to1
	{ 1952.215698, 1742.750732 } // 3to1
};


//#define COLOR_ERROR 					COLOR_GREY

#define MAX_CASINO_CARDS				(52)

enum {
	CARD_NUMBER_TWO = 2,
	CARD_NUMBER_THREE,
	CARD_NUMBER_FOUR,
	CARD_NUMBER_FIVE,
	CARD_NUMBER_SIX,
	CARD_NUMBER_SEVEN,
	CARD_NUMBER_EIGHT,
	CARD_NUMBER_NINE,
	CARD_NUMBER_TEN,
	CARD_NUMBER_JACK,
	CARD_NUMBER_QUEEN,
	CARD_NUMBER_KING,
	CARD_NUMBER_ACE
}
enum {
	BJ_CARD_NUMBER_TWO = 1,
	BJ_CARD_NUMBER_THREE,
	BJ_CARD_NUMBER_FOUR,
	BJ_CARD_NUMBER_FIVE,
	BJ_CARD_NUMBER_SIX,
	BJ_CARD_NUMBER_SEVEN,
	BJ_CARD_NUMBER_EIGHT,
	BJ_CARD_NUMBER_NINE,
	BJ_CARD_NUMBER_TEN,
	BJ_CARD_NUMBER_JACK,
	BJ_CARD_NUMBER_QUEEN,
	BJ_CARD_NUMBER_KING,
	BJ_CARD_NUMBER_ACE
}
enum {
	CARD_SUIT_CLUBS = 1,
	CARD_SUIT_DIAMONDS,
	CARD_SUIT_HEARTS,
	CARD_SUIT_SPADES
};
enum CASINO_CARD_ENUM {
	CASINO_CARD_NAME[16],
	CASINO_CARD_SUIT,
	CASINO_CARD_VALUE
};
new CASINO_CARD_INFO[MAX_CASINO_CARDS][CASINO_CARD_ENUM] = {
	{"LD_CARD:cd1c", CARD_SUIT_CLUBS, CARD_NUMBER_ACE},
	{"LD_CARD:cd2c", CARD_SUIT_CLUBS, CARD_NUMBER_TWO},
	{"LD_CARD:cd3c", CARD_SUIT_CLUBS, CARD_NUMBER_THREE},
	{"LD_CARD:cd4c", CARD_SUIT_CLUBS, CARD_NUMBER_FOUR},
	{"LD_CARD:cd5c", CARD_SUIT_CLUBS, CARD_NUMBER_FIVE},
	{"LD_CARD:cd6c", CARD_SUIT_CLUBS, CARD_NUMBER_SIX},
	{"LD_CARD:cd7c", CARD_SUIT_CLUBS, CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8c", CARD_SUIT_CLUBS, CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9c", CARD_SUIT_CLUBS, CARD_NUMBER_NINE},
	{"LD_CARD:cd10c", CARD_SUIT_CLUBS, CARD_NUMBER_TEN},
	{"LD_CARD:cd11c", CARD_SUIT_CLUBS, CARD_NUMBER_JACK},
	{"LD_CARD:cd12c", CARD_SUIT_CLUBS, CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13c", CARD_SUIT_CLUBS, CARD_NUMBER_KING},

	{"LD_CARD:cd1d", CARD_SUIT_DIAMONDS, CARD_NUMBER_ACE},
	{"LD_CARD:cd2d", CARD_SUIT_DIAMONDS, CARD_NUMBER_TWO},
	{"LD_CARD:cd3d", CARD_SUIT_DIAMONDS, CARD_NUMBER_THREE},
	{"LD_CARD:cd4d", CARD_SUIT_DIAMONDS, CARD_NUMBER_FOUR},
	{"LD_CARD:cd5d", CARD_SUIT_DIAMONDS, CARD_NUMBER_FIVE},
	{"LD_CARD:cd6d", CARD_SUIT_DIAMONDS, CARD_NUMBER_SIX},
	{"LD_CARD:cd7d", CARD_SUIT_DIAMONDS, CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8d", CARD_SUIT_DIAMONDS, CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9d", CARD_SUIT_DIAMONDS, CARD_NUMBER_NINE},
	{"LD_CARD:cd10d", CARD_SUIT_DIAMONDS, CARD_NUMBER_TEN},
	{"LD_CARD:cd11d", CARD_SUIT_DIAMONDS, CARD_NUMBER_JACK},
	{"LD_CARD:cd12d", CARD_SUIT_DIAMONDS, CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13d", CARD_SUIT_DIAMONDS, CARD_NUMBER_KING},

	{"LD_CARD:cd1h", CARD_SUIT_HEARTS, CARD_NUMBER_ACE},
	{"LD_CARD:cd2h", CARD_SUIT_HEARTS, CARD_NUMBER_TWO},
	{"LD_CARD:cd3h", CARD_SUIT_HEARTS, CARD_NUMBER_THREE},
	{"LD_CARD:cd4h", CARD_SUIT_HEARTS, CARD_NUMBER_FOUR},
	{"LD_CARD:cd5h", CARD_SUIT_HEARTS, CARD_NUMBER_FIVE},
	{"LD_CARD:cd6h", CARD_SUIT_HEARTS, CARD_NUMBER_SIX},
	{"LD_CARD:cd7h", CARD_SUIT_HEARTS, CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8h", CARD_SUIT_HEARTS, CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9h", CARD_SUIT_HEARTS, CARD_NUMBER_NINE},
	{"LD_CARD:cd10h", CARD_SUIT_HEARTS, CARD_NUMBER_TEN},
	{"LD_CARD:cd11h", CARD_SUIT_HEARTS, CARD_NUMBER_JACK},
	{"LD_CARD:cd12h", CARD_SUIT_HEARTS, CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13h", CARD_SUIT_HEARTS, CARD_NUMBER_KING},

	{"LD_CARD:cd1s", CARD_SUIT_SPADES, CARD_NUMBER_ACE},
	{"LD_CARD:cd2s", CARD_SUIT_SPADES, CARD_NUMBER_TWO},
	{"LD_CARD:cd3s", CARD_SUIT_SPADES, CARD_NUMBER_THREE},
	{"LD_CARD:cd4s", CARD_SUIT_SPADES, CARD_NUMBER_FOUR},
	{"LD_CARD:cd5s", CARD_SUIT_SPADES, CARD_NUMBER_FIVE},
	{"LD_CARD:cd6s", CARD_SUIT_SPADES, CARD_NUMBER_SIX},
	{"LD_CARD:cd7s", CARD_SUIT_SPADES, CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8s", CARD_SUIT_SPADES, CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9s", CARD_SUIT_SPADES, CARD_NUMBER_NINE},
	{"LD_CARD:cd10s", CARD_SUIT_SPADES, CARD_NUMBER_TEN},
	{"LD_CARD:cd11s", CARD_SUIT_SPADES, CARD_NUMBER_JACK},
	{"LD_CARD:cd12s", CARD_SUIT_SPADES, CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13s", CARD_SUIT_SPADES, CARD_NUMBER_KING}
};
enum CASINO_BJ_CARD_ENUM {
	CASINO_BJ_CARD_NAME[16],
	CASINO_BJ_CARD_SUIT,
	CASINO_BJ_CARD_VALUE
};
new CASINO_BJ_CARD_INFO[MAX_CASINO_CARDS][CASINO_BJ_CARD_ENUM] = {
	{"LD_CARD:cd1c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_ACE},
	{"LD_CARD:cd2c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_TWO},
	{"LD_CARD:cd3c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_THREE},
	{"LD_CARD:cd4c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_FOUR},
	{"LD_CARD:cd5c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_FIVE},
	{"LD_CARD:cd6c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_SIX},
	{"LD_CARD:cd7c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_NINE},
	{"LD_CARD:cd10c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_TEN},
	{"LD_CARD:cd11c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_JACK},
	{"LD_CARD:cd12c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13c", CARD_SUIT_CLUBS, BJ_CARD_NUMBER_KING},

	{"LD_CARD:cd1d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_ACE},
	{"LD_CARD:cd2d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_TWO},
	{"LD_CARD:cd3d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_THREE},
	{"LD_CARD:cd4d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_FOUR},
	{"LD_CARD:cd5d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_FIVE},
	{"LD_CARD:cd6d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_SIX},
	{"LD_CARD:cd7d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_NINE},
	{"LD_CARD:cd10d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_TEN},
	{"LD_CARD:cd11d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_JACK},
	{"LD_CARD:cd12d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13d", CARD_SUIT_DIAMONDS, BJ_CARD_NUMBER_KING},

	{"LD_CARD:cd1h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_ACE},
	{"LD_CARD:cd2h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_TWO},
	{"LD_CARD:cd3h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_THREE},
	{"LD_CARD:cd4h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_FOUR},
	{"LD_CARD:cd5h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_FIVE},
	{"LD_CARD:cd6h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_SIX},
	{"LD_CARD:cd7h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_NINE},
	{"LD_CARD:cd10h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_TEN},
	{"LD_CARD:cd11h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_JACK},
	{"LD_CARD:cd12h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13h", CARD_SUIT_HEARTS, BJ_CARD_NUMBER_KING},

	{"LD_CARD:cd1s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_ACE},
	{"LD_CARD:cd2s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_TWO},
	{"LD_CARD:cd3s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_THREE},
	{"LD_CARD:cd4s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_FOUR},
	{"LD_CARD:cd5s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_FIVE},
	{"LD_CARD:cd6s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_SIX},
	{"LD_CARD:cd7s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_SEVEN},
	{"LD_CARD:cd8s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_EIGHT},
	{"LD_CARD:cd9s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_NINE},
	{"LD_CARD:cd10s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_TEN},
	{"LD_CARD:cd11s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_JACK},
	{"LD_CARD:cd12s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_QUEEN},
	{"LD_CARD:cd13s", CARD_SUIT_SPADES, BJ_CARD_NUMBER_KING}
};
enum {
	CASINO_LANGUAGE_ENGLISH = 0,
	CASINO_LANGUAGE_RUSSIAN
};
#define CASINO_DEFAULT_CHIPS_COURSE	(10)

#define CASINO_WORLD_ID				(1)
#define CASINO_INTERIOR_ID			(10)

enum casino_enum {
	casinoChipsCourse,
};
new casinoDataInfo[casino_enum];

new CasinoArea, PlayerText:CasinoRoulettePTD[MAX_PLAYERS];

#define CASINO_ROULETTE_TABLE_TIMER 	(30)
#define MAX_ROULETTE_TABLE_PLAYERS		15

enum CASINO_ROULETTE_TABLE_E {
	tableMinBet,
	tableMaxBet,

	Float:tablePos[3],
	Float:tableActorPos[4],

	tableWorld,
	tableInterior,

	tableActorID,
	Text3D:tableTextID,

	tableTimer,
	tableTimerID,
	tableTimerDeals,

	tableActiveBets,
	tableActivePlayers,
	tablePlayers[MAX_ROULETTE_TABLE_PLAYERS]
};
new CasinoRouletteTableInfo[][CASINO_ROULETTE_TABLE_E] = {
	{ 25, 1000, {1961.435791, 1025.165161, 992.488647}, {1959.2400, 1024.9224, 992.4688, 270.0}, CASINO_WORLD_ID, CASINO_INTERIOR_ID },
	{ 25, 1000, {1961.435791, 1017.924316, 992.488647}, {1959.2413, 1017.5031, 992.4688, 270.0}, CASINO_WORLD_ID, CASINO_INTERIOR_ID },
	{ 25, 1000, {1961.435791, 1011.364685, 992.488647}, {1959.2410, 1011.1620, 992.4688, 270.0}, CASINO_WORLD_ID, CASINO_INTERIOR_ID }
};

casino_OnPlayerLeaveDynamicArea(playerid, areaid) {
	if (areaid == CasinoArea) {
		HideCasinoChipsPTD(playerid);
		return true;
	}
	return false;
}

casino_OnPlayerEnterDynamicArea(playerid, areaid) {
	if (areaid == CasinoArea) {
		ShowCasinoChipsPTD(playerid);
		return true;
	}
	return false;
}

static 
	Text:CasinoChips_TD[2], 
	PlayerText:CasinoChips_PTD[MAX_PLAYERS];

casino_OnGameModeInit() {
	
	CasinoChips_TD[0] = TextDrawCreate(527.767700, 82.914825, "_");
	TextDrawTextSize(CasinoChips_TD[0], 50.000000, 50.000000);
	TextDrawAlignment(CasinoChips_TD[0], 1);
	TextDrawColor(CasinoChips_TD[0], 255);
	TextDrawSetShadow(CasinoChips_TD[0], 0);
	TextDrawFont(CasinoChips_TD[0], 5);
	TextDrawSetProportional(CasinoChips_TD[0], 0);
	TextDrawBackgroundColor(CasinoChips_TD[0], 0);
	TextDrawSetPreviewModel(CasinoChips_TD[0], 1905);
	TextDrawSetPreviewRot(CasinoChips_TD[0], 90.000000, 0.000000, 0.000000, 1.000000);

	CasinoChips_TD[1] = TextDrawCreate(532.666503, 88.214744, "_");
	TextDrawTextSize(CasinoChips_TD[1], 40.000000, 40.000000);
	TextDrawAlignment(CasinoChips_TD[1], 1);
	TextDrawColor(CasinoChips_TD[1], -1);
	TextDrawSetShadow(CasinoChips_TD[1], 0);
	TextDrawFont(CasinoChips_TD[1], 5);
	TextDrawSetProportional(CasinoChips_TD[1], 0);
	TextDrawBackgroundColor(CasinoChips_TD[1], 0);
	TextDrawSetPreviewModel(CasinoChips_TD[1], 1905);
	TextDrawSetPreviewRot(CasinoChips_TD[1], 90.000000, 0.000000, 0.000000, 1.000000);

	CreateDynamicObject(1978, 1961.435791, 1011.364685, 992.488647, -0.000004, -0.000001, 90.000000, CASINO_WORLD_ID, CASINO_INTERIOR_ID, -1, 100.00, 100.00); //_0
	CreateDynamicObject(1978, 1961.435791, 1017.924316, 992.488647, -0.000007, -0.000001, 90.000000, CASINO_WORLD_ID, CASINO_INTERIOR_ID, -1, 100.00, 100.00); //_0
	CreateDynamicObject(1978, 1961.435791, 1025.165161, 992.488647, -0.000009, -0.000001, 90.000000, CASINO_WORLD_ID, CASINO_INTERIOR_ID, -1, 100.00, 100.00); //_0
	CreateDynamicObject(1979, 1960.085449, 1011.174499, 992.468627, -0.000004, -0.000001, 90.000000, CASINO_WORLD_ID, CASINO_INTERIOR_ID, -1, 100.00, 100.00); //_1
	CreateDynamicObject(1979, 1960.085449, 1017.734130, 992.468627, -0.000007, -0.000001, 90.000000, CASINO_WORLD_ID, CASINO_INTERIOR_ID, -1, 100.00, 100.00); //_1
	CreateDynamicObject(1979, 1960.085449, 1024.974975, 992.468627, -0.000009, -0.000001, 90.000000, CASINO_WORLD_ID, CASINO_INTERIOR_ID, -1, 100.00, 100.00); //_1

	new Float:casinoTablePosZ = CasinoRouletteTableInfo[0][tablePos][2] + 0.25; 

	for (new roulette_tableid = 0; roulette_tableid < sizeof (CasinoRouletteTableInfo); roulette_tableid++) {
		CasinoRouletteTableInfo[roulette_tableid][tableActorID] = AI_CreateActor(11,
			CasinoRouletteTableInfo[roulette_tableid][tableActorPos][0], CasinoRouletteTableInfo[roulette_tableid][tableActorPos][1], 
			CasinoRouletteTableInfo[roulette_tableid][tableActorPos][2], CasinoRouletteTableInfo[roulette_tableid][tableActorPos][3], 
			.worldid = CasinoRouletteTableInfo[roulette_tableid][tableWorld], .interiorid = CASINO_INTERIOR_ID
		);
		CasinoRouletteTableInfo[roulette_tableid][tableTextID] = CreateDynamic3DTextLabel(
			"{9932CC}Рулетка\n \n{FFFFFF}Нажмите {9932CC}\"ENTER\"", 0xFFFFFFFF, 
			CasinoRouletteTableInfo[roulette_tableid][tablePos][0], CasinoRouletteTableInfo[roulette_tableid][tablePos][1], casinoTablePosZ, 
			5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, CasinoRouletteTableInfo[roulette_tableid][tableWorld], CASINO_INTERIOR_ID, -1
		);
		CasinoRouletteTableInfo[roulette_tableid][tableTimerDeals] = 0;
		CasinoRouletteTableInfo[roulette_tableid][tableTimerID] = -1;
		CasinoRouletteTableInfo[roulette_tableid][tableTimer] = CASINO_ROULETTE_TABLE_TIMER + 5 + (roulette_tableid * 15);

		for (new slotid = 0; slotid < MAX_ROULETTE_TABLE_PLAYERS; slotid++) {
			CasinoRouletteTableInfo[roulette_tableid][tablePlayers][slotid] = INVALID_PLAYER_ID;
		}
		CasinoRouletteTableInfo[roulette_tableid][tableActiveBets] = 0;
		CasinoRouletteTableInfo[roulette_tableid][tableActivePlayers] = 0;
	}
	casinoDataInfo[casinoChipsCourse] = CASINO_DEFAULT_CHIPS_COURSE;

	CasinoArea = CreateDynamicSphere(1960.085449, 1024.974975, 992.46865, 150.0, -1, CASINO_INTERIOR_ID);
}
CMD:language2(playerid) {
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) 
		return true;
	format(t_string, sizeof(t_string), 
		"{9932CC}1. {%s}English\n{9932CC}2. {%s}Русский", 
		(CASINO_LANGUAGE_ENGLISH == pInfo[playerid][pCasinoLanguage]) ? ("9ACD32") : ("FFFFFF"),
		(CASINO_LANGUAGE_RUSSIAN == pInfo[playerid][pCasinoLanguage]) ? ("9ACD32") : ("FFFFFF")
	); 
	ShowPlayerDialog(playerid, DIALOG_CASINO_LANGUAGE, DIALOG_STYLE_LIST, "{9932CC}Выбор языка интерфейса", 
		t_string, "Принять", "Выйти"
	), t_string[0] = EOS;
	return true;
}
CMD:lang2(playerid) 
	return callcmd::language2(playerid);

casino_OnPlayerConnect(playerid) {

	CasinoChips_PTD[playerid] = CreatePlayerTextDraw(playerid, 560.633300, 103.499092, "000004200");
	PlayerTextDrawLetterSize(playerid, CasinoChips_PTD[playerid], 0.295333, 1.297184);
	PlayerTextDrawTextSize(playerid, CasinoChips_PTD[playerid], 645.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, CasinoChips_PTD[playerid], 1);
	PlayerTextDrawColor(playerid, CasinoChips_PTD[playerid], -6225921);
	PlayerTextDrawSetShadow(playerid, CasinoChips_PTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CasinoChips_PTD[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, CasinoChips_PTD[playerid], 255);
	PlayerTextDrawFont(playerid, CasinoChips_PTD[playerid], 3);
	PlayerTextDrawSetProportional(playerid, CasinoChips_PTD[playerid], 1);
	return true;
}
stock ShowCasinoChipsPTD(playerid) {
	if (pTemp[playerid][tCasinoChipsPTD]) 
		return false;
	
	for (new i = 0; i < sizeof (CasinoChips_TD); i++) {
		TextDrawShowForPlayer(playerid, CasinoChips_TD[i]);
	}
	PlayerTextDrawShow(playerid, CasinoChips_PTD[playerid]);
	pTemp[playerid][tCasinoChipsPTD] = 1;

	UpdateCasinoChipsPTD(playerid);
	return true;
}
stock HideCasinoChipsPTD(playerid) {
	if (!pTemp[playerid][tCasinoChipsPTD]) 
		return false;
	for (new i = 0; i < sizeof (CasinoChips_TD); i++) {
		TextDrawHideForPlayer(playerid, CasinoChips_TD[i]);
	}
	PlayerTextDrawHide(playerid, CasinoChips_PTD[playerid]);
	return pTemp[playerid][tCasinoChipsPTD] = 0;
}
stock UpdateCasinoChipsPTD(playerid) {
	if (!pTemp[playerid][tCasinoChipsPTD]) 
		return;

	if (pInfo[playerid][pPokerTableID])
		format(t_string, sizeof (t_string), "%08d", pInfo[playerid][pPokerChips]);
	else format(t_string, sizeof (t_string), "%08d", pInfo[playerid][pCasinoChips]);
	PlayerTextDrawSetString(playerid, CasinoChips_PTD[playerid], t_string);
}
casino_OnPlayerDisconnect(playerid) {
	casino_LeaveRouletteTable(playerid);
	HideCasinoChipsPTD(playerid);
	return true;
}
casino_OnPlayerDeath(playerid) {
	casino_LeaveRouletteTable(playerid);
	return true;
}
SetPlayerPosObjectOffset(objectid, playerid, Float:offset_x, Float:offset_y, Float:offset_z)
{
	new Float:object_px,
        Float:object_py,
        Float:object_pz,
        Float:object_rx,
        Float:object_ry,
        Float:object_rz;

    GetDynamicObjectPos(objectid, object_px, object_py, object_pz);
    GetDynamicObjectRot(objectid, object_rx, object_ry, object_rz);

    new Float:cos_x = floatcos(object_rx, degrees),
        Float:cos_y = floatcos(object_ry, degrees),
        Float:cos_z = floatcos(object_rz, degrees),
        Float:sin_x = floatsin(object_rx, degrees),
        Float:sin_y = floatsin(object_ry, degrees),
        Float:sin_z = floatsin(object_rz, degrees);

	new Float:x, Float:y, Float:z;

    x = object_px + offset_x * cos_y * cos_z - offset_x * sin_x * sin_y * sin_z - offset_y * cos_x * sin_z + offset_z * sin_y * cos_z + offset_z * sin_x * cos_y * sin_z;
    y = object_py + offset_x * cos_y * sin_z + offset_x * sin_x * sin_y * cos_z + offset_y * cos_x * cos_z + offset_z * sin_y * sin_z - offset_z * sin_x * cos_y * cos_z;
    z = object_pz - offset_x * cos_x * sin_y + offset_y * sin_x + offset_z * cos_x * cos_y;

	SetPlayerPos(playerid, x, y, z);
	return 1;
}
CameraRadiusSetPos(playerid, Float:x, Float:y, Float:z, Float:degree = 0.0, Float:height = 3.0, Float:radius = 8.0)
{
	new Float:deltaToX = x + radius * floatsin(-degree, degrees);
	new Float:deltaToY = y + radius * floatcos(-degree, degrees);
	new Float:deltaToZ = z + height;

	SetPlayerCameraPos(playerid, deltaToX, deltaToY, deltaToZ);
	SetPlayerCameraLookAt(playerid, x, y, z); return 1;
}
ArraySort(array[], size) {
	new i, j, app;
	for (i = 1; i < size; i++) {
		app = array[i];
		for (j = i - 1; (j >= 0) && (array[j] > app); j--)
			array[j + 1 ] = array[j];
		array[j + 1] = app;
	}
	return 1;
}
stock strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(string)) {
	if (limit == 0)
		return 0;
	new
		sublen = strlen(search),
		replen = strlen(replacement),
		bool:packed = ispacked(string),
		maxlen = maxlength,
		len = strlen(string),
		count = 0
	;
	if (packed)
		maxlen *= 4;
	if (!sublen)
		return 0;
	while (-1 != (pos = strfind(string, search, ignorecase, pos))) {
		strdel(string, pos, pos + sublen);
 
		len -= sublen;

		if (replen && len + replen < maxlen) {
			strins(string, replacement, pos, maxlength);
			pos += replen, len += replen;
		}
		if (limit != (-1) && (++count) >= limit)
			break;
	}
	return count;
}
/*stock TranslateText(words[]) {
	new result[256];
	for (new i = 0; i < sizeof(result); i++) {
		switch (words[i]) {
			case 'а': result[i] = 'a';
			case 'А': result[i] = 'A';
			case 'б': result[i] = '—';
			case 'Б': result[i] = 'Ђ';
			case 'в': result[i] = 'ў';
			case 'В': result[i] = '‹';
			case 'г': result[i] = '™';
			case 'Г': result[i] = '‚';
			case 'д': result[i] = 'љ';
			case 'Д': result[i] = 'ѓ';
			case 'е': result[i] = 'e';
			case 'Е': result[i] = 'E';
			case 'ё': result[i] = 'e';
			case 'Ё': result[i] = 'E';
			case 'ж': result[i] = '›';
			case 'Ж': result[i] = '„';
			case 'з': result[i] = 'џ';
			case 'З': result[i] = '€';
			case 'и': result[i] = 'њ';
			case 'И': result[i] = '…';
			case 'й': result[i] = 'ќ';
			case 'Й': result[i] = '…';
			case 'к': result[i] = 'k';
			case 'К': result[i] = 'K';
			case 'л': result[i] = 'ћ';
			case 'Л': result[i] = '‡';
			case 'м': result[i] = 'Ї';
			case 'М': result[i] = 'M';
			case 'н': result[i] = '®';
			case 'Н': result[i] = 'H';
			case 'о': result[i] = 'o';
			case 'О': result[i] = 'O';
			case 'п': result[i] = 'Ј';
			case 'П': result[i] = 'Њ';
			case 'р': result[i] = 'p';
			case 'Р': result[i] = 'P';
			case 'с': result[i] = 'c';
			case 'С': result[i] = 'C';
			case 'т': result[i] = '¦';
			case 'Т': result[i] = 'Џ';
			case 'у': result[i] = 'y';
			case 'У': result[i] = 'Y';
			case 'ф': result[i] = 'Ѓ';
			case 'Ф': result[i] = 'Ѓ';
			case 'х': result[i] = 'x';
			case 'Х': result[i] = 'X';
			case 'ц': result[i] = '‰';
			case 'Ц': result[i] = '‰';
			case 'ч': result[i] = '¤';
			case 'Ч': result[i] = 'Ќ';
			case 'ш': result[i] = 'Ґ';
			case 'Ш': result[i] = 'Ћ';
			case 'щ': result[i] = 'Ў';
			case 'Щ': result[i] = 'Љ';
			case 'ь': result[i] = '©';
			case 'Ь': result[i] = '’';
			case 'ъ': result[i] = 'ђ';
			case 'Ъ': result[i] = '§';
			case 'ы': result[i] = 'Ё';
			case 'Ы': result[i] = '‘';
			case 'э': result[i] = 'Є';
			case 'Э': result[i] = '“';
			case 'ю': result[i] = '«';
			case 'Ю': result[i] = '”';
			case 'я': result[i] = '¬';
			case 'Я': result[i] = '•';
			default: result[i] = words[i];
		}
	}
	return result;
}*/


casino_Timer() {
	for (new tableid = 0; tableid < sizeof (CasinoRouletteTableInfo); tableid++) {
		if (CasinoRouletteTableInfo[tableid][tableTimer]) {
			if (CasinoRouletteTableInfo[tableid][tableActiveBets] == 0) { 
				CasinoRouletteTableInfo[tableid][tableTimer] = CASINO_ROULETTE_TABLE_TIMER + 1;
				format(t_string, sizeof (t_string), 
					"{9932CC}Рулетка\n \n\
					"colwhi"Минимальная ставка: {9932CC}%d\n\
					"colwhi"Максимальная ставка: {9932CC}%d\n \n\
					"colgrey"В ожидании первой ставки.\n \n\
					"colwhi"Нажмите {9932CC}\"ENTER\"",
					CasinoRouletteTableInfo[tableid][tableMinBet],
					CasinoRouletteTableInfo[tableid][tableMaxBet],
					CasinoRouletteTableInfo[tableid][tableTimer]
				);
			} 
			else if (--CasinoRouletteTableInfo[tableid][tableTimer] <= 0) {
				ApplyDynamicActorAnimation(CasinoRouletteTableInfo[tableid][tableActorID], "BD_FIRE", "wash_up", 4.1, 0, 1, 1, 1, 1);

				CasinoRouletteTableInfo[tableid][tableTimerDeals] = random(36) + random(10);
				CasinoRouletteTableInfo[tableid][tableTimerID] = SetTimerEx("casino_RouletteTimer", 250, false, "i", tableid);
				CasinoRouletteTableInfo[tableid][tableTimer] = 0;

				format(t_string, sizeof (t_string), 
					"{9932CC}Рулетка\n \n\
					"colwhi"Минимальная ставка: {9932CC}%d\n\
					"colwhi"Максимальная ставка: {9932CC}%d\n \n\
					"colserver"Рулетка запущена!\n \n\
					"colwhi"Нажмите {9932CC}\"ENTER\"",
					CasinoRouletteTableInfo[tableid][tableMinBet],
					CasinoRouletteTableInfo[tableid][tableMaxBet]
				);
				for (new slotid = 0, playerid; slotid < MAX_ROULETTE_TABLE_PLAYERS; slotid++) {
					playerid = CasinoRouletteTableInfo[tableid][tablePlayers][slotid];
					if (playerid == INVALID_PLAYER_ID)
						continue;
					if (pTemp[playerid][tCasinoRouletteTable] != tableid + 1) 
						continue;
					if (pTemp[playerid][tCasinoRouletteBet] == 0 && pTemp[playerid][tCasinoRouletteChipsObject] != -1) 
						DestroyDynamicObject(pTemp[playerid][tCasinoRouletteChipsObject]);
				}
			} else {
				format(t_string, sizeof (t_string), 
					"{9932CC}Рулетка\n \n\
					"colwhi"Минимальная ставка: {9932CC}%d\n\
					"colwhi"Максимальная ставка: {9932CC}%d\n \n\
					"colwhi"Запуск через "colserver"%i "colwhi"сек.\n \n\
					"colwhi"Нажмите {9932CC}\"ENTER\"",
					CasinoRouletteTableInfo[tableid][tableMinBet],
					CasinoRouletteTableInfo[tableid][tableMaxBet],
					CasinoRouletteTableInfo[tableid][tableTimer]
				);
			}
			UpdateDynamic3DTextLabelText(CasinoRouletteTableInfo[tableid][tableTextID], 0xFFFFFFFF, t_string);

			t_string[0] = EOS;
		}
	}
}
forward casino_RouletteTimer(tableid);
public casino_RouletteTimer(tableid) {
	CasinoRouletteTableInfo[tableid][tableTimerDeals]--;

	new 
		win_Line = 4, win_Color = 3,
		win_Number = random(37);

	switch (win_Number) {
		case 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36: win_Color = 1; // RED
		case 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35: win_Color = 2; // BLACK
	}
	switch (win_Number) {
		case 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36: win_Line = 3; // РЯД
		case 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35: win_Line = 2; // РЯД
		case 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34: win_Line = 1; // РЯД
	}
	new color[10];
	switch (win_Number) {
		case 0: {
			format(color, sizeof (color), "{228B22}");
			format(t_string, sizeof (t_string), "~g~%d", win_Number);
		}
		case 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36:  { 
			format(color, sizeof (color), "{DC143C}");
			format(t_string, sizeof (t_string), "~r~%d", win_Number);
		}
		case 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35: {
			format(color, sizeof (color), "{2E2E2E}");
			format(t_string, sizeof (t_string), "%d", win_Number);
		}
	}
	if (CasinoRouletteTableInfo[tableid][tableTimerDeals] <= 0) {

		new Float:objectPos[3];
		
		for (new slotid = 0, playerid; slotid < MAX_ROULETTE_TABLE_PLAYERS; slotid++) {
			playerid = CasinoRouletteTableInfo[tableid][tablePlayers][slotid];
			if (playerid == INVALID_PLAYER_ID)
				continue;
			if (pTemp[playerid][tCasinoRouletteTable] != tableid + 1) 
				continue;
			PlayerTextDrawSetString(playerid, CasinoRoulettePTD[playerid], t_string), t_string[0] = EOS;

			if (
				pTemp[playerid][tCasinoRouletteChips] <= 36 && pTemp[playerid][tCasinoRouletteChips] >= 0 && 
				win_Number == pTemp[playerid][tCasinoRouletteChips] // Числа 
			) {
				casino_OnPlayerWinRoulette(playerid, 20, win_Number, color); 
			}
			else if (
				(win_Color == 1 && pTemp[playerid][tCasinoRouletteChips] == 38) ||
				(win_Color == 2 && pTemp[playerid][tCasinoRouletteChips] == 37) // Черное или красное
			) {
				casino_OnPlayerWinRoulette(playerid, 2, win_Number, color); 
			}
			else if (pTemp[playerid][tCasinoRouletteChips] == 39 && win_Number >= 1 && win_Number <= 12) // 1-12
				casino_OnPlayerWinRoulette(playerid, 3, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 40 && win_Number >= 13 && win_Number <= 24) // 13-24
				casino_OnPlayerWinRoulette(playerid, 3, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 41 && win_Number >= 25 && win_Number <= 36) // 25-36
				casino_OnPlayerWinRoulette(playerid, 3, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 42 && win_Number >= 1 && win_Number <= 18) // 1-18
				casino_OnPlayerWinRoulette(playerid, 2, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 43 && win_Number >= 19 && win_Number <= 36) // 19-36
				casino_OnPlayerWinRoulette(playerid, 2, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 44 && win_Number >= 2 && win_Number <= 36 && IsEven(win_Number)) // Четное
				casino_OnPlayerWinRoulette(playerid, 2, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 45 && win_Number >= 1 && win_Number <= 35 && !IsEven(win_Number)) // Нечетное
				casino_OnPlayerWinRoulette(playerid, 2, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 46 && win_Line == 1) // 1 ряд
				casino_OnPlayerWinRoulette(playerid, 3, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 47 && win_Line == 2) // 2 ряд
				casino_OnPlayerWinRoulette(playerid, 3, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteChips] == 48 && win_Line == 3) // 3 ряд
				casino_OnPlayerWinRoulette(playerid, 3, win_Number, color); 
			else if (pTemp[playerid][tCasinoRouletteBet]) {
				format(t_string, sizeof (t_string), 
					"Выпало число — %s%d"colgrey". Вы проиграли {9932CC}%d фишек"colgrey"!", 
					color, win_Number, pTemp[playerid][tCasinoRouletteBet]
				);
				SendClientMessage(playerid, COLOR_GREY, t_string);
			}
			else {
				format(t_string, sizeof (t_string), 
					"Выпало число — %s%d"colgrey". Вы ничего не поставили!", 
					color, win_Number, pTemp[playerid][tCasinoRouletteBet]
				);
				SendClientMessage(playerid, COLOR_GREY, t_string);
			}
			pTemp[playerid][tCasinoRouletteChipsPos] = 0;
			pTemp[playerid][tCasinoRouletteChips] = 0;
			pTemp[playerid][tCasinoRouletteBet] = 0;

			if (pTemp[playerid][tCasinoRouletteChipsObject] != -1) 
				DestroyDynamicObject(pTemp[playerid][tCasinoRouletteChipsObject]);
			GetRouletteChipsPos(tableid, pTemp[playerid][tCasinoRouletteChipsPos], objectPos[0], objectPos[1], objectPos[2]);
			pTemp[playerid][tCasinoRouletteChipsObject] = CreateDynamicObject(1913,
				objectPos[0], objectPos[1], objectPos[2], 0.0, 0.0, 0.0, 
				CasinoRouletteTableInfo[tableid][tableWorld], CASINO_INTERIOR_ID, -1, 50, 50
			);
			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		}
		CasinoRouletteTableInfo[tableid][tableActiveBets] = 0;
		CasinoRouletteTableInfo[tableid][tableTimerDeals] = 0;
		CasinoRouletteTableInfo[tableid][tableTimerID] = -1;
		CasinoRouletteTableInfo[tableid][tableTimer] = CASINO_ROULETTE_TABLE_TIMER + 5;
	} else {
		for (new slotid = 0, playerid; slotid < MAX_ROULETTE_TABLE_PLAYERS; slotid++) {
			playerid = CasinoRouletteTableInfo[tableid][tablePlayers][slotid];
			if (playerid == INVALID_PLAYER_ID)
				continue;
			if (pTemp[playerid][tCasinoRouletteTable] != tableid + 1) 
				continue;
			PlayerTextDrawSetString(playerid, CasinoRoulettePTD[playerid], t_string), t_string[0] = EOS;
		}
		CasinoRouletteTableInfo[tableid][tableTimerID] = SetTimerEx("casino_RouletteTimer", 250, false, "i", tableid);
	}
	t_string[0] = EOS;
}
casino_OnPlayerWinRoulette(playerid, multiplier, win_Number, const color[]) {
	new win_Money = (pTemp[playerid][tCasinoRouletteBet] * multiplier) - ((pTemp[playerid][tCasinoRouletteBet] * multiplier) / 10);

	format(t_string, sizeof (t_string), 
		"Выпало число — %s%d"colgrey". Вы выиграли {9932CC}%d фишек"colgrey"!",
		color, win_Number, win_Money
	);
	SendClientMessage(playerid, COLOR_GREY, t_string);

	GiveChips(playerid, win_Money, "OnPlayerWinRoulette");

	//PlayerTextDrawSetString(playerid, casino_roulette_PTD[playerid][1], "~w~B‘ ЊOCTAB…‡… HA: ~y~-~n~~w~BAЋA CTABKA: ~g~$0");

	return true;
}

casino_PlayerTimer(playerid) {
	UpdateCasinoChipsPTD(playerid);

	if (!pTemp[playerid][tCasinoRouletteTable]) return;
	new tableid = pTemp[playerid][tCasinoRouletteTable] - 1;

	if (CasinoRouletteTableInfo[tableid][tableActiveBets] == 0 && CasinoRouletteTableInfo[tableid][tableTimer] == CASINO_ROULETTE_TABLE_TIMER + 1) {
		PlayerTextDrawSetString(playerid, CasinoRoulettePTD[playerid], "~w~WAITING FOR BETS..");
	} else {
		if (0 < CasinoRouletteTableInfo[tableid][tableTimer] <= CASINO_ROULETTE_TABLE_TIMER) {
			format(t_string, sizeof (t_string), "~y~00:%02d",
				CasinoRouletteTableInfo[tableid][tableTimer]
			);
			PlayerTextDrawSetString(playerid, CasinoRoulettePTD[playerid], t_string), t_string[0] = EOS;
		}
	}
}

casino_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (GetPlayerInterior(playerid) != CASINO_INTERIOR_ID) 
		return false;
	new bool:isReturn = false;

	if ((newkeys & KEY_SPRINT) && !(oldkeys & KEY_SPRINT)) {
		if (pTemp[playerid][tCasinoRouletteTable] && pTemp[playerid][tCasinoRouletteChipsObject] != -1) {
			new tableid = pTemp[playerid][tCasinoRouletteTable] - 1;
			if (CasinoRouletteTableInfo[tableid][tableTimer] > 1) {
				format(t_string, sizeof (t_string), 
					""colwhi"Введите сумму ставки:\n\n\
					"colgrey"Примечание:\n\
					"colgrey"- Минимальная ставка: {9932CC}%d\n\
					"colgrey"- Максимальная ставка: {9932CC}%d",
					CasinoRouletteTableInfo[tableid][tableMinBet], 
					CasinoRouletteTableInfo[tableid][tableMaxBet]
				);
				ShowPlayerDialog(playerid, D_CASINO_ROULETTE_BET, DIALOG_STYLE_INPUT, ""colserver"Рулетка", t_string, "Принять", "Отмена"), t_string[0] = EOS;
				return true;
			}
			else {
				SendClientMessage(playerid, COLOR_GREY, "Рулетка уже запущена.");
				return true;
			}
		}
	}
	if ((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)) {
		if (!pTemp[playerid][tCasinoRouletteTable]) {
			for (new tableid = 0; tableid < sizeof (CasinoRouletteTableInfo); tableid++) {
				if (GetPlayerVirtualWorld(playerid) !=  CasinoRouletteTableInfo[tableid][tableWorld]) 
					continue;
				if (!IsPlayerInRangeOfPoint(playerid, 2.5, CasinoRouletteTableInfo[tableid][tablePos][0], CasinoRouletteTableInfo[tableid][tablePos][1], CasinoRouletteTableInfo[tableid][tablePos][2] - 0.5)) 
					continue;
				casino_JoinRouletteTable(playerid, tableid);
				isReturn = true;
				break;
			}
		} else {
			TogglePlayerControllable(playerid, false);
			ShowPlayerDialog(playerid, D_CASINO_ROULETTE_EXIT, DIALOG_STYLE_MSGBOX, ""colserver"Рулетка", ""colwhi"Вы действительно хотите закончить игру?", "Да", "Отмена");
			return true;
		}
		if (isReturn) return true;
	}
	return false;
}

casino_LeaveRouletteTable(playerid) {
	if (!pTemp[playerid][tCasinoRouletteTable]) return;
	new tableid = pTemp[playerid][tCasinoRouletteTable] - 1;

	for (new slotid = 0; slotid < MAX_ROULETTE_TABLE_PLAYERS; slotid++) {
		if (CasinoRouletteTableInfo[tableid][tablePlayers][slotid] != playerid)
			continue;
		CasinoRouletteTableInfo[tableid][tablePlayers][slotid] = INVALID_PLAYER_ID;
		break;
	}
	CasinoRouletteTableInfo[tableid][tableActivePlayers]--;

	if (pTemp[playerid][tCasinoRouletteBet]) {
		CasinoRouletteTableInfo[tableid][tableActiveBets]--;
		GiveChips(playerid, pTemp[playerid][tCasinoRouletteBet], "refund Bet");
	}
	PlayerTextDrawHide(playerid, CasinoRoulettePTD[playerid]);

	pTemp[playerid][tCasinoRouletteChipsPos] = 0;
	pTemp[playerid][tCasinoRouletteChips] = 0;
	pTemp[playerid][tCasinoRouletteBet] = 0;
	pTemp[playerid][tCasinoRouletteTable] = 0;

	Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, CasinoRouletteTableInfo[tableid][tableTextID], true);

	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, true);

	if (pTemp[playerid][tCasinoRouletteChipsObject] != -1) {
		DestroyDynamicObject(pTemp[playerid][tCasinoRouletteChipsObject]);
		pTemp[playerid][tCasinoRouletteChipsObject] = -1;
	}
}
casino_JoinRouletteTable(playerid, tableid) {
	if (CasinoRouletteTableInfo[tableid][tableActivePlayers] >= MAX_ROULETTE_TABLE_PLAYERS) {
		SendClientMessage(playerid, COLOR_GREY, "Все места за данным столом полностью заняты!");
		return false;
	}
	for (new slotid = 0; slotid < MAX_ROULETTE_TABLE_PLAYERS; slotid++) {
		if (CasinoRouletteTableInfo[tableid][tablePlayers][slotid] != INVALID_PLAYER_ID)
			continue;
		CasinoRouletteTableInfo[tableid][tablePlayers][slotid] = playerid;
		break;
	}
	CasinoRouletteTableInfo[tableid][tableActivePlayers]++;

	pTemp[playerid][tCasinoRouletteTable] = tableid + 1;
	pTemp[playerid][tCasinoRouletteChipsPos] = 0;

	SendClientMessage(playerid, COLOR_GREY, "Вы присоединились к игровому столу.");
	SendClientMessage(playerid, COLOR_GREY, "Используйте "colserver"\"стрелки перемещения\""colgrey", чтобы перемещать фишку.");
	SendClientMessage(playerid, COLOR_GREY, "Используйте "colserver"\"пробел\""colgrey", чтобы сделать ставку.");

	SetPlayerCameraPos(playerid, 1950.811767 + 10.624, 1742.440917 - 717.28 - CasinoRouletteTablePos[tableid], 992.488647 + 3.5);
	SetPlayerCameraLookAt(playerid, 1950.811767 + 10.624, 1742.440917 - 717.28 - CasinoRouletteTablePos[tableid] + 0.05, 992.488647);

	Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, CasinoRouletteTableInfo[tableid][tableTextID], false);

	PlayerTextDrawSetString(playerid, CasinoRoulettePTD[playerid], " ");
	PlayerTextDrawShow(playerid, CasinoRoulettePTD[playerid]);

	if (CasinoRouletteTableInfo[tableid][tableTimer] <= 0) {
		SendClientMessage(playerid, COLOR_GREY, "Дождитесь пока закончится текущий круг..");
		pTemp[playerid][tCasinoRouletteChipsObject] = -1;
	} else {
		new Float:objectPos[3];
		GetRouletteChipsPos(tableid, pTemp[playerid][tCasinoRouletteChipsPos], objectPos[0], objectPos[1], objectPos[2]);
		pTemp[playerid][tCasinoRouletteChipsObject] = CreateDynamicObject(1913,
			objectPos[0], objectPos[1], objectPos[2], 0.0, 0.0, 0.0, 
			CasinoRouletteTableInfo[tableid][tableWorld], CASINO_INTERIOR_ID, -1, 50, 50
		);
		foreach (new i: Player) {
			if (pTemp[i][tCasinoRouletteTable] != tableid + 1) 
				continue;
			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		}
	}
	TogglePlayerControllable(playerid, false);
	return pTemp[playerid][tCasinoRouletteTable];
}
GetRouletteChipsPos(tableid, position, &Float:x, &Float:y, &Float:z) {
	if (!(0 <= position < sizeof (CasinoRouletteChipsPos)) || !(0 <= tableid < sizeof (CasinoRouletteTablePos))) 
		return;

	x = CasinoRouletteChipsPos[position][0] + 10.624;
	y = CasinoRouletteChipsPos[position][1] - CasinoRouletteTablePos[tableid] - 717.2764;
	z = 992.314331;
}
enum {
	CHIPS_MOVE_TYPE_RIGHT = 1,
	CHIPS_MOVE_TYPE_LEFT,
	CHIPS_MOVE_TYPE_DOWN,
	CHIPS_MOVE_TYPE_UP
}
stock casino_MoveRouletteChips(playerid, type) {
	if (!pTemp[playerid][tCasinoRouletteTable]) return;
	new tableid = pTemp[playerid][tCasinoRouletteTable] - 1;

	TogglePlayerControllable(playerid, false);
	switch (type) {
		case CHIPS_MOVE_TYPE_RIGHT: {
			switch (pTemp[playerid][tCasinoRouletteChipsPos]) {
				case 0: pTemp[playerid][tCasinoRouletteChipsPos] = 2;
				case 1..33: pTemp[playerid][tCasinoRouletteChipsPos] += 3;
				case 34..36: pTemp[playerid][tCasinoRouletteChipsPos] += 12;
				case 39, 40: pTemp[playerid][tCasinoRouletteChipsPos]++;
				case 42: pTemp[playerid][tCasinoRouletteChipsPos] = 44;
				case 44: pTemp[playerid][tCasinoRouletteChipsPos] = 38;
				case 38: pTemp[playerid][tCasinoRouletteChipsPos] = 37;
				case 37: pTemp[playerid][tCasinoRouletteChipsPos] = 45;
				case 45: pTemp[playerid][tCasinoRouletteChipsPos] = 43;
			}
		}
		case CHIPS_MOVE_TYPE_LEFT: {
			switch (pTemp[playerid][tCasinoRouletteChipsPos]) {
				case 1 .. 36: {
					pTemp[playerid][tCasinoRouletteChipsPos] -= 3;
					if (pTemp[playerid][tCasinoRouletteChipsPos] < 0) 
						pTemp[playerid][tCasinoRouletteChipsPos] = 0;
				}
				case 46 .. 48: pTemp[playerid][tCasinoRouletteChipsPos] -= 12;
				case 41: pTemp[playerid][tCasinoRouletteChipsPos] = 40;
				case 40: pTemp[playerid][tCasinoRouletteChipsPos] = 39;
				case 43: pTemp[playerid][tCasinoRouletteChipsPos] = 45;
				case 45: pTemp[playerid][tCasinoRouletteChipsPos] = 37;
				case 37: pTemp[playerid][tCasinoRouletteChipsPos] = 38;
				case 38: pTemp[playerid][tCasinoRouletteChipsPos] = 44;
				case 44: pTemp[playerid][tCasinoRouletteChipsPos] = 42;
			}
		}
		case CHIPS_MOVE_TYPE_DOWN: {
			switch (pTemp[playerid][tCasinoRouletteChipsPos]) {
				case 2, 3, 5, 6, 8, 9, 11, 12, 14, 15, 17, 18, 20, 21, 23, 24, 26, 27, 29, 30, 32, 33, 35, 36, 47, 48: 
					pTemp[playerid][tCasinoRouletteChipsPos]--;
				case 39: pTemp[playerid][tCasinoRouletteChipsPos] = 42;
				case 40: pTemp[playerid][tCasinoRouletteChipsPos] = 38;
				case 41: pTemp[playerid][tCasinoRouletteChipsPos] = 45;
				case 1, 4, 7, 10: pTemp[playerid][tCasinoRouletteChipsPos] = 39;
				case 13, 16, 19, 22: pTemp[playerid][tCasinoRouletteChipsPos] = 40;
				case 25, 28, 31, 34: pTemp[playerid][tCasinoRouletteChipsPos] = 41;
			}
		}
		case CHIPS_MOVE_TYPE_UP: {
			switch (pTemp[playerid][tCasinoRouletteChipsPos]) {
				case 1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26, 28, 29, 31, 32, 34, 35, 46, 47: 
					pTemp[playerid][tCasinoRouletteChipsPos]++;
				case 42, 44: pTemp[playerid][tCasinoRouletteChipsPos] = 39;
				case 37, 38: pTemp[playerid][tCasinoRouletteChipsPos] = 40;
				case 43, 45: pTemp[playerid][tCasinoRouletteChipsPos] = 41;
				case 39: pTemp[playerid][tCasinoRouletteChipsPos] = 1;
				case 40: pTemp[playerid][tCasinoRouletteChipsPos] = 13;
				case 41: pTemp[playerid][tCasinoRouletteChipsPos] = 25;
			}
		}
	}
	new Float:objectPos[3];
	GetRouletteChipsPos(tableid, pTemp[playerid][tCasinoRouletteChipsPos], objectPos[0], objectPos[1], objectPos[2]);
	SetDynamicObjectPos(pTemp[playerid][tCasinoRouletteChipsObject], objectPos[0], objectPos[1], objectPos[2]);
}

stock GetChips(playerid) 
	return pInfo[playerid][pCasinoChips];
stock GiveChips(playerid, amount, const logs[]) {
	if (amount == 0) 
		return false;
	pInfo[playerid][pCasinoChips] += amount;
	SavePlayerInteger(playerid, "pCasinoChips", pInfo[playerid][pCasinoChips]);

	if (amount < 0) 
		format(t_string, sizeof (t_string), "~p~%d", amount);
	else format(t_string, sizeof (t_string), "~p~+%d", amount);

	GameTextForPlayer(playerid, t_string, 500, 1), t_string[0] = EOS;


	return true;
	#pragma unused logs
}
stock TranslateText(const string[])
{
	new result[256];
	for(new i = 0; i < strlen(string); i++)
	{
		switch(string[i])
		{
			case 'а': result[i] = 'a';
			case 'А': result[i] = 'A';
			case 'б': result[i] = '—';
			case 'Б': result[i] = 'Ђ';
			case 'в': result[i] = 'ў';
			case 'В': result[i] = '‹';
			case 'г': result[i] = '™';
			case 'Г': result[i] = '‚';
			case 'д': result[i] = 'љ';
			case 'Д': result[i] = 'ѓ';
			case 'е': result[i] = 'e';
			case 'Е': result[i] = 'E';
			case 'ё': result[i] = 'e';
			case 'Ё': result[i] = 'E';
			case 'ж': result[i] = '›';
			case 'Ж': result[i] = '„';
			case 'з': result[i] = 'џ';
			case 'З': result[i] = '€';
			case 'и': result[i] = 'њ';
			case 'И': result[i] = '…';
			case 'й': result[i] = 'ќ';
			case 'Й': result[i] = '…';
			case 'к': result[i] = 'k';
			case 'К': result[i] = 'K';
			case 'л': result[i] = 'ћ';
			case 'Л': result[i] = '‡';
			case 'м': result[i] = 'Ї';
			case 'М': result[i] = 'M';
			case 'н': result[i] = '®';
			case 'Н': result[i] = '­';
			case 'о': result[i] = 'o';
			case 'О': result[i] = 'O';
			case 'п': result[i] = 'Ј';
			case 'П': result[i] = 'Њ';
			case 'р': result[i] = 'p';
			case 'Р': result[i] = 'P';
			case 'с': result[i] = 'c';
			case 'С': result[i] = 'C';
			case 'т': result[i] = '¦';
			case 'Т': result[i] = 'Џ';
			case 'у': result[i] = 'y';
			case 'У': result[i] = 'Y';
			case 'ф': result[i] = 'Ѓ';
			case 'Ф': result[i] = 'Ѓ';
			case 'х': result[i] = 'x';
			case 'Х': result[i] = 'X';
			case 'ц': result[i] = '‰';
			case 'Ц': result[i] = '‰';
			case 'ч': result[i] = '¤';
			case 'Ч': result[i] = 'Ќ';
			case 'ш': result[i] = 'Ґ';
			case 'Ш': result[i] = 'Ћ';
			case 'щ': result[i] = 'Ў';
			case 'Щ': result[i] = 'Љ';
			case 'ь': result[i] = '©';
			case 'Ь': result[i] = '’';
			case 'ъ': result[i] = 'ђ';
			case 'Ъ': result[i] = '§';
			case 'ы': result[i] = 'Ё';
			case 'Ы': result[i] = '‘';
			case 'э': result[i] = 'Є';
			case 'Э': result[i] = '“';
			case 'ю': result[i] = '«';
			case 'Ю': result[i] = '”';
			case 'я': result[i] = '¬';
			case 'Я': result[i] = '•';
			default: result[i] = string[i];
		}
	}
	return result;
}
stock IsEven(value)
	return (value%2 ? 0 : 1);


/*

 - Сохранение / загрузка фишек
 - Табличка инфомрации ТД в рулетке
 - Переместить покерные / блекджек столы
 - Подкорректировать позицию фишек на столах рулетки

*/