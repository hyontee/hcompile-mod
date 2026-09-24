#define PACKET_CUSTOMRPC    			251
#define RPC_QUEST_SHOW					0x260
#define RPC_QUEST_HIDE					0x261

stock SetShowQuest ( playerid, _str [ ], _str2 [ ], _str3 [ ], bool: _buttonCancel, bool: _questShow )
{
	#if defined debug_packet
		printf ( "[SetShowQuest] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUEST_SHOW);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str3 ) ;

	BS_WriteValue(bitstream, PR_BOOL, _buttonCancel ) ;
	BS_WriteValue(bitstream, PR_BOOL, _questShow ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetHideQuest ( playerid )
{
	#if defined debug_packet
		printf ( "[SetHideQuest] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUEST_HIDE);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}
