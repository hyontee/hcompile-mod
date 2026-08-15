// Магазины 24/7: свой VW = ID бизнеса (слот+1); прилавок с тихим re-approach ~1 м
#if defined _BR_BIZ_247_SYSTEM_INC_
	#endinput
#endif
#define _BR_BIZ_247_SYSTEM_INC_

#if !defined MAX_BUSINESS
	#define MAX_BUSINESS (300)
#endif

#if !defined SHOP247_INTERIOR_ID
	#define SHOP247_INTERIOR_ID (1)
#endif

#if !defined SHOP247_ATM_MODEL
	#define SHOP247_ATM_MODEL (2942)
#endif

#if !defined SHOP247_SHOW_RADIUS
	#define SHOP247_SHOW_RADIUS       (1.30)
#endif
#if !defined SHOP247_RESET_RADIUS
	#define SHOP247_RESET_RADIUS      (2.35)
#endif
#if !defined SHOP247_COUNTER_REAPPROACH_DIST
	#define SHOP247_COUNTER_REAPPROACH_DIST (1.00)
#endif
#if !defined SHOP247_LEAVE_LOCK_DIST
	#define SHOP247_LEAVE_LOCK_DIST   (1.00)
#endif
#if !defined SHOP247_PROX_MS
	#define SHOP247_PROX_MS           (200)
#endif
#if !defined SHOP247_SHOP_OPEN_CD_MS
	#define SHOP247_SHOP_OPEN_CD_MS   (400)
#endif
#if !defined SHOP247_INTERACT_BLOCK_MS
	#define SHOP247_INTERACT_BLOCK_MS (1200)
#endif

#define SHOP247_PVAR_SHOP_DLG       "Shop247DlgOpen"
#define SHOP247_PVAR_ATM_DLG        "Shop247AtmDlg"
#define SHOP247_PVAR_NPC_OPEN       "Shop247NpcGui"

#define SHOP247_GUI_NPC             (63)
#define SHOP247_GUI_MAIN            (1)
#define SHOP247_GUI_THANKS          (2)

#define SHOP247_BK_MEDKIT           (100)
#define SHOP247_BK_REPAIR           (101)
#define SHOP247_BK_OTHER            (102)
#define SHOP247_BK_BYE              (103)

#define SHOP247_PRICE_MEDKIT        (200)
#define SHOP247_PRICE_REPAIR        (790)
#define SHOP247_PRODS_MEDKIT        (2)
#define SHOP247_PRODS_REPAIR        (3)

#if !defined SHOP247_CASHIER_SKIN
	#define SHOP247_CASHIER_SKIN         (39)
#endif

static const Float:Shop247_AtmPos[4] =
	{1551.0257, 411.3246, 1001.0393, 165.4102};

static const Float:Shop247_CashierPos[4] =
	{1545.0731, 412.6195, 1001.0393, 2.6673};

static const Float:Shop247_CounterInteractPos[3] =
	{1544.8500, 414.2000, 1001.0393};

new STREAMER_TAG_OBJECT:g_Shop247AtmObj[MAX_BUSINESS];
new STREAMER_TAG_AREA:g_Shop247AtmArea[MAX_BUSINESS];
new STREAMER_TAG_AREA:g_Shop247CounterArea[MAX_BUSINESS];
new STREAMER_TAG_ACTOR:g_Shop247CashierActor[MAX_BUSINESS];
new Text3D:g_Shop247CashierLabel[MAX_BUSINESS];

new g_Shop247ProxTimer[MAX_PLAYERS] = {-1, ...};
new g_Shop247ActiveBiz[MAX_PLAYERS] = {-1, ...};
new bool:g_Shop247CounterInside[MAX_PLAYERS];
new bool:g_Shop247AtmInside[MAX_PLAYERS];
new bool:g_Shop247ShopLocked[MAX_PLAYERS];
new Float:g_Shop247LockPos[MAX_PLAYERS][3];
new g_Shop247LastShopOpen[MAX_PLAYERS];
new g_Shop247LastAtmNotify[MAX_PLAYERS];
new g_Shop247UnlockTimer[MAX_PLAYERS] = {-1, ...};
new g_Shop247GuiScreen[MAX_PLAYERS];
new g_Shop247InteractBlockUntil[MAX_PLAYERS];
new bool:g_Shop247CounterReapproach[MAX_PLAYERS];

forward Shop247_ProxTick(playerid);
forward Shop247_UnlockCheck(playerid);
forward Shop247_DelayedZoneCheck(playerid);
forward Biz_GetInteriorVW(businessid);
forward Shop247_TryInteractKey(playerid);
forward Shop247_ResolveActiveBiz(playerid);
forward bool:Shop247_HandleNpcGuiPacket(playerid, Node:json);

stock Shop247_GetBizVW(businessid)
{
	return Biz_GetInteriorVW(businessid);
}

stock bool:Shop247_Is247Business(businessid)
{
	if(businessid < 0 || businessid >= MAX_BUSINESS) return false;
	return (GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_SHOP_24_7);
}

stock Shop247_GetInteriorIdx(businessid)
{
	#pragma unused businessid
	return BUSINESS_INTERIOR_SHOP_24_7;
}

