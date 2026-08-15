// Закусочная (бизнес тип 16) — Black Russia / MODE

#if defined _BR_BUSINESS_SYSTEM_INC_
	#endinput
#endif
#define _BR_BUSINESS_SYSTEM_INC_

#if !defined MAX_BUSINESS
	#define MAX_BUSINESS (300)
#endif

#if !defined BUSINESS_TYPE_SNACK
	#define BUSINESS_TYPE_SNACK (16)
#endif
#if !defined BUSINESS_INTERIOR_SNACK
	#define BUSINESS_INTERIOR_SNACK (11)
#endif

#define BR_SNACK_INTERIOR_ID        (1)
#define BR_SNACK_GUI_ID             (3)
#define BR_SNACK_PICKUP_STREAM      (35.0)
#define BR_SNACK_BUY_COOLDOWN_SEC   (3)
#define BR_SNACK_MENU_CD_SEC        (3)

forward ShowPlayerGUI(playerid, guiid, Node:json);
forward OnPacketIncoming(playerid, guiid, Node:json);
forward SavePlayerAccount(playerid);
forward bool:IsPlayerInBuyPosBiz(playerid, businessid, type, Float:radius = 50.0);
forward Biz_LogProfit(sql_bid, playerid, money, view1);
forward Biz_SaveBusinessRow(businessid);
forward GetBusinessEnterProdCount(businessid);
forward GetPlayerInBiz(playerid);
forward bool:IsBusinessOwned(businessid);
forward bool:IsBusinessSlotValid(businessid);
forward GetPlayerMoneyEx(playerid);
forward ShowNotification(playerid, type, duration, id, subId, caption[], btnCaption[]);
forward Biz_GetInteriorVW(businessid);
forward ExitPlayerFromBiz(playerid);
forward Satiety_Get(playerid);
forward Satiety_Add(playerid, amount);
forward Satiety_SaveDb(playerid, bool:force = false);

#if !defined NOTIFY_TYPE_TEXT_GREEN
	#define NOTIFY_TYPE_TEXT_GREEN (4)
#endif
#if !defined NOTIFY_TYPE_TEXT_RED
	#define NOTIFY_TYPE_TEXT_RED (5)
#endif

new g_SnackInteriorPickup[MAX_BUSINESS];
new Text3D:g_SnackBuyLabel[MAX_BUSINESS];

static const Float:BR_SNACK_SPAWN[4] =
{
	10.0209, 1004.5321, 1381.0468, 2.5819
};
#define BR_SNACK_POS_X  (BR_SNACK_SPAWN[0])
#define BR_SNACK_POS_Y  (BR_SNACK_SPAWN[1])
#define BR_SNACK_POS_Z  (BR_SNACK_SPAWN[2])
#define BR_SNACK_POS_A  (BR_SNACK_SPAWN[3])

static const g_SnackFoodName[][] =
{
	"Картофель Фри",
	"Сэндвич",
	"Бургер",
	"Крылышки",
	"Пицца"
};
static const g_SnackFoodPrice[] = {120, 230, 320, 450, 580};
static const g_SnackFoodSatiety[] = {8, 12, 18, 22, 28};

stock bool:Snack_IsBusiness(businessid)
{
	if(businessid < 0 || businessid >= g_business_loaded) return false;
	return (GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_SNACK);
}

stock Snack_GetInteriorIdx()
{
	return BUSINESS_INTERIOR_SNACK;
}

stock Snack_ClearPlayerVars(playerid)
{
	DeletePVar(playerid, "SnackDlgOpen");
	DeletePVar(playerid, "SnackBizId");
	DeletePVar(playerid, "SnackMenuCd");
}

stock Snack_SetMenuCooldown(playerid)
{
	SetPVarInt(playerid, "SnackMenuCd", gettime() + BR_SNACK_MENU_CD_SEC);
}

stock bool:Snack_IsMenuOnCooldown(playerid)
{
	return (GetPVarInt(playerid, "SnackMenuCd") > gettime());
}

