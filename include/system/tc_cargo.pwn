// =============================================================================
// TC_CARGO — Transport Company delivery gameplay (orders / cargo / trailers)
//
// Ported from bykranin.pwn's modules/m1stoks/transportCompany/* and adapted to
// this project's existing business-based TCompany (see include/system/tcompany.pwn).
//
// WHAT WAS KEPT (the actual "buggy/missing" part the port was requested for):
//   - Government cargo orders (auto-generated mine <-> warehouse <-> port routes)
//   - Accepting an order, driving with a trailer, loading, delivering, getting paid
//   - The full trailer anti-detach/guard/recovery system (this is the trickiest
//     part of the original and is ported almost verbatim; it only touches
//     per-player state, not company data)
//   - Vehicle guard so an active-route truck/trailer can't be destroyed from under
//     the driver by unrelated cleanup code elsewhere in the gamemode
//
// WHAT WAS DELIBERATELY DROPPED (out of scope — nh already has its own systems,
// or these add a lot of surface area not requested):
//   - bykranin's own standalone company/office/employee/finance/rating system.
//     A "TC company" here is exactly what TCompany_* (tcompany.pwn) already
//     manages: a `business` row of type BUSINESS_TYPE_TRUCKING_COMPANY.
//   - Two offices (Baturevo/Busaevo) -> single office, at nh's existing
//     coordinates (g_tcompany_enter_pickup etc. in tcompany.pwn).
//   - Per-shift truck "rental" checkout (TC56/TC_StartRent/TC_EndRent) -> any
//     company vehicle usable by any staff member, matching nh's existing
//     TCompany_CanUseVehicle() model. The "assigned truck" for a route is just
//     whichever company vehicle the driver is sitting in when accepting.
//   - PRIVATE orders (other businesses commissioning cargo) and GOV+ orders
//     (rating-gated) -> only plain GOV orders remain. Rating and its DB columns
//     are not touched.
//   - Commission is a fixed split (TC_CARGO_COMMISSION_PERCENT) instead of a
//     per-company adjustable value, since nh's business struct/UI has no such
//     field. Change the constant below if you want a different split.
//   - Per-vehicle trip wear/breakdown (TF_TRIPS_LEFT/TF_BROKEN) and employee
//     stat tracking (orders_done/earned) -> not ported; no such tables in nh.
//
// Identifier mapping vs bykranin's TC_*:
//   company_idx (bykranin's own g_tc_companies index) -> businessid
//     (nh's g_business index; fetched via TCompany_GetPlayerCompany(playerid))
//   g_tc_companies[idx][TC_BALANCE]  -> AddBusinessData(businessid, B_BALANCE, +, x)
//   g_tc_companies[idx][TC_SQL_ID]   -> GetBusinessData(businessid, B_SQL_ID)
//   g_tc_companies[idx][TC_COMMISSION] -> TC_CARGO_COMMISSION_PERCENT (fixed)
//   p_tc_rent_vehicle[playerid]      -> p_tcc_truck[playerid] (captured at accept time)
// =============================================================================

#if defined _tc_cargo_included
    #endinput
#endif
#define _tc_cargo_included

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------
#define TC_CARGO_COLOR_MSG          0xFFFF24FF
#define TC_CARGO_COLOR_ERROR        0xE04646FF
#define TC_CARGO_COLOR_GOOD         0x66CC33FF
#define TC_CARGO_MSG                "{FFFF24}[Транспортная компания] {FFFFFF}"
#define TC_CARGO_CHAT_MAX           144

#define TC_CARGO_COMMISSION_PERCENT 10   // company keeps 10%, driver gets 90%
#define TCOMPANY_DEFAULT_BUY_PRICE  2000000 // fallback price if a TC business row has no B_PRICE set

#define MAX_TC_CARGO_ORDERS         24
#define TC_CARGO_ORDERS_PAGE_SIZE   10

#define TC_CARGO_TRAILER_RECOVER_COOLDOWN_MS   4000
#define TC_CARGO_TRAILER_SOFT_RECOVER_MISSES   2
#define TC_CARGO_TRAILER_HARD_RECOVER_MISSES   5
#define TC_CARGO_TRAILER_RELINK_DISTANCE        55.0
#define TC_CARGO_TRAILER_HARD_DISTANCE         180.0
#define TC_CARGO_TRAILER_FORCE_SNAP_MS          700
#define TC_CARGO_LOAD_UNLOAD_FREEZE_MS         5000
#define TC_CARGO_LOAD_UNLOAD_WATCH_MS            500
#define TC_CARGO_LOAD_POINT_RANGE               18.0
#define TC_CARGO_UNLOAD_POINT_RANGE             18.0
#define TC_CARGO_ORDER_PICKUP_RANGE              3.0
#define TC_CARGO_ROUTE_CHECKPOINT_SIZE           15.0
#define TC_CARGO_ROUTE_MAP_ICON_SLOT               51
#define TC_CARGO_ROUTE_MAP_ICON_TYPE                2

#define TC_POINT_MINE       0
#define TC_POINT_WAREHOUSE  1
#define TC_POINT_PORT       2

#define DIALOG_TC_CARGO_ORDERS_LIST     (8880)
#define DIALOG_TC_CARGO_ORDER_INFO      (8881)
#define DIALOG_TC_CARGO_TRAILER_RESPAWN (8882)

#define PICKUP_ACTION_TYPE_TC_CARGO_ORDERS  (310)
#define PICKUP_ACTION_TYPE_TC_CARGO_UNLOAD  (311)

#define TC_NOTIFY_INFO_LOCAL    2
#define TC_NOTIFY_ERROR_LOCAL   3
#define TC_NOTIFY_SUCCESS_LOCAL 1

// Same physical building nh's tcompany.pwn already uses for enter/exit/select.
new const Float:g_tcc_office_pos[4] = {2327.705566, 2009.635742, 16.620204, 354.957916};
new const Float:g_tcc_orders_pickup_pos[3] = {2.028566, 2503.603271, 2011.005126};

new const Float:g_tcc_gov_points[3][3] =
{
    {2435.937744, 1770.656372, 13.629980}, // mine
    {-1329.494628, -1549.859252, 60.841377}, // warehouse
    {-1733.898681, 2207.515869, 9.664999} // port
};
new const g_tcc_point_names[][32] = {"Шахта", "Промышленный склад", "Порт"};
new const g_tcc_cargo_names[][24] = {"Руда", "Уголь", "Оборудование"};

new const Float:g_tcc_mine_load_points[][3] =
{
    {2435.937744, 1770.656372, 13.629980},
    {2372.254638, 1718.976196, 13.696249},
    {2316.785400, 1744.028442, 13.650000}
};
new const Float:g_tcc_port_docks[][3] =
{
    {-1732.715454, 2195.462158, 9.674424},
    {-1732.835693, 2201.456298, 9.664999},
    {-1733.898681, 2207.515869, 9.664999},
    {-1734.082641, 2213.364257, 9.664999},
    {-1734.429321, 2219.395507, 9.664999}
};

