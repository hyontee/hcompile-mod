#define pick_type_pc_use	100

new pickup_car_id [ 38 ] ;
new Text3D: pick_car_label [ 38 ] ;
new pick_car_cooldown [ 38 ] [ 2 ] ;

enum _pickup_car
{
	Float: pc_pos [ 3 ],
	Float: pc_pos_car [ 4 ],
	pc_type,
	pc_owner
} ;

new pickup_car_info [ 38 ] [ _pickup_car ] =
{
	{ { -324.8362, 727.2735, 12.1064 }, { -328.2001, 724.3779, 12.0923, 92.2969 }, vehicle_type_server, 1 }, // Мэрия ЛС
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 2 }, // Мэрия СФ
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 3 }, // Мэрия ЛВ
	{ { 197.3919, 1354.4410, 11.9218 }, { 203.853, 1362.242, 11.551, 353.910 }, vehicle_type_server, 4 }, // ЛСПД
	{ { 2543.0051, -2433.9406, 22.0055 }, { 2552.241, -2438.084, 21.636, 270.181 }, vehicle_type_server, 5 }, // СФПД
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 6 }, // ЛВПД
	{ { 2404.8820, -1843.5942, 21.9622 }, { 2398.2680, -1846.1667, 21.9286, 89.4637 }, vehicle_type_server, 7 }, // ФБР
	{ { 1679.0712, 1710.6936, 15.9531 }, { 1685.8442, 1700.0894, 16.5330, 0.8550 }, vehicle_type_server, 8 }, // Сухопутные Войска
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 9 }, // Военно-Морской Флот
	{ { 1919.6520, 2228.3386, 15.7109 }, { 1926.5985, 2223.9912, 15.3254, 271.8531 }, vehicle_type_server, 10 }, // Инструкторы
	{ { 1912.7725, -2233.8627, 11.0872 }, { 1919.3492, -2234.2590, 11.5081, 179.8128 }, vehicle_type_server, 11 }, // Правительство
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 12 }, // Резерв
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 13 }, // Резерв
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 14 }, // Резерв
	{ { -282.5746, 579.4829, 12.1071 }, { -277.7846, 585.4732, 12.2465, 353.8812 }, vehicle_type_server, 15 }, // Больница
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 16 }, // Резерв
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 17 }, // Резерв
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 18 }, // Grove
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 19 }, // Ballas
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 20 }, // Vagos
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 21 }, // Rifa
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 22 }, // Aztecas
	{ { -891.4642, 1234.0348, 10.5234 }, { -895.5974, 1230.9315, 10.5979, 184.5341 }, vehicle_type_server, 23 }, // LCN
	{ { 2589.9465, 1789.3706, 2.3159 }, { 2592.2502, 1785.1555, 2.4445, 272.3106 }, vehicle_type_server, 24 }, // RM
	{ { -2244.1940, 240.0034, 24.5395 }, { -2238.9914, 240.3928, 24.6157, 351.5275 }, vehicle_type_server, 25 }, // YAKUZA
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 26 }, // Резерв
	{ { 2135.8461, -1937.9197, 20.2421 }, { 2141.0729, -1933.9545, 18.8848, 70.9479 }, vehicle_type_server, 27 }, // СМИ
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_server, 28 }, // Резерв
	
	{ { 219.2581, 417.0141, 11.6346 }, { 227.0639, 405.6400, 11.2554, 275.4140 }, vehicle_type_job, 1 }, // Автобусник
	//{ { 1822.457, 2509.445, 15.664 }, { 1814.142, 2511.797, 15.571, 207.285 }, vehicle_type_job, 2 }, // Таксист
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_job, 2 }, // Таксист
	{ { 2345.0419, -2627.8171, 21.8114 }, { 2353.6284, -2627.4592, 21.8654, 0.9894 }, vehicle_type_job, 3 }, // Механик
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_job, 4 }, // Дальнобойщик
	{ { 1798.6024, 2734.0966, 13.8925 }, { 1797.9555, 2727.2441, 13.6907, 226.4124 }, vehicle_type_job, 5 }, // Доставщик
	{ { 1729.3286, 2664.8525, 13.8925 }, { 1737.4205, 2664.9377, 13.6893, 226.5786 }, vehicle_type_job, 6 }, // Доставщик топлива
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_job, 7 }, // Пилот
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_job, 8 }, // Инкассатор
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_job, 9 }, // Мореплаватель
	{ { 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0, 0.0 }, vehicle_type_job, 10 } // Вертолетчик
} ;

