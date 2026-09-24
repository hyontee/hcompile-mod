#define PACKET_CUSTOMRPC    			251
#define RPC_KEYBOARD_BIND				0x250
#define RPC_KEYBOARD_PARAMS				0x251

stock SetKeyboardBind ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[SetKeyboardBind] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_KEYBOARD_BIND);
	
	BS_WriteValue(bitstream, PR_UINT8, player_binder_count [ playerid ] ) ;
	BS_WriteValue(bitstream, PR_INT32, player_binder [ playerid ] [ _id ] [ bind_insert_id ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, player_binder [ playerid ] [ _id ] [ bind_name ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_1 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_2 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_2 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_3 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_3 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_4 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_4 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, player_binder [ playerid ] [ _id ] [ bind_text_5 ] ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetKeyboardParams ( playerid )
{
	#if defined debug_packet
		printf ( "[SetKeyboardParams] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_KEYBOARD_PARAMS);
	
	BS_WriteValue(bitstream, PR_INT16, ( p_info [ playerid ] [ member ] > 0 ) ? ( p_info [ playerid ] [ member ] + 100 ) : ( -1 ) ) ;
	BS_WriteValue(bitstream, PR_INT16, ( p_info [ playerid ] [ family ] > 0 ) ? ( 150 ) : ( -1 ) ) ;
	BS_WriteValue(bitstream, PR_INT16, ( p_info [ playerid ] [ job ] > 0 ) ? ( p_info [ playerid ] [ job ] + 200 ) : ( -1 ) ) ;
	BS_WriteValue(bitstream, PR_INT16, ( Iter_Count(player_houses[playerid]) > 0 ) ? ( 250 ) : ( -1 ) ) ;
	BS_WriteValue(bitstream, PR_INT16, ( Iter_Count(player_business[playerid]) > 0 ) ? ( 300 ) : ( -1 ) ) ;
	BS_WriteValue(bitstream, PR_INT16, ( p_info [ playerid ] [ rent_house ] > 0 ) ? ( 350 ) : ( -1 ) ) ;
	BS_WriteValue(bitstream, PR_INT16, ( p_info [ playerid ] [ cellar ] > 0 ) ? ( 400 ) : ( -1 ) ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}
