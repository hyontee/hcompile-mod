#define MAX_TREASURE 100

enum _treasure
{
	te_id,
	Float: te_pos [ 3 ],
	te_object [ 2 ],
	te_area,
	te_area_card,
	bool: te_status
} ;
new te_info [ MAX_TREASURE ] [ _treasure ] ;

new te_count = 0 ;

static garage_skin [ 14 ] [ 2 ] =
{
	{ 1, 0 },
	{ 2, 0 }, 
	{ 4, 0 }, 
	{ 6, 0 }, 
	{ 7, 0 }, 
	{ 9, 1 }, 
	{ 11, 1 },
	{ 17, 0 }, 
	{ 18, 0 }, 
	{ 19, 0 },
	{ 21, 0 },
	{ 92, 0 },
	{ 94, 0 },
	{ 95, 0 }
} ;

static garage_car [ 3 ] =
{
	400, 491, 502
} ;

static treasure_zone [ MAX_PLAYERS ] ;

stock tr_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `treasure` ORDER BY `treasure`.`te_id` ASC", "treasures_loading" ) ;
	return 1 ;
}

callback: treasures_loading ( )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( te_count, fields ) ;
	if ( te_count )
	{
		for ( new i = 0 ; i < te_count ; i ++ )
		{
			te_info [ i ] [ te_id ] = cache_get_field_content_int ( i, "te_id", sql_connection ) ;

			te_info [ i ] [ te_pos ] [ 0 ] = cache_get_field_content_float ( i,"te_pos_x", sql_connection ) ;
			te_info [ i ] [ te_pos ] [ 1 ] = cache_get_field_content_float ( i,"te_pos_y", sql_connection ) ;
			te_info [ i ] [ te_pos ] [ 2 ] = cache_get_field_content_float ( i,"te_pos_z", sql_connection ) ;
			
			te_info [ i ] [ te_status ] = false ; 
		}
		
		reset_treasure ( ) ;
    }
	printf ( "[SERVER] Загружено %d кладов. (%d ms)", te_count, GetTickCount ( ) - time ) ;
	return 1 ;
}

