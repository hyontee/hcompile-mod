#include	<custom/plates>

static varchar_plate [ MAX_PLAYERS ] [ 32 ] ;

#define MAX_PLATES 20
new varchar_platename [ MAX_PLAYERS ] [ MAX_PLATES ] [ 12 ] ;
new varchar_plateregion [ MAX_PLAYERS ] [ MAX_PLATES ] [ 10 ] ;
new varchar_platetype [ MAX_PLAYERS ] [ MAX_PLATES ] ;
new varchar_plateid [ MAX_PLAYERS ] [ MAX_PLATES ] ;

new bool: plates_cofirm [ MAX_PLAYERS ] ;
new plate_count [ MAX_PLAYERS ] ;
new bool: g_player_load_plates [ MAX_PLAYERS ] ;
new plate_inc_id ;

#define d_trade_plates 22050

stock clear_player_plate ( playerid )
{
	plate_count [ playerid ] = 0 ;
	g_player_load_plates [ playerid ] = false ;
	
	for ( new i = 0 ; i < MAX_PLATES ; i ++ )
	{
		format ( varchar_platename [ playerid ] [ i ], 12, "Transit" ) ;
		format ( varchar_plateregion [ playerid ] [ i ], 10, "" ) ;
	
		varchar_platetype [ playerid ] [ i ] = 0 ;
		varchar_plateid [ playerid ] [ i ] = -1 ;
	}
	return 1 ;
}

stock loaded_player_plates ( playerid, type_return, plate_name [ ], plate_region [ ], plate_type, plate_slot )
{
	if ( type_return == 1 ) callcmd::plates ( playerid ) ;
	//else if ( type_return == 2 ) show_market_inventory ( playerid ) ;
	else if ( type_return == 3 ) give_player_plates ( playerid, plate_name, plate_region, plate_type ) ;
	else if ( type_return == 4 ) clear_player_plates ( playerid, plate_name, plate_region, plate_type, plate_slot ) ;
	return 1 ;
}

callback: callback_plates ( playerid, type_return, plate_name [ ], plate_region [ ], plate_type, plate_slot )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		plate_count [ playerid ] = 0 ;
		
		g_player_load_plates [ playerid ] = true ;
		loaded_player_plates ( playerid, type_return, plate_name, plate_region, plate_type, plate_slot ) ;
		return 1 ;
	}

	plate_count [ playerid ] = rows ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
	    varchar_plateid [ playerid ] [ i ] = cache_get_field_content_int ( i, "p_id", sql_connection ) ;
	    varchar_platetype [ playerid ] [ i ] = cache_get_field_content_int ( i, "p_type", sql_connection ) ;
	    cache_get_field_content ( i, "p_name", varchar_platename [ playerid ] [ i ], sql_connection, 12 ) ;
	    cache_get_field_content ( i, "p_region", varchar_plateregion [ playerid ] [ i ], sql_connection, 10 ) ;
	}
	
	g_player_load_plates [ playerid ] = true ;
	loaded_player_plates ( playerid, type_return, plate_name, plate_region, plate_type, plate_slot ) ;
	return 1 ;
}

stock give_player_plates ( playerid, plate_name [ ], plate_region [ ], plate_type )
{
	if ( g_player_load_plates [ playerid ] == false )
	{
		new query_string [ 60 + 9 + 4 ] ;
		format ( query_string, sizeof query_string, "SELECT * FROM `users_plates` WHERE `u_id` = '%d' LIMIT 20", p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "callback_plates", "iissii", playerid, 3, plate_name, plate_region, plate_type, -1 ) ;
		return 1 ;
	}
	
	if ( plate_count [ playerid ] + 1 > MAX_PLATES )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество номеров!" ) ;
		return 1 ;
	}
	
	for ( new i = 0 ; i < MAX_PLATES ; i ++ )
	{
		if ( varchar_plateid [ playerid ] [ i ] != -1 ) continue ;
		
		format ( varchar_platename [ playerid ] [ i ], 12, "%s", plate_name ) ;
		format ( varchar_plateregion [ playerid ] [ i ], 10, "%s", plate_region ) ;
		varchar_platetype [ playerid ] [ i ] = plate_type ;
		
		plate_inc_id ++ ;
		varchar_plateid [ playerid ] [ i ] = plate_inc_id ;
		
		new sql_string [ 232 ] ;
		format ( sql_string, sizeof sql_string, "INSERT INTO `users_plates` (`p_id`,`u_id`,`p_name`,`p_region`,`p_type`) VALUES ('%d','%d','%s','%s','%d')", varchar_plateid [ playerid ] [ i ], p_info [ playerid ] [ id ], plate_name, plate_region, plate_type ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		plate_count [ playerid ] ++ ;
		
		if ( player_device { playerid } == 2 ) send_check_cinfo ( playerid, "/plates - управление номерами.\n/take_plate - снять номера с т/с.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_VEHICLE, "", "" ) ;
		else SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}{"#cBL"}/plates {"#cWH"}- управление номерами. {"#cBL"}/take_plate {"#cWH"}- снять номера." ) ;
		break ;
	}
	return 1 ;
}

callback: callback_last_plates ( )
{
	new fields,
		rows,
		time = GetTickCount ( ) ;

	cache_get_data ( rows, fields ) ;

    if ( rows ) plate_inc_id = cache_get_field_content_int ( 0, "p_id", sql_connection ) ;
    printf("[SERVER] Загружен %d последний номер. (%d ms)", plate_inc_id, GetTickCount ( ) - time ) ;
	return 1 ;
}

