#if defined _ac_ser_inc
	#endinput
#endif

#define _ac_ser_inc

/*

 КОДЫ АНТИЧИТОВ

 aac-1  == Быстрый телепорт в авто
 aac-2 == игрок сел в авто уже находясь в авто / невалидное место пассажирское
 aac-3  == игрок в наблюдении без разрешения
// телепорт
aac-4 == максимальная разрешенная дистанция по координате Z
aac-5 ==  максимальная разрешенная дистанция по координате X,Y
aac-6 == резкий набор скорости / скорость больше допустимой
aac-7 == минимальная дистанция телепорта на которую античит закроет глаза
aac-8 == сел в авто в который нельзя сесть ( закрытый / не  доступен)
aac-9 == телепорт в интерьер
aac-10 == невидимка через objectid  ( Shadow Blade )

*/

new GetWeaponSlot[] = 
{
   0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10,
   10, 8, 8, 8, 0, 0, 0, 2, 2, 2, 3, 3, 3, 4, 4, 5,
   5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11
};

new Text:CheatShow[10];

new debug_ac = 0;

CMD:testac(playerid)
{
	debug_ac = !debug_ac;// == 0  ?  1 : 0;
	if (debug_ac)
		SendClientMessage(playerid,-1,"debug_ac - on");
	else SendClientMessage(playerid,-1,"debug_ac - off");
}

enum ac_settings_ser_
{
	acResultZ,
	acResultDist,
	acResultSpeed,
	acResultDist2,
	acResultAir,
	acDistCount,
	Float:acDistKick,
	Float:acDistZKick,
	Float:acStartCheck,
	Float:acAirBreak,
	Float:acAirBreak2,
	acTimeTPCar,
	acTPCar,
	acChangeCar,
	acInt
}

new AcSettings[ac_settings_ser_];

enum  ac_ser_tmp
{
	acSetPos,
	Float:acPosX,
	Float:acPosY,
	Float:acPosZ,
	acDistCount,
	acVehicleID,
	acVehicleSeat,
	acTPVehicle,
	Float:acPosDiff,
	Float:acSpeed,
	acSpectate,
	acSpectateTick,
	acEnterVehicleID,
	acSetInt,
	acInt,
	PlayerDeath,
	PlayerKicked,
	acFloodEnterCar,
	acNonLogin,
	acInvis
}

new AC_Info[MAX_PLAYERS][ac_ser_tmp];

new bool: CRASH[MAX_PLAYERS];


#if defined _INC_WEAPON_CONFIG

stock IsPlayerDeath(playerid)
{
	if (0 <= playerid < MAX_PLAYERS) {
		return IsPlayerDying(playerid);
	}

	return false;
}

#else

stock IsPlayerDeath(playerid)
{
	if (0 <= playerid < MAX_PLAYERS) {
		return AC_Info[playerid][PlayerDeath];
	}

	return false;
}

#endif

stock IsPlayerAFK(playerid) 
{
	if (0 <= playerid < MAX_PLAYERS) {
		return pTemp[playerid][PlayerAFK];
	}

	return false;
}

stock IsPlayerKicked(playerid)
{
	if (0 <= playerid < MAX_PLAYERS) {
		return AC_Info[playerid][PlayerKicked];
	}

	return false;
}

#define KickEx(%1);     AC_Info[%1][PlayerKicked] = 1;\
						SetTimerEx("KickPublic",500,false,"i",%1);

publics:KickPublic(const playerid) return Kick(playerid);

#define  MAX_PASSENGER  12

stock GetPlayerAdmin(playerid)
{
	if (0 <= playerid < MAX_PLAYERS) {
		return pInfo[playerid][pAdmin];
	}
	return false;
}


stock TogglePlayerSpectatingEx(playerid, toggle)
{
	AC_Info[playerid][acSpectate] = toggle;
	AC_Info[playerid][acSpectateTick] = GetTickCount()+2000;
	return TogglePlayerSpectating(playerid, toggle);
}

#if defined _ALS_TogglePlayerSpectating
	#undef TogglePlayerSpectating
#else
	#define _ALS_TogglePlayerSpectating
#endif

#define TogglePlayerSpectating TogglePlayerSpectatingEx


stock SetPlayerInteriorEx(playerid,interiorid)
{
	if (!SetPlayerInterior(playerid, interiorid)) return 0;
    AC_Info[playerid][acSetInt] = interiorid % 256;

	//printf("SetPlayerInteriorEx %d", AC_Info[playerid][acSetInt]);

	if ( GetPlayerState(playerid) == PLAYER_STATE_WASTED){
		AC_Info[playerid][PlayerDeath] = 1;
	}
    return 1;
}

#if    defined    _ALS_SetPlayerInterior
    #undef    SetPlayerInterior
#else
    #define    _ALS_SetPlayerInterior
#endif
#define SetPlayerInterior SetPlayerInteriorEx

stock  SpawnPlayerEx(playerid)
{
	if (IsPlayerDeath(playerid)) return 0;
	return SpawnPlayer(playerid);
}
#if defined _ALS_SpawnPlayer
	#undef SpawnPlayer
#else
	#define _ALS_SpawnPlayer
#endif

#define SpawnPlayer SpawnPlayerEx


stock SetPlayerPosEx(playerid,Float:x,Float:y,Float:z)
{
	if (!SetPlayerPos(playerid, x, y, z)) return 0;
	if (debug_ac)
	{
		printf("SetPlayerPosEx acPos %0.2f %0.2f  %0.2f  ",x,y,z);
	}
    AC_Info[playerid][acPosX] = x;
    AC_Info[playerid][acPosY] = y;
    AC_Info[playerid][acPosZ] = z;
	AC_Info[playerid][acSetPos] = GetTickCount() + 3250;
    return 1;
}

#if defined _ALS_SetPlayerPos
	#undef SetPlayerPos
#else
	#define _ALS_SetPlayerPos
#endif

#define SetPlayerPos SetPlayerPosEx

stock SetPlayerPosFindZEx(playerid,Float:x,Float:y,Float:z)
{
	if (!SetPlayerPosFindZ(playerid, x, y, z)) return 0;
    AC_Info[playerid][acPosX] = x;
    AC_Info[playerid][acPosY] = y;
    AC_Info[playerid][acPosZ] = z;
	AC_Info[playerid][acSetPos] = GetTickCount() + 2850;

	if (debug_ac)
	{
		printf("SetPlayerPosFindZEx acPos %0.2f %0.2f  %0.2f  ",x,y,z);
	}
	return 1;
}

#if defined _ALS_SetPlayerPosFindZ
	#undef SetPlayerPosFindZ
#else
	#define _ALS_SetPlayerPosFindZ
#endif

#define SetPlayerPosFindZ SetPlayerPosFindZEx


stock PutPlayerInVehicleEx(playerid, vehicleid, seatid) // tyt
{
	if (vehicleid == INVALID_VEHICLE_ID) return 0;
	AC_Info[playerid][acSetPos] = GetTickCount() + 2350;

	new Float: car_X, Float:car_Y,Float:car_Z;
	GetVehiclePos(vehicleid,car_X,car_Y,car_Z);

	AC_Info[playerid][acPosX] = car_X;
	AC_Info[playerid][acPosY] = car_Y;
	AC_Info[playerid][acPosZ] = car_Z;

	if (debug_ac)
	{
		printf("SetVehiclePosEx acPos %0.2f %0.2f  %0.2f  ",car_X,car_Y,car_Z);
	}

	/*if (AC_Info[playerid][acVehicleID] != INVALID_VEHICLE_ID)
	{
	}*/
	AC_Info[playerid][acEnterVehicleID] = vehicleid;
	AC_Info[playerid][acTPVehicle] = GetTickCount()-1000;
	return PutPlayerInVehicle(playerid, vehicleid, seatid);
}
#if defined _ALS_PutPlayerInVehicle
	#undef PutPlayerInVehicle
