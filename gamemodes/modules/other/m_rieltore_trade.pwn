#define MAX_TRADE_SLOT 20

enum _trade_rieltore
{
	trade_id,
	bool: trade_accept,
	
	trade_item [ MAX_TRADE_SLOT ],
	trade_type [ MAX_TRADE_SLOT ],
	trade_count [ MAX_TRADE_SLOT ]
} ;

new trade_rielt [ MAX_PLAYERS ] [ _trade_rieltore ] ;

new bool: used_trade [ MAX_PLAYERS ] ;

new trade_char_plate [ MAX_PLAYERS ] [ 24 ] ;
new trade_plate_name [ MAX_PLAYERS ] [ MAX_TRADE_SLOT ] [ 24 ] ;

#define d_trade_plates 22050

enum
{
	d_accept_trade = 22000,
	
	d_prise_trade,
	d_prise_trade_count,
	
	d_trade,
	d_trade_vehicle,
	d_trade_money,
	d_home_trade,
	d_business_trade,
	d_trade_accessories,
	d_use_trade,
	d_accept_trade_1,
	d_accept_trade_2,
	d_returnmoney_trade,
	d_trade_rielt_skins,
	d_trade_ft,
	d_skin_show,
	
	d_trade_info,
	d_trade_info_house,
	d_trade_info_bizz,
	d_trade_inform
} ;

enum
{
	TRADE_RIELT_HOUSE = 1,
	TRADE_RIELT_BIZZ,
	TRADE_RIELT_MONEY,
	TRADE_RIELT_CAR,
	TRADE_RIELT_ACCS,
	TRADE_RIELT_INVENTORY,
	TRADE_RIELT_GARAGE,
	TRADE_RIELT_RETURN_MONEY,
	TRADE_RIELT_SKIN,
	TRADE_RIELT_PLATE,
	TRADE_RIELT_FAMILY,
	TRADE_RIELT_FAMILY_TALON,
	TRADE_RIELT_SIMCARD
} ;

static Float: def_trade_player1_pos [ MAX_TRADE_SLOT ] [ 2 ] =
{
	{ 171.666641, 129.437011 },
	{ 171.666641, 139.437011 },
	{ 171.666641, 149.437011 },
	{ 171.666641, 159.437011 },
	{ 171.666641, 169.437011 },
	{ 171.666641, 179.437011 },
	{ 171.666641, 189.437011 },
	{ 171.666641, 199.437011 },
	{ 171.666641, 209.437011 },
	{ 171.666641, 219.437011 },
	
	{ 171.666641, 229.437011 },
	{ 171.666641, 239.437011 },
	{ 171.666641, 249.437011 },
	{ 171.666641, 259.437011 },
	{ 171.666641, 269.437011 },
	{ 171.666641, 279.437011 },
	{ 171.666641, 289.437011 },
	{ 171.666641, 299.437011 },
	{ 171.666641, 309.437011 },
	{ 171.666641, 319.437011 }
} ;

static Float: def_trade_player2_pos [ MAX_TRADE_SLOT ] [ 2 ] =
{
	{ 352.666656, 129.437011 },
	{ 352.666656, 139.437011 },
	{ 352.666656, 149.437011 },
	{ 352.666656, 159.437011 },
	{ 352.666656, 169.437011 },
	{ 352.666656, 179.437011 },
	{ 352.666656, 189.437011 },
	{ 352.666656, 199.437011 },
	{ 352.666656, 209.437011 },
	{ 352.666656, 219.437011 },
	
	{ 352.666656, 229.437011 },
	{ 352.666656, 239.437011 },
	{ 352.666656, 249.437011 },
	{ 352.666656, 259.437011 },
	{ 352.666656, 269.437011 },
	{ 352.666656, 279.437011 },
	{ 352.666656, 289.437011 },
	{ 352.666656, 299.437011 },
	{ 352.666656, 309.437011 },
	{ 352.666656, 319.437011 }
} ;

new PlayerText: def_trade_main_PTD [ MAX_PLAYERS ] [ 35 ] ;
new PlayerText: def_trade_player2_PTD [ MAX_PLAYERS ] [ 25 ] ;
new PlayerText: def_trade_player1_PTD [ MAX_PLAYERS ] [ 25 ] ;

#include	<custom/trade_inc>

stock clear_player_trade ( playerid )
{
	trade_rielt [ playerid ] [ trade_id ] = INVALID_PLAYER_ID ;
	DeletePVar ( playerid, "plate_trade" ) ;
	return 1 ;
}

stock trade_OnPlayerDisconnect ( playerid, _type )
{
	if ( trade_rielt [ playerid ] [ trade_id ] != INVALID_PLAYER_ID )
	{
		new targetid = trade_rielt [ playerid ] [ trade_id ] ;
		
		used_trade [ playerid ] =
		used_trade [ targetid ] = false ;

		show_trade_ptd ( playerid, false ) ;
		show_player_ptd ( playerid, false ) ;
		show_trader_ptd ( playerid, false ) ;
		clear_player_trade ( playerid ) ;

		show_trade_ptd ( targetid, false ) ;
		show_player_ptd ( targetid, false ) ;
		show_trader_ptd ( targetid, false ) ;
		clear_player_trade ( targetid ) ;
		
		if ( _type == 1 ) show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cRInfo"}* {"#cGRInfo"}Игрок, с которым Вы обменивались, покинул игру. Обмен отменён!", "Закрыть", "" ) ;
		else if ( _type == 2 ) show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cRInfo"}* {"#cGRInfo"}Игрок, с которым Вы обменивались, умер. Обмен отменён!", "Закрыть", "" ) ;
	}
	return 1 ;
}

stock show_trade ( playerid )
{
	if ( p_t_info [ playerid ] [ owner_account ] ) return bad_owner_account ( playerid ) ;
	if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы администратор." ) ;
	if ( GetPVarInt ( playerid, "p_biz_id" ) < 1 ) return bad_exit ( playerid ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "{"#cBL"}1. {"#cWH"}Предложить обмен\n{"#cBL"}2. {"#cWH"}Примерочная\n{"#cBL"}3. {417419}Общее положение по обмену\n{"#cGRDialog"}- {"#cWH"}Комиссия: {"#cGN"}%d$", b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 2 ] ) ;
	show_dialog ( playerid, d_use_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Обмен имуществом", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:trade ( playerid, params [ ] )
{
	if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
	if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /trade [id/имя]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
	if ( ! bad_dialog ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Недоступно в данный момент." ) ;
	if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы администратор." ) ;
	
	if ( GetString ( p_t_info [ params [ 0 ] ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
	{
		new scm_string [ 128 ] ;
		format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s[%d] попытка трейда %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ params [ 0 ] ] [ name ], params [ 0 ] ) ;
		foreach(new i: admin_players)SendClientMessage ( i, col_admin, scm_string ) ;

		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно обмениваться с данным игроком." ) ;
		return 1 ;
	}

	global_string [ 0 ] = EOS ;
    format ( global_string, 100, "{"#cGInfo"}* {"#cWH"}Вы предложили {"#cGN"}%s {"#cWH"}обмен.",p_info [ params [ 0 ] ] [ name ] ) ;
    SendClientMessage ( playerid, col_white, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "\
	{"#cOR"}%s {"#cWH"}предлагает Вам обмен.\n\n\
	{"#cWH"}Вне риелторского агентства Вы можете обменять:\n\
	{"#cGRDialog"}- {"#cWH"}Предметы инвентаря\n\
	{"#cGRDialog"}- {"#cWH"}Аксессуары\n\n\
	{"#cGRDialog"}* Вы согласны начать обмен?", p_info [ playerid ] [ name ] ) ;
    show_dialog ( params [ 0 ], d_accept_trade_2, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предложение обмена", global_string, "Да", "Нет" ) ;

    buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
	return 1 ;
}

stock show_rieltore_trade ( playerid, targetid, bool: status )
{
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		trade_rielt [ playerid ] [ trade_item ] [ i ] =
		trade_rielt [ playerid ] [ trade_type ] [ i ] =
		trade_rielt [ playerid ] [ trade_count ] [ i ] =
		
		trade_rielt [ targetid ] [ trade_item ] [ i ] =
		trade_rielt [ targetid ] [ trade_type ] [ i ] =
		trade_rielt [ targetid ] [ trade_count ] [ i ] = 0 ;
	}
	
	for ( new i = 2 ; i < sizeof def_trade_player1_pos ; i ++ )
	{
		def_trade_player1_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		def_trade_player2_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		
		def_trade_player1_PTD [ targetid ] [ i ] = PlayerText:-1 ;
		def_trade_player2_PTD [ targetid ] [ i ] = PlayerText:-1 ;
	}
	
	trade_rielt [ playerid ] [ trade_id ] = targetid ;
	trade_rielt [ targetid ] [ trade_id ] = playerid ;
	
	trade_rielt [ playerid ] [ trade_accept ] =
	trade_rielt [ targetid ] [ trade_accept ] = false ;
	
	used_trade [ playerid ] = true ;
	used_trade [ targetid ] = true ;
	
	show_trade_ptd ( playerid, true, status ) ;
	show_player_ptd ( playerid, true ) ;
	show_trader_ptd ( playerid, true ) ;
	
	show_trade_ptd ( targetid, true, status ) ;
	show_player_ptd ( targetid, true ) ;
	show_trader_ptd ( targetid, true ) ;
	return 1 ;
}

stock show_trade_ptd ( playerid, bool: status, bool: in_business = false )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			def_trade_main_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 165.000000, 81.000000, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][0], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][0], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][0], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][0], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][0], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][0], 0);

			def_trade_main_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 289.799987, 81.199996, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][1], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][1], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][1], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][1], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][1], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][1], 0);

			def_trade_main_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 165.000000, 306.000000, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][2], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][2], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][2], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][2], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][2], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][2], 0);

			def_trade_main_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 289.799987, 305.899993, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][3], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][3], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][3], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][3], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][3], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][3], 0);

			def_trade_main_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 171.399963, 83.500007, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][4], 123.699989, 39.099983);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][4], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][4], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][4], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][4], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][4], 0);

			def_trade_main_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 167.000000, 89.000000, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][5], 133.000000, 34.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][5], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][5], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][5], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][5], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][5], 0);

			def_trade_main_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 167.000000, 122.400024, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][6], 133.000000, 190.800048);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][6], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][6], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][6], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][6], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][6], 0);

			def_trade_main_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 171.000000, 127.000000, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][7], 125.000000, 191.300018);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][7], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][7], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][7], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][7], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][7], 0);

			def_trade_main_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 166.000000, 125.000000, "particle:lamp_shad_64");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][8], 134.000000, 193.400085);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][8], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][8], 1630929302);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][8], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][8], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][8], 0);

			def_trade_main_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 207.000000, 175.000000, "ld_beat:chit"); // 1 круг click (зона клика)
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][9], 58.000000, 66.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][9], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][9], -1);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][9], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][9], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][9], 0);
			PlayerTextDrawSetSelectable(playerid, def_trade_main_PTD[playerid][9], true);

			def_trade_main_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 209.300018, 178.299957, "ld_beat:chit"); // 1 круг click 
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][10], 53.000000, 60.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][10], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][10], 891158783);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][10], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][10], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][10], 0);

			def_trade_main_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 236.000000, 203.000000, "CLICK"); // 1 круг click 
			PlayerTextDrawLetterSize(playerid, def_trade_main_PTD[playerid][11], 0.245333, 1.210072);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][11], 2);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][11], -1);
			PlayerTextDrawSetShadow(playerid, def_trade_main_PTD[playerid][11], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][11], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][11], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][11], 1);

			def_trade_main_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 325.000000, 81.000000, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][12], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][12], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][12], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][12], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][12], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][12], 0);

			def_trade_main_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 449.799987, 81.199996, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][13], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][13], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][13], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][13], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][13], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][13], 0);

			def_trade_main_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 325.000000, 306.000000, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][14], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][14], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][14], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][14], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][14], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][14], 0);

			def_trade_main_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 449.799987, 305.899993, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][15], 12.000000, 15.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][15], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][15], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][15], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][15], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][15], 0);

			def_trade_main_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 331.399963, 83.500007, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][16], 123.699989, 39.099983);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][16], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][16], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][16], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][16], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][16], 0);

			def_trade_main_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 327.000000, 89.000000, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][17], 133.000000, 34.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][17], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][17], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][17], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][17], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][17], 0);

			def_trade_main_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 327.000000, 122.400024, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][18], 133.000000, 190.800048);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][18], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][18], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][18], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][18], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][18], 0);

			def_trade_main_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 331.000000, 127.000000, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][19], 125.000000, 191.300018);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][19], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][19], 588513535);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][19], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][19], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][19], 0);

			def_trade_main_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 326.000000, 125.000000, "particle:lamp_shad_64");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][20], 134.000000, 193.400085);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][20], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][20], 1630929302);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][20], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][20], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][20], 0);

			def_trade_main_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 367.000000, 175.000000, "ld_beat:chit"); // 2 круг click (зона клика)
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][21], 58.000000, 66.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][21], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][21], -1);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][21], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][21], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][21], 0);
			PlayerTextDrawSetSelectable(playerid, def_trade_main_PTD[playerid][21], true);

			def_trade_main_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 369.300018, 178.299957, "ld_beat:chit"); // 2 круг click 
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][22], 53.000000, 60.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][22], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][22], 891158783);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][22], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][22], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][22], 0);

			def_trade_main_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 396.000000, 203.000000, "CLICK"); // 2 круг click 
			PlayerTextDrawLetterSize(playerid, def_trade_main_PTD[playerid][23], 0.245333, 1.210072);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][23], 2);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][23], -1);
			PlayerTextDrawSetShadow(playerid, def_trade_main_PTD[playerid][23], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][23], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][23], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][23], 1);

			def_trade_main_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 283.333343, 170.185180, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][24], 61.000000, 73.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][24], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][24], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][24], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][24], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][24], 0);

			def_trade_main_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 294.533111, 182.844497, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][25], 39.000000, 48.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][25], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][25], -1);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][25], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][25], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][25], 0);

			def_trade_main_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 298.000030, 186.777786, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][26], 32.000000, 40.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][26], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][26], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][26], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][26], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][26], 0);

			def_trade_main_PTD[playerid][27] = CreatePlayerTextDraw(playerid, 299.666717, 202.252014, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][27], 28.000000, 10.799947);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][27], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][27], -6416897);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][27], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][27], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][27], 0);

			def_trade_main_PTD[playerid][28] = CreatePlayerTextDraw(playerid, 271.999908, 171.592605, "");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][28], 63.000000, 77.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][28], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][28], -1);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][28], 0);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][28], 5);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][28], 0);
			PlayerTextDrawSetPreviewModel(playerid, def_trade_main_PTD[playerid][28], 19177);
			PlayerTextDrawSetPreviewRot(playerid, def_trade_main_PTD[playerid][28], 0.000000, 0.000000, 0.000000, 1.000000);

			def_trade_main_PTD[playerid][29] = CreatePlayerTextDraw(playerid, 293.300048, 166.592605, "");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][29], 63.000000, 77.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][29], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][29], -1);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][29], 0);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][29], 5);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][29], 0);
			PlayerTextDrawSetPreviewModel(playerid, def_trade_main_PTD[playerid][29], 19177);
			PlayerTextDrawSetPreviewRot(playerid, def_trade_main_PTD[playerid][29], 0.000000, -180.000000, 0.000000, 1.000000);
			
			def_trade_main_PTD[playerid][30] = CreatePlayerTextDraw(playerid, 284.666778, 357.430053, "ld_spac:white");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][30], 55.000000, 26.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][30], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][30], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][30], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][30], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][30], 0);
			PlayerTextDrawSetSelectable(playerid, def_trade_main_PTD[playerid][30], true);
			
			def_trade_main_PTD[playerid][31] = CreatePlayerTextDraw(playerid, 268.333435, 351.437316, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][31], 31.000000, 38.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][31], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][31], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][31], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][31], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][31], 0);

			def_trade_main_PTD[playerid][32] = CreatePlayerTextDraw(playerid, 324.233337, 351.437316, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][32], 31.000000, 38.000000);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][32], 1);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][32], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][32], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][32], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][32], 0);

			def_trade_main_PTD[playerid][33] = CreatePlayerTextDraw(playerid, 310.333160, 364.000396, TranslateText1 ( "ОТМЕНА" ) ) ;
			PlayerTextDrawLetterSize(playerid, def_trade_main_PTD[playerid][33], 0.305330, 1.346963);
			PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][33], 2);
			PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][33], -6416897);
			PlayerTextDrawSetShadow(playerid, def_trade_main_PTD[playerid][33], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][33], 255);
			PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][33], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][33], 1);
			
			for ( new i = 0 ; i < 34 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, def_trade_main_PTD [ playerid ] [ i ] ) ;
			}
			
			SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
		}
		else if ( player_device { playerid } == 2 )
		{
			showTrade ( playerid ) ;
			
			new _str [ 13 + MAX_PLAYER_NAME ], _str2 [ 32 ], _str3 [ 32 ], _trader_id = trade_rielt [ playerid ] [ trade_id ], _model ;
			format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ _trader_id ] [ name ] ) ;
			format ( _str2, sizeof _str2, "0"valute_title_", 0 "family_title"" ) ;
			format ( _str3, sizeof _str3, "0"valute_title_", 0 "family_title"" ) ;
			tradeUpdate ( playerid, _str, trade_rielt [ playerid ] [ trade_accept ], trade_rielt [ _trader_id ] [ trade_accept ], false, _str2, _str3 ) ;
			
			new _position = 0, _count = 0 ;
			for ( new i = 0 ; i < MAX_PRISE_SLOT ; i ++ )
			{
				_model = p_info [ playerid ] [ prise_slot ] [ i ] ;
				if ( _model < 1 ) 
				{
					_count ++ ;
					continue ;
				}

				format ( _str2, sizeof _str2, "%d", p_info [ playerid ] [ prise_slot_count ] [ i ] ) ;
				tradeUpdateItem ( playerid, _position, _count, item_render_type ( _model ), item_object_id ( playerid, _model ), item_name ( _model ), _str2, TRADE_RIELT_INVENTORY ) ;

				_position ++ ;
				_count ++ ;
			}
			
			_count = 0 ;
			for ( new i = 0 ; i < MAX_ACCESORIES ; i ++ )
			{
				_model = acc_player [ playerid ] [ acc_model ] [ i ] ;
				if ( _model < 1 )
				{
					_count ++ ;
					continue ;
				}
				
				tradeUpdateItem ( playerid, _position, _count, 1, _model, "", "Личный", TRADE_RIELT_ACCS ) ;
				
				_position ++ ;
				_count ++ ;
			}
			
			if ( in_business )
			{
				_count = 0 ;
				if ( Iter_Count(player_vehicles[playerid]) > 0 )
				{
					foreach(new _v_id: player_vehicles[playerid])
					{
						tradeUpdateItem ( playerid, _position, _v_id, 1, GetVehicleModelEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), "", "Из /cars", TRADE_RIELT_CAR ) ;

						_position ++ ;
						_count ++ ;
					}
				}
				
				_count = 0 ;
				for ( new i = 0 ; i < 5 ; i ++ )
				{
					_model = p_info [ playerid ] [ temp_skin ] [ i ] ;
					if ( _model < 1 )
					{
						_count ++ ;
						continue ;
					}
					
					tradeUpdateItem ( playerid, _position, _count, 1, _model, "", "Гардероб", TRADE_RIELT_SKIN ) ;

					_position ++ ;
					_count ++ ;
				}
				
				_count = 0 ;
				if ( Iter_Count(player_houses[playerid]) > 0 )
				{
					foreach(new h: player_houses[playerid])
					{
						format ( _str2, sizeof _str2, "Дом №%d", h ) ;
						tradeUpdateItem ( playerid, _position, h, -1, 55, "", _str2, TRADE_RIELT_HOUSE ) ;

						_position ++ ;
						_count ++ ;
					}
				}
				
				_count = 0 ;
				if ( Iter_Count(player_business[playerid]) > 0 )
				{
					foreach(new b: player_business[playerid])
					{
						format ( _str2, sizeof _str2, "Бизнес №%d", b ) ;
						tradeUpdateItem ( playerid, _position, b, -1, 55, "", _str2, TRADE_RIELT_BIZZ ) ;

						_position ++ ;
						_count ++ ;
					}
				}
				
				_count = 0 ;
				if ( p_info [ playerid ] [ cellar ] != -1 )
				{
					format ( _str2, sizeof _str2, "Гараж №%d", p_info [ playerid ] [ cellar ] ) ;
					tradeUpdateItem ( playerid, _position, p_info [ playerid ] [ cellar ], -1, 55, "", _str2, TRADE_RIELT_GARAGE ) ;

					_position ++ ;
					_count ++ ;
				}
				
				_count = 0 ;
				if ( p_info [ playerid ] [ family ] > 0 )
				{
					tradeUpdateItem ( playerid, _position, _count, -1, 56, "", "Семья", TRADE_RIELT_FAMILY ) ;

					_position ++ ;
					_count ++ ;
				}
				
				_count = 0 ;
				if ( p_info [ playerid ] [ number ] )
				{
					format ( _str2, sizeof _str2, "SIM %d", p_info [ playerid ] [ number ] ) ;
					tradeUpdateItem ( playerid, _position, _count, -1, 57, "", _str2, TRADE_RIELT_SIMCARD ) ;

					_position ++ ;
					_count ++ ;
				}
				
				_count = 0 ;
				for ( new i = 0 ; i < MAX_PLATES ; i ++ )
				{
					if ( varchar_plateid [ playerid ] [ i ] == -1 )
					{
						_count ++ ;
						continue ;
					}
					
					format ( _str2, sizeof _str2, "%s", plate_number1 ( varchar_platetype [ playerid ] [ i ], varchar_platename [ playerid ] [ i ], varchar_plateregion [ playerid ] [ i ] ) ) ;
					tradeUpdateItem ( playerid, _position, _count, -1, 57, "", _str2, TRADE_RIELT_PLATE ) ;

					_position ++ ;
					_count ++ ;
				}
			}
			
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 34 ; i ++ )
			{
				PlayerTextDrawDestroy ( playerid, def_trade_main_PTD [ playerid ] [ i ] ) ;
				def_trade_main_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
			
			CancelSelectTextDraw ( playerid ) ;
		}
		else if ( player_device { playerid } == 2 )
		{
			hideTrade ( playerid ) ;
	
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		}
	}
	return 1 ;
}