stock Snack_DestroyForBusiness(businessid)
{
	if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;

	if(g_SnackInteriorPickup[businessid])
	{
		DestroyDynamicPickup(g_SnackInteriorPickup[businessid]);
		g_SnackInteriorPickup[businessid] = 0;
	}
	if(g_SnackBuyLabel[businessid])
	{
		if(IsValidDynamic3DTextLabel(g_SnackBuyLabel[businessid]))
			DestroyDynamic3DTextLabel(g_SnackBuyLabel[businessid]);
		g_SnackBuyLabel[businessid] = Text3D:0;
	}
	return 1;
}

stock Snack_SpawnForBusiness(businessid)
{
	if(!Snack_IsBusiness(businessid)) return 0;

	Snack_DestroyForBusiness(businessid);

	new vw = Biz_GetInteriorVW(businessid);
	new int_id = BR_SNACK_INTERIOR_ID;

	// Один пикап (type 2): меню /buy и выход — без дубля на тех же координатах
	g_SnackInteriorPickup[businessid] = CreateDynamicPickup(1239, 2,
		BR_SNACK_POS_X, BR_SNACK_POS_Y, BR_SNACK_POS_Z,
		vw, int_id, -1, BR_SNACK_PICKUP_STREAM);

	g_SnackBuyLabel[businessid] = CreateDynamic3DTextLabel(
		"{66CC00}Меню еды и выход\n{FFFFFF}Подойдите к метке",
		0xFFFFFFFF,
		BR_SNACK_POS_X, BR_SNACK_POS_Y, BR_SNACK_POS_Z + 0.85,
		8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
		vw, int_id, -1, 60.0);
	return 1;
}

stock Snack_SpawnAll()
{
	for(new i; i < g_business_loaded; i++)
	{
		if(!IsBusinessSlotValid(i)) continue;
		if(Snack_IsBusiness(i))
			Snack_SpawnForBusiness(i);
	}
	return 1;
}

stock Snack_BuildMenuList(dest[], size)
{
	dest[0] = '\0';
	new line[72];
	for(new i; i < sizeof g_SnackFoodName; i++)
	{
		format(line, sizeof line, "%s\t%d руб\t+%d сыт.\n",
			g_SnackFoodName[i], g_SnackFoodPrice[i], g_SnackFoodSatiety[i]);
		strcat(dest, line, size);
	}
	return 1;
}

stock Snack_ShowFoodMenu(playerid, businessid)
{
	if(businessid < 0 || businessid >= g_business_loaded) return 0;
	if(!Snack_IsBusiness(businessid)) return 0;
	if(GetPlayerInBiz(playerid) != businessid) return 0;
	if(GetPVarInt(playerid, "SnackDlgOpen")) return 0;
	if(Snack_IsMenuOnCooldown(playerid)) return 0;

	SetPVarInt(playerid, "SnackDlgOpen", 1);
	SetPVarInt(playerid, "SnackBizId", businessid);

	new list[512];
	Snack_BuildMenuList(list, sizeof list);
	ShowPlayerDialog(playerid, DIALOG_BIZ_SNACK_MENU, DIALOG_STYLE_TABLIST,
		"{FFCD00}Закусочная", list, "Купить", "Отмена");
	return 1;
}

stock Snack_ShowHubDialog(playerid, businessid)
{
	if(businessid < 0 || businessid >= g_business_loaded) return 0;
	if(!Snack_IsBusiness(businessid)) return 0;
	if(GetPlayerInBiz(playerid) != businessid) return 0;
	if(GetPVarInt(playerid, "SnackDlgOpen")) return 0;
	if(Snack_IsMenuOnCooldown(playerid)) return 0;

	SetPVarInt(playerid, "SnackDlgOpen", 1);
	SetPVarInt(playerid, "SnackBizId", businessid);
	ShowPlayerDialog(playerid, DIALOG_BIZ_SNACK_HUB, DIALOG_STYLE_MSGBOX,
		"{FFCD00}Закусочная",
		"{FFFFFF}Меню еды или выход на улицу.",
		"Меню еды", "Выйти");
	return 1;
}