#else
	#define _ALS_PutPlayerInVehicle
#endif

#define PutPlayerInVehicle PutPlayerInVehicleEx


stock SetVehiclePosEx(vehicleid,Float:ac_x,Float:ac_y,Float:ac_z)
{
	if (!SetVehiclePos(vehicleid, ac_x, ac_y, ac_z)) return 0;
	foreach(PlayerInVehicle[vehicleid], i)
	{
		AC_Info[i][acPosX] = ac_x;
		AC_Info[i][acPosY] = ac_y;
		AC_Info[i][acPosZ] = ac_z;
		AC_Info[i][acSetPos] = GetTickCount() + 2850;
		if (debug_ac) {
			printf("SetVehiclePosEx acPos %0.2f %0.2f  %0.2f  ",ac_x,ac_y,ac_z);
		}
	}
	return 1;
}
#if defined _ALS_SetVehiclePos
	#undef SetVehiclePos
#else
	#define _ALS_SetVehiclePos
#endif

#define SetVehiclePos SetVehiclePosEx


stock LinkVehicleToInteriorEx(vehicleid,interior)
{
	foreach(PlayerInVehicle[vehicleid], i)
	{
		SetPlayerInterior(i,interior);
	}
	return LinkVehicleToInterior(vehicleid,interior);
}

#if defined _ALS_LinkVehicleToInterior
	#undef LinkVehicleToInterior
#else
	#define _ALS_LinkVehicleToInterior
#endif

#define LinkVehicleToInterior LinkVehicleToInteriorEx

stock GivePlayerWeaponEx(const playerid, const weaponid, const ammo)
{
	if (IsPlayerDeath(playerid)) return 0;
	new slot = GetWeaponSlot[weaponid];
	switch(weaponid)
	{
        case 0..15,40,46: player_weapon_ammo[playerid][slot] = 1;
	    default: player_weapon_ammo[playerid][slot] += ammo;
	}
	new weap = player_weapon_id[playerid][slot];
	player_weapon_id[playerid][slot] = weaponid;
	if (weap != weaponid)
	{
		player_weapon_ammo[playerid][slot] = ammo;
		GivePlayerWeapon(playerid,weaponid,ammo);
		SetPlayerAmmo(playerid,weaponid,ammo);
	}
    else GivePlayerWeapon(playerid,weaponid,ammo);
    pTemp[playerid][acWeaponTick] = GetTickCount() + 2850;
    return 1;
}


stock GetWeapon(playerid,x)
{
	if (player_weapon_id[playerid][x] > 0  && player_weapon_ammo[playerid][x] > 0) return 1;
	return 0;
}

stock ClearWeaponSlot(playerid,slot)
{
    if (!GetWeapon(playerid,slot))
	{
       ClearSlot(playerid,slot);
	}
	return 1;
}
stock ClearSlot(playerid,slot)
{
    player_weapon_ammo[playerid][slot] = 0;
	player_weapon_id[playerid][slot] = 0;
    Set_Weapon(playerid);
	return SetPlayerArmedWeapon(playerid,0);
}
stock GetWeaponClear(playerid)
{
	for(new x; x < 13; x++)
	{
	    ClearWeaponSlot(playerid,x);
	}
	Set_Weapon(playerid);
    pTemp[playerid][acWeaponTick] = GetTickCount() + 2850;
	return 1;
}
stock Set_Weapon(playerid)
{
	ResetPlayerWeapons(playerid);
	new ammo[13],weaponid[13];
	for(new x; x < 13; x++)
	{
		if (GetWeapon(playerid,x))
		{
		    weaponid[x] = player_weapon_id[playerid][x];
	     	ammo[x] =  player_weapon_ammo[playerid][x];
	     	player_weapon_ammo[playerid][x] = 0;
	    	player_weapon_id[playerid][x] = 0;
			GivePlayerWeaponEx(playerid,  weaponid[x], ammo[x]);
		}
	}
	return 1;
}

stock s_ac_SetPlayerAmmo(playerid, weaponid, ammo)
{
    player_weapon_ammo[playerid][ GetWeaponSlot[weaponid] ] = ammo;
    pTemp[playerid][acWeaponTick] = GetTickCount() + 2850;
    return SetPlayerAmmo(playerid, weaponid, ammo);
}

stock ResetPlayerWeaponsClient(playerid) return ResetPlayerWeapons(playerid);

stock ResetPlayerWeaponsEx(playerid)
{
    ResetPlayerWeapons(playerid);
	for (new i = 0; i < 13; i++)
	{
        player_weapon_id[playerid][i] = player_weapon_ammo[playerid][i] = 0;
	}
	pTemp[playerid][acWeaponTick] = GetTickCount() + 2850;
	return 1;
}

#if defined _ALS_ResetPlayerWeapons
	#undef ResetPlayerWeapons
#else
	#define _ALS_ResetPlayerWeapons
#endif

#define ResetPlayerWeapons ResetPlayerWeaponsEx

/*
new MaxSeats[212] = {
4,2,2,2,4,4,1,2,2,4,2,2,2,4,2,2,4,2,4,2,4,4,2,2,2,1,4,4,4,2,1,9,1,2,2,1,2,9,4,2,
4,1,2,2,2,4,1,2,1,6,1,2,1,1,1,2,2,2,4,4,2,2,2,2,2,2,4,4,2,2,4,2,1,1,2,2,1,2,2,4,
2,1,4,3,1,1,1,4,2,2,4,2,4,1,2,2,2,4,4,2,2,2,2,2,2,2,2,4,2,1,1,2,1,1,2,2,4,2,2,1,
1,2,2,2,2,2,2,2,2,4,1,1,1,2,2,2,2,0,0,1,4,2,2,2,2,2,4,4,2,2,4,4,2,1,2,2,2,2,2,2,
4,4,2,2,1,2,4,4,1,0,0,1,1,2,1,2,2,2,2,4,4,2,4,1,1,4,2,2,2,2,6,1,2,2,2,1,4,4,4,2,
2,2,2,2,4,2,1,1,1,4,1,1
};
*/

new const Float: vehicle_speed_max[212] = {
	88.0,82.0,104.0,61.0,74.0,91.0,61.0,83.0,56.0,88.0,72.0,123.0,94.0,61.0,59.0,107.0,86.0,74.0,64.0,83.0,81.0,
	86.0,78.0,55.0,75.0,110.0,94.0,92.0,87.0,112.0,103.0,77.0,95.0,61.0,93.0,0.0,83.0,88.0,80.0,94.0,76.0,42.0,
	79.0,70.0,62.0,91.0,103.0,70.0,80.0,102.0,0.0,108.0,80.0,30.0,72.0,88.0,59.0,53.0,92.0,77.0,100.0,107.0,
	100.0,90.0,50.0,50.0,84.0,78.0,90.0,70.0,87.0,65.0,71.0,60.0,83.0,96.0,110.0,104.0,65.0,78.0,103.0,54.0,
	87.0,68.0,34.0,56.0,36.0,100.0,100.0,78.0,87.0,83.0,78.0,91.0,120.0,98.0,92.0,100.0,60.0,68.0,78.0,50.0,
	119.0,119.0,96.0,78.0,100.0,89.0,60.0,58.0,72.0,120.0,120.0,120.0,69.0,79.0,89.0,89.0,91.0,120.0,150.0,
	105.0,115.0,105.0,72.0,89.0,88.0,83.0,98.0,83.0,33.0,39.0,61.0,93.0,94.0,88.0,96.0,90.0,90.0,55.0,83.0,
	115.0,91.0,84.0,83.0,83.0,83.0,79.0,120.0,85.0,81.0,88.0,67.0,100.0,80.0,88.0,67.0,67.0,92.0,99.0,94.0,
	86.0,99.0,120.0,50.0,92.0,89.0,96.0,81.0,0.0,0.0,55.0,35.0,61.0,35.0,88.0,88.0,120.0,120.0,88.0,85.0,105.0,
	80.0,35.0,0.0,83.0,99.0,92.0,60.0,91.0,0.0,0.0,120.0,120.0,50.0,52.0,98.0,98.0,98.0,88.0,84.0,61.0,96.0,95.0,
	84.0,0.0,0.0,0.0,0.0,0.0,0.0
};