// Reuses nh's existing fleet spawn slots (tcompany.pwn) as truck parking, and
// piggybacks a trailer parking row right behind them.
new const Float:g_tcc_trailer_parking[TCOMPANY_MAX_FLEET][4] =
{
    {2342.5000, 2050.2000, 15.9500, 180.0},
    {2337.5000, 2050.2000, 15.9500, 180.0},
    {2332.5000, 2050.2000, 15.9500, 180.0},
    {2327.5000, 2050.2000, 15.9500, 180.0},
    {2322.5000, 2050.2000, 15.9500, 180.0},
    {2317.5000, 2050.2000, 15.9500, 180.0},
    {2342.5000, 2062.0000, 15.9500, 0.0},
    {2337.5000, 2062.0000, 15.9500, 0.0},
    {2332.5000, 2062.0000, 15.9500, 0.0},
    {2327.5000, 2062.0000, 15.9500, 0.0},
    {2322.5000, 2062.0000, 15.9500, 0.0},
    {2317.5000, 2062.0000, 15.9500, 0.0}
};

// ---------------------------------------------------------------------------
// Runtime order table
// ---------------------------------------------------------------------------
enum E_TCC_ORDER
{
    bool:TCC_USED,
    TCC_FROM,
    TCC_TO,
    TCC_TOTAL_PAY,
    TCC_TRAILER_MODEL,
    TCC_CARGO_NAME[24]
};
new g_tcc_orders[MAX_TC_CARGO_ORDERS][E_TCC_ORDER];
new g_tcc_orders_count;

new g_tcc_enter_pickup = -1;
new g_tcc_orders_pickup = -1;
new Text3D:g_tcc_orders_label = Text3D:-1;

// ---------------------------------------------------------------------------
// Per-player state
// ---------------------------------------------------------------------------
new p_tcc_active_order[MAX_PLAYERS] = {-1, ...};
new p_tcc_order_progress[MAX_PLAYERS];             // 0=need trailer,1=trailer en route,2=driving to load,3=driving to unload
new p_tcc_truck[MAX_PLAYERS] = {-1, ...};
new p_tcc_trailer[MAX_PLAYERS] = {-1, ...};
new bool:p_tcc_trailer_detached[MAX_PLAYERS];
new bool:p_tcc_trailer_was_attached[MAX_PLAYERS];
new p_tcc_trailer_detach_misses[MAX_PLAYERS];
new p_tcc_trailer_last_recover_ms[MAX_PLAYERS];
new p_tcc_trailer_lock_fail_since_ms[MAX_PLAYERS];
new Float:p_tcc_trailer_last_x[MAX_PLAYERS];
new Float:p_tcc_trailer_last_y[MAX_PLAYERS];
new Float:p_tcc_trailer_last_z[MAX_PLAYERS];
new bool:p_tcc_trailer_has_last_pos[MAX_PLAYERS];
new p_tcc_dest_port_dock[MAX_PLAYERS] = {-1, ...};
new p_tcc_mine_load_dock[MAX_PLAYERS] = {-1, ...};
new p_tcc_operation_timer[MAX_PLAYERS];
new p_tcc_operation_watch_timer[MAX_PLAYERS];
new bool:p_tcc_operation_loading[MAX_PLAYERS];
new bool:p_tcc_route_marker_active[MAX_PLAYERS];

// ---------------------------------------------------------------------------
// Vehicle guard: protect an active route's truck/trailer from any DestroyVehicle
// call anywhere else in the gamemode. Safe to ALS-hook: nothing else in this
// codebase hooks DestroyVehicle (verified), so there is no chain collision risk.
// ---------------------------------------------------------------------------
new bool:g_tcc_guarded_vehicle[MAX_VEHICLES];

stock TCC_GuardVehicle(vehicleid, bool:guard)
{
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
    g_tcc_guarded_vehicle[vehicleid] = guard;
    return 1;
}

stock bool:TCC_IsGuardedVehicle(vehicleid)
{
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return false;
    return g_tcc_guarded_vehicle[vehicleid];
}

stock TCC_ForceDestroyVehicle(vehicleid)
{
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
    TCC_GuardVehicle(vehicleid, false);
    return DestroyVehicle(vehicleid); // real native: our #define below has not applied yet at this point in the file
}

stock tcc_DestroyVehicle(vehicleid)
{
    if(TCC_IsGuardedVehicle(vehicleid))
    {
        printf("[TC_CARGO]: blocked DestroyVehicle on guarded vehicle #%d", vehicleid);
        return 0;
    }
    return DestroyVehicle(vehicleid); // real native: our #define below has not applied yet at this point in the file
}

#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle tcc_DestroyVehicle

// ---------------------------------------------------------------------------
// Small helpers
// ---------------------------------------------------------------------------
stock TCC_Send(playerid, const message[])
{
    new buf[196];
    format(buf, sizeof buf, "%s%s", TC_CARGO_MSG, message);
    SendClientMessage(playerid, TC_CARGO_COLOR_MSG, buf);
    return 1;
}

stock TCC_ModelNeedsTrailer(model_id)
{
    return (model_id == 403 || model_id == 413 || model_id == 514 || model_id == 515);
}

stock Float:TCC_GetPointsDistanceKm(from_point, to_point)
{
    new Float:dx = g_tcc_gov_points[from_point][0] - g_tcc_gov_points[to_point][0];
    new Float:dy = g_tcc_gov_points[from_point][1] - g_tcc_gov_points[to_point][1];
    new Float:dz = g_tcc_gov_points[from_point][2] - g_tcc_gov_points[to_point][2];
    return floatsqroot(dx * dx + dy * dy + dz * dz) / 1000.0;
}

stock TCC_GetRoutePointPos(order_idx, bool:loading, &Float:x, &Float:y, &Float:z, playerid = INVALID_PLAYER_ID)
{
    if(order_idx < 0 || order_idx >= MAX_TC_CARGO_ORDERS || !g_tcc_orders[order_idx][TCC_USED]) return 0;

    new point = loading ? g_tcc_orders[order_idx][TCC_FROM] : g_tcc_orders[order_idx][TCC_TO];
    if(point == TC_POINT_PORT)
    {
        if(playerid != INVALID_PLAYER_ID && p_tcc_dest_port_dock[playerid] >= 0 && p_tcc_dest_port_dock[playerid] < sizeof g_tcc_port_docks)
        {
            new d = p_tcc_dest_port_dock[playerid];
            x = g_tcc_port_docks[d][0]; y = g_tcc_port_docks[d][1]; z = g_tcc_port_docks[d][2];
            return 1;
        }
        x = g_tcc_gov_points[TC_POINT_PORT][0]; y = g_tcc_gov_points[TC_POINT_PORT][1]; z = g_tcc_gov_points[TC_POINT_PORT][2];
        return 1;
    }
    if(point == TC_POINT_MINE)
    {
        new d = 0;
        if(playerid != INVALID_PLAYER_ID && p_tcc_mine_load_dock[playerid] >= 0 && p_tcc_mine_load_dock[playerid] < sizeof g_tcc_mine_load_points)
            d = p_tcc_mine_load_dock[playerid];
        x = g_tcc_mine_load_points[d][0]; y = g_tcc_mine_load_points[d][1]; z = g_tcc_mine_load_points[d][2];
        return 1;
    }
    x = g_tcc_gov_points[point][0]; y = g_tcc_gov_points[point][1]; z = g_tcc_gov_points[point][2];
    return 1;
}

