#define MARKET_PRICE_RENT	100000
new player_market [ MAX_PLAYERS ] = { -1, ... } ;
new player_market_rent [ MAX_PLAYERS ] = { -1, ... } ;

new bool: player_market_bool [ MAX_PLAYERS ] = { false, ... } ;
new player_market_type [ MAX_PLAYERS char ] = { 2, ... } ;

#define MARKET_ACTOR_1		INVALID_PLAYER_ID - 1
new Float: market_actor_position [ 4 ] = { -461.0363, 714.2191, 12.1175, 3.1067 } ;
new market_buy_item [ ] =
{
	1, 2, 3,
	15, 16, 17, 18, 19, 20, 21, 22, 23,
	24, 25, 26, 27, 28, 29, 30, 31,
	35, 36,
	37, 38, 39,
	40, 41, 42, 43, 44,
	45, 55,
	58, 59, 60, 61, 62, 63, 64, 65,
	71, 72, 73,
	84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94,
	95, 96, 97, 98,
	125,
	128, 129, 130, 131, 132, 133,
	134, 135, 136, 137,
	138,
	174, 175, 176, 177,
	178, 179, 180, 181, 182, 183, 184, 185, 186,
	905, 19941, 1463, 2684, 1080, 1018, 1038, 1140, 1165, 19773, 11746
} ;

#define MAX_MARKET 			150
#define MAX_MARKET_ITEM 	200
enum _market
{
	m_renter_id,
	m_area,
	m_object,
	bool: m_default,
	
	m_item_model [ MAX_MARKET_ITEM ],
	m_item_price [ MAX_MARKET_ITEM ],
	m_item_price_ft [ MAX_MARKET_ITEM ],
	m_item_price_ec [ MAX_MARKET_ITEM ],
	m_item_price_ac [ MAX_MARKET_ITEM ],
	m_item_count [ MAX_MARKET_ITEM ],
	
	m_item_buy_model [ MAX_MARKET_ITEM ],
	m_item_buy_price [ MAX_MARKET_ITEM ],
	m_item_buy_price_ft [ MAX_MARKET_ITEM ],
	m_item_buy_price_ec [ MAX_MARKET_ITEM ],
	m_item_buy_price_ac [ MAX_MARKET_ITEM ],
	m_item_buy_count [ MAX_MARKET_ITEM ],
	
	Float: m_position [ 3 ],
	Text3D: m_label,
	m_name [ 32 ],
	m_type
} ;
new market_info [ MAX_MARKET ] [ _market ] ;

enum
{
	d_market_rent = 31313,
	
	d_market_buy,
	d_market_buy_count,
	d_market_sell,
	d_market_sell_count,
	
	d_market_edit,
	d_market_edit_price,
	d_market_edit_price_ft,
	d_market_edit_price_ec,
	d_market_edit_count,
	
	d_market_edit_buy,
	d_market_edit_buy_price,
	d_market_edit_buy_price_ft,
	d_market_edit_buy_price_ec,
	d_market_edit_buy_count
} ;

#define MAX_MARKET_DEFAULT 6
new Float: market_default_position [ MAX_MARKET_DEFAULT ] [ 6 ] =
{
	{ -461.2217, 715.0012, 12.1175, 0.0000, 0.0000, 90.0000 },
	{ -449.0829, 715.7846, 12.0003, 0.0000, 0.0000, 90.0000 },
	{ -455.1187, 740.8825, 12.0003, 0.0000, 0.0000, 90.0000 },
	{ -441.9912, 740.9558, 12.0003, 0.0000, 0.0000, 90.0000 },
	{ -461.5907, 766.1316, 12.0003, 0.0000, 0.0000, -90.0000 },
	{ -449.6922, 766.9148, 12.0003, 0.0000, 0.0000, -90.0000 }
} ;

#include 									<custom/markets>

stock create_player_market ( playerid, _item_id )
{
	if ( GetPlayerInterior ( playerid ) > 0 || GetPlayerVirtualWorld ( playerid ) > 0 )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Палатку можно ставить только на улице." ) ;
		return 1 ;
	}
	
	foreach(new i: streamed_players[playerid])
	{
		if ( IsPlayerInRangeOfPoint ( playerid, 10.0, p_t_info [ i ] [ p_pos ] [ 0 ], p_t_info [ i ] [ p_pos ] [ 1 ], p_t_info [ i ] [ p_pos ] [ 2 ] ) )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рядом с Вами уже стоит палатка." ) ;
			return 1 ;
		}
	}
	
	for ( new i = 0 ; i < MAX_PICKUPS ; i ++ )
	{
		if ( IsPlayerInRangeOfPoint ( playerid, 10.0, pick_info [ i ] [ pick_pos ] [ 0 ], pick_info [ i ] [ pick_pos ] [ 1 ], pick_info [ i ] [ pick_pos ] [ 2 ] ) )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Запрещено ставить палатку рядом с пикапом." ) ;
			return 1 ;
		}
	}
	
	new bool: _free_slot = false ;
	for ( new i = 0 ; i < MAX_MARKET ; i ++ )
	{
		if ( market_info [ i ] [ m_default ] ) continue ;
		if ( IsValidDynamicObject ( market_info [ i ] [ m_object ] ) ) continue ;
		if ( market_info [ i ] [ m_renter_id ] != INVALID_PLAYER_ID ) continue ;
		
		_free_slot = true ;
		
		new Float: x = p_t_info [ playerid ] [ p_pos ] [ 0 ], Float: y = p_t_info [ playerid ] [ p_pos ] [ 1 ], Float: z = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;
		market_info [ i ] [ m_object ] = CreateDynamicObject ( _item_id, x, y, z, 0.0, 0.0, 0.0, 0, 0 ) ;
		market_info [ i ] [ m_area ] = CreateDynamicSphere ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], 5.0, 0, 0, -1 ) ;
		market_info [ i ] [ m_position ] [ 0 ] = x ;
		market_info [ i ] [ m_position ] [ 1 ] = y ;
		market_info [ i ] [ m_position ] [ 2 ] = z ;
		area_info [ market_info [ i ] [ m_area ] ] [ a_type ] = area_type_market ;
		area_info [ market_info [ i ] [ m_area ] ] [ a_item ] = i ;
		
		market_info [ i ] [ m_renter_id ] = playerid ;
		player_market [ playerid ] = i ;
		
		market_info [ i ] [ m_label ] = CreateDynamic3DTextLabel ( "", col_blue, x, y, z + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
		update_market_label ( i ) ;
		break ;
	}
	
	if ( ! _free_slot )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В игре поставлено максимальное количество киосков." ) ;
	}
	return 1 ;
}

