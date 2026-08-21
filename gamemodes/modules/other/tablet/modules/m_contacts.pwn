stock handleTabletContacts ( playerid, actionId, data [ ] )
{
	if ( actionId == CALL_APP_REQ_FOR_GET_CONTACTS ) // contacts
	{
		new Node: node = JSON_Array ( ), _str [ 12 ] ;
		for ( new i = 0, Node: nodeContact ; i < MAX_CONTACTS ; i ++ )
		{
			if ( i == 0 ) // isMe
			{
				format ( _str, sizeof _str, "%d", p_info [ playerid ] [ number ] ) ;
				nodeContact = JSON_Array (
					JSON_Object (
						"contactId",		JSON_Int ( -1 ),
						"contactName",		JSON_String ( "Мой номер" ),
						"contactNumber",	JSON_String ( _str ),
						"contactSkin",		JSON_Int ( getNewSkinModel ( playerid ) ),
						"isContactBlocked",	JSON_Int ( 0 ),
						"isMe",				JSON_Int ( 1 )
					)
				) ;

				node = JSON_Append ( node, nodeContact ) ;
			}

			if ( users_contacts [ playerid ] [ i ] [ uc_inc ] == -1 ) continue ;

			format ( _str, sizeof _str, "%d", users_contacts [ playerid ] [ i ] [ uc_number ] ) ;
			nodeContact = JSON_Array (
				JSON_Object (
					"contactId",		JSON_Int ( i ),
					"contactName",		JSON_String ( users_contacts [ playerid ] [ i ] [ uc_name ] ),
					"contactNumber",	JSON_String ( _str ),
					"contactSkin",		JSON_Int ( users_contacts [ playerid ] [ i ] [ uc_skin ] ),
					"isContactBlocked",	JSON_Int ( users_contacts [ playerid ] [ i ] [ uc_bl ] ),
					"isMe",				JSON_Int ( 0 )
				)
			) ;

			node = JSON_Append ( node, nodeContact ) ;
		}

		global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_TABLET, CALL_APP_REQ_FOR_GET_CONTACTS, global_string ) ;
	}
	else if ( actionId == CALL_APP_REQ_CALL_USER ) // call
	{
		new _number = strval ( data ), _str [ 12 ] ;
		format ( _str, sizeof _str, "%d", _number ) ;
		callcmd::call ( playerid, _str ) ;
	}
	else if ( actionId == CALL_APP_REQ_ADD_CONTACT ) // add contact
	{
		new _number = strval ( data ) ;
		for ( new i = 0 ; i < MAX_CONTACTS ; i ++ )
		{
		    if ( users_contacts [ playerid ] [ i ] [ uc_inc ] == -1 ) continue ;
		    if ( users_contacts [ playerid ] [ i ] [ uc_number ] != _number ) continue ;
		    
		    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный номер телефона уже есть в Вашей телефонной книге." ) ;
		    return 1 ;
		}

		new _free_cont = -1 ;
		for ( new i = 0 ; i < MAX_CONTACTS ; i ++ )
		{
		    if ( users_contacts [ playerid ] [ i ] [ uc_inc ] != -1 ) continue ;
	
			_free_cont = i ;
			break ;
		}
			
		if ( _free_cont == -1 ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас записано максимальное число контактов!" ) ;
		else
		{
			static const _str [ ] = "\
				SELECT \
					u.u_id, \
					u.u_name, \
					u.u_skin, \
					ua.acc_count AS u_number \
				FROM users_accessories ua \
				LEFT JOIN users u ON u.u_id=ua.u_id \
				WHERE ua.acc_count = %d LIMIT 1" ;
			new query_string [ sizeof _str + 9 ] ;
			format ( query_string, sizeof query_string, _str, _number ) ;
			mysql_tquery ( sql_connection, query_string, "callback_add_contact", "iii", playerid, _number, _free_cont ) ;
		}
	}
	else if ( actionId == CALL_APP_REQ_BLACKLIST_USER ) // add blacklist
	{
		new _slot = strval ( data ) ;
		if ( users_contacts [ playerid ] [ _slot ] [ uc_bl ] == 1 )
		{
			users_contacts [ playerid ] [ _slot ] [ uc_bl ] = 0 ;

			static const _str [ ] = "UPDATE `users_contacts` SET `u_c_bl` = '0' WHERE `inc_id` = '%d' LIMIT 1" ;
			new query_string [ sizeof _str + 9 ] ;
			format ( query_string, sizeof query_string, _str, users_contacts [ playerid ] [ _slot ] [ uc_inc ] ) ;
			mysql_tquery ( sql_connection, query_string ) ;
		}
		else
		{
			users_contacts [ playerid ] [ _slot ] [ uc_bl ] = 1 ;

			static const _str [ ] = "UPDATE `users_contacts` SET `u_c_bl` = '1' WHERE `inc_id` = '%d' LIMIT 1" ;
			new query_string [ sizeof _str + 9 ] ;
			format ( query_string, sizeof query_string, _str, users_contacts [ playerid ] [ _slot ] [ uc_inc ] ) ;
			mysql_tquery ( sql_connection, query_string ) ;
		}

		new _str [ 12 ] ;
		format ( _str, sizeof _str, "%d", users_contacts [ playerid ] [ _slot ] [ uc_number ] ) ;
		new Node: node = JSON_Object (
			"contactId",		JSON_Int ( _slot ),
			"contactName",		JSON_String ( users_contacts [ playerid ] [ _slot ] [ uc_name ] ),
			"contactNumber",	JSON_String ( _str ),
			"contactSkin",		JSON_Int ( users_contacts [ playerid ] [ _slot ] [ uc_skin ] ),
			"isContactBlocked",	JSON_Int ( users_contacts [ playerid ] [ _slot ] [ uc_bl ] ),
			"isMe",				JSON_Int ( 0 )
		) ;

		global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_TABLET, CALL_APP + 2, global_string ) ;
	}
	else if ( actionId == CALL_APP_REQ_DELETE_USER ) // delete contact
	{
		new _slot = strval ( data ) ;
		if ( users_contacts [ playerid ] [ _slot ] [ uc_inc ] != -1 )
		{
			static const _str [ ] = "DELETE FROM `users_contacts` WHERE `inc_id` = '%d' LIMIT 1" ;
			new sql_string [ sizeof _str + 9 ] ;
			format ( sql_string, sizeof sql_string, _str, users_contacts [ playerid ] [ _slot ] [ uc_inc ] ) ;
			mysql_tquery(sql_connection, sql_string ) ;

			users_contacts [ playerid ] [ _slot ] [ uc_inc ] = -1 ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 12, "%d", _slot ) ;
			onServerSendData ( playerid, UI_TABLET, CALL_APP + 1, global_string ) ;
		}
	}
	return 1 ;
}

