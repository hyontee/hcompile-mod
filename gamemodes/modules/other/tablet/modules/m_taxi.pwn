new taxiOrderStatus [ MAX_PLAYERS ] ;

stock clear_player_taxi ( playerid )
{
	taxiOrderStatus [ playerid ] = 0 ;
	return 1 ;
}

stock handleTabletTaxi ( playerid, actionId, data [ ] )
{
	if ( actionId == TAXI_APP ) // открытие taxi
	{
		if ( taxiOrderStatus [ playerid ] == 1 )
		{
			initWaitScreen ( playerid ) ;
			return 1 ;
		}
		else if ( taxiOrderStatus [ playerid ] == 2 )
		{
			initFindScreen ( playerid ) ;
			return 1 ;
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 12, "%d", getTaxiPlayersOnline ( ) ) ;
		onServerSendData ( playerid, UI_TABLET, TAXI_APP, global_string ) ;

		static const _place [ ] [ 26 ] =
		{
			"Важные места",
			"Работы",
			"Официальные организации",
			"Автосалоны и автосервисы",
			"Прочее",
			"Квесты",
			"Поставить метку на карте"
		} ;

		new Node: node = JSON_Array ( ) ;
		for ( new i = 0, Node: placeNode ; i < sizeof _place ; i ++ )
		{
			placeNode = JSON_Array (
				JSON_String ( _place [ i ] )
			) ;

			node = JSON_Append ( node, placeNode ) ;
		}

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, TAXI_APP + 1, global_string ) ;
	}
	else if ( actionId == TAXI_APP + 1 ) // accept confirm
	{
		if ( p_info [ playerid ] [ money ] < getTaxiPrice ( playerid, true ) )
		{
			tabletMessage ( playerid, "Такси", "У Вас недостаточно средств для заказа такси", 3, TAXI_APP ) ;
			return 1 ;
		}

		taxiOrderStatus [ playerid ] = 1 ;
		initWaitScreen ( playerid ) ;

		static const _str [ ] = "* [Такси] Поступил новый заказ. (Клиент: %s, класс такси: %s)" ;
		new scm_string [ sizeof _str + 64 ] ;
		format ( scm_string, sizeof scm_string, _str, p_info [ playerid ] [ name ], taxiClassName [ taxiClassSelect [ playerid ] ] ) ;
		setTaxiDriverMessage ( taxiClassSelect [ playerid ], scm_string ) ;
	}
	else if ( actionId == TAXI_APP + 2 ) // cancel confirm
	{
		taxiOrderStatus [ playerid ] = 0 ;
		handleTabletTaxi ( playerid, TAXI_APP, "" ) ;
	}
	else if ( actionId == TAXI_APP + 3 ) // cancel wait
	{
		taxiOrderStatus [ playerid ] = 0 ;
		handleTabletTaxi ( playerid, TAXI_APP, "" ) ;

		new driverId = taxiDriverId [ playerid ] ;
		if ( driverId != INVALID_PLAYER_ID )
		{
			clear_player_job_taxi ( driverId ) ;
			clear_player_job_taxi ( playerid ) ;

			tabletMessage ( playerid, "Такси", "Вы успешно отменили заказ", 3, TAXI_APP ) ;
			send_check_cinfo ( driverId, "Игрок отменил(а) заказ!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		}
	}
	else if ( actionId == TAXI_APP + 4 ) // accept main
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new idx, classId ;
		JSON_GetInt ( json, "position", idx ) ;
		JSON_GetInt ( json, "classId", classId ) ;
		
		taxiClassSelect [ playerid ] = classId ;
		
		global_string [ 0 ] = EOS ;
		strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Информация:\t{"#cBL"}Стоимость:\n" ) ;
		if ( idx == 0 )
		{
			for ( new i = 0 ; i < gps_important_place_items ; i ++ )
			{
			    new Float:_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], gps_important_place [ i ] [ position ] [ 0 ], gps_important_place [ i ] [ position ] [ 1 ], gps_important_place [ i ] [ position ] [ 2 ] ) ;
			    format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cTN"}%s"valute_title_"\n", global_string, i + 1, gps_important_place [ i ] [ loc_name ], GetPlayerCashValueToSmile ( floatround ( _distance * ( classId + 1 ) ) * taxiMultiplie ) ) ;
			}
			show_dialog ( playerid, d_taxi_gps_0, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Важные места", global_string, "Выбрать", "Назад" ) ;
		}
		else if ( idx == 1 )
		{
			for ( new i = 0 ; i < gps_job_place_items ; i ++ )
			{
				new Float:_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], gps_job_place [ i ] [ position ] [ 0 ], gps_job_place [ i ] [ position ] [ 1 ], gps_job_place [ i ] [ position ] [ 2 ] ) ;
				format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cTN"}%s"valute_title_"\n", global_string, i + 1, gps_job_place [ i ] [ loc_name ], GetPlayerCashValueToSmile ( floatround ( _distance * ( classId + 1 ) ) * taxiMultiplie ) ) ;
			}
			show_dialog ( playerid, d_taxi_gps_1, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Работы", global_string, "Выбрать", "Назад" ) ;
		}
		else if ( idx == 2 )
		{
			for ( new i = 0 ; i < gps_govorg_place_items ; i ++ )
			{
			    new Float:_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], gps_govorg_place [ i ] [ position ] [ 0 ], gps_govorg_place [ i ] [ position ] [ 1 ], gps_govorg_place [ i ] [ position ] [ 2 ] ) ;
			    format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cTN"}%s"valute_title_"\n", global_string, i + 1, gps_govorg_place [ i ] [ loc_name ], GetPlayerCashValueToSmile ( floatround ( _distance * ( classId + 1 ) ) * taxiMultiplie ) ) ;
			}
			show_dialog ( playerid, d_taxi_gps_2, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Государственные организации", global_string, "Выбрать", "Назад" ) ;
		}
		else if ( idx == 3 )
		{
			for ( new i = 0 ; i < gps_auto_place_items ; i ++ )
			{
			    new Float:_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], gps_auto_place [ i ] [ position ] [ 0 ], gps_auto_place [ i ] [ position ] [ 1 ], gps_auto_place [ i ] [ position ] [ 2 ] ) ;
			    format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cTN"}%s"valute_title_"\n", global_string, i + 1, gps_auto_place [ i ] [ loc_name ], GetPlayerCashValueToSmile ( floatround ( _distance * ( classId + 1 ) ) * taxiMultiplie ) ) ;
			}
			show_dialog ( playerid, d_taxi_gps_4, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Автосалоны и автосервисы", global_string, "Выбрать", "Назад" ) ;
		}
		else if ( idx == 4 )
		{
			for ( new i = 0 ; i < gps_other_place_items ; i ++ )
			{
				new Float:_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], gps_other_place [ i ] [ position ] [ 0 ], gps_other_place [ i ] [ position ] [ 1 ], gps_other_place [ i ] [ position ] [ 2 ] ) ;
			    format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cTN"}%s"valute_title_"\n", global_string, i + 1, gps_other_place [ i ] [ loc_name ], GetPlayerCashValueToSmile ( floatround ( _distance * ( classId + 1 ) ) * taxiMultiplie ) ) ;
			}
			show_dialog ( playerid, d_taxi_gps_6, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Прочее", global_string, "Выбрать", "Назад" ) ;
		}
		else if ( idx == 5 )
		{
			for ( new i = 0 ; i < gps_quests_place_items ; i ++ )
			{
			    new Float:_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], gps_quests_place [ i ] [ position ] [ 0 ], gps_quests_place [ i ] [ position ] [ 1 ], gps_quests_place [ i ] [ position ] [ 2 ] ) ;
			    format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cTN"}%s"valute_title_"\n", global_string, i + 1, gps_quests_place [ i ] [ loc_name ], GetPlayerCashValueToSmile ( floatround ( _distance * ( classId + 1 ) ) * taxiMultiplie ) ) ;
			}
			show_dialog ( playerid, d_taxi_gps_7, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Квесты", global_string, "Выбрать", "Назад" ) ;
		}
		else if ( idx == 6 )
		{
			setPauseOpen ( playerid ) ;
			SetPVarInt ( playerid, "map_mark", 1 ) ;
		}
	}
	else if ( actionId == TAXI_APP + 5 ) // exit
	{
		p_t_info [ playerid ] [ in_taxi ] = false ;
	}
	return 1 ;
}

