/*

	Сделать движение карт на -1, когда игрок походил / побился

*/

#define ofm_formula_card(%1)	(%1 * 6) // + 1

#define MAX_FOOL_TABLE 3
enum _fool
{
	f_player [ 6 ],
	f_move_next_player [ 6 ],
	f_move,
	f_move_pokriv,
	f_move_podkinul,
	f_trump,
	f_team_trump,
	f_card [ 36 ],
	f_card_count,
	f_table_podkid [ 6 ],
	f_table_pokriv [ 6 ],
	f_time,
	f_started,
	f_status,
	f_bet,
	f_bank,
	Text3D: f_text,
	f_area
}
new fool_info [ MAX_BUSINESS ] [ MAX_FOOL_TABLE ] [ _fool ] ;

new PlayerText: enemy1_cards_PTD [ MAX_PLAYERS ] [ 7 ] ;
new PlayerText: enemy2_cards_PTD [ MAX_PLAYERS ] [ 7 ] ;
new PlayerText: enemy3_cards_PTD [ MAX_PLAYERS ] [ 7 ] ;
new PlayerText: enemy4_cards_PTD [ MAX_PLAYERS ] [ 7 ] ;
new PlayerText: enemy5_cards_PTD [ MAX_PLAYERS ] [ 7 ] ;
new PlayerText: player_cards_PTD [ MAX_PLAYERS ] [ 6 ] ;
new PlayerText: koloda_cards_PTD [ MAX_PLAYERS ] [ 8 ] ;
new PlayerText: cards_background_PTD [ MAX_PLAYERS ] [ 8 ] ;
new PlayerText: pokriv_cards_PTD [ MAX_PLAYERS ] [ 6 ] ;
new PlayerText: podkid_cards_PTD [ MAX_PLAYERS ] [ 6 ] ;
new PlayerText: button_take_PTD [ MAX_PLAYERS ] [ 4 ] ;

new Float: fool_positions [ MAX_FOOL_TABLE ] [ 3 ] =
{
	{ -1673.1070, -346.6575, 1200.5023 },
	{ -1675.2601, -341.9582, 1200.5023 },
	{ -1670.8294, -341.9722, 1200.5023 }
} ;

new fool_table [ MAX_PLAYERS char ] ;
new bool: fool_used [ MAX_PLAYERS ] ;
new fool_player [ MAX_PLAYERS ] [ 36 ] ;
new fool_player_clear [ 36 ] = { -1, ... } ;

stock clear_player_fool ( playerid )
{
	fool_player [ playerid ] = fool_player_clear ;
	fool_used [ playerid ] = false ;
	fool_table { playerid } = 0 ;
	
	for ( new i = 0 ; i < 7 ; i ++ )
	{
		enemy1_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		enemy2_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		enemy3_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		enemy4_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		enemy5_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		if ( i < 4 ) button_take_PTD [ playerid ] [ i ] = PlayerText:-1 ;
	}
	return 1 ;
}

stock cards_OnPlayerDisconnect ( playerid )
{
	if ( fool_table { playerid } )
	{
		if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 )
		{
			new _table = fool_table { playerid } ;
			fool_used [ playerid ] = false ;
			fool_table { playerid } = 0 ;
			
			show_fool_ptd ( playerid, _table, false ) ;
			show_cards_ptd ( playerid, false ) ;
			show_koloda_ptd ( playerid, false ) ;
			show_podkid_ptd ( playerid, false ) ;
			show_pokriv_ptd ( playerid, false ) ;
			show_button_ptd ( playerid, -1, false ) ;
			
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			
			SetCameraBehindPlayer ( playerid ) ;
		}
		else close_player_fool ( GetPVarInt ( playerid, "p_biz_id" ), fool_table { playerid } - 1, playerid, 2 ) ;
	}
	return 1 ;
}

stock close_player_fool ( _b_id, _table, winner_id, _type )
{
	new scm_string [ 37 + MAX_PLAYER_NAME ] ;
	if ( _type == 1 )
	{
		format ( scm_string, sizeof scm_string, "%s победил(а). Игра окончена.", p_info [ winner_id ] [ name ] ) ;
		
		give_money ( winner_id, fool_info [ _b_id ] [ _table ] [ f_bank ] ) ;
		insert_money_log ( winner_id, INVALID_PLAYER_ID, fool_info [ _b_id ] [ _table ] [ f_bank ], "победа дурак" ) ;
		
		for ( new q = 0 ; q < 6 ; q ++ ) 
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] == INVALID_PLAYER_ID ) continue ;
			
			new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] ;
		
			SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
			
			fool_used [ player_id ] = false ;
			fool_table { player_id } = 0 ;
			
			show_fool_ptd ( player_id, _table, false ) ;
			show_cards_ptd ( player_id, false ) ;
			show_koloda_ptd ( player_id, false ) ;
			show_podkid_ptd ( player_id, false ) ;
			show_pokriv_ptd ( player_id, false ) ;
			show_button_ptd ( player_id, -1, false ) ;
			
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_KILL_LIST, true ) ;
			
			SetCameraBehindPlayer ( player_id ) ;
		}
		
		for ( new q = 0 ; q < 6 ; q ++ ) 
		{
			fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] = INVALID_PLAYER_ID ;
			fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ q ] = 0 ;
				
			fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ q ] = 
			fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ q ] = -1 ;
		}
		fool_info [ _b_id ] [ _table ] [ f_move ] = INVALID_PLAYER_ID ;
		fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = INVALID_PLAYER_ID ;
		fool_info [ _b_id ] [ _table ] [ f_card_count ] = 36 ;
		fool_info [ _b_id ] [ _table ] [ f_bank ] = 0 ;
		for ( new q = 0 ; q < 36 ; q ++ ) fool_info [ _b_id ] [ _table ] [ f_card ] [ q ] = 0 ;
		
		if ( ! IsValidDynamic3DTextLabel ( fool_info [ _b_id ] [ _table ] [ f_text ] ) )
		{
			new fool_string [ 200 ] ;
			format ( fool_string, sizeof fool_string, "** Fool Game **\n{"#cGR3D"}Нажмите {"#cWH3D"}F{"#cGR3D"} для взаимодействия\n\n{"#cGR3D"}Игроков: {"#cWH3D"}0/6\n{"#cGR3D"}Ставка: {"#cGN3D"}%d$\n\n{"#cGR3D"}Статус: {"#cRD"}Игра не начата", fool_info [ _b_id ] [ _table ] [ f_bet ] ) ;
			fool_info [ _b_id ] [ _table ] [ f_text ] = CreateDynamic3DTextLabel ( fool_string, col_blue, fool_positions [ _table ] [ 0 ], fool_positions [ _table ] [ 1 ], fool_positions [ _table ] [ 2 ] + 0.5,
																						5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, b_info [ _b_id - 1 ] [ b_id ] + 1000, -1 ) ;
		}
		fool_info [ _b_id ] [ _table ] [ f_status ] = 0 ;
		update_fool_table ( _b_id, _table ) ;
	}
	else if ( _type == 2 )
	{
		format ( scm_string, sizeof scm_string, "%s покинул(а) игру. Игра окончена.", p_info [ winner_id ] [ name ] ) ;
		
		for ( new q = 0 ; q < 6 ; q ++ ) 
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] == INVALID_PLAYER_ID ) continue ;
			
			new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] ;
		
			SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
			
			fool_used [ player_id ] = false ;
			fool_table { player_id } = 0 ;
			
			show_fool_ptd ( player_id, _table, false ) ;
			show_cards_ptd ( player_id, false ) ;
			show_koloda_ptd ( player_id, false ) ;
			show_podkid_ptd ( player_id, false ) ;
			show_pokriv_ptd ( player_id, false ) ;
			show_button_ptd ( player_id, -1, false ) ;
			
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( player_id, HUD_ELEMENT_KILL_LIST, true ) ;
			
			SetCameraBehindPlayer ( player_id ) ;
		}
			
		for ( new q = 0 ; q < 6 ; q ++ ) 
		{
			fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] = INVALID_PLAYER_ID ;
			fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ q ] = 0 ;
				
			fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ q ] = 
			fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ q ] = -1 ;
		}
		fool_info [ _b_id ] [ _table ] [ f_move ] = INVALID_PLAYER_ID ;
		fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = INVALID_PLAYER_ID ;
		fool_info [ _b_id ] [ _table ] [ f_card_count ] = 36 ;
		fool_info [ _b_id ] [ _table ] [ f_bank ] = 0 ;
		for ( new q = 0 ; q < 36 ; q ++ ) fool_info [ _b_id ] [ _table ] [ f_card ] [ q ] = 0 ;
		
		if ( ! IsValidDynamic3DTextLabel ( fool_info [ _b_id ] [ _table ] [ f_text ] ) )
		{
			new fool_string [ 200 ] ;
			format ( fool_string, sizeof fool_string, "** Fool Game **\n{"#cGR3D"}Нажмите {"#cWH3D"}F{"#cGR3D"} для взаимодействия\n\n{"#cGR3D"}Игроков: {"#cWH3D"}0/6\n{"#cGR3D"}Ставка: {"#cGN3D"}%d$\n\n{"#cGR3D"}Статус: {"#cRD"}Игра не начата", fool_info [ _b_id ] [ _table ] [ f_bet ] ) ;
			fool_info [ _b_id ] [ _table ] [ f_text ] = CreateDynamic3DTextLabel ( fool_string, col_blue, fool_positions [ _table ] [ 0 ], fool_positions [ _table ] [ 1 ], fool_positions [ _table ] [ 2 ] + 0.5,
																						5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, b_info [ _b_id - 1 ] [ b_id ] + 1000, -1 ) ;
		}
		
		fool_info [ _b_id ] [ _table ] [ f_status ] = 0 ;
		update_fool_table ( _b_id, _table ) ;
	}
	else if ( _type == 3 )
	{
		format ( scm_string, sizeof scm_string, "%s покинул(а) стол.", p_info [ winner_id ] [ name ] ) ;
		
		fool_table { winner_id } = 0 ;
		SetCameraBehindPlayer ( winner_id ) ;
	
		new _p_count = 0 ;
		for ( new q = 0 ; q < 6 ; q ++ ) 
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] == INVALID_PLAYER_ID ) continue ;
			
			new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] ;
		
			SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
			
			_p_count ++ ;
			if ( player_id == winner_id ) fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] = INVALID_PLAYER_ID ;
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_status ] == 1 )
		{
			give_money ( winner_id, fool_info [ _b_id ] [ _table ] [ f_bet ] ) ;
			insert_money_log ( winner_id, INVALID_PLAYER_ID, fool_info [ _b_id ] [ _table ] [ f_bet ], "ставка дурак" ) ;
			
			fool_info [ _b_id ] [ _table ] [ f_bank ] -= fool_info [ _b_id ] [ _table ] [ f_bet ] ;
		}
		
		if ( _p_count == 1 )
		{
			KillTimer ( fool_info [ _b_id ] [ _table ] [ f_time ] ) ;
			fool_info [ _b_id ] [ _table ] [ f_time ] = -1 ;
			fool_info [ _b_id ] [ _table ] [ f_status ] = 0 ;
			update_fool_table ( _b_id, _table ) ;
		}
	}
	return 1 ;
}

