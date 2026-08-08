#define PACKET_CUSTOMRPC 251

#define RPC_AKS 0x377
#define RPC_AKS_UPD 0x388

stock ShowAks(playerid, money)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x377);

    BS_WriteValue(bitstream, PR_INT32, money);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);

    return true;
}
stock UpdateAks(playerid, money)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x388);

    BS_WriteValue(bitstream, PR_INT32, money);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);
    return true;
}


