//>> Файл: bykranin_src/systems/m1stoks/transportCompany/tcomp_defs.inc  (905 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: TC_Send, TC_PlayerInTcInterior, TC_CanShowWorldCheckpoint, TC_RememberRouteMarkerPos, TC_GetActiveRouteMarkerPos, TC_ShowNotify, TC_ApplyRouteMarker
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/transportCompany/tcomp_defs.inc
#if defined _tcomp_defs_included
	#endinput
#endif
#define _tcomp_defs_included




#define TC_COLOR_ACCENT         0xFFFF24FF
#define TC_COLOR_MSG            0xFFFF24FF
#define TC_COLOR_WHITE          0xFFFFFFFF
#define TC_COLOR_ERROR          0xE04646FF
#define TC_COLOR_GOOD           0x66CC33FF
#define TC_MSG                  "{FFFF24}[Транспортная компания] {FFFFFF}"
#define TC_TITLE                "{FFFF24}Меню компании"
#define TC_CHAT_MAX             144

stock TC_Send(playerid, message[192])
{
	new tc_msg_buf[160];
	tc_msg_buf[0] = 0;
	strcat(tc_msg_buf, TC_MSG, sizeof tc_msg_buf);
	strcat(tc_msg_buf, message, sizeof tc_msg_buf);
	if(strlen(tc_msg_buf) < TC_CHAT_MAX)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, tc_msg_buf);
		return 1;
	}
	SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG);
	if(strlen(message) < TC_CHAT_MAX)
		SendClientMessage(playerid, TC_COLOR_MSG, message);
	else
	{
		new short[TC_CHAT_MAX];
		strmid(short, message, 0, TC_CHAT_MAX - 1);
		SendClientMessage(playerid, TC_COLOR_MSG, short);
	}
	return 1;
}



#define TC_JOIN_MIN_LEVEL           2
#define GPS_DIALOG_TC_OFFICES       29140
#define GPS_DIALOG_TUNING_ATELIER   29141

#define TC_COMPANIES_PER_OFFICE     12
#define TC_COMPANIES_TOTAL          24
#define TC_FLEET_TRIPS_MAX          50
#define TC_RENAME_PRICE             100000
#define TC_RENAME_COOLDOWN_DAYS     7
#define TC_WITHDRAW_FEE_PERCENT     3
#define TC_PRIVATE_ORDER_WAIT_SEC   120
#define TC_PRIVATE_AUTO_DELIVER_SEC 300
#define TC_GOV_PLUS_MIN_RATING_LVL  3
#define TC_GOV_PLUS_PAY_MIN         50000
#define TC_GOV_PLUS_PAY_MAX         200000
#define TC_FLEET_PAGE_SIZE          7
#define TC_COMPANY_PAGE_SIZE        7
#define TC_RENT_PAGE_SIZE           7
#define TC_ORDERS_PAGE_SIZE         10
#define TC_EMPLOYEE_PAGE_SIZE       8
#define TC_RENT_OCCUPY_SEC          120
#define TC_TRAILER_DEBUG            0
#define TC_TRAILER_LINK_MS          250
#define TC_TRAILER_RECOVER_COOLDOWN_MS 4000
#define TC_TRAILER_SOFT_RECOVER_MISSES 2
#define TC_TRAILER_HARD_RECOVER_MISSES 5
#define TC_TRAILER_RELINK_DISTANCE  55.0
#define TC_TRAILER_HARD_DISTANCE    180.0
#define TC_TRAILER_FORCE_SNAP_MS    700
#define TC_LOAD_UNLOAD_FREEZE_MS    5000
#define TC_LOAD_UNLOAD_WATCH_MS     500
#define TC_ORDER_PICKUP_RANGE       3.0
#define TC_ROUTE_CHECKPOINT_SIZE    15.0
#define TC_LOAD_POINT_RANGE         18.0
#define TC_UNLOAD_POINT_RANGE       18.0
#define TC_ROUTE_MAP_ICON_SLOT      50
#define TC_ROUTE_MAP_ICON_TYPE      55
#define TC_NOTIFY_INFO              2
#define TC_NOTIFY_SUCCESS           1
#define TC_NOTIFY_ERROR             3
#define TC_NOTIFY_DUR_LOAD          5
#define TC_NOTIFY_DUR               6
#define MAX_TC_FLEET                256
#define MAX_TC_RUNTIME_ORDERS       64
#define TC_COMMISSION_MIN           90
#define TC_COMMISSION_MAX           99
#define TC_SELL_REFUND_PERCENT      50
#define TC_FLEET_SELL_REFUND_PERCENT 50