stock show_player_ptd ( playerid, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			new td_string [ MAX_PLAYER_NAME ] ;
			format ( td_string, sizeof td_string, "%s", p_info [ playerid ] [ name ] ) ;
			def_trade_player1_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 233.499969, 98.000000, td_string);
			PlayerTextDrawLetterSize(playerid, def_trade_player1_PTD[playerid][0], 0.290333, 1.330371);
			PlayerTextDrawTextSize(playerid, def_trade_player1_PTD[playerid][0], 0.000000, 126.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player1_PTD[playerid][0], 2);
			PlayerTextDrawColor(playerid, def_trade_player1_PTD[playerid][0], -1);
			PlayerTextDrawSetShadow(playerid, def_trade_player1_PTD[playerid][0], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player1_PTD[playerid][0], 255);
			PlayerTextDrawFont(playerid, def_trade_player1_PTD[playerid][0], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_player1_PTD[playerid][0], 1);

			def_trade_player1_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 206.000076, 303.918609, "ld_spac:white"); // зона клика
			PlayerTextDrawTextSize(playerid, def_trade_player1_PTD[playerid][1], 55.000000, 26.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player1_PTD[playerid][1], 1);
			PlayerTextDrawColor(playerid, def_trade_player1_PTD[playerid][1], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player1_PTD[playerid][1], 255);
			PlayerTextDrawFont(playerid, def_trade_player1_PTD[playerid][1], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_player1_PTD[playerid][1], 0);
			PlayerTextDrawSetSelectable(playerid, def_trade_player1_PTD[playerid][1], true);

			def_trade_player1_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 189.666702, 297.925872, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_player1_PTD[playerid][2], 31.000000, 38.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player1_PTD[playerid][2], 1);
			PlayerTextDrawColor(playerid, def_trade_player1_PTD[playerid][2], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player1_PTD[playerid][2], 255);
			PlayerTextDrawFont(playerid, def_trade_player1_PTD[playerid][2], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_player1_PTD[playerid][2], 0);

			def_trade_player1_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 245.566940, 297.925872, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_player1_PTD[playerid][3], 31.000000, 38.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player1_PTD[playerid][3], 1);
			PlayerTextDrawColor(playerid, def_trade_player1_PTD[playerid][3], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player1_PTD[playerid][3], 255);
			PlayerTextDrawFont(playerid, def_trade_player1_PTD[playerid][3], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_player1_PTD[playerid][3], 0);

			def_trade_player1_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 234.000000, 308.000000, "X");
			PlayerTextDrawLetterSize(playerid, def_trade_player1_PTD[playerid][4], 0.507664, 1.886222);
			PlayerTextDrawAlignment(playerid, def_trade_player1_PTD[playerid][4], 2);
			PlayerTextDrawColor(playerid, def_trade_player1_PTD[playerid][4], -196206337);
			PlayerTextDrawSetShadow(playerid, def_trade_player1_PTD[playerid][4], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player1_PTD[playerid][4], 255);
			PlayerTextDrawFont(playerid, def_trade_player1_PTD[playerid][4], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_player1_PTD[playerid][4], 1);

			for ( new i = 0 ; i < 5 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, def_trade_player1_PTD [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 25 ; i ++ )
			{
				if ( def_trade_player1_PTD [ playerid ] [ i ] == PlayerText:-1 ) continue ;
				
				PlayerTextDrawDestroy ( playerid, def_trade_player1_PTD [ playerid ] [ i ] ) ;
				def_trade_player1_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	return 1 ;
}

stock show_trader_ptd ( playerid, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			def_trade_player2_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 413.499969, 98.000000, "Kroumberg_Kroumberg");
			PlayerTextDrawLetterSize(playerid, def_trade_player2_PTD[playerid][0], 0.290333, 1.330371);
			PlayerTextDrawTextSize(playerid, def_trade_player2_PTD[playerid][0], 0.000000, 126.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player2_PTD[playerid][0], 2);
			PlayerTextDrawColor(playerid, def_trade_player2_PTD[playerid][0], -1);
			PlayerTextDrawSetShadow(playerid, def_trade_player2_PTD[playerid][0], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player2_PTD[playerid][0], 255);
			PlayerTextDrawFont(playerid, def_trade_player2_PTD[playerid][0], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_player2_PTD[playerid][0], 1);

			def_trade_player2_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 365.000091, 303.918609, "ld_spac:white"); // зона клика
			PlayerTextDrawTextSize(playerid, def_trade_player2_PTD[playerid][1], 55.000000, 26.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player2_PTD[playerid][1], 1);
			PlayerTextDrawColor(playerid, def_trade_player2_PTD[playerid][1], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player2_PTD[playerid][1], 255);
			PlayerTextDrawFont(playerid, def_trade_player2_PTD[playerid][1], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_player2_PTD[playerid][1], 0);
			PlayerTextDrawSetSelectable(playerid, def_trade_player2_PTD[playerid][1], true);

			def_trade_player2_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 348.666717, 297.925872, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_player2_PTD[playerid][2], 31.000000, 38.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player2_PTD[playerid][2], 1);
			PlayerTextDrawColor(playerid, def_trade_player2_PTD[playerid][2], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player2_PTD[playerid][2], 255);
			PlayerTextDrawFont(playerid, def_trade_player2_PTD[playerid][2], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_player2_PTD[playerid][2], 0);

			def_trade_player2_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 404.566955, 297.925872, "ld_beat:chit");
			PlayerTextDrawTextSize(playerid, def_trade_player2_PTD[playerid][3], 31.000000, 38.000000);
			PlayerTextDrawAlignment(playerid, def_trade_player2_PTD[playerid][3], 1);
			PlayerTextDrawColor(playerid, def_trade_player2_PTD[playerid][3], 756285695);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player2_PTD[playerid][3], 255);
			PlayerTextDrawFont(playerid, def_trade_player2_PTD[playerid][3], 4);
			PlayerTextDrawSetProportional(playerid, def_trade_player2_PTD[playerid][3], 0);

			def_trade_player2_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 393.000000, 308.000000, "V");
			PlayerTextDrawLetterSize(playerid, def_trade_player2_PTD[playerid][4], 0.507665, 1.886222);
			PlayerTextDrawAlignment(playerid, def_trade_player2_PTD[playerid][4], 2);
			PlayerTextDrawColor(playerid, def_trade_player2_PTD[playerid][4], -788653313);
			PlayerTextDrawSetShadow(playerid, def_trade_player2_PTD[playerid][4], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player2_PTD[playerid][4], 255);
			PlayerTextDrawFont(playerid, def_trade_player2_PTD[playerid][4], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_player2_PTD[playerid][4], 1);

			for ( new i = 0 ; i < 5 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, def_trade_player2_PTD [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 25 ; i ++ )
			{
				if ( def_trade_player2_PTD [ playerid ] [ i ] == PlayerText:-1 ) continue ;
				
				PlayerTextDrawDestroy ( playerid, def_trade_player2_PTD [ playerid ] [ i ] ) ;
				def_trade_player2_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	return 1 ;
}

stock check_add_player ( playerid, _type, _count_item, _id )
{
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != _type ) continue ;
		if ( trade_rielt [ playerid ] [ trade_count ] [ i ] == _count_item ) { } // чтоб не было варнинга
		if ( trade_rielt [ playerid ] [ trade_item ] [ i ] == _id ) return 1 ;
	}
	return 0 ;
}

stock show_remove_player ( playerid, _id )
{
	trade_rielt [ playerid ] [ trade_type ] [ _id ] =
	trade_rielt [ playerid ] [ trade_count ] [ _id ] =
	trade_rielt [ playerid ] [ trade_item ] [ _id ] = 0 ;
		
	if ( player_device { playerid } != 2 ) PlayerTextDrawSetString ( playerid, def_trade_player1_PTD [ playerid ] [ _id + 5 ], " " ) ;
	else if ( player_device { playerid } == 2 ) tradeDeleteSendItem ( playerid, _id ) ;
	
	new _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
	if ( player_device { _trader_id } != 2 ) PlayerTextDrawSetString ( _trader_id, def_trade_player2_PTD [ _trader_id ] [ _id + 5 ], " " ) ;
	else if ( player_device { _trader_id } == 2 ) tradeDeleteReceiveItem ( _trader_id, _id ) ;
	return 1 ;
}

stock show_add_player ( playerid, _type, _count_item, _id )
{
	new _count = -1, bool: _finded_type = false ;
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == 0 && _count == -1 ) _count = i ;
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != _type || trade_rielt [ playerid ] [ trade_item ] [ i ] != _id ) continue ;

		_count = i ;
		_finded_type = true ;
		break ;
	}
	
	if ( _count == -1 )
	{
		if ( player_device { playerid } == 2 ) send_check_cinfo ( playerid, "У Вас нет свободных слотов для обмена!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		else show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cRD"}* {"#cGRDialog"}У Вас нет свободных слотов для обмена!", "Закрыть", "" ) ;
		return 1 ;
	}
	
	trade_rielt [ playerid ] [ trade_type ] [ _count ] = _type ;
	trade_rielt [ playerid ] [ trade_count ] [ _count ] += _count_item ;
	trade_rielt [ playerid ] [ trade_item ] [ _count ] = _id ;

	if ( player_device { playerid } == 2 )
	{
		if ( _type == TRADE_RIELT_MONEY || _type == TRADE_RIELT_FAMILY_TALON )
		{
			new _slot_money = -1, _slot_family_talon = -1, _slot_money_trader = -1, _slot_family_talon_trader = -1, _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money_trader = i ;
				else if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon_trader = i ;
				
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money = i ;
				else if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon = i ;
			}
			
			new _str [ 13 + MAX_PLAYER_NAME ], _str2 [ 64 ], _str3 [ 64 ] ;
			format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ _trader_id ] [ name ] ) ;
			format ( _str2, sizeof _str2, "%d"valute_title_", %d "family_title"", ( _slot_money == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_money ] ), ( _slot_family_talon == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_family_talon ] ) ) ;
			format ( _str3, sizeof _str3, "%d"valute_title_", %d "family_title"", ( _slot_money_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_money_trader ] ), ( _slot_family_talon_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_family_talon_trader ] ) ) ;
			tradeUpdate ( playerid, _str, false, false, false, _str2, _str3 ) ;
		}
		else
		{
			new td_string [ 32 ] ;
			switch ( _type )
			{
				case TRADE_RIELT_HOUSE:
				{
					format ( td_string, sizeof td_string, "Дом №%d", _id ) ;
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, -1, 55, "", td_string, TRADE_RIELT_HOUSE ) ;
					else tradeAddSendItem ( playerid, _count, _count, -1, 55, "", td_string, TRADE_RIELT_HOUSE ) ;
				}
				case TRADE_RIELT_BIZZ:
				{
					format ( td_string, sizeof td_string, "Бизнес №%d", _id ) ;
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, -1, 55, "", td_string, TRADE_RIELT_BIZZ ) ;
					else tradeAddSendItem ( playerid, _count, _count, -1, 55, "", td_string, TRADE_RIELT_BIZZ ) ;
				}
				case TRADE_RIELT_CAR:
				{
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, 1, GetVehicleModelEx ( veh_info [ _id - 1 ] [ v_vehicle ] ), "", "Из /cars", TRADE_RIELT_CAR ) ;
					else tradeAddSendItem ( playerid, _count, _count, 1, GetVehicleModelEx ( veh_info [ _id - 1 ] [ v_vehicle ] ), "", "Из /cars", TRADE_RIELT_CAR ) ;
				}
				case TRADE_RIELT_ACCS:
				{
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, 1, _count_item, "", "Личный", TRADE_RIELT_ACCS ) ;
					else tradeAddSendItem ( playerid, _count, _count, 1, _count_item, "", "Личный", TRADE_RIELT_ACCS ) ;
				}
				case TRADE_RIELT_INVENTORY:
				{
					format ( td_string, sizeof td_string, "%d", trade_rielt [ playerid ] [ trade_count ] [ _count ] ) ;
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, item_render_type ( _id ), item_object_id ( playerid, _id ), "", td_string, TRADE_RIELT_INVENTORY ) ;
					else tradeAddSendItem ( playerid, _count, _count, item_render_type ( _id ), item_object_id ( playerid, _id ), "", td_string, TRADE_RIELT_INVENTORY ) ;
				}
				case TRADE_RIELT_GARAGE:
				{
					format ( td_string, sizeof td_string, "Гараж №%d", _id ) ;
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, -1, 55, "", td_string, TRADE_RIELT_GARAGE ) ;
					else tradeAddSendItem ( playerid, _count, _count, -1, 55, "", td_string, TRADE_RIELT_GARAGE ) ;
				}
				case TRADE_RIELT_SKIN:
				{
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, 1, _count_item, "", "Гардероб", TRADE_RIELT_SKIN ) ;
					else tradeAddSendItem ( playerid, _count, _count, 1, _count_item, "", "Гардероб", TRADE_RIELT_SKIN ) ;
				}
				case TRADE_RIELT_PLATE:
				{
					format ( trade_plate_name [ playerid ] [ _count ], 24, "%s", trade_char_plate [ playerid ] ) ;
					format ( td_string, sizeof td_string, "%s", trade_plate_name [ playerid ] [ _count ] ) ;
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, -1, 57, "", td_string, TRADE_RIELT_PLATE ) ;
					else tradeAddSendItem ( playerid, _count, _count, -1, 57, "", td_string, TRADE_RIELT_PLATE ) ;
				}
				case TRADE_RIELT_FAMILY:
				{
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, -1, 56, "", "Семья", TRADE_RIELT_FAMILY ) ;
					else tradeAddSendItem ( playerid, _count, _count, -1, 56, "", "Семья", TRADE_RIELT_FAMILY ) ;
				}
				case TRADE_RIELT_SIMCARD:
				{
					format ( td_string, sizeof td_string, "SIM %d", _count_item ) ;
					if ( _finded_type ) tradeUpdateSendItem ( playerid, _count, _count, -1, 57, "", td_string, TRADE_RIELT_SIMCARD ) ;
					else tradeAddSendItem ( playerid, _count, _count, -1, 57, "", td_string, TRADE_RIELT_SIMCARD ) ;
				}
			}
		}
	}
	else
	{
		new td_string [ 42 ] ;
		switch ( _type )
		{
			case TRADE_RIELT_MONEY: format ( td_string, sizeof td_string, "%d. %s$", _count + 1, GetPlayerCashValueToSmile ( trade_rielt [ playerid ] [ trade_count ] [ _count ] ) ) ;
			case TRADE_RIELT_FAMILY_TALON: format ( td_string, sizeof td_string, "%d. %s "family_title"", _count + 1, GetPlayerCashValueToSmile ( trade_rielt [ playerid ] [ trade_count ] [ _count ] ) ) ;
			case TRADE_RIELT_HOUSE: format ( td_string, sizeof td_string, "%d. %s (№%d)", _count + 1, TranslateText1 ( "Дом" ), trade_rielt [ playerid ] [ trade_item ] [ _count ] ) ;
			case TRADE_RIELT_BIZZ: format ( td_string, sizeof td_string, "%d. %s (№%d)", _count + 1, TranslateText1 ( "Бизнес" ), trade_rielt [ playerid ] [ trade_item ] [ _count ] ) ;
			case TRADE_RIELT_CAR: 
			{
				new _v_id = trade_rielt [ playerid ] [ trade_item ] [ _count ] ;
				if ( ! IsValidVehicle ( _v_id ) || _v_id < 0 || _v_id > 2000 ) 
				{
					show_remove_player ( playerid, _count ) ;
				}
				else format ( td_string, sizeof td_string, "%d. %s (%s)", _count + 1, TranslateText1 ( "Транспорт" ), GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ) ) ;
			}
			case TRADE_RIELT_ACCS: format ( td_string, sizeof td_string, "%d. %s", _count + 1, TranslateText1 ( "Нажмите для просмотра" ) ) ;
			case TRADE_RIELT_INVENTORY: format ( td_string, sizeof td_string, "%d. %s", _count + 1, TranslateText1 ( "Нажмите для просмотра" ) ) ;
			case TRADE_RIELT_GARAGE: format ( td_string, sizeof td_string, "%d. %s (№%d)", _count + 1, TranslateText1 ( "Гараж" ), trade_rielt [ playerid ] [ trade_item ] [ _count ] ) ;
			case TRADE_RIELT_RETURN_MONEY: format ( td_string, sizeof td_string, "%d. %s$", _count + 1, GetPlayerCashValueToSmile ( trade_rielt [ playerid ] [ trade_count ] [ _count ] ) ) ;
			case TRADE_RIELT_SKIN: format ( td_string, sizeof td_string, "%d. %s (№%d)", _count + 1, TranslateText1 ( "Одежда" ), trade_rielt [ playerid ] [ trade_count ] [ _count ] ) ;
			case TRADE_RIELT_PLATE: format ( td_string, sizeof td_string, "%d. %s", _count + 1, trade_plate_name [ playerid ] [ _count ] ) ;
			case TRADE_RIELT_FAMILY: format ( td_string, sizeof td_string, "%d. %s", _count + 1, TranslateText1 ( "Семья" ) ) ;
			case TRADE_RIELT_SIMCARD: format ( td_string, sizeof td_string, "%d. %s (№%d)", _count + 1, TranslateText1 ( "SIM-карта" ), trade_rielt [ playerid ] [ trade_count ] [ _count ] ) ;
		}
		
		if ( _finded_type == true ) PlayerTextDrawSetString ( playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], td_string ) ;
		else
		{
			def_trade_player1_PTD [ playerid ] [ _count + 5 ] = CreatePlayerTextDraw(playerid, def_trade_player1_pos [ _count ] [ 0 ], def_trade_player1_pos [ _count ] [ 1 ], td_string);
			PlayerTextDrawLetterSize(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], 0.217333, 1.039999);
			PlayerTextDrawAlignment(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], 1);
			PlayerTextDrawColor(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], -1);
			PlayerTextDrawSetShadow(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], 255);
			PlayerTextDrawFont(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ], 1);
			
			PlayerTextDrawShow ( playerid, def_trade_player1_PTD [ playerid ] [ _count + 5 ] ) ;
		}
	}
	
	trade_rielt [ playerid ] [ trade_accept ] = false ;
	if ( player_device { playerid } != 2 )
	{
		PlayerTextDrawDestroy ( playerid, def_trade_main_PTD [ playerid ] [ 9 ] ) ;
		PlayerTextDrawDestroy ( playerid, def_trade_main_PTD [ playerid ] [ 10 ] ) ;
		PlayerTextDrawDestroy ( playerid, def_trade_main_PTD [ playerid ] [ 11 ] ) ;
		
		def_trade_main_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 207.000000, 175.000000, " "); // 1 круг click (зона клика)
		PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][9], 58.000000, 66.000000);
		PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][9], 1);
		PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][9], -1);
		PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][9], 255);
		PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][9], 0);
		PlayerTextDrawSetSelectable(playerid, def_trade_main_PTD[playerid][9], true);

		def_trade_main_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 209.300018, 178.299957, " "); // 1 круг click 
		PlayerTextDrawTextSize(playerid, def_trade_main_PTD[playerid][10], 53.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][10], 1);
		PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][10], 891158783);
		PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][10], 255);
		PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][10], 4);
		PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][10], 0);

		def_trade_main_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 236.000000, 203.000000, " "); // 1 круг click 
		PlayerTextDrawLetterSize(playerid, def_trade_main_PTD[playerid][11], 0.245333, 1.210072);
		PlayerTextDrawAlignment(playerid, def_trade_main_PTD[playerid][11], 2);
		PlayerTextDrawColor(playerid, def_trade_main_PTD[playerid][11], -1);
		PlayerTextDrawSetShadow(playerid, def_trade_main_PTD[playerid][11], 0);
		PlayerTextDrawBackgroundColor(playerid, def_trade_main_PTD[playerid][11], 255);
		PlayerTextDrawFont(playerid, def_trade_main_PTD[playerid][11], 1);
		PlayerTextDrawSetProportional(playerid, def_trade_main_PTD[playerid][11], 1);
		
		PlayerTextDrawShow ( playerid, def_trade_main_PTD [ playerid ] [ 9 ] ) ;
		PlayerTextDrawShow ( playerid, def_trade_main_PTD [ playerid ] [ 10 ] ) ;
		PlayerTextDrawShow ( playerid, def_trade_main_PTD [ playerid ] [ 11 ] ) ;
		
		
		
		PlayerTextDrawSetString ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ], "X" ) ;
				
		PlayerTextDrawHide ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ] ) ;
		PlayerTextDrawColor ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ], -196206337 ) ;
		PlayerTextDrawShow ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ] ) ;
		
		
		
		PlayerTextDrawSetString ( playerid, def_trade_player2_PTD [ playerid ] [ 4 ], "X" ) ;
					
		PlayerTextDrawHide ( playerid, def_trade_player2_PTD [ playerid ] [ 4 ] ) ;
		PlayerTextDrawColor ( playerid, def_trade_player2_PTD [ playerid ] [ 4 ], -196206337 ) ;
		PlayerTextDrawShow ( playerid, def_trade_player2_PTD [ playerid ] [ 4 ] ) ;
	}
	else if ( player_device { playerid } == 2 )
	{
		
	}
	
	new _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
	trade_rielt [ _trader_id ] [ trade_accept ] = false ;
	if ( player_device { _trader_id } != 2 )
	{
		PlayerTextDrawDestroy ( _trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ] ) ;
		PlayerTextDrawDestroy ( _trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ] ) ;
		PlayerTextDrawDestroy ( _trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ] ) ;
		
		def_trade_main_PTD [ _trader_id ] [ 21 ] = CreatePlayerTextDraw(_trader_id, 367.000000, 175.000000, " "); // 2 круг click (зона клика)
		PlayerTextDrawTextSize(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], 58.000000, 66.000000);
		PlayerTextDrawAlignment(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], 1);
		PlayerTextDrawColor(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], -1);
		PlayerTextDrawBackgroundColor(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], 255);
		PlayerTextDrawFont(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], 4);
		PlayerTextDrawSetProportional(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], 0);
		PlayerTextDrawSetSelectable(_trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ], true);

		def_trade_main_PTD [ _trader_id ] [ 22 ] = CreatePlayerTextDraw(_trader_id, 369.300018, 178.299957, " "); // 2 круг click 
		PlayerTextDrawTextSize(_trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ], 53.000000, 60.000000);
		PlayerTextDrawAlignment(_trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ], 1);
		PlayerTextDrawColor(_trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ], 891158783);
		PlayerTextDrawBackgroundColor(_trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ], 255);
		PlayerTextDrawFont(_trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ], 4);
		PlayerTextDrawSetProportional(_trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ], 0);

		def_trade_main_PTD [ _trader_id ] [ 23 ] = CreatePlayerTextDraw(_trader_id, 396.000000, 203.000000, " "); // 2 круг click 
		PlayerTextDrawLetterSize(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], 0.245333, 1.210072);
		PlayerTextDrawAlignment(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], 2);
		PlayerTextDrawColor(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], -1);
		PlayerTextDrawSetShadow(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], 0);
		PlayerTextDrawBackgroundColor(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], 255);
		PlayerTextDrawFont(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], 1);
		PlayerTextDrawSetProportional(_trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ], 1);
		
		PlayerTextDrawShow ( _trader_id, def_trade_main_PTD [ _trader_id ] [ 21 ] ) ;
		PlayerTextDrawShow ( _trader_id, def_trade_main_PTD [ _trader_id ] [ 22 ] ) ;
		PlayerTextDrawShow ( _trader_id, def_trade_main_PTD [ _trader_id ] [ 23 ] ) ;



		
		PlayerTextDrawSetString ( _trader_id, def_trade_player1_PTD [ _trader_id ] [ 4 ], "X" ) ;
				
		PlayerTextDrawHide ( _trader_id, def_trade_player1_PTD [ _trader_id ] [ 4 ] ) ;
		PlayerTextDrawColor ( _trader_id, def_trade_player1_PTD [ _trader_id ] [ 4 ], -196206337 ) ;
		PlayerTextDrawShow ( _trader_id, def_trade_player1_PTD [ _trader_id ] [ 4 ] ) ;
		
		
		
		PlayerTextDrawSetString ( _trader_id, def_trade_player2_PTD [ _trader_id ] [ 4 ], "X" ) ;
					
		PlayerTextDrawHide ( _trader_id, def_trade_player2_PTD [ _trader_id ] [ 4 ] ) ;
		PlayerTextDrawColor ( _trader_id, def_trade_player2_PTD [ _trader_id ] [ 4 ], -196206337 ) ;
		PlayerTextDrawShow ( _trader_id, def_trade_player2_PTD [ _trader_id ] [ 4 ] ) ;
	}
	else if ( player_device { _trader_id } == 2 )
	{
		
	}
	
	show_add_trader ( trade_rielt [ playerid ] [ trade_id ], _type, _count, _finded_type ) ;
	return 1 ;
}

