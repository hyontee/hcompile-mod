static thief_progress [ MAX_PLAYERS char ] ;
static bool: thief_processed [ MAX_PLAYERS ] ;
static thief_timer [ MAX_PLAYERS ] ;
static thief_area [ MAX_PLAYERS ] ;

static model_thief_skill [ ] = { 412, 419, 439, 466, 467, 474, 475, 516, 517, 518, 534, 535, 536, 542, 549 } ;
static Float: model_thief_pos [ 15 ] [ 4 ] =
{
	{ 1816.5273, 2337.3203, 15.2556, 211.5303 },
	{ 1935.8164, 2093.0854, 15.5944, 178.6973 },
	{ 1843.5578, 2197.3662, 15.5528, 270.0008 },
	{ 1875.0231, 1182.8693, 29.9087, 177.2787 },
	{ 744.3986, -1356.1956, 40.6203, 340.8362 },
	{ 484.6010, -1277.4533, 40.6272, 71.7336 },
	{ -516.2273, -1641.3845, 40.8256, 328.8913 },
	{ -2236.4089, -193.9129, 24.3012, 258.5437 },
	{ -2233.8300, 233.9322, 24.4382, 171.4747 },
	{ 2332.9370, -2625.5112, 21.6979, 0.8825 },
	{ 2558.0957, -2065.6472, 21.8525, 89.6697 },
	{ 1771.2490, -2339.7944, 10.7208, 181.4551 },
	{ 238.3366, 416.1848, 11.6497, 68.6105 },
	{ -322.4146, 839.3015, 12.9461, 0.0851 },
	{ 287.2539, 1761.3538, 11.8993, 352.2554 }
} ;
static bool: thief_place_toggled [ sizeof model_thief_pos ] = { false, ... } ;
new model_thief_count = sizeof model_thief_pos ;

stock clear_player_thief ( playerid )
{
	thief_timer [ playerid ] = -1 ;
	thief_progress { playerid } = 0 ;
	thief_processed [ playerid ] = false ;
	return 1 ;
}

