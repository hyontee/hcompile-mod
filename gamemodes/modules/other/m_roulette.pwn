enum _rou_item
{
	rou_type,
	rou_rare,
	rou_model,
	rou_name [ 24 ],
	Float: rou_rotX,
	Float: rou_rotY,
	Float: rou_rotZ,
	Float: rou_angle
} ;

#define MAX_BRONZE_PRISE 12
new rou_item_bronze [ MAX_BRONZE_PRISE ] [ _rou_item ] =
{
	{ NON_RENDER_TYPE, RARE_TYPE_GRAY, 2001, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ NON_RENDER_TYPE, RARE_TYPE_PURPLE, 2004, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 75, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 76, "Одежда", 20.0, 180.0, 45.0, 0.78 },

	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 400, "BMW X6 F16", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 404, "Lamborghini LM002", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_SILVER_PRISE 12
new rou_item_silver [ MAX_SILVER_PRISE ] [ _rou_item ] =
{
	{ NON_RENDER_TYPE, RARE_TYPE_GRAY, 2001, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ NON_RENDER_TYPE, RARE_TYPE_PURPLE, 2004, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 282, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 284, "Одежда", 20.0, 180.0, 45.0, 0.78 },

	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 427, "Chevrolet Camaro ZL1", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 516, "Audi 100 c4", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_GOLD_PRISE 14
new rou_item_gold [ MAX_GOLD_PRISE ] [ _rou_item ] =
{
	{ NON_RENDER_TYPE, RARE_TYPE_GRAY, 2001, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ NON_RENDER_TYPE, RARE_TYPE_PURPLE, 2004, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 271, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 274, "Одежда", 20.0, 180.0, 45.0, 0.78 },

	{ NON_RENDER_TYPE, RARE_TYPE_PURPLE, 3508, "Silver Rifle", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 12157, "Пряня", 20.0, 180.0, 45.0, 0.78 },

	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 428, "Chevrolet Camaro ZR1", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 437, "Dodge Challenger SRT", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_TRUCKER_ITEM 12
new rou_trucker_item [ MAX_TRUCKER_ITEM ] [ _rou_item ] =
{
	{ NON_RENDER_TYPE, RARE_TYPE_GRAY, 2001, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ NON_RENDER_TYPE, RARE_TYPE_PURPLE, 2004, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 282, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 284, "Одежда", 20.0, 180.0, 45.0, 0.78 },

	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 403, "MAZ 5440", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 514, "DAF XT", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_INCASS_ITEM 15
#define MAX_COURIER_ITEM 15
#define MAX_ZAVOD_ITEM 15
#define MAX_DELIVERY_ITEM 15
#define MAX_SAWMILL_ITEM 15
#define MAX_MINER_ITEM 15

stock showPlayerRoulette ( playerid )
{
	set_player_use_listitem ( playerid, 0 ) ;
	addRouletteItems ( playerid, 0 ) ;
	updateRouletteInformation ( playerid ) ;
	toggle_controlable ( playerid, false ) ;
	return true ;
}

stock updateRouletteInformation ( playerid )
{
	new Node: node = JSON_Object (
		"bronze",		JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2045 ) ),
		"silver",		JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2055 ) ),
		"gold",			JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2125 ) )
	) ;
	
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_ROULETTE_PLAYER, 1, global_string ) ;
	return true ;
}