/*new const vehicle_seat_max[212] = {
	3,1,1,1,3,3,0,1,1,3,1,1,1,3,1,1,3,1,3,1,3,3,1,1,1,0,3,3,3,1,
	0,8,0,1,1,0,1,8,3,1,3,0,1,1,1,3,0,1,0,5,0,1,0,0,0,1,1,1,3,3,
	1,1,1,1,1,1,3,3,1,1,3,1,0,0,1,1,0,1,1,3,1,0,3,2,0,0,0,3,1,1,
	3,1,3,0,1,1,1,3,3,1,1,1,1,1,1,1,1,3,1,0,0,1,0,0,1,1,3,1,1,0,
	0,1,1,1,1,1,1,1,1,3,0,0,0,1,1,1,1,5,5,0,3,1,1,1,1,1,3,3,1,1,
	3,3,1,0,1,1,1,1,1,1,3,3,1,1,0,1,3,3,0,5,5,0,0,1,0,1,1,1,1,3,
	3,1,3,0,0,3,1,1,1,1,5,0,1,1,1,0,3,3,3,1,1,1,1,1,3,1,0,0,0,3,
	0,0
};*/


#if defined _ALS_GivePlayerWeapon
	#undef GivePlayerWeapon
#else
	#define _ALS_GivePlayerWeapon
#endif

#define GivePlayerWeapon GivePlayerWeaponEx


public OnPlayerConnect(playerid)
{
	AC_Info[playerid][acPosDiff] =
	AC_Info[playerid][acSpeed] = 0.0;
	AC_Info[playerid][acVehicleID] = INVALID_VEHICLE_ID;
	AC_Info[playerid][acVehicleSeat] = MAX_PASSENGER;
	AC_Info[playerid][acInt] = 
	AC_Info[playerid][PlayerDeath] = 
	AC_Info[playerid][acFloodEnterCar] = 
	AC_Info[playerid][acDistCount] = 
	AC_Info[playerid][acNonLogin] = 
	AC_Info[playerid][PlayerKicked] = 
	AC_Info[playerid][acInvis] = 0;

	AC_Info[playerid][acSetInt] = -1;
	AC_Info[playerid][acSpectateTick] = 
	AC_Info[playerid][acSetPos] = GetTickCount()+58000;

	CRASH[playerid] = false;

    #if defined ac_ser_OnPlayerConnect 
		return ac_ser_OnPlayerConnect(playerid); 
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
  #undef OnPlayerConnect
#else
  #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect ac_ser_OnPlayerConnect
#if  defined ac_ser_OnPlayerConnect
  forward ac_ser_OnPlayerConnect(playerid);
#endif

public  OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (AC_Info[playerid][acFloodEnterCar] == 0)
	{
		if (CRASH[playerid] == false ){
			CRASH[playerid] = true;
			SetTimerEx("CRASHer", 2000, 0, "d", playerid); 
		}
		AC_Info[playerid][acTPVehicle] = GetTickCount();
		AC_Info[playerid][acFloodEnterCar] = 1;
	}

	#if defined ac_ser_OnPlayerEnterVehicle
		return ac_ser_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
	#else
		return 1;
	#endif
}

publics:CRASHer(playerid)
{
	CRASH[playerid] = false;
	return true;
}

#if defined _ALS_OnPlayerEnterVehicle
	#undef OnPlayerEnterVehicle
#else
	#define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle ac_ser_OnPlayerEnterVehicle
#if defined ac_ser_OnPlayerEnterVehicle
	forward ac_ser_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	AC_Info[playerid][acFloodEnterCar] = 0;
	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if (GetTickCount() - AC_Info[playerid][acTPVehicle] < 450 && AcSettings[acTimeTPCar] && GetPlayerAdmin(playerid) < 1)
		{
			if (AcSettings[acTimeTPCar] == 1 )
				OnPlayerWarning(playerid,"Возможно быстрый телепорт в авто",1);
			else
				return ackick(playerid,!"Вы были кикнуты по подозрению в читерстве (aac-1)");
		}

		if (AC_Info[playerid][acVehicleID] != INVALID_VEHICLE_ID || AC_Info[playerid][acVehicleSeat] != MAX_PASSENGER && AcSettings[acChangeCar])
		{
		   if (AcSettings[acChangeCar] == 1 )
				OnPlayerWarning(playerid,"Возможно подмена авто",1);
			else
				return ackick(playerid,"Выбыли кикнуты по подозрению в читерстве (aac-2)");
		}

		AC_Info[playerid][acVehicleID] = GetPlayerVehicleID(playerid);
		AC_Info[playerid][acVehicleSeat] = GetPlayerVehicleSeat(playerid);

		if (AC_Info[playerid][acEnterVehicleID] != AC_Info[playerid][acVehicleID] && AcSettings[acTPCar] && GetPlayerAdmin(playerid) < 1)
		{
			if (AcSettings[acTPCar] == 1 )
				OnPlayerWarning(playerid,"Возможно телепорт в недопустимый авто",1);
			else
				return ackick(playerid,!"Вы были кикнуты по подозрению в читерстве (aac-8)");
		}
	}
	else if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		if (AC_Info[playerid][acVehicleID] != INVALID_VEHICLE_ID)
		{
			AC_Info[playerid][acVehicleID] = INVALID_VEHICLE_ID;
			AC_Info[playerid][acVehicleSeat] = MAX_PASSENGER;
		}
	}
	/*else if ( newstate == PLAYER_STATE_SPECTATING && !pTemp[playerid][tSpectate] && !pTemp[playerid][PlayerADostup])
	{
		OnPlayerWarning(playerid,"Возможно Spectate Hack",1);
		//return ackick(playerid,!"Вы были кикнуты по подозрению в читерстве (aac-Spectate)");
	}*/
	else if (newstate == PLAYER_STATE_WASTED)
	{
		AC_Info[playerid][PlayerDeath] = 1;
	}
	#if defined ac_ser_OnPlayerStateChange
		return ac_ser_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange ac_ser_OnPlayerStateChange
#if defined ac_ser_OnPlayerStateChange
	forward ac_ser_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

#define class_x 410.700
#define class_y -1770.2331
#define class_z 155.2173

/*for(new i;i<sizeof(CheatShow);i++){
		TextDrawShowForPlayer(playerid, CheatShow[i]);
	}*/