stock clear_player_plates ( playerid, plate_name [ ], plate_region [ ], plate_type, plate_slot = -1 )
{
	if ( g_player_load_plates [ playerid ] == false )
	{
		new query_string [ 60 + 9 + 4 ] ;
		format ( query_string, sizeof query_string, "SELECT * FROM `users_plates` WHERE `u_id` = '%d' LIMIT 20", p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "callback_plates", "iissii", playerid, 4, plate_name, plate_region, plate_type, plate_slot ) ;
		return 1 ;
	}
	
	if ( plate_slot != -1 )
	{
		varchar_platetype [ playerid ] [ plate_slot ] = 0 ;
		
		format ( varchar_platename [ playerid ] [ plate_slot ], 12, "None" ) ;
		format ( varchar_plateregion [ playerid ] [ plate_slot ], 10, "None" ) ;
		
		new sql_string [ 57 + 9 ] ;
		format ( sql_string, sizeof sql_string, "DELETE FROM `users_plates` WHERE `p_id` = '%d' LIMIT 1", varchar_plateid [ playerid ] [ plate_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		varchar_plateid [ playerid ] [ plate_slot ] = -1 ;
		
		plate_count [ playerid ] -- ;
		return 1 ;
	}
	
	for ( new i = 0 ; i < MAX_PLATES ; i ++ )
	{
		if ( ! GetString ( varchar_platename [ playerid ] [ i ], plate_name ) && ! GetString ( varchar_plateregion [ playerid ] [ i ], plate_region ) ) continue ;
		
		varchar_platetype [ playerid ] [ i ] = 0 ;
		
		format ( varchar_platename [ playerid ] [ i ], 12, "None" ) ;
		format ( varchar_plateregion [ playerid ] [ i ], 10, "None" ) ;
		
		new sql_string [ 57 + 9 ] ;
		format ( sql_string, sizeof sql_string, "DELETE FROM `users_plates` WHERE `p_id` = '%d' LIMIT 1", varchar_plateid [ playerid ] [ i ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		varchar_plateid [ playerid ] [ i ] = -1 ;
		
		plate_count [ playerid ] -- ;
		return 1 ;
	}
	return 1 ;
}

CMD:plates ( playerid )
{
	if ( g_player_load_plates [ playerid ] == false )
	{
		new query_string [ 60 + 9 + 4 ] ;
		format ( query_string, sizeof query_string, "SELECT * FROM `users_plates` WHERE `u_id` = '%d' LIMIT 20", p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "callback_plates", "iissii", playerid, 1, "none", "none", 0, -1 ) ;
		return 1 ;
	}
	
	if ( plate_count [ playerid ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет номерных знаков." ) ;
	if ( ! bad_dialog ( playerid ) && GetPVarInt ( playerid, "plate_trade" ) != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRDialog"}В данный момент недоступно." ) ;
	
    global_string [ 0 ] = EOS ;
    new line_str [ 128 ], row_count = 0 ;
	format ( global_string, sizeof ( global_string ), "{"#cBL"}Выберите номерные знаки:\t\n" ) ;
	for ( new i = 0 ; i < MAX_PLATES ; i ++ )
	{
		if ( varchar_plateid [ playerid ] [ i ] == -1 ) continue ;
		
		set_player_listitem_values ( playerid, row_count, i ) ;
		row_count ++ ;

		format ( line_str, sizeof line_str, "{"#cGR"}- {"#cWH"}Номера: {"#cGR"}%s{"#cWH"}\n", plate_number1 ( varchar_platetype [ playerid ] [ i ], varchar_platename [ playerid ] [ i ], varchar_plateregion [ playerid ] [ i ] ) ) ;
		strcat ( global_string, line_str ) ;
	}
	
	if ( GetPVarInt ( playerid, "plate_trade" ) == 1 ) show_dialog ( playerid, d_trade_plates, DIALOG_STYLE_LIST, "{"#cBHD"}Номерные знаки", global_string, "Выбрать", "Закрыть" ) ;
	else show_dialog ( playerid, d_plates, DIALOG_STYLE_LIST, "{"#cBHD"}Номерные знаки", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:take_plate ( playerid )
{
	if ( ! Iter_Count(player_vehicles[playerid]) ) return 1 ;
	if ( plate_count [ playerid ] + 1 > MAX_PLATES ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество номеров!" ) ;

	new bool: player_from_vehicles = false ;
	foreach(new veh_id: player_vehicles[playerid])
	{
		if ( veh_info [ veh_id - 1 ] [ v_type ] != vehicle_type_player ) continue ;
		if ( veh_info [ veh_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] ) continue ;
		
		if ( ! IsVehicleInRangeOfPoint ( veh_id, 5.0, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ) continue ;
			
		if ( veh_info [ veh_id - 1 ] [ v_plate_type ] < 2 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На т/с нет номерных знаков." ) ;
		if ( GetString ( veh_info [ veh_id - 1 ] [ v_plate ], "Transit" ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На т/с нет номерных знаков." ) ;
			
		give_player_plates ( playerid, veh_info [ veh_id - 1 ] [ v_plate ], veh_info [ veh_id - 1 ] [ v_region ], veh_info [ veh_id - 1 ] [ v_plate_type ] ) ;

		format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "Transit" ) ;
			
		SetVehicleNumberPlate ( veh_id, veh_info [ veh_id - 1 ] [ v_plate ] ) ;
			
		veh_info [ veh_id - 1 ] [ v_plate_type ] = 1 ;
		foreach(new forplayerid: streamed_in_vehicles[veh_id])
		{
			sc_OnVehicleStreamIn ( veh_id, forplayerid ) ;
		}
		
		new sql_string [ 186 ] ;
		format ( sql_string, sizeof sql_string, "UPDATE `users_vehicles` SET `v_plate` = 'Transit', `v_region` = 'None', `v_plate_type` = '1' WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
	    mysql_tquery ( sql_connection, sql_string ) ;
			
		ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 6.1, 0, 0, 0, 0, 0, 1 ) ;
	
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы сняли номера с т/с. Используйте {"#cGN"}/plates {"#cWH"}для управления номерами." ) ;
	
		player_from_vehicles = true ;
		return 1 ;
	}
	
	if ( player_from_vehicles == false ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не рядом с транспортом." ) ;
	return 1 ;
}

stock show_plates ( playerid )
{
    new dialog_string [ 164 + 9 ] ;
	format ( dialog_string, sizeof dialog_string, "{"#cBL"}1. {"#cWH"}Продать номерной знак\n{"#cBL"}2. {"#cWH"}Установить номерной знак\n{"#cBL"}3. {"#cWH"}Продать номерной знак государству [{"#cGN"}%d${"#cWH"}]\n{"#cBL"}4. {"#cWH"}Снять номер", price_reg_veh ) ;

	new _plate_id = get_player_use_listitem ( playerid ) ;
	format ( varchar_plate [ playerid ], 32, "%s", plate_number1 ( varchar_platetype [ playerid ] [ _plate_id ], varchar_platename [ playerid ] [ _plate_id ], varchar_plateregion [ playerid ] [ _plate_id ] ) ) ;

	new header_string [ 64 + 12 ] ;
	format ( header_string, sizeof header_string, "{"#cBHD"}Номерной знак: {"#cBL"}%s", varchar_plate [ playerid ] ) ;
    show_dialog(playerid, d_plates_select, DIALOG_STYLE_LIST, header_string, dialog_string, "Выбрать", "Закрыть");
	return 1 ;
}

stock plates_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_plates:
	    {
	        if ( ! response ) return 1 ;
	        
	        if ( listitem == 0 )
	        {
				clear_player_listitem_values ( playerid ) ;
				callcmd::plates ( playerid ) ;
				return 1 ;
	        }
			
			if ( GetPVarInt ( playerid, "plate_trade" ) ) return 1 ;
			
			new select_id = get_player_listitem_values ( playerid, listitem - 1 ) ;
			clear_player_listitem_values ( playerid ) ;
			
			set_player_use_listitem ( playerid, select_id ) ;
			show_plates ( playerid ) ;
			return 1 ;
	    }
	    case d_plates_select:
	    {
	        if ( ! response ) return 1 ;
	        switch ( listitem )
	        {
	            case 0:
	            {
	                if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Доступно с 3 часов в игре.") ;
	            
					new pvar_string [ 64 + 12 ] ;
		        	format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
		        	show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGR"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				}
				case 1: show_car_used ( playerid, 2 ) ;
				case 2:
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 144, "{"#cWH"}Вы собираетесь продать {"#cGN"}%s\n\n{"#cGRDialog"}* Вы уверены, что хотите продать государству?", varchar_plate [ playerid ] ) ;
					show_dialog ( playerid, d_plates_drop, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Продажа номеров", global_string, "Продать", "Назад" ) ;
				}
				case 3: callcmd::take_plate ( playerid ) ;
	        }
			return 1 ;
	    }
		case d_plates_drop:
		{
	        if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				callcmd::plates ( playerid ) ;
				return 1 ;
			}
			
	        new plate_id = get_player_use_listitem ( playerid ) ;

			clear_player_plates ( playerid, "none", "none", 0, plate_id ) ;
			give_money ( playerid, price_reg_veh ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "%s продажа номеров гос (%s)", p_info [ playerid ] [ name ], varchar_plate [ playerid ] ) ;
          	insert_money_log ( playerid, INVALID_PLAYER_ID, price_reg_veh, global_string ) ;
			   		
			callcmd::plates ( playerid ) ;
			return 1 ;
		}
		case d_plates_use:
	    {
	        if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				callcmd::plates ( playerid ) ;
				return 1 ;
			}
			
			new veh_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;

			if ( ! IsVehicleInRangeOfPoint ( veh_id, 5.0, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) )
			    return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Вы не рядом с транспортом, на который хотите установить номерной знак." ) ;

			new _plate_id = get_player_use_listitem ( playerid ) ;
			if ( _plate_id > MAX_PLATES ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Произошла ошибка. Попробуйте заново." ) ;
			format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "%s", varchar_platename [ playerid ] [ _plate_id ] ) ;
			format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%s", varchar_plateregion [ playerid ] [ _plate_id ] ) ;
			veh_info [ veh_id - 1 ] [ v_plate_type ] = varchar_platetype [ playerid ] [ _plate_id ] ;
			
			SetVehicleNumberPlate ( veh_id, veh_info [ veh_id - 1 ] [ v_plate ] ) ;
			
			foreach(new forplayerid: streamed_in_vehicles[veh_id])
			{
				sc_OnVehicleStreamIn ( veh_id, forplayerid ) ;
			}
			
		  	veh_plate ( veh_id ) ;

			clear_player_plates ( playerid, "none", "none", 0, _plate_id ) ;
			
			new sql_string [ 186 ] ;
			format ( sql_string, 100, "%s надел(а) номера (%s) на т/с", p_info [ playerid ] [ name ], varchar_plate [ playerid ] ) ;
			WriteLog ( playerid, TYPE_LOG_DEBUG, sql_string ) ;

			format ( sql_string, sizeof sql_string, "UPDATE `users_vehicles` SET `v_plate_type` = '%d', `v_plate` = '%s', `v_region` = '%s' WHERE `v_id` = '%d' LIMIT 1",
			veh_info [ veh_id - 1 ] [ v_plate_type ], veh_info [ veh_id - 1 ] [ v_plate ], veh_info [ veh_id - 1 ] [ v_region ], veh_info [ veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sql_string, "", "" ) ;
			
			ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 6.1, 0, 0, 0, 0, 0, 1 ) ;
			return 1 ;
	    }
	    case d_plates_sell:
		{
		    if ( ! response ) return callcmd::plates ( playerid ) ;

		    new plid, plprice ;
			if ( sscanf ( inputtext, "p<,>dd", plid, plprice ) )
			{
			    new pvar_string [ 46 + 12 ] ;
		        format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
		       	show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
			}

            if ( ! IsPlayerConnected ( plid ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Игрока нет в игре." ) ;

				new pvar_string [ 46 + 12 ] ;
		        format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
		       	show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}
			if ( plprice < 1 || plprice == INVALID_PRICE )
			{
			    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Цена не может быть меньше 1$." ) ;

			    new pvar_string [ 46 + 12 ] ;
		        format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
		       	show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}
			
			if ( admin_info [ plid ] [ admin ] > 0 && admin_info [ plid ] [ admin ] < 6 || admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 6 )
            {
			    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок администратор." ) ;

			    new pvar_string [ 46 + 12 ] ;
		        format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
		       	show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}
			
			if ( ! bad_dialog ( plid ) || ! bad_dialog ( playerid ) )
			{
			    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Недоступно в данный момент." ) ;

			    new pvar_string [ 46 + 12 ] ;
		        format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
		       	show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}

			if ( plid == playerid )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Вы не можете продать самому себе." ) ;

				new pvar_string [ 46 + 12 ] ;
				format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
				show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}

			if ( ! IsPlayerInRangeOfPoint ( plid, 5, p_t_info [ playerid ] [ p_pos ] [ 0 ],
													p_t_info [ playerid ] [ p_pos ] [ 1 ],
													p_t_info [ playerid ] [ p_pos ] [ 2 ] ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;

				new pvar_string [ 46 + 12 ] ;
				format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
				show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}

			if ( p_info [ plid ] [ hour_played ] < 3 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не отыграл 3 часа.");

				new pvar_string [ 46 + 12 ] ;
				format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
				show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}
				
			if ( GetString ( p_t_info [ plid ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
			{
				new scm_string [ 128 ] ;
				format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s[%d] попытка продажи аксессуара %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ plid ] [ name ], plid ) ;
				foreach(new i: admin_players)SendClientMessage ( i, col_admin, scm_string ) ;

				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно продать данному игроку." ) ;

				new pvar_string [ 46 + 12 ] ;
				format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
				show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}
			
			if ( plate_count [ plid ] >= MAX_PLATES )
			{
				SendClientMessage ( plid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока максимальное количество номеров." ) ;
				
				new pvar_string [ 46 + 12 ] ;
				format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа номерного знака {"#cBL"}%s", varchar_plate [ playerid ] ) ;
				show_dialog ( playerid, d_plates_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
				return 1 ;
			}
			
			new plate_id = get_player_use_listitem ( playerid ) ;

			buyer_id [ playerid ] = plid ;
			sell_price [ playerid ] = plprice ;
			sell_item [ playerid ] = plate_id ;
			seller_id [ plid ] = playerid ;
				
			sell_time { playerid } =
			sell_time { plid } = time_sell_null ;

			new dialog_string [ 166 ] ;
			format ( dialog_string, sizeof ( dialog_string  ), "{"#cBL"}%s {FFFFFF}предлагает Вам приобрести номерной знак {"#cOR"}%s{FFFFFF} за {"#cGN"}%s$", p_info [ playerid ] [ name ], varchar_plate [ playerid ], GetPlayerCashValueToSmile ( plprice ) ) ;
			show_dialog ( plid, d_plate_sell_accept, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка", dialog_string, "Купить", "Отмена" ) ;

			format ( dialog_string, 129, "{"#cGInfo"}* {"#cWH"}Вы предложили {"#cGN"}%s{"#cWH"} приобрести номерной знак %s за %s$",
			p_info [ plid ] [ name ], varchar_plate [ playerid ], GetPlayerCashValueToSmile ( plprice ) ) ;
			SendClientMessage ( playerid, col_white, dialog_string ) ;
			return 1 ;
		}
		case d_plate_sell_accept:
		{
		    if ( ! response )
			{
				if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) clear_sell_params ( playerid, playerid ) ;
				else clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			else
			{
				new h_seller_id = seller_id [ playerid ] ;
				if ( ! IsPlayerConnected ( h_seller_id ) || h_seller_id == INVALID_PLAYER_ID )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Продавец покинул(а) игру." ) ;
					
				new h_price_int = sell_price [ h_seller_id ] ;
				new h_plates_id = sell_item [ h_seller_id ] ;
				if ( p_info [ playerid ] [ money ] < h_price_int )
				{
					clear_sell_params ( playerid, h_seller_id ) ;
					SendClientMessage ( h_seller_id, col_gray, !"{"#cRInfo"}* {"#cGR"}У игрока нет такого количества денег." ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}У Вас нет такого количества денег." ) ;
				}
				if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ h_seller_id ] [ p_pos ] [ 0 ], p_t_info [ h_seller_id ] [ p_pos ] [ 1 ], p_t_info [ h_seller_id ] [ p_pos ] [ 2 ] ) || p_t_info [ playerid ] [ p_data ] [ 1 ] != p_t_info [ h_seller_id ] [ p_data ] [ 1 ] )
				{
					clear_sell_params ( playerid, h_seller_id ) ;
					SendClientMessage ( h_seller_id, col_gray, !"{"#cRInfo"}* {"#cGR"}Покупатель слишком далеко." ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Вы слишком далеко от продавца." ) ;
				}
				if ( h_plates_id < 0 )
				{
					clear_sell_params ( playerid, h_seller_id ) ;
					SendClientMessage ( h_seller_id, col_gray, !"{"#cRInfo"}* {"#cGR"}Номера не выбраны." ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGR"}Номера не выбраны." ) ;
				}

				give_money ( playerid, - h_price_int ) ;
				give_money ( h_seller_id, h_price_int ) ;

				new sql_string [ 34 + 32 ] ;
				format ( sql_string, sizeof sql_string, "покупка номеровов у игрока (%s)", varchar_plate [ h_seller_id ] ) ;
                insert_money_log ( playerid, h_seller_id, -h_price_int, sql_string ) ;
				
				format ( sql_string, sizeof sql_string, "продажа номеров игроку (%s)", varchar_plate [ h_seller_id ] ) ;
				insert_money_log ( h_seller_id, playerid, h_price_int, sql_string ) ;

				SendClientMessage ( playerid, col_gray, "{"#cGInfo"}* {"#cGR"}Вы успешно приобрели номерной знак." ) ;
				PlayerPlaySound ( playerid, 1052, 0.0, 0.0, 0.0 ) ;

				give_player_plates ( playerid, varchar_platename [ h_seller_id ] [ h_plates_id ], varchar_plateregion [ h_seller_id ] [ h_plates_id ], varchar_platetype [ h_seller_id ] [ h_plates_id ] ) ;
				clear_player_plates ( h_seller_id, "none", "none", 0, h_plates_id ) ;

				new query_string [ 144 ] ;
				format ( query_string, sizeof query_string, "{"#cGInfo"}* {"#cWH"}Вы продали {"#cGN"}%s {"#cWH"}номерной знак{"#cGN"} '%s'{"#cWH"} за {"#cGN"}%s$", p_info [ playerid ] [ name ], varchar_plate [ h_seller_id ], GetPlayerCashValueToSmile ( h_price_int ) ) ;
				SendClientMessage ( h_seller_id, col_succes, query_string ) ;
				
				format ( query_string, sizeof query_string, "{"#cGInfo"}* {"#cWH"}Вы купили у {"#cGN"}%s {"#cWH"}номерной знак{"#cGN"} '%s'{"#cWH"} за {"#cGN"}%s$", p_info [ h_seller_id ] [ name ], varchar_plate [ h_seller_id ], GetPlayerCashValueToSmile ( h_price_int ) ) ;
				SendClientMessage ( playerid, col_succes, query_string ) ;

				clear_sell_params ( playerid, h_seller_id ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

new plates_dialog_tick [ MAX_PLAYERS ] ;


#define PLATES_DONATE_PRICE 500

new plates_type [ MAX_PLAYERS ] ;
new plates_vehicle [ MAX_PLAYERS ] ;
new bool: plates_custom [ MAX_PLAYERS ] ;
new plates_ua_region [ MAX_PLAYERS ] [ 4 ] ;
new plates_backup_type [ MAX_PLAYERS ] ;
new plates_backup_plate [ MAX_PLAYERS ] [ 12 ] ;
new plates_backup_region [ MAX_PLAYERS ] [ 10 ] ;

CMD:testp ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /testp [id]");

	set_player_use_listitem ( playerid, params [ 0 ] ) ;
	p_info [ playerid ] [ plates_count ] += 5 ;
	return showPlates ( playerid ) ;
}

stock plates_owned_vehicle ( playerid, _veh_id )
{
	if ( _veh_id < 1 ) return 0 ;
	if ( veh_info [ _veh_id - 1 ] [ v_type ] != vehicle_type_player ) return 0 ;
	if ( veh_info [ _veh_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] ) return 0 ;
	return 1 ;
}

stock plates_tab_from_type ( _plate_type )
{
	switch ( _plate_type )
	{
		case 3: return 1 ;
		case 4: return 3 ;
		case 5: return 2 ;
	}
	return 0 ;
}

stock plates_valid_number ( const _str [ ] )
{
	new _len = strlen ( _str ) ;
	if ( _len < 3 || _len > 6 ) return 0 ;

	for ( new i = 0 ; i < _len ; i ++ )
	{
		switch ( _str [ i ] )
		{
			case '0'..'9', 'A', 'B', 'C', 'T', 'X', 'E', 'K', 'M', 'H', 'P', 'O': continue ;
			default: return 0 ;
		}
	}
	return 1 ;
}

stock plates_valid_letters ( const _str [ ], _min, _max )
{
	new _len = strlen ( _str ) ;
	if ( _len < _min || _len > _max ) return 0 ;

	for ( new i = 0 ; i < _len ; i ++ )
	{
		if ( _str [ i ] < 'A' || _str [ i ] > 'Z' ) return 0 ;
	}
	return 1 ;
}

stock plates_restore_vehicle ( playerid )
{
	new _veh_id = plates_vehicle [ playerid ] ;
	if ( _veh_id < 1 ) return 1 ;

	veh_info [ _veh_id - 1 ] [ v_plate_type ] = plates_backup_type [ playerid ] ;
	format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "%s", plates_backup_plate [ playerid ] ) ;
	format ( veh_info [ _veh_id - 1 ] [ v_region ], 10, "%s", plates_backup_region [ playerid ] ) ;
	return 1 ;
}

stock plates_close ( playerid, bool: _restore )
{
	platesHide ( playerid ) ;

	if ( _restore ) plates_restore_vehicle ( playerid ) ;

	plates_vehicle [ playerid ] = 0 ;
	plates_cofirm [ playerid ] = false ;
	plates_custom [ playerid ] = false ;
	player_select_count [ playerid ] = 0 ;

	toggle_controlable ( playerid, true ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	return 1 ;
}

stock showPlates ( playerid )
{
	new _veh_id = get_player_use_listitem ( playerid ) ;

	plates_vehicle [ playerid ] = _veh_id ;
	plates_cofirm [ playerid ] = false ;
	plates_custom [ playerid ] = false ;
	plates_type [ playerid ] = 0 ;
	player_select_count [ playerid ] = 0 ;
	plates_ua_region [ playerid ] [ 0 ] = EOS ;

	if ( _veh_id > 0 )
	{
		plates_backup_type [ playerid ] = veh_info [ _veh_id - 1 ] [ v_plate_type ] ;
		format ( plates_backup_plate [ playerid ], 12, "%s", veh_info [ _veh_id - 1 ] [ v_plate ] ) ;
		format ( plates_backup_region [ playerid ], 10, "%s", veh_info [ _veh_id - 1 ] [ v_region ] ) ;
	}

	static const _str [ ] = "Вы можете подобрать номера ещё %d раз(а). Разрешение на подбор можно приобрести у сотрудников полиции." ;
	new line_string [ sizeof _str + 9 ], price_string [ 32 ], donate_string [ 32 ] ;
	format ( line_string, sizeof line_string, _str, p_info [ playerid ] [ plates_count ] ) ;
	format ( price_string, sizeof price_string, "%s"valute_title_"", GetPlayerCashValueToSmile ( price_reg_veh * for_tax [ 5 ] ) ) ;
	format ( donate_string, sizeof donate_string, "%d "donate_title"", PLATES_DONATE_PRICE ) ;

	platesShow ( playerid ) ;
	platesLayout ( playerid, 0 ) ;
	platesMainLayout ( playerid, line_string, donate_string, price_string ) ;

	toggle_controlable ( playerid, false ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

stock plates_check_query ( playerid, _veh_id )
{
	new query_string [ 144 ] ;
	format ( query_string, sizeof ( query_string ), "SELECT `v_id` FROM `users_vehicles` WHERE `v_plate_type` = '%d' AND `v_plate` = '%s' AND `v_region` = '%s' LIMIT 1", veh_info [ _veh_id - 1 ] [ v_plate_type ], veh_info [ _veh_id - 1 ] [ v_plate ], veh_info [ _veh_id - 1 ] [ v_region ] ) ;
	mysql_tquery ( sql_connection, query_string, "check_plate_from_vehicle", "ii", playerid, _veh_id ) ;
	return 1 ;
}

stock plates_generate ( _veh_id )
{
	switch ( veh_info [ _veh_id - 1 ] [ v_plate_type ] )
	{
		case 2: format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "%s%d%d%d%s%s", veh_number ( 2 ), random ( 9 ), random ( 9 ), random ( 9 ), veh_number ( 2 ), veh_number ( 2 ) ) ;
		case 3: format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "%d%d%d%d %s%s", random ( 9 ), random ( 9 ), random ( 9 ), random ( 9 ), veh_number ( 3 ), veh_number ( 3 ) ) ;
		case 4: format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "%d%d%d%d %s%s", random ( 9 ), random ( 9 ), random ( 9 ), random ( 9 ), veh_number ( 4 ), veh_number ( 4 ) ) ;
		case 5: format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "%d%d%d%s%s%s", random ( 9 ), random ( 9 ), random ( 9 ), veh_number ( 5 ), veh_number ( 5 ), veh_number ( 5 ) ) ;
	}
	return 1 ;
}

stock show_packet_plates ( playerid, _param1, _param2, _param3, _param_str [ ] )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 ) return plates_close ( playerid, true ) ;

		if ( _param2 == 1 || _param2 == 2 )
		{
			plates_type [ playerid ] = _param2 ;
			platesLayout ( playerid, 1 ) ;
		}
		return 1 ;
	}

	if ( _param1 == 1 )
	{
		if ( _param2 == 0 ) return platesLayout ( playerid, 0 ) ;
		if ( _param2 != 1 || _param3 < 0 || _param3 > 3 ) return 1 ;

		plates_restore_vehicle ( playerid ) ;
		plates_cofirm [ playerid ] = false ;
		plates_ua_region [ playerid ] [ 0 ] = EOS ;

		if ( plates_type [ playerid ] == 1 )
		{
			new _description [ 128 ] ;
			format ( _description, sizeof _description, "Нажмите на номерную рамку, чтоб указать номер и регион. Стоимость: %d "donate_title"", PLATES_DONATE_PRICE ) ;

			plates_custom [ playerid ] = true ;
			platesLayout ( playerid, _param3 + 2 ) ;
			platesTabLayout ( playerid, _param3, true ) ;
			platesTabDescription ( playerid, _param3, _description ) ;
			platesTabButtonText ( playerid, _param3, "Оформить" ) ;
			return 1 ;
		}

		plates_custom [ playerid ] = false ;
		platesLayout ( playerid, _param3 + 2 ) ;
		platesTabLayout ( playerid, _param3, false ) ;
		platesTabDescription ( playerid, _param3, "Укажите регион. Сам номер будет подобран автоматически" ) ;
		platesTabButtonText ( playerid, _param3, "Подобрать" ) ;
		return 1 ;
	}

	if ( _param1 == 3 )
	{
		if ( _param2 < 1 || _param2 > 4 ) return 1 ;
		if ( plates_custom [ playerid ] ) return 1 ;

		new veh_id = plates_vehicle [ playerid ], _tab = _param2 - 1 ;
		if ( ! plates_owned_vehicle ( playerid, veh_id ) )
		{
			platesTabDescription ( playerid, _tab, "Вы не выбрали т/с на которое будет происходить подбор номеров." ) ;
			return 1 ;
		}

		if ( plates_cofirm [ playerid ] == true ) return show_plate_confirm ( playerid, veh_id ) ;

		if ( p_info [ playerid ] [ plates_count ] < 1 )
		{
			platesTabDescription ( playerid, _tab, "У Вас не осталось попыток подборка номера. Обратитесь к сотруднику полиции для покупки." ) ;
			return 1 ;
		}

		switch ( _param2 )
		{
			case 1:
			{
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 2 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%d", _param3 ) ;
			}
			case 2:
			{
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 3 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%s", _param_str ) ;
			}
			case 3:
			{
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 5 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%d", _param3 ) ;
			}
			case 4:
			{
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 4 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%d", _param3 ) ;
			}
		}

		player_select_count [ playerid ] = 0 ;
		plates_generate ( veh_id ) ;
		platesTabDescription ( playerid, _tab, "Подбираем номер..." ) ;
		return plates_check_query ( playerid, veh_id ) ;
	}

	if ( _param1 == 4 )
	{
		if ( _param2 == 0 )
		{
			plates_restore_vehicle ( playerid ) ;
			plates_cofirm [ playerid ] = false ;
			plates_ua_region [ playerid ] [ 0 ] = EOS ;
			platesLayout ( playerid, 1 ) ;
			return 1 ;
		}

		if ( _param2 < 1 || _param2 > 4 ) return 1 ;
		if ( plates_type [ playerid ] != 1 || ! plates_custom [ playerid ] ) return 1 ;

		new veh_id = plates_vehicle [ playerid ], _tab = _param2 - 1 ;
		if ( ! plates_owned_vehicle ( playerid, veh_id ) )
		{
			platesTabDescription ( playerid, _tab, "Вы не выбрали т/с на которое будет происходить подбор номеров." ) ;
			return 1 ;
		}

		if ( _param2 == 2 && _param3 == 1 )
		{
			if ( ! plates_valid_letters ( _param_str, 1, 2 ) )
			{
				platesTabDescription ( playerid, _tab, "Регион должен состоять из 1-2 заглавных латинских букв." ) ;
				return 1 ;
			}
			format ( plates_ua_region [ playerid ], 4, "%s", _param_str ) ;
			return 1 ;
		}

		if ( ! plates_valid_number ( _param_str ) )
		{
			platesTabDescription ( playerid, _tab, "Номер: от 3 до 6 символов. Доступны цифры и буквы ABCTXEKMHPO." ) ;
			return 1 ;
		}

		if ( p_info [ playerid ] [ donate ] < PLATES_DONATE_PRICE )
		{
			platesTabDescription ( playerid, _tab, "У Вас недостаточно "donate_title" для оформления номера." ) ;
			return 1 ;
		}

		switch ( _param2 )
		{
			case 1:
			{
				if ( _param3 < 1 || _param3 > 999 )
				{
					platesTabDescription ( playerid, _tab, "В регионе должно быть от 1 до 3 цифр." ) ;
					return 1 ;
				}
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 2 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%d", _param3 ) ;
			}
			case 2:
			{
				if ( _param3 != 2 || ! plates_ua_region [ playerid ] [ 0 ] )
				{
					platesTabDescription ( playerid, _tab, "Укажите регион и номер ещё раз." ) ;
					return 1 ;
				}
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 3 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%s", plates_ua_region [ playerid ] ) ;
			}
			case 3:
			{
				if ( _param3 < 1 || _param3 > 99 )
				{
					platesTabDescription ( playerid, _tab, "В регионе должно быть от 1 до 2 цифр." ) ;
					return 1 ;
				}
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 5 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%d", _param3 ) ;
			}
			case 4:
			{
				if ( _param3 < 1 || _param3 > 99 )
				{
					platesTabDescription ( playerid, _tab, "В регионе должно быть от 1 до 2 цифр." ) ;
					return 1 ;
				}
				veh_info [ veh_id - 1 ] [ v_plate_type ] = 4 ;
				format ( veh_info [ veh_id - 1 ] [ v_region ], 10, "%d", _param3 ) ;
			}
		}

		format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "%s", _param_str ) ;

		player_select_count [ playerid ] = 0 ;
		platesTabDescription ( playerid, _tab, "Проверяем номер..." ) ;
		return plates_check_query ( playerid, veh_id ) ;
	}
	return 1 ;
}

stock plates_apply ( _veh_id )
{
	SetVehicleNumberPlate ( veh_info [ _veh_id - 1 ] [ v_vehicle ], veh_info [ _veh_id - 1 ] [ v_plate ] ) ;
	foreach(new forplayerid: streamed_in_vehicles[_veh_id])
	{
		sc_OnVehicleStreamIn ( _veh_id, forplayerid ) ;
	}

	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "UPDATE `users_vehicles` SET `v_plate_type` = '%d', `v_plate` = '%s', `v_region` = '%s' WHERE `v_id` = '%d' LIMIT 1",
	veh_info [ _veh_id - 1 ] [ v_plate_type ], veh_info [ _veh_id - 1 ] [ v_plate ], veh_info [ _veh_id - 1 ] [ v_region ], veh_info [ _veh_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;

	veh_plate ( _veh_id ) ;
	return 1 ;
}

stock plates_buy_custom ( playerid, _veh_id )
{
	new _tab = plates_tab_from_type ( veh_info [ _veh_id - 1 ] [ v_plate_type ] ) ;

	if ( ! plates_owned_vehicle ( playerid, _veh_id ) )
	{
		plates_restore_vehicle ( playerid ) ;
		platesTabDescription ( playerid, _tab, "Вы не выбрали т/с на которое будет происходить подбор номеров." ) ;
		return 1 ;
	}

	if ( ! set_player_donate ( playerid, PLATES_DONATE_PRICE, 2 ) )
	{
		plates_restore_vehicle ( playerid ) ;
		platesTabDescription ( playerid, _tab, "У Вас недостаточно "donate_title" для оформления номера." ) ;
		return 1 ;
	}

	plates_apply ( _veh_id ) ;

	new log_string [ 64 ] ;
	format ( log_string, sizeof log_string, "(donate) номер на заказ (%s)", plate_number1 ( veh_info [ _veh_id - 1 ] [ v_plate_type ], veh_info [ _veh_id - 1 ] [ v_plate ], veh_info [ _veh_id - 1 ] [ v_region ] ) ) ;
	insert_donate_log ( playerid, INVALID_PLAYER_ID, -PLATES_DONATE_PRICE, p_info [ playerid ] [ donate ], log_string ) ;

	send_check_cinfo ( playerid, "Номерной знак оформлен.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
	return plates_close ( playerid, false ) ;
}

stock show_plate_confirm ( playerid, _veh_id )
{
	new _tab = ( _veh_id > 0 ) ? ( plates_tab_from_type ( veh_info [ _veh_id - 1 ] [ v_plate_type ] ) ) : ( 0 ) ;

	if ( ! plates_owned_vehicle ( playerid, _veh_id ) )
	{
		platesTabDescription ( playerid, _tab, "Вы не выбрали т/с на которое будет происходить подбор номеров." ) ;
		return 1 ;
	}

	new _price = price_reg_veh * for_tax [ 5 ] ;
	if ( p_info [ playerid ] [ money ] < _price )
	{
		platesTabDescription ( playerid, _tab, "У Вас недостаточно средств для оплаты номера." ) ;
		return 1 ;
	}

	plates_apply ( _veh_id ) ;

	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "покупка номера т/с (%s)", plate_number1 ( veh_info [ _veh_id - 1 ] [ v_plate_type ], veh_info [ _veh_id - 1 ] [ v_plate ], veh_info [ _veh_id - 1 ] [ v_region ] ) ) ;
	insert_money_log ( playerid, INVALID_PLAYER_ID, _price, query_string ) ;

	give_money ( playerid, -_price ) ;

    set_money_fraction ( 3, 3, floatround ( _price / 3 ), true ) ;
    set_money_fraction ( 4, 3, floatround ( _price / 3 ), true ) ;
    set_money_fraction ( 5, 3, floatround ( _price / 3 ), true ) ;

	send_check_cinfo ( playerid, "Номерной знак оформлен.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
	return plates_close ( playerid, false ) ;
}

stock plates_retry_or_fail ( playerid, _veh_id )
{
	if ( plates_custom [ playerid ] )
	{
		new _tab = plates_tab_from_type ( veh_info [ _veh_id - 1 ] [ v_plate_type ] ) ;
		plates_restore_vehicle ( playerid ) ;
		player_select_count [ playerid ] = 0 ;
		platesTabDescription ( playerid, _tab, "Такой номер уже занят. Укажите другой." ) ;
		return 1 ;
	}

	if ( player_select_count [ playerid ] >= 5 )
	{
		send_check_cinfo ( playerid, "Произошла ошибка, попробуйте еще раз.\nВсе варианты подбора уже заняты. Попробуйте подобрать номера ещё раз.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return plates_close ( playerid, true ) ;
	}

	plates_generate ( _veh_id ) ;
	return plates_check_query ( playerid, _veh_id ) ;
}

callback: check_plate_from_vehicle ( playerid, _veh_id )
{
	if ( plates_vehicle [ playerid ] != _veh_id ) return 1 ;

	player_select_count [ playerid ] ++ ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows ) return plates_retry_or_fail ( playerid, _veh_id ) ;

	new scm_string [ 144 ] ;
	format ( scm_string, sizeof scm_string, "SELECT `p_id` FROM `users_plates` WHERE `p_type` = '%d' AND `p_name` = '%s' AND `p_region` = '%s' LIMIT 1", veh_info [ _veh_id - 1 ] [ v_plate_type ], veh_info [ _veh_id - 1 ] [ v_plate ], veh_info [ _veh_id - 1 ] [ v_region ] ) ;
	mysql_tquery ( sql_connection, scm_string, "check_plate_from_inventory", "ii", playerid, _veh_id ) ;
	return 1 ;
}

callback: check_plate_from_inventory ( playerid, _veh_id )
{
	if ( plates_vehicle [ playerid ] != _veh_id ) return 1 ;

	player_select_count [ playerid ] ++ ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows ) return plates_retry_or_fail ( playerid, _veh_id ) ;

	player_select_count [ playerid ] = 0 ;

	if ( plates_custom [ playerid ] ) return plates_buy_custom ( playerid, _veh_id ) ;

	new _tab = plates_tab_from_type ( veh_info [ _veh_id - 1 ] [ v_plate_type ] ) ;
	if ( ! plates_owned_vehicle ( playerid, _veh_id ) )
	{
		platesTabDescription ( playerid, _tab, "Вы не выбрали т/с на которое будет происходить подбор номеров." ) ;
		return 1 ;
	}

	new _description [ 96 ] ;
	format ( _description, sizeof _description, "Номер подобран. Стоимость оформления: %s"valute_title_"", GetPlayerCashValueToSmile ( price_reg_veh * for_tax [ 5 ] ) ) ;

	platesTabButton ( playerid, _tab, veh_info [ _veh_id - 1 ] [ v_plate ] ) ;
	platesTabDescription ( playerid, _tab, _description ) ;
	platesTabButtonText ( playerid, _tab, "Оформить" ) ;

	p_info [ playerid ] [ plates_count ] -= 1 ;
	plates_cofirm [ playerid ] = true ;
	return 1 ;
}
