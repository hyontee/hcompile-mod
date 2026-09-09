enum E_TAXI_VEHICLE_STRUCT
{
    Float:E_POS[4],
    E_MODEL_ID,
    E_COLOR1,
    E_COLOR2,
    E_VINIL,
    E_PRICE,
    E_VEH_ID,
    E_OWNER_ID,
    Text3D:E_LABEL,
    E_TIMER
}

static const taxi_vehicles[][E_TAXI_VEHICLE_STRUCT] =
{
    {{251.195, 277.828, 11.456, 160.640}, 15651, 1, 1, 0, 7000000},
    {{254.252, 270.631, 11.602, 70.770},  15167, 0, 0, 1, 15000000},
    {{252.110, 264.505, 11.606, 70.593},  15167, 0, 0, 1, 15000000},
    {{245.047, 280.001, 11.322, 160.117}, 15651, 1, 1, 0, 7000000},
    {{230.607, 268.758, 11.353, 339.232}, 15603, 1, 1, 3, 5000000},
    {{236.711, 266.490, 11.456, 341.243}, 15603, 1, 1, 3, 5000000},
    {{241.205, 241.161, 11.061, 341.123}, 15603, 1, 1, 3, 5000000},
    {{232.825, 284.376, 11.231, 160.620}, 15077, 1, 1, 4, 10000000},
    {{238.881, 282.213, 11.336, 160.084}, 15077, 1, 1, 4, 10000000},
    {{224.468, 270.986, 11.231, 341.015}, 15603, 1, 1, 3, 5000000},
    {{235.075, 243.285, 11.130, 340.731}, 15603, 1, 1, 3, 5000000}
};

enum E_TAXI_ORDER_STRUCT
{
    E_ORDER_ACTIVE,
    E_ORDER_CUSTOMER_ID,
    Float:E_ORDER_FROM_X,
    Float:E_ORDER_FROM_Y,
    Float:E_ORDER_FROM_Z,
    Float:E_ORDER_TO_X,
    Float:E_ORDER_TO_Y,
    Float:E_ORDER_TO_Z,
    E_ORDER_CITY,
    E_ORDER_ZONE[64],
    E_ORDER_EXECUTER_ID,
    E_ORDER_UNIX_TIME,
    E_ORDER_STATUS,
    E_ORDER_TIMER,
    E_ORDER_t_CefUpdate_TIMER,
    E_ORDER_PRICE
}

new taxi_orders[MAX_PLAYERS][E_TAXI_ORDER_STRUCT];
new taxi_driver_status[MAX_PLAYERS];
new taxi_driver_order[MAX_PLAYERS];
new taxi_driver_timer[MAX_PLAYERS];

public: Taxi_CheckDriverVehicle(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid) || Taxi_GetVehicleIndex(GetPlayerVehicleID(playerid)) == -1)
    {
        taxi_driver_status[playerid] = 0;
        taxi_driver_timer[playerid] = 0;
        SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(-1)");
        GameText(playerid, "~y~Okончание~n~работы", 2000, 3);
    }
    return 1;
}

stock Taxi_OnGameModeInit()
{
    for(new i; i < sizeof(taxi_vehicles); i++)
    {
        taxi_vehicles[i][E_VEH_ID] = CreateVehicle(taxi_vehicles[i][E_MODEL_ID], taxi_vehicles[i][E_POS][0], taxi_vehicles[i][E_POS][1], taxi_vehicles[i][E_POS][2], taxi_vehicles[i][E_POS][3], taxi_vehicles[i][E_COLOR1], taxi_vehicles[i][E_COLOR2], -1, 0);
        SetVehicleNumber(taxi_vehicles[i][E_VEH_ID], 7, GenerateCarNumberRu(), GenerateCarRegRu());
        if(taxi_vehicles[i][E_VINIL]) ChangeVehicleDefaultViniljob(taxi_vehicles[i][E_VEH_ID], taxi_vehicles[i][E_VINIL]);
        
        switch(taxi_vehicles[i][E_MODEL_ID])
        {
            case 15603, 15167: AttachObjectToVehicle(CreateObject(16876, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), taxi_vehicles[i][E_VEH_ID], 0.003722, -0.00025, 0.740693, 0.0, 0.0, -0.082082);
            case 15651: AttachObjectToVehicle(CreateObject(16876, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), taxi_vehicles[i][E_VEH_ID], 0.0, 0.0, 0.830006, 0.0, 0.0, 0.0);
            case 15077: AttachObjectToVehicle(CreateObject(16876, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), taxi_vehicles[i][E_VEH_ID], 0.0, 0.0, 0.74, 0.0, 0.0, 0.0);
        }
        
        taxi_vehicles[i][E_LABEL] = Create3DTextLabel("Такси\n{F5CF51}< Бесплатно для новичков >", 0xF5CF51FF, 0.0, 0.0, 0.0, 10.0, 0);
        Attach3DTextLabelToVehicle(taxi_vehicles[i][E_LABEL], taxi_vehicles[i][E_VEH_ID], 0.0, 0.0, 1.30);
        taxi_vehicles[i][E_OWNER_ID] = INVALID_PLAYER_ID;
        taxi_vehicles[i][E_TIMER] = 0;
    }
    return 1;
}

