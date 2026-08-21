stock handleTabletGps ( playerid, actionId, data [ ] )
{
	if ( actionId == GPS_APP )
	{
		show_gps_add ( playerid ) ;
	}
	else if ( actionId == GPS_APP + 1 )
	{
		new Node: json = JSON_Object();
		JSON_Parse ( data, json ) ;

		new placeIndex, placeCategory ;
		JSON_GetInt ( json, "id", placeIndex ) ;
		JSON_GetInt ( json, "categoryId", placeCategory ) ;

		if ( is_gps_used { playerid } )
		{
			DisablePlayerRaceCheckpoint ( playerid ) ;
			is_gps_used { playerid } = 0 ;
		}

		p_t_info [ playerid ] [ gps_category ] = placeCategory ;
		p_t_info [ playerid ] [ gps_id ] = placeIndex ;

		if ( placeCategory == 0 ) // важные места
		{
			SetPlayerRaceCheckpoint ( playerid, 1, gps_important_place [ placeIndex ] [ position ] [ 0 ], gps_important_place [ placeIndex ] [ position ] [ 1 ], gps_important_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 1 ) // работы
		{
			SetPlayerRaceCheckpoint ( playerid, 1, gps_job_place [ placeIndex ] [ position ] [ 0 ], gps_job_place [ placeIndex ] [ position ] [ 1 ], gps_job_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 2 ) // гос. организации
		{
			SetPlayerRaceCheckpoint ( playerid, 1, gps_govorg_place [ placeIndex ] [ position ] [ 0 ], gps_govorg_place [ placeIndex ] [ position ] [ 1 ], gps_govorg_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 3 ) // банды
		{
			switch ( placeIndex )
			{
				case 0:SetPlayerRaceCheckpoint ( playerid, 1, army_unloading [ 22 ] [ 0 ], army_unloading [ 22 ] [ 1 ], army_unloading [ 22 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // LCN
				case 1:SetPlayerRaceCheckpoint ( playerid, 1, army_unloading [ 23 ] [ 0 ], army_unloading [ 23 ] [ 1 ], army_unloading [ 23 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // RM
				case 2:SetPlayerRaceCheckpoint ( playerid, 1, army_unloading [ 24 ] [ 0 ], army_unloading [ 24 ] [ 1 ], army_unloading [ 24 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // YAKUZA
				default:
				{
		            SetPlayerRaceCheckpoint ( playerid, 1, gps_quests_place [ placeIndex ] [ position ] [ 0 ], gps_quests_place [ placeIndex ] [ position ] [ 1 ], gps_quests_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
					is_gps_used { playerid } = 1 ;
					return 1 ;
				}
			}
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 4 ) // автосалоны
		{
			SetPlayerRaceCheckpoint ( playerid, 1, gps_auto_place [ placeIndex ] [ position ] [ 0 ], gps_auto_place [ placeIndex ] [ position ] [ 1 ], gps_auto_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 5 ) // развлечения
		{
			SetPlayerRaceCheckpoint ( playerid, 1, gps_other_place [ placeIndex ] [ position ] [ 0 ], gps_other_place [ placeIndex ] [ position ] [ 1 ], gps_other_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 6 ) // бизнесы
		{
			new Float: _distance2 = 3000.0, _b_id ;
			foreach(new b: business_types[placeIndex])
			{
				if ( b_info [ b - 1 ] [ b_type ] != placeIndex ) continue ;
				new Float:__distance2 = GetPlayerDistanceFromPoint ( playerid, b_info [ b - 1 ] [ b_position ] [ 0 ], b_info [ b - 1 ] [ b_position ] [ 1 ], b_info [ b - 1 ] [ b_position ] [ 2 ] ) ;
				if ( _distance2 > __distance2 ) _distance2 = __distance2, _b_id = b - 1 ;
			}
			
			SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _b_id - 1 ] [ b_position ] [ 0 ], b_info [ _b_id - 1 ] [ b_position ] [ 1 ], b_info [ _b_id - 1 ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 7 ) // задания
		{
			SetPlayerRaceCheckpoint ( playerid, 1, gps_quests_place [ placeIndex ] [ position ] [ 0 ], gps_quests_place [ placeIndex ] [ position ] [ 1 ], gps_quests_place [ placeIndex ] [ position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
		}
		else if ( placeCategory == 8 ) // ближ. места
		{
			if ( placeIndex == 0 ) // банкомат
			{
				new Float:_distance = 3000.0,
					_atm_id ;

				for ( new h = 0 ; h < atm_count ; h ++ )
				{
					new Float:__distance = GetPlayerDistanceFromPoint ( playerid, atm_info [ h ] [ atm_position ] [ 0 ],atm_info [ h ] [ atm_position ] [ 1 ], atm_info [ h ] [ atm_position ] [ 2 ] ) ;
					if ( _distance > __distance ) _distance = __distance, _atm_id = h ;
				}

				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;

				SetPlayerRaceCheckpoint ( playerid, 1, atm_info [ _atm_id ] [ atm_position ] [ 0 ], atm_info [ _atm_id ] [ atm_position ] [ 1 ], atm_info [ _atm_id ] [ atm_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			}
			else if ( placeIndex == 1 ) // 24/7
			{
				new Float:_distance = 3000.0,
					_b_id ;

				foreach(new h: business_types[bizz_type_shop])
				{
					if ( b_info [ h - 1 ] [ b_type ] != bizz_type_shop ) continue ;
					new Float:__distance = GetPlayerDistanceFromPoint ( playerid, b_info [ h - 1 ] [ b_position ] [ 0 ], b_info [ h - 1 ] [ b_position ] [ 1 ], b_info [ h - 1 ] [ b_position ] [ 2 ] ) ;
					if ( _distance > __distance ) _distance = __distance, _b_id = h - 1 ;
				}

				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;

				SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _b_id ] [ b_position ] [ 0 ], b_info [ _b_id ] [ b_position ] [ 1 ], b_info [ _b_id ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			}
			else if ( placeIndex == 2 ) // азс
			{
				new Float:_distance = 3000.0,
					_b_id ;

				foreach(new h: business_types[bizz_type_gas])
				{
					if ( b_info [ h - 1 ] [ b_type ] != bizz_type_gas ) continue ;
					new Float:__distance = GetPlayerDistanceFromPoint ( playerid, b_info [ h - 1 ] [ b_position ] [ 0 ], b_info [ h - 1 ] [ b_position ] [ 1 ], b_info [ h - 1 ] [ b_position ] [ 2 ] ) ;
					if ( _distance > __distance ) _distance = __distance, _b_id = h - 1 ;
				}

				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;

				SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _b_id ] [ b_position ] [ 0 ], b_info [ _b_id ] [ b_position ] [ 1 ], b_info [ _b_id ] [ b_position ] [ 2 ],0.0,0.0,0.0,2.0);
			}
			else if ( placeIndex == 3 ) // home
			{
				callcmd::home ( playerid ) ;
			}
			else if ( placeIndex == 4 ) // family home
			{
				callcmd::famhouse ( playerid ) ;
			}
		}
		onServerSendData ( playerid, UI_TABLET, 1, "" ) ;
	}
	return 1 ;
}

stock show_gps_add ( playerid )
{
	#if defined debug_packet
		printf ( "[show_gps_add] playerid: %d", playerid ) ;
	#endif

	// важные места
	new Node: node = JSON_Array ( ), Float: _distance,
		_category = p_t_info [ playerid ] [ gps_category ],
		_gpsId = p_t_info [ playerid ] [ gps_id ] ;
	for ( new i = 0, Node: gpsNode ; i < gps_important_place_items ; i ++ )
	{
		_distance = GetDistanceBetweenPoints ( 
			p_t_info [ playerid ] [ p_pos ] [ 0 ], 
			p_t_info [ playerid ] [ p_pos ] [ 1 ], 
			p_t_info [ playerid ] [ p_pos ] [ 2 ], 
			gps_important_place [ i ] [ position ] [ 0 ], 
			gps_important_place [ i ] [ position ] [ 1 ], 
			gps_important_place [ i ] [ position ] [ 2 ] 
		) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_important_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 0 ),
				"placeStatus",		JSON_Int ( ( _category == 0 && _gpsId == i ) ? 1 : 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// работы
	node = JSON_Array ( ) ;
	for ( new i = 0, Node: gpsNode ; i < gps_job_place_items ; i ++ )
	{
		_distance = GetDistanceBetweenPoints ( 
			p_t_info [ playerid ] [ p_pos ] [ 0 ], 
			p_t_info [ playerid ] [ p_pos ] [ 1 ], 
			p_t_info [ playerid ] [ p_pos ] [ 2 ], 
			gps_job_place [ i ] [ position ] [ 0 ], 
			gps_job_place [ i ] [ position ] [ 1 ], 
			gps_job_place [ i ] [ position ] [ 2 ] 
		) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_job_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 1 ),
				"placeStatus",		JSON_Int ( ( _category == 1 && _gpsId == i ) ? 1 : 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// гос. организации
	node = JSON_Array ( ) ;
	for ( new i = 0, Node: gpsNode ; i < gps_govorg_place_items ; i ++ )
	{
		_distance = GetDistanceBetweenPoints ( 
			p_t_info [ playerid ] [ p_pos ] [ 0 ], 
			p_t_info [ playerid ] [ p_pos ] [ 1 ], 
			p_t_info [ playerid ] [ p_pos ] [ 2 ], 
			gps_govorg_place [ i ] [ position ] [ 0 ], 
			gps_govorg_place [ i ] [ position ] [ 1 ], 
			gps_govorg_place [ i ] [ position ] [ 2 ] 
		) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_govorg_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 2 ),
				"placeStatus",		JSON_Int ( ( _category == 2 && _gpsId == i ) ? 1 : 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// опг
	node = JSON_Array ( ) ;
	for ( new i = 0, Node: gpsNode ; i < gps_nelegal_place_items ; i ++ )
	{
		if ( i < 3 )
		{
			_distance = 0.0 ;
		}
		else
		{
			_distance = GetDistanceBetweenPoints ( 
				p_t_info [ playerid ] [ p_pos ] [ 0 ], 
				p_t_info [ playerid ] [ p_pos ] [ 1 ], 
				p_t_info [ playerid ] [ p_pos ] [ 2 ], 
				gps_nelegal_place [ i ] [ position ] [ 0 ], 
				gps_nelegal_place [ i ] [ position ] [ 1 ], 
				gps_nelegal_place [ i ] [ position ] [ 2 ] 
			) ;
		}
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_nelegal_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 3 ),
				"placeStatus",		JSON_Int ( ( _category == 3 && _gpsId == i ) ? 1 : 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// автосалоны
	node = JSON_Array ( ) ;
	for ( new i = 0, Node: gpsNode ; i < gps_auto_place_items ; i ++ )
	{
		_distance = GetDistanceBetweenPoints ( 
			p_t_info [ playerid ] [ p_pos ] [ 0 ], 
			p_t_info [ playerid ] [ p_pos ] [ 1 ], 
			p_t_info [ playerid ] [ p_pos ] [ 2 ], 
			gps_auto_place [ i ] [ position ] [ 0 ], 
			gps_auto_place [ i ] [ position ] [ 1 ], 
			gps_auto_place [ i ] [ position ] [ 2 ] 
		) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_auto_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 4 ),
				"placeStatus",		JSON_Int ( ( _category == 4 && _gpsId == i ) ? 1 : 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// развлечения
	node = JSON_Array ( ) ;
	for ( new i = 0, Node: gpsNode ; i < gps_other_place_items ; i ++ )
	{
		_distance = GetDistanceBetweenPoints ( 
			p_t_info [ playerid ] [ p_pos ] [ 0 ], 
			p_t_info [ playerid ] [ p_pos ] [ 1 ], 
			p_t_info [ playerid ] [ p_pos ] [ 2 ], 
			gps_other_place [ i ] [ position ] [ 0 ], 
			gps_other_place [ i ] [ position ] [ 1 ], 
			gps_other_place [ i ] [ position ] [ 2 ] 
		) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_other_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 5 ),
				"placeStatus",		JSON_Int ( ( _category == 5 && _gpsId == i ) ? 1 : 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// бизнесы
	node = JSON_Array ( ) ;
	new itemsLoaded = 0 ;
	for ( new i = 0, Node: gpsNode ; i < max_type - 2 ; i ++ )
	{
		new Float: _distance2 = 3000.0 ;
		foreach(new b: business_types[i])
		{
			new Float:__distance2 = GetPlayerDistanceFromPoint ( playerid, b_info [ b - 1 ] [ b_position ] [ 0 ], b_info [ b - 1 ] [ b_position ] [ 1 ], b_info [ b - 1 ] [ b_position ] [ 2 ] ) ;
			if ( _distance2 > __distance2 ) _distance2 = __distance2 ;
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 100, "%s\t ", b_types [ i ] ) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( global_string ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 6 ),
				"placeStatus",		JSON_Int ( ( _category == 6 && _gpsId == i ) ? 1 : 0 )
			)
		);
		node = JSON_Append ( node, gpsNode ) ;

		if ( ++ itemsLoaded == 10 || i == max_type - 2 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
    	JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;
	}
	
	// задания
	node = JSON_Array ( ) ;
	for ( new i = 0, Node: gpsNode ; i < gps_quests_place_items ; i ++ )
	{
		_distance = GetDistanceBetweenPoints ( 
			p_t_info [ playerid ] [ p_pos ] [ 0 ], 
			p_t_info [ playerid ] [ p_pos ] [ 1 ], 
			p_t_info [ playerid ] [ p_pos ] [ 2 ], 
			gps_quests_place [ i ] [ position ] [ 0 ], 
			gps_quests_place [ i ] [ position ] [ 1 ], 
			gps_quests_place [ i ] [ position ] [ 2 ] 
		) ;
		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( gps_quests_place [ i ] [ loc_name ] ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( i ),
				"placeCategory",	JSON_Int ( 7 ),
				"placeStatus",		JSON_Int ( ( _category == 7 && _gpsId == i ) ? 1 : 0 )
			)
		);
		node = JSON_Append ( node, gpsNode ) ;
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;

	// ближ. места
	node = JSON_Array ( ) ;
	new Node: gpsNode, Float: __distance ;

	// банкомат
	_distance = 3000.0 ;
	for ( new h = 0 ; h < atm_count ; h ++ )
	{
		__distance = GetPlayerDistanceFromPoint ( playerid, atm_info [ h ] [ atm_position ] [ 0 ], atm_info [ h ] [ atm_position ] [ 1 ], atm_info [ h ] [ atm_position ] [ 2 ] ) ;
		if ( _distance > __distance ) _distance = __distance ;
	}

	gpsNode = JSON_Array (
		JSON_Object (
			"placeName",		JSON_String ( "Банкомат\tБлижайший к Вам" ),
			"placeDistance",	JSON_Int ( floatround ( _distance ) ),
			"placeIndex",		JSON_Int ( 0 ),
			"placeCategory",	JSON_Int ( 8 ),
			"placeStatus",		JSON_Int ( 0 )
		)
	) ;
	node = JSON_Append ( node, gpsNode ) ;

	// магазин 24/7
	_distance = 3000.0 ;
	foreach(new h: business_types[bizz_type_shop])
	{
		if ( b_info [ h - 1 ] [ b_type ] != bizz_type_shop ) continue ;
		__distance = GetPlayerDistanceFromPoint ( playerid, b_info [ h - 1 ] [ b_position ] [ 0 ], b_info [ h - 1 ] [ b_position ] [ 1 ], b_info [ h - 1 ] [ b_position ] [ 2 ] ) ;
		if ( _distance > __distance ) _distance = __distance ;
	}

	gpsNode = JSON_Array (
		JSON_Object (
			"placeName",		JSON_String ( "Магазин 24/7\tБлижайший к Вам" ),
			"placeDistance",	JSON_Int ( floatround ( _distance ) ),
			"placeIndex",		JSON_Int ( 1 ),
			"placeCategory",	JSON_Int ( 8 ),
			"placeStatus",		JSON_Int ( 0 )
		)
	) ;
	node = JSON_Append ( node, gpsNode ) ;

	// азс
	_distance = 3000.0 ;
	foreach(new h: business_types[bizz_type_gas])
	{
		if ( b_info [ h - 1 ] [ b_type ] != bizz_type_gas ) continue ;
		__distance = GetPlayerDistanceFromPoint ( playerid, b_info [ h - 1 ] [ b_position ] [ 0 ], b_info [ h - 1 ] [ b_position ] [ 1 ], b_info [ h - 1 ] [ b_position ] [ 2 ] ) ;
		if ( _distance > __distance ) _distance = __distance ;
	}

	gpsNode = JSON_Array (
		JSON_Object (
			"placeName",		JSON_String ( "АЗС\tБлижайшая к Вам" ),
			"placeDistance",	JSON_Int ( floatround ( _distance ) ),
			"placeIndex",		JSON_Int ( 2 ),
			"placeCategory",	JSON_Int ( 8 ),
			"placeStatus",		JSON_Int ( 0 )
		)
	) ;
	node = JSON_Append ( node, gpsNode ) ;

	if ( p_info [ playerid ] [ house ] > 0 )
	{
		new s_house_id = p_info [ playerid ] [ house ] - 1 ;
        if ( h_info [ s_house_id ] [ h_podezd ] != -1 )
	    {
	    	new _padik_id = h_info [ s_house_id ] [ h_podezd ] ;
			__distance = GetPlayerDistanceFromPoint ( playerid, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ] ) ;
		}
		else 
		{
			__distance = GetPlayerDistanceFromPoint ( playerid, h_info [ s_house_id ] [ h_pos ] [ 0 ], h_info [ s_house_id ] [ h_pos ] [ 1 ], h_info [ s_house_id ] [ h_pos ] [ 2 ] ) ;
		}

		gpsNode = JSON_Array (
			JSON_Object (
				"placeName",		JSON_String ( "Ваш дом\tОтметить на GPS" ),
				"placeDistance",	JSON_Int ( floatround ( _distance ) ),
				"placeIndex",		JSON_Int ( 3 ),
				"placeCategory",	JSON_Int ( 8 ),
				"placeStatus",		JSON_Int ( 0 )
			)
		) ;
		node = JSON_Append ( node, gpsNode ) ;
	}

	if ( p_info [ playerid ] [ family ] > 0 )
	{
		new family_id = p_info [ playerid ] [ family ] ;
		if ( family_info [ family_id - 1 ] [ fam_house ] )
		{
			new s_house_id = family_info [ family_id - 1 ] [ fam_house ] - 1 ;
			if ( h_info [ s_house_id ] [ h_podezd ] != -1 )
			{
				new _padik_id = h_info [ s_house_id ] [ h_podezd ] ;
				__distance = GetPlayerDistanceFromPoint ( playerid, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ] ) ;
			}
			else 
			{
				__distance = GetPlayerDistanceFromPoint ( playerid, h_info [ s_house_id ] [ h_pos ] [ 0 ], h_info [ s_house_id ] [ h_pos ] [ 1 ], h_info [ s_house_id ] [ h_pos ] [ 2 ] ) ;
			}

			gpsNode = JSON_Array (
				JSON_Object (
					"placeName",		JSON_String ( "Семейный дом\tОтметить на GPS" ),
					"placeDistance",	JSON_Int ( floatround ( _distance ) ),
					"placeIndex",		JSON_Int ( 4 ),
					"placeCategory",	JSON_Int ( 8 ),
					"placeStatus",		JSON_Int ( 0 )
				)
			) ;
			node = JSON_Append ( node, gpsNode ) ;
		}
	}

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, GPS_APP, global_string ) ;
}