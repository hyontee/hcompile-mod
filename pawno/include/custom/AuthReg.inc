#define PACKET_CUSTOMRPC    			251
#define RPC_AUTH_REG					0x112

stock authShow ( playerid )
{
	#if defined debug_packet
		printf ( "[authShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock authHide ( playerid )
{
	#if defined debug_packet
		printf ( "[authHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock authLoadedBar ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[authLoadedBar] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 2 ) ;
	
	BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock authCheckedParams ( playerid, _position, bool: status )
{
	#if defined debug_packet
		printf ( "[authCheckedParams] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 3 ) ;
	
	BS_WriteValue(bitstream, PR_INT8, _position ) ;
	BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock authUpdateParams ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[authUpdateParams] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
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
		PR_STRING, _str4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock setAuthRemember ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[setAuthRemember] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 5 ) ;
	
	BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock authMessage ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[authMessage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 6 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regShow ( playerid )
{
	#if defined debug_packet
		printf ( "[regShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 10 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regHide ( playerid )
{
	#if defined debug_packet
		printf ( "[regHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 11 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regCheckedParams ( playerid, _position, bool: status )
{
	#if defined debug_packet
		printf ( "[regCheckedParams] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 12 ) ;
	
	BS_WriteValue(bitstream, PR_INT8, _position ) ;
	BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regMessage ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[regMessage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 13 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regPedShow ( playerid )
{
	#if defined debug_packet
		printf ( "[regPedShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 20 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regPedHide ( playerid )
{
	#if defined debug_packet
		printf ( "[regPedHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 21 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regPedClothes ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[regPedClothes] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 22 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock regPedMessage ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[regPedMessage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTH_REG);
	
	BS_WriteValue(bitstream, PR_INT8, 23 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}