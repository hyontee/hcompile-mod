#define PACKET_CUSTOMRPC    			251
#define RPC_FISHING						0x144

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock fishingShow ( playerid )
{
	#if defined debug_packet
		printf ( "[fishingShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FISHING);
	
    BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock fishingHide ( playerid )
{
	#if defined debug_packet
		printf ( "[fishingHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FISHING);
	
    BS_WriteValue(bitstream, PR_INT8, 1);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock fishingUpdate ( playerid, _str [ ], bool: animation )
{
	#if defined debug_packet
		printf ( "[fishingUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FISHING);
	
    BS_WriteValue(bitstream, PR_INT8, 2);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str);
	
    BS_WriteValue(bitstream, PR_BOOL, animation ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock fishingFirstPerson ( playerid, bool: first_person )
{
	#if defined debug_packet
		printf ( "[fishingFirstPerson] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FISHING);
	
    BS_WriteValue(bitstream, PR_INT8, 3);
	
    BS_WriteValue(bitstream, PR_BOOL, first_person ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}