stock TCC_SelectMineLoadDock(playerid)
{
    new best = 0;
    new Float:px, Float:py, Float:pz, Float:dist, Float:best_dist = 999999.0;
    GetPlayerPos(playerid, px, py, pz);
    for(new i = 0; i < sizeof g_tcc_mine_load_points; i++)
    {
        dist = floatsqroot(floatpower(px - g_tcc_mine_load_points[i][0], 2.0) + floatpower(py - g_tcc_mine_load_points[i][1], 2.0) + floatpower(pz - g_tcc_mine_load_points[i][2], 2.0));
        if(dist < best_dist) { best_dist = dist; best = i; }
    }
    p_tcc_mine_load_dock[playerid] = best;
    return best;
}

stock TCC_IsAtMineLoadPoint(playerid, Float:range = TC_CARGO_LOAD_POINT_RANGE)
{
    for(new i = 0; i < sizeof g_tcc_mine_load_points; i++)
        if(IsPlayerInRangeOfPoint(playerid, range, g_tcc_mine_load_points[i][0], g_tcc_mine_load_points[i][1], g_tcc_mine_load_points[i][2]))
            return 1;
    return 0;
}

stock TCC_IsNearAnyPortDock(playerid, Float:range = 14.0)
{
    for(new d = 0; d < sizeof g_tcc_port_docks; d++)
        if(IsPlayerInRangeOfPoint(playerid, range, g_tcc_port_docks[d][0], g_tcc_port_docks[d][1], g_tcc_port_docks[d][2]))
            return 1;
    return 0;
}

stock TCC_ApplyRouteMarker(playerid, Float:x, Float:y, Float:z, Float:size = TC_CARGO_ROUTE_CHECKPOINT_SIZE)
{
    p_tcc_route_marker_active[playerid] = true;
    SetPlayerCheckpoint(playerid, x, y, z, size);
    SetPlayerMapIcon(playerid, TC_CARGO_ROUTE_MAP_ICON_SLOT, x, y, z, TC_CARGO_ROUTE_MAP_ICON_TYPE, 0xFFFF24FF, MAPICON_LOCAL);
    return 1;
}

stock TCC_ClearRouteMarker(playerid)
{
    p_tcc_route_marker_active[playerid] = false;
    RemovePlayerMapIcon(playerid, TC_CARGO_ROUTE_MAP_ICON_SLOT);
    DisablePlayerCheckpoint(playerid);
    return 1;
}

stock TCC_SendRouteMessage(playerid, order_idx, bool:loading)
{
    new point = loading ? g_tcc_orders[order_idx][TCC_FROM] : g_tcc_orders[order_idx][TCC_TO];
    new msg[128];
    format(msg, sizeof msg, "%s: {FFFF24}%s{FFFFFF}.", loading ? ("Погрузка") : ("Разгрузка"), g_tcc_point_names[point]);
    TCC_Send(playerid, msg);
    return 1;
}

stock TCC_SetRouteCheckpoint(playerid, order_idx, bool:loading, Float:size = TC_CARGO_ROUTE_CHECKPOINT_SIZE)
{
    new Float:x, Float:y, Float:z;
    TCC_GetRoutePointPos(order_idx, loading, x, y, z, playerid);
    TCC_SendRouteMessage(playerid, order_idx, loading);
    TCC_ApplyRouteMarker(playerid, x, y, z, size);
    return 1;
}

stock TCC_IsAtLoadPoint(playerid, order_idx)
{
    if(g_tcc_orders[order_idx][TCC_FROM] == TC_POINT_MINE)
        return TCC_IsAtMineLoadPoint(playerid, TC_CARGO_LOAD_POINT_RANGE);
    new Float:fx, Float:fy, Float:fz;
    TCC_GetRoutePointPos(order_idx, true, fx, fy, fz, playerid);
    return IsPlayerInRangeOfPoint(playerid, TC_CARGO_LOAD_POINT_RANGE, fx, fy, fz);
}

stock TCC_IsAtUnloadPoint(playerid, order_idx)
{
    if(g_tcc_orders[order_idx][TCC_TO] == TC_POINT_PORT)
    {
        if(p_tcc_dest_port_dock[playerid] >= 0 && p_tcc_dest_port_dock[playerid] < sizeof g_tcc_port_docks)
        {
            new d = p_tcc_dest_port_dock[playerid];
            if(IsPlayerInRangeOfPoint(playerid, TC_CARGO_UNLOAD_POINT_RANGE, g_tcc_port_docks[d][0], g_tcc_port_docks[d][1], g_tcc_port_docks[d][2]))
                return 1;
        }
        return TCC_IsNearAnyPortDock(playerid, TC_CARGO_UNLOAD_POINT_RANGE);
    }
    new Float:dx, Float:dy, Float:dz;
    TCC_GetRoutePointPos(order_idx, false, dx, dy, dz, playerid);
    return IsPlayerInRangeOfPoint(playerid, TC_CARGO_UNLOAD_POINT_RANGE, dx, dy, dz);
}

stock TCC_SetUnloadCheckpoint(playerid, order_idx, bool:notify = true)
{
    new Float:x, Float:y, Float:z;
    new to_point = g_tcc_orders[order_idx][TCC_TO];
    if(to_point == TC_POINT_PORT)
    {
        new d = random(sizeof g_tcc_port_docks);
        p_tcc_dest_port_dock[playerid] = d;
        x = g_tcc_port_docks[d][0]; y = g_tcc_port_docks[d][1]; z = g_tcc_port_docks[d][2];
    }
    else
    {
        p_tcc_dest_port_dock[playerid] = -1;
        TCC_GetRoutePointPos(order_idx, false, x, y, z, playerid);
    }
    if(notify) TCC_SendRouteMessage(playerid, order_idx, false);
    TCC_ApplyRouteMarker(playerid, x, y, z, TC_CARGO_ROUTE_CHECKPOINT_SIZE);
    return 1;
}

// ---------------------------------------------------------------------------
// Order generation (GOV orders only — auto, no employer, refreshed on startup)
// ---------------------------------------------------------------------------
stock TCC_GenerateGovOrders()
{
    g_tcc_orders_count = 0;
    new routes[3][2] = {{TC_POINT_MINE, TC_POINT_WAREHOUSE}, {TC_POINT_WAREHOUSE, TC_POINT_PORT}, {TC_POINT_MINE, TC_POINT_PORT}};

    for(new r = 0; r < 3 && g_tcc_orders_count < MAX_TC_CARGO_ORDERS; r++)
    {
        new idx = g_tcc_orders_count++;
        g_tcc_orders[idx][TCC_USED] = true;
        g_tcc_orders[idx][TCC_FROM] = routes[r][0];
        g_tcc_orders[idx][TCC_TO] = routes[r][1];
        g_tcc_orders[idx][TCC_TRAILER_MODEL] = 435;
        format(g_tcc_orders[idx][TCC_CARGO_NAME], 24, "%s", g_tcc_cargo_names[r % sizeof(g_tcc_cargo_names)]);
        new Float:km = TCC_GetPointsDistanceKm(routes[r][0], routes[r][1]);
        g_tcc_orders[idx][TCC_TOTAL_PAY] = floatround(km * 10000.0) + random(5000) + 30000;
    }
    return g_tcc_orders_count;
}