/*CMD:start_fool ( playerid )
{
	fool_table { playerid } = 1 ;
	new _table = fool_table { playerid } ;

	new _p_count = 0 ;
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		_p_count ++ ;
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] != INVALID_PLAYER_ID ) continue ;

		fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] = playerid ;
		break ;
	}

	if ( _p_count > 1 )
	{
	    page_count [ playerid ] = 1 ;
	    fool_info [ _b_id ] [ _table ] [ f_trump ] = give_card ( _table ) ;
	    fool_info [ _b_id ] [ _table ] [ f_team_trump ] = card_team ( fool_info [ _b_id ] [ _table ] [ f_trump ] ) ;
		fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 1 ] ;
		fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
			
			new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
			page_rows [ player_id ] = 6 ;
		}
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;

			new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
			fool_used [ player_id ] = true ;
			show_fool_ptd ( player_id, _table, true ) ;
			
			new scm_string [ 25 + ( MAX_PLAYER_NAME * 2 ) ] ;
			format ( scm_string, sizeof scm_string, "Игра началась. Первым ходит %s на %s.", p_info [ fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] ] [ name ], p_info [ fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] ] [ name ] ) ;
			SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
		}
	}
	return 1 ;
}*/

stock show_fool_player_ptd ( playerid, _type = -1, bool: status )
{
	if ( status )
	{
		new _table = fool_table { playerid } - 1 ;
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ; 
		new td_string [ 20 ] ;
		
		if ( _type == 1 )
		{
			fool_player [ playerid ] [ 0 ] = give_card ( _b_id, _table ) ;
			fool_player [ playerid ] [ 1 ] = give_card ( _b_id, _table ) ;
			fool_player [ playerid ] [ 2 ] = give_card ( _b_id, _table ) ;
			fool_player [ playerid ] [ 3 ] = give_card ( _b_id, _table ) ;
			fool_player [ playerid ] [ 4 ] = give_card ( _b_id, _table ) ;
			fool_player [ playerid ] [ 5 ] = give_card ( _b_id, _table ) ;
		}
		
		new _card_id ;
		if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( 0 + 1 ) ;
		else _card_id = 0 ;
		
		if ( fool_player [ playerid ] [ _card_id ] == -1 ) format ( td_string, sizeof td_string, "ld_card:cdback" ) ;
		else format ( td_string, sizeof td_string, "%s", card_string ( fool_player [ playerid ] [ _card_id ] ) ) ;
		player_cards_PTD [ playerid ] [ 0 ] = CreatePlayerTextDraw(playerid, 181.6665, 371.5332, td_string); // player card 1
		PlayerTextDrawTextSize(playerid, player_cards_PTD [ playerid ] [ 0 ], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, player_cards_PTD [ playerid ] [ 0 ], 1);
		PlayerTextDrawColor(playerid, player_cards_PTD [ playerid ] [ 0 ], -1);
		PlayerTextDrawBackgroundColor(playerid, player_cards_PTD [ playerid ] [ 0 ], 255);
		PlayerTextDrawFont(playerid, player_cards_PTD [ playerid ] [ 0 ], 4);
		PlayerTextDrawSetProportional(playerid, player_cards_PTD [ playerid ] [ 0 ], 0);
		PlayerTextDrawSetShadow(playerid, player_cards_PTD [ playerid ] [ 0 ], 0);
		PlayerTextDrawSetSelectable(playerid, player_cards_PTD [ playerid ] [ 0 ], true);
		
		if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( 1 + 1 ) ;
		else _card_id = 1 ;

		if ( fool_player [ playerid ] [ _card_id ] == -1 ) format ( td_string, sizeof td_string, "ld_card:cdback" ) ;
		else format ( td_string, sizeof td_string, "%s", card_string ( fool_player [ playerid ] [ _card_id ] ) ) ;
		player_cards_PTD [ playerid ] [ 1 ] = CreatePlayerTextDraw(playerid, 228.3674, 371.5480, td_string); // player card 2
		PlayerTextDrawTextSize(playerid, player_cards_PTD [ playerid ] [ 1 ], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, player_cards_PTD [ playerid ] [ 1 ], 1);
		PlayerTextDrawColor(playerid, player_cards_PTD [ playerid ] [ 1 ], -1);
		PlayerTextDrawBackgroundColor(playerid, player_cards_PTD [ playerid ] [ 1 ], 255);
		PlayerTextDrawFont(playerid, player_cards_PTD [ playerid ] [ 1 ], 4);
		PlayerTextDrawSetProportional(playerid, player_cards_PTD [ playerid ] [ 1 ], 0);
		PlayerTextDrawSetShadow(playerid, player_cards_PTD [ playerid ] [ 1 ], 0);
		PlayerTextDrawSetSelectable(playerid, player_cards_PTD [ playerid ] [ 1 ], true);

		if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( 2 + 1 ) ;
		else _card_id = 2 ;

		if ( fool_player [ playerid ] [ _card_id ] == -1 ) format ( td_string, sizeof td_string, "ld_card:cdback" ) ;
		else format ( td_string, sizeof td_string, "%s", card_string ( fool_player [ playerid ] [ _card_id ] ) ) ;
		player_cards_PTD [ playerid ] [ 2 ] = CreatePlayerTextDraw(playerid, 275.6665, 371.5332, td_string); // player card 3
		PlayerTextDrawTextSize(playerid, player_cards_PTD [ playerid ] [ 2 ], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, player_cards_PTD [ playerid ] [ 2 ], 1);
		PlayerTextDrawColor(playerid, player_cards_PTD [ playerid ] [ 2 ], -1);
		PlayerTextDrawBackgroundColor(playerid, player_cards_PTD [ playerid ] [ 2 ], 255);
		PlayerTextDrawFont(playerid, player_cards_PTD [ playerid ] [ 2 ], 4);
		PlayerTextDrawSetProportional(playerid, player_cards_PTD [ playerid ] [ 2 ], 0);
		PlayerTextDrawSetShadow(playerid, player_cards_PTD [ playerid ] [ 2 ], 0);
		PlayerTextDrawSetSelectable(playerid, player_cards_PTD [ playerid ] [ 2 ], true);

		if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( 3 + 1 ) ;
		else _card_id = 3 ;

		if ( fool_player [ playerid ] [ _card_id ] == -1 ) format ( td_string, sizeof td_string, "ld_card:cdback" ) ;
		else format ( td_string, sizeof td_string, "%s", card_string ( fool_player [ playerid ] [ _card_id ] ) ) ;
		player_cards_PTD [ playerid ] [ 3 ] = CreatePlayerTextDraw(playerid, 322.7007, 371.9630, td_string); // player card 4
		PlayerTextDrawTextSize(playerid, player_cards_PTD [ playerid ] [ 3 ], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, player_cards_PTD [ playerid ] [ 3 ], 1);
		PlayerTextDrawColor(playerid, player_cards_PTD [ playerid ] [ 3 ], -1);
		PlayerTextDrawBackgroundColor(playerid, player_cards_PTD [ playerid ] [ 3 ], 255);
		PlayerTextDrawFont(playerid, player_cards_PTD [ playerid ] [ 3 ], 4);
		PlayerTextDrawSetProportional(playerid, player_cards_PTD [ playerid ] [ 3 ], 0);
		PlayerTextDrawSetShadow(playerid, player_cards_PTD [ playerid ] [ 3 ], 0);
		PlayerTextDrawSetSelectable(playerid, player_cards_PTD [ playerid ] [ 3 ], true);

		if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( 4 + 1 ) ;
		else _card_id = 4 ;

		if ( fool_player [ playerid ] [ _card_id ] == -1 ) format ( td_string, sizeof td_string, "ld_card:cdback" ) ;
		else format ( td_string, sizeof td_string, "%s", card_string ( fool_player [ playerid ] [ _card_id ] ) ) ;
		player_cards_PTD [ playerid ] [ 4 ] = CreatePlayerTextDraw(playerid, 369.9996, 371.9482, td_string); // player card 5
		PlayerTextDrawTextSize(playerid, player_cards_PTD [ playerid ] [ 4 ], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, player_cards_PTD [ playerid ] [ 4 ], 1);
		PlayerTextDrawColor(playerid, player_cards_PTD [ playerid ] [ 4 ], -1);
		PlayerTextDrawBackgroundColor(playerid, player_cards_PTD [ playerid ] [ 4 ], 255);
		PlayerTextDrawFont(playerid, player_cards_PTD [ playerid ] [ 4 ], 4);
		PlayerTextDrawSetProportional(playerid, player_cards_PTD [ playerid ] [ 4 ], 0);
		PlayerTextDrawSetShadow(playerid, player_cards_PTD [ playerid ] [ 4 ], 0);
		PlayerTextDrawSetSelectable(playerid, player_cards_PTD [ playerid ] [ 4 ], true);

		if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( 5 + 1 ) ;
		else _card_id = 5 ;

		if ( fool_player [ playerid ] [ _card_id ] == -1 ) format ( td_string, sizeof td_string, "ld_card:cdback" ) ;
		else format ( td_string, sizeof td_string, "%s", card_string ( fool_player [ playerid ] [ _card_id ] ) ) ;
		player_cards_PTD [ playerid ] [ 5 ] = CreatePlayerTextDraw(playerid, 417.0343, 371.9630, td_string); // player card 6
		PlayerTextDrawTextSize(playerid, player_cards_PTD [ playerid ] [ 5 ], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, player_cards_PTD [ playerid ] [ 5 ], 1);
		PlayerTextDrawColor(playerid, player_cards_PTD [ playerid ] [ 5 ], -1);
		PlayerTextDrawBackgroundColor(playerid, player_cards_PTD [ playerid ] [ 5 ], 255);
		PlayerTextDrawFont(playerid, player_cards_PTD [ playerid ] [ 5 ], 4);
		PlayerTextDrawSetProportional(playerid, player_cards_PTD [ playerid ] [ 5 ], 0);
		PlayerTextDrawSetShadow(playerid, player_cards_PTD [ playerid ] [ 5 ], 0);
		PlayerTextDrawSetSelectable(playerid, player_cards_PTD [ playerid ] [ 5 ], true);
		
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, player_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, player_cards_PTD [ playerid ] [ i ] ) ;
			player_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock give_card ( _b_id, _table )
{
	new _random, _c_count = 0 ;
	do
	{
		_random = random ( 36 ) ;
		_c_count ++ ;
	}
	while ( fool_info [ _b_id ] [ _table ] [ f_card ] [ _random ] == 1 && _c_count < 6 ) ;
	
	if ( fool_info [ _b_id ] [ _table ] [ f_card ] [ _random ] == 1 )
	{
		for ( new i = 0 ; i < 36 ; i ++ )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_card ] [ i ] == 1 ) continue ;
			
			fool_info [ _b_id ] [ _table ] [ f_card_count ] -- ;
			fool_info [ _b_id ] [ _table ] [ f_card ] [ i ] = 1 ;
			
			if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] == 1 )
			{
				if ( fool_info [ _b_id ] [ _table ] [ f_trump ] != -1 )
				{
					new _card_id = fool_info [ _b_id ] [ _table ] [ f_trump ] ;
					
					fool_info [ _b_id ] [ _table ] [ f_trump ] = -1 ;
					fool_info [ _b_id ] [ _table ] [ f_card ] [ _card_id ] = 0 ;
				}
			}
			return i ;
		}
	}
	else 
	{
		fool_info [ _b_id ] [ _table ] [ f_card_count ] -- ;
		fool_info [ _b_id ] [ _table ] [ f_card ] [ _random ] = 1 ;
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] == 1 )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_trump ] != -1 )
			{
				new _card_id = fool_info [ _b_id ] [ _table ] [ f_trump ] ;
				
				fool_info [ _b_id ] [ _table ] [ f_trump ] = -1 ;
				fool_info [ _b_id ] [ _table ] [ f_card ] [ _card_id ] = 0 ;
			}
		}
		return _random ;
	}
	return -1 ;
}

