enum
{
	WORKSHOP_UPGRADE,
	WORKSHOP_REPAIR,
	WORKSHOP_RESOURCES
} ;

new playerWorkShopType [ MAX_PLAYERS char ] ;

stock showWorkShop ( playerid )
{
	workShopColorFillter ( playerid, WORKSHOP_UPGRADE, 0, 0 ) ;
	workShopLeftItem ( playerid, -1, -1 ) ;
	workShopMainItem ( playerid, -1, -1 ) ;
	workShopRightItem ( playerid, -1, -1 ) ;
	toggle_controlable ( playerid, false ) ;

	playerWorkShopType { playerid } = WORKSHOP_UPGRADE ;
	return true ;
}

stock packetWorkShop ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new moveFromIndex, moveToIndex, moveFromInventoryType, moveToInventoryType ;
		JSON_GetInt ( json, "moveFromIndex", moveFromIndex ) ;
		JSON_GetInt ( json, "moveToIndex", moveToIndex ) ;
		JSON_GetInt ( json, "moveFromInventoryType", moveFromInventoryType ) ;
		JSON_GetInt ( json, "moveToInventoryType", moveToInventoryType ) ;

		if ( moveToInventoryType == 1 ) // Center item
		{
			new modelId = GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ),
				nextLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, moveFromIndex ) ;

			if ( GetModelStatsMax ( modelId ) < 1 )
			{
				send_check_cinfo ( playerid, "Этот предмет нельзя заточить!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

			workShopLeftItem ( playerid, modelId, nextLevel ) ;
			workShopMainItem ( playerid, modelId, nextLevel ) ;
			workShopRightItem ( playerid, modelId, nextLevel ) ;
			workShopChance ( playerid, modelId, nextLevel ) ;
			workShopCost ( playerid ) ;
			workShopColorFillter ( playerid, WORKSHOP_RESOURCES, modelId, nextLevel ) ;

			set_player_use_listitem ( playerid, moveFromIndex ) ;
		}
	}
	else if ( actionId == 1 )
	{
		workShopLeftItem ( playerid, -1, -1 ) ;
		workShopMainItem ( playerid, -1, -1 ) ;
		workShopRightItem ( playerid, -1, -1 ) ;
	}
	else if ( actionId == 2 ) // left item info
	{
		new idx = get_player_use_listitem ( playerid ),
			modelId = GetUsersInventory ( playerid, INV_ITEM, idx ),
			nextLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, idx ),
			itemRes = GetModelStatsRes ( modelId, nextLevel, 1 ),
			headerString [ 64 ] ;

		format ( headerString, sizeof headerString, "{"#cBHD"}Предмет: {"#cWH"}%s", item_name ( itemRes ) ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, headerString, item_description ( itemRes ), "Закрыть", "" ) ;
	}
	else if ( actionId == 3 ) // center item info
	{
		new idx = strval ( data ) ;
		GetInventoryItemNextLevel ( playerid, idx ) ;
	}
	else if ( actionId == 4 ) // right item info
	{
		new idx = get_player_use_listitem ( playerid ),
			modelId = GetUsersInventory ( playerid, INV_ITEM, idx ),
			nextLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, idx ),
			itemRes = GetModelStatsRes ( modelId, nextLevel, 0 ),
			headerString [ 64 ] ;

		format ( headerString, sizeof headerString, "{"#cBHD"}Предмет: {"#cWH"}%s", item_name ( itemRes ) ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, headerString, item_description ( itemRes ), "Закрыть", "" ) ;
	}
	else if ( actionId == 5 ) // click upgrade
	{
		new idx = get_player_use_listitem ( playerid ),
			modelId = GetUsersInventory ( playerid, INV_ITEM, idx ),
			nextLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, idx ),
			itemRes_1, itemResCount_1, itemRes_2, itemResCount_2,
			_b_id = GetPVarInt ( playerid, "p_biz_id" ),
			wsPrice = b_price_market [ _b_id - 1 ] [ playerWorkShopType { playerid } ] ;

		if ( p_info [ playerid ] [ money ] < wsPrice )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return true ;
		}
			
		give_bmoney ( _b_id, wsPrice, 0 ) ;
		give_money ( playerid, -wsPrice ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -wsPrice, "услуги заточки" ) ;

		if ( playerWorkShopType { playerid } == WORKSHOP_UPGRADE )
		{
			itemRes_1 = GetModelStatsRes ( modelId, nextLevel, 0 ) ;
			itemResCount_1 = GetModelStatsResCount ( modelId, nextLevel, 0 ) ;
			itemRes_2 = GetModelStatsRes ( modelId, nextLevel, 1 ) ;
			itemResCount_2 = GetModelStatsResCount ( modelId, nextLevel, 1 ) ;

			if ( nextLevel >= GetModelStatsMax ( modelId ) )
			{
				send_check_cinfo ( playerid, "У Вас максимальный уровень предмета!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}
		}
		else if ( playerWorkShopType { playerid } == WORKSHOP_REPAIR )
		{
			itemRes_1 = GetModelRepairRes ( modelId, 0 ) ;
			itemResCount_1 = GetModelRepairResCount ( modelId, 0 ) ;
			itemRes_2 = GetModelRepairRes ( modelId, 1 ) ;
			itemResCount_2 = GetModelRepairResCount ( modelId, 1 ) ;

			if ( GetUsersInventory ( playerid, INV_ITEM_WEAR, idx ) >= 100 )
			{
				send_check_cinfo ( playerid, "Предмет не нуждается в ремонте!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}
		}

		if ( itemRes_1 != -1 )
		{
			if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, itemRes_1 ) < itemResCount_1 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "У Вас не хватает \"%s\"!", item_name ( itemRes_1 ) ) ;
				send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

			clear_inventory ( playerid, itemRes_1, itemResCount_1 ) ;
		}

		if ( itemRes_2 != -1 )
		{
			if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, itemRes_2 ) < itemResCount_2 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "У Вас не хватает \"%s\"!", item_name ( itemRes_2 ) ) ;
				send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

			clear_inventory ( playerid, itemRes_2, itemResCount_2 ) ;
		}

		onServerSendData ( playerid, UI_WORKSHOP, 7, "" ) ;
	}
	else if ( actionId == 6 ) // end to upgrade timer
	{
		new idx = get_player_use_listitem ( playerid ),
			modelId = GetUsersInventory ( playerid, INV_ITEM, idx ),
			nextLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, idx ),
			randomEx = random ( 100 ) ;

		if ( playerWorkShopType { playerid } == WORKSHOP_UPGRADE )
		{
			if ( randomEx < GetModelStatsChance ( modelId, nextLevel ) )
			{
				static const _str [ ] = "UPDATE users_accessories_stats SET acs_level = acs_level + 1 WHERE id = %d LIMIT 1" ;
				new query_string [ sizeof _str + 9 ] ;
				format ( query_string, sizeof query_string, _str, GetUsersInventory ( playerid, INV_ITEM_ID, idx ) ) ;
				mysql_tquery ( sql_connection, query_string ) ;

				GetUsersInventory ( playerid, INV_ITEM_LEVEL, idx ) += 1 ;
				nextLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, idx ) ;
				send_check_cinfo ( playerid, "Вы успешно заточили предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			}
			else
			{
				send_check_cinfo ( playerid, "У Вас не получилось заточить предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
		}
		else if ( playerWorkShopType { playerid } == WORKSHOP_REPAIR )
		{
			static const _str [ ] = "UPDATE users_accessories_stats SET acs_wear = 100 WHERE id = %d LIMIT 1" ;
			new query_string [ sizeof _str + 9 ] ;
			format ( query_string, sizeof query_string, _str, GetUsersInventory ( playerid, INV_ITEM_ID, idx ) ) ;
			mysql_tquery ( sql_connection, query_string ) ;

			GetUsersInventory ( playerid, INV_ITEM_WEAR, idx ) = 100 ;
			send_check_cinfo ( playerid, "Вы успешно восстановили предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		}

		workShopLeftItem ( playerid, modelId, nextLevel ) ;
		workShopMainItem ( playerid, modelId, nextLevel ) ;
		workShopRightItem ( playerid, modelId, nextLevel ) ;
		workShopChance ( playerid, modelId, nextLevel ) ;
		workShopCost ( playerid ) ;
		workShopColorFillter ( playerid, WORKSHOP_RESOURCES, modelId, nextLevel ) ;
	}
	else if ( actionId == 7 ) // category select
	{
		playerWorkShopType { playerid } = strval ( data ) ;
		workShopColorFillter ( playerid, strval ( data ), 0, 0 ) ;
		workShopLeftItem ( playerid, -1, -1 ) ;
		workShopMainItem ( playerid, -1, -1 ) ;
		workShopRightItem ( playerid, -1, -1 ) ;
	}
	return true ;
}

stock workShopChance ( playerid, modelId, modelLevel )
{
	new Node: node = JSON_Object (
		"name",				JSON_String ( "ШАНС" ),
		"count",			JSON_Int ( GetModelStatsChance ( modelId, modelLevel ) ),
		"icon",				JSON_Int ( 0 )
	) ;
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WORKSHOP, 5, global_string ) ;
}

stock workShopCost ( playerid )
{
	new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
	new Node: node = JSON_Object (
		"name",				JSON_String ( "СТОИМОСТЬ" ),
		"count",			JSON_Int ( b_price_market [ _b_id - 1 ] [ playerWorkShopType { playerid } ] ),
		"icon",				JSON_Int ( 1 )
	) ;
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WORKSHOP, 6, global_string ) ;
}

stock workShopLeftItem ( playerid, modelId, nextLevel )
{
	new Node: node ;
	if ( modelId == -1 )
	{
		node = JSON_Object (
			"position",			JSON_Int ( -1 ),
			"type",         	JSON_Int ( item_render_type ( modelId ) ),
			"model",  			JSON_Int ( item_object_id ( modelId ) ),
			"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( modelId ) ),
			"count",			JSON_Int ( 0 ),
			"needCount",		JSON_Int ( 0 )
		) ;
	}
	else
	{
		new itemRes, itemResCount ;
		if ( playerWorkShopType { playerid } == WORKSHOP_UPGRADE )
		{
			itemRes = GetModelStatsRes ( modelId, nextLevel, 1 ) ;
			itemResCount = GetModelStatsResCount ( modelId, nextLevel, 1 ) ;
		}
		else if ( playerWorkShopType { playerid } == WORKSHOP_REPAIR )
		{
			itemRes = GetModelRepairRes ( modelId, 1 ) ;
			itemResCount = GetModelRepairResCount ( modelId, 1 ) ;
		}
		node = JSON_Object (
			"position",			JSON_Int ( -1 ),
			"type",         	JSON_Int ( item_render_type ( itemRes ) ),
			"model",  			JSON_Int ( item_object_id ( itemRes ) ),
			"color1",  			JSON_Int ( item_color ( itemRes, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( itemRes ) ),
			"count",			JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, itemRes ) ),
			"needCount",		JSON_Int ( itemResCount )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WORKSHOP, 2, global_string ) ;
	return true ;
}

stock workShopMainItem ( playerid, modelId, nextLevel )
{
	new Node: node ;
	if ( modelId == -1 )
	{
		node = JSON_Object (
			"position",			JSON_Int ( -1 ),
			"type",         	JSON_Int ( item_render_type ( modelId ) ),
			"model",  			JSON_Int ( item_object_id ( modelId ) ),
			"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( modelId ) ),
			"count",			JSON_Int ( 0 ),
			"needCount",		JSON_Int ( 0 )
		) ;
	}
	else
	{
		new moveLevel ;
		if ( nextLevel >= GetModelStatsMax ( modelId ) ) moveLevel = nextLevel ;
		else moveLevel = nextLevel + 1 ;
		node = JSON_Object (
			"position",			JSON_Int ( -1 ),
			"type",         	JSON_Int ( item_render_type ( modelId ) ),
			"model",  			JSON_Int ( item_object_id ( modelId ) ),
			"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( modelId ) ),
			"count",			JSON_Int ( nextLevel ),
			"needCount",		JSON_Int ( moveLevel )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WORKSHOP, 3, global_string ) ;
	return true ;
}

stock workShopRightItem ( playerid, modelId, nextLevel )
{
	new Node: node ;
	if ( modelId == -1 )
	{
		node = JSON_Object (
			"position",			JSON_Int ( -1 ),
			"type",         	JSON_Int ( item_render_type ( modelId ) ),
			"model",  			JSON_Int ( item_object_id ( modelId ) ),
			"color1",  			JSON_Int ( item_color ( modelId, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( modelId ) ),
			"count",			JSON_Int ( 0 ),
			"needCount",		JSON_Int ( 0 )
		) ;
	}
	else
	{
		new itemRes, itemResCount ;
		if ( playerWorkShopType { playerid } == WORKSHOP_UPGRADE )
		{
			itemRes = GetModelStatsRes ( modelId, nextLevel, 0 ) ;
			itemResCount = GetModelStatsResCount ( modelId, nextLevel, 0 ) ;
		}
		else if ( playerWorkShopType { playerid } == WORKSHOP_REPAIR )
		{
			itemRes = GetModelRepairRes ( modelId, 0 ) ;
			itemResCount = GetModelRepairResCount ( modelId, 0 ) ;
		}
		node = JSON_Object (
			"position",			JSON_Int ( -1 ),
			"type",         	JSON_Int ( item_render_type ( itemRes ) ),
			"model",  			JSON_Int ( item_object_id ( itemRes ) ),
			"color1",  			JSON_Int ( item_color ( itemRes, 1 ) ),
			"color2",      		JSON_Int ( 1 ),
			"rotX",				JSON_Float ( 20.0 ),
			"rotY",				JSON_Float ( 180.0 ),
			"rotZ",				JSON_Float ( 45.0 ),
			"zoom",				JSON_Float ( 0.78 ),
			"name",				JSON_String ( item_name ( itemRes ) ),
			"count",			JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, itemRes ) ),
			"needCount",		JSON_Int ( itemResCount )
		) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WORKSHOP, 4, global_string ) ;
	return true ;
}

stock workShopColorFillter ( playerid, typeSend, modelId, nextLevel )
{
	new Node: node = JSON_Array ( ), itemRes_1, itemRes_2 ;

	if ( playerWorkShopType { playerid } == WORKSHOP_UPGRADE )
	{
		itemRes_1 = GetModelStatsRes ( modelId, nextLevel, 0 ) ;
		itemRes_2 = GetModelStatsRes ( modelId, nextLevel, 0 ) ;
	}
	else if ( playerWorkShopType { playerid } == WORKSHOP_REPAIR )
	{
		itemRes_1 = GetModelRepairRes ( modelId, 0 ) ;
		itemRes_2 = GetModelRepairRes ( modelId, 1 ) ;
	}

	for ( new i = 0, Node: fillterNode ; i < MAX_INVENTORY_SLOTS ; i ++ )
	{
		modelId = GetUsersInventory ( playerid, INV_ITEM, i ) ;
		if ( modelId < 1 ) continue ;

		if ( typeSend == WORKSHOP_UPGRADE )
		{
			if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, i ) != INVENTORY_TYPE_ACCESSORIES ) continue ;
			if ( GetModelStatsMax ( modelId ) < 1 ) continue ;
		}
		else if ( typeSend == WORKSHOP_REPAIR )
		{
			if ( GetUsersInventory ( playerid, INV_ITEM_WEAR, i ) == -1 ) continue ;
			if ( GetUsersInventory ( playerid, INV_ITEM_WEAR, i ) >= 100 ) continue ;
		}
		else if ( typeSend == WORKSHOP_RESOURCES )
		{
			if ( modelId != itemRes_1 && modelId != itemRes_2 ) continue ;
		}

		fillterNode = JSON_Array (
			JSON_Int ( i )
		) ;
		node = JSON_Append ( node, fillterNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WORKSHOP, 0, global_string ) ;
	return true ;
}

stock packetWorkShopDestroy ( playerid )
{
	toggle_controlable ( playerid, true ) ;
	return true ;
}

stock workshop_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_shop_workshop:
		{
			if ( ! response ) return true ;

			showWorkShop ( playerid ) ;
			return true ;
		}
	}
	return false ;
}