#define WOUNDGID (40)

new bool:g_wound_active[MAX_PLAYERS];
new bool:g_wound_respawn[MAX_PLAYERS];
new g_wound_timer[MAX_PLAYERS];
new Float:g_wound_x[MAX_PLAYERS];
new Float:g_wound_y[MAX_PLAYERS];
new Float:g_wound_z[MAX_PLAYERS];
new Float:g_wound_a[MAX_PLAYERS];
new g_wound_int[MAX_PLAYERS];
new g_wound_vw[MAX_PLAYERS];
new g_wound_killer[MAX_PLAYERS];
new bool:g_wound_gui_opened[MAX_PLAYERS];

forward WoundRespawn(playerid);

stock WoundReset(playerid)
{
    g_wound_active[playerid] = false;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;

    if (g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    return 1;
}

stock WoundClose(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 2);
    OnPacketIncoming(playerid, WOUNDGID, json);
    JSON_Cleanup(json);
    return 1;
}

stock WoundOpen(playerid)
{
    if (g_wound_gui_opened[playerid])
    {
        return 1;
    }

    new Node:json = JSON_Object();
    new killerid = g_wound_killer[playerid];
    new nick[MAX_PLAYER_NAME + 1];

    if (killerid != INVALID_PLAYER_ID && IsPlayerConnected(killerid))
    {
        format(nick, sizeof nick, "%s", GetPlayerNameEx(killerid));
        JSON_SetInt(json, "id", killerid);
    }
    else
    {
        format(nick, sizeof nick, "");
        JSON_SetInt(json, "id", 0);
    }

    JSON_SetString(json, "p", nick);
    JSON_SetInt(json, "h", 1);
    ShowPlayerGUI(playerid, WOUNDGID, json);
    JSON_Cleanup(json);
    g_wound_gui_opened[playerid] = true;
    return 1;
}

stock WoundAnim(playerid)
{
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, false);
    ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.1, 1, 0, 0, 1, 0, 1);
    return 1;
}

public WoundRespawn(playerid)
{
    if (!IsPlayerConnected(playerid) || !g_wound_active[playerid])
    {
        return 0;
    }

    g_wound_timer[playerid] = 0;
    g_wound_respawn[playerid] = true;

    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerData(playerid, P_SKIN),
        g_wound_x[playerid],
        g_wound_y[playerid],
        g_wound_z[playerid],
        g_wound_a[playerid],
        0, 0, 0, 0, 0, 0
    );

    SpawnPlayer(playerid);
    return 1;
}

stock WoundStart(playerid, killerid)
{
    if (!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
    {
        return 0;
    }

    GetPlayerPos(playerid, g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid]);
    GetPlayerFacingAngle(playerid, g_wound_a[playerid]);

    g_wound_int[playerid] = GetPlayerInterior(playerid);
    g_wound_vw[playerid] = GetPlayerVirtualWorld(playerid);
    g_wound_killer[playerid] = killerid;
    g_wound_active[playerid] = true;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;

    SetPlayerData(playerid, P_HOSPITAL, true);
    UpdatePlayerDatabaseInt(playerid, "hospital", 1);

    if (g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
    }

    g_wound_timer[playerid] = SetTimerEx("WoundRespawn", 1200, false, "i", playerid);
    return 1;
}

stock WoundOnSpawn(playerid)
{
    if (!g_wound_active[playerid])
    {
        return 0;
    }

    g_wound_respawn[playerid] = false;

    SetPlayerInterior(playerid, g_wound_int[playerid]);
    SetPlayerVirtualWorld(playerid, g_wound_vw[playerid]);
    SetPlayerPos(playerid, g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid]);
    SetPlayerFacingAngle(playerid, g_wound_a[playerid]);
    SetCameraBehindPlayer(playerid);
    SetPlayerHealthEx(playerid, 15.0, true);
    ResetPlayerWeapons(playerid);
    WoundAnim(playerid);
    WoundOpen(playerid);
    return 1;
}

stock WoundHospital(playerid)
{
    if (!g_wound_active[playerid])
    {
        return 1;
    }

    g_wound_active[playerid] = false;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;

    if (g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    WoundClose(playerid);
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, true);
    SetPlayerData(playerid, P_HOSPITAL, true);
    UpdatePlayerDatabaseInt(playerid, "hospital", 1);
    SpawnPlayerHospital(playerid);
    SpawnPlayer(playerid);
    return 1;
}

stock WoundHandle(playerid, const data[])
{
    new action;
    
    switch (action)
    {
        case 1:
        {
            JSON_SetInt(JSON_Object(), "t", 1);
            OnPacketIncoming(playerid, WOUNDGID, JSON_Object());
            JSON_Cleanup(JSON_Object());
            return 1;
        }
        case 2:
        {
            return WoundHospital(playerid);
        }
        case 4:
        {
            return 1;
        }
    }

    return 1;
}

CMD:wound(playerid)
{
    JSON_SetInt(JSON_Object(), "id", 1);
    JSON_SetString(JSON_Object(), "p", "Test_Memory");
    JSON_SetInt(JSON_Object(), "h", 1);
    ShowPlayerGUI(playerid, WOUNDGID, JSON_Object());
    JSON_Cleanup(JSON_Object());
    g_wound_gui_opened[playerid] = true;
    
    return 1;
}