stock Shop247_GetCounterPos(businessid, &Float:x, &Float:y, &Float:z)
{
	#pragma unused businessid
	x = Shop247_CounterInteractPos[0];
	y = Shop247_CounterInteractPos[1];
	z = Shop247_CounterInteractPos[2];
	return 1;
}

stock Shop247_SyncPlayer247State(playerid, businessid)
{
	if(businessid < 0 || !Shop247_Is247Business(businessid)) return -1;
	if(GetPlayerInterior(playerid) != SHOP247_INTERIOR_ID) return -1;

	new expected_vw = Shop247_GetBizVW(businessid);
	if(expected_vw < 1)
		return -1;

	if(GetPlayerVirtualWorld(playerid) != expected_vw)
		SetPlayerVirtualWorld(playerid, expected_vw);

	if(GetPlayerInBiz(playerid) != businessid)
		SetPlayerInBiz(playerid, businessid);

	g_Shop247ActiveBiz[playerid] = businessid;
	return businessid;
}

stock Shop247_FindBizByInteriorVW(playerid)
{
	if(GetPlayerInterior(playerid) != SHOP247_INTERIOR_ID) return -1;

	new vw = GetPlayerVirtualWorld(playerid);
	if(vw < 1) return -1;

	for(new i = 0; i < g_business_loaded; i++)
	{
		if(!Shop247_Is247Business(i)) continue;
		if(Shop247_GetBizVW(i) == vw) return i;
	}

	if(vw >= 256)
	{
		new legacy = vw - 255;
		if(legacy >= 0 && legacy < g_business_loaded && Shop247_Is247Business(legacy))
			return legacy;
	}
	return -1;
}

stock Shop247_GetPlayer247Biz(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(GetPlayerInterior(playerid) != SHOP247_INTERIOR_ID) return -1;

	new bid = Shop247_FindBizByInteriorVW(playerid);
	if(bid != -1)
		return Shop247_SyncPlayer247State(playerid, bid);

	bid = GetPlayerInBiz(playerid);
	if(bid == -1 || !Shop247_Is247Business(bid))
		bid = g_Shop247ActiveBiz[playerid];
	if(bid == -1 || !Shop247_Is247Business(bid)) return -1;

	new vw = GetPlayerVirtualWorld(playerid);
	new expected_vw = Shop247_GetBizVW(bid);

	if(vw == expected_vw)
		return Shop247_SyncPlayer247State(playerid, bid);

	if(vw == bid + 255 || BR_IsCityInteriorVW(vw))
		return Shop247_SyncPlayer247State(playerid, bid);

	return -1;
}

stock Shop247_GetBizByAtmArea(STREAMER_TAG_AREA:areaid, &businessid)
{
	businessid = -1;
	for(new i = 0; i < g_business_loaded; i++)
	{
		if(!IsValidDynamicArea(g_Shop247AtmArea[i])) continue;
		if(_:areaid == _:g_Shop247AtmArea[i])
		{
			businessid = i;
			return 1;
		}
	}
	return 0;
}

stock Shop247_GetBizByCounterArea(STREAMER_TAG_AREA:areaid, &businessid)
{
	businessid = -1;
	for(new i = 0; i < g_business_loaded; i++)
	{
		if(!IsValidDynamicArea(g_Shop247CounterArea[i])) continue;
		if(_:areaid == _:g_Shop247CounterArea[i])
		{
			businessid = i;
			return 1;
		}
	}
	return 0;
}

stock bool:Shop247_IsNearPoint(playerid, Float:x, Float:y, Float:z, Float:radius)
{
	return (IsPlayerInRangeOfPoint(playerid, radius, x, y, z) != 0);
}

stock bool:Shop247_IsNearCounter(playerid, businessid)
{
	new Float:cx, Float:cy, Float:cz;
	Shop247_GetCounterPos(businessid, cx, cy, cz);
	return Shop247_IsNearPoint(playerid, cx, cy, cz, SHOP247_SHOW_RADIUS);
}

stock Shop247_ResolveActiveBiz(playerid)
{
	new bid = Shop247_GetPlayer247Biz(playerid);
	if(bid != -1) return bid;

	if(g_Shop247ActiveBiz[playerid] != -1 && Shop247_Is247Business(g_Shop247ActiveBiz[playerid]))
		return Shop247_SyncPlayer247State(playerid, g_Shop247ActiveBiz[playerid]);

	return -1;
}

stock bool:Shop247_MayUseAtm(playerid, businessid = -1)
{
	if(businessid == -1) businessid = Shop247_GetPlayer247Biz(playerid);
	if(businessid == -1) return false;
	if(g_Shop247AtmInside[playerid]) return true;
	return Shop247_IsNearPoint(playerid, Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2], SHOP247_SHOW_RADIUS);
}

stock bool:Shop247_MayUseCounter(playerid, businessid = -1)
{
	if(businessid == -1) businessid = Shop247_ResolveActiveBiz(playerid);
	if(businessid == -1) return false;
	if(g_Shop247CounterInside[playerid]) return true;
	return Shop247_IsNearCounter(playerid, businessid);
}