stock Taxi_GetVehicleIndex(vehicleid)
{
    for(new i; i < sizeof(taxi_vehicles); i++) if(taxi_vehicles[i][E_VEH_ID] == vehicleid) return i;
    return -1;
}
stock Taxi_OnPlayerStateChange(playerid, newstate, oldstate)
{
    #pragma unused oldstate
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid), idx = Taxi_GetVehicleIndex(vehicleid);
        if(idx == -1) return 0;
        
        new jobs[3];
        EM_ManageJobs(playerid, 0, -1, jobs);
        
        new hasTaxiJob = (jobs[0] == 8 || jobs[1] == 8 || jobs[2] == 8);
        if(!hasTaxiJob) return SendClientMessage(playerid, 0xCECECEFF, "Сначала вам необходимо устроиться таксистом в центре занятости."), RemovePlayerFromVehicle(playerid), 1;
        if(taxi_vehicles[idx][E_OWNER_ID] != INVALID_PLAYER_ID && taxi_vehicles[idx][E_OWNER_ID] != playerid) return SendClientMessage(playerid, 0xCECECEFF, "Данный транспорт уже арендован другим игроком."), RemovePlayerFromVehicle(playerid), 1;
        if(taxi_vehicles[idx][E_OWNER_ID] == playerid)
        {
            if(taxi_vehicles[idx][E_TIMER]) KillTimer(taxi_vehicles[idx][E_TIMER]), taxi_vehicles[idx][E_TIMER] = 0;
            if(taxi_driver_status[playerid])
            {
                if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]), taxi_driver_timer[playerid] = 0;
                SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(1)");
                Taxi_t_CefUpdateDriverInfo(playerid);
            }
            return 1;
        }
        str_q[0] = EOS;

        format(str_q, sizeof(str_q),
            "{FFFFFF}Желаете арендовать транспорт?\n{FFFFFF}Стоимость аренды: {FF9900}%d руб.",
            taxi_vehicles[idx][E_PRICE]
        );

        Dialog(playerid, DIALOG_TAXI_RENT, DIALOG_STYLE_MSGBOX, "Таксопарк", str_q, "Да", "Нет");
        return 1;
    }
    return 0;
}

stock Taxi_OnDialogResponse(playerid, dialogid, response)
{
    switch(dialogid)
    {
        case DIALOG_TAXI_RENT:
        {
            if(!response) { RemovePlayerFromVehicle(playerid); return 1; }
            new vehicleid = GetPlayerVehicleID(playerid), idx = Taxi_GetVehicleIndex(vehicleid);
            if(idx == -1) return 1;
            if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), taxi_vehicles[idx][E_PRICE])) { SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно средств для аренды."); RemovePlayerFromVehicle(playerid); return 1; }
            GivePlayerMoneyEx(playerid, -taxi_vehicles[idx][E_PRICE], "Аренда такси");
            taxi_vehicles[idx][E_OWNER_ID] = playerid;
            SendClientMessage(playerid, 0xFFA500FF, "Для начала работы откройте приложение такси в телефоне.");
            return 1;
        }
    }
    return 0;
}

public: Taxi_ReleaseVehicle(idx)
{
    if(idx < 0 || idx >= sizeof(taxi_vehicles)) return 0;
    taxi_vehicles[idx][E_OWNER_ID] = INVALID_PLAYER_ID;
    taxi_vehicles[idx][E_TIMER] = 0;
    SetVehicleToRespawn(taxi_vehicles[idx][E_VEH_ID]);
    return 1;
}

