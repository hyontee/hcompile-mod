

stock OnPacketIncoming(playerid, gui_id, const data[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_INT16, gui_id);
    BS_WriteValue(bitstream, PR_INT16, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

    PR_SendPacket(bitstream, playerid);
    BS_Delete(bitstream);

    return true;
}