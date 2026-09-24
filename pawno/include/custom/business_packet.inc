#define PACKET_CUSTOMRPC    			251
#define RPC_BUSINESS					0x171

stock bizShow ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[bizShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 0,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizHide ( playerid )
{
	#if defined debug_packet
		printf ( "[bizHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizLayoutPage ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[bizLayoutPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 2,
	
		PR_UINT8, _id ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizAddItem ( playerid, _id, _type, bool: _locked, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ], _str7 [ ], _str8 [ ] )
{
	#if defined debug_packet
		printf ( "[bizAddItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 3,
	
		PR_INT32, _id,
		PR_INT8, _type,
		PR_BOOL, _locked,

		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,

		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,

		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,

		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,

		PR_UINT8, strlen ( _str5 ),
		PR_STRING, _str5,

		PR_UINT8, strlen ( _str6 ),
		PR_STRING, _str6,

		PR_UINT8, strlen ( _str7 ),
		PR_STRING, _str7,

		PR_UINT8, strlen ( _str8 ),
		PR_STRING, _str8 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizLayoutUpdate ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _type, bool: _locked )
{
	#if defined debug_packet
		printf ( "[bizLayoutUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 4,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,

		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,

		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,

		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,

		PR_INT8, _type,
		PR_BOOL, _locked ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizMenuItem ( playerid, _id, _str [ ] )
{
	#if defined debug_packet
		printf ( "[bizMenuItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 5,
	
		PR_INT32, _id,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizMainItem ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[bizMainItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 6,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizParentItem ( playerid, _position, _str [ ], bool: status )
{
	#if defined debug_packet
		printf ( "[bizParentItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 7,
	
		PR_INT32, _position,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bizChildItem ( playerid, _position, _id, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[bizChildItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BUSINESS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 8,
	
		PR_INT32, _position,
		PR_INT32, _id,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}