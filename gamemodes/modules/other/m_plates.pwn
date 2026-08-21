static const PLATE_UPDATE_PRICE = 2000 ;
static const PLATE_PURCHASE_PRICE = 5000 ;

new Cache: ownedPlatesCache [ MAX_PLAYERS ] ;
new Cache: sellingPlatesCache ;
new bool: checkPlatesAvailable [ MAX_PLAYERS ] = { false, ... } ;

new g_licence_plates_region [ 4 ] [ 5 ] = { "RU", "UA", "KZ", "BY" } ;

enum E_LIC_PLATE_SYS_STRUCT
{
    LPS_SELECTED_REGION_ID,
	LPS_NUMBER [ 24 ],
	LPS_REGION [ 12 ],
    LPS_NUMBER_RU [ 24 ],
    LPS_REGION_RU [ 12 ],
    LPS_NUMBER_UA [ 24 ],
    LPS_REGION_UA [ 12 ],
    LPS_NUMBER_KZ [ 24 ],
    LPS_REGION_KZ [ 12 ],
    LPS_NUMBER_BY [ 24 ],
    LPS_REGION_BY [ 12 ],
    LPS_FINE_SUM
} ;
new g_licence_plate_system [ MAX_PLAYERS ] [ E_LIC_PLATE_SYS_STRUCT ] ;

new g_licence_plate_system_def_val [ E_LIC_PLATE_SYS_STRUCT ] =
{
    -1,
    EOS,
    EOS,
    EOS,
    EOS,
    EOS,
    EOS,
    EOS,
    EOS,
    EOS,
    EOS,
    0
} ;

enum 
{
    LICENCE_PLATE_REGION_RU,
    LICENCE_PLATE_REGION_UA,
    LICENCE_PLATE_REGION_KZ,
    LICENCE_PLATE_REGION_BY,
    LICENCE_PLATE_REGION_RU_POLICE
} ;

stock GenerateLicencePlates ( playerid, regionid )
{
    switch ( regionid )
    {
        case LICENCE_PLATE_REGION_RU:
        {
            static const regions [ 14 ] [ 4 ] = { "77", "97", "99", "78", "98", "178", "198", "177", "197", "199", "777", "797", "799", "977" } ;
            static const chars [ 12 ] = { 'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'Y', 'X' } ;

			if ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_RU ] == EOS )
			{
				format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_RU ], 24, "\
					%c%d%d%d%c%c",
					chars [ random ( sizeof chars ) ],
					random ( 10 ), random ( 10 ), random ( 10 ),
					chars [ random ( sizeof chars ) ], chars [ random ( sizeof chars ) ]
				) ;

				format ( g_licence_plate_system [ playerid ] [ LPS_REGION_RU ], 4, "%s", regions [ random ( sizeof regions ) ] ) ; 
			}
			format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER ], 24, "%s", g_licence_plate_system [ playerid ] [ LPS_NUMBER_RU ] ) ;
			format ( g_licence_plate_system [ playerid ] [ LPS_REGION ], 12, "%s", g_licence_plate_system [ playerid ] [ LPS_REGION_RU ] ) ;                            
        }
        case LICENCE_PLATE_REGION_UA:
        {
            static const regions [ ] [ 3 ] = { "AC", "BB", "BK", "AM", "AH", "AA", "CB", "EH", "AE", "CC" } ;
            static const chars [ 11 ] = { 'A', 'B', 'C', 'E', 'H', 'K', 'M', 'O', 'P', 'T', 'X' } ;

			if ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_UA ] == EOS )
			{
				format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_UA ], 24, "\
					%d%d%d%d %c%c",
					random ( 10 ), random ( 10 ), random ( 10 ), random ( 10 ),
					chars [ random ( sizeof chars ) ], chars [ random ( sizeof chars ) ]
				) ;

				format ( g_licence_plate_system [ playerid ] [ LPS_REGION_UA ], 3, "%s", regions [ random ( sizeof regions ) ] ) ;
			}
			format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER ], 24, "%s", g_licence_plate_system [ playerid ] [ LPS_NUMBER_UA ] ) ;
			format ( g_licence_plate_system [ playerid ] [ LPS_REGION ], 12, "%s", g_licence_plate_system [ playerid ] [ LPS_REGION_UA ] ) ;                            
        }
        case LICENCE_PLATE_REGION_KZ:
        {           
            static const chars [ 12 ] = { 'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'Y', 'X' } ;

			if ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_KZ ] == EOS )
			{
				format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_KZ ], 24, "\
					%d%d%d %c%c%c", 
					random ( 10 ), random ( 10 ), random ( 10 ),
					chars [ random ( sizeof chars ) ], chars [ random ( sizeof chars ) ], chars [ random ( sizeof chars ) ]
				) ;             

				new randomRegion = random ( 21 ) + 1 ;  
				format ( g_licence_plate_system [ playerid ] [ LPS_REGION_KZ ], 3, "%s%d", ( randomRegion < 10 ) ? ( "0" ) : ( "" ), randomRegion ) ;
			}
        	format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER ], 24, "%s", g_licence_plate_system [ playerid ] [ LPS_NUMBER_KZ ] ) ;
			format ( g_licence_plate_system [ playerid ] [ LPS_REGION ], 12, "%s", g_licence_plate_system [ playerid ] [ LPS_REGION_KZ ] ) ;                            
        }
        case LICENCE_PLATE_REGION_BY:
        {
            static const chars [ 11 ] = { 'A', 'B', 'C', 'E', 'K', 'M', 'H', 'P', 'O', 'T', 'X' } ;

			if ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_BY ] == EOS )
			{
				format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER_BY ], 24, "\
					%d%d%d%d %c%c", 
					random ( 10 ), random ( 10 ), random ( 10 ), random ( 10 ),
					chars [ random ( sizeof chars ) ], chars [ random ( sizeof chars ) ]
				) ;

				new randomRegion = random ( 8 ) + 1 ;
				format ( g_licence_plate_system [ playerid ] [ LPS_REGION_BY ], 2, "%d", randomRegion ) ;
			}
        	format ( g_licence_plate_system [ playerid ] [ LPS_NUMBER ], 24, "%s", g_licence_plate_system [ playerid ] [ LPS_NUMBER_BY ] ) ;
			format ( g_licence_plate_system [ playerid ] [ LPS_REGION ], 12, "%s", g_licence_plate_system [ playerid ] [ LPS_REGION_BY ] ) ;                            
        }
    }
    return true ;
}

stock resetLicensePlates ( playerid, regionid )
{
	switch ( regionid )
	{
		case LICENCE_PLATE_REGION_RU:
		{
			g_licence_plate_system [ playerid ] [ LPS_NUMBER_RU ] = EOS ;
			g_licence_plate_system [ playerid ] [ LPS_REGION_RU ] = EOS ;
		}
		case LICENCE_PLATE_REGION_UA:
		{
			g_licence_plate_system [ playerid ] [ LPS_NUMBER_UA ] = EOS ;
			g_licence_plate_system [ playerid ] [ LPS_REGION_UA ] = EOS ;
		}
		case LICENCE_PLATE_REGION_KZ:
		{
			g_licence_plate_system [ playerid ] [ LPS_NUMBER_KZ ] = EOS ;
			g_licence_plate_system [ playerid ] [ LPS_REGION_KZ ] = EOS ;
		}
		case LICENCE_PLATE_REGION_BY:
		{
			g_licence_plate_system [ playerid ] [ LPS_NUMBER_BY ] = EOS ;
			g_licence_plate_system [ playerid ] [ LPS_REGION_BY ] = EOS ;
		}
	}
}

