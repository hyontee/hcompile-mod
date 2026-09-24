#if defined _anticheat_included
    #endinput
#endif
#define _anticheat_included

static Float:playerHealth[MAX_PLAYERS];
static Float:playerArmour[MAX_PLAYERS];
static playerWeapon[MAX_PLAYERS][13];
static playerAmmo[MAX_PLAYERS][13];
static playerLastHitID[MAX_PLAYERS];
static playerLastHitTick[MAX_PLAYERS];
static playerIsNPC[MAX_PLAYERS];
static playerRetardKill[MAX_PLAYERS];
static playerFakeKill[MAX_PLAYERS];
static playerSpawn[MAX_PLAYERS];

static Float:WeaponDamage[47] =
{
	6.60, 1.32, 4.62, 6.60, 6.60, 6.60, 6.60,
	6.60, 6.60, 27.06, 4.62, 6.60, 6.60, 6.60,
	4.62, 6.60, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
	8.25, 13.2, 46.2, 49.5, 49.5, 39.6, 6.6,
	8.25, 9.9, 9.9, 6.6, 24.75, 41.25, 0.0,
	0.0, 0.0, 46.2, 0.0, 0.0, 0.33, 0.33,
	0.0, 0.0, 0.0, 0.0
};

static WeaponSlots[47] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, -1, -1, -1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11};