#define TC_BUY_TRUCK_PRICE          250000
#define TC_BUY_VAN_PRICE            180000
#define TC_BUY_DAF_PRICE            300000
#define TC_REPAIR_PRICE             50000
#define TC_RENT_PRICE_MIN           1000
#define TC_RENT_PRICE_MAX           10000
#define TC_FIN_TRANSPORT            0
#define TC_FIN_WITHDRAW             1
#define TC_FIN_EXPENSE              2
#define TC_FIN_RENT                 3
#define TC_FIN_DEPOSIT              4
#define TC_FINANCE_DAYS             20
#define TC_UPGRADE_OFFICE_PRICE     50000
#define TC_UPGRADE_GARAGE_PRICE     1000000
#define TC_UPGRADE_LICENSE_PRICE    2000000

#define TC_UPGRADE_OFFICE           0
#define TC_UPGRADE_GARAGE           1
#define TC_UPGRADE_LICENSE          2

#define TC_EMPLOYEE_LIMIT_BASE        8
#define TC_EMPLOYEE_LIMIT_OFFICE      150
#define TC_FLEET_LIMIT_BASE           5
#define TC_FLEET_LIMIT_UPGRADE_ADD    20

#define TC_BUY_TYPE_TRUCK           0
#define TC_BUY_TYPE_VAN             1
#define TC_BUY_TYPE_DAF             2

#define TC_TRUCK_MODEL_DEFAULT      403
#define TC_VAN_MODEL_DEFAULT        498
#define TC_DAF_MODEL_DEFAULT        514

#define TC_OFFICE_BATUREVO      0
#define TC_OFFICE_BUSAEVO       1

#define TC_ORDER_GOV            0
#define TC_ORDER_PRIVATE        1
#define TC_ORDER_GOV_PLUS       2

#define TC_POINT_MINE       0
#define TC_POINT_WAREHOUSE  1
#define TC_POINT_PORT       2

#define TC_PARKING_SLOTS_MAX        20
#define TC_PARKING_TRUCK_SLOTS_USED 7
#define TC_PARKING_TRAILER_SLOTS_USED 7


new const Float: g_tc_building_enter[2][4] =
{
	{2327.705566, 2009.635742, 16.620204, 354.957916},
	{-426.065887, -1687.605712, 41.526901, 151.296875}
};

new const Float: g_tc_interior_enter[2][4] =
{
	{-0.251249, 2501.800000, 2011.005126, 0.857749},
	{-0.251249, 2501.800000, 2011.005126, 0.857749}
};

new const g_tc_interior_id = 1;
new const g_tc_interior_vw[2] = {1, 2};

stock TC_PlayerInTcInterior(playerid)
{
	if(GetPlayerInterior(playerid) != g_tc_interior_id) return 0;
	new vw = GetPlayerVirtualWorld(playerid);
	return (vw == g_tc_interior_vw[0] || vw == g_tc_interior_vw[1]);
}

stock TC_CanShowWorldCheckpoint(playerid)
{
	if(TC_PlayerInTcInterior(playerid)) return 0;
	if(GetPlayerInterior(playerid) != 0) return 0;
	return 1;
}

new Float:p_tc_route_mark_x[MAX_PLAYERS];
new Float:p_tc_route_mark_y[MAX_PLAYERS];
new Float:p_tc_route_mark_z[MAX_PLAYERS];
new bool:p_tc_route_marker_active[MAX_PLAYERS];

stock TC_RememberRouteMarkerPos(playerid, Float:x, Float:y, Float:z)
{
	p_tc_route_mark_x[playerid] = x;
	p_tc_route_mark_y[playerid] = y;
	p_tc_route_mark_z[playerid] = z;
	p_tc_route_marker_active[playerid] = true;
	return 1;
}

stock TC_GetActiveRouteMarkerPos(playerid, &Float:x, &Float:y, &Float:z)
{
	if(!p_tc_route_marker_active[playerid]) return 0;
	x = p_tc_route_mark_x[playerid];
	y = p_tc_route_mark_y[playerid];
	z = p_tc_route_mark_z[playerid];
	return 1;
}

stock TC_ShowNotify(playerid, type, duration, caption[], btnCaption[] = "")
{
	new cap[160], btn[32];
	format(cap, sizeof cap, "%s", caption);
	format(btn, sizeof btn, "%s", btnCaption);
	ShowNotificationNew(playerid, type, duration, 0, 0, cap, btn);
	return 1;
}