stock Taxi_OnPlayerConnect(playerid)
{
    taxi_orders[playerid][E_ORDER_ACTIVE] = 0;
    taxi_orders[playerid][E_ORDER_EXECUTER_ID] = -1;
    taxi_driver_status[playerid] = 0;
    taxi_driver_order[playerid] = -1;
    taxi_driver_timer[playerid] = 0;
    return 1;
}

stock Taxi_OnPlayerDisconnect(playerid)
{
    if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]);
    taxi_orders[playerid][E_ORDER_ACTIVE] = 0;
    taxi_driver_status[playerid] = 0;
    for(new i; i < sizeof(taxi_vehicles); i++) if(taxi_vehicles[i][E_OWNER_ID] == playerid) taxi_vehicles[i][E_OWNER_ID] = INVALID_PLAYER_ID;
    return 1;
}

stock PhoneTaxi_OnPlayerRequest(playerid, type, event, extra)
{
    printf("PhoneTaxi_OnPlayerRequest: playerid=%d, type=%d, event=%d, extra=%d", playerid, type, event, extra);
    
    if(type == 5 && event == 0 && extra == 0)
    {
        printf("Opening taxi app for player %d, driver_status=%d, order_active=%d", playerid, taxi_driver_status[playerid], taxi_orders[playerid][E_ORDER_ACTIVE]);
        
        new jobs[3];
        EM_ManageJobs(playerid, 0, -1, jobs);
        new hasTaxiJob = (jobs[0] == 8 || jobs[1] == 8 || jobs[2] == 8);
        
        if(taxi_driver_status[playerid] && hasTaxiJob && IsPlayerInAnyVehicle(playerid) && Taxi_GetVehicleIndex(GetPlayerVehicleID(playerid)) != -1)
        {
            printf("Player %d is active driver, showing driver interface", playerid);
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(1)");
            Taxi_t_CefUpdateDriverInfo(playerid);
            Taxi_SendOrders(playerid);
            return 1;
        }
        
        if(taxi_orders[playerid][E_ORDER_ACTIVE])
        {
            printf("Player %d has active order, showing passenger interface", playerid);
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(0)");
            new Float:px, Float:py, Float:pz, Float:pa;
            GetPlayerPos(playerid, px, py, pz);
            GetPlayerFacingAngle(playerid, pa);
            format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').setPlayer('[%f,%f,%f,%f,0,\"%s\"]')", px, py, pz, pa, GetCityName(Get2DCity(px, py)));
            SendClientEvent(playerid, t_CefUpdate, str_q);
            
            if(taxi_orders[playerid][E_ORDER_EXECUTER_ID] == -1)
            {
                format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').orderTaxi('[%d,%f,%f,%f,%d,0,%d,%f,%f,%f,0]')", 
                    playerid, taxi_orders[playerid][E_ORDER_TO_X], taxi_orders[playerid][E_ORDER_TO_Y], taxi_orders[playerid][E_ORDER_TO_Z],
                    taxi_orders[playerid][E_ORDER_PRICE], taxi_orders[playerid][E_ORDER_UNIX_TIME],
                    taxi_orders[playerid][E_ORDER_FROM_X], taxi_orders[playerid][E_ORDER_FROM_Y], taxi_orders[playerid][E_ORDER_FROM_Z]);
                SendClientEvent(playerid, t_CefUpdate, str_q);
                format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateStatus(0)");
                SendClientEvent(playerid, t_CefUpdate, str_q);
            }
            else
            {
                new execid = taxi_orders[playerid][E_ORDER_EXECUTER_ID];
                if(IsPlayerConnected(execid))
                {
                    new vehicleid = GetPlayerVehicleID(execid);
                    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').orderTaxi('[%d,%f,%f,%f,%d,0,%d,%f,%f,%f,0]')", 
                        playerid, taxi_orders[playerid][E_ORDER_TO_X], taxi_orders[playerid][E_ORDER_TO_Y], taxi_orders[playerid][E_ORDER_TO_Z],
                        taxi_orders[playerid][E_ORDER_PRICE], taxi_orders[playerid][E_ORDER_UNIX_TIME],
                        taxi_orders[playerid][E_ORDER_FROM_X], taxi_orders[playerid][E_ORDER_FROM_Y], taxi_orders[playerid][E_ORDER_FROM_Z]);
                    SendClientEvent(playerid, t_CefUpdate, str_q);
                    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateStatus(1)");
                    SendClientEvent(playerid, t_CefUpdate, str_q);
                    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateExecuterInfo(0, '[\"%s\",\"%s\",\"[RU %s %s]\",\"%s\"]')", 
                        GetPlayerNameEx(execid), GetVehicleName(vehicleid), GetVehicleNumber(vehicleid), g_vehicle_data[vehicleid][V_REGION],
                        "Стандарт");
                    SendClientEvent(playerid, t_CefUpdate, str_q);
                }
            }
            return 1;
        }
        
        printf("Player %d showing role selection", playerid);
        SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(-1)");
        return 1;
    }
    if(type == 1 && event == 1 && extra == 0)
    {
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, px, py, pz);
        taxi_orders[playerid][E_ORDER_ACTIVE] = 1;
        taxi_orders[playerid][E_ORDER_CUSTOMER_ID] = playerid;
        taxi_orders[playerid][E_ORDER_FROM_X] = px;
        taxi_orders[playerid][E_ORDER_FROM_Y] = py;
        taxi_orders[playerid][E_ORDER_FROM_Z] = pz;
        taxi_orders[playerid][E_ORDER_TO_X] = px;
        taxi_orders[playerid][E_ORDER_TO_Y] = py;
        taxi_orders[playerid][E_ORDER_TO_Z] = pz;
        taxi_orders[playerid][E_ORDER_EXECUTER_ID] = -1;
        taxi_orders[playerid][E_ORDER_STATUS] = 0;
        taxi_orders[playerid][E_ORDER_UNIX_TIME] = gettime();
        taxi_orders[playerid][E_ORDER_CITY] = Get2DCity(px, py);
        GetPlayer2DZone(playerid, taxi_orders[playerid][E_ORDER_ZONE], 64);
        taxi_orders[playerid][E_ORDER_PRICE] = 50;
        return 1;
    }
    if(type == 1 && event == 0 && extra == 0)
    {
        printf("Taxi cancel order: playerid=%d, active=%d", playerid, taxi_orders[playerid][E_ORDER_ACTIVE]);
        if(!taxi_orders[playerid][E_ORDER_ACTIVE]) return 1;
        new execid = taxi_orders[playerid][E_ORDER_EXECUTER_ID];
        taxi_orders[playerid][E_ORDER_ACTIVE] = 0;
        taxi_orders[playerid][E_ORDER_EXECUTER_ID] = -1;
        if(taxi_orders[playerid][E_ORDER_TIMER]) KillTimer(taxi_orders[playerid][E_ORDER_TIMER]), taxi_orders[playerid][E_ORDER_TIMER] = 0;
        if(taxi_orders[playerid][E_ORDER_t_CefUpdate_TIMER]) KillTimer(taxi_orders[playerid][E_ORDER_t_CefUpdate_TIMER]), taxi_orders[playerid][E_ORDER_t_CefUpdate_TIMER] = 0;
        GameText(playerid, "~r~Заказ отменен", 2000, 3);
        SendClientMessage(playerid, 0xFF9501FF, "Вы отменили заказ такси");
        if(execid != -1 && IsPlayerConnected(execid))
        {
            SendClientMessage(execid, 0xFF9501FF, "Клиент отменил заказ");
            taxi_driver_order[execid] = -1;
            if(taxi_driver_timer[execid]) KillTimer(taxi_driver_timer[execid]), taxi_driver_timer[execid] = 0;
        }
        return 1;
    }
    if(type == 2 && event == 1 && extra == 0)
    {
        printf("Taxi driver start work: playerid=%d", playerid);
        new jobs[3];
        EM_ManageJobs(playerid, 0, -1, jobs);
        new hasTaxiJob = (jobs[0] == 8 || jobs[1] == 8 || jobs[2] == 8);
        
        if(!hasTaxiJob)
        {
            GameText(playerid, "~r~Ошибка", 2000, 3);
            SendClientMessage(playerid, 0xCECECEFF, "Сначала вам необходимо устроиться таксистом в центре занятости.");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(-1)");
            return 1;
        }
        
        if(!IsPlayerInAnyVehicle(playerid) || Taxi_GetVehicleIndex(GetPlayerVehicleID(playerid)) == -1)
        {
            GameText(playerid, "~r~Ошибка", 2000, 3);
            SendClientMessage(playerid, 0xFAAC58FF, "Для начала работы вы должны находиться в транспорте");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(-1)");
            return 1;
        }
        
        taxi_driver_status[playerid] = 1;
        if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]), taxi_driver_timer[playerid] = 0;
        
        GameText(playerid, "~g~Начало работы", 2000, 3);
        SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(1)");
        
        Taxi_t_CefUpdateDriverInfo(playerid);
        Taxi_SendOrders(playerid);
        
        printf("Taxi driver started, orders sent");
        return 1;
    }
    if(type == 2 && event == 0 && extra == 0)
    {
        printf("Taxi driver stop work: playerid=%d", playerid);
        taxi_driver_status[playerid] = 0;
        if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]), taxi_driver_timer[playerid] = 0;
        GameText(playerid, "~y~Окончание~n~работы", 2000, 3);
        SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getApp('taxi').setRole(-1)");
        return 1;
    }
    if(type == 10 && event == 0)
    {
        if(!taxi_driver_status[playerid]) return 1;
        if(extra >= MAX_PLAYERS || !taxi_orders[extra][E_ORDER_ACTIVE] || taxi_orders[extra][E_ORDER_EXECUTER_ID] != -1) return 1;
        Taxi_AcceptOrder(playerid, extra);
        return 1;
    }
    return 1;
}

