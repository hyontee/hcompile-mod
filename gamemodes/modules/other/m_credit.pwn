#define max_credit_notpledge 300000
#define max_credit_notpledge_text "300000"

stock clear_player_credit ( playerid )
{
	p_t_info [ playerid ] [ creditor_id ] =
	p_t_info [ playerid ] [ credit_card ] = -1 ;
	
	p_t_info [ playerid ] [ credit_sum ] =
	p_t_info [ playerid ] [ credit_day ] =
	p_t_info [ playerid ] [ credit_pledge ] =
	p_t_info [ playerid ] [ credit_pledge_type ] = 0 ;
	return 1 ;
}

stock credit_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_give_credit:
		{
		    if ( ! response )
			{
		        clear_player_credit ( playerid ) ;
			    return 1 ;
			}
			switch ( listitem )
			{
			    case 0: show_give_credit ( playerid ) ;
				case 1: select_credit_card ( playerid ) ;
				case 2: show_dialog ( playerid, d_give_credit_sum, DIALOG_STYLE_INPUT, "{"#cBHD"}Подача заявки на кредит", "{"#cWH"}Если Вы берёте сумму менее {"#cLY"}"max_credit_notpledge_text"{"#cWH"}, то Вы можете не указывать залог.\n\
																																		{"#cWH"}Для большего шанса одобрения кредита необходимо указывать залог.\n\n\
																																		{"#cGRDialog"}* Укажите сумму кредита, которую хотите взять:", "Принять", "Назад" ) ;
				case 3: show_give_credit ( playerid ) ;
				case 4: show_dialog ( playerid, d_give_credit_day, DIALOG_STYLE_INPUT, "{"#cBHD"}Подача заявки на кредит", "{"#cWH"}Укажите количество дней, на которые будет выдан кредит:", "Принять", "Назад" ) ;
				case 5:
				{
					if ( p_t_info [ playerid ] [ credit_sum ] <= max_credit_notpledge )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы указали сумму, для которой не обязателен залог." ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Если Вы укажите недвижимость в залоге, то шанс выдачи может увеличиться." ) ;
					}
					select_credit_property ( playerid ) ;
				}
				case 6:
				{
				    if ( p_t_info [ playerid ] [ credit_card ] != -1 && p_t_info [ playerid ] [ credit_day ] > 0 && 
					( p_t_info [ playerid ] [ credit_sum ] > 0 && p_t_info [ playerid ] [ credit_sum ] < max_credit_notpledge || p_t_info [ playerid ] [ credit_sum ] > max_credit_notpledge && p_t_info [ playerid ] [ credit_pledge ] > 0 ) )
					{
					
					    new dialog_string [ 456 ] ;

					    new _pledge_str [ 64 ] ;
						switch ( p_t_info [ playerid ] [ credit_pledge_type ] )
						{
							case 0: format ( _pledge_str, sizeof _pledge_str, "{"#cRD"}Не выбран" ) ;
							case 1: format ( _pledge_str, sizeof _pledge_str, "Дом {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ]  ) ;
							case 2: format ( _pledge_str, sizeof _pledge_str, "Бизнес {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
							case 3: format ( _pledge_str, sizeof _pledge_str, "Гараж {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
						}

						new _credit_pay = floatround ( ( p_t_info [ playerid ] [ credit_sum ] * b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 1 ] ) / 100 ) ;
						p_t_info [ playerid ] [ credit_pay ] = p_t_info [ playerid ] [ credit_sum ] + _credit_pay ;
						
						format ( dialog_string, sizeof dialog_string, "{"#cWH"}Кредит от %s.\n\n\
																		{"#cBInfo"}* {"#cWH"}Сумма кредита: {"#cGN"}%d$\n\
																		{"#cBInfo"}* {"#cWH"}Процент: {"#cGN"}%d%%\n\
																		{"#cBInfo"}* {"#cWH"}Переплата: {"#cGN"}%d$\n\
																		{"#cBInfo"}* {"#cWH"}Срок: {"#cGN"}%d {"#cWH"}дн.\n\
																		{"#cBInfo"}* {"#cWH"}Залог: %s\n\n\
																		{"#cWH"}В случае, если Вы вовремя не погасите кредит, Ваш залог\n\
																		перейдёт во владения кредитора.\n\n\
																		{"#cGRDialog"}* Вы согласны подать заявку на таких условиях?", b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_name ],
																		p_t_info [ playerid ] [ credit_sum ], b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 1 ], _credit_pay,
																		p_t_info [ playerid ] [ credit_day ], _pledge_str ) ;
					    show_dialog ( playerid, d_give_credit_select, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кредитование", dialog_string, "Да", "Нет" ) ;
					}
					else SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы указали не все аспекты кредитования." ), show_give_credit ( playerid ) ;
				}
			}
			return 1 ;
		}
		case d_give_credit_select:
		{
		    if ( ! response )
		    {
		        clear_player_credit ( playerid ) ;
		        return 1 ;
		    }
		    
		    enter_credit_card ( playerid ) ;
		    return 1 ;
		}
		case d_enter_credit_card:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				
		        clear_player_credit ( playerid ) ;
				return 1 ;
			}
			new deposit_id = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;
			if ( bank_info [ playerid ] [ bi_credit ] [ deposit_id ] )
			{
			    clear_player_credit ( playerid ) ;
		        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас уже есть кредит на выбранной карте." ) ;
				return 1 ;
			}
		    
			new dialog_string [ 512 ] ;
			format ( dialog_string, sizeof ( dialog_string ), "INSERT INTO `businesses_credit` (`db_owner`,`db_owner_name`,`db_credit`,`db_pledge`,`db_pledge_type`,`db_credit_day`,`db_active_card`,`db_credit_card`,`db_creditor`,`db_date`) VALUES ('%d','%s','%d','%d','%d','%d','%d','%d','%d',NOW())",
			p_info [ playerid ] [ id ], p_info [ playerid ] [ name ],
			p_t_info [ playerid ] [ credit_sum ], p_t_info [ playerid ] [ credit_pledge ], p_t_info [ playerid ] [ credit_pledge_type ],
			p_t_info [ playerid ] [ credit_day ], bank_info [ playerid ] [ bi_id ] [ p_t_info [ playerid ] [ credit_card ] ], 
			bank_info [ playerid ] [ bi_id ] [ deposit_id ], b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_id ] ) ;
			mysql_tquery ( sql_connection, dialog_string, "", "" ) ;
			
			clear_player_credit ( playerid ) ;
			
			SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Заявка успешно подана. Вам необходимо ожидать решения." ) ;
			SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Кредит может быть одобрен даже, когда Вы не в игре. Деньги переведутся Вам на счёт." ) ;
			SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Кредит одобрить может только владелец Банка. (При входе указан ник)" ) ;
		    return 1 ;
		}
		case d_credit_property_house:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
				DeletePVar ( playerid, "debt_house" ) ;
				DeletePVar ( playerid, "debt_business" ) ;
				DeletePVar ( playerid, "debt_garage" ) ;
				
				show_give_credit ( playerid ) ;
		        return 1 ;
		    }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "debt_house", select_id ) ;

   			clear_player_listitem_values ( playerid ) ;

			new s_house_id = GetPVarInt ( playerid, "debt_house" ) ;
			if ( s_house_id < 1 )
			{
				SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома." ) ;
				show_give_credit ( playerid ) ;
				return 1 ;
			}
			else
			{
			    if ( h_info [ s_house_id - 1 ] [ h_auction_status ] == 1 )
				{
					SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Дом выставлен на аукционе." ) ;
					show_give_credit ( playerid ) ;
				    return 1 ;
				}

				if ( h_info [ s_house_id - 1 ] [ h_sell_status ] )
				{
					SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Имущество уже подготавливается к опечатке." ) ;
                    show_give_credit ( playerid ) ;
				    return 1 ;
				}

                p_t_info [ playerid ] [ credit_pledge ] = h_info [ s_house_id - 1 ] [ h_id ] ;
		       	p_t_info [ playerid ] [ credit_pledge_type ] = 1 ;
		       	show_give_credit ( playerid ) ;
			}
		    return 1 ;
		}
		case d_credit_property_bizz:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
				DeletePVar ( playerid, "debt_house" ) ;
				DeletePVar ( playerid, "debt_business" ) ;
				DeletePVar ( playerid, "debt_garage" ) ;
				
				show_give_credit ( playerid ) ;
		        return 1 ;
		    }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "debt_business", select_id ) ;

			clear_player_listitem_values ( playerid ) ;

			new business_id = GetPVarInt ( playerid, "debt_business" ) - 1 ;
			if (business_id < 0 )
			{
				SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}У Вас нет бизнеса." ) ;
				show_give_credit ( playerid ) ;
				return 1 ;
			}
			else
			{
			    if ( b_info [ business_id ] [ b_auction_status ] == 1 )
				{
					SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Бизнес выставлен на аукционе." ) ;
					show_give_credit ( playerid ) ;
				    return 1 ;
				}

                if ( b_info [ business_id ] [ b_sell_status ] )
				{
					SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Имущество уже подготавливается к опечатке." ) ;
                    show_give_credit ( playerid ) ;
				    return 1 ;
				}

                p_t_info [ playerid ] [ credit_pledge ] = b_info [ business_id ] [ b_id ] ;
		       	p_t_info [ playerid ] [ credit_pledge_type ] = 2 ;
		       	show_give_credit ( playerid ) ;
			}
		    return 1 ;
		}
		case d_credit_property:
		{
			if ( ! response )
			{
				show_give_credit ( playerid ) ;

				DeletePVar ( playerid, "debt_house" ) ;
				DeletePVar ( playerid, "debt_business" ) ;
				DeletePVar ( playerid, "debt_garage" ) ;
				return 1 ;
			}
			if ( listitem == 0 )
			{
				new line_string [ 128 ], _count_house = 0 ;
				global_string [ 0 ] = EOS ;
			    foreach(new _h_id: player_houses[playerid])
			    {
					set_player_listitem_values ( playerid, _count_house, _h_id ) ;
					
					_count_house ++ ;

				    format ( line_string, sizeof line_string, "{"#cWH"}%s {"#cGRDialog"}(№%d){"#cWH"} - {"#cGN"}%d${"#cWH"}\n", house_classes [ house_int [ h_info [ _h_id - 1 ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ _h_id - 1 ] [ h_id ], h_info [ _h_id - 1 ] [ h_price ] ) ;
					strcat ( global_string, line_string ) ;
				}
				show_dialog ( playerid, d_credit_property_house, DIALOG_STYLE_LIST, "{"#cBHD"}Залог", global_string, "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				new line_string [ 128 ], _count_bizz = 0 ;
				global_string [ 0 ] = EOS ;
			    foreach(new _b_id: player_business[playerid])
				{
					set_player_listitem_values ( playerid, _count_bizz, _b_id ) ;

                    _count_bizz ++ ;

				    format ( line_string, sizeof line_string, "{"#cWH"}%s {"#cGRDialog"}(№%d){"#cWH"} - {"#cGN"}%d${"#cWH"}\n", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_id ], b_info [ _b_id - 1 ] [ b_price ] ) ;
					strcat ( global_string, line_string ) ;
				}
				show_dialog ( playerid, d_credit_property_bizz, DIALOG_STYLE_LIST, "{"#cBHD"}Залог", global_string, "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 2 )
			{
				new s_house_id = GetPVarInt ( playerid, "debt_garage" ) ;
				if ( s_house_id == - 1 )
				{
					SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}У игрока нет гаража." ) ;
					show_give_credit ( playerid ) ;
					return 1 ;
				}
				else
				{
				    if ( cellar_info [ s_house_id - 1 ] [ cl_sell_status ] )
					{
						SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Имущество уже подготавливается к опечатке." ) ;
						show_give_credit ( playerid ) ;
					    return 1 ;
					}

                    p_t_info [ playerid ] [ credit_pledge ] = cellar_info [ s_house_id - 1 ] [ cl_id ] ;
		        	p_t_info [ playerid ] [ credit_pledge_type ] = 3 ;
		        	show_give_credit ( playerid ) ;
				}
			}
		    return 1 ;
		}
		case d_give_credit_day:
		{
		    if ( ! response ) return show_give_credit ( playerid ) ;

		    new _value = strval ( inputtext ) ;
		    if ( _value < 5 || _value > 30 ) return show_dialog ( playerid, d_give_credit_day, DIALOG_STYLE_INPUT, "{"#cBHD"}Выдача кредита", "{"#cRD"}* Дней кредитования не может быть менее 5 и более 30.\n\n{"#cWH"}Укажите количество дней, на которые будет выдан кредит:", "Принять", "Назад" ) ;

            p_t_info [ playerid ] [ credit_day ] = _value ;
            show_give_credit ( playerid ) ;
		    return 1 ;
		}
		case d_credit_card:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				show_give_credit ( playerid ) ;
				return 1 ;
			}
			p_t_info [ playerid ] [ credit_card ] = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;
            show_give_credit ( playerid ) ;
			return 1 ;
		}
		case d_give_credit_sum:
		{
		    if ( ! response ) return show_give_credit ( playerid ) ;
		    
		    new _value = strval ( inputtext ), _card_id = p_t_info [ playerid ] [ credit_card ] ;
		    if ( _value < 50000 || _value > max_money ) return show_dialog ( playerid, d_give_credit_sum, DIALOG_STYLE_INPUT, "{"#cBHD"}Выдача кредита", "{"#cRD"}* Минимальная сумма кредита 50.000$\n\n\
																																		{"#cWH"}Если Вы берёте сумму менее {"#cLY"}"max_credit_notpledge_text"{"#cWH"}, то Вы можете не указывать залог.\n\
																																		{"#cWH"}Для большего шанса одобрения кредита необходимо указывать залог.\n\n\
																																		{"#cGRDialog"}* Укажите сумму кредита, которую хотите взять:", "Принять", "Назад" ) ;
		    if ( _card_id == -1 ) return show_dialog ( playerid, d_give_credit_sum, DIALOG_STYLE_INPUT, "{"#cBHD"}Выдача кредита", "{"#cRD"}* Вы не указали карту.\n\n\
																																		{"#cWH"}Если Вы берёте сумму менее {"#cLY"}"max_credit_notpledge_text"{"#cWH"}, то Вы можете не указывать залог.\n\
																																		{"#cWH"}Для большего шанса одобрения кредита необходимо указывать залог.\n\n\
																																		{"#cGRDialog"}* Укажите сумму кредита, которую хотите взять:", "Принять", "Назад" ) ;

            p_t_info [ playerid ] [ credit_sum ] = _value ;
            show_give_credit ( playerid ) ;
		    return 1 ;
		}
		case d_businesses_credit_1:
		{
			if ( ! response ) return 1 ;
			
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;

			static const _str [ ] = "SELECT * FROM `businesses_credit` WHERE `db_id` = '%d' LIMIT 1" ;
			new sql_string [ sizeof _str + 11 ] ;
			format ( sql_string, sizeof sql_string, _str, select_id ) ;
			mysql_tquery ( sql_connection, sql_string, "callback_businesses_credit_1", "i", playerid ) ;
		    return 1 ;
		}
		case d_businesses_credit:
		{
			if ( ! response ) 
			{
				DeletePVar ( playerid, "owner_name" ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы отказали в кредите." ) ;
				
				insert_debtor_message ( "Банк", "Вам было отказано в кредите!", p_t_info [ playerid ] [ creditor_id ] ) ;
				
				static const _str [ ] = "DELETE FROM `businesses_credit` WHERE `db_id` = '%d' LIMIT 1" ;
				new sql_string [ sizeof _str + 11 ] ;
				format ( sql_string, sizeof sql_string, _str, get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, sql_string, "", "" ) ;
				return 1 ;
			}
			
			new _owner_name [ 32 ] ;
			GetPVarString ( playerid, "owner_name", _owner_name, sizeof ( _owner_name ) ) ;
			DeletePVar ( playerid, "owner_name" ) ;
			
			new pl_id ;
			sscanf ( _owner_name, "u", pl_id ) ;
			
			new _credit_sum = p_t_info [ playerid ] [ credit_sum ] ;
		    new _credit_pay = p_t_info [ playerid ] [ credit_pay ] ;
		    new _card_number = p_t_info [ playerid ] [ credit_card ] ;
		    new _credit_day = p_t_info [ playerid ] [ credit_day ] ;
			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			new _active_card = GetPVarInt ( playerid, "active_card" ) ;
			DeletePVar ( playerid, "active_card" ) ;
			 
			if ( b_info [ _b_id - 1 ] [ b_money ] <  _credit_sum ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В Вашем Банке недостаточно средств для выдачи кредита!" ) ;
			
			new dialog_string [ 400 ] ;
			if ( IsPlayerConnected ( pl_id ) )
			{
				new deposit_id ;
				for ( new j = 0 ; j < MAX_BANK_ACCOUNT ; j ++ )
				{
					if ( bank_info [ pl_id ] [ bi_id ] [ j ] != _card_number ) continue ;
					
					deposit_id = j ;
					break ;
				}
				bank_info [ pl_id ] [ bi_credit ] [ deposit_id ] += _credit_pay ;
				bank_info [ pl_id ] [ bi_pledge ] [ deposit_id ] = p_t_info [ playerid ] [ credit_pledge ] ;
				bank_info [ pl_id ] [ bi_pledge_type ] [ deposit_id ] = p_t_info [ playerid ] [ credit_pledge_type ] ;
				bank_info [ pl_id ] [ bi_credit_day ] [ deposit_id ] = _credit_day ;
				bank_info [ pl_id ] [ bi_credit_card ] [ deposit_id ] = b_info [ _b_id - 1 ] [ b_id ] + 100000 ;
				bank_info [ pl_id ] [ bi_creditor ] [ deposit_id ] = b_info [ _b_id - 1 ] [ b_id ] ;
				
				SendClientMessage ( pl_id, col_white, !"{"#cGInfo"}* {"#cWH"}Вам был одобрен кредит!" ) ;
				format ( dialog_string, 144, "{"#cGInfo"}* {"#cWH"}На Ваш банковский счет {"#cGN"}№%d{"#cWH"} поступил перевод на сумму {"#cGN"}%d${"#cWH"}.", _active_card, _credit_sum ) ;
				SendClientMessage ( pl_id, col_white, dialog_string ) ;
			}
			else
			{
				insert_debtor_message ( "Банк", "Вам был одобрен кредит!\nПеревод можно получить в любом Банке.", p_t_info [ playerid ] [ creditor_id ] ) ;
			}
		    
			b_info [ _b_id - 1 ] [ b_money ] -= _credit_sum ;

			new _sql_string [ 128 ] ;
			format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_money` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ _b_id - 1 ] [ b_money ], b_info [ _b_id - 1 ] [ b_id ] ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;

		    format ( dialog_string, sizeof dialog_string, "UPDATE `deposit_boxes` SET `db_credit` = '%d', `db_pledge` = '%d', `db_pledge_type` = '%d', `db_credit_day` = '%d', `db_credit_card` = '%d', `db_creditor` = '%d' WHERE `db_id` = '%d' LIMIT 1",
			_credit_pay, p_t_info [ playerid ] [ credit_pledge ], p_t_info [ playerid ] [ credit_pledge_type ],
			_credit_day, b_info [ _b_id - 1 ] [ b_id ] + 100000, b_info [ _b_id - 1 ] [ b_id ],
			_card_number ) ;
			mysql_tquery ( sql_connection, dialog_string, "", "" ) ;

			format ( dialog_string, sizeof ( dialog_string ), "INSERT INTO `deposit_logs` (`dl_from`,`dl_to`,`dl_date`,`dl_money`) VALUES ('%d','%d',NOW(),'%d')",
			b_info [ _b_id - 1 ] [ b_id ] + 100000, _active_card, _credit_sum ) ;
			mysql_tquery ( sql_connection, dialog_string, "", "" ) ;

		    format ( dialog_string, sizeof ( dialog_string ), "INSERT INTO `deposit_transfer` (`dl_owner`,`dl_from`,`dl_to`,`dl_date`,`dl_money`,`dl_protection`) VALUES ('%d','%d','%d',NOW(),'%d','0')",
			p_t_info [ playerid ] [ creditor_id ], b_info [ _b_id - 1 ] [ b_id ] + 100000, _active_card, _credit_sum ) ;
			mysql_tquery ( sql_connection, dialog_string, "", "" ) ;
			
			if ( p_t_info [ playerid ] [ credit_pledge_type ] == 1 )
			{
			    new house_id = p_t_info [ playerid ] [ credit_pledge ] ;
			    h_info [ house_id - 1 ] [ h_sell_status ] = 2 ;
				format ( dialog_string, sizeof ( dialog_string ), "UPDATE `houses` SET `h_sell_status` = '2' WHERE `h_id` = '%d' LIMIT 1", h_info [ house_id - 1 ] [ h_id ] ) ;
				mysql_tquery ( sql_connection, dialog_string, "", "" ) ;
			}
			else if ( p_t_info [ playerid ] [ credit_pledge_type ] == 2 )
			{
			    new pledge_b_id = p_t_info [ playerid ] [ credit_pledge ] ;
			    b_info [ pledge_b_id - 1 ] [ b_sell_status ] = 2 ;
				format ( dialog_string, sizeof ( dialog_string ), "UPDATE `businesses` SET `b_sell_status` = '2' WHERE `b_id` = '%d' LIMIT 1", b_info [ pledge_b_id - 1 ] [ b_id ] ) ;
				mysql_tquery ( sql_connection, dialog_string, "", "" ) ;
			}
			else if ( p_t_info [ playerid ] [ credit_pledge_type ] == 3 )
			{
			    new _cl_id = p_t_info [ playerid ] [ credit_pledge ] ;
			    cellar_info [ _cl_id - 1 ] [ cl_sell_status ] = 2 ;
				format ( dialog_string, sizeof ( dialog_string ), "UPDATE `cellars` SET `cl_sell_status` = '2' WHERE `cl_id` = '%d' LIMIT 1", cellar_info [ _cl_id - 1 ] [ cl_id ] ) ;
				mysql_tquery ( sql_connection, dialog_string, "", "" ) ;
			}
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы одобрили кредит! Вам переодически будут поступать уведомления с информацией о должнике." ) ;
			
			format ( dialog_string, 128, "DELETE FROM `businesses_credit` WHERE `db_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
			mysql_tquery ( sql_connection, dialog_string, "", "" ) ;

		    new sql_string [ 92 ] ;
		    format ( sql_string, sizeof sql_string, "перевёл %s [КРЕДИТ от %s]", p_info [ playerid ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_credit_sum, sql_string ) ;

		    clear_player_credit ( playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock enter_credit_card ( playerid )
{
    global_string [ 0 ] = EOS ;

	new line_string [ 144 ], _card_count = 0, _card_type [ 32 ] ;
    for ( new j = 0 ; j < MAX_BANK_ACCOUNT ; j ++ )
    {
    	if ( bank_info [ playerid ] [ bi_type ] [ j ] != 3 ) continue ;

		set_player_listitem_values ( playerid, _card_count, j ) ;

		_card_count ++ ;

		switch ( bank_info [ playerid ] [ bi_type ] [ j ] )
		{
  			case 1: format ( _card_type, sizeof _card_type, "{"#cGRDialog"}Зарплатная{"#cWH"}" ) ;
	    	case 2: format ( _card_type, sizeof _card_type, "{"#cGN"}Накопительная{"#cWH"}" ) ;
		    case 3: format ( _card_type, sizeof _card_type, "{"#cYW"}Кредитная{"#cWH"}" ) ;
		}

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%d.{"#cWH"} {"#cWH"}№%d (%s) - {"#cGN"}%d$\n", _card_count, bank_info [ playerid ] [ bi_id ] [ j ], _card_type, bank_info [ playerid ] [ bi_money ] [ j ] ) ;
		strcat ( global_string, line_string ) ;
	}
	if ( _card_count == 0 ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Управление счетами", "{"#cRInfo"}* {"#cGRDialog"}У Вас нет кредитных карт.", "Выбрать", "Назад" ) ;
	show_dialog ( playerid, d_enter_credit_card, DIALOG_STYLE_LIST, "{"#cBHD"}Управление счетами", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock select_credit_property ( playerid )
{
	new dialog_string [ 300 ] ;

	new house_data [ 64 ];
	format ( house_data, 64, "Дом в залог {"#cGRDialog"}({"#cBL"}%d{"#cGRDialog"}){"#cWH"}\n", Iter_Count(player_houses[playerid]) ) ;

	new business_date [ 64 ];
	format ( business_date, 64, "Бизнес в залог {"#cGRDialog"}({"#cBL"}%d{"#cGRDialog"}){"#cWH"}\n", Iter_Count(player_business[playerid]) ) ;

	new garage_date [ 32 ];
	if ( p_info [ playerid ] [ cellar ] != -1 ) format ( garage_date, 32, "гараж №%d (%d$)\n", p_info [ playerid ] [ cellar ], cellar_info [ p_info [ playerid ] [ cellar ] - 1 ] [ cl_price ] ) ;
	else format ( garage_date, 32, "Гараж отсутствует\n" ) ;

	strcat ( dialog_string, house_data ) ;
	strcat ( dialog_string, business_date ) ;
	strcat ( dialog_string, garage_date ) ;
	
	SetPVarInt ( playerid, "debt_garage", p_info [ playerid ] [ cellar ] ) ;

	show_dialog ( playerid, d_credit_property, DIALOG_STYLE_LIST, "{"#cBHD"}Кредитование", dialog_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock select_credit_card ( playerid )
{
    global_string [ 0 ] = EOS ;

	new line_string [ 144 ], _card_count = 0, _card_type [ 32 ] ;
    for ( new j = 0 ; j < MAX_BANK_ACCOUNT ; j ++ )
    {
    	if ( ! bank_info [ playerid ] [ bi_type ] [ j ] ) continue ;

		set_player_listitem_values ( playerid, _card_count, j ) ;

		_card_count ++ ;

		switch ( bank_info [ playerid ] [ bi_type ] [ j ] )
		{
  			case 1: format ( _card_type, sizeof _card_type, "{"#cGRDialog"}Зарплатная{"#cWH"}" ) ;
	    	case 2: format ( _card_type, sizeof _card_type, "{"#cGN"}Накопительная{"#cWH"}" ) ;
		    case 3: format ( _card_type, sizeof _card_type, "{"#cYW"}Кредитная{"#cWH"}" ) ;
		}

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%d.{"#cWH"} {"#cWH"}№%d (%s) - {"#cGN"}%d$\n", _card_count, bank_info [ playerid ] [ bi_id ] [ j ], _card_type, bank_info [ playerid ] [ bi_money ] [ j ] ) ;
		strcat ( global_string, line_string ) ;
	}
	if ( _card_count == 0 ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Управление счетами", "{"#cRInfo"}* {"#cGRDialog"}У Вас нет счетов.", "Выбрать", "Назад" ) ;
	show_dialog ( playerid, d_credit_card, DIALOG_STYLE_LIST, "{"#cBHD"}Управление счетами", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_give_credit ( playerid )
{
	if ( ! GetPVarInt ( playerid, "p_biz_id" ) ) return bad_exit ( playerid ) ;
	
	global_string [ 0 ] = EOS ;

	new _pledge_str [ 64 ] ;
	switch ( p_t_info [ playerid ] [ credit_pledge_type ] )
	{
	    case 0: format ( _pledge_str, sizeof _pledge_str, "{"#cRD"}Не выбран" ) ;
	    case 1: format ( _pledge_str, sizeof _pledge_str, "Дом {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ]  ) ;
	    case 2: format ( _pledge_str, sizeof _pledge_str, "Бизнес {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
	    case 3: format ( _pledge_str, sizeof _pledge_str, "Гараж {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
	}
	
	new _card_str [ 32 ] ;
	if ( p_t_info [ playerid ] [ credit_card ] == -1 ) format ( _card_str, sizeof _card_str, "{"#cRD"}Не указана" ) ;
	else format ( _card_str, sizeof _card_str, "{"#cGN"}№%d", p_t_info [ playerid ] [ credit_card ] ) ;
	
	new _go_credit_str [ 16 ] ;
	if ( p_t_info [ playerid ] [ credit_card ] != -1 && p_t_info [ playerid ] [ credit_day ] > 0 && 
		( p_t_info [ playerid ] [ credit_sum ] > 0 && p_t_info [ playerid ] [ credit_sum ] < max_credit_notpledge || p_t_info [ playerid ] [ credit_sum ] > max_credit_notpledge && p_t_info [ playerid ] [ credit_pledge ] > 0 ) )
	{
	    format ( _go_credit_str, sizeof _go_credit_str, "{"#cBL"}" ) ;
	}
	else format ( _go_credit_str, sizeof _go_credit_str, "{"#cRD"}" ) ;
	
	format ( global_string, sizeof global_string, "{"#cGRDialog"}Кредит от %s\n\
	                                                {"#cBL"}1. {"#cWH"}Карта для выдачи: %s\n\
													{"#cBL"}2. {"#cWH"}Сумма кредита: {"#cGN"}%d$\n\
													{"#cBL"}3. {"#cWH"}Процент: {"#cGN"}%d%%\n\
													{"#cBL"}4. {"#cWH"}Срок: {"#cGN"}%d {"#cWH"}дн.\n\
													{"#cBL"}5. {"#cWH"}Залог: %s\n\
													%sПодать заявку на кредит", b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_name ],
													_card_str,
													p_t_info [ playerid ] [ credit_sum ], b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 1 ],
													p_t_info [ playerid ] [ credit_day ], _pledge_str, _go_credit_str ) ;
    show_dialog ( playerid, d_give_credit, DIALOG_STYLE_LIST, "{"#cBHD"}Кредитование", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

callback: callback_businesses_credit ( playerid )
{
    new fields,
		rows ;

	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В Вашем Банке нет заявок для рассмотрения." ) ;
	if ( rows )
	{
		new scm_string [ 128 ] ;
		global_string [ 0 ] = EOS ;
	    for ( new i = 0 ; i < rows ; i ++ )
		{
			new db_id = cache_get_field_content_int ( i, "db_id", sql_connection ) ;
		
			new db_credit = cache_get_field_content_int ( i, "db_credit", sql_connection ) ;
	        new db_credit_day = cache_get_field_content_int ( i, "db_credit_day", sql_connection ) ;
			
			new db_pledge = cache_get_field_content_int ( i, "db_pledge", sql_connection ) ;
	        new db_pledge_type = cache_get_field_content_int ( i, "db_pledge_type", sql_connection ) ;
			
			new db_owner_name [ 32 ] ;
			cache_get_field_content ( i, "db_owner_name", db_owner_name, sql_connection, MAX_PLAYER_NAME ) ;
		
			set_player_listitem_values ( playerid, i, db_id ) ;
		
			if ( ! db_pledge_type ) format ( scm_string, sizeof scm_string, "{"#cGRDialog"}(Без залога) {"#cWH"}%s, {"#cGN"}%d$ {"#cWH"} на {"#cGN"}%d дн.\n", db_owner_name, db_credit, db_credit_day ) ;
			else 
			{
				new _pledge_str [ 70 ] ;
				switch ( db_pledge_type )
				{
					case 1: format ( _pledge_str, sizeof _pledge_str, "(Залог Дом №%d '%d$')", db_pledge, h_info [ db_pledge - 1 ] [ h_price ] ) ;
					case 2: format ( _pledge_str, sizeof _pledge_str, "(Залог Бизнес %s '%d$')", b_info [ db_pledge - 1 ] [ b_name ], b_info [ db_pledge - 1 ] [ b_price ] ) ;
					case 3: format ( _pledge_str, sizeof _pledge_str, "(Залог Гараж №%d '%d$')", cellar_info [ db_pledge - 1 ] [ cl_id ], cellar_info [ db_pledge - 1 ] [ cl_price ] ) ;
				}
			
				format ( scm_string, sizeof scm_string, "{"#cGRDialog"}%s {"#cWH"}%s, {"#cGN"}%d$ {"#cWH"}на {"#cGN"}%d дн.\n", _pledge_str, db_owner_name, db_credit, db_credit_day ) ;
			}
			strcat ( global_string, scm_string ) ;
		}
		show_dialog ( playerid, d_businesses_credit_1, DIALOG_STYLE_LIST, "{"#cBHD"}Кредитование", global_string, "Выбрать", "Назад" ) ;
	}
	return 1 ;
}

callback: callback_businesses_credit_1 ( playerid )
{
    new fields,
		rows ;

	cache_get_data ( rows, fields ) ;
	if( rows )
	{
		new db_id = cache_get_field_content_int ( 0, "db_id", sql_connection ) ;
		set_player_use_listitem ( playerid, db_id ) ;
	
		p_t_info [ playerid ] [ credit_sum ] = cache_get_field_content_int ( 0, "db_credit", sql_connection ) ;
	    p_t_info [ playerid ] [ credit_day ] = cache_get_field_content_int ( 0, "db_credit_day", sql_connection ) ;
		
		p_t_info [ playerid ] [ credit_card ] = cache_get_field_content_int ( 0, "db_credit_card", sql_connection ) ;
		new db_active_card = cache_get_field_content_int ( 0, "db_active_card", sql_connection ) ;
		SetPVarInt ( playerid, "active_card", db_active_card ) ;
			
		p_t_info [ playerid ] [ credit_pledge ] = cache_get_field_content_int ( 0, "db_pledge", sql_connection ) ;
	    p_t_info [ playerid ] [ credit_pledge_type ] = cache_get_field_content_int ( 0, "db_pledge_type", sql_connection ) ;
			
		new db_owner_name [ MAX_PLAYER_NAME ] ;
		cache_get_field_content ( 0, "db_owner_name", db_owner_name, sql_connection, MAX_PLAYER_NAME ) ;
		SetPVarString ( playerid, "owner_name", db_owner_name ) ;
		
		p_t_info [ playerid ] [ creditor_id ] = cache_get_field_content_int ( 0, "db_owner", sql_connection ) ;
		
		new _pledge_str [ 64 ] ;
		switch ( p_t_info [ playerid ] [ credit_pledge_type ] )
		{
			case 0: format ( _pledge_str, sizeof _pledge_str, "{"#cRD"}Не выбран" ) ;
			case 1: format ( _pledge_str, sizeof _pledge_str, "Дом {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
			case 2: format ( _pledge_str, sizeof _pledge_str, "Бизнес {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
			case 3: format ( _pledge_str, sizeof _pledge_str, "Гараж {"#cGN"}№%d", p_t_info [ playerid ] [ credit_pledge ] ) ;
		}
		
		new _credit_pay = floatround ( ( p_t_info [ playerid ] [ credit_sum ] * b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 1 ] ) / 100 ) ;
		p_t_info [ playerid ] [ credit_pay ] = p_t_info [ playerid ] [ credit_sum ] + _credit_pay ;
	
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "{"#cWH"}Кредит для %s.\n\n\
														{"#cBInfo"}* {"#cWH"}Сумма кредита: {"#cGN"}%d$\n\
														{"#cBInfo"}* {"#cWH"}Процент: {"#cGN"}%d%%\n\
														{"#cBInfo"}* {"#cWH"}Переплата: {"#cGN"}%d$\n\
														{"#cBInfo"}* {"#cWH"}Срок: {"#cGN"}%d {"#cWH"}дн.\n\
														{"#cBInfo"}* {"#cWH"}Залог: %s\n\n\
														{"#cGRDialog"}* Вы согласны одобрить кредит?", db_owner_name, 
														p_t_info [ playerid ] [ credit_sum ], b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 1 ], _credit_pay,
														p_t_info [ playerid ] [ credit_day ], _pledge_str ) ;
														
		show_dialog ( playerid, d_businesses_credit, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кредитование", global_string, "Да", "Нет" ) ;
	}
	return 1 ;
}

callback: callback_credit_day ( )
{
    new fields,
		rows ;

	cache_get_data ( rows, fields ) ;
	if( rows )
	{
		new scm_string [ 228 ] ;
	    for ( new i = 0 ; i < rows ; i ++ )
	    {
	        new db_owner = cache_get_field_content_int ( i, "db_owner", sql_connection ) ;
	        new db_id = cache_get_field_content_int ( i, "db_id", sql_connection ) ;
	        new db_credit_day = cache_get_field_content_int ( i, "db_credit_day", sql_connection ) ;

	        if ( db_credit_day == 1 )
	        {
	            new db_creditor = cache_get_field_content_int ( i, "db_creditor", sql_connection ) ;
	            new db_pledge = cache_get_field_content_int ( i, "db_pledge", sql_connection ) ;
	            new db_pledge_type = cache_get_field_content_int ( i, "db_pledge_type", sql_connection ) ;
				new db_credit = cache_get_field_content_int ( i, "db_credit", sql_connection ) ;

				if ( db_pledge_type == 0 )
				{
					new _collector_money = floatround ( ( db_credit * sell_percent ) / 100 ) ;
				
					format ( scm_string, sizeof scm_string, "Вы просрочили кредит. Банк взыщит часть суммы в виде %d"valute_title_"!\nУ Вас будет образована задолженность перед государством!", _collector_money ) ;
					insert_debtor_message ( "Банк", scm_string, db_owner ) ;
					
					format ( scm_string, sizeof scm_string, "Игрок просрочил кредит!\n\nВы автоматически взыскали часть суммы в виде %d"valute_title_".", _collector_money ) ;
					insert_debtor_message ( "Банк", scm_string, b_info [ db_creditor - 1 ] [ b_owner_inc ] ) ;
					
					format ( scm_string, sizeof scm_string, "UPDATE `users` SET `u_tax` = `u_tax` + '%d' WHERE `u_id` = '%d' LIMIT 1", _collector_money, db_owner ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
					
					b_info [ db_creditor - 1 ] [ b_money ] += _collector_money ;
				
	                format ( scm_string, sizeof scm_string, "UPDATE `businesses` SET `b_money` = `b_money` + '%d' WHERE `b_id` = '%d' LIMIT 1", _collector_money, b_info [ db_creditor - 1 ] [ b_id ] ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
				
				}
	            else if ( db_pledge_type == 1 )
	            {
					b_info [ db_creditor - 1 ] [ b_money ] += h_info [ db_pledge - 1 ] [ h_price ] ;
				
	                format ( scm_string, sizeof scm_string, "UPDATE `businesses` SET `b_money` = `b_money` + '%d' WHERE `b_id` = '%d' LIMIT 1", h_info [ db_pledge - 1 ] [ h_price ], b_info [ db_creditor - 1 ] [ b_id ] ) ;
					mysql_tquery ( sql_connection, scm_string ) ;

					sell_houses ( db_pledge - 1, -1, false, true ) ;
					
					insert_debtor_message ( "Банк", "Вы просрочили кредит. Имущество продано!", db_owner ) ;
					insert_debtor_message ( "Банк", "Игрок просрочил кредит! Имущество продано, деньги переданы в Банк.", b_info [ db_creditor - 1 ] [ b_owner_inc ] ) ;
	            }
	            else if ( db_pledge_type == 2 )
	            {
					b_info [ db_creditor - 1 ] [ b_money ] += b_info [ db_pledge - 1 ] [ b_price ] ;
				
	                format ( scm_string, sizeof scm_string, "UPDATE `businesses` SET `b_money` = `b_money` + '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ db_pledge - 1 ] [ b_price ], b_info [ db_creditor - 1 ] [ b_id ] ) ;
					mysql_tquery ( sql_connection, scm_string ) ;

					sell_businesses ( db_pledge - 1, -1, false, true ) ;
					
					insert_debtor_message ( "Банк", "Вы просрочили кредит. Имущество продано!", db_owner ) ;
					insert_debtor_message ( "Банк", "Игрок просрочил кредит! Имущество продано, деньги переданы в Банк.", b_info [ db_creditor - 1 ] [ b_owner_inc ] ) ;
	            }
	            else if ( db_pledge_type == 3 )
	            {
					b_info [ db_creditor - 1 ] [ b_money ] += cellar_info [ db_pledge - 1 ] [ cl_price ] ;
				
	                format ( scm_string, sizeof scm_string, "UPDATE `businesses` SET `b_money` = `b_money` + '%d' WHERE `b_id` = '%d' LIMIT 1", cellar_info [ db_pledge - 1 ] [ cl_price ], b_info [ db_creditor - 1 ] [ b_id ] ) ;
					mysql_tquery ( sql_connection, scm_string ) ;

	                format ( scm_string, sizeof scm_string, "UPDATE `cellars` SET `cl_owner` = '-1' WHERE `cl_id` = '%d' LIMIT 1", db_pledge ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
					
					insert_debtor_message ( "Банк", "Вы просрочили кредит. Имущество продано!", db_owner ) ;
					insert_debtor_message ( "Банк", "Игрок просрочил кредит! Имущество продано, деньги переданы в Банк.", b_info [ db_creditor - 1 ] [ b_owner_inc ] ) ;
	            }

				format ( scm_string, sizeof scm_string, "UPDATE `deposit_boxes` SET `db_credit_day` = '0', `db_creditor` = '-1', `db_pledge` = '0', `db_pledge_type` = '0', `db_credit` = '0' WHERE `db_id` = '%d' LIMIT 1", db_id ) ;
				mysql_tquery ( sql_connection, scm_string ) ;
	            continue ;
	        }

			format ( scm_string, sizeof scm_string, "До конца кредита по карте №%d осталось %d дней.", db_id, db_credit_day ) ;
			insert_debtor_message ( "Банк", scm_string, db_owner ) ;

			format ( scm_string, sizeof scm_string, "UPDATE `deposit_boxes` SET `db_credit_day` = `db_credit_day`-'1' WHERE `db_id` = '%d' LIMIT 1", db_id ) ;
			mysql_tquery ( sql_connection, scm_string ) ;
	    }
	}
	return 1 ;
}

callback: callback_delite_credit ( )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;
	
	for ( new i = 0 ; i < rows ; i ++ )
	{
		new account_id = cache_get_field_content_int ( i, "db_owner", sql_connection ) ;
		insert_debtor_message ( "Кредит", "Срок действия Вашей заявки истёк!\nЗаявка на кредит отклонена.", account_id ) ;
	}
	mysql_tquery ( sql_connection, !"DELETE FROM `businesses_credit` WHERE `db_date` < NOW()-INTERVAL 3 DAY", "", "" ) ;
	return 1 ;
}

/* 

CREATE TABLE `businesses_credit` (
  `db_id` int(11) NOT NULL,
  `db_owner_name` varchar(32) NOT NULL,
  `db_owner` int(6) NOT NULL,
  `db_creditor` int(11) NOT NULL DEFAULT '-1',
  `db_credit` int(11) NOT NULL DEFAULT '0',
  `db_pledge` int(9) NOT NULL DEFAULT '0',
  `db_pledge_type` int(3) NOT NULL DEFAULT '0',
  `db_credit_day` int(3) NOT NULL DEFAULT '0',
  `db_active_card` int(11) NOT NULL DEFAULT '0',
  `db_credit_card` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `businesses_credit`
  ADD PRIMARY KEY (`db_id`);

ALTER TABLE `businesses_credit`
  MODIFY `db_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
  
*/