stock Snack_ProcessPurchase(playerid, businessid, food_idx)
{
	if(businessid < 0 || businessid >= g_business_loaded) return 0;
	if(!Snack_IsBusiness(businessid)) return 0;
	if(!(0 <= food_idx < sizeof g_SnackFoodPrice)) return 0;

	new price = g_SnackFoodPrice[food_idx];
	new sat_add = g_SnackFoodSatiety[food_idx];

	if(GetPlayerMoneyEx(playerid) < price)
	{
		ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0,
			"Недостаточно денег для покупки еды.", "");
		return 0;
	}

	if(IsBusinessOwned(businessid))
	{
		new need = GetBusinessEnterProdCount(businessid);
		if(need > 0 && GetBusinessData(businessid, B_PRODS) < need)
		{
			SendClientMessage(playerid, 0xCECECEFF, "В закусочной закончились продукты.");
			return 0;
		}
		if(need > 0)
		{
			SetBusinessData(businessid, B_PRODS, GetBusinessData(businessid, B_PRODS) - need);
			Biz_SaveBusinessRow(businessid);
		}
		new profit = floatround(price * 0.35);
		if(profit > 0)
		{
			SetBusinessData(businessid, B_BALANCE, GetBusinessData(businessid, B_BALANCE) + profit);
			Biz_LogProfit(GetBusinessData(businessid, B_SQL_ID), playerid, profit, 1);
			Biz_SaveBusinessRow(businessid);
		}
	}

	GivePlayerMoney(playerid, -price);
	Player[playerid][pMoney] -= price;
	Satiety_Add(playerid, sat_add);
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0);

	new msg[144];
	format(msg, sizeof msg, "Вы поели: %s. Сытость: %d%% (+%d).",
		g_SnackFoodName[food_idx], Satiety_Get(playerid), sat_add);
	SendClientMessage(playerid, 0x66CC00FF, msg);
	Satiety_SaveDb(playerid, true);
	SavePlayerAccount(playerid);
	return 1;
}

stock Snack_ProcessCart(playerid, businessid, order)
{
	if(businessid < 0 || businessid >= g_business_loaded) return 0;
	if(!order) return 0;

	new total_cost, total_sat, count;
	for(new i; i < sizeof g_SnackFoodPrice; i++)
	{
		if(order & (1 << i))
		{
			total_cost += g_SnackFoodPrice[i];
			total_sat += g_SnackFoodSatiety[i];
			count++;
		}
	}
	if(!count || total_cost <= 0) return 0;

	if(GetPlayerMoneyEx(playerid) < total_cost)
	{
		ShowNotification(playerid, NOTIFY_TYPE_TEXT_RED, 5, 0, 0, "Недостаточно денег.", "");
		return 0;
	}

	if(IsBusinessOwned(businessid))
	{
		new need = GetBusinessEnterProdCount(businessid) * count;
		if(need > 0 && GetBusinessData(businessid, B_PRODS) < need)
		{
			SendClientMessage(playerid, 0xCECECEFF, "В закусочной закончились продукты.");
			return 0;
		}
		if(need > 0)
		{
			SetBusinessData(businessid, B_PRODS, GetBusinessData(businessid, B_PRODS) - need);
			Biz_SaveBusinessRow(businessid);
		}
		new profit = floatround(total_cost * 0.35);
		if(profit > 0)
		{
			SetBusinessData(businessid, B_BALANCE, GetBusinessData(businessid, B_BALANCE) + profit);
			Biz_LogProfit(GetBusinessData(businessid, B_SQL_ID), playerid, profit, 1);
			Biz_SaveBusinessRow(businessid);
		}
	}

	GivePlayerMoney(playerid, -total_cost);
	Player[playerid][pMoney] -= total_cost;
	Satiety_Add(playerid, total_sat);
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0);

	new msg[128];
	format(msg, sizeof msg, "Покупка еды: -%d руб. Сытость: %d%% (+%d).",
		total_cost, Satiety_Get(playerid), total_sat);
	SendClientMessage(playerid, 0x66CC00FF, msg);
	Satiety_SaveDb(playerid, true);
	SavePlayerAccount(playerid);
	return 1;
}