stock pc_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_pc_use:
		{
			if ( player_rentcar [ playerid ] != INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже арендуете транспорт, сначала откажитесь от старого {"#cRD"}/stoprent" ) ;
			
			new i = pick_info [ pickupid ] [ pick_item ] ;
			
			if ( pick_car_cooldown [ i ] [ 1 ] > gettime ( ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Транспорт можно брать раз в {"#cRInfo"}60 секунд{"#cGRInfo"}." ) ;
				return 1 ;
			}
			
			if ( pick_car_cooldown [ i ] [ 0 ] > gettime ( ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вызывать меню с транспортом можно раз в {"#cRInfo"}10 секунд{"#cGRInfo"}." ) ;
				return 1 ;
			}
			
			if ( pickup_car_info [ i ] [ pc_type ] == vehicle_type_server )
			{
				if ( pickup_car_info [ i ] [ pc_owner ] == 11 )
				{
					if ( p_info [ playerid ] [ member ] != pickup_car_info [ i ] [ pc_owner ] && exam_start [ playerid ] == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в данной организации!" ) ;
				}
				else if ( p_info [ playerid ] [ member ] != pickup_car_info [ i ] [ pc_owner ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в данной организации!" ) ;
			}
			else if ( pickup_car_info [ i ] [ pc_type ] == vehicle_type_job )
			{
				if ( p_info [ playerid ] [ job ] != pickup_car_info [ i ] [ pc_owner ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете на данной работе!" ) ;
			}
			
			pick_car_cooldown [ i ] [ 0 ] = gettime ( ) + 10 ;
				
			new sql_string [ 160 ] ;
			format ( sql_string, sizeof sql_string, "SELECT `sv_id`, `sv_model`, `sv_rank`, `sv_subleader` FROM `server_vehicles` WHERE `sv_type` = '%d' AND `sv_owner` = '%d' AND `sv_use` = '0'", pickup_car_info [ i ] [ pc_type ], pickup_car_info [ i ] [ pc_owner ] ) ;
			mysql_tquery ( sql_connection, sql_string, "vehicles_loading_info", "d", playerid ) ;
				
			set_player_use_listitem ( playerid, i ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: vehicles_loading_info ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		global_string [ 0 ] = EOS ;
		new line_string [ 128 ] ;
		if ( pickup_car_info [ get_player_use_listitem ( playerid ) ] [ pc_type ] == vehicle_type_server )
		{
			new _unit_name [ 32 ], _sv_____model, _sv_____id, _sv_____rank, _sv_____subleader ;
			strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Должность:\t{"#cBL"}Подразделение:\n" ) ;
			for ( new i = 0 ; i < rows ; i ++ )
			{
				_sv_____model = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
				_sv_____id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
				_sv_____rank = cache_get_field_content_int ( i, "sv_rank", sql_connection ) ;
				_sv_____subleader = cache_get_field_content_int ( i, "sv_subleader", sql_connection ) ;
				
				set_player_listitem_values ( playerid, i, _sv_____id ) ;
				
				if ( _sv_____subleader > 0 ) format ( _unit_name, sizeof _unit_name, "{"#cLY"}%s", unit_info [ _sv_____subleader - 1 ] [ un_name ] ) ;
				else format ( _unit_name, sizeof _unit_name, "{"#cRD"}Нет" ) ;
				
				format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\t{33AAFF}%s {"#cGRDialog"}- %d ранг{"#cWH"}\t%s\n", i + 1, GetVehicleNameEx ( INVALID_VEHICLE_ID, _sv_____model ), f_rank [ p_info [ playerid ] [ member ] - 1 ] [ _sv_____rank - 1 ], _sv_____rank, _unit_name ) ;
				strcat ( global_string, line_string ) ;
			}
			show_dialog ( playerid, d_use_car, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Транспорт", global_string, "Выбрать", "Закрыть" ) ;
		}
		else
		{
			new _sv_use [ 15 ] = { 0, ... }, _sv_model [ 15 ] = { 0, ... }, bool: _sv_status = false, _free_sv_id = 0 ;
			for ( new i = 0 ; i < rows ; i ++ )
			{
				new _sv_____model = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
				
				for ( new q = 0 ; q < 15 ; q ++ )
				{
					if ( _sv_use [ q ] == 14 ) continue ;
					if ( _sv_model [ q ] == 0 ) _free_sv_id = q ;
					
					if ( _sv_model [ q ] == _sv_____model )
					{
						_sv_use [ q ] ++ ;
						_sv_status = true ;
						break ;
					}
				}
				
				if ( _sv_status == false )
				{
					_sv_model [ _free_sv_id ] = _sv_____model ;
					_sv_use [ _free_sv_id ] ++ ;
				}
				else _sv_status = false ;
			}
			
			_free_sv_id = 0 ;
			for ( new i = 0 ; i < 15 ; i ++ )
			{
				if ( ! _sv_model [ i ] ) continue ;
				
				set_player_listitem_values ( playerid, _free_sv_id, _sv_model [ i ] ) ;
				_free_sv_id ++ ;
				
				format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s {"#cGRDialog"}({"#cWH"}%d шт.{"#cGRDialog"})\n", _free_sv_id, GetVehicleNameEx ( INVALID_VEHICLE_ID, _sv_model [ i ] ), _sv_use [ i ] ) ;
				strcat ( global_string, line_string ) ;
			}
			show_dialog ( playerid, d_use_car, DIALOG_STYLE_LIST, "{"#cBHD"}Транспорт", global_string, "Выбрать", "Закрыть" ) ;
		}
	}
	return 1 ;
}

stock pc_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_use_car:
		{
			if ( ! response ) return clear_player_listitem_values ( playerid ) ;

			new _c_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( GetPVarInt ( playerid, "_b_toggled" ) == 1 )
			{
				DeletePVar ( playerid, "_b_toggled" ) ;
				new sql_string [ 63 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT * FROM `rent_vehicles` WHERE `sv_id` = '%d' LIMIT 1", _c_id ) ;
				mysql_tquery ( sql_connection, sql_string, "vehicles_loading_rent", "d", playerid ) ;
				return 1 ;
			}
			else if ( GetPVarInt ( playerid, "_b_toggled" ) == 2 )
			{
				DeletePVar ( playerid, "_b_toggled" ) ;
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "SELECT fv.*, lp.* \
									FROM familys_vehicles fv \
									LEFT JOIN licence_plate lp \
									ON lp.licence_plate_use_own_car_id = fv.v_owner_fam \
									WHERE `sv_id` = '%d' LIMIT 1", _c_id ) ;
				mysql_tquery ( sql_connection, global_string, "vehicles_loading_family", "d", playerid ) ;
				return 1 ;
			}
			
			if ( pickup_car_info [ get_player_use_listitem ( playerid ) ] [ pc_type ] == vehicle_type_server )
			{
				new sql_string [ 63 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT * FROM `server_vehicles` WHERE `sv_id` = '%d' LIMIT 1", _c_id ) ;
				mysql_tquery ( sql_connection, sql_string, "vehicles_loading_other", "d", playerid ) ;
			}
			else
			{
				new sql_string [ 144 ] ;
				format ( sql_string, sizeof sql_string, "SELECT * FROM `server_vehicles` WHERE `sv_type` = '%d' AND `sv_owner` = '%d' AND `sv_use` = '0' AND `sv_model` = '%d' LIMIT 1", pickup_car_info [ get_player_use_listitem ( playerid ) ] [ pc_type ], pickup_car_info [ get_player_use_listitem ( playerid ) ] [ pc_owner ], _c_id ) ;
				mysql_tquery ( sql_connection, sql_string, "vehicles_loading_other", "d", playerid ) ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

callback: vehicles_loading_other ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if( rows )
	{
		new _veh_id = GetVehicleID ( ),
			_pos_id = get_player_use_listitem ( playerid ) ;
			
		new sv_use = cache_get_field_content_int ( 0, "sv_use", sql_connection ) ;
		if ( sv_use == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный транспорт уже загружен!" ) ;
			
		veh_info [ _veh_id - 1 ] [ v_type ] = cache_get_field_content_int ( 0, "sv_type", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_rank ] = cache_get_field_content_int ( 0, "sv_rank", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_subleader ] = cache_get_field_content_int ( 0, "sv_subleader", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_model ] = cache_get_field_content_int ( 0, "sv_model", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_owner ] = cache_get_field_content_int ( 0, "sv_owner", sql_connection ) ;
		if ( veh_info [ _veh_id - 1 ] [ v_type ] == vehicle_type_server )
		{
			if ( p_info [ playerid ] [ rank ] < veh_info [ _veh_id - 1 ] [ v_rank ] )
			{
				static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Транспорт доступен с ранга %s (%d)." ;
				new scm_string [ sizeof _str + 30 + 3 ] ;
				format ( scm_string, sizeof scm_string, _str, f_rank [ p_info [ playerid ] [ member ] - 1 ] [ veh_info [ _veh_id - 1 ] [ v_rank ] - 1 ], veh_info [ _veh_id - 1 ] [ v_rank ] ) ;
				SendClientMessage ( playerid, col_gray, scm_string ) ;
				return 1 ;
			}
			
			if ( veh_info [ _veh_id - 1 ] [ v_subleader ] )
			{
			    if ( veh_info [ _veh_id - 1 ] [ v_subleader ] != p_info [ playerid ] [ subleader ] )
			    {
					new row_count = 0 ;
					for ( new i = 0 ; i < unit_count ; i++ )
					{
						if ( row_count >= 5 ) break ;
						if ( p_info [ playerid ] [ member ] != unit_info [ i ] [ u_fraction ] ) continue ;
						if ( veh_info [ _veh_id - 1 ] [ v_subleader ] != unit_info [ i ] [ un_id ] ) continue ;

						row_count ++ ;
					}
					
					if ( ! row_count )
					{
						SendClientMessage ( playerid, col_gray, "{"#cRInfo"}* {"#cGRInfo"}Данное подразделение не активно. Обновите подразделение у транспорта." ) ;
						veh_info [ _veh_id - 1 ] [ v_subleader ] = 0 ;
					}
					else if ( p_info [ playerid ] [ leader ] < 1 )
					{
						new _t_string [ 128 ] ;
						format ( _t_string, sizeof _t_string, "{"#cRInfo"}* {"#cGRInfo"}Транспорт доступен для подразделения {"#cRD"}%s{"#cGRInfo"}.", unit_info [ veh_info [ _veh_id - 1 ] [ v_subleader ] - 1 ] [ un_name ] ) ;
						SendClientMessage ( playerid, col_gray, _t_string ) ;
						return 1 ;
					}
				}
			}
			
			if ( veh_info [ _veh_id - 1 ] [ v_owner ] == 10 )
			{
				if ( exam_start [ playerid ] != true && veh_info [ _veh_id - 1 ] [ v_model ] != vehicle_exam_drive &&
					p_info [ playerid ] [ member ] != 10 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный вид транспорта не предназначен для экзамена." ) ;
				
				exam_vehicle [ playerid ] = _veh_id ;
			}
			
			new scm_string [ 128 ] ;
			new fraction_id = p_info [ playerid ] [ member ] ;
			if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( scm_string, sizeof scm_string, "[F] %s %s взял(а) с парковки %s.", f_rank [ fraction_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], GetVehicleNameEx ( INVALID_VEHICLE_ID, veh_info [ _veh_id - 1 ] [ v_model ] ) ) ;
			else format ( scm_string, sizeof scm_string, "[R] %s %s взял(а) с парковки %s.", f_rank [ fraction_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], GetVehicleNameEx ( INVALID_VEHICLE_ID, veh_info [ _veh_id - 1 ] [ v_model ] ) ) ;
			fraction_message ( fraction_id, col_lblue, scm_string ) ;
		}
		
		veh_info [ _veh_id - 1 ] [ v_id ] = cache_get_field_content_int ( 0, "sv_id", sql_connection ) ;
		
		veh_info [ _veh_id - 1 ] [ v_color ] [ 0 ] = cache_get_field_content_int ( 0, "sv_color_1", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_color ] [ 1 ] = cache_get_field_content_int ( 0, "sv_color_2", sql_connection ) ;

		cache_get_field_content ( 0, "sv_plate", veh_info [ _veh_id - 1 ] [ v_plate ], sql_connection, 12 ) ;
		veh_info [ _veh_id - 1 ] [ v_fuel ] = cache_get_field_content_float ( 0,"sv_fuel", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_millage ] = cache_get_field_content_float ( 0,"sv_millage", sql_connection ) ;

		veh_info [ _veh_id - 1 ] [ v_pos ] [ 0 ] = cache_get_field_content_float ( 0,"sv_pos_x", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_pos ] [ 1 ] = cache_get_field_content_float ( 0,"sv_pos_y", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_pos ] [ 2 ] = cache_get_field_content_float ( 0,"sv_pos_z", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_pos ] [ 3 ] = cache_get_field_content_float ( 0,"sv_pos_a", sql_connection ) ;
			
		veh_info [ _veh_id - 1 ] [ v_vw ] = cache_get_field_content_int ( 0, "v_vw", sql_connection ) ;
		veh_info [ _veh_id - 1 ] [ v_int ] = cache_get_field_content_int ( 0, "v_int", sql_connection ) ;
		
		veh_info [ _veh_id - 1 ] [ v_trunk_open ] = false ;
		veh_info [ _veh_id - 1 ] [ v_trunk_load ] = false ;
		
		veh_info [ _veh_id - 1 ] [ v_fuel ] = 35.0 ;
		if ( veh_info [ _veh_id - 1 ] [ v_owner ] == job_forklift ) veh_info [ _veh_id - 1 ] [ v_fuel ] = 100.0 ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_owner ] >= 4 && veh_info [ _veh_id - 1 ] [ v_owner ] <= 9 && veh_info [ _veh_id - 1 ] [ v_type ] == vehicle_type_server )
		{
			veh_info [ _veh_id - 1 ] [ v_plate_type ] = 6 ;
			
			if ( veh_info [ _veh_id - 1 ] [ v_id ] < 10 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "A 000%d", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			else if ( veh_info [ _veh_id - 1 ] [ v_id ] > 9 && veh_info [ _veh_id - 1 ] [ v_id ] < 100 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "A 00%d", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			else if ( veh_info [ _veh_id - 1 ] [ v_id ] > 99 && veh_info [ _veh_id - 1 ] [ v_id ] < 1000 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "A 0%d", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			
			format ( veh_info [ _veh_id - 1 ] [ v_region ], 12, "77" ) ;
			
			veh_info [ _veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( veh_info [ _veh_id - 1 ] [ v_model ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 0 ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 1 ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 2 ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 3 ], veh_info [ _veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ _veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_SERVER_VEHICLE, 1 ) ;
			
			player_vehicle [ playerid ] = _veh_id ;

			new sscanf_delimit [ 100 ] ;
			format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `server_vehicles` SET `sv_use` = '1' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sscanf_delimit ) ;
			
			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ _veh_id - 1 ] [ v_locked ] = false ;
			GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( _veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно арендовали транспорт. Используйте {"#cGN"}/rlock (/rlk){"#cWH"}, чтобы закрыть его." ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вам доступен багажник транспорта. Для отмены аренды транспорта используйте {"#cGN"}/stoprent{"#cWH"}." ) ;
				
			player_vehicle [ playerid ] = _veh_id ;
			player_rentcar [ playerid ] = _veh_id ;
			veh_info [ _veh_id - 1 ] [ v_renter ] = playerid ;
			Iter_Add ( fraction_vehicles[veh_info [ _veh_id - 1 ] [ v_owner ]], veh_info [ _veh_id - 1 ] [ v_vehicle ] ) ;
			
			pick_car_cooldown [ _pos_id ] [ 1 ] = gettime ( ) + 60 ;
			
			SetVehicleNumberPlate ( veh_info [ _veh_id - 1 ] [ v_vehicle ], veh_info [ _veh_id - 1 ] [ v_plate ] ) ;

			if ( veh_info [ _veh_id - 1 ] [ v_type ] == vehicle_type_server ) 
				Iter_Add ( fraction_vehicles[veh_info [ _veh_id - 1 ] [ v_owner ]], veh_info [ _veh_id - 1 ] [ v_vehicle ] ) ;
			return 1 ;
		}
		else
		{
			veh_info [ _veh_id - 1 ] [ v_plate_type ] = 2 ;
				
			if ( veh_info [ _veh_id - 1 ] [ v_id ] < 10 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "P000%dPP", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			else if ( veh_info [ _veh_id - 1 ] [ v_id ] > 9 && veh_info [ _veh_id - 1 ] [ v_id ] < 100 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "P00%dPP", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			else if ( veh_info [ _veh_id - 1 ] [ v_id ] > 99 && veh_info [ _veh_id - 1 ] [ v_id ] < 1000 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "P0%dPP", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
				
			format ( veh_info [ _veh_id - 1 ] [ v_region ], 12, "77" ) ;

			veh_info [ _veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( veh_info [ _veh_id - 1 ] [ v_model ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 0 ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 1 ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 2 ], pickup_car_info [ _pos_id ] [ pc_pos_car ] [ 3 ], veh_info [ _veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ _veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_SERVER_VEHICLE ) ;
		}
		
		
		
		new sscanf_delimit [ 100 ] ;
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `server_vehicles` SET `sv_use` = '1' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ _veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( _veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
		
		
		
		
		SetVehicleNumberPlate ( veh_info [ _veh_id - 1 ] [ v_vehicle ], veh_info [ _veh_id - 1 ] [ v_plate ] ) ;

		if ( veh_info [ _veh_id - 1 ] [ v_type ] == vehicle_type_server ) // если организация
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно арендовали транспорт. Используйте {"#cGN"}/rlock (/rlk){"#cWH"}, чтобы закрыть его." ) ;
           	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вам доступен багажник транспорта. Для отмены аренды транспорта используйте {"#cGN"}/stoprent{"#cWH"}." ) ;
			
			player_vehicle [ playerid ] = _veh_id ;
			player_rentcar [ playerid ] = _veh_id ;
			veh_info [ _veh_id - 1 ] [ v_renter ] = playerid ;
			Iter_Add ( fraction_vehicles[veh_info [ _veh_id - 1 ] [ v_owner ]], veh_info [ _veh_id - 1 ] [ v_vehicle ] ) ;
		}
		else
		{
			player_vehicle [ playerid ] = _veh_id ;
			
			show_rent_car ( playerid, 250 ) ;
			veh_info [ _veh_id - 1 ] [ v_rent_price ] = 0 ;
		}
		
		pick_car_cooldown [ _pos_id ] [ 1 ] = gettime ( ) + 60 ;

		/*if ( veh_info [ _veh_id - 1 ] [ v_model ] == 578 )
		{
			new veh_object = CreateDynamicObject(3287,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 19962, "samproadsigns", "materialtext1", 0);
			SetDynamicObjectMaterial(veh_object, 1, 19962, "samproadsigns", "materialtext1", 0);
			SetDynamicObjectMaterial(veh_object, 2, 19962, "samproadsigns", "materialtext1", 0);
			SetDynamicObjectMaterial(veh_object, 3, 14576, "mafiacasinovault01", "ab_vaultmetal", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, 0.120, 2.090, 0.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(1428,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -5.289, 1.228, 10.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(9131,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, 0.130, 2.280, 0.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(9131,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -2.771, 2.280, 0.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(1428,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -2.233, 3.166, -75.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(1428,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -0.142, 3.158, -75.000, 0.000, 0.050);
			veh_object = CreateDynamicObject(19866,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -1.371, -0.350, 0.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(19866,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -1.391, -0.360, 0.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(19363,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -3.830, 1.459, 0.000, 0.000, 90.000);
			veh_object = CreateDynamicObject(19363,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 0, 5704, "melrose07_lawn", "ws_conc_step1", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, 1.158, 1.459, 0.000, 0.000, -90.000);
			veh_object = CreateDynamicObject(2983,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 10, -1, "none", "none", -9868951);
			SetDynamicObjectMaterial(veh_object, 10, -1, "none", "none", -9868951);
			SetDynamicObjectMaterial(veh_object, 10, -1, "none", "none", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, 0.170, 3.070, 270.000, 0.000, 0.000);
			veh_object = CreateDynamicObject(2983,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
			SetDynamicObjectMaterial(veh_object, 11, -1, "none", "none", -9868951);
			SetDynamicObjectMaterial(veh_object, 11, -1, "none", "none", -9868951);
			SetDynamicObjectMaterial(veh_object, 11, -1, "none", "none", -9868951);
			AttachDynamicObjectToVehicle(veh_object, veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000, -2.730, 3.070, 270.000, 0.000, 0.000);
		}*/
		if ( veh_info [ _veh_id - 1 ] [ v_model ] == 403 )
		{
			new _vehicle_id = CreateVehicle(584, spawn_trailer_delivery [ 0 ], spawn_trailer_delivery [ 1 ], spawn_trailer_delivery [ 2 ], spawn_trailer_delivery [ 3 ], 0, 0, SPAWN_TIME_SERVER_VEHICLE ) ;
			player_trailer [ playerid ] = _vehicle_id ;
		}
		/*else if ( veh_info [ _veh_id - 1 ] [ v_model ] == 405 )
		{
		    veh_info [ _veh_id - 1 ] [ v_object ] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
			AttachDynamicObjectToVehicle(veh_info [ _veh_id - 1 ] [ v_object ], veh_info [ _veh_id - 1 ] [ v_vehicle ], 0.000000, -0.400000, 0.854999, 0.000000, 0.000000, 0.0);
		}
		else if ( veh_info [ _veh_id - 1 ] [ v_model ] == 560 )
		{
		    veh_info [ _veh_id - 1 ] [ v_object ] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
			AttachDynamicObjectToVehicle(veh_info [ _veh_id - 1 ] [ v_object ], veh_info [ _veh_id - 1 ] [ v_vehicle ], -0.014999, -0.140000, 0.919999, -1.005000, 0.000000, 0.0);
		}*/
	}
   	return 1 ;
}

stock __SetVehicleToRespawn ( vehicleid, _respawn_type = 0 )
{
	new _v_type = veh_info [ vehicleid - 1 ] [ v_type ] ;
	if ( _v_type == vehicle_type_family )
	{
		new sscanf_delimit [ 75 + 9 ] ;
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `sv_use` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ vehicleid - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;
	
		Iter_Remove(family_vehicles[veh_info [ vehicleid - 1 ] [ v_owner ]], veh_info [ vehicleid - 1 ] [ v_vehicle ] ) ;
		
		if ( _respawn_type == 0 )
			DestroyVehicle ( vehicleid, 2 ) ;
	}
	else if ( _v_type == vehicle_type_rentcar )
	{
		new sscanf_delimit [ 75 + 9 ] ;
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `rent_vehicles` SET `sv_use` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ vehicleid - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;
	
		Iter_Remove(business_vehicles[veh_info [ vehicleid - 1 ] [ v_owner ]], veh_info [ vehicleid - 1 ] [ v_vehicle ] ) ;
		
		if ( _respawn_type == 0 )
			DestroyVehicle ( vehicleid, 2 ) ;
	}
	else if ( _v_type == vehicle_type_server || _v_type == vehicle_type_job )
	{		
		new sscanf_delimit [ 75 + 9 ] ;
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `server_vehicles` SET `sv_use` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ vehicleid - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;
	
		if ( veh_info [ vehicleid - 1 ] [ v_type ] == vehicle_type_server ) 
			Iter_Remove ( fraction_vehicles[veh_info [ vehicleid - 1 ] [ v_owner ]], veh_info [ vehicleid - 1 ] [ v_vehicle ] ) ;

		if ( _respawn_type == 0 )
			DestroyVehicle ( vehicleid, 2 ) ;
	}
	return 1 ;
}

stock pc_OnGameModeInit ( )
{
	static const job_status [ 10 ] [ 22 ] =
	{
		"Водитель автобуса",
		"Таксист",
		"Механик",
		"Дальнобойщик",
		"Развозчик продуктов",
		"Развозчик топлива",
		"Пилот",
		"Инкассатор",
		"Мореплаватель",
		"Вертолетчик"
	} ;
	
	new text_label [ 110 ] ;
	for ( new i = 0 ; i < sizeof pickup_car_info ; i ++ )
	{
		pickup_car_id [ i ] = CreateDynamicPickup ( pickupPropertyGarage, 23, pickup_car_info [ i ] [ pc_pos ] [ 0 ], pickup_car_info [ i ] [ pc_pos ] [ 1 ], pickup_car_info [ i ] [ pc_pos ] [ 2 ], 0, 0, -1 ) ;
		pick_info [ pickup_car_id [ i ] ] [ pick_type ] = pick_type_pc_use ;
		pick_info [ pickup_car_id [ i ] ] [ pick_item ] = i ;

		if ( i < 28 )
		{
			format ( text_label, sizeof text_label, "** Парковка **\n{%s}%s\n\n{"#cGR3D"}Используйте {"#cWH"}/stoprent {"#cGR3D"}для сдачи т/с", f_info [ i ] [ f_chat_color ], f_info [ i ] [ f_name ] ) ;
			pick_car_label [ i ] = CreateDynamic3DTextLabel ( text_label, col_header_3d, pickup_car_info [ i ] [ pc_pos ] [ 0 ], pickup_car_info [ i ] [ pc_pos ] [ 1 ], pickup_car_info [ i ] [ pc_pos ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0 ) ; 
		}
		else
		{
			format ( text_label, sizeof text_label, "** Парковка **\n{"#cWH"}%s\n\n{"#cGR3D"}Используйте {"#cWH"}/stoprent {"#cGR3D"}для сдачи т/с", job_status [ pickup_car_info [ i ] [ pc_owner ] - 1 ] ) ;
			pick_car_label [ i ] = CreateDynamic3DTextLabel ( text_label, col_header_3d, pickup_car_info [ i ] [ pc_pos ] [ 0 ], pickup_car_info [ i ] [ pc_pos ] [ 1 ], pickup_car_info [ i ] [ pc_pos ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0 ) ; 
		}
	}
	return 1 ;
}

/*

	Familys Cars

*/

callback: family_vehicles_loading_info ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		SetPVarInt ( playerid, "_b_toggled", 2 ) ;
		
		global_string [ 0 ] = EOS ;
		new line_string [ 100 ], family_id = p_info [ playerid ] [ family ] ;
		
		strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Должность:\n" ) ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
			new _sv_____model = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
			new _sv_____id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
			new _sv_____rank = cache_get_field_content_int ( i, "sv_rank", sql_connection ) ;
			if ( _sv_____rank < 1 ) _sv_____rank = 1 ;
				
			set_player_listitem_values ( playerid, i, _sv_____id ) ;

			format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\t{33AAFF}%s {"#cGRDialog"}- %d ранг\n", _sv_____id, GetVehicleNameEx ( INVALID_VEHICLE_ID, _sv_____model ), family_rank [ family_id - 1 ] [ _sv_____rank - 1 ], _sv_____rank ) ;
			strcat ( global_string, line_string ) ;
		}
		show_dialog ( playerid, d_use_car, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Транспорт", global_string, "Выбрать", "Закрыть" ) ;
	}
	else SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В семье не осталось транспорта для аренды." ) ;
	return 1 ;
}

callback: vehicles_loading_family ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if( rows )
	{
	    new veh_id = GetVehicleID ( ),
			_family_id = p_info [ playerid ] [ family ] ;
		if ( _family_id < 1 ) return 1 ;
		
		new sv_use = cache_get_field_content_int ( 0, "sv_use", sql_connection ) ;
		if ( sv_use == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный транспорт уже загружен!" ) ;
		
		veh_info [ veh_id - 1 ] [ v_rank ] = cache_get_field_content_int ( 0, "sv_rank", sql_connection ) ;
		
		if ( veh_info [ veh_id - 1 ] [ v_rank ] < 1 ) veh_info [ veh_id - 1 ] [ v_rank ] = 1 ;
		if ( p_info [ playerid ] [ family_rang ] < veh_info [ veh_id - 1 ] [ v_rank ] )
		{
			static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Транспорт доступен с ранга %s (%d)." ;
			new scm_string [ sizeof _str + 30 + 3 ] ;
			format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ veh_info [ veh_id - 1 ] [ v_rank ] - 1 ], veh_info [ veh_id - 1 ] [ v_rank ] ) ;
			SendClientMessage ( playerid, col_gray, scm_string ) ;
			return 1 ;
		}
		
		veh_info [ veh_id - 1 ] [ v_id ] = cache_get_field_content_int ( 0, "sv_id", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_model ] = cache_get_field_content_int ( 0, "sv_model", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_type ] = cache_get_field_content_int ( 0, "sv_type", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_owner ] = cache_get_field_content_int ( 0, "sv_owner", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_owner_fam ] = cache_get_field_content_int ( 0, "v_owner_fam", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = 0 ; //cache_get_field_content_int ( 0, "sv_color_1", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = 0 ; //cache_get_field_content_int ( 0, "sv_color_2", sql_connection ) ;

		new sscanf_delimit [ 126 ] ;
		cache_get_field_content ( 0, "licence_plate_country", sscanf_delimit, sql_connection, 8 ) ;
		cache_get_field_content ( 0, "licence_plate_number", veh_info [ veh_id - 1 ] [ v_plate ], sql_connection, 12 ) ;
		cache_get_field_content ( 0, "licence_plate_region", veh_info [ veh_id - 1 ] [ v_region ], sql_connection, 12 ) ;

		if ( GetString ( sscanf_delimit, "RU POLICE" ) ) veh_info [ veh_id - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_RU_POLICE ;
		else if ( GetString ( sscanf_delimit, "RU" ) ) veh_info [ veh_id - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_RUS ;
		else if ( GetString ( sscanf_delimit, "UA" ) ) veh_info [ veh_id - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_UA ;
		else if ( GetString ( sscanf_delimit, "BY" ) ) veh_info [ veh_id - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_BY ;
		else if ( GetString ( sscanf_delimit, "KZ" ) ) veh_info [ veh_id - 1 ] [ v_plate_type ] = NUMBERPLATE_TYPE_KZ ;
		else veh_info [ veh_id - 1 ] [ v_plate_type ] = 1 ;
			
		veh_info [ veh_id - 1 ] [ v_fuel ] = cache_get_field_content_float ( 0, "sv_fuel", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_millage ] = cache_get_field_content_float ( 0, "sv_millage", sql_connection ) ;

		veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = cache_get_field_content_float ( 0, "sv_pos_x", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = cache_get_field_content_float ( 0, "sv_pos_y", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = cache_get_field_content_float ( 0, "sv_pos_z", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = cache_get_field_content_float ( 0, "sv_pos_a", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_vw ] = cache_get_field_content_int ( 0, "v_vw", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_int ] = cache_get_field_content_int ( 0, "v_int", sql_connection ) ;

		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		veh_info [ veh_id - 1 ] [ v_fuel ] = 35.0 ;




		new _house_id = family_info [ _family_id - 1 ] [ fam_house ] ;
		
		if ( h_info [ _house_id - 1 ] [ h_podezd ] != -1 )
		{
			veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], position_vehicle_parking [ 0 ], position_vehicle_parking [ 1 ], position_vehicle_parking [ 2 ], position_vehicle_parking [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_FAMILY_VEHICLE ) ;
			
			LinkVehicleToInterior ( veh_id, GetPlayerInterior ( playerid ) ) ;
			SetVehicleVirtualWorld ( veh_id, GetPlayerVirtualWorld ( playerid ) ) ;
		}
		else
		{
			veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 0 ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 1 ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 2 ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_FAMILY_VEHICLE ) ;
		
			if ( veh_info [ veh_id - 1 ] [ v_int ] != 0 )LinkVehicleToInterior ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_int ] ) ;
			if ( veh_info [ veh_id - 1 ] [ v_vw ] != 0 )SetVehicleVirtualWorld ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_vw ] ) ;
		}
		SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
		
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
		player_rentcar [ playerid ] = veh_id ;
		PutPlayerInVehicle ( playerid, veh_id, 0 ) ;
		SetPlayerArmedWeapon ( playerid, 0 ) ;
		
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `sv_use` = '1' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;
		
	
	
	
		
			

		veh_plate ( veh_id ) ;

		veh_info [ veh_id - 1 ] [ v_trunk_open ] = false ;
		veh_info [ veh_id - 1 ] [ v_trunk_load ] = false ;
			
		veh_info [ veh_id - 1 ] [ v_price ] = cache_get_field_content_int ( 0, "sv_price", sql_connection ) ;

		format ( sscanf_delimit, sizeof sscanf_delimit, "SELECT * FROM `familys_vehicles_handling` WHERE `v_handling_own_car_sql_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit, "SetHandlingToOwnableCar", "is", veh_id, "familys_vehicles_handling" ) ;
			
		format ( sscanf_delimit, sizeof sscanf_delimit, "SELECT * FROM `familys_vehicles_tuning` WHERE `v_tuning_sql_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit, "SetTuningToOwnableCar", "is", veh_id, "familys_vehicles_tuning" ) ;

		format ( sscanf_delimit, sizeof sscanf_delimit, "SELECT * FROM `familys_vehicles_component` WHERE `v_component_sql_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit, "SetComponentToOwnableCar", "is", veh_id, "familys_vehicles_component" ) ;

		Iter_Add(family_vehicles[veh_info [ veh_id - 1 ] [ v_owner ]], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
	}
	return 1 ;
}
/*

	Businesses Cars

*/

callback: rent_vehicles_loading_info ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		SetPVarInt ( playerid, "_b_toggled", 1 ) ;
		
		global_string [ 0 ] = EOS ;
		new line_string [ 100 ] ;
		
		strcat ( global_string, "{"#cBL"}Название:\t{"#cBL"}Стоимость аренды:\n" ) ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
			new _sv_____model = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
			new _sv_____id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
			new _sv_____rent_price = cache_get_field_content_int ( i, "sv_rent_price", sql_connection ) ;
				
			set_player_listitem_values ( playerid, i, _sv_____id ) ;

			format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\t{"#cGN"}%d"valute_title_"\n", i + 1, GetVehicleNameEx ( INVALID_VEHICLE_ID, _sv_____model ), _sv_____rent_price ) ;
			strcat ( global_string, line_string ) ;
		}
		show_dialog ( playerid, d_use_car, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Транспорт", global_string, "Выбрать", "Закрыть" ) ;
	}
	else SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В бизнесе не осталось транспорта для аренды." ) ;
	return 1 ;
}

callback: vehicles_loading_rent ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if( rows )
	{
	    new veh_id = GetVehicleID ( ) ;
		
		new sv_use = cache_get_field_content_int ( 0, "sv_use", sql_connection ) ;
		if ( sv_use == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный транспорт уже загружен!" ) ;
		
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		if ( _b_id < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка! Арендуйте транспорт повторно." ) ;

		veh_info [ veh_id - 1 ] [ v_id ] = cache_get_field_content_int ( 0, "sv_id", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_model ] = cache_get_field_content_int ( 0, "sv_model", sql_connection ) ;
		
		veh_info [ veh_id - 1 ] [ v_type ] = cache_get_field_content_int ( 0, "sv_type", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_owner ] = cache_get_field_content_int ( 0, "sv_owner", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = 0 ; //cache_get_field_content_int ( 0, "sv_color_1", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = 0 ; //cache_get_field_content_int ( 0, "sv_color_2", sql_connection ) ;

		new sscanf_delimit [ 126 ] ;
		veh_info [ veh_id - 1 ] [ v_plate_type ] = 1 ;

		veh_info [ veh_id - 1 ] [ v_fuel ] = cache_get_field_content_float ( 0,"sv_fuel", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_millage ] = cache_get_field_content_float ( 0,"sv_millage", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_rank ] = cache_get_field_content_int ( 0, "sv_rank", sql_connection ) ;

		veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = cache_get_field_content_float ( 0,"sv_pos_x", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = cache_get_field_content_float ( 0,"sv_pos_y", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = cache_get_field_content_float ( 0,"sv_pos_z", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = cache_get_field_content_float ( 0,"sv_pos_a", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		veh_info [ veh_id - 1 ] [ v_fuel ] = 35.0 ;

		player_vehicle [ playerid ] = veh_id ;
		if ( b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 0 ] != 0.0 && b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 1 ] != 0.0 && b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 2 ] != 0.0 )
		{
			veh_info [ veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( veh_info [ veh_id - 1 ] [ v_model ], b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 0 ], b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 1 ], b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 2 ], b_info [ _b_id - 1 ] [ b_vehicle_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_SERVER_VEHICLE ) ;
		}
		else
		{
			veh_info [ veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_SERVER_VEHICLE ) ;
		}
		SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
		show_rent_car ( playerid, veh_info [ veh_id - 1 ] [ v_rent_price ] ) ;
		
		b_info [ _b_id - 1 ] [ b_car_cooldown ] [ 1 ] = gettime ( ) + 60 ;
		DeletePVar  ( playerid, "p_biz_id" ) ;
		
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `rent_vehicles` SET `sv_use` = '1' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;

		new bool: _car_marker = false, _biz_id ;
		for ( new i = 0 ; i < b_count ; i ++ )
		{
		    if ( b_info [ i ] [ b_car_marker ] != veh_info [ veh_id - 1 ] [ v_owner ] ) continue ;
			    
		    _car_marker = true ;
		    _biz_id = i ;
		    break ;
		}
		if ( _car_marker == true )
		{
		    veh_info [ veh_id - 1 ] [ v_owner ] = b_info [ _biz_id ] [ b_id ] ;
			Iter_Add(business_vehicles[veh_info [ veh_id - 1 ] [ v_owner ]], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
		}
		else
		    printf ( "[SERVER] В rent_vehicles маркер авто не совпадает с маркером бизнеса. (Маркер авто: %d)", veh_info [ veh_id - 1 ] [ v_owner ] ) ;

		veh_plate ( veh_id ) ;

		veh_info [ veh_id - 1 ] [ v_trunk_open ] = false ;
		veh_info [ veh_id - 1 ] [ v_trunk_load ] = false ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
	}
   	return 1 ;
}