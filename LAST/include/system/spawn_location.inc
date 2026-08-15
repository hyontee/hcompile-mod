#if defined _BR_SPAWN_LOCATION_INC_
	#endinput
#endif
#define _BR_SPAWN_LOCATION_INC_

#define SPAWN_GUI_ID            (50)

// ID в пакете m / t — индексы карточек клиента (SpawnLocationItem.id), не place из JSON.
#define SPAWN_UI_FRACTION       (0)
#define SPAWN_UI_VOKZAL         (1)
#define SPAWN_UI_LAST           (2)
#define SPAWN_UI_GARAGE         (3)
#define SPAWN_UI_HOME           (4)
#define SPAWN_UI_FAMILY_GARAGE  (5)
#define SPAWN_UI_FAMILY_HOME    (6)
#define SPAWN_UI_YACHT          (7)

// Внутренние place-id для спавна на сервере (совпадают с place в arrays.xml клиента).
#define SPAWN_LOC_VOKZAL        (0)
#define SPAWN_LOC_LAST          (1)
#define SPAWN_LOC_FRACTION      (2)
#define SPAWN_LOC_GARAGE        (3)
#define SPAWN_LOC_HOME          (4)
#define SPAWN_LOC_YACHT         (5)
#define SPAWN_LOC_FAMILY_GARAGE (6)
#define SPAWN_LOC_FAMILY_HOME   (7)

forward SpawnLoc_OnPlayerDisconnect(playerid);
forward SpawnLoc_PeriodicSaveTick();
forward SpawnLoc_DelayedOpen(playerid);
forward SpawnLoc_FallbackOpenAfterFam(playerid);
forward SpawnLoc_ReviveFromAccidentalDeath(playerid);
forward SpawnLoc_NotifyRestartPending(playerid);
forward SpawnLoc_SyncHouseInterior(playerid);
forward Hospital_ResolveReconnectSpawn(playerid);
forward bool:Hospital_HasUnfinishedSession(playerid);
forward Hospital_ApplyUnfinishedSessionSpawn(playerid);
forward Float:Hospital_GetUnfinishedSessionHP(playerid);
forward bool:Hospital_IsReservedSpawnPos(Float:x, Float:y, Float:z);
forward Hospital_SanitizePersistedSpawnPos(playerid);
forward Hospital_GetBranchVW(branch);
forward Hospital_UpdateGreenZone(playerid);
forward Hospital_BedProxEnsure(playerid);
forward ChiefDoctor_OnEnterHospital(playerid);
forward Hospital_UnlockWoundCamera(playerid);
forward ShowPlayerGUI(playerid, guiid, Node:json);
forward OnPacketIncoming(playerid, guiid, Node:json);
forward House_RefreshInteriorExit(houseid);
forward House_RefreshInteriorExtras(houseid);
forward GetPlayerHouseSlot(playerid);
forward Family_GetHouseSlotByPlayer(playerid);
forward Shop_IsInShop(playerid);
forward House_GetInteriorVW(houseid);
forward House_GetInteriorSpawnPos(houseid, &Float:x, &Float:y, &Float:z, &Float:a);
forward House_EnterInterior(playerid, houseid);
forward House_TeleportPlayerToInterior(playerid, houseid);
forward House_StreamerRefreshInterior(playerid, houseid);
forward Player_FixInteriorWorldLeak(playerid);
forward SpawnLoc_RestoreSkinDelayed(playerid);
forward Inv_TryApplyWornAccessories(playerid);
forward Inv_ApplyWornAccessoriesDelayed(playerid);

// SetSpawnInfo принимает только GTA-скины 0..311; донат (>311) надевается после SpawnPlayer.
stock SpawnLoc_GetSpawnInfoSkin(playerid)
{
	new skin = Player[playerid][pSkin];
	if(skin < 1)
		return 74;
	if(skin > 311)
		return 74;
	return skin;
}

stock SpawnLoc_ApplyFullSkin(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	new skin = Player[playerid][pSkin];
	if(skin < 1)
		skin = 74;

	SetPlayerSkin(playerid, skin);
	Inv_TryApplyWornAccessories(playerid);

	if(skin > 311)
		SetTimerEx("SpawnLoc_RestoreSkinDelayed", 400, false, "i", playerid);

	return 1;
}

public SpawnLoc_RestoreSkinDelayed(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	new skin = Player[playerid][pSkin];
	if(skin < 1) skin = 74;
	SetPlayerSkin(playerid, skin);
	Inv_TryApplyWornAccessories(playerid);
	return 1;
}

