#define pick_type_gentrance 300
#define pick_type_gexit 301
#define pick_type_buy_seed 302
#define pick_type_sell_seed 303

#define MAX_SEED_INFO 3
enum _seed_info
{
	s_price, // покупка
	s_sell_price, // за штуку
	s_object, // объект, который будет расти
	s_time, // время роста
	s_name [ 24 ],
	s_sell_name [ 24 ]
}
new seed_info [ MAX_SEED_INFO ] [ _seed_info ] =
{
	{ 10, 4, 3409, 150, "Картошка", "картошку" },
	{ 12, 7, 673, 150, "Апельсиновое дерево", "апельсины" },
	{ 20, 11, 715, 150, "Яблочное дерево", "яблоки" }
} ;

new pick_buy_seed, pick_sell_seed ;
new Float: pickups_seed_posoton [ 2 ] [ 3 ] =
{
	{ 1201.5639, -566.5419, 41.2923 }, // покупка
	{ 1200.8265, -562.9439, 41.2923 } // продажа
} ;

new pick_garden_exit ;
new Float: garden_player_position [ 4 ] = { 76.4142, -950.1591, 1207.7563, 178.5181 } ;

new Float: garden_object_position [ MAX_PLANT_IN_GARDEN ] [ 3 ] =
{
	{ 74.8385, -965.6826, 1207.9985 },
	{ 70.7075, -970.8508, 1207.9985 },
	{ 72.8988, -976.3989, 1208.0063 },
	{ 80.2013, -976.3516, 1208.0063 },
	{ 82.3042, -970.9155, 1207.9985 },
	{ 79.1521, -966.0449, 1208.0063 },
	{ 70.1850, -963.8303, 1207.9985 },
	{ 66.8422, -969.5558, 1208.0063 },
	{ 67.7417, -976.2611, 1208.0063 },
	{ 73.1194, -980.7407, 1208.0063 },
	{ 82.8119, -979.0242, 1207.9985 },
	{ 86.2070, -973.0189, 1208.0063 },
	{ 85.0405, -966.4591, 1208.0063 },
	{ 79.7530, -962.0402, 1208.0063 },
	{ 70.0628, -959.0997, 1208.0063 },
	{ 65.4829, -963.0447, 1208.0063 },
	{ 62.9591, -968.6727, 1208.0063 },
	{ 63.1364, -975.1344, 1208.0063 },
	{ 66.0902, -980.6090, 1208.0063 },
	{ 71.0062, -984.2471, 1208.0063 },
	{ 81.0476, -984.6729, 1208.0063 },
	{ 87.6162, -979.7933, 1208.0063 },
	{ 90.0200, -974.0337, 1208.0063 },
	{ 89.8842, -967.6791, 1208.0063 },
	{ 86.8147, -962.1595, 1208.0063 },
	{ 82.0260, -958.6077, 1208.0063 },
	{ 70.8204, -954.4052, 1208.0063 },
	{ 65.2592, -957.3482, 1207.9985 },
	{ 61.3262, -962.2155, 1208.0063 },
	{ 58.9483, -967.8795, 1208.0063 },
	{ 58.6894, -973.9541, 1208.0063 },
	{ 60.8259, -979.8207, 1208.0063 },
	{ 64.8418, -984.6862, 1208.0063 },
	{ 69.8970, -987.9083, 1208.0063 },
	{ 82.0360, -988.4890, 1208.0063 },
	{ 87.5458, -985.2934, 1207.9985 },
	{ 91.5982, -980.8971, 1208.0063 },
	{ 94.2107, -974.9647, 1208.0063 },
	{ 94.1753, -968.7722, 1208.0063 },
	{ 92.0132, -963.0202, 1208.0063 },
	{ 88.2998, -958.1091, 1208.0063 },
	{ 83.1832, -954.8607, 1208.0063 }
} ;

new Iterator:houses_garden<MAX_HOUSES-1>;

