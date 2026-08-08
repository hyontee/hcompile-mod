#define PACKET_CUSTOMRPC          251
#define RPC_SHOW_INVENTORY 0x266

stock ShowInventory(playerid, hp, hunger, skin_id, key, sumka)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_INVENTORY);

    BS_WriteValue(bitstream, PR_INT32, hp);
    BS_WriteValue(bitstream, PR_INT32, hunger);
    BS_WriteValue(bitstream, PR_INT32, skin_id);
	BS_WriteValue(bitstream, PR_INT32, key);
	BS_WriteValue(bitstream, PR_INT32, sumka);

    BS_Send(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}
