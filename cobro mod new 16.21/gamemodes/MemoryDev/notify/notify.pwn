#define GUINotificationNewStyle             13

stock ShowNotificationNew(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, GUINotificationNewStyle, JSONObject);
}

CMD:notify(playerid)
{
    ShowNotificationNew(playerid,  2, 6, 0, 0, "TEST NOTIF", "qq"); 
    return 1;
}

stock ShowNotificationMemory(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, 13, JSONObject);
}


CMD:m3mory(playerid)
{
    ShowNotificationNew(playerid,  2, 6, 0, 0, "TEST M3MORY", "qq");
    return 1;
}