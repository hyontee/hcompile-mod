//
//

#if !defined PACKET_CUSTOMRPC
	#define PACKET_CUSTOMRPC			251
#endif

#define RPC_MAP_ICONS					0x1B0

#define MAX_MAP_ICON_LIST				1024
#define MAP_ICONS_PER_PACKET			40

new Float: map_icon_list_x [ MAX_MAP_ICON_LIST ] ;
new Float: map_icon_list_y [ MAX_MAP_ICON_LIST ] ;
new map_icon_list_type [ MAX_MAP_ICON_LIST ] ;
new map_icon_list_color [ MAX_MAP_ICON_LIST ] ;
new map_icon_list_count = 0 ;

new bool: map_icons_sent [ MAX_PLAYERS ] ;

//
stock map_icon_remember ( Float:x, Float:y, type, color, playerid )
{
	if ( playerid != -1 ) return 0 ;
	if ( type == 31 || type == 32 ) return 0 ;
	if ( map_icon_list_count >= MAX_MAP_ICON_LIST ) return 0 ;

	map_icon_list_x [ map_icon_list_count ] = x ;
	map_icon_list_y [ map_icon_list_count ] = y ;
	map_icon_list_type [ map_icon_list_count ] = type ;
	map_icon_list_color [ map_icon_list_count ] = color ;

	map_icon_list_count ++ ;
	return 1 ;
}

stock mapIconsClear ( playerid )
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MAP_ICONS);

	BS_WriteValue(bitstream, PR_INT8, 0);

	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
}

stock mapIconsSend ( playerid )
{
	mapIconsClear ( playerid ) ;

	new sent = 0 ;
	while ( sent < map_icon_list_count )
	{
		new count = map_icon_list_count - sent ;
		if ( count > MAP_ICONS_PER_PACKET ) count = MAP_ICONS_PER_PACKET ;

		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_MAP_ICONS);

		BS_WriteValue(bitstream, PR_INT8, 1);
		BS_WriteValue(bitstream, PR_UINT8, count);

		for ( new i = 0 ; i < count ; i ++ )
		{
			BS_WriteValue(bitstream,
				PR_FLOAT,  map_icon_list_x [ sent + i ],
				PR_FLOAT,  map_icon_list_y [ sent + i ],
				PR_UINT8,  map_icon_list_type [ sent + i ],
				PR_UINT32, map_icon_list_color [ sent + i ]);
		}

		PR_SendPacket(bitstream, playerid);
		BS_Delete(bitstream);

		sent += count ;
	}

	#if defined debug_packet
		printf ( "[mapIconsSend] playerid: %d, иконок: %d", playerid, map_icon_list_count ) ;
	#endif
	return map_icon_list_count ;
}
