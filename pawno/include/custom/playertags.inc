#define PACKET_CUSTOMRPC    			251
#define RPC_PLAYER_TAG					0x141

stock SetPlayerTag ( playerid, targetid, bool: status, _str [ ], _type, _color, _colorBox )
{
	#if defined debug_packet
		printf ( "[SetPlayerTag] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLAYER_TAG);
	
	BS_WriteValue(
		bitstream,
		PR_UINT16, targetid,
		PR_BOOL, status,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, _type,
		PR_UINT32, _color,
		PR_UINT32, _colorBox ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}
