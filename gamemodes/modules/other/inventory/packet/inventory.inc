stock SetInventoryCache ( playerid )
{
	#if defined debug_packet
		printf ( "[SetInventoryCache] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Array ( ), itemsLoaded = 0, modelId ;
	for ( new i = 0, Node: invNode ; i < MAX_INVENTORY_SLOTS ; i ++ )
	{
		modelId = GetUsersInventory ( playerid, INV_ITEM, i ) ;
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
					"count",			JSON_Int ( 0 ),
					"region",			JSON_String ( "" ),
					"plate",			JSON_String ( "" ),
					"plateType",		JSON_Int ( 0 )
				)
			) ;
			node = JSON_Append ( node, invNode ) ;
		}
		else
		{
			if ( modelId == ITEM_SIM_CARD )
			{
				new _str [ 64 ] ;
				format ( _str, sizeof _str, "%s\t%d", item_name ( modelId ), GetUsersInventory ( playerid, INV_ITEM_GIVE_DATE, i ) ) ;

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
						"name",				JSON_String ( _str ),
						"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, i ) ),
						"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, i ) ),
						"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, i ) ),
						"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, i ) )
					)
				) ;
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
						"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, i ) ),
						"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, i ) ),
						"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, i ) ),
						"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, i ) )
					)
				) ;
			}
			node = JSON_Append ( node, invNode ) ;
		}

		if ( ++ itemsLoaded == 5 || i == MAX_INVENTORY_SLOTS - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendCacheData ( playerid, 0, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
}

stock SetInventoryCacheItem ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetInventoryCacheItem] playerid: %d", playerid ) ;
	#endif

	new Node: node, modelId = GetUsersInventory ( playerid, INV_ITEM, slotId ) ;
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
			"count",			JSON_Int ( 0 ),
			"region",			JSON_String ( "" ),
			"plate",			JSON_String ( "" ),
			"plateType",		JSON_Int ( 0 )
		) ;
	}
	else
	{
		if ( modelId == ITEM_SIM_CARD )
		{
			new _str [ 64 ] ;
			format ( _str, sizeof _str, "%s\t%d", item_name ( modelId ), GetUsersInventory ( playerid, INV_ITEM_GIVE_DATE, slotId ) ) ;

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
				"name",				JSON_String ( _str ),
				"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
				"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, slotId ) ),
				"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
				"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendCacheData ( playerid, 2, global_string ) ;
			return 1 ;
		}
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
			"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
			"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, slotId ) ),
			"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
			"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendCacheData ( playerid, 2, global_string ) ;
	return 1 ;
}

stock SetInventoryCacheAcs ( playerid )
{
	#if defined debug_packet
		printf ( "[SetInventoryCacheAcs] playerid: %d", playerid ) ;
	#endif

	new Node:node = JSON_Array ( ), modelId, itemsLoaded = 0 ;
	for ( new i = 0, Node: accNode ; i < MAX_ACCESORIES ; i ++ )
	{
		modelId = GetUserAccessories ( playerid, ACS_MODEL, i ) ;
		if ( modelId < 1 )
		{
			accNode = JSON_Array (
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
			node = JSON_Append ( node, accNode ) ;
		}
		else
		{
			if ( modelId == ITEM_SIM_CARD )
			{
				new _str [ 64 ] ;
				format ( _str, sizeof _str, "%s\t%d", item_name ( modelId ), GetUserAccessories ( playerid, ACS_COUNT, i ) ) ;

				accNode = JSON_Array (
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
						"name",				JSON_String ( _str ),
						"count",			JSON_Int ( 1 )
					)
				) ;
			}
			else
			{
				accNode = JSON_Array (
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
						"count",			JSON_Int ( 1 )
					)
				) ;
			}
			node = JSON_Append ( node, accNode ) ;
		}

		if ( ++ itemsLoaded == 5 || i == MAX_ACCESORIES - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendCacheData ( playerid, 1, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
}

stock SetInventoryCacheAcsItem ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetInventoryCacheAcsItem] playerid: %d", playerid ) ;
	#endif

	new Node: node, modelId = GetUserAccessories ( playerid, ACS_MODEL, slotId ) ;
	if ( modelId == 0 )
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
		if ( modelId == ITEM_SIM_CARD )
		{
			new _str [ 64 ] ;
			format ( _str, sizeof _str, "%s\t%d", item_name ( modelId ), GetUserAccessories ( playerid, ACS_COUNT, slotId ) ) ;

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
				"name",				JSON_String ( _str ),
				"count",			JSON_Int ( 1 )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendCacheData ( playerid, 3, global_string ) ;
			return 1 ;
		}
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
			"count",			JSON_Int ( 1 )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendCacheData ( playerid, 3, global_string ) ;
	return 1 ;
}
































