new boats_price [ 3 ] = { 20_000_000, 500, 300 } ;
new boats_model [ ] = { 446, 453, 454, 473, 472, 493 } ;
new planes_model [ ] = { 447, 469, 487, 519, 593 } ;

new Float: boats_rent_position [ 4 ] = { 2421.4953, 216.8511, -0.5305, 148.7870 } ;
new Float: planes_rent_position [ 4 ] = { 2127.5937, -2024.5678, 19.0725, 268.3829 } ;

#include 									<custom/boats>

enum
{
	d_boats_stage = 10111
} ;

new bool: used_boats [ MAX_PLAYERS ] ;
new opened_boats [ MAX_PLAYERS char ] ;
new boats_select [ MAX_PLAYERS char ] ;
new boats_tickcount [ MAX_PLAYERS ] ;

stock boats_clear_data ( playerid )
{
	used_boats [ playerid ] = false ;
	opened_boats { playerid } = 0 ;
	return 1 ;
}

stock boats_OnPlayerDisconnect ( playerid )
{
	if ( used_boats [ playerid ] == true )
	{
		used_boats [ playerid ] = false ;
		p_t_info [ playerid ] [ tuning_vehicle ] = INVALID_PLAYER_ID ;
		TogglePlayerControllable ( playerid, true ) ;
	}
	return 1 ;
}

/*CMD:prent ( playerid )
{
	SetBoatsRent ( playerid, 0 ) ;
	SetBoatsShow ( playerid, 0 ) ;
	opened_boats { playerid } = 1 ;
	return 1 ;
}

CMD:boats ( playerid )
{
	SetBoatsShow ( playerid, 2 ) ;
	
	p_t_info [ playerid ] [ tuning_vehicle ] = GetPlayerVehicleID ( playerid ) ;
	SetBoatsUpgrade ( playerid, p_t_info [ playerid ] [ tuning_vehicle ] ) ;
	
	used_boats [ playerid ] = true ;
	TogglePlayerControllable ( playerid, false ) ;
	return 1 ;
}*/

stock load_planes_or_boats ( playerid, _type )
{
	if ( ! bad_dialog ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRDialog"}В данный момент недоступно." ) ;

    new sql_string [ 82 + ( 9 * 2 ) ] ;
	format ( sql_string, sizeof sql_string, "SELECT `v_id`, `v_model` FROM `users_vehicles` WHERE `v_owner` = '%d' LIMIT %d", p_info [ playerid ] [ id ], p_info [ playerid ] [ max_veh ] ) ;
	mysql_tquery ( sql_connection, sql_string, "callback_planes_or_boats", "ii", playerid, _type ) ;
	return 1 ;
}

