new bool: rieltore_opened [ MAX_PLAYERS ] ;
new bool: player_sim_auction [ MAX_PLAYERS ] ;

#define ofm_formula_auction(%1)	(%1 * 4) // + 1

stock find_your_bet_sim ( playerid )
{
    new _c_count = 0, _c_card = 0 ;

	static query_string[] = "SELECT `c_account`,`c_id` FROM `card_bet` WHERE `c_account` = '%d' LIMIT 1";
	new fmt_query[(sizeof(query_string) - 4) + 11 * 5];
	format ( fmt_query, sizeof ( fmt_query ), query_string, p_info [ playerid ] [ id ] ) ;
	new Cache:result = mysql_query ( sql_connection, fmt_query ) ;
	_c_count = cache_num_rows ( ) ;
	if ( _c_count ) _c_card = cache_get_field_content_int ( 0, "c_id", sql_connection ) ;
	cache_delete ( result ) ;
	return _c_card ;
}

stock get_sim_number ( sim_id )
{
    new _c_id,
		query_string [ 64 + 9 ] ;
	format ( query_string, sizeof ( query_string ),"SELECT `c_id` FROM `card_auction` WHERE `c_id` = '%d' LIMIT 1", sim_id ) ;
	new Cache:result = mysql_query ( sql_connection, query_string ) ;
	_c_id = cache_get_field_content_int ( 0, "c_id", sql_connection ) ;
	cache_delete ( result ) ;
	return _c_id ;
}

callback: find_your_bet ( playerid, _i_id, _type )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( ! rows ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не ставили ставку." ) ;
	
	if ( _type == 3 )
	{
		new _c_bet = cache_get_field_content_int ( 0, "c_bet", sql_connection ) ;
		
		give_money ( playerid, _c_bet ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, _c_bet, "отмена ставки" ) ;

		new scm_string [ 176 ] ;
		format ( scm_string, 128, "DELETE FROM `card_bet` WHERE `c_account` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
		mysql_query ( sql_connection, scm_string ) ;
		
		format ( scm_string, sizeof ( scm_string ),"SELECT `c_bet`, `c_account` FROM `card_bet` WHERE `c_id` = '%d' AND `c_account` != '%d' ORDER BY `card_bet`.`c_bet` DESC LIMIT 1", _i_id, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, scm_string, "callback_last_bet", "ii", _i_id, _type ) ;
	}
	return 1 ;
}

callback: callback_last_bet ( _i_id, _type )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( _type == 3 )
	{
		if ( ! rows )
		{
			new scm_string [ 110 + ( 3 * 9 ) ] ;
			format ( scm_string, sizeof scm_string, "UPDATE `card_auction` SET `c_bet` = '0', `c_account_bet` = '0' WHERE `c_id` = '%d' LIMIT 1", _i_id ) ;
			mysql_tquery ( sql_connection, scm_string, "", "" ) ;
			return 1 ;
		}
		
		new _c_bet = cache_get_field_content_int ( 0, "c_bet", sql_connection ) ;
		new _c_account = cache_get_field_content_int ( 0, "c_account", sql_connection ) ;
		
		new scm_string [ 110 + ( 3 * 9 ) ] ;
		format ( scm_string, sizeof scm_string, "UPDATE `card_auction` SET `c_bet` = '%d', `c_account_bet` = '%d' WHERE `c_id` = '%d' LIMIT 1", _c_bet, _c_account, _i_id ) ;
		mysql_tquery ( sql_connection, scm_string, "", "" ) ;
	}
	return 1 ;
}