stock show_window_plate ( playerid )
{
	#if defined debug_packet
		printf ( "[show_window_plate] playerid: %d", playerid ) ;
	#endif

	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_LICENCE_PLATES, 0, global_string ) ;

	new Node: node = JSON_Object (
    	"costLicensePlates",        	JSON_Int ( 5000 ),
    	"costChangingLicencePlates",	JSON_Int ( 2000 )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_LICENCE_PLATES, 1, global_string ) ;
    
	p_t_info [ playerid ] [ in_license_menu ] = true ;

	UpdateOwnedPlatesCache ( playerid, 1, 1 ) ;
    ShowCharacterTickets ( playerid, 1 ) ;
	CheckPlatesMarketTimer ( ) ;
	toggle_controlable ( playerid, false ) ;

	checkPlatesAvailable [ playerid ] = false ;
}

stock show_packet_plates ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
        for ( new idx = 0 ; idx < 4 ; idx ++ )
      	{
            if ( strfind ( g_licence_plates_region [ idx ], data ) != -1 )
            {
               	g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] = idx ;

                ShowPlayerHoldingPlates ( playerid, 1 ) ;
              	break ;
            }
        }
	}
	else if ( actionId == 1 )
	{
		if ( checkPlatesAvailable [ playerid ] )
			return true ;

		if ( g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] == -1 )
		{
			send_check_cinfo ( playerid, "Сначала нужно выбрать страну!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return true ;
		}

		if ( p_info [ playerid ] [ money ] < PLATE_UPDATE_PRICE )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return true ;
		}

		checkPlatesAvailable [ playerid ] = true ;
		
		give_money ( playerid, -PLATE_UPDATE_PRICE ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -PLATE_UPDATE_PRICE, "Изменение номерного знака" ) ;
        UpdatePlayerCash ( playerid ) ;

        new regionid = g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ;
		resetLicensePlates ( playerid, regionid ) ;
        GenerateLicencePlates ( playerid, regionid ) ;
        CheckIsPlateAvailable ( playerid, 1 ) ;
	}
	else if ( actionId == 2 )
	{
        if ( g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] == -1 )
		{
			send_check_cinfo ( playerid, "Сначала нужно выбрать страну!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		static const _str [ ] = "SELECT IFNULL(count(id), 0) AS licence_plate_count FROM licence_plate WHERE licence_plate_char_id = %d" ;
		new query_string [ sizeof _str + 9 ] ;
        format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
        mysql_tquery ( sql_connection, query_string, "BuyLicencePlate", "i", playerid ) ;
	}
	else if ( actionId == 3 )
	{
		new platesId = strval ( data ) ;
		OwnedPlatesLeftActionButton ( playerid, platesId ) ;
	}
	else if ( actionId == 4 )
	{
		new platesId = strval ( data ) ;
		OwnedPlatesRightActionButton ( playerid, platesId ) ;
	}
	else if ( actionId == 5 ) // buy plate
	{
		if ( ! cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) ) {
        	send_check_cinfo ( playerid, "Произошла неведомая ошибка. Перезайдите в интерфейс и попробуйте снова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

        cache_set_active ( ownedPlatesCache [ playerid ], sql_connection ) ;

		new rows, fields ;
		cache_get_data ( rows, fields ) ;

    	if ( rows + 1 > p_info [ playerid ] [ max_veh ] )
		{
            send_check_cinfo ( playerid, "Лимит на покупку номеров исчерпан, необходимо купить ещё слоты для транспорта.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
        }

        new Node: node ;      
        JSON_Parse ( data, node ) ;

        new platesId, platesPrice ;
        JSON_GetInt ( node, "id", platesId ) ;
        JSON_GetInt ( node, "price", platesPrice ) ;

        BuyPlates ( playerid, platesId, platesPrice ) ;
	}
	else if ( actionId == 6 ) // pay all tickets
	{
		if ( p_info [ playerid ] [ money ] < g_licence_plate_system [ playerid ] [ LPS_FINE_SUM ] )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
        }

		give_money ( playerid, -g_licence_plate_system [ playerid ] [ LPS_FINE_SUM ] ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -g_licence_plate_system [ playerid ] [ LPS_FINE_SUM ], "Оплата всех штрафов" ) ;

        ResetCharacterTickets ( playerid ) ;
        onServerSendData ( playerid, UI_LICENCE_PLATES, 11, "" ) ;
	}
	else if ( actionId == 7 ) // exit
	{
		static const _str [ ] = "DELETE FROM licence_plate_hold WHERE licence_plate_hold_char_id = %d" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string ) ;

		ClearOwnedPlatesCache ( playerid ) ;
		toggle_controlable ( playerid, true ) ;
	}
	return 1 ;
}

callback: loaded_player_plates ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	new _id, _vehicle_id, _region [ 12 ], _plate [ 12 ], _country [ 12 ], _country_id ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
		_id = cache_get_field_content_int ( i, "id" ) ;
		_vehicle_id = cache_get_field_content_int ( i, "licence_plate_use_own_car_id" ) ;
		cache_get_field_content ( i, "licence_plate_country", _country ) ;
		cache_get_field_content ( i, "licence_plate_number", _plate ) ;
		cache_get_field_content ( i, "licence_plate_region", _region ) ;
		for ( new q = 0 ; q < MAX_INVENTORY_SLOTS ; q ++ )
		{
			if ( USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_TYPE ] != RENDER_TYPE_PLATE ) continue ;
			if ( USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_ID ] != _id ) continue ;

			format ( USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_REGION ], 12, "%s", _region ) ;
			format ( USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_PLATE ], 12, "%s", _plate ) ;

			if ( ! strcmp ( _country, "RU POLICE" ) ) _country_id = NUMBERPLATE_TYPE_RU_POLICE ;
			else if ( ! strcmp ( _country, "RU" ) ) _country_id = NUMBERPLATE_TYPE_RUS ;
			else if ( ! strcmp ( _country, "UA" ) ) _country_id = NUMBERPLATE_TYPE_UA ;
			else if ( ! strcmp ( _country, "BY" ) ) _country_id = NUMBERPLATE_TYPE_BY ;
			else if ( ! strcmp ( _country, "KZ" ) ) _country_id = NUMBERPLATE_TYPE_KZ ;

			if ( _country_id > 1 )
			{
				format ( USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_REGION ], 12, "%s", _region ) ;
				format ( USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_PLATE ], 12, "%s", _plate ) ;
				
				USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_PLATE_TYPE ] = _country_id ;
				USERS_INVENTORY [ playerid ] [ q ] [ INV_ITEM_GIVE_DATE ] = _vehicle_id ;
			}
			break ;
		}
	}
	return 1 ;
}

