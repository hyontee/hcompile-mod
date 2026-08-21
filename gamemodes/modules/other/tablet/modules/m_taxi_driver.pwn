stock handleTabletTaxiDriver ( playerid, actionId, data [ ] )
{
	if ( actionId == TAXI_DRIVER_APP ) // открытие taxi driver
	{
		updateTaxiDriver ( playerid ) ;

		if ( taxiPassenger [ playerid ] [ 0 ] != INVALID_PLAYER_ID )
		{
			tabletMessage ( playerid, "Заказы", "У Вас уже есть активный заказ", 3, TAXI_DRIVER_APP ) ;
		}
		else updateTaxiOrder ( playerid ) ;

		p_t_info [ playerid ] [ in_taxi_driver ] = true ;
	}
	else if ( actionId == TAXI_DRIVER_APP + 1 ) // заказ
	{
		if ( GetPlayerVehicleID ( playerid ) == 0 || veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_type ] != vehicle_type_job )
		{
			tabletMessage ( playerid, "Такси", "Вы не в рабочем транспорте!", 3, TAXI_DRIVER_APP ) ;
			return true ;
		}

		if ( taxiPassenger [ playerid ] [ 0 ] != INVALID_PLAYER_ID )
		{
			tabletMessage ( playerid, "Такси", "Вы уже взяли заказ!", 3, TAXI_DRIVER_APP ) ;
			return true ;
		}

		new idx = strval ( data ), toid = taxi_order_info [ idx ] [ ORDER_ID ] ;
		if ( taxi_order_info [ idx ] [ IS_PLAYER ] )
		{
			taxiPassenger [ playerid ] [ 0 ] = toid ;
			taxiPassenger [ playerid ] [ 1 ] = 1 ;

			taxiDriverId [ toid ] = playerid ;
			if ( p_t_info [ toid ] [ in_taxi ] == true )
			{
				initFindScreen ( toid ) ;
				tabletMessage ( toid, "Такси", "Водитель найден, статус заказа обновлён", 3, TAXI_APP ) ;
			}
			else
			{
				send_check_cinfo ( toid, "Водитель найден, статус заказа обновлён", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			}

			send_check_cinfo ( playerid, "Место посадки отмечено на карте", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			is_gps_used { playerid } = 1 ;

			SetPlayerRaceCheckpoint ( playerid, 1, taxiStartPosition [ toid ] [ 0 ], taxiStartPosition [ toid ] [ 1 ], taxiStartPosition [ toid ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
		else
		{
			new actorId = createTaxiActor ( idx, toid ) ;
			taxiPassenger [ playerid ] [ 0 ] = actorId ;
			taxiPassenger [ playerid ] [ 1 ] = 0 ;

			send_check_cinfo ( playerid, "Место посадки отмечено на карте", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			is_gps_used { playerid } = 6 ;

			SetPlayerRaceCheckpoint ( playerid, 1, taxiActorStartPosition [ actorId ] [ 0 ], taxiActorStartPosition [ actorId ] [ 1 ], taxiActorStartPosition [ actorId ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
		removeTaxiOrder ( idx ) ;
		removeTaxiDriver ( idx ) ;
	}
	else if ( actionId == TAXI_DRIVER_APP + 2 ) // exit
	{
		p_t_info [ playerid ] [ in_taxi_driver ] = false ;
	}
	return 1 ;
}

stock updateTaxiDriver ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 100, "%d из %d до нового уровня", p_info [ playerid ] [ taxi_progress ], MAX_TAXI_PROGRESS ) ;
	new Node: node = JSON_Object (
		"level",		JSON_Int ( p_info [ playerid ] [ taxi_skill ] ),
		"classId",		JSON_Int ( p_info [ playerid ] [ taxi_skill ] ),
		"progress",		JSON_Int ( p_info [ playerid ] [ taxi_progress ] ),
		"max",			JSON_Int ( MAX_TAXI_PROGRESS ),
		"rate",			JSON_String ( global_string ),
		"earned",		JSON_Int ( p_info [ playerid ] [ taxi_earned ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, TAXI_DRIVER_APP, global_string ) ;
	return 1 ;
}

stock updateTaxiOrder ( playerid )
{
	new Node: node = JSON_Array ( ), itemsLoaded = 0, toid, bool: status ;
	for ( new i = 0, Node: orderNode ; i < MAX_TAXI_ORDERS ; i ++ )
	{
		toid = taxi_order_info [ i ] [ ORDER_ID ] ;
		if ( toid == INVALID_PLAYER_ID ) continue ;
		if ( taxi_order_info [ i ] [ CLASS_ID ] != p_info [ playerid ] [ taxi_skill ] ) continue ;

		status = taxi_order_info [ i ] [ IS_PLAYER ] ;
		orderNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( i ),
				"classId",		JSON_Int ( taxi_order_info [ i ] [ CLASS_ID ] ),
				"distance",		JSON_Int ( getTaxiDistance ( playerid, toid, status ) ),
				"name",			JSON_String ( getTaxiPassengerName ( i ) ),
				"price",		JSON_Int ( getTaxiPrice ( toid, status ) )
			)
		) ;

		node = JSON_Append ( node, orderNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, TAXI_DRIVER_APP + 1, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, TAXI_DRIVER_APP + 1, global_string ) ;
	}
	return 1 ;
}

stock removeTaxiDriver ( orderSlot )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", orderSlot ) ;
	foreach(new i: logged_players)
	{
		if ( p_t_info [ i ] [ in_taxi_driver ] == false ) continue ;
		onServerSendData ( i, UI_TABLET, TAXI_DRIVER_APP + 2, global_string ) ;
	}
	return 1 ;
}