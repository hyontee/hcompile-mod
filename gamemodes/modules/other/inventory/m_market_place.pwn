stock insertMarketPlace ( userId, modelId, modelCount, modelType, modelOtherId, modelDate = -1 )
{
	static const _str [ ] = "SELECT inv_slot_id FROM users_market_place WHERE inv_id = %d LIMIT %d" ;
	new query_string [ sizeof _str + ( 9 * 2 ) ] ;
	format ( query_string, sizeof query_string, _str, userId, MAX_MARKET_PLACE_ITEMS ) ;
	mysql_tquery ( sql_connection, query_string, "checkingSlotToMarketPlace", "iiiiii", userId, modelId, modelCount, modelType, modelOtherId, modelDate ) ;
	return 1 ;
}

callback: checkingSlotToMarketPlace ( userId, modelId, modelCount, modelType, modelOtherId, modelDate )
{
	new rows, fields, slotId = 0 ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		if ( rows >= MAX_MARKET_PLACE_ITEMS ) return false ;

		new bool: freeSlotId [ MAX_MARKET_PLACE_ITEMS ] = { false, ... } ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
			freeSlotId [ cache_get_field_content_int ( i, "inv_slot_id" ) ] = true ;
		}

		for ( new i = 0 ; i < MAX_MARKET_PLACE_ITEMS ; i ++ )
		{
			if ( freeSlotId [ i ] ) continue ;

			slotId = i ;
			break ;
		}
	}

	static const _str [ ] = "\
		INSERT INTO `users_market_place` \
		(`inv_id`, `inv_item`, `inv_count`, `inv_date`, `inv_slot_id`, `inv_type`, `inv_other_id`) \
		VALUES \
		('%d', '%d', '%d', '%d', '%d', '%d', '%d')" ;
	new query_string [ sizeof _str + ( 6 * 9 ) ] ;
    format ( query_string, sizeof query_string, _str, userId, modelId, modelCount, modelDate, slotId, modelType, modelOtherId ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

stock LoadUserMarketPlace ( playerid )
{
	used_inventory [ playerid ] = true ;
	toggle_controlable ( playerid, false ) ;

	SetInventoryItem ( playerid ) ;
	setInventoryLayout ( playerid, 1 ) ;
	set_inventory_button ( playerid, SUB_INV_MARKET_PLACE ) ;
	setInventoryWarehouse ( playerid, SUB_INV_MARKET_PLACE, 0 ) ;
	setWarehouseInfo (
		playerid,
		"Склад почты", 
		"Здесь хранятся предметы, которым\nне хватило места в инвентаре", 
		"", 
		"",
		"",
		""
	) ;
	return true ;
}

stock dragged_market_place ( playerid, moveFromIndex, moveToIndex, bool: toInventory )
{
	if ( toInventory )
	{
		new draggedItem = GetMarketPlaceInventory ( playerid, INV_ITEM, moveFromIndex ),
			draggedItemCount = GetMarketPlaceInventory ( playerid, INV_ITEM_COUNT, moveFromIndex ),
			USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;

		moveInventory = TransferInventoryStructure ( playerid, SUB_INV_MARKET_PLACE, moveFromIndex ) ;
		new _return = giveInventorySlot ( playerid, moveInventory, moveToIndex ) ;
		if ( _return == -1 )
		{
			send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		clear_market_place_slot ( playerid, draggedItem, draggedItemCount, moveFromIndex ) ;
	}
	else
	{
		new draggedItem = GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ),
			draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, moveFromIndex ),
			USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;

		moveInventory = TransferInventoryStructure ( playerid, SUB_INVENTORY, moveFromIndex ) ;
		new _return = give_market_place_slot ( playerid, moveToIndex, moveInventory ) ;
		if ( _return == -1 )
		{
			send_check_cinfo ( playerid, "Вы не можете переместить объект в выбранный слот.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		clear_inventory_slot ( playerid, draggedItem, draggedItemCount, moveFromIndex ) ;
	}
	return 1 ;
}

stock clear_market_place ( playerid, modelId, modelCount )
{
	new slotId = ClearInventory ( playerid, SUB_INV_MARKET_PLACE, modelId, modelCount ) ;
	SetWarehouseItemID ( playerid, SUB_INV_MARKET_PLACE, playerid, slotId ) ;
	return 1 ;
}

stock clear_market_place_slot ( playerid, modelId, modelCount, slotId )
{
	ClearInventorySlot ( playerid, SUB_INV_MARKET_PLACE, slotId, modelId, modelCount ) ;
	SetWarehouseItemID ( playerid, SUB_INV_MARKET_PLACE, playerid, slotId ) ;
	return 1 ;
}

stock give_market_place_slot ( playerid, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( slotId == -1 ) slotId = GiveInventory ( playerid, SUB_INV_MARKET_PLACE, itemStruct ) ;
	else GiveInventorySlot ( playerid, SUB_INV_MARKET_PLACE, slotId, itemStruct ) ;
	return slotId ;
}

stock set_market_place_divide ( playerid, itemIndex, itemCount )
{
	new draggedItem = GetMarketPlaceInventory ( playerid, INV_ITEM, itemIndex ) ;
	if ( item_blocked ( playerid, draggedItem ) )
	{
		send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new slotId = GetInventoryFreeSlot ( playerid, SUB_INV_MARKET_PLACE ) ;
	if ( slotId == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного места на Market Place.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	clear_market_place_slot ( 
		playerid, 
		draggedItem,
		itemCount,
		itemIndex
	) ;

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( playerid, SUB_INV_MARKET_PLACE, itemIndex ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = itemCount ;
	give_market_place_slot ( playerid, slotId, inventoryStruct ) ;
	return true ;
}

stock mp_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_shop_workshop:
		{
			if ( ! response ) return true ;

			new _b_id = GetPVarInt ( playerid, "p_biz_id" ), mpPrice = b_price_market [ _b_id - 1 ] [ 0 ] ;
			if ( p_info [ playerid ] [ money ] < mpPrice )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}
			
			give_bmoney ( _b_id, mpPrice, 0 ) ;
			give_money ( playerid, -mpPrice ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -mpPrice, "услуги почты" ) ;

			InventoryLoading ( p_info [ playerid ] [ id ], playerid, SUB_INV_MARKET_PLACE, 1 ) ;
			return true ;
		}
	}
	return false ;
}