stock TC_ApplyRouteMarker(playerid, Float:x, Float:y, Float:z, Float:size = TC_ROUTE_CHECKPOINT_SIZE)
{
	TC_RememberRouteMarkerPos(playerid, x, y, z);
	EnablePlayerGPS(playerid, TC_ROUTE_MAP_ICON_TYPE, x, y, z, "");
	SetPlayerCheckpoint(playerid, x, y, z, size, CP_ACTION_TYPE_NONE);
	SetPlayerMapIcon(playerid, TC_ROUTE_MAP_ICON_SLOT, x, y, z, TC_ROUTE_MAP_ICON_TYPE, 0xFFFF24FF, MAPICON_GLOBAL_CHECKPOINT);
	SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_ON);
	return 1;
}

stock TC_ClearRouteMarker(playerid)
{
	p_tc_route_marker_active[playerid] = false;
	RemovePlayerMapIcon(playerid, TC_ROUTE_MAP_ICON_SLOT);
	DisablePlayerGPS(playerid);
	DisablePlayerCheckpoint(playerid);
	return 1;
}

stock TC_PlaceRouteCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size = TC_ROUTE_CHECKPOINT_SIZE)
{
	return TC_ApplyRouteMarker(playerid, x, y, z, size);
}

stock TC_SetRouteCheckpoint(playerid, order_idx, bool:loading, Float:size = TC_ROUTE_CHECKPOINT_SIZE, bool:notify = true)
{
	new Float:x, Float:y, Float:z;
	TC_GetRoutePointPos(order_idx, loading, x, y, z, playerid);
	if(notify)
		TC_SendRouteMessage(playerid, order_idx, loading);
	TC_PlaceRouteCheckpoint(playerid, x, y, z, size);
	return 1;
}

new const Float: g_tc_building_exit[2][4] =
{
	{2327.662353, 2011.768310, 16.121875, 354.957916},
	{-426.906463, -1688.774536, 41.029911, 151.296875}
};

new const Float: g_tc_interior_exit[4] =
	{-0.251249, 2500.500000, 2011.005126, 0.857749};

new const Float: g_tc_marker_order[3] =
	{2.028566, 2503.603271, 2011.005126};

new const Float: g_tc_marker_company_list[3] =
	{-2.693784, 2504.187255, 2011.040039};

new const Float: g_tc_marker_rent[2][3] =
{
	{2320.732666, 2012.828857, 16.121875},
	{-413.875732, -1696.201904, 41.069911}
};

new const Float: g_tc_truck_parking[2][TC_PARKING_SLOTS_MAX][4] =
{
	{
		{2313.000000, 1992.950000, 15.660000, 2.060000},
		{2306.600000, 1992.980000, 15.670000, 2.060000},
		{2300.280000, 1992.310000, 15.660000, 2.060000},
		{2293.740000, 1992.360000, 15.670000, 2.060000},
		{2287.030000, 1993.110000, 15.660000, 2.060000},
		{2280.160000, 1992.920000, 15.670000, 2.060000},
		{2272.570000, 1992.890000, 15.670000, 2.060000},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}
	},
	{
		{-406.060000, -1689.130000, 40.600000, 149.760000},
		{-401.080000, -1692.530000, 40.600000, 149.760000},
		{-395.730000, -1695.842000, 40.600000, 149.760000},
		{-389.300000, -1699.543000, 40.600000, 149.760000},
		{-384.530000, -1702.104000, 40.600000, 149.760000},
		{-379.120000, -1705.562000, 40.600000, 149.760000},
		{-374.090000, -1709.198000, 40.600000, 149.760000},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}
	}
};

new const Float: g_tc_trailer_parking[2][TC_PARKING_SLOTS_MAX][4] =
{
	{
		{2287.050000, 2057.900000, 15.660000, 182.790000},
		{2296.590000, 2058.410000, 15.670000, 182.790000},
		{2307.050000, 2059.090000, 15.670000, 182.790000},
		{2316.680000, 2059.640000, 15.660000, 182.790000},
		{2342.840000, 2058.120000, 15.670000, 182.790000},
		{2348.800000, 2058.290000, 15.670000, 182.790000},
		{2355.140000, 2058.690000, 15.660000, 182.790000},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}
	},
	{
		{-386.510000, -1738.530000, 40.600000, 329.760000},
		{-392.660000, -1737.330000, 40.600000, 329.760000},
		{-397.250000, -1733.010000, 40.600000, 329.760000},
		{-402.830000, -1731.030000, 40.600000, 329.760000},
		{-408.050000, -1728.220000, 40.600000, 329.760000},
		{-412.630000, -1723.960000, 40.600000, 329.760000},
		{-417.880000, -1720.820000, 40.600000, 329.760000},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0}, {0.0, 0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0, 0.0}
	}
};