stock Shop247_StreamRefresh(playerid, businessid)
{
	new Float:x, Float:y, Float:z;
	Shop247_GetCounterPos(businessid, x, y, z);
	Streamer_UpdateEx(playerid, x, y, z,
		Shop247_GetBizVW(businessid), SHOP247_INTERIOR_ID, -1, -1, 0);
	return 1;
}

stock Shop247_DestroyForBusiness(businessid)
{
	if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;

	if(IsValidDynamicActor(g_Shop247CashierActor[businessid]))
	{
		DestroyDynamicActor(g_Shop247CashierActor[businessid]);
		g_Shop247CashierActor[businessid] = STREAMER_TAG_ACTOR:0;
	}
	if(IsValidDynamicObject(g_Shop247AtmObj[businessid]))
	{
		DestroyDynamicObject(g_Shop247AtmObj[businessid]);
		g_Shop247AtmObj[businessid] = STREAMER_TAG_OBJECT:0;
	}
	if(g_Shop247CashierLabel[businessid])
	{
		if(IsValidDynamic3DTextLabel(g_Shop247CashierLabel[businessid]))
			DestroyDynamic3DTextLabel(g_Shop247CashierLabel[businessid]);
		g_Shop247CashierLabel[businessid] = Text3D:0;
	}
	if(IsValidDynamicArea(g_Shop247AtmArea[businessid]))
	{
		DestroyDynamicArea(g_Shop247AtmArea[businessid]);
		g_Shop247AtmArea[businessid] = STREAMER_TAG_AREA:0;
	}
	if(IsValidDynamicArea(g_Shop247CounterArea[businessid]))
	{
		DestroyDynamicArea(g_Shop247CounterArea[businessid]);
		g_Shop247CounterArea[businessid] = STREAMER_TAG_AREA:0;
	}
	return 1;
}

stock Shop247_CreateInterior(businessid)
{
	if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
	if(!Shop247_Is247Business(businessid)) return 0;
	if(IsValidDynamicObject(g_Shop247AtmObj[businessid])) return 1;

	new vw = Shop247_GetBizVW(businessid);
	new idx = Shop247_GetInteriorIdx(businessid);
	new interior_id = GetBusinessInteriorInfo(idx, BT_ENTER_INTERIOR);

	new Float:cx, Float:cy, Float:cz;
	Shop247_GetCounterPos(businessid, cx, cy, cz);

	g_Shop247AtmObj[businessid] = CreateDynamicObject(SHOP247_ATM_MODEL,
		Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2],
		0.0, 0.0, Shop247_AtmPos[3], vw, interior_id);
	SetDynamicObjectMaterial(g_Shop247AtmObj[businessid], 0, -1, "none", "none", 0x3BD16FFF);
	SetDynamicObjectMaterial(g_Shop247AtmObj[businessid], 1, -1, "none", "none", 0x3BD16FFF);

	g_Shop247CashierActor[businessid] = CreateDynamicActor(SHOP247_CASHIER_SKIN,
		Shop247_CashierPos[0], Shop247_CashierPos[1], Shop247_CashierPos[2], Shop247_CashierPos[3],
		true, 100.0, vw, interior_id);

	g_Shop247CashierLabel[businessid] = CreateDynamic3DTextLabel(
		"{FFCD00}Кассирша",
		0xFFFFFFFF,
		Shop247_CashierPos[0], Shop247_CashierPos[1], Shop247_CashierPos[2] + 1.05,
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, interior_id);

	CreateDynamic3DTextLabel("{3BD16F}Банкомат", 0x3BD16FFF,
		Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2] + 1.05,
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, interior_id);

	g_Shop247AtmArea[businessid] = CreateDynamicSphere(
		Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2],
		SHOP247_SHOW_RADIUS, vw, interior_id);

	g_Shop247CounterArea[businessid] = CreateDynamicSphere(
		cx, cy, cz, SHOP247_SHOW_RADIUS, vw, interior_id);

	return 1;
}

stock Shop247_SpawnForBusiness(businessid)
{
	Shop247_DestroyForBusiness(businessid);
	if(!Shop247_Is247Business(businessid)) return 0;
	return Shop247_CreateInterior(businessid);
}

stock Shop247_SpawnAll()
{
	for(new i = 0; i < g_business_loaded; i++)
	{
		if(!IsBusinessSlotValid(i)) continue;
		Shop247_SpawnForBusiness(i);
	}
	return 1;
}

stock Shop247_ClearShopLock(playerid)
{
	g_Shop247ShopLocked[playerid] = false;
	g_Shop247LockPos[playerid][0] = 0.0;
	g_Shop247LockPos[playerid][1] = 0.0;
	g_Shop247LockPos[playerid][2] = 0.0;
	if(g_Shop247UnlockTimer[playerid] != -1)
	{
		KillTimer(g_Shop247UnlockTimer[playerid]);
		g_Shop247UnlockTimer[playerid] = -1;
	}
}

stock Shop247_BlockInteractBriefly(playerid, ms = SHOP247_INTERACT_BLOCK_MS)
{
	g_Shop247InteractBlockUntil[playerid] = GetTickCount() + ms;
	HideInteractionWindow(playerid);
	return 1;
}

stock bool:Shop247_MayInteractNow(playerid)
{
	return (GetTickCount() >= g_Shop247InteractBlockUntil[playerid]);
}