callback: callback_add_contact ( playerid, _number, _slot )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;

	if ( ! rows )
	{
		send_check_cinfo ( playerid, "Абонент по указанному номеру не найден!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	contacts_inc_id ++ ;
	users_contacts [ playerid ] [ _slot ] [ uc_inc ] = contacts_inc_id ;
	users_contacts [ playerid ] [ _slot ] [ uc_id ] = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
	users_contacts [ playerid ] [ _slot ] [ uc_number ] = cache_get_field_content_int ( 0, "u_number", sql_connection ) ;
	users_contacts [ playerid ] [ _slot ] [ uc_skin ] = cache_get_field_content_int ( 0, "u_skin", sql_connection ) ;
	
	cache_get_field_content ( 0, "u_name", users_contacts [ playerid ] [ _slot ] [ uc_name ], sql_connection, MAX_PLAYER_NAME ) ;
	format ( users_contacts [ playerid ] [ _slot ] [ uc_subname ], MAX_PLAYER_NAME, "%s", users_contacts [ playerid ] [ _slot ] [ uc_name ] ) ;

	new query_string [ 300 ] ;
	format ( query_string, sizeof query_string, "INSERT INTO `users_contacts` (`inc_id`,`u_id`,`u_c_id`,`u_c_number`,`u_c_skin`) VALUES ('%d','%d','%d','%d','%d')",
	users_contacts [ playerid ] [ _slot ] [ uc_inc ],
	p_info [ playerid ] [ id ], users_contacts [ playerid ] [ _slot ] [ uc_id ],
	users_contacts [ playerid ] [ _slot ] [ uc_number ],
	users_contacts [ playerid ] [ _slot ] [ uc_skin ] ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	new _str [ 12 ] ;
	format ( _str, sizeof _str, "%d", users_contacts [ playerid ] [ _slot ] [ uc_number ] ) ;
	new Node: node = JSON_Array (
		JSON_Object (
			"contactId",		JSON_Int ( _slot ),
			"contactName",		JSON_String ( users_contacts [ playerid ] [ _slot ] [ uc_name ] ),
			"contactNumber",	JSON_String ( _str ),
			"contactSkin",		JSON_Int ( users_contacts [ playerid ] [ _slot ] [ uc_skin ] ),
			"isContactBlocked",	JSON_Int ( users_contacts [ playerid ] [ _slot ] [ uc_bl ] ),
			"isMe",				JSON_Int ( 0 )
		)
	) ;

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_TABLET, CALL_APP_REQ_FOR_GET_CONTACTS, global_string ) ;

	send_check_cinfo ( playerid, "Вы добавили контакт в телефонную книгу!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	return 1 ;
}