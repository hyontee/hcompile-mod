#define PACKET_CUSTOMRPC    			251
#define RPC_AZS							0x139

stock showAzs ( playerid, bool: status, _price, _fuel, _valute [ ] )
{
	#if defined debug_packet
		printf ( "[showAzs] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AZS);
	
	BS_WriteValue(bitstream, PR_INT8, 0 ) ;
	
	BS_WriteValue(bitstream, PR_BOOL, status ) ;
	BS_WriteValue(bitstream, PR_INT32, _price ) ;
	BS_WriteValue(bitstream, PR_INT32, _fuel ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _valute ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _valute ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock hideAzs ( playerid )
{
	#if defined debug_packet
		printf ( "[hideAzs] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AZS);
	
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock azsAddItem ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[azsAddItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AZS);
	
	BS_WriteValue(bitstream, PR_INT8, 2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, MAX_FUELL_OTHER ) ;
	new line_string [ 64 ], _b_id = GetPVarInt ( playerid, "f_biz" ) ;
	for ( new i = 0 ; i < MAX_FUELL_OTHER ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( b_fill_name [ i ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, b_fill_name [ i ] ) ;
		
		format ( line_string, sizeof line_string, "%s%s", GetPlayerCashValueToSmile ( b_price_market [ _b_id ] [ i + 1 ] ), _str ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}