stock garden_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `houses_garden`", "houses_garden_loading" ) ;
	
	pick_garden_exit = CreateDynamicPickup ( 19639, 23, garden_player_position [ 0 ], garden_player_position [ 1 ], garden_player_position [ 2 ], -1, garden_interior, -1 ) ;
	pick_info [ pick_garden_exit ] [ pick_type ] = pick_type_gexit ;
	
	CreateDynamic3DTextLabel ( "** Покупка семян **", col_blue, pickups_seed_posoton [ 0 ] [ 0 ], pickups_seed_posoton [ 0 ] [ 1 ], pickups_seed_posoton [ 0 ] [ 2 ] + 1.0, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, 0, 0 ) ;
	pick_buy_seed = CreateDynamicPickup ( 1239, 23, pickups_seed_posoton [ 0 ] [ 0 ], pickups_seed_posoton [ 0 ] [ 1 ], pickups_seed_posoton [ 0 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ pick_buy_seed ] [ pick_type ] = pick_type_buy_seed ;
	
	CreateDynamic3DTextLabel ( "** Продажа **", col_blue, pickups_seed_posoton [ 1 ] [ 0 ], pickups_seed_posoton [ 1 ] [ 1 ], pickups_seed_posoton [ 1 ] [ 2 ] + 1.0, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, 0, 0 ) ;
	pick_sell_seed = CreateDynamicPickup ( 1239, 23, pickups_seed_posoton [ 1 ] [ 0 ], pickups_seed_posoton [ 1 ] [ 1 ], pickups_seed_posoton [ 1 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ pick_sell_seed ] [ pick_type ] = pick_type_sell_seed ;
	return 1 ;
}

stock garden_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_buy_seed:
		{
			global_string [ 0 ] = EOS ;
			new line_string [ 55 + 24 + 4 ] ;

			for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
			{
				format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, стоимость покупки: {99cc00}%d$\n", seed_info [ i ] [ s_name ], seed_info [ i ] [ s_price ] ) ;
				strcat ( global_string, line_string ) ;
			}
			show_dialog ( playerid, d_buy_seed, DIALOG_STYLE_LIST, "{"#cBHD"}Покупка семян", global_string, "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case pick_type_sell_seed:
		{
			global_string [ 0 ] = EOS ;
			new line_string [ 55 + 24 + 4 ], _id_seed = 0 ;

			for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
			{
				if ( ! p_info [ playerid ] [ seed_sell ] [ i ] ) continue ;

				format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, стоимость продажи: {99cc00}%d$\n", seed_info [ i ] [ s_name ], seed_info [ i ] [ s_sell_price ] * p_info [ playerid ] [ seed_sell ] [ i ] ) ;
				strcat ( global_string, line_string ) ;

				set_player_listitem_values ( playerid, _id_seed, i ) ;

				_id_seed ++ ;
			}
			if ( ! _id_seed ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет продукции на продажу." ) ;
			show_dialog ( playerid, d_sell_seed, DIALOG_STYLE_LIST, "{"#cBHD"}Продажа продукции", global_string, "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case pick_type_gentrance:
		{
			foreach(new h: houses_garden)
			{
				if ( h_info [ h - 1 ] [ h_garden_pickup ] != pickupid ) continue ;
				
				SetPVarInt ( playerid, "garden_id", h ) ;
				set_pos ( playerid, garden_player_position [ 0 ], garden_player_position [ 1 ], garden_player_position [ 2 ], garden_player_position [ 3 ], garden_interior, h_info [ h - 1 ] [ h_id ] ) ;
				break ;
			}
			return 1 ;
		}
		case pick_type_gexit:
		{
			if ( ! GetPVarInt ( playerid, "garden_id" ) ) return bad_exit ( playerid ) ;
			
			new _h_id = GetPVarInt ( playerid, "garden_id" ) ;
			set_pos ( playerid, h_info [ _h_id - 1 ] [ h_garden_position ] [ 0 ],
								h_info [ _h_id - 1 ] [ h_garden_position ] [ 1 ],
								h_info [ _h_id - 1 ] [ h_garden_position ] [ 2 ], 
								h_info [ _h_id - 1 ] [ h_garden_position ] [ 3 ], 0, 0 ) ;
								
			DeletePVar ( playerid, "garden_id" ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: houses_garden_loading ( )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
	    for ( new i = 0 ; i < rows ; i ++ )
	    {
	        new _h_id = cache_get_field_content_int ( i, "h_id", sql_connection ) ;
	        
	        new _id = cache_get_field_content_int ( i, "h_slot", sql_connection ) ;
	        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = cache_get_field_content_int ( i, "h_garden_time", sql_connection ) ;
	        h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] = cache_get_field_content_int ( i, "h_garden_result", sql_connection ) ;
	        h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = cache_get_field_content_int ( i, "h_garden_object", sql_connection ) ;
	        
	        h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] = cache_get_field_content_int ( i, "h_garden_seed", sql_connection ) ;
	        
			new _h_garden_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] ;
			new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
			h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _h_garden_seed ] [ s_object ], 
																							garden_object_position [ _id ] [ 0 ],
																							garden_object_position [ _id ] [ 1 ],
																							( garden_object_position [ _id ] [ 2 ] - 12 ) + _z_update,
																							0.0, 0.0, 0.0 ,
																							_h_id, garden_interior ) ;

            if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] > 1 )
			{
			    new text_label [ 59 + 32 + 4 ] ;
			    format ( text_label, sizeof text_label, "** %s **\n\n{FFFFFF}До созревания: {99cc00}%d минут(ы)", seed_info [ _h_garden_seed ] [ s_name ], h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) ;
			    UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], col_blue, text_label ) ;
			}
			else
			{
			    new text_label [ 67 + 32 ] ;
			    format ( text_label, sizeof text_label, "** %s **\n{FFFFFF}Растение созрело!\n\n{99cc00}Используйте ALT", seed_info [ _h_garden_seed ] [ s_name ] ) ;
			    UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], col_blue, text_label ) ;
			}
	    }
	}
	return 1 ;
}