stock show_button_ptd ( playerid, _type, bool: status )
{
	if ( status )
	{
		button_take_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 291.3333, 257.8740, "ld_beat:chit"); // пусто
		PlayerTextDrawTextSize(playerid, button_take_PTD[playerid][0], 23.0000, 27.0000);
		PlayerTextDrawAlignment(playerid, button_take_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, button_take_PTD[playerid][0], -5963521);
		PlayerTextDrawBackgroundColor(playerid, button_take_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, button_take_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, button_take_PTD[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, button_take_PTD[playerid][0], 0);

		button_take_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 322.3667, 257.8740, "ld_beat:chit"); // пусто
		PlayerTextDrawTextSize(playerid, button_take_PTD[playerid][1], 23.0000, 27.0000);
		PlayerTextDrawAlignment(playerid, button_take_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, button_take_PTD[playerid][1], -5963521);
		PlayerTextDrawBackgroundColor(playerid, button_take_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, button_take_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, button_take_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, button_take_PTD[playerid][1], 0);

		button_take_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 303.6666, 262.4370, "ld_spac:white"); // пусто
		PlayerTextDrawTextSize(playerid, button_take_PTD[playerid][2], 31.0000, 17.8199);
		PlayerTextDrawAlignment(playerid, button_take_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, button_take_PTD[playerid][2], -5963521);
		PlayerTextDrawBackgroundColor(playerid, button_take_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, button_take_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, button_take_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, button_take_PTD[playerid][2], 0);

		if ( _type == 1 ) button_take_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 317.9999, 264.6666, "BIT"); // пусто
		else if ( _type == 2 ) button_take_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 317.9999, 264.6666, "TAKE"); // пусто
		PlayerTextDrawLetterSize(playerid, button_take_PTD[playerid][3], 0.2019, 1.2847);
		PlayerTextDrawTextSize(playerid, button_take_PTD[playerid][3], 10.0000, 45.0000);
		PlayerTextDrawAlignment(playerid, button_take_PTD[playerid][3], 2);
		PlayerTextDrawColor(playerid, button_take_PTD[playerid][3], 437918463);
		PlayerTextDrawUseBox(playerid, button_take_PTD[playerid][3], 1);
		PlayerTextDrawBoxColor(playerid, button_take_PTD[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, button_take_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, button_take_PTD[playerid][3], 2);
		PlayerTextDrawSetProportional(playerid, button_take_PTD[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, button_take_PTD[playerid][3], 0);
		PlayerTextDrawSetSelectable(playerid, button_take_PTD[playerid][3], true);
	
		for ( new i = 0 ; i < 4 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, button_take_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 4 ; i ++ )
		{
			if ( button_take_PTD [ playerid ] [ i ] == PlayerText:-1 ) continue ;
		
			PlayerTextDrawDestroy ( playerid, button_take_PTD [ playerid ] [ i ] ) ;
			button_take_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock show_cards_ptd ( playerid, bool: status )
{
	if ( status )
	{
		cards_background_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 450.0000, 441.6365, "ld_spac:white"); // пусто
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][0], 13.9195, 1.7000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][0], -5963521);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][0], 0);

		cards_background_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 463.6665, 425.0440, "ld_spac:white"); // пусто
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][1], 1.5599, 18.0000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][1], -5963521);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][1], 0);

		cards_background_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 175.6667, 364.4812, "ld_spac:white"); // пусто
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][2], 13.9195, 1.7000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][2], -5963521);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][2], 0);

		cards_background_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 175.6667, 364.4812, "ld_spac:white"); // пусто
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][3], 1.5599, 18.0000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][3], -5963521);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][3], 0);

		cards_background_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 129.3332, 386.0516, "ld_beat:chit"); // пусто
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][4], 29.0000, 36.0000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][4], -5963521);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][4], 0);

		cards_background_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 143.3332, 394.9183, "<"); // пусто
		PlayerTextDrawLetterSize(playerid, cards_background_PTD[playerid][5], 0.1666, 1.8609);
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][5], 10.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][5], 2);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][5], 437918463);
		PlayerTextDrawUseBox(playerid, cards_background_PTD[playerid][5], 1);
		PlayerTextDrawBoxColor(playerid, cards_background_PTD[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][5], 2);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][5], 1);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][5], 0);
		PlayerTextDrawSetSelectable(playerid, cards_background_PTD[playerid][5], true);

		cards_background_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 481.7004, 385.8630, "ld_beat:chit"); // пусто
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][6], 29.0000, 36.0000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][6], -5963521);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][6], 0);

		cards_background_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 497.1004, 394.7297, ">"); // пусто
		PlayerTextDrawLetterSize(playerid, cards_background_PTD[playerid][7], 0.1666, 1.8609);
		PlayerTextDrawTextSize(playerid, cards_background_PTD[playerid][7], 10.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, cards_background_PTD[playerid][7], 2);
		PlayerTextDrawColor(playerid, cards_background_PTD[playerid][7], 437918463);
		PlayerTextDrawUseBox(playerid, cards_background_PTD[playerid][7], 1);
		PlayerTextDrawBoxColor(playerid, cards_background_PTD[playerid][7], 0);
		PlayerTextDrawBackgroundColor(playerid, cards_background_PTD[playerid][7], 255);
		PlayerTextDrawFont(playerid, cards_background_PTD[playerid][7], 2);
		PlayerTextDrawSetProportional(playerid, cards_background_PTD[playerid][7], 1);
		PlayerTextDrawSetShadow(playerid, cards_background_PTD[playerid][7], 0);
		PlayerTextDrawSetSelectable(playerid, cards_background_PTD[playerid][7], true);
		
		for ( new i = 0 ; i < 8 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, cards_background_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 8 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, cards_background_PTD [ playerid ] [ i ] ) ;
			cards_background_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock show_koloda_ptd ( playerid, bool: status )
{
	if ( status )
	{
		new _table = fool_table { playerid } - 1, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		new td_string [ 20 ] ;
		
		if ( fool_info [ _b_id ] [ _table ] [ f_trump ] != -1 )
		{
			format ( td_string, sizeof td_string, "%s", card_string ( fool_info [ _b_id ] [ _table ] [ f_trump ] ) ) ;
			koloda_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 9.7010, 157.0888, td_string); // kozir'
			PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][0], 46.0000, 66.0000);
			PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][0], 1);
			PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][0], -1);
			PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][0], 255);
			PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][0], 4);
			PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][0], 0);
			PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][0], 0);
		}

		koloda_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 6.0335, 259.4713, "ld_beat:chit"); // пусто
		PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][1], 23.0000, 30.0000);
		PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][1], -5963521);
		PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][1], 0);

		koloda_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 36.9337, 259.4713, "ld_beat:chit"); // пусто
		PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][2], 23.0000, 30.0000);
		PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][2], -5963521);
		PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][2], 0);

		koloda_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 18.3332, 264.3110, "ld_spac:white"); // пусто
		PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][3], 31.0000, 20.1098);
		PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][3], -5963521);
		PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][3], 0);

		format ( td_string, sizeof td_string, "CARDS:_%d", fool_info [ _b_id ] [ _table ] [ f_card_count ] ) ;
		koloda_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 32.9999, 268.8146, td_string); // пусто
		PlayerTextDrawLetterSize(playerid, koloda_cards_PTD[playerid][4], 0.1640, 1.0856);
		PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][4], 2);
		PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][4], 437918463);
		PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][4], 2);
		PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][4], 1);
		PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][4], 0);

		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] > 0 )
		{
			koloda_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 9.7009, 176.1703, "ld_card:cdback"); // left cards
			PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][5], 46.0000, 74.0000);
			PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][5], 1);
			PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][5], -1);
			PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][5], 255);
			PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][5], 4);
			PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][5], 0);
			PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][5], 0);
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] > 1 )
		{
			koloda_cards_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 9.7009, 181.1481, "ld_card:cdback"); // left cards
			PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][6], 46.0000, 74.0000);
			PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][6], 1);
			PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][6], -1);
			PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][6], 255);
			PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][6], 4);
			PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][6], 0);
			PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][6], 0);
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] > 2 )
		{
			koloda_cards_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 9.7009, 186.1259, "ld_card:cdback"); // left cards
			PlayerTextDrawTextSize(playerid, koloda_cards_PTD[playerid][7], 46.0000, 74.0000);
			PlayerTextDrawAlignment(playerid, koloda_cards_PTD[playerid][7], 1);
			PlayerTextDrawColor(playerid, koloda_cards_PTD[playerid][7], -1);
			PlayerTextDrawBackgroundColor(playerid, koloda_cards_PTD[playerid][7], 255);
			PlayerTextDrawFont(playerid, koloda_cards_PTD[playerid][7], 4);
			PlayerTextDrawSetProportional(playerid, koloda_cards_PTD[playerid][7], 0);
			PlayerTextDrawSetShadow(playerid, koloda_cards_PTD[playerid][7], 0);
		}
	
		for ( new i = 0 ; i < 8 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, koloda_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 8 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, koloda_cards_PTD [ playerid ] [ i ] ) ;
			koloda_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock show_pokriv_ptd ( playerid, bool: status )
{
	if ( status )
	{
		pokriv_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 164.3332, 182.7926, "ld_card:cd2d"); // card 1 pokrili
		PlayerTextDrawTextSize(playerid, pokriv_cards_PTD[playerid][0], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, pokriv_cards_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, pokriv_cards_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, pokriv_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, pokriv_cards_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, pokriv_cards_PTD[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, pokriv_cards_PTD[playerid][0], 0);

		pokriv_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 219.0339, 182.8074, "ld_card:cd2d"); // card 2 pokrili
		PlayerTextDrawTextSize(playerid, pokriv_cards_PTD[playerid][1], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, pokriv_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, pokriv_cards_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, pokriv_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, pokriv_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, pokriv_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, pokriv_cards_PTD[playerid][1], 0);

		pokriv_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 274.0000, 182.7926, "ld_card:cd2d"); // card 3 pokrili
		PlayerTextDrawTextSize(playerid, pokriv_cards_PTD[playerid][2], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, pokriv_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, pokriv_cards_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, pokriv_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, pokriv_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, pokriv_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, pokriv_cards_PTD[playerid][2], 0);

		pokriv_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 328.7005, 182.8074, "ld_card:cd2d"); // card 4 pokrili
		PlayerTextDrawTextSize(playerid, pokriv_cards_PTD[playerid][3], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, pokriv_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, pokriv_cards_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, pokriv_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, pokriv_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, pokriv_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, pokriv_cards_PTD[playerid][3], 0);

		pokriv_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 385.3330, 182.7926, "ld_card:cd2d"); // card 5 pokrili
		PlayerTextDrawTextSize(playerid, pokriv_cards_PTD[playerid][4], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, pokriv_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, pokriv_cards_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, pokriv_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, pokriv_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, pokriv_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, pokriv_cards_PTD[playerid][4], 0);

		pokriv_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 440.0343, 182.8074, "ld_card:cd2d"); // card 6 pokrili
		PlayerTextDrawTextSize(playerid, pokriv_cards_PTD[playerid][5], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, pokriv_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, pokriv_cards_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, pokriv_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, pokriv_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, pokriv_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, pokriv_cards_PTD[playerid][5], 0);
	}
	else
	{
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, pokriv_cards_PTD [ playerid ] [ i ] ) ;
			pokriv_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock show_podkid_ptd ( playerid, bool: status )
{
	if ( status )
	{
		podkid_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 156.3332, 174.4963, "ld_card:cd2d"); // card 1 podkid
		PlayerTextDrawTextSize(playerid, podkid_cards_PTD[playerid][0], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, podkid_cards_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, podkid_cards_PTD[playerid][0], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, podkid_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, podkid_cards_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, podkid_cards_PTD[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, podkid_cards_PTD[playerid][0], 0);

		podkid_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 211.0339, 174.5110, "ld_card:cd2d"); // card 2 podkid
		PlayerTextDrawTextSize(playerid, podkid_cards_PTD[playerid][1], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, podkid_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, podkid_cards_PTD[playerid][1], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, podkid_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, podkid_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, podkid_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, podkid_cards_PTD[playerid][1], 0);

		podkid_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 266.0000, 174.4963, "ld_card:cd2d"); // card 3 podkid
		PlayerTextDrawTextSize(playerid, podkid_cards_PTD[playerid][2], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, podkid_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, podkid_cards_PTD[playerid][2], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, podkid_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, podkid_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, podkid_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, podkid_cards_PTD[playerid][2], 0);

		podkid_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 320.7005, 174.5110, "ld_card:cd2d"); // card 4 podkid
		PlayerTextDrawTextSize(playerid, podkid_cards_PTD[playerid][3], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, podkid_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, podkid_cards_PTD[playerid][3], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, podkid_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, podkid_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, podkid_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, podkid_cards_PTD[playerid][3], 0);

		podkid_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 377.3330, 174.4963, "ld_card:cd2d"); // card 5 podkid
		PlayerTextDrawTextSize(playerid, podkid_cards_PTD[playerid][4], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, podkid_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, podkid_cards_PTD[playerid][4], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, podkid_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, podkid_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, podkid_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, podkid_cards_PTD[playerid][4], 0);

		podkid_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 432.0343, 174.5110, "ld_card:cd2d"); // card 6 podkid
		PlayerTextDrawTextSize(playerid, podkid_cards_PTD[playerid][5], 41.0000, 64.0000);
		PlayerTextDrawAlignment(playerid, podkid_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, podkid_cards_PTD[playerid][5], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, podkid_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, podkid_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, podkid_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, podkid_cards_PTD[playerid][5], 0);
	}
	else
	{
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, podkid_cards_PTD [ playerid ] [ i ] ) ;
			podkid_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock show_fool_ptd ( playerid, _table, bool: status )
{
	if ( status )
	{
		new _c_count = 0, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		for ( new p = 0 ; p < 6 ; p ++ )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] == playerid ) 
			{
				show_fool_player_ptd ( playerid, 1, true ) ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] != INVALID_PLAYER_ID && _c_count == 0 )
			{
				show_fool_enemy_1 ( playerid, _table, p, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] != INVALID_PLAYER_ID && _c_count == 1 )
			{
				show_fool_enemy_2 ( playerid, _table, p, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] != INVALID_PLAYER_ID && _c_count == 2 )
			{
				show_fool_enemy_3 ( playerid, _table, p, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] != INVALID_PLAYER_ID && _c_count == 3 )
			{
				show_fool_enemy_4 ( playerid, _table, p, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] != INVALID_PLAYER_ID && _c_count == 4 )
			{
				show_fool_enemy_5 ( playerid, _table, p, true ) ;
				
				_c_count ++ ;
				continue ;
			}
		}

		SetTimerEx ( "card_start", 2000, false, "i", playerid ) ;
		TogglePlayerControllable ( playerid, false ) ;
		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
		show_fool_enemy_1 ( playerid, _table, -1, false ) ;
		show_fool_enemy_2 ( playerid, _table, -1, false ) ;
		show_fool_enemy_3 ( playerid, _table, -1, false ) ;
		show_fool_enemy_4 ( playerid, _table, -1, false ) ;
		show_fool_enemy_5 ( playerid, _table, -1, false ) ;
		show_fool_player_ptd ( playerid, -1, false ) ;
		TogglePlayerControllable ( playerid, true ) ;
		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

