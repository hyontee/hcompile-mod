new USERS_INVENTORY [ MAX_PLAYERS ] [ MAX_INVENTORY_SLOTS ] [ USERS_INVENTORY_STRUCT ] ;

#define GetUsersInventory(%0,%1,%2)					USERS_INVENTORY[%0][%2][%1]
#define SetUsersInventoryChar(%0,%1,%2,%3)			format(USERS_INVENTORY[%0][%2][%1], 12, "%s", %3)

new VEHICLES_INVENTORY [ MAX_VEHICLES ] [ MAX_WAREHOUSE_SLOT ] [ USERS_INVENTORY_STRUCT ] ;

#define GetVehicleInventory(%0,%1,%2) 				VEHICLES_INVENTORY[%0-1][%2][%1]
#define SetVehicleInventoryChar(%0,%1,%2,%3)		format(VEHICLES_INVENTORY[%0-1][%2][%1], 12, "%s", %3)

new HOUSES_INVENTORY [ MAX_HOUSES ] [ MAX_WAREHOUSE_SLOT ] [ USERS_INVENTORY_STRUCT ] ;

#define GetHouseInventory(%0,%1,%2) 				HOUSES_INVENTORY[%0-1][%2][%1]
#define SetHouseInventoryChar(%0,%1,%2,%3)			format(HOUSES_INVENTORY[%0-1][%2][%1], 12, "%s", %3)

new FRACTIONS_INVENTORY [ max_fraction ] [ MAX_FRACTION_WAREHOUSE ] [ USERS_INVENTORY_STRUCT ] ;

#define GetFractionInventory(%0,%1,%2) 				FRACTIONS_INVENTORY[%0-1][%2][%1]
#define SetFractionInventoryChar(%0,%1,%2,%3)		format(FRACTIONS_INVENTORY[%0-1][%2][%1], 12, "%s", %3)

new TRADE_INVENTORY [ MAX_PLAYERS ] [ MAX_TRADE_SLOTS ] [ USERS_INVENTORY_STRUCT ] ;

#define GetTradeInventory(%0,%1,%2)					TRADE_INVENTORY[%0][%2][%1]
#define SetTradeInventoryChar(%0,%1,%2,%3)			format(TRADE_INVENTORY[%0][%2][%1], 12, "%s", %3)

new MARKET_INVENTORY_SELL [ MAX_MARKET ] [ MAX_MARKET_SLOTS ] [ USERS_INVENTORY_STRUCT ] ;

#define GetMarketSellInventory(%0,%1,%2)			MARKET_INVENTORY_SELL[%0][%2][%1]
#define SetMarketSellInventoryChar(%0,%1,%2,%3)		format(TRADE_INVENTORY[%0][%2][%1], 12, "%s", %3)

new MARKET_INVENTORY_BUY [ MAX_MARKET ] [ MAX_MARKET_SLOTS ] [ USERS_INVENTORY_STRUCT ] ;

#define GetMarketBuyInventory(%0,%1,%2)				MARKET_INVENTORY_BUY[%0][%2][%1]
#define SetMarketBuyInventoryChar(%0,%1,%2,%3)		format(MARKET_INVENTORY_BUY[%0][%2][%1], 12, "%s", %3)

new MARKET_PLACE_INVENTORY [ MAX_PLAYERS ] [ MAX_MARKET_PLACE_ITEMS ] [ USERS_INVENTORY_STRUCT ] ;

#define GetMarketPlaceInventory(%0,%1,%2)			MARKET_PLACE_INVENTORY[%0][%2][%1]
#define SetMarketPlaceInventoryChar(%0,%1,%2,%3)	format(MARKET_PLACE_INVENTORY[%0][%2][%1], 12, "%s", %3)

new GUARD_INVENTORY [ MAX_PLAYERS ] [ MAX_GUARDS ] [ MAX_GUARDS_SLOT ] [ USERS_INVENTORY_STRUCT ] ;

#define GetGuardInventory(%0,%1,%2,%3)				GUARD_INVENTORY[%0][%1][%3][%2]
#define SetGuardInventoryChar(%0,%1,%2,%3,%4)		format(GUARD_INVENTORY[%0][%1][%3][%2], 12, "%s", %4)

stock ClearInventoryNull ( idx, inventoryType, itemIndex )
{
	if ( inventoryType == SUB_INVENTORY ) USERS_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_VEHICLE ) VEHICLES_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_HOUSE ) HOUSES_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_FAMILY ) FAMILYS_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_FRACTION ) FRACTIONS_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) MARKET_PLACE_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_TRADE ) TRADE_INVENTORY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) MARKET_INVENTORY_SELL [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) MARKET_INVENTORY_BUY [ idx ] [ itemIndex ] = clearInventoryStruct ;
	else if ( inventoryType == SUB_INV_GUARDS )
	{
		for ( new i = 0 ; i < MAX_GUARDS ; i ++ )
			GUARD_INVENTORY [ idx ] [ i ] [ itemIndex ] = clearInventoryStruct ;
	}
}

stock GetInventoryFindSlot ( idx, inventoryType, modelId )
{
	new slotId = -1, maxItems ;

	if ( inventoryType == SUB_INVENTORY ) maxItems = MAX_INVENTORY_SLOTS ;
	else if ( inventoryType == SUB_INV_VEHICLE ) maxItems = getTrunkCapacity ( idx ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) maxItems = MAX_WAREHOUSE_SLOT ;
	else if ( inventoryType == SUB_INV_FAMILY ) maxItems = MAX_FAMILY_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_FRACTION ) maxItems = MAX_FRACTION_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) maxItems = MAX_MARKET_PLACE_ITEMS ;
	else if ( inventoryType == SUB_INV_TRADE ) maxItems = MAX_TRADE_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_GUARDS ) maxItems = MAX_GUARDS_SLOT ;
	
	new migrateStruct [ USERS_INVENTORY_STRUCT ] ;
	for ( new i = 0 ; i < maxItems ; i ++ )
	{
		migrateStruct = GetInventoryStruct ( idx, inventoryType, i ) ;
		if ( migrateStruct [ INV_ITEM ] != modelId ) continue ;

		slotId = i ;
		break ;
	}
	return slotId ;
}

stock GetInventoryFreeSlot ( idx, inventoryType )
{
	new slotId = -1, maxItems = 0 ;

	if ( inventoryType == SUB_INVENTORY ) maxItems = MAX_INVENTORY_SLOTS ;
	else if ( inventoryType == SUB_INV_VEHICLE ) maxItems = getTrunkCapacity ( idx ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) maxItems = MAX_WAREHOUSE_SLOT ;
	else if ( inventoryType == SUB_INV_FAMILY ) maxItems = MAX_FAMILY_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_FRACTION ) maxItems = MAX_FRACTION_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) maxItems = MAX_MARKET_PLACE_ITEMS ;
	else if ( inventoryType == SUB_INV_TRADE ) maxItems = MAX_TRADE_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_GUARDS ) maxItems = MAX_GUARDS_SLOT ;
	
	new migrateStruct [ USERS_INVENTORY_STRUCT ] ;
	for ( new i = 0 ; i < maxItems ; i ++ )
	{
		migrateStruct = GetInventoryStruct ( idx, inventoryType, i ) ;
		if ( migrateStruct [ INV_ITEM ] > 0 ) continue ;

		slotId = i ;
		break ;
	}
	return slotId ;
}

stock GetInventoryFindItem ( idx, inventoryType, modelId )
{
	new itemCount = 0, maxItems = 0 ;

	if ( inventoryType == SUB_INVENTORY ) maxItems = MAX_INVENTORY_SLOTS ;
	else if ( inventoryType == SUB_INV_VEHICLE ) maxItems = getTrunkCapacity ( idx ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) maxItems = MAX_WAREHOUSE_SLOT ;
	else if ( inventoryType == SUB_INV_FAMILY ) maxItems = MAX_FAMILY_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_FRACTION ) maxItems = MAX_FRACTION_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) maxItems = MAX_MARKET_PLACE_ITEMS ;
	else if ( inventoryType == SUB_INV_TRADE ) maxItems = MAX_TRADE_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_GUARDS ) maxItems = MAX_GUARDS_SLOT ;
	
	new migrateStruct [ USERS_INVENTORY_STRUCT ] ;
	for ( new i = 0 ; i < maxItems ; i ++ )
	{
		migrateStruct = GetInventoryStruct ( idx, inventoryType, i ) ;
		if ( migrateStruct [ INV_ITEM ] != modelId ) continue ;

		itemCount = migrateStruct [ INV_ITEM_COUNT ] ;
		break ;
	}
	return itemCount ;
}

stock USERS_INVENTORY_STRUCT: TransferInventoryStructure ( idx, inventoryType, itemIndex )
{
	new migrateStruct [ USERS_INVENTORY_STRUCT ], USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] ;
	migrateStruct = GetInventoryStruct ( idx, inventoryType, itemIndex ) ;
	
	itemStruct [ _:INV_ITEM ] = migrateStruct [ INV_ITEM ] ;
	itemStruct [ _:INV_ITEM_COUNT ] = migrateStruct [ INV_ITEM_COUNT ] ;
	itemStruct [ _:INV_ITEM_DATE ] = migrateStruct [ INV_ITEM_DATE ] ;
	itemStruct [ _:INV_ID ] = migrateStruct [ INV_ID ] ;
	itemStruct [ _:INV_ITEM_TYPE ] = migrateStruct [ INV_ITEM_TYPE ] ;
	itemStruct [ _:INV_ITEM_REGION ] = migrateStruct [ INV_ITEM_REGION ] ;
	itemStruct [ _:INV_ITEM_PLATE ] = migrateStruct [ INV_ITEM_PLATE ] ;
	itemStruct [ _:INV_ITEM_PLATE_TYPE ] = migrateStruct [ INV_ITEM_PLATE_TYPE ] ;
	format ( itemStruct [ _:INV_ITEM_REGION ], 12, "%s", migrateStruct [ INV_ITEM_PLATE_TYPE ] ) ;
	format ( itemStruct [ _:INV_ITEM_PLATE ], 12, "%s", migrateStruct [ INV_ITEM_PLATE_TYPE ] ) ;
	itemStruct [ _:INV_ITEM_GIVE_DATE ] = migrateStruct [ INV_ITEM_GIVE_DATE ] ;
	itemStruct [ _:INV_ITEM_ID ] = migrateStruct [ INV_ITEM_ID ] ;
	itemStruct [ _:INV_ITEM_LEVEL ] = migrateStruct [ INV_ITEM_LEVEL ] ;
	itemStruct [ _:INV_ITEM_STRIPE ] = migrateStruct [ INV_ITEM_STRIPE ] ;
	itemStruct [ _:INV_ITEM_WEAR ] = migrateStruct [ INV_ITEM_WEAR ] ;
	itemStruct [ _:INV_OBJ_X ] = migrateStruct [ INV_OBJ_X ] ;
	itemStruct [ _:INV_OBJ_Y ] = migrateStruct [ INV_OBJ_X ] ;
	itemStruct [ _:INV_OBJ_Z ] = migrateStruct [ INV_OBJ_X ] ;
	itemStruct [ _:INV_ROT_X ] = migrateStruct [ INV_OBJ_X ] ;
	itemStruct [ _:INV_ROT_Y ] = migrateStruct [ INV_OBJ_X ] ;
	itemStruct [ _:INV_ROT_Z ] = migrateStruct [ INV_OBJ_X ] ;

	return itemStruct ;
}

stock GetInventoryStruct ( idx, inventoryType, itemIndex )
{
	new migrateStruct [ USERS_INVENTORY_STRUCT ] ;

	if ( inventoryType == SUB_INVENTORY )
		migrateStruct = USERS_INVENTORY [ idx ] [ itemIndex ] ;
		
	else if ( inventoryType == SUB_INV_VEHICLE )
		migrateStruct = VEHICLES_INVENTORY [ idx ] [ itemIndex ] ;
		
	else if ( inventoryType == SUB_INV_HOUSE )
		migrateStruct = HOUSES_INVENTORY [ idx ] [ itemIndex ] ;
		
	else if ( inventoryType == SUB_INV_FAMILY )
		migrateStruct = FAMILYS_INVENTORY [ idx ] [ itemIndex ] ;
		
	else if ( inventoryType == SUB_INV_FRACTION )
		migrateStruct = FRACTIONS_INVENTORY [ idx ] [ itemIndex ] ;
		
	else if ( inventoryType == SUB_INV_MARKET_PLACE )
		migrateStruct = MARKET_PLACE_INVENTORY [ idx ] [ itemIndex ] ;
		
	else if ( inventoryType == SUB_INV_TRADE )
		migrateStruct = TRADE_INVENTORY [ idx ] [ itemIndex ] ;

	else if ( inventoryType == SUB_INV_MARKET_SELL )
		migrateStruct = MARKET_INVENTORY_SELL [ idx ] [ itemIndex ] ;

	else if ( inventoryType == SUB_INV_MARKET_BUY )
		migrateStruct = MARKET_INVENTORY_BUY [ idx ] [ itemIndex ] ;

	else if ( inventoryType == SUB_INV_GUARDS )
		migrateStruct = GUARD_INVENTORY [ idx ] [ GetPlayerTimeInfo ( idx, PT_GUARD ) ] [ itemIndex ] ;

	return migrateStruct ;
}

stock SetInventoryStructure ( idx, inventoryType, itemIndex, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	new migrateStruct [ USERS_INVENTORY_STRUCT ] ;

	migrateStruct [ INV_ITEM ] = itemStruct [ _:INV_ITEM ] ;
	migrateStruct [ INV_ITEM_COUNT ] = itemStruct [ _:INV_ITEM_COUNT ] ;
	migrateStruct [ INV_ITEM_DATE ] = itemStruct [ _:INV_ITEM_DATE ] ;
	migrateStruct [ INV_ID ] = itemStruct [ _:INV_ID ] ;
	migrateStruct [ INV_ITEM_TYPE ] = itemStruct [ _:INV_ITEM_TYPE ] ;
	format ( migrateStruct [ INV_ITEM_REGION ], 12, "%s", itemStruct [ _:INV_ITEM_REGION ] ) ;
	format ( migrateStruct [ INV_ITEM_PLATE ], 12, "%s", itemStruct [ _:INV_ITEM_PLATE ] ) ;
	migrateStruct [ INV_ITEM_PLATE_TYPE ] = itemStruct [ _:INV_ITEM_PLATE_TYPE] ;
	migrateStruct [ INV_ITEM_GIVE_DATE ] = itemStruct [ _:INV_ITEM_GIVE_DATE ] ;
	migrateStruct [ INV_ITEM_ID ] = itemStruct [ _:INV_ITEM_ID ] ;
	migrateStruct [ INV_ITEM_LEVEL ] = itemStruct [ _:INV_ITEM_LEVEL ] ;
	migrateStruct [ INV_ITEM_STRIPE ] = itemStruct [ _:INV_ITEM_STRIPE ] ;
	migrateStruct [ INV_ITEM_WEAR ] = itemStruct [ _:INV_ITEM_WEAR ] ;
	migrateStruct [ INV_OBJ_X ] = itemStruct [ _:INV_OBJ_X ] ;
	migrateStruct [ INV_OBJ_Y ] = itemStruct [ _:INV_OBJ_X ] ;
	migrateStruct [ INV_OBJ_Z ] = itemStruct [ _:INV_OBJ_X ] ;
	migrateStruct [ INV_ROT_X ] = itemStruct [ _:INV_OBJ_X ] ;
	migrateStruct [ INV_ROT_Y ] = itemStruct [ _:INV_OBJ_X ] ;
	migrateStruct [ INV_ROT_Z ] = itemStruct [ _:INV_OBJ_X ] ;

	if ( inventoryType == SUB_INVENTORY ) USERS_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_VEHICLE ) VEHICLES_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_HOUSE ) HOUSES_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_FAMILY ) FAMILYS_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_FRACTION ) FRACTIONS_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) MARKET_PLACE_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_TRADE ) TRADE_INVENTORY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) MARKET_INVENTORY_SELL [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) MARKET_INVENTORY_BUY [ idx ] [ itemIndex ] = migrateStruct ;
	else if ( inventoryType == SUB_INV_GUARDS )
		GUARD_INVENTORY [ idx ] [ GetPlayerTimeInfo ( idx, PT_GUARD ) ] [ itemIndex ] = migrateStruct ;
}

