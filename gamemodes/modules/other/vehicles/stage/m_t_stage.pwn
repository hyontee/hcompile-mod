static PlayerText: stage_PTD [ MAX_PLAYERS ] [ 13 ] ;
new stage_select [ MAX_PLAYERS char ] ;

enum
{
	d_stage = 50000
} ;

new stage_max_speed [ 3 ] = { 25, 45, 75 } ;
new stage_brake [ 3 ] = { 15, 25, 35 } ;
new stage_stability [ 3 ] = { 7, 31, 45 } ;

stock stage_info_speed ( _v_id )
{
	new _v_speed = 0 ;
	if ( veh_info [ _v_id - 1 ] [ v_stage_speed ] > 0 ) _v_speed = stage_max_speed [ veh_info [ _v_id - 1 ] [ v_stage_speed ] - 1 ] ;
	return _v_speed ;
}

stock stage_info_brake ( _v_id )
{
	new _v_brake = 0 ;
	if ( veh_info [ _v_id - 1 ] [ v_stage_brake ] > 0 ) _v_brake = stage_brake [ veh_info [ _v_id - 1 ] [ v_stage_brake ] - 1 ] ;
	return _v_brake ;
}

static const stage_name [ 3 ] [ 12 ] = { "1_stage_gr", "2_stage_gr", "3_stage_gr" } ;

stock stage_OnPlayerDisconnect ( playerid )
{
	if ( stage_select { playerid } > 0 )
	{
		show_stage_ptd ( playerid, false ) ;
	}	
	return 1 ;
}

