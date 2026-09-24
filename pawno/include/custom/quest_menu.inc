#define PACKET_CUSTOMRPC    			251
#define RPC_QUESTS						0x145

stock questsShow ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[questsShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;
	BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock questsHide ( playerid )
{
	#if defined debug_packet
		printf ( "[questsHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock addQuestsItem ( playerid, _id, _type, _model, _str [ ], _str2 [ ], _progress, _max )
{
	#if defined debug_packet
		printf ( "[addQuestsItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,

		PR_INT8, _id,
		PR_INT8, _type,
		PR_INT32, _model,
	
		PR_UINT8, 1,
		PR_UINT8, 1,
			
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_INT32, _max,
		PR_INT32, _progress);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock addQuestRewardsItem ( playerid, _type, _model, _str [ ] )
{
	#if defined debug_packet
		printf ( "[addQuestRewardsItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 3,
			
		PR_INT8, _type,
		PR_INT32, _model,
	
		PR_UINT8, 1,
		PR_UINT8, 1,
			
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateQuestsData ( playerid, _str [ ], _str2 [ ], _progress, _max, _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[updateQuestsData] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 4,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_INT32, _max,
		PR_INT32, _progress,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock setQuestButtons ( playerid, _str [ ], bool: _cancel )
{
	#if defined debug_packet
		printf ( "[setQuestButtons] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);

	BS_WriteValue(
		bitstream,
		PR_INT8, 5,

		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,

		PR_BOOL, _cancel ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock clearQuestItems ( playerid )
{
	#if defined debug_packet
		printf ( "[clearQuestItems] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);

	BS_WriteValue(bitstream, PR_INT8, 6 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock selectQuestItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[selectQuestItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_QUESTS);

	BS_WriteValue(
		bitstream,
		PR_INT8, 7,
		PR_INT8, _id ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}
