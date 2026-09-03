#if defined _damage_newbuild_included
    #endinput
#endif
#define _damage_newbuild_included

// === Система ранений (Wound System) ===
new bool:g_wound_active[MAX_PLAYERS];
new g_wound_killer[MAX_PLAYERS];
new g_wound_timer[MAX_PLAYERS];

forward Wound_Timeout(playerid);

// Проверка: находится ли игрок сейчас в состоянии "ранен"
stock bool:WoundActive(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return false;
    return g_wound_active[playerid];
}

// Перевод игрока в состояние "ранен" вместо смерти
stock Wound_Start(playerid, killerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(WoundActive(playerid)) return 0;

    g_wound_active[playerid] = true;
    g_wound_killer[playerid] = killerid;

    SetPlayerData(playerid, P_HEALTH, 1.0);
    SetPlayerHealth(playerid, 1.0);

    TogglePlayerControllable(playerid, false);

    ShowWoundGUI(playerid, killerid);

    g_wound_timer[playerid] = SetTimerEx("Wound_Timeout", 10000, false, "i", playerid);
    return 1;
}

// Отправка раненого игрока в больницу (по таймауту либо по клику в GUI)
stock Wound_SendToHospital(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(!WoundActive(playerid)) return 0;

    g_wound_active[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;

    if(g_wound_timer[playerid] != 0)
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }

    HidePlayerGUI(playerid, GUIWoundSystem);

    SetPlayerData(playerid, P_HOSPITAL, true);
    SetPlayerData(playerid, P_HEALTH, 50.0);
    SetPlayerHealth(playerid, 50.0);
    SetPlayerArmour(playerid, 0.0);

    SetPlayerPos(playerid, 1482.54, 2504.26, 2501.04, 182.71);
    SetPlayerInterior(playerid, 1);

    TogglePlayerControllable(playerid, true);

    ShowNotification(playerid, 2, "Вы были доставлены в больницу после ранения.", 4, "", "");
    return 1;
}

public Wound_Timeout(playerid)
{
    g_wound_timer[playerid] = 0;
    if(!IsPlayerConnected(playerid)) return 0;
    if(!WoundActive(playerid)) return 0;

    Wound_SendToHospital(playerid);
    return 1;
}

