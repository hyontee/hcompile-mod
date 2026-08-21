#define CALL_APP 		50
#define SETTINGS_APP 	100
#define CHAT_APP 		150
#define MVD_APP 		200
#define MUSIC_APP 		250
#define GPS_APP 		300
#define SERVICES_APP 	350
#define AUCTIONS_APP 	400
#define ADS_APP			450
#define VACANCY_APP		500
#define FORBES_APP		550
#define MARKET_APP		600
#define BANK_APP		700
#define TAXI_APP		750
#define TAXI_DRIVER_APP	800

#define ITEMS_SMS_PAGE	10

new bool: tablet_sanction [ MAX_PLAYERS ] ;
new bool: tablet_opened [ MAX_PLAYERS ] ;

enum
{
	CALL_APP_REQ_FOR_GET_CONTACTS = CALL_APP,
    CALL_APP_REQ_CALL_USER = CALL_APP + 1,
    CALL_APP_REQ_SMS_USER = CALL_APP + 2,
    CALL_APP_REQ_BLACKLIST_USER = CALL_APP + 3,
    CALL_APP_REQ_DELETE_USER = CALL_APP + 4,
    CALL_APP_REQ_ADD_CONTACT = CALL_APP + 5,
    CALL_APP_REQ_EXIT_PHONE_APP = CALL_APP + 6,

	GET_CHATS = CHAT_APP,
    GET_MESSAGES = CHAT_APP + 1,
    GET_CONTACTS = CHAT_APP + 2,
    CLOSE_APP = CHAT_APP + 3,
    SEARCH_CONTACT = CHAT_APP + 4,
    SEND_MESSAGE = CHAT_APP + 5,

	REQ_GET_INITIAL_INFO = MVD_APP,
    REQ_GET_WANTED_INFO = MVD_APP + 1,
    REQ_ADD_WANTED_LEVEL = MVD_APP + 2,
    REQ_GET_PLAYER_FINES_FROM_DB = MVD_APP + 3,
    REQ_GET_CAR_FINES_FROM_DB = MVD_APP + 4,
    REQ_GET_CATEGORIES_N_REASONS = MVD_APP + 5,
    REQ_FIND_WANTED_PLAYER = MVD_APP + 6,

	CHANGE_PLAY_MODE_REQ = MUSIC_APP,
    GET_CURRENT_PLAYING_TRACK = MUSIC_APP + 1,
    PLAY_TRACK_REQ = MUSIC_APP + 2,
    PAUSE_TRACK_REQ = MUSIC_APP + 3,

	GET_AUCTIONS = AUCTIONS_APP,
    SEARCH_BY_CATEGORY = AUCTIONS_APP + 1,
    MAKE_BET_AUCTION = AUCTIONS_APP + 2,
    SHOW_GEO_AUCTION = AUCTIONS_APP + 3,
    EXIT_AUCTIONS = AUCTIONS_APP + 4,
    SORT_AUCTIONS = AUCTIONS_APP + 5,
    GET_MY_AUCTIONS = AUCTIONS_APP + 6
} ;

//========================================================================================================================================
#include									"modules/other/tablet/modules/m_mvd.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_market.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_sms.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_contacts.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_gps.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_auctions.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_forbes.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_music.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_bank.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_settings.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_vacancy.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_taxi.pwn"
//========================================================================================================================================
#include									"modules/other/tablet/modules/m_taxi_driver.pwn"
//========================================================================================================================================