callback: card_start ( playerid )
{
	if ( fool_table { playerid } < 1 ) return 1 ;
	
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;

	show_cards_ptd ( playerid, true ) ;
	show_koloda_ptd ( playerid, true ) ;
	show_podkid_ptd ( playerid, true ) ;
	show_pokriv_ptd ( playerid, true ) ;
	return 1 ;
}

stock show_fool_enemy_1 ( playerid, _table, _position, bool: status )
{
	if ( status )
	{
		new td_string [ MAX_PLAYER_NAME + 2 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		format ( td_string, sizeof td_string, "%s", p_info [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] [ name ] ) ;
			
		enemy1_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 108.9999, 64.3106, td_string); // player 1 nick
		PlayerTextDrawLetterSize(playerid, enemy1_cards_PTD[playerid][0], 0.2230, 1.0729);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][0], 0);

		enemy1_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 78.0337, 9.4140, "ld_card:cdback"); // player 1 cards 1
		PlayerTextDrawTextSize(playerid, enemy1_cards_PTD[playerid][1], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][1], 0);

		enemy1_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 83.7005, 9.6289, "ld_card:cdback"); // player 1 cards 2
		PlayerTextDrawTextSize(playerid, enemy1_cards_PTD[playerid][2], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][2], 0);

		enemy1_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 89.6009, 9.6289, "ld_card:cdback"); // player 1 cards 3
		PlayerTextDrawTextSize(playerid, enemy1_cards_PTD[playerid][3], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][3], 0);

		enemy1_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 95.6009, 9.5291, "ld_card:cdback"); // player 1 cards 4
		PlayerTextDrawTextSize(playerid, enemy1_cards_PTD[playerid][4], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][4], 0);

		enemy1_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 101.4017, 9.5291, "ld_card:cdback"); // player 1 cards 5
		PlayerTextDrawTextSize(playerid, enemy1_cards_PTD[playerid][5], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][5], 0);

		enemy1_cards_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 107.1018, 9.5291, "ld_card:cdback"); // player 1 cards 6
		PlayerTextDrawTextSize(playerid, enemy1_cards_PTD[playerid][6], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy1_cards_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, enemy1_cards_PTD[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy1_cards_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, enemy1_cards_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, enemy1_cards_PTD[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, enemy1_cards_PTD[playerid][6], 0);
		
		
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( page_rows [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] < i ) continue ;
			PlayerTextDrawShow ( playerid, enemy1_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( enemy1_cards_PTD [ playerid ] [ i ] != PlayerText:-1 )
			{
				PlayerTextDrawDestroy ( playerid, enemy1_cards_PTD [ playerid ] [ i ] ) ;
				enemy1_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
	}
	return 1 ;
}

stock show_fool_enemy_2 ( playerid, _table, _position, bool: status )
{
	if ( status )
	{
		new td_string [ MAX_PLAYER_NAME + 2 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		format ( td_string, sizeof td_string, "%s", p_info [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] [ name ] ) ;
			
		enemy2_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 210.9998, 64.2254, td_string); // player 2 nick
		PlayerTextDrawLetterSize(playerid, enemy2_cards_PTD[playerid][0], 0.2230, 1.0729);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][0], 0);

		enemy2_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 180.0339, 9.3291, "ld_card:cdback"); // player 2 cards 1
		PlayerTextDrawTextSize(playerid, enemy2_cards_PTD[playerid][1], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][1], 0);

		enemy2_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 185.7005, 9.5439, "ld_card:cdback"); // player 2 cards 2
		PlayerTextDrawTextSize(playerid, enemy2_cards_PTD[playerid][2], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][2], 0);

		enemy2_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 191.6011, 9.5439, "ld_card:cdback"); // player 2 cards 3
		PlayerTextDrawTextSize(playerid, enemy2_cards_PTD[playerid][3], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][3], 0);

		enemy2_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 197.6015, 9.4436, "ld_card:cdback"); // player 2 cards 4
		PlayerTextDrawTextSize(playerid, enemy2_cards_PTD[playerid][4], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][4], 0);

		enemy2_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 203.4015, 9.4436, "ld_card:cdback"); // player 2 cards 5
		PlayerTextDrawTextSize(playerid, enemy2_cards_PTD[playerid][5], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][5], 0);

		enemy2_cards_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 209.1020, 9.4436, "ld_card:cdback"); // player 2 cards 6
		PlayerTextDrawTextSize(playerid, enemy2_cards_PTD[playerid][6], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy2_cards_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, enemy2_cards_PTD[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy2_cards_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, enemy2_cards_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, enemy2_cards_PTD[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, enemy2_cards_PTD[playerid][6], 0);
	
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( page_rows [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] < i ) continue ;
			PlayerTextDrawShow ( playerid, enemy2_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( enemy2_cards_PTD [ playerid ] [ i ] != PlayerText:-1 )
			{
				PlayerTextDrawDestroy ( playerid, enemy2_cards_PTD [ playerid ] [ i ] ) ;
				enemy2_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
	}
	return 1 ;
}

stock show_fool_enemy_3 ( playerid, _table, _position, bool: status )
{
	if ( status )
	{
		new td_string [ MAX_PLAYER_NAME + 2 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		format ( td_string, sizeof td_string, "%s", p_info [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] [ name ] ) ;
			
		enemy3_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 316.6669, 64.3106, td_string); // player 3 nick
		PlayerTextDrawLetterSize(playerid, enemy3_cards_PTD[playerid][0], 0.2230, 1.0729);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][0], 0);

		enemy3_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 285.7008, 9.4141, "ld_card:cdback"); // player 3 cards 1
		PlayerTextDrawTextSize(playerid, enemy3_cards_PTD[playerid][1], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][1], 0);

		enemy3_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 291.3674, 9.6290, "ld_card:cdback"); // player 3 cards 2
		PlayerTextDrawTextSize(playerid, enemy3_cards_PTD[playerid][2], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][2], 0);

		enemy3_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 297.2680, 9.6290, "ld_card:cdback"); // player 3 cards 3
		PlayerTextDrawTextSize(playerid, enemy3_cards_PTD[playerid][3], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][3], 0);

		enemy3_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 303.2684, 9.5291, "ld_card:cdback"); // player 3 cards 4
		PlayerTextDrawTextSize(playerid, enemy3_cards_PTD[playerid][4], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][4], 0);

		enemy3_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 309.0686, 9.5291, "ld_card:cdback"); // player 3 cards 5
		PlayerTextDrawTextSize(playerid, enemy3_cards_PTD[playerid][5], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][5], 0);

		enemy3_cards_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 314.7691, 9.5291, "ld_card:cdback"); // player 3 cards 6
		PlayerTextDrawTextSize(playerid, enemy3_cards_PTD[playerid][6], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy3_cards_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, enemy3_cards_PTD[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy3_cards_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, enemy3_cards_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, enemy3_cards_PTD[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, enemy3_cards_PTD[playerid][6], 0);
	
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( page_rows [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] < i ) continue ;
			PlayerTextDrawShow ( playerid, enemy3_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( enemy3_cards_PTD [ playerid ] [ i ] != PlayerText:-1 )
			{
				PlayerTextDrawDestroy ( playerid, enemy3_cards_PTD [ playerid ] [ i ] ) ;
				enemy3_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
	}
	return 1 ;
}

stock show_fool_enemy_4 ( playerid, _table, _position, bool: status )
{
	if ( status )
	{
		new td_string [ MAX_PLAYER_NAME + 2 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		format ( td_string, sizeof td_string, "%s", p_info [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] [ name ] ) ;
			
		enemy4_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 422.5332, 64.6399, td_string); // player 4 nick
		PlayerTextDrawLetterSize(playerid, enemy4_cards_PTD[playerid][0], 0.2230, 1.0729);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][0], 0);

		enemy4_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 391.5674, 9.7440, "ld_card:cdback"); // player 4 cards 1
		PlayerTextDrawTextSize(playerid, enemy4_cards_PTD[playerid][1], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][1], 0);

		enemy4_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 397.2337, 9.9589, "ld_card:cdback"); // player 4 cards 2
		PlayerTextDrawTextSize(playerid, enemy4_cards_PTD[playerid][2], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][2], 0);

		enemy4_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 403.1346, 9.9589, "ld_card:cdback"); // player 4 cards 3
		PlayerTextDrawTextSize(playerid, enemy4_cards_PTD[playerid][3], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][3], 0);

		enemy4_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 409.1346, 9.8589, "ld_card:cdback"); // player 4 cards 4
		PlayerTextDrawTextSize(playerid, enemy4_cards_PTD[playerid][4], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][4], 0);

		enemy4_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 414.9349, 9.8589, "ld_card:cdback"); // player 4 cards 5
		PlayerTextDrawTextSize(playerid, enemy4_cards_PTD[playerid][5], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][5], 0);

		enemy4_cards_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 420.6354, 9.8589, "ld_card:cdback"); // player 4 cards 6
		PlayerTextDrawTextSize(playerid, enemy4_cards_PTD[playerid][6], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy4_cards_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, enemy4_cards_PTD[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy4_cards_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, enemy4_cards_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, enemy4_cards_PTD[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, enemy4_cards_PTD[playerid][6], 0);
	
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( page_rows [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] < i ) continue ;
			PlayerTextDrawShow ( playerid, enemy4_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( enemy4_cards_PTD [ playerid ] [ i ] != PlayerText:-1 )
			{
				PlayerTextDrawDestroy ( playerid, enemy4_cards_PTD [ playerid ] [ i ] ) ;
				enemy4_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
	}
	return 1 ;
}

stock show_fool_enemy_5 ( playerid, _table, _position, bool: status )
{
	if ( status )
	{
		new td_string [ MAX_PLAYER_NAME + 2 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		format ( td_string, sizeof td_string, "%s", p_info [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] [ name ] ) ;
			
		enemy5_cards_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 524.5324, 64.5550, td_string); // player 5 nick
		PlayerTextDrawLetterSize(playerid, enemy5_cards_PTD[playerid][0], 0.2230, 1.0729);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][0], 0);

		enemy5_cards_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 493.5671, 9.6590, "ld_card:cdback"); // player 5 cards 1
		PlayerTextDrawTextSize(playerid, enemy5_cards_PTD[playerid][1], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][1], 0);

		enemy5_cards_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 499.2333, 9.8738, "ld_card:cdback"); // player 5 cards 2
		PlayerTextDrawTextSize(playerid, enemy5_cards_PTD[playerid][2], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][2], 0);

		enemy5_cards_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 505.1340, 9.8738, "ld_card:cdback"); // player 5 cards 3
		PlayerTextDrawTextSize(playerid, enemy5_cards_PTD[playerid][3], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][3], 0);

		enemy5_cards_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 511.1343, 9.7735, "ld_card:cdback"); // player 5 cards 4
		PlayerTextDrawTextSize(playerid, enemy5_cards_PTD[playerid][4], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][4], 0);

		enemy5_cards_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 516.9343, 9.7735, "ld_card:cdback"); // player 5 cards 5
		PlayerTextDrawTextSize(playerid, enemy5_cards_PTD[playerid][5], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][5], 0);

		enemy5_cards_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 522.6348, 9.7735, "ld_card:cdback"); // player 5 cards 6
		PlayerTextDrawTextSize(playerid, enemy5_cards_PTD[playerid][6], 32.0000, 53.0000);
		PlayerTextDrawAlignment(playerid, enemy5_cards_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, enemy5_cards_PTD[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, enemy5_cards_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, enemy5_cards_PTD[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, enemy5_cards_PTD[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, enemy5_cards_PTD[playerid][6], 0);
	
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( page_rows [ fool_info [ _b_id ] [ _table ] [ f_player ] [ _position ] ] < i ) continue ;
			PlayerTextDrawShow ( playerid, enemy5_cards_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			if ( enemy5_cards_PTD [ playerid ] [ i ] != PlayerText:-1 )
			{
				PlayerTextDrawDestroy ( playerid, enemy5_cards_PTD [ playerid ] [ i ] ) ;
				enemy5_cards_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
	}
	return 1 ;
}

stock card_team ( _card_id )
{
	new card_value = 0 ;
	switch ( _card_id )
	{
		case 0,4,8,12,16,20,24,28,32: card_value = 1 ; // крести
		case 1,5,9,13,17,21,25,29,33: card_value = 2 ; // черви
		case 2,6,10,14,18,22,26,30,34: card_value = 3 ; // пики
		case 3,7,11,15,19,23,27,31,35: card_value = 4 ; // бубны
	}
	return card_value ;
}

stock card_score ( _card_id )
{
	new card_value = 0 ;
	switch ( _card_id )
	{
		case 0..3: card_value = 6 ; // шохи
		case 4..7: card_value = 7 ; // семёрки
		case 8..11: card_value = 8 ; // восьмёрки
		case 12..15: card_value = 9 ; // девятки
		case 16..19: card_value = 10 ; // десятки
		case 20..23: card_value = 11 ; // вальты
		case 24..27: card_value = 12 ; // дамы
		case 28..31: card_value = 13 ; // кинги
		case 32..35: card_value = 14 ; // тузы
	}
	return card_value ;
}

stock card_string ( _card_id )
{
	new card_namination [ 16 ] ;
	switch (_card_id )
	{
		case 0: card_namination = "ld_card:cd6c" ; // шесторки, как вальты, но более пидорестичнее
		case 1: card_namination = "ld_card:cd6h" ;
		case 2: card_namination = "ld_card:cd6s" ;
		case 3: card_namination = "ld_card:cd6d" ;
		case 4: card_namination = "ld_card:cd7c" ; // семёрки
		case 5: card_namination = "ld_card:cd7h" ;
		case 6: card_namination = "ld_card:cd7s" ;
		case 7: card_namination = "ld_card:cd7d" ;
		case 8: card_namination = "ld_card:cd8c" ; // восьмёрки
		case 9: card_namination = "ld_card:cd8h" ;
		case 10: card_namination = "ld_card:cd8s" ;
		case 11: card_namination = "ld_card:cd8d" ;
		case 12: card_namination = "ld_card:cd9c" ; // девятки
		case 13: card_namination = "ld_card:cd9h" ;
		case 14: card_namination = "ld_card:cd9s" ;
		case 15: card_namination = "ld_card:cd9d" ;
		case 16: card_namination = "ld_card:cd10c" ; // чирики
		case 17: card_namination = "ld_card:cd10h" ;
		case 18: card_namination = "ld_card:cd10s" ;
		case 19: card_namination = "ld_card:cd10d" ;
		case 20: card_namination = "ld_card:cd11c" ; // вальты ебучие
		case 21: card_namination = "ld_card:cd11h" ;
		case 22: card_namination = "ld_card:cd11s" ;
		case 23: card_namination = "ld_card:cd11d" ;
		case 24: card_namination = "ld_card:cd12c" ; // дамы
		case 25: card_namination = "ld_card:cd12h" ;
		case 26: card_namination = "ld_card:cd12s" ;
		case 27: card_namination = "ld_card:cd12d" ;
		case 28: card_namination = "ld_card:cd13c" ; // кинги
		case 29: card_namination = "ld_card:cd13h" ;
		case 30: card_namination = "ld_card:cd13s" ;
		case 31: card_namination = "ld_card:cd13d" ;
		case 32: card_namination = "ld_card:cd1c" ; // тузы
		case 33: card_namination = "ld_card:cd1h" ;
		case 34: card_namination = "ld_card:cd1s" ;
		case 35: card_namination = "ld_card:cd1d" ;
	}
	return card_namination ;
}

stock cards_PlayerTextDraw ( playerid, PlayerText:playertextid )
{
	if ( fool_used [ playerid ] )
	{
		new _table = fool_table { playerid } - 1 ;
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		if ( playertextid == cards_background_PTD [ playerid ] [ 5 ] )
		{
			if ( page_count [ playerid ] == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице." ) ;
			
			show_fool_player_ptd ( playerid, -1, false ) ;
			
			page_count [ playerid ] -= 1 ;
			show_fool_player_ptd ( playerid, -1, true ) ;
			return 1 ;
		}
		else if ( playertextid == cards_background_PTD [ playerid ] [ 7 ] )
		{
			if ( ofm_formula_card ( page_count [ playerid ] ) >= page_rows [ playerid ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице." ) ;
			
			show_fool_player_ptd ( playerid, -1, false ) ;
			
			page_count [ playerid ] += 1 ;
			show_fool_player_ptd ( playerid, -1, true ) ;
			return 1 ;
		}
		
		if ( playertextid == button_take_PTD [ playerid ] [ 3 ] )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] == playerid )
			{
				new bool: _next_player = false ;
				for ( new i = 0 ; i < 6 ; i ++ )
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] != playerid ) continue ;
					
					fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ i ] = 1 ;
					show_button_ptd ( playerid, -1, false ) ;
					break ;
				}
				for ( new i = 0 ; i < 6 ; i ++ )
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
					if ( fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ i ] == 1 ) continue ;
					if ( fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] == fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ) continue ;
					
					fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
					SendClientMessage ( fool_info [ _b_id ] [ _table ] [ f_move_podkinul ], 0xFFCC00FF, !"Предидущий игрок пропустил ход, Ваша очередь!" ) ;
					
					show_button_ptd ( fool_info [ _b_id ] [ _table ] [ f_move ], 1, true ) ;
					
					_next_player = true ;
					break ;
				}
				if ( _next_player == false ) return next_move_player ( _b_id, _table, fool_info [ _b_id ] [ _table ] [ f_move_pokriv ], 1 ) ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] == playerid )
			{
				new bool: _go_table_string = false ;
				for ( new k = 0 ; k < 6 ; k ++ )
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] != -1 ) // Если карта уже побита
					{
						new _card_id = 0 ;
						for ( new i = 0 ; i < 36 ; i ++ )
						{
							if ( fool_player [ playerid ] [ i ] != -1 ) continue ;
							
							_card_id = i ;
							break ;
						}
						
						page_rows [ playerid ] ++ ;
						
						fool_player [ playerid ] [ _card_id ] = fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] ;
						fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] = -1 ;
						
						for ( new p = 0 ; p < 6 ; p ++ )
						{
							if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] == INVALID_PLAYER_ID ) continue ;
							
							new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] ;
							PlayerTextDrawHide ( player_id, pokriv_cards_PTD [ player_id ] [ k ] ) ;
							
							if ( _go_table_string == false )
							{
								new scm_string [ 25 + ( MAX_PLAYER_NAME * 2 ) ] ;
								format ( scm_string, sizeof scm_string, "%s взял(а) карты.", p_info [ playerid ] [ name ] ) ;
								SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
								
								_go_table_string = true ;
							}
						}
					}
					if ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] != -1 ) // Если кинутый слот карты не пуст
					{
						new _card_id = 0 ;
						for ( new i = 0 ; i < 36 ; i ++ )
						{
							if ( fool_player [ playerid ] [ i ] != -1 ) continue ;
							
							_card_id = i ;
							break ;
						}
						
						page_rows [ playerid ] ++ ;
						
						fool_player [ playerid ] [ _card_id ] = fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] ;
						fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] = -1 ;
						
						for ( new p = 0 ; p < 6 ; p ++ )
						{
							if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] == INVALID_PLAYER_ID ) continue ;
							
							new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] ;
							PlayerTextDrawHide ( player_id, podkid_cards_PTD [ player_id ] [ k ] ) ;
							
							if ( _go_table_string == false )
							{
								new scm_string [ 25 + ( MAX_PLAYER_NAME * 2 ) ] ;
								format ( scm_string, sizeof scm_string, "%s взял(а) карты.", p_info [ playerid ] [ name ] ) ;
								SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
								
								_go_table_string = true ;
							}
						}
					}
				}
				show_button_ptd ( playerid, -1, false ) ;
				next_move_player ( _b_id, _table, fool_info [ _b_id ] [ _table ] [ f_move_pokriv ], 2 ) ;
			}
			return 1 ;
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_move ] == playerid )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] == playerid )
			{
				for ( new i = 0 ; i < 6 ; i ++ )
				{
					if ( playertextid != player_cards_PTD [ playerid ] [ i ] ) continue ;
				
					new _card_id ;
					if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( i + 1 ) ;
					else _card_id = i ;
					
					if ( fool_player [ playerid ] [ _card_id ] == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данном слоте у Вас нет карты." ) ;
							
					for ( new k = 0 ; k < 6 ; k ++ )
					{
						if ( fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] != -1 ) continue ; // Если карта уже побита, то переходим к следующей
						if ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] == -1 ) return 1 ; // Если ничего не кинули
								
						new _podkid_score = card_team ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] ), _player_score = card_team ( fool_player [ playerid ] [ _card_id ] ) ;
						if ( _podkid_score != _player_score ) // Если масти не равны
						{
							if ( _podkid_score == fool_info [ _b_id ] [ _table ] [ f_team_trump ] ) // Если карта кинувшего козырь
							{
								return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данной картой Вы не можете побить козырь." ) ;
							}
							else if ( _player_score == fool_info [ _b_id ] [ _table ] [ f_team_trump ] ) // Если карта, которой мы бьёмся козырь
							{
								fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] = fool_player [ playerid ] [ _card_id ] ;
								
								page_rows [ playerid ] -- ;
										
								fool_player [ playerid ] [ _card_id ] = -1 ;
								fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] ;
								
								show_pokriv_cards_refresh ( _b_id, _table, k, fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] ) ;
								show_refresh_card ( playerid, _b_id, _table, i ) ;
										
								show_button_ptd ( playerid, -1, false ) ;
								
								if ( fool_info [ _b_id ] [ _table ] [ f_move ] == INVALID_PLAYER_ID )
									next_move_player ( _b_id, _table, fool_info [ _b_id ] [ _table ] [ f_move_pokriv ], 1 ) ;
								
								else 
									show_button_ptd ( fool_info [ _b_id ] [ _table ] [ f_move ], 1, true ) ;
								return 1 ;
							}
							else return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данной картой Вы не можете побить." ) ; // Если не одно из условий не подошло
						}
						else
						{
							_podkid_score = card_score ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] ), _player_score = card_score ( fool_player [ playerid ] [ _card_id ] ) ;
							if ( _podkid_score < _player_score )
							{
								fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] = fool_player [ playerid ] [ _card_id ] ;

								page_rows [ playerid ] -- ;
										
								fool_player [ playerid ] [ _card_id ] = -1 ;
								fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] ;
										
								show_pokriv_cards_refresh ( _b_id, _table, k, fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] ) ;
								show_refresh_card ( playerid, _b_id, _table, i ) ;
										
								show_button_ptd ( playerid, -1, false ) ;
								
								if ( fool_info [ _b_id ] [ _table ] [ f_move ] == INVALID_PLAYER_ID )
									next_move_player ( _b_id, _table, fool_info [ _b_id ] [ _table ] [ f_move_pokriv ], 1 ) ;
								
								else 
									show_button_ptd ( fool_info [ _b_id ] [ _table ] [ f_move ], 1, true ) ;
								return 1 ;
							}
							else return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данной картой Вы не можете побить." ) ; // Если не одно из условий не подошло
						}
					}
				}
				return 1 ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] == playerid )
			{
				for ( new i = 0 ; i < 6 ; i ++ )
				{
					if ( playertextid != player_cards_PTD [ playerid ] [ i ] ) continue ;
				
					new _card_id ;
					if ( page_count [ playerid ] > 1 ) _card_id = ( 5 * ( page_count [ playerid ] - 1 ) ) + ( i + 1 ) ;
					else _card_id = i ;
					
					new _c_count = 0 ;
					for ( new k = 0 ; k < 6 ; k ++ )
					{
						if ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] != -1 ) 
						{
							_c_count ++ ;
							continue ;
						}
								
						new _player_score = card_score ( fool_player [ playerid ] [ _card_id ] ), bool: _card_count = false ;
						for ( new q = 0 ; q < 6 ; q ++ )
						{
							if ( _c_count == 0 )
							{
								fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] = fool_player [ playerid ] [ _card_id ] ;
													
								page_rows [ playerid ] -- ;
										
								fool_player [ playerid ] [ _card_id ] = -1 ;
								fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] ;
										
								show_podkid_cards_refresh ( _b_id, _table, k, fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] ) ;
								show_refresh_card ( playerid, _b_id, _table, i ) ;
										
								show_button_ptd ( playerid, -1, false ) ;
								
								if ( fool_info [ _b_id ] [ _table ] [ f_move ] == INVALID_PLAYER_ID )
									next_move_player ( _b_id, _table, fool_info [ _b_id ] [ _table ] [ f_move_pokriv ], 1 ) ;
								
								else 
									show_button_ptd ( fool_info [ _b_id ] [ _table ] [ f_move ], 2, true ) ;
										
								_card_count = true ;
								return 1 ;
							}
								
							if ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ q ] == -1 ) continue ;
									
							new _podkid_score = card_score ( fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ q ] ), _pokriv_score = card_score ( fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ q ] ) ;
							if ( _podkid_score == _player_score || _pokriv_score == _player_score )
							{
								fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] = fool_player [ playerid ] [ _card_id ] ;
											
								page_rows [ playerid ] -- ;
										
								fool_player [ playerid ] [ _card_id ] = -1 ;
								fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] ;
										
								show_podkid_cards_refresh ( _b_id, _table, k, fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] ) ;
								show_refresh_card ( playerid, _b_id, _table, i ) ;
										
								show_button_ptd ( playerid, -1, false ) ;
								
								if ( fool_info [ _b_id ] [ _table ] [ f_move ] == INVALID_PLAYER_ID )
									next_move_player ( _b_id, _table, fool_info [ _b_id ] [ _table ] [ f_move_pokriv ], 1 ) ;
								
								else 
									show_button_ptd ( fool_info [ _b_id ] [ _table ] [ f_move ], 2, true ) ;
										
								_card_count = true ;
								return 1 ;
							}
						}
						if ( _card_count == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данную карту нельзя подкинуть." ) ;
					}
					if ( _c_count == 6 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Подкинуто максимальное количество карт." ) ;
				}
				return 1 ;
			}
		}
		else SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сейчас не твой ход." ) ;
		return 1 ;
	}
	return 0 ;
}