callback: callback_planes_or_boats ( playerid, _type )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;

	if ( ! rows ) return send_check_cinfo ( playerid, "У Вас нет данного типа транспорта!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;

	new bool: _player_finded = false, _c_count = 0 ;
	new _v_model [ 30 ] = { -1, ... } ;
	new _v_id [ 30 ] = { -1, ... } ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
	    new ___v_id = cache_get_field_content_int ( i, "v_id", sql_connection ) ;
	    new ___v_model = cache_get_field_content_int ( i, "v_model", sql_connection ) ;
		if ( _type == 0 && ! v_plane ( ___v_model, 1 ) ) continue ;
		if ( _type == 1 && ! v_boat ( ___v_model, 1 ) ) continue ;
		
		_v_id [ _c_count ] = ___v_id ;
		_v_model [ _c_count ] = ___v_model ;
		
		_c_count ++ ;
	}
	
	if ( _c_count > 0 )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_SELECT);
	
		BS_WriteValue(bitstream, PR_UINT8, _c_count);
		for ( new i = 0 ; i < _c_count ; i ++ )
		{
			foreach(new _veh_id: player_vehicles[playerid])
			{
				if ( veh_info [ _veh_id - 1 ] [ v_id ] != _v_id [ i ] ) continue ;

				_player_finded = true ;
				break ;
			}

			if ( _type == 1 )
			{
				new _model = _v_model [ i ] ;
				BS_WriteValue(bitstream, PR_UINT32, _v_id [ i ]);
				BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, _model ) ) ) ;
				BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, _model ) ) ;
				BS_WriteValue(bitstream, PR_UINT16, max_veh_speed ( _model ) ) ;
				if ( _player_finded ) BS_WriteValue(bitstream, PR_BOOL, true);
				else BS_WriteValue(bitstream, PR_BOOL, false);
				BS_WriteValue(bitstream, PR_UINT8, 1);
				BS_WriteValue(bitstream, PR_UINT16, _model);
			}
			else
			{
				new _model = _v_model [ i ] ;
				BS_WriteValue(bitstream, PR_UINT32, _v_id [ i ]);
				BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, _model ) ) ) ;
				BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, _model ) ) ;
				BS_WriteValue(bitstream, PR_UINT16, max_veh_speed ( _model ) ) ;
				if ( _player_finded ) BS_WriteValue(bitstream, PR_BOOL, true);
				else BS_WriteValue(bitstream, PR_BOOL, false);
				BS_WriteValue(bitstream, PR_UINT8, 1);
				BS_WriteValue(bitstream, PR_UINT16, _model);
			}

			_player_finded = false ;
		}

		PR_SendPacket(bitstream, playerid);

		BS_Delete(bitstream);
	}
	
	SetBoatsShow ( playerid, 1 ) ;
	return 1 ;
}

