#if defined _death_gui_included
    #endinput
#endif
#define _death_gui_included

#define WOUND_SYSTEM_KMONARCH_LOADED (1)
#define WOUNDGID (40)

// Центральная больница (ЦБ).
#define WOUND_HOSPITAL_X (1482.540039)
#define WOUND_HOSPITAL_Y (2504.260009)
#define WOUND_HOSPITAL_Z (2501.040283)
#define WOUND_HOSPITAL_A (182.710006)
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
new Float:g_wound_last_health[MAX_PLAYERS];
new Float:g_wound_last_armour[MAX_PLAYERS];

forward WoundRespawn(playerid);
forward WoundPostGuiApply(playerid);

stock bool:WoundIsActive(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return false;
    return g_wound_active[playerid];
}

stock WoundSyncVitals(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;

    GetPlayerHealth(playerid, g_wound_last_health[playerid]);
    GetPlayerArmour(playerid, g_wound_last_armour[playerid]);
    return 1;
}

stock WoundReset(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 1;

    g_wound_active[playerid] = false;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;
    g_wound_last_health[playerid] = 100.0;
    g_wound_last_armour[playerid] = 0.0;

    if(g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }
    return 1;
}

stock Float:WoundGetFallbackDamage(weaponid)
{
    switch(weaponid)
    {
        case 22: return 8.25;   // Colt 45
        case 23: return 13.20;  // Silenced
        case 24: return 46.20;  // Desert Eagle
        case 25: return 30.00;  // Shotgun
        case 26: return 30.00;  // Sawnoff
        case 27: return 30.00;  // Combat shotgun
        case 28, 32: return 6.60;
        case 29: return 8.25;
        case 30, 31: return 9.90;
        case 33: return 24.75;
        case 34: return 41.25;
        case 35, 36, 37, 38: return 46.20;
    }
    return 0.0;
}

// На разных мобильных клиентах урон иногда приходит в callback, но HP не меняется.
// Если движок уже снял здоровье/броню, функция только синхронизирует P_HEALTH.
// Если не снял — применяет полученный amount вручную один раз.
stock WoundApplyWeaponDamage(playerid, issuerid, Float:amount, weaponid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(issuerid == INVALID_PLAYER_ID || !IsPlayerConnected(issuerid)) return 0;
    if(g_wound_active[playerid]) return 0;
    if(weaponid < 22 || weaponid > 38) return 0;

    new Float:current_health, Float:current_armour;
    GetPlayerHealth(playerid, current_health);
    GetPlayerArmour(playerid, current_armour);

    new Float:previous_health = g_wound_last_health[playerid];
    new Float:previous_armour = g_wound_last_armour[playerid];

    if(previous_health <= 0.0 || previous_health > 100.0)
        previous_health = GetPlayerHealthEx(playerid);
    if(previous_armour < 0.0 || previous_armour > 100.0)
        previous_armour = current_armour;

    // Стандартный урон уже применён клиентом/сервером — не удваиваем его.
    if(current_health < previous_health - 0.01 || current_armour < previous_armour - 0.01)
    {
        SetPlayerData(playerid, P_HEALTH, current_health);
        g_wound_last_health[playerid] = current_health;
        g_wound_last_armour[playerid] = current_armour;
        return 1;
    }

    new Float:damage = amount;
    if(damage <= 0.0) damage = WoundGetFallbackDamage(weaponid);
    if(damage <= 0.0) return 0;

    if(current_armour > 0.0)
    {
        if(current_armour >= damage)
        {
            current_armour -= damage;
            damage = 0.0;
        }
        else
        {
            damage -= current_armour;
            current_armour = 0.0;
        }
        SetPlayerArmour(playerid, current_armour);
    }

    if(damage > 0.0)
    {
        current_health -= damage;
        if(current_health < 0.0) current_health = 0.0;
        SetPlayerHealthEx(playerid, current_health, false);
    }
    else
    {
        SetPlayerData(playerid, P_HEALTH, current_health);
    }

    g_wound_last_health[playerid] = current_health;
    g_wound_last_armour[playerid] = current_armour;
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

    HidePlayerGUI(playerid, WOUNDGID);
    g_wound_gui_opened[playerid] = false;
    return 1;
}

stock WoundOpen(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;
    if(g_wound_gui_opened[playerid]) return 1;

    // Формат полностью совпадает с рабочим GUI смерти из last(3).
    new Node:json = JSON_Object();
    new wounded_name[MAX_PLAYER_NAME + 1];
    format(wounded_name, sizeof wounded_name, "%s", GetPlayerNameEx(playerid));

    JSON_SetInt(json, "id", playerid);
    JSON_SetString(json, "p", wounded_name, strlen(wounded_name));
    JSON_SetInt(json, "h", 0);

    g_wound_gui_opened[playerid] = true;
    ShowPlayerGUI(playerid, WOUNDGID, json);
    JSON_Cleanup(json);

    WoundPostGuiApply(playerid);
    SetTimerEx("WoundPostGuiApply", 250, false, "i", playerid);
    return 1;
}