stock create_seed_position ( playerid, _seed_position )
{
    new _h_id = GetPVarInt ( playerid, "garden_id" ), bool: _free_id ;
    for ( new _id = 0 ; _id < MAX_PLANT_IN_GARDEN ; _id ++ )
    {
        if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] > 0 ) continue ;
        
        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = seed_info [ _seed_position ] [ s_time ] ;
        h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] = 0 ;
        
        new Float: x, Float: y, Float: z ;
        GetPlayerPos ( playerid, x, y, z ) ;
        
        h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] = _seed_position ;
        
        new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
		h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _seed_position ] [ s_object ], 
																						garden_object_position [ _id ] [ 0 ],
																						garden_object_position [ _id ] [ 1 ],
																					 	( garden_object_position [ _id ] [ 2 ] - 12 ) + _z_update,
																						0.0, 0.0, 0.0 ,
																						_h_id, garden_interior ) ;
																						
        new text_label [ 59 + 32 + 4 ] ;
	    format ( text_label, sizeof text_label, "** %s **\n\n{FFFFFF}До созревания: {99cc00}%d минут(ы)", seed_info [ _seed_position ] [ s_name ], h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) ;
	    UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], col_blue, text_label ) ;

        global_string [ 0 ] = EOS ;
        format ( global_string, sizeof ( global_string ), "INSERT INTO `houses_garden` (`h_id`,`h_slot`,`h_garden_time`,`h_garden_seed`) VALUES ('%d','%d','%d','%d')",
		_h_id, _id, h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ], _seed_position ) ;
		mysql_tquery ( sql_connection, global_string ) ;
		
		_free_id = true ;
		break ;
	}
	
	if ( _free_id == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас посажено максимальное количество растений." ) ;
	
	p_info [ playerid ] [ p_seed ] [ _seed_position ] -- ;

    new update_string [ 100 ], sql_string [ 144 ] ;
    for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
    {
        if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
		else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
    }
    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, sql_string ) ;

    ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
	return 1 ;
}

