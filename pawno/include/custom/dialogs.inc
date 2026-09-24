#define PACKET_CUSTOMRPC    			251
#define RPC_DIALOGS 					0x111

stock showSelectorDialog ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ], _str7 [ ], _str8 [ ] )
{
	#if defined debug_packet
		printf ( "[showSelectorDialog] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_DIALOGS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 0,
	
		PR_UINT32, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT32, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT32, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT32, strlen ( _str4 ),
		PR_STRING, _str4,
	
		PR_UINT32, strlen ( _str5 ),
		PR_STRING, _str5,
	
		PR_UINT32, strlen ( _str6 ),
		PR_STRING, _str6,
	
		PR_UINT32, strlen ( _str7 ),
		PR_STRING, _str7,
	
		PR_UINT32, strlen ( _str8 ),
		PR_STRING, _str8 ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock hideSelectorDialog ( playerid )
{
	#if defined debug_packet
		printf ( "[hideSelectorDialog] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_DIALOGS);

    BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock dialogSeekBar ( playerid, bool: status, _str [ ], _str2 [ ], _str3 [ ], _progress, _max )
{
	#if defined debug_packet
		printf ( "[dialogSeekBar] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_DIALOGS);

    BS_WriteValue(
		bitstream,
		PR_INT8, 2,
	
		PR_BOOL, status,
	
		PR_UINT32, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT32, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT32, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_INT32, _max,
		PR_INT32, _progress);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}