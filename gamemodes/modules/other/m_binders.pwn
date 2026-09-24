enum _player_binder
{
	bind_insert_id,
	bind_name [ 128 ],
	bind_text_1 [ 128 ],
	bind_text_2 [ 128 ],
	bind_text_3 [ 128 ],
	bind_text_4 [ 128 ],
	bind_text_5 [ 128 ]
} ;
new player_binder [ MAX_PLAYERS ] [ MAX_BINDS ] [ _player_binder ] ;
new bool: player_binds_sql [ MAX_PLAYERS ] ;
new bind_inc_id = 1 ;

new player_keyboard [ MAX_PLAYERS ] ;
new player_binder_timer [ MAX_PLAYERS ] ;

stock clear_player_binds ( playerid )
{
	player_keyboard [ playerid ] = 
	player_binder_timer [ playerid ] = -1 ;
	
	for ( new i = 0 ; i < MAX_BINDS ; i ++ )
	{
        player_binder [ playerid ] [ i ] [ bind_insert_id ] = -1 ;
	}

	player_binder_loaded [ playerid ] = 
	player_binds_sql [ playerid ] = false ;
	return 1 ;
}

stock binder_OnPlayerDisconnect ( playerid )
{
	if ( player_binder_timer [ playerid ] != -1 )
	{
		KillTimer ( player_binder_timer [ playerid ] ) ;
		player_binder_timer [ playerid ] = -1 ;
	}
	return 1 ;
}

stock EmulateBindCommand ( playerid, _str [ ] )
{
	if ( _str [ 0 ] == '/' )
	{
		PC_EmulateCommand ( playerid, _str ) ;
		return 1 ;
	}

	OnPlayerText ( playerid, _str ) ;
	return 1 ;
}

callback: callback_binder_timer ( playerid, _id, _type )
{
	KillTimer ( player_binder_timer [ playerid ] ) ;
	player_binder_timer [ playerid ] = -1 ;
	switch ( _type )
	{
		case 1:
		{
			if ( strlen ( player_binder [ playerid ] [ _id ] [ bind_text_1 ] ) > 1 )
			{
				EmulateBindCommand ( playerid, player_binder [ playerid ] [ _id ] [ bind_text_1 ] ) ;
				player_binder_timer [ playerid ] = SetTimerEx ( "callback_binder_timer", 1000, false, "iii", playerid, _id, 2 ) ;
			}
		}
		case 2:
		{
			if ( strlen ( player_binder [ playerid ] [ _id ] [ bind_text_2 ] ) > 1 )
			{
				EmulateBindCommand ( playerid, player_binder [ playerid ] [ _id ] [ bind_text_2 ] ) ;
				player_binder_timer [ playerid ] = SetTimerEx ( "callback_binder_timer", 1000, false, "iii", playerid, _id, 3 ) ;
			}
		}
		case 3:
		{
			if ( strlen ( player_binder [ playerid ] [ _id ] [ bind_text_3 ] ) > 1 )
			{
				EmulateBindCommand ( playerid, player_binder [ playerid ] [ _id ] [ bind_text_3 ] ) ;
				player_binder_timer [ playerid ] = SetTimerEx ( "callback_binder_timer", 1000, false, "iii", playerid, _id, 4 ) ;
			}
		}
		case 4:
		{
			if ( strlen ( player_binder [ playerid ] [ _id ] [ bind_text_4 ] ) > 1 )
			{
				EmulateBindCommand ( playerid, player_binder [ playerid ] [ _id ] [ bind_text_4 ] ) ;
				player_binder_timer [ playerid ] = SetTimerEx ( "callback_binder_timer", 1000, false, "iii", playerid, _id, 5 ) ;
			}
		}
		case 5:
		{
			if ( strlen ( player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) > 1 )
			{
				EmulateBindCommand ( playerid, player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) ;
			}
		}
		
	}
	return 1 ;
}

CMD:b1 ( playerid )
{
	show_playerbinder ( playerid ) ;
	return 1 ;
}

CMD:b2 ( playerid )
{
	show_playerbinder ( playerid ) ;
	return 1 ;
}

CMD:b3 ( playerid )
{
	show_playerbinder ( playerid ) ;
	return 1 ;
}

CMD:b4 ( playerid )
{
	show_playerbinder ( playerid ) ;
	return 1 ;
}

CMD:b5 ( playerid )
{
	show_playerbinder ( playerid ) ;
	return 1 ;
}