stock show_podkid_cards_refresh ( _b_id, _table, td_id, _card_id )
{
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
	
		new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
		
		new td_string [ 20 ] ;
		format ( td_string, sizeof td_string, "%s", card_string ( _card_id ) ) ;
		PlayerTextDrawSetString ( player_id, podkid_cards_PTD [ player_id ] [ td_id ], td_string ) ;
		PlayerTextDrawShow ( player_id, podkid_cards_PTD [ player_id ] [ td_id ] ) ;
	}
	return 1 ;
}

stock show_pokriv_cards_refresh ( _b_id, _table, td_id, _card_id )
{
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
	
		new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
		
		new td_string [ 20 ] ;
		format ( td_string, sizeof td_string, "%s", card_string ( _card_id ) ) ;
		PlayerTextDrawSetString ( player_id, pokriv_cards_PTD [ player_id ] [ td_id ], td_string ) ;
		PlayerTextDrawShow ( player_id, pokriv_cards_PTD [ player_id ] [ td_id ] ) ;
	}
	return 1 ;
}

stock show_refresh_card ( playerid, _b_id, _table, td_id )
{
	#pragma unused td_id
	//PlayerTextDrawDestroy ( playerid, player_cards_PTD [ playerid ] [ td_id ] ) ;
	//player_cards_PTD [ playerid ] [ td_id ] = PlayerText:-1 ;
	
	if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] <= 0 )
	{
		if ( page_rows [ playerid ] <= 0 )
		{
			close_player_fool ( _b_id, _table, playerid, 1 ) ;
			return 1 ;
		}
	}

	for ( new q = 0 ; q < 35 ; q ++ )
	{
		if ( fool_player [ playerid ] [ q ] != -1 || fool_player [ playerid ] [ q + 1 ] == -1 ) continue ;
		
		fool_player [ playerid ] [ q ] = fool_player [ playerid ] [ q + 1 ] ;
		fool_player [ playerid ] [ q + 1 ] = -1 ;
	}
	
	page_count [ playerid ] = 1 ;
	show_fool_player_ptd ( playerid, -1, false ) ;
	show_fool_player_ptd ( playerid, -1, true ) ;
	
	for ( new p = 0 ; p < 6 ; p ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] == INVALID_PLAYER_ID ) continue ;
		
		new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ p ] ;
		for ( new k = 0 ; k < 6 ; k ++ )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == player_id ) continue ;
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == playerid )
			{
				for ( new i = 6 ; i > 1 ; i -- )
				{
					if ( enemy1_cards_PTD [ player_id ] [ i ] != PlayerText:-1 )
					{
						PlayerTextDrawDestroy ( player_id, enemy1_cards_PTD [ player_id ] [ i ] ) ;
						enemy1_cards_PTD [ player_id ] [ i ] = PlayerText:-1 ;
						break ;
					}
				}
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == playerid )
			{
				for ( new i = 6 ; i > 1 ; i -- )
				{
					if ( enemy2_cards_PTD [ player_id ] [ i ] != PlayerText:-1 )
					{
						PlayerTextDrawDestroy ( player_id, enemy2_cards_PTD [ player_id ] [ i ] ) ;
						enemy2_cards_PTD [ player_id ] [ i ] = PlayerText:-1 ;
						break ;
					}
				}
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == playerid )
			{
				for ( new i = 6 ; i > 1 ; i -- )
				{
					if ( enemy3_cards_PTD [ player_id ] [ i ] != PlayerText:-1 )
					{
						PlayerTextDrawDestroy ( player_id, enemy3_cards_PTD [ player_id ] [ i ] ) ;
						enemy3_cards_PTD [ player_id ] [ i ] = PlayerText:-1 ;
						break ;
					}
				}
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == playerid )
			{
				for ( new i = 6 ; i > 1 ; i -- )
				{
					if ( enemy4_cards_PTD [ player_id ] [ i ] != PlayerText:-1 )
					{
						PlayerTextDrawDestroy ( player_id, enemy4_cards_PTD [ player_id ] [ i ] ) ;
						enemy4_cards_PTD [ player_id ] [ i ] = PlayerText:-1 ;
						break ;
					}
				}
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == playerid )
			{
				for ( new i = 6 ; i > 1 ; i -- )
				{
					if ( enemy5_cards_PTD [ player_id ] [ i ] != PlayerText:-1 )
					{
						PlayerTextDrawDestroy ( player_id, enemy5_cards_PTD [ player_id ] [ i ] ) ;
						enemy5_cards_PTD [ player_id ] [ i ] = PlayerText:-1 ;
						break ;
					}
				}
			}
		}
	}
	return 1 ;
}

