#if !defined PACKET_CUSTOMRPC
	#define PACKET_CUSTOMRPC			251
#endif
#define RPC_PLATES						0x146

stock platesShow ( playerid )
{
	#if defined debug_packet
		printf ( "[platesShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 0 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesHide ( playerid )
{
	#if defined debug_packet
		printf ( "[platesHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesLayout ( playerid, _layout )
{
	#if defined debug_packet
		printf ( "[platesLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 2,
		PR_INT8, _layout ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesMainLayout ( playerid, _str [ ], _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[platesMainLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 3,
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesTabLayout ( playerid, _tab, bool: _editable )
{
	#if defined debug_packet
		printf ( "[platesTabLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 4,
		PR_INT8, _tab,
		PR_BOOL, _editable ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesTabDescription ( playerid, _tab, _str [ ] )
{
	#if defined debug_packet
		printf ( "[platesTabDescription] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 5,
		PR_INT8, _tab,
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesTabButton ( playerid, _tab, _str [ ] )
{
	#if defined debug_packet
		printf ( "[platesTabButton] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 6,
		PR_INT8, _tab,
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock platesTabButtonText ( playerid, _tab, _str [ ] )
{
	#if defined debug_packet
		printf ( "[platesTabButtonText] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLATES);

	BS_WriteValue(bitstream, PR_INT8, 7,
		PR_INT8, _tab,
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}