stock PhoneTaxi_CreateOrder(playerid, Float:destX, Float:destY, Float:destZ)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    
    new Float:distance = floatsqroot(floatpower(destX - px, 2.0) + floatpower(destY - py, 2.0));
    new calculatedPrice = floatround(distance * 7.0);
    if(calculatedPrice < 50) calculatedPrice = 50;
    
    taxi_orders[playerid][E_ORDER_ACTIVE] = 1;
    taxi_orders[playerid][E_ORDER_CUSTOMER_ID] = playerid;
    taxi_orders[playerid][E_ORDER_FROM_X] = px;
    taxi_orders[playerid][E_ORDER_FROM_Y] = py;
    taxi_orders[playerid][E_ORDER_FROM_Z] = pz;
    taxi_orders[playerid][E_ORDER_TO_X] = destX;
    taxi_orders[playerid][E_ORDER_TO_Y] = destY;
    taxi_orders[playerid][E_ORDER_TO_Z] = destZ;
    taxi_orders[playerid][E_ORDER_EXECUTER_ID] = -1;
    taxi_orders[playerid][E_ORDER_STATUS] = 0;
    taxi_orders[playerid][E_ORDER_UNIX_TIME] = gettime();
    taxi_orders[playerid][E_ORDER_CITY] = Get2DCity(px, py);
    GetPlayer2DZone(playerid, taxi_orders[playerid][E_ORDER_ZONE], 64);
    taxi_orders[playerid][E_ORDER_PRICE] = calculatedPrice;
    
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateStatus(0)");
    SendClientEvent(playerid, t_CefUpdate, str_q);
    
    GameText(playerid, "~g~Успешно", 2000, 3);
    
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').orderTaxi('[%d,%f,%f,%f,%d,0,%d,%f,%f,%f,0]')", 
        playerid, destX, destY, destZ, calculatedPrice, gettime(), px, py, pz);
    SendClientEvent(playerid, t_CefUpdate, str_q);
    
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !taxi_driver_status[i]) continue;
        GameText(i, "Поступил ~n~~r~новый заказ", 2000, 3);
        format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateOrder('[%d,%f,%f,%f,%d,0,%d,%f,%f,%f,0,\"%s\",\"%s\",%d,\"%s\"]')", 
            playerid, px, py, 0.0, playerid, gettime(),
            destX, destY, destZ,
            GetPlayerNameEx(playerid), taxi_orders[playerid][E_ORDER_ZONE],
            taxi_orders[playerid][E_ORDER_CITY], GetCityName(taxi_orders[playerid][E_ORDER_CITY]));
        SendClientEvent(i, t_CefUpdate, str_q);
    }
    
    return 1;
}