stock next_move_player ( _b_id, _table, _move_id, _type )
{
	if ( _type == 1 )
	{
		new _pos_id ;
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			if ( _move_id != fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ) continue ;
			
			_pos_id = i ;
			break ;
		}
		
		fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = _move_id ;
		if ( _pos_id == 5 )
		{
			fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
		}
		else
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ _pos_id + 1 ] != INVALID_PLAYER_ID )
			{
				if ( _pos_id + 1 > 5 ) fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
				else fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ _pos_id + 1 ] ;
			}
			else
			{
				fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
			}
		}
	}
	else if ( _type == 2 )
	{
		new _pos_id ;
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			if ( _move_id != fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ) continue ;
			
			_pos_id = i ;
			break ;
		}
		
		if ( _pos_id == 5 )
		{
			fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
			fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 1 ] ;
		}
		else
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ _pos_id + 1 ] != INVALID_PLAYER_ID )
			{
				fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ _pos_id + 1 ] ;
				if ( _pos_id + 2 > 5 ) fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
				else
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ _pos_id + 2 ] != INVALID_PLAYER_ID )
					{
						fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ _pos_id + 2 ] ;
					}
					else fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
				}
			}
			else
			{
				fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;
				fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 1 ] ;
			}
		}
	}

	for ( new i = 0 ; i < 6 ; i ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
		
		new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
		page_count [ player_id ] = 1 ;
		
		for ( new k = 0 ; k < 6 ; k ++ )
		{
			PlayerTextDrawHide ( player_id, pokriv_cards_PTD [ player_id ] [ k ] ) ;
			PlayerTextDrawHide ( player_id, podkid_cards_PTD [ player_id ] [ k ] ) ;
			
			fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ k ] = -1 ;
			fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ k ] = -1 ;
		}
		
		fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ i ] = 0 ;
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] == 1 )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_trump ] != -1 )
			{
				new _card_id = fool_info [ _b_id ] [ _table ] [ f_trump ] ;
				
				fool_info [ _b_id ] [ _table ] [ f_trump ] = -1 ;
				fool_info [ _b_id ] [ _table ] [ f_card ] [ _card_id ] = 0 ;
			}
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] > 0 )
		{
			if ( page_rows [ player_id ] < 6 )
			{
				for ( new q = 0 ; q < 36 ; q ++ )
				{
					if ( page_rows [ player_id ] >= 6 ) break ;
					if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] == 0 ) break ;
					if ( fool_player [ player_id ] [ q ] != -1 ) continue ;
						
					page_rows [ player_id ] ++ ;
					fool_player [ player_id ] [ q ] = give_card ( _b_id, _table ) ;
				}
			}
		}
		
		new scm_string [ 25 + ( MAX_PLAYER_NAME * 2 ) ] ;
		format ( scm_string, sizeof scm_string, "Теперь ходит %s на %s.", p_info [ fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] ] [ name ], p_info [ fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] ] [ name ] ) ;
		SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
	}
	
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;
		
		new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
		
		new _c_count = 0 ;
		for ( new k = 0 ; k < 6 ; k ++ )
		{
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == INVALID_PLAYER_ID ) continue ;
			
			new gambler_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] ;
			
			if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == player_id )
			{
				show_fool_player_ptd ( player_id, -1, false ) ;
				show_fool_player_ptd ( player_id, -1, true ) ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == gambler_id && _c_count == 0 )
			{
				show_fool_enemy_1 ( player_id, _table, -1, false ) ;
				show_fool_enemy_1 ( player_id, _table, k, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == gambler_id && _c_count == 1 )
			{
				show_fool_enemy_2 ( player_id, _table, -1, false ) ;
				show_fool_enemy_2 ( player_id, _table, k, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == gambler_id && _c_count == 2 )
			{
				show_fool_enemy_3 ( player_id, _table, -1, false ) ;
				show_fool_enemy_3 ( player_id, _table, k, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == gambler_id && _c_count == 3 )
			{
				show_fool_enemy_4 ( player_id, _table, -1, false ) ;
				show_fool_enemy_4 ( player_id, _table, k, true ) ;
				
				_c_count ++ ;
				continue ;
			}
			else if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ k ] == gambler_id && _c_count == 4 )
			{
				show_fool_enemy_5 ( player_id, _table, -1, false ) ;
				show_fool_enemy_5 ( player_id, _table, k, true ) ;
				
				_c_count ++ ;
				continue ;
			}
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] < 3 ) 
		{
			PlayerTextDrawDestroy ( player_id, koloda_cards_PTD [ player_id ] [ 7 ] ) ;
			koloda_cards_PTD [ player_id ] [ 7 ] = PlayerText:-1 ;
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] < 2 ) 
		{
			PlayerTextDrawDestroy ( player_id, koloda_cards_PTD [ player_id ] [ 6 ] ) ;
			koloda_cards_PTD [ player_id ] [ 6 ] = PlayerText:-1 ;
		}
		
		if ( fool_info [ _b_id ] [ _table ] [ f_card_count ] < 1 ) 
		{
			PlayerTextDrawDestroy ( player_id, koloda_cards_PTD [ player_id ] [ 5 ] ) ;
			koloda_cards_PTD [ player_id ] [ 5 ] = PlayerText:-1 ;
		}
		
		new td_string [ 24 ] ;
		format ( td_string, sizeof td_string, "CARDS:_%d", fool_info [ _b_id ] [ _table ] [ f_card_count ] ) ;
		PlayerTextDrawSetString ( player_id, koloda_cards_PTD [ player_id ] [ 4 ], td_string ) ;
	}
	return 1 ;
}