stock ClearInventory ( idx, inventoryType, modelId, modelCount )
{
	new slotId = -1, maxItems ;

	if ( inventoryType == SUB_INVENTORY ) maxItems = MAX_INVENTORY_SLOTS ;
	else if ( inventoryType == SUB_INV_VEHICLE ) maxItems = getTrunkCapacity ( idx ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) maxItems = MAX_WAREHOUSE_SLOT ;
	else if ( inventoryType == SUB_INV_FAMILY ) maxItems = MAX_FAMILY_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_FRACTION ) maxItems = MAX_FRACTION_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) maxItems = MAX_MARKET_PLACE_ITEMS ;
	else if ( inventoryType == SUB_INV_TRADE ) maxItems = MAX_TRADE_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_GUARDS ) maxItems = MAX_GUARDS_SLOT ;
	
	new migrateStruct [ USERS_INVENTORY_STRUCT ] ;
	for ( new i = 0 ; i < maxItems ; i ++ )
	{
		migrateStruct = GetInventoryStruct ( idx, inventoryType, i ) ;
		if ( migrateStruct [ INV_ITEM ] != modelId ) continue ;
		if ( migrateStruct [ INV_ITEM_COUNT ] < modelCount ) continue ;

		ClearInventorySlot ( idx, inventoryType, i, modelId, modelCount ) ;
		slotId = i ;
		break ;
	}
	return slotId ;
}

