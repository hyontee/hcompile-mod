#define PACKET_CUSTOMRPC    			251
#define RPC_OBJECT_EDIT					0x133

stock editShow ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[editShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_OBJECT_EDIT);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;
	BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock editHide ( playerid )
{
	#if defined debug_packet
		printf ( "[editHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_OBJECT_EDIT);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateEditScale ( playerid, Float: _scale )
{
	#if defined debug_packet
		printf ( "[updateEditScale] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_OBJECT_EDIT);
	
	BS_WriteValue(bitstream, PR_INT8, 2 ) ;
	BS_WriteValue(bitstream, PR_FLOAT, _scale ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}