//by vk.com/b.weikton
#define PACKET_CUSTOMRPC    			252
#define RPC_SHOW_NOTIFICATION      0x32

stock ShowNotificationNew(playerid, notify_type, duration, notif_id = 0, subId = 0, caption[] = "", btnCaption[] = "")

{

    if(!IsPlayerConnected(playerid)) return 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", notify_type);
    JSON_SetInt(json, "d", duration);
    JSON_SetInt(json, "s", notif_id);
    JSON_SetInt(json, "b", subId);
    JSON_SetString(json, "i", caption, strlen(caption));
    JSON_SetString(json, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUINew(playerid, BrNotification, json);
    JSON_Cleanup(json);

    // Fallback для текущего byreytiz UI (brnotification.inc).
    ShowNotification(playerid, notify_type, caption, duration, (notif_id == NOTIFY_RENT_MOPED) ? ("/rentbike") : ((notif_id == NOTIFY_ENGINE) ? ("/e") : ("")), btnCaption);
    return 1;
}