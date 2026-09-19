#if defined _camera_freeze_fix_included
    #endinput
#endif
#define _camera_freeze_fix_included

#define CFF_AUTO_UNFREEZE_SECONDS (120)

static gCFF_LastAutoFix[MAX_PLAYERS];

stock CFF_CanFixPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerLogged(playerid)) return 0;
    if(GetPVarInt(playerid, "Freeze") == 1) return 0;
    if(GetPlayerData(playerid, P_FREEZE)) return 0;
    if(GetPlayerData(playerid, P_CUFFED)) return 0;
    if(GetPlayerData(playerid, P_JAIL) > 0) return 0;
    if(GetPlayerData(playerid, P_HOSPITAL)) return 0;
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return 0;
    return 1;
}

stock CFF_ApplyFix(playerid, bool:auto_fix = false)
{
    if(!CFF_CanFixPlayer(playerid)) return 0;

    CancelSelectTextDraw(playerid);
    ClearAnimations(playerid);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 1);

    gCFF_LastAutoFix[playerid] = gettime();

    if(auto_fix)
        SendClientMessage(playerid, 0x66CC00FF, "Camera fix: automatic control restore applied.");
    else
        SendClientMessage(playerid, 0x66CC00FF, "Camera fix: camera/control restored.");

    return 1;
}

stock CFF_WatchdogPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(gettime() - gCFF_LastAutoFix[playerid] < 120) return 0;
    return 0;
}

CMD:fixcam(playerid)
{
    if(!CFF_CanFixPlayer(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Camera fix: cannot restore control now."), 1;

    CFF_ApplyFix(playerid, false);
    return 1;
}

CMD:unbug(playerid)
{
    if(!CFF_CanFixPlayer(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Camera fix: cannot restore control now."), 1;

    CFF_ApplyFix(playerid, false);
    return 1;
}
