#define nope_class 		1
#define middle_class 	2
#define luxury_class 	3
#define boat_class		4
#define plane_class		5

#define city_nope 		"г. Лос-Сантос"
#define city_middle		"г. Сан-Фиерро"
#define city_luxury		"г. Лас-Вентурас"

#define MAX_ADMIN_SALON 100
enum _admin_salon
{
	car_num_id,
	car_model,
	car_price,
	Float: car_position [ 4 ],
	car_count,
	car_class,
	car_slot
} ;
new admin_salon [ MAX_ADMIN_SALON ] [ _admin_salon ] ;
new car_market_count = 0 ;

stock create_car_debtor ( _slot_id, _car_count )
{
	if ( ! _car_count )
	{
		new scm_string [ 91 + 32 ] ;
		foreach(new i: logged_players)
		{
		    if ( p_info [ i ] [ radio ] != 27 ) continue ;
			format ( scm_string, sizeof ( scm_string ), "< Радио %s > Государственные изменения: Опечатанный транспорт доступен для приобретения.", f_info [ p_info [ i ] [ radio ] - 1 ] [ f_letter_name ] ) ;
			SendClientMessage ( i, 0x00ACF6FF, scm_string ) ;
		}
		car_salon_debtor ( admin_salon [ _slot_id ] [ car_model ], _slot_id ) ;
	}
	return 1 ;
}

stock car_salon_debtor ( veh_model, position_car )
{
	new veh_id = GetVehicleID ( ) ;

	veh_info [ veh_id - 1 ] [ v_owner ] = 0 ;
	veh_info [ veh_id - 1 ] [ v_model ] = veh_model ;
	
	veh_info [ veh_id - 1 ] [ v_sell_price ] = admin_salon [ position_car ] [ car_price ] ;
	
	veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = admin_salon [ position_car ] [ car_position ] [ 0 ] ;
	veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = admin_salon [ position_car ] [ car_position ] [ 1 ] ;
	veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = admin_salon [ position_car ] [ car_position ] [ 2 ] ;
	veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = admin_salon [ position_car ] [ car_position ] [ 3 ] ;
	
	veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = 1 ;
	veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = 1 ;

	GetVehiclePos ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ) ;
	GetVehicleZAngle ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ) ;

	veh_info[ veh_id - 1 ] [ v_type ] = vehicle_type_addcar ;

	format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "Transit" ) ;
    if ( veh_info [ veh_id - 1 ] [ v_owner ] == 1 ) veh_info [ veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], -1, 1 ) ;
	else veh_info [ veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], -1 ) ;
	SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;

    veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	admin_salon [ position_car ] [ car_slot ] = veh_id ;
		
	car_market_3d ( position_car, veh_id, true ) ;
	return 1 ;
}

stock cars_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `addcar_vehicles`", "addcar_vehicles_loading" ) ;
	return 1 ;
}

