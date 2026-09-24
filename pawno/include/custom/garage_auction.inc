#define PACKET_CUSTOMRPC    			251
#define RPC_CONTAINER					0x143

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock containerShow ( playerid )
{
	#if defined debug_packet
		printf ( "[containerShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerHide ( playerid )
{
	#if defined debug_packet
		printf ( "[containerHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 1);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerUpdateData ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ] )
{
	#if defined debug_packet
		printf ( "[containerUpdateData] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 2,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,
	
		PR_UINT8, strlen ( _str5 ),
		PR_STRING, _str5);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerShowInput ( playerid, bool: status, _str [ ], _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[containerShowInput] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 3,
	
		PR_BOOL, status,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerAddItem ( playerid )
{
	#if defined debug_packet
		printf ( "[containerAddItem] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 4);
	
	new _item, _con_id = player_container_id [ playerid ], _count = 0, _g_type = g_auction_info [ _con_id ] [ g_type ] ;
	if ( _g_type == 4 )
	{
		for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
		{
			if ( garage_item [ i ] [ gar_type ] != GARAGE_RENDER_CAR ) continue ;
			
			_count ++ ;
		}
	}
	else
	{
		for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
		{
			if ( garage_item [ i ] [ gar_type ] == GARAGE_RENDER_CAR ) continue ;
			if ( garage_item [ i ] [ gar_rare ] == ROU_ITEM_COMMON ) continue ;
			
			_count ++ ;
		}
	}

    BS_WriteValue(bitstream, PR_UINT8, _count);
	for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
	{
		if ( _g_type == 4 )
		{
			if ( garage_item [ i ] [ gar_type ] != GARAGE_RENDER_CAR ) continue ;
		}
		else
		{
			if ( garage_item [ i ] [ gar_type ] == GARAGE_RENDER_CAR ) continue ;
			if ( garage_item [ i ] [ gar_rare ] == ROU_ITEM_COMMON ) continue ;
		}
		
		_item = garage_item [ i ] [ gar_model ] ;
		if ( _item == 0 ) continue ;
			
		BS_WriteValue(
			bitstream,
			PR_INT8, garage_item [ i ] [ gar_type ],
			PR_UINT32, _item,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
		
			PR_FLOAT, garage_item [ i ] [ gar_rotX ],
			PR_FLOAT, garage_item [ i ] [ gar_rotY ],
			PR_FLOAT, garage_item [ i ] [ gar_rotZ ],
			PR_FLOAT, garage_item [ i ] [ gar_angle ],
			
			PR_UINT8, garage_item [ i ] [ gar_rare ],
	
			PR_UINT8, strlen ( garage_item [ i ] [ gar_name ] ),
			PR_STRING, garage_item [ i ] [ gar_name ]);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerPrizeShow ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[containerShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 5);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerPrizeHide ( playerid )
{
	#if defined debug_packet
		printf ( "[containerPrizeHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 6);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerPrizeClear ( playerid )
{
	#if defined debug_packet
		printf ( "[containerPrizeClear] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 7);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock containerPrizeAddItem ( playerid, _count, _id )
{
	#if defined debug_packet
		printf ( "[containerPrizeAddItem] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CONTAINER);
	
    BS_WriteValue(bitstream, PR_INT8, 8);
	
	BS_WriteValue(bitstream, PR_UINT8, _count);
	for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
	{
		new _id_slot = g_auction_info [ _id ] [ g_slot ] [ i ] ;
		if ( _id_slot == -1 ) continue ;
		
		new _item = garage_item [ _id_slot ] [ gar_model ] ;
		if ( _item == 0 ) continue ;
			
		BS_WriteValue(
			bitstream,
			PR_INT8, garage_item [ _id_slot ] [ gar_type ],
			PR_UINT32, _item,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
		
			PR_FLOAT, garage_item [ _id_slot ] [ gar_rotX ],
			PR_FLOAT, garage_item [ _id_slot ] [ gar_rotY ],
			PR_FLOAT, garage_item [ _id_slot ] [ gar_rotZ ],
			PR_FLOAT, garage_item [ _id_slot ] [ gar_angle ],
			
			PR_UINT8, garage_item [ _id_slot ] [ gar_rare ],
	
			PR_UINT8, strlen ( garage_item [ _id_slot ] [ gar_name ] ),
			PR_STRING, garage_item [ _id_slot ] [ gar_name ]);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}