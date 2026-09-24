#define PACKET_CUSTOMRPC    			251
#define RPC_MUSIC						0x23

stock musicShow ( playerid, _item_0, _item_1, _volume, bool: _muted, _str [ ] )
{
	#if defined debug_packet
		printf ( "[musicShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MUSIC);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 0,
		
		PR_UINT8, _item_0,
		PR_UINT8, _item_1,
		PR_UINT8, _volume,
		PR_BOOL, _muted,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock musicHide ( playerid )
{
	#if defined debug_packet
		printf ( "[musicHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MUSIC);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock musicAudioSelectorShow ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[musicAudioSelectorShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MUSIC);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		
		PR_UINT8, _id);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock musicAudioSelectorHide ( playerid )
{
	#if defined debug_packet
		printf ( "[musicAudioSelectorHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MUSIC);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}