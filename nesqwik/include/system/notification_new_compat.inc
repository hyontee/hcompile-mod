// notification_new_compat.inc
// fix: ShowNotificationNew() вызывался в нескольких местах мода (garages.pwn и др.),
// но нигде не была реализована - "undefined symbol" при компиляции.
// ShowPlayerGUI() уже существует и работает (см. gamemodes/sile/ipacket.inc) -
// используем её напрямую, не дублируя.

#if !defined BrNotification
    #define BrNotification (13)
#endif

#if !defined _NOTIFICATION_NEW_COMPAT
#define _NOTIFICATION_NEW_COMPAT

stock ShowNotificationNew(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, BrNotification, JSONObject);
    return 1;
}

#endif
