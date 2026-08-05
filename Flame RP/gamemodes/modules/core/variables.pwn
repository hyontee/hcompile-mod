
#define 	CADMIN_INFO 0x1965D9AA
#define 	HOLDING(%0) 							((newkeys & (%0)) == (%0))
#define 	PRESSED(%0) 							(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define 	RELEASED(%0) 							(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define		KEY_NUM4						(8192)
#define 	KEY_NUM6 								(16384)

#define		MAX_TELEPORTS                        	57
#define 	MAX_ACTORSS 							34
#define 	MAX_ADVERT_COUNT 						35
#define 	RES_CAR_TIME    						900


#define 	MAX_HOUSE_COUNT 						911 //кол-во домов
#define 	FAMILY_COUNT 							500	//кол-во семей
#define 	HOTEL_COUNT 							4	//кол-во отелей
#define 	AIR_COUNT 								3	//кол-во аэроп
#define 	SHOP_OBJECTS 							12	//кол-во предметов в 24/7
#define 	BINT_COUNT 								25	//кол-во интерьеров бизнесов
#define 	MAX_BUSINESS_COUNT 						150	// максимально возможное кол-во бизнесов
#define 	BUSINESS_TYPE_COUNT 					18	//кол-во типов бизнесов
#define 	SHOP_COUNT 								8	//кол-во 24-7
#define 	MAX_OST 								500 //кол-во остановок
#define 	AUTO_CP_COUNT 							63	//кол-во чекпоинтов АШ
#define	 	MAX_OBJECT_MOVED 						54	//кол-во MOVED
#define 	TP_COUNT 								136	//кол-во пикапов входы/выходы
#define 	PICKUPS_COUNT 							107	//кол-во пикапов
#define 	MAX_FUNCBIZZ							10	//кол-во функци. бизнесов
#define 	MAX_ATM 								17 //кол-во ATM
#define 	MOROZ_BALLAS 							0	//ballas
#define 	MOROZ_VAGOS 							1	//vagos
#define 	MOROZ_GROVE 							2	//grove
#define 	MOROZ_RIFA 								3	//rifa
#define 	MOROZ_AZTECAS 							4	//aztec
#define 	MAX_ATTEMPT_GANG 						5	//кол-во раз для капта
#define 	MAX_OGRAD 								500
#define 	TABLE_ACCOUNTS  	"accounts"
#define 	TABLE_ADMIN 		"admin"
#define 	TABLE_OTHERS 		"others"
#define 	TABLE_BANIP     	"banip"
#define 	TABLE_BIZZ      	"bizz"
#define 	TABLE_HOUSE     	"house"
#define 	TABLE_ATM       	"atm"
#define 	TABLE_BAN       	"ban"
#define 	TABLE_GANGZONE  	"gangzone"
#define 	TABLE_CARS      	"cars"
#define 	TABLE_GREENZONE     "greenzone"
#define 	TABLE_TICKETS     	"tickets"

/*============================================================================*/
#define VEHICLE_STATE_CAR   0
#define VEHICLE_STATE_BIKE  1
#define VEHICLE_STATE_VELIK 2
#define VEHICLE_STATE_PLANE 3
#define VEHICLE_STATE_BOAT  4

#define VEHICLE_TYPE_NONE 0
#define VEHICLE_TYPE_PLAYER 1
#define VEHICLE_TYPE_FRACTION 2
#define VEHICLE_TYPE_BIZZ 3
#define VEHICLE_TYPE_JOB 4
#define VEHICLE_TYPE_RENT 5
#define VEHICLE_TYPE_ADMIN 6
#define VEHICLE_TYPE_TRAILER 7
#define VEHICLE_TYPE_BUY 8
#define VEHICLE_TYPE_AIR 9
#define VEHICLE_TYPE_AUTOSCHOOL 10
#define VEHICLE_TYPE_SPAWN 11
#define VEHICLE_TYPE_RACE 12
#define VEHICLE_TYPE_INVENT 13
#define VEHICLE_TYPE_AUTOSALON 14
#define VEHICLE_TYPE_ALCATRAZ 15

#define VEHICLE_TYPE_RENT_NEWBIE 16

#define VIP_NONE 0
#define VIP_SILVER 1
#define VIP_GOLD 2
#define VIP_PLATINA 3
#define VIP_ECSCLUSIVE 4
//#define VIP_FOREVER 5
//#define VIP_KING 7

#define MINISTRE_NEWS 6
#define MINISTRE_MEDICS 7
#define MINISTRE_ARMY 8
#define MINISTRE_PD 9
#define MINISTRE_YUST 10
/*============================================================================*/
#define     FD(%0) (GetString(%0, FD1) || GetString(%0, FD2) || GetString(%0, FD3) || GetString(%0, FD4))

#define 	callback:%0(%1)					forward %0(%1); public %0(%1) // shit
#define 	format:%0(		    		%0[0] = EOS,format(%0,sizeof(%0),
#define 	GivePVarInt(%0,%1,%2) SetPVarInt(%0,%1,(GetPVarInt(%0,%1) + %2))

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define 	SCM     			SendClientMessage
/*============================================================================*/
#define  	DSM 			DIALOG_STYLE_MSGBOX
#define 	DSI				DIALOG_STYLE_INPUT
#define 	DSL				DIALOG_STYLE_LIST
#define 	DSP				DIALOG_STYLE_PASSWORD
#define 	DST				DIALOG_STYLE_TABLIST
#define 	DSTH			DIALOG_STYLE_TABLIST_HEADERS
/*============================================================================*/
#define dip_status_neutral 0
#define dip_status_war 1
#define dip_status_alliance 2
#define dip_status_alliance_invite 3
#define dip_status_alliance_get_invite 4
/*============================================================================*/
// for fast debug
/* new string_debug[144];
#define SCMF(%1,%2,%3)    string_debug[0] = EOS, format(string_debug,sizeof(string_debug),%3), SendClientMessage(%1,%2,string_debug) */
//
// Android
#if !defined gpci
native gpci(playerid, buffer[], size = sizeof(buffer));
#endif

#if !defined GetPlayerClientID
native GetPlayerClientID(playerid, buffer[], size = sizeof(buffer)) = gpci;
#endif

new
	Android_PlayersCount,
	PC_PlayersCount;
/*============================================================================*/
// textdraws

new 
	Text:LOGO[23],
	Text:LOGO_ANDROID,

/* 	PlayerText:mobile_local_auth[MAX_PLAYERS][5],
	PlayerText:mobile_local_register[MAX_PLAYERS][14], */

	PlayerText:work_td_local[MAX_PLAYERS][1],
	Text:work_td_global[5],

/* 	PlayerText:mobile_local_hud[MAX_PLAYERS][7],
	Text:mobile_global_hud, */

	Text:HungerFon[2],
	Text:HungerFon_ANDROID[2],
	PlayerText:HungerProgres[MAX_PLAYERS],
	PlayerText:HungerProgres_ANDROID[MAX_PLAYERS],

	Text:LoadTextures[4],
	PlayerText:LoadTexturess[MAX_PLAYERS],

	Text:skill_td[4],
	PlayerText:skill_player_td[MAX_PLAYERS][2] = {PlayerText:-1,...},

	Text:buy_skins[9],
	PlayerText:buy_player_skins[MAX_PLAYERS] = {PlayerText:-1,...},

	Text:world_time[2],

	Text:SPEEDOMETR_GLOBAL[13],
	PlayerText:SPEEDOMETR_LOCAL[MAX_PLAYERS][7],
	PlayerText:fspeed[MAX_PLAYERS][8], // speedometer pod android

	Text:td_game[6],

	PlayerText:theft_PTD[MAX_PLAYERS][2],

	PlayerText:p_mh[MAX_PLAYERS] = {PlayerText:-1,...},

	Text:AnimDraw,

	Text:ghettotablica_TD[7],
	Text:Bizwar[8],

	Text:func_bcolor[22],
	PlayerText:Captcha[29],
	PlayerText:DmArenaTextDraw[MAX_PLAYERS],
	PlayerText:RECON[MAX_PLAYERS],

	Text:CheatText[10],
	Text:CheatPanel[3],
	Text: reconMenuAndroid[9],

	Text: greenZoneTD[5];

new 
	Float: xANDROIDHUNGRY = 22.5,
	Float: yANDROIDHUNGRY = 0.0;

new bool:flying[MAX_PLAYERS]; // Admin Fly system

enum chetinfo {
	cheatid1
}
new Float:ChetInfo[10][chetinfo],
	Cheat1;	
/*============== [ Кости ] ===============*/
#define MIN_IGROKOV (2)
#define MIN_STAVKA 1000
#define MAX_STAVKA 5000000
#define MAX_TABLES_DICE 4
enum Casino_TD_Data {
	Text:Casino_TD_Set_Bet,
	Text:Casino_TD_Dice,
	Text:Casino_TD_Exit,
	Text:Casino_TD_TableNicks[MAX_TABLES_DICE],
	Text:Casino_TD_TableScore[MAX_TABLES_DICE],
	Text:Casino_TD_TableName[MAX_TABLES_DICE],
	Text:Casino_TD_Box,
	Text:Casino_TD_Enum,
	Text:Casino_TD_Lines[5],
	Text:Casino_TD_Modeled[2]
}
new Casino_TD[Casino_TD_Data],
	PlayerText:PTD_DiceStat[MAX_PLAYERS] = {PlayerText:-1,...};

#define CASINO_TEXT_STRING ""ORANGE"Стол №%d\n\n"W"Крупье: "P"   %s\n\n"W"Игрок 1:"G"   %s\n"W"Игрок 2:"G"   %s\n"W"Игрок 3:"G"   %s\n"W"Игрок 4:"G"   %s\n"W"Игрок 5:"G"   %s\n\n"W"Ставка: "ORANGE"$%d\n"W"Банк: "ORANGE"$%d\n\n"W"Статус: {EB3F36}%s\n"G"Для начала игры нажмите "W"'F'\n"
enum InfoDice_ {
	dice_gamer[5],
	dice_score[5],
	dice_stavka,
	dice_bank,
	dice_crup,
	bool:dice_game_start,
	dice_area,
	Text3D:dice_text,
	dice_game_start_time,
	dice_game_start_timer
}
new InfoDice[MAX_TABLES_DICE][InfoDice_];
new Casino_Flag[MAX_PLAYERS][6];

#define show_casino_td 0
#define select_casino_table 1
#define casino_crup 2
#define casino_bet_cash 3

//////////////////////////////////////////////////////////////////
enum dialogs
{
	D_NONE1, // for android
	D_NONE2, // for android
	D_LOGIN,
	D_REG,
	D_REG_MAIL,
	D_REG_FRIEND,
	D_REG_SEX,

	D_HOUSE,
	D_HOUSE_BUY,
	D_HOUSE_BUY_2,
	D_HOUSE_SELL,
	D_HOUSE_MENU,
	D_HOUSE_EXIT,
	D_HOUSE_CARSELL,
	D_HOUSE_CARSELL_2,
	D_HOUSE_IMPROVE,
	D_HOUSE_IMPROVE_2,
	D_HOUSE_STATS,
	dStore,
	dStorePut,
	dStoreGet,
	dStoreDress,
	dStoreSkin,
	dSafe,
	dSafeCode,
	dSafeCodeChange,
	dSafeCodeChange2,
	dSafeAction,
	dSafePutMoney,
	dSafeGetMoney,
	dSafePutDrug,
	dSafeGetDrug,
	dFreez,
	dFreezPut,
	dArendator,
	dZhitelSettings,
	dArendatorAction,
	dArendatorSettings,
	dRentMenu,

	D_HOTEL_BUY,
	D_HOTEL_BUY_2,
	D_HOTEL,
	D_HOTEL_OWNER,
	D_HOTEL_BANK,
	D_HOTEL_PRICE,
	D_HOTEL_SELL,
	D_HOTEL_RECEPTION,
	D_HOTEL_RECEPTION_2,
	D_HOTEL_ROOM_BUY,
	D_HOTEL_LIFT_1,
	D_HOTEL_LIFT_2,
	D_HOTEL_OPLATA,
	D_HOTEL_NORENT,

	D_AIRPORT,
	D_AIRPORT_BANK,
	D_AIRPORT_PRICE,
	D_AIRPORT_BUY,
	D_AIRPORT_BUY_2,
	D_AIRPORT_SELL,

	D_GREENZONE,
	D_GREENZONE_ADD,
	D_GREENZONE_EDIT,
	D_GREENZONE_EDIT_NAME,
	D_GREENZONE_EDIT_DIST,

	D_HOUSE_ADD,
	D_HOUSE_KLASS,
	D_HOUSE_PRICE,
	D_HOUSE_INT,
	D_HOUSE_INT_1,

	D_BAND_STOCK,
	D_BAND_STOCK_PUT_MONEY,
	D_BAND_STOCK_INPUT_MONEY,
	D_BAND_STOCK_PUT_MATS,
	D_BAND_STOCK_INPUT_MATS,
	D_BAND_STOCK_PUT_DRUGS,
	D_BAND_STOCK_INPUT_DRUGS,

	D_REPORT,
	D_JURIST,
	D_MATERIALS_BUY,
	D_CLIST,
	D_MENU,
	D_MENU_SETTING,
	D_MENU_COMMANDS,
	D_CHAT,
	D_NEWS_SELECT,
	D_NEWS_SELECT_2,
	D_BOX,
	D_BOX_2,

	D_ALOGIN,

    D_BIZZ_BUY,
	D_BIZZ_BUY_2,
	D_BIZZ_BUY_FILL,
    D_BIZZ_UPDATE,
	D_BIZZ_UPGRADE,
    D_BIZZ,
	D_BIZZ_2,
	D_BIZZ_3,
    D_BIZZ_STATS,
    D_BIZZ_24,
    D_BIZZ_SIM,
    D_BIZZ_TAVERN,
    D_BIZZ_BAR,
	D_BIZZ_FISH,
	D_BIZZ_COMP,
	D_COMP_GAME,
	D_COMP_GAME_1,
	D_COMP_GAME_2,
	D_COMP_GAME_3,
	D_BIZZ_BANK,
	D_BIZZ_BANK_INPUT,
	D_BIZZ_BANK_PUT,
	D_BIZZ_PRICE,
	D_BIZZ_ENTER,
	D_BIZZ_ENTERS,
	D_BIZZ_SELL,
	dBusinessProd,
	dBusinessProd2,
	D_AMMO,
	D_AMMO_2,

	dBuyCarSalon,
	D_FIXCAR,

	D_BOOK,
	D_BOOK_2,
	D_BOOK_3,
	D_BOOK_4,

	D_CALL_SERVICESS,

	D_STOP_LOAD,

	D_CONTROL_EDIT,
	D_ACCOUNT_RECOVERY,
	D_CHANGE_PASS,
	D_CHANGE_PASS_SELECT,
	D_CHANGE_NAME,
	dCode,
	dChangeCode,
	dCodeChange1,
	D_MAIL_CONTROL,
	D_MAIL_CONTROL_VERIFICATION, // 136 dialogid
	D_MAIL_CONTROL_OFFER,
	D_MAIL_CONTROL_SETACCEPT,

	D_BAN_LIST,
	D_UNBAN,

	D_TRUNK_LIST,
	D_TRUNK_SELECT,
	D_TRUNK_INPUT,
	D_TRUNK_PUT,

    D_TP_LIST,
	D_TP_LIST_2,
    D_TP_HOUSE,

	D_NEWS,
	D_NEWS_ETHER,
	D_NEWS_ETHER_PRICE,
    D_ADVERT_LIST,
    D_ADVERT_LIST_EDIT,
    D_ADVERT_START,

	D_ADMIN_HISTORY,
	D_ADMIN_HISTORY_USE,
	D_ADMIN_PANEL,
	D_ADMIN_OSNOVA,

    D_OBC_LIST,
    D_OBC_WANTED,
    D_OBC_PATRUL,
	D_OBC_SERVICESS,
	D_OBC_SERVICESS_INV,
	D_OBC_BD,
	D_OBC_BD_NAME,
	D_OBC_BD_NUMBER,

	D_MEDICS,
	D_MEDICS_INV,

	D_REPAIRS,
	D_REPAIRS_INV,

    D_MAKELEADER_INFO,
    D_MAKELEADER_LIST,
    D_MAKELEADER_ADD,
    D_MAKELEADER_CLEAR,
    D_MAKELEADER,

    D_TEMPLEADER_CHOOSE,

	D_BLACK_MARKET,
	D_BLACK_MARKET_DRUGS,
	D_BLACK_MARKET_MATS,
	D_BLACK_MARKET_ARMOUR,
	D_BLACK_MARKET_SKIN,

	D_MARKET_NARKO,
	D_MARKET,
	D_MARKET_ARMOUR,
	D_MARKET_SKIN,
	D_MARKET_GUN,
	D_MARKET_GUN_BUY,
	D_MARKET_BUY,
	D_MARKET_NARKO_SELL,
	D_MARKET_MATS_SELL,

	D_MAKEGUN,
	D_MAKEGUN_2,

    D_JOB,
    D_JOB_GUNS,
	D_JOB_GUNS_1,
	D_JOB_OIL,
	D_JOB_OIL_1,
	D_JOB_SAD,
	D_JOB_SAD_1,
	D_JOB_FISH,
	D_JOB_WOOD,
	D_JOB_WOOD_1,
	D_JOB_LOADER,
	D_JOB_LOADER_1,
	
	D_JOB_MINE,
	D_JOB_MINE_1,

	D_ARENDA,

	D_FAMILY,
	D_FAMILY_INFO,
	D_FAMILY_CREATE,
	D_FAMILY_NAME,
	D_FAMILY_STORE,
	D_FAMILY_STORE_1,
	D_FAMILY_STORE_2,
	D_FAMILY_STORE_3,
	D_FAMILY_SET,
	D_FAMILY_SET_RANK,
	D_FAMILY_ERANK_1,
	D_FAMILY_ERANK_2,
	D_FAMILY_COLOR,
	D_FAM_RANK,

	D_BUY_SKIN,
	D_BUY_SKIN_2,

	D_AUTOSCHOOL_1,
	D_AUTOSCHOOL_2,
	D_LICENSES,

	D_UNIVERSITY,
	D_UNIVERSITY_1,

	D_BANK,
	D_BANK_ACTIVE,
	D_BANK_OPEN,
	D_BANK_AUTORISATION,
	D_BANK_TOP,
	D_BANK_LIST,
	D_BANK_INPUT,
	D_BANK_PUT,
	D_BANK_TRANSFER_ONE,
	D_BANK_TRANSFER_TWO,
	D_BANK_TRANSFER_THREE,
	D_BANK_CHANGE_PIN,
	D_BANK_CHANGE_NAME,
	D_BANK_GLOBAL,
	D_BANK_GLOBAL_LIST,
	D_BANK_GLOBAL_PUT,
	D_BANK_GLOBAL_INPUT,
	D_BANK_OPLATA,
	D_BANK_OPLATA_HOUSE,
	D_BANK_OPLATA_BIZZ,
	D_BANK_OPLATA_HOTEL,
	D_BANK_OPLATA_AIRPORT,

	dBusRent,
	dBusChangeRoute,
	dBusChangePrice,
	D_SPAWN,
	D_ARMY_CARM,
	D_ARMY_CARM_SF,
	D_BUKSIR,
	dProdRent,
	dProdGet,
	dProdPut,
	dProdList,
	dProdSell,

	D_BUY_CAR,
	D_BUY_CAR_2,
	D_AUTOSALON,

	D_MEDCARD,
	D_MEDSEX,

	D_SU,
	D_SU_2,

	D_TAZER,

	dInviteSkin,
	dFractionSkin,
	dRank,

	dBizList,

	D_TAXIST,

	D_CAPTURE,
	D_BIZWAR,

	D_ANIM,
	D_TAKE,

	D_ATM,
	D_ATM_INPUT,
	D_ATM_PUT,
	D_ATM_PHONE,

	D_TICKET,
	D_TICKET_1,
	D_TICKET_2,
	D_TICKET_3,

	D_SHOWALL,

	D_TIPSTER,

	D_FUEL,
	D_FUEL_2,
	D_BUY_FUEL,

	D_EXAM,

	D_CHANGECAR,
	D_CAR_BUY,

	D_SET_BET,

	D_MAFIA_STOCK,
	D_MAFIA_STOCK_PUT_MONEY,
	D_MAFIA_STOCK_INPUT_MONEY,
	D_MAFIA_STOCK_PUT_NARKO,
	D_MAFIA_STOCK_INPUT_NARKO,
	D_MAFIA_STOCK_PUT_MATS,
	D_MAFIA_STOCK_INPUT_MATS,

	D_LMENU,
	D_LMENU_RANK,
	D_EDIT_RANK_1,
	D_EDIT_RANK_2,
	D_LMENU_TEXT,
	D_LMENU_BANK,
	D_LMENU_BANK_INPUT,

	D_CASINO,

	D_COP_ARREST,

	D_DONATE,
	D_DONATE_CONVERT,
	D_DONATE_CHANGENAME,
	D_DONATE_VIP,
	D_DONATE_UNWARN,
	D_DONATE_ZAKON,
	D_DONATE_LICENSES,
	D_DONATE_SKILLS,
	D_DONATE_SATIETY,
	//D_DONATE_DISEASE,

	D_BIZZ_TAXI,
	D_BIZZ_TAXI_ZAM,
	D_BIZZ_TAXI_CAR,
	D_BIZZ_TAXI_CAR_2,
	D_BIZZ_TAXI_CAR_3,
	D_BIZZ_TAXI_NAME,
	D_BIZZ_TAXI_NAMECAR,
	D_BIZZ_TAXI_TARIF,
	D_BIZZ_TAXI_TARIF_2,
	D_BIZZ_TAXI_PERCENT,
	D_BIZZ_TAXI_PHONE,
	D_BIZZ_TAXI_MEM,
	D_BIZZ_TAXI_MEM_2,
	D_BIZZ_TAXI_INFO,

	D_TAXI_CALL,
	D_TAXI_COUNT,
	D_TAXI_WAYCHOICE,
	D_TAXI_WAYCHOICE_GPS,

	D_GPS,
	D_GPS_O,
	D_GPS_WORK,
	D_GPS_GOS,
	D_GPS_NOLEGAL,
	D_GPS_AUTOSALON,
	D_GPS_BANK,
	D_GPS_BIZZ,
	D_GPS_HOTEL,
	D_GPS_AIRPORT,
	D_GPS_TAXI,
	D_GPS_GAME,
	D_GPS_RIELTOR,

	D_ADDHOUSE,
	D_EDIT_HOUSE_CLASS,

	DIALOG_ATM_EDIT,
	DIALOG_ATM_EDIT_DELETE,

	D_FREE,

	D_ECONOMY,
	D_ECONOMY_GUN,
	D_ECONOMY_OIL,
	D_ECONOMY_APPLE,
	D_ECONOMY_WOOD,
	D_ECONOMY_LOADER,
	D_ECONOMY_ALCO,
	D_ECONOMY_BIZZ,
	D_ECONOMY_NALOG,
	D_ECONOMY_SALARY,
	D_ECONOMY_SALARY_1,
	D_ECONOMY_SALARY_2,
	D_ECONOMY_PREM,
	D_ECONOMY_PREM_1,
	D_ECONOMY_PUT,
	D_ECONOMY_INPUT,
	D_ECONOMY_MINE,

	D_MAKELEADER_WH,

	D_REC_KICK,
	D_REC_WARN,
	D_REC_BAN,

	D_ELECTION,
	D_ELECTION_1,
	D_ELECTION_2,
	D_ELECTION_3,

	D_MAYOR,
	D_MAYOR_BLAGO,

	dRentCar,

	D_COP_GUN,
	D_FBI_GUN,

	dGiveGunTD,
	dFContract,
	dRefill,

	D_MARRIED,
	D_BUYNARKO,

	D_ADMC,
	D_YOUTUBE_CMD,

	D_NEWS_LIFT, 
	D_MP,
	D_MP_1,
	D_MP_2,
	D_MP_3,

	D_DISEASE,
	D_DISEASE_2,

	D_ANTICHEAT,

	D_QUEST,
	D_QUEST_1,
	D_QUEST_2,
	D_QUEST_3,

	DIALOG_BAN,

	D_RIELTOR,
	D_RIELTOR_HOUSE,
	D_RIELTOR_HOUSE_2,

	D_RIELTOR_BIZZ,
	D_RIELTOR_BIZZ_2,

	D_VEH_NUMBER,
	D_VEH_NUMBER_2,

	D_WORK,

	D_RADIO,

	D_BL,
	D_BL_ADD,
	D_BL_DELL,
	D_BL_ADD_REASON,
	D_BL_ALL,

	D_QUEST_GANG,

	D_ARMY_CARM_SF_2,
	D_ARMY_CARM_SF_3,
	D_ARMY_CARM_SF_4,
	D_ARMY_CARM_SF_5,
	D_ARMY_CARM_SF_6,
	D_ARMY_CARM_SF_7,

	D_REFERALS,

	D_BIZZ_TK,
	D_BIZZ_TK_ZAM,
	D_BIZZ_TK_MEM,
	D_BIZZ_TK_MEM_2,
	D_BIZZ_TK_INFO,

	D_TRUCK,
	D_TRUCK_2,
	D_TRUCK_3,
	D_TRUCK_UNLOAD,
	D_TRUCK_UNLOAD_2,
	D_TRUCK_UNLOAD_3,

	D_GPS_TK,

	D_ADMIN_TK,
	D_ADMIN_TK_1,
	D_ADMIN_TK_2,
	D_ADMIN_TK_3,
	D_ADMIN_TK_4,

	D_BAND_GUN,
	D_BAND_GUN_1,
	D_BAND_GUN_2,
	D_BAND_GUN_3,
	D_BAND_GUN_4,
	D_BAND_GUN_5,
	D_BAND_GUN_6,
	D_BAND_GUN_7,

	D_HEAL,

	D_FAMILY_OFFLINE,

	D_SPY,
	D_SPY_2,
	D_FBI_LIFT_1,
	D_FBI_LIFT_2,

	D_DUEL,
	D_DUEL_1,

	D_REPORT_1,
	D_REPORT_2,
	D_REPORT_3,
	D_REPORT_4,

	D_DONATE_ARREST,

	D_LEAVE,

	D_BIZZ_BO,
	D_BIZZ_BO_ZAM,
	D_BIZZ_BO_PERCENT,
	D_BIZZ_BO_PERCENT_2,
	D_BIZZ_BO_PERCENT_3,

	D_BIZZ_BO_BANK,
	D_BIZZ_BO_BANK_2,
	D_BIZZ_BO_BANK_3,

	D_ADMIN_TIME,

	D_ZBT,
	D_ZBT_1,

	D_BIZZ_4,

	dEatRent,
	dEContract,
	dEHotDog,

	D_AUTOSCHOOL_3,
	D_AUTOSCHOOL_4,

	D_MP_4,
	D_MP_5,

	D_TUNE_UPDATE,

	D_PLAYER_HISTORY,
	D_PLAYER_HISTORY_USE,
	D_AMEMBERS,

	D_LAB,
	D_LAB_2,

	D_FAKEPASS,

	D_ADMIN_INVITE,
	D_ADMIN_INVITE_2,

	D_BUYACS,
	D_BUYACS_2,
	D_BUYACS_3,
	D_BUYACS_4,
	D_BUYACS_5,

	D_ASK,
	D_ASK_1,

	D_GAME_DM,
	D_GAME_DM_2,

	D_GAME_RACE,
	D_GAME_RACE_2,

	D_BAND_DRUGS,
	D_BAND_DRUGS_2,

	D_MAFIA_CARM,
	D_MAFIA_CARM_2,
	D_MAFIA_CARM_3,

	D_GIVE,
	D_GIVE_2,

	D_REPAIR,
	D_REPAIR_LIST,

	D_ADVERT_LIST_2,

	D_GAME_GOLOD,
	D_GAME_GOLOD_2,

	D_VACANCY,
	D_VACANCY_2,
	D_VACANCY_3,

	D_DIPLOMATION,
	D_DIPLOMATION_2,

	D_OBJ,
	D_OBJ_2,
	D_OBJ_3,
	D_OBJ_4,
	D_OBJ_5,

	D_BUY_CAR_DONATE,
	D_BUY_CAR_DONATE_2,

	D_TUNE_LIST,
	D_PERF_ENGINE,
	D_PERF_ENGINE_2,
	D_PERF_BRAKE,
	D_PERF_BRAKE_2,
	D_BIZWAR_CONFIRM,
	D_DJMSG,
	D_DJMAKE,
	D_SELL_SIM,

	D_ECONOMY_PENS,
	D_ECONOMY_PENS_1,
	D_ECONOMY_PENS_2,

	D_FIND,
	D_SHOWALL_2,

	D_BONUSES,

	D_GANG_PAY,

	D_FAMILY_UPDATE,
	D_FAMILY_UPDATE_2,
	D_FAMILY_HOUSE,
	D_FAMILY_TEXT,
	D_FAMILY_CREATE_2,
	D_FAMILY_CREATE_3,

	D_CONNECT_RETURN_BACK,
	D_DONATE_POINT,
	D_BIZZ_MEDKIT,
	D_BIZZ_MEDKIT_2,
	D_BIZZ_MEDKIT_3,
	D_BIZZ_MEDKIT_4,

	D_AUTONEWS,
	D_AUTONEWS_BUY,
	D_AUTONEWS_SELL,
	D_AUTONEWS_CHANGE,
	D_AUTONEWS_BUY_HOUSE,
	D_AUTONEWS_BUY_HOUSE_2,
	D_AUTONEWS_BUY_HOUSE_3,
	D_AUTONEWS_BUY_BIZZ,
	D_AUTONEWS_BUY_BIZZ_2,
	D_AUTONEWS_BUY_HOTEL,
	D_AUTONEWS_BUY_AIRPORT,
	D_AUTONEWS_BUY_CAR,
	D_AUTONEWS_BUY_CAR_2,
	D_AUTONEWS_BUY_CAR_3,
	D_AUTONEWS_BUY_CAR_4,
	D_AUTONEWS_BUY_SIM,
	D_AUTONEWS_BUY_SIM_2,
	D_AUTONEWS_BUY_SIM_3,
	D_AUTONEWS_BUY_MOTO,
	D_AUTONEWS_BUY_MOTO_2,
	D_AUTONEWS_SELL_HOUSE,
	D_AUTONEWS_SELL_HOUSE_2,
	D_AUTONEWS_SELL_HOUSE_3,
	D_AUTONEWS_SELL_BIZZ,
	D_AUTONEWS_SELL_BIZZ_2,
	D_AUTONEWS_SELL_HOTEL,
	D_AUTONEWS_SELL_AIRPORT,
	D_AUTONEWS_SELL_CAR,
	D_AUTONEWS_SELL_CAR_2,
	D_AUTONEWS_SELL_CAR_3,
	D_AUTONEWS_SELL_CAR_4,
	D_AUTONEWS_SELL_MOTO,
	D_AUTONEWS_SELL_MOTO_2,
	D_AUTONEWS_SELL_SIM,
	D_AUTONEWS_SELL_SIM_2,
	D_AUTONEWS_SELL_SIM_3,
	D_AUTONEWS_CHANGE_HOUSE,
	D_AUTONEWS_CHANGE_HOUSE_2,
	D_AUTONEWS_CHANGE_BIZZ,
	D_AUTONEWS_CHANGE_CAR,
	D_AUTONEWS_CHANGE_CAR_2,
	D_AUTONEWS_CHANGE_CAR_3,
	D_AUTONEWS_CHANGE_MOTO,
	D_AUTONEWS_CHANGE_SIM,
	D_AUTONEWS_CHANGE_SIM_2,
	D_AUTONEWS_SERVICES,
	D_AUTONEWS_SERVICES_2,

	D_AMMOSG,

	D_ROB_CAR,
	D_STOP_LOAD_ROBHOUSE,

	D_DUEL_MONEY,
	D_DUEL_HEALTH,
	D_DUEL_ARMOUR,
	D_DUEL_2,
	D_DUEL_PASSWORD,
	D_DUEL_ENTER_PSW,
	D_DUEL_3,
	D_DUEL_4,
	D_DUEL_5,

	D_BIZZ_5,

	D_THEFT,
	D_THEFT_LIST,

	D_LMENU_2,
	D_GANGTOP,

	dEndWork,
	D_JOB_CLEAR,
	D_JOB_CLEAR_2,
	D_JOB_CLEAR_3,

	D_JOB_GAZON,
	D_JOB_GAZON_2,
	D_JOB_GAZON_3,
	D_JOB_GAZON_4,

	D_DONATE_ZV,
	D_DONATE_DISEASE,
	D_DONATE_BANK,
	D_DONATE_BANK_2,
	D_DONATE_BANK_3,
	D_DONATE_SKIN,
	D_DONATE_BOX,
	D_DONATE_TUNE_CAR,
	D_DONATE_TUNE_CAR_2,
	D_DONATE_NUMBER,
	D_DONATE_NUMBER_2,
	D_DONATE_BLACK,
	D_DONATE_BLACK_2,
	D_DONATE_BLACK_3,
	D_DONATE_UNMUTE,
	D_DONATE_UNBAN,
	D_DONATE_UNNARK,
	D_DONATE_JOB,
	D_DONATE_VIP_SILVER,
	D_DONATE_VIP_GOLD,
	D_DONATE_VIP_PLATIN,
	D_DONATE_VIP_ECSCLUSIVE,
	D_DONATE_CHANGENAME_2,

	D_BOOMBOX_MENU,
	D_BOOMBOX_INPUT_LINK,
	D_RENT_SPAWN_LS,
	D_FAQ,
	D_SHOWSTATS,
	D_HOUSE_BUYINT,
	D_HOUSE_BUYINT_2,
	// D_HUD_CHOOSEGUN,
	D_CREATE_PROMO,
	D_CREATE_PROMO_SETTINGS,
	D_CREATE_PROMO_SETTINGS_2,
	D_CREATE_PROMO_SETTINGS_3,
	D_CREATE_PROMO_SETTINGS_4,
	D_CREATE_PROMO_SETTINGS_5,
	D_PROMO_ACTIVATION,

	DIALOG_NONE = 32767

};
enum carInfo {
	carID[2],
	carModel[2],
	carColor_one[2],
	carColor_two[2],
	Float:carDrived[2],
	Float:carFuel[2],
	carVehcom_1[2],
	carVehcom_2[2],
	carVehcom_3[2],
	carVehcom_4[2],
	carVehcom_5[2],
	carVehcom_6[2],
	carVehcom_7[2],
	carVehcom_8[2],
	carVehcom_9[2],
	carVehcom_10[2],
	carVehcom_11[2],
	carVehcom_12[2],
	carVehcom_13[2],
	carVehcom_14[2],
	carOpen[2],
	carNarko[2],
	carDeagle[2],
	carM4[2],
	carAK47[2],
	carShot[2],
	carKanistra[2],
	carMats[2],
	carPaintJob[2],
	carPEngine_1[2],
	carPEngine_2[2],
	carPEngine_3[2],
	carPEngine_4[2],
	carPEngine_5[2],
	carPBrake_1[2],
	carPBrake_2[2],
	carPBrake_3[2],
	carPBrake_4[2],
	carPBrake_5[2]
};
new gPlayerCars[MAX_PLAYERS][carInfo],
	NumberVehicle[MAX_PLAYERS][2][10];

enum trunkInfo {
	tGun[4],
	tDrugs,
	tMats,
	tNarko,
	tKanistra,
	tOpen
};
new TrunkInfo[MAX_VEHICLES][trunkInfo];

new player_ip[MAX_PLAYERS][16],
	player_ip_check[MAX_PLAYERS][16],
	player_name[MAX_PLAYERS][24],
	player_pass[MAX_PLAYERS][64];

enum pInfo {
	pID,
	pEmail[36],
	pEmailStatus,
	pLevel,
	pAdmin,
	pYoutube,
	pJail,
	pIpReg[18],
	pKeyip[5],
	Float:pHP,
	pDataReg[32],
	pHouse,
	pTempKey,
	pRoom,
	pHotel,
	pAirport,
	pBusiness,
	pMats,
	pSex,
	pArrested,
	pMute,
	pCrimes,
	pExp,
	pCash,
	pSalary,
	pJailTime,
	pDrugs,
	pLeader,
	pMember,
	pRank,
	pSkin,
	pJob,
	pFracSkin,
	pPhone,
	pZakonp,
	pAddiction,
	pWarns,
	punWarnstime,
	pFuel,
	pMarried[MAX_PLAYER_NAME],
	pDrug[MAX_PLAYER_NAME],
	pBank,
	pMobile,
	pSearch,
	pGunSkill[6],
    pPlayTime,
    pAccusedof[44],
    pVictim[MAX_PLAYER_NAME],
	pHospital,
	pWatch,
	pRod,
	pRopes,
	pWorms,
	Float:pFish,
	pRouble,
	pFamily,
	pProgress,
	pBook,
	pPhoneNumber[25],
	pSpawn,
	pMedCard,
	pSettings[11],
	pMedHeal,
	pAdvert,
	pArmSkin,
	bizz_work,
	bizz_status,
	bizz_cash,
	bizz_lcash,
	pGolos,
	pBlago,
	pVips,
	pVipTime,
	pVipName,
	pfWarn,
	pDisease[2],
	pSatiety,
	pFamRank,
	pDSatiety,
	pDDisease,
	pBox,
	Float:pSnow,
	pMedKit,
	pAdmMSG,
	pAdmKL,
	pMask,
	Float:pX,
	Float:pY,
	pSellNeed[5],
	pVipAdd,
	pGunLic,
	pDrugInv,
	pHelper,
	pBoomBox,
	pSlotItem[8],
	pSlotItem_Use[8],
	pAsk,
	pInstrument,
	pAskmute,
	pJemmy,
	ptheftSkill, //угон
	ptheftExp, // угон
	ptheftTime, //угон
	ptheftHome, //угон
	pFMute,
	pDonateBank,
	pPromoUsed,
};
new PI[MAX_PLAYERS][pInfo],
	pPhoneName[MAX_PLAYERS][25][MAX_PLAYER_NAME],
	lic[MAX_PLAYERS][64],
	start_work[MAX_PLAYERS],
	gOnlinePlayer[MAX_PLAYERS][2],
	gOnlinePlayerAFK[MAX_PLAYERS][2];


//Радиоведущие //DJ
new DJlvl[MAX_PLAYERS];
new DJname[MAX_PLAYERS][25];
new DJmsg;

enum tInfo {
	tAFK,
	tSelectHouse,
	bool:tInHouse,
	bool:tTPpick,
	bool:tLogin,
	bool:tJoined,
	bool:tPhone,
	bool:tSpawn,
	bool:tSpectate,

	tSelectedBusinessID,

	tStoreGun,

	tArendaCar,
	tTaxiPrice,
	tTaxiTurn,
	bool:tTaxiGoing,
	Float:tTaxiStart,
	tTaxiPass,
	tSalonInfo[2],
	tKubik,
	tSpectr,
	preOrg,
	preOrgg,
	Float:Admin_X,
	Float:Admin_Y,
	Float:Admin_Z,
	pOldSkin,
	bool:tDialog,
	tPhoneCalled,
	tPhoneCaller,
	bool:tPhoneNews,
	bool:tTazer,
	tCuffedTime,
	tCuffed,
	bool:tTied,
	bool:tGag,
	tGagTime,
	tSpcarTime,
	bool:tEther,
	bool:tJobOil[2],//0 - работа, 1 - объект
	tJobSalary,
	tGunArea[4],// 0 - gungs_arena, 1 - KillsGun, 2 - KillsAll, 3 - NextGun
	tDMArea[3], // 0 - dm_arena, 1 - KillsPlayer, 2 - DeathsPlayer
	tJobSad[4], // 0 - sad_work, 1 - use_sad, sad_kg,sad_all
	tJobGun[3], // 0 - job_gun, 1 - gun_blank, 2 - gun_collected
	tJobWood[4], // 0 - wood_work, 1 - WoodCheckpointTop, 2 - WoodDrop, 3 - PlayerUseBox
	tJobLoader[3], // 0  - work , 2 - carry, 3 - count carry
	tJobMine[2], // 0  - work,  1 - count carry
	tMaskTime,
	bool:tBlockWars,
	tMask,
	tLoginTime,
	tAlcotraz[3], // 0 - alcatraz_time,1 - alcatraz_maniken, 2 - alcatraz_knife
	tTrucker[4], // 0 - quantity_tk, 1 - tk_unload, 2 - tk_unload_price, 3 - attach_trailer_2
	tOilObject,
	tTazers[3], // 0 - tazertime, 1 - tazershot, 2 - player
	bool:tPhoneOnline,
	tFight,
	bool:tGym,
	tClothesWork[2],// 0 - работа, 1 - заготовка
	tProcess[2],// 0 - выполнено, 2 - максимум
	tDuel,
	tDuelLobby,
	tArendKey,
	bool:tShowKeys,
	tAntiDM,
	tMasked,
	tFakePass,
	Float:tGyms,
	tGymSkill,
	tNewYear[2],
	bool:tHeal,
	bool:tEnter[MAX_FRACTIONS+1],
	tAutoSchool,
	loadingMode,
	loadingModelPlayer,
	tACflood,
	bool:tHelperDuty,
	bool:tSelectSkin,
	tUpdate,
	Float:tArmour,
	tCashDM,
	tCashRace,
	tDiceID,
	tDiceIDs,
	tDiceMoney,
	bool:tDiceClosed,
	tDiceTime,
	bool:tTir,
	tSLimit,
	tVirtualWorld,
	tInterior,
	tRaceID,
	tRaceLeftStartTime,
	tRaceMoney,
	tRaceRandom,
	tRaceCP,
	pAndroid
}
new TI[MAX_PLAYERS][tInfo];

enum action_info {
	act_skill,
	act_exp,
	act_sport,
	act_mp,
	act_gun,
	act_fish,
	act_renthotel,
	act_buyskin,
	act_buycar,
	act_rentcar,
	act_buylic,
	act_buyimprove,
	act_disease,
	act_changesex,
	act_medcard,
	act_buynubmbercar,
	act_perfomance,
	act_tune,
	act_payday,
	act_donate,
	act_level,
	act_time,
	act_select
}
new 
	string_1024[1024],
	string_2048[2048];

new BonusInfo[action_info];
enum vip_info {
	vip_payday,
	vip_carlic,
	vip_lvl,
	vip_healtime,
	vip_arrest,
	vip_mute,
	vip_admins,
	vip_mask_time,
	vip_armmats,
	vip_search,
	vip_heal,
	vip_mask,
	vip_fuel,
	vip_jimmy,
	vip_mats,
	vip_drugs,
	Float:vip_satiety,
	vip_fam_point,
	vip_transfer_bank,
	vip_percent_job,
	vip_percent_pension,
	vip_percent_startjob,
	vip_flylic,
	vip_fixcar,
	vip_fine,
	vip_hotel,
	vip_chose,
	vip_buycar,
	vip_rentcar,
	vip_houseupdate,
	vip_changesex,
	vip_number,
	vip_perfonans,
	vip_tune,
	vip_hp,
	vip_useheal,
	vip_changename,
	vip_gunlic,
	vip_radar,
	vip_report,
	vip_ad,
	vip_enterbizz,
	vip_vad,
	vip_sms,
	vip_disease,
	vip_pay,
	vip_chat,
	vip_call,
	vip_report_color
};
new vip_status[7][vip_info];

new object_park_ls[321];

new timer_job_mower[MAX_PLAYERS];
new timer_job[MAX_PLAYERS];
//количество убранных чекпоинтов по зонам
new check_verona_beach;
new check_white_house;
new check_medic_ls;
new check_glenpark_1;
new check_glenpark_2;

new bool: status_check_job_mower[321] = { false, ... };
new bool: status_restore_check_job_mower[321] = { false, ... };
new Float:check_job_mower[321][7]= {
	{484.773346, -1783.324585, 5.595574, 0.000000, 0.000000, 191.964981},//Участок №1 Verona Beach -- 46 начало
	{497.478088, -1784.695557, 5.166778, 0.000000, 0.000000, 195.474335},
	{497.495911, -1794.405518, 5.395043, 0.000000, 0.000000, 165.644714},
	{550.602966, -1805.766113, 5.412500, 0.000000, 0.000000, 170.031387},
	{550.469299, -1817.875122, 5.412500, 0.000000, 0.000000, 170.031387},
	{559.160828, -1820.898560, 5.412500, 0.000000, 0.000000, 266.538940},
	{569.401733, -1821.201782, 5.412500, 0.000000, 0.000000, 278.529266},
	{578.073364, -1820.941528, 5.412500, 0.000000, 0.000000, 269.170959},
	{588.242615, -1820.504883, 5.412500, 0.000000, 0.000000, 269.170959},
	{597.190979, -1819.642456, 5.412500, 0.000000, 0.000000, 276.189667},
	{593.504150, -1812.972168, 5.412500, 0.000000, 0.000000, 90.195747},
	{584.673279, -1813.790527, 5.412500, 0.000000, 0.000000, 89.903297},
	{574.517639, -1813.869385, 5.412500, 0.000000, 0.000000, 89.903297},
	{563.561768, -1814.403564, 5.412500, 0.000000, 0.000000, 89.903297},
	{555.104370, -1811.654663, 5.412500, 0.000000, 0.000000, 89.903297},
	{559.105652, -1805.398071, 5.412500, 0.000000, 0.000000, 265.663971},
	{572.565247, -1807.502197, 5.412500, 0.000000, 0.000000, 143.713577},
	{583.393066, -1806.581299, 5.412500, 0.000000, 0.000000, 272.097870},
	{548.551208, -1830.855347, 4.810937, 0.000000, 0.000000, 282.623566},
	{587.160645, -1829.936157, 5.155915, 0.000000, 0.000000, 270.340820},
	{595.647461, -1838.733643, 4.903313, 0.000000, 0.000000, 241.096100},
	{606.198853, -1842.815552, 4.920055, 0.000000, 0.000000, 262.737183},
	{614.203796, -1840.844971, 5.006981, 0.000000, 0.000000, 272.680359},
	{624.894409, -1844.435303, 4.911686, 0.000000, 0.000000, 253.963760},
	{633.927490, -1844.206543, 4.913923, 0.000000, 0.000000, 263.029633},
	{644.041260, -1845.737671, 4.959471, 0.000000, 0.000000, 262.152283},
	{644.787170, -1838.452515, 5.197773, 0.000000, 0.000000, 3.923810},
	{634.862915, -1837.822876, 5.100921, 0.000000, 0.000000, 84.931755},
	{625.271667, -1836.613770, 5.136159, 0.000000, 0.000000, 82.299736},
	{615.906982, -1835.932617, 5.156877, 0.000000, 0.000000, 82.592186},
	{605.570862, -1835.808594, 5.126902, 0.000000, 0.000000, 82.592186},
	{597.652588, -1831.397217, 5.218519, 0.000000, 0.000000, 49.545647},
	{607.845886, -1829.898804, 5.309297, 0.000000, 0.000000, 277.651978},
	{619.620361, -1831.050903, 5.318044, 0.000000, 0.000000, 249.284592},
	{629.064026, -1829.772827, 5.342881, 0.000000, 0.000000, 275.604797},
	{640.615784, -1830.991943, 5.321196, 0.000000, 0.000000, 248.992126},
	{651.902405, -1826.121338, 5.412500, 0.000000, 0.000000, 260.397644},
	{659.078003, -1826.579712, 5.412500, 0.000000, 0.000000, 254.548706},
	{655.006470, -1833.021973, 5.412500, 0.000000, 0.000000, 155.994034},
	{663.935852, -1830.519165, 5.412500, 0.000000, 0.000000, 268.001343},
	{667.470093, -1840.939087, 5.412500, 0.000000, 0.000000, 313.986755},
	{654.341370, -1847.582642, 5.121390, 0.000000, 0.000000, 339.867279},
	{663.727905, -1851.073730, 5.184746, 0.000000, 0.000000, 266.244324},
	{674.350769, -1851.553955, 5.079543, 0.000000, 0.000000, 306.309540},
	{680.838684, -1851.281738, 5.289329, 0.000000, 0.000000, 51.516762},
	{692.251404, -1850.366821, 6.168665, 0.000000, 0.000000, 278.234528},
	{700.528748, -1851.819824, 6.697062, 0.000000, 0.000000, 258.932953},
	{1140.843628, -2078.608398, 68.357811, 0.000000, 0.000000, 274.744751},//Участок 2 Правительство -- 58 начало
	{1151.825562, -2078.555176, 68.357811, 0.000000, 0.000000, 274.744751},
	{1164.483032, -2078.563232, 68.357811, 0.000000, 0.000000, 274.744751},
	{1174.843140, -2076.458496, 68.357811, 0.000000, 0.000000, 275.037201},
	{1189.039307, -2077.790771, 68.357811, 0.000000, 0.000000, 275.037201},
	{1200.017456, -2077.879150, 68.357811, 0.000000, 0.000000, 275.037201},
	{1207.704102, -2073.815674, 68.357811, 0.000000, 0.000000, 275.037201},
	{1184.207642, -2072.951904, 68.357811, 0.000000, 0.000000, 93.429955},
	{1168.951294, -2073.062256, 68.357811, 0.000000, 0.000000, 93.429955},
	{1149.126953, -2073.709717, 68.357811, 0.000000, 0.000000, 63.015461},
	{1140.623047, -2073.677734, 68.357811, 0.000000, 0.000000, 107.762276},
	{1144.791992, -2062.541748, 68.357811, 0.000000, 0.000000, 273.869812},
	{1159.508179, -2062.592529, 68.357811, 0.000000, 0.000000, 273.869812},
	{1162.121582, -2054.288086, 68.357811, 0.000000, 0.000000, 273.869812},
	{1161.533691, -2045.794067, 68.350609, 0.000000, 0.000000, 273.869812},
	{1150.692383, -2043.622192, 68.350609, 0.000000, 0.000000, 87.875862},
	{1143.389404, -2046.008545, 68.350609, 0.000000, 0.000000, 195.203979},
	{1155.038330, -2050.436279, 68.350609, 0.000000, 0.000000, 246.674683},
	{1154.483032, -2058.991943, 68.357811, 0.000000, 0.000000, 138.469223},
	{1144.486206, -2029.430176, 68.350609, 0.000000, 0.000000, 279.133911},
	{1153.453613, -2029.421387, 68.350609, 0.000000, 0.000000, 273.869812},
	{1162.936646, -2029.032837, 68.350609, 0.000000, 0.000000, 279.426270},
	{1163.539063, -2021.068604, 68.350609, 0.000000, 0.000000, 351.368286},
	{1163.835938, -2013.065186, 68.350609, 0.000000, 0.000000, 6.867984},
	{1155.661743, -2010.368164, 68.357811, 0.000000, 0.000000, 87.583389},
	{1145.188843, -2010.794922, 68.357811, 0.000000, 0.000000, 86.706039},
	{1144.234863, -2018.708130, 68.007813, 0.000000, 0.000000, 169.468613},
	{1151.140137, -2022.396606, 68.357811, 0.000000, 0.000000, 265.098755},
	{1158.023193, -2018.022583, 68.350609, 0.000000, 0.000000, 349.908356},
	{1152.347290, -2015.787964, 68.357811, 0.000000, 0.000000, 349.908356},
	{1188.401489, -2010.149170, 68.357811, 0.000000, 0.000000, 265.391174},
	{1187.728394, -2020.535400, 68.357811, 0.000000, 0.000000, 181.166168},
	{1187.948730, -2030.554077, 68.357811, 0.000000, 0.000000, 181.166168},
	{1197.656372, -2031.645508, 68.357811, 0.000000, 0.000000, 181.166168},
	{1206.158813, -2030.061401, 68.357811, 0.000000, 0.000000, 283.011688},
	{1205.621704, -2021.104858, 68.357811, 0.000000, 0.000000, 283.011688},
	{1203.965454, -2011.690430, 68.357811, 0.000000, 0.000000, 283.011688},
	{1195.969116, -2011.534058, 68.357811, 0.000000, 0.000000, 182.338501},
	{1195.569336, -2019.363159, 68.357811, 0.000000, 0.000000, 175.319931},
	{1189.107910, -2063.471191, 68.350609, 0.000000, 0.000000, 272.704773},
	{1195.456909, -2063.648682, 68.000610, 0.000000, 0.000000, 271.535004},
	{1204.818237, -2062.969971, 68.350609, 0.000000, 0.000000, 291.713806},
	{1205.026978, -2056.077881, 68.350609, 0.000000, 0.000000, 351.373016},
	{1204.832397, -2048.185791, 68.350609, 0.000000, 0.000000, 356.929474},
	{1203.845459, -2041.097412, 68.357811, 0.000000, 0.000000, 17.400789},
	{1197.577393, -2042.214111, 68.350609, 0.000000, 0.000000, 94.899277},
	{1187.934082, -2043.592041, 68.350609, 0.000000, 0.000000, 94.899277},
	{1186.555664, -2049.819336, 68.357811, 0.000000, 0.000000, 94.899277},
	{1187.274780, -2057.245361, 68.357811, 0.000000, 0.000000, 175.907089},
	{1194.469849, -2057.222656, 68.350609, 0.000000, 0.000000, 267.443115},
	{1195.433472, -2049.798340, 68.357811, 0.000000, 0.000000, 317.744019},
	{1204.749878, -1998.648193, 68.357811, 0.000000, 0.000000, 196.014725},
	{1197.217041, -1999.042725, 68.357811, 0.000000, 0.000000, 93.439453},
	{1189.093628, -2000.198608, 68.357811, 0.000000, 0.000000, 86.713173},
	{1178.943481, -1999.329468, 68.357811, 0.000000, 0.000000, 84.666039},
	{1169.935547, -1998.812134, 68.357811, 0.000000, 0.000000, 89.637634},
	{1161.076294, -1998.848022, 68.357811, 0.000000, 0.000000, 93.439468},
	{1152.301147, -1998.151123, 68.357811, 0.000000, 0.000000, 82.326462},
	{1142.545288, -1998.624634, 68.357811, 0.000000, 0.000000, 135.551834},
	{1220.061279, -1295.611450, 12.820630, 0.000000, 0.000000, 202.588028},//Участок №3 Больница ЛС -- 37 начало
	{1219.068481, -1301.858643, 12.824845, 0.000000, 0.000000, 178.607315},
	{1219.093628, -1309.453491, 12.830401, 0.000000, 0.000000, 180.946472},
	{1218.716797, -1316.750732, 12.836747, 0.000000, 0.000000, 180.654312},
	{1218.542236, -1324.906006, 12.830925, 0.000000, 0.000000, 185.333450},
	{1218.584229, -1332.729614, 12.832835, 0.000000, 0.000000, 177.144867},
	{1218.531372, -1339.101196, 12.837425, 0.000000, 0.000000, 177.144867},
	{1218.733765, -1345.730103, 12.843824, 0.000000, 0.000000, 177.144867},
	{1218.378540, -1353.291382, 12.845671, 0.000000, 0.000000, 182.993820},
	{1218.322144, -1361.223389, 12.817779, 0.000000, 0.000000, 182.993820},
	{1218.914795, -1368.568604, 12.782659, 0.000000, 0.000000, 182.993698},
	{1219.508057, -1379.898315, 12.699455, 0.000000, 0.000000, 182.993698},
	{1228.192505, -1380.120117, 12.688148, 0.000000, 0.000000, 267.218567},
	{1236.037109, -1380.532593, 12.665513, 0.000000, 0.000000, 267.218567},
	{1242.375244, -1378.805786, 12.668731, 0.000000, 0.000000, 4.603386},
	{1233.649902, -1375.019043, 12.693229, 0.000000, 0.000000, 68.356842},
	{1225.229248, -1374.031006, 12.751884, 0.000000, 0.000000, 39.112122},
	{1223.709106, -1367.236572, 12.811624, 0.000000, 0.000000, 1.386210},
	{1224.190186, -1360.600708, 12.842188, 0.000000, 0.000000, 355.537537},
	{1223.404419, -1350.503052, 12.845477, 0.000000, 0.000000, 3.433477},
	{1223.821777, -1341.374023, 12.838238, 0.000000, 0.000000, 358.754486},
	{1224.243042, -1329.755737, 12.832597, 0.000000, 0.000000, 358.754486},
	{1224.303467, -1322.539917, 12.838648, 0.000000, 0.000000, 354.660126},
	{1223.291992, -1311.622437, 12.835979, 0.000000, 0.000000, 9.282518},
	{1225.576538, -1304.833252, 12.826563, 0.000000, 0.000000, 28.293932},
	{1227.786255, -1295.909546, 12.813955, 0.000000, 0.000000, 335.365875},
	{1234.904663, -1296.221924, 12.747257, 0.000000, 0.000000, 182.123581},
	{1231.840576, -1303.273560, 12.775769, 0.000000, 0.000000, 169.840775},
	{1237.192261, -1309.080322, 12.747046, 0.000000, 0.000000, 251.433502},
	{1242.312134, -1307.244141, 12.680327, 0.000000, 0.000000, 171.157913},
	{1242.774292, -1316.437744, 12.686161, 0.000000, 0.000000, 187.097488},
	{1242.702393, -1325.303223, 12.694906, 0.000000, 0.000000, 187.097488},
	{1243.327393, -1334.560669, 12.691512, 0.000000, 0.000000, 183.880508},
	{1241.518188, -1342.948975, 12.700533, 0.000000, 0.000000, 170.720444},
	{1241.839355, -1352.318848, 12.709240, 0.000000, 0.000000, 170.720444},
	{1242.121582, -1361.418945, 12.704837, 0.000000, 0.000000, 170.720444},
	{1240.677856, -1368.625000, 12.709319, 0.000000, 0.000000, 170.135544},
	{1233.519653, -1370.330811, 12.730769, 0.000000, 0.000000, 101.702904},
	{1867.358276, -1246.167114, 13.221643, 0.000000, 0.000000, 271.902435},//Участок № 4 Глен Парк сторона 1 -- 95 начало
	{1879.723267, -1246.921753, 13.175182, 0.000000, 0.000000, 270.437866},
	{1889.987915, -1246.639771, 13.363698, 0.000000, 0.000000, 270.437866},
	{1900.332642, -1246.652466, 13.676298, 0.000000, 0.000000, 270.437866},
	{1910.957642, -1246.144897, 14.361286, 0.000000, 0.000000, 270.437866},
	{1921.833496, -1245.892822, 16.109970, 0.000000, 0.000000, 270.437866},
	{1932.653687, -1245.594849, 17.320723, 0.000000, 0.000000, 270.437866},
	{1943.216797, -1245.196533, 18.295958, 0.000000, 0.000000, 270.437866},
	{1953.732178, -1245.090454, 19.037907, 0.000000, 0.000000, 270.437866},
	{1960.312500, -1245.495483, 19.256392, 0.000000, 0.000000, 270.437866},
	{1958.022461, -1232.280029, 19.211897, 0.000000, 0.000000, 134.086182},
	{1951.030396, -1229.105347, 19.144039, 0.000000, 0.000000, 81.519363},
	{1944.291138, -1233.323608, 18.738131, 0.000000, 0.000000, 104.915138},
	{1943.331909, -1223.625610, 19.285929, 0.000000, 0.000000, 32.388256},
	{1935.050171, -1219.605957, 19.468113, 0.000000, 0.000000, 58.416039},
	{1929.315063, -1214.761108, 19.346359, 0.000000, 0.000000, 53.444431},
	{1924.723511, -1220.001465, 18.975727, 0.000000, 0.000000, 139.423889},
	{1924.205811, -1227.302246, 18.344778, 0.000000, 0.000000, 196.743561},
	{1926.336304, -1233.042358, 17.665197, 0.000000, 0.000000, 217.799789},
	{1934.242798, -1233.444458, 17.926485, 0.000000, 0.000000, 275.704315},
	{1916.387329, -1235.239990, 16.341469, 0.000000, 0.000000, 105.790092},
	{1906.114136, -1234.314575, 15.299605, 0.000000, 0.000000, 72.158646},
	{1898.302002, -1231.738403, 14.944695, 0.000000, 0.000000, 51.979790},
	{1891.412964, -1227.149048, 15.060605, 0.000000, 0.000000, 48.177982},
	{1887.563477, -1219.410767, 16.005716, 0.000000, 0.000000, 10.452292},
	{1887.908203, -1211.488281, 17.433287, 0.000000, 0.000000, 347.641449},
	{1889.611450, -1203.114868, 19.143389, 0.000000, 0.000000, 343.547119},
	{1892.414185, -1194.862183, 20.763123, 0.000000, 0.000000, 343.547119},
	{1895.335083, -1187.858032, 21.977161, 0.000000, 0.000000, 344.132050},
	{1898.707520, -1181.456299, 22.807127, 0.000000, 0.000000, 344.132050},
	{1902.802124, -1176.290527, 23.249763, 0.000000, 0.000000, 295.293335},
	{1911.027954, -1170.306641, 23.029148, 0.000000, 0.000000, 291.491516},
	{1919.889282, -1166.064941, 22.243843, 0.000000, 0.000000, 287.689758},
	{1927.470703, -1163.716675, 21.522303, 0.000000, 0.000000, 277.161713},
	{1935.994629, -1162.692261, 20.844452, 0.000000, 0.000000, 272.482574},
	{1943.722778, -1162.527222, 20.438334, 0.000000, 0.000000, 266.633636},
	{1951.386597, -1162.415771, 20.255171, 0.000000, 0.000000, 268.973175},
	{1954.238037, -1167.605103, 19.933907, 0.000000, 0.000000, 180.361542},
	{1953.367920, -1175.664673, 19.445637, 0.000000, 0.000000, 150.532074},
	{1943.820923, -1177.764526, 19.488754, 0.000000, 0.000000, 103.740524},
	{1935.780029, -1180.525269, 19.575300, 0.000000, 0.000000, 108.712120},
	{1928.817017, -1178.982910, 20.131247, 0.000000, 0.000000, 81.806984},
	{1919.220215, -1175.869629, 21.577497, 0.000000, 0.000000, 68.061974},
	{1911.458008, -1177.654907, 22.279034, 0.000000, 0.000000, 120.117508},
	{1906.133301, -1182.346924, 22.269163, 0.000000, 0.000000, 119.825035},
	{1901.146729, -1188.850342, 21.967215, 0.000000, 0.000000, 152.286575},
	{1898.446411, -1196.203857, 20.980274, 0.000000, 0.000000, 160.475082},
	{1897.568726, -1205.405151, 18.905323, 0.000000, 0.000000, 178.314362},
	{1898.428833, -1214.339966, 17.807949, 0.000000, 0.000000, 170.420761},
	{1899.453003, -1222.291504, 16.404261, 0.000000, 0.000000, 227.155411},
	{1906.315918, -1225.115479, 16.469769, 0.000000, 0.000000, 245.869537},
	{1914.545044, -1227.512939, 16.902369, 0.000000, 0.000000, 251.426010},
	{1917.468140, -1221.014160, 18.211891, 0.000000, 0.000000, 318.688782},
	{1920.434937, -1214.422363, 18.912180, 0.000000, 0.000000, 323.075439},
	{1925.799316, -1207.512207, 19.323290, 0.000000, 0.000000, 321.905670},
	{1920.132446, -1202.961670, 19.237158, 0.000000, 0.000000, 31.800503},
	{1912.381958, -1212.841919, 18.752636, 0.000000, 0.000000, 116.317719},
	{1908.059448, -1191.620605, 21.259354, 0.000000, 0.000000, 254.935303},
	{1916.785034, -1194.246216, 20.268057, 0.000000, 0.000000, 248.209015},
	{1925.465576, -1193.818115, 19.545786, 0.000000, 0.000000, 269.265198},
	{1923.847656, -1187.694824, 20.132030, 0.000000, 0.000000, 342.082092},
	{1918.140259, -1185.196533, 20.847538, 0.000000, 0.000000, 57.533447},
	{1954.654541, -1151.323364, 20.875120, 0.000000, 0.000000, 98.183594},
	{1942.135986, -1151.113770, 21.742018, 0.000000, 0.000000, 71.278450},
	{1930.641113, -1152.326050, 22.475374, 0.000000, 0.000000, 89.995071},
	{1920.478882, -1152.254028, 23.103773, 0.000000, 0.000000, 89.995071},
	{1910.036011, -1157.119751, 22.975300, 0.000000, 0.000000, 89.995071},
	{1898.186035, -1152.625366, 23.696474, 0.000000, 0.000000, 89.995071},
	{1885.720703, -1152.850220, 23.474592, 0.000000, 0.000000, 89.995071},
	{1884.073730, -1163.561890, 23.380205, 0.000000, 0.000000, 89.995071},
	{1894.197021, -1164.241333, 23.438457, 0.000000, 0.000000, 89.995071},
	{1902.943115, -1165.435303, 23.526339, 0.000000, 0.000000, 268.899017},
	{1894.442627, -1174.762695, 23.488493, 0.000000, 0.000000, 139.713486},
	{1885.571045, -1174.393066, 23.292017, 0.000000, 0.000000, 121.581818},
	{1875.827759, -1180.716431, 23.038374, 0.000000, 0.000000, 121.289360},
	{1883.703735, -1185.085693, 22.545891, 0.000000, 0.000000, 239.730469},
	{1885.624756, -1194.326538, 20.987839, 0.000000, 0.000000, 171.005417},
	{1878.034668, -1190.441528, 21.570574, 0.000000, 0.000000, 58.413280},
	{1871.276489, -1188.160034, 22.608206, 0.000000, 0.000000, 58.120831},
	{1866.274292, -1191.862793, 22.729689, 0.000000, 0.000000, 109.006630},
	{1866.282593, -1200.074463, 21.576797, 0.000000, 0.000000, 180.656113},
	{1873.567749, -1199.659180, 20.948042, 0.000000, 0.000000, 250.258621},
	{1881.627686, -1202.204102, 19.745148, 0.000000, 0.000000, 245.579498},
	{1880.182617, -1210.648682, 18.136990, 0.000000, 0.000000, 161.647156},
	{1872.642700, -1209.538940, 18.869944, 0.000000, 0.000000, 83.271309},
	{1864.596924, -1209.499390, 19.727041, 0.000000, 0.000000, 83.271301},
	{1864.666626, -1215.465576, 18.963261, 0.000000, 0.000000, 179.194000},
	{1867.633911, -1222.829712, 17.501318, 0.000000, 0.000000, 191.476654},
	{1871.866211, -1216.548096, 17.657242, 0.000000, 0.000000, 346.473633},
	{1878.161499, -1223.409546, 16.220636, 0.000000, 0.000000, 212.825302},
	{1864.669678, -1233.362061, 15.701693, 0.000000, 0.000000, 135.619263},
	{1864.440918, -1239.464600, 14.398665, 0.000000, 0.000000, 323.077942},
	{1885.218018, -1240.321411, 13.916868, 0.000000, 0.000000, 268.682739},
	{1894.850342, -1240.158325, 14.366830, 0.000000, 0.000000, 268.682739},
	{1885.283813, -1233.227051, 14.686578, 0.000000, 0.000000, 268.682739},
	{1872.900024, -1227.628418, 15.833553, 0.000000, 0.000000, 33.850128},
	{2052.105957, -1248.333984, 23.101965, 0.000000, 0.000000, 85.138367},//Участок № 5 Глен Парк сторона 2 -- 80 начало
	{2052.648926, -1239.833618, 23.025469, 0.000000, 0.000000, 359.743591},
	{2052.682129, -1232.533691, 23.027925, 0.000000, 0.000000, 359.743591},
	{2052.736328, -1220.633789, 23.031933, 0.000000, 0.000000, 359.743591},
	{2053.768066, -1212.595459, 23.113119, 0.000000, 0.000000, 3.545526},
	{2052.881348, -1204.760254, 23.109367, 0.000000, 0.000000, 93.545670},
	{2053.242188, -1194.415894, 23.006886, 0.000000, 0.000000, 3.545526},
	{2053.067383, -1183.212036, 23.020996, 0.000000, 0.000000, 3.545526},
	{2052.440674, -1173.106445, 22.999132, 0.000000, 0.000000, 3.545526},
	{2054.451416, -1160.462524, 22.994017, 0.000000, 0.000000, 3.545526},
	{2052.638428, -1149.701904, 23.161327, 0.000000, 0.000000, 3.545526},
	{2039.835327, -1148.952515, 23.380121, 0.000000, 0.000000, 85.723320},
	{2033.174683, -1155.614136, 22.236532, 0.000000, 0.000000, 121.986778},
	{2022.169678, -1149.868408, 23.062159, 0.000000, 0.000000, 56.186131},
	{2010.697632, -1148.949951, 23.264124, 0.000000, 0.000000, 83.676140},
	{2001.049805, -1149.684814, 22.906815, 0.000000, 0.000000, 83.678513},
	{1991.516602, -1148.771240, 21.455414, 0.000000, 0.000000, 75.489990},
	{1982.714600, -1152.197510, 20.449589, 0.000000, 0.000000, 153.280945},
	{2000.686035, -1154.322754, 20.688007, 0.000000, 0.000000, 277.278442},
	{2018.766846, -1156.388550, 21.570492, 0.000000, 0.000000, 277.278442},
	{2041.546997, -1168.411377, 22.180187, 0.000000, 0.000000, 176.676620},
	{2029.834229, -1163.938843, 21.483173, 0.000000, 0.000000, 72.275475},
	{1984.586792, -1160.906250, 20.240561, 0.000000, 0.000000, 274.063965},
	{1995.976440, -1160.662964, 20.347477, 0.000000, 0.000000, 274.063965},
	{2006.716797, -1162.463257, 20.533003, 0.000000, 0.000000, 274.063965},
	{2017.682129, -1164.358398, 20.941208, 0.000000, 0.000000, 274.063965},
	{2028.624390, -1170.473633, 21.477953, 0.000000, 0.000000, 274.063965},
	{2037.281006, -1175.917236, 22.148050, 0.000000, 0.000000, 274.063965},
	{2042.541382, -1183.845581, 22.708593, 0.000000, 0.000000, 215.867081},
	{2034.899902, -1184.459839, 22.049437, 0.000000, 0.000000, 84.265892},
	{2030.172119, -1178.808960, 21.374657, 0.000000, 0.000000, 313.030792},
	{2025.353882, -1186.236206, 20.961493, 0.000000, 0.000000, 80.756500},
	{2016.943481, -1184.039551, 20.140444, 0.000000, 0.000000, 86.897896},
	{2010.556763, -1180.000610, 19.800041, 0.000000, 0.000000, 50.342007},
	{2008.480347, -1174.341919, 19.998922, 0.000000, 0.000000, 17.587986},
	{2004.515625, -1169.093384, 20.186283, 0.000000, 0.000000, 86.897957},
	{1993.883179, -1168.541138, 19.960743, 0.000000, 0.000000, 113.803101},
	{1985.223633, -1169.168945, 19.761030, 0.000000, 0.000000, 87.775314},
	{1989.339478, -1175.695435, 19.468435, 0.000000, 0.000000, 236.046021},
	{1998.127686, -1174.196777, 19.700197, 0.000000, 0.000000, 257.102173},
	{2004.564941, -1181.127075, 19.541172, 0.000000, 0.000000, 209.433350},
	{2014.237427, -1190.604126, 19.496807, 0.000000, 0.000000, 210.895584},
	{2017.603271, -1195.766968, 19.634840, 0.000000, 0.000000, 196.273224},
	{2016.462036, -1202.479614, 19.495668, 0.000000, 0.000000, 159.424866},
	{2012.954834, -1211.445313, 19.538244, 0.000000, 0.000000, 159.132416},
	{2006.520874, -1216.973877, 19.580059, 0.000000, 0.000000, 115.265366},
	{1998.958130, -1220.103882, 19.464239, 0.000000, 0.000000, 112.633369},
	{1992.229370, -1223.705933, 19.523685, 0.000000, 0.000000, 110.586235},
	{1986.307739, -1228.668335, 19.575462, 0.000000, 0.000000, 151.236389},
	{1996.842163, -1227.796265, 19.919613, 0.000000, 0.000000, 279.620697},
	{2005.931396, -1225.310913, 20.251413, 0.000000, 0.000000, 278.450897},
	{2014.167969, -1222.740601, 20.569157, 0.000000, 0.000000, 278.450897},
	{2022.712158, -1220.504639, 21.055275, 0.000000, 0.000000, 274.649109},
	{2033.537720, -1216.098267, 21.849470, 0.000000, 0.000000, 274.649109},
	{2032.582642, -1208.034912, 21.539402, 0.000000, 0.000000, 356.824371},
	{2038.923950, -1210.170044, 22.180939, 0.000000, 0.000000, 253.590469},
	{2042.105591, -1203.243164, 22.584679, 0.000000, 0.000000, 345.711273},
	{2043.261841, -1195.205688, 22.725100, 0.000000, 0.000000, 345.711273},
	{2036.342773, -1192.076172, 22.091585, 0.000000, 0.000000, 40.691353},
	{2029.458252, -1194.603394, 21.249327, 0.000000, 0.000000, 118.774757},
	{2026.916992, -1202.825806, 20.823637, 0.000000, 0.000000, 141.878082},
	{2035.867432, -1200.998047, 21.790827, 0.000000, 0.000000, 187.497345},
	{2044.054199, -1247.826660, 23.004990, 0.000000, 0.000000, 72.858070},
	{2037.057739, -1245.909180, 22.751347, 0.000000, 0.000000, 86.895531},
	{2029.271240, -1247.171021, 22.899652, 0.000000, 0.000000, 86.895531},
	{2018.975098, -1247.301758, 22.915018, 0.000000, 0.000000, 86.895531},
	{2009.635498, -1246.693726, 22.650595, 0.000000, 0.000000, 87.480438},
	{2000.731201, -1246.766968, 21.554968, 0.000000, 0.000000, 85.725746},
	{1991.578613, -1247.012451, 20.202988, 0.000000, 0.000000, 85.725746},
	{1989.787720, -1240.149780, 19.651670, 0.000000, 0.000000, 18.755314},
	{1996.230591, -1237.448120, 19.990788, 0.000000, 0.000000, 264.116058},
	{2002.186401, -1241.389282, 21.126034, 0.000000, 0.000000, 262.653809},
	{2007.249756, -1235.382324, 20.777763, 0.000000, 0.000000, 283.709991},
	{2012.688232, -1239.922363, 21.711922, 0.000000, 0.000000, 224.635666},
	{2018.154785, -1232.119995, 21.180098, 0.000000, 0.000000, 298.332336},
	{2024.679932, -1237.369751, 21.673695, 0.000000, 0.000000, 234.871353},
	{2028.964478, -1231.207031, 21.531506, 0.000000, 0.000000, 279.028473},
	{2038.563232, -1233.516846, 22.079952, 0.000000, 0.000000, 271.717316},
	{2037.481934, -1224.965088, 21.976377, 0.000000, 0.000000, 325.235107},
	{2044.973755, -1223.109375, 22.409435, 0.000000, 0.000000, 287.801849},
	{2046.857788, -1235.534180, 22.632471, 0.000000, 0.000000, 188.369812}
};

new Float:gClearCPs[3][32][4] = {
	{//маршрут №1
		{0.0,1386.8707,-1819.8137,13.0907},
		{0.0,1386.7776,-1868.3838,13.0977},
		{0.0,1316.3186,-1851.1456,13.0907},
		{0.0,1315.2659,-1625.0011,13.0907},
		{0.0,1359.6088,-1378.5940,13.1917},
		{0.0,1363.4550,-1102.8883,23.5857},
		{0.0,1371.0570,-1032.9611,25.9409},
		{0.0,1160.9144,-1036.0770,31.6240},
		{0.0,1159.9063,-1139.4188,23.3642},
		{0.0,1056.9033,-1140.9899,23.3726},
		{0.0,1055.8633,-1283.4092,13.4271},
		{0.0,1194.7260,-1283.1401,13.0360},
		{0.0,1195.9567,-1392.5038,12.8794},
		{0.0,901.4108,-1393.2153,12.9317},
		{0.0,626.9870,-1392.4143,13.0403},
		{0.0,616.2323,-1745.6138,13.0400},
		{0.0,1001.2133,-1808.8887,13.7552},
		{0.0,1044.7469,-1963.8276,12.6603},
		{0.0,1034.1226,-2273.0300,12.6546},
		{0.0,1318.7294,-2466.1479,7.3642},
		{0.0,1321.4236,-2447.4917,7.3641},
		{0.0,1075.6267,-2309.5688,12.6046},
		{0.0,1063.6611,-1855.6954,13.1064},
		{0.0,1391.0505,-1874.6238,13.0908},
		{1.0,1398.9404,-1804.5812,13.2549},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,1391.9589,-1781.9507,13.0908}, // LS1
		{0.0,1392.1201,-1735.9944,13.0949}, // LS2
		{0.0,1531.5963,-1735.4170,13.0947}, // LS3
		{0.0,1532.3362,-1589.9933,13.0908}, // LS4
		{0.0,1428.1073,-1589.6709,13.0986}, // LS5
		{0.0,1426.9728,-1728.9611,13.0946}, // LS6
		{0.0,1314.9839,-1729.1403,13.0907}, // LS7
		{0.0,1359.6808,-1393.4606,13.1648}, // LS8
		{0.0,1195.4027,-1392.5393,12.8757}, // LS9
		{0.0,1193.1986,-1573.5201,13.0906}, // LS10
		{0.0,1294.8170,-1575.3953,13.0907}, // LS11
		{0.0,1295.1188,-1855.4094,13.0908}, // LS12
		{0.0,1648.7030,-1874.1086,13.0908}, // LS13
		{0.0,1690.8506,-1814.6907,13.0986}, // LS14
		{0.0,1819.0297,-1834.4786,13.1220}, // LS15
		{0.0,1819.0096,-1887.5176,13.1004}, // LS16
		{0.0,1787.5604,-1891.2620,13.1028}, // LS17
		{0.0,1784.6788,-1927.4304,13.0966}, // LS18
		{0.0,1796.6338,-1929.5077,13.0959}, // LS19
		{0.0,1797.6156,-1894.4919,13.1102}, // LS20
		{0.0,1818.1531,-1892.2823,13.1113}, // LS21
		{0.0,1957.7418,-1934.2329,13.0908}, // LS22
		{0.0,1957.9696,-2060.2686,13.0908}, // LS23
		//{0.0,2029.9690,-2037.7518,13.2974}, LS24 DEL
		//{0.0,2032.4188,-1997.9026,13.2974}, LS25 DEL
		{0.0,1964.9982,-1995.6715,13.0901}, // LS24
		{0.0,1964.5792,-1930.5961,13.0908}, // LS25
		{0.0,1824.2692,-1830.3569,13.1220}, // LS26
		{0.0,1687.6703,-1809.8795,13.0907}, // LS27
		{0.0,1392.3217,-1869.7803,13.0966}, // LS28
		{1.0,1398.9404,-1804.5812,13.2549}, // LS29
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,1392.0623,-1791.7125,13.0908}, // Ghetto1
		{0.0,1391.7612,-1735.2448,13.0968}, // Ghetto2
		{0.0,1690.5293,-1734.7238,13.1005}, // Ghetto3
		{0.0,1818.6444,-1734.6156,13.0908}, // Ghetto4
		{0.0,1818.8099,-1754.3562,13.0908},// Ghetto5
		{0.0,2091.4414,-1753.9078,13.1127}, // Ghetto6
		{0.0,2187.5518,-1735.1260,13.0829}, // Ghetto7
		{0.0,2212.4153,-1736.0732,13.0742}, // Ghetto8
		{0.0,2215.7388,-1896.6831,13.0984}, // Ghetto9
		{0.0,2309.8857,-1896.4823,13.1752}, // Ghetto10
		{0.0,2311.5947,-1973.8826,13.0918}, // Ghetto11
		{0.0,2415.4360,-1974.5627,13.1200}, // Ghetto12
		{0.0,2415.9646,-1935.3470,13.0908}, // Ghetto13
		{0.0,2517.4490,-1935.0500,13.0796}, // Ghetto14
		{0.0,2529.7197,-1735.9653,13.0907}, // Ghetto15
		{0.0,2644.0718,-1734.2902,10.4423}, // Ghetto16
		{0.0,2644.8076,-1660.5665,10.4184}, // Ghetto17
		{0.0,2739.6265,-1659.7494,12.7783}, // Ghetto18
		{0.0,2740.0049,-1510.1157,29.9892}, // Ghetto19
		{0.0,2645.6689,-1402.3347,29.9945}, // Ghetto20
		{0.0,2644.8938,-1044.6847,69.1220}, // Ghetto21
		{0.0,2562.2761,-1044.7236,69.1220}, // Ghetto22
		{0.0,2321.1631,-1150.2688,26.5124}, // Ghetto23
		{0.0,2174.7383,-1117.0276,24.8626}, // Ghetto24
		{0.0,2164.1028,-1381.2463,23.5361}, // Ghetto25
		{0.0,2111.0916,-1381.4752,23.5360}, // Ghetto26
		{0.0,2090.8074,-1749.2878,13.1132}, // Ghetto27
		{0.0,1824.8679,-1749.9146,13.0908}, // Ghetto28
		{0.0,1824.1864,-1730.2544,13.0908}, // Ghetto29
		{0.0,1387.0582,-1730.0496,13.0908}, // Ghetto30
		{1.0,1398.9404,-1804.5812,13.2549}, // Ghetto 31
		{0.0,0.0,0.0,0.0}
	}
};
new condition_of_roads[][]  = {
	{"На дорогах чисто"},
	{"На дорогах пыль"},
	{"На дорогах грязь"}
};
new condition_of_roads_price[][] = {
	{3500,4500,6000},
	{3500,4500,6000},
	{4500,5500,7000}
};
new condition_of_roads_;//тут рандомное число от 0 до 2, в зп и ongamemodeinit, будет отвечать за состояние дорог
new Float:race_checkpoint[][] = {
	{2761.9590,-2449.8303,13.5373}, // Порт ЛС
	{1961.2914,-2190.3118,13.5469},// Въезд Аэро ЛС
	{1798.4791,-2303.9937,-2.7481}, // Аэро ЛС
	{492.7488,-1010.9299,91.3559}, // VineWood
	{2170.8821,-1007.9356,62.8047}, // Гора Ghetto
	{2270.4927,-1434.7721,23.8281}, // Ghetto
	{2213.9636,-2231.4707,13.5469}, // Дуэли
	{1663.8843,-1053.8571,23.8984}, // Стоянка
	{879.6149,-1221.6178,16.9766} // Гаражи
};

enum ROB_PL {
	AttachObj,
	RobArea,
	RobPickup,
	RobRand,
	Text3D:RobText
};
new RobPlayer[MAX_PLAYERS][ROB_PL];

new rob_veh[MAX_PLAYERS];


new start_invent;
new invent_object[13];
new invent_area;
new invent_pickup;
new invent_car[3];
new invent_mats;
new Text3D:invent_text;
new invent_time;
new invent_time_car;
new invent_zone;
new invent_zone_id = -1;
new invent_place[5][4] = {
	{1997, -178, 2152, -44},
	{ 333, 261, 545, 408},
	{-665, 1249, -530, 1381},
	{-2166, 1404, -1992, 1508},
	{-1267, -2197, -1110, -2026}
};
enum GRF {
	gId,
	gObject,
	gFrak,
	Float: gr_x[7],
}
new GrafInfo[121][GRF],CountGraffity;
new graf_timer[MAX_PLAYERS];

new dice_random[11] = {2,4,6,8,10,12,3,5,7,9,11};

//угон
new theftarea[MAX_PLAYERS][2];
new theftIDveh[MAX_PLAYERS][3];
new theftCheck[MAX_PLAYERS][2];
new theftplayer[MAX_PLAYERS][2];
new thefttime[MAX_PLAYERS];
new theftveh[MAX_PLAYERS][3]; // ид и время //угон
new	TheftSkillMax[26] = {3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79,83,87,91,95,100,100};


new GUARD_TICK_C_BUG[MAX_PLAYERS];

new player_gm[MAX_PLAYERS char];

new salary_pd[11] = {1700,2700,3500,4200,5000,5500,6500,7500,8600,9000,9500};
new salary_fbi[11] = {2000,3000,4000,5000,5500,6200,7500,8000,9000,10500,12000};
new salary_medics[7] = {2000,2500,3000,3500,4000,4500,5500};
new salary_news[10] = {2500,4000,4500,4700,4900,5000,5500,6900,8100,9500};
new salary_wh[12] = {2700,3900,4200,4900,5500,12000,12000,12000,12000,12000,13500,16500};
new salary_army[15] = {1500,2000,2500,3000,3500,4100,4500,4700,5500,6100,7000,7700,8700,9400,10100};
new salary_mayor[8] = {2700,3900,4200,4900,5500,12000,12000};

new UseSound[MAX_PLAYERS];
new Sounds;
new Float:rads;
new Float:streampos[3];
new stream[256];
new Float:setX[MAX_PLAYERS];
new Float:setY[MAX_PLAYERS];
new Float:setZ[MAX_PLAYERS];

new anti_dm[MAX_PLAYERS char] ;

new objgolod[21] = -1;

new object[MAX_OGRAD] ={-1,...};
new objectrot[MAX_OGRAD] ={-1,...};
// PROMO
new promo_params[15];

new engine_name[5][44] = {
	"Нагнетатель воздуха",
	"Кованые поршни двигателя",
	"Дроссельная заслонка увеличенного диаметра",
	"Воздушный фильтр нулевого сопротивления",
	"Спортивный распредвал"};
new engine_name_price[5] = {30000, 50000, 90000, 120000, 150000};
new Float:engine_name_boost[5] = {0.3, 0.5, 0.7, 1.0, 1.5};

new brake_name[5][44] = {
	"Тормозной шланг",
	"Спортивные тормозные диски",
	"Модифицированные тормозные колодки",
	"Тормозной цилиндр",
	"Вакуумный усилитель"};
new brake_name_price[5] = {30000, 50000, 50000, 60000, 80000};
new Float:brake_name_boost[5] = {1.0, 2.0, 2.0, 3.0, 4.0};
/*============================================================================*/
enum e_HOUSE_INTERIOR {
	h_id,
	h_type,
	Float:h_pos_exit[4],
	Float:h_pos_spawn[4],
	h_int_name[24],			// Наименование интерьера
	h_evict,				// Количество возможно-подселяемых людей
	h_interior				// интерьер
}
#define MAX_INTERIORS 42
new
	const hinterior_info[][ e_HOUSE_INTERIOR ] = {
	/*0*/	{ 0, 1, { 2233.57,-1114.97,1050.88,358.299 },{ 2230.48,-1107.75,1050.88,272.758 }, "Интерьер дома №1", 0, 5 }, 		// 1
	/*1*/	{ 0, 2, { 2196.6, -1204.51, 1049.02, 91.6726 }, { 2189.2, -1219.15, 1049.02, 352.827 }, "Интерьер дома №1", 0, 6}, 		// 1
	/*2*/	{ 0, 3, { 2317.82, -1026.76, 1050.22, 354.248 }, { 2325.1, -1007.82, 1054.72, 178.322 }, "Интерьер дома №1", 0, 9 }, 		// 1
	/*3*/	{ 0, 0, { 2259.39, -1135.64, 1050.64, 270.298 }, { 2264.04, -1141.45, 1050.63, 359.912 }, "Интерьер дома №1", 0, 10 }, 		// 1
	/*4*/	{ 1, 1, { 2365.17, -1135.58, 1050.88, 357.068 }, { 2358.98, -1131.58, 1050.88, 266.393 }, "Интерьер дома №2", 0, 8 }, 		// 1
	/*5*/	{ 2, 1, { 2282.99, -1140.27, 1050.9, 356.778 }, { 2285.17, -1133.77, 1050.9, 94.9977 }, "Интерьер дома №3", 0, 11 }, 		// 1
	/*6*/	{ 3, 1, { 2218.4, -1076.32, 1050.48, 72.2927 }, { 2205.11, -1071.47, 1050.48, 174.249 }, "Интерьер дома №4", 0, 1 }, 		// 1
	/*7*/	{ 1, 3, { 83.014, 1322.29, 1083.87, 1.69824 }, { 79.2619, 1337.67, 1088.37, 349.96 }, "Интерьер дома №2", 0, 9 }, 		// 1
	/*8*/	{ 2, 3, { 234.381, 1063.73, 1084.21, 2.01149 }, { 237.359, 1082.94, 1087.82, 170.105 }, "Интерьер дома №3", 0, 6 }, 		// 1
	/*9*/	{ 1, 0, { 243.742, 304.976, 999.148, 269.891 }, { 247.015, 301.828, 999.148, 356.998 }, "Интерьер дома №2", 0, 1 }, 		// 1
	/*10*/	{ 2, 0, { 266.515, 304.944, 999.148, 265.168 }, { 271.431, 308.121, 999.148, 174.637 }, "Интерьер дома №3", 0, 2 }, 		// 1
	/*11*/	{ 4, 1, { 2468.45, -1698.35, 1013.51, 92.5746 }, { 2451.3003,-1699.1317,1013.5078,249.2947 }, "Интерьер дома №5", 0, 2 }, 		// 1
	/*12*/	{ 1, 2, { 2496.03, -1692.42, 1014.74, 181.249 }, { 2492.64, -1703.11, 1018.34, 169.464 }, "Интерьер дома №2", 0, 3 }, 		// 1
	/*13*/	{ 2, 2, { 2269.84, -1210.43, 1047.56, 92.2165 }, { 2251.72, -1209.5, 1049.02, 265.468 }, "Интерьер дома №3", 0, 10 }, 		// 1
	/*14*/	{ 3, 3, { 227.344, 1114.22, 1081, 271.062 }, { 234.029, 1109.56, 1085.01, 6.60592 }, "Интерьер дома №4", 0, 5 }, 		// 1
	/*15*/	{ 4, 3, { 235.405, 1186.98, 1080.26, 2.701 }, { 232.795, 1201.81, 1084.42, 207.455 }, "Интерьер дома №5", 0, 3 }, 		// 1
	/*16*/	{ 5, 1, { 225.971, 1239.97, 1082.14, 91.0382 }, { 223.639, 1251.37, 1082.15, 91.1831 }, "Интерьер дома №6", 0, 2 }, 		// 1
	/*17*/	{ 6, 1, { 223.217, 1287.64, 1082.14, 3.3038 }, { 231.444, 1290.18, 1082.14, 91.2065 }, "Интерьер дома №7", 0, 1 }, 		// 1
	/*18*/	{ 3, 2, { 24.0069,1340.6532,1084.3750,356.8460 }, { 27.7965, 1348.01, 1088.88, 267.82 }, "Интерьер дома №4", 0, 10 }, 		// 1
	/*19*/	{ 7, 1, { 295.133, 1472.56, 1080.26, 1.4707 }, { 294.194, 1487.38, 1080.26, 187.737 }, "Интерьер дома №8", 0, 15 }, 		// 1
	/*20*/	{ 4, 2, { 2324.35, -1148.76, 1050.71, 354.638 }, { 2337.82, -1138.28, 1054.3, 178.566 }, "Интерьер дома №5", 0, 12 }, 		// 1
	/*21*/	{ 5, 2, { -261.195, 1456.73, 1084.37, 95.1205 }, { -274.975, 1450.16, 1088.87, 1.31134 }, "Интерьер дома №6", 0, 4 }, 		// 1
	/*22*/	{ 8, 1, { 328.007, 1478.36, 1084.44, 0.1398 }, { 330.764, 1489.56, 1084.44, 162.28 }, "Интерьер дома №9", 0, 15 }, 		// 1
	/*23*/	{ 9, 1, { 22.9166, 1403.98, 1084.43, 357.72 }, { 20.2279, 1416.06, 1084.43, 180.249 }, "Интерьер дома №10", 0, 5 }, 		// 1
	/*24*/	{ 10, 1, { 386.502, 1471.72, 1080.19, 92.5512 }, { 373.049, 1462.83, 1080.19, 331.772 }, "Интерьер дома №11", 0, 15 }, 		// 1
	/*25*/	{ 11, 1, { 376.324, 1417.27, 1081.33, 86.6211 }, { 359.628, 1416.02, 1081.34, 189.54 }, "Интерьер дома №12", 0, 15 }, 		// 1
	/*26*/	{ 6, 2, { 447.25, 1397.76, 1084.3, 1.3703 }, { 455.384, 1415.07, 1084.31, 161.653 }, "Интерьер дома №7", 0, 2 }, 		// 1
	/*27*/	{ 5, 3, { 140.342, 1366.7, 1083.86, 356.404 }, { 137.146, 1385.06, 1088.37, 265.101 }, "Интерьер дома №6", 0, 5 }, 		// 1
	/*28*/	{ 6, 3, { 491.169, 1398.91, 1080.26, 2.0439 }, { 491.162, 1420.6, 1084.37, 177.681 }, "Интерьер дома №7", 0, 2 }, 		// 1
	/*29*/	{ 7, 3, { 234.149, 1064.4, 1084.21, 354.523 }, { 236.775, 1082.44, 1087.82, 87.4161 }, "Интерьер дома №8", 0, 6 }, 		// 1
	/*30*/	{ 12, 1, { 261.112, 1284.91, 1080.26, 355.899 }, { 256.311, 1290.84, 1080.27, 205.811 }, "Интерьер дома №13", 0, 4 }, 		// 1
	/*31*/	{ 13, 1, { -68.8663, 1351.94, 1080.21, 1.3932 }, { -70.2393, 1362.66, 1080.21, 268.188 }, "Интерьер дома №14", 0, 6 }, 		// 1
	/*32*/	{ 7, 2, { 2807.55, -1174.22, 1025.57, 359.851 }, { 2816.06, -1169.01, 1029.17, 90.5266 }, "Интерьер дома №8", 0, 8 }, 		// 1
	/*33*/	{ 14, 1, { 2217.45, -1076.34, 1050.48, 86.2849 }, { 2206.45, -1073.43, 1050.48, 177.176 }, "Интерьер дома №15", 0, 1 }, 		// 1
	/*34*/	{ 8, 2, { 2237.53, -1081.1, 1049.02, 357.634 }, { 2243.92, -1078.82, 1049.02, 357.367 }, "Интерьер дома №9", 0, 2 }, 		// 1
	/*35*/	{ 9, 2, { 2365.33, -1135.16, 1050.88, 2.7174 }, { 2360.45, -1132.71, 1050.88, 269.68 }, "Интерьер дома №10", 0, 8 }, 		// 1
	/*36*/	{ 15, 1, { -42.6872, 1405.89, 1084.43, 1.4874 }, { -50.5177, 1408.57, 1084.43, 268.282 }, "Интерьер дома №16", 0, 8 }, 		// 1
	/*37*/	{ 10, 2, { 82.9296, 1322.94, 1083.87, 3.1521 }, { 93.8073, 1340.1, 1088.37, 273.538 }, "Интерьер дома №11", 0, 9 }, 		// 1
	/*38*/	{ 16, 1, { 260.602, 1237.93, 1084.26, 5.5135 }, { 257.968, 1254.04, 1084.26, 86.6679 }, "Интерьер дома №17", 0, 9 }, 		// 1
	/*39*/	{ 3, 0, { 244.211, 305.121, 999.148, 273.123 }, { 247.029, 303.004, 999.148, 0.688418 }, "Интерьер дома №4", 0, 1 }, 		// 1
	/*40*/	{ 4, 0, { 422.148, 2536.35, 10.0, 92.0123 }, { 416.287, 2539.94, 10.0, 178.719 }, "Интерьер дома №5", 0, 10 }, 		// 1
	/*41*/	{ 17, 1, { 226.17, 1239.97, 1082.14, 90.3812 }, { 225.499, 1252.73, 1082.14, 91.153 }, "Интерьер дома №18", 0, 2 } 		// 1
};

/*============================================================================*/
#define ClearAnimationsEX(%0) ApplyAnimation(%0,"CARRY","null",1.0,0,0,0,0,0,0),SetTimerEx("ClearAnim", 400, 0, "d", %0)
#define PlayerToPoint(%0,%1,%2,%3,%4) IsPlayerInRangeOfPoint(%1,%0,%2,%3,%4)
#define PointToPoint(%0,%1,%2,%3,%4,%5) floatsqroot(floatpower(floatabs(floatsub(%3,%0)),2)+floatpower(floatabs(floatsub(%4,%1)),2)+floatpower(floatabs(floatsub(%5,%2)),2))
new const not_id[] = "Неверный ID игрока";
/*============================================================================*/

new VehTrailer[MAX_PLAYERS] = {INVALID_VEHICLE_ID,...};
new LastVeh[MAX_PLAYERS] = {INVALID_VEHICLE_ID,...};

#define MAX_REPORTS (50)

new TextReport[MAX_REPORTS][65];
new TextReportAdmin[MAX_REPORTS][65];
new PlayerReport[MAX_REPORTS] = {-1,...};
new ReportID[MAX_PLAYERS] = {-1,...};
new ReportSlot[MAX_REPORTS] = {-1,...};
new ReportAdmin[MAX_PLAYERS];

#define MAX_ASK (50)

new TextAsk[MAX_ASK][151];
new PlayerReportAsk[MAX_ASK] = {-1,...};
new ReportIDAsk[MAX_PLAYERS] = {-1,...};
new ReportSlotAsk[MAX_ASK] = {-1,...};

new SlotCObject[499];

new SlotObject[99];
new Army;
new SFa;

new bool:ac_1[MAX_PLAYERS char];

enum MAKEGUN_DATA {
	mgunname[24],
	mgunamount,
	mgunid
}
new MakeGunData[7][MAKEGUN_DATA] = {
	{"SD Pistol", 		35, 	23},
	{"Desert Eagle", 	90, 	24},
	{"MP5", 			100, 	29},
	{"Shotgun", 		140, 	25},
	{"M4", 				150, 	31},
	{"AK-47", 			190, 	30},
	{"Rifle", 			175, 	33}
};
/*============================================================================*/
#define 	Ammo_SDPISTOL           20
#define 	Ammo_DEAGLE             10
#define 	Ammo_SHOTGUN            10
#define 	Ammo_MP5				25
#define 	Ammo_AK47				28
#define 	Ammo_M4A1				28
/*============================================================================*/
/*new MaxSpeedCar[212] = { 160,160,200,120,150,165,110,170,110,180,160,240,160,160,140,230,155,200,150,160,180,180,
	165,145,170,200,200,170,170,200,190,130,80,180,200,120,160,160,160,160,160,75,150,150,110,
	165,280,200,190,150,120,240,190,190,190,140,160,160,165,160,200,190,190,190,75,75,160,160,
	190,200,170,160,190,190,160,160,200,200,150,165,200,120,150,120,190,160,100,200,200,170,170,
	160,160,190,220,170,200,200,140,140,160,75,220,220,160,170,230,165,140,120,140,200,200,200,120,
	120,165,165,160,330,330,190,190,190,110,160,160,160,170,160,60,70,140,200,160,160,160,110,110,150,
	160,230,160,165,170,160,160,160,200,160,160,165,160,200,170,180,110,110,200,200,200,200,200,200,75,
	200,160,160,170,110,110,90,60,110,60,160,160,200,110,160,165,190,160,170,120,165,190,200,140,200,110,
	120,200,200,60,190,200,200,200,160,165,110,200,200,160,165,160,160,160,140,160,160 } ; */
new MaxSpeedCar[212] = {111,103,131,77,93,115,77,104,70,111,91,155,118,77,74,135,108,80,81,105,102,108,98,69,95,135,122,116,110,141,128,91,66,77,117,0,105,111,100,118,95,53,98,89,77,115,162,80,77,0,0,136,118,44,91,110,74,67,110,95,92,113,78,100,0,0,103,98,100,78,110,77,88,75,105,121,141,131,82,98,129,68,110,86,46,70,45,116,104,98,110,105,99,125,151,124,114,114,76,86,98,0,151,151,121,98,126,116,76,73,91,87,90,111,84,100,110,110,115,190,189,112,123,106,91,113,111,105,124,105,42,49,77,117,118,111,121,0,0,70,105,142,115,106,104,103,105,100,86,108,102,110,85,95,101,111,77,77,110,125,119,108,125,85,0,116,112,121,102,0,0,65,42,77,42,111,111,190,91,111,107,106,95,60,0,107,100,116,76,114,0,0,190,100,0,77,123,123,123,111,106,77,119,120,103,106,0,0,0,76,0,0};
new TotalObject=0;
new gCurHour,
	gCurDay,
	timers_unix = -1,
	tmphour,
	tmpminute,
	tmpsecond,
	unix,
	unix_hour,
	unix_sec,
	unix_heal,
	unix_min,
	unix_three_sec;

new time_grandtimer,
	time_grandtimer_max,
	time_newkeys,
	time_newkeys_max,
	time_update,
	time_update_max,
	time_second,
	time_second_max;

new OldDialogID[MAX_PLAYERS];
#define INVALID_DIALOG_ID   (1234)

//new RecoveryTime = 0;

new Text3D:gPlayerProdText[MAX_PLAYERS] = {Text3D:-1, ...},
	gPlayerProdCP[MAX_PLAYERS];

new Text3D:ShipText[MAX_PLAYERS],
	ObjectShip[MAX_PLAYERS] = {0x7F800000,...};


new Text3D:med_turn_text[4];

new Text3D:PlayerMehText[MAX_PLAYERS] = {Text3D:-1, ...};

new Text3D:PlayerEatText[MAX_PLAYERS] = {Text3D:-1, ...};

new ABC[20][2] 	= { "E", "R", "T", "Y", "U", "O", "A", "S", "D", "F", "G", "H", "K", "Z", "X", "C", "V", "B", "N", "M" };

enum _spectator {
	sID
}
new SERIU[MAX_PLAYERS][_spectator];
new avir[MAX_PLAYERS];
new aint[MAX_PLAYERS];
new Lastspec[MAX_PLAYERS];

new take_items[MAX_PLAYERS][2];

enum _bl {
	bool:bl_is_killed,
	bl_finder,
	bl_observe,
	bool:bl_fraction[MAX_FRACTIONS + 1],
	bl_reason[42]
}
new bl_info[MAX_PLAYERS][_bl];
new bl_name[MAX_PLAYER_NAME + 1];

new Teleport_Players[2] = 0,
	bool:Teleport,
	Teleport_text[36] = {"None"},
	Float:TeleportFloat[3],
	TeleportInfo[2];

enum aInfo {
	aID,            // - Unknown -
	aPlayerID,      // - Unknown -
	aModel,			//Model
	aCost,			//Цена
	Float:aPos_X,	//Кордината X
	Float:aPos_Y,	//Кордината Y
	Float:aPos_Z,	//Кордината Z
	Float:aPos_A,	//Угол поворота
	aColor_1,		//Цвет 1
	aColor_2,		//Цвет 2
	aBizz			//Автосалон
};

new drieltorka[MAX_PLAYERS];

new election;
new Text3D:election3D;

new ATMNames[15][24] =  {
	"ЖД Вокзал г. ЛВ", // 0
	{"Аммунация г. ЛС"}, // 1
	{"ЖД Вокзал г. ЛС"}, // 2
	{"ЖД Вокзал г. СФ"}, // 3
	{"Мэрия"}, // 4
	{"Автошкола"}, // 5
	{"Казино"}, // 6
	{"АЗС Гетто"}, // 7
	{"Отели"}, // 8
	{"Автосалон г. ЛС"}, // 9
	{"Автосалон г. СФ"}, // 10
	{"Автосалон г. ЛВ"}, // 11
	{"Мотосалон"}, // 12
	{"Военкомат"}, // 13
	{"Яблочный сад"} // 14
};
new WeaponNames[48][40] = {
	"Unarmed (Fist)", // 0
	{"Brass Knuckles"}, // 1
	{"Golf Club"}, // 2
	{"Night Stick"}, // 3
	{"Knife"}, // 4
	{"Baseball Bat"}, // 5
	{"Shovel"}, // 6
	{"Pool Cue"}, // 7
	{"Katana"}, // 8
	{"Chainsaw"}, // 9
	{"Purple Dildo"}, // 10
	{"Big White Vibrator"}, // 11
	{"Medium White Vibrator"}, // 12
	{"Small White Vibrator"}, // 13
	{"Flowers"}, // 14
	{"Cane"}, // 15
	{"Grenade"}, // 16
	{"Teargas"}, // 17
	{"Molotov"}, // 18
	{" "}, // 19
	{" "}, // 20
	{" "}, // 21
	{"Pistols"}, // 22
	{"Desert Eagle (Silencer)"}, // 23
	{"Desert Eagle"}, // 24
	{"Shotgun"}, // 25
	{"Sawnoff Shotgun"}, // 26
	{"Combat Shotgun"}, // 27
	{"Micro Uzi (Mac 10)"}, // 28
	{"MP5"}, // 29
	{"AK47"}, // 30
	{"M4"}, // 31
	{"Tec9"}, // 32
	{"Country Rifle"}, // 33
	{"Sniper Rifle"}, // 34
	{"Rocket Launcher"}, // 35
	{"Auto Rocket Launcher"}, // 36
	{"Flamethrower"}, // 37
	{"Minigun"}, // 38
	{"Satchel Charge"}, // 39
	{"Detonator"}, // 40
	{"Spray Can"}, // 41
	{"Fire Extinguisher"}, // 42
	{"Camera"}, // 43
	{"Night Vision Goggles"}, // 44
	{"Infrared Vision Goggles"}, // 45
	{"Parachute"}, // 46
	{"Fake Pistol"} // 47
};
#define MAX_DUELS 100
enum duel_data {
	duel_type,
	duel_raund,
	duel_map,
	duel_health,
	duel_armour,
	duel_password,
	duel_owner_id,
	duel_id[6],
	duel_gun,
	duel_gun_2,
	duel_money,
	duel_cash,
	bool:duel_start,
	bool:duel_create,
	duel_point_1,
	duel_point_2,
	duel_leave[6],
	duel_vw
}
new DI[MAX_DUELS][duel_data];
new duel_id_gun[5] = {24,25,29,30,31};

#define STANDART_GUN_TEXT ""W"%s\n"G"ALT"
#define MAX_DROP_GUNS 250
new GPDIO[47]={0,331,333,334,335,336,337,338,339,341,321,322,323,324,325,326,342,343,344,0,0,0,346,347,348,349,350,351,352,353,355,356,372,357,358,359,360,361,362,363,364,365,366,367,368,368,371};
enum drop_gun_data {
	dg_gun,
	dg_ammo,
	dg_object,
	Text3D:dg_text,
	dg_time
}
new drop_gun[MAX_DROP_GUNS][drop_gun_data];


new TOTALSTYLELIST = 0;
enum rgInfo {
	Float:rgPos1[3],
	Float:rgPos2[3],
	rgPlayer[2],
	rgTime,
	rgState,
	rgPrice
}

new RingInfo[5][rgInfo];
new RingCP[2];
new mine_ruda[MAX_PLAYERS][4];

enum admCMD {
	cmdName[32],
	cmdInfo[64],
	cmdLVL
};
#define MAX_YOUTUBE_CMDS 17
enum ytCMD {
	cmdName[32],
	cmdInfo[64],
	cmdLVL
};
new YoutubeCommand[MAX_YOUTUBE_CMDS][ytCMD] = {
	{"/veh", "cоздать транспорт",1},
	{"/delveh", "удалить транспорт", 1},
	{"/goto", "телепортироваться к игроку", 1},
	{"/re", "войти в режим слежки за игроком", 1},
	{"/reoff", "выйти из режима слежки", 1},
	{"/slap","подкинуть игрока", 2},
	{"/gethere", "телепортировать к себе", 2},
	{"/astats", "посмотреть статистику игрока", 2},
	{"/ysay", "написать за другого игрока", 2},
	{"/tp", "телепортироваться", 3},
	{"/jp", "включить jet-pack", 3},
	{"/ans", "написать игроку", 3},
	{"/gomp", "создать мероприятие", 3},
	{"/gun", "выдать оружие", 3},
	{"/jail", "посадить в тюрьму", 3},
	{"/mute", "поставиь затычку", 3},
	{"/kick", "кикнуть", 3}

};
#define MAX_ADM_CMDS 119
new AdminCommand[MAX_ADM_CMDS][admCMD] = {
	{"/alogin", "авторизоваться в админ панели", 1},
	{"/a", "чат администрации", 1},
	{"/pm", "ответить в репорт", 1},
	{"/weap", "посмотреть оружие игрока", 1},
	{"/admins", "админы онлайн", 1},
	{"/jlist", "посмотреть игроков в тюрьме", 1},
	{"/re", "следить за игроком", 1},
	{"/getskills", "узнать навыки владения оружия игрока", 1},
	{"/m", "мегафон", 1},
	{"/gg", "пожелать приятной игры", 1},
	{"/ainfo", "узнать свою статистику", 1},
	{"/afklist", "игроки в АФК", 1},
	{"/gm", "включить/отключить ГМ", 1},
	{"/skin", "сменить скин", 1},
	{"/hp", "выдать себе 100 хп", 1},

	{"/jail", "посадить в тюрьму", 2},
	{"/unjail", "выпустить из тюрьмы", 2},
	{"/mute", "заблокировать чат", 2},
	{"/unmute", "разблокировать чат", 2},
	{"/tp", "телепорт", 2},
    {"/spawn [/sp]", "телепортировать(ся) на спавн", 2},
	{"/spcar", "заспавнить автомобиль (в котором сидишь)", 2},
	{"/flip", "перевернуть и починить машину игрока", 2},
	{"/goto [/g]", "телепортироватся к игроку", 2},
	{"/fly", "включить режим полёта", 2},
	{"/setfuel", "установить количество бензина в машине", 2},
	{"/kick", "кикнуть игрока", 2},
	{"/atipster", "прослушка рации организации", 2},
	{"/astats", "посмотреть статистику игрока", 2},
	{"/aimcheck", "проверить на AIM", 2},
	{"/gettime", "узнать время игрока", 2},
	{"/delfences", "удалить ограждение", 2},
	{"/uncuff", "снять наручники", 2},
	{"/alock", "открыть/закрыть транспорт", 2},
	{"/ghouse", "телепорт к дому", 2},
	{"/gbiz", "телепорт к бизнесу", 2},
	{"/tpint", "телепорт в интерьер", 2},

	{"/tskin", "выдать временный скин игроку", 3},
	{"/msg", "отправить сообщение в общий чат (видно всем игрокам)", 3},
	{"/templeader", "выдать себе временную лидерку", 3},
	{"/skick", "тихий кик", 3},
    {"/ban", "заблокировать аккаунт", 3},
	{"/warn", "выдать предупреждение", 3},
	{"/cweap", "забрать оружие у игрока", 3},
	{"/gethere", "телепортировать игрока к себе", 3},
	{"/okey", "одобрить смену ника", 3},
	{"/freeze", "заморозить игрока", 3},
	{"/unfreeze", "разморозить игрока", 3},
	{"/offstats", "статистика игрока в оффлайн", 3},
	{"/getid", "узнать ник по ID игрока", 3},
	{"/slap", "подкинуть игрока", 3},
	{"/graff", "граффити", 3},
	{"/mark", "поставить метку для телепорта где стоишь", 3},
	{"/gotomark", "телепортироваться к метке", 3},
	{"/sethp", "выдать ХП игроку", 3},
	{"/setarm", "выдать броню игроку", 3},
	{"/last", "узнать последний вход игрока", 3},
	{"/awarehouse", "состояние складов организаций", 3},
	{"/spveh", "спавн авто в радиусе", 3},
	{"/gotocar", "телепортироваться к авто", 3},
	{"/getherecar", "телепортировать авто к себе", 3},
	{"/hinfo", "узнать информацию о Хелпере", 3},
	{"/delveh", "удалить админ авто", 3},
	{"/offgettime", "просмотр статистики в оффлайне", 3},
	{"/offjail", "посадить в тюрьму оффлайн", 3},
	{"/offunjail", "вытащить из тюрьмы оффлайн", 3},
	{"/offmute", "заблокировать чат в оффлайн", 3},
	{"/offunmute", "разблокировать чат в оффлайн", 3},
	{"/offwarn", "выдать предупреждение в оффлайн", 3},

	{"/getip", "узнать IP адреса игрока", 4},
	{"/agetip", "узнать IP адреса игрока в оффлайн", 4},
	{"/unbanip", "разблокировка IP адреса", 4},
	{"/offban", "блокировка аккаунта оффлайн", 4},
	{"/unban", "разблокировать аккаунт", 4},
	{"/fin", "посмотреть прибыль бизнеса", 4},
	{"/veh", "cоздать транспорт", 4},
	{"/unwarn", "снять предупреждение игроку", 4},
	{"/offunwarn", "снять предупреждение игроку в оффлайн", 4},
	{"/weather", "установить погоду", 4},
	{"/uval", "уволить игрока", 4},
	{"/hpall", "выдать хп всем в радиусе", 4},
	{"/spall", "заспавнить всех в радиусе", 4},
	{"/gettax", "балланс казны", 4},
	{"/givegun", "выдать оружие", 4},
	{"/gomp", "провести мероприятие", 4},
	{"/captfreeze", "заморозить стрелы/капты", 4},
	{"/spcars", "заспавнить весь не занятый транспорт", 4},
	{"/tempzone", "перекрасить ганг-зону", 4},
	{"/setbizmafia", "передать бизнес др. мафии", 4},
	{"/ram", "войти в закрытый дом", 4},
	
	{"/settime", "установить игровое время", 5},
	{"/ears", "прослушка SMS", 5},
	{"/dvall", "удалить все админ авто", 5},
	{"/infoips", "пробить твинков по IP", 5},
	{"/paint", "запустить сумасшедшие войны", 5},
	{"/race", "запустить безумные гонки", 5},
	{"/golod", "запустить голодные игры", 5},
	{"/sban", "тихая блокировка аккаунта", 5},
	{"/amusic", "онлайн радио", 5},
	{"/banip", "блокировка IP адреса", 5},


	{"/obj", "создать объект", 6},
	{"/eobject", "редактировать объект", 6},
	{"/dobject", "удалить объект", 6},
	{"/hbject", "создать объект на игрока", 6},
	{"/hbedit", "редактировать объект на игроке", 6},
	{"/getdonate", "узнать пополнения(донат) игрока", 6},
	{"/reloadbans", "перезагрузить блокировки аккаунтов", 6},
	{"/block", "заблокировать до 2038 года", 6},
	{"/offblock", "заблокировать до 2038 года в оффлайн", 6},
	{"/setmats", "изменить маты организациям", 6},
	{"/admstats", "узнать статистику админа", 6},
	{"/delacc", "удалить аккаунт игрока", 6},
	{"/givelic", "выдать все лицензии", 6},
	{"/makedj", "добавить DJ", 6},
	{"/makehelper", "добавить Хелпера", 6},
	{"/makeleader", "назначить лидера", 6},
	{"/asettax", "добавить денег в казну", 6},
	{"/makeadmin", "добавить модератора", 6},
	{"/setskin", "изменить постоянный скин", 6}
};

new ArendInfo[][aInfo] =
{//ID, Цена, Координаты X, Y, Z, Цвет 1, Цвет 2
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 471, 1800 ,2137.3403, -1135.8445, 25.1808, 100.0000,-1,-1,71 }, // Моторынок1
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 461, 5500 ,2136.8276, -1133.4684, 25.2229, 100.0000,-1,-1,71 }, // Моторынок2
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 462, 220 ,2136.8013, -1130.9340, 25.1831, 100.0000,-1,-1,71 }, // Моторынок3
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 510, 130 ,2137.0405, -1128.2262, 25.2155, 100.000,-1,-1,71 }, // Моторынок4

	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 401, 1500 ,546.2834, -1267.1354, 17.0241, 220.0000,-1,-1,68 }, // Авторынок ЛС 1
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 585, 1600 ,542.8993, -1270.2717, 16.8330, 220.0000,-1,-1,68 }, // Авторынок ЛС 2
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 518, 1200 ,539.4501, -1273.0795, 16.9120, 220.0000,-1,-1,68 }, // Авторынок ЛС 3
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 466, 1800 ,536.1959, -1275.8226, 16.9862, 220.0000,-1,-1,68 }, // Авторынок ЛС 4
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 491, 2100 ,533.1170, -1278.3557, 17.0001, 220.0000,-1,-1,68 }, // Авторынок ЛС 5
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 410, 1000 ,529.7689, -1280.4216, 16.9001, 220.0000,-1,-1,68 }, // Авторынок ЛС 6

	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 496, 3100 ,-1974.8362, 304.6295, 34.8882, 180.0000,-1,-1,69 }, // Авторынок СФ 1
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 603, 9100 ,-1969.8870, 304.8717, 35.0099, 180.0000,-1,-1,69 }, // Авторынок СФ 2
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 405, 4200 ,-1990.2765, 268.6406, 35.0523, 302.6477,-1,-1,69 }, // Авторынок СФ 3
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 533, 5200 ,-1990.7843, 261.6671, 34.8903, 305.8713,-1,-1,69 }, // Авторынок СФ 4
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 558, 7100 ,-1991.5657, 255.2777, 34.8033, 303.7885,-1,-1,69 }, // Авторынок СФ 5
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 566, 4900 ,-1990.5830, 248.7883, 34.9516, 297.9163,-1,-1,69 }, // Авторынок СФ 6
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 589, 8200 ,-1984.7192, 242.3710, 34.8346, 0.0000,-1,-1,69 }, // Авторынок СФ 7
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 579, 7600 ,-1978.6296, 242.8808, 35.0709, 0.0000,-1,-1,69 }, // Авторынок СФ 8

	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 480, 17300 ,2113.7048, 1398.2725, 10.5959, 180.0000,-1,-1,70 }, // Авторынок ЛВ 1
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 434, 22000 ,2119.8660, 1398.3364, 10.7829, 180.0000,-1,-1,70 }, // Авторынок ЛВ 2
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 541, 35000 ,2126.3828, 1398.0538, 10.4396, 180.0000,-1,-1,70 }, // Авторынок ЛВ 3
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 562, 18800 ,2132.8091, 1398.4464, 10.4771, 180.0000,-1,-1,70 }, // Авторынок ЛВ 4
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 602, 8000 ,2139.0806, 1398.1453, 10.6202, 180.0000,-1,-1,70 }, // Авторынок ЛВ 5
	{ INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 560, 22200 ,2145.6101, 1398.2130, 10.5196, 180.0000,-1,-1,70 } // Авторынок ЛВ 6
};

new Float:med_heal[12][4]={
	{1560.5155,496.3742,1070.9421,272.3593}, // кровать 1
	{1563.1982,496.3743,1070.9421,270.4559}, // кровать 2
	{1565.7197,496.4349,1070.9421,268.5757}, // кровать 3
	{1561.0460,508.9258,1070.9421,88.0939}, // кровать 4
	{1563.6310,509.0753,1070.9421,90.2871}, // кровать 5
	{1566.2164,508.8936,1070.9421,91.8540}, // кровать 6
	{1542.9122,508.9595,1070.9421,88.0470}, // кровать 7
	{1545.4645,509.0333,1070.9421,91.1570}, // кровать 8
	{1548.0690,508.9948,1070.9421,91.7836}, // кровать 9
	{1547.6119,496.5009,1070.9421,272.2653}, // кровать 10
	{1545.0653,496.4404,1070.9421,269.4219}, // кровать 11
	{1542.4304,496.4236,1070.9421,271.6151} // кровать 12
};
enum ticlist {
	tID,
	tName[MAX_PLAYER_NAME],
	tPrice,
	tDate[32],
	tReason[30],
}
new TL[MAX_PLAYERS][15][ticlist], TOTALTICKETS[MAX_PLAYERS];
new SALLROWS[MAX_PLAYERS];

#define WD::                    WoodsInfo
#define MAX_WOODS               14
enum woodsInfo {
	woodObject,
	woodZone,
	bool:woodUse
};
new WD::[MAX_WOODS][woodsInfo];
new Float:Woods[MAX_WOODS][6] = {
	{-495.984649, -1603.825073, 4.579759, -0.000022, -0.000018, -28.599811},
	{-499.378234, -1609.924194, 5.349759, -0.000022, -0.000018, -28.599811},
	{-504.325317, -1602.181762, 5.069756, -0.000022, -0.000018, -28.599811},
	{-511.276000, -1614.929931, 6.579750, -0.000022, -0.000018, -28.599811},
	{-503.816925, -1615.955566, 6.289748, -0.000022, -0.000018, -28.599811},
	{-508.378845, -1624.322509, 7.429743, -0.000022, -0.000018, -28.599811},
	{-526.272216, -1614.567138, 9.079734, -0.000022, -0.000018, -28.599811},
	{-522.710998, -1608.035278, 7.379727, -0.000022, -0.000018, -28.599811},
	{-527.820922, -1604.748291, 7.489733, -0.000022, -0.000018, -28.599811},
	{-533.318420, -1607.082519, 9.099727, -0.000022, -0.000018, -28.599811},
	{-521.210449, -1594.755126, 5.479712, -0.000022, -0.000018, -28.599811},
	{-516.609863, -1597.262939, 5.479712, -0.000022, -0.000018, -28.599811},
	{-512.211425, -1595.902099, 5.149709, -0.000022, -0.000018, -28.599811},
	{-498.067321, -1597.075073, 4.579759, -0.000022, -0.000018, -28.599811}
};

new Text3D:wood_3dtext;
new woodsklad;
new casino;
new rep_system;
new duels;
new anti_tk;
new tk_unloading[4];

new invite_frac[8];

enum fraction_weapon_data {
	fwID,
	fwName[32],
	fwGunID,
	fwGunAmmo,
	fwArmor,
	fwRank
}
new FW[9][MAX_FRACTIONS + 1][fraction_weapon_data];
new GunTickGet[MAX_PLAYERS][9];

new bool:zahvat = false;
new CaptureAttempt[6]={0,...};
new CountOnZone[23];
new capture_kd[23];

new fracmoroz [8]={0,...};
new const fracmorozName [8][32]={"The Ballas","Los Santos Vagos","Grove Street","The Rifa","Varrios Los Aztecas", "La Cosa Nostra", "Yakuza","Русской мафии"};

new
	bizwar_kd[23],
	BizWarTime = 0,
	biz_war_gangzone = - 1,
	Float:bizwar_coordinates[4];

#define MOROZ_LCN 5
#define MOROZ_YAKUZA 6
#define MOROZ_RM 7
new gBankMafia[3][MAX_BUSINESS_COUNT];

enum MzoneInfo {
	bFrakVlad,
	bNapad,
	bBiz,
	bCountDead[18]
}
/*
new Float:mafia_zone[7][4] = {
	{-413.7659, 1504.788, -278.7655, 1635.785},//Метеостанция 0
	{-461.2375, 2190.1268, -339.2005, 2278.1268},//СВ-ВВС 1
	{-1355.469, 2478.460, -1267.469, 2561.465},//Каменная деревня 2
	{-1752.000, -66.000, -1652.00, 34.0000},//Порт СФ 3
	{-1473.5905, -1588.8917, -1408.590, -1445.8917},//Вестоун 4
	{-1933.913, -1717.885, -1751.9138, -1592.8852},//Угольная шахта 5
	{2373.1386, -2667.0048, 2527.1386, -2507.0048}//Каменная деревня 6
};*/
new MZInfo[MzoneInfo];

new IDGZ[MAX_PLAYERS] = {-1,...};
enum GzoneInfo {
	gID,
	gZone,
	Float:gCoords[4],
	gFrakVlad,
	gNapad,
	gTime,
	ZoneOnBattle,
	gzTimer
}
new GZInfo[104][GzoneInfo];
new TOTALGZ = 0;
new VladGzone[MAX_FRACTIONS]={0,...};
new gz_area;

enum _ATMData {
	Float:ATM_Pos[6],
	atm_VW,
	atm_INT,
	Text3D:atm_Label,
	atm_Object,
	atm_Taken,
	atm_Bank,
	atm_BankTime
}
new ATMData[MAX_ATM + 1][_ATMData];
new EdittingATM[MAX_PLAYERS];

new TextArray[11] = "1234567890";

new med_mskin[] = {50,15,35},
	med_gskin[] = {55,90,192};

new Signal[MAX_VEHICLES];
new Float:SignalAngle[MAX_VEHICLES];
new SignalTick[MAX_VEHICLES][2];
new LightsObject[MAX_VEHICLES][2];
//new perf_object_engine[MAX_VEHICLES];
new g_sign_up_timer,
	g_game_status = 0,
	g_default_colors[4] = {0xFFE61400,0xFF0066CC,0xFF319A31,0xFFFF7F00};
new p_has_color[MAX_PLAYERS],
	g_start_pos[4] = {0, 7, 56, 63};
new b_gobjectid[4],
	b_button[64],
	b_pickupid[64],
	b_objectid[64],
	b_has_color[64],
	b_unique_id[64],
	g_arena_created = false;

new JobTempProcess[MAX_PLAYERS];
new second_timerlog;

new patrul_id[MAX_PLAYERS],
	tick_wanted[MAX_PLAYERS char],
	time_wanted[MAX_PLAYERS];

new spaned[MAX_PLAYERS];

new open_game = 0; // если 0 - рега закрыта, 1 - открыта
new time_registr_game; // время на регистрацию
new time_play_game;
new players_in_game; // количество игроков зарегалось
new money_in_game; // бюджет регистрации
new game_start; // игра началась или нет
new player_to_game[MAX_PLAYERS];
new kills_player_game[MAX_PLAYERS];
new weapon_id_game[] ={22,23,24,25,28,29,30,31,33,34};
new Text3D:gamedm_text;
new Text3D:gamerace_text;
new Text3D:golod_text;

new Text3D:labrary_text;
new Text3D:army_text[2];
new bool:army_chs[2];
new tuningtaxi_text[4][20];
new tuningtaxi_text_1[4][20];
new tuningtaxi[4][20];
new tuningtaxi_1[4][20];
new tuningtaxi_shash[4][20];
new actor[MAX_ACTORSS];
new Text3D:tActor[MAX_ACTORSS];
new actortime[MAX_ACTORSS];
new speed_timer[MAX_PLAYERS]={-1,...};


new addchet[MAX_PLAYERS];

new FirstBL[MAX_PLAYERS],
	UnbanName[MAX_PLAYERS][24];

new FirstReferal[MAX_PLAYERS];
new FirstFamily[MAX_PLAYERS];

new prod_id[MAX_PLAYERS];

new idaofcar[MAX_PLAYERS],
	nedded[MAX_PLAYERS];

new shotTime[MAX_PLAYERS],
	shot[MAX_PLAYERS];

new Text3D:gMenu[5],
	Text3D:mMenu[3],
	Text3D:gHealth[5];

new CountFloodForPlayer[MAX_PLAYERS];

new advertise_price,
	action_server[3];

new car_spawn[MAX_PLAYERS];

new house_car[MAX_PLAYERS][2],
	car_autoschool[MAX_PLAYERS];

new WantNickChange[MAX_PLAYERS][MAX_PLAYER_NAME];

new GunPlayer[MAX_PLAYERS][13][2];
new AC_GunCheattime[MAX_PLAYERS]={0,...};

new HealOffer[MAX_PLAYERS],
	HealPrice[MAX_PLAYERS];

new oilsklad,
	Text3D:oil_3dtext;

new pricedrugs;
new disease;
new object_oil[MAX_PLAYERS];

new Text3D:sklad_armysf[3],
	Text3D:sklad_armylv[2],
	Text3D:sklad_cops[4];

new TotalGZ[5],
	Text3D:black_market,
	black_prods[10];
	
new WebSites[][] = 
{ ".ws", ".ru", ".tk", ".com", "www.", ".org", ".net", ".cc", ".рф", ".by", ".biz", ".su", ".info", "мать", "мамку", "матерей", "шлюх", "flame", "флейм"};
new UpomRod[][] = 
{ 	"мамка", "mamka", "мамке", "mamke", "мамаше", "mamashe", "маму", "mamu", "mamy",
	"маме", "mame", "мамку", "mamku", "mamky", "мамашу", "mamashy", "mamashu",
	"мама","mama", "мать", "m q", "m.q", "mq", "матуха", "матуху", "mat'",
	"м@му", "м@ма", "м@мку", "м@мка", "ма.му", "ма.ма", "ма.му", "ма.ма",
	"matj", "mй", "м@ть", "м.а.т.ь", "м.а.м.а", "м.а.м.у", "м.а.м.к.а", "м.а.м.к.у",
	"сын", "отец", "папа" 
};
new BadWords[][] = 
{ 	"сука", "пидорас", "блять", "блядь", "хуй", "залупа", "член", "гандон", "ублюдок",
	"пидор", "пидрила", "хуила", "долбоеб", "дебил", "нахуй", "еблан", "хуйлан",
	"говно","хуйня", "пенис", "хер", "блядина", "шлюха", "жопа", "петух", "питух",
	"мудила", "блядун", "вагина", "ебланище", "пизда", "педрила", "шалава", "жопа",
	"жопу", "пизду", "шалаву", "хуи", "залупы", "ублюдки", "пидрилы", "хуилы",
	"нахуя", "говнари", "говнарь", "вагины", "выблядок", "выблядки", "сосите",
	"сосать", "сосми", "хуесос", "проститутка", "проститутки","ховно", "посасывай",
	"соснул", "лох", "чмо", "аутист", "даун", "дцп", "гнида","уебан", "анус",
	"пидарас", "манда", "машонка", "долбаеб", "ебучий", "ебанутый", "мудак",
	"хуеплет", "хуеплёт", "шалавы", "шлюхи", "ебать", "ебучие", "ёбарь", "ебаные",
 	"syka", "suka", "ебливые", "пиздец", "залупка", "шмара", "пидорша", "дура",
    "daun", "dayn", "eblan", "pidor", "4mo", "пидр", "pidr", "хуйло", "xuilo",
    "ебланы", "ебал", "пидар", "lox", "loh", "говно", "соснет", "соснёт", "naxuy",
	"hui", "sosi", "блеать", "nahoy", "сосут", "xuy", "псина", "psina", "пiзда",
	"sobaka", "пес", "пёс", "dura", "dyra", "dro4i", "дрочи", "дрочить", "xy`",
	"dro4it'", "епт", "ёпт", "епта", "ёпта", "bomj", "пнх", "сперма","трансуха",
	"транс", "transuxa", "transuha", "умри", "сдохни", "ymri", "umri", "трахал",
	"dro4it", "тупой", "бля", "дауны", "даун", "собака", "бомж"
};
new delimiters[]={'.', ' ', ',', '*', '/', ';', '\\', '|'};
new dostup[MAX_PLAYERS];

new engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

new gPlaneCount;

/* new Float:LightsPos[212][6] =
{
	{ 0.8766, 2.0272, -0.1000, 0.8766, -2.2272, -0.1000 },
	{ 0.9566, 2.4500, 0.0000, 0.9566, -2.3500, 0.0000 },
	{ 0.8033, 2.5363, 0.0000, 0.9033, -2.6363, 0.0000 },
	{ 1.1500, 4.1909, -0.2000, 0.3499, -4.1909, -0.7000 },
	{ 0.7333, 2.2409, 0.2000, 0.8333, -2.6409, 0.0000 },
	{ 0.9833, 2.2272, -0.1000, 0.8833, -2.7272, -0.1000 },
	{ 1.0566, 5.2681, 0.0000, 2.2566, -5.1681, 0.4000 },
	{ 0.8499, 4.0727, 0.1000, 1.0499, -3.4727, 0.2000 },
	{ 0.9399, 4.8590, -0.4000, 0.8399, -4.0590, -0.5000 },
	{ 0.8899, 3.6181, 0.0000, 0.8899, -3.9181, 0.0000 },
	{ 0.8533, 2.1772, 0.0000, 0.8533, -2.1772, 0.0000 },
	{ 0.9966, 2.6272, -0.2000, 0.8966, -2.4272, 0.0000 },
	{ 0.9166, 2.6227, -0.1000, 0.8166, -3.6227, -0.2000 },
	{ 0.9600, 2.6727, -0.1000, 0.9600, -2.6727, 0.0000 },
	{ 0.7399, 2.8136, -0.1000, 1.0399, -3.2136, 0.0000 },
	{ 0.8733, 2.5045, -0.3000, 0.7733, -2.5045, 0.0000 },
	{ 0.9099, 2.9409, 0.0000, 1.1100, -3.7409, -0.5000 },
	{ 1.8166, 10.5772, 0.0000, 1.8166, -10.5772, 0.0000 },
	{ 0.9566, 2.4772, -0.2000, 1.0566, -2.5772, -0.2000 },
	{ 0.8000, 2.7272, -0.4000, 0.8000, -2.9272, -0.2000 },
	{ 0.9033, 2.3863, 0.0000, 0.9033, -2.6863, 0.0000 },
	{ 0.8500, 2.6045, -0.2000, 0.8500, -2.9045, -0.2000 },
	{ 0.7566, 2.2454, -0.3000, 0.8566, -2.4454, -0.3000 },
	{ 0.7733, 2.2999, 0.0000, 0.8733, -2.2000, 0.0000 },
	{ 0.7199, 1.5545, 0.2000, 0.6199, -1.6545, 0.3000 },
	{ 1.7199, 8.4681, 0.0000, 1.7199, -8.4681, 0.0000 },
	{ 1.0033, 2.3863, 0.0000, 0.9033, -2.6863, 0.0000 },
	{ 0.8800, 3.3272, -0.1000, 0.9800, -3.7272, 0.3000 },
	{ 0.9100, 2.5545, 0.2000, 0.9100, -2.9545, 0.2000 },
	{ 0.7366, 2.2545, -0.3000, 0.8366, -2.4545, 0.0000 },
	{ 1.5900, 7.6818, 0.0000, 1.5900, -7.6818, 0.0000 },
	{ 1.0033, 5.9499, 0.4000, 1.0033, -5.8499, 0.0000 },
	{ 1.4333, 4.1681, 0.0000, 1.4333, -4.1681, 0.0000 },
	{ 1.2333, 3.7454, -0.1000, 1.3333, -4.7454, -0.1000 },
	{ 0.5633, 1.9772, -0.1000, 0.4633, -1.9772, -0.1000 },
	{ 1.0533, 6.1499, 0.0000, 1.0533, -3.9500, -1.1000 },
	{ 0.8600, 2.3045, 0.0000, 0.8600, -2.5045, 0.0000 },
	{ 1.2133, 5.5454, -0.2000, 1.1133, -5.2454, 0.4000 },
	{ 0.9033, 2.6454, 0.0000, 0.9033, -2.7454, -0.1000 },
	{ 0.8400, 2.4045, -0.5000, 0.8400, -2.7045, -0.1000 },
	{ 0.9700, 2.6272, -0.3000, 0.8700, -2.6272, 0.1000 },
	{ 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
	{ 0.9699, 2.8363, -0.2000, 1.0699, -3.0363, 0.0000 },
	{ 1.0866, 5.8136, -1.0000, 1.2866, -7.1136, -0.9000 },
	{ 1.1200, 2.7363, 0.7000, 1.1200, -3.0363, 0.7000 },
	{ 0.9666, 2.3636, 0.0000, 0.9666, -2.7636, -0.2000 },
	{ 1.5900, 7.7363, 0.0000, 1.5900, -7.7363, 0.0000 },
	{ 0.8066, 6.7272, 0.0000, 0.8066, -6.7272, 0.0000 },
	{ 0.2366, 0.9954, 0.0000, 0.2366, -0.9954, 0.0000 },
	{ 1.0099, 4.1045, 0.0000, 1.0099, -4.1045, 0.0000 },
	{ 1.0233, 6.1409, 0.0000, 1.0233, -3.9409, -1.2000 },
	{ 0.7733, 2.0863, -0.2000, 0.8733, -2.4863, -0.2000 },
	{ 1.2033, 6.6227, 0.0000, 1.2033, -6.6227, 0.0000 },
	{ 1.7133, 6.2590, 0.0000, 1.7133, -6.2590, 0.0000 },
	{ 2.2066, 8.6590, 0.0000, 2.2066, -8.6590, 0.0000 },
	{ 1.2066, 3.7090, -0.1000, 1.3066, -4.7090, -0.1000 },
	{ 0.8766, 3.3272, -0.1000, 0.8766, -4.6272, -0.5000 },
	{ 0.4099, 1.1863, 0.0000, 0.5099, -1.2863, 0.0000 },
	{ 0.9033, 2.4909, -0.2000, 0.9033, -2.7909, 0.0000 },
	{ 0.9666, 2.5999, -0.1000, 0.8666, -2.5999, 0.1000 },
	{ 3.6166, 6.1590, 0.0000, 3.6166, -6.1590, 0.0000 },
	{ 0.2333, 0.8181, 0.5000, 0.2333, -1.1181, 0.3000 },
	{ 0.2366, 0.9954, 0.0000, 0.2366, -0.9954, 0.0000 },
	{ 0.2333, 1.1000, 0.0000, 0.2333, -1.1000, 0.0000 },
	{ 0.5266, 0.5045, 0.0000, 0.5266, -0.7045, 0.0000 },
	{ 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
	{ 0.9433, 2.6045, 0.1000, 1.0433, -2.8045, 0.0000 },
	{ 0.6433, 2.8909, -0.1000, 0.9433, -3.0909, 0.0000 },
	{ 0.2366, 1.0136, 0.0000, 0.2366, -1.0136, 0.0000 },
	{ 0.8066, 6.7272, 0.0000, 0.8066, -6.7272, 0.0000 },
	{ 1.0866, 2.0909, 0.2000, 1.0866, -2.6909, -0.2000 },
	{ 0.4733, 0.9090, 0.0000, 0.4733, -0.9090, 0.0000 },
	{ 0.8900, 4.2454, 0.0000, 0.8900, -4.2454, 0.0000 },
	{ 0.9666, 2.4545, 0.0000, 0.9666, -2.4545, 0.0000 },
	{ 0.9100, 2.7409, 0.0000, 1.0099, -2.7409, -0.1000 },
	{ 0.9166, 2.5272, -0.3000, 0.8166, -2.8272, -0.3000 },
	{ 3.6766, 5.1318, 0.0000, 3.6766, -5.1318, 0.0000 },
	{ 0.7900, 2.6954, -0.2000, 1.0900, -2.5954, 0.1000 },
	{ 0.9166, 2.2318, 0.0000, 1.0166, -2.5318, -0.3000 },
	{ 0.9500, 2.4954, 0.0000, 0.9500, -2.7954, 0.0000 },
	{ 0.8566, 1.7909, 0.0000, 0.8566, -2.2909, -0.2000 },
	{ 0.2366, 0.8545, 0.0000, 0.2366, -0.8545, 0.0000 },
	{ 0.8799, 2.3909, -0.4000, 0.8799, -2.5909, 0.0000 },
	{ 0.7833, 2.6136, 0.0000, 0.6833, -2.8136, -0.3000 },
	{ 1.7833, 11.9090, 0.0000, 1.7833, -11.9090, 0.0000 },
	{ 0.6566, 1.7500, 0.0000, 0.6566, -1.3499, 0.0000 },
	{ 0.8466, 1.5636, 1.0000, 0.5466, -3.2636, 1.1000 },
	{ 0.7766, 6.8363, 0.0000, 0.7766, -6.8363, 0.0000 },
	{ 0.7766, 5.7318, 0.0000, 0.7766, -5.7318, 0.0000 },
	{ 1.0466, 2.5909, 0.0000, 1.1466, -2.6909, 0.2000 },
	{ 0.9733, 3.1499, 0.0000, 1.1733, -3.1499, 0.1000 },
	{ 0.8700, 2.5772, -0.1000, 0.8700, -2.8772, 0.0000 },
	{ 0.7833, 2.6090, 0.0000, 0.7833, -2.8090, 0.0000 },
	{ 1.5900, 8.1045, 0.0000, 1.5900, -8.1045, 0.0000 },
	{ 0.8500, 2.3500, -0.2000, 0.8500, -2.8499, 0.1000 },
	{ 1.1266, 2.3772, 0.0000, 1.1266, -2.0772, 0.0000 },
	{ 0.9600, 2.2590, 0.0000, 0.9600, -2.0590, 0.0000 },
	{ 0.7766, 6.8363, 0.0000, 0.7766, -6.8363, 0.0000 },
	{ 0.8666, 3.0999, 0.2000, 0.9666, -3.0999, 0.3000 },
	{ 0.7799, 2.5727, -0.2000, 1.0800, -3.4727, 0.1000 },
	{ 0.4633, 2.0772, -0.2000, 0.7633, -1.9772, 0.0000 },
	{ 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
	{ 0.8833, 2.6136, -0.2000, 0.7833, -2.7136, 0.0000 },
	{ 0.8366, 2.3909, 0.0000, 0.8366, -2.8909, 0.0000 },
	{ 0.9433, 2.6454, 0.1000, 1.0433, -2.8454, 0.0000 },
	{ 1.0466, 2.5909, 0.0000, 1.1466, -2.6909, 0.1000 },
	{ 0.7500, 2.2727, -0.3000, 0.8500, -2.3727, 0.0000 },
	{ 1.0566, 2.5954, -0.1000, 1.1566, -2.8954, -0.1000 },
	{ 0.6866, 2.9590, -0.7000, 0.9866, -3.7590, 0.0000 },
	{ 0.2366, 0.8636, 0.0000, 0.2366, -0.8636, 0.0000 },
	{ 0.2400, 0.7909, 0.0000, 0.2400, -0.7909, 0.0000 },
	{ 7.0733, 9.6318, 0.0000, 7.0733, -9.6318, 0.0000 },
	{ 3.7200, 2.7999, 0.0000, 3.7200, -2.7999, 0.0000 },
	{ 2.8999, 4.0909, 0.0000, 2.8999, -4.0909, 0.0000 },
	{ 1.2633, 4.2772, 0.1000, 0.3633, -5.0772, -0.4000 },
	{ 1.2833, 4.4227, -0.5000, 0.3833, -4.6227, -1.3000 },
	{ 0.9666, 2.7363, 0.0000, 0.9666, -2.8363, 0.0000 },
	{ 0.9433, 2.7772, 0.0000, 0.9433, -2.7772, -0.1000 },
	{ 0.8100, 2.7272, 0.0000, 1.0099, -2.8272, -0.2000 },
	{ 6.7699, 8.7681, 0.0000, 6.7699, -8.7681, 0.0000 },
	{ 2.9166, 6.5090, 0.0000, 2.9166, -6.5090, 0.0000 },
	{ 0.2333, 1.1181, 0.0000, 0.2333, -1.1181, 0.0000 },
	{ 0.2333, 1.1181, 0.0000, 0.2333, -1.1181, 0.0000 },
	{ 0.2333, 1.1227, 0.0000, 0.2333, -1.1227, 0.0000 },
	{ 0.8966, 3.7181, 0.0000, 1.1966, -3.9181, -1.1000 },
	{ 0.8166, 3.0409, 0.1000, 0.9166, -3.1409, -0.1000 },
	{ 0.9333, 2.3545, -0.2000, 0.8333, -2.3545, 0.0000 },
	{ 0.9099, 2.5000, 0.0000, 0.9099, -2.3000, 0.0000 },
	{ 0.8499, 2.5227, -0.2000, 0.8499, -2.6227, -0.3000 },
	{ 0.9933, 2.5590, 0.0000, 0.9933, -2.5590, 0.1000 },
	{ 0.5266, -0.6772, 1.3000, 0.5266, -1.9227, 0.8000 },
	{ 0.2533, 1.5818, -0.2000, 0.2533, -1.1818, -0.1000 },
	{ 0.4733, 4.0772, 1.3000, 0.3733, -1.0772, 0.0000 },
	{ 0.9933, 2.4636, 0.0000, 0.8933, -2.5636, 0.0000 },
	{ 1.0266, 2.9499, -0.2000, 0.7266, -2.8499, -0.1000 },
	{ 0.8899, 2.4909, -0.1000, 0.8900, -2.5909, -0.1000 },
	{ 0.8199, 2.4181, -0.2000, 0.8199, -3.1181, -0.2000 },
	{ 0.7766, 2.3272, 0.0000, 1.1100, -7.9772, 0.0000 },
	{ 1.0900, 7.6409, 0.0000, 1.0900, -7.5409, 0.0000 },
	{ 0.8333, 2.0590, 0.0000, 0.8333, -1.7590, 0.0000 },
	{ 0.9633, 2.6590, -0.1000, 1.0633, -2.7590, -0.1000 },
	{ 0.6566, 2.2499, -0.2000, 0.7566, -2.2499, 0.1000 },
	{ 0.9266, 2.6090, -0.1000, 0.7266, -3.0090, -0.1000 },
	{ 0.7933, 2.3045, 0.1000, 0.9933, -2.7045, 0.0000 },
	{ 0.7366, 3.6454, -0.2000, 0.9366, -4.2454, -0.8000 },
	{ 0.5299, 1.7863, 0.0000, 0.8300, -2.0863, -0.4000 },
	{ 0.9566, 2.5636, 0.0000, 1.0566, -2.6636, 0.0000 },
	{ 0.9299, 2.5545, 0.0000, 0.9299, -2.6545, 0.1000 },
	{ 1.3933, 11.0999, 0.0000, 1.3933, -11.0999, 0.0000 },
	{ 0.9000, 2.5136, 0.0000, 0.9000, -2.5136, 0.0000 },
	{ 0.9466, 2.5772, -0.2000, 0.9466, -2.6772, -0.2000 },
	{ 0.9866, 2.5545, -0.1000, 0.9866, -3.0545, 0.0000 },
	{ 0.9833, 3.0545, 0.3000, 1.1833, -2.8545, 0.3000 },
	{ 9.5799, 10.6772, 0.0000, 9.5799, -10.6772, 0.0000 },
	{ 1.0933, 2.5045, 0.1000, 1.0933, -2.9045, 0.1000 },
	{ 0.7666, 2.2318, 0.0000, 0.6666, -2.4318, -0.2000 },
	{ 1.0199, 2.5954, 0.5000, 1.1200, -2.8954, 0.6000 },
	{ 1.1200, 2.4454, 0.7000, 1.1200, -2.7454, 0.7000 },
	{ 0.9433, 2.0863, 0.0000, 0.9433, -2.3863, 0.2000 },
	{ 0.7599, 2.3909, 0.0000, 0.8600, -2.2909, 0.2000 },
	{ 0.9733, 2.3545, -0.0000, 0.8733, -2.1545, 0.1000 },
	{ 0.8333, 2.6363, -0.1000, 0.9333, -2.6363, 0.0000 },
	{ 0.8533, 2.4136, 0.0000, 0.8533, -2.3136, 0.1000 },
	{ 1.1299, 8.4636, 0.0000, 1.1299, -8.4636, 0.0000 },
	{ 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
	{ 0.7766, 2.0909, 0.0000, 0.8766, -1.8909, 0.0000 },
	{ 0.9366, 2.7363, 0.0000, 0.9366, -2.9363, 0.0000 },
	{ 1.0033, 2.9136, -0.2000, 1.0033, -3.0136, -0.2000 },
	{ 0.4033, 2.1954, 0.0000, 0.2033, -1.4954, 0.0000 },
	{ 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000 },
	{ 0.7766, 2.3272, 0.0000, 1.1566, -9.5772, 0.0000 },
	{ 0.5233, 1.0590, 0.0000, 0.5233, -1.0590, 0.0000 },
	{ 0.3533, 0.8681, -0.1000, 0.3533, -1.0681, -0.1000 },
	{ 0.8766, 3.1545, -0.4000, 0.8766, -3.3545, -0.4000 },
	{ 0.5400, 1.7499, -0.2000, 0.5400, -1.2499, -0.2000 },
	{ 0.9300, 2.3500, 0.1000, 0.8299, -2.7499, 0.0000 },
	{ 1.0066, 2.3909, -0.2000, 1.0066, -3.1909, 0.0000 },
	{ 20.8299, 27.9272, 0.0000, 0.0000, 0.0000, 0.0000 },
	{ 1.1500, 4.3590, -0.2000, 1.1500, -5.4590, -0.5000 },
	{ 0.9233, 2.3227, 0.0000, 1.0233, -2.8227, 0.1000 },
	{ 0.7866, 2.6227, -0.2000, 1.0866, -2.8227, 0.0000 },
	{ 0.2333, 1.1181, 0.0000, 0.2333, -1.1181, 0.0000 },
	{ 0.9133, 2.5818, -0.1000, 0.9133, -3.3818, 0.1000 },
	{ 0.6566, 1.4636, 0.3000, 0.5566, -1.6636, 0.4000 },
	{ 1.1833, 7.2318, 0.0000, 1.1833, -7.2318, 0.0000 },
	{ 1.0133, 2.8681, 0.1000, 0.9133, -3.0681, 0.2000 },
	{ 0.2333, 1.2727, 0.0000, 0.2333, -1.2727, 0.0000 },
	{ 0.9699, 2.1181, -0.3000, 1.0699, -2.5181, 0.1000 },
	{ 1.0266, 3.4181, 0.4000, 1.0266, -4.0181, -0.3000 },
	{ 0.7533, 2.4136, 0.1000, 0.8533, -2.3136, 0.4000 },
	{ 1.1466, 8.3636, 0.0000, 1.1466, -8.3636, 0.0000 },
	{ 1.0600, 6.1954, 0.0000, 1.0600, -6.1954, 0.0000 },
	{ 14.8166, 26.1681, 0.0000, 14.8166, -26.1681, 0.0000 },
	{ 4.1966, 6.1590, 0.0000, 4.1966, -6.1590, 0.0000 },
	{ 0.1666, 0.4181, 0.0000, 0.1666, -0.4181, 0.0000 },
	{ 0.9499, 6.1227, 0.0000, 0.9499, -6.1227, 0.0000 },
	{ 1.0033, 2.2863, 0.0000, 0.9033, -2.6863, 0.0000 },
	{ 1.0033, 2.2863, 0.0000, 0.9033, -2.6863, 0.0000 },
	{ 1.0033, 2.3318, 0.0000, 0.9033, -2.7318, 0.0000 },
	{ 1.0733, 2.6000, 0.0000, 1.1733, -2.6000, 0.1000 },
	{ 0.8000, 2.7545, -0.1000, 1.0000, -2.7545, 0.1000 },
	{ 0.8266, 3.1636, 0.5000, 1.0266, -3.0636, 0.9000 },
	{ 0.8733, 2.1181, 0.0000, 0.8733, -2.6181, -0.3000 },
	{ 0.8800, 2.5590, -0.2000, 0.8800, -2.6590, -0.1000 },
	{ 0.8433, 2.6045, 0.1000, 1.0433, -2.8045, 0.0000 },
	{ 0.7933, 2.3045, 0.0000, 0.9933, -2.7045, 0.0000 },
	{ 0.9766, 1.5363, 0.0000, 0.9766, -1.5363, 0.0000 },
	{ 1.0066, 1.4818, 0.0000, 1.0066, -1.4818, 0.0000 },
	{ 0.4833, 2.1136, 0.0000, 0.4833, -2.1136, 0.0000 },
	{ 0.8666, 3.0999, 0.2000, 0.9666, -3.0999, 0.3000 },
	{ 0.8266, 0.6499, 0.0000, 0.8266, -0.6499, 0.0000 },
	{ 0.7100, 1.4363, 0.0000, 0.7100, -1.4363, 0.0000 }
}; */

new Float:DmArenaSpawns[13][3] = {
	{-15.2709,2522.6272,16.4844},//3
	{0.8387,2480.1719,16.4844},//4
	{10.4950,2515.0256,16.4844},//5
	{8.7762,2528.0828,16.4922},//6
	{34.5469,2523.9570,16.4844},//7
	{48.4432,2478.2725,16.4844},//8
	{54.4565,2481.7009,16.4844},//9
	{52.2536,2509.2185,16.4844},//10
	{56.1235,2517.0713,16.4844},//11
	{89.3234,2481.9392,16.4844},//14
	{107.6609,2493.5183,16.4844},//15
	{92.4067,2522.1169,16.5540},//16
	{112.5036,2519.1624,16.6917}//17
};
new Text3D:DMSTATUS[MAX_PLAYERS];
new PaintGun[] = {24,31,25,30};
new ArenaGun[] = {23,24,25,29,30,31};

new Float:DMPositions[16][3] = {
	{595.2228,918.2593,6002.3262},
	{589.9407,928.0914,6002.0322},
	{586.6329,902.3514,6018.1548},
	{584.7057,878.4374,6000.9780},
	{599.7452,885.2993,6002.5005},
	{601.0707,905.4709,6003.0117},
	{628.3613,919.1977,6000.4570},
	{629.3442,911.0972,5999.9858},
	{639.1546,921.4785,6015.9800},
	{663.1718,913.4455,5998.5186},
	{696.9830,891.0146,5997.5513},
	{681.8344,857.3040,5999.6289},
	{688.3863,843.8834,6000.3115},
	{655.5336,836.2385,6001.7065},
	{619.6937,840.1102,6000.2534},
	{647.0892,856.9950,6000.9971}
};
new legalmods[48][22] = {
	{400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
	{404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
	{415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
	{439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
	{477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
	{491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
	{492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
	{500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
	{517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
	{518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
	{527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
	{534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
	{535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
	{536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
	{540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
	{542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
	{547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
	{550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
	{551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
	{558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
	{559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
	{560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
	{561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
	{562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
	{565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
	{567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
	{575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
	{600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
	{603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
};

new Float:spawn_ls[][] = { // по 3 позиции на спавн!
	{1762.2612,-1897.7631,13.5628,269.9580}, // spawn ЖДЛС (1)
	{1762.7892,-1899.7666,13.5639,269.8118}, // spawn ЖДЛС (2)
	{1760.5597,-1899.5997,13.5633,271.2740}, // spawn ЖДЛС (3)


	{1151.1781,-1769.2253,16.5938,358.8235}, // спавн (вокзал лс) 1
	{1154.2155,-1768.7198,16.5938,359.2622}, // спавн (вокзал лс) 2
	{1157.1193,-1768.7310,16.5938,358.5310} // спавн (вокзал лс) 3
};
new Float:spawn_sf[][] = {
	{-1977.4750,123.1160,27.7047,270.2929}, // ЖД СФ 1
	{-1977.4535,137.6149,27.7047,270.2929}, // ЖД СФ 2
	{-1977.4214,152.9397,27.7047,270.2928}, // ЖД СФ 3
	{-1963.0869,145.2251,27.7087,88.5580}, // ЖД СФ 5
	{-1963.0641,134.3678,27.7087,90.4380}, // ЖД СФ 6
	{-1963.0579,123.5178,27.7087,91.0647} // ЖД СФ 7
};
new Float:spawn_lv[][] = {
	{2842.7383,1290.7621,11.3906,86.3537}, // 1pos
	{2840.1025,1277.7393,11.3906,85.7270}, // 2pos
	{2839.1521,1302.1378,11.3906,83.5336}, // 3po
	{2834.0078,1292.5236,10.7782,85.7270}, // 4pos
	{2858.9575,1290.7992,11.3906,272.4755}, // 5pos
	{2859.0649,1297.6897,11.3906,1.1496}, // 6pos
	{2858.3022,1284.0557,11.3906,179.4380} // 7pos
};

//new actorereg[MAX_PLAYERS][2];
new Talk[][] = {
	{"IDLE_chat"},
	{"prtial_gngtlkA"},
	{"prtial_gngtlkB"},
	{"prtial_gngtlkD"},
	{"prtial_gngtlkE"},
	{"prtial_gngtlkF"},
	{"prtial_gngtlkG"}
};

/*
	new PlayerTrailerTime[MAX_PLAYERS];

new Float:car_fuels[6][3] = {
	{-231.2285, -195.9663, 2.4525},
	{-224.4868, -197.6987, 2.4525},
	{-217.5300, -199.7619, 2.4525},
	{-210.7354, -201.3426, 2.4525},
	{-203.3658, -202.8208, 2.4525},
	{-195.6543, -204.4956, 2.4525}
};
*/

// pSpawn
// HOME-SPAWN - дома и отели
#define DEFAULT_SPAWN 			0
#define	HOME_SPAWN				1
#define FRACTION_SPAWN			2
#define FAMILY_SPAWN			3


enum fracspawn {

	fracInt,
	fracWorld,
	fracColor,
	Float:fracCoordsX,
	Float:fracCoordsY,
	Float:fracCoordsZ,
	Float:fracCoordsA
}
new Float:gFractionSpawn[MAX_FRACTIONS][fracspawn] = {
	{0,0,TEAM_HIT_COLOR,0.0,0.0,0.0,0.0},
	{99,40,0x110CE7FF,1376.2949,1061.4469,1626.4896,27.7764}, //LSPD
	{99,41,0x110CE7FF,1376.2949,1061.4469,1626.4896,27.7764}, //SFPD
	{99,42,0x110CE7FF,1376.2949,1061.4469,1626.4896,27.7764}, //LVPD
	{75,43,0x313131AA,2109.9412,1381.5179,1020.8400,91.1694}, //FBI
	{77,44,0xCCFF00FF,683.8852,-113.5730,1071.6169,3.1567}, //mayor
	{87,59,0x996633FF,290.4519,1939.1803,5.1970,88.9851}, //ArmySf
	{87,60,0x996633FF,289.5414,1929.8999,5.1970,87.4184}, //ArmyLV
	{93,20,0xA52A2AFF,2174.6411,578.7777,1080.4542,270.2591}, //Medics Ls
	{93,21,0xA52A2AFF,2174.6411,578.7777,1080.4542,270.2591}, //Medics Sf
	{93,22,0xA52A2AFF,2174.6411,578.7777,1080.4542,270.2591}, //Medics Lv
	{74,10,0xFF6600FF,2243.9475,744.5161,1153.9510,1.9254}, // LSn
	{74,11,0xFF6600FF,2243.9475,744.5161,1153.9510,1.9254},//SFn
	{74,12,0xFF6600FF,2243.9475,744.5161,1153.9510,1.9254},//LVn
	{73,49,0xDDA701FF,-1786.3325,-642.9802,1001.0900,115.2369},//LCN
	{73,50,COLOR_REDD,-1786.3325,-642.9802,1001.0900,115.2369},//Yakuza
	{73,51,COLOR_GRAD1,-1786.3325,-642.9802,1001.0900,115.2369},//RM
	{95,52,0xB313E7FF,1795.0190,735.8157,1072.5573,46.0240},//Ballas
	{98,53,0xDBD604AA,2708.0117,1746.2433,1215.7015,38.0406},//Vagos
	{94,54,0x009F00AA,1957.0736,1334.8208,966.4043,117.0578},//Grove
	{96,55,TEAM_AZTECAS_COLOR,1568.2350,905.4245,924.2636,90.5644},//Aztec
	{97,56,0x2A9170FF,1560.5941,708.0313,915.6061,24.5535},//Rifa
	{83,57,0xCCFF00FF,1731.4105,1367.0096,1095.3182,292.9517}//WhiteHouse
};

new gpss[MAX_PLAYERS];

enum suspect_data {
	suspect_name_folder[31],
	suspect_name_reason[90],
	suspect_level[4]
}
new suspect_player[13][suspect_data] = {
	{"Нападение",							"Нападение на гражданина\nНападение на сотр. гос.организации", 												{2,4,-1,-1}},
	{"Нападение с применением оружия",		"Нападение на гражданина\nНападение на сотр. гос.организации",												{3,3,-1,-1}},
	{"Хулиганство",							"Ограбление\nМелкое хулиганство\nУгон",																		{2,1,3,-1}},
	{"Оружие",								"Хранение без лицензии\nКража металла\nХранение металла\nТорговля оружием",									{1,2,3,3}},
	{"Взятка",								"Попытка дачи взятки",																						{2,-1,-1,-1}},
	{"Наркотические вещества",				"Использование наркотических веществ\nРеклама/Продажа/Хранение наркотиков",									{2,3,-1,-1}},
	{"Транспортные средства",				"Порча т/с или гос. имущества\nНарушение ПДД\nУгон частного т/с\nПопытка угона т/с",						{2,1,2,2}},
	{"Неподчинение",						"Неподчинение сотруднику ПД/ФБР\nНеподченение сотруднику гос. структур",									{1,2,-1,-1}},
	{"Соучастие",							"Соучастие в преступлении",																					{1,-1,-1,-1}},
	{"Проникновение",						"На объекты част. собственности\nНа охран. территорию\nВ хранилище банка",									{1,2,3,-1}},
	{"Похищение",							"Попытка похищения\nПохищение\nПохищение гос.сотрудника",													{2,3,4,-1}},
	{"Терракт",								"Планирование/Исполнение терракта",																			{6,-1,-1,-1}},
	{"Митинг",								"Организация нелегального митинга\nОрганизация революции\nВовлечение в терр.организацию",					{2,4,4,-1}}
};
new Float:camExit[5][4] = {
	{1545.9545,-1675.5330,13.5614,89.0782},
	{-1604.9307,719.3295,11.8571,0.0674},
	{2335.9099,2454.5857,14.9688,123.8118},
	{-1604.9307,719.3295,11.8571,0.0674},
	{-1604.9307,719.3295,11.8571,0.0674}
};
enum autosalon {
	autoCars,
	autoClass,
	autoWorld,
	Float:autoPosX,
	Float:autoPosY,
	Float:autoPosZ
}
new autosaloncar[78][autosalon] = {
	{419,0,1,1445.2085,705.7338,1087.9011},//1
	{404,0,1,1445.2091,710.9103,1087.9011},//1
	{401,0,1,1445.2209,716.5020,1087.9011},//3
	{410,0,1,1445.2075,721.8635,1087.9011},//4
	{412,0,1,1445.2218,727.5889,1087.9011},//5
	{413,0,1,1445.2330,733.3967,1087.9011},//6
	{422,0,1,1440.6002,735.0201,1087.9011},//7
	{439,0,1,1429.7894,740.1119,1087.9241},//8
	{467,0,1,1429.7721,735.5907,1087.9241},//9
	{466,0,1,1429.7736,731.3618,1087.9241},//10
	{474,0,1,1429.8004,726.9999,1087.9241},//11
	{479,0,1,1429.8016,723.1078,1087.9241},//12
	{492,0,1,1429.7720,718.8213,1087.9241},//13
	{491,0,1,1429.7936,714.4084,1087.9241},//14
	{517,0,1,1429.7799,709.7604,1087.9241},//15
	{518,0,1,1429.7854,705.0353,1087.9241},//16
	{542,0,1,1429.7755,699.8195,1087.9241},//17
	{543,0,1,1441.5001,712.2757,1087.9011},//18
	{545,0,1,1441.5013,725.3693,1087.9011},//19

	{549,0,2,1445.2085,705.7338,1087.9011},//1
	{575,0,2,1445.2091,710.9103,1087.9011},//1
	{576,0,2,1445.2209,716.5020,1087.9011},//3
	{600,0,2,1445.2075,721.8635,1087.9011},//4
	{585,0,2,1445.2218,727.5889,1087.9011},//5
	///////////////////////////////////////
	{603,1,3,1445.2085,705.7338,1087.9011},//1
	{579,1,3,1445.2091,710.9103,1087.9011},//1
	{589,1,3,1445.2209,716.5020,1087.9011},//3
	{580,1,3,1445.2075,721.8635,1087.9011},//4
	{567,1,3,1445.2218,727.5889,1087.9011},//5
	{566,1,3,1445.2330,733.3967,1087.9011},//6
	{561,1,3,1440.6002,735.0201,1087.9011},//7
	{558,1,3,1429.7894,740.1119,1087.9241},//8
	{555,1,3,1429.7721,735.5907,1087.9241},//9
	{554,1,3,1429.7736,731.3618,1087.9241},//10
	{551,1,3,1429.8004,726.9999,1087.9241},//11
	{534,1,3,1429.8016,723.1078,1087.9241},//12
	{527,1,3,1429.7720,718.8213,1087.9241},//13
	{535,1,3,1429.7936,714.4084,1087.9241},//14
	{507,1,3,1429.7799,709.7604,1087.9241},//15
	{505,1,3,1429.7854,705.0353,1087.9241},//16
	{526,1,3,1429.7755,699.8195,1087.9241},//17
	{533,1,3,1441.5001,712.2757,1087.9011},//18
	{500,1,3,1441.5013,725.3693,1087.9011},//19

	{496,1,4,1445.2085,705.7338,1087.9011},//1
	{475,1,4,1445.2091,710.9103,1087.9011},//1
	{445,1,4,1445.2209,716.5020,1087.9011},//3
	{426,1,4,1445.2075,721.8635,1087.9011},//4
	{421,1,4,1445.2218,727.5889,1087.9011},//5
	{405,1,4,1445.2330,733.3967,1087.9011},//6
	{400,1,4,1440.6002,735.0201,1087.9011},//7
	//////////////////////////////////////
	{602,2,5,1445.2085,705.7338,1087.9011},//1
	{587,2,5,1445.2091,710.9103,1087.9011},//1
	{559,2,5,1445.2209,716.5020,1087.9011},//3
	{560,2,5,1445.2075,721.8635,1087.9011},//4
	{562,2,5,1445.2218,727.5889,1087.9011},//5
	{541,2,5,1445.2330,733.3967,1087.9011},//6
	{506,2,5,1440.6002,735.0201,1087.9011},//7
	{480,2,5,1429.7894,740.1119,1087.9241},//8
	{434,2,5,1429.7721,735.5907,1087.9241},//9
	{477,2,5,1429.7736,731.3618,1087.9241},//10
	{415,2,5,1429.8004,726.9999,1087.9241},//11
	{429,2,5,1429.8016,723.1078,1087.9241},//12
	{402,2,5,1429.7720,718.8213,1087.9241},//13
	{451,2,5,1429.7936,714.4084,1087.9241},//14
	{411,2,5,1429.7799,709.7604,1087.9241},//15
	{495,2,5,1429.7854,705.0353,1087.9241},//15
	{494,2,5,1429.7755,699.8195,1087.9241},//15
	///////////////////////////////////////
	{481,3,6,1445.2085,705.7338,1087.9011},//1
	{509,3,6,1445.2091,710.9103,1087.9011},//1
	{510,3,6,1445.2209,716.5020,1087.9011},//3
	{462,3,6,1445.2075,721.8635,1087.9011},//4
	{461,3,6,1445.2218,727.5889,1087.9011},//5
	{521,3,6,1445.2330,733.3967,1087.9011},//6
	{463,3,6,1440.6002,735.0201,1087.9011},//7
	{586,3,6,1429.7894,740.1119,1087.9241},//8
	{471,3,6,1429.7721,735.5907,1087.9241},//9
	{468,3,6,1429.7736,731.3618,1087.9241},//10
	{522,3,6,1429.8004,726.9999,1087.9241}//11
};
new aSellCar[7],
	car_pickup[78];

new donate_car[22][2] = {
	{409,200},//0
	{424,400},//1
	{444,1000},//2
	{459,200},//3
	{470,600},//4
	{478,250},//5
	{482,180},//6
	{490,600},//7
	{502,1000},//8
	{503,1000},//9
	{504,1000},//10
	{528,600},//11
	{531,300},//12
	{539,1200},//13
	{556,1000},//14
	{557,1000},//15
	{568,800},//16
	{571,700},//17
	{573,900},//18
	{578,900},//19
	{599,600},//20
	{601,1200}//21
};

new Float:hotel_spawncar[34][4] = {
	//ЛВ
	{1900.8213, 1988.9442, 7.2995, 180.0000},
	{1897.3031, 1988.9442, 7.2995, 180.0000},
	{1893.6305, 1988.9442, 7.2995, 180.0000},
	{1890.0723, 1988.9442, 7.2995, 180.0000},
	{1886.3447, 1988.9442, 7.2995, 180.0000},
	{1882.7974, 1988.9442, 7.2995, 180.0000},
	{1879.2885, 1988.9442, 7.2995, 180.0000},
	{1875.6777, 1988.9442, 7.2995, 180.0000},
	{1871.9949, 1988.9442, 7.2995, 180.0000},
	{1868.5052, 1988.9442, 7.2995, 180.0000},
	//ЛС
	{279.2335, -1536.3569, 24.2992, 234.8225},
	{282.6563, -1532.0404, 24.2992, 234.8225},
	{286.0143, -1527.7018, 24.2992, 234.8225},
	{289.2401, -1523.2544, 24.2992, 234.8225},
	{292.5214, -1518.8168, 24.2992, 234.8225},
	{295.7639, -1514.4993, 24.2992, 234.8225},
	{298.8854, -1509.8937, 24.2992, 234.8225},
	{302.0367, -1505.2727, 24.2992, 234.8225},
	{304.5532, -1501.3510, 24.2992, 234.8225},
	//LV ROCK
	{2610.9695, 2279.4922, 10.5251, 90.0000},
	{2610.9695, 2275.3081, 10.5251, 90.0000},
	{2610.9695, 2271.1663, 10.5251, 90.0000},
	{2610.9695, 2266.9214, 10.5251, 90.0000},
	{2610.9695, 2262.7231, 10.5251, 90.0000},
	//СФ
	{-2493.8018, 284.6566, 34.8714, 162.6043},
	{-2490.5122, 283.7906, 34.8714, 162.6043},
	{-2487.1584, 282.7819, 34.8714, 162.6043},
	{-2484.0061, 281.8705, 34.8714, 162.6043},
	{-2480.6489, 280.8499, 34.8714, 162.6043},
	{-2477.3955, 279.9110, 34.8714, 162.6043},
	{-2474.2861, 278.9149, 34.8714, 162.6043},
	{-2470.8843, 278.0006, 34.8714, 162.6043},
	{-2467.7415, 276.9304, 34.8714, 162.6043},
	{-2464.1814, 275.9180, 34.8714, 162.6043}
};
new Float:hotel_spawnscar[60][4] = {
	{1639.2523, 681.8748, 589.2706, 270.0000},
	{1639.2523, 685.3676, 589.2634, 270.0000},
	{1639.2523, 689.1181, 589.2706, 270.0000},
	{1639.2523, 692.9104, 589.2707, 270.0000},
	{1639.2523, 696.7643, 589.2707, 270.0000},
	{1639.2523, 700.5690, 589.2707, 270.0000},
	{1639.2523, 704.2307, 589.2706, 270.0000},
	{1639.2523, 707.8220, 589.2714, 270.0000},
	{1639.2523, 711.6429, 589.2697, 270.0000},
	{1661.5199, 708.4477, 589.2723, 0.0000},
	{1665.6879, 708.4477, 589.2725, 0.0000},
	{1669.7159, 708.4477, 589.2707, 0.0000},
	{1690.4121, 708.4477, 589.2707, 0.0000},
	{1694.5243, 708.4477, 589.2725, 0.0000},
	{1698.7091, 708.4477, 589.2682, 0.0000},
	{1698.7136, 692.3749, 589.2707, 180.0000},
	{1694.6134, 692.3749, 589.2707, 180.0000},
	{1690.3038, 692.3749, 589.2707, 180.0000},
	{1686.2885, 692.3749, 589.2706, 180.0000},
	{1673.9747, 692.3749, 589.2707, 180.0000},
	{1669.7694, 692.3749, 589.2725, 180.0000},
	{1665.6481, 692.3749, 589.2722, 180.0000},
	{1661.4946, 692.3749, 589.2725, 180.0000},
	{1645.2010, 675.7460, 589.2640, 0.0000},
	{1649.1854, 675.7460, 589.2623, 0.0000},
	{1653.5624, 675.7460, 589.2503, 0.0000},
	{1657.5077, 675.7460, 589.2647, 0.0000},
	{1661.5767, 675.7460, 589.2480, 0.0000},
	{1665.5404, 675.7460, 589.2515, 0.0000},
	{1669.8055, 675.7460, 589.2491, 0.0000},
	{1673.8234, 675.7460, 589.2576, 0.0000},
	{1678.0140, 675.7460, 589.2639, 0.0000},
	{1682.2246, 675.7460, 589.2675, 0.0000},
	{1686.1377, 675.7460, 589.2593, 0.0000},
	{1690.4374, 675.7460, 589.2601, 0.0000},
	{1694.4039, 675.7460, 589.2617, 0.0000},
	{1698.6069, 675.7460, 589.2545, 0.0000},
	{1702.7660, 675.7460, 589.2673, 0.0000},
	{1706.8040, 675.7460, 589.2642, 0.0000},
	{1710.9709, 675.7460, 589.2601, 0.0000},
	{1715.1213, 675.7460, 589.2668, 0.0000},
	{1721.3688, 682.6960, 589.2549, 90.0000},
	{1721.3688, 688.2509, 589.2630, 90.0000},
	{1721.3688, 693.4296, 589.2612, 90.0000},
	{1721.3688, 698.6730, 589.2632, 90.0000},
	{1721.3688, 702.4772, 589.2640, 90.0000},
	{1723.1814, 724.6450, 589.2619, 180.0000},
	{1719.1642, 724.6450, 589.2607, 180.0000},
	{1714.9835, 724.6450, 589.2621, 180.0000},
	{1710.7709, 724.6450, 589.2488, 180.0000},
	{1706.9706, 724.6450, 589.2467, 180.0000},
	{1702.7843, 724.6450, 589.2603, 180.5041},
	{1698.5903, 724.6450, 589.2646, 180.0000},
	{1694.5520, 724.6450, 589.2487, 180.0000},
	{1690.4575, 724.6450, 589.2648, 180.0000},
	{1686.3148, 724.6450, 589.2678, 180.0000},
	{1682.1447, 724.6450, 589.2514, 180.0000},
	{1678.0258, 724.6450, 589.2576, 180.0000},
	{1673.8429, 724.6450, 589.2629, 180.0000},
	{1669.6791, 724.6450, 589.2625, 180.0000}
};

new Float:exitgarage[4][4] = {
	{1111.7349,-1772.8270,894.0478,181.6883},//N
	{1045.7454,-1781.7330,894.0495,180.3648},//D
	{1113.7714,-1858.3667,894.0478,269.9092},//B
	{1052.1896,-1852.6293,894.0478,147.5578}//A
};
new Float:cargarage[8][4] = {
	{1111.6594, -1785.9598, 893.7748, 37.4031},//N
	{1111.8777, -1778.5665, 893.7748, 140.4031},//N
	{1043.5570, -1783.2856, 893.7767, 270.0000},//D
	{1043.5570, -1787.0009, 893.7767, 270.0000},//D
	{1116.3336, -1853.8832, 893.7759, 310.0000},//B
	{1116.3298, -1862.6064, 893.7759, -135.0000},//B
	{1050.6737, -1862.6144, 893.8024, -230.0000},//A
	{1050.1293, -1856.7645, 893.8024, -230.0000}//A
};

enum TRANSPORT_DATA {
	trID,
	trModel,
	trName[35],
	trPrice,
	trTank,
	trConsumption,
	trClass,
	trFuelable,
	trSellable,
	trProds
}
new gTransport[220][TRANSPORT_DATA];

#define BUS_PRICE_CHECKPOINT 50
#define BUS_PRICE_RENT 500

new Text3D:gPlayerBusText[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID,...},
	gRouteName[7][32],
	gRoutePrice[MAX_PLAYERS] = 100;

new Float:gBusCPs[7][111][4] = {
	{
		{0.0,1214.2271,-1841.6237,13.4829}, // Автобус ЛС - Яблочный сад 1
		{0.0,1337.0187,-1858.6047,13.4910}, // Автобус ЛС - Яблочный сад 2
		{0.0,1556.0479,-1874.5721,13.4841}, // Автобус ЛС - Яблочный сад 3
		{0.0,1691.2279,-1830.6217,13.4858}, // Автобус ЛС - Яблочный сад 4
		{0.0,1801.5131,-1834.5245,13.4789}, // Автобус ЛС - Яблочный сад 5
		{0.0,1819.7594,-1875.0637,13.4980}, // Автобус ЛС - Яблочный сад 6
		{1.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 7 ОСТ
		{0.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 7
		{0.0,1804.4498,-1894.3840,13.5065}, // Автобус ЛС - Яблочный сад 8
		{0.0,1855.0417,-1935.1912,13.4802}, // Автобус ЛС - Яблочный сад 9
		{0.0,1961.7318,-1932.4554,13.3828}, // Автобус ЛС - Яблочный сад 10 1961.7318,-1932.4554,13.3828
		{0.0,1964.3901,-1864.1176,13.4833}, // Автобус ЛС - Яблочный сад 12
		{0.0,1964.5205,-1767.0066,13.4870}, // Автобус ЛС - Яблочный сад 13
		{0.0,1805.2716,-1729.8383,13.4948}, // Автобус ЛС - Яблочный сад 14
		{0.0,1544.3309,-1730.2870,13.4771}, // Автобус ЛС - Яблочный сад 15
		{1.0,1535.7860,-1674.1608,13.4879}, // Автобус ЛС - Яблочный сад 16 ОСТ
		{0.0,1535.7860,-1674.1608,13.4879}, // Автобус ЛС - Яблочный сад 17
		{0.0,1531.6091,-1611.0477,13.4792}, // Автобус ЛС - Яблочный сад 18
		{0.0,1328.5776,-1571.1885,13.4637}, // Автобус ЛС - Яблочный сад 19
		{0.0,1354.8143,-1425.8323,13.4881}, // Автобус ЛС - Яблочный сад 20
		{0.0,1281.6537,-1392.6047,13.3373}, // Автобус ЛС - Яблочный сад 21
		{0.0,1259.8846,-1300.3331,13.2508}, // Автобус ЛС - Яблочный сад 22
		{0.0,1212.6843,-1278.1226,13.4864}, // Автобус ЛС - Яблочный сад 23
		{1.0,1192.5950,-1357.1691,13.4869}, // Автобус ЛС - Яблочный сад 24 ОСТ
		{0.0,1192.5950,-1357.1691,13.4869}, // Автобус ЛС - Яблочный сад 25
		{0.0,1193.4930,-1380.9880,13.3259}, // Автобус ЛС - Яблочный сад
		{0.0,1192.7594,-1377.8389,13.4397}, // Автобус ЛС - Яблочный сад 26
		{0.0,901.3838,-1395.2395,13.3022}, // Автобус ЛС - Яблочный сад 27
		{1.0,735.4214,-1390.9387,13.6672}, // Автобус ЛС - Яблочный сад 28 ОСТ АВТОШКОЛА
		{0.0,735.4214,-1390.9387,13.6672}, // Автобус ЛС - Яблочный сад 28
		{0.0,545.0849,-1406.2698,15.6582}, // Автобус ЛС - Яблочный сад 29
		{1.0,342.6032,-1525.6768,33.4036}, // Автобус ЛС - Яблочный сад 30 ОСТ отель
		{0.0,342.6032,-1525.6768,33.4036}, // Автобус ЛС - Яблочный сад 30
		{0.0,322.9697,-1569.4362,33.1997}, // Автобус ЛС - Яблочный сад 31
		{0.0,260.9909,-1572.1434,33.0791}, // Автобус ЛС - Яблочный сад 32
		{0.0,281.2208,-1508.2583,32.5755}, // Автобус ЛС - Яблочный сад 33
		{0.0,157.5408,-1539.8556,11.2695}, // Автобус ЛС - Яблочный сад 34
		{0.0,53.4258,-1524.0197,5.1330}, // Автобус ЛС - Яблочный сад 35
		{0.0,-119.8915,-1187.7773,2.7961}, // Автобус ЛС - Яблочный сад 36
		{0.0,-113.7326,-995.2748,24.9790}, // Автобус ЛС - Яблочный сад 37
		{0.0,52.6536,-558.9227,9.2004}, // Автобус ЛС - Яблочный сад 38
		{0.0,-298.3496,-172.8055,1.1759}, // Автобус ЛС - Яблочный сад 39
		{0.0,-146.7536,-188.9806,1.9985}, // Автобус ЛС - Яблочный сад 40
		{0.0,-118.3879,-138.2790,3.2170}, // Автобус ЛС - Яблочный сад 41
		{1.0,-163.2506,-113.0578,3.2167}, // Автобус ЛС - Яблочный сад 42 ОСТ ЯБЛ
		{0.0,-163.2506,-113.0578,3.2167}, // Автобус ЛС - Яблочный сад 42
		{0.0,-288.9584,-78.0612,2.3629}, // Автобус ЛС - Яблочный сад 43
		{0.0,-312.8886,-132.4520,1.1855}, // Автбус ЛС - Яблочный сад 44
		{0.0,53.1651,-213.1240,1.5581}, // втобус ЛС - Яблочный сад 45
		{0.0,308.4373,-214.6019,1.5046}, // Автобус ЛС - Яблочный сад 46
		{0.0,335.2500,-160.6235,1.3314}, // Автобус ЛС - Яблочный сад 47
		{0.0,586.5766,-150.1363,32.9785}, // Автобус ЛС - Яблочный сад 48
		{0.0,812.3875,-170.6930,18.6473}, // Автобус ЛС - Яблочный сад 49
		{0.0,1163.3831,-174.9190,41.1304}, // Автобус ЛС - Яблочный сад 50
		{0.0,1256.2535,-435.2551,5.3327}, // Автобус ЛС - Яблочный сад 51
		{0.0,1172.4113,-695.1100,62.2461}, // Автобус ЛС - Яблочный сад 52
		{0.0,1156.0012,-921.0430,42.9780}, // Автобус ЛС - Яблочный сад 53
		{0.0,1341.7106,-940.4310,35.3839}, // Автобус ЛС - Яблочный сад 54
		{0.0,1340.8616,-1150.4279,23.7666}, // Автобус ЛС - Яблочный сад 55
		{0.0,1320.9132,-1493.5867,13.4783}, // Автобус ЛС - Яблочный сад 56
		{0.0,1294.9742,-1738.9154,13.4877}, // Автобус ЛС - Яблочный сад 57
		{0.0,1295.0835,-1833.2035,13.4806}, // Автобус ЛС - Яблочный сад 58
		{1.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{//оружейка
		{0.0,1214.2271,-1841.6237,13.4829}, // Автобус ЛС - Яблочный сад 1
		{0.0,1337.0187,-1858.6047,13.4910}, // Автобус ЛС - Яблочный сад 2
		{0.0,1556.0479,-1874.5721,13.4841}, // Автобус ЛС - Яблочный сад 3
		{0.0,1691.2279,-1830.6217,13.4858}, // Автобус ЛС - Яблочный сад 4
		{0.0,1801.5131,-1834.5245,13.4789}, // Автобус ЛС - Яблочный сад 5
		{0.0,1819.7594,-1875.0637,13.4980}, // Автобус ЛС - Яблочный сад 6
		{1.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 7 ОСТ
		{0.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 8
		{0.0,1804.4498,-1894.3840,13.5065}, // Автобус ЛС - Яблочный сад 9
		{0.0,1855.0417,-1935.1912,13.4802}, // Автобус ЛС - Яблочный сад 10
		{0.0,1961.7318,-1932.4554,13.3828}, // Автобус ЛС - Яблочный сад 11
		{0.0,1963.3302,-1942.5835,13.5776}, // Оружейка 1
		{0.0,1963.6166,-1765.9930,13.4837}, // Оружейка 2
		{0.0,1741.3721,-1729.4889,13.4913}, // Оружейка 3
		{0.0,1540.4053,-1730.5059,13.4791}, // Оружейка 4
		{1.0,1536.3052,-1673.5221,13.4833}, // Оружейка 5 остановка ЛСПД
		{0.0,1536.3052,-1673.5221,13.4833}, // Оружейка 5 остановка ЛСПД
		{0.0,1531.4255,-1602.0299,13.4795}, // Оружейка 6
		{0.0,1448.0746,-1590.0293,13.4835}, // Оружейка 7
		{0.0,1427.0520,-1718.3151,13.4776}, // Оружейка 8
		{0.0,1399.7667,-1731.2450,13.4879}, // Оружейка 9
		{0.0,1386.8468,-1858.1704,13.4841}, // Оружейка 10
		{0.0,1521.1714,-1875.1702,13.4859}, // Оружейка 11
		{0.0,1828.2681,-2167.7881,13.4836}, // Оружейка 12
		{0.0,1953.3475,-2168.1384,13.4809}, // Оружейка 13
		{0.0,1963.6655,-2124.0908,13.4773}, // Оружейка 14
		{0.0,2188.5161,-2158.4248,13.4849}, // Оружейка 15
		{0.0,2273.5181,-2092.4167,13.5962}, // Оружейка 16
		{0.0,2551.2319,-2351.6409,19.4098}, // Оружейка 17
		{1.0,2648.9653,-2410.4834,13.6335}, // Оружейка 18 Оружейный завод остановка
		{0.0,2648.9653,-2410.4834,13.6335}, // Оружейка 18 Оружейный завод остановка
		{0.0,2614.3113,-2401.7566,13.6075}, // Оружейка 19
		{0.0,2290.5583,-2086.0999,13.4534}, // Оружейка 20
		{0.0,2221.3511,-1903.6588,13.4772}, // Оружейка 21
		{0.0,2096.2139,-1891.4275,13.4691}, // Оружейка 22
		{0.0,2071.1812,-1929.7961,13.4589}, // Оружейка 23
		{0.0,1833.7593,-1929.3501,13.4755}, // Оружейка 24
		{0.0,1822.6019,-1743.0156,13.4838}, // Оружейка 25
		{1.0,1481.3580,-1725.4241,13.4710}, // Оружейка 26 Остановка мэрия
		{0.0,1481.3580,-1725.4241,13.4710}, // Оружейка 26 Остановка мэрия
		{0.0,1326.9724,-1729.1134,13.4685}, // Оружейка 27
		{0.0,1353.4050,-1408.6917,13.4451}, // Оружейка 28
		{0.0,1272.6542,-1398.1283,13.1364}, // Оружейка 29
		{0.0,1262.1517,-1288.5327,13.4005}, // Оружейка 30
		{0.0,1209.7455,-1277.6670,13.4763}, // Оружейка 31
		{1.0,1190.4352,-1336.4911,13.5762}, // Оружейка 32 остановка мчс
		{0.0,1190.4352,-1336.4911,13.5762}, // Оружейка 32 остановка мчс
		{0.0,1192.9000,-1544.1130,13.4843}, // Оружейка 33
		{0.0,1160.1768,-1571.0173,13.3792}, // Оружейка 34
		{0.0,1146.9352,-1698.9518,13.9472}, // Оружейка 35
		{0.0,1171.5535,-1730.2413,13.6339}, // Оружейка 36
		{0.0,1172.3817,-1836.5792,13.4998}, // Оружейка 37
		{0.0,1251.5541,-1854.7930,13.4835}, // Оружейка 38
		{1.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,1214.2271,-1841.6237,13.4829}, // Автобус ЛС - Яблочный сад 1
		{0.0,1337.0187,-1858.6047,13.4910}, // Автобус ЛС - Яблочный сад 2
		{0.0,1556.0479,-1874.5721,13.4841}, // Автобус ЛС - Яблочный сад 3
		{0.0,1691.2279,-1830.6217,13.4858}, // Автобус ЛС - Яблочный сад 4
		{0.0,1801.5131,-1834.5245,13.4789}, // Автобус ЛС - Яблочный сад 5
		{0.0,1819.7594,-1875.0637,13.4980}, // Автобус ЛС - Яблочный сад 6
		{1.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 7 ОСТ
		{0.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 8
		{0.0,1804.4498,-1894.3840,13.5065}, // Автобус ЛС - Яблочный сад 9
		{0.0,1855.0417,-1935.1912,13.4802}, // Автобус ЛС - Яблочный сад 10
		{0.0,1961.7318,-1932.4554,13.3828}, // Автобус ЛС - Яблочный сад 11
		{0.0,1963.0328,-1978.8793,13.4917}, // АвтобусЛС - Нефтезавод 1
		{0.0,1963.7924,-1766.7512,13.5188}, // АвтобусЛС - Нефтезавод 2
		{0.0,1843.8573,-1750.1359,13.4836}, // АвтобусЛС - Нефтезавод 3
		{0.0,1788.9052,-1730.1495,13.4833}, // АвтобусЛС - Нефтезавод 4
		{0.0,1541.3855,-1730.0957,13.4783}, // АвтобусЛС - Нефтезавод 5
		{1.0,1535.3049,-1674.4214,13.4848}, // АвтобусЛС - Нефтезавод 6 ОСТ ЛСПД
		{0.0,1535.3049,-1674.4214,13.4848}, // АвтобусЛС - Нефтезавод 6 ОСТ ЛСПД
		{0.0,1532.6956,-1608.1808,13.4816}, // АвтобусЛС - Нефтезавод 7
		{0.0,1439.6666,-1590.5693,13.4873}, // АвтобусЛС - Нефтезавод 8
		{0.0,1456.3632,-1453.6963,13.4584}, // АвтобусЛС - Нефтезавод 9
		{0.0,1430.9341,-1438.4152,13.4865}, // АвтобусЛС - Нефтезавод 10
		{0.0,1374.4532,-1395.8250,13.4969}, // АвтобусЛС - Нефтезавод 11
		{1.0,1210.4618,-1323.7418,13.5760}, // АвтобусЛС - Нефтезавод 12 Больница ЛС
		{0.0,1210.4618,-1323.7418,13.5760}, // АвтобусЛС - Нефтезавод 12 Больница ЛС
		{0.0,1205.2424,-1290.5332,13.4836}, // АвтобусЛС - Нефтезавод 13
		{0.0,1079.3782,-1278.3528,13.4934}, // АвтобусЛС - Нефтезавод 14
		{0.0,1056.1313,-1379.2722,13.5650}, // АвтобусЛС - Нефтезавод 15
		{1.0,742.2429,-1390.5920,13.6654}, // АвтобусЛС - Нефтезавод 16 Автошкола ЛС
		{0.0,742.2429,-1390.5920,13.6654}, // АвтобусЛС - Нефтезавод 16 Автошкола ЛС
		{0.0,649.5396,-1396.0400,13.5171}, // АвтобусЛС - Нефтезавод 17
		{0.0,628.0599,-1223.6124,18.1729}, // АвтобусЛС - Нефтезавод 18
		{0.0,554.3544,-1236.8094,17.1235}, // АвтобусЛС - Нефтезавод 19
		{0.0,299.5295,-1399.9049,13.9805}, // АвтобусЛС - Нефтезавод 20
		{0.0,158.4846,-1540.7407,11.3579}, // АвтобусЛС - Нефтезавод 21
		{0.0,105.5371,-1531.4368,6.4888}, // АвтобусЛС - Нефтезавод 22
		{0.0,165.2634,-1414.2917,44.5608}, // АвтобусЛС - Нефтезавод 23
		{0.0,145.1400,-1366.9550,50.0345}, // АвтобусЛС - Нефтезавод 24
		{0.0,188.5456,-1146.1903,60.2137}, // АвтобусЛС - Нефтезавод 25
		{0.0,286.5631,-958.2195,40.6255}, // АвтобусЛС - Нефтезавод 26
		{0.0,418.1149,-600.1732,35.5377}, // АвтобусЛС - Нефтезавод 27
		{0.0,469.4636,-418.1744,28.7455}, // АвтобусЛС - Нефтезавод 28
		{0.0,527.8354,-150.6377,37.9239}, // АвтобусЛС - Нефтезавод 29
		{0.0,516.0957,218.1131,14.1550}, // АвтобусЛС - Нефтезавод 30
		{0.0,607.9367,303.9923,19.6420}, // АвтобусЛС - Нефтезавод 31
		{0.0,553.1782,428.8676,19.0303}, // АвтобусЛС - Нефтезавод 32
		{0.0,318.8514,768.3904,12.3128}, // АвтобусЛС - Нефтезавод 33
		{0.0,193.5854,1079.4230,18.5035}, // АвтобусЛС - Нефтезавод 34
		{1.0,351.8507,1396.4845,7.0182}, // АвтобусЛС - Нефтезавод 35 ОСТ Нефтезавод
		{0.0,351.8507,1396.4845,7.0182}, // АвтобусЛС - Нефтезавод 35 ОСТ Нефтезавод
		{0.0,388.7699,1538.4469,13.7434}, // АвтобусЛС - Нефтезавод 37
		{0.0,657.1676,1839.8582,5.5735}, // АвтобусЛС - Нефтезавод 38
		{0.0,795.8563,1819.3867,4.5521}, // АвтобусЛС - Нефтезавод 39
		{0.0,829.8419,1539.0870,17.9067}, // АвтобусЛС - Нефтезавод 40
		{0.0,809.4116,1267.4512,25.8389}, // АвтобусЛС - Нефтезавод 41
		{0.0,672.6898,1096.5126,28.4358}, // АвтобусЛС - Нефтезавод 42
		{0.0,248.0561,982.5639,28.2891}, // АвтобусЛС - Нефтезавод 43
		{0.0,279.3735,843.4335,18.8742}, // АвтобусЛС - Нефтезавод 44
		{0.0,427.3322,598.7987,18.9978}, // АвтобусЛС - Нефтезавод 45
		{0.0,605.9601,345.6794,19.0318}, // АвтобусЛС - Нефтезавод 46
		{0.0,525.7582,250.0852,14.8112}, // АвтобусЛС - Нефтезавод 47
		{0.0,528.0024,-33.1806,30.1174}, // АвтобусЛС - Нефтезавод 48
		{0.0,523.5165,-124.1270,37.7924}, // АвтобусЛС - Нефтезавод 49
		{0.0,793.8564,-167.4526,18.6081}, // АвтобусЛС - Нефтезавод 50
		{0.0,1050.8088,-188.7111,32.9994}, // АвтобусЛС - Нефтезавод 51
		{0.0,1158.5375,-177.8556,41.3960}, // АвтобусЛС - Нефтезавод 52
		{0.0,1253.3308,-368.3256,2.8819}, // АвтобусЛС - Нефтезавод 53
		{0.0,1194.4186,-646.9192,59.7953}, // АвтобусЛС - Нефтезавод 54
		{0.0,1156.5133,-931.7866,43.1468}, // АвтобусЛС - Нефтезавод 55
		{0.0,1190.5186,-949.5859,42.7763}, // АвтобусЛС - Нефтезавод 56
		{0.0,1349.7976,-941.7606,34.6926}, // АвтобусЛС - Нефтезавод 57
		{0.0,1353.4818,-1040.0150,26.2441}, // АвтобусЛС - Нефтезавод 58
		{0.0,1343.6632,-1207.9521,17.3990}, // АвтобусЛС - Нефтезавод 59
		{0.0,1336.0908,-1460.1149,13.4853}, // АвтобусЛС - Нефтезавод 60
		{0.0,1298.3976,-1724.9344,13.4899}, // АвтобусЛС - Нефтезавод 61
		{0.0,1299.7802,-1830.5485,13.4906}, // АвтобусЛС - Нефтезавод 62
		{0.0,1278.4308,-1849.6223,13.4839}, // АвтобусЛС - Нефтезавод 63
		{1.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,1214.2271,-1841.6237,13.4829}, // Автобус ЛС - Яблочный сад 1
		{0.0,1337.0187,-1858.6047,13.4910}, // Автобус ЛС - Яблочный сад 2
		{0.0,1556.0479,-1874.5721,13.4841}, // Автобус ЛС - Яблочный сад 3
		{0.0,1691.2279,-1830.6217,13.4858}, // Автобус ЛС - Яблочный сад 4
		{0.0,1801.5131,-1834.5245,13.4789}, // Автобус ЛС - Яблочный сад 5
		{0.0,1819.7594,-1875.0637,13.4980}, // Автобус ЛС - Яблочный сад 6
		{1.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 7 ОСТ
		{0.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 8
		{0.0,1804.4498,-1894.3840,13.5065}, // Автобус ЛС - Яблочный сад 9
		{0.0,1855.0417,-1935.1912,13.4802}, // Автобус ЛС - Яблочный сад 10
		{0.0,1961.7318,-1932.4554,13.3828}, // Автобус ЛС - Яблочный сад 11
		{0.0,1964.1012,-1763.8149,13.4924}, // ЖДЛС - ЖДСФ 1
		{0.0,1841.7656,-1750.2228,13.4833}, // ЖДЛС - ЖДСФ 2
		{0.0,1790.8025,-1730.4607,13.4846}, // ЖДЛС - ЖДСФ 3
		{0.0,1548.8041,-1729.8701,13.4841}, // ЖДЛС - ЖДСФ 4
		{1.0,1535.3271,-1673.9270,13.4891}, // ЖДЛС - ЖДСФ 5 ОСТ ЛСПД
		{0.0,1535.3271,-1673.9270,13.4891}, // ЖДЛС - ЖДСФ 6 ОСТ ЛСПД
		{0.0,1532.5133,-1605.6156,13.5001}, // ЖДЛС - ЖДСФ 7
		{0.0,1445.8591,-1589.5212,13.4835}, // ЖДЛС - ЖДСФ 8
		{0.0,1327.0753,-1571.0421,13.4675}, // ЖДЛС - ЖДСФ 9
		{0.0,1354.9215,-1405.3069,13.4160}, // ЖДЛС - ЖДСФ 10
		{0.0,1280.8184,-1395.7087,13.2048}, // ЖДЛС - ЖДСФ 11
		{0.0,1260.5604,-1300.0964,13.2579}, // ЖДЛС - ЖДСФ 12
		{0.0,1225.2194,-1277.8857,13.5096}, // ЖДЛС - ЖДСФ 13
		{1.0,1189.4410,-1340.2562,13.5792}, // ЖДЛС - ЖДСФ 14 ОСТ БОЛЬНИЦА
		{0.0,1189.4410,-1340.2562,13.5792}, // ЖДЛС - ЖДСФ 14 ОСТ БОЛЬНИЦА
		{0.0,1195.2321,-1377.6731,13.4091}, // ЖДЛС - ЖДСФ 15
		{0.0,1142.4996,-1396.3303,13.6249}, // ЖДЛС - ЖДСФ 16
		{0.0,920.6032,-1397.2067,13.3422}, // ЖДЛС - ЖДСФ 17
		{1.0,741.4285,-1391.5300,13.5780}, // ЖДЛС - ЖДСФ 18 ОСТ АВТОШКОЛА
		{0.0,741.4285,-1391.5300,13.5780}, // ЖДЛС - ЖДСФ 18 ОСТ АВТОШКОЛА
		{0.0,650.0319,-1396.4429,13.5278}, // ЖДЛС - ЖДСФ 19
		{0.0,633.7971,-1260.5646,17.0576}, // ЖДЛС - ЖДСФ 20
		{0.0,627.3437,-1187.3578,18.8196}, // ЖДЛС - ЖДСФ 21
		{0.0,463.0310,-1113.4683,27.9686}, // ЖДЛС - ЖДСФ 22
		{0.0,4.6530,-1318.7405,11.5244}, // ЖДЛС - ЖДСФ 23
		{0.0,-320.5933,-1762.5314,16.3806}, // ЖДЛС - ЖДСФ 24
		{0.0,-320.5703,-2207.8826,28.5968}, // ЖДЛС - ЖДСФ 25
		{0.0,-43.7109,-2747.7300,41.4230}, // ЖДЛС - ЖДСФ 26
		{0.0,-279.0562,-2810.0627,53.3196}, // ЖДЛС - ЖДСФ 27
		{0.0,-782.1933,-2775.6616,74.1486}, // ЖДЛС - ЖДСФ 28
		{0.0,-1031.6819,-2850.2493,67.9472}, // ЖДЛС - ЖДСФ 29
		{0.0,-1562.5157,-2776.0818,47.9199}, // ЖДЛС - ЖДСФ 30
		{0.0,-1750.7065,-2589.7268,51.0123}, // ЖДЛС - ЖДСФ 31
		{0.0,-1948.2964,-2550.9741,38.9697}, // ЖДЛС - ЖДСФ 32
		{0.0,-2046.6895,-2486.2827,30.6258}, // ЖДЛС - ЖДСФ 33
		{0.0,-2174.7241,-2385.1775,30.5734}, // ЖДЛС - ЖДСФ 34
		{0.0,-2160.1440,-2325.6897,30.5686}, // ЖДЛС - ЖДСФ 35
		{0.0,-2259.2068,-2226.9380,30.1915}, // ЖДЛС - ЖДСФ 36
		{1.0,-2200.9778,-2179.0984,43.7746}, // ЖДЛС - ЖДСФ 37 ОСТ Города Чиллиад
		{0.0,-2200.9778,-2179.0984,43.7746}, // ЖДЛС - ЖДСФ 37 ОСТ Города Чиллиад
		{0.0,-2123.1187,-2107.8169,59.7788}, // ЖДЛС - ЖДСФ 38
		{0.0,-2032.3018,-1921.7090,50.3591}, // ЖДЛС - ЖДСФ 39
		{0.0,-1796.9850,-1707.7631,29.8124}, // ЖДЛС - ЖДСФ 40
		{0.0,-1558.4453,-1605.8856,37.7545}, // ЖДЛС - ЖДСФ 41
		{0.0,-1641.7303,-1502.5426,36.5871}, // ЖДЛС - ЖДСФ 42
		{0.0,-2136.3093,-1043.4182,31.4800}, // ЖДЛС - ЖДСФ 43
		{0.0,-2211.7026,-902.8359,47.8051}, // ЖДЛС - ЖДСФ 44
		{0.0,-2208.1526,-749.1548,63.3719}, // ЖДЛС - ЖДСФ 45
		{0.0,-2184.7329,-532.8647,48.2160}, // ЖДЛС - ЖДСФ 46
		{0.0,-2241.3594,-388.0588,50.9692}, // ЖДЛС - ЖДСФ 47
		{0.0,-2251.6299,-201.7406,35.3341}, // ЖДЛС - ЖДСФ 48
		{0.0,-2250.2859,155.8972,35.2729}, // ЖДЛС - ЖДСФ 49
		{0.0,-2290.1865,402.6272,35.1054}, // ЖДЛС - ЖДСФ 50
		{1.0,-2358.1506,484.3576,30.8095}, // ЖДЛС - ЖДСФ 51 ОСТ БАНК СФ
		{0.0,-2358.1506,484.3576,30.8095}, // ЖДЛС - ЖДСФ 51 ОСТ БАНК СФ
		{0.0,-2365.1399,493.5286,30.4416}, // ЖДЛС - ЖДСФ 52
		{0.0,-2295.8711,506.8802,34.9690}, // ЖДЛС - ЖДСФ 53
		{0.0,-2084.5737,501.9756,35.1164}, // ЖДЛС - ЖДСФ 54
		{0.0,-2025.5344,501.8260,35.1153}, // ЖДЛС - ЖДСФ 55
		{1.0,-2011.5411,470.9115,35.1920}, // ЖДЛС - ЖДСФ 56 ОСТ УНИВЕР
		{0.0,-2011.5411,470.9115,35.1920}, // ЖДЛС - ЖДСФ 56 ОСТ УНИВЕР
		{0.0,-2007.3442,285.0027,33.8154}, // ЖДЛС - ЖДСФ 57
		{0.0,-2008.4031,132.7381,27.63981}, // ЖДЛС - ЖДСФ 58
		{1.0,-1984.6376,154.8171,27.8089}, // ЖДЛС - ЖДСФ 59 ОСТ ЖДСФ
		{0.0,-1984.6376,154.8171,27.8089}, // ЖДЛС - ЖДСФ 59 ОСТ ЖДСФ
		{0.0,-1994.0704,181.9314,27.6403}, // ЖДЛС - ЖДСФ 60
		{0.0,-1998.6086,329.6880,35.1166}, // ЖДЛС - ЖДСФ 61ф
		{0.0,-1920.7955,339.3335,30.9872}, // ЖДЛС - ЖДСФ 62
		{0.0,-1867.2281,404.1663,17.1198}, // ЖДЛС - ЖДСФ 63
		{0.0,-1762.5792,319.6498,7.2834}, // ЖДЛС - ЖДСФ 64
		{0.0,-1808.4950,105.6276,15.0623}, // ЖДЛС - ЖДСФ 65
		{0.0,-1800.1647,-182.2119,12.3371}, // ЖДЛС - ЖДСФ 66
		{0.0,-1802.0424,-282.8228,23.2056}, // ЖДЛС - ЖДСФ 67
		{0.0,-1820.0985,-568.2142,16.4264}, // ЖДЛС - ЖДСФ 6
		{0.0,-1769.2061,-583.6187,16.4367}, // ЖДЛС - ЖДСФ 68
		{0.0,-1615.4719,-796.1270,47.2867}, // ЖДЛС - ЖДСФ 69
		{0.0,-1235.0642,-777.1043,64.4914}, // ЖДЛС - ЖДСФ 70
		{0.0,-1012.4896,-443.4344,36.3507}, // ЖДЛС - ЖДСФ 71
		{0.0,-879.2217,-462.5110,23.2752}, // ЖДЛС - ЖДСФ 72
		{1.0,-428.8405,-449.6632,17.5722}, // ЖДЛС - ЖДСФ 73 Рыбалка
		{0.0,-428.8405,-449.6632,17.5722}, // ЖДЛС - ЖДСФ 73 Рыбалка
		{0.0,-416.2287,-635.3752,11.8140}, // ЖДЛС - ЖДСФ 74
		{0.0,-356.5605,-764.6705,29.8075}, // ЖДЛС - ЖДСФ 75
		{0.0,-294.9551,-854.6519,46.2089}, // ЖДЛС - ЖДСФ 76
		{0.0,-127.4551,-984.8000,26.0111}, // ЖДЛС - ЖДСФ 77
		{0.0,-152.6284,-1302.5249,2.7958}, // ЖДЛС - ЖДСФ 78
		{0.0,32.7749,-1536.8119,5.5575}, // ЖДЛС - ЖДСФ 79
		{0.0,131.6335,-1567.7102,9.9812}, // ЖДЛС - ЖДСФ 80
		{0.0,351.1815,-1714.8959,6.7842}, // ЖДЛС - ЖДСФ 81
		{0.0,685.1577,-1759.8953,13.3447}, // ЖДЛС - ЖДСФ 82
		{0.0,1043.8145,-1844.4503,13.5171}, // ЖДЛС - ЖДСФ 83
		{0.0,1108.3501,-1854.9894,13.4824}, // ЖДЛС - ЖДСФ 84
		{0.0,1246.7698,-1855.2886,13.4840}, // ЖДЛС - ЖДСФ 85
		{1.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,1214.2271,-1841.6237,13.4829}, // Автобус ЛС - Яблочный сад 1
		{0.0,1337.0187,-1858.6047,13.4910}, // Автобус ЛС - Яблочный сад 2
		{0.0,1556.0479,-1874.5721,13.4841}, // Автобус ЛС - Яблочный сад 3
		{0.0,1691.2279,-1830.6217,13.4858}, // Автобус ЛС - Яблочный сад 4
		{0.0,1801.5131,-1834.5245,13.4789}, // Автобус ЛС - Яблочный сад 5
		{0.0,1819.7594,-1875.0637,13.4980}, // Автобус ЛС - Яблочный сад 6
		{1.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 7 ОСТ
		{0.0,1777.3118,-1917.5198,13.5080}, // Автобус ЛС - Яблочный сад 8
		{0.0,1804.4498,-1894.3840,13.5065}, // Автобус ЛС - Яблочный сад 9
		{0.0,1855.0417,-1935.1912,13.4802}, // Автобус ЛС - Яблочный сад 10
		{0.0,1961.7318,-1932.4554,13.3828}, // Автобус ЛС - Яблочный сад 11
		{0.0,1964.3895,-1986.8088,13.4881}, // ЖДЛС - ЖДЛВ
		{0.0,1964.2737,-1779.0786,13.4838}, // ЖДЛС - ЖДЛВ
		{0.0,1841.3989,-1749.0479,13.4838}, // ЖДЛС - ЖДЛВ
		{0.0,1768.5527,-1729.8423,13.4840}, // ЖДЛС - ЖДЛВ
		{0.0,1571.9257,-1729.1656,13.4838}, // ЖДЛС - ЖДЛВ
		{1.0,1535.6764,-1674.0948,13.4848}, // ЖДЛС - ЖДЛВ ОСТ ЛСПД
		{0.0,1535.6764,-1674.0948,13.4848}, // ЖДЛС - ЖДЛВ ОСТ ЛСПД
		{0.0,1532.4268,-1607.3379,13.4823}, // ЖДЛС - ЖДЛВ
		{0.0,1419.6753,-1590.2869,13.4705}, // ЖДЛС - ЖДЛВ
		{0.0,1325.3134,-1571.1428,13.4636}, // ЖДЛС - ЖДЛВ
		{0.0,1355.1908,-1425.0554,13.4918}, // ЖДЛС - ЖДЛВ
		{0.0,1307.0311,-1398.9163,13.3520}, // ЖДЛС - ЖДЛВ
		{0.0,1231.1937,-1397.5558,13.2136}, // ЖДЛС - ЖДЛВ
		{1.0,1211.2694,-1335.3163,13.5800}, // ЖДЛС - ЖДЛВ ОСТ Больница ЛС
		{0.0,1211.2694,-1335.3163,13.5800}, // ЖДЛС - ЖДЛВ ОСТ Больница ЛС
		{0.0,1218.1603,-1167.0958,23.0242}, // ЖДЛС - ЖДЛВ
		{0.0,1312.0769,-1147.6741,23.7577}, // ЖДЛС - ЖДЛВ
		{0.0,1375.0165,-965.0331,33.8391}, // ЖДЛС - ЖДЛВ
		{0.0,1451.0409,-960.9687,36.1465}, // ЖДЛС - ЖДЛВ
		{0.0,1541.9932,-993.3146,43.2385}, // ЖДЛС - ЖДЛВ
		{0.0,1714.9706,-863.3711,58.4345}, // ЖДЛС - ЖДЛВ
		{0.0,1717.2285,-552.4230,35.8195}, // ЖДЛС - ЖДЛВ
		{0.0,1678.0281,-243.9397,42.9094}, // ЖДЛС - ЖДЛВ
		{0.0,1639.5632,-5.3570,36.7284}, // ЖДЛС - ЖДЛВ
		{0.0,1681.5200,341.1547,30.2688}, // ЖДЛС - ЖДЛВ
		{0.0,1773.4552,609.8650,21.7300}, // ЖДЛС - ЖДЛВ
		{0.0,1808.3149,824.0667,10.8020}, // ЖДЛС - ЖДЛВ
		{0.0,2047.3458,840.9211,6.8250}, // ЖДЛС - ЖДЛВ
		{0.0,2068.7295,1136.6163,10.7852}, // ЖДЛС - ЖДЛВ
		{1.0,2076.8447,1395.0903,10.8394}, // ЖДЛС - ЖДЛВ ОСТ автосалон ЛВ
		{0.0,2076.8447,1395.0903,10.8394}, // ЖДЛС - ЖДЛВ ОСТ автосалон ЛВ
		{0.0,2150.0464,1880.3892,10.7784}, // ЖДЛС - ЖДЛВ
		{0.0,2150.0901,2106.5635,10.7764}, // ЖДЛС - ЖДЛВ
		{1.0,2190.6689,2132.9546,10.7711}, // ЖДЛС - ЖДЛВ ОСТ Казино
		{0.0,2190.6689,2132.9546,10.7711}, // ЖДЛС - ЖДЛВ ОСТ Казино
		{0.0,2339.8977,2134.8503,10.7833}, // ЖДЛС - ЖДЛВ
		{0.0,2494.4424,2134.8115,10.7727}, // ЖДЛС - ЖДЛВ
		{0.0,2614.4578,2111.2222,10.7726}, // ЖДЛС - ЖДЛВ
		{0.0,2698.8152,1980.1976,6.8446}, // ЖДЛС - ЖДЛВ
		{0.0,2706.7600,1654.6088,6.8352}, // ЖДЛС - ЖДЛВ
		{0.0,2637.7083,1490.6335,10.7568}, // ЖДЛС - ЖДЛВ
		{0.0,2731.0884,1472.1692,13.6653}, // ЖДЛС - ЖДЛВ
		{0.0,2808.8750,1471.8922,10.8651}, // ЖДЛС - ЖДЛВ
		{0.0,2825.0698,1370.6274,10.8506}, // ЖДЛС - ЖДЛВ
		{0.0,2812.2595,1306.3754,10.8515}, // ЖДЛС - ЖДЛВ
		{1.0,2838.8772,1278.6033,10.9514}, // ЖДЛС - ЖДЛВ ОСТ ЖДЛВ
		{0.0,2838.8772,1278.6033,10.9514}, // ЖДЛС - ЖДЛВ ОСТ ЖДЛВ
		{0.0,2829.7717,1364.4343,10.8502}, // ЖДЛС - ЖДЛВ
		{0.0,2738.9294,1593.7034,6.8228}, // ЖДЛС - ЖДЛВ
		{0.0,2721.9519,1612.3257,6.8247}, // ЖДЛС - ЖДЛВ
		{0.0,2704.9534,1566.8306,6.8366}, // ЖДЛС - ЖДЛВ
		{0.0,2691.4341,1032.9639,6.8414}, // ЖДЛС - ЖДЛВ
		{0.0,2452.2925,852.0750,6.8385}, // ЖДЛС - ЖДЛВ
		{0.0,2263.2485,855.4351,6.8354}, // ЖДЛС - ЖДЛВ
		{0.0,2008.8618,853.6462,6.8357}, // ЖДЛС - ЖДЛВ
		{0.0,1817.3739,851.6034,10.7433}, // ЖДЛС - ЖДЛВ
		{0.0,1785.2819,815.5065,10.9304}, // ЖДЛС - ЖДЛВ
		{0.0,1726.0603,515.6217,28.6511}, // ЖДЛС - ЖДЛВ
		{0.0,1620.2179,168.5696,34.6889}, // ЖДЛС - ЖДЛВ
		{0.0,1661.9821,-242.1901,38.3402}, // ЖДЛС - ЖДЛВ
		{0.0,1687.5999,-740.8577,51.1203}, // ЖДЛС - ЖДЛВ
		{0.0,1482.0156,-937.6389,36.5790}, // ЖДЛС - ЖДЛВ
		{0.0,1383.4220,-938.9413,34.2691}, // ЖДЛС - ЖДЛВ
		{0.0,1352.5049,-1013.6958,26.7127}, // ЖДЛС - ЖДЛВ
		{0.0,1345.9933,-1129.7567,23.7602}, // ЖДЛС - ЖДЛВ
		{0.0,1343.7898,-1314.3254,13.4755}, // ЖДЛС - ЖДЛВ
		{0.0,1321.3065,-1495.8490,13.4834}, // ЖДЛС - ЖДЛВ
		{0.0,1295.1565,-1713.8878,13.4843}, // ЖДЛС - ЖДЛВ
		{0.0,1295.1361,-1817.7592,13.4837}, // ЖДЛС - ЖДЛВ
		{0.0,1277.6897,-1848.3373,13.4848}, // ЖДЛС - ЖДЛВ
		{1.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,1228.7788,-1827.2336,13.5090}, // Автобус ЛС - Яблочный сад 59 ОСТ конечная
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,2811.6599,1264.9022,10.8839}, // ЖДЛВ - ЖДЛС
		{1.0,2839.3447,1293.5128,10.9767}, // ЖДЛВ - ЖДЛС ОСТ ЖДЛВ
		{0.0,2839.3447,1293.5128,10.9767}, // ЖДЛВ - ЖДЛС ОСТ ЖДЛВ
		{0.0,2830.0520,1382.6539,10.8852}, // ЖДЛВ - ЖДЛС
		{0.0,2800.3811,1488.0938,10.7947}, // ЖДЛВ - ЖДЛС
		{0.0,2730.8894,1769.9720,6.8679}, // ЖДЛВ - ЖДЛС
		{0.0,2764.8594,2030.2826,8.4789}, // ЖДЛВ - ЖДЛС
		{0.0,2798.1301,2097.5002,10.7904}, // ЖДЛВ - ЖДЛС
		{0.0,2677.1587,2115.5266,12.1905}, // ЖДЛВ - ЖДЛС
		{0.0,2542.9248,2115.5112,10.8049}, // ЖДЛВ - ЖДЛС
		{0.0,2507.1006,2148.8538,10.8056}, // ЖДЛВ - ЖДЛС
		{0.0,2354.8066,2151.6348,10.8948}, // ЖДЛВ - ЖДЛС
		{1.0,2189.1946,2153.8804,10.8769}, // ЖДЛВ - ЖДЛС ОСТ КАЗИНО ЛВ
		{0.0,2189.1946,2153.8804,10.8769}, // ЖДЛВ - ЖДЛС ОСТ КАЗИНО ЛВ
		{0.0,2138.1609,2151.6978,10.8052}, // ЖДЛВ - ЖДЛС
		{1.0,2117.9849,1937.6003,10.8765}, // ЖДЛВ - ЖДЛС ОСТ Отель ЛВ
		{0.0,2117.9849,1937.6003,10.8765}, // ЖДЛВ - ЖДЛС ОСТ Отель ЛВ
		{0.0,2105.0200,1822.4395,10.8057}, // ЖДЛВ - ЖДЛС
		{0.0,2055.6917,1725.1305,10.8069}, // ЖДЛВ - ЖДЛС
		{0.0,1888.5416,1715.0933,10.8304}, // ЖДЛВ - ЖДЛС
		{0.0,1669.4302,1715.7327,10.8039}, // ЖДЛВ - ЖДЛС
		{1.0,1652.5247,1828.5485,10.9016}, // ЖДЛВ - ЖДЛС ОСТ Больница ЛВ
		{0.0,1652.5247,1828.5485,10.9016}, // ЖДЛВ - ЖДЛС ОСТ Больница ЛВ
		{0.0,1649.5107,1858.9519,10.7941}, // ЖДЛВ - ЖДЛС
		{0.0,1586.0669,1875.8157,10.8031}, // ЖДЛВ - ЖДЛС
		{0.0,1565.1235,1829.7086,10.8970}, // ЖДЛВ - ЖДЛС
		{0.0,1605.4042,1710.9758,10.8080}, // ЖДЛВ - ЖДЛС
		{0.0,1698.8910,1710.9238,10.8060}, // ЖДЛВ - ЖДЛС
		{0.0,1783.7328,1554.8937,6.8780}, // ЖДЛВ - ЖДЛС
		{0.0,1784.9916,1213.9532,6.8763}, // ЖДЛВ - ЖДЛС
		{0.0,1784.5745,926.7280,8.7216}, // ЖДЛВ - ЖДЛС
		{0.0,1785.0264,814.5547,10.9753}, // ЖДЛВ - ЖДЛС
		{0.0,1764.0336,650.4240,19.0520}, // ЖДЛВ - ЖДЛС
		{0.0,1664.1935,341.3025,30.3802}, // ЖДЛВ - ЖДЛС
		{0.0,1658.0754,-264.2254,38.8548}, // ЖДЛВ - ЖДЛС
		{0.0,1698.9503,-538.2750,35.2457}, // ЖДЛВ - ЖДЛС
		{0.0,1676.9587,-774.2608,54.1092}, // ЖДЛВ - ЖДЛС
		{0.0,1380.7175,-938.5894,34.3202}, // ЖДЛВ - ЖДЛС
		{0.0,1354.0558,-1021.8506,26.6601}, // ЖДЛВ - ЖДЛС
		{0.0,1474.8035,-1036.4746,23.7860}, // ЖДЛВ - ЖДЛС
		{0.0,1574.8267,-1139.8116,23.7458}, // ЖДЛВ - ЖДЛС
		{0.0,1693.6605,-1163.3075,23.7857}, // ЖДЛВ - ЖДЛС
		{1.0,1709.3661,-1339.0776,13.5966}, // ЖДЛВ - ЖДЛС ОСТ Центр занятости
		{0.0,1709.3661,-1339.0776,13.5966}, // ЖДЛВ - ЖДЛС ОСТ Центр занятости
		{0.0,1712.4839,-1428.4733,13.5162}, // ЖДЛВ - ЖДЛС
		{0.0,1471.2365,-1438.9060,13.5161}, // ЖДЛВ - ЖДЛС
		{0.0,1427.1078,-1603.3900,13.5158}, // ЖДЛВ - ЖДЛС
		{0.0,1426.9940,-1705.4247,13.5158}, // ЖДЛВ - ЖДЛС
		{1.0,1493.9652,-1738.9160,13.6800}, // ЖДЛВ - ЖДЛС ОСТ Мэрия
		{0.0,1493.9652,-1738.9160,13.6800}, // ЖДЛВ - ЖДЛС ОСТ Мэрия
		{0.0,1551.0874,-1735.2466,13.5147}, // ЖДЛВ - ЖДЛС
		{0.0,1567.7570,-1846.1224,13.5416}, // ЖДЛВ - ЖДЛС
		{0.0,1436.4189,-1870.3555,13.5197}, // ЖДЛВ - ЖДЛС
		{0.0,1292.2882,-1849.4534,13.5161},// ЖДЛВ - ЖДЛС
		{1.0,1228.2168,-1826.2201,13.6270}, // ЖДЛВ - ЖДЛС ОСТ ЖДЛС
		{0.0,1228.2168,-1826.2201,13.6270}, // ЖДЛВ - ЖДЛС ОСТ ЖДЛС
		{0.0,1216.1584,-1838.8870,13.5187}, // ЖДЛВ - ЖДЛС
		{0.0,1296.9298,-1854.9777,13.5168}, // ЖДЛВ - ЖДЛС
		{0.0,1311.9849,-1659.5074,13.5162}, // ЖДЛВ - ЖДЛС
		{0.0,1358.6890,-1300.9633,13.4257}, // ЖДЛВ - ЖДЛС
		{0.0,1376.9252,-964.4139,33.8415}, // ЖДЛВ - ЖДЛС
		{0.0,1477.3091,-969.6825,36.6038}, // ЖДЛВ - ЖДЛС
		{0.0,1703.4259,-909.2404,53.5434}, // ЖДЛВ - ЖДЛС
		{0.0,1714.0291,-641.4417,41.4720}, // ЖДЛВ - ЖДЛС
		{0.0,1682.7441,-331.3966,45.1686}, // ЖДЛВ - ЖДЛС
		{0.0,1624.7516,122.8967,36.8080}, // ЖДЛВ - ЖДЛС
		{0.0,1730.0817,475.3436,30.2632}, // ЖДЛВ - ЖДЛС
		{0.0,1807.5977,801.7347,11.2282}, // ЖДЛВ - ЖДЛС
		{0.0,2037.1251,833.1800,6.8596}, // ЖДЛВ - ЖДЛС
		{0.0,2446.5486,832.4109,6.8679}, // ЖДЛВ - ЖДЛС
		{0.0,2697.4641,990.9603,6.8673}, // ЖДЛВ - ЖДЛС
		{0.0,2728.5237,1295.2372,6.8678}, // ЖДЛВ - ЖДЛС
		{0.0,2797.4832,1455.0337,10.7988}, // ЖДЛВ - ЖДЛС
		{0.0,2825.5657,1371.6364,10.8826}, // ЖДЛВ - ЖДЛС
		{0.0,2819.3682,1267.0796,10.8893}, // ЖДЛВ - ЖДЛС
		{1.0,2840.2212,1276.3347,10.9786}, // ЖДЛВ - ЖДЛС ОСТ ЖДЛВ
		{0.0,2840.2212,1276.3347,10.9786}, // ЖДЛВ - ЖДЛС ОСТ ЖДЛВ
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},
	{
		{0.0,-1990.0763,193.2773,27.7563}, // ЖДСФ - ЖДЛС
		{0.0,-2009.9574,142.6636,27.6721}, // ЖДСФ - ЖДЛС
		{1.0,-1984.6704,146.6337,27.8411}, // ЖДСФ - ЖДЛС ОСТ ЖДСФ
		{0.0,-1984.6704,146.6337,27.8411}, // ЖДСФ - ЖДЛС ОСТ ЖДСФ
		{0.0,-2003.1953,229.4114,28.3929}, // ЖДСФ - ЖДЛС
		{0.0,-2001.5217,426.2427,35.1485}, // ЖДСФ - ЖДЛС
		{1.0,-2024.8417,508.7587,35.2226}, // ЖДСФ - ЖДЛС ОСТ Универ
		{0.0,-2024.8417,508.7587,35.2226}, // ЖДСФ - ЖДЛС ОСТ Универ
		{0.0,-2105.2141,506.6866,35.1489}, // ЖДСФ - ЖДЛС
		{0.0,-2268.7148,510.0154,35.1490}, // ЖДСФ - ЖДЛС
		{1.0,-2351.0842,513.4455,29.2837}, // ЖДСФ - ЖДЛС ОСТ БАнк СФ
		{0.0,-2351.0842,513.4455,29.2837}, // ЖДСФ - ЖДЛС ОСТ БАнк СФ
		{0.0,-2353.0430,466.1475,31.4117}, // ЖДСФ - ЖДЛС
		{0.0,-2321.3728,429.8806,34.9647}, // ЖДСФ - ЖДЛС
		{0.0,-2368.7786,362.2540,35.1489}, // ЖДСФ - ЖДЛС
		{1.0,-2402.1843,326.4380,35.3161}, // ЖДСФ - ЖДЛС Ост Отель СФ
		{0.0,-2402.1843,326.4380,35.3161}, // ЖДСФ - ЖДЛС Ост Отель СФ
		{0.0,-2423.1782,-46.7613,35.3056}, // ЖДСФ - ЖДЛС
		{0.0,-2386.2158,-71.6138,35.2968}, // ЖДСФ - ЖДЛС
		{0.0,-2284.5950,-192.5336,35.3054}, // ЖДСФ - ЖДЛС
		{0.0,-2183.4895,-472.7820,47.9329}, // ЖДСФ - ЖДЛС
		{0.0,-1905.9290,-583.3749,24.5796}, // ЖДСФ - ЖДЛС
		{0.0,-1781.9854,-584.0237,16.4509}, // ЖДСФ - ЖДЛС
		{0.0,-1701.2969,-757.5758,39.2007}, // ЖДСФ - ЖДЛС
		{0.0,-1451.9558,-823.6375,74.4962}, // ЖДСФ - ЖДЛС
		{0.0,-1229.0071,-771.9417,64.0624}, // ЖДСФ - ЖДЛС
		{0.0,-1157.0313,-612.7076,38.2038}, // ЖДСФ - ЖДЛС
		{0.0,-969.8114,-445.1295,34.8067}, // ЖДСФ - ЖДЛС
		{0.0,-709.3467,-425.5027,16.7009}, // ЖДСФ - ЖДЛС
		{1.0,-440.0122,-437.6913,16.7004}, // ЖДСФ - ЖДЛС ОСТ Рыбалка
		{0.0,-440.0122,-437.6913,16.7004}, // ЖДСФ - ЖДЛС ОСТ Рыбалка
		{0.0,-413.7339,-645.8948,12.8715}, // ЖДСФ - ЖДЛС
		{0.0,-357.1746,-770.1766,30.0917}, // ЖДСФ - ЖДЛС
		{0.0,-317.8934,-794.7083,33.8689}, // ЖДСФ - ЖДЛС
		{0.0,-296.1505,-856.9515,46.3829}, // ЖДСФ - ЖДЛС
		{0.0,-147.7730,-970.1813,27.6242}, // ЖДСФ - ЖДЛС
		{0.0,-69.3727,-884.8249,15.4131}, // ЖДСФ - ЖДЛС
		{0.0,49.1451,-598.0204,4.7461}, // ЖДСФ - ЖДЛС
		{0.0,-94.9533,-414.4091,1.2135}, // ЖДСФ - ЖДЛС
		{0.0,-301.2192,-163.6344,1.2109}, // ЖДСФ - ЖДЛС
		{0.0,-214.9978,-174.7631,2.2938}, // ЖДСФ - ЖДЛС
		{0.0,-150.1478,-188.9800,2.0520}, // ЖДСФ - ЖДЛС
		{0.0,-119.1314,-137.9158,3.2545}, // ЖДСФ - ЖДЛС
		{1.0,-158.1488,-113.0416,3.2489}, // ЖДСФ - ЖДЛС ОСТ Яблочный сад
		{0.0,-158.1488,-113.0416,3.2489}, // ЖДСФ - ЖДЛС ОСТ Яблочный сад
		{0.0,-271.4798,-93.4918,3.0950}, // ЖДСФ - ЖДЛС
		{0.0,-314.8729,-128.6022,1.2111}, // ЖДСФ - ЖДЛС
		{0.0,20.8937,-210.1649,1.6201}, // ЖДСФ - ЖДЛС
		{0.0,284.9167,-215.0063,1.5629}, // ЖДСФ - ЖДЛС
		{0.0,334.9539,-164.5363,1.3148}, // ЖДСФ - ЖДЛС
		{0.0,543.6616,-146.0867,37.3337}, // ЖДСФ - ЖДЛС
		{0.0,904.6948,-177.7319,11.1655}, // ЖДСФ - ЖДЛС
		{0.0,1158.7584,-177.0398,41.3979}, // ЖДСФ - ЖДЛС
		{0.0,1237.9901,-308.5961,10.4510}, // ЖДСФ - ЖДЛС
		{0.0,1232.3737,-544.3182,37.8160}, // ЖДСФ - ЖДЛС
		{0.0,1156.4321,-923.8820,43.0874}, // ЖДСФ - ЖДЛС
		{0.0,973.0387,-963.6682,39.5489}, // ЖДСФ - ЖДЛС
		{0.0,960.1107,-1114.3121,23.8347}, // ЖДСФ - ЖДЛС
		{0.0,940.6979,-1294.4608,14.2958}, // ЖДСФ - ЖДЛС
		{0.0,737.5104,-1318.1848,13.5246}, // ЖДСФ - ЖДЛС
		{0.0,660.8900,-1317.1246,13.5552}, // ЖДСФ - ЖДЛС
		{0.0,629.4893,-1374.7257,13.6372}, // ЖДСФ - ЖДЛС
		{1.0,733.4760,-1412.3254,13.6597}, // ЖДСФ - ЖДЛС ОСТ Автошкола
		{0.0,733.4760,-1412.3254,13.6597}, // ЖДСФ - ЖДЛС ОСТ Автошкола
		{0.0,968.2913,-1403.1016,13.2832}, // ЖДСФ - ЖДЛС
		{0.0,1363.2635,-1403.7415,13.5083}, // ЖДСФ - ЖДЛС
		{0.0,1445.7882,-1444.0598,13.5252}, // ЖДСФ - ЖДЛС
		{0.0,1427.6233,-1573.8146,13.4912}, // ЖДСФ - ЖДЛС
		{0.0,1516.8811,-1594.5140,13.5150}, // ЖДСФ - ЖДЛС
		{0.0,1527.7831,-1701.5503,13.5166}, // ЖДСФ - ЖДЛС
		{1.0,1495.9943,-1726.6743,13.5070}, // ЖДСФ - ЖДЛС ОСТ Мэрия
		{0.0,1495.9943,-1726.6743,13.5070}, // ЖДСФ - ЖДЛС ОСТ Мэрия ЛС
		{0.0,1415.5389,-1729.8356,13.5190}, // ЖДСФ - ЖДЛС
		{0.0,1387.0298,-1854.5844,13.5189}, // ЖДСФ - ЖДЛС
		{0.0,1284.4939,-1849.5759,13.5204}, // ЖДСФ - ЖДЛС
		{1.0,1229.3988,-1826.2620,13.6493}, // ЖДСФ - ЖДЛС ОСТ ЖДЛС
		{0.0,1229.3988,-1826.2620,13.6493}, // ЖДСФ - ЖДЛС ОСТ ЖДЛС
		{0.0,1214.6980,-1839.8639,13.5158}, // ЖДСФ - ЖДЛС
		{0.0,1080.9991,-1850.6726,13.5231}, // ЖДСФ - ЖДЛС
		{0.0,993.9035,-1789.8778,14.1936}, // ЖДСФ - ЖДЛС
		{0.0,437.2980,-1706.3000,10.2182}, // ЖДСФ - ЖДЛС
		{0.0,170.3689,-1582.6938,13.1495}, // ЖДСФ - ЖДЛС
		{0.0,59.0949,-1524.6427,5.1106}, // ЖДСФ - ЖДЛС
		{0.0,-148.8886,-1379.9684,2.8304}, // ЖДСФ - ЖДЛС
		{0.0,-87.2297,-1113.2678,1.6921}, // ЖДСФ - ЖДЛС
		{0.0,-194.1466,-929.8817,35.8891}, // ЖДСФ - ЖДЛС
		{0.0,-382.6331,-833.9890,47.0683}, // ЖДСФ - ЖДЛС
		{0.0,-569.3133,-939.5194,59.9852}, // ЖДСФ - ЖДЛС
		{0.0,-747.7856,-1002.4215,76.8045}, // ЖДСФ - ЖДЛС
		{0.0,-882.9417,-1102.5907,98.1532}, // ЖДСФ - ЖДЛС
		{0.0,-991.7566,-1009.1080,94.5069}, // ЖДСФ - ЖДЛС
		{0.0,-1201.5936,-794.0877,64.7511}, // ЖДСФ - ЖДЛС
		{0.0,-1438.6663,-817.7955,77.6791}, // ЖДСФ - ЖДЛС
		{0.0,-1680.7272,-760.0618,41.1703}, // ЖДСФ - ЖДЛС
		{0.0,-1759.1168,-600.2720,16.3815}, // ЖДСФ - ЖДЛС
		{0.0,-1804.0962,-574.5425,16.3300}, // ЖДСФ - ЖДЛС
		{0.0,-1956.4969,-574.8124,24.5895}, // ЖДСФ - ЖДЛС
		{0.0,-2170.7822,-474.0224,46.2689}, // ЖДСФ - ЖДЛС
		{0.0,-2254.0413,-240.7402,37.9920}, // ЖДСФ - ЖДЛС
		{0.0,-2253.0745,-108.7386,35.3116}, // ЖДСФ - ЖДЛС
		{0.0,-2162.0483,-72.3071,35.3085}, // ЖДСФ - ЖДЛС
		{0.0,-2027.5092,-72.6452,35.3058}, // ЖДСФ - ЖДЛС
		{0.0,-2003.8905,22.9682,32.9707}, // ЖДСФ - ЖДЛС
		{1.0,-1984.5515,146.5591,27.8430}, // ЖДСФ - ЖДЛС ОСТ ЖДСФ
		{0.0,-1984.5515,146.5591,27.8430}, // ЖДСФ - ЖДЛС ОСТ ЖДСФ
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	}
};

#define SP_TYPE_NONE 0
#define SP_TYPE_PLAYER 1
#define SP_TYPE_VEHICLE 2

new Menu:specmenu;

new gAdmin[MAX_PLAYERS][9],
	gAdminTime[MAX_PLAYERS];
new gDaysOfWeek[][10] = {
	"thursday",
	"friday",
	"saturday",
	"sunday",
	"monday",
	"tuesday",
	"wednesday"
};
#define ADMIN_KICK 0
#define ADMIN_BAN 1
#define ADMIN_MUTE 2
#define ADMIN_PM 3
#define ADMIN_WARN 4
#define ADMIN_JAIL 5

#define LOG_MUTE 0
#define LOG_KICK 1
#define LOG_WARN 2
#define LOG_BAN 3
#define LOG_JAIL 4
#define LOG_CHANGENAME 5
#define LOG_UNBAN 6
#define LOG_BANIP 7
#define LOG_UNBANIP 8
#define LOG_SKICK 9
#define LOG_SBAN 10
#define LOG_UNMUTE 11
#define LOG_UNJAIL 12
#define LOG_UVAL 12
#define LOG_DELACC 13
#define LOG_GUN 14

#define LOGS_INVITE 0
#define LOGS_UNINVITE 1
#define LOGS_RANK 2
#define LOGS_LEAVE 3
#define LOGS_FWARN 4
#define LOGS_FUNWARN 5

#define MAX_VOTES 7
new vote_name[MAX_VOTES][MAX_PLAYER_NAME + 1];
new vote_count[MAX_VOTES]={0,...};

enum sInfo {
	bankID,
	bankNumber,
	bankBalance,
	bankPassword,
	bankOwner[MAX_PLAYER_NAME],
	bankTowner[MAX_PLAYER_NAME]
};
new gBanks[MAX_PLAYERS][sInfo][3],
	score_number[MAX_PLAYERS],
	score_name[MAX_PLAYERS][3][12];

enum dInfo {
    dDialog,
	dQuestion[500],
	dAnswers[300],
	dSuccesQwe
}
new QueInfo[7][dInfo] = {
		{2,"Что делать при возниконовении ДТП?",										"Скрыться с места ДТП\nНемедленно остановиться и вызвать полицию\nВызвать сотрудников скорой помощи\nВызвать такси",1},
		{2,"Максимальная скорость в городе?",											"60 км/ч\n90 км/ч\n100 км/ч\n120 км/ч",0},
		{2,"Максимальная скорость за городом?",											"90 км/ч\n100 км/ч\n110 км/ч\n120 км/ч",2},
		{2,"Со скольки лет можно получить вод.удостоверение?",							"14 лет\n16 лет\n18 лет\n20 лет",2},
		{2,"Когда следует включать ближний свет фар?",		 							"В светлое время суток\nВ тёмное время суток\nНе нужно включать\nНужно включать в любое время суток",3},
		{2,"В каком случае разрешена остановка на автомагистрали?",		 				"В любых местах за пределами проезжей части\nПравее линии разметки, обозначающей край проезжей части\nТолько на спец. площадках для стоянки\nЗапрещается",2},
		{2,"Должны ли быть видны гос. номера автомобиля?",		 						"Не должны\nДолжны только спереди\nДолжны только сзади\nДолжны спереди и сзади",3}
	},
	TestASKMassive[MAX_PLAYERS][7],

	Float:AutoCP[AUTO_CP_COUNT][3] = {
		{-2047.1299,-82.7046,34.9072},
		{-2021.2046,-72.2330,34.9150},
		{-2004.2841,-56.4547,34.9083},
		{-2004.3656,63.5635,29.0903},
		{-2003.5389,169.0928,27.2806},
		{-1999.3879,309.9337,34.7228},
		{-1999.1091,488.9284,34.7584},
		{-2020.0480,506.7851,34.7583},
		{-2123.5198,506.4044,34.7593},
		{-2147.1807,490.5033,34.7583},
		{-2149.1292,407.9551,34.8205},
		{-2148.8479,229.6411,34.9152},
		{-2165.5833,210.6641,34.9144},
		{-2233.7517,210.4253,34.9137},
		{-2249.0859,233.7054,34.9071},
		{-2261.7542,372.9274,33.2418},
		{-2359.8423,484.6871,30.3849},
		{-2383.4255,790.3303,34.7652},
		{-2364.3657,805.9047,36.6098},
		{-2217.7344,806.2595,49.0387},
		{-2095.3938,806.2051,69.1558},
		{-2023.7908,806.1768,47.0934},
		{-2000.5417,825.1227,45.0399},
		{-2000.4559,901.5263,45.0433},
		{-1983.4757,917.6733,45.0391},
		{-1859.3486,917.3110,34.7522},
		{-1738.9817,917.5093,24.4839},
		{-1584.8662,917.9406,7.2808},
		{-1541.6730,928.6280,6.7821},
		{-1540.8986,962.7398,6.7813},
		{-1586.9012,1029.1655,6.7806},
		{-1634.6927,1240.9236,6.7836},
		{-1733.3973,1340.2684,6.7808},
		{-1822.0417,1375.2615,6.7819},
		{-1930.4690,1306.2540,6.7826},
		{-2025.0059,1304.6970,6.8203},
		{-2062.1274,1281.8025,7.5473},
		{-2270.4485,1204.1831,53.2871},
		{-2267.0386,1095.9159,79.6025},
		{-2266.0283,990.1443,75.16690},
		{-2266.5266,807.7878,49.0438},
		{-2266.6682,585.7730,36.3168},
		{-2242.5308,562.4396,34.7589},
		{-2229.0964,540.6600,34.7586},
		{-2209.9031,506.0080,34.7579},
		{-2102.6755,501.8567,34.7602},
		{-2020.8113,501.6382,34.7586},
		{-2007.8937,491.4999,34.7592},
		{-2009.4333,253.1356,30.0010},
		{-2008.9186,60.0073,29.5201},
		{-2008.8951,-83.7164,35.0135},
		{-2007.6554,-162.2175,35.4526},
		{-2007.6746,-276.8484,35.0604},
		{-2038.9626,-289.8528,35.1186},
		{-2195.3115,-290.1100,35.0690},
		{-2205.7070,-272.5776,35.0689},
		{-2205.3076,-204.0107,35.0867},
		{-2236.1755,-187.5369,34.9148},
		{-2251.8374,-86.5177,34.9136},
		{-2234.4314,-72.5208,34.9151},
		{-2083.7751,-72.7984,34.9150},
		{-2046.7074,-84.9175,34.9071},
		{-2079.5813,-95.3732,32.9071}
	},
	Float:AutoCPMav[16][3] = {
		{-2237.0500,2268.0081,83.6208},
		{-2375.0461,2113.6812,127.8150},
		{-2578.3135,1876.7322,127.8150},
		{-2775.0762,1720.8237,127.8150},
		{-2774.0469,1437.7941,127.8150},
		{-2508.0786,1122.9218,196.0580},
		{-2354.1763,1014.5866,196.0580},
		{-2025.0238,1001.5494,196.0580},
		{-1797.6589,1070.4943,196.0580},
		{-1709.8640,1288.2534,104.2660},
		{-1666.0533,1514.0822,104.2660},
		{-1760.7709,1795.3632,104.2660},
		{-1842.9213,2034.1228,104.2660},
		{-2057.4817,2263.4072,104.2660},
		{-2178.4324,2308.7937,56.7514},
		{-2226.2112,2326.8320,7.5469}
	},
	Float:AutoCPBoat[17][3] = {
		{-2183.6353,2452.7236,1.5673},
		{-2149.7393,2290.8181,1.5673},
		{-2038.6492,2111.3970,1.5673},
		{-1931.0121,1946.3879,1.5673},
		{-1914.0162,1688.6759,1.5673},
		{-2124.9104,1578.5792,1.5673},
		{-2347.3064,1499.0609,1.5673},
		{-2539.6792,1527.0002,1.5673},
		{-2734.9744,1561.1744,1.5673},
		{-2685.3503,1710.8802,1.5673},
		{-2641.0125,1872.9221,1.5673},
		{-2556.4885,2007.4111,1.5673},
		{-2432.7034,2073.5146,1.5673},
		{-2301.9253,2132.1987,1.5673},
		{-2193.7424,2278.9890,1.5673},
		{-2170.6936,2432.3828,1.5673},
		{-2210.7000,2410.0308,1.5673}
	};
enum SADinfo {
	sad_object[9],
	Text3D:sad_3dtext,
	sad_fermer[24],
	sad_temp,
	sad_time,
	bool:sad_use
};
new sad_area[119],
	SI[119][SADinfo],
	Float:sad_objects[119][6] = {
		{ -226.486404, 93.764694, -0.948091, -0.000003, 0.000006, -19.899995 },
		{ -216.287322, 89.569213, -0.948091, -0.000006, 0.000013, -19.899990 },
		{ -206.333007, 85.554542, -0.948091, -0.000006, 0.000013, -19.899990 },
		{ -196.133911, 81.359062, -0.948091, -0.000009, 0.000020, -19.899990 },
		{ -185.723388, 78.033241, -0.948091, -0.000009, 0.000020, -19.899990 },
		{ -175.524307, 73.837753, -0.948091, -0.000012, 0.000027, -19.899990 },
		{ -164.655883, 70.929939, -0.948090, -0.000012, 0.000027, -19.899990 },
		{ -154.456802, 66.734458, -0.948090, -0.000015, 0.000034, -19.899990 },
		{ -143.513366, 63.020080, -0.948090, -0.000015, 0.000034, -19.899990 },
		{ -133.314285, 58.824600, -0.948090, -0.000018, 0.000041, -19.899990 },
		{ -229.546340, 80.324729, -0.948090, -0.000005, 0.000014, -19.899995 },
		{ -219.347259, 76.129249, -0.948090, -0.000008, 0.000021, -19.899988 },
		{ -209.392944, 72.114578, -0.948090, -0.000008, 0.000021, -19.899988 },
		{ -199.193847, 67.919097, -0.948090, -0.000012, 0.000028, -19.899988 },
		{ -188.783325, 64.593276, -0.948090, -0.000012, 0.000028, -19.899988 },
		{ -178.584243, 60.397789, -0.948090, -0.000015, 0.000034, -19.899988 },
		{ -167.715820, 57.489974, -0.948090, -0.000015, 0.000034, -19.899988 },
		{ -157.516738, 53.294494, -0.948090, -0.000018, 0.000041, -19.899988 },
		{ -146.573303, 49.580116, -0.948090, -0.000018, 0.000041, -19.899988 },
		{ -136.374221, 45.384635, -0.948090, -0.000021, 0.000048, -19.899988 },
		{ -233.266418, 66.574691, -0.948090, -0.000005, 0.000014, -19.899995 },
		{ -223.067337, 62.379207, -0.948090, -0.000008, 0.000021, -19.899988 },
		{ -213.113021, 58.364536, -0.948090, -0.000008, 0.000021, -19.899988 },
		{ -202.913925, 54.169055, -0.948090, -0.000012, 0.000028, -19.899988 },
		{ -192.503402, 50.843235, -0.948090, -0.000012, 0.000028, -19.899988 },
		{ -182.304321, 46.647747, -0.948090, -0.000015, 0.000034, -19.899988 },
		{ -171.435897, 43.739933, -0.948090, -0.000015, 0.000034, -19.899988 },
		{ -161.236816, 39.544452, -0.948090, -0.000018, 0.000041, -19.899988 },
		{ -150.293380, 35.830074, -0.948090, -0.000018, 0.000041, -19.899988 },
		{ -140.094299, 31.634593, -0.948090, -0.000021, 0.000048, -19.899988 },
		{ -236.326354, 53.134723, -0.948090, -0.000008, 0.000021, -19.899995 },
		{ -226.127273, 48.939243, -0.948090, -0.000011, 0.000028, -19.899988 },
		{ -216.172958, 44.924571, -0.948090, -0.000011, 0.000028, -19.899988 },
		{ -205.973861, 40.729091, -0.948090, -0.000014, 0.000035, -19.899988 },
		{ -195.563339, 37.403270, -0.948090, -0.000014, 0.000035, -19.899988 },
		{ -185.364257, 33.207782, -0.948090, -0.000017, 0.000042, -19.899988 },
		{ -174.495834, 30.299968, -0.948090, -0.000017, 0.000042, -19.899988 },
		{ -164.296752, 26.104488, -0.948090, -0.000021, 0.000049, -19.899988 },
		{ -153.353317, 22.390110, -0.948090, -0.000021, 0.000049, -19.899988 },
		{ -143.154235, 18.194629, -0.948090, -0.000024, 0.000056, -19.899988 },
		{ -242.345413, 43.200313, -0.948090, -0.000010, 0.000028, -23.600004 },
		{ -232.438323, 38.355407, -0.948090, -0.000014, 0.000035, -23.600000 },
		{ -222.763839, 33.706722, -0.948090, -0.000014, 0.000035, -23.600000 },
		{ -212.856750, 28.861812, -0.948090, -0.000017, 0.000042, -23.600000 },
		{ -202.682540, 24.871109, -0.948090, -0.000017, 0.000042, -23.600000 },
		{ -192.775466, 20.026193, -0.948090, -0.000020, 0.000049, -23.600000 },
		{ -182.117355, 16.423072, -0.948090, -0.000020, 0.000049, -23.600000 },
		{ -172.210266, 11.578165, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -161.529342, 7.165320, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -151.622253, 2.320413, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -246.266281, 29.985826, -0.948090, -0.000013, 0.000035, -23.600004 },
		{ -236.359207, 25.140918, -0.948090, -0.000016, 0.000042, -23.600000 },
		{ -226.684707, 20.492237, -0.948090, -0.000016, 0.000042, -23.600000 },
		{ -216.777618, 15.647329, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -206.603424, 11.656623, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -196.696334, 6.811707, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -186.038223, 3.208588, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -176.131134, -1.636319, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -165.450210, -6.049163, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -155.543136, -10.894070, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -250.865936, 16.504512, -0.948090, -0.000013, 0.000035, -23.600004 },
		{ -240.958847, 11.659602, -0.948090, -0.000016, 0.000042, -23.600000 },
		{ -231.284362, 7.010922, -0.948090, -0.000016, 0.000042, -23.600000 },
		{ -221.377273, 2.166013, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -211.203063, -1.824692, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -201.295989, -6.669608, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -190.637878, -10.272727, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -180.730789, -15.117635, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -170.049865, -19.530479, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -160.142791, -24.375387, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -254.786804, 3.290025, -0.948090, -0.000016, 0.000042, -23.600004 },
		{ -244.879730, -1.554882, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -235.205245, -6.203562, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -225.298141, -11.048471, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -215.123947, -15.039176, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -205.216857, -19.884092, -0.948090, -0.000025, 0.000063, -23.600000 },
		{ -194.558746, -23.487211, -0.948090, -0.000025, 0.000063, -23.600000 },
		{ -184.651657, -28.332120, -0.948090, -0.000028, 0.000070, -23.600000 },
		{ -173.970733, -32.744968, -0.948090, -0.000028, 0.000070, -23.600000 },
		{ -164.063659, -37.589874, -0.948090, -0.000031, 0.000077, -23.600000 },
		{ -258.745483, -6.849704, -0.948090, -0.000014, 0.000035, -23.600004 },
		{ -248.838378, -11.694610, -0.948090, -0.000017, 0.000042, -23.600000 },
		{ -239.163894, -16.343296, -0.948090, -0.000017, 0.000042, -23.600000 },
		{ -229.256805, -21.188205, -0.948090, -0.000020, 0.000049, -23.600000 },
		{ -219.082595, -25.178909, -0.948090, -0.000020, 0.000049, -23.600000 },
		{ -209.175521, -30.023824, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -198.517410, -33.626945, -0.948090, -0.000023, 0.000056, -23.600000 },
		{ -188.610321, -38.471855, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -177.929397, -42.884696, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -168.022308, -47.729606, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -262.666320, -20.064191, -0.948090, -0.000016, 0.000042, -23.600004 },
		{ -252.759262, -24.909099, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -243.084762, -29.557781, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -233.177673, -34.402687, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -223.003479, -38.393394, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -213.096389, -43.238311, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -202.438278, -46.841430, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -192.531188, -51.686336, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -181.850265, -56.099182, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -171.943191, -60.944087, -0.948090, -0.000032, 0.000077, -23.600000 },
		{ -267.265991, -33.545505, -0.948090, -0.000016, 0.000042, -23.600004 },
		{ -257.358886, -38.390415, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -247.684417, -43.039096, -0.948090, -0.000019, 0.000049, -23.600000 },
		{ -237.777328, -47.884006, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -227.603118, -51.874710, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -217.696044, -56.719627, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -207.037933, -60.322746, -0.948090, -0.000026, 0.000063, -23.600000 },
		{ -197.130844, -65.167655, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -186.449920, -69.580497, -0.948090, -0.000029, 0.000070, -23.600000 },
		{ -176.542846, -74.425407, -0.948090, -0.000032, 0.000077, -23.600000 },
		{ -271.186859, -46.759994, -0.948090, -0.000019, 0.000049, -23.600004 },
		{ -261.279785, -51.604900, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -251.605300, -56.253582, -0.948090, -0.000022, 0.000056, -23.600000 },
		{ -241.698196, -61.098487, -0.948090, -0.000025, 0.000063, -23.600000 },
		{ -231.524002, -65.089195, -0.948090, -0.000025, 0.000063, -23.600000 },
		{ -221.616912, -69.934112, -0.948090, -0.000028, 0.000070, -23.600000 },
		{ -210.958801, -73.537231, -0.948090, -0.000028, 0.000070, -23.600000 },
		{ -201.051712, -78.382141, -0.948090, -0.000031, 0.000077, -23.600000 },
		{ -190.370788, -82.794982, -0.948090, -0.000031, 0.000077, -23.600000 }
	},
	Float:sad_stairs[119][6] = {
		{ -226.001708, 93.735031, 2.619222, 0.000007, 0.000001, 84.199958 },
		{ -215.802612, 89.539550, 2.619222, 0.000015, 0.000002, 84.199935 },
		{ -205.848312, 85.524879, 2.619222, 0.000015, 0.000002, 84.199935 },
		{ -195.649230, 81.329399, 2.619222, 0.000022, 0.000004, 84.199913 },
		{ -185.238677, 78.003570, 2.619222, 0.000022, 0.000004, 84.199913 },
		{ -175.039596, 73.808090, 2.619222, 0.000030, 0.000005, 84.199890 },
		{ -164.171188, 70.900276, 2.619222, 0.000030, 0.000005, 84.199890 },
		{ -153.972106, 66.704788, 2.619222, 0.000037, 0.000006, 84.199867 },
		{ -143.028671, 62.990413, 2.619222, 0.000037, 0.000006, 84.199867 },
		{ -132.829589, 58.794933, 2.619222, 0.000045, 0.000008, 84.199844 },
		{ -229.061645, 80.295066, 2.619222, 0.000015, 0.000002, 84.199935 },
		{ -218.862548, 76.099586, 2.619222, 0.000022, 0.000003, 84.199913 },
		{ -208.908248, 72.084915, 2.619222, 0.000022, 0.000003, 84.199913 },
		{ -198.709167, 67.889434, 2.619222, 0.000030, 0.000004, 84.199890 },
		{ -188.298614, 64.563606, 2.619222, 0.000030, 0.000004, 84.199890 },
		{ -178.099533, 60.368125, 2.619222, 0.000037, 0.000006, 84.199867 },
		{ -167.231124, 57.460311, 2.619222, 0.000037, 0.000006, 84.199867 },
		{ -157.032043, 53.264823, 2.619222, 0.000045, 0.000007, 84.199844 },
		{ -146.088607, 49.550449, 2.619222, 0.000045, 0.000007, 84.199844 },
		{ -135.889526, 45.354969, 2.619222, 0.000052, 0.000009, 84.199821 },
		{ -232.781723, 66.545028, 2.619222, 0.000015, 0.000002, 84.199935 },
		{ -222.582626, 62.349544, 2.619222, 0.000022, 0.000003, 84.199913 },
		{ -212.628326, 58.334873, 2.619222, 0.000022, 0.000003, 84.199913 },
		{ -202.429244, 54.139392, 2.619222, 0.000030, 0.000004, 84.199890 },
		{ -192.018692, 50.813564, 2.619222, 0.000030, 0.000004, 84.199890 },
		{ -181.819610, 46.618083, 2.619222, 0.000037, 0.000006, 84.199867 },
		{ -170.951202, 43.710269, 2.619222, 0.000037, 0.000006, 84.199867 },
		{ -160.752120, 39.514781, 2.619222, 0.000045, 0.000007, 84.199844 },
		{ -149.808685, 35.800407, 2.619222, 0.000045, 0.000007, 84.199844 },
		{ -139.609603, 31.604927, 2.619222, 0.000052, 0.000009, 84.199821 },
		{ -235.841659, 53.105060, 2.619222, 0.000022, 0.000002, 84.199913 },
		{ -225.642562, 48.909580, 2.619222, 0.000030, 0.000004, 84.199890 },
		{ -215.688262, 44.894908, 2.619222, 0.000030, 0.000004, 84.199890 },
		{ -205.489181, 40.699428, 2.619222, 0.000037, 0.000005, 84.199867 },
		{ -195.078628, 37.373600, 2.619222, 0.000037, 0.000005, 84.199867 },
		{ -184.879547, 33.178119, 2.619222, 0.000045, 0.000007, 84.199844 },
		{ -174.011138, 30.270305, 2.619222, 0.000045, 0.000007, 84.199844 },
		{ -163.812057, 26.074817, 2.619222, 0.000052, 0.000008, 84.199821 },
		{ -152.868621, 22.360443, 2.619222, 0.000052, 0.000008, 84.199821 },
		{ -142.669540, 18.164962, 2.619222, 0.000060, 0.000009, 84.199798 },
		{ -241.863632, 43.139434, 2.619222, 0.000030, 0.000003, 80.499885 },
		{ -231.956542, 38.294525, 2.619222, 0.000037, 0.000005, 80.499855 },
		{ -222.282073, 33.645843, 2.619222, 0.000037, 0.000005, 80.499855 },
		{ -212.374984, 28.800935, 2.619222, 0.000045, 0.000006, 80.499839 },
		{ -202.200759, 24.810218, 2.619222, 0.000045, 0.000006, 80.499839 },
		{ -192.293685, 19.965311, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -181.635574, 16.362194, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -171.728500, 11.517277, 2.619222, 0.000060, 0.000009, 80.499786 },
		{ -161.047561, 7.104437, 2.619222, 0.000060, 0.000009, 80.499786 },
		{ -151.140487, 2.259530, 2.619222, 0.000067, 0.000010, 80.499763 },
		{ -245.784515, 29.924945, 2.619222, 0.000037, 0.000004, 80.499855 },
		{ -235.877410, 25.080036, 2.619222, 0.000045, 0.000005, 80.499839 },
		{ -226.202941, 20.431358, 2.619222, 0.000045, 0.000005, 80.499839 },
		{ -216.295852, 15.586450, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -206.121627, 11.595735, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -196.214569, 6.750826, 2.619222, 0.000060, 0.000008, 80.499786 },
		{ -185.556442, 3.147708, 2.619222, 0.000060, 0.000008, 80.499786 },
		{ -175.649368, -1.697207, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -164.968444, -6.110047, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -155.061355, -10.954955, 2.619222, 0.000075, 0.000011, 80.499748 },
		{ -250.384155, 16.443634, 2.619222, 0.000037, 0.000004, 80.499855 },
		{ -240.477066, 11.598720, 2.619222, 0.000045, 0.000005, 80.499839 },
		{ -230.802597, 6.950041, 2.619222, 0.000045, 0.000005, 80.499839 },
		{ -220.895507, 2.105134, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -210.721282, -1.885581, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -200.814193, -6.730488, 2.619222, 0.000060, 0.000008, 80.499786 },
		{ -190.156097, -10.333607, 2.619222, 0.000060, 0.000008, 80.499786 },
		{ -180.249023, -15.178524, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -169.568084, -19.591361, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -159.661010, -24.436271, 2.619222, 0.000075, 0.000011, 80.499748 },
		{ -254.305038, 3.229145, 2.619222, 0.000045, 0.000005, 80.499839 },
		{ -244.397933, -1.615763, 2.619222, 0.000052, 0.000006, 80.499816 },
		{ -234.723464, -6.264442, 2.619222, 0.000052, 0.000006, 80.499816 },
		{ -224.816375, -11.109350, 2.619222, 0.000060, 0.000007, 80.499786 },
		{ -214.642150, -15.100067, 2.619222, 0.000060, 0.000007, 80.499786 },
		{ -204.735076, -19.944974, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -194.076965, -23.548091, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -184.169891, -28.393007, 2.619222, 0.000075, 0.000010, 80.499748 },
		{ -173.488967, -32.805850, 2.619222, 0.000075, 0.000010, 80.499748 },
		{ -163.581878, -37.650753, 2.619222, 0.000082, 0.000012, 80.499725 },
		{ -258.263671, -6.910583, 2.619222, 0.000037, 0.000004, 80.499862 },
		{ -248.356597, -11.755493, 2.619222, 0.000045, 0.000006, 80.499832 },
		{ -238.682128, -16.404174, 2.619222, 0.000045, 0.000006, 80.499832 },
		{ -228.775039, -21.249082, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -218.600814, -25.239799, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -208.693740, -30.084707, 2.619222, 0.000060, 0.000009, 80.499794 },
		{ -198.035629, -33.687824, 2.619222, 0.000060, 0.000009, 80.499794 },
		{ -188.128555, -38.532741, 2.619222, 0.000067, 0.000010, 80.499763 },
		{ -177.447616, -42.945579, 2.619222, 0.000067, 0.000010, 80.499763 },
		{ -167.540542, -47.790489, 2.619222, 0.000075, 0.000011, 80.499740 },
		{ -262.184570, -20.125072, 2.619222, 0.000045, 0.000005, 80.499832 },
		{ -252.277465, -24.969982, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -242.602996, -29.618659, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -232.695907, -34.463569, 2.619222, 0.000060, 0.000008, 80.499794 },
		{ -222.521682, -38.454284, 2.619222, 0.000060, 0.000008, 80.499794 },
		{ -212.614624, -43.299190, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -201.956497, -46.902309, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -192.049423, -51.747226, 2.619222, 0.000075, 0.000011, 80.499740 },
		{ -181.368499, -56.160064, 2.619222, 0.000075, 0.000011, 80.499740 },
		{ -171.461410, -61.004974, 2.619222, 0.000082, 0.000012, 80.499725 },
		{ -266.784210, -33.606384, 2.619222, 0.000045, 0.000005, 80.499832 },
		{ -256.877136, -38.451297, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -247.202651, -43.099975, 2.619222, 0.000052, 0.000007, 80.499816 },
		{ -237.295562, -47.944885, 2.619222, 0.000060, 0.000008, 80.499794 },
		{ -227.121337, -51.935600, 2.619222, 0.000060, 0.000008, 80.499794 },
		{ -217.214248, -56.780506, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -206.556152, -60.383625, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -196.649078, -65.228546, 2.619222, 0.000075, 0.000011, 80.499740 },
		{ -185.968139, -69.641380, 2.619222, 0.000075, 0.000011, 80.499740 },
		{ -176.061065, -74.486289, 2.619222, 0.000082, 0.000012, 80.499725 },
		{ -270.705078, -46.820873, 2.619222, 0.000052, 0.000006, 80.499816 },
		{ -260.797973, -51.665782, 2.619222, 0.000060, 0.000007, 80.499794 },
		{ -251.123519, -56.314460, 2.619222, 0.000060, 0.000007, 80.499794 },
		{ -241.216430, -61.159370, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -231.042205, -65.150085, 2.619222, 0.000067, 0.000009, 80.499763 },
		{ -221.135131, -69.994995, 2.619222, 0.000075, 0.000010, 80.499740 },
		{ -210.477020, -73.598114, 2.619222, 0.000075, 0.000010, 80.499740 },
		{ -200.569946, -78.443023, 2.619222, 0.000082, 0.000012, 80.499725 },
		{ -189.889022, -82.855865, 2.619222, 0.000082, 0.000012, 80.499725 }
	};

enum s_apple {
	a_ID,
	Float:a_coordsX,
	Float:a_coordsY,
	Float:a_coordsZ,
	Float:a_coordsAX,
	Float:a_coordsAY,
	Float:a_coordsAZ
}
new sad_apple[833][s_apple] = {
	{ 0, -225.258819, 92.767127, 5.712926, 0.000000, 0.000007, 4.599997 },
	{ 0, -226.205520, 91.567390, 7.042929, 0.000000, 0.000007, 4.599997 },
	{ 0, -227.997024, 92.771568, 5.900618, 0.000000, 0.000007, 4.599997 },
	{ 0, -228.189788, 94.717208, 6.156506, 0.000000, 0.000007, 4.599997 },
	{ 0, -225.719497, 91.557861, 7.075955, 0.000000, 0.000007, 4.599997 },
	{ 0, -225.961410, 96.371261, 7.306849, 0.000000, 0.000007, 4.599997 },
	{ 0, -227.136718, 94.948760, 5.651482, 0.000000, 0.000007, 4.599997 },
	{ 1,  -215.059738, 88.571647, 5.712926, 0.000000, 0.000015, 4.599997 },
	{ 1,  -216.006439, 87.371910, 7.042929, 0.000000, 0.000015, 4.599997 },
	{ 1,  -217.797943, 88.576080, 5.900618, 0.000000, 0.000015, 4.599997 },
	{ 1,  -217.990692, 90.521728, 6.156506, 0.000000, 0.000015, 4.599997 },
	{ 1,  -215.520401, 87.362380, 7.075955, 0.000000, 0.000015, 4.599997 },
	{ 1,  -215.762329, 92.175781, 7.306849, 0.000000, 0.000015, 4.599997 },
	{ 1,  -216.937637, 90.753280, 5.651482, 0.000000, 0.000015, 4.599997 },
	{ 2,  -205.105422, 84.556983, 5.712926, 0.000000, 0.000015, 4.599997 },
	{ 2,  -206.052108, 83.357238, 7.042929, 0.000000, 0.000015, 4.599997 },
	{ 2,  -207.843627, 84.561416, 5.900618, 0.000000, 0.000015, 4.599997 },
	{ 2,  -208.036392, 86.507064, 6.156506, 0.000000, 0.000015, 4.599997 },
	{ 2,  -205.566085, 83.347724, 7.075955, 0.000000, 0.000015, 4.599997 },
	{ 2,  -205.808013, 88.161117, 7.306849, 0.000000, 0.000015, 4.599997 },
	{ 2,  -206.983322, 86.738624, 5.651482, 0.000000, 0.000015, 4.599997 },
	{ 3,  -194.906341, 80.361503, 5.712926, 0.000000, 0.000022, 4.599997 },
	{ 3,  -195.853027, 79.161758, 7.042929, 0.000000, 0.000022, 4.599997 },
	{ 3,  -197.644546, 80.365936, 5.900618, 0.000000, 0.000022, 4.599997 },
	{ 3,  -197.837310, 82.311584, 6.156506, 0.000000, 0.000022, 4.599997 },
	{ 3,  -195.367004, 79.152236, 7.075955, 0.000000, 0.000022, 4.599997 },
	{ 3,  -195.608932, 83.965629, 7.306849, 0.000000, 0.000022, 4.599997 },
	{ 3,  -196.784240, 82.543136, 5.651482, 0.000000, 0.000022, 4.599997 },
	{ 4,  -184.495788, 77.035675, 5.712926, 0.000000, 0.000022, 4.599997 },
	{ 4,  -185.442504, 75.835937, 7.042929, 0.000000, 0.000022, 4.599997 },
	{ 4,  -187.234008, 77.040107, 5.900618, 0.000000, 0.000022, 4.599997 },
	{ 4,  -187.426757, 78.985763, 6.156506, 0.000000, 0.000022, 4.599997 },
	{ 4,  -184.956466, 75.826416, 7.075955, 0.000000, 0.000022, 4.599997 },
	{ 4,  -185.198394, 80.639808, 7.306849, 0.000000, 0.000022, 4.599997 },
	{ 4,  -186.373703, 79.217315, 5.651482, 0.000000, 0.000022, 4.599997 },
	{ 5,  -174.296707, 72.840194, 5.712926, 0.000000, 0.000030, 4.599997 },
	{ 5,  -175.243423, 71.640457, 7.042929, 0.000000, 0.000030, 4.599997 },
	{ 5,  -177.034927, 72.844627, 5.900618, 0.000000, 0.000030, 4.599997 },
	{ 5,  -177.227676, 74.790275, 6.156506, 0.000000, 0.000030, 4.599997 },
	{ 5,  -174.757385, 71.630935, 7.075955, 0.000000, 0.000030, 4.599997 },
	{ 5,  -174.999298, 76.444328, 7.306849, 0.000000, 0.000030, 4.599997 },
	{ 5,  -176.174606, 75.021835, 5.651482, 0.000000, 0.000030, 4.599997 },
	{ 6,  -163.428298, 69.932373, 5.712926, 0.000000, 0.000030, 4.599997 },
	{ 6,  -164.375000, 68.732635, 7.042929, 0.000000, 0.000030, 4.599997 },
	{ 6,  -166.166503, 69.936805, 5.900618, 0.000000, 0.000030, 4.599997 },
	{ 6,  -166.359268, 71.882461, 6.156506, 0.000000, 0.000030, 4.599997 },
	{ 6,  -163.888961, 68.723114, 7.075955, 0.000000, 0.000030, 4.599997 },
	{ 6,  -164.130889, 73.536506, 7.306849, 0.000000, 0.000030, 4.599997 },
	{ 6,  -165.306198, 72.114013, 5.651482, 0.000000, 0.000030, 4.599997 },
	{ 7,  -153.229217, 65.736885, 5.712926, 0.000000, 0.000038, 4.599997 },
	{ 7,  -154.175903, 64.537147, 7.042929, 0.000000, 0.000038, 4.599997 },
	{ 7,  -155.967422, 65.741325, 5.900618, 0.000000, 0.000038, 4.599997 },
	{ 7,  -156.160186, 67.686981, 6.156506, 0.000000, 0.000038, 4.599997 },
	{ 7,  -153.689880, 64.527633, 7.075955, 0.000000, 0.000038, 4.599997 },
	{ 7,  -153.931808, 69.341026, 7.306849, 0.000000, 0.000038, 4.599997 },
	{ 7,  -155.107116, 67.918533, 5.651482, 0.000000, 0.000038, 4.599997 },
	{ 8,  -142.285766, 62.022514, 5.712926, 0.000000, 0.000038, 4.599997 },
	{ 8,  -143.232482, 60.822776, 7.042929, 0.000000, 0.000038, 4.599997 },
	{ 8,  -145.023986, 62.026950, 5.900618, 0.000000, 0.000038, 4.599997 },
	{ 8,  -145.216751, 63.972595, 6.156506, 0.000000, 0.000038, 4.599997 },
	{ 8,  -142.746444, 60.813255, 7.075955, 0.000000, 0.000038, 4.599997 },
	{ 8,  -142.988388, 65.626647, 7.306849, 0.000000, 0.000038, 4.599997 },
	{ 8,  -144.163681, 64.204154, 5.651482, 0.000000, 0.000038, 4.599997 },
	{ 9,  -132.086685, 57.827033, 5.712926, 0.000000, 0.000045, 4.599997 },
	{ 9,  -133.033401, 56.627296, 7.042929, 0.000000, 0.000045, 4.599997 },
	{ 9,  -134.824905, 57.831470, 5.900618, 0.000000, 0.000045, 4.599997 },
	{ 9,  -135.017669, 59.777114, 6.156506, 0.000000, 0.000045, 4.599997 },
	{ 9,  -132.547363, 56.617767, 7.075955, 0.000000, 0.000045, 4.599997 },
	{ 9,  -132.789291, 61.431163, 7.306849, 0.000000, 0.000045, 4.599997 },
	{ 9,  -133.964599, 60.008666, 5.651482, 0.000000, 0.000045, 4.599997 },
	{ 10,  -228.318756, 79.327163, 5.712926, 0.000000, 0.000015, 4.599997 },
	{ 10,  -229.265457, 78.127426, 7.042929, 0.000000, 0.000015, 4.599997 },
	{ 10,  -231.056961, 79.331604, 5.900618, 0.000000, 0.000015, 4.599997 },
	{ 10,  -231.249725, 81.277244, 6.156506, 0.000000, 0.000015, 4.599997 },
	{ 10,  -228.779434, 78.117897, 7.075955, 0.000000, 0.000015, 4.599997 },
	{ 10,  -229.021347, 82.931297, 7.306849, 0.000000, 0.000015, 4.599997 },
	{ 10,  -230.196655, 81.508796, 5.651482, 0.000000, 0.000015, 4.599997 },
	{ 11,  -218.119674, 75.131683, 5.712926, 0.000000, 0.000022, 4.599997 },
	{ 11,  -219.066375, 73.931945, 7.042929, 0.000000, 0.000022, 4.599997 },
	{ 11,  -220.857879, 75.136116, 5.900618, 0.000000, 0.000022, 4.599997 },
	{ 11,  -221.050628, 77.081764, 6.156506, 0.000000, 0.000022, 4.599997 },
	{ 11,  -218.580337, 73.922416, 7.075955, 0.000000, 0.000022, 4.599997 },
	{ 11,  -218.822265, 78.735816, 7.306849, 0.000000, 0.000022, 4.599997 },
	{ 11,  -219.997573, 77.313316, 5.651482, 0.000000, 0.000022, 4.599997 },
	{ 12,  -208.165359, 71.117019, 5.712926, 0.000000, 0.000022, 4.599997 },
	{ 12,  -209.112045, 69.917274, 7.042929, 0.000000, 0.000022, 4.599997 },
	{ 12,  -210.903564, 71.121452, 5.900618, 0.000000, 0.000022, 4.599997 },
	{ 12,  -211.096328, 73.067100, 6.156506, 0.000000, 0.000022, 4.599997 },
	{ 12,  -208.626022, 69.907760, 7.075955, 0.000000, 0.000022, 4.599997 },
	{ 12,  -208.867950, 74.721153, 7.306849, 0.000000, 0.000022, 4.599997 },
	{ 12,  -210.043258, 73.298660, 5.651482, 0.000000, 0.000022, 4.599997 },
	{ 13,  -197.966278, 66.921539, 5.712926, 0.000000, 0.000030, 4.599997 },
	{ 13,  -198.912963, 65.721794, 7.042929, 0.000000, 0.000030, 4.599997 },
	{ 13,  -200.704483, 66.925971, 5.900618, 0.000000, 0.000030, 4.599997 },
	{ 13,  -200.897247, 68.871620, 6.156506, 0.000000, 0.000030, 4.599997 },
	{ 13,  -198.426940, 65.712272, 7.075955, 0.000000, 0.000030, 4.599997 },
	{ 13,  -198.668869, 70.525665, 7.306849, 0.000000, 0.000030, 4.599997 },
	{ 13,  -199.844177, 69.103172, 5.651482, 0.000000, 0.000030, 4.599997 },
	{ 14,  -187.555725, 63.595710, 5.712926, 0.000000, 0.000030, 4.599997 },
	{ 14,  -188.502441, 62.395973, 7.042929, 0.000000, 0.000030, 4.599997 },
	{ 14,  -190.293945, 63.600143, 5.900618, 0.000000, 0.000030, 4.599997 },
	{ 14,  -190.486694, 65.545799, 6.156506, 0.000000, 0.000030, 4.599997 },
	{ 14,  -188.016403, 62.386451, 7.075955, 0.000000, 0.000030, 4.599997 },
	{ 14,  -188.258331, 67.199844, 7.306849, 0.000000, 0.000030, 4.599997 },
	{ 14,  -189.433639, 65.777351, 5.651482, 0.000000, 0.000030, 4.599997 },
	{ 15,  -177.356643, 59.400230, 5.712926, 0.000000, 0.000038, 4.599997 },
	{ 15,  -178.303359, 58.200492, 7.042929, 0.000000, 0.000038, 4.599997 },
	{ 15,  -180.094863, 59.404663, 5.900618, 0.000000, 0.000038, 4.599997 },
	{ 15,  -180.287612, 61.350311, 6.156506, 0.000000, 0.000038, 4.599997 },
	{ 15,  -177.817321, 58.190971, 7.075955, 0.000000, 0.000038, 4.599997 },
	{ 15,  -178.059234, 63.004364, 7.306849, 0.000000, 0.000038, 4.599997 },
	{ 15,  -179.234542, 61.581871, 5.651482, 0.000000, 0.000038, 4.599997 },
	{ 16,  -166.488235, 56.492408, 5.712926, 0.000000, 0.000038, 4.599997 },
	{ 16,  -167.434936, 55.292671, 7.042929, 0.000000, 0.000038, 4.599997 },
	{ 16,  -169.226440, 56.496841, 5.900618, 0.000000, 0.000038, 4.599997 },
	{ 16,  -169.419204, 58.442497, 6.156506, 0.000000, 0.000038, 4.599997 },
	{ 16,  -166.948898, 55.283149, 7.075955, 0.000000, 0.000038, 4.599997 },
	{ 16,  -167.190826, 60.096542, 7.306849, 0.000000, 0.000038, 4.599997 },
	{ 16,  -168.366134, 58.674049, 5.651482, 0.000000, 0.000038, 4.599997 },
	{ 17,  -156.289154, 52.296920, 5.712926, 0.000000, 0.000045, 4.599997 },
	{ 17,  -157.235839, 51.097183, 7.042929, 0.000000, 0.000045, 4.599997 },
	{ 17,  -159.027359, 52.301361, 5.900618, 0.000000, 0.000045, 4.599997 },
	{ 17,  -159.220123, 54.247016, 6.156506, 0.000000, 0.000045, 4.599997 },
	{ 17,  -156.749816, 51.087669, 7.075955, 0.000000, 0.000045, 4.599997 },
	{ 17,  -156.991744, 55.901062, 7.306849, 0.000000, 0.000045, 4.599997 },
	{ 17,  -158.167053, 54.478569, 5.651482, 0.000000, 0.000045, 4.599997 },
	{ 18,  -145.345703, 48.582550, 5.712926, 0.000000, 0.000045, 4.599997 },
	{ 18,  -146.292419, 47.382812, 7.042929, 0.000000, 0.000045, 4.599997 },
	{ 18,  -148.083923, 48.586986, 5.900618, 0.000000, 0.000045, 4.599997 },
	{ 18,  -148.276687, 50.532630, 6.156506, 0.000000, 0.000045, 4.599997 },
	{ 18,  -145.806381, 47.373291, 7.075955, 0.000000, 0.000045, 4.599997 },
	{ 18,  -146.048324, 52.186683, 7.306849, 0.000000, 0.000045, 4.599997 },
	{ 18,  -147.223617, 50.764190, 5.651482, 0.000000, 0.000045, 4.599997 },
	{ 19,  -135.146621, 44.387069, 5.712926, 0.000000, 0.000053, 4.599997 },
	{ 19,  -136.093338, 43.187332, 7.042929, 0.000000, 0.000053, 4.599997 },
	{ 19,  -137.884841, 44.391506, 5.900618, 0.000000, 0.000053, 4.599997 },
	{ 19,  -138.077606, 46.337150, 6.156506, 0.000000, 0.000053, 4.599997 },
	{ 19,  -135.607299, 43.177803, 7.075955, 0.000000, 0.000053, 4.599997 },
	{ 19,  -135.849227, 47.991199, 7.306849, 0.000000, 0.000053, 4.599997 },
	{ 19,  -137.024536, 46.568702, 5.651482, 0.000000, 0.000053, 4.599997 },
	{ 20,  -232.038833, 65.577117, 5.712926, 0.000000, 0.000015, 4.599997 },
	{ 20,  -232.985534, 64.377380, 7.042929, 0.000000, 0.000015, 4.599997 },
	{ 20,  -234.777038, 65.581558, 5.900618, 0.000000, 0.000015, 4.599997 },
	{ 20,  -234.969802, 67.527206, 6.156506, 0.000000, 0.000015, 4.599997 },
	{ 20,  -232.499511, 64.367858, 7.075955, 0.000000, 0.000015, 4.599997 },
	{ 20,  -232.741424, 69.181259, 7.306849, 0.000000, 0.000015, 4.599997 },
	{ 20,  -233.916732, 67.758758, 5.651482, 0.000000, 0.000015, 4.599997 },
	{ 21,  -221.839752, 61.381641, 5.712926, 0.000000, 0.000022, 4.599997 },
	{ 21,  -222.786453, 60.181903, 7.042929, 0.000000, 0.000022, 4.599997 },
	{ 21,  -224.577957, 61.386074, 5.900618, 0.000000, 0.000022, 4.599997 },
	{ 21,  -224.770706, 63.331722, 6.156506, 0.000000, 0.000022, 4.599997 },
	{ 21,  -222.300415, 60.172374, 7.075955, 0.000000, 0.000022, 4.599997 },
	{ 21,  -222.542343, 64.985778, 7.306849, 0.000000, 0.000022, 4.599997 },
	{ 21,  -223.717651, 63.563274, 5.651482, 0.000000, 0.000022, 4.599997 },
	{ 22,  -211.885437, 57.366977, 5.712926, 0.000000, 0.000022, 4.599997 },
	{ 22,  -212.832122, 56.167232, 7.042929, 0.000000, 0.000022, 4.599997 },
	{ 22,  -214.623641, 57.371410, 5.900618, 0.000000, 0.000022, 4.599997 },
	{ 22,  -214.816406, 59.317058, 6.156506, 0.000000, 0.000022, 4.599997 },
	{ 22,  -212.346099, 56.157718, 7.075955, 0.000000, 0.000022, 4.599997 },
	{ 22,  -212.588027, 60.971111, 7.306849, 0.000000, 0.000022, 4.599997 },
	{ 22,  -213.763336, 59.548618, 5.651482, 0.000000, 0.000022, 4.599997 },
	{ 23,  -201.686355, 53.171497, 5.712926, 0.000000, 0.000030, 4.599997 },
	{ 23,  -202.633041, 51.971752, 7.042929, 0.000000, 0.000030, 4.599997 },
	{ 23,  -204.424560, 53.175930, 5.900618, 0.000000, 0.000030, 4.599997 },
	{ 23,  -204.617324, 55.121578, 6.156506, 0.000000, 0.000030, 4.599997 },
	{ 23,  -202.147018, 51.962230, 7.075955, 0.000000, 0.000030, 4.599997 },
	{ 23,  -202.388946, 56.775623, 7.306849, 0.000000, 0.000030, 4.599997 },
	{ 23,  -203.564254, 55.353130, 5.651482, 0.000000, 0.000030, 4.599997 },
	{ 24,  -191.275802, 49.845668, 5.712926, 0.000000, 0.000030, 4.599997 },
	{ 24,  -192.222518, 48.645931, 7.042929, 0.000000, 0.000030, 4.599997 },
	{ 24,  -194.014022, 49.850101, 5.900618, 0.000000, 0.000030, 4.599997 },
	{ 24,  -194.206771, 51.795757, 6.156506, 0.000000, 0.000030, 4.599997 },
	{ 24,  -191.736480, 48.636409, 7.075955, 0.000000, 0.000030, 4.599997 },
	{ 24,  -191.978408, 53.449802, 7.306849, 0.000000, 0.000030, 4.599997 },
	{ 24,  -193.153717, 52.027309, 5.651482, 0.000000, 0.000030, 4.599997 },
	{ 25,  -181.076721, 45.650188, 5.712926, 0.000000, 0.000038, 4.599997 },
	{ 25,  -182.023437, 44.450450, 7.042929, 0.000000, 0.000038, 4.599997 },
	{ 25,  -183.814941, 45.654621, 5.900618, 0.000000, 0.000038, 4.599997 },
	{ 25,  -184.007690, 47.600269, 6.156506, 0.000000, 0.000038, 4.599997 },
	{ 25,  -181.537399, 44.440929, 7.075955, 0.000000, 0.000038, 4.599997 },
	{ 25,  -181.779312, 49.254322, 7.306849, 0.000000, 0.000038, 4.599997 },
	{ 25,  -182.954620, 47.831829, 5.651482, 0.000000, 0.000038, 4.599997 },
	{ 26,  -170.208312, 42.742366, 5.712926, 0.000000, 0.000038, 4.599997 },
	{ 26,  -171.155014, 41.542629, 7.042929, 0.000000, 0.000038, 4.599997 },
	{ 26,  -172.946517, 42.746799, 5.900618, 0.000000, 0.000038, 4.599997 },
	{ 26,  -173.139282, 44.692455, 6.156506, 0.000000, 0.000038, 4.599997 },
	{ 26,  -170.668975, 41.533107, 7.075955, 0.000000, 0.000038, 4.599997 },
	{ 26,  -170.910903, 46.346500, 7.306849, 0.000000, 0.000038, 4.599997 },
	{ 26,  -172.086212, 44.924007, 5.651482, 0.000000, 0.000038, 4.599997 },
	{ 27,  -160.009231, 38.546878, 5.712926, 0.000000, 0.000045, 4.599997 },
	{ 27,  -160.955917, 37.347141, 7.042929, 0.000000, 0.000045, 4.599997 },
	{ 27,  -162.747436, 38.551319, 5.900618, 0.000000, 0.000045, 4.599997 },
	{ 27,  -162.940200, 40.496974, 6.156506, 0.000000, 0.000045, 4.599997 },
	{ 27,  -160.469894, 37.337627, 7.075955, 0.000000, 0.000045, 4.599997 },
	{ 27,  -160.711822, 42.151020, 7.306849, 0.000000, 0.000045, 4.599997 },
	{ 27,  -161.887130, 40.728527, 5.651482, 0.000000, 0.000045, 4.599997 },
	{ 28,  -149.065780, 34.832508, 5.712926, 0.000000, 0.000045, 4.599997 },
	{ 28,  -150.012496, 33.632770, 7.042929, 0.000000, 0.000045, 4.599997 },
	{ 28,  -151.804000, 34.836944, 5.900618, 0.000000, 0.000045, 4.599997 },
	{ 28,  -151.996765, 36.782588, 6.156506, 0.000000, 0.000045, 4.599997 },
	{ 28,  -149.526458, 33.623249, 7.075955, 0.000000, 0.000045, 4.599997 },
	{ 28,  -149.768402, 38.436641, 7.306849, 0.000000, 0.000045, 4.599997 },
	{ 28,  -150.943695, 37.014148, 5.651482, 0.000000, 0.000045, 4.599997 },
	{ 29,  -138.866699, 30.637027, 5.712926, 0.000000, 0.000053, 4.599997 },
	{ 29,  -139.813415, 29.437290, 7.042929, 0.000000, 0.000053, 4.599997 },
	{ 29,  -141.604919, 30.641464, 5.900618, 0.000000, 0.000053, 4.599997 },
	{ 29,  -141.797683, 32.587108, 6.156506, 0.000000, 0.000053, 4.599997 },
	{ 29,  -139.327377, 29.427761, 7.075955, 0.000000, 0.000053, 4.599997 },
	{ 29,  -139.569305, 34.241157, 7.306849, 0.000000, 0.000053, 4.599997 },
	{ 29,  -140.744613, 32.818660, 5.651482, 0.000000, 0.000053, 4.599997 },
	{ 30,  -235.098770, 52.137157, 5.712926, 0.000001, 0.000022, 4.599997 },
	{ 30,  -236.045471, 50.937419, 7.042929, 0.000001, 0.000022, 4.599997 },
	{ 30,  -237.836975, 52.141597, 5.900618, 0.000001, 0.000022, 4.599997 },
	{ 30,  -238.029739, 54.087238, 6.156506, 0.000001, 0.000022, 4.599997 },
	{ 30,  -235.559448, 50.927890, 7.075955, 0.000001, 0.000022, 4.599997 },
	{ 30,  -235.801361, 55.741291, 7.306849, 0.000001, 0.000022, 4.599997 },
	{ 30,  -236.976669, 54.318790, 5.651482, 0.000001, 0.000022, 4.599997 },
	{ 31,  -224.899688, 47.941677, 5.712926, 0.000001, 0.000030, 4.599997 },
	{ 31,  -225.846389, 46.741939, 7.042929, 0.000001, 0.000030, 4.599997 },
	{ 31,  -227.637893, 47.946109, 5.900618, 0.000001, 0.000030, 4.599997 },
	{ 31,  -227.830642, 49.891757, 6.156506, 0.000001, 0.000030, 4.599997 },
	{ 31,  -225.360351, 46.732410, 7.075955, 0.000001, 0.000030, 4.599997 },
	{ 31,  -225.602279, 51.545810, 7.306849, 0.000001, 0.000030, 4.599997 },
	{ 31,  -226.777587, 50.123310, 5.651482, 0.000001, 0.000030, 4.599997 },
	{ 32,  -214.945373, 43.927013, 5.712926, 0.000001, 0.000030, 4.599997 },
	{ 32,  -215.892059, 42.727268, 7.042929, 0.000001, 0.000030, 4.599997 },
	{ 32,  -217.683578, 43.931446, 5.900618, 0.000001, 0.000030, 4.599997 },
	{ 32,  -217.876342, 45.877094, 6.156506, 0.000001, 0.000030, 4.599997 },
	{ 32,  -215.406036, 42.717754, 7.075955, 0.000001, 0.000030, 4.599997 },
	{ 32,  -215.647964, 47.531147, 7.306849, 0.000001, 0.000030, 4.599997 },
	{ 32,  -216.823272, 46.108654, 5.651482, 0.000001, 0.000030, 4.599997 },
	{ 33,  -204.746292, 39.731533, 5.712926, 0.000001, 0.000038, 4.599997 },
	{ 33,  -205.692977, 38.531787, 7.042929, 0.000001, 0.000038, 4.599997 },
	{ 33,  -207.484497, 39.735965, 5.900618, 0.000001, 0.000038, 4.599997 },
	{ 33,  -207.677261, 41.681613, 6.156506, 0.000001, 0.000038, 4.599997 },
	{ 33,  -205.206954, 38.522266, 7.075955, 0.000001, 0.000038, 4.599997 },
	{ 33,  -205.448883, 43.335659, 7.306849, 0.000001, 0.000038, 4.599997 },
	{ 33,  -206.624191, 41.913166, 5.651482, 0.000001, 0.000038, 4.599997 },
	{ 34,  -194.335739, 36.405704, 5.712926, 0.000001, 0.000038, 4.599997 },
	{ 34,  -195.282455, 35.205966, 7.042929, 0.000001, 0.000038, 4.599997 },
	{ 34,  -197.073959, 36.410137, 5.900618, 0.000001, 0.000038, 4.599997 },
	{ 34,  -197.266708, 38.355792, 6.156506, 0.000001, 0.000038, 4.599997 },
	{ 34,  -194.796417, 35.196445, 7.075955, 0.000001, 0.000038, 4.599997 },
	{ 34,  -195.038345, 40.009838, 7.306849, 0.000001, 0.000038, 4.599997 },
	{ 34,  -196.213653, 38.587345, 5.651482, 0.000001, 0.000038, 4.599997 },
	{ 35,  -184.136657, 32.210224, 5.712926, 0.000001, 0.000045, 4.599997 },
	{ 35,  -185.083374, 31.010486, 7.042929, 0.000001, 0.000045, 4.599997 },
	{ 35,  -186.874877, 32.214656, 5.900618, 0.000001, 0.000045, 4.599997 },
	{ 35,  -187.067626, 34.160305, 6.156506, 0.000001, 0.000045, 4.599997 },
	{ 35,  -184.597335, 31.000965, 7.075955, 0.000001, 0.000045, 4.599997 },
	{ 35,  -184.839248, 35.814357, 7.306849, 0.000001, 0.000045, 4.599997 },
	{ 35,  -186.014556, 34.391864, 5.651482, 0.000001, 0.000045, 4.599997 },
	{ 36,  -173.268249, 29.302402, 5.712926, 0.000001, 0.000045, 4.599997 },
	{ 36,  -174.214950, 28.102664, 7.042929, 0.000001, 0.000045, 4.599997 },
	{ 36,  -176.006454, 29.306835, 5.900618, 0.000001, 0.000045, 4.599997 },
	{ 36,  -176.199218, 31.252490, 6.156506, 0.000001, 0.000045, 4.599997 },
	{ 36,  -173.728912, 28.093143, 7.075955, 0.000001, 0.000045, 4.599997 },
	{ 36,  -173.970840, 32.906536, 7.306849, 0.000001, 0.000045, 4.599997 },
	{ 36,  -175.146148, 31.484043, 5.651482, 0.000001, 0.000045, 4.599997 },
	{ 37,  -163.069168, 25.106914, 5.712926, 0.000001, 0.000053, 4.599997 },
	{ 37,  -164.015853, 23.907176, 7.042929, 0.000001, 0.000053, 4.599997 },
	{ 37,  -165.807373, 25.111354, 5.900618, 0.000001, 0.000053, 4.599997 },
	{ 37,  -166.000137, 27.057010, 6.156506, 0.000001, 0.000053, 4.599997 },
	{ 37,  -163.529830, 23.897663, 7.075955, 0.000001, 0.000053, 4.599997 },
	{ 37,  -163.771759, 28.711055, 7.306849, 0.000001, 0.000053, 4.599997 },
	{ 37,  -164.947067, 27.288562, 5.651482, 0.000001, 0.000053, 4.599997 },
	{ 38,  -152.125717, 21.392543, 5.712926, 0.000001, 0.000053, 4.599997 },
	{ 38,  -153.072433, 20.192806, 7.042929, 0.000001, 0.000053, 4.599997 },
	{ 38,  -154.863937, 21.396980, 5.900618, 0.000001, 0.000053, 4.599997 },
	{ 38,  -155.056701, 23.342624, 6.156506, 0.000001, 0.000053, 4.599997 },
	{ 38,  -152.586395, 20.183284, 7.075955, 0.000001, 0.000053, 4.599997 },
	{ 38,  -152.828338, 24.996677, 7.306849, 0.000001, 0.000053, 4.599997 },
	{ 38,  -154.003631, 23.574184, 5.651482, 0.000001, 0.000053, 4.599997 },
	{ 39,  -141.926635, 17.197063, 5.712926, 0.000001, 0.000060, 4.599997 },
	{ 39,  -142.873352, 15.997325, 7.042929, 0.000001, 0.000060, 4.599997 },
	{ 39,  -144.664855, 17.201499, 5.900618, 0.000001, 0.000060, 4.599997 },
	{ 39,  -144.857620, 19.147144, 6.156506, 0.000001, 0.000060, 4.599997 },
	{ 39,  -142.387313, 15.987796, 7.075955, 0.000001, 0.000060, 4.599997 },
	{ 39,  -142.629241, 20.801193, 7.306849, 0.000001, 0.000060, 4.599997 },
	{ 39,  -143.804550, 19.378696, 5.651482, 0.000001, 0.000060, 4.599997 },
	{ 40,  -241.184753, 42.125606, 5.712926, 0.000001, 0.000030, 0.899986 },
	{ 40,  -242.206909, 40.989463, 7.042929, 0.000001, 0.000030, 0.899986 },
	{ 40,  -243.916976, 42.306743, 5.900618, 0.000001, 0.000030, 0.899986 },
	{ 40,  -243.983764, 44.260768, 6.156506, 0.000001, 0.000030, 0.899986 },
	{ 40,  -241.722503, 40.948593, 7.075955, 0.000001, 0.000030, 0.899986 },
	{ 40,  -241.653305, 45.767570, 7.306849, 0.000001, 0.000030, 0.899986 },
	{ 40,  -242.917953, 44.423877, 5.651482, 0.000001, 0.000030, 0.899986 },
	{ 41,  -231.277679, 37.280700, 5.712926, 0.000001, 0.000038, 0.899986 },
	{ 41,  -232.299819, 36.144554, 7.042929, 0.000001, 0.000038, 0.899986 },
	{ 41,  -234.009887, 37.461826, 5.900618, 0.000001, 0.000038, 0.899986 },
	{ 41,  -234.076675, 39.415859, 6.156506, 0.000001, 0.000038, 0.899986 },
	{ 41,  -231.815414, 36.103679, 7.075955, 0.000001, 0.000038, 0.899986 },
	{ 41,  -231.746231, 40.922660, 7.306849, 0.000001, 0.000038, 0.899986 },
	{ 41,  -233.010879, 39.578971, 5.651482, 0.000001, 0.000038, 0.899986 },
	{ 42,  -221.603179, 32.632026, 5.712926, 0.000001, 0.000038, 0.899986 },
	{ 42,  -222.625320, 31.495872, 7.042929, 0.000001, 0.000038, 0.899986 },
	{ 42,  -224.335403, 32.813152, 5.900618, 0.000001, 0.000038, 0.899986 },
	{ 42,  -224.402206, 34.767185, 6.156506, 0.000001, 0.000038, 0.899986 },
	{ 42,  -222.140930, 31.455013, 7.075955, 0.000001, 0.000038, 0.899986 },
	{ 42,  -222.071731, 36.273986, 7.306849, 0.000001, 0.000038, 0.899986 },
	{ 42,  -223.336380, 34.930305, 5.651482, 0.000001, 0.000038, 0.899986 },
	{ 43,  -211.696121, 27.787117, 5.712926, 0.000001, 0.000045, 0.899986 },
	{ 43,  -212.718231, 26.650964, 7.042929, 0.000001, 0.000045, 0.899986 },
	{ 43,  -214.428329, 27.968242, 5.900618, 0.000001, 0.000045, 0.899986 },
	{ 43,  -214.495117, 29.922275, 6.156506, 0.000001, 0.000045, 0.899986 },
	{ 43,  -212.233856, 26.610097, 7.075955, 0.000001, 0.000045, 0.899986 },
	{ 43,  -212.164657, 31.429069, 7.306849, 0.000001, 0.000045, 0.899986 },
	{ 43,  -213.429306, 30.085388, 5.651482, 0.000001, 0.000045, 0.899986 },
	{ 44,  -201.521881, 23.796400, 5.712926, 0.000001, 0.000045, 0.899986 },
	{ 44,  -202.544052, 22.660257, 7.042929, 0.000001, 0.000045, 0.899986 },
	{ 44,  -204.254104, 23.977527, 5.900618, 0.000001, 0.000045, 0.899986 },
	{ 44,  -204.320892, 25.931568, 6.156506, 0.000001, 0.000045, 0.899986 },
	{ 44,  -202.059631, 22.619392, 7.075955, 0.000001, 0.000045, 0.899986 },
	{ 44,  -201.990447, 27.438364, 7.306849, 0.000001, 0.000045, 0.899986 },
	{ 44,  -203.255096, 26.094680, 5.651482, 0.000001, 0.000045, 0.899986 },
	{ 45,  -191.614807, 18.951492, 5.712926, 0.000001, 0.000053, 0.899986 },
	{ 45,  -192.636978, 17.815349, 7.042929, 0.000001, 0.000053, 0.899986 },
	{ 45,  -194.347030, 19.132621, 5.900618, 0.000001, 0.000053, 0.899986 },
	{ 45,  -194.413818, 21.086652, 6.156506, 0.000001, 0.000053, 0.899986 },
	{ 45,  -192.152557, 17.774482, 7.075955, 0.000001, 0.000053, 0.899986 },
	{ 45,  -192.083343, 22.593454, 7.306849, 0.000001, 0.000053, 0.899986 },
	{ 45,  -193.347991, 21.249773, 5.651482, 0.000001, 0.000053, 0.899986 },
	{ 46,  -180.956695, 15.348366, 5.712926, 0.000001, 0.000053, 0.899986 },
	{ 46,  -181.978836, 14.212223, 7.042929, 0.000001, 0.000053, 0.899986 },
	{ 46,  -183.688919, 15.529493, 5.900618, 0.000001, 0.000053, 0.899986 },
	{ 46,  -183.755706, 17.483533, 6.156506, 0.000001, 0.000053, 0.899986 },
	{ 46,  -181.494445, 14.171356, 7.075955, 0.000001, 0.000053, 0.899986 },
	{ 46,  -181.425247, 18.990327, 7.306849, 0.000001, 0.000053, 0.899986 },
	{ 46,  -182.689895, 17.646644, 5.651482, 0.000001, 0.000053, 0.899986 },
	{ 47,  -171.049621, 10.503451, 5.712926, 0.000001, 0.000060, 0.899986 },
	{ 47,  -172.071762, 9.367306, 7.042929, 0.000001, 0.000060, 0.899986 },
	{ 47,  -173.781829, 10.684586, 5.900618, 0.000001, 0.000060, 0.899986 },
	{ 47,  -173.848648, 12.638626, 6.156506, 0.000001, 0.000060, 0.899986 },
	{ 47,  -171.587356, 9.326448, 7.075955, 0.000001, 0.000060, 0.899986 },
	{ 47,  -171.518157, 14.145420, 7.306849, 0.000001, 0.000060, 0.899986 },
	{ 47,  -172.782806, 12.801737, 5.651482, 0.000001, 0.000060, 0.899986 },
	{ 48,  -160.368682, 6.090614, 5.712926, 0.000001, 0.000060, 0.899986 },
	{ 48,  -161.390853, 4.954471, 7.042929, 0.000001, 0.000060, 0.899986 },
	{ 48,  -163.100906, 6.271745, 5.900618, 0.000001, 0.000060, 0.899986 },
	{ 48,  -163.167724, 8.225774, 6.156506, 0.000001, 0.000060, 0.899986 },
	{ 48,  -160.906433, 4.913604, 7.075955, 0.000001, 0.000060, 0.899986 },
	{ 48,  -160.837249, 9.732577, 7.306849, 0.000001, 0.000060, 0.899986 },
	{ 48,  -162.101882, 8.388894, 5.651482, 0.000001, 0.000060, 0.899986 },
	{ 49,  -150.461593, 1.245706, 5.712926, 0.000001, 0.000068, 0.899986 },
	{ 49,  -151.483764, 0.109563, 7.042929, 0.000001, 0.000068, 0.899986 },
	{ 49,  -153.193832, 1.426838, 5.900618, 0.000001, 0.000068, 0.899986 },
	{ 49,  -153.260635, 3.380866, 6.156506, 0.000001, 0.000068, 0.899986 },
	{ 49,  -150.999359, 0.068689, 7.075955, 0.000001, 0.000068, 0.899986 },
	{ 49,  -150.930160, 4.887664, 7.306849, 0.000001, 0.000068, 0.899986 },
	{ 49,  -152.194824, 3.543978, 5.651482, 0.000001, 0.000068, 0.899986 },
	{ 50,  -245.105621, 28.911119, 5.712926, 0.000002, 0.000038, 0.899986 },
	{ 50,  -246.127777, 27.774974, 7.042929, 0.000002, 0.000038, 0.899986 },
	{ 50,  -247.837844, 29.092254, 5.900618, 0.000002, 0.000038, 0.899986 },
	{ 50,  -247.904647, 31.046279, 6.156506, 0.000002, 0.000038, 0.899986 },
	{ 50,  -245.643371, 27.734100, 7.075955, 0.000002, 0.000038, 0.899986 },
	{ 50,  -245.574172, 32.553081, 7.306849, 0.000002, 0.000038, 0.899986 },
	{ 50,  -246.838821, 31.209392, 5.651482, 0.000002, 0.000038, 0.899986 },
	{ 51,  -235.198547, 24.066211, 5.712926, 0.000002, 0.000045, 0.899986 },
	{ 51,  -236.220687, 22.930068, 7.042929, 0.000002, 0.000045, 0.899986 },
	{ 51,  -237.930770, 24.247339, 5.900618, 0.000002, 0.000045, 0.899986 },
	{ 51,  -237.997558, 26.201370, 6.156506, 0.000002, 0.000045, 0.899986 },
	{ 51,  -235.736297, 22.889192, 7.075955, 0.000002, 0.000045, 0.899986 },
	{ 51,  -235.667098, 27.708171, 7.306849, 0.000002, 0.000045, 0.899986 },
	{ 51,  -236.931747, 26.364482, 5.651482, 0.000002, 0.000045, 0.899986 },
	{ 52,  -225.524047, 19.417539, 5.712926, 0.000002, 0.000045, 0.899986 },
	{ 52,  -226.546188, 18.281387, 7.042929, 0.000002, 0.000045, 0.899986 },
	{ 52,  -228.256286, 19.598667, 5.900618, 0.000002, 0.000045, 0.899986 },
	{ 52,  -228.323074, 21.552698, 6.156506, 0.000002, 0.000045, 0.899986 },
	{ 52,  -226.061813, 18.240528, 7.075955, 0.000002, 0.000045, 0.899986 },
	{ 52,  -225.992614, 23.059499, 7.306849, 0.000002, 0.000045, 0.899986 },
	{ 52,  -227.257263, 21.715818, 5.651482, 0.000002, 0.000045, 0.899986 },
	{ 53,  -215.616989, 14.572631, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 53,  -216.639114, 13.436479, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 53,  -218.349197, 14.753757, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 53,  -218.416000, 16.707790, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 53,  -216.154724, 13.395612, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 53,  -216.085525, 18.214586, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 53,  -217.350173, 16.870903, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 54,  -205.442749, 10.581915, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 54,  -206.464920, 9.445772, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 54,  -208.174987, 10.763043, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 54,  -208.241760, 12.717082, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 54,  -205.980514, 9.404906, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 54,  -205.911315, 14.223878, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 54,  -207.175964, 12.880195, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 55,  -195.535675, 5.737008, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 55,  -196.557846, 4.600865, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 55,  -198.267898, 5.918136, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 55,  -198.334701, 7.872166, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 55,  -196.073425, 4.559998, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 55,  -196.004211, 9.378969, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 55,  -197.268875, 8.035286, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 56,  -184.877578, 2.133882, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 56,  -185.899719, 0.997738, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 56,  -187.609786, 2.315008, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 56,  -187.676574, 4.269048, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 56,  -185.415313, 0.956871, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 56,  -185.346115, 5.775843, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 56,  -186.610763, 4.432160, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 57,  -174.970489, -2.711033, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 57,  -175.992630, -3.847178, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 57,  -177.702713, -2.529899, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 57,  -177.769515, -0.575859, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 57,  -175.508239, -3.888036, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 57,  -175.439041, 0.930935, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 57,  -176.703689, -0.412747, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 58,  -164.289550, -7.123870, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 58,  -165.311721, -8.260013, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 58,  -167.021774, -6.942739, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 58,  -167.088592, -4.988710, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 58,  -164.827301, -8.300880, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 58,  -164.758132, -3.481907, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 58,  -166.022766, -4.825590, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 59,  -154.382476, -11.968778, 5.712926, 0.000002, 0.000076, 0.899986 },
	{ 59,  -155.404647, -13.104921, 7.042929, 0.000002, 0.000076, 0.899986 },
	{ 59,  -157.114700, -11.787647, 5.900618, 0.000002, 0.000076, 0.899986 },
	{ 59,  -157.181503, -9.833618, 6.156506, 0.000002, 0.000076, 0.899986 },
	{ 59,  -154.920227, -13.145795, 7.075955, 0.000002, 0.000076, 0.899986 },
	{ 59,  -154.851028, -8.326819, 7.306849, 0.000002, 0.000076, 0.899986 },
	{ 59,  -156.115692, -9.670505, 5.651482, 0.000002, 0.000076, 0.899986 },
	{ 60,  -249.705276, 15.429800, 5.712926, 0.000002, 0.000038, 0.899986 },
	{ 60,  -250.727432, 14.293657, 7.042929, 0.000002, 0.000038, 0.899986 },
	{ 60,  -252.437484, 15.610935, 5.900618, 0.000002, 0.000038, 0.899986 },
	{ 60,  -252.504287, 17.564966, 6.156506, 0.000002, 0.000038, 0.899986 },
	{ 60,  -250.243041, 14.252790, 7.075955, 0.000002, 0.000038, 0.899986 },
	{ 60,  -250.173812, 19.071769, 7.306849, 0.000002, 0.000038, 0.899986 },
	{ 60,  -251.438476, 17.728078, 5.651482, 0.000002, 0.000038, 0.899986 },
	{ 61,  -239.798202, 10.584896, 5.712926, 0.000002, 0.000045, 0.899986 },
	{ 61,  -240.820343, 9.448752, 7.042929, 0.000002, 0.000045, 0.899986 },
	{ 61,  -242.530395, 10.766022, 5.900618, 0.000002, 0.000045, 0.899986 },
	{ 61,  -242.597198, 12.720054, 6.156506, 0.000002, 0.000045, 0.899986 },
	{ 61,  -240.335937, 9.407877, 7.075955, 0.000002, 0.000045, 0.899986 },
	{ 61,  -240.266738, 14.226861, 7.306849, 0.000002, 0.000045, 0.899986 },
	{ 61,  -241.531402, 12.883167, 5.651482, 0.000002, 0.000045, 0.899986 },
	{ 62,  -230.123703, 5.936223, 5.712926, 0.000002, 0.000045, 0.899986 },
	{ 62,  -231.145843, 4.800071, 7.042929, 0.000002, 0.000045, 0.899986 },
	{ 62,  -232.855911, 6.117350, 5.900618, 0.000002, 0.000045, 0.899986 },
	{ 62,  -232.922729, 8.071382, 6.156506, 0.000002, 0.000045, 0.899986 },
	{ 62,  -230.661437, 4.759212, 7.075955, 0.000002, 0.000045, 0.899986 },
	{ 62,  -230.592239, 9.578185, 7.306849, 0.000002, 0.000045, 0.899986 },
	{ 62,  -231.856903, 8.234502, 5.651482, 0.000002, 0.000045, 0.899986 },
	{ 63,  -220.216644, 1.091315, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 63,  -221.238769, -0.044836, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 63,  -222.948837, 1.272442, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 63,  -223.015640, 3.226475, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 63,  -220.754379, -0.085702, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 63,  -220.685180, 4.733269, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 63,  -221.949829, 3.389587, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 64,  -210.042404, -2.899399, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 64,  -211.064559, -4.035542, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 64,  -212.774627, -2.718271, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 64,  -212.841415, -0.764232, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 64,  -210.580154, -4.076409, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 64,  -210.510971, 0.742562, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 64,  -211.775619, -0.601119, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 65,  -200.135330, -7.744307, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 65,  -201.157501, -8.880450, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 65,  -202.867553, -7.563179, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 65,  -202.934341, -5.609148, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 65,  -200.673080, -8.921317, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 65,  -200.603866, -4.102346, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 65,  -201.868515, -5.446028, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 66,  -189.477203, -11.347433, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 66,  -190.499359, -12.483577, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 66,  -192.209442, -11.166307, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 66,  -192.276229, -9.212267, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 66,  -190.014968, -12.524444, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 66,  -189.945770, -7.705472, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 66,  -191.210418, -9.049155, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 67,  -179.570144, -16.192350, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 67,  -180.592269, -17.328495, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 67,  -182.302352, -16.011215, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 67,  -182.369155, -14.057174, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 67,  -180.107879, -17.369352, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 67,  -180.038681, -12.550380, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 67,  -181.303329, -13.894062, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 68,  -168.889205, -20.605186, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 68,  -169.911361, -21.741329, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 68,  -171.621429, -20.424055, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 68,  -171.688232, -18.470026, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 68,  -169.426956, -21.782196, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 68,  -169.357772, -16.963222, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 68,  -170.622406, -18.306907, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 69,  -158.982116, -25.450094, 5.712926, 0.000002, 0.000076, 0.899986 },
	{ 69,  -160.004272, -26.586236, 7.042929, 0.000002, 0.000076, 0.899986 },
	{ 69,  -161.714355, -25.268962, 5.900618, 0.000002, 0.000076, 0.899986 },
	{ 69,  -161.781143, -23.314933, 6.156506, 0.000002, 0.000076, 0.899986 },
	{ 69,  -159.519882, -26.627111, 7.075955, 0.000002, 0.000076, 0.899986 },
	{ 69,  -159.450683, -21.808134, 7.306849, 0.000002, 0.000076, 0.899986 },
	{ 69,  -160.715332, -23.151821, 5.651482, 0.000002, 0.000076, 0.899986 },
	{ 70,  -253.626159, 2.215319, 5.712926, 0.000003, 0.000045, 0.899986 },
	{ 70,  -254.648300, 1.079175, 7.042929, 0.000003, 0.000045, 0.899986 },
	{ 70,  -256.358367, 2.396453, 5.900618, 0.000003, 0.000045, 0.899986 },
	{ 70,  -256.425170, 4.350479, 6.156506, 0.000003, 0.000045, 0.899986 },
	{ 70,  -254.163909, 1.038301, 7.075955, 0.000003, 0.000045, 0.899986 },
	{ 70,  -254.094680, 5.857280, 7.306849, 0.000003, 0.000045, 0.899986 },
	{ 70,  -255.359344, 4.513590, 5.651482, 0.000003, 0.000045, 0.899986 },
	{ 71,  -243.719085, -2.629588, 5.712926, 0.000003, 0.000053, 0.899986 },
	{ 71,  -244.741210, -3.765732, 7.042929, 0.000003, 0.000053, 0.899986 },
	{ 71,  -246.451278, -2.448462, 5.900618, 0.000003, 0.000053, 0.899986 },
	{ 71,  -246.518066, -0.494431, 6.156506, 0.000003, 0.000053, 0.899986 },
	{ 71,  -244.256820, -3.806606, 7.075955, 0.000003, 0.000053, 0.899986 },
	{ 71,  -244.187606, 1.012372, 7.306849, 0.000003, 0.000053, 0.899986 },
	{ 71,  -245.452270, -0.331317, 5.651482, 0.000003, 0.000053, 0.899986 },
	{ 72,  -234.044570, -7.278261, 5.712926, 0.000003, 0.000053, 0.899986 },
	{ 72,  -235.066711, -8.414413, 7.042929, 0.000003, 0.000053, 0.899986 },
	{ 72,  -236.776794, -7.097134, 5.900618, 0.000003, 0.000053, 0.899986 },
	{ 72,  -236.843597, -5.143102, 6.156506, 0.000003, 0.000053, 0.899986 },
	{ 72,  -234.582321, -8.455272, 7.075955, 0.000003, 0.000053, 0.899986 },
	{ 72,  -234.513122, -3.636300, 7.306849, 0.000003, 0.000053, 0.899986 },
	{ 72,  -235.777786, -4.979982, 5.651482, 0.000003, 0.000053, 0.899986 },
	{ 73,  -224.137512, -12.123167, 5.712926, 0.000003, 0.000060, 0.899986 },
	{ 73,  -225.159637, -13.259321, 7.042929, 0.000003, 0.000060, 0.899986 },
	{ 73,  -226.869705, -11.942041, 5.900618, 0.000003, 0.000060, 0.899986 },
	{ 73,  -226.936523, -9.988010, 6.156506, 0.000003, 0.000060, 0.899986 },
	{ 73,  -224.675247, -13.300188, 7.075955, 0.000003, 0.000060, 0.899986 },
	{ 73,  -224.606048, -8.481215, 7.306849, 0.000003, 0.000060, 0.899986 },
	{ 73,  -225.870697, -9.824897, 5.651482, 0.000003, 0.000060, 0.899986 },
	{ 74,  -213.963287, -16.113883, 5.712926, 0.000003, 0.000060, 0.899986 },
	{ 74,  -214.985427, -17.250026, 7.042929, 0.000003, 0.000060, 0.899986 },
	{ 74,  -216.695510, -15.932757, 5.900618, 0.000003, 0.000060, 0.899986 },
	{ 74,  -216.762283, -13.978717, 6.156506, 0.000003, 0.000060, 0.899986 },
	{ 74,  -214.501037, -17.290893, 7.075955, 0.000003, 0.000060, 0.899986 },
	{ 74,  -214.431838, -12.471922, 7.306849, 0.000003, 0.000060, 0.899986 },
	{ 74,  -215.696487, -13.815605, 5.651482, 0.000003, 0.000060, 0.899986 },
	{ 75,  -204.056198, -20.958791, 5.712926, 0.000003, 0.000068, 0.899986 },
	{ 75,  -205.078369, -22.094934, 7.042929, 0.000003, 0.000068, 0.899986 },
	{ 75,  -206.788421, -20.777664, 5.900618, 0.000003, 0.000068, 0.899986 },
	{ 75,  -206.855224, -18.823633, 6.156506, 0.000003, 0.000068, 0.899986 },
	{ 75,  -204.593948, -22.135803, 7.075955, 0.000003, 0.000068, 0.899986 },
	{ 75,  -204.524734, -17.316831, 7.306849, 0.000003, 0.000068, 0.899986 },
	{ 75,  -205.789382, -18.660512, 5.651482, 0.000003, 0.000068, 0.899986 },
	{ 76,  -193.398086, -24.561918, 5.712926, 0.000003, 0.000068, 0.899986 },
	{ 76,  -194.420242, -25.698062, 7.042929, 0.000003, 0.000068, 0.899986 },
	{ 76,  -196.130310, -24.380790, 5.900618, 0.000003, 0.000068, 0.899986 },
	{ 76,  -196.197113, -22.426752, 6.156506, 0.000003, 0.000068, 0.899986 },
	{ 76,  -193.935836, -25.738929, 7.075955, 0.000003, 0.000068, 0.899986 },
	{ 76,  -193.866638, -20.919958, 7.306849, 0.000003, 0.000068, 0.899986 },
	{ 76,  -195.131286, -22.263639, 5.651482, 0.000003, 0.000068, 0.899986 },
	{ 77,  -183.491012, -29.406833, 5.712926, 0.000003, 0.000076, 0.899986 },
	{ 77,  -184.513137, -30.542982, 7.042929, 0.000003, 0.000076, 0.899986 },
	{ 77,  -186.223236, -29.225698, 5.900618, 0.000003, 0.000076, 0.899986 },
	{ 77,  -186.290023, -27.271659, 6.156506, 0.000003, 0.000076, 0.899986 },
	{ 77,  -184.028762, -30.583841, 7.075955, 0.000003, 0.000076, 0.899986 },
	{ 77,  -183.959564, -25.764865, 7.306849, 0.000003, 0.000076, 0.899986 },
	{ 77,  -185.224212, -27.108549, 5.651482, 0.000003, 0.000076, 0.899986 },
	{ 78,  -172.810073, -33.819675, 5.712926, 0.000003, 0.000076, 0.899986 },
	{ 78,  -173.832229, -34.955814, 7.042929, 0.000003, 0.000076, 0.899986 },
	{ 78,  -175.542297, -33.638545, 5.900618, 0.000003, 0.000076, 0.899986 },
	{ 78,  -175.609100, -31.684516, 6.156506, 0.000003, 0.000076, 0.899986 },
	{ 78,  -173.347824, -34.996681, 7.075955, 0.000003, 0.000076, 0.899986 },
	{ 78,  -173.278656, -30.177707, 7.306849, 0.000003, 0.000076, 0.899986 },
	{ 78,  -174.543289, -31.521394, 5.651482, 0.000003, 0.000076, 0.899986 },
	{ 79,  -162.902999, -38.664581, 5.712926, 0.000003, 0.000083, 0.899986 },
	{ 79,  -163.925155, -39.800720, 7.042929, 0.000003, 0.000083, 0.899986 },
	{ 79,  -165.635223, -38.483444, 5.900618, 0.000003, 0.000083, 0.899986 },
	{ 79,  -165.702011, -36.529418, 6.156506, 0.000003, 0.000083, 0.899986 },
	{ 79,  -163.440750, -39.841594, 7.075955, 0.000003, 0.000083, 0.899986 },
	{ 79,  -163.371551, -35.022621, 7.306849, 0.000003, 0.000083, 0.899986 },
	{ 79,  -164.636199, -36.366306, 5.651482, 0.000003, 0.000083, 0.899986 },
	{ 80,  -257.584808, -7.924411, 5.712926, 0.000001, 0.000038, 0.899986 },
	{ 80,  -258.606964, -9.060554, 7.042929, 0.000001, 0.000038, 0.899986 },
	{ 80,  -260.317016, -7.743274, 5.900618, 0.000001, 0.000038, 0.899986 },
	{ 80,  -260.383819, -5.789249, 6.156506, 0.000001, 0.000038, 0.899986 },
	{ 80,  -258.122558, -9.101425, 7.075955, 0.000001, 0.000038, 0.899986 },
	{ 80,  -258.053344, -4.282447, 7.306849, 0.000001, 0.000038, 0.899986 },
	{ 80,  -259.317993, -5.626140, 5.651482, 0.000001, 0.000038, 0.899986 },
	{ 81,  -247.677734, -12.769317, 5.712926, 0.000001, 0.000045, 0.899986 },
	{ 81,  -248.699874, -13.905464, 7.042929, 0.000001, 0.000045, 0.899986 },
	{ 81,  -250.409942, -12.588191, 5.900618, 0.000001, 0.000045, 0.899986 },
	{ 81,  -250.476730, -10.634159, 6.156506, 0.000001, 0.000045, 0.899986 },
	{ 81,  -248.215469, -13.946338, 7.075955, 0.000001, 0.000045, 0.899986 },
	{ 81,  -248.146286, -9.127357, 7.306849, 0.000001, 0.000045, 0.899986 },
	{ 81,  -249.410934, -10.471046, 5.651482, 0.000001, 0.000045, 0.899986 },
	{ 82,  -238.003234, -17.417991, 5.712926, 0.000001, 0.000045, 0.899986 },
	{ 82,  -239.025375, -18.554145, 7.042929, 0.000001, 0.000045, 0.899986 },
	{ 82,  -240.735458, -17.236865, 5.900618, 0.000001, 0.000045, 0.899986 },
	{ 82,  -240.802261, -15.282833, 6.156506, 0.000001, 0.000045, 0.899986 },
	{ 82,  -238.540985, -18.595005, 7.075955, 0.000001, 0.000045, 0.899986 },
	{ 82,  -238.471786, -13.776031, 7.306849, 0.000001, 0.000045, 0.899986 },
	{ 82,  -239.736434, -15.119712, 5.651482, 0.000001, 0.000045, 0.899986 },
	{ 83,  -228.096176, -22.262901, 5.712926, 0.000001, 0.000053, 0.899986 },
	{ 83,  -229.118286, -23.399053, 7.042929, 0.000001, 0.000053, 0.899986 },
	{ 83,  -230.828384, -22.081775, 5.900618, 0.000001, 0.000053, 0.899986 },
	{ 83,  -230.895172, -20.127742, 6.156506, 0.000001, 0.000053, 0.899986 },
	{ 83,  -228.633911, -23.439920, 7.075955, 0.000001, 0.000053, 0.899986 },
	{ 83,  -228.564712, -18.620948, 7.306849, 0.000001, 0.000053, 0.899986 },
	{ 83,  -229.829360, -19.964630, 5.651482, 0.000001, 0.000053, 0.899986 },
	{ 84,  -217.921936, -26.253618, 5.712926, 0.000001, 0.000053, 0.899986 },
	{ 84,  -218.944107, -27.389760, 7.042929, 0.000001, 0.000053, 0.899986 },
	{ 84,  -220.654159, -26.072490, 5.900618, 0.000001, 0.000053, 0.899986 },
	{ 84,  -220.720947, -24.118450, 6.156506, 0.000001, 0.000053, 0.899986 },
	{ 84,  -218.459686, -27.430625, 7.075955, 0.000001, 0.000053, 0.899986 },
	{ 84,  -218.390502, -22.611654, 7.306849, 0.000001, 0.000053, 0.899986 },
	{ 84,  -219.655151, -23.955337, 5.651482, 0.000001, 0.000053, 0.899986 },
	{ 85,  -208.014862, -31.098526, 5.712926, 0.000001, 0.000060, 0.899986 },
	{ 85,  -209.037033, -32.234668, 7.042929, 0.000001, 0.000060, 0.899986 },
	{ 85,  -210.747085, -30.917396, 5.900618, 0.000001, 0.000060, 0.899986 },
	{ 85,  -210.813873, -28.963365, 6.156506, 0.000001, 0.000060, 0.899986 },
	{ 85,  -208.552612, -32.275535, 7.075955, 0.000001, 0.000060, 0.899986 },
	{ 85,  -208.483398, -27.456563, 7.306849, 0.000001, 0.000060, 0.899986 },
	{ 85,  -209.748046, -28.800245, 5.651482, 0.000001, 0.000060, 0.899986 },
	{ 86,  -197.356750, -34.701652, 5.712926, 0.000001, 0.000060, 0.899986 },
	{ 86,  -198.378890, -35.837795, 7.042929, 0.000001, 0.000060, 0.899986 },
	{ 86,  -200.088973, -34.520523, 5.900618, 0.000001, 0.000060, 0.899986 },
	{ 86,  -200.155761, -32.566482, 6.156506, 0.000001, 0.000060, 0.899986 },
	{ 86,  -197.894500, -35.878662, 7.075955, 0.000001, 0.000060, 0.899986 },
	{ 86,  -197.825302, -31.059690, 7.306849, 0.000001, 0.000060, 0.899986 },
	{ 86,  -199.089950, -32.403373, 5.651482, 0.000001, 0.000060, 0.899986 },
	{ 87,  -187.449676, -39.546566, 5.712926, 0.000001, 0.000068, 0.899986 },
	{ 87,  -188.471817, -40.682712, 7.042929, 0.000001, 0.000068, 0.899986 },
	{ 87,  -190.181884, -39.365432, 5.900618, 0.000001, 0.000068, 0.899986 },
	{ 87,  -190.248703, -37.411392, 6.156506, 0.000001, 0.000068, 0.899986 },
	{ 87,  -187.987411, -40.723571, 7.075955, 0.000001, 0.000068, 0.899986 },
	{ 87,  -187.918212, -35.904598, 7.306849, 0.000001, 0.000068, 0.899986 },
	{ 87,  -189.182861, -37.248279, 5.651482, 0.000001, 0.000068, 0.899986 },
	{ 88,  -176.768737, -43.959403, 5.712926, 0.000001, 0.000068, 0.899986 },
	{ 88,  -177.790908, -45.095546, 7.042929, 0.000001, 0.000068, 0.899986 },
	{ 88,  -179.500961, -43.778274, 5.900618, 0.000001, 0.000068, 0.899986 },
	{ 88,  -179.567779, -41.824241, 6.156506, 0.000001, 0.000068, 0.899986 },
	{ 88,  -177.306488, -45.136413, 7.075955, 0.000001, 0.000068, 0.899986 },
	{ 88,  -177.237304, -40.317440, 7.306849, 0.000001, 0.000068, 0.899986 },
	{ 88,  -178.501937, -41.661125, 5.651482, 0.000001, 0.000068, 0.899986 },
	{ 89,  -166.861648, -48.804309, 5.712926, 0.000001, 0.000076, 0.899986 },
	{ 89,  -167.883819, -49.940456, 7.042929, 0.000001, 0.000076, 0.899986 },
	{ 89,  -169.593887, -48.623180, 5.900618, 0.000001, 0.000076, 0.899986 },
	{ 89,  -169.660690, -46.669151, 6.156506, 0.000001, 0.000076, 0.899986 },
	{ 89,  -167.399414, -49.981330, 7.075955, 0.000001, 0.000076, 0.899986 },
	{ 89,  -167.330215, -45.162353, 7.306849, 0.000001, 0.000076, 0.899986 },
	{ 89,  -168.594879, -46.506038, 5.651482, 0.000001, 0.000076, 0.899986 },
	{ 90,  -261.505676, -21.138898, 5.712926, 0.000002, 0.000045, 0.899986 },
	{ 90,  -262.527832, -22.275043, 7.042929, 0.000002, 0.000045, 0.899986 },
	{ 90,  -264.237915, -20.957763, 5.900618, 0.000002, 0.000045, 0.899986 },
	{ 90,  -264.304687, -19.003738, 6.156506, 0.000002, 0.000045, 0.899986 },
	{ 90,  -262.043426, -22.315917, 7.075955, 0.000002, 0.000045, 0.899986 },
	{ 90,  -261.974243, -17.496936, 7.306849, 0.000002, 0.000045, 0.899986 },
	{ 90,  -263.238891, -18.840625, 5.651482, 0.000002, 0.000045, 0.899986 },
	{ 91,  -251.598602, -25.983806, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 91,  -252.620742, -27.119949, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 91,  -254.330825, -25.802679, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 91,  -254.397613, -23.848648, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 91,  -252.136352, -27.160825, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 91,  -252.067153, -22.341846, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 91,  -253.331802, -23.685535, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 92,  -241.924102, -30.632478, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 92,  -242.946243, -31.768630, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 92,  -244.656341, -30.451351, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 92,  -244.723129, -28.497320, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 92,  -242.461868, -31.809490, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 92,  -242.392669, -26.990518, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 92,  -243.657318, -28.334199, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 93,  -232.017044, -35.477386, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 93,  -233.039169, -36.613540, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 93,  -234.749252, -35.296260, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 93,  -234.816055, -33.342227, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 93,  -232.554779, -36.654403, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 93,  -232.485580, -31.835432, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 93,  -233.750228, -33.179115, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 94,  -221.842803, -39.468101, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 94,  -222.864974, -40.604248, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 94,  -224.575042, -39.286975, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 94,  -224.641815, -37.332935, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 94,  -222.380569, -40.645111, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 94,  -222.311370, -35.826141, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 94,  -223.576019, -37.169822, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 95,  -211.935729, -44.313011, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 95,  -212.957901, -45.449153, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 95,  -214.667953, -44.131881, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 95,  -214.734756, -42.177852, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 95,  -212.473480, -45.490020, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 95,  -212.404266, -40.671051, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 95,  -213.668930, -42.014732, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 96,  -201.277633, -47.916137, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 96,  -202.299774, -49.052280, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 96,  -204.009841, -47.735008, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 96,  -204.076629, -45.780967, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 96,  -201.815368, -49.093147, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 96,  -201.746170, -44.274173, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 96,  -203.010818, -45.617858, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 97,  -191.370544, -52.761051, 5.712926, 0.000002, 0.000076, 0.899986 },
	{ 97,  -192.392684, -53.897197, 7.042929, 0.000002, 0.000076, 0.899986 },
	{ 97,  -194.102767, -52.579917, 5.900618, 0.000002, 0.000076, 0.899986 },
	{ 97,  -194.169570, -50.625877, 6.156506, 0.000002, 0.000076, 0.899986 },
	{ 97,  -191.908294, -53.938053, 7.075955, 0.000002, 0.000076, 0.899986 },
	{ 97,  -191.839096, -49.119083, 7.306849, 0.000002, 0.000076, 0.899986 },
	{ 97,  -193.103744, -50.462764, 5.651482, 0.000002, 0.000076, 0.899986 },
	{ 98,  -180.689605, -57.173889, 5.712926, 0.000002, 0.000076, 0.899986 },
	{ 98,  -181.711776, -58.310031, 7.042929, 0.000002, 0.000076, 0.899986 },
	{ 98,  -183.421829, -56.992755, 5.900618, 0.000002, 0.000076, 0.899986 },
	{ 98,  -183.488647, -55.038726, 6.156506, 0.000002, 0.000076, 0.899986 },
	{ 98,  -181.227355, -58.350898, 7.075955, 0.000002, 0.000076, 0.899986 },
	{ 98,  -181.158187, -53.531925, 7.306849, 0.000002, 0.000076, 0.899986 },
	{ 98,  -182.422821, -54.875610, 5.651482, 0.000002, 0.000076, 0.899986 },
	{ 99,  -170.782531, -62.018798, 5.712926, 0.000002, 0.000083, 0.899986 },
	{ 99,  -171.804702, -63.154937, 7.042929, 0.000002, 0.000083, 0.899986 },
	{ 99,  -173.514755, -61.837665, 5.900618, 0.000002, 0.000083, 0.899986 },
	{ 99,  -173.581558, -59.883636, 6.156506, 0.000002, 0.000083, 0.899986 },
	{ 99,  -171.320281, -63.195816, 7.075955, 0.000002, 0.000083, 0.899986 },
	{ 99,  -171.251083, -58.376838, 7.306849, 0.000002, 0.000083, 0.899986 },
	{ 99,  -172.515747, -59.720523, 5.651482, 0.000002, 0.000083, 0.899986 },
	{ 100,  -266.105346, -34.620216, 5.712926, 0.000002, 0.000045, 0.899986 },
	{ 100,  -267.127502, -35.756362, 7.042929, 0.000002, 0.000045, 0.899986 },
	{ 100,  -268.837524, -34.439083, 5.900618, 0.000002, 0.000045, 0.899986 },
	{ 100,  -268.904357, -32.485054, 6.156506, 0.000002, 0.000045, 0.899986 },
	{ 100,  -266.643096, -35.797225, 7.075955, 0.000002, 0.000045, 0.899986 },
	{ 100,  -266.573852, -30.978248, 7.306849, 0.000002, 0.000045, 0.899986 },
	{ 100,  -267.838531, -32.321937, 5.651482, 0.000002, 0.000045, 0.899986 },
	{ 101,  -256.198242, -39.465122, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 101,  -257.220397, -40.601264, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 101,  -258.930450, -39.283996, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 101,  -258.997253, -37.329963, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 101,  -256.735992, -40.642139, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 101,  -256.666809, -35.823158, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 101,  -257.931457, -37.166851, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 102,  -246.523757, -44.113796, 5.712926, 0.000002, 0.000053, 0.899986 },
	{ 102,  -247.545898, -45.249946, 7.042929, 0.000002, 0.000053, 0.899986 },
	{ 102,  -249.255966, -43.932666, 5.900618, 0.000002, 0.000053, 0.899986 },
	{ 102,  -249.322784, -41.978637, 6.156506, 0.000002, 0.000053, 0.899986 },
	{ 102,  -247.061492, -45.290805, 7.075955, 0.000002, 0.000053, 0.899986 },
	{ 102,  -246.992294, -40.471832, 7.306849, 0.000002, 0.000053, 0.899986 },
	{ 102,  -248.256958, -41.815513, 5.651482, 0.000002, 0.000053, 0.899986 },
	{ 103,  -236.616699, -48.958702, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 103,  -237.638824, -50.094856, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 103,  -239.348892, -48.777576, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 103,  -239.415695, -46.823543, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 103,  -237.154434, -50.135719, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 103,  -237.085235, -45.316749, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 103,  -238.349884, -46.660430, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 104,  -226.442459, -52.949417, 5.712926, 0.000002, 0.000060, 0.899986 },
	{ 104,  -227.464614, -54.085559, 7.042929, 0.000002, 0.000060, 0.899986 },
	{ 104,  -229.174682, -52.768291, 5.900618, 0.000002, 0.000060, 0.899986 },
	{ 104,  -229.241470, -50.814250, 6.156506, 0.000002, 0.000060, 0.899986 },
	{ 104,  -226.980209, -54.126426, 7.075955, 0.000002, 0.000060, 0.899986 },
	{ 104,  -226.911026, -49.307456, 7.306849, 0.000002, 0.000060, 0.899986 },
	{ 104,  -228.175674, -50.651138, 5.651482, 0.000002, 0.000060, 0.899986 },
	{ 105,  -216.535385, -57.794326, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 105,  -217.557556, -58.930469, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 105,  -219.267608, -57.613197, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 105,  -219.334396, -55.659168, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 105,  -217.073135, -58.971336, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 105,  -217.003921, -54.152366, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 105,  -218.268569, -55.496047, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 106,  -205.877258, -61.397453, 5.712926, 0.000002, 0.000068, 0.899986 },
	{ 106,  -206.899414, -62.533596, 7.042929, 0.000002, 0.000068, 0.899986 },
	{ 106,  -208.609497, -61.216323, 5.900618, 0.000002, 0.000068, 0.899986 },
	{ 106,  -208.676284, -59.262287, 6.156506, 0.000002, 0.000068, 0.899986 },
	{ 106,  -206.415023, -62.574462, 7.075955, 0.000002, 0.000068, 0.899986 },
	{ 106,  -206.345825, -57.755493, 7.306849, 0.000002, 0.000068, 0.899986 },
	{ 106,  -207.610473, -59.099174, 5.651482, 0.000002, 0.000068, 0.899986 },
	{ 107,  -195.970199, -66.242370, 5.712926, 0.000002, 0.000076, 0.899986 },
	{ 107,  -196.992324, -67.378509, 7.042929, 0.000002, 0.000076, 0.899986 },
	{ 107,  -198.702407, -66.061233, 5.900618, 0.000002, 0.000076, 0.899986 },
	{ 107,  -198.769210, -64.107192, 6.156506, 0.000002, 0.000076, 0.899986 },
	{ 107,  -196.507934, -67.419372, 7.075955, 0.000002, 0.000076, 0.899986 },
	{ 107,  -196.438735, -62.600399, 7.306849, 0.000002, 0.000076, 0.899986 },
	{ 107,  -197.703384, -63.944080, 5.651482, 0.000002, 0.000076, 0.899986 },
	{ 108,  -185.289260, -70.655204, 5.712926, 0.000002, 0.000076, 0.899986 },
	{ 108,  -186.311416, -71.791351, 7.042929, 0.000002, 0.000076, 0.899986 },
	{ 108,  -188.021484, -70.474075, 5.900618, 0.000002, 0.000076, 0.899986 },
	{ 108,  -188.088287, -68.520042, 6.156506, 0.000002, 0.000076, 0.899986 },
	{ 108,  -185.827011, -71.832214, 7.075955, 0.000002, 0.000076, 0.899986 },
	{ 108,  -185.757827, -67.013244, 7.306849, 0.000002, 0.000076, 0.899986 },
	{ 108,  -187.022460, -68.356925, 5.651482, 0.000002, 0.000076, 0.899986 },
	{ 109,  -175.382171, -75.500114, 5.712926, 0.000002, 0.000083, 0.899986 },
	{ 109,  -176.404327, -76.636253, 7.042929, 0.000002, 0.000083, 0.899986 },
	{ 109,  -178.114410, -75.318984, 5.900618, 0.000002, 0.000083, 0.899986 },
	{ 109,  -178.181198, -73.364952, 6.156506, 0.000002, 0.000083, 0.899986 },
	{ 109,  -175.919937, -76.677131, 7.075955, 0.000002, 0.000083, 0.899986 },
	{ 109,  -175.850738, -71.858154, 7.306849, 0.000002, 0.000083, 0.899986 },
	{ 109,  -177.115386, -73.201843, 5.651482, 0.000002, 0.000083, 0.899986 },
	{ 110,  -270.026214, -47.834697, 5.712926, 0.000003, 0.000053, 0.899986 },
	{ 110,  -271.048339, -48.970844, 7.042929, 0.000003, 0.000053, 0.899986 },
	{ 110,  -272.758422, -47.653564, 5.900618, 0.000003, 0.000053, 0.899986 },
	{ 110,  -272.825225, -45.699539, 6.156506, 0.000003, 0.000053, 0.899986 },
	{ 110,  -270.563964, -49.011718, 7.075955, 0.000003, 0.000053, 0.899986 },
	{ 110,  -270.494750, -44.192737, 7.306849, 0.000003, 0.000053, 0.899986 },
	{ 110,  -271.759399, -45.536426, 5.651482, 0.000003, 0.000053, 0.899986 },
	{ 111,  -260.119140, -52.679607, 5.712926, 0.000003, 0.000060, 0.899986 },
	{ 111,  -261.141265, -53.815750, 7.042929, 0.000003, 0.000060, 0.899986 },
	{ 111,  -262.851318, -52.498481, 5.900618, 0.000003, 0.000060, 0.899986 },
	{ 111,  -262.918121, -50.544448, 6.156506, 0.000003, 0.000060, 0.899986 },
	{ 111,  -260.656860, -53.856624, 7.075955, 0.000003, 0.000060, 0.899986 },
	{ 111,  -260.587646, -49.037647, 7.306849, 0.000003, 0.000060, 0.899986 },
	{ 111,  -261.852325, -50.381336, 5.651482, 0.000003, 0.000060, 0.899986 },
	{ 112,  -250.444625, -57.328281, 5.712926, 0.000003, 0.000060, 0.899986 },
	{ 112,  -251.466766, -58.464431, 7.042929, 0.000003, 0.000060, 0.899986 },
	{ 112,  -253.176849, -57.147151, 5.900618, 0.000003, 0.000060, 0.899986 },
	{ 112,  -253.243652, -55.193122, 6.156506, 0.000003, 0.000060, 0.899986 },
	{ 112,  -250.982376, -58.505290, 7.075955, 0.000003, 0.000060, 0.899986 },
	{ 112,  -250.913177, -53.686317, 7.306849, 0.000003, 0.000060, 0.899986 },
	{ 112,  -252.177841, -55.029998, 5.651482, 0.000003, 0.000060, 0.899986 },
	{ 113,  -240.537567, -62.173187, 5.712926, 0.000003, 0.000068, 0.899986 },
	{ 113,  -241.559692, -63.309341, 7.042929, 0.000003, 0.000068, 0.899986 },
	{ 113,  -243.269760, -61.992057, 5.900618, 0.000003, 0.000068, 0.899986 },
	{ 113,  -243.336578, -60.038028, 6.156506, 0.000003, 0.000068, 0.899986 },
	{ 113,  -241.075302, -63.350204, 7.075955, 0.000003, 0.000068, 0.899986 },
	{ 113,  -241.006103, -58.531234, 7.306849, 0.000003, 0.000068, 0.899986 },
	{ 113,  -242.270751, -59.874916, 5.651482, 0.000003, 0.000068, 0.899986 },
	{ 114,  -230.363342, -66.163902, 5.712926, 0.000003, 0.000068, 0.899986 },
	{ 114,  -231.385482, -67.300048, 7.042929, 0.000003, 0.000068, 0.899986 },
	{ 114,  -233.095565, -65.982772, 5.900618, 0.000003, 0.000068, 0.899986 },
	{ 114,  -233.162338, -64.028732, 6.156506, 0.000003, 0.000068, 0.899986 },
	{ 114,  -230.901092, -67.340911, 7.075955, 0.000003, 0.000068, 0.899986 },
	{ 114,  -230.831893, -62.521942, 7.306849, 0.000003, 0.000068, 0.899986 },
	{ 114,  -232.096542, -63.865623, 5.651482, 0.000003, 0.000068, 0.899986 },
	{ 115,  -220.456253, -71.008811, 5.712926, 0.000003, 0.000076, 0.899986 },
	{ 115,  -221.478424, -72.144950, 7.042929, 0.000003, 0.000076, 0.899986 },
	{ 115,  -223.188476, -70.827682, 5.900618, 0.000003, 0.000076, 0.899986 },
	{ 115,  -223.255279, -68.873649, 6.156506, 0.000003, 0.000076, 0.899986 },
	{ 115,  -220.994003, -72.185821, 7.075955, 0.000003, 0.000076, 0.899986 },
	{ 115,  -220.924789, -67.366851, 7.306849, 0.000003, 0.000076, 0.899986 },
	{ 115,  -222.189437, -68.710533, 5.651482, 0.000003, 0.000076, 0.899986 },
	{ 116,  -209.798141, -74.611938, 5.712926, 0.000003, 0.000076, 0.899986 },
	{ 116,  -210.820297, -75.748077, 7.042929, 0.000003, 0.000076, 0.899986 },
	{ 116,  -212.530364, -74.430809, 5.900618, 0.000003, 0.000076, 0.899986 },
	{ 116,  -212.597167, -72.476768, 6.156506, 0.000003, 0.000076, 0.899986 },
	{ 116,  -210.335891, -75.788948, 7.075955, 0.000003, 0.000076, 0.899986 },
	{ 116,  -210.266693, -70.969978, 7.306849, 0.000003, 0.000076, 0.899986 },
	{ 116,  -211.531341, -72.313659, 5.651482, 0.000003, 0.000076, 0.899986 },
	{ 117,  -199.891067, -79.456848, 5.712926, 0.000003, 0.000083, 0.899986 },
	{ 117,  -200.913192, -80.593002, 7.042929, 0.000003, 0.000083, 0.899986 },
	{ 117,  -202.623291, -79.275718, 5.900618, 0.000003, 0.000083, 0.899986 },
	{ 117,  -202.690078, -77.321678, 6.156506, 0.000003, 0.000083, 0.899986 },
	{ 117,  -200.428817, -80.633857, 7.075955, 0.000003, 0.000083, 0.899986 },
	{ 117,  -200.359619, -75.814880, 7.306849, 0.000003, 0.000083, 0.899986 },
	{ 117,  -201.624267, -77.158569, 5.651482, 0.000003, 0.000083, 0.899986 },
	{ 118,  -189.210128, -83.869689, 5.712926, 0.000003, 0.000083, 0.899986 },
	{ 118,  -190.232284, -85.005828, 7.042929, 0.000003, 0.000083, 0.899986 },
	{ 118,  -191.942352, -83.688568, 5.900618, 0.000003, 0.000083, 0.899986 },
	{ 118,  -192.009155, -81.734535, 6.156506, 0.000003, 0.000083, 0.899986 },
	{ 118,  -189.747879, -85.046699, 7.075955, 0.000003, 0.000083, 0.899986 },
	{ 118,  -189.678710, -80.227722, 7.306849, 0.000003, 0.000083, 0.899986 },
	{ 118,  -190.943344, -81.571411, 5.651482, 0.000003, 0.000083, 0.899986 }
};

// modules
#include "modules/workshop/workshop.pwn"
//

enum TPList {
	tName[46],
	Float:tPos[3],
	tList
}
new TPLIST[MAX_TELEPORTS][TPList] = {
 	{""P"[POLICE]"W" Полиция LS", 				{1540.0491,-1676.1680,13.2146},0},
	{""P"[POLICE]"W" Полиция SF", 				{-1629.0847,726.1740,14.1306},0},
	{""P"[POLICE]"W" Полиция LV", 				{2285.9685,2420.4519,10.4922},0},
	{""P"[POLICE]"W" ФБР",						{-1978.8849,-1012.8095,32.1719},0},
	{""P"[ARMY]"W" Армия ЛВ", 				{308.7944,1896.6123,17.6406},0},
	{""P"[ARMY]"W" Армия СФ", 				{-1533.1841,488.2717,7.1797},0},
	{""P"[MAYOR]"W" Мэрия",				{1481.2506,-1739.8961,13.5469},0},
	{""P"[MAYOR]"W" Правительство",				{1136.0038,-2037.0396,69.0078},0},
	{""P"[MEDICS]"W" Больница ЛС", 			{1177.6864,-1323.2448,14.0830},0},
	{""P"[MEDICS]"W" Больница СФ", 			{-2666.6680,580.7857,14.4609},0},
	{""P"[MEDICS]"W" Больница ЛВ", 			{1641.8849,1833.5286,10.8508},0},
	{""P"[СМИ]"W" Радиоцентр ЛС", 			{1578.6501,-1326.6104,16.4844},0},
	{""P"[СМИ]"W" Радиоцентр СФ", 			{-2522.5120,-613.8146,132.5625},0},
	{""P"[CМИ]"W" Радиоцентр ЛВ", 			{2642.6973,1172.9144,10.8203},0},
	{""P"[MAFIA]"W" Итальянская мафия", 		{1450.4951,750.6007,11.0234},0},
	{""P"[MAFIA]"W" Японская мафия",			{2630.8684,1824.2241,11.0234},0},
	{""P"[MAFIA]"W" Русская мафия",			{943.2179,1732.5566,8.8516},0},
	{""P"[GANG]"W" The Ballas",				{1939.0865,-1120.5308,26.4909},0},
	{""P"[GANG]"W" Los Santos Vagos",				{2756.3188,-1180.4659,69.3984},0},
	{""P"[GANG]"W" Grove Street",		{2495.8179,-1679.6707,13.3391},0},
	{""P"[GANG]"W" Varrios Los Aztecas",		{1677.8265,-2117.4241,13.5469},0},
	{""P"[GANG]"W" The Rifa",				{2730.9592,-1952.6282,13.5394},0},
	{"Оружейный завод",			{2680.7827,-2405.3203,13.4907},1},
	{"Нефтезавод",				{273.7452,1417.4165,10.4462},1},
	{"Склад", {864.2950,-1245.7744,14.8895},1},
	{"Яблочный сад",			{-116.4320,-0.3284,3.1094},1},
	{"Рыбалка",					{-403.6830,-433.3349,16.2312},1},
	{"Лесопилка",				{-476.3983,-1572.0128,9.4845},1},
	{"Шахта",				{-1864.4569,-1636.4508,21.8669},1},
	{"Развозчики продуктов",	{1144.7769,1975.1379,10.8203},1},
	{"Развозчики топлива",		{-21.2761,-352.0749,5.4297},1},
	{"ЖД Los Santos", 			{1805.0404,-1908.3304,13.3983},2},
	{"ЖД San Fierro", 			{-1994.0475,100.2056,27.5391},2},
	{"ЖД Las-Venturas", 		{2827.3931,1255.9264,10.7685},2},
	{"Банк ЛС",					{1418.9523,-1699.3098,13.5469},3},
	{"Банк СФ",					{-2354.6326,493.4315,30.9022},3},
	{"Банк ЛВ",					{2577.5327,1322.0800,10.8203},3},
	{"Транспортная компания 1",	{-80.9743,-1128.4877,1.0781},4},
	{"Транспортная компания 2",	{-488.5891,-524.2830,25.5178},4},
	{"Транспортная компания 3",	{152.3726,-266.1065,1.5781},4},
	{"Загрузка Оружейный завод",{2653.8486,-2387.8660,13.6328},4},
	{"Загрузка Нефтезавод",		{253.3007,1396.0299,10.5859},4},
	{"Разгрузка Порт СФ",		{-1744.4447,149.4602,3.5496},4},
	{"Разгрузка Порт ЛС",		{2616.7119,-2226.7627,13.381},4},
	{"Разгрузка Оружейный завод",{2687.9753,-2480.1912,13.5008},4},
	{"Таксопарк ЛС",			{1072.7596,-1768.8920,13.3602},5},
	{"Таксопарк СФ",			{-2182.2236,291.4850,35.1291},5},
	{"Таксопарк ЛВ",			{2490.6318,1346.1738,10.8276},5},
	{"Гетто", 					{2201.2886,-1703.4170,13.5396},6},
	{"Форт карсон", 			{91.6006,1182.4490,21.1174},6},
	{"ЛС-СФ Шоссе",				{-110.4161,-1140.6246,1.6458},6},
	{"Казино",					{2163.6824,2160.8635,10.8203},6},
	{"Компьютерный клуб",		{1022.6423,-1129.9634,23.8705},6},
	{"Дуэли",					{2194.3650,-2278.3823,13.5469},6},
	{"Центр Развлечений",		{2221.6672,1837.3550,10.8203},6},
	{"Черный рынок",			{2310.7986,-1218.1053,24.0008},6},
	{"Военкомат",				{-316.6047,1060.1151,19.7422},6}
};
enum INTlist {
	iID,
	iName[70],
	Float:iEnterx,
	Float:iEntery,
	Float:iEnterz,
	Float:iEntera,
	Float:iExitx,
	Float:iExity,
	Float:iExitz
};
new edit_int[MAX_PLAYERS];
new bool:Fishing[MAX_PLAYERS],
	fish_zone[3],
	Float:fish_place[3][4] = {
		{-310.00006103515625, -505.0000762939453, -200.00006103515625, -415.0000762939453},
		{-350.00006103515625, -640.0000610351562, -240.00006103515625, -540.0000610351562},
		{-246.00006103515625, -763.0000610351562, -136.00006103515625, -673.0000610351562}
	},
	FishName[8][22] = {
		"Карп",
		"Карась",
		"Щука",
		"Красноперка",
		"Окунь",
		"Тунец",
		"Лещ",
		"Язь"
	},
	Float:fish_sklad,
	Text3D:fish_text;

new Float:HospitalSpawns[12][4] = {
	{1561.8345,496.7100,1070.4226,359.1996}, // spawn 1
	{1564.4565,496.6277,1070.4226,357.2962}, // spawn 2
	{1567.0247,496.6094,1070.4226,1.0329}, // spawn 3
	{1559.8263,508.7991,1070.4226,178.6712}, // spawn 4
	{1562.3278,508.4033,1070.4226,179.9247}, // spawn 5
	{1564.7817,508.7976,1070.4226,180.5748}, // spawn 6
	{1546.6906,508.6857,1070.4226,180.2381}, // spawn 7
	{1544.1390,508.6756,1070.4226,180.2147}, // spawn 8
	{1541.6169,508.6804,1070.4226,180.1914}, // spawn 9
	{1548.8851,496.6806,1070.4226,1.2764}, // spawn 10
	{1546.3250,496.6836,1070.4226,1.9031}, // spawn 11
	{1543.7367,496.6739,1070.4226,359.0831} // spawn 12
};

new Float:HospitalArmSpawns[4][4] = {
	{309.4100,2067.1343,1014.3731,274.7489},
	{309.4100,2067.1343,1014.3731,274.7489},
	{312.5431,2063.4282,1014.3731,177.6381},
	{310.5005,2054.7236,1014.3731,358.0731}
};

new Float:PoliceSpawn[10][4] = {
	{1366.2506,1061.8446,1626.4896,265.4858},
	{1366.5651,1060.1194,1626.4896,270.1859},
	{1366.8134,1061.0466,1626.4896,267.3658},
	{1364.9451,1059.8419,1626.4896,270.4759},
	{1365.0205,1061.1891,1626.4896,265.1491},
	{1366.5056,1056.0862,1626.4896,268.5959},
	{1366.4434,1057.2314,1626.4896,269.2226},
	{1366.6952,1058.2623,1626.4896,268.2826},
	{1364.8705,1056.2211,1626.4896,268.2592},
	{1364.8931,1057.9684,1626.4896,266.0659}
};

new FirstFire[MAX_PLAYERS],
	SecondFire[MAX_PLAYERS];


enum BINT_DATA {
	bintID,
	bintInterior,
	Float:bintX,
	Float:bintY,
	Float:bintZ,
	Float:bintR,
	Float:bintXB,
	Float:bintYB,
	Float:bintZB,
	bintName[32]
}

enum BUSINESS_DATA {
	bizzID,
	bizzName[64],
	bizzType,
	bizzBint,
	bizzOwnerID,
	bizzSellPrice,
	bizzBank,
	bizzBankDay,
	bizzPrice,
	bizzEnter,
	bizzProduct,
	bizzProdOrder,
	bizzProdOrderPrice,
	bizzStatus,
	Float:bizzX,
	Float:bizzY,
	Float:bizzZ,
	Float:bizzR,
	bizzDay,
	bizzMafia,
	bizzOwner[48],
	bizzVisitors,
	bizzUpgrade[3]
}

//Бизнесы
new gBints[BINT_COUNT][BINT_DATA],
	gBintEnterArea[BINT_COUNT],
	gBintBuyArea[BINT_COUNT],
	gBusiness[MAX_BUSINESS_COUNT][BUSINESS_DATA],
	b_area[MAX_BUSINESS_COUNT],
	Text3D: gBusinessText[MAX_BUSINESS_COUNT],
	gBusinessIcon[MAX_BUSINESS_COUNT],
	gBusinessTypeName[BUSINESS_TYPE_COUNT][28] = {"Закусочная","24/7","Бар","Клуб","Магазин одежды","АММО","АЗС","Автосалон","Рыболовный бизнес","Компьютерный клуб","Таксопарк","Риэлторское агенство","Спортзал","Транспортная компания","Банк","Рекламное агенство","Магазин Аксессуаров","Perfomance Tune"},
	gBusinessCount,
	gBarCosts[] = {5, 10, 13, 16, 24, 31},
	gCompCosts[] = {100, 150, 230, 260},
	gTavernNames[][] = {{"Салат"}, {"Наггетсы"}, {"Бургер"}, {"Пицца"}},
	gTavernCosts[] = {5, 10, 13, 25},
	gShopProduct[SHOP_OBJECTS] = {66,84,24,72,38,28,16,12,25,30,25,100},
	gShopPrice[SHOP_OBJECTS] = 	 {660,840,240,720,380,280,90,120,250,300,250,300000},
	gShopObject[SHOP_OBJECTS][24] = {"Телефон","Камера","Часы","Телефонная книга","SIM-карта","Маска","Аптечка","Цветы","Ремкомплект","Балончик с краской","Отмычки", "Бумбокс"},
	gFishCosts[] = {520, 340, 100, 400};
//лрпата, бита, катана, кастет, газ балон, парашут
new stock gSellGun [15] = { 6, 5, 8, 1, 17, 46, 23, 24, 25, 29, 30, 31, 33 };
new stock gSellGunPrice [15] = { 50, 100, 100, 100, 300, 1000, 16, 27, 32, 14, 27, 27, 1000 , 500 };
new stock gSellGunProds [15] = { 10, 10, 10, 10, 15, 20, 3, 4, 5, 3, 4, 4, 70, 50 };

new type_acces[MAX_PLAYERS];

new acces_name_all[][] = {
	{""P"1."W" Очки"},
	{""P"2."W" Шапки"},
	{""P"3."W" Шляпы"},
	{""P"4."W" Кепки"},
	{""P"5."W" Береты"},
	{""P"6."W" Банданы"},
	{""P"7."W" Панамки"},
	{""P"8."W" Спорт-шлем"},
	{""P"9."W" Каски"},
	{""P"10."W" Маски"},
	{""P"11."W" Наушники"},
	{""P"12."W" Часы"},
	{""P"13."W" Рюкзаки"}
	//{""P"14."W" Разное"}
};
//очки
new acces_id_glass[][] = {
	{19035,2500},
	{19034,2500},
	{19033,2500},
	{19032,2500},
	{19031,2500},
	{19030,2500},
	{19029,2500},
	{19028,2500},
	{19027,2500},
	{19026,2500},
	{19025,2500},
	{19024,2500},
	{19023,2500},
	{19022,2500},
	{19021,2500},
	{19020,2500},
	{19019,2500},
	{19018,2500},
	{19017,2500},
	{19016,2500},
	{19015,2500},
	{19014,2500},
	{19013,2500},
	{19012,2500},
	{19011,2500},
	{19010,2500},
	{19009,2500},
	{19008,2500},
	{19007,2500},
	{19006,2500}
};
//шапки
new acces_id_hat[][] = {
	{19069,5000},
	{19067,5000},
	{19068,6000},
	{18953,8000},
	{18954,10000},
	{19554,13000}
};
//шляпы
new acces_id_bonnet[][] = {
	{18947,10000},
	{18948,10000},
	{18949,10000},
	{18950,10000},
	{18951,10000}
};
//кепки
new acces_id_cap[][] = {
	{18933,3000},
	{18932,3000},
	{18928,4000},
	{18942,5000},
	{18943,6000},
	{18940,6000},
	{18929,7000},
	{18926,7000},
	{18955,7000},
	{18956,7000},
	{18957,7000},
	{18959,7000}
};
//береты
new acces_id_beret[][] = {
	{18924,3000},
	{18925,3000},
	{18921,3000},
	{18923,3000},
	{18922,3000}
};
//банданы
new acces_id_bandanas[][] = {
	{18906,4000},
	{18906,4000},
	{18906,4000},
	{18906,4000},
	{18910,4000},
	{18911,4000},
	{18912,4000},
	{18913,4000},
	{18914,4000},
	{18915,4000},
	{18916,4000},
	{18917,4000},
	{18918,4000},
	{18919,4000}
};
//панамки
new acces_id_panam[][] = {
	{18968,4000},
	{18967,4000},
	{18969,4000}
};
//спорт шлем
new acces_id_sporthat[][] = {
	{18976,15000},
	{18977,20000},
	{18978,20000},
	{18979,20000},
	{18645,20000}
};
//каски
new acces_id_kask[][] = {
	{19101,5000},
	{19102,5000},
	{19103,5000},
	{19104,5000},
	{19105,5000},
	{19106,7000},
	{19107,7000},
	{19108,7000},
	{19109,7000},
	{19110,7000},
	{19111,7000},
	{19112,7000},
	{19113,7000},
	{19114,7000},
	{19115,7000},
	{19116,7000},
	{19117,7000},
	{19118,7000},
	{19119,7000},
	{19120,7000}
};
//маски
new acces_id_mask[][] = {
	{19036,8000},
	{19037,8000},
	{19038,8000}
};
//наушники
new acces_id_headphones[][] = {
	{19421,6000},
	{19422,6000},
	{19423,6000},
	{19424,6000}
};
//часы
new acces_id_watch[][] = {
	{19042,7000},
	{19041,7000},
	{19040,7000},
	{19039,7000},
	{19043,7000},
	{19044,10000},
	{19045,10000},
	{19046,10000},
	{19048,10000},
	{19049,15000},
	{19050,15000},
	{19051,15000},
	{19053,15000}
};
//рюкзаки
new acces_id_backpack[][] = {
	{3026,4000},
	{371,8000},
	{19559,15000}
};

new Float:pickup_game_dm[][14] = {
	{-1131.3823,1057.6615,1346.4155},
	{-1101.3960,1019.7981,1342.0938},
	{-1054.7520,1061.1354,1341.3516},
	{-1008.6476,1022.1013,1341.0078},
	{-975.6393,1089.7686,1344.9706},
	{-973.3884,1024.7118,1345.0496},
	{-1131.5729,1029.1079,1345.7302},
	{-1090.5127,1047.7528,1343.7136},
	{-1057.1874,1024.8693,1343.5397},
	{-1010.1868,1082.6458,1341.0432},
	{-974.7061,1061.1276,1345.6770},
	{-1132.5320,1095.6166,1345.7961}
};
new pickups_game_dm[14];
new Float:spawns_pos_game[][19] = {
	{-971.9037,1088.3547,1344.9967,129.8470},
	{-972.0953,1073.0126,1345.0067,176.5341},
	{-969.6308,1048.2323,1345.0522,178.4141},
	{-979.3818,1024.2477,1345.0090,109.4801},
	{-1010.3306,1031.4248,1341.0078,86.6066},
	{-1026.0189,1030.3739,1342.3063,86.6066},
	{-1032.7190,1063.5831,1344.2081,2.0058},
	{-1025.6360,1076.7162,1347.0292,308.7386},
	{-1018.4744,1097.9198,1342.2784,347.9056},
	{-1002.1757,1097.6473,1342.7841,271.4515},
	{-1133.9045,1096.3629,1345.8059,82.8970},
	{-1136.0276,1021.7136,1345.7485,155.5910},
	{-1067.0563,1019.8869,1343.1606,236.1185},
	{-1114.4014,1098.4094,1341.8438,65.3736},
	{-1027.1936,1050.3809,1342.3127,323.8293},
	{-972.6334,1097.3291,1344.9896,278.7089},
	{-1046.6215,1065.1182,1344.2026,287.5548},
	{-1090.9199,1062.1122,1341.3516,341.3527},
	{-1132.3114,1062.6431,1345.7616,249.7135}
};
new Float:spawns_pos_game_end[][6] ={
	{829.7211,0.6873,1004.1797,41.4414},
	{832.6205,1.1667,1004.1797,37.3680},
	{832.2601,10.5252,1004.1797,133.5622},
	{829.1796,10.6138,1004.1797,162.7025},
	{826.5115,0.0795,1004.1797,353.5243},
	{828.8213,2.8872,1004.1797,36.1380}
};
new game_info[][] = {
	{""W"Сумасшедшие войны, в данном мероприятии каждый участник - сам за себя.\n"},
	{"Минимальный взнос для участия в мероприятии составляет "ORANGE"$1000$"W".\n"},
	{"Максимальный взнос для участия в мероприятии составляет "ORANGE"$10000$"W".\n\n"},
	{"Доступные виды оружия: \n\t"P"9mm Pistol, Silenced Pistol, Desert Eagle, Shotgun\n"},
	{"\tMP5, AK - 47, M4, Country Rifle, Sniper Rifle\n"},
	{""W"Оружие выдается рандомно после гибели Игрока.\n\n"},
	{""G"Призовой фонд составляет:\n\n"},
	{"\t"ORANGE"1 место - 50% от бюджета мероприятия\n"},
	{"\t2 место - 30% от бюджета мероприятия\n"},
	{"\t3 место - 20% от бюджета мероприятия\n"}
};

new golod_info[][] = {
	{""W"Голодные игры, суть данного мероприятия - остаться в живых.\n"},
	{"Минимальный взнос для участия в мероприятии составляет "ORANGE"$1000$"W".\n"},
	{"Максимальный взнос для участия в мероприятии составляет "ORANGE"$10000$"W".\n\n"},
	{"Доступные виды оружия: \n\t"P"9mm Pistol, Silenced Pistol, Desert Eagle, Shotgun\n"},
	{"\tMP5, AK - 47, M4, Country Rifle, Sniper Rifle\n"},
	{""W"Оружие же можно добыть, подобрав его после приземления воздушной посылки.\n\n"},
	{""G"Призовой фонд составляет:\n\n"},
	{"\t"ORANGE"1 место - 100% от бюджета мероприятия\n"}
};

new Float:spawns_pos_golod[][21] = {
	{511.1205,3411.7109,1.7684,99.0891}, // 1
	{509.9627,3396.8550,1.7684,72.1423}, // 2
	{504.6795,3382.9170,1.7684,57.1023}, // 3
	{495.4037,3371.1836,1.7684,33.2888}, // 4
	{482.9640,3362.9731,1.7684,18.5619}, // 5
	{468.7217,3358.4131,1.7684,9.7884}, // 6
	{453.8185,3358.3726,1.7684,359.4482}, // 7
	{439.4697,3362.7666,1.7684,334.0680}, // 8
	{426.9885,3371.1084,1.7684,315.2679}, // 9
	{417.8222,3382.8037,1.7684,291.1411}, // 10
	{412.2269,3396.7642,1.7684,283.3079}, // 11
	{411.1539,3411.7212,1.7684,273.5945}, // 12
	{414.4911,3426.2949,1.7684,247.2741}, // 13
	{421.9019,3439.3760,1.7684,229.4139}, // 14
	{433.0515,3449.2075,1.7684,217.5071}, // 15
	{446.3200,3455.8037,1.7684,202.7803}, // 16
	{461.1968,3458.0762,1.7684,194.9469}, // 17
	{475.9952,3455.8101,1.7684,177.0867}, // 18
	{489.4095,3449.4893,1.7684,159.5399}, // 19
	{500.4183,3439.2100,1.7684,133.8463}, // 20
	{507.6727,3426.1934,1.7684,103.4528} // 21
};
new Float:pickup_game_golod[][21] = {
	{477.4199,3420.0537,2.5208}, // сумка 1
	{483.0627,3407.4302,2.5208}, // сумка 2
	{485.4454,3397.5142,2.5208}, // сумка 3
	{484.5856,3392.6943,2.5208}, // сумка 4
	{481.7088,3391.8286,2.5208}, // сумка 5
	{478.2400,3390.9438,2.5208}, // сумка 6
	{463.9134,3387.8848,2.5208}, // сумка 7
	{451.6201,3385.4824,2.5208}, // сумка 8
	{448.5182,3388.5239,2.5208}, // сумка 9
	{448.0757,3391.3525,2.5208}, // сумка 10
	{447.4832,3394.5737,2.5208}, // сумка 11
	{446.5945,3401.0376,2.5208}, // сумка 12
	{444.3455,3413.2827,2.5208}, // сумка 13
	{442.8724,3418.9351,2.5208}, // сумка 14
	{445.3425,3423.0034,2.5208}, // сумка 15
	{448.0399,3423.3066,2.5208}, // сумка 16
	{451.7747,3424.2412,2.5208}, // сумка 17
	{466.9659,3427.0801,2.5208}, // сумка 18
	{476.5350,3428.8726,2.5208}, // сумка 19
	{481.1384,3426.8359,2.5208}, // сумка 20
	{481.2592,3423.7212,2.5208} // сумка 21
};
new pickups_game_golod[21] = -1;

new Float:pickup_game_golod_2[][21] = {
	{583.48,3429.419,7.0},
	{563.262,3481.784,13.5},
	{521.769,3504.372,9.0},
	{574.850,3373.640,13.5},
	{426.755,3497.690,12.0},
	{480.709,3288.237,9.963},
	{384.965,3510.70,11.958},
	{347.324,3369.504,11.3},
	{376.239,3316.323,12.3},
	{528.836,3595.626,49.0},
	{329.494,3417.427,17.2},
	{605.253,3251.989,47.0},
	{672.387,3300.246,63.0},
	{306.292,3520.320,48.9},
	{543.147,3205.829,50.8},
	{328.103,3560.866,45.7},
	{275.63,3453.482,45.4},
	{467.36,3657.813,43.4},
	{409.763,3658.840,68.9},
	{371.728,3185.230,71.1},
	{240.421,3495.499,76.3}
};
new Float:pickup_game_objmoved[][21] = {
	{583.48,3429.419,14.667,4.0},
	{563.262,3481.784,20.909,4.0},
	{521.769,3504.372,16.520,4.0},
	{574.850,3373.640,20.903,4.0},
	{426.755,3497.690,19.446,4.0},
	{480.709,3288.237,17.363,4.0},
	{384.965,3510.70,19.258,4.0},
	{347.324,3369.504,18.869,4.0},
	{376.239,3316.323,19.763,4.0},
	{528.836,3595.626,56.527,4.0},
	{329.494,3417.427,24.715,4.0},
	{605.253,3251.989,54.549,4.0},
	{672.387,3300.246,70.55,4.0},
	{306.292,3520.320,56.196,4.0},
	{543.147,3205.829,58.158,4.0},
	{328.103,3560.866,53.172,4.0},
	{275.63,3453.482,51.841,4.0},
	{467.36,3657.813,50.704,4.0},
	{409.763,3658.840,76.13,4.0},
	{371.728,3185.230,78.460,4.0},
	{240.421,3495.499,83.751,4.0}
};
new game_players[3];
new pickups_game_golod_2[21] = -1;
new area_golod[21];
new time_gamegolod = 0;
new player_to_golod[MAX_PLAYERS];
new open_gamegolod = 0;
new players_in_golod = 0;
new player_to_golod_id[MAX_PLAYERS];
new golod_use_pickup[MAX_PLAYERS];
new money_in_golod = 0;
new golod_start = 0;
new time_golod;
new Float:pickup_game_obj[][21] = {
	{607.48,3369.419,62.667,4.000,13.000,-32.860},
	{587.262,3421.784,68.909,0.000,0.000,0.000},
	{545.769,3444.372,64.520,11.000,0.000,0.000},
	{598.850,3313.640,68.903,0.000,0.000,-90.120},
	{450.755,3437.690,67.446,10.000,0.000,13.380},
	{504.709,3228.237,65.363,10.000,3.000,129.311},
	{408.965,3450.70,67.258,10.000,0.000,0.000},
	{371.324,3309.504,66.869,10.000,3.000,166.391},
	{400.239,3256.323,67.763,10.000,3.000,129.312},
	{552.836,3535.626,104.527,18.000,0.000,-16.000},
	{353.494,3357.427,72.715,10.000,3.000,0.079},
	{629.253,3191.989,102.549,0.000,0.000,48.720},
	{696.387,3240.246,118.55,-7.000,-10.000,2.000},
	{330.292,3460.320,104.196,20.000,0.000,17.000},
	{567.147,3145.829,106.158,0.000,0.000,0.000},
	{352.103,3500.866,101.172,15.000,0.000,53.000},
	{299.63,3393.482,100.841,11.000,0.000,69.480},
	{491.36,3597.813,98.704,-19.000,0.000,-69.419},
	{433.763,3598.840,124.13,0.000,0.000,0.000},
	{395.728,3125.230,126.460,-19.000,0.000,-2.000},
	{264.421,3435.499,131.751,-30.000,0.000,-67.000}
};

new random_car_race_lv = INVALID_VEHICLE_ID;
new car_id_race_lv[] ={495,502,506,559,560,562,568,587,603,451,411};

new open_race_lv = 0; // если 0 - рега закрыта, 1 - открыта
new time_registr_race_lv; // время на регистрацию
new players_in_race_lv; // количество игроков зарегалось
new money_in_race_lv; // бюджет регистрации
new time_race_lv; // игра началась или нет
new race_lv_start = 0;
new player_to_race_lv[MAX_PLAYERS];
new player_to_race_lv_id[MAX_PLAYERS];
new player_car_race_lv_id[MAX_PLAYERS] = INVALID_VEHICLE_ID;
new race_lead_lv = 0;
new race_type = 0;


new Float:gRaceCPs[3][49][4] = {
	{// город
		{0.0,-1593.1674,995.8550,6.7661},
		{0.0,-1559.2784,713.1943,6.7661},
		{0.0,-1731.9357,321.2237,6.7583},
		{0.0,-1760.4103,325.8777,7.1245},
		{0.0,-1820.8859,380.7706,16.7357},
		{0.0,-1848.5409,365.2331,17.4409},
		{0.0,-1897.2014,95.6595,37.8657},
		{0.0,-1910.8467,-262.3996,37.9693},
		{0.0,-1910.7738,-577.5660,37.9615},
		{0.0,-1910.9318,-963.2586,42.4246},
		{0.0,-1907.5707,-1217.4100,39.2115},
		{0.0,-1911.0490,-1354.6622,40.1021},
		{0.0,-1956.8323,-1341.4967,40.1605},
		{0.0,-2093.4607,-1124.2417,30.1528},
		{0.0,-2219.6184,-921.2327,43.4467},
		{0.0,-2221.3218,-747.5360,63.7629},
		{0.0,-2349.4438,-724.1194,105.8035},
		{0.0,-2422.8469,-609.0765,132.2896},
		{0.0,-2506.4609,-482.6401,91.8960},
		{0.0,-2623.9351,-500.7565,70.6256},
		{0.0,-2489.5293,-443.8438,77.3281},
		{0.0,-2353.6812,-459.1245,79.9845},
		{0.0,-2336.3044,-421.2580,79.2547},
		{0.0,-2443.2471,-368.6861,70.0947},
		{0.0,-2675.7188,-425.3551,31.5907},
		{0.0,-2681.5325,-523.8073,16.5806},
		{0.0,-2774.8213,-495.3371,6.9114},
		{0.0,-2734.9756,-431.2374,6.9789},
		{0.0,-2557.7732,-345.0942,24.4528},
		{0.0,-2272.2705,-347.4919,39.2546},
		{0.0,-2075.9956,-350.9016,35.0318},
		{0.0,-2037.8602,-335.3759,35.0317},
		{0.0,-2005.3221,-137.4541,35.4380},
		{0.0,-2006.3556,138.6625,27.2661},
		{0.0,-2003.4937,384.4902,34.7427},
		{0.0,-2004.1002,542.3316,34.7427},
		{0.0,-2099.6802,565.8253,34.7431},
		{0.0,-2226.9331,565.7338,34.7483},
		{0.0,-2256.5208,591.7636,37.7843},
		{0.0,-2256.2234,905.8365,66.2233},
		{0.0,-2258.5522,1085.7393,79.5879},
		{0.0,-2260.9167,1251.9984,43.2102},
		{0.0,-2059.8630,1275.2407,8.0363},
		{0.0,-1863.7690,1337.6692,6.7739},
		{1.0,-1618.1641,1199.9156,6.7661},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},//
	{// бездорожье
		{0.0,-1864.4503,-2381.2229,31.5846},
		{0.0,-1718.3188,-2294.7283,45.2318},
		{0.0,-1678.9152,-2176.0771,36.4075},
		{0.0,-1708.6892,-2106.5313,40.5838},
		{0.0,-1832.3588,-2087.7468,56.0560},
		{0.0,-1952.9957,-2060.5771,69.7296},
		{0.0,-1945.8071,-1954.0258,78.5620},
		{0.0,-1857.0730,-1927.6558,88.4337},
		{0.0,-1691.0414,-1912.4009,98.2297},
		{0.0,-1581.9554,-1891.6198,84.9697},
		{0.0,-1518.2130,-1839.8138,67.3244},
		{0.0,-1475.8656,-1782.2496,50.6363},
		{0.0,-1430.3173,-1873.5522,33.5106},
		{0.0,-1411.3867,-2034.2435,1.0000},
		{0.0,-1350.2726,-2042.8008,9.2772},
		{0.0,-1306.4934,-2118.4250,25.2313},
		{0.0,-1264.5914,-2263.1064,22.2187},
		{0.0,-1189.5835,-2355.5100,19.3239},
		{0.0,-1055.4319,-2373.8184,49.7934},
		{0.0,-967.9534,-2357.7893,63.5209},
		{0.0,-954.4967,-2319.0549,58.7685},
		{0.0,-954.9092,-2214.7622,40.3016},
		{0.0,-895.7296,-2182.9709,29.5663},
		{0.0,-798.3245,-2157.1934,22.2218},
		{0.0,-814.7314,-2059.7971,24.9278},
		{0.0,-857.7783,-1976.6576,16.9916},
		{0.0,-735.8377,-1860.4415,12.9406},
		{0.0,-670.8856,-1925.7917,10.9450},
		{0.0,-676.0182,-2090.8599,24.7597},
		{0.0,-783.4732,-2136.5078,25.4185},
		{0.0,-888.4941,-2181.9814,28.5519},
		{0.0,-948.7108,-2195.7961,38.2576},
		{0.0,-936.2672,-2352.7488,58.5742},
		{0.0,-786.4156,-2465.2830,75.9324},
		{0.0,-709.3486,-2352.2390,40.8819},
		{0.0,-592.4052,-2384.5251,27.7612},
		{0.0,-658.4496,-2479.5637,34.5280},
		{0.0,-710.3221,-2609.6077,72.9349},
		{0.0,-777.1717,-2687.0247,83.4813},
		{0.0,-917.7076,-2668.3259,86.0870},
		{0.0,-1091.5773,-2669.1135,25.7622},
		{0.0,-1230.5806,-2637.0510,9.0866},
		{0.0,-1367.1473,-2632.0386,26.7262},
		{0.0,-1512.8129,-2634.5842,48.5268},
		{0.0,-1644.1321,-2622.4631,47.2647},
		{0.0,-1771.0397,-2502.6235,9.2780},
		{1.0,-1880.7358,-2432.5237,32.6747},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	},//
	{// картинг
		{0.0,-1423.0721,-133.5238,1044.2628},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{0.0,-1404.6044,-155.3698,1043.1080},
		{0.0,-1530.3483,-221.1989,1049.9586},
		{0.0,-1381.4954,-140.8468,1050.4185},
		{0.0,-1265.7865,-222.4202,1050.0526},
		{1.0,-1404.6044,-155.3698,1043.1080},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0},
		{0.0,0.0,0.0,0.0}
	}
};

new Float:spawns_car_race_kart[][25] = {
	{-1402.4996, -207.0603, 1042.3719, 0.0000},
	{-1400.2638, -207.0603, 1042.3754, 0.0000},
	{-1397.8931, -207.0603, 1042.3781, 0.0000},
	{-1395.7288, -207.0603, 1042.3805, 0.0000},
	{-1393.3668, -207.0603, 1042.3831, 0.0000},
	{-1402.4996, -210.0510, 1042.3781, 0.0000},
	{-1400.2638, -210.0510, 1042.3818, 0.0000},
	{-1397.8931, -210.0510, 1042.3859, 0.0000},
	{-1395.7288, -210.0510, 1042.3884, 0.0000},
	{-1393.3668, -210.0510, 1042.3910, 0.0000},
	{-1402.4996, -213.1461, 1042.3794, 0.0000},
	{-1400.2638, -213.1461, 1042.3892, 0.0000},
	{-1397.8931, -213.1461, 1042.3923, 0.0000},
	{-1395.7288, -213.1461, 1042.3956, 0.0000},
	{-1393.3668, -213.1461, 1042.3932, 0.0000},
	{-1402.4996, -216.1665, 1042.4006, 0.0000},
	{-1400.2638, -216.1665, 1042.3590, 0.0000},
	{-1397.8931, -216.1665, 1042.3999, 0.0000},
	{-1395.7288, -216.1665, 1042.4026, 0.0000},
	{-1393.3668, -216.1665, 1042.4080, 0.0000},
	{-1402.4996, -219.2523, 1042.4167, 0.0000},
	{-1400.2638, -219.2523, 1042.4226, 0.0000},
	{-1397.8931, -219.2523, 1042.4073, 0.0000},
	{-1395.7288, -219.2523, 1042.4249, 0.0000},
	{-1393.3668, -219.2523, 1042.4327, 0.0000}
};
new Float:spawns_car_race_sity[][25] = {
	{-1626.8721, 1216.4556, 6.7722, 225.0000},
	{-1632.9271, 1210.5011, 6.7533, 225.0000},
	{-1632.3458, 1221.9630, 6.7671, 225.0000},
	{-1638.5345, 1215.9559, 6.7662, 225.0000},
	{-1638.4059, 1227.9788, 6.7671, 225.0000},
	{-1644.5020, 1221.8387, 6.7661, 225.0000},
	{-1644.3997, 1233.8173, 6.7671, 225.0000},
	{-1650.5052, 1227.5979, 6.7672, 225.0000},
	{-1650.2097, 1239.5116, 6.7671, 225.0000},
	{-1656.4216, 1233.3439, 6.7671, 225.0000},
	{-1656.1857, 1245.1952, 6.7709, 225.0000},
	{-1662.3087, 1238.9772, 6.7669, 225.0000},
	{-1662.2899, 1251.0956, 6.7772, 225.0000},
	{-1668.2368, 1244.9404, 6.7671, 225.0000},
	{-1667.9672, 1256.5748, 6.7777, 225.0000},
	{-1673.7991, 1250.6311, 6.7670, 225.0000},
	{-1673.7429, 1262.3813, 6.7592, 225.0000},
	{-1679.5250, 1256.4894, 6.7950, 225.0000},
	{-1679.6475, 1268.3621, 6.7671, 225.0000},
	{-1685.3892, 1262.6636, 6.7660, 225.0000},
	{-1685.3733, 1274.2111, 6.7672, 225.0000},
	{-1691.0829, 1268.3452, 6.7671, 225.0000},
	{-1690.8152, 1279.7847, 6.7661, 225.0000},
	{-1696.7572, 1274.0592, 6.7663, 225.0000},
	{-1696.3383, 1285.2871, 6.7662, 225.0000}
};
new Float:spawns_car_race_desert[][25] = {
	{-1928.6108, -2434.7722, 30.3596, 315.0000},
	{-1926.0165, -2437.4097, 30.3584, 315.0000},
	{-1923.4214, -2440.0471, 30.3579, 315.0000},
	{-1920.8254, -2442.6819, 30.3619, 315.0000},
	{-1918.2297, -2445.3201, 30.3607, 315.0000},
	{-1923.8497, -2450.6912, 30.3573, 315.0000},
	{-1926.2788, -2448.1880, 30.3531, 315.0000},
	{-1928.9128, -2445.5024, 30.3588, 315.0000},
	{-1931.5558, -2443.0854, 30.3528, 315.0000},
	{-1934.2892, -2440.4890, 30.3499, 315.0000},
	{-1939.2938, -2445.7158, 30.3620, 315.0000},
	{-1936.7200, -2448.2480, 30.3638, 315.0000},
	{-1934.1202, -2450.8022, 30.3679, 315.0000},
	{-1931.5591, -2453.3091, 30.4019, 315.0000},
	{-1928.9017, -2455.8230, 30.4710, 315.0000},
	{-1933.9561, -2460.9844, 30.6104, 315.0000},
	{-1936.4891, -2458.2773, 30.5352, 315.0000},
	{-1938.9983, -2455.6040, 30.4634, 315.0000},
	{-1941.4366, -2453.0049, 30.3984, 315.0000},
	{-1944.0645, -2450.2112, 30.3717, 315.0000},
	{-1949.2622, -2455.4006, 30.3631, 315.0000},
	{-1946.6733, -2457.9849, 30.4673, 315.0000},
	{-1944.1763, -2460.4136, 30.5923, 315.0000},
	{-1941.3196, -2463.2275, 30.6701, 315.0000},
	{-1938.7661, -2465.7358, 30.7351, 315.0000}
};
new game_info_race_lv[][] = {
	{"{FFFFFF}Безумные гонки, победит тот - кто первый доедет до финиша.\n"},
	{"Минимальный взнос для участия в мероприятии составляет "ORANGE"$1000"W".\n"},
	{"Максимальный взнос для участия в мероприятии составляет "ORANGE"$10000$"W".\n\n"},
	{"Возможные Автомобили: \n\t"P"Sandking, Hotring Racer, Super GT, Jester, Sultan\n"},
	{"\tElegy, Bandito, Euros, Phoenix, Infernus, Turismo\n\n"},
	{""G"Призовой фонд составляет:\n\n"},
	{""ORANGE"\t1 место - 50% от бюджета мероприятия\n"},
	{"\t2 место - 30% от бюджета мероприятия\n"},
	{"\t3 место - 20% от бюджета мероприятия\n"}
};

new ped_buyclothes[79][2] ={
	{95,5000},
	{50,10000},
	{15,10000},
	{35,10000},
	{25,10000},
	{36,10000},
	{96,10000},
	{155,10000},
	{143,10000},
	{44,20000},
	{24,30000},
	{37,40000},
	{2,45000},
	{3,45000},//
	{6,50000},
	{7,50000},//
	{14,50000},
	{47,50000},
	{67,50000},
	{142,50000},//
	{23,65000},//
	{72,70000},
	{22,80000},//
	{68,80000},
	{220,100000},
	{18,125000},
	{45,125000},
	{97,125000},
	{21,125000},
	{60,125000},//
	{182,150000},
	{262,150000},//
	{250,150000},
	{121,150000},
	{183,150000},
	{184,150000},//
	{30,175000},//
	{19,175000},
	{20,175000},//
	{4,225000},
	{5,225000},
	{259,250000},//
	{17,250000},
	{180,250000},//
	{208,250000},//
	{185,300000},
	{289,300000},
	{28,325000},
	{29,325000},
	{119,350000},
	{290,350000},
	{291,350000},
	{292,350000},
	{293,350000},
	{82,380000},
	{83,380000},//
	{84,380000},
	{101,400000},//
	{241,400000},
	{242,400000},
	{295,400000},
	{297,400000},
	{296,450000},//
	{249,500000},
	{299,500000},
	{46,700000},
	{294,700000},//67
	{55, 10000},//женские
	{90, 10000},
	{13, 10000},
	{192, 10000},
	{193, 10000},
	{224, 50000},
	{12, 100000},
	{190, 100000},
	{40, 100000},
	{298, 200000},
	{93, 400000},
	{233, 400000} // 79
};
enum fun_bizz {
	funcbSlot,
	funcbID,
	funcbName[20],
	funcbNameCar[12],
	funcbNum,
	funcbTarif[4],
	funcbCar[20],
	funcbBank[15],
	funcbColor,
	funcbShash,
	funcbPercent,
	Float:funcbPercent2,
	funcbPercent3,
	funcbCarID[20],
	funcbCars[20]

}
new FuncBizz[MAX_BUSINESS_COUNT][fun_bizz];
enum col_td {
	col_id,
	col_rgb[16],
	col_shash[16],
	col_car,
}
new taxi_class[6][24] = {"Эконом","Комфорт","Микроавтобус","Бизнес","Управляющий","Руководитель"};
new tk_class[3][24] = {"Водитель","Управляющий","Руководитель"};
new iconTaxi = 55;
new color_td[22][col_td] = {
	{-1,"ffffff",0xFFFFFFFF, 1},
	{930150143,"3770f6",0xFF3770F6, 2},
	{945198335,"385694",0xFF385694, 108},
	{-1554021121,"a35f84",0xFFA35F84, 232},
	{-328487169,"ec6bae",0xFFEC6BAE, 126},
	{831820287,"319491",0xFF319491, 240},
	{-1521069569,"a55651",0xFFA55651, 161},
	{1160383999,"452a0d",0xFF452A0D, 131},
	{-1433256961,"aa923b",0xFFAA923B, 228},
	{-1553384961,"a36939",0xFFA36939, 219},
	{-1674829569,"9c2c20",0xFF9C2C20, 158},
	{513427199,"1e9a46",0xFF1E9A46, 154},
	{444537343,"1a7f19",0xFF1A7F19, 229},
	{-1886631937,"8f8c47",0xFF8F8C47, 65},
	{-1365606401,"ae9a7f",0xFFAE9A7F, 99},
	{2084470783,"7c3e7f",0xFF7C3E7F, 178},
	{-1726078465,"991e21",0xFF991E21, 175},
	{-1701305857,"9a9821",0xFF9A9821, 194},
	{-712109825,"d58e10",0xFFD58E10, 6},
	{-2061554177,"042023",0xFF042023, 237},
	{623127039,"000000",0x000000AA, 0},
	{-1,"ffffff",0xFFFFFFFF, 1}
};
new biz_text[MAX_FUNCBIZZ];
new select_member[MAX_PLAYERS][36];
new taxi_car[7][2] = {
	{426,0},//эконом premier
	{438,0},//эконом cabbie
	{540,1},//комфорт vincent
	{550,1},//комфорт sunrise
	{560,3},//элитный sultan
	{580,3},//элитный stafford
	{483,2}//микроавтобус camper
};
new tk_car[3][2] = {
	{403,10000},
	{514,12000},
	{515,15000}
};
new Float:tk_wood[3][4] = {
	{-496.2701,-1571.6128,9.9494,274.1373},
	{-524.5775,-1544.1014,10.3110,359.3954},
	{-497.6492,-1563.9414,10.0701,271.9509}
};
new Float:tk_oil[5][4] = {
	{260.9107, 1359.6311, 11.5590, 0.0000},
	{266.4707, 1359.6311, 11.5590, 0.0000},
	{272.0701, 1359.6311, 11.5590, 0.0000},
	{277.6099, 1359.6311, 11.5590, 0.0000},
	{283.4688, 1359.6311, 11.5590, 0.0000}
};
new Float:tk_gun[3][4] = {
	{2653.2520,-2395.8916,13.6276,178.9787},// 1
	{2645.8679,-2395.8560,13.6276,178.0539},// 2
	{2613.2920,-2377.6545,14.6742,180.4115}// 3 d
};
new Float:car_bizz[7][20][4] = {
	{
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000}
	},
	{//ls
		{1084.9131, -1767.5701, 13.0683, 270.0000},
		{1084.9131, -1764.3806, 13.0743, 270.0000},
		{1084.9131, -1761.1133, 13.0802, 270.0000},
		{1084.9131, -1757.9333, 13.0877, 270.0000},
		{1084.9131, -1754.7515, 13.0960, 270.0000},
		{1098.6677, -1755.0851, 13.0609, 90.0000},
		{1098.6677, -1758.7825, 13.0618, 90.0000},
		{1098.6677, -1762.3461, 13.0597, 90.0000},
		{1098.6677, -1765.8761, 13.0589, 90.0000},
		{1098.6677, -1769.6969, 13.0578, 90.0000},
		{1098.6677, -1773.5542, 13.0553, 90.0000},
		{1062.4872, -1747.8126, 13.1559, 270.0000},
		{1062.4872, -1751.2001, 13.1532, 270.0000},
		{1062.4872, -1744.5979, 13.1682, 270.0000},
		{1062.4872, -1741.3923, 13.1746, 270.0000},
		{1062.4872, -1738.0553, 13.1835, 270.0000},
		{1084.9131, -1770.5269, 13.0600, 270.0000},
		{1084.9131, -1773.6429, 13.0543, 270.0000},
		{1076.3751, -1746.8152, 13.1523, 270.0000},
		{1084.5719, -1746.8152, 13.1360, 270.0000}

	},
	{//sf
		{-2189.3442, 293.3513, 34.8283, 0.0000},
		{-2193.0112, 293.3513, 34.8241, 0.0000},
		{-2197.1506, 293.3513, 34.8221, 0.0000},
		{-2201.3896, 293.3513, 34.8225, 0.0000},
		{-2205.5735, 293.3513, 34.8245, 0.0000},
		{-2209.9639, 293.3513, 34.8242, 0.0000},
		{-2214.1077, 293.3513, 34.8242, 0.0000},
		{-2218.3374, 293.3513, 34.8241, 0.0000},
		{-2222.8630, 293.3513, 34.8219, 0.0000},
		{-2227.0833, 293.3513, 34.8222, 0.0000},
		{-2231.4631, 293.3513, 34.8238, 0.0000},
		{-2235.1509, 293.3513, 34.8247, 0.0000},
		{-2239.0037, 293.3513, 34.8244, 0.0000},
		{-2239.5796, 306.2199, 34.8247, 180.0000},
		{-2235.3774, 306.2199, 34.8258, 180.0000},
		{-2231.4170, 306.2199, 34.8241, 180.0000},
		{-2227.0754, 306.2199, 34.8242, 180.0000},
		{-2222.9646, 306.2199, 34.8221, 180.0000},
		{-2218.5408, 306.2199, 34.8244, 180.0000},
		{-2214.1565, 306.2199, 34.8190, 180.0000}
	},
	{//lv
		{2441.4143, 1354.3888, 10.6409, 270.0000},
		{2441.4143, 1350.4005, 10.6409, 270.0000},
		{2441.4143, 1346.7572, 10.6410, 270.0000},
		{2441.4143, 1343.0005, 10.6412, 270.0000},
		{2441.4143, 1339.1304, 10.6408, 270.0000},
		{2441.4143, 1335.6786, 10.6409, 270.0000},
		{2441.4143, 1332.0668, 10.6409, 270.0000},
		{2450.9836, 1327.2745, 10.6409, 0.0000},
		{2454.6257, 1327.2745, 10.6410, 0.0000},
		{2458.1453, 1327.2745, 10.6407, 0.0000},
		{2453.1067, 1345.0856, 10.6185, 0.0000},
		{2457.2837, 1345.0856, 10.6187, 0.0000},
		{2461.6689, 1345.0856, 10.6223, 0.0000},
		{2451.9392, 1357.6162, 10.6409, 180.0000},
		{2455.8706, 1357.6162, 10.6409, 180.0000},
		{2459.4697, 1357.6162, 10.6409, 180.0000},
		{2463.4968, 1357.6162, 10.6409, 180.0000},
		{2467.0620, 1357.6162, 10.6409, 180.0000},
		{2470.8596, 1357.6162, 10.6409, 180.0000},
		{2474.5889, 1357.6162, 10.6408, 180.0000}
	},//ТРАНСПОРТНАЯ КОМПАНИЯ
	{//ls
		{-73.0662, -1138.3992, 2.0934, 334.0000},
		{-67.4416, -1141.0468, 2.0954, 334.0000},
		{-62.3113, -1143.5752, 2.0944, 334.0000},
		{-56.9763, -1146.1246, 2.0992, 334.0000},
		{-51.5848, -1148.6465, 2.0983, 334.0000},
		{-46.3469, -1151.1414, 2.1150, 334.0000},
		{-40.8276, -1153.6548, 2.0963, 334.0000},
		{-39.2590, -1145.0032, 2.0984, 65.0000},
		{-36.5911, -1139.6930, 2.0958, 65.0000},
		{-34.0856, -1134.5540, 2.0980, 65.0000},
		{-26.9305, -1125.6454, 2.0971, 160.0000},
		{-32.3384, -1123.7498, 2.0917, 160.0000},
		{-37.8672, -1121.5237, 2.0917, 160.0000},
		{-43.1510, -1119.5389, 2.0917, 160.0000},
		{-48.5604, -1117.5288, 2.0864, 160.0000},
		{-53.9550, -1115.4786, 2.0917, 159.8837},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000}

	},
	{//sf
		{-469.1691, -473.7513, 26.5467, 180.0000},
		{-474.1685, -473.7513, 26.5467, 180.0000},
		{-479.3889, -473.7513, 26.5467, 180.0000},
		{-484.5038, -473.7513, 26.5467, 180.0000},
		{-489.6243, -473.7513, 26.5467, 180.0000},
		{-494.6654, -473.7513, 26.5467, 180.0000},
		{-499.7348, -473.7513, 26.5467, 180.0000},
		{-504.6826, -473.7513, 26.5467, 180.0000},
		{-509.7936, -473.7513, 26.5467, 180.0000},
		{-514.7168, -473.7513, 26.5467, 180.0000},
		{-519.9040, -473.7513, 26.5467, 180.0000},
		{-524.6349, -473.7513, 26.5467, 180.0000},
		{-529.7674, -473.7513, 26.5467, 180.0000},
		{-534.8320, -473.7513, 26.5467, 180.0000},
		{-539.7120, -473.7513, 26.5467, 180.0000},
		{-544.7651, -473.7513, 26.5467, 180.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000}
	},
	{//lv
		{196.0370, -338.7674, 2.5944, 0.0000},
		{189.9101, -338.7674, 2.5944, 0.0000},
		{183.8461, -338.7674, 2.5944, 0.0000},
		{177.9124, -338.7674, 2.5944, 0.0000},
		{172.0277, -338.7674, 2.5944, 0.0000},
		{166.0319, -338.7674, 2.5944, 0.0000},
		{159.9279, -338.7674, 2.5944, 0.0000},
		{153.8436, -338.7674, 2.5944, 0.0000},
		{147.9041, -338.7674, 2.5944, 0.0000},
		{141.9637, -338.7674, 2.5944, 0.0000},
		{135.8837, -338.7674, 2.5944, 0.0000},
		{130.0420, -338.7674, 2.5944, 0.0000},
		{123.7230, -338.7674, 2.5944, 0.0000},
		{118.0001, -338.7674, 2.5944, 0.0000},
		{112.0287, -338.7674, 2.5944, 0.0000},
		{105.9255, -338.7674, 2.5944, 0.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000},
		{-1.00, -1.00, -1.00, 270.0000}
	}
};

enum ADVERT_DATA {
	adID,
	adSender[24],
	adCheker[24],
	adNews[3],
	adPhone,
	adText[100],
	adTime,
	adVIP,
	adMoney,
	bool:adCheked,
	bool:adBusy,
	bool:adCheking
}
new gAdvert[MAX_ADVERT_COUNT][ADVERT_DATA],
	gAdvertCount,
	gAdvertTime;

new calls_news[3],
	calls_ether[3],
	Text3D:advert_turn_text[3];

/* enum object_moved_data {
	moved_id,
	moved_vw,
	moved_modelid,
	Float:movedPosX,
	Float:movedPosY,
	Float:movedPosZ,
	Float:movedPosRotationX,
	Float:movedPosRotationY,
	Float:movedPosRotationZ,
	bool:status_moved
}
new moved_info[MAX_OBJECT_MOVED][object_moved_data] = {
	{-1,-1,986,-1530.303344, 483.000000, 7.910076, 0.000000, 0.000000, 0.000000,false},//0
	{-1,-1,1495,-1448.309692, 481.617034, 6.151350, 0.000000, 0.000000, 0.000000,false},//1
	{-1,-1,1495,-1318.928100, 481.617034, 6.151350, 0.000000, 0.000000, 0.000000,false},//2
	{-1,-1,2949,-1520.944091, 489.061187, 5.801178, 0.000000, 0.000000, -90.099952,false},//3
	{-1,-1,989,120.331481, 2070.349121, 17.936050, 0.000000, 0.000000, 176.819915,false},// lva ворота 1 часть

	// {-1,-1,968,36.051998, -1518.188964, 4.782000, 0.000000, 270.000000, 87.995002,false},//блок пост ЛС 5
	// {-1,-1,968,35.923999, -1534.245971, 4.794000, 0.000000, 270.000000, 87.989997,false},//блок пост ЛС 6
	// {-1,-1,968,66.999000, -1538.291015, 4.724998, 0.000000, 270.000000, 87.989997,false},//блок пост ЛС 7
	// {-1,-1,968,67.121002, -1522.211059, 4.782000, 0.000000, 270.000000, 87.989997,false},//блок пост ЛС 8

	// {-1,-1,968,-1444.939941, 785.088989, 46.647998, 0.000000, 270.000000, 316.000000,false},//блок пост СФ 9
	// {-1,-1,968,-1438.353027, 778.713012, 46.647998, 0.000000, 270.000000, 136.000000,false},//блок пост СФ 10
	// {-1,-1,968,-1388.014038, 845.619018, 46.984001, 0.000000, 270.000000, 316.000000,false},//блок пост СФ 11
	// {-1,-1,968,-1381.303955, 839.392028, 46.984001, 0.000000, 270.000000, 135.994003,false},//блок пост СФ 12

	// {-1,-1,968,1789.296997, 822.682006, 10.480999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 13
	// {-1,-1,968,1811.623046, 822.682006, 10.480999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 14
	// {-1,-1,968,1811.676025, 793.505004, 10.982999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 15
	// {-1,-1,968,1789.364990, 793.500000, 10.982999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 16


	{22,22,968,36.051998, -1518.188964, 4.782000, 0.000000, 270.000000, 87.995002,false},//блок пост ЛС 5
	{22,22,968,35.923999, -1534.245971, 4.794000, 0.000000, 270.000000, 87.989997,false},//блок пост ЛС 6
	{22,22,968,66.999000, -1538.291015, 4.724998, 0.000000, 270.000000, 87.989997,false},//блок пост ЛС 7
	{22,22,968,67.121002, -1522.211059, 4.782000, 0.000000, 270.000000, 87.989997,false},//блок пост ЛС 8

	{22,22,968,-1444.939941, 785.088989, 46.647998, 0.000000, 270.000000, 316.000000,false},//блок пост СФ 9
	{22,22,968,-1438.353027, 778.713012, 46.647998, 0.000000, 270.000000, 136.000000,false},//блок пост СФ 10
	{22,22,968,-1388.014038, 845.619018, 46.984001, 0.000000, 270.000000, 316.000000,false},//блок пост СФ 11
	{22,22,968,-1381.303955, 839.392028, 46.984001, 0.000000, 270.000000, 135.994003,false},//блок пост СФ 12

	{22,22,968,1789.296997, 822.682006, 10.480999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 13
	{22,22,968,1811.623046, 822.682006, 10.480999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 14
	{22,22,968,1811.676025, 793.505004, 10.982999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 15
	{22,22,968,1789.364990, 793.500000, 10.982999, 0.000000, 270.000000, 0.000000,false},//блок пост ЛВ 16

	{-1,40,1495,1365.661376, 1066.767333, 1625.481933, 0.000022, 0.000000, 89.999931,false},//[ПД] дверь в помещению копов 17
	{-1,40,1495,1369.071411, 1064.577392, 1625.481933, 0.000000, 0.000022, 0.000000,false},//[ПД] дверь к камерам 18
	{-1,40,1495,1289.777709, -6.756979, 999.859863,  0.000000, 0.000000, -90.599975,false},//[ПД] дверь к камерам 19
	{-1,-1,2990, 1589.65820, -1637.95203, 15.00631,  0.00000, 0.00000, 180.00000,false},//[ПД] Ворота в гараж LSPD 20
	{-1,-1,968,1544.69006348,-1630.90002441,13.13999939,0.00000000,90.00000000,90.00000000,false},//[ПД] шлагбаум в гараж LSPD 21
	{-1,-1,1495,1582.60718, -1637.91467, 12.29627,   0.00000, 0.00000, 0.00000,false},//[ПД] дверь в гараж LSPD 22

	{-1,-1,968, 198.439071, -323.986236, 1.242653, -0.000007, -90.000007, -86.599952,false},//[ТК] у ябл.сада 23

	{-1,-1,1500,764.733154, 6.474230, 1150.968750, 0.000000, 0.000000, 0.000000,false},//[LVa] штаб дверь собеседований 24

	{-1,-1,968, 1101.9063, -1744.5302, 13.1907, 0.000000, 90.000000, 90.000000,false},//[TAXI] шлагбаум LS 25
	{-1,-1,2920, -2201.914062, 309.752960, 35.281238, -90.000000, 0.000000, -270.000000,false},//[TAXI] шлагбаум SF 1 26
	{-1,-1,2920, -2197.043945, 309.662933, 35.281238, 90.000000, 0.000000, -270.000000,false},//[TAXI] шлагбаум SF 2 27
	{-1,-1,968, 2469.932861, 1323.640991, 10.427176, 0.000000, -90.000000, 0.000000,false},//[TAXI] шлагбаум LV 28

	{-1,-1,19859, 500.865386, 2041.307128, 1015.148132, 0.000000, 0.000000, -90.000000,false},//[ARMY] военкомат 29

	{-1,-1,10184,660.0380249,-1227.0469971,17.6669998,0.0000000,0.0000000,332.0000000,false}, //[особняк] 30
	{-1,-1,10184,665.3027344,-1309.4492188,14.9829998,0.0000000,0.0000000,270.0000000,false}, //[особняк] 31
	{-1,-1,10184,785.4316406,-1153.4423828,25.0900002,0.0000000,0.0000000,1.9995117,false}, //[особняк] 32

	{-1,-1,1569, 59.928001, -1533.542968, 4.499000, 0.000000, 0.000000, 82.000000,false}, //[блок пост] ЛС дверь 33
	{-1,-1,1569, -1401.375976, 823.627990, 46.742000, 0.000000, 0.000000, 136.427993,false}, //[блок пост] СФ дверь 34
	{-1,-1,1569, 1796.286010, 816.505004, 11.206999, 0.000000, 0.000000, 0.000000,false}, //[блок пост] ЛВ дверь 35

	{-1,-1,2949, -1522.477172, 482.676055, 5.801178, 0.000000, 0.000000, 90.600036,false}, //[SFa] дверь в армию 36

	{-1,-1,988, 211.929382, 1796.644409, 17.745433, 0.000000, 0.000000, 0.000000,false}, //[lVa] ворота 37

	{-1,-1,1495, 693.4559, -164.2079, 1070.6169, 0.000022, 0.000000, 89.999931, false}, //[Mayor] дверь в оружейную | 38

	{-1,-1,968, -87.517776, -1126.890502, 0.890990, 0.000000, -90.000007, 68.599983,false}, //[ТК] у АЗС 39
	{-1,-1,968, -486.344726, -562.425537, 25.272714, 0.000000, -90.000007, 0.000000,false}, //[ТК] у рыбалки 40

	{-1,-1,968, 2238.17749, 2450.42896, 10.63530,   0.00000, 90.00000, 90.00000,false}, //[LVPD] шлагбаум 41
	{-1,-1,968, -1572.19250, 658.78668, 6.78400,   0.00000, 89.00000, 89.87980,false}, //[SFPD] шлагбаум 42
	{-1,-1,968, -1701.42175, 687.79688, 24.53650,   0.00000, 89.00000, 269.86310,false}, //[SFPD] шлагбаум 43

	{-1,41,1495,1365.661376, 1066.767333, 1625.481933, 0.000022, 0.000000, 89.999931,false},//[ПД] дверь в помещению копов 44
	{-1,41,1495,1369.071411, 1064.577392, 1625.481933, 0.000000, 0.000022, 0.000000,false},//[ПД] дверь к камерам 45
	{-1,41,1495,1289.777709, -6.756979, 999.859863,  0.000000, 0.000000, -90.599975,false},//[ПД] дверь к камерам 46

	{-1,42,1495,1365.661376, 1066.767333, 1625.481933, 0.000022, 0.000000, 89.999931,false},//[ПД] дверь в помещению копов 47
	{-1,42,1495,1369.071411, 1064.577392, 1625.481933, 0.000000, 0.000022, 0.000000,false},//[ПД] дверь к камерам 48
	{-1,42,1495,1289.777709, -6.756979, 999.859863,  0.000000, 0.000000, -90.599975,false},//[ПД] дверь к камерам 49

	{-1,-1,989,118.631767, 2065.167724, 17.936050, 0.000000, 0.000000, 176.819915,false},//[LVa] ворота часть №2 | 50

	//{-1,-1,9625,614.09998, -1509.57031, 14.71810, 0.0000, 0.0000, 0.0000,false},//[Perfomanse] ворота №1 | 51
	//{-1,-1,9625,614.14276, -1501.64575, 14.71810, 0.000000, 0.000000, 0.0000,false},//[Perfomanse] ворота №2 | 52

	{-1,-1,968,2337.54028, 2446.61133, 5.6151, 0.00000, -90.00000, 60.00000,false},//[LVPD] шлагбаум | 51
	{-1,-1,9625,651.7225, -1487.5088, 14.6100, 0.0000, 0.0000, 0.0000,false},//[Perfomanse] ворота №1 | 52
	{-1,-1,9625,651.7225, -1477.1748, 14.6100, 0.000000, 0.000000, 0.0000,false}//[Perfomanse] ворота №2 | 53
	
},
Float:moved_pos_object[MAX_OBJECT_MOVED][6]={
	{-1537.7033, 483.0000, 7.9101,0.0,0.0,0.0},
	{-1448.309692, 481.617034, 6.151350,0.0,0.0,120.0000},
	{-1318.928100, 481.617034, 6.151350,0.0,0.0,120.0000},
	{-1520.944091, 489.061187, 5.801178,0.0,0.0,170.1000},
	{122.1715, 2075.6492, 18.0561, -3.9000, 0.0, 176.819915},

	{36.051998, -1518.188964, 4.782000, 0.000000, 0.000000, 87.995002},//блок пост ЛС
	{35.923999, -1534.245971, 4.794000, 0.000000, 0.000000, 87.989997},//блок пост ЛС
	{66.999000, -1538.291015, 4.724998, 0.000000, 0.000000, 87.989997},//блок пост ЛС
	{67.121002, -1522.211059, 4.782000, 0.000000, 0.000000, 87.989997},//блок пост ЛС

	{-1444.939941, 785.088989, 46.647998, 0.000000, 0.000000, 316.000000},//блок пост СФ
	{-1438.353027, 778.713012, 46.647998, 0.000000, 0.000000, 136.000000},//блок пост СФ
	{-1388.014038, 845.619018, 46.984001, 0.000000, 0.000000, 316.000000},//блок пост СФ
	{-1381.303955, 839.392028, 46.984001, 0.000000, 0.000000, 135.994003},//блок пост СФ

	{1789.296997, 822.682006, 10.480999, 0.000000, 0.000000, 0.000000},//блок пост ЛВ
	{1811.623046, 822.682006, 10.480999, 0.000000, 0.000000, 0.000000},//блок пост ЛВ
	{1811.676025, 793.505004, 10.982999, 0.000000, 0.000000, 0.000000},//блок пост ЛВ
	{1789.364990, 793.500000, 10.982999, 0.000000, 0.000000, 0.000000},//блок пост ЛВ

	{1365.661376, 1066.767333, 1625.481933, 0.000022, 0.000000, 10.9999},//[ПД] дверь в помещению копов
	{1369.071411, 1064.577392, 1625.481933, 0.000000, 0.000022, -80.0000},//[ПД] дверь к камерам
	{1289.777709, -6.756979, 999.859863,  0.000000, 0.000000, -10.599975},//[ПД] дверь к камерам
	{1597.39136, -1637.95203, 15.00631,   0.00000, 0.00000, 180.00000},//[ПД] Ворота в гараж LSPD
	{1544.69006348,-1630.90002441,13.13999939, 0.00000000,0.00000000,90.00000000},//[ПД] шлагбаум в гараж LSPD
	{1582.60718, -1637.91467, 12.29627,   0.00000, 0.00000, 92.63997},//[ПД] дверь в гараж LSPD

	{198.439071, -323.986236, 1.242653, -0.000007, 0.000007, -86.599952},//[ТК] у ябл.сада

	{764.733154, 6.474230, 1150.968750, 0.000000, 0.000000, -80.000000},//[LVa] штаб дверь собеседований

	{1101.9063, -1744.5302, 13.1907, 0.000000, 0.000000, 90.000000},//[TAXI] шлагбаум LS
	{-2201.914062, 309.752960, 35.281238, 0.000000, 0.000000, -270.000000},//[TAXI] шлагбаум SF 1
	{-2197.043945, 309.662933, 35.281238, 0.000000, 0.000000, -270.000000},//[TAXI] шлагбаум SF 2
	{2469.932861, 1323.640991, 10.427176, 0.000000, 0.000000, 0.000000},//[TAXI] шлагбаум LV

	{500.865386, 2041.307128, 1015.148132, 0.000000, 0.000000, -143.499984},//[ARMY] военкомат

	{660.0380249,-1227.0469971,12.4070,0.0000000,0.0000000,332.0000000}, //[особняк]
	{665.3027344,-1309.4492188,9.9230,0.0000000,0.0000000,270.0000000}, //[особняк]
	{785.4316406,-1153.4423828,20.0300,0.0000000,0.0000000,1.9995117}, //[особняк]

	{59.928001, -1533.542968, 4.499000, 0.000000, 0.000000, 0.000000}, //[блок пост] ЛС дверь
	{-1401.375976, 823.627990, 46.742000, 0.000000, 0.000000, 50.000000}, //[блок пост] СФ дверь
	{1796.286010, 816.505004, 11.206999, 0.000000, 0.000000, 90.000000}, //[блок пост] ЛВ дверь

	{-1522.477172, 482.676055, 5.801178, 0.000000, 0.000000, 0.600036}, //[SFa] дверь в армию

	{206.000000, 1796.644409, 17.745433, 0.000000, 0.000000, 0.000000}, //[lVa] ворота

	{693.4559, -164.2079, 1070.6169, 0.000022, 0.000000, 10.9999},//[Mayor] дверь в оружейную | 38

	{-87.517776, -1126.890502, 0.890990, 0.000000, 0.000007, 68.599983}, //[ТК] у АЗС
	{-486.344726, -562.425537, 25.272714, 0.000000, 0.000007, 0.000000}, //[ТК] у рыбалки

	{ 2238.17749, 2450.42896, 10.63530,   0.00000, 0.00000, 90.00000}, //[LVPD] шлагбаум
	{-1572.19250, 658.78668, 6.78400,   0.00000, 0.00000, 89.87980}, //[SFPD] шлагбаум
	{-1701.42175, 687.79688, 24.53650,   0.00000, 0.00000, 269.86310}, //[SFPD] шлагбаум

	{1365.661376, 1066.767333, 1625.481933, 0.000022, 0.000000, 10.9999},//[ПД] дверь в помещению копов
	{1369.071411, 1064.577392, 1625.481933, 0.000000, 0.000022, -80.0000},//[ПД] дверь к камерам
	{1289.777709, -6.756979, 999.859863,  0.000000, 0.000000, -10.599975},//[ПД] дверь к камерам

	{1365.661376, 1066.767333, 1625.481933, 0.000022, 0.000000, 10.9999},//[ПД] дверь в помещению копов
	{1369.071411, 1064.577392, 1625.481933, 0.000000, 0.000022, -80.0000},//[ПД] дверь к камерам
	{1289.777709, -6.756979, 999.859863,  0.000000, 0.000000, -10.599975},//[ПД] дверь к камерам

	{117.6936, 2059.8333, 18.0361,  2.0000, 0.000000, 200.2399},//[LVa] ворота часть №2 | 50

	// {2337.54028, 2446.61133, 5.6151,   0.00000, 0.00000, 60.00000},//[LVPD] шлагбаум | 51
	// {651.7225, -1487.5088, 10.9653,  0.0000, 0.000000, 0.0000},//[Perfomanse] ворота №1 | 52
	// {651.7225, -1477.1748, 10.9653,  0.0000, 0.000000, 0.0000}//[Perfomanse] ворота №2 | 53

	{2337.54028, 2446.61133, 5.6151,   0.00000, 0.00000, 60.00000},//[LVPD] шлагбаум | 51
	{651.7225, -1487.5088, 10.9653,  0.0000, 0.000000, 0.0000},//[Perfomanse] ворота №1 | 52
	{651.7225, -1477.1748, 10.9653,  0.0000, 0.000000, 0.0000}//[Perfomanse] ворота №2 | 53
	

};
 */
enum enter_info {
	tpName[50],
Float:tpEnterPos_X,
Float:tpEnterPos_Y,
Float:tpEnterPos_Z,
	tpEnterInt,
	tpEnterWorld,
Float:tpExitPos_X,
Float:tpExitPos_Y,
Float:tpExitPos_Z,
Float:tpExitPos_A,
	tpExitInt,
	tpExitWorld
}
new gTeleportsToD[TP_COUNT][enter_info] = { //saneka
	/*0*/{"Оружейный завод",2688.7493,-2399.4126,13.6328,0,0,2692.4006,-2401.0337,13.4674,215.4410,0,0},//оружейный завод
	/*1*/{"Выход на улицу",2690.6274,-2399.3911,13.6328,0,0,2687.2502,-2399.4639,13.6328,91.9586,0,0},//оружейный завод
	/*2*/{"Больница г.ЛС",1172.5408,-1325.2740,15.4040,0,0,2187.5295,586.6940,1080.4542,177.1751,93,20},//МЧС ЛС
	/*3*/{"Выход на улицу",2187.6035,588.1922,1080.4542,93,20,1174.0408,-1325.2740,14.9922,270.0000,0,0},//МЧС ЛС
	/*4*/{"Больница г.СФ",-2655.1638,639.8657,14.4545,0,0,2187.5295,586.6940,1080.4542,177.1751,93,21},//МЧС СФ
	/*5*/{"Выход на улицу",2187.6035,588.1922,1080.4542,93,21,-2655.1638,638.3657,14.4531,180.0000,0,0},//МЧС СФ
	/*6*/{"Больница г.ЛВ",1607.3760,1815.9340,10.8203,0,0,2187.5295,586.6940,1080.4542,177.1751,93,22},//МЧС ЛВ
	/*7*/{"Выход на улицу",2187.6035,588.1922,1080.4542,93,22,1607.3848,1817.4340,10.8203,359.6633,0,0},//МЧС ЛВ

	/*8*/{"Центр занятости",1684.5287,-1343.3507,17.4368,3,57,1494.4186,1305.7440,1093.2891,357.2330,3,57},//Центр занятости УБРАТЬ
	/*9*/{"Выход на улицу",1494.3658,1303.5785,1093.2891,3,57,1686.0278,-1343.3999,17.4316,268.1222,0,0},//Центр занятости УБРАТЬ

	/*10*/{"Вход на крышу",1556.2736,489.0876,1070.4316,92,20,1161.5529,-1328.3661,31.4985,358.4099,0,0},//МЧС ЛС крыша
	/*11*/{"Спуск с крыши",1161.5112,-1329.8655,31.4943,0,0,1556.3342,490.5883,1070.4316,359.5603,92,20},//МЧС ЛС крыша
	/*12*/{"Вход на крышу",1556.2736,489.0876,1070.4316,92,21,-2714.2036,629.6984,34.4028,180.1581,0,0},//МЧС СФ крыша
	/*13*/{"Спуск с крыши",-2714.2078,631.1984,34.4028,0,0,1556.3342,490.5883,1070.4316,359.5603,92,21},//МЧС СФ крыша
	/*14*/{"Вход на крышу",1556.2736,489.0876,1070.4316,92,22,1608.4158,1787.6586,30.4688,1.2818,0,0},//МЧС ЛВ крыша
	/*15*/{"Спуск с крыши",1608.4493,1786.1589,30.4688,0,0,1556.3342,490.5883,1070.4316,359.5603,92,22},//МЧС ЛВ крыша
	/*16*/{"Склад армии",289.8449,2046.9331,17.8456,0,0,316.4524,-168.3621,999.5938,2.1932,6,30},//ЛВА склад
	/*17*/{"Выход на улицу",316.3708,-169.8620,999.6010,6,30,294.4789,2044.2577,17.6406,258.0287,0,0},//ЛВА склад

	/*18*/{"Радиоцентр г.ЛС",1569.6614,-1334.6711,16.4844,0,0,2246.1313,764.2151,1153.9510,92.7495,74,10},//LS News

	/*19*/{"Выход в мэрию",1437.931,-1786.454,33.43,0,0,701.4060,-138.1458,1068.5168,88.0009,77,44},//КРЫША MAYOR LS выход

	/*20*/{"Радиоцентр г.СФ",-2521.1753,-624.5951,132.7827,0,0,2246.1313,764.2151,1153.9510,92.7495,74,11},//SF News

	/*21*/{"Лифт",2860.0000,-2762.0000,-0.2832,74,11,-2521.1445,-623.0954,132.7646,358.8209,0,0},//SF News УБРАТЬ

	/*22*/{"Радиоцентр г.ЛВ",2645.2136,1185.2959,10.8203,0,0,2246.1313,764.2151,1153.9510,92.7495,74,12},//LV News

	/*23*/{"Лифт",2860.0000,-2762.0000,-0.2832,74,-1,2645.1785,1183.7963,10.8203,178.6527,0,0},//LV News УБРАТЬ

	/*24*/{"Вход в офис",1548.6804,-1363.7773,326.2183,0,0,2246.1313,764.2151,1153.9510,92.7495,74,10},//LS News крыша

	/*25*/{"Вертолетная площадка",704.7529,-138.7394,1068.5168,77,44,1435.2,-1786.442,33.43,90.3133,0,0},//КРЫША MAYOR LS вход
	
	/*26*/{"Полицейский участок г.ЛС",1555.1647,-1675.6324,16.1953,0,0,1360.5880,1075.1031,1626.4896,182.1617,99,40},//LSPD 1
	/*27*/{"Выход на улицу",1360.5315,1076.6021,1626.4896,99,40,1553.6647,-1675.6243,16.1953,89.6884,0,0},//LSPD 1
	/*28*/{"Полицейский участок г.ЛС",1568.6637,-1689.9839,6.2188,0,0,1368.6409,1079.4608,1626.4896,268.6192,99,40},//LSPD 2
	/*29*/{"Выход на парковку",1367.1414,1079.4969,1626.4896,99,40,1568.6019,-1691.4827,5.8906,177.6423,0,0},//LSPD 2
	/*30*/{"Полицейский участок г.СФ",-1605.5975,710.3373,13.8672,0,0,1360.5880,1075.1031,1626.4896,182.1617,99,41},//SFPD 1
	/*31*/{"Выход на улицу",1360.5315,1076.6021,1626.4896,99,41,-1605.5238,711.8354,13.8672,357.1840,0,0},//SFPD 1
	/*32*/{"Полицейский участок г.СФ",-1594.1570,716.2018,-4.9063,0,0,1368.6409,1079.4608,1626.4896,268.6192,99,41},//SFPD 2
	/*33*/{"Выход на парковку",1367.1414,1079.4969,1626.4896,99,41,-1592.6570,716.2032,-5.2422,270.0532,0,0},//SFPD 2
	/*34*/{"Полицейский участок г.ЛВ",2337.1853,2459.2725,14.9742,0,0,1360.5880,1075.1031,1626.4896,182.1617,99,42},//LVPD 1
	/*35*/{"Выход на улицу",1360.5315,1076.6021,1626.4896,99,42,2337.1318,2457.7734,14.9688,177.9557,0,0},//LVPD 1
	/*36*/{"Полицейский участок г.ЛВ",2297.0679,2451.4919,10.8203,0,0,1368.6409,1079.4608,1626.4896,268.6192,99,42},//LVPD 2
	/*37*/{"Выход на парковку",1367.1414,1079.4969,1626.4896,99,42,2295.5681,2451.5195,10.8203,88.9447,0,0},//LVPD 2

	/*38*/{"FBI",-1972.5879,-1020.2689,32.1719,0,0,2114.2876,1369.0536,1020.8400,88.9665,75,43},//FBI
	/*39*/{"Выход на улицу",2117.7866,1368.9647,1020.8400,75,43,-1973.9132,-1019.5665,32.1767,62.0773,0,0},//FBI

	/*40*/{"Лифт",2101.7456,1369.1786,1020.8400,75,43,-1959.6599,-1043.3351,53.3498,183.8602,0,0},//FBI лифт на крышу
	/*41*/{"Выход в офис",-1959.7502,-1039.8644,53.3498,0,0,2104.3501,1369.0543,1020.8400,267.8347,75,43},//FBI лифт 2

	/*42*/{"Мэрия",1481.0220,-1772.2487,18.7958,0,0,701.1844,-134.0186,1068.5168,89.2543,77,44},//МЭРИЯ
	/*43*/{"Выход на улицу",704.7440,-132.7174,1068.5168,77,44,1481.0292,-1770.7487,18.7958,359.7233,0,0},//МЭРИЯ

	/*44*/{"Автошкола",-2026.5878,-102.0661,35.1641,0,0,711.0714,-1378.2799,1.4270,274.6702,3,45},//АШ
	/*45*/{"Выход на улицу",708.4104,-1378.7219,1.4270,3,45,-2026.7527,-100.2341,35.1641,0.0,0,0},//АШ

	/*46*/{"Банк г.ЛС",1411.5083,-1699.5978,13.5395,0,0,190.0802,-262.0420,1000.9766,182.5581,78,46},//БАНК ЛС
	/*47*/{"Выход на улицу",190.0132,-260.5435,1000.9766,78,46,1414.2449,-1702.1873,13.5395,230.0882,0,0},//БАНК ЛС
	/*48*/{"Банк г.СФ",-2351.1323,492.5963,30.8144,0,0,190.0802,-262.0420,1000.9766,182.5581,78,47},//БАНК СФ
	/*49*/{"Выход на улицу",190.0132,-260.5435,1000.9766,78,47,-2352.5913,492.9442,30.8510,76.5903,0,0},//БАНК СФ
	/*50*/{"Банк г.ЛВ",2577.4541,1325.8289,10.8203,0,0,190.0802,-262.0420,1000.9766,182.5581,78,48},//БАНК ЛВ
	/*51*/{"Выход на улицу",190.0132,-260.5435,1000.9766,78,48,2577.4856,1324.3292,10.8203,181.1994,0,0},//БАНК ЛВ
	/*52*/{"Итальянская мафия",1455.8739,751.0579,11.0234,0,0,-1814.9398,-646.3951,1001.0999,269.3521,73,49},//LCN
	/*53*/{"Выход на улицу",-1816.4397,-646.3781,1001.0999,73,49,1454.3873,750.8578,11.0234,97.6668,0,0},//LCN
	/*54*/{"Японская мафия",2634.7048,1824.2144,11.0161,0,0,-1814.9398,-646.3951,1001.0999,269.3521,73,50},//Yakuza
	/*55*/{"Выход на улицу",-1816.4397,-646.3781,1001.0999,73,50,2633.2048,1824.2188,11.0234,89.8335,0,0},//Yakuza
	/*56*/{"Русская мафия",937.1491,1732.5082,8.8516,0,0,-1814.9398,-646.3951,1001.0999,269.3521,73,51},//RM
	/*57*/{"Выход на улицу",-1816.4397,-646.3781,1001.0999,73,51,938.6489,1732.5316,8.8516,270.8951,0,0},//RM
	/*58*/{"Ballas",1939.1348,-1114.5219,27.4523,0,0,1796.1089,722.6656,1072.5573,88.6611,95,52},//Ballas
	/*59*/{"Выход на улицу",1797.6085,722.6306,1072.5573,95,52,1939.1057,-1116.0216,27.2563,178.8924,0,0},//Ballas
	/*60*/{"Vagos",2756.3184,-1182.7939,69.4034,0,0,2687.8591,1760.5887,1215.7155,249.2060,98,53},//Vagos
	/*61*/{"Выход на улицу",2686.4568,1761.1212,1215.7155,98,53,2756.3188,-1181.2939,69.3966,359.9770,0,0},//Vagos
	/*62*/{"Grove",2495.4343,-1691.0961,14.7656,0,0,1965.1907,1321.8658,966.3950,88.7639,94,54},//Grove
	/*63*/{"Выход на улицу",1966.6903,1321.8335,966.3950,94,54,2495.4336,-1689.5961,14.5297,0.0239,0,0},//Grove
	/*64*/{"Aztecas",1673.6831,-2122.4465,14.1460,0,0,1555.3221,912.0717,924.0762,269.5025,96,55},//Aztec
	/*65*/{"Выход на улицу",1553.8221,912.0847,924.0762,96,55,1674.6377,-2121.2896,13.9337,320.4736,0,0},//Aztec
	/*66*/{"Rifa",2736.6187,-1952.5796,13.5469,0,0,1556.3812,734.0337,915.6003,181.1748,97,56},//Rifa
	/*67*/{"Выход на улицу",1556.3505,735.5334,915.6003,97,56,2735.1187,-1952.5778,13.5394,89.9284,0,0},//Rifa
	/*68*/{"Фабрика",783.4079,590.4982,1063.3656,85,203,1296.5531,2461.9744,1011.8739,266.0278,88,200},//алько на фабрику
	/*69*/{"Выход в тюрьму",1295.0568,2462.0784,1011.8739,88,200,783.3878,588.9984,1063.3656,179.2337,85,203},//алько на фабрику
	/*70*/{"Столовая",749.3672,590.5065,1063.3656,85,203,1201.7505,2285.2493,1008.9139,271.9579,87,201},//алько в столовку
	/*71*/{"Выход в тюрьму",1200.2513,2285.1980,1008.9139,87,201,749.4456,589.0085,1063.3656,182.9937,85,203},//алько в столовку
	/*72*/{"Правительство",1123.0260,-2036.9426,69.8938,0,0,1749.4689,1381.5963,1095.3185,179.9072,83,57},//Правительство
	/*73*/{"Выход на улицу",1749.4713,1383.0963,1095.3185,83,57,1124.5255,-2036.9797,69.8839,268.5813,0,0},//Правительство
	/*74*/{"Центр развлечений",2227.2017,1837.1248,10.8203,0,0,833.0818,7.3694,1004.1797,92.8519,3,200},//центр развлечений
	/*75*/{"Выход на улицу",834.6312,7.3997,1004.1870,3,200,2225.7490,1837.1133,10.8203,93.2120,0,0},//центр развлечений
	/*76*/{"Казино",2166.0955,2165.0505,10.8203,0,0,2058.7952,1713.0632,1113.7751,264.9474,88,58},//казино
	/*77*/{"Выход на улицу",2057.3010,1713.1953,1113.7751,88,58,2165.5325,2163.6602,10.8203,157.9600,0,0},//казино

	/*78*/{"Казарма",-1373.0016,498.9899,11.1953,0,0,280.6122,1934.4968,5.1970,268.8168,87,59},//казарма армия сф
	/*79*/{"Выход на улицу",277.1194,1934.3929,5.1960,87,59,-1371.5020,499.0244,11.1953,271.3166,0,0},//казарма армия сф

	/*80*/{"Казарма",171.4748,1834.8865,17.6406,0,0,280.6122,1934.4968,5.1970,268.8168,87,60},//казарма армия лв
	/*81*/{"Выход на улицу",277.1194,1934.3929,5.1960,87,60,168.0004,1834.8228,17.6406,90.9048,0,0},//казарма армия лв

	/*82*/{"Штаб",154.4268,1903.3352,18.7542,0,0,758.8699,-2.7475,1151.9795,270.5926,89,61},//штаб армия лв
	/*83*/{"Выход на улицу",757.3700,-2.7630,1151.9795,89,61,158.6730,1903.2212,18.7149,271.5608,0,0},//штаб армия лв

	/*84*/{"Лаборатория",-1797.6656,-643.4174,1001.0859,73,49,1634.6228,995.3404,1475.6283,86.9213,100,49},//лаборатория LCN
	/*85*/{"Выход в дом",1636.1206,995.2598,1475.6283,100,49,-1797.7463,-644.9152,1001.0959,176.9179,73,49},//лаборатория LCN
	/*86*/{"Военкомат",-319.5402,1048.2900,20.3403,0,0,2464.2158,1343.0038,3015.3784,270.0906,84,63},//Военкомат
	/*87*/{"Выход на улицу",2462.7158,1343.0015,3015.3784,84,63,-319.4800,1049.7888,20.3403,357.7003,0,0},//Военкомат
	/*88*/{"Склад",-1297.0609,386.1711,6.9661,0,0,316.4528,-168.3600,999.5938,359.9998,6,31},//СФ склад
	/*89*/{"Выход на улицу",316.3708,-169.8620,999.6010,6,31,-1298.2955,387.0706,6.9661,54.4037,0,0},//СФ склад
	/*90*/{"Наркопритон",2165.9673,-1671.2290,15.0732,21,21,318.6192,1116.0261,1083.8828,359.4771,5,32},//наркопритон
	/*91*/{"Выход на улицу",318.6055,1114.5262,1083.8828,5,32,2167.0911,-1672.2224,15.0753,228.5259,0,0},//наркопритон

	/*92*/{"Военный госпиталь",153.6850,1846.2126,17.7718,0,0,311.2815,2059.5583,1014.3731,86.4105,90,33},//госпиталь ЛВа
	/*93*/{"Выход на улицу",312.7786,2059.4644,1014.3731,90,33,153.7152,1849.4449,17.7718,359.5159,0,0},//госпиталь ЛВа

	/*94*/{"Военный госпиталь",-1297.0643,402.0823,6.9661,0,0,311.2815,2059.5583,1014.3731,86.4105,90,34},//госпиталь СФа
	/*95*/{"Выход на улицу",312.7786,2059.4644,1014.3731,90,34,-1298.3687,402.8231,6.9661,60.4037,0,0},//госпиталь СФа
	/*96*/{"Вертолетная площадка",1524.5486,-1677.9193,6.2188,0,0,1565.1028,-1665.4083,28.3956,355.3339,0,0},//верт LSPD
	/*97*/{"Выход в гараж",1564.9807,-1666.9033,28.3956,0,0,1526.0479,-1677.9672,5.8906,268.1730,0,0},//верт LSPD
	/*98*/{"Вертолетная площадка",2297.0544,2468.7280,10.8203,0,0,2278.1699,2459.6155,38.6837,358.3989,0,0},//верт LVPD
	/*99*/{"Выход в гараж",2278.1279,2458.1160,38.6837,0,0,2295.5579,2468.8276,10.8203,86.1956,0,0},//верт LVPD
	/*100*/{"Склад",2714.1404,-2445.1436,13.6400,1,15,316.4528,-168.3642,999.5938,356.8665,6,35},//склад оружейный завод
	/*101*/{"Выход на улицу",316.3708,-169.8620,999.6010,6,35,2712.6416,-2445.0813,13.6399,87.6178,0,0},//склад оружейный завод
	/*102*/{"Лифт",2185.3337,568.6909,1080.4542,93,20,1552.2980,490.5710,1070.4316,359.2470,92,20},//МЧС ЛС 2 этаж
	/*103*/{"Лифт",1552.2783,489.0711,1070.4316,92,20,2185.3396,570.1909,1080.4542,359.7798,93,20},//МЧС ЛС 2 этаж
	/*104*/{"Лифт",2185.3337,568.6909,1080.4542,93,21,1552.2980,490.5710,1070.4316,359.2470,92,21},//МЧС СФ 2 этаж
	/*105*/{"Лифт",1552.2783,489.0711,1070.4316,92,21,2185.3396,570.1909,1080.4542,359.7798,93,21},//МЧС СФ 2 этаж
	/*106*/{"Лифт",2185.3337,568.6909,1080.4542,93,22,1552.2980,490.5710,1070.4316,359.2470,92,22},//МЧС ЛВ 2 этаж
	/*107*/{"Лифт",1552.2783,489.0711,1070.4316,92,22,2185.3396,570.1909,1080.4542,359.7798,93,22},//МЧС ЛВ 2 этаж
	/*108*/{"Лаборатория",-1797.6656,-643.4174,1001.0859,73,50,1634.6228,995.3404,1475.6283,86.9213,100,50},//лаборатория Yakuza
	/*109*/{"Выход в дом",1636.1206,995.2598,1475.6283,100,50,-1797.7463,-644.9152,1001.0959,176.9179,73,50},//лаборатория Yakuza
	/*110*/{"Лаборатория",-1797.6656,-643.4174,1001.0859,73,51,1634.6228,995.3404,1475.6283,86.9213,100,51},//лаборатория RM
	/*111*/{"Выход в дом",1636.1206,995.2598,1475.6283,100,51,-1797.7463,-644.9152,1001.0959,176.9179,73,51},//лаборатория RM
	/*112*/{"Тир",305.3506,-141.8417,1004.0625,7,66,302.9281,-141.8477,1004.0625,15.1908,7,500},//ТИР ЛС
	/*113*/{"Выход",304.5872,-141.9285,1004.0625,7,500,307.0656,-141.2360,1004.0625,293.4333,7,66},//ТИР ЛС выход

	/*114*/{"Тир",286.1431,-29.8190,1001.5156,1,67,286.1431,-27.2179,1001.5156,279.9366,1,500},//ТИР СФ
	/*115*/{"Выход",286.0357,-29.1079,1001.5156,1,500,286.1418,-31.4886,1001.5156,179.6914,1,67},//ТИР СФ выход

	/*116*/{"Тир",301.7687,-76.5397,1001.5156,4,68,301.6959,-73.8680,1001.5156,357.5736,4,500},//ТИР ЛВ
	/*117*/{"Выход",301.7337,-75.6934,1001.5156,4,500,301.6580,-78.1741,1001.5156,116.3515,4,68},//ТИР ЛВ выход
	/*118*/{"Тир",306.3994,-159.1899,999.5938,6,31,303.5488,-159.0396,999.5938,88.3483,6,31},//ТИР CФа вход
	/*119*/{"Выход",305.6983,-159.1528,999.5938,6,31,307.9801,-159.6936,999.5938,262.3747,6,31},//ТИР CФа выход
	/*120*/{"Тир",1760.3450,724.2971,1071.0692,95,52,336.0217,-29.9183,997.8625,88.1146,95,52},//ТИР Ballas вход
	/*121*/{"Выход",337.4296,-29.7989,997.8625,95,52,1760.3148,726.3054,1071.0692,358.7480,95,52},//ТИР Ballas вход
	/*122*/{"Тир",1569.0374,897.9334,924.2578,96,55,336.0217,-29.9183,997.8625,88.1146,96,55},//ТИР Aztec вход
	/*123*/{"Выход",337.4296,-29.7989,997.8625,96,55,1567.3612,897.7423,924.2578,89.6479,96,55},//ТИР Aztec выход
	/*124*/{"Тир",1954.3213,1341.0316,966.4043,94,54,336.0217,-29.9183,997.8625,88.1146,94,54},//ТИР Grove вход
	/*125*/{"Выход",337.4296,-29.7989,997.8625,94,54,1952.7927,1341.0491,966.4043,88.2306,94,54},//ТИР Grove выход
	/*126*/{"Тир",2714.0208,1756.1503,1215.7363,98,53,336.0217,-29.9183,997.8625,88.1146,98,53},//ТИР Vagos вход
	/*127*/{"Выход",337.4296,-29.7989,997.8625,98,53,2712.5549,1756.0474,1215.7363,87.2578,98,53},//ТИР Vagos выход
	/*128*/{"Тир",1548.9573,716.2450,915.6003,97,56,336.0217,-29.9183,997.8625,88.1146,97,56},//ТИР Rifa вход
	/*129*/{"Выход",337.4296,-29.7989,997.8625,97,56,1550.2424,716.2040,915.6003,269.8958,97,56},//ТИР Rifa выход

	/*130*/{"Тир",1578.3342,-1690.6177,6.2188,0,0,302.9281,-141.8477,1004.0625,15.1908,7,12},//ТИР LSPD вход
	/*131*/{"Выход",304.5872,-141.9285,1004.0625,7,12,1578.2947,-1692.4899,6.2188,181.1595,0,0},//ТИР LSPD выход
	
	/*132*/{"Тир",-1606.3071,672.0612,-4.9063,0,0,302.9281,-141.8477,1004.0625,15.1908,7,13},//ТИР SFPD вход
	/*133*/{"Выход",304.5872,-141.9285,1004.0625,7,13,-1606.8217,673.8746,-5.2422,359.3306,0,0},//ТИР SFPD выход

	/*134*/{"Тир",306.3991,-159.1039,999.5938,6,30,259.8334,-29.5117,1001.1633,93.7385,6,30},//ТИР LSPD вход
	/*135*/{"Выход",261.1749,-29.6252,1001.1633,6,30,308.1745,-160.1824,999.5938,269.1558,6,30}//ТИР LSPD выход

};
new TeleportPickup[sizeof(gTeleportsToD)] = {-1, ...};
// ПИКАПЫ
new Float:gPickup[PICKUPS_COUNT][3] ={// Roman Ivanov modified
	/*0*/{704.0650,-1364.2423,1.4270},//автошкола ПДД
	/*1*/{686.5381,-133.5372,1068.5168},//мэрия трудоустрйоство
	/*2*/{728.1974,-1371.6168,1.4270},//АШ покупка лицензий
	/*3*/{1406.7494,-15.8215,1000.9215},//отель выход
	/*4*/{1398.1952,-6.5419,1000.9082},//отель ресепшн
	/*5*/{1393.9543,-16.6323,1000.9181},//отель лифт 1
	/*6*/{159.7930,-16.2426,1002.1111},//отель лифт 2
	/*7*/{1555.9406,517.9673,1070.4316},//медкарта
	/*8*/{1552.5643,517.7847,1070.4458},//смена пола
	/*9*/{2093.6831,1702.3396,1115.9095},//казино раздевалка
	/*10*/{1755.7896,-1906.6122,13.5655},//помощь о игре спавн ЖД ЛС
	/*11*/{1754.1715,-1899.1108,13.5615},//бесплатная еда спавн ЖД ЛС
	/*12*/{1356.6272,1072.1150,1626.4896},//сдача с повинной
	/*13*/{2409.4675,-40.0383,1029.6404},//информация в бизнесе таксопарке
	/*14*/{1611.4082,997.8234,1475.6283},//лаборатории аренда рабочих
	/*15*/{822.1746,1.8579,1004.1797},//сумасшедшие войны
	/*16*/{1749.4655,1335.9310,1099.2771},//экономика Правительство
	/*17*/{2692.3264,-2413.4194,13.6328},//[оружейный завод] раздевалка
	/*18*/{2696.0183,-2413.3420,13.6328},//[оружейный завод] заготовка
	/*19*/{277.5458,1435.3368,10.6189},//[нефтезавод] раздевалка
	/*20*/{-111.1846,-4.5949,3.1172},//[Ферма(Яблочневый сад)] ящик
	/*21*/{-109.3539,0.2345,3.1172},//[Ферма(Яблочневый сад)] лейка
	/*22*/{-109.7289,-2.1081,3.1172},//[Ферма(Яблочневый сад)] раздевалка
	/*23*/{686.5380,-135.6803,1068.5168},//[Мэрия] инфо о штате
	/*24*/{1373.1304,1056.9905,1626.4896},//[ПД] выдача оружия
	/*25*/{2105.6753,1383.7122,1020.8400},//[ФБР] выдача оружия
	/*26*/{312.4538,-168.7225,999.5938},//[Армии] выдача оружия
	/*27*/{1358.4679,1072.0204,1626.4896},//[ПД] получение номеров на машины
	/*28*/{1297.9482,2464.1494,1011.8739},//[Alcotraz] заготовка
	/*29*/{1296.6395,2441.2144,1011.8739},//[Alcotraz] склад
	/*30*/{1376.0228,1057.0640,1626.4896},//[Раздевалка] ПОЛИЦИЯ
	/*31*/{2110.2344,1379.5747,1020.8400},//[Раздевалка] ФБР
	/*32*/{2172.9651,571.7098,1080.4542},//[Раздевалка] МЧС
	/*33*/{281.5041,1942.8838,5.1970},//[Раздевалка] АРМИИ 1
	/*34*/{2229.9209,747.7399,1153.9510},//[Раздевалка] NEWS
	/*35*/{1734.7340,1366.4283,1095.3182},//[Раздевалка] Правительство
	/*36*/{686.5384,-138.2538,1068.5168},//Покупка семьи
	/*37*/{765.9391,11.4027,1000.7066},//[Спорт-Зал] Инфо
	/*38*/{1731.3005,1372.8398,1095.3182},//[Правительство] Выдача оружия
	/*39*/{-511.7016,-1571.1439,10.3160},//[Лесопилка] Раздевалка
	/*40*/{822.0084,6.3995,1004.1797},//[МЧС] Лечение
	/*41*/{2109.5098,1384.1621,1020.8400},//[FBI] Маскирока
	/*42*/{1758.4182,728.0562,1071.0692},//[Ballas] склад
	/*43*/{2707.5825,1761.0266,1215.7363},//[Vagos] склад
	/*44*/{1951.9347,1342.9095,966.4043},//[Grove] склад
	/*45*/{1559.0104,889.8791,922.4379},//[Aztec] склад
	/*46*/{1553.2108,707.3284,915.6003},//[Rifa] склад
	/*47*/{-1793.8373,-671.8163,991.4554},//[Мафии] склад
	/*48*/{187.8701,-274.7375,1000.9766},//[Банк] услуги
	/*49*/{187.2302,-272.9705,1000.9766},//[Банк] услуги
	/*50*/{185.9120,-269.3565,1000.9766},//[Банк] оплата недвижимости
	/*51*/{186.5228,-271.0347,1000.9766},//[Банк] оплата штрафов

	/*52*/{1111.7571,-1771.2794,894.0478},//[выход с гаража] N
	/*53*/{1045.7643,-1780.6997,894.0478},//[выход с гаража] D
	/*54*/{1112.3341,-1858.3147,894.0478},//[выход с гаража] B
	/*55*/{1052.9872,-1851.4395,894.0478},//[выход с гаража] A
	/*56*/{1451.0068,702.5929,1087.9011},//[автосалон] выход

	/*57*/{822.0088,4.1138,1004.1797},//[гонки] регистрация

	/*58*/{1405.1508,-30.1729,1000.8589},//[отель] вход на парковку
	/*59*/{1680.0447,696.4232,589.8863},//[гонки] выход с парковки в отель

	/*60*/{1779.6661,715.8765,1072.5573},//[Ballas] аптечка
	/*61*/{2687.0530,1750.3890,1215.7085},//[Vagos] аптечка
	/*62*/{1940.9451,1324.0303,966.4050},//[Grove] аптечка
	/*63*/{1552.7271,921.2464,924.0771},//[Aztec] аптечка
	/*64*/{1570.2238,723.8939,915.6011},//[Rifa] аптечка

	/*65*/{-1346.5437,364.5526,7.1875},//СФА тир
	/*66*/{303.3796,-127.7514,1004.0},//аммо тир лс
	/*67*/{297.9763,-27.7321,1001.5156},//аммо тир сф
	/*68*/{294.4863,-59.0796,1001.5156},//аммо тир лв
	/*69*/{336.5639,-18.4006,997.8625},//аммо тир ballas
	/*70*/{336.5639,-18.4006,997.8625},//аммо тир aztec
	/*71*/{336.5639,-18.4006,997.8625},//аммо тир grove
	/*72*/{336.5639,-18.4006,997.8625},//аммо тир vagos
	/*73*/{336.5639,-18.4006,997.8625},//аммо тир rifa

	/*74*/{302.3565,-127.4016,1004.0625},//аммо тир lspd
	/*75*/{302.3565,-127.4016,1004.0625},//аммо тир sfpd
	/*76*/{260.2811,-17.7656,1001.1633},//аммо тир Lva

	/*77*/{1937.6501,-1124.6125,26.6159},//ballas top
	/*78*/{2748.9026,-1175.2101,69.4068},//vagos top
	/*79*/{2492.4402,-1687.0853,13.5132},//grove top
	/*80*/{1677.6838,-2124.1843,13.5469},//aztec top
	/*81*/{2731.1826,-1956.2351,13.5469},//rifa top


	/*82*/{-539.6769,-1585.4095,10.3110},//лесопилка unload 1
	/*83*/{-531.6503,-1585.4089,10.3110},//лесопилка unload 2

 	/*84*/{860.8140,-1245.8215,14.7578},// грузчики раздевалка
 	/*85*/{706.3217,-1364.7998,1.4270}, // АШ сдача экзамена 
 	/*86*/{281.3185,1926.0063,5.1970},//[Раздевалка] АРМИИ 2
 	/*87*/{675.0721,-107.7897,1071.6169},//[Раздевалка] Мэрия
 	/*88*/{696.9623,-160.7304,1071.6169},//[Оружейная] Мэрия

 	/*89*/{286.5800,1816.3429,17.6509},//[Телепорт для ворот пешком ( со стороны ангаров на территорию казарм )] АРМИЯ ЛВ
 	/*90*/{285.1710,1825.6858,17.6709},//[Телепорт для ворот  пешком( из территории казарм на территорию ангаров)] АРМИЯ ЛВ
 	/*91*/{290.0635,1821.3661,17.6406},//[Телепорт для ворот для машин ( со стороны ангаров на территорию казарм )] АРМИЯ ЛВ
 	/*92*/{283.0171,1821.3195,17.6709},//[Телепорт для ворот для машин ( из территории казарм на территорию ангаров )] АРМИЯ ЛВ

 	/*93*/{140.7689,1940.4702,19.3068},//[Телепорт для ворот пешком( на территорию казарм на территорию вертолётной площадки )] АРМИЯ ЛВ
 	/*94*/{129.1773,1942.6154,19.3262},//[Телепорт для ворот пешком( с территории вертолётной площадки на территорию казарм )] АРМИЯ ЛВ
 	/*95*/{134.8916,1938.0608,19.2849},//[Телепорт для ворот для машин( на территорию казарм на территорию вертолётной площадки )] АРМИЯ ЛВ
 	/*96*/{135.1537,1945.2299,19.3479},//[Телепорт для ворот для машин( с территории вертолётной площадки на территорию казарм )] АРМИЯ ЛВ

	/*97*/{1161.1179,-1756.1178,13.6343},//помощь по игре спавн Вокзал ЛС

	// 98{826.1300,-1355.2468,13.5407},помощь по игре спавн 3-ий спавн ЛС MONSER DEL
	// 99 {813.7074,-1351.7848,13.5333}, еда спавн 3 monser DEL


	/*98*/{1149.0448,-1755.9703,13.6327},//еда спавн 2
	/*99*/{2669.9128,-2399.0171,13.6328},//еда работа оружейный завод
	/*100*/{274.8127,1424.6901,10.5859},//еда нефтезавод
	/*101*/{880.7157,-1260.8700,14.8814},//еда склад
	/*102*/{-129.4655,-9.0290,3.1172},//еда ферма
	/*103*/{-504.5277,-1585.6414,10.3160},//еда лесопилка
	/*104*/{-2039.9197,-84.0894,35.3203},//еда автошкола
	/*105*/{-1869.7888,-1628.4187,21.7877}, // шахта раздевалка
	/*106*/{2247.9429,764.3359,1153.9510}// СМИ ЛИФТ


};
new gPickupData[PICKUPS_COUNT][3] ={//int | mir || id
	{3,45,1239},//0
	{-1,-1,1239},//1
	{3,45,1239},//2
	{79,-1,1318},//3
	{79,-1,1239},//4
	{-1,-1,19130},//5
	{-1,-1,19130},//6
	{92,-1,11736},//7
	{92,-1,1314},//8
	{88,58,1275},//9
	{0,0,18631},//10
	{0,0,2821},//11
	{99,-1,1247},//12
	{-1,-1,1239},//13
	{100,-1,1239},//14
	{3,200,1314},//15
	{83,57,1239},//16
	{0,0,1275},//17
	{0,0,2061},//18
	{0,0,1275},//19
	{0,0,19639},//20
	{0,0,19621},//21
	{0,0,1275},//22
	{77,44,1239},//23
	{99,-1,2044},//24
	{75,43,2044},//25
	{6,-1,2044},//26
	{99,-1,1239},//27
	{88,200,1239},//28
	{88,200,2386},//29

	{99,-1,1275},//30
	{75,43,1275},//31
	{93,-1,1275},//32
	{87,-1,1275},//33
	{74,-1,1275},//34
	{83,57,1275},//35
	{77,44,1314},//36 покупка семьи
	{-1,-1,1239},//37
	{83,57,2044},//38
	{0,0,1275},//39
	{3,200,1314},//40
	{75,43,1275},//41
	{95,52,11745},//42
	{98,53,11745},//43
	{94,54,11745},//44
	{96,55,11745},//45
	{97,56,11745},//46
	{73,-1,11745},//47

	{78,-1,1274},//48
	{78,-1,1274},//49
	{78,-1,1274},//50
	{78,-1,1274},//51

	{-1,-1,1318},//52
	{-1,-1,1318},//53
	{-1,-1,1318},//54
	{-1,-1,1318},//55
	{-1,-1,1318},//56

	{3,200,1314},//57

	{79,-1,1318},//58
	{101,-1,1318},//59

	{95,52,1240},//60
	{98,53,1240},//61
	{94,54,1240},//62
	{96,55,1240},//63
	{97,56,1240},//64

	{0,0,2061},//65
	{7,500,2061},//66
	{1,500,2061},//67
	{4,500,2061},//68
	{95,52,2061},//69
	{96,55,2061},//70
	{94,54,2061},//71
	{98,53,2061},//72
	{97,56,2061},//73
	{1,12,2061},//74
	{1,13,2061},//75
	{6,30,2061},//76

	{0,0,1239},//77
	{0,0,1239},//78
	{0,0,1239},//79
	{0,0,1239},//80
	{0,0,1239},//81

	{0,0,19198},//82
	{0,0,19198},//83

	{0,0,1275},//84
	{3,45,1581},//85
	{87,-1,1275},//86
	{77,44,1275},//87
	{77,44,2044},//88
	{0,0,19135},//89
	{0,0,19135},//90
	{0,0,19133},//91
	{0,0,19133},//92
	{0,0,19135},//93
	{0,0,19135},//94
	{0,0,19133},//95
	{0,0,19133},//96
	{0,0,18631},//97
	{0,0,2821}, // 98
	{0,0,2821}, // 99
	{0,0,2821}, // 100
	{0,0,2821}, // 101
	{0,0,2821}, // 102
	{0,0,2821}, // 103
	{0,0,2821}, // 104
	{0,0,1275},//105
	{74,10,19134}//106

};
enum pick3dtext {
	picName[64],
	picColor[36]
}
new gPickupDataName[PICKUPS_COUNT][pick3dtext] ={//3dText || color
	{"Правила Дорожного Движения",COLOR_SERVER},//0
	{"Трудоустройство",COLOR_SERVER},//1
	{"Покупка лицензий",COLOR_SERVER},//2
	{"Выход на улицу",COLOR_SERVER},//3
	{"Ресепшн",COLOR_SERVER},//4
	{"Лифт",COLOR_SERVER},//5
	{"Лифт",COLOR_SERVER},//6
	{"Получение мед.карты",COLOR_SERVER},//7
	{"Смена пола",COLOR_SERVER},//8
	{"Раздевалка",COLOR_SERVER},//9
	{"FAQ",COLOR_SERVER},//10
	{"Еда для новичков",COLOR_SERVER},//11
	{"Сдача с повинной",COLOR_SERVER},//12
	{"Информация",COLOR_SERVER},//13
	{"Найм рабочих",COLOR_SERVER},//14
	{"Сумасшедшие войны",COLOR_SERVER},//15
	{"Управление штатом",COLOR_SERVER},//16
	{"Раздевалка",COLOR_SERVER},//17
	{"Заготовка",COLOR_SERVER},//18
	{"Раздевалка",COLOR_SERVER},//19
	{"Ящик для сбора яблок",COLOR_SERVER},//20
	{"Лейка",COLOR_SERVER},//21
	{"Раздевалка",COLOR_SERVER},//22
	{"Информация о штате",COLOR_SERVER},//23
	{"Оружие",COLOR_SERVER},//24
	{"Оружие",COLOR_SERVER},//25
	{"Оружие",COLOR_SERVER},//26
	{"Получение номеров на Т/С",COLOR_SERVER},//27
	{"Заготовка",COLOR_SERVER},//28
	{"Склад",COLOR_SERVER},//29

	{"Раздевалка",COLOR_SERVER},//30
	{"Раздевалка",COLOR_SERVER},//31
	{"Раздевалка",COLOR_SERVER},//32
	{"Раздевалка",COLOR_SERVER},//33
	{"Раздевалка",COLOR_SERVER},//34
	{"Раздевалка",COLOR_SERVER},//35
	{"Семьи",COLOR_SERVER},//36
	{"Информация",COLOR_SERVER},//37
	{"Оружие",COLOR_SERVER},//38
	{"Раздевалка",COLOR_SERVER},//39
	{"Голодные игры",COLOR_SERVER},//40
	{"Маскировка",COLOR_SERVER},//41
	{"None",COLOR_SERVER},//42
	{"None",COLOR_SERVER},//43
	{"None",COLOR_SERVER},//44
	{"None",COLOR_SERVER},//45
	{"None",COLOR_SERVER},//46
	{"None",COLOR_SERVER},//47

	{"Банковские услуги",COLOR_SERVER},//48
	{"Банковские услуги",COLOR_SERVER},//49
	{"Оплата недвижимости",COLOR_SERVER},//50
	{"Оплата штрафов",COLOR_SERVER},//51

	{"None",COLOR_SERVER},//52
	{"None",COLOR_SERVER},//53
	{"None",COLOR_SERVER},//54
	{"None",COLOR_SERVER},//55
	{"None",COLOR_SERVER},//56

	{"Безумные гонки",COLOR_SERVER},//57

	{"Вход на парковку",COLOR_SERVER},//58
	{"Вход в отель",COLOR_SERVER},//59

	{"None",COLOR_SERVER},//60
	{"None",COLOR_SERVER},//61
	{"None",COLOR_SERVER},//62
	{"None",COLOR_SERVER},//63
	{"None",COLOR_SERVER},//64

	{"Начать тренировку",COLOR_SERVER},//65
	{"Начать тренировку",COLOR_SERVER},//66
	{"Начать тренировку",COLOR_SERVER},//67
	{"Начать тренировку",COLOR_SERVER},//68
	{"Начать тренировку",COLOR_SERVER},//69
	{"Начать тренировку",COLOR_SERVER},//70
	{"Начать тренировку",COLOR_SERVER},//71
	{"Начать тренировку",COLOR_SERVER},//72
	{"Начать тренировку",COLOR_SERVER},//73
	{"Начать тренировку",COLOR_SERVER},//74
	{"Начать тренировку",COLOR_SERVER},//75
	{"Начать тренировку",COLOR_SERVER},//76

	{"Информация",COLOR_SERVER},//77
	{"Информация",COLOR_SERVER},//78
	{"Информация",COLOR_SERVER},//79
	{"Информация",COLOR_SERVER},//80
	{"Информация",COLOR_SERVER},//81

	{"None",COLOR_SERVER},//82
	{"None",COLOR_SERVER},//83

 	{"Раздевалка",COLOR_SERVER}, //84
 	{"Сдача экзамена", COLOR_SERVER}, //85
 	{"Раздевалка",COLOR_SERVER},// 86
 	{"Раздевалка",COLOR_SERVER}, //87
 	{"Оружие",COLOR_SERVER}, //88
 	{"None",COLOR_SERVER}, //89
 	{"None",COLOR_SERVER}, //90
 	{"None",COLOR_SERVER}, //91
 	{"None",COLOR_SERVER}, //92
 	{"None",COLOR_SERVER}, //93
 	{"None",COLOR_SERVER}, //94
 	{"None",COLOR_SERVER}, //95
 	{"None",COLOR_SERVER}, //96
	{"FAQ",COLOR_SERVER},//97
	{"Еда для новичков",COLOR_SERVER},//98
	{"Еда для новичков",COLOR_SERVER},//99
	{"Еда для новичков",COLOR_SERVER},//100
	{"Еда для новичков",COLOR_SERVER},//101
	{"Еда для новичков",COLOR_SERVER},//102
	{"Еда для новичков",COLOR_SERVER},//103
	{"Еда для новичков",COLOR_SERVER},//104
	{"Раздевалка",COLOR_SERVER},//105
	{"Лифт",COLOR_SERVER}//106
};

new gPickID[sizeof(gPickup)] = {-1, ...};

enum alcatraz_object {
	alc_id,
	Float:alc_posX,
	Float:alc_posY,
	Float:alc_posZ,
	Float:alc_posRX,
	Float:alc_posRY,
	Float:alc_posRZ
}
new alcatraz[18][alcatraz_object] = {
	{-1,757.297851, 586.495361, 1063.594970, 0.000000, 0.000000, 180.000000},
	{-1,755.526367, 586.515380, 1063.594970, 0.000000, 0.000000, 0.000000},
	{-1,762.678710, 586.495361, 1063.594970, 0.000000, 0.000000, 0.000000},
	{-1,773.070312, 586.495361, 1063.594970, 0.000000, 0.000000, 0.000000},
	{-1,774.821289, 586.495361, 1063.594970, 0.000000, 0.000000, 180.000000},
	{-1,778.353271, 586.495361, 1063.594970, 0.000000, 0.000000, 0.000000},
	{-1,757.297851, 586.495361, 1067.225708, 0.000000, -0.000014, 180.000000},
	{-1,755.526367, 586.515380, 1067.225708, 0.000000, 0.000014, 0.000000},
	{-1,762.678710, 586.495361, 1067.225708, 0.000000, 0.000014, 0.000000},
	{-1,773.070312, 586.495361, 1067.225708, 0.000000, 0.000014, 0.000000},
	{-1,774.821289, 586.495361, 1067.225708, 0.000000, -0.000014, 180.000000},
	{-1,778.363281, 586.495361, 1067.225708, 0.000000, -0.000014, 180.000000},
	{-1,757.297851, 586.495361, 1070.856689, 0.000000, -0.000029, 180.000000},
	{-1,755.526367, 586.515380, 1070.856689, 0.000000, 0.000029, 0.000000},
	{-1,762.678710, 586.495361, 1070.856689, 0.000000, 0.000029, 0.000000},
	{-1,773.070312, 586.495361, 1070.856689, 0.000000, 0.000029, 0.000000},
	{-1,774.821289, 586.495361, 1070.856689, 0.000000, -0.000029, 180.000000},
	{-1,778.363281, 586.495361, 1070.856689, 0.000000, -0.000029, 180.000000}
};

new Float:PickupX[MAX_PLAYERS],
	Float:PickupY[MAX_PLAYERS],
	oldpickup[MAX_PLAYERS],
	timepickup[MAX_PLAYERS];


enum grzone {
	grid,
	Float:grX,
	Float:grY,
	Float:grZ,
	Float:grD,
	grName[50],
	grVirt
};
new GREENZONE[100][grzone],
	TOTALZONE = 0;
	
enum gtInfo {
	gtID,
	gtGoID,
	Float:gtX,
	Float:gtY,
	Float:gtZ,
	Float:gtTPX,
	Float:gtTPY,
	Float:gtTPZ,
	gtState,
	gtStayed
}
new GotoInfo[MAX_PLAYERS][gtInfo];
new RankName[MAX_FRACTIONS][15][24];

#define house_rent 	0.001
#define hotel_rent 	0.003
#define bizz_rent 	0.002
#define airport_rent 0.003

new FracSalary[9][15];
new WorkSalary[7];
new Nalog[8];

enum _fInfo {
    fID,
	fName[24],
	fLeader[MAX_PLAYER_NAME],
	fAdmin[24],
	fTime[53],
	fBank,
	fBankCash,
	fDrugs,
	fMats,
	fHealth,
	fSklad,
	fPrice,
	fSkin,
	fMaxRang,
	fInviteRang,
	fUninviteRang,
	fGiveRang,
	fUseStock,
	fColor,
	fVw,
	fInt,
	fMessage[71],
	fDrugsBuy,
	fDrugsPrice,
	fAntiTK,
	fRating
}
// Итераторы
new 
	Iterator: adminsCount<MAX_PLAYERS>,
	Iterator: helpersCount<MAX_PLAYERS>,
	Iterator: youtubersCount<MAX_PLAYERS>;
//

new FI[MAX_FRACTIONS + 1][_fInfo],
	gFractionSkin[MAX_FRACTIONS][10] = {
		{0,0,0,0,0,0,0,0,0,0}, //Defence
		{281,280,284,282,285,303,288,283,306,309}, //LSPD
		{281,280,284,282,285,303,288,283,306,309}, //SFPD
		{281,280,284,282,285,303,288,283,306,309}, //LVPD
		{286,163,164,165,166,141,0,0,0,0}, //FBI
		{255,57,71,187,147,150,0,0,0,0}, //MAYOR
		{287,179,311,61,255,191,0,0,0,0}, //ARMY
		{287,179,311,61,255,191,0,0,0,0}, //ARMY
		{276,275,274,70,219,308,0,0,0,0}, //MEDICS LS
		{276,275,274,70,219,308,0,0,0,0}, //MEDICS SF
		{276,275,274,70,219,308,0,0,0,0}, //MEDICS LV
		{188,170,217,261,211,0,0,0,0,0}, //LS News
		{188,170,217,261,211,0,0,0,0,0}, //SF News
		{188,170,217,261,211,0,0,0,0,0}, //LV News
		{124,223,127,113,214,0,0,0,0,0}, //LCN
		{117,118,123,186,120,169,0,0,0,0}, //Yakuza
		{112,111,126,125,272,216,0,0,0,0}, //RM
		{103,102,104,195,0,0,0,0,0,0}, //Ballas
		{108,109,110,56,0,0,0,0,0,0}, //Vagos
		{105,106,107,269,271,270,65,0,0,0}, //Grove
		{48,114,116,115,41,0,0,0,0,0}, //Aztec
		{175,174,173,273,226,0,0,0,0,0}, //Rifa
		{255,98,57,163,228,305,304,17,76,0} //WH
	};
new f_diplomacy[8][8] ;
enum Vacancy {
	VacancyCreator,
	bool: VacancyStatus,
	VacancyText[120],
	VacancyFraction,
};
new VacancyInfo[14][Vacancy];
//=================================================
//бизнесы

enum HOUSE_DATA {
	houseID,
	houseClass,
	houseApartmentCount,
	housePrice,
	houseHint,
	houseImprove[6],
	houseGun[9],
	houseSkin[3],
	houseSafeCode,
	houseSafeMoney,
	houseHealth,
	houseDrugs,
	houseProducts,
	houseClose,
	Float:houseX,
	Float:houseY,
	Float:houseZ,
	Float:houseR,
	Float:houseParkX,
	Float:houseParkY,
	Float:houseParkZ,
	Float:houseParkR,
	houseOwnerID,
	houseOwner[MAX_PLAYER_NAME],
	houseHabitID[3],
	houseDay,
	bool:houseRob,
	/*hWall				[ 10 ],	// Стены
	hFloor				[ 10 ],	// Полы
	hRoof				[ 7 ],	// Потолки
	hStairs,
	hCountFurn,*/
	houseFamily
}

new gHouses[MAX_HOUSE_COUNT][HOUSE_DATA],
	gHouseArendator[MAX_HOUSE_COUNT][3][MAX_PLAYER_NAME],
	gHouseArea[MAX_HOUSE_COUNT],
	gHousePickup[MAX_HOUSE_COUNT],
	gHouseIcon[MAX_HOUSE_COUNT],
	gHouseCount;

new gHouseImprovePriceN[3] = {10000,20000,25000},
	gHouseImprovePriceD[3] = {25000,60000,65000},
	gHouseImprovePriceB[3] = {75000,110000,115000},
	gHouseImprovePriceA[3] = {125000,160000,165000},
	gHouseImproveName[3][36] = {"Автоматические двери","Снижение субсидий","Гараж"};

enum hotelInfo{
	hotelID,
	hotelName[64],
	hotelOwnerID,
	hotelOwner[MAX_PLAYER_NAME],
	hotelPrice,
	hotelCoast,
	hotelBank,
	hotelBankDay,
	hotelVisitors,
	Float:hotelAreaX,
	Float:hotelAreaY,
	Float:hotelAreaZ,
    hotelLevel,
    hotelVW[8],
	hotelDay,
	Float:carX,
	Float:carY,
	Float:carZ,
	Float:carC
};
new Text3D: gHotelText[HOTEL_COUNT],
	gHotelArea[HOTEL_COUNT],
	gHotelCount,
	gHotels[HOTEL_COUNT][hotelInfo];

enum roomInfo {
	roomsID,
    roomsOwner[MAX_PLAYER_NAME],
	Float:roomsEnterX,
	Float:roomsEnterY,
	Float:roomsEnterZ,
	Float:roomsEnterR,
    roomsDoors,
    roomsWorld,
    roomsDay,
    roomsHotel
};
new gRooms[240][roomInfo],
	gRoomsCount,
	Text3D:gRoomText[MAX_PLAYERS][11];


enum ac_info {
	acID,
    acName[64],
	acValue
};
new AntiCheat[53][ac_info];
enum airportInfo {
	airID,
	airName[64],
	airOwnerID,
	airOwner[MAX_PLAYER_NAME],
	airPrice,
	airCoast,
	airBank,
	Float:airAreaX,
	Float:airAreaY,
	Float:airAreaZ,
	airDay
};
new Text3D:gAirText[AIR_COUNT],
	gAirArea[AIR_COUNT],
	gAirCount,
	gAirs[AIR_COUNT][airportInfo];

new TotalFamily = 0;
enum family_data {
	famID,
	famColor,
	famCName[32],
	famName[32],
	famDate[32],
	famCOwner[MAX_PLAYER_NAME],
	famOwner[MAX_PLAYER_NAME],
	famDrugs,
	famMats,
	famInvRang,
	famUninvRang,
	famGiveRang,
	famSklad,
	famMessage[71],
	famExp,
	famLvl,
	famPoint,
	famDrugsMax,
	famMatsMax,
	famFuel,
	famFuelMax,
	famRemp,
	famRempMax,
	famArmour,
	famArmourMax,
	famHealth,
	famHealthMax,
	famMask,
	famMaskMax,
	famMoney,
	famMoneyMax,
	famHouse,
	famType
}
new gFamily[FAMILY_COUNT][family_data];
new FamRanks[FAMILY_COUNT][9][24];
new Text3D:fam_lable[MAX_PLAYERS] = {Text3D:-1, ...};
new FamilyColor[13][7] ={"FFFFFF","1965D9","33AA33","FF0000","FFFF00","FFD700","dc6a26","2C8BDE","98F5FF","DD90FF","63cb00","54FF9F","6B8E23"};
new FamilyColorG[13] ={COLOR_WHITE,0x1965D9AA,0x33AA33AA,0xFF0000AA,0xFFFF00FF,0xFFD700FF,0xdc6a26AA,0x2C8BDEAA,0x98F5FFFF,0xDD90FFFF,0x63cb00FF,0x54FF9FFF,0x6B8E23FF};

new fam_point_upgrade[21] = {3000,4500,6000,8500,10000,11800,13600,15400,17200,19000,20800,22600,24400,26200,28000,29800,31600,33400,35200,37000,99999999999999};

new FamilyMoneyUpdate[20] = {10000,50000,100000,200000,300000,400000,500000,1000000,2000000,3000000,5000000,8000000,10000000,15000000,20000000,25000000,30000000,35000000,40000000,50000000};
new FamilyDrugsUpdate[20] = {500,800,1100,1400,1700,2000,2300,2600,2900,3200,3500,3800,4100,4400,4700,5000,5300,5600,5900,6200};
new FamilyMatsUpdate[20] = {10000,20000,30000,40000,50000,60000,70000,80000,90000,100000,110000,120000,130000,140000,150000,160000,170000,180000,190000,200000};
new FamilyFuelUpdate[20] = {5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100};
new FamilyRempUpdate[20] = {5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100};
new FamilyArmourUpdate[20] = {3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60};
new FamilyMaskUpdate[20] = {5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100};
new FamilyHealthUpdate[20] = {10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200};


#define MAX_QUESTS 17
enum QuestInfo {
	QuestName[64],
	QuestText[1024],
	LastProgress
}
/*
new QI[MAX_QUESTS][QuestInfo] = {
	{"","",70},
	{"Сбор яблок",""G"Привет! Мы рады видеть тебя в нашем Штате,\nдля того чтобы заработать первые деньги тебе нужно отправиться\nв Яблочный сад и собрать 40кг яблок, за каждый килограмм тебе хорошо заплатят.\n\n"ORANGE"Задача: Собрать 40кг яблок\n"P"Награда: "GREEN"$8000",40},
	{"Сбор оружия",""G"Слышал о нашем заводе по производству оружия?\nНужна твоя помощь в сборке оружия,\nработа легальная и хорошо оплачиваемая. Отправляйся на завод и собери 15 единиц оружия.\n\n"ORANGE"Задача: Собрать 15 ед оружия\n"P"Награда: "GREEN"$8000",15},
	{"Особый грузчик",""G"Влиятельные люди платят неплохие деньги за каждую бочку нефти,\nвникни в суть дела и помоги перенести 10 бочек с нефтью, возможно ты следующий нефтяной магнат.\n\n"ORANGE"Задача: Перенести 10 бочек с нефтью\n"P"Награда: "GREEN"$8000",10},
	{"ЛесоFC",""G"Ну ты прям трудоголик, дружище, последнее задание для тебя.\nСрочно требуется рабочая сила на завод по переработке древесины,\nсFCи и перенеси 20 ед древесины и получи от меня награду.\n\n"ORANGE"Задача: СFCить и перенести 20 ед древесины\n"P"Награда: "GREEN"$10000",20},

	{"Вор",""G"Первое задание для тебя!\nПроберись на склад армий,\nи укради 500 ед боеприпасов.\n\n"ORANGE"Задача: Украсть 500 ед боеприпасов.\n"P"Награда: "GREEN"$5000",500},
	{"Грабитель",""G"На наших районах появились богатые жильцы.\nНе хочешь украсть у них денег?\nСтупай и ограбь 15 домов.\n\n"ORANGE"Задача: Ограбить 15 домов (/robhouse)\n"P"Награда: "GREEN"$7000",15},
	{"Продавец",""G"Заработай на продаже оружия.\nНайди 10 людей, которе хотят пострелять, и продай им любое оружие.\n\n"ORANGE"Задача: Продать оружие 10 игрокам\n"P"Награда: "GREEN"$7000",10},
	{"Тащер",""G"Говорят ты уже опытный бандит.\nТак вот, убей 20 игроков во время войны (капта),\nя тебе за это хорошо заплачу. Да и авторитет свой повысишь\n\n"ORANGE"Задача: Убить 20 игроков во время капта\n"P"Награда: "GREEN"$10000",20},
	{"Провокатор",""G"Время последнего задания!\nСпровоцируй войну за территорию с другой бандой.\nСтань лучшим провокатором своей банды!\n\n"ORANGE"Задача: Спровоцировать войну за территорию\n"P"Награда: "GREEN"$20000",1}
};*/
new QI[MAX_QUESTS][QuestInfo] = {
	{"","",70},
	{"Первая работа",""G"Из соседнего штата привезли груз и теперь его необходимо разгрузить,\nотправляйся на склад и помоги с разгрузкой, достаточно 10 мешков и тебя наградят.\n\n"ORANGE"Задача: Перенести 10 мешков на склад\n"P"Награда: "GREEN"$3000 "P"и "GREEN"3 EXP",10},
	{"Сотовая связь",""G"Ты выполнил своё первое задание, теперь у тебя достаточно денег\nпоэтому тебе нужно купить новый мобильный телефон в ближайшем 24/7\nОтправляйся в ближайший магазин 24/7 приобрети мобильный телефон.\n\n"ORANGE"Задача: Приобрести мобильный телефон\n"P"Награда: "GREEN"$4000 "P"и "GREEN"1 EXP",1},
	{"Сборка оружия",""G"Слышал о нашем заводе по производству оружия?\nНужна твоя помощь в сборке оружия,\nработа легальная и хорошо оплачивается. Отправляйся на завод и собери 10 единиц оружия.\n\n"ORANGE"Задача: Собрать 10 ед оружия\n"P"Награда: "GREEN"$1500 "P"и "GREEN"2 EXP",10},
	{"Медицинская карта",""G"Ох, начальник на следующей работе очень требовательный\nтебе придётся заглянуть в больницу, чтобы получить мед. карту\nОтправляйся в ближайшую больницу и оформи мед. карту.\n\n"ORANGE"Задача: Оформить медицинскую карту\n"P"Награда: "GREEN"$1000 "P"и "GREEN"1 EXP",1},
    {"Сбор урожая",""G"В нашем яблочном саду нехватает рук\nпомоги им с сезоном сбора урожая, тебе нужно отправиться\nв Яблочный сад и собрать 40кг яблок, за каждый килограмм тебе хорошо заплатят.\n\n"ORANGE"Задача: Собрать 40кг яблок\n"P"Награда: "GREEN"$1500 "P"и "GREEN"2 EXP",40},
	{"Пора перекусить",""G"Привет! Ты уже наверное проголодался,\nпоэтому тебе следует перекусить и отдохнуть в ближайшей закусочной\nОтправляйся в ближайшую закусочную и хорошенько поешь.\n\n"ORANGE"Задача: Перекусить в ближайшей закусочной\n"P"Награда: "GREEN"$1000 "P"и "GREEN"1 EXP",1},
	{"Нефтяное дело",""G"Влиятельные люди платят неплохие деньги за каждую бочку нефти,\nвникни в суть дела и помоги перенести 10 бочек с нефтью, возможно ты следующий нефтяной магнат.\n\n"ORANGE"Задача: Перенести 10 бочек с нефтью\n"P"Награда: "GREEN"$1500 "P"и "GREEN"2 EXP",10},
	{"Лесопилка",""G"Дружище, я надеюсь тебе приятен запах леса?\nА то тут срочно требуется рабочая сила на завод по переработке древесины,\nПеренеси 10 ед древесины и получи от меня награду.\n\n"ORANGE"Задача: добыть и перенести 10 ед древесины\n"P"Награда: "GREEN"$1500 "P"и "GREEN"2 EXP",10},
	{"Новый стиль",""G"Ты отлично поработал, пора выходить в люди,\nдля этого тебе нужно купить новую одежду\nОтправляйся в ближайший магазин одежды и купи новую одежду.\n\n"ORANGE"Задача: Приобрести новую одежду\n"P"Награда: "GREEN"$3000 "P"и "GREEN"1 EXP",1},
    {"Водительские права",""G"Думаю скоро у тебя появятся деньги на машину,\nпоэтому я бы рекомендовал тебе получить водительские права\nОтправляйся в автошколу (/gps > Общественные места) и получи права.\n\n"ORANGE"Задача: Получить водительские права\n"P"Награда: "GREEN"$2000 "P"и "GREEN"2 EXP",1},
    {"Навыки стрельбы",""G"У меня для тебя последнее задание, вижу ты совсем не умеешь стрелять,\nя знаю хорошее местечко, где тебя научат стрелять\nОтправляйся в тир ближайшего магазина оружия, там ты улучшишь навыки стрельбы.\n\n"ORANGE"Задача: Выстрелить 30 раз из любого оружия\n"P"Награда: "GREEN"$3000 "P"и "GREEN"2 EXP",30},
	// ghetto quest
	{"Вор",""G"Первое задание для тебя!\nПроберись на склад армий,\nи укради 500 ед боеприпасов.\n\n"ORANGE"Задача: Украсть 500 ед боеприпасов.\n"P"Награда: "GREEN"$5000",500},
	{"Грабитель",""G"На наших районах появились богатые жильцы.\nНе хочешь украсть у них денег?\nСтупай и ограбь 15 домов.\n\n"ORANGE"Задача: Ограбить 15 домов (/robhouse)\n"P"Награда: "GREEN"$7000",15},
	{"Продавец",""G"Заработай на продаже оружия.\nНайди 10 людей, которе хотят пострелять, и продай им любое оружие.\n\n"ORANGE"Задача: Продать оружие 10 игрокам\n"P"Награда: "GREEN"$7000",10},
	{"Тащер",""G"Говорят ты уже опытный бандит.\nТак вот, убей 20 игроков во время войны (капта),\nя тебе за это хорошо заплачу. Да и авторитет свой повысишь\n\n"ORANGE"Задача: Убить 20 игроков во время капта\n"P"Награда: "GREEN"$10000",20},
	{"Провокатор",""G"Время последнего задания!\nСпровоцируй войну за территорию с другой бандой.\nСтань лучшим провокатором своей банды!\n\n"ORANGE"Задача: Спровоцировать войну за территорию\n"P"Награда: "GREEN"$20000",1}
};
new QuestProgress[MAX_PLAYERS][MAX_QUESTS];
new QuestShow[MAX_PLAYERS][MAX_QUESTS];
new AcceptQuest[MAX_PLAYERS][MAX_QUESTS];
new QuestClick[MAX_PLAYERS];

enum AIRPLANE_DATA {
	aID,
	aAirport,
	aPlane,
    aOwner[24],
	aTime,
    aPrice,
    aCar,
    Float:aFuel,
    Float:aPos[4],
    Text3D:aText
}
new gAirplanes[34][AIRPLANE_DATA];

new skin_register[2][8] =
{
    {78, 79, 137, 94, 200, 212, 26, 230}, // male
	{40, 75, 77, 90, 129, 196} // female
};
enum v_car {
	vSpawn,
	vColor[2],
	vPaintJob,
	vTuneList[13],
	vTeam,
	vRank,
	vJob,
	vBus,
	vBizz,
	vLights,
	vType,
	Float:vFuel,
	Float:vDrived,
	vPlayer,
	Float:veX,
	Float:veY,
	Float:veZ,
	Float:veA,
	Float:vEngineBoost,
	Float:vBrakeBoost,
	Float:vStabilityBoost,
	Float:vzAngle,
	vPEngine[5],
	vPBrake[5],
	vPerfStatus,
	bool:vRobHouse
}
new VehicleInfo[MAX_VEHICLES][v_car];
new VehicleState[MAX_VEHICLES];

enum v_gun {
	vgID,
	vgAmount[2],
	Text3D:vgText,
	bool:vgLoading,
	bool:vgUnloading,
	vgPickup,
	vgArea,
	vgDrugs,
	bool:vgRobHouse
}
new VG[MAX_VEHICLES][v_gun];

enum ARs {
	arZavod,
	arZavodSklad,
	arArmySFSklad,
	arArmyLVSklad,
	arOil[6],
	arLoadProds[2],
	arSad,
	arJob[6],
	arClothes[9],
	arPobeg[2],
	arManiken[18],
	arNews[2],
	arGripp[3],
	arPerfomans[2]
}
new gAreas[ARs];

new Text3D:gun_3dtext[3],
	gun_pickup[24],
	Float:gun_checkpoints[24][3] = {
		{2708.8772,-2411.6133,13.6328}, // место оружейка 1
		{2710.6575,-2411.6133,13.6328}, // место оружейка 2
		{2708.9011,-2415.6052,13.6328}, // место оружейка 3
		{2710.8159,-2415.6047,13.6328}, // место оружейка 4
		{2708.8315,-2417.0789,13.6328}, // место оружейка 5
		{2710.6995,-2417.0791,13.6328}, // место оружейка 6
		{2715.2690,-2411.6135,13.6328}, // место оружейка 7
		{2716.9167,-2411.6111,13.6328}, // место оружейка 8
		{2715.3184,-2415.6064,13.6328}, // место оружейка 9
		{2717.1924,-2415.6052,13.6328}, // место оружейка 10
		{2715.2151,-2417.0791,13.6328}, // место оружейка 11
		{2717.1125,-2417.0774,13.6328}, // место оружейка 12
		{2710.7349,-2399.6270,13.6328}, // место оружейка 13
		{2708.9243,-2399.6238,13.6328}, // место оружейка 14
		{2708.8003,-2395.5623,13.6328}, // место оружейка 15
		{2710.7014,-2395.5630,13.6328}, // место оружейка 16
		{2710.7378,-2393.6458,13.6328}, // место оружейка 17
		{2708.9084,-2393.6472,13.6328}, // место оружейка 18
		{2715.3267,-2399.6262,13.6328}, // место оружейка 19
		{2717.1904,-2399.6257,13.6328}, // место оружейка 20
		{2717.0771,-2395.5630,13.6328}, // место оружейка 21
		{2715.2449,-2395.5635,13.6328}, // место оружейка 22
		{2717.2051,-2393.6475,13.6328}, // место оружейка 23
		{2715.3521,-2393.6460,13.6328} // место оружейка 24
	},
	GunWorkWeapon[6] = {348,353,355,356,346,349},
	zavodsklad;

new Float:clothes_checkpoints[9][3] = {
		{1302.2273,2450.8921,1011.8739},
		{1302.2482,2453.2739,1011.8739},
		{1302.2648,2455.7158,1011.8739},
		{1298.9824,2455.7158,1011.8739},
		{1298.9872,2453.2739,1011.8739},
		{1299.0380,2450.8921,1011.8739},
		{1295.6338,2450.8921,1011.8739},
		{1295.6832,2453.2734,1011.8739},
		{1295.7318,2455.7158,1011.8739}
	},
	Float:clothes_works[9][3] = {
		{1302.33557, 2451.59131, 1011.60541},
		{1302.35229, 2453.98755, 1011.60541},
		{1302.24475, 2456.43945, 1011.60541},
		{1299.07898, 2456.44971, 1011.60541},
		{1298.96863, 2454.02734, 1011.60541},
		{1298.98938, 2451.65430, 1011.60541},
		{1295.62463, 2451.61255, 1011.60541},
		{1295.77319, 2454.06006, 1011.60541},
		{1295.81433, 2456.51196, 1011.60541}
	};

new fork_pickup,
	fork_pickups,
	Float:fork_allpickups[11][3] = {
		{1214.8530,2306.4580,1008.9139}, // вилка 1
		{1203.8088,2301.6340,1008.9139}, // вилка 2
		{1203.7101,2295.4634,1008.9139}, // вилка 3
		{1203.7124,2292.0486,1008.9139}, // вилка 4
		{1203.6594,2288.8381,1008.9139}, // вилка 5
		{1211.5032,2287.3240,1008.9139}, // вилка 6
		{1214.4635,2287.8840,1008.9139}, // вилка 7
		{1217.6741,2292.7222,1008.9139}, // вилка 8
		{1214.4635,2292.8457,1008.9139}, // вилка 9
		{1214.4635,2298.5601,1008.9139}, // вилка 10
		{1217.6741,2298.5061,1008.9139} // вилка 11
	};

new maniken[MAX_PLAYERS],
	Float:alcatraz_maniken[18][3] = {
		{753.66687, 588.01678, 1063.15625},
		{759.23547, 588.01678, 1063.15625},
		{760.66748, 588.01678, 1063.15625},
		{771.20062, 588.01678, 1063.15625},
		{776.71661, 588.01678, 1063.15625},
		{780.18860, 588.01678, 1063.15625},
		{780.22607, 588.01678, 1066.81628},
		{776.72803, 588.01678, 1066.79639},
		{771.18481, 588.01678, 1066.79639},
		{760.60321, 588.01678, 1066.79639},
		{759.21057, 588.03638, 1066.79639},
		{753.57727, 588.27856, 1066.79639},
		{753.55029, 588.15723, 1070.43628},
		{759.25525, 587.98145, 1070.43628},
		{760.63263, 588.07227, 1070.43628},
		{771.15869, 588.27612, 1070.43628},
		{776.71460, 588.00989, 1070.43628},
		{780.19446, 587.92993, 1070.43628}
	},
	Float:AlcatrazSpawns[18][4] = {
		{755.0739,589.0833,1063.3656,181.6186},
		{757.9329,589.1299,1063.3656,179.1118},
		{762.0038,589.0305,1063.3656,179.4253},
		{772.6663,589.0371,1063.3656,177.5454},
		{775.3486,588.9456,1063.3656,180.0523},
		{778.8930,588.8256,1063.3656,179.4256},
		{778.7370,588.8964,1067.0107,179.7387},
		{775.4164,588.8442,1067.0107,177.5455},
		{772.7256,588.9982,1067.0107,178.1488},
		{762.1152,588.9001,1067.0107,179.6921},
		{757.7969,588.7919,1067.0107,179.9820},
		{755.0713,589.0401,1067.0107,180.2721},
		{754.9739,589.1035,1070.6417,180.2487},
		{757.8131,589.0568,1070.6417,180.8754},
		{762.1030,588.8369,1070.6417,180.2488},
		{772.7346,589.0098,1070.6417,180.2493},
		{775.2703,589.1150,1070.6417,181.8159},
		{778.8127,588.7805,1070.6417,178.9958}
	};

new l_actor[3][8],
	l_actort[3][8],
	l_actors[3][8],
	Float:l_actor_pos[8][4] = {
		{1620.3792,998.7274,1475.6283,180.9220}, // актер рабочий за столом
		{1621.3796,990.7556,1475.6283,272.4163}, // актер рабочий за столом
		{1627.0360,998.4398,1475.6283,1.7172}, // актер у куста
		{1626.9094,992.0641,1475.6283,179.0421}, // актер у куста
		{1630.2444,998.4404,1475.6283,358.5839}, // актер у куста
		{1630.0763,992.0634,1475.6283,180.2955}, // актер у куста
		{1633.3794,998.4421,1475.6283,1.4039}, // актер у куста
		{1633.1389,992.0649,1475.6283,181.5488} // актер у куста
	};

new Float:news_edit[4][3] = {
 	{2229.1873,779.2301,1153.9510},
	{2233.1079,777.6376,1153.9510},
	{2233.3799,774.7096,1153.9510},
	{2229.9558,769.0854,1153.9510}
};

new Float:comp_club[15][3] = {
	{840.469,-221.190,1000.190},
	{840.489,-219.210,1000.190},
	{840.500,-217.229,1000.190},
	{840.520,-215.240,1000.190},
	{840.530,-213.250,1000.190},
	{840.549,-211.270,1000.190},
	{840.559,-209.279,1000.190},
	{840.580,-207.289,1000.190},
	{840.590,-205.300,1000.190},
	{847.179,-204.389,1000.190},
	{845.190,-204.389,1000.190},
	{847.200,-207.250,1000.190},
	{845.210,-207.240,1000.190},
	{847.200,-210.169,1000.190},
	{845.210,-210.169,1000.190}
};

new Float:tuning_enter[3][3] = {
	{1153.4031,-1208.7499,19.0252},//LS
	{-1786.8206,1206.0835,25.1250},//SF
	{1643.8298,2197.1387,10.8203}//LV
};
new Float:tuning_exit_1[3][4] = {
	{1146.8389,-1218.7427,17.7843,180.1412},//1
	{1151.7120,-1219.6622,17.6905,179.8527},//2
	{1156.8915,-1219.8698,17.6866,179.4841}//3
};
new Float:tuning_exit_2[3][4] = {
	{-1779.4021, 1204.3573, 24.8605, 180.0000},//1
	{-1775.1401, 1204.3573, 24.8605, 180.0000},//2
	{-1770.8749, 1204.3573, 24.8605, 180.0000}//3
};
new Float:tuning_exit_3[3][4] = {
	{1638.3571, 2195.1743, 10.5474, 180.0000},//1
	{1632.6182, 2195.1743, 10.5474, 180.0000},//2
	{1626.9589, 2195.1743, 10.5474, 180.0000}//3
};
