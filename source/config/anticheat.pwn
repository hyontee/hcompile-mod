// Packet limits:
#define MAX_SURF_DISTANCE 300.0

// AntiCheat defines:
#define AC_TIMER_UPDATE_NAME        "AC_Timer"
#define AC_TIMER_UPDATE_INTERVAL    5000

#define AC_NOPE     0
#define AC_KICK     1
#define AC_WARNING  2

// AntiCheat codes:
const AC_INVALID_SURF_VEHICLE   = 1;
const AC_INVALID_SURF_OBJECT    = 2;
const AC_INVALID_WEAPONS_UPDATE = 3;
const AC_INVALID_WEAPON_SHOT    = 4;
const AC_INVALID_AMMO_SHOT      = 5;

// Packet identificators:
const ID_PLAYER_SYNC        = 207;
const ID_UNOCCUPIED_SYNC    = 209;
const ID_WEAPONS_UPDATE     = 204;
const ID_BULLET_SYNC        = 206;

// AntiCheat variables:
const ALLOWED_CARS_LENGTH       = 27;
const ALLOWED_GUNS_LENGTH       = 4;
const ANTICHEAT_ENABLE_INDEX    = 0;

new allowedCars[ALLOWED_CARS_LENGTH] = {478, 430, 446, 452, 453, 473, 472, 454, 484, 493, 595, 543, 
    605, 538, 433, 408, 601, 582, 546, 578, 554, 413, 422, 407, 456, 407, 570};

new allowedGuns[ALLOWED_GUNS_LENGTH] = {2, 3, 40, 46};
new bulletSyncCounter[MAX_PLAYERS];
new weaponsUpdateCounter[MAX_PLAYERS];

// AntiCheat configuration:
new antiCheatConfiguration[] = {
    true, // Enable this anti-cheat.
    AC_KICK, // 0x01 - Invalid surf on vehicle.
    AC_KICK, // 0x02 - Invalid surf on object.
    AC_KICK, // 0x03 - Invalid weapons update.
    AC_KICK, // 0x04 - Invalid weapon shot.
    AC_KICK, // 0x05 - Invalid AMMO shot.
};

// AntiCheat functional:
stock isPlayerAdmin(playerid) {
    return (pInfo[playerid][pAdmin] && pTemp[playerid][PlayerADostup]);
}

stock Float:getDistance(Float:firstPositionX, Float:firstPositionY, Float:firstPositionZ,
    Float:secondPositionX, Float:secondPositionY, Float:secondPositionZ) 
{
    return floatsqroot(
        floatpower(secondPositionX - firstPositionX, 2) +
        floatpower(secondPositionY - firstPositionY, 2) +
        floatpower(secondPositionZ - firstPositionZ, 2));
}

stock kickPlayer(playerid, code)
{
    switch (antiCheatConfiguration[code])
    {
        case AC_KICK:
        {
            if (!IsPlayerKicked(playerid))
            {
                new kickBuffer[92];

                format(kickBuffer, sizeof(kickBuffer), "<AntiCheat> {FFFFFF}Вы были кикнуты по подозрению в читерстве. \
                    {FF0000}Код: {FFFFFF}0x0%d", code);
            
                scmKick(playerid, kickBuffer);
            }
        }
        case AC_WARNING:
        {
            new cheatNames[][] = {"Nope", "Teleport", "Teleport", "D-Gun", "D-Gun","invalid-ammo"};
            new warningBuffer[100];
            
            format(warningBuffer, sizeof(warningBuffer), "Возможно использует %s", cheatNames[code]);
            OnPlayerWarning(playerid, warningBuffer);
        }
    }
}

stock AC_Initialize() {
    mysql_tquery(dbHandle, "SELECT * FROM `anticheat_configuration`", "AC_LoadSettings");
}

stock AC_UpdateSettings(code) 
{
    new queryFormat[80];

    mysql_format(dbHandle, queryFormat, sizeof(queryFormat),
        "UPDATE `anticheat_configuration` SET `Enable` = %d WHERE `Code` = %d",
        antiCheatConfiguration[code], code);

    mysql_tquery(dbHandle, queryFormat, "");
}

stock AC_Update(playerid)
{
    if (bulletSyncCounter[playerid] > weaponsUpdateCounter[playerid]) 
    {
        if (antiCheatConfiguration[AC_INVALID_WEAPONS_UPDATE])
            kickPlayer(playerid, AC_INVALID_WEAPONS_UPDATE);
    }

    bulletSyncCounter[playerid] = 0;
    weaponsUpdateCounter[playerid] = 0;
}

// AntiCheat five seconds timer:
publics: AC_Timer()
{
    if (!antiCheatConfiguration[ANTICHEAT_ENABLE_INDEX])
        return;

    foreach (new i : Player) {
        if (!pInfo[i][pLogin] || AntiCheatIsKickedWithDesync(i)) continue;
        AC_Update(i);
    }
}

