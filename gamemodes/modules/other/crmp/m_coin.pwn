new Float: coin_position [ 3 ] [ 3 ] =
{
	{ 793.4786, -799.2199, 1798.0305 },
	{ 793.4795, -795.5845, 1798.0234 },
	{ 793.4821, -791.9165, 1798.0234 }
} ;
new coin_area [ sizeof coin_position ] ;

stock coin_businesses_loading ( )
{
	for ( new i = 0 ; i < sizeof coin_position ; i ++ )
	{
		CreateDynamic3DTextLabel ( "** Орёл и решка **\n{"#cGR3D"}Подойдите для взаимодействия", col_header_3d, coin_position [ i ] [ 0 ], coin_position [ i ] [ 1 ], coin_position [ i ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1 ) ;

        coin_area [ i ] = CreateDynamicSphere ( coin_position [ i ] [ 0 ], coin_position [ i ] [ 1 ], coin_position [ i ] [ 2 ], 5.0, -1, -1, -1 ) ;
		area_info [ coin_area [ i ] ] [ a_type ] = area_type_coin ;
	}
	return 1 ;
}

stock coin_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_coin:
		{
			if ( player_device { playerid } == 2 )
				send_check_cinfo ( playerid, "Орёл и решка", 1, -1, CINFO_COIN_ID, PICTURE_INFO_SUCESS, "Играть", "" ) ;
			
			else
			{
				if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
				if ( p_t_info [ playerid ] [ p_dialog ] != -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас открыт диалог! Вы не можете сыграть." ) ;
				
				global_string [ 0 ] = EOS ;

				new TotalPla ;
				foreach(new i: streamed_players[playerid])
				{
					set_player_listitem_values ( playerid, TotalPla, i ) ;

					TotalPla ++ ;
					if ( TotalPla == 20 ) break ;

					format( global_string, sizeof global_string, "%s{"#cWH"}%s[%d]\n", global_string, p_info [ i ] [ name ], i ) ;
				}
				
				if ( TotalPla == 0 )
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Орёл и решка", "{"#cWH"}Нет поблизости игроков, с которыми можно сыграть!", "Принять", "" ) ;

				else
				    show_dialog ( playerid, d_coin, DIALOG_STYLE_LIST, "{"#cBHD"}Орёл и решка", global_string, "Выбрать", "Назад" ) ;
				return 1 ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock coin_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_coin:
		{
		    clear_check_info ( playerid, CINFO_COIN_ID ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock coin_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_coin:
		{
			if ( ! response ) return 1 ;
			
			new targetid = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( ! IsPlayerConnected ( targetid ) || targetid == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ), clear_sell_params ( targetid, playerid ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ), clear_sell_params ( targetid, playerid ) ;
			
			buyer_id [ playerid ] = targetid ;
			
			show_dialog ( playerid, d_coin_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Орёл и решка", "{"#cWH"}Укажите сумму ставки:", "Принять", "Закрыть" ) ;
			return 1 ;
		}
		case d_coin_bet:
		{
			if ( ! response ) return 1 ;
			
			new _value = strval ( inputtext ) ;
			if ( _value < 1000 || _value > 300_000_000 ) return show_dialog ( playerid, d_coin_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Орёл и решка", "{"#cRD"}Минимум 1.000"valute_title_", максимум 300.000.000"valute_title_"!\n\n{"#cWH"}Укажите сумму ставки:", "Принять", "Закрыть" ) ;
			if ( p_info [ playerid ] [ money ] < _value ) return show_dialog ( playerid, d_coin_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Орёл и решка", "{"#cRD"}У Вас недостаточно средств!\n\n{"#cWH"}Укажите сумму ставки:", "Принять", "Закрыть" ) ;
			
			new targetid = buyer_id [ playerid ] ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == playerid )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
				buyer_id [ playerid ] = INVALID_PLAYER_ID ;
				return 1 ;
			}
			if ( p_info [ targetid ] [ hour_played ] < THREE_HOUR_PLAYED )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не отыграл 3 часа." ) ;
				buyer_id [ playerid ] = INVALID_PLAYER_ID ;
				return 1 ;
			}
			if ( ! bad_dialog ( targetid ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно принять игрока в данный момент." ) ;
				buyer_id [ playerid ] = INVALID_PLAYER_ID ;
				return 1 ;
			}
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
				buyer_id [ playerid ] = INVALID_PLAYER_ID ;
				return 1 ;
			}
			
			buyer_id [ playerid ] = targetid ;
			seller_id [ targetid ] = playerid ;
			sell_price [ playerid ] = _value ;
			
			sell_time { playerid } =
			sell_time { targetid } = time_sell_null ;
			
			new dialog_string [ 156 ] ;
			format ( dialog_string, sizeof dialog_string, "{ffffff}%s[%d] предлагает Вам сыграть в {"#cBL"}орёл и решка\n{ffffff}Ставка: {"#cBL"}%s"valute_title_"",
			p_info [ playerid ] [ name ], playerid, GetPlayerCashValueToSmile ( _value ) ) ;
			show_dialog ( targetid, d_coin_accept, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Орёл и решка", dialog_string, "Купить", "Отмена" ) ;

			format ( dialog_string, sizeof ( dialog_string  ), "{"#cBInfo"}* {"#cWH"}Вы предложили {"#cBL"}%s{"#cWH"} сыграть в {"#cBL"}\"орёл и решка\"{ffffff} за {"#cBL"}%s"valute_title_"",
			p_info [ targetid ] [ name ], GetPlayerCashValueToSmile ( _value ) ) ;
			SendClientMessage ( playerid, col_white, dialog_string ) ;
			return 1 ;
		}
		case d_coin_accept:
		{
			if ( ! response )
			{
				if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) seller_id [ playerid ] = INVALID_PLAYER_ID ;
				else clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new targetid = seller_id [ playerid ] ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ), seller_id [ playerid ] = INVALID_PLAYER_ID ;
			
			new _sell_price = sell_price [ targetid ] ;
			if ( p_info [ playerid ] [ money ] < _sell_price )
			{
				clear_sell_params ( playerid, targetid ) ;
				SendClientMessage ( targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока недостаточно средств." ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств." ) ;
			}
			if ( p_info [ targetid ] [ money ] < _sell_price )
			{
				clear_sell_params ( playerid, targetid ) ;
				SendClientMessage ( targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока недостаточно средств." ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств." ) ;
			}
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ targetid ] [ p_pos ] [ 0 ], p_t_info [ targetid ] [ p_pos ] [ 1 ], p_t_info [ targetid ] [ p_pos ] [ 2 ] ) || p_t_info [ playerid ] [ p_data ] [ 1 ] != p_t_info [ targetid ] [ p_data ] [ 1 ] )
			{
				clear_sell_params ( playerid, targetid ) ;
				SendClientMessage ( targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы слишком далеко." ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы слишком далеко." ) ;
			}
			
			new win_prise = _sell_price, biz_pay = floatround ( ( _sell_price * 0.01 ) / 100 ), winner_id, query_string [ 63 + ( MAX_PLAYER_NAME * 3 ) ] ;
			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			if ( _b_id > 0 ) give_bmoney ( _b_id, biz_pay, 0 ) ;
			
			if ( random ( 2 ) == 1 ) 
			{
				winner_id = playerid ;
				give_money ( playerid, win_prise ) ;
				insert_money_log ( playerid, targetid, win_prise, "победа в орла и решку" ) ;
				
				give_money ( targetid, -_sell_price ) ;
				insert_money_log ( targetid, playerid, -_sell_price, "проигрыш в орла и решку" ) ;
			}
			else
			{
				winner_id = targetid ;
				give_money ( targetid, win_prise ) ;
				insert_money_log ( targetid, playerid, win_prise, "победа в орла и решку" ) ;
				
				give_money ( playerid, -_sell_price ) ;
				insert_money_log ( playerid, targetid, -_sell_price, "проигрыш в орла и решку" ) ;
			}

			format(query_string, sizeof ( query_string ), "%s сыграл(а) в \"орёл и решка\" с %s. Победитель: {3399FF}%s", p_info [ playerid ] [ name ], p_info [ targetid ] [ name ], p_info [ winner_id ] [ name ] ) ;
			send_world_message ( playerid, 25.0, query_string, col_lblue, col_lblue, col_lblue, false ) ;
			
			give_event_progress ( playerid, THE_COIN, 1 ) ;
			give_event_progress ( targetid, THE_COIN, 1 ) ;
			
			clear_sell_params ( playerid, targetid ) ;
			return 1 ;
		}
	}
	return 0 ;
}