stock t_taxi_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_taxi_gps_0:
		{
			if ( ! response ) return 1 ;

			new slotId = getFreeOrderId ( ) ;
			if ( slotId == INVALID_PLAYER_ID )
			{
				tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
				return 1 ;
			}

			if ( getTaxiPlayersOnline ( ) < 1 )
			{
				tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
				return 1 ;
			}

			insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;

			taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
			taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
			taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

			taxiEndPosition [ playerid ] [ 0 ] = gps_important_place [ listitem ] [ position ] [ 0 ] ;
			taxiEndPosition [ playerid ] [ 1 ] = gps_important_place [ listitem ] [ position ] [ 1 ] ;
			taxiEndPosition [ playerid ] [ 2 ] = gps_important_place [ listitem ] [ position ] [ 2 ] ;

			initConfirmScreen ( playerid ) ;
			return 1 ;
		}
		case d_taxi_gps_1:
		{
			if ( ! response ) return 1 ;

			new slotId = getFreeOrderId ( ) ;
			if ( slotId == INVALID_PLAYER_ID )
			{
				tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
				return 1 ;
			}

			if ( getTaxiPlayersOnline ( ) < 1 )
			{
				tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
				return 1 ;
			}

			insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;

			taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
			taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
			taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

			taxiEndPosition [ playerid ] [ 0 ] = gps_job_place [ listitem ] [ position ] [ 0 ] ;
			taxiEndPosition [ playerid ] [ 1 ] = gps_job_place [ listitem ] [ position ] [ 1 ] ;
			taxiEndPosition [ playerid ] [ 2 ] = gps_job_place [ listitem ] [ position ] [ 2 ] ;

			initConfirmScreen ( playerid ) ;
			return 1 ;
		}
		case d_taxi_gps_2:
		{
			if ( ! response ) return 1 ;

			new slotId = getFreeOrderId ( ) ;
			if ( slotId == INVALID_PLAYER_ID )
			{
				tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
				return 1 ;
			}

			if ( getTaxiPlayersOnline ( ) < 1 )
			{
				tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
				return 1 ;
			}

			insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;

			taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
			taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
			taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

			taxiEndPosition [ playerid ] [ 0 ] = gps_govorg_place [ listitem ] [ position ] [ 0 ] ;
			taxiEndPosition [ playerid ] [ 1 ] = gps_govorg_place [ listitem ] [ position ] [ 1 ] ;
			taxiEndPosition [ playerid ] [ 2 ] = gps_govorg_place [ listitem ] [ position ] [ 2 ] ;

			initConfirmScreen ( playerid ) ;
			return 1 ;
		}
		case d_taxi_gps_4:
		{
			if ( ! response ) return 1 ;

			new slotId = getFreeOrderId ( ) ;
			if ( slotId == INVALID_PLAYER_ID )
			{
				tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
				return 1 ;
			}

			if ( getTaxiPlayersOnline ( ) < 1 )
			{
				tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
				return 1 ;
			}

			insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;

			taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
			taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
			taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

			taxiEndPosition [ playerid ] [ 0 ] = gps_auto_place [ listitem ] [ position ] [ 0 ] ;
			taxiEndPosition [ playerid ] [ 1 ] = gps_auto_place [ listitem ] [ position ] [ 1 ] ;
			taxiEndPosition [ playerid ] [ 2 ] = gps_auto_place [ listitem ] [ position ] [ 2 ] ;

			initConfirmScreen ( playerid ) ;
			return 1 ;
		}
		case d_taxi_gps_6:
		{
			if ( ! response ) return 1 ;

			new slotId = getFreeOrderId ( ) ;
			if ( slotId == INVALID_PLAYER_ID )
			{
				tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
				return 1 ;
			}

			if ( getTaxiPlayersOnline ( ) < 1 )
			{
				tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
				return 1 ;
			}

			insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;

			taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
			taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
			taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

			taxiEndPosition [ playerid ] [ 0 ] = gps_other_place [ listitem ] [ position ] [ 0 ] ;
			taxiEndPosition [ playerid ] [ 1 ] = gps_other_place [ listitem ] [ position ] [ 1 ] ;
			taxiEndPosition [ playerid ] [ 2 ] = gps_other_place [ listitem ] [ position ] [ 2 ] ;

			initConfirmScreen ( playerid ) ;
			return 1 ;
		}
		case d_taxi_gps_7:
		{
			if ( ! response ) return 1 ;

			new slotId = getFreeOrderId ( ) ;
			if ( slotId == INVALID_PLAYER_ID )
			{
				tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
				return 1 ;
			}

			if ( getTaxiPlayersOnline ( ) < 1 )
			{
				tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
				return 1 ;
			}

			insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;

			taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
			taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
			taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

			taxiEndPosition [ playerid ] [ 0 ] = gps_quests_place [ listitem ] [ position ] [ 0 ] ;
			taxiEndPosition [ playerid ] [ 1 ] = gps_quests_place [ listitem ] [ position ] [ 1 ] ;
			taxiEndPosition [ playerid ] [ 2 ] = gps_quests_place [ listitem ] [ position ] [ 2 ] ;

			initConfirmScreen ( playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock t_taxi_OnPlayerClickMap ( playerid, Float: fX, Float: fY, Float: fZ )
{
	if ( GetPVarInt ( playerid, "map_mark" ) )
	{
		DeletePVar ( playerid, "map_mark" ) ;

		new slotId = getFreeOrderId ( ) ;
		if ( slotId == INVALID_PLAYER_ID )
		{
			tabletMessage ( playerid, "Такси", "В данный момент нет возможности заказать такси, попробуйте позднее", 3, TAXI_APP ) ;
			return 1 ;
		}

		if ( getTaxiPlayersOnline ( ) < 1 )
		{
			tabletMessage ( playerid, "Такси", "Работающих таксистов сейчас нет", 3, TAXI_APP ) ;
			return 1 ;
		}

		insertTaxiOrder ( slotId, playerid, taxiClassSelect [ playerid ], true ) ;
		
		taxiStartPosition [ playerid ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
		taxiStartPosition [ playerid ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
		taxiStartPosition [ playerid ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

		taxiEndPosition [ playerid ] [ 0 ] = fX ;
		taxiEndPosition [ playerid ] [ 1 ] = fY ;
		taxiEndPosition [ playerid ] [ 2 ] = fZ ;

		initConfirmScreen ( playerid ) ;
		return 1 ;
	}
	return 0 ;
}

stock initConfirmScreen ( playerid )
{
	new Node: node = JSON_Object (
		"drivers",		JSON_Int ( getTaxiPlayersOnline ( ) ),
		"price",		JSON_Int ( getTaxiPrice ( playerid, true ) )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, TAXI_APP + 2, global_string ) ;
	return 1 ;
}

stock initWaitScreen ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", getTaxiPlayersOnline ( ) ) ;
	onServerSendData ( playerid, UI_TABLET, TAXI_APP + 3, global_string ) ;
	return 1 ;
}

stock initFindScreen ( playerid )
{
	new driverID = taxiDriverId [ playerid ] ;
	new Node: node = JSON_Object (
		"drivers",		JSON_Int ( getTaxiPlayersOnline ( ) ),
		"price",		JSON_Int ( getTaxiPrice ( playerid, true ) ),
		"classId",		JSON_Int ( p_info [ driverID ] [ taxi_skill ] ),
		"driver",		JSON_String ( p_info [ driverID ] [ name ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, TAXI_APP + 4, global_string ) ;
	return 1 ;
}

#define PACKET_CUSTOMRPC    			251
#define RPC_PAUSE_OPEN					0x152

stock setPauseOpen ( playerid )
{
	#if defined debug_packet
		printf ( "[setPauseOpen] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PAUSE_OPEN);
	
    PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
}