// ---------------------------------------------------------------------------
// Trailer link / guard / recovery (ported near-verbatim — self-contained on
// per-player state, does not touch company data at all)
// ---------------------------------------------------------------------------
stock TCC_GetTrailerDistance(playerid, &Float:dist)
{
    new truck = p_tcc_truck[playerid], trailer = p_tcc_trailer[playerid];
    if(truck == -1 || trailer == -1) return 0;
    new Float:tx, Float:ty, Float:tz, Float:px, Float:py, Float:pz;
    GetVehiclePos(trailer, tx, ty, tz);
    GetVehiclePos(truck, px, py, pz);
    new Float:dx = tx - px, Float:dy = ty - py, Float:dz = tz - pz;
    dist = floatsqroot(dx * dx + dy * dy + dz * dz);
    return 1;
}

stock TCC_IsTrailerNearTruck(playerid, Float:max_dist)
{
    new Float:dist;
    if(!TCC_GetTrailerDistance(playerid, dist)) return 0;
    return dist <= max_dist;
}

stock bool:TCC_IsTrailerPhysicallyLinked(playerid)
{
    new truck = p_tcc_truck[playerid], trailer = p_tcc_trailer[playerid];
    if(truck == -1 || trailer == -1 || !IsValidVehicle(truck) || !IsValidVehicle(trailer)) return false;
    return IsTrailerAttachedToVehicle(truck) && GetVehicleTrailer(truck) == trailer;
}

stock TCC_IsTrailerLinked(playerid)
{
    if(p_tcc_truck[playerid] == -1 || p_tcc_trailer[playerid] == -1) return 0;
    if(!IsValidVehicle(p_tcc_truck[playerid]) || !IsValidVehicle(p_tcc_trailer[playerid])) return 0;

    new truck = p_tcc_truck[playerid], trailer = p_tcc_trailer[playerid];
    if(!IsTrailerAttachedToVehicle(truck)) return 0;

    new linked = GetVehicleTrailer(truck);
    if(linked == trailer) return 1;
    if(linked == 0)
    {
        new Float:dist;
        if(TCC_GetTrailerDistance(playerid, dist) && dist < 20.0) return 1;
    }
    return 0;
}

stock TCC_GetTrailerRecoveryPos(playerid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    new truck = p_tcc_truck[playerid];
    if(truck == -1 || !IsValidVehicle(truck)) return 0;
    GetVehiclePos(truck, x, y, z);
    GetVehicleZAngle(truck, a);
    x -= 5.0 * floatsin(-a, degrees);
    y -= 5.0 * floatcos(-a, degrees);
    return 1;
}

stock TCC_OnTrailerAttached(playerid)
{
    if(p_tcc_active_order[playerid] == -1) return 0;
    new order_idx = p_tcc_active_order[playerid];
    if(p_tcc_order_progress[playerid] == 1)
    {
        TCC_ClearRouteMarker(playerid);
        p_tcc_order_progress[playerid] = 2;
        if(g_tcc_orders[order_idx][TCC_FROM] == TC_POINT_MINE) TCC_SelectMineLoadDock(playerid);
        TCC_SetRouteCheckpoint(playerid, order_idx, true, TC_CARGO_ROUTE_CHECKPOINT_SIZE);
    }
    return 1;
}

stock TCC_OnTrailerLinked(playerid)
{
    if(p_tcc_trailer_was_attached[playerid]) return 1;
    p_tcc_trailer_was_attached[playerid] = true;
    p_tcc_trailer_detached[playerid] = false;
    p_tcc_trailer_detach_misses[playerid] = 0;
    p_tcc_trailer_lock_fail_since_ms[playerid] = 0;
    TCC_OnTrailerAttached(playerid);
    return 1;
}

stock TCC_TryDetectTrailerLink(playerid)
{
    if(p_tcc_active_order[playerid] == -1 || p_tcc_trailer[playerid] == -1) return 0;
    if(p_tcc_order_progress[playerid] < 1) return 0;
    new truck = p_tcc_truck[playerid];
    if(truck == -1 || GetPlayerVehicleID(playerid) != truck || !IsValidVehicle(truck)) return 0;
    new trailer = p_tcc_trailer[playerid];
    if(!IsValidVehicle(trailer)) return 0;

    if(TCC_IsTrailerLinked(playerid)) return TCC_OnTrailerLinked(playerid);

    if(p_tcc_order_progress[playerid] == 1 && TCC_IsTrailerNearTruck(playerid, 22.0))
    {
        AttachTrailerToVehicle(trailer, truck);
        if(TCC_IsTrailerLinked(playerid)) return TCC_OnTrailerLinked(playerid);
    }
    return 0;
}

// Hard lock for an accepted route: once attached (progress >= 2) the trailer
// must never remain detached — this is what makes the mechanic reliable on
// laggy/mobile clients instead of "randomly losing the trailer".
stock TCC_ForceTrailerLock(playerid, bool:allow_snap = true)
{
    if(p_tcc_active_order[playerid] == -1 || p_tcc_order_progress[playerid] < 2) return 0;
    if(!TCC_ModelNeedsTrailer(GetVehicleModel(p_tcc_truck[playerid]))) return 1;

    new truck = p_tcc_truck[playerid], trailer = p_tcc_trailer[playerid];
    if(truck == -1 || trailer == -1 || !IsValidVehicle(truck) || !IsValidVehicle(trailer)) return 0;

    TCC_GuardVehicle(trailer, true);
    SetVehicleHealth(trailer, 100000.0);
    SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
    LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));

    if(TCC_IsTrailerPhysicallyLinked(playerid))
    {
        p_tcc_trailer_lock_fail_since_ms[playerid] = 0;
        p_tcc_trailer_detach_misses[playerid] = 0;
        p_tcc_trailer_detached[playerid] = false;
        p_tcc_trailer_was_attached[playerid] = true;
        GetVehiclePos(trailer, p_tcc_trailer_last_x[playerid], p_tcc_trailer_last_y[playerid], p_tcc_trailer_last_z[playerid]);
        p_tcc_trailer_has_last_pos[playerid] = true;
        return 1;
    }

    new linked = GetVehicleTrailer(truck);
    if(linked != 0 && linked != trailer) DetachTrailerFromVehicle(truck);

    AttachTrailerToVehicle(trailer, truck);
    p_tcc_trailer_detached[playerid] = false;
    p_tcc_trailer_was_attached[playerid] = true;
    p_tcc_trailer_detach_misses[playerid] = 0;
    p_tcc_trailer_last_recover_ms[playerid] = 0;

    if(TCC_IsTrailerPhysicallyLinked(playerid))
    {
        p_tcc_trailer_lock_fail_since_ms[playerid] = 0;
        return 1;
    }

    new now = GetTickCount();
    if(p_tcc_trailer_lock_fail_since_ms[playerid] == 0) p_tcc_trailer_lock_fail_since_ms[playerid] = now;

    if(allow_snap && now - p_tcc_trailer_lock_fail_since_ms[playerid] >= TC_CARGO_TRAILER_FORCE_SNAP_MS)
    {
        new Float:x, Float:y, Float:z, Float:a;
        if(TCC_GetTrailerRecoveryPos(playerid, x, y, z, a))
        {
            SetVehiclePos(trailer, x, y, z);
            SetVehicleZAngle(trailer, a);
            SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
            LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));
            AttachTrailerToVehicle(trailer, truck);
            p_tcc_trailer_lock_fail_since_ms[playerid] = now;
            p_tcc_trailer_last_x[playerid] = x; p_tcc_trailer_last_y[playerid] = y; p_tcc_trailer_last_z[playerid] = z;
            p_tcc_trailer_has_last_pos[playerid] = true;
        }
    }
    return 1;
}

