//#include <custom/ui_interface>

#define RARE_TYPE_GRAY			0
#define RARE_TYPE_PURPLE		1
#define RARE_TYPE_RED			2

new Float: rarityChanceDefault [ 3 ] = { 0.87, 0.11, 0.02 } ;
new Float: rarityChanceMedium [ 3 ] = { 0.70, 0.23, 0.07 } ;

#define NON_RENDER_TYPE			-1
#define RENDER_TYPE_OBJECT 		0
#define RENDER_TYPE_VEHICLE 	1
#define RENDER_TYPE_SKINS		2
#define RENDER_TYPE_PLATE		3
#define RENDER_TYPE_WEAPON		4

#define UI_PAUSE_MENU 			0
#define UI_DONATE_MENU 			1
#define UI_SPEEDOMETR			2
#define UI_WEAPON_SHOP			3
#define UI_PRODUCT_STORE		4
#define UI_RADIAL_MENU			5
#define UI_HUD_SCREEN			6
#define UI_CHAT_SCREEN			7
#define UI_MENU_MAP				8
#define UI_SETTINGS_MENU		9
#define UI_CONTROL_MENU			10
#define UI_INVENTORY			11
#define UI_DOCUMENT				12
#define UI_GAME_LOAD			13
#define UI_TABLET				14
#define UI_CALL_SCREEN			15
#define UI_PTS					16
#define UI_LICENSE_LIST			17
#define UIEMPLOYMENT_HISTORY	18
#define UI_BATTLE_PASS			19
#define UI_MARKET				20
#define UI_TRADE				21
#define UI_FAMILY_MENU			22
#define UI_RECONNECT			23
#define UI_QUESTS_MONOLOGUES	24
#define UI_QUEST				25
#define UI_TAB					26
#define UI_ADMIN_PANEL			27
#define UI_CAR_SHOWROOM			28
#define UI_CLOTHES_N_ACS		29
#define UI_LICENCE_PLATES		30
#define UI_TIRE_SHOP			31
#define UI_TUNING				32
#define UI_CASINO_ROULETTE		33
#define UI_CASINO_SLOTS			34
#define UI_CARS_MENU			35
#define UI_ORG_MENU				36
#define UI_GAME_MENU			37
#define UI_TRUCK_MENU			38
#define UI_CONTAINERS			39
#define UI_CASINO_DICE			40
#define UI_CASINO_BLACKJACK		41

#define UI_FISHING_GAME			43
#define UI_FISHING_INVENTORY	44

#define UI_CAPTURE				46
#define UI_FAMILY_CAPTURE		47
#define UI_DAILY_REWARDS		48
#define UI_FUEL_STATION			49
#define UI_CHARGE_STATION		50

#define UI_DIALOG_JOBS			52
#define UI_TAXI_JOBS			53
#define UI_SPEED_LIMIT			54
#define UI_CRAFT_SCREEN			55
#define UI_FRACTION_TASKS		56
#define UI_OFFLINE_NOTIFICATION	57
#define UI_CAR_MARKET			58
#define UI_ROULETTE_PLAYER		59
#define UI_ROULETTE_JOB			60
#define UI_BINDER_MENU			61
#define UI_BINDER_EDIT_MENU		62
#define UI_COMPONENT_SHOP		63

#define UI_GXT					66
#define UI_WORKSHOP				67

//========================================================================================================================================
#include									"modules/other/station/m_gas_station.pwn"
//========================================================================================================================================
#include									"modules/other/station/m_charge_station.pwn"
//========================================================================================================================================