stock use_boats_manager ( playerid, _i, _i2, _i3 )
{
	if ( _i == 0 && _i2 == 0 && _i3 == 0 )
	{
		SetBoatsHide ( playerid ) ;
		TogglePlayerControllable ( playerid, true ) ;
		used_boats [ playerid ] = false ;
		opened_boats { playerid } = 0 ;
		DeletePVar ( playerid, "p_biz_id" ) ;
		p_t_info [ playerid ] [ tuning_vehicle ] = INVALID_VEHICLE_ID ;
	}
	else if ( _i == 1 && _i2 == 0 && _i3 == 0 )
	{
		if ( opened_boats { playerid } == 1 )
		{
			if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Откройте меню заново. Ошибка: SetBoatsRent." ) ;
				return 1 ;
			}
			
			SetBoatsRent ( playerid, 0 ) ;
			SetBoatsShow ( playerid, 0 ) ;
		}
		else if ( opened_boats { playerid } == 2 )
		{
			if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Откройте меню заново. Ошибка: SetBoatsRent." ) ;
				return 1 ;
			}
			
			SetBoatsRent ( playerid, 1 ) ;
			SetBoatsShow ( playerid, 1 ) ;
		}
		else
		{
			SetBoatsShow ( playerid, 2 ) ;
			SetBoatsUpgrade ( playerid, p_t_info [ playerid ] [ tuning_vehicle ] ) ;
		}
	}
	else if ( _i == 2 )
	{
		if ( _i2 == 0 && _i3 == 0 )
		{
			if ( opened_boats { playerid } == 1 )
			{
				if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Откройте меню заново. Ошибка: SetBoatsRent." ) ;
					return 1 ;
				}
				
				SetBoatsRent ( playerid, 0 ) ;
			}
			else if ( opened_boats { playerid } == 2 )
			{
				if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Откройте меню заново. Ошибка: SetBoatsRent." ) ;
					return 1 ;
				}
				
				SetBoatsRent ( playerid, 1 ) ;
			}
			SetBoatsShow ( playerid, 4 ) ;
		}
		else if ( _i2 == 1 && _i3 == 0 )
		{
			if ( GetTickCount ( ) - boats_tickcount [ playerid ] < 5000 )
			{
				send_check_cinfo ( playerid, "Транспорт можно загружать раз в 5 секунд!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			boats_tickcount [ playerid ] = GetTickCount ( ) ;
			load_planes_or_boats ( playerid, opened_boats { playerid } - 1 ) ;
		}
	}
	else if ( _i == 3 )
	{
		new _finded_cars = false, _inc_id ;
		foreach(new _veh_id: player_vehicles[playerid])
		{
		    if ( veh_info [ _veh_id - 1 ] [ v_id ] != _i2 ) continue ;

		    _inc_id = _veh_id ;
		    _finded_cars = true ;
		    break ;
		}
		
		if ( _i3 == 0 )
		{
			if ( ! _finded_cars )
			{
				if ( GetTickCount ( ) - boats_tickcount [ playerid ] < 5000 )
				{
					send_check_cinfo ( playerid, "Транспорт можно загружать раз в 5 секунд!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				boats_tickcount [ playerid ] = GetTickCount ( ) ;
				
			    new sql_string [ 62 + 11 ] ;
			    format ( sql_string, sizeof sql_string, "SELECT * FROM `users_vehicles` WHERE `v_id` = '%d' LIMIT 1", _i2 ) ;
				mysql_tquery ( sql_connection, sql_string, "load_player_vehicles", "iii", playerid, false, -1 ) ;
				
				send_check_cinfo ( playerid, "Транспорт успешно загружен!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			    return 1 ;
			}
			else
			{
				if ( GetPlayerVehicleID ( playerid ) == _inc_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сперва покиньте транспорт." ) ;
				if ( veh_info [ _inc_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Повторите попытку. Ошибка: d_fixcar." ) ;

		        new query_string [ 156 ] ;
				format ( query_string, sizeof ( query_string ),"UPDATE `users_vehicles` SET `v_fuel` = '%f',`v_millage` = '%f' WHERE `v_id` = '%d' LIMIT 1",
				veh_info [ _inc_id - 1 ] [ v_fuel ],
				veh_info [ _inc_id - 1 ] [ v_millage ],
				veh_info [ _inc_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, query_string, "", "" ) ;

				format ( query_string, 110, "{"#cGInfo"}* {"#cWH"}Вы успешно выгрузили {"#cGN"}%s{"#cWH"} из игры.", GetVehicleNameEx ( veh_info [ _inc_id - 1 ] [ v_vehicle ] ) ) ;
				SendClientMessage ( playerid, col_white, query_string ) ;

		        Iter_Remove(player_vehicles[playerid], _inc_id ) ;

				DestroyVehicle ( _inc_id, 101 ) ;
				
				send_check_cinfo ( playerid, "Транспорт успешно выгружен!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				load_planes_or_boats ( playerid, opened_boats { playerid } - 1 ) ;
			}
		}
		else if ( _i3 == 1 )
		{
			set_player_use_listitem ( playerid, _inc_id ) ;

			new header_string [ 46 ] ;
			format ( header_string, sizeof header_string, "{"#cBHD"}%s", GetVehicleNameEx ( _inc_id ) ) ;
			
			if ( veh_info [ _inc_id - 1 ] [ v_locked ] == false )
			{
				show_dialog
				(
					playerid, d_fine_fixcar, DIALOG_STYLE_LIST,
					header_string, "\
					{"#cBL"}1. {"#cWH"}Выгрузить транспорт с сервера\n\
					{"#cBL"}2. {"#cWH"}Отметить транспорт на GPS [{"#cGN"}500${"#cWH"}]\n\
					{"#cBL"}3. {"#cWH"}Отправить на штрафстоянку\n\
					{"#cBL"}4. {"#cWH"}Доставка т/с к месту парковки [{"#cGN"}1200${"#cWH"}]\n\
					{"#cBL"}5. {"#cWH"}Открыть транспорт",
					"Выбрать", "Закрыть"
				) ;
			}
			else
			{
				show_dialog
				(
					playerid, d_fine_fixcar, DIALOG_STYLE_LIST,
					header_string, "\
					{"#cBL"}1. {"#cWH"}Выгрузить транспорт с сервера\n\
					{"#cBL"}2. {"#cWH"}Отметить транспорт на GPS [{"#cGN"}500${"#cWH"}]\n\
					{"#cBL"}3. {"#cWH"}Отправить на штрафстоянку\n\
					{"#cBL"}4. {"#cWH"}Доставка т/с к месту парковки [{"#cGN"}1200${"#cWH"}]\n\
					{"#cBL"}5. {"#cWH"}Закрыть транспорт",
					"Выбрать", "Закрыть"
				) ;
			}
		}
	}
	else if ( _i == 5 )
	{
		if ( _i2 >= 0 && _i2 <= 2 && _i3 == 0 )
		{
			new _vehicleid = p_t_info [ playerid ] [ tuning_vehicle ] ;
			boats_select { playerid } = veh_info [ _vehicleid - 1 ] [ v_stage_speed ] + 1 ;
			new td_string [ 35 ], _stage_id = boats_select { playerid } ;
			if ( _stage_id == 1 ) format ( td_string, sizeof td_string, "%d$", boats_price [ _stage_id - 1 ] ) ;
			else if ( _stage_id == 2 ) format ( td_string, sizeof td_string, "%d "donate_title_abb" (Бонус)", boats_price [ _stage_id - 1 ] ) ;
			else format ( td_string, sizeof td_string, "%d "donate_title_abb" (Основной)", boats_price [ _stage_id - 1 ] ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 256, "\
				{"#cGRDialog"}- {"#cWH"}Stage %d:\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}%s.\n\
				{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Stage %d{"#cGRDialog"}\"?", _stage_id, td_string, _stage_id ) ;
			
			show_dialog ( playerid, d_boats_stage, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", global_string, "Принять", "Закрыть" ) ;
		}
		else if ( _i2 == 3 && _i3 == 0 )
		{
			show_pantera_armour ( playerid ) ;
		}
		else if ( _i2 == 4 && _i3 == 0 )
		{
			show_pantera_engine ( playerid ) ;
		}
		else if ( _i2 == 5 && _i3 == 0 )
		{
			SetBoatsShow ( playerid, 3 ) ;
			SetBoatsColor ( playerid, p_t_info [ playerid ] [ tuning_vehicle ] ) ;
		}
	}
	else if ( _i == 6 )
	{
		if ( p_info [ playerid ] [ money ] < 1_000_000 )
		{
			send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
	
		new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
		ChangeVehicleColor ( _veh_id, _i2, _i2 ) ;
	   	veh_info [ _veh_id - 1 ] [ v_color ] [ 0 ] = _i2 ;
	   	veh_info [ _veh_id - 1 ] [ v_color ] [ 1 ] = _i2 ;
		save_tuning ( playerid ) ;
	}
	else if ( _i == 7 )
	{
		if ( player_rentcar [ playerid ] != INVALID_VEHICLE_ID )
		{
			send_check_cinfo ( playerid, "Вы уже арендуете транспорт (/stoprent)!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _b_cost = b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ;
		if ( p_info [ playerid ] [ money ] < _b_cost )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _vehicle_id ;
		if ( opened_boats { playerid } == 2 )
		{
			if ( _i2 > sizeof boats_model )
			{
				send_check_cinfo ( playerid, "Произошла ошибка, переоткройте меню!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			_vehicle_id = CreateVehicle ( boats_model [ _i2 ], boats_rent_position [ 0 ], boats_rent_position [ 1 ], boats_rent_position [ 2 ], boats_rent_position [ 3 ], _i3, _i3, 300 ) ;
		}
		else 
		{
			if ( _i2 > sizeof planes_model )
			{
				send_check_cinfo ( playerid, "Произошла ошибка, переоткройте меню!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			_vehicle_id = CreateVehicle ( planes_model [ _i2 ], planes_rent_position [ 0 ], planes_rent_position [ 1 ], planes_rent_position [ 2 ], planes_rent_position [ 3 ], _i3, _i3, 300 ) ;
		}
		
		veh_info [ _vehicle_id - 1 ] [ v_type ] = vehicle_type_rentcar_faggio ;
		veh_info [ _vehicle_id - 1 ] [ v_fuel ] = 60 ;
		veh_info [ _vehicle_id - 1 ] [ v_renter ] = playerid ;

		SetVehicleNumberPlate ( _vehicle_id, "Faggio" ) ;
		give_money ( playerid, -_b_cost ) ;
        insert_money_log ( playerid, INVALID_PLAYER_ID, _b_cost, "Аренда т/с (кастом)" ) ;
		give_bmoney ( GetPVarInt ( playerid, "p_biz_id" ), _b_cost, 0 ) ;
		player_rentcar [ playerid ] = _vehicle_id ;

		new engine, lights, alarm, doors, bonnet, boot, objective ;
		GetVehicleParamsEx ( _vehicle_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( _vehicle_id, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective ) ;

        toggle_engine ( playerid, _vehicle_id ) ;
		toggle_locked ( playerid, _vehicle_id, 1 ) ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно арендовали транспорт. Используйте {"#cGN"}/rlock (/rlk){"#cWH"}, чтобы закрыть его." ) ;
		
		SetBoatsHide ( playerid ) ;
		TogglePlayerControllable ( playerid, true ) ;
		used_boats [ playerid ] = false ;
		opened_boats { playerid } = 0 ;
		DeletePVar ( playerid, "p_biz_id" ) ;
		p_t_info [ playerid ] [ tuning_vehicle ] = INVALID_VEHICLE_ID ;
	}
	return 1 ;
}

stock boats_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	#pragma unused listitem
	switch ( dialogid )
	{
		case d_boats_stage:
		{
			if ( ! response ) return 1 ;
			
			new _v_id = p_t_info [ playerid ] [ tuning_vehicle ], _s_lvl = boats_select { playerid } ;
			if ( _v_id == INVALID_VEHICLE_ID ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Вы не выбрали т/с на которое будете устанавливать.", "Закрыть", "" ) ;
			if ( veh_info [ _v_id - 1 ] [ v_stage_speed ] == _s_lvl ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}У Вас уже установлен данный Stage.", "Закрыть", "" ) ;
			
			switch ( boats_select { playerid } )
			{
				case 1:
				{
					if ( p_info [ playerid ] [ money ] < 20_000_000 ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Недостаточно денежных средств.", "Закрыть", "" ) ;
					
					give_money ( playerid, -20_000_000 ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -20_000_000, "stage (lvl 1)" ) ;
				}
				case 2:
				{
					if ( ! get_player_donate ( playerid, 500, 1 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Недостаточно "donate_title_abb" на бонусном счёте.", "Закрыть", "" ) ;
					
					set_player_donate ( playerid, 500, 1 ) ;
				}
				case 3:
				{
					if ( ! get_player_donate ( playerid, 300, 2 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Недостаточно "donate_title_abb" на основном счёте.", "Закрыть", "" ) ;
        
					set_player_donate ( playerid, 300, 2 ) ;
					insert_donate_log ( playerid, INVALID_PLAYER_ID, 300, p_info [ playerid ] [ donate ], "(donate) stage (lvl 2)" ) ;
				}
			}
			
			veh_info [ _v_id - 1 ] [ v_stage_speed ] = _s_lvl ;
			veh_info [ _v_id - 1 ] [ v_stage_brake ] = _s_lvl ;
			save_car_boats ( _v_id ) ;
			
			new scm_string [ 54 + 4 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы успешно приобрели Stage %d.", _s_lvl ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			SetBoatsUpgrade ( playerid, _v_id ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock save_car_boats ( _v_id )
{
	if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_player )
	{
		new query_string [ 356 ] ;
		format ( query_string, sizeof ( query_string ),"UPDATE `users_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `v_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_family )
	{
		new query_string [ 356 ] ;
		format ( query_string, sizeof ( query_string ),"UPDATE `familys_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_rentcar )
	{
		new query_string [ 356 ] ;			
		format ( query_string, sizeof ( query_string ),"UPDATE `rent_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_house )
	{
		new query_string [ 356 ] ;
		format ( query_string, sizeof ( query_string ),"UPDATE `house_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	return 1 ;
}