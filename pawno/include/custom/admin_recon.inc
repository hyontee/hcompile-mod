#define PACKET_CUSTOMRPC    			251
#define RPC_RECON_ADMIN					0x134

stock reconShow ( playerid )
{
	#if defined debug_packet
		printf ( "[reconShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RECON_ADMIN);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock reconHide ( playerid )
{
	#if defined debug_packet
		printf ( "[reconHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RECON_ADMIN);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateRecon ( playerid, _str [ ], playerID )
{
	#if defined debug_packet
		printf ( "[updateRecon] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RECON_ADMIN);
	
	BS_WriteValue(bitstream, PR_INT8, 2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_INT32, playerID);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}