stock market_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_market:
		{
			if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре. Используйте /mm - Информация о персонаже - Бонусы для проверки времени." ) ;
			
			new i = used_area [ playerid ] ;
			if ( i < 0 || i > MAX_MARKET ) return 1 ;
			
			send_check_cinfo ( playerid, market_info [ area_info [ i ] [ a_item ] ] [ m_name ], 1, -1, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_SWAP, "Открыть", "" ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock market_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_market:
		{
			player_market [ playerid ] = -1 ;
			clear_check_info ( playerid, CINFO_MARKET_ID ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock market_OnPlayerDisconnect ( playerid )
{
	new _m_id = player_market_rent [ playerid ] ;
	player_market_rent [ playerid ] = -1 ;
	if ( _m_id >= 0 && _m_id < MAX_MARKET && market_info [ _m_id ] [ m_renter_id ] == playerid )
	{
		new bool: _default = market_info [ _m_id ] [ m_default ] ;
		if ( ! _default )
		{
			if ( IsValidDynamicObject ( market_info [ _m_id ] [ m_object ] ) ) DestroyDynamicObject ( market_info [ _m_id ] [ m_object ] ) ;
			if ( IsValidDynamicArea ( market_info [ _m_id ] [ m_area ] ) ) DestroyDynamicArea ( market_info [ _m_id ] [ m_area ] ) ;
			if ( IsValidDynamic3DTextLabel ( market_info [ _m_id ] [ m_label ] ) ) DestroyDynamic3DTextLabel ( market_info [ _m_id ] [ m_label ] ) ;
		}

		for ( new i = 0 ; i < MAX_MARKET_ITEM ; i ++ )
		{
			market_info [ _m_id ] [ m_item_model ] [ i ] =
			market_info [ _m_id ] [ m_item_price ] [ i ] =
			market_info [ _m_id ] [ m_item_price_ft ] [ i ] =
			market_info [ _m_id ] [ m_item_price_ec ] [ i ] =
			market_info [ _m_id ] [ m_item_price_ac ] [ i ] = 0 ;
		}
		market_info [ _m_id ] [ m_renter_id ] = INVALID_PLAYER_ID ;
		update_player_market ( playerid, _m_id, -1, 2 ) ;

		if ( IsValidDynamic3DTextLabel ( market_info [ _m_id ] [ m_label ] ) ) update_market_label ( _m_id ) ;
	}
	return 1 ;
}

stock update_market_label ( _m_id )
{
	new _renter_id = market_info [ _m_id ] [ m_renter_id ] ;
	if ( _renter_id != INVALID_PLAYER_ID )
	{
		if ( _renter_id == MARKET_ACTOR_1 ) UpdateDynamic3DTextLabelText ( market_info [ _m_id ] [ m_label ], col_blue, "** Торговая лавка **\n{"#cGR3D"}Статус: {"#cRD"}Занята" ) ;
		else
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "** Торговая лавка **\n{"#cGR3D"}Статус: {"#cRD"}Занята\n{"#cGR3D"}Арендует: {"#cWH"}%s", p_info [ _renter_id ] [ name ] ) ;
			UpdateDynamic3DTextLabelText ( market_info [ _m_id ] [ m_label ], col_blue, global_string ) ;
		}
	}
	else UpdateDynamic3DTextLabelText ( market_info [ _m_id ] [ m_label ], col_blue, "** Торговая лавка **\n{"#cGR3D"}Статус: {"#cGN"}Свободна" ) ;
	return 1 ;
}

stock add_market ( _m_id, _m_type, _slot_id, _model, _type_price, _price, Float: _x, Float: _y, Float: _z, _str [ ], bool: _status )
{
	if ( _slot_id == 0 )
	{
		market_info [ _m_id ] [ m_area ] = CreateDynamicSphere ( _x, _y, _z, 5.0, 0, 0, -1 ) ;
		market_info [ _m_id ] [ m_position ] [ 0 ] = _x ;
		market_info [ _m_id ] [ m_position ] [ 1 ] = _y ;
		market_info [ _m_id ] [ m_position ] [ 2 ] = _z ;
		area_info [ market_info [ _m_id ] [ m_area ] ] [ a_type ] = area_type_market ;
		area_info [ market_info [ _m_id ] [ m_area ] ] [ a_item ] = _m_id ;
		
		market_info [ _m_id ] [ m_renter_id ] = MARKET_ACTOR_1 ;
		market_info [ _m_id ] [ m_type ] = _m_type ;
		
		market_info [ _m_id ] [ m_label ] = CreateDynamic3DTextLabel ( "", col_blue, _x, _y, _z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
		
		format ( market_info [ _m_id ] [ m_name ], 32, "%s", _str ) ;
	}
	
	market_info [ _m_id ] [ m_item_model ] [ _slot_id ] = _model ;
	market_info [ _m_id ] [ m_item_count ] [ _slot_id ] = 1000 ;
	if ( _type_price == 0 ) market_info [ _m_id ] [ m_item_price ] [ _slot_id ] = _price ;
	else if ( _type_price == 1 ) market_info [ _m_id ] [ m_item_price_ft ] [ _slot_id ] = _price ;
	else if ( _type_price == 2 ) market_info [ _m_id ] [ m_item_price_ec ] [ _slot_id ] = _price ;
	else if ( _type_price == 3 ) market_info [ _m_id ] [ m_item_price_ac ] [ _slot_id ] = _price ;
	
	if ( _status ) update_market_label ( _m_id ) ;
	return 1 ;
}

stock market_OnGameModeInit ( )
{
	for ( new i = 0 ; i < MAX_MARKET ; i ++ )
	{
		market_info [ i ] [ m_renter_id ] = INVALID_PLAYER_ID ;
		market_info [ i ] [ m_default ] = false ;
		market_info [ i ] [ m_type ] = 0 ;
		
		format ( market_info [ i ] [ m_name ], 32, "Торговая палатка" ) ;
	}
	
	for ( new i = 0 ; i < MAX_MARKET_DEFAULT ; i ++ )
	{
		market_info [ i ] [ m_object ] = CreateDynamicObject ( RandomEx ( 18400, 18402 ), market_default_position [ i ] [ 0 ], market_default_position [ i ] [ 1 ], market_default_position [ i ] [ 2 ], market_default_position [ i ] [ 3 ], market_default_position [ i ] [ 4 ], market_default_position [ i ] [ 5 ], 0, 0 ) ;
		market_info [ i ] [ m_area ] = CreateDynamicSphere ( market_default_position [ i ] [ 0 ], market_default_position [ i ] [ 1 ], market_default_position [ i ] [ 2 ], 5.0, 0, 0, -1 ) ;
		market_info [ i ] [ m_position ] [ 0 ] = market_default_position [ i ] [ 0 ] ;
		market_info [ i ] [ m_position ] [ 1 ] = market_default_position [ i ] [ 1 ] ;
		market_info [ i ] [ m_position ] [ 2 ] = market_default_position [ i ] [ 2 ] ;
		area_info [ market_info [ i ] [ m_area ] ] [ a_type ] = area_type_market ;
		area_info [ market_info [ i ] [ m_area ] ] [ a_item ] = i ;

		market_info [ i ] [ m_default ] = true ;
		
		market_info [ i ] [ m_label ] = CreateDynamic3DTextLabel ( "", col_blue, market_default_position [ i ] [ 0 ], market_default_position [ i ] [ 1 ], market_default_position [ i ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
		update_market_label ( i ) ;
	}

	market_info [ 0 ] [ m_renter_id ] = MARKET_ACTOR_1 ;
	
	// камень
	market_info [ 0 ] [ m_item_model ] [ 0 ] = 905 ;
	market_info [ 0 ] [ m_item_count ] [ 0 ] = 50_000 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 0 ] = 2 ;
	
	// золото
	market_info [ 0 ] [ m_item_model ] [ 1 ] = 19941 ;
	market_info [ 0 ] [ m_item_count ] [ 1 ] = 25_000 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 1 ] = 4 ;
	
	// древесина
	market_info [ 0 ] [ m_item_model ] [ 2 ] = 1463 ;
	market_info [ 0 ] [ m_item_count ] [ 2 ] = 50_000 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 2 ] = 8 ;
	
	// хлопок
	market_info [ 0 ] [ m_item_model ] [ 3 ] = 2684 ;
	market_info [ 0 ] [ m_item_count ] [ 3 ] = 25_000 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 3 ] = 10 ;
	
	// Колесо
	market_info [ 0 ] [ m_item_model ] [ 4 ] = 1080 ;
	market_info [ 0 ] [ m_item_count ] [ 4 ] = 500 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 4 ] = 100 ;
	
	// Выхлопная труба
	market_info [ 0 ] [ m_item_model ] [ 5 ] = 1018 ;
	market_info [ 0 ] [ m_item_count ] [ 5 ] = 500 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 5 ] = 100 ;
	
	// Элемент крыши
	market_info [ 0 ] [ m_item_model ] [ 6 ] = 1038 ;
	market_info [ 0 ] [ m_item_count ] [ 6 ] = 500 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 6 ] = 100 ;
	
	// Бампер
	market_info [ 0 ] [ m_item_model ] [ 7 ] = 1140 ;
	market_info [ 0 ] [ m_item_count ] [ 7 ] = 500 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 7 ] = 100 ;
	
	// Задний бампер
	market_info [ 0 ] [ m_item_model ] [ 8 ] = 1165 ;
	market_info [ 0 ] [ m_item_count ] [ 8 ] = 500 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 8 ] = 100 ;
	
	// Фрагмент ключа
	market_info [ 0 ] [ m_item_model ] [ 9 ] = 19773 ;
	market_info [ 0 ] [ m_item_count ] [ 9 ] = 50 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 9 ] = 1000 ;
	
	// Ключ от тюрьмы
	market_info [ 0 ] [ m_item_model ] [ 10 ] = 11746 ;
	market_info [ 0 ] [ m_item_count ] [ 10 ] = 10 ;
	market_info [ 0 ] [ m_item_price_ft ] [ 10 ] = 5000 ;
	
	update_market_label ( 0 ) ;
	
	CreateActor ( 269, market_actor_position [ 0 ], market_actor_position [ 1 ], market_actor_position [ 2 ], market_actor_position [ 3 ] ) ;
	CreateDynamic3DTextLabel ( "** Продавец **\n{"#cGR3D"}Подойдите для взаимодействия", col_blue, market_actor_position [ 0 ], market_actor_position [ 1 ], market_actor_position [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;
	return 1 ;
}

