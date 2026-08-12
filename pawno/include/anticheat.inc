/**
 * Module: hkAntiCheat.inc
 * Author: alferov
 * Last update: 25.02.2021
 */



/*
 * custom kick callback
 * example:

forward hkOnCheatDetected(playerid, hkKickCode:code);
public hkOnCheatDetected(playerid, hkKickCode:code) {
	if (player is admin)
		return 0;
	
	message for player, kick, etc...
	return 1;
}


 * custom warning callback
 * example:

forward hkOnSendWarning(playerid, const message[]);
public hkOnSendWarning(playerid, const message[]) {
	if (is playerid admin) or #pragma unused playerid
		return;

	for (players idx) {
		if (idx is admin)
			message for idx
	}
}


 * switch anticheat kick status:
 * true/false - enable/disable kick status
 * example:

hkToggleAntiCheat(playerid, hkKickCode:hk_CLICK_WARP, false); // disable kick hk_CLICK_WARP
*/



#if defined _hkac_included
	#endinput
#endif
#define _hkac_included

#if !defined PAWNRAKNET_INC_
	#endinput
#endif

#if __Pawn >= 0x3A && defined __PawnBuild
	#if __Pawn > 0x3A || __PawnBuild >= 2
		#if !defined static_enum
			#define static_enum static enum
		#endif

		#if !defined static_const
			#define static_const(%0) static enum { %0 }
		#endif
	#endif
#endif

#if !defined static_enum
	#define static_enum enum
#endif

#if !defined static_const
	#define static_const(%0) static const %0
#endif

#if !defined gpci
    native gpci(playerid, buffer[], size = sizeof(buffer));
#endif


#define hkDEBUG 0
#define hkKICK_COLOR 0xFF6347FF

/* 
 * bullet sync damager
 * aim sync damager
 * spread
*/
#define hk_DEFAULT_WARNINGS_VALUE 2, 3, 3

#define hkIsSkillfulWeapon(%0) (%0 >= WEAPON_COLT45 && %0 <= WEAPON_SNIPER)
#define hkGetPlayerSkillByWeapon(%0,%1) hkGetPlayerSkillLevel(%0, hkGetSkillIdByWeapon(%1))
#define hkIsBulletWeapon(%0) ((%0 >= 22 && %0 <= 34) || %0 == 38)
#define hkIsInvalidValue(%0) (hkIsNaN(%0) || hkIsInfinity(%0))

static stock Float:hkGetDistance3D(Float:x, Float:y, Float:z, Float:fx, Float:fy, Float:fz);
static stock Float:hkGetDistance2D(Float:x, Float:y, Float:fx, Float:fy);
static stock Float:hkGetDistance1D(Float:x, Float:fx);

enum hkKickCode {
	hk_NONE = 0,
	hk_CRASH_INVISIBLE = 1, // инвиз+спек крашер 1
	hk_NO_SKILLS, // фейк скиллы 2
	hk_DAMAGER_AIM_SYNC, // дамагер, проверка через aim sync 3
	hk_DAMAGER_BULLET_SYNC,  // дамагер, проверка через bullet sync 4
	hk_CLICK_WARP, // телепорт через колесо в собейте (on foot) 5
	hk_INVALID_SURFING, // кривая surfing машина (инвиз) 6
	hk_RPC_DAMAGE_1, // дамагер через rpc 7
	hk_INVALID_WEAPON, // кривой ган 8
	hk_DGUN, // чит на патроны / ган 9
	hk_FLY_ANIM, // флаги и анимации флая / метлы 10
	hk_EXIT_VEHICLE_TP, // телепорт через подмену координат при выходе из машины 11
	hk_NOP_REMOVE_FROM_VEHICLE, // ноп RemovePlayerFromVehicle 12
	hk_NOP_PUT_IN_VEHICLE, // ноп PutPlayerInVehicle 13
	hk_CHANGE_SEAT, // passenger сразу после incar и наоборот / смена слота в авто 14
	hk_INVALID_AIM_Z, // отрезает часть скина игрока15
	hk_SHAKING_CAMERA, // тряска камеры игроков 16
	hk_SPECTATING_WO_ACCESS, // отправка spectating sync без TogglePlayerSpectating 17
#if PAWNRAKNET_INCLUDE_VERSION >= 140
	hk_USE_AUTOAIM, // функция auto aim на мобильной клиенте 18
#endif
	hk_FLY, // флай 19
	hk_BIG_TP, // телепорт (on foot / in car) большой разрыв координат за короткий промежуток времени 20
	hk_REMOTE_CARHACK, // удалённое управления машинами / посадка в авто без RPC Enter Vehicle 21

	hk_MAX_CODE = 30
}

/*
 * без кика:

 * нопы на невалидные данные (фиксы крашеров)
 * перезапись невалидной синхры (для того чтоб не кикать если будет ложный)
 * защита от нопа SetPlayerPos, SetPlayerPosFindZ, SetVehiclePos сделана путём возврата на установленные координаты и десинхронизации игрока
*/

static_enum hkInfo {
	Float:hkLastPosX, Float:hkLastPosY, Float:hkLastPosZ,
	Float:hkLastSetPosX, Float:hkLastSetPosY, Float:hkLastSetPosZ,
	Float:hkLastVelX, Float:hkLastVelY, Float:hkLastVelZ,
	Float:hkLastBigTpPosX, Float:hkLastBigTpPosY, Float:hkLastBigTpPosZ,
	Float:hkDesyncPosX, Float:hkDesyncPosY, Float:hkDesyncPosZ,
	Float:hkLastBulletOffsetX, Float:hkLastBulletOffsetY, Float:hkLastBulletOffsetZ,
	hkLastSetPosTime,
	hkPlayerState,
	hkLastPacketTime,
	hkLastCurrentWeaponId,
	hkLastTargetId,
	hkLastAnim,
	hkLastVehicleId,
	hkLastEnterVehicleId,
	hkSurfVehicleId,
	hkLastSurfTime,
	hkLastHitTime,
	hkDesyncVehiclePlayerId,
	hkDesyncVehicleId,
	hkLastSubmissionKeyTime,
	hkLastRemoveTime,
	hkLastPutTime,
	hkLastPutVehicle,
	hkVehicleSeat,
	hkLastDesyncPosTime,
	hkLastSpawnTime,
	hkLastBigTpTime,
	hkLastSpectatingTime,
	hkLastEnterVehicleTime,
	hkLastDeathTime,
	hkLastCamMode,
	bool:hkIsWasted,
	bool:hkSurfDesync,
	bool:hkRemoveFromVehicle,
	bool:hkAnimIsBad,
	bool:hkFirstOnFootAfterShot,
	bool:hkWaitAimSync,
	bool:hkNewPosIsValid,
	bool:hkIsSpectating,
	bool:hkIsMobile
};

static_enum hkWeaponInfo {
	hkWeaponId,
	hkWeaponAmmo,
	hkIgnoreWeaponTime
};

static_enum hkMaxWarningsInfo {
	hkBulletSyncDamager,
	hkAimSyncDamager,
	hkSpread
};


static stock hkData							[MAX_PLAYERS][hkInfo];
static stock hkWeaponData					[MAX_PLAYERS][hkWeaponInfo][13];
static stock hkMaxWarnings					[MAX_PLAYERS][hkMaxWarningsInfo];

static stock hkPlayerSkill					[MAX_PLAYERS][11];
static stock hkLastWarningTime				[MAX_PLAYERS];

static stock bool:hkIsKicked				[MAX_PLAYERS];
static stock bool:hkAcStatus				[hk_MAX_CODE];

static stock hkVehicleDriverId				[MAX_VEHICLES] = {INVALID_PLAYER_ID, ...};
static stock bool:hkVehicleIsDesync			[MAX_VEHICLES];

static const __hk_default_warnings_value	[hkMaxWarningsInfo] = {hk_DEFAULT_WARNINGS_VALUE};

static stock DB:hkDBhandle					= DB:-1;

#if defined hkOnCheatDetected
	static stock bool:hkKickCallback		= false;
#endif

#if defined hkOnSendWarning
	static stock bool:hkWarningCallback		= false;
#endif


