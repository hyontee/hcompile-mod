static playerSearch [ MAX_PLAYERS ] [ 64 ] ;

stock handleTabletSms ( playerid, actionId, data [ ] )
{
	if ( actionId == GET_CHATS ) // load chats
	{
		new page = strval ( data ) ;

		if ( page == 0 ) playerSearch [ playerid ] [ 0 ] = EOS ;
		if ( playerSearch [ playerid ] [ 0 ] != EOS ) page -= 1 ;

		p_t_info [ playerid ] [ in_messenger ] = true ;
		p_t_info [ playerid ] [ messenger_with_char ] = 0 ;

		GetMessengerMessages ( playerid, page ) ;
	}
	else if ( actionId == GET_MESSAGES ) // open chat
	{
		new Node: json ;
		JSON_Parse ( data, json ) ;

		new senderChar, page, firstOpen ;
		JSON_GetInt ( json, "chatId", senderChar ) ;
		JSON_GetInt ( json, "page", page ) ;
		JSON_GetInt ( json, "firstOpen", firstOpen ) ;

		SetPVarInt ( playerid, "messenger:firstOpen", firstOpen ) ;

		p_t_info [ playerid ] [ messenger_with_char ] = senderChar ;
		GetMessengerChat ( playerid, senderChar, page ) ;
	}
	else if ( actionId == GET_CONTACTS ) // open contacts with chat
	{
		new Node: node = JSON_Array ( ), _str [ 12 ], _pl_id ;
		for ( new i = 0, Node: nodeContact ; i < MAX_CONTACTS ; i ++ )
		{
			if ( i == 0 ) // isMe
			{
				format ( _str, sizeof _str, "%d", p_info [ playerid ] [ number ] ) ;
				nodeContact = JSON_Array (
					JSON_Object (
						"chatId",			JSON_Int ( -1 ),
						"username",			JSON_String ( "Мой номер" ),
						"number",			JSON_String ( _str ),
						"skinId",			JSON_Int ( getNewSkinModel ( playerid ) ),
						"isMe",				JSON_Int ( 1 ),
						"isOnline",			JSON_Int ( 1 )
					)
				) ;

				node = JSON_Append ( node, nodeContact ) ;
			}

			if ( users_contacts [ playerid ] [ i ] [ uc_inc ] == -1 ) continue ;

			sscanf ( users_contacts [ playerid ] [ i ] [ uc_name ], "u", _pl_id ) ;
			format ( _str, sizeof _str, "%d", users_contacts [ playerid ] [ i ] [ uc_number ] ) ;

			nodeContact = JSON_Array (
				JSON_Object (
					"chatId",			JSON_Int ( users_contacts [ playerid ] [ i ] [ uc_id ] ),
					"username",			JSON_String ( users_contacts [ playerid ] [ i ] [ uc_name ] ),
					"number",			JSON_String ( _str ),
					"skinId",			JSON_Int ( users_contacts [ playerid ] [ i ] [ uc_skin ] ),
					"isMe",				JSON_Int ( 0 ),
					"isOnline",			JSON_Int ( IsPlayerConnected ( _pl_id ) )
				)
			) ;

			node = JSON_Append ( node, nodeContact ) ;
		}

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, CLOSE_APP, global_string ) ;
	}
	else if ( actionId == CLOSE_APP ) // close chat
	{
		p_t_info [ playerid ] [ in_messenger ] = false ;
		p_t_info [ playerid ] [ messenger_with_char ] = 0 ;
	}
	else if ( actionId == SEARCH_CONTACT ) // find contact
	{
		format ( playerSearch [ playerid ], 64, "WHERE u_name LIKE '%%%s%%'", data ) ;
		GetMessengerMessages ( playerid, 0 ) ;
	}
	else if ( actionId == SEND_MESSAGE ) // send message
	{
		new Node: json ;
		JSON_Parse ( data, json ) ;

		new receiverId, message [ 124 ] ;
		JSON_GetInt ( json, "chatId", receiverId ) ;
		JSON_GetString ( json, "message", message ) ;

		if ( p_info [ playerid ] [ phone_balance ] < 5 )
		{
			send_check_cinfo ( playerid, "У вас нет средств для отправки SMS.\nПополните счёт в банке / банкомате (/gps).", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		p_info [ playerid ] [ phone_balance ] -= 5 ;
		SendMessengerMessage ( playerid, receiverId, message ) ;
	}
	return 1 ;
}

stock GetMessengerMessages ( playerid, page )
{
	new charId = p_info [ playerid ] [ id ] ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 1024, "\
		WITH list AS ( \
			SELECT \
				MAX(um.id) AS id, \
				CASE WHEN um.receiver_char_id = %d THEN um.sender_char_id ELSE um.receiver_char_id END AS u_id \
			FROM users_messages um \
			WHERE um.receiver_char_id = %d OR um.sender_char_id = %d \
			GROUP BY u_id \
		) \
		SELECT \
			us.u_id, \
			us.u_name, \
			us.u_skin, \
			us.u_online, \
			um.timestamp, \
			um.message, \
			(SELECT IFNULL(SUM(message_unread), 0) FROM users_messages WHERE sender_char_id = us.u_id AND receiver_char_id = %d) AS message_unread \
		FROM list l \
		LEFT JOIN users us ON us.u_id=l.u_id \
		LEFT JOIN users_messages um ON um.id=l.id \
		%s ORDER BY l.id DESC \
		LIMIT %d OFFSET %d", 
		charId,
		charId, charId,
		charId,
		playerSearch [ playerid ],
		ITEMS_SMS_PAGE, page * ITEMS_SMS_PAGE
	) ;
	mysql_tquery ( sql_connection, global_string, "ShowMessengerMessages", "i", playerid ) ;
	return true ;
}

