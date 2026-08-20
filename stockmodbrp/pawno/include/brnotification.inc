//by vk.com/b.weikton


stock ShowNewNotification(playerid, type, duration, id, sub_id, message[], btnText[])
{
    new Node:json_notification_data = Node:JSON_Object(), outcoming_data[512];

    JSON_SetInt(json_notification_data, "o", 1);
    JSON_SetInt(json_notification_data, "t", type);
    JSON_SetInt(json_notification_data, "d", duration);
    JSON_SetInt(json_notification_data, "s", id);
    JSON_SetInt(json_notification_data, "b", sub_id);

    JSON_SetString(json_notification_data, "i", message, strlen(message));
    JSON_SetString(json_notification_data, "k", btnText, strlen(btnText));
    
    JSON_Stringify(json_notification_data, outcoming_data);
    OnPacketIncoming(playerid, 13, outcoming_data);
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
