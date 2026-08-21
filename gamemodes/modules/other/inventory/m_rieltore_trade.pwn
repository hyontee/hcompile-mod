enum _trade_rieltore
{
	trade_id,
	bool: trade_accept,
	trade_money
} ;
new trade_rielt [ MAX_PLAYERS ] [ _trade_rieltore ] ;

new bool: used_trade [ MAX_PLAYERS ] ;

enum
{
	d_accept_trade = 22000,
	
	d_prise_trade,
	d_prise_trade_count,
	
	d_trade,
	d_trade_vehicle,
	d_trade_money,
	d_home_trade,
	d_business_trade,
	d_trade_accessories,
	d_use_trade,
	d_accept_trade_1,
	d_accept_trade_2,
	d_returnmoney_trade,
	d_trade_rielt_skins,
	d_trade_ft,
	d_skin_show,
	
	d_trade_info,
	d_trade_info_house,
	d_trade_info_bizz,
	d_trade_inform
} ;

stock clear_player_trade ( playerid )
{
	used_trade [ playerid ] =
	trade_rielt [ playerid ] [ trade_accept ] = false ;
	trade_rielt [ playerid ] [ trade_id ] = INVALID_PLAYER_ID ;
	return 1 ;
}

stock trade_OnPlayerDisconnect ( playerid )
{
	if ( trade_rielt [ playerid ] [ trade_id ] != INVALID_PLAYER_ID )
	{
		show_packet_trade ( playerid, 3, "" ) ;
	}
	return 1 ;
}

