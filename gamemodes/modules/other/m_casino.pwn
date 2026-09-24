#include 									<custom/casino_inc>

#define max_bet_custom 1_000_000
#define max_bet_jackpot 10_000_000

new apple_process [ MAX_PLAYERS ] ;
new apple_money [ MAX_PLAYERS ] ;
stock show_packet_apple ( playerid, _touch_id, _result_id )
{
	if ( _touch_id == 255 ) TogglePlayerControllable ( playerid, true ) ;
	else if ( _touch_id == 254 )
	{
		if ( _result_id < 1000 || _result_id > p_info [ playerid ] [ money ] )
		{
			send_check_cinfo ( playerid, "Некорректная сумма ставки!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( _result_id > max_bet_custom )
		{
			send_check_cinfo ( playerid, "Максимальная сумма ставки 1.000.000$!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( p_info [ playerid ] [ money ] < _result_id )
		{
			send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			SetAppleStop ( playerid ) ;
			return 1 ;
		}
		
		apple_money [ playerid ] = _result_id ;
		
		give_money ( playerid, -_result_id ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -_result_id, "яблоки ставка" ) ;
		
		SetAppleStart ( playerid ) ;
	}
	else if ( _touch_id == 253 )
	{
		if ( apple_process [ playerid ] > 0 )
		{
			static const Float: apple_x [ ] =
			{
				1.1,
				1.2,
				1.3,
				1.5,
				2.0,
				3.0,
				4.0,
				5.0,
				8.0,
				10.0
			} ;
			
			new _apple_money = floatround ( apple_money [ playerid ] * apple_x [ apple_process [ playerid ] ] ) ;
			
			new _str [ ] = "Вы выйграли %d$" ;
			new scm_string [ sizeof _str + 9 ] ;
			format ( scm_string, sizeof scm_string, _str, _apple_money ) ;
			
			send_check_cinfo ( playerid, scm_string, 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		
			give_money ( playerid, _apple_money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _apple_money, "яблоки выигрыш" ) ;
		
			SetAppleStop ( playerid ) ;
		}
		
		apple_process [ playerid ] =
		apple_money [ playerid ] = 0 ;
	}
	else
	{
		new _random = random ( 5 ) ;
		if ( _random == _result_id || random ( 3 ) == 1 )
		{
			send_check_cinfo ( playerid, "Вы проиграли!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			SetAppleProcessBid ( playerid, _touch_id, _result_id, true, apple_process [ playerid ] ) ;
			apple_process [ playerid ] = 0 ;
			SetAppleStop ( playerid ) ;
			
			new _win = floatround ( apple_money [ playerid ] / 1000 ) ;
			give_bmoney ( GetPVarInt ( playerid, "p_biz_id" ), _win, 0 ) ;
		}
		else
		{
			apple_process [ playerid ] = _touch_id ;
			SetAppleProcessBid ( playerid, _touch_id, _result_id, false, apple_process [ playerid ] + 1 ) ;
			
			if ( _touch_id == 9 )
			{
				static const Float: apple_x [ ] =
				{
					1.1,
					1.2,
					1.3,
					1.5,
					2.0,
					3.0,
					4.0,
					5.0,
					8.0,
					10.0
				} ;
				
				new _apple_money = floatround ( apple_money [ playerid ] * apple_x [ apple_process [ playerid ] ] ) ;
				
				new _str [ ] = "Вы выйграли %d$" ;
				new scm_string [ sizeof _str + 9 ] ;
				format ( scm_string, sizeof scm_string, _str, _apple_money ) ;
				
				send_check_cinfo ( playerid, scm_string, 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				
				give_money ( playerid, _apple_money ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, _apple_money, "яблоки выигрыш" ) ;
				SetAppleStop ( playerid ) ;
			}
		}
		
        give_event_progress ( playerid, THE_CASINO, 1 ) ;
	}
	return 1 ;
}

new binary_random [ MAX_PLAYERS ] ;
new binary_money [ MAX_PLAYERS ] ;
stock show_packet_binary ( playerid, _id, bool: status, _current_bid )
{
	if ( _id == 255 ) TogglePlayerControllable ( playerid, true ) ;
	else if ( _id == 254 )
	{
		if ( _current_bid < 1000 || _current_bid > p_info [ playerid ] [ money ] )
		{
			send_check_cinfo ( playerid, "Некорректная сумма ставки!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( _current_bid > max_bet_custom )
		{
			send_check_cinfo ( playerid, "Максимальная сумма ставки 1.000.000$!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( p_info [ playerid ] [ money ] < _current_bid )
		{
			send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		binary_money [ playerid ] = _current_bid ;
		binary_random [ playerid ] = random ( 500 ) + 51 ;
		
		give_money ( playerid, -_current_bid ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -_current_bid, "больше меньше ставка" ) ;
		
		SetBinaryStart ( playerid, binary_random [ playerid ] ) ;
	}
	else if ( _id == 253 )
	{
		/*if ( p_info [ playerid ] [ money ] < _result_id )
		{
			send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			SetAppleStop ( playerid ) ;
			return 1 ;
		}
		
		binary_money [ playerid ] = _current_bid ;*/
	}
	else
	{
		if ( status )
		{
			if ( random ( 10 ) == 1 )
			{
				SetBinaryValue ( playerid, binary_random [ playerid ] + ( random ( 50 ) + 1 ), binary_money [ playerid ] * 2 ) ;
				
				give_money ( playerid, binary_money [ playerid ] * 2 ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, binary_money [ playerid ] * 2, "больше меньше выигрыш" ) ;
			}
			else
			{
				new _win = floatround ( binary_money [ playerid ] / 1000 ) ;
				give_bmoney ( GetPVarInt ( playerid, "p_biz_id" ), _win, 0 ) ;
			
				SetBinaryValue ( playerid, binary_random [ playerid ] - ( random ( 50 ) + 1 ), 0 ) ;
			}
		}
		else
		{
			if ( random ( 10 ) == 1 )
			{
				SetBinaryValue ( playerid, binary_random [ playerid ] - ( random ( 50 ) + 1 ), binary_money [ playerid ] * 2 ) ;
				
				give_money ( playerid, binary_money [ playerid ] * 2 ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, binary_money [ playerid ] * 2, "больше меньше выигрыш" ) ;
			}
			else
			{
				new _win = floatround ( binary_money [ playerid ] / 1000 ) ;
				give_bmoney ( GetPVarInt ( playerid, "p_biz_id" ), _win, 0 ) ;
				
				SetBinaryValue ( playerid, binary_random [ playerid ] + ( random ( 50 ) + 1 ), 0 ) ;
			}
		}
		
        give_event_progress ( playerid, THE_CASINO, 1 ) ;
	}
	return 1 ;
}

new roulette_money [ MAX_PLAYERS ] ;
stock show_packet_roulette ( playerid, _current_bid, _select_type, _select_number )
{
	if ( _current_bid == 255 && _select_type == 255 ) TogglePlayerControllable ( playerid, true ) ;
	else
	{
		if ( _current_bid < 1000 || _current_bid > p_info [ playerid ] [ money ] )
		{
			send_check_cinfo ( playerid, "Некорректная сумма ставки!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( _current_bid > max_bet_custom )
		{
			send_check_cinfo ( playerid, "Максимальная сумма ставки 1.000.000$!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( p_info [ playerid ] [ money ] < _current_bid )
		{
			send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		roulette_money [ playerid ] = _current_bid ;
		
		give_money ( playerid, -_current_bid ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -_current_bid, "рулетка ставка" ) ;
		
		static const coeficient [ ] = { 12, 2, 3, 3, 3, 3 } ;
		
		new _win_id = random ( 40 ), _win_money = _current_bid * coeficient [ _select_type ] ;
		SetRouletteStart ( playerid, _win_id, _win_money ) ;
		
		switch ( _select_type )
		{
			case 0:
			{
				if ( _select_number == _win_id )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
			}
			case 1:
			{
				if ( _select_number == 0 && black_roulette_id ( _win_id ) )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
				else if ( _select_number == 1 && red_roulette_id ( _win_id ) )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
			}
			default:
			{
				if ( _select_number == 0 && ryad_roulette_id ( _win_id, 0 ) )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
				else if ( _select_number == 1 && ryad_roulette_id ( _win_id, 1 ) )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
				else if ( _select_number == 2 && ryad_roulette_id ( _win_id, 2 ) )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
				else if ( _select_number == 3 && ryad_roulette_id ( _win_id, 3 ) )
				{
					give_money ( playerid, _win_money ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, _win_money, "рулетка выигрыш" ) ;
				}
			}
		}
		
        give_event_progress ( playerid, THE_CASINO, 1 ) ;
	}
	return 1 ;
}

stock casino_open_jackpot ( playerid )
{
	TogglePlayerControllable ( playerid, false ) ;
	SetJackpotShow ( playerid ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

new jackpot_money [ MAX_PLAYERS ] ;
stock show_packet_jackpot ( playerid, _i, _i2 )
{
	if ( _i == 0 && _i2 == 0 )
	{
		TogglePlayerControllable ( playerid, true ) ;
		SetJackpotHide ( playerid ) ;

		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( _i == 1 )
	{
		if ( _i2 < 1000 || _i2 > p_info [ playerid ] [ money ] )
		{
			send_check_cinfo ( playerid, "Некорректная сумма ставки!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( _i2 > max_bet_jackpot )
		{
			send_check_cinfo ( playerid, "Максимальная сумма ставки 10.000.000$!", 0, 300, CINFO_CASINO_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		jackpot_money [ playerid ] = _i2 ;
		if ( random ( 50 ) == 1 )
		{
			new _random = random ( 51 ) ;
			new _bet_win ;
			switch ( _random )
			{
				case 0..35: _bet_win = jackpot_money [ playerid ] * 1 ;
				case 36..47: _bet_win = jackpot_money [ playerid ] * 3 ;
				case 48: _bet_win = jackpot_money [ playerid ] * 5 ;
				case 49: _bet_win = jackpot_money [ playerid ] * 10 ;
				case 50: _bet_win = jackpot_money [ playerid ] * 100 ;
			}
			SetJackpotStart ( playerid, _random, _bet_win ) ;
			
			give_money ( playerid, _bet_win ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _bet_win, "jackpot выйгрыш" ) ;
		}
		else
		{
			SetJackpotStart ( playerid, -1, 0 ) ;
			
			give_money ( playerid, -_i2 ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_i2, "jackpot ставка" ) ;
				
			new _win = floatround ( _i2 / 1000 ) ;
			give_bmoney ( GetPVarInt ( playerid, "p_biz_id" ), _win, 0 ) ;
		}
		
        give_event_progress ( playerid, THE_CASINO, 1 ) ;
	}
	return 1 ;
}

new wheel_player_time [ MAX_PLAYERS ] ;
new wheel_player_count [ MAX_PLAYERS ] ;
stock casino_open_wheel ( playerid )
{
	TogglePlayerControllable ( playerid, false ) ;
	
	new _str [ 64 ], _time = 7200 - wheel_player_time [ playerid ] ;
	format ( _str, sizeof _str, "Будет доступно через %s", convert_time ( _time, TYPE_TIME_HOUR ) ) ;
	if ( _time < 1 )
	{
		if ( ! p_info [ playerid ] [ crime_plus ] && wheel_player_count [ playerid ] > 0 ) SetWheelShow ( playerid, 2, "На сегодня Ваши прокрутки закончились" ) ;
		else if ( wheel_player_count [ playerid ] > 1 ) SetWheelShow ( playerid, 0, "На сегодня Ваши прокрутки закончились" ) ;
		else SetWheelShow ( playerid, 1, "Можно прокрутить" ) ;
	}
	else SetWheelShow ( playerid, 0, _str ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

CMD:testwh ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	TogglePlayerControllable ( playerid, false ) ;
	
	new _str [ 64 ], _time = 7200 - wheel_player_time [ playerid ] ;
	format ( _str, sizeof _str, "Будет доступно через %s", convert_time ( _time, TYPE_TIME_HOUR ) ) ;
	SetWheelShow ( playerid, 1, _str ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

stock wheel_player_timer ( playerid, _time )
{
	if ( wheel_player_time [ playerid ] + _time >= 7200 && wheel_player_time [ playerid ] < 7200 )
	{
		wheel_player_time [ playerid ] = 7200 ;
		SendClientMessage ( playerid, col_orange, !"* Вам доступна прокрутка колеса фортуны в казино. (/gps - Бизнесы - Казино)" ) ;
	}
	else
	{
		wheel_player_time [ playerid ] += _time ;
	}
	return 1 ;
}

stock wheel_gettime_clear ( playerid )
{
	wheel_player_time [ playerid ] =
	wheel_player_count [ playerid ] = 0 ;
	return 1 ;
}

stock wheel_OnPlayerDisconnect ( playerid )
{
	new sql_string [ 95 + ( 9 * 3 ) ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_wheel_time` = '%d', `u_wheel_count` = '%d' WHERE `u_id` = '%d' LIMIT 1", wheel_player_time [ playerid ], wheel_player_count [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

stock show_packet_wheel ( playerid, _i )
{
	if ( _i == 0 )
	{
		TogglePlayerControllable ( playerid, true ) ;
		SetWheelHide ( playerid ) ;

		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( 7200 - wheel_player_time [ playerid ] < 1 )
	{
		if ( ! p_info [ playerid ] [ crime_plus ] && wheel_player_count [ playerid ] > 0 )
		{
			TogglePlayerControllable ( playerid, true ) ;
			SetWheelHide ( playerid ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подписка", "{"#cWH"}Приобрести подписку можно в /donate.", "Закрыть", "" ) ;
			return 1 ;
		}
		if ( wheel_player_count [ playerid ] > 1 )
		{
			TogglePlayerControllable ( playerid, true ) ;
			SetWheelHide ( playerid ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			return 1 ;
		}

		new _random = random ( 20 ) ;
		switch ( _random )
		{
			case 0:
			{
				static const _skin_id [ ] = { 1, 2, 3, 10, 33, 93, 94, 95, 105, 106, 184, 185, 186, 4601 } ;
				new _random_item = _skin_id [ random ( sizeof _skin_id ) ] ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", get_skin_name ( _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 2, _random_item, 0, 0, _str_name ) ;
				
				give_player_item_prise ( playerid, _random_item + skin_cross, 1 ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
			case 5, 15:
			{
				static const _acc_id [ ] = { 12047, 12048, 12049, 12050, 12069, 12070, 12071, 12052, 12053, 12054, 12055, 12056 } ;
				new _random_item = _acc_id [ random ( sizeof _acc_id ) ] ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", get_accessorie_name ( _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 0, _random_item, 0, 0, _str_name ) ;
				
				give_player_item ( playerid, _random_item ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
			case 10:
			{
				static const _veh_id [ ] = { 400, 401, 402, 436, 550, 555, 568, 3226, 3231, 3234, 3238, 3240, 3241 } ;
				new _random_item = _veh_id [ random ( sizeof _veh_id ) ] ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", GetVehicleNameEx ( -1, _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 1, _random_item, 0, 0, _str_name ) ;
				
				give_player_item_prise ( playerid, _random_item, 1 ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
			case 1, 6, 11, 16:
			{
				static const _exp_id [ ] = { 0, 1, 2 } ;
				new _random_item = _exp_id [ random ( sizeof _exp_id ) ] ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", item_name ( _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 0, 2684, 0, 0, _str_name ) ;
				
				give_player_item_prise ( playerid, _random_item, 1 ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
			case 2, 7, 12, 17:
			{
				static const _exp_id [ ] = { 4, 5, 6, 7, 8, 9, 32, 33, 34 } ;
				new _random_item = _exp_id [ random ( sizeof _exp_id ) ] ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", item_name ( _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 0, 1212, 0, 0, _str_name ) ;
				
				give_player_item_prise ( playerid, _random_item, 1 ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
			case 3, 8, 13, 18:
			{
				new _random_item = 3 ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", item_name ( _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 0, 1210, 0, 0, _str_name ) ;
				
				give_player_item_prise ( playerid, _random_item, 1 ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
			case 4, 9, 14, 19:
			{
				static const _exp_id [ ] = { 15, 16, 17, 18, 19, 20, 21, 22, 23 } ;
				new _random_item = _exp_id [ random ( sizeof _exp_id ) ] ;
				
				new _str_name [ 32 ] ;
				format ( _str_name, sizeof _str_name, "%s", item_name ( _random_item ) ) ;
				SetWheelUpdate ( playerid, _random, 0, 1274, 0, 0, _str_name ) ;
				
				give_player_item_prise ( playerid, _random_item, 1 ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s выйграл в Fortune Wheel %s", p_info [ playerid ] [ name ], _str_name ) ;
				WriteLog ( playerid, TYPE_LOG_WHEEL, sql_string ) ;
			}
		}
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;
		
		wheel_player_time [ playerid ] = 0 ;
		wheel_player_count [ playerid ] += 1 ;
		
        give_event_progress ( playerid, THE_CASINO, 1 ) ;
	}
	return 1 ;
}

stock black_roulette_id ( _win_id )
{
	switch ( _win_id )
	{
		case 1, 4, 6, 7, 11, 13, 15, 17, 18, 19, 20, 22, 24, 26, 27, 31, 34, 36, 38: return 1 ;
	}
	return 0 ;
}

stock red_roulette_id ( _win_id )
{
	switch ( _win_id )
	{
		case 2, 3, 5, 8, 9, 10, 12, 14, 16, 21, 23, 25, 28, 29, 30, 32, 35, 37: return 1 ;
	}
	return 0 ;
}

stock ryad_roulette_id ( _win_id, _ryad_id )
{
	if ( _ryad_id == 0 )
	{
		switch ( _win_id )
		{
			case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9: return 1 ;
		}
	}
	else if ( _ryad_id == 1 )
	{
		switch ( _win_id )
		{
			case 10, 11, 12, 13, 14, 15, 16, 17, 18, 19: return 1 ;
		}
	}
	else if ( _ryad_id == 2 )
	{
		switch ( _win_id )
		{
			case 20, 21, 22, 23, 24, 25, 26, 27, 28, 29: return 1 ;
		}
	}
	else if ( _ryad_id == 3 )
	{
		switch ( _win_id )
		{
			case 30, 31, 32, 33, 34, 35, 36, 37, 38, 39: return 1 ;
		}
	}
	return 0 ;
}