stock TCC_RecoverTrailerForActiveCargo(playerid, bool:allow_recreate = true)
{
    if(p_tcc_active_order[playerid] == -1 || p_tcc_order_progress[playerid] < 2) return 0;
    new truck = p_tcc_truck[playerid];
    if(truck == -1 || !IsValidVehicle(truck)) return 0;
    if(GetPlayerVehicleID(playerid) != truck) return 0;
    if(!TCC_ModelNeedsTrailer(GetVehicleModel(truck))) return 1;

    new now = GetTickCount();
    if(p_tcc_trailer_last_recover_ms[playerid] != 0 && now - p_tcc_trailer_last_recover_ms[playerid] < TC_CARGO_TRAILER_RECOVER_COOLDOWN_MS)
        return 0;
    p_tcc_trailer_last_recover_ms[playerid] = now;

    new trailer = p_tcc_trailer[playerid];
    if(trailer != -1 && IsValidVehicle(trailer))
    {
        if(TCC_ForceTrailerLock(playerid, true)) return 1;

        TCC_GuardVehicle(trailer, true);
        SetVehicleHealth(trailer, 100000.0);
        SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
        LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));

        new Float:dist = 99999.0;
        TCC_GetTrailerDistance(playerid, dist);

        if(dist <= TC_CARGO_TRAILER_RELINK_DISTANCE)
        {
            AttachTrailerToVehicle(trailer, truck);
            if(TCC_IsTrailerLinked(playerid))
            {
                p_tcc_trailer_detached[playerid] = false;
                p_tcc_trailer_was_attached[playerid] = true;
                p_tcc_trailer_detach_misses[playerid] = 0;
                GetVehiclePos(trailer, p_tcc_trailer_last_x[playerid], p_tcc_trailer_last_y[playerid], p_tcc_trailer_last_z[playerid]);
                p_tcc_trailer_has_last_pos[playerid] = true;
                return 1;
            }
        }

        if(p_tcc_trailer_detach_misses[playerid] >= TC_CARGO_TRAILER_HARD_RECOVER_MISSES || dist > TC_CARGO_TRAILER_HARD_DISTANCE)
        {
            new Float:x, Float:y, Float:z, Float:a;
            if(TCC_GetTrailerRecoveryPos(playerid, x, y, z, a))
            {
                SetVehiclePos(trailer, x, y, z);
                SetVehicleZAngle(trailer, a);
                SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
                LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));
                AttachTrailerToVehicle(trailer, truck);
                p_tcc_trailer_detached[playerid] = false;
                p_tcc_trailer_was_attached[playerid] = true;
                p_tcc_trailer_detach_misses[playerid] = 0;
                p_tcc_trailer_last_x[playerid] = x; p_tcc_trailer_last_y[playerid] = y; p_tcc_trailer_last_z[playerid] = z;
                p_tcc_trailer_has_last_pos[playerid] = true;
                return 1;
            }
        }
        return 0;
    }

    if(!allow_recreate) return 0;

    new order_idx = p_tcc_active_order[playerid];
    if(order_idx < 0 || order_idx >= MAX_TC_CARGO_ORDERS) return 0;
    new trailer_model = g_tcc_orders[order_idx][TCC_TRAILER_MODEL];
    new Float:x, Float:y, Float:z, Float:a;
    if(!TCC_GetTrailerRecoveryPos(playerid, x, y, z, a)) return 0;

    new trailerid = CreateVehicle(trailer_model, x, y, z, a, random(126), random(126), -1, 0, VEHICLE_ACTION_TYPE_TRUCKER, VEHICLE_ACTION_ID_NONE);
    if(trailerid == INVALID_VEHICLE_ID) return 0;

    p_tcc_trailer[playerid] = trailerid;
    TCC_GuardVehicle(trailerid, true);
    SetVehicleHealth(trailerid, 100000.0);
    SetVehicleVirtualWorld(trailerid, GetVehicleVirtualWorld(truck));
    LinkVehicleToInterior(trailerid, GetPlayerInterior(playerid));
    AttachTrailerToVehicle(trailerid, truck);

    p_tcc_trailer_detached[playerid] = false;
    p_tcc_trailer_was_attached[playerid] = true;
    p_tcc_trailer_detach_misses[playerid] = 0;
    p_tcc_trailer_last_x[playerid] = x; p_tcc_trailer_last_y[playerid] = y; p_tcc_trailer_last_z[playerid] = z;
    p_tcc_trailer_has_last_pos[playerid] = true;
    return 1;
}

// Called every tick from OnPlayerUpdate (see hook below) while a route is active.
stock TCC_MaintainTrailerOnRoute(playerid)
{
    if(p_tcc_active_order[playerid] == -1 || p_tcc_order_progress[playerid] < 2) return 0;

    new truck = p_tcc_truck[playerid];
    if(truck == -1 || !IsValidVehicle(truck)) return 0;
    if(!TCC_ModelNeedsTrailer(GetVehicleModel(truck))) return 1;

    new trailer = p_tcc_trailer[playerid];
    if(trailer == -1 || !IsValidVehicle(trailer))
    {
        if(trailer != -1) TCC_GuardVehicle(trailer, false);
        p_tcc_trailer[playerid] = -1;
        p_tcc_trailer_last_recover_ms[playerid] = 0;
        p_tcc_trailer_lock_fail_since_ms[playerid] = 0;
        if(GetPlayerVehicleID(playerid) == truck) TCC_RecoverTrailerForActiveCargo(playerid, true);
        return p_tcc_trailer[playerid] != -1;
    }
    return TCC_ForceTrailerLock(playerid, true);
}

stock TCC_EnsureTrailerForCargo(playerid)
{
    new truck = p_tcc_truck[playerid];
    if(truck == -1) return 0;
    if(!TCC_ModelNeedsTrailer(GetVehicleModel(truck))) return 1;

    if(p_tcc_order_progress[playerid] >= 2)
    {
        if(TCC_ForceTrailerLock(playerid, true)) return 1;
        TCC_RecoverTrailerForActiveCargo(playerid, true);
        return p_tcc_trailer[playerid] != -1;
    }

    if(TCC_IsTrailerLinked(playerid)) return 1;

    new trailer = p_tcc_trailer[playerid];
    if(trailer == -1 || !IsValidVehicle(trailer) || GetPlayerVehicleID(playerid) != truck) return 0;

    SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
    LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));
    AttachTrailerToVehicle(trailer, truck);
    if(TCC_IsTrailerLinked(playerid))
    {
        p_tcc_trailer_was_attached[playerid] = true;
        return 1;
    }
    return 0;
}

