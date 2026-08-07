#define RPC_CUSTOM_TOGGLE_GUI_ELEMENT 0x15 //id пакета
 
#define GUI_ELEMENT_BUTTON_PANEL 0 
#define GUI_ELEMENT_CHAT 1 
#define GUI_ELEMENT_SPEEDOMETR 2 
#define GUI_ELEMENT_WIDGETS 3 
#define GUI_ELEMENT_RADAR 4 
#define GUI_ELEMENT_HUD 5 
#define GUI_ELEMENT_VOICE 6 
#define GUI_ELEMENT_COUNT 7

/*stock SetPlayerHudElementVisible(playerid, elementid, bool:isVisible)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_TOGGLE_GUI_ELEMENT);
    BS_WriteValue(bitstream, PR_UINT8, elementid);
    BS_WriteValue(bitstream, PR_BOOL, isVisible);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock all_SetPlayerHudElementVisible(playerid, bool:isVisible)
{
    for(new i; i < GUI_ELEMENT_COUNT; i++)
    {
        SetPlayerHudElementVisible(playerid, i, bool:isVisible);
    }
}*/