stock stage_PlayerTextDraw ( playerid, PlayerText:playertextid )
{
	if ( stage_select { playerid } > 0 )
	{
		if ( playertextid == stage_PTD [ playerid ] [ 0 ] )
		{
			if ( stage_select { playerid } >= 3 ) return 1 ;
			
			stage_select { playerid } ++ ;
			update_stage_progress ( playerid, stage_select { playerid } ) ;
			update_header_stage ( playerid, stage_select { playerid } ) ;
			return 1 ;
		}
		else if ( playertextid == stage_PTD [ playerid ] [ 1 ] )
		{
			if ( stage_select { playerid } <= 1 ) return 1 ;
			
			stage_select { playerid } -- ;
			update_stage_progress ( playerid, stage_select { playerid } ) ;
			update_header_stage ( playerid, stage_select { playerid } ) ;
			return 1 ;
		}
		else if ( playertextid == stage_PTD [ playerid ] [ 11 ] )
		{
			static const _t_price [ 3 ] = { 20_000_000, 500, 300 } ;
			
			new td_string [ 35 ], _stage_id = stage_select { playerid } ;
			if ( _stage_id == 1 ) format ( td_string, sizeof td_string, "%d$", _t_price [ stage_select { playerid } - 1 ] ) ;
			else if ( _stage_id == 2 ) format ( td_string, sizeof td_string, "%d "donate_title_abb" (Бонус)", _t_price [ stage_select { playerid } - 1 ] ) ;
			else format ( td_string, sizeof td_string, "%d "donate_title_abb" (Основной)", _t_price [ stage_select { playerid } - 1 ] ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 256, "\
				{"#cGRDialog"}- {"#cWH"}Stage %d:\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}%s.\n\
				{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Stage %d{"#cGRDialog"}\"?", stage_select { playerid }, td_string, stage_select { playerid } ) ;
			
			show_dialog ( playerid, d_stage, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", global_string, "Принять", "Закрыть" ) ;
			return 1 ;
		}
		else if ( playertextid == stage_PTD [ playerid ] [ 12 ] )
		{
			show_stage_ptd ( playerid, false ) ;
			return 1 ;
		}
	}	
	return 0 ;
}

stock stage_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	#pragma unused listitem
	switch ( dialogid )
	{
		case d_stage:
		{
			if ( ! response ) return 1 ;
			
			new _v_id = GetPlayerVehicleID ( playerid ), _s_lvl = stage_select { playerid } ;
			if ( veh_info [ _v_id - 1 ] [ v_stage_speed ] == _s_lvl ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}У Вас уже установлен данный Stage.", "Закрыть", "" ) ;
			
			switch ( stage_select { playerid } )
			{
				case 1:
				{
					if ( p_info [ playerid ] [ money ] < 20_000_000 ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Недостаточно денежных средств.", "Закрыть", "" ) ;
					
					give_money ( playerid, -20_000_000 ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -20_000_000, "stage (lvl 1)" ) ;
				}
				case 2:
				{
					if ( ! get_player_donate ( playerid, 500, 1 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Недостаточно "donate_title_abb" на бонусном счёте.", "Закрыть", "" ) ;
					
					set_player_donate ( playerid, 500, 1 ) ;
				}
				case 3:
				{
					if ( ! get_player_donate ( playerid, 300, 2 ) ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Stage-тюнинг", !"{"#cRD"}* {"#cGRDialog"}Недостаточно "donate_title_abb" на основном счёте.", "Закрыть", "" ) ;
        
					set_player_donate ( playerid, 300, 2 ) ;
					insert_donate_log ( playerid, INVALID_PLAYER_ID, 300, p_info [ playerid ] [ donate ], "(donate) stage (lvl 2)" ) ;
				}
			}
			
			veh_info [ _v_id - 1 ] [ v_stage_speed ] = _s_lvl ;
			veh_info [ _v_id - 1 ] [ v_stage_brake ] = _s_lvl ;
			save_car_stage ( _v_id ) ;
			
			new scm_string [ 54 + 4 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы успешно приобрели Stage %d.", _s_lvl ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			show_stage_ptd ( playerid, false ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock save_car_stage ( _v_id )
{
	if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_player )
	{
		new query_string [ 356 ] ;
		format ( query_string, sizeof ( query_string ),"UPDATE `users_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `v_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_family )
	{
		new query_string [ 356 ] ;
		format ( query_string, sizeof ( query_string ),"UPDATE `familys_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_rentcar )
	{
		new query_string [ 356 ] ;			
		format ( query_string, sizeof ( query_string ),"UPDATE `rent_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_house )
	{
		new query_string [ 356 ] ;
		format ( query_string, sizeof ( query_string ),"UPDATE `house_vehicles` SET `v_stage_speed` = '%d', `v_stage_brake` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_stage_speed ],
		veh_info [ _v_id - 1 ] [ v_stage_brake ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
	}
	return 1 ;
}

stock update_stage_progress ( playerid, _stage_id )
{
	new _v_id = GetPlayerVehicleID ( playerid ) ;
	new _v_model = getVehicleOrdinalNumber ( _v_id ) ;
	new _m_speed = max_veh_speed ( _v_model ) ;
	
	new Float: start_x = floatdiv ( 67.4, 100 ) ;
	new Float: td_x = start_x * ( _m_speed / 10 ) ;
	if ( td_x > 67.4 ) td_x = 67.4 ;
	PlayerTextDrawTextSize ( playerid, stage_PTD [ playerid ] [ 5 ], td_x, 10.000000 ) ;
	PlayerTextDrawHide ( playerid, stage_PTD [ playerid ] [ 5 ] ) ;
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 5 ] ) ;
	
	td_x = start_x * ( ( _m_speed / 10 ) + stage_max_speed [ _stage_id - 1 ] ) ;
	if ( td_x > 67.4 ) td_x = 67.4 ;
	PlayerTextDrawTextSize ( playerid, stage_PTD [ playerid ] [ 4 ], td_x, 10.000000 ) ;
	PlayerTextDrawHide ( playerid, stage_PTD [ playerid ] [ 4 ] ) ;
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 4 ] ) ;
	
	td_x = start_x * ( _m_speed / 20 ) ;
	if ( td_x > 67.4 ) td_x = 67.4 ;
	PlayerTextDrawTextSize ( playerid, stage_PTD [ playerid ] [ 7 ], td_x, 10.000000 ) ;
	PlayerTextDrawHide ( playerid, stage_PTD [ playerid ] [ 7 ] ) ;
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 7 ] ) ;
	
	td_x = start_x * ( ( _m_speed / 20 ) + stage_brake [ _stage_id - 1 ] ) ;
	if ( td_x > 67.4 ) td_x = 67.4 ;
	PlayerTextDrawTextSize ( playerid, stage_PTD [ playerid ] [ 6 ], td_x, 10.000000 ) ;
	PlayerTextDrawHide ( playerid, stage_PTD [ playerid ] [ 6 ] ) ;
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 6 ] ) ;
	
	td_x = start_x * ( _m_speed / 15 ) ;
	if ( td_x > 67.4 ) td_x = 67.4 ;
	PlayerTextDrawTextSize ( playerid, stage_PTD [ playerid ] [ 9 ], td_x, 10.000000 ) ;
	PlayerTextDrawHide ( playerid, stage_PTD [ playerid ] [ 9 ] ) ;
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 9 ] ) ;
	
	td_x = start_x * ( ( _m_speed / 15 ) + stage_stability [ _stage_id - 1 ] ) ;
	if ( td_x > 67.4 ) td_x = 67.4 ;
	PlayerTextDrawTextSize ( playerid, stage_PTD [ playerid ] [ 8 ], td_x, 10.000000 ) ;
	PlayerTextDrawHide ( playerid, stage_PTD [ playerid ] [ 8 ] ) ;
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 8 ] ) ;
	return 1 ;
}

stock update_header_stage ( playerid, _stage_id )
{
	static const _t_price [ 3 ] = { 20_000_000, 500, 300 } ;
	
	new td_string [ 32 ] ;
	if ( _stage_id == 1 ) format ( td_string, sizeof td_string, "%d$", _t_price [ _stage_id - 1 ] ) ;
	else format ( td_string, sizeof td_string, "%d "donate_title_abb"", _t_price [ _stage_id - 1 ] ) ;
	PlayerTextDrawSetString ( playerid, stage_PTD [ playerid ] [ 10 ], td_string ) ;
	
	PlayerTextDrawDestroy ( playerid, stage_PTD [ playerid ] [ 2 ] ) ;
	
	format ( td_string, sizeof td_string, "grtd:%s", stage_name [ _stage_id - 1 ] ) ;
	stage_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 0.333325, 165.785232, td_string ) ;
	PlayerTextDrawTextSize(playerid, stage_PTD[playerid][2], 98.000000, 117.000000);
	PlayerTextDrawAlignment(playerid, stage_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, stage_PTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, stage_PTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][2], 0);
	
	PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ 2 ] ) ;
	return 1 ;
}

