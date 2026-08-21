#define PRICE_DIST_WATER 1000

enum
{
	RADIAL_CLOSE_VEHICLE,
	RADIAL_DOCUMENTS,
	RADIAL_DRIVER_LICENSE,
	RADIAL_EJECT_LEFT_DOOR,
	RADIAL_EJECT_RIGHT_DOOR,
	RADIAL_EMPLOYMENT_HISTORY,
	RADIAL_GIVE_MONEY,
	RADIAL_LICENSE,
	RADIAL_MEDICAL_CARD,
	RADIAL_MILITARY_ID,
	RADIAL_OPEN_VEHICLE,
	RADIAL_PARKING,
	RADIAL_PASSPORT,
	RADIAL_PROPERTY,
	RADIAL_PROPOSE,
	RADIAL_PTS,
	RADIAL_REPAIR_VEHICLE,
	RADIAL_SELL_BUSINESS,
	RADIAL_SELL_FLAT,
	RADIAL_SELL_HOUSE,
	RADIAL_SELLCAR,
	RADIAL_SHAKE_HANDS,
	RADIAL_TECHNICAL_PASSPORT,
	RADIAL_TRADE,
	RADIAL_TRANSPORT,
	RADIAL_USE_GASOLINE,
	RADIAL_TRUNK,

	RADIAL_MAX_ITEM
} ;

enum _radial_menu
{
	rad_id,
	rad_name [ 32 ],
	rad_icon
} ;

new radial_menu [ RADIAL_MAX_ITEM ] [ _radial_menu ] =
{
	{ 0, "Закрыть т/с", RADIAL_CLOSE_VEHICLE },
	{ 1, "Показать корочку", RADIAL_DOCUMENTS },
	{ 2, "Показать вод. права", RADIAL_DRIVER_LICENSE },
	{ 3, "Выкинуть из т/с", RADIAL_EJECT_LEFT_DOOR },
	{ 4, "Выкинуть из т/с", RADIAL_EJECT_RIGHT_DOOR },
	{ 5, "Показать трудовую", RADIAL_EMPLOYMENT_HISTORY },
	{ 6, "Передать деньги", RADIAL_GIVE_MONEY },
	{ 7, "Показать лицензии", RADIAL_LICENSE },
	{ 8, "Показать мед. карту", RADIAL_MEDICAL_CARD },
	{ 9, "Военный билет", RADIAL_MILITARY_ID },
	{ 10, "Открыть т/с", RADIAL_OPEN_VEHICLE },
	{ 11, "Препарковать т/с", RADIAL_PARKING },
	{ 12, "Показать паспорт", RADIAL_PASSPORT },
	{ 13, "Недвижимость", RADIAL_PROPERTY },
	{ 14, "Попрошайничать", RADIAL_PROPOSE },
	{ 15, "Показать ПТС", RADIAL_PTS },
	{ 16, "Починить т/с", RADIAL_REPAIR_VEHICLE },
	{ 17, "Бизнес", RADIAL_SELL_BUSINESS },
	{ 18, "Квартира", RADIAL_SELL_FLAT },
	{ 19, "Дом", RADIAL_SELL_HOUSE },
	{ 20, "Продать т/с", RADIAL_SELLCAR },
	{ 21, "Пожать руку", RADIAL_SHAKE_HANDS },
	{ 22, "Показать тех. паспорт", RADIAL_TECHNICAL_PASSPORT },
	{ 23, "Обмен имуществом", RADIAL_TRADE },
	{ 24, "Меню т/с", RADIAL_TRANSPORT },
	{ 25, "Заправить т/с", RADIAL_USE_GASOLINE },
	{ 26, "Багажник", RADIAL_TRUNK }
} ;

enum
{
    ENTITY_TYPE_NOTHING = 0,
    ENTITY_TYPE_BUILDING,
    ENTITY_TYPE_VEHICLE,
    ENTITY_TYPE_PED,
    ENTITY_TYPE_OBJECT,
    ENTITY_TYPE_DUMMY,
    ENTITY_TYPE_NOTINPOOLS
} ;

