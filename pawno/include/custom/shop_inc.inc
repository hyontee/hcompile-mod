#define PACKET_CUSTOMRPC    			251
#define RPC_SHOP						0x200

stock SetShopShow ( playerid, _position, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SetShopShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);
	
	BS_WriteValue(bitstream, PR_INT8, 0 );
	BS_WriteValue(bitstream, PR_INT8, _position );
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) );
	BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock SetShopHide ( playerid, _position )
{
	#if defined debug_packet
		printf ( "[SetShopHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);
	
	BS_WriteValue(bitstream, PR_INT8, 1 );
	BS_WriteValue(bitstream, PR_INT8, _position );

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock UpdateShopItem ( playerid, _b_type, _str [ ] )
{
	#if defined debug_packet
		printf ( "[UpdateShopItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New(), line_string [ 48 ], price, _b_id = GetPVarInt ( playerid, "p_biz_id" ),
		_perk_stats = get_perk_info ( playerid, PERK_COLLECTIONER ), _price ;
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	if ( _b_type == bizz_type_shop )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_ITEM_IN_SHOP);
		BS_WriteValue(bitstream, PR_INT8, 2);
		for ( new i = 0 ; i < MAX_ITEM_IN_SHOP ; i ++ )
		{
			price = b_price_market [ _b_id - 1 ] [ i ] ;
			if ( mafia_player ( playerid ) )
			{
				if ( b_info [ _b_id - 1 ] [ b_mafia ] == p_info [ playerid ] [ member ] )
				{
				    price = floatround ( ( b_price_market [ _b_id - 1 ] [ i ] * 50 ) / 100 ) ;
				}
			}
			
			_price = price ;
			if ( _perk_stats > 0 ) price = price - floatround ( ( _price * _perk_stats ) / 100 ) ;
			format ( line_string, sizeof line_string, "{33AA33}%s%s", GetPlayerCashValueToSmile ( price ), _str ) ;
			
			BS_WriteValue(
				bitstream,
				PR_INT8, b_shop [ i ] [ bs_type ],
				PR_INT32, b_shop [ i ] [ bs_model ],
			
				PR_UINT8, 1,
				PR_UINT8, 1,
				
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
		
				PR_UINT8, strlen ( "" ),
				PR_STRING, "",
	
				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string ) ;
		}
	}
	else if ( _b_type == bizz_type_ammo )
	{
		BS_WriteValue(bitstream, PR_UINT8, 24);
		BS_WriteValue(bitstream, PR_INT8, 2);
		for ( new i = 0 ; i < 24 ; i ++ )
		{
			if ( i < MAX_AMMO_IN_SHOP )
			{
				price = b_price_market [ _b_id - 1 ] [ i ] ;
				if ( mafia_player ( playerid ) )
				{
					if ( b_info [ _b_id - 1 ] [ b_mafia ] == p_info [ playerid ] [ member ] )
					{
						price = floatround ( ( b_price_market [ _b_id - 1 ] [ i ] * 50 ) / 100 ) ;
					}
				}
				
				_price = price ;
				if ( _perk_stats > 0 ) price = price - floatround ( ( _price * _perk_stats ) / 100 ) ;
				format ( line_string, sizeof line_string, "{33AA33}%s%s", GetPlayerCashValueToSmile ( price ), _str ) ;
				
				BS_WriteValue(
					bitstream,
					PR_INT8, b_gun_shop [ i ] [ bs_type ],
					PR_INT32, b_gun_shop [ i ] [ bs_model ],
				
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
			
					PR_UINT8, strlen ( "" ),
					PR_STRING, "",
				
					PR_UINT8, strlen ( line_string ),
					PR_STRING, line_string);
			}
			else
			{
				BS_WriteValue(
					bitstream,
					PR_INT8, -1,
					PR_INT32, -1,
				
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
			
					PR_UINT8, strlen ( "" ),
					PR_STRING, "",
			
					PR_UINT8, strlen ( "" ),
					PR_STRING, "" ) ;
			}
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock ShowAcessoriesCategory ( playerid )
{
	#if defined debug_packet
		printf ( "[ShowAcessoriesCategory] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_UINT8, accessories_category_count);
	BS_WriteValue(bitstream, PR_INT8, 1);
	for ( new i = 0 ; i < accessories_category_count ; i ++ )
	{
		BS_WriteValue(bitstream, PR_INT8, 0);
		BS_WriteValue(bitstream, PR_INT32, accessories_items [ i ] [ 0 ]);
			
		BS_WriteValue(bitstream, PR_UINT8, 1);
		BS_WriteValue(bitstream, PR_UINT8, 1);
			
		BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( "" ) );
		BS_WriteValue(bitstream, PR_STRING, "" ) ;
			
		BS_WriteValue(bitstream, PR_UINT8, strlen ( accessories_category [ i ] ) );
		BS_WriteValue(bitstream, PR_STRING, accessories_category [ i ]);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock ShowAcessoriesSet ( playerid, _iType )
{
	#if defined debug_packet
		printf ( "[ShowAcessoriesSet] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);
	
	new _count = 0, line_string [ 64 ] ;
	for ( new i = 0 ; i < 20 ; i ++ )
	{
		if ( accessories_items [ _iType ] [ i ] == 1 ) break ;
		
		_count ++ ;
	}
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_UINT8, _count);
	BS_WriteValue(bitstream, PR_INT8, 1);
	for ( new i = 0 ; i < _count ; i ++ )
	{
		BS_WriteValue(bitstream, PR_INT8, 0);
		BS_WriteValue(bitstream, PR_INT32, accessories_items [ _iType ] [ i ]);
			
		BS_WriteValue(bitstream, PR_UINT8, 1);
		BS_WriteValue(bitstream, PR_UINT8, 1);
			
		BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( "" ) );
		BS_WriteValue(bitstream, PR_STRING, "" ) ;
		
		format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( accessories_items_price [ _iType ] [ i ] ) ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) );
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock ShowSkinsSet ( playerid )
{
	#if defined debug_packet
		printf ( "[ShowSkinsSet] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New(), line_string [ 48 ] ;
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);
	
	new _iType = p_info [ playerid ] [ gender ] ;
	
	new _count = 0 ;
	for ( new i = 0 ; i < MAX_SKIN_IN_SHOP ; i ++ )
	{
		if ( shop_skins [ _iType ] [ i ] == 0 ) break ;
		
		_count ++ ;
	}
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_UINT8, _count);
	BS_WriteValue(bitstream, PR_INT8, 1);
	for ( new i = 0 ; i < _count ; i ++ )
	{
		BS_WriteValue(bitstream, PR_INT8, 2);
		BS_WriteValue(bitstream, PR_INT32, shop_skins [ _iType ] [ i ]);
			
		BS_WriteValue(bitstream, PR_UINT8, 1);
		BS_WriteValue(bitstream, PR_UINT8, 1);
			
		BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( "" ) );
		BS_WriteValue(bitstream, PR_STRING, "" ) ;
		
		format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( shop_skins_price [ _iType ] [ i ] ) ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) );
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock SetShopReset ( playerid )
{
	#if defined debug_packet
		printf ( "[SetShopReset] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOP);

	BS_WriteValue(bitstream, PR_INT8, 3);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}