stock SpawnLoc_FinalizeWorldSpawn(playerid, Float:sx, Float:sy, Float:sz, Float:sa)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	if(Player[playerid][pID] <= 0)
		return 0;

	new spawnSkin = SpawnLoc_GetSpawnInfoSkin(playerid);

	HideInteractionWindow(playerid);
	GibddResetPlayer(playerid);
	SetPlayerInBiz(playerid, -1);
	Shop247_OnExitBiz(playerid);
	DeletePVar(playerid, "InHouseID");
	DeletePVar(playerid, "HouseEnterID");

	SetPVarInt(playerid, "spawn_resolving", 1);

	SetSpawnInfo(playerid, 0, spawnSkin, sx, sy, sz, sa, 0, 0, 0, 0, 0, 0);
	TogglePlayerSpectating(playerid, false);
	SpawnPlayer(playerid);

	SetPlayerPos(playerid, sx, sy, sz);
	SetPlayerFacingAngle(playerid, sa);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	Streamer_UpdateEx(playerid, sx, sy, sz, 0, 0);

	SpawnLoc_ApplyFullSkin(playerid);
	Hospital_RestoreAppearance(playerid);

	Player_FixInteriorWorldLeak(playerid);
	DeletePVar(playerid, "spawn_resolving");
	return 1;
}

stock bool:SpawnLoc_IsPosValid(Float:x, Float:y, Float:z)
{
	if(x == 0.0 && y == 0.0 && z == 0.0) return false;
	if(x < -4000.0 || x > 4000.0) return false;
	if(y < -4000.0 || y > 4000.0) return false;
	if(z < -100.0 || z > 1000.0) return false;
	return true;
}

stock bool:SpawnLoc_ShouldSaveLastPos(playerid)
{
	if(!IsPlayerConnected(playerid)) return false;
	if(Player[playerid][pID] <= 0) return false;
	if(GetPVarInt(playerid, "spawn_gui_active")) return false;

	if(GetPlayerInterior(playerid) != 0) return false;
	if(GetPlayerVirtualWorld(playerid) != 0) return false;

	if(GetPVarType(playerid, "InHouseID")) return false;

	new in_biz = GetPlayerInBiz(playerid);
	if(in_biz != -1 && Biz_IsPlayerInside(playerid, in_biz))
		return false;

	if(Shop_IsInShop(playerid))
		return false;

	return true;
}

stock SpawnLoc_TrySaveLastPos(playerid)
{
	if(!SpawnLoc_ShouldSaveLastPos(playerid))
		return 0;

	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	if(!SpawnLoc_IsPosValid(x, y, z))
		return 0;
	if(Hospital_IsReservedSpawnPos(x, y, z))
		return 0;

	Player[playerid][pLastSpawnX] = x;
	Player[playerid][pLastSpawnY] = y;
	Player[playerid][pLastSpawnZ] = z;
	Player[playerid][pLastSpawnA] = a;
	Player[playerid][pLastSpawnValid] = true;
	return 1;
}