stock hkDestroyVehicle(vehicleid) {
	new driverid = INVALID_PLAYER_ID;
	new Float:x, Float:y, Float:z;

	GetVehiclePos(vehicleid, x, y, z);

#if defined foreach
	foreach(new i : Player) {
#else
	for (new i = GetPlayerPoolSize(); i >= 0; --i) {
		if (!IsPlayerConnected(i))
			continue;
#endif
		if (hkVehicleIsDesync[vehicleid]) {
			driverid = hkData[i][hkDesyncVehiclePlayerId];
				
			if (driverid != INVALID_PLAYER_ID && hkData[driverid][hkDesyncVehicleId] == vehicleid) {
				hkData[driverid][hkDesyncVehicleId] = INVALID_VEHICLE_ID;
				hkData[i][hkDesyncVehiclePlayerId] = INVALID_PLAYER_ID;
			}
		}

		if (!hkData[i][hkNewPosIsValid] || (!IsPlayerInVehicle(i, vehicleid) && hkData[i][hkSurfVehicleId] != vehicleid))
			continue;

		hkData[i][hkLastBigTpPosX] =
			hkData[i][hkLastSetPosX] =
			hkData[i][hkLastPosX] = x;

		hkData[i][hkLastBigTpPosY] =
			hkData[i][hkLastSetPosY] =
			hkData[i][hkLastPosY] = y;

		hkData[i][hkLastBigTpPosZ] =
			hkData[i][hkLastSetPosZ] =
			hkData[i][hkLastPosZ] = z;

		hkData[i][hkLastBigTpTime] =
			hkData[i][hkLastSetPosTime] = GetTickCount();

		hkData[i][hkNewPosIsValid] = false;
	}

	hkVehicleIsDesync[vehicleid] = false;

	return DestroyVehicle(vehicleid);
}

#if defined _ALS_DestroyVehicle
	#undef DestroyVehicle
#else
	#define _ALS_DestroyVehicle
#endif

#define DestroyVehicle hkDestroyVehicle


public OnGameModeInit() {
	#if defined hkDEBUG
		print("[hkAntiCheat]: debug mode");
		#if PAWNRAKNET_INCLUDE_VERSION < 140
			printf("[hkAntiCheat]: PawnRakNet version < 140\n\tchecking \"AutoAim\" disabled!");
		#endif
	#endif

	#if defined hkOnCheatDetected
		if (funcidx(#hkOnCheatDetected) != -1)
			hkKickCallback = true;
	#endif

	#if defined hkOnSendWarning
		if (funcidx(#hkOnSendWarning) != -1)
			hkWarningCallback = true;
	#endif

	/*if ((hkDBhandle = db_open("hkAntiCheat.db")) != DB:-1) {
		db_free_result(db_query(hkDBhandle,
			"CREATE TABLE IF NOT EXISTS `hk_ac_settings`\
			(`code` INTEGER NOT NULL DEFAULT '0',\
			`toggle` INTEGER NOT NULL DEFAULT '1')"
		));
	}*/

	for (new hkKickCode:i = hk_NONE; i < hk_MAX_CODE; i++)
		hkGetKickStatus(i, hkAcStatus[i]);

	#if defined hk_OnGameModeInit
		return hk_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit hk_OnGameModeInit
#if defined hk_OnGameModeInit
	forward hk_OnGameModeInit();
#endif


public OnGameModeExit() {
	if (hkDBhandle)
		db_close(hkDBhandle);

	#if defined hk_OnGameModeExit
		return hk_OnGameModeExit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif

#define OnGameModeExit hk_OnGameModeExit
#if defined hk_OnGameModeExit
	forward hk_OnGameModeExit();
#endif


public OnPlayerDisconnect(playerid, reason) {
	new vehicleid = hkData[playerid][hkLastVehicleId];

	if (vehicleid != INVALID_VEHICLE_ID && hkVehicleDriverId[vehicleid] == playerid)
		hkVehicleDriverId[vehicleid] = INVALID_PLAYER_ID;

	#if defined hk_OnPlayerDisconnect
		return hk_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect hk_OnPlayerDisconnect
#if defined hk_OnPlayerDisconnect
	forward hk_OnPlayerDisconnect(playerid, reason);
#endif


public OnVehicleSpawn(vehicleid) {
	if (hkVehicleIsDesync[vehicleid]) {
		new driverid = INVALID_PLAYER_ID;

	#if defined foreach
		foreach(new i : Player) {
	#else
		for (new i = GetPlayerPoolSize(); i >= 0; --i) {
			if (!IsPlayerConnected(i))
				continue;
	#endif
			driverid = hkData[i][hkDesyncVehiclePlayerId];

			if (driverid != INVALID_PLAYER_ID && hkData[driverid][hkDesyncVehicleId] == vehicleid) {
				hkData[driverid][hkDesyncVehicleId] = INVALID_VEHICLE_ID;
				hkData[i][hkDesyncVehiclePlayerId] = INVALID_PLAYER_ID;
			}
		}

		hkVehicleIsDesync[vehicleid] = false;
	}

	#if defined hk_OnVehicleSpawn
		return hk_OnVehicleSpawn(vehicleid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnVehicleSpawn
	#undef OnVehicleSpawn
#else
	#define _ALS_OnVehicleSpawn
#endif

#define OnVehicleSpawn hk_OnVehicleSpawn
#if defined hk_OnVehicleSpawn
	forward hk_OnVehicleSpawn(vehicleid);
#endif


public OnPlayerStateChange(playerid, newstate, oldstate) {
	if (newstate == PLAYER_STATE_WASTED || newstate == PLAYER_STATE_SPAWNED) // на всякий случай проверю ещё и PLAYER_STATE_SPAWNED
		hkData[playerid][hkIsWasted] = true;
	else
		hkData[playerid][hkIsWasted] = false;

	#if defined hk_OnPlayerStateChange
		return hk_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange hk_OnPlayerStateChange
#if defined hk_OnPlayerStateChange
	forward hk_OnPlayerStateChange(playerid, newstate, oldstate);
#endif


public OnIncomingPacket(playerid, packetid, BitStream:bs) {
	if(NEW_ANTICHEAT_ALF == 0) return 1;
	static tick = 0;

	switch(packetid) {
		case 200: { // in car sync
			if(NEW_ANTICHEAT_ALF_CAR == 0) return 1;
			tick = GetTickCount();

			new data[PR_InCarSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadInCarSync(bs, data);

			new vehicleid = data[PR_vehicleId];

			if (vehicleid < 1 || vehicleid >= MAX_VEHICLES)
				return 0;

			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]) ||
				hkIsInvalidValue(data[PR_velocity][0]) || hkIsInvalidValue(data[PR_velocity][1]) || hkIsInvalidValue(data[PR_velocity][2]) ||
				hkIsInvalidValue(data[PR_quaternion][0]) || hkIsInvalidValue(data[PR_quaternion][1]) || hkIsInvalidValue(data[PR_quaternion][2]) ||
				hkIsInvalidValue(data[PR_quaternion][3]))
				return 0;

			if (hkData[playerid][hkLastVehicleId] == INVALID_VEHICLE_ID)
				hkData[playerid][hkLastVehicleId] = vehicleid;

			/*if (hkData[playerid][hkLastPutVehicle] == INVALID_VEHICLE_ID) {
				if ((hkData[playerid][hkLastEnterVehicleId] != vehicleid && hkData[playerid][hkLastEnterVehicleTime] > 2500) ||
					hkData[playerid][hkLastVehicleId] != vehicleid) {

					if (hkKickHandler(playerid, hk_REMOTE_CARHACK))
						return 0;
				}
			}
			else if (hkData[playerid][hkLastPutVehicle] == vehicleid) {
				hkData[playerid][hkLastEnterVehicleId] =
					hkData[playerid][hkLastVehicleId] = vehicleid;
				hkData[playerid][hkLastPutVehicle] = INVALID_VEHICLE_ID;
			}*/

			if (hkData[playerid][hkLastPutVehicle] == vehicleid) {
			hkData[playerid][hkLastEnterVehicleId] =
				hkData[playerid][hkLastVehicleId] = vehicleid;
			hkData[playerid][hkLastPutVehicle] = INVALID_VEHICLE_ID;
			}

			new weaponid = data[PR_weaponId];

			if (!hkIsValidWeapon(weaponid)) {
				if (hkKickHandler(playerid, hk_INVALID_WEAPON))
					return 0;
			}

			if (hkData[playerid][hkRemoveFromVehicle] && tick - hkData[playerid][hkLastRemoveTime] > 3000) {
				if (hkKickHandler(playerid, hk_NOP_REMOVE_FROM_VEHICLE))
					return 0;
			}

			if ((hkData[playerid][hkVehicleSeat] != -1 && hkData[playerid][hkVehicleSeat] != 0) ||
				hkData[playerid][hkPlayerState] == PLAYER_STATE_PASSENGER) {
				
				if (hkKickHandler(playerid, hk_CHANGE_SEAT))
					return 0;
			}

			new model = GetVehicleModel(vehicleid);
				
			// anti carhack
			if (model != 0 && !hkIsUnsupportedVehicle(model) && hkGetDistance1D(hkData[playerid][hkLastVelZ], data[PR_velocity][2]) > 1.6 &&
				data[PR_velocity][2] > 0.0 && data[PR_velocity][2] > hkData[playerid][hkLastVelZ]) {
				
				data[PR_velocity][2] = 0.0;

				BS_SetWriteOffset(bs, 360);
				BS_WriteValue(bs, PR_FLOAT, data[PR_velocity][2]);
			}

			if (weaponid != 0 && weaponid != WEAPON_PARACHUTE && !hkData[playerid][hkIsWasted] &&
				tick - hkData[playerid][hkLastDeathTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 3500) {

				new slot = 65535;

				if ((slot = hkGetWeaponSlot(weaponid)) != 65535) {
					if ((hkWeaponData[playerid][hkWeaponAmmo][slot] < 0 || hkWeaponData[playerid][hkWeaponId][slot] != weaponid) &&
						tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot] > 3500) {

						#if defined hkDEBUG
							printf("[hkAntiCheat]: code: %i incar \\ ammo: %i, hkWeaponId: %i, weaponid: %i, ignore time: %i",
								hkWeaponData[playerid][hkWeaponAmmo][slot], hkWeaponData[playerid][hkWeaponId][slot], weaponid,
								tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot]);
						#endif

						ResetPlayerWeapons(playerid);

						if (hkKickHandler(playerid, hk_DGUN))
							return 0;
					}
				}
			}

			// защита от раздвоения машины
			if (hkData[playerid][hkDesyncVehicleId] == vehicleid)
				hkVehicleIsDesync[vehicleid] = true;

			new driverid = hkData[playerid][hkDesyncVehiclePlayerId];

			if (driverid != INVALID_PLAYER_ID && hkVehicleIsDesync[vehicleid]) {
				if (!IsPlayerStreamedIn(playerid, driverid)) {
					RemovePlayerFromVehicle(playerid);
					SetPlayerPos(playerid, hkData[playerid][hkDesyncPosX], hkData[playerid][hkDesyncPosY], hkData[playerid][hkDesyncPosZ] + 2.0);

					#if defined hkDEBUG
						printf("[hkAntiCheat]: desync vehicle: %i \\ new driver: %i, old driver: %i", vehicleid, driverid, playerid);
					#endif
				}

				hkVehicleIsDesync[vehicleid] = false;
				hkData[driverid][hkDesyncVehicleId] = INVALID_VEHICLE_ID;
				hkData[playerid][hkDesyncVehiclePlayerId] = INVALID_PLAYER_ID;
			}

			if (!hkData[playerid][hkNewPosIsValid] && GetVehicleState(vehicleid) != 1) {
				if (hkGetDistance2D(data[PR_position][0], data[PR_position][1], hkData[playerid][hkLastSetPosX], hkData[playerid][hkLastSetPosY]) < 100.0)
					hkData[playerid][hkNewPosIsValid] = true;
				else if (tick - hkData[playerid][hkLastSetPosTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 5000) {
					SetVehiclePos(vehicleid, hkData[playerid][hkLastSetPosX], hkData[playerid][hkLastSetPosY], hkData[playerid][hkLastSetPosZ]);
					printf("[hkAntiCheat]: playerid: %i veh: %d\\ desync SetVehiclePos", playerid, vehicleid);
					#if defined hkDEBUG
						printf("[hkAntiCheat]: playerid: %i \\ desync SetVehiclePos", playerid);
					#endif
					return 0;
				}
			}
			else {
				if (tick - hkData[playerid][hkLastBigTpTime] > 3800) {
					hkData[playerid][hkLastBigTpPosX] = data[PR_position][0];
					hkData[playerid][hkLastBigTpPosY] = data[PR_position][1];
					hkData[playerid][hkLastBigTpPosZ] = data[PR_position][2];

					hkData[playerid][hkLastBigTpTime] = tick;
				}

				if (tick - hkData[playerid][hkLastSetPosTime] > 2500) {
					if (hkGetDistance2D(data[PR_position][0], data[PR_position][1], hkData[playerid][hkLastBigTpPosX], hkData[playerid][hkLastBigTpPosY]) > 550 ||
						(data[PR_position][2] > hkData[playerid][hkLastBigTpPosZ] && hkGetDistance1D(data[PR_position][2], hkData[playerid][hkLastBigTpPosZ]) > 550)) {
						
						if (hkKickHandler(playerid, hk_BIG_TP))
							return 0;
					}
				}
			}

			/*if (!hkData[playerid][hkIsWasted] && tick - hkData[playerid][hkLastDeathTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 3500 &&
				tick - hkData[playerid][hkLastSetPosTime] > 2500 &&
				hkGetDistance2D(data[PR_position][0], data[PR_position][1], hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY]) > 100.0)
			{
				if (hkKickHandler(playerid, hk_BIG_TP))
					return 0;
			}*/

			hkData[playerid][hkLastPosX] = data[PR_position][0];
			hkData[playerid][hkLastPosY] = data[PR_position][1];
			hkData[playerid][hkLastPosZ] = data[PR_position][2];
			hkData[playerid][hkLastVelX] = data[PR_velocity][0];
			hkData[playerid][hkLastVelY] = data[PR_velocity][1];
			hkData[playerid][hkLastVelZ] = data[PR_velocity][2];
			hkData[playerid][hkLastCurrentWeaponId] = weaponid;
			hkData[playerid][hkPlayerState]	= PLAYER_STATE_DRIVER;
			hkData[playerid][hkLastVehicleId] = data[PR_vehicleId];
			hkData[playerid][hkSurfVehicleId] = INVALID_VEHICLE_ID;
			hkData[playerid][hkVehicleSeat] = 0;
			hkData[playerid][hkSurfDesync] = false;
			hkData[playerid][hkLastPacketTime] = tick;
		}
		case 203: { // aim sync
			tick = GetTickCount();

			new data[PR_AimSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadAimSync(bs, data);

			if (hkIsInvalidValue(data[PR_camFrontVec][0]) || hkIsInvalidValue(data[PR_camFrontVec][1]) || hkIsInvalidValue(data[PR_camFrontVec][2]) ||
				hkIsInvalidValue(data[PR_camPos][0]) || hkIsInvalidValue(data[PR_camPos][1]) || hkIsInvalidValue(data[PR_camPos][2]))
				return 0;

			if (hkIsInvalidValue(data[PR_aimZ])) {
				if (hkKickHandler(playerid, hk_INVALID_AIM_Z))
					return 0;
			}

			if (data[PR_camMode] == 34 || data[PR_camMode] == 45) {	
				if (hkKickHandler(playerid, hk_SHAKING_CAMERA))
					return 0;
			}

			if (hkData[playerid][hkWaitAimSync]) {
				new targetid = hkData[playerid][hkLastTargetId];

				if (targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid) &&
					tick - hkData[playerid][hkLastSetPosTime] > 2500 && tick - hkData[targetid][hkLastPacketTime] < 2500) {

					if (data[PR_camMode] == 53 &&
						hkGetDistance3D(hkData[targetid][hkLastPosX], hkData[targetid][hkLastPosY], hkData[targetid][hkLastPosZ],
							hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY], hkData[playerid][hkLastPosZ]) > 5.0 &&
							
						hkGetDistance3D(hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY], hkData[playerid][hkLastPosZ],
							data[PR_camPos][0], data[PR_camPos][1], data[PR_camPos][2]) > 5.0 &&	
							
						hkGetDistance3D(hkData[targetid][hkLastPosX], hkData[targetid][hkLastPosY], hkData[targetid][hkLastPosZ],
							data[PR_camPos][0], data[PR_camPos][1], data[PR_camPos][2]) < 3.0) {
							
						if (--hkMaxWarnings[playerid][hkAimSyncDamager] <= 0) {
							if (hkKickHandler(playerid, hk_DAMAGER_AIM_SYNC)) // damager
								return 0;
						}
					}
					else hkMaxWarnings[playerid][hkAimSyncDamager] = __hk_default_warnings_value[hkAimSyncDamager];
				}

				hkData[playerid][hkLastCamMode] = data[PR_camMode];
				hkData[playerid][hkWaitAimSync] = false;
			}
		}
		case 206: { // bullet sync
			tick = GetTickCount();

			new data[PR_BulletSync];
	
			BS_IgnoreBits(bs, 8);
			BS_ReadBulletSync(bs, data);

			hkData[playerid][hkAnimIsBad] = false;

			new weaponid = data[PR_weaponId];

			if (!hkIsBulletWeapon(weaponid)) {
				if (hkKickHandler(playerid, hk_INVALID_WEAPON)) // invalid weapon
					return 0;
			}

			new slot = 65535;

			if ((slot = hkGetWeaponSlot(weaponid)) != 65535) {
				if (!hkData[playerid][hkIsWasted] && tick - hkData[playerid][hkLastDeathTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 3500) {
					if (hkWeaponData[playerid][hkWeaponAmmo][slot] <= 0 || hkWeaponData[playerid][hkWeaponId][slot] != weaponid) {
						if (tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot] > 3500) {
							#if defined hkDEBUG
								printf("[hkAntiCheat]: code: %i bullet \\ ammo: %i, hkWeaponId: %i, weaponid: %i, ignore time: %i",
									hkWeaponData[playerid][hkWeaponAmmo][slot], hkWeaponData[playerid][hkWeaponId][slot], weaponid,
									tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot]);
							#endif

							ResetPlayerWeapons(playerid);
						
							if (hkKickHandler(playerid, hk_DGUN))
								return 0;
						}

						return 0;
					}
				}

				if (--hkWeaponData[playerid][hkWeaponAmmo][slot] == 0)
					hkWeaponData[playerid][hkWeaponId][slot] = 0;
			}

			if (tick - hkData[playerid][hkLastPacketTime] > 2500)
				return 0;

			if (hkIsInvalidValue(data[PR_origin][0]) || hkIsInvalidValue(data[PR_origin][1]) || hkIsInvalidValue(data[PR_origin][2]) ||
				hkIsInvalidValue(data[PR_hitPos][0]) || hkIsInvalidValue(data[PR_hitPos][1]) || hkIsInvalidValue(data[PR_hitPos][2]) ||
				hkIsInvalidValue(data[PR_offsets][0]) || hkIsInvalidValue(data[PR_offsets][1]) || hkIsInvalidValue(data[PR_offsets][2]))
				return 0;
			
			if (hkIsSkillfulWeapon(weaponid) && hkData[playerid][hkLastCurrentWeaponId] == weaponid &&
				hkData[playerid][hkPlayerState] == PLAYER_STATE_ONFOOT) {

				if (data[PR_hitType] == BULLET_HIT_TYPE_PLAYER) {
					hkData[playerid][hkLastTargetId] = data[PR_hitId];
					hkData[playerid][hkWaitAimSync] = true;
				}

				if (hkGetPlayerSkillByWeapon(playerid, weaponid) < 999) {
					if (hkData[playerid][hkLastAnim] >= 1160 && hkData[playerid][hkLastAnim] <= 1163)
						hkData[playerid][hkAnimIsBad] = true;
				}
				else
				{
					new Float:dist = hkGetDistance3D(data[PR_offsets][0], data[PR_offsets][1], data[PR_offsets][2],
						hkData[playerid][hkLastBulletOffsetX], hkData[playerid][hkLastBulletOffsetY], hkData[playerid][hkLastBulletOffsetZ]);

					if (_:data[PR_offsets][0] == _:0.000000 || _:data[PR_offsets][1] == _:0.000000 || _:data[PR_offsets][2] == _:0.000000)
						hkMaxWarnings[playerid][hkSpread] = __hk_default_warnings_value[hkSpread];
					else if ((weaponid == WEAPON_M4 || weaponid == WEAPON_AK47 || weaponid == WEAPON_MP5) &&
						hkFloatApprox(dist, 0.0, 0.0009) && hkData[playerid][hkLastCamMode] == 53) {
						
						if (--hkMaxWarnings[playerid][hkSpread] <= 0)
							hkWarningHandler(playerid, "Возможно стрельба без разброса");
					}

					if (data[PR_hitType] == BULLET_HIT_TYPE_PLAYER && tick - hkData[playerid][hkLastHitTime] < 1000) {
						if (hkData[playerid][hkNewPosIsValid] && tick - hkData[playerid][hkLastSetPosTime] > 2500) {
							
							new bool:is_cheat_damager = false;

							if (floatcmp(data[PR_origin][2], hkData[playerid][hkLastPosZ]) == 0) {
								hkWarningHandler(playerid, "Возможно SilentAim / Damager");
								is_cheat_damager = true;
							}

							if ((is_cheat_damager || hkGetDistance1D(data[PR_origin][2], hkData[playerid][hkLastPosZ]) >= 2.0) &&
								data[PR_offsets][0] >= 0.1 && data[PR_offsets][0] <= 0.9 &&
								data[PR_offsets][1] >= 0.1 && data[PR_offsets][1] <= 0.9 &&
								data[PR_offsets][2] >= 0.1 && data[PR_offsets][2] <= 0.9) {
									
								if (--hkMaxWarnings[playerid][hkBulletSyncDamager] <= 0) {
									if (hkKickHandler(playerid, hk_DAMAGER_BULLET_SYNC)) // damager
										return 0;
								}
							}
						}
					} 
					else hkMaxWarnings[playerid][hkBulletSyncDamager] = __hk_default_warnings_value[hkBulletSyncDamager];
				}
			}

			hkData[playerid][hkLastHitTime] = tick;
			hkData[playerid][hkLastCurrentWeaponId] = weaponid;
			hkData[playerid][hkFirstOnFootAfterShot] = true;
		}
		case 207: { // on foot sync
			tick = GetTickCount();

			new data[PR_OnFootSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadOnFootSync(bs, data);

			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]) ||
				hkIsInvalidValue(data[PR_velocity][0]) || hkIsInvalidValue(data[PR_velocity][1]) || hkIsInvalidValue(data[PR_velocity][2]) ||
				hkIsInvalidValue(data[PR_quaternion][0]) || hkIsInvalidValue(data[PR_quaternion][1]) || hkIsInvalidValue(data[PR_quaternion][2]) ||
				hkIsInvalidValue(data[PR_quaternion][3]))
				return 0;

			new weaponid = data[PR_weaponId];
			new old_vehicleid = hkData[playerid][hkLastVehicleId];

			if (old_vehicleid != INVALID_VEHICLE_ID) {
				if (hkVehicleDriverId[old_vehicleid] == playerid)
					hkVehicleDriverId[old_vehicleid] = INVALID_PLAYER_ID;

				if ((hkData[playerid][hkPlayerState] == PLAYER_STATE_DRIVER || hkData[playerid][hkPlayerState] == PLAYER_STATE_PASSENGER) &&
					tick - hkData[playerid][hkLastSetPosTime] > 2500 && tick - hkData[playerid][hkLastSpawnTime] > 5000 &&
					tick - hkData[playerid][hkLastDesyncPosTime] > 2500) {

					new Float:vehx, Float:vehy, Float:vehz;
					GetVehiclePos(old_vehicleid, vehx, vehy, vehz);

					if (hkGetDistance3D(vehx, vehy, vehz, data[PR_position][0], data[PR_position][1], data[PR_position][2]) > 150.0 &&
						hkGetDistance3D(hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY], hkData[playerid][hkLastPosZ],
						data[PR_position][0], data[PR_position][1], data[PR_position][2]) > 150.0) {
						
						if (hkData[playerid][hkVehicleSeat] == 0 || hkData[playerid][hkPlayerState] == PLAYER_STATE_PASSENGER) {
							if (GetVehicleState(old_vehicleid) != 1) {
								SetVehicleToRespawn(old_vehicleid);
							}
						}
							

						if (hkKickHandler(playerid, hk_EXIT_VEHICLE_TP))
							return 0;
					}
				}

				hkData[playerid][hkVehicleSeat] = -1;
				hkData[playerid][hkRemoveFromVehicle] = false;
				hkData[playerid][hkPlayerState]	= PLAYER_STATE_ONFOOT;
				hkData[playerid][hkLastVehicleId] = INVALID_VEHICLE_ID;
				hkData[playerid][hkDesyncVehiclePlayerId] = INVALID_PLAYER_ID;
			}
			else {
				if (!hkData[playerid][hkIsMobile]) {
					if ((floatabs(data[PR_quaternion][1]) > 0.01 && floatabs(data[PR_quaternion][1]) < 0.09) && 
						(floatabs(data[PR_quaternion][2]) > 0.01 && floatabs(data[PR_quaternion][2]) < 0.09) &&
						weaponid != WEAPON_PARACHUTE && data[PR_specialAction] == SPECIAL_ACTION_NONE &&
						data[PR_animationId] != 1130 && data[PR_animationId] != 1132 &&
						tick - hkData[playerid][hkLastSpawnTime] > 5000 && tick - hkData[playerid][hkLastSetPosTime] > 3500 &&
						tick - hkData[playerid][hkLastSurfTime] > 5000) {

						new Float:quat_size = VectorSize(data[PR_quaternion][0], data[PR_quaternion][3], 0.0);
			
						if (hkFloatApprox(VectorSize(data[PR_velocity][0], data[PR_velocity][1], data[PR_velocity][2]), 0.0) ||
							quat_size < 0.999999 || quat_size > 1.000000) {
						
							if (hkKickHandler(playerid, hk_FLY))
								return 0;
						}
					}
				}
			}

			if (hkIsInvalidValue(data[PR_surfingOffsets][0]) ||
				hkIsInvalidValue(data[PR_surfingOffsets][1]) ||
				hkIsInvalidValue(data[PR_surfingOffsets][2])) {

				if (hkKickHandler(playerid, hk_CRASH_INVISIBLE)) // invalid surfing offset (admins crasher / invisible)
					return 0;
			}

			if (!hkIsValidWeapon(weaponid)) {
				if (hkKickHandler(playerid, hk_INVALID_WEAPON))
					return 0;
			}

			if (hkData[playerid][hkFirstOnFootAfterShot]) {
				if (hkData[playerid][hkAnimIsBad] && hkData[playerid][hkLastCurrentWeaponId] == weaponid &&
					(data[PR_animationId] >= 1160 && data[PR_animationId] <= 1163)) {

					if (hkKickHandler(playerid, hk_NO_SKILLS)) // стрельба без скиллов
						return 0;
				}

				hkData[playerid][hkFirstOnFootAfterShot] = false;
			}

			if (weaponid != 0 && weaponid != WEAPON_PARACHUTE && !hkData[playerid][hkIsWasted] &&
				tick - hkData[playerid][hkLastDeathTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 3500) {

				new slot = 65535;

				if ((slot = hkGetWeaponSlot(weaponid)) != 65535) {
					if (tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot] > 3500 && (hkWeaponData[playerid][hkWeaponAmmo][slot] < 0 ||
						(hkWeaponData[playerid][hkWeaponAmmo][slot] > 0 && hkWeaponData[playerid][hkWeaponId][slot] != weaponid))) {

						#if defined hkDEBUG
							printf("[hkAntiCheat]: code: %i onfoot \\ ammo: %i, hkWeaponId: %i, weaponid: %i, ignore time: %i",
								hkWeaponData[playerid][hkWeaponAmmo][slot], hkWeaponData[playerid][hkWeaponId][slot], weaponid,
								tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot]);
						#endif

						ResetPlayerWeapons(playerid);

						if (hkKickHandler(playerid, hk_DGUN))
							return 0;
					}
				}
			}

			if (hkData[playerid][hkLastPutVehicle] != INVALID_VEHICLE_ID && tick - hkData[playerid][hkLastPutTime] > 3000 && GetPlayerCuffedAC(playerid) == 0) {
				if (hkKickHandler(playerid, hk_NOP_PUT_IN_VEHICLE))
					return 0;
			}

			if ((data[PR_animationFlags] == 5892 && (data[PR_animationId] == 1538 || data[PR_animationId] == 1539 || data[PR_animationId] == 1543 ||
				data[PR_animationId] == 1189)) || (data[PR_animationFlags] == 4100 && data[PR_animationId] == 1058)) {
				
				if (hkKickHandler(playerid, hk_FLY_ANIM))
					return 0;
			}

			// invalid surfing
			/*new svehicleid = data[PR_surfingVehicleId];
			hkData[playerid][hkSurfVehicleId] = INVALID_VEHICLE_ID;

			if (svehicleid > 0 && svehicleid != INVALID_VEHICLE_ID) {
				if (svehicleid < MAX_VEHICLES && svehicleid != 1999) {
					new Float:vehx, Float:vehy, Float:vehz;
					new vehicle_exist = GetVehiclePos(svehicleid, vehx, vehy, vehz);

					if (!vehicle_exist || hkGetDistance3D(data[PR_position][0], data[PR_position][1], data[PR_position][2], vehx, vehy, vehz) > 100.0
						|| hkVehicleDriverId[svehicleid] == INVALID_PLAYER_ID) {
						

						BS_SetWriteOffset(bs, 408);
						BS_WriteValue(bs,
							PR_FLOAT, 0.0,
							PR_FLOAT, 0.0,
							PR_FLOAT, 0.0,
							PR_UINT16, 0
						);

						data[PR_surfingVehicleId] =
							svehicleid = INVALID_VEHICLE_ID;
					}
					else {
						hkData[playerid][hkSurfVehicleId] = svehicleid;
						hkData[playerid][hkLastSurfTime] = tick;
					}

					if (svehicleid != INVALID_VEHICLE_ID) {
						new vehicle_driverid = hkVehicleDriverId[svehicleid];

						if (vehicle_exist && vehicle_driverid != INVALID_PLAYER_ID && !hkData[vehicle_driverid][hkSurfDesync] &&
							tick - hkData[vehicle_driverid][hkLastPacketTime] > 2000) {

			

						#if defined foreach
							foreach(new i : Player) {
						#else
							for (new i = GetPlayerPoolSize(); i >= 0; --i) {
								if (!IsPlayerConnected(i))
									continue;
						#endif
								if (IsVehicleStreamedIn(svehicleid, i) && hkVehicleDriverId[svehicleid] != i)
									hkSendSetVehiclePos(i, svehicleid, vehx, vehy, vehz);
							}

							hkData[playerid][hkNewPosIsValid] = false;

							hkData[playerid][hkLastSetPosX] = vehx;
							hkData[playerid][hkLastSetPosY] = vehy;
							hkData[playerid][hkLastSetPosZ] = vehz;
							hkData[playerid][hkLastSetPosTime] = tick;

							hkData[vehicle_driverid][hkSurfDesync] = true;
						}
					}
				}
				else if (svehicleid < MAX_VEHICLES + MAX_OBJECTS && svehicleid != 1999) {
				#if defined Streamer_IsItemVisible
					if (Streamer_IsItemVisible(playerid, STREAMER_TYPE_OBJECT, svehicleid - MAX_VEHICLES))
						hkData[playerid][hkLastSurfTime] = tick;
					else {
						BS_SetWriteOffset(bs, 408);
						BS_WriteValue(bs,
							PR_FLOAT, 0.0,
							PR_FLOAT, 0.0,
							PR_FLOAT, 0.0,
							PR_UINT16, 0
						);

						data[PR_surfingVehicleId] =
							svehicleid = INVALID_VEHICLE_ID;
					}
				#endif
				}
				else {
					if (hkKickHandler(playerid, hk_INVALID_SURFING))
						return 0;
				}
			}*/

			// click warp
			if (data[PR_keys] & KEY_SUBMISSION)
				hkData[playerid][hkLastSubmissionKeyTime] = tick;
			else if (data[PR_keys] & KEY_FIRE && tick - hkData[playerid][hkLastSubmissionKeyTime] < 3500) {
				new Float:max_dist = 100.0;

				if (tick - hkData[playerid][hkLastSetPosTime] > 2500)
					max_dist = tick - hkData[playerid][hkLastSurfTime] > 3500 ? 20.0 : 40.0;

				if (hkGetDistance2D(data[PR_position][0], data[PR_position][1],
					hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY]) >= max_dist) {

					if (hkKickHandler(playerid, hk_CLICK_WARP))
						return 0;
				}
			}

			
			if (!hkData[playerid][hkNewPosIsValid]) 
			{
				if (hkGetDistance2D(data[PR_position][0], data[PR_position][1], hkData[playerid][hkLastSetPosX], hkData[playerid][hkLastSetPosY]) < 100.0)
					hkData[playerid][hkNewPosIsValid] = true;
				else if (tick - hkData[playerid][hkLastSetPosTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 5000) {
					if (tick - hkData[playerid][hkLastSurfTime] > 2500) {
						SetPlayerPos(playerid, hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY], hkData[playerid][hkLastPosZ]);
						#if defined hkDEBUG
							printf("[hkAntiCheat]: playerid: %i \\ desync SetPlayerPos", playerid);
						#endif
						return 0;
					}
				}
			}
			else
			{
				if (tick - hkData[playerid][hkLastBigTpTime] > 3800 ) {
					hkData[playerid][hkLastBigTpPosX] = data[PR_position][0];
					hkData[playerid][hkLastBigTpPosY] = data[PR_position][1];
					hkData[playerid][hkLastBigTpPosZ] = data[PR_position][2];

					hkData[playerid][hkLastBigTpTime] = tick;
				}

				if (tick - hkData[playerid][hkLastSetPosTime] > 2500) {
					new Float:max_dist = tick - hkData[playerid][hkLastSurfTime] > 5000 ? 250 : 350;

					if (hkGetDistance2D(data[PR_position][0], data[PR_position][1], hkData[playerid][hkLastBigTpPosX], hkData[playerid][hkLastBigTpPosY]) > max_dist ||
						(data[PR_position][2] > hkData[playerid][hkLastBigTpPosZ] && hkGetDistance1D(data[PR_position][2], hkData[playerid][hkLastBigTpPosZ]) > max_dist)) {
						
						if (hkKickHandler(playerid, hk_BIG_TP))
							return 0;
					}
				}
			} 

			/*if (!hkData[playerid][hkIsWasted] && tick - hkData[playerid][hkLastDeathTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 3500 &&
				tick - hkData[playerid][hkLastSetPosTime] > 2500 &&
				hkGetDistance2D(data[PR_position][0], data[PR_position][1], hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY]) > 100.0)
			{
				if (hkKickHandler(playerid, hk_BIG_TP))
					return 0;
			}*/

			hkData[playerid][hkLastPosX] = data[PR_position][0];
			hkData[playerid][hkLastPosY] = data[PR_position][1];
			hkData[playerid][hkLastPosZ] = data[PR_position][2];
			hkData[playerid][hkLastAnim] = data[PR_animationId];
			hkData[playerid][hkLastCurrentWeaponId] = weaponid;
			hkData[playerid][hkLastPacketTime] = tick;
		}
		case 209: { // unoccupied sync
			new data[PR_UnoccupiedSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadUnoccupiedSync(bs, data);

			new vehicleid = data[PR_vehicleId];

			if (vehicleid < 1 || vehicleid >= MAX_VEHICLES)
				return 0;
	
			if (hkVehicleDriverId[vehicleid] != INVALID_PLAYER_ID) 
				return 0;

			// invalid sync
			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]) ||
				hkIsInvalidValue(data[PR_velocity][0]) || hkIsInvalidValue(data[PR_velocity][1]) || hkIsInvalidValue(data[PR_velocity][2]) ||
				hkIsInvalidValue(data[PR_roll][0]) || hkIsInvalidValue(data[PR_roll][1]) || hkIsInvalidValue(data[PR_roll][2]) ||
				hkIsInvalidValue(data[PR_direction][0]) || hkIsInvalidValue(data[PR_direction][1]) || hkIsInvalidValue(data[PR_direction][2]) ||
				hkIsInvalidValue(data[PR_angularVelocity][0]) || hkIsInvalidValue(data[PR_angularVelocity][1]) || hkIsInvalidValue(data[PR_angularVelocity][2]) ||
				hkIsInvalidValue(data[PR_angularVelocity][0]) || hkIsInvalidValue(data[PR_angularVelocity][1]) || hkIsInvalidValue(data[PR_angularVelocity][2]))
				return 0;

			new Float:vehx, Float:vehy, Float:vehz;
			GetVehiclePos(vehicleid, vehx, vehy, vehz); 
	
			if (hkGetDistance2D(data[PR_position][0], data[PR_position][1], vehx, vehy) > 100.0)
				return 0;
	
			if (data[PR_position][2] > vehz && hkGetDistance1D(data[PR_position][2], vehz) > 300.0)
				return 0;

			if (floatabs(data[PR_roll][0]) > 10.0 || floatabs(data[PR_roll][1]) > 10.0 || floatabs(data[PR_roll][2]) > 10.0)
				return 0;

			if (floatabs(data[PR_direction][0]) > 10.0 || floatabs(data[PR_direction][1]) > 10.0 || floatabs(data[PR_direction][2]) > 10.0)
				return 0;

			if (data[PR_vehicleHealth] < 0.0)
				return 0;

			new Float:speed = VectorSize(data[PR_velocity][0], data[PR_velocity][1], 0.0);
			new Float:angular_speed = VectorSize(data[PR_angularVelocity][0], data[PR_angularVelocity][1], 0.0);

			if (speed > 0.6 || angular_speed > 0.6 || data[PR_velocity][2] > 0.5 || data[PR_velocity][2] < -2.0 ||
				data[PR_angularVelocity][2] > 0.5 || data[PR_angularVelocity][2] < -2.0)
				return 0;	
		}
		/*case 210: { // trailer sync
			new data[PR_TrailerSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadTrailerSync(bs, data);

			if (data[PR_trailerId] < 1 || data[PR_trailerId] >= MAX_VEHICLES)
				return 0;

			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]) ||
				hkIsInvalidValue(data[PR_velocity][0]) || hkIsInvalidValue(data[PR_velocity][1]) || hkIsInvalidValue(data[PR_velocity][2]) ||
				hkIsInvalidValue(data[PR_angularVelocity][0]) || hkIsInvalidValue(data[PR_angularVelocity][1]) || hkIsInvalidValue(data[PR_angularVelocity][2]) ||
				hkIsInvalidValue(data[PR_quaternion][0]) || hkIsInvalidValue(data[PR_quaternion][1]) || hkIsInvalidValue(data[PR_quaternion][2]) ||
				hkIsInvalidValue(data[PR_quaternion][3]))
				return 0;
		}*/
		case 211: { // passenger sync
			new data[PR_PassengerSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadPassengerSync(bs, data);

			new vehicleid = data[PR_vehicleId];

			if (vehicleid < 1 || vehicleid >= MAX_VEHICLES)
				return 0;

			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]))
				return 0;

			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]))
				return 0;

			new weaponid = data[PR_weaponId];

			if (!hkIsValidWeapon(weaponid)) {
				if (hkKickHandler(playerid, hk_INVALID_WEAPON))
					return 0;
			}

			if (hkData[playerid][hkLastVehicleId] == INVALID_VEHICLE_ID)
				hkData[playerid][hkLastVehicleId] = vehicleid;

			/*if (hkData[playerid][hkLastPutVehicle] == INVALID_VEHICLE_ID) {
				if ((hkData[playerid][hkLastEnterVehicleId] != vehicleid && hkData[playerid][hkLastEnterVehicleTime] > 2500) ||
					hkData[playerid][hkLastVehicleId] != vehicleid) {

					if (hkKickHandler(playerid, hk_REMOTE_CARHACK))
						return 0;
				}
			}
			else if (hkData[playerid][hkLastPutVehicle] == vehicleid) {
				hkData[playerid][hkLastEnterVehicleId] =
					hkData[playerid][hkLastVehicleId] = vehicleid;
				hkData[playerid][hkLastPutVehicle] = INVALID_VEHICLE_ID;
			}*/

			if (hkData[playerid][hkRemoveFromVehicle] && tick - hkData[playerid][hkLastRemoveTime] > 3000) {
				if (hkKickHandler(playerid, hk_NOP_REMOVE_FROM_VEHICLE))
					return 0;
			}
			
			if ((hkData[playerid][hkVehicleSeat] != -1 && hkData[playerid][hkVehicleSeat] != data[PR_seatId]) ||
				hkData[playerid][hkPlayerState] == PLAYER_STATE_DRIVER) {
	
				if (hkKickHandler(playerid, hk_CHANGE_SEAT))
					return 0;
			}

			if (weaponid != 0 && weaponid != WEAPON_PARACHUTE && !hkData[playerid][hkIsWasted] &&
				tick - hkData[playerid][hkLastDeathTime] > 3500 && tick - hkData[playerid][hkLastSpawnTime] > 3500) {

				new slot = 65535;

				if ((slot = hkGetWeaponSlot(weaponid)) != 65535) {
					if ((hkWeaponData[playerid][hkWeaponAmmo][slot] < 0 || hkWeaponData[playerid][hkWeaponId][slot] != weaponid) &&
						tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot] > 3500) {

						#if defined hkDEBUG
							printf("[hkAntiCheat]: code: %i passenger \\ ammo: %i, hkWeaponId: %i, weaponid: %i, ignore time: %i",
								hkWeaponData[playerid][hkWeaponAmmo][slot], hkWeaponData[playerid][hkWeaponId][slot], weaponid,
								tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot]);
						#endif

						ResetPlayerWeapons(playerid);

						if (hkKickHandler(playerid, hk_DGUN))
							return 0;
					}
				}
			}

			if (hkVehicleDriverId[vehicleid] == INVALID_PLAYER_ID) {
				new Float:vehx, Float:vehy, Float:vehz;
				GetVehiclePos(vehicleid, vehx, vehy, vehz);

				if (hkGetDistance2D(data[PR_position][0], data[PR_position][1], vehx, vehy) > 200.0)
					return 0;

				if (data[PR_position][2] > vehz && hkGetDistance1D(data[PR_position][2], vehz) > 300.0)
					return 0;
			}

			hkData[playerid][hkLastPosX] = data[PR_position][0];
			hkData[playerid][hkLastPosY] = data[PR_position][1];
			hkData[playerid][hkLastPosZ] = data[PR_position][2];
			hkData[playerid][hkLastVehicleId] = data[PR_vehicleId];
			hkData[playerid][hkVehicleSeat] = data[PR_seatId];
			hkData[playerid][hkLastCurrentWeaponId] = weaponid;
			hkData[playerid][hkPlayerState]	= PLAYER_STATE_PASSENGER;
			hkData[playerid][hkLastPacketTime] = tick;
		}
		case 212: { // spectating sync
			new data[PR_SpectatingSync];

			BS_IgnoreBits(bs, 8);
			BS_ReadSpectatingSync(bs, data);

			if (hkIsInvalidValue(data[PR_position][0]) || hkIsInvalidValue(data[PR_position][1]) || hkIsInvalidValue(data[PR_position][2]))
				return 0;

			if (!hkData[playerid][hkIsSpectating] && tick - hkData[playerid][hkLastSpectatingTime] > 3500) {
				if (hkKickHandler(playerid, hk_SPECTATING_WO_ACCESS))
					return 0;
			}
		}
	}

	#if defined hk_OnIncomingPacket
		return hk_OnIncomingPacket(playerid, packetid, BitStream:bs);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnIncomingPacket
	#undef OnIncomingPacket
