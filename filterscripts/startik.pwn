#include <a_samp>
#include <Pawn.RakNet>

#define FILTERSCRIPT

stock SendEventButton(playerid, bool:enable)
{
    new BitStream:bs = BS_New();

    BS_WriteValue(
        bs,
        PR_UINT8, 60,
        PR_UINT8, enable ? 1 : 0
    );

    PR_SendRPC(bs, playerid, 168, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

forward EventButtonDelay(playerid);
public EventButtonDelay(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    SendEventButton(playerid, true);
    return 1;
}

public OnFilterScriptInit()
{
    print("[EventButtonFS] Загружен.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    SetTimerEx("EventButtonDelay", 2000, false, "d", playerid);
    return 1;
}