stock show_packet_radial ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		
	}
	else if ( actionId == 1 )
	{
		new _position = strval ( data ) ;

		if ( _position == RADIAL_CLOSE_VEHICLE ) toggle_locked ( playerid, idaofcar [ playerid ], 3 ) ;
		else if ( _position == RADIAL_DOCUMENTS ) { }
		else if ( _position == RADIAL_DRIVER_LICENSE ) { }
		else if ( _position == RADIAL_EJECT_LEFT_DOOR ) { }
		else if ( _position == RADIAL_EJECT_RIGHT_DOOR ) { }
		else if ( _position == RADIAL_EMPLOYMENT_HISTORY ) { }
		else if ( _position == RADIAL_GIVE_MONEY ) { }
		else if ( _position == RADIAL_LICENSE )
		{
			new _cmd [ 6 ] ;
			format ( _cmd, sizeof _cmd, "%d", get_player_use_listitem ( playerid ) ) ;
			callcmd::lic ( playerid, _cmd ) ;
		}
		else if ( _position == RADIAL_MEDICAL_CARD )
		{
			new _cmd [ 6 ] ;
			format ( _cmd, sizeof _cmd, "%d", get_player_use_listitem ( playerid ) ) ;
			callcmd::med ( playerid, _cmd ) ;
		}
		else if ( _position == RADIAL_MILITARY_ID ) { }
		else if ( _position == RADIAL_OPEN_VEHICLE ) toggle_locked ( playerid, idaofcar [ playerid ], 1 ) ;
		else if ( _position == RADIAL_PARKING ) callcmd::vpark ( playerid ) ;
		else if ( _position == RADIAL_PASSPORT )
		{
			new _cmd [ 6 ] ;
			format ( _cmd, sizeof _cmd, "%d", get_player_use_listitem ( playerid ) ) ;
			callcmd::pass ( playerid, _cmd ) ;
		}
		else if ( _position == RADIAL_PROPERTY ) { }
		else if ( _position == RADIAL_PROPOSE ) { }
		else if ( _position == RADIAL_PTS )
		{
			new _cmd [ 6 ] ;
			format ( _cmd, sizeof _cmd, "%d", get_player_use_listitem ( playerid ) ) ;
			callcmd::pts ( playerid, _cmd ) ;
		}
		else if ( _position == RADIAL_REPAIR_VEHICLE ) callcmd::repairkit ( playerid ) ;
		else if ( _position == RADIAL_SELL_BUSINESS ) { }
		else if ( _position == RADIAL_SELL_FLAT ) { }
		else if ( _position == RADIAL_SELL_HOUSE ) { }
		else if ( _position == RADIAL_SELLCAR ) callcmd::sellcar ( playerid, "" ) ;
		else if ( _position == RADIAL_SHAKE_HANDS ) { }
		else if ( _position == RADIAL_TECHNICAL_PASSPORT ) { }
		else if ( _position == RADIAL_TRADE )
		{
			new _cmd [ 6 ] ;
			format ( _cmd, sizeof _cmd, "%d", get_player_use_listitem ( playerid ) ) ;
			callcmd::trade ( playerid, _cmd ) ;
		}
		else if ( _position == RADIAL_TRANSPORT ) { }
		else if ( _position == RADIAL_USE_GASOLINE ) callcmd::usecanister ( playerid ) ;
		else if ( _position == RADIAL_TRUNK ) show_bagage ( playerid ) ;
	}
	else if ( actionId == 2 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new _type, _targetid = INVALID_PLAYER_ID, _actorid = INVALID_PLAYER_ID ;
		JSON_GetInt ( json, "type", _type ) ;
		if ( _type == ENTITY_TYPE_PED )
		{
			JSON_GetInt ( json, "targetid", _targetid ) ;
			JSON_GetInt ( json, "actorid", _actorid ) ;

			set_player_use_listitem ( playerid, _targetid ) ;
		}
		else
		{
			JSON_GetInt ( json, "targetid", _targetid ) ;
			idaofcar [ playerid ] = _targetid ;
		}

		show_open_radial ( playerid, _type, _targetid, _actorid ) ;
	}
	return 1 ;
}