stock show_playerbinder ( playerid )
{
	#if defined m_inventory
		if ( used_inventory [ playerid ] == true ) return 1 ;
	#endif
	
	#if defined m_craft
	    if ( used_craft [ playerid ] == true ) return 1 ;
	#endif
	
	if ( player_keyboard [ playerid ] == 2 )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Откройте биндер через клавиатуру!" ) ;
		return 1 ;
	}
	if ( ! player_binder_loaded [ playerid ] )
	{
		new sql_string [ 59 + 9 ] ;
		format ( sql_string, sizeof ( sql_string ), "SELECT * FROM `users_binds` WHERE `u_id` = '%d' LIMIT %d", p_info [ playerid ] [ id ], MAX_BINDS ) ;
		mysql_tquery ( sql_connection, sql_string, "loaded_player_binds", "ii", playerid, 1 ) ;
		return 1 ;
	}

	global_string [ 0 ] = EOS ;
	if ( player_binder_count [ playerid ] < MAX_BINDS ) strcat ( global_string, "{"#cBL"}Создать бинд\n" ) ;
	
	new line_string [ 128 ], _count = 0 ;
	for ( new i = 0 ; i < MAX_BINDS ; i ++ )
	{
		if ( player_binder [ playerid ] [ i ] [ bind_insert_id ] == -1 ) continue ;
		format ( line_string, sizeof line_string, "{"#cBL"}%d.{ffffff} %s\n", _count + 1, player_binder [ playerid ] [ i ] [ bind_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		set_player_listitem_values ( playerid, _count, i ) ;
		_count ++ ;
	}

	show_dialog ( playerid, d_binder, DIALOG_STYLE_LIST, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
	return 1 ;
}

stock show_add_binds ( playerid, _i )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 700, "\
		Название\t{"#cOR"}%s\n\
		Строка 1\t{"#cOR"}%s\n\
		Строка 2\t{"#cOR"}%s\n\
		Строка 3\t{"#cOR"}%s\n\
		Строка 4\t{"#cOR"}%s\n\
		Строка 5\t{"#cOR"}%s\n\
		{"#cGRDialog"}Сохранить\t\n\
		{"#cGRDialog"}Удалить\t", player_binder [ playerid ] [ _i ] [ bind_name ],
	player_binder [ playerid ] [ _i ] [ bind_text_1 ], player_binder [ playerid ] [ _i ] [ bind_text_2 ],
	player_binder [ playerid ] [ _i ] [ bind_text_3 ], player_binder [ playerid ] [ _i ] [ bind_text_4 ],
	player_binder [ playerid ] [ _i ] [ bind_text_5 ] ) ;
	show_dialog ( playerid, d_binder_add, DIALOG_STYLE_TABLIST, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
	return 1 ;
}

stock show_open_binds ( playerid, _i )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 700, "\
		Строка 1\t{"#cOR"}%s\n\
		Строка 2\t{"#cOR"}%s\n\
		Строка 3\t{"#cOR"}%s\n\
		Строка 4\t{"#cOR"}%s\n\
		Строка 5\t{"#cOR"}%s\n\
		{"#cGRDialog"}Отправить\t\n\
		{"#cGRDialog"}Удалить\t",
	player_binder [ playerid ] [ _i ] [ bind_text_1 ], player_binder [ playerid ] [ _i ] [ bind_text_2 ],
	player_binder [ playerid ] [ _i ] [ bind_text_3 ], player_binder [ playerid ] [ _i ] [ bind_text_4 ],
	player_binder [ playerid ] [ _i ] [ bind_text_5 ] ) ;
	show_dialog ( playerid, d_binder_settings, DIALOG_STYLE_TABLIST, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
	return 1 ;
}