stock Shop247_ArmCounterReapproach(playerid)
{
	g_Shop247CounterReapproach[playerid] = true;
	g_Shop247CounterInside[playerid] = false;
	HideInteractionWindow(playerid);
	return 1;
}

stock bool:Shop247_CanUseCounterInteract(playerid, businessid = -1)
{
	if(!Shop247_MayInteractNow(playerid)) return false;
	if(!g_Shop247CounterReapproach[playerid]) return true;

	if(businessid == -1) businessid = Shop247_ResolveActiveBiz(playerid);
	if(businessid == -1) return false;

	new Float:cx, Float:cy, Float:cz;
	Shop247_GetCounterPos(businessid, cx, cy, cz);
	if(Shop247_IsNearPoint(playerid, cx, cy, cz, SHOP247_COUNTER_REAPPROACH_DIST))
		return false;

	g_Shop247CounterReapproach[playerid] = false;
	return true;
}

stock Shop247_ClearCounterSession(playerid)
{
	g_Shop247InteractBlockUntil[playerid] = 0;
	g_Shop247CounterReapproach[playerid] = false;
	return 1;
}

stock Shop247_TryUnlockShop(playerid)
{
	if(!g_Shop247ShopLocked[playerid]) return 0;
	if(IsPlayerInRangeOfPoint(playerid, SHOP247_LEAVE_LOCK_DIST,
		g_Shop247LockPos[playerid][0], g_Shop247LockPos[playerid][1], g_Shop247LockPos[playerid][2]))
		return 0;
	Shop247_ClearShopLock(playerid);
	return 1;
}

public Shop247_UnlockCheck(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		Shop247_ClearShopLock(playerid);
		return 0;
	}
	if(!g_Shop247ShopLocked[playerid])
	{
		if(g_Shop247UnlockTimer[playerid] != -1)
		{
			KillTimer(g_Shop247UnlockTimer[playerid]);
			g_Shop247UnlockTimer[playerid] = -1;
		}
		return 0;
	}
	Shop247_TryUnlockShop(playerid);
	return 1;
}

stock Shop247_NotePurchase(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	GetPlayerPos(playerid, g_Shop247LockPos[playerid][0], g_Shop247LockPos[playerid][1], g_Shop247LockPos[playerid][2]);
	g_Shop247ShopLocked[playerid] = true;
	g_Shop247CounterInside[playerid] = false;
	HideInteractionWindow(playerid);
	if(g_Shop247UnlockTimer[playerid] != -1)
		KillTimer(g_Shop247UnlockTimer[playerid]);
	g_Shop247UnlockTimer[playerid] = SetTimerEx("Shop247_UnlockCheck", 350, true, "i", playerid);
	return 1;
}

stock bool:Shop247_CanOpenShop(playerid)
{
	if(!g_Shop247ShopLocked[playerid]) return true;
	return Shop247_TryUnlockShop(playerid) != 0;
}

stock Shop247_MarkShopDialogClosed(playerid)
{
	DeletePVar(playerid, SHOP247_PVAR_SHOP_DLG);
	g_Shop247CounterInside[playerid] = false;
	if(Shop247_GetPlayer247Biz(playerid) != -1)
	{
		new bid = Shop247_GetPlayer247Biz(playerid);
		if(Shop247_IsNearCounter(playerid, bid) && Shop247_CanOpenShop(playerid))
			Shop247_ShowCounterInteract(playerid, bid);
	}
}

stock Shop247_OnAtmRearmSynced(playerid)
{
	g_Shop247AtmInside[playerid] = false;
	return 1;
}

stock Shop247_OnAtmDialogClosed(playerid)
{
	if(GetPVarInt(playerid, SHOP247_PVAR_ATM_DLG) != 1) return 0;
	DeletePVar(playerid, SHOP247_PVAR_ATM_DLG);
	g_Shop247AtmInside[playerid] = false;
	return 1;
}

stock bool:Shop247_IsPlayerAtAtm(playerid, businessid = -1)
{
	if(businessid == -1) businessid = Shop247_GetPlayer247Biz(playerid);
	if(businessid == -1) return false;
	return Shop247_MayUseAtm(playerid, businessid);
}

stock Shop247_OpenAtm(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(Shop247_GetPlayer247Biz(playerid) == -1) return 0;
	if(!Shop247_MayUseAtm(playerid)) return 0;
	if(GetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN) == 1) return 0;

	new tick = GetTickCount();
	if(tick - g_Shop247LastAtmNotify[playerid] < BANK_ATM_OPEN_CD_MS) return 0;

	HideInteractionWindow(playerid);
	g_BankAtmStandalone[playerid] = 1;
	g_BankLastAtmOpen[playerid] = tick;
	Bank_ArmAtmBackIgnore(playerid);
	SetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN, 1);
	SetPVarInt(playerid, SHOP247_PVAR_ATM_DLG, 1);
	return Bank_ShowAtmMainDialog(playerid);
}

stock Shop247_ShowAtmNotify(playerid, bool:ignore_cd = false)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(GetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN) == 1) return 0;
	if(!Shop247_IsPlayerAtAtm(playerid)) return 0;
	if(!Bank_AtmMayShowNotify(playerid)) return 0;

	new tick = GetTickCount();
	if(!ignore_cd && tick - g_Shop247LastAtmNotify[playerid] < BANK_ATM_NOTIFY_REPEAT_MS)
		return 0;
	g_Shop247LastAtmNotify[playerid] = tick;

	ToggleInteractionWindow(playerid, true);
	return 1;
}