stock SpawnLoc_SaveLastPosToDB(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(!Player[playerid][pLastSpawnValid]) return 0;

	new q[256];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `players` SET `spawn_last_x`=%f, `spawn_last_y`=%f, `spawn_last_z`=%f, `spawn_last_a`=%f, `spawn_last_valid`=1 WHERE `id`=%d LIMIT 1",
		Player[playerid][pLastSpawnX], Player[playerid][pLastSpawnY], Player[playerid][pLastSpawnZ], Player[playerid][pLastSpawnA],
		Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock bool:SpawnLoc_HasLastPos(playerid)
{
	if(!Player[playerid][pLastSpawnValid]) return false;
	if(Hospital_IsReservedSpawnPos(Player[playerid][pLastSpawnX], Player[playerid][pLastSpawnY], Player[playerid][pLastSpawnZ]))
		return false;
	return SpawnLoc_IsPosValid(Player[playerid][pLastSpawnX], Player[playerid][pLastSpawnY], Player[playerid][pLastSpawnZ]);
}

stock bool:SpawnLoc_IsChoiceAvailable(playerid, client_ui_id)
{
	switch(client_ui_id)
	{
		case SPAWN_UI_VOKZAL: return true;
		case SPAWN_UI_LAST: return SpawnLoc_HasLastPos(playerid);
		case SPAWN_UI_HOME: return (GetPlayerHouseSlot(playerid) != -1);
		case SPAWN_UI_FAMILY_HOME: return (Family_GetHouseSlotByPlayer(playerid) != -1);
	}
	return false;
}

stock SpawnLoc_MapClientToPlace(client_ui_id)
{
	switch(client_ui_id)
	{
		case SPAWN_UI_VOKZAL: return SPAWN_LOC_VOKZAL;
		case SPAWN_UI_LAST: return SPAWN_LOC_LAST;
		case SPAWN_UI_FRACTION: return SPAWN_LOC_FRACTION;
		case SPAWN_UI_GARAGE: return SPAWN_LOC_GARAGE;
		case SPAWN_UI_HOME: return SPAWN_LOC_HOME;
		case SPAWN_UI_YACHT: return SPAWN_LOC_YACHT;
		case SPAWN_UI_FAMILY_GARAGE: return SPAWN_LOC_FAMILY_GARAGE;
		case SPAWN_UI_FAMILY_HOME: return SPAWN_LOC_FAMILY_HOME;
	}
	return -1;
}

stock SpawnLoc_BuildPayload(playerid, dest[], size)
{
	dest[0] = EOS;
	strcat(dest, "{\"m\":[1", size);

	if(Player[playerid][pID] > 0)
	{
		if(SpawnLoc_HasLastPos(playerid))
			strcat(dest, ",2", size);
		if(GetPlayerHouseSlot(playerid) != -1)
			strcat(dest, ",4", size);
		if(Player[playerid][pFamilyId] > 0 && Family_GetHouseSlotByPlayer(playerid) != -1)
			strcat(dest, ",6", size);
	}
	strcat(dest, "],\"o\":1}", size);
	return 1;
}

stock SpawnLoc_SendAccountIdPacket(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	new Node:root = JSON_Object();
	JSON_SetInt(root, "id", Player[playerid][pID]);
	OnPacketIncoming(playerid, 100, root);
	JSON_Cleanup(root);
	return 1;
}

stock SpawnLoc_RefreshGuiPayload(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!GetPVarInt(playerid, "spawn_gui_active")) return 0;

	new payload[256];
	SpawnLoc_BuildPayload(playerid, payload, sizeof(payload));

	new Node:json_spawn;
	JSON_Parse(payload, json_spawn);
	OnPacketIncoming(playerid, SPAWN_GUI_ID, json_spawn);
	JSON_Cleanup(json_spawn);

	printf("[SpawnLoc] GUI 50 refresh -> %s (%s)", payload, Player[playerid][pName]);
	return 1;
}

stock SpawnLoc_SendGuiOpenPacket(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new payload[256];
	SpawnLoc_BuildPayload(playerid, payload, sizeof(payload));

	new Node:json_spawn;
	JSON_Parse(payload, json_spawn);
	OnPacketIncoming(playerid, SPAWN_GUI_ID, json_spawn);

	printf("[SpawnLoc] GUI 50 packet -> %s (%s, pID=%d)", payload, Player[playerid][pName], Player[playerid][pID]);

	JSON_Cleanup(json_spawn);
	return 1;
}

stock SpawnLoc_ShowSelectionGUITest(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new r = random(sizeof(RandomSpawns));
	new Float:px = RandomSpawns[r][0];
	new Float:py = RandomSpawns[r][1];
	new Float:pz = RandomSpawns[r][2];
	new Float:pa = RandomSpawns[r][3];

	SetPVarInt(playerid, "spawn_gui_active", 1);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SpawnLoc_SendGuiOpenPacket(playerid);

	SetSpawnInfo(playerid, 0, 74, px, py, pz, pa, 0, 0, 0, 0, 0, 0);
	TogglePlayerSpectating(playerid, false);
	SpawnPlayer(playerid);
	SetPlayerPos(playerid, px, py, pz);
	SetPlayerFacingAngle(playerid, pa);
	TogglePlayerControllable(playerid, false);
	SetPlayerCameraPos(playerid, px + 35.0, py + 35.0, pz + 18.0);
	SetPlayerCameraLookAt(playerid, px, py, pz);
	return 1;
}

