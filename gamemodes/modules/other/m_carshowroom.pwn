#include <custom/carshowroom>

stock show_packet_carshowroom ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				scrHide ( playerid ) ;
				toggle_controlable ( playerid, true ) ;

				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
				
				if ( IsValidVehicle ( player_shop_vehicle [ playerid ] ) && veh_info [ player_shop_vehicle [ playerid ] - 1 ] [ v_type ] == vehicle_type_none ) DestroyVehicle ( player_shop_vehicle [ playerid ], 55 ) ;

				p_t_info [ playerid ] [ last_alt ] = GetTickCount ( ) ;

				SetPVarInt ( playerid, "tp_area_used", 1 ) ;

				exit_carbuy ( playerid ) ;
			}
		}
	}
	else if ( _param1 == 1 )
	{
		new ts_type = player_shop_select { playerid } - 1,
			ts_list = player_shop_list { playerid } ;

		new _car_price ;
		if ( ts_type == 7 )
		{
			if ( GetPlayerVehicleID ( playerid ) == 0 )  return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}Приобретите транспорт через /donate.","Закрыть", "" ) ;
			
			new _v_model = getReplacableVehicleModel ( GetPlayerVehicleID ( playerid ) ) ;
		    for ( new i = 0 ; i < sizeof donate_cars ; i ++ )
		    {
				if ( _v_model != donate_cars [ i ] [ 0 ] ) continue ;
					        
		        _car_price = donate_cars [ i ] [ 1 ] ;
		        break ;
		    }
				    
		    if ( ! get_player_donate ( playerid, _car_price, 2 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "donate_title" на основном счёте для покупки данного транспорта!","Закрыть", "" ) ;
		}
		else if ( ts_type == 8 )
		{
		    if ( GetPlayerVehicleID ( playerid ) == 0 )  return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}Приобретите транспорт через /donate.","Закрыть", "" ) ;
			new _v_model = getReplacableVehicleModel ( GetPlayerVehicleID ( playerid ) ) ;
		    for ( new i = 0 ; i < sizeof donate_cars_2 ; i ++ )
		    {
				if ( _v_model != donate_cars_2 [ i ] [ 0 ] ) continue ;

		        _car_price = donate_cars_2 [ i ] [ 1 ] ;
				break ;
		    }
					    
		    if ( ! get_player_donate ( playerid, _car_price, 2 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "donate_title" на основном счёте для покупки данного транспорта!","Закрыть", "" ) ;
		}
		else if ( ts_type == TYPE_FLYING )
		{
		    if ( GetPlayerVehicleID ( playerid ) == 0 )  return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}Приобретите транспорт через /donate.","Закрыть", "" ) ;
			new _v_model = getReplacableVehicleModel ( GetPlayerVehicleID ( playerid ) ) ;
		    for ( new i = 0 ; i < sizeof donate_cars_3 ; i ++ )
		    {
				if ( _v_model != donate_cars_3 [ i ] [ 0 ] ) continue ;

				_car_price = donate_cars_3 [ i ] [ 1 ] ;
		        break ;
		    }

		    if ( ! get_player_donate ( playerid, _car_price, 2 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "donate_title" на основном счёте для покупки данного транспорта!","Закрыть", "" ) ;
		}
		else
		{
		    new _v_model = GetVehicleModelEx ( -1, t_shop_models [ ts_list ] [ ts_type ] ) ;
			if ( vehicle_shop_count [ _v_model - 400 ] != -1 )
			{
				if ( vehicle_shop_count [ _v_model - 400 ] < 1 )
		     	{
					vehicle_shop_count [ _v_model - 400 ] = 0 ;

					new query_string [ 128 ] ;
					format ( query_string, sizeof query_string, "UPDATE `addcar_vehicles` SET `v_count` = '%d' WHERE `v_id` = '%d' LIMIT 1", vehicle_shop_count [ _v_model - 400 ], _v_model - 400 ) ;
					mysql_tquery ( sql_connection, query_string ) ;

					return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}Данной модели нет в автосалоне! Ожидайте пополнения.","Закрыть", "" ) ;
				}
			}

			if ( player_device { playerid } != 2 )
				_car_price = ( GetModelPrice ( t_shop_models [ ts_list ] [ ts_type ] ) * for_tax [ 2 ] ) + t_shop_colors [ GetPVarInt ( playerid, "t_shop_colors" ) ] [ shop_price ] ;

			if ( player_device { playerid } == 2 )
			    _car_price = ( GetModelPrice ( t_shop_models [ ts_list ] [ ts_type ] ) * for_tax [ 2 ] ) ;
						    
		    if ( p_info [ playerid ] [ money ] < _car_price ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка транспорта", "{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно денег для покупки данного транспорта!", "Закрыть", "" ) ;
		}

        if ( get_player_veh_count ( playerid ) >= p_info [ playerid ] [ max_veh ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Для начала нужно продать одно из имеющихся транспортных средств." ) ;

		new ts_vehicle = player_shop_vehicle [ playerid ] ;
		new _v_model = GetVehicleModelEx ( -1, t_shop_models [ ts_list ] [ ts_type ] ) ;

	    new ts_spawn_slot = random ( 5 ) ;
		new ts_id = GetPVarInt ( playerid, "tshop_id" ) - 1 ;
		if ( ts_id < 0 ) ts_id = 0 ;
		new	veh_id = CreateVehicle ( t_shop_models [ ts_list ] [ ts_type ],
									t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 0 ],
									t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 1 ],
									t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 2 ],
									t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 3 ],
									veh_info [ ts_vehicle - 1 ] [ v_color ] [ 0 ], veh_info [ ts_vehicle - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_PLAYER_VEHICLE ) ;

		veh_info [ veh_id - 1 ] [ v_price ] = _car_price ;

		new query_string [ 320 ] ;
		mysql_format ( sql_connection, query_string, sizeof query_string, "INSERT INTO `users_vehicles`(`v_model`,`v_owner`,`v_color_1`,`v_color_2`,`v_pos_x`,`v_pos_y`,`v_pos_z`,`v_pos_a`,`v_buydate`,`v_price`) VALUES ('%i','%i','%i','%i','%f','%f','%f','%f',NOW(),'%d')",
			t_shop_models [ ts_list ] [ ts_type ],
			p_info [ playerid ] [ id ],
			veh_info [ ts_vehicle - 1 ] [ v_color ] [ 0 ],
			veh_info [ ts_vehicle - 1 ] [ v_color ] [ 1 ],
			t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 0 ],
			t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 1 ],
			t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 2 ],
			t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 3 ],
			veh_info [ veh_id - 1 ] [ v_price ] ) ;
		mysql_tquery ( sql_connection, query_string, "create_vehicle_buycar", "dd", veh_id, playerid ) ;

		p_info [ playerid ] [ p_veh_count ] ++ ;

		model_info [ t_shop_models [ ts_list ] [ ts_type ] ] [ m_count ] += 1 ;
		set_model_count ( t_shop_models [ ts_list ] [ ts_type ], model_info [ t_shop_models [ ts_list ] [ ts_type ] ] [ m_count ] ) ;

		if ( ts_type == 7 || ts_type == 8 || ts_type == TYPE_FLYING )
		{
		    set_player_donate ( playerid, _car_price, 2 ) ;

			new car_string [ 64 ] ;
			format ( car_string, sizeof car_string, "(donate) покупка %s с салона", GetVehicleNameEx ( -1, t_shop_models [ ts_list ] [ ts_type ] ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, -_car_price, p_info [ playerid ] [ donate ], car_string ) ;
		}
		else
		{
			give_money ( playerid, -_car_price ) ;

			new car_string [ 64 ] ;
			format ( car_string, sizeof car_string, "покупка %s с салона", GetVehicleNameEx ( -1, t_shop_models [ ts_list ] [ ts_type ] ) ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_car_price, car_string ) ;

			new b = GetPVarInt ( playerid, "p_biz_id" ) - 1 ;
			if ( b > 0 ) give_bmoney ( b + 1, floatround ( ( _car_price * 0.05 ) / 100 ), 0 ) ;

			DestroyVehicle ( ts_vehicle, 29 ) ;

			veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_player ;
			veh_info [ veh_id - 1 ] [ v_vehicle ] = veh_id ;
			format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "Transit" ) ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 0 ] ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 1 ] ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 2 ] ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 3 ] ;
			veh_info [ veh_id - 1 ] [ v_fuel ] = 100.0 ;
			veh_info [ veh_id - 1 ] [ v_millage ] = 0.0 ;
			veh_info [ veh_id - 1 ] [ v_legal_millage ] = 0.0 ;
			veh_info [ veh_id - 1 ] [ v_fine ] = 3 ;
			veh_info [ veh_id - 1 ] [ v_key ] = 0 ;

			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Не забудьте припарковать Ваше транспортное средство (/vpark)." ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}У Вас есть 3 минуты, чтобы его отогнать или оно будет отправлено на штрафстоянку." ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Используйте {"#cGN"}/cars {"#cWH"}для управления автомобилем." ) ;
			veh_info [ veh_id - 1 ] [ v_fine_time ] = 180 ;

			veh_plate ( veh_id ) ;

			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ veh_id - 1 ] [ v_locked ] = true ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, engine, lights, alarm, true, bonnet, boot, objective ) ;

			veh_info [ veh_id - 1 ] [ v_owner ] = p_info [ playerid ] [ id ] ;

			SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
			Iter_Add(player_vehicles[ playerid ], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;

			SetPVarInt ( playerid, "carbuy_vehid", veh_id ) ;

			set_money_fraction ( 10, 3, _car_price, true ) ;

			if ( b > 0 && ( b_info [ b ] [ b_type ] == bizz_type_boatshop || b_info [ b ] [ b_type ] == bizz_type_flyshop ) ) { }
			else
		    {
				format ( query_string, sizeof query_string, "{"#cWH"}Хотите ли Вы приобрести GPS - трекер для того, чтобы установить его на автомобиль?\n\n{"#cGInfo"}* {"#cWH"}Стоимость GPS - трекер составить: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы хотите приобрести GPS - трекер?", price_gps_tracker ) ;
				show_dialog ( playerid, d_carbuy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка GPS-трекера", query_string, "Да", "Нет" ) ;
			}

			checking_quest_progress ( playerid, 4, 1, quest_line_medium ) ;
		}
	}
	else if ( _param1 == 3 )
	{
		new ts_vehicle = player_shop_vehicle [ playerid ],
			ts_type = player_shop_select { playerid } - 1,
			ts_list = player_shop_list { playerid } ;

		if ( IsValidVehicle ( ts_vehicle ) && veh_info [ ts_vehicle - 1 ] [ v_type ] == vehicle_type_none ) DestroyVehicle ( ts_vehicle, 54 ) ;
		else return 1 ;

		if ( ts_list == 0 )
		{
			for ( new j = 0 ; j < MAX_T_SHOP_MODELS ; j ++ )
			{
				if ( t_shop_models [ j + 1 ] [ ts_type ] == 0 )
				{
					ts_list = j ;
					break ;
				}
			}
			player_shop_list { playerid } = ts_list ;
		}
		else ts_list -= 1, player_shop_list { playerid } = ts_list ;

		p_t_info [ playerid ] [ last_alt ] = GetTickCount ( ) ;
		new veh_id = CreateVehicle ( t_shop_models [ ts_list ] [ ts_type ],
									 t_shop_pos [ ts_type ] [ 0 ],
									 t_shop_pos [ ts_type ] [ 1 ],
									 t_shop_pos [ ts_type ] [ 2 ],
									 t_shop_pos [ ts_type ] [ 3 ],
									 0, 0, -1 ) ;

        veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_none ;
		player_shop_vehicle [ playerid ] = veh_id ;

   		SetVehicleVirtualWorld ( veh_id, playerid + 2 ) ;
		if ( ts_type < 9 ) LinkVehicleToInterior ( veh_id, car_shop_interior ) ;
		else LinkVehicleToInterior ( veh_id, 0 ) ;

		new _str [ 48 ], _str2 [ 24 ], _str3 [ 24 ], _v_model = getReplacableVehicleModel ( veh_id ), _car_price ;
		if ( ts_type == 7 )
		{
		   	for ( new i = 0 ; i < sizeof donate_cars ; i ++ )
		    {
      			if ( _v_model != donate_cars [ i ] [ 0 ] ) continue ;

		     	_car_price = donate_cars [ i ] [ 1 ] ;
	       		break ;
			}
			
			format ( _str, sizeof ( _str ), "%s "donate_title_abb"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s "donate_title_abb"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		}
		else if ( ts_type == 8 )
		{
		   	for ( new i = 0 ; i < sizeof donate_cars_2 ; i ++ )
		    {
       			if ( _v_model != donate_cars_2 [ i ] [ 0 ] ) continue ;

			   	_car_price = donate_cars_2 [ i ] [ 1 ] ;
		   		break ;
			}
			
			format ( _str, sizeof ( _str ), "%s "donate_title_abb"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s "donate_title_abb"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		}
		else if ( ts_type == TYPE_FLYING )
		{
		   	for ( new i = 0 ; i < sizeof donate_cars_3 ; i ++ )
		    {
       			if ( _v_model != donate_cars_3 [ i ] [ 0 ] ) continue ;

		     	_car_price = donate_cars_3 [ i ] [ 1 ] ;
		   		break ;
			}

			format ( _str, sizeof ( _str ), "%s "donate_title_abb"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s "donate_title_abb"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		}
		else
		{
			_car_price = GetModelPrice ( t_shop_models [ ts_list ] [ ts_type ] ) * for_tax [ 2 ] ) ;
			format ( _str, sizeof ( _str ), "%s"valute_title"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s"valute_title"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
		}
		
		format ( _str2, sizeof _str2, "%d км/ч", max_veh_speed ( _v_model ) ) ;
		scrUpdate ( playerid, "Автосалон", "Класс: низкий", "", GetVehicleNameEx ( -1, t_shop_models [ ts_list ] [ ts_type ] ), _str, _str2, "100 литров" ) ;
	}
	else if ( _param1 == 4 )
	{
		new ts_vehicle = player_shop_vehicle [ playerid ],
			ts_type = player_shop_select { playerid } - 1,
			ts_list = player_shop_list { playerid } ;

		if ( IsValidVehicle ( ts_vehicle ) && veh_info [ ts_vehicle - 1 ] [ v_type ] == vehicle_type_none ) DestroyVehicle ( ts_vehicle, 53 ) ;
		else return 1 ;

		if ( t_shop_models [ ts_list + 1 ] [ ts_type ] == 0 ) ts_list = 0, player_shop_list { playerid } = ts_list ;
		else ts_list += 1, player_shop_list { playerid } = ts_list ;

		p_t_info [ playerid ] [ last_alt ] = GetTickCount ( ) ;

		new veh_id ;

		veh_id = CreateVehicle ( t_shop_models [ ts_list ] [ ts_type ],
									 t_shop_pos [ ts_type ] [ 0 ],
									 t_shop_pos [ ts_type ] [ 1 ],
									 t_shop_pos [ ts_type ] [ 2 ],
									 t_shop_pos [ ts_type ] [ 3 ],
									 0, 0, -1 ) ;

        veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_none ;
		player_shop_vehicle [ playerid ] = veh_id ;
			
   		SetVehicleVirtualWorld ( veh_id, playerid + 2 ) ;
		if ( ts_type < 9 ) LinkVehicleToInterior ( veh_id, car_shop_interior ) ;
		else LinkVehicleToInterior ( veh_id, 0 ) ;


		new _str [ 48 ], _str2 [ 24 ], _str3 [ 24 ], _v_model = getReplacableVehicleModel ( veh_id ), _car_price ;
		if ( ts_type == 7 )
		{
		   	for ( new i = 0 ; i < sizeof donate_cars ; i ++ )
		    {
      			if ( _v_model != donate_cars [ i ] [ 0 ] ) continue ;

		     	_car_price = donate_cars [ i ] [ 1 ] ;
	       		break ;
			}
			
			format ( _str, sizeof ( _str ), "%s "donate_title_abb"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s "donate_title_abb"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		}
		else if ( ts_type == 8 )
		{
		   	for ( new i = 0 ; i < sizeof donate_cars_2 ; i ++ )
		    {
       			if ( _v_model != donate_cars_2 [ i ] [ 0 ] ) continue ;

			   	_car_price = donate_cars_2 [ i ] [ 1 ] ;
		   		break ;
			}
			
			format ( _str, sizeof ( _str ), "%s "donate_title_abb"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s "donate_title_abb"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		}
		else if ( ts_type == TYPE_FLYING )
		{
		   	for ( new i = 0 ; i < sizeof donate_cars_3 ; i ++ )
		    {
       			if ( _v_model != donate_cars_3 [ i ] [ 0 ] ) continue ;

		     	_car_price = donate_cars_3 [ i ] [ 1 ] ;
		   		break ;
			}

			format ( _str, sizeof ( _str ), "%s "donate_title_abb"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s "donate_title_abb"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		}
		else
		{
			_car_price = GetModelPrice ( t_shop_models [ ts_list ] [ ts_type ] ) * for_tax [ 2 ] ) ;
			format ( _str, sizeof ( _str ), "%s"valute_title"", GetPlayerCashValueToSmile ( _car_price ) ) ;
			format ( _str3, sizeof _str3, "%s"valute_title"", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
		}
		
		format ( _str2, sizeof _str2, "%d км/ч", max_veh_speed ( _v_model ) ) ;
		scrUpdate ( playerid, "Автосалон", "Класс: низкий", "", GetVehicleNameEx ( -1, t_shop_models [ ts_list ] [ ts_type ] ), _str, _str2, "100 литров" ) ;
	}
	else if ( _param1 == 5 )
	{
		if ( _param2 == 1 )
		{
			new _v_id = player_shop_vehicle [ playerid ] ;
			veh_info [ _v_id - 1 ] [ v_color ] [ 0 ] = _param3 ;
			sc_OnVehicleStreamIn ( _v_id, playerid ) ;
		}
	}
	return 1 ;
}