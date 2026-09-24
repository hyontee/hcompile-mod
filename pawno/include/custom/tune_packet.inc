#define PACKET_CUSTOMRPC    			251
#define RPC_TUNING						0x20

new rgb_array_small [ 127 ] [ 12 ] =
{
	"#FFFFFF", "#F5F5F5", "#2A77A1", "#840410", "#263739", "#86446E", "#D78E10", "#4C75B7", "#BDBEC6", "#5E7072",
	"#46597A", "#656A79", "#5D7E8D", "#58595A", "#D6DAD6", "#9CA1A3", "#335F3F", "#730E1A", "#7B0A2A", "#9F9D94",
	"#3B4E78", "#732E3E", "#691E3B", "#96918C", "#515459", "#3F3E45", "#A5A9A7", "#635C5A", "#3D4A68", "#979592",
	"#421F21", "#5F272B", "#8494AB", "#767B7C", "#646464", "#5A5752", "#252527", "#2D3A35", "#93A396", "#6D7A88",
	"#221918", "#6F675F", "#7C1C2A", "#5F0A15", "#193826", "#5D1B20", "#9D9872", "#7A7560", "#989586", "#ADB0B0",
	"#848988", "#304F45", "#4D6268", "#162248", "#272F4B", "#7D6256", "#9EA4AB", "#9C8D71", "#6D1822", "#4E6881",
	"#9C9C98", "#917347", "#661C26", "#949D9F", "#A4A7A5", "#8E8C46", "#341A1E", "#6A7A8C", "#AAAD8E", "#AB988F",
	"#851F2E", "#6F8297", "#585853", "#9AA790", "#601A23", "#20202C", "#A4A096", "#AA9D84", "#78222B", "#0E316D",
	"#722A3F", "#7B715E", "#741D28", "#1E2E32", "#4D322F", "#7C1B44", "#2E5B20", "#395A83", "#6D2837", "#A7A28F",
	"#AFB1B1", "#364155", "#6D6C6E", "#0F6A89", "#204B6B", "#2B3E57", "#9B9F9D", "#6C8495", "#4D8495", "#AE9B7F",
	"#406C8F", "#1F253B", "#AB9276", "#134573", "#96816C", "#64686A", "#105082", "#A19983", "#385694", "#525661",
	"#7F6956", "#8C929A", "#596E87", "#473532", "#44624F", "#730A27", "#223457", "#640D1B", "#A3ADC6", "#695853",
	"#9B8B80", "#620B1C", "#5B5D5E", "#624428", "#731827", "#1B376D", "#EC6AAE"
} ;

stock showTune ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[showTune] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 0,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock hideTune ( playerid )
{
	#if defined debug_packet
		printf ( "[hideTune] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carCharacteristicLayout ( playerid, bool: status, _str [ ] )
{
	#if defined debug_packet
		printf ( "[carCharacteristicLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	
    BS_WriteValue(bitstream, PR_BOOL, status ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carCharacteristicAdd ( playerid, _str [ ], max, progress, _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[carCharacteristicAdd] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 3,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT32, max,
		PR_UINT32, progress,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carCharacteristicUpdate ( playerid, _position, _str [ ], max, progress, _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[carCharacteristicUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 4,
	
		PR_INT8, _position,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT32, max,
		PR_UINT32, progress,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carColorLayout ( playerid, bool: status, _str [ ], bool: status2, bool: status3 )
{
	#if defined debug_packet
		printf ( "[carColorLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 5,
	
		PR_BOOL, status,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_BOOL, status2,
		PR_BOOL, status3 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock colorsAdd ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[colorsAdd] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 6);
	
	BS_WriteValue(bitstream, PR_UINT8, sizeof rgb_array);
	for ( new i = 0 ; i < sizeof rgb_array ; i ++ )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, _type,
		
			PR_UINT8, strlen ( rgb_array_small [ i ] ),
			PR_STRING, rgb_array_small [ i ] ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carWheelsLayout ( playerid, bool: status, _str [ ] )
{
	#if defined debug_packet
		printf ( "[carWheelsLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 7);
	
    BS_WriteValue(bitstream, PR_BOOL, status ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carWheelsSettings ( playerid, _position, bool: status, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _seek )
{
	#if defined debug_packet
		printf ( "[carWheelsSettings] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 8,
	
		PR_INT8, _position,
		PR_BOOL, status,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,
	
		PR_INT8, _seek ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carTintSettingsLayout ( playerid, bool: status, _str [ ] )
{
	#if defined debug_packet
		printf ( "[carTintSettingsLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 9);
	
    BS_WriteValue(bitstream, PR_BOOL, status ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carTintSettings ( playerid, _position, bool: status, _str [ ], _str2 [ ], _str3 [ ], _seek )
{
	#if defined debug_packet
		printf ( "[carTintSettings] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 10,
	
		PR_INT8, _position,
		PR_BOOL, status,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_INT8, _seek ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock menuAdd ( playerid, _position, _str [ ], _icon )
{
	#if defined debug_packet
		printf ( "[menuAdd] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 11,
	
		PR_UINT8, max_items,
	
		PR_INT8, _position,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_INT8, icon);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carComponentAdd ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ], _type, _model, _str7 [ ], _str8 [ ], _str9 [ ] )
{
	#if defined debug_packet
		printf ( "[carComponentAdd] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 12,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,
	
		PR_UINT8, strlen ( _str5 ),
		PR_STRING, _str5,
	
		PR_UINT8, strlen ( _str6 ),
		PR_STRING, _str6,
	
		PR_INT8, _type,
		PR_UINT32, _model,
		
		PR_UINT8, 1,
		PR_UINT8, 1,
	
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
	
		PR_UINT8, strlen ( _str7 ),
		PR_STRING, _str7,
	
		PR_UINT8, strlen ( _str8 ),
		PR_STRING, _str8,
	
		PR_UINT8, strlen ( _str9 ),
		PR_STRING, _str9 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carComponentUpdate ( playerid, _position, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _str5 [ ], _str6 [ ], _type, _model, _str7 [ ], _str8 [ ], _str9 [ ] )
{
	#if defined debug_packet
		printf ( "[carComponentUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 13,
	
		PR_INT8, _position,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,
	
		PR_UINT8, strlen ( _str5 ),
		PR_STRING, _str5,
	
		PR_UINT8, strlen ( _str6 ),
		PR_STRING, _str6,
	
		PR_INT8, _type,
		PR_UINT32, _model,
		
		PR_UINT8, 1,
		PR_UINT8, 1,
	
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
	
		PR_UINT8, strlen ( _str7 ),
		PR_STRING, _str7,
	
		PR_UINT8, strlen ( _str8 ),
		PR_STRING, _str8,
	
		PR_UINT8, strlen ( _str9 ),
		PR_STRING, _str9 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock clearMenu ( playerid, _position )
{
	#if defined debug_packet
		printf ( "[clearMenu] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 14);
	
	BS_WriteValue(bitstream, PR_INT8, _position);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carComponentClear ( playerid )
{
	#if defined debug_packet
		printf ( "[carComponentClear] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 15);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock carCartLayout ( playerid, bool: status, _str [ ] )
{
	#if defined debug_packet
		printf ( "[carCartLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 16);
	
    BS_WriteValue(bitstream, PR_BOOL, status ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock addCartItem ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[addCartItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 17);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock clearCartItem ( playerid )
{
	#if defined debug_packet
		printf ( "[clearCartItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
	
	BS_WriteValue(bitstream, PR_INT8, 18);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}