new const Float: g_tc_gov_points[3][3] =
{
	{2435.937744, 1770.656372, 13.629980},
	{-1329.494628, -1549.859252, 60.841377},
	{-1733.898681, 2207.515869, 9.664999}
};

new const Float: g_tc_mine_load_points[][3] =
{
	{2435.937744, 1770.656372, 13.629980},
	{2372.254638, 1718.976196, 13.696249},
	{2316.785400, 1744.028442, 13.650000}
};

new const Float: g_tc_port_docks[][3] =
{
	{-1732.715454, 2195.462158, 9.674424},
	{-1732.835693, 2201.456298, 9.664999},
	{-1733.898681, 2207.515869, 9.664999},
	{-1734.082641, 2213.364257, 9.664999},
	{-1734.429321, 2219.395507, 9.664999}
};

new const g_tc_point_names[][] =
{
	"Шахта",
	"Загородный склад",
	"Порт"
};

new const g_tc_office_names[][] =
{
	"п. Батырево",
	"тгт. Бусаево"
};

enum E_TC_COMPANY
{
	TC_SQL_ID,
	TC_OFFICE,
	TC_SLOT,
	TC_OWNER_ID,
	TC_BALANCE,
	TC_COMMISSION,
	TC_LAST_RENAME,
	TC_UPG_OFFICE,
	TC_UPG_GARAGE,
	TC_UPG_LICENSE
};

enum E_TC_FLEET
{
	TF_SQL_ID,
	TF_COMPANY_ID,
	TF_MODEL_ID,
	TF_RENT_PRICE,
	TF_TRIPS_LEFT,
	TF_TRIPS_MAX,
	bool:TF_BROKEN,
	TF_RENTED_ACCOUNT_ID
};

enum E_TC_RT_ORDER
{
	RT_USED,
	RT_OFFICE,
	RT_TYPE,
	RT_FROM,
	RT_TO,
	RT_TOTAL_PAY,
	RT_MIN_RATING,
	RT_TRAILER_MODEL,
	RT_BUSINESS_ID,
	RT_AMOUNT,
	RT_SQL_ID,
	RT_CARGO_NAME[24],
	RT_TYPE_NAME[16]
};

new g_tc_companies[TC_COMPANIES_TOTAL][E_TC_COMPANY];
new g_tc_company_name[TC_COMPANIES_TOTAL][48];
new g_tc_owner_name[TC_COMPANIES_TOTAL][24];
new g_tc_company_rating[TC_COMPANIES_TOTAL];
new g_tc_companies_loaded;

new g_tc_fleet[MAX_TC_FLEET][E_TC_FLEET];
new g_tc_fleet_name[MAX_TC_FLEET][32];
new g_tc_fleet_loaded;

new g_tc_rt_orders[MAX_TC_RUNTIME_ORDERS][E_TC_RT_ORDER];
new g_tc_rt_orders_count;

new g_tc_private_business[MAX_BUSINESS] = {-1, ...};