// AntiCheat settings loader:
publics: AC_LoadSettings()
{
    new numRows = cache_num_rows();

    if (!numRows)
        return printf("AntiCheat Error: Settings didn't found.");

    for (new i; i < numRows; i++)
    {
        new acCode, codeEnable;

        cache_get_value_name_int(i, "Code", acCode);
        cache_get_value_name_int(i, "Enable", codeEnable);

        antiCheatConfiguration[acCode] = codeEnable;
    }

    SetTimer(AC_TIMER_UPDATE_NAME, 
        AC_TIMER_UPDATE_INTERVAL, true);

    return true;
}
/*IPacket:ID_PLAYER_SYNC(playerid, BitStream:bs)
{
	new RAKNET_ONFOOT_PACKET;
	new RAKNET_ONFOOT[PR_OnFootSync];
	
	BS_ReadUint8(bs, RAKNET_ONFOOT_PACKET);
	BS_ReadOnFootSync(bs, RAKNET_ONFOOT);

	SERVER_INFO[playerid][SAMP_SPEED_X] = RAKNET_ONFOOT[PR_velocity][0];
	SERVER_INFO[playerid][SAMP_SPEED_Y] = RAKNET_ONFOOT[PR_velocity][1];
	SERVER_INFO[playerid][SAMP_SPEED_Z] = RAKNET_ONFOOT[PR_velocity][2];
	
	SERVER_INFO[playerid][SAMP_POS_X] = RAKNET_ONFOOT[PR_position][0];
	SERVER_INFO[playerid][SAMP_POS_Y] = RAKNET_ONFOOT[PR_position][1];
	SERVER_INFO[playerid][SAMP_POS_Z] = RAKNET_ONFOOT[PR_position][2];
	
	SERVER_INFO[playerid][SAMP_ID_VEHICLE] = 0;
	
	if(CENTER_CONTROLE[0][CONTROL_DAMAGE] == 1)
	{
		if(SAMP_AC_CHECK_PLAYER_HEALTH(playerid, RAKNET_ONFOOT[PR_health]) == 0) return 0;
	
		BS_Reset(bs);
		BS_WriteUint8(bs, RAKNET_ONFOOT_PACKET);
		BS_WriteOnFootSync(bs, RAKNET_ONFOOT);
	}
	
	#include																		SAMP_AC/MODULE/ANTICHEAT/INVISIBLE_VEHICLE
	#include																		SAMP_AC/MODULE/ANTICHEAT/SURFING_INVISIBLE
	#include																		SAMP_AC/MODULE/ANTICRASHER/QUATERION
	#include                                                                        SAMP_AC/MODULE/ANTINOP/POSITION
	#include                                                                        SAMP_AC/MODULE/ANTICHEAT/FLY_HACK
	#include                                                                        SAMP_AC/MODULE/ANTICHEAT/AIR_BREAK
	#include                                                                        SAMP_AC/MODULE/ANTICHEAT/TELEPORT_HACK
	#include																		SAMP_AC/MODULE/ANTICHEAT/MOP
	#include                                                                        SAMP_AC/MODULE/ANTINOP/PUT_VEHICLE
	#include                                                                        SAMP_AC/MODULE/ANTINOP/ARMED_WEAPON
	#include																		SAMP_AC/MODULE/ANTICHEAT/SPEED_HACK_ONFOOT
	
	
    return 1;
}*/
// Packet callbacks:
IPacket:ID_PLAYER_SYNC(playerid, BitStream:bs)
{
    if (!antiCheatConfiguration[ANTICHEAT_ENABLE_INDEX])
        return true;

	new onFootData[PR_OnFootSync];

	BS_IgnoreBits(bs, 8);
	BS_ReadOnFootSync(bs, onFootData);

    // AntiCheat on D-Gun:
    if (antiCheatConfiguration[AC_INVALID_WEAPON_SHOT] != 0 && 
        GetTickCount() > pTemp[playerid][acWeaponTick] + GetPlayerPing(playerid) && IsPlayerAFK(playerid) < 1) 
    {
        new bool:allowedGun;

        for (new i; i < ALLOWED_GUNS_LENGTH; i++)
        {
            if (onFootData[PR_weaponId] == allowedGuns[i]){
                allowedGun = true;
                break;
            }
        }
        //ResetPlayerWeaponsEx(playerid);
        if (onFootData[PR_weaponId] != player_weapon_id[playerid][GetWeaponSlot[onFootData[PR_weaponId]]] && !allowedGun)
            kickPlayer(playerid, AC_INVALID_WEAPON_SHOT);
    }

    // AntiCheat on invalid surfing:
	if (onFootData[PR_surfingVehicleId] != 0)
	{
        for (new i; i < ALLOWED_CARS_LENGTH; i++)
            if (onFootData[PR_surfingVehicleId] == allowedCars[i])
                return true;

        new Float:playerPosition[3];
        new Float:surfPosition[3];

        GetPlayerPos(playerid, playerPosition[0], playerPosition[1],
            playerPosition[2]);

		if (IsValidVehicle(onFootData[PR_surfingVehicleId])) // Filter on valid cars.
        {
            if (antiCheatConfiguration[AC_INVALID_SURF_VEHICLE] != 0)
            {
                GetVehiclePos(onFootData[PR_surfingVehicleId], 
                    surfPosition[0], surfPosition[1], surfPosition[2]);

                if (getDistance(playerPosition[0], playerPosition[1], playerPosition[2], 
                        surfPosition[0], surfPosition[1], surfPosition[2]) > MAX_SURF_DISTANCE) {
                    kickPlayer(playerid, AC_INVALID_SURF_VEHICLE);
                }
            }

			return true;
        }
        
        if (IsValidObject(onFootData[PR_surfingVehicleId])) // Filter on valid objects.
        {
            if (antiCheatConfiguration[AC_INVALID_SURF_OBJECT] != 0)
            {
                GetObjectPos(onFootData[PR_surfingVehicleId], 
                    surfPosition[0], surfPosition[1], surfPosition[2]);
                
                if (getDistance(playerPosition[0], playerPosition[1], playerPosition[2], 
                        surfPosition[0], surfPosition[1], surfPosition[2]) > MAX_SURF_DISTANCE) {
                    kickPlayer(playerid, AC_INVALID_SURF_OBJECT);
                }
            }

            return true;
        }
        /*new SAMP_AC_OBJECT = GetPlayerSurfingObjectID(playerid);
		if(SAMP_AC_OBJECT > 0x0 && SAMP_AC_OBJECT != 0xFFFF && IsValidObject(SAMP_AC_OBJECT))
		{
			new Float: SAMP_AC_X, Float: SAMP_AC_Y, Float: SAMP_AC_Z;
			GetObjectPos(SAMP_AC_OBJECT, SAMP_AC_X, SAMP_AC_Y, SAMP_AC_Z);
			if(!IsPlayerInRangeOfPoint(playerid, 50.0, SAMP_AC_X, SAMP_AC_Y, SAMP_AC_Z))
			{
				SAMP_AC_SEND_WARNING_FOR_SCRIPT(playerid, "Invisible Vehicle", 19, 0);
			}
		}*/
        return false;
	}

	return true;
}

