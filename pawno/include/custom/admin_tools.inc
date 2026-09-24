#define PACKET_CUSTOMRPC    			251
#define RPC_ADMIN_TOOLS					0x142

stock adminLogsShow ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ] )
{
	#if defined debug_packet
		printf ( "[adminLogsShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str3 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str4 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str4 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str5 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str5 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock adminLogsHide ( playerid )
{
	#if defined debug_packet
		printf ( "[adminLogsHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock adminMenuItem ( playerid )
{
	#if defined debug_packet
		printf ( "[adminMenuItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
	
	BS_WriteValue(bitstream, PR_INT8, 2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, MAX_ADMIN_TOOLS ) ;
	for ( new i = 0 ; i < MAX_ADMIN_TOOLS ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( loggs_type [ i ] [ logg_name ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, loggs_type [ i ] [ logg_name ] ) ;
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock adminLogsItem ( playerid )
{
	#if defined debug_packet
		printf ( "[adminLogsItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
	
	BS_WriteValue(bitstream, PR_INT8, 3 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}