stock Taxi_t_CefUpdateDriverInfo(playerid)
{
    new Float:px, Float:py, Float:pz, Float:pa, city, zone[64];
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerFacingAngle(playerid, pa);
    city = Get2DCity(px, py);
    GetPlayer2DZone(playerid, zone, sizeof(zone));
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').setPlayer('[%f,%f,%f,%f,1,\"%s\"]')", px, py, pz, pa, GetCityName(city));
    SendClientEvent(playerid, t_CefUpdate, str_q);
}

stock Taxi_SendOrders(playerid)
{
    printf("Taxi_SendOrders called for playerid=%d", playerid);
    str_q[0] = EOS;
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').setOrder('[[");
    new bool:first = true;
    new count = 0;
    
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!taxi_orders[i][E_ORDER_ACTIVE] || taxi_orders[i][E_ORDER_EXECUTER_ID] != -1) continue;
        count++;
        if(!first) strcat(str_q, ",[");
        else first = false;
        format(str_q, sizeof(str_q), "%d,%f,%f,%f,%d,0,%d,%f,%f,%f,0,\"%s\",\"%s\",%d,\"%s\"]", 
            i, taxi_orders[i][E_ORDER_FROM_X], taxi_orders[i][E_ORDER_FROM_Y], 0.0,
            taxi_orders[i][E_ORDER_CUSTOMER_ID], taxi_orders[i][E_ORDER_UNIX_TIME],
            taxi_orders[i][E_ORDER_TO_X], taxi_orders[i][E_ORDER_TO_Y], taxi_orders[i][E_ORDER_TO_Z],
            GetPlayerNameEx(taxi_orders[i][E_ORDER_CUSTOMER_ID]), taxi_orders[i][E_ORDER_ZONE],
            taxi_orders[i][E_ORDER_CITY], GetCityName(taxi_orders[i][E_ORDER_CITY]));
        strcat(str_q, str_q);
        printf("Added order %d from player %d", i, taxi_orders[i][E_ORDER_CUSTOMER_ID]);
    }
    strcat(str_q, "]]')");
    printf("Sending %d orders to driver %d: %s", count, playerid, str_q);
    SendClientEvent(playerid, t_CefUpdate, str_q);
}

