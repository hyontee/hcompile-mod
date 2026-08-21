enum
{
	GENRES_POP,
	GENRES_ROCK,
	GENRES_RUS_CHANCON,
	GENRES_PHONK,
	GENRES_HIP_HOP,
	GENRES_RUS_RAP,
	GENRES_WORLD_MUSIC,
	GENRES_RADIO
} ;

stock handleTabletMusic ( playerid, actionId, data [ ] )
{
	if ( actionId == CHANGE_PLAY_MODE_REQ ) // смена выхода звука
	{
		g_aStreamSources [ playerid ] [ eStreamType ] = strval ( data ) ;

		new _vehicleOutput = 0, boombox = ! GetInventoryFindItem ( playerid, SUB_INVENTORY, 2256 ) ? 0 : 1, _v_id = GetPlayerVehicleID ( playerid ) ;
		if ( _v_id ) _vehicleOutput = 1, boombox = 0 ;
		
		new Node: node = JSON_Object (
			"currentMode",				JSON_Int ( g_aStreamSources [ playerid ] [ eStreamType ] ), // 0 - наушники, 1 - сабвуфер, 2 - бумбокс
			"isHeadphoneAvailable",		JSON_Int ( 1 ), // 0 - недоступно, 1 - доступно
			"isSubwooferAvailable",		JSON_Int ( _vehicleOutput ), // 0 - недоступно, 1 - доступно
			"isBoomboxAvailable",		JSON_Int ( boombox ) // 0 - недоступно, 1 - доступно
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, CHANGE_PLAY_MODE_REQ, global_string ) ;
	}
	else if ( actionId == GET_CURRENT_PLAYING_TRACK ) // запрос на получение текущего трека, если он вдруг играл при закрытом планшете
	{
		new _vehicleOutput = 0, boombox = ! GetInventoryFindItem ( playerid, SUB_INVENTORY, 2256 ) ? 0 : 1, _v_id = GetPlayerVehicleID ( playerid ) ;
		if ( _v_id ) _vehicleOutput = 1, boombox = 0 ;
		
		new Node: node = JSON_Object (
			"currentMode",				JSON_Int ( g_aStreamSources [ playerid ] [ eStreamType ] ), // 0 - наушники, 1 - сабвуфер, 2 - бумбокс
			"isHeadphoneAvailable",		JSON_Int ( 1 ), // 0 - недоступно, 1 - доступно
			"isSubwooferAvailable",		JSON_Int ( _vehicleOutput ), // 0 - недоступно, 1 - доступно
			"isBoomboxAvailable",		JSON_Int ( boombox ) // 0 - недоступно, 1 - доступно
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, CHANGE_PLAY_MODE_REQ, global_string ) ;
	}
	else if ( actionId == PLAY_TRACK_REQ ) // воспроизвести трэк
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new trackId, categoryId, trackLink [ 256 ], playTime ;

		JSON_GetInt ( json, "trackId", trackId ) ;
		JSON_GetInt ( json, "categoryId", categoryId ) ;
		JSON_GetString ( json, "trackLink", trackLink ) ;
		JSON_GetInt ( json, "playTime", playTime ) ;

		format ( g_aStreamSources [ playerid ] [ eStreamURL ], 256, "%s", trackLink ) ;
		format ( g_aStreamSources [ playerid ] [ eStreamName ], 256, "%s", p_info [ playerid ] [ name ] ) ;
		switch ( g_aStreamSources [ playerid ] [ eStreamType ] )
		{
			case NONE:
			{
				DestroyRecorder ( playerid ) ;
	            if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
				if ( categoryId == GENRES_RADIO )
				{
					g_aStreamSources [ playerid ] [ eStreamRepeat ] = 1 ;
					g_aStreamSources [ playerid ] [ eStreamCurrentTime ] = gettime ( ) ;
				}
				else
				{
					g_aStreamSources [ playerid ] [ eStreamRepeat ] = 0 ;
					g_aStreamSources [ playerid ] [ eStreamCurrentTime ] = gettime ( ) - playTime ;
				}
				PlayerIndividualStream ( playerid, g_aStreamSources [ playerid ] [ eStreamURL ] ) ;
				SetAttachToPlay ( playerid ) ;
			}
			case TOVEHICLE:
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 || GetPlayerState ( playerid ) != PLAYER_STATE_DRIVER )
				{
					DestroyRecorder ( playerid ) ;
					return 1 ;
				}

				if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED )
				{
					send_check_cinfo ( playerid, "¬ключение музыки в т/с доступно с 3 часов в игре!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( getVehicleSubtype ( GetPlayerVehicleID ( playerid ) ) != VEHICLE_STATE_CAR )
				{
					send_check_cinfo ( playerid, "¬ключать музыку можно только в ћјЎ»Ќј’!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				g_aStreamSources [ playerid ] [ eStreamID ] = playerid ;
				g_aStreamSources [ playerid ] [ eStreamDistance ] = 40.0 ;
				g_aStreamSources [ playerid ] [ eStreamInt ] = GetPlayerInterior ( playerid ) ;
				if ( categoryId == GENRES_RADIO )
				{
					g_aStreamSources [ playerid ] [ eStreamRepeat ] = 1 ;
					g_aStreamSources [ playerid ] [ eStreamCurrentTime ] = gettime ( ) ;
				}
				else
				{
					g_aStreamSources [ playerid ] [ eStreamRepeat ] = 0 ;
					g_aStreamSources [ playerid ] [ eStreamCurrentTime ] = gettime ( ) - playTime ;
				}
				CreateStreamSource ( playerid, playerid ) ;
				
				g_aStreamSources [ playerid ] [ eStreamType ] = TOVEHICLE ;
				g_aStreamSources [ playerid ] [ eStreamAttachType ] = TOVEHICLE ;
				g_aStreamSources [ playerid ] [ eStreamAttach ] = GetPlayerVehicleID ( playerid ) ;
				AttachStreamSource ( playerid, playerid ) ;

				veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_sound ] = playerid ;
				
				foreach(new i: streamed_players[playerid])
				{
					if ( g_aStreamSources [ i ] [ eStreamID ] == playerid )
					{
						CreateStreamSource ( i, playerid ) ;
						AttachStreamSource ( i, playerid ) ;
					}
				}
			}
			case TOPLAYER:
			{
				if ( GetPlayerVehicleID ( playerid ) != 0 || GetPlayerState ( playerid ) != PLAYER_STATE_ONFOOT )
				{
					DestroyRecorder ( playerid ) ;
					return 1 ;
				}
				
				if ( ! boombox_player [ playerid ] [ b_status ] ) 
				{
					if ( SetAddRecorder ( playerid ) == -1 ) return 1 ;
				}

				g_aStreamSources [ playerid ] [ eStreamID ] = playerid ;
				g_aStreamSources [ playerid ] [ eStreamDistance ] = 40.0 ;
				g_aStreamSources [ playerid ] [ eStreamInt ] = GetPlayerInterior ( playerid ) ;
				if ( categoryId == GENRES_RADIO )
				{
					g_aStreamSources [ playerid ] [ eStreamRepeat ] = 1 ;
					g_aStreamSources [ playerid ] [ eStreamCurrentTime ] = gettime ( ) ;
				}
				else
				{
					g_aStreamSources [ playerid ] [ eStreamRepeat ] = 0 ;
					g_aStreamSources [ playerid ] [ eStreamCurrentTime ] = gettime ( ) - playTime ;
				}
				g_aStreamSources [ playerid ] [ eStreamPos ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
				g_aStreamSources [ playerid ] [ eStreamPos ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
				g_aStreamSources [ playerid ] [ eStreamPos ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;
				CreateStreamSource ( playerid, playerid ) ;
				
				g_aStreamSources [ playerid ] [ eStreamType ] = TOPLAYER ;
				g_aStreamSources [ playerid ] [ eStreamAttachType ] = NONE ;
				g_aStreamSources [ playerid ] [ eStreamAttach ] = playerid ;
				AttachStreamSource ( playerid, playerid ) ;
				
				foreach(new i: streamed_players[playerid])
				{
					if ( g_aStreamSources [ i ] [ eStreamID ] == playerid )
					{
						CreateStreamSource ( i, playerid ) ;
						AttachStreamSource ( i, playerid ) ;
					}
				}
			}
		}
	}
	else if ( actionId == PAUSE_TRACK_REQ ) // pause music
	{
	    if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
		PlayerIndividualStream ( playerid, "" ) ;
		DestroyRecorder ( playerid ) ;
	}
	return 1 ;
}