stock binders_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_binder:
		{
			if ( ! response ) return clear_player_listitem_values ( playerid ) ;

			if ( player_binder_count [ playerid ] < MAX_BINDS )
			{
				for ( new i = 0 ; i < MAX_BINDS ; i ++ )
				{
					if ( player_binder [ playerid ] [ i ] [ bind_insert_id ] != -1 ) continue ;
				
					set_player_use_listitem ( playerid, i ) ;
					break ;
				}
		
				if ( listitem == 0 ) show_add_binds ( playerid, get_player_use_listitem ( playerid ) ) ;
				else
				{
					new i = get_player_listitem_values ( playerid, listitem - 1 ) ;
					
					show_open_binds ( playerid, i ) ;
					set_player_use_listitem ( playerid, i ) ;
				}
				clear_player_listitem_values ( playerid ) ;
			}
			else
			{
				new i = get_player_listitem_values ( playerid, listitem ) ;
				clear_player_listitem_values ( playerid ) ;
				
				show_open_binds ( playerid, i ) ;
				set_player_use_listitem ( playerid, i ) ;
			}
			return 1 ;
		}
		case d_binder_add:
		{
			if ( ! response ) return 1 ;

			new _free_id = get_player_use_listitem ( playerid ) ;
			if ( listitem == 6 )
			{
				if ( strlen ( player_binder [ playerid ] [ _free_id ] [ bind_name ] ) > 3 &&
					strlen ( player_binder [ playerid ] [ _free_id ] [ bind_text_1 ] ) > 3 &&
					strlen ( player_binder [ playerid ] [ _free_id ] [ bind_text_2 ] ) > 3 )
				{
					bind_inc_id ++ ;
				
					player_binder_count [ playerid ] += 1 ;
					player_binder [ playerid ] [ _free_id ] [ bind_insert_id ] = bind_inc_id ;
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 512, "INSERT INTO `users_binds` (`inc_id`,`u_id`,`bind_name`,`bind_text_1`,`bind_text_2`,`bind_text_3`,`bind_text_4`,`bind_text_5`,`bind_date`) VALUES ('%d','%d','%s','%s','%s','%s','%s','%s',NOW( ))",
					bind_inc_id, p_info [ playerid ] [ id ],
					player_binder [ playerid ] [ _free_id ] [ bind_name ], player_binder [ playerid ] [ _free_id ] [ bind_text_1 ], player_binder [ playerid ] [ _free_id ] [ bind_text_2 ],
					player_binder [ playerid ] [ _free_id ] [ bind_text_3 ], player_binder [ playerid ] [ _free_id ] [ bind_text_4 ], player_binder [ playerid ] [ _free_id ] [ bind_text_5 ] ) ;
					mysql_tquery ( sql_connection, global_string ) ;
				}
			}
			else if ( listitem == 7 )
			{
			}
			else
			{
				global_string [ 0 ] = EOS ;
				switch ( listitem )
				{
					case 0: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_name ] ) ;
					case 1: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_1 ] ) ;
					case 2: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_2 ] ) ;
					case 3: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_3 ] ) ;
					case 4: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_4 ] ) ;
					case 5: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_5 ] ) ;
				}

				SetPVarInt ( playerid, "list_item", listitem ) ;
				show_dialog ( playerid, d_binder_add_set, DIALOG_STYLE_INPUT, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
			}
			return 1 ;
		}
		case d_binder_add_set:
		{
			if ( ! response ) return DeletePVar ( playerid, "list_item" ), show_add_binds ( playerid, get_player_use_listitem ( playerid ) ) ;
			
			new _free_id = get_player_use_listitem ( playerid ) ;
			if ( strlen ( inputtext ) > 128 || is_text_invalid_binder ( inputtext ) || check_advertise ( playerid, inputtext, report_type_binder ) )
			{
				new list_item = GetPVarInt ( playerid, "list_item" ) ;
				switch ( list_item )
				{
					case 0: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_name ] ) ;
					case 1: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_1 ] ) ;
					case 2: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_2 ] ) ;
					case 3: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_3 ] ) ;
					case 4: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_4 ] ) ;
					case 5: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_5 ] ) ;
				}
				
				show_dialog ( playerid, d_binder_add_set, DIALOG_STYLE_INPUT, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
				return 1 ;
			}
			
			new list_item = GetPVarInt ( playerid, "list_item" ) ;
			DeletePVar ( playerid, "list_item" ) ;
			switch ( list_item )
			{
				case 0: format ( player_binder [ playerid ] [ _free_id ] [ bind_name ], 128, "%s", inputtext ) ;
				case 1: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_1 ], 128, "%s", inputtext ) ;
				case 2: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_2 ], 128, "%s", inputtext ) ;
				case 3: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_3 ], 128, "%s", inputtext ) ;
				case 4: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_4 ], 128, "%s", inputtext ) ;
				case 5: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_5 ], 128, "%s", inputtext ) ;
			}
			
			show_add_binds ( playerid, _free_id ) ;
			return 1 ;
		}
		case d_binder_settings:
		{
			if ( listitem == 6 )
			{
				new _free_id = get_player_use_listitem ( playerid ) ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "DELETE FROM `users_binds` WHERE `inc_id` = '%d' LIMIT 1", 
				player_binder [ playerid ] [ _free_id ] [ bind_insert_id ] ) ;
				mysql_tquery ( sql_connection, global_string ) ;
				
				player_binder_count [ playerid ] -= 1 ;
				player_binder [ playerid ] [ _free_id ] [ bind_insert_id ] = -1 ;
				format ( player_binder [ playerid ] [ _free_id ] [ bind_name ], 128, " " ) ;
				format ( player_binder [ playerid ] [ _free_id ] [ bind_text_1 ], 128, " " ) ;
				format ( player_binder [ playerid ] [ _free_id ] [ bind_text_2 ], 128, " " ) ;
				format ( player_binder [ playerid ] [ _free_id ] [ bind_text_3 ], 128, " " ) ;
				format ( player_binder [ playerid ] [ _free_id ] [ bind_text_4 ], 128, " " ) ;
				format ( player_binder [ playerid ] [ _free_id ] [ bind_text_5 ], 128, " " ) ;
			}
			else if ( listitem == 5 )
			{
				new _free_id = get_player_use_listitem ( playerid ) ;
		
				player_binder_timer [ playerid ] = SetTimerEx ( "callback_binder_timer", 100, false, "iii", playerid, _free_id, 1 ) ;
				
			}
			else
			{
				new _free_id = get_player_use_listitem ( playerid ) ;
				
				global_string [ 0 ] = EOS ;
				switch ( listitem )
				{
					case 0: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_1 ] ) ;
					case 1: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_2 ] ) ;
					case 2: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_3 ] ) ;
					case 3: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_4 ] ) ;
					case 4: format ( global_string, 256, "{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_5 ] ) ;
				}
				
				SetPVarInt ( playerid, "list_item", listitem ) ;
				show_dialog ( playerid, d_binder_settings_set, DIALOG_STYLE_INPUT, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
			}
			return 1 ;
		}
		case d_binder_settings_set:
		{
			if ( ! response ) return DeletePVar ( playerid, "list_item" ), show_open_binds ( playerid, get_player_use_listitem ( playerid ) ) ;
			
			new _free_id = get_player_use_listitem ( playerid ) ;
			if ( strlen ( inputtext ) > 128 || is_text_invalid_binder ( inputtext ) || check_advertise ( playerid, inputtext, report_type_binder ) )
			{
				new list_item = GetPVarInt ( playerid, "list_item" ) ;
				switch ( list_item )
				{
					case 0: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_1 ] ) ;
					case 1: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_2 ] ) ;
					case 2: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_3 ] ) ;
					case 3: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_4 ] ) ;
					case 4: format ( global_string, 256, "{"#cRD"}* Вы ввели некорректные символы!\n\n{"#cWH"}Текущий текст: {"#cOR"}%s\n\n{"#cGRDialog"}* Если Вы хотите удалить текст, то оставьте поле пустым.\n{"#cGRDialog"}* Введите текст в окно ниже:", player_binder [ playerid ] [ _free_id ] [ bind_text_5 ] ) ;
				}
				
				show_dialog ( playerid, d_binder_settings_set, DIALOG_STYLE_INPUT, "{"#cBHD"}Биндер", global_string, "Далее", "Отмена" ) ;
				return 1 ;
			}
			
			new list_item = GetPVarInt ( playerid, "list_item" ) ;
			DeletePVar ( playerid, "list_item" ) ;
			switch ( list_item )
			{
				case 0: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_1 ], 128, "%s", inputtext ) ;
				case 1: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_2 ], 128, "%s", inputtext ) ;
				case 2: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_3 ], 128, "%s", inputtext ) ;
				case 3: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_4 ], 128, "%s", inputtext ) ;
				case 4: format ( player_binder [ playerid ] [ _free_id ] [ bind_text_5 ], 128, "%s", inputtext ) ;
			}
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 700, "UPDATE `users_binds` SET `bind_name` = '%s', `bind_text_1` = '%s', `bind_text_2` = '%s', \
										`bind_text_3` = '%s', `bind_text_4` = '%s', `bind_text_5` = '%s', `bind_date` = NOW() WHERE `inc_id` = '%d' AND `u_id` = '%d' LIMIT 1", 
			player_binder [ playerid ] [ _free_id ] [ bind_name ], player_binder [ playerid ] [ _free_id ] [ bind_text_1 ], player_binder [ playerid ] [ _free_id ] [ bind_text_2 ],
			player_binder [ playerid ] [ _free_id ] [ bind_text_3 ], player_binder [ playerid ] [ _free_id ] [ bind_text_4 ], player_binder [ playerid ] [ _free_id ] [ bind_text_5 ],
			player_binder [ playerid ] [ _free_id ] [ bind_insert_id ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
			
			show_open_binds ( playerid, _free_id ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock binders_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_binds` ORDER BY `users_binds`.`inc_id` DESC LIMIT 1", "callback_bind_inc_id" ) ;
	return 1 ;
}

callback: callback_bind_inc_id ( )
{
    new rows, fields, time = GetTickCount ( ) ;
	cache_get_data ( rows, fields ) ;
	
    if ( rows ) bind_inc_id = cache_get_field_content_int ( 0, "inc_id", sql_connection ) ;
    printf("[SERVER] Загружена %d последняя строка биндов. (%d ms)", bind_inc_id, GetTickCount ( ) - time ) ;
	return 1 ;
}

callback: loaded_player_binds ( playerid, _type )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	player_binder_count [ playerid ] = rows ;
	if ( rows )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
		    player_binder [ playerid ] [ i ] [ bind_insert_id ] = cache_get_field_content_int ( i, "inc_id", sql_connection ) ;

		    cache_get_field_content ( i, "bind_name", player_binder [ playerid ] [ i ] [ bind_name ], sql_connection, 128 ) ;
		    cache_get_field_content ( i, "bind_text_1", player_binder [ playerid ] [ i ] [ bind_text_1 ], sql_connection, 128 ) ;
		    cache_get_field_content ( i, "bind_text_2", player_binder [ playerid ] [ i ] [ bind_text_2 ], sql_connection, 128 ) ;
		    cache_get_field_content ( i, "bind_text_3", player_binder [ playerid ] [ i ] [ bind_text_3 ], sql_connection, 128 ) ;
		    cache_get_field_content ( i, "bind_text_4", player_binder [ playerid ] [ i ] [ bind_text_4 ], sql_connection, 128 ) ;
		    cache_get_field_content ( i, "bind_text_5", player_binder [ playerid ] [ i ] [ bind_text_5 ], sql_connection, 128 ) ;
		}
	}
	else
	{
		player_binder_count [ playerid ] = 0 ;
		player_binder [ playerid ] [ 0 ] [ bind_insert_id ] = -1 ;
			
		format ( player_binder [ playerid ] [ 0 ] [ bind_name ], 128, " " ) ;
		format ( player_binder [ playerid ] [ 0 ] [ bind_text_1 ], 128, " " ) ;
		format ( player_binder [ playerid ] [ 0 ] [ bind_text_2 ], 128, " " ) ;
		format ( player_binder [ playerid ] [ 0 ] [ bind_text_3 ], 128, " " ) ;
		format ( player_binder [ playerid ] [ 0 ] [ bind_text_4 ], 128, " " ) ;
		format ( player_binder [ playerid ] [ 0 ] [ bind_text_5 ], 128, " " ) ;
	}
	if ( _type == 0 )
	{
		bindShow ( playerid ) ;
		if ( player_binder_count [ playerid ] > 0 ) bindAddItem ( playerid ) ;
            
		toggle_controlable ( playerid, false ) ;
		onServerSendData ( playerid, 7, 3, "3" ) ;
	}
	else if ( _type == 1 ) show_playerbinder ( playerid ) ;
	player_binder_loaded [ playerid ] = true ;
	player_binds_sql [ playerid ] = false ;
	return 1 ;
}

#include <custom/binders>
#include <custom/binders_new>

stock update_packet_binds ( playerid )
{
	if ( player_keyboard [ playerid ] == 2 )
	{
		SetKeyboardParams ( playerid ) ;
	}
	return 1 ;
}

stock show_packet_keyboard ( playerid, actionId, data [ ] )
{
	new Node: json = JSON_Object();
	JSON_Parse ( data, json ) ;
	
	new _param2 ;
	JSON_GetInt ( json, "position", _param2 ) ;
	if ( actionId == 1 )
	{
		if ( _param2 == 1 )
		{
			onServerSendData ( playerid, 7, 4, "" ) ;
			if ( ! player_binder_loaded [ playerid ] )
			{
				new sql_string [ 59 + 9 ] ;
				format ( sql_string, sizeof ( sql_string ), "SELECT * FROM `users_binds` WHERE `u_id` = '%d' LIMIT %d", p_info [ playerid ] [ id ], MAX_BINDS ) ;
				mysql_tquery ( sql_connection, sql_string, "loaded_player_binds", "ii", playerid, 0 ) ;
				return 1 ;
			}
			else
			{
				bindShow ( playerid ) ;
				if ( player_binder_count [ playerid ] > 0 ) bindAddItem ( playerid ) ;
				
				toggle_controlable ( playerid, false ) ;
				onServerSendData ( playerid, 7, 3, "3" ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			toggle_controlable ( playerid, true ) ;
			bindHide ( playerid ) ;
		}
	}
	return 1 ;
}

stock show_packet_binders ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			toggle_controlable ( playerid, true ) ;
			
			bindHide ( playerid ) ;
			onServerSendData ( playerid, 7, 3, "2" ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				new bool: _created = false ;
				for ( new i = 0 ; i < MAX_BINDS ; i ++ )
				{
					if ( player_binder [ playerid ] [ i ] [ bind_insert_id ] != -1 ) continue ;
				
					_param3 = i ;
				
					set_player_use_listitem ( playerid, _param3 ) ;
					player_binder [ playerid ] [ _param3 ] [ bind_insert_id ] = -1 ;
						
					format ( player_binder [ playerid ] [ _param3 ] [ bind_name ], 128, "" ) ;
					format ( player_binder [ playerid ] [ _param3 ] [ bind_text_1 ], 128, "" ) ;
					format ( player_binder [ playerid ] [ _param3 ] [ bind_text_2 ], 128, "" ) ;
					format ( player_binder [ playerid ] [ _param3 ] [ bind_text_3 ], 128, "" ) ;
					format ( player_binder [ playerid ] [ _param3 ] [ bind_text_4 ], 128, "" ) ;
					format ( player_binder [ playerid ] [ _param3 ] [ bind_text_5 ], 128, "" ) ;
					
					bindHide ( playerid ) ;
					bindEditShow ( playerid ) ;
					bindEditAddItem ( playerid, _param3 ) ;
					
					_created = true ;
					break ;
				}
				
				if ( ! _created ) send_check_cinfo ( playerid, "У Вас создано максимальное количество биндов", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			bindHide ( playerid ) ;
			onServerSendData ( playerid, 7, 4, "" ) ;
            
			toggle_controlable ( playerid, true ) ;
				
			player_binder_timer [ playerid ] = SetTimerEx ( "callback_binder_timer", 100, false, "iii", playerid, _param3, 1 ) ;
		}
		else if ( _param2 == 3 )
		{
			set_player_use_listitem ( playerid, _param3 ) ;
			bindHide ( playerid ) ;
			bindEditShow ( playerid ) ;
			bindEditAddItem ( playerid, _param3 ) ;
		}
		else if ( _param2 == 4 )
		{
			if ( player_binder [ playerid ] [ _param3 ] [ bind_insert_id ] != -1 )
			{
				static const _str2 [ ] = "DELETE FROM `users_binds` WHERE `inc_id` = '%d' LIMIT 1" ;
				new sql_string [ sizeof _str2 + 9 ] ;
				format ( sql_string, sizeof sql_string, _str2, player_binder [ playerid ] [ _param3 ] [ bind_insert_id ] ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
				
				player_binder_count [ playerid ] -= 1 ;
				player_binder [ playerid ] [ _param3 ] [ bind_insert_id ] = -1 ;
					
				format ( player_binder [ playerid ] [ _param3 ] [ bind_name ], 128, "" ) ;
				format ( player_binder [ playerid ] [ _param3 ] [ bind_text_1 ], 128, "" ) ;
				format ( player_binder [ playerid ] [ _param3 ] [ bind_text_2 ], 128, "" ) ;
				format ( player_binder [ playerid ] [ _param3 ] [ bind_text_3 ], 128, "" ) ;
				format ( player_binder [ playerid ] [ _param3 ] [ bind_text_4 ], 128, "" ) ;
				format ( player_binder [ playerid ] [ _param3 ] [ bind_text_5 ], 128, "" ) ;
			}
			
			bindShow ( playerid ) ;
			if ( player_binder_count [ playerid ] > 0 ) bindAddItem ( playerid ) ;
		}
	}
	return 1 ;
}

stock show_packet_binders_str ( playerid, _param1, _param2, _str [ ] )
{
	if ( _param1 == 2 )
	{
		if ( _param2 == 1 )
		{
			bindEditHide ( playerid ) ;
			bindShow ( playerid ) ;
			if ( player_binder_count [ playerid ] > 0 ) bindAddItem ( playerid ) ;
		}
	}
	else if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ) ;
		if ( player_binder [ playerid ] [ _id ] [ bind_insert_id ] == -1 )
		{
			bind_inc_id ++ ;
			player_binder_count [ playerid ] += 1 ;
			player_binder [ playerid ] [ _id ] [ bind_insert_id ] = bind_inc_id ;
			format ( player_binder [ playerid ] [ _id ] [ bind_name ], 128, "%s", _str ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 512, "INSERT INTO `users_binds` (`inc_id`,`u_id`,`bind_name`,`bind_text_1`,`bind_text_2`,`bind_text_3`,`bind_text_4`,`bind_text_5`,`bind_date`) VALUES ('%d','%d','%s','%s','%s','%s','%s','%s',NOW( ))",
			bind_inc_id, p_info [ playerid ] [ id ],
			player_binder [ playerid ] [ _id ] [ bind_name ], player_binder [ playerid ] [ _id ] [ bind_text_1 ], player_binder [ playerid ] [ _id ] [ bind_text_2 ],
			player_binder [ playerid ] [ _id ] [ bind_text_3 ], player_binder [ playerid ] [ _id ] [ bind_text_4 ], player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
			
			send_check_cinfo ( playerid, "Бинд успешно создан. Нажмите 'отмена' для закрытия окна.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			return 1 ;
		}
		
		switch ( _param2 )
		{
			case 0: format ( player_binder [ playerid ] [ _id ] [ bind_name ], 128, "%s", _str ) ;
			case 1: format ( player_binder [ playerid ] [ _id ] [ bind_text_1 ], 128, "%s", _str ) ;
			case 2: format ( player_binder [ playerid ] [ _id ] [ bind_text_2 ], 128, "%s", _str ) ;
			case 3: format ( player_binder [ playerid ] [ _id ] [ bind_text_3 ], 128, "%s", _str ) ;
			case 4: format ( player_binder [ playerid ] [ _id ] [ bind_text_4 ], 128, "%s", _str ) ;
			case 5: format ( player_binder [ playerid ] [ _id ] [ bind_text_5 ], 128, "%s", _str ) ;
		}
			
		global_string [ 0 ] = EOS ;
		format ( global_string, 700, "UPDATE `users_binds` SET `bind_name` = '%s', `bind_text_1` = '%s', `bind_text_2` = '%s', \
									`bind_text_3` = '%s', `bind_text_4` = '%s', `bind_text_5` = '%s', `bind_date` = NOW() WHERE `inc_id` = '%d' AND `u_id` = '%d' LIMIT 1", 
		player_binder [ playerid ] [ _id ] [ bind_name ], player_binder [ playerid ] [ _id ] [ bind_text_1 ], player_binder [ playerid ] [ _id ] [ bind_text_2 ],
		player_binder [ playerid ] [ _id ] [ bind_text_3 ], player_binder [ playerid ] [ _id ] [ bind_text_4 ], player_binder [ playerid ] [ _id ] [ bind_text_5 ],
		player_binder [ playerid ] [ _id ] [ bind_insert_id ], p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
		
		send_check_cinfo ( playerid, "Бинд успешно сохранён. Нажмите 'отмена' для закрытия окна.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	return 1 ;
}

/*
	
	CREATE TABLE `users_binds` (`inc_id` INT(11) NOT NULL AUTO_INCREMENT , `u_id` INT(11) NOT NULL DEFAULT '0' , `bind_name` VARCHAR(128) NULL DEFAULT NULL , `bind_text_1` VARCHAR(128) NULL DEFAULT NULL , `bind_text_2` VARCHAR(128) NULL DEFAULT NULL , `bind_text_3` VARCHAR(128) NULL DEFAULT NULL , `bind_text_4` VARCHAR(128) NULL DEFAULT NULL , `bind_text_5` VARCHAR(128) NULL DEFAULT NULL , PRIMARY KEY (`inc_id`)) ENGINE = InnoDB; 
	ALTER TABLE `users_binds` ADD `bind_date` DATE NOT NULL AFTER `bind_text_5`;
	
*/