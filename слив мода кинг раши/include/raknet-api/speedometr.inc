#define RPC_CUSTOM_UPDATE_SPEEDOMETR 0x16

stock SpeedometrSetVehName(playerid, name[])
{
    new BitStream:bitstream = BS_New();

    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC); // кастомный пакет
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_UPDATE_SPEEDOMETR); //для спидометра
    BS_WriteValue(bitstream, PR_UINT8, 0); // 0 - имя машины, 1 - топливо, макс. топливо, пробег
    BS_WriteValue(bitstream, PR_UINT8, strlen(name)); // длина имени машины
    BS_WriteValue(bitstream, PR_STRING, name); // имя машины

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock SpeedometrSetVehData(playerid, fuel, maxFuel, probeg)
{
    new BitStream:bitstream = BS_New();

    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC); // кастомный пакет
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_UPDATE_SPEEDOMETR); //для спидометра
    BS_WriteValue(bitstream, PR_UINT8, 1); // 0 - имя машины, 1 - топливо, макс. топливо, пробег
    BS_WriteValue(bitstream, PR_UINT32, fuel); // топливо
    BS_WriteValue(bitstream, PR_UINT32, maxFuel); // макс. топливо
    BS_WriteValue(bitstream, PR_UINT32, probeg); // пробег

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}
