#if defined _fixactor_included
	#endinput
#endif
#define _fixactor_included

new Float:actorPosX[MAX_ACTORS];
new Float:actorPosY[MAX_ACTORS];
new Float:actorPosZ[MAX_ACTORS];

fa_CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation)
{
	new actorid = CreateActor(modelid, X, Y, Z, Rotation);
	if(actorid == INVALID_ACTOR_ID) return INVALID_ACTOR_ID;
    actorPosX[actorid] = X;
    actorPosY[actorid] = Y;
    actorPosZ[actorid] = Z;
	return actorid;
}
#if defined _ALS_CreateActor
	#undef CreateActor
#else
	#define _ALS_CreateActor
#endif
#define CreateActor fa_CreateActor

forward fa_MainTimer();
public fa_MainTimer()
{
	new Float:pos_x, Float:pos_y, Float:pos_z;
	for(new i = GetActorPoolSize(); i >= 0; i--) if(GetActorPos(i, pos_x, pos_y, pos_z) && VectorSize((pos_x - actorPosX[i]), (pos_y - actorPosY[i]), (pos_z - actorPosZ[i])) > 2.0) SetActorPos(i, actorPosX[i], actorPosY[i], actorPosZ[i]);
	return 1;
}

public OnGameModeInit()
{
    SetTimer("fa_MainTimer", (1000 * 10), 1);
	#if defined fa_OnGameModeInit
		return fa_OnGameModeInit();
	#else
	    return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#if defined fa_OnGameModeInit
	forward fa_OnGameModeInit();
#endif
#define OnGameModeInit fa_OnGameModeInit
