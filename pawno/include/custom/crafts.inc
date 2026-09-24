#define PACKET_CUSTOMRPC    			251
#define RPC_CRAFT						0x132

stock CraftShow ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[CraftShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(bitstream, PR_INT8, 1);

	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CraftHide ( playerid )
{
	#if defined debug_packet
		printf ( "[CraftHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(bitstream, PR_INT8, 2);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CraftMainAddItem ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[CraftMainAddItem] playerid: %d", playerid ) ;
	#endif
	
	new _count = 0 ;
	for ( new i = 0 ; i < MAX_CRAFT ; i ++ )
	{
		new _c_type = craft_info [ i ] [ c_type ] ;
		if ( _type != _c_type ) continue ;
		
		_count ++ ;
	}
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(bitstream, PR_INT8, 4);

	BS_WriteValue(bitstream, PR_UINT8, _count);
	new line_string [ 24 ] ;
	for ( new i = 0 ; i < MAX_CRAFT ; i ++ )
	{
		new _c_type = craft_info [ i ] [ c_type ] ;
		if ( _type != _c_type ) continue ;
	
		new _id = craft_info [ i ] [ c_item ] ;
		if ( _id < 1 ) continue ;

		BS_WriteValue(bitstream, PR_INT8, i);
		if ( craft_info [ i ] [ c_give_item ] >= skin_cross )
		{
			format ( line_string, sizeof line_string, "%d", craft_info [ i ] [ c_color ] ) ;
			BS_WriteValue(
				bitstream,
				PR_INT8, 1,
				PR_UINT32, _id,
				
				PR_UINT8, strlen ( craft_info [ i ] [ c_name ] ),
				PR_STRING, craft_info [ i ] [ c_name ],

				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string,

				PR_UINT8, 1,
				PR_UINT8, 1,

				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78 ) ;
		}
		else if ( _id >= 400 && _id <= 611 || _id >= 3217 && _id <= 3400 )
		{
			format ( line_string, sizeof line_string, "%d", craft_info [ i ] [ c_color ] ) ;
			BS_WriteValue(
				bitstream,
				PR_INT8, 3,
				PR_UINT32, _id,
				
				PR_UINT8, strlen ( craft_info [ i ] [ c_name ] ),
				PR_STRING, craft_info [ i ] [ c_name ],

				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string,

				PR_UINT8, 1,
				PR_UINT8, 1,

				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78 ) ;
		}
		else
		{
			format ( line_string, sizeof line_string, "%d", craft_info [ i ] [ c_color ] ) ;
			BS_WriteValue(
				bitstream,
				PR_INT8, 2,
				PR_UINT32, _id,
				
				PR_UINT8, strlen ( craft_info [ i ] [ c_name ] ),
				PR_STRING, craft_info [ i ] [ c_name ],

				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string,

				PR_UINT8, 1,
				PR_UINT8, 1,

				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78 ) ;
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateCraftBlocked ( playerid, _position, bool: status, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[updateCraftBlocked] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(bitstream, PR_INT8, 5);

	BS_WriteValue(bitstream, PR_INT8, _position ) ;
	BS_WriteValue(bitstream, PR_BOOL, status ) ;
				
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateCraftCount ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[updateCraftCount] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(bitstream, PR_INT8, 6);
				
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateCraft ( playerid, _position, _max, _progress, _id, _str [ ] )
{
	#if defined debug_packet
		printf ( "[updateCraft] playerid: %d", playerid ) ;
	#endif

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 7,
	
		PR_INT8, _position,
		PR_INT32, _max,
		PR_INT32, _progress,

		PR_INT8, craft_info [ _id ] [ c_type ],
		PR_UINT32, craft_info [ _id ] [ c_item ],

		PR_UINT8, 1,
		PR_UINT8, 1,

		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock rvResItem ( playerid, _id, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[rvResItem] playerid: %d", playerid ) ;
	#endif

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 8,

		PR_INT8, item_render_type ( _id ),
		PR_UINT32, item_object_id ( playerid, _id ),
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,

		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,

		PR_UINT8, 1,
		PR_UINT8, 1,

		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78 ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock craftClearItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[craftClearItem] playerid: %d", playerid ) ;
	#endif

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
	
	BS_WriteValue(bitstream, PR_INT8, 9);
	
	BS_WriteValue(bitstream, PR_INT8, _id);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}