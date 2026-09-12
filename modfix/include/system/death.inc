#if defined _death_gui_included
    #endinput
#endif
#define _death_gui_included

#define WOUND_SYSTEM_KMONARCH_LOADED (1)
#define WOUNDGID (40)

#define WOUND_HOSPITAL_X (1471.672729)
#define WOUND_HOSPITAL_Y (2506.028076)
#define WOUND_HOSPITAL_Z (2501.040283)
#define WOUND_HOSPITAL_A (181.954757)
#define WOUND_HOSPITAL_INT (1)
#define WOUND_HOSPITAL_WORLD (1)

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
new Text3D:g_wound_label[MAX_PLAYERS];
new g_wound_last_attacker[MAX_PLAYERS];

forward WoundRespawn(playerid);
forward WoundPostGuiApply(playerid);

stock bool:WoundIsActive(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return false;
    return g_wound_active[playerid];
}

stock WoundReset(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 1;

    g_wound_active[playerid] = false;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;
    g_wound_last_attacker[playerid] = INVALID_PLAYER_ID;

    if(g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    WoundHideLabel(playerid);
    return 1;
}

stock WoundShowLabel(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    WoundHideLabel(playerid);

    g_wound_label[playerid] = CreateDynamic3DTextLabel("{FF3333}Стадия ранения\n{FFFFFF}Подойдите для взаимодействия", 0xFF3333FF, 0.0, 0.0, 0.7, 15.0, playerid);
    Attach3DTextLabelToPlayer(g_wound_label[playerid], playerid, 0.0, 0.0, 0.7);
    return 1;
}

stock WoundHideLabel(playerid)
{
    if(IsValidDynamic3DTextLabel(g_wound_label[playerid]))
    {
        DestroyDynamic3DTextLabel(g_wound_label[playerid]);
    }
    g_wound_label[playerid] = Text3D: -1;
    return 1;
}

stock WoundSetLastAttacker(playerid, issuerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    g_wound_last_attacker[playerid] = issuerid;
    return 1;
}

stock WoundClose(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 2);
    JSON_SetInt(json, "c", 1);
    SendPacketToClient(playerid, WOUNDGID, json);
    JSON_Cleanup(json);

    g_wound_gui_opened[playerid] = false;
    return 1;
}

stock WoundOpen(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(g_wound_gui_opened[playerid]) return 1;

    new Node:json = JSON_Object();
    new killerid = g_wound_killer[playerid];
    new nick[MAX_PLAYER_NAME + 1];

    if(killerid != INVALID_PLAYER_ID && killerid >= 0 && killerid < MAX_PLAYERS && IsPlayerConnected(killerid))
    {
        format(nick, sizeof nick, "%s", GetPlayerNameEx(killerid));
        JSON_SetInt(json, "id", killerid);
    }
    else
    {
        nick[0] = EOS;
        JSON_SetInt(json, "id", 0);
    }

    JSON_SetString(json, "p", nick, strlen(nick));
    JSON_SetInt(json, "h", 1);


    g_wound_gui_opened[playerid] = true;


    WoundPostGuiApply(playerid);
    ShowPlayerGUI(playerid, WOUNDGID, json);
    SetTimerEx("WoundPostGuiApply", 250, false, "i", playerid);

    JSON_Cleanup(json);
    return 1;
}

stock WoundAnim(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, false);

    // "Плохое самочувствие" / injured loop animation while a player is in the wound stage
    ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, true, 0, 0, 0, 0, 0);

    return 1;
}

public WoundPostGuiApply(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;


    SetPlayerData(playerid, P_HEALTH, 65.0);
    SetPlayerHealth(playerid, 65.0);

    WoundAnim(playerid);
    return 1;
}

stock WoundSetSpawn(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerSkinEx(playerid),
        g_wound_x[playerid],
        g_wound_y[playerid],
        g_wound_z[playerid] + 0.20,
        g_wound_a[playerid],
        0, 0, 0, 0, 0, 0
    );
    return 1;
}

stock WoundApply(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;

    g_wound_respawn[playerid] = false;
    SetPlayerData(playerid, P_HOSPITAL, false);

    SetPlayerInterior(playerid, g_wound_int[playerid]);
    SetPlayerVirtualWorld(playerid, g_wound_vw[playerid]);
    SetPlayerPos(playerid, g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid] + 0.20);
    SetPlayerFacingAngle(playerid, g_wound_a[playerid]);
    SetCameraBehindPlayer(playerid);
    SetPlayerHealthEx(playerid, 65.0, false);
    ResetPlayerWeapons(playerid);
    WoundOpen(playerid);

    printf("[WOUND_SYSTEM] applied player=%d gui=40", playerid);
    return 1;
}

public WoundRespawn(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;

    g_wound_timer[playerid] = 0;

    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;



    g_wound_respawn[playerid] = true;
    WoundSetSpawn(playerid);
    return 1;
}