stock notify_server ( playerid, uiElementId, actionId, data [ ] )
{
	//printf ( "[notify_server] playerid: %d, uiElementId: %d, actionId: %d, data: %s", playerid, uiElementId, actionId, data ) ;
	if ( uiElementId == UI_DONATE_MENU )
	{
		show_donate_packet ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_SPEEDOMETR )
	{
		show_packet_speedometr ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_WEAPON_SHOP )
	{
		show_packet_weapon_shop ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_PRODUCT_STORE )
	{
		show_packet_product_store ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_RADIAL_MENU )
	{
		show_packet_radial ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_HUD_SCREEN )
	{
		show_packet_hud ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CHAT_SCREEN )
	{
		show_packet_keyboard ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_MENU_MAP )
	{
		show_packet_menumap ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_INVENTORY )
	{
		show_packet_inventory ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_TABLET )
	{
		show_packet_tablet ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CALL_SCREEN )
	{
		show_packet_call ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_LICENSE_LIST )
	{
		callcmd::licenses ( playerid ) ;
	}
	else if ( uiElementId == UI_MARKET )
	{
		show_packet_market ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_TRADE )
	{
		show_packet_trade ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_FAMILY_MENU )
	{
		show_packet_familys ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_QUESTS_MONOLOGUES )
	{
		show_packet_monologue ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_QUEST )
	{
		show_packet_quest ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_ADMIN_PANEL )
	{
		show_packet_adminpanel ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CAR_SHOWROOM )
	{
		show_packet_car_showroom ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CLOTHES_N_ACS )
	{
		show_packet_clothes ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_LICENCE_PLATES )
	{
		show_packet_plates ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_TIRE_SHOP )
	{
		show_packet_tireshop ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_TUNING )
	{
		show_packet_tuning ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CASINO_ROULETTE )
	{
		show_packet_roulette ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CASINO_SLOTS )
	{
		show_packet_jackpot ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CARS_MENU )
	{
		show_packet_carsmenu ( playerid, actionId, data ) ;
	}
	/*else if ( uiElementId == UI_ORG_MENU )
	{
		show_packet_orgmenu ( playerid, actionId, data ) ;
	}*/
	else if ( uiElementId == UI_GAME_MENU )
	{
		show_packet_game_menu ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_TRUCK_MENU )
	{
		show_packet_truck_menu ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CONTAINERS )
	{
		show_packet_container ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CASINO_DICE )
	{
		show_packet_dice ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CASINO_BLACKJACK )
	{
		show_packet_blackjack ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_FISHING_GAME )
	{
		show_packet_fishing_game ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_FISHING_INVENTORY )
	{
		show_packet_fishing_inventory ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_FUEL_STATION )
	{
		show_packet_gas_station ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CHARGE_STATION )
	{
		show_packet_charge_station ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_DIALOG_JOBS )
	{
		packetDialogJobs ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_TAXI_JOBS )
	{
		packetTaxiJobs ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_CRAFT_SCREEN )
	{
		packetCraft ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_FRACTION_TASKS )
	{
		packetFractionTasks ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_ROULETTE_PLAYER )
	{
		packetPlayerRoulette ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_ROULETTE_JOB )
	{
		packetJobRoulette ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_BINDER_MENU )
	{
		packetBinderMenu ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_BINDER_EDIT_MENU )
	{
		packetBinderEdit ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_COMPONENT_SHOP )
	{
		packetComponentShop ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == UI_WORKSHOP )
	{
		packetWorkShop ( playerid, actionId, data ) ;
	}
	return 1 ;
}

