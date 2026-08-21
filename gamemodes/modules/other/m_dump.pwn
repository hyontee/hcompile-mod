new Float: trash_position [ 27 ] [ 3 ] =
{
	{ -2763.827, -1131.147, 18.242 },
	{ -2745.434, -1105.178, 12.524 },
	{ -2730.686, -1097.435, 16.518 },
	{ -2740.289, -1090.596, 13.648 },
	{ -2746.934, -1082.085, 14.295 },
	{ -2747.081, -1070.522, 16.609 },
	{ -2737.533, -1063.510, 15.336 },
	{ -2727.314, -1061.773, 14.579 },
	{ -2722.762, -1073.891, 11.774 },
	{ -2702.425, -1090.472, 11.835 },
	{ -2697.680, -1104.291, 17.111 },
	{ -2685.177, -1099.712, 13.924 },
	{ -2682.437, -1086.108, 17.279 },
	{ -2681.633, -1069.672, 16.330 },
	{ -2658.509, -1104.652, 15.920 },
	{ -2654.154, -1082.969, 15.899 },
	{ -2657.709, -1048.726, 16.964 },
	{ -2659.397, -1036.715, 14.461 },
	{ -2660.650, -1021.102, 15.451 },
	{ -2664.031, -1010.346, 16.088 },
	{ -2667.287, -998.975, 14.720 },
	{ -2665.317, -990.093, 16.219 },
	{ -2669.663, -980.585, 15.647 },
	{ -2728.549, -1022.360, 13.809 },
	{ -2742.167, -1025.405, 16.116 },
	{ -2751.145, -1027.745, 16.551 },
	{ -2761.054, -1031.533, 16.641 }
} ;

new trash_count = sizeof trash_position ;
new trash_area [ sizeof trash_position ] ;
new bool: trash_status [ sizeof trash_position ] ;
new Text3D: trash_text [ sizeof trash_position ] ;

stock trash_OnGameModeInit ( )
{
	reset_trash ( ) ;
	return 1 ;
}

stock reset_trash ( )
{
	new _tr_count = 0 ;
	
	for ( new i = 0 ; i < trash_count ; i ++ )
	{
		if ( trash_status [ i ] ) _tr_count ++ ;
	}

	if ( _tr_count < 5 )
	{
		for ( new i = 0 ; i < trash_count ; i++ )
		{
			if ( IsValidDynamicArea ( trash_area [ i ] ) ) DestroyDynamicArea ( trash_area [ i ] ) ;
			if ( IsValidDynamic3DTextLabel ( trash_text [ i ] ) ) DestroyDynamic3DTextLabel ( trash_text [ i ] ) ;

			trash_status [ i ] = false ;
		}
	
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			trash_spawn ( ) ;
		}
	}
	return 1 ;
}

stock trash_spawn ( )
{
	new _random = 0, _count = 0 ;
	do
	{
		_random = random ( trash_count ) ;
		_count ++ ;
	}
	while ( trash_status [ _random ] == true && _count < 5 ) ;
		
	if ( te_info [ _random ] [ te_status ] )
	{
		for ( new i = 0 ; i < trash_count ; i ++ )
		{
			if ( trash_status [ i ] == true ) continue ;
			
			_random = i ;
			break ;
		}
	}
	
	trash_text [ _random ] = CreateDynamic3DTextLabel ( "** Мусор **\n{"#cGR3D"}Подойдите для взаимодействия", col_blue, trash_position [ _random ] [ 0 ], trash_position [ _random ] [ 1 ], trash_position [ _random ] [ 2 ], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
	trash_area [ _random ] = CreateDynamicSphere ( trash_position [ _random ] [ 0 ], trash_position [ _random ] [ 1 ], trash_position [ _random ] [ 2 ], 3.0, 0, 0, -1 ) ;
	
	new _te_area = trash_area [ _random ] ;
	area_info [ _te_area ] [ a_type ] = area_type_trash ;
	area_info [ _te_area ] [ a_item ] = _random ;
	
	trash_status [ _random ] = true ;
	return 1 ;
}

stock trash_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_trash:
		{
			if ( GetPlayerState ( playerid ) != PLAYER_STATE_ONFOOT ) return 1 ;
			
			if ( player_device { playerid } == 2 )
				send_check_cinfo ( playerid, "Вы можете порыться в мусоре,\nвозможно найдёте что-то интересное", 1, -1, CINFO_TRASH_ID, PICTURE_INFO_SUCESS, "Копаться", "" ) ;
			
			else
				trash_active ( playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock trash_active ( playerid )
{
	new i = area_info [ used_area [ playerid ] ] [ a_item ] ;
			
	if ( trash_status [ i ] )
	{
		ApplyAnimation ( playerid, "BUDDY", "buddy_reload", 4.1, 0, 1, 1, 1, 0 ) ;
		p_t_info [ playerid ] [ p_animation ] = true ;
		toggle_controlable ( playerid, false ) ;
							
		job_timer [ playerid ] = SetTimerEx ( "trash_timer", 5800, false, "ii", playerid, i ) ;
					
		trash_status [ i ] = false ;
		if ( IsValidDynamicArea ( trash_area [ i ] ) ) DestroyDynamicArea ( trash_area [ i ] ) ;
		if ( IsValidDynamic3DTextLabel ( trash_text [ i ] ) ) DestroyDynamic3DTextLabel ( trash_text [ i ] ) ;
	}
	return 1 ;
}

stock trash_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_trash:
		{
			clear_check_info ( playerid, CINFO_TRASH_ID ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: trash_timer ( playerid, _te_id )
{
	KillTimer ( job_timer [ playerid ] ) ;
	job_timer [ playerid ] = -1 ;

	toggle_controlable ( playerid, true ) ;
	p_t_info [ playerid ] [ p_animation ] = false ;
	ClearAnimations ( playerid, 1 ) ;
	
	checking_quest_progress ( playerid, 4, 1, quest_line_high ) ;
	
	new _chance = random ( 30 ) ;
	switch ( _chance )
	{
		case 1:
		{
			new _count = random ( 5 ) + 1 ;
			give_inventory ( playerid, 19941, _count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}%d ед. {"#cWH"}золота! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})", _count ) ;
			SendClientMessage ( playerid, col_white, global_string ) ;
		}
		case 2:
		{
			new _count = random ( 5 ) + 1 ;
			give_inventory ( playerid, 2684, _count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}%d ед. {"#cWH"}хлопка! Он понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})", _count ) ;
			SendClientMessage ( playerid, col_white, global_string ) ;
		}
		case 3:
		{
			give_inventory ( playerid, 1080, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}колесо{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 4:
		{
			give_inventory ( playerid, 1018, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}выхлопную трубу{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 5:
		{
			give_inventory ( playerid, 1038, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}элемент крыши{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 6:
		{
			give_inventory ( playerid, 1140, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}бампер{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 7:
		{
			give_inventory ( playerid, 1165, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}задний бампер{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 8:
		{
			give_inventory ( playerid, 19773, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}фрагмент ключа{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 9..29:
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вы ничего не нашли." ) ;
		}
	}
	
	give_global_quest ( playerid, 4, 1 ) ;
	return 1 ;
}