#else
	#define _ALS_OnIncomingPacket
#endif

#define OnIncomingPacket hk_OnIncomingPacket
#if defined hk_OnIncomingPacket
	forward hk_OnIncomingPacket(playerid, packetid, BitStream:bs);
#endif


#if PAWNRAKNET_INCLUDE_VERSION >= 140
	public OnIncomingRawPacket(playerid, packetid, BitStream:bs) {
		if (packetid == 221) { // packet rpc
			new bytes, rpcid;

			BS_GetNumberOfBytesUsed(bs, bytes);
		
			if(bytes < 3)
				return 0;

			BS_ReadValue(bs, 
				PR_IGNORE_BITS, 8,
				PR_UINT8, rpcid
			);

			if(rpcid == 0x10) { // custom mobile rpc
				new autoaim;

				BS_ReadValue(bs,
					PR_UINT8, autoaim
				);

				if (autoaim != 0) {
					SendClientMessage(playerid, -1, " Отключите AutoAim в настройках мобильного клиента!");

					if (hkKickHandler(playerid, hk_USE_AUTOAIM))
						return 0;
				}

				hkData[playerid][hkIsMobile] = true;
			}
		}

		#if defined hk_OnIncomingRawPacket
			return hk_OnIncomingRawPacket(playerid, packetid, BitStream:bs);
		#else
			return 1;
		#endif
	}

	#if defined _ALS_OnIncomingRawPacket
		#undef OnIncomingRawPacket
	#else
		#define _ALS_OnIncomingRawPacket
	#endif

	#define OnIncomingRawPacket hk_OnIncomingRawPacket
	#if defined hk_OnIncomingRawPacket
		forward hk_OnIncomingRawPacket(playerid, packetid, BitStream:bs);
	#endif
