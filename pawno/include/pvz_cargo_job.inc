// ============================================================================
// pvz_cargo_job.inc — работа "доставка груза" для ПВЗ (без гуишек)
//
//   Подходите к начальнику -> в чат пишется подсказка -> пишете /y -> точка
//   забора груза отмечается на карте (GPS + кольцо).
//   Приезжаете на точку забора -> в чат пишется подсказка -> пишете /y ->
//   идёт полоса погрузки (ShowPlayerProgress) -> груз на спине.
//   Несёте груз в ПВЗ (через любой из 9 пикапов) -> подходите к чекпоинту
//   у начальника -> груз сдаётся и засчитывается автоматически -> деньги.
// ============================================================================

#define PVZ_CARGO_NPC_MODEL         (6792)
#define PVZ_CARGO_NPC_X             (2284.598144)
#define PVZ_CARGO_NPC_Y             (1832.220703)
#define PVZ_CARGO_NPC_Z             (1519.743286)
#define PVZ_CARGO_NPC_A             (342.522583)
#define PVZ_CARGO_NPC_INT           (1)
#define PVZ_CARGO_NPC_VW            (1)

#define PVZ_CARGO_BTN_X             (2285.099121)
#define PVZ_CARGO_BTN_Y             (1834.363037)
#define PVZ_CARGO_BTN_Z             (1519.743286)
#define PVZ_CARGO_BTN_RADIUS        (2.5)

#define PVZ_CARGO_TAKE_X            (2025.244262)
#define PVZ_CARGO_TAKE_Y            (1398.201416)
#define PVZ_CARGO_TAKE_Z            (26.196250)
#define PVZ_CARGO_TAKE_RADIUS       (2.5)

#define PVZ_CARGO_LOAD_TIME_MS      (5000)
#define PVZ_CARGO_PAY               (3000)
#define PVZ_CARGO_COOLDOWN_MS       (120000)
#define PVZ_CARGO_OBJECT_MODEL      (2912)

new g_PvzCargoNpc = INVALID_ACTOR_ID;
new STREAMER_TAG_3D_TEXT_LABEL:g_PvzCargoNpcLabel = STREAMER_TAG_3D_TEXT_LABEL:-1;
new g_PvzCargoBossArea = -1;
new g_PvzCargoTakeArea = -1;

// ----------------------------------------------------------------------
// Полоса прогресса — дано как есть.
// ----------------------------------------------------------------------
stock ShowPlayerProgress(playerid, close, current_status, max_value, max_bar_progress, tick, timer, title[])
{
	new Node:json = JSON_Object();
	JSON_SetInt(json, "o", 1);
	JSON_SetInt(json, "g", 1);
	JSON_SetInt(json, "x", close);

	JSON_SetInt(json, "p_start", current_status);
	JSON_SetInt(json, "p_max", max_value);
	JSON_SetInt(json, "p_max_bar", max_bar_progress);
	JSON_SetInt(json, "p_tick", tick);
	JSON_SetInt(json, "p_timer", timer);
	JSON_SetString(json, "p_title", title, strlen(title));

	SendPacketToClient(playerid, 31, json);
	JSON_Cleanup(json);
	return 1;
}