stock notify_server_ui_destroyed ( playerid, uiElementId )
{
	if ( uiElementId == UI_DONATE_MENU )
	{
		packetDonateDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_SPEEDOMETR )
	{
		
	}
	else if ( uiElementId == UI_WEAPON_SHOP )
	{
		show_packet_weapon_shop ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_PRODUCT_STORE )
	{
		show_packet_product_store ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_RADIAL_MENU )
	{
		
	}
	else if ( uiElementId == UI_HUD_SCREEN )
	{
		
	}
	else if ( uiElementId == UI_CHAT_SCREEN )
	{
		
	}
	else if ( uiElementId == UI_MENU_MAP )
	{
		
	}
	else if ( uiElementId == UI_INVENTORY )
	{
		show_packet_inventory ( playerid, 3, "0" ) ;
	}
	else if ( uiElementId == UI_TABLET )
	{
		show_packet_tablet ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_CALL_SCREEN )
	{
		
	}
	else if ( uiElementId == UI_MARKET )
	{
		show_packet_market ( playerid, 3, "" ) ;
	}
	else if ( uiElementId == UI_TRADE )
	{
		
	}
	else if ( uiElementId == UI_FAMILY_MENU )
	{
		
	}
	else if ( uiElementId == UI_QUESTS_MONOLOGUES )
	{
		show_packet_monologue ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_QUEST )
	{
		
	}
	else if ( uiElementId == UI_ADMIN_PANEL )
	{
		
	}
	else if ( uiElementId == UI_CAR_SHOWROOM )
	{
		//show_packet_car_showroom ( playerid, 5, "" ) ;
	}
	else if ( uiElementId == UI_CLOTHES_N_ACS )
	{
		
	}
	else if ( uiElementId == UI_LICENCE_PLATES )
	{
		show_packet_plates ( playerid, 7, "" ) ;
	}
	else if ( uiElementId == UI_TIRE_SHOP )
	{
		show_packet_tireshop ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_TUNING )
	{
		show_packet_tuning ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_CASINO_ROULETTE )
	{
		show_packet_roulette ( playerid, 2, "" ) ;
	}
	else if ( uiElementId == UI_CASINO_SLOTS )
	{
		show_packet_jackpot ( playerid, 3, "" ) ;
	}
	else if ( uiElementId == UI_CARS_MENU )
	{
		
	}
	/*else if ( uiElementId == UI_ORG_MENU )
	{
		show_packet_orgmenu ( playerid, actionId, data ) ;
	}*/
	else if ( uiElementId == UI_GAME_MENU )
	{
		
	}
	else if ( uiElementId == UI_TRUCK_MENU )
	{
		show_packet_truck_menu ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_CONTAINERS )
	{
		show_packet_container ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_CASINO_DICE )
	{
		
	}
	else if ( uiElementId == UI_CASINO_BLACKJACK )
	{
		show_packet_blackjack ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_FISHING_GAME )
	{
		show_packet_fishing_game ( playerid, 2, "" ) ;
	}
	else if ( uiElementId == UI_FISHING_INVENTORY )
	{
		show_packet_fishing_inventory ( playerid, 0, "" ) ;
	}
	else if ( uiElementId == UI_FUEL_STATION )
	{
		show_packet_gas_station ( playerid, 2, "" ) ;
	}
	else if ( uiElementId == UI_CHARGE_STATION )
	{
		show_packet_charge_station ( playerid, 2, "" ) ;
	}
	else if ( uiElementId == UI_DIALOG_JOBS )
	{

	}
	else if ( uiElementId == UI_TAXI_JOBS )
	{
		packetTaxiDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_CRAFT_SCREEN )
	{
		packetCraftDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_FRACTION_TASKS )
	{
		packetFractionTasksDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_OFFLINE_NOTIFICATION )
	{
		packetOffNotificationDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_ROULETTE_PLAYER )
	{
		packetPlayerRouletteDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_ROULETTE_JOB )
	{
		packetJobRouletteDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_BINDER_MENU )
	{
		packetBinderMenuDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_BINDER_EDIT_MENU )
	{
		packetBinderEditDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_COMPONENT_SHOP )
	{
		packetComponentShopDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_ACTION_CLICK )
	{
		packetActionClickDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_ACTION )
	{
		packetActionDestroy ( playerid ) ;
	}
	else if ( uiElementId == UI_WORKSHOP )
	{
		packetWorkShopDestroy ( playerid ) ;
	}
	return 1 ;
}

#define PACKET_CUSTOMRPC    			251
#define RPC_AUTHORIZATION_PACKET		0x173

