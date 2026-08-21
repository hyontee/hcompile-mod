#define TABLET_BANK_COMMISION	10

stock handleTabletBank ( playerid, actionId, data [ ] )
{
	if ( actionId == BANK_APP ) // open bank
	{
		show_window_tablet_bank ( playerid ) ;

		new _str [ 64 ] ;
		format ( _str, sizeof _str, "Мы рады вас видеть,\n{C7ED70}%s", p_info [ playerid ] [ name ] ) ;
		new Node: node = JSON_Object (
			"name",						JSON_String ( _str ),
			"skinId",					JSON_Int ( getNewSkinModel ( playerid ) )
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, BANK_APP + 1, global_string ) ;
	}
	else if ( actionId == BANK_APP + 2 ) // logs
	{
		page_rows [ playerid ] = 100 ;

		new sql_string [ 144 ] ;
		format ( sql_string, sizeof sql_string, "SELECT * FROM deposit_logs WHERE dl_from = %d ORDER BY deposit_logs.dl_id DESC LIMIT %d OFFSET %d", 
			bank_info [ playerid ] [ bi_id ] [ strval ( data ) ], page_rows [ playerid ], page_rows [ playerid ] - 100 ) ;
		mysql_tquery ( sql_connection, sql_string, "showDepositLogs", "i", playerid ) ;
	}
	else if ( actionId == BANK_APP + 3 ) // transfer
	{
		new Node: json ;
        JSON_Parse ( data, json ) ;

        new idx, playerId, sum, commision ;
        JSON_GetInt ( json, "id", idx ) ;
        JSON_GetInt ( json, "playerId", playerId ) ;
        JSON_GetInt ( json, "sum", sum ) ;

		if ( sum < 100 || sum > max_money )
		{
			send_check_cinfo ( playerid, "Сумма перевода указана некорректно!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		commision = ( sum * TABLET_BANK_COMMISION ) / 100 ;
		if ( sum + commision > bank_info [ playerid ] [ bi_money ] [ idx ] )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 256, "\
				У Вас на выбранном счету недостаточно средств для перевода!\n\
				Сумма перевода: %s"valute_title_", Коммиссия: %s"valute_title_"\n\
				На счёте должно быть: %s"valute_title_"",
			GetPlayerCashValueToSmile ( sum ), GetPlayerCashValueToSmile ( commision ),
			GetPlayerCashValueToSmile ( sum + commision ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( playerId < MAX_PLAYERS + 1 )
		{
			if ( ! IsPlayerConnected ( ( playerId ) ) )
			{
				send_check_cinfo ( playerid, "Игрок не в сети!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( GetString ( p_t_info [ playerId ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
			{
				new scm_string [ 128 ] ;
				format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s[%d] перевод через мобильный банк %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ playerId ] [ name ], playerId ) ;
				foreach(new i: admin_players) SendClientMessage ( i, col_admin, scm_string ) ;

				send_check_cinfo ( playerid, "Невозможно перевести средства данному игроку!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new dialog_string [ 128 ] ;
			format ( dialog_string, sizeof dialog_string, "Перевод игроку %s", p_info [ playerId ] [ name ] ) ;
			insert_deposit_logs ( bank_info [ playerid ] [ bi_id ] [ idx ], p_info [ playerId ] [ id ], sum, dialog_string, BANK_TYPE_TRANSFER_TO ) ;

			bank_info [ playerid ] [ bi_money ] [ idx ] -= sum + commision ;

			dialog_string [ 0 ] = EOS ;
			format ( dialog_string, sizeof dialog_string, "\
				UPDATE `deposit_boxes` SET `db_money` = '%d' WHERE `db_id` = '%d' LIMIT 1",
				bank_info [ playerid ] [ bi_money ] [ idx ], bank_info [ playerid ] [ bi_id ] [ idx ] ) ;
			mysql_tquery ( sql_connection, dialog_string ) ;

			show_window_tablet_bank ( playerid ) ;

			dialog_string [ 0 ] = EOS ;
			format ( dialog_string, sizeof ( dialog_string ), "\
				INSERT INTO `deposit_transfer` \
				(`dl_owner`,`dl_money`) \
				VALUES \
				('%d','%d')",
				p_info [ playerId ] [ id ], sum ) ;
			mysql_tquery ( sql_connection, dialog_string ) ;
		
			format ( dialog_string, 144, "{"#cGInfo"}* {"#cWH"}Вам поступил банковский перевод на сумму {"#cGN"}%s"valute_title"{"#cWH"}.", GetPlayerCashValueToSmile ( sum ) ) ;
			SendClientMessage ( playerId, col_white, dialog_string ) ;
				
			SendClientMessage ( playerId, col_white, !"{"#cGInfo"}* {"#cWH"}Вам нужно получить перевод. Найдите в банке метку с текстом {"#cGN"}'получение переводов'{"#cWH"}." ) ;
		
			global_string [ 0 ] = EOS ;
			format ( global_string, 256, "\
				Вы успешно перевели денежные средства.\n\
				Сумма перевода: %s"valute_title_", Коммиссия: %s"valute_title_"",
			GetPlayerCashValueToSmile ( sum ), GetPlayerCashValueToSmile ( commision ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		}
		else
		{
			for ( new i = 0 ; i < MAX_BANK_ACCOUNT ; i ++ )
			{
				if ( bank_info [ playerid ] [ bi_id ] [ i ] != playerId ) continue ;

				send_check_cinfo ( playerid, "Невозможно перевести средства самому себе!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new sql_string [ 156 ] ;
			format ( sql_string, sizeof sql_string, "\
				SELECT \
					u.u_last_ip, \
					u.u_name, \
					u.u_id \
				FROM deposit_boxes db \
				LEFT JOIN users u ON u.u_id=db.db_owner \
				WHERE db.db_id = '%d' LIMIT 1", playerId ) ;
			mysql_tquery ( sql_connection, sql_string, "check_owner_deposit", "iiii", playerid, playerId, sum, idx ) ;
		}
	}
	else if ( actionId == BANK_APP + 4 ) // next page
	{
		page_rows [ playerid ] += 20 ;
		
		new sql_string [ 144 ] ;
		format ( sql_string, sizeof sql_string, "SELECT * FROM deposit_logs WHERE dl_from = %d ORDER BY deposit_logs.dl_id DESC LIMIT %d OFFSET %d", 
			bank_info [ playerid ] [ bi_id ] [ strval ( data ) ], page_rows [ playerid ], page_rows [ playerid ] - 100 ) ;
		mysql_tquery ( sql_connection, sql_string, "showDepositLogs", "i", playerid ) ;
	}
	else if ( actionId == BANK_APP + 5 ) // swipe
	{
		send_check_cinfo ( playerid, "Используйте свайп для выбора карты.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	else if ( actionId == BANK_APP + 6 ) // error id
	{
		send_check_cinfo ( playerid, "Укажите ID игрока или счёта для перевода!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	else if ( actionId == BANK_APP + 7 ) // error sum
	{
		send_check_cinfo ( playerid, "Укажите сумму перевода!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	else if ( actionId == BANK_APP + 8 ) // bank service
	{
    	global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			{"#cWH"}Ваша задолженность по налогам составляет {"#cBL"}%s"valute_title_"\n\
			{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
			{"#cGRDialog"}* Введите сумму, которую желаете внести в счёт уплаты налогов:",
			GetPlayerCashValueToSmile ( p_info [ playerid ] [ tax ] ), TABLET_BANK_COMMISION ) ;
		show_dialog ( playerid, d_tablet_tax, DIALOG_STYLE_INPUT, "{"#cBHD"}Оплата налогов", global_string, "Принять", "Назад" ) ;

		set_player_use_listitem ( playerid, strval ( data ) ) ;
	}
	else if ( actionId == BANK_APP + 9 ) // phone payment
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
			{"#cGRDialog"}* Введите сумму, на которую хотите пополнить баланс:",
			TABLET_BANK_COMMISION ) ;
		show_dialog ( playerid, d_tablet_tophone, DIALOG_STYLE_INPUT, "{"#cBHD"}Пополнение баланса телефона", global_string, "Принять", "Назад" ) ;

		set_player_use_listitem ( playerid, strval ( data ) ) ;
	}
	else if ( actionId == BANK_APP + 10 ) // ticket payment
	{
    	page_count [ playerid ] = 1 ;

		new query_string [ 86 ] ;
		format ( query_string, sizeof query_string, "SELECT `id`,`fine_value` FROM `users_tickets` WHERE `u_id` = '%d'", p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "bankticket_list_callback", "i", playerid ) ;
	}
	return 1 ;
}

stock t_bank_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	switch ( dialogid )
	{
		case d_tablet_tax:
		{
			if ( ! response ) return 1 ;

			new deposit_id = get_player_use_listitem ( playerid ),
				tax_count = strval ( inputtext ),
				commision = ( tax_count * TABLET_BANK_COMMISION ) / 100 ;
			if ( tax_count < 1 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "\
					{"#cRD"}* Сумма платежа не может быть меньше 1"valute_title_"\n\
					{"#cWH"}Ваша задолженность по налогам составляет {"#cBL"}%s"valute_title_"\n\
					{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
					{"#cGRDialog"}* Введите сумму, которую желаете внести в счёт уплаты налогов:",
					GetPlayerCashValueToSmile ( p_info [ playerid ] [ tax ] ), TABLET_BANK_COMMISION ) ;
				show_dialog ( playerid, d_tablet_tax, DIALOG_STYLE_INPUT, "{"#cBHD"}Оплата налогов", global_string, "Принять", "Назад" ) ;
				return 1 ;
			}
			if ( bank_info [ playerid ] [ bi_money ] [ deposit_id ] < tax_count + commision )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "\
					{"#cRD"}* У Вас недостаточно средств для платежа!\n\
					{"#cWH"}Ваша задолженность по налогам составляет {"#cBL"}%s"valute_title_"\n\
					{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
					{"#cGRDialog"}* Введите сумму, которую желаете внести в счёт уплаты налогов:",
					GetPlayerCashValueToSmile ( p_info [ playerid ] [ tax ] ), TABLET_BANK_COMMISION ) ;
				show_dialog ( playerid, d_tablet_tax, DIALOG_STYLE_INPUT, "{"#cBHD"}Оплата налогов", global_string, "Принять", "Назад" ) ;
				return 1 ;
			}
			if ( p_info [ playerid ] [ tax ] < tax_count )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "\
					{"#cRD"}* Вносимая сумма превышает сумму долга!\n\
					{"#cWH"}Ваша задолженность по налогам составляет {"#cBL"}%s"valute_title_"\n\
					{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
					{"#cGRDialog"}* Введите сумму, которую желаете внести в счёт уплаты налогов:",
					GetPlayerCashValueToSmile ( p_info [ playerid ] [ tax ] ), TABLET_BANK_COMMISION ) ;
				show_dialog ( playerid, d_tablet_tax, DIALOG_STYLE_INPUT, "{"#cBHD"}Оплата налогов", global_string, "Принять", "Назад" ) ;
				return 1 ;
			}
			p_info [ playerid ] [ tax ] -= tax_count ;
			update_int_sql ( playerid, "u_tax", p_info [ playerid ] [ tax ] ) ;

            bank_info [ playerid ] [ bi_money ] [ deposit_id ] -= tax_count + commision ;

			new _text_string [ 144 ] ;
			format ( _text_string, sizeof ( _text_string ), "UPDATE `deposit_boxes` SET `db_money` = '%d' WHERE `db_id` = '%d' LIMIT 1", bank_info [ playerid ] [ bi_money ] [ deposit_id ], bank_info [ playerid ] [ bi_id ] [ deposit_id ] ) ;
			mysql_tquery ( sql_connection, _text_string, "", "" ) ;

			set_money_fraction ( 10, 4, tax_count, true ) ;

			format ( _text_string, sizeof ( _text_string ), "{"#cGInfo"}* {"#cWH"}Вы внесли {"#cGN"}%d"valute_title_"{"#cWH"} в счёт уплаты налогов. Задолженность составляет {"#cGN"}%d"valute_title"{"#cWH"}.",
			tax_count, p_info [ playerid ] [ tax ] ) ;
			SendClientMessage ( playerid, col_white, _text_string ) ;

			if ( p_info [ playerid ] [ tax ] < tax_limit_bit ) clear_for_tax ( playerid, 1 ) ;
			
			give_event_progress ( playerid, THE_TAX, 1 ) ;
			return 1 ;
		}
		case d_tablet_tophone:
		{
			if ( ! response ) return 1 ;

			new _value = strval ( inputtext ),
				_db_money = bank_info [ playerid ] [ bi_money ] [ get_player_use_listitem ( playerid ) ],
				commision = ( _value * TABLET_BANK_COMMISION ) / 100 ;
			if ( _value < 1 || _value > 500000 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "\
					{"#cRD"}* Сумма не может быть меньше 1"valute_title_" или больше 500.000"valute_title".\n\
					{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
					{"#cGRDialog"}* Введите сумму, на которую хотите пополнить баланс:",
					TABLET_BANK_COMMISION ) ;
				show_dialog ( playerid, d_tablet_tophone, DIALOG_STYLE_INPUT, "{"#cBHD"}Пополнение баланса телефона", global_string, "Принять", "Назад" ) ;
				return 1 ;
			}
			
			if ( _db_money < _value + commision )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "\
					{"#cRD"}* На вашем счету недостаточно средств.\n\
					{"#cWH"}Комиссия за оплату через мобильный банк {"#cGN"}%d%\n\n\
					{"#cGRDialog"}* Введите сумму, на которую хотите пополнить баланс:",
					TABLET_BANK_COMMISION ) ;
				show_dialog ( playerid, d_tablet_tophone, DIALOG_STYLE_INPUT, "{"#cBHD"}Пополнение баланса телефона", global_string, "Принять", "Назад" ) ;
				return 1 ;
			}

			p_info [ playerid ] [ phone_balance ] += _value + commision ;

			new dialog_string [ 76 + 9 + 9 ] ;
			format ( dialog_string, sizeof ( dialog_string ), "SMS: Ваш баланс пополнен на сумму %d"valute_title". Баланс: %d"valute_title" | Отправитель: SA BANK", _value, p_info [ playerid ] [ phone_balance ] ) ;
			SendClientMessage( playerid,  col_yellow, dialog_string ) ;

			bank_info [ playerid ] [ bi_money ] [ get_player_use_listitem ( playerid ) ] -= _value ;

			format ( dialog_string, sizeof dialog_string, "UPDATE `deposit_boxes` SET `db_money` = '%d' WHERE `db_id` = '%d' LIMIT 1", bank_info [ playerid ] [ bi_money ] [ get_player_use_listitem ( playerid ) ], bank_info [ playerid ] [ bi_id ] [ get_player_use_listitem ( playerid ) ] ) ;
			mysql_tquery ( sql_connection, dialog_string ) ;

			give_event_progress ( playerid, PUT_MOBILE, _value ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: check_owner_deposit ( playerid, db_id, sum_transfer, idx )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	new ownerId, u_name [ MAX_PLAYER_NAME ], _ip_account [ 16 ], pl_id ;
	cache_get_field_content ( 0, "u_last_ip", _ip_account, sql_connection, 16 ) ;
	cache_get_field_content ( 0, "u_name", u_name ) ;
	ownerId = cache_get_field_content_int ( 0, "u_id" ) ;

    if ( GetString ( _ip_account, p_t_info [ playerid ] [ p_ip ] ) )
    {
        send_check_cinfo ( playerid, "Вы не можете перевести своему аккаунту!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

	new commision = ( sum_transfer * TABLET_BANK_COMMISION ) / 100 ;
	bank_info [ playerid ] [ bi_money ] [ idx ] -= sum_transfer + commision ;

	new dialog_string [ 144 ] ;
	format ( dialog_string, sizeof dialog_string, "\
		UPDATE `deposit_boxes` SET `db_money` = '%d' WHERE `db_id` = '%d' LIMIT 1",
		bank_info [ playerid ] [ bi_money ] [ db_id ], bank_info [ playerid ] [ bi_id ] [ idx ] ) ;
	mysql_tquery ( sql_connection, dialog_string ) ;

	format ( dialog_string, sizeof dialog_string, "Перевод на счёт №%d", db_id ) ;
	insert_deposit_logs ( bank_info [ playerid ] [ bi_id ] [ idx ], db_id, sum_transfer, dialog_string, BANK_TYPE_TRANSFER_TO ) ;
	format ( dialog_string, sizeof dialog_string, "Перевод со счёта №%d", bank_info [ playerid ] [ bi_id ] [ idx ] ) ;
	insert_deposit_logs ( db_id, bank_info [ playerid ] [ bi_id ] [ idx ], sum_transfer, dialog_string, BANK_TYPE_TRANSFER_ME ) ;

	dialog_string [ 0 ] = EOS ;
	format ( dialog_string, sizeof dialog_string, "\
		UPDATE `deposit_boxes` SET `db_money` = `db_money` + '%d' WHERE `db_id` = '%d' LIMIT 1", sum_transfer, db_id ) ;
	mysql_tquery ( sql_connection, dialog_string ) ;

	sscanf ( u_name, "u", pl_id ) ;
	if ( IsPlayerConnected ( pl_id ) )
	{
		for ( new i = 0 ; i < MAX_BANK_ACCOUNT ; i ++ )
		{
			if ( bank_info [ pl_id ] [ bi_id ] [ i ] != db_id ) continue ;

			bank_info [ pl_id ] [ bi_money ] [ i ] += sum_transfer ;
			break ;
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "{"#cGInfo"}* {"#cWH"}На Ваш банковский счет {"#cGN"}№%d{"#cWH"} поступил перевод на сумму {"#cGN"}%s"valute_title"{"#cWH"}.", db_id, GetPlayerCashValueToSmile ( sum_transfer ) ) ;
		SendClientMessage ( pl_id, col_white, global_string ) ;
	}
	else
	{
		insert_debtor_message ( "Банковский перевод", "Вам поступил банковский перевод.\nПолучить его можно в банке подойдя к надписи 'получение переводов'.", ownerId ) ;
	}

	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "\
		Вы успешно перевели денежные средства.\n\
		Сумма перевода: %s"valute_title_", Коммиссия: %s"valute_title_"",
	GetPlayerCashValueToSmile ( sum_transfer ), GetPlayerCashValueToSmile ( commision ) ) ;
	send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;

	show_window_tablet_bank ( playerid ) ;
	return 1 ;
}

callback: showDepositLogs ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	new Node: node = JSON_Array ( ), itemsLoaded = 0, dl_text [ 256 ], dl_type, dl_money, dl_time ;
	for ( new i = 0, Node: logsNode ; i < rows ; i ++ )
	{
		cache_get_field_content ( i, "dl_text", dl_text ) ;
		dl_type = cache_get_field_content_int ( i, "dl_type" ) ;
		dl_money = cache_get_field_content_int ( i, "dl_money" ) ;
		dl_time = cache_get_field_content_int ( i, "dl_date" ) ;

		logsNode = JSON_Array (
			JSON_Object (
				"text",				JSON_String ( dl_text ),
				"type",				JSON_Int ( dl_type ),
				"value",			JSON_Int ( dl_money ),
				"time",				JSON_Int ( dl_time )
			)
		) ;

		node = JSON_Append ( node, logsNode ) ;

		if ( ++ itemsLoaded == 10 || i == rows - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, BANK_APP + 2, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
	return 1 ;
}

stock show_window_tablet_bank ( playerid )
{
	new Node: node = JSON_Array ( ) ;
	for ( new i = 0, Node: bankNode ; i < MAX_BANK_ACCOUNT ; i ++ )
	{
		if ( ! bank_info [ playerid ] [ bi_type ] [ i ] ) continue ;

		bankNode = JSON_Array (
			JSON_Object (
				"id",				JSON_Int ( i ),
				"money",			JSON_Int ( bank_info [ playerid ] [ bi_money ] [ i ] ),
				"card",				JSON_Int ( bank_info [ playerid ] [ bi_id ] [ i ] ),
				"cardType",			JSON_Int ( bank_info [ playerid ] [ bi_type ] [ i ] )
			)
		) ;

		node = JSON_Append ( node, bankNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, BANK_APP, global_string ) ;
}