callback: ShowCharacterTickets ( playerid, init )
{
    if ( init )
    {
		static const _str [ ] = "SELECT * FROM users_tickets WHERE u_id = %d" ;
		new query_string [ sizeof _str + 9 ] ;
        format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
        mysql_tquery ( sql_connection, query_string, "ShowCharacterTickets", "ii", playerid, 0 ) ;
    }
    else
    {
        new rows, fields ;
		cache_get_data ( rows, fields ) ;
        if ( rows )
        {
            new Node: node = JSON_Array ( ) ;

            g_licence_plate_system [ playerid ] [ LPS_FINE_SUM ] = 0 ;

            new ticketId, 
                ticketType [ 12 ],
                ticketDate [ 12 ], 
                carNumber [ 24 ],
                carModel, 
                ticketValue ;

            for ( new idx = 0, Node: ticketNode, ticketsLoaded ; idx < rows ; idx ++ )
            {
                ticketId = cache_get_field_content_int ( idx, "id" ) ;
                carModel = cache_get_field_content_int ( idx, "car_model" ) ;
                ticketValue = cache_get_field_content_int ( idx, "fine_value" ) ;

                g_licence_plate_system [ playerid ] [ LPS_FINE_SUM ] += ticketValue ;

                cache_get_field_content ( idx, "fine_type", ticketType ) ;
                cache_get_field_content ( idx, "fine_date", ticketDate ) ;
                cache_get_field_content ( idx, "car_number", carNumber ) ;

				if ( carModel == 0 )
				{
					ticketNode = JSON_Array (
						JSON_Object (
							"fineId", 		JSON_Int ( ticketId ),
							"type", 		JSON_String ( ticketType ),
							"date",	 		JSON_String ( ticketDate ),
							"carName", 		JSON_String ( "" ),
							"carNumber", 	JSON_String ( carNumber ),
							"finePrice", 	JSON_Int ( ticketValue )
						)
					) ;
				}
				else
				{
					ticketNode = JSON_Array (
						JSON_Object (
							"fineId", 		JSON_Int ( ticketId ),
							"type", 		JSON_String ( ticketType ),
							"date",	 		JSON_String ( ticketDate ),
							"carName", 		JSON_String ( GetVehicleNameEx ( INVALID_VEHICLE_ID, carModel ) ),
							"carNumber", 	JSON_String ( carNumber ),
							"finePrice", 	JSON_Int ( ticketValue )
						)
					) ;
				}
                node = JSON_Append ( node, ticketNode ) ;

                if ( ++ ticketsLoaded == 10 || idx == rows - 1 )
                {
					global_string [ 0 ] = EOS ;
                    JSON_Stringify ( node, global_string, sizeof global_string ) ;
                    onServerSendData ( playerid, UI_LICENCE_PLATES, 10, global_string ) ;

                    ticketsLoaded = 0 ;
                    node = JSON_Array ( ) ;
                }
            }

			global_string [ 0 ] = EOS ;
            format ( global_string, 11, "%d", g_licence_plate_system [ playerid ] [ LPS_FINE_SUM ] ) ;
            onServerSendData ( playerid, UI_LICENCE_PLATES, 9, global_string ) ;
        }        
        p_info [ playerid ] [ ticket_c ] = rows ;
    }
    return true ;
}

stock ResetCharacterTickets ( playerid )
{
	static const _str [ ] = "DELETE FROM `users_tickets` WHERE `u_id` = '%d' LIMIT %d" ;
	new query_string [ sizeof _str + ( 9 * 2 ) ] ;
    format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], p_info [ playerid ] [ ticket_c ] ) ;
    mysql_tquery ( sql_connection, query_string ) ;

    p_info [ playerid ] [ ticket_c ] = 0 ;
    return true ;
}

static stock OwnedPlatesLeftActionButton ( playerid, platesId )
{
    /* Установить; снять с авто; снять с продажи */

    if ( ! cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) ) {
		send_check_cinfo ( playerid, "Произошла неведомая ошибка. Перезайдите в интерфейс и попробуйте снова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    cache_set_active ( ownedPlatesCache [ playerid ], sql_connection ) ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;

    new sqlPlatePrice,
        sqlPlateCar,
		sqlPlateId,
		sqlPlateRegion [ 8 ],
		sqlPlateNumber [ 24 ],
		sqlPlateCountry [ 8 ] ;

    for ( new idx = 0 ; idx < rows ; idx ++ )
    {
		sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
        if ( sqlPlateId != platesId ) continue ;

		sqlPlateCar = cache_get_field_content_int ( idx, "licence_plate_use_own_car_id" ) ;
		sqlPlatePrice = cache_get_field_content_int ( idx, "licence_plate_price" ) ;

        if ( sqlPlatePrice > 0 ) // Снять с продажи
        {
			cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
			cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
			cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

            new Node: node = JSON_Object (
                "id",           JSON_Int ( sqlPlateId ),
                "region",       JSON_String ( sqlPlateRegion ),
                "number",       JSON_String ( sqlPlateNumber ),
                "country",      JSON_String ( sqlPlateCountry ),
                "status",       JSON_String ( "notInstalled" ),
                "sellPrice",    JSON_Int ( 0 ),
                "carName",      JSON_String ( "" )
            ) ;

			global_string [ 0 ] = EOS ;
            JSON_Stringify ( node, global_string, sizeof global_string ) ;
            onServerSendData ( playerid, UI_LICENCE_PLATES, 4, global_string ) ;  

			global_string [ 0 ] = EOS ;
            format ( global_string, 144, "UPDATE licence_plate SET licence_plate_price=0 WHERE id=%d AND licence_plate_char_id=%d LIMIT 1", platesId, p_info [ playerid ] [ id ] ) ;
            mysql_tquery ( sql_connection, global_string ) ;

            UpdatePlatesForSaleCache ( 1 ) ;
            UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;

            RemovePlateFromSale ( sqlPlateId ) ;
        }
        else if ( sqlPlateCar != 0 )  // Снять с ТС
        {
			cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
			cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
			cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

            new Node: node = JSON_Object (
                "id",           JSON_Int ( sqlPlateId ),
                "region",       JSON_String ( sqlPlateRegion ),
                "number",       JSON_String ( sqlPlateNumber ),
                "country",      JSON_String ( sqlPlateCountry ),
                "status",       JSON_String ( "notInstalled" ),
                "sellPrice",    JSON_Int ( 0 ),
                "carName",      JSON_String ( "" )
            ) ;

			global_string [ 0 ] = EOS ;
            JSON_Stringify ( node, global_string, sizeof global_string ) ;
            onServerSendData ( playerid, UI_LICENCE_PLATES, 4, global_string ) ;  

			foreach(new _v_id: player_vehicles[playerid])
			{
				if ( veh_info [ _v_id - 1 ] [ v_id ] != sqlPlateCar ) continue ;
				
				format ( veh_info [ _v_id - 1 ] [ v_plate ], 12, "Transit" ) ;
				SetVehicleNumberPlate ( _v_id, veh_info [ _v_id - 1 ] [ v_plate ] ) ;
				veh_info [ _v_id - 1 ] [ v_plate_type ] = 1 ;

				foreach(new forplayerid: streamed_in_vehicles[_v_id])
				{
					sc_OnVehicleStreamIn ( _v_id, forplayerid ) ;
				}
				break ;
			}

			global_string [ 0 ] = EOS ;
            format ( global_string, 144, "UPDATE licence_plate SET licence_plate_use_own_car_id=NULL WHERE id=%d AND licence_plate_char_id=%d LIMIT 1", platesId, p_info [ playerid ] [ id ] ) ;
            mysql_tquery ( sql_connection, global_string ) ;

            UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;
        }
        else // Установить на ТС
        {
			set_player_use_listitem ( playerid, sqlPlateId ) ;

			static const _str [ ] = "\
                SELECT uv.v_id, uv.v_model, uv.v_fine \
                FROM users_vehicles uv \
                LEFT JOIN licence_plate lp ON lp.licence_plate_use_own_car_id = uv.v_id \
                WHERE uv.v_owner = %d \
                AND COALESCE(lp.licence_plate_use_own_car_id, 0) = 0 LIMIT %d" ;
			new query_string [ sizeof _str + ( 2 * 9 ) ] ;
            format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], p_info [ playerid ] [ max_veh ] ) ;
            mysql_tquery ( sql_connection, query_string, "EstablishOwnableCarNumber", "i", playerid ) ;
        }
        break ;
    }
    return true ;
}

