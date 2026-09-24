#include <custom/fishing>

#if defined SAMP
	static Float: udochka_position [ 9 ] = { 0.079376, 0.037070, 0.007706, 181.482910, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 } ;
#endif

#if defined CRMP
	static Float: udochka_position [ 9 ] = { -0.0199, -0.0499, 0.1399, 0.0000, 0.0000, 0.0000, 1.6500, 1.6500, 1.6500 } ;
#endif

static Float: fishing_position [ 14 ] [ 3 ] =
{
	{ -2239.5026, -972.1477, 29.2472 },
	{ -2199.8942, -1008.5966, 29.2472 },
	{ -2144.5627, -1032.0325, 29.2472 },
	{ -2101.3542, -1043.6794, 29.2473 },
	{ -2043.4631, -1011.2409, 29.2473 },
	{ -2036.8395, -986.1390, 29.2473 },
	{ -2036.5474, -964.1528, 29.2473 },
	{ -2039.9488, -930.7846, 29.2473 },
	{ -2047.5626, -899.7265, 29.2473 },
	{ -2057.6408, -876.1149, 29.2473 },
	{ -2074.6037, -861.1803, 29.2473 },
	{ -2102.5249, -844.8115, 29.2473 },
	{ -2186.8823, -820.2985, 29.2473 },
	{ -2236.0925, -840.0061, 29.2473 }
} ;

static Text3D: fishing_text [ 14 ] ;
static fishing_area [ 14 ] ;
static bool: used_fishing [ 14 ] = { false, ... } ;
new player_fishing_place [ MAX_PLAYERS char ] ;
new player_fishing_count [ MAX_PLAYERS char ] ;
new player_fishing_status [ MAX_PLAYERS char ] ;

static const fish_item_model [ 3 ] = { 1599, 1600, 1604 } ;

stock fish_held_kg ( playerid )
{
	new _kg = p_info [ playerid ] [ fishing_kg ] ;
	for ( new i = 0 ; i < MAX_PRISE_SLOT ; i ++ )
	{
		switch ( p_info [ playerid ] [ prise_slot ] [ i ] )
		{
			case 1599, 1600, 1604: _kg += p_info [ playerid ] [ prise_slot_count ] [ i ] ;
		}
	}
	return _kg ;
}

stock take_player_fish ( playerid )
{
	new _kg = p_info [ playerid ] [ fishing_kg ] ;
	p_info [ playerid ] [ fishing_kg ] = 0 ;

	for ( new i = 0 ; i < MAX_PRISE_SLOT ; i ++ )
	{
		new _item = p_info [ playerid ] [ prise_slot ] [ i ] ;
		switch ( _item )
		{
			case 1599, 1600, 1604:
			{
				new _count = p_info [ playerid ] [ prise_slot_count ] [ i ] ;
				_kg += _count ;
				clear_player_item_prise ( playerid, _item, _count, i ) ;
			}
		}
	}
	return _kg ;
}

stock clear_player_fishing ( playerid )
{
	player_fishing_place { playerid } =
	player_fishing_count { playerid } = 
	player_fishing_status { playerid } = 0 ;
	
	p_t_info [ playerid ] [ fishing_rod ] = false ;
	p_t_info [ playerid ] [ Fishing_TimerID ] = -1 ;
	return 1 ;
}

