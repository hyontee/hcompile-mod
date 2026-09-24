#define PACKET_CUSTOMRPC    			251
#define RPC_ACTION						0x172

stock actionShow ( playerid, _str [ ], _time )
{
	#if defined debug_packet
		printf ( "[actionShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 0,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
		
		PR_INT32, _time);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actionHide ( playerid )
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

stock actionClickShow ( playerid, _percent )
{
	#if defined debug_packet
		printf ( "[actionClickShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT32, _percent);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actionClickHide ( playerid )
{
	#if defined debug_packet
		printf ( "[actionClickHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}