stock show_stage_ptd ( playerid, bool: status )
{
	if ( status )
	{
		stage_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 31.999994, 140.437026, "grtd:up_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][0], 30.000000, 35.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][0], 0);
		PlayerTextDrawSetSelectable(playerid, stage_PTD[playerid][0], true);

		stage_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 31.999994, 277.437042, "grtd:down_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][1], 30.000000, 35.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][1], 0);
		PlayerTextDrawSetSelectable(playerid, stage_PTD[playerid][1], true);

		stage_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 0.333325, 165.785232, "grtd:1_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][2], 98.000000, 117.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][2], 0);

		stage_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 470.333282, 121.814834, "grtd:menu_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][3], 165.000000, 214.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][3], 0);

		stage_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 551.333557, 184.566619, "grtd:dp_stage_gr"); // двиг. задняя полоска
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][4], 67.379974, 10.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][4], 0);

		stage_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 551.333557, 184.566619, "grtd:ap_stage_gr"); // двиг. перед полоска
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][5], 67.379974, 10.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][5], 0);

		stage_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 551.333557, 209.066650, "grtd:dp_stage_gr"); // тормоза
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][6], 67.379974, 10.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][6], 0);

		stage_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 551.333557, 209.066650, "grtd:ap_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][7], 67.379974, 10.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][7], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][7], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][7], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][7], 0);

		stage_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 551.333557, 233.866638, "grtd:dp_stage_gr"); // стабильность
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][8], 67.379974, 10.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][8], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][8], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][8], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][8], 0);

		stage_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 551.333557, 233.866638, "grtd:ap_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][9], 67.379974, 10.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][9], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][9], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][9], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][9], 0);

		stage_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 503.666748, 263.422302, "50.000.000");
		PlayerTextDrawLetterSize(playerid, stage_PTD[playerid][10], 0.352666, 1.579259);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][10], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][10], -1);
		PlayerTextDrawSetShadow(playerid, stage_PTD[playerid][10], 0);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][10], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][10], 1);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][10], 1);

		stage_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 264.000061, 393.933349, "grtd:btnbuy_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][11], 101.000000, 33.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][11], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][11], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][11], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][11], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][11], 0);
		PlayerTextDrawSetSelectable(playerid, stage_PTD[playerid][11], true);

		stage_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 594.333129, 8.155550, "grtd:exit_stage_gr");
		PlayerTextDrawTextSize(playerid, stage_PTD[playerid][12], 38.000000, 43.000000);
		PlayerTextDrawAlignment(playerid, stage_PTD[playerid][12], 1);
		PlayerTextDrawColor(playerid, stage_PTD[playerid][12], -1);
		PlayerTextDrawBackgroundColor(playerid, stage_PTD[playerid][12], 255);
		PlayerTextDrawFont(playerid, stage_PTD[playerid][12], 4);
		PlayerTextDrawSetProportional(playerid, stage_PTD[playerid][12], 0);
		PlayerTextDrawSetSelectable(playerid, stage_PTD[playerid][12], true);
		
		for ( new i = 0 ; i < 13 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, stage_PTD [ playerid ] [ i ] ) ;
		}
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;

		update_stage_progress ( playerid, 1 ) ;
		update_header_stage ( playerid, 1 ) ;
		
		stage_select { playerid } = 1 ;
		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
		for ( new i = 0 ; i < 13 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, stage_PTD [ playerid ] [ i ] ) ;
			stage_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		
		stage_select { playerid } = 0 ;
		CancelSelectTextDraw ( playerid ) ;
		SetCameraBehindPlayer ( playerid ) ;
	}
	return 1 ;
}