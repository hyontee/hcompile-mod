#define CUSTOM_SPAWN_PACKET_INC

#if !defined PACKET_CUSTOMRPC
	#define PACKET_CUSTOMRPC 251
#endif
#define RPC_SPAWN_PACKET 0x170

stock spawnShow(playerid)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SPAWN_PACKET);

	BS_WriteValue(bitstream, PR_INT8, 0);

	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	return 1;
}

stock spawnHide(playerid)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SPAWN_PACKET);

	BS_WriteValue(bitstream, PR_INT8, 1);

	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	return 1;
}

stock spawnAddItem(playerid, spawnType, houseID, const spawnText[])
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SPAWN_PACKET);

	BS_WriteValue(
		bitstream,
		PR_INT8, 2,

		PR_INT32, spawnType,
		PR_INT32, houseID,

		PR_UINT8, strlen(spawnText),
		PR_STRING, spawnText);

	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	return 1;
}
