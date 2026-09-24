#define PACKET_CUSTOMRPC    			251
#define RPC_BATTLE_PASS 				0x71

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock bpHide ( playerid )
{
	#if defined debug_packet
		printf ( "[bpHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bpShow ( playerid, _str [ ], bool: button, _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[bpShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 1,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,

		PR_BOOL, button,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock buyBattlePass ( playerid, bool: status, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[buyBattlePass] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 2,

		PR_BOOL, status,
	
		PR_UINT16, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT16, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT16, strlen ( _str3 ),
		PR_STRING, _str3,
	
		PR_UINT16, strlen ( _str4 ),
		PR_STRING, _str4);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock updateBuyBattlePass ( playerid, _id, bool: status )
{
	#if defined debug_packet
		printf ( "[updateBuyBattlePass] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
	new _render = bp_buy_item [ _id ] [ bp_render ] ;
    BS_WriteValue(
		bitstream,
		PR_INT8, 3,
	
		PR_INT8, _id,
		PR_BOOL, status,
	
		PR_INT8, _render,
		PR_UINT32, ( _render == BATTLEPASS_RENDER_OBJECT ) ? ( item_object_id ( playerid, bp_buy_item [ _id ] [ bp_model ] ) ) : ( bp_buy_item [ _id ] [ bp_model ] ),
		
		PR_UINT8, 1,
		PR_UINT8, 1,
	
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
		
		PR_UINT8, strlen ( bp_buy_item [ _id ] [ bp_color ] ),
		PR_STRING, bp_buy_item [ _id ] [ bp_color ],
	
		PR_UINT8, strlen ( item_name ( bp_buy_item [ _id ] [ bp_model ] ) ),
		PR_STRING, item_name ( bp_buy_item [ _id ] [ bp_model ] ) ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock selectBattlePass ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[selectBattlePass] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 4);
	
	BS_WriteValue(bitstream, PR_INT8, _id);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bpUpdateMainLayout ( playerid, _str [ ], _str2 [ ], bool: limitButton, _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[bpUpdateMainLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 5,
		
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

stock bpUpdateDayTaskLayout ( playerid, _id, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ], _max, _progress, _str5 [ ], _str6 [ ] )
{
	#if defined debug_packet
		printf ( "[bpUpdateDayTaskLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 6,
		
		PR_INT8, _id,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
		
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
		
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
		
		PR_UINT8, strlen ( _str4 ),
		PR_STRING, _str4,
		
		PR_UINT32, _max,
		PR_UINT32, _progress,
		
		PR_UINT8, strlen ( _str5 ),
		PR_STRING, _str5,
		
		PR_UINT8, strlen ( _str6 ),
		PR_STRING, _str6);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bpUpdateDayTasksPrize ( playerid, _id, _qid, bool: status, _str [ ] )
{
	#if defined debug_packet
		printf ( "[bpUpdateDayTasksPrize] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
	new _model = GlobalQuestData [ _qid ] [ goPriseModel ] [ _id ] ;
    BS_WriteValue(
		bitstream,
		PR_INT8, 7,
	
		PR_INT8, _id,
		PR_BOOL, status,
	
		PR_INT8, GlobalQuestData [ _qid ] [ goPriseType ] [ _id ],
		PR_UINT32, ( _model != 54 ) ? ( item_object_id ( playerid, _model ) ) : ( 54 ),
		
		PR_UINT8, 1,
		PR_UINT8, 1,
	
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78 ) ;
	
	if ( _model != 54 )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( item_name ( _model ) ) ) ;
		BS_WriteValue(bitstream, PR_STRING, item_name ( _model ) ) ;
	}
	else
	{
		new line_string [ 64 ] ;
		format ( line_string, sizeof line_string, "+%d %s", GlobalQuestData [ _qid ] [ goPriseCount ] [ _id ], _str ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bpAddTasks ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[bpAddTasks] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 8);
	
	BS_WriteValue(bitstream, PR_UINT8, MAX_PLAYER_EP_QUEST);
	new _id, line_string [ 32 ] ;
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		_id = gPlayerEventQuestStatus [ playerid ] [ i ] ;
		BS_WriteValue(bitstream, PR_UINT16, strlen ( QuestData [ _id ] [ eqName ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, QuestData [ _id ] [ eqName ] ) ;
		
		BS_WriteValue(bitstream, PR_UINT16, strlen ( QuestData [ _id ] [ eqDescription ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, QuestData [ _id ] [ eqDescription ] ) ;
		
		format ( line_string, sizeof line_string, "%d/%d", gPlayerEventQuestProgress [ playerid ] [ i ], QuestData [ _id ] [ eqProgress ] ) ;
		BS_WriteValue(bitstream, PR_UINT16, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
		
		BS_WriteValue(bitstream, PR_UINT32, QuestData [ _id ] [ eqProgress ] ) ;
		BS_WriteValue(bitstream, PR_UINT32, gPlayerEventQuestProgress [ playerid ] [ i ] ) ;
	
		BS_WriteValue(bitstream, PR_INT8, -1);
		BS_WriteValue(bitstream, PR_INT32, 54);

		BS_WriteValue(bitstream, PR_UINT8, 1);
		BS_WriteValue(bitstream, PR_UINT8, 1);
		
		BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
		
		BS_WriteValue(bitstream, PR_UINT8, 0);
		
		format ( line_string, sizeof line_string, "+%d %s", QuestData [ _id ] [ eqEPassEXP ], _str ) ;
		BS_WriteValue(bitstream, PR_UINT16, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock bpAddGuideMainLayout ( playerid )
{
	#if defined debug_packet
		printf ( "[bpAddGuideMainLayout] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 9);
	
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

stock bpAddBPItem ( playerid, _start )
{
	#if defined debug_packet
		printf ( "[bpAddBPItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 10);
	
	BS_WriteValue(bitstream, PR_UINT8, 10);
	new _epass = gPlayerBattlePassLVL { playerid }, bool: _premium = gPlayerBattlePassPrem [ playerid ], line_string [ 32 ], _exp ;
	for ( new i = _start - 10 ; i < _start ; i ++ )
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( BattlePass [ i ] [ bpiName ] ),
			PR_STRING, BattlePass [ i ] [ bpiName ],
		
			PR_UINT8, strlen ( BattlePass [ i ] [ bpiPremName ] ),
			PR_STRING, BattlePass [ i ] [ bpiPremName ],
		
			PR_UINT8, strlen ( BattlePass [ i ] [ bpiName ] ),
			PR_STRING, BattlePass [ i ] [ bpiName ]);
		
		if ( _epass >= i && gPlayerPA [ playerid ] == i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
		else
		{
			if ( gPlayerPA [ playerid ] > i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
			else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
		}
		
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiRare ] ) ;
		if ( BattlePass [ i ] [ bpiRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiAmount ] ) ;
		else
		{
			if ( BattlePass [ i ] [ bpiType ] == BP_INVENTORY ) BS_WriteValue(bitstream, PR_UINT32, item_object_id ( playerid, BattlePass [ i ] [ bpiAmount ] ) ) ;
			else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiType ] ) ;
		}
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ i ] [ bpiPremName ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, BattlePass [ i ] [ bpiPremName ]);
		
		if ( _premium )
		{
			if ( _epass >= i && gPlayerPAPrem [ playerid ] == i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
			else
			{
				if ( gPlayerPAPrem [ playerid ] > i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
				else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
			}
		}
		else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_BLOCKED ) ;
			
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiPremRare ] ) ;
		if ( BattlePass [ i ] [ bpiPremRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiPremAmount ] ) ;
		else
		{
			if ( BattlePass [ i ] [ bpiPremType ] == BP_INVENTORY ) BS_WriteValue(bitstream, PR_UINT32, item_object_id ( playerid, BattlePass [ i ] [ bpiPremAmount ] ) ) ;
			else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiPremType ] ) ;
		}
		
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiRender ] ) ;
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiPremRender ] ) ;
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
			format ( line_string, sizeof line_string, "%d EXP", gPlayerBattlePassEXP { playerid } + _exp ) ;
			BS_WriteValue(
				bitstream,
				PR_UINT32, 100,
				PR_UINT32, gPlayerBattlePassEXP { playerid },
		
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

stock bpUpdateBPItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[bpUpdateBPItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 11);
	
	new _epass = gPlayerBattlePassLVL { playerid }, bool: _premium = gPlayerBattlePassPrem [ playerid ], line_string [ 32 ], _exp ;
    BS_WriteValue(
		bitstream,
		PR_INT8, _id,
	
		PR_UINT8, strlen ( BattlePass [ _id ] [ bpiName ] ),
		PR_STRING, BattlePass [ _id ] [ bpiName ],
		
		PR_UINT8, strlen ( BattlePass [ _id ] [ bpiPremName ] ),
		PR_STRING, BattlePass [ _id ] [ bpiPremName ],
		
		PR_UINT8, strlen ( BattlePass [ _id ] [ bpiName ] ),
		PR_STRING, BattlePass [ _id ] [ bpiName ] ) ;
	
	if ( _epass >= _id && gPlayerPA [ playerid ] == _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
	else
	{
		if ( gPlayerPA [ playerid ] > _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
		else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
	}
		
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiRare ] ) ;
	if ( BattlePass [ _id ] [ bpiRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiAmount ] ) ;
	else
	{
		if ( BattlePass [ _id ] [ bpiType ] == BP_INVENTORY ) BS_WriteValue(bitstream, PR_UINT32, item_object_id ( playerid, BattlePass [ _id ] [ bpiAmount ] ) ) ;
		else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiType ] ) ;
	}
		
	BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ _id ] [ bpiPremName ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, BattlePass [ _id ] [ bpiPremName ]);

	if ( _premium )
	{
		if ( _epass >= _id && gPlayerPAPrem [ playerid ] == _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
		else
		{
			if ( gPlayerPAPrem [ playerid ] > _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
			else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
		}
	}
	else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_BLOCKED ) ;
		
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiPremRare ] ) ;
	if ( BattlePass [ _id ] [ bpiPremRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiPremAmount ] ) ;
	else
	{
		if ( BattlePass [ _id ] [ bpiPremType ] == BP_INVENTORY ) BS_WriteValue(bitstream, PR_UINT32, item_object_id ( playerid, BattlePass [ _id ] [ bpiPremAmount ] ) ) ;
		else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiPremType ] ) ;
	}
		
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiRender ] ) ;
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiPremRender ] ) ;
	BS_WriteValue(bitstream, PR_INT8, _id ) ;
	
	_exp = _id * 100 ;
	if ( _epass > _id )
	{
		format ( line_string, sizeof line_string, "%d EXP", _exp ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT32, 100,
			PR_UINT32, 100,
		
			PR_UINT8, strlen ( line_string ),
			PR_STRING, line_string ) ;
	}
	else if ( _epass == _id )
	{
		format ( line_string, sizeof line_string, "%d EXP", gPlayerBattlePassEXP { playerid } + _exp ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT32, 100,
			PR_UINT32, gPlayerBattlePassEXP { playerid },
		
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

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CaseRouletteHide ( playerid )
{
	#if defined debug_packet
		printf ( "[CaseRouletteHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 12);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CaseRoulettePage ( playerid, _itemlvl, bool: canRoll, _maxItems )
{
	#if defined debug_packet
		printf ( "[CaseRoulettePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 13);
	
    BS_WriteValue(bitstream, PR_UINT32, _itemlvl);
    BS_WriteValue(bitstream, PR_BOOL, canRoll);
    BS_WriteValue(bitstream, PR_UINT32, _maxItems);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CaseRouletteShowPrize ( playerid, _model, _str [ ] )
{
	#if defined debug_packet
		printf ( "[CaseRouletteShowPrize] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(bitstream, PR_INT8, 14);
	
    BS_WriteValue(bitstream, PR_UINT32, _model);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CaseRouletteItem ( playerid )
{
	#if defined debug_packet
		printf ( "[CaseRouletteItem] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
	BS_WriteValue(bitstream, PR_INT8, 15);
	
	BS_WriteValue(bitstream, PR_UINT8, MAX_BATTLE_PASS_ROULETTE_ITEMS);
	for ( new i = 0 ; i < MAX_BATTLE_PASS_ROULETTE_ITEMS ; i ++ )
	{
		new _id = player_case [ playerid ] [ i ] ;
		new _item = bp_roulette [ _id ] [ bp_model ] ;
		if ( _item == 0 ) continue ;
		
		new _render = bp_roulette [ _id ] [ bp_render ] ;
		if ( _render == BATTLEPASS_RENDER_SKIN )
		{
			BS_WriteValue(
				bitstream,
				PR_INT8, _render,
				PR_UINT32, _item,
			
				PR_UINT8, 1,
				PR_UINT8, 1,
		
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
			
				PR_UINT8, bp_roulette [ _id ] [ bp_rare ],
				
				PR_UINT8, strlen ( item_name ( _item + skin_cross ) ),
				PR_STRING, item_name ( _item + skin_cross ) ) ;
		}
		else
		{
			BS_WriteValue(
				bitstream,
				PR_INT8, _render,
				PR_UINT32, _item,
			
				PR_UINT8, 1,
				PR_UINT8, 1,
		
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
			
				PR_UINT8, bp_roulette [ _id ] [ bp_rare ],
				
				PR_UINT8, strlen ( item_name ( _item ) ),
				PR_STRING, item_name ( _item ) ) ;
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CaseRouletteGlasses ( playerid, _type, _model, _rareLevel, _name [ ] )
{
	#if defined debug_packet
		printf ( "[CaseRouletteGlasses] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_PASS);
	
    BS_WriteValue(
		bitstream,
		PR_INT8, 16,
	
		PR_INT8, _type,
		PR_UINT32, _model,
		
		PR_UINT8, 1,
		PR_UINT8, 1,
	
		PR_FLOAT, 20.0,
		PR_FLOAT, 180.0,
		PR_FLOAT, 45.0,
		PR_FLOAT, 0.78,
			
		PR_UINT8, _rareLevel,
	
		PR_UINT8, strlen ( _name ),
		PR_STRING, _name);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}