#if defined _gym_inc
	#endinput
#endif
#define _gym_inc
// GYM
new player_bench[MAX_PLAYERS char];
new player_disallow_rep[MAX_PLAYERS char];
new bench_used[4 char];
new barbell_objects[4];
new gym_[3];
new PlayerText: BenchTD[ MAX_PLAYERS ];
new PlayerText: bench_repslabel[ MAX_PLAYERS ];
new Float:bench_pos[4][4] = {
	{ 2292.85,-957.50,1498.60,90.00 },
	{ 2292.85,-954.49,1498.60,90.00 },
	{ 2292.85,-951.50,1498.60,90.00 },
	{ 2292.85,-948.48,1498.60,90.00 }
};
new Float:barbell_pos[4][6] = {
	{ 2291.46,-957.96,1498.66,0.00,90.00,90.00 },
	{ 2291.47,-954.96,1498.66,0.00,90.00,90.00 },
	{ 2291.46,-951.96,1498.66,0.00,90.00,90.00 },
	{ 2291.47,-948.97,1498.66,0.00,90.00,90.00 }
};
new RingArea;
new Boxing[MAX_PLAYERS];

/*Style - Boxing
BoxProgress[2]
Style[0]
Style - KongFu
KongFuProgress[2]
Style[1]
Stype - FIGHT_STYLE_KNEEHEAD
KickBoxProgress[2]
Style[2*/]