stock SpawnLoc_ShowSelectionGUI(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	HideInteractionWindow(playerid);
	GibddResetPlayer(playerid);
	SetPlayerInBiz(playerid, -1);
	Shop247_OnExitBiz(playerid);
	DeletePVar(playerid, "InHouseID");
	DeletePVar(playerid, "HouseEnterID");

	new r = random(sizeof(RandomSpawns));
	new Float:px = RandomSpawns[r][0];
	new Float:py = RandomSpawns[r][1];
	new Float:pz = RandomSpawns[r][2];
	new Float:pa = RandomSpawns[r][3];
	SetPVarInt(playerid, "spawn_gui_active", 1);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	SpawnLoc_SendGuiOpenPacket(playerid);

	new skin = SpawnLoc_GetSpawnInfoSkin(playerid);
	SetSpawnInfo(playerid, 0, skin, px, py, pz, pa, 0, 0, 0, 0, 0, 0);
	TogglePlayerSpectating(playerid, false);
	SpawnPlayer(playerid);
	SetPlayerPos(playerid, px, py, pz);
	SetPlayerFacingAngle(playerid, pa);
	SpawnLoc_ApplyFullSkin(playerid);
	if(GetPVarInt(playerid, "auth_first_play")
		|| (Player[playerid][pHealth] < 1.0 && !Hospital_HasUnfinishedSession(playerid)))
	{
		Player[playerid][pHealth] = 100.0;
		Player[playerid][pArmour] = 0.0;
		SetPlayerHealth(playerid, 100.0);
		SetPlayerArmour(playerid, 0.0);
	}
	TogglePlayerControllable(playerid, false);
	SetPlayerCameraPos(playerid, px + 35.0, py + 35.0, pz + 18.0);
	SetPlayerCameraLookAt(playerid, px, py, pz);

	printf("[SpawnLoc] GUI 50 opened for %s (id=%d)", Player[playerid][pName], Player[playerid][pID]);
	return 1;
}

stock SpawnLoc_OpenAfterAuth(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	SpawnLoc_SendAccountIdPacket(playerid);
	printf("[SpawnLoc] OpenAfterAuth -> %s (db id %d)", Player[playerid][pName], Player[playerid][pID]);

	if(Hospital_HasUnfinishedSession(playerid))
	{
		printf("[SpawnLoc] %s: unfinished hospital — spawn GUI, beds on choice", Player[playerid][pName]);
		Hospital_SanitizePersistedSpawnPos(playerid);
		SpawnLoc_ShowSelectionGUI(playerid);
		return 1;
	}

	Hospital_ResetPlayer(playerid);
	Hospital_SanitizePersistedSpawnPos(playerid);
	SpawnLoc_ShowSelectionGUI(playerid);
	return 1;
}

stock SpawnLoc_CloseGUI(playerid)
{
	new Node:close_json = JSON_Object();
	JSON_SetInt(close_json, "c", 1);
	OnPacketIncoming(playerid, SPAWN_GUI_ID, close_json);
	JSON_Cleanup(close_json);
	return 1;
}

stock SpawnLoc_SendChoiceError(playerid)
{
	new Node:err = JSON_Object();
	JSON_SetInt(err, "s", 1);
	OnPacketIncoming(playerid, SPAWN_GUI_ID, err);
	JSON_Cleanup(err);
	return 1;
}

public SpawnLoc_ReviveFromAccidentalDeath(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(Player[playerid][pID] <= 0) return 1;
	if(Player[playerid][pHospitalUnfinished] == 1 || g_HospitalSessionActive[playerid])
		return 1;
	if(!GetPVarInt(playerid, "spawn_gui_active") && !GetPVarInt(playerid, "spawn_resolving"))
		return 1;
	if(GetPVarInt(playerid, "auth_reg_flow"))
		return 1;

	Hospital_ResetPlayer(playerid);
	Player[playerid][pHealth] = 100.0;
	Player[playerid][pArmour] = 0.0;
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0.0);
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, false);
	SetCameraBehindPlayer(playerid);
	return 1;
}