#endif


public OnOutcomingRPC(playerid, rpcid, BitStream:bs) {
	if(NEW_ANTICHEAT_ALF == 0) return 1;
	if(!(0 <= playerid < MAX_PLAYERS) || IsPlayerKicked(playerid)) return 0;
	static tick = 0;

	switch(rpcid) {
		case 12, 13: { // SetPlayerPos, SetPlayerPosFindZ
			tick = GetTickCount();

			new Float:x, Float:y, Float:z;

			BS_ReadValue(bs,
				PR_FLOAT, x,
				PR_FLOAT, y,
				PR_FLOAT, z
			);

			hkData[playerid][hkLastBigTpPosX] =
				hkData[playerid][hkLastSetPosX] =
				hkData[playerid][hkLastPosX] = x;

			hkData[playerid][hkLastBigTpPosY] =
				hkData[playerid][hkLastSetPosY] =
				hkData[playerid][hkLastPosY] = y;

			hkData[playerid][hkLastBigTpPosZ] =
				hkData[playerid][hkLastSetPosZ] =
				hkData[playerid][hkLastPosZ] = z;

			hkData[playerid][hkLastBigTpTime] =
				hkData[playerid][hkLastSetPosTime] = tick;

			hkData[playerid][hkNewPosIsValid] = false;
		}
		case 21: { // ResetPlayerWeapons
			tick = GetTickCount();

			for (new i = 0; i < 13; i++) {
				hkWeaponData[playerid][hkWeaponId][i] =
					hkWeaponData[playerid][hkIgnoreWeaponTime][i] = tick;
				
				hkWeaponData[playerid][hkWeaponAmmo][i] = -1;
			}
		}
		case 22: { // GivePlayerWeapon
			tick = GetTickCount();

			new weaponid, ammo;

			BS_ReadValue(bs,
				PR_UINT32, weaponid,
				PR_UINT32, ammo
			);

			new slot = 65535;

			if ((slot = hkGetWeaponSlot(weaponid)) == 65535)
				return 0;

			if (hkWeaponData[playerid][hkWeaponAmmo][slot] < 0)
				hkWeaponData[playerid][hkWeaponAmmo][slot] = 0;

			hkWeaponData[playerid][hkWeaponId][slot] = weaponid;
			hkWeaponData[playerid][hkWeaponAmmo][slot] += ammo;
			hkWeaponData[playerid][hkIgnoreWeaponTime][slot] = tick;
		}
		case 34: { // SetPlayerSkillLevel
			new pid;
			BS_ReadUint16(bs, pid);

			if (pid == playerid) {
				new skill, level;

				BS_ReadValue(bs,
					PR_UINT32, skill,
					PR_UINT16, level
				);

				hkPlayerSkill[pid][skill] = level;
			}
		}
		case 70: { // PutPlayerInVehicle
			tick = GetTickCount();

			new vehicleid, seatid;

			BS_ReadValue(bs,
				PR_UINT16, vehicleid,
				PR_UINT8, seatid
			);

			if (vehicleid != hkData[playerid][hkLastVehicleId] && hkData[playerid][hkLastPutVehicle] == INVALID_VEHICLE_ID) {
				hkData[playerid][hkLastPutVehicle] = vehicleid;
				hkData[playerid][hkLastPutTime] = tick;
			}

			hkData[playerid][hkVehicleSeat] = seatid;
			hkData[playerid][hkLastEnterVehicleId] = vehicleid;

			new Float:x, Float:y, Float:z;
			new vehicle_exist = GetVehiclePos(vehicleid, x, y, z);

			if (vehicle_exist) {
				hkData[playerid][hkLastBigTpPosX] =
					hkData[playerid][hkLastSetPosX] =
					hkData[playerid][hkLastPosX] = x;

				hkData[playerid][hkLastBigTpPosY] =
					hkData[playerid][hkLastSetPosY] =
					hkData[playerid][hkLastPosY] = y;

				hkData[playerid][hkLastBigTpPosZ] =
					hkData[playerid][hkLastSetPosZ] =
					hkData[playerid][hkLastPosZ] = z;

				hkData[playerid][hkLastBigTpTime] =
					hkData[playerid][hkLastSetPosTime] = tick;

				hkData[playerid][hkNewPosIsValid] = false;
			}
		}
		case 71: { // RemovePlayerFromVehicle
			tick = GetTickCount();

			if ((hkData[playerid][hkPlayerState] == PLAYER_STATE_DRIVER || hkData[playerid][hkPlayerState] == PLAYER_STATE_PASSENGER) &&
				hkData[playerid][hkLastVehicleId] != INVALID_VEHICLE_ID) {
				
				hkData[playerid][hkRemoveFromVehicle] = true;
				hkData[playerid][hkLastRemoveTime] = tick;
			}
		}
		case 124: { // TogglePlayerSpectating
			tick = GetTickCount();

			new spectating;

			BS_ReadValue(bs,
				PR_UINT32, spectating
			);

			hkData[playerid][hkIsSpectating] = spectating >= 1 ? true : false;
			hkData[playerid][hkLastSpectatingTime] = tick;
		}
		case 145: { // SetPlayerAmmo
			tick = GetTickCount();

			new weaponid, ammo;

			BS_ReadValue(bs,
				PR_UINT8, weaponid,
				PR_UINT16, ammo
			);

			new slot = 65535;

			if ((slot = hkGetWeaponSlot(weaponid)) == 65535)
				return 0;

			if (ammo < 0)
				ammo = 0;

			/*if (hkWeaponData[playerid][hkWeaponAmmo][slot] == 0)
				return 0;
			else if (hkWeaponData[playerid][hkWeaponAmmo][slot] < 0) {
				hkWeaponData[playerid][hkWeaponId][slot] =
					hkWeaponData[playerid][hkWeaponAmmo][slot] =
					hkWeaponData[playerid][hkIgnoreWeaponTime][slot] = 0;
				return 0;
			}*/

			hkWeaponData[playerid][hkWeaponId][slot] = weaponid;
			hkWeaponData[playerid][hkWeaponAmmo][slot] = ammo;
			hkWeaponData[playerid][hkIgnoreWeaponTime][slot] = tick;
		}
		case 159: { // SetVehiclePos
			tick = GetTickCount();

			new vehicleid;
			new Float:x, Float:y, Float:z;

			BS_ReadValue(bs,
				PR_UINT16, vehicleid,
				PR_FLOAT, x,
				PR_FLOAT, y,
				PR_FLOAT, z
			);

		#if defined foreach
			foreach(new i : Player) {
		#else
			for (new i = GetPlayerPoolSize(); i >= 0; --i) {
				if (!IsPlayerConnected(i))
					continue;
		#endif
				if (hkData[i][hkLastVehicleId] != vehicleid && hkData[i][hkSurfVehicleId] != vehicleid)
					continue;

				hkData[i][hkLastBigTpPosX] =
					hkData[i][hkLastSetPosX] =
					hkData[i][hkLastPosX] = x;

				hkData[i][hkLastBigTpPosY] =
					hkData[i][hkLastSetPosY] =
					hkData[i][hkLastPosY] = y;

				hkData[i][hkLastBigTpPosZ] =
					hkData[i][hkLastSetPosZ] =
					hkData[i][hkLastPosZ] = z;

				hkData[i][hkLastBigTpTime] =
					hkData[i][hkLastSetPosTime] = tick;

				hkData[i][hkNewPosIsValid] = false;
			}
		}
	}	

	#if defined hk_OnOutcomingRPC
		return hk_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnOutcomingRPC
	#undef OnOutcomingRPC
#else
	#define _ALS_OnOutcomingRPC
#endif

#define OnOutcomingRPC hk_OnOutcomingRPC
#if defined hk_OnOutcomingRPC
	forward hk_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
#endif


public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
	static tick = 0;

	switch(rpcid) {
		case 25: { // ClientJoin
			hkData[playerid][hkVehicleSeat] = -1;

			hkLastWarningTime[playerid] =
				hkData[playerid][hkLastSetPosTime] =
				hkData[playerid][hkLastHitTime] =
				hkData[playerid][hkLastSubmissionKeyTime] =
				hkData[playerid][hkLastSurfTime] =
				hkData[playerid][hkLastPacketTime] =
				hkData[playerid][hkLastCurrentWeaponId] =
				hkData[playerid][hkLastAnim] =
				hkData[playerid][hkLastRemoveTime] =
				hkData[playerid][hkLastPutTime] =
				hkData[playerid][hkLastDesyncPosTime] =
				hkData[playerid][hkLastSpawnTime] =
				hkData[playerid][hkLastBigTpTime] =
				hkData[playerid][hkLastSpectatingTime] =
				hkData[playerid][hkLastEnterVehicleTime] =
				hkData[playerid][hkLastDeathTime] =
				hkData[playerid][hkLastCamMode] = 0;

			hkIsKicked[playerid] =
				hkData[playerid][hkAnimIsBad] =
				hkData[playerid][hkFirstOnFootAfterShot] =
				hkData[playerid][hkWaitAimSync] =
				hkData[playerid][hkRemoveFromVehicle] =
				hkData[playerid][hkNewPosIsValid] =
				hkData[playerid][hkIsSpectating] =
				hkData[playerid][hkSurfDesync] =
				hkData[playerid][hkIsWasted] = false;

			hkData[playerid][hkLastVehicleId] =
				hkData[playerid][hkSurfVehicleId] =
				hkData[playerid][hkDesyncVehicleId] =
				hkData[playerid][hkLastPutVehicle] =
				hkData[playerid][hkLastEnterVehicleId] = INVALID_VEHICLE_ID;

			hkData[playerid][hkLastTargetId] =
				hkData[playerid][hkDesyncVehiclePlayerId] = INVALID_PLAYER_ID;

			hkData[playerid][hkPlayerState] = PLAYER_STATE_ONFOOT;
			hkMaxWarnings[playerid] = __hk_default_warnings_value;

			for (new i = 0; i < 13; i++) {
				hkWeaponData[playerid][hkWeaponId][i] =
					hkWeaponData[playerid][hkIgnoreWeaponTime][i] = 0;

				hkWeaponData[playerid][hkWeaponAmmo][i] = -1;
			}

			for (new i = 0; i < sizeof(hkPlayerSkill[]); i++)
				hkPlayerSkill[playerid][i] = 999;

			new gpciStr[64];
			gpci(playerid, gpciStr, sizeof(gpciStr));

    		if(!strcmp(gpciStr, "ED40ED0E8089CC44C08EE9580F4C8C44EE8EE990"))
				hkData[playerid][hkIsMobile] = true;
			else
				hkData[playerid][hkIsMobile] = false;
		}
		case 26: { // EnterVehicle
			tick = GetTickCount();

			new vehicleid, isPassenger;

			BS_ReadValue(bs,
				PR_UINT16, vehicleid,
				PR_UINT8, isPassenger
			);

			if (vehicleid < 1 || vehicleid >= MAX_VEHICLES)
				return 0;

			new Float:vehx, Float:vehy, Float:vehz;
			new is_exist = GetVehiclePos(vehicleid, vehx, vehy, vehz);

			if (!is_exist)
				return 0;

			if (hkGetDistance2D(vehx, vehy, hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY]) > 60.0) {
				hkSendSetVehiclePos(playerid, vehicleid, vehx, vehy, vehz);
				SetPlayerPos(playerid, hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY], hkData[playerid][hkLastPosZ] + 2.0);
				return 0;
			}

			if (!isPassenger) {
				new driverid = hkVehicleDriverId[vehicleid];

				if (driverid != INVALID_PLAYER_ID && hkData[driverid][hkPlayerState] == PLAYER_STATE_DRIVER &&
					tick - hkData[driverid][hkLastPacketTime] > 2500 && (IsPlayerInVehicle(driverid, vehicleid) ||
					hkData[driverid][hkLastVehicleId] == vehicleid)) {

					hkData[driverid][hkDesyncPosX] = vehx;
					hkData[driverid][hkDesyncPosY] = vehy;
					hkData[driverid][hkDesyncPosZ] = vehz;
					hkData[driverid][hkDesyncVehiclePlayerId] = playerid;

					hkData[playerid][hkDesyncVehicleId] = vehicleid;
				}
				else if(hkVehicleDriverId[vehicleid] == INVALID_PLAYER_ID)
				{
					hkVehicleDriverId[vehicleid] = playerid;
				}
				/*if (!GetPlayerUseCar(playerid, vehicleid, true))
				{
					TogglePlayerControllable(playerid, 0);
					ClearAnimations(playerid);
					TogglePlayerControllable(playerid, 1);
					SetVehicleParamsForPlayer(vehicleid, playerid, 0, 1);
					SetTimerEx("ChangeStatusVehicle", 3200,false, "ii", playerid, vehicleid);
					return 0;
				}*/
			}
			/*else if (PlayerCuffed[playerid] > 0) {
				TogglePlayerControllable(playerid, 0);
				ClearAnimations(playerid);
				TogglePlayerControllable(playerid, 1);
				return 0;
			}*/

			hkData[playerid][hkLastEnterVehicleId] = vehicleid;
			hkData[playerid][hkLastEnterVehicleTime] = tick;
		}
		case 52: { // SendSpawn
			tick = GetTickCount();
			hkData[playerid][hkLastSpawnTime] = tick;
		}
		case 53: { // SendDeathNotification
			tick = GetTickCount();
			hkData[playerid][hkLastDeathTime] = tick;
		}
		case 115: { // GiveTakeDamage
			new pid, weaponid, bodypart;
			new Float:damage;
			new bool:give_or_take;

			BS_ReadValue(bs,
				PR_BOOL, give_or_take,
				PR_UINT16, pid,
				PR_FLOAT, damage,
				PR_UINT32, weaponid,
				PR_UINT32, bodypart
			);

			if (pid < 0 || pid >= MAX_PLAYERS)
				return 0;

			if (pid == playerid)
				return 0;

			if (!give_or_take) {
				if (!IsPlayerStreamedIn(playerid, pid)) {
					//if (hkKickHandler(playerid, hk_RPC_DAMAGE_1)) // тут можно и без кика, просто блочим дамаг
					return 0;
				}

				new slot = 65535;

				if ((slot = hkGetWeaponSlot(weaponid)) == 65535)
					return 0;

				switch(slot) {
					case 0, 1, 10: {
						// не отправлять урон кулаком, ножами, etc... если игрок далеко
						if (hkGetDistance3D(hkData[playerid][hkLastPosX], hkData[playerid][hkLastPosY], hkData[playerid][hkLastPosZ],
							hkData[pid][hkLastPosX], hkData[pid][hkLastPosY], hkData[pid][hkLastPosZ]) > 5.5)
							return 0;
					}
				}

				if (hkIsBulletWeapon(weaponid)) {
					if (hkWeaponData[playerid][hkWeaponAmmo][slot] <= 0 && tick - hkWeaponData[playerid][hkIgnoreWeaponTime][slot] > 2500)
						return 0;
				}
			}
			else {
				if (!IsPlayerStreamedIn(playerid, pid))
					return 0;

				// 50 - helicopter blades
				if (weaponid == WEAPON_VEHICLE || weaponid == 50) {
					new vehicleid = GetPlayerVehicleID(pid);

					if (!IsValidVehicle(vehicleid))
						return 0;

					if (GetPlayerVehicleSeat(pid) != 0)
						return 0;
				}
			}
		}
		case 154: { // ExitVehicle
			new vehicleid;

			BS_ReadValue(bs,
				PR_UINT16, vehicleid
			);

			if (vehicleid < 1 || vehicleid >= MAX_VEHICLES)
				return 0;

			if (hkData[playerid][hkLastVehicleId] == vehicleid && hkVehicleDriverId[vehicleid] == playerid)
				hkVehicleDriverId[vehicleid] = INVALID_PLAYER_ID;

			hkData[playerid][hkLastEnterVehicleId] = INVALID_VEHICLE_ID;
		}
	}

	#if defined hk_OnIncomingRPC
		return hk_OnIncomingRPC(playerid, rpcid, BitStream:bs);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnIncomingRPC
	#undef OnIncomingRPC
