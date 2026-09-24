#include 									<custom/AuthReg>

new bool: player_stoped_regped [ MAX_PLAYERS ] ;
stock show_packet_AuthReg ( playerid, _param1, _param2, _str [ ], _param3 )
{
	if ( _param3 == 0 )
	{
		if ( _param1 == 1 )
		{
			if ( _param2 == 1 )
			{
				format ( p_info [ playerid ] [ name ], MAX_PLAYER_NAME, "%s", _str ) ;
				
				if ( strlen ( _str ) < 3 || strlen ( _str ) > MAX_PLAYER_NAME || is_russian_text ( reg_info [ playerid ] [ reg_password ] ) )
				{
					authCheckedParams ( playerid, 2, true ) ;
					return 1 ;
				}
				
				if ( strlen ( reg_info [ playerid ] [ reg_password ] ) < 6 || strlen ( reg_info [ playerid ] [ reg_password ] ) > 24 || is_russian_text ( reg_info [ playerid ] [ reg_password ] ) )
				{
					authCheckedParams ( playerid, 2, true ) ;
					return 1 ;
				}
				
				authCheckedParams ( playerid, 2, false ) ;
			}
		}
		else if ( _param1 == 2 )
		{
			if ( _param2 == 1 )
			{
				format ( reg_info [ playerid ] [ reg_password ], 24, "%s", _str ) ;
				
				if ( strlen ( p_info [ playerid ] [ name ] ) < 3 || strlen ( p_info [ playerid ] [ name ] ) > MAX_PLAYER_NAME || is_russian_text ( p_info [ playerid ] [ name ] ) )
				{
					authCheckedParams ( playerid, 2, true ) ;
					return 1 ;
				}
				
				if ( strlen ( reg_info [ playerid ] [ reg_password ] ) < 6 || strlen ( reg_info [ playerid ] [ reg_password ] ) > 24 || is_russian_text ( reg_info [ playerid ] [ reg_password ] ) )
				{
					authCheckedParams ( playerid, 2, true ) ;
					return 1 ;
				}
				
				authCheckedParams ( playerid, 2, false ) ;
			}
		}
		else if ( _param1 == 3 )
		{
			reg_info [ playerid ] [ reg_remember ] = _param2 ;
		}
		else if ( _param1 == 4 )
		{
			if ( _param2 == 1 )
			{
				if ( strlen ( p_info [ playerid ] [ name ] ) < 3 || strlen ( p_info [ playerid ] [ name ] ) > MAX_PLAYER_NAME || is_russian_text ( p_info [ playerid ] [ name ] ) )
				{
					authCheckedParams ( playerid, 0, true ) ;
					authCheckedParams ( playerid, 2, true ) ;
					authMessage ( playerid, "Длина ника должна быть от 3 до 24 символов!" ) ;
					return 1 ;
				}
				if ( strlen ( reg_info [ playerid ] [ reg_password ] ) < 6 || strlen ( reg_info [ playerid ] [ reg_password ] ) > 24 || is_russian_text ( reg_info [ playerid ] [ reg_password ] ) )
				{
					authCheckedParams ( playerid, 1, true ) ;
					authCheckedParams ( playerid, 2, true ) ;
					authMessage ( playerid, "Длина пароля должна быть от 6 до 24 символов!" ) ;
					return 1 ;
				}
				
				static const __str [ ] = "SELECT `u_id`,`u_online` FROM `users` WHERE `u_name` = '%s' AND `u_password` = '%s' LIMIT 1" ;
				new query_string [ sizeof __str + ( MAX_PLAYER_NAME * 2 ) ] ;
				format ( query_string, sizeof query_string, __str, p_info [ playerid ] [ name ], reg_info [ playerid ] [ reg_password ] ) ;
				mysql_tquery ( sql_connection, query_string, "check_account_authorization", "i", playerid ) ;
				
				authLoadedBar ( playerid, true ) ;
			}
		}
		else if ( _param1 == 5 )
		{
			if ( _param2 == 1 )
			{
				authHide ( playerid ) ;
				regShow ( playerid ) ;
			}
		}
	}
	else if ( _param3 == 1 )
	{
		if ( _param1 == 1 )
		{
			if ( _param2 == 1 )
			{
				SetPVarString ( playerid, "reg_name", _str ) ;
				
				new _str2 [ 10 ], _str3 [ 10 ] ;
				GetPVarString ( playerid, "reg_name", _str2, sizeof _str2 ) ;
				GetPVarString ( playerid, "reg_family", _str3, sizeof _str3 ) ;
				if ( ( strlen ( _str2 ) > 2 && strlen ( _str2 ) < 10 ) &&
					( strlen ( _str3 ) > 2 && strlen ( _str3 ) < 10 ) &&
					( strlen ( reg_info [ playerid ] [ reg_password ] ) > 5 && strlen ( reg_info [ playerid ] [ reg_password ] ) < 25 ) )
				{
					regCheckedParams ( playerid, 4, false ) ;
				}	
			}
		}
		else if ( _param1 == 2 )
		{
			if ( _param2 == 1 )
			{
				SetPVarString ( playerid, "reg_family", _str ) ;
				
				new _str2 [ 10 ], _str3 [ 10 ] ;
				GetPVarString ( playerid, "reg_name", _str2, sizeof _str2 ) ;
				GetPVarString ( playerid, "reg_family", _str3, sizeof _str3 ) ;
				if ( ( strlen ( _str2 ) > 2 && strlen ( _str2 ) < 10 ) &&
					( strlen ( _str3 ) > 2 && strlen ( _str3 ) < 10 ) &&
					( strlen ( reg_info [ playerid ] [ reg_password ] ) > 5 && strlen ( reg_info [ playerid ] [ reg_password ] ) < 25 ) )
				{
					regCheckedParams ( playerid, 4, false ) ;
				}	
			}
		}
		else if ( _param1 == 3 )
		{
			if ( _param2 == 1 )
			{
				format ( reg_info [ playerid ] [ reg_password ], 24, "%s", _str ) ;
				
				new _str2 [ 10 ], _str3 [ 10 ] ;
				GetPVarString ( playerid, "reg_name", _str2, sizeof _str2 ) ;
				GetPVarString ( playerid, "reg_family", _str3, sizeof _str3 ) ;
				if ( ( strlen ( _str2 ) > 2 && strlen ( _str2 ) < 10 ) &&
					( strlen ( _str3 ) > 2 && strlen ( _str3 ) < 10 ) &&
					( strlen ( reg_info [ playerid ] [ reg_password ] ) > 5 && strlen ( reg_info [ playerid ] [ reg_password ] ) < 25 ) )
				{
					regCheckedParams ( playerid, 4, false ) ;
				}	
			}
		}
		else if ( _param1 == 4 )
		{
			if ( _param2 == 1 )
			{
				new query_string [ 59 + MAX_PLAYER_NAME ] ;
				mysql_format ( sql_connection, query_string, sizeof ( query_string ), "SELECT `u_id` FROM `users` WHERE `u_name` = '%e' LIMIT 1", _str ) ;
				mysql_tquery ( sql_connection, query_string, "check_referal_device", "is", playerid, _str ) ;
			}
		}
		else if ( _param1 == 5 )
		{
            new _str2 [ 10 ], _str3 [ 10 ] ;
			GetPVarString ( playerid, "reg_name", _str2, sizeof _str2 ) ;
			GetPVarString ( playerid, "reg_family", _str3, sizeof _str3 ) ;
			if ( strlen ( _str2 ) < 3 || strlen ( _str2 ) > 10 || is_russian_text ( _str2 ) )
			{
				regCheckedParams ( playerid, 0, true ) ;
				regCheckedParams ( playerid, 4, true ) ;
				regMessage ( playerid, "Длина имени должна быть от 3 до 10 латинских символов!" ) ;
				return 1 ;
			}
			if ( strlen ( _str3 ) < 3 || strlen ( _str3 ) > 10 || is_russian_text ( _str3 ) )
			{
				regCheckedParams ( playerid, 1, true ) ;
				regCheckedParams ( playerid, 4, true ) ;
				regMessage ( playerid, "Длина фамилии должна быть от 3 до 10 латинских символов!" ) ;
				return 1 ;
			}
			if ( strlen ( reg_info [ playerid ] [ reg_password ] ) < 6 || strlen ( reg_info [ playerid ] [ reg_password ] ) > 24 || is_russian_text ( reg_info [ playerid ] [ reg_password ] ) )
			{
				regCheckedParams ( playerid, 2, true ) ;
				regCheckedParams ( playerid, 4, true ) ;
				regMessage ( playerid, "Длина пароля должна быть от 6 до 24 символов!" ) ;
				return 1 ;
			}
			
			format ( p_info [ playerid ] [ name ], MAX_PLAYER_NAME, "%s_%s", _str2, _str3 ) ;
				
			static const __str [ ] = "SELECT `u_id` FROM `users` WHERE `u_name` = '%s' LIMIT 1" ;
			new query_string [ sizeof __str + MAX_PLAYER_NAME ] ;
			format ( query_string, sizeof query_string, __str, p_info [ playerid ] [ name ] ) ;
			mysql_tquery ( sql_connection, query_string, "check_account_register", "i", playerid ) ;
		}
		else if ( _param1 == 6 )
		{
			if ( _param2 == 1 )
			{
				regHide ( playerid ) ;
				authShow ( playerid ) ;
				#if defined server_number_one
					authUpdateParams ( playerid, "", "", "Авторитетный", "500" ) ;
				#endif

				#if defined server_number_two
					authUpdateParams ( playerid, "", "", "Бандитский", "300" ) ;
				#endif

				#if defined server_number_test
					authUpdateParams ( playerid, "", "", "Тестовый", "0" ) ;
				#endif
				authCheckedParams ( playerid, 0, true ) ;
				authCheckedParams ( playerid, 1, true ) ;
				authCheckedParams ( playerid, 2, true ) ;
			}
		}
	}
	return 1 ;
}