public OnGameModeInit()
{
	SetTimer("SearchCheaters", 1_000, true); 
	AddPlayerClass(37,class_x,class_y,class_z,14.4058,0,0,0,0,0,0); //

	new Float:DrawPos = 26.0;
	for(new i;i<sizeof(CheatShow);i++)
    {
        if (i > 0) DrawPos += 30.0;
        CheatShow[i] = TextDrawCreate(DrawPos,430.0,"-1");
        TextDrawColor(CheatShow[i],0xEF8100FF);
        TextDrawFont(CheatShow[i],1);
        TextDrawSetOutline(CheatShow[i],1);
        TextDrawLetterSize(CheatShow[i],0.3500,1.270);
    }

	#if defined ac_ser_OnGameModeInit
		return ac_ser_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit ac_ser_OnGameModeInit
#if defined ac_ser_OnGameModeInit
	forward ac_ser_OnGameModeInit();
#endif

public OnPlayerSpawn(playerid)
{
	AC_Info[playerid][acSpectateTick] = 
	AC_Info[playerid][acSetPos] = GetTickCount() + 2850;
	AC_Info[playerid][PlayerDeath] = 
	AC_Info[playerid][acDistCount] = 0;
	#if defined ac_ser_OnPlayerSpawn
		return ac_ser_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn ac_ser_OnPlayerSpawn
#if defined ac_ser_OnPlayerSpawn
	forward ac_ser_OnPlayerSpawn(playerid);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	AC_Info[playerid][acSpectateTick] = GetTickCount()+2800;
	ResetPlayerWeapons(playerid);
	AC_Info[playerid][PlayerDeath] = 1;
	AC_Info[playerid][acDistCount] = 
	AC_Info[playerid][acInvis] = 0;
	#if defined ac_ser_OnPlayerDeath
		return ac_ser_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath ac_ser_OnPlayerDeath
#if defined ac_ser_OnPlayerDeath
	forward ac_ser_OnPlayerDeath(playerid, killerid, reason);
#endif


public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
	if (!(0 <= playerid < MAX_PLAYERS) || IsPlayerKicked(playerid) > 0 || IsPlayerDeath(playerid)) return 0;
	//printf("oldinteriorid %d , newinteriorid %d, acInt = %d ",oldinteriorid,newinteriorid, AC_Info[playerid][acInt]);
	if (AC_Info[playerid][acSetInt] != newinteriorid)
	{
		if (AC_Info[playerid][acSetInt] == -1 && AcSettings[acInt] && GetPlayerAdmin(playerid) < 1 && pTemp[playerid][tSelectSkin] == false)
		{
			if (AcSettings[acInt] == 1)
				OnPlayerWarning(playerid,"Телепорт в интерьер");
			else return ackick(playerid,!"Вы были кикнуты по подозрению в читерстве (aac-9)"), 1;
		}
	}
	else AC_Info[playerid][acSetInt] = -1;
	if (!IsPlayerKicked(playerid)) AC_Info[playerid][acInt] = newinteriorid % 256;
	//else PlayerDeath{playerid} = 0;
	
    #if defined ac_ser_OnPlayerInteriorChange
		return ac_ser_OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerInteriorChange
	#undef OnPlayerInteriorChange
#else
	#define _ALS_OnPlayerInteriorChange
#endif
#define OnPlayerInteriorChange ac_ser_OnPlayerInteriorChange
#if defined ac_ser_OnPlayerInteriorChange
	forward ac_ser_OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid);
#endif



//new string_cheat[128];
publics: SearchCheaters()
{
    new ser_tick = GetTickCount();
	new Float:max_speed = 30.0,
		Float:X,
		Float:Y,
		Float:Z,
		//weapon_id,
		//weapon_ammo,
		Float:speed;
	foreach(Player, playerid)
	{
		if (!(0 <= playerid < MAX_PLAYERS) ||
			IsPlayerKicked(playerid) || 
			IsPlayerDeath(playerid)
		) continue;

		if (!pInfo[playerid][pLogin])
		{
			GetPlayerVelocity(playerid,X,Y,Z);
			if (X > 0 || Y > 0 || Z > 0)
			{
				if (++ AC_Info[playerid][acNonLogin] > 3)
				{
					ackick(playerid, "Вы были кикнуты по подозрению в читерстве (aac-999999)");
					printf("ID: %d, code 999999", playerid);
				}
			}
			continue;
		}

		if (ser_tick > pTemp[playerid][acWeaponTick] + GetPlayerPing(playerid) && IsPlayerAFK(playerid) < 1) {

			UpdateWeapon_AC(playerid,1);
		}
        /*if (ser_tick > pTemp[playerid][acWeaponTick] + GetPlayerPing(playerid) && IsPlayerAFK(playerid) < 1) {
			for(new i = 1; i < 13; i++)
			{
                GetPlayerWeaponData(playerid, i, weapon_id, weapon_ammo);
				if (weapon_id == 46 || weapon_id == 2 || weapon_id == 3 || weapon_id == 40) continue;
				if (weapon_id != player_weapon_id[playerid][i] && weapon_ammo > 1) { 

					ResetPlayerWeapons(playerid);

                    format(string_cheat, 128, "<Warning> %s[%d] был кикнут по подозрению: WeaponHack [code: S:1].", pInfo[playerid][pName],playerid);
                   	SendAdminMessage(CGRAY2, string_cheat);

                    ackick(playerid, "Вы были кикнуты по подозрению: WeaponHack [code: S:1]");
					break;
				}
				if (player_weapon_ammo[playerid][i] <  weapon_ammo) {
				//if (weapon_ammo > player_weapon_ammo[playerid][i]-1) { 

					ResetPlayerWeapons(playerid);

                    format(string_cheat, 128, "<Warning> %s[%d] был кикнут по подозрению: AmmoHack [code: S:1].", pInfo[playerid][pName],playerid);
                   	SendAdminMessage(CGRAY2, string_cheat);

					ackick(playerid, "Вы были кикнуты по подозрению: AmmoHack [code: S:1]");
					break;
				}
                else player_weapon_ammo[playerid][i] = weapon_ammo; // сохраняем аммо
			}
		}*/

		// далее читы которые не проверяются у админов  ^ WeaponHack проверка нужна для сохранения оружия

		if (GetPlayerAdmin(playerid) > 0) continue;
		if (SB_INFO) {
			new objectid = GetPlayerSurfingObjectID(playerid);
			if (objectid != INVALID_OBJECT_ID)
			{
				GetObjectPos(objectid, X,Y,Z);

				if (!IsPlayerInRangeOfPoint(playerid, 200.0,X,Y,Z) && ++ AC_Info[playerid][acInvis] > 2)
				{
					ackick(playerid,!"Вы были кикнуты по подозрению в читерстве (aac-10)");
					continue;
				}
			}
		}
		

		if (ser_tick > AC_Info[playerid][acSetPos] + GetPlayerPing(playerid)*2 )
		{
			new vehicleid = AC_Info[playerid][acVehicleID];

			if (vehicleid != INVALID_VEHICLE_ID ){
				GetVehicleVelocity(vehicleid,X,Y,Z);
				new model_first = GetVehicleModel(vehicleid)-400;
				if (model_first > -1) max_speed = vehicle_speed_max[model_first] + 15.0;
			}
			else if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT){
				GetPlayerVelocity(playerid,X,Y,Z);
			}
			else if (GetPlayerState(playerid)  == PLAYER_STATE_SPECTATING)
			{
				if (!AC_Info[playerid][acSpectate] && ser_tick > AC_Info[playerid][acSpectateTick]){
					SendClientMessage(playerid, COLOR_GREY, !"ERROR (aac-3)");
					continue;
				}
			}
			else continue;
			speed = (VectorSize(X, Y, Z))*100.0;

			/*if (GetPlayerAdmin(playerid) > 1)
			{
				GetPlayerPos(playerid,AC_Info[playerid][acPosX], AC_Info[playerid][acPosY], AC_Info[playerid][acPosZ]);
				continue;
			}*/

			static afk_start[MAX_PLAYERS];
			static afk_car[MAX_PLAYERS];

			if (IsPlayerAFK(playerid) > 2 && vehicleid != INVALID_VEHICLE_ID && afk_start[playerid] == 0)
			{
				afk_start[playerid] = 1;
				afk_car[playerid] = vehicleid;
			}

			if (IsPlayerAFK(playerid) > 3) continue;
			
			if (afk_start[playerid] == 1 && IsPlayerAFK(playerid) < 2)
			{
				//if (IsPlayerAFK(playerid) > 1)return 1;
				afk_start[playerid] = 0;
				if (IsPlayerInVehicle(playerid,afk_car[playerid]))
				{
					new Float:veh_x,Float:veh_y,Float:veh_z;
					GetVehiclePos(afk_car[playerid],veh_x,veh_y,veh_z);
					AC_Info[playerid][acPosX] = veh_x;
					AC_Info[playerid][acPosY]= veh_y;
					AC_Info[playerid][acPosZ] = veh_z;
					continue;
				}
			}
			
			new playerState = GetPlayerState(playerid);
			if ((playerState == PLAYER_STATE_ONFOOT|| playerState == PLAYER_STATE_DRIVER  || playerState == PLAYER_STATE_PASSENGER))
			{
				static 
					Float:diff_pos,
					Float:dist_z,
					Float:pos_x,
					Float:pos_y,
					Float:pos_z
				;

				GetPlayerPos(playerid,pos_x,pos_y,pos_z);
				
				diff_pos = VectorSize(pos_x-AC_Info[playerid][acPosX], pos_y-AC_Info[playerid][acPosY],0.0);

				dist_z = floatabs(floatsub(pos_z, AC_Info[playerid][acPosZ]));
				
				new vehicle_surf = GetPlayerSurfingVehicleID(playerid);
				if (vehicle_surf != INVALID_VEHICLE_ID)
				{
					new id = -1;
					foreach(new i: PlayerInVehicle[vehicle_surf])
					{
						if (GetPlayerVehicleSeat(i) == 0)
						{
							id = i;
							break;
						}
					}

					if ((CheckSurfCar(GetVehicleModel(vehicle_surf)) && diff_pos < AcSettings[acDistKick]) || GetPlayerAdmin(id) > 1 )
					{
						goto update_status;
					}

					new Float:speed_car;
					GetVehicleVelocity(vehicle_surf,X,Y,Z);
					speed_car = (VectorSize(X, Y, Z))*100.0;


					if (speed_car > 20.0 && !CheckSurfCar(GetVehicleModel(vehicle_surf))) // Если скорость больше 20км\час
					{
						SetPlayerPos(playerid, pos_x, pos_y, pos_z+2.5); // Немного подкинем игрока чтоб он не остался на авто
						ApplyAnimation(playerid,!"PED",!"BIKE_fallR", 4.0, 0, 1, 0, 0, 0,0); // Применим анимку падения
						//SetPlayerHealth(playerid, player_health[playerid]-15.0); // Отнимем 15хп
						goto update_status;
					}
				}
				
				if (playerState == PLAYER_STATE_PASSENGER)
				{
					new id = -1;
					foreach(new i: PlayerInVehicle[vehicleid])
					{
						if (GetPlayerVehicleSeat(i) == 0)
						{
							id = i;
							break;
						}
					}
					if (id != -1 && diff_pos < AcSettings[acDistKick] || GetPlayerAdmin(id) > 1){
						goto update_status;
					}
				}
				if (dist_z > AcSettings[acDistZKick] && AcSettings[acResultZ]){
					if (AcSettings[acResultZ] == 1)
						OnPlayerWarning(playerid,"Возможно телепорт (aac-4/^Z) ",1);
					else
					{
						ac_tp_kick(playerid,diff_pos,speed,max_speed,dist_z, "aac-4");
						continue;
					}
				}
				else if ((diff_pos > AcSettings[acDistKick] && AcSettings[acResultDist]) && GetPVarInt(playerid,"AntiKickGarage") < gettime()){
					if (AcSettings[acResultDist] == 1)
						OnPlayerWarning(playerid,"Возможно телепорт (aac-5/distMax)",1);
					else
					{
						ac_tp_kick(playerid,diff_pos,speed,max_speed,dist_z, "aac-5");
						continue;
					}
				}

				else if (diff_pos > AcSettings[acStartCheck])
				{
					if (speed > max_speed && speed > AC_Info[playerid][acSpeed] +  (( AC_Info[playerid][acPosDiff] / 2.6) * 1.8) && AcSettings[acResultSpeed])
					{
						if (AcSettings[acResultSpeed] == 1)
							OnPlayerWarning(playerid,"Возможно телепорт (aac-6/speed)",1);
						else
						{
							ac_tp_kick(playerid,diff_pos,speed,max_speed,dist_z, "aac-6");
							continue;
						}
					}

					if (diff_pos >  AC_Info[playerid][acPosDiff] + (( AC_Info[playerid][acSpeed] / 2.6) * 1.8) && AcSettings[acResultDist2] )
					{
						if (AcSettings[acResultDist2] == 1 ||  AcSettings[acDistCount] > ++ AC_Info[playerid][acDistCount])
							OnPlayerWarning(playerid,"Возможно телепорт (aac-7/DistMin)",1);
						else
						{
							ac_tp_kick(playerid,diff_pos,speed,max_speed,dist_z, "aac-7");
							continue;
						}
					}
				}

				if (speed < AcSettings[acAirBreak] && diff_pos > AcSettings[acAirBreak2] && AC_Info[playerid][acSpeed] < AcSettings[acAirBreak] && AcSettings[acResultAir])
				{
					OnPlayerWarning(playerid,"Возможно Airbreak / SpeedHack / FlyHack",1);
					//AddCheater(playerid); 
				}
				update_status:
				AC_Info[playerid][acPosDiff] = diff_pos;
				AC_Info[playerid][acSpeed] = speed;
				AC_Info[playerid][acPosX] = pos_x;
				AC_Info[playerid][acPosY] = pos_y;
				AC_Info[playerid][acPosZ] = pos_z;
				pTemp[playerid][tPos][0] = pos_x;
				pTemp[playerid][tPos][1] = pos_y;
				pTemp[playerid][tPos][2] = pos_z;
				if (debug_ac) {
					printf("%s - speed %0.2f",pInfo[playerid][pName],speed);
				}
				//GetPlayerPos(playerid,AC_Info[playerid][acPosX], AC_Info[playerid][acPosY], AC_Info[playerid][acPosZ]);
				//last_car[playerid] = vehicleid;
			}

		}
		if (X > 1.7 || Y > 1.7)
        {
            SetPVarInt(playerid, "Pizdorvanka", GetPVarInt(playerid, "Pizdorvanka") + 1 ) ;
            if (GetPVarInt(playerid, "Pizdorvanka") > 2)
            {
                SetPVarInt(playerid, "Pizdorvanka", 0);
				if (!GetVehicleTT(playerid)) {
					scmKick(playerid,"Вы были отсоеденены от сервера! (RVANKA) CODE: S2");
				} 
				continue;
            } 
        }

		if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
        {
            scmKick(playerid,"Вы были отсоеденены от сервера! (SPECIAL_ACTION_USEJETPACK) CODE: S3");
        }
	} 
	return 1;
} 
stock ackick(const playerid,const reason[])
{
    if (IsPlayerKicked(playerid)) return 0;
	SendClientMessage(playerid,0xFF6347AA,reason);
	KickEx(playerid);
	return 1;
}