stock WoundStart(playerid, killerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    if(g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    GetPlayerPos(playerid, g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid]);
    GetPlayerFacingAngle(playerid, g_wound_a[playerid]);

    g_wound_int[playerid] = GetPlayerInterior(playerid);
    g_wound_vw[playerid] = GetPlayerVirtualWorld(playerid);

    if(killerid != INVALID_PLAYER_ID && killerid >= 0 && killerid < MAX_PLAYERS && IsPlayerConnected(killerid))
    {
        g_wound_killer[playerid] = killerid;
    }
    else
    {
        g_wound_killer[playerid] = INVALID_PLAYER_ID;
    }

    g_wound_active[playerid] = true;
    g_wound_respawn[playerid] = true;
    g_wound_gui_opened[playerid] = false;


    SetPlayerData(playerid, P_HOSPITAL, false);
    UpdatePlayerDatabaseInt(playerid, "hospital", 0);

    SetPlayerData(playerid, P_WOUND_PENDING, true);
    UpdatePlayerDatabaseInt(playerid, "wound_pending", 1);

    WoundSetSpawn(playerid);
    WoundShowLabel(playerid);

    printf("[WOUND_SYSTEM] start player=%d killer=%d pos=%.2f %.2f %.2f", playerid, g_wound_killer[playerid], g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid]);
    return 1;
}

stock WoundOnSpawn(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;
    if(!g_wound_respawn[playerid]) return 0;

    return WoundApply(playerid);
}

stock WoundHospital(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    if(g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    g_wound_active[playerid] = false;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;
    g_wound_last_attacker[playerid] = INVALID_PLAYER_ID;

    WoundClose(playerid);
    WoundHideLabel(playerid);
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, true);

    SetPlayerData(playerid, P_HOSPITAL, true);
    UpdatePlayerDatabaseInt(playerid, "hospital", 1);

    SetPlayerData(playerid, P_WOUND_PENDING, false);
    UpdatePlayerDatabaseInt(playerid, "wound_pending", 0);

    SetPlayerHealthEx(playerid, 15.0, false);

    SendClientMessage(playerid, 0x3399FFFF, "Вы доставлены в больницу. Подойдите к свободной койке и введите {ffff00}/lekmed{3399ff}, чтобы начать лечение.");

    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerSkinEx(playerid),
        WOUND_HOSPITAL_X,
        WOUND_HOSPITAL_Y,
        WOUND_HOSPITAL_Z,
        WOUND_HOSPITAL_A,
        0, 0, 0, 0, 0, 0
    );

    SetPlayerPosEx(playerid, WOUND_HOSPITAL_X, WOUND_HOSPITAL_Y, WOUND_HOSPITAL_Z, WOUND_HOSPITAL_A, WOUND_HOSPITAL_INT, WOUND_HOSPITAL_WORLD, false);
    return 1;
}

stock WoundHandle(playerid, Node:json)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new action;
    JSON_GetInt(json, "t", action);

    printf("[WOUND_SYSTEM] handle player=%d action=%d gui_opened=%d active=%d respawn=%d",
        playerid, action, g_wound_gui_opened[playerid], g_wound_active[playerid], g_wound_respawn[playerid]);

    switch(action)
    {
        case 1:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 1);
            SendPacketToClient(playerid, WOUNDGID, response);
            JSON_Cleanup(response);
            return 1;
        }
        case 2:
        {
            printf("[WOUND_SYSTEM] hospital button pressed by player=%d", playerid);
            return WoundHospital(playerid);
        }
        case 4:
        {


            return 1;
        }
        default:
        {
            printf("[WOUND_SYSTEM] unhandled action=%d from player=%d", action, playerid);
        }
    }

    return 1;
}

CMD:deathkoch(playerid)
{
    WoundStart(playerid, INVALID_PLAYER_ID);
    return 1;
}
// Called at login when a player disconnected while wounded (never reached the hospital)
// or while still mid-treatment in the hospital (health < 100). In both cases they are
// placed directly into the hospital and the normal spawn-selection GUI is skipped
// entirely, since there is nowhere else for them to legitimately appear.
stock WoundForceHospitalLogin(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    WoundReset(playerid);

    if(GetPlayerData(playerid, P_WOUND_PENDING))
    {
        // died and never made it to the hospital before disconnecting - start fresh
        SetPlayerData(playerid, P_WOUND_PENDING, false);
        UpdatePlayerDatabaseInt(playerid, "wound_pending", 0);

        SetPlayerData(playerid, P_HOSPITAL, true);
        UpdatePlayerDatabaseInt(playerid, "hospital", 1);

        SetPlayerHealthEx(playerid, 15.0, false);
    }
    else
    {
        // already mid-treatment - keep whatever health was saved, just place them back
        SetPlayerHealth(playerid, GetPlayerData(playerid, P_HEALTH));
    }

    SetPlayerVirtualWorld(playerid, WOUND_HOSPITAL_WORLD);
    SetPlayerInterior(playerid, WOUND_HOSPITAL_INT);
    SetPlayerPosEx(playerid, WOUND_HOSPITAL_X, WOUND_HOSPITAL_Y, WOUND_HOSPITAL_Z, WOUND_HOSPITAL_A, WOUND_HOSPITAL_INT, WOUND_HOSPITAL_WORLD, false);

    TogglePlayerControllable(playerid, true);
    ResetPlayerWeapons(playerid);

    SendClientMessage(playerid, 0x3399FFFF, "Вы всё ещё находитесь на лечении в больнице. Подойдите к свободной койке и введите {ffff00}/lekmed{3399ff}, чтобы продолжить лечение.");

    return 1;
}