callback: ShowMessengerMessages ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

	new Node: node = JSON_Array ( ),
		charId, charName [ MAX_PLAYER_NAME ], charSkin, charIsOnline, 
		messageDate, lastMessage [ 64 ], unreadMessage ;

	for ( new i = 0, Node: messageNode ; i < rows ; i ++ )
	{
		charId = cache_get_field_content_int ( i, "u_id" ) ; // us.u_id
		charSkin = cache_get_field_content_int ( i, "u_skin" ) ; // us.u_skin
		charIsOnline = cache_get_field_content_int ( i, "u_online" ) ; // us.u_online
		messageDate = cache_get_field_content_int ( i, "timestamp" ) ; // timestamp
		unreadMessage = cache_get_field_content_int ( i, "message_unread" ) ; // message_unrea

		cache_get_field_content ( i, "u_name", charName ) ; // us.u_name
		cache_get_field_content ( i, "message", lastMessage ) ; // message

		messageNode = JSON_Array (
			JSON_Object(
				"chatId", 				JSON_Int ( charId ),
				"skinId", 				JSON_Int ( charSkin ),
				"username", 			JSON_String ( charName ),
				"lastMessage", 			JSON_String ( lastMessage ),
				"date", 				JSON_Int ( messageDate ),
				"isOnline", 			JSON_Int ( charIsOnline ),
				"unreadMessageCount", 	JSON_Int ( unreadMessage )
			)
		) ;
		node = JSON_Append ( node, messageNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GET_CHATS, global_string ) ;
	return true ;
}

