#define PACKET_CUSTOMRPC    			251
#define RPC_NEWBIE_BATTLE 				0x72

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock newbieHide ( playerid )
{
	#if defined debug_packet
		printf ( "[newbieHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock newbieShow ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[newbieShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 1);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock selectNewBie ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[selectNewBie] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 2);
	
	BS_WriteValue(bitstream, PR_INT8, _id);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock newbieUpdateMainLayout ( playerid, _str [ ], _str2 [ ], bool: limitButton, _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[newbieUpdateMainLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 3,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
		
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_BOOL, limitButton,
		
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock newbieAddTasks ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[newbieAddTasks] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 4);
	
	BS_WriteValue(bitstream, PR_UINT8, MAX_PLAYER_EP_QUEST);
	new _id, line_string [ 32 ] ;
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		_id = gNewBieQuestStatus [ playerid ] [ i ] ;
		BS_WriteValue(
			bitstream,
			PR_UINT16, strlen ( QuestData [ _id ] [ eqName ] ),
			PR_STRING, QuestData [ _id ] [ eqName ],
		
			PR_UINT16, strlen ( QuestData [ _id ] [ eqDescription ] ),
			PR_STRING, QuestData [ _id ] [ eqDescription ] ) ;
		
		format ( line_string, sizeof line_string, "%d/%d", gNewBieQuestProgress [ playerid ] [ i ], QuestData [ _id ] [ eqProgress ] ) ;
		BS_WriteValue(bitstream, PR_UINT16, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
		
		BS_WriteValue(
			bitstream,
			PR_UINT32, QuestData [ _id ] [ eqProgress ],
			PR_UINT32, gNewBieQuestProgress [ playerid ] [ i ],
	
			PR_INT8, -1,
			PR_INT32, 54,

			PR_UINT8, 1,
			PR_UINT8, 1,
		
			PR_FLOAT, 20.0,
			PR_FLOAT, 180.0,
			PR_FLOAT, 45.0,
			PR_FLOAT, 0.78,
		
			PR_UINT8, 0);
		
		format ( line_string, sizeof line_string, "+%d %s", QuestData [ _id ] [ eqEPassEXP ], _str ) ;
		BS_WriteValue(bitstream, PR_UINT16, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock newbieAddGuideMainLayout ( playerid )
{
	#if defined debug_packet
		printf ( "[newbieAddGuideMainLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 5);
	
	BS_WriteValue(bitstream, PR_UINT8, 5);
	for ( new i = 0 ; i < 5 ; i ++ )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, i,
		
			PR_UINT16, strlen ( AdviceTitle [ i ] ),
			PR_STRING, AdviceTitle [ i ],
		
			PR_UINT16, strlen ( AdviceText [ i ] ),
			PR_STRING, AdviceText [ i ] ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

enum
{
	BATTLE_STAT_USE,
	BATTLE_STAT_NOT_LVL,
	BATTLE_STAT_BLOCKED,
	BATTLE_STAT_ACCEPT
} ;

stock newbieAddBPItem ( playerid, _start )
{
	#if defined debug_packet
		printf ( "[newbieAddBPItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 6);
	
	BS_WriteValue(bitstream, PR_UINT8, 10);
	new _epass = gNewBiePassLVL { playerid }, line_string [ 32 ], _exp ;
	for ( new i = _start - 10 ; i < _start ; i ++ )
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( NewBiePass [ i ] [ bpiName ] ),
			PR_STRING, NewBiePass [ i ] [ bpiName ],
		
			PR_UINT8, strlen ( NewBiePass [ i ] [ bpiName ] ),
			PR_STRING, NewBiePass [ i ] [ bpiName ]);
		
		if ( _epass >= i && gNewBiePA [ playerid ] == i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
		else
		{
			if ( gNewBiePA [ playerid ] > i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
			else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
		}
		
		BS_WriteValue(bitstream, PR_INT8, NewBiePass [ i ] [ bpiRare ] ) ;
		if ( NewBiePass [ i ] [ bpiRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, NewBiePass [ i ] [ bpiAmount ] ) ;
		else
		{
			if ( NewBiePass [ i ] [ bpiType ] == BP_INVENTORY ) BS_WriteValue(bitstream, PR_UINT32, item_object_id ( playerid, NewBiePass [ i ] [ bpiAmount ] ) ) ;
			else BS_WriteValue(bitstream, PR_UINT32, NewBiePass [ i ] [ bpiType ] ) ;
		}
		
		BS_WriteValue(bitstream, PR_INT8, NewBiePass [ i ] [ bpiRender ] ) ;
		BS_WriteValue(bitstream, PR_INT8, i ) ;
		
		_exp = i * 100 ;
		if ( _epass > i )
		{
			format ( line_string, sizeof line_string, "%d EXP", _exp ) ;
			BS_WriteValue(
				bitstream,
				PR_UINT32, 100,
				PR_UINT32, 100,
		
				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string ) ;
		}
		else if ( _epass == i )
		{
			format ( line_string, sizeof line_string, "%d EXP", gNewBiePassEXP { playerid } + _exp ) ;
			BS_WriteValue(
				bitstream,
				PR_UINT32, 100,
				PR_UINT32, gNewBiePassEXP { playerid },
		
				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string ) ;
		}
		else
		{
			format ( line_string, sizeof line_string, "%d EXP", _exp ) ;
			BS_WriteValue(
				bitstream,
				PR_UINT32, 100,
				PR_UINT32, 0,
		
				PR_UINT8, strlen ( line_string ),
				PR_STRING, line_string ) ;
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock newbieUpdateBPItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[newbieUpdateBPItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 7);
	
	new _epass = gNewBiePassLVL { playerid }, line_string [ 32 ], _exp ;
    BS_WriteValue(bitstream, PR_INT8, _id);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( NewBiePass [ _id ] [ bpiName ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, NewBiePass [ _id ] [ bpiName ]);
		
	BS_WriteValue(bitstream, PR_UINT8, strlen ( NewBiePass [ _id ] [ bpiName ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, NewBiePass [ _id ] [ bpiName ]);
	
	if ( _epass >= _id && gNewBiePA [ playerid ] == _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
	else
	{
		if ( gNewBiePA [ playerid ] > _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
		else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
	}
		
	BS_WriteValue(bitstream, PR_INT8, NewBiePass [ _id ] [ bpiRare ] ) ;
	if ( NewBiePass [ _id ] [ bpiRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, NewBiePass [ _id ] [ bpiAmount ] ) ;
	else
	{
		if ( NewBiePass [ _id ] [ bpiType ] == BP_INVENTORY ) BS_WriteValue(bitstream, PR_UINT32, item_object_id ( playerid, NewBiePass [ _id ] [ bpiAmount ] ) ) ;
		else BS_WriteValue(bitstream, PR_UINT32, NewBiePass [ _id ] [ bpiType ] ) ;
	}
		
	BS_WriteValue(bitstream, PR_INT8, NewBiePass [ _id ] [ bpiRender ] ) ;
	BS_WriteValue(bitstream, PR_INT8, _id ) ;
	
	_exp = _id * 100 ;
	if ( _epass > _id )
	{
		BS_WriteValue(bitstream, PR_UINT32, 100 ) ;
		BS_WriteValue(bitstream, PR_UINT32, 100 ) ;
		
		format ( line_string, sizeof line_string, "%d EXP", _exp ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}
	else if ( _epass == _id )
	{
		BS_WriteValue(bitstream, PR_UINT32, 100 ) ;
		BS_WriteValue(bitstream, PR_UINT32, gNewBiePassEXP { playerid } ) ;
		
		format ( line_string, sizeof line_string, "%d EXP", gNewBiePassEXP { playerid } + _exp ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}
	else
	{
		BS_WriteValue(bitstream, PR_UINT32, 100 ) ;
		BS_WriteValue(bitstream, PR_UINT32, 0 ) ;
		
		format ( line_string, sizeof line_string, "%d EXP", _exp ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock newbieMiniPrize ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[newbieMiniPrize] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_NEWBIE_BATTLE);
	
    BS_WriteValue(bitstream, PR_INT8, 8);
    BS_WriteValue(bitstream, PR_INT8, _id);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}