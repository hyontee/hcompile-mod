#define PACKET_CUSTOMRPC    			251
#define RPC_RENT_SHOW					0x190
#define RPC_RENT_HIDE					0x191
#define RPC_RENT_SETUP					0x192

stock SetRentShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetRentShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RENT_SHOW);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRentHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetRentHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RENT_HIDE);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRentSetUp ( playerid, _modelId, _maxSpeed, _rentPrice )
{
	#if defined debug_packet
		printf ( "[SetRentSetUp] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RENT_SETUP);
	
	BS_WriteValue(bitstream, PR_UINT16, _modelId);
	BS_WriteValue(bitstream, PR_UINT16, _maxSpeed);
	BS_WriteValue(bitstream, PR_UINT32, _rentPrice);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}