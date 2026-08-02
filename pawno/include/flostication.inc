#define RPC_STREAM_TEXTURE	0x187
#define PACKET_CUSTOMRPC    			251

stock SetVehTexture(playerid, veh, tex[], tex2[])
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_TEXTURE);

	BS_WriteValue(bitstream, PR_UINT16, veh);	

	BS_WriteValue(bitstream, PR_UINT8, strlen(tex));
	BS_WriteValue(bitstream, PR_STRING, tex);

	BS_WriteValue(bitstream, PR_UINT8, strlen(tex2));
	BS_WriteValue(bitstream, PR_STRING, tex2);

	PR_SendPacket(bitstream, playerid);
	BS_Send(bitstream, playerid);

	BS_Delete(bitstream);
}