stock ac_tp_kick(const playerid,const Float:diff_pos,const Float:speed,const Float:max_speed,const Float:dist_z,const reason[])
{
	if (IsPlayerKicked(playerid)) return 0;
	new 
		string_[128]; 

	format(string_, sizeof string_, "< Warning > %s[%d] был кикнут (Телепорт diff_pos = %0.2f speed = %0.2f max_speed = %0.2f dist_z = %0.2f)", 
		pInfo[playerid][pName], diff_pos, speed, max_speed, dist_z
	); 
	SendACMessageAdmins(COLOR_REDD, string_, 2); 

	format(string_, sizeof string_, "Вы были кикнуты по подозрению в читерстве %s", 
		reason
	);
	SendClientMessage(playerid, 0xFF6347AA, string_); 

	format(t_string, sizeof t_string, 
		""colwhi"Вы были кикнуты по подозрению в использовнии чит-программ. {F48015}код: %s\n\n\
		"colwhi"Возможные причины ложного срабатывания:\n\
		\tВысокий пинг\n \tПлохое соединение с сервером\n\tПроблема на стороне сервера\n\
		\tБаг SA-MP\n\tЧитеры\n\nЕсли вы считаете, что были кикнуты по ошибке. сообщите на форум:\n\
		\t\t{CCCCCC}t.me/ForumHellRolePlay", reason
	); 
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, !"Античит", t_string, !"Хорошо", ""), t_string[0] = EOS;
	KickEx(playerid); 
	return 1;
}

