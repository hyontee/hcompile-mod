#define PACKET_CUSTOMRPC    			251
#define RPC_UI_INTERFACE				0x90

stock onServerDestroy ( playerid, uiElementId )
{
	#if defined debug_packet
		printf ( "[onServerDestroy] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_UI_INTERFACE);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 0,
		
		PR_INT32, uiElementId);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock onServerSendData(playerid, uiElementId, actionId, data[])
{
    printf("[DEBUG] Отправка UI: playerid: %d, uiElementId: %d, actionId: %d, data: %s",
        playerid, uiElementId, actionId, data);

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_UI_INTERFACE);
    
    BS_WriteValue(
        bitstream,
        PR_INT8, 1,
        PR_INT32, uiElementId,
        PR_INT32, actionId,
        PR_UINT32, strlen(data),
        PR_STRING, data);

    PR_SendPacket(bitstream, playerid);
    BS_Delete(bitstream);
}


/*stock onServerSendData ( playerid, uiElementId, actionId, data [ ] )
{
	#if defined debug_packet
		printf ( "[onServerSetUIVisible] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_UI_INTERFACE);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 1,
		
		PR_INT32, uiElementId,
		PR_INT32, actionId,
		
		PR_UINT32, strlen ( data ),
		PR_STRING, data);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}*/