stock SpawnLoc_CompleteSessionStart(playerid, bool:skip_hospital_resolve = false)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	if(!skip_hospital_resolve)
	{
		Hospital_ResetPlayer(playerid);
		Hospital_ResolveReconnectSpawn(playerid);
	}

	if(GetPVarInt(playerid, "auth_first_play"))
	{
		DeletePVar(playerid, "auth_first_play");
		Player[playerid][pHealth] = 100.0;
		Player[playerid][pArmour] = 0.0;
	}

	SetCameraBehindPlayer(playerid);
	TogglePlayerSpectating(playerid, false);
	TogglePlayerControllable(playerid, true);
	SetPlayerColor(playerid, COLOR_WHITE);
	SendClientMessage(playerid, -1, "{66CC66}| {ffffff}Добро пожаловать на {E0584B}BR BLACK STUDIO!");
	SpawnLoc_ApplyFullSkin(playerid);
	if(skip_hospital_resolve)
	{
		new Float:hp = Hospital_GetUnfinishedSessionHP(playerid);
		new Float:arm = Player[playerid][pArmour];
		if(arm < 0.0)
			arm = 0.0;
		if(arm > 100.0)
			arm = 100.0;
		Player[playerid][pHealth] = hp;
		Player[playerid][pArmour] = arm;
		SetPlayerHealth(playerid, hp);
		SetPlayerArmour(playerid, arm);
	}
	else
		Player_ApplySavedVitals(playerid);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Player[playerid][pMoney]);

	if(!Player[playerid][pAdminAuth])
	{
		if(Player[playerid][pAdminLvl] > 0 && Player[playerid][pAdminPass] != 0)
			ShowAdminLogin(playerid);
		else
			Admin_NotifyGoadmHint(playerid);
	}
	SpawnLoc_NotifyRestartPending(playerid);
	SetTimerEx("House_PlayerStreamerRefresh", 1200, false, "i", playerid);
	return 1;
}