public OnGameModeInit()
{
    #if defined ac_OnGameModeInit
        return ac_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#if defined ac_OnGameModeInit
    forward ac_OnGameModeInit();
#endif
#define OnGameModeInit ac_OnGameModeInit

public OnPlayerConnect(playerid)
{
    playerIsNPC[playerid] = IsPlayerNPC(playerid);
    playerRetardKill[playerid] = 0;
    playerFakeKill[playerid] = 0;
    playerSpawn[playerid] = 0;
    
    // Сбрасываем оружие
    for(new id; id < 13; id++)
    {
        playerAmmo[playerid][id] = 0;
        playerWeapon[playerid][id] = 0;
    }
    
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    ResetPlayerWeapons(playerid);
    
    #if defined ac_OnPlayerConnect
        return ac_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#if defined ac_OnPlayerConnect
    forward ac_OnPlayerConnect(playerid);
#endif
#define OnPlayerConnect ac_OnPlayerConnect

public OnPlayerSpawn(playerid)
{
    if(!playerIsNPC[playerid])
    {
        playerFakeKill[playerid] = 0;
        playerRetardKill[playerid] = 0;
        
        // Возвращаем HP/Armour
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 0.0);
        
        // Сбрасываем оружие
        ResetPlayerWeapons(playerid);
        ApplyAnimation(playerid, "PED", "null", 0.0, 0, 0, 0, 0, 0);
        
        // Возвращаем сохранённое оружие
        for(new id; id < 13; id++)
        {
            if(playerWeapon[playerid][id] && playerAmmo[playerid][id])
            {
                GivePlayerWeapon(playerid, playerWeapon[playerid][id], playerAmmo[playerid][id]);
            }
        }
    }
    
    #if defined ac_OnPlayerSpawn
        return ac_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#if defined ac_OnPlayerSpawn
    forward ac_OnPlayerSpawn(playerid);
#endif
#define OnPlayerSpawn ac_OnPlayerSpawn

public OnPlayerDeath(playerid, killerid, reason)
{
    if(playerRetardKill[playerid]) return 0;
    
    if(!playerIsNPC[playerid])
    {
        // Определяем настоящего киллера
        if(killerid == INVALID_PLAYER_ID && reason == 255 && (GetTickCount() - playerLastHitTick[playerid]) < 1000)
        {
            killerid = playerLastHitID[playerid];
        }
        
        playerSpawn[playerid] = 1;
        playerFakeKill[playerid] = 1;
        
        // Сохраняем оружие перед сбросом
        for(new id; id < 13; id++)
        {
            new weap, ammo;
            GetPlayerWeaponData(playerid, id, weap, ammo);
            playerWeapon[playerid][id] = weap;
            playerAmmo[playerid][id] = ammo;
        }
        
        ResetPlayerWeapons(playerid);
    }
    
    #if defined ac_OnPlayerDeath
        return ac_OnPlayerDeath(playerid, killerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#if defined ac_OnPlayerDeath
    forward ac_OnPlayerDeath(playerid, killerid, reason);
#endif
#define OnPlayerDeath ac_OnPlayerDeath

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(!(22 <= weaponid <= 34) && weaponid != 38) return 0;
    
    new ret = 1;
    #if defined ac_OnPlayerWeaponShot
        ret = ac_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
    #endif
    
    if(ret && hittype == BULLET_HIT_TYPE_PLAYER)
    {
        if(!playerIsNPC[hitid] && IsPlayerConnected(hitid))
        {
            new Float:pos_x, Float:pos_y, Float:pos_z;
            GetPlayerPos(hitid, pos_x, pos_y, pos_z);
            new Float:topldist = VectorSize(pos_x - fX, pos_y - fY, pos_z - fZ);
            
            DamageSystem(playerid, weaponid, hitid, topldist);
            ret = 0;
        }
    }
    return ret;
}
#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot
#else
    #define _ALS_OnPlayerWeaponShot
#endif
#if defined ac_OnPlayerWeaponShot
    forward ac_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif
#define OnPlayerWeaponShot ac_OnPlayerWeaponShot

// Переопределение SetPlayerHealth с сохранением
stock ac_SetPlayerHealth(playerid, Float:heal)
{
    playerHealth[playerid] = heal;
    return SetPlayerHealth(playerid, heal);
}
#if defined _ALS_SetPlayerHealth
    #undef SetPlayerHealth
#else
    #define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth ac_SetPlayerHealth

// Переопределение SetPlayerArmour с сохранением
stock ac_SetPlayerArmour(playerid, Float:arm)
{
    playerArmour[playerid] = arm;
    return SetPlayerArmour(playerid, arm);
}
#if defined _ALS_SetPlayerArmour
    #undef SetPlayerArmour
#else
    #define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour ac_SetPlayerArmour

// Переопределение SetPlayerAmmo с сохранением
stock ac_SetPlayerAmmo(playerid, weap, ammo)
{
    new slot = WeaponSlots[weap];
    if(slot != -1)
    {
        playerAmmo[playerid][slot] = ammo;
        playerWeapon[playerid][slot] = weap;
    }
    return SetPlayerAmmo(playerid, weap, ammo);
}
#if defined _ALS_SetPlayerAmmo
    #undef SetPlayerAmmo
#else
    #define _ALS_SetPlayerAmmo
#endif
#define SetPlayerAmmo ac_SetPlayerAmmo

// Переопределение GivePlayerWeapon с сохранением
stock ac_GivePlayerWeapon(playerid, weap, ammo)
{
    new slot = WeaponSlots[weap];
    if(slot != -1)
    {
        playerAmmo[playerid][slot] += ammo;
        playerWeapon[playerid][slot] = weap;
    }
    return GivePlayerWeapon(playerid, weap, ammo);
}
#if defined _ALS_GivePlayerWeapon
    #undef GivePlayerWeapon
#else
    #define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon ac_GivePlayerWeapon

// Переопределение ResetPlayerWeapons с сохранением
stock ac_ResetPlayerWeapons(playerid)
{
    for(new id; id < 13; id++)
    {
        playerAmmo[playerid][id] = 0;
        playerWeapon[playerid][id] = 0;
    }
    return ResetPlayerWeapons(playerid);
}
#if defined _ALS_ResetPlayerWeapons
    #undef ResetPlayerWeapons
#else
    #define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons ac_ResetPlayerWeapons

// Переопределение SpawnPlayer с защитой
stock ac_SpawnPlayer(playerid)
{
    playerSpawn[playerid] = 1;
    return SpawnPlayer(playerid);
}
#if defined _ALS_SpawnPlayer
    #undef SpawnPlayer
#else
    #define _ALS_SpawnPlayer
#endif
#define SpawnPlayer ac_SpawnPlayer

static DamageSystem(playerid, weap, hitid, Float:topldist) if(!playerRetardKill{hitid} && !playerFakeKill{hitid})
{
 	new Float:ndmg, Float:dmg = WeaponDamage[weap];
	if(25 <= weap <= 27)
	{
		ndmg = (topldist / 7.5);
		if(ndmg >= 1.0 && (5.0 <= topldist <= MaxDistShot[weap - 22])) dmg = (dmg / ndmg);
	}
 	new Float:heal = playerHealth[hitid], Float:arm = playerArmour[hitid];
 	#if defined OnPlayerDamageStatusUpdateAC
		if(!OnPlayerDamageStatusUpdateAC(playerid, hitid, dmg, heal, arm, weap)) return;
	#endif
	playerLastHitID[hitid] = playerid;
    playerLastHitTick[hitid] = GetTickCount();
	if(!arm)
    {
        if((heal - dmg) > 0.0) SetPlayerHealth(hitid, (heal - dmg));
        else
		{
		    DeathSystem(hitid, playerid, weap);
		    if(!CheatStatus[AC_INFDAMAGE]) HideDamage(playerid);
		}
    }
	else if(dmg > arm)
    {
        SetPlayerArmour(hitid, 0.0);
        if((heal - (dmg - arm)) > 0.0) SetPlayerHealth(hitid, (heal - (dmg - arm)));
        else
		{
		    DeathSystem(hitid, playerid, weap);
		    if(!CheatStatus[AC_INFDAMAGE]) HideDamage(playerid);
		}
    }
	else SetPlayerArmour(hitid, (arm - dmg));
    if(!CheatStatus[AC_INFDAMAGE])
	{
	    CheatCount[AC_INFDAMAGE]++;
		//ShowDamage(playerid, hitid);
	}
}

static DeathSystem(playerid, killerid, reason)
{
    if(playerRetardKill[playerid] || playerFakeKill[playerid]) return;
    
    playerRetardKill[playerid] = 1;
    
    #if defined ac_OnPlayerDeath
        ac_OnPlayerDeath(playerid, killerid, reason);
    #else
        #pragma unused killerid
        #pragma unused reason
    #endif
    
    SetPlayerHealth(playerid, 1.0);
    ResetPlayerWeapons(playerid);
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 0);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    
    SetTimerEx("ac_DeathRespawn", 3000, 0, "i", playerid);
    
    ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
}

forward ac_DeathRespawn(playerid);
public ac_DeathRespawn(playerid)
{
    playerRetardKill[playerid] = 0;
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    SetPlayerVirtualWorld(playerid, 0);
    TogglePlayerControllable(playerid, 1);
    SpawnPlayer(playerid);
}

#if defined OnPlayerDamageStatusUpdateAC
    forward OnPlayerDamageStatusUpdateAC(playerid, hitid, &Float:dmg, &Float:heal, &Float:arm, weaponid);
#endif