stock TCC_SpawnTrailerForPlayer(playerid, bool:respawn_detach)
{
    new truck = p_tcc_truck[playerid];
    if(truck == -1 || p_tcc_active_order[playerid] == -1)
    {
        TCC_Send(playerid, "Сначала возьмите заказ и сядьте в грузовик компании.");
        return 0;
    }

    new order_idx = p_tcc_active_order[playerid];
    if(!TCC_ModelNeedsTrailer(GetVehicleModel(truck)))
    {
        TCC_Send(playerid, "Вашему транспорту не нужен прицеп для этого рейса.");
        return 0;
    }

    if(p_tcc_trailer[playerid] != -1 && IsValidVehicle(p_tcc_trailer[playerid]))
    {
        if(!respawn_detach && !p_tcc_trailer_detached[playerid])
        {
            TCC_Send(playerid, "Прицеп уже выдан. Вернитесь к нему и подцепите.");
            return 0;
        }
        TCC_ForceDestroyVehicle(p_tcc_trailer[playerid]);
        p_tcc_trailer[playerid] = -1;
    }

    p_tcc_trailer_detached[playerid] = false;
    p_tcc_trailer_was_attached[playerid] = false;
    p_tcc_trailer_detach_misses[playerid] = 0;
    p_tcc_trailer_last_recover_ms[playerid] = 0;
    p_tcc_trailer_lock_fail_since_ms[playerid] = 0;
    p_tcc_order_progress[playerid] = 1;

    new slot = random(sizeof g_tcc_trailer_parking);
    new Float:x = g_tcc_trailer_parking[slot][0], Float:y = g_tcc_trailer_parking[slot][1];
    new Float:z = g_tcc_trailer_parking[slot][2], Float:a = g_tcc_trailer_parking[slot][3];

    new trailer_model = g_tcc_orders[order_idx][TCC_TRAILER_MODEL];
    new trailerid = CreateVehicle(trailer_model, x, y, z, a, random(126), random(126), -1, 0, VEHICLE_ACTION_TYPE_TRUCKER, VEHICLE_ACTION_ID_NONE);
    if(trailerid == INVALID_VEHICLE_ID) return 0;

    p_tcc_trailer[playerid] = trailerid;
    TCC_GuardVehicle(trailerid, true);
    SetVehicleHealth(trailerid, 100000.0);
    SetVehicleVirtualWorld(trailerid, GetVehicleVirtualWorld(truck));
    p_tcc_trailer_last_x[playerid] = x; p_tcc_trailer_last_y[playerid] = y; p_tcc_trailer_last_z[playerid] = z;
    p_tcc_trailer_has_last_pos[playerid] = true;

    TCC_Send(playerid, "Прицеп выдан. Подъедьте к нему и подцепите (сдавайте задним ходом).");
    TCC_ApplyRouteMarker(playerid, x, y, z, 6.0);
    return 1;
}

// ---------------------------------------------------------------------------
// Load / unload freeze-and-verify mechanic
// ---------------------------------------------------------------------------
stock TCC_IsPlayerInAssignedTruck(playerid)
{
    if(p_tcc_truck[playerid] == -1 || !IsValidVehicle(p_tcc_truck[playerid])) return 0;
    return GetPlayerVehicleID(playerid) == p_tcc_truck[playerid];
}

stock TCC_CancelLoadUnloadOperation(playerid)
{
    if(p_tcc_operation_timer[playerid]) { KillTimer(p_tcc_operation_timer[playerid]); p_tcc_operation_timer[playerid] = 0; }
    if(p_tcc_operation_watch_timer[playerid]) { KillTimer(p_tcc_operation_watch_timer[playerid]); p_tcc_operation_watch_timer[playerid] = 0; }
    p_tcc_operation_loading[playerid] = false;
    if(IsPlayerConnected(playerid)) TogglePlayerControllable(playerid, true);
    return 1;
}

stock TCC_StartLoadUnloadOperation(playerid, bool:loading)
{
    if(p_tcc_operation_timer[playerid]) return 1;
    if(!TCC_IsPlayerInAssignedTruck(playerid))
    {
        TCC_Send(playerid, loading ? ("Для загрузки нужно быть в своём грузовике.") : ("Для разгрузки нужно быть в своём грузовике."));
        return 1;
    }

    TogglePlayerControllable(playerid, false);
    p_tcc_operation_loading[playerid] = loading;
    ShowNotificationNew(playerid, TC_NOTIFY_INFO_LOCAL, 5, 0, 0, loading ? ("Идёт погрузка груза...") : ("Идёт разгрузка груза..."), "");

    p_tcc_operation_watch_timer[playerid] = SetTimerEx("TCC_LoadUnloadWatch", TC_CARGO_LOAD_UNLOAD_WATCH_MS, true, "i", playerid);
    p_tcc_operation_timer[playerid] = SetTimerEx("TCC_OnLoadUnloadDone", TC_CARGO_LOAD_UNLOAD_FREEZE_MS, false, "i", playerid);
    return 1;
}

forward TCC_LoadUnloadWatch(playerid);
public TCC_LoadUnloadWatch(playerid)
{
    if(!p_tcc_operation_timer[playerid])
    {
        if(p_tcc_operation_watch_timer[playerid]) { KillTimer(p_tcc_operation_watch_timer[playerid]); p_tcc_operation_watch_timer[playerid] = 0; }
        return 0;
    }
    if(TCC_IsPlayerInAssignedTruck(playerid)) return 1;

    new bool:loading = p_tcc_operation_loading[playerid];
    TCC_CancelLoadUnloadOperation(playerid);
    ShowNotificationNew(playerid, TC_NOTIFY_ERROR_LOCAL, 6, 0, 0, loading ? ("Погрузка прервана — вы покинули грузовик.") : ("Разгрузка прервана — вы покинули грузовик."), "OK");
    return 1;
}

forward TCC_OnLoadUnloadDone(playerid);
public TCC_OnLoadUnloadDone(playerid)
{
    if(p_tcc_operation_watch_timer[playerid]) { KillTimer(p_tcc_operation_watch_timer[playerid]); p_tcc_operation_watch_timer[playerid] = 0; }
    p_tcc_operation_timer[playerid] = 0;
    if(!IsPlayerConnected(playerid)) return 0;
    TogglePlayerControllable(playerid, true);
    if(p_tcc_active_order[playerid] == -1) return 0;

    new order_idx = p_tcc_active_order[playerid];
    new bool:loading = p_tcc_operation_loading[playerid];
    p_tcc_operation_loading[playerid] = false;

    if(!TCC_IsPlayerInAssignedTruck(playerid))
    {
        ShowNotificationNew(playerid, TC_NOTIFY_ERROR_LOCAL, 6, 0, 0, "Операция прервана — вы не в грузовике.", "OK");
        return 1;
    }

    if(loading)
    {
        if(p_tcc_order_progress[playerid] != 2 || !TCC_IsAtLoadPoint(playerid, order_idx))
        {
            ShowNotificationNew(playerid, TC_NOTIFY_ERROR_LOCAL, 6, 0, 0, "Погрузка прервана — вы не у точки.", "OK");
            return 1;
        }
        if(!TCC_EnsureTrailerForCargo(playerid))
        {
            ShowNotificationNew(playerid, TC_NOTIFY_ERROR_LOCAL, 6, 0, 0, "Прицеп отцепился в процессе.", "OK");
            return 1;
        }
        TCC_ClearRouteMarker(playerid);
        p_tcc_order_progress[playerid] = 3;
        TCC_SetUnloadCheckpoint(playerid, order_idx, true);
        ShowNotificationNew(playerid, TC_NOTIFY_SUCCESS_LOCAL, 6, 0, 0, "Груз загружен.", "OK");
        return 1;
    }

    if(p_tcc_order_progress[playerid] != 3 || !TCC_IsAtUnloadPoint(playerid, order_idx))
    {
        ShowNotificationNew(playerid, TC_NOTIFY_ERROR_LOCAL, 6, 0, 0, "Разгрузка прервана — вы не у точки.", "OK");
        return 1;
    }
    if(!TCC_EnsureTrailerForCargo(playerid))
    {
        ShowNotificationNew(playerid, TC_NOTIFY_ERROR_LOCAL, 6, 0, 0, "Нет прицепа с грузом. Наберите /cargo.", "OK");
        return 1;
    }

    TCC_ClearRouteMarker(playerid);
    ShowNotificationNew(playerid, TC_NOTIFY_SUCCESS_LOCAL, 6, 0, 0, "Груз разгружен.", "OK");
    TCC_CompleteOrder(playerid);
    return 1;
}