callback: check_account_authorization ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( rows ) 
	{
		for ( new i = 0 ; i < MAX_PLAYERS ; i ++ )
		{
			if ( i == playerid ) continue ;
			if ( ! IsPlayerConnected ( i ) ) continue ;
			if ( ! GetString ( p_info [ i ] [ name ], p_info [ playerid ] [ name ] ) ) continue ;
					
			authCheckedParams ( playerid, 0, true ) ;
			authCheckedParams ( playerid, 2, true ) ;
			authMessage ( playerid, "Игрок с выбранным ником находится в игре!" ) ;
			return 1 ;
		}
				
		SetPlayerName ( playerid, p_info [ playerid ] [ name ] ) ;
	
		authHide ( playerid ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		
	    reg_info [ playerid ] [ reg_id ] = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
		
		new query_string [ 85 + MAX_PLAYER_NAME ] ;
		format ( query_string, sizeof query_string, "SELECT * FROM `users_bans` WHERE `u_b_name` = '%s' AND `u_b_date` > NOW( ) LIMIT 1", p_info [ playerid ] [ name ] ) ;
		mysql_tquery ( sql_connection, query_string, "check_player_banned_1", "i", playerid ) ;
	}
	else
	{
		authCheckedParams ( playerid, 0, true ) ;
		authCheckedParams ( playerid, 1, true ) ;
		authCheckedParams ( playerid, 2, true ) ;
		authMessage ( playerid, "Указанный ник не зарегистрирован либо пароль не верный!" ) ;
		authLoadedBar ( playerid, false ) ;
	}
	return 1 ;
}