stock clear_fool_table ( )
{
	foreach(new _b_id: business_types[bizz_type_casino])
   	{
		for ( new _table = 0 ; _table < MAX_FOOL_TABLE ; _table ++ )
		{
			for ( new q = 0 ; q < 6 ; q ++ ) 
			{
				fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] = INVALID_PLAYER_ID ;
				fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ q ] = 0 ;
				
				fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ q ] = 
				fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ q ] = -1 ;
			}
			fool_info [ _b_id ] [ _table ] [ f_move ] = INVALID_PLAYER_ID ;
			fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = INVALID_PLAYER_ID ;
			fool_info [ _b_id ] [ _table ] [ f_card_count ] = 36 ;
			for ( new q = 0 ; q < 36 ; q ++ ) fool_info [ _b_id ] [ _table ] [ f_card ] [ q ] = 0 ;
				
			fool_info [ _b_id ] [ _table ] [ f_bet ] = 100000 ;
			fool_info [ _b_id ] [ _table ] [ f_bank ] = 0 ;
				
			new fool_string [ 200 ] ;
			format ( fool_string, sizeof fool_string, "** Fool Game **\n{"#cGR3D"}Нажмите {"#cWH3D"}F{"#cGR3D"} для взаимодействия\n\n{"#cGR3D"}Игроков: {"#cWH3D"}0/6\n{"#cGR3D"}Ставка: {"#cGN3D"}%d$\n\n{"#cGR3D"}Статус: {"#cRD"}Игра не начата", fool_info [ _b_id ] [ _table ] [ f_bet ] ) ;
			fool_info [ _b_id ] [ _table ] [ f_text ] = CreateDynamic3DTextLabel ( fool_string, col_blue, fool_positions [ _table ] [ 0 ], fool_positions [ _table ] [ 1 ], fool_positions [ _table ] [ 2 ] + 0.5,
																		5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, b_info [ _b_id - 1 ] [ b_id ] + 1000, -1 ) ;
		
			fool_info [ _b_id ] [ _table ] [ f_area ] = CreateDynamicSphere ( fool_positions [ _table ] [ 0 ], fool_positions [ _table ] [ 1 ], fool_positions [ _table ] [ 2 ], 3.0, b_info [ _b_id - 1 ] [ b_id ] + 1000, -1, -1 ) ;
			area_info [ fool_info [ _b_id ] [ _table ] [ f_area ] ] [ a_type ] = area_type_cards ;
		}
	}
	return 1 ;
}

stock update_fool_table ( _b_id, _table )
{
	global_string [ 0 ] = EOS ;

    new _c_status [ 48 ], _p_count = 0 ;
	
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] != INVALID_PLAYER_ID ) _p_count ++ ;
	}
	
	switch ( fool_info [ _b_id ] [ _table ] [ f_status ] )
	{
		case 0: _c_status = "{"#cRD"}Игра не начата" ;
		case 1: format ( _c_status, sizeof _c_status, "{"#cYW"}Ожидание игроков (%d сек.)", fool_info [ _b_id ] [ _table ] [ f_started ] ) ;
		case 2: _c_status = "{"#cYW"}Раздача карт" ;
		case 3: _c_status = "{"#cYW"}Подведение итогов" ;
	}

	format ( global_string, 512, "** Fool Game **\n{"#cGR3D"}Нажмите {"#cWH3D"}F{"#cGR3D"} для взаимодействия\n\n{"#cGR3D"}Игроков: {"#cWH3D"}%d/6\n{"#cGR3D"}Ставка: {"#cGN3D"}%d$\n\n{"#cGR3D"}Статус: %s", 
		_p_count, fool_info [ _b_id ] [ _table ] [ f_bet ], _c_status ) ;
	if ( IsValidDynamic3DTextLabel ( fool_info [ _b_id ] [ _table ] [ f_text ] ) ) UpdateDynamic3DTextLabelText ( fool_info [ _b_id ] [ _table ] [ f_text ], col_blue, global_string ) ;
	return 1 ;
}