stock Taxi_OnPlayerExitVehicle(playerid, vehicleid)
{
    new idx = Taxi_GetVehicleIndex(vehicleid);
    if(idx == -1 || taxi_vehicles[idx][E_OWNER_ID] != playerid) return 0;
    if(taxi_driver_status[playerid])
    {
        SendClientMessage(playerid, 0xF9501EFF, "У вас есть {FFFFFF}300 сек{F9501E}, чтобы вернуться в транспорт, иначе работа таксиста будет приостановлена");
        if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]);
        taxi_driver_timer[playerid] = SetTimerEx("Taxi_CheckDriverVehicle", 300000, false, "i", playerid);
    }
    GameText(playerid, "~w~Aренда будет завершена через ~y~5 мин.", 3000, 3);
    taxi_vehicles[idx][E_TIMER] = SetTimerEx("Taxi_ReleaseVehicle", 300000, false, "i", idx);
    return 1;
}

forward Taxi_t_CefUpdateDriverPosition(playerid);
public: Taxi_t_CefUpdateDriverPosition(playerid)
{
    if(!taxi_driver_status[playerid] || taxi_driver_order[playerid] == -1) return KillTimer(taxi_driver_timer[playerid]), taxi_driver_timer[playerid] = 0, 1;
    new orderid = taxi_driver_order[playerid];
    if(!taxi_orders[orderid][E_ORDER_ACTIVE]) return KillTimer(taxi_driver_timer[playerid]), taxi_driver_timer[playerid] = 0, 1;
    new Float:px, Float:py, Float:pz, Float:pa;
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerFacingAngle(playerid, pa);
    new customerid = taxi_orders[orderid][E_ORDER_CUSTOMER_ID];
    if(IsPlayerConnected(customerid))
    {
        format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateExecuterInfo(1, '[\"%s\",%f,%f,%f,%f,%f,%f,%f,0,\"%s\",\"%s\",%d]')", 
            GetPlayerNameEx(customerid), taxi_orders[orderid][E_ORDER_TO_X], taxi_orders[orderid][E_ORDER_TO_Y],
            taxi_orders[orderid][E_ORDER_FROM_X], taxi_orders[orderid][E_ORDER_FROM_Y],
            px, py, pa, GetCityName(taxi_orders[orderid][E_ORDER_CITY]), taxi_orders[orderid][E_ORDER_ZONE],
            customerid);
        SendClientEvent(playerid, t_CefUpdate, str_q);
    }
    return 1;
}