callback: check_player_banned_1 ( playerid )
{
	new rows, fields;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		global_string [ 0 ] = EOS ;
		new date [ 32 ], reason [ 64 ], old_date [ 32 ], admin_name [ MAX_PLAYER_NAME ], ub_days ;
		cache_get_field_content ( 0, "u_b_date", date, sql_connection, 32 ) ;
		cache_get_field_content ( 0, "u_b_admin", admin_name, sql_connection, MAX_PLAYER_NAME ) ;
		cache_get_field_content ( 0, "u_b_reason", reason, sql_connection, 64 ) ;
		cache_get_field_content ( 0, "u_b_ndate", old_date, sql_connection, 32 ) ;

		ub_days = cache_get_field_content_int ( 0, "u_b_days", sql_connection ) ;

		format ( global_string, sizeof global_string, "{"#cRD"}Ваш аккаунт был заблокирован, за нарушение правил сервера.\n\n\
												{"#cGRDialog"}*  Пожалуйста, сделайте скриншот данного окна {"#cWH"}(F8),\n\
												{"#cGRDialog"}   если вы не согласны с наказанием и оставьте жалобу на форуме {"#cWH"}"site_name".\n\n\
												{"#cBL"}* {"#cGRDialog"}Ваш ник: {"#cWH"}%s.\n\
												{"#cBL"}* {"#cGRDialog"}Ник администратора: {"#cWH"}%s.\n\
												{"#cBL"}* {"#cGRDialog"}Дата блокировки: {"#cWH"}%s.\n\
												{"#cBL"}* {"#cGRDialog"}Дата разблокировки: {"#cWH"}%s (%d дней)\n\
												{"#cBL"}* {"#cGRDialog"}Причина: {"#cWH"}%s\n",
		p_info [ playerid ] [ name ], admin_name, old_date, date, ub_days, reason ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация о блокировке", global_string, "Выйти", "" ) ;
		
		p_t_info [ playerid ] [ login_timer ] = SetTimerEx ( "callback_banned_timer", 5000, false, "i", playerid ) ;
	}
	else
	{
		new query_string [ 76 + 9 + 24 ] ;
		mysql_format ( sql_connection, query_string, sizeof ( query_string ), "SELECT * FROM `users` WHERE `u_id` = '%d' AND `u_password` = '%s' LIMIT 1", reg_info [ playerid ] [ reg_id ], reg_info [ playerid ] [ reg_password ] ) ;
		mysql_tquery ( sql_connection, query_string, "load_user", "ii", playerid, reg_info [ playerid ] [ reg_remember ] ) ;
		
		KillTimer ( p_t_info [ playerid ] [ login_timer ] ) ;
		p_t_info [ playerid ] [ login_timer ] = -1 ;
	}
	authLoadedBar ( playerid, false ) ;
	return 1 ;
}

