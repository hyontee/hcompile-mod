#define prison_interior 	20
#define prison_virtualworld 1

#define skin_male			283
#define skin_female			297

new Float: exit_prison_player [ 4 ] = { -1772.3614, -2779.5219, 13.9966, 61.5405 } ;

enum
{
	d_prison_door = 38888
} ;

new Float: prison_zone [ 4 ] = { -1986.3430, -2989.4089, -1477.1774, -2419.8544 } ;
new prison_zone_create ;

new Float: prison_spawn [ 15 ] [ 4 ] =
{
	{ 796.2389, -820.5579, 1502.0048, 93.4155 },
	{ 796.6066, -815.2271, 1502.0048, 78.9689 },
	{ 796.3126, -810.4465, 1502.0048, 88.5142 },
	{ 796.4755, -805.4865, 1502.0168, 89.6516 },
	{ 796.4389, -800.2329, 1502.0180, 90.1119 },
	{ 796.4893, -795.4005, 1502.0192, 87.2947 },
	{ 796.6504, -790.6074, 1502.0207, 78.9410 },
	{ 796.4673, -784.8020, 1502.0218, 94.6844 },
	{ 796.2789, -785.0559, 1505.3935, 90.3485 },
	{ 795.9576, -790.0053, 1505.3929, 89.2170 },
	{ 796.7458, -795.1976, 1505.3890, 101.3824 },
	{ 796.2700, -800.5585, 1505.3884, 74.2092 },
	{ 796.3746, -805.3716, 1505.3885, 97.0087 },
	{ 796.1572, -810.4802, 1505.3883, 98.2004 },
	{ 796.2354, -815.5114, 1505.3883, 93.9815 }
} ;
new prison_spawn_count = sizeof prison_spawn ;

enum _prison_door
{
	door_name [ 24 ],
	door_object_id,
	Float: pdoor_pos [ 6 ],
	door_interior,
	door_vw
} ;

