enum
{
	MARKET_TYPE_SELL,
	MARKET_TYPE_BUY
} ;

#define MARKET_PRICE_RENT	100000
new player_market [ MAX_PLAYERS ] = { -1, ... } ;

#define MARKET_ACTOR_1		INVALID_PLAYER_ID - 1
new Float: market_actor_position [ 4 ] = { -461.0363, 714.2191, 12.1175, 3.1067 } ;

enum _market
{
	m_renter_id,
	m_area,
	m_object,
	bool: m_default,

	Float: m_position [ 3 ],
	Text3D: m_label,
	m_name [ 32 ],
	m_type
} ;
new market_info [ MAX_MARKET ] [ _market ] ;

enum
{
	d_market_rent = 21212,
	
	d_market_edit,
	d_market_edit_price,
	d_market_edit_price_ft,
	d_market_edit_price_ec,
	d_market_edit_count
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

new playerMarketType [ MAX_PLAYERS ] = { 0, ... } ;

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
			if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре. Используйте /mm - Информация о персонаже - Статистика персонажа." ) ;
			
			new i = used_area [ playerid ] ;
			if ( i < 0 || i > MAX_MARKET ) return 1 ;
			
			send_check_cinfo ( playerid, market_info [ area_info [ i ] [ a_item ] ] [ m_name ], 1, -1, CINFO_MARKET_ID, PICTURE_INFO_SUCESS, "Открыть", "" ) ;
			return true ;
		}
	}
	return false ;
}