callback: check_referal_device ( playerid, inputtext [ ] )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		regCheckedParams ( playerid, 3, true ) ;
		regMessage ( playerid, "Ник пригласившего Вас игрока не зарегистрирован!" ) ;
		return 1 ;
	}
	
	regCheckedParams ( playerid, 3, false ) ;
	format ( reg_info [ playerid ] [ reg_referal ], MAX_PLAYER_NAME, "%s", inputtext ) ;
	reg_info [ playerid ] [ reg_referal_id ] = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
	return 1 ;
}

callback: check_account_register ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( rows ) 
	{
	    regCheckedParams ( playerid, 0, true ) ;
		regCheckedParams ( playerid, 1, true ) ;
		regCheckedParams ( playerid, 4, true ) ;
		regMessage ( playerid, "Аккаунт с указанными именем и фамилией уже зарегистрирован!" ) ;
	}
	else 
	{
	    regCheckedParams ( playerid, 0, false ) ;
		regCheckedParams ( playerid, 1, false ) ;
		SetPlayerName ( playerid, p_info [ playerid ] [ name ] ) ;
		regHide ( playerid ) ;
		
		player_stoped_regped [ playerid ] = false ;
		regPedShow ( playerid ) ;
		regPedClothes ( playerid, "Мужчина #1" ) ;
		
		SetSpawnInfo ( playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ) ;
		SpawnPlayer ( playerid ) ;
		
		DeletePVar ( playerid, "reg_name" ) ;
		DeletePVar ( playerid, "reg_family" ) ;
	}
	return 1 ;
}