// ---------------------------------------------------------------------------
// Accept / complete order
// ---------------------------------------------------------------------------
stock TCC_AcceptOrder(playerid, order_idx)
{
    if(order_idx < 0 || order_idx >= MAX_TC_CARGO_ORDERS || !g_tcc_orders[order_idx][TCC_USED]) return 0;
    if(p_tcc_active_order[playerid] != -1)
    {
        TCC_Send(playerid, "У вас уже есть активный заказ.");
        return 0;
    }

    new businessid = TCompany_GetPlayerCompany(playerid);
    if(businessid == -1)
    {
        TCC_Send(playerid, "Вы не состоите в транспортной компании.");
        return 0;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0 || !TCompany_CanUseVehicle(playerid, vehicleid))
    {
        TCC_Send(playerid, "Сядьте в грузовик своей компании, чтобы взять заказ.");
        return 0;
    }

    p_tcc_active_order[playerid] = order_idx;
    p_tcc_truck[playerid] = vehicleid;

    if(TCC_ModelNeedsTrailer(GetVehicleModel(vehicleid)))
    {
        p_tcc_order_progress[playerid] = 0;
        TCC_Send(playerid, "Наберите {FFFF24}/cargo{FFFFFF} чтобы получить прицеп.");
    }
    else
    {
        p_tcc_order_progress[playerid] = 2;
        if(g_tcc_orders[order_idx][TCC_FROM] == TC_POINT_MINE) TCC_SelectMineLoadDock(playerid);
        TCC_SetRouteCheckpoint(playerid, order_idx, true, TC_CARGO_ROUTE_CHECKPOINT_SIZE);
    }
    return 1;
}

stock TCC_CompleteOrder(playerid)
{
    new order_idx = p_tcc_active_order[playerid];
    new businessid = TCompany_GetPlayerCompany(playerid);
    if(order_idx < 0 || businessid == -1) return 0;

    new total_pay = g_tcc_orders[order_idx][TCC_TOTAL_PAY];
    new company_take = total_pay * TC_CARGO_COMMISSION_PERCENT / 100;
    new driver_pay = total_pay - company_take;

    GivePlayerMoneyEx(playerid, driver_pay, "Оплата рейса ТК", true, true);

    AddBusinessData(businessid, B_BALANCE, +, company_take);
    new query[160];
    mysql_format(mysql, query, sizeof query, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_SQL_ID));
    mysql_query(mysql, query, false);

    new done_msg[96];
    format(done_msg, sizeof done_msg, "%sРейс завершён. Вы заработали {FFFF24}%d{FFFFFF} руб.", TC_CARGO_MSG, driver_pay);
    SendClientMessage(playerid, TC_CARGO_COLOR_MSG, done_msg);

    if(p_tcc_trailer[playerid] != -1 && IsValidVehicle(p_tcc_trailer[playerid]))
    {
        DetachTrailerFromVehicle(p_tcc_truck[playerid]);
        TCC_ForceDestroyVehicle(p_tcc_trailer[playerid]);
    }
    else if(p_tcc_trailer[playerid] != -1)
        TCC_GuardVehicle(p_tcc_trailer[playerid], false);

    p_tcc_trailer[playerid] = -1;
    p_tcc_truck[playerid] = -1;
    p_tcc_active_order[playerid] = -1;
    p_tcc_order_progress[playerid] = 0;
    p_tcc_trailer_detached[playerid] = false;
    p_tcc_trailer_was_attached[playerid] = false;
    p_tcc_trailer_lock_fail_since_ms[playerid] = 0;
    p_tcc_dest_port_dock[playerid] = -1;
    p_tcc_mine_load_dock[playerid] = -1;
    TCC_ClearRouteMarker(playerid);
    return 1;
}

// ---------------------------------------------------------------------------
// Checkpoint dispatch — call from OnPlayerEnterCheckpoint (see hook below)
// ---------------------------------------------------------------------------
stock TCC_OnPlayerEnterCheckpoint(playerid)
{
    if(p_tcc_active_order[playerid] == -1) return 0;
    new order_idx = p_tcc_active_order[playerid];

    if(p_tcc_order_progress[playerid] == 2 && TCC_IsAtLoadPoint(playerid, order_idx))
    {
        if(!TCC_IsPlayerInAssignedTruck(playerid))
        {
            TCC_Send(playerid, "Для погрузки нужно быть в своём грузовике.");
            return 1;
        }
        if(!TCC_EnsureTrailerForCargo(playerid))
        {
            TCC_Send(playerid, "Сначала подцепите прицеп к тягачу.");
            return 1;
        }
        TCC_StartLoadUnloadOperation(playerid, true);
        return 1;
    }

    if(p_tcc_order_progress[playerid] == 3 && TCC_IsAtUnloadPoint(playerid, order_idx))
    {
        if(!TCC_IsPlayerInAssignedTruck(playerid))
        {
            TCC_Send(playerid, "Для разгрузки нужно быть в своём грузовике.");
            return 1;
        }
        if(!TCC_EnsureTrailerForCargo(playerid))
        {
            TCC_Send(playerid, "Нет прицепа с грузом. Наберите /cargo.");
            return 1;
        }
        TCC_StartLoadUnloadOperation(playerid, false);
        return 1;
    }

    if(p_tcc_order_progress[playerid] == 1)
    {
        if(TCC_IsTrailerLinked(playerid) || TCC_IsTrailerNearTruck(playerid, 22.0))
        {
            TCC_TryDetectTrailerLink(playerid);
            return 1;
        }
    }
    return 0;
}

// ---------------------------------------------------------------------------
// Vehicle lifecycle hooks — call from OnVehicleSpawn/OnVehicleDeath (see below)
// ---------------------------------------------------------------------------
stock TCC_OnVehicleSpawn(vehicleid)
{
    new bool:handled;
    foreach(new i : Player)
    {
        if(p_tcc_trailer[i] != vehicleid) continue;
        TCC_GuardVehicle(vehicleid, true);
        if(p_tcc_truck[i] != -1 && IsValidVehicle(p_tcc_truck[i]))
            SetVehicleVirtualWorld(vehicleid, GetVehicleVirtualWorld(p_tcc_truck[i]));
        handled = true;
        break;
    }
    return handled ? 1 : 0;
}