stock fishing_OnGameModeInit ( )
{
	for ( new i = 0 ; i < sizeof fishing_position ; i ++ )
	{
		fishing_text [ i ] = CreateDynamic3DTextLabel ( "** Рыбацкое место **\n{"#cGN3D"}Свободно", col_blue, fishing_position [ i ] [ 0 ], fishing_position [ i ] [ 1 ], fishing_position [ i ] [ 2 ] + 0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0 ) ;
		fishing_area [ i ] = CreateDynamicSphere ( fishing_position [ i ] [ 0 ], fishing_position [ i ] [ 1 ], fishing_position [ i ] [ 2 ], 2.0, -1, -1, -1 ) ;
		area_info [ fishing_area [ i ] ] [ a_type ] = area_type_fishing ;
		area_info [ fishing_area [ i ] ] [ a_item ] = i ;
	}
	return 1 ;
}

stock fishing_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_fishing_go:
		{
			if ( ! response ) return update_int_sql ( playerid, "u_fishing_bait", p_info [ playerid ] [ fishing_bait ] ) ;
		
			new _place_id = get_player_use_listitem ( playerid ) ;
			
			new scm_string [ 52 + MAX_PLAYER_NAME ] ;
			format ( scm_string, sizeof scm_string, "** Рыбацкое место **\n{"#cRL3D"}Занято {"#cWH"}%s", p_info [ playerid ] [ name ] ) ;
			UpdateDynamic3DTextLabelText ( fishing_text [ _place_id ], col_blue, scm_string ) ;
			
			player_fishing_place { playerid } = _place_id + 1 ;
			
			p_t_info [ playerid ] [ fishing_rod ] = true ;
		    
			SetPlayerAttachedObject ( playerid, 1, udochka_object, 6, udochka_position [ 0 ], udochka_position [ 1 ], udochka_position [ 2 ], udochka_position [ 3 ], udochka_position [ 4 ], udochka_position [ 5 ], udochka_position [ 6 ], udochka_position [ 7 ], udochka_position [ 8 ] ) ;
			ApplyAnimation ( playerid, "SWORD", "sword_block", 1.0, 0, 0, 0, 1, 0, 1 ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
			
			p_t_info [ playerid ] [ Fishing_TimerID ] = SetTimerEx ( "OnPlayerFishing", 10000 + random ( 10000 ), false, "d", playerid ) ;
			me_action ( playerid, "достал(а) удочку" ) ;
			
			if ( player_device { playerid } == 2 )
			{
				fishingFirstPerson ( playerid, true ) ;
				fishingShow ( playerid ) ;
				fishingUpdate ( playerid, "В спокойствии...", false ) ;
				player_fishing_status { playerid } = 0 ;
		
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
			}
			
			toggle_controlable ( playerid, false ) ;
			return 1 ;
		}
		case d_fishing_go_1:
		{
		    if ( ! response )
		    {
				exit_player_fishing ( playerid ) ;
		        return 1 ;
		    }

			ApplyAnimation(playerid, "SWORD", "sword_block", 1.0, 0, 0, 0, 1, 0, 1);
			p_t_info [ playerid ] [ Fishing_TimerID ] = SetTimerEx ( "OnPlayerFishing", 10000 + random ( 10000 ), false, "d", playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock fishing_EnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_fishing:
			{
				if ( ! p_info [ playerid ] [ fishing_rod ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам необходимо приобрести удочку. Используйте {"#cRInfo"}/gps - Бизнесы - Охота и рыбалка{"#cGRInfo"}." ) ;
				if ( ! p_info [ playerid ] [ fishing_bait ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам необходимо приобрести наживку. Используйте {"#cRInfo"}/gps - Бизнесы - Охота и рыбалка{"#cGRInfo"}." ) ;
				
				new i = area_info [ areaid ] [ a_item ] ;
				if ( used_fishing [ i ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Место занято другим игроком." ) ;

				show_dialog ( playerid, d_fishing_go, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Рыбалка", "{"#cWH"}Вы хотите занять место и начать рыбачить?", "Да", "Нет" ) ;
				set_player_use_listitem ( playerid, i ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

callback: OnPlayerFishing ( playerid )
{
    if ( ! p_info [ playerid ] [ fishing_bait ] )
	{
		exit_player_fishing ( playerid ) ;
		return 1 ;
	}
	p_info [ playerid ] [ fishing_bait ] -- ;

	KillTimer ( p_t_info [ playerid ] [ Fishing_TimerID ] ) ;
	p_t_info [ playerid ] [ Fishing_TimerID ] = -1 ;
	
	if ( player_device { playerid } == 2 )
	{
		if ( player_fishing_status { playerid } == 1 )
		{
			fishingUpdate ( playerid, "В спокойствии...", false ) ;
			player_fishing_status { playerid } = 0 ;
			
			p_t_info [ playerid ] [ Fishing_TimerID ] = SetTimerEx ( "OnPlayerFishing", 10000 + random ( 10000 ), false, "d", playerid ) ;
		}	
		else
		{
			fishingUpdate ( playerid, "Колышится...", true ) ;
			player_fishing_status { playerid } = 1 ;
			
			p_t_info [ playerid ] [ Fishing_TimerID ] = SetTimerEx ( "OnPlayerFishing", 2000 + random ( 2000 ), false, "d", playerid ) ;
		}
	}
	else give_player_fish ( playerid ) ;
	return 1 ;
}

stock fishing_player_timer ( playerid )
{
	if ( p_info [ playerid ] [ fishing_cooldown ] > 0 ) 
	{
		if ( --p_info [ playerid ] [ fishing_cooldown ] == 1 )
		{
			p_info [ playerid ] [ fishing_cooldown ] =
			p_info [ playerid ] [ fishing_hour_kg ] = 0 ;
			
			new sql_string [ 103 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_fishing_cooldown` = '0', `u_fishing_hour_kg` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы снова можете отправляться на рыбалку." ) ;
		}
	}
	return 1 ;
}

stock give_player_fish ( playerid )
{
	new _fish_id = random ( 3 ) ;
	new _fish_kg = random ( 5 ) + 1 ;

	new _fish_cap = p_info [ playerid ] [ vip ] ? 60 : 40 ;
	new _fish_give = _fish_cap - fish_held_kg ( playerid ) ;
	if ( _fish_give > _fish_kg ) _fish_give = _fish_kg ;
	if ( _fish_give > 0 ) give_player_item_prise ( playerid, fish_item_model [ _fish_id ], _fish_give, -1 ) ;

	p_info [ playerid ] [ fishing_hour_kg ] += _fish_kg ;
	
	give_event_progress ( playerid, THE_FISHING, _fish_kg ) ;
	
	checking_mission_progress ( playerid, 0, _fish_kg ) ;
	checking_mission_progress ( playerid, 2, _fish_kg ) ;
	
	checking_quest_progress ( playerid, 7, _fish_kg, quest_line_medium ) ;
	
	if ( p_info [ playerid ] [ family ] > 0 )
	{
		give_all_family_quest ( p_info [ playerid ] [ family ], 4, _fish_kg ) ;
		
		if ( p_info [ playerid ] [ family_quest ] == 6 )
		{
			if ( p_info [ playerid ] [ family_quest_progress ] < 50 )
			{
				p_info [ playerid ] [ family_quest_progress ] += _fish_kg ;
				update_int_sql ( playerid, "u_family_quest_progress", p_info [ playerid ] [ family_quest_progress ] ) ;
			}
			else SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
		}
		else if ( p_info [ playerid ] [ family_quest ] == 7 )
		{
			if ( p_info [ playerid ] [ family_quest_progress ] < 100 )
			{
				p_info [ playerid ] [ family_quest_progress ] += _fish_kg ;
				update_int_sql ( playerid, "u_family_quest_progress", p_info [ playerid ] [ family_quest_progress ] ) ;
			}
			else SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
		}
	}
	
	if ( player_device { playerid } == 2 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "{"#cWH"}Вы поймали {"#cGN"}%s {"#cWH"}весом {"#cGN"}%d кг.\n\
									Осталось {"#cGN"}%d шт.{"#cWH"} наживки. Поймано {"#cGN"}%d кг.{"#cWH"} рыбы.\n\
									Используйте {"#cBInfo"}/gps - Бизнесы - Охота и рыбалка {"#cWH"}для продажи рыбы.",
		fish_name ( _fish_id ), _fish_kg,
		p_info [ playerid ] [ fishing_bait ], fish_held_kg ( playerid ) ) ;
		send_check_cinfo ( playerid, global_string, 0, 300, CINFO_FISHING_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	else
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 110, "{"#cGInfo"}* {"#cWH"}Осталось {"#cGN"}%d шт.{"#cWH"} наживки. Поймано {"#cGN"}%d кг.{"#cWH"} рыбы.", p_info [ playerid ] [ fishing_bait ], fish_held_kg ( playerid ) ) ;
		SendClientMessage ( playerid, col_white, global_string ) ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 100, "{"#cGInfo"}* {"#cWH"}Вы поймали {"#cGN"}%s {"#cWH"}весом {"#cGN"}%d кг.", fish_name ( _fish_id ), _fish_kg ) ;
		SendClientMessage ( playerid, col_white, global_string ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBInfo"}/gps - Бизнесы - Охота и рыбалка {"#cWH"}для продажи рыбы." ) ;
	}
	
	if ( random ( 100 ) < 10 )
	{
		switch ( random ( 10 ) )
		{
			case 1, 2, 3, 4:
			{
				give_player_item_prise ( playerid, 2684, random ( 10 ) + 3, 30 ) ;
				if ( player_device { playerid } == 2 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.\n\
												Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{"#cWH"})", item_name ( 2684 ) ) ;
					send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( 2684 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
			}
			case 5, 6, 7, 8:
			{
				give_player_item_prise ( playerid, 19941, random ( 10 ) + 3, 30 ) ;
				
				if ( player_device { playerid } == 2 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.\n\
												Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{"#cWH"})", item_name ( 19941 ) ) ;
					send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( 19941 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
			}
			case 9:
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
				
				give_player_item_prise ( playerid, _det_id, 1, 30 ) ;
				
				if ( player_device { playerid } == 2 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.\n\
												Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{"#cWH"})", item_name ( _det_id ) ) ;
					send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _det_id ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
			}
		}
	}
	
	new max_fish_mass ;
	if ( p_info [ playerid ] [ vip ] ) max_fish_mass = 60 ;
	else max_fish_mass = 40 ;
	
	if ( p_info [ playerid ] [ fishing_hour_kg ] >= max_fish_mass )
	{
		p_info [ playerid ] [ fishing_hour_kg ] = max_fish_mass ;
		
		p_info [ playerid ] [ fishing_cooldown ] = 1200 ;
		
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы поймали максимальное количество рыбы. Вам необходимо отдохнуть." ) ;
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Возвращайтесь через 20 минут." ) ;
		if ( player_device { playerid } == 2 ) show_packet_fishing ( playerid, 0, 0 ) ;
		else exit_player_fishing ( playerid ) ;
	}
	else if ( fish_held_kg ( playerid ) >= max_fish_mass )
	{
		
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы поймали максимальное количество рыбы. Отправляйтесь на продажу." ) ;
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBInfo"}/gps - Бизнесы - Охота и рыбалка {"#cWH"}для продажи рыбы." ) ;
		if ( player_device { playerid } == 2 ) show_packet_fishing ( playerid, 0, 0 ) ;
		else exit_player_fishing ( playerid ) ;
	}
	else
	{
		if ( player_device { playerid } == 2 )
		{
			fishingUpdate ( playerid, "В спокойствии...", false ) ;
			player_fishing_status { playerid } = 0 ;
			
			ApplyAnimation(playerid, "SWORD", "sword_block", 1.0, 0, 0, 0, 1, 0, 1);
			p_t_info [ playerid ] [ Fishing_TimerID ] = SetTimerEx ( "OnPlayerFishing", 10000 + random ( 10000 ), false, "d", playerid ) ;
		}
		else show_dialog ( playerid, d_fishing_go_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Рыбалка", "{"#cWH"}Вы хотите продолжить рыбачить?", "Да", "Нет" ) ;
	}
	
	give_global_quest ( playerid, 2, _fish_kg ) ;
	
	new scm_string [ 153 + ( 5 * 9 ) ] ;
	format ( scm_string, sizeof scm_string, "UPDATE `users` SET `u_fishing_kg` = '%d', `u_fishing_hour_kg` = '%d', `u_fishing_bait` = '%d', `u_fishing_cooldown` = '%d' WHERE `u_id` = '%d' LIMIT 1",
	p_info [ playerid ] [ fishing_kg ], p_info [ playerid ] [ fishing_hour_kg ], p_info [ playerid ] [ fishing_bait ], p_info [ playerid ] [ fishing_cooldown ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, scm_string ) ;
	return 1 ;
}

stock exit_player_fishing ( playerid )
{
	p_t_info [ playerid ] [ fishing_rod ] = false ;
	
	RemovePlayerAttachedObject ( playerid, 1 ) ;
	ClearAnimations ( playerid ) ;
	p_t_info [ playerid ] [ p_animation ] = false ;
	
	KillTimer ( p_t_info [ playerid ] [ Fishing_TimerID ] ) ;
	p_t_info [ playerid ] [ Fishing_TimerID ] = -1 ;
	
	me_action ( playerid, "убрал(а) удочку" ) ;
		
	new _place_id = player_fishing_place { playerid } ;
	if ( _place_id > 0 )
		UpdateDynamic3DTextLabelText ( fishing_text [ _place_id - 1 ], col_blue, "** Рыбацкое место **\n{"#cGN3D"}Свободно" ) ;
	
	player_fishing_place { playerid } = 
	player_fishing_status { playerid } = 0 ;

	toggle_controlable ( playerid, true ) ;
	return 1 ;
}

stock fish_name ( fish_id )
{
	new _fish_name [ 10 ] ;
	switch ( fish_id )
	{
	    case 0: _fish_name = "Анчоус" ;
	    case 1: _fish_name = "Тунец" ;
	    case 2: _fish_name = "Ласось" ;
	}
	return _fish_name ;
}

stock fishing_OnPlayerDisconnect ( playerid )
{
	if ( p_t_info [ playerid ] [ Fishing_TimerID ] != -1 ) exit_player_fishing ( playerid ) ;
	return 1 ;
}

stock show_packet_fishing ( playerid, _param, _param2 )
{
	if ( _param == 0 )
	{
		if ( _param2 == 0 )
		{
			fishingHide ( playerid ) ;
			exit_player_fishing ( playerid ) ;
			fishingFirstPerson ( playerid, false ) ;
		
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		}
	}
	else if ( _param == 1 )
	{
		if ( _param2 == 0 )
		{
			if ( player_fishing_status { playerid } == 1 )
			{
				KillTimer ( p_t_info [ playerid ] [ Fishing_TimerID ] ) ;
				p_t_info [ playerid ] [ Fishing_TimerID ] = -1 ;
				
				give_player_fish ( playerid ) ;
				player_fishing_status { playerid } = 0 ;
			}
			else send_check_cinfo ( playerid, "Поплавок не колышится!", 0, 300, CINFO_FISHING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		}
	}
	return 1 ;
}