stock show_packet_PedSettings ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			reg_info [ playerid ] [ reg_gender ] = _param3 + 1 ;
			DeletePVar ( playerid, "skin_select_number" ) ;
			
			new _skin = registration_skins [ reg_info [ playerid ] [ reg_national ] - 1 ] [ _param3 ] [ 0 ] ;
			reg_info [ playerid ] [ reg_skin ] = _skin ;
			SetPlayerSkin ( playerid, _skin ) ;
			
			if ( reg_info [ playerid ] [ reg_gender ] == 1 ) regPedClothes ( playerid, "Мужчина #1" ) ;
			else regPedClothes ( playerid, "Женщина #1" ) ;
		}
	}
	else if ( _param1 == 2 )
	{
		if ( _param2 == 1 )
		{
			reg_info [ playerid ] [ reg_national ] = _param3 + 1 ;
			DeletePVar ( playerid, "skin_select_number" ) ;
			
			new _skin = registration_skins [ _param3 ] [ reg_info [ playerid ] [ reg_gender ] - 1 ] [ 0 ] ;
			reg_info [ playerid ] [ reg_skin ] = _skin ;
			SetPlayerSkin ( playerid, _skin ) ;
			
			if ( reg_info [ playerid ] [ reg_gender ] == 1 ) regPedClothes ( playerid, "Мужчина #1" ) ;
			else regPedClothes ( playerid, "Женщина #1" ) ;
		}
	}
	else if ( _param1 == 3 )
	{
		if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				new skin_count = GetPVarInt ( playerid, "skin_select_number" ) ;
				if ( skin_count == 0 ) return 1 ;
				
				new _str [ 12 ] ;
				if ( reg_info [ playerid ] [ reg_gender ] == 1 ) format ( _str, sizeof _str, "Мужчина #%d", skin_count - 1 ) ;
				else format ( _str, sizeof _str, "Женщина #%d", skin_count - 1 ) ;
				regPedClothes ( playerid, _str ) ;
				
				SetPVarInt ( playerid, "skin_select_number", skin_count - 1 ) ;
				new _skin = registration_skins [ reg_info [ playerid ] [ reg_national ] - 1 ] [ reg_info [ playerid ] [ reg_gender ] - 1 ] [ skin_count - 1 ] ;
				reg_info [ playerid ] [ reg_skin ] = _skin ;
				SetPlayerSkin ( playerid, _skin ) ;
			}
			else if ( _param3 == 1 )
			{
				new skin_count = GetPVarInt ( playerid, "skin_select_number" ) ;
				if ( skin_count == 4 ) return 1 ;
				
				new _str [ 12 ] ;
				if ( reg_info [ playerid ] [ reg_gender ] == 1 ) format ( _str, sizeof _str, "Мужчина #%d", skin_count + 1 ) ;
				else format ( _str, sizeof _str, "Женщина #%d", skin_count + 1 ) ;
				regPedClothes ( playerid, _str ) ;
				
				SetPVarInt ( playerid, "skin_select_number", skin_count + 1 ) ;
				new _skin = registration_skins [ reg_info [ playerid ] [ reg_national ] - 1 ] [ reg_info [ playerid ] [ reg_gender ] - 1 ] [ skin_count + 1 ] ;
				reg_info [ playerid ] [ reg_skin ] = _skin ;
				SetPlayerSkin ( playerid, _skin ) ;
			}
		}
	}
	else if ( _param1 == 5 )
	{
		if ( _param2 == 1 )
		{
			regPedHide ( playerid ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			
			if ( player_stoped_regped [ playerid ] == false )
			{
				player_stoped_regped [ playerid ] = true ;
			
				new query_string [ 356 ] ;
				mysql_format ( sql_connection, query_string, sizeof ( query_string ), "INSERT INTO `users` (`u_name`,`u_password`,`u_ip_registration`,`u_date_registration`,`u_referal`,`u_referal_id`,`u_gender`,`u_national`,`u_email`,`u_skin`) VALUES ('%s','%s','%s',NOW(),'%s','%d','%d','%d','n','%d')",
				p_info [ playerid ] [ name ], reg_info [ playerid ] [ reg_password ], p_t_info [ playerid ] [ p_ip ],
				reg_info [ playerid ] [ reg_referal ], reg_info [ playerid ] [ reg_referal_id ], reg_info [ playerid ] [ reg_gender ] - 1,
				reg_info [ playerid ] [ reg_national ], reg_info [ playerid ] [ reg_skin ] ) ;
				mysql_tquery ( sql_connection, query_string, "callback_insert_user", "is", playerid, reg_info [ playerid ] [ reg_password ] ) ;
			}
		}
	}
	return 1 ;
}