callback: addcar_vehicles_loading ( )
{
	new fields ;
	cache_get_data ( car_market_count, fields ) ;
	
	if ( car_market_count )
	{
		for ( new i = 0 ; i < car_market_count ; i ++ )
		{
			admin_salon [ i ] [ car_num_id ] = cache_get_field_content_int ( i, "v_id", sql_connection ) ;
			admin_salon [ i ] [ car_count ] = cache_get_field_content_int ( i, "v_count", sql_connection ) ;
			admin_salon [ i ] [ car_class ] = cache_get_field_content_int ( i, "v_class", sql_connection ) ;
			admin_salon [ i ] [ car_price ] = cache_get_field_content_int ( i, "v_price", sql_connection ) ;
			admin_salon [ i ] [ car_model ] = cache_get_field_content_int ( i, "v_model", sql_connection ) ;
			
			admin_salon [ i ] [ car_position ] [ 0 ] = cache_get_field_content_float ( i,"v_pos_x", sql_connection ) ;
			admin_salon [ i ] [ car_position ] [ 1 ] = cache_get_field_content_float ( i,"v_pos_y", sql_connection ) ;
			admin_salon [ i ] [ car_position ] [ 2 ] = cache_get_field_content_float ( i,"v_pos_z", sql_connection ) ;
			admin_salon [ i ] [ car_position ] [ 3 ] = cache_get_field_content_float ( i,"v_pos_a", sql_connection ) ;
			
			if ( admin_salon [ i ] [ car_count ] )
			{
				new veh_id = GetVehicleID ( ) ;
			
				veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_addcar ;
			
				veh_info [ veh_id - 1 ] [ v_sell_price ] = admin_salon [ i ] [ car_price ] ;
				veh_info [ veh_id - 1 ] [ v_model ] = admin_salon [ i ] [ car_model ] ;
			
				veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = admin_salon [ i ] [ car_position ] [ 0 ] ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = admin_salon [ i ] [ car_position ] [ 1 ] ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = admin_salon [ i ] [ car_position ] [ 2 ] ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = admin_salon [ i ] [ car_position ] [ 3 ] ;
			
				veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = 1 ;
				veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = 1 ;
				
				admin_salon [ i ] [ car_slot ] = veh_id ;

				format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "Transit" ) ;

				veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], -1 ) ;
				SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;

				car_market_3d ( i, veh_id, true ) ;
				
				new engine, lights, alarm, doors, bonnet, boot, objective ;
				veh_info [ veh_id - 1 ] [ v_locked ] = false ;
				GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
				SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;	
			}
			else admin_salon [ i ] [ car_slot ] = INVALID_VEHICLE_ID ;
		}
	}
	return 1 ;
}

stock car_market_3d ( salon_id, vehicle_id, bool: status )
{
	if ( status )
	{
		if ( ! IsValid3DTextLabel(veh_info [ vehicle_id - 1 ] [ v_sell_text ] ) )
		{
			new query_string [ 156 ] ;
			format ( query_string, sizeof ( query_string ),"** Транспорт продаётся **\n{"#cGR3D"}Модель: {"#cWH3D"}%s\n{"#cGR3D"}В наличии: {"#cWH3D"}%d шт.\n{"#cGR3D"}Цена: {"#cWH3D"}%d$\n{"#cGR3D"}Номер: {"#cWH3D"}%s",
			vehicle_name [ GetVehicleModel ( veh_info [ vehicle_id - 1 ] [ v_vehicle ] ) - 400 ],
			admin_salon [ salon_id ] [ car_count ],
			veh_info [ vehicle_id - 1 ] [ v_sell_price ],
			veh_info [ vehicle_id - 1 ] [ v_plate ] ) ;
		
			new Float: _car_x, Float: _car_y, Float: _car_z ;
			GetCoordBonnetVehicle ( veh_info [ vehicle_id - 1 ] [ v_vehicle ], _car_x, _car_y, _car_z, 3.5 ) ;
			veh_info [ vehicle_id - 1 ] [ v_sell_text ] = CreateDynamic3DTextLabel ( query_string, col_blue, _car_x, _car_y, _car_z + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID ) ;
		}
		
		new query_string [ 156 ] ;
		format ( query_string, sizeof ( query_string ),"** Транспорт продаётся **\n{"#cGR3D"}Модель: {"#cWH3D"}%s\n{"#cGR3D"}В наличии: {"#cWH3D"}%d шт.\n{"#cGR3D"}Цена: {"#cWH3D"}%d$\n{"#cGR3D"}Номер: {"#cWH3D"}%s",
		vehicle_name [ GetVehicleModel ( veh_info [ vehicle_id - 1 ] [ v_vehicle ] ) - 400 ],
		admin_salon [ salon_id ] [ car_count ],
		veh_info [ vehicle_id - 1 ] [ v_sell_price ],
		veh_info [ vehicle_id - 1 ] [ v_plate ] ) ;
		UpdateDynamic3DTextLabelText ( veh_info [ vehicle_id - 1 ] [ v_sell_text ], col_blue, query_string ) ;
	}
	else
	{
		if ( IsValidDynamic3DTextLabel ( veh_info [ vehicle_id - 1 ] [ v_sell_text ] ) )
		{
			DestroyDynamic3DTextLabel ( veh_info [ vehicle_id - 1 ] [ v_sell_text ] ) ;
			veh_info [ vehicle_id - 1 ] [ v_sell_text ] = Text3D:INVALID_3DTEXT_ID ;
		}
	}
	return 1 ;
}