new p_tc_company[MAX_PLAYERS] = {-1, ...};
new p_tc_rating[MAX_PLAYERS];
new p_tc_office[MAX_PLAYERS];
new p_tc_fleet_page[MAX_PLAYERS];
new p_tc_admin_company[MAX_PLAYERS] = {-1, ...};
new p_tc_join_company[MAX_PLAYERS] = {-1, ...};
new p_tc_company_page[MAX_PLAYERS];
new p_tc_rent_page[MAX_PLAYERS];
new p_tc_orders_page[MAX_PLAYERS];
new p_tc_emp_page[MAX_PLAYERS];
new p_tc_emp_view_mode[MAX_PLAYERS];
new p_tc_fire_target[MAX_PLAYERS][24];
new p_tc_emp_row_name[MAX_PLAYERS][TC_EMPLOYEE_PAGE_SIZE][24];
new p_tc_emp_list_shown[MAX_PLAYERS];
new p_tc_emp_total[MAX_PLAYERS];
new p_tc_finance_mode[MAX_PLAYERS];
new p_tc_upgrade_sel[MAX_PLAYERS];
new p_tc_pick_order[MAX_PLAYERS] = {-1, ...};
new p_tc_fleet_sel[MAX_PLAYERS] = {-1, ...};
new p_tc_rent_vehicle[MAX_PLAYERS] = {-1, ...};
new p_tc_rent_fleet_idx[MAX_PLAYERS] = {-1, ...};
new p_tc_trailer_vehicle[MAX_PLAYERS] = {-1, ...};
new p_tc_active_order[MAX_PLAYERS] = {-1, ...};
new p_tc_order_progress[MAX_PLAYERS];
new bool:p_tc_trailer_detached[MAX_PLAYERS];
new bool:p_tc_trailer_was_attached[MAX_PLAYERS];
new p_tc_trailer_detach_misses[MAX_PLAYERS];
new p_tc_trailer_last_recover_ms[MAX_PLAYERS];
new Float:p_tc_trailer_last_x[MAX_PLAYERS];
new Float:p_tc_trailer_last_y[MAX_PLAYERS];
new Float:p_tc_trailer_last_z[MAX_PLAYERS];
new Float:p_tc_trailer_last_a[MAX_PLAYERS];
new bool:p_tc_trailer_has_last_pos[MAX_PLAYERS];
new p_tc_trailer_lock_fail_since_ms[MAX_PLAYERS];
new p_tc_dest_port_dock[MAX_PLAYERS] = {-1, ...};
new p_tc_mine_load_dock[MAX_PLAYERS] = {-1, ...};
new p_tc_rent_timer[MAX_PLAYERS];
new p_tc_rent_sec_left[MAX_PLAYERS];
new p_tc_trailer_watch_timer[MAX_PLAYERS];
new p_tc_operation_timer[MAX_PLAYERS];
new p_tc_operation_watch_timer[MAX_PLAYERS];
new bool:p_tc_operation_loading[MAX_PLAYERS];

stock TC_GetRatingLevel(rating)
{
	if(rating < 10) return 1;
	return 2;
}

stock TC_GetCompanyIndexBySqlId(sql_id)
{
	if(sql_id <= 0) return -1;
	for(new i = 0; i < g_tc_companies_loaded; i++)
		if(g_tc_companies[i][TC_SQL_ID] == sql_id)
			return i;
	return -1;
}

stock TC_GetPlayerCompanyIndex(playerid)
{
	new cid = p_tc_company[playerid];
	if(cid < 0 || cid >= g_tc_companies_loaded)
		return -1;
	return cid;
}

stock TC_IsCompanyOwner(playerid, company_idx)
{
	if(company_idx < 0) return 0;
	return g_tc_companies[company_idx][TC_OWNER_ID] == GetPlayerAccountID(playerid);
}

stock TC_GetOwnedCompanyIndexByAccount(account_id)
{
	if(account_id <= 0) return -1;
	for(new i = 0; i < g_tc_companies_loaded; i++)
		if(g_tc_companies[i][TC_OWNER_ID] == account_id)
			return i;
	return -1;
}

stock TC_GetOwnedCompanyIndex(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	return TC_GetOwnedCompanyIndexByAccount(GetPlayerAccountID(playerid));
}

stock TC_PlayerHasTcCompany(playerid, allow_company_idx = -1)
{
	new member_idx = TC_GetPlayerCompanyIndex(playerid);
	if(member_idx != -1 && member_idx != allow_company_idx)
		return 1;

	new owned_idx = TC_GetOwnedCompanyIndex(playerid);
	if(owned_idx != -1 && owned_idx != allow_company_idx)
		return 1;

	new member_sql = GetPlayerData(playerid, P_TC_COMPANY_ID);
	if(member_sql > 0)
	{
		new idx = TC_GetCompanyIndexBySqlId(member_sql);
		if(idx != -1 && idx != allow_company_idx)
			return 1;
	}
	return 0;
}

stock TC_GetDriverPay(total_pay, commission_percent)
{
	new company_take = total_pay * commission_percent / 100;
	return total_pay - company_take;
}

stock TC_ModelNeedsTrailer(model_id)
{
	return (model_id == 403 || model_id == 413 || model_id == 514 || model_id == 515);
}

stock TC_GetRandomPortDock(&Float:x, &Float:y, &Float:z)
{
	new d = random(sizeof g_tc_port_docks);
	x = g_tc_port_docks[d][0];
	y = g_tc_port_docks[d][1];
	z = g_tc_port_docks[d][2];
	return d;
}

