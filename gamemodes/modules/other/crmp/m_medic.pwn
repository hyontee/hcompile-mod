#define medic_pay_km 500
#define MAX_MEDIC_PAY 250000

const MAX_MEDIC_ACTOR = 8 ;
new Float: actor_medic_position [ MAX_MEDIC_ACTOR ] [ 4 ] =
{
	{ 2478.2102, -2607.3979, 23.2998, 75.7556 },
	{ 2419.8154, -2102.6218, 21.9727, 80.0496 },
	{ -2292.1030, 29.9446, 24.7360, 274.5664 },
	{ -2577.9230, 2857.4423, 37.6348, 326.8321 },
	{ 1761.8894, 2060.2343, 15.9660, 289.7435 },
	{ 478.4164, 421.6350, 11.8971, 183.5314 },
	{ 602.6395, 1038.2907, 12.2660, 251.1240 },
	{ -203.3299, 943.7864, 12.1401, 334.6927 }
} ;

new bool: actor_medic_toggled [ MAX_MEDIC_ACTOR ] = { false, ... } ;
new bool: medic_actor_calling [ MAX_MEDIC_ACTOR ] = { false, ... } ;
new medic_actor_id [ MAX_MEDIC_ACTOR ] = { INVALID_ACTOR_ID, ... } ;
new medic_actor_pay [ MAX_MEDIC_ACTOR ] ;
new medic_actor_area [ MAX_MEDIC_ACTOR ] ;
new medic_timer = 30 ;
new medic_actor_timer [ MAX_MEDIC_ACTOR ] = { 0, ... } ;
new Text3D: medic_label [ MAX_MEDIC_ACTOR ] ;

new medic_actor_use [ MAX_PLAYERS char ] ;
new medic_player_time [ MAX_PLAYERS char ] ;
new medic_salary [ MAX_PLAYERS ] ;

stock clear_player_medic ( playerid )
{
	medic_player_time { playerid } =
	medic_actor_use { playerid } = 0 ;
	
	medic_salary [ playerid ] = 0 ;
	return 1 ;
}

