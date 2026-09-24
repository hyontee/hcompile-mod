#define PACKET_CUSTOMRPC    			251
#define RPC_MARKET						0x131

stock marketShow ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[marketShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MARKET);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 1,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock marketHide ( playerid )
{
	#if defined debug_packet
		printf ( "[marketHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MARKET);
	
	BS_WriteValue(bitstream, PR_INT8, 2);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock marketInvAddItem ( playerid, _type, _str [ ] )
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MARKET);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	
	new _count = sizeof market_buy_item, line_string [ 32 ] ;
	if ( _type == 1 )
	{
		BS_WriteValue(bitstream, PR_UINT8, _count);
		for ( new i = 0 ; i < _count ; i ++ )
		{
			if ( i >= MAX_PRISE_SLOT )
			{
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
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
					
				continue ;
			}
			
			new _id = p_info [ playerid ] [ prise_slot ] [ i ] ;
			if ( _id < 1 )
			{
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
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
			else
			{
				format ( line_string, sizeof line_string, "%d %s", p_info [ playerid ] [ prise_slot_count ] [ i ], _str ) ;
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
					PR_INT8, item_render_type ( _id ),
					PR_UINT32, item_object_id ( playerid, _id ),
			
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( line_string ),
					PR_STRING, line_string,
					
					PR_UINT8, strlen ( "#FFFFFF" ),
					PR_STRING, "#FFFFFF" ) ;
			}
		}
	}
	else if ( _type == 2 )
	{
		BS_WriteValue(bitstream, PR_UINT8, _count);
		for ( new i = 0 ; i < _count ; i ++ )
		{
			new _id = market_buy_item [ i ] ;
			if ( _id < 1 )
			{
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
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
			else
			{
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
					PR_INT8, item_render_type ( _id ),
					PR_UINT32, item_object_id ( playerid, _id ),
			
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
}

stock marketInvUpdateItem ( playerid, _slot_id, _str [ ] )
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MARKET);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	
	BS_WriteValue(bitstream, PR_UINT8, 1);
	new _id = p_info [ playerid ] [ prise_slot ] [ _slot_id ], line_string [ 32 ] ;
	if ( _id < 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT32, _slot_id,
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
	else
	{
		format ( line_string, sizeof line_string, "%d %s", p_info [ playerid ] [ prise_slot_count ] [ _slot_id ], _str ) ;
		BS_WriteValue(
			bitstream,
			PR_INT32, _slot_id,
			PR_INT8, item_render_type ( _id ),
			PR_UINT32, item_object_id ( playerid, _id ),
		
			PR_UINT8, 1,
			PR_UINT8, 1,
				
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
			
			PR_UINT8, strlen ( line_string ),
			PR_STRING, line_string,
				
			PR_UINT8, strlen ( "#FFFFFF" ),
			PR_STRING, "#FFFFFF" ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock marketAddItem ( playerid, _type, _str [ ] )
{
	#if defined debug_packet
		printf ( "[marketAddItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MARKET);
	
	BS_WriteValue(bitstream, PR_INT8, 4);
	
	new _m_id = player_market [ playerid ], line_string [ 32 ] ;

	BS_WriteValue(bitstream, PR_UINT8, sizeof market_buy_item);
	if ( _type == 1 )
	{
		for ( new i = 0 ; i < sizeof market_buy_item ; i ++ )
		{
			new _id = market_info [ _m_id ] [ m_item_model ] [ i ] ;
			if ( _id < 1 )
			{
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
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
			else
			{
				format ( line_string, sizeof line_string, "%d %s", market_info [ _m_id ] [ m_item_count ] [ i ], _str ) ;
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
					PR_INT8, item_render_type ( _id ),
					PR_INT32, item_object_id ( playerid, _id ),
				
					PR_UINT8, 1,
					PR_UINT8, 1,
						
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( line_string ),
					PR_STRING, line_string,
					
					PR_UINT8, strlen ( "#FFFFFF" ),
					PR_STRING, "#FFFFFF" ) ;
			}
		}
	}
	else if ( _type == 2 )
	{
		for ( new i = 0 ; i < sizeof market_buy_item ; i ++ )
		{
			new _id = market_info [ _m_id ] [ m_item_buy_model ] [ i ] ;
			if ( _id < 1 )
			{
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
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
			else
			{
				format ( line_string, sizeof line_string, "%d %s", market_info [ _m_id ] [ m_item_buy_count ] [ i ], _str ) ;
				BS_WriteValue(
					bitstream,
					PR_INT32, i,
					PR_INT8, item_render_type ( _id ),
					PR_INT32, item_object_id ( playerid, _id ),
				
					PR_UINT8, 1,
					PR_UINT8, 1,
						
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( line_string ),
					PR_STRING, line_string,
					
					PR_UINT8, strlen ( "#FFFFFF" ),
					PR_STRING, "#FFFFFF" ) ;
			}
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock marketUpdateItem ( playerid, _slot_id, _type, _str [ ] )
{
	#if defined debug_packet
		printf ( "[marketUpdateItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MARKET);
	
	BS_WriteValue(bitstream, PR_INT8, 4);
	
	new _m_id = player_market [ playerid ], line_string [ 32 ] ;

	BS_WriteValue(bitstream, PR_UINT8, 1);
	if ( _type == 1 )
	{
		new _id = market_info [ _m_id ] [ m_item_model ] [ _slot_id ] ;
		if ( _id < 1 )
		{
			BS_WriteValue(
				bitstream,
				PR_INT32, _slot_id,
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
		else
		{
			format ( line_string, sizeof line_string, "%d %s", market_info [ _m_id ] [ m_item_count ] [ _slot_id ], _str ) ;
			BS_WriteValue(
				bitstream,
				PR_INT32, _slot_id,
				PR_INT8, item_render_type ( _id ),
				PR_INT32, item_object_id ( playerid, _id ),
			
				PR_UINT8, 1,
				PR_UINT8, 1,
					
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
			
				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string,
				
				PR_UINT8, strlen ( "#FFFFFF" ),
				PR_STRING, "#FFFFFF" ) ;
		}
	}
	else if ( _type == 2 )
	{
		new _id = market_info [ _m_id ] [ m_item_buy_model ] [ _slot_id ] ;
		if ( _id < 1 )
		{
			BS_WriteValue(
				bitstream,
				PR_INT32, _slot_id,
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
		else
		{
			format ( line_string, sizeof line_string, "%d %s", market_info [ _m_id ] [ m_item_buy_count ] [ _slot_id ], _str ) ;
			BS_WriteValue(
				bitstream,
				PR_INT32, _slot_id,
				PR_INT8, item_render_type ( _id ),
				PR_INT32, item_object_id ( playerid, _id ),
			
				PR_UINT8, 1,
				PR_UINT8, 1,
					
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
			
				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string,
				
				PR_UINT8, strlen ( "#FFFFFF" ),
				PR_STRING, "#FFFFFF" ) ;
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}