stock Shop247_ShowCounterInteract(playerid, businessid = -1)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(GetPVarInt(playerid, SHOP247_PVAR_SHOP_DLG) == 1) return 0;
	if(GetPVarInt(playerid, SHOP247_PVAR_NPC_OPEN) == 1) return 0;
	if(businessid == -1) businessid = Shop247_ResolveActiveBiz(playerid);
	if(businessid == -1) return 0;
	if(!Shop247_CanUseCounterInteract(playerid, businessid)) return 0;
	if(!Shop247_CanOpenShop(playerid)) return 0;
	if(!Shop247_MayUseCounter(playerid, businessid)) return 0;
	ToggleInteractionWindow(playerid, true);
	return 1;
}

stock Shop247_OnEnterArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerInterior(playerid) != SHOP247_INTERIOR_ID) return 0;

	new bid;
	if(Shop247_GetBizByAtmArea(areaid, bid))
	{
		if(GetPlayerVirtualWorld(playerid) != Shop247_GetBizVW(bid)) return 0;
		g_Shop247ActiveBiz[playerid] = bid;
		Shop247_ProxEnsure(playerid);
		if(!g_Shop247AtmInside[playerid] && Shop247_ShowAtmNotify(playerid, true))
			g_Shop247AtmInside[playerid] = true;
		return 1;
	}

	if(Shop247_GetBizByCounterArea(areaid, bid))
	{
		if(GetPlayerVirtualWorld(playerid) != Shop247_GetBizVW(bid)) return 0;
		g_Shop247ActiveBiz[playerid] = bid;
		Shop247_ProxEnsure(playerid);
		if(!g_Shop247CounterInside[playerid] && Shop247_ShowCounterInteract(playerid, bid))
			g_Shop247CounterInside[playerid] = true;
		return 1;
	}
	return 0;
}

stock Shop247_OnLeaveArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new bid;
	if(Shop247_GetBizByAtmArea(areaid, bid))
	{
		g_Shop247AtmInside[playerid] = false;
		if(!Shop247_IsNearCounter(playerid, bid))
			HideInteractionWindow(playerid);
		return 1;
	}
	if(Shop247_GetBizByCounterArea(areaid, bid))
	{
		new Float:cx, Float:cy, Float:cz;
		Shop247_GetCounterPos(bid, cx, cy, cz);
		if(!IsPlayerInRangeOfPoint(playerid, SHOP247_RESET_RADIUS, cx, cy, cz))
		{
			g_Shop247CounterInside[playerid] = false;
			HideInteractionWindow(playerid);
		}
		return 1;
	}
	return 0;
}

public Shop247_DelayedZoneCheck(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new bid = Shop247_GetPlayer247Biz(playerid);
	if(bid == -1) return 0;

	Shop247_UpdateProx(playerid, bid);

	if(Shop247_IsPlayerAtAtm(playerid, bid) && !g_Shop247AtmInside[playerid])
	{
		if(Shop247_ShowAtmNotify(playerid, true))
			g_Shop247AtmInside[playerid] = true;
	}
	return 0;
}

stock Shop247_OpenShopDialog(playerid)
{
	new businessid = Shop247_ResolveActiveBiz(playerid);
	if(businessid == -1) return 0;
	if(!Shop247_CanOpenShop(playerid)) return 0;
	if(GetPVarInt(playerid, SHOP247_PVAR_SHOP_DLG) == 1) return 0;
	if(!Shop247_MayUseCounter(playerid, businessid)) return 0;

	new tick = GetTickCount();
	if(tick - g_Shop247LastShopOpen[playerid] < SHOP247_SHOP_OPEN_CD_MS) return 0;

	HideInteractionWindow(playerid);
	g_Shop247LastShopOpen[playerid] = tick;
	SetPVarInt(playerid, SHOP247_PVAR_SHOP_DLG, 1);
	ShowPlayerDialog(playerid, DIALOG_BIZ_SHOP_24_7, DIALOG_STYLE_LIST, CAR_DLG_PREFIX "Магазин 24/7",
		BR_SHOP_LIST_24_7, "Купить", "Отмена");
	return 1;
}

stock Shop247_ResetProxFlags(playerid)
{
	g_Shop247CounterInside[playerid] = false;
	g_Shop247AtmInside[playerid] = false;
}

stock Shop247_ProxStop(playerid)
{
	if(g_Shop247ProxTimer[playerid] != -1)
	{
		KillTimer(g_Shop247ProxTimer[playerid]);
		g_Shop247ProxTimer[playerid] = -1;
	}
	HideInteractionWindow(playerid);
	g_Shop247ActiveBiz[playerid] = -1;
	Shop247_ResetProxFlags(playerid);
}

stock Shop247_ProxEnsure(playerid)
{
	if(g_Shop247ProxTimer[playerid] != -1) return 1;
	g_Shop247ProxTimer[playerid] = SetTimerEx("Shop247_ProxTick", SHOP247_PROX_MS, true, "i", playerid);
	return 1;
}