stock show_add_trader ( playerid, _type, _slot, bool: status )
{
	new td_string [ 42 ], _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
	
	if ( player_device { playerid } == 2 )
	{
		if ( _trader_id == INVALID_PLAYER_ID )
		{
			clear_player_trade ( playerid ) ;
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cRD"}* {"#cGRDialog"}Произошла ошибка! Предложите обмен повторно.", "Закрыть", "" ) ;
			return 1 ;
		}
		
		if ( _type == TRADE_RIELT_MONEY || _type == TRADE_RIELT_FAMILY_TALON )
		{
			new _slot_money = -1, _slot_family_talon = -1, _slot_money_trader = -1, _slot_family_talon_trader = -1 ;
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money_trader = i ;
				else if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon_trader = i ;
				
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money = i ;
				else if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon = i ;
			}
			
			new _str [ 13 + MAX_PLAYER_NAME ], _str2 [ 64 ], _str3 [ 64 ] ;
			format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ _trader_id ] [ name ] ) ;
			format ( _str2, sizeof _str2, "%d"valute_title_", %d "family_title"", ( _slot_money == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_money ] ), ( _slot_family_talon == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_family_talon ] ) ) ;
			format ( _str3, sizeof _str3, "%d"valute_title_", %d "family_title"", ( _slot_money_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_money_trader ] ), ( _slot_family_talon_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_family_talon_trader ] ) ) ;
			tradeUpdate ( playerid, _str, false, false, false, _str2, _str3 ) ;
		}
		else
		{
			switch ( _type )
			{
				case TRADE_RIELT_HOUSE:
				{
					format ( td_string, sizeof td_string, "Дом №%d", trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ) ;
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, -1, 55, "", td_string, TRADE_RIELT_HOUSE ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, -1, 55, "", td_string, TRADE_RIELT_HOUSE ) ;
				}
				case TRADE_RIELT_BIZZ:
				{
					format ( td_string, sizeof td_string, "Дом №%d", trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ) ;
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, -1, 55, "", td_string, TRADE_RIELT_BIZZ ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, -1, 55, "", td_string, TRADE_RIELT_BIZZ ) ;
				}
				case TRADE_RIELT_CAR:
				{
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, 1, GetVehicleModelEx ( veh_info [ trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] - 1 ] [ v_vehicle ] ), "", "Из /cars", TRADE_RIELT_CAR ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, 1, GetVehicleModelEx ( veh_info [ trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] - 1 ] [ v_vehicle ] ), "", "Из /cars", TRADE_RIELT_CAR ) ;
				}
				case TRADE_RIELT_ACCS:
				{
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, 1, trade_rielt [ _trader_id ] [ trade_count ] [ _slot ], "", "Личный", TRADE_RIELT_ACCS ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, 1, trade_rielt [ _trader_id ] [ trade_count ] [ _slot ], "", "Личный", TRADE_RIELT_ACCS ) ;
				}
				case TRADE_RIELT_INVENTORY:
				{
					format ( td_string, sizeof td_string, "%d", trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ;
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, item_render_type ( trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ), item_object_id ( playerid, trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ), "", td_string, TRADE_RIELT_INVENTORY ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, item_render_type ( trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ), item_object_id ( playerid, trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ), "", td_string, TRADE_RIELT_INVENTORY ) ;
				}
				case TRADE_RIELT_GARAGE:
				{
					format ( td_string, sizeof td_string, "Гараж №%d", trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ) ;
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, -1, 55, "", td_string, TRADE_RIELT_GARAGE ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, -1, 55, "", td_string, TRADE_RIELT_GARAGE ) ;
				}
				case TRADE_RIELT_SKIN:
				{
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, 1, trade_rielt [ _trader_id ] [ trade_count ] [ _slot ], "", "Гардероб", TRADE_RIELT_SKIN ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, 1, trade_rielt [ _trader_id ] [ trade_count ] [ _slot ], "", "Гардероб", TRADE_RIELT_SKIN ) ;
				}
				case TRADE_RIELT_PLATE:
				{
					format ( td_string, sizeof td_string, "%s", trade_plate_name [ _trader_id ] [ _slot ] ) ;
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, -1, 57, "", td_string, TRADE_RIELT_PLATE ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, -1, 57, "", td_string, TRADE_RIELT_PLATE ) ;
				}
				case TRADE_RIELT_FAMILY:
				{
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, -1, 56, "", "Семья", TRADE_RIELT_FAMILY ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, -1, 56, "", "Семья", TRADE_RIELT_FAMILY ) ;
				}
				case TRADE_RIELT_SIMCARD:
				{
					format ( td_string, sizeof td_string, "SIM %d", trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ;
					if ( status ) tradeUpdateReceiveItem ( playerid, _slot, _slot, -1, 57, "", td_string, TRADE_RIELT_SIMCARD ) ;
					else tradeAddReceiveItem ( playerid, _slot, _slot, -1, 57, "", td_string, TRADE_RIELT_SIMCARD ) ;
				}
			}
		}
	}
	else
	{
		if ( _trader_id == INVALID_PLAYER_ID )
		{
			clear_player_trade ( playerid ) ;
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cRD"}* {"#cGRDialog"}Произошла ошибка! Предложите обмен повторно.", "Закрыть", "" ) ;
			return 1 ;
		}
	
		switch ( _type )
		{
			case TRADE_RIELT_MONEY: format ( td_string, sizeof td_string, "%d. %s$", _slot + 1, GetPlayerCashValueToSmile ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ) ;
			case TRADE_RIELT_FAMILY_TALON: format ( td_string, sizeof td_string, "%d. %s "family_title"", _slot + 1, GetPlayerCashValueToSmile ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ) ;
			case TRADE_RIELT_HOUSE: format ( td_string, sizeof td_string, "%d. %s (№%d)", _slot + 1, TranslateText1 ( "Дом" ), trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ) ;
			case TRADE_RIELT_BIZZ: format ( td_string, sizeof td_string, "%d. %s (№%d)", _slot + 1, TranslateText1 ( "Бизнес" ), trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ) ;
			case TRADE_RIELT_CAR: 
			{
				new _v_id = trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ;
				if ( ! IsValidVehicle ( _v_id ) || _v_id < 0 || _v_id > 2000 )
				{
					show_remove_player ( _trader_id, _slot ) ;
				}
				else format ( td_string, sizeof td_string, "%d. %s (%s)", _slot + 1, TranslateText1 ( "Транспорт" ), GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ) ) ;
			}
			case TRADE_RIELT_ACCS: format ( td_string, sizeof td_string, "%d. %s", _slot + 1, TranslateText1 ( "Нажмите для просмотра" ) ) ;
			case TRADE_RIELT_INVENTORY: format ( td_string, sizeof td_string, "%d. %s", _slot + 1, TranslateText1 ( "Нажмите для просмотра" ) ) ;
			case TRADE_RIELT_GARAGE: format ( td_string, sizeof td_string, "%d. %s (№%d)", _slot + 1, TranslateText1 ( "Гараж" ), trade_rielt [ _trader_id ] [ trade_item ] [ _slot ] ) ;
			case TRADE_RIELT_RETURN_MONEY: format ( td_string, sizeof td_string, "%d. %s$", _slot + 1, GetPlayerCashValueToSmile ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ) ;
			case TRADE_RIELT_SKIN: format ( td_string, sizeof td_string, "%d. %s (№%d)", _slot + 1, TranslateText1 ( "Одежда" ), trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ;
			case TRADE_RIELT_PLATE: format ( td_string, sizeof td_string, "%d. %s", _slot + 1, trade_plate_name [ _trader_id ] [ _slot ] ) ;
			case TRADE_RIELT_FAMILY: format ( td_string, sizeof td_string, "%d. %s", _slot + 1, TranslateText1 ( "Семья" ) ) ;
			case TRADE_RIELT_SIMCARD: format ( td_string, sizeof td_string, "%d. %s (№%d)", _slot + 1, TranslateText1 ( "SIM-карта" ), trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ;
		}
		
		if ( def_trade_player2_PTD [ playerid ] [ _slot + 5 ] != PlayerText:-1 ) PlayerTextDrawSetString ( playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], td_string ) ;
		else
		{
			format ( td_string, sizeof td_string, "%d. %s "family_title"", _slot + 1, GetPlayerCashValueToSmile ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot ] ) ) ;
			def_trade_player2_PTD [ playerid ] [ _slot + 5 ] = CreatePlayerTextDraw(playerid, def_trade_player2_pos [ _slot ] [ 0 ], def_trade_player2_pos [ _slot ] [ 1 ], td_string ) ;
			PlayerTextDrawLetterSize(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], 0.217333, 1.039999);
			PlayerTextDrawAlignment(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], 1);
			PlayerTextDrawColor(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], -1);
			PlayerTextDrawSetShadow(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], 0);
			PlayerTextDrawBackgroundColor(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], 255);
			PlayerTextDrawFont(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], 1);
			PlayerTextDrawSetProportional(playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ], 1);
				
			PlayerTextDrawShow ( playerid, def_trade_player2_PTD [ playerid ] [ _slot + 5 ] ) ;
		}
	}
	return 1 ;
}

