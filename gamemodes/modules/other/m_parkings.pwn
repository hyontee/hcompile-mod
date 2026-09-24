#include 									<custom/parkings>

stock open_parking ( playerid, _b_id )
{
	if ( b_info [ _b_id - 1 ] [ b_car_cooldown ] [ 1 ] > gettime ( ) )
	{
		send_check_cinfo ( playerid, "Транспорт можно брать раз в 60 секунд.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
	
	foreach(new _veh_id: player_vehicles[playerid])
	{
	    new Float: _x_v, Float: _x_y, Float: _x_z ;
		GetVehiclePos ( _veh_id, _x_v, _x_y, _x_z ) ;
		if ( ! IsPlayerInRangeOfPoint ( playerid, 100.0, _x_v, _x_y, _x_z ) ) continue ;
		
		send_check_cinfo ( playerid, "Рядом с Вами есть Ваше т/с!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
	
	b_info [ _b_id - 1 ] [ b_car_cooldown ] [ 1 ] = gettime ( ) + 60 ;
	
	SetParkingShow ( playerid ) ;
	parking_loaded_cars ( playerid ) ;
	
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

stock show_packet_parking ( playerid, _i1, _i2 )
{
	if ( _i1 == 0 )
	{
		if ( _i2 == 0 )
		{
			SetParkingHide ( playerid ) ;
		
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		}
		else if ( _i2 == 1 ) // key no
		{
			
		}
		else if ( _i2 == 2 ) // key yes
		{
			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			if ( _b_id < 1 ) return bad_exit ( playerid ) ;
					
			new _b_cost = b_info [ _b_id - 1 ] [ b_cost ] ;
			if ( p_info [ playerid ] [ money ] < _b_cost )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			_i2 = get_player_use_listitem ( playerid ) ;
			if ( GetPVarInt ( playerid, "parking_type" ) == 1 )
			{
				new bool: _player_finded = false, _inc_id ;
				foreach(new _veh_id: player_vehicles[playerid])
				{
					if ( veh_info [ _veh_id - 1 ] [ v_id ] != _i2 ) continue ;

					_inc_id = _veh_id ;
					_player_finded = true ;
					break ;
				}

				if ( ! _player_finded )
				{
					new sql_string [ 62 + 11 ] ;
					format ( sql_string, sizeof sql_string, "SELECT * FROM `users_vehicles` WHERE `v_id` = '%d' LIMIT 1", _i2 ) ;
					mysql_tquery ( sql_connection, sql_string, "load_parking_vehicles", "iii", playerid, false, _b_id ) ;
					
					SetParkingHide ( playerid ) ;
				
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
				}
				else
				{
					if ( v_plane ( _inc_id ) || v_boat ( _inc_id ) )
					{
						send_check_cinfo ( playerid, "Данный вид транспорта не доступен для буксировки!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
			
					SetVehiclePos ( _inc_id, b_info [ _b_id - 1 ] [ b_repair ] [ 0 ], b_info [ _b_id - 1 ] [ b_repair ] [ 1 ], b_info [ _b_id - 1 ] [ b_repair ] [ 2 ] ) ;
					SetVehicleZAngle ( _inc_id, b_info [ _b_id - 1 ] [ b_repair ] [ 3 ] ) ;
					LinkVehicleToInterior( _inc_id, 0 );
					SetVehicleVirtualWorld ( _inc_id, 0 );
					
					SetParkingHide ( playerid ) ;
				
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
				
					give_money ( playerid, -_b_cost ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -_b_cost, "паркомат" ) ;
					give_bmoney ( _b_id, _b_cost, 0 ) ;
				
					send_check_cinfo ( playerid, "Вы успешно загрузили транспорт рядом с Вами.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
			}
			else if ( GetPVarInt ( playerid, "parking_type" ) == 2 )
			{
				new bool: _player_finded = false, _inc_id ;
				foreach(new _veh_id: player_vehicles[playerid])
				{
					if ( veh_info [ _veh_id - 1 ] [ v_id ] != _i2 ) continue ;
					
					new Float: _x_v, Float: _x_y, Float: _x_z ;
					GetVehiclePos ( _veh_id, _x_v, _x_y, _x_z ) ;
					if ( ! IsPlayerInRangeOfPoint ( playerid, 15.0, _x_v, _x_y, _x_z ) ) continue ;

					_inc_id = _veh_id ;
					_player_finded = true ;
					break ;
				}
				
				if ( ! _player_finded )
				{
					send_check_cinfo ( playerid, "Транспорт не загружен или не рядом с Вами!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				veh_info [ _inc_id - 1 ] [ v_fuel ] += 20.0 ;
				
				give_money ( playerid, -_b_cost ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -_b_cost, "паркомат" ) ;
				give_bmoney ( _b_id, _b_cost, 0 ) ;
				
				send_check_cinfo ( playerid, "Вы успешно заправили т/с на 20 литров.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
					
				SetParkingHide ( playerid ) ;
				
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			}
		}
	}
	else if ( _i1 == 1 )
	{
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		if ( _b_id < 1 ) return bad_exit ( playerid ) ;
					
		set_player_use_listitem ( playerid, _i2 ) ;
		SetPVarInt ( playerid, "parking_type", 1 ) ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 128, "Вы действительно хотите буксировать транспорт за %d"valute_title_"?", b_info [ _b_id - 1 ] [ b_cost ] ) ;
		SetParkingDialog ( playerid, "Буксировка", global_string, "Нет", "Да" ) ;
	}
	else if ( _i1 == 2 )
	{
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		if ( _b_id < 1 ) return bad_exit ( playerid ) ;
		
		set_player_use_listitem ( playerid, _i2 ) ;
		SetPVarInt ( playerid, "parking_type", 2 ) ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 128, "Вы действительно хотите заправить транспорт на 20л за %d"valute_title_"?", b_info [ _b_id - 1 ] [ b_cost ] ) ;
		SetParkingDialog ( playerid, "Заправка", global_string, "Нет", "Да" ) ;
	}
	return 1 ;
}

callback: load_parking_vehicles ( playerid, bool: status, _b_id )
{
	new fields,
		rows ;

	cache_get_data ( rows, fields ) ;
	if( rows )
	{
	    new unix_time = gettime ( ) ;
		for ( new i = 0 ; i < rows ; i++ )
		{
			new veh_id = GetVehicleID ( ) ;

			veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_player ;
			
			veh_info [ veh_id - 1 ] [ v_fine ] = cache_get_field_content_int ( i, "v_fine", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_sell_price ] = cache_get_field_content_int ( i,"v_sell_price", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_fine ] == 1 )
		    {
		        show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "{"#cRD"}ВНИМАНИЕ!\n\n{"#cRD"}ОДИН ИЗ ВАШИХ АВТОМОБИЛЕЙ НАХОДИТСЯ НА ШТРАФСТОЯНКЕ\n{"#cBL"}Чтобы забрать используйте {"#cWH"}'/gps > Прочее > Штрафстоянка'{"#cBL"}.", "Принять", "Закрыть" ) ;
				return 1 ;
			}
			else if ( veh_info [ veh_id - 1 ] [ v_fine ] == 2 )
		    {
		        show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "{"#cRD"}ВНИМАНИЕ!\n\n{"#cRD"}ОДИН ИЗ ВАШИХ АВТОМОБИЛЕЙ НАХОДИТСЯ В СЕМЕЙНОМ АВТОПАРКЕ\n{"#cBL"}Чтобы забрать используйте {"#cWH"}'/fixcar'{"#cBL"}.", "Принять", "Закрыть" ) ;
				return 1 ;
			}
			else if ( veh_info [ veh_id - 1 ] [ v_sell_price ] )
		    {
		        show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "{"#cRD"}ВНИМАНИЕ!\n\n{"#cRD"}ОДИН ИЗ ВАШИХ АВТОМОБИЛЕЙ ВЫСТАВЛЕН НА ПРОДАЖУ НА АВТОРЫНКЕ\n{"#cBL"}Чтобы забрать используйте {"#cWH"}'/gps > Бизнесы > Авторынки'{"#cBL"}.", "Принять", "Закрыть" ) ;
				return 1 ;
			}

			veh_info [ veh_id - 1 ] [ v_id ] = cache_get_field_content_int ( i, "v_id", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_model ] = cache_get_field_content_int ( i, "v_model", sql_connection ) ;
			if ( v_plane ( veh_info [ veh_id - 1 ] [ v_model ], 1 ) || v_boat ( veh_info [ veh_id - 1 ] [ v_model ], 1 ) )
			{
				send_check_cinfo ( playerid, "Данный вид транспорта не доступен для буксировки!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			veh_info [ veh_id - 1 ] [ v_owner ] = cache_get_field_content_int ( i, "v_owner", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_owner_id ] = playerid ;
			
			veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = cache_get_field_content_int ( i, "v_color_1", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = cache_get_field_content_int ( i, "v_color_2", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_plate_type ] = cache_get_field_content_int ( i, "v_plate_type", sql_connection ) ;
			cache_get_field_content ( i, "v_plate", veh_info [ veh_id - 1 ] [ v_plate ], sql_connection, 12 ) ;
			cache_get_field_content ( i, "v_region", veh_info [ veh_id - 1 ] [ v_region ], sql_connection, 10 ) ;

			veh_info [ veh_id - 1 ] [ v_fuel ] = cache_get_field_content_float ( i,"v_fuel", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_millage ] = cache_get_field_content_float ( i,"v_millage", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_legal_millage ] = cache_get_field_content_float ( i,"v_legal_millage", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_rank ] =
			veh_info [ veh_id - 1 ] [ v_sell_price ] =
			veh_info [ veh_id - 1 ] [ v_sell_slot ] =
			veh_info [ veh_id - 1 ] [ v_sell_carmarket ] = 0 ;

			veh_info [ veh_id - 1 ] [ v_engine_boost ] = cache_get_field_content_float ( i,"v_engine_boost", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_brake_boost ] = cache_get_field_content_float ( i,"v_brake_boost", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_stability_boost ] = cache_get_field_content_float ( i,"v_stability_boost", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_vw ] = cache_get_field_content_int ( i, "v_vw", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_int ] = cache_get_field_content_int ( i, "v_int", sql_connection ) ;
			
			veh_info [ veh_id - 1 ] [ v_key ] = cache_get_field_content_int ( i, "v_key", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_date_used ] = cache_get_field_content_int ( i, "v_date_used", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_date_used ] > 0 )
			{
				if ( veh_info [ veh_id - 1 ] [ v_date_used ] - unix_time < 0 )
				{
				    new query_string [ 59 + 9 ] ;
	                format ( query_string, sizeof ( query_string ), "DELETE FROM `users_vehicles` WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
					mysql_tquery( sql_connection, query_string ) ;

					new scm_string [ 90 + 32 ] ;
					format ( scm_string, sizeof scm_string, "{"#cRInfo"}* {"#cGRInfo"}Действие т/с {"#cRInfo"}%s {"#cGRInfo"}подошло к концу.", GetVehicleNameEx ( -1, veh_info [ veh_id - 1 ] [ v_model ] ) ) ;
					insert_debtor_message ( "Транспорт", scm_string, p_info [ playerid ] [ id ] ) ;

					SendClientMessage ( playerid, col_gray, scm_string ) ;
					
					format ( scm_string, sizeof scm_string, "Действие т/с %s подошло к концу.", GetVehicleNameEx ( -1, veh_info [ veh_id - 1 ] [ v_model ] ) ) ;
					WriteLogs ( playerid, p_info [ playerid ] [ member ], TYPE_LOG_DEBTORS, scm_string ) ;

					veh_info [ veh_id - 1 ] [ v_date_used ] = 0 ;

					if ( p_info [ playerid ] [ max_veh_timeing ] > 0 )
					{
					    p_info [ playerid ] [ max_veh ] -= 1 ;
						p_info [ playerid ] [ max_veh_timeing ] -= 1 ;

						new sql_string [ 126 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` - '1', `u_maxveh_timeing` = `u_maxveh_timeing` - '1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
					return 1 ;
				}
			}

			veh_info [ veh_id - 1 ] [ v_pantera_strobs ] = cache_get_field_content_int ( i, "v_pantera_strobs", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_alarm ] = cache_get_field_content_int ( i, "v_pantera_alarm", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_engine ] = cache_get_field_content_int ( i, "v_pantera_engine", sql_connection ) ;

			new sscanf_delimit [ 128 ] ;
			veh_info [ veh_id - 1 ] [ v_pantera_radar ] = cache_get_field_content_int ( i, "v_pantera_radar", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_rdate ] = cache_get_field_content_int ( i, "v_pantera_rdate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_rdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_radar ] )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_rdate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_radar ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `users_vehicles` SET `v_pantera_rdate` = '0', `v_pantera_radar` = '0' WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_pantera_gps ] = cache_get_field_content_int ( i, "v_pantera_gps", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_gdate ] = cache_get_field_content_int ( i, "v_pantera_gdate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_gdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_gps ] )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_gdate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_gps ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `users_vehicles` SET `v_pantera_gdate` = '0', `v_pantera_gps` = '0' WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_pantera_armour ] = cache_get_field_content_int ( i, "v_pantera_armour", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_adate ] = cache_get_field_content_int ( i, "v_pantera_adate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_adate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_armour ] )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_adate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_armour ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `users_vehicles` SET `v_pantera_adate` = '0', `v_pantera_armour` = '0' WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_pantera_launch ] = cache_get_field_content_int ( i, "v_pantera_launch", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_ldate ] = cache_get_field_content_int ( i, "v_pantera_ldate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_ldate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_launch ] == 1 )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_ldate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_launch ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `users_vehicles` SET `v_pantera_ldate` = '0', `v_pantera_launch` = '0' WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}
			
			veh_info [ veh_id - 1 ] [ v_sound ] = cache_get_field_content_int ( i, "v_sound", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_sdate ] = cache_get_field_content_int ( i, "v_pantera_sdate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_sdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_sound ] == 1 )
			{
			    veh_info [ veh_id - 1 ] [ v_sound ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_sdate ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `users_vehicles` SET `v_sound` = '0', `v_pantera_sdate` = '0' WHERE `v_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			sscanf_delimit [ 0 ] = EOS ;
			cache_get_field_content ( i, "v_suspension", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>ff", veh_info [ veh_id - 1 ] [ v_suspension ] [ 0 ], veh_info [ veh_id - 1 ] [ v_suspension ] [ 1 ] ) ;

			veh_info [ veh_id - 1 ] [ v_wheel_size ] = cache_get_field_content_float ( i, "v_wheel_size", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_wheel_width ] = cache_get_field_content_int ( i, "v_wheel_width", sql_connection ) ;

			cache_get_field_content ( i, "v_wheel_alignment", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] ) ;

			cache_get_field_content ( i, "v_wheel_offset", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 1 ] ) ;

			veh_info [ veh_id - 1 ] [ v_lights_color ] = cache_get_field_content_int ( i, "v_lights_color", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_neon ] = cache_get_field_content_int ( i, "v_neon", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_neon_type ] = cache_get_field_content_int ( i, "v_neon_type", sql_connection ) ;
			
			cache_get_field_content ( i, "v_toner", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>dddd", veh_info [ veh_id - 1 ] [ v_toner ] [ 0 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 1 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 2 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 3 ] ) ;

			veh_info [ veh_id - 1 ] [ v_vinyl ] = cache_get_field_content_int ( i, "v_vinyl", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_stage_speed ] = cache_get_field_content_int ( i, "v_stage_speed", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_stage_brake ] = cache_get_field_content_int ( i, "v_stage_brake", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_trunk_open ] = false ;
			veh_info [ veh_id - 1 ] [ v_trunk_load ] = false ;

            veh_plate ( veh_id ) ;

			cache_get_field_content ( i, "v_eng_details", sscanf_delimit, sql_connection, 16 ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 4 ]	) ;

			cache_get_field_content ( i, "v_brake_details", sscanf_delimit, sql_connection, 16 ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 4 ]	) ;

			cache_get_field_content ( i, "v_stab_details", sscanf_delimit, sql_connection, 16 ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 4 ]	) ;

			cache_get_field_content ( i, "v_components", sscanf_delimit, sql_connection, 128 ) ;
			sscanf ( sscanf_delimit, "p<|>dddddddddd", veh_info [ veh_id - 1 ] [ v_component ] [ 0 ], veh_info [ veh_id - 1 ] [ v_component ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_component ] [ 2 ], veh_info [ veh_id - 1 ] [ v_component ] [ 3 ], veh_info [ veh_id - 1 ] [ v_component ] [ 4 ],
			veh_info [ veh_id - 1 ] [ v_component ] [ 5 ], veh_info [ veh_id - 1 ] [ v_component ] [ 6 ], veh_info [ veh_id - 1 ] [ v_component ] [ 7 ],
			veh_info [ veh_id - 1 ] [ v_component ] [ 8 ], veh_info [ veh_id - 1 ] [ v_component ] [ 9 ] ) ;

			veh_info [ veh_id - 1 ] [ v_gps_tracker ] = cache_get_field_content_int ( i, "v_gps_tracker", sql_connection ) ;

   			if ( status ) veh_info [ veh_id - 1 ] [ v_fine_time ] = 120 ;
   			else
			{
			    format ( sscanf_delimit, 110, "{"#cGInfo"}* {"#cWH"}Вы успешно загрузили {"#cGN"}%s{"#cWH"} в игру.", GetVehicleNameEx ( -1, veh_info [ veh_id - 1 ] [ v_model ] ) ) ;
				SendClientMessage ( playerid, col_white, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], b_info [ _b_id - 1 ] [ b_repair ] [ 0 ], b_info [ _b_id - 1 ] [ b_repair ] [ 1 ], b_info [ _b_id - 1 ] [ b_repair ] [ 2 ], b_info [ _b_id - 1 ] [ b_repair ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_PLAYER_VEHICLE ) ;
			SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;

			veh_info [ veh_id - 1 ] [ v_paint ] = cache_get_field_content_int ( i, "v_paint", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_price ] = cache_get_field_content_int ( i, "v_price", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_paint ] != 3 )
			{
				ChangeVehiclePaintjob ( veh_id, veh_info [ veh_id - 1 ] [ v_paint ] ) ;
			}

			LinkVehicleToInterior ( veh_id, 0 ) ;
			SetVehicleVirtualWorld ( veh_id, 0 ) ;

			if ( veh_info [ veh_id - 1 ] [ v_model ] != 444 )
			{
				for ( new j = 0; j < 10; j ++ )
				{
				    if ( veh_info [ veh_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
					AddVehicleComponent ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_component ] [ j ] ) ;
				}
			}

			Iter_Add(player_vehicles[playerid], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
			veh_info [ veh_id - 1 ] [ v_spawn_time ] = gettime ( ) + 180 ;

			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ veh_id - 1 ] [ v_locked ] = true ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, engine, lights, alarm, true, bonnet, boot, objective ) ;
				
			give_money ( playerid, -b_info [ _b_id - 1 ] [ b_cost ] ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -b_info [ _b_id - 1 ] [ b_cost ], "паркомат" ) ;
				
			send_check_cinfo ( playerid, "Вы успешно загрузили транспорт рядом с Вами.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		}
	}
	return 1 ;
}

stock parking_loaded_cars ( playerid )
{
	new sql_string [ 159 + 9 + 4 ] ;
	format ( sql_string, sizeof sql_string, "SELECT `v_id`, `v_model`, `v_date_used`, `v_fine`, `v_sell_price`, `v_color_1`, `v_color_2`, `v_fuel` FROM `users_vehicles` WHERE `v_owner` = '%d' LIMIT %d", p_info [ playerid ] [ id ], p_info [ playerid ] [ max_veh ] ) ;
	mysql_tquery ( sql_connection, sql_string, "callback_parking", "i", playerid ) ;
	return 1 ;
}

callback: callback_parking ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;

	if ( ! rows )
	{
		send_check_cinfo ( playerid, "У Вас нет транспорта для буксировки!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	global_string [ 0 ] = EOS ;
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PARKING_CAR);

    BS_WriteValue(bitstream, PR_UINT8, rows);
	for ( new i = 0 ; i < rows ; i ++ )
	{
	    new _v_id = cache_get_field_content_int ( i, "v_id", sql_connection ) ;
	    new _v_model = cache_get_field_content_int ( i, "v_model", sql_connection ) ;
	    new _v_date_used = cache_get_field_content_int ( i, "v_date_used", sql_connection ) ;
	    new _v_fine = cache_get_field_content_int ( i, "v_fine", sql_connection ) ;
	    new _v_sell_price = cache_get_field_content_int ( i, "v_sell_price", sql_connection ) ;

	    new _v_color_1 = cache_get_field_content_int ( i, "v_color_1", sql_connection ) ;
	    new _v_color_2 = cache_get_field_content_int ( i, "v_color_2", sql_connection ) ;
	    new Float: _v_fuel = cache_get_field_content_float ( i, "v_fuel", sql_connection ) ;
		
		BS_WriteValue(bitstream, PR_UINT32, _v_id);
		BS_WriteValue(bitstream, PR_UINT8, 3);
		BS_WriteValue(bitstream, PR_UINT32, _v_model);
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, _v_model ) ) ) ;
		BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, _v_model ) ) ;
		
		BS_WriteValue(bitstream, PR_UINT8, _v_color_1);
		BS_WriteValue(bitstream, PR_UINT8, _v_color_2);
				
		BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
		
		BS_WriteValue(bitstream, PR_UINT32, 1000);
		BS_WriteValue(bitstream, PR_UINT8, floatround ( _v_fuel ));
		if ( _v_fuel < 20 ) BS_WriteValue(bitstream, PR_UINT8, 0);
		else BS_WriteValue(bitstream, PR_UINT8, 1);

		new bool: _status = false ;
	    if ( _v_date_used > 0 )
		{
			BS_WriteValue(bitstream, PR_UINT8, strlen ( "Временная" ) ) ;
			BS_WriteValue(bitstream, PR_STRING, "Временная" ) ;
			_status = true ;
		}
		if ( ! _status && _v_fine == 1 )
		{
			BS_WriteValue(bitstream, PR_UINT8, strlen ( "На штрафстоянке" ) ) ;
			BS_WriteValue(bitstream, PR_STRING, "На штрафстоянке" ) ;
			_status = true ;
		}
		if ( ! _status && _v_fine == 2 )
		{
			BS_WriteValue(bitstream, PR_UINT8, strlen ( "В семье" ) ) ;
			BS_WriteValue(bitstream, PR_STRING, "В семье" ) ;
			_status = true ;
		}
		if ( ! _status && _v_sell_price )
		{
			BS_WriteValue(bitstream, PR_UINT8, strlen ( "Выставлена на продажу" ) ) ;
			BS_WriteValue(bitstream, PR_STRING, "Выставлена на продажу" ) ;
			_status = true ;
		}
		
		if ( ! _status )
		{
			BS_WriteValue(bitstream, PR_UINT8, strlen ( " " ) ) ;
			BS_WriteValue(bitstream, PR_STRING, " " ) ;
		}
	}

    PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	return 1 ;
}