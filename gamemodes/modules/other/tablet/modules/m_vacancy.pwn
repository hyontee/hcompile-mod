stock handleTabletVacancy ( playerid, actionId, data [ ] )
{
	if ( actionId == VACANCY_APP ) // открытие вакансий
	{
		new Node: node = JSON_Array ( ), fractionId ;
		for ( new i = 0, Node: vacancyNode ; i < sizeof FRACTION_ACTOR ; i ++ )
		{
			fractionId = FRACTION_ACTOR [ i ] [ FRACTION_ACTOR_ID ] ;
			vacancyNode = JSON_Array (
				JSON_Object (
					"id",				JSON_Int ( i ),
					"fracName",			JSON_String ( f_info [ fractionId - 1 ] [ f_name ] ),
					"fracId",			JSON_Int ( fractionId ),
					"fracDescription",	JSON_String ( FRACTION_ACTOR [ i ] [ FRACTION_DESCRIPTION ] )
				)
			) ;
			node = JSON_Append ( node, vacancyNode ) ;
		}

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, VACANCY_APP, global_string ) ;
	}
	else if ( actionId == VACANCY_APP + 1 ) // выбрал вакансию
	{
		new idx = strval ( data ) ;
        SetPlayerRaceCheckpoint ( playerid, 1, FRACTION_ACTOR [ idx ] [ INVITE_GPS ] [ 0 ], FRACTION_ACTOR [ idx ] [ INVITE_GPS ] [ 1 ], FRACTION_ACTOR [ idx ] [ INVITE_GPS ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;
	}
	return 1 ;
}