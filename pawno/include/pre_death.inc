#define PACKET_CUSTOMRPC 251
#define RPC_SHOW_PRE_DEATH 0x271

stock ShowPreDeath(playerid)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_PRE_DEATH);

    BS_Send(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}


