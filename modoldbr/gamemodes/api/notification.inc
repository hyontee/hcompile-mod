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