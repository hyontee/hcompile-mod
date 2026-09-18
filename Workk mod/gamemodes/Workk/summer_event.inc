#if defined _summer_event_included
    #endinput
#endif
#define _summer_event_included

// Summer event source is not present in the supplied archive.
// These compatibility handlers keep the existing gamemode callbacks valid.
// Replace this file with the original summer event implementation if you have it.

stock SummerEvent_Init()
{
    return 1;
}

stock SummerEvent_OnPlayerConnect(playerid)
{
    #pragma unused playerid
    return 1;
}

stock SummerEvent_OnPlayerDisconnect(playerid, reason)
{
    #pragma unused playerid
    #pragma unused reason
    return 1;
}

stock SummerEvent_OnPlayerDeath(playerid, killerid, reason)
{
    #pragma unused playerid
    #pragma unused killerid
    #pragma unused reason
    return 1;
}

stock SummerEvent_OnPlayerUpdate(playerid)
{
    #pragma unused playerid
    return 1;
}

stock SummerEvent_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid
    #pragma unused dialogid
    #pragma unused response
    #pragma unused listitem
    #pragma unused inputtext
    return 0;
}