#else
	#define _ALS_OnIncomingRPC
#endif

#define OnIncomingRPC hk_OnIncomingRPC
#if defined hk_OnIncomingRPC
	forward hk_OnIncomingRPC(playerid, rpcid, BitStream:bs);
#endif


stock hkKickHandler(playerid, hkKickCode:code) {
	if (!IsPlayerConnected(playerid) || hkIsKicked[playerid])
		return 0;

	new bool:status = false;
	hkGetKickStatus(code, status, true);

	if (!status)
		return 0;

	if (!hkAcStatus[code]) {
		#if defined hkDEBUG
			printf("[hkAntiCheat]: detected code: %i, playerid: %i, anticheat status: %s",
				_:code, playerid, hkAcStatus ? "enabled" : "disabled");
		#endif
		return 0;
	}
	
	#if defined hkOnCheatDetected
		if (hkKickCallback)
			return (hkIsKicked[playerid] = CallLocalFunction(#hkOnCheatDetected, "ii", playerid, code) ? true : false);
	#endif

	new buffer[144];
	format(buffer, sizeof(buffer), " Вы были кикнуты по подозрению в читерстве. (#hk-%i)", code);
	SendClientMessage(playerid, hkKICK_COLOR, buffer);

	SetTimerEx(#hkKick, 250, false, "ii", playerid, code);

	hkIsKicked[playerid] = true;

	return 1;
}

stock hkWarningHandler(playerid, const message[], time = 8500) {
	new tick = GetTickCount();

	if (tick - hkLastWarningTime[playerid] > time) {
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));

		new buffer[144];
		format(buffer, sizeof(buffer), " [hkAntiCheat]: %s(%i) %s", name, playerid, message);

		#if defined hkOnSendWarning
			if (hkWarningCallback)
				CallLocalFunction(#hkOnSendWarning, "is", playerid, buffer);
		#endif

		#if defined hkDEBUG
			printf("[hkAntiCheat]: %s", buffer);
		#endif

		hkLastWarningTime[playerid] = tick;
	}
}

stock hkToggleAntiCheat(playerid, hkKickCode:code, bool:status) {
    if (code <= hk_NONE || code >= hk_MAX_CODE)
        return;
 
    new buffer[128];
	/*format(buffer, sizeof buffer, "SELECT `toggle` FROM `hk_ac_settings` WHERE `code` = %i", _:code);
    new Cache: result = mysql_query(dbHandle, buffer), rows; 
    cache_get_row_count(rows);
    if (!rows) {
		format(buffer, sizeof(buffer), "UPDATE `hk_ac_settings` SET `toggle` = %i", _:status);
		mysql_query(dbHandle, buffer);
        
        //return 1;
    } else {
		format(buffer, sizeof(buffer), "INSERT INTO `hk_ac_settings` (`code`, `toggle`) VALUES (%i, %i)", _:code, _:status);
		mysql_query(dbHandle, buffer);
	}
	if (cache_is_valid(result)) cache_delete(result);
*/

    if (hkDBhandle) {
        format(buffer, sizeof(buffer), "SELECT `toggle` FROM `hk_ac_settings` WHERE `code` = %i", _:code);
    
        new DBResult:result = db_query(hkDBhandle, buffer);
 
        if (db_num_rows(result) > 0) {
            if (db_get_field_assoc_int(result, "toggle") != _:status) {
                format(buffer, sizeof(buffer), "UPDATE `hk_ac_settings` SET `toggle` = %i", _:status);
                db_free_result(db_query(hkDBhandle, buffer));
            }
        }
        else {
            format(buffer, sizeof(buffer), "INSERT INTO `hk_ac_settings` (`code`, `toggle`) VALUES (%i, %i)", _:code, _:status);
            db_free_result(db_query(hkDBhandle, buffer));
        }
 
        db_free_result(result);
    }
 
    hkAcStatus[code] = status;
 
    format(buffer, sizeof(buffer), " [hkAntiCheat]: code: %i, status: %i", _:code, _:status);
    SendClientMessage(playerid, -1, buffer);
 
    #if defined hkDEBUG
        printf(buffer);
    #endif
}

stock hkGetKickStatus(hkKickCode:code, &bool:status, bool:cache = false) {
	if (code <= hk_NONE || code >= hk_MAX_CODE)
		return;

	if (cache) {
		status = hkAcStatus[code];
		return;
	}

	if (hkDBhandle) {
		new buffer[128];
		format(buffer, sizeof(buffer), "SELECT `toggle` FROM `hk_ac_settings` WHERE `code` = %i", _:code);
	
		new DBResult:result = db_query(hkDBhandle, buffer);

		if (db_num_rows(result) > 0)
			status = bool:db_get_field_assoc_int(result, "toggle");
		else
			status = true;

		db_free_result(result);
		return;
	}

	status = true;
}

forward hkKick(playerid, hkKickCode:code);
public hkKick(playerid, hkKickCode:code) {
	#if defined hkDEBUG
		printf("[hkAntiCheat]: playerid: %i has been kicked! code: %i", playerid, _:code);
	#endif
	#pragma unused code
	return Kick(playerid);
}

static stock hkGetSkillIdByWeapon(weaponid) {
	switch (weaponid) {
		case WEAPON_M4:	return WEAPONSKILL_M4;
		case WEAPON_MP5: return WEAPONSKILL_MP5;
		case WEAPON_AK47: return WEAPONSKILL_AK47;
		case WEAPON_COLT45: return WEAPONSKILL_PISTOL;
		case WEAPON_SHOTGUN: return WEAPONSKILL_SHOTGUN;
		case WEAPON_DEAGLE: return WEAPONSKILL_DESERT_EAGLE;
		case WEAPON_SHOTGSPA: return WEAPONSKILL_SPAS12_SHOTGUN;
		case WEAPON_SAWEDOFF: return WEAPONSKILL_SAWNOFF_SHOTGUN;
		case WEAPON_SILENCED: return WEAPONSKILL_PISTOL_SILENCED;
		case WEAPON_UZI, WEAPON_TEC9: return WEAPONSKILL_MICRO_UZI;
		case WEAPON_RIFLE, WEAPON_SNIPER: return WEAPONSKILL_SNIPERRIFLE;
	}

	return WEAPONSKILL_PISTOL;
}

static stock hkGetPlayerSkillLevel(playerid, skill) {
	if (skill < 0 || skill >= sizeof(hkPlayerSkill[]))
		return 0;

	return hkPlayerSkill[playerid][skill];
}

static stock hkIsValidWeapon(weaponid) {
	if (weaponid == 19 || weaponid == 20 || weaponid == 21 || weaponid == 44 || weaponid == 45)
		return false;

	return (0 <= weaponid <= WEAPON_PARACHUTE);
}

static stock hkGetWeaponSlot(weaponid) {
	switch(weaponid) {
		case 0, 1: return 0;
		case 2..9: return 1;
		case 22..24: return 2;
		case 25..27: return 3;
		case 28, 29, 32: return 4;
		case 30, 31: return 5;
		case 33, 34: return 6;
		case 35..38: return 7;
		case 16..18, 39: return 8;
		case 41..43: return 9;
		case 10..15: return 10;
		case 44..46: return 11;
		case 40: return 12;
	}

	return 65535; // invalid
}

static stock hkIsUnsupportedVehicle(model) {
	switch(model) {
		case 460, 476, 511..513, 519, 520, 553, 577, 592, 593,
			417, 425, 447, 469, 487, 488, 497, 548, 563:
			return true;
	}

	return false;
}

static stock hkSendSetVehiclePos(playerid, vehicleid, Float:x, Float:y, Float:z) {
	new BitStream:bs = BS_New();

	BS_WriteValue(bs,
		PR_UINT16, vehicleid,
		PR_FLOAT, x,
		PR_FLOAT, y,
		PR_FLOAT, z
	);

	#if defined PR_SendRPC
		PR_SendRPC(bs, playerid, 159); // SetVehiclePos
	#else
		BS_RPC(bs, playerid, 159); // SetVehiclePos
	#endif
	BS_Delete(bs);
}

static stock hkFloatApprox(Float:a, Float:b, Float:approx = 0.0001) {
	new Float:c = a - b;

	c = (c < 0.0) ? -c : c;

	return (c < approx);
}

static stock Float:hkGetDistance3D(Float:x, Float:y, Float:z, Float:fx, Float:fy, Float:fz)
	return VectorSize(fx - x, fy - y, fz - z);

static stock Float:hkGetDistance2D(Float:x, Float:y, Float:fx, Float:fy)
	return VectorSize(fx - x, fy - y, 0.0);

static stock Float:hkGetDistance1D(Float:x, Float:fx)
	return VectorSize(fx - x, 0.0, 0.0);

static stock hkIsNaN(Float:value)
	return floatcmp(value, value) != 0;

static stock hkIsInfinity(Float:value)
	return (floatcmp(value, Float:0x7F800000) == 0 || floatcmp(value, Float:0xFF800000) == 0);


stock hkAntiCheatGetPos(playerid, &Float:x, &Float:y, &Float:z)
{
	if(!IsPlayerConnected(playerid)) return 0;
	x = hkData[playerid][hkLastPosX];
	y = hkData[playerid][hkLastPosY];
	z = hkData[playerid][hkLastPosZ];
	return 1;
}