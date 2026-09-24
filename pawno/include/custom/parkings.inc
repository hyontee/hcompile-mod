#define PACKET_CUSTOMRPC    			251
#define RPC_PARKING_SHOW				0x135
#define RPC_PARKING_HIDE				0x136
#define RPC_PARKING_CAR					0x137
#define RPC_PARKING_DIALOG				0x138

stock SetParkingShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetParkingShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PARKING_SHOW);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetParkingHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetParkingHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PARKING_HIDE);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetParkingCar ( playerid )
{
	#if defined debug_packet
		printf ( "[SetParkingCar] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PARKING_CAR);
	

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetParkingDialog ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[SetParkingDialog] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PARKING_DIALOG);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str3 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str4 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}