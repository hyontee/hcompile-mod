#if !defined MAX_PLAYERS
	#error fps_counter: подключайте инклюд после a_samp/open.mp (нужен MAX_PLAYERS)
#endif

new PlayerText: FPS_PTD[MAX_PLAYERS];
new pFPSCounter[MAX_PLAYERS];
new pFPSValue[MAX_PLAYERS];
new pFPSTimer[MAX_PLAYERS] = {-1, ...};
new bool: pFPSCreated[MAX_PLAYERS];
new bool: pFPSFirstTick[MAX_PLAYERS];

stock CreateFPSTextDraw(playerid)
{
	FPS_PTD[playerid] = CreatePlayerTextDraw(playerid, 7.499990, 314.444396, "FPS 0");
	PlayerTextDrawLetterSize(playerid, FPS_PTD[playerid], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, FPS_PTD[playerid], 1);
	PlayerTextDrawColor(playerid, FPS_PTD[playerid], 0xFFFFFFFF);
	PlayerTextDrawSetShadow(playerid, FPS_PTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, FPS_PTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, FPS_PTD[playerid], 255);
	PlayerTextDrawFont(playerid, FPS_PTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, FPS_PTD[playerid], 1);
	return 1;
}

stock ShowFPSCounter(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;

	if(!pFPSCreated[playerid])
	{
		CreateFPSTextDraw(playerid);
		pFPSCreated[playerid] = true;
	}

	pFPSCounter[playerid] = 0;
	pFPSValue[playerid] = 0;
	pFPSFirstTick[playerid] = true;

	if(pFPSTimer[playerid] != -1)
	{
		KillTimer(pFPSTimer[playerid]);
		pFPSTimer[playerid] = -1;
	}
	pFPSTimer[playerid] = SetTimerEx("UpdateFPSCounter", 1000, true, "i", playerid);

	PlayerTextDrawShow(playerid, FPS_PTD[playerid]);
	return 1;
}

stock HideFPSCounter(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;

	if(pFPSTimer[playerid] != -1)
	{
		KillTimer(pFPSTimer[playerid]);
		pFPSTimer[playerid] = -1;
	}
	if(pFPSCreated[playerid])
	{
		PlayerTextDrawHide(playerid, FPS_PTD[playerid]);
		PlayerTextDrawDestroy(playerid, FPS_PTD[playerid]);
		pFPSCreated[playerid] = false;
	}
	pFPSCounter[playerid] = 0;
	pFPSValue[playerid] = 0;
	pFPSFirstTick[playerid] = false;
	return 1;
}

stock GetPlayerFPS(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
	return pFPSValue[playerid];
}

forward UpdateFPSCounter(playerid);
public UpdateFPSCounter(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid))
	{
		if(playerid >= 0 && playerid < MAX_PLAYERS && pFPSTimer[playerid] != -1)
		{
			KillTimer(pFPSTimer[playerid]);
			pFPSTimer[playerid] = -1;
		}
		return 0;
	}

	if(pFPSFirstTick[playerid])
	{
		pFPSCounter[playerid] = 0;
		pFPSFirstTick[playerid] = false;
		return 1;
	}

	pFPSValue[playerid] = pFPSCounter[playerid];
	pFPSCounter[playerid] = 0;

	if(pFPSValue[playerid] > 999) pFPSValue[playerid] = 999;
	if(pFPSValue[playerid] < 0) pFPSValue[playerid] = 0;

	new str[16];
	format(str, sizeof(str), "FPS %d", pFPSValue[playerid]);
	PlayerTextDrawSetString(playerid, FPS_PTD[playerid], str);
	PlayerTextDrawShow(playerid, FPS_PTD[playerid]);
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect FPS_OnPlayerConnect

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect FPS_OnPlayerDisconnect

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn FPS_OnPlayerSpawn

#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate FPS_OnPlayerUpdate

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit FPS_OnGameModeExit

public FPS_OnPlayerConnect(playerid)
{
	pFPSTimer[playerid] = -1;
	pFPSCreated[playerid] = false;
	pFPSCounter[playerid] = 0;
	pFPSValue[playerid] = 0;
	pFPSFirstTick[playerid] = false;

	#if defined OnPlayerConnect
		return OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

public FPS_OnPlayerDisconnect(playerid, reason)
{
	HideFPSCounter(playerid);

	#if defined OnPlayerDisconnect
		return OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}

public FPS_OnPlayerSpawn(playerid)
{
	ShowFPSCounter(playerid);

	#if defined OnPlayerSpawn
		return OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}

public FPS_OnPlayerUpdate(playerid)
{
	if(playerid >= 0 && playerid < MAX_PLAYERS)
	{
		pFPSCounter[playerid]++;
	}

	#if defined OnPlayerUpdate
		return OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}

public FPS_OnGameModeExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(pFPSTimer[i] != -1)
		{
			KillTimer(pFPSTimer[i]);
			pFPSTimer[i] = -1;
		}
	}

	#if defined OnGameModeExit
		return OnGameModeExit();
	#else
		return 1;
	#endif
}

forward FPS_OnPlayerConnect(playerid);
forward FPS_OnPlayerDisconnect(playerid, reason);
forward FPS_OnPlayerSpawn(playerid);
forward FPS_OnPlayerUpdate(playerid);
forward FPS_OnGameModeExit();
