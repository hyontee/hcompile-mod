#define PACKET_CUSTOMRPC    			251

#define RPC_VALENTINE_SHOW				0x210
#define RPC_VALENTINE_HIDE				0x211
#define RPC_VALENTINE_TASKS				0x212
#define RPC_VALENTINE_SEND				0x213
#define RPC_VALENTINE_SHOP				0x214
#define RPC_VALENTINE_TOP				0x215
#define RPC_VALENTINE_DESC				0x216
#define RPC_VALENTINE_LOBBY_SHOW		0x217
#define RPC_VALENTINE_LOBBY_STATE		0x218
#define RPC_VALENTINE_LOBBY_SETNAME		0x219
#define RPC_VALENTINE_LOBBY_READY		0x220
#define RPC_VALENTINE_LOBBY_HIDE		0x221
#define RPC_VALENTINE_ADD_TOP			0x222

stock ValentineShow ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[ValentineShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_SHOW);
	
	new _count = 0 ;
	for ( new i = 0 ; i < MAX_VALENTINE_BOX ; i ++ )
	{
		_count += player_valentine_box [ playerid ] [ i ] ;
	}
	BS_WriteValue(bitstream, PR_UINT32, _count);
	
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_quest [ playerid ] [ 2 ]);
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_quest [ playerid ] [ 3 ]);
	BS_WriteValue(bitstream, PR_UINT32, valentine_gift);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ));
	BS_WriteValue(bitstream, PR_STRING, _str);
	BS_WriteValue(bitstream, PR_UINT32, player_valentine [ playerid ]);
	
	if ( m_bValentineRPC [ playerid ] == false )
	{
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			if ( i == 3 && valentine_action == 1 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 186, "(%s) %s", _str2, valentine_target [ i ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ));
				BS_WriteValue(bitstream, PR_STRING, global_string);
			}
			else if ( i == 4 && valentine_action == 2 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 186, "(%s) %s", _str2, valentine_target [ i ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ));
				BS_WriteValue(bitstream, PR_STRING, global_string);
			}
			else if ( i == 5 && valentine_action == 3 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 186, "(%s) %s", _str2, valentine_target [ i ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ));
				BS_WriteValue(bitstream, PR_STRING, global_string);
			}
			else
			{
				BS_WriteValue(bitstream, PR_UINT8, strlen ( valentine_target [ i ] ));
				BS_WriteValue(bitstream, PR_STRING, valentine_target [ i ]);
			}
		}
	
		m_bValentineRPC [ playerid ] = true ;
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineHide ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineLobbyHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_HIDE);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineTasksShow ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineTasksShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_TASKS);
	
    BS_WriteValue(bitstream, PR_UINT8, MAX_VALENTINE_QUEST);
	
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_quest [ playerid ] [ 0 ]);
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_status [ playerid ] [ 0 ]);
	
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_quest [ playerid ] [ 1 ]);
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_status [ playerid ] [ 1 ]);
	
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_quest [ playerid ] [ 2 ]);
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_status [ playerid ] [ 2 ]);
	
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_quest [ playerid ] [ 3 ]);
	BS_WriteValue(bitstream, PR_UINT8, player_valentine_status [ playerid ] [ 3 ]);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineSendShow ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineSendShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_SEND);
	
    BS_WriteValue(bitstream, PR_UINT8, MAX_VALENTINE_BOX);
	BS_WriteValue(bitstream, PR_UINT16, player_valentine_box [ playerid ] [ 0 ]);
	BS_WriteValue(bitstream, PR_UINT16, player_valentine_box [ playerid ] [ 1 ]);
	BS_WriteValue(bitstream, PR_UINT16, player_valentine_box [ playerid ] [ 2 ]);
	BS_WriteValue(bitstream, PR_UINT16, player_valentine_box [ playerid ] [ 3 ]);
	BS_WriteValue(bitstream, PR_UINT16, player_valentine_box [ playerid ] [ 4 ]);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineShopShow ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineShopShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_SHOP);
	
    BS_WriteValue(bitstream, PR_UINT8, MAX_VALENTINE_PRICE);
	for ( new i = 0 ; i < MAX_VALENTINE_PRICE ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT32, valentine_price [ i ]);
	}
	
    BS_WriteValue(bitstream, PR_UINT8, sizeof valentine_vehicle_model);
	for ( new i = 0 ; i < sizeof valentine_vehicle_model ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT32, valentine_vehicle_model [ i ]);
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineTopShow ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineTopShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_TOP);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineDescShow ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineDescShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_DESC);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