stock show_tablet_init ( playerid )
{
	#if defined debug_packet
		printf ( "[show_tablet_init] playerid: %d", playerid ) ;
	#endif

	new bool: findSim = p_info [ playerid ] [ number ] < 1 ? false : true ;
	new Node: node = JSON_Object (
            "simCard", JSON_Bool ( findSim ),
            "availableApp", JSON_Array ( )
    ) ;

    if ( findSim )
	{
		JSON_ArrayAppend ( node, "availableApp", JSON_Int ( CALL_APP ) ) ;
    	JSON_ArrayAppend ( node, "availableApp", JSON_Int ( CHAT_APP ) ) ;
		JSON_ArrayAppend ( node, "availableApp", JSON_Int ( SERVICES_APP ) ) ;
	}
	JSON_ArrayAppend ( node, "availableApp", JSON_Int ( MUSIC_APP ) ) ; // Музыка
	JSON_ArrayAppend ( node, "availableApp", JSON_Int ( SETTINGS_APP ) ) ; // Настройки
    JSON_ArrayAppend ( node, "availableApp", JSON_Int ( GPS_APP ) ) ;
    JSON_ArrayAppend ( node, "availableApp", JSON_Int ( AUCTIONS_APP ) ) ;
    JSON_ArrayAppend ( node, "availableApp", JSON_Int ( ADS_APP ) ) ; // объявления
    JSON_ArrayAppend ( node, "availableApp", JSON_Int ( FORBES_APP ) ) ; // forbes
    JSON_ArrayAppend ( node, "availableApp", JSON_Int ( MARKET_APP ) ) ; // market
    JSON_ArrayAppend ( node, "availableApp", JSON_Int ( VACANCY_APP ) ) ; // вакансии
    if ( bank_player_account [ playerid ] > 0 ) JSON_ArrayAppend ( node, "availableApp", JSON_Int ( BANK_APP ) ) ; // мобильный банк
    if ( p_info [ playerid ] [ job ] == job_taxi ) JSON_ArrayAppend ( node, "availableApp", JSON_Int ( TAXI_DRIVER_APP ) ) ; // taxi driver
	else JSON_ArrayAppend ( node, "availableApp", JSON_Int ( TAXI_APP ) ) ; // taxi
	
	if ( server_test == 1 )
	{
		
	}

    if ( cop_player ( playerid ) || fbi_player ( playerid ) ) 
    {
        JSON_ArrayAppend ( node, "availableApp", JSON_Int ( MVD_APP ) ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, 0, global_string ) ;

	if ( ! users_education [ playerid ] [ EDUCATION_TABLET_SIM ] )
	{
		if ( p_info [ playerid ] [ number ] < 1 )
		{
			show_window_monologue (
				playerid,
				5,
				"Я смотрю ты решил ознакомиться с планшетом? \
				Для полного ознакомления тебе необходима SIM-карта, \
				которую ты можешь купить в любом магазине 24/7.",
				"Местный",
				"Понял"
			) ;
		}

		save_user_education ( playerid, EDUCATION_TABLET_SIM ) ;
	}

	tablet_opened [ playerid ] = true ;
}

stock show_packet_tablet ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // destroy
	{
		p_t_info [ playerid ] [ in_messenger ] =
		p_t_info [ playerid ] [ in_market ] =
		p_t_info [ playerid ] [ in_auctions ] =
		p_t_info [ playerid ] [ in_taxi ] =
		p_t_info [ playerid ] [ in_taxi_driver ] =
		tablet_opened [ playerid ] = false ;

		p_t_info [ playerid ] [ market_with_id ] =
		p_t_info [ playerid ] [ messenger_with_char ] = 0 ;
	}
	else if ( actionId >= CALL_APP && actionId <= CALL_APP + 49 ) // contacts
	{
		handleTabletContacts ( playerid, actionId, data ) ;
	}
	else if ( actionId >= SETTINGS_APP && actionId <= SETTINGS_APP + 49 ) // settings
	{
		handleTabletSettings ( playerid, actionId, data ) ;
	}
	else if ( actionId >= CHAT_APP && actionId <= CHAT_APP + 49 ) // sms
	{
		handleTabletSms ( playerid, actionId, data ) ;
	}
	else if ( actionId >= MVD_APP && actionId <= MVD_APP + 49 ) // mvd
	{
		handleTabletMvd ( playerid, actionId, data ) ;
	}
	else if ( actionId >= MUSIC_APP && actionId <= MUSIC_APP + 49 ) // music
	{
		handleTabletMusic ( playerid, actionId, data ) ;
	}
	else if ( actionId >= GPS_APP && actionId <= GPS_APP + 49 ) // gps
	{
		handleTabletGps ( playerid, actionId, data ) ;
	}
	else if ( actionId >= AUCTIONS_APP && actionId <= AUCTIONS_APP + 49 ) // auctions
	{
		handleTabletAuctions ( playerid, actionId, data ) ;
	}
	else if ( actionId == SERVICES_APP )
	{
		callcmd::service ( playerid ) ;
	}
	else if ( actionId == ADS_APP ) // объявления
	{
		show_dialog ( playerid, d_advertise_send, DIALOG_STYLE_INPUT, "{"#cBHD"}Объявление", "{"#cWH"}Введите текст объявления, который хотите опубликовать:", "Отправить", "Закрыть" ) ;
	}
	else if ( actionId >= VACANCY_APP && actionId <= VACANCY_APP + 49 ) // вакансии
	{
		handleTabletVacancy ( playerid, actionId, data ) ;
	}
	else if ( actionId >= FORBES_APP && actionId <= FORBES_APP + 49 ) // список форбс
	{
		handleTabletForbes ( playerid, actionId, data ) ;
	}
	else if ( actionId >= MARKET_APP && actionId <= MARKET_APP + 49 ) // market place
	{
		handleTabletMarket ( playerid, actionId, data ) ;
	}
	else if ( actionId >= BANK_APP && actionId <= BANK_APP + 49 ) // мобильный банк
	{
		handleTabletBank ( playerid, actionId, data ) ;
	}
	else if ( actionId >= TAXI_APP && actionId <= TAXI_APP + 49 ) // taxi
	{
		handleTabletTaxi ( playerid, actionId, data ) ;
	}
	else if ( actionId >= TAXI_DRIVER_APP && actionId <= TAXI_DRIVER_APP + 49 ) // taxi driver
	{
		handleTabletTaxiDriver ( playerid, actionId, data ) ;
	}
	return 1 ;
}

stock GetPlayerIDBySqlID ( sql_id )
{
	new playerid = INVALID_PLAYER_ID ;
	foreach(new i: logged_players)
	{
		if ( p_info [ i ] [ id ] != sql_id ) continue ;
		
		playerid = i ;
		break ;
	}
    
	return playerid ;
}

stock tabletMessage ( playerid, header [ ], message [ ], duration, appType )
{
	new Node: node = JSON_Object (
		"name",			JSON_String ( header ),
		"message",		JSON_String ( message ),
		"duration",		JSON_Int ( duration ),
		"appType",		JSON_Int ( appType )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, 2000, global_string ) ;
	return 1 ;
}