stock show_open_market ( playerid, bool: status = true )
{
	new _m_id ;
	if ( status )
	{
		_m_id = area_info [ used_area [ playerid ] ] [ a_item ] ;
		if ( _m_id < 0 || _m_id > MAX_MARKET ) return 1 ;
		if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 7 )
		{
			send_check_cinfo ( playerid, "Рынок не доступен администрации.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		player_market [ playerid ] = _m_id ;
	}
	else _m_id = player_market [ playerid ] ;
	
	new bool: _default = market_info [ _m_id ] [ m_default ] ;
	if ( _default && market_info [ _m_id ] [ m_renter_id ] == INVALID_PLAYER_ID )
	{
		if ( player_market_rent [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже арендуете лавку.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			{"#cBL"}** Аренда лавки **\n\n\
			{"#cWH"}Номер лавки: {"#cOR"}№%d\n\
			{"#cWH"}Стоимость аренды: {"#cGN"}%s"valute_title_"", _m_id + 1, GetPlayerCashValueToSmile ( MARKET_PRICE_RENT ) ) ;
		show_dialog ( playerid, d_market_rent, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Аренда лавки", global_string, "Арендовать", "Отмена" ) ;
		return 1 ;
	}
	
	if ( market_info [ _m_id ] [ m_renter_id ] == playerid )
	{
		marketShow ( playerid, "Ваша лавка" ) ;
		marketInvAddItem ( playerid, 1, "шт." ) ;
		marketAddItem ( playerid, 1, "шт." ) ;
		
		player_market_type { playerid } = 1 ;
	}
	else
	{
		marketShow ( playerid, market_info [ _m_id ] [ m_name ] ) ;
		marketInvAddItem ( playerid, 1, "шт." ) ;
		marketAddItem ( playerid, 1, "шт." ) ;
		
		player_market_type { playerid } = 1 ;
	}
            
	toggle_controlable ( playerid, false ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

stock market_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_market_rent:
		{
			if ( ! response ) return 1 ;
			
			new _m_id = player_market [ playerid ] ;
			for ( new i = 0 ; i < MAX_MARKET_ITEM ; i ++ )
			{
				market_info [ _m_id ] [ m_item_model ] [ i ] =
				market_info [ _m_id ] [ m_item_price ] [ i ] =
				market_info [ _m_id ] [ m_item_price_ft ] [ i ] =
				market_info [ _m_id ] [ m_item_price_ec ] [ i ] =
				market_info [ _m_id ] [ m_item_price_ac ] [ i ] = 0 ;
			}
			market_info [ _m_id ] [ m_renter_id ] = playerid ;
			
			marketShow ( playerid, "Ваша лавка" ) ;
			marketInvAddItem ( playerid, 1, "шт." ) ;
			marketAddItem ( playerid, 1, "шт." ) ;
			player_market_type { playerid } = 1 ;
			player_market_rent [ playerid ] = _m_id ;
			
			update_market_label ( _m_id ) ;
			return 1 ;
		}
		case d_market_buy:
		{
			if ( ! response ) return 1 ;
			
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _targetid = market_info [ _m_id ] [ m_renter_id ] ;
			if ( _targetid == INVALID_PLAYER_ID )
			{
				send_check_cinfo ( playerid, "У лавки нет владельца.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( market_info [ _m_id ] [ m_item_count ] [ _id ] < 1 )
			{
				send_check_cinfo ( playerid, "В лавке нет выбранного предмета.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			new _price = market_info [ _m_id ] [ m_item_price ] [ _id ], _price_ft = market_info [ _m_id ] [ m_item_price_ft ] [ _id ], _price_ec = market_info [ _m_id ] [ m_item_price_ec ] [ _id ], _price_ac = market_info [ _m_id ] [ m_item_price_ac ] [ _id ] ;
			if ( _price < 0 || _price > p_info [ playerid ] [ money ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ft < 0 || _price_ft > p_info [ playerid ] [ family_ticket ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "family_title".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ec < 0 || _price_ec > gPlayerBattlePassCoins [ playerid ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "event_coins".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ac < 0 || _price_ac > admin_info [ playerid ] [ coins ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно Admin Coins.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price > 0 )
			{
				give_money ( playerid, -_price ) ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_money ( _targetid, _price ) ;
			}
			
			if ( _price_ft > 0 )
			{
				p_info [ playerid ] [ family_ticket ] -= _price_ft ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
				{
					p_info [ _targetid ] [ family_ticket ] += _price_ft ;
					update_int_sql ( _targetid, "u_family_ticket", p_info [ _targetid ] [ family_ticket ] ) ;
				}
			}
			
			if ( _price_ec > 0 )
			{
				gPlayerBattlePassCoins [ playerid ] -= _price_ec ;
				update_int_sql ( playerid, "u_ecoins", gPlayerBattlePassCoins [ playerid ] ) ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 )
				{
					gPlayerBattlePassCoins [ _targetid ] += _price_ec ;
					update_int_sql ( _targetid, "u_ecoins", gPlayerBattlePassCoins [ _targetid ] ) ;
				}
			}
			
			if ( _price_ac > 0 )
			{
				admin_info [ playerid ] [ coins ] -= _price_ac ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) admin_info [ _targetid ] [ coins ] += _price_ac ;
			}
			
			give_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_model ] [ _id ], 1 ) ;
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) clear_player_item_prise ( _targetid, market_info [ _m_id ] [ m_item_model ] [ _id ], 1 ) ;
			
			market_info [ _m_id ] [ m_item_count ] [ _id ] -= 1 ;
			if ( market_info [ _m_id ] [ m_item_count ] [ _id ] < 1 )
			{
				market_info [ _m_id ] [ m_item_count ] [ _id ] =
				market_info [ _m_id ] [ m_item_model ] [ _id ] =
				market_info [ _m_id ] [ m_item_price ] [ _id ] =
				market_info [ _m_id ] [ m_item_price_ft ] [ _id ] =
				market_info [ _m_id ] [ m_item_price_ec ] [ _id ] = 0 ;
			}
			
			marketInvAddItem ( playerid, 1, "шт." ) ;
			marketUpdateItem ( playerid, _id, 1, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 1 ) ;
			
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), 1, p_info [ _targetid ] [ name ],
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ _targetid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), 1, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			else
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у актёра (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), 1,
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "Актёр продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), 1, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			return 1 ;
		}
		case d_market_buy_count:
		{
			if ( ! response ) return 1 ;
			
			new _count = strval ( inputtext ), _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _targetid = market_info [ _m_id ] [ m_renter_id ] ;
			if ( _targetid == INVALID_PLAYER_ID )
			{
				send_check_cinfo ( playerid, "У лавки нет владельца.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _count < 1 || _count > market_info [ _m_id ] [ m_item_count ] [ _id ] )
			{
				send_check_cinfo ( playerid, "В лавке нет выбранного предмета.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			new _price = market_info [ _m_id ] [ m_item_price ] [ _id ] * _count, _price_ft = market_info [ _m_id ] [ m_item_price_ft ] [ _id ] * _count, _price_ec = market_info [ _m_id ] [ m_item_price_ec ] [ _id ] * _count, _price_ac = market_info [ _m_id ] [ m_item_price_ac ] [ _id ] * _count ;
			if ( _price < 0 || _price > p_info [ playerid ] [ money ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ft < 0 || _price_ft > p_info [ playerid ] [ family_ticket ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "family_title".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ec < 0 || _price_ec > gPlayerBattlePassCoins [ playerid ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "event_coins".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ac < 0 || _price_ac > admin_info [ playerid ] [ coins ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно Admin Coins.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price > 0 )
			{
				give_money ( playerid, -_price ) ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_money ( _targetid, _price ) ;
			}
			
			if ( _price_ft > 0 )
			{
				p_info [ playerid ] [ family_ticket ] -= _price_ft ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 )
				{
					p_info [ _targetid ] [ family_ticket ] += _price_ft ;
					update_int_sql ( _targetid, "u_family_ticket", p_info [ _targetid ] [ family_ticket ] ) ;
				}
			}
			
			if ( _price_ec > 0 )
			{
				gPlayerBattlePassCoins [ playerid ] -= _price_ec ;
				update_int_sql ( playerid, "u_ecoins", gPlayerBattlePassCoins [ playerid ] ) ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
				{
					gPlayerBattlePassCoins [ _targetid ] += _price_ec ;
					update_int_sql ( _targetid, "u_ecoins", gPlayerBattlePassCoins [ _targetid ] ) ;
				}
			}
			
			if ( _price_ac > 0 )
			{
				admin_info [ playerid ] [ coins ] -= _price_ac ;
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) admin_info [ _targetid ] [ coins ] += _price_ac ;
			}
			
			give_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_model ] [ _id ], _count ) ;
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) clear_player_item_prise ( _targetid, market_info [ _m_id ] [ m_item_model ] [ _id ], _count ) ;
			
			market_info [ _m_id ] [ m_item_count ] [ _id ] -= _count ;
			if ( market_info [ _m_id ] [ m_item_count ] [ _id ] < 1 )
			{
				market_info [ _m_id ] [ m_item_count ] [ _id ] =
				market_info [ _m_id ] [ m_item_model ] [ _id ] =
				market_info [ _m_id ] [ m_item_price ] [ _id ] =
				market_info [ _m_id ] [ m_item_price_ft ] [ _id ] =
				market_info [ _m_id ] [ m_item_price_ec ] [ _id ] = 0 ;
			}
			
			marketInvAddItem ( playerid, 1, "шт." ) ;
			marketUpdateItem ( playerid, _id, 1, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 1 ) ;
			
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), _count, p_info [ _targetid ] [ name ],
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ _targetid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), _count, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			else
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у актёра (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), _count,
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "Актёр продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				item_name ( market_info [ _m_id ] [ m_item_model ] [ _id ] ), _count, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_price ] [ _id ], market_info [ _m_id ] [ m_item_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			return 1 ;
		}
		case d_market_sell:
		{
			if ( ! response ) return 1 ;
			
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], 
				_targetid = market_info [ _m_id ] [ m_renter_id ], 
				_inv_slot = get_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ) ;
			if ( _inv_slot < 1 )
			{
				send_check_cinfo ( playerid, "У Вас нет выбранного предмета.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			new _price = market_info [ _m_id ] [ m_item_buy_price ] [ _id ], _price_ft = market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], _price_ec = market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ;
			if ( _targetid == INVALID_PLAYER_ID )
			{
				send_check_cinfo ( playerid, "У лавки нет владельца.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _targetid != MARKET_ACTOR_1 && _price > p_info [ _targetid ] [ money ] )
			{
				send_check_cinfo ( playerid, "У скупщика недостаточно средств.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ft < 0 || _targetid != MARKET_ACTOR_1 && _price_ft > p_info [ _targetid ] [ family_ticket ] )
			{
				send_check_cinfo ( playerid, "У скупщика недостаточно "family_title".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ec < 0 || _targetid != MARKET_ACTOR_1 && _price_ec > gPlayerBattlePassCoins [ _targetid ] )
			{
				send_check_cinfo ( playerid, "У скупщика недостаточно "event_coins".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price > 0 )
			{
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_money ( _targetid, -_price ) ;
				give_money ( playerid, _price ) ;
			}
			
			if ( _price_ft > 0 )
			{
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
				{
					p_info [ _targetid ] [ family_ticket ] -= _price_ft ;
					update_int_sql ( _targetid, "u_family_ticket", p_info [ _targetid ] [ family_ticket ] ) ;
				}
				p_info [ playerid ] [ family_ticket ] += _price_ft ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;
			}
			
			if ( _price_ec > 0 )
			{
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
				{
					gPlayerBattlePassCoins [ _targetid ] -= _price_ec ;
					update_int_sql ( _targetid, "u_ecoins", gPlayerBattlePassCoins [ _targetid ] ) ;
				}
				gPlayerBattlePassCoins [ playerid ] += _price_ec ;
				update_int_sql ( playerid, "u_ecoins", gPlayerBattlePassCoins [ playerid ] ) ;
			}
			
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_player_item_prise ( _targetid, market_info [ _m_id ] [ m_item_buy_model ] [ _id ], 1 ) ;
			clear_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_buy_model ] [ _id ], 1 ) ;
			
			market_info [ _m_id ] [ m_item_buy_count ] [ _id ] -= 1 ;
			if ( market_info [ _m_id ] [ m_item_buy_count ] [ _id ] < 1 )
			{
				market_info [ _m_id ] [ m_item_buy_count ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_model ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] = 0 ;
			}
			
			marketInvAddItem ( playerid, 1, "шт." ) ;
			marketUpdateItem ( playerid, _id, 2, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 2 ) ;
			
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), 1, p_info [ _targetid ] [ name ],
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ _targetid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), 1, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			else
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) актёру (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), 1,
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "Актёр купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), 1, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			return 1 ;
		}
		case d_market_sell_count:
		{
			if ( ! response ) return 1 ;
			
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], 
				_targetid = market_info [ _m_id ] [ m_renter_id ], 
				_inv_slot = get_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ),
				_count = strval ( inputtext ) ;
			if ( _inv_slot < 1 || _count > market_info [ _m_id ] [ m_item_buy_count ] [ _id ] )
			{
				send_check_cinfo ( playerid, "У Вас нет выбранного предмета.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( _count < 1 || _count > _inv_slot )
			{
				send_check_cinfo ( playerid, "Неверное количество. Укажите не больше, чем у Вас есть.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			new _price = market_info [ _m_id ] [ m_item_buy_price ] [ _id ] * _count, _price_ft = market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ] * _count, _price_ec = market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] * _count ;
			if ( _targetid == INVALID_PLAYER_ID )
			{
				send_check_cinfo ( playerid, "У лавки нет владельца.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _targetid != MARKET_ACTOR_1 && _price > p_info [ _targetid ] [ money ] )
			{
				send_check_cinfo ( playerid, "У скупщика недостаточно средств.", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ft < 0 || _targetid != MARKET_ACTOR_1 && _price_ft > p_info [ _targetid ] [ family_ticket ] )
			{
				send_check_cinfo ( playerid, "У скупщика недостаточно "family_title".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price_ec < 0 || _targetid != MARKET_ACTOR_1 && _price_ec > gPlayerBattlePassCoins [ _targetid ] )
			{
				send_check_cinfo ( playerid, "У скупщика недостаточно "event_coins".", 0, 300, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _price > 0 )
			{
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_money ( _targetid, -_price ) ;
				give_money ( playerid, _price ) ;
			}
			
			if ( _price_ft > 0 )
			{
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
				{
					p_info [ _targetid ] [ family_ticket ] -= _price_ft ;
					update_int_sql ( _targetid, "u_family_ticket", p_info [ _targetid ] [ family_ticket ] ) ;
				}
				p_info [ playerid ] [ family_ticket ] += _price_ft ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;
			}
			
			if ( _price_ec > 0 )
			{
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 )
				{
					gPlayerBattlePassCoins [ _targetid ] -= _price_ec ;
					update_int_sql ( _targetid, "u_ecoins", gPlayerBattlePassCoins [ _targetid ] ) ;
				}
				gPlayerBattlePassCoins [ playerid ] += _price_ec ;
				update_int_sql ( playerid, "u_ecoins", gPlayerBattlePassCoins [ playerid ] ) ;
			}
			
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_player_item_prise ( _targetid, market_info [ _m_id ] [ m_item_buy_model ] [ _id ], _count ) ;
			clear_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_buy_model ] [ _id ], _count ) ;
			
			market_info [ _m_id ] [ m_item_buy_count ] [ _id ] -= _count ;
			if ( market_info [ _m_id ] [ m_item_buy_count ] [ _id ] < 1 )
			{
				market_info [ _m_id ] [ m_item_buy_count ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_model ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] = 0 ;
			}
			
			marketInvAddItem ( playerid, 1, "шт." ) ;
			marketUpdateItem ( playerid, _id, 2, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 2 ) ;
			
			if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), _count, p_info [ _targetid ] [ name ],
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ _targetid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), _count, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			else
			{
				new sql_string [ 256 ] ;
				format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) актёру (%d$, %d "family_title_abb", %d "event_coins_letter")",
				p_info [ playerid ] [ name ], item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), _count,
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "Актёр купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
				item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _id ] ), _count, p_info [ playerid ] [ name ],
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ], market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
			}
			return 1 ;
		}
		case d_market_edit:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				show_dialog ( playerid, d_market_edit_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cWH"}Укажите "valute_title_", за которую хотите продать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				show_dialog ( playerid, d_market_edit_price_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cWH"}Укажите "family_title", за которую хотите продать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 2 )
			{
				show_dialog ( playerid, d_market_edit_price_ec, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cWH"}Укажите "event_coins", за которую хотите продать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 3 )
			{
				show_dialog ( playerid, d_market_edit_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка количества", "{"#cWH"}Укажите количество, которое хотите продать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 4 )
			{
				new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ] ;
				market_info [ _m_id ] [ m_item_count ] [ _id ] =
				market_info [ _m_id ] [ m_item_model ] [ _id ] =
				market_info [ _m_id ] [ m_item_price ] [ _id ] =
				market_info [ _m_id ] [ m_item_price_ft ] [ _id ] =
				market_info [ _m_id ] [ m_item_price_ec ] [ _id ] = 0 ;
			
				marketUpdateItem ( playerid, _id, 1, "шт." ) ;
				update_player_market ( playerid, _m_id, _id, 1 ) ;
			}
			else if ( listitem == 5 )
			{
				new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ] ;
				market_info [ _m_id ] [ m_item_model ] [ _id ] = p_info [ playerid ] [ prise_slot ] [ _id ] ;
			
				marketUpdateItem ( playerid, _id, 1, "шт." ) ;
				update_player_market ( playerid, _m_id, _id, 1 ) ;
			}
			return 1 ;
		}
		case d_market_edit_price:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1"valute_title_" и более 1.800.000"valute_title_"\n{"#cWH"}Укажите "valute_title_", за которую хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_price ] [ _id ] = _price ;
			show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 1, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 1 ) ;
			return 1 ;
		}
		case d_market_edit_price_ft:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_price_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1 "family_title" и более 1.800.000 "family_title"\n{"#cWH"}Укажите "family_title", за которую хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_price_ft ] [ _id ] = _price ;
			show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 1, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 1 ) ;
			return 1 ;
		}
		case d_market_edit_price_ec:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_price_ec, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1 "event_coins" и более 1.800.000 "event_coins"\n{"#cWH"}Укажите "event_coins", за которую хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_price_ec ] [ _id ] = _price ;
			show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 1, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 1 ) ;
			return 1 ;
		}
		case d_market_edit_count:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _count = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _count < 1 || _count > p_info [ playerid ] [ prise_slot_count ] [ _id ] )
			{
				show_dialog ( playerid, d_market_edit_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка количества", "{"#cRD"}* У Вас нет такого количества!\n{"#cWH"}Укажите количество, которое хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_count ] [ _id ] = _count ;
			show_market_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 1, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 1 ) ;
			return 1 ;
		}
		case d_market_edit_buy:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				show_dialog ( playerid, d_market_edit_buy_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cWH"}Укажите "valute_title_", за которую хотите скупать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				show_dialog ( playerid, d_market_edit_buy_price_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cWH"}Укажите "family_title", за которую хотите скупать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 2 )
			{
				show_dialog ( playerid, d_market_edit_buy_price_ec, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cWH"}Укажите "event_coins", за которую хотите скупать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 3 )
			{
				show_dialog ( playerid, d_market_edit_buy_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка количества", "{"#cWH"}Укажите количество, которое хотите скупать:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 4 )
			{
				new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ] ;
				market_info [ _m_id ] [ m_item_buy_count ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_model ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ] =
				market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] = 0 ;
			
				marketUpdateItem ( playerid, _id, 2, "шт." ) ;
				update_player_market ( playerid, _m_id, _id, 2 ) ;
			}
			else if ( listitem == 5 )
			{
				new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ] ;
				market_info [ _m_id ] [ m_item_buy_model ] [ _id ] = market_buy_item [ _id ] ;
			
				marketUpdateItem ( playerid, _id, 2, "шт." ) ;
				update_player_market ( playerid, _m_id, _id, 2 ) ;
			}
			return 1 ;
		}
		case d_market_edit_buy_price:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_buy_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1"valute_title_" и более 1.800.000"valute_title_"\n{"#cWH"}Укажите "valute_title_", за которую хотите скупать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_buy_price ] [ _id ] = _price ;
			show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 2, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 2 ) ;
			return 1 ;
		}
		case d_market_edit_buy_price_ft:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_buy_price_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1 "family_title" и более 1.800.000 "family_title"\n{"#cWH"}Укажите "family_title", за которую хотите скупать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ] = _price ;
			show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 2, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 2 ) ;
			return 1 ;
		}
		case d_market_edit_buy_price_ec:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_buy_price_ec, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1 "event_coins" и более 1.800.000 "event_coins"\n{"#cWH"}Укажите "event_coins", за которую хотите скупать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] = _price ;
			show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 2, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 2 ) ;
			return 1 ;
		}
		case d_market_edit_buy_count:
		{
			new _id = get_player_use_listitem ( playerid ), _m_id = player_market [ playerid ], _count = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
				return 1 ;
			}
			
			if ( _count < 1 || _count > 1000 )
			{
				show_dialog ( playerid, d_market_edit_buy_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка количества", "{"#cRD"}* Количество должно быть от 1 до 1.000!\n{"#cWH"}Укажите количество, которое хотите скупать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			market_info [ _m_id ] [ m_item_buy_count ] [ _id ] = _count ;
			show_market_buy_item ( playerid, _id, player_market_bool [ playerid ] ) ;
			
			marketUpdateItem ( playerid, _id, 2, "шт." ) ;
			update_player_market ( playerid, _m_id, _id, 2 ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock show_packet_market ( playerid, _param1, _param2, _param3 )
{
	new _m_id = player_market [ playerid ] ;
	if ( _m_id < 0 || _m_id > MAX_MARKET ) return 1 ;
	
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			marketHide ( playerid ) ;
            
			toggle_controlable ( playerid, true ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			
			if ( _m_id != 8 ) send_check_cinfo ( playerid, market_info [ _m_id ] [ m_name ], 1, -1, CINFO_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_SWAP, "Открыть", "" ) ;
		}
		else if ( _param2 == 1 )
		{
			if ( market_info [ _m_id ] [ m_renter_id ] == playerid ) marketInvAddItem ( playerid, 2, "шт." ) ;
			else marketInvAddItem ( playerid, 1, "шт." ) ;
			marketAddItem ( playerid, 2, "шт." ) ;
			player_market_type { playerid } = 2 ;
		}
		else if ( _param2 == 2 )
		{
			marketInvAddItem ( playerid, 1, "шт." ) ;
			marketAddItem ( playerid, 1, "шт." ) ;
			player_market_type { playerid } = 1 ;
		}
	}
	else if ( _param1 == 1 )
	{
		if ( market_info [ _m_id ] [ m_renter_id ] == playerid )
		{
			if ( player_market_type { playerid } == 1 ) show_market_item ( playerid, _param3, true ) ;
			else if ( player_market_type { playerid } == 2 ) show_market_buy_item ( playerid, _param3, true ) ;
			player_market_bool [ playerid ] = true ;
			set_player_use_listitem ( playerid, _param3 ) ;
		}
		else
		{
			new _type = player_market_type { playerid } ;
			if ( _type == 1 )
			{
				new line_string [ 144 ] ;
				if ( market_info [ _m_id ] [ m_item_price ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s"valute_title_"{"#cWH"}\n", GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price ] [ _param3 ] ) ) ;
				if ( market_info [ _m_id ] [ m_item_price_ft ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "%s{"#cGRDialog"}- {"#cWH"}%s "family_title_abb"{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price_ft ] [ _param3 ] ) ) ;
				if ( market_info [ _m_id ] [ m_item_price_ec ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "%s{"#cGRDialog"}- {"#cWH"}%s "event_coins_letter"{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price_ec ] [ _param3 ] ) ) ;
				if ( market_info [ _m_id ] [ m_item_price_ac ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "%s{"#cGRDialog"}- {"#cWH"}%s AC{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price_ac ] [ _param3 ] ) ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, sizeof global_string, "\
					{"#cWH"}Предмет: {"#cOR"}%s\n\
					{"#cWH"}В продаже: {"#cOR"}%d шт.\n\n\
					{"#cBL"}** Цена за 1 шт. **\n\n\
					%s\n\
					%s\n\n\
					{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
					{"#cGRDialog"}* %s",
				item_name ( market_info [ _m_id ] [ m_item_model ] [ _param3 ] ), market_info [ _m_id ] [ m_item_count ] [ _param3 ], line_string,
				item_description ( market_info [ _m_id ] [ m_item_model ] [ _param3 ] ), get_model_count ( market_info [ _m_id ] [ m_item_model ] [ _param3 ] ),
				( market_info [ _m_id ] [ m_item_count ] [ _param3 ] > 1 ) ? ( "Введите количество, которое хотите купить:" ) : ( "Вы действительно хотите приобрести предмет?" ) ) ;
				if ( market_info [ _m_id ] [ m_item_count ] [ _param3 ] > 1 ) show_dialog ( playerid, d_market_buy_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Покупка предмета", global_string, "Купить", "Отмена" ) ;
				else show_dialog ( playerid, d_market_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка предмета", global_string, "Купить", "Отмена" ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
			}
			else if ( _type == 2 )
			{
				new line_string [ 144 ] ;
				if ( market_info [ _m_id ] [ m_item_buy_price ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s"valute_title_"{"#cWH"}\n", GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price ] [ _param3 ] ) ) ;
				if ( market_info [ _m_id ] [ m_item_buy_price_ft ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s "family_title_abb"{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price_ft ] [ _param3 ] ) ) ;
				if ( market_info [ _m_id ] [ m_item_buy_price_ec ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s "event_coins_letter"{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price_ec ] [ _param3 ] ) ) ;
				if ( market_info [ _m_id ] [ m_item_buy_price_ac ] [ _param3 ] > 0 ) format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s AC{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price_ac ] [ _param3 ] ) ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, sizeof global_string, "\
					{"#cWH"}Предмет: {"#cOR"}%s\n\
					{"#cWH"}Скупает: {"#cOR"}%d шт.\n\
					{"#cWH"}У Вас в наличии: {"#cOR"}%d шт.\n\n\
					{"#cBL"}** Цена за 1 шт. **\n\n\
					%s\n\
					%s\n\n\
					{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
					{"#cGRDialog"}* %s",
				item_name ( market_info [ _m_id ] [ m_item_buy_model ] [ _param3 ] ), market_info [ _m_id ] [ m_item_buy_count ] [ _param3 ],
				get_player_item_prise ( playerid, market_info [ _m_id ] [ m_item_buy_model ] [ _param3 ] ), line_string,
				item_description ( market_info [ _m_id ] [ m_item_model ] [ _param3 ] ), get_model_count ( market_info [ _m_id ] [ m_item_model ] [ _param3 ] ),
				( market_info [ _m_id ] [ m_item_buy_count ] [ _param3 ] > 1 ) ? ( "Введите количество, которое хотите продать:" ) : ( "Вы действительно хотите продать предмет?" ) ) ;
				if ( market_info [ _m_id ] [ m_item_buy_count ] [ _param3 ] > 1 ) show_dialog ( playerid, d_market_sell_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предмета", global_string, "Купить", "Отмена" ) ;
				else show_dialog ( playerid, d_market_sell, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Продажа предмета", global_string, "Продать", "Отмена" ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
			}
		}
	}
	else if ( _param1 == 2 )
	{
		if ( market_info [ _m_id ] [ m_renter_id ] == playerid )
		{
			if ( player_market_type { playerid } == 1 ) show_market_item ( playerid, _param3, false ) ;
			else if ( player_market_type { playerid } == 2 ) show_market_buy_item ( playerid, _param3, false ) ;
			player_market_bool [ playerid ] = false ;
			set_player_use_listitem ( playerid, _param3 ) ;
		}
	}
	return 1 ;
}

stock show_market_item ( playerid, _id, bool: status )
{
	new _m_id = player_market [ playerid ] ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "\
		{"#cBL"}№. Тип:\t{"#cBL"}Цена:\n\
		{"#cBL"}1. {"#cWH"}Цена {"#cGN"}"valute_title_"{"#cWH"}\t{"#cGN"}%s"valute_title_"{"#cWH"} за 1 шт.\n\
		{"#cBL"}2. {"#cWH"}Цена {"#cGN"}"family_title"{"#cWH"}\t{"#cGN"}%s"family_title_abb"{"#cWH"} за 1 шт.\n\
		{"#cBL"}3. {"#cWH"}Цена {"#cGN"}"event_coins"{"#cWH"}\t{"#cGN"}%s"event_coins_letter"{"#cWH"} за 1 шт.\n\
		{"#cBL"}4. {"#cWH"}Количество\t{"#cOR"}%d шт.{"#cWH"}\n\
		{"#cBL"}4. {"#cWH"}Убрать с продажи\t \n\
		{"#cBL"}5. {"#cWH"}%s\t \n\
		{"#cBL"}6. {"#cWH"}Название\t{"#cOR"}%s",
	GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price ] [ _id ] ),
	GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price_ft ] [ _id ] ),
	GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_price_ec ] [ _id ] ),
	market_info [ _m_id ] [ m_item_count ] [ _id ],
	( status ) ? ( "Выставить на продажу" ) : ( "Обновить параметры" ),
	item_name ( p_info [ playerid ] [ prise_slot ] [ _id ] ) ) ;
	show_dialog ( playerid, d_market_edit, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Настройка", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_market_buy_item ( playerid, _id, bool: status )
{
	new _m_id = player_market [ playerid ] ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "\
		{"#cBL"}№. Тип:\t{"#cBL"}Цена:\n\
		{"#cBL"}1. {"#cWH"}Цена {"#cGN"}"valute_title_"{"#cWH"}\t{"#cGN"}%s"valute_title_"{"#cWH"} за 1 шт.\n\
		{"#cBL"}2. {"#cWH"}Цена {"#cGN"}"family_title"{"#cWH"}\t{"#cGN"}%s"family_title_abb"{"#cWH"} за 1 шт.\n\
		{"#cBL"}3. {"#cWH"}Цена {"#cGN"}"event_coins"{"#cWH"}\t{"#cGN"}%s"event_coins_letter"{"#cWH"} за 1 шт.\n\
		{"#cBL"}4. {"#cWH"}Количество\t{"#cOR"}%d шт.{"#cWH"}\n\
		{"#cBL"}4. {"#cWH"}Убрать со скупки\t \n\
		{"#cBL"}5. {"#cWH"}%s\t \n\
		{"#cBL"}6. {"#cWH"}Название\t{"#cOR"}%s",
	GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price ] [ _id ] ),
	GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price_ft ] [ _id ] ),
	GetPlayerCashValueToSmile ( market_info [ _m_id ] [ m_item_buy_price_ec ] [ _id ] ),
	market_info [ _m_id ] [ m_item_buy_count ] [ _id ],
	( status ) ? ( "Начать скупать" ) : ( "Обновить параметры" ),
	item_name ( market_buy_item [ _id ] ) ) ;
	show_dialog ( playerid, d_market_edit_buy, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Настройка", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock checkInventoryMarket ( playerid, _slot )
{
	new _m_id = player_market_rent [ playerid ] ;
	if ( _m_id >= 0 && _m_id < MAX_MARKET )
	{
		if ( market_info [ _m_id ] [ m_renter_id ] == playerid )
		{
			if ( market_info [ _m_id ] [ m_item_model ] [ _slot ] > 0 ) return 1 ;
			return 0 ;
		}
	}
	return 0 ;
}

stock update_player_market ( playerid, _m_id, _slot, _type )
{
	foreach(new i: streamed_players[playerid])
	{
		if ( player_market [ i ] != _m_id ) continue ;
		if ( player_market_type { i } != _type ) continue ;
		
		if ( _slot == -1 ) show_packet_market ( i, 0, 0, 0 ) ;
		else marketUpdateItem ( i, _slot, _type, "шт." ) ;
	}
	return 1 ;
}