#include <a_samp>
#include <Pawn.RakNet>

#define COLOR_GREEN 0x33CC33FF
#define COLOR_RED   0xE74C3CFF

forward ApplyStartRPC(playerid);

stock SetGreenZone(playerid, bool:toggle)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT8, 6,
        PR_UINT8, toggle
    );
    BS_RPC(bs, playerid, 168);
    BS_Delete(bs);
    return 1;
}

stock SetCinemaCamera(playerid, bool:toggle)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT8, 16,
        PR_UINT8, toggle
    );
    BS_RPC(bs, playerid, 168);
    BS_Delete(bs);
    return 1;
}

stock SetX2(playerid, bool:toggle, time_seconds)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT8, 24,
        PR_UINT8, toggle,
        PR_UINT32, time_seconds
    );
    BS_RPC(bs, playerid, 168);
    BS_Delete(bs);
    return 1;
}

stock ShowGiftHud(playerid, bool:toggle)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT8, 9,
        PR_UINT8, toggle
    );
    BS_RPC(bs, playerid, 168);
    BS_Delete(bs);
    return 1;
}

public OnFilterScriptInit()
{
    print("[rpc_start] loaded.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    SetTimerEx("ApplyStartRPC", 2500, false, "i", playerid);
    return 1;
}

public ApplyStartRPC(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    SetGreenZone(playerid, true);
    SetX2(playerid, true, 3600);
    ShowGiftHud(playerid, true);

    SendClientMessage(playerid, COLOR_GREEN, "[RPC] При входе активированы: X2, зеленая зона и подарки.");
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/camera", true))
    {
        SetCinemaCamera(playerid, true);
        SendClientMessage(playerid, COLOR_GREEN, "[RPC] Кинематографическая камера включена.");
        return 1;
    }

    if(!strcmp(cmdtext, "/cameraoff", true))
    {
        SetCinemaCamera(playerid, false);
        SendClientMessage(playerid, COLOR_RED, "[RPC] Кинематографическая камера выключена.");
        return 1;
    }

    return 0;
}