stock sucess_trade ( playerid, targetid )
{
	new bool: _trade_sim = false ;
	new _sucess_biz = false, _c_biz [ 2 ] = { 0, ... } ;
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_BIZZ ) continue ;
		
		for ( new q = 0 ; q < MAX_TRADE_SLOT ; q ++ )
		{
			if ( trade_rielt [ targetid ] [ trade_type ] [ q ] != TRADE_RIELT_BIZZ ) continue ;
			
			_sucess_biz = true ;
			break ;
		}
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_BIZZ ) continue ;
		
		_c_biz [ 0 ] ++ ;
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ targetid ] [ trade_type ] [ i ] != TRADE_RIELT_BIZZ ) continue ;
		
		_c_biz [ 1 ] ++ ;
	}
	
	
	
	
	
	
	
	new _sucess_house = false, _c_house [ 2 ] = { 0, ... } ;
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_HOUSE ) continue ;
		
		for ( new q = 0 ; q < MAX_TRADE_SLOT ; q ++ )
		{
			if ( trade_rielt [ targetid ] [ trade_type ] [ q ] != TRADE_RIELT_HOUSE ) continue ;
			
			_sucess_house = true ;
			break ;
		}
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_HOUSE ) continue ;
		
		_c_house [ 0 ] ++ ;
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ targetid ] [ trade_type ] [ i ] != TRADE_RIELT_HOUSE ) continue ;
		
		_c_house [ 1 ] ++ ;
	}
	
	
	
	
	
	new _sucess_car = false, _c_car [ 2 ] = { 0, ... } ;
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_CAR ) continue ;
		
		for ( new q = 0 ; q < MAX_TRADE_SLOT ; q ++ )
		{
			if ( trade_rielt [ targetid ] [ trade_type ] [ q ] != TRADE_RIELT_CAR ) continue ;
			
			_sucess_car = true ;
			break ;
		}
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_CAR ) continue ;
		
		_c_car [ 0 ] ++ ;
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ targetid ] [ trade_type ] [ i ] != TRADE_RIELT_CAR ) continue ;
		
		_c_car [ 1 ] ++ ;
	}
	
	
	
	
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == 0 ) continue ;
		switch ( trade_rielt [ playerid ] [ trade_type ] [ i ] )
		{
			case TRADE_RIELT_HOUSE:
			{
				if ( Iter_Count(player_houses[targetid]) + _c_house [ 0 ] > p_info [ targetid ] [ max_house ] && ! _sucess_house )
			  	{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_BIZZ:
			{
				if ( Iter_Count(player_business[targetid]) + _c_biz [ 0 ] > p_info [ targetid ] [ max_biz ] && ! _sucess_biz )
			  	{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_MONEY:
			{
				new _sum = trade_rielt [ playerid ] [ trade_count ] [ i ] ;
				if ( p_info [ targetid ] [ money ] + _sum > max_money || p_info [ targetid ] [ money ] + _sum < 1 || _sum < 1 || _sum > max_money )
				{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Баланс не может превышать сумму в 1.800.000.000$! Уберите часть денег в банк!", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока лимит средств!", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_CAR:
			{
				if ( get_player_veh_count ( targetid ) + _c_car [ 0 ] > p_info [ targetid ] [ max_veh ] && ! _sucess_car )
				{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть транспорт. (Нет свободного слота)", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть транспорт. (Нет свободного слота)", "Закрыть", "" ) ;
					return 1 ;
				}
				
				new _veh_id = trade_rielt [ playerid ] [ trade_item ] [ i ] ;
				if ( ! IsValidVehicle ( _veh_id ) || veh_info [ _veh_id - 1 ] [ v_type ] != vehicle_type_player || veh_info [ _veh_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] )
				{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Ваш транспорт не загружен в игру.", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Транспорт игрока не загружен в игру.", "Закрыть", "" ) ;
					return 1 ;
				}
				
				if ( veh_info [ _veh_id - 1 ] [ v_date_used ] == -1 && ( get_player_veh_count ( playerid ) - 1 ) + _c_car [ 1 ] > p_info [ playerid ] [ max_veh ] && _sucess_car )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Вы обмениваете т/с с временным слотом.\nДля обмена у Вас не хватает слотов под т/с.", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Игрок обменивает т/с с временным слотом.\nДля обмена у Игрока не хватает слотов под т/с.", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_ACCS:
			{
				continue ;
			}
			case TRADE_RIELT_INVENTORY:
			{
				for ( new q = 0 ; q < MAX_PRISE_SLOT ; q ++ )
				{
					if ( p_info [ targetid ] [ prise_slot ] [ q ] != trade_rielt [ targetid ] [ trade_item ] [ i ] ) continue ;
					if ( p_info [ targetid ] [ prise_slot_count ] [ q ] < trade_rielt [ targetid ] [ trade_count ] [ i ] )
					{
						show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока нет такого количества предметов.", "Закрыть", "" ) ;
						show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас нет такого количества предметов.", "Закрыть", "" ) ;
						return 1 ;
					}
					
					break ;
				}
				continue ;
			}
			case TRADE_RIELT_GARAGE:
			{
				if ( p_info [ targetid ] [ cellar ] != -1 )
				{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть гараж.", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть гараж.", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_RETURN_MONEY:
			{
				continue ;
			}
			case TRADE_RIELT_SKIN:
			{
				continue ;
			}
			case TRADE_RIELT_PLATE:
			{
				if ( plate_count [ targetid ] + 1 >= MAX_PLATES )
				{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас максимальное количество номерных знаков.", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока максимальное количество номерных знаков.", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_FAMILY:
			{
				continue ;
			}
			case TRADE_RIELT_FAMILY_TALON:
			{
				continue ;
			}
			case TRADE_RIELT_SIMCARD:
			{
				continue ;
			}
		}
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ targetid ] [ trade_type ] [ i ] == 0 ) continue ;
		switch ( trade_rielt [ targetid ] [ trade_type ] [ i ] )
		{
			case TRADE_RIELT_HOUSE:
			{
				if ( Iter_Count(player_houses[playerid]) + _c_house [ 1 ] > p_info [ playerid ] [ max_house ] && ! _sucess_house )
			  	{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_BIZZ:
			{
				if ( Iter_Count(player_business[playerid]) + _c_biz [ 1 ] > p_info [ playerid ] [ max_biz ] && ! _sucess_biz )
			  	{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть недвижимость. (Нет свободного слота)", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_MONEY:
			{
				new _sum = trade_rielt [ targetid ] [ trade_count ] [ i ] ;
				if ( p_info [ playerid ] [ money ] + _sum > max_money || p_info [ playerid ] [ money ] + _sum < 1 || _sum < 1 || _sum > max_money )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Баланс не может превышать сумму в 1.800.000.000$! Уберите часть денег в банк!", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока лимит средств!", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_CAR:
			{
				if ( get_player_veh_count ( playerid ) + _c_car [ 1 ] > p_info [ playerid ] [ max_veh ] && ! _sucess_car )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть транспорт. (Нет свободного слота)", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть транспорт. (Нет свободного слота)", "Закрыть", "" ) ;
					return 1 ;
				}
				
				new _veh_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
				if ( ! IsValidVehicle ( _veh_id ) || veh_info [ _veh_id - 1 ] [ v_type ] != vehicle_type_player || veh_info [ _veh_id - 1 ] [ v_owner ] != p_info [ targetid ] [ id ] )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Ваш транспорт не загружен в игру.", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Транспорт игрока не загружен в игру.", "Закрыть", "" ) ;
					return 1 ;
				}
				
				if ( veh_info [ _veh_id - 1 ] [ v_date_used ] == -1 && ( get_player_veh_count ( targetid ) - 1 ) + _c_car [ 0 ] > p_info [ targetid ] [ max_veh ] && _sucess_car )
				{
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Вы обмениваете т/с с временным слотом.\nДля обмена у Вас не хватает слотов под т/с.", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Игрок обменивает т/с с временным слотом.\nДля обмена у Игрока не хватает слотов под т/с.", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_ACCS:
			{
				continue ;
			}
			case TRADE_RIELT_INVENTORY:
			{
				for ( new q = 0 ; q < MAX_PRISE_SLOT ; q ++ )
				{
					if ( p_info [ playerid ] [ prise_slot ] [ q ] != trade_rielt [ playerid ] [ trade_item ] [ i ] ) continue ;
					if ( p_info [ playerid ] [ prise_slot_count ] [ q ] < trade_rielt [ playerid ] [ trade_count ] [ i ] )
					{
						show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока нет такого количества предметов.", "Закрыть", "" ) ;
						show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас нет такого количества предметов.", "Закрыть", "" ) ;
						return 1 ;
					}
					
					break ;
				}
				continue ;
			}
			case TRADE_RIELT_GARAGE:
			{
				if ( p_info [ playerid ] [ cellar ] != -1 )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас в собственности уже есть гараж.", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока уже есть гараж.", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_RETURN_MONEY:
			{
				continue ;
			}
			case TRADE_RIELT_SKIN:
			{
				continue ;
			}
			case TRADE_RIELT_PLATE:
			{
				if ( plate_count [ playerid ] + 1 >= MAX_PLATES )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У Вас максимальное количество номерных знаков.", "Закрыть", "" ) ;
					show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}У игрока максимальное количество номерных знаков.", "Закрыть", "" ) ;
					return 1 ;
				}
				continue ;
			}
			case TRADE_RIELT_FAMILY:
			{
				continue ;
			}
			case TRADE_RIELT_FAMILY_TALON:
			{
				continue ;
			}
			case TRADE_RIELT_SIMCARD:
			{
				continue ;
			}
		}
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == 0 ) continue ;
		switch ( trade_rielt [ playerid ] [ trade_type ] [ i ] )
		{
			case TRADE_RIELT_HOUSE:
			{
				new house_id = trade_rielt [ playerid ] [ trade_item ] [ i ], query_string [ 135 + MAX_PLAYER_NAME + ( 9 * 2 ) ] ;
				p_info [ targetid ] [ house ] = house_id ;
				p_info [ playerid ] [ house ] = -1 ;

				format ( h_info [ house_id - 1 ] [ h_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ targetid ] [ name ] ) ;
				h_info [ house_id - 1 ] [ h_owner ] = p_info [ targetid ] [ id ] ;

				Iter_Remove(player_houses[playerid], house_id);
				Iter_Remove(houses_players[house_id], playerid);

				Iter_Add(player_houses[targetid], house_id);
				Iter_Add(houses_players[house_id], targetid);

				if ( finded_house_cars [ house_id ] == true && Iter_Count(houses_players[house_id]) == 1 )
				{
					if ( house_cars [ house_id ] == false )
					{
						static const _str [ ] = "SELECT * FROM `house_vehicles` WHERE `sv_owner` = '%d' LIMIT %d" ;
						new sql_string [ sizeof _str + 9 + 4 ] ;
						format ( sql_string, sizeof sql_string, _str, house_id, house_max_car ) ;
						mysql_tquery ( sql_connection, sql_string, "load_house_vehicles", "" ) ;
						
						house_cars [ house_id ] = true ;
					}
				}

				p_info [ targetid ] [ spawnchange ] = 1 ;
				update_int_sql ( targetid, "u_spawnchange", 1 ) ;

				PlayerPlaySound ( targetid, 1052, 0.0, 0.0, 0.0 ) ;
				
				h_info [ house_id - 1 ] [ h_sell_status ] =
				h_info [ house_id - 1 ] [ h_safe_code ] = 0 ;

				format ( query_string, sizeof query_string, "UPDATE `houses` SET `h_owner` = '%d',`h_ownername` = '%s', `h_sell_status` = '0', `h_safe_code` = '0000' WHERE `h_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ], p_info [ targetid ] [ name ], h_info [ house_id - 1 ] [ h_id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				clear_fam_house ( playerid, house_id, 0 ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, 128, "%s обменял дом №%d у %s", p_info [ targetid ] [ name ], house_id, p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_BIZZ:
			{
				new b = trade_rielt [ playerid ] [ trade_item ] [ i ] - 1, query_string [ 121 + 9 + MAX_PLAYER_NAME + 9 ] ;
				format ( b_info [ b ][ b_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ targetid ] [ name ] ) ;
				b_info [ b ][ b_owner_inc ] = p_info [ targetid ] [ id ];
				p_info [ targetid ] [ business ] = b_info [ b ] [ b_id ] ;

				p_info [ targetid ] [ b_worker ] = -1 ;
				p_info [ targetid ] [ business_rang ] = b_info [ b ] [ b_settings ] [ 3 ] ;
				
				format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_bworker` = '-1', `u_business_rang` = '%d' WHERE `u_id` = '%d' LIMIT 1", p_info [ targetid ] [ business_rang ], p_info [ targetid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				p_info [ playerid ] [ business ] = -1 ;

				p_info [ playerid ] [ business_rang ] = 0 ;
				update_int_sql ( playerid, "u_business_rang", 0 ) ;

				Iter_Remove ( business_players[b + 1], playerid ) ;
				Iter_Add ( business_players[b + 1], targetid ) ;

				Iter_Remove(player_business[playerid], b_info [ b ][ b_id ]);
				Iter_Add(player_business[targetid], b_info [ b ][ b_id ]);

				PlayerPlaySound ( targetid, 1052, 0.0, 0.0, 0.0 ) ;

				b_info [ b ] [ b_sell_status ] = 0 ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_sell_status` = '0', `b_owner_inc` = '%d', `b_owner_name` = '%s' WHERE `b_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ], p_info [ targetid ] [ name ], b_info [ b ] [ b_id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				update_blabel ( b ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял бизнес №%d у %s", p_info [ targetid ] [ name ], b + 1, p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_MONEY:
			{
				new _money = trade_rielt [ playerid ] [ trade_count ] [ i ], car_string [ 13 + MAX_PLAYER_NAME ] ;
				give_money ( targetid, _money ) ;
				give_money ( playerid, -_money ) ;
				
				format ( car_string, sizeof car_string, "трейд с %s", p_info [ playerid ] [ name ] ) ;
				insert_money_log ( targetid, playerid, _money, car_string ) ;
				
				car_string [ 0 ] = EOS ;
				format ( car_string, sizeof car_string, "трейд с %s", p_info [ targetid ] [ name ] ) ;
				insert_money_log ( playerid, targetid, -_money, car_string ) ;
				continue ;
			}
			case TRADE_RIELT_CAR:
			{
				new query_string [ 144 ], veh_id = trade_rielt [ playerid ] [ trade_item ] [ i ] ;
				format ( query_string, sizeof ( query_string ), "UPDATE `users_vehicles` SET `v_owner` = '%d', `v_date_used` = '0' WHERE `v_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ], veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery( sql_connection, query_string ) ;
				
				if ( veh_info [ veh_id - 1 ] [ v_date_used ] == -1 )
				{
					if ( p_info [ playerid ] [ max_veh_timeing ] > 0 )
					{
						p_info [ playerid ] [ max_veh ] -= 1 ;
						p_info [ playerid ] [ max_veh_timeing ] -= 1 ;

						query_string [ 0 ] = EOS ;
						format ( query_string, sizeof query_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` - '1', `u_maxveh_timeing` = `u_maxveh_timeing` - '1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
						mysql_tquery ( sql_connection, query_string ) ;
						
						show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Бонусное т/с", "{"#cWH"}Транспортное средство, которое было предложено Вами на обмен\nбыло получено Вами в виде бонуса, поэтому\nпри обмене у Вас был отнят слот под т/с.", "Закрыть", "" ) ;
					}
				}
				
				veh_info [ veh_id - 1 ] [ v_date_used ] = 0 ;

				Iter_Remove(player_vehicles[playerid], veh_id ) ;
				veh_info [ veh_id - 1 ] [ v_owner ] = p_info [ targetid ] [ id ] ;
				Iter_Add(player_vehicles[targetid], veh_id ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял т/с %s у %s", p_info [ targetid ] [ name ], GetVehicleNameEx ( veh_info [ veh_id - 1 ] [ v_vehicle ] ), p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				
				p_info [ targetid ] [ p_veh_count ] ++ ;
				p_info [ playerid ] [ p_veh_count ] -- ;
				continue ;
			}
			case TRADE_RIELT_ACCS:
			{
				new _item_model = trade_rielt [ playerid ] [ trade_count ] [ i ], query_string [ 128 ] ;
				give_player_item ( targetid, _item_model ) ;
				clear_player_item ( playerid, _item_model ) ;
				
				format ( query_string, sizeof query_string, "%s обменял %s у %s", p_info [ targetid ] [ name ], get_accessorie_name ( _item_model ), p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_INVENTORY:
			{
				for ( new q = 0 ; q < MAX_PRISE_SLOT ; q ++ )
				{
					if ( p_info [ playerid ] [ prise_slot ] [ q ] != trade_rielt [ playerid ] [ trade_item ] [ i ] ) continue ;
					if ( p_info [ playerid ] [ prise_slot_count ] [ q ] < trade_rielt [ playerid ] [ trade_count ] [ i ] ) break ;
					
					if ( clear_player_item_prise ( playerid, trade_rielt [ playerid ] [ trade_item ] [ i ], trade_rielt [ playerid ] [ trade_count ] [ i ] ) )
					{
						give_player_item_prise ( targetid, trade_rielt [ playerid ] [ trade_item ] [ i ], trade_rielt [ playerid ] [ trade_count ] [ i ] ) ;
						
						new query_string [ 128 ] ;
						format ( query_string, sizeof query_string, "%s обменял %s (%d шт.) у %s", p_info [ targetid ] [ name ], item_name ( trade_rielt [ playerid ] [ trade_item ] [ i ] ), trade_rielt [ playerid ] [ trade_count ] [ i ], p_info [ playerid ] [ name ] ) ;
						WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
						break ;
					}
				}
				continue ;
			}
			case TRADE_RIELT_GARAGE:
			{
				p_info [ targetid ] [ cellar ] = trade_rielt [ playerid ] [ trade_item ] [ i ] ;
				p_info [ playerid ] [ cellar ] = -1 ;
				
				new cel_id = p_info [ targetid ] [ cellar ], query_string [ 186 ] ;
				format ( cellar_info [ cel_id - 1 ] [ cl_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ targetid ] [ name ] ) ;
				cellar_info [ cel_id - 1 ] [ cl_owner ] = p_info [ targetid ] [ id ] ;
				
				format ( query_string, 138, "UPDATE `cellars` SET `cl_owner` = '%d',`cl_ownername` = '%s' WHERE `cl_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ], p_info [ targetid ] [ name ], cel_id ) ;
				mysql_tquery ( sql_connection, query_string ) ;
				
				p_info [ playerid ] [ max_veh ] -= 1 ;
			    p_info [ targetid ] [ max_veh ] += 1 ;
			    
			    query_string [ 0 ] = EOS ;
			    format ( query_string, sizeof query_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` - '1', `u_spawnchange` = '0', `u_cellar` = '-1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			    mysql_tquery ( sql_connection, query_string ) ;

			    query_string [ 0 ] = EOS ;
			    format ( query_string, sizeof query_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` + '1', `u_spawnchange` = '4', `u_cellar` = '%d' WHERE `u_id` = '%d' LIMIT 1", p_info [ targetid ] [ cellar ], p_info [ targetid ] [ id ] ) ;
			    mysql_tquery ( sql_connection, query_string ) ;
				
			    query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял гараж №%d у %s", p_info [ targetid ] [ name ], trade_rielt [ playerid ] [ trade_item ] [ i ], p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_RETURN_MONEY:
			{
				new query_string [ 93 + ( 9 * 2 ) ] ;
				format ( query_string, sizeof query_string, "UPDATE `return_money` SET `rm_dest` = '%d', `rm_date` = NOW() WHERE `rm_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ], trade_rielt [ playerid ] [ trade_item ] [ i ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял %d$ у %s", p_info [ targetid ] [ name ], trade_rielt [ playerid ] [ trade_count ] [ i ], p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_SKIN:
			{
				new _slot = trade_rielt [ playerid ] [ trade_item ] [ i ], _query [ 126 ], _item = trade_rielt [ playerid ] [ trade_count ] [ i ] + skin_cross ;
				SendClientMessage ( targetid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Одежда отправлена в инвентарь." ) ;
				give_player_item_prise ( targetid, _item, 1 ) ;
				
				p_info [ playerid ] [ temp_skin ] [ _slot ] = 0 ;
				format ( _query, sizeof ( _query ), "UPDATE `users` SET `u_tempskin`='%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
				p_info [ playerid ] [ temp_skin ] [ 0 ], p_info [ playerid ] [ temp_skin ] [ 1 ], p_info [ playerid ] [ temp_skin ] [ 2 ],
				p_info [ playerid ] [ temp_skin ] [ 3 ], p_info [ playerid ] [ temp_skin ] [ 4 ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, _query ) ;
			
				_query [ 0 ] = EOS ;
				format ( _query, sizeof _query, "%s обменял одежду №%d у %s", p_info [ targetid ] [ name ], _item - skin_cross, p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, _query ) ;
				continue ;
			}
			case TRADE_RIELT_PLATE:
			{
				new _plate_id = trade_rielt [ playerid ] [ trade_count ] [ i ], query_string [ 144 ] ;
				give_player_plates ( targetid, varchar_platename [ playerid ] [ _plate_id ], varchar_plateregion [ playerid ] [ _plate_id ], varchar_platetype [ playerid ] [ _plate_id ] ) ;
				clear_player_plates ( playerid, "none", "none", 0, _plate_id ) ;
				
				format ( query_string, sizeof query_string, "%s обменял н/з %s у %s", p_info [ targetid ] [ name ], trade_plate_name [ playerid ] [ i ], p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_FAMILY:
			{
				new familyid = p_info [ playerid ] [ family ], query [ 144 ] ;
				format ( family_info [ familyid - 1 ] [ fam_creator ], MAX_PLAYER_NAME, "%s", p_info [ targetid ] [ name ] ) ;

				format ( query, sizeof ( query ), "UPDATE `family` SET `fam_creator` = '%s' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_creator ], familyid ) ;
				mysql_tquery ( sql_connection, query ) ;

				foreach(new p: family_players[familyid])
				{
					if ( targetid == p ) continue ;
					if ( p_info [ p ] [ family ] != familyid ) continue ;
					
					p_info [ p ] [ family_rang ] = 1 ;
				}
				
				query [ 0 ] = EOS ;
				format ( query, 128, "UPDATE `users` SET `u_family_rank` = '1' WHERE `u_family` = '%d' LIMIT %d", familyid, family_info [ familyid - 1 ] [ fam_members ] ) ;
				mysql_tquery ( sql_connection, query ) ;

				p_info [ targetid ] [ family ] = familyid ;
				update_int_sql ( targetid, "u_family", familyid ) ;
				p_info [ targetid ] [ family_rang ] = family_info [ familyid - 1 ] [ fam_settings ] [ 3 ] ;
				update_int_sql ( targetid, "u_family_rank", p_info [ targetid ] [ family_rang ] ) ;

				query [ 0 ] = EOS ;
				format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Вы успешно передали %s семью {%s}%s{"#cGRInfo"}.", p_info [ targetid ] [ name ], family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ] ) ;
				SendClientMessage ( playerid, col_gray, query ) ;

				query [ 0 ] = EOS ;
				format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Теперь Вы новый лидер семьи {%s}%s{"#cGRInfo"}.", family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ] ) ;
				SendClientMessage ( targetid, col_gray, query ) ;
				
				query [ 0 ] = EOS ;
				format ( query, sizeof query, "%s обменял(а) семью у %s.", p_info [ targetid ] [ name ], p_info [ playerid ] [ name ] ) ;
				write_family ( targetid, familyid, TYPE_LOG_TRADE, query ) ;
				continue ;
			}
			case TRADE_RIELT_FAMILY_TALON:
			{
				new _money = trade_rielt [ playerid ] [ trade_count ] [ i ], query_string [ 128 ] ;
				if ( _money < 0 || _money > p_info [ playerid ] [ family_ticket ] ) continue ;
				
				p_info [ targetid ] [ family_ticket ] += _money ;
				update_int_sql ( targetid, "u_family_ticket", p_info [ targetid ] [ family_ticket ] ) ;

				p_info [ playerid ] [ family_ticket ] -= _money ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

				format ( query_string, sizeof query_string, "%s обменял %d "family_title" у %s", p_info [ targetid ] [ name ], _money, p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_SIMCARD:
			{
				_trade_sim = true ;
				new _number = trade_rielt [ playerid ] [ trade_count ] [ i ], query_string [ 128 ] ;
				
				p_info [ targetid ] [ number ] = _number ;
				update_int_sql ( targetid, "u_number", _number ) ;
				
				p_info [ playerid ] [ number ] = 0 ;
				update_int_sql ( playerid, "u_number", 0 ) ;
				
				format ( query_string, sizeof query_string, "%s обменял SIM-карту (%d) у %s", p_info [ targetid ] [ name ], _number, p_info [ playerid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
		}
	}
	
	for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
	{
		if ( trade_rielt [ targetid ] [ trade_type ] [ i ] == 0 ) continue ;
		switch ( trade_rielt [ targetid ] [ trade_type ] [ i ] )
		{
			case TRADE_RIELT_HOUSE:
			{
				new house_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
				p_info [ playerid ] [ house ] = house_id ;
				p_info [ targetid ] [ house ] = -1 ;

				format ( h_info [ house_id - 1 ] [ h_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
				h_info [ house_id - 1 ] [ h_owner ] = p_info [ playerid ] [ id ] ;

				Iter_Remove(player_houses[targetid], house_id);
				Iter_Remove(houses_players[house_id], targetid);

				Iter_Add(player_houses[playerid], house_id);
				Iter_Add(houses_players[house_id], playerid);

				if ( finded_house_cars [ house_id ] == true && Iter_Count(houses_players[house_id]) == 1 )
				{
					if ( house_cars [ house_id ] == false )
					{
						static const _str [ ] = "SELECT * FROM `house_vehicles` WHERE `sv_owner` = '%d' LIMIT %d" ;
						new sql_string [ sizeof _str + 9 + 4 ] ;
						format ( sql_string, sizeof sql_string, _str, house_id, house_max_car ) ;
						mysql_tquery ( sql_connection, sql_string, "load_house_vehicles", "" ) ;
						
						house_cars [ house_id ] = true ;
					}
				}

				p_info [ playerid ] [ spawnchange ] = 1 ;
				update_int_sql ( playerid, "u_spawnchange", 1 ) ;

				PlayerPlaySound ( playerid, 1052, 0.0, 0.0, 0.0 ) ;
				
				h_info [ house_id - 1 ] [ h_sell_status ] =
				h_info [ house_id - 1 ] [ h_safe_code ] = 0 ;

				new query_string [ 135 + MAX_PLAYER_NAME + ( 9 * 2 ) ] ;
				format ( query_string, sizeof query_string, "UPDATE `houses` SET `h_owner` = '%d',`h_ownername` = '%s', `h_sell_status` = '0', `h_safe_code` = '0000' WHERE `h_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], h_info [ house_id - 1 ] [ h_id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				clear_fam_house ( targetid, house_id, 0 ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, 128, "%s обменял дом №%d у %s", p_info [ playerid ] [ name ], house_id, p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_BIZZ:
			{
				new b = trade_rielt [ targetid ] [ trade_item ] [ i ] - 1, query_string [ 121 + 9 + MAX_PLAYER_NAME + 9 ] ;
				format ( b_info [ b ][ b_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
				b_info [ b ][ b_owner_inc ] = p_info [ playerid ] [ id ];
				p_info [ playerid ] [ business ] = b_info [ b ] [ b_id ] ;

				p_info [ playerid ] [ b_worker ] = -1 ;
				p_info [ playerid ] [ business_rang ] = b_info [ b ] [ b_settings ] [ 3 ] ;
				
				format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_bworker` = '-1', `u_business_rang` = '%d' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ business_rang ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				p_info [ targetid ] [ business ] = -1 ;

				p_info [ targetid ] [ business_rang ] = 0 ;
				update_int_sql ( targetid, "u_business_rang", 0 ) ;

				Iter_Remove ( business_players[b + 1], targetid ) ;
				Iter_Add ( business_players[b + 1], playerid ) ;

				Iter_Remove(player_business[targetid], b_info [ b ][ b_id ]);
				Iter_Add(player_business[playerid], b_info [ b ][ b_id ]);

				PlayerPlaySound ( playerid, 1052, 0.0, 0.0, 0.0 ) ;
				
				b_info [ b ] [ b_sell_status ] = 0 ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_sell_status` = '0', `b_owner_inc` = '%d', `b_owner_name` = '%s' WHERE `b_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], b_info [ b ] [ b_id ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				update_blabel ( b ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял бизнес №%d у %s", p_info [ playerid ] [ name ], b + 1, p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_MONEY:
			{
				new _money = trade_rielt [ targetid ] [ trade_count ] [ i ], car_string [ 13 + MAX_PLAYER_NAME ] ;
				give_money ( playerid, _money ) ;
				give_money ( targetid, -_money ) ;
				
				format ( car_string, sizeof car_string, "трейд с %s", p_info [ targetid ] [ name ] ) ;
				insert_money_log ( playerid, targetid, _money, car_string ) ;
				
				car_string [ 0 ] = EOS ;
				format ( car_string, sizeof car_string, "трейд с %s", p_info [ playerid ] [ name ] ) ;
				insert_money_log ( targetid, playerid, -_money, car_string ) ;
				continue ;
			}
			case TRADE_RIELT_CAR:
			{
				new query_string [ 144 ], veh_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
				format ( query_string, sizeof ( query_string ), "UPDATE `users_vehicles` SET `v_owner` = '%d', `v_date_used` = '0' WHERE `v_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery( sql_connection, query_string ) ;
				
				if ( veh_info [ veh_id - 1 ] [ v_date_used ] == -1 )
				{
					if ( p_info [ targetid ] [ max_veh_timeing ] > 0 )
					{
						p_info [ targetid ] [ max_veh ] -= 1 ;
						p_info [ targetid ] [ max_veh_timeing ] -= 1 ;

						query_string [ 0 ] = EOS ;
						format ( query_string, sizeof query_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` - '1', `u_maxveh_timeing` = `u_maxveh_timeing` - '1' WHERE `u_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ] ) ;
						mysql_tquery ( sql_connection, query_string ) ;
						
						show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Бонусное т/с", "{"#cWH"}Транспортное средство, которое было предложено Вами на обмен\nбыло получено Вами в виде бонуса, поэтому\nпри обмене у Вас был отнят слот под т/с.", "Закрыть", "" ) ;
					}
				}
				
				veh_info [ veh_id - 1 ] [ v_date_used ] = 0 ;

				Iter_Remove(player_vehicles[targetid], veh_id ) ;
				veh_info [ veh_id - 1 ] [ v_owner ] = p_info [ playerid ] [ id ] ;
				Iter_Add(player_vehicles[playerid], veh_id ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял т/с %s у %s", p_info [ playerid ] [ name ], GetVehicleNameEx ( veh_info [ veh_id - 1 ] [ v_vehicle ] ), p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				
				p_info [ playerid ] [ p_veh_count ] ++ ;
				p_info [ targetid ] [ p_veh_count ] -- ;
				continue ;
			}
			case TRADE_RIELT_ACCS:
			{
				new _item_model = trade_rielt [ targetid ] [ trade_count ] [ i ], query_string [ 128 ] ;
				give_player_item ( playerid, _item_model ) ;
				clear_player_item ( targetid, _item_model ) ;
				
				format ( query_string, sizeof query_string, "%s обменял %s у %s", p_info [ playerid ] [ name ], get_accessorie_name ( _item_model ), p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_INVENTORY:
			{
				for ( new q = 0 ; q < MAX_PRISE_SLOT ; q ++ )
				{
					if ( p_info [ targetid ] [ prise_slot ] [ q ] != trade_rielt [ targetid ] [ trade_item ] [ i ] ) continue ;
					if ( p_info [ targetid ] [ prise_slot_count ] [ q ] < trade_rielt [ targetid ] [ trade_count ] [ i ] ) break ;
					
					if ( clear_player_item_prise ( targetid, trade_rielt [ targetid ] [ trade_item ] [ i ], trade_rielt [ targetid ] [ trade_count ] [ i ] ) )
					{
						give_player_item_prise ( playerid, trade_rielt [ targetid ] [ trade_item ] [ i ], trade_rielt [ targetid ] [ trade_count ] [ i ] ) ;
						
						new query_string [ 128 ] ;
						format ( query_string, sizeof query_string, "%s обменял %s (%d шт.) у %s", p_info [ playerid ] [ name ], item_name ( trade_rielt [ targetid ] [ trade_item ] [ i ] ), trade_rielt [ targetid ] [ trade_count ] [ i ], p_info [ targetid ] [ name ] ) ;
						WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
						break ;
					}
				}
				continue ;
			}
			case TRADE_RIELT_GARAGE:
			{
				p_info [ playerid ] [ cellar ] = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
				p_info [ targetid ] [ cellar ] = -1 ;
				
				new cel_id = p_info [ playerid ] [ cellar ], query_string [ 186 ] ;
				format ( cellar_info [ cel_id - 1 ] [ cl_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
				cellar_info [ cel_id - 1 ] [ cl_owner ] = p_info [ playerid ] [ id ] ;
				
				format ( query_string, 138, "UPDATE `cellars` SET `cl_owner` = '%d',`cl_ownername` = '%s' WHERE `cl_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], cel_id ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				p_info [ targetid ] [ max_veh ] -= 1 ;
			    p_info [ playerid ] [ max_veh ] += 1 ;
			    
			    query_string [ 0 ] = EOS ;
			    format ( query_string, sizeof query_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` - '1', `u_spawnchange` = '0', `u_cellar` = '-1' WHERE `u_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ] ) ;
			    mysql_tquery ( sql_connection, query_string ) ;

			    query_string [ 0 ] = EOS ;
			    format ( query_string, sizeof query_string, "UPDATE `users` SET `u_maxveh` = `u_maxveh` + '1', `u_spawnchange` = '4', `u_cellar` = '%d' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ cellar ], p_info [ playerid ] [ id ] ) ;
			    mysql_tquery ( sql_connection, query_string ) ;
				
			    query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял гараж №%d у %s", p_info [ playerid ] [ name ], trade_rielt [ targetid ] [ trade_item ] [ i ], p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_RETURN_MONEY:
			{
				new query_string [ 93 + ( 9 * 2 ) ] ;
				format ( query_string, sizeof query_string, "UPDATE `return_money` SET `rm_dest` = '%d', `rm_date` = NOW() WHERE `rm_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], trade_rielt [ targetid ] [ trade_item ] [ i ] ) ;
				mysql_tquery ( sql_connection, query_string ) ;
				
				query_string [ 0 ] = EOS ;
				format ( query_string, sizeof query_string, "%s обменял %d$ у %s", p_info [ playerid ] [ name ], trade_rielt [ targetid ] [ trade_count ] [ i ], p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_SKIN:
			{
				new _slot = trade_rielt [ targetid ] [ trade_item ] [ i ], _query [ 126 ], _item = trade_rielt [ targetid ] [ trade_count ] [ i ] + skin_cross ;
				SendClientMessage ( targetid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Одежда отправлена в инвентарь." ) ;
				give_player_item_prise ( playerid, _item, 1 ) ;

				p_info [ targetid ] [ temp_skin ] [ _slot ] = 0 ;
				format ( _query, sizeof ( _query ), "UPDATE `users` SET `u_tempskin`='%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
				p_info [ targetid ] [ temp_skin ] [ 0 ], p_info [ targetid ] [ temp_skin ] [ 1 ], p_info [ targetid ] [ temp_skin ] [ 2 ],
				p_info [ targetid ] [ temp_skin ] [ 3 ], p_info [ targetid ] [ temp_skin ] [ 4 ], p_info [ targetid ] [ id ] ) ;
				mysql_tquery ( sql_connection, _query ) ;

				_query [ 0 ] = EOS ;
				format ( _query, sizeof _query, "%s обменял одежду №%d у %s", p_info [ playerid ] [ name ], _item - skin_cross, p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, _query ) ;
				continue ;
			}
			case TRADE_RIELT_PLATE:
			{
				new _plate_id = trade_rielt [ targetid ] [ trade_count ] [ i ], query_string [ 144 ] ;
				give_player_plates ( playerid, varchar_platename [ targetid ] [ _plate_id ], varchar_plateregion [ targetid ] [ _plate_id ], varchar_platetype [ targetid ] [ _plate_id ] ) ;
				clear_player_plates ( targetid, "none", "none", 0, _plate_id ) ;
				
				format ( query_string, sizeof query_string, "%s обменял н/з %s у %s", p_info [ playerid ] [ name ], trade_plate_name [ targetid ] [ i ], p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_FAMILY:
			{
				new familyid = p_info [ targetid ] [ family ], query [ 144 ] ;
				format ( family_info [ familyid - 1 ] [ fam_creator ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;

				format ( query, sizeof ( query ), "UPDATE `family` SET `fam_creator` = '%s' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_creator ], familyid ) ;
				mysql_tquery ( sql_connection, query ) ;

				foreach(new p: family_players[familyid])
				{
					if ( playerid == p ) continue ;
					if ( p_info [ p ] [ family ] != familyid ) continue ;
					
					p_info [ p ] [ family_rang ] = 1 ;
				}
				
				query [ 0 ] = EOS ;
				format ( query, 128, "UPDATE `users` SET `u_family_rank` = '1' WHERE `u_family` = '%d' LIMIT %d", familyid, family_info [ familyid - 1 ] [ fam_members ] ) ;
				mysql_tquery ( sql_connection, query ) ;

				p_info [ playerid ] [ family ] = familyid ;
				update_int_sql ( playerid, "u_family", familyid ) ;
				p_info [ playerid ] [ family_rang ] = family_info [ familyid - 1 ] [ fam_settings ] [ 3 ] ;
				update_int_sql ( playerid, "u_family_rank", p_info [ playerid ] [ family_rang ] ) ;

				query [ 0 ] = EOS ;
				format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Вы успешно передали %s семью {%s}%s{"#cGRInfo"}.", p_info [ playerid ] [ name ], family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ] ) ;
				SendClientMessage ( playerid, col_gray, query ) ;

				query [ 0 ] = EOS ;
				format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Теперь Вы новый лидер семьи {%s}%s{"#cGRInfo"}.", family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ] ) ;
				SendClientMessage ( playerid, col_gray, query ) ;
				
				query [ 0 ] = EOS ;
				format ( query, sizeof query, "%s обменял(а) семью у %s.", p_info [ playerid ] [ name ], p_info [ targetid ] [ name ] ) ;
				write_family ( playerid, familyid, TYPE_LOG_TRADE, query ) ;
				continue ;
			}
			case TRADE_RIELT_FAMILY_TALON:
			{
				new _money = trade_rielt [ targetid ] [ trade_count ] [ i ], query_string [ 128 ] ;
				if ( _money < 0 || _money > p_info [ targetid ] [ family_ticket ] ) continue ;
				
				p_info [ playerid ] [ family_ticket ] += _money ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

				p_info [ targetid ] [ family_ticket ] -= _money ;
				update_int_sql ( targetid, "u_family_ticket", p_info [ targetid ] [ family_ticket ] ) ;

				format ( query_string, sizeof query_string, "%s обменял %d "family_title" у %s", p_info [ playerid ] [ name ], _money, p_info [ targetid ] [ name ] ) ;
				WriteLog ( playerid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
			case TRADE_RIELT_SIMCARD:
			{
				new _number = trade_rielt [ targetid ] [ trade_count ] [ i ], query_string [ 128 ] ;
				
				p_info [ playerid ] [ number ] = _number ;
				update_int_sql ( playerid, "u_number", _number ) ;
				
				if ( _trade_sim == false )
				{
					p_info [ targetid ] [ number ] = 0 ;
					update_int_sql ( targetid, "u_number", 0 ) ;
				}
				
				format ( query_string, sizeof query_string, "%s обменял SIM-карту (%d) у %s", p_info [ playerid ] [ name ], _number, p_info [ targetid ] [ name ] ) ;
				WriteLog ( targetid, TYPE_LOG_TRADE, query_string ) ;
				continue ;
			}
		}
	}
	
	SendClientMessage ( playerid, col_white, !"{"#cGN"}* {"#cWH"}Вы успешно совершили обмен!" ) ;
	SendClientMessage ( targetid, col_white, !"{"#cGN"}* {"#cWH"}Вы успешно совершили обмен!" ) ;

	used_trade [ playerid ] = false ;
	used_trade [ targetid ] = false ;

	show_trade_ptd ( playerid, false ) ;
	show_player_ptd ( playerid, false ) ;
	show_trader_ptd ( playerid, false ) ;
	clear_player_trade ( playerid ) ;
			
	show_trade_ptd ( targetid, false ) ;
	show_player_ptd ( targetid, false ) ;
	show_trader_ptd ( targetid, false ) ;
	clear_player_trade ( targetid ) ;
	return 1 ;
}

stock return_to_vision ( playerid )
{
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
				
	SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	return 1 ;
}

stock trade_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_trade_info:
		{
			if ( ! response ) return clear_player_listitem_values ( playerid ) ;
			
			new i = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			set_player_use_listitem ( playerid, i ) ;
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			if ( targetid == INVALID_PLAYER_ID )
			{
				used_trade [ playerid ] = false ;
				
				show_trade_ptd ( playerid, false ) ;
				show_player_ptd ( playerid, false ) ;
				show_trader_ptd ( playerid, false ) ;
				clear_player_trade ( playerid ) ;
					
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен имуществом", "{"#cRInfo"}* {"#cGRDialog"}Игрок, с которым Вы обменивались, отказался. Обмен отменён!", "Хорошо", "" ) ;
				return 1 ;
			}
			
			switch ( trade_rielt [ targetid ] [ trade_type ] [ i ] )
			{
				case TRADE_RIELT_HOUSE:
				{
					new _h_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
					
					new line_string [ 64 ] ;
					format ( line_string, sizeof line_string, "{"#cBHD"}Номер дома: {"#cBL"}%d", h_info [ _h_id - 1 ] [ h_id ] ) ;
					show_dialog(playerid, d_trade_info_house, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Информация о доме", "Выбрать", "Закрыть" ) ;
				}
				case TRADE_RIELT_BIZZ:
				{
					new _h_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
					
					new line_string [ 64 ] ;
					format ( line_string, sizeof line_string, "{"#cBHD"}Номер бизнеса: {"#cBL"}%d", b_info [ _h_id - 1 ] [ b_id ] ) ;
					show_dialog(playerid, d_trade_info_bizz, DIALOG_STYLE_LIST, line_string, "{"#cBL"}1.{"#cWH"} Информация о бизнесе\n{"#cBL"}2.{"#cWH"} Доходы", "Выбрать", "Закрыть" ) ;
				}
				case TRADE_RIELT_CAR:
				{
					new _v_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
					
					show_pts ( playerid, _v_id ) ;
				}
				default: SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Взаимодействовать можно только с домом или бизнесом." ) ;
			}
			return 1 ;
		}
		case d_trade_info_house:
		{
			if ( ! response ) return 1 ;
			
			new i = get_player_use_listitem ( playerid ) ;
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			new _h_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
			
			if ( listitem == 0 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 300, "{"#cGRDialog"}Класс: {"#cWH"}%s\n{"#cGRDialog"}Номер дома: {"#cWH"}%d\n{"#cGRDialog"}Налог в сутки: {"#cWH"}%d$\n{"#cGRDialog"}Аптечек в доме: {"#cWH"}%d",
				house_classes [ house_int [ h_info [ _h_id - 1 ] [ h_int ] - 1 ] [ hint_class ] ], h_info [ _h_id - 1 ] [ h_id ],
				floatround ( h_info [ _h_id - 1 ] [ h_price ] / 350 ) * for_tax [ 3 ], h_info [ _h_id - 1 ] [ h_heal ] ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация о доме:", global_string, "Назад", "Закрыть" ) ;
			}
			return 1 ;
		}
		case d_trade_info_bizz:
		{
			if ( ! response ) return 1 ;
			
			new i = get_player_use_listitem ( playerid ) ;
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			new _b_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;

			if ( listitem == 0 )
			{
				business_information ( playerid, _b_id - 1, 3 ) ;
			}
			else if ( listitem == 1 )
			{
				new text_string [ 144 ] ;
				mysql_format ( sql_connection, text_string, sizeof ( text_string  ), "SELECT `bh_count`, `bh_date` FROM `businesses_history` WHERE `bh_business` = '%d' AND `bh_date` >= DATE(NOW()) - INTERVAL 7 DAY", _b_id ) ;
				mysql_tquery ( sql_connection, text_string, "bh_story", "iii", playerid, _b_id, 3 ) ;
			}
			return 1 ;
		}
		case d_use_trade:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
				if ( p_info [ playerid ] [ money ] < b_price_market [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ 2 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не хватает средств на оплату комиссии." ) ;
			
				global_string [ 0 ] = EOS ;

				new TotalPla ;
				foreach(new i: streamed_players[playerid])
				{
					if ( trade_rielt [ i ] [ trade_id ] != INVALID_PLAYER_ID ) continue ;
					
					set_player_listitem_values ( playerid, TotalPla, i ) ;

					TotalPla ++ ;
					if ( TotalPla == 20 ) break ;

					format( global_string, sizeof global_string, "%s{"#cWH"}%s[%d]\n", global_string, p_info [ i ] [ name ], i ) ;
				}
				
				if ( TotalPla == 0 )
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cWH"}Нет поблизости игроков, с которыми можно обмениваться!", "Принять", "" ) ;

				else
				    show_dialog ( playerid, d_accept_trade_1, DIALOG_STYLE_LIST, "{"#cBHD"}Обмен", global_string, "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				inv_dialog ( playerid, d_skin_show, DIALOG_STYLE_INPUT, "{"#cBHD"}Примерочная", "{"#cWH"}Укажите ID одежды, которую Вы хотите примерить:", "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 2 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен / трейд", "{"#cBL"}Обмен:\n\n\
					{"#cWH"}Вы можете обменяться {"#cLY"}любым {"#cWH"}имуществом для этого обратитесть в {"#cLY"}/gps - Бизнесы - Риелторское агентство{"#cWH"}.\n\
					При обмене Вы можете предложить всё, что угодно, как и тот, с кем Вы меняетесь.\n\
					Настоятельно рекомендуем не ждать чего-либо, а меняться сразу на оговоренное.\n\n\
					{"#cRInfo"}Администрация не несёт ответственности за Вашу невнимательность!\n\
					Мы Вас не ограничиваем в обмене и даём возможность обменять всё сразу!\n\
					Не нужно верить в то, что игрок что-то сперва помериет, а потом, если всё устроит,\n\
					то отдаст обещанное!\n\n\
					МЕНЯЙТЕСЬ НА ВСЁ СРАЗУ, НЕ ЖДИТЕ НИКАКИХ ПРИМЕРОК И ТОМУ ПОДОБНОГО!", "Закрыть", "" ) ;
			}
			else if ( listitem == 3 ) show_trade ( playerid ) ;
			return 1 ;
		}
		case d_skin_show:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				show_trade ( playerid ) ;
				return 1 ;
			}
			
			new _value = strval ( inputtext ) ;
			if ( _value == 74 || _value == 267 || _value == 268 || _value == 269 || _value == 270 || _value == 271 )return inv_dialog ( playerid, d_skin_show, DIALOG_STYLE_INPUT, "{"#cBHD"}Примерочная", "{"#cRD"}* Номер одежды указан некорректно!\n\n{"#cWH"}Укажите ID одежды, которую Вы хотите примерить:", "Выбрать", "Назад" ) ;

			if ( _value < 1 || _value > 311 )
			{
				new bool: _custom_model = false ;
				for ( new i = 0 ; i < MAX_SKIN_MODELS_REPLACE ; i ++ )
				{
					if ( skin_replace_model [ i ] [ 0 ] != _value ) continue ;

					_custom_model = true ;
					break ;
				}
				if ( ! _custom_model ) return inv_dialog ( playerid, d_skin_show, DIALOG_STYLE_INPUT, "{"#cBHD"}Примерочная", "{"#cRD"}* Номер одежды указан некорректно!\n\n{"#cWH"}Укажите ID одежды, которую Вы хотите примерить:", "Выбрать", "Назад" ) ;
			}
			
			show_for_timeskin ( playerid, _value ) ;
			return 1 ;
		}
		case d_accept_trade_1:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				show_trade ( playerid ) ;
				return 1 ;
			}
			
			new targetid = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( ! IsPlayerConnected ( targetid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( targetid == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 30, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
			if ( ! bad_dialog ( targetid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Недоступно в данный момент." ) ;
			if ( p_info [ targetid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
			if ( admin_info [ targetid ] [ admin ] > 0 && admin_info [ targetid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок администратор." ) ;
			
			if ( GetString ( p_t_info [ targetid ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
			{
				new scm_string [ 128 ] ;
				format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s[%d] попытка трейда %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ targetid ] [ name ], targetid ) ;
				foreach(new i: admin_players)SendClientMessage ( i, col_admin, scm_string ) ;

				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно обмениваться с данным игроком." ) ;
				return 1 ;
			}

			new _t_string [ 138 ] ;
			format(_t_string,sizeof(_t_string),"{"#cGInfo"}* {"#cWH"}Вы предложили {"#cGN"}%s {"#cWH"}обмен.",p_info [ targetid ] [ name ] ) ;
			SendClientMessage ( playerid, col_white, _t_string ) ;

			format ( _t_string, sizeof ( _t_string ),"{FFFFFF}%s предлагает Вам обмен.\n\n{"#cBL"}Вы согласны начать обмен?", p_info [ playerid ] [ name ] ) ;
			show_dialog ( targetid, d_accept_trade, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предложение обмена", _t_string, "Да", "Нет" ) ;

			buyer_id [ playerid ] = targetid ;
			seller_id [ targetid ] = playerid ;
			
			sell_time { playerid } =
			sell_time { targetid } = time_sell_null ;
			return 1 ;
		}
		case d_accept_trade:
		{
			if ( ! response )
			{
				if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) clear_sell_params ( playerid, playerid ) ;
				else clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new targetid = seller_id [ playerid ] ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 15, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
			
			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			if ( _b_id < 1 ) return bad_exit ( playerid ) ;
			if ( b_info [ _b_id - 1 ] [ b_product ] < b_other_product [ 2 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В бизнесе недостаточно бланков для подписания договора." ) ;
			
			new _price = b_price_market [ _b_id - 1 ] [ 2 ] ;
			if ( p_info [ playerid ] [ money ] < _price ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств для трейда." ) ;
			
			give_bmoney ( _b_id, _price, b_other_product [ 2 ] ) ;
			
			give_money ( playerid, -_price ) ;
            insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "комиссия трейд" ) ;
			
			show_rieltore_trade ( playerid, targetid, true ) ;
			clear_sell_params ( playerid, targetid ) ;
			return 1 ;
		}
		case d_accept_trade_2:
		{
			if ( ! response )
			{
				if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) clear_sell_params ( playerid, playerid ) ;
				else clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new targetid = seller_id [ playerid ] ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 15, p_t_info [ targetid ][ p_pos ] [ 0 ], p_t_info [ targetid ][ p_pos ] [ 1 ], p_t_info [ targetid ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( targetid ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
			if ( p_info [ targetid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
			if ( admin_info [ targetid ] [ admin ] > 0 && admin_info [ targetid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок администратор." ) ;

			show_rieltore_trade ( playerid, targetid, false ) ;
			clear_sell_params ( playerid, targetid ) ;
			return 1 ;
		}
		case d_prise_trade:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				return 1 ;
			}
	
			new _inv_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			new _m_id = player_market_rent [ playerid ] ;
			if ( _m_id >= 0 && _m_id < MAX_MARKET )
			{
				if ( market_info [ _m_id ] [ m_item_price ] [ _inv_id ] > 0 )
				{
					show_dialog ( playerid, d_none, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарочный инвентарь", "{"#cRD"}* Данный предмет выставлен на продажу в лавке!", "Принять", "" ) ;
					return 1 ;
				}
			}
			
			if ( p_info [ playerid ] [ prise_slot_count ] [ _inv_id ] > 1 )
			{
				set_player_use_listitem ( playerid, _inv_id ) ;
				show_dialog ( playerid, d_prise_trade_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарочный инвентарь", "{"#cWH"}Укажите количество, которое хотите обменять:", "Выбрать", "Закрыть" ) ;
				return 1 ;
			}
				
			if ( check_add_player ( playerid, TRADE_RIELT_INVENTORY, 0, p_info [ playerid ] [ prise_slot ] [ _inv_id ] ) ) return 1 ;

			show_add_player ( playerid, TRADE_RIELT_INVENTORY, 1, p_info [ playerid ] [ prise_slot ] [ _inv_id ] ) ;
			return 1 ;
		}
		case d_prise_trade_count:
		{
			if ( ! response ) return 1 ;
			
			new _value = strval ( inputtext ), _inv_id = get_player_use_listitem ( playerid ) ;
			
			new _count = -1, _id = -1 ;
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_INVENTORY ) continue ;
				if ( trade_rielt [ playerid ] [ trade_item ] [ i ] != p_info [ playerid ] [ prise_slot ] [ _inv_id ] ) continue ;

				_id = i ;
				_count = trade_rielt [ playerid ] [ trade_count ] [ i ] ;
				break ;
			}
			
			if ( _id != -1 )
			{
				if ( _value + _count < 1 )
					return show_dialog ( playerid, d_prise_trade_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарочный инвентарь", "{"#cRD"}* Количество указано не верно.\n\n{"#cWH"}Укажите количество, которое хотите обменять:", "Выбрать", "Закрыть" ) ;
				
				if ( _value < 1 || _value + _count > p_info [ playerid ] [ prise_slot_count ] [ _inv_id ] )
					return show_dialog ( playerid, d_prise_trade_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарочный инвентарь", "{"#cRD"}* Количество указано не верно.\n\n{"#cWH"}Укажите количество, которое хотите обменять:", "Выбрать", "Закрыть" ) ;
			}
			else
			{
				if ( _value < 1 || _value > p_info [ playerid ] [ prise_slot_count ] [ _inv_id ] )
					return show_dialog ( playerid, d_prise_trade_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарочный инвентарь", "{"#cRD"}* Количество указано не верно.\n\n{"#cWH"}Укажите количество, которое хотите обменять:", "Выбрать", "Закрыть" ) ;
			}
			
			show_add_player ( playerid, TRADE_RIELT_INVENTORY, _value, p_info [ playerid ] [ prise_slot ] [ _inv_id ] ) ;
			return 1 ;
		}
		case d_returnmoney_trade:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
	 			return 1 ;
		    }

		    if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
			    clear_player_use_page ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
				    clear_player_listitem_values ( playerid ) ;
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					returnmoney_trade ( playerid ) ;
					return 1 ;
				}
				else
				{
				    static const _str [ ] = "SELECT `rm_id`, `rm_money`, `rm_type` FROM `return_money` WHERE `rm_dest` = '%d' AND `rm_type` = '1' ORDER BY `return_money`.`rm_id` DESC" ;
					new sql_string [ sizeof _str + 9 ] ;
					format ( sql_string, sizeof sql_string, _str, p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, sql_string, "load_returnmoney_trade", "i", playerid ) ;

					page_count [ playerid ] -= 1 ;
				}
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
			    clear_player_use_page ( playerid ) ;
			    if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице уведомлений." ) ;

					static const _str [ ] = "SELECT `rm_id`, `rm_money`, `rm_type` FROM `return_money` WHERE `rm_dest` = '%d' AND `rm_type` = '1' ORDER BY `return_money`.`rm_id` DESC" ;
					new sql_string [ sizeof _str + 9 ] ;
					format ( sql_string, sizeof sql_string, _str, p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, sql_string, "load_returnmoney_trade", "i", playerid ) ;

					page_count [ playerid ] = page_count [ playerid ] ;
					return 1 ;
				}

				static const _str [ ] = "SELECT `rm_id`, `rm_money`, `rm_type` FROM `return_money` WHERE `rm_dest` = '%d' AND `rm_type` = '1' ORDER BY `return_money`.`rm_id` DESC" ;
				new sql_string [ sizeof _str + 9 ] ;
				format ( sql_string, sizeof sql_string, _str, p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, sql_string, "load_returnmoney_trade", "i", playerid ) ;

				page_count [ playerid ] += 1 ;
				return 1 ;
			}

		    new select_id = get_player_listitem_values ( playerid, listitem ) ;
		    clear_player_listitem_values ( playerid ) ;
			
			new pvar_string [ 12 ] ;
			format ( pvar_string, sizeof pvar_string, "p_%d", listitem ) ;
			new _inv_inc = GetPVarInt ( playerid, pvar_string ) ;
			
			for ( new i = 0 ; i < 10 ; i ++ )
			{
				format ( pvar_string, sizeof pvar_string, "p_%d", i ) ;
				DeletePVar ( playerid, pvar_string ) ;
			}
			
			if ( check_add_player ( playerid, TRADE_RIELT_RETURN_MONEY, 0, select_id ) ) return 1 ;

			show_add_player ( playerid, TRADE_RIELT_RETURN_MONEY, _inv_inc, select_id ) ;
			return 1 ;
		}
		case d_trade:
		{
			if ( ! response ) return 1 ;
			
			switch ( listitem )
			{
				case 0:
				{
					if ( Iter_Count(player_houses[playerid]) < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома." ) ;
					
					show_home_trade ( playerid ) ;
					return 1 ;
				}
				case 1:
				{
					if ( Iter_Count(player_business[playerid]) < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет бизнеса." ) ;
					
					show_business_trade ( playerid ) ;
					return 1 ;
				}
				case 2:
				{
					show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
					return 1 ;
				}
				case 3:
				{
					global_string [ 0 ] = EOS ;
					new line_str [ 128 ], veh_slot = 0, _d_used [ 50 ] ;
					foreach(new veh_id: player_vehicles[playerid])
					{
						if ( veh_info [ veh_id - 1 ] [ v_date_used ] > 0 ) continue ;
						set_player_listitem_values ( playerid, veh_slot, veh_id ) ;

						veh_slot ++ ;
						
						if ( veh_info [ veh_id - 1 ] [ v_date_used ] == -1 ) format ( _d_used, sizeof _d_used, "{"#cGRDialog"}* Бонусное т/с (будет отнят слот)" ) ;
						else format ( _d_used, sizeof _d_used, "" ) ;

						format ( line_str, sizeof line_str, "{"#cWH"}%s {"#cGRDialog"}(%d){"#cWH"}. %s\n", GetVehicleNameEx ( veh_info [ veh_id - 1 ] [ v_vehicle ] ), veh_id, _d_used ) ;
						strcat ( global_string, line_str ) ;
					}

					if ( veh_slot == 0 ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет загруженного транспорта." ) ;
					else show_dialog ( playerid, d_trade_vehicle, DIALOG_STYLE_LIST, "{"#cBHD"}Обмен транспорта", global_string, "Выбрать", "Назад" ) ;
					return 1 ;
				}
				case 4:
				{
					show_trade_accesories ( playerid ) ;
					return 1 ;
				}
				case 5:
				{
					show_trade_inventory ( playerid ) ;
					return 1 ;
				}
				case 6:
				{
					if ( p_info [ playerid ] [ cellar ] == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет гаража." ) ;
					if ( check_add_player ( playerid, TRADE_RIELT_GARAGE, 0, p_info [ playerid ] [ cellar ] ) ) return 1 ;
					
					show_add_player ( playerid, TRADE_RIELT_GARAGE, 0, p_info [ playerid ] [ cellar ] ) ;
					return 1 ;
				}
				case 7: return returnmoney_trade ( playerid ) ;
				case 8:
				{
					SetPVarInt ( playerid, "plate_trade", 1 ) ;
					callcmd::plates ( playerid ) ;
					return 1 ;
				}
				case 9:
				{
					show_rieltore_trade_skins ( playerid ) ;
					return 1 ;
				}
				case 10:
				{
					if ( ! p_info [ playerid ] [ family ] ) return 1 ;
					if ( ! GetString ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Передавать семью может только создатель." ) ;
					
					new _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
					if ( p_info [ playerid ] [ family ] != p_info [ _trader_id ] [ family ] )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы состоите не в одной семье." ) ;
						SendClientMessage ( _trader_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы состоите не в одной семье." ) ;
						return 1 ;
					}
					if ( GetString ( family_info [ p_info [ _trader_id ] [ family ] - 1 ] [ fam_creator ], p_info [ _trader_id ] [ name ] ) )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок уже является владельцем семьи." ) ;
						SendClientMessage ( _trader_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже являетесь владельцем семьи." ) ;
						return 1 ;
					}
					
					if ( check_add_player ( _trader_id, TRADE_RIELT_FAMILY, 0, p_info [ _trader_id ] [ family ] ) )
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок уже выставил семью на обмен." ) ;
					
					if ( check_add_player ( playerid, TRADE_RIELT_FAMILY, 0, p_info [ playerid ] [ family ] ) ) return 1 ;
			
					show_add_player ( playerid, TRADE_RIELT_FAMILY, 0, p_info [ playerid ] [ family ] ) ;
				}
				case 11: show_dialog ( playerid, d_trade_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cWH"}Укажите количество "family_title", которое хотите обменять:", "Выбрать", "Закрыть" ) ;
				case 12:
				{
					if ( p_info [ playerid ] [ number ] < 1 )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет SIM-карты!" ) ;
						return 1 ;
					}

					if ( check_add_player ( playerid, TRADE_RIELT_SIMCARD, 0, p_info [ playerid ] [ number ] ) ) return 1 ;
					
					show_add_player ( playerid, TRADE_RIELT_SIMCARD, p_info [ playerid ] [ number ], p_info [ playerid ] [ number ] ) ;
				}
			}
			return 1 ;
		}
		case d_trade_plates:
		{
			if ( ! response ) return DeletePVar ( playerid, "plate_trade" ) ;
			
			if ( listitem == 0 )
	        {
				clear_player_listitem_values ( playerid ) ;
				callcmd::plates ( playerid ) ;
				DeletePVar ( playerid, "plate_trade" ) ;
				return 1 ;
	        }
			
			DeletePVar ( playerid, "plate_trade" ) ;
			new select_id = get_player_listitem_values ( playerid, listitem - 1 ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( check_add_player ( playerid, TRADE_RIELT_PLATE, 0, varchar_plateid [ playerid ] [ select_id ] ) ) return 1 ;

			format ( trade_char_plate [ playerid ], 24, "%s", plate_number1 ( varchar_platetype [ playerid ] [ select_id ], varchar_platename [ playerid ] [ select_id ], varchar_plateregion [ playerid ] [ select_id ] ) ) ;

			show_add_player ( playerid, TRADE_RIELT_PLATE, select_id, varchar_plateid [ playerid ] [ select_id ] ) ;
			return 1 ;
		}
		case d_trade_ft:
		{
			if ( ! response ) return 1 ;
			
			new _value = strval ( inputtext ) ;
			
			new _count = -1 ;
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_FAMILY_TALON ) continue ;

				_count = i ;
				break ;
			}
			
			if ( _count != -1 )
			{
				if ( _value + trade_rielt [ playerid ] [ trade_count ] [ _count ] < 1 || _value + trade_rielt [ playerid ] [ trade_count ] [ _count ] > max_money )
					return show_dialog ( playerid, d_trade_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите количество "family_title", которое хотите обменять:", "Выбрать", "Закрыть" ) ;
				
				if ( _value < 1 || p_info [ playerid ] [ family_ticket ] < _value + trade_rielt [ playerid ] [ trade_count ] [ _count ] || _value > max_money )
					return show_dialog ( playerid, d_trade_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите количество "family_title", которое хотите обменять::", "Выбрать", "Закрыть" ) ;
			}
			else
			{
				if ( _value < 1 || p_info [ playerid ] [ family_ticket ] < _value || _value > max_money )
					return show_dialog ( playerid, d_trade_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите количество "family_title", которое хотите обменять:", "Выбрать", "Закрыть" ) ;
			}
			
			show_add_player ( playerid, TRADE_RIELT_FAMILY_TALON, _value, 0 ) ;
			return 1 ;
		}
		case d_trade_vehicle:
		{
			if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        return 1 ;
		    }
			
			new _veh_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
				
			if ( check_add_player ( playerid, TRADE_RIELT_CAR, 0, _veh_id ) ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_CAR, 0, _veh_id ) ;
			return 1 ;
		}
		case d_trade_money:
		{
			if ( ! response ) return 1 ;
			
			new _value = strval ( inputtext ) ;
			
			new _count = -1 ;
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_MONEY ) continue ;

				_count = i ;
				break ;
			}
			
			if ( _count != -1 )
			{
				if ( _value + trade_rielt [ playerid ] [ trade_count ] [ _count ] < 1 || _value + trade_rielt [ playerid ] [ trade_count ] [ _count ] > max_money )
					return show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
				
				if ( _value < 1 || _value + trade_rielt [ playerid ] [ trade_count ] [ _count ] > p_info [ playerid ] [ money ] || _value > max_money )
					return show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
			}
			else
			{
				if ( _value < 1 || _value > p_info [ playerid ] [ money ] || _value > max_money )
					return show_dialog ( playerid, d_trade_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Обмен", "{"#cRD"}* Сумма указана не верно.\n\n{"#cWH"}Укажите сумму, которую хотите поставить на обмен:", "Выбрать", "Закрыть" ) ;
			}
			
			show_add_player ( playerid, TRADE_RIELT_MONEY, _value, 0 ) ;
			return 1 ;
		}
		case d_home_trade:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        return 1 ;
		    }
			
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( h_info [ select_id - 1 ] [ h_auction_status ] == 1 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш дом уже выставлен на аукцион." ) ;
				return 1 ;
			}
			
			if ( h_info [ select_id - 1 ] [ h_sell_status ] )
	        {
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваше имущество уже подгатавливается к опечатке." ) ;
				return 1 ;
			}
			
			for ( new h = 0 ; h < max_houses ; h ++ )
			{
			    if ( houses_info [ h ] [ houses_number ] == h_info [ select_id - 1 ] [ h_id ] )
			    {
		            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Дом выставлен на продажу." ) ;
					return 1 ;
				}
			}
				
			if ( check_add_player ( playerid, TRADE_RIELT_HOUSE, 0, select_id ) ) return 1 ;

			p_info [ playerid ] [ house ] = select_id ;
			show_add_player ( playerid, TRADE_RIELT_HOUSE, 0, p_info [ playerid ] [ house ] ) ;
			
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cWH"}Игрок добавил на обмен недвижимость.\nНажмите на поле дома для просмотра информации.", "Закрыть", "" ) ;
			return 1 ;
		}
		case d_business_trade:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        return 1 ;
		    }
			
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( b_info [ select_id - 1 ] [ b_auction_status ] == 1 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш бизнес уже выставлен на аукцион." ) ;
				return 1 ;
			}
			
			if ( b_info [ select_id - 1 ] [ b_sell_status ] )
	        {
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваше имущество уже подгатавливается к опечатке." ) ;
				return 1 ;
			}
			
			for ( new b = 0 ; b < max_business ; b ++ )
			{
			    if ( business_info [ b ] [ business_number ] == b_info [ select_id - 1 ] [ b_id ] )
			    {
		            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Бизнес выставлен на продажу." ) ;
					return 1 ;
				}
			}
				
			if ( check_add_player ( playerid, TRADE_RIELT_BIZZ, 0, select_id ) ) return 1 ;
			
			p_info [ playerid ] [ business ] = select_id ;
			show_add_player ( playerid, TRADE_RIELT_BIZZ, 0, p_info [ playerid ] [ business ] ) ;
			
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен", "{"#cWH"}Игрок добавил на обмен недвижимость.\nНажмите на поле бизнеса для просмотра информации.", "Закрыть", "" ) ;
			return 1 ;
		}
		case d_trade_accessories:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        return 1 ;
		    }
			
			if ( listitem == 0 ) return show_trade_accesories ( playerid ) ;
			
			new select_id = get_player_listitem_values ( playerid, listitem - 1 ) ;
			clear_player_listitem_values ( playerid ) ;
				
			if ( check_add_player ( playerid, TRADE_RIELT_ACCS, 0, select_id ) ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_ACCS, acc_player [ playerid ] [ acc_model ] [ select_id ], select_id ) ;
			return 1 ;
		}
		case d_trade_rielt_skins:
	    {
	        if ( ! response )
			{
				clear_player_use_listitem ( playerid ) ;
				return 1 ;
			}

			if ( listitem == 0 )
			{
			    clear_player_use_listitem ( playerid ) ;
				show_rieltore_trade_skins ( playerid ) ;
				return 1 ;
			}
			
			new select_id = listitem - 1 ;
			if ( p_info [ playerid ] [ temp_skin ] [ select_id ] == 0 )
			{
				show_rieltore_trade_skins ( playerid ) ;
				return 1 ;
			}

			if ( p_info [ playerid ] [ skin ] == p_info [ playerid ] [ temp_skin ] [ select_id ] )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данная одежда надета на персонажа!" ) ;
				return 1 ;
			}

			new _count = -1 ;
			/*for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_SKIN ) continue ;

				_count = i ;
				break ;
			}*/
			
			if ( _count != -1 || check_add_player ( playerid, TRADE_RIELT_SKIN, 0, select_id ) ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_SKIN, p_info [ playerid ] [ temp_skin ] [ select_id ], select_id ) ;
			return 1 ;
	    }
	}
	return 0 ;
}

stock show_rieltore_trade_skins ( playerid )
{
    new line_string [ 36 ] ;
	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Выберите одежду для обмена\n" ) ;
	for ( new j = 0 ; j < 5 ; j ++ )
	{
		if ( p_info [ playerid ] [ temp_skin ] [ j ] == 0 )
		{
			strcat ( global_string, "{"#cGRDialog"}- Пусто\n" ) ;
		}
		else
		{
			format ( line_string, 36, "{ffffff}Одежда | %d\n", p_info [ playerid ] [ temp_skin ] [ j ] ) ;
			strcat ( global_string, line_string ) ;
		}
	}
	show_dialog ( playerid, d_trade_rielt_skins, DIALOG_STYLE_LIST, "{"#cBHD"}Гардероб", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock returnmoney_trade ( playerid )
{
	page_count [ playerid ] = 1 ;

	static const _str [ ] = "SELECT `rm_id`, `rm_money`, `rm_type` FROM `return_money` WHERE `rm_dest` = '%d' AND `rm_type` = '1' ORDER BY `return_money`.`rm_id` DESC" ;
    new sql_string [ sizeof _str + 9 ] ;
	format ( sql_string, sizeof sql_string, _str, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string, "load_returnmoney_trade", "i", playerid ) ;
	return 1 ;
}

callback: load_returnmoney_trade ( playerid )
{
	new rows, fields;
	cache_get_data ( rows, fields ) ;

	if ( ! rows )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ничего не найдено." ) ;
		page_count [ playerid ] = 0 ;
		return 1 ;
	}

	if ( rows )
	{
		global_string [ 0 ] = EOS ;

		new rows_list = page_count [ playerid ] - 1 ;
		page_rows [ playerid ] = rows ;

        new dm_id, dm_money, dm_type, line_string [ 128 ], row_count, pvar_string [ 12 ] ;
		for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
		{
		    if ( i >= rows ) break ;

		    dm_id = cache_get_field_content_int ( i, "rm_id", sql_connection ) ;
		    dm_money = cache_get_field_content_int ( i, "rm_money", sql_connection ) ;
		    dm_type = cache_get_field_content_int ( i, "rm_type", sql_connection ) ;

            set_player_listitem_values ( playerid, i - rows_list * 10, dm_id ) ;
		
			format ( pvar_string, sizeof pvar_string, "p_%d", row_count ) ;
			SetPVarInt ( playerid, pvar_string, dm_money ) ;

			if ( dm_type == RETURN_TYPE_MONEY ) format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cGN"}%d$\n", i + 1, dm_money ) ;
			else if ( dm_type == RETURN_TYPE_ACESSORIES ) format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\n", i + 1, get_accessorie_name ( dm_money ) ) ;
			strcat ( global_string, line_string ) ;

			row_count ++ ;
		}

		if ( rows_list > 0 )
		{
			strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
			set_player_use_page ( playerid, row_count, 0 ) ;
			row_count ++ ;
		}
		if ( ofm_formula ( page_count [ playerid ] ) < rows )
		{
			strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
			set_player_use_page ( playerid, row_count, 1 ) ;
		}

		show_dialog ( playerid, d_returnmoney_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Возврат средств", global_string, "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}

stock show_trade_inventory ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], bool: _finded_prise = false, row_count = 0, date_string [ 86 ] ;

	for ( new i = 0 ; i < MAX_PRISE_SLOT ; i ++ )
	{
	    if ( p_info [ playerid ] [ prise_slot ] [ i ] < 1 ) continue ;

	    set_player_listitem_values ( playerid, row_count, i ) ;
	    row_count ++ ;

		new s_year, s_month, s_day, s_hour, s_minute, s_second, _day = p_info [ playerid ] [ prise_slot_date ] [ i ] ;
		if ( _day != -1 )
		{
			timestamp_to_date ( p_info [ playerid ] [ prise_slot_date ] [ i ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
			format ( date_string, sizeof date_string, "{"#cGRDialog"}({"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d{"#cGRDialog"})", s_day, s_month, s_year ) ;
		}
	    else format ( date_string, sizeof date_string, " " ) ;

	    new prize_type = p_info [ playerid ] [ prise_slot ] [ i ] ;
		if ( prize_type > skin_cross && prize_type < ( skin_cross + 1000 ) ) format ( line_string, sizeof line_string, "{"#cWH"}Одежда №%d (%d шт.) %s\n", prize_type - skin_cross, p_info [ playerid ] [ prise_slot_count ] [ i ], date_string ) ;
		else format ( line_string, sizeof line_string, "{"#cWH"}%s (%d шт.) %s\n", item_name ( prize_type ), p_info [ playerid ] [ prise_slot_count ] [ i ], date_string ) ;
	    strcat ( global_string, line_string ) ;
	    
	    _finded_prise = true ;
	}
	
	if ( _finded_prise == false )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш подарочный инвентарь пуст." ) ;
		return 1 ;
	}
	
	show_dialog ( playerid, d_prise_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Подарочный инвентарь", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_trade_accesories ( playerid )
{
    new line_string [ 128 ], count_acc = 0 ;
	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Выберите слот аксессуара\n" ) ;
	for ( new j = 0 ; j < MAX_ACCESORIES ; j ++ )
	{
		if ( acc_player [ playerid ] [ acc_model ] [ j ] < 1 ) continue ;
		if ( acc_player [ playerid ] [ acc_date ] [ j ] > 0 ) continue ;
		if ( acc_player [ playerid ] [ acc_used ] [ j ] ) continue ;
		
		set_player_listitem_values ( playerid, count_acc, j ) ;

		count_acc ++ ;

		format ( line_string, sizeof line_string, "{"#cWH"}- %s\n", get_accessorie_name ( acc_player [ playerid ] [ acc_model ] [ j ] ) ) ;
		strcat ( global_string, line_string ) ;
	}
	if ( count_acc == 0 ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет аксессуар, которые можно обменять. Либо аксессуар надет на Вас." ) ;
	else show_dialog ( playerid, d_trade_accessories, DIALOG_STYLE_LIST, "{"#cBHD"}Аксессуары", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_home_trade ( playerid )
{
	if ( Iter_Count(player_houses[playerid]) == 1 )
	{
		new select_id = Iter_First(player_houses[playerid]) ;
		if ( h_info [ select_id - 1 ] [ h_auction_status ] == 1 )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш дом уже выставлен на аукцион." ) ;
			return 1 ;
		}
			
		if ( h_info [ select_id - 1 ] [ h_sell_status ] )
	    {
	        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваше имущество уже подгатавливается к опечатке." ) ;
			return 1 ;
		}
			
		for ( new h = 0 ; h < max_houses ; h ++ )
		{
		    if ( houses_info [ h ] [ houses_number ] == h_info [ select_id - 1 ] [ h_id ] )
		    {
		        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Дом выставлен на продажу." ) ;
				return 1 ;
			}
		}
				
		if ( check_add_player ( playerid, TRADE_RIELT_HOUSE, 0, select_id ) ) return 1 ;
			
	    p_info [ playerid ] [ house ] = Iter_First(player_houses[playerid]) ;
		show_add_player ( playerid, TRADE_RIELT_HOUSE, 0, p_info [ playerid ] [ house ] ) ;
	}
	else
	{
	    global_string [ 0 ] = EOS ;
	    new line_string [ 128 ], count_h = 0 ;
	    foreach(new h: player_houses[playerid])
	    {
	        set_player_listitem_values ( playerid, count_h, h ) ;

	        count_h ++ ;

			format ( line_string, sizeof line_string, "{"#cBL"}%d.{"#cWH"} %s - {"#cBL"}№%d {"#cGRDialog"}(%s{"#cGRDialog"})\n", count_h, house_classes [ house_int [ h_info [ h - 1 ] [ h_int ] - 1 ] [ hint_class ] ], h, ( h_info [ h - 1 ] [ h_closed ] ) ? ( "{"#cRD"}Закрыт" ) : ( "{"#cGN"}Открыт" ) ) ;
			strcat ( global_string, line_string ) ;
		}
	    show_dialog ( playerid, d_home_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Дома", global_string, "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}

stock show_business_trade ( playerid )
{
	if ( Iter_Count(player_business[playerid]) == 1 )
	{
		new select_id = Iter_First(player_business[playerid]) ;
		if ( b_info [ select_id - 1 ] [ b_auction_status ] == 1 )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш бизнес уже выставлен на аукцион." ) ;
			return 1 ;
		}
			
		if ( b_info [ select_id - 1 ] [ b_sell_status ] )
	    {
	        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваше имущество уже подгатавливается к опечатке." ) ;
			return 1 ;
		}
			
		for ( new b = 0 ; b < max_business ; b ++ )
		{
		    if ( business_info [ b ] [ business_number ] == b_info [ select_id - 1 ] [ b_id ] )
		    {
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Бизнес выставлен на продажу." ) ;
				return 1 ;
			}
		}
				
		if ( check_add_player ( playerid, TRADE_RIELT_BIZZ, 0, select_id ) ) return 1 ;
	
	    p_info [ playerid ] [ business ] = select_id ;
		show_add_player ( playerid, TRADE_RIELT_BIZZ, 0, p_info [ playerid ] [ business ] ) ;
	}
	else
	{
	    global_string [ 0 ] = EOS ;
	    new line_string [ 128 ], count_b = 0 ;

	    new _b_name [ 17 ], _b_type [ 17 ] ;

	    foreach(new b: player_business[playerid])
	    {
	        set_player_listitem_values ( playerid, count_b, b ) ;

	        count_b ++ ;
	        
	        if ( strlen ( b_types [ b_info [ b - 1 ] [ b_type ] ] ) > 14 )
			{
				format ( _b_type, 14, "%s", b_types [ b_info [ b - 1 ] [ b_type ] ] ) ;
				strcat ( _b_type, "..." ) ;
			}
			else format ( _b_type, 14, "%s", b_types [ b_info [ b - 1 ] [ b_type ] ] ) ;

	        if ( strlen ( b_info [ b - 1 ] [ b_name ] ) > 14 )
			{
				format ( _b_name, 14, "%s", b_info [ b - 1 ] [ b_name ] ) ;
				strcat ( _b_name, "..." ) ;
			}
			else format ( _b_name, 14, "%s", b_info [ b - 1 ] [ b_name ] ) ;

			format ( line_string, sizeof line_string, "{"#cBL"}%d.{"#cWH"} (%s) %s {"#cGRDialog"}(%s{"#cGRDialog"}){"#cWH"}. Продуктов: {"#cBL"}%d\n", count_b, _b_type, _b_name, ( b_info [ b - 1 ] [ b_close ] ) ? ( "{"#cRD"}Закрыт" ) : ( "{"#cGN"}Открыт" ), b_info [ b - 1 ] [ b_product ] ) ;
			strcat ( global_string, line_string ) ;
		}
	    show_dialog ( playerid, d_business_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Бизнесы", global_string, "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}

stock trade_PlayerTextDraw ( playerid, PlayerText:playertextid )
{
	if ( trade_rielt [ playerid ] [ trade_id ] != INVALID_PLAYER_ID )
	{
		if ( playertextid == def_trade_main_PTD [ playerid ] [ 30 ] )
		{
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			
			used_trade [ playerid ] = false ;
			used_trade [ targetid ] = false ;
		
			show_trade_ptd ( playerid, false ) ;
			show_player_ptd ( playerid, false ) ;
			show_trader_ptd ( playerid, false ) ;
			clear_player_trade ( playerid ) ;
			
			show_trade_ptd ( targetid, false ) ;
			show_player_ptd ( targetid, false ) ;
			show_trader_ptd ( targetid, false ) ;
			clear_player_trade ( targetid ) ;
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен имуществом", "{"#cRInfo"}* {"#cGRDialog"}Вы отказались от обмена. Обмен отменён!", "Хорошо", "" ) ;
			show_dialog ( targetid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Обмен имуществом", "{"#cRInfo"}* {"#cGRDialog"}Игрок, с которым Вы обменивались, отказался. Обмен отменён!", "Хорошо", "" ) ;
			return 1 ;
		}
		else if ( playertextid == def_trade_main_PTD [ playerid ] [ 9 ] )
		{
			show_dialog ( playerid, d_trade, DIALOG_STYLE_LIST, "{"#cBHD"}Обмен имуществом", "\
				{"#cBL"}1. {"#cWH"}Дом\n\
				{"#cBL"}2. {"#cWH"}Бизнес\n\
				{"#cBL"}3. {"#cWH"}Деньги\n\
				{"#cBL"}4. {"#cWH"}Транспорт\n\
				{"#cBL"}5. {"#cWH"}Аксессуар\n\
				{"#cBL"}6. {"#cWH"}Предмет инвентаря\n\
				{"#cBL"}7. {"#cWH"}Гараж\n\
				{"#cBL"}8. {"#cWH"}/returnmoney (/rm)\n\
				{"#cBL"}9. {"#cWH"}Номерные знаки\n\
				{"#cBL"}10. {"#cWH"}Одежда\n\
				{"#cBL"}11. {"#cWH"}Семья\n\
				{"#cBL"}12. {"#cWH"}Семейные талоны\n\
				{"#cBL"}13. {"#cWH"}SIM-карта", "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		else if ( playertextid == def_trade_main_PTD [ playerid ] [ 21 ] )
		{
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			
			global_string [ 0 ] = EOS ;
			new line_string [ 128 ], _count = 0 ;
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ targetid ] [ trade_type ] [ i ] == 0 ) continue ;
				
				switch ( trade_rielt [ targetid ] [ trade_type ] [ i ] )
				{
					case TRADE_RIELT_HOUSE: format ( line_string, sizeof line_string, "%d. Дом (№%d)\n", _count + 1, trade_rielt [ targetid ] [ trade_item ] [ i ] ) ;
					case TRADE_RIELT_BIZZ: format ( line_string, sizeof line_string, "%d. Бизнес (№%d)\n", _count + 1, trade_rielt [ targetid ] [ trade_item ] [ i ] ) ;
					case TRADE_RIELT_MONEY: format ( line_string, sizeof line_string, "%d. %s$\n", _count + 1, GetPlayerCashValueToSmile ( trade_rielt [ targetid ] [ trade_count ] [ i ] ) ) ;
					case TRADE_RIELT_CAR: 
					{
						new _v_id = trade_rielt [ targetid ] [ trade_item ] [ i ] ;
						if ( ! IsValidVehicle ( _v_id ) || _v_id < 0 || _v_id > 2000 ) 
						{
							show_remove_player ( targetid, i ) ;
							continue ;
						}
						format ( line_string, sizeof line_string, "%d. Транспорт (%s). Пробег: %.1f км, можно скрутить до: %.1f км\n", _count + 1, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), veh_info [ _v_id - 1 ] [ v_millage ], veh_info [ _v_id - 1 ] [ v_legal_millage ] ) ;
					}
					case TRADE_RIELT_ACCS: format ( line_string, sizeof line_string, "%d. Аксессуар %s\n", _count + 1, get_accessorie_name ( trade_rielt [ targetid ] [ trade_count ] [ i ] ) ) ;
					case TRADE_RIELT_INVENTORY: format ( line_string, sizeof line_string, "%d. %s (%d шт.)\n", _count + 1, item_name ( trade_rielt [ targetid ] [ trade_item ] [ i ] ), trade_rielt [ targetid ] [ trade_count ] [ i ] ) ;
					case TRADE_RIELT_GARAGE: format ( line_string, sizeof line_string, "%d. Гараж (№%d)\n", _count + 1, trade_rielt [ targetid ] [ trade_item ] [ i ] ) ;
					case TRADE_RIELT_RETURN_MONEY: format ( line_string, sizeof line_string, "%d. %s$\n", _count + 1, GetPlayerCashValueToSmile ( trade_rielt [ targetid ] [ trade_count ] [ i ] ) ) ;
					case TRADE_RIELT_SKIN: format ( line_string, sizeof line_string, "%d. Одежда (№%d)", _count + 1, trade_rielt [ targetid ] [ trade_count ] [ _count ] ) ;
					case TRADE_RIELT_PLATE: format ( line_string, sizeof line_string, "%d. %s", _count + 1, trade_plate_name [ targetid ] [ _count ] ) ;
					case TRADE_RIELT_FAMILY: format ( line_string, sizeof line_string, "%d. Семья", _count + 1 ) ;
					case TRADE_RIELT_FAMILY_TALON: format ( line_string, sizeof line_string, "%d. %s "family_title"\n", _count + 1, GetPlayerCashValueToSmile ( trade_rielt [ targetid ] [ trade_count ] [ i ] ) ) ;
				}
				strcat ( global_string, line_string ) ;
				
				set_player_listitem_values ( playerid, _count, i ) ;
				_count ++ ;
			}
			if ( _count == 0 ) show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предметы игрока", "{"#cRD"}* {"#cGRDialog"}Игрок ещё ничего не добавил!", "Закрыть", "" ) ;
			else show_dialog ( playerid, d_trade_info, DIALOG_STYLE_LIST, "{"#cBHD"}Предметы игрока", global_string, "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		else if ( playertextid == def_trade_player1_PTD [ playerid ] [ 1 ] )
		{
			if ( ! trade_rielt [ playerid ] [ trade_accept ] )
			{
				trade_rielt [ playerid ] [ trade_accept ] = true ;
				
				if ( player_device { playerid } != 2 )
				{
					PlayerTextDrawSetString ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ], "V" ) ;
					
					PlayerTextDrawHide ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ] ) ;
					PlayerTextDrawColor ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ], -788653313 ) ;
					PlayerTextDrawShow ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ] ) ;
				}
				else if ( player_device { playerid } == 2 )
				{
					
				}
				
				new targetid = trade_rielt [ playerid ] [ trade_id ] ;
				if ( player_device { targetid } != 2 )
				{
					PlayerTextDrawSetString ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ], "V" ) ;
					
					PlayerTextDrawHide ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ] ) ;
					PlayerTextDrawColor ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ], -788653313 ) ;
					PlayerTextDrawShow ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ] ) ;
				}
				else if ( player_device { targetid } == 2 )
				{
					
				}
				
				if ( trade_rielt [ targetid ] [ trade_accept ] )
					sucess_trade ( playerid, targetid ) ;
			}
			else
			{
				trade_rielt [ playerid ] [ trade_accept ] = false ;
				
				if ( player_device { playerid } != 2 )
				{
					PlayerTextDrawSetString ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ], "X" ) ;
					
					PlayerTextDrawHide ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ] ) ;
					PlayerTextDrawColor ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ], -196206337 ) ;
					PlayerTextDrawShow ( playerid, def_trade_player1_PTD [ playerid ] [ 4 ] ) ;
				}
				else if ( player_device { playerid } == 2 )
				{
					
				}
				
				new targetid = trade_rielt [ playerid ] [ trade_id ] ;
				if ( player_device { targetid } != 2 )
				{
					PlayerTextDrawSetString ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ], "X" ) ;
					
					PlayerTextDrawHide ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ] ) ;
					PlayerTextDrawColor ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ], -196206337 ) ;
					PlayerTextDrawShow ( targetid, def_trade_player2_PTD [ targetid ] [ 4 ] ) ;
				}
				else if ( player_device { targetid } == 2 )
				{
					
				}
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock TranslateText1 ( string [ ] )
{
	new result [ 128 ] ;
	for ( new i = 0 ; i < sizeof ( result ) ; i ++ )
	{
		switch ( string [ i ] )
		{
			case 'а': result [ i ] = 'a' ;
			case 'А': result [ i ] = 'A' ;
			case 'б': result [ i ] = '—' ;
			case 'Б': result [ i ] = 'Ђ' ;
			case 'в': result [ i ] = 'ў' ;
			case 'В': result [ i ] = '‹' ;
			case 'г': result [ i ] = '™' ;
			case 'Г': result [ i ] = '‚' ;
			case 'д': result [ i ] = 'љ' ;
			case 'Д': result [ i ] = 'ѓ' ;
			case 'е': result [ i ] = 'e' ;
			case 'Е': result [ i ] = 'E' ;
			case 'ё': result [ i ] = 'e' ;
			case 'Ё': result [ i ] = 'E' ;
			case 'ж': result [ i ] = '›' ;
			case 'Ж': result [ i ] = '„' ;
			case 'з': result [ i ] = 'џ' ;
			case 'З': result [ i ] = '€' ;
			case 'и': result [ i ] = 'њ' ;
			case 'И': result [ i ] = '…' ;
			case 'й': result [ i ] = 'ќ' ;
			case 'Й': result [ i ] = '…' ;
			case 'к': result [ i ] = 'k' ;
			case 'К': result [ i ] = 'K' ;
			case 'л': result [ i ] = 'ћ' ;
			case 'Л': result [ i ] = '‡' ;
			case 'м': result [ i ] = 'Ї' ;
			case 'М': result [ i ] = 'M' ;
			case 'н': result [ i ] = '®' ;
			case 'Н': result [ i ] = ' ' ;
			case 'о': result [ i ] = 'o' ;
			case 'О': result [ i ] = 'O' ;
			case 'п': result [ i ] = 'Ј' ;
			case 'П': result [ i ] = 'Њ' ;
			case 'р': result [ i ] = 'p' ;
			case 'Р': result [ i ] = 'P' ;
			case 'с': result [ i ] = 'c' ;
			case 'С': result [ i ] = 'C' ;
			case 'т': result [ i ] = '¦' ;
			case 'Т': result [ i ] = 'Џ' ;
			case 'у': result [ i ] = 'y' ;
			case 'У': result [ i ] = 'Y' ;
			case 'ф': result [ i ] = '~' ;
			case 'Ф': result [ i ] = 'Ѓ' ;
			case 'х': result [ i ] = 'x' ;
			case 'Х': result [ i ] = 'X' ;
			case 'ц': result [ i ] = '*' ;
			case 'Ц': result [ i ] = '‰' ;
			case 'ч': result [ i ] = '¤' ;
			case 'Ч': result [ i ] = 'Ќ' ;
			case 'ш': result [ i ] = 'Ґ' ;
			case 'Ш': result [ i ] = 'Ћ' ;
			case 'щ': result [ i ] = 'Ў' ;
			case 'Щ': result [ i ] = 'Љ' ;
			case 'ь': result [ i ] = '©' ;
			case 'Ь': result [ i ] = '’' ;
			case 'ъ': result [ i ] = 'ђ' ;
			case 'Ъ': result [ i ] = '§' ;
			case 'ы': result [ i ] = 'Ё' ;
			case 'Ы': result [ i ] = '‘' ;
			case 'э': result [ i ] = 'Є' ;
			case 'Э': result [ i ] = '“' ;
			case 'ю': result [ i ] = '«' ;
			case 'Ю': result [ i ] = '”' ;
			case 'я': result [ i ] = '¬' ;
			case 'Я': result [ i ] = '•' ;
			default: result [ i ] = string [ i ] ;
		}
	}
	return result ;
}

stock set_packet_trade_valute ( playerid, _param1 )
{
	if ( _param1 == 5 )
	{
		new _value = get_player_use_listitem ( playerid ) ;
		if ( _value < 1 || p_info [ playerid ] [ money ] < _value )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно "valute_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
			
		new _count = -1 ;
		for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
		{
			if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_MONEY ) continue ;

			_count = i ;
			break ;
		}
		
		if ( _count != -1 )
		{
			if ( trade_rielt [ playerid ] [ trade_count ] [ _count ] + _value < 1 || trade_rielt [ playerid ] [ trade_count ] [ _count ] + _value > p_info [ playerid ] [ money ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "valute_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
		}
		
		update_sucess_trade ( playerid ) ;
		show_add_player ( playerid, TRADE_RIELT_MONEY, _value, 0 ) ;
	}
	else if ( _param1 == 6 )
	{
		new _value = get_player_use_listitem ( playerid ) ;
		if ( _value < 1 || p_info [ playerid ] [ family_ticket ] < _value )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно "family_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
			
		new _count = -1 ;
		for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
		{
			if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_FAMILY_TALON ) continue ;

			_count = i ;
			break ;
		}
		
		if ( _count != -1 )
		{
			if ( trade_rielt [ playerid ] [ trade_count ] [ _count ] + _value < 1 || trade_rielt [ playerid ] [ trade_count ] [ _count ] + _value > p_info [ playerid ] [ family_ticket ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "family_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
		}
		
		update_sucess_trade ( playerid ) ;
		show_add_player ( playerid, TRADE_RIELT_FAMILY_TALON, _value, 0 ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock set_packet_trade_value ( playerid, _param1, _param2 )
{
	if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), _count = -1 ;
		for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
		{
			if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_INVENTORY ) continue ;
			if ( trade_rielt [ playerid ] [ trade_item ] [ i ] != p_info [ playerid ] [ prise_slot ] [ _id ] ) continue ;

			_count = i ;
			break ;
		}
		
		if ( _count != -1 )
		{
			if ( p_info [ playerid ] [ prise_slot_count ] [ _id ] < trade_rielt [ playerid ] [ trade_count ] [ _count ] + 1 )
			{
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
		}
		
		show_add_player ( playerid, TRADE_RIELT_INVENTORY, 1, p_info [ playerid ] [ prise_slot ] [ _id ] ) ;
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), _count = -1 ;
		for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
		{
			if ( trade_rielt [ playerid ] [ trade_type ] [ i ] != TRADE_RIELT_INVENTORY ) continue ;
			if ( trade_rielt [ playerid ] [ trade_item ] [ i ] != p_info [ playerid ] [ prise_slot ] [ _id ] ) continue ;

			_count = i ;
			break ;
		}
		
		if ( _param2 < 1 )
		{
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( _count != -1 )
		{
			if ( p_info [ playerid ] [ prise_slot_count ] [ _id ] < trade_rielt [ playerid ] [ trade_count ] [ _count ] + _param2 )
			{
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
		}
		
		show_add_player ( playerid, TRADE_RIELT_INVENTORY, _param2, p_info [ playerid ] [ prise_slot ] [ _id ] ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock update_sucess_trade ( playerid )
{
	new _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
	if ( _trader_id != INVALID_PLAYER_ID && ( trade_rielt [ playerid ] [ trade_accept ] || trade_rielt [ _trader_id ] [ trade_accept ] ) )
	{
		trade_rielt [ playerid ] [ trade_accept ] = false ;
				
		new _slot_money = -1, _slot_family_talon = -1, _slot_money_trader = -1, _slot_family_talon_trader = -1 ;
		for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
		{
			if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money_trader = i ;
			else if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon_trader = i ;
					
			if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money = i ;
			else if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon = i ;
		}
				
		new _str [ 13 + MAX_PLAYER_NAME ], _str2 [ 64 ], _str3 [ 64 ] ;
		
		trade_rielt [ _trader_id ] [ trade_accept ] = false ;
		send_check_cinfo ( _trader_id, "Произошли изменения в предложенных предметах.\nПроверьте корректность предметов.", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
		
		format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ _trader_id ] [ name ] ) ;
		format ( _str2, sizeof _str2, "%d"valute_title_", %d "family_title"", ( _slot_money == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_money ] ), ( _slot_family_talon == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_family_talon ] ) ) ;
		format ( _str3, sizeof _str3, "%d"valute_title_", %d "family_title"", ( _slot_money_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_money_trader ] ), ( _slot_family_talon_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_family_talon_trader ] ) ) ;
		tradeUpdate ( playerid, _str, trade_rielt [ playerid ] [ trade_accept ], trade_rielt [ _trader_id ] [ trade_accept ], false, _str2, _str3 ) ;
		format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ playerid ] [ name ] ) ;
		tradeUpdate ( _trader_id, _str, trade_rielt [ _trader_id ] [ trade_accept ], trade_rielt [ playerid ] [ trade_accept ], false, _str3, _str2 ) ;
	}
	return 1 ;
}

stock show_packet_trade ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;

			used_trade [ playerid ] = false ;

			show_trade_ptd ( playerid, false ) ;
			show_player_ptd ( playerid, false ) ;
			show_trader_ptd ( playerid, false ) ;
			clear_player_trade ( playerid ) ;

			if ( targetid != INVALID_PLAYER_ID )
			{
				used_trade [ targetid ] = false ;
				
				show_trade_ptd ( targetid, false ) ;
				show_player_ptd ( targetid, false ) ;
				show_trader_ptd ( targetid, false ) ;
				clear_player_trade ( targetid ) ;
			}
		}
		else if ( _param2 == 1 )
		{
			new _slot_money = -1, _slot_family_talon = -1, _slot_money_trader = -1, _slot_family_talon_trader = -1, _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
			
			trade_rielt [ playerid ] [ trade_accept ] = true ;
			if ( trade_rielt [ _trader_id ] [ trade_accept ] )
			{
				if ( _trader_id == INVALID_PLAYER_ID )
				{
					show_packet_trade ( playerid, 0, 0, 0 ) ;
					return 1 ;
				}
				sucess_trade ( playerid, _trader_id ) ;
				return 1 ;
			}
			
			for ( new i = 0 ; i < MAX_TRADE_SLOT ; i ++ )
			{
				if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money_trader = i ;
				else if ( trade_rielt [ _trader_id ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon_trader = i ;
				
				if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_MONEY ) _slot_money = i ;
				else if ( trade_rielt [ playerid ] [ trade_type ] [ i ] == TRADE_RIELT_FAMILY_TALON ) _slot_family_talon = i ;
			}

			new _str [ 13 + MAX_PLAYER_NAME ], _str2 [ 64 ], _str3 [ 64 ] ;
			format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ _trader_id ] [ name ] ) ;
			format ( _str2, sizeof _str2, "%d"valute_title_", %d "family_title"", ( _slot_money == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_money ] ), ( _slot_family_talon == -1 ) ? ( 0 ) : ( trade_rielt [ playerid ] [ trade_count ] [ _slot_family_talon ] ) ) ;
			format ( _str3, sizeof _str3, "%d"valute_title_", %d "family_title"", ( _slot_money_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_money_trader ] ), ( _slot_family_talon_trader == -1 ) ? ( 0 ) : ( trade_rielt [ _trader_id ] [ trade_count ] [ _slot_family_talon_trader ] ) ) ;
			tradeUpdate ( playerid, _str, trade_rielt [ playerid ] [ trade_accept ], trade_rielt [ _trader_id ] [ trade_accept ], false, _str2, _str3 ) ;
			format ( _str, sizeof _str, "ОБМЕН С %s", p_info [ playerid ] [ name ] ) ;
			tradeUpdate ( _trader_id, _str, trade_rielt [ _trader_id ] [ trade_accept ], trade_rielt [ playerid ] [ trade_accept ], true, _str3, _str2 ) ;
		}
		else if ( _param2 == 2 )
		{
			update_sucess_trade ( playerid ) ;
		}
		else if ( _param2 == 3 )
		{
			if ( _param3 < 1 && _param3 > max_money ) return 1 ;
			
			showSelectorDialog ( playerid, "", "", "", "", ""valute_title_"", ""family_title"", "Валюта", "Выберите валюту доплаты:" ) ;
			dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			
			set_player_use_listitem ( playerid, _param3 ) ;
			SetPlayerDialogsType ( playerid, 3 ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		update_sucess_trade ( playerid ) ;
		if ( _param2 == TRADE_RIELT_INVENTORY )
		{
			if ( p_info [ playerid ] [ prise_slot ] [ _param3 ] < 1 ) return 1 ;
			if ( checkInventoryMarket ( playerid, _param3 ) )
			{
				send_check_cinfo ( playerid, "Предмет выставлен на рынке.", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _i_item = p_info [ playerid ] [ prise_slot ] [ _param3 ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = p_info [ playerid ] [ prise_slot_date ] [ _param3 ], 
				date_string [ 64 ] ;
					
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
					{"#cWH"}Предмет: {"#cOR"}%s\n\
					{"#cWH"}Количество: {"#cWV"}%d шт.\n\
					{"#cWH"}%s\n\n\
					{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
					%s",
			item_name ( _i_item ), p_info [ playerid ] [ prise_slot_count ] [ _param3 ], date_string, get_model_count ( _i_item ), item_description ( _i_item ) ) ;

			if ( p_info [ playerid ] [ prise_slot_count ] [ _param3 ] > 1 )
			{
				showSelectorDialog ( playerid, "", "", "", "", "Добавить 1 шт.", "Добавить", "Информация", global_string ) ;
				
				new _str [ 8 ] ;
				format ( _str, sizeof _str, "%d", p_info [ playerid ] [ prise_slot_count ] [ _param3 ] ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, p_info [ playerid ] [ prise_slot_count ] [ _param3 ] ) ;
			}
				
			else
			{
				showSelectorDialog ( playerid, "", "", "", "", "Добавить", "-", "Информация", global_string ) ;
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			}
			
			set_player_use_listitem ( playerid, _param3 ) ;
			SetPlayerDialogsType ( playerid, 4 ) ;
		}
		else if ( _param2 == TRADE_RIELT_CAR )
		{
			if ( _param3 < 0 ) return 1 ;
			if ( veh_info [ _param3 - 1 ] [ v_type ] != vehicle_type_player )
			{
				send_check_cinfo ( playerid, "Выбранное т/с не принадлежит Вам! Вам необходимо загрузить его заново (/cars)", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( veh_info [ _param3 - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] )
			{
				send_check_cinfo ( playerid, "Выбранное т/с не принадлежит Вам! Вам необходимо загрузить его заново (/cars)", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( check_add_player ( playerid, TRADE_RIELT_CAR, 0, _param3 ) ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_CAR, 0, _param3 ) ;
		}
		else if ( _param2 == TRADE_RIELT_ACCS )
		{
			if ( acc_player [ playerid ] [ acc_model ] [ _param3 ] < 1 ) return 1 ;
			if ( acc_player [ playerid ] [ acc_date ] [ _param3 ] > 0 )
			{
				send_check_cinfo ( playerid, "Вы не можете обменять временный аксессуар!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( acc_player [ playerid ] [ acc_used ] [ _param3 ] )
			{
				send_check_cinfo ( playerid, "Аксессуар надет на Вас!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( check_add_player ( playerid, TRADE_RIELT_ACCS, 0, _param3 ) ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_ACCS, acc_player [ playerid ] [ acc_model ] [ _param3 ], _param3 ) ;
		}
		else if ( _param2 == TRADE_RIELT_HOUSE )
		{
			if ( _param3 < 0 ) return 1 ;
			
			if ( h_info [ _param3 - 1 ] [ h_owner ] != p_info [ playerid ] [ id ] )
			{
				send_check_cinfo ( playerid, "Данный дом не принадлежит Вам!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			if ( h_info [ _param3 - 1 ] [ h_sell_status ] )
			{
				send_check_cinfo ( playerid, "Ваше имущество уже подгатавливается к опечатке!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			if ( h_info [ _param3 - 1 ] [ h_sell_status ] )
			{
				send_check_cinfo ( playerid, "Ваше имущество уже подгатавливается к опечатке!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			for ( new h = 0 ; h < max_houses ; h ++ )
			{
				if ( houses_info [ h ] [ houses_number ] == h_info [ _param3 - 1 ] [ h_id ] )
				{
					send_check_cinfo ( playerid, "Дом выставлен на продажу!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}

			if ( check_add_player ( playerid, TRADE_RIELT_HOUSE, 0, _param3 ) ) return 1 ;
			if ( p_info [ playerid ] [ id ] != h_info [ _param3 - 1 ] [ h_owner ] ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_HOUSE, 0, _param3 ) ;
		}
		else if ( _param2 == TRADE_RIELT_BIZZ )
		{
			if ( _param3 < 0 ) return 1 ;
			
			if ( b_info [ _param3 - 1 ] [ b_owner_inc ] != p_info [ playerid ] [ id ] )
			{
				send_check_cinfo ( playerid, "Данный бизнес не принадлежит Вам!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( b_info [ _param3 - 1 ] [ b_auction_status ] == 1 )
			{
				send_check_cinfo ( playerid, "Ваш бизнес уже выставлен на аукцион!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			if ( b_info [ _param3 - 1 ] [ b_sell_status ] )
			{
				send_check_cinfo ( playerid, "Ваше имущество уже подгатавливается к опечатке!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			for ( new b = 0 ; b < max_business ; b ++ )
			{
				if ( business_info [ b ] [ business_number ] == b_info [ _param3 - 1 ] [ b_id ] )
				{
					send_check_cinfo ( playerid, "Бизнес выставлен на продажу!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
					
			if ( check_add_player ( playerid, TRADE_RIELT_BIZZ, 0, _param3 ) ) return 1 ;
			if ( p_info [ playerid ] [ id ] != b_info [ _param3 - 1 ] [ b_owner_inc ] ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_BIZZ, 0, _param3 ) ;
		}
		else if ( _param2 == TRADE_RIELT_GARAGE )
		{
			if ( p_info [ playerid ] [ cellar ] == -1 )
			{
				send_check_cinfo ( playerid, "У Вас нет гаража!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( p_info [ playerid ] [ id ] != cellar_info [ _param3 - 1 ] [ cl_owner ] ) return 1 ;
			show_add_player ( playerid, TRADE_RIELT_GARAGE, 0, _param3 ) ;
		}
		else if ( _param2 == TRADE_RIELT_SKIN )
		{
			if ( p_info [ playerid ] [ skin ] == p_info [ playerid ] [ temp_skin ] [ _param3 ] )
			{
				send_check_cinfo ( playerid, "Данная одежда надета на персонажа!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( p_info [ playerid ] [ temp_skin ] [ _param3 ] < 1 || check_add_player ( playerid, TRADE_RIELT_SKIN, 0, _param3 ) ) return 1 ;

			show_add_player ( playerid, TRADE_RIELT_SKIN, p_info [ playerid ] [ temp_skin ] [ _param3 ], _param3 ) ;
		}
		else if ( _param2 == TRADE_RIELT_FAMILY )
		{
			if ( ! p_info [ playerid ] [ family ] ) return 1 ;
			if ( ! GetString ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
			{
				send_check_cinfo ( playerid, "Передавать семью может только создатель!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _trader_id = trade_rielt [ playerid ] [ trade_id ] ;
			if ( p_info [ playerid ] [ family ] != p_info [ _trader_id ] [ family ] )
			{
				send_check_cinfo ( playerid, "Вы состоите не в одной семье!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				send_check_cinfo ( _trader_id, "Вы состоите не в одной семье!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( GetString ( family_info [ p_info [ _trader_id ] [ family ] - 1 ] [ fam_creator ], p_info [ _trader_id ] [ name ] ) )
			{
				send_check_cinfo ( playerid, "Игрок уже является владельцем семьи!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				send_check_cinfo ( _trader_id, "Вы уже являетесь владельцем семьи!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
					
			if ( check_add_player ( _trader_id, TRADE_RIELT_FAMILY, 0, p_info [ _trader_id ] [ family ] ) )
			{
				send_check_cinfo ( playerid, "Игрок уже выставил семью на обмен!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( check_add_player ( playerid, TRADE_RIELT_FAMILY, 0, p_info [ playerid ] [ family ] ) ) return 1 ;
			
			show_add_player ( playerid, TRADE_RIELT_FAMILY, 0, p_info [ playerid ] [ family ] ) ;
		}
		else if ( _param2 == TRADE_RIELT_SIMCARD )
		{
			if ( p_info [ playerid ] [ number ] < 1 )
			{
				send_check_cinfo ( playerid, "У Вас нет SIM-карты!", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
					
			if ( check_add_player ( playerid, TRADE_RIELT_SIMCARD, 0, p_info [ playerid ] [ number ] ) ) return 1 ;
			show_add_player ( playerid, TRADE_RIELT_SIMCARD, p_info [ playerid ] [ number ], p_info [ playerid ] [ number ] ) ;
		}
		else if ( _param2 == TRADE_RIELT_PLATE )
		{
			if ( check_add_player ( playerid, TRADE_RIELT_PLATE, 0, varchar_plateid [ playerid ] [ _param3 ] ) ) return 1 ;

			format ( trade_char_plate [ playerid ], 24, "%s", plate_number1 ( varchar_platetype [ playerid ] [ _param3 ], varchar_platename [ playerid ] [ _param3 ], varchar_plateregion [ playerid ] [ _param3 ] ) ) ;
			show_add_player ( playerid, TRADE_RIELT_PLATE, _param3, varchar_plateid [ playerid ] [ _param3 ] ) ;
		}
		
		show_packet_trade ( playerid, 0, 2, 0 ) ;
	}
	else if ( _param1 == 2 )
	{
		if ( _param2 == 1 )
		{
			update_sucess_trade ( playerid ) ;
			show_remove_player ( playerid, _param3 ) ;
		}
	}
	else if ( _param1 == 3 )
	{
		if ( _param2 == 1 )
		{
			global_string [ 0 ] = EOS ;
			new targetid = trade_rielt [ playerid ] [ trade_id ] ;
			switch ( trade_rielt [ targetid ] [ trade_type ] [ _param3 ] )
			{
				case TRADE_RIELT_HOUSE:
				{
					new _h_id = trade_rielt [ targetid ] [ trade_item ] [ _param3 ] ;
					format ( global_string, 256, "Дом №%d\n%s", _h_id, house_classes [ house_int [ h_info [ _h_id - 1 ] [ h_int ] - 1 ] [ hint_class ] ] ) ;
				}
				case TRADE_RIELT_BIZZ:
				{
					new _b_id = trade_rielt [ targetid ] [ trade_item ] [ _param3 ] ;
					format ( global_string, 256, "Бизнес №%d\n%s", _b_id, b_types [ b_info [ _b_id - 1 ] [ b_type ] ] ) ;
				}
				case TRADE_RIELT_CAR:
				{
					new _v_id = trade_rielt [ targetid ] [ trade_item ] [ _param3 ] ;
					if ( ! IsValidVehicle ( _v_id ) || _v_id < 0 || _v_id > 2000 ) 
					{
						show_remove_player ( targetid, _param3 ) ;
						return 1 ;
					}
					
					show_pts ( playerid, _v_id ) ;
				}
				case TRADE_RIELT_ACCS:
				{
					new _model = trade_rielt [ targetid ] [ trade_count ] [ _param3 ] ;
					format ( global_string, sizeof global_string, "\
						Аксессуар %s\n\
						{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
						%s",
					get_accessorie_name ( _model ), get_model_count ( _model ), item_description ( _model ) ) ;
				}
				case TRADE_RIELT_INVENTORY:
				{
					new _model = trade_rielt [ targetid ] [ trade_item ] [ _param3 ] ;
					format ( global_string, sizeof global_string, "\
						%s (%d шт.)\n\
						{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
						%s",
					item_name ( _model ), trade_rielt [ targetid ] [ trade_count ] [ _param3 ], get_model_count ( _model ), item_description ( _model ) ) ;
				}
				case TRADE_RIELT_GARAGE:
				{
					new _id = trade_rielt [ targetid ] [ trade_item ] [ _param3 ] ;
					format ( global_string, 256, "Гараж №%d", _id ) ;
				}
				case TRADE_RIELT_RETURN_MONEY:
				{
					new _id = trade_rielt [ targetid ] [ trade_count ] [ _param3 ] ;
					format ( global_string, 256, "%s$", GetPlayerCashValueToSmile ( _id ) ) ;
				}
				case TRADE_RIELT_SKIN:
				{
					new _id = trade_rielt [ targetid ] [ trade_count ] [ _param3 ] ;
					format ( global_string, 256, "Одежда №%d", _id ) ;
				}
				case TRADE_RIELT_PLATE:
				{
					format ( global_string, 256, "Номерной знак %s", trade_plate_name [ targetid ] [ _param3 ] ) ;
				}
				case TRADE_RIELT_FAMILY:
				{
					new _id = trade_rielt [ targetid ] [ trade_item ] [ _param3 ] ;
					format ( global_string, 256, "Семья %s", family_info [ _id - 1 ] [ fam_name ] ) ;
				}
				case TRADE_RIELT_SIMCARD:
				{
					format ( global_string, 256, "SIM %d", p_info [ targetid ] [ number ] ) ;
				}
			}
			
			showSelectorDialog ( playerid, "", "", "", "", "", "", "Информация", global_string ) ;
			SetPlayerDialogsType ( playerid, 0 ) ;
		}
	}
	return 1 ;
}

CMD:testt ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	show_rieltore_trade ( playerid, playerid, true ) ;
	return 1 ;
}