stock GetMessengerChat ( playerid, targetCharId, page )
{
	new charId = p_info [ playerid ] [ id ] ;

	if ( page == 0 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			UPDATE users_messages \
			SET message_unread = 0 \
			WHERE (sender_char_id = %d AND receiver_char_id = %d) AND message_unread = 1",
			targetCharId, charId
		);
		mysql_tquery ( sql_connection, global_string ) ;
	}

	global_string [ 0 ] = EOS ;
	format ( global_string, 356, "\
		SELECT \
			cm.message, \
			IF(cm.sender_char_id = %d, 0, 1) AS sender_char_id \
		FROM users_messages cm \
		WHERE (cm.receiver_char_id = %d AND cm.sender_char_id = %d) OR (cm.sender_char_id = %d AND cm.receiver_char_id = %d) \
		ORDER BY id DESC \
		LIMIT %d OFFSET %d", 
		charId, 
		charId, targetCharId,
		charId, targetCharId,
		ITEMS_SMS_PAGE, page * ITEMS_SMS_PAGE
	);
	mysql_tquery ( sql_connection, global_string, "ShowMessengerChat", "i", playerid ) ;
	return true ;
}

callback: ShowMessengerChat ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

	new Node: node = JSON_Array ( ), message [ 124 ], isFrom ;
	for ( new i = 0, Node: messageNode ; i < rows ; i ++ )
	{
		cache_get_field_content ( i, "message", message ) ;
		isFrom = cache_get_field_content_int ( i, "sender_char_id" ) ;

		messageNode = JSON_Array (
			JSON_Object (
				"message", 	JSON_String ( message ),
				"isFrom", 	JSON_Int ( isFrom )
			)
		) ;
		node = JSON_Append ( node, messageNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GET_MESSAGES, global_string ) ;
	return true ;
}

stock SendMessengerMessage ( playerid, receiverCharId, const message [ ] )
{
	new senderCharId = p_info [ playerid ] [ id ],
		receiverId = GetPlayerIDBySqlID ( receiverCharId ),
		messageTime = gettime ( ),
		messageUnread = 1 ;

	new newChat = GetPVarInt ( playerid, "messenger:firstOpen" ) ;
	DeletePVar ( playerid, "messenger:firstOpen" ) ;

	if ( p_t_info [ playerid ] [ in_messenger ] ) // У меня открыт мессенджер
	{
		if ( newChat ) // Если это первое сообщение в диалоге
			GetNewMessengerChat ( playerid, receiverCharId, messageTime, message, 0 ); // Втыкаем новый чат в панельку слева себе

		else
			GetUpdatedChatListInfo ( playerid, receiverCharId, message, 0 ) ; // Обновляем инфу в панельке слева себе (без обновления кол-ва входящих)

		AddNewMessageToChat ( playerid, message, 0 ) ; // Отображаем отправленное сообщение у себя в чате
	}
	if ( receiverId != INVALID_PLAYER_ID && p_t_info [ receiverId ] [ in_messenger ] ) // Собеседник в игре и у него открыт месседжер
	{
		if ( newChat ) // Если это первое сообщение в диалоге
			GetNewMessengerChat ( receiverId, senderCharId, messageTime, message, 1 ); // Втыкаем новый чат в панельку слева собеседнику

		else
		{
			if ( p_t_info [ receiverId ] [ messenger_with_char ] == senderCharId ) // У собеседника открыт чат с отправителем
			{
				AddNewMessageToChat ( receiverId, message, 1 ) ; // Отображаем отправленное сообщение у собеседника	в чате
				GetUpdatedChatListInfo ( receiverId, senderCharId, message, 0 ); // Обновляем инфу в панельке слева собеседнику (без обновления кол-ва входящих)
				messageUnread = 0 ;
			}
			else
				GetUpdatedChatListInfo ( receiverId, senderCharId, message, -1 ) ; // Обновляем инфу в панельке слева собеседнику (с обновлением кол-ва входящих)
		}
	}

	global_string [ 0 ] = EOS ;
	mysql_format ( sql_connection, global_string, 256, "\
		INSERT INTO users_messages (sender_char_id, receiver_char_id, message, timestamp, message_unread) \
		VALUES ('%d', '%d', '%s', '%d', '%d')",
		senderCharId, receiverCharId, message, messageTime, messageUnread
	) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return true ;
}