stock market_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_market:
		{
			player_market [ playerid ] = -1 ;
			clear_check_info ( playerid, CINFO_MARKET_ID ) ;
			return true ;
		}
	}
	return false ;
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

		for ( new i = 0 ; i < MAX_MARKET_SLOTS ; i ++ )
		{
			if ( GetMarketSellInventory ( _m_id, INV_ITEM, i ) > 0 )
			{
				new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
				inventoryStruct = TransferInventoryStructure ( _m_id, SUB_INV_MARKET_SELL, i ) ;
				giveInventory ( playerid, inventoryStruct ) ;
			}

			clear_market_slot (
				_m_id,
				GetMarketSellInventory ( _m_id, INV_ITEM, i ),
				GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, i ),
				i
			) ;

			market_update_item ( playerid, _m_id, i ) ;
		}
		market_info [ _m_id ] [ m_renter_id ] = INVALID_PLAYER_ID ;

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
	
	GetMarketSellInventory ( _m_id, INV_ITEM, _slot_id ) = _model ;
	GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _slot_id ) = 1000 ;
	if ( _type_price == 0 ) GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, _slot_id ) = _price ;
	else if ( _type_price == 1 ) GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, _slot_id ) = _price ;
	else if ( _type_price == 2 ) GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, _slot_id ) = _price ;
	else if ( _type_price == 3 ) GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_AC, _slot_id ) = _price ;
	
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
		market_info [ i ] [ m_object ] = CreateDynamicObject ( 1570, market_default_position [ i ] [ 0 ], market_default_position [ i ] [ 1 ], market_default_position [ i ] [ 2 ], market_default_position [ i ] [ 3 ], market_default_position [ i ] [ 4 ], market_default_position [ i ] [ 5 ], 0, 0 ) ;
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
	GetMarketSellInventory ( 0, INV_ITEM, 0 ) = 905 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 0 ) = 50_000 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 0 ) = 2 ;
	
	// золото
	GetMarketSellInventory ( 0, INV_ITEM, 1 ) = 19941 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 1 ) = 25_000 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 1 ) = 4 ;
	
	// древесина
	GetMarketSellInventory ( 0, INV_ITEM, 2 ) = 1463 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 2 ) = 50_000 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 2 ) = 8 ;
	
	// хлопок
	GetMarketSellInventory ( 0, INV_ITEM, 3 ) = 2684 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 3 ) = 25_000 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 3 ) = 10 ;
	
	// Колесо
	GetMarketSellInventory ( 0, INV_ITEM, 4 ) = 1080 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 4 ) = 500 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 4 ) = 100 ;
	
	// Выхлопная труба
	GetMarketSellInventory ( 0, INV_ITEM, 5 ) = 1018 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 5 ) = 500 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 5 ) = 100 ;
	
	// Элемент крыши
	GetMarketSellInventory ( 0, INV_ITEM, 6 ) = 1038 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 6 ) = 500 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 6 ) = 100 ;
	
	// Бампер
	GetMarketSellInventory ( 0, INV_ITEM, 7 ) = 1140 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 7 ) = 500 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 7 ) = 100 ;
	
	// Задний бампер
	GetMarketSellInventory ( 0, INV_ITEM, 8 ) = 1165 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 8 ) = 500 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 8 ) = 100 ;
	
	// Фрагмент ключа
	GetMarketSellInventory ( 0, INV_ITEM, 9 ) = 19773 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 9 ) = 50 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 9 ) = 1000 ;
	
	// Ключ от тюрьмы
	GetMarketSellInventory ( 0, INV_ITEM, 10 ) = 11746 ;
	GetMarketSellInventory ( 0, INV_ITEM_COUNT, 10 ) = 10 ;
	GetMarketSellInventory ( 0, INV_ITEM_PRICE_FT, 10 ) = 5000 ;
	
	update_market_label ( 0 ) ;
	
	CreateActor ( 238, market_actor_position [ 0 ], market_actor_position [ 1 ], market_actor_position [ 2 ], market_actor_position [ 3 ] ) ;
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
			send_check_cinfo ( playerid, "Рынок не доступен администрации.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return true ;
		}
		
		player_market [ playerid ] = _m_id ;
	}
	else _m_id = player_market [ playerid ] ;
	
	new bool: _default = market_info [ _m_id ] [ m_default ] ;
	if ( _default && market_info [ _m_id ] [ m_renter_id ] == INVALID_PLAYER_ID )
	{
		if ( player_market_rent [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже арендуете лавку.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return true ;
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			{"#cBL"}** Аренда лавки **\n\n\
			{"#cWH"}Номер лавки: {"#cOR"}№%d\n\
			{"#cWH"}Стоимость аренды: {"#cGN"}%s"valute_title_"", _m_id + 1, GetPlayerCashValueToSmile ( MARKET_PRICE_RENT ) ) ;
		show_dialog ( playerid, d_market_rent, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Аренда лавки", global_string, "Арендовать", "Отмена" ) ;
		return true ;
	}
	
	setMarketInfo ( 
		playerid, 
		"Лавка", 
		"Здесь хранятся предметы, которые\nвыставлены на продажу", 
		"ЛАВКА", 
		"",
		"",
		""
	) ;
	SetPlayerItem ( playerid ) ;
	SetMarketItem ( playerid, _m_id, MARKET_TYPE_SELL ) ;

	playerMarketType [ playerid ] = 0 ;
	toggle_controlable ( playerid, false ) ;
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
			for ( new i = 0 ; i < MAX_MARKET_SLOTS ; i ++ )
			{
				GetMarketSellInventory ( _m_id, INV_ITEM, i ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, i ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, i ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, i ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_AC, i ) = 

				GetMarketBuyInventory ( _m_id, INV_ITEM, i ) =
				GetMarketBuyInventory ( _m_id, INV_ITEM_PRICE, i ) =
				GetMarketBuyInventory ( _m_id, INV_ITEM_PRICE_FT, i ) =
				GetMarketBuyInventory ( _m_id, INV_ITEM_PRICE_EC, i ) =
				GetMarketBuyInventory ( _m_id, INV_ITEM_PRICE_AC, i ) = 0 ;
			}
			market_info [ _m_id ] [ m_renter_id ] = playerid ;
			
			setMarketInfo ( 
				playerid, 
				"Лавка", 
				"Здесь хранятся предметы, которые\nвыставлены на продажу", 
				"ЛАВКА", 
				"",
				"",
				""
			) ;
			SetPlayerItem ( playerid ) ;
			SetMarketItem ( playerid, _m_id, MARKET_TYPE_SELL ) ;

			playerMarketType [ playerid ] = 0 ;
			player_market_rent [ playerid ] = _m_id ;
			
			update_market_label ( _m_id ) ;
			return 1 ;
		}
		case d_market_edit:
		{
			if ( ! response )
			{
				new _id = GetPVarInt ( playerid, "market:moveToIndex" ), _m_id = player_market [ playerid ] ;
				GetMarketSellInventory ( _m_id, INV_ITEM, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, _id ) = 0 ;
			
				marketUpdateItemID ( playerid, _m_id, _id ) ;
				market_update_item ( playerid, _m_id, _id ) ;

				DeletePVar ( playerid, "market:moveToIndex" ) ;
				DeletePVar ( playerid, "inventory:moveFromIndex" ) ;
			}
			
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
				new _id = GetPVarInt ( playerid, "market:moveToIndex" ), _m_id = player_market [ playerid ] ;
				GetMarketSellInventory ( _m_id, INV_ITEM, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, _id ) =
				GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, _id ) = 0 ;
			
				marketUpdateItemID ( playerid, _m_id, _id ) ;
				market_update_item ( playerid, _m_id, _id ) ;

				DeletePVar ( playerid, "market:moveToIndex" ) ;
				DeletePVar ( playerid, "inventory:moveFromIndex" ) ;
			}
			else if ( listitem == 5 )
			{
				new _id = GetPVarInt ( playerid, "market:moveToIndex" ), 
					slotId = GetPVarInt ( playerid, "inventory:moveFromIndex" ), 
					_m_id = player_market [ playerid ] ;

				new USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;
				moveInventory = TransferInventoryStructure ( playerid, SUB_INVENTORY, slotId ) ;
				moveInventory [ _:INV_ITEM_COUNT ] = GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) ? GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) : GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ) ;
				new _return = give_market_slot ( _m_id, _id, moveInventory ) ;
				if ( _return == -1 )
				{
					send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			
				clear_inventory_slot (
					playerid,
					GetUsersInventory ( playerid, INV_ITEM, slotId ),
					GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) ? GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) : GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ),
					slotId
				) ;
				marketUpdateItemID ( playerid, _m_id, _id ) ;
				market_update_item ( playerid, _m_id, _id ) ;

				DeletePVar ( playerid, "market:moveToIndex" ) ;
				DeletePVar ( playerid, "inventory:moveFromIndex" ) ;
			}
			return 1 ;
		}
		case d_market_edit_price:
		{
			new _id = GetPVarInt ( playerid, "market:moveToIndex" ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_price, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1"valute_title_" и более 1.800.000"valute_title_"\n{"#cWH"}Укажите "valute_title_", за которую хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, _id ) = _price ;
			show_market_item ( playerid, _id ) ;
			
			marketUpdateItemID ( playerid, _m_id, _id ) ;
			market_update_item ( playerid, _m_id, _id ) ;
			return 1 ;
		}
		case d_market_edit_price_ft:
		{
			new _id = GetPVarInt ( playerid, "market:moveToIndex" ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_price_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1 "family_title" и более 1.800.000 "family_title"\n{"#cWH"}Укажите "family_title", за которую хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, _id ) = _price ;
			show_market_item ( playerid, _id ) ;
			
			marketUpdateItemID ( playerid, _m_id, _id ) ;
			market_update_item ( playerid, _m_id, _id ) ;
			return 1 ;
		}
		case d_market_edit_price_ec:
		{
			new _id = GetPVarInt ( playerid, "market:moveToIndex" ), _m_id = player_market [ playerid ], _price = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id ) ;
				return 1 ;
			}
			
			if ( _price < 0 || _price > max_money )
			{
				show_dialog ( playerid, d_market_edit_price_ec, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка цены", "{"#cRD"}* Цена не может быть менее 1 "event_coins" и более 1.800.000 "event_coins"\n{"#cWH"}Укажите "event_coins", за которую хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, _id ) = _price ;
			show_market_item ( playerid, _id ) ;
			
			marketUpdateItemID ( playerid, _m_id, _id ) ;
			market_update_item ( playerid, _m_id, _id ) ;
			return 1 ;
		}
		case d_market_edit_count:
		{
			new _id = GetPVarInt ( playerid, "market:moveToIndex" ), _m_id = player_market [ playerid ], _count = strval ( inputtext ) ;
			if ( ! response )
			{
				show_market_item ( playerid, _id ) ;
				return 1 ;
			}
			
			if ( _count < 1 || _count > USERS_INVENTORY [ playerid ] [ _id ] [ INV_ITEM_COUNT ] )
			{
				show_dialog ( playerid, d_market_edit_count, DIALOG_STYLE_INPUT, "{"#cBHD"}Настройка количества", "{"#cRD"}* У Вас нет такого количества!\n{"#cWH"}Укажите количество, которое хотите продать:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ) = _count ;
			show_market_item ( playerid, _id ) ;
			
			marketUpdateItemID ( playerid, _m_id, _id ) ;
			market_update_item ( playerid, _m_id, _id ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock show_market_item ( playerid, _id )
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
		{"#cBL"}5. {"#cWH"}Выставить на продажу\t \n\
		{"#cBL"}6. {"#cWH"}Название\t{"#cOR"}%s",
	GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, _id ) ),
	GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, _id ) ),
	GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, _id ) ),
	GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, _id ),
	item_name ( GetUsersInventory ( playerid, INV_ITEM, GetPVarInt ( playerid, "inventory:moveFromIndex" ) ) ) ) ;
	show_dialog ( playerid, d_market_edit, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Настройка", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_packet_market ( playerid, actionId, data [ ] )
{
	new _m_id = player_market [ playerid ] ;
	if ( _m_id < 0 || _m_id > MAX_MARKET )
	{
		send_check_cinfo ( playerid, "Вы не рядом с лавкой!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return false ;
	}

	if ( actionId == 0 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new moveFromIndex, moveToIndex, moveFromInventoryType, moveToInventoryType ;
		JSON_GetInt ( json, "moveFromIndex", moveFromIndex ) ;
		JSON_GetInt ( json, "moveToIndex", moveToIndex ) ;
		JSON_GetInt ( json, "moveFromInventoryType", moveFromInventoryType ) ;
		JSON_GetInt ( json, "moveToInventoryType", moveToInventoryType ) ;

		if ( moveFromInventoryType == moveToInventoryType )
		{
			switch ( moveFromInventoryType )
			{
				case 0: // инвентарь
				{
					dragged_player_inventory ( playerid, moveFromIndex, moveToIndex ) ;
				}
				case 1: // аксессуары
				{

				}
				case 2: // склад
				{
				
				}
				case 3: // trader
				{

				}
				case 4: // receiver
				{

				}
			}
		}
		else
		{
			switch ( moveToInventoryType )
			{
				case 0: // инвентарь
				{
					if ( player_market_rent [ playerid ] == player_market [ playerid ] )
					{
						dragged_market_inventory_sell ( playerid, moveFromIndex, moveToIndex, true ) ;

						marketUpdateItemID ( playerid, player_market [ playerid ], moveFromIndex ) ;
						market_update_item ( playerid, player_market [ playerid ], moveFromIndex ) ;
					}
					else send_check_cinfo ( playerid, "Используйте кнопку 'купить'!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				}
				case 1: // аксессуары
				{
					
				}
				case 2: // склад
				{
					if ( player_market_rent [ playerid ] == player_market [ playerid ] )
					{
						if ( item_blocked ( playerid, USERS_INVENTORY [ playerid ] [ moveFromIndex ] [ INV_ITEM ], 1, moveToIndex ) )
						{
							send_check_cinfo ( playerid, "Выбраный предмет нельзя продавать!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
							return 1 ;
						}

						SetPVarInt ( playerid, "inventory:moveFromIndex", moveFromIndex ) ;
						SetPVarInt ( playerid, "market:moveToIndex", moveToIndex ) ;

						show_market_item ( playerid, moveToIndex ) ;
					}
					else send_check_cinfo ( playerid, "Используйте кнопку 'купить'!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				}
				case 3: // trader
				{

				}
				case 4: // receiver
				{

				}
			}
		}
	}
	else if ( actionId == 1 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new itemIndex, itemCount, inventoryType, action, _item ;
		JSON_GetInt ( json, "itemIndex", itemIndex ) ;
		JSON_GetInt ( json, "itemCount", itemCount ) ;
		JSON_GetInt ( json, "inventoryType", inventoryType ) ;
		JSON_GetInt ( json, "action", action ) ;

		_item = USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM ] ;
		if ( inventoryType == 0 ) // инвентарь
		{
			if ( action == 0 ) // использовать
			{
				if ( GetAccessoriesItem ( USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM ] ) )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия нужно надеть аксессуар!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _item == 2250 )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия с номерами отправляйтесь в полицейский участок!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( item_blocked ( playerid, _item ) )
				{

				}
				else prise_open ( playerid, itemIndex ) ;
			}
			else if ( action == 1 ) // продать
			{
				
			}
			else if ( action == 2 ) // выкинуть
			{
				if ( item_blocked ( playerid, _item ) )
				{
					send_check_cinfo ( playerid, "Вы не можете выкинуть выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_TYPE ] == RENDER_TYPE_PLATE )
				{
					static const _str [ ] = "DELETE FROM `licence_plate` WHERE `licence_plate_char_id` = '%d' AND `id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_ID ] ) ;
					mysql_tquery ( sql_connection, query_string ) ;
				}
				
				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_ACCESSORIES )
					dropped_accessories ( GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_SKINS )
					dropped_skins ( GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;
					
				clear_inventory_slot ( playerid, USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM ], itemCount, itemIndex ) ;
			}
			else if ( action == 3 ) // разделить
			{
				if ( item_blocked ( playerid, _item ) )
				{
					send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				new _slot = GetInventoryFreeSlot ( playerid, SUB_INVENTORY ) ;
				if ( _slot == -1 )
				{
					send_check_cinfo ( playerid, "У Вас нет свободного места в инвентаре.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				clear_inventory_slot ( 
					playerid, 
					USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM ],
					itemCount,
					itemIndex
				) ;

				give_inventory_slot (
					playerid,
					USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM ],
					itemCount,
					0,
					"",
					"",
					USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_PLATE_TYPE ],
					USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_ID ],
					_slot,
					GetElapsedTime ( USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_DATE ], gettime ( ), CONVERT_TIME_TO_DAYS )
				) ;
			}
			else if ( action == 4 ) // информация
			{
				GetInventoryInfo ( playerid, SUB_INVENTORY, itemIndex ) ;
			}
		}
		else if ( inventoryType == 2 ) // остальное
		{
			if ( action == 0 ) // купить
			{
				new _targetid = market_info [ _m_id ] [ m_renter_id ] ;
				if ( _targetid == INVALID_PLAYER_ID )
				{
					send_check_cinfo ( playerid, "У лавки нет владельца.", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( playerid == _targetid )
				{
					send_check_cinfo ( playerid, "Вы не можете купить у себя.", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, itemIndex ) < itemCount )
				{
					send_check_cinfo ( playerid, "В лавке нет выбранного предмета.", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new _price = GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ) * itemCount, 
					_price_ft = GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ) * itemCount, 
					_price_ec = GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) * itemCount, 
					_price_ac = GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_AC, itemIndex ) * itemCount ;
				if ( _price < 0 || _price > p_info [ playerid ] [ money ] )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно средств.", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _price_ft < 0 || _price_ft > GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_FAMILY_TALON ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "family_title".", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _price_ec < 0 || _price_ec > gPlayerBattlePassCoins [ playerid ] )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "event_coins".", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _price_ac < 0 || _price_ac > admin_info [ playerid ] [ coins ] )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно Admin Coins.", 0, 3, CINFO_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _price > 0 )
				{
					give_money ( playerid, -_price ) ;
					if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) give_money ( _targetid, _price ) ;
				}
				
				if ( _price_ft > 0 )
				{
					clear_inventory ( playerid, 252, _price_ft ) ;
					if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
					{
						give_inventory (
							_targetid,
							ITEM_FAMILY_TALON,
							_price_ft,
							0,
							"",
							"",
							NUMBERPLATE_TYPE_NONE,
							0,
							-1
						) ;
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

				if ( GetMarketSellInventory ( _m_id, INV_ITEM_TYPE, itemIndex ) == RENDER_TYPE_PLATE )
				{
					static const _str [ ] = "UPDATE `licence_plate` SET `licence_plate_char_id` = '%d' WHERE `id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], GetMarketSellInventory ( _m_id, INV_ITEM_ID, itemIndex ) ) ;
					mysql_tquery ( sql_connection, query_string ) ;
				}
				
				new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
				inventoryStruct = TransferInventoryStructure ( _m_id, SUB_INV_MARKET_SELL, itemIndex ) ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = itemCount ;
				giveInventory ( playerid, inventoryStruct ) ;
				
				clear_market_slot (
					_m_id,
					GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ),
					itemCount,
					itemIndex
				) ;
				
				marketUpdateItemID ( playerid, _m_id, itemIndex ) ;
				market_update_item ( playerid, _m_id, itemIndex ) ;
				
				if ( market_info [ _m_id ] [ m_renter_id ] != MARKET_ACTOR_1 ) 
				{
					new sql_string [ 256 ] ;
					format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
					p_info [ playerid ] [ name ],
					item_name ( GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ) ),
					itemCount, p_info [ _targetid ] [ name ],
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ),
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) ) ;
					WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
					
					sql_string [ 0 ] = EOS ;
					format ( sql_string, sizeof sql_string, "%s продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
					p_info [ _targetid ] [ name ], 
					item_name ( GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ) ), 
					itemCount, 
					p_info [ playerid ] [ name ],
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) ) ;
					WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				}
				else
				{
					new sql_string [ 256 ] ;
					format ( sql_string, sizeof sql_string, "%s купил(а) %s (%d шт) у актёра (%d$, %d "family_title_abb", %d "event_coins_letter")",
					p_info [ playerid ] [ name ],
					item_name ( GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ) ), 
					itemCount,
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) ) ;
					WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
					
					sql_string [ 0 ] = EOS ;
					format ( sql_string, sizeof sql_string, "Актёр продал(а) %s (%d шт) у %s (%d$, %d "family_title_abb", %d "event_coins_letter")",
					item_name ( GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ) ), 
					itemCount, 
					p_info [ playerid ] [ name ],
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ), 
					GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) ) ;
					WriteLogs ( playerid, -1, TYPE_LOG_MARKET, sql_string ) ;
				}
			}
			else if ( action == 1 ) // отмена
			{
				if ( player_market_rent [ playerid ] == playerid )
				{
					clear_market_slot (
						player_market [ playerid ],
						GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ),
						GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, itemIndex ),
						itemIndex
					) ;
				
					marketUpdateItemID ( playerid, _m_id, itemIndex ) ;
					market_update_item ( playerid, _m_id, itemIndex ) ;
				}
			}
			else if ( action == 2 ) // выкинуть
			{
				send_check_cinfo ( playerid, "Если Вы хотите убрать товар с продажи, то нажмите 'отмена'.\nНельзя 'выкинуть' предмет из лавки.", 0, 3, CINFO_OTHER_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 3 ) // разделить
			{
				send_check_cinfo ( playerid, "Если Вы хотите убрать товар с продажи, то нажмите 'отмена'.\nНельзя 'разделить' предмет из лавки.", 0, 3, CINFO_OTHER_MARKET_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( action == 4 ) // информация
			{
				GetInventoryInfo ( playerid, SUB_INV_MARKET_SELL, itemIndex ) ;
			}
		}
	}
	else if ( actionId == 3 )
	{
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 5 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new itemIndex, inventoryType ;
		JSON_GetInt ( json, "itemIndex", itemIndex ) ;
		JSON_GetInt ( json, "inventoryType", inventoryType ) ;

		if ( inventoryType == 0 )
		{
			new _i_item = USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_DATE ],
				_count = USERS_INVENTORY [ playerid ] [ itemIndex ] [ INV_ITEM_COUNT ],
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
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
			item_name ( _i_item ), _count, get_model_count ( _i_item ) ) ;

			onServerSendData ( playerid, UI_MARKET, 12, global_string ) ;
		}
		else if ( inventoryType == 2 )
		{
			new _i_item = GetMarketSellInventory ( _m_id, INV_ITEM, itemIndex ), 
				_count = GetMarketSellInventory ( _m_id, INV_ITEM_COUNT, itemIndex ), 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = GetMarketSellInventory ( _m_id, INV_ITEM_DATE, itemIndex ),
				date_string [ 64 ] ;

			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "\n{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			new line_string [ 144 ] ;
			if ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ) > 0 ) 
				format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s"valute_title_"{"#cWH"}\n", GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE, itemIndex ) ) ) ;
			if ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ) > 0 ) 
				format ( line_string, sizeof line_string, "%s{"#cGRDialog"}- {"#cWH"}%s "family_title_abb"{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_FT, itemIndex ) ) ) ;
			if ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) > 0 ) 
				format ( line_string, sizeof line_string, "%s{"#cGRDialog"}- {"#cWH"}%s "event_coins_letter"{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_EC, itemIndex ) ) ) ;
			if ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_AC, itemIndex ) > 0 ) 
				format ( line_string, sizeof line_string, "%s{"#cGRDialog"}- {"#cWH"}%s AC{"#cWH"}\n", line_string, GetPlayerCashValueToSmile ( GetMarketSellInventory ( _m_id, INV_ITEM_PRICE_AC, itemIndex ) ) ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\n\
				{"#cBL"}** Цена за 1 шт. **\n\n\
				{"#cWH"}%s\n\
				{"#cWH"}%s\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
				item_name ( _i_item ), _count,
				line_string,
				date_string, get_model_count ( _i_item ) ) ;

			onServerSendData ( playerid, UI_MARKET, 12, global_string ) ;
		}
	}
	else if ( actionId == 6 )
	{
		new idx = strval ( data ) ;
		playerMarketType [ playerid ] = idx ;

		if ( idx == 0 ) // продажа
		{
			SetMarketItem ( playerid, _m_id, MARKET_TYPE_SELL ) ;
		}
		else if ( idx == 1 ) // скупка
		{
			SetMarketItem ( playerid, _m_id, MARKET_TYPE_BUY ) ;
		}
	}
	return 1 ;
}