stock show_trade ( playerid )
{
	if ( p_t_info [ playerid ] [ owner_account ] ) return bad_owner_account ( playerid ) ;
	if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы администратор." ) ;
	if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 ) return bad_exit ( playerid ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "{"#cBL"}1. {"#cWH"}Предложить обмен\n{"#cBL"}2. {"#cWH"}Примерочная\n{"#cBL"}3. {417419}Общее положение по обмену\n{"#cGRDialog"}- {"#cWH"}Комиссия: {"#cGN"}%d$", b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 2 ] ) ;
	show_dialog ( playerid, d_use_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Обмен имуществом", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:trade ( playerid, params [ ] )
{
	if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
	if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /trade [id/имя]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
	if ( ! bad_dialog ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Недоступно в данный момент." ) ;
	if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы администратор." ) ;
	
	if ( GetString ( p_t_info [ params [ 0 ] ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
	{
		new scm_string [ 128 ] ;
		format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s[%d] попытка трейда %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ params [ 0 ] ] [ name ], params [ 0 ] ) ;
		foreach(new i: admin_players)SendClientMessage ( i, col_admin, scm_string ) ;

		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно обмениваться с данным игроком." ) ;
		return 1 ;
	}

	global_string [ 0 ] = EOS ;
    format ( global_string, 100, "{"#cGInfo"}* {"#cWH"}Вы предложили {"#cGN"}%s {"#cWH"}обмен.",p_info [ params [ 0 ] ] [ name ] ) ;
    SendClientMessage ( playerid, col_white, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "\
	{"#cOR"}%s {"#cWH"}предлагает Вам обмен.\n\n\
	{"#cWH"}Вне риелторского агентства Вы можете обменять:\n\
	{"#cGRDialog"}- {"#cWH"}Предметы инвентаря\n\
	{"#cGRDialog"}- {"#cWH"}Аксессуары\n\n\
	{"#cGRDialog"}* Вы согласны начать обмен?", p_info [ playerid ] [ name ] ) ;
    show_dialog ( params [ 0 ], d_accept_trade_2, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предложение обмена", global_string, "Да", "Нет" ) ;

    buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
	return 1 ;
}

stock clear_trade_info ( playerid, targetid )
{
	for ( new i = 0 ; i < MAX_TRADE_SLOTS ; i ++ )
	{
		GetTradeInventory ( playerid, INV_ITEM, i ) =
		GetTradeInventory ( playerid, INV_ITEM_COUNT, i ) =

		GetTradeInventory ( targetid, INV_ITEM, i ) =
		GetTradeInventory ( targetid, INV_ITEM_COUNT, i ) = 0 ;
	}
	
	trade_rielt [ playerid ] [ trade_id ] = targetid ;
	trade_rielt [ targetid ] [ trade_id ] = playerid ;

	trade_rielt [ playerid ] [ trade_money ] =
	trade_rielt [ targetid ] [ trade_money ] = 0 ;
	
	trade_rielt [ playerid ] [ trade_accept ] =
	trade_rielt [ targetid ] [ trade_accept ] = false ;
	
	used_trade [ playerid ] =
	used_trade [ targetid ] = true ;
	return 1 ;
}

stock trade_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_use_trade:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
				if ( p_info [ playerid ] [ money ] < b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 2 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не хватает средств на оплату комиссии." ) ;
			
				global_string [ 0 ] = EOS ;

				new TotalPla ;
				foreach(new i: streamed_players[playerid])
				{
					if ( trade_rielt [ i ] [ trade_id ] != INVALID_PLAYER_ID ) continue ;
					
					set_player_listitem_values ( playerid, TotalPla, i ) ;

					TotalPla ++ ;
					if ( TotalPla == 20 ) break ;

					format( global_string, sizeof global_string, "%s{"#cWH"}%s[%d]\n", global_string, p_info [ i ] [ name ], i ) ;
				}
				
				if ( TotalPla == 0 )
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cWH"}Нет поблизости игроков, с которыми можно обмениваться!", "Принять", "" ) ;

				else
				    show_dialog ( playerid, d_accept_trade_1, DIALOG_STYLE_LIST, "{"#cBHD"}Обмен", global_string, "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				show_dialog ( playerid, d_skin_show, DIALOG_STYLE_INPUT, "{"#cBHD"}Примерочная", "{"#cWH"}Укажите ID одежды, которую Вы хотите примерить:", "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 2 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен / трейд", "{"#cBL"}Обмен:\n\n\
					{"#cWH"}Вы можете обменяться {"#cLY"}любым {"#cWH"}имуществом для этого обратитесть в {"#cLY"}/gps - Бизнесы - Риелторское агентство{"#cWH"}.\n\
					При обмене Вы можете предложить всё, что угодно, как и тот, с кем Вы меняетесь.\n\
					Настоятельно рекомендуем не ждать чего-либо, а меняться сразу на оговоренное.\n\n\
					{"#cRInfo"}Администрация не несёт ответственности за Вашу невнимательность!\n\
					Мы Вас не ограничиваем в обмене и даём возможность обменять всё сразу!\n\
					Не нужно верить в то, что игрок что-то сперва помериет, а потом, если всё устроит,\n\
					то отдаст обещанное!\n\n\
					МЕНЯЙТЕСЬ НА ВСЁ СРАЗУ, НЕ ЖДИТЕ НИКАКИХ ПРИМЕРОК И ТОМУ ПОДОБНОГО!", "Закрыть", "" ) ;
			}
			else if ( listitem == 3 ) show_trade ( playerid ) ;
			return 1 ;
		}
		case d_skin_show:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				show_trade ( playerid ) ;
				return 1 ;
			}
			
			new _value = strval ( inputtext ) ;
			if ( _value == 74 || _value == 267 || _value == 268 || _value == 269 || _value == 270 || _value == 271 )return show_dialog ( playerid, d_skin_show, DIALOG_STYLE_INPUT, "{"#cBHD"}Примерочная", "{"#cRD"}* Номер одежды указан некорректно!\n\n{"#cWH"}Укажите ID одежды, которую Вы хотите примерить:", "Выбрать", "Назад" ) ;

			if ( ! getValidReplacableSkinModel ( _value ) )
				return show_dialog ( playerid, d_skin_show, DIALOG_STYLE_INPUT, "{"#cBHD"}Примерочная", "{"#cRD"}* Номер одежды указан некорректно!\n\n{"#cWH"}Укажите ID одежды, которую Вы хотите примерить:", "Выбрать", "Назад" ) ;
			
			show_for_timeskin ( playerid, _value ) ;
			return 1 ;
		}
		case d_accept_trade_1:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				show_trade ( playerid ) ;
				return 1 ;
			}
			
			new targetid = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( ! IsPlayerConnected ( targetid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( targetid == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 30, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
			if ( ! bad_dialog ( targetid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Недоступно в данный момент." ) ;
			if ( p_info [ targetid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
			if ( admin_info [ targetid ] [ admin ] > 0 && admin_info [ targetid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок администратор." ) ;

			if ( GetString ( p_t_info [ targetid ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
			{
				new scm_string [ 128 ] ;
				format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s[%d] попытка трейда %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ targetid ] [ name ], targetid ) ;
				foreach(new i: admin_players)SendClientMessage ( i, col_admin, scm_string ) ;

				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно обмениваться с данным игроком." ) ;
				return 1 ;
			}

			new _t_string [ 138 ] ;
			format(_t_string,sizeof(_t_string),"{"#cGInfo"}* {"#cWH"}Вы предложили {"#cGN"}%s {"#cWH"}обмен.",p_info [ targetid ] [ name ] ) ;
			SendClientMessage ( playerid, col_white, _t_string ) ;

			format ( _t_string, sizeof ( _t_string ),"{FFFFFF}%s предлагает Вам обмен.\n\n{"#cBL"}Вы согласны начать обмен?", p_info [ playerid ] [ name ] ) ;
			show_dialog ( targetid, d_accept_trade, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предложение обмена", _t_string, "Да", "Нет" ) ;

			buyer_id [ playerid ] = targetid ;
			seller_id [ targetid ] = playerid ;
			
			sell_time { playerid } =
			sell_time { targetid } = time_sell_null ;
			return 1 ;
		}
		case d_accept_trade:
		{
			if ( ! response )
			{
				if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) clear_sell_params ( playerid, playerid ) ;
				else clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new targetid = seller_id [ playerid ] ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 15, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;

			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			if ( _b_id < 1 ) return bad_exit ( playerid ) ;
			if ( b_info [ _b_id - 1 ] [ b_product ] < b_other_product [ 2 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В бизнесе недостаточно бланков для подписания договора." ) ;
			
			new _price = b_price_market [ _b_id - 1 ] [ 2 ] ;
			if ( p_info [ playerid ] [ money ] < _price ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств для трейда." ) ;
			
			give_bmoney ( _b_id, _price, b_other_product [ 2 ] ) ;
			
			give_money ( playerid, -_price ) ;
            insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "комиссия трейд" ) ;
			
			clear_trade_info ( playerid, targetid ) ;
			clear_sell_params ( playerid, targetid ) ;

			show_window_trade ( playerid ) ;
			show_window_trade ( targetid ) ;

			trade_update_info ( playerid ) ;
			trade_update_info ( targetid ) ;
			return 1 ;
		}
		case d_accept_trade_2:
		{
			if ( ! response )
			{
				if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) clear_sell_params ( playerid, playerid ) ;
				else clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new targetid = seller_id [ playerid ] ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 15, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
			if ( p_info [ targetid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
			if ( admin_info [ targetid ] [ admin ] > 0 && admin_info [ targetid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок администратор." ) ;

			clear_trade_info ( playerid, targetid ) ;
			clear_sell_params ( playerid, targetid ) ;

			show_window_trade ( playerid ) ;
			show_window_trade ( targetid ) ;

			trade_update_info ( playerid ) ;
			trade_update_info ( targetid ) ;
			return 1 ;
		}
		case d_trade_money:
		{
			if ( ! response ) return 1 ;
			
			new _value = strval ( inputtext ) ;
			
			if ( _value + trade_rielt [ playerid ] [ trade_money ] < 1 || _value + trade_rielt [ playerid ] [ trade_money ] > max_money )
				return show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
				
			if ( _value < 1 || _value + trade_rielt [ playerid ] [ trade_money ] > p_info [ playerid ] [ money ] || _value > max_money )
				return show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
			
			trade_rielt [ playerid ] [ trade_money ] += _value ;
		
			new _targetid = trade_rielt [ playerid ] [ trade_id ] ;
			trade_update_info ( playerid ) ;
			trade_update_info ( _targetid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock show_window_trade ( playerid )
{
	#if defined debug_packet
		printf ( "[show_window_trade] playerid: %d", playerid ) ;
	#endif

	SetTradeItem ( playerid ) ;
	tradeInventoryInsert ( playerid ) ;

	toggle_controlable ( playerid, true ) ;
	return 1 ;
}

stock accept_trade ( playerid, targetid )
{
	new _traderCount = 0, _receiverCount = 0 ;
	for ( new i = 0 ; i < MAX_TRADE_SLOTS ; i ++ )
	{
		if ( GetTradeInventory ( playerid, INV_ITEM, i ) > 0 ) _traderCount ++ ;
		if ( GetTradeInventory ( targetid, INV_ITEM, i ) > 0 ) _receiverCount ++ ;
	}

	new _traderInventoryCount = 0, _receiverInventoryCount = 0 ;
	for ( new i = 0 ; i < MAX_INVENTORY_SLOTS ; i ++ )
	{
		if ( GetUsersInventory ( playerid, INV_ITEM, i ) > 0 ) _traderInventoryCount ++ ;
		if ( GetUsersInventory ( targetid, INV_ITEM, i ) > 0 ) _receiverInventoryCount ++ ;
	}

	if ( _traderInventoryCount + _receiverCount > MAX_INVENTORY_SLOTS )
	{
		send_check_cinfo ( playerid, "У Вас недостаточно слотов в инвентаре для обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		send_check_cinfo ( targetid, "У игрока недостаточно слотов в инвентаре для обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	if ( _receiverInventoryCount + _traderCount > MAX_INVENTORY_SLOTS )
	{
		send_check_cinfo ( targetid, "У Вас недостаточно слотов в инвентаре для обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		send_check_cinfo ( playerid, "У игрока недостаточно слотов в инвентаре для обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new _str [ 64 ], query_string [ 144 ] ;
	for ( new i = 0 ; i < MAX_TRADE_SLOTS ; i ++ )
	{
		if ( GetTradeInventory ( playerid, INV_ITEM, i ) > 0 && GetTradeInventory ( playerid, INV_ITEM_COUNT, i ) > 0 )
		{
			if ( GetTradeInventory ( playerid, INV_ITEM_TYPE, i ) == RENDER_TYPE_PLATE )
			{
				static const _str2 [ ] = "UPDATE `licence_plate` SET `licence_plate_char_id` = '%d' WHERE `id` = '%d' LIMIT 1" ;
				new query_string2 [ sizeof _str2 + ( 9 * 2 ) ] ;
				format ( query_string2, sizeof query_string2, _str2, 
				p_info [ targetid ] [ id ], 
				GetTradeInventory ( playerid, INV_ITEM_ID, i ) ) ;
				mysql_tquery ( sql_connection, query_string2 ) ;
			}

			new USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;
			moveInventory = TransferInventoryStructure ( playerid, SUB_INV_TRADE, i ) ;
			giveInventory ( targetid, moveInventory ) ;

			query_string [ 0 ] = EOS ;
			format ( query_string, sizeof query_string, "%s обменял %s (%d шт) у %s",
			p_info [ targetid ] [ name ], 
			item_name ( GetTradeInventory ( playerid, INV_ITEM, i ) ),
			GetTradeInventory ( playerid, INV_ITEM_COUNT, i ),
			p_info [ playerid ] [ name ] ) ;
			WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;

			clear_trade_slot (
				playerid,
				GetTradeInventory ( playerid, INV_ITEM, i ),
				GetTradeInventory ( playerid, INV_ITEM_COUNT, i ),
				i
			) ;
		}

		if ( GetTradeInventory ( targetid, INV_ITEM, i ) > 0 && GetTradeInventory ( targetid, INV_ITEM_COUNT, i ) > 0 )
		{
			if ( GetTradeInventory ( targetid, INV_ITEM_TYPE, i ) == RENDER_TYPE_PLATE )
			{
				static const _str2 [ ] = "UPDATE `licence_plate` SET `licence_plate_char_id` = '%d' WHERE `id` = '%d' LIMIT 1" ;
				new query_string2 [ sizeof _str2 + ( 9 * 2 ) ] ;
				format ( query_string2, sizeof query_string2, _str2,
				p_info [ playerid ] [ id ], 
				GetTradeInventory ( targetid, INV_ITEM_ID, i ) ) ;
				mysql_tquery ( sql_connection, query_string2 ) ;
			}

			new USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;
			moveInventory = TransferInventoryStructure ( targetid, SUB_INV_TRADE, i ) ;
			giveInventory ( playerid, moveInventory ) ;

			query_string [ 0 ] = EOS ;
			format ( query_string, sizeof query_string, "%s обменял %s (%d шт) у %s",
			p_info [ playerid ] [ name ], 
			item_name ( GetTradeInventory ( targetid, INV_ITEM, i ) ),
			GetTradeInventory ( targetid, INV_ITEM_COUNT, i ),
			p_info [ targetid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;

			clear_trade_slot (
				targetid,
				GetTradeInventory ( targetid, INV_ITEM, i ),
				GetTradeInventory ( targetid, INV_ITEM_COUNT, i ),
				i
			) ;
		}
	}

	if ( trade_rielt [ targetid ] [ trade_money ] > 0 )
	{
		give_money ( playerid, trade_rielt [ targetid ] [ trade_money ] ) ;
		format ( _str, sizeof _str, "Обмен с %s", p_info [ targetid ] [ name ] ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, trade_rielt [ targetid ] [ trade_money ], _str ) ;

		give_money ( targetid, -trade_rielt [ targetid ] [ trade_money ] ) ;
		format ( _str, sizeof _str, "Обмен с %s", p_info [ playerid ] [ name ] ) ;
		insert_money_log ( targetid, INVALID_PLAYER_ID, -trade_rielt [ targetid ] [ trade_money ], _str ) ;
	}

	if ( trade_rielt [ playerid ] [ trade_money ] > 0 )
	{
		give_money ( targetid, trade_rielt [ playerid ] [ trade_money ] ) ;
		format ( _str, sizeof _str, "Обмен с %s", p_info [ playerid ] [ name ] ) ;
		insert_money_log ( targetid, INVALID_PLAYER_ID, trade_rielt [ playerid ] [ trade_money ], _str ) ;

		give_money ( playerid, -trade_rielt [ playerid ] [ trade_money ] ) ;
		format ( _str, sizeof _str, "Обмен с %s", p_info [ targetid ] [ name ] ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -trade_rielt [ playerid ] [ trade_money ], _str ) ;
	}

	trade_rielt [ playerid ] [ trade_money ] =
	trade_rielt [ targetid ] [ trade_money ] = 0 ;

	show_packet_trade ( playerid, 3, "" ) ;
	return 1 ;
}

stock return_player_inventory ( playerid )
{
	new query_string [ 144 ] ;
	for ( new i = 0 ; i < MAX_TRADE_SLOTS ; i ++ )
	{
		if ( GetTradeInventory ( playerid, INV_ITEM, i ) > 0 && GetTradeInventory ( playerid, INV_ITEM_COUNT, i ) > 0 )
		{
			new USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;
			moveInventory = TransferInventoryStructure ( playerid, SUB_INV_TRADE, i ) ;
			giveInventory ( playerid, moveInventory ) ;

			query_string [ 0 ] = EOS ;
			format ( query_string, sizeof query_string, "%s возврат при отказе %s (%d шт)",
			p_info [ playerid ] [ name ], 
			item_name ( GetTradeInventory ( playerid, INV_ITEM, i ) ),
			GetTradeInventory ( playerid, INV_ITEM_COUNT, i ) ) ;
			WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;

			clear_trade_slot (
				playerid,
				GetTradeInventory ( playerid, INV_ITEM, i ),
				GetTradeInventory ( playerid, INV_ITEM_COUNT, i ),
				i
			) ;
		}
	}
	trade_rielt [ playerid ] [ trade_money ] = 0 ;
	return 1 ;
}

stock show_packet_trade ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new moveFromIndex, moveToIndex, moveFromInventoryType, moveToInventoryType ;
		JSON_GetInt ( json, "moveFromIndex", moveFromIndex ) ;
		JSON_GetInt ( json, "moveToIndex", moveToIndex ) ;
		JSON_GetInt ( json, "moveFromInventoryType", moveFromInventoryType ) ;
		JSON_GetInt ( json, "moveToInventoryType", moveToInventoryType ) ;
	
		if ( moveFromInventoryType == moveToInventoryType )
		{
			switch ( moveFromInventoryType )
			{
				case 0: // inventory
				{
					dragged_player_inventory ( playerid, moveFromIndex, moveToIndex ) ;
				}
				case 1: // accessories
				{

				}
				case 2: // warehouse
				{
				
				}
				case 3: // trader
				{

				}
				case 4: // receiver
				{

				}
			}
		}
		else
		{
			switch ( moveToInventoryType )
			{
				case 0: // inventory
				{
					trade_rielt [ playerid ] [ trade_accept ] = false ;
						
					new targetid = trade_rielt [ playerid ] [ trade_id ] ;
					trade_update_info ( playerid ) ;
					trade_update_info ( targetid ) ;

					dragged_trader_inventory ( playerid, moveFromIndex, moveToIndex, true ) ;

					SetReceiverItemID ( playerid, targetid, moveFromIndex ) ;
					SetTradeItemID ( playerid, moveFromIndex ) ;
				}
				case 1: // accessories
				{

				}
				case 2: // warehouse
				{
				
				}
				case 3: // trader
				{
					if ( item_blocked ( playerid, GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ), 0, moveFromIndex ) )
					{
						send_check_cinfo ( playerid, "Выбраный предмет нельзя передавать!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					trade_rielt [ playerid ] [ trade_accept ] = false ;
					
					new targetid = trade_rielt [ playerid ] [ trade_id ] ;
					trade_update_info ( playerid ) ;
					trade_update_info ( targetid ) ;

					dragged_trader_inventory ( playerid, moveFromIndex, moveToIndex, false ) ;

					SetReceiverItemID ( playerid, targetid, moveToIndex ) ;
					SetTradeItemID ( playerid, moveToIndex ) ;
				}
				case 4: // receiver
				{
					
				}
			}
		}
	}
	else if ( actionId == 1 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new itemIndex, itemCount, inventoryType, action, _item ;
		JSON_GetInt ( json, "itemIndex", itemIndex ) ;
		JSON_GetInt ( json, "itemCount", itemCount ) ;
		JSON_GetInt ( json, "inventoryType", inventoryType ) ;
		JSON_GetInt ( json, "action", action ) ;

		if ( inventoryType == 0 ) // инвентарь
		{
			_item = GetUsersInventory ( playerid, INV_ITEM, itemIndex ) ;
			if ( action == 0 ) // использовать
			{
				if ( GetAccessoriesItem ( _item ) )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия нужно надеть аксессуар!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _item == 2250 )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия с номерами отправляйтесь в полицейский участок!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( item_blocked ( playerid, _item ) )
				{

				}
				else prise_open ( playerid, itemIndex ) ;
			}
			else if ( action == 1 ) // передать
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 2 ) // выкинуть
			{
				if ( item_blocked ( playerid, _item ) )
				{
					send_check_cinfo ( playerid, "Вы не можете выкинуть выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == RENDER_TYPE_PLATE )
				{
					static const _str [ ] = "DELETE FROM `licence_plate` WHERE `licence_plate_char_id` = '%d' AND `id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;
					mysql_tquery ( sql_connection, query_string ) ;
				}

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_ACCESSORIES )
					dropped_accessories ( GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_SKINS )
					dropped_skins ( GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

				clear_inventory_slot ( playerid, GetUsersInventory ( playerid, INV_ITEM, itemIndex ), itemCount, itemIndex ) ;
			}
			else if ( action == 3 ) // разделить
			{
				if ( item_blocked ( playerid, _item ) )
				{
					send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				new _slot = GetInventoryFreeSlot ( playerid, SUB_INVENTORY ) ;
				if ( _slot == -1 )
				{
					send_check_cinfo ( playerid, "У Вас нет свободного места в инвентаре.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				clear_inventory_slot ( 
					playerid, 
					GetUsersInventory ( playerid, INV_ITEM, itemIndex ),
					itemCount,
					itemIndex
				) ;
				give_inventory_slot (
					playerid,
					GetUsersInventory ( playerid, INV_ITEM, itemIndex ),
					itemCount,
					0,
					"",
					"",
					NUMBERPLATE_TYPE_NONE,
					GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ),
					_slot,
					GetElapsedTime ( GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ), gettime ( ), CONVERT_TIME_TO_DAYS )
				) ;
			}
			else if ( action == 4 ) // информация
			{
				GetInventoryInfo ( playerid, SUB_INVENTORY, itemIndex ) ;
			}
		}
		else if ( inventoryType == 1 ) // аксессуары
		{
			if ( action == 0 ) // использовать
			{

			}
			else if ( action == 1 ) // передать
			{

			}
			else if ( action == 2 ) // выкинуть
			{

			}
			else if ( action == 3 ) // разделить
			{
				
			}
		}
		else if ( inventoryType == 2 ) // склады
		{
			if ( action == 0 ) // информация
			{

			}
			else if ( action == 1 ) // отмена
			{

			}
			else if ( action == 2 ) // выкинуть
			{
				
			}
			else if ( action == 3 ) // разделить
			{
				
			}
		}
		else if ( inventoryType == 2 ) // trader
		{
			if ( action == 0 ) // информация
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 1 ) // отмена
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 2 ) // выкинуть
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 3 ) // разделить
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 4 ) // информация
			{
				GetInventoryInfo ( playerid, SUB_INV_TRADE, itemIndex ) ;
			}
		}
		else if ( inventoryType == 2 ) // receiver
		{
			if ( action == 0 ) // информация
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 1 ) // отмена
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 2 ) // выкинуть
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 3 ) // разделить
			{
				send_check_cinfo ( playerid, "Недоступно в режиме обмена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 4 ) // информация
			{
				GetInventoryInfo ( playerid, SUB_INV_TRADE_RECEIVER, itemIndex ) ;
			}
		}
	}
	else if ( actionId == 3 ) // destroy
	{
		new _targetid = trade_rielt [ playerid ] [ trade_id ] ;
		
		clear_player_trade ( playerid ) ;
		return_player_inventory ( playerid ) ;

		onServerDestroy ( playerid, UI_TRADE ) ;
		
		clear_player_trade ( _targetid ) ;
		return_player_inventory ( _targetid ) ;

		onServerDestroy ( _targetid, UI_TRADE ) ;
	}
	else if ( actionId == 5 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new itemIndex, inventoryType ;
		JSON_GetInt ( json, "itemIndex", itemIndex ) ;
		JSON_GetInt ( json, "inventoryType", inventoryType ) ;

		if ( inventoryType == 0 )
		{
			new _i_item = GetUsersInventory ( playerid, INV_ITEM, itemIndex ), 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ),
				_count = GetUsersInventory ( playerid, INV_ITEM_COUNT, itemIndex ),
				date_string [ 64 ] ;
					
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
			item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ) ) ;

			onServerSendData ( playerid, UI_TRADE, 12, global_string ) ;
		}
		else if ( inventoryType == 1 )
		{

		}
		else if ( inventoryType == 2 )
		{
			
		}
		else if ( inventoryType == 3 )
		{
			new _i_item = GetTradeInventory ( playerid, INV_ITEM, itemIndex ), 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = GetTradeInventory ( playerid, INV_ITEM_DATE, itemIndex ),
				_count = GetTradeInventory ( playerid, INV_ITEM_COUNT, itemIndex ),
				date_string [ 64 ] ;
					
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
				item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ) ) ;

			onServerSendData ( playerid, UI_TRADE, 12, global_string ) ;
		}
		else if ( inventoryType == 4 )
		{
			new _targetid = trade_rielt [ playerid ] [ trade_id ], 
				_i_item = GetTradeInventory ( _targetid, INV_ITEM, itemIndex ), 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = GetTradeInventory ( _targetid, INV_ITEM_DATE, itemIndex ),
				_count = GetTradeInventory ( _targetid, INV_ITEM_COUNT, itemIndex ),
				date_string [ 64 ] ;
					
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
			item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ) ) ;

			onServerSendData ( playerid, UI_TRADE, 12, global_string ) ;
		}
	}
	else if ( actionId == 6 ) // accept
	{
		if ( trade_rielt [ playerid ] [ trade_accept ] ) trade_rielt [ playerid ] [ trade_accept ] = false ;
		else trade_rielt [ playerid ] [ trade_accept ] = true ;

		new _targetid = trade_rielt [ playerid ] [ trade_id ] ;
		trade_update_info ( playerid ) ;
		trade_update_info ( _targetid ) ;

		if ( trade_rielt [ playerid ] [ trade_accept ] && trade_rielt [ _targetid ] [ trade_accept ] )
			accept_trade ( playerid, _targetid ) ;
	}
	else if ( actionId == 7 ) // money
	{
		trade_rielt [ playerid ] [ trade_accept ] = false ;
		
		new _targetid = trade_rielt [ playerid ] [ trade_id ] ;
		trade_update_info ( playerid ) ;
		trade_update_info ( _targetid ) ;

		show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}

stock trade_update_info ( playerid )
{
	new _traderid = trade_rielt [ playerid ] [ trade_id ], _str [ 32 ], _str2 [ 32 ] ;
	if ( ! trade_rielt [ playerid ] [ trade_accept ] )
		format ( _str, sizeof _str, "выбирает предметы для сделки" ) ;
	else
		format ( _str, sizeof _str, "ожидает подтверждения сделки игроком" ) ;

	if ( ! trade_rielt [ _traderid ] [ trade_accept ] )
		format ( _str2, sizeof _str2, "выбирает предметы для сделки" ) ;
	else
		format ( _str2, sizeof _str2, "ожидает подтверждения сделки игроком" ) ;

	new Node: node = JSON_Object (
		"traderName",				JSON_String ( p_info [ playerid ] [ name ] ),
		"traderDescription",		JSON_String ( _str ),
		"traderMoney",				JSON_Int ( trade_rielt [ playerid ] [ trade_money ] ),
		"traderAccept",				JSON_Bool ( trade_rielt [ playerid ] [ trade_accept ] ),

		"receiverName",				JSON_String ( p_info [ _traderid ] [ name ] ),
		"receiverDescription",		JSON_String ( _str2 ),
		"receiverMoney",			JSON_Int ( trade_rielt [ _traderid ] [ trade_money ] ),
		"receiverAccept",			JSON_Bool ( trade_rielt [ _traderid ] [ trade_accept ] )
	) ;

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TRADE, 17, global_string ) ;
	return 1 ;
}

stock dragged_trader_inventory ( playerid, moveFromIndex, moveToIndex, bool: toInventory )
{
	if ( moveToIndex == -1 ) return 1 ;

	if ( toInventory )
	{
		new draggedItem = GetTradeInventory ( playerid, INV_ITEM, moveFromIndex ),
			draggedItemCount = GetTradeInventory ( playerid, INV_ITEM_COUNT, moveFromIndex ),
			USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;

		moveInventory = TransferInventoryStructure ( playerid, SUB_INV_TRADE, moveFromIndex ) ;
		new _return = giveInventorySlot ( playerid, moveInventory, moveToIndex ) ;
		if ( _return == -1 )
		{
			send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s убрал с обмена %s (%d шт)",
		p_info [ playerid ] [ name ], 
		item_name ( draggedItem ),
		draggedItemCount ) ;
		WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;

		clear_trade_slot ( playerid, draggedItem, draggedItemCount, moveFromIndex ) ;
	}
	else
	{
		new draggedItem = GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ),
			draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, moveFromIndex ),
			USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;

		moveInventory = TransferInventoryStructure ( playerid, SUB_INVENTORY, moveFromIndex ) ;
		new _return = give_trade_slot ( playerid, moveToIndex, moveInventory ) ;
		if ( _return == -1 )
		{
			send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s добавил в обмен %s (%d шт)",
		p_info [ playerid ] [ name ], 
		item_name ( draggedItem ),
		draggedItemCount ) ;
		WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;

		clear_inventory_slot ( playerid, draggedItem, draggedItemCount, moveFromIndex ) ;
	}
	return 1 ;
}

stock clear_trade_slot ( playerid, modelId, modelCount, slotId )
{
	ClearInventorySlot ( playerid, SUB_INV_TRADE, slotId, modelId, modelCount ) ;
	return 1 ;
}

stock give_trade ( playerid, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	new slotId = GiveInventory ( playerid, SUB_INV_TRADE, itemStruct ) ;
	return slotId ;
}

stock give_trade_slot ( playerid, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	GiveInventorySlot ( playerid, slotId, SUB_INV_TRADE, itemStruct ) ;
	return slotId ;
}