stock save_garden ( _house_id )
{
	new sql_string [ 144 ] ;
    for ( new _id = 0 ; _id < MAX_PLANT_IN_GARDEN ; _id ++ )
	{
		if ( ! h_info [ _house_id - 1 ] [ h_garden_time ] [ _id ] ) continue ;

        format ( sql_string, sizeof sql_string, "UPDATE `houses_garden` SET `h_garden_time` = '%d', `h_garden_result` = '%d' WHERE `h_id` = '%d' AND `h_slot` = '%d' LIMIT 1",
		h_info [ _house_id - 1 ] [ h_garden_time ] [ _id ], h_info [ _house_id - 1 ] [ h_garden_result ] [ _id ], _house_id, _id ) ;
    	mysql_tquery ( sql_connection, sql_string ) ;
	}
	return 1 ;
}

stock garden_minute_timer ( )
{
	foreach(new _h_id: houses_garden)
	{
	    for ( new _id = 0 ; _id < MAX_PLANT_IN_GARDEN ; _id ++ )
	    {
		    if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] > 1 )
		    {
		        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] -- ;

                new _h_garden_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] ;
                
		        new text_label [ 59 + 32 + 4 ] ;
			    format ( text_label, sizeof text_label, "** %s **\n\n{FFFFFF}До созревания: {99cc00}%d минут(ы)", seed_info [ _h_garden_seed ] [ s_name ], h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) ;
				UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], col_blue, text_label ) ;

				if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 120 || h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 90 ||
					h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 60 || h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 30 )
				{
				
				    if ( h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] < 4 ) h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] ++ ;

				    new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
				    DestroyDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) ;
					h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _h_garden_seed ] [ s_object ], 
																									garden_object_position [ _id ] [ 0 ],
																									garden_object_position [ _id ] [ 1 ],
																									( garden_object_position [ _id ] [ 2 ] - 12 ) + _z_update,
																									0.0, 0.0, 0.0 ,
																									_h_id, garden_interior ) ;
				}
				else if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 1 )
				{
                    h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = 1 ;

                    format ( text_label, sizeof text_label, "** %s **\n{FFFFFF}Растение созрело!\n\n{99cc00}Используйте ALT", seed_info [ _h_garden_seed ] [ s_name ] ) ;
					UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], col_blue, text_label ) ;

                    h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] ++ ;
					save_garden ( _h_id ) ;

                    new _h_garden_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] ;
				    new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
				    DestroyDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) ;
					h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _h_garden_seed ] [ s_object ], 
																									garden_object_position [ _id ] [ 0 ],
																									garden_object_position [ _id ] [ 1 ],
																									( garden_object_position [ _id ] [ 2 ] - 12 ) + _z_update,
																									0.0, 0.0, 0.0 ,
																									_h_id, garden_interior ) ;
				}
		    }
		}
	}
	return 1 ;
}

