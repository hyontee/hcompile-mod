#if defined _BR_KVEST_INC_
	#endinput
#endif
#define _BR_KVEST_INC_

// ID ˜˜˜˜˜˜˜˜
enum
{
	DIALOG_KVEST_INTRO = 5000,
	DIALOG_KVEST_CHAPTER1,
	DIALOG_KVEST_CHAPTER2,
	DIALOG_KVEST_CHAPTER3,
	DIALOG_KVEST_ENDING
};

// ˜˜˜˜˜˜ ˜˜˜˜˜˜
enum
{
	KVEST_STAGE_NONE = 0,
	KVEST_STAGE_INTRO,
	KVEST_STAGE_CHAPTER1_READY,
	KVEST_STAGE_CHAPTER1_DONE,
	KVEST_STAGE_CHAPTER2_READY,
	KVEST_STAGE_CHAPTER2_DONE,
	KVEST_STAGE_CHAPTER3_READY,
	KVEST_STAGE_CHAPTER3_DONE,
	KVEST_STAGE_COMPLETED
};

// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜
new g_KvestStage[MAX_PLAYERS];
new g_KvestDuelWins[MAX_PLAYERS];
new g_KvestNPC[MAX_PLAYERS]; // ID NPC ˜˜˜˜˜˜˜

// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜
#define KVEST_VICTOR_X 1752.1234
#define KVEST_VICTOR_Y -2050.5678
#define KVEST_VICTOR_Z 13.5432
#define KVEST_VICTOR_A 180.0

// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜
#define KVEST_ARENA1_X 1400.0
#define KVEST_ARENA1_Y -1400.0
#define KVEST_ARENA1_Z 10.0
#define KVEST_ARENA1_A 0.0

#define KVEST_ARENA2_X 1500.0
#define KVEST_ARENA2_Y -1500.0
#define KVEST_ARENA2_Z 10.0
#define KVEST_ARENA2_A 90.0

// ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜, ˜˜˜˜ ˜˜˜ ˜˜ ˜˜˜˜˜˜˜˜˜˜
#if !defined COLOR_RED
	#define COLOR_RED    0xE0584BFF
#endif
#if !defined COLOR_GREY
	#define COLOR_GREY   0xAAAAAAFF
#endif
#if !defined COLOR_WHITE
	#define COLOR_WHITE  0xFFFFFFFF
#endif
#if !defined COLOR_GREEN
	#define COLOR_GREEN  0x00FF00FF
#endif
#if !defined COLOR_YELLOW
	#define COLOR_YELLOW 0xFFFF00FF
#endif

// ALS Hooking for callbacks
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#if defined Kvest_OnPlayerConnect
	forward Kvest_OnPlayerConnect(playerid);
#endif
#define OnPlayerConnect Kvest_OnPlayerConnect

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#if defined Kvest_OnPlayerDisconnect
	forward Kvest_OnPlayerDisconnect(playerid);
#endif
#define OnPlayerDisconnect Kvest_OnPlayerDisconnect

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#if defined Kvest_OnPlayerSpawn
	forward Kvest_OnPlayerSpawn(playerid);
#endif
#define OnPlayerSpawn Kvest_OnPlayerSpawn

// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜
stock Kvest_InitPlayer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	g_KvestStage[playerid] = KVEST_STAGE_NONE;
	g_KvestDuelWins[playerid] = 0;
	g_KvestNPC[playerid] = INVALID_ACTOR_ID;
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ NPC ˜˜˜˜˜˜˜
stock Kvest_CreateNPC(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_KvestNPC[playerid] != INVALID_ACTOR_ID) return 0;
	
	// ˜˜˜˜˜˜˜ NPC ˜ ˜˜˜˜˜˜ 170 (˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜)
	g_KvestNPC[playerid] = CreateActor(170, KVEST_VICTOR_X, KVEST_VICTOR_Y, KVEST_VICTOR_Z, KVEST_VICTOR_A);
	
	if(g_KvestNPC[playerid] != INVALID_ACTOR_ID)
	{
		ApplyAnimation(g_KvestNPC[playerid], "PED", "IDLE_STANCE", 4.1, 1, 1, 1, 1, 1);
		printf("[Kvest] NPC ˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜ %d", playerid);
	}
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ NPC
stock Kvest_DestroyNPC(playerid)
{
	if(g_KvestNPC[playerid] != INVALID_ACTOR_ID)
	{
		DestroyActor(g_KvestNPC[playerid]);
		g_KvestNPC[playerid] = INVALID_ACTOR_ID;
	}
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜
stock bool:Kvest_IsNearVictor(playerid)
{
	if(!IsPlayerConnected(playerid)) return false;
	if(g_KvestNPC[playerid] == INVALID_ACTOR_ID) return false;
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	
	new Float:dist = GetDistanceBetweenPoints3D(x, y, z, KVEST_VICTOR_X, KVEST_VICTOR_Y, KVEST_VICTOR_Z);
	
	return (dist < 5.0);
}

// ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜
stock Float:GetDistanceBetweenPoints3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    new Float:dx = x1 - x2;
    new Float:dy = y1 - y2;
    new Float:dz = z1 - z2;
    return floatsqroot((dx * dx) + (dy * dy) + (dz * dz));
}

// ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜
stock Kvest_StartIntro(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_KvestStage[playerid] != KVEST_STAGE_NONE) return 0;
	
	g_KvestStage[playerid] = KVEST_STAGE_INTRO;
	
	// ˜˜˜˜˜˜˜ NPC
	Kvest_CreateNPC(playerid);
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜
	SetPlayerPos(playerid, KVEST_VICTOR_X + 2.0, KVEST_VICTOR_Y, KVEST_VICTOR_Z);
	SetPlayerFacingAngle(playerid, KVEST_VICTOR_A);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, false);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜ 1 ˜˜˜˜˜˜˜
	SetTimerEx("Kvest_ShowIntroDialog", 1000, false, "i", playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
forward Kvest_ShowIntroDialog(playerid);
public Kvest_ShowIntroDialog(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	
	new dialogText[2048];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n\n"
		"˜˜˜˜˜˜, %s. ˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜, ˜ ˜ ˜˜˜˜˜ ˜ ˜˜˜˜ ˜˜˜˜˜˜˜˜˜.\n\n"
		"˜ ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜˜ ˜ ˜˜˜˜˜, ˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜ ˜ ˜˜˜˜˜.\n\n"
		"˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜, ˜˜ ˜˜˜˜˜ ˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜.\n\n"
		"˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜? ˜ ˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜.\n\n"
		"{CCCCCC}˜˜˜˜˜˜, ˜˜˜ ˜˜˜˜˜˜:", name);
	
	Dialog_Open(playerid, "KvestIntroResponse", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜ ˜˜˜˜˜˜", dialogText, "˜˜˜˜˜˜˜ ˜˜˜˜˜", "˜˜˜˜˜˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
Dialog_Response:KvestIntroResponse(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		// ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜˜: {FFFFFF}˜˜˜˜˜˜, ˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜.");
		g_KvestStage[playerid] = KVEST_STAGE_NONE;
		Kvest_DestroyNPC(playerid);
		TogglePlayerControllable(playerid, true);
		return 1;
	}
	
	// ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜
	g_KvestStage[playerid] = KVEST_STAGE_CHAPTER1_READY;
	TogglePlayerControllable(playerid, true);
	
	new dialogText[1024];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n\n"
		"˜˜˜˜˜˜˜! ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜ ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜, ˜˜˜˜˜˜.\n\n"
		"˜˜ ˜˜˜˜˜˜˜, ˜˜ ˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜.\n\n"
		"{CCCCCC}˜˜˜˜˜, ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜.");
	
	Dialog_Open(playerid, "KvestChapter1Start", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜ 1: ˜˜˜˜˜˜ ˜˜˜", dialogText, "˜˜ ˜˜˜˜˜!", "˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜ 1
Dialog_Response:KvestChapter1Start(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜˜: {FFFFFF}˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜.");
		return 1;
	}
	
	Kvest_StartChapter1(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜ 1
stock Kvest_StartChapter1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_KvestStage[playerid] != KVEST_STAGE_CHAPTER1_READY) return 0;
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜ 1
	SetTimerEx("Kvest_TeleportToArena1", 500, false, "i", playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜ 1
forward Kvest_TeleportToArena1(playerid);
public Kvest_TeleportToArena1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	SetPlayerPos(playerid, KVEST_ARENA1_X, KVEST_ARENA1_Y, KVEST_ARENA1_Z);
	SetPlayerFacingAngle(playerid, KVEST_ARENA1_A);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 100); // ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜ ˜˜˜˜˜
	SetCameraBehindPlayer(playerid);
	
	// ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜
	GivePlayerWeapon(playerid, WEAPON_KNIFE, 1);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0.0);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜
	new dialogText[1024];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜ (˜˜ ˜˜˜˜˜):{FFFFFF}\n\n"
		"˜˜˜ ˜ ˜˜˜˜˜. ˜˜˜˜ ˜˜˜ ˜˜˜˜ ˜˜˜˜.\n\n"
		"˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜, ˜˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜.\n\n"
		"{CCCCCC}˜˜˜˜˜, ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜.");
	
	Dialog_Open(playerid, "KvestDuel1Start", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜ ˜1", dialogText, "˜˜˜˜˜˜!", "˜˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜
Dialog_Response:KvestDuel1Start(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜
		SetPlayerVirtualWorld(playerid, 0);
		SpawnPlayer(playerid);
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜˜: {FFFFFF}˜˜˜˜˜, ˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜...");
		return 1;
	}
	
	Kvest_StartDuelChapter1(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜ 1
stock Kvest_StartDuelChapter1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, COLOR_RED, "{FF0000}˜˜˜˜˜ ˜˜˜˜˜˜˜!");
	
	// ˜˜˜˜˜˜˜ NPC-˜˜˜˜˜˜˜˜˜˜ (˜˜˜˜, ˜˜˜˜ 171)
	new actorid = CreateActor(171, KVEST_ARENA1_X + 5.0, KVEST_ARENA1_Y, KVEST_ARENA1_Z, 180.0);
	if(actorid != INVALID_ACTOR_ID)
	{
		ApplyAnimation(actorid, "PED", "FIGHT_STANCE", 4.1, 1, 1, 1, 1, 1);
	}
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	SetTimerEx("Kvest_CheckDuel1Win", 1000, true, "i", playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜ ˜˜˜˜˜ 1
forward Kvest_CheckDuel1Win(playerid);
public Kvest_CheckDuel1Win(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	// ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	new Float:health;
	GetPlayerHealth(playerid, health);
	
	if(health < 20.0)
	{
		// ˜˜˜˜˜ ˜˜˜˜˜˜˜˜
		KillTimer(GetTimerID("Kvest_CheckDuel1Win"));
		SendClientMessage(playerid, COLOR_RED, "{FF0000}˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜!");
		
		new dialogText[1024];
		format(dialogText, sizeof(dialogText),
			"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n\n"
			"˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜.\n\n"
			"˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜?\n\n"
			"{CCCCCC}˜˜˜˜˜˜:");
		
		Dialog_Open(playerid, "KvestDuel1Retry", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜˜˜˜˜", dialogText, "˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜", "˜˜˜˜˜˜˜˜˜");
		
		return 1;
	}
	
	// ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜ 15 ˜˜˜˜˜˜ (˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜ ˜˜ ˜˜˜˜˜˜ ˜˜˜ ˜ NPC)
	static duelTimer[MAX_PLAYERS];
	if(duelTimer[playerid]++ >= 15)
	{
		KillTimer(GetTimerID("Kvest_CheckDuel1Win"));
		duelTimer[playerid] = 0;
		Kvest_OnDuelWinChapter1(playerid);
	}
	
	return 1;
}

// ˜˜˜˜˜˜ ˜ ˜˜˜˜˜ 1
Dialog_Response:KvestDuel1Retry(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		// ˜˜˜˜˜ ˜˜˜˜˜˜
		SetPlayerVirtualWorld(playerid, 0);
		SpawnPlayer(playerid);
		g_KvestStage[playerid] = KVEST_STAGE_NONE;
		Kvest_DestroyNPC(playerid);
		return 1;
	}
	
	// ˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜
	Kvest_TeleportToArena1(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜˜˜˜ 1
stock Kvest_OnDuelWinChapter1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	g_KvestStage[playerid] = KVEST_STAGE_CHAPTER1_DONE;
	g_KvestDuelWins[playerid]++;
	
	SendClientMessage(playerid, COLOR_GREEN, "{00FF00}˜˜ ˜˜˜˜˜˜˜!");
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid, KVEST_VICTOR_X + 2.0, KVEST_VICTOR_Y, KVEST_VICTOR_Z);
	SetPlayerFacingAngle(playerid, KVEST_VICTOR_A);
	TogglePlayerControllable(playerid, false);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	new dialogText[1024];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n\n"
		"˜˜˜˜˜˜˜! ˜ ˜˜˜˜, ˜˜˜ ˜˜ ˜˜˜˜˜˜˜.\n\n"
		"˜˜ ˜˜˜ ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜. ˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜.\n\n"
		"˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜, ˜˜˜˜˜˜˜, ˜˜˜˜˜˜ ˜˜˜˜˜˜˜. ˜˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜.\n\n"
		"˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜, ˜˜˜ ˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜?\n\n"
		"{CCCCCC}˜˜˜˜˜˜:");
	
	Dialog_Open(playerid, "KvestChapter2Accept", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜ 2: ˜˜˜˜˜ ˜˜˜˜˜˜˜", dialogText, "˜˜˜˜˜˜", "˜˜˜˜˜˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜˜˜ ˜˜˜˜˜ 2
Dialog_Response:KvestChapter2Accept(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		// ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜˜: {FFFFFF}˜˜˜˜˜˜˜, ˜˜˜ ˜˜˜˜˜˜˜˜˜˜. ˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜.");
		TogglePlayerControllable(playerid, true);
		g_KvestStage[playerid] = KVEST_STAGE_CHAPTER1_DONE;
		return 1;
	}
	
	g_KvestStage[playerid] = KVEST_STAGE_CHAPTER2_READY;
	Kvest_StartChapter2(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜ 2
stock Kvest_StartChapter2(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_KvestStage[playerid] != KVEST_STAGE_CHAPTER2_READY) return 0;
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜ 2
	SetTimerEx("Kvest_TeleportToArena2", 500, false, "i", playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜ 2
forward Kvest_TeleportToArena2(playerid);
public Kvest_TeleportToArena2(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	SetPlayerPos(playerid, KVEST_ARENA2_X, KVEST_ARENA2_Y, KVEST_ARENA2_Z);
	SetPlayerFacingAngle(playerid, KVEST_ARENA2_A);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 200);
	SetCameraBehindPlayer(playerid);
	
	// ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜
	GivePlayerWeapon(playerid, WEAPON_BAT, 1);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 50.0);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	new dialogText[1024];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜ (˜˜ ˜˜˜˜˜):{FFFFFF}\n\n"
		"˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜.\n\n"
		"˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜˜.\n\n"
		"{CCCCCC}˜˜˜˜˜, ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜.");
	
	Dialog_Open(playerid, "KvestChapter2Action", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜ 2: ˜˜˜˜˜˜", dialogText, "˜˜˜˜˜˜ ˜˜˜˜˜", "˜˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜ 2
Dialog_Response:KvestChapter2Action(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		SetPlayerVirtualWorld(playerid, 0);
		SpawnPlayer(playerid);
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜˜: {FFFFFF}˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜?");
		return 1;
	}
	
	Kvest_StartDuelChapter2(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜ 2
stock Kvest_StartDuelChapter2(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, COLOR_RED, "{FF0000}˜˜˜˜˜˜˜˜! ˜˜ ˜˜˜˜ ˜˜˜˜˜˜!");
	
	// ˜˜˜˜˜˜˜ 2 NPC-˜˜˜˜˜˜˜˜˜˜
	new actor1 = CreateActor(172, KVEST_ARENA2_X + 3.0, KVEST_ARENA2_Y, KVEST_ARENA2_Z, 180.0);
	new actor2 = CreateActor(173, KVEST_ARENA2_X - 3.0, KVEST_ARENA2_Y, KVEST_ARENA2_Z, 180.0);
	
	if(actor1 != INVALID_ACTOR_ID) ApplyAnimation(actor1, "PED", "FIGHT_STANCE", 4.1, 1, 1, 1, 1, 1);
	if(actor2 != INVALID_ACTOR_ID) ApplyAnimation(actor2, "PED", "FIGHT_STANCE", 4.1, 1, 1, 1, 1, 1);
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	SetTimerEx("Kvest_CheckDuel2Win", 1000, true, "i", playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜ ˜˜˜˜˜ 2
forward Kvest_CheckDuel2Win(playerid);
public Kvest_CheckDuel2Win(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	static duelTimer2[MAX_PLAYERS];
	if(duelTimer2[playerid]++ >= 20)
	{
		KillTimer(GetTimerID("Kvest_CheckDuel2Win"));
		duelTimer2[playerid] = 0;
		Kvest_OnDuelWinChapter2(playerid);
	}
	
	return 1;
}

// ˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜˜˜˜ 2
stock Kvest_OnDuelWinChapter2(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	g_KvestStage[playerid] = KVEST_STAGE_CHAPTER2_DONE;
	g_KvestDuelWins[playerid]++;
	
	SendClientMessage(playerid, COLOR_GREEN, "{00FF00}˜˜ ˜˜˜˜˜˜˜!");
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid, KVEST_VICTOR_X + 2.0, KVEST_VICTOR_Y, KVEST_VICTOR_Z);
	SetPlayerFacingAngle(playerid, KVEST_VICTOR_A);
	TogglePlayerControllable(playerid, false);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	new dialogText[1024];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n\n"
		"˜˜˜˜˜˜˜˜˜˜˜, ˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜ ˜˜˜˜˜.\n\n"
		"˜˜ ˜˜˜˜˜˜˜, ˜˜˜ ˜ ˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜.\n\n"
		"˜˜ ˜˜˜˜˜˜˜ ˜˜˜ ˜ ˜˜ ˜ ˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜.\n\n"
		"˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜ ˜˜˜˜˜ ˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜?\n\n"
		"{CCCCCC}˜˜˜˜˜˜:");
	
	Dialog_Open(playerid, "KvestChapter3Accept", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜ 3: ˜˜˜˜˜", dialogText, "˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜!", "˜˜˜, ˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜˜˜ ˜˜˜˜˜ 3
Dialog_Response:KvestChapter3Accept(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜˜: {FFFFFF}˜ ˜˜ ˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜˜˜˜˜. ˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜...");
		TogglePlayerControllable(playerid, true);
		g_KvestStage[playerid] = KVEST_STAGE_CHAPTER2_DONE;
		return 1;
	}
	
	g_KvestStage[playerid] = KVEST_STAGE_CHAPTER3_READY;
	Kvest_StartChapter3(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜ 3
stock Kvest_StartChapter3(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_KvestStage[playerid] != KVEST_STAGE_CHAPTER3_READY) return 0;
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜
	SetPlayerPos(playerid, KVEST_ARENA1_X, KVEST_ARENA1_Y, KVEST_ARENA1_Z);
	SetPlayerFacingAngle(playerid, KVEST_ARENA1_A);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 300);
	SetCameraBehindPlayer(playerid);
	
	// ˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜
	GivePlayerWeapon(playerid, WEAPON_KATANA, 1);
	GivePlayerWeapon(playerid, WEAPON_DESERT_EAGLE, 100);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	new dialogText[1024];
	format(dialogText, sizeof(dialogText),
		"{FF6600}˜˜˜˜˜:{FFFFFF}\n\n"
		"˜˜ ˜˜˜, ˜ ˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜? ˜˜, ˜˜ ˜˜˜˜˜˜˜˜˜˜.\n\n"
		"˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜ ˜˜˜˜.\n\n"
		"˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜˜ ˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜.\n\n"
		"{CCCCCC}˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜?");
	
	Dialog_Open(playerid, "KvestFinalDuelStart", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜: ˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜", dialogText, "˜˜˜˜˜˜!", "˜˜˜˜˜˜˜");
	
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜
Dialog_Response:KvestFinalDuelStart(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		SetPlayerVirtualWorld(playerid, 0);
		SpawnPlayer(playerid);
		SendClientMessage(playerid, COLOR_GREY, "{999999}˜˜˜˜˜: {FFFFFF}˜˜˜˜, ˜˜˜ ˜ ˜˜˜˜˜˜!");
		g_KvestStage[playerid] = KVEST_STAGE_CHAPTER2_DONE;
		return 1;
	}
	
	Kvest_StartFinalDuel(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜
stock Kvest_StartFinalDuel(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, COLOR_RED, "{FF0000}˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜!");
	
	// ˜˜˜˜˜˜˜ ˜˜˜˜˜
	new actorid = CreateActor(174, KVEST_ARENA1_X + 5.0, KVEST_ARENA1_Y, KVEST_ARENA1_Z, 180.0);
	if(actorid != INVALID_ACTOR_ID)
	{
		ApplyAnimation(actorid, "PED", "FIGHT_STANCE", 4.1, 1, 1, 1, 1, 1);
	}
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	SetTimerEx("Kvest_CheckFinalDuelWin", 1000, true, "i", playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
forward Kvest_CheckFinalDuelWin(playerid);
public Kvest_CheckFinalDuelWin(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	static finalTimer[MAX_PLAYERS];
	if(finalTimer[playerid]++ >= 25)
	{
		KillTimer(GetTimerID("Kvest_CheckFinalDuelWin"));
		finalTimer[playerid] = 0;
		Kvest_OnFinalDuelWin(playerid);
	}
	
	return 1;
}

// ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
stock Kvest_OnFinalDuelWin(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	g_KvestStage[playerid] = KVEST_STAGE_CHAPTER3_DONE;
	g_KvestDuelWins[playerid]++;
	
	SendClientMessage(playerid, COLOR_GREEN, "{00FF00}˜˜ ˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜!");
	
	// ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid, KVEST_VICTOR_X + 2.0, KVEST_VICTOR_Y, KVEST_VICTOR_Z);
	SetPlayerFacingAngle(playerid, KVEST_VICTOR_A);
	TogglePlayerControllable(playerid, false);
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
	new dialogText[2048];
	format(dialogText, sizeof(dialogText),
		"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n\n"
		"˜˜ ˜˜˜˜˜˜ ˜˜˜! ˜ ˜˜˜˜ ˜˜˜˜˜, ˜˜˜˜˜.\n\n"
		"{00FF00}˜˜˜˜˜˜˜:{FFFFFF}\n"
		"˜˜˜˜˜˜˜, ˜˜˜ ˜˜˜˜ ˜˜˜˜. ˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜!\n\n"
		"{FF9900}˜˜˜˜˜˜:{FFFFFF}\n"
		"˜˜˜˜˜˜ ˜˜ ˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜˜. ˜˜ ˜˜˜˜˜ ˜ ˜˜˜˜ ˜˜˜˜ ˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜, ˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜.\n\n"
		"˜˜˜˜˜˜˜˜˜ ˜˜ ˜ ˜˜˜˜.\n\n"
		"{CCCCCC}˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜!");
	
	Dialog_Open(playerid, "KvestEnding", DIALOG_STYLE_MSGBOX, "{E0584B}˜˜˜˜˜ ˜˜˜˜˜˜˜", dialogText, "˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜!", "");
	
	return 1;
}

// ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
Dialog_Response:KvestEnding(playerid, response, listitem, inputtext[])
{
	Kvest_GiveRewards(playerid);
	return 1;
}

// ˜˜˜˜˜˜ ˜˜˜˜˜˜
stock Kvest_GiveRewards(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	g_KvestStage[playerid] = KVEST_STAGE_COMPLETED;
	
	// ˜˜˜˜ ˜˜˜˜˜˜
	GivePlayerMoney(playerid, 500000);
	
	// ˜˜˜˜˜˜˜˜˜˜˜
	SendClientMessage(playerid, COLOR_GREEN, "{00FF00}+ $500 000");
	SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜! ˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜.");
	
	// ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜
	TogglePlayerControllable(playerid, true);
	Kvest_DestroyNPC(playerid);
	
	return 1;
}

// ˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜
CMD:kvest(playerid, params[])
{
	if(!IsPlayerConnected(playerid)) return 1;
	
	Kvest_StartIntro(playerid);
	return 1;
}

// ˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
public OnPlayerConnect(playerid)
{
	Kvest_InitPlayer(playerid);
	#if defined Kvest_OnPlayerConnect_After
		return Kvest_OnPlayerConnect_After(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#if defined Kvest_OnPlayerConnect_After
	forward Kvest_OnPlayerConnect_After(playerid);
#endif
#define OnPlayerConnect Kvest_OnPlayerConnect_After

// ˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
public OnPlayerDisconnect(playerid)
{
	Kvest_DestroyNPC(playerid);
	#if defined Kvest_OnPlayerDisconnect_After
		return Kvest_OnPlayerDisconnect_After(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#if defined Kvest_OnPlayerDisconnect_After
	forward Kvest_OnPlayerDisconnect_After(playerid);
#endif
#define OnPlayerDisconnect Kvest_OnPlayerDisconnect_After

// ˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜
public OnPlayerSpawn(playerid)
{
	// ˜˜˜˜ ˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜ - ˜˜˜˜˜˜˜˜˜˜
	if(g_KvestStage[playerid] == KVEST_STAGE_CHAPTER1_READY)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "{FFFF00}˜˜˜˜˜˜˜˜˜˜˜: {FFFFFF}˜˜ ˜˜˜˜˜ ˜ ˜˜˜˜˜˜ ˜˜˜˜˜! ˜˜˜˜˜˜ /kvest ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜.");
	}
	else if(g_KvestStage[playerid] == KVEST_STAGE_CHAPTER2_READY)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "{FFFF00}˜˜˜˜˜˜˜˜˜˜˜: {FFFFFF}˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜! ˜˜˜˜˜˜ /kvest ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜.");
	}
	else if(g_KvestStage[playerid] == KVEST_STAGE_CHAPTER3_READY)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "{FFFF00}˜˜˜˜˜˜˜˜˜˜˜: {FFFFFF}˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜! ˜˜˜˜˜˜ /kvest ˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜.");
	}
	else if(g_KvestStage[playerid] == KVEST_STAGE_COMPLETED)
	{
		SendClientMessage(playerid, COLOR_GREEN, "{00FF00}˜˜ ˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜˜!");
	}
	
	#if defined Kvest_OnPlayerSpawn_After
		return Kvest_OnPlayerSpawn_After(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#if defined Kvest_OnPlayerSpawn_After
	forward Kvest_OnPlayerSpawn_After(playerid);
#endif
#define OnPlayerSpawn Kvest_OnPlayerSpawn_After