stock ClearInventorySlot ( idx, inventoryType, itemIndex, modelId, itemCount )
{
	new USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ],
		itemId, bool: isUpdate = false, bool: isSQL = true, tableName [ 24 ] ;

	itemStruct = TransferInventoryStructure ( idx, inventoryType, itemIndex ) ;
	itemId = itemStruct [ _:INV_ID ] ;
	if ( itemStruct [ _:INV_ITEM_COUNT ] - itemCount > 0 )
	{
		itemStruct [ _:INV_ITEM_COUNT ] -= itemCount ;
		isUpdate = true ;
	}
	else
	{
		itemStruct [ _:INV_ITEM ] = 0 ;
		itemStruct [ _:INV_ITEM_COUNT ] = 0 ;
		itemStruct [ _:INV_ITEM_DATE ] = 0 ;
		itemStruct [ _:INV_ID ] = 0 ;
		itemStruct [ _:INV_ITEM_TYPE ] = 0 ;
		itemStruct [ _:INV_ITEM_REGION ] = 0 ;
		itemStruct [ _:INV_ITEM_PLATE ] = 0 ;
		itemStruct [ _:INV_ITEM_PLATE_TYPE ] = 0 ;
		format ( itemStruct [ _:INV_ITEM_REGION ], 12, "" ) ;
		format ( itemStruct [ _:INV_ITEM_PLATE ], 12, "" ) ;
		itemStruct [ _:INV_ITEM_GIVE_DATE ] = 0 ;
		itemStruct [ _:INV_ITEM_ID ] = 0 ;
		itemStruct [ _:INV_ITEM_LEVEL ] = 0 ;
		itemStruct [ _:INV_ITEM_STRIPE ] = 0 ;
		itemStruct [ _:INV_ITEM_WEAR ] = 0 ;
		itemStruct [ _:INV_OBJ_X ] = 0.0 ;
		itemStruct [ _:INV_OBJ_Y ] = 0.0 ;
		itemStruct [ _:INV_OBJ_Z ] = 0.0 ;
		itemStruct [ _:INV_ROT_X ] = 0.0 ;
		itemStruct [ _:INV_ROT_Y ] = 0.0 ;
		itemStruct [ _:INV_ROT_Z ] = 0.0 ;

		isUpdate = false ;
	}
	if ( inventoryType == SUB_INVENTORY ) format ( tableName, sizeof tableName, "users_inventory" ) ;
	else if ( inventoryType == SUB_INV_VEHICLE ) format ( tableName, sizeof tableName, "users_vehicles_inventory" ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) format ( tableName, sizeof tableName, "houses_inventory" ) ;
	else if ( inventoryType == SUB_INV_FAMILY ) format ( tableName, sizeof tableName, "familys_inventory" ) ;
	else if ( inventoryType == SUB_INV_FRACTION ) format ( tableName, sizeof tableName, "fractions_inventory" ) ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) format ( tableName, sizeof tableName, "users_market_place" ) ;
	else if ( inventoryType == SUB_INV_TRADE ) isSQL = false ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) isSQL = false ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) isSQL = false ;
	else if ( inventoryType == SUB_INV_GUARDS ) format ( tableName, sizeof tableName, "users_guards_inventory" ) ;

	if ( isSQL )
	{
		if ( isUpdate )
		{
			static const _str [ ] = "UPDATE `%s` SET `inv_count` = `inv_count` - '%d' WHERE `id` = '%d' LIMIT 1" ;
			new sql_string [ sizeof _str + 9 + 32 ] ;
			format ( sql_string, sizeof sql_string, _str, tableName, itemCount, itemId ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
		else
		{
			static const _str [ ] = "DELETE FROM `%s` WHERE `id` = '%d' LIMIT 1" ;
			new sql_string [ sizeof _str + 9 + 32 ] ;
			format ( sql_string, sizeof sql_string, _str, tableName, itemId ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	}

	SetInventoryStructure ( idx, inventoryType, itemIndex, itemStruct ) ;

	MODEL_INFO [ modelId ] [ MODEL_COUNT ] -= itemCount ;
	set_model_count ( modelId, MODEL_INFO [ modelId ] [ MODEL_COUNT ] ) ;
	return itemIndex ;
}

//========================================================================================================================================
#include 									"modules/other/inventory/m_inventory.pwn"
//========================================================================================================================================
#include 									"modules/other/inventory/m_market_place.pwn"
//========================================================================================================================================
#include 									"modules/other/inventory/m_market.pwn"
//========================================================================================================================================
#include 									"modules/other/inventory/m_rieltore_trade.pwn"
//========================================================================================================================================
#include 									"modules/other/inventory/packet/inventory.inc"
//========================================================================================================================================
#include 									"modules/other/inventory/packet/trade.inc"
//========================================================================================================================================
#include 									"modules/other/inventory/packet/market.inc"
//========================================================================================================================================

stock GetInventoryInfo ( playerid, inventoryType, itemIndex )
{
	new s_year, s_month, s_day, s_hour, s_minute, s_second,
		modelId, modelCount, dayAction, acsLevel, modelWear, modelType, date_string [ 64 ] ;
	if ( inventoryType == SUB_INVENTORY )
	{
		modelId = GetUsersInventory ( playerid, INV_ITEM, itemIndex ) ;
		dayAction = GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetUsersInventory ( playerid, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_VEHICLE )
	{
		new vehicleId = idaofcar [ playerid ] ;
			
		modelId = GetVehicleInventory ( vehicleId, INV_ITEM, itemIndex ) ;
		dayAction = GetVehicleInventory ( vehicleId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetVehicleInventory ( vehicleId, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetVehicleInventory ( vehicleId, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetVehicleInventory ( vehicleId, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetVehicleInventory ( vehicleId, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_ACCESSORIES )
	{
		modelId = GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) ;
		dayAction = GetUserAccessories ( playerid, ACS_DATE, itemIndex ) ;
		modelCount = GetUserAccessories ( playerid, ACS_COUNT, itemIndex ) ;
		acsLevel = GetUserAccessories ( playerid, ACS_LEVEL, itemIndex ) ;
		modelWear = GetUserAccessories ( playerid, ACS_WEAR, itemIndex ) ;
		modelType = INVENTORY_TYPE_ACCESSORIES ;
	}
	else if ( inventoryType == SUB_INV_HOUSE )
	{
		new houseId = GetPVarInt ( playerid, "house_id" ) ;

		modelId = GetHouseInventory ( houseId, INV_ITEM, itemIndex ) ;
		dayAction = GetHouseInventory ( houseId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetHouseInventory ( houseId, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetHouseInventory ( houseId, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetHouseInventory ( houseId, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetHouseInventory ( houseId, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_FAMILY )
	{
		new familyId = p_info [ playerid ] [ family ] ;

		modelId = GetFamilyInventory ( familyId, INV_ITEM, itemIndex ) ;
		dayAction = GetFamilyInventory ( familyId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetFamilyInventory ( familyId, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetFamilyInventory ( familyId, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetFamilyInventory ( familyId, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetFamilyInventory ( familyId, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_FRACTION )
	{
		new fId = p_info [ playerid ] [ member ] ;

		modelId = GetFractionInventory ( fId, INV_ITEM, itemIndex ) ;
		dayAction = GetFractionInventory ( fId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetFractionInventory ( fId, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetFractionInventory ( fId, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetFractionInventory ( fId, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetFractionInventory ( fId, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_MARKET_PLACE )
	{
		modelId = GetMarketPlaceInventory ( playerid, INV_ITEM, itemIndex ) ; 
		dayAction = GetMarketPlaceInventory ( playerid, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetMarketPlaceInventory ( playerid, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetMarketPlaceInventory ( playerid, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetMarketPlaceInventory ( playerid, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetMarketPlaceInventory ( playerid, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_TRADE )
	{
		modelId = GetTradeInventory ( playerid, INV_ITEM, itemIndex ) ; 
		dayAction = GetTradeInventory ( playerid, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetTradeInventory ( playerid, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetTradeInventory ( playerid, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetTradeInventory ( playerid, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetTradeInventory ( playerid, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_TRADE_RECEIVER )
	{
		new targetId = trade_rielt [ playerid ] [ trade_id ] ;
		modelId = GetTradeInventory ( targetId, INV_ITEM, itemIndex ) ; 
		dayAction = GetTradeInventory ( targetId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetTradeInventory ( targetId, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetTradeInventory ( targetId, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetTradeInventory ( targetId, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetTradeInventory ( targetId, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_MARKET_SELL )
	{
		modelId = GetMarketSellInventory ( playerid, INV_ITEM, itemIndex ) ; 
		dayAction = GetMarketSellInventory ( playerid, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetMarketSellInventory ( playerid, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetMarketSellInventory ( playerid, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetMarketSellInventory ( playerid, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetMarketSellInventory ( playerid, INV_ITEM_TYPE, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_GUARDS )
	{
		new guardId = GetPlayerTimeInfo ( playerid, PT_GUARD ) ;
		modelId = GetGuardInventory ( playerid, guardId, INV_ITEM, itemIndex ) ; 
		dayAction = GetGuardInventory ( playerid, guardId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetGuardInventory ( playerid, guardId, INV_ITEM_COUNT, itemIndex ) ;
		acsLevel = GetGuardInventory ( playerid, guardId, INV_ITEM_LEVEL, itemIndex ) ;
		modelWear = GetGuardInventory ( playerid, guardId, INV_ITEM_WEAR, itemIndex ) ;
		modelType = GetGuardInventory ( playerid, guardId, INV_ITEM_TYPE, itemIndex ) ;
	}

	if ( dayAction != -1 )
	{
		timestamp_to_date ( dayAction + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
	}
	else format ( date_string, sizeof date_string, " " ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "\
		{"#cWH"}Предмет: {"#cOR"}%s\n\
		{"#cWH"}Количество: {"#cWV"}%d шт.\n\
		{"#cWH"}%s\n\
		{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\
		{"#cWH"}Можно хранить в одной ячейке: {"#cWV"}%d ед. предмета\n\n",
	item_name ( modelId ), modelCount, date_string, get_model_count ( modelId ), item_max_in_slot ( modelId ) ) ;

	switch ( modelId )
	{
	    case 190, 191, 192:
		{
		#if defined m_casket
			new casketId = GetCasketId ( modelId ) ;
			format ( global_string, sizeof global_string, "\
				%s{"#cWH"}При открытии этого ларца помимо основных предметов,\n\
				можно получить {"#cLY"}супер-рекие {"#cWH"}предметы, такие как:\n\n\
				%s\n\n\
				{"#cWH"}Такой сундук можно приобрести в {"#cLY"}донат-магазине,\n\
				{"#cWH"}или у игроков через обмен. (/trade)\n\n", global_string, CASKET_INFO [ casketId ] [ CASKET_DESCRIPTION ] ) ;
		#endif
		}
		case 905: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на шахте, свалке, у игроков или на рынке.", global_string ) ;
		case 19941: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на шахте, свалке, у игроков или на рынке.", global_string ) ;
		case 1463: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на лесопилке, свалке, у игроков или на рынке.", global_string ) ;
		case 2684: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на лесопилке, свалке, у игроков или на рынке.", global_string ) ;
		case 1080: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1018: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1038: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1140: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1165: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 19773: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nВыпадает при убийстве полицейского.", global_string ) ;
		case 11746: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nНеобходим для побега из тюрьмы.", global_string ) ;
		default:
		{
		    new _type ;
		    for ( new i = 0 ; i < 5 ; i ++ )
		    {
				_type = get_model_type ( modelId, i ) ;
				if ( _type == MODEL_TYPE_SHOP ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой предмет можно приобрести в {"#cLY"}автосалоне{"#cWH"}.\n", global_string ) ;
				else if ( _type == MODEL_TYPE_DONATE ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой предмет можно приобрести в {"#cLY"}/donate{"#cWH"}.\n", global_string ) ;
				else if ( _type == MODEL_TYPE_BATTLE_PASS ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой предмет можно приобрести в {"#cLY"}обменнике "event_coins"{"#cWH"}.\n", global_string ) ;
				else if ( _type == MODEL_TYPE_FAMILY ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой предмет можно приобрести в {"#cLY"}обменнике "family_title"{"#cWH"}.\n", global_string ) ;
				else if ( _type == MODEL_TYPE_CRAFT ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой предмет можно {"#cLY"}скрафтить{"#cWH"} в подвале любого дома.\n", global_string ) ;
			}

            format ( global_string, sizeof global_string, "%s{"#cWH"}Можно выменять (/trade) или приобрести у игроков.", global_string ) ;
		}
	}

	if ( GetModelStatsMax ( modelId ) > 0 )
	{
		new line_string [ 256 ] ;
		for ( new i = 0 ; i < ACS_STATS_SPECIAL ; i ++ )
		{
			if ( GetModelStatsLevel ( i, modelId, acsLevel ) != -1 )
			{
				if ( i == ACS_STATS_LUCKY )
					format ( line_string, sizeof line_string, "%s\n+%d%% к удаче", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_DAMAGE )
					format ( line_string, sizeof line_string, "%s\n+%d к урону", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_GUARD )
					format ( line_string, sizeof line_string, "%s\n+%d к понижению урона по Вам", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_CRITICAL )
					format ( line_string, sizeof line_string, "%s\nшанс +%d%% на крит. урон", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_MAX_HP )
					format ( line_string, sizeof line_string, "%s\n+%d к макс. хп", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_MAX_ARM )
					format ( line_string, sizeof line_string, "%s\n+%d к макс. броне", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_REFL )
					format ( line_string, sizeof line_string, "%s\nшанс +%d%% отразить урон", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_BLEEDING )
					format ( line_string, sizeof line_string, "%s\nшанс +%d%% нанести кровот. рану", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;

			}
		}

		format ( global_string, sizeof global_string, "%s\
			\n\n{"#cBL"}** Характеристики **\n\
			{"#cWH"}Улучшение: {"#cOR"}%d/%d\n\
			{"#cWH"}Бонус от улучшения: {"#cGRDialog"}%s",
		global_string, acsLevel, GetModelStatsMax ( modelId ), line_string ) ;
	}

	new line_string [ 256 ], bool: isNotNull = false ;
	for ( new i = 0 ; i < MAX_MODEL_STATS ; i ++ )
	{
		if ( GetModelStatsLevel ( ACS_STATS_SPECIAL, modelId, i ) != -1 )
		{
			isNotNull = true ;

			if ( i == ACS_SPECIAL_LUCKY )
				format ( line_string, sizeof line_string, "%s\n-- Удача: +%d%% к шансу в рулетках", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
				
			if ( i == ACS_SPECIAL_DAMAGE )
				format ( line_string, sizeof line_string, "%s\n-- Урон: +%d к урону", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
			
			if ( i == ACS_SPECIAL_GUARD )
				format ( line_string, sizeof line_string, "%s\n-- Защита: +%d к понижению урона по Вам", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
			
			if ( i == ACS_SPECIAL_CRITICAL )
				format ( line_string, sizeof line_string, "%s\n-- Крит. урон: шанс +%d%% к нанесению", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
			
			if ( i == ACS_SPECIAL_MAX_HP )
				format ( line_string, sizeof line_string, "%s\n-- Здоровье: +%d к макс. хп", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
			
			if ( i == ACS_SPECIAL_MAX_ARM )
				format ( line_string, sizeof line_string, "%s\n-- Броня: +%d к броне", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
			
			if ( i == ACS_SPECIAL_REFL )
				format ( line_string, sizeof line_string, "%s\n-- Отражение: шанс +%d%% отразить урон", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
			
			if ( i == ACS_SPECIAL_BLEEDING )
				format ( line_string, sizeof line_string, "%s\n-- Кровотечение: шанс +%d%% нанести кровот. рану", line_string, GetModelStatsInfo ( ACS_STATS_SPECIAL, modelId, i ) ) ;
		}
	}

	if ( isNotNull )
	{
		format ( global_string, sizeof global_string, "%s\
			\n\n{"#cRInfo"}Данный предмет имеет следующие характеристики по-умолчанию:{"#cWH"}\
			%s", global_string, line_string ) ;
	}

	line_string [ 0 ] = EOS ; isNotNull = false ;
	new gunName [ 24 ] ;
	for ( new i = 0 ; i < MAX_MODEL_STATS ; i ++ )
	{
		if ( GetModelStatsLevel ( ACS_STATS_WEAPON, modelId, i ) != -1 )
		{
			isNotNull = true ;

            gunName [ 0 ] = EOS ;
			GetWeaponName ( GetModelStatsLevel ( ACS_STATS_WEAPON, modelId, i ), gunName, sizeof ( gunName ) ) ;
			format ( line_string, sizeof line_string, "%s\n-- %s: -%d%% урона", line_string, gunName, GetModelStatsInfo ( ACS_STATS_WEAPON, modelId, i ) ) ;
		}
	}

	if ( isNotNull )
	{
		format ( global_string, sizeof global_string, "%s\
			\n\n{"#cRInfo"}Понижение урона в зависимости от оружия:{"#cWH"}\
			%s", global_string, line_string ) ;
	}

	if ( modelType == INVENTORY_TYPE_ACCESSORIES )
	{
		switch ( modelWear )
		{
			case -1: format ( global_string, sizeof global_string, "%s\n\n{"#cGN"}Этот предмет имеет специальное свойство: не изнашиваться.", global_string ) ;
			case 0..20: format ( global_string, sizeof global_string, "%s\n\n{"#cWH"}Износ предмета: {"#cRInfo"}%d/%d", global_string, modelWear, GetModelWearMax ( modelId ) ) ;
			case 21..60: format ( global_string, sizeof global_string, "%s\n\n{"#cWH"}Износ предмета: {"#cOR"}%d/%d", global_string, modelWear, GetModelWearMax ( modelId ) ) ;
			default: format ( global_string, sizeof global_string, "%s\n\n{"#cWH"}Износ предмета: {"#cGN"}%d/%d", global_string, modelWear, GetModelWearMax ( modelId ) ) ;
		}
	}

	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", global_string, "Закрыть", "" ) ;
	return true ;
}

stock GetInventoryItemNextLevel ( playerid, itemIndex )
{
	new s_year, s_month, s_day, s_hour, s_minute, s_second,
		modelId, modelCount, dayAction, acsLevel, date_string [ 64 ] ;
	
	modelId = GetUsersInventory ( playerid, INV_ITEM, itemIndex ) ;
	dayAction = GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ) ;
	modelCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, itemIndex ) ;
	acsLevel = GetUsersInventory ( playerid, INV_ITEM_LEVEL, itemIndex ) ;

	if ( acsLevel + 1 > GetModelStatsMax ( modelId ) )
	{
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Заточка", "{"#cRInfo"}Ваш предмет имеет максимальный уровень!", "Принять", "" ) ;
		return true ;
	}

	acsLevel += 1 ;

	if ( dayAction != -1 )
	{
		timestamp_to_date ( dayAction + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
	}
	else format ( date_string, sizeof date_string, " " ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "\
		{"#cWH"}Предмет: {"#cOR"}%s\n\
		{"#cWH"}Количество: {"#cWV"}%d шт.\n\
		{"#cWH"}%s\n\
		{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\
		{"#cWH"}Можно хранить в одной ячейке: {"#cWV"}%d ед. предмета",
	item_name ( modelId ), modelCount, date_string, get_model_count ( modelId ), item_max_in_slot ( modelId ) ) ;

	if ( GetModelStatsMax ( modelId ) > 0 )
	{
		new line_string [ 256 ] ;
		for ( new i = 0 ; i < ACS_STATS_SPECIAL ; i ++ )
		{
			if ( GetModelStatsLevel ( i, modelId, acsLevel ) != -1 )
			{
				if ( i == ACS_STATS_LUCKY )
					format ( line_string, sizeof line_string, "%s\n+%d%% к удаче", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_DAMAGE )
					format ( line_string, sizeof line_string, "%s\n+%d к урону", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_GUARD )
					format ( line_string, sizeof line_string, "%s\n+%d к понижению урона по Вам", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_CRITICAL )
					format ( line_string, sizeof line_string, "%s\nшанс +%d%% на крит. урон", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_MAX_HP )
					format ( line_string, sizeof line_string, "%s\n+%d к макс. хп", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_MAX_ARM )
					format ( line_string, sizeof line_string, "%s\n+%d к макс. броне", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_REFL )
					format ( line_string, sizeof line_string, "%s\nшанс +%d%% отразить урон", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;
				
				else if ( i == ACS_STATS_BLEEDING )
					format ( line_string, sizeof line_string, "%s\nшанс +%d%% нанести кровот. рану", line_string, GetModelStatsInfo ( i, modelId, acsLevel ) ) ;

			}
		}

		format ( global_string, sizeof global_string, "%s\
			\n\n{"#cBL"}** Характеристики следующего уровня **\n\
			{"#cWH"}Бонус от улучшения: {"#cGRDialog"}%s",
		global_string, line_string ) ;
	}

	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Заточка", global_string, "Закрыть", "" ) ;
	return true ;
}

stock item_name ( modelId )
{
	new itemName [ 64 ] ;
	switch ( modelId )
	{
		case 0..300: format ( itemName, sizeof itemName, "Одежда #%d", modelId ) ;
	    case ITEM_2_EXP: itemName = "2 очка опыта" ;
		case 2001: itemName = "3 очка опыта" ;
		case 2002: itemName = "4 очка опыта" ;
		case 2003: itemName = "Еженедельный кейс" ;
		case 2004: itemName = "1.000"valute_title_"" ;
		case 2005: itemName = "5.000"valute_title_"" ;
		case 2006: itemName = "10.000"valute_title_"" ;
		case 2007: itemName = "50.000"valute_title_"" ;
		case 2008: itemName = "100.000"valute_title_"" ;
		case 2009: itemName = "150.000"valute_title_"" ;
		case 2010: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( INVALID_VEHICLE_ID, 400 ) ) ;
		case 2011: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( INVALID_VEHICLE_ID, 439 ) ) ;
		case 2012: format ( itemName, sizeof itemName, "Мотоцикл %s", GetVehicleNameEx ( INVALID_VEHICLE_ID, 522 ) ) ;
		case 2013: format ( itemName, sizeof itemName, "Яхта %s", GetVehicleNameEx ( INVALID_VEHICLE_ID, 446 ) ) ;
		case 2014: format ( itemName, sizeof itemName, "Яхта %s", GetVehicleNameEx ( INVALID_VEHICLE_ID, 493 ) ) ;
		case 2015: itemName = "9 доната" ;
		case 2016: itemName = "19 доната" ;
		case 2017: itemName = "29 доната" ;
		case 2018: itemName = "39 доната" ;
		case 2019: itemName = "49 доната" ;
		case 2020: itemName = "59 доната" ;
		case 2021: itemName = "69 доната" ;
		case 2022: itemName = "79 доната" ;
		case 2023: itemName = "89 доната" ;
		case 2024: itemName = "VIP {cd7f32}Bronze{"#cWH"} (3 дн.)" ;
		case 2025: itemName = "VIP {cd7f32}Bronze{"#cWH"} (5 дн.)" ;
		case 2026: itemName = "VIP {cd7f32}Bronze{"#cWH"} (7 дн.)" ;
		case 2027: itemName = "VIP {cd7f32}Bronze{"#cWH"} (10 дн.)" ;
		case 2028: itemName = "VIP {c8c8c8}Silver{"#cWH"} (3 дн.)" ;
		case 2029: itemName = "VIP {c8c8c8}Silver{"#cWH"} (5 дн.)" ;
		case 2030: itemName = "VIP {c8c8c8}Silver{"#cWH"} (7 дн.)" ;
		case 2031: itemName = "VIP {c8c8c8}Silver{"#cWH"} (10 дн.)" ;
		case 2032: itemName = "200.000"valute_title_"" ;
		case 2033: itemName = "300.000"valute_title_"" ;
		case 2034: itemName = "400.000"valute_title_"" ;
		case 2035: itemName = "Комплект лицензий" ;
		case 2036: itemName = "Набор навыков оружия" ;
		case 2037: itemName = "x2 PayDay, x2 з/п на квестах" ;
		case 2038: itemName = "x3 PayDay, x3 з/п на квестах" ;
		case 2039: itemName = "x4 PayDay, x4 з/п на квестах" ;
		case 2040: itemName = "Пополнение сытости и бесконечная сытость на: 3 ч." ;
		case 2041: itemName = "Пополнение сытости и бесконечная сытость на: 5 ч." ;
		case 2042: itemName = "Пополнение сытости и бесконечная сытость на: 8 ч." ;
		case 2043: itemName = "Пополнение сытости и бесконечная сытость на: 10 ч." ;
		case 2044: itemName = "Пополнение сытости и бесконечная сытость на: 15 ч." ;
		case 2045: itemName = "Рулетка удачи {cd7f32}Bronze{"#cWH"}" ;
		case 2046: itemName = "очки опыта организации" ;
		case ITEM_GRINDING: itemName = "Точильный камень" ;
		case 2048: itemName = "Семейный кейс" ;
		case 2049: itemName = "200.000"valute_title_"" ;
		case 2050: itemName = "300.000"valute_title_"" ;
		case 2051: itemName = "400.000"valute_title_"" ;
		case 2052: itemName = "1.000.000"valute_title_"" ;
		case 2053: itemName = "3.000.000"valute_title_"" ;
		case 2054: itemName = "5.000.000"valute_title_"" ;
		case 2055: itemName = "Рулетка удачи {c8c8c8}Silver{"#cWH"}" ;
		case ITEM_SUPER_SHARPENING: itemName = "Супер-заточка" ;
		//case 2057: itemName = "Рулетка удачи {c8c8c8}Silver{"#cWH"} (3 шт.)" ;
		case 2058: itemName = "149 доната" ;
		case 2059: itemName = "199 доната" ;
		case 2060: itemName = "249 доната" ;
		case 2061: itemName = "299 доната" ;
		case 2062: itemName = "349 доната" ;
		case 2063: itemName = "399 доната" ;
		case 2064: itemName = "449 доната" ;
		case 2065: itemName = "499 доната" ;
		case 2066: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( 559 ) ) ;
		case 2067: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( 550 ) ) ;
		case 2068: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( 502 ) ) ;
		case 2069: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( 412 ) ) ;
		case 2070: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( 494 ) ) ;
		case 2071: format ( itemName, sizeof itemName, "Машина %s", GetVehicleNameEx ( 451 ) ) ;
		case 2072: itemName = "5 очков опыта" ;
		case 2073: itemName = "7 очков опыта" ;
		case 2074: itemName = "10 очков опыта" ;
		case 2075: itemName = "Белая маска" ;
		case 2076: itemName = "Красная маска" ;
		case 2077: itemName = "Зелёная маска" ;
		case 2078: itemName = "Синяя каска" ;
		case 2079: itemName = "Красная каска" ;
		case 2080: itemName = "Зелёная каска" ;
		case 2081: itemName = "Чёрная гитара" ;
		case 2082: itemName = "Белая гитара" ;
		case 2083: itemName = "Красная гитара" ;
		case 2084: itemName = "Водительские права" ;
		case 2085: itemName = "Лицензия пилота" ;
		case 2086: itemName = "Лицензия на водный транспорт" ;
		case 2087: itemName = "Лицензия на оружие" ;
		case 2088: itemName = "Навык SDPistol" ;
		case 2089: itemName = "Навык Deagle" ;
		case 2090: itemName = "Навык ShotGun" ;
		case 2091: itemName = "Навык MP5" ;
		case 2092: itemName = "Навык AK47" ;
		case 2093: itemName = "Навык M4A1" ;
		case 2094: itemName = "Навык Rifle" ;
		case 2095: itemName = "Карта кладов на: 3 ч." ;
		case 2096: itemName = "Карта кладов на: 5 ч." ;
		case 2097: itemName = "Карта кладов на: 7 ч." ;
		case 2098: itemName = "Карта кладов на: 10 ч." ;

		case 2122: itemName = "Скидочный талон (Бизнес)" ;
		case 2123: itemName = "Скидочный талон (Дом)" ;
		case 2124: itemName = "Скидочный талон (Транспорт)" ;

		case 2125: itemName = "Рулетка удачи {c3900a}Gold{"#cWH"}" ;
		//case 2126: itemName = "Рулетка удачи {c3900a}Gold{"#cWH"} (2 шт.)" ;
		//case 2127: itemName = "Рулетка удачи {c3900a}Gold{"#cWH"} (3 шт.)" ;
		
		case 2128: itemName = "Талон КПЗ на: 10 мин." ;
		case 2129: itemName = "Талон КПЗ на: 20 мин." ;
		case 2130: itemName = "Талон КПЗ на: 30 мин." ;
		
		case 2131: itemName = "Талон бана чата на: 10 мин." ;
		case 2132: itemName = "Талон бана чата на: 20 мин." ;
		case 2133: itemName = "Талон бана чата на: 30 мин." ;
		
		case 2134: itemName = "VIP {c3900a}Gold{"#cWH"} (3 дн.)" ;
		case 2135: itemName = "VIP {c3900a}Gold{"#cWH"} (5 дн.)" ;
		case 2136: itemName = "VIP {c3900a}Gold{"#cWH"} (7 дн.)" ;
		case 2137: itemName = "VIP {c3900a}Gold{"#cWH"} (10 дн.)" ;
		
		case 2138: itemName = "Кейс дальнобойщика" ;
		case 2139: itemName = "Кейс инкассатора" ;
		case 2140: itemName = "Кейс курьера" ;
		case 2141: itemName = "Кейс завода" ;
		case 2142: itemName = "Кейс доставщика" ;
		case 2143: itemName = "Кейс лесопилки" ;
		case 2144: itemName = "Кейс шахтёра" ;
		
		case ITEM_AID_KIT: itemName = "Аптечка" ;
		case 2146: itemName = "Бинт" ;
		case 2147: itemName = "Шина" ;
		case 2148: itemName = "Аспирин" ;
		case 2149: itemName = "Морфий" ;
		case 2150: itemName = "Адреналин" ;
		case 2151: itemName = "Лекарство" ;
		case 2152: itemName = "Витамин" ;
		
		case 2153: itemName = "Металл" ;
		case 2154: itemName = "Патроны" ;
		case 2155: itemName = "Наркотики" ;
		case 2156: itemName = "Рем. комплект" ;
		case 2157: itemName = "Канистра" ;
		case 2158: itemName = "Маска" ;
		case 2159: itemName = "Семяна наркотиков" ;
		case 2160: itemName = "Верёвка" ;
		case 2161: itemName = "Скрепка" ;
		case 2162: itemName = "GPS трекер" ;
		case 2163: itemName = "Справочник" ;

		case 2164: itemName = "Ящик с Desert Eagle" ;
		case 2165: itemName = "Ящик с AK47" ;
		case 2166: itemName = "Ящик с M4A1" ;
		case 2167: itemName = "Ящик с патронами" ;
		case 2168: itemName = "Ящик с бронежилетами" ;
		case 2169: itemName = "Ящик с Silenced 9mm" ;
		case 2170: itemName = "Ящик с Shotgun" ;
		case 2172: itemName = "Ящик с аптечками" ;
		
		case ITEM_MILITARY_ID: itemName = "Военный билет" ;
		case ITEM_PASSPORT: itemName = "Паспорт" ;
		case 2220, 2222, 2223: itemName = "Удостоверение" ;
		case 2221: itemName = "Мед. карта" ;
		case 2224: itemName = "Лицензии" ;
		
		case 2174: itemName = "Battle Pass Premium" ;
		case 2175: itemName = "Battle Pass +1 lvl" ;
		case 2176: itemName = "Лимит заданий" ;
		case 2177: itemName = "Лимит заданий (Прив.)" ;
		
		case 2178: itemName = "Скидка на дом 10%" ;
		case 2179: itemName = "Скидка на дом 30%" ;
		case 2180: itemName = "Скидка на дом 50%" ;
		case 2181: itemName = "Скидка на бизнес 10%" ;
		case 2182: itemName = "Скидка на бизнес 30%" ;
		case 2183: itemName = "Скидка на бизнес 50%" ;
		case 2184: itemName = "Скидка на Battle Pass 10%" ;
		case 2185: itemName = "Скидка на Battle Pass 30%" ;
		case 2186: itemName = "Скидка на Battle Pass 50%" ;
		
		case 2190: itemName = "Ларец Fortnite" ;
		case 2191: itemName = "Ларец Star Wars" ;
		case 2192: itemName = "Ларец Zombie" ;
		case 2193: itemName = "Радужный ларец" ;
		case 2194: itemName = "Ларец демона" ;
		case 2195: itemName = "Ларец зомби" ;
		case 2196: itemName = "Ядовитый ларец" ;

		case ITEM_CASKET_BUS: itemName = "Ларец автобусника" ;
		case ITEM_CASKET_TRUCK: itemName = "Ларец дальнобойщика" ;
		case ITEM_CASKET_DELIVERY: itemName = "Ларец доставщика" ;
		case ITEM_CASKET_CLADMAN: itemName = "Ларец кладоискателя" ;
		case ITEM_CASKET_FISHMAN: itemName = "Ларец рыболова" ;
		case ITEM_CASKET_FRACTION: itemName = "Ларец организации" ;
		case ITEM_CASKET_FAMILY: itemName = "Ларец семьи" ;

		case 2200: itemName = "Камень космоса" ;
		case 2201: itemName = "Камень души" ;
		case 2202: itemName = "Камень реальности" ;
		case 2203: itemName = "Камень времени" ;
		case 2204: itemName = "Камень силы" ;
		case 2205: itemName = "Камень разума" ;

		case 2250: itemName = "Номерной знак" ;

		case 2251: itemName = "Колонка" ;
		case ITEM_FAMILY_TALON: itemName = ""family_title"" ;
		case 2253: itemName = ""event_coins"" ;
		case ITEM_CASINO_CHIPS: itemName = "Фишки" ;
		case ITEM_SIM_CARD: itemName = "SIM-карта" ;
		case 2256: itemName = "JBL-колонка" ;

		case 331: itemName = "Кастет" ;
		case 333: itemName = "Клюшка" ;
		case 334: itemName = "Полицейская дубинка" ;
		case 335: itemName = "Нож" ;
		case 336: itemName = "Бейсбольная бита" ;
		case 337: itemName = "Лопата" ;
		case 338: itemName = "Кий" ;
		case 339: itemName = "Катана" ;
		case 341: itemName = "Бензопила" ;
		case 321: itemName = "Розовый дилдо" ;
		case 322: itemName = "Дилдо" ;
		case 323: itemName = "Вибратор" ;
		case 324: itemName = "Серебряный вибратор" ;
		case 325: itemName = "Букет цветов" ;
		case 326: itemName = "Трость" ;
		case 342: itemName = "Граната" ;
		case 343: itemName = "Дымовая граната" ;
		case 346: itemName = "Colt-45" ;
		case 347: itemName = "Silenced 9mm" ;
		case 348: itemName = "Desert Eagle" ;
		case 349: itemName = "Shotgun" ;
		case 350: itemName = "Sawnoff" ;
		case 351: itemName = "Combat" ;
		case 352: itemName = "Uzi" ;
		case 353: itemName = "MP5" ;
		case 355: itemName = "AK-47" ;
		case 356: itemName = "M4A1" ;
		case 372: itemName = "Tec-9" ;
		case 357: itemName = "Country Rifle" ;
		case 358: itemName = "Sniper Rifle" ;
		case 359: itemName = "RPG" ;
		case 360: itemName = "HS Rocket" ;
		case 361: itemName = "Flamethrower" ;
		case 362: itemName = "Minigun" ;
		case 363: itemName = "Satchel Charge" ;
		case 364: itemName = "Detonator" ;
		case 365: itemName = "Spraycan" ;
		case 366: itemName = "Fire Extinguisher" ;
		case 367: itemName = "Camera" ;

		case 3500: itemName = "AWP Silver" ; // donate case
		case 3501: itemName = "AWP Red" ; // donate case
		case 3502: itemName = "AWP Anime" ;
		case 3503: itemName = "Gold AK-47" ; // donate case
		case 3504: itemName = "Dragon AK-47" ; // donate case
		case 3505: itemName = "Blue AK-47" ;
		case 3506: itemName = "Impulse AK-47" ;
		case 3507: itemName = "Blood Rifle" ; // donate case
		case 3508: itemName = "Silver Rifle" ;
		case 3509: itemName = "Energy Rifle" ;
		case 3510: itemName = "White AK-74" ;
		case 3511: itemName = "CS AK-74" ; // donate case
		case 3512: itemName = "Flower Mak" ;
		case 3513: itemName = "CS Mak" ; // donate case
		case 3514: itemName = "Death Mak" ;
		case 3515: itemName = "Eye Dragon" ; // donate case
		case 3516: itemName = "Impulse ShotGun" ;
		case 3517: itemName = "Rainbow ShotGun" ;
		case 3518: itemName = "Dragon ShotGun" ; // donate case
		case 3519: itemName = "Teeth ShotGun" ;
		case 3520: itemName = "Snow UMP" ;
		case 3521: itemName = "Red arrow UMP" ;
		case 3522: itemName = "Dice UMP" ;
		case 3523: itemName = "Monster UMP" ;
		
		case 400..611: format ( itemName, sizeof itemName, "%s (Т/С)", GetVehicleNameEx ( INVALID_VEHICLE_ID, modelId ) ) ;
		case 3200..3400: format ( itemName, sizeof itemName, "%s (Т/С)", GetVehicleNameEx ( INVALID_VEHICLE_ID, modelId ) ) ;
		
		case 1242: itemName = "Бронежилет (1 уровень)" ;
		case 1243: itemName = "Бронежилет (2 уровень)" ;
		case 1244: itemName = "Бронежилет (3 уровень)" ;
		
		case 905: itemName = "Камень" ;
		case 19941: itemName = "Золото" ;
		case 1463: itemName = "Древесина" ;
		case 2684: itemName = "Хлопок" ;
		case 1080: itemName = "Колесо" ;
		case 1018: itemName = "Выхлопная труба" ;
		case 1038: itemName = "Элемент крыши" ;
		case 1140: itemName = "Бампер" ;
		case 1165: itemName = "Задний бампер" ;
		case 19773: itemName = "Фрагмент ключа" ;
		case 11746: itemName = "Ключ от тюрьмы" ;

		default: format ( itemName, sizeof itemName, "Аксессуар %s", get_accessorie_name ( modelId ) ) ;
	}
	return itemName ;
}

stock item_price ( modelId )
{
	new itemPrice ;
	switch ( modelId )
	{
		//case 0..300: format ( _item_name, sizeof _item_name, "Одежда #%d", item_id ) ;
	    case ITEM_2_EXP: itemPrice = 5000 ;
		case 2001: itemPrice = 8000 ;
		case 2002: itemPrice = 10000 ;
		case 2003: itemPrice = 500000 ;
		case 2004: itemPrice = 800 ;
		case 2005: itemPrice = 4200 ;
		case 2006: itemPrice = 8000 ;
		case 2007: itemPrice = 42000 ;
		case 2008: itemPrice = 80000 ;
		case 2009: itemPrice = 142000 ;
		case 2010: itemPrice = GetModelPrice ( 400 ) ;
		case 2011: itemPrice = GetModelPrice ( 439 ) ;
		case 2012: itemPrice = GetModelPrice ( 522 ) ;
		case 2013: itemPrice = GetModelPrice ( 446 ) ;
		case 2014: itemPrice = GetModelPrice ( 493 ) ;
		case 2015: itemPrice = convertion_price * 9 ;
		case 2016: itemPrice = convertion_price * 19 ;
		case 2017: itemPrice = convertion_price * 29 ;
		case 2018: itemPrice = convertion_price * 39 ;
		case 2019: itemPrice = convertion_price * 49 ;
		case 2020: itemPrice = convertion_price * 59 ;
		case 2021: itemPrice = convertion_price * 69 ;
		case 2022: itemPrice = convertion_price * 79 ;
		case 2023: itemPrice = convertion_price * 89 ;
		case 2024: itemPrice = convertion_price * ( 16 * 3 ) ;
		case 2025: itemPrice = convertion_price * ( 16 * 5 ) ;
		case 2026: itemPrice = convertion_price * ( 16 * 7 ) ;
		case 2027: itemPrice = convertion_price * ( 16 * 10 ) ;
		case 2028: itemPrice = convertion_price * ( 33 * 3 ) ;
		case 2029: itemPrice = convertion_price * ( 33 * 5 ) ;
		case 2030: itemPrice = convertion_price * ( 33 * 7 ) ;
		case 2031: itemPrice = convertion_price * ( 33 * 10 ) ;
		case 2032: itemPrice = 200000 ;
		case 2033: itemPrice = 300000 ;
		case 2034: itemPrice = 400000 ;
		case 2035: itemPrice = convertion_price * 150 ;
		case 2036: itemPrice = convertion_price * 200 ;
		case 2037: itemPrice = 20000 ;
		case 2038: itemPrice = 30000 ;
		case 2039: itemPrice = 40000 ;
		case 2040: itemPrice = 30000 ;
		case 2041: itemPrice = 50000 ;
		case 2042: itemPrice = 80000 ;
		case 2043: itemPrice = 100000 ;
		case 2044: itemPrice = 150000 ;
		case 2045: itemPrice = convertion_price * ( 100 * 1 ) ;
		case 2046: itemPrice = 0 ;
		//case ITEM_GRINDING: itemPrice = convertion_price * ( 100 * 3 ) ;
		case 2048: itemPrice = 5000000 ;
		case 2049: itemPrice = 200000 ;
		case 2050: itemPrice = 300000 ;
		case 2051: itemPrice = 400000 ;
		case 2052: itemPrice = 1000000 ;
		case 2053: itemPrice = 3000000 ;
		case 2054: itemPrice = 5000000 ;
		case 2055: itemPrice = convertion_price * ( 150 * 1 ) ;
		//case ITEM_SUPER_SHARPENING: itemPrice = convertion_price * ( 150 * 2 ) ;
		case 2057: itemPrice = convertion_price * ( 150 * 3 ) ;
		case 2058: itemPrice = convertion_price * 149 ;
		case 2059: itemPrice = convertion_price * 199 ;
		case 2060: itemPrice = convertion_price * 249 ;
		case 2061: itemPrice = convertion_price * 299 ;
		case 2062: itemPrice = convertion_price * 349 ;
		case 2063: itemPrice = convertion_price * 399 ;
		case 2064: itemPrice = convertion_price * 449 ;
		case 2065: itemPrice = convertion_price * 499 ;
		case 2066: itemPrice = GetModelPrice ( 559 ) ;
		case 2067: itemPrice = GetModelPrice ( 541 ) ;
		case 2068: itemPrice = GetModelPrice ( 502 ) ;
		case 2069: itemPrice = GetModelPrice ( 503 ) ;
		case 2070: itemPrice = GetModelPrice ( 494 ) ;
		case 2071: itemPrice = GetModelPrice ( 451 ) ;
		case 2072: itemPrice = convertion_price * 5 ;
		case 2073: itemPrice = convertion_price * 7 ;
		case 2074: itemPrice = convertion_price * 10 ;
		case 2075: itemPrice = 1500000 ;
		case 2076: itemPrice = 1500000 ;
		case 2077: itemPrice = 1500000 ;
		case 2078: itemPrice = 1500000 ;
		case 2079: itemPrice = 1500000 ;
		case 2080: itemPrice = 1500000 ;
		case 2081: itemPrice = 1500000 ;
		case 2082: itemPrice = 1500000 ;
		case 2083: itemPrice = 1500000 ;
		case 2084: itemPrice = convertion_price * 25 ;
		case 2085: itemPrice = convertion_price * 25 ;
		case 2086: itemPrice = convertion_price * 25 ;
		case 2087: itemPrice = convertion_price * 25 ;
		case 2088: itemPrice = convertion_price * 25 ;
		case 2089: itemPrice = convertion_price * 25 ;
		case 2090: itemPrice = convertion_price * 25 ;
		case 2091: itemPrice = convertion_price * 25 ;
		case 2092: itemPrice = convertion_price * 25 ;
		case 2093: itemPrice = convertion_price * 25 ;
		case 2094: itemPrice = convertion_price * 25 ;
		case 2095: itemPrice = 30000 ;
		case 2096: itemPrice = 50000 ;
		case 2097: itemPrice = 80000 ;
		case 2098: itemPrice = 100000 ;
		case 2099: itemPrice = 150000 ;
		case 2125: itemPrice = convertion_price * ( 200 * 1 ) ;
		case 2126: itemPrice = convertion_price * ( 200 * 2 ) ;
		case 2127: itemPrice = convertion_price * ( 200 * 3 ) ;
		case 400..611, 3200..3400: itemPrice = GetModelPrice ( modelId ) ;
		/*default:
		{
			if ( item_id >= skin_cross )
				format ( _item_name, sizeof _item_name, "Одежда #%d", item_id - skin_cross ) ;

			else
			    format ( _item_name, sizeof _item_name, "Аксессуар %s", get_accessorie_name ( item_id ) ) ;
		}*/
		default: itemPrice = 0 ;
	}
	return itemPrice ;
}

stock item_render_type ( modelId )
{
	new itemRenderType ;
	switch ( modelId )
	{
		case 0..300: itemRenderType = RENDER_TYPE_SKINS ;
	    case ITEM_2_EXP: itemRenderType = NON_RENDER_TYPE ;
		case 2001: itemRenderType = NON_RENDER_TYPE ;
		case 2002: itemRenderType = NON_RENDER_TYPE ;
		case 2003: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2004: itemRenderType = NON_RENDER_TYPE ;
		case 2005: itemRenderType = NON_RENDER_TYPE ;
		case 2006: itemRenderType = NON_RENDER_TYPE ;
		case 2007: itemRenderType = NON_RENDER_TYPE ;
		case 2008: itemRenderType = NON_RENDER_TYPE ;
		case 2009: itemRenderType = NON_RENDER_TYPE ;

		case 2010: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2011: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2012: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2013: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2014: itemRenderType = RENDER_TYPE_VEHICLE ;

		case 2015: itemRenderType = NON_RENDER_TYPE ;
		case 2016: itemRenderType = NON_RENDER_TYPE ;
		case 2017: itemRenderType = NON_RENDER_TYPE ;
		case 2018: itemRenderType = NON_RENDER_TYPE ;
		case 2019: itemRenderType = NON_RENDER_TYPE ;
		case 2020: itemRenderType = NON_RENDER_TYPE ;
		case 2021: itemRenderType = NON_RENDER_TYPE ;
		case 2022: itemRenderType = NON_RENDER_TYPE ;
		case 2023: itemRenderType = NON_RENDER_TYPE ;

		case 2024: itemRenderType = NON_RENDER_TYPE ;
		case 2025: itemRenderType = NON_RENDER_TYPE ;
		case 2026: itemRenderType = NON_RENDER_TYPE ;
		case 2027: itemRenderType = NON_RENDER_TYPE ;
		case 2028: itemRenderType = NON_RENDER_TYPE ;
		case 2029: itemRenderType = NON_RENDER_TYPE ;
		case 2030: itemRenderType = NON_RENDER_TYPE ;
		case 2031: itemRenderType = NON_RENDER_TYPE ;

		case 2032: itemRenderType = NON_RENDER_TYPE ;
		case 2033: itemRenderType = NON_RENDER_TYPE ;
		case 2034: itemRenderType = NON_RENDER_TYPE ;

		case 2035: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2036: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2037: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2038: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2039: itemRenderType = RENDER_TYPE_OBJECT ;

		case 2040: itemRenderType = NON_RENDER_TYPE ;
		case 2041: itemRenderType = NON_RENDER_TYPE ;
		case 2042: itemRenderType = NON_RENDER_TYPE ;
		case 2043: itemRenderType = NON_RENDER_TYPE ;
		case 2044: itemRenderType = NON_RENDER_TYPE ;
		case 2045: itemRenderType = NON_RENDER_TYPE ;
		case 2046: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_GRINDING: itemRenderType = NON_RENDER_TYPE ;

		case 2048: itemRenderType = RENDER_TYPE_OBJECT ;

		case 2049: itemRenderType = NON_RENDER_TYPE ;
		case 2050: itemRenderType = NON_RENDER_TYPE ;
		case 2051: itemRenderType = NON_RENDER_TYPE ;
		case 2052: itemRenderType = NON_RENDER_TYPE ;
		case 2053: itemRenderType = NON_RENDER_TYPE ;
		case 2054: itemRenderType = NON_RENDER_TYPE ;
		case 2055: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_SUPER_SHARPENING: itemRenderType = NON_RENDER_TYPE ;

		case 2057: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2058: itemRenderType = NON_RENDER_TYPE ;
		case 2059: itemRenderType = NON_RENDER_TYPE ;
		case 2060: itemRenderType = NON_RENDER_TYPE ;
		case 2061: itemRenderType = NON_RENDER_TYPE ;
		case 2062: itemRenderType = NON_RENDER_TYPE ;
		case 2063: itemRenderType = NON_RENDER_TYPE ;
		case 2064: itemRenderType = NON_RENDER_TYPE ;
		case 2065: itemRenderType = NON_RENDER_TYPE ;

		case 2066: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2067: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2068: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2069: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2070: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 2071: itemRenderType = RENDER_TYPE_VEHICLE ;

		case 2072: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2073: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2074: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2075: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2076: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2077: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2078: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2079: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2080: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2081: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2082: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2083: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2084: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2085: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2086: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2087: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2088: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2089: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2090: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2091: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2092: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2093: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2094: itemRenderType = RENDER_TYPE_OBJECT ;

		case 2095: itemRenderType = NON_RENDER_TYPE ;
		case 2096: itemRenderType = NON_RENDER_TYPE ;
		case 2097: itemRenderType = NON_RENDER_TYPE ;
		case 2098: itemRenderType = NON_RENDER_TYPE ;
		case 2125: itemRenderType = NON_RENDER_TYPE ;

		case 2126: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2127: itemRenderType = RENDER_TYPE_OBJECT ;

		case 2128: itemRenderType = NON_RENDER_TYPE ;
		case 2129: itemRenderType = NON_RENDER_TYPE ;
		case 2130: itemRenderType = NON_RENDER_TYPE ;
		case 2131: itemRenderType = NON_RENDER_TYPE ;
		case 2132: itemRenderType = NON_RENDER_TYPE ;
		case 2133: itemRenderType = NON_RENDER_TYPE ;
		case 2134: itemRenderType = NON_RENDER_TYPE ;
		case 2135: itemRenderType = NON_RENDER_TYPE ;
		case 2136: itemRenderType = NON_RENDER_TYPE ;
		case 2137: itemRenderType = NON_RENDER_TYPE ;
		case 2138: itemRenderType = NON_RENDER_TYPE ;
		case 2139: itemRenderType = NON_RENDER_TYPE ;
		case 2140: itemRenderType = NON_RENDER_TYPE ;
		case 2141: itemRenderType = NON_RENDER_TYPE ;
		case 2142: itemRenderType = NON_RENDER_TYPE ;
		case 2143: itemRenderType = NON_RENDER_TYPE ;
		case 2144: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_AID_KIT: itemRenderType = NON_RENDER_TYPE ;
		case 2146: itemRenderType = NON_RENDER_TYPE ;
		case 2147: itemRenderType = NON_RENDER_TYPE ;
		case 2148: itemRenderType = NON_RENDER_TYPE ;
		case 2149: itemRenderType = NON_RENDER_TYPE ;
		case 2150: itemRenderType = NON_RENDER_TYPE ;
		case 2151: itemRenderType = NON_RENDER_TYPE ;
		case 2152: itemRenderType = NON_RENDER_TYPE ;
		case 2153: itemRenderType = NON_RENDER_TYPE ;
		case 2154: itemRenderType = NON_RENDER_TYPE ;
		case 2155: itemRenderType = NON_RENDER_TYPE ;
		case 2156: itemRenderType = NON_RENDER_TYPE ;
		case 2157: itemRenderType = NON_RENDER_TYPE ;
		case 2158: itemRenderType = NON_RENDER_TYPE ;
		case 2159: itemRenderType = NON_RENDER_TYPE ;
		case 2160: itemRenderType = NON_RENDER_TYPE ;
		case 2161: itemRenderType = NON_RENDER_TYPE ;
		case 2162: itemRenderType = NON_RENDER_TYPE ;
		case 2163: itemRenderType = NON_RENDER_TYPE ;
		case 2164: itemRenderType = NON_RENDER_TYPE ;
		case 2165: itemRenderType = NON_RENDER_TYPE ;
		case 2166: itemRenderType = NON_RENDER_TYPE ;
		case 2167: itemRenderType = NON_RENDER_TYPE ;
		case 2168: itemRenderType = NON_RENDER_TYPE ;
		case 2169: itemRenderType = NON_RENDER_TYPE ;
		case 2170: itemRenderType = NON_RENDER_TYPE ;
		case 2172: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_MILITARY_ID: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_PASSPORT: itemRenderType = NON_RENDER_TYPE ;
		case 2220, 2222, 2223: itemRenderType = NON_RENDER_TYPE ;
		case 2221: itemRenderType = NON_RENDER_TYPE ;
		case 2224: itemRenderType = NON_RENDER_TYPE ;
		case 2174: itemRenderType = NON_RENDER_TYPE ;
		case 2175: itemRenderType = NON_RENDER_TYPE ;
		case 2176: itemRenderType = NON_RENDER_TYPE ;
		case 2177: itemRenderType = NON_RENDER_TYPE ;
		case 2178: itemRenderType = NON_RENDER_TYPE ;
		case 2179: itemRenderType = NON_RENDER_TYPE ;
		case 2180: itemRenderType = NON_RENDER_TYPE ;
		case 2181: itemRenderType = NON_RENDER_TYPE ;
		case 2182: itemRenderType = NON_RENDER_TYPE ;
		case 2183: itemRenderType = NON_RENDER_TYPE ;
		case 2184: itemRenderType = NON_RENDER_TYPE ;
		case 2185: itemRenderType = NON_RENDER_TYPE ;
		case 2186: itemRenderType = NON_RENDER_TYPE ;
		case 2190: itemRenderType = NON_RENDER_TYPE ;
		case 2191: itemRenderType = NON_RENDER_TYPE ;
		case 2192: itemRenderType = NON_RENDER_TYPE ;

		case 2193: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2194: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2195: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2196: itemRenderType = RENDER_TYPE_OBJECT ;

		case ITEM_CASKET_BUS: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASKET_TRUCK: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASKET_DELIVERY: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASKET_CLADMAN: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASKET_FISHMAN: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASKET_FRACTION: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASKET_FAMILY: itemRenderType = NON_RENDER_TYPE ;

		case 2200: itemRenderType = NON_RENDER_TYPE ;
		case 2201: itemRenderType = NON_RENDER_TYPE ;
		case 2202: itemRenderType = NON_RENDER_TYPE ;
		case 2203: itemRenderType = NON_RENDER_TYPE ;
		case 2204: itemRenderType = NON_RENDER_TYPE ;
		case 2205: itemRenderType = NON_RENDER_TYPE ;

		case 2250: itemRenderType = RENDER_TYPE_PLATE ;

		case ITEM_FAMILY_TALON: itemRenderType = NON_RENDER_TYPE ;
		case 2253: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_CASINO_CHIPS: itemRenderType = NON_RENDER_TYPE ;
		case ITEM_SIM_CARD: itemRenderType = NON_RENDER_TYPE ;
		case 2256: itemRenderType = NON_RENDER_TYPE ;

		case 400..611: itemRenderType = RENDER_TYPE_VEHICLE ;
		case 3200..3400: itemRenderType = RENDER_TYPE_VEHICLE ;

		case 1242: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1243: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1244: itemRenderType = RENDER_TYPE_OBJECT ;
		case 905: itemRenderType = RENDER_TYPE_OBJECT ;
		case 19941: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1463: itemRenderType = RENDER_TYPE_OBJECT ;
		case 2684: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1080: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1018: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1038: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1140: itemRenderType = RENDER_TYPE_OBJECT ;
		case 1165: itemRenderType = RENDER_TYPE_OBJECT ;
		case 19773: itemRenderType = RENDER_TYPE_OBJECT ;
		case 11746: itemRenderType = RENDER_TYPE_OBJECT ;
		
		case 331: itemRenderType = NON_RENDER_TYPE ;
		case 333: itemRenderType = NON_RENDER_TYPE ;
		case 334: itemRenderType = NON_RENDER_TYPE ;
		case 335: itemRenderType = NON_RENDER_TYPE ;
		case 336: itemRenderType = NON_RENDER_TYPE ;
		case 337: itemRenderType = NON_RENDER_TYPE ;
		case 338: itemRenderType = NON_RENDER_TYPE ;
		case 339: itemRenderType = NON_RENDER_TYPE ;
		case 341: itemRenderType = NON_RENDER_TYPE ;
		case 321: itemRenderType = NON_RENDER_TYPE ;
		case 322: itemRenderType = NON_RENDER_TYPE ;
		case 323: itemRenderType = NON_RENDER_TYPE ;
		case 324: itemRenderType = NON_RENDER_TYPE ;
		case 325: itemRenderType = NON_RENDER_TYPE ;
		case 326: itemRenderType = NON_RENDER_TYPE ;
		case 342: itemRenderType = NON_RENDER_TYPE ;
		case 343: itemRenderType = NON_RENDER_TYPE ;
		case 346: itemRenderType = NON_RENDER_TYPE ;
		case 347: itemRenderType = NON_RENDER_TYPE ;
		case 348: itemRenderType = NON_RENDER_TYPE ;
		case 349: itemRenderType = NON_RENDER_TYPE ;
		case 350: itemRenderType = NON_RENDER_TYPE ;
		case 351: itemRenderType = NON_RENDER_TYPE ;
		case 352: itemRenderType = NON_RENDER_TYPE ;
		case 353: itemRenderType = NON_RENDER_TYPE ;
		case 355: itemRenderType = NON_RENDER_TYPE ;
		case 356: itemRenderType = NON_RENDER_TYPE ;
		case 372: itemRenderType = NON_RENDER_TYPE ;
		case 357: itemRenderType = NON_RENDER_TYPE ;
		case 358: itemRenderType = NON_RENDER_TYPE ;
		case 359: itemRenderType = NON_RENDER_TYPE ;
		case 360: itemRenderType = NON_RENDER_TYPE ;
		case 361: itemRenderType = NON_RENDER_TYPE ;
		case 362: itemRenderType = NON_RENDER_TYPE ;
		case 363: itemRenderType = NON_RENDER_TYPE ;
		case 364: itemRenderType = NON_RENDER_TYPE ;
		case 365: itemRenderType = NON_RENDER_TYPE ;
		case 366: itemRenderType = NON_RENDER_TYPE ;
		case 367: itemRenderType = NON_RENDER_TYPE ;

		/*case 3500: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3501: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3502: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3503: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3504: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3505: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3506: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3507: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3508: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3509: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3510: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3511: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3512: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3513: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3514: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3515: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3516: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3517: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3518: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3519: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3520: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3521: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3522: itemRenderType = RENDER_TYPE_WEAPON ;
		case 3523: itemRenderType = RENDER_TYPE_WEAPON ;*/

		case 3500: itemRenderType = NON_RENDER_TYPE ;
		case 3501: itemRenderType = NON_RENDER_TYPE ;
		case 3502: itemRenderType = NON_RENDER_TYPE ;
		case 3503: itemRenderType = NON_RENDER_TYPE ;
		case 3504: itemRenderType = NON_RENDER_TYPE ;
		case 3505: itemRenderType = NON_RENDER_TYPE ;
		case 3506: itemRenderType = NON_RENDER_TYPE ;
		case 3507: itemRenderType = NON_RENDER_TYPE ;
		case 3508: itemRenderType = NON_RENDER_TYPE ;
		case 3509: itemRenderType = NON_RENDER_TYPE ;
		case 3510: itemRenderType = NON_RENDER_TYPE ;
		case 3511: itemRenderType = NON_RENDER_TYPE ;
		case 3512: itemRenderType = NON_RENDER_TYPE ;
		case 3513: itemRenderType = NON_RENDER_TYPE ;
		case 3514: itemRenderType = NON_RENDER_TYPE ;
		case 3515: itemRenderType = NON_RENDER_TYPE ;
		case 3516: itemRenderType = NON_RENDER_TYPE ;
		case 3517: itemRenderType = NON_RENDER_TYPE ;
		case 3518: itemRenderType = NON_RENDER_TYPE ;
		case 3519: itemRenderType = NON_RENDER_TYPE ;
		case 3520: itemRenderType = NON_RENDER_TYPE ;
		case 3521: itemRenderType = NON_RENDER_TYPE ;
		case 3522: itemRenderType = NON_RENDER_TYPE ;
		case 3523: itemRenderType = NON_RENDER_TYPE ;

		default:
		{
			itemRenderType = RENDER_TYPE_OBJECT ;
		}
	}
	return itemRenderType ;
}

stock item_object_id ( modelId )
{
	new itemModel ;
	switch ( modelId )
	{
		case -1: itemModel = -1 ;
		case 0..300: itemModel = modelId ;
	    case ITEM_2_EXP: itemModel = 2 ;
		case 2001: itemModel = 2 ;
		case 2002: itemModel = 2 ;
		case 2003: itemModel = 1210 ;
		case 2004: itemModel = 1 ;
		case 2005: itemModel = 1 ;
		case 2006: itemModel = 1 ;
		case 2007: itemModel = 1 ;
		case 2008: itemModel = 1 ;
		case 2009: itemModel = 1 ;
		case 2010: itemModel = 400 ;
		case 2011: itemModel = 439 ;
		case 2012: itemModel = 522 ;
		case 2013: itemModel = 446 ;
		case 2014: itemModel = 493 ;
		case 2015: itemModel = 4 ;
		case 2016: itemModel = 4 ;
		case 2017: itemModel = 4 ;
		case 2018: itemModel = 4 ;
		case 2019: itemModel = 4 ;
		case 2020: itemModel = 4 ;
		case 2021: itemModel = 4 ;
		case 2022: itemModel = 4 ;
		case 2023: itemModel = 4 ;
		case 2024: itemModel = 158 ;
		case 2025: itemModel = 158 ;
		case 2026: itemModel = 158 ;
		case 2027: itemModel = 158 ;
		case 2028: itemModel = 158 ;
		case 2029: itemModel = 158 ;
		case 2030: itemModel = 158 ;
		case 2031: itemModel = 158 ;
		case 2032: itemModel = 1 ;
		case 2033: itemModel = 1 ;
		case 2034: itemModel = 1 ;
		case 2035: itemModel = 11736 ;
		case 2036: itemModel = 11736 ;
		case 2037: itemModel = 18876 ;
		case 2038: itemModel = 18876 ;
		case 2039: itemModel = 18876 ;
		case 2040: itemModel = 182 ;
		case 2041: itemModel = 182 ;
		case 2042: itemModel = 182 ;
		case 2043: itemModel = 182 ;
		case 2044: itemModel = 182 ;
		case 2045: itemModel = 190 ;
		case 2046: itemModel = 201 ;
		case ITEM_GRINDING: itemModel = 19 ;
		case 2048: itemModel = 1210 ;
		case 2049: itemModel = 1 ;
		case 2050: itemModel = 1 ;
		case 2051: itemModel = 1 ;
		case 2052: itemModel = 1 ;
		case 2053: itemModel = 1 ;
		case 2054: itemModel = 1 ;
		case 2055: itemModel = 191 ;
		case ITEM_SUPER_SHARPENING: itemModel = 20 ;
		case 2057: itemModel = 11744 ;
		case 2058: itemModel = 4 ;
		case 2059: itemModel = 4 ;
		case 2060: itemModel = 4 ;
		case 2061: itemModel = 4 ;
		case 2062: itemModel = 4 ;
		case 2063: itemModel = 4 ;
		case 2064: itemModel = 4 ;
		case 2065: itemModel = 4 ;
		case 2066: itemModel = 559 ;
		case 2067: itemModel = 550 ;
		case 2068: itemModel = 502 ;
		case 2069: itemModel = 412 ;
		case 2070: itemModel = 494 ;
		case 2071: itemModel = 451 ;
		case 2072: itemModel = 2684 ;
		case 2073: itemModel = 2684 ;
		case 2074: itemModel = 2684 ;
		case 2075: itemModel = 19036 ;
		case 2076: itemModel = 19037 ;
		case 2077: itemModel = 19038 ;
		case 2078: itemModel = 18938 ;
		case 2079: itemModel = 18937 ;
		case 2080: itemModel = 19118 ;
		case 2081: itemModel = 19319 ;
		case 2082: itemModel = 19318 ;
		case 2083: itemModel = 19317 ;
		case 2084: itemModel = 11736 ;
		case 2085: itemModel = 11736 ;
		case 2086: itemModel = 11736 ;
		case 2087: itemModel = 11736 ;
		case 2088: itemModel = 347 ;
		case 2089: itemModel = 348 ;
		case 2090: itemModel = 349 ;
		case 2091: itemModel = 353 ;
		case 2092: itemModel = 355 ;
		case 2093: itemModel = 356 ;
		case 2094: itemModel = 357 ;
		case 2095: itemModel = 183 ;
		case 2096: itemModel = 183 ;
		case 2097: itemModel = 183 ;
		case 2098: itemModel = 183 ;

		case 2125: itemModel = 192 ;
		case 2126: itemModel = 11744 ;
		case 2127: itemModel = 11744 ;

		case 2128: itemModel = 181 ;
		case 2129: itemModel = 181 ;
		case 2130: itemModel = 181 ;

		case 2131: itemModel = 180 ;
		case 2132: itemModel = 180 ;
		case 2133: itemModel = 180 ;
		
		case 2134: itemModel = 158 ;
		case 2135: itemModel = 158 ;
		case 2136: itemModel = 158 ;
		case 2137: itemModel = 158 ;
		
		case 2138: itemModel = 31 ;
		case 2139: itemModel = 32 ;
		case 2140: itemModel = 33 ;
		case 2141: itemModel = 34 ;
		case 2142: itemModel = 35 ;
		case 2143: itemModel = 36 ;
		case 2144: itemModel = 37 ;

		case ITEM_AID_KIT: itemModel = 89 ;
		case 2146: itemModel = 77 ;
		case 2147: itemModel = 85 ;
		case 2148: itemModel = 76 ;
		case 2149: itemModel = 82 ;
		case 2150: itemModel = 75 ;
		case 2151: itemModel = 79 ;
		case 2152: itemModel = 86 ;

		case 2153: itemModel = 81 ;
		case 2154: itemModel = 83 ;
		case 2155: itemModel = 87 ;
		case 2156: itemModel = 90 ;
		case 2157: itemModel = 91 ;
		case 2158: itemModel = 80 ;
		case 2159: itemModel = 88 ;
		case 2160: itemModel = 92 ;
		case 2161: itemModel = 93 ;
		case 2162: itemModel = 94 ;
		case 2163: itemModel = 95 ;
		
		case 2164: itemModel = 144 ;
		case 2165: itemModel = 147 ;
		case 2166: itemModel = 147 ;
		case 2167: itemModel = 145 ;
		case 2168: itemModel = 146 ;
		case 2169: itemModel = 144 ;
		case 2170: itemModel = 148 ;
		case 2172: itemModel = 150 ;
		
		case ITEM_MILITARY_ID: itemModel = 149 ;
		case ITEM_PASSPORT: itemModel = 151 ;
		case 2220, 2222, 2223: itemModel = 193 ;
		case 2221: itemModel = 194 ;
		case 2224: itemModel = 195 ;

		case 2174: itemModel = 152 ;
		case 2175: itemModel = 153 ;
		case 2176: itemModel = 154 ;
		case 2177: itemModel = 155 ;

		case 2178: itemModel = 159 ;
		case 2179: itemModel = 160 ;
		case 2180: itemModel = 161 ;
		case 2181: itemModel = 162 ;
		case 2182: itemModel = 163 ;
		case 2183: itemModel = 164 ;
		case 2184: itemModel = 165 ;
		case 2185: itemModel = 166 ;
		case 2186: itemModel = 167 ;

		case 2190: itemModel = 168 ;
		case 2191: itemModel = 169 ;
		case 2192: itemModel = 170 ;
		case 2193: itemModel = 8332 ;
		case 2194: itemModel = 8333 ;
		case 2195: itemModel = 8334 ;
		case 2196: itemModel = 5139 ;

		case ITEM_CASKET_BUS: itemModel = 203 ;
		case ITEM_CASKET_TRUCK: itemModel = 204 ;
		case ITEM_CASKET_DELIVERY: itemModel = 205 ;
		case ITEM_CASKET_CLADMAN: itemModel = 206 ;
		case ITEM_CASKET_FISHMAN: itemModel = 207 ;
		case ITEM_CASKET_FRACTION: itemModel = 208 ;
		case ITEM_CASKET_FAMILY: itemModel = 209 ;

		case 2200: itemModel = 185 ;
		case 2201: itemModel = 188 ;
		case 2202: itemModel = 184 ;
		case 2203: itemModel = 187 ;
		case 2204: itemModel = 186 ;
		case 2205: itemModel = 189 ;

		case 2250: itemModel = 250 ;
		case ITEM_FAMILY_TALON: itemModel = 198 ;
		case 2253: itemModel = 199 ;
		case ITEM_CASINO_CHIPS: itemModel = 200 ;
		case ITEM_SIM_CARD: itemModel = 57 ;
		case 2256: itemModel = 202 ;
		
		case 331: itemModel = 105 ;
		case 333: itemModel = 106 ;
		case 334: itemModel = 107 ;
		case 335: itemModel = 108 ;
		case 336: itemModel = 109 ;
		case 337: itemModel = 110 ;
		case 338: itemModel = 111 ;
		case 339: itemModel = 112 ;
		case 341: itemModel = 113 ;
		case 321: itemModel = 114 ;
		case 322: itemModel = 115 ;
		case 323: itemModel = 116 ;
		case 324: itemModel = 117 ;
		case 325: itemModel = 118 ;
		case 326: itemModel = 119 ;
		case 342: itemModel = 120 ;
		case 343: itemModel = 121 ;
		case 346: itemModel = 122 ;
		case 347: itemModel = 123 ;
		case 348: itemModel = 124 ;
		case 349: itemModel = 125 ;
		case 350: itemModel = 126 ;
		case 351: itemModel = 127 ;
		case 352: itemModel = 128 ;
		case 353: itemModel = 129 ;
		case 355: itemModel = 130 ;
		case 356: itemModel = 131 ;
		case 372: itemModel = 132 ;
		case 357: itemModel = 133 ;
		case 358: itemModel = 134 ;
		case 359: itemModel = 135 ;
		case 360: itemModel = 136 ;
		case 361: itemModel = 137 ;
		case 362: itemModel = 138 ;
		case 363: itemModel = 139 ;
		case 364: itemModel = 140 ;
		case 365: itemModel = 141 ;
		case 366: itemModel = 142 ;
		case 367: itemModel = 143 ;

		case 3500: itemModel = 51 ;
		case 3501: itemModel = 52 ;
		case 3502: itemModel = 53 ;
		case 3503: itemModel = 38 ;
		case 3504: itemModel = 39 ;
		case 3505: itemModel = 40 ;
		case 3506: itemModel = 41 ;
		case 3507: itemModel = 42 ;
		case 3508: itemModel = 43 ;
		case 3509: itemModel = 44 ;
		case 3510: itemModel = 45 ;
		case 3511: itemModel = 46 ;
		case 3512: itemModel = 47 ;
		case 3513: itemModel = 48 ;
		case 3514: itemModel = 49 ;
		case 3515: itemModel = 50 ;
		case 3516: itemModel = 62 ;
		case 3517: itemModel = 63 ;
		case 3518: itemModel = 64 ;
		case 3519: itemModel = 65 ;
		case 3520: itemModel = 58 ;
		case 3521: itemModel = 59 ;
		case 3522: itemModel = 60 ;
		case 3523: itemModel = 61 ;

		/*case 3500: itemModel = 358 ;
		case 3501: itemModel = 358 ;
		case 3502: itemModel = 358 ;
		case 3503: itemModel = 355 ;
		case 3504: itemModel = 355 ;
		case 3505: itemModel = 355 ;
		case 3506: itemModel = 355 ;
		case 3507: itemModel = 357 ;
		case 3508: itemModel = 357 ;
		case 3509: itemModel = 357 ;
		case 3510: itemModel = 356 ;
		case 3511: itemModel = 356 ;
		case 3512: itemModel = 348 ;
		case 3513: itemModel = 348 ;
		case 3514: itemModel = 348 ;
		case 3515: itemModel = 348 ;
		case 3516: itemModel = 349 ;
		case 3517: itemModel = 349 ;
		case 3518: itemModel = 349 ;
		case 3519: itemModel = 349 ;
		case 3520: itemModel = 353 ;
		case 3521: itemModel = 353 ;
		case 3522: itemModel = 353 ;
		case 3523: itemModel = 353 ;*/

		case 400..700: itemModel = modelId ; // cars

		case 1242: itemModel = 19142 ;
		case 1243: itemModel = 19142 ;
		case 1244: itemModel = 19142 ;

		case 905: itemModel = 905 ;
		case 19941: itemModel = 19941 ;
		case 1463: itemModel = 1463 ;
		case 2684: itemModel = 2684 ;
		case 1080: itemModel = 1080 ;
		case 1018: itemModel = 1018 ;
		case 1038: itemModel = 1038 ;
		case 1140: itemModel = 1140 ;
		case 1165: itemModel = 1165 ;
		case 19773: itemModel = 19773 ;
		case 11746: itemModel = 11746 ;
		default: itemModel = modelId ;
	}
	return itemModel ;
}

stock item_weapon ( modelId )
{
	new itemModel = 0 ;
	switch ( modelId )
	{
		case 3500: itemModel = 358 ;
		case 3501: itemModel = 358 ;
		case 3502: itemModel = 358 ;
		case 3503: itemModel = 355 ;
		case 3504: itemModel = 355 ;
		case 3505: itemModel = 355 ;
		case 3506: itemModel = 355 ;
		case 3507: itemModel = 357 ;
		case 3508: itemModel = 357 ;
		case 3509: itemModel = 357 ;
		case 3510: itemModel = 356 ;
		case 3511: itemModel = 356 ;
		case 3512: itemModel = 348 ;
		case 3513: itemModel = 348 ;
		case 3514: itemModel = 348 ;
		case 3515: itemModel = 348 ;
		case 3516: itemModel = 349 ;
		case 3517: itemModel = 349 ;
		case 3518: itemModel = 349 ;
		case 3519: itemModel = 349 ;
		case 3520: itemModel = 353 ;
		case 3521: itemModel = 353 ;
		case 3522: itemModel = 353 ;
		case 3523: itemModel = 353 ;
	}
	return itemModel ;
}

stock item_color ( modelId, defColor )
{
	new _color = defColor ;
	switch ( modelId )
	{
		case 3500: _color = 2 ;
		case 3501: _color = 3 ;
		case 3502: _color = 4 ;
		case 3503: _color = 6 ;
		case 3504: _color = 7 ;
		case 3505: _color = 8 ;
		case 3506: _color = 9 ;
		case 3507: _color = 11 ;
		case 3508: _color = 12 ;
		case 3509: _color = 13 ;
		case 3510: _color = 15 ;
		case 3511: _color = 16 ;
		case 3512: _color = 18 ;
		case 3513: _color = 19 ;
		case 3514: _color = 20 ;
		case 3515: _color = 21 ;
		case 3516: _color = 23 ;
		case 3517: _color = 24 ;
		case 3518: _color = 25 ;
		case 3519: _color = 26 ;
		case 3520: _color = 28 ;
		case 3521: _color = 29 ;
		case 3522: _color = 30 ;
		case 3523: _color = 31 ;
	}
	return _color ;
}

stock weapon_skins ( modelId )
{
	switch ( modelId )
	{
		case 3500: return true ;
		case 3501: return true ;
		case 3502: return true ;
		case 3503: return true ;
		case 3504: return true ;
		case 3505: return true ;
		case 3506: return true ;
		case 3507: return true ;
		case 3508: return true ;
		case 3509: return true ;
		case 3510: return true ;
		case 3511: return true ;
		case 3512: return true ;
		case 3513: return true ;
		case 3514: return true ;
		case 3515: return true ;
		case 3516: return true ;
		case 3517: return true ;
		case 3518: return true ;
		case 3519: return true ;
	}
	return false ;
}

stock item_description ( modelId, _typeColor = 0 )
{
	global_string [ 0 ] = EOS ;
	switch ( modelId )
	{
		case 905: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на шахте, свалке, у игроков или на рынке.", global_string ) ;
		case 19941: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на шахте, свалке, у игроков или на рынке.", global_string ) ;
		case 1463: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на лесопилке, свалке, у игроков или на рынке.", global_string ) ;
		case 2684: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на лесопилке, свалке, у игроков или на рынке.", global_string ) ;
		case 1080: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1018: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1038: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1140: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 1165: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nМожно добыть на работе 'разбор транспорта', свалке, у игроков или на рынке.", global_string ) ;
		case 19773: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nВыпадает при убийстве полицейского.", global_string ) ;
		case 11746: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для крафта, крафтить можно в подвале любого дома.\nНеобходим для побега из тюрьмы.", global_string ) ;
		case ITEM_GRINDING: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для заточки аксессуаров.", global_string ) ;
		case ITEM_SUPER_SHARPENING: format ( global_string, sizeof global_string, "%s{"#cWH"}Предмет нужен для заточки аксессуаров.", global_string ) ;
		default:
		{
		    new _type ;
		    for ( new i = 0 ; i < 5 ; i ++ )
		    {
				_type = get_model_type ( modelId, i ) ;
				if ( _type == MODEL_TYPE_SHOP )
				{
					if ( _typeColor == 1 ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в автосалоне.\n", global_string ) ;
					else format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в {"#cLY"}автосалоне{"#cWH"}.\n", global_string ) ;
				}
				else if ( _type == MODEL_TYPE_DONATE )
				{
					if ( _typeColor == 1 ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в /donate.\n", global_string ) ;
					else format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в {"#cLY"}/donate{"#cWH"}.\n", global_string ) ;
				}
				else if ( _type == MODEL_TYPE_BATTLE_PASS )
				{
					if ( _typeColor == 1 ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в обменнике "event_coins".\n", global_string ) ;
					else format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в {"#cLY"}обменнике "event_coins"{"#cWH"}.\n", global_string ) ;
				}
				else if ( _type == MODEL_TYPE_FAMILY )
				{
					if ( _typeColor == 1 ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в обменнике "family_title".\n", global_string ) ;
					else format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно приобрести в {"#cLY"}обменнике "family_title"{"#cWH"}.\n", global_string ) ;
				}
				else if ( _type == MODEL_TYPE_CRAFT )
				{
					if ( _typeColor == 1 ) format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно скрафтить в подвале любого дома.\n", global_string ) ;
					else format ( global_string, sizeof global_string, "%s{"#cWH"}Такой транспорт можно {"#cLY"}скрафтить{"#cWH"} в подвале любого дома.\n", global_string ) ;
				}
			}

            if ( _typeColor == 1 ) format ( global_string, sizeof global_string, "%s{"#cWH"}Можно выменять (/trade) или приобрести у игроков.", global_string ) ;
			else format ( global_string, sizeof global_string, "%s{"#cWH"}Можно выменять (/trade) или приобрести у игроков.", global_string ) ;
		}
	}
	return global_string ;
}

stock item_max_in_slot ( modelId )
{
	new itemCount = 1_000_000 ;
	switch ( modelId )
	{
		case 0..300: itemCount = 1 ;
		case ITEM_AID_KIT: itemCount = 10 ;
		case 2156: itemCount = 5 ;
		case 2158: itemCount = 3 ;
		case 2160: itemCount = 3 ;
		case 2161: itemCount = 3 ;
		case 2162: itemCount = 5 ;
		case 2163: itemCount = 1 ;
		case 2250: itemCount = 1 ;
		case ITEM_SIM_CARD: itemCount = 1 ;
		case 2256: itemCount = 1 ;

		case 400..611: itemCount = 1 ;
		case 3200..3400: itemCount = 1 ;
		
		default: itemCount = 1 ; // acs
	}
	return itemCount ;
}

stock item_blocked ( playerid, modelId, type_info = 0, slot_id = 0 )
{
	switch ( modelId )
	{
	    case ITEM_MILITARY_ID: return true ;
	    case ITEM_PASSPORT: return true ;
		case 2220, 2222, 2223: return true ;
		case 2221: return true ;
		case 2224: return true ;
		case 2250: 
		{
			if ( type_info == 1 )
				return true ;
		
			if ( USERS_INVENTORY [ playerid ] [ slot_id ] [ INV_ITEM_TYPE ] == RENDER_TYPE_PLATE &&
				USERS_INVENTORY [ playerid ] [ slot_id ] [ INV_ITEM_GIVE_DATE ] > 0 )
			{
				send_check_cinfo ( playerid, "Сперва снимите номера с транспорта!\nСнять их можно в любом отделении полиции.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

			return false ;
		}
	}
	return false ;
}

stock item_not_get ( modelId )
{
	switch ( modelId )
	{
		case 2164: return true ;
		case 2165: return true ;
		case 2166: return true ;
		case 2167: return true ;
		case 2168: return true ;
		case 2169: return true ;
		case 2170: return true ;
		case 2172: return true ;
		case 2220, 2222, 2223: return true ;
		case 2221: return true ;
		case 2224: return true ;
		case 2250: return true ;
	}
	return false ;
}

stock item_not_put ( modelId )
{
	switch ( modelId )
	{
		case ITEM_AID_KIT: return true ;
		case 2146: return true ;
		case 2147: return true ;
		case 2148: return true ;
		case 2149: return true ;
		case 2150: return true ;
		case 2151: return true ;
		case 2152: return true ;

		case 2153: return true ;
		case 2154: return true ;
		case 2155: return true ;
		case 2156: return true ;
		case 2157: return true ;
		case 2158: return true ;
		
		case 2164: return true ;
		case 2165: return true ;
		case 2166: return true ;
		case 2167: return true ;
		case 2168: return true ;
		case 2169: return true ;
		case 2170: return true ;
		case 2172: return true ;
		case 2220, 2222, 2223: return true ;
		case 2221: return true ;
		case 2224: return true ;

		case 2250: return true ;

	    case 331: return true ;
		case 333: return true ;
		case 334: return true ;
		case 335: return true ;
		case 336: return true ;
		case 337: return true ;
		case 338: return true ;
		case 339: return true ;
		case 341: return true ;
		case 321: return true ;
		case 322: return true ;
		case 323: return true ;
		case 324: return true ;
		case 325: return true ;
		case 326: return true ;
		case 342: return true ;
		case 343: return true ;
		case 346: return true ;
		case 347: return true ;
		case 348: return true ;
		case 349: return true ;
		case 350: return true ;
		case 351: return true ;
		case 352: return true ;
		case 353: return true ;
		case 355: return true ;
		case 356: return true ;
		case 372: return true ;
		case 357: return true ;
		case 358: return true ;
		case 359: return true ;
		case 360: return true ;
		case 361: return true ;
		case 362: return true ;
		case 363: return true ;
		case 364: return true ;
		case 365: return true ;
		case 366: return true ;
		case 367: return true ;

		case 1242: return true ;
		case 1243: return true ;
		case 1244: return true ;
	}
	return false ;
}

stock GiveInventory ( idx, inventoryType, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( itemStruct [ _:INV_ITEM ] < 1 ) return 1 ;

	new migrateStruct [ USERS_INVENTORY_STRUCT ], maxItems = 0, invItem, slotId = -1, bool: freeSlot = false ;
	if ( inventoryType == SUB_INVENTORY ) maxItems = MAX_INVENTORY_SLOTS ;
	else if ( inventoryType == SUB_INV_VEHICLE ) maxItems = getTrunkCapacity ( idx ) ;
	else if ( inventoryType == SUB_INV_HOUSE ) maxItems = MAX_WAREHOUSE_SLOT ;
	else if ( inventoryType == SUB_INV_FAMILY ) maxItems = MAX_FAMILY_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_FRACTION ) maxItems = MAX_FRACTION_WAREHOUSE ;
	else if ( inventoryType == SUB_INV_MARKET_PLACE ) maxItems = MAX_MARKET_PLACE_ITEMS ;
	else if ( inventoryType == SUB_INV_TRADE ) maxItems = MAX_TRADE_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) maxItems = MAX_MARKET_SLOTS ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) maxItems = MAX_MARKET_SLOTS ;

	for ( new i = 0 ; i < maxItems ; i ++ )
	{
		migrateStruct = GetInventoryStruct ( idx, inventoryType, i ) ;
		invItem = migrateStruct [ INV_ITEM ] ;
		if ( invItem > 0 )
		{
			if ( invItem > 0 )
			{
				new maxSlotCount = item_max_in_slot ( invItem ) ;
				if ( maxSlotCount != -1 && migrateStruct [ INV_ITEM_COUNT ] + itemStruct [ _:INV_ITEM_COUNT ] > maxSlotCount ) continue ;

				if ( invItem == itemStruct [ _:INV_ITEM ] )
				{
					slotId = i ;
					freeSlot = true ;
					break ;
				}
				continue ;
			}
		}
		else
		{
			if ( ! freeSlot )
			{
				slotId = i ;
				freeSlot = true ;
			}
		}
	}
	
	if ( ! freeSlot || slotId == -1 ) return -1 ;
	return GiveInventorySlot ( idx, inventoryType, slotId, itemStruct ) ;
}

stock GiveInventorySlot ( idx, inventoryType, itemIndex, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( itemStruct [ _:INV_ITEM ] < 1 ) return 1 ;

	new migrateStruct [ USERS_INVENTORY_STRUCT ], USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ],
		tableName [ 32 ], bool: isSQL = true,
		bool: insertSlot = false, invType, invItemId = itemStruct [ _:INV_ITEM_ID ], ownerSQLId ;

	migrateStruct = GetInventoryStruct ( idx, inventoryType, itemIndex ) ;
	if ( migrateStruct [ INV_ITEM ] > 0 )
	{
		if ( migrateStruct [ INV_ITEM ] != itemStruct [ _:INV_ITEM ] ) return -1 ;
		
		new maxSlotCount = item_max_in_slot ( itemStruct [ _:INV_ITEM ] ) ;
		if ( maxSlotCount != -1 && migrateStruct [ INV_ITEM_COUNT ] + itemStruct [ _:INV_ITEM_COUNT ] > maxSlotCount ) return -1 ;

		insertSlot = false ;
		migrateStruct [ INV_ITEM_COUNT ] += itemStruct [ _:INV_ITEM_COUNT ] ;
	}
	else
	{
		insertSlot = true ;
		SetInventoryStructure ( idx, inventoryType, itemIndex, itemStruct ) ;
		migrateStruct = GetInventoryStruct ( idx, inventoryType, itemIndex ) ;
	}

	if ( inventoryType == SUB_INVENTORY )
	{
		if ( insertSlot )
		{
			prise_inc_id ++ ;
			migrateStruct [ INV_ID ] = prise_inc_id ;
		}
		ownerSQLId = p_info [ idx ] [ id ] ;
		format ( tableName, sizeof tableName, "users_inventory" ) ;
	}
	else if ( inventoryType == SUB_INV_VEHICLE )
	{
		if ( insertSlot )
		{
			prise_vehicle_inc_id ++ ;
			migrateStruct [ INV_ID ] = prise_vehicle_inc_id ;
		}
		ownerSQLId = veh_info [ idx - 1 ] [ v_id ] ;
		format ( tableName, sizeof tableName, "users_vehicles_inventory" ) ;
	}
	else if ( inventoryType == SUB_INV_HOUSE )
	{
		if ( insertSlot )
		{
			prise_house_inc_id ++ ;
			migrateStruct [ INV_ID ] = prise_house_inc_id ;
		}
		ownerSQLId = h_info [ idx - 1 ] [ h_id ] ;
		format ( tableName, sizeof tableName, "houses_inventory" ) ;
	}
	else if ( inventoryType == SUB_INV_FAMILY )
	{
		if ( insertSlot )
		{
			prise_family_inc_id ++ ;
			migrateStruct [ INV_ID ] = prise_family_inc_id ;
		}
		ownerSQLId = family_info [ idx - 1 ] [ fam_id ] ;
		format ( tableName, sizeof tableName, "familys_inventory" ) ;
	}
	else if ( inventoryType == SUB_INV_FRACTION )
	{
		if ( insertSlot )
		{
			prise_fraction_inc_id ++ ;
			migrateStruct [ INV_ID ] = prise_fraction_inc_id ;
		}
		ownerSQLId = f_info [ idx - 1 ] [ f_id ] ;
		format ( tableName, sizeof tableName, "fractions_inventory" ) ;
	}
	else if ( inventoryType == SUB_INV_MARKET_PLACE )
	{
		if ( insertSlot )
		{
			prise_market_place_id ++ ;
			migrateStruct [ INV_ID ] = prise_market_place_id ;
		}
		ownerSQLId = p_info [ idx ] [ id ] ;
		format ( tableName, sizeof tableName, "users_market_place" ) ;
	}
	else if ( inventoryType == SUB_INV_TRADE ) isSQL = false ;
	else if ( inventoryType == SUB_INV_MARKET_SELL ) isSQL = false ;
	else if ( inventoryType == SUB_INV_MARKET_BUY ) isSQL = false ;

	invItemId = itemStruct [ _:INV_ITEM_ID ], invType = itemStruct [ _:INV_ITEM_TYPE ] ;
	if ( ! invItemId )
	{
		if ( invType == INVENTORY_TYPE_SIMCARD )
		{
			simcard_inc_id ++ ;
			invItemId = simcard_inc_id ;

			static const _str [ ] = "INSERT INTO licence_number (id,number) VALUES (%d,%d)" ;
			new sql_string [ sizeof _str + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, _str, invItemId, itemStruct [ _:INV_ITEM_GIVE_DATE ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
		else if ( item_render_type ( migrateStruct [ INV_ITEM ] ) == RENDER_TYPE_SKINS )
		{
			skin_inc_id ++ ;
			invItemId = skin_inc_id ;
			invType = INVENTORY_TYPE_SKINS ;

			// На первое создание указываем макс. износ, чтоб до первого релога инфа была
			migrateStruct [ INV_ITEM_WEAR ] = GetModelWearMax ( itemStruct [ _:INV_ITEM ] ) ;

			static const _str [ ] = "INSERT INTO users_skins_stats (id,skin_wear) VALUES (%d,%d)" ;
			new sql_string [ sizeof _str + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, _str, invItemId, migrateStruct [ INV_ITEM_WEAR ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
		else if ( NotPreLoadAccessories ( itemStruct [ _:INV_ITEM ] ) && GetAccessoriesItem ( itemStruct [ _:INV_ITEM ] ) )
		{
			invType = INVENTORY_TYPE_ACCESSORIES ;

			new USER_ACCESSORIES_STRUCT: acsStruct [ _:ACS_STRUCTURE_MAX ] ;
			acsStruct [ _:ACS_ID ] = 0 ;
			acsStruct [ _:ACS_MODEL ] = itemStruct [ _:INV_ITEM ] ;
			acsStruct [ _:ACS_USED ] = 0 ;
			acsStruct [ _:ACS_DATE ] = itemStruct [ _:INV_ITEM_DATE ] ;
			acsStruct [ _:ACS_COUNT ] = 1 ;
			acsStruct [ _:ACS_OBJ_X ] = 0.0 ;
			acsStruct [ _:ACS_OBJ_Y ] = 0.0 ;
			acsStruct [ _:ACS_OBJ_Z ] = 0.0 ;
			acsStruct [ _:ACS_ROT_X ] = 0.0 ;
			acsStruct [ _:ACS_ROT_Y ] = 0.0 ;
			acsStruct [ _:ACS_ROT_Z ] = 0.0 ;
			acsStruct [ _:ACS_WEAR ] = GetModelWearMax ( itemStruct [ _:INV_ITEM ] ) ;

			// На первое создание указываем макс. износ, чтоб до первого релога инфа была
			migrateStruct [ INV_ITEM_WEAR ] = GetModelWearMax ( itemStruct [ _:INV_ITEM ] ) ;

			invItemId = give_accessories ( idx, getFreeSlotAccessories ( idx ), acsStruct ) ;
			clear_accessories ( idx, invItemId ) ;
		}
	}

	migrateStruct [ INV_ITEM_TYPE ] = invType ;
	migrateStruct [ INV_ITEM_ID ] = invItemId ;

	if ( isSQL )
	{
		if ( insertSlot )
		{
			static const _str [ ] = "\
				INSERT INTO \
				`%s` \
				(`id`, `inv_id`, `inv_item`, `inv_count`, `inv_date`, `inv_slot_id`, `inv_type`, `inv_other_id`) \
				VALUES \
				('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d')" ;
			new sql_string [ sizeof _str + 32 + ( 9 * 9 ) ] ;
			format ( sql_string, sizeof sql_string, _str,
			tableName,
			migrateStruct [ INV_ID ],
			ownerSQLId,
			migrateStruct [ INV_ITEM ],
			migrateStruct [ INV_ITEM_COUNT ], 
			migrateStruct [ INV_ITEM_DATE ], 
			itemIndex,
			migrateStruct [ INV_ITEM_TYPE ],
			migrateStruct [ INV_ITEM_ID ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
		else
		{
			static const _str [ ] = "\
				UPDATE \
				`%s` \
				SET \
					`inv_item` = '%d', `inv_count` = '%d', `inv_date` = '%d', `inv_type` = '%d', `inv_other_id` = '%d' \
				WHERE\
					`id` = '%d' LIMIT 1" ;
			new sql_string [ sizeof _str + 32 + ( 9 * 6 ) ] ;
			format ( sql_string, sizeof sql_string, _str, 
			tableName,
			migrateStruct [ INV_ITEM ],
			migrateStruct [ INV_ITEM_COUNT ], 
			migrateStruct [ INV_ITEM_DATE ], 
			migrateStruct [ INV_ITEM_TYPE ],
			migrateStruct [ INV_ITEM_ID ],
			migrateStruct [ INV_ID ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	}

	
	inventoryStruct [ _:INV_ITEM ] = migrateStruct [ INV_ITEM ] ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = migrateStruct [ INV_ITEM_COUNT ] ;
	inventoryStruct [ _:INV_ITEM_DATE ] = migrateStruct [ INV_ITEM_DATE ] ;
	inventoryStruct [ _:INV_ID ] = migrateStruct [ INV_ID ] ;
	inventoryStruct [ _:INV_ITEM_TYPE ] = migrateStruct [ INV_ITEM_TYPE ] ;
	inventoryStruct [ _:INV_ITEM_REGION ] = migrateStruct [ INV_ITEM_REGION ] ;
	inventoryStruct [ _:INV_ITEM_PLATE ] = migrateStruct [ INV_ITEM_PLATE ] ;
	inventoryStruct [ _:INV_ITEM_PLATE_TYPE ] = migrateStruct [ INV_ITEM_PLATE_TYPE ] ;
	format ( inventoryStruct [ _:INV_ITEM_REGION ], 12, "%s", migrateStruct [ INV_ITEM_PLATE_TYPE ] ) ;
	format ( inventoryStruct [ _:INV_ITEM_PLATE ], 12, "%s", migrateStruct [ INV_ITEM_PLATE_TYPE ] ) ;
	inventoryStruct [ _:INV_ITEM_GIVE_DATE ] = migrateStruct [ INV_ITEM_GIVE_DATE ] ;
	inventoryStruct [ _:INV_ITEM_ID ] = migrateStruct [ INV_ITEM_ID ] ;
	inventoryStruct [ _:INV_ITEM_LEVEL ] = migrateStruct [ INV_ITEM_LEVEL ] ;
	inventoryStruct [ _:INV_ITEM_STRIPE ] = migrateStruct [ INV_ITEM_STRIPE ] ;
	inventoryStruct [ _:INV_ITEM_WEAR ] = migrateStruct [ INV_ITEM_WEAR ] ;
	inventoryStruct [ _:INV_OBJ_X ] = migrateStruct [ INV_OBJ_X ] ;
	inventoryStruct [ _:INV_OBJ_Y ] = migrateStruct [ INV_OBJ_X ] ;
	inventoryStruct [ _:INV_OBJ_Z ] = migrateStruct [ INV_OBJ_X ] ;
	inventoryStruct [ _:INV_ROT_X ] = migrateStruct [ INV_OBJ_X ] ;
	inventoryStruct [ _:INV_ROT_Y ] = migrateStruct [ INV_OBJ_X ] ;
	inventoryStruct [ _:INV_ROT_Z ] = migrateStruct [ INV_OBJ_X ] ;
	SetInventoryStructure ( idx, inventoryType, itemIndex, inventoryStruct ) ;

	new modelId = itemStruct [ _:INV_ITEM ] ;
	MODEL_INFO [ modelId ] [ MODEL_COUNT ] += itemStruct [ _:INV_ITEM_COUNT ] ;
	set_model_count ( modelId, MODEL_INFO [ modelId ] [ MODEL_COUNT ] ) ;

	return itemIndex ;
}

callback: InventoryLoading ( idx, serverId, inventoryType, init )
{
	if ( init )
	{
		new tableName [ 32 ], maxItems ;
		if ( inventoryType == SUB_INVENTORY )
		{
			maxItems = MAX_INVENTORY_SLOTS ;
			format ( tableName, sizeof tableName, "users_inventory" ) ;
		}
		else if ( inventoryType == SUB_INV_VEHICLE )
		{
			maxItems = getTrunkCapacity ( serverId ) ;
			format ( tableName, sizeof tableName, "users_vehicles_inventory" ) ;
		}
		else if ( inventoryType == SUB_INV_HOUSE )
		{
			maxItems = MAX_WAREHOUSE_SLOT ;
			format ( tableName, sizeof tableName, "houses_inventory" ) ;
		}
		else if ( inventoryType == SUB_INV_FAMILY )
		{
			maxItems = MAX_FAMILY_WAREHOUSE ;
			format ( tableName, sizeof tableName, "familys_inventory" ) ;
		}
		else if ( inventoryType == SUB_INV_FRACTION )
		{
			maxItems = MAX_FRACTION_WAREHOUSE ;
			format ( tableName, sizeof tableName, "fractions_inventory" ) ;
		}
		else if ( inventoryType == SUB_INV_MARKET_PLACE )
		{
			maxItems = MAX_MARKET_SLOTS ;
			format ( tableName, sizeof tableName, "users_market_place" ) ;
		}
		else if ( inventoryType == SUB_INV_GUARDS )
		{
			maxItems = MAX_GUARDS_SLOT ;
			format ( tableName, sizeof tableName, "users_guards_inventory" ) ;
		}

		for ( new i = 0 ; i < maxItems ; i ++ )
			ClearInventoryNull ( serverId, inventoryType, i ) ;

		static const _str [ ] = "\
			SELECT \
				inv.*, \
				IFNULL(lp.licence_plate_number, 'None') AS licence_plate_number, \
				lp.licence_plate_country, \
				lp.licence_plate_region, \
				IFNULL(lp.licence_plate_use_own_car_id, 0) AS licence_plate_use_own_car_id, \
				uaf.*, \
				IFNULL(uaf.id, 0) AS uaf_id, \
				uas.*, \
				IFNULL(uas.id, 0) AS uas_id, \
				IFNULL(ln.number, 0) AS sim_number, \
				uss.*, \
				IFNULL(uss.id, 0) AS uss_id \
			FROM %s inv \
			LEFT JOIN licence_plate lp ON lp.id = inv.inv_other_id AND inv.inv_type = %d \
			LEFT JOIN users_accessories_float uaf ON uaf.id = inv.inv_other_id AND inv.inv_type = %d \
			LEFT JOIN users_accessories_stats uas ON uas.id = inv.inv_other_id AND inv.inv_type = %d \
			LEFT JOIN licence_number ln ON ln.id = inv.inv_other_id AND inv.inv_type = %d \
			LEFT JOIN users_skins_stats uss ON uss.id = inv.inv_other_id AND inv.inv_type = %d \
			WHERE inv.inv_id = %d LIMIT %d" ;
		new query_string [ sizeof _str + ( 9 * 2 ) ] ;
		format ( query_string, sizeof query_string, _str,
			tableName,
			INVENTORY_TYPE_PLATE,
			INVENTORY_TYPE_ACCESSORIES,
			INVENTORY_TYPE_ACCESSORIES,
			INVENTORY_TYPE_SIMCARD,
			INVENTORY_TYPE_SKINS,
			idx,
			maxItems ) ;
		mysql_tquery ( sql_connection, query_string, "InventoryLoading", "iiii", idx, serverId, inventoryType, 0 ) ;
	}
	else
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;

		if ( rows )
		{
			new slotId, regionStr [ 12 ], plateStr [ 12 ], countryStr [ 12 ], sscanf_delimit [ 128 ], 
				vehicleId, countryId, simNumber, invType, USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] ;
			for ( new i = 0 ; i < rows ; i ++ )
			{
				slotId = cache_get_field_content_int ( i, "inv_slot_id", sql_connection ) ;
				itemStruct [ _:INV_ID ] = cache_get_field_content_int ( i, "id", sql_connection ) ;
				itemStruct [ _:INV_ITEM ] = cache_get_field_content_int ( i, "inv_item", sql_connection ) ;
				itemStruct [ _:INV_ITEM_COUNT ] = cache_get_field_content_int ( i, "inv_count", sql_connection ) ;
				itemStruct [ _:INV_ITEM_DATE ] = cache_get_field_content_int ( i, "inv_date", sql_connection ) ;
				invType = cache_get_field_content_int ( i, "inv_type", sql_connection ) ;
				itemStruct [ _:INV_ITEM_ID ] = cache_get_field_content_int ( i, "inv_other_id", sql_connection ) ;
				itemStruct [ _:INV_ITEM_GIVE_DATE ] = cache_get_field_content_int ( i, "inv_give_date", sql_connection ) ;
			
				simNumber = cache_get_field_content_int ( i, "sim_number", sql_connection ) ;
				if ( simNumber ) itemStruct [ _:INV_ITEM_GIVE_DATE ] = simNumber ;

				cache_get_field_content ( i, "licence_plate_country", countryStr ) ;
				cache_get_field_content ( i, "licence_plate_number", plateStr ) ;
				cache_get_field_content ( i, "licence_plate_region", regionStr ) ;
				
				if ( ! GetString ( plateStr, "None" ) )
				{
					if ( ! strcmp ( countryStr, "RU POLICE" ) ) countryId = NUMBERPLATE_TYPE_RU_POLICE ;
					else if ( ! strcmp ( countryStr, "RU" ) ) countryId = NUMBERPLATE_TYPE_RUS ;
					else if ( ! strcmp ( countryStr, "UA" ) ) countryId = NUMBERPLATE_TYPE_UA ;
					else if ( ! strcmp ( countryStr, "BY" ) ) countryId = NUMBERPLATE_TYPE_BY ;
					else if ( ! strcmp ( countryStr, "KZ" ) ) countryId = NUMBERPLATE_TYPE_KZ ;

					if ( countryId > 1 )
					{
						vehicleId = cache_get_field_content_int ( i, "licence_plate_use_own_car_id" ) ;

						format ( itemStruct [ _:INV_ITEM_REGION ], 12, "%s", regionStr ) ;
						format ( itemStruct [ _:INV_ITEM_PLATE ], 12, "%s", plateStr ) ;
						
						itemStruct [ _:INV_ITEM_PLATE_TYPE ] = countryId ;
						itemStruct [ _:INV_ITEM_GIVE_DATE ] = vehicleId ;
					}
				}

				itemStruct [ _:INV_ITEM_TYPE ] = invType ;
				if ( invType == INVENTORY_TYPE_ACCESSORIES && cache_get_field_content_int ( i, "uaf_id", sql_connection ) )
				{
					cache_get_field_content ( i, "acs_position", sscanf_delimit, sql_connection ) ;
					sscanf ( sscanf_delimit, "p<|>ffffff",
					itemStruct [ _:INV_OBJ_X ], itemStruct [ _:INV_OBJ_Y ], itemStruct [ _:INV_OBJ_Z ],
					itemStruct [ _:INV_ROT_X ], itemStruct [ _:INV_ROT_Y ], itemStruct [ _:INV_ROT_Z ] ) ;
				}

				if ( invType == INVENTORY_TYPE_ACCESSORIES && cache_get_field_content_int ( i, "uas_id", sql_connection ) )
				{
					itemStruct [ _:INV_ITEM_LEVEL ] = cache_get_field_content_int ( i, "acs_level", sql_connection ) ;
					itemStruct [ _:INV_ITEM_STRIPE ] = cache_get_field_content_int ( i, "acs_stripe", sql_connection ) ;
					itemStruct [ _:INV_ITEM_WEAR ] = cache_get_field_content_int ( i, "acs_wear", sql_connection ) ;
				}

				if ( invType == INVENTORY_TYPE_SKINS && cache_get_field_content_int ( i, "uss_id", sql_connection ) )
				{
					itemStruct [ _:INV_ITEM_LEVEL ] = cache_get_field_content_int ( i, "skin_level", sql_connection ) ;
					itemStruct [ _:INV_ITEM_STRIPE ] = cache_get_field_content_int ( i, "skin_stripe", sql_connection ) ;
					itemStruct [ _:INV_ITEM_WEAR ] = cache_get_field_content_int ( i, "skin_wear", sql_connection ) ;
				}

				SetInventoryStructure ( serverId, inventoryType, slotId, itemStruct ) ;
			}
		}

		if ( inventoryType == SUB_INVENTORY )
		{
			SetInventoryCache ( serverId ) ;
			LoadUsersGuards ( serverId, 1 ) ;
		}
		else if ( inventoryType == SUB_INV_VEHICLE ) veh_info [ serverId - 1 ] [ v_trunk_load ] = true ;
		else if ( inventoryType == SUB_INV_HOUSE ) h_info [ serverId - 1 ] [ h_safe_load ] = true ;
		else if ( inventoryType == SUB_INV_FAMILY ) family_info [ serverId - 1 ] [ fam_safe_load ] = true ;
		else if ( inventoryType == SUB_INV_FRACTION ) { }
		else if ( inventoryType == SUB_INV_MARKET_PLACE ) LoadUserMarketPlace ( serverId ) ;
		else if ( inventoryType == SUB_INV_GUARDS )
		{
			for ( new i = 0 ; i < MAX_GUARDS ; i ++ )
			{
				if ( GetGuardInfo ( serverId, GUARD_LOAD, i ) ) continue ;

				GetGuardInfo ( serverId, GUARD_LOAD, i ) = true ;
				InventoryLoading ( GetGuardInfo ( serverId, GUARD_ID, i ), serverId, SUB_INV_GUARDS, 1 ) ;
				break ;
			}
		}
	}
	return true ;
}