// ----------------------------------------------------------------------
// Вызывается из OnGameModeInit
// ----------------------------------------------------------------------
stock CreatePvzCargoJobNpc()
{
	if(g_PvzCargoNpc != INVALID_ACTOR_ID) return 1;

	g_PvzCargoNpc = CreateActor(PVZ_CARGO_NPC_MODEL, PVZ_CARGO_NPC_X, PVZ_CARGO_NPC_Y, PVZ_CARGO_NPC_Z, PVZ_CARGO_NPC_A);
	SetActorVirtualWorld(g_PvzCargoNpc, PVZ_CARGO_NPC_VW);
	SetActorInvulnerable(g_PvzCargoNpc, true);

	g_PvzCargoNpcLabel = CreateDynamic3DTextLabel(
		"{FFD429}Начальник\n{FFFFFF}Напишите {FFD429}/y{FFFFFF}, чтобы поговорить",
		0xFFFFFFFF, PVZ_CARGO_NPC_X, PVZ_CARGO_NPC_Y, PVZ_CARGO_NPC_Z + 0.85, 18.0,
		INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PVZ_CARGO_NPC_VW, PVZ_CARGO_NPC_INT);

	g_PvzCargoBossArea = CreateDynamicSphere(PVZ_CARGO_BTN_X, PVZ_CARGO_BTN_Y, PVZ_CARGO_BTN_Z, PVZ_CARGO_BTN_RADIUS, PVZ_CARGO_NPC_VW, PVZ_CARGO_NPC_INT);
	g_PvzCargoTakeArea = CreateDynamicSphere(PVZ_CARGO_TAKE_X, PVZ_CARGO_TAKE_Y, PVZ_CARGO_TAKE_Z, PVZ_CARGO_TAKE_RADIUS, 0, 0);
	return 1;
}

// ----------------------------------------------------------------------
// Вход в зоны — вызвать из существующего OnPlayerEnterDynamicArea:
//     if(PvzCargo_OnEnterArea(playerid, areaid)) return 1;
// Просто подсказка в чат, никакого гуи.
// ----------------------------------------------------------------------
stock PvzCargo_OnEnterArea(playerid, areaid)
{
	if(areaid == g_PvzCargoBossArea)
	{
		SendClientMessage(playerid, -1, "{2299ee}| {FFFFFF}Напишите {FFD700}/y{FFFFFF}, чтобы начать работу.");
		return 1;
	}

	if(areaid == g_PvzCargoTakeArea)
	{
		if(GetPVarInt(playerid, "pvz_cargo_accepted") && !GetPVarInt(playerid, "pvz_cargo_has"))
		{
			SendClientMessage(playerid, -1, "{2299ee}| {FFFFFF}Напишите {FFD700}/y{FFFFFF}, чтобы забрать груз.");
		}
		return 1;
	}
	return 0;
}

// ----------------------------------------------------------------------
// /y — универсальная команда подтверждения: смотрим, в какой мы зоне.
// ----------------------------------------------------------------------
CMD:y(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerLogged(playerid)) return 1;

	if(IsPlayerInDynamicArea(playerid, g_PvzCargoBossArea))
	{
		return PvzCargo_AcceptJob(playerid);
	}

	if(IsPlayerInDynamicArea(playerid, g_PvzCargoTakeArea))
	{
		return PvzCargo_StartLoading(playerid);
	}

	return 1;
}

// ----------------------------------------------------------------------
// Принять заказ у начальника
// ----------------------------------------------------------------------
stock PvzCargo_AcceptJob(playerid)
{
	if(GetPVarInt(playerid, "pvz_cargo_has"))
	{
		SendClientMessage(playerid, -1, "{FF5252}| {FFFFFF}Груз уже у вас на руках, довезите его.");
		return 1;
	}

	new cd = GetPVarInt(playerid, "pvz_cargo_cd");
	if(cd != 0 && GetTickCount() - cd < PVZ_CARGO_COOLDOWN_MS)
	{
		new left = (PVZ_CARGO_COOLDOWN_MS - (GetTickCount() - cd)) / 1000;
		new msg[96];
		format(msg, sizeof(msg), "{FF5252}| {FFFFFF}Следующий заказ можно взять через %d сек.", left);
		SendClientMessage(playerid, -1, msg);
		return 1;
	}

	SetPVarInt(playerid, "pvz_cargo_accepted", 1);
	DisablePlayerCheckpoint(playerid);
	DisablePlayerGPS(playerid);
	EnablePlayerGPS(playerid, 55, PVZ_CARGO_TAKE_X, PVZ_CARGO_TAKE_Y, PVZ_CARGO_TAKE_Z, "Забор груза отмечен на карте.");
	SetPlayerCheckpoint(playerid, PVZ_CARGO_TAKE_X, PVZ_CARGO_TAKE_Y, PVZ_CARGO_TAKE_Z, 3.0);

	SendClientMessage(playerid, -1, "{2299ee}| {FFFFFF}Есть работёнка. Нужно забрать груз, привезти сюда - и деньги твои.");
	new msg2[96];
	format(msg2, sizeof(msg2), "{2299ee}| {FFFFFF}За доставку заплачу {33aa33}%d рублей{FFFFFF}. Точка забора отмечена на карте.", PVZ_CARGO_PAY);
	SendClientMessage(playerid, -1, msg2);
	return 1;
}

