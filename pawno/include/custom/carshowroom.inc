#define PACKET_CUSTOMRPC    			251
#define RPC_CARSHOWROOM                 0x65

stock scrShow ( playerid )
{
	#if defined debug_packet
		printf ( "[actionShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock scrHide ( playerid )
{
	#if defined debug_packet
		printf ( "[actionHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock scrUpdate ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ], _str7 [ ] )
{
	#if defined debug_packet
		printf ( "[actionClickShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTION);
	
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
		PR_STRING, _str5,
		
		PR_UINT8, strlen ( _str6 ),
		PR_STRING, _str6,
		
		PR_UINT8, strlen ( _str7 ),
		PR_STRING, _str7);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}