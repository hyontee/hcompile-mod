stock show_window_gas_station ( playerid )
{
	new vehicleid = GetPlayerVehicleID ( playerid ),
		modelid = getVehicleOrdinalNumber ( vehicleid ),
		_b_id = GetPVarInt ( playerid, "f_biz" ) ;

    static const fuel_type_name [ 4 ] [ 4 ] = { "92", "95", "98", "ДТ" } ;

    new Node: node = JSON_Array ( ), price = 0 ;
	for ( new idx = 0, Node: fuelNode ; idx < 4 ; idx ++ ) 
    {
		price = b_price_market [ _b_id ] [ idx ] ;
		if ( mafia_player ( playerid ) )
		{
			if ( b_info [ _b_id ] [ b_mafia ] == p_info [ playerid ] [ member ] )
			{
			    price = floatround ( ( b_price_market [ _b_id ] [ idx ] * 50 ) / 100 ) ;
			}
		}

		fuelNode = JSON_Array (
			JSON_Object (
				"fuelType",		JSON_String ( fuel_type_name [ idx ] ),
				"price",		JSON_Int ( price ),
				"isAvailable",	JSON_Int ( veh_data [ modelid ] [ VEHICLE_FUEL_TYPE_ID ] == idx + 1 ? true : false )
			)
		) ;
        node = JSON_Append ( node, fuelNode ) ;
    }

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FUEL_STATION, 0, global_string ) ;

	node = JSON_Object (
		"currentFuelLevel", 		JSON_Int ( floatround ( veh_info [ vehicleid - 1 ] [ v_fuel ] ) ),
		"fullTankFuelLevel",		JSON_Int ( 100 )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FUEL_STATION, 1, global_string ) ;
	return 1 ;
}

stock show_packet_gas_station ( playerid, actionId, data [ ] )
{
	new _b_id = GetPVarInt ( playerid, "f_biz" ),
		vehicleid = GetPlayerVehicleID ( playerid ),
    	Float: fuel_capacity = 100.0,
		modelid = getVehicleOrdinalNumber ( vehicleid ),
        vehicle_fuel_type = veh_data [ modelid ] [ VEHICLE_FUEL_TYPE_ID ] ;

    switch ( actionId )
 	{
    	case 0:
     	{
        	new count = strval ( data ) ;
         	if ( count < 1 )
			{
				send_check_cinfo ( playerid, "Выберите количество!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

          	if ( floatround ( veh_info [ vehicleid - 1 ] [ v_fuel ] ) + count > floatround ( fuel_capacity ) )
			{
				send_check_cinfo ( playerid, "В бензобак транспорта столько не поместится!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

			if ( b_info [ _b_id ] [ b_product ] < b_fill_product [ VEHICLE_FUEL_TYPE_CHARGE - 1 ] * count )
			{
				send_check_cinfo ( playerid, "У АЗС нет столько топлива!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

			new price = b_price_market [ _b_id ] [ vehicle_fuel_type - 1 ] * count ;
			if ( mafia_player ( playerid ) )
			{
				if ( b_info [ _b_id ] [ b_mafia ] == p_info [ playerid ] [ member ] )
				{
				    price = floatround ( ( b_price_market [ _b_id ] [ vehicle_fuel_type - 1 ] * 50 ) / 100 ) ;
				}
			}

			for ( new j = 0 ; j < MAX_BANK_ACCOUNT ; j ++ )
			{
				if ( ! bank_info [ playerid ] [ bi_type ] [ j ] ) continue ;
				if ( bank_info [ playerid ] [ bi_money ] [ j ] < price ) continue ;

				bank_info [ playerid ] [ bi_money ] [ j ] -= price ;

				static const _str [ ] = "UPDATE `deposit_boxes` SET `db_money` = `db_money` - '%d' WHERE `db_id` = '%i' LIMIT 1" ;
				new sql_string [ sizeof _str + ( 9 * 2 ) ] ;
				format ( sql_string, sizeof ( sql_string ), _str, price, bank_info [ playerid ] [ bi_id ] [ j ] ) ;
				mysql_tquery ( sql_connection, sql_string ) ;

				insert_deposit_logs ( bank_info [ playerid ] [ bi_id ] [ j ], -1, price, "Оплата на АЗС", BANK_TYPE_PAYMENT ) ;
				give_bmoney ( _b_id + 1, price, b_fill_product [ VEHICLE_FUEL_TYPE_CHARGE - 1 ] * count ) ;

				veh_info [ vehicleid - 1 ] [ v_fuel ] += float ( count ) ;
				onServerSendData ( playerid, UI_FUEL_STATION, 2, "" ) ;
				return 1 ;
			}

          	send_check_cinfo ( playerid, "У Вас недостаточно средств или нет банковских карт!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
        }
        case 1:
        {
            new count = strval ( data ) ;
         	if ( count < 1 )
			{
				send_check_cinfo ( playerid, "Выберите количество!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

          	if ( floatround ( veh_info [ vehicleid - 1 ] [ v_fuel ] ) + count > floatround ( fuel_capacity ) )
			{
				send_check_cinfo ( playerid, "В бензобак транспорта столько не поместится!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

			if ( b_info [ _b_id ] [ b_product ] < b_fill_product [ VEHICLE_FUEL_TYPE_CHARGE - 1 ] * count )
			{
				send_check_cinfo ( playerid, "У АЗС нет столько топлива!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

			new price = b_price_market [ _b_id ] [ vehicle_fuel_type - 1 ] * count ;
			if ( mafia_player ( playerid ) )
			{
				if ( b_info [ _b_id ] [ b_mafia ] == p_info [ playerid ] [ member ] )
				{
				    price = floatround ( ( b_price_market [ _b_id ] [ vehicle_fuel_type - 1 ] * 50 ) / 100 ) ;
				}
			}

          	if ( p_info [ playerid ] [ money ] < price )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

			give_money ( playerid, -price ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Услуги АЗС" ) ;
			give_bmoney ( _b_id + 1, price, b_fill_product [ VEHICLE_FUEL_TYPE_CHARGE - 1 ] * count ) ;

            veh_info [ vehicleid - 1 ] [ v_fuel ] += float ( count ) ;
            onServerSendData ( playerid, UI_FUEL_STATION, 2, "" ) ;
        }
        case 2:
        {
			toggle_controlable ( playerid, true ) ;
        }
        case 3:
        {
            new count = strval ( data ) ;
         	if ( count < 1 )
			{
				send_check_cinfo ( playerid, "Выберите количество!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            	return 1 ;
			}

			new price = b_price_market [ _b_id ] [ vehicle_fuel_type - 1 ] * count ;
			if ( mafia_player ( playerid ) )
			{
				if ( b_info [ _b_id ] [ b_mafia ] == p_info [ playerid ] [ member ] )
				{
				    price = floatround ( ( b_price_market [ _b_id ] [ vehicle_fuel_type - 1 ] * 50 ) / 100 ) ;
				}
			}
			
			onServerDestroy ( playerid, UI_FUEL_STATION ) ;

			new line_string [ 144 ] ;
			format ( line_string, sizeof line_string, "Транспорт заправлен на {"#cOR"}%d литров {"#cWH"}за {"#cGN"}%d "valute_title_"", count, price ) ;
           	send_check_cinfo ( playerid, line_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;

			toggle_controlable ( playerid, true ) ;
			SendSpeedometr ( playerid, vehicleid, true ) ;
		}
	}
	return 1 ;
}