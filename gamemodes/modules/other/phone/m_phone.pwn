stock clear_player_phone ( playerid )
{
    g_phone_call [ playerid ] = g_phone_call_default_values ;
	return true ;
}

stock startUserCalling ( playerid )
{
	new caller = g_phone_call [ playerid ] [ PC_INCOMING_PLAYER ] ;
	if ( caller != INVALID_PLAYER_ID )
	{
		new scm_string [ 27 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof ( scm_string ), "%s ответил(а) на звонок.", p_info [ playerid ] [ name ] ) ;
		SendClientMessage ( caller, col_yellow, scm_string ) ;
		SendClientMessage ( caller, col_yellow, !"Для разговора используйте голосовой чат или обычный чат." ) ;

		onServerSendData ( caller, UI_CALL_SCREEN, 1, "PROCESS" ) ;
		g_phone_call [ caller ] [ PC_STATUS ] = true ;
	}

	SendClientMessage ( playerid, col_yellow, !"Для разговора используйте голосовой чат или обычный чат." ) ;
	onServerSendData ( playerid, UI_CALL_SCREEN, 1, "PROCESS" ) ;

	SetPlayerSpecialAction ( playerid, SPECIAL_ACTION_USECELLPHONE ) ;
	SetPlayerAttachedObject ( playerid, 2, p_info [ playerid ] [ model_phone ], 6, 0.059000, 0.014000, -0.008999, 95.100051, -179.800033, 46.500030, 1.000000, 1.000000, 1.000000);

    switch ( p_info [ playerid ] [ sound_call ] )
	{
		case 1062: PlayerPlaySound ( playerid, 1063, 0, 0, 0 ) ;
		case 1068: PlayerPlaySound ( playerid, 1069, 0, 0, 0 ) ;
		case 1076: PlayerPlaySound ( playerid, 1077, 0, 0, 0 ) ;
		case 1097: PlayerPlaySound ( playerid, 1098, 0, 0, 0 ) ;
		case 1183: PlayerPlaySound ( playerid, 1184, 0, 0, 0 ) ;
		case 1185: PlayerPlaySound ( playerid, 1186, 0, 0, 0 ) ;
		case 1187: PlayerPlaySound ( playerid, 1188, 0, 0, 0 ) ;
	}

	g_phone_call [ playerid ] [ PC_STATUS ] = true ;

	new free_phone_voice_idx = Iter_Free(IPhoneCallVoice);
	if ( free_phone_voice_idx == -1 )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Голосовой чат будет недоступен по техническим причинам" ) ;
		SendClientMessage ( caller, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Голосовой чат будет недоступен по техническим причинам" ) ;
	}
	else
	{
		Iter_Add(IPhoneCallVoice, free_phone_voice_idx);

		g_phone_call [ caller ] [ PC_VOICE_CHAT ] = free_phone_voice_idx ;
		g_phone_call [ playerid ] [ PC_VOICE_CHAT ] = free_phone_voice_idx ;

		g_phone_call_stream [ free_phone_voice_idx ] = SvCreateGStream ( 0xffff0000, "Calling" ) ;
		SvAttachListenerToStream ( g_phone_call_stream [ free_phone_voice_idx ], caller ) ;
		SvAttachListenerToStream ( g_phone_call_stream [ free_phone_voice_idx ], playerid ) ;
	}
	return true ;
}