stock medic_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused oldkeys
	if ( newkeys & KEY_WALK )
	{
		if ( used_area [ playerid ] != -1 )
		{
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_medic )
			{
				if ( ! medic_player ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Лечение доступно сотрудникам больницы." ) ;
				if ( medic_actor_use { playerid } < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не приняли вызов." ) ;
				
				new _actor_id = area_info [ used_area [ playerid ] ] [ a_item ] ;
				if ( medic_actor_use { playerid } - 1 != _actor_id ) return 1 ;
				
				medic_player_time { playerid } = 5 ;
				ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 6.1, 0, 0, 0, 0, 0, 1 ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock medic_player_timer ( playerid )
{
	if ( medic_player_time { playerid } > 0 )
	{
		if ( --medic_player_time { playerid } == 1 )
		{
			medic_player_time { playerid } = 0 ;
			
			if ( medic_actor_use { playerid } > 0 )
			{
				new _actor_id = medic_actor_use { playerid } - 1 ;
				destroy_medic_actor ( _actor_id ) ;
				
				p_info [ playerid ] [ salary ] += medic_actor_pay [ _actor_id ] + medic_salary [ playerid ] ;
				
				new __t_string [ 72 ] ;
				format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d"valute_title_"", p_info [ playerid ] [ salary ] ) ;
				SendClientMessage ( playerid, col_white, __t_string ) ;
			}
		}
	}
	return 1 ;
}

stock medic_minute_timer ( )
{
	if ( medic_timer > 0 ) 
	{
		medic_timer -- ;
		if ( medic_timer == 1 )
		{
			medic_timer = 30 ;
			start_medic_actor ( ) ;
		}
	}
	
	for ( new i = 0 ; i < MAX_MEDIC_ACTOR ; i ++ )
	{
		if ( medic_actor_timer [ i ] < 1 ) continue ;
		
		medic_actor_timer [ i ] -- ;
		if ( medic_actor_timer [ i ] == 1 )
		{
			destroy_medic_actor ( i ) ;
			continue ;
		}
	}
	return 1 ;
}

stock start_medic_actor ( )
{
	new _iteration = 0 ;
	new _random = 0 ;
	
	do
	{
		_random = random ( MAX_MEDIC_ACTOR - 1 ) ;
		_iteration ++ ;
	}
	while ( actor_medic_toggled [ _random ] == true && _iteration < 5 ) ;
	
	if ( actor_medic_toggled [ _random ] == true )
	{
		for ( new i = 0 ; i < MAX_MEDIC_ACTOR ; i ++ )
		{
			if ( actor_medic_toggled [ i ] == true ) continue ;
			
			_random = i ;
			break ;
		}
	}
	
	static const _skin_id [ ] = { 33, 35, 185, 105, 10, 10 } ;
	
	medic_actor_id [ _random ] = CreateActor ( _skin_id [ random ( sizeof _skin_id ) ], actor_medic_position [ _random ] [ 0 ], actor_medic_position [ _random ] [ 1 ], actor_medic_position [ _random ] [ 2 ], actor_medic_position [ _random ] [ 3 ] ) ;
	ApplyActorAnimation ( medic_actor_id [ _random ], "CRACK", "CRCKDETH1", 4.0, 1, 1, 1, 1, 0 ) ;
	actor_medic_toggled [ _random ] = true ;
	
	medic_label [ _random ] = CreateDynamic3DTextLabel ( "** Больной **\n{"#cGR3D"}Нажмите {"#cWH3D"}ALT{"#cGR3D"} для взаимодействия", col_header_3d, actor_medic_position [ _random ] [ 0 ], actor_medic_position [ _random ] [ 1 ], actor_medic_position [ _random ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;
	
	medic_actor_area [ _random ] = CreateDynamicSphere ( actor_medic_position [ _random ] [ 0 ], actor_medic_position [ _random ] [ 1 ], actor_medic_position [ _random ] [ 2 ], 3.0, -1, -1, -1 ) ;
	area_info [ medic_actor_area [ _random ] ] [ a_type ] = area_type_medic ;
	area_info [ medic_actor_area [ _random ] ] [ a_item ] = _random ;

	medic_actor_pay [ _random ] = random ( MAX_MEDIC_PAY ) + MAX_MEDIC_PAY ;
	medic_actor_timer [ _random ] = 15 ;

	foreach(new i: logged_players)
	{
		if ( medic_player ( i ) )
		{
		    new scm_string [ 144 ] ;
			format ( scm_string, 144, "* Диспетчер: Вам вызов от больного. Оплата: %d"valute_title".", medic_actor_pay [ _random ] ) ;
			SendClientMessage ( i, col_blue, scm_string ) ;
			format ( scm_string, 144, "* Диспетчер: Расстояние %.1f метр(ов). Введите {"#cWH"}\"/goheal\"{"#cBL"} чтоб принять вызов.", GetPlayerDistanceFromPoint ( i, actor_medic_position [ _random ] [ 0 ], actor_medic_position [ _random ] [ 1 ], actor_medic_position [ _random ] [ 2 ] ) ) ;
			SendClientMessage ( i, col_blue, scm_string ) ;
			
			medic_salary [ i ] = floatround ( GetPlayerDistanceFromPoint ( i, actor_medic_position [ _random ] [ 0 ], actor_medic_position [ _random ] [ 1 ], actor_medic_position [ _random ] [ 2 ] ) * medic_pay_km ) ;
		}
	}
	return 1 ;
}

CMD:goheal ( playerid )
{
    if ( ! medic_player ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Команда доступна только для сотрудников больницы." ) ;

	new _actor_id = -1 ;
	for ( new i = 0 ; i < MAX_MEDIC_ACTOR ; i ++ )
	{
		if ( medic_actor_id [ i ] == INVALID_ACTOR_ID ) continue ;
		if ( medic_actor_calling [ i ] == true ) continue ;
		
		_actor_id = i ;
		medic_actor_calling [ i ] = true ;
		
		medic_actor_use { playerid } = i + 1 ;
		break ;
	}
	
	if ( _actor_id == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент нет вызовов." ) ;

	SetPlayerRaceCheckpoint ( playerid, 1, actor_medic_position [ _actor_id ] [ 0 ], actor_medic_position [ _actor_id ] [ 1 ], actor_medic_position [ _actor_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
	is_gps_used { playerid } = 1 ;
	return 1 ;
}

stock destroy_medic_actor ( _actor_id )
{
	foreach(new i: logged_players)
	{
		if ( ! medic_player ( i ) ) continue ;
		if ( medic_actor_use { i } < 1 ) continue ;
		if ( medic_actor_use { i } - 1 != _actor_id ) continue ;
		
		medic_actor_use { i } = 0 ;
	}
	
	DestroyDynamicActor ( medic_actor_id [ _actor_id ] ) ;
	medic_actor_id [ _actor_id ] = INVALID_ACTOR_ID ;
	
	DestroyDynamic3DTextLabel ( medic_label [ _actor_id ] ) ;
	medic_label [ _actor_id ] = Text3D:INVALID_3DTEXT_ID ;
	
	DestroyDynamicArea ( medic_actor_area [ _actor_id ] ) ;
	medic_actor_timer [ _actor_id ] = 0 ;
	return 1 ;
}

stock medic_OnPlayerDisconnect ( playerid )
{
	if ( medic_actor_use { playerid } > 0 )
	{
		new _actor_id = medic_actor_use { playerid } - 1 ;
		medic_actor_calling [ _actor_id ] = false ;
	}
	return 1 ;
}