stock CheckSurfCar(vehicle_model)
{
	switch(vehicle_model){
		case 422, 430, 446, 452..455, 472,473, 478, 484, 493, 595, 600:
			return true;
	}
	return 0;
}


CMD:acedit(playerid)
{
	if (GetPlayerAdmin(playerid) < 6) return 1;
	ShowPlayerDialog(playerid, D_AC_SETTINGS, DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",!"[0] Телепорт\n[1] Телепорт в авто\n[2] Интерьер(aac-9)\n[3] Статусы", !"Далее", !"Закрыть");
	return 1;
}
 


publics:LoadAcSettings()
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) return print(!"[Загрузка ...] Данные из ac_settings не получены!");
	
	new time = GetTickCount();

	cache_get_value_name_int(0, "acResultZ",AcSettings[acResultZ]);
	cache_get_value_name_int(0, "acResultDist",AcSettings[acResultDist]);
	cache_get_value_name_int(0, "acResultSpeed",AcSettings[acResultSpeed]);
	cache_get_value_name_int(0, "acResultDist2",AcSettings[acResultDist2]);
	cache_get_value_name_int(0, "acResultAir",AcSettings[acResultAir]);

	cache_get_value_name_int(0, "acDistCount",AcSettings[acDistCount]);

	cache_get_value_name_float(0, "acDistKick",AcSettings[acDistKick]);
	cache_get_value_name_float(0, "acDistZKick",AcSettings[acDistZKick]);
	cache_get_value_name_float(0, "acStartCheck",AcSettings[acStartCheck]);
	cache_get_value_name_float(0, "acAirBreak",AcSettings[acAirBreak]);
	cache_get_value_name_float(0, "acAirBreak2",AcSettings[acAirBreak2]);

	cache_get_value_name_int(0, "acTimeTPCar",AcSettings[acTimeTPCar]);
	cache_get_value_name_int(0, "acTPCar",AcSettings[acTPCar]);
	cache_get_value_name_int(0, "acChangeCar",AcSettings[acChangeCar]);
	cache_get_value_name_int(0, "acInt",AcSettings[acInt]);


	printf ( "[Загрузка ...] Данные из ac_settings загружены за %d (ms)",GetTickCount()-time ) ;
	return 1;
}

