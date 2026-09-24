#define PACKET_CUSTOMRPC    			251
#define RPC_TRADE 						0x100

stock showTrade ( playerid )
{
	#if defined debug_packet
		printf ( "[showTrade] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 0);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock hideTrade ( playerid )
{
	#if defined debug_packet
		printf ( "[hideTrade] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 1);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeUpdate ( playerid, _str [ ], bool: _accept, bool: _accept2, bool: _accept3, _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[tradeUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(
		bitstream,
		PR_INT8, 2,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_BOOL, _accept,
		PR_BOOL, _accept2,
		PR_BOOL, _accept3,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3 ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeUpdateItem ( playerid, _id, _slot, _type, _model, _str [ ], _str2 [ ], _type_trade )
{
	#if defined debug_packet
		printf ( "[tradeUpdateItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 3);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	BS_WriteValue(bitstream, PR_INT32, _slot ) ;
	
	if ( _model < 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, -1,
			PR_INT32, -1,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
			
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
			
			PR_UINT8, strlen ( "" ),
			PR_STRING, "",

			PR_UINT8, strlen ( "" ),
			PR_STRING, "",
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	else
	{
		BS_WriteValue(
			bitstream,
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
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeAddSendItem ( playerid, _id, _slot, _type, _model, _str [ ], _str2 [ ], _type_trade )
{
	#if defined debug_packet
		printf ( "[tradeAddSendItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 4);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	BS_WriteValue(bitstream, PR_INT32, _slot ) ;
	
	if ( _model < 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, -1,
			PR_INT32, -1,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
			
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
			
			PR_UINT8, strlen ( "" ),
			PR_STRING, "",

			PR_UINT8, strlen ( "" ),
			PR_STRING, "",
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	else
	{
		BS_WriteValue(
			bitstream,
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
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeUpdateSendItem ( playerid, _id, _slot, _type, _model, _str [ ], _str2 [ ], _type_trade )
{
	#if defined debug_packet
		printf ( "[tradeUpdateSendItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 5);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	BS_WriteValue(bitstream, PR_INT32, _slot ) ;
	
	if ( _model < 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, -1,
			PR_INT32, -1,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
			
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
			
			PR_UINT8, strlen ( "" ),
			PR_STRING, "",

			PR_UINT8, strlen ( "" ),
			PR_STRING, "",
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	else
	{
		BS_WriteValue(
			bitstream,
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
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeDeleteSendItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[tradeDeleteSendItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 6);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeAddReceiveItem ( playerid, _id, _slot, _type, _model, _str [ ], _str2 [ ], _type_trade )
{
	#if defined debug_packet
		printf ( "[tradeAddReceiveItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 7);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	BS_WriteValue(bitstream, PR_INT32, _slot ) ;
	
	if ( _model < 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, -1,
			PR_INT32, -1,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
			
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
			
			PR_UINT8, strlen ( "" ),
			PR_STRING, "",

			PR_UINT8, strlen ( "" ),
			PR_STRING, "",
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	else
	{
		BS_WriteValue(
			bitstream,
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
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeUpdateReceiveItem ( playerid, _id, _slot, _type, _model, _str [ ], _str2 [ ], _type_trade )
{
	#if defined debug_packet
		printf ( "[tradeUpdateReceiveItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 8);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	BS_WriteValue(bitstream, PR_INT32, _slot ) ;
	
	if ( _model < 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, -1,
			PR_INT32, -1,
			
			PR_UINT8, 1,
			PR_UINT8, 1,
			
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
			
			PR_UINT8, strlen ( "" ),
			PR_STRING, "",

			PR_UINT8, strlen ( "" ),
			PR_STRING, "",
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	else
	{
		BS_WriteValue(
			bitstream,
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
		
			PR_BOOL, false,
			PR_INT8, _type_trade);
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock tradeDeleteReceiveItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[tradeDeleteReceiveItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TRADE);

    BS_WriteValue(bitstream, PR_INT8, 9);
	
    BS_WriteValue(bitstream, PR_INT32, _id ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}