stock TC_IsNearAnyPortDock(playerid, Float:range = 14.0)
{
	for(new d = 0; d < sizeof g_tc_port_docks; d++)
		if(IsPlayerInRangeOfPoint(playerid, range, g_tc_port_docks[d][0], g_tc_port_docks[d][1], g_tc_port_docks[d][2]))
			return 1;
	return 0;
}

stock Float:TC_GetPointsDistanceKm(from_point, to_point)
{
	new Float:dx = g_tc_gov_points[from_point][0] - g_tc_gov_points[to_point][0];
	new Float:dy = g_tc_gov_points[from_point][1] - g_tc_gov_points[to_point][1];
	new Float:dz = g_tc_gov_points[from_point][2] - g_tc_gov_points[to_point][2];
	return floatsqroot(dx * dx + dy * dy + dz * dz) / 1000.0;
}

stock TC_IsParkingSlotValid(office, slot, bool:trailer = false)
{
	if(office < 0 || office > 1) return 0;
	if(slot < 0 || slot >= TC_PARKING_SLOTS_MAX) return 0;

	new used = trailer ? TC_PARKING_TRAILER_SLOTS_USED : TC_PARKING_TRUCK_SLOTS_USED;
	if(slot >= used) return 0;

	new Float:x, Float:y, Float:z;
	if(trailer)
	{
		x = g_tc_trailer_parking[office][slot][0];
		y = g_tc_trailer_parking[office][slot][1];
		z = g_tc_trailer_parking[office][slot][2];
	}
	else
	{
		x = g_tc_truck_parking[office][slot][0];
		y = g_tc_truck_parking[office][slot][1];
		z = g_tc_truck_parking[office][slot][2];
	}
	return (x != 0.0 || y != 0.0 || z != 0.0);
}

stock TC_GetTruckParkingPos(office, slot, &Float:x, &Float:y, &Float:z, &Float:a)
{
	if(!TC_IsParkingSlotValid(office, slot, false)) return 0;
	x = g_tc_truck_parking[office][slot][0];
	y = g_tc_truck_parking[office][slot][1];
	z = g_tc_truck_parking[office][slot][2];
	a = g_tc_truck_parking[office][slot][3];
	return 1;
}

stock TC_GetTrailerParkingPos(office, slot, &Float:x, &Float:y, &Float:z, &Float:a)
{
	if(!TC_IsParkingSlotValid(office, slot, true)) return 0;
	x = g_tc_trailer_parking[office][slot][0];
	y = g_tc_trailer_parking[office][slot][1];
	z = g_tc_trailer_parking[office][slot][2];
	a = g_tc_trailer_parking[office][slot][3];
	return 1;
}

stock TC_GetRandomTruckParkingSlot(office)
{
	#pragma unused office
	return random(TC_PARKING_TRUCK_SLOTS_USED);
}

stock TC_GetRandomTrailerParkingSlot(office)
{
	#pragma unused office
	return random(TC_PARKING_TRAILER_SLOTS_USED);
}

stock TC_GetOfficeByPlayer(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx != -1)
		return g_tc_companies[company_idx][TC_OFFICE];
	if(p_tc_office[playerid] >= 0 && p_tc_office[playerid] <= 1)
		return p_tc_office[playerid];
	return TC_OFFICE_BATUREVO;
}

stock TC_GetOwnerDisplayName(company_idx, dest[], size)
{
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded)
	{
		format(dest, size, "-");
		return 0;
	}
	if(g_tc_companies[company_idx][TC_OWNER_ID] == -1)
	{
		format(dest, size, "Свободна");
		return 0;
	}
	format(dest, size, "%s", g_tc_owner_name[company_idx]);
	return 1;
}

stock TC_FormatMoneyBR(amount, dest[], size)
{
	new src[16], len;
	format(src, sizeof src, "%d", amount);
	len = strlen(src);

	new tmp[20], pos;
	for(new i = len - 1, grp; i >= 0; i--)
	{
		tmp[pos++] = src[i];
		grp++;
		if(grp == 3 && i > 0)
			tmp[pos++] = '.';
	}

	dest[0] = 0;
	for(new j = pos - 1; j >= 0; j--)
	{
		new ch[2];
		ch[0] = tmp[j];
		ch[1] = 0;
		strcat(dest, ch, size);
	}
	return 1;
}