#define MAX_PRISON_DOOR 19
new bool: prison_door_toggled [ MAX_PRISON_DOOR ] = { false, ... } ;
new prison_door_cooldown [ MAX_PRISON_DOOR ] ;
new prison_dooor_object [ MAX_PRISON_DOOR ] ;
new Float: prison_door [ MAX_PRISON_DOOR ] [ _prison_door ] =
{
	{ "Регистратура", 15208, { 790.5913, -853.5228, 1504.2799, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Железные двери #1", 15207, { 788.0096, -845.9285, 1504.1873, 0.0000, 0.0000, 88.1498 }, prison_interior, prison_virtualworld },
	{ "Железные двери #2", 15207, { 788.0634, -835.4782, 1504.2000, 0.0000, 0.0000, 87.5000 }, prison_interior, prison_virtualworld },
	{ "Камера #1", 15206, { 793.8906, -820.0518, 1502.2351, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #2", 15206, { 793.8704, -814.9892, 1502.3052, -0.0499, 0.0000, 0.0499 }, prison_interior, prison_virtualworld },
	{ "Камера #3", 15206, { 793.8566, -809.8868, 1502.3070, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #4", 15206, { 793.8659, -804.8505, 1502.3076, 0.0000, 0.0000, -0.0499 }, prison_interior, prison_virtualworld },
	{ "Камера #5", 15206, { 793.8717, -799.7669, 1502.3126, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #6", 15206, { 793.8721, -794.6632, 1502.3126, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #7", 15206, { 793.8628, -789.5840, 1502.3126, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #8", 15206, { 793.8685, -784.5403, 1502.3126, 0.0000, -0.4499, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #9", 15206, { 793.8664, -784.5333, 1505.6671, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #10", 15206, { 793.8694, -789.5907, 1505.6568, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #11", 15206, { 793.8612, -794.6713, 1505.6667, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #12", 15206, { 793.8661, -799.7652, 1505.6667, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #13", 15206, { 793.8714, -804.8505, 1505.6571, 0.0000, 0.0000, -0.0499 }, prison_interior, prison_virtualworld },
	{ "Камера #14", 15206, { 793.8664, -809.8923, 1505.6567, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Камера #15", 15206, { 793.8602, -814.9856, 1505.6636, 0.0000, 0.0000, 0.0000 }, prison_interior, prison_virtualworld },
	{ "Уличная дверь", 15206, { -1761.8937, -2826.6472, 14.1966, 0.0000, 0.0000, 60.0000 }, 0, 0 }
} ;

new prison_timer = 1200 ;
new end_prison_timer = 0 ;

new convoy_timer = 600 ;

/*

	break

*/

#define MAX_ELECTRIC_PRISON 2
new prison_electric_cooldown [ MAX_ELECTRIC_PRISON ] = { 0, ... } ;
new Text3D: prison_electric_text [ MAX_ELECTRIC_PRISON ] ;
new bool: prison_electric_status [ MAX_ELECTRIC_PRISON ] = { false, ... } ;
new Float: prison_electric_position [ MAX_ELECTRIC_PRISON ] [ 3 ] =
{
	{ -1872.3750, -2859.7199, 13.9966 },
	{ -1741.9998, -2941.1611, 14.0982 }
} ;
new bool: used_key_prison [ MAX_PLAYERS ] ;
new count_offline_electric = 0 ;

stock clear_player_prison ( playerid )
{
	used_key_prison [ playerid ] = false ;
	
	GangZoneShowForPlayer ( playerid, prison_zone_create, 0x000000AA ) ;
	return 1 ;
}

stock prison_EnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_prison:
			{
				new i = area_info [ areaid ] [ a_item ] ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 64, "Дверь '%s' (№%d)", prison_door [ i ] [ door_name ], i + 1 ) ;
				if ( prison_door_toggled [ i ] == true ) send_check_cinfo ( playerid, global_string, 1, -1, CINFO_PRISON_ID, PICTURE_INFO_SUCESS, "Закрыть", "" ) ;
				else send_check_cinfo ( playerid, global_string, 1, -1, CINFO_PRISON_ID, PICTURE_INFO_SUCESS, "Открыть", "" ) ;
				return 1 ;
			}
			case area_type_prison_electric:
			{
				new i = area_info [ areaid ] [ a_item ] ;
				if ( p_info [ playerid ] [ jail ] == 9 && prison_electric_status [ i ] == false )
				{
					send_check_cinfo ( playerid, "Трансформатор. Нажмите для взаимодействия", 1, 5, CINFO_PRISON_ELECTRIC_ID, PICTURE_INFO_SUCESS, "Взломать", "" ) ;
				}
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock prison_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
    {
		case area_type_prison:
		{
			clear_check_info ( playerid, CINFO_PRISON_ID ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock prison_OnGameModeInit ( )
{
	prison_zone_create = GangZoneCreate ( prison_zone [ 0 ], prison_zone [ 1 ], prison_zone [ 2 ], prison_zone [ 3 ] ) ;
	GangZoneShowForAll ( prison_zone_create, 0x000000AA ) ;

	global_string [ 0 ] = EOS ;
	for ( new i = 0 ; i < MAX_PRISON_DOOR ; i ++ )
	{
		format ( global_string, 128, "** %s (№%d) **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"} для взаимодействия", prison_door [ i ] [ door_name ], i + 1 ) ;
		CreateDynamic3DTextLabel ( global_string, col_blue, prison_door [ i ] [ pdoor_pos ] [ 0 ], prison_door [ i ] [ pdoor_pos ] [ 1 ], prison_door [ i ] [ pdoor_pos ] [ 2 ], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, prison_door [ i ] [ door_vw ], prison_door [ i ] [ door_interior ] ) ;
		
		new _area_door = CreateDynamicSphere ( prison_door [ i ] [ pdoor_pos ] [ 0 ], prison_door [ i ] [ pdoor_pos ] [ 1 ], prison_door [ i ] [ pdoor_pos ] [ 2 ], 2.0, -1, -1, -1 ) ;
		area_info [ _area_door ] [ a_type ] = area_type_prison ;
        area_info [ _area_door ] [ a_item ] = i ;
		
		prison_door_toggled [ i ] = false ;
		prison_dooor_object [ i ] = CreateDynamicObject ( prison_door [ i ] [ door_object_id ], prison_door [ i ] [ pdoor_pos ] [ 0 ],
																								prison_door [ i ] [ pdoor_pos ] [ 1 ],
																								prison_door [ i ] [ pdoor_pos ] [ 2 ],
																								prison_door [ i ] [ pdoor_pos ] [ 3 ],
																								prison_door [ i ] [ pdoor_pos ] [ 4 ],
																								prison_door [ i ] [ pdoor_pos ] [ 5 ], 
																								prison_door [ i ] [ door_vw ], prison_door [ i ] [ door_interior ] ) ;
	}
	
	global_string [ 0 ] = EOS ;
	for ( new i = 0 ; i < sizeof prison_electric_position ; i ++ )
	{
		format ( global_string, 128, "** Трансформатор [ {"#cGN3D"}РАБОТАЕТ{"#cBL"} ] **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"} для взаимодействия" ) ;
		prison_electric_text [ i ] = CreateDynamic3DTextLabel ( global_string, col_blue, prison_electric_position [ i ] [ 0 ], prison_electric_position [ i ] [ 1 ], prison_electric_position [ i ] [ 2 ], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0 ) ;
		
		new _area_door = CreateDynamicSphere ( prison_electric_position [ i ] [ 0 ], prison_electric_position [ i ] [ 1 ], prison_electric_position [ i ] [ 2 ], 2.0, -1, -1, -1 ) ;
		area_info [ _area_door ] [ a_type ] = area_type_prison_electric ;
        area_info [ _area_door ] [ a_item ] = i ;
		
		prison_electric_status [ i ] = false ;
	}
	return 1 ;
}

stock prison_OnPlayerSyncDeath ( playerid, killerid )
{
	if ( cop_player ( playerid ) && mafia_player ( killerid ) )
	{
		if ( random ( 10 ) == 1 ) give_inventory ( playerid, 19773, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
	}
	return 1 ;
}

stock show_prison_door ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ] ;
	for ( new i = 0 ; i < MAX_PRISON_DOOR ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s {"#cGRDialog"}(№%d)\t%s\n", prison_door [ i ] [ door_name ], i + 1, ( prison_door_toggled [ i ] ) ? ( "{"#cGN"}Открыта" ) : ( "{"#cRD"}Закрыта" ) ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_prison_door, DIALOG_STYLE_TABLIST, "{"#cBHD"}Тюремные двери", global_string, "Выбрать", "Отмена" ) ;
	return 1 ;
}

stock prison_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_prison_door:
		{
			if ( ! response ) return 1 ;
			
			if ( prison_door_cooldown [ listitem ] > GetTickCount ( ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}С дверью можно взаимодействовать раз в 5 секунд." ) ;
			prison_door_cooldown [ listitem ] = GetTickCount ( ) + 5 ;
			
			new _fraction_id = p_info [ playerid ] [ member ] ;
			if ( prison_door_toggled [ listitem ] == true )
			{
				prison_door_toggled [ listitem ] = false ;
				MoveDynamicObject ( prison_dooor_object [ listitem ], prison_door [ listitem ] [ pdoor_pos ] [ 0 ], 
														prison_door [ listitem ] [ pdoor_pos ] [ 1 ], 
														prison_door [ listitem ] [ pdoor_pos ] [ 2 ], 2.0, 
														prison_door [ listitem ] [ pdoor_pos ] [ 3 ],
														prison_door [ listitem ] [ pdoor_pos ] [ 4 ],
														prison_door [ listitem ] [ pdoor_pos ] [ 5 ] ) ;
														
				static const _str [ ] = "[R] %s %s[%d] закрыл(а) дверь '%s' (№%d)." ;
				new scm_string [ sizeof _str + ( 32 * 2 ) + 24 + ( 4 * 2 ) ] ;
				format ( scm_string, sizeof scm_string, _str, f_rank [ _fraction_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, prison_door [ listitem ] [ door_name ], listitem + 1 ) ;
				fraction_message ( _fraction_id, col_lblue, scm_string ) ;
			}
			else
			{
				prison_door_toggled [ listitem ] = true ;
				
				MoveDynamicObject ( prison_dooor_object [ listitem ], prison_door [ listitem ] [ pdoor_pos ] [ 0 ], 
														prison_door [ listitem ] [ pdoor_pos ] [ 1 ], 
														prison_door [ listitem ] [ pdoor_pos ] [ 2 ] - 6.0, 2.0, 
														prison_door [ listitem ] [ pdoor_pos ] [ 3 ],
														prison_door [ listitem ] [ pdoor_pos ] [ 4 ],
														prison_door [ listitem ] [ pdoor_pos ] [ 5 ] + 0.01 ) ;
														
				static const _str [ ] = "[R] %s %s[%d] открыл(а) дверь '%s' (№%d)." ;
				new scm_string [ sizeof _str + ( 32 * 2 ) + 24 + ( 4 * 2 ) ] ;
				format ( scm_string, sizeof scm_string, _str, f_rank [ _fraction_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, prison_door [ listitem ] [ door_name ], listitem + 1 ) ;
				fraction_message ( _fraction_id, col_lblue, scm_string ) ;
			}
			
			show_prison_door ( playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock prison_player_timer ( playerid )
{
	if ( p_info [ playerid ] [ jail ] == 9 && p_info [ playerid ] [ jailed ] > 0 )
	{
		if ( ! IsPlayerInGangZone ( playerid, prison_zone_create ) && GetPlayerInterior ( playerid ) != prison_interior )
		{
			if ( count_offline_electric >= MAX_ELECTRIC_PRISON )
			{
				p_info [ playerid ] [ jail ] =
				p_info [ playerid ] [ jailed ] = 0 ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно совершили побег из тюрьмы!" ) ;
				fraction_duty ( playerid ) ;
			}
			else
			{
				SpawnPlayer ( playerid ) ;
				p_info [ playerid ] [ jailed ] += 600 ;
				
				SendClientMessage ( playerid, col_red, !"* За попытку несанкционированного побега Ваш срок увеличен!" ) ;
				
				static const _str [ ] = "[R] %s пытался совершить побег. Система безопасности предотвратила побег!" ;
				new scm_string [ sizeof _str + MAX_PLAYER_NAME ] ;
				format ( scm_string, sizeof scm_string, _str, p_info [ playerid ] [ name ] ) ;
				fraction_message ( 12, col_lblue, scm_string ) ;
			}
		}
	}
	return 1 ;
}

stock prison_second_timer ( )
{
	for ( new i = 0 ; i < MAX_ELECTRIC_PRISON ; i ++ )
	{
		if ( prison_electric_cooldown [ i ] > 0 )
		{
			prison_electric_cooldown [ i ] -- ;
			if ( prison_electric_cooldown [ i ] == 1 )
			{
				prison_electric_status [ i ] = false ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "** Трансформатор [ {"#cGN3D"}РАБОТАЕТ{"#cBL"} ] **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"} для взаимодействия" ) ;
				UpdateDynamic3DTextLabelText ( prison_electric_text [ i ], col_blue, global_string ) ;
				
				fraction_message ( 12, col_lblue, "[R] Один из трансформаторов восстановил свою работу." ) ;
				count_offline_electric -- ;
			}
		}
	}
	
	if ( prison_timer > 0 )
	{
		prison_timer -- ;
		if ( prison_timer == 600 )
		{
			foreach(new i: logged_players)
			{
				if ( GetPlayerInterior ( i ) != prison_interior || GetPlayerVirtualWorld ( i ) != prison_virtualworld ) continue ;
				
				SendClientMessage ( i, 0xB7C956FF, !"* До прогулки осталось 10 минут!" ) ;
			}
		}
		else if ( prison_timer == 1 )
		{
			prison_timer = 0 ;
			end_prison_timer = 1200 ;
			for ( new i = 3 ; i < 17 ; i ++ )
			{
				if ( prison_door_toggled [ i ] == false )
				{
					prison_door_toggled [ i ] = true ;
					
					MoveDynamicObject ( prison_dooor_object [ i ], prison_door [ i ] [ pdoor_pos ] [ 0 ],
															prison_door [ i ] [ pdoor_pos ] [ 1 ],
															prison_door [ i ] [ pdoor_pos ] [ 2 ] - 6.0, 2.0,
															prison_door [ i ] [ pdoor_pos ] [ 3 ],
															prison_door [ i ] [ pdoor_pos ] [ 4 ],
															prison_door [ i ] [ pdoor_pos ] [ 5 ] + 0.01 ) ;
				}
			}
		}
	}
	
	if ( end_prison_timer > 0 )
	{
		end_prison_timer -- ;
		if ( end_prison_timer == 600 )
		{
			foreach(new i: logged_players)
			{
				if ( GetPlayerInterior ( i ) != prison_interior || GetPlayerVirtualWorld ( i ) != prison_virtualworld ) continue ;
				
				SendClientMessage ( i, 0xB7C956FF, !"* До конца прогулки осталось 10 минут!" ) ;
			}
		}
		else if ( end_prison_timer == 1 )
		{
			prison_timer = 1200 ;
			end_prison_timer = 0 ;
			for ( new i = 3 ; i < 17 ; i ++ )
			{
				if ( prison_door_toggled [ i ] == true )
				{
					prison_door_toggled [ i ] = false ;
					
					MoveDynamicObject ( prison_dooor_object [ i ], prison_door [ i ] [ pdoor_pos ] [ 0 ], 
															prison_door [ i ] [ pdoor_pos ] [ 1 ],
															prison_door [ i ] [ pdoor_pos ] [ 2 ], 2.0,
															prison_door [ i ] [ pdoor_pos ] [ 3 ],
															prison_door [ i ] [ pdoor_pos ] [ 4 ],
															prison_door [ i ] [ pdoor_pos ] [ 5 ] ) ;
				}
			}
		}
	}
	
	if ( convoy_timer > 0 )
	{
		convoy_timer -- ;
		if ( convoy_timer == 300 )
		{
			new _count_player = 0 ;
			foreach(new i: logged_players)
			{
				if ( 4 > p_info [ i ] [ jail ] > 0 )
				{
					SendClientMessage ( i, 0xB7C956FF, !"* До конвоирования в исправительную колонию осталось 5 минут!" ) ;
					_count_player ++ ;
				}
			}
			
			if ( _count_player > 0 )
			{
				static const _str [ ] = "[R] До конвоирования новых заключённых осталось 5 минут! Ожидают конвоирования: %d чел." ;
				new scm_string [ sizeof _str + 9 ] ;
				format ( scm_string, sizeof scm_string, _str, _count_player ) ;
				fraction_message ( 4, col_lblue, scm_string ) ;
				fraction_message ( 5, col_lblue, scm_string ) ;
				fraction_message ( 12, col_lblue, scm_string ) ;
			}
		}
		else if ( convoy_timer == 1 )
		{
			new _count_player = 0 ;
			foreach(new i: logged_players)
			{
				if ( 4 > p_info [ i ] [ jail ] > 0 )
				{
					p_info [ i ] [ jail ] = 9 ;
					update_int_sql ( i, "u_jail", 9 ) ;
					SpawnPlayer ( i ) ;
					
					SendClientMessage ( i, 0xB7C956FF, !"* Вы были перенаправлены в исправительную колонию!" ) ;
					_count_player ++ ;
				}
			}
			
			if ( _count_player > 0 )
			{
				static const _str [ ] = "[R] В исправительную колонию было перенаправлено %d чел." ;
				new scm_string [ sizeof _str + 9 ] ;
				format ( scm_string, sizeof scm_string, _str, _count_player ) ;
				fraction_message ( 4, col_lblue, scm_string ) ;
				fraction_message ( 5, col_lblue, scm_string ) ;
				fraction_message ( 12, col_lblue, scm_string ) ;
			}
			
			convoy_timer = 600 ;
		}
	}
	return 1 ;
}

stock prison_KeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused oldkeys
	if ( newkeys & KEY_CTRL_BACK )
	{
		new _areaid = used_area [ playerid ] ;
		if ( _areaid != -1 && area_info [ _areaid ] [ a_type ] == area_type_prison )
		{
			if ( ! prison_player ( playerid ) && used_key_prison [ playerid ] == false )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет ключа от дверей!" ) ;
			
			new i = area_info [ _areaid ] [ a_item ],
				_fraction_id = p_info [ playerid ] [ member ] ;
				
			if ( prison_door_cooldown [ i ] > GetTickCount ( ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}С дверью можно взаимодействовать раз в 5 секунд." ) ;
			prison_door_cooldown [ i ] = GetTickCount ( ) + 5 ;
			
			if ( prison_door_toggled [ i ] == true )
			{
				prison_door_toggled [ i ] = false ;
				MoveDynamicObject ( prison_dooor_object [ i ], prison_door [ i ] [ pdoor_pos ] [ 0 ], 
														prison_door [ i ] [ pdoor_pos ] [ 1 ], 
														prison_door [ i ] [ pdoor_pos ] [ 2 ], 2.0, 
														prison_door [ i ] [ pdoor_pos ] [ 3 ],
														prison_door [ i ] [ pdoor_pos ] [ 4 ],
														prison_door [ i ] [ pdoor_pos ] [ 5 ] ) ;
														
				static const _str [ ] = "[R] %s %s[%d] закрыл(а) дверь '%s' (№%d)." ;
				new scm_string [ sizeof _str + ( 32 * 2 ) + 24 + ( 4 * 2 ) ] ;
				format ( scm_string, sizeof scm_string, _str, f_rank [ _fraction_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, prison_door [ i ] [ door_name ], i + 1 ) ;
				fraction_message ( _fraction_id, col_lblue, scm_string ) ;
			}
			else
			{
				prison_door_toggled [ i ] = true ;
				
				MoveDynamicObject ( prison_dooor_object [ i ], prison_door [ i ] [ pdoor_pos ] [ 0 ], 
														prison_door [ i ] [ pdoor_pos ] [ 1 ], 
														prison_door [ i ] [ pdoor_pos ] [ 2 ] - 6.0, 2.0, 
														prison_door [ i ] [ pdoor_pos ] [ 3 ],
														prison_door [ i ] [ pdoor_pos ] [ 4 ],
														prison_door [ i ] [ pdoor_pos ] [ 5 ] + 0.01 ) ;
														
				static const _str [ ] = "[R] %s %s[%d] открыл(а) дверь '%s' (№%d)." ;
				new scm_string [ sizeof _str + ( 32 * 2 ) + 24 + ( 4 * 2 ) ] ;
				format ( scm_string, sizeof scm_string, _str, f_rank [ _fraction_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, prison_door [ i ] [ door_name ], i + 1 ) ;
				fraction_message ( _fraction_id, col_lblue, scm_string ) ;
			}
			return 1 ;
		}
		else if ( _areaid != -1 && area_info [ _areaid ] [ a_type ] == area_type_prison_electric )
		{
			if( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2161 ) < 1 ) 
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас нету отмычек." ) ;
			
			action_type { playerid } = ACTION_PRISON_ELECTRIC ;
			actionShow ( playerid, "Взлом электрощитовой", 100 ) ;
			
			clear_inventory ( playerid, 2162, 1 ) ;
			toggle_controlable ( playerid, false ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock check_electric_status ( playerid )
{
	toggle_controlable ( playerid, true ) ;
	
	new _areaid = used_area [ playerid ] ;
	if ( _areaid < 1 ) return 1 ;
	
	new i = area_info [ _areaid ] [ a_item ] ;
	prison_electric_status [ i ] = true ;
	prison_electric_cooldown [ i ] = 600 ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "** Трансформатор [ {"#cRD3D"}НЕ РАБОТАЕТ{"#cBL"} ] **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"} для взаимодействия" ) ;
	UpdateDynamic3DTextLabelText ( prison_electric_text [ i ], col_blue, global_string ) ;
	
	fraction_message ( 12, col_lblue, "[R] Один из трансформаторов был отключен." ) ;
	count_offline_electric ++ ;
	
	new scm_string [ 100 + 4 ] ;
	format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы отключи трансформатор. Осталось отключить для побега: {"#cGN"}%d{"#cWH"}.", MAX_ELECTRIC_PRISON - count_offline_electric ) ;
	SendClientMessage ( playerid, col_white, scm_string ) ;
	SendClientMessage ( playerid, col_white, "{"#cGInfo"}* {"#cWH"}Через 10 минут трансформатор снова возобновит свою работу." ) ;
	return 1 ;
}