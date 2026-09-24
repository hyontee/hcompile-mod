CMD:setstats ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) && ! p_info [ playerid ] [ google_auth_status ] ) 
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не привязан гугл аутентификатор!" ) ;
	
	if ( sscanf ( params, "s[32]", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /setstats [name]");
	
	new sql_string [ 110 + MAX_PLAYER_NAME ] ;
	format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_name` = '%s' LIMIT 1", params [ 0 ] ) ;
	mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, params [ 0 ] ) ;
	return 1 ;
}

callback: callback_setstats ( playerid, _name [ ] )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		new scm_string [ 63 + MAX_PLAYER_NAME ] ;
		format( scm_string, sizeof ( scm_string ), "{"#cRInfo"}* {"#cGRInfo"}Аккаунт %s не найден в базе данных.", _name ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	
	new account_id = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
	new u_money = cache_get_field_content_int ( 0, "u_money", sql_connection ) ;
	new u_donate = cache_get_field_content_int ( 0, "u_donate", sql_connection ) ;
	new u_donate_bonus = cache_get_field_content_int ( 0, "u_donate_bonus", sql_connection ) ;
	
	new _account_name [ MAX_PLAYER_NAME ] ;
	cache_get_field_content ( 0, "u_name", _account_name, sql_connection, MAX_PLAYER_NAME ) ;
	
	SetPVarString ( playerid, "log_name", _account_name ) ;
	
	set_player_use_listitem ( playerid, account_id ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "\
		{"#cBL"}1. {"#cWH"}Номер аккаунта\t№%d\n\
		{"#cBL"}2. {"#cWH"}Средств на аккаунте\t%d$\n\
		{"#cBL"}3. {"#cWH"}Основной счёт\t%d "donate_title"\n\
		{"#cBL"}4. {"#cWH"}Бонусный счёт\t%d "donate_title"\n\
		{"#cBL"}5. {"#cWH"}Банковские счета\t \n\
		{"#cBL"}6. {"#cWH"}Транспорт\t ", account_id, u_money, u_donate, u_donate_bonus ) ;
	
	new header_string [ 64 ] ;
	format ( header_string, sizeof header_string, "{"#cBHD"}Аккаунт {"#cWH"}%s", _name ) ;
	show_dialog ( playerid, d_setstats, DIALOG_STYLE_TABLIST, header_string, global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock setstats_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_setstats:
		{
			if ( ! response ) return 1 ;
			switch ( listitem )
			{
				case 0:
				{
					new log_name [ MAX_PLAYER_NAME ] ;
					GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
					
					new sql_string [ 108 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
					return 1 ;
				}
				case 1:
				{
					show_dialog ( playerid, d_setstats_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение средств", "{"#cWH"}Укажите сумму, которую хотите ДОБАВИТЬ или ОТНЯТЬ:\n\n{"#cGRDialog"}* Если хотите отнять сумму, то укажите перед суммой минус", "Указать", "Закрыть" ) ;
					return 1 ;
				}
				case 2:
				{
					show_dialog ( playerid, d_setstats_donate, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение основного счёта", "{"#cWH"}Укажите сумму, которую хотите ДОБАВИТЬ или ОТНЯТЬ:\n\n{"#cGRDialog"}* Если хотите отнять сумму, то укажите перед суммой минус", "Указать", "Закрыть" ) ;
					return 1 ;
				}
				case 3:
				{
					show_dialog ( playerid, d_setstats_donate_bonus, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение бонусного счёта", "{"#cWH"}Укажите сумму, которую хотите ДОБАВИТЬ или ОТНЯТЬ:\n\n{"#cGRDialog"}* Если хотите отнять сумму, то укажите перед суммой минус", "Указать", "Закрыть" ) ;
					return 1 ;
				}
				case 4:
				{
					new query_string [ 83 + 9 ] ;
					format ( query_string, sizeof query_string, "SELECT `db_id`, `db_money` FROM `deposit_boxes` WHERE `db_owner` = '%d' LIMIT 10", get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, query_string, "setstats_db_callback", "i", playerid ) ;
					return 1 ;
				}
				case 5:
				{
					new query_string [ 83 + 9 ] ;
					format ( query_string, sizeof query_string, "SELECT `v_id`, `v_model`, `v_price` FROM `users_vehicles` WHERE `v_owner` = '%d'", get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, query_string, "setstats_vehicle_callback", "i", playerid ) ;
					return 1 ;
				}
			}
		}
		case d_setstats_money:
		{
			if ( ! response )
			{
				new log_name [ MAX_PLAYER_NAME ] ;
				GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
				
				new sql_string [ 108 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
				return 1 ;
			}
			
			new _str_value = strval ( inputtext ) ;
			
			new log_name [ MAX_PLAYER_NAME ] ;
			GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
			
			new _pl_id ;
			sscanf ( log_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s[%d] выдал Вам вирты на сумму %d$. Приятного время провождения на проекте!", p_info [ playerid ] [ name ], playerid ) ;
				SendClientMessage ( _pl_id, col_succes, scm_string ) ;
				
				give_money ( _pl_id, _str_value ) ;
				insert_money_log ( _pl_id, INVALID_PLAYER_ID, _str_value, "получил(а) от руководителя" ) ;
				
				format ( scm_string, 128, "%s выдал(а) деньги %s на сумму %d$", p_info [ playerid ] [ name ], p_info [ _pl_id ] [ name ], _str_value ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			else
			{
				if ( _str_value < 1 )
				{
					new scm_string [ 144 ] ;
					format ( scm_string, 90, "UPDATE `users` SET `u_money` = `u_money` + '%d' WHERE `u_id` = '%d' LIMIT 1", _str_value, get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
				}
				else insert_return_money ( "Денежные операции", _str_value, RETURN_TYPE_MONEY, get_player_use_listitem ( playerid ) ) ;
				
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s выдал Вам вирты на сумму %d$.\nПриятного время провождения на проекте!", p_info [ playerid ] [ name ], _str_value ) ;
				insert_debtor_message ( "Денежные операции", scm_string, get_player_use_listitem ( playerid ) ) ;
				
				format ( scm_string, 128, "%s выдал(а) деньги %s на сумму %d$", p_info [ playerid ] [ name ], log_name, _str_value ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			return 1 ;
		}
		case d_setstats_donate:
		{
			if ( ! response )
			{
				new log_name [ MAX_PLAYER_NAME ] ;
				GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
				
				new sql_string [ 108 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
				return 1 ;
			}
			
			new _str_value = strval ( inputtext ) ;
			
			new log_name [ MAX_PLAYER_NAME ] ;
			GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
			
			new _pl_id ;
			sscanf ( log_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s[%d] выдал Вам донат на сумму %d "donate_title". Приятного время провождения на проекте!", p_info [ playerid ] [ name ], playerid ) ;
				SendClientMessage ( playerid, col_succes, scm_string ) ;
				
				if ( _str_value < 1 ) set_player_donate ( _pl_id, _str_value, 2 ) ;
				else give_player_donate ( _pl_id, _str_value, 2 ) ;
				
				insert_donate_log ( _pl_id, INVALID_PLAYER_ID, _str_value, p_info [ playerid ] [ donate ], "(donate) получил(а) от руководителя" ) ;
				
				format ( scm_string, 128, "%s выдал(а) донат %s на сумму %d "donate_title"", p_info [ playerid ] [ name ], p_info [ _pl_id ] [ name ], _str_value ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			else
			{
				if ( _str_value < 1 )
				{
					new scm_string [ 80 + ( 9 * 2 ) ] ;
					format ( scm_string, sizeof scm_string, "UPDATE `users` SET `u_donate` = `u_donate` + '%d' WHERE `u_id` = '%d' LIMIT 1", _str_value, get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
				}
				else
				{
					new scm_string [ 80 + ( 9 * 2 ) ] ;
					format ( scm_string, sizeof scm_string, "UPDATE `users` SET `u_donate` = `u_donate` + '%d' WHERE `u_id` = '%d' LIMIT 1", _str_value, get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
				}
				
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s выдал Вам донат на сумму %d "donate_title".\nПриятного время провождения на проекте!", p_info [ playerid ] [ name ], _str_value ) ;
				insert_debtor_message ( ""donate_title"", scm_string, get_player_use_listitem ( playerid ) ) ;
				
				format ( scm_string, 128, "%s выдал(а) донат %s на сумму %d "donate_title"", p_info [ playerid ] [ name ], log_name, _str_value ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			return 1 ;
		}
		case d_setstats_donate_bonus:
		{
			if ( ! response )
			{
				new log_name [ MAX_PLAYER_NAME ] ;
				GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
				
				new sql_string [ 108 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
				return 1 ;
			}
			
			new _str_value = strval ( inputtext ) ;
			
			new log_name [ MAX_PLAYER_NAME ] ;
			GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
			
			new _pl_id ;
			sscanf ( log_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s[%d] выдал Вам донат на сумму %d "donate_title". Приятного время провождения на проекте!", p_info [ playerid ] [ name ], playerid ) ;
				SendClientMessage ( playerid, col_succes, scm_string ) ;
				
				if ( _str_value < 1 ) set_player_donate ( _pl_id, _str_value, 1 ) ;
				else give_player_donate ( _pl_id, _str_value, 1 ) ;
				
				insert_donate_log ( _pl_id, INVALID_PLAYER_ID, _str_value, p_info [ playerid ] [ donate_bonus ], "(donate) bonus | получил(а) от руководителя" ) ;
				
				format ( scm_string, 128, "%s выдал(а) донат %s на сумму %d "donate_title" | bonus", p_info [ playerid ] [ name ], p_info [ _pl_id ] [ name ], _str_value ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			else
			{
				if ( _str_value < 1 )
				{
					new scm_string [ 144 ] ;
					format ( scm_string, 90, "UPDATE `users` SET `u_donate_bonus` = `u_donate_bonus` + '%d' WHERE `u_id` = '%d' LIMIT 1", _str_value, get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
				}
				else
				{
					new scm_string [ 144 ] ;
					format ( scm_string, 90, "UPDATE `users` SET `u_donate_bonus` = `u_donate_bonus` + '%d' WHERE `u_id` = '%d' LIMIT 1", _str_value, get_player_use_listitem ( playerid ) ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
				}
				
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s выдал Вам донат на сумму %d "donate_title".\nПриятного время провождения на проекте!", p_info [ playerid ] [ name ], _str_value ) ;
				insert_debtor_message ( ""donate_title"", scm_string, get_player_use_listitem ( playerid ) ) ;
				
				format ( scm_string, 128, "%s выдал(а) донат %s на сумму %d "donate_title" | bonus", p_info [ playerid ] [ name ], log_name, _str_value ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			return 1 ;
		}
		case d_setstats_bank:
		{
			if ( ! response )
			{
				new log_name [ MAX_PLAYER_NAME ] ;
				GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
				
				new sql_string [ 108 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
				return 1 ;
			}
			
			SetPVarInt ( playerid, "bank_account", get_player_listitem_values ( playerid, listitem ) ) ;
			clear_player_listitem_values ( playerid ) ;
			
			show_dialog ( playerid, d_setstats_bank_set, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение банковского счёта", "{"#cWH"}Укажите сумму, которую хотите ДОБАВИТЬ или ОТНЯТЬ:\n\n{"#cGRDialog"}* Если хотите отнять сумму, то укажите перед суммой минус", "Указать", "Закрыть" ) ;
			return 1 ;
		}
		case d_setstats_bank_set:
		{
			if ( ! response )
			{
				new log_name [ MAX_PLAYER_NAME ] ;
				GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
				
				new sql_string [ 108 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
				
				DeletePVar ( playerid, "bank_account" ) ;
				return 1 ;
			}
			
			new _str_value = strval ( inputtext ) ;
			new _bank_id = GetPVarInt ( playerid, "bank_account" ) ;
			DeletePVar ( playerid, "bank_account" ) ;
			
			new log_name [ MAX_PLAYER_NAME ] ;
			GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
			
			new _pl_id ;
			sscanf ( log_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				for ( new i = 0 ; i < MAX_BANK_ACCOUNT ; i ++ )
				{
					if ( bank_info [ _pl_id ] [ bi_id ] [ i ] != _bank_id ) continue ;
					
					bank_info [ _pl_id ] [ bi_money ] [ i ] += _str_value ;
					
					new _t_string [ 76 + ( 9 * 2 ) ] ;
					format ( _t_string, sizeof ( _t_string ), "UPDATE `deposit_boxes` SET `db_money` = '%d' WHERE `db_id` = '%i' LIMIT 1",
					bank_info [ _pl_id ] [ bi_money ] [ i ], _bank_id ) ;
					mysql_tquery ( sql_connection, _t_string ) ;
					
					new scm_string [ 144 ] ;
					format ( scm_string, sizeof scm_string, "* Администратор %s[%d] выдал Вам вирты на сумму %d$ на банковский счёт №%d.", p_info [ playerid ] [ name ], playerid, _str_value, _bank_id ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					format ( scm_string, sizeof scm_string, "%s выдал(а) деньги %s на сумму %d$ на банковский счёт №%d", p_info [ playerid ] [ name ], p_info [ _pl_id ] [ name ], _str_value, _bank_id ) ;
					WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
					return 1 ;
				}
			}
			else
			{
				new _t_string [ 89 + ( 9 * 2 ) ] ;
				if ( _str_value < 1 )
				{
					format ( _t_string, sizeof ( _t_string ), "UPDATE `deposit_boxes` SET `db_money` = `db_money` + '%d' WHERE `db_id` = '%i' LIMIT 1",
					_str_value, _bank_id ) ;
					mysql_tquery ( sql_connection, _t_string ) ;
				}
				else
				{
					format ( _t_string, sizeof ( _t_string ), "UPDATE `deposit_boxes` SET `db_money` = `db_money` + '%d' WHERE `db_id` = '%i' LIMIT 1",
					_str_value, _bank_id ) ;
					mysql_tquery ( sql_connection, _t_string ) ;
				}
				
				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "* Администратор %s выдал Вам вирты на сумму %d$ на банковский счёт №%d.", p_info [ playerid ] [ name ], _str_value, _bank_id ) ;
				insert_debtor_message ( "Денежные операции", scm_string, get_player_use_listitem ( playerid ) ) ;
				
				format ( scm_string, sizeof scm_string, "%s выдал(а) деньги %s на сумму %d$ на банковский счёт №%d", p_info [ playerid ] [ name ], log_name, _str_value, _bank_id ) ;
				WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			}
			return 1 ;
		}
		case d_setstats_vehicle:
		{
			if ( ! response )
			{
				new log_name [ MAX_PLAYER_NAME ] ;
				GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
				
				new sql_string [ 108 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `u_id`, `u_name`, `u_money`, `u_donate`, `u_donate_bonus` FROM `users` WHERE `u_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_setstats", "is", playerid, log_name ) ;
				return 1 ;
			}
			
			new _v_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			new log_name [ MAX_PLAYER_NAME ] ;
			GetPVarString ( playerid, "log_name", log_name, sizeof ( log_name ) ) ;
			
			new sql_string [ 108 + 9 ] ;
			format ( sql_string, sizeof sql_string, "DELETE FROM `users_vehicles` WHERE `v_id` = '%d' LIMIT 1", _v_id ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			new scm_string [ 144 ] ;
			format ( scm_string, sizeof scm_string, "* Администратор %s продал(а) одно из Ваших т/с.", p_info [ playerid ] [ name ] ) ;
			insert_debtor_message ( "Денежные операции", scm_string, get_player_use_listitem ( playerid ) ) ;
				
			format ( scm_string, sizeof scm_string, "%s продал одно из т/с %s", p_info [ playerid ] [ name ], log_name ) ;
			WriteLog ( playerid, TYPE_LOG_ADMIN, scm_string ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: setstats_db_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, col_gray, "{"#cRInfo"}* {"#cGRInfo"}Активных счетов не найдено." ) ;
		return 1 ;
	}
	
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ] ;
	for ( new j = 0 ; j < rows ; j ++ )
	{
		new _db_id = cache_get_field_content_int ( j, "db_id", sql_connection ) ;
		new _db_money = cache_get_field_content_int ( j, "db_money", sql_connection ) ;
		
		set_player_listitem_values ( playerid, j, _db_id ) ;
		
		format ( line_string, sizeof line_string, "{"#cWH"}№%d - %d$\n", _db_id, _db_money ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_setstats_bank, DIALOG_STYLE_LIST, "{"#cBHD"}Банковские счета", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

callback: setstats_vehicle_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, col_gray, "{"#cRInfo"}* {"#cGRInfo"}У игрока нет транспорта." ) ;
		return 1 ;
	}
	
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ] ;
	for ( new j = 0 ; j < rows ; j ++ )
	{
		new _v_id = cache_get_field_content_int ( j, "v_id", sql_connection ) ;
		new _v_model = cache_get_field_content_int ( j, "v_model", sql_connection ) ;
		new _v_price = cache_get_field_content_int ( j, "v_price", sql_connection ) ;
		
		set_player_listitem_values ( playerid, j, _v_id ) ;
		
		format ( line_string, sizeof line_string, "{"#cWH"}%s, {"#cGN"}%d$\n", GetVehicleNameEx ( -1, _v_model ), _v_price ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_setstats_vehicle, DIALOG_STYLE_LIST, "{"#cBHD"}Транспорта", global_string, "Продать", "Назад" ) ;
	return 1 ;
}