stock TC_GetCompanyDisplayName(company_idx, dest[], size)
{
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded)
	{
		dest[0] = 0;
		return 0;
	}
	format(dest, size, "%s", g_tc_company_name[company_idx]);
	return 1;
}

stock TC_IsValidCompanyName(const name[])
{
	new len = strlen(name);
	if(len < 2 || len > 32) return 0;
	for(new i = 0; i < len; i++)
	{
		new ch = name[i];
		if((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9') || ch == '_' || ch == ' ')
			continue;
		return 0;
	}
	return 1;
}

stock TC_GetMaxEmployees(company_idx)
{
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return TC_EMPLOYEE_LIMIT_BASE;
	if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_OFFICE))
		return TC_EMPLOYEE_LIMIT_OFFICE;
	return TC_EMPLOYEE_LIMIT_BASE;
}

stock TC_GetMaxFleetSlots(company_idx)
{
	new max_slots = TC_FLEET_LIMIT_BASE;
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return max_slots;
	if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_GARAGE))
		max_slots += TC_FLEET_LIMIT_UPGRADE_ADD;
	return max_slots;
}

stock TC_CompanyHasTransportLicense(company_idx)
{
	return TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_LICENSE);
}

stock TC_CountEmployeesSync(company_sql_id)
{
	new query[96], Cache:result = Cache:0, count;
	mysql_format(mysql, query, sizeof query,
		"SELECT COUNT(*) AS cnt FROM tc_employees WHERE company_id=%d", company_sql_id);
	result = mysql_query(mysql, query, true);
	count = 0;
	if(cache_num_rows())
		count = cache_get_field_content_int(0, "cnt");
	cache_delete(result);
	return count;
}

stock TC_CheckEmploymentRequirements(playerid)
{
	if(GetPlayerLevel(playerid) < TC_JOIN_MIN_LEVEL)
	{
		new msg[128];
		format(msg, sizeof msg, TC_MSG"Для работы в ТК нужен {FFFF24}%d{FFFFFF} уровень.", TC_JOIN_MIN_LEVEL);
		SendClientMessage(playerid, TC_COLOR_ERROR, msg);
		return 0;
	}
	if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Для работы в ТК нужны {FFFF24}водительские права{FFFFFF}.");
		return 0;
	}
	return 1;
}

stock TC_CompanyHasUpgrade(company_idx, upgrade_type)
{
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return 0;
	switch(upgrade_type)
	{
		case TC_UPGRADE_OFFICE: return g_tc_companies[company_idx][TC_UPG_OFFICE] != 0;
		case TC_UPGRADE_GARAGE: return g_tc_companies[company_idx][TC_UPG_GARAGE] != 0;
		case TC_UPGRADE_LICENSE: return g_tc_companies[company_idx][TC_UPG_LICENSE] != 0;
	}
	return 0;
}

stock TC_GetFleetSellRefund(model_id)
{
	switch(model_id)
	{
		case TC_VAN_MODEL_DEFAULT: return TC_BUY_VAN_PRICE * TC_FLEET_SELL_REFUND_PERCENT / 100;
		case TC_DAF_MODEL_DEFAULT: return TC_BUY_DAF_PRICE * TC_FLEET_SELL_REFUND_PERCENT / 100;
	}
	return TC_BUY_TRUCK_PRICE * TC_FLEET_SELL_REFUND_PERCENT / 100;
}

stock TC_GetFleetCountForCompany(company_sql_id)
{
	new count;
	for(new i = 0; i < g_tc_fleet_loaded; i++)
		if(g_tc_fleet[i][TF_COMPANY_ID] == company_sql_id)
			count++;
	return count;
}

stock TC_GetFleetUsageText(vehicle_idx, dest[], size)
{
	if(g_tc_fleet[vehicle_idx][TF_BROKEN] || g_tc_fleet[vehicle_idx][TF_TRIPS_LEFT] <= 0)
		format(dest, size, "На Т/О");
	else if(g_tc_fleet[vehicle_idx][TF_RENTED_ACCOUNT_ID] != -1)
		format(dest, size, "Арендована");
	else
		format(dest, size, "Не используется");
	return 1;
}

