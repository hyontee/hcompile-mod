/*
    include/system/yandex_taxi_test.pwn
    Полноценная система такси (Yandex Taxi)

    Кодировка: Windows-1251 (Cyrillic)
*/

#if defined _yandex_taxi_test_included
    #endinput
#endif
#define _yandex_taxi_test_included

// ---------------- НАСТРОЙКИ ----------------
#define YT_MAX_ORDERS        (50)
#define YT_ORDER_COOLDOWN   (60)

#define YT_RENT_PRICE        (35000)
#define YT_PENALTY_CLIENT    (120000)
#define YT_PENALTY_DRIVER    (100000)
#define YT_DAMAGE_PENALTY    (5000)
#define YT_DAMAGE_CD_SEC     (20)

#define YT_WAIT_SECONDS      (60)

#define YT_DRIVER_TIMEOUT   (180)
#define YT_TRIP_TIMEOUT     (300)
#define YT_TRIP_PENALTY     (50000)
#define YT_LEAVE_RADIUS      (70.0)
#define YT_PICKUP_RADIUS     (12.0)
#define YT_DEST_RADIUS       (15.0)

#define YT_TICK_MS           (900)

#define YT_PRICE_PER_METER   (10)     // 10 руб за метр
#define YT_MIN_FARE          (20000)
#define YT_MAX_FARE          (200000)

#define YT_COLOR_OK          0xA7F542FF
#define YT_COLOR_ERR         0xFF6B6BFF
#define YT_COLOR_INFO        0xFFB020FF

#define YT_TAXI_LABEL_TEXT "{FFFF00}YANDEX TAXI\\n{FFFFFF}АРЕНДОВАННОЕ"

#define YT_DIALOG_RENT       (9501)
#define YT_DIALOG_ORDERS     (9502)

// ---------------- СТАТУСЫ ----------------
#define YT_STATUS_WAIT       (1) // ждёт таксиста
#define YT_STATUS_ASSIGNED   (2) // таксист взял заказ
#define YT_STATUS_ARRIVED    (3) // таксист приехал, ждёт клиента
#define YT_STATUS_TRIP       (4) // клиент в авто, едем к цели

// ---------------- ДАННЫЕ ----------------
enum E_YT_ORDER_DATA
{
    bool: YT_ACTIVE,
    YT_PASSENGER,
    YT_DRIVER,
    YT_STATUS,
    Float: YT_PICKUP_X,
    Float: YT_PICKUP_Y,
    Float: YT_PICKUP_Z,
    Float: YT_DEST_X,
    Float: YT_DEST_Y,
    Float: YT_DEST_Z,
    Float: YT_ROUTE_DIST,
    YT_FARE,
    YT_ESCROW,
    YT_CREATED_AT,
    YT_ASSIGNED_AT,
    YT_ARRIVED_AT,
    YT_TRIP_STARTED_AT
};

new ytaxi_orders[YT_MAX_ORDERS][E_YT_ORDER_DATA];

new ytaxi_player_order[MAX_PLAYERS];
new ytaxi_driver_order[MAX_PLAYERS];
new bool:ytaxi_driver_active[MAX_PLAYERS];
new ytaxi_driver_vehicle[MAX_PLAYERS];
new ytaxi_last_order_time[MAX_PLAYERS];
new ytaxi_driver_damage_cd[MAX_PLAYERS];

new ytaxi_vehicle_owner[MAX_VEHICLES]; // playerid + 1, 0 = none
new Float:ytaxi_vehicle_hp[MAX_VEHICLES];


new Text3D:ytaxi_vehicle_label[MAX_VEHICLES];
new ytaxi_dialog_map[MAX_PLAYERS][YT_MAX_ORDERS];

new ytaxi_timer = 0;

static const YT_VEH_MODELS[] = {420};
static const YT_VEH_NAMES[][] =
{
    "Такси"
};

// ---------------- УТИЛИТЫ ----------------
stock YT_IsVehicleValid(vehicleid)
{
    if (vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    return (GetVehicleModel(vehicleid) != 0);
}

stock bool:YT_IsRentedTaxi(vehicleid, driverid = -1)
{
    if (!YT_IsVehicleValid(vehicleid)) return false;
    if (ytaxi_vehicle_owner[vehicleid] <= 0) return false;
    if (driverid != -1 && ytaxi_vehicle_owner[vehicleid] != driverid + 1) return false;
    return true;
}

stock bool:YT_IsDriverInTaxi(driverid)
{
    new veh = ytaxi_driver_vehicle[driverid];
    if (!YT_IsRentedTaxi(veh, driverid)) return false;
    if (!IsPlayerInVehicle(driverid, veh)) return false;
    if (!IsPlayerDriver(driverid)) return false;
    return true;
}
stock YT_GetPlayerOrder(playerid)
{
    if (ytaxi_player_order[playerid] <= 0) return -1;
    return ytaxi_player_order[playerid] - 1;
}

stock YT_SetPlayerOrder(playerid, orderid)
{
    ytaxi_player_order[playerid] = orderid + 1;
    return 1;
}

stock YT_ClearPlayerOrder(playerid)
{
    ytaxi_player_order[playerid] = 0;
    return 1;
}

stock YT_GetDriverOrder(playerid)
{
    if (ytaxi_driver_order[playerid] <= 0) return -1;
    return ytaxi_driver_order[playerid] - 1;
}

stock YT_SetDriverOrder(playerid, orderid)
{
    ytaxi_driver_order[playerid] = orderid + 1;
    return 1;
}

stock YT_ClearDriverOrder(playerid)
{
    ytaxi_driver_order[playerid] = 0;
    return 1;
}

stock YT_Send(playerid, color, const msg[])
{
    new buf[192];
    format(buf, sizeof buf, "%s", msg);
    SendClientMessage(playerid, color, buf);
    return 1;
}

stock YT_Distance(Float:x, Float:y, Float:z, Float:fx, Float:fy, Float:fz)
{
    return floatsqroot(floatpower(fx - x, 2.0) + floatpower(fy - y, 2.0) + floatpower(fz - z, 2.0));
}

stock YT_CalcFare(Float:dist)
{
    new fare = floatround(dist * YT_PRICE_PER_METER);
    if (fare < YT_MIN_FARE) fare = YT_MIN_FARE;
    if (fare > YT_MAX_FARE) fare = YT_MAX_FARE;
    return fare;
}

stock bool:YT_GetGPSDestination(playerid, &Float:x, &Float:y, &Float:z)
{
    if (GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF) return false;

    x = GetPlayerGPSInfo(playerid, G_POS_X);
    y = GetPlayerGPSInfo(playerid, G_POS_Y);
    z = GetPlayerGPSInfo(playerid, G_POS_Z);

    if (floatabs(x) < 1.0 && floatabs(y) < 1.0) return false;

    if (z == 0.0)
    {
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, px, py, pz);
        z = pz;
    }
    return true;
}