stock cars_OnPlayerStateChange ( playerid, newstate, oldstate )
{
	#pragma unused newstate
	#pragma unused oldstate

	new vehicle_id = GetPlayerVehicleID ( playerid ) ;
	if ( veh_info [ vehicle_id - 1 ] [ v_type ] == vehicle_type_addcar )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "{"#cBL"}** Транспорт продаётся **\n\n\
										{"#cGRDialog"}Модель: {"#cWH"}%s\n\
										{"#cGRDialog"}Цена: {"#cWH"}%d$\n\n\
										{"#cGRDialog"}* Вы действительно хотите приобрести транспорт?", vehicle_name [ GetVehicleModel ( veh_info [ vehicle_id - 1 ] [ v_vehicle ] ) - 400 ], veh_info [ vehicle_id - 1 ] [ v_sell_price ] ) ;
		show_dialog ( playerid, d_a_carmarket_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Авторынок", global_string, "Купить", "Отмена" ) ;
	}
	return 1 ;
}

stock cars_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_a_carmarket_buy:
		{
			if ( ! response ) return RemovePlayerFromVehicle ( playerid ) ;
			
			if ( p_info [ playerid ] [ money ] < veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_sell_price ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно денег для покупки данного транспорта!" ), RemovePlayerFromVehicle ( playerid ) ;
			if ( get_player_veh_count ( playerid ) >= p_info [ playerid ] [ max_veh ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Для начала нужно продать одно из имеющихся транспортных средств." ), RemovePlayerFromVehicle ( playerid ) ;
			if ( GetPlayerState ( playerid ) != PLAYER_STATE_DRIVER ) return 1 ;

			SetPVarInt ( playerid, "carbuy_vehid", GetPlayerVehicleID ( playerid ) ) ;
			
			for ( new i = 0 ; i < car_market_count ; i ++ )
			{
				if ( admin_salon [ i ] [ car_slot ] != GetPlayerVehicleID ( playerid ) ) continue ;
				
				admin_salon [ i ] [ car_count ] -- ;
				
				new sql_string [ 76 + 4 + 9 ] ;
				format ( sql_string, sizeof sql_string, "UPDATE `addcar_vehicles` SET `v_count` = '%d' WHERE `v_id` = '%d' LIMIT 1", admin_salon [ i ] [ car_count ], admin_salon [ i ] [ car_num_id ] ) ;
				mysql_tquery ( sql_connection, sql_string, "", "");
				
				if ( ! admin_salon [ i ] [ car_count ] )
				{
					car_market_3d ( i, admin_salon [ i ] [ car_slot ], false ) ;
					DestroyVehicle ( admin_salon [ i ] [ car_slot ] ) ;
					admin_salon [ i ] [ car_slot ] = INVALID_VEHICLE_ID ;
				}
				
				new ts_spawn_slot = random ( 5 ) ;
				new ts_id = admin_salon [ i ] [ car_class ] - 1 ;
				SetPVarInt ( playerid, "tshop_id", ts_id ) ;
				if ( ts_id < 0 ) ts_id = 0 ;
				new	veh_id = CreateVehicle ( admin_salon [ i ] [ car_model ],
													t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 0 ],
													t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 1 ],
													t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 2 ],
													t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 3 ],
													1, 1, -1 ) ;


				veh_info [ veh_id - 1 ] [ v_model ] = GetVehicleModel ( veh_id ) ;

				new query_string [ 300 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "INSERT INTO `users_vehicles`(`v_model`,`v_owner`,`v_color_1`,`v_color_2`,`v_pos_x`,`v_pos_y`,`v_pos_z`,`v_pos_a`,`v_buydate`) VALUES ('%i','%i','%i','%i','%f','%f','%f','%f',NOW())",
				admin_salon [ i ] [ car_model ],
				p_info [ playerid ] [ id ],
				1, // color
				1, // color
				t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 0 ],
				t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 1 ],
				t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 2 ],
				t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 3 ]	) ;

				mysql_tquery ( sql_connection, query_string, "create_vehicle_callback", "dd", veh_id, playerid ) ;

				give_money ( playerid, -veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_sell_price ] ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_sell_price ], "покупка транспорта" ) ;

				veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_player ;
				veh_info [ veh_id - 1 ] [ v_vehicle ] = veh_id ;
				format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "Transit" ) ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 0 ] ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 1 ] ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 2 ] ;
				veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = t_shop_respawn [ ts_id ] [ ts_spawn_slot ] [ 3 ] ;
				veh_info [ veh_id - 1 ] [ v_fuel ] = 100.0 ;
				veh_info [ veh_id - 1 ] [ v_millage ] = 0.0 ;
				veh_info [ veh_id - 1 ] [ v_fine ] = 3 ;
				veh_info [ veh_id - 1 ] [ v_key ] = 0 ;

			    veh_plate ( veh_id ) ;

				new engine, lights, alarm, doors, bonnet, boot, objective ;
				veh_info [ veh_id - 1 ] [ v_locked ] = true ;
				GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
				SetVehicleParamsEx ( veh_id, engine, lights, alarm, true, bonnet, boot, objective ) ;

				veh_info [ veh_id - 1 ] [ v_owner ] = p_info [ playerid ] [ id ] ;

				SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
				Iter_Add(player_vehicles[ playerid ], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
				
				if ( ts_id + 1 == 1 ) SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели транспортное средство! Транспорт доставлен на парковку "city_nope"." ) ;
				else if ( ts_id + 1 == 2 ) SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели транспортное средство! Транспорт доставлен на парковку "city_middle"." ) ;
				else SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели транспортное средство! Транспорт доставлен на парковку "city_luxury"." ) ;
				break ;
			}
			
			RemovePlayerFromVehicle ( playerid ) ;
			
			new query_string [ 217 + 9 ] ;
			format ( query_string, sizeof query_string, "{"#cWH"}Хотите ли Вы приобрести GPS - трекер для того, чтобы установить его на автомобиль?\n\n{"#cGInfo"}* {"#cWH"}Стоимость GPS - трекер составить: {"#cGN"}%d$\n\n{"#cGRDialog"}* Вы хотите приобрести GPS - трекер?", price_gps_tracker ) ;
			show_dialog ( playerid, d_a_carmarket_gps, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка GPS-трекера", query_string, "Да", "Нет" ) ;
		}
		case d_carbuy:
		{
			if ( response )
			{
				if ( p_info [ playerid ] [ money ] >= price_gps_tracker )
				{
					new veh_id = GetPVarInt ( playerid, "carbuy_vehid" ) ;

					veh_info [ veh_id - 1 ] [ v_gps_tracker ] = 1 ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы приобрели GPS-трекер. (/gps > Найти транспорт)" ) ;

					new scm_string [ 98 ] ;
					format ( scm_string, 98, "UPDATE `users_vehicles` SET `v_gps_tracker` = '%d' WHERE `v_id` = '%d' LIMIT 1",
					veh_info [ veh_id - 1 ] [ v_gps_tracker ], veh_info [ veh_id - 1 ] [ v_id ] ) ;
					mysql_tquery ( sql_connection, scm_string ) ;
					
					give_money ( playerid, -price_gps_tracker ) ;
           		 	insert_money_log ( playerid, INVALID_PLAYER_ID, -price_gps_tracker, "GPS-трекер при покупки тс" ) ;
				}
				else
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств для покупки GPS-трекер." ) ;
					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы сможете купить GPS-трекер в любом магазине 24/7 и установить на транспорт." ) ;
				}
			}
			DeletePVar ( playerid, "carbuy_vehid" ) ;

			if ( GetPVarInt ( playerid, "tshop_id" ) - 1 < 3 )
			{
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Необходимо припарковаться в разрешенном месте, чтобы транспорт не был эвакуирован. Используйте {"#cGN"}/vpark{"#cWH"}." ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация:",
				"{"#cBL"}Информация о транспорте:\n\n{"#cBL"}- {"#cWH"}Каждое транспортное средство облагается налогами. Оплатить их Вы сможете в банке или в банкомате.\nВ случае неуплаты налога Вы можете потерять часть своей собственности.\n\n{"#cBL"}- {"#cWH"}По штату курсируют экипажи полиции с эвакуаторами.\nВ случае парковки в неположенных местах, Ваше транспортное средство будет эвакуировано на штрафстоянку.\nПрипарковать транспортное средство Вы можете при помощи команды /vpark.\nНастоятельно рекомендуем сделать это сразу после покупки транспорта.\n\n{"#cBL"}- {"#cWH"}Каждый игрок может иметь 2 транспортных средства.\n\n{"#cGRDialog"}* Вы ознакомились с информацией и желаете продолжить?", "Закрыть", "" ) ;
			}
			else if ( GetPVarInt ( playerid, "tshop_id" ) - 1 == 3 )SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели водное транспортное средство." ) ;
			else if ( GetPVarInt ( playerid, "tshop_id" ) - 1 == 4 )SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели воздушное транспортное средство. Оно доставлено к ангару." ) ;
			return 1 ;
		}
		case d_admin_salon:
		{
			if ( ! response ) return callcmd::apanel ( playerid ) ;
			
			if ( car_market_count == listitem )
			{
				if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны быть в транспорте!" ) ;
				
				global_string [ 0 ] = EOS ;
				new veh_id = GetPlayerVehicleID ( playerid ) ;
				format ( global_string, sizeof ( global_string ), "INSERT INTO `addcar_vehicles` (`v_pos_x`,`v_pos_y`,`v_pos_z`,`v_pos_a`) VALUES ('%.2f','%.2f','%.2f','%.2f')",
				veh_info [ veh_id - 1 ] [ v_now_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_now_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_now_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_now_pos ] [ 3 ] ) ;
				mysql_tquery ( sql_connection, global_string ) ;
				return 1 ;
			}

			set_player_use_listitem ( playerid, listitem ) ;
			show_dialog ( playerid, d_admin_salon_set, DIALOG_STYLE_LIST, "{"#cBHD"}Настройки автосалона", "{"#cBL"}1. {"#cWH"}Установить модель\n{"#cBL"}2. {"#cWH"}Установить цену\n{"#cBL"}3. {"#cWH"}Установить количество транспорта\n{"#cBL"}4. {"#cWH"}Изменить позицию\n{"#cBL"}5. {"#cWH"}Настройки класса", "Выбрать", "Назад" ) ;
		}
		case d_admin_salon_set:
		{
			if ( ! response ) return show_admin_salon ( playerid ) ;
			switch ( listitem )
			{
				case 0: 
				{
					global_string [ 0 ] = EOS ;
					new listitem_id = get_player_use_listitem ( playerid ) ;
					format ( global_string, 200, "{"#cWH"}Введите ID модели транспорта:\n\n{"#cGRDialog"}* Текущая модель: {"#cWH"}%s (ID: %d)\n\n{"#cGRDialog"}* Доступные модели: 400 - 611", vehicle_name [ admin_salon [ listitem_id ] [ car_model ] - 400 ], admin_salon [ listitem_id ] [ car_model ] ) ;
					show_dialog ( playerid, d_admin_salon_set_id, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
				}
				case 1: 
				{
					global_string [ 0 ] = EOS ;
					new listitem_id = get_player_use_listitem ( playerid ) ;
					format ( global_string, 200, "{"#cWH"}Введите цену за модель транспорта:\n\n{"#cGRDialog"}* Текущая стоимость: {"#cWH"}%d$\n\n{"#cGRDialog"}* Цена может быть от 1$ до 100.000.000$", admin_salon [ listitem_id ] [ car_price ] ) ;
					show_dialog ( playerid, d_admin_salon_set_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
				}
				case 2: 
				{
					global_string [ 0 ] = EOS ;
					new listitem_id = get_player_use_listitem ( playerid ) ;
					format ( global_string, 200, "{"#cWH"}Введите количество транспорта:\n\n{"#cGRDialog"}* Текущее количество: {"#cWH"}%d\n\n{"#cGRDialog"}* Минимальное количество 1, максимальное 10000", admin_salon [ listitem_id ] [ car_count ] ) ;
					show_dialog ( playerid, d_admin_salon_set_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
				}
				case 3:
				{
					if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны быть в транспорте!" ) ;
				
					new listitem_id = get_player_use_listitem ( playerid ) ;
					
					GetVehiclePos ( GetPlayerVehicleID ( playerid ), admin_salon [ listitem_id ] [ car_position ] [ 0 ], admin_salon [ listitem_id ] [ car_position ] [ 1 ], admin_salon [ listitem_id ] [ car_position ] [ 2 ] ) ;
					GetVehicleZAngle ( GetPlayerVehicleID ( playerid ), admin_salon [ listitem_id ] [ car_position ] [ 3 ] ) ;
				
					new sql_string [ 200 ] ;
					format ( sql_string, sizeof sql_string, "UPDATE `addcar_vehicles` SET `v_pos_x` = '%.2f',\
																						`v_pos_y` = '%.2f',\
																						`v_pos_z` = '%.2f',\
																						`v_pos_a` = '%.2f' WHERE `v_id` = '%d' LIMIT 1", admin_salon [ listitem_id ] [ car_position ] [ 0 ], admin_salon [ listitem_id ] [ car_position ] [ 1 ], admin_salon [ listitem_id ] [ car_position ] [ 2 ], admin_salon [ listitem_id ] [ car_position ] [ 3 ], admin_salon [ listitem_id ] [ car_num_id ] ) ;
					mysql_tquery ( sql_connection, sql_string, "", "");
				
					if ( admin_salon [ listitem_id ] [ car_slot ] == INVALID_VEHICLE_ID ) { }
					else
					{
						car_market_3d ( listitem_id, admin_salon [ listitem_id ] [ car_slot ], false ) ;
						DestroyVehicle ( admin_salon [ listitem_id ] [ car_slot ] ) ;
						car_salon_debtor ( admin_salon [ listitem_id ] [ car_model ], listitem_id ) ;
					}
				}
				case 4:
				{
					global_string [ 0 ] = EOS ;
					new line_string [ 64 ] ;
					new listitem_id = get_player_use_listitem ( playerid ) ;
					
					static const _classes_cars [ ] [ ] = 
					{
						"Эконом", 
						"Средний", 
						"Бизнес", 
						"Водный", 
						"Воздушный"
					} ;
					
					for ( new i = 0 ; i < sizeof _classes_cars ; i ++ )
					{
						format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s %s\n", i + 1, _classes_cars [ i ], ( admin_salon [ listitem_id ] [ car_class ] == i + 1 ) ? ( "{"#cGRDialog"}* Текущий класс" ) : ( "" ) ) ;
						strcat ( global_string, line_string ) ;
					}
					show_dialog ( playerid, d_admin_salon_set_class, DIALOG_STYLE_LIST, "{"#cBHD"}Настройки класса", global_string, "Выбрать", "Назад" ) ;
				}
			}
		}
		case d_admin_salon_set_id:
		{
			if ( ! response ) return show_admin_salon ( playerid ) ;
			
			new _value = strval ( inputtext ), listitem_id = get_player_use_listitem ( playerid ) ;
			if ( _value < 400 || _value > 611 )
			{
				global_string [ 0 ] = EOS ;
				new listitem_id = get_player_use_listitem ( playerid ) ;
				format ( global_string, 200, "{"#cWH"}Введите ID модели транспорта:\n\n{"#cGRDialog"}* Текущая модель: {"#cWH"}%s (ID: %d)\n\n{"#cGRDialog"}* Доступные модели: 400 - 611", vehicle_name [ admin_salon [ listitem_id ] [ car_model ] - 400 ], admin_salon [ listitem_id ] [ car_model ] ) ;
				show_dialog ( playerid, d_admin_salon_set_id, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
				return 1 ;
			}
			admin_salon [ listitem_id ] [ car_model ] = _value ;
			
			new sql_string [ 76 + 4 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `addcar_vehicles` SET `v_model` = '%d' WHERE `v_id` = '%d' LIMIT 1", admin_salon [ listitem_id ] [ car_model ], admin_salon [ listitem_id ] [ car_num_id ] ) ;
			mysql_tquery ( sql_connection, sql_string, "", "");
			
			if ( admin_salon [ listitem_id ] [ car_slot ] )
			{
				car_market_3d ( listitem_id, admin_salon [ listitem_id ] [ car_slot ], false ) ;
				DestroyVehicle ( admin_salon [ listitem_id ] [ car_slot ] ) ;
				car_salon_debtor ( admin_salon [ listitem_id ] [ car_model ], listitem_id ) ;
			}
			
			show_admin_salon ( playerid ) ;
		}
		case d_admin_salon_set_price:
		{
			if ( ! response ) return show_admin_salon ( playerid ) ;
			
			new _value = strval ( inputtext ), listitem_id = get_player_use_listitem ( playerid ) ;
			if ( _value < 1 || _value > 100000000 )
			{
				global_string [ 0 ] = EOS ;
				new listitem_id = get_player_use_listitem ( playerid ) ;
				format ( global_string, 200, "{"#cWH"}Введите цену за модель транспорта:\n\n{"#cGRDialog"}* Текущая стоимость: {"#cWH"}%d$\n\n{"#cGRDialog"}* Цена может быть от 1$ до 100.000.000$", admin_salon [ listitem_id ] [ car_price ] ) ;
				show_dialog ( playerid, d_admin_salon_set_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
				return 1 ;
			}
			admin_salon [ listitem_id ] [ car_price ] = _value ;
			
			new sql_string [ 76 + 9 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `addcar_vehicles` SET `v_price` = '%d' WHERE `v_id` = '%d' LIMIT 1", admin_salon [ listitem_id ] [ car_price ], admin_salon [ listitem_id ] [ car_num_id ] ) ;
			mysql_tquery ( sql_connection, sql_string, "", "");
			
			if ( admin_salon [ listitem_id ] [ car_slot ] )
			{
				car_market_3d ( listitem_id, admin_salon [ listitem_id ] [ car_slot ], false ) ;
				DestroyVehicle ( admin_salon [ listitem_id ] [ car_slot ] ) ;
				car_salon_debtor ( admin_salon [ listitem_id ] [ car_model ], listitem_id ) ;
			}
			
			show_admin_salon ( playerid ) ;
		}
		case d_admin_salon_set_count:
		{
			if ( ! response ) return show_admin_salon ( playerid ) ;
			
			new _value = strval ( inputtext ), listitem_id = get_player_use_listitem ( playerid ) ;
			if ( _value < 1 || _value > 10000 )
			{
				global_string [ 0 ] = EOS ;
				new listitem_id = get_player_use_listitem ( playerid ) ;
				format ( global_string, 200, "{"#cWH"}Введите количество транспорта:\n\n{"#cGRDialog"}* Текущее количество: {"#cWH"}%d\n\n{"#cGRDialog"}* Минимальное количество 1, максимальное 10000", admin_salon [ listitem_id ] [ car_count ] ) ;
				show_dialog ( playerid, d_admin_salon_set_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
				return 1 ;
			}
			
			if ( admin_salon [ listitem_id ] [ car_slot ] == INVALID_VEHICLE_ID )
			{
				car_market_3d ( listitem_id, admin_salon [ listitem_id ] [ car_slot ], false ) ;
				DestroyVehicle ( admin_salon [ listitem_id ] [ car_slot ] ) ;
				car_salon_debtor ( admin_salon [ listitem_id ] [ car_model ], listitem_id ) ;
			}
			
			admin_salon [ listitem_id ] [ car_count ] = _value ;
			
			new sql_string [ 76 + 4 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `addcar_vehicles` SET `v_count` = '%d' WHERE `v_id` = '%d' LIMIT 1", admin_salon [ listitem_id ] [ car_count ], admin_salon [ listitem_id ] [ car_num_id ] ) ;
			mysql_tquery ( sql_connection, sql_string, "", "");
			
			show_admin_salon ( playerid ) ;
		}
		case d_admin_salon_set_class:
		{
			if ( ! response ) return show_admin_salon ( playerid ) ;
			
			new listitem_id = get_player_use_listitem ( playerid ) ;
			admin_salon [ listitem_id ] [ car_class ] = listitem ;
			
			new sql_string [ 76 + 4 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `addcar_vehicles` SET `v_class` = '%d' WHERE `v_id` = '%d' LIMIT 1", admin_salon [ listitem_id ] [ car_class ], admin_salon [ listitem_id ] [ car_num_id ] ) ;
			mysql_tquery ( sql_connection, sql_string, "", "");
			
			show_admin_salon ( playerid ) ;
		}
	}
	return 1 ;
}

CMD:test_salon ( playerid ) { return show_admin_salon ( playerid ) ; }
stock show_admin_salon ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 128 ] ;
	for ( new i = 0 ; i < car_market_count ; i ++ )
	{
		if ( ! admin_salon [ i ] [ car_model ] ) continue ;
		
		new class_string [ 16 ] ;
		switch ( admin_salon [ i ] [ car_class ] )
		{
			case 1: class_string = "Эконом" ;
			case 2: class_string = "Средний" ;
			case 3: class_string = "Бизнес" ;
			case 4: class_string = "Водный" ;
			case 5: class_string = "Воздушный" ;
		}
		
		format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s, %s (ID: %d) - {"#cGN"}%d$\n", i + 1, vehicle_name [ admin_salon [ i ] [ car_model ] - 400 ], class_string, admin_salon [ i ] [ car_model ], admin_salon [ i ] [ car_price ] ) ;
		strcat ( global_string, line_string ) ;
	}
	strcat ( global_string, "{"#cGRDialog"}Добавить транспорт" ) ;
	show_dialog ( playerid, d_admin_salon, DIALOG_STYLE_LIST, "{"#cBHD"}Настройки автосалона", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock GetCoordBonnetVehicle ( vehicleid, &Float: x, &Float: y, &Float: z, Float: distance )
{
    new
        Float: angle,
        Float: dis ;

    dis = dis / 2 + distance ;
    GetVehiclePos ( vehicleid, x, y, z ) ;
    GetVehicleZAngle ( vehicleid, angle ) ;
    x -= ( dis * floatsin ( - angle + 180, degrees ) ) ;
    y -= ( dis * floatcos ( - angle + 180, degrees ) ) ;
    return 1 ;
}