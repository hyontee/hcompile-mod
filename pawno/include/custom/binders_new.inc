#define PACKET_CUSTOMRPC    			251
#define RPC_BINDERS						0x123

stock bindShow ( playerid )
{
	#if defined debug_packet
		printf ( "[bindShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindHide ( playerid )
{
	#if defined debug_packet
		printf ( "[bindHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindAddItem ( playerid )
{
	#if defined debug_packet
		printf ( "[bindAddItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(bitstream, PR_INT8, 2 ) ;
    BS_WriteValue(bitstream, PR_UINT8, player_binder_count [ playerid ] ) ;
	
	new line_string [ 64 ] ;
	for ( new i = 0 ; i < MAX_BINDS ; i ++ )
	{
		if ( player_binder [ playerid ] [ i ] [ bind_insert_id ] == -1 ) continue ;
		
		BS_WriteValue(bitstream, PR_INT8, i ) ;
		
		format ( line_string, sizeof line_string, "{"#cWH"}%s", player_binder [ playerid ] [ i ] [ bind_name ] ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindUpdateItem ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[bindAddItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(bitstream, PR_INT8, 3 ) ;
    BS_WriteValue(bitstream, PR_UINT8, player_binder_count [ playerid ] ) ;
	
	new line_string [ 64 ] ;
	for ( new i = 0 ; i < MAX_BINDS ; i ++ )
	{
		if ( player_binder [ playerid ] [ i ] [ bind_insert_id ] == -1 ) continue ;
		
		BS_WriteValue(bitstream, PR_INT8, i ) ;
		
		if ( status ) format ( line_string, sizeof line_string, "{"#cGN"}%s", player_binder [ playerid ] [ i ] [ bind_name ] ) ;
		else format ( line_string, sizeof line_string, "{"#cWH"}%s", player_binder [ playerid ] [ i ] [ bind_name ] ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindEditShow ( playerid )
{
	#if defined debug_packet
		printf ( "[bindEditShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(bitstream, PR_INT8, 4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindEditHide ( playerid )
{
	#if defined debug_packet
		printf ( "[bindEditHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(bitstream, PR_INT8, 5 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindEditAddItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[bindEditAddItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 6,
		PR_UINT8, 6,
	
		PR_UINT8, strlen ( "Name" ),
		PR_STRING, "Name",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_name ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_name ],

		PR_UINT8, strlen ( "1" ),
		PR_STRING, "1",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_1 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_1 ],

		PR_UINT8, strlen ( "2" ),
		PR_STRING, "2",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_2 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_2 ],

		PR_UINT8, strlen ( "3" ),
		PR_STRING, "3",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_3 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_3 ],

		PR_UINT8, strlen ( "4" ),
		PR_STRING, "4",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_4 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_4 ],

		PR_UINT8, strlen ( "5" ),
		PR_STRING, "5",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_5 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bindEditUpdateItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[bindEditUpdateItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BINDERS);

	BS_WriteValue(
		bitstream,
		PR_INT8, 7,
		PR_UINT8, 6,
	
		PR_INT8, 0,
		PR_UINT8, strlen ( "Name" ),
		PR_STRING, "Name",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_name ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_name ],

		PR_INT8, 1,
		PR_UINT8, strlen ( "1" ),
		PR_STRING, "1",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_1 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_1 ],

		PR_INT8, 2,
		PR_UINT8, strlen ( "2" ),
		PR_STRING, "2",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_2 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_2 ],

		PR_INT8, 3,
		PR_UINT8, strlen ( "3" ),
		PR_STRING, "3",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_3 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_3 ],

		PR_INT8, 4,
		PR_UINT8, strlen ( "4" ),
		PR_STRING, "4",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_4 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_4 ],

		PR_INT8, 5,
		PR_UINT8, strlen ( "5" ),
		PR_STRING, "5",
		PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_5 ] ),
		PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}