stock SpawnLoc_ApplySpawn(playerid, spawn_id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	new Float:sx, Float:sy, Float:sz, Float:sa;
	new houseid = -1;

	if(spawn_id == SPAWN_LOC_VOKZAL)
	{
		new r = random(sizeof(RandomSpawns));
		sx = RandomSpawns[r][0];
		sy = RandomSpawns[r][1];
		sz = RandomSpawns[r][2];
		sa = RandomSpawns[r][3];
	}
	else if(spawn_id == SPAWN_LOC_LAST)
	{
		if(!SpawnLoc_HasLastPos(playerid)) return 0;
		sx = Player[playerid][pLastSpawnX];
		sy = Player[playerid][pLastSpawnY];
		sz = Player[playerid][pLastSpawnZ];
		sa = Player[playerid][pLastSpawnA];
	}
	else if(spawn_id == SPAWN_LOC_HOME)
	{
		houseid = GetPlayerHouseSlot(playerid);
		if(houseid == -1) return 0;
	}
	else if(spawn_id == SPAWN_LOC_FAMILY_HOME)
	{
		houseid = Family_GetHouseSlotByPlayer(playerid);
		if(houseid == -1) return 0;
	}
	else return 0;

	HideInteractionWindow(playerid);
	GibddResetPlayer(playerid);
	SetPlayerInBiz(playerid, -1);
	Shop247_OnExitBiz(playerid);

	if((spawn_id == SPAWN_LOC_HOME || spawn_id == SPAWN_LOC_FAMILY_HOME) && houseid != -1)
	{
		SetPVarInt(playerid, "spawn_resolving", 1);
		TogglePlayerSpectating(playerid, false);
		TogglePlayerControllable(playerid, false);

		House_EnterInterior(playerid, houseid);

		DeletePVar(playerid, "spawn_resolving");
		DeletePVar(playerid, "spawn_gui_active");
		SpawnLoc_CompleteSessionStart(playerid);
		SetTimerEx("SpawnLoc_SyncHouseInterior", 400, false, "i", playerid);
		printf("[SpawnLoc] house enter %s slot=%d int=%d vw=%d",
			Player[playerid][pName], houseid, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		return 1;
	}

	DeletePVar(playerid, "spawn_gui_active");
	SpawnLoc_FinalizeWorldSpawn(playerid, sx, sy, sz, sa);
	SpawnLoc_CompleteSessionStart(playerid);
	printf("[SpawnLoc] spawned %s place=%d at %.2f, %.2f, %.2f (live int=%d vw=%d)",
		Player[playerid][pName], spawn_id, sx, sy, sz,
		GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	return 1;
}

public SpawnLoc_DelayedOpen(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(Player[playerid][pID] <= 0) return 1;
	if(GetPVarInt(playerid, "spawn_gui_active")) return 1;
	SpawnLoc_ShowSelectionGUI(playerid);
	return 1;
}

public SpawnLoc_FallbackOpenAfterFam(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!GetPVarInt(playerid, "spawn_wait_fam")) return 1;
	DeletePVar(playerid, "spawn_wait_fam");
	printf("[SpawnLoc] fallback open (family load timeout) -> %s", Player[playerid][pName]);
	SpawnLoc_OpenAfterAuth(playerid);
	return 1;
}

public SpawnLoc_SyncHouseInterior(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!GetPVarType(playerid, "InHouseID")) return 1;

	new houseid = GetPVarInt(playerid, "InHouseID");
	if(houseid < 0 || houseid >= TotalHouses) return 1;

	House_TeleportPlayerToInterior(playerid, houseid);
	SetCameraBehindPlayer(playerid);

	printf("[SpawnLoc] house sync %s slot=%d int=%d vw=%d",
		Player[playerid][pName], houseid, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	return 1;
}

stock SpawnLoc_ParseChoiceId(const raw[], Node:json, &client_ui_id)
{
	client_ui_id = -1;
	if(JSON_GetInt(json, "t", client_ui_id))
		return 1;

	if(!raw[0])
		return 0;

	new pos = strfind(raw, "\"t\"");
	if(pos == -1)
		return 0;

	new colon = strfind(raw, ":", false, pos);
	if(colon == -1)
		return 0;

	new idx = colon + 1;
	while(raw[idx] == ' ')
		idx++;

	client_ui_id = strval(raw[idx]);
	return 1;
}

stock SpawnLoc_HandlePacket(playerid, Node:json, const raw[] = "")
{
	new client_ui_id;
	if(!SpawnLoc_ParseChoiceId(raw, json, client_ui_id))
	{
		printf("[SpawnLoc] choice parse fail for %s raw=%s", Player[playerid][pName], raw);
		JSON_Cleanup(json);
		return 0;
	}

	if(Player[playerid][pID] <= 0)
	{
		JSON_Cleanup(json);
		return 0;
	}

	if(!GetPVarInt(playerid, "spawn_gui_active"))
		SetPVarInt(playerid, "spawn_gui_active", 1);

	if(Hospital_HasUnfinishedSession(playerid))
	{
		printf("[SpawnLoc] unfinished hospital session for %s -> interior random bed", Player[playerid][pName]);
		DeletePVar(playerid, "spawn_resolving");
		DeletePVar(playerid, "spawn_gui_active");
		SpawnLoc_CloseGUI(playerid);
		Hospital_ApplyUnfinishedSessionSpawn(playerid);
		SpawnLoc_CompleteSessionStart(playerid, true);
		JSON_Cleanup(json);
		return 1;
	}

	printf("[SpawnLoc] choice %s -> ui_id=%d", Player[playerid][pName], client_ui_id);

	if(!SpawnLoc_IsChoiceAvailable(playerid, client_ui_id))
	{
		SpawnLoc_SendChoiceError(playerid);
		JSON_Cleanup(json);
		return 1;
	}

	new spawn_id = SpawnLoc_MapClientToPlace(client_ui_id);
	printf("[SpawnLoc] apply %s ui_id=%d place=%d house=%d", Player[playerid][pName], client_ui_id, spawn_id, GetPlayerHouseSlot(playerid));

	if(spawn_id < 0)
	{
		SpawnLoc_SendChoiceError(playerid);
		JSON_Cleanup(json);
		return 1;
	}

	if(!SpawnLoc_ApplySpawn(playerid, spawn_id))
	{
		SpawnLoc_SendChoiceError(playerid);
		JSON_Cleanup(json);
		return 1;
	}

	SpawnLoc_CloseGUI(playerid);
	JSON_Cleanup(json);
	return 1;
}

stock SpawnLoc_OnPlayerDisconnect(playerid)
{
	if(Player[playerid][pID] > 0)
	{
		if(SpawnLoc_TrySaveLastPos(playerid))
			SpawnLoc_SaveLastPosToDB(playerid);
	}
	DeletePVar(playerid, "spawn_gui_active");
	DeletePVar(playerid, "spawn_resolving");
	return 1;
}

public SpawnLoc_PeriodicSaveTick()
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i) || Player[i][pID] <= 0) continue;
		if(GetPVarInt(i, "spawn_gui_active")) continue;
		if(SpawnLoc_TrySaveLastPos(i))
			SpawnLoc_SaveLastPosToDB(i);
	}
	return 1;
}

CMD:spawngui(playerid, params[])
{
	if(Player[playerid][pID] <= 0)
	{
		SpawnLoc_ShowSelectionGUITest(playerid);
		SendClientMessage(playerid, 0xFFFF00FF, "Тест GUI 50. Сначала войдите в аккаунт через меню авторизации.");
		return 1;
	}
	SpawnLoc_ShowSelectionGUI(playerid);
	return 1;
}
