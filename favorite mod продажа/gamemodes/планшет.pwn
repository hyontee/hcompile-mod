#if defined _tablet_gui_included
    #endinput
#endif
#define _tablet_gui_included

#define APPLET_INFO                        (5)
#define APPLET_GPS                         (7)
#define APPLET_MENU                        (9)
#define APPLET_INVENTORY                   (11)
#define APPLET_DONATE                      (13)
#define APPLET_REWARD                      (22)
#define PACKET_BLACKRRPC                   252

stock SendPlayerTabletOpen113(playerid)
{
    new Node:json = JSON_Object(
        "a", JSON_Int(1),
        "ac", JSON_Array(
            JSON_Object("id", JSON_Int(17)),
            JSON_Object("id", JSON_Int(24))
        ),
        "d", JSON_Object(
            "ar",  JSON_Int(1),
            "av",  JSON_Int(2),
            "bg",  JSON_Int(2),
            "exm", JSON_Int(8),
            "exp", JSON_Int(0),
            "fn",  JSON_String("HARLEY"),
            "lv",  JSON_Int(1),
            "v",   JSON_Int(0)
        ),
        "n", JSON_Array(
            JSON_Object("id", JSON_Int(22))
        ),
        "o", JSON_Int(1)
    );

    OnPacketIncoming(playerid, 113, json);
    JSON_Cleanup(json);
    return 1;
}

stock SendTabletInfoList113(playerid)
{
    new Node:list = JSON_Array(
        JSON_Object(
            "id",  JSON_Int(1),
            "nm",  JSON_String("HARLEY"),
            "nn",  JSON_String("HARLEY"),
            "dsc", JSON_String("HARLEY"),
            "tm",  JSON_Object(
                "dt", JSON_String("2026-03-17"),
                "h",  JSON_Int(14),
                "m",  JSON_Int(40)
            )
        ),
        JSON_Object(
            "id",  JSON_Int(2),
            "nm",  JSON_String("HARLEY"),
            "nn",  JSON_String("HARLEY"),
            "dsc", JSON_String("HARLEY"),
            "tm",  JSON_Object(
                "dt", JSON_String("2026-03-17"),
                "h",  JSON_Int(14),
                "m",  JSON_Int(25)
            )
        )
    );

    new Node:json = JSON_Object(
        "a", JSON_Int(APPLET_INFO),
        "o", JSON_Int(1),
        "d", list
    );

    OnPacketIncoming(playerid, 113, json);
    JSON_Cleanup(json);
    JSON_Cleanup(list);
    return 1;
}

stock OpenTabletInfo(playerid)
{
    new Node:json = JSON_Object("a", JSON_Int(APPLET_INFO));
    ShowPlayerGUI(playerid, 113, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:tablet(playerid, params[])
{
    #pragma unused params
    return SendPlayerTabletOpen113(playerid);
}