stock Wound_OnDisconnect(playerid)
{
    if(g_wound_timer[playerid] != 0)
    {
        KillTimer(g_wound_timer[playerid]);
        g_wound_timer[playerid] = 0;
    }
    g_wound_active[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;
    return 1;
}
// === Конец системы ранений ===

new Float:g_newbuild_pending_damage[MAX_PLAYERS];
new Float:g_newbuild_snapshot_total[MAX_PLAYERS];
new g_newbuild_pending_attacker[MAX_PLAYERS];
new g_newbuild_pending_weapon[MAX_PLAYERS];
new g_newbuild_pending_bodypart[MAX_PLAYERS];
new g_newbuild_pending_token[MAX_PLAYERS];
new g_newbuild_last_bullet_tick[MAX_PLAYERS];
new g_newbuild_last_queue_tick[MAX_PLAYERS];
new g_newbuild_last_queue_attacker[MAX_PLAYERS];
new g_newbuild_last_queue_weapon[MAX_PLAYERS];

forward NewBuildDamage_Flush(victimid, token);

stock Float:NewBuildDamage_GetWeaponDamage(weaponid)
{
    switch(weaponid)
    {
        case 22, 23: return 18.0;
        case 24: return 46.0;
        case 25: return 32.0;
        case 26: return 28.0;
        case 27: return 38.0;
        case 28, 32: return 8.0;
        case 29: return 10.0;
        case 30, 31: return 12.0;
        case 33: return 30.0;
        case 34: return 55.0;
        case 38: return 14.0;
    }
    return 8.0;
}

stock Float:NewBuildDamage_GetAmount(weaponid, bodypart)
{
    new Float:damage = NewBuildDamage_GetWeaponDamage(weaponid);
    switch(bodypart)
    {
        case 9: damage *= 1.65;
        case 7, 8: damage *= 0.75;
        case 5, 6: damage *= 0.85;
    }
    if(damage < 1.0) damage = 1.0;
    if(damage > 95.0) damage = 95.0;
    return damage;
}

stock NewBuildDamage_IsAllowed(attackerid, victimid, weaponid)
{
    if(attackerid == victimid) return 0;
    if(attackerid < 0 || attackerid >= MAX_PLAYERS || !IsPlayerConnected(attackerid)) return 0;
    if(victimid < 0 || victimid >= MAX_PLAYERS || !IsPlayerConnected(victimid)) return 0;
    if(!IsPlayerLogged(attackerid) || !IsPlayerLogged(victimid)) return 0;
    if(WoundActive(victimid)) return 0;
    if(GetPlayerVirtualWorld(attackerid) != GetPlayerVirtualWorld(victimid)) return 0;
    if(GetPlayerInterior(attackerid) != GetPlayerInterior(victimid)) return 0;
    if(!IsPlayerStreamedIn(victimid, attackerid)) return 0;
    if(GetPVarInt(attackerid, "player_in_green_zone") || GetPVarInt(victimid, "player_in_green_zone")) return 0;
    if(!(22 <= weaponid <= 34) && weaponid != 38) return 0;

    new Float:max_distance = 100.0;
    switch(weaponid)
    {
        case 25, 26, 27: max_distance = 55.0;
        case 28, 29, 32: max_distance = 80.0;
        case 30, 31, 33: max_distance = 170.0;
        case 34: max_distance = 320.0;
        case 38: max_distance = 120.0;
    }
    new Float:x, Float:y, Float:z;
    GetPlayerPos(victimid, x, y, z);
    if(!IsPlayerInRangeOfPoint(attackerid, max_distance, x, y, z)) return 0;
    return 1;
}

stock NewBuildDamage_Queue(attackerid, victimid, weaponid, bodypart)
{
    new queue_tick = GetTickCount();
    if(g_newbuild_last_queue_attacker[victimid] == attackerid && g_newbuild_last_queue_weapon[victimid] == weaponid && queue_tick - g_newbuild_last_queue_tick[victimid] < 45) return 0;
    g_newbuild_last_queue_tick[victimid] = queue_tick;
    g_newbuild_last_queue_attacker[victimid] = attackerid;
    g_newbuild_last_queue_weapon[victimid] = weaponid;

    if(!NewBuildDamage_IsAllowed(attackerid, victimid, weaponid)) return 0;

    new Float:health, Float:armour;
    GetPlayerHealth(victimid, health);
    GetPlayerArmour(victimid, armour);

    if(g_newbuild_pending_damage[victimid] <= 0.0)
    {
        g_newbuild_snapshot_total[victimid] = health + armour;
        g_newbuild_pending_token[victimid]++;
        SetTimerEx("NewBuildDamage_Flush", 160, false, "ii", victimid, g_newbuild_pending_token[victimid]);
    }

    g_newbuild_pending_damage[victimid] += NewBuildDamage_GetAmount(weaponid, bodypart);
    g_newbuild_pending_attacker[victimid] = attackerid;
    g_newbuild_pending_weapon[victimid] = weaponid;
    g_newbuild_pending_bodypart[victimid] = bodypart;
    return 1;
}

public NewBuildDamage_Flush(victimid, token)
{
    if(victimid < 0 || victimid >= MAX_PLAYERS || !IsPlayerConnected(victimid)) return 0;
    if(token != g_newbuild_pending_token[victimid]) return 0;

    new Float:pending = g_newbuild_pending_damage[victimid];
    new attackerid = g_newbuild_pending_attacker[victimid];
    new weaponid = g_newbuild_pending_weapon[victimid];

    g_newbuild_pending_damage[victimid] = 0.0;
    if(pending <= 0.0 || !NewBuildDamage_IsAllowed(attackerid, victimid, weaponid)) return 0;

    new Float:health, Float:armour;
    GetPlayerHealth(victimid, health);
    GetPlayerArmour(victimid, armour);

    new Float:client_loss = g_newbuild_snapshot_total[victimid] - (health + armour);
    if(client_loss < 0.0) client_loss = 0.0;

    new Float:remaining = pending - client_loss;
    if(remaining <= 0.5) return 1;

    if(armour > 0.0)
    {
        if(armour >= remaining)
        {
            armour -= remaining;
            SetPlayerArmour(victimid, armour);
            remaining = 0.0;
        }
        else
        {
            remaining -= armour;
            SetPlayerArmour(victimid, 0.0);
        }
    }

    if(remaining > 0.0)
    {
        health -= remaining;
        if(health <= 0.0)
        {
            // Вместо обычной смерти от выстрела - перевод в состояние "ранен"
            SetPlayerData(victimid, P_HEALTH, 1.0);
            SetPlayerHealth(victimid, 1.0);
            Wound_Start(victimid, attackerid);
        }
        else
        {
            SetPlayerData(victimid, P_HEALTH, health);
            SetPlayerHealth(victimid, health);
        }
    }

    printf("[NEWBUILD DAMAGE] attacker=%d victim=%d weapon=%d queued=%.2f client=%.2f server=%.2f hp=%.2f armour=%.2f",
        attackerid, victimid, weaponid, pending, client_loss, remaining, health, armour);
    return 1;
}

stock NewBuildDamage_OnWeaponShot(playerid, weaponid, hittype, hitid, Float:hit_z)
{
    if(hittype != BULLET_HIT_TYPE_PLAYER || hitid == INVALID_PLAYER_ID) return 0;
    if(GetTickCount() - g_newbuild_last_bullet_tick[playerid] <= 120) return 0;

    new bodypart = 3;
    if(hit_z > 0.65) bodypart = 9;
    else if(hit_z < -0.35) bodypart = 7;
    return NewBuildDamage_Queue(playerid, hitid, weaponid, bodypart);
}

stock NewBuildDamage_OnConnect(playerid)
{
    g_newbuild_pending_damage[playerid] = 0.0;
    g_newbuild_snapshot_total[playerid] = 0.0;
    g_newbuild_pending_attacker[playerid] = INVALID_PLAYER_ID;
    g_newbuild_pending_weapon[playerid] = 0;
    g_newbuild_pending_bodypart[playerid] = 3;
    g_newbuild_pending_token[playerid] = 0;
    g_newbuild_last_bullet_tick[playerid] = 0;
    g_newbuild_last_queue_tick[playerid] = 0;
    g_newbuild_last_queue_attacker[playerid] = INVALID_PLAYER_ID;
    g_newbuild_last_queue_weapon[playerid] = 0;

    g_wound_active[playerid] = false;
    g_wound_killer[playerid] = INVALID_PLAYER_ID;
    g_wound_timer[playerid] = 0;
    return 1;
}

IPacket:206(playerid, BitStream:bs)
{
    new data[PR_BulletSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadBulletSync(bs, data);

    g_newbuild_last_bullet_tick[playerid] = GetTickCount();
    if(data[PR_hitType] == BULLET_HIT_TYPE_PLAYER && data[PR_hitId] != INVALID_PLAYER_ID)
    {
        new bodypart = 3;
        if(data[PR_offsets][2] > 0.65) bodypart = 9;
        else if(data[PR_offsets][2] < -0.35) bodypart = 7;
        NewBuildDamage_Queue(playerid, data[PR_hitId], data[PR_weaponId], bodypart);
    }
    return 1;
}