stock GetUpdatedChatListInfo ( playerid, targetCharId, const message [ ], messageUnread = -1 )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "\
		SELECT us.u_id, us.u_name, us.u_skin, us.u_online, \
			(SELECT SUM(message_unread) FROM users_messages WHERE sender_char_id=us.u_id AND receiver_char_id = %d) \
		FROM users us \
		WHERE us.u_id = %d LIMIT 1", 
		p_info [ playerid ] [ id ],
		targetCharId
	);
	return mysql_tquery ( sql_connection, global_string, "UpdateChatListInfo", "isi", playerid, message, messageUnread ) ;
}

callback: UpdateChatListInfo ( playerid, const lastMessage [ ], messageUnread )
{
	new charId, charSkin, charIsOnline, charName [ MAX_PLAYER_NAME ] ;

	charId = cache_get_field_content_int ( 0, "u_id" ) ; // us.u_id
	charSkin = cache_get_field_content_int ( 0, "u_skin" ) ; // us.u_skin
	charIsOnline = cache_get_field_content_int ( 0, "u_online" ) ; // us.u_online

	if ( messageUnread == -1 ) 
	{
		messageUnread = cache_get_field_content_int ( 0, "unreadMessage" ) ; // unreadMessage
		messageUnread += 1 ;
	}

	cache_get_field_content ( 0, "u_name", charName ) ; // us.u_name

	new Node: contactNode = JSON_Object (
		"chatId", 				JSON_Int ( charId ),
		"skinId", 				JSON_Int ( charSkin ),
		"username", 			JSON_String ( charName ),
		"lastMessage", 			JSON_String ( lastMessage ),
		"date", 				JSON_Int ( gettime ( ) ),
		"isOnline", 			JSON_Int ( charIsOnline ),
		"unreadMessageCount", 	JSON_Int ( messageUnread )
	);

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( contactNode, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GET_CONTACTS, global_string ) ;	
	return true ;
}

stock AddNewMessageToChat ( playerid, const message [ ], messageFrom )
{
	new Node: messageNode = JSON_Object (
		"message", 	JSON_String ( message ),
		"isFrom", 	JSON_Int ( messageFrom )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( messageNode, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, SEARCH_CONTACT, global_string ) ;
	return true ;
}

stock GetNewMessengerChat ( playerid, messageWithCharId, messageTime, const message [ ], messageUnread )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "\
		SELECT \
			us.u_id, \
			us.u_name, \
			us.u_skin, \
			us.u_online \
		FROM users us \
		WHERE us.u_id = %d LIMIT 1", 
		messageWithCharId
	) ;
	return mysql_tquery ( sql_connection, global_string, "AddNewMessengerChat", "iisi", playerid, messageTime, message, messageUnread ) ;
}

callback: AddNewMessengerChat ( playerid, messageTime, const message [ ], messageUnread )
{
	new charId, charSkin, charIsOnline, charName [ MAX_PLAYER_NAME ] ;

	charId = cache_get_field_content_int ( 0, "u_id" ) ; // us.u_id
	charSkin = cache_get_field_content_int ( 0, "u_skin" ) ; // us.u_skin
	charIsOnline = cache_get_field_content_int ( 0, "u_online" ) ; // us.u_online

	cache_get_field_content ( 0, "u_name", charName ) ; // us.u_name

	new Node: contactNode = JSON_Object (
		"chatId", 				JSON_Int ( charId ),
		"skinId", 				JSON_Int ( charSkin ),
		"username", 			JSON_String ( charName ),
		"lastMessage", 			JSON_String ( message ),
		"date", 				JSON_Int ( messageTime ),
		"isOnline", 			JSON_Int ( charIsOnline ),
		"unreadMessageCount", 	JSON_Int ( messageUnread )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( contactNode, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, SEND_MESSAGE, global_string ) ;
	return true ;
}