stock ac_ser_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) {
	switch(dialogid)
	{
		case D_AC_SETTINGS:
		{
			if (response)
			{
				switch(listitem)
				{
				
					case 0:{
						ShowPlayerDialog(playerid,D_AC_SETTINGS2,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
						!"Высота MAX(aac-4)\nДистанция MAX(aac-5)\nСкорость(aac-6)\nДистанция(aac-7)\nAirbreak",
						!"Далее",!"Закрыть");
					}
					case 1:{
						ShowPlayerDialog(playerid,D_AC_SETTINGS11,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
						!"Быстрый телепорт в авто(aac-1)\nПодмена авто(aac-2)\nТелепорт в не разрешенный авто(aac-8)",
						!"Далее",!"Закрыть");
					}
					case 2:
					{
						ShowPlayerDialog(playerid,D_AC_SETTINGS13,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
						!"1. Отключить\n2. Warning\n3. Kick",!"Далее",!"Назад");
					}
					case 3: {
						static str_staus[] = "\
							Название\tПараметр\tДействие\n\
							Минимальная дистанция\t%0.2f до кика (%d)\t%s\n\
							Максимальная дистанция\t%0.2f\t%s\n\
							Дистанция по высоте \t%0.2f\t%s\n\
							Airbreak / Fly \tspeed < %0.2f && diff > %0.2f\t%s\n\
							Античит по скорости\t%s\n\
							Смена интерьера\t%s"
						;

						new tmp_str[sizeof(str_staus) + 130];
						format(tmp_str,sizeof(tmp_str),str_staus,
						AcSettings[acStartCheck],
						AcSettings[acDistCount],
						AcSettings[acResultDist2] == 0 ? ("{DB0202}Отключен") : AcSettings[acResultDist2] == 1 ? ("{40D32F}Warning") : ("{F7DC16}Kick"),
						AcSettings[acDistKick],
						AcSettings[acResultDist] == 0 ? ("{DB0202}Отключен") : AcSettings[acResultDist] == 1 ? ("{40D32F}Warning") : ("{F7DC16}Kick"),
						AcSettings[acDistZKick],
						AcSettings[acResultZ] == 0 ? ("{DB0202}Отключен") : AcSettings[acResultZ] == 1 ? ("{40D32F}Warning") : ("{F7DC16}Kick"),
						AcSettings[acAirBreak],AcSettings[acAirBreak2],
						AcSettings[acResultAir] == 0 ? ("{DB0202}Отключен") : ("{40D32F}Warning"),
						AcSettings[acResultSpeed] == 0 ? ("{DB0202}Отключен") : AcSettings[acResultSpeed] == 1 ? ("{40D32F}Warning") : ("{F7DC16}Kick"),
						AcSettings[acInt] == 0 ? ("{DB0202}Отключен"): AcSettings[acInt] == 1 ? ("{40D32F}Warning") : ("{F7DC16}Kick")	);

						ShowPlayerDialog(playerid,0,DIALOG_STYLE_TABLIST_HEADERS,!"Античит",tmp_str,!"Закрыть","");
					}
				}
			}
			return 1;
		}
		case D_AC_SETTINGS2:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerDialog(playerid,D_AC_SETTINGS3,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"Высота",
						!"1. Действие по высоте.\n2. Изменить дистанцию",!"Далее",!"Назад");
					}
					case 1:
					{
						ShowPlayerDialog(playerid,D_AC_SETTINGS5,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"Дистанция MAX",
						!"1. Действие по расстоянию.\n2. Изменить дистанцию",!"Далее",!"Назад");
					}
					case 2:
					{
						ShowPlayerDialog(playerid,D_AC_SETTINGS7,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"Скорость",
						!"1. Отключить\n2. Warning\n3. Kick",!"Далее",!"Назад");
					}
					case 3:
					{
						ShowPlayerDialog(playerid,D_AC_SETTINGS8,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"Дистанция",
						!"1. Действие по расстоянию.\n2. Изменить дистанцию",!"Далее",!"Назад");
					}
					case 4:
					{
						ShowPlayerDialog(playerid,D_AC_SETTINGS10,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"Airbreak",
						!"1. Отключить\n2. Warning",!"Далее",!"Назад");
					}
				}
			}
			else callcmd::acedit(playerid);
		}
		case D_AC_SETTINGS3:
		{
			if (response)
			{
				playerListItem[playerid][0] = listitem;
				if (listitem == 0 )
					ShowPlayerDialog(playerid,D_AC_SETTINGS4,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
					!"1. Отключить\n2. Warning\n3. Kick",!"Далее",!"Назад");
				else{
					ShowSettingsDistZ(playerid);
				}
			}
			else 
			{
				ShowPlayerDialog(playerid,D_AC_SETTINGS2,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"Высота MAX(aac-4)\nДистанция MAX(aac-5)\nСкорость(aac-6)\nДистанция(aac-7)\nAirbreak",
				!"Далее",!"Закрыть");
			}
		}
		case D_AC_SETTINGS4:
		{
			if (response)
			{
				if (playerListItem[playerid][0] == 1)
				{
					new Float:dist_z_result;
					if (sscanf(inputtext,"f",dist_z_result)) return  ShowSettingsDistZ(playerid), 1;
					if (dist_z_result < 100.0)
					{
						SendClientMessage(playerid,CGRAY2,!"Нельзя меньше 100.0");
						ShowSettingsDistZ(playerid);
						return 1;
					}
					AcSettings[acDistZKick] = dist_z_result;
					SaveAcSettingsFloat("acDistZKick",dist_z_result);

					new tmp_str[60];
					format(tmp_str,sizeof(tmp_str),"Вы установили дистанцию по высоте %0.2f",dist_z_result);
					SendClientMessage(playerid,CGRAY2,tmp_str);
				}
				else
				{
					if (listitem == 0 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по высоте: отлючена!");
					else if (listitem == 1 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по высоте: Warning!");
					else if (listitem == 2 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по высоте: Kick!");
					else return 1;

					AcSettings[acResultZ] = listitem;
					SaveAcSettingsInteger("acResultZ", listitem);
				}
			}
			else 
				ShowPlayerDialog(playerid,D_AC_SETTINGS3,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
						!"1. Действие по высоте.\n2. Изменить дистанцию",!"Далее",!"Назад");
		}
		case D_AC_SETTINGS5:
		{
			if (response)
			{
				playerListItem[playerid][0] = listitem;
				if (listitem == 0 )
					ShowPlayerDialog(playerid,D_AC_SETTINGS6,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
					!"1. Отключить\n2. Warning\n3. Kick",!"Далее",!"Назад");
				else{
					ShowSettingsDist(playerid);
				}
			}
			else 
			{
				ShowPlayerDialog(playerid,D_AC_SETTINGS2,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"Высота MAX(aac-4)\nДистанция MAX(aac-5)\nСкорость(aac-6)\nДистанция(aac-7)\nAirbreak",
				!"Далее",!"Закрыть");
			}
		}
		case D_AC_SETTINGS6:
		{
			if (response)
			{
				if (playerListItem[playerid][0] == 1)
				{
					new Float:dist_result;
					if (sscanf(inputtext,"f",dist_result)) return  ShowSettingsDistZ(playerid), 1;
					if (dist_result < 100.0)
					{
						SendClientMessage(playerid,CGRAY2,!"Нельзя меньше 100.0");
					ShowSettingsDistZ(playerid);	
						return 1;
					}
					AcSettings[acDistKick] = dist_result;
					SaveAcSettingsFloat("acDistKick",dist_result);

					new tmp_str[60];
					format(tmp_str,sizeof(tmp_str),"Вы установили дистанцию по расстоянию %0.2f",dist_result);
					SendClientMessage(playerid,CGRAY2,tmp_str);
				}
				else
				{
					if (listitem == 0 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по расстоянию: отлючена!");
					else if (listitem == 1 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по расстоянию: Warning!");
					else if (listitem == 2 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по расстоянию: Kick!");
					else return 1;

					AcSettings[acResultDist] = listitem;
					SaveAcSettingsInteger("acResultDist", listitem);
				}
			}
			else 
				ShowPlayerDialog(playerid,D_AC_SETTINGS5,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
						!"1. Действие по высоте.\n2. Изменить дистанцию",!"Далее",!"Назад");
		}
		case D_AC_SETTINGS7:
		{
			if (response)
			{
				if (listitem == 0 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по скорости: отлючена!");
					else if (listitem == 1 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по скорости: Warning!");
					else if (listitem == 2 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция по скорости: Kick!");
					else return 1;

					AcSettings[acResultSpeed] = listitem;
					SaveAcSettingsInteger("acResultSpeed", listitem);
			}
			else 
			{
				ShowPlayerDialog(playerid,D_AC_SETTINGS2,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"Высота MAX(aac-4)\nДистанция MAX(aac-5)\nСкорость(aac-6)\nДистанция(aac-7)\nAirbreak",
				!"Далее",!"Закрыть");
			}
		}
		case D_AC_SETTINGS8:
		{
			if (response)
			{
				playerListItem[playerid][0] = listitem;
				if (listitem == 0 )
					ShowPlayerDialog(playerid,D_AC_SETTINGS9,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
					!"1. Отключить\n2. Warning\n3. Kick",!"Далее",!"Назад");
				else{
					ShowSettingsDistStart(playerid);
				}
			}
			else 
			{
				ShowPlayerDialog(playerid,D_AC_SETTINGS2,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"Высота MAX(aac-4)\nДистанция MAX(aac-5)\nСкорость(aac-6)\nДистанция(aac-7)\nAirbreak",
				!"Далее",!"Закрыть");
			}
		}
		case D_AC_SETTINGS9:
		{
			if (response)
			{
				if (playerListItem[playerid][0] == 1)
				{
					new Float:dist_result;
					if (sscanf(inputtext,"f",dist_result)) return  ShowSettingsDistStart(playerid), 1;
					if (dist_result < 30.0)
					{
						SendClientMessage(playerid,CGRAY2,!"Нельзя меньше 30.0");
						ShowSettingsDistStart(playerid);	
						return 1;
					}
					AcSettings[acStartCheck] = dist_result;
					SaveAcSettingsFloat("acStartCheck",dist_result);

					new tmp_str[60];
					format(tmp_str,sizeof(tmp_str),"Вы установили минимальное расстояние %0.2f",dist_result);
					SendClientMessage(playerid,CGRAY2,tmp_str);
				}
				else
				{
					if (listitem == 0 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция минимальная: отлючена!");
					else if (listitem == 1 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция минимальная: Warning!");
					else if (listitem == 2 )
						SendClientMessage(playerid,CGRAY2,!"Дистанция минимальная: Kick!");
					else return 1;

					AcSettings[acResultDist2] = listitem;
					SaveAcSettingsInteger("acResultDist2", listitem);
				}
			}
			else 
				ShowPlayerDialog(playerid,D_AC_SETTINGS5,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
						!"1. Действие по высоте.\n2. Изменить дистанцию",!"Далее",!"Назад");
		}
		case D_AC_SETTINGS10:
		{
			if (response)
			{
				if (listitem == 0 )
					SendClientMessage(playerid,CGRAY2,!"Дистанция минимальная: отлючена!");
				else if (listitem == 1 )
					SendClientMessage(playerid,CGRAY2,!"Дистанция минимальная: Warning!");
				else return 1;
				AcSettings[acResultAir] = listitem;
				SaveAcSettingsInteger("acResultAir", listitem);
			}
			else 
			{
				ShowPlayerDialog(playerid,D_AC_SETTINGS2,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"Высота MAX(aac-4)\nДистанция MAX(aac-5)\nСкорость(aac-6)\nДистанция(aac-7)\nAirbreak",
				!"Далее",!"Закрыть");
			}
		}
		case D_AC_SETTINGS11:
		{
			if (response)
			{
				playerListItem[playerid][0] = listitem;
				ShowPlayerDialog(playerid,D_AC_SETTINGS12,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"1. Отключить\n2. Warning\n3. Kick",!"Далее",!"Назад");

			}
			else
			{
				callcmd::acedit(playerid);
			}
		}
		case D_AC_SETTINGS12:
		{
			if (response)
			{
				if (listitem == 0 )
					SendClientMessage(playerid,CGRAY2,!"Настройка teleport в авто: Отключен!");
				else if (listitem == 1 )
					SendClientMessage(playerid,CGRAY2,!"Настройка teleport в автоWarning!");
				else if (listitem == 2 )
					SendClientMessage(playerid,CGRAY2,!"Настройка teleport в автоKick!");
				else return 1;

				new id_ac_status = playerListItem[playerid][0];

				if (id_ac_status == 0){
					AcSettings[acTimeTPCar] = listitem;
					SaveAcSettingsInteger("acTimeTPCar", listitem);
				}
				else if (id_ac_status == 1){
					AcSettings[acChangeCar] = listitem;
					SaveAcSettingsInteger("acChangeCar", listitem);
				}
				else {
					AcSettings[acTPCar] = listitem;
					SaveAcSettingsInteger("acTPCar", listitem);
				}
			}
			else
			{
				ShowPlayerDialog(playerid,D_AC_SETTINGS11,DIALOG_STYLE_LIST,""colserver"Античит: "colwhi"настройка",
				!"Быстрый телепорт в авто(aac-1)\nПодмена авто(aac-2)\nТелепорт в не разрешенный авто(aac-8)",
				!"Далее",!"Закрыть");
			}
		}
		case D_AC_SETTINGS13:
		{
			if (response)
			{
				if (listitem == 0 )
					SendClientMessage(playerid,CGRAY2,!"Телепорт в интерьер: отлючена!");
				else if (listitem == 1 )
					SendClientMessage(playerid,CGRAY2,!"Телепорт в интерьер: Warning!");
				else if (listitem == 2 )
					SendClientMessage(playerid,CGRAY2,!"Телепорт в интерьер: Kick!");
				else return 1;

				AcSettings[acInt] = listitem;
				SaveAcSettingsInteger("acInt", listitem);
			}
			else
			{
				callcmd::acedit(playerid);
			}
		}
	}
	return false;
}


stock ShowSettingsDistStart(playerid)
{
	new tmp_str[50];
	format(tmp_str,sizeof(tmp_str),
		"{FFFFFF}Дистанция минимальная %0.2f\n\nИзменить:",AcSettings[acStartCheck]
		)
	;

	return ShowPlayerDialog(playerid,D_AC_SETTINGS9,DIALOG_STYLE_INPUT,""colserver"Античит: "colwhi"настройка",
	tmp_str,!"Далее",!"Назад");
}


stock ShowSettingsDist(playerid)
{
	new tmp_str[50];
	format(tmp_str,sizeof(tmp_str),
		"{FFFFFF}Дистанция по расстоянию %0.2f\n\nИзменить:",AcSettings[acDistKick]
		)
	;

	return ShowPlayerDialog(playerid,D_AC_SETTINGS4,DIALOG_STYLE_INPUT,""colserver"Античит: "colwhi"настройка",
	tmp_str,!"Далее",!"Назад");
}


stock ShowSettingsDistZ(playerid)
{
	new tmp_str[50];
	format(tmp_str,sizeof(tmp_str),"{FFFFFF}Дистанция по высоте %0.2f\n\nИзменить:",AcSettings[acDistZKick]);
	return ShowPlayerDialog(playerid, D_AC_SETTINGS4, DIALOG_STYLE_INPUT,""colserver"Античит: "colwhi"настройка",
	tmp_str,!"Далее",!"Назад");
}



stock SaveAcSettingsInteger(const field[], var) {
	new query_[128];
	format(query_, sizeof query_, "UPDATE `ac_settings` SET `%s` = '%d' WHERE `id` = '1' LIMIT 1", field, var);
	mysql_tquery(dbHandle, query_, "", ""); 
	return 1;
}


stock SaveAcSettingsFloat(const field[], Float: var) {
	new query_[128];
	format(query_, sizeof query_, "UPDATE `ac_settings` SET `%s` = '%f' WHERE `id` = '1' LIMIT 1", field, var);
	mysql_tquery(dbHandle, query_, "", ""); 
	return 1;
}


stock AddCheater(playerid,type = 0)
{
    static cheat_show;
	if (type == 1){
	    cheat_show = 0;
	    return 1;
	}
	if (GetPVarInt(playerid,!"send_air") > gettime()) return 1;
	SetPVarInt(playerid,!"send_air",gettime()+2);
	new str_id[4];
	valstr(str_id,playerid,false);
	TextDrawSetString(CheatShow[cheat_show], str_id);
	cheat_show++;
	if (cheat_show > 8) cheat_show = 0;
	return 1;
}

new test_log = 0;
s_ac_OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{	
    if (test_log) printf("[DEBUG] OnUnoccupiedVehicleUpdate(vehicleid:%d | playerid:%d | passenger_seat:%d | vel_x: %f | vel_y: %f | vel_z: %f)", 
        vehicleid, playerid, passenger_seat, new_x, new_y, new_z,
        vel_x, vel_y, vel_z
    );
	if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 50) return 0;
	if (CRASH[playerid] == true) return false;
	//if (passenger_seat > 0) return false;
	//GetVehiclePos(vehicleid, new_x, new_y, new_z);
	//new Float:distance = GetPlayerDistanceFromPoint(playerid, new_x, new_y, new_z);
    //if (distance > 100.0) return SendWarningCheatMessageToAdmin(playerid,"Раскидывает тачки");
	/*if (vel_x > -1.5 && vel_x < 1.5)
	{
		if (vel_x >= 1.5 || vel_x <= -1.5 && vel_y >= 1.5 || vel_y <= 1.5 && vel_z >= 0.5 || vel_z <= -0.5) 
            return scmKick(playerid, "Вы были кикнуты по подозрению в читерстве (#Рванка с машины)", 0xC21D00AA);
	}*///
	/*if (GetVehicleModel(vehicleid) != 570 && GetVehicleModel(vehicleid) != 449)
	{
		if (vel_x > 100 || vel_y > 100 || vel_z > 100) SCM(playerid, COLOR_LIGHTRED, " Вы были кикнуты по подозрению в читерстве (#2)"), Kick(playerid);
	}*/
	//#undef passenger_seat, new_x;
    ///#pragma unused bodypart
    //#undef modelid
    return 1;
}