enum
{
	ALL_VALENTIN_VALENTINS = 0,
	ALL_VALENTIN_GIFTS,
	ALL_VALENTIN_QUEST_2,
	ALL_VALENTIN_QUEST_3
} ;

stock ValentineAddTop ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[ValentineAddTop] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_ADD_TOP);
	
	if ( _type == 0 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_VALENTINE_TOP_PLAYERS);
		for ( new i = 0 ; i < 4 ; i ++ )
		{
			for ( new q = 0 ; q < MAX_VALENTINE_TOP_PLAYERS ; q ++ )
			{
				BS_WriteValue(bitstream, PR_UINT8, i + 1);
				BS_WriteValue(bitstream, PR_UINT8, q + 1);
				BS_WriteValue(bitstream, PR_UINT8, strlen ( valentine_top [ i ] [ q ] [ valentine_name ] ));
				BS_WriteValue(bitstream, PR_STRING, valentine_top [ i ] [ q ] [ valentine_name ]);
				BS_WriteValue(bitstream, PR_UINT32, strlen ( valentine_top [ i ] [ q ] [ valentine_count ] ));
			}
		}
	}
	else
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_VALENTINE_TOP_PLAYERS);
		for ( new i = 4 ; i < 8 ; i ++ )
		{
			for ( new q = 0 ; q < MAX_VALENTINE_TOP_PLAYERS ; q ++ )
			{
				BS_WriteValue(bitstream, PR_UINT8, i - 3);
				BS_WriteValue(bitstream, PR_UINT8, q + 1);
				BS_WriteValue(bitstream, PR_UINT8, strlen ( valentine_top [ i ] [ q ] [ valentine_name ] ));
				BS_WriteValue(bitstream, PR_STRING, valentine_top [ i ] [ q ] [ valentine_name ]);
				BS_WriteValue(bitstream, PR_UINT32, strlen ( valentine_top [ i ] [ q ] [ valentine_count ] ));
			}
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

enum
{
	LOBBY_STATE_START = 0,
	LOBBY_STATE_START_RANDOM = 1,
	LOBBY_STATE_READY = 2,
	LOBBY_STATE_FIND_OPPONENT = 3
} ;

enum
{
	PLAYER_IN_TWO_LOBBY = 2,
	PLAYER_IN_FOUR_LOBBY = 4
} ;

stock ValentineLobbyShow ( playerid, _lobby_id )
{
	#if defined debug_packet
		printf ( "[ValentineLobbyShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_LOBBY_SHOW);

	BS_WriteValue(bitstream, PR_UINT8, _lobby_id);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineLobbyState ( playerid, _state_id )
{
	#if defined debug_packet
		printf ( "[ValentineLobbyShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_LOBBY_STATE);

	BS_WriteValue(bitstream, PR_UINT8, _state_id);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineLobbySetName ( playerid, _position, _str [ ] )
{
	#if defined debug_packet
		printf ( "[ValentineLobbySetName] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_LOBBY_SETNAME);

	BS_WriteValue(bitstream, PR_UINT8, _position);
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ));
	BS_WriteValue(bitstream, PR_STRING, _str);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineLobbyReady ( playerid, _position, _ready )
{
	#if defined debug_packet
		printf ( "[ValentineLobbyReady] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_LOBBY_READY);

	BS_WriteValue(bitstream, PR_UINT8, _position);
	BS_WriteValue(bitstream, PR_UINT8, _ready);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ValentineLobbyHide ( playerid )
{
	#if defined debug_packet
		printf ( "[ValentineLobbyHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_VALENTINE_LOBBY_HIDE);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}