stock bool:Snack_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused inputtext

	if(dialogid == DIALOG_BIZ_SNACK_HUB)
	{
		DeletePVar(playerid, "SnackDlgOpen");
		Snack_SetMenuCooldown(playerid);

		new businessid = GetPVarInt(playerid, "SnackBizId");
		DeletePVar(playerid, "SnackBizId");
		if(businessid < 0 || businessid >= g_business_loaded) return true;
		if(GetPlayerInBiz(playerid) != businessid) return true;

		if(!response)
		{
			ExitPlayerFromBiz(playerid);
			return true;
		}
		Snack_ShowFoodMenu(playerid, businessid);
		return true;
	}

	if(dialogid != DIALOG_BIZ_SNACK_MENU) return false;

	DeletePVar(playerid, "SnackDlgOpen");
	Snack_SetMenuCooldown(playerid);

	if(!response)
	{
		DeletePVar(playerid, "SnackBizId");
		return true;
	}

	new businessid = GetPVarInt(playerid, "SnackBizId");
	DeletePVar(playerid, "SnackBizId");
	if(businessid < 0 || businessid >= g_business_loaded) return true;
	if(GetPlayerInBiz(playerid) != businessid)
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны быть внутри закусочной."), true;
	if(!IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SNACK, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Подойдите к прилавку."), true;

	Snack_ProcessPurchase(playerid, businessid, listitem);
	return true;
}

stock bool:Snack_HandleDinerGuiPacket(playerid, Node:json)
{
	new t = -1, order = 0;
	if(JSON_GetType(json, "t") != JSON_NODE_NULL) JSON_GetInt(json, "t", t);
	if(t != 1) return false;
	if(JSON_GetType(json, "r") != JSON_NODE_NULL) JSON_GetInt(json, "r", order);
	if(!order) return true;

	new businessid = GetPlayerInBiz(playerid);
	if(businessid == -1 || !Snack_IsBusiness(businessid)) return true;
	if(!IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SNACK, 8.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Подойдите к прилавку."), true;

	Snack_ProcessCart(playerid, businessid, order);
	return true;
}

stock bool:Snack_TryOpenFromBuyCmd(playerid)
{
	new businessid = GetPlayerInBiz(playerid);
	if(businessid == -1) return false;
	if(!Snack_IsBusiness(businessid)) return false;
	if(!IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SNACK, 6.0))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Подойдите к прилавку закусочной.");
		return true;
	}
	if(Snack_IsMenuOnCooldown(playerid))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Подождите несколько секунд.");
		return true;
	}
	Snack_ShowFoodMenu(playerid, businessid);
	return true;
}

stock bool:Snack_OnPickup(playerid, pickupid)
{
	for(new i; i < g_business_loaded; i++)
	{
		if(!IsBusinessSlotValid(i) || !Snack_IsBusiness(i)) continue;
		if(pickupid != g_SnackInteriorPickup[i]) continue;

		if(GetPVarInt(playerid, "PickupDelay") > gettime()) return true;
		if(GetPVarInt(playerid, "SnackDlgOpen")) return true;
		if(Snack_IsMenuOnCooldown(playerid)) return true;
		if(GetPlayerInBiz(playerid) != i) return true;

		SetPVarInt(playerid, "PickupDelay", gettime() + BR_SNACK_BUY_COOLDOWN_SEC);
		SetPlayerFacingAngle(playerid, BR_SNACK_POS_A);
		Snack_ShowHubDialog(playerid, i);
		return true;
	}
	return false;
}

stock Snack_InitInteriorExtras(interior_idx)
{
	#pragma unused interior_idx
	return 1;
}

stock BusinessSystem_OnGameModeInit()
{
	return Satiety_OnGameModeInit();
}

stock BusinessSystem_OnPlayerConnect(playerid)
{
	Snack_ClearPlayerVars(playerid);
	return Satiety_OnPlayerConnect(playerid);
}

stock BusinessSystem_OnPlayerDisconnect(playerid)
{
	Snack_ClearPlayerVars(playerid);
	return Satiety_OnPlayerDisconnect(playerid);
}