stock addRouletteItems ( playerid, rouletteId )
{
	new Node: node = JSON_Array ( ), itemsLoaded = 0 ;
	if ( rouletteId == 0 )
	{
		for ( new i = 0, Node: itemNode ; i < MAX_BRONZE_PRISE ; i ++ )
		{
			itemNode = JSON_Array (
				JSON_Object (
					"position",		JSON_Int ( i ),
					"name",			JSON_String ( rou_item_bronze [ i ] [ rou_name ] ),
					"rare",			JSON_Int ( rou_item_bronze [ i ] [ rou_rare ] ),
					"type",			JSON_Int ( rou_item_bronze [ i ] [ rou_type ] ),
					"model",		JSON_Int ( rou_item_bronze [ i ] [ rou_model ] ),
					"color1",  		JSON_Int ( 1 ),
					"color2",      	JSON_Int ( 1 ),
					"rotX",			JSON_Float ( 20.0 ),
					"rotY",			JSON_Float ( 180.0 ),
					"rotZ",			JSON_Float ( 45.0 ),
					"zoom",			JSON_Float ( 0.78 )
				)
			) ;
			node = JSON_Append ( node, itemNode ) ;

			if ( ++ itemsLoaded == 5 || i == MAX_BRONZE_PRISE - 1 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_ROULETTE_PLAYER, 0, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}
	}
	else if ( rouletteId == 1 )
	{
		for ( new i = 0, Node: itemNode ; i < MAX_SILVER_PRISE ; i ++ )
		{
			itemNode = JSON_Array (
				JSON_Object (
					"position",		JSON_Int ( i ),
					"name",			JSON_String ( rou_item_silver [ i ] [ rou_name ] ),
					"rare",			JSON_Int ( rou_item_silver [ i ] [ rou_rare ] ),
					"type",			JSON_Int ( rou_item_silver [ i ] [ rou_type ] ),
					"model",		JSON_Int ( rou_item_silver [ i ] [ rou_model ] ),
					"color1",  		JSON_Int ( 1 ),
					"color2",      	JSON_Int ( 1 ),
					"rotX",			JSON_Float ( 20.0 ),
					"rotY",			JSON_Float ( 180.0 ),
					"rotZ",			JSON_Float ( 45.0 ),
					"zoom",			JSON_Float ( 0.78 )
				)
			) ;
			node = JSON_Append ( node, itemNode ) ;

			if ( ++ itemsLoaded == 5 || i == MAX_SILVER_PRISE - 1 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_ROULETTE_PLAYER, 0, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}
	}
	else if ( rouletteId == 2 )
	{
		for ( new i = 0, Node: itemNode ; i < MAX_GOLD_PRISE ; i ++ )
		{
			itemNode = JSON_Array (
				JSON_Object (
					"position",		JSON_Int ( i ),
					"name",			JSON_String ( rou_item_gold [ i ] [ rou_name ] ),
					"rare",			JSON_Int ( rou_item_gold [ i ] [ rou_rare ] ),
					"type",			JSON_Int ( rou_item_gold [ i ] [ rou_type ] ),
					"model",		JSON_Int ( rou_item_gold [ i ] [ rou_model ] ),
					"color1",  		JSON_Int ( 1 ),
					"color2",      	JSON_Int ( 1 ),
					"rotX",			JSON_Float ( 20.0 ),
					"rotY",			JSON_Float ( 180.0 ),
					"rotZ",			JSON_Float ( 45.0 ),
					"zoom",			JSON_Float ( 0.78 )
				)
			) ;
			node = JSON_Append ( node, itemNode ) ;

			if ( ++ itemsLoaded == 5 || i == MAX_GOLD_PRISE - 1 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_ROULETTE_PLAYER, 0, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}
	}
	return true ;
}

stock packetPlayerRoulette ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		new idx = strval ( data ) ;
		addRouletteItems ( playerid, idx ) ;
		set_player_use_listitem ( playerid, idx ) ;
	}
	else if ( actionId == 1 )
	{
		new idx = get_player_use_listitem ( playerid ),
			itemIdx = GetRouletteRandomRarity ( idx ),
			modelId, renderType ;

		if ( idx == 0 )
		{
			if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2045 ) < 1 ) return false ;
			clear_inventory ( playerid, 2045, 1 ) ;
			modelId = rou_item_bronze [ itemIdx ] [ rou_model ] ;
			renderType = rou_item_bronze [ itemIdx ] [ rou_type ] ;
		}
		else if ( idx == 1 )
		{
			if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2055 ) < 1 ) return false ;
			clear_inventory ( playerid, 2055, 1 ) ;
			modelId = rou_item_silver [ itemIdx ] [ rou_model ] ;
			renderType = rou_item_silver [ itemIdx ] [ rou_type ] ;
		}
		else if ( idx == 2 )
		{
			if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2125 ) < 1 ) return false ;
			clear_inventory ( playerid, 2125, 1 ) ;
			modelId = rou_item_gold [ itemIdx ] [ rou_model ] ;
			renderType = rou_item_gold [ itemIdx ] [ rou_type ] ;
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 12, "%d", itemIdx ) ;
		onServerSendData ( playerid, UI_ROULETTE_PLAYER, 2, global_string ) ;
		
		give_inventory (
			playerid,
			modelId,
			1,
			0,
			"",
			"",
			NUMBERPLATE_TYPE_NONE,
			0
		) ;

		updateRouletteInformation ( playerid ) ;

		static const _str [ ] = "(PLAYER ROULETTE) %s открыл рулетку и получил %s" ;
		new query_string [ sizeof _str + 64 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ name ], giveRouletteItem ( playerid, modelId, renderType ) ) ;
		WriteLog ( playerid, TYPE_LOG_CASE, query_string ) ;
	}
	return true ;
}