stock YT_EnsureTimer()
{
    if (!ytaxi_timer)
        ytaxi_timer = SetTimer("YTAXI_Tick", YT_TICK_MS, true);
    return 1;
}
stock YT_HasActiveDrivers()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (ytaxi_driver_active[i]) return true;
    }
    return false;
}

stock YT_ClearTaxiLabel(vehicleid)
{
    if (vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    if (ytaxi_vehicle_label[vehicleid] != Text3D:0)
    {
        Delete3DTextLabel(ytaxi_vehicle_label[vehicleid]);
        ytaxi_vehicle_label[vehicleid] = Text3D:0;
    }
    return 1;
}

stock YT_CreateTaxiLabel(vehicleid)
{
    if (vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    YT_ClearTaxiLabel(vehicleid);
    ytaxi_vehicle_label[vehicleid] = Create3DTextLabel(YT_TAXI_LABEL_TEXT, 0xFFFF00FF, 0.0, 0.0, 0.0, 25.0, 0, 1);
    Attach3DTextLabelToVehicle(ytaxi_vehicle_label[vehicleid], vehicleid, 0.0, 0.0, -0.6);
    return 1;
}

stock YT_ClearTaxiVehicle(vehicleid)
{
    if (vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    YT_ClearTaxiLabel(vehicleid);
    ytaxi_vehicle_owner[vehicleid] = 0;
    ytaxi_vehicle_hp[vehicleid] = 0.0;
    return 1;
}

stock YT_StopDriverWork(playerid, bool:notify)
{
    new veh = ytaxi_driver_vehicle[playerid];
    if (veh > 0 && veh < MAX_VEHICLES)
    {
        YT_ClearTaxiVehicle(veh);
        if (YT_IsVehicleValid(veh))
            DestroyVehicle(veh);
    }

    ytaxi_driver_vehicle[playerid] = 0;
    ytaxi_driver_active[playerid] = false;
    YT_ClearDriverOrder(playerid);

    if (notify)
        YT_Send(playerid, YT_COLOR_INFO, "Вы завершили работу таксистом.");

    return 1;
}

stock YT_HasFreeSeat(vehicleid)
{
    if (!YT_IsVehicleValid(vehicleid)) return false;
    new max = GetMaxPassengersAC(vehicleid);
    if (max <= 0 || max == 15) return false;

    new count = 0;
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (GetPlayerVehicleID(i) != vehicleid) continue;
        if (GetPlayerVehicleSeat(i) == 0) continue;
        count++;
    }
    return (count < max);
}
stock YT_FindFreeOrder()
{
    for (new i = 0; i < YT_MAX_ORDERS; i++)
        if (!ytaxi_orders[i][YT_ACTIVE]) return i;
    return -1;
}

stock YT_ClearOrder(orderid)
{
    if (!ytaxi_orders[orderid][YT_ACTIVE]) return 0;

    new passenger = ytaxi_orders[orderid][YT_PASSENGER];
    new driver = ytaxi_orders[orderid][YT_DRIVER];

    if (driver != INVALID_PLAYER_ID)
    {
        DisablePlayerGPS(driver);
        YT_ClearDriverOrder(driver);
    }

    if (passenger != INVALID_PLAYER_ID)
        YT_ClearPlayerOrder(passenger);

    ytaxi_orders[orderid][YT_ACTIVE] = false;
    ytaxi_orders[orderid][YT_PASSENGER] = INVALID_PLAYER_ID;
    ytaxi_orders[orderid][YT_DRIVER] = INVALID_PLAYER_ID;
    ytaxi_orders[orderid][YT_STATUS] = 0;
    ytaxi_orders[orderid][YT_ROUTE_DIST] = 0.0;
    ytaxi_orders[orderid][YT_FARE] = 0;
    ytaxi_orders[orderid][YT_ESCROW] = 0;
    ytaxi_orders[orderid][YT_CREATED_AT] = 0;
    ytaxi_orders[orderid][YT_ASSIGNED_AT] = 0;
    ytaxi_orders[orderid][YT_ARRIVED_AT] = 0;
    ytaxi_orders[orderid][YT_TRIP_STARTED_AT] = 0;
    return 1;
}
stock YT_CancelOrder(orderid, const msg_passenger[], const msg_driver[])
{
    if (!ytaxi_orders[orderid][YT_ACTIVE]) return 0;

    new passenger = ytaxi_orders[orderid][YT_PASSENGER];
    new driver = ytaxi_orders[orderid][YT_DRIVER];
    new escrow = ytaxi_orders[orderid][YT_ESCROW];

    if (escrow > 0 && passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
        GivePlayerMoneyEx(passenger, escrow, "Возврат такси", true, true);

    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
        YT_Send(passenger, YT_COLOR_INFO, msg_passenger);

    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
        YT_Send(driver, YT_COLOR_INFO, msg_driver);

    YT_ClearOrder(orderid);
    return 1;
}
stock YT_PenalizeOrder(orderid, const reason[])
{
    if (!ytaxi_orders[orderid][YT_ACTIVE]) return 0;

    new passenger = ytaxi_orders[orderid][YT_PASSENGER];
    new driver = ytaxi_orders[orderid][YT_DRIVER];
    new escrow = ytaxi_orders[orderid][YT_ESCROW];

    if (escrow > 0 && passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
        GivePlayerMoneyEx(passenger, escrow, "Возврат такси", true, true);

    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
    {
        GivePlayerMoneyEx(passenger, -YT_PENALTY_CLIENT, "Штраф такси", true, true);
        YT_Send(passenger, YT_COLOR_ERR, reason);
    }

    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
    {
        GivePlayerMoneyEx(driver, YT_PENALTY_DRIVER, "Компенсация такси", true, true);
        YT_Send(driver, YT_COLOR_OK, "Клиент наказан. Вам начислено 100.000 руб.");
    }

    YT_ClearOrder(orderid);
    return 1;
}
stock YT_AssignOrder(orderid, driverid)
{
    if (!YT_IsDriverInTaxi(driverid))
        return YT_Send(driverid, YT_COLOR_ERR, "Нужен арендованный такси и вы должны быть за рулём.");

    ytaxi_orders[orderid][YT_DRIVER] = driverid;
    ytaxi_orders[orderid][YT_STATUS] = YT_STATUS_ASSIGNED;
    ytaxi_orders[orderid][YT_ASSIGNED_AT] = gettime();

    YT_SetDriverOrder(driverid, orderid);

    new Float:x = ytaxi_orders[orderid][YT_PICKUP_X];
    new Float:y = ytaxi_orders[orderid][YT_PICKUP_Y];
    new Float:z = ytaxi_orders[orderid][YT_PICKUP_Z];

    EnablePlayerGPS(driverid, x, y, z, "");

    new passenger = ytaxi_orders[orderid][YT_PASSENGER];
    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
    {
        new msg[144];
        format(msg, sizeof msg, "Ваш заказ принят. Таксист: %s.", GetPlayerNameEx(driverid));
        YT_Send(passenger, YT_COLOR_OK, msg);
    }

    YT_Send(driverid, YT_COLOR_OK, "Заказ принят. Езжайте к клиенту.");
    YT_EnsureTimer();
    return 1;
}

stock YT_SetArrived(orderid)
{
    ytaxi_orders[orderid][YT_STATUS] = YT_STATUS_ARRIVED;
    ytaxi_orders[orderid][YT_ARRIVED_AT] = gettime();

    new passenger = ytaxi_orders[orderid][YT_PASSENGER];
    new driver = ytaxi_orders[orderid][YT_DRIVER];

    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
        YT_Send(passenger, YT_COLOR_INFO, "Такси на месте. У вас 60 секунд, чтобы сесть в авто.");

    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
        YT_Send(driver, YT_COLOR_INFO, "Ожидайте клиента 60 секунд.");
    
    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
    {
        if (!YT_HasFreeSeat(ytaxi_driver_vehicle[driver]))
            YT_Send(driver, YT_COLOR_ERR, "В такси нет свободных мест.");
    }

    return 1;
}

stock YT_StartTrip(orderid)
{
    ytaxi_orders[orderid][YT_STATUS] = YT_STATUS_TRIP;
    ytaxi_orders[orderid][YT_TRIP_STARTED_AT] = gettime();

    new driver = ytaxi_orders[orderid][YT_DRIVER];
    new passenger = ytaxi_orders[orderid][YT_PASSENGER];

    new Float:x = ytaxi_orders[orderid][YT_DEST_X];
    new Float:y = ytaxi_orders[orderid][YT_DEST_Y];
    new Float:z = ytaxi_orders[orderid][YT_DEST_Z];

    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
        EnablePlayerGPS(driver, x, y, z, "");

    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
        YT_Send(passenger, YT_COLOR_OK, "Поездка началась. Следуйте к пункту назначения.");

    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
        YT_Send(driver, YT_COLOR_OK, "Клиент в авто. Едьте к пункту назначения.");

    return 1;
}

stock YT_CompleteOrder(orderid)
{
    if (!ytaxi_orders[orderid][YT_ACTIVE]) return 0;

    new passenger = ytaxi_orders[orderid][YT_PASSENGER];
    new driver = ytaxi_orders[orderid][YT_DRIVER];
    new fare = ytaxi_orders[orderid][YT_FARE];
    new escrow = ytaxi_orders[orderid][YT_ESCROW];

    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
    {
        if (escrow <= 0)
            GivePlayerMoneyEx(passenger, -fare, "Оплата такси", true, true);
        YT_Send(passenger, YT_COLOR_OK, "Поездка завершена. Спасибо за заказ!");
    }

    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
    {
        GivePlayerMoneyEx(driver, (escrow > 0 ? escrow : fare), "Оплата такси", true, true);
        YT_Send(driver, YT_COLOR_OK, "Заказ выполнен. Оплата начислена.");
    }

    YT_ClearOrder(orderid);
    return 1;
}
stock YT_CreateOrder(playerid)
{
    if (YT_GetPlayerOrder(playerid) != -1)
        return YT_Send(playerid, YT_COLOR_ERR, "У вас уже есть активный заказ.");

    if (ytaxi_driver_active[playerid])
        return YT_Send(playerid, YT_COLOR_ERR, "Таксист не может заказывать такси.");

    if (!YT_HasActiveDrivers())
        return YT_Send(playerid, YT_COLOR_INFO, "Сейчас нет таксистов. Попробуйте позже.");

    new now = gettime();
    if (now - ytaxi_last_order_time[playerid] < YT_ORDER_COOLDOWN)
    {
        new left = YT_ORDER_COOLDOWN - (now - ytaxi_last_order_time[playerid]);
        new msg_cd[96];
        format(msg_cd, sizeof msg_cd, "Подождите %d сек. перед новым заказом.", left);
        return YT_Send(playerid, YT_COLOR_INFO, msg_cd);
    }

    new Float:dx, Float:dy, Float:dz;
    if (!YT_GetGPSDestination(playerid, dx, dy, dz))
        return YT_Send(playerid, YT_COLOR_ERR, "Сначала поставьте метку через /gps.");

    new orderid = YT_FindFreeOrder();
    if (orderid == -1)
        return YT_Send(playerid, YT_COLOR_ERR, "Нет свободных слотов для заказов. Попробуйте позже.");

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new Float:dist = YT_Distance(px, py, pz, dx, dy, dz);
    new fare = YT_CalcFare(dist);

    new min_balance = fare;
    if (min_balance < YT_PENALTY_CLIENT) min_balance = YT_PENALTY_CLIENT;

    if (GetPlayerMoneyEx(playerid) < min_balance)
    {
        new msg[160];
        format(msg, sizeof msg, "Недостаточно денег для заказа. Нужно минимум %d руб.", min_balance);
        return YT_Send(playerid, YT_COLOR_ERR, msg);
    }

    GivePlayerMoneyEx(playerid, -fare, "Бронь такси", true, true);

    ytaxi_orders[orderid][YT_ACTIVE] = true;
    ytaxi_orders[orderid][YT_PASSENGER] = playerid;
    ytaxi_orders[orderid][YT_DRIVER] = INVALID_PLAYER_ID;
    ytaxi_orders[orderid][YT_STATUS] = YT_STATUS_WAIT;
    ytaxi_orders[orderid][YT_PICKUP_X] = px;
    ytaxi_orders[orderid][YT_PICKUP_Y] = py;
    ytaxi_orders[orderid][YT_PICKUP_Z] = pz;
    ytaxi_orders[orderid][YT_DEST_X] = dx;
    ytaxi_orders[orderid][YT_DEST_Y] = dy;
    ytaxi_orders[orderid][YT_DEST_Z] = dz;
    ytaxi_orders[orderid][YT_ROUTE_DIST] = dist;
    ytaxi_orders[orderid][YT_FARE] = fare;
    ytaxi_orders[orderid][YT_ESCROW] = fare;
    ytaxi_orders[orderid][YT_CREATED_AT] = gettime();
    ytaxi_orders[orderid][YT_ASSIGNED_AT] = 0;
    ytaxi_last_order_time[playerid] = gettime();
    ytaxi_orders[orderid][YT_ARRIVED_AT] = 0;
    ytaxi_orders[orderid][YT_TRIP_STARTED_AT] = 0;

    YT_SetPlayerOrder(playerid, orderid);

    new msg[192];
    format(msg, sizeof msg, "Заказ создан. Дистанция: %d м. Цена: %d руб. Средства зарезервированы.", floatround(dist), fare);
    YT_Send(playerid, YT_COLOR_OK, msg);
    YT_Send(playerid, YT_COLOR_INFO, "Важно: если уйдёте далеко или не сядете за 60 секунд — штраф 120.000 руб.");

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (!ytaxi_driver_active[i]) continue;
        YT_Send(i, YT_COLOR_INFO, "{FFCD00}[Диспетчер]{FFFFFF} Новый вызов >>> {FFFF00}/tord");
    }

    YT_EnsureTimer();
    return 1;
}
stock YT_ShowRentDialog(playerid)
{
    new list[512], row[96];
    list[0] = '\0';

    for (new i = 0; i < sizeof(YT_VEH_MODELS); i++)
    {
        format(row, sizeof row, "%s (%d)", YT_VEH_NAMES[i], YT_VEH_MODELS[i]);
        if (i > 0) strcat(list, "\\n");
        strcat(list, row);
    }

    new title[64], b1[16], b2[16];
    format(title, sizeof title, "Аренда такси (%d руб.)", YT_RENT_PRICE);
    format(b1, sizeof b1, "Выбрать");
    format(b2, sizeof b2, "Закрыть");

    ShowPlayerDialog(playerid, YT_DIALOG_RENT, DIALOG_STYLE_LIST, title, list, b1, b2);
    return 1;
}
stock YT_ShowOrdersDialog(playerid)
{
    new list[4096], row[160];
    new count = 0;

    for (new i = 0; i < YT_MAX_ORDERS; i++)
        ytaxi_dialog_map[playerid][i] = -1;

    format(list, sizeof list, "##\\tНик\\tДо клиента\\tПоездка\\tЦена\\n");

    for (new i = 0; i < YT_MAX_ORDERS; i++)
    {
        if (!ytaxi_orders[i][YT_ACTIVE]) continue;
        if (ytaxi_orders[i][YT_STATUS] != YT_STATUS_WAIT) continue;

        new passenger = ytaxi_orders[i][YT_PASSENGER];
        if (passenger == INVALID_PLAYER_ID || !IsPlayerConnected(passenger)) continue;

        new Float:px = ytaxi_orders[i][YT_PICKUP_X];
        new Float:py = ytaxi_orders[i][YT_PICKUP_Y];
        new Float:pz = ytaxi_orders[i][YT_PICKUP_Z];

        new dist_to_pickup = floatround(GetPlayerDistanceFromPoint(playerid, px, py, pz));
        new route_dist = floatround(ytaxi_orders[i][YT_ROUTE_DIST]);
        new fare = ytaxi_orders[i][YT_FARE];

        format(row, sizeof row, "#%d\\t%s\\t%dм\\t%dм\\t%d\\n", count + 1, GetPlayerNameEx(passenger), dist_to_pickup, route_dist, fare);
        strcat(list, row);

        ytaxi_dialog_map[playerid][count] = i;
        count++;
    }

    if (!count)
        return YT_Send(playerid, YT_COLOR_INFO, "Нет доступных заказов.");

    new title[48], b1[16], b2[16];
    format(title, sizeof title, "Заказы такси");
    format(b1, sizeof b1, "Выбрать");
    format(b2, sizeof b2, "Закрыть");

    ShowPlayerDialog(playerid, YT_DIALOG_ORDERS, DIALOG_STYLE_TABLIST_HEADERS, title, list, b1, b2);
    return 1;
}
stock YT_RentVehicle(playerid, modelid)
{
    if (GetPlayerInterior(playerid) != 0)
        return YT_Send(playerid, YT_COLOR_ERR, "Аренда такси доступна только на улице.");

    if (IsPlayerInAnyVehicle(playerid))
        return YT_Send(playerid, YT_COLOR_ERR, "Выйдите из транспорта, чтобы начать работу.");
    if (GetPlayerMoneyEx(playerid) < YT_RENT_PRICE)
        return YT_Send(playerid, YT_COLOR_ERR, "Недостаточно денег для аренды такси.");
    new oldveh = ytaxi_driver_vehicle[playerid];
    if (oldveh > 0 && oldveh < MAX_VEHICLES)
    {
        YT_ClearTaxiVehicle(oldveh);
        if (YT_IsVehicleValid(oldveh))
            DestroyVehicle(oldveh);
    }

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new vehicleid = CreateVehicle(modelid, x + 2.0, y, z, a, -1, -1, 600);
    if (!YT_IsVehicleValid(vehicleid))
        return YT_Send(playerid, YT_COLOR_ERR, "Не удалось создать транспорт. Попробуйте ещё раз.");

    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    ytaxi_driver_vehicle[playerid] = vehicleid;
    ytaxi_vehicle_owner[vehicleid] = playerid + 1;
    GetVehicleHealth(vehicleid, ytaxi_vehicle_hp[vehicleid]);

    YT_CreateTaxiLabel(vehicleid);

    ytaxi_driver_active[playerid] = true;

    GivePlayerMoneyEx(playerid, -YT_RENT_PRICE, "Аренда такси", true, true);
    PutPlayerInVehicle(playerid, vehicleid, 0);

    YT_Send(playerid, YT_COLOR_OK, "Вы начали работу таксистом. Используйте /tord для заказов.");
    YT_EnsureTimer();
    return 1;
}
// ---------------- ТИКЕР ----------------
forward YTAXI_Tick();
public YTAXI_Tick()
{
    new any_active = 0;
    new now = gettime();

    // проверка повреждений арендованных авто
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!ytaxi_driver_active[i]) continue;
        if (!IsPlayerConnected(i)) continue;

        any_active = 1;

        new veh = ytaxi_driver_vehicle[i];
        if (!YT_IsVehicleValid(veh))
        {
            if (veh > 0 && veh < MAX_VEHICLES) YT_ClearTaxiVehicle(veh);

            ytaxi_driver_vehicle[i] = 0;

            if (ytaxi_driver_active[i])
            {
                new orderid = YT_GetDriverOrder(i);
                if (orderid != -1)
                    YT_CancelOrder(orderid, "Такси уничтожено. Заказ отменён.", "Ваше такси уничтожено. Заказ отменён.");

                ytaxi_driver_active[i] = false;
                YT_ClearDriverOrder(i);
            }
            continue;
        }

        new Float:hp;
        GetVehicleHealth(veh, hp);

        if (ytaxi_vehicle_hp[veh] > 0.0 && hp < ytaxi_vehicle_hp[veh] - 1.0)
        {
            if (now - ytaxi_driver_damage_cd[i] >= YT_DAMAGE_CD_SEC)
            {
                ytaxi_driver_damage_cd[i] = now;
                GivePlayerMoneyEx(i, -YT_DAMAGE_PENALTY, "Повреждение такси", true, true);
                YT_Send(i, YT_COLOR_ERR, "Повреждение такси: -5.000 руб. (КД 20 сек.)");
            }
        }

        ytaxi_vehicle_hp[veh] = hp;
    }

    for (new order = 0; order < YT_MAX_ORDERS; order++)
    {
        if (!ytaxi_orders[order][YT_ACTIVE]) continue;
        any_active = 1;

        new passenger = ytaxi_orders[order][YT_PASSENGER];
        new driver = ytaxi_orders[order][YT_DRIVER];
        new status = ytaxi_orders[order][YT_STATUS];

        if (passenger == INVALID_PLAYER_ID || !IsPlayerConnected(passenger))
        {
            if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
                YT_Send(driver, YT_COLOR_INFO, "Клиент вышел из игры. Заказ отменён.");
            YT_ClearOrder(order);
            continue;
        }

        if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
        {
            new dveh = ytaxi_driver_vehicle[driver];
            if (dveh && !YT_IsRentedTaxi(dveh, driver))
            {
                YT_CancelOrder(order, "Таксист потерял такси. Заказ отменён.", "Ваше такси недоступно. Заказ отменён.");
                continue;
            }

            if (IsPlayerInAnyVehicle(driver) && !YT_IsDriverInTaxi(driver))
            {
                YT_CancelOrder(order, "Таксист не в арендованном такси. Заказ отменён.", "Вы не в арендованном такси. Заказ отменён.");
                continue;
            }
        }

        switch (status)
        {
            case YT_STATUS_WAIT:
            {
                // ждём таксиста
            }
            case YT_STATUS_ASSIGNED:
            {
                if (ytaxi_orders[order][YT_ASSIGNED_AT] > 0 &&
                    (now - ytaxi_orders[order][YT_ASSIGNED_AT]) > YT_DRIVER_TIMEOUT)
                {
                    YT_CancelOrder(order, "Таксист не успел приехать. Заказ отменён.", "Вы не успели доехать к клиенту. Заказ отменён.");
                    break;
                }

                if (driver == INVALID_PLAYER_ID || !IsPlayerConnected(driver))
                {
                    YT_CancelOrder(order, "Таксист вышел. Заказ отменён.", "Заказ отменён.");
                    break;
                }

                if (GetPlayerDistanceFromPoint(passenger,
                    ytaxi_orders[order][YT_PICKUP_X],
                    ytaxi_orders[order][YT_PICKUP_Y],
                    ytaxi_orders[order][YT_PICKUP_Z]) > YT_LEAVE_RADIUS)
                {
                    YT_PenalizeOrder(order, "Клиент отошёл слишком далеко. Штраф 120.000 руб.");
                    break;
                }

                if (GetPlayerDistanceFromPoint(driver,
                    ytaxi_orders[order][YT_PICKUP_X],
                    ytaxi_orders[order][YT_PICKUP_Y],
                    ytaxi_orders[order][YT_PICKUP_Z]) <= YT_PICKUP_RADIUS)
                {
                    YT_SetArrived(order);
                }
            }
            case YT_STATUS_ARRIVED:
            {
                if (IsPlayerInAnyVehicle(passenger) && !IsPlayerInVehicle(passenger, ytaxi_driver_vehicle[driver]))
                {
                    YT_PenalizeOrder(order, "Клиент сел не в то авто. Штраф 120.000 руб.");
                    break;
                }

                if (driver == INVALID_PLAYER_ID || !IsPlayerConnected(driver))
                {
                    YT_CancelOrder(order, "Таксист вышел. Заказ отменён.", "Заказ отменён.");
                    break;
                }

                if (GetPlayerDistanceFromPoint(passenger,
                    ytaxi_orders[order][YT_PICKUP_X],
                    ytaxi_orders[order][YT_PICKUP_Y],
                    ytaxi_orders[order][YT_PICKUP_Z]) > YT_LEAVE_RADIUS)
                {
                    YT_PenalizeOrder(order, "Клиент отошёл слишком далеко. Штраф 120.000 руб.");
                    break;
                }

                new veh = ytaxi_driver_vehicle[driver];
                if (YT_IsVehicleValid(veh) && IsPlayerInVehicle(passenger, veh) && GetPlayerState(passenger) == PLAYER_STATE_PASSENGER)
                {
                    YT_StartTrip(order);
                    break;
                }

                if ((gettime() - ytaxi_orders[order][YT_ARRIVED_AT]) > YT_WAIT_SECONDS)
                {
                    YT_PenalizeOrder(order, "Клиент не сел в авто. Штраф 120.000 руб.");
                }
            }
            case YT_STATUS_TRIP:
            {
                if (driver == INVALID_PLAYER_ID || !IsPlayerConnected(driver))
                {
                    YT_CancelOrder(order, "Таксист вышел. Заказ отменён.", "Заказ отменён.");
                    break;
                }

                if (!YT_IsDriverInTaxi(driver))
                {
                    YT_CancelOrder(order, "Таксист покинул такси. Заказ отменён.", "Вы покинули такси. Заказ отменён.");
                    break;
                }

                new veh = ytaxi_driver_vehicle[driver];

                new Float:dx = ytaxi_orders[order][YT_DEST_X];
                new Float:dy = ytaxi_orders[order][YT_DEST_Y];
                new Float:dz = ytaxi_orders[order][YT_DEST_Z];

                new Float:cx, Float:cy, Float:cz;
                if (YT_IsVehicleValid(veh))
                    GetVehiclePos(veh, cx, cy, cz);
                else
                    GetPlayerPos(driver, cx, cy, cz);

                if (YT_Distance(cx, cy, cz, dx, dy, dz) <= YT_DEST_RADIUS)
                {
                    YT_CompleteOrder(order);
                    break;
                }

                if (!(YT_IsVehicleValid(veh) && IsPlayerInVehicle(passenger, veh)))
                {
                    YT_PenalizeOrder(order, "Клиент покинул такси. Штраф 120.000 руб.");
                    break;
                }

                if (ytaxi_orders[order][YT_TRIP_STARTED_AT] > 0 &&
                    (now - ytaxi_orders[order][YT_TRIP_STARTED_AT]) > YT_TRIP_TIMEOUT)
                {
                    new escrow = ytaxi_orders[order][YT_ESCROW];
                    if (escrow > 0 && passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
                        GivePlayerMoneyEx(passenger, escrow, "Возврат такси", true, true);

                    if (driver != INVALID_PLAYER_ID && IsPlayerConnected(driver))
                    {
                        GivePlayerMoneyEx(driver, -YT_TRIP_PENALTY, "Штраф такси", true, true);
                        YT_Send(driver, YT_COLOR_ERR, "Вы не успели довезти клиента за 5 минут. Штраф 50.000 руб.");
                    }

                    if (passenger != INVALID_PLAYER_ID && IsPlayerConnected(passenger))
                        YT_Send(passenger, YT_COLOR_INFO, "Поездка отменена из-за превышения времени. Средства возвращены.");

                    YT_ClearOrder(order);
                }
            }
        }
    }

    if (!any_active && ytaxi_timer)
    {
        KillTimer(ytaxi_timer);
        ytaxi_timer = 0;
    }

    return 1;
}
// ---------------- КОМАНДЫ ----------------
CMD:taxord(playerid, params[])
{
    if (!IsPlayerLogged(playerid)) return 1;
    YT_CreateOrder(playerid);
    return 1;
}

CMD:starttax(playerid, params[])
{
    if (!IsPlayerLogged(playerid)) return 1;

    if (ytaxi_driver_active[playerid])
        return YT_Send(playerid, YT_COLOR_INFO, "Вы уже работаете таксистом.");

    if (GetPlayerInterior(playerid) != 0)
        return YT_Send(playerid, YT_COLOR_ERR, "Аренда такси доступна только на улице.");

    if (IsPlayerInAnyVehicle(playerid))
        return YT_Send(playerid, YT_COLOR_ERR, "Выйдите из транспорта, чтобы начать работу.");

    YT_ShowRentDialog(playerid);
    return 1;
}

CMD:tord(playerid, params[])
{
    if (!IsPlayerLogged(playerid)) return 1;

    if (!ytaxi_driver_active[playerid])
        return YT_Send(playerid, YT_COLOR_ERR, "Сначала начните работу через /starttax.");

    if (YT_GetDriverOrder(playerid) != -1)
        return YT_Send(playerid, YT_COLOR_INFO, "У вас уже есть активный заказ.");

    YT_ShowOrdersDialog(playerid);
    return 1;
}

CMD:stoptax(playerid, params[])
{
    if (!IsPlayerLogged(playerid)) return 1;

    if (!ytaxi_driver_active[playerid])
        return YT_Send(playerid, YT_COLOR_INFO, "Вы не работаете таксистом.");

    if (YT_GetDriverOrder(playerid) != -1)
        return YT_Send(playerid, YT_COLOR_ERR, "Сначала завершите активный заказ.");

    YT_StopDriverWork(playerid, true);
    return 1;
}

// ---------------- КОЛБЭКИ ----------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == YT_DIALOG_RENT)
    {
        if (!response) return 1;
        if (listitem < 0 || listitem >= sizeof(YT_VEH_MODELS)) return 1;

        YT_RentVehicle(playerid, YT_VEH_MODELS[listitem]);
        return 1;
    }
    if (dialogid == YT_DIALOG_ORDERS)
    {
        if (!response) return 1;

        if (listitem < 0 || listitem >= YT_MAX_ORDERS) return 1;
        new orderid = ytaxi_dialog_map[playerid][listitem];
        if (orderid < 0 || orderid >= YT_MAX_ORDERS) return 1;

        if (!ytaxi_orders[orderid][YT_ACTIVE] || ytaxi_orders[orderid][YT_STATUS] != YT_STATUS_WAIT)
            return YT_Send(playerid, YT_COLOR_ERR, "Этот заказ уже недоступен.");

        if (YT_GetDriverOrder(playerid) != -1)
            return YT_Send(playerid, YT_COLOR_INFO, "У вас уже есть активный заказ.");

        if (!ytaxi_driver_active[playerid])
            return YT_Send(playerid, YT_COLOR_ERR, "Сначала начните работу через /starttax.");

        if (!YT_IsDriverInTaxi(playerid))
            return YT_Send(playerid, YT_COLOR_ERR, "Нужен арендованный такси и вы должны быть за рулём.");

        YT_AssignOrder(orderid, playerid);
        return 1;
    }

    #if defined ytaxi_OnDialogResponse
        return ytaxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse ytaxi_OnDialogResponse
#if defined ytaxi_OnDialogResponse
    forward ytaxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerDisconnect(playerid, reason)
{
        // если игрок был пассажиром
    new orderid = YT_GetPlayerOrder(playerid);
    if (orderid != -1)
    {
        if (ytaxi_orders[orderid][YT_ACTIVE] && ytaxi_orders[orderid][YT_STATUS] >= YT_STATUS_ASSIGNED)
            YT_PenalizeOrder(orderid, "Клиент вышел из игры. Штраф 120.000 руб.");
        else
            YT_CancelOrder(orderid, "Вы вышли из игры. Заказ отменён.", "Клиент вышел из игры. Заказ отменён.");
    }

    // если игрок был таксистом
    orderid = YT_GetDriverOrder(playerid);
    if (orderid != -1)
        YT_CancelOrder(orderid, "Таксист вышел. Заказ отменён.", "Заказ отменён.");
    new oldveh = ytaxi_driver_vehicle[playerid];
    if (oldveh > 0 && oldveh < MAX_VEHICLES)
    {
        YT_ClearTaxiVehicle(oldveh);
        if (YT_IsVehicleValid(oldveh))
            DestroyVehicle(oldveh);
    }

    ytaxi_driver_vehicle[playerid] = 0;
    ytaxi_driver_active[playerid] = false;
    YT_ClearDriverOrder(playerid);
    YT_ClearPlayerOrder(playerid);

    #if defined ytaxi_OnPlayerDisconnect
        return ytaxi_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect ytaxi_OnPlayerDisconnect
#if defined ytaxi_OnPlayerDisconnect
    forward ytaxi_OnPlayerDisconnect(playerid, reason);
#endif
public OnPlayerDeath(playerid, killerid, reason)
{
    new orderid = YT_GetPlayerOrder(playerid);
    if (orderid != -1)
        YT_CancelOrder(orderid, "Вы погибли. Заказ отменён.", "Клиент погиб. Заказ отменён.");

    orderid = YT_GetDriverOrder(playerid);
    if (orderid != -1)
        YT_CancelOrder(orderid, "Таксист погиб. Заказ отменён.", "Вы погибли. Заказ отменён.");

    #if defined ytaxi_OnPlayerDeath
        return ytaxi_OnPlayerDeath(playerid, killerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath ytaxi_OnPlayerDeath
#if defined ytaxi_OnPlayerDeath
    forward ytaxi_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnVehicleDeath(vehicleid, killerid)
{
    if (vehicleid > 0 && vehicleid < MAX_VEHICLES && ytaxi_vehicle_owner[vehicleid] > 0)
    {
        new driverid = ytaxi_vehicle_owner[vehicleid] - 1;

        YT_ClearTaxiVehicle(vehicleid);

        if (driverid >= 0 && driverid < MAX_PLAYERS)
        {
            if (ytaxi_driver_vehicle[driverid] == vehicleid)
                ytaxi_driver_vehicle[driverid] = 0;

            new orderid = YT_GetDriverOrder(driverid);
            if (orderid != -1)
                YT_CancelOrder(orderid, "Такси уничтожено. Заказ отменён.", "Ваше такси уничтожено. Заказ отменён.");

            ytaxi_driver_active[driverid] = false;
            YT_ClearDriverOrder(driverid);

            if (IsPlayerConnected(driverid))
                YT_Send(driverid, YT_COLOR_ERR, "Ваше такси уничтожено. Работа завершена.");
        }
    }

    #if defined ytaxi_OnVehicleDeath
        return ytaxi_OnVehicleDeath(vehicleid, killerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleDeath
    #undef OnVehicleDeath
#else
    #define _ALS_OnVehicleDeath
#endif
#define OnVehicleDeath ytaxi_OnVehicleDeath
#if defined ytaxi_OnVehicleDeath
    forward ytaxi_OnVehicleDeath(vehicleid, killerid);
#endif

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if (vehicleid > 0 && vehicleid < MAX_VEHICLES && ytaxi_vehicle_owner[vehicleid] > 0)
    {
        new driverid = ytaxi_vehicle_owner[vehicleid] - 1;
        if (driverid >= 0 && driverid < MAX_PLAYERS && ytaxi_driver_active[driverid])
        {
            new Float:hp;
            GetVehicleHealth(vehicleid, hp);

            if (ytaxi_vehicle_hp[vehicleid] > 0.0 && hp < ytaxi_vehicle_hp[vehicleid] - 1.0)
            {
                new now = gettime();
                if (now - ytaxi_driver_damage_cd[driverid] >= YT_DAMAGE_CD_SEC)
                {
                    ytaxi_driver_damage_cd[driverid] = now;
                    GivePlayerMoneyEx(driverid, -YT_DAMAGE_PENALTY, "Повреждение такси", true, true);
                    YT_Send(driverid, YT_COLOR_ERR, "Повреждение такси: -5.000 руб. (КД 20 сек.)");
                }
            }

            ytaxi_vehicle_hp[vehicleid] = hp;
        }
    }

    #if defined ytaxi_OnVehicleDamageStatusUpdate
        return ytaxi_OnVehicleDamageStatusUpdate(vehicleid, playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleDamageStatusUpdate
    #undef OnVehicleDamageStatusUpdate
#else
    #define _ALS_OnVehicleDamageStatusUpdate
#endif
#define OnVehicleDamageStatusUpdate ytaxi_OnVehicleDamageStatusUpdate
#if defined ytaxi_OnVehicleDamageStatusUpdate
    forward ytaxi_OnVehicleDamageStatusUpdate(vehicleid, playerid);
#endif