stock Shop247_UpdateProx(playerid, businessid)
{
	new Float:cx, Float:cy, Float:cz;
	Shop247_GetCounterPos(businessid, cx, cy, cz);

	if(!Shop247_IsNearPoint(playerid, cx, cy, cz, SHOP247_COUNTER_REAPPROACH_DIST))
		g_Shop247CounterReapproach[playerid] = false;

	if(!Shop247_IsNearPoint(playerid, cx, cy, cz, SHOP247_RESET_RADIUS))
	{
		g_Shop247CounterInside[playerid] = false;
		if(!Shop247_IsPlayerAtAtm(playerid, businessid))
			HideInteractionWindow(playerid);
	}

	if(Shop247_IsNearPoint(playerid, cx, cy, cz, SHOP247_SHOW_RADIUS))
	{
		if(!g_Shop247CounterInside[playerid] && Shop247_ShowCounterInteract(playerid, businessid))
			g_Shop247CounterInside[playerid] = true;
	}

	if(!Shop247_IsNearPoint(playerid, Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2], SHOP247_RESET_RADIUS))
	{
		g_Shop247AtmInside[playerid] = false;
		if(!Shop247_IsNearCounter(playerid, businessid))
			HideInteractionWindow(playerid);
	}

	if(Shop247_IsNearPoint(playerid, Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2], SHOP247_SHOW_RADIUS))
	{
		if(!g_Shop247AtmInside[playerid] && Shop247_ShowAtmNotify(playerid, false))
			g_Shop247AtmInside[playerid] = true;
	}
	return 1;
}

public Shop247_ProxTick(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		Shop247_ProxStop(playerid);
		return 0;
	}
	if(GetPlayerInterior(playerid) != SHOP247_INTERIOR_ID)
	{
		Shop247_ProxStop(playerid);
		return 0;
	}

	new raw = GetPlayerInBiz(playerid);
	if(raw == -1 || !Shop247_Is247Business(raw))
		raw = g_Shop247ActiveBiz[playerid];
	if(raw == -1 || !Shop247_Is247Business(raw))
	{
		Shop247_ProxStop(playerid);
		return 0;
	}

	new bid = Shop247_SyncPlayer247State(playerid, raw);
	if(bid == -1)
	{
		Shop247_ProxStop(playerid);
		return 0;
	}
	if(bid != g_Shop247ActiveBiz[playerid])
	{
		g_Shop247ActiveBiz[playerid] = bid;
		Shop247_ResetProxFlags(playerid);
	}
	Shop247_UpdateProx(playerid, bid);
	return 0;
}

stock Shop247_OnEnterBiz(playerid, businessid)
{
	if(!Shop247_Is247Business(businessid)) return 0;
	Shop247_SyncPlayer247State(playerid, businessid);
	Shop247_ResetProxFlags(playerid);
	Shop247_StreamRefresh(playerid, businessid);
	Streamer_UpdateEx(playerid,
		Shop247_AtmPos[0], Shop247_AtmPos[1], Shop247_AtmPos[2],
		Shop247_GetBizVW(businessid), SHOP247_INTERIOR_ID, -1, -1, 0);
	Shop247_ProxEnsure(playerid);
	SetTimerEx("Shop247_ProxTick", 80, false, "i", playerid);
	SetTimerEx("Shop247_DelayedZoneCheck", 350, false, "i", playerid);
	return 1;
}