stock show_thief_info ( playerid )
{
	new _skill_level, _skill_name [ 16 ], _status_active [ 64 ] ;
	if ( p_info [ playerid ] [ jackcar_skill ] < 51 )
	{
		_skill_level = 50 - p_info [ playerid ] [ jackcar_skill ] ;
		format ( _skill_name, sizeof _skill_name, "Новичок" ) ;
	}
	else if ( p_info [ playerid ] [ jackcar_skill ] > 50 && p_info [ playerid ] [ jackcar_skill ] < 101 )
	{
		_skill_level = 100 - p_info [ playerid ] [ jackcar_skill ] ;
		format ( _skill_name, sizeof _skill_name, "Бывалый" ) ;
	}
	else if ( p_info [ playerid ] [ jackcar_skill ] > 100 && p_info [ playerid ] [ jackcar_skill ] < 151 )
	{
		_skill_level = 150 - p_info [ playerid ] [ jackcar_skill ] ;
		format ( _skill_name, sizeof _skill_name, "Эксперт" ) ;
	}
	else _skill_level = 0, format ( _skill_name, sizeof _skill_name, "Профессионал" ) ;
	
	if ( p_info [ playerid ] [ thief_cooldown ] > gettime ( ) ) format ( _status_active, sizeof _status_active, "{"#cGRDialog"}* Заказ будет доступен через {"#cRD"}%s", convert_time ( p_info [ playerid ] [ thief_cooldown ] - gettime ( ), TYPE_TIME_SECOND ) ) ;
	else format ( _status_active, sizeof _status_active, "{"#cGRDialog"}* Вы {"#cGN"}можете {"#cGRDialog"}взять заказ" ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 1024,"\
			{"#cBL"}** Вор деталей **\n\n\
			{"#cWH"}Вор деталей доступен только бандитам.\n\
			Перед тем, как доверить кражу деталей с дорогих транспортных средств\n\
			Вас испытают на дешёвках.\n\
			Если Вы покажите себя хорошо, то, в скором времени,\n\
			начнёте получать хорошие заказы.\n\n\
			{"#cBL"}** Механика **\n\n\
			{"#cWH"}Прокачивая навык вора деталей Вы сможете снимать детали с\n\
			более дорогие транспортные средства, соответственно, оплата\n\
			будет больше.\n\n\
			{"#cBL"}** Навык **\n\n\
			{"#cWH"}Ваш текущий уровень опыта: %d (%s)\n\
			До перехода на следующий уровень: %d\n\
			%s\n\n\
			{"#cGRDialog"}* Стоимость подбора составляет {"#cGN"}%d"valute_title_"\n\
			{"#cGRDialog"}* Вы готовы взять заказ?", p_info [ playerid ] [ jackcar_skill ], _skill_name, _skill_level, _status_active, price_jackcar ) ;
    show_dialog ( playerid, d_thief_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Вор деталей", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock thief_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_thief_quest:
		{
			if ( ! response ) return 1 ;
	        if ( p_t_info [ playerid ] [ c_vehicle ] != INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам уже подобрали т/с." ) ;
	        if ( p_info [ playerid ] [ thief_cooldown ] > gettime ( ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже брали заказ / пытались взять заказ." ) ;
	        
			give_money ( playerid, -price_jackcar ) ;
            insert_money_log ( playerid, INVALID_PLAYER_ID, -price_jackcar, "подбор автоугон" ) ;
	        
			#if defined SAMP
	        set_money_fraction ( gz_info [ 52 ] [ gz_owner ] - 1, 0, price_jackcar, true ) ;
	        #endif
			
			p_info [ playerid ] [ thief_cooldown ] = gettime ( ) + random ( URGENT_TIME ) + URGENT_TIME ;
			update_int_sql ( playerid, "u_thief_cooldown", p_info [ playerid ] [ thief_cooldown ] ) ;
			
			new vehicle_id ;
			new _random_car = random ( sizeof model_thief_skill ), _random_pos, _m_count = 0 ;

            do
			{
                _random_pos = random ( model_thief_count ) ;
                _m_count ++ ;
            }
            while ( thief_place_toggled [ _random_pos ] == true && _m_count < 10 ) ;

            if ( thief_place_toggled [ _random_pos ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент нет работы для тебя." ) ;

			p_t_info [ playerid ] [ c_vehicle ] = CreateVehicle ( model_thief_skill [ _random_car ], model_thief_pos [ _random_pos ] [ 0 ], model_thief_pos [ _random_pos ] [ 1 ], model_thief_pos [ _random_pos ] [ 2 ], model_thief_pos [ _random_pos ] [ 3 ], random ( 126 ), random ( 126 ), -1 ) ;

            vehicle_id = p_t_info [ playerid ] [ c_vehicle ] ;
			veh_info [ vehicle_id - 1 ] [ v_now_pos ] [ 0 ] = model_thief_pos [ _random_pos ] [ 0 ] ;
			veh_info [ vehicle_id - 1 ] [ v_now_pos ] [ 1 ] = model_thief_pos [ _random_pos ] [ 1 ] ;

			p_t_info [ playerid ] [ c_pos_toggled_thief ] = _random_pos ;
			thief_place_toggled [ _random_pos ] = true ;
			
			veh_info [ vehicle_id - 1 ] [ v_owner ] = -1 ;
			veh_info [ vehicle_id - 1 ] [ v_type ] = vehicle_type_player ;
			veh_info [ vehicle_id - 1 ] [ v_jackcar ] = playerid ;
			veh_info [ vehicle_id - 1 ] [ v_fuel ] = 60.0 ;

			new engine, lights, alarm, doors, bonnet, boot, objective ;

			veh_info [ vehicle_id - 1 ] [ v_locked ] = true ;
			GetVehicleParamsEx ( vehicle_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( vehicle_id, engine, lights, alarm, true, bonnet, boot, objective ) ;

			new Float: pos [ 4 ], Float: perv_pos [ 2 ] ;
   			find_mark_gz ( -1, vehicle_id, perv_pos [ 0 ], perv_pos [ 1 ] ) ;
      		get_gz_pos ( perv_pos [ 0 ]-float(-random(50)+random(50)), perv_pos [ 1 ]-float(-random(50)+random(50)), 80.0, pos [ 0 ], pos [ 1 ], pos [ 2 ], pos [ 3 ] ) ;
			p_t_info [ playerid ] [ c_gangzone ] = GangZoneCreate ( pos [ 0 ], pos [ 1 ], pos [ 2 ], pos [ 3 ] ) ;

			GangZoneShowForPlayer ( playerid, p_t_info [ playerid ] [ c_gangzone ], 0x000000AA ) ;
			p_t_info [ playerid ] [ c_time ] = 900 ;

			new scm_string [ 144 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Тебе необходимо снять детали с %s. Примерное нахождение отмечено на карте чёрным квадратом.", GetVehicleNameEx ( vehicle_id ) ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			format ( scm_string, sizeof scm_string, "** Разбор транспорта **\n{"#cGR3D"}Подойдите для взаимодействия\n\n{"#cWH3D"}Заказ: {"#cLY3D"}%s", p_info [ playerid ] [ name ] ) ;
			veh_info [ vehicle_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( scm_string, col_header_3d, 0.0, 0.0, 0.2, 5.0, INVALID_PLAYER_ID, vehicle_id ) ;
			
			thief_area [ playerid ] = CreateDynamicSphere ( model_thief_pos [ _random_pos ] [ 0 ], model_thief_pos [ _random_pos ] [ 1 ], model_thief_pos [ _random_pos ] [ 2 ], 3.0, 0, 0, -1 ) ;
			area_info [ thief_area [ playerid ] ] [ a_type ] = area_type_thief ;
			
			thief_processed [ playerid ] = false ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: calllback_thief_timer ( playerid )
{
	thief_progress { playerid } ++ ;
	
	new extraComponent, vehicleId = p_t_info [ playerid ] [ c_vehicle ] ;
	extraComponent = RandomEx ( EXTRA_COMPONENT_BOOT, EXTRA_COMPONENT_BUMP_FRONT ) ;
	
	veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ extraComponent ] = CAR_COMPONENT_INVISIBLE ;
	foreach(new forplayerid: streamed_in_vehicles[vehicleId]) setCarComponent ( vehicleId, forplayerid ) ;
	checking_quest_progress ( playerid, 5, 1, quest_line_high ) ;
	
	new _chance = 30 ;
	if ( p_info [ playerid ] [ crime_plus ] == true ) _chance = 5 ;
	
	if ( random ( _chance ) == 1 )
	{
		new _det_id ;
		switch ( random ( 5 ) )
		{
			case 0: _det_id = 1080 ;
			case 1: _det_id = 1018 ;
			case 2: _det_id = 1038 ;
			case 3: _det_id = 1140 ;
			case 4: _det_id = 1165 ;
		}
		give_inventory ( playerid, _det_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _det_id ) ) ;
		SendClientMessage ( playerid, col_yellow, global_string ) ;
		SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
	}
	
	if ( thief_progress { playerid } >= 3 )
	{
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Место продажи деталей отмечено у Вас на карте." ) ;
		
		new _position = random ( MAX_URGENT_POSITION ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, urgent_position [ _position ] [ 0 ], urgent_position [ _position ] [ 1 ], urgent_position [ _position ] [ 2 ], 0.0, 0.0, 0.0, 5 ) ;
		is_gps_used { playerid } = 2 ;
		
		thief_timer [ playerid ] = SetTimerEx ( "calllback_thief_timer_1", 60000, false, "i", playerid ) ;
		
		thief_processed [ playerid ] = false ;
		return 1 ;
	}
	
	thief_processed [ playerid ] = false ;
	return 1 ;
}

stock thief_is_gps_used ( playerid )
{
	if ( thief_progress { playerid } >= 3 )
	{
		thief_progress { playerid } = 0 ;
		
		new _veh_price ;
		if ( p_info [ playerid ] [ jackcar_skill ] < 51 ) _veh_price += RandomEx ( 20000, 80000 ) ;
		else if ( p_info [ playerid ] [ jackcar_skill ] > 50 && p_info [ playerid ] [ jackcar_skill ] < 101 ) _veh_price += RandomEx ( 50000, 120000 ) ;
		else if ( p_info [ playerid ] [ jackcar_skill ] > 100 && p_info [ playerid ] [ jackcar_skill ] < 151 ) _veh_price += RandomEx ( 80000, 150000 ) ;
		else _veh_price += RandomEx ( 100000, 250000 ) ;
		
		new scm_string [ 144 ], fractionid = p_info [ playerid ] [ member ] ;
		
		format ( scm_string, 100, "{"#cGInfo"}* {"#cWH"}Вы сдали краденые детали за {"#cGN"}%d"valute_title_"", _veh_price ) ;
		SendClientMessage ( playerid, col_white, scm_string ) ;

		if ( gang_player ( playerid ) ) 
		{
			format ( scm_string, sizeof scm_string, "[F] %s %s[%d] сдал(а) краденые детали. (Процент в общак: %d"valute_title_")", f_rank [ fractionid - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, floatround ( ( _veh_price * 50 ) / 100 ) ) ;
			fraction_message ( fractionid, col_lblue, scm_string ) ;
			
			set_money_fraction ( fractionid - 1, 3, floatround ( ( _veh_price * 50 ) / 100 ), true ) ;
			checking_getto_quest_progress ( playerid, 4, 1 ) ;
		}
		if ( mafia_player ( playerid ) ) 
		{
			format ( scm_string, sizeof scm_string, "[F] %s %s[%d] сдал(а) краденые детали. (Процент в общак: %d"valute_title_")", f_rank [ fractionid - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, floatround ( ( _veh_price * 50 ) / 100 ) ) ;
			fraction_message ( fractionid, col_lblue, scm_string ) ;
			
			set_money_fraction ( fractionid - 1, 3, floatround ( ( _veh_price * 50 ) / 100 ), true ) ;
			checking_mafia_quest_progress ( playerid, 4, 1 ) ;
		}
		
		DisablePlayerRaceCheckpoint ( playerid ) ;
	   	is_gps_used { playerid } = 0 ;
		
		if ( p_t_info [ playerid ] [ c_time ] )
		{
		    p_t_info [ playerid ] [ c_time ] = 0 ;
		}
		
		p_info [ playerid ] [ jackcar_skill ] ++ ;
		p_info [ playerid ] [ thief_cooldown ] = gettime ( ) + random ( URGENT_TIME ) + URGENT_TIME ;
		
		scm_string [ 0 ] = EOS ;
		format ( scm_string, sizeof scm_string, "UPDATE `users` SET `u_jackcarkill` = '%d', `u_thief_cooldown` = '%d' WHERE `u_id` = '%d' LIMIT 1",
		p_info [ playerid ] [ jackcar_skill ], p_info [ playerid ] [ thief_cooldown ], p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, scm_string ) ;
		return 1 ;
	}
	return 0 ;
}

callback: calllback_thief_timer_1 ( playerid )
{
	if ( IsValidVehicle ( p_t_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_t_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_t_info [ playerid ] [ c_vehicle ], 4 ) ;
	if ( p_t_info [ playerid ] [ c_gangzone ] != -1 )
 	{
		GangZoneHideForPlayer ( playerid, p_t_info [ playerid ] [ c_gangzone ] ) ;
		GangZoneDestroy ( p_t_info [ playerid ] [ c_gangzone ] ) ;
		p_t_info [ playerid ] [ c_gangzone ] = -1 ;
 	}
	
	if ( IsValidDynamicArea ( thief_area [ playerid ] ) ) DestroyDynamicArea ( thief_area [ playerid ] ) ;
	if ( p_t_info [ playerid ] [ c_pos_toggled_thief ] != -1 )
 	{
	 	thief_place_toggled [ p_t_info [ playerid ] [ c_pos_toggled_thief ] ] = false ;
	}
	return 1 ;
}

stock thief_OnPlayerDisconnect ( playerid )
{
	if ( thief_timer [ playerid ] != -1 )
	{
		KillTimer ( thief_timer [ playerid ] ) ;
		thief_timer [ playerid ] = -1 ;
		
		if ( IsValidVehicle ( p_t_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_t_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_t_info [ playerid ] [ c_vehicle ], 4 ) ;
		if ( p_t_info [ playerid ] [ c_gangzone ] != -1 )
		{
			GangZoneHideForPlayer ( playerid, p_t_info [ playerid ] [ c_gangzone ] ) ;
			GangZoneDestroy ( p_t_info [ playerid ] [ c_gangzone ] ) ;
			p_t_info [ playerid ] [ c_gangzone ] = -1 ;
		}
		
		if ( IsValidDynamicArea ( thief_area [ playerid ] ) ) DestroyDynamicArea ( thief_area [ playerid ] ) ;
		if ( p_t_info [ playerid ] [ c_pos_toggled_thief ] != -1 )
		{
			thief_place_toggled [ p_t_info [ playerid ] [ c_pos_toggled_thief ] ] = false ;
		}
	}
	return 1 ;
}

stock thief_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_thief:
		{
			if ( p_t_info [ playerid ] [ c_vehicle ] != INVALID_VEHICLE_ID && GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT && thief_processed [ playerid ] == false )
			{
				if ( thief_progress { playerid } < 3 )
				{
					new vehicle_id = p_t_info [ playerid ] [ c_vehicle ] ;
					if ( GetPlayerDistanceFromPoint ( playerid, veh_info [ vehicle_id - 1 ] [ v_now_pos ] [ 0 ], veh_info [ vehicle_id - 1 ] [ v_now_pos ] [ 1 ], veh_info [ vehicle_id - 1 ] [ v_now_pos ] [ 2 ] ) < 5 )
					{
						thief_processed [ playerid ] = true ;
						ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 6.1, 0, 0, 0, 0, 0, 1 ) ;
					
						thief_timer [ playerid ] = SetTimerEx ( "calllback_thief_timer", 3000, false, "i", playerid ) ;
						return 1 ;
					}
				}
			}
			return 1 ;
		}
	}
	return 0 ;
}