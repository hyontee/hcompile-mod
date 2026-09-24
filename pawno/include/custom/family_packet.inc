#define PACKET_CUSTOMRPC    			251
#define RPC_FAMILY						0x120

stock SetFamilyHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetFamilyHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMainMenuPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowMainMenuPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 3,
		PR_INT8, 1,
	
		PR_UINT8, strlen ( family_info [ family_id - 1 ] [ fam_name ] ),
		PR_STRING, family_info [ family_id - 1 ] [ fam_name ],
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowInformationPage ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[familyShowInformationPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 14);
	BS_WriteValue(bitstream, PR_INT8, 2);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_info [ family_id - 1 ] [ fam_name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_info [ family_id - 1 ] [ fam_name ] ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_bank ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;

	// выговоры игрока
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%d / 3", p_info [ playerid ] [ fam_warning ] ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	// сколько игрок закрасил граффити
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%d", p_info [ playerid ] [ fam_graffity ] ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	// сколько игрок учавствовал в семейных войнах
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%d", p_info [ playerid ] [ fam_captured ] ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", family_info [ family_id - 1 ] [ fam_creator ] ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	// сколько территорий у семьи
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%d", family_info [ family_id - 1 ] [ fam_zones ] ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	// сколько граффити у семьи
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%d", family_info [ family_id - 1 ] [ fam_graffity ] ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMembersPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowMembersPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 12,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMembersOnlinePage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowMembersOnlinePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 20,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMembersRanksPage ( playerid, _selectedRank )
{
	#if defined debug_packet
		printf ( "[familyShowMembersRanksPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 16);
	BS_WriteValue(bitstream, PR_INT8, 13);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	BS_WriteValue(bitstream, PR_INT8, _selectedRank);
	BS_WriteValue(bitstream, PR_INT8, family_info [ family_id - 1 ] [ fam_settings ] [ 3 ]);
	
	for ( new i = 0 ; i < 12 ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ i ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ i ] ) ;
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMembersBlackPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowMembersBlackPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 14,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMembersPaydayPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowMembersPaydayPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 15,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowMembersMutedPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowMembersMutedPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 21,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowTopFamsPage ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[familyShowTopFamsPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 3,
		PR_INT8, 4,
	
		PR_UINT32, _type,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowTopPlayersPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowTopPlayersPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 5,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowShopPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowShopPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_INT8, 6);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowUpgradePage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowUpgradePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		PR_INT8, 3,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowQuestsContractsPage ( playerid, _str [ ], _str2 [ ], _q_name [ ], _q_text [ ], _q_progress, _q_max_pgoress, _q_rexp, _q_rmoney, _str3 [ ], _type )
{
	#if defined debug_packet
		printf ( "[familyShowQuestsContractsPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(
		bitstream,
		PR_INT8, 12,
		PR_INT8, 22,
	
		PR_UINT8, strlen ( p_info [ playerid ] [ name ] ),
		PR_STRING, p_info [ playerid ] [ name ],

		PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ),
		PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ],
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _q_name ),
		PR_STRING, _q_name,
	
		PR_UINT8, strlen ( _q_text ),
		PR_STRING, _q_text,

		PR_UINT32, _q_progress,
		PR_UINT32, _q_max_pgoress,
	
		PR_UINT32, _q_rexp,
		PR_UINT32, _q_rmoney,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3,
		PR_UINT8, _type ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyAddQuestsContractsItem ( playerid, _quest_name [ ], _quest_type, _quest_status )
{
	#if defined debug_packet
		printf ( "[familyAddQuestsContractsItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 3,
		PR_INT8, 46,
	
		PR_UINT8, strlen ( _quest_name ),
		PR_STRING, _quest_name,
	
		PR_UINT32, _quest_type,
		PR_UINT32, _quest_status);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowQGInfoPage ( playerid, _str [ ], _str2 [ ], _str3 [ ], _type, _packet, _packet_id )
{
	#if defined debug_packet
		printf ( "[familyShowQGInfoPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, _packet);
	BS_WriteValue(bitstream, PR_INT8, _packet_id);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_bank ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str3 ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, _type ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowSafePage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowSafePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_INT8, 26);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_bank ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowSettingsPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowSettingsPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT8, 16);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowSettingsRanksPage ( playerid, _selectedRank )
{
	#if defined debug_packet
		printf ( "[familyShowSettingsRanksPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 16);
	BS_WriteValue(bitstream, PR_INT8, 17);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	BS_WriteValue(bitstream, PR_INT8, _selectedRank);
	BS_WriteValue(bitstream, PR_INT8, family_info [ family_id - 1 ] [ fam_settings ] [ 3 ]);
	
	for ( new i = 0 ; i < 12 ; i ++ )
	{
		BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ i ] ) ) ;
		BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ i ] ) ;
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowSettingsLogPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowSettingsLogPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT8, 19);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowSettingsCarsPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowSettingsCarsPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT8, 18);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyUpdateSettingsCarsItem ( playerid, _param, _veh_id, _status [ ], _status_id )
{
	#if defined debug_packet
		printf ( "[familyUpdateSettingsCarsItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 5);
	BS_WriteValue(bitstream, PR_INT8, 45);
	
	BS_WriteValue(bitstream, PR_INT8, _param);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, veh_info [ _veh_id - 1 ] [ v_model ] ) ) ) ;
	BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, veh_info [ _veh_id - 1 ] [ v_model ] ) ) ;
	
	new _family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ _family_id - 1 ] [ veh_info [ _veh_id - 1 ] [ v_rank ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ _family_id - 1 ] [ veh_info [ _veh_id - 1 ] [ v_rank ] - 1 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _status ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _status ) ;
	BS_WriteValue(bitstream, PR_INT8, _status_id);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowWarehousePage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowWarehousePage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT8, 9);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowWarehouseLogPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowWarehouseLogPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT8, 10);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowChangeGraffitiPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowChangeGraffitiPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_INT8, 8);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowBuyGraffitiPage ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[familyShowBuyGraffitiPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 16);
	BS_WriteValue(bitstream, PR_INT8, 7);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	BS_WriteValue(bitstream, PR_UINT32, 2934);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	for ( new i = 0 ; i < 11 ; i ++ )
	{
		if ( i < 10 && family_info [ family_id - 1 ] [ fam_graffity_color ] == i )
		{
			BS_WriteValue(bitstream, PR_INT8, 0);
		}
		else
		{
			BS_WriteValue(bitstream, PR_INT8, 1);
		}
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowQuestsWarsPage ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[familyShowQuestsWarsPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 6);
	BS_WriteValue(bitstream, PR_INT8, 25);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_bank ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 32, "%s", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_ticket ] ) ) ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( global_string ) ) ;
	BS_WriteValue(bitstream, PR_STRING, global_string ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyShowDiplomacyPage ( playerid )
{
	#if defined debug_packet
		printf ( "[familyShowDiplomacyPage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 2);
	BS_WriteValue(bitstream, PR_INT8, 11);
	
	new family_id = p_info [ playerid ] [ family ] ;
	BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ playerid ] [ name ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, p_info [ playerid ] [ name ] ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ) ;
	BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ] ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock familyAddDiplomacyItem ( playerid, _str [ ], _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[familyAddDiplomacyItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_INT8, 38);
	
	BS_WriteValue(bitstream, PR_UINT8, 1);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str2 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str2 ) ;

	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str3 ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str3 ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}