stock packetPlayerRouletteDestroy ( playerid )
{
	toggle_controlable ( playerid, true ) ;
	return true ;
}

stock showJobRoulette ( playerid )
{
	addJobRouletteItems ( playerid, get_player_use_listitem ( playerid ) ) ;
	return true ;
}

stock addJobRouletteItems ( playerid, rouletteId )
{
	new Node: node = JSON_Array ( ), itemsLoaded = 0 ;
	if ( rouletteId == 138 )
	{
		for ( new i = 0, Node: itemNode ; i < MAX_TRUCKER_ITEM ; i ++ )
		{
			itemNode = JSON_Array (
				JSON_Object (
					"position",		JSON_Int ( i ),
					"name",			JSON_String ( rou_trucker_item [ i ] [ rou_name ] ),
					"rare",			JSON_Int ( rou_trucker_item [ i ] [ rou_rare ] ),
					"type",			JSON_Int ( rou_trucker_item [ i ] [ rou_type ] ),
					"model",		JSON_Int ( rou_trucker_item [ i ] [ rou_model ] ),
					"color1",  		JSON_Int ( 1 ),
					"color2",      	JSON_Int ( 1 ),
					"rotX",			JSON_Float ( 20.0 ),
					"rotY",			JSON_Float ( 180.0 ),
					"rotZ",			JSON_Float ( 45.0 ),
					"zoom",			JSON_Float ( 0.78 )
				)
			) ;
			node = JSON_Append ( node, itemNode ) ;

			if ( ++ itemsLoaded == 5 || i == MAX_BRONZE_PRISE - 1 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_ROULETTE_JOB, 0, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}
	}
	return true ;
}

stock packetJobRoulette ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 )
	{
		new idx = get_player_use_listitem ( playerid ),
			itemIdx = GetJobRandomRarity ( idx ),
			modelId ;

		switch ( idx )
		{
			case 2138:
			{
				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, idx ) < 1 ) return false ;
				clear_inventory ( playerid, idx, 1 ) ;
				modelId = rou_trucker_item [ itemIdx ] [ rou_model ] ;
			}
		}

		global_string [ 0 ] = EOS ;
		format ( global_string, 12, "%d", itemIdx ) ;
		onServerSendData ( playerid, UI_ROULETTE_PLAYER, 1, global_string ) ;
		
		give_inventory (
			playerid,
			modelId,
			1,
			0,
			"",
			"",
			NUMBERPLATE_TYPE_NONE,
			0
		) ;

		static const _str [ ] = "(JOB ROULETTE) %s открыл рулетку и получил %s" ;
		new query_string [ sizeof _str + 64 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ name ], giveRouletteItem ( playerid, modelId, rou_trucker_item [ itemIdx ] [ rou_type ] ) ) ;
		WriteLog ( playerid, TYPE_LOG_CASE, query_string ) ;

		give_global_quest ( playerid, 0, 1 ) ;
	}
	return true ;
}

stock packetJobRouletteDestroy ( playerid )
{
	toggle_controlable ( playerid, true ) ;
	return true ;
}