stock garden_KeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused newkeys
	#pragma unused oldkeys
	if ( GetPVarInt ( playerid, "garden_id" ) > 0 )
	{
		new bool: _user_house = false ;
		foreach(new h: player_houses[playerid])
		{
			if ( GetPVarInt ( playerid, "garden_id" ) != h_info [ h - 1 ] [ h_id ] ) continue ;
			
			_user_house = true ;
			break ;
		}
	    if ( _user_house == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный огород не принадлежит Вашему дому!" ) ;
		
		new _h_id = GetPVarInt ( playerid, "garden_id" ) ;
		for ( new _id = 0 ; _id < MAX_PLANT_IN_GARDEN ; _id ++ )
	    {
	        if ( ! IsPlayerInRangeOfPoint ( playerid, 2.0, garden_object_position [ _id ] [ 0 ],
															garden_object_position [ _id ] [ 1 ],
															garden_object_position [ _id ] [ 2 ] ) ) continue ;
																
		    if ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] != INVALID_OBJECT_ID )
			{
				if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] != 1 ) break ;
				
				h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = 0 ;				        
				DestroyDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) ;
				h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = INVALID_OBJECT_ID ;
				
			    UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], col_blue, "** Грядка **\n{"#cGR3D"}Нажмите {"#cWH3D"}ALT{"#cGR3D"} для взаимодействия" ) ;

			    new _h_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ], _random = 2 ;
				        
			    new scm_string [ 106 + 32 + 4 + 4 ] ;
				format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы собрали {"#cGN"}%s{"#cWH"}, количество собранного урожая {"#cGN"}%d шт{"#cWH"}.", seed_info [ _h_seed ] [ s_sell_name ], _random ) ;
				SendClientMessage ( playerid, col_white, scm_string ) ;
				        
			    p_info [ playerid ] [ seed_sell ] [ _h_seed ] = _random ;

				new update_string [ 10 * MAX_SEED_INFO ], sql_string [ sizeof update_string + 70 ] ;
			   	for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
			    {
			   		if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
					else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
				}
			    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed_sell` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
			    mysql_tquery ( sql_connection, sql_string ) ;

				format ( sql_string, sizeof sql_string, "DELETE FROM `houses_garden` WHERE `h_id` = '%d' AND `h_slot` = '%d' LIMIT 1", _h_id, _id ) ;
				mysql_tquery ( sql_connection, sql_string, "", "" ) ;

				ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
				return 1 ;
			}
			else
			{
				global_string [ 0 ] = EOS ;
				new line_string [ 59 + 24 + 4 ], _id_seed = 0 ;
				
				for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
				{
					if ( ! p_info [ playerid ] [ p_seed ] [ i ] ) continue ;
					
					format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, количество: {99cc00}%d {FFFFFF}шт.\n", seed_info [ i ] [ s_name ], p_info [ playerid ] [ p_seed ] [ i ] ) ;
					strcat ( global_string, line_string ) ;
					
					set_player_listitem_values ( playerid, _id_seed, i ) ;

					_id_seed ++ ;
				}
				if ( ! _id_seed ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет семян." ) ;
				show_dialog ( playerid, d_player_garden, DIALOG_STYLE_LIST, "{"#cBHD"}Садовый инвентарь", global_string, "Выбрать", "Закрыть" ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock garden_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_buy_seed:
	    {
	        if ( ! response ) return 1 ;

	        if ( p_info [ playerid ] [ money ] < seed_info [ listitem ] [ s_price ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств." ) ;

			new scm_string [ 93 + 32 + 4 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы приобрели {"#cGInfo"}%s {"#cWH"}(1 шт.) за {"#cGInfo"}%d${"#cWH"}.", seed_info [ listitem ] [ s_name ], seed_info [ listitem ] [ s_price ] ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;

			p_info [ playerid ] [ p_seed ] [ listitem ] ++ ;

		    new update_string [ 10 * MAX_SEED_INFO ], sql_string [ sizeof update_string + 65 ] ;
		    for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
		    {
		        if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
				else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
		    }
		    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
		    mysql_tquery ( sql_connection, sql_string ) ;
			return 1 ;
		}
	    case d_sell_seed:
		{
		    if ( ! response ) return clear_player_listitem_values ( playerid ) ;

		    new list_item = get_player_listitem_values ( playerid, listitem ) ;
		    clear_player_listitem_values ( playerid ) ;

		    new _price = seed_info [ list_item ] [ s_sell_price ] * p_info [ playerid ] [ seed_sell ] [ list_item ] ;
		    
			new scm_string [ 121 + 32 + 4 + 4 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы продали {"#cGInfo"}%s{"#cWH"}, в размере {"#cGInfo"}%d шт.{"#cWH"}, за {"#cGInfo"}%d${"#cWH"}.", seed_info [ list_item ] [ s_sell_name ], p_info [ playerid ] [ seed_sell ] [ list_item ], _price ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;

			p_info [ playerid ] [ seed_sell ] [ list_item ] = 0 ;

			new update_string [ 10 * MAX_SEED_INFO ], sql_string [ sizeof update_string + 70 ] ;
		    for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
		    {
		        if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
				else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
		    }
		    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed_sell` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
		    mysql_tquery ( sql_connection, sql_string ) ;
			return 1 ;
		}
		case d_player_garden:
		{
		    if ( ! response ) return clear_player_listitem_values ( playerid ) ;
		    
		    new list_item = get_player_listitem_values ( playerid, listitem ) ;
		    clear_player_listitem_values ( playerid ) ;
		    
		    create_seed_position ( playerid, list_item ) ;
			return 1 ;
		}
	}
	return 0 ;
}