forward Taxi_OrderTimeout(orderid);
public: Taxi_OrderTimeout(orderid)
{
    if(!taxi_orders[orderid][E_ORDER_ACTIVE]) return 1;
    new customerid = taxi_orders[orderid][E_ORDER_CUSTOMER_ID];
    new execid = taxi_orders[orderid][E_ORDER_EXECUTER_ID];
    if(taxi_orders[orderid][E_ORDER_STATUS] == 1 && IsPlayerConnected(customerid))
    {
        SendClientMessage(customerid, 0xFF9501FF, "Заказ {FFFFFF}приостановлен{F9501E}, по причине {FFFFFF}Время ожидания вышло, вы не сели в такси");
        GameText(customerid, "~r~Заказ приостановлен", 2000, 3);
    }
    if(execid != -1 && IsPlayerConnected(execid))
    {
        SendClientMessage(execid, 0xFF9501FF, "Заказ отменен, клиент не сел в такси");
        taxi_driver_order[execid] = -1;
    }
    taxi_orders[orderid][E_ORDER_ACTIVE] = 0;
    if(taxi_orders[orderid][E_ORDER_t_CefUpdate_TIMER]) KillTimer(taxi_orders[orderid][E_ORDER_t_CefUpdate_TIMER]), taxi_orders[orderid][E_ORDER_t_CefUpdate_TIMER] = 0;
    return 1;
}

stock Taxi_AcceptOrder(playerid, orderid)
{
    if(!taxi_orders[orderid][E_ORDER_ACTIVE] || taxi_orders[orderid][E_ORDER_EXECUTER_ID] != -1) return 0;
    new customerid = taxi_orders[orderid][E_ORDER_CUSTOMER_ID];
    if(!IsPlayerConnected(customerid)) return 0;
    
    taxi_orders[orderid][E_ORDER_EXECUTER_ID] = playerid;
    taxi_orders[orderid][E_ORDER_STATUS] = 1;
    taxi_driver_order[playerid] = orderid;
    
    new vehicleid = GetPlayerVehicleID(playerid);
    
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateStatus(1)");
    SendClientEvent(customerid, t_CefUpdate, str_q);
    
    GameText(customerid, "~g~Машина в пути", 2000, 3);
    
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateExecuterInfo(0, '[\"%s\",\"%s\",\"[RU %s %s]\",\"%s\"]')", 
        GetPlayerNameEx(playerid), GetVehicleName(vehicleid), GetVehicleNumber(vehicleid), g_vehicle_data[vehicleid][V_REGION],
        "Стандарт");
    SendClientEvent(customerid, t_CefUpdate, str_q);
    
    GameText(playerid, "~g~Успех", 2000, 3);
    
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').deleteOrder(%d, 0, %d, %d)", orderid, taxi_orders[orderid][E_ORDER_CITY], customerid);
    SendClientEvent(playerid, t_CefUpdate, str_q);
    
    new Float:px, Float:py, Float:pz, Float:pa;
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerFacingAngle(playerid, pa);
    format(str_q, sizeof(str_q), "interface('Phone').getApp('taxi').t_CefUpdateExecuterInfo(1, '[\"%s\",%f,%f,%f,%f,%f,%f,%f,0,\"%s\",\"%s\",%d]')", 
        GetPlayerNameEx(customerid), taxi_orders[orderid][E_ORDER_TO_X], taxi_orders[orderid][E_ORDER_TO_Y],
        taxi_orders[orderid][E_ORDER_FROM_X], taxi_orders[orderid][E_ORDER_FROM_Y],
        px, py, pa, GetCityName(taxi_orders[orderid][E_ORDER_CITY]), taxi_orders[orderid][E_ORDER_ZONE],
        customerid);
    SendClientEvent(playerid, t_CefUpdate, str_q);
    
    format(str_q, sizeof(str_q), "window.getRoute(%f,%f,%f,%f,%f,%f,0,1)", 
        px, py, pz, taxi_orders[orderid][E_ORDER_FROM_X], taxi_orders[orderid][E_ORDER_FROM_Y], taxi_orders[orderid][E_ORDER_FROM_Z]);
    SendClientEvent(playerid, t_CefUpdate, str_q);
    
    taxi_orders[orderid][E_ORDER_TIMER] = SetTimerEx("Taxi_OrderTimeout", 300000, false, "i", orderid);
    if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]);
    taxi_driver_timer[playerid] = SetTimerEx("Taxi_t_CefUpdateDriverPosition", 1000, true, "i", playerid);
    
    return 1;
}

