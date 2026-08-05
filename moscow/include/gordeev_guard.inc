#if defined _GORDEEV_GUARD_API_INCLUDED
    #endinput
#endif
#define _GORDEEV_GUARD_API_INCLUDED

native GordeevGuardLoaded();
native GordeevGuardProof(challenge);

// Safe prefixed API for usage without conflicts with existing stock functions.
native Gordeev_ShowPlayerGUI(playerid, guiid, Node:json);
native Gordeev_HidePlayerGUI(playerid, guiid);
native Gordeev_OnPacketIncoming(playerid, guiid, Node:json);

// String bridge for gradual migration from stock logic to plugin logic.
// Return 1 if packet is fully handled by plugin, 0 to use Pawn fallback.
native Gordeev_SendGuiPacket(playerid, guiid, const payload[]);

// Turn light bridge:
// turnStatus: 0=off, 1=left, 2=right, 3=hazard
// Return 1 if handled by plugin transport, 0 to use Pawn fallback.
native Gordeev_SendTurnLight(playerid, vehicleid, turnStatus);