stock auction_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_rieltore_biz_select:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
		        show_biz_rieltore ( playerid ) ;
		        return 1 ;
		    }

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
				    page_count [ playerid ] = page_count [ playerid ] ;
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка бизнесов." ) ;

					show_rieltore_biz_select ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] -= 1 ;

                show_rieltore_biz_select ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
            	    page_count [ playerid ] = page_count [ playerid ] ;
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка бизнесов." ) ;

					show_rieltore_biz_select ( playerid ) ;
					page_count [ playerid ] = 1 ;
					return 1;
				}
                page_count [ playerid ] += 1 ;

                show_rieltore_biz_select ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;

			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}%s", b_info [ select_id ] [ b_name ] ) ;

            show_dialog(playerid, d_rieltore_biz_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию бизнеса", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
			page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
		}
		case d_rieltore_biz_select_info:
		{
		    if ( ! response )
		    {
		        page_count [ playerid ] = 0 ;
		        show_biz_rieltore ( playerid ) ;
		        return 1 ;
		    }
		    switch ( listitem )
			{
			    case 0:
			    {
			        new bizz_id = GetPVarInt ( playerid, "b_id_select" ) ;

			        SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
					is_gps_used { playerid } = 1 ;

					SetPlayerRaceCheckpoint ( playerid, 1, b_info [ bizz_id ] [ b_position ] [ 0 ], b_info [ bizz_id ] [ b_position ] [ 1 ], b_info [ bizz_id ] [ b_position ] [ 2 ],0.0,0.0,0.0,2.0);
					DeletePVar ( playerid, "b_id_select" ) ;
				}
				case 1:
				{
				    new bizz_id = GetPVarInt ( playerid, "b_id_select" ) ;

					GetPlayerPos ( playerid, last_coord [ playerid ] [ 0 ], last_coord [ playerid ] [ 1 ], last_coord [ playerid ] [ 2 ] ) ;
					GetPlayerFacingAngle ( playerid, last_coord [ playerid ] [ 3 ] ) ;

					last_virt [ playerid ] = GetPlayerVirtualWorld ( playerid ) ;
    				last_int [ playerid ] = GetPlayerInterior ( playerid ) ;

					rieltore_opened [ playerid ] = true ;

                    set_world ( playerid, 0 ) ;
                    set_interior ( playerid, 0 ) ;
					//set_pos ( playerid, b_info [ bizz_id ] [ b_position ] [ 0 ], b_info [ bizz_id ] [ b_position ] [ 1 ], b_info [ bizz_id ] [ b_position ] [ 2 ]-50.0, 90.0, 0, 0);

                    toggle_controlable ( playerid, false ) ;
                    TogglePlayerSpectating ( playerid, true ) ;

                    SetPlayerCameraPos(playerid, b_info [ bizz_id ] [ b_position ] [ 0 ] - 15, b_info [ bizz_id ] [ b_position ] [ 1 ] + 27, b_info [ bizz_id ] [ b_position ] [ 2 ] + 31);
					SetPlayerCameraLookAt(playerid, b_info [ bizz_id ] [ b_position ] [ 0 ] - 14, b_info [ bizz_id ] [ b_position ] [ 1 ] + 26, b_info [ bizz_id ] [ b_position ] [ 2 ] + 30);
                    p_t_info [ playerid ] [ camera_timer ] = SetTimerEx ( "fixed_camera_pos", 500, 0, "iii", playerid, bizz_id, 1 ) ;

					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Для выхода из режима просмотра нажмите {"#cBL"}\"ПРОБЕЛ (/close)\"{"#cGRInfo"}.");
					DeletePVar ( playerid, "b_id_select" ) ;
				}
			}
		}
		case d_rieltore_biz_finprice:
		{
		    if ( ! response ) return show_rieltore ( playerid ) ;

			global_string [ 0 ] = EOS ;
			new line_string [ 128 ], count_business = 0, insert_bizz = 0, bool:find_biz = false, row_count ;
			for ( new b = 0; b < b_count ; b ++ )
			{
			    if ( b_info [ b ] [ b_price ] * for_tax [ 1 ] != strval ( inputtext ) ) continue ;
			    if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

				insert_bizz ++ ;

				if ( count_business > 10 ) continue ;
				
				set_player_listitem_values ( playerid, insert_bizz - 1, b ) ;

				format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
				strcat ( global_string, line_string ) ;
				
      			count_business ++ ;
				row_count ++ ;
		  		find_biz = true ;
			}
			if ( find_biz == false )
			{
		        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}По Вашему запросу о сортировке бизнесов ничего не было найдено." ) ;
		        show_biz_rieltore ( playerid ) ;
				return 1 ;
			}

			page_count [ playerid ] = 1 ;
			SetPVarInt ( playerid, "find_price", strval ( inputtext ) ) ;
			page_rows [ playerid ] = insert_bizz ;

			if ( page_count [ playerid ] > 1 )
			{
				strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 0 ) ;
				row_count ++ ;
			}
			if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
			{
				strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 1 ) ;
			}
			
			show_dialog(playerid, d_rieltore_biz_finprice_select, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по стоимости", global_string, "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case d_rieltore_biz_finprice_select:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        page_count [ playerid ] = 0 ;
		        DeletePVar ( playerid, "find_price" ) ;
		        page_rows [ playerid ] = 0 ;
		        show_biz_rieltore ( playerid ) ;
		        return 1 ;
			}

			if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка бизнесов." ) ;

					show_rieltore_biz_finprice ( playerid ) ;
					page_count [ playerid ] = 1 ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

				show_rieltore_biz_finprice ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка бизнесов." ) ;

					show_rieltore_biz_finprice ( playerid ) ;
					page_count [ playerid ] = 1 ;
					return 1 ;
				}
                page_count [ playerid ] += 1 ;

                show_rieltore_biz_finprice ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}%s", b_info [ select_id ] [ b_name ] ) ;

            show_dialog(playerid, d_rieltore_biz_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию бизнеса", "Выбрать", "Закрыть" ) ;

			clear_player_listitem_values ( playerid ) ;
            page_count [ playerid ] = 0 ;
            DeletePVar ( playerid, "find_price" ) ;
            page_rows [ playerid ] = 0 ;
		}
		case d_rieltore_biz_type:
		{
		    if ( ! response )
		    {
		        show_biz_rieltore ( playerid ) ;
		        return 1 ;
			}

			global_string [ 0 ] = EOS ;
			new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
			for ( new b = 0; b < b_count ; b ++ )
			{
			    if ( b_info [ b ] [ b_type ] != listitem ) continue ;
			    if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

				if ( count_business < 10 ) set_player_listitem_values ( playerid, insert_bizz, b ) ;

				insert_bizz ++ ;

				if ( count_business > 10 ) continue ;

				format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
				strcat ( global_string, line_string ) ;
				
				count_business ++ ;
				row_count ++ ;
			}

			page_count [ playerid ] = 1 ;
			page_rows [ playerid ] = insert_bizz ;
			SetPVarInt ( playerid, "find_type", listitem ) ;
			
			if ( page_count [ playerid ] > 1 )
			{
				strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 0 ) ;
				row_count ++ ;
			}
			if ( ofm_formula ( page_count [ playerid ] ) < insert_bizz )
			{
				strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 1 ) ;
			}

			show_dialog(playerid, d_rieltore_biz_type_list, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по типу бизнеса", global_string, "Выбрать", "Закрыть" ) ;
		}
		case d_rieltore_biz_type_list:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
            	DeletePVar ( playerid, "find_type" ) ;
		        show_biz_rieltore ( playerid ) ;
		        return 1 ;
			}

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка бизнесов." ) ;

					show_rieltore_biz_type ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

                show_rieltore_biz_type ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка бизнесов." ) ;

					show_rieltore_biz_type ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] += 1 ;

                show_rieltore_biz_type ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}%s", b_info [ select_id ] [ b_name ] ) ;

            show_dialog(playerid, d_rieltore_biz_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию бизнеса", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
            page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
            DeletePVar ( playerid, "find_type" ) ;
		}
		case d_rieltore_biz_free:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
		        show_biz_rieltore ( playerid ) ;
		        return 1 ;
			}

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка бизнесов." ) ;

					show_rieltore_biz_fee ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] -= 1 ;

                show_rieltore_biz_fee ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка бизнесов." ) ;

					show_rieltore_biz_fee ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] += 1 ;

                show_rieltore_biz_fee ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}%s", b_info [ select_id ] [ b_name ] ) ;

            show_dialog(playerid, d_rieltore_biz_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию бизнеса", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
            page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
		}
		case d_rieltore_biz:
		{
		    if ( ! response ) return show_rieltore ( playerid ) ;
			switch ( listitem )
			{
			    case 0:
			    {
					page_count [ playerid ] = 1 ;
					new rows_list = page_count [ playerid ] - 1 ;
					page_rows [ playerid ] = b_count ;

					global_string [ 0 ] = EOS ;
					new line_string [ 128 ], row_count ;
					for ( new b = rows_list * 10 ; b < rows_list * 10 + 10 ; b ++ )
					{
					    if ( b >= page_rows [ playerid ] ) break ;
					    if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

						set_player_listitem_values ( playerid, b - rows_list * 10, b ) ;

						format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", b + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
						strcat ( global_string, line_string ) ;
						
						row_count ++ ;
					}
					
					if ( rows_list > 0 )
					{
						strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 0 ) ;
						row_count ++ ;
					}
					if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
					{
						strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 1 ) ;
					}
					
					show_dialog(playerid, d_rieltore_biz_select, DIALOG_STYLE_LIST, "{"#cBHD"}Список всех бизнесов", global_string, "Выбрать", "Закрыть" ) ;
			    }
			    case 1:
			    {
			        show_dialog ( playerid, d_rieltore_biz_finprice, DIALOG_STYLE_INPUT, "{"#cBHD"}Сортировка по стоимости", "{"#cWH"}Введите желаему сумму стоимости, по которой будет поиск:", "Далее", "Назад" ) ;
			    }
                case 2:
			    {
			        global_string [ 0 ] = EOS ;
			        new line_string [ 128 ] ;
			        for ( new i = 0 ; i < max_type - 2 ; i ++ )
			        {
			            format ( line_string, sizeof ( line_string ), "{"#cBL"}%i.{"#cWH"} %s\n", i + 1, b_types [ i ] ) ;
			            strcat ( global_string, line_string ) ;
			        }
			        show_dialog ( playerid, d_rieltore_biz_type, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по типу бизнеса", global_string, "Выбрать", "Закрыть" ) ;
			    }
			    case 3:
				{
					global_string [ 0 ] = EOS ;
					new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
					for ( new b = 0 ; b < b_count ; b ++ )
					{
					    if ( b_info [ b ] [ b_owner_inc ] != -1 ) continue ;
						if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

						if ( count_business < 10 ) set_player_listitem_values ( playerid, insert_bizz, b ) ;

						insert_bizz ++ ;

						if ( count_business > 10 ) continue ;

						format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
						strcat ( global_string, line_string ) ;
						
						count_business ++ ;
						row_count ++ ;
					}
					if ( insert_bizz == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нет бизнесов на продаже." ) ;

					page_count [ playerid ] = 1 ;
					page_rows [ playerid ] = insert_bizz ;

					if ( page_count [ playerid ] > 1 )
					{
						strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 0 ) ;
						row_count ++ ;
					}
					if ( ofm_formula ( page_count [ playerid ] ) < insert_bizz )
					{
						strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 1 ) ;
					}
			
					show_dialog(playerid, d_rieltore_biz_free, DIALOG_STYLE_LIST, "{"#cBHD"}Бизнесы на продаже", global_string, "Выбрать", "Закрыть" ) ;
			    }
			    case 4:
			    {
					global_string [ 0 ] = EOS ;
					new line_string [ 128 ], row_count ;
					for ( new b = 0 ; b < b_count ; b ++ )
					{
					    if ( row_count >= 40 ) break ;
					    if ( b_info [ b ] [ b_auction_status ] != 1 ) continue ;

						set_player_listitem_values ( playerid, row_count, b ) ;

						format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", b + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
						strcat ( global_string, line_string ) ;
						
						row_count ++ ;
					}
					
					if ( ! row_count ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нет недвижимости на аукционе." ) ;
					show_dialog ( playerid, d_rieltore_biz_auction, DIALOG_STYLE_LIST, "{"#cBHD"}Аукцион", global_string, "GPS", "Закрыть" ) ;
			    }
			}
		}
		case d_rieltore_biz_auction:
		{
			if ( ! response ) return show_biz_rieltore ( playerid ) ;
			
			new _id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
		    SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _id ] [ b_position ] [ 0 ], b_info [ _id ] [ b_position ] [ 1 ], b_info [ _id ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Бизнес обозначен на карте красной меткой." ) ;
			is_gps_used { playerid } = 1 ;
			return 1 ;
		}
		case d_rieltore:
		{
			if ( ! response ) return 1 ;
			switch ( listitem )
			{
				case 0: show_biz_rieltore ( playerid ) ;
				case 1: show_house_rieltore ( playerid ) ;
			}
		}
		case d_rieltore_house_select:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
		    }

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
				    page_count [ playerid ] = page_count [ playerid ] ;
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка домов." ) ;

					show_house_rieltore_select ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] -= 1 ;

                show_house_rieltore_select ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
            	    page_count [ playerid ] = page_count [ playerid ] ;
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка домов." ) ;

					show_house_rieltore_select ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] += 1 ;

                show_house_rieltore_select ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;

			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}Номер дома: {"#cBL"}%d", h_info [ select_id ] [ h_id ] ) ;

            show_dialog(playerid, d_rieltore_house_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию дома", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
			page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
		}
		case d_rieltore_house_select_info:
		{
		    if ( ! response )
		    {
		        page_count [ playerid ] = 0 ;
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
		    }
		    switch ( listitem )
			{
			    case 0:
			    {
			        new bizz_id = GetPVarInt ( playerid, "b_id_select" ) ;

					if ( h_info [ bizz_id ] [ h_podezd ] != -1 )
					{
						new _padik_id = h_info [ bizz_id ] [ h_podezd ] ;
						SetPlayerRaceCheckpoint ( playerid, 1, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
					}
					else SetPlayerRaceCheckpoint ( playerid, 1, h_info [ bizz_id ] [ h_pos ] [ 0 ], h_info [ bizz_id ] [ h_pos ] [ 1 ], h_info [ bizz_id ] [ h_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
					is_gps_used { playerid } = 1 ;
					
					DeletePVar ( playerid, "b_id_select" ) ;
				}
				case 1:
				{
				    new bizz_id = GetPVarInt ( playerid, "b_id_select" ) ;

					GetPlayerPos ( playerid, last_coord [ playerid ] [ 0 ], last_coord [ playerid ] [ 1 ], last_coord [ playerid ] [ 2 ] ) ;
					GetPlayerFacingAngle ( playerid, last_coord [ playerid ] [ 3 ] ) ;

					last_virt [ playerid ] = GetPlayerVirtualWorld ( playerid ) ;
    				last_int [ playerid ] = GetPlayerInterior ( playerid ) ;

					rieltore_opened [ playerid ] = true ;

                    set_world ( playerid, 0 ) ;
                    set_interior ( playerid, 0 ) ;
					//set_pos ( playerid, h_info [ bizz_id ] [ h_pos ] [ 0 ], h_info [ bizz_id ] [ h_pos ] [ 1 ], h_info [ bizz_id ] [ h_pos ] [ 2 ]-50.0, 90.0, 0, 0);

                    toggle_controlable ( playerid, false ) ;
                    TogglePlayerSpectating ( playerid, true ) ;

                    SetPlayerCameraPos(playerid, h_info [ bizz_id ] [ h_pos ] [ 0 ] - 15, h_info [ bizz_id ] [ h_pos ] [ 1 ] + 27, h_info [ bizz_id ] [ h_pos ] [ 2 ] + 31);
					SetPlayerCameraLookAt(playerid, h_info [ bizz_id ] [ h_pos ] [ 0 ] - 14, h_info [ bizz_id ] [ h_pos ] [ 1 ] + 26, h_info [ bizz_id ] [ h_pos ] [ 2 ] + 30);
     				p_t_info [ playerid ] [ camera_timer ] = SetTimerEx ( "fixed_camera_pos", 500, 0, "iii", playerid, bizz_id, 2 ) ;

					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Для выхода из режима просмотра нажмите {"#cBL"}\"ПРОБЕЛ (/close)\"{"#cGRInfo"}.");
					DeletePVar ( playerid, "b_id_select" ) ;
				}
			}
		}
		case d_rieltore_house_finprice:
		{
		    if ( ! response ) return show_rieltore ( playerid ) ;

			global_string [ 0 ] = EOS ;
			new line_string [ 128 ], count_business = 0, insert_bizz = 0, bool:find_biz = false, row_count ;
			for ( new h = 0; h < house_count ; h ++ )
			{
			    if ( h_info [ h ] [ h_price ] * for_tax [ 0 ] != strval ( inputtext ) ) continue ;

				insert_bizz ++ ;

				if ( count_business > 10 ) continue ;
				
				set_player_listitem_values ( playerid, insert_bizz - 1, h ) ;

				format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
				strcat ( global_string, line_string ) ;
				
      			count_business ++ ;
				row_count ++ ;
		  		find_biz = true ;
			}
			if ( find_biz == false )
			{
		        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}По Вашему запросу о сортировке домов ничего не было найдено." ) ;
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
			}

			page_count [ playerid ] = 1 ;
			page_rows [ playerid ] = insert_bizz ;
			SetPVarInt ( playerid, "find_price", strval ( inputtext ) ) ;

			if ( page_count [ playerid ] > 1 )
			{
				strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 0 ) ;
				row_count ++ ;
			}
			if ( ofm_formula ( page_count [ playerid ] ) < insert_bizz )
			{
				strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 1 ) ;
			}
			
			show_dialog(playerid, d_rieltore_house_finprice_sct, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по стоимости", global_string, "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case d_rieltore_house_finprice_sct:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
		        DeletePVar ( playerid, "find_price" ) ;
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
			}

			if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка домов." ) ;

					show_house_rieltore_finprice ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

                show_house_rieltore_finprice ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка домов." ) ;

					show_house_rieltore_finprice ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] += 1 ;

                show_house_rieltore_finprice ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}Номер дома: {"#cBL"}%d", h_info [ select_id ] [ h_id ] ) ;

            show_dialog(playerid, d_rieltore_house_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию дома", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
            page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
            DeletePVar ( playerid, "find_price" ) ;
		}
		case d_rieltore_house_type:
		{
		    if ( ! response )
		    {
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
			}

			global_string [ 0 ] = EOS ;
			new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
			for ( new h = 0; h < house_count ; h ++ )
			{
			    if ( house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] != listitem ) continue ;

				if ( count_business < 10 ) set_player_listitem_values ( playerid, insert_bizz, h ) ;

				insert_bizz ++ ;

				if ( count_business > 10 ) continue ;

				format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
				strcat ( global_string, line_string ) ;
				
				count_business ++ ;
				row_count ++ ;
			}

			page_count [ playerid ] = 1 ;
			page_rows [ playerid ] = insert_bizz ;
			SetPVarInt ( playerid, "find_type", listitem ) ;

			if ( page_count [ playerid ] > 1 )
			{
				strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 0 ) ;
				row_count ++ ;
			}
			if ( ofm_formula ( page_count [ playerid ] ) < insert_bizz )
			{
				strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
				set_player_use_page ( playerid, row_count, 1 ) ;
			}
			
			show_dialog(playerid, d_rieltore_house_type_list, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по типу дома", global_string, "Выбрать", "Закрыть" ) ;
		}
		case d_rieltore_house_type_list:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
            	DeletePVar ( playerid, "find_type" ) ;
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
			}

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка домов." ) ;

					show_rieltore_house_type ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

                show_rieltore_house_type ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка домов." ) ;

					show_rieltore_house_type ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] += 1 ;

                show_rieltore_house_type ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}Номер дома: {"#cBL"}%d", h_info [ select_id ] [ h_id ] ) ;

            show_dialog(playerid, d_rieltore_house_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию дома", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
            page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
            DeletePVar ( playerid, "find_type" ) ;
		}
		case d_rieltore_house:
		{
		    if ( ! response ) return show_rieltore ( playerid ) ;
			switch ( listitem )
			{
			    case 0:
			    {
			        page_count [ playerid ] = 1 ;
					new rows_list = page_count [ playerid ] - 1 ;
					page_rows [ playerid ] = house_count ;

			        global_string [ 0 ] = EOS ;
					new line_string [ 128 ], row_count ;
					for ( new h = rows_list * 10 ; h < rows_list * 10 + 10 ; h ++ )
					{
						set_player_listitem_values ( playerid, h - rows_list * 10, h ) ;

						format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", h + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
						strcat ( global_string, line_string ) ;
						
						row_count ++ ;
					}
					
					if ( rows_list > 0 )
					{
						strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 0 ) ;
						row_count ++ ;
					}
					if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
					{
						strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 1 ) ;
					}
					
					show_dialog(playerid, d_rieltore_house_select, DIALOG_STYLE_LIST, "{"#cBHD"}Список всех домов", global_string, "Выбрать", "Закрыть" ) ;
			    }
			    case 1:
			    {
			        show_dialog ( playerid, d_rieltore_house_finprice, DIALOG_STYLE_INPUT, "{"#cBHD"}Сортировка по стоимости", "{"#cWH"}Введите желаему сумму стоимости, по которой будет поиск:", "Далее", "Назад" ) ;
			    }
                case 2:
			    {
			        global_string [ 0 ] = EOS ;
			        new line_string [ 128 ] ;
			        for ( new i = 0 ; i < max_class ; i ++ )
			        {
			            format ( line_string, sizeof ( line_string ), "{"#cBL"}%i.{"#cWH"} %s\n", i + 1, house_classes [ i ] ) ;
			            strcat ( global_string, line_string ) ;
			        }
			        show_dialog ( playerid, d_rieltore_house_type, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по типу дома", global_string, "Выбрать", "Закрыть" ) ;
			    }
			    case 3:
			    {
			        global_string [ 0 ] = EOS ;
					new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
					for ( new h = 0; h < house_count ; h ++ )
					{
					    if ( h_info [ h ] [ h_owner ] != -1 ) continue ;

						if ( count_business < 10 ) set_player_listitem_values ( playerid, insert_bizz, h ) ;

						insert_bizz ++ ;

						if ( count_business > 10 ) continue ;

						format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
						strcat ( global_string, line_string ) ;
						
				  		count_business ++ ;
						row_count ++ ;
					}
					if ( insert_bizz == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нет домов на продаже." ) ;

					page_count [ playerid ] = 1 ;
					page_rows [ playerid ] = insert_bizz ;

					if ( page_count [ playerid ] > 1 )
					{
						strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 0 ) ;
						row_count ++ ;
					}
					if ( ofm_formula ( page_count [ playerid ] ) < insert_bizz )
					{
						strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
						set_player_use_page ( playerid, row_count, 1 ) ;
					}
			
					show_dialog(playerid, d_rieltore_house_free, DIALOG_STYLE_LIST, "{"#cBHD"}Дома на продаже", global_string, "Выбрать", "Закрыть" ) ;
			    }
			    case 4:
			    {
			        global_string [ 0 ] = EOS ;
					new line_string [ 128 ], row_count ;
					for ( new h = 0 ; h < house_count ; h ++ )
					{
						if ( row_count >= 40 ) break ;
						if ( h_info [ h ] [ h_auction_status ] != 1 ) continue ;
						
						set_player_listitem_values ( playerid, row_count, h ) ;

						format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", h + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
						strcat ( global_string, line_string ) ;
						
						row_count ++ ;
					}
					
					if ( ! row_count ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нет недвижимости на аукционе." ) ;
					show_dialog(playerid, d_rieltore_house_auction, DIALOG_STYLE_LIST, "{"#cBHD"}Аукцион", global_string, "GPS", "Закрыть" ) ;
			    }
			}
		}
		case d_rieltore_house_auction:
		{
			if ( ! response ) return show_house_rieltore ( playerid ) ;
			
			new _id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;

			new s_house_id = _id ;
		    if ( h_info [ s_house_id ] [ h_podezd ] != -1 )
		    {
			   	new _padik_id = h_info [ s_house_id ] [ h_podezd ] ;
				SetPlayerRaceCheckpoint ( playerid, 1, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
			}
			else SetPlayerRaceCheckpoint ( playerid, 1, h_info [ s_house_id ] [ h_pos ] [ 0 ], h_info [ s_house_id ] [ h_pos ] [ 1 ], h_info [ s_house_id ] [ h_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Дом обозначен на карте красной меткой." ) ;
			is_gps_used { playerid } = 1 ;
			return 1 ;
		}
		case d_rieltore_house_free:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
		        show_house_rieltore ( playerid ) ;
		        return 1 ;
			}

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка домов." ) ;

					show_rieltore_house_free ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

                show_rieltore_house_free ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка домов." ) ;

					show_rieltore_house_free ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] += 1 ;

                show_rieltore_house_free ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}Номер дома: {"#cBL"}%d", h_info [ GetPVarInt ( playerid, "b_id_select" ) ] [ h_id ] ) ;

            show_dialog(playerid, d_rieltore_house_select_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Отметить на карте\n{"#cBL"}2.{"#cWH"} Посмотреть фотографию дома", "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
            page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
		}
		case d_sim_auction_list:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
				}
				show_sim_auction ( playerid ) ;
				return 1 ;
			}

			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
				    clear_player_listitem_values ( playerid ) ;
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					show_sim_auction ( playerid ) ;
					return 1 ;
				}
				else
				{
					mysql_tquery ( sql_connection, "SELECT * FROM `card_auction`", "card_callback", "i", playerid ) ;

					page_count [ playerid ] -= 1 ;
				}
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице аукциона SIM-карт." ) ;

					mysql_tquery ( sql_connection, "SELECT * FROM `card_auction`", "card_callback", "i", playerid ) ;

					page_count [ playerid ] = page_count [ playerid ] ;
					return 1 ;
				}
				mysql_tquery ( sql_connection, "SELECT * FROM `card_auction`", "card_callback", "i", playerid ) ;

				page_count [ playerid ] += 1 ;
				return 1 ;
			}

			if ( player_sim_auction [ playerid ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша SIM-карта находится на аукционе. Вы не сможете сделать ставку." ) ;

			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "b_id_select", select_id ) ;

			clear_player_listitem_values ( playerid ) ;
			page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;

			new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}Номер SIM-карты: {"#cBL"}%d", get_sim_number ( select_id ) ) ;

            show_dialog(playerid, d_sim_auction_info, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Повысить ставку\n{"#cBL"}2.{"#cWH"} Отменить ставку", "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case d_sim_auction_price:
		{
		    if ( ! response )
			{
			    DeletePVar ( playerid, "b_id_select" ) ;
				show_sim_auction ( playerid ) ;
				return 1 ;
			}

			new sim_id = GetPVarInt ( playerid, "b_id_select" ), _value = strval ( inputtext ) ;
		    if ( _value < 50000 )
			{
				new dialog_string [ 256 ] ;
				format ( dialog_string, sizeof dialog_string, "{"#cWH"}Вы собираетесь повысить ставку за SIM-карту, введите сумму, которую хотите поставить:\n\n{"#cGRDialog"}* Минимальная сумма шага должна быть от %d$.", 50000 ) ;
				show_dialog ( playerid, d_sim_auction_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Повышение ставки", dialog_string, "Далее", "Назад" ) ;
				return 1 ;
			}

		    if ( p_info [ playerid ] [ money ] < _value )
		    {
		        DeletePVar ( playerid, "auction_bet" ) ;
		        DeletePVar ( playerid, "b_id_select" ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств для ставки." ) ;
				show_sim_auction ( playerid ) ;
		        return 1 ;
		    }

			SetPVarInt ( playerid, "auction_bet", _value ) ;

			new query_string [ 59 + 9 ] ;
			mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `card_auction` WHERE `c_id` = '%d' LIMIT 1", sim_id ) ;
			mysql_tquery ( sql_connection, query_string, "cardbet_callback", "i", playerid ) ;
			return 1 ;
		}
		case d_sim_auction_info:
		{
		    if ( ! response )
			{
			    DeletePVar ( playerid, "b_id_select" ) ;
				show_sim_auction ( playerid ) ;
				return 1 ;
			}

			switch ( listitem )
			{
			    case 0:
			    {
			        if ( p_info [ playerid ] [ hour_played ] < 3 )
			        {
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре.");
						DeletePVar ( playerid, "b_id_select" ) ;
						show_sim_auction ( playerid ) ;
						return 1 ;
					}

			        if ( find_your_bet_sim ( playerid ) )
			        {
				        if ( find_your_bet_sim ( playerid ) != GetPVarInt ( playerid, "b_id_select" ) )
						{
							SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже делали ставку на одну из SIM-карт на аукционе." ) ;
							DeletePVar ( playerid, "b_id_select" ) ;
							show_sim_auction ( playerid ) ;
							return 1 ;
						}
					}
					new dialog_string [ 256 ] ;
					format ( dialog_string, sizeof dialog_string, "{"#cWH"}Вы собираетесь повысить ставку за SIM-карту, введите сумму, которую хотите поставить:\n\n{"#cGRDialog"}* Минимальная сумма шага должна быть от %d$.", 50000 ) ;
					show_dialog ( playerid, d_sim_auction_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Повышение ставки", dialog_string, "Далее", "Назад" ) ;
					return 1 ;
			    }
			    case 1:
			    {
			        new bizz_id = GetPVarInt ( playerid, "b_id_select" ) ;
			        DeletePVar ( playerid, "b_id_select" ) ;

					static query_string [ ] = "SELECT `c_bet` FROM `card_bet` WHERE `c_account` = '%d' LIMIT 1";
					new fmt_query [ sizeof query_string + 9 ] ;
					format ( fmt_query, sizeof ( fmt_query ), query_string, p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, fmt_query, "find_your_bet", "iii", playerid, bizz_id, 3 ) ;
			    }
			}
		}
		case d_sim_auction:
		{
		    if ( ! response ) return 1 ;

			switch ( listitem )
			{
			    case 0:
			    {
			        if ( p_info [ playerid ] [ number ] < 1 )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет SIM-карты." ) ;
						show_sim_auction ( playerid ) ;
						return 1 ;
					}

					for ( new i = 0 ; i < card_count ; i ++ )
					{
					    if ( card_info [ i ] [ card_number ] == p_info [ playerid ] [ number ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша SIM-карта уже выставлена на продажу." ), show_sim_auction ( playerid ) ;
					}

					if ( player_sim_auction [ playerid ] == true )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша SIM-карта уже выставлена на аукцион." ) ;
						show_sim_auction ( playerid ) ;
						return 1 ;
					}
					
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "{"#cWH"}Ваша SIM-карта будет выставлена на аукционе.\n\n\
																	{"#cGRDialog"}* Длительность торгов: {"#cGN"}2 дня\n\
																	{"#cGRDialog"}* Стоимость размещения: {"#cGN"}%d$\n\n\
																	{"#cGRDialog"}* Если по итогам ставка будет менее нужной,\n\
																	{"#cGRDialog"}* аукцион продлится до тех пор,\n\
																	{"#cGRDialog"}* пока ставка не появится.\n\n\
																	{"#cGRDialog"}* Вы уверены, что хотите выставить SIM-карту на аукцион?", b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 1 ] ) ;

					show_dialog ( playerid, d_sim_auction_activated, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Аукцион", global_string, "Далее", "Назад" ) ;
			    }
			    case 1:
			    {
			        page_count [ playerid ] = 1 ;
			        mysql_tquery ( sql_connection, "SELECT * FROM `card_auction`", "card_callback", "i", playerid ) ;
				}
				case 2:
				{
				    if ( player_sim_auction [ playerid ] == false )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет SIM-карты выставленной на аукцион." ) ;
						show_sim_auction ( playerid ) ;
						return 1 ;
					}

					SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вы успешно сняли свою SIM-карту с аукциона." ) ;

					new scm_string [ 128 ] ;
					format ( scm_string, sizeof scm_string, "SELECT * FROM `card_bet` WHERE `c_id` = '%d'", p_info [ playerid ] [ number ] ) ;
					mysql_tquery ( sql_connection, scm_string, "card_outback", "i", p_info [ playerid ] [ number ] ) ;

					format ( scm_string, sizeof scm_string, "DELETE FROM `card_auction` WHERE `c_id` = '%d' LIMIT 1", p_info [ playerid ] [ number ] ) ;
					mysql_tquery ( sql_connection, scm_string ) ;

					show_sim_auction ( playerid ) ;
					
					player_sim_auction [ playerid ] = false ;
					update_int_sql ( playerid, "u_sim_auction", 0 ) ;
				}
			}
		}
		case d_sim_auction_activated:
		{
		    if ( ! response ) return show_sim_auction ( playerid ) ;
			
			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			if ( b_info [ _b_id - 1 ] [ b_product ] < b_other_product [ 1 ] )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В бизнесе недостаточно бланков для подписания договора аукциона." ) ;
				show_sim_auction ( playerid ) ;
				return 1 ;
			}

			SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы успешно выставили свою SIM-карту на аукцион." ) ;
			
			new _price = b_price_market [ _b_id - 1 ] [ 1 ] ;
			give_money ( playerid, -_price ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "аукцион (SIM)" ) ;
			
			give_bmoney ( _b_id, _price, b_other_product [ 1 ] ) ;

			new _sql_string [ 228 ] ;
			format ( _sql_string, sizeof _sql_string, "INSERT INTO `card_auction` (`c_date`,`c_id`,`c_account`,`c_result`) VALUES (NOW() + INTERVAL 2 DAY, '%d', '%d', NOW() + INTERVAL 3 DAY)",
			p_info [ playerid ] [ number ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;

		    show_sim_auction ( playerid ) ;
			
			player_sim_auction [ playerid ] = true ;
			update_int_sql ( playerid, "u_sim_auction", 1 ) ;
			return 1 ;
		}
	}
	return 1 ;
}

callback: card_callback ( playerid )
{
    new rows, Fields ;
    cache_get_data ( rows, Fields ) ;
    if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На аукционе нет SIM-карт." ) ;
		show_sim_auction ( playerid ) ;
		return 1 ;
	}

	page_rows [ playerid ] = rows ;
    new rows_list = page_count [ playerid ] - 1 ;
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
	    if ( i >= rows ) break ;

	    new bh_business, bh_bet, h_date [ 32 ] ;
	    bh_business = cache_get_field_content_int ( i, "c_id", sql_connection ) ;
	    bh_bet = cache_get_field_content_int ( i, "c_bet", sql_connection ) ;
		cache_get_field_content ( i, "c_result", h_date, sql_connection, 32 ) ;

		set_player_listitem_values ( playerid, i - rows_list * 10, bh_business ) ;

		format ( line_string, sizeof ( line_string ), "{"#cWH"}%i. %d - {"#cGN"}%d$ {"#cGRDialog"}(Окончание: {"#cWH"}%s в 21:00{"#cGRDialog"})\n", i + 1, bh_business, bh_bet, h_date ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_sim_auction_list, DIALOG_STYLE_LIST, "{"#cBHD"}Список SIM-карт на аукционе", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

callback: cardbet_callback ( playerid )
{
    new Rows, Fields;
    cache_get_data(Rows, Fields);
    if ( ! Rows )
    {
        DeletePVar ( playerid, "auction_bet" ) ;
        DeletePVar ( playerid, "b_id_select" ) ;
        return 1 ;
    }

    new bh_business, bh_bet ;
    bh_business = cache_get_field_content_int ( 0, "c_id", sql_connection ) ;
    bh_bet = cache_get_field_content_int ( 0, "c_bet", sql_connection ) ;

    if ( bh_bet >= GetPVarInt ( playerid, "auction_bet" ) )
    {
        DeletePVar ( playerid, "auction_bet" ) ;
        DeletePVar ( playerid, "b_id_select" ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша ставка должна быть больше предыдущей." ) ;
		show_sim_auction ( playerid ) ;
        return 1 ;
    }

    bh_bet = GetPVarInt ( playerid, "auction_bet" ) ;

    new query_string [ 128 ] ;
	format ( query_string, sizeof query_string, "SELECT * FROM `card_bet` WHERE `c_account` = '%d' LIMIT 1", p_info [ playerid ] [ id ] );
	new Cache:result = mysql_query(sql_connection, query_string);
	new rows = cache_get_row_count(sql_connection);
	if ( rows )
	{
		new scm_string [ 128 ] ;
		format ( scm_string, sizeof scm_string, "UPDATE `card_bet` SET `c_bet` = `c_bet`+'%d' WHERE `c_account` = '%d' LIMIT 1", bh_bet, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, scm_string, "", "" ) ;
	}
	else
	{
	    new scm_string [ 128 ] ;
	    format ( scm_string, sizeof scm_string, "INSERT INTO `card_bet` (`c_id`,`c_bet`,`c_account`,`c_name`) VALUES ('%d','%d','%d','%s')", bh_business, bh_bet, p_info [ playerid ] [ id ], p_info [ playerid ] [ name ] ) ;
		mysql_tquery ( sql_connection, scm_string ) ;
	}
 	cache_delete(result, sql_connection);

    give_money ( playerid, -bh_bet ) ;
	insert_money_log ( playerid, INVALID_PLAYER_ID, -bh_bet, "ставка за SIM-карту" ) ;
	
    new _sql_string [ 146 ] ;
	format ( _sql_string, 146, "UPDATE `card_auction` SET `c_bet` = '%d', `c_account_bet` = '%d' WHERE `c_id` = '%d' LIMIT 1",
	bh_bet, p_info [ playerid ] [ id ], bh_business ) ;
	mysql_tquery ( sql_connection, _sql_string, "", "" ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно установили новую ставку." ) ;
	show_sim_auction ( playerid ) ;
	
    DeletePVar ( playerid, "auction_bet" ) ;
    DeletePVar ( playerid, "b_id_select" ) ;
	return 1 ;
}

callback: carditog_callback ( )
{
    new Rows, Fields;
    cache_get_data(Rows, Fields);
    new bh_business [ 100 ], bh_account [ 100 ], bh_account_bet [ 100 ], bh_bet [ 100 ] ;
    for ( new i = 0 ; i < Rows ; i ++ )
    {
        if ( i >= 100 ) break ;
    	bh_business [ i ] = cache_get_field_content_int ( i, "c_id", sql_connection ) ;
    	bh_account [ i ] = cache_get_field_content_int ( i, "c_account", sql_connection ) ;
    	bh_account_bet [ i ] = cache_get_field_content_int ( i, "c_account_bet", sql_connection ) ;
    	bh_bet [ i ] = cache_get_field_content_int ( i, "c_bet", sql_connection ) ;
    }
    for ( new i = 0 ; i < Rows ; i ++ )
    {
		if ( i >= 100 ) break ;
		if ( bh_bet [ i ] == 0 ) continue ;

        new _sql_string [ 256 ] ;

		format ( _sql_string, 146, "DELETE FROM `card_bet` WHERE `c_account` = '%d'", bh_account_bet [ i ] ) ;
		mysql_tquery ( sql_connection, _sql_string, "", "" ) ;

		format ( _sql_string, 146, "DELETE FROM `card_auction` WHERE `c_id` = '%d' LIMIT 1", bh_business [ i ] ) ;
		mysql_tquery ( sql_connection, _sql_string, "", "" ) ;
		
		format ( _sql_string, 146, "SELECT `u_name`, `u_id` FROM `users` WHERE `u_id` = '%d' LIMIT 1", bh_account [ i ] ) ;
		mysql_tquery ( sql_connection, _sql_string, "cardplayer_owner_auction", "ii", bh_business [ i ], bh_bet [ i ] ) ;
		
		format ( _sql_string, 146, "SELECT `u_name`, `u_id` FROM `users` WHERE `u_id` = '%d' LIMIT 1", bh_account_bet [ i ] ) ;
		mysql_tquery ( sql_connection, _sql_string, "cardplayer_callback", "i", bh_business [ i ] ) ;
    }
    return 1 ;
}

callback: cardplayer_owner_auction ( bh_business, bh_bet )
{
    new Rows, Fields;
    cache_get_data(Rows, Fields);

    if ( Rows )
    {
        new u_name [ MAX_PLAYER_NAME ] ;
		cache_get_field_content ( 0, "u_name", u_name, sql_connection, MAX_PLAYER_NAME ) ;
		new u_id = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;

        new _pl_id, query_string [ 200 + MAX_PLAYER_NAME + 1 ] ;
		sscanf ( u_name, "u", _pl_id ) ;
		if ( IsPlayerConnected ( _pl_id ) )
		{
		    give_money ( _pl_id, bh_bet ) ;
		    insert_money_log ( _pl_id, INVALID_PLAYER_ID, bh_bet, "аукцион SIM-карт" ) ;
		    
			p_info [ _pl_id ] [ number ] = 0 ;
			update_int_sql ( _pl_id, "u_number", 0 ) ;
		}
		else
		{
			format ( query_string, sizeof query_string, "{"#cGInfo"}* {"#cWH"}Аукцион закончился. Ваша SIM-карта была успешно продана за %d$!\n{"#cGInfo"}* {"#cWH"}Деньги у Вас на руках.", bh_bet ) ;
			insert_debtor_message ( "Аукцион", query_string, u_id ) ;

			format ( query_string, 146, "UPDATE `users` SET `u_number` = '0' WHERE `u_id` = '%d' LIMIT 1", u_id ) ;
			mysql_tquery ( sql_connection, query_string, "", "" ) ;
			
			insert_return_money ( "Аукцион (продажа SIM)", bh_bet, RETURN_TYPE_MONEY, u_id ) ;
		}
	}
	return 1 ;
}

callback: cardplayer_callback ( bh_business )
{
    new Rows, Fields ;
    cache_get_data ( Rows, Fields ) ;

    if ( Rows )
    {
        new u_name [ MAX_PLAYER_NAME ] ;
		cache_get_field_content ( 0, "u_name", u_name, sql_connection, MAX_PLAYER_NAME ) ;
		new u_id = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;

        new _pl_id, query_string [ 200 + MAX_PLAYER_NAME + 1 ] ;
		sscanf ( u_name, "u", _pl_id ) ;
		if ( IsPlayerConnected ( _pl_id ) )
		{
		    p_info [ _pl_id ] [ number ] = bh_business ;
		}
		else
		{
			format ( query_string, sizeof query_string, "{"#cGInfo"}* {"#cWH"}Аукцион закончился. Вы в нем одержали победу. SIM-карта Ваша, поздравляем!" ) ;
			insert_debtor_message ( "Аукцион", query_string, u_id ) ;
		}
		
		format ( query_string, 146, "UPDATE `users` SET `u_number` = '%d' WHERE `u_id` = '%d'", bh_business, u_id ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	new _sql_string [ 100 ] ;
	format ( _sql_string, 100, "SELECT * FROM `card_bet` WHERE `c_id` = '%d'", bh_business ) ;
	mysql_tquery ( sql_connection, _sql_string, "cardplayer_auction", "i", bh_business ) ;
	return 1 ;
}

callback: cardplayer_auction ( bh_business )
{
    new Rows, Fields ;
    cache_get_data ( Rows, Fields ) ;
    if ( Rows )
    {
	    for ( new i = 0 ; i < Rows ; i ++ )
	    {
	        new u_id, u_bet, u_name [ MAX_PLAYER_NAME ] ;
    		u_id = cache_get_field_content_int ( i, "c_account", sql_connection ) ;
    		u_bet = cache_get_field_content_int ( i, "c_bet", sql_connection ) ;
			cache_get_field_content ( i, "c_name", u_name, sql_connection, MAX_PLAYER_NAME ) ;

			new _pl_id ;
			sscanf ( u_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
	  			SendClientMessage ( _pl_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}SIM-карту, в торгах которой Вы учавствовали, сняли с аукциона." ) ;
	  			SendClientMessage ( _pl_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Деньги, которые Вы поставили, возвращены на руки." ) ;

	     		give_money ( _pl_id, u_bet ) ;
				insert_money_log ( _pl_id, INVALID_PLAYER_ID, u_bet, "возврат ставки" ) ;
	    	}
	    	else
	    	{
				insert_debtor_message ( "Аукцион", "{"#cRInfo"}* {"#cGRInfo"}Аукцион закончился. К сожалению, Вы не смогли одержать победу. Деньги возвращены.", u_id ) ;
				insert_return_money ( "Аукцион (возврат)", u_bet, RETURN_TYPE_MONEY, u_id ) ;
	    	}
	    }
	}
	new _sql_string [ 100 ] ;
	format ( _sql_string, 100, "DELETE FROM `card_bet` WHERE `c_id` = '%d'", bh_business ) ;
	mysql_tquery ( sql_connection, _sql_string, "", "" ) ;
	return 1 ;
}

callback: card_outback ( bizz_id )
{
    new Rows, Fields ;
    cache_get_data ( Rows, Fields ) ;
    if ( ! Rows ) return 1 ;

	for ( new i ; i < Rows ; i ++ )
	{
	    new u_id, u_bet, u_name [ MAX_PLAYER_NAME ] ;
    	u_id = cache_get_field_content_int ( i, "c_account", sql_connection ) ;
    	u_bet = cache_get_field_content_int ( i, "c_bet", sql_connection ) ;
		cache_get_field_content ( i, "c_name", u_name, sql_connection, MAX_PLAYER_NAME ) ;

    	new _pl_id ;
		sscanf ( u_name, "u", _pl_id ) ;
		if ( IsPlayerConnected ( _pl_id ) )
		{
  			SendClientMessage ( _pl_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}SIM-карту, в торгах которой Вы учавствовали, сняли с аукциона." ) ;
  			SendClientMessage ( _pl_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Деньги, которые Вы поставили, возвращены на руки." ) ;

     		give_money ( _pl_id, u_bet ) ;
			insert_money_log ( _pl_id, INVALID_PLAYER_ID, u_bet, "возврат ставки" ) ;
    	}
    	else
    	{
			insert_debtor_message ( "Аукцион", "{"#cRInfo"}* {"#cGRInfo"}Аукцион закончился. Владелец снял лот. Деньги возвращены.", u_id ) ;
			insert_return_money ( "Аукцион (отмена SIM)", u_bet, RETURN_TYPE_MONEY, u_id ) ;
    	}
	}
	new _sql_string [ 100 ] ;
	format ( _sql_string, 100, "DELETE FROM `card_bet` WHERE `c_id` = '%d'", bizz_id ) ;
	mysql_tquery ( sql_connection, _sql_string ) ;
	return 1 ;
}

stock show_house_rieltore ( playerid )
{
    show_dialog(playerid, d_rieltore_house, DIALOG_STYLE_LIST, "{"#cBHD"}Дома", "{"#cBL"}1.{"#cWH"} Список всех домов\n{"#cBL"}2.{"#cWH"} Сортировка по стоимости\n{"#cBL"}3.{"#cWH"} Сортировка по классу\n{"#cBL"}4.{"#cWH"} Дома на продаже\n{"#cBL"}5.{"#cWH"} Аукцион", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_biz_rieltore ( playerid )
{
    show_dialog(playerid, d_rieltore_biz, DIALOG_STYLE_LIST, "{"#cBHD"}Бизнесы", "{"#cBL"}1.{"#cWH"} Список всех бизнесов\n{"#cBL"}2.{"#cWH"} Сортировка по стоимости\n{"#cBL"}3.{"#cWH"} Сортировка по типу бизнеса\n{"#cBL"}4.{"#cWH"} Бизнесы на продаже\n{"#cBL"}5.{"#cWH"} Аукцион", "Выбрать", "Закрыть" ) ;
    return 1 ;
}

stock show_rieltore ( playerid )
{
    show_dialog ( playerid, d_rieltore, DIALOG_STYLE_LIST, "{"#cBHD"}Риелторское агенство", "{"#cBL"}1. {"#cWH"}Бизнесы\n{"#cBL"}2. {"#cWH"}Дома", "Выбрать", "Отмена" ) ;
	return 1 ;
}

stock show_rieltore_biz_select ( playerid )
{
    new rows_list = page_count [ playerid ] - 1 ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
	for ( new b = rows_list * 10 ; b < rows_list * 10 + 10 ; b ++ )
	{
	    if ( b >= page_rows [ playerid ] ) break ;
	    if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;
	
 		set_player_listitem_values ( playerid, b - rows_list * 10, b ) ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", b + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_biz_select, DIALOG_STYLE_LIST, "{"#cBHD"}Список всех бизнесов", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_rieltore_biz_finprice ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
	for ( new b = 0; b < b_count ; b ++ )
	{
	    if ( b_info [ b ] [ b_price ] * for_tax [ 1 ] != GetPVarInt ( playerid, "find_price" ) ) continue ;
	    if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

		if ( count_business > page_count [ playerid ] * 10 ) break ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		
		set_player_listitem_values ( playerid, insert_bizz, b ) ;

		insert_bizz ++ ;
		
		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
 	 	count_business ++ ;
		row_count ++ ;
	}
	
	if ( page_count [ playerid ] > 1 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_biz_finprice_select, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по стоимости", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_rieltore_biz_type ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
	for ( new b = 0; b < b_count ; b ++ )
	{
 		if ( b_info [ b ] [ b_type ] != GetPVarInt ( playerid, "find_type" ) ) continue ;
 		if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

		if ( count_business > page_count [ playerid ] * 10 ) break ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		
		set_player_listitem_values ( playerid, insert_bizz, b ) ;

		insert_bizz ++ ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		count_business ++ ;
		row_count ++ ;
	}
	
	if ( page_count [ playerid ] > 1 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_biz_type_list, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по типу бизнеса", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_rieltore_biz_fee ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
	for ( new b = 0; b < b_count ; b ++ )
	{
	    if ( b_info [ b ] [ b_owner_inc ] != -1 ) continue ;
		if ( b_info [ b ] [ b_type ] == bizz_type_drugsfarm || b_info [ b ] [ b_type ] == bizz_type_gunfactory ) continue ;

		if ( count_business > page_count [ playerid ] * 10 ) break ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		
		set_player_listitem_values ( playerid, insert_bizz, b ) ;

		insert_bizz ++ ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		count_business ++ ;
		row_count ++ ;
	}
	
	if ( page_count [ playerid ] > 1 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_biz_free, DIALOG_STYLE_LIST, "{"#cBHD"}Бизнесы на продаже", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_house_rieltore_select ( playerid )
{
    new rows_list = page_count [ playerid ] - 1 ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
	for ( new h = rows_list * 10 ; h < rows_list * 10 + 10 ; h ++ )
	{
  		if ( h >= page_rows [ playerid ] ) break ;

		set_player_listitem_values ( playerid, h - rows_list * 10, h ) ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", h + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_house_select, DIALOG_STYLE_LIST, "{"#cBHD"}Список всех домов", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_house_rieltore_finprice ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
	for ( new h = 0; h < house_count ; h ++ )
	{
	    if ( h_info [ h ] [ h_price ] * for_tax [ 0 ] != GetPVarInt ( playerid, "find_price" ) ) continue ;

		if ( count_business > page_count [ playerid ] * 10 ) break ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		
		set_player_listitem_values ( playerid, insert_bizz, h ) ;

		insert_bizz ++ ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
 	 	count_business ++ ;
		row_count ++ ;
	}
	
	if ( page_count [ playerid ] > 1 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_house_finprice_sct, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по стоимости", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_rieltore_house_type ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
	for ( new h = 0; h < house_count ; h ++ )
	{
	    if ( house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] != GetPVarInt ( playerid, "find_type" ) ) continue ;

		if ( count_business > page_count [ playerid ] * 10 ) break ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		
		set_player_listitem_values ( playerid, insert_bizz, h ) ;

		insert_bizz ++ ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		count_business ++ ;
		row_count ++ ;
	}
	
	if ( page_count [ playerid ] > 1 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_rieltore_house_type_list, DIALOG_STYLE_LIST, "{"#cBHD"}Сортировка по типу дома", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_rieltore_house_free ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, insert_bizz = 0, row_count ;
	for ( new h = 0; h < house_count ; h ++ )
	{
 		if ( h_info [ h ] [ h_owner ] != -1 ) continue ;

		if ( count_business > page_count [ playerid ] * 10 ) break ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		
		set_player_listitem_values ( playerid, insert_bizz, h ) ;

		insert_bizz ++ ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}%s - %s\n", count_business + 1, house_classes [ house_int [ h_info [ h ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ h ] [ h_owner_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		count_business ++ ;
		row_count ++ ;
	}
	
	if ( page_count [ playerid ] > 1 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog ( playerid, d_rieltore_house_free, DIALOG_STYLE_LIST, "{"#cBHD"}Дома на продаже", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_sim_auction ( playerid )
{
    show_dialog ( playerid, d_sim_auction, DIALOG_STYLE_LIST, "{"#cBHD"}Аукцион", "{"#cBL"}1.{"#cWH"} Выставить SIM-карту на аукцион\n{"#cBL"}2.{"#cWH"} Список SIM-карт на аукционе\n{"#cBL"}3.{"#cWH"} Снять SIM-карту с аукциона", "Выбрать", "Закрыть" ) ;
	return 1 ;
}