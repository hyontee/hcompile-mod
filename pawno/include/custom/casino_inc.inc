#define PACKET_CUSTOMRPC    			251

#define RPC_CASINO						0x150

stock SetAppleStart ( playerid )
{
	#if defined debug_packet
		printf ( "[SetAppleStart] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetAppleStop ( playerid )
{
	#if defined debug_packet
		printf ( "[SetAppleStop] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetAppleProcessBid ( playerid, touch_id, result_id, bool: status, process_id )
{
	#if defined debug_packet
		printf ( "[SetAppleProcessBid] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 2);
	
	BS_WriteValue(bitstream, PR_UINT8, touch_id);
	BS_WriteValue(bitstream, PR_UINT8, result_id);
	BS_WriteValue(bitstream, PR_BOOL, status);
	BS_WriteValue(bitstream, PR_UINT8, process_id);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetAppleShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetAppleShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBinaryShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetBinaryShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 4);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBinaryStart ( playerid, _old_value )
{
	#if defined debug_packet
		printf ( "[SetBinaryStart] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 5);
	
	BS_WriteValue(bitstream, PR_UINT32, _old_value);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBinaryValue ( playerid, _new_value, _win_value )
{
	#if defined debug_packet
		printf ( "[SetBinaryValue] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 6);
	
	BS_WriteValue(bitstream, PR_UINT32, _new_value);
	BS_WriteValue(bitstream, PR_UINT32, _win_value);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetRouletteShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 7);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteStart ( playerid, _win_id, _win_cash )
{
	#if defined debug_packet
		printf ( "[SetRouletteStart] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 8);
	
	BS_WriteValue(bitstream, PR_UINT8, _win_id);
	BS_WriteValue(bitstream, PR_UINT32, _win_cash);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetJackpotShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetJackpotShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 9);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetJackpotHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetJackpotHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 10);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetJackpotStart ( playerid, _slot_combination, _slot_win )
{
	#if defined debug_packet
		printf ( "[SetJackpotStart] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 11);
	
	BS_WriteValue(bitstream, PR_INT32, _slot_combination);
	BS_WriteValue(bitstream, PR_INT32, _slot_win);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetWheelShow ( playerid, _type, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SetWheelShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 12);
	
	BS_WriteValue(bitstream, PR_UINT8, _type);
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ));
	BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetWheelHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetWheelHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 13);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetWheelUpdate ( playerid, _winValue, _winType, _winModel, _winColor1, _winColor2, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SetWheelUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 14);
	
	BS_WriteValue(bitstream, PR_UINT32, _winValue);
	BS_WriteValue(bitstream, PR_UINT8, _winType);
	BS_WriteValue(bitstream, PR_UINT16, _winModel);
	BS_WriteValue(bitstream, PR_UINT8, _winColor1);
	BS_WriteValue(bitstream, PR_UINT8, _winColor2);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ));
	BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetDiceCubes ( playerid, _left, _right )
{
	#if defined debug_packet
		printf ( "[SetDiceCubes] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);

	BS_WriteValue(
		bitstream,
		PR_INT8, 23,

		PR_INT8, _left,
		PR_INT8, _right ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock SetDiceShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetDiceShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 15);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetDiceHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetDiceHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 16);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateDice ( playerid, _type, _str [ ], _time, _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[updateDice] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 17);
	
    BS_WriteValue(bitstream, PR_INT8, _type);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
    BS_WriteValue(bitstream, PR_INT32, _type);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str3 ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str4 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock addGamerItem ( playerid, _str [ ], _type, bool: status, _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[addGamerItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 18);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
    BS_WriteValue(bitstream, PR_INT8, _type);
    BS_WriteValue(bitstream, PR_BOOL, status);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock addGamerUpdate ( playerid, _str [ ], _type, bool: status, _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[addGamerUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 19);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
    BS_WriteValue(bitstream, PR_INT8, _type);
    BS_WriteValue(bitstream, PR_BOOL, status);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock clearGamerItem ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[clearGamerItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 20);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock addChatItem ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[addChatItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 21);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock diceBetScreen ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[diceBetScreen] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CASINO);
	
    BS_WriteValue(bitstream, PR_INT8, 22);
	
    BS_WriteValue(bitstream, PR_BOOL, status ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}