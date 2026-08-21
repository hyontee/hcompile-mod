#if 0
new bool: rieltore_opened [ MAX_PLAYERS ] ;

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
	}
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
#endif