stock set_authorization_data ( playerid, data [ ] )
{
	new Node: json = JSON_Object ( ) ;
	JSON_Parse ( data, json ) ;

	new _name [ MAX_PLAYER_NAME ], _password [ 32 ], _spawnType ;
	JSON_GetString ( json, "login", _name ) ;
	JSON_GetString ( json, "password", _password ) ;
	JSON_GetInt ( json, "spawnType", _spawnType ) ;
	SetPVarInt ( playerid, "spawnType", _spawnType ) ;

	static const _str [ ] = "SELECT * FROM `users` WHERE `u_name` = '%s' AND `u_password` = '%s' LIMIT 1" ;
    new query_string [ sizeof _str + ( MAX_PLAYER_NAME * 2 ) ] ;
	format ( query_string, sizeof ( query_string ), _str, _name, _password ) ;
	mysql_tquery ( sql_connection, query_string, "load_user", "i", playerid ) ;

	KillTimer ( p_t_info [ playerid ] [ login_timer ] ) ;
	p_t_info [ playerid ] [ login_timer ] = -1 ;
	return 1 ;
}

stock get_authorization_data ( playerid )
{
  	new BitStream:bitstream = BS_New();

	BS_WriteValue(
        bitstream,
        PR_UINT8,   PACKET_CUSTOMRPC,
        PR_UINT32,  RPC_AUTHORIZATION_PACKET
    );

    PR_SendPacket(bitstream, playerid, PR_MEDIUM_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock SPEC_SendSpectateData ( playerid, to_player )
{
	if ( ! IsPlayerConnected ( to_player ) || ! p_t_info [ to_player ] [ p_logged ] )
		return true ;
		
	new Float: health,
		Float: armour ;

	GetPlayerHealth ( to_player, health ) ;
	GetPlayerArmour ( to_player, armour ) ;

	global_string [ 0 ] = EOS ;
	new fmt_str [ 218 ] ;
    format
	(
		global_string, sizeof global_string,
		"{ \"nickname\": \"%s\", \"playerId\": %d, \"items\": [ ", 
		p_info [ to_player ] [ name ], to_player
	) ;

	format ( fmt_str, sizeof fmt_str, "{ \"type\": \"health\", \"value\": %d },", floatround ( p_t_info [ to_player ] [ p_health ] ) ) ;
	strcat ( global_string, fmt_str ) ;

	format ( fmt_str, sizeof fmt_str, "{ \"type\": \"armour\", \"value\": %d },", floatround ( p_t_info [ to_player ] [ p_armour ] ) ) ;
	strcat ( global_string, fmt_str ) ;

	format ( fmt_str, sizeof fmt_str, "{ \"type\": \"speed\", \"value\": %d },", GetPlayerSpeed ( to_player ) ) ;
	strcat ( global_string, fmt_str ) ;

	format ( fmt_str, sizeof fmt_str, "{ \"type\": \"level\", \"value\": %d },", p_info [ to_player ] [ level ] ) ;
	strcat ( global_string, fmt_str ) ;

	format ( fmt_str, sizeof fmt_str, "{ \"type\": \"money\", \"value\": %d }", p_info [ to_player ] [ money ] ) ;
	strcat ( global_string, fmt_str ) ;

	strcat ( global_string, " ] }" ) ;

	onServerSendData ( playerid, UI_ADMIN_PANEL, 0, global_string ) ;
	return true ;
}

stock show_packet_game_menu ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 1 ) // donate
	{
		show_mobile_donate ( playerid ) ;
	}
	else if ( actionId == 2 ) // stats
	{
		show_playermenu ( playerid ) ;
	}
	else if ( actionId == 5 ) // report
	{
		show_dialog ( playerid, d_mm_request_1, DIALOG_STYLE_LIST, "{"#cBHD"}Помощь", "\
			{"#cBL"}Выберите аспект помощи:\n\
			{"#cBL"}1. {"#cWH"}Вам нужен спавн?\n\
			{"#cBL"}2. {"#cWH"}Вам нужно выдать скутер?\n\
			{"#cBL"}3. {"#cWH"}Вы перевернулись?\n\
			{"#cBL"}4. {"#cWH"}У Вас застряла машина?\n\
			{"#cBL"}5. {"#cWH"}У Вас сделка?\n \n\
			{"#cLY"}Задать вопрос администрации", "Выбрать", "Закрыть" ) ;
	}
	else if ( actionId == 6 ) // anim
	{
		callcmd::anim ( playerid, "" ) ;
	}
	else if ( actionId == 8 ) // settings
	{
		show_settings ( playerid ) ;
	}
	else if ( actionId == 9 ) // promo
	{
		global_string [ 0 ] = EOS ;
		strcat ( global_string, "{"#cWH"}Если вы пришли на {"#cBL"}"server_name"{"#cWH"}\n" ) ;
		strcat ( global_string, "по приглашению и у Вас есть {"#cLY"}промокод{"#cWH"},\n" ) ;
		strcat ( global_string, "то введите его в поле ниже.\n\n" ) ;

		strcat ( global_string, "{"#cBL"}1.{"#cWH"} При активации {"#cLY"}промокода{"#cWH"}\n" ) ;
		strcat ( global_string, "Вы получите все бонусы,\n" ) ;
		strcat ( global_string, "которые были обещаны.\n\n" ) ;

		new line_string [ 100 ] ;
		format ( line_string, sizeof line_string, "{"#cBL"}2.{"#cWH"} При достижении {"#cLY"}%d{"#cWH"} уровня\n", promo_level ) ;
		strcat ( global_string, line_string ) ;
		strcat ( global_string, "Вы получите денежные средства.\n\n" ) ;

		format ( line_string, sizeof line_string, "{"#cBL"}3.{"#cWH"} С {"#cLY"}%d{"#cWH"} по {"#cLY"}%d{"#cWH"} уровень аккаунта будет\n", promo_level, promo_llevel ) ;
		strcat ( global_string, line_string ) ;
		strcat ( global_string, "качаться в {"#cBL"}2 раза быстрее{"#cWH"}.\n\n" ) ;

		format ( line_string, sizeof line_string, "{"#cBL"}4.{"#cWH"} При достижении {"#cLY"}%d{"#cWH"} уровня\n", promo_llevel ) ;
		strcat ( global_string, line_string ) ;
		strcat ( global_string, "Вы получите ещё дополнительные\n" ) ;
		strcat ( global_string, "денежные средства в виде {"#cBL"}x1.5{"#cWH"} от\n" ) ;
		strcat ( global_string, "того, что выдавал {"#cLY"}промокод{"#cWH"} изначально.\n\n" ) ;

		strcat ( global_string, "{"#cGRDialog"}* Если у Вас имеется {"#cBL"}промокод{"#cGRDialog"}, введите его здесь:" ) ;
		show_dialog ( playerid, d_mm_promocode, DIALOG_STYLE_INPUT, "{"#cBHD"}Промокод", global_string, "Принять", "Назад" ) ;
	}
	else if ( actionId == 11 ) // inventory
	{
		show_inventory_ptd ( playerid, true ) ;
	}
	else if ( actionId == 14 ) // tablet
	{
		callcmd::phone ( playerid ) ;
	}
	else if ( actionId == 22 ) // family
	{
		callcmd::fmenu ( playerid ) ;
	}
	else if ( actionId == 25 ) // quest
	{
		show_open_quest ( playerid ) ;
	}
	else if ( actionId == 35 ) // cars
	{
		callcmd::fixcar ( playerid ) ;
	}
	else if ( actionId == 36 ) // org menu
	{
		callcmd::lmenu ( playerid ) ;
	}
	return 1 ;
}

stock show_window_licence ( playerid, targetid )
{
	#if defined debug_packet
		printf ( "[show_window_licence] playerid: %d", playerid ) ;
	#endif

	new _gunLic = 0, _flyLic = 0, _driveLic = 0, _boatLic = 0 ;
	if ( p_info [ playerid ] [ gun_lic ] == 1 || p_info [ playerid ] [ gun_lic ] == 2 ) _gunLic = 1 ;
	if ( p_info [ playerid ] [ fly_lic ] == 1 || p_info [ playerid ] [ fly_lic ] == 2 ) _flyLic = 1 ;
	if ( p_info [ playerid ] [ drive_lic ] == 1 || p_info [ playerid ] [ drive_lic ] == 2 ) _driveLic = 1 ;
	if ( p_info [ playerid ] [ boat_lic ] == 1 || p_info [ playerid ] [ boat_lic ] == 2 ) _boatLic = 1 ;
	new Node: node = JSON_Object (
		"playerName",			JSON_String ( p_info [ playerid ] [ name ] ),
		"licenceWeapon",		JSON_String ( _gunLic ? "Имеется" : "Отсутствует" ),
		"licenceFlying",		JSON_String ( _flyLic ? "Имеется" : "Отсутствует" ),
		"licenceDriving",		JSON_String ( _driveLic ? "Имеется" : "Отсутствует" ),
		"licenceBoat",			JSON_String ( _boatLic ? "Имеется" : "Отсутствует" )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( targetid, UI_LICENSE_LIST, 0, global_string ) ;
}

stock show_window_pts ( targetid, vehicleid )
{
	#if defined debug_packet
		printf ( "[show_window_pts] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Array ( ), Node: lineNode,
		modelid = getVehicleOrdinalNumber ( vehicleid ) ;

	lineNode = JSON_Array (
		JSON_Object (
			"name",			JSON_String ( "Модель" ),
			"value",		JSON_String ( veh_data [ modelid ] [ VEHICLE_NAME ] )
		)
	) ;
	node = JSON_Append ( node, lineNode ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%.1f", veh_info [ vehicleid - 1 ] [ v_millage ] ) ;
	lineNode = JSON_Array (
		JSON_Object (
			"name",			JSON_String ( "Пробег" ),
			"value",		JSON_String ( global_string )
		)
	) ;
	node = JSON_Append ( node, lineNode ) ;

	new Float: _v_millage = floatround ( veh_info [ vehicleid - 1 ] [ v_millage ] * 25 ) / 100 ;
	if ( _v_millage > 1000 ) _v_millage = 1000.0 ;
	if ( _v_millage < veh_info [ vehicleid - 1 ] [ v_legal_millage ] ) _v_millage = veh_info [ vehicleid - 1 ] [ v_legal_millage ] ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%.1f", _v_millage ) ;
	lineNode = JSON_Array (
		JSON_Object (
			"name",			JSON_String ( "Можно скрутить до" ),
			"value",		JSON_String ( global_string )
		)
	) ;
	node = JSON_Append ( node, lineNode ) ;

	lineNode = JSON_Array (
		JSON_Object (
			"name",			JSON_String ( "Номерной знак" ),
			"value",		JSON_String ( plate_number ( vehicleid ) )
		)
	) ;
	node = JSON_Append ( node, lineNode ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d шт.", get_model_count ( modelid ) ) ;
	lineNode = JSON_Array (
		JSON_Object (
			"name",			JSON_String ( "Модели на сервере" ),
			"value",		JSON_String ( global_string )
		)
	) ;
	node = JSON_Append ( node, lineNode ) ;

	lineNode = JSON_Array (
		JSON_Object (
			"name",			JSON_String ( "Достать можно" ),
			"value",		JSON_String ( item_description ( modelid, 1 ) )
		)
	) ;
	node = JSON_Append ( node, lineNode ) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( targetid, UI_PTS, 0, global_string ) ;
}

stock showSpeedLimit ( playerid, speedLimit )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", speedLimit ) ;
	onServerSendData ( playerid, UI_SPEED_LIMIT, 0, global_string ) ;
}

enum
{
	GXT_TYPE_CENTER = 3,
	GXT_TYPE_BOTTOM = 2,
	GXT_TYPE_MIDDLE_END = 1
} ;

stock gameTextForPlayer ( playerid, typeId, _str [ ], duration )
{
	new Node: node = JSON_Object (
		"id",		JSON_Int ( typeId ),
		"text",		JSON_String ( _str ),
		"duration",	JSON_Int ( duration )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_GXT, 0, global_string ) ;
}