stock WoundAnim(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, false);
    ApplyAnimationEx(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0, 1, USE_ANIM_TYPE_NONE);
    return 1;
}

public WoundPostGuiApply(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;

    SetPlayerData(playerid, P_HEALTH, 15.0);
    SetPlayerHealth(playerid, 15.0);
    SetPlayerArmour(playerid, 0.0);
    WoundAnim(playerid);
    WoundSyncVitals(playerid);
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

    if(g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    g_wound_respawn[playerid] = false;
    SetPlayerData(playerid, P_HOSPITAL, false);

    SetPlayerInterior(playerid, g_wound_int[playerid]);
    SetPlayerVirtualWorld(playerid, g_wound_vw[playerid]);
    SetPlayerPos(playerid, g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid] + 0.20);
    SetPlayerFacingAngle(playerid, g_wound_a[playerid]);
    SetCameraBehindPlayer(playerid);
    ResetPlayerWeapons(playerid);
    WoundOpen(playerid);
    return 1;
}

public WoundRespawn(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;

    g_wound_timer[playerid] = 0;
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid] || !g_wound_respawn[playerid]) return 0;

    WoundSetSpawn(playerid);
    SpawnPlayer(playerid);
    return 1;
}

stock WoundStart(playerid, killerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    if(g_wound_timer[playerid]) KillTimer(g_wound_timer[playerid]);

    GetPlayerPos(playerid, g_wound_x[playerid], g_wound_y[playerid], g_wound_z[playerid]);
    GetPlayerFacingAngle(playerid, g_wound_a[playerid]);
    g_wound_int[playerid] = GetPlayerInterior(playerid);
    g_wound_vw[playerid] = GetPlayerVirtualWorld(playerid);

    if(killerid != INVALID_PLAYER_ID && IsPlayerConnected(killerid))
        g_wound_killer[playerid] = killerid;
    else
        g_wound_killer[playerid] = INVALID_PLAYER_ID;

    g_wound_active[playerid] = true;
    g_wound_respawn[playerid] = true;
    g_wound_gui_opened[playerid] = false;

    SetPlayerData(playerid, P_HOSPITAL, false);
    UpdatePlayerDatabaseInt(playerid, "hospital", 0);
    WoundSetSpawn(playerid);

    // Даём клиенту закончить стандартную анимацию смерти и сразу возрождаем в состоянии ранения.
    g_wound_timer[playerid] = SetTimerEx("WoundRespawn", 700, false, "i", playerid);
    return 1;
}

stock WoundOnSpawn(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid] || !g_wound_respawn[playerid]) return 0;
    return WoundApply(playerid);
}

stock WoundHospital(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_wound_active[playerid]) return 0;

    if(g_wound_timer[playerid])
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    WoundClose(playerid);
    g_wound_active[playerid] = false;
    g_wound_respawn[playerid] = false;
    g_wound_gui_opened[playerid] = false;

    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, true);
    ResetPlayerWeapons(playerid);

    SetPlayerData(playerid, P_HOSPITAL, true);
    UpdatePlayerDatabaseInt(playerid, "hospital", 1);
    SetPlayerHealthEx(playerid, 15.0, false);
    SetPlayerArmour(playerid, 0.0);

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
    SetCameraBehindPlayer(playerid);
    WoundSyncVitals(playerid);
    SendClientMessage(playerid, 0x33FF33FF, "Вы были доставлены в Центральную больницу.");
    return 1;
}

stock WoundHandle(playerid, Node:json)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new action = -1;
    JSON_GetInt(json, "t", action);
    if(action == -1) JSON_GetInt(json, "type", action);
    if(action == -1) JSON_GetInt(json, "action", action);

    switch(action)
    {
        case 1:
        {
            SendClientMessage(playerid, 0xE3B341FF, "[Скорая] Вызов принят. Ожидайте помощь или нажмите кнопку отправки в больницу.");
            return 1;
        }
        case 2:
        {
            return WoundHospital(playerid);
        }
        case 4:
        {
            // Пока игрок находится в состоянии смерти, закрытие клиентом не отменяет состояние.
            if(g_wound_active[playerid])
            {
                g_wound_gui_opened[playerid] = false;
                SetTimerEx("WoundPostGuiApply", 150, false, "i", playerid);
            }
            return 1;
        }
    }
    return 1;
}
