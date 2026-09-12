stock SetVehicleLightProperties(vehicleid, lights = -1, strob = -1, high = -1)
{

	SetVehicleParam(vehicleid, V_LIGHTS, lights);  
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

//stock RGBA_to_ARGB(rgba) return ((rgba & 0xFFFFFF00) >> 8) | ((rgba & 0xFF) << 24);