stock stopUserCalling ( playerid )
{
	new caller = g_phone_call [ playerid ] [ PC_INCOMING_PLAYER ] ;
	new call_to = g_phone_call [ playerid ] [ PC_OUTCOMING_PLAYER ] ;

	if ( call_to != INVALID_PLAYER_ID )
	{
		if ( g_phone_call [ call_to ] [ PC_INCOMING_PLAYER ] == playerid )
		{
			SendClientMessage ( call_to, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Абонент повесил(а) трубку." ) ;
			onServerDestroy ( call_to, UI_CALL_SCREEN ) ;

			SetPlayerSpecialAction ( call_to, SPECIAL_ACTION_STOPUSECELLPHONE ) ;
			RemovePlayerAttachedObject ( call_to, 2 ) ;

            switch ( p_info [ call_to ] [ sound_call ] )
		 	{
		  		case 1062: PlayerPlaySound ( call_to, 1063, 0, 0, 0 ) ;
				case 1068: PlayerPlaySound ( call_to, 1069, 0, 0, 0 ) ;
				case 1076: PlayerPlaySound ( call_to, 1077, 0, 0, 0 ) ;
				case 1097: PlayerPlaySound ( call_to, 1098, 0, 0, 0 ) ;
				case 1183: PlayerPlaySound ( call_to, 1184, 0, 0, 0 ) ;
				case 1185: PlayerPlaySound ( call_to, 1186, 0, 0, 0 ) ;
				case 1187: PlayerPlaySound ( call_to, 1188, 0, 0, 0 ) ;
			}
		}

		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы закончили текущий разговор." ) ;
		onServerDestroy ( playerid, UI_CALL_SCREEN ) ;

		SetPlayerSpecialAction ( playerid, SPECIAL_ACTION_STOPUSECELLPHONE ) ;
		RemovePlayerAttachedObject ( playerid, 2 ) ;

		new idx = g_phone_call [ playerid ] [ PC_VOICE_CHAT ] ;
		if ( idx < 0 ) idx = g_phone_call [ call_to ] [ PC_VOICE_CHAT ] ;

		if ( idx != -1 )
		{
			if ( g_phone_call_stream [ idx ] )
			{
				SvDetachListenerFromStream ( g_phone_call_stream [ idx ], call_to ) ;
				SvDetachListenerFromStream ( g_phone_call_stream [ idx ], playerid ) ;

				SvDeleteStream ( g_phone_call_stream [ idx ] ) ;
				g_phone_call_stream [ idx ] = SV_NULL ;

				Iter_Remove(IPhoneCallVoice, idx);
			}
		}
	}
	else if ( caller != INVALID_PLAYER_ID )
	{
		if ( g_phone_call [ caller ] [ PC_OUTCOMING_PLAYER ] == playerid )
		{
			SendClientMessage ( caller, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Абонент повесил(а) трубку." ) ;
			onServerDestroy ( caller, UI_CALL_SCREEN ) ;

			SetPlayerSpecialAction ( caller, SPECIAL_ACTION_STOPUSECELLPHONE ) ;
			RemovePlayerAttachedObject ( caller, 2 ) ;

            switch ( p_info [ caller ] [ sound_call ] )
		 	{
		  		case 1062: PlayerPlaySound ( caller, 1063, 0, 0, 0 ) ;
				case 1068: PlayerPlaySound ( caller, 1069, 0, 0, 0 ) ;
				case 1076: PlayerPlaySound ( caller, 1077, 0, 0, 0 ) ;
				case 1097: PlayerPlaySound ( caller, 1098, 0, 0, 0 ) ;
				case 1183: PlayerPlaySound ( caller, 1184, 0, 0, 0 ) ;
				case 1185: PlayerPlaySound ( caller, 1186, 0, 0, 0 ) ;
				case 1187: PlayerPlaySound ( caller, 1188, 0, 0, 0 ) ;
			}
		}

		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы закончили текущий разговор." ) ;
		onServerDestroy ( playerid, UI_CALL_SCREEN ) ;

		SetPlayerSpecialAction ( playerid, SPECIAL_ACTION_STOPUSECELLPHONE ) ;
		RemovePlayerAttachedObject ( playerid, 2 ) ;

		new idx = g_phone_call [ playerid ] [ PC_VOICE_CHAT ] ;
		if ( idx < 0 ) idx = g_phone_call [ caller ] [ PC_VOICE_CHAT ] ;

		if ( idx != -1 )
		{
			if ( g_phone_call_stream [ idx ] )
			{
				SvDetachListenerFromStream ( g_phone_call_stream[idx], caller ) ;
				SvDetachListenerFromStream ( g_phone_call_stream[idx], playerid ) ;

				SvDeleteStream ( g_phone_call_stream [ idx ] ) ;
				g_phone_call_stream [ idx ] = SV_NULL ;

				Iter_Remove(IPhoneCallVoice, idx);
			}
		}
	}

	if ( call_to != INVALID_PLAYER_ID ) g_phone_call [ call_to ] = g_phone_call_default_values ;
	if ( caller != INVALID_PLAYER_ID ) g_phone_call [ caller ] = g_phone_call_default_values ;
	g_phone_call [ playerid ] = g_phone_call_default_values ;
	return true ;
}

stock show_window_call ( playerid, targetid, _status [ ] )
{
	#if defined debug_packet
		printf ( "[show_window_call] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Object (
		"skinId",		JSON_Int ( getNewSkinModel ( playerid ) ),
		"status",		JSON_String ( _status ),
		"nickname",		JSON_String ( p_info [ playerid ] [ name ] )
	) ;

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( targetid, UI_CALL_SCREEN, 0, global_string ) ;

	onServerSendData ( targetid, UI_CALL_SCREEN, 1, _status ) ;
	return 1 ;
}

stock show_packet_call ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 ) // accept call
	{
		if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы в наручниках." ) ;
		if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы связаны." ) ;
		if ( is_ether { playerid } != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете говорить по телефону во время эфира." ) ;

		startUserCalling ( playerid ) ;
	}
	else if ( actionId == 1 ) // decline call
	{
		stopUserCalling ( playerid ) ;
	}
	return 1 ;
}

stock is_player_bl ( playerid, targetid, type_cheching, _message [ ] )
{
	if ( type_cheching == 1 )
	{
		new PlayerNumber = p_info [ playerid ] [ number ],
			GivePlayerNumber = p_info [ targetid ] [ number ],
			scm_string [ 144 ] ;

		if ( player_device { targetid } == 2 )
		{
			show_window_call ( playerid, targetid, "INCOMING" ) ;
		}
		else
		{
		    format ( scm_string, sizeof scm_string, "Вам звонит %s [т. %d]. Нажмите '{"#cGN"}Y{"#cWH"}' чтобы ответить или '{"#cRD"}N{"#cWH"}' чтобы сбросить.", p_info [ playerid ] [ name ], PlayerNumber ) ;
			SendClientMessage ( targetid, col_white, scm_string ) ;
		}

		if ( player_device { playerid } == 2 )
		{
			show_window_call ( targetid, playerid, "OUTGOING" ) ;
		}
		else
		{
			format ( scm_string, sizeof scm_string, "Вы позвонили игроку %s [т. %d]. Нажмите '{"#cRD"}N{"#cWH"}' чтобы сбросить.", p_info [ targetid ] [ name ], GivePlayerNumber ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
		}

		SetPlayerSpecialAction ( playerid, SPECIAL_ACTION_USECELLPHONE ) ;
		SetPlayerAttachedObject ( playerid, 2, p_info [ playerid ] [ model_phone ], 6, 0.059000, 0.014000, -0.008999, 95.100051, -179.800033, 46.500030, 1.000000, 1.000000, 1.000000 ) ;
		if ( p_info [ targetid ] [ sound_call ] != -1 ) PlayerPlaySound ( targetid, p_info [ targetid ] [ sound_call ], 0, 0, 0 ) ;

		g_phone_call [ playerid ] [ PC_OUTCOMING_PLAYER ] = targetid ;
		g_phone_call [ targetid ] [ PC_INCOMING_PLAYER ] = playerid ;

	    new Float: X = p_t_info [ targetid ] [ p_pos ] [ 0 ],
			Float: Y = p_t_info [ targetid ] [ p_pos ] [ 1 ],
			Float: Z = p_t_info [ targetid ] [ p_pos ] [ 2 ] ;
		format ( scm_string, sizeof scm_string, "{"#cBInfo"}* {"#cGRInfo"}У %s звонит телефон.", p_info [ targetid ] [ name ] ) ;
		foreach(new in: streamed_players[targetid])
		{
			if ( IsPlayerInRangeOfPoint ( in, 5.0, X, Y, Z ) )
			{
				if ( targetid == in ) continue ;
				SendClientMessage ( in, col_gray, scm_string ) ;
			}
		}
		SetPlayerChatBubble ( targetid, "Звонит телефон", col_light_purple, 13, 5000 ) ;
	}
	else if ( type_cheching == 2 )
	{
		new PlayerNumber = p_info [ playerid ] [ number ],
			GivePlayerNumber = p_info [ targetid ] [ number ],
			scm_string [ 144 ] ;

		format ( scm_string, sizeof scm_string, "SMS: %s. Отправитель: %s [т. %d]", _message, p_info [ playerid ] [ name ], PlayerNumber ) ;
		SendClientMessage ( targetid, col_yellow, scm_string ) ;

		format ( scm_string, sizeof scm_string, "SMS: %s. Получатель: %s [т. %d]", _message, p_info [ targetid ] [ name ], GivePlayerNumber ) ;
		SendClientMessage ( playerid, col_yellow, scm_string ) ;

		if ( p_info [ targetid ] [ sound_sms ] != -1 ) PlayerPlaySound ( targetid, p_info [ targetid ] [ sound_sms ], 0, 0, 0 ) ;

		format ( scm_string, sizeof scm_string, "SMS %s(%d) для %s(%d): %s", p_info [ playerid ] [ name ], playerid, p_info [ targetid ] [ name ], targetid, _message ) ;
		foreach(new j: admin_players)
		{
			if ( big_ears { j } == 0 ) continue ;
			SendClientMessage ( j, col_yellow, scm_string ) ;
		}
		p_info [ playerid ] [ phone_balance ] -- ;
		SendMessengerMessage ( playerid, p_info [ targetid ] [ id ], _message ) ;
	}
	return 1 ;
}

CMD:phone ( playerid )
{
	if ( ! p_info [ playerid ] [ number ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас нет SIM-карты, приобретите её в 24/7." ) ;
	if ( player_device { playerid } == 2 ) show_tablet_init ( playerid ) ;
	else show_phone ( playerid ) ;
	return 1 ;
}

stock show_phone ( playerid )
{
	if ( g_phone_call [ playerid ] [ PC_ENABLED ] )
	{
    	show_dialog ( playerid, d_phone_main, DIALOG_STYLE_LIST, "{"#cBHD"}Телефон", "{"#cBL"}1.{"#cWH"} Список контактов\n{"#cBL"}2.{"#cWH"} Добавить контакт\n{"#cBL"}3.{"#cWH"} Заказать услуги\n{"#cBL"}4.{"#cWH"} Звук СМС\n{"#cBL"}5.{"#cWH"} Мелодия звонка\n{"#cBL"}6.{"#cWH"} Выключить телефон", "Выбрать", "Назад" ) ;
	}
	else
	{
		show_dialog ( playerid, d_phone_main, DIALOG_STYLE_LIST, "{"#cBHD"}Телефон", "{"#cBL"}1.{"#cWH"} Звук СМС\n{"#cBL"}2.{"#cWH"} Мелодия звонка\n{"#cBL"}3.{"#cWH"} Включить телефон", "Выбрать", "Назад" ) ;
	}
	return 1 ;
}

CMD:call ( playerid, params [ ] )
{
	if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы в наручниках." ) ;
	if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы связаны." ) ;
	if ( ! p_info [ playerid ] [ number ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас нет телефона. Приобретите его в магазине 24/7 (/gps - Бизнесы)." ) ;
	if ( ! g_phone_call [ playerid ] [ PC_ENABLED ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас отключен мобильный телефон. Используйте /togphone для включения." ) ;
	if ( g_phone_call [ playerid ] [ PC_STATUS ] || is_ether_calling { playerid } != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Закончите текущий разговор." ) ;
	if ( p_info [ playerid ] [ phone_balance ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Баланс вашего телефона равен нулю. Пополните счёт в банке / банкомате (/gps)." ) ;
	if ( is_ether { playerid } != 0 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете говорить по телефону во время эфира." ) ;
	if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /call [номер]" ) ;
	if ( p_info [ playerid ] [ number ] == params [ 0 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете звонить самому себе." ) ;

	if ( params [ 0 ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный номер не существует." ) ;

	if ( params [ 0 ] == 911 )
	{
		show_service ( playerid ) ;
		return 1 ;
	}
	if ( params [ 0 ] == f_info [ 25 ] [ f_materials ] && cas_price [ 0 ] != 0 )
	{
		new scm_string [ 98 ] ;
		format ( scm_string, sizeof scm_string, "{ffffff}Стоимость звонка: %d"valute_title".\n\n{"#cGRDialog"}* Вы действительно хотите позвонить?",
		cas_price [ 0 ] ) ;
		show_dialog ( playerid, d_ether_calling, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Звонок на прямой эфир", scm_string, "Да", "Нет" ) ;
		is_ether_calling { playerid } = 26 ;
		return 1 ;
	}
	if ( params [ 0 ] == f_info [ 26 ] [ f_materials ] && cas_price [ 1 ] != 0 )
	{
		new scm_string [ 98 ] ;
		format ( scm_string, sizeof scm_string, "{ffffff}Стоимость звонка: %d"valute_title".\n\n{"#cGRDialog"}* Вы действительно хотите позвонить?",
		cas_price [ 1 ] ) ;
		show_dialog ( playerid, d_ether_calling, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Звонок на прямой эфир",scm_string, "Да", "Нет" ) ;
		is_ether_calling { playerid } = 27 ;
		return 1 ;
	}
	if ( params [ 0 ] == f_info [ 27 ] [ f_materials ] && cas_price [ 2 ] != 0 )
	{
		new scm_string [ 98 ] ;
		format ( scm_string, sizeof scm_string, "{ffffff}Стоимость звонка: %d"valute_title".\n\n{"#cGRDialog"}* Вы действительно хотите позвонить?",
		cas_price [ 2 ] ) ;
		show_dialog ( playerid, d_ether_calling, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Звонок на прямой эфир", scm_string, "Да", "Нет" ) ;
		is_ether_calling { playerid } = 28 ;
		return 1 ;
	}

	foreach(new i: logged_players)
	{
		if ( p_info [ i ] [ number ] == params [ 0 ] )
		{
			if ( ! g_phone_call [ i ] [ PC_ENABLED ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока отключен мобильный телефон." ) ;
			if ( g_phone_call [ i ] [ PC_STATUS ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Абонент в данный момент уже с кем-то разговаривает." ) ;

			for ( new q = 0 ; q < MAX_CONTACTS ; q ++ )
			{
		    	if ( users_contacts [ i ] [ q ] [ uc_inc ] != p_info [ playerid ] [ id ] ) continue ;
				if ( users_contacts [ i ] [ q ] [ uc_bl ] == 1 )
				{
			    	SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь в чёрном списке у данного игрока." ) ;
			    	return 1 ;
				}
				break ;
			}

			is_player_bl ( playerid, i, 1, "none" ) ;
			return 1 ;
		}
	}
	return 1 ;
}

CMD:sms ( playerid, params [ ] )
{
	if ( p_info [ playerid ] [ mute ] )
	{
		new _t_string [ 38 ] ;
		format ( _t_string, sizeof ( _t_string ),"У Вас бан чата | %d секунд(ы)", p_info [ playerid ] [ mute ] ) ;
		SendClientMessage ( playerid, col_light_red, _t_string ) ;
		return false ;
	}
	if ( sms_cooldown [ playerid ] > gettime ( ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сообщение можно писать только раз в 10 секунд." ) ;
	if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы в наручниках." ) ;
	if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы связаны." ) ;
	if ( ! p_info [ playerid ] [ number ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас нет телефона. Приобретите его в магазине 24/7 (/gps - Бизнесы)." ) ;
	if ( ! g_phone_call [ playerid ] [ PC_ENABLED ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас отключен мобильный телефон. Используйте /togphone для включения." ) ;
	if ( p_info [ playerid ] [ phone_balance ] < 5 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас нет средств для отправки SMS. Пополните счёт в банке / банкомате (/gps)." ) ;

	new target_number, _sms_tr [ 128 ] ;
	if ( sscanf ( params, "ds[128]", target_number, _sms_tr ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /sms [номер] [текст]" ) ;
	if ( target_number == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный номер не существует." ) ;
	if ( strlen ( _sms_tr ) < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы ничего не ввели в текст сообщения." ) ;
	if ( check_advertise ( playerid, _sms_tr, report_type_sms ) ) return 1 ;

	sms_cooldown [ playerid ] = gettime ( ) + 10 ;

	if ( target_number == f_info [ 25 ] [ f_materials ] && cas_price [ 0 ] != 0 )
	{
		if ( cas_price [ 0 ] > p_info [ playerid ] [ phone_balance ] )
		{
			is_ether_calling { playerid } = 0 ;
			return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На вашем счету недостаточно средств." ) ;
		}

		SendClientMessage ( playerid, 0xCCCCCCFF, !"Вы успешно отправили SMS в эфир." ) ;
		new _text_string [ 144 ] ;
		format ( _text_string, sizeof ( _text_string ),"* [SMS в эфир] %s[%d]: %s", p_info [ playerid ] [ name ], playerid, _sms_tr ) ;
		foreach(new i: logged_players) if ( p_info [ i ] [ member ] == 26 || big_ears { i } == 1 ) SendClientMessage ( i, col_lblue, _text_string ) ;

		is_ether_calling { playerid } = 26 ;
		return 1 ;
	}
	if ( target_number == f_info [ 26 ] [ f_materials ] && cas_price [ 1 ] != 0 )
	{
		if ( cas_price [ 1 ] > p_info [ playerid ] [ phone_balance ] )
		{
			is_ether_calling { playerid } = 0 ;
			return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На вашем счету недостаточно средств." ) ;
		}

		SendClientMessage ( playerid, 0xCCCCCCFF, !"Вы успешно отправили SMS в эфир." ) ;
		new _text_string [ 144 ] ;
		format ( _text_string, sizeof ( _text_string ),"* [SMS в эфир] %s[%d]: %s", p_info [ playerid ] [ name ], playerid, _sms_tr ) ;
		foreach(new i: logged_players) if ( p_info [ i ] [ member ] == 27 || big_ears { i } == 1 ) SendClientMessage ( i, col_lblue, _text_string ) ;

		is_ether_calling { playerid } = 27 ;
		return 1 ;
	}
	if ( target_number == f_info [ 27 ] [ f_materials ] && cas_price [ 2 ] != 0 )
	{
		if ( cas_price [ 2 ] > p_info [ playerid ] [ phone_balance ] )
		{
			is_ether_calling { playerid } = 0 ;
			return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На вашем счету недостаточно средств." ) ;
		}

		SendClientMessage ( playerid, 0xCCCCCCFF, !"Вы успешно отправили SMS в эфир." ) ;
		new _text_string [ 144 ] ;
		format ( _text_string, sizeof ( _text_string ),"* [SMS в эфир] %s[%d]: %s", p_info [ playerid ] [ name ], playerid, _sms_tr ) ;
		foreach(new i: logged_players) if ( p_info [ i ] [ member ] == 28 || big_ears { i } == 1 ) SendClientMessage ( i, col_lblue, _text_string ) ;

		is_ether_calling { playerid } = 28 ;
		return 1 ;
	}

	foreach(new i: logged_players)
	{
		if ( p_info [ i ] [ number ] == target_number )
		{
			if ( i == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя отправить SMS самому себе." ) ;

			if ( ! g_phone_call [ i ] [ PC_ENABLED ] )
			{
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока отключен мобильный телефон." ) ;
			}
			
			for ( new q = 0 ; q < MAX_CONTACTS ; q ++ )
			{
		    	if ( users_contacts [ i ] [ q ] [ uc_inc ] != p_info [ playerid ] [ id ] ) continue ;
				if ( users_contacts [ i ] [ q ] [ uc_bl ] == 1 )
				{
			    	SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь в чёрном списке у данного игрока." ) ;
			    	return 1 ;
				}
				break ;
			}
			
			p_info [ playerid ] [ phone_balance ] -= 5 ;
			is_player_bl ( playerid, i, 2, _sms_tr ) ;
			return 1 ;
		}
	}
	SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В настоящий момент абонент недоступен!" ) ;
	return 1 ;
}