public OnGameModeInit()
{
	CreateObject(14794, 2298.62, -950.66, 1500.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(14782, 2305.24, -954.61, 1498.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 2308.89, -937.12, 1499.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 2289.01, -956.38, 1499.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(14791, 2298.69, -944.03, 1499.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(1985, 2305.55, -941.26, 1500.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 2289.01, -946.76, 1499.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 2313.11, -939.65, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 2293.84, -939.65, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 2303.48, -939.65, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 2308.89, -946.76, 1499.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 2289.01, -937.12, 1499.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 2308.89, -956.38, 1499.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(19397, 2306.12, -961.10, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 2312.53, -961.10, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 2299.70, -961.10, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 2290.07, -961.10, 1499.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(19377, 2293.99, -944.27, 1501.16,   0.00, 270.00, 0.00);
	CreateDynamicObject(19377, 2293.99, -953.90, 1501.16,   0.00, 270.00, 0.00);
	CreateDynamicObject(19377, 2293.99, -963.53, 1501.16,   0.00, 270.00, 0.00);
	CreateDynamicObject(19377, 2304.49, -953.90, 1501.16,   0.00, 270.00, 0.00);
	CreateDynamicObject(19377, 2304.49, -963.53, 1501.16,   0.00, 269.99, 0.00);
	CreateDynamicObject(19377, 2304.49, -944.27, 1501.16,   0.00, 270.00, 0.00);
	CreateDynamicObject(17969, 2308.75, -957.61, 1498.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(4227, 2289.02, -947.72, 1499.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(5069, 2299.53, -941.99, 1498.96,   0.00, 0.00, 270.00);
	CreateDynamicObject(3034, 2294.00, -961.01, 1499.36,   0.00, 0.00, 180.00);
	CreateDynamicObject(3034, 2301.89, -961.01, 1499.36,   0.00, 0.00, 179.99);
	CreateDynamicObject(3034, 2298.00, -961.01, 1499.36,   0.00, 0.00, 179.99);
	CreateDynamicObject(19461, 2306.17, -954.06, 1499.32,   0.00, 0.00, 90.00);
	CreateDynamicObject(1808, 2308.62, -952.60, 1497.57,   0.00, 0.00, 270.00);
	CreateDynamicObject(2099, 2289.14, -940.97, 1497.57,   0.00, 0.00, 90.00);
	CreateDynamicObject(2103, 2295.52, -948.03, 1497.59,   0.00, 0.00, 333.66);
	CreateDynamicObject(2631, 2291.52, -954.48, 1497.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2631, 2291.52, -951.48, 1497.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2631, 2291.52, -948.48, 1497.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2631, 2291.52, -957.48, 1497.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2629, 2292.00, -957.52, 1497.67,   0.00, 0.00, 90.00);
	CreateDynamicObject(2629, 2291.99, -954.52, 1497.67,   0.00, 0.00, 90.00);
	CreateDynamicObject(2629, 2291.99, -951.52, 1497.67,   0.00, 0.00, 90.00);
	CreateDynamicObject(2629, 2291.99, -948.52, 1497.67,   0.00, 0.00, 90.00);
	CreateDynamicObject(2819, 2306.99, -955.35, 1497.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2827, 2305.81, -951.48, 1497.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(1709, 2308.31, -952.43, 1497.57,   0.00, 0.00, 180.00);
	CreateDynamicObject(2915, 2290.43, -957.75, 1497.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(2913, 2289.98, -954.99, 1497.95,   0.00, 90.00, 90.00);
	CreateDynamicObject(2913, 2290.41, -957.11, 1497.96,   0.00, 90.00, 300.00);
	CreateDynamicObject(2913, 2289.83, -958.10, 1497.96,   0.00, 90.00, 90.00);
	CreateDynamicObject(2913, 2290.44, -954.99, 1497.95,   0.00, 90.00, 90.00);
	CreateDynamicObject(2915, 2294.29, -955.90, 1497.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(2915, 2294.68, -956.28, 1497.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(2916, 2294.49, -956.26, 1497.69,   0.00, 0.00, 90.00);
	CreateDynamicObject(2916, 2294.53, -955.89, 1497.69,   0.00, 0.00, 90.00);
	CreateDynamicObject(2916, 2294.73, -955.95, 1497.69,   0.00, 0.00, 115.36);
	CreateDynamicObject(2961, 2306.13, -954.23, 1498.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(2913, 2291.59, -955.72, 1497.86,   0.00, 90.00, 0.00);
	CreateDynamicObject(2913, 2290.34, -951.94, 1497.95,   0.00, 90.00, 90.00);
	CreateDynamicObject(2913, 2289.38, -950.02, 1497.94,   0.00, 352.00, 0.00);
	CreateDynamicObject(2913, 2289.68, -949.59, 1497.76,   0.00, 330.00, 0.00);
	CreateDynamicObject(2611, 2290.61, -939.77, 1499.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(18608, 2297.11, -958.16, 1502.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(18608, 2305.00, -958.16, 1502.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(2626, 2307.45, -957.87, 1498.10,   0.00, 0.00, 270.00);
	CreateDynamicObject(1985, 2306.06, -946.73, 1500.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(1985, 2305.55, -943.55, 1500.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(2068, 2272.32, -955.47, 1533.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(2690, 2307.22, -960.93, 1499.24,   0.00, 0.00, 180.00);
	CreateDynamicObject(1582, 2305.84, -951.81, 1498.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(2370, 2305.57, -951.96, 1497.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(1486, 2306.33, -952.29, 1498.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(1510, 2305.75, -951.11, 1498.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(1717, 2303.68, -950.69, 1497.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1778, 2289.91, -939.73, 1497.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2258, 2293.73, -939.75, 1499.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1421, 2292.31, -940.18, 1498.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(2063, 2289.38, -944.17, 1498.48,   0.00, 0.00, 90.00);
	CreateDynamicObject(2777, 2294.32, -955.36, 1498.08,   0.00, 0.00, 140.00);
	CreateDynamicObject(2632, 2296.75, -958.84, 1497.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(2632, 2299.75, -958.84, 1497.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(2627, 2299.70, -958.58, 1497.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(2627, 2296.81, -958.53, 1497.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(2628, 2291.89, -944.67, 1497.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(2632, 2291.87, -944.26, 1497.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(2630, 2289.72, -946.44, 1497.58,   0.00, 340.00, 0.00);
	CreateDynamicObject(1498, 2305.34, -961.14, 1497.58,   0.00, 0.00, 0.00);

	for( new o; o != sizeof barbell_pos; ++ o ){
		barbell_objects[ o ] = CreateDynamicObject( 2913, barbell_pos[ o ][ 0 ], barbell_pos[ o ][ 1 ], barbell_pos[ o ][ 2 ], barbell_pos[ o ][ 3 ], barbell_pos[ o ][ 4 ], barbell_pos[ o ][ 5 ] );
	}
	CreateDynamic3DTextLabel("Переодеться",-1,-341.7713,124.8646,-42.9600+0.5,3.0,INVALID_PLAYER_ID, INVALID_VEHICLE_ID,6,6);
	CreateDynamic3DTextLabel("Используйте /ring\nЧтобы попасть на ринг",-1,2298.7773,-947.9284,1498.5781+0.2,3.0,INVALID_PLAYER_ID, INVALID_VEHICLE_ID,1,1);
	RingArea = CreateDynamicCube(2307.0757,-952.6057,1502.2460,   2290.8987,-941.4647,1502.2460); // fix ring
	gym_[0] = CreateDynamicPickup(19132, 23, 2229.7566, -1721.5988, 13.5646, .worldid = 0, .interiorid = 0);//спортзал ЛС
	gym_[1] = CreateDynamicPickup(19132, 23, 2306.0449, -960.6892, 1498.5845, .worldid = 1, .interiorid = 0);//gym
	gym_[2] = CreateDynamicPickup(1275, 23, -341.7713,124.8646,-42.9600, .worldid = 6, .interiorid = 6);//gym
	#if defined gym_OnGameModeInit
		gym_OnGameModeInit();
	#endif
	return 1;
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit gym_OnGameModeInit
#if defined gym_OnGameModeInit
	forward gym_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if (areaid == RingArea)
	{
		SetPlayerPos(playerid, 2298.8240, -944.4350, 1499.4240);//, 184.6768
	}
	#if defined gym_OnPlayerEnterDynamicArea
		gym_OnPlayerEnterDynamicArea(playerid, areaid);
	#endif
	return 1;
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea gym_OnPlayerEnterDynamicArea
#if defined gym_OnPlayerEnterDynamicArea
	forward gym_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	ExitGYM(playerid);
	#if defined gym_OnPlayerDeath
		gym_OnPlayerDeath(playerid, killerid, reason);
	#endif
	return 1;
}
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath gym_OnPlayerDeath
#if defined gym_OnPlayerDeath
	forward gym_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (GetPVarInt(playerid, "GymUse"))
	{
		if (((newkeys & 128) && (oldkeys & 128) && (newkeys & KEY_SECONDARY_ATTACK)) && IsPlayerNearBoxing(playerid))
		{
			if ((GetTickCount() - Boxing[playerid]) > 300)
			{
				new data = /*PlayerInfo[playerid][pLastBox]+*/86400;
				if (!GetPVarInt(playerid, "BoxMessage") && data > gettime())
				{
					SendClientMessage(playerid, COLOR_BLUE, !"На сегодня достаточно, приходите завтра!");
					SetPVarInt(playerid, "BoxMessage", 1);
				}
				else
				{
					if (data < gettime() && GetPVarInt(playerid, "TypeStyle") != 0)
					{
						SetPVarInt(playerid, "BoxNum", GetPVarInt(playerid, "BoxNum")+1);
						new 
							str_[16];
						/*switch(GetPVarInt(playerid, "TypeStyle"))
		    			{
	        				case 1: PlayerInfo[playerid][pGymSkill][0]++;
					        case 2: PlayerInfo[playerid][pGymSkill][1]++;
					        case 3: PlayerInfo[playerid][pGymSkill][2]++;
					    }*/
						format(str_, sizeof str_, "~g~HITS:~r~%d", GetPVarInt(playerid, "BoxNum"));
						GameTextForPlayer(playerid, str_, 3000, 4);
						Boxing[playerid] = GetTickCount();
						if (GetPVarInt(playerid, "BoxNum") >= 500)
						{
							SendClientMessage(playerid, COLOR_GREY, !"На сегодня хватит");
							DeletePVar(playerid, "BoxNum");
							//PlayerInfo[playerid][pLastBox] = gettime();
						}
					}
				}
			}
		}
		else if ( ( newkeys & KEY_SECONDARY_ATTACK ) && !( oldkeys & KEY_SECONDARY_ATTACK ) && ( player_bench{playerid} == 0 ) && ( !IsPlayerAttachedObjectSlotUsed( playerid, GetPVarInt(playerid, "BenchPerssIndex") ) ) )
		{
			StartUsingBench(playerid);
		}
		else if ( ( newkeys & KEY_SECONDARY_ATTACK ) && !( oldkeys & KEY_SECONDARY_ATTACK ) && ( player_bench{playerid} == 1 ) && ( IsPlayerAttachedObjectSlotUsed( playerid, GetPVarInt(playerid, "BenchPerssIndex") ) ) )
		{
			StopUsingBench(playerid);
		}
		else if ( ( newkeys & GetPVarInt(playerid, "KeyBench") ) && ( player_bench{playerid} == 1 ) && ( IsPlayerAttachedObjectSlotUsed( playerid, GetPVarInt(playerid, "BenchPerssIndex") ) ) && ( player_disallow_rep{playerid} == 0 ) )
		{
			BenchUse(playerid);
		}
	}
	#if defined gym_OnPlayerKeyStateChange
		gym_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif
	return 1;
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange gym_OnPlayerKeyStateChange
#if defined gym_OnPlayerKeyStateChange
	forward gym_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif
publics: allowPlayerRep( clientid )
{
	if (!IsPlayerConnected(clientid)) return;
	player_disallow_rep{clientid} = 0;
	ApplyAnimation( clientid, "benchpress", "gym_bp_down", 1, 0, 0, 0, 1, 0, 1 );
	PlayerPlaySound( clientid, 1054, 0, 0, 0 );
}
publics: removeBarBellToPlayer( clientid, barbell_id )
{
	if (!IsPlayerConnected(clientid)) return;
	SetCameraBehindPlayer( clientid );
	ClearAnimations( clientid, 1 );
	TogglePlayerControllable( clientid, 1 );
	player_bench{clientid} = 0;
	RemovePlayerAttachedObject( clientid, GetPVarInt(clientid, "BenchPerssIndex") );
	barbell_objects[ barbell_id ] = CreateDynamicObject( 2913, barbell_pos[ barbell_id ][ 0 ], barbell_pos[ barbell_id ][ 1 ], barbell_pos[ barbell_id ][ 2 ], barbell_pos[ barbell_id ][ 3 ], barbell_pos[ barbell_id ][ 4 ], barbell_pos[ barbell_id ][ 5 ] );
}
publics: attachBarBellToPlayer( clientid, barbell_id )
{
	if (!IsPlayerConnected(clientid)) return;
	SetPVarInt(clientid, "BenchPerssIndex", ATTACHED_SLOT_JOB_0);
	SetPlayerAttachedObject(clientid, GetPVarInt(clientid, "BenchPerssIndex"), 2913, 6);
	DestroyDynamicObject( barbell_id );
	switch(random(3))
	{
		case 0:
		{
			PlayerTextDrawSetString(clientid, BenchTD[ clientid ], "PRESS ~r~~k~~CONVERSATION_YES~" );
			SetPVarInt(clientid, "KeyBench", KEY_YES);
		}
		case 1:
		{
			PlayerTextDrawSetString(clientid, BenchTD[ clientid ], "PRESS ~r~~k~~CONVERSATION_NO~" );
			SetPVarInt(clientid, "KeyBench", KEY_NO);
		}
		case 2:
		{
			PlayerTextDrawSetString(clientid, BenchTD[ clientid ], "PRESS ~r~~k~~GROUP_CONTROL_BWD~" );
			SetPVarInt(clientid, "KeyBench", KEY_CTRL_BACK);
		}
	}
	PlayerTextDrawHide( clientid, BenchTD[ clientid ] );
	PlayerTextDrawShow( clientid, BenchTD[ clientid ] );
}
stock getClosestBarBellEx( clientid )
{
	for( new o; o != sizeof barbell_pos; ++ o )
		if ( IsPlayerInRangeOfPoint( clientid, 3.0, barbell_pos[ o ][ 0 ], barbell_pos[ o ][ 1 ], barbell_pos[ o ][ 2 ] ) )
			return o;
	return false;
}
stock getClosestBarBell( clientid )
{
	for( new o; o != sizeof barbell_pos; ++ o )
		if ( IsPlayerInRangeOfPoint( clientid, 3.0, barbell_pos[ o ][ 0 ], barbell_pos[ o ][ 1 ], barbell_pos[ o ][ 2 ] ) )
			return barbell_objects[ o ];

	return false;
}
stock StopUsingBench(playerid)
{
	CallLocalFunction( "OnPlayerExitBenchPress", "ii", playerid, GetPVarInt( playerid, "player_bench_reps" ) );
	player_bench{playerid} = 0;
	ApplyAnimation( playerid, "benchpress", "gym_bp_getoff", 1, 0, 0, 0, 0, 0, 1 );
	SetTimerEx("removeBarBellToPlayer", 3000, false, "ii", playerid, getClosestBarBellEx( playerid ) );

	SetPVarInt( playerid, "player_bench_reps", 0 );

	bench_used{GetPVarInt( playerid, "player_current_bench" )} = 0;
	PlayerTextDrawHide( playerid, BenchTD[ playerid ] );
	DeletePVar(playerid, "KeyBench");

	KillTimer( GetPVarInt( playerid, "player_bench_timer" ) );

	PlayerTextDrawSetString(playerid, bench_repslabel[ playerid ], "RESP: ~r~0" );
	PlayerTextDrawHide( playerid, bench_repslabel[ playerid ] );

}
stock StartUsingBench(playerid)
{
	for( new o; o != sizeof bench_pos; o ++ )
	{
		if ( IsPlayerInRangeOfPoint( playerid, 2.0, bench_pos[ o ][ 0 ], bench_pos[ o ][ 1 ], bench_pos[ o ][ 2 ] ) )
		{
			if ( bench_used{o} == 1){
				return CallLocalFunction( "OnPlayerStartBenchPress", "ii", playerid, 0 );
			}
			CallLocalFunction( "OnPlayerStartBenchPress", "ii", playerid, 1 );

			SetPlayerPos(playerid, bench_pos[ o ][ 0 ], bench_pos[ o ][ 1 ], bench_pos[ o ][ 2 ]);
			SetPlayerFacingAngle( playerid, bench_pos[ o ][ 3 ] );
			ApplyAnimation( playerid, "benchpress", "gym_bp_geton", 1, 0, 0, 0, 1, 0, 1 );

			player_bench{playerid} = 1;
			bench_used{o} = 1;

			SetPVarInt( playerid, "player_current_bench", o );
			SetPlayerCameraPos( playerid, bench_pos[ o ][ 0 ] + 1.5, bench_pos[ o ][ 1 ] - 1.5, bench_pos[ o ][ 2 ] + 0.5 );
			SetPlayerCameraLookAt( playerid, bench_pos[ o ][ 0 ], bench_pos[ o ][ 1 ], bench_pos[ o ][ 2 ] );

			PlayerTextDrawShow( playerid, bench_repslabel[ playerid ] );
			PlayerTextDrawShow( playerid, BenchTD[ playerid ] );

			SetTimerEx("attachBarBellToPlayer", 3850, false, "ii", playerid, getClosestBarBell( playerid ) );
			break;
		}
	}
	return 1;
}
stock BenchUse(playerid)
{
	switch( random( 2 ) )
	{
		case 0: ApplyAnimation( playerid, "benchpress", "gym_bp_up_A", 1, 0, 0, 0, 1, 0, 1 );
		case 1: ApplyAnimation( playerid, "benchpress", "gym_bp_up_B", 1, 0, 0, 0, 1, 0, 1 );
	}
	player_disallow_rep{playerid} = 1;

	SetTimerEx("allowPlayerRep", 2000, false, "i", playerid);
    /*switch(GetPVarInt(playerid, "TypeStyle"))
	{
		case 1: PlayerInfo[playerid][pGymSkill][3]++;
  		case 2: PlayerInfo[playerid][pGymSkill][4]++;
    	case 3: PlayerInfo[playerid][pGymSkill][5]++;
    }*/
	SetPVarInt( playerid, "player_bench_reps", GetPVarInt( playerid, "player_bench_reps" ) + 1 );
	CallLocalFunction( "OnPlayerBenchPress", "ii", playerid, GetPVarInt( playerid, "player_bench_reps" ) );

	new s_string[24];
	format( s_string, sizeof s_string, "RESP: ~r~%d", GetPVarInt( playerid, "player_bench_reps" ) );
	PlayerTextDrawSetString(playerid, bench_repslabel[ playerid ], s_string );
	PlayerTextDrawHide( playerid, bench_repslabel[ playerid ] );
	PlayerTextDrawShow( playerid, bench_repslabel[ playerid ] );
	switch(random(3))
	{
		case 0:
		{
			PlayerTextDrawSetString(playerid, BenchTD[ playerid ], "PRESS ~r~~k~~CONVERSATION_YES~" );
			SetPVarInt(playerid, "KeyBench", KEY_YES);
		}
		case 1:
		{
			PlayerTextDrawSetString(playerid, BenchTD[ playerid ], "PRESS ~r~~k~~CONVERSATION_NO~" );
			SetPVarInt(playerid, "KeyBench", KEY_NO);
		}
		case 2:
		{
			PlayerTextDrawSetString(playerid, BenchTD[ playerid ], "PRESS ~r~~k~~GROUP_CONTROL_BWD~" );
			SetPVarInt(playerid, "KeyBench", KEY_CTRL_BACK);
		}
	}
	PlayerTextDrawHide( playerid, BenchTD[ playerid ] );
	PlayerTextDrawShow( playerid, BenchTD[ playerid ] );
}
publics: OnPlayerStartBenchPress(playerid, result)
{
	if (result) SendClientMessage(playerid, COLOR_BLUE, !"Используйте \"Клавишу указанную внизу экрана\"");
	else SendClientMessage(playerid, COLOR_GREY, !"Тренажер занят");
	return 1;
}
publics: OnPlayerExitBenchPress(playerid, reps) return 1;
publics: OnPlayerBenchPress(playerid, reps)
{
	return 1;
}
stock InitGYM(playerid)
{
	bench_repslabel[playerid] = CreatePlayerTextDraw(playerid, 320.666687, 341.807708, "RESP: ~r~0");
	PlayerTextDrawLetterSize(playerid, bench_repslabel[playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, bench_repslabel[playerid], 2);
	PlayerTextDrawColor(playerid, bench_repslabel[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bench_repslabel[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bench_repslabel[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, bench_repslabel[playerid], 51);
	PlayerTextDrawFont(playerid, bench_repslabel[playerid], 2);
	PlayerTextDrawSetProportional(playerid, bench_repslabel[playerid], 1);

	BenchTD[playerid] = CreatePlayerTextDraw(playerid, 320.333221, 362.962829, "PRESS ~r~Y");
	PlayerTextDrawLetterSize(playerid, BenchTD[playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, BenchTD[playerid], 2);
	PlayerTextDrawColor(playerid, BenchTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BenchTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BenchTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BenchTD[playerid], 51);
	PlayerTextDrawFont(playerid, BenchTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, BenchTD[playerid], 1);

	player_bench{playerid} = 0;
	player_disallow_rep{playerid} = 0;

	SetPVarInt(playerid, "GymUse", 1);
	return 1;
}
gym_OnPlayerPickUpPickup(playerid, pickupid) {
	
	if (pickupid == gym_[0])
	{
		InitGYM(playerid);
		SetPlayerPosAC(playerid,-341.7713,124.8646,-42.9600, 6, 6);
		SetPlayerFacingAngle(playerid,108.3145);
	}
	else if (pickupid == gym_[1])
	{
	    ExitGYM(playerid); 
		SetPlayerPosAC(playerid,-340.0099,126.0212,-42.9600, 6, 6);
		SetPlayerFacingAngle(playerid, 356.3509); 
	}
	else if (pickupid == gym_[2])
	{
	    ShowPlayerDialog(playerid, 252, DIALOG_STYLE_LIST, 
			""colserver"Спортзал: "colwhi"Раздевалка", 
			"[0] Переодеться в форму\n[1] Переодеться в обычную одежду\n"colserver" - Моя статистика", 
			"Выбрать", "Отмена"
		);
	}
	return false;
}


stock ExitGYM(playerid)
{
	PlayerTextDrawDestroy(playerid, bench_repslabel[playerid]);
	PlayerTextDrawDestroy(playerid, BenchTD[playerid]);
	bench_repslabel[playerid] = PlayerText:-1;
	BenchTD[playerid] = PlayerText:-1;
	DeletePVar(playerid, "GymUse");
	DeletePVar(playerid, "BoxNum");
	DeletePVar(playerid, "TypeStyle");
	//if (PlayerInfo[playerid][pPlayerMember] != 0) SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	//else SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
	/*switch(PlayerInfo[playerid][pStyleFight][0]){
		case 5..7: SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pStyleFight][0]);
		default: {
			PlayerInfo[playerid][pStyleFight][0] = 4;
			SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pStyleFight][0]);
		}
	}*/
	DeletePVar(playerid, "playeronring");
	if ( player_bench{playerid} == 1 )
	{
		bench_used{GetPVarInt(playerid, "player_current_bench")} = 0;
		removeBarBellToPlayer( playerid, getClosestBarBellEx( playerid ) );
	}
	DeletePVar(playerid, "BenchPerssIndex");
	return 1;
}
stock IsPlayerNearBoxing(playerid)
{
	if (IsPlayerInRangeOfPoint(playerid, 2.0, 2305.4268,-946.8574,1498.5815) 	||
	IsPlayerInRangeOfPoint(playerid, 2.0, 2305.0125,-943.3639,1498.5072) 		||
	IsPlayerInRangeOfPoint(playerid, 2.0, 2304.9592,-941.1104,1498.5781)) return true;
	return false;
}
CMD:ring(playerid, params[])
{
	if (IsPlayerInRangeOfPoint(playerid, 5.0, 2298.8240,-944.4350,1499.4240) && !GetPVarInt(playerid, "playeronring"))
	{
		SetPlayerPos(playerid, 2298.8240, -944.4350, 1499.4240);//, 184.6768
		SetPVarInt(playerid, "playeronring", 1);
		SendClientMessage(playerid, COLOR_BLUE, !"Для выхода с ринга используйте команду /ring");
	}
	else if (GetPVarInt(playerid, "playeronring"))
	{
		SetPlayerPos(playerid, 2298.5420,-947.9177,1498.5781);//, 184.6768
		DeletePVar(playerid, "playeronring");
	}
	return 1;
}
/*
CMD:ms(playerid) return cmd::mystyle(playerid);
CMD:mystyle(playerid)
{
	new
	string[256],
	resh[50],
	sum[50],
	yint[50],
	myStyleFight[24],
	boxingInfo[6]
	;
	switch(PlayerInfo[playerid][pStyleFight][0]){
		case 5: myStyleFight = "Бокс";
		case 6: myStyleFight = "Конг-Фу";
		case 7: myStyleFight = "Кикбоксинг";
		default: myStyleFight = "Стандартный";
	}
	if (PlayerInfo[playerid][pGymSkill][0] >= 5000) boxingInfo[0] = 1;
	else boxingInfo[0] = 0;
	if (PlayerInfo[playerid][pGymSkill][3] >= 500) boxingInfo[1] = 1;
	else boxingInfo[1] = 0;
	if (boxingInfo[0] == 1 && boxingInfo[1] == 1) {
		resh = "{FFCD00}Стиль познан";
		SetPVarInt(playerid, "Boxing", 1);
	}
	else {
		resh = "{03c03c}Стиль непознан";
		SetPVarInt(playerid, "Boxing", 0);
	}

	if (PlayerInfo[playerid][pGymSkill][1] >= 5000) boxingInfo[2] = 1;
	else boxingInfo[2] = 0;
	if (PlayerInfo[playerid][pGymSkill][4] >= 500) boxingInfo[3] = 1;
	else boxingInfo[3] = 0;
	if (boxingInfo[2] == 1 && boxingInfo[3] == 1) {
		sum = "{FFCD00}Стиль познан";
		SetPVarInt(playerid, "KongFu", 1);
  	}
	else {
		sum = "{03c03c}Стиль непознан";
		SetPVarInt(playerid, "KongFu",0);
	}

	if (PlayerInfo[playerid][pGymSkill][2] >= 5000) boxingInfo[4] = 1;
	else boxingInfo[4] = 0;
	if (PlayerInfo[playerid][pGymSkill][5] >= 500) boxingInfo[5] = 1;
	else boxingInfo[5] = 0;
	if (boxingInfo[4] == 1 && boxingInfo[5] == 1) {
		yint = "{FFCD00}Стиль познан";
		SetPVarInt(playerid, "KickBoxing", 1);
	}
	else {
		yint = "{03c03c}Стиль непознан";
		SetPVarInt(playerid, "KickBoxing", 0);
	}
	format(string,sizeof(string),"{FFFFFF}Cтили\t{FFFFFF}Статус\nБоксерский стиль\t%s\nКонг-Фу стиль\t%s\nКикбоксинг стиль\t%s\n"colgold"Текущий стиль:\t"colsky"%s",resh,sum,yint,myStyleFight);
	show_d(playerid,45,DIALOG_STYLE_TABLIST_HEADERS,""colorange"| Статус занятий в спортзале",string,"Выбор","Закрыть");
	return 1;
}*/



stock gymNextSkill(playerid)
{
	/*if (p_info [ i ] [ exp ] >= ( p_info [ i ] [ level ] + 1 ) * 100 )
	{
		p_info [ i ] [ exp ] -= ( p_info [ i ] [ level ] + 1 ) * 100 ;
		p_info [ i ] [ level ] ++ ;  

		p_info [ i ] [ donate_roulette ] += 1 ;
		update_int_sql ( i, "u_droulette", p_info [ i ] [ donate_roulette ] ) ;
		SendClientMessage ( i, col_white, "{"#cGN"}* {"#cWH"}Вы получили 1 очко для рулетки-удачи, введите {"#cGN"}/roulette{"#cWH"}, чтобы сыграть." ) ;

		SendClientMessage ( i, col_white, "{"#cGN"}* {"#cWH"}Ваш игровой уровень повысился." ) ;  
	}*/
}