stock SetInventoryItem ( playerid )
{
	#if defined debug_packet
		printf ( "[SetInventoryItem] playerid: %d", playerid ) ;
	#endif

	onServerSendData ( playerid, UI_INVENTORY, 0, "" ) ;
}

stock SetInventoryItemID ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetInventoryItemID] playerid: %d", playerid ) ;
	#endif

	new Node: node, _id = GetUsersInventory ( playerid, INV_ITEM, slotId ) ;
	if ( _id < 1 )
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
			"count",			JSON_Int ( 0 ),
			"region",			JSON_String ( "" ),
			"plate",			JSON_String ( "" ),
			"plateType",		JSON_Int ( 0 )
		) ;
	}
	else
	{
		if ( _id == ITEM_SIM_CARD )
		{
			new _str [ 64 ] ;
			format ( _str, sizeof _str, "%s\t%d", item_name ( _id ), GetUsersInventory ( playerid, INV_ITEM_GIVE_DATE, slotId ) ) ;

			node = JSON_Object (
				"position",         JSON_Int ( slotId ),
				"type",         	JSON_Int ( item_render_type ( _id ) ),
				"model",  			JSON_Int ( item_object_id ( _id ) ),
				"color1",  			JSON_Int ( item_color ( _id, 1 ) ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( _str ),
				"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
				"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, slotId ) ),
				"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
				"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_INVENTORY, 3, global_string ) ;
			return 1 ;
		}
		node = JSON_Object (
			"position",         JSON_Int ( slotId ),
			"type",         	JSON_Int ( item_render_type ( _id ) ),
			"model",  			JSON_Int ( item_object_id ( _id ) ),
			"color1",  			JSON_Int ( item_color ( _id, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( _id ) ),
			"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
			"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, slotId ) ),
			"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
			"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_INVENTORY, 3, global_string ) ;
	return 1 ;
}

stock SetInventoryAcs ( playerid )
{
	onServerSendData ( playerid, UI_INVENTORY, 1, "" ) ;
}

stock SetInventoryAcsID ( playerid, slotId )
{
	#if defined debug_packet
		printf ( "[SetInventoryAcsID] playerid: %d", playerid ) ;
	#endif

	new Node: node, _id = GetUserAccessories ( playerid, ACS_MODEL, slotId ) ;
	if ( _id == 0 )
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
		if ( _id == ITEM_SIM_CARD )
		{
			new _str [ 64 ] ;
			format ( _str, sizeof _str, "%s\t%d", item_name ( _id ), GetUserAccessories ( playerid, ACS_COUNT, slotId ) ) ;

			node = JSON_Object (
				"position",         JSON_Int ( slotId ),
				"type",         	JSON_Int ( item_render_type ( _id ) ),
				"model",  			JSON_Int ( item_object_id ( _id ) ),
				"color1",  			JSON_Int ( item_color ( _id, 1 ) ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( _str ),
				"count",			JSON_Int ( 1 )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_INVENTORY, 4, global_string ) ;
			return 1 ;
		}
		node = JSON_Object (
			"position",         JSON_Int ( slotId ),
			"type",         	JSON_Int ( item_render_type ( _id ) ),
			"model",  			JSON_Int ( item_object_id ( _id ) ),
			"color1",  			JSON_Int ( item_color ( _id, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( _id ) ),
			"count",			JSON_Int ( 1 )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_INVENTORY, 4, global_string ) ;
	return 1 ;
}

stock setInventoryWarehouse ( playerid, inventoryType, _id )
{
	#if defined debug_packet
		printf ( "[setInventoryWarehouse] playerid: %d", playerid ) ;
	#endif

	new maxItems ;
	if ( inventoryType == SUB_INV_VEHICLE ) maxItems = getTrunkCapacity ( _id ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) maxItems = MAX_WAREHOUSE_SLOT ;
	else if ( inventoryType == SUB_INV_FAMILY ) maxItems = MAX_FAMILY_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_FRACTION ) maxItems = MAX_FRACTION_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) maxItems = MAX_MARKET_PLACE_ITEMS ;

	new Node: node = JSON_Array ( ), modelId, modelCount, itemsLoaded = 0, giveDate ;
	for ( new i = 0, Node: invNode ; i < maxItems ; i ++ )
	{
		if ( inventoryType == SUB_INV_VEHICLE )
		{
			modelId = GetVehicleInventory ( _id, INV_ITEM, i ) ;
			modelCount = GetVehicleInventory ( _id, INV_ITEM_COUNT, i ) ;
			giveDate = GetVehicleInventory ( _id, INV_ITEM_GIVE_DATE, i ) ;
		}
		else if ( inventoryType == SUB_INV_HOUSE )
		{
			modelId = GetHouseInventory ( _id, INV_ITEM, i ) ;
			modelCount = GetHouseInventory ( _id, INV_ITEM_COUNT, i ) ;
			giveDate = GetHouseInventory ( _id, INV_ITEM_GIVE_DATE, i ) ;
		}
		else if ( inventoryType == SUB_INV_FAMILY )
		{
			modelId = GetFamilyInventory ( _id, INV_ITEM, i ) ;
			modelCount = GetFamilyInventory ( _id, INV_ITEM_COUNT, i ) ;
			giveDate = GetFamilyInventory ( _id, INV_ITEM_GIVE_DATE, i ) ;
		}
		else if ( inventoryType == SUB_INV_FRACTION )
		{
			modelId = GetFractionInventory ( _id, INV_ITEM, i ) ;
			modelCount = GetFractionInventory ( _id, INV_ITEM_COUNT, i ) ;
			giveDate = GetFractionInventory ( _id, INV_ITEM_GIVE_DATE, i ) ;
		}
		else if ( inventoryType == SUB_INV_MARKET_PLACE )
		{
			modelId = GetMarketPlaceInventory ( playerid, INV_ITEM, i ) ;
			modelCount = GetMarketPlaceInventory ( playerid, INV_ITEM_COUNT, i ) ;
			giveDate = GetMarketPlaceInventory ( playerid, INV_ITEM_GIVE_DATE, i ) ;
		}

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
			
			if ( modelId == ITEM_SIM_CARD )
			{
				new _str [ 64 ] ;
				format ( _str, sizeof _str, "%s\t%d", item_name ( modelId ), giveDate ) ;

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
						"name",				JSON_String ( _str ),
						"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, i ) ),
						"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, i ) ),
						"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, i ) ),
						"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, i ) )
					)
				) ;
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
						"count",			JSON_Int ( modelCount )
					)
				) ;
			}
			node = JSON_Append ( node, invNode ) ;
		}

		if ( ++ itemsLoaded == 5 || i == maxItems - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_INVENTORY, 7, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
}

stock SetWarehouseItemID ( playerid, inventoryType, _id, slotId )
{
	#if defined debug_packet
		printf ( "[SetWarehouseItemID] playerid: %d", playerid ) ;
	#endif

	new Node: node, modelId, modelCount, giveDate ;
	if ( inventoryType == SUB_INV_VEHICLE )
	{
		modelId = GetVehicleInventory ( _id, INV_ITEM, slotId ) ;
		modelCount = GetVehicleInventory ( _id, INV_ITEM_COUNT, slotId ) ;
		giveDate = GetVehicleInventory ( _id, INV_ITEM_GIVE_DATE, slotId ) ;
	}
	else if ( inventoryType == SUB_INV_HOUSE )
	{
		modelId = GetHouseInventory ( _id, INV_ITEM, slotId ) ;
		modelCount = GetHouseInventory ( _id, INV_ITEM_COUNT, slotId ) ;
		giveDate = GetHouseInventory ( _id, INV_ITEM_GIVE_DATE, slotId ) ;
	}
	else if ( inventoryType == SUB_INV_FAMILY )
	{
		modelId = GetFamilyInventory ( _id, INV_ITEM, slotId ) ;
		modelCount = GetFamilyInventory ( _id, INV_ITEM_COUNT, slotId ) ;
		giveDate = GetFamilyInventory ( _id, INV_ITEM_GIVE_DATE, slotId ) ;
	}
	else if ( inventoryType == SUB_INV_FRACTION )
	{
		modelId = GetFractionInventory ( _id, INV_ITEM, slotId ) ;
		modelCount = GetFractionInventory ( _id, INV_ITEM_COUNT, slotId ) ;
		giveDate = GetFractionInventory ( _id, INV_ITEM_GIVE_DATE, slotId ) ;
	}
	else if ( inventoryType == SUB_INV_MARKET_PLACE )
	{
		modelId = GetMarketPlaceInventory ( playerid, INV_ITEM, slotId ) ;
		modelCount = GetMarketPlaceInventory ( playerid, INV_ITEM_COUNT, slotId ) ;
		giveDate = GetMarketPlaceInventory ( playerid, INV_ITEM_GIVE_DATE, slotId ) ;
	}

	if ( modelId < 1 )
	{
		node = JSON_Object (
			"position",			JSON_Int ( slotId ),
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
		if ( _id == ITEM_SIM_CARD )
		{
			new _str [ 64 ] ;
			format ( _str, sizeof _str, "%s\t%d", item_name ( _id ), giveDate ) ;

			node = JSON_Object (
				"position",         JSON_Int ( slotId ),
				"type",         	JSON_Int ( item_render_type ( _id ) ),
				"model",  			JSON_Int ( item_object_id ( _id ) ),
				"color1",  			JSON_Int ( item_color ( _id, 1 ) ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 ),
				"name",				JSON_String ( _str ),
				"count",			JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_COUNT, slotId ) ),
				"region",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_REGION, slotId ) ),
				"plate",			JSON_String ( GetUsersInventory ( playerid, INV_ITEM_PLATE, slotId ) ),
				"plateType",		JSON_Int ( GetUsersInventory ( playerid, INV_ITEM_PLATE_TYPE, slotId ) )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_INVENTORY, 3, global_string ) ;
			return 1 ;
		}
		node = JSON_Object (
			"position",         JSON_Int ( slotId ),
			"type",         	JSON_Int ( item_render_type ( modelId ) ),
			"model",  			JSON_Int ( item_object_id ( modelId ) ),
			"color1",  			JSON_Int ( item_color ( _id, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( modelId ) ),
			"count",			JSON_Int ( modelCount )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_INVENTORY, 8, global_string ) ;
	return 1 ;
}