stock TCC_OnVehicleDeath(vehicleid)
{
    foreach(new i : Player)
    {
        if(p_tcc_trailer[i] == vehicleid)
        {
            TCC_GuardVehicle(vehicleid, false);
            new saved_order = p_tcc_active_order[i];
            new saved_progress = p_tcc_order_progress[i];
            p_tcc_trailer[i] = -1;
            p_tcc_trailer_last_recover_ms[i] = 0;
            p_tcc_trailer_lock_fail_since_ms[i] = 0;
            p_tcc_trailer_detach_misses[i] = TC_CARGO_TRAILER_SOFT_RECOVER_MISSES;
            p_tcc_trailer_detached[i] = true;
            p_tcc_trailer_has_last_pos[i] = false;

            if(saved_order != -1 && saved_progress >= 2 && p_tcc_truck[i] != -1)
                SetTimerEx("TCC_RecoverTrailerDelayed", 700, false, "i", i);
            return 1;
        }
        if(p_tcc_truck[i] == vehicleid)
        {
            // The assigned truck itself died — the route cannot continue safely.
            TCC_Send(i, "Ваш грузовик уничтожен. Рейс отменён.");
            if(p_tcc_trailer[i] != -1) TCC_GuardVehicle(p_tcc_trailer[i], false);
            p_tcc_trailer[i] = -1;
            p_tcc_truck[i] = -1;
            p_tcc_active_order[i] = -1;
            p_tcc_order_progress[i] = 0;
            TCC_ClearRouteMarker(i);
            return 1;
        }
    }
    return 0;
}

forward TCC_RecoverTrailerDelayed(playerid);
public TCC_RecoverTrailerDelayed(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    return TCC_RecoverTrailerForActiveCargo(playerid, true);
}

// ---------------------------------------------------------------------------
// Player connect/disconnect
// ---------------------------------------------------------------------------
stock TCC_OnPlayerConnect(playerid)
{
    p_tcc_active_order[playerid] = -1;
    p_tcc_order_progress[playerid] = 0;
    p_tcc_truck[playerid] = -1;
    p_tcc_trailer[playerid] = -1;
    p_tcc_trailer_detached[playerid] = false;
    p_tcc_trailer_was_attached[playerid] = false;
    p_tcc_dest_port_dock[playerid] = -1;
    p_tcc_mine_load_dock[playerid] = -1;
    p_tcc_operation_timer[playerid] = 0;
    p_tcc_operation_watch_timer[playerid] = 0;
    return 1;
}

stock TCC_OnPlayerDisconnect(playerid)
{
    TCC_CancelLoadUnloadOperation(playerid);
    if(p_tcc_trailer[playerid] != -1) TCC_GuardVehicle(p_tcc_trailer[playerid], false);
    p_tcc_active_order[playerid] = -1;
    p_tcc_truck[playerid] = -1;
    p_tcc_trailer[playerid] = -1;
    return 1;
}

// ---------------------------------------------------------------------------
// Pickups, commands, dialogs, world init
// ---------------------------------------------------------------------------
stock TCC_ShowOrdersList(playerid)
{
    new businessid = TCompany_GetPlayerCompany(playerid);
    if(businessid == -1) { TCC_Send(playerid, "Вы не состоите в транспортной компании."); return 0; }
    if(p_tcc_active_order[playerid] != -1) { TCC_Send(playerid, "У вас уже есть активный заказ."); return 0; }

    new body[1024] = "Груз\tМаршрут\tОплата\n";
    for(new i = 0; i < g_tcc_orders_count; i++)
    {
        if(!g_tcc_orders[i][TCC_USED]) continue;
        new order_line[160];
        format(order_line, sizeof order_line, "%s\t%s -> %s\t%d руб.\n",
            g_tcc_orders[i][TCC_CARGO_NAME], g_tcc_point_names[g_tcc_orders[i][TCC_FROM]], g_tcc_point_names[g_tcc_orders[i][TCC_TO]],
            g_tcc_orders[i][TCC_TOTAL_PAY] - g_tcc_orders[i][TCC_TOTAL_PAY] * TC_CARGO_COMMISSION_PERCENT / 100);
        strcat(body, order_line);
    }
    Dialog(playerid, DIALOG_TC_CARGO_ORDERS_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Государственные заказы", body, "Выбрать", "Закрыть");
    return 1;
}

stock TCC_CmdCargo(playerid)
{
    new businessid = TCompany_GetPlayerCompany(playerid);
    if(businessid == -1) { TCC_Send(playerid, "Вы не состоите в транспортной компании."); return 1; }
    if(p_tcc_active_order[playerid] == -1) { TCC_Send(playerid, "Сначала возьмите заказ."); return 1; }

    if(p_tcc_order_progress[playerid] >= 2)
    {
        if(TCC_IsTrailerLinked(playerid)) { TCC_Send(playerid, "Прицеп уже подцеплен, груз сохранён."); return 1; }
        p_tcc_trailer_last_recover_ms[playerid] = 0;
        if(TCC_RecoverTrailerForActiveCargo(playerid, true))
            TCC_Send(playerid, "Прицеп восстановлен. Груз и маршрут сохранены.");
        else
            TCC_Send(playerid, "Не удалось восстановить прицеп. Остановитесь и повторите /cargo.");
        return 1;
    }

    if(p_tcc_trailer_detached[playerid] && p_tcc_trailer[playerid] != -1)
    {
        Dialog(playerid, DIALOG_TC_CARGO_TRAILER_RESPAWN, DIALOG_STYLE_MSGBOX, "Прицеп",
            "{FFFFFF}Прицеп был отцеплен.\nВыдать новый прицеп без потери заказа?", "Да", "Нет");
        return 1;
    }

    TCC_SpawnTrailerForPlayer(playerid, false);
    return 1;
}

stock TCC_HandlePickup(playerid, pickupid)
{
    if(pickupid == g_tcc_orders_pickup)
    {
        if(!IsPlayerInRangeOfPoint(playerid, TC_CARGO_ORDER_PICKUP_RANGE, g_tcc_orders_pickup_pos[0], g_tcc_orders_pickup_pos[1], g_tcc_orders_pickup_pos[2]))
            return 0;
        TCC_ShowOrdersList(playerid);
        return 1;
    }
    return 0;
}

stock TCC_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    switch(dialogid)
    {
        case DIALOG_TC_CARGO_ORDERS_LIST:
        {
            if(!response) return 1;
            if(listitem < 0 || listitem >= g_tcc_orders_count) return 1;
            TCC_AcceptOrder(playerid, listitem);
            return 1;
        }
        case DIALOG_TC_CARGO_TRAILER_RESPAWN:
        {
            if(!response) return 1;
            TCC_SpawnTrailerForPlayer(playerid, true);
            return 1;
        }
    }
    return 0;
}

CMD:cargo(playerid, params[])
{
    #pragma unused params
    return TCC_CmdCargo(playerid);
}

CMD:orders(playerid, params[])
{
    #pragma unused params
    return TCC_ShowOrdersList(playerid);
}

stock TCC_CreateWorldPickups()
{
    static bool:created;
    if(created) return 1;
    created = true;

    g_tcc_orders_pickup = CreatePickup(1274, 23, g_tcc_orders_pickup_pos[0], g_tcc_orders_pickup_pos[1], g_tcc_orders_pickup_pos[2], 0, PICKUP_ACTION_TYPE_TC_CARGO_ORDERS, 0);
    g_tcc_orders_label = CreateDynamic3DTextLabel("{FFFF24}Заказы на перевозку\n{FFFFFF}Нажмите на пикап", 0xFFFFFFFF, g_tcc_orders_pickup_pos[0], g_tcc_orders_pickup_pos[1], g_tcc_orders_pickup_pos[2] + 0.5, 15.0);
    return 1;
}

stock TCC_Init()
{
    TCC_GenerateGovOrders();
    TCC_CreateWorldPickups();
    return 1;
}
