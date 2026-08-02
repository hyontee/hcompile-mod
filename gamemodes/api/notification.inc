
stock ShowNewNotificatin(playerid, type, duration, id, subId, caption[], btnCaption[])
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