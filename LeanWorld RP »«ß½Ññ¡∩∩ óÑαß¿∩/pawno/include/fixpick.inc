#if defined _pickfix_included
	#endinput
#endif
#define _pickfix_included

new pf_pickupValid[MAX_PICKUPS char];
new Float:pf_pickupPosX[MAX_PICKUPS];
new Float:pf_pickupPosY[MAX_PICKUPS];
new Float:pf_pickupPosZ[MAX_PICKUPS];
static playerInPickupID[MAX_PLAYERS];

stock pf_CreatePickup(modelid, type, Float:pos_x, Float:pos_y, Float:pos_z, worldid = 0)
{
	new pick = CreatePickup(modelid, type, pos_x, pos_y, pos_z, worldid);
	if(pick == -1) return -1;
	pf_pickupPosX[pick] = pos_x;
	pf_pickupPosY[pick] = pos_y;
	pf_pickupPosZ[pick] = pos_z;
	pf_pickupValid{pick} = 1;
	return pick;
}
#if defined _ALS_CreatePickup
    #undef CreatePickup
#else
    #define	_ALS_CreatePickup
#endif
#define CreatePickup pf_CreatePickup

stock pf_DestroyPickup(pick)
{
    if(pick == -1 || !pf_pickupValid{pick}) return 0;
    pf_pickupValid{pick} = 0;
    pf_pickupPosX[pick] =
	pf_pickupPosY[pick] =
	pf_pickupPosZ[pick] = 0.0;
    return DestroyPickup(pick);
}
#if defined _ALS_DestroyPickup
    #undef DestroyPickup
#else
    #define	_ALS_DestroyPickup
#endif
#define DestroyPickup pf_DestroyPickup

forward pf_PickTimer();
public pf_PickTimer()
{
    for(new playerid = GetPlayerPoolSize(); playerid >= 0; playerid--) if(IsPlayerConnected(playerid))
    {
		new pick = playerInPickupID[playerid];
		if(pick != -1 && (!pf_pickupValid{pick} || !IsPlayerInRangeOfPoint(playerid, 1.6, pf_pickupPosX[pick], pf_pickupPosY[pick], pf_pickupPosZ[pick]))) playerInPickupID[playerid] = -1;
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid >= MAX_PICKUPS || playerInPickupID[playerid] != -1 || !pf_pickupValid{pickupid} || !IsPlayerInRangeOfPoint(playerid, 1.6, pf_pickupPosX[pickupid], pf_pickupPosY[pickupid], pf_pickupPosZ[pickupid])) return 1;
	playerInPickupID[playerid] = pickupid;
	#if defined pf_OnPlayerPickUpPickup
		return pf_OnPlayerPickUpPickup(playerid, pickupid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define _ALS_OnPlayerPickUpPickup
#endif
#if defined pf_OnPlayerPickUpPickup
	forward pf_OnPlayerPickUpPickup(playerid, pickupid);
#endif
#define OnPlayerPickUpPickup pf_OnPlayerPickUpPickup

public OnGameModeInit()
{
	SetTimer("pf_PickTimer", 200, 1);
	#if defined pf_OnGameModeInit
		return pf_OnGameModeInit();
	#else
	    return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#if defined pf_OnGameModeInit
	forward pf_OnGameModeInit();
#endif
#define OnGameModeInit pf_OnGameModeInit

#define IsValidPickup(%0) 	(pf_pickupValid{%0})
#define GetPickupPosX(%0) 	(pf_pickupPosX[%0])
#define GetPickupPosY(%0) 	(pf_pickupPosY[%0])
#define GetPickupPosZ(%0) 	(pf_pickupPosZ[%0])