stock tr_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_treasure:
		{
			if ( GetPlayerState ( playerid ) != PLAYER_STATE_ONFOOT ) return 1 ;
			if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Администрации нельзя откапывать клады." ) ;
			
			if ( player_device { playerid } == 2 ) send_check_cinfo ( playerid, "Вы нашли клад! Осталось только раскопать", 1, -1, CINFO_TREASURE_ID, PICTURE_INFO_SUCESS, "Раскопать", "" ) ;
			else GameTextForPlayer ( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~g~ PRESS: ~r~Y", 3000, 3 ) ;
			return 1 ;
		}
		case area_type_treasure_card:
		{
			if ( ! p_info [ playerid ] [ treasure_card ] ) return 1 ;
			
			if ( player_device { playerid } == 2 ) send_check_cinfo ( playerid, "Вы находитесь не далеко от клада!", 0, 5, CINFO_TREASURE_CARD, PICTURE_INFO_SUCESS, "", "" ) ;
			else SendClientMessage ( playerid, col_white, "{"#cGInfo"}* {"#cWH"}Вы находитесь не далеко от клада!" ) ;
			
			if ( treasure_zone [ playerid ] == -1 && p_info [ playerid ] [ crime_plus ] )
			{
				if ( treasure_zone [ playerid ] != -1 )
				{
					GangZoneHideForPlayer ( playerid, treasure_zone [ playerid ] ) ;
					GangZoneDestroy ( treasure_zone [ playerid ] ) ;
					treasure_zone [ playerid ] = -1 ;
				}
				
				new _item = area_info [ areaid ] [ a_item ], Float: _mw_quad [ 4 ] ;
				get_gz_pos ( te_info [ _item ] [ te_pos ] [ 0 ]-float(-random(50)+random(50)), te_info [ _item ] [ te_pos ] [ 1 ]-float(-random(50)+random(50)), 80.0, _mw_quad [ 0 ], _mw_quad [ 1 ], _mw_quad [ 2 ], _mw_quad [ 3 ] ) ;
				treasure_zone [ playerid ] = GangZoneCreate ( _mw_quad [ 0 ], _mw_quad [ 1 ], _mw_quad [ 2 ], _mw_quad [ 3 ] ) ;
			
				GangZoneShowForPlayer ( playerid, treasure_zone [ playerid ], 0x000000AA ) ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock tr_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_treasure:
		{
			clear_check_info ( playerid, CINFO_TREASURE_ID ) ;
			return 1 ;
		}
		case area_type_treasure_card:
		{
			if ( treasure_zone [ playerid ] == -1 ) return 1 ;
				
			GangZoneHideForPlayer ( playerid, treasure_zone [ playerid ] ) ;
			GangZoneDestroy ( treasure_zone [ playerid ] ) ;
			treasure_zone [ playerid ] = -1 ;
			
			clear_check_info ( playerid, CINFO_TREASURE_CARD ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock clear_player_treasure ( playerid )
{
	treasure_zone [ playerid ] = -1 ;
	return 1 ;
}

stock tr_OnPlayerDisconnect ( playerid )
{
	if ( treasure_zone [ playerid ] != -1 )
	{
		GangZoneHideForPlayer ( playerid, treasure_zone [ playerid ] ) ;
		GangZoneDestroy ( treasure_zone [ playerid ] ) ;
		treasure_zone [ playerid ] = -1 ;
	}
	return 1 ;
}

stock reset_treasure ( )
{
	new _tr_count = 0 ;
	
	for ( new i = 0 ; i < te_count ; i ++ )
	{
		if ( te_info [ i ] [ te_status ] ) _tr_count ++ ;
	}

	if ( _tr_count < 15 )
	{
		for ( new i = 0 ; i < te_count ; i++ )
		{
			if ( IsValidDynamicObject ( te_info [ i ] [ te_object ] [ 0 ] ) ) DestroyDynamicObject ( te_info [ i ] [ te_object ] [ 0 ] ) ;
			if ( IsValidDynamicObject ( te_info [ i ] [ te_object ] [ 1 ] ) ) DestroyDynamicObject ( te_info [ i ] [ te_object ] [ 1 ] ) ;
			if ( IsValidDynamicArea ( te_info [ i ] [ te_area ] ) ) DestroyDynamicArea ( te_info [ i ] [ te_area ] ) ;
			if ( IsValidDynamicArea ( te_info [ i ] [ te_area_card ] ) ) DestroyDynamicArea ( te_info [ i ] [ te_area_card ] ) ;
				
			te_info [ i ] [ te_status ] = false ;
		}
	
		for ( new i = 0 ; i < 15 ; i ++ )
		{
			treasure_spawn ( ) ;
		}
	}
	return 1 ;
}

stock treasure_spawn ( )
{
	new _random = 0, _count = 0 ;
	do
	{
		_random = random ( te_count ) ;
		_count ++ ;
	}
	while ( te_info [ _random ] [ te_status ] == true && _count < 10 ) ;
		
	if ( te_info [ _random ] [ te_status ] )
	{
		for ( new i = 0 ; i < te_count ; i ++ )
		{
			if ( te_info [ i ] [ te_status ] == true ) continue ;
			
			_random = i ;
			break ;
		}
	}
	
	te_info [ _random ] [ te_object ] [ 0 ] = CreateDynamicObject ( 11713, te_info [ _random ] [ te_pos ] [ 0 ], te_info [ _random ] [ te_pos ] [ 1 ], te_info [ _random ] [ te_pos ] [ 2 ], 0.0, -90.0, 0.0, 0, 0 ) ;
	te_info [ _random ] [ te_object ] [ 1 ] = CreateDynamicObject ( 16305, te_info [ _random ] [ te_pos ] [ 0 ], te_info [ _random ] [ te_pos ] [ 1 ], te_info [ _random ] [ te_pos ] [ 2 ] + random ( 2 ) + 0.5, 0.0, 0.0, 0.0, 0, 0 ) ;
	
	te_info [ _random ] [ te_area ] = CreateDynamicSphere ( te_info [ _random ] [ te_pos ] [ 0 ], te_info [ _random ] [ te_pos ] [ 1 ], te_info [ _random ] [ te_pos ] [ 2 ], 5.0, 0, 0, -1 ) ;
	new _te_area = te_info [ _random ] [ te_area ] ;
	area_info [ _te_area ] [ a_type ] = area_type_treasure ;
	area_info [ _te_area ] [ a_item ] = _random ;
	
	te_info [ _random ] [ te_area_card ] = CreateDynamicSphere ( te_info [ _random ] [ te_pos ] [ 0 ], te_info [ _random ] [ te_pos ] [ 1 ], te_info [ _random ] [ te_pos ] [ 2 ], 100.0, 0, 0, -1 ) ;
	_te_area = te_info [ _random ] [ te_area_card ] ;
	area_info [ _te_area ] [ a_type ] = area_type_treasure_card ;
	area_info [ _te_area ] [ a_item ] = _random ;
	
	te_info [ _random ] [ te_status ] = true ;
	return 1 ;
}

stock tr_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused newkeys
	#pragma unused oldkeys
	if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_treasure )
	{
		new i = area_info [ used_area [ playerid ] ] [ a_item ] ;
			
		if ( IsValidDynamicObject ( te_info [ i ] [ te_object ] [ 1 ] ) )
		{
			if ( GetPlayerWeapon ( playerid ) != 6 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет лопаты, приобретите её в магазине 24/7." ) ;
			
			ApplyAnimation ( playerid, "BASEBALL","Bat_4", 4.1, 1, 0, 0, 1, 11000 ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
					
			job_timer [ playerid ] = SetTimerEx ( "treasure_timer", 5800, false, "ii", playerid, i ) ;
		}
		else open_treasure ( playerid, i ) ;
		return 1 ;
	}
	return 0 ;
}

stock open_treasure ( playerid, i )
{
	if ( IsValidDynamicObject ( te_info [ i ] [ te_object ] [ 0 ] ) ) DestroyDynamicObject ( te_info [ i ] [ te_object ] [ 0 ] ) ;
	if ( IsValidDynamicArea ( te_info [ i ] [ te_area ] ) ) DestroyDynamicArea ( te_info [ i ] [ te_area ] ) ;
	if ( IsValidDynamicArea ( te_info [ i ] [ te_area_card ] ) ) DestroyDynamicArea ( te_info [ i ] [ te_area_card ] ) ;

	te_info [ i ] [ te_status ] = false ;

	treasure_spawn ( ) ;

	new donate_count = random ( 150000 ), random_item, random_random = -1 ;
	if ( donate_count >= 0 && donate_count <= 25000 )random_item = 0 ;
	else if ( donate_count >= 25001 && donate_count <= 45000 )random_item = 1 ;
	else if ( donate_count >= 45001 && donate_count <= 55000 )random_item = 2 ;
	else if ( donate_count >= 55001 && donate_count <= 65000 )random_item = 3 ;
	else if ( donate_count >= 65001 && donate_count <= 70000 )random_item = 4 ;
	else if ( donate_count >= 70001 && donate_count <= 75000 )random_item = 5 ;
	else if ( donate_count >= 75001 && donate_count <= 80000 )random_item = 6 ;
	else if ( donate_count >= 80001 && donate_count <= 85000 )random_item = 7 ;
	else if ( donate_count >= 85001 && donate_count <= 95000 )random_item = 8 ;
	else if ( donate_count >= 95001 && donate_count <= 100000 )random_item = 9 ;
	else if ( donate_count >= 100001 && donate_count <= 110000 )random_item = 10 ;
	else if ( donate_count >= 110001 && donate_count <= 115000 )random_item = 11 ;
	else if ( donate_count >= 115001 && donate_count <= 118000 )random_item = 12 ;
	else if ( donate_count >= 118001 && donate_count <= 121000 )random_item = 13 ;
	else if ( donate_count >= 121001 && donate_count <= 124000 )random_item = 14 ;
	else if ( donate_count >= 124001 && donate_count <= 127000 )random_item = 15 ;
	else if ( donate_count >= 127001 && donate_count <= 130000 )random_item = 16 ;
	else if ( donate_count >= 130001 && donate_count <= 140000 )random_item = 17 ;
	else if ( donate_count >= 140001 && donate_count <= 142000 )random_item = 18 ;
	else if ( donate_count >= 142001 && donate_count <= 144000 )random_item = 19 ;
	else if ( donate_count >= 144001 && donate_count <= 146000 )random_item = 20 ;
	else if ( donate_count >= 146001 && donate_count <= 150000 )random_item = 21 ;
	
	switch ( random_item )
	{
		case 0:
		{
			new _money = random ( 10000 ) + 10000 ;
            give_money ( playerid, _money ) ;
            insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "взял из багажника" ) ;
		}
		case 1: give_inventory ( playerid, 2000, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 0 ;
		case 2: give_inventory ( playerid, 2001, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1 ;
		case 3: give_inventory ( playerid, 2002, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 2 ;
		case 4: give_inventory ( playerid, 2003, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 3 ;
		case 5: give_inventory ( playerid, 2035, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 35 ;
		case 6: give_inventory ( playerid, 2036, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 36 ;
		case 7: give_inventory ( playerid, 2037, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 37 ;
		case 8: give_inventory ( playerid, 905, random ( 10 ) + 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 905 ;
		case 9: give_inventory ( playerid, 19941, random ( 3 ) + 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 19941 ;
		case 10: give_inventory ( playerid, 1463, random ( 10 ) + 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1463 ;
		case 11: give_inventory ( playerid, 2684, random ( 3 ) + 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 2684 ;
		case 12: give_inventory ( playerid, 1080, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1080 ;
		case 13: give_inventory ( playerid, 1018, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1018 ;
		case 14: give_inventory ( playerid, 1038, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1038 ;
		case 15: give_inventory ( playerid, 1140, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1140 ;
		case 16: give_inventory ( playerid, 1165, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 1165 ;
		case 17: give_inventory ( playerid, 19773, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 19773 ;
		case 18: give_inventory ( playerid, 2045, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 45 ;
		case 19: give_inventory ( playerid, 2055, 1, 00, "", "", NUMBERPLATE_TYPE_NONE, 0 ), random_random = 55 ;
		case 20:
		{
			new _random = random ( sizeof garage_skin ) ;
			random_random = garage_skin [ _random ] [ 0 ] ;
			give_inventory ( playerid, random_random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		}
		case 21:
		{
			new _random = random ( sizeof garage_car ) ;
			random_random = garage_car [ _random ] ;
			give_inventory ( playerid, random_random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		}
	}
	
	p_t_info [ playerid ] [ treasure_open ] ++ ;
	
	if ( random_random != -1 )
	{
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "* Вы откопали клад! '%s' добавлен Вам в инвентарь.", item_name ( random_random ) ) ;
		SendClientMessage ( playerid, col_purple, query_string ) ;

		format(query_string, sizeof query_string, "{"#cRD"}* WARNING %s открыл(а) %d клад(ов) за сессию (в игре уже: %s). Приз: %s", p_info [ playerid ] [ name ], p_t_info [ playerid ] [ treasure_open ], convert_time ( p_info [ playerid ] [ time_hour ], TYPE_TIME_SECOND ), item_name ( random_random ) ) ;
		foreach(new q: admin_players) SendClientMessage ( q, col_gray, query_string ) ;

		format(query_string, sizeof query_string, "%s открыл(а) клад. Приз: %s", p_info [ playerid ] [ name ], item_name ( random_random ) ) ;
		WriteLog(playerid, TYPE_LOG_TREASURE, query_string);
	}
	
	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cWH"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cWH"}." ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cWH"}Используйте {"#cBL"}\"/teinfo\"{"#cWH"} для просмотра ВОЗМОЖНЫХ призов с клада." ) ;

	give_event_progress ( playerid, THE_TREASURE, 1 ) ;
	checking_quest_progress ( playerid, 7, 1, quest_line_high ) ;
	return 1 ;
}

CMD:teinfo ( playerid )
{
	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Возможные призы:\n\n" ) ;
	
	new line_string [ 100 ] ;
	for ( new i = 0 ; i < sizeof garage_skin ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s (#%d).\n", get_skin_name ( garage_skin [ i ] [ 0 ] ), garage_skin [ i ] [ 0 ] ) ;
		strcat ( global_string, line_string ) ;
	}
	for ( new i = 0 ; i < sizeof garage_car ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s.\n", GetVehicleNameEx ( INVALID_VEHICLE_ID, garage_car [ i ] ) ) ;
		strcat ( global_string, line_string ) ;
	}
	strcat ( global_string, "{"#cGRDialog"}- {"#cWH"}Донат поинты.\n" ) ;
	strcat ( global_string, "{"#cGRDialog"}- {"#cWH"}Семейные талоны.\n" ) ;
	strcat ( global_string, "{"#cGRDialog"}- {"#cWH"}VIP на несколько дней.\n" ) ;
	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Клады", global_string, "Принять", "" ) ;
	return 1 ;
}

callback: treasure_timer ( playerid, _te_id )
{
	KillTimer ( job_timer [ playerid ] ) ;
	job_timer [ playerid ] = -1 ;
	
	if ( p_t_info [ playerid ] [ shovel_count ] ) p_t_info [ playerid ] [ shovel_count ] -= 1 ;
	if ( ! p_t_info [ playerid ] [ shovel_count ] )
	{
		RemoveWeaponFromSlot ( playerid, get_weapon_slot ( 6 ) ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Лопата сломалась, приобретите её в магазине 24/7.");
	}
	
	p_t_info [ playerid ] [ p_animation ] = false ;
	ClearAnimations ( playerid, 1 ) ;
	
	if ( IsValidDynamicObject ( te_info [ _te_id ] [ te_object ] [ 1 ] ) ) DestroyDynamicObject ( te_info [ _te_id ] [ te_object ] [ 1 ] ) ;
	
	if ( player_device { playerid } == 2 ) send_check_cinfo ( playerid, "Клад можно забрать", 1, -1, CINFO_TREASURE_ID, PICTURE_INFO_SUCESS, "Забрать", "" ) ;
	else GameTextForPlayer ( playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~g~ PRESS: ~r~Y", 3000, 3 ) ;
	return 1 ;
}

CMD:treasure ( playerid, params [ ] )
{
    if ( admin_info [ playerid ] [ admin ] < 8 )return 1 ;

    page_count [ playerid ] = 1 ;
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = te_count ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count = 1 ; // 1 - потому что есть первая строка в виде strcat
	strcat ( global_string, "{"#cBL"}Создать клад\n" ) ;
	for ( new i = rows_list * 10 ; i < rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= te_count ) break ;
		
		set_player_listitem_values ( playerid, i - rows_list * 10, i ) ;

		format ( line_string, sizeof ( line_string ), "{"#cWH"}Клад №%d\n", te_info [ i ] [ te_id ] ) ;
		strcat ( global_string, line_string ) ;
			
		row_count ++ ;
	}
		
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
		
	show_dialog(playerid, d_treasure, DIALOG_STYLE_LIST, "{"#cBHD"}Клады", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_treasure ( playerid )
{
    new rows_list = page_count [ playerid ] - 1 ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count = 1 ; // 1 - потому что есть первая строка в виде strcat
	strcat ( global_string, "{"#cBL"}Создать клад\n" ) ;
	for ( new i = rows_list * 10 ; i < rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= te_count ) break ;
	
		set_player_listitem_values ( playerid, i - rows_list * 10, i ) ;

		format ( line_string, sizeof ( line_string ), "{"#cWH"}Клад №%d\n", te_info [ i ] [ te_id ] ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_treasure, DIALOG_STYLE_LIST, "{"#cBHD"}Клады", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock tr_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_treasure:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				return 1 ;
			}
			
			if ( listitem == 0 )
			{
				new _treasure_object = CreateDynamicObject ( 11713, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], 0.0, -90.0, 0.0, 0, 0, -1, 300.0, 300.0 ) ;

				create_type { playerid } = 8 ;
				create_object_id [ playerid ] = _treasure_object ;
				EditDynamicObject ( playerid, _treasure_object ) ;
				return 1 ;
			}
			
			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
				if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка кладов." ) ;
					page_count [ playerid ] = page_count [ playerid ] ;

					show_treasure ( playerid ) ;
					return 1 ;
				}
				page_count [ playerid ] -= 1 ;

				show_treasure ( playerid ) ;
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
				if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка кладов." ) ;
					page_count [ playerid ] = page_count [ playerid ] ;

					show_treasure ( playerid ) ;
					return 1 ;
				}
				page_count [ playerid ] += 1 ;
	  
				show_treasure ( playerid ) ;
				return 1 ;
			}
			
			new select_id = get_player_listitem_values ( playerid, listitem - 1 ) ;
			SetPVarInt ( playerid, "a_id_select", select_id ) ;

			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "{"#cBHD"}Клад №%d", te_info [ select_id ] [ te_id ] ) ;

			show_dialog(playerid, d_treasure_select, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1. {"#cWH"}Телепортироваться\n{"#cBL"}2. {"#cWH"}Изменить позицию", "Выбрать", "Закрыть" ) ;

			clear_player_listitem_values ( playerid ) ;
			page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
			return 1 ;
		}
		case d_treasure_select:
		{
			if ( ! response ) return DeletePVar ( playerid, "a_id_select" ) ;
			
			switch ( listitem )
			{
				case 0:
				{
					new select_id = GetPVarInt ( playerid, "a_id_select" ) ;
					DeletePVar ( playerid, "a_id_select" ) ;
					
					set_pos ( playerid, te_info [ select_id ] [ te_pos ] [ 0 ], te_info [ select_id ] [ te_pos ] [ 1 ], te_info [ select_id ] [ te_pos ] [ 2 ] + 1.0, 0.0, 0, 0 ) ;
				}
				case 1:
				{
					if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) &&
						! GetString ( p_info [ playerid ] [ name ], founder_name_2 ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вам данная функция не доступна." ) ;

					new _treasure_object = CreateDynamicObject ( 11713, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], 0.0, -90.0, 0.0, 0, 0, -1, 300.0, 300.0 ) ;

					create_type { playerid } = 9 ;
					create_object_id [ playerid ] = _treasure_object ;
					EditDynamicObject ( playerid, _treasure_object ) ;
				}
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock tr_OnPlayerEditDynamicObject ( playerid, response, Float:x, Float:y, Float:z )
{
	if ( player_device { playerid } != 2 && response == EDIT_RESPONSE_FINAL || player_device { playerid } == 2 && response == 1 )
	{
		if ( create_type { playerid } == 8 )
		{
			te_info [ te_count ] [ te_pos ] [ 0 ] = x ;
			te_info [ te_count ] [ te_pos ] [ 1 ] = y ;
			te_info [ te_count ] [ te_pos ] [ 2 ] = z ;
			
			te_info [ te_count ] [ te_status ] = false ;
			
			te_info [ te_count ] [ te_id ] = te_count + 1 ;
			
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			
			te_count ++ ;
			
			new _sql_string [ 128 ] ;
			format ( _sql_string, sizeof _sql_string, "INSERT INTO `treasure` (`te_pos_x`,`te_pos_y`,`te_pos_z`) VALUES ('%f','%f','%f')",
			x, y, z ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;
			return 1 ;
		}
		if ( create_type { playerid } == 9 )
		{
			new select_id = GetPVarInt ( playerid, "a_id_select" ) ;
			DeletePVar ( playerid, "a_id_select" ) ;
			
			te_info [ select_id ] [ te_pos ] [ 0 ] = x ;
			te_info [ select_id ] [ te_pos ] [ 1 ] = y ;
			te_info [ select_id ] [ te_pos ] [ 2 ] = z ;
			
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			
			new _sql_string [ 144 ] ;
			format ( _sql_string, sizeof _sql_string, "UPDATE `treasure` SET `te_pos_x` = '%f', `te_pos_y` = '%f', `te_pos_z` = '%f' WHERE `te_id` = '%d' LIMIT 1",
			x, y, z, te_info [ select_id ] [ te_id ] ) ;
			mysql_tquery ( sql_connection, _sql_string, "", "" ) ;
			return 1 ;
		}
	}
	if ( player_device { playerid } != 2 && response == EDIT_RESPONSE_CANCEL || player_device { playerid } == 2 && response == 2 )
	{
		if ( create_type { playerid } == 8 )
	    {
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			CancelEdit(playerid);
			return 1 ;
		}
	
		if ( create_type { playerid } == 9 )
	    {
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			CancelEdit(playerid);
			
			DeletePVar ( playerid, "a_id_select" ) ;
			return 1 ;
		}
	}
	return 0 ;
}