stock Shop247_OnExitBiz(playerid)
{
	Shop247_CloseCashierGui(playerid, false);
	Shop247_ClearCounterSession(playerid);
	Shop247_MarkShopDialogClosed(playerid);
	Bank_AtmClearRearm(playerid);
	Shop247_ProxStop(playerid);
	g_Shop247ActiveBiz[playerid] = -1;
	if(GetPlayerVirtualWorld(playerid) != 0)
		SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

stock Shop247_OnPlayerConnect(playerid)
{
	InteractBtn_ResetPlayer(playerid);
	g_Shop247ProxTimer[playerid] = -1;
	g_Shop247ActiveBiz[playerid] = -1;
	g_Shop247CounterInside[playerid] = false;
	g_Shop247AtmInside[playerid] = false;
	g_Shop247ShopLocked[playerid] = false;
	g_Shop247LastShopOpen[playerid] = 0;
	g_Shop247LastAtmNotify[playerid] = 0;
	g_Shop247GuiScreen[playerid] = 0;
	g_Shop247InteractBlockUntil[playerid] = 0;
	g_Shop247CounterReapproach[playerid] = false;
	Shop247_ClearShopLock(playerid);
	DeletePVar(playerid, SHOP247_PVAR_SHOP_DLG);
	DeletePVar(playerid, SHOP247_PVAR_ATM_DLG);
	DeletePVar(playerid, SHOP247_PVAR_NPC_OPEN);
	return 1;
}

stock Shop247_OnPlayerDisconnect(playerid)
{
	Shop247_OnExitBiz(playerid);
	Shop247_ClearShopLock(playerid);
	return 1;
}

stock Shop247_GetGenderCompliment(playerid, dest[], size)
{
	if(Shop_GetPlayerSexIndex(playerid))
		format(dest, size, "красавица");
	else
		format(dest, size, "красавчик");
	return 1;
}

stock Shop247_FormatCashierGreeting(playerid, dest[], size)
{
	if(Shop_GetPlayerSexIndex(playerid))
		format(dest, size, "Привет, красавица! За чем пришла?");
	else
		format(dest, size, "Привет, красавчик! За чем пришёл?");
	return 1;
}

stock Node:Shop247_BuildNpcButton(text[], bt, bk)
{
	return JSON_Object(
		"bn", JSON_String(text),
		"bt", JSON_Int(bt),
		"bk", JSON_Int(bk)
	);
}

stock Shop247_GetNpcButtonKey(Node:json, screen)
{
	new key = 0, bt = 0;
	JSON_GetInt(json, "bk", key);
	if(key != 0) return key;

	JSON_GetInt(json, "bt", bt);
	if(screen == SHOP247_GUI_THANKS)
		return SHOP247_BK_BYE;

	if(screen == SHOP247_GUI_MAIN && bt == 2)
		return SHOP247_BK_OTHER;

	return 0;
}

stock Shop247_SendCashierGui(playerid, Node:json)
{
	ShowPlayerGUI(playerid, SHOP247_GUI_NPC, json);
	JSON_Cleanup(json);
	return 1;
}

stock Shop247_ShowCashierMainGui(playerid, bool:is_update = false)
{
	new desc[144];
	Shop247_FormatCashierGreeting(playerid, desc, sizeof desc);

	SetPVarInt(playerid, SHOP247_PVAR_NPC_OPEN, 1);
	g_Shop247GuiScreen[playerid] = SHOP247_GUI_MAIN;

	new Node:buttons = JSON_Array(
		Shop247_BuildNpcButton("Аптечка", 1, SHOP247_BK_MEDKIT),
		Shop247_BuildNpcButton("Ремонтный набор", 1, SHOP247_BK_REPAIR),
		Shop247_BuildNpcButton("Другие товары", 2, SHOP247_BK_OTHER)
	);

	new Node:json = JSON_Object();
	if(is_update)
		JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Кассирша");
	JSON_SetString(json, "d", desc);
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", SHOP247_CASHIER_SKIN);
	JSON_SetArray(json, "b", buttons);

	Shop247_SendCashierGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock Shop247_CloseCashierGui(playerid, bool:reshow_interact = true)
{
	if(GetPVarInt(playerid, SHOP247_PVAR_NPC_OPEN) != 1) return 0;

	new was_thanks = (g_Shop247GuiScreen[playerid] == SHOP247_GUI_THANKS);

	DeletePVar(playerid, SHOP247_PVAR_NPC_OPEN);
	g_Shop247GuiScreen[playerid] = 0;

	new Node:close_json = JSON_Object();
	HidePlayerGUI(playerid, SHOP247_GUI_NPC, close_json);
	JSON_Cleanup(close_json);

	if(was_thanks)
	{
		Shop247_ArmCounterReapproach(playerid);
		Shop247_BlockInteractBriefly(playerid);
		reshow_interact = false;
	}

	if(reshow_interact)
	{
		new bid = Shop247_GetPlayer247Biz(playerid);
		if(bid != -1 && Shop247_IsNearCounter(playerid, bid) && Shop247_CanOpenShop(playerid))
			Shop247_ShowCounterInteract(playerid, bid);
	}
	return 1;
}

stock Shop247_ShowCashierThanksGui(playerid)
{
	new compliment[16], desc[144];
	Shop247_GetGenderCompliment(playerid, compliment, sizeof compliment);
	format(desc, sizeof desc,
		"Спасибо за покупку, %s!", compliment);

	SetPVarInt(playerid, SHOP247_PVAR_NPC_OPEN, 1);
	g_Shop247GuiScreen[playerid] = SHOP247_GUI_THANKS;

	new Node:buttons = JSON_Array(
		Shop247_BuildNpcButton("До свидания", 1, SHOP247_BK_BYE)
	);

	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Кассирша");
	JSON_SetString(json, "d", desc);
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", SHOP247_CASHIER_SKIN);
	JSON_SetArray(json, "b", buttons);

	Shop247_SendCashierGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock Shop247_OpenCashierGui(playerid)
{
	new businessid = Shop247_ResolveActiveBiz(playerid);
	if(businessid == -1) return 0;
	if(!Shop247_CanUseCounterInteract(playerid, businessid)) return 0;
	if(!Shop247_CanOpenShop(playerid)) return 0;
	if(GetPVarInt(playerid, SHOP247_PVAR_SHOP_DLG) == 1) return 0;
	if(GetPVarInt(playerid, SHOP247_PVAR_NPC_OPEN) == 1) return 0;
	if(!Shop247_MayUseCounter(playerid, businessid)) return 0;

	new tick = GetTickCount();
	if(tick - g_Shop247LastShopOpen[playerid] < SHOP247_SHOP_OPEN_CD_MS) return 0;

	HideInteractionWindow(playerid);
	g_Shop247LastShopOpen[playerid] = tick;
	g_Shop247CounterInside[playerid] = false;
	return Shop247_ShowCashierMainGui(playerid);
}

stock Shop247_BuyQuickItem(playerid, item_type)
{
	new businessid = Shop247_ResolveActiveBiz(playerid);
	if(businessid == -1) return 0;
	if(!Shop247_MayUseCounter(playerid, businessid)) return 0;

	new price, take_prods, item_id;
	switch(item_type)
	{
		case 1:
		{
			price = SHOP247_PRICE_MEDKIT;
			take_prods = SHOP247_PRODS_MEDKIT;
			item_id = ITEM_MEDKIT;
		}
		case 2:
		{
			price = SHOP247_PRICE_REPAIR;
			take_prods = SHOP247_PRODS_REPAIR;
			item_id = ITEM_REPAIR_KIT;
		}
		default: return 0;
	}

	if(GetPlayerMoneyEx(playerid) < price)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег.");
		return 0;
	}

	GivePlayerMoneyEx(playerid, -price);
	if(GetBusinessData(businessid, B_PRODS) >= take_prods)
	{
		AddBusinessData(businessid, B_PRODS, -, take_prods);
		AddBusinessData(businessid, B_BALANCE, +, price);
	}
	Biz_LogProfit(GetBusinessData(businessid, B_SQL_ID), playerid, price, _:IsBusinessOwned(businessid));
	Biz_SaveBusinessRow(businessid);

	if(!GivePlayerItem(playerid, item_id, 1))
	{
		GivePlayerMoneyEx(playerid, price);
		AddBusinessData(businessid, B_PRODS, +, take_prods);
		AddBusinessData(businessid, B_BALANCE, -, price);
		SendClientMessage(playerid, 0xCECECEFF, "Инвентарь переполнен. Освободите слот.");
		return 0;
	}

	if(item_type == 1)
		SendClientMessage(playerid, 0x66CC00FF, "Аптечка добавлена в инвентарь. Используйте её через инвентарь.");
	else
		SendClientMessage(playerid, 0x66CC00FF, "Ремонтный набор добавлен в инвентарь. Используйте за рулём через инвентарь.");

	Shop247_NotePurchase(playerid);
	return 1;
}

stock bool:Shop247_HandleNpcGuiPacket(playerid, Node:json)
{
	if(GetPVarInt(playerid, SHOP247_PVAR_NPC_OPEN) != 1)
		return false;

	new close_flag;
	if(JSON_GetInt(json, "c", close_flag) && close_flag)
	{
		Shop247_CloseCashierGui(playerid, true);
		return true;
	}

	new click = Shop247_GetNpcButtonKey(json, g_Shop247GuiScreen[playerid]);
	if(click == 0)
		return true;

	switch(click)
	{
		case SHOP247_BK_MEDKIT:
		{
			if(Shop247_BuyQuickItem(playerid, 1))
				Shop247_ShowCashierThanksGui(playerid);
			else
				Shop247_ShowCashierMainGui(playerid, true);
		}
		case SHOP247_BK_REPAIR:
		{
			if(Shop247_BuyQuickItem(playerid, 2))
				Shop247_ShowCashierThanksGui(playerid);
			else
				Shop247_ShowCashierMainGui(playerid, true);
		}
		case SHOP247_BK_OTHER:
		{
			Shop247_CloseCashierGui(playerid, false);
			Shop247_OpenShopDialog(playerid);
		}
		case SHOP247_BK_BYE:
		{
			Shop247_CloseCashierGui(playerid, false);
		}
	}
	return true;
}

stock Shop247_HandleNotifyAtm(playerid, notify_id)
{
	if(notify_id != NOTIFY_BANK_ATM) return 0;
	if(Shop247_GetPlayer247Biz(playerid) == -1) return 0;
	if(!Shop247_MayUseAtm(playerid)) return 0;
	return Shop247_OpenAtm(playerid);
}

stock Shop247_TryInteractKey(playerid)
{
	new bid = Shop247_ResolveActiveBiz(playerid);
	if(bid == -1) return 0;

	if(Shop247_MayUseAtm(playerid, bid))
		return Shop247_OpenAtm(playerid);

	if(!Shop247_CanUseCounterInteract(playerid, bid)) return 0;
	if(!Shop247_MayUseCounter(playerid, bid)) return 0;
	return Shop247_OpenCashierGui(playerid);
}

stock bool:Shop247_TryInteractClick(playerid)
{
	return Shop247_TryInteractKey(playerid) != 0;
}

stock Shop247_CmdBuy(playerid)
{
	new businessid = Shop247_GetPlayer247Biz(playerid);
	if(businessid == -1)
		return SendClientMessage(playerid, 0xCECECEFF, "Вы не в магазине 24/7.");
	if(!Shop247_CanOpenShop(playerid)) return 0;
	g_Shop247CounterInside[playerid] = false;
	return Shop247_OpenShopDialog(playerid);
}

stock Shop247_OnGameModeInit()
{
	for(new i = 0; i < MAX_BUSINESS; i++)
	{
		g_Shop247AtmObj[i] = STREAMER_TAG_OBJECT:0;
		g_Shop247AtmArea[i] = STREAMER_TAG_AREA:0;
		g_Shop247CounterArea[i] = STREAMER_TAG_AREA:0;
		g_Shop247CashierActor[i] = STREAMER_TAG_ACTOR:0;
		g_Shop247CashierLabel[i] = Text3D:0;
	}
	return 1;
}