stock cards_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	switch ( dialogid )
	{
		case f_fool_bet:
		{
	        new _table = fool_table { playerid } - 1, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
	        if ( ! response )
	        {
	            fool_info [ _b_id ] [ _table ] [ f_bet ] = 1000 ;
	            toggle_controlable ( playerid, false ) ;

				update_fool_table ( _b_id, _table ) ;
	            return 1 ;
	        }
	        
	        new _value = strval ( inputtext ) ;
			if ( _value < 1000 || _value > 10000000 )
			{
                show_dialog ( playerid, f_fool_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "{"#cWH"}Укажите сумму ставки для выбранного стола:\n\n{"#cRD"}* Сумма не может быть менее 1.000$ и более 10.000.000$", "Указать", "Закрыть" ) ;
			    return 1 ;
			}
			if ( p_info [ playerid ] [ money ] < _value )
			{
			    show_dialog ( playerid, f_fool_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "{"#cRD"}* У Вас недостаточно средств для такой ставки.\n\n{"#cWH"}Укажите сумму ставки для выбранного стола:\n\n{"#cGRDialog"}* Сумма не может быть менее 1.000$ и более 10.000.000$", "Указать", "Закрыть" ) ;
			    return 1 ;
			}
			
			fool_info [ _b_id ] [ _table ] [ f_bet ] = _value ;
			
	   		new _f_money = fool_info [ _b_id ] [ _table ] [ f_bet ] ;
			give_money ( playerid, -_f_money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_f_money, "ставка дурак" ) ;

			fool_info [ _b_id ] [ _table ] [ f_bank ] += _f_money ;
			
			toggle_controlable ( playerid, false ) ;

			update_fool_table ( _b_id, _table ) ;
			return 1 ;
	    }
	}
	return 0 ;
}

stock cards_OnPlayerKeyStateChange ( playerid )
{
	if ( IsPlayerNearFool ( playerid ) == -1 ) return 0 ;
	
	new null = -1, _table = IsPlayerNearFool ( playerid ), _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
	for ( new i = 0 ; i < 6 ; i ++ ) if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) { null = i ; break ; }
	if ( fool_table { playerid } ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже зарегистрированы на другом столе." ) ;
	if ( null == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}За этим столом нет свободных мест." ) ;
	if ( fool_info [ _b_id ] [ _table ] [ f_bet ] > p_info [ playerid ] [ money ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не хватает денег." ) ;
	if ( fool_info [ _b_id ] [ _table ] [ f_status ] > 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игра уже началась." ) ;
		
	clear_player_fool ( playerid ) ;
		
	new _p_count = 0 ;
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] != INVALID_PLAYER_ID ) _p_count ++ ;
	}
	if ( ! _p_count )
	{
		for ( new q = 0 ; q < 6 ; q ++ )
		{
			fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] = INVALID_PLAYER_ID ;
			fool_info [ _b_id ] [ _table ] [ f_move_next_player ] [ q ] = 0 ;
					
			fool_info [ _b_id ] [ _table ] [ f_table_podkid ] [ q ] = 
			fool_info [ _b_id ] [ _table ] [ f_table_pokriv ] [ q ] = -1 ;
		}
		fool_info [ _b_id ] [ _table ] [ f_move ] = INVALID_PLAYER_ID ;
		fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = INVALID_PLAYER_ID ;
		fool_info [ _b_id ] [ _table ] [ f_card_count ] = 36 ;
			
		fool_info [ _b_id ] [ _table ] [ f_bank ] =
		fool_info [ _b_id ] [ _table ] [ f_bet ] =
		fool_info [ _b_id ] [ _table ] [ f_status ] = 0 ;
			
		for ( new q = 0 ; q < 36 ; q ++ ) fool_info [ _b_id ] [ _table ] [ f_card ] [ q ] = 0 ;
			
		fool_info [ _b_id ] [ _table ] [ f_started ] = 30 ;
		fool_info [ _b_id ] [ _table ] [ f_status ] = 1 ;
		fool_info [ _b_id ] [ _table ] [ f_time ] = SetTimerEx ( "fool_timer", 1000, true, "ii", _b_id, _table ) ;
	
		show_dialog ( playerid, f_fool_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "{"#cWH"}Укажите сумму ставки для выбранного стола:\n\n{"#cGRDialog"}* Сумма не может быть менее 1.000$ и более 10.000.000$", "Указать", "Закрыть" ) ;
	}
	else
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_bet ] > p_info [ playerid ] [ money ] || fool_info [ _b_id ] [ _table ] [ f_bet ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не хватает денег / ставка не назначена." ) ;
	}
		
	new scm_string [ 30 + MAX_PLAYER_NAME ] ;
	format ( scm_string, sizeof scm_string, "%s присоединился(а) к игре.", p_info [ playerid ] [ name ] ) ;
	for ( new q = 0 ; q < 6 ; q ++ ) 
	{
		if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] == INVALID_PLAYER_ID ) continue ;
		
		new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ q ] ;
		SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
	}
		
	new Float:pl_pos_x,
		Float:pl_pos_y,
		Float:pl_pos_z ;

	GetPlayerPos ( playerid, pl_pos_x, pl_pos_y, pl_pos_z ) ;

	InterpolateCameraPos ( playerid, pl_pos_x, pl_pos_y, pl_pos_z + 1, fool_positions [ _table ] [ 0 ], fool_positions [ _table ] [ 1 ], fool_positions [ _table ] [ 2 ] + 2.0, 5000, 18000 ) ;
	InterpolateCameraLookAt ( playerid, pl_pos_x, pl_pos_y, pl_pos_z + 1, fool_positions [ _table ] [ 0 ], fool_positions [ _table ] [ 1 ], fool_positions [ _table ] [ 2 ], 5000, 18000 ) ;
		
	SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Вы сели за стол. Ожидайте игроков. Если Вы передумали играть, то используйте /exitfool." ) ;
		
	new _f_money = fool_info [ _b_id ] [ _table ] [ f_bet ] ;
	give_money ( playerid, -_f_money ) ;
	insert_money_log ( playerid, INVALID_PLAYER_ID, -_f_money, "ставка дурак" ) ;
		
	fool_info [ _b_id ] [ _table ] [ f_bank ] += _f_money ;
	
	page_count [ playerid ] = 1 ;
	
	fool_info [ _b_id ] [ _table ] [ f_player ] [ null ] = playerid ;
	fool_table { playerid } = _table + 1 ;
	toggle_controlable ( playerid, false ) ;
		
	update_fool_table ( _b_id, _table ) ;
	return 1 ;
}

CMD:exitfool ( playerid )
{
	if ( fool_table { playerid } )
	{
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		if ( fool_info [ _b_id ] [ fool_table { playerid } - 1 ] [ f_status ] == 2 ) 
		{
			close_player_fool ( _b_id, fool_table { playerid } - 1, playerid, 2 ) ;
		}
		else
		{
			close_player_fool ( _b_id, fool_table { playerid } - 1, playerid, 3 ) ;
			toggle_controlable ( playerid, true ) ;
			fool_table { playerid } = 0 ;
		}
	}
	return 1 ;
}

callback: fool_timer ( _b_id, _table )
{
	if ( fool_info [ _b_id ] [ _table ] [ f_started ] > 0 ) 
	{
		fool_info [ _b_id ] [ _table ] [ f_started ] -- ;
		if ( fool_info [ _b_id ] [ _table ] [ f_started ] == 1 )
		{
			new _p_count = 0 ;
			for ( new i = 0 ; i < 6 ; i ++ )
			{
				if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;

				_p_count ++ ;
			}

			if ( _p_count > 1 )
			{
				if ( IsValidDynamic3DTextLabel ( fool_info [ _b_id ] [ _table ] [ f_text ] ) )
				{
					DestroyDynamic3DTextLabel ( fool_info [ _b_id ] [ _table ] [ f_text ] ) ;
				}
			
				fool_info [ _b_id ] [ _table ] [ f_trump ] = give_card ( _b_id, _table ) ;
				
				new _p_free_id = 0 ;
				for ( new i = 0 ; i < 5 ; i ++ )
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] != INVALID_PLAYER_ID ) 
					{
						_p_free_id ++ ;
						continue ;
					}
					
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i + 1 ] != INVALID_PLAYER_ID )
					{
						fool_info [ _b_id ] [ _table ] [ f_player ] [ _p_free_id ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ i + 1 ] ;
						fool_info [ _b_id ] [ _table ] [ f_player ] [ i + 1 ] = INVALID_PLAYER_ID ;
					}
					break ;
				}

				fool_info [ _b_id ] [ _table ] [ f_team_trump ] = card_team ( fool_info [ _b_id ] [ _table ] [ f_trump ] ) ;
				fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 1 ] ;
				fool_info [ _b_id ] [ _table ] [ f_move ] = fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] = fool_info [ _b_id ] [ _table ] [ f_player ] [ 0 ] ;

				for ( new i = 0 ; i < 6 ; i ++ )
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;

					new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
					fool_used [ player_id ] = true ;
					page_rows [ player_id ] = 6 ;
					
					new scm_string [ 25 + ( MAX_PLAYER_NAME * 2 ) ] ;
					format ( scm_string, sizeof scm_string, "Игра началась. Первым ходит %s на %s.", p_info [ fool_info [ _b_id ] [ _table ] [ f_move_podkinul ] ] [ name ], p_info [ fool_info [ _b_id ] [ _table ] [ f_move_pokriv ] ] [ name ] ) ;
					SendClientMessage ( player_id, 0xFFCC00FF, scm_string ) ;
				}
				
				for ( new i = 0 ; i < 6 ; i ++ )
				{
					if ( fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;

					new player_id = fool_info [ _b_id ] [ _table ] [ f_player ] [ i ] ;
					
					show_fool_ptd ( player_id, _table, true ) ;
				}
				
				KillTimer ( fool_info [ _b_id ] [ _table ] [ f_time ] ) ;
				fool_info [ _b_id ] [ _table ] [ f_time ] = -1 ;
				fool_info [ _b_id ] [ _table ] [ f_status ] = 2 ;
				fool_info [ _b_id ] [ _table ] [ f_started ] = 0 ;
			}
			else if ( _p_count == 1 ) 
			{
				fool_info [ _b_id ] [ _table ] [ f_status ] = 1 ;
				fool_info [ _b_id ] [ _table ] [ f_started ] = 30 ;
			}
			else if ( ! _p_count )
			{
				KillTimer ( fool_info [ _b_id ] [ _table ] [ f_time ] ) ;
				fool_info [ _b_id ] [ _table ] [ f_time ] = -1 ;
				
				fool_info [ _b_id ] [ _table ] [ f_status ] =
				fool_info [ _b_id ] [ _table ] [ f_started ] = 0 ;
			}
		}
		update_fool_table ( _b_id, _table ) ;
	}
	return 1 ;
}

stock IsPlayerNearFool ( playerid )
{
	for ( new i = 0 ; i < MAX_FOOL_TABLE ; i ++ ) if ( IsPlayerInRangeOfPoint ( playerid, 3.0, fool_positions [ i ] [ 0 ], fool_positions [ i ] [ 1 ], fool_positions [ i ] [ 2 ] ) ) return i ;
	return -1 ;
}