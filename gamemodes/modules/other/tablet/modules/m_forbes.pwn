stock handleTabletForbes ( playerid, actionId, data [ ] )
{
	if ( actionId == FORBES_APP ) // список форбс (наличка)
	{
		new visible = strval ( data ) ;
		if ( p_info [ playerid ] [ forbes_visible ] != visible )
		{
			p_info [ playerid ] [ forbes_visible ] = visible ;
			update_int_sql ( playerid, "u_forbes_visible", visible ) ;
		}

		onServerSendData ( playerid, UI_TABLET, FORBES_APP + 1, "" ) ;
		mysql_tquery ( sql_connection, "SELECT `u_name`,`u_skin`,`u_money` FROM `users` WHERE `u_forbes_visible` = '0' ORDER BY `users`.`u_money` DESC LIMIT 10", "callback_forbes_money", "i", playerid ) ;
	}
	else if ( actionId == FORBES_APP + 1 ) // список форбс (банк)
	{
		new visible = strval ( data ) ;
		if ( p_info [ playerid ] [ forbes_visible ] != visible )
		{
			p_info [ playerid ] [ forbes_visible ] = visible ;
			update_int_sql ( playerid, "u_forbes_visible", visible ) ;
		}

		onServerSendData ( playerid, UI_TABLET, FORBES_APP + 1, "" ) ;
		mysql_tquery ( sql_connection, "\
		SELECT \
			us.u_name, \
			us.u_skin, \
			db.db_money \
		FROM deposit_boxes db \
		LEFT JOIN users us ON us.u_id=db.db_owner \
		ORDER BY db.db_money DESC LIMIT 10", "callback_forbes_bank", "i", playerid ) ;
	}
	else if ( actionId == FORBES_APP + 2 ) // список форбс (благотворительность)
	{
		new visible = strval ( data ) ;
		if ( p_info [ playerid ] [ forbes_visible ] != visible )
		{
			p_info [ playerid ] [ forbes_visible ] = visible ;
			update_int_sql ( playerid, "u_forbes_visible", visible ) ;
		}

		onServerSendData ( playerid, UI_TABLET, FORBES_APP + 1, "" ) ;
		mysql_tquery ( sql_connection, "SELECT `u_name`,`u_skin`,`u_charity` FROM `users` WHERE `u_forbes_visible` = '0' ORDER BY `users`.`u_charity` DESC LIMIT 10", "callback_forbes_charity", "i", playerid ) ;
	}
	return 1 ;
}

callback: callback_forbes_money ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	new Node: node = JSON_Array ( ), u_name [ MAX_PLAYER_NAME ], u_money, u_skin ;
	for ( new i = 0, Node: forbesNode ; i < rows ; i ++ )
	{
		cache_get_field_content ( i, "u_name", u_name ) ;
		u_money = cache_get_field_content_int ( i, "u_money" ) ;
		u_skin = cache_get_field_content_int ( i, "u_skin" ) ;

		forbesNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( u_name ),
				"money",		JSON_Int ( u_money ),
				"skinId",		JSON_Int ( u_skin )
			)
		) ;
		node = JSON_Append ( node, forbesNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, FORBES_APP, global_string ) ;
	return 1 ;
}

callback: callback_forbes_bank ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	new Node: node = JSON_Array ( ), u_name [ MAX_PLAYER_NAME ], db_money, u_skin ;
	for ( new i = 0, Node: forbesNode ; i < rows ; i ++ )
	{
		cache_get_field_content ( i, "u_name", u_name ) ;
		u_skin = cache_get_field_content_int ( i, "u_skin" ) ;
		db_money = cache_get_field_content_int ( i, "db_money" ) ;

		forbesNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( u_name ),
				"money",		JSON_Int ( db_money ),
				"skinId",		JSON_Int ( u_skin )
			)
		) ;
		node = JSON_Append ( node, forbesNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, FORBES_APP, global_string ) ;
	return 1 ;
}

callback: callback_forbes_charity ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	new Node: node = JSON_Array ( ), u_name [ MAX_PLAYER_NAME ], u_charity, u_skin ;
	for ( new i = 0, Node: forbesNode ; i < rows ; i ++ )
	{
		cache_get_field_content ( i, "u_name", u_name ) ;
		u_skin = cache_get_field_content_int ( i, "u_skin" ) ;
		u_charity = cache_get_field_content_int ( i, "u_charity" ) ;

		forbesNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( u_name ),
				"money",		JSON_Int ( u_charity ),
				"skinId",		JSON_Int ( u_skin )
			)
		) ;
		node = JSON_Append ( node, forbesNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, FORBES_APP, global_string ) ;
	return 1 ;
}
