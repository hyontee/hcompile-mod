new Float: trash_position [ 27 ] [ 3 ] =
{
	{ -1707.3845, 30.3605, 87.9697 },
	{ -1700.4274, 21.5805, 90.7665 },
	{ -1686.9665, 3.9642, 90.7999 },
	{ -1680.8160, -5.8413, 88.1623 },
	{ -1676.8713, -18.7804, 90.6335 },
	{ -1675.9768, -25.1352, 90.8457 },
	{ -1710.7374, -21.9826, 92.5818 },
	{ -1718.6055, -25.5113, 90.9345 },
	{ -1724.3603, -12.3368, 93.0614 },
	{ -1733.4731, -5.5799, 92.6815 },
	{ -1742.4482, 4.4960, 89.8419 },
	{ -1787.4985, 33.6548, 88.5956 },
	{ -1793.3020, 31.3764, 88.1206 },
	{ -1800.3160, -16.4611, 86.7149 },
	{ -1803.7841, -29.1846, 87.3678 },
	{ -1799.8708, -42.6421, 90.7288 },
	{ -1794.6511, -59.3785, 90.6936 },
	{ -1781.9289, -51.5300, 90.8181 },
	{ -1777.5849, -63.6401, 90.1622 },
	{ -1767.3896, -71.7382, 90.4207 },
	{ -1762.5783, -80.6059, 90.8342 },
	{ -1772.0069, -77.0259, 86.8154 },
	{ -1778.7702, -79.4576, 90.8275 },
	{ -1770.5488, -93.1458, 85.9821 },
	{ -1768.6373, -100.5206, 85.9180 },
	{ -1761.3896, -105.4588, 85.7578 },
	{ -1754.8813, -110.9111, 85.5132 }
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
				send_check_cinfo ( playerid, "Мусор. Нажмите для взаимодействия", 1, -1, CINFO_TRASH_ID, CINFO_TYPE_AREA, PICTURE_INFO_SELECT, "Копаться", "" ) ;
			
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
			give_player_item_prise ( playerid, 19941, _count, 30 ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}%d ед. {"#cWH"}золота! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})", _count ) ;
			SendClientMessage ( playerid, col_white, global_string ) ;
		}
		case 2:
		{
			new _count = random ( 5 ) + 1 ;
			give_player_item_prise ( playerid, 2684, _count, 30 ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}%d ед. {"#cWH"}хлопка! Он понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})", _count ) ;
			SendClientMessage ( playerid, col_white, global_string ) ;
		}
		case 3:
		{
			give_player_item_prise ( playerid, 1080, 1, 30 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}колесо{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 4:
		{
			give_player_item_prise ( playerid, 1018, 1, 30 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}выхлопную трубу{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 5:
		{
			give_player_item_prise ( playerid, 1038, 1, 30 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}элемент крыши{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 6:
		{
			give_player_item_prise ( playerid, 1140, 1, 30 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}бампер{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 7:
		{
			give_player_item_prise ( playerid, 1165, 1, 30 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}задний бампер{"#cWH"}! Оно понадобится для крафта. ({"#cGInfo"}/help - Крафт{"#cWH"})" ) ;
		}
		case 8:
		{
			give_player_item_prise ( playerid, 19773, 1, 30 ) ;
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