stock Taxi_DriverArrived(playerid, orderid)
{
    if(!taxi_orders[orderid][E_ORDER_ACTIVE] || taxi_orders[orderid][E_ORDER_EXECUTER_ID] != playerid) return 0;
    new customerid = taxi_orders[orderid][E_ORDER_CUSTOMER_ID];
    if(!IsPlayerConnected(customerid)) return 0;
    
    GameText(playerid, "~g~Вы прибыли~n~На место заказа", 2000, 3);
    format(str_q, sizeof(str_q), "Вы {FFFFFF}успешно{F9A61E} прибыли на место заказа, ожидайте клиента {FFFFFF}%s [тел %d]", 
        GetPlayerNameEx(customerid), GetPlayerPhone(customerid));
    SendClientMessage(playerid, 0xFF9A61FF, str_q);
    
    taxi_orders[orderid][E_ORDER_STATUS] = 2;
    return 1;
}

stock Taxi_CustomerEntered(playerid, orderid)
{
    if(!taxi_orders[orderid][E_ORDER_ACTIVE] || taxi_orders[orderid][E_ORDER_EXECUTER_ID] != playerid) return 0;
    new customerid = taxi_orders[orderid][E_ORDER_CUSTOMER_ID];
    if(!IsPlayerConnected(customerid)) return 0;
    
    if(taxi_orders[orderid][E_ORDER_TIMER]) KillTimer(taxi_orders[orderid][E_ORDER_TIMER]), taxi_orders[orderid][E_ORDER_TIMER] = 0;
    
    GameText(playerid, "~r~Начало поездки", 2000, 3);
    SendClientMessage(playerid, 0xFF9A61FF, "{FFFFFF}Клиент{F9A61E} сел к вам в автомобиль, доставьте его до указаной точки на карте");
    
    format(str_q, sizeof(str_q), "window.getRoute(%f,%f,%f,%f,%f,%f,0,1)", 
        taxi_orders[orderid][E_ORDER_FROM_X], taxi_orders[orderid][E_ORDER_FROM_Y], taxi_orders[orderid][E_ORDER_FROM_Z],
        taxi_orders[orderid][E_ORDER_TO_X], taxi_orders[orderid][E_ORDER_TO_Y], taxi_orders[orderid][E_ORDER_TO_Z]);
    SendClientEvent(playerid, t_CefUpdate, str_q);
    
    taxi_orders[orderid][E_ORDER_STATUS] = 3;
    
    new price = taxi_orders[orderid][E_ORDER_PRICE];
    if(GetPlayerLevel(customerid) <= 5)
    {
        GivePlayerMoneyEx(playerid, price, "Такси (новичок)");
        SendClientMessage(customerid, 0xFF9A61FF, "Поездка {FFFFFF}бесплатна{F9A61E} для новичков до 5 уровня");
    }
    else
    {
        if(GetILPlayerInt(GetPlayerMoneyEx(customerid), price))
        {
            GivePlayerMoneyEx(customerid, -price, "Оплата такси");
            GivePlayerMoneyEx(playerid, price, "Такси");
        }
    }
    
    return 1;
}

stock Taxi_CompleteOrder(playerid, orderid)
{
    if(!taxi_orders[orderid][E_ORDER_ACTIVE] || taxi_orders[orderid][E_ORDER_EXECUTER_ID] != playerid) return 0;
    new customerid = taxi_orders[orderid][E_ORDER_CUSTOMER_ID];
    
    GameText(playerid, "~g~Вы прибыли", 2000, 3);
    SendClientMessage(playerid, 0xFF9A61FF, "Вы {FFFFFF}успешно{F9A61E} прибыли в точку назначения");
    
    if(IsPlayerConnected(customerid))
    {
        GameText(customerid, "~g~Вы прибыли", 2000, 3);
        SendClientMessage(customerid, 0xFF9A61FF, "Вы {FFFFFF}успешно{F9A61E} прибыли в точку назначения");
    }
    
    taxi_orders[orderid][E_ORDER_ACTIVE] = 0;
    if(taxi_driver_timer[playerid]) KillTimer(taxi_driver_timer[playerid]), taxi_driver_timer[playerid] = 0;
    taxi_driver_order[playerid] = -1;
    
    return 1;
}


CMD:zakaz(playerid)
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;
    
    new count = 0;
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(taxi_orders[i][E_ORDER_ACTIVE]) count++;
    }
    
    format(str_q, sizeof(str_q), "%d", count);
    SendClientMessage(playerid, -1, str_q);
    return 1;
}
