#define PACKET_CUSTOMRPC    			251
#define RPC_BATTLE_STATS 				0x70

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock SetBattleHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetBattleHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetMainPage ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[SetMainPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 2);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);
	
	new line_string [ 32 ] ;
	format ( line_string, sizeof line_string, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, line_string);
	
	BS_WriteValue(bitstream, PR_UINT32, gPlayerBattlePassEXP { playerid });
	BS_WriteValue(bitstream, PR_UINT32, 100);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2);

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

stock SetAddBpItem ( playerid, _start )
{
	#if defined debug_packet
		printf ( "[SetAddBpItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 12);
	
	BS_WriteValue(bitstream, PR_UINT8, 10);
	new _epass = gPlayerBattlePassLVL { playerid }, bool: _premium = gPlayerBattlePassPrem [ playerid ] ;
	for ( new i = _start - 10 ; i < _start ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ i ] [ bpiName ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, BattlePass [ i ] [ bpiName ]);
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ i ] [ bpiPremName ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, BattlePass [ i ] [ bpiPremName ]);
		
		BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ i ] [ bpiName ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, BattlePass [ i ] [ bpiName ]);
		
		if ( _epass >= i && gPlayerPA [ playerid ] == i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
		else
		{
			if ( gPlayerPA [ playerid ] > i ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
			else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
		}
		
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiRare ] ) ;
		if ( BattlePass [ i ] [ bpiRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiAmount ] ) ;
		else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiType ] ) ;
		
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
		else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ i ] [ bpiPremType ] ) ;
		
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiRender ] ) ;
		BS_WriteValue(bitstream, PR_INT8, BattlePass [ i ] [ bpiPremRender ] ) ;
		BS_WriteValue(bitstream, PR_INT8, i ) ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock UpdateAddBpItem ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[UpdateAddBpItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 13);
	
	new _epass = gPlayerBattlePassLVL { playerid }, bool: _premium = gPlayerBattlePassPrem [ playerid ] ;
    BS_WriteValue(bitstream, PR_INT8, _id);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ _id ] [ bpiName ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, BattlePass [ _id ] [ bpiName ]);
		
	BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ _id ] [ bpiPremName ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, BattlePass [ _id ] [ bpiPremName ]);
		
	BS_WriteValue(bitstream, PR_UINT8, strlen ( BattlePass [ _id ] [ bpiName ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, BattlePass [ _id ] [ bpiName ]);
	
	if ( _epass >= _id && gPlayerPA [ playerid ] == _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_ACCEPT ) ;
	else
	{
		if ( gPlayerPA [ playerid ] > _id ) BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_USE ) ;
		else BS_WriteValue(bitstream, PR_INT8, BATTLE_STAT_NOT_LVL ) ;
	}
		
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiRare ] ) ;
	if ( BattlePass [ _id ] [ bpiRender ] != BATTLEPASS_NO_RENDER ) BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiAmount ] ) ;
	else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiType ] ) ;
		
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
	else BS_WriteValue(bitstream, PR_UINT32, BattlePass [ _id ] [ bpiPremType ] ) ;
		
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiRender ] ) ;
	BS_WriteValue(bitstream, PR_INT8, BattlePass [ _id ] [ bpiPremRender ] ) ;
	BS_WriteValue(bitstream, PR_INT8, _id ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetTasksPage ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[SetTasksPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 3);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);
	
	new line_string [ 32 ] ;
	format ( line_string, sizeof line_string, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, line_string);
	
	BS_WriteValue(bitstream, PR_UINT32, gPlayerBattlePassEXP { playerid });
	BS_WriteValue(bitstream, PR_UINT32, 100);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetAddTasks ( playerid )
{
	#if defined debug_packet
		printf ( "[SetAddTasks] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 9);
	
    BS_WriteValue(bitstream, PR_UINT8, MAX_PLAYER_EP_QUEST);
	new line_string [ 32 ] ;
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		new _task_id = gPlayerEventQuestStatus [ playerid ] [ i ] ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( QuestData [ _task_id ] [ eqDescription ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, QuestData [ _task_id ] [ eqDescription ]);
		
		new _quest_progress = gPlayerEventQuestProgress [ playerid ] [ i ], _q_max_progress = QuestData [ _task_id ] [ eqProgress ] ;
		format ( line_string, sizeof line_string, "%d/%d", _quest_progress, _q_max_progress ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string);
		
		if ( _quest_progress >= _q_max_progress ) BS_WriteValue(bitstream, PR_INT8, 1);
		else BS_WriteValue(bitstream, PR_INT8, 0);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetExpPage ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[SetExpPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 4);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);
	
	new line_string [ 32 ] ;
	format ( line_string, sizeof line_string, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, line_string);
	
	BS_WriteValue(bitstream, PR_UINT32, gPlayerBattlePassEXP { playerid });
	BS_WriteValue(bitstream, PR_UINT32, 100);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetExpInfo ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[SetExpInfo] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 10);
	
	new line_string [ 32 ] ;
	static const _lvl_price [ ] = { 200, 800, 2700, 499 } ;
	static const _buy_lvl [ ] = { 1, 5, 15, 25 } ;
	
    BS_WriteValue(bitstream, PR_UINT8, 3);
	for ( new i = 0 ; i < 3 ; i ++ )
	{
		BS_WriteValue(bitstream, PR_INT8, i ) ;
		
		format ( line_string, sizeof line_string, "%d", _buy_lvl [ i ] ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string);
		
		format ( line_string, sizeof line_string, "%s %d %s", _str, _lvl_price [ i ], _str2 ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetStatPage ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[SetStatPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 5);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);
	
	new line_string [ 32 ] ;
	format ( line_string, sizeof line_string, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, line_string);
	
	BS_WriteValue(bitstream, PR_UINT32, gPlayerBattlePassEXP { playerid });
	BS_WriteValue(bitstream, PR_UINT32, 100);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBattleStat ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[SetBattleStat] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 14);
	
	new line_string [ 32 ] ;
    BS_WriteValue(bitstream, PR_UINT8, 100);
	for ( new i = 0 ; i < 100 ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( NameTopLeader [ i ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, NameTopLeader [ i ]);
		
		BS_WriteValue(bitstream, PR_INT8, PremiumTopLeader [ i ] );
		
		format ( line_string, sizeof line_string, "%d %s", LevelTopLeader [ i ], _str ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string);
		
		format ( line_string, sizeof line_string, "%d %s", ExpTopLeader [ i ], _str2 ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream, PR_STRING, line_string);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRoulettePage ( playerid, _itemlvl, bool: canRoll, _cost )
{
	#if defined debug_packet
		printf ( "[SetRoulettePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 6);
	
    BS_WriteValue(bitstream, PR_UINT32, _itemlvl);
    BS_WriteValue(bitstream, PR_BOOL, canRoll);
    BS_WriteValue(bitstream, PR_UINT32, _cost);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBattleRoulette ( playerid, _type, _model, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SetBattleRoulette] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 8);
	
    BS_WriteValue(bitstream, PR_INT8, _type);
    BS_WriteValue(bitstream, PR_UINT32, _model);
	
    BS_WriteValue(bitstream, PR_UINT8, 1);
    BS_WriteValue(bitstream, PR_UINT8, 1);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBattleDialog ( playerid, _str [ ], _str2 [ ], _str3 [ ], _str4 [ ] )
{
	#if defined debug_packet
		printf ( "[SetBattleDialog] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 16);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str2);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str3);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( _str4 ) ) ;
    BS_WriteValue(bitstream, PR_STRING, _str4);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetRouletteItem ( playerid )
{
	#if defined debug_packet
		printf ( "[SetRouletteItem] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 15);
	
	BS_WriteValue(bitstream, PR_UINT8, 15);
	for ( new i = 0 ; i < 15 ; i ++ )
	{
		new _id = player_case [ playerid ] [ i ] ;
		new _item = bp_roulette [ _id ] [ bp_model ] ;
		if ( _item == 0 ) continue ;
		
		new _render = bp_roulette [ _id ] [ bp_render ] ;
		BS_WriteValue(bitstream, PR_INT8, _render ) ;
		BS_WriteValue(bitstream, PR_UINT32, _item);
		
		BS_WriteValue(bitstream, PR_UINT8, 1);
		BS_WriteValue(bitstream, PR_UINT8, 1);
	
		BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
		BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
		
		BS_WriteValue(bitstream, PR_UINT8, bp_roulette [ _id ] [ bp_rare ]);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock SetCasePage ( playerid, _rouletteID )
{
	#if defined debug_packet
		printf ( "[SetCasePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 7);
	
    BS_WriteValue(bitstream, PR_UINT32, _rouletteID ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetCaseItem ( playerid, _case_id )
{
	#if defined debug_packet
		printf ( "[SetCaseItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 11);
	
	BS_WriteValue(bitstream, PR_UINT8, 15);
	new _str_name [ 32 ] ;
	for ( new i = 0 ; i < 15 ; i ++ )
	{
		new _id = player_case [ playerid ] [ i ] ;
		new _item, _render ;
		if ( _case_id == BP_LOTTERY )
		{
			_item = bp_case1 [ _id ] [ bp_model ] ;
			_render = bp_case1 [ _id ] [ bp_render ] ;
		}
		else if ( _case_id == BP_LOTTERY2 ) 
		{
			_item = bp_case2 [ _id ] [ bp_model ] ;
			_render = bp_case2 [ _id ] [ bp_render ] ;
		}
		if ( _item == 0 ) continue ;
		
		BS_WriteValue(bitstream, PR_INT8, i ) ;
		
		BS_WriteValue(bitstream, PR_INT8, _render ) ;
		BS_WriteValue(bitstream, PR_UINT32, _item);
		
		if ( _render == BATTLEPASS_RENDER_OBJECT ) format ( _str_name, sizeof _str_name, "%s", get_accessorie_name ( _item ) ) ;
		else if ( _render == BATTLEPASS_RENDER_SKIN ) format ( _str_name, sizeof _str_name, "%s", get_skin_name ( _item ) ) ;
		else if ( _render == BATTLEPASS_RENDER_CAR ) format ( _str_name, sizeof _str_name, "%s", GetVehicleNameEx ( -1, _item ) ) ;
		BS_WriteValue(bitstream, PR_UINT8, strlen ( _str_name ) ) ;
		BS_WriteValue(bitstream, PR_STRING, _str_name);
		
		if ( _case_id == BP_LOTTERY ) BS_WriteValue(bitstream, PR_INT8, bp_case1 [ _id ] [ bp_rare ]);
		else if ( _case_id == BP_LOTTERY2 ) BS_WriteValue(bitstream, PR_INT8, bp_case2 [ _id ] [ bp_rare ]);
		BS_WriteValue(bitstream, PR_INT8, 0);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock SetCaseStart ( playerid, _case_id, _item, _id )
{
	#if defined debug_packet
		printf ( "[SetCaseStart] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BATTLE_STATS);
	
    BS_WriteValue(bitstream, PR_INT8, 11);
	
	BS_WriteValue(bitstream, PR_UINT8, 1);
	
	/*new _render ;
	if ( _case_id == BP_LOTTERY ) _render = bp_case1 [ _id ] [ bp_render ] ;
	else if ( _case_id == BP_LOTTERY2 ) _render = bp_case2 [ _id ] [ bp_render ] ;*/
	BS_WriteValue(bitstream, PR_INT8, 15 ) ;
	BS_WriteValue(bitstream, PR_INT8, _id ) ;
	BS_WriteValue(bitstream, PR_UINT32, _item ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( "" ) ) ;
	BS_WriteValue(bitstream, PR_STRING, "");
		
	if ( _case_id == BP_LOTTERY ) BS_WriteValue(bitstream, PR_INT8, bp_case1 [ _id ] [ bp_rare ]);
	else if ( _case_id == BP_LOTTERY2 ) BS_WriteValue(bitstream, PR_INT8, bp_case2 [ _id ] [ bp_rare ]);
	BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}