stock initMarketItemsDialog ( playerid, pageId )
{
	page_count [ playerid ] = pageId ;

	global_string [ 0 ] = EOS ;

	return true ;
}

stock dragged_market_inventory_sell ( playerid, moveFromIndex, moveToIndex, bool: toInventory )
{
	if ( toInventory )
	{
		new _m_id = player_market [ playerid ],
			draggedItem = GetMarketSellInventory ( playerid, INV_ITEM, moveFromIndex ),
			draggedItemCount = GetMarketSellInventory ( playerid, INV_ITEM_COUNT, moveFromIndex ),
			USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;

		if ( ! draggedItem ) return false ;

		moveInventory = TransferInventoryStructure ( playerid, SUB_INV_MARKET_SELL, moveFromIndex ) ;
		new _return = giveInventorySlot ( playerid, moveInventory, moveToIndex ) ;
		if ( _return == -1 )
		{
			send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		clear_market_slot ( _m_id, draggedItem, draggedItemCount, moveFromIndex ) ;
	}
	else
	{
		new _m_id = player_market [ playerid ],
			draggedItem = GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ),
			draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, moveFromIndex ),
			USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;

		moveInventory = TransferInventoryStructure ( playerid, SUB_INVENTORY, moveFromIndex ) ;
		new _return = give_market_slot ( _m_id, moveToIndex, moveInventory ) ;
		if ( _return == -1 )
		{
			send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		clear_inventory_slot ( playerid, draggedItem, draggedItemCount, moveFromIndex ) ;
	}
	return 1 ;
}

stock clear_market_slot ( marketId, modelId, modelCount, slotId )
{
	ClearInventorySlot ( marketId, SUB_INV_MARKET_SELL, slotId, modelId, modelCount ) ;
	return 1 ;
}

stock give_market ( _m_id, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	slotId = GiveInventory ( _m_id, SUB_INV_MARKET_SELL, itemStruct ) ;
	return slotId ;
}

stock give_market_slot ( _m_id, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	GiveInventorySlot ( _m_id, slotId, SUB_INV_MARKET_SELL, itemStruct ) ;
	return slotId ;
}

stock market_update_item ( playerid, _m_id, slotId )
{
	foreach(new i: streamed_players[playerid])
	{
		if ( player_market [ i ] != _m_id ) continue ;
		
		marketUpdateItemID ( i, _m_id, slotId ) ;
	}
	return 1 ;
}