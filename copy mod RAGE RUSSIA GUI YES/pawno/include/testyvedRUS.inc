#define PACKET_BLACKRRPC     252

CMD:notifytest(playerid, params[])
{
    ShowNotificationNew(playerid, 5, 6, 0, 0, "Нажмите для взаимодействия!", "»", "/gps");
    return 1;
}

CMD:testnotify2(playerid)
{
 ShowNotificationNew(playerid, 2, 5, 1, 10, "Привет от vit4lka!", "");
 return 1;
}

stock ShowNotificationNew(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, 13, JSONObject);
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);

	BS_WriteValue(bitstream, PR_UINT16, guiid);

	new data[1024]; //4294967295
    JSON_Stringify(json, data);

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}

stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
}
stock HidePlayerGUI(playerid, guiid) //, Node:json)
{
	new Node:json = JSON_Object();
	JSON_SetInt(json, "c", 1);
	OnPacketIncoming(playerid, guiid, json);
}