callback: EstablishOwnableCarNumber ( playerid )
{
    if ( ! cache_num_rows ( ) )
	{
		send_check_cinfo ( playerid, "У Вас нет авто, на которые можно установить номера.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

    new sql_id,
		rows = cache_num_rows ( ),
		modelid,
		fmt_str [ 100 ],
		bool: carLoaded,
		_fine ;

    global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Марка:\t{"#cBL"}Номерной знак:\t{"#cBL"}Статус:\n{"#cWH"}" ) ;
    for ( new idx = 0 ; idx < rows ; idx ++ )
    {
		sql_id = cache_get_field_content_int ( idx, "v_id" ) ;
        modelid = cache_get_field_content_int ( idx, "v_model" ) ;
		_fine = cache_get_field_content_int ( idx, "v_fine" ) ;

		if ( _fine == 2 )
		{
			format ( fmt_str, sizeof fmt_str, "{"#cBL"}%d. {FFFFFF}%s\tОтсутствует\tВ семье\n",
			idx + 1, GetVehicleNameEx ( INVALID_VEHICLE_ID, modelid ) ) ;
			strcat ( global_string, fmt_str ) ;
		}
		else
		{
			carLoaded = false ;
			foreach(new _v_id: player_vehicles[playerid])
			{
				if ( veh_info [ _v_id - 1 ] [ v_id ] != sql_id ) continue ;

				carLoaded = true ;
				break ;
			}

			format ( fmt_str, sizeof fmt_str, "{"#cBL"}%d. {FFFFFF}%s\tОтсутствует\t%s\n",
			idx + 1, GetVehicleNameEx ( INVALID_VEHICLE_ID, modelid ), carLoaded ? "Загружена" : "Выгружена" ) ;
			strcat ( global_string, fmt_str ) ;
		}

		set_player_listitem_values ( playerid, idx, sql_id ) ;
		set_player_param_values ( playerid, idx, modelid ) ;
	}

	show_dialog ( playerid, d_set_vehicle_plates, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Личный транспорт", global_string, "Выбрать", "Отмена" ) ;
    return true ;
}

stock plates_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_set_vehicle_plates:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				clear_player_param_values ( playerid ) ;
				return 1 ;
			}

			if ( ! cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) ) {
				send_check_cinfo ( playerid, "Произошла неведомая ошибка. Перезайдите в интерфейс и попробуйте снова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

            cache_set_active ( ownedPlatesCache [ playerid ], sql_connection ) ;

			new rows, fields ;
			cache_get_data ( rows, fields ) ;

            new _id = get_player_listitem_values ( playerid, listitem ),
				modelid = get_player_param_values ( playerid, listitem ),
				platesId = get_player_use_listitem ( playerid ), 
				sqlPlateId ;
            for ( new idx = 0 ; idx < rows ; idx ++ )
            {
				sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
                if ( platesId != sqlPlateId ) continue ;
                
                new sqlPlateRegion [ 12 ], sqlPlateNumber [ 24 ], sqlPlateCountry [ 8 ] ;
				cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
				cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
				cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

                // Ваши номера
                new vehicleid = INVALID_VEHICLE_ID ;
				foreach(new _v_id: player_vehicles[playerid])
				{
					if ( veh_info [ _v_id - 1 ] [ v_id ] != _id ) continue ;

					vehicleid = _v_id ;
					break ;
				}

                new Node: node = JSON_Object (
                    "id",           JSON_Int ( sqlPlateId ),
                    "region",       JSON_String ( sqlPlateRegion ),
                    "number",       JSON_String ( sqlPlateNumber ),
                    "country",      JSON_String ( sqlPlateCountry ),
                    "status",       JSON_String ( "installed" ),
                    "sellPrice",    JSON_Int ( 0 ),
                    "carName",      JSON_String ( GetVehicleNameEx ( INVALID_VEHICLE_ID, modelid ) )
                ) ;

				global_string [ 0 ] = EOS ;
                JSON_Stringify ( node, global_string, sizeof global_string ) ;
                onServerSendData ( playerid, UI_LICENCE_PLATES, 4, global_string ) ;  

                if ( vehicleid != INVALID_VEHICLE_ID )
                {
                    format ( veh_info [ vehicleid - 1 ] [ v_plate ], 12, "%s", sqlPlateNumber ) ;
                    format ( veh_info [ vehicleid - 1 ] [ v_region ], 12, "%s", sqlPlateRegion ) ;

					if ( ! strcmp ( sqlPlateCountry, "RU POLICE" ) ) veh_info [ vehicleid - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_RU_POLICE ;
					else if ( ! strcmp ( sqlPlateCountry, "RU" ) ) veh_info [ vehicleid - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_RUS ;
					else if ( ! strcmp ( sqlPlateCountry, "UA" ) ) veh_info [ vehicleid - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_UA ;
					else if ( ! strcmp ( sqlPlateCountry, "BY" ) ) veh_info [ vehicleid - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_BY ;
					else if ( ! strcmp ( sqlPlateCountry, "KZ" ) ) veh_info [ vehicleid - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_KZ ;

					foreach(new forplayerid: streamed_in_vehicles[vehicleid])
					{
						sc_OnVehicleStreamIn ( vehicleid, forplayerid ) ;
					}
                }

				static const _str [ ] = "\
                    UPDATE licence_plate \
                    SET licence_plate_use_own_car_id=%d WHERE id=%d AND licence_plate_char_id=%d" ;
				new query_string [ sizeof _str + ( 3 * 9 ) ] ;
                format ( query_string, sizeof query_string, _str, _id, platesId, p_info [ playerid ] [ id ] ) ;
                mysql_tquery ( sql_connection, query_string ) ;

                UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;

                clear_player_listitem_values ( playerid ) ;
				clear_player_param_values ( playerid ) ;

                send_check_cinfo ( playerid, "Вы успешно установили номера.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				break ;
            }
			return 1 ;
		}
		case d_plates_change_price:
		{
			if ( ! response ) return 1 ;

			new platesPrice = strval ( inputtext ) ;
			if ( platesPrice < 50_000 || platesPrice > 10_000_000 )
			{
				send_check_cinfo ( playerid, "Стоимость введена некорректно.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( ! cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) ) 
			{
				send_check_cinfo ( playerid, "Произошла неведомая ошибка. Перезайдите в интерфейс и попробуйте снова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			cache_set_active ( ownedPlatesCache [ playerid ], sql_connection ) ;

			new rows, fields ;
			cache_get_data ( rows, fields ) ;

			new platesId = GetPVarInt ( playerid, "sellplates:plateid" ) ;
			for ( new idx = 0, sqlPlateId, sqlOwnerId ; idx < rows ; idx ++ )
			{
				sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
				if ( sqlPlateId != platesId ) continue ;

				sqlOwnerId = cache_get_field_content_int ( idx, "licence_plate_char_id" ) ;

				if ( p_info [ playerid ] [ id ] != sqlOwnerId )
				{
					send_check_cinfo ( playerid, "Произошла ошибка при смены стоимости номера.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				// Ваши номера
                new sqlPlateRegion [ 8 ], sqlPlateNumber [ 24 ], sqlPlateCountry [ 8 ] ;
				cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
				cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
				cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

				new Node:node = JSON_Object (
					"id",           JSON_Int ( sqlPlateId ),
					"region",       JSON_String ( sqlPlateRegion ),
					"number",       JSON_String ( sqlPlateNumber ),
					"country",      JSON_String ( sqlPlateCountry ),
					"status",       JSON_String ( "selling" ),
					"sellPrice",    JSON_Int ( platesPrice ),
					"carName",      JSON_String ( "" )
				) ;

				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_LICENCE_PLATES, 4, global_string ) ;  

				// Купить номера
				node = JSON_Object (
					"id",       JSON_Int ( platesId ),
					"price",    JSON_Int ( platesPrice )
				);

				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;

				foreach(new i: logged_players)
				{
					if ( p_t_info [ i ] [ in_license_menu ] == false ) continue ;
					onServerSendData ( i, UI_LICENCE_PLATES, 7, global_string ) ; 
				}

				static const _str [ ] = "UPDATE licence_plate SET licence_plate_price=%d WHERE id=%d AND licence_plate_char_id=%d LIMIT 1" ;
				new query_string [ sizeof _str + ( 3 * 9 ) ] ;
				format ( query_string, sizeof query_string, _str, platesPrice, platesId, p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				UpdatePlatesForSaleCache ( 1 ) ;
				UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;

				send_check_cinfo ( playerid, "Вы успешно изменили стоимость номера.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				break ;
			}
			return 1 ;
		}
		case d_sell_license_plates:
		{
			if ( ! response ) return 1 ;

			new platesPrice = strval ( inputtext ) ;
			if ( platesPrice < 50_000 || platesPrice > 10_000_000 )
			{
				send_check_cinfo ( playerid, "Стоимость введена некорректно.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( ! cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) ) 
			{
				send_check_cinfo ( playerid, "Произошла неведомая ошибка. Перезайдите в интерфейс и попробуйте снова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			cache_set_active ( ownedPlatesCache [ playerid ], sql_connection ) ;

			new rows, fields ;
			cache_get_data ( rows, fields ) ;

			new platesId = GetPVarInt ( playerid, "sellplates:plateid" ) ;
			for ( new idx = 0, sqlPlateId, sqlOwnerId ; idx < rows ; idx ++ )
			{
				sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
				if ( sqlPlateId != platesId ) continue ;

				sqlOwnerId = cache_get_field_content_int ( idx, "licence_plate_char_id" ) ;

				if ( p_info [ playerid ] [ id ] != sqlOwnerId )
				{
					send_check_cinfo ( playerid, "Произошла ошибка при смены стоимости номера.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				// Ваши номера
                new sqlPlateRegion [ 8 ], sqlPlateNumber [ 24 ], sqlPlateCountry [ 8 ] ;
				cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
				cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
				cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

				// Ваши номера
				new Node:node = JSON_Object (
					"id",           JSON_Int ( sqlPlateId ),
					"region",       JSON_String ( sqlPlateRegion ),
					"number",       JSON_String ( sqlPlateNumber ),
					"country",      JSON_String ( sqlPlateCountry ),
					"status",       JSON_String ( "selling" ),
					"sellPrice",    JSON_Int ( platesPrice ),
					"carName",      JSON_String ( "" )
				) ;

				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_LICENCE_PLATES, 4, global_string ) ;  

				// Купить номера
				node = JSON_Array (
					JSON_Object (
						"id",           JSON_Int ( sqlPlateId ),
						"region",       JSON_String ( sqlPlateRegion ),
						"number",       JSON_String ( sqlPlateNumber ),
						"country",      JSON_String ( sqlPlateCountry ),
						"sellerName",   JSON_String ( p_info [ playerid ] [ name ] ),
						"price",        JSON_Int ( platesPrice )
					)
				) ;

				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				foreach(new i: logged_players)
				{
					if ( p_t_info [ i ] [ in_license_menu ] == false ) continue;
					onServerSendData ( i, UI_LICENCE_PLATES, 6, global_string ) ; 
				}

				static const _str [ ] = "\
					UPDATE licence_plate SET licence_plate_price=%d, licence_plate_sell_end=%d \
					WHERE id=%d AND licence_plate_char_id=%d LIMIT 1" ;
				new query_string [ sizeof _str + ( 4 * 9 ) ] ;
				format ( query_string, sizeof query_string, _str, platesPrice, gettime ( ) + 86_400, platesId, p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				UpdatePlatesForSaleCache ( 1 ) ;
				UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;

				send_check_cinfo ( playerid, "Вы успешно установили номера на продажу\nСрок действия продажи - 24 часа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				break ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

static stock OwnedPlatesRightActionButton ( playerid, platesId ) 
{
    /* Продать; изменить цену */

    if ( ! cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) ) {
		send_check_cinfo ( playerid, "Произошла неведомая ошибка. Перезайдите в интерфейс и попробуйте снова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    cache_set_active ( ownedPlatesCache [ playerid ], sql_connection ) ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;

    new sqlPlateId,
		sqlPlatePrice,
		sqlPlateRegion [ 8 ],
		sqlPlateNumber [ 24 ],
		sqlPlateCountry [ 8 ],
		plateStr [ 10 ] ;
    for ( new idx = 0 ; idx < rows ; idx ++ )
    {
		sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
        if ( sqlPlateId != platesId ) continue ;

		sqlPlatePrice = cache_get_field_content_int ( idx, "licence_plate_price" ) ;

        if ( sqlPlatePrice > 0 ) // Изменить цену
        {
            SetPVarInt ( playerid, "sellplates:plateid", sqlPlateId ) ;

			cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
			cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
			cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

            if ( ! strcmp ( "UA", sqlPlateCountry ) ) {
                format ( plateStr, 12, "%s %s", sqlPlateRegion, sqlPlateNumber ) ;
            }
            else {
                format ( plateStr, 12, "%s %s", sqlPlateNumber, sqlPlateRegion ) ;
            }

            global_string [ 0 ] = EOS ;
            format ( global_string, 256, "\
                {"#cWH"}Вы продаёте номер {"#cOR"}%s\n\n\
                {"#cWH"}Установите стоимость в поле для ввода ниже:\n\n\
                {"#cGRDialog"}* Минимальная цена продажи номеров - 50.000 "valute_title_", максимальная - 10.000.000 "valute_title_"", plateStr
            ) ;

			show_dialog ( playerid, d_plates_change_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменить стоимость", global_string, "выставить", "Отмена" ) ;
		}
        else // Продать
        {
            new vehicleUid = cache_get_field_content_int ( idx, "licence_plate_use_own_car_id" ) ;

            if ( vehicleUid != 0 )
			{
				send_check_cinfo ( playerid, "Вы не можете продать установленные номера!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
            }

            SetPVarInt ( playerid, "sellplates:plateid", sqlPlateId ) ;

			cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;
			cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
			cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;

            if ( ! strcmp ( "UA", sqlPlateCountry ) ) {
                format ( plateStr, 12, "%s %s", sqlPlateRegion, sqlPlateNumber ) ;
            }
            else {
                format ( plateStr, 12, "%s %s", sqlPlateNumber, sqlPlateRegion ) ;
            }

			global_string [ 0 ] = EOS ;
            format ( global_string, 256, "\
                {"#cWH"}Вы собираетесь продать номер {"#cOR"}%s\n\n\
                {"#cWH"}Установите стоимость в поле для ввода ниже:\n\n\
                {"#cGRDialog"}* Минимальная цена продажи номеров - 50.000 "valute_title_", максимальная - 10.000.000 "valute_title_"", plateStr
            ) ;

			show_dialog ( playerid, d_sell_license_plates, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа номеров", global_string, "выставить", "Отмена" ) ;
		}
        break ;
    }
    return true ;
}

callback: BuyLicencePlate ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;

    new licence_plate_count = cache_get_field_content_int ( 0, "licence_plate_count" ) ;

 	if ( licence_plate_count + 1 > p_info [ playerid ] [ max_veh ] )
	{
    	send_check_cinfo ( playerid, "Лимит на покупку номеров исчерпан, необходимо купить ещё слоты для транспорта.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
   	}

	if ( p_info [ playerid ] [ money ] < PLATE_PURCHASE_PRICE )
	{
		send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
		
	give_money ( playerid, -PLATE_PURCHASE_PRICE ) ;
	insert_money_log ( playerid, INVALID_PLAYER_ID, -PLATE_PURCHASE_PRICE, "Покупка номерных знаков" ) ;
    UpdatePlayerCash ( playerid ) ;

    new regionid = g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ;
    if ( regionid == -1 )
	{
		send_check_cinfo ( playerid, "Ошибка №80", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	if ( GetInventoryFreeSlot ( playerid, SUB_INVENTORY ) == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного места в инвентаре.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

    global_string [ 0 ] = EOS ;
    format
    (
        global_string, 512, 
        "INSERT INTO licence_plate \
        (licence_plate_char_id,licence_plate_country,licence_plate_number,licence_plate_region) \
        VALUES \
        ('%d','%s','%s','%s')",
        p_info [ playerid ] [ id ],
        g_licence_plates_region [ regionid ],
        g_licence_plate_system [ playerid ] [ LPS_NUMBER ],
        g_licence_plate_system [ playerid ] [ LPS_REGION ]
    ) ;
    mysql_tquery ( sql_connection, global_string, "OnNewPlateInserted", "i", playerid ) ;

    global_string [ 0 ] = EOS ;
    format ( global_string, 144, "\
        DELETE FROM licence_plate_hold \
        WHERE licence_plate_hold_char_id=%d AND licence_plate_hold_region_id=%d", p_info [ playerid ] [ id ], regionid
    ) ;
    mysql_tquery ( sql_connection, global_string ) ;

	resetLicensePlates ( playerid, regionid ) ;
    GenerateLicencePlates ( playerid, regionid ) ;
    CheckIsPlateAvailable ( playerid, 1 ) ;

	send_check_cinfo ( playerid, "Вы успешно приобрели номер", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
    return true ;
}

callback: OnNewPlateInserted ( playerid )
{
    new sqlPlateId = cache_insert_id ( ), _country_id ;

    // Ваши номера (показываем покупателю)
    new regionid = g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ;

    new Node: node = JSON_Array (
        JSON_Object (
            "id",           JSON_Int ( sqlPlateId ),
            "region",       JSON_String ( g_licence_plate_system [ playerid ] [ LPS_REGION ] ),
            "number",       JSON_String ( g_licence_plate_system [ playerid ] [ LPS_NUMBER ] ),
            "country",      JSON_String ( g_licence_plates_region [ regionid ] ),
            "status",       JSON_String ( "notInstalled" ),
            "sellPrice",    JSON_Int ( 0 ),
            "carName",      JSON_String ( "" )
        )
    ) ;

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_LICENCE_PLATES, 3, global_string ) ;

    UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;

	if ( ! strcmp ( g_licence_plates_region [ regionid ], "RU POLICE" ) ) _country_id = NUMBERPLATE_TYPE_RU_POLICE ;
	else if ( ! strcmp ( g_licence_plates_region [ regionid ], "RU" ) ) _country_id = NUMBERPLATE_TYPE_RUS ;
	else if ( ! strcmp ( g_licence_plates_region [ regionid ], "UA" ) ) _country_id = NUMBERPLATE_TYPE_UA ;
	else if ( ! strcmp ( g_licence_plates_region [ regionid ], "BY" ) ) _country_id = NUMBERPLATE_TYPE_BY ;
	else if ( ! strcmp ( g_licence_plates_region [ regionid ], "KZ" ) ) _country_id = NUMBERPLATE_TYPE_KZ ;

	give_inventory (
		playerid,
		2250,
		1,
		RENDER_TYPE_PLATE,
		g_licence_plate_system [ playerid ] [ LPS_REGION ],
		g_licence_plate_system [ playerid ] [ LPS_NUMBER ],
		_country_id,
		sqlPlateId,
		-1
	) ;
    return true ;
}

callback: ShowPlayerHoldingPlates ( playerid, init )
{
    if ( init )
    {
		static const _str [ ] = "\
			SELECT licence_plate_hold_number, licence_plate_hold_region \
            FROM licence_plate_hold \
            WHERE licence_plate_hold_char_id=%d AND licence_plate_hold_region_id=%d AND licence_plate_hold_add_time > %d LIMIT 1" ;
        new query_string [ sizeof _str + ( 9 * 3 ) ] ;
		format ( query_string, sizeof query_string, _str, 
            p_info [ playerid ] [ id ], g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ], gettime ( )
        ) ;
        mysql_tquery ( sql_connection, query_string, "ShowPlayerHoldingPlates", "ii", playerid, 0 ) ;
    }
    else
    {
        new rows = cache_num_rows ( ) ;
        if ( ! rows )
        {
            GenerateLicencePlates ( playerid, g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ) ;
            CheckIsPlateAvailable ( playerid, 1 ) ;
            return true ;      
        }
		cache_get_field_content ( 0, "licence_plate_hold_number", g_licence_plate_system [ playerid ] [ LPS_NUMBER ], sql_connection, 24 ) ;
		cache_get_field_content ( 0, "licence_plate_hold_region", g_licence_plate_system [ playerid ] [ LPS_REGION ], sql_connection, 12 ) ;

        ShowHoldNumber ( playerid ) ;
    }
    return true ;
}

callback: CheckIsPlateAvailable ( playerid, newQuery )
{
    if ( newQuery )
    {
		static const _str [ ] = "\
            SELECT 1 FROM licence_plate WHERE licence_plate_number='%s' \
            UNION ALL \
            SELECT 1 FROM licence_plate_hold WHERE licence_plate_hold_number='%s'" ;
		new query_string [ sizeof _str + 24 ] ;
        format ( query_string, sizeof query_string, _str, 
            g_licence_plate_system [ playerid ] [ LPS_NUMBER ], g_licence_plate_system [ playerid ] [ LPS_NUMBER ]
        ) ;
        mysql_tquery ( sql_connection, query_string, "CheckIsPlateAvailable", "ii", playerid, 0 ) ;
    }
    else
    {
        new rows, fields ;
		cache_get_data ( rows, fields ) ;
        if ( rows ) // Если номер найден в таблице licence_plate или licence_plate_hold - генерируем номер и снова ищем
        {
			resetLicensePlates ( playerid, g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ) ;
            GenerateLicencePlates ( playerid, g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ) ;
            CheckIsPlateAvailable ( playerid, 1 ) ;
            return true ;
        }

        ShowHoldNumber ( playerid ) ;

		static const _str [ ] = "\
            SELECT 1 \
            FROM licence_plate_hold \
            WHERE licence_plate_hold_char_id = %d AND licence_plate_hold_region_id = %d LIMIT 1" ;
		new query_string [ sizeof _str + ( 9 * 2 ) ] ;
        format ( query_string, sizeof query_string,
			_str,
            p_info [ playerid ] [ id ], g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ]
        ) ;

        mysql_tquery ( sql_connection, query_string, "InsertPlateForHolding", "ii", playerid, 0 ) ;
    }
    return true ;
}

callback: InsertPlateForHolding ( playerid, init )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
    if ( ! rows )
    {
		static const _str [ ] = "\
			INSERT INTO licence_plate_hold \
			(licence_plate_hold_char_id,licence_plate_hold_number,licence_plate_hold_region,licence_plate_hold_region_id,licence_plate_hold_add_time) \
            VALUES \
			('%d','%s','%s','%d','%d')" ;
		new query_string [ sizeof _str + ( 3 * 9 ) + 24 ] ;
        format ( query_string, sizeof query_string, _str,
            p_info [ playerid ] [ id ],
            g_licence_plate_system [ playerid ] [ LPS_NUMBER ],
            g_licence_plate_system [ playerid ] [ LPS_REGION ],
            g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ],
            gettime ( ) + 300
        ) ;

        mysql_tquery ( sql_connection, query_string ) ;
    }
    else
    {
		static const _str [ ] = "\
            UPDATE licence_plate_hold \
            SET licence_plate_hold_number='%s',licence_plate_hold_region='%s',licence_plate_hold_add_time=%d \
            WHERE licence_plate_hold_char_id=%d AND licence_plate_hold_region_id=%d LIMIT 1" ;
		new query_string [ sizeof _str + ( 3 * 9 ) + 24 ] ;
        format ( query_string, sizeof query_string, _str,
            g_licence_plate_system [ playerid ] [ LPS_NUMBER ],
            g_licence_plate_system [ playerid ] [ LPS_REGION ],
            gettime ( ) + 300, 
            p_info [ playerid ] [ id ], g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] 
        ) ;

        mysql_tquery ( sql_connection, query_string ) ;      
    }
	checkPlatesAvailable [ playerid ] = false ;
    return true ;
}

stock ShowHoldNumber ( playerid )
{
    new regionid = g_licence_plate_system [ playerid ] [ LPS_SELECTED_REGION_ID ] ;

    if ( regionid == -1 )
	{
		send_check_cinfo ( playerid, "Вы не выбрали страну!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

    new Node: node = JSON_Object (
        "region",            JSON_String ( g_licence_plate_system [ playerid ] [ LPS_REGION ] ),
        "number",            JSON_String ( g_licence_plate_system [ playerid ] [ LPS_NUMBER ] ),
        "country",           JSON_String ( g_licence_plates_region [ regionid ] )
    ) ; 

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_LICENCE_PLATES, 2, global_string ) ;
    return true ;
}

callback: UpdateOwnedPlatesCache ( playerid, reloadCache, drawPlates )
{
    if ( reloadCache )
    {
		if ( cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) )
            cache_delete ( ownedPlatesCache [ playerid ], sql_connection ) ;

		static const _str [ ] = "\
			SELECT \
				lp.id, \
				lp.licence_plate_char_id, \
				lp.licence_plate_country, \
				lp.licence_plate_number, \
				lp.licence_plate_region, \
				IFNULL(lp.licence_plate_use_own_car_id, 0) AS licence_plate_use_own_car_id, \
				lp.licence_plate_price, \
				lp.licence_plate_sell_end, \
				uv.v_model \
			FROM licence_plate lp \
			LEFT JOIN users_vehicles uv ON lp.licence_plate_use_own_car_id=uv.v_id \
			WHERE lp.licence_plate_char_id = %d" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "UpdateOwnedPlatesCache", "iii", playerid, 0, drawPlates ) ;
	}
	else
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;

		if ( drawPlates )
		{
			new Node: node = JSON_Array ( ),
				itemsLoaded = 0,
				licence_plate_sql_id,
				licence_plate_country [ 8 ],
				licence_plate_number [ 24 ],
				licence_plate_region [ 8 ],
				licence_plate_use_own_car_id,
				licence_plate_price,
				status [ 13 ], carName [ 24 ] ;
			if ( rows )
			{
				for ( new i = 0, Node: plateNode ; i < rows ; i ++ )
				{
					licence_plate_sql_id = cache_get_field_content_int ( i, "id" ) ;
					cache_get_field_content ( i, "licence_plate_country", licence_plate_country ) ;
					cache_get_field_content ( i, "licence_plate_number", licence_plate_number ) ;
					cache_get_field_content ( i, "licence_plate_region", licence_plate_region ) ;
					licence_plate_use_own_car_id = cache_get_field_content_int ( i, "licence_plate_use_own_car_id" ) ;
					licence_plate_price = cache_get_field_content_int ( i, "licence_plate_price" ) ;

					if ( licence_plate_price > 0 ) format ( status, sizeof status, "selling" ) ;
					else if ( licence_plate_use_own_car_id != 0 )
					{
						// users_vehicles
						new modelid = cache_get_field_content_int ( i, "v_model" ) ;
						if ( modelid > 0 ) {
							format ( carName, sizeof carName, "%s", GetVehicleNameEx ( INVALID_VEHICLE_ID, modelid ) ) ;
							format ( status, sizeof status, "installed" ) ;
						}
					}
					else format ( status, sizeof status, "notInstalled" ) ;

					plateNode = JSON_Array (
						JSON_Object (
							"id",           JSON_Int ( licence_plate_sql_id ),
							"region",       JSON_String ( licence_plate_region ),
							"number",       JSON_String ( licence_plate_number ),
							"country",      JSON_String ( licence_plate_country ),
							"status",       JSON_String ( status ),
							"sellPrice",    JSON_Int ( licence_plate_price ),
							"carName",      JSON_String ( carName )
						)
					) ;

					node = JSON_Append ( node, plateNode ) ;

					if ( ++ itemsLoaded == 5 || i >= rows - 1 )
					{
						global_string [ 0 ] = EOS ;
						JSON_Stringify ( node, global_string, sizeof global_string ) ;
						onServerSendData ( playerid, UI_LICENCE_PLATES, 3, global_string ) ;

						node = JSON_Array ( ) ;
						itemsLoaded = 0 ;
					}
				}
			}
		}
		ownedPlatesCache [ playerid ] = cache_save ( sql_connection ) ;
	}
	return true ;
}

callback: SetLicencePlateToAnotherPlayer ( playerid, index )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
    if ( rows )
    {
		static const _str [ ] = "UPDATE `licence_plate` SET `licence_plate_char_id` = '%d' WHERE `licence_plate_use_own_car_id` = '%d' LIMIT 1" ;
		new query_string [ sizeof _str + ( 9 * 2 ) ] ;
        format ( query_string, sizeof query_string, _str,
		veh_info [ index - 1 ] [ v_owner ], veh_info [ index - 1 ] [ v_id ] ) ;
        mysql_tquery ( sql_connection, query_string ) ;
    }
    return true ;
}

callback: UpdatePlatesForSaleCache ( reloadCache ) 
{
    if ( reloadCache )
    {
        if ( cache_is_valid ( sellingPlatesCache, sql_connection ) ) {
            cache_delete ( sellingPlatesCache, sql_connection ) ;
        }

        mysql_tquery ( sql_connection, !"\
            SELECT lp.id, \
                lp.licence_plate_char_id, \
                lp.licence_plate_country, \
                lp.licence_plate_number, \
                lp.licence_plate_region, \
                lp.licence_plate_price, \
                lp.licence_plate_sell_end, \
                us.u_name \
            FROM licence_plate lp \
            LEFT JOIN users us ON lp.licence_plate_char_id=us.u_id \
            WHERE lp.licence_plate_price > 0 ORDER BY lp.licence_plate_sell_end DESC", "UpdatePlatesForSaleCache", "i", 0
        ) ;
    }
    else
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;
		sellingPlatesCache = cache_save ( sql_connection ) ;
	}
    return true ;
}

stock LoadPlatesForSaleCache ( playerid )
{
	cache_set_active ( sellingPlatesCache, sql_connection ) ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;

    if ( rows >= 1 )
    {
        new Node:node = JSON_Array ( ),
			licence_plate_sql_id,
			licence_plate_price,
			licence_plate_country [ 8 ],
			licence_plate_number [ 24 ],
			licence_plate_region [ 8 ],
			sellerName [ MAX_PLAYER_NAME ] ;

        for ( new idx = 0, platesLoaded = 0, Node: plateNode ; idx < rows ; idx ++ )
        {
			licence_plate_sql_id = cache_get_field_content_int ( idx, "id" ) ;
			licence_plate_price = cache_get_field_content_int ( idx, "licence_plate_price" ) ;
			cache_get_field_content ( idx, "licence_plate_country", licence_plate_country ) ;
			cache_get_field_content ( idx, "licence_plate_number", licence_plate_number ) ;
			cache_get_field_content ( idx, "licence_plate_region", licence_plate_region ) ;

			// users
			cache_get_field_content ( idx, "u_name", sellerName ) ;

            plateNode = JSON_Array (
                JSON_Object (
                    "id",           JSON_Int ( licence_plate_sql_id ),
                    "region",       JSON_String ( licence_plate_region ),
                    "number",       JSON_String ( licence_plate_number ),
                    "country",      JSON_String ( licence_plate_country ),
                    "sellerName",   JSON_String ( sellerName ),
                    "price",        JSON_Int ( licence_plate_price )
                )
            ) ;

            node = JSON_Append ( node, plateNode ) ;

            if ( ++ platesLoaded == 10 || idx == rows - 1 )
            {
				global_string [ 0 ] = EOS ;
                JSON_Stringify ( global_string, global_string, sizeof global_string ) ;
                onServerSendData ( playerid, UI_LICENCE_PLATES, 6, global_string ) ;

                node = JSON_Array ( ) ;
                platesLoaded = 0 ;    
            }
        }      
    }
    return true ;
}

static stock BuyPlates ( playerid, plateId, platePrice )
{
    cache_set_active ( sellingPlatesCache, sql_connection ) ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;

    new sqlPlateId, sqlOwnerId, sqlPlatePrice,
		sqlPlateRegion [ 8 ], sqlPlateNumber [ 24 ], sqlPlateCountry [ 8 ] ;
    for ( new idx = 0 ; idx < rows ; idx ++ )
    {
		sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
        if ( sqlPlateId != plateId ) continue ;

		sqlOwnerId = cache_get_field_content_int ( idx, "licence_plate_char_id" ) ;

		if ( p_info [ playerid ] [ id ] == sqlOwnerId )
		{
			send_check_cinfo ( playerid, "Вы не можете купить свой же номер!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}      

		sqlPlatePrice = cache_get_field_content_int ( idx, "licence_plate_price" ) ;

		if ( platePrice != sqlPlatePrice )
		{
			send_check_cinfo ( playerid, "Произошла ошибка при покупке номера. Попробуйте снова!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( p_info [ playerid ] [ money ] < platePrice )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств для покупки!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		cache_get_field_content ( idx, "licence_plate_country", sqlPlateCountry ) ;
		cache_get_field_content ( idx, "licence_plate_number", sqlPlateNumber ) ;
		cache_get_field_content ( idx, "licence_plate_region", sqlPlateRegion ) ;

        // Ваши номера (показываем покупателю)
        new Node:node = JSON_Array (
            JSON_Object (
                "id",           JSON_Int ( sqlPlateId ),
                "region",       JSON_String ( sqlPlateRegion ),
                "number",       JSON_String ( sqlPlateNumber ),
                "country",      JSON_String ( sqlPlateCountry ),
                "status",       JSON_String ( "notInstalled" ),
                "sellPrice",    JSON_Int ( 0 ),
                "carName",      JSON_String ( "" )
            )
        ) ;

		global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_LICENCE_PLATES, 3, global_string ) ;

		give_money ( playerid, -platePrice ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -platePrice, "Покупка номеров с рынка" ) ;
        UpdatePlayerCash ( playerid ) ;

		global_string [ 0 ] = EOS ;
        format ( global_string, 144, "UPDATE `licence_plate` SET `licence_plate_char_id` = '%d', `licence_plate_price` = '0' WHERE `id` = '%d' LIMIT 1",
		p_info [ playerid ] [ id ], sqlPlateId ) ;
        mysql_tquery ( sql_connection, global_string ) ;

        send_check_cinfo ( playerid, "Вы успешно приобрели новый номер!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		UpdateOwnedPlatesCache ( playerid, 1, 0 ) ;

        // Ваши номера (удаляем у продавца)
        new sellerid = GetPlayerIDBySqlID ( sqlOwnerId ) ;
        if ( sellerid != INVALID_PLAYER_ID )
        {
			give_money ( sellerid, platePrice ) ;
			insert_money_log ( sellerid, INVALID_PLAYER_ID, platePrice, "Продажа номеров на рынке" ) ;

            send_check_cinfo ( sellerid, "Вы успешно продали свой номер!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		
			if ( p_t_info [ sellerid ] [ in_license_menu ] == true ) 
            {
                new sqlPlateIdStr [ 12 ] ;
				format ( sqlPlateIdStr, sizeof sqlPlateIdStr, "%d", sqlPlateId ) ;
                onServerSendData ( sellerid, UI_LICENCE_PLATES, 5, sqlPlateIdStr ) ;  
                UpdatePlayerCash ( sellerid ) ;
                UpdateOwnedPlatesCache ( sellerid, 1, 0 ) ;        
            }
        }
        else insert_return_money ( "Продажа номеров", platePrice, sqlOwnerId ) ;

        // Купить номера (удаляем из списка)
        RemovePlateFromSale ( plateId ) ;
        UpdatePlatesForSaleCache ( 1 ) ;
        break ;
    }
    return true ;
}

static stock UpdatePlayerCash ( playerid )
{
    new cashStr [ 12 ] ;
	format ( cashStr, sizeof cashStr, "%d", p_info [ playerid ] [ money ] ) ;
    onServerSendData ( playerid, UI_LICENCE_PLATES, 0, cashStr ) ; 
	return 1 ;
}

static stock RemovePlateFromSale ( plateId )
{
    new plateIdStr [ 12 ] ;
	format ( plateIdStr, sizeof plateIdStr, "%d", plateId ) ;
    foreach(new i: logged_players)
    {
        if ( p_t_info [ i ] [ in_license_menu ] == false ) continue ;
        onServerSendData ( i, UI_LICENCE_PLATES, 8, plateIdStr ) ; 
    }
    return true ;
}

stock ClearOwnedPlatesCache ( playerid )
{
    g_licence_plate_system [ playerid ] = g_licence_plate_system_def_val ;
    p_t_info [ playerid ] [ in_license_menu ] = false ;

	if ( cache_is_valid ( ownedPlatesCache [ playerid ], sql_connection ) )
		cache_delete ( ownedPlatesCache [ playerid ], sql_connection ) ;
    return true ;
}

stock CheckPlatesMarketTimer ( )
{
	cache_set_active ( sellingPlatesCache, sql_connection ) ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;

	new sqlPlateSellEnd,
		sqlPlateId,
		sqlPlateOwner ;

	for ( new idx = 0 ; idx < rows ; idx ++ )
	{
		sqlPlateSellEnd = cache_get_field_content_int ( idx, "licence_plate_sell_end" ) ;
		if ( sqlPlateSellEnd > gettime ( ) ) continue ;

		sqlPlateId = cache_get_field_content_int ( idx, "id" ) ;
		sqlPlateOwner = cache_get_field_content_int ( idx, "licence_plate_char_id" ) ;

		new sellerid = GetPlayerIDBySqlID ( sqlPlateOwner ) ;
		if ( sellerid != INVALID_PLAYER_ID )
		{
			if ( p_t_info [ sellerid ] [ in_license_menu ] == true )
			{
				new sqlPlateIdStr [ 12 ] ;
				format ( sqlPlateIdStr, sizeof sqlPlateIdStr, "%d", sqlPlateId ) ;
				onServerSendData ( sellerid, UI_LICENCE_PLATES, 5, sqlPlateIdStr ) ;
				UpdateOwnedPlatesCache ( sellerid, 1, 0 ) ;
			}
			send_check_cinfo ( sellerid, "Ваш номер был снят с продажи по истечению времени.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_WARNING, "", "" ) ;
		}

		global_string [ 0 ] = EOS ;
        format ( global_string, 144, "UPDATE licence_plate SET licence_plate_price=0 WHERE id=%d LIMIT 1", sqlPlateId, sqlPlateOwner ) ;
        mysql_tquery ( sql_connection, global_string ) ;

		RemovePlateFromSale ( sqlPlateId ) ;
	}

	UpdatePlatesForSaleCache ( 1 ) ;
    return true ;
}

stock InsertNewTicket ( playerid, value, vehicleid, const reason [ ] )
{
    new modelid = 0, year, month, day, plateStr [ 24 ] ;
    getdate ( year, month, day ) ;

    if ( vehicleid != INVALID_VEHICLE_ID )
	{
		modelid = GetVehicleModelEx ( vehicleid ) ;
		if ( veh_info [ vehicleid - 1 ] [ v_plate_type ] > 1 )
		{
			switch ( veh_info [ vehicleid - 1 ] [ v_plate_type ] )
			{
				case LICENCE_PLATE_REGION_UA: format ( plateStr, sizeof plateStr, "%s%s", veh_info [ vehicleid - 1 ] [ v_region ], veh_info [ vehicleid - 1 ] [ v_plate ] ) ;
				default: format ( plateStr, sizeof plateStr, "%s%s", veh_info [ vehicleid - 1 ] [ v_plate ], veh_info [ vehicleid - 1 ] [ v_region ] ) ;
			}

			for ( new i = 0 ; i < strlen ( plateStr ) ; i ++ )
			{
				if ( plateStr [ i ] == ' ' ) { strdel ( plateStr, i, i + 1 ) ; }
			}
		}
		else
		{
			strcat ( plateStr, "НЕТ НОМЕРА" ) ;
		}
	}

	new query_string [ 256 ] ;
    format ( query_string, sizeof query_string, "\
        INSERT INTO users_tickets (u_id, fine_type, car_model, car_number, fine_value) \
        VALUES ('%d', '%s', '%d', '%s', '%d')", p_info [ playerid ] [ id ], reason, modelid, plateStr, value 
    ) ;
    mysql_tquery ( sql_connection, query_string ) ;

    p_info [ playerid ] [ ticket_c ] += 1 ;
    return true ;
}