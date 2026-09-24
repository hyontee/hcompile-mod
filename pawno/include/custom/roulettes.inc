#define PACKET_CUSTOMRPC    			251
#define RPC_ROULETTE					0x121

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock SetCRouletteHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetCRouletteHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetCRoulettePage ( playerid, _itemlvl, bool: canRoll, _maxItems )
{
	#if defined debug_packet
		printf ( "[SetCRoulettePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 1);
	
    BS_WriteValue(bitstream, PR_UINT32, _itemlvl);
    BS_WriteValue(bitstream, PR_BOOL, canRoll);
    BS_WriteValue(bitstream, PR_UINT32, _maxItems);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetCRoulette ( playerid, _type, _model, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SetCRoulette] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 2);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, _type,
		PR_UINT32, _model,
	
		PR_UINT8, 1,
		PR_UINT8, 1,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetCRouletteItem ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[SetCRouletteItem] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 3);
	
	if ( _type == 0 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_BRONZE_PRISE);
		for ( new i = 0 ; i < MAX_BRONZE_PRISE ; i ++ )
		{
			new _item = rou_item_bronze [ i ] [ rou_model ] ;
			if ( _item == 0 ) continue ;
			
			BS_WriteValue(
				bitstream,
				PR_INT8, rou_item_bronze [ i ] [ rou_type ],
				PR_UINT32, _item,
			
				PR_UINT8, 1,
				PR_UINT8, 1,
		
				PR_FLOAT, rou_item_bronze [ i ] [ rou_rotX ],
				PR_FLOAT, rou_item_bronze [ i ] [ rou_rotY ],
				PR_FLOAT, rou_item_bronze [ i ] [ rou_rotZ ],
				PR_FLOAT, rou_item_bronze [ i ] [ rou_angle ],
			
				PR_UINT8, rou_item_bronze [ i ] [ rou_rare ]);
		}
	}
	else if ( _type == 1 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_SILVER_PRISE);
		for ( new i = 0 ; i < MAX_SILVER_PRISE ; i ++ )
		{
			new _item = rou_item_silver [ i ] [ rou_model ] ;
			if ( _item == 0 ) continue ;
			
			BS_WriteValue(
				bitstream,
				PR_INT8, rou_item_silver [ i ] [ rou_type ],
				PR_UINT32, _item,
			
				PR_UINT8, 1,
				PR_UINT8, 1,
		
				PR_FLOAT, rou_item_silver [ i ] [ rou_rotX ],
				PR_FLOAT, rou_item_silver [ i ] [ rou_rotY ],
				PR_FLOAT, rou_item_silver [ i ] [ rou_rotZ ],
				PR_FLOAT, rou_item_silver [ i ] [ rou_angle ],
			
				PR_UINT8, rou_item_silver [ i ] [ rou_rare ]);
		}
	}
	else if ( _type == 2 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_GOLD_PRISE);
		for ( new i = 0 ; i < MAX_GOLD_PRISE ; i ++ )
		{
			new _item = rou_item_gold [ i ] [ rou_model ] ;
			if ( _item == 0 ) continue ;
			
			BS_WriteValue(
				bitstream,
				PR_INT8, rou_item_gold [ i ] [ rou_type ],
				PR_UINT32, _item,
			
				PR_UINT8, 1,
				PR_UINT8, 1,
		
				PR_FLOAT, rou_item_gold [ i ] [ rou_rotX ],
				PR_FLOAT, rou_item_gold [ i ] [ rou_rotY ],
				PR_FLOAT, rou_item_gold [ i ] [ rou_rotZ ],
				PR_FLOAT, rou_item_gold [ i ] [ rou_angle ],
			
				PR_UINT8, rou_item_gold [ i ] [ rou_rare ]);
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetCRouletteUpdate ( playerid, _type, _str [ ], _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[SetCRouletteUpdate] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 4,
	
		PR_INT8, _type,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteJobHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetRouletteJobHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 5);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteJobPage ( playerid, _itemlvl, bool: canRoll, _maxItems )
{
	#if defined debug_packet
		printf ( "[SetRouletteJobPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 6);
	
    BS_WriteValue(bitstream, PR_UINT32, _itemlvl);
    BS_WriteValue(bitstream, PR_BOOL, canRoll);
    BS_WriteValue(bitstream, PR_UINT32, _maxItems);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteJob ( playerid, _model, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SetRouletteJob] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 7,
	
		PR_UINT32, _model,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteJobItem ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[SetRouletteJobItem] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ROULETTE);
	
    BS_WriteValue(bitstream, PR_INT8, 8);
	
	if ( _type == 1 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_TRUCKER_ITEM);
		for ( new i = 0 ; i < MAX_TRUCKER_ITEM ; i ++ )
		{
			new _item = rou_trucker_item [ i ] [ rou_model ] ;
			if ( _item == 0 ) continue ;
			
			BS_WriteValue(
				bitstream,
				PR_INT8, rou_trucker_item [ i ] [ rou_type ],
				PR_UINT32, _item,
			
				PR_UINT8, 1,
				PR_UINT8, 1,
		
				PR_FLOAT, rou_trucker_item [ i ] [ rou_rotX ],
				PR_FLOAT, rou_trucker_item [ i ] [ rou_rotY ],
				PR_FLOAT, rou_trucker_item [ i ] [ rou_rotZ ],
				PR_FLOAT, rou_trucker_item [ i ] [ rou_angle ],
			
				PR_UINT8, rou_trucker_item [ i ] [ rou_rare ],
	
				PR_UINT8, strlen ( rou_trucker_item [ i ] [ rou_name ] ),
				PR_STRING, rou_trucker_item [ i ] [ rou_name ]);
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}