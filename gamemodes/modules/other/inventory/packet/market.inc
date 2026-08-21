stock SetPlayerItem ( playerid )
{
	#if defined debug_packet
		printf ( "[SetPlayerItem] playerid: %d", playerid ) ;
	#endif

	onServerSendData ( playerid, UI_MARKET, 0, "" ) ;
}

stock SetPlayerItemID ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetPlayerItemID] playerid: %d", playerid ) ;
	#endif

	new Node: node, modelId = USERS_INVENTORY [ playerid ] [ slotId ] [ INV_ITEM ] ;
	if ( modelId < 1 )
	{
		node = JSON_Object (
			"position",         JSON_Int ( slotId ),
			"type",         	JSON_Int ( -1 ),
			"model",  			JSON_Int ( -1 ),
			"color1",  			JSON_Int ( 1 ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( "" ),
			"count",			JSON_Int ( 0 )
		) ;
	}
	else
	{
		node = JSON_Object (
			"position",         JSON_Int ( slotId ),
			"type",         	JSON_Int ( item_render_type ( modelId ) ),
			"model",  			JSON_Int ( item_object_id ( modelId ) ),
			"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( modelId ) ),
			"count",			JSON_Int ( USERS_INVENTORY [ playerid ] [ slotId ] [ INV_ITEM_COUNT ] ),
			"region",			JSON_String ( USERS_INVENTORY [ playerid ] [ slotId ] [ INV_ITEM_REGION ] ),
			"plate",			JSON_String ( USERS_INVENTORY [ playerid ] [ slotId ] [ INV_ITEM_PLATE ] ),
			"plateType",		JSON_Int ( USERS_INVENTORY [ playerid ] [ slotId ] [ INV_ITEM_PLATE_TYPE ] )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_MARKET, 3, global_string ) ;
}

stock SetMarketItem ( playerid, marketId, marketType )
{
	#if defined debug_packet
		printf ( "[SetMarketItem] playerid: %d", playerid ) ;
	#endif

	new Node:node = JSON_Array ( ), itemsLoaded = 0, modelId ;
	for ( new i = 0, Node:invNode ; i < MAX_MARKET_SLOTS ; i ++ )
	{
		if ( marketType == MARKET_TYPE_SELL )
		{
			modelId = GetMarketSellInventory ( marketId, INV_ITEM, i ) ;
			if ( modelId < 1 )
			{
				invNode = JSON_Array (
					JSON_Object (
						"position",         JSON_Int ( i ),
						"type",         	JSON_Int ( -1 ),
						"model",  			JSON_Int ( -1 ),
						"color1",  			JSON_Int ( 1 ),
						"color2",      		JSON_Int ( 1 ),
						"rotX",				JSON_Float ( 20.0 ),
						"rotY",				JSON_Float ( 180.0 ),
						"rotZ",				JSON_Float ( 45.0 ),
						"zoom",				JSON_Float ( 0.78 ),
						"name",				JSON_String ( "" ),
						"count",			JSON_Int ( 0 )
					)
				) ;
				node = JSON_Append ( node, invNode ) ;
			}
			else
			{
				invNode = JSON_Array (
					JSON_Object (
						"position",         JSON_Int ( i ),
						"type",         	JSON_Int ( item_render_type ( modelId ) ),
						"model",  			JSON_Int ( item_object_id ( modelId ) ),
						"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
						"color2",      		JSON_Int ( 1 ),
						"rotX",				JSON_Float ( 20.0 ),
						"rotY",				JSON_Float ( 180.0 ),
						"rotZ",				JSON_Float ( 45.0 ),
						"zoom",				JSON_Float ( 0.78 ),
						"name",				JSON_String ( item_name ( modelId ) ),
						"count",			JSON_Int ( GetMarketSellInventory ( marketId, INV_ITEM_COUNT, i ) ),
						"region",			JSON_String ( GetMarketSellInventory ( marketId, INV_ITEM_REGION, i ) ),
						"plate",			JSON_String ( GetMarketSellInventory ( marketId, INV_ITEM_PLATE, i ) ),
						"plateType",		JSON_Int ( GetMarketSellInventory ( marketId, INV_ITEM_PLATE_TYPE, i ) )
					)
				) ;
				node = JSON_Append ( node, invNode ) ;
			}
		}
		else
		{
			modelId = GetMarketBuyInventory ( marketId, INV_ITEM, i ) ;
			if ( modelId < 1 )
			{
				invNode = JSON_Array (
					JSON_Object (
						"position",         JSON_Int ( i ),
						"type",         	JSON_Int ( -1 ),
						"model",  			JSON_Int ( -1 ),
						"color1",  			JSON_Int ( 1 ),
						"color2",      		JSON_Int ( 1 ),
						"rotX",				JSON_Float ( 20.0 ),
						"rotY",				JSON_Float ( 180.0 ),
						"rotZ",				JSON_Float ( 45.0 ),
						"zoom",				JSON_Float ( 0.78 ),
						"name",				JSON_String ( "" ),
						"count",			JSON_Int ( 0 )
					)
				) ;
				node = JSON_Append ( node, invNode ) ;
			}
			else
			{
				invNode = JSON_Array (
					JSON_Object (
						"position",         JSON_Int ( i ),
						"type",         	JSON_Int ( item_render_type ( modelId ) ),
						"model",  			JSON_Int ( item_object_id ( modelId ) ),
						"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
						"color2",      		JSON_Int ( 1 ),
						"rotX",				JSON_Float ( 20.0 ),
						"rotY",				JSON_Float ( 180.0 ),
						"rotZ",				JSON_Float ( 45.0 ),
						"zoom",				JSON_Float ( 0.78 ),
						"name",				JSON_String ( item_name ( modelId ) ),
						"count",			JSON_Int ( GetMarketBuyInventory ( marketId, INV_ITEM_COUNT, i ) ),
						"region",			JSON_String ( GetMarketBuyInventory ( marketId, INV_ITEM_REGION, i ) ),
						"plate",			JSON_String ( GetMarketBuyInventory ( marketId, INV_ITEM_PLATE, i ) ),
						"plateType",		JSON_Int ( GetMarketBuyInventory ( marketId, INV_ITEM_PLATE_TYPE, i ) )
					)
				) ;
				node = JSON_Append ( node, invNode ) ;
			}
		}

		if ( ++ itemsLoaded == 5 || i == MAX_MARKET_SLOTS - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_MARKET, 7, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
}

stock marketUpdateItemID ( playerid, marketId, marketSlot )
{
	#if defined debug_packet
		printf ( "[marketUpdateItemID] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Object ( ), modelId, marketType = playerMarketType [ playerid ] ;
	if ( marketType == MARKET_TYPE_SELL )
	{
		modelId = GetMarketSellInventory ( marketId, INV_ITEM, marketSlot ) ;
		if ( modelId < 1 )
		{
			node = JSON_Object (
				"position",         JSON_Int ( marketSlot ),
				"type",         	JSON_Int ( -1 ),
				"model",  			JSON_Int ( -1 ),
				"color1",  			JSON_Int ( 1 ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( "" ),
				"count",			JSON_Int ( 0 )
			) ;
		}
		else
		{
			node = JSON_Object (
				"position",         JSON_Int ( marketSlot ),
				"type",         	JSON_Int ( item_render_type ( modelId ) ),
				"model",  			JSON_Int ( item_object_id ( modelId ) ),
				"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( item_name ( modelId ) ),
				"count",			JSON_Int ( GetMarketSellInventory ( marketId, INV_ITEM_COUNT, marketSlot ) ),
				"region",			JSON_String ( GetMarketSellInventory ( marketId, INV_ITEM_REGION, marketSlot ) ),
				"plate",			JSON_String ( GetMarketSellInventory ( marketId, INV_ITEM_PLATE, marketSlot ) ),
				"plateType",		JSON_Int ( GetMarketSellInventory ( marketId, INV_ITEM_PLATE_TYPE, marketSlot ) )
			) ;
		}
	}
	else
	{
		modelId = GetMarketBuyInventory ( marketId, INV_ITEM, marketSlot ) ;
		if ( modelId < 1 )
		{
			node = JSON_Object (
				"position",         JSON_Int ( marketSlot ),
				"type",         	JSON_Int ( -1 ),
				"model",  			JSON_Int ( -1 ),
				"color1",  			JSON_Int ( 1 ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( "" ),
				"count",			JSON_Int ( 0 )
			) ;
		}
		else
		{
			node = JSON_Object (
				"position",         JSON_Int ( marketSlot ),
				"type",         	JSON_Int ( item_render_type ( modelId ) ),
				"model",  			JSON_Int ( item_object_id ( modelId ) ),
				"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( item_name ( modelId ) ),
				"count",			JSON_Int ( GetMarketBuyInventory ( marketId, INV_ITEM_COUNT, marketSlot ) ),
				"region",			JSON_String ( GetMarketBuyInventory ( marketId, INV_ITEM_REGION, marketSlot ) ),
				"plate",			JSON_String ( GetMarketBuyInventory ( marketId, INV_ITEM_PLATE, marketSlot ) ),
				"plateType",		JSON_Int ( GetMarketBuyInventory ( marketId, INV_ITEM_PLATE_TYPE, marketSlot ) )
			) ;
		}
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_MARKET, 8, global_string ) ;
}

stock setMarketInfo ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ] )
{
	#if defined debug_packet
		printf ( "[setMarketInfo] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Object (
		"header", 				JSON_String ( _str ),
		"desc", 				JSON_String ( _str2 ),
		"name", 				JSON_String ( _str3 ),
		"subName", 				JSON_String ( _str4 ),
		"nameName", 			JSON_String ( _str5 ),
		"nameSubName", 			JSON_String ( _str6 )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_MARKET, 6, global_string ) ;
}