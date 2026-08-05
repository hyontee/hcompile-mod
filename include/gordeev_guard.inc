#if defined _GORDEEV_GUARD_API_INCLUDED
    #endinput
#endif
#define _GORDEEV_GUARD_API_INCLUDED

native GordeevGuardLoaded();
native GordeevGuardProof(challenge);

native Gordeev_ShowPlayerGUI(playerid, guiid, Node:json);
native Gordeev_HidePlayerGUI(playerid, guiid);
native Gordeev_OnPacketIncoming(playerid, guiid, Node:json);

native Gordeev_SendGuiPacket(playerid, guiid, const payload[]);

native Gordeev_SendTurnLight(playerid, vehicleid, turnStatus);
