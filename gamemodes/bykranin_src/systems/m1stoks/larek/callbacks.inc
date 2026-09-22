//>> Файл: bykranin_src/systems/m1stoks/larek/callbacks.inc  (69 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: Larek_OnGameModeInit, Larek_OnPlayerConnect, Larek_OnPlayerDisconnect, Larek_OnPlayerEnterDynamicArea, Larek_OnPlayerLeaveDynamicArea, Larek_OnPlayerPickUpPickupEx
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/larek/callbacks.inc
#if defined _m1stoks_callbacks_included
	#endinput
#endif
#define _m1stoks_callbacks_included

forward Larek_OnGameModeInit();
public Larek_OnGameModeInit()
{
	Larek_InitStaticBusinesses();
	Larek_InitAreas();
	Larek_RefreshAllLabels();
	printf("[Larek]: Система ларьков загружена.");
	return 1;
}

forward Larek_OnPlayerConnect(playerid);
public Larek_OnPlayerConnect(playerid)
{
	Larek_ResetPlayer(playerid);
	return 1;
}

forward Larek_OnPlayerDisconnect(playerid);
public Larek_OnPlayerDisconnect(playerid)
{
	p_larek_biz_id[playerid] = -1;
	p_larek_notify_biz[playerid] = -1;
	p_larek_last_check_ms[playerid] = 0;
	return 1;
}

forward Larek_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
public Larek_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new biz_id = Larek_GetBizByArea(areaid);
	if(biz_id == -1) return 0;

	Larek_ShowInteractNotification(playerid, biz_id);
	return 1;
}

forward Larek_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
public Larek_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new biz_id = Larek_GetBizByArea(areaid);
	if(biz_id == -1) return 0;

	if(p_larek_biz_id[playerid] == biz_id)
		p_larek_biz_id[playerid] = -1;

	p_larek_notify_biz[playerid] = -1;
	return 1;
}

forward Larek_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
public Larek_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	#pragma unused pickupid

	if(action_type != PICKUP_ACTION_TYPE_BIZ_ENTER) return 0;
	if(action_id < 0 || action_id >= g_business_loaded) return 0;
	if(!Larek_IsBusinessLarek(action_id)) return 0;

	Larek_ShowInteractNotification(playerid, action_id);
	return 1;
}
// END INLINED: modules/m1stoks/larek/callbacks.inc