IPacket:ID_UNOCCUPIED_SYNC(playerid, BitStream:bs)
{
    if (!antiCheatConfiguration[ANTICHEAT_ENABLE_INDEX])
        return true;

    new unoccupiedData[PR_UnoccupiedSync];
    
    BS_ReadUint8(bs, 8);
    BS_ReadUnoccupiedSync(bs, unoccupiedData);
    
    // AntiCheat on Quantum Crasher:
    if (!(-1.0 <= unoccupiedData[PR_roll][0] <= 1.00000)
        || !(-1.0 <= unoccupiedData[PR_roll][1] <= 1.00000)
        || !(-1.0 <= unoccupiedData[PR_direction][0] <= 1.00000)
        || !(-1.0 <= unoccupiedData[PR_roll][2] <= 1.00000)
        || !(-1.0 <= unoccupiedData[PR_direction][1] <= 1.00000)
        || !(-1.0 <= unoccupiedData[PR_direction][2] <= 1.00000)
        || !(-20000.0 <= unoccupiedData[PR_position][0] <= 20000.00000)
        || !(-20000.0 <= unoccupiedData[PR_position][1] <= 20000.00000)
        || !(-20000.0 <= unoccupiedData[PR_position][2] <= 20000.00000)
        || !(-1.00000 <= unoccupiedData[PR_angularVelocity][0] <= 1.00000)
        || !(-1.00000 <= unoccupiedData[PR_angularVelocity][1] <= 1.00000)
        || !(-1.00000 <= unoccupiedData[PR_angularVelocity][2] <= 1.00000)
        || !(-100.00000 <= unoccupiedData[PR_velocity][0] <= 100.00000)
        || !(-100.00000 <= unoccupiedData[PR_velocity][1] <= 100.00000)
        || !(-100.00000 <= unoccupiedData[PR_velocity][2] <= 100.00000)) 
            return false;

    return true;
}

IPacket:ID_BULLET_SYNC(playerid, BitStream:bs)
{
    if (!antiCheatConfiguration[ANTICHEAT_ENABLE_INDEX])
        return true;

    new bulletData[PR_BulletSync];

    BS_ReadUint8(bs, 8);
    BS_ReadBulletSync(bs, bulletData);

    bulletSyncCounter[playerid]++;
    player_weapon_ammo[playerid][GetWeaponSlot[bulletData[PR_weaponId]]]--;

    if(player_weapon_ammo[playerid][GetWeaponSlot[bulletData[PR_weaponId]]]+1 < 0 && !IsPlayerDeath(playerid) )
    {
        kickPlayer(playerid, AC_INVALID_AMMO_SHOT);
    }

    return true;
}

IPacket:ID_WEAPONS_UPDATE(playerid, BitStream:bs)
{
    if (!antiCheatConfiguration[ANTICHEAT_ENABLE_INDEX])
        return true;

    new weaponsUpdateData[PR_WeaponsUpdate];
    BS_ReadUint8(bs, 8);
    BS_ReadWeaponsUpdate(bs, weaponsUpdateData);

    weaponsUpdateCounter[playerid]++;
    return true;
}
 