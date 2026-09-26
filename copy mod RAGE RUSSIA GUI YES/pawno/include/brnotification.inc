//by vk.com/b.weikton


stock ShowNewNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_UINT32, 102);
    
    BS_WriteValue(bitstream, PR_INT16, type);
	BS_WriteValue(bitstream, PR_INT16, duration);
	BS_WriteValue(bitstream, PR_INT16, id);
	BS_WriteValue(bitstream, PR_INT16, subId);

	BS_WriteValue(bitstream, PR_INT16, strlen(btnCaption));
	BS_WriteValue(bitstream, PR_STRING, btnCaption);
	
	BS_WriteValue(bitstream, PR_INT16, strlen(caption));
	BS_WriteValue(bitstream, PR_STRING, caption);
    
    BS_Send(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);

	return true;
}


stock ShowNotification(playerid, type, const text[], duration, const actionforBtn[], const textBtn[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_UINT32, 0x32);
    
    BS_WriteValue(bitstream, PR_INT32, type);
    
    BS_WriteValue(bitstream, PR_UINT16, strlen(text));
    BS_WriteValue(bitstream, PR_STRING, text);
    
    BS_WriteValue(bitstream, PR_INT32, duration);
    
    BS_WriteValue(bitstream, PR_UINT16, strlen(actionforBtn));
    BS_WriteValue(bitstream, PR_STRING, actionforBtn);
    
    BS_WriteValue(bitstream, PR_UINT16, strlen(textBtn));
    BS_WriteValue(bitstream, PR_STRING, textBtn);
    
    BS_Send(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

	return true;
} 