stock giveRouletteItem ( playerid, modelId, renderType )
{
	new _str_name [ 32 ] ;
	if ( modelId == 1 )
	{
		new money_count = 0 ;
		switch ( random ( 5 ) )
		{
			case 0,1,3,4: money_count = RandomEx ( 4, 9 ) ;
			case 2: money_count = RandomEx ( 50, 55 ) ;
		}
		format ( _str_name, sizeof _str_name, "%s", item_name ( money_count ) ) ;
		give_inventory ( playerid, money_count, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( modelId == 4 )
	{
		new money_count = RandomEx ( 2015, 2023 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( money_count ) ) ;
		give_inventory ( playerid, money_count, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( modelId == 1582 )
	{
		new result_random = RandomEx ( 2040, 2044 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( result_random ) ) ;
		give_inventory ( playerid, result_random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( modelId == 348 )
	{
		new prize_type ;
		if ( random ( 15 ) == 1 ) prize_type = 2036 ;
		else prize_type = RandomEx ( 2088, 2094 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( prize_type ) ) ;
		give_inventory ( playerid, prize_type, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( modelId == 2684 )
	{
	    new prize_type ;
		if ( random ( 15 ) == 1 ) prize_type = 2035 ;
		else prize_type = RandomEx ( 2084, 2087 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( prize_type ) ) ;
		give_inventory ( playerid, prize_type, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( modelId == 11738 )
	{
		new aidkit_count = RandomEx ( 1, 3 ) ;
		give_inventory ( playerid, ITEM_AID_KIT, aidkit_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/healme\"{"#cGRInfo"}, чтобы полечиться." ) ;
	}
	else if ( modelId == 1575 )
	{
		new drugs_count = RandomEx ( 5, 100 ) ;
		give_inventory ( playerid, 2153, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		give_inventory ( playerid, 2154, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		format ( _str_name, sizeof _str_name, "Боеприпасы (%d шт.)", drugs_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/makegun\"{"#cGRInfo"}, чтобы собрать оружие." ) ;
	}
	else if ( modelId == 2061 )
	{
		new drugs_count = RandomEx ( 5, 100 ) ;
		give_inventory ( playerid, 2153, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		give_inventory ( playerid, 2154, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		format ( _str_name, sizeof _str_name, "Боеприпасы (%d шт.)", drugs_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/makegun\"{"#cGRInfo"}, чтобы собрать оружие." ) ;
	}
	else
	{
		if ( renderType == RENDER_TYPE_OBJECT )
		{
			format ( _str_name, sizeof _str_name, "%s", get_accessorie_name ( modelId ) ) ;
			give_inventory ( playerid, modelId, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
		else if ( renderType == RENDER_TYPE_SKINS )
		{
			format ( _str_name, sizeof _str_name, "%s", get_skin_name ( modelId ) ) ;
			give_inventory ( playerid, modelId, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
		else if ( renderType == RENDER_TYPE_VEHICLE )
		{
			format ( _str_name, sizeof _str_name, "%s", GetVehicleNameEx ( -1, modelId ) ) ;
			give_inventory ( playerid, modelId, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
	}
	return _str_name ;
}

stock GetJobRandomRarity ( rouletteType )
{
	new freeCount = 0,
		freeId [ 40 ] = { -1, ... },
		idx,
		itemRarity = GetRandomWeightedNumber ( rarityChanceDefault ) ;
	switch ( rouletteType )
	{
		case 138:
		{
			for ( new i = 0 ; i < MAX_TRUCKER_ITEM ; i ++ )
			{
				if ( rou_trucker_item [ i ] [ rou_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
	}

	if ( ! freeCount ) idx = 0 ;
	else if ( freeCount > 0 && freeCount < 2 ) idx = freeId [ freeCount - 1 ] ;
	else idx = freeId [ random ( freeCount ) ] ;

	return idx ;
}

stock GetRouletteRandomRarity ( rouletteType )
{
	new freeCount = 0,
		freeId [ 40 ] = { -1, ... },
		idx,
		itemRarity = GetRandomWeightedNumber ( rarityChanceDefault ) ;
	switch ( rouletteType )
	{
		case 0:
		{
			for ( new i = 0 ; i < MAX_BRONZE_PRISE ; i ++ )
			{
				if ( rou_item_bronze [ i ] [ rou_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 1:
		{
			for ( new i = 0 ; i < MAX_SILVER_PRISE ; i ++ )
			{
				if ( rou_item_silver [ i ] [ rou_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 2:
		{
			for ( new i = 0 ; i < MAX_GOLD_PRISE ; i ++ )
			{
				if ( rou_item_gold [ i ] [ rou_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
	}

	if ( ! freeCount ) idx = 0 ;
	else if ( freeCount > 0 && freeCount < 2 ) idx = freeId [ freeCount - 1 ] ;
	else idx = freeId [ random ( freeCount ) ] ;

	return idx ;
}