stock SetGuardsInfo ( playerid )
{
	new Node: node = JSON_Array ( ) ;
	for ( new idx = 0 ; idx < MAX_GUARDS ; idx ++ )
	{
		new Node: json = JSON_Array ( ) ;
		JSON_Parse ( SetGuardsInv ( playerid, idx ), json ) ;

		node = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( 0 ),
				"guardName",	JSON_String ( GetGuardInfo ( playerid, GUARD_NAME, idx ) ),
				"level",		JSON_Int ( GetGuardInfo ( playerid, GUARD_LEVEL, idx ) ),
				"skinId",		JSON_Int ( GetGuardInfo ( playerid, GUARD_SKIN, idx ) ),
				"color1",  		JSON_Int ( 1 ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 ),
				"guardItems",	json
			)
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_INVENTORY, 18, global_string ) ;
	}
	return true ;
}

stock SetGuardsInv ( playerid, guardNum )
{
	new Node: node = JSON_Array ( ), modelId ;
	for ( new idx = 0, Node: invNode ; idx < MAX_GUARDS_SLOT ; idx ++ )
	{
		modelId = GetGuardInventory ( playerid, guardNum, INV_ITEM, idx ) ;
		if ( modelId < 1 )
		{
			invNode = JSON_Array (
				JSON_Object (
					"position",         JSON_Int ( idx ),
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
		}
		else
		{
			if ( modelId == ITEM_SIM_CARD )
			{
				new _str [ 64 ] ;
				format ( _str, sizeof _str, "%s\t%d", item_name ( modelId ), GetGuardInventory ( playerid, guardNum, INV_ITEM_GIVE_DATE, idx ) ) ;

				invNode = JSON_Array (
					JSON_Object (
						"position",         JSON_Int ( idx ),
						"type",         	JSON_Int ( item_render_type ( modelId ) ),
						"model",  			JSON_Int ( item_object_id ( modelId ) ),
						"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
						"color2",      		JSON_Int ( 1 ),
						"rotX",				JSON_Float ( 20.0 ),
						"rotY",				JSON_Float ( 180.0 ),
						"rotZ",				JSON_Float ( 45.0 ),
						"zoom",				JSON_Float ( 0.78 ),
						"name",				JSON_String ( _str ),
						"count",			JSON_Int ( GetGuardInventory ( playerid, guardNum, INV_ITEM_COUNT, idx ) ),
						"region",			JSON_String ( GetGuardInventory ( playerid, guardNum, INV_ITEM_REGION, idx ) ),
						"plate",			JSON_String ( GetGuardInventory ( playerid, guardNum, INV_ITEM_PLATE, idx ) ),
						"plateType",		JSON_Int ( GetGuardInventory ( playerid, guardNum, INV_ITEM_PLATE_TYPE, idx ) )
					)
				) ;
			}
			else
			{
				invNode = JSON_Array (
					JSON_Object (
						"position",         JSON_Int ( idx ),
						"type",         	JSON_Int ( item_render_type ( modelId ) ),
						"model",  			JSON_Int ( item_object_id ( modelId ) ),
						"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
						"color2",      		JSON_Int ( 1 ),
						"rotX",				JSON_Float ( 20.0 ),
						"rotY",				JSON_Float ( 180.0 ),
						"rotZ",				JSON_Float ( 45.0 ),
						"zoom",				JSON_Float ( 0.78 ),
						"name",				JSON_String ( item_name ( modelId ) ),
						"count",			JSON_Int ( GetGuardInventory ( playerid, guardNum, INV_ITEM_COUNT, idx ) )
					)
				) ;
			}
		}
		node = JSON_Append ( node, invNode ) ;
	}
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	return global_string ;
}

stock setCharacterInfo ( playerid )
{
	#if defined debug_packet
		printf ( "[setCharacterInfo] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Object (
		"satiety", JSON_Int ( p_info [ playerid ] [ hunger ] ),
		"playerName", JSON_String ( p_info [ playerid ] [ name ] ),
		"level", JSON_Int ( p_info [ playerid ] [ level ] ),
		"skinId", JSON_Int ( getNewSkinModel ( playerid ) ),
		"color1", JSON_Int ( 1 ),
		"color2", JSON_Int ( 1 ),
		"rotX", JSON_Float ( 20.0 ),
		"rotY", JSON_Float ( 180.0 ),
		"rotZ", JSON_Float ( 45.0 ),
		"zoom", JSON_Float ( 0.78 )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_INVENTORY, 2, global_string ) ;
}

stock setInventoryLayout ( playerid, idx )
{
	#if defined debug_packet
		printf ( "[setInventoryLayout] playerid: %d", playerid ) ;
	#endif

	if ( idx == 0 ) onServerSendData ( playerid, UI_INVENTORY, 5, "0" ) ;
	else if ( idx == 2 ) onServerSendData ( playerid, UI_INVENTORY, 5, "2" ) ;
	else onServerSendData ( playerid, UI_INVENTORY, 5, "1" ) ;
}

stock setWarehouseInfo ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ] )
{
	#if defined debug_packet
		printf ( "[setWarehouseInfo] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Object (
		"header", JSON_String ( _str ),
		"desc", JSON_String ( _str2 ),
		"name", JSON_String ( _str3 ),
		"subName", JSON_String ( _str4 ),
		"nameName", JSON_String ( _str5 ),
		"nameSubName", JSON_String ( _str6 )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_INVENTORY, 6, global_string ) ;
}