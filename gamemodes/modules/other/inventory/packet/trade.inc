stock SetTradeItem ( playerid )
{
	#if defined debug_packet
		printf ( "[SetTradeItem] playerid: %d", playerid ) ;
	#endif

	onServerSendData ( playerid, UI_TRADE, 0, global_string ) ;
}

stock SetTradePlayerItemID ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetTradePlayerItemID] playerid: %d", playerid ) ;
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
		);
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
	onServerSendData ( playerid, UI_TRADE, 3, global_string ) ;
}

stock SetTradeItemID ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetTradeItemID] playerid: %d", playerid ) ;
	#endif

	new Node: node, modelId = GetTradeInventory ( playerid, INV_ITEM, slotId ) ;
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
			"count",			JSON_Int ( GetTradeInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
			"region",			JSON_String ( GetTradeInventory ( playerid, INV_ITEM_REGION, slotId ) ),
			"plate",			JSON_String ( GetTradeInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
			"plateType",		JSON_Int ( GetTradeInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TRADE, 14, global_string ) ;
}

stock SetReceiverItemID ( playerid, targetid, slotId )
{
	#if defined debug_packet
		printf ( "[SetReceiverItemID] playerid: %d", playerid ) ;
	#endif

	new Node: node, modelId = GetTradeInventory ( playerid, INV_ITEM, slotId ) ;
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
			"count",			JSON_Int ( GetTradeInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
			"region",			JSON_String ( GetTradeInventory ( playerid, INV_ITEM_REGION, slotId ) ),
			"plate",			JSON_String ( GetTradeInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
			"plateType",		JSON_Int ( GetTradeInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( targetid, UI_TRADE, 16, global_string ) ;
}

stock tradeInventoryInsert ( playerid )
{
	new Node: node = JSON_Array ( ), itemsLoaded = 0 ;
	for ( new i = 0, Node: tradeNode ; i < MAX_TRADE_SLOTS ; i ++ )
	{
		tradeNode = JSON_Array (
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

		node = JSON_Append ( node, tradeNode ) ;

		if ( ++ itemsLoaded >= 5 || i == MAX_TRADE_SLOTS - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TRADE, 13, global_string ) ;
			onServerSendData ( playerid, UI_TRADE, 15, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}
	return 1 ;
}