// ----------------------------------------------------------------------
// Забрать груз на точке (запускает полосу погрузки)
// ----------------------------------------------------------------------
stock PvzCargo_StartLoading(playerid)
{
	if(!GetPVarInt(playerid, "pvz_cargo_accepted"))
	{
		SendClientMessage(playerid, -1, "{FF5252}| {FFFFFF}У вас нет активного заказа.");
		return 1;
	}
	if(GetPVarInt(playerid, "pvz_cargo_has")) return 1;
	if(GetPVarInt(playerid, "pvz_cargo_loading")) return 1;

	SetPVarInt(playerid, "pvz_cargo_loading", 1);
	TogglePlayerControllable(playerid, false);

	ShowPlayerProgress(playerid, 0, 0, 100, 100, 2, 100, "Погрузка груза...");
	SetTimerEx("PvzCargo_FinishLoad", PVZ_CARGO_LOAD_TIME_MS, false, "i", playerid);
	return 1;
}

// ----------------------------------------------------------------------
// Завершение погрузки
// ----------------------------------------------------------------------
forward PvzCargo_FinishLoad(playerid);
public PvzCargo_FinishLoad(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(!GetPVarInt(playerid, "pvz_cargo_loading")) return 1;
	DeletePVar(playerid, "pvz_cargo_loading");
	DeletePVar(playerid, "pvz_cargo_accepted");

	TogglePlayerControllable(playerid, true);
	HidePlayerGUI(playerid, 31);

	SetPVarInt(playerid, "pvz_cargo_has", 1);
	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_SPINE, PVZ_CARGO_OBJECT_MODEL, A_OBJECT_BONE_SPINE,
		0.0, 0.25, 0.15, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

	DisablePlayerGPS(playerid);
	EnablePlayerGPS(playerid, 55, PVZ_CARGO_NPC_X, PVZ_CARGO_NPC_Y, PVZ_CARGO_NPC_Z, "Точка сдачи груза отмечена на карте.");
	n_SetPlayerCheckpoint(playerid, PVZ_CARGO_NPC_X, PVZ_CARGO_NPC_Y, PVZ_CARGO_NPC_Z, 3.0, CP_ACTION_TYPE_PVZ_CARGO_PUT);
	SendClientMessage(playerid, -1, "{2299ee}| {FFFFFF}Груз загружен. Отнесите его начальнику в пункте выдачи.");
	return 1;
}

// ----------------------------------------------------------------------
// Сдача груза — вызвать из switch(action_type) внутри OnPlayerEnterCheckpoint:
//     case CP_ACTION_TYPE_PVZ_CARGO_PUT: PvzCargo_OnEnterPutCP(playerid);
// ----------------------------------------------------------------------
stock PvzCargo_OnEnterPutCP(playerid)
{
	if(!GetPVarInt(playerid, "pvz_cargo_has")) return 1;

	DisablePlayerCheckpoint(playerid);
	DisablePlayerGPS(playerid);
	DeletePVar(playerid, "pvz_cargo_has");
	RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_SPINE);

	SetPVarInt(playerid, "pvz_cargo_cd", GetTickCount());
	GivePlayerMoneyEx(playerid, PVZ_CARGO_PAY, "Доставка груза (ПВЗ)", true, true);

	new msg[96];
	format(msg, sizeof(msg), "{33aa33}| {FFFFFF}Груз доставлен! Вы получили {33aa33}%d руб.", PVZ_CARGO_PAY);
	SendClientMessage(playerid, -1, msg);
	return 1;
}