stock show_open_radial ( playerid, _type, _targetid, _actorid )
{
	if ( _actorid != INVALID_PLAYER_ID )
	{
		send_check_cinfo ( playerid, "Вы выбрали NPC персонажа!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new Node: node = JSON_Array ( ) ;
	if ( _type == ENTITY_TYPE_PED )
	{
		new Node: radialNode ;
		/*if ( get_inventory_item ( playerid, 2171 ) )
		{
			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_MILITARY_ID ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_MILITARY_ID ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_MILITARY_ID ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;
		}*/
		if ( GetInventoryFindItem ( playerid, SUBMARINE_TIME, 2173 ) )
		{
			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_PASSPORT ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_PASSPORT ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_PASSPORT ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;
		}
		/*if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2220 ) ||
			GetInventoryFindItem ( playerid, SUB_INVENTORY, 2222 ) ||
			GetInventoryFindItem ( playerid, SUB_INVENTORY, 2223 ) )
		{
			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_DOCUMENTS ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_DOCUMENTS ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_DOCUMENTS ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;
		}*/
		if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2221 ) )
		{
			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_MEDICAL_CARD ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_MEDICAL_CARD ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_MEDICAL_CARD ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;
		}

		radialNode = JSON_Array (
			JSON_Object (
				"id",        		JSON_Int ( radial_menu [ RADIAL_LICENSE ] [ rad_id ] ),
				"title",         	JSON_String ( radial_menu [ RADIAL_LICENSE ] [ rad_name ] ),
				"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_LICENSE ] [ rad_icon ] )
			)
		) ;
		node = JSON_Append ( node, radialNode ) ;

		radialNode = JSON_Array (
			JSON_Object (
				"id",        		JSON_Int ( radial_menu [ RADIAL_TRADE ] [ rad_id ] ),
				"title",         	JSON_String ( radial_menu [ RADIAL_TRADE ] [ rad_name ] ),
				"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_TRADE ] [ rad_icon ] )
			)
		) ;
		node = JSON_Append ( node, radialNode ) ;
	}
	else if ( _type == ENTITY_TYPE_VEHICLE )
	{
		new Node: radialNode, playerState = GetPlayerState ( playerid ) ;
		if ( playerState == PLAYER_STATE_DRIVER )
		{
			new _v_type = veh_info [ _targetid - 1 ] [ v_type ] ;
			if ( _v_type == vehicle_type_player )
			{
				if ( veh_info [ _targetid - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] )
				{
					send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				radialNode = JSON_Array (
					JSON_Object (
						"id",        		JSON_Int ( radial_menu [ RADIAL_SELLCAR ] [ rad_id ] ),
						"title",         	JSON_String ( radial_menu [ RADIAL_SELLCAR ] [ rad_name ] ),
						"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_SELLCAR ] [ rad_icon ] )
					)
				) ;
				node = JSON_Append ( node, radialNode ) ;

				radialNode = JSON_Array (
					JSON_Object (
						"id",        		JSON_Int ( radial_menu [ RADIAL_PTS ] [ rad_id ] ),
						"title",         	JSON_String ( radial_menu [ RADIAL_PTS ] [ rad_name ] ),
						"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_PTS ] [ rad_icon ] )
					)
				) ;
				node = JSON_Append ( node, radialNode ) ;
			}

			else if ( _v_type == vehicle_type_family )
			{
				if ( veh_info [ _targetid - 1 ] [ v_owner ] != p_info [ playerid ] [ family ] )
				{
					send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}

			else if ( _v_type == vehicle_type_server )
			{
				if ( veh_info [ _targetid - 1 ] [ v_owner ] != p_info [ playerid ] [ member ] )
				{
					send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}

			else
			{
				send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _rad ;
			if ( veh_info [ _targetid - 1 ] [ v_locked ] ) _rad = RADIAL_OPEN_VEHICLE ;
			else _rad = RADIAL_CLOSE_VEHICLE ;
			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ _rad ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ _rad ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ _rad ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;

			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_REPAIR_VEHICLE ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_REPAIR_VEHICLE ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_REPAIR_VEHICLE ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;

			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_USE_GASOLINE ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_USE_GASOLINE ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_USE_GASOLINE ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;
		}
		else if ( playerState == PLAYER_STATE_ONFOOT )
		{
			new _v_type = veh_info [ _targetid - 1 ] [ v_type ] ;
			if ( _v_type == vehicle_type_player )
			{
				if ( veh_info [ _targetid - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] )
				{
					send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				radialNode = JSON_Array (
					JSON_Object (
						"id",        		JSON_Int ( radial_menu [ RADIAL_SELLCAR ] [ rad_id ] ),
						"title",         	JSON_String ( radial_menu [ RADIAL_SELLCAR ] [ rad_name ] ),
						"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_SELLCAR ] [ rad_icon ] )
					)
				) ;
				node = JSON_Append ( node, radialNode ) ;
			}

			else if ( _v_type == vehicle_type_family )
			{
				if ( veh_info [ _targetid - 1 ] [ v_owner ] != p_info [ playerid ] [ family ] )
				{
					send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}

			else if ( _v_type == vehicle_type_server )
			{
				if ( veh_info [ _targetid - 1 ] [ v_owner ] != p_info [ playerid ] [ member ] )
				{
					send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}

			else if ( _v_type == vehicle_type_job && _targetid == player_rentcar [ playerid ] )
			{
				
			}

			else
			{
				send_check_cinfo ( playerid, "С данным транспортом не доступно взаимодействие!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _rad ;
			if ( veh_info [ _targetid - 1 ] [ v_locked ] ) _rad = RADIAL_OPEN_VEHICLE ;
			else _rad = RADIAL_CLOSE_VEHICLE ;
			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ _rad ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ _rad ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ _rad ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;

			radialNode = JSON_Array (
				JSON_Object (
					"id",        		JSON_Int ( radial_menu [ RADIAL_TRUNK ] [ rad_id ] ),
					"title",         	JSON_String ( radial_menu [ RADIAL_TRUNK ] [ rad_name ] ),
					"drawableResId", 	JSON_Int ( radial_menu [ RADIAL_TRUNK ] [ rad_icon ] )
				)
			) ;
			node = JSON_Append ( node, radialNode ) ;
		}
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_RADIAL_MENU, 0, global_string ) ;
	return 1 ;
}

stock VehicleProcessBuoyancy ( playerid )
{
	if ( p_t_info [ playerid ] [ p_dialog ] != -1 ) return true ;

	new vehicleId = GetPlayerVehicleID ( playerid ) ;
	if ( vehicleId && GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "\
		{"#cWH"}Так как Ваш транспорт {"#cGN"}%s {"#cWH"}попал в воду вместе с Вами, Вы можете вызвать эвакуацию.\n\n\
		{"#cGRDialog"}* Вы хотите вызвать эвакуацию?\n\
		{"#cGRDialog"}* При использовании кнопки {"#cOR"}Далее{"#cWH"}, Вам будет предложен список ближайших СТО для эвакуации.",
		GetVehicleNameEx ( vehicleId ) ) ;
		show_dialog ( playerid, d_buoyancy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Транспортировка транспорта", global_string, "Далее", "Закрыть" ) ;
	}
	return true ;
}

stock buoyancy_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_buoyancy:
		{
			if ( ! response ) return true ;

			buoyancyBusinessList ( playerid, bizz_type_tune, 0 ) ;
			return true ;
		}
		case d_buoyancy_biz:
		{
		    if ( ! response ) return true ;

			new bType = get_player_use_listitem ( playerid ) ;
			if ( GetString ( inputtext, "Предыдущая страница" ) ) gpsBusinessList ( playerid, bType, page_count [ playerid ] - 1 ) ;
			else if ( GetString ( inputtext, "Следующая страница" ) ) gpsBusinessList ( playerid, bType, page_count [ playerid ] + 1 ) ;
			else
			{
				new idx = get_player_listitem_values ( playerid, listitem ),
					vehicleId = GetPlayerVehicleID ( playerid ),
					tuningId = GetTuningIdx ( idx ) ;
				clear_player_listitem_values ( playerid ) ;

				new Float: _distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], b_info [ idx - 1 ] [ b_position ] [ 0 ], b_info [ idx - 1 ] [ b_position ] [ 1 ], b_info [ idx - 1 ] [ b_position ] [ 2 ] ) ;
				new priceTeleport = floatround ( PRICE_DIST_WATER * _distance ) ;
				if ( priceTeleport > p_info [ playerid ] [ money ] )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return true ;
				}

				give_money ( playerid, -priceTeleport ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -priceTeleport, "Буксировка к СТО из воды" ) ;

				set_pos ( playerid, tuning_info [ tuningId ] [ t_exit_pos ] [ 0 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 1 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 2 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 3 ], 0, 0 ) ;
				if ( vehicleId )
				{
					SetVehiclePos ( vehicleId, tuning_info [ tuningId ] [ t_exit_pos ] [ 0 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 1 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 2 ] ) ;
					SetVehicleZAngle ( vehicleId, tuning_info [ tuningId ] [ t_exit_pos ] [ 3 ] ) ;

					LinkVehicleToInterior ( vehicleId, 0 ) ;
					SetVehicleVirtualWorld ( vehicleId, 0 ) ;

					PutPlayerInVehicle ( playerid, vehicleId, 0 ) ;
				}

				foreach(new i: streamed_players[playerid])
				{
					if ( GetPlayerState ( i ) == PLAYER_STATE_PASSENGER && GetPlayerVehicleID ( i ) == vehicleId )
					{
						set_pos ( i, tuning_info [ tuningId ] [ t_exit_pos ] [ 0 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 1 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 2 ], tuning_info [ tuningId ] [ t_exit_pos ] [ 3 ], 0, 0 ) ;
					}
				}
			}
			return true ;
		}
	}
	return false ;
}

stock buoyancyBusinessList ( playerid, businessType, page )
{
	page_count [ playerid ] = page ;

	new count_type = 0, count = 0, Float: _distance, tuningId, priceTeleport ;
	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Расстояние:\t{"#cBL"}Цена:\n" ) ;
	foreach(new b: business_types[businessType])
	{
		count_type ++ ;

		if ( page * 20 > count_type ) continue ;
		if ( count_type > ( page + 1 ) * 20 ) continue ;

		set_player_listitem_values ( playerid, count, b ) ;

		count ++ ;

		tuningId = GetTuningIdx ( b ) ;
		if ( tuningId == -1 ) continue ;

		priceTeleport = floatround ( PRICE_DIST_WATER * _distance ) ;
		_distance = GetDistanceBetweenPoints ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], b_info [ b - 1 ] [ b_position ] [ 0 ], b_info [ b - 1 ] [ b_position ] [ 1 ], b_info [ b - 1 ] [ b_position ] [ 2 ] ) ;
		format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t%.2f км\t{"#cGN"}%s"valute_title_"\n", global_string, count_type, b_info [ b - 1 ] [ b_name ], _distance, GetPlayerCashValueToSmile ( priceTeleport ) ) ;
	}
	set_player_use_listitem ( playerid, businessType ) ;

	if ( page > 0 ) strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
	if ( count_type > ( page + 1 ) * 20 ) strcat ( global_string, "{"#cBL"}Следующая страница" ) ;

	static const _str [ ] = "{"#cBHD"}%s (Всего: {"#cWH"}%d {"#cBHD"}шт.)" ;
	new header_string [ sizeof _str + 32 + 9 ] ;
	format ( header_string, sizeof header_string, _str, b_types [ businessType ], count_type ) ;
	show_dialog ( playerid, d_buoyancy_biz, DIALOG_STYLE_TABLIST_HEADERS, header_string, global_string, "Выбрать", "Закрыть" ) ;
    return true ;
}