stock TC_GetRoutePointName(order_idx, bool:loading, dest[], size)
{
	if(order_idx < 0 || order_idx >= MAX_TC_RUNTIME_ORDERS || !g_tc_rt_orders[order_idx][RT_USED])
	{
		format(dest, size, "-");
		return 0;
	}

	if(!loading && g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE && g_tc_rt_orders[order_idx][RT_BUSINESS_ID] >= 0)
	{
		new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
		format(dest, size, "Бизнес \"%s\"", GetBusinessData(bid, B_NAME));
		return 1;
	}

	new point = loading ? g_tc_rt_orders[order_idx][RT_FROM] : g_tc_rt_orders[order_idx][RT_TO];
	if(point == TC_POINT_PORT)
		format(dest, size, "Порт");
	else
		format(dest, size, "%s", g_tc_point_names[point]);
	return 1;
}

stock TC_GetRoutePointPos(order_idx, bool:loading, &Float:x, &Float:y, &Float:z, playerid = INVALID_PLAYER_ID)
{
	if(order_idx < 0 || order_idx >= MAX_TC_RUNTIME_ORDERS || !g_tc_rt_orders[order_idx][RT_USED])
		return 0;

	if(!loading && g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE && g_tc_rt_orders[order_idx][RT_BUSINESS_ID] >= 0)
	{
		new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
		x = GetBusinessData(bid, B_POS_X);
		y = GetBusinessData(bid, B_POS_Y);
		z = GetBusinessData(bid, B_POS_Z);
		return 1;
	}

	new point = loading ? g_tc_rt_orders[order_idx][RT_FROM] : g_tc_rt_orders[order_idx][RT_TO];
	if(point == TC_POINT_PORT)
	{
		if(playerid != INVALID_PLAYER_ID && p_tc_dest_port_dock[playerid] >= 0 && p_tc_dest_port_dock[playerid] < sizeof g_tc_port_docks)
		{
			new d = p_tc_dest_port_dock[playerid];
			x = g_tc_port_docks[d][0];
			y = g_tc_port_docks[d][1];
			z = g_tc_port_docks[d][2];
			return 1;
		}
		x = g_tc_gov_points[TC_POINT_PORT][0];
		y = g_tc_gov_points[TC_POINT_PORT][1];
		z = g_tc_gov_points[TC_POINT_PORT][2];
		return 1;
	}
	if(point == TC_POINT_MINE)
	{
		new d = 0;
		if(playerid != INVALID_PLAYER_ID && p_tc_mine_load_dock[playerid] >= 0
			&& p_tc_mine_load_dock[playerid] < sizeof g_tc_mine_load_points)
			d = p_tc_mine_load_dock[playerid];
		x = g_tc_mine_load_points[d][0];
		y = g_tc_mine_load_points[d][1];
		z = g_tc_mine_load_points[d][2];
		return 1;
	}

	x = g_tc_gov_points[point][0];
	y = g_tc_gov_points[point][1];
	z = g_tc_gov_points[point][2];
	return 1;
}

stock TC_SendRouteMessage(playerid, order_idx, bool:loading)
{
	new pname[48];
	TC_GetRoutePointName(order_idx, loading, pname, sizeof pname);

	new msg[192];
	if(loading)
		format(msg, sizeof msg, "Загрузка: {FFFF24}%s{FFFFFF}.", pname);
	else
		format(msg, sizeof msg, "Разгрузка: {FFFF24}%s{FFFFFF}.", pname);
	TC_Send(playerid, msg);
	return 1;
}

stock TC_SelectMineLoadDock(playerid)
{
	new best = 0;
	new Float:px, Float:py, Float:pz, Float:dist, Float:best_dist = 999999.0;
	GetPlayerPos(playerid, px, py, pz);

	for(new i = 0; i < sizeof g_tc_mine_load_points; i++)
	{
		dist = floatsqroot(
			floatpower(px - g_tc_mine_load_points[i][0], 2.0) +
			floatpower(py - g_tc_mine_load_points[i][1], 2.0) +
			floatpower(pz - g_tc_mine_load_points[i][2], 2.0));
		if(dist < best_dist)
		{
			best_dist = dist;
			best = i;
		}
	}
	p_tc_mine_load_dock[playerid] = best;
	return best;
}

stock TC_IsAtMineLoadPoint(playerid, Float:range = TC_LOAD_POINT_RANGE)
{
	for(new i = 0; i < sizeof g_tc_mine_load_points; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, range,
			g_tc_mine_load_points[i][0], g_tc_mine_load_points[i][1], g_tc_mine_load_points[i][2]))
			return 1;
	}
	return 0;
}
// END INLINED: modules/m1stoks/transportCompany/tcomp_defs.inc
