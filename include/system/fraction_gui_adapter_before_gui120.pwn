#if defined _fraction_gui_adapter_included
    #endinput
#endif
#define _fraction_gui_adapter_included

#define FRACTION_GUI_PAGE_MAIN       (1)
#define FRACTION_GUI_PAGE_REWARD     (2)
#define FRACTION_GUI_PAGE_QUESTS     (3)
#define FRACTION_GUI_PAGE_DOCUMENTS  (4)
#define FRACTION_GUI_PAGE_TEST       (5)
#define FRACTION_GUI_PAGE_TEST_RESULT (6)
#define FRACTION_GUI_PAGE_TOKENS     (7)
#define FRACTION_GUI_PAGE_SHOP       (8)
#define FRACTION_GUI_PAGE_CONTROL    (9)

new g_fraction_gui_selected_account[MAX_PLAYERS];


#define ORG_TRANSPORT_GUI_ACTIVE_ID_BASE (10000)
#define ORG_TRANSPORT_GUI_MAX_ACTIVE_ROWS (40)

new bool:g_org_transport_gui_open[MAX_PLAYERS];
new g_org_transport_gui_selected_item[MAX_PLAYERS];

stock OrgTransportGuiEnsureTable()
{
    static bool:table_ready = false;
    if(table_ready) return 1;

    new query[320];
    format(query, sizeof query,
        "CREATE TABLE IF NOT EXISTS org_vehicle_access (team_id TINYINT NOT NULL, model_slot TINYINT NOT NULL, access_level TINYINT NOT NULL DEFAULT 1, PRIMARY KEY(team_id,model_slot)) ENGINE=InnoDB DEFAULT CHARSET=utf8"
    );
    mysql_query(mysql, query, false);
    table_ready = true;
    return 1;
}

stock OrgTransportGuiFindConfig(team)
{
    for(new i; i < sizeof(g_org_car); i++)
    {
        if(g_org_car[i][O_FRAC_ID] == team) return i;
    }
    return -1;
}

stock OrgTransportGuiFindModelSlot(config_id, model_id)
{
    if(config_id < 0 || config_id >= sizeof(g_org_car)) return -1;

    for(new slot; slot < 4; slot++)
    {
        if(g_org_car[config_id][O_MODEL][slot] == model_id) return slot;
    }
    return -1;
}

stock OrgTransportGuiAccessLevelToRank(access_level)
{
    if(access_level < 1) access_level = 1;
    if(access_level > 5) access_level = 5;
    return 1 + ((access_level - 1) * 2);
}

stock OrgTransportGuiGetAccessLevel(team, model_slot)
{
    OrgTransportGuiEnsureTable();

    new query[160], access_level = 1;
    format(query, sizeof query,
        "SELECT access_level FROM org_vehicle_access WHERE team_id=%d AND model_slot=%d LIMIT 1",
        team, model_slot
    );

    new Cache:result = mysql_query(mysql, query, true);
    if(cache_num_rows()) access_level = cache_get_field_content_int(0, "access_level");
    cache_delete(result);

    if(access_level < 1) access_level = 1;
    if(access_level > 5) access_level = 5;
    return access_level;
}

stock OrgTransportGuiSetAccessLevel(team, model_slot, access_level)
{
    OrgTransportGuiEnsureTable();

    if(access_level < 1) access_level = 1;
    if(access_level > 5) access_level = 5;

    new query[240];
    format(query, sizeof query,
        "INSERT INTO org_vehicle_access(team_id,model_slot,access_level) VALUES(%d,%d,%d) ON DUPLICATE KEY UPDATE access_level=%d",
        team, model_slot, access_level, access_level
    );
    mysql_query(mysql, query, false);
    return !mysql_errno();
}

stock OrgTransportGuiResetPlayer(playerid)
{
    g_org_transport_gui_open[playerid] = false;
    g_org_transport_gui_selected_item[playerid] = 0;
    return 1;
}

stock OrgTransportGuiIsOpen(playerid)
{
    return (g_org_transport_gui_open[playerid] && FractionGuiIsMember(playerid));
}

stock OrgTransportGuiGetVehicleDriver(vehicleid)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i)) continue;
        if(GetPlayerVehicleID(i) == vehicleid) return i;
    }
    return INVALID_PLAYER_ID;
}

stock OrgTransportGuiResolveItem(playerid, item_id, &bool:is_active, &config_id, &model_slot, &vehicleid)
{
    is_active = false;
    config_id = OrgTransportGuiFindConfig(GetPlayerTeamEx(playerid));
    model_slot = -1;
    vehicleid = INVALID_VEHICLE_ID;

    if(config_id == -1) return 0;

    if(item_id >= ORG_TRANSPORT_GUI_ACTIVE_ID_BASE)
    {
        vehicleid = item_id - ORG_TRANSPORT_GUI_ACTIVE_ID_BASE;
        if(!IsValidVehicle(vehicleid)) return 0;
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_ORG_CAR) return 0;
        if(GetVehicleData(vehicleid, V_ACTION_ID) != GetPlayerTeamEx(playerid)) return 0;

        model_slot = OrgTransportGuiFindModelSlot(config_id, GetVehicleData(vehicleid, V_MODELID));
        if(model_slot == -1) return 0;

        is_active = true;
        return 1;
    }

    model_slot = item_id - 1;
    if(model_slot < 0 || model_slot >= 4) return 0;
    if(g_org_car[config_id][O_MODEL][model_slot] == 0) return 0;
    return 1;
}

stock OrgTransportGuiSendActionResult(playerid, success)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 2);
    JSON_SetInt(response, "s", 2);
    JSON_SetInt(response, "d", success ? 1 : 0);
    OnPacketIncoming(playerid, GUIFamilySystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock OrgTransportGuiSendList(playerid)
{
    if(!FractionGuiIsMember(playerid)) return 0;

    new config_id = OrgTransportGuiFindConfig(GetPlayerTeamEx(playerid));
    if(config_id == -1)
    {
        ShowNotification(playerid, 2, "Для этой организации автопарк не настроен", 5, "", "");
        return 0;
    }

    new Node:response = JSON_Object();
    new Node:name_list = JSON_Array();
    new Node:id_list = JSON_Array();

    JSON_SetInt(response, "t", 2);
    JSON_SetInt(response, "g", 0);

    for(new slot; slot < 4; slot++)
    {
        new model_id = g_org_car[config_id][O_MODEL][slot];
        if(model_id == 0) continue;

        new model_name[48], row_text[112];
        GetVehicleModelName(model_id, model_name, sizeof model_name);

        new access_level = OrgTransportGuiGetAccessLevel(GetPlayerTeamEx(playerid), slot);
        new min_rank = OrgTransportGuiAccessLevelToRank(access_level);
        format(row_text, sizeof row_text, "Получить: %s | доступ с %d ранга", model_name, min_rank);

        name_list = JSON_Append(name_list, JSON_Array(JSON_String(row_text)));
        id_list = JSON_Append(id_list, JSON_Array(JSON_Int(slot + 1)));
    }

    new active_rows;
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES && active_rows < ORG_TRANSPORT_GUI_MAX_ACTIVE_ROWS; vehicleid++)
    {
        if(!IsValidVehicle(vehicleid)) continue;
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_ORG_CAR) continue;
        if(GetVehicleData(vehicleid, V_ACTION_ID) != GetPlayerTeamEx(playerid)) continue;

        new model_id = GetVehicleData(vehicleid, V_MODELID);
        new model_slot = OrgTransportGuiFindModelSlot(config_id, model_id);
        if(model_slot == -1) continue;

        new model_name[48], status_name[40], row_text[144];
        new driverid = OrgTransportGuiGetVehicleDriver(vehicleid);
        new ownerid = GetVehicleData(vehicleid, V_ACTION_OWNER);
        new Float:health;
        new health_percent;
        new fuel_percent = floatround((GetVehicleData(vehicleid, V_FUEL) / 150.0) * 100.0);

        GetVehicleModelName(model_id, model_name, sizeof model_name);
        GetVehicleHealth(vehicleid, health);
        health_percent = floatround(health / 10.0);
        if(health_percent < 0) health_percent = 0;
        if(health_percent > 100) health_percent = 100;
        if(fuel_percent < 0) fuel_percent = 0;
        if(fuel_percent > 100) fuel_percent = 100;

        if(driverid != INVALID_PLAYER_ID && IsPlayerConnected(driverid))
            format(status_name, sizeof status_name, "водитель %s", GetPlayerNameEx(driverid));
        else if(ownerid != INVALID_PLAYER_ID && IsPlayerConnected(ownerid))
            format(status_name, sizeof status_name, "выдан %s", GetPlayerNameEx(ownerid));
        else
            format(status_name, sizeof status_name, "свободен");

        format(row_text, sizeof row_text, "%s | %s | топливо %d%% | состояние %d%%",
            model_name, status_name, fuel_percent, health_percent);

        name_list = JSON_Append(name_list, JSON_Array(JSON_String(row_text)));
        id_list = JSON_Append(id_list, JSON_Array(JSON_Int(ORG_TRANSPORT_GUI_ACTIVE_ID_BASE + vehicleid)));
        active_rows++;
    }

    JSON_SetArray(response, "n", name_list);
    JSON_SetArray(response, "id", id_list);
    OnPacketIncoming(playerid, GUIFamilySystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock OrgTransportGuiSendInfo(playerid, item_id)
{
    new bool:is_active, config_id, model_slot, vehicleid;
    if(!OrgTransportGuiResolveItem(playerid, item_id, is_active, config_id, model_slot, vehicleid))
    {
        ShowNotification(playerid, 2, "Транспорт больше не найден", 5, "", "");
        return OrgTransportGuiSendList(playerid);
    }

    #pragma unused config_id
    #pragma unused vehicleid

    g_org_transport_gui_selected_item[playerid] = item_id;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 2);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "r", OrgTransportGuiGetAccessLevel(GetPlayerTeamEx(playerid), model_slot));
    JSON_SetInt(response, "d", is_active ? 1 : 0);
    OnPacketIncoming(playerid, GUIFamilySystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock OrgTransportGuiCreateVehicle(playerid, model_slot)
{
    new team = GetPlayerTeamEx(playerid);
    new config_id = OrgTransportGuiFindConfig(team);
    if(config_id == -1 || model_slot < 0 || model_slot >= 4) return 0;

    new model_id = g_org_car[config_id][O_MODEL][model_slot];
    if(model_id == 0) return 0;

    new current_vehicle = GetPlayerData(playerid, P_FRACTION_CAR);
    if(current_vehicle != INVALID_VEHICLE_ID)
    {
        if(IsValidVehicle(current_vehicle) &&
            GetVehicleData(current_vehicle, V_ACTION_TYPE) == VEHICLE_ACTION_ORG_CAR &&
            GetVehicleData(current_vehicle, V_ACTION_OWNER) == playerid)
        {
            ShowNotification(playerid, 2, "Вы уже получили транспорт организации", 5, "", "");
            return 0;
        }
        SetPlayerData(playerid, P_FRACTION_CAR, INVALID_VEHICLE_ID);
    }

    new access_level = OrgTransportGuiGetAccessLevel(team, model_slot);
    new min_rank = OrgTransportGuiAccessLevelToRank(access_level);
    if(GetPlayerJob(playerid) < min_rank)
    {
        new message[96];
        format(message, sizeof message, "Транспорт доступен с %d ранга", min_rank);
        ShowNotification(playerid, 2, message, 5, "", "");
        return 0;
    }

    new spawn_slot = g_org_car[config_id][O_COUNT];
    if(spawn_slot < 0 || spawn_slot >= 4) spawn_slot = 0;
    g_org_car[config_id][O_COUNT] = (spawn_slot + 1) % 4;

    new vehicleid = CreateVehicle(
        model_id,
        org_car_pos_spawn[config_id][spawn_slot][0],
        org_car_pos_spawn[config_id][spawn_slot][1],
        org_car_pos_spawn[config_id][spawn_slot][2],
        org_car_pos_spawn[config_id][spawn_slot][3],
        g_org_car[config_id][O_COLOR][0],
        g_org_car[config_id][O_COLOR][1],
        120,
        0,
        VEHICLE_ACTION_ORG_CAR,
        team
    );

    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        ShowNotification(playerid, 2, "Не удалось создать транспорт", 5, "", "");
        return 0;
    }

    SetVehicleData(vehicleid, V_ACTION_OWNER, playerid);
    SetPlayerData(playerid, P_FRACTION_CAR, vehicleid);

    new model_name[48], log_text[144];
    GetVehicleModelName(model_id, model_name, sizeof model_name);
    format(log_text, sizeof log_text, "Получил транспорт %s через меню автопарка организации", model_name);
    SendLog(playerid, LOG_TYPE_FRACTION, log_text);

    ShowNotification(playerid, 3, "Вы успешно получили транспорт организации", 4, "", "");
    return 1;
}

stock OrgTransportGuiReturnVehicle(playerid, item_id)
{
    new bool:is_active, config_id, model_slot, vehicleid;
    if(!OrgTransportGuiResolveItem(playerid, item_id, is_active, config_id, model_slot, vehicleid)) return 0;

    if(!is_active)
    {
        vehicleid = GetPlayerData(playerid, P_FRACTION_CAR);
        if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_ORG_CAR) return 0;
        if(GetVehicleData(vehicleid, V_ACTION_ID) != GetPlayerTeamEx(playerid)) return 0;
        if(OrgTransportGuiFindModelSlot(config_id, GetVehicleData(vehicleid, V_MODELID)) != model_slot) return 0;
    }

    new ownerid = GetVehicleData(vehicleid, V_ACTION_OWNER);
    new driverid = OrgTransportGuiGetVehicleDriver(vehicleid);

    if(ownerid != playerid && !FractionGuiCanManage(playerid))
    {
        ShowNotification(playerid, 2, "Вы не можете вернуть чужой транспорт", 5, "", "");
        return 0;
    }

    if(driverid != INVALID_PLAYER_ID && driverid != playerid)
    {
        ShowNotification(playerid, 2, "Транспорт сейчас используется другим игроком", 5, "", "");
        return 0;
    }

    if(driverid == playerid) RemovePlayerFromVehicle(playerid);
    if(ownerid != INVALID_PLAYER_ID && IsPlayerConnected(ownerid) && GetPlayerData(ownerid, P_FRACTION_CAR) == vehicleid)
        SetPlayerData(ownerid, P_FRACTION_CAR, INVALID_VEHICLE_ID);

    new model_name[48], log_text[144];
    GetVehicleModelName(GetVehicleData(vehicleid, V_MODELID), model_name, sizeof model_name);
    format(log_text, sizeof log_text, "Вернул транспорт %s через меню автопарка организации", model_name);
    SendLog(playerid, LOG_TYPE_FRACTION, log_text);

    DestroyVehicle(vehicleid);
    ShowNotification(playerid, 3, "Транспорт успешно возвращен в автопарк", 4, "", "");
    return 1;
}

stock OrgTransportGuiResetModel(playerid, model_slot)
{
    if(!FractionGuiCanManage(playerid))
    {
        ShowNotification(playerid, 2, "Сброс автопарка доступен руководству", 5, "", "");
        return 0;
    }

    new config_id = OrgTransportGuiFindConfig(GetPlayerTeamEx(playerid));
    if(config_id == -1 || model_slot < 0 || model_slot >= 4) return 0;

    new model_id = g_org_car[config_id][O_MODEL][model_slot];
    new returned_count;

    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(!IsValidVehicle(vehicleid)) continue;
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_ORG_CAR) continue;
        if(GetVehicleData(vehicleid, V_ACTION_ID) != GetPlayerTeamEx(playerid)) continue;
        if(GetVehicleData(vehicleid, V_MODELID) != model_id) continue;
        if(OrgTransportGuiGetVehicleDriver(vehicleid) != INVALID_PLAYER_ID) continue;

        new ownerid = GetVehicleData(vehicleid, V_ACTION_OWNER);
        if(ownerid != INVALID_PLAYER_ID && IsPlayerConnected(ownerid) && GetPlayerData(ownerid, P_FRACTION_CAR) == vehicleid)
            SetPlayerData(ownerid, P_FRACTION_CAR, INVALID_VEHICLE_ID);

        DestroyVehicle(vehicleid);
        returned_count++;
    }

    new message[112];
    format(message, sizeof message, "Возвращено свободного транспорта: %d", returned_count);
    ShowNotification(playerid, 3, message, 4, "", "");
    return 1;
}

stock OrgTransportGuiHandleAction(playerid, Node:request)
{
    new item_id, action_id;
    if(!JSON_GetInt(request, "m", item_id)) return OrgTransportGuiSendActionResult(playerid, 0);
    if(!JSON_GetInt(request, "id", action_id)) return OrgTransportGuiSendActionResult(playerid, 0);

    new bool:is_active, config_id, model_slot, vehicleid;
    if(!OrgTransportGuiResolveItem(playerid, item_id, is_active, config_id, model_slot, vehicleid))
        return OrgTransportGuiSendActionResult(playerid, 0);

    new success;

    switch(action_id)
    {
        case 0:
        {
            if(!is_active)
            {
                vehicleid = INVALID_VEHICLE_ID;
                new model_id = g_org_car[config_id][O_MODEL][model_slot];
                for(new i = 1; i < MAX_VEHICLES; i++)
                {
                    if(!IsValidVehicle(i)) continue;
                    if(GetVehicleData(i, V_ACTION_TYPE) != VEHICLE_ACTION_ORG_CAR) continue;
                    if(GetVehicleData(i, V_ACTION_ID) != GetPlayerTeamEx(playerid)) continue;
                    if(GetVehicleData(i, V_MODELID) != model_id) continue;
                    vehicleid = i;
                    break;
                }
            }

            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                new Float:x, Float:y, Float:z;
                GetVehiclePos(vehicleid, x, y, z);
                EnablePlayerGPS(playerid, 55, x, y, z, "");
                ShowNotification(playerid, 3, "Транспорт отмечен на GPS", 4, "", "");
                success = 1;
            }
            else ShowNotification(playerid, 2, "Активный транспорт этой модели не найден", 5, "", "");
        }
        case 1, 6:
        {
            if(is_active)
                ShowNotification(playerid, 2, "Этот транспорт уже находится в игре", 5, "", "");
            else
                success = OrgTransportGuiCreateVehicle(playerid, model_slot);
        }
        case 2:
        {
            ShowNotification(playerid, 2, "Передача транспорта организации в личный гараж запрещена", 5, "", "");
        }
        case 3:
        {
            if(!FractionGuiCanManage(playerid))
            {
                ShowNotification(playerid, 2, "Изменение доступа доступно руководству", 5, "", "");
            }
            else
            {
                new direction = -1;
                JSON_GetInt(request, "r", direction);

                new access_level = OrgTransportGuiGetAccessLevel(GetPlayerTeamEx(playerid), model_slot);
                if(direction == 0 && access_level > 1) access_level--;
                else if(direction == 1 && access_level < 5) access_level++;

                success = OrgTransportGuiSetAccessLevel(GetPlayerTeamEx(playerid), model_slot, access_level);
                if(success)
                {
                    new message[112];
                    format(message, sizeof message, "Доступ к транспорту установлен с %d ранга", OrgTransportGuiAccessLevelToRank(access_level));
                    ShowNotification(playerid, 3, message, 4, "", "");
                    OrgTransportGuiSendInfo(playerid, item_id);
                }
            }
        }
        case 4:
        {
            success = OrgTransportGuiReturnVehicle(playerid, item_id);
        }
        case 5:
        {
            ShowNotification(playerid, 2, "Система гаражей для организаций не используется", 5, "", "");
        }
        case 7:
        {
            success = OrgTransportGuiResetModel(playerid, model_slot);
        }
    }

    OrgTransportGuiSendActionResult(playerid, success);
    OrgTransportGuiSendList(playerid);
    return 1;
}

stock OrgTransportGuiHandlePacket(playerid, Node:request)
{
    new close_status;
    if(JSON_GetInt(request, "c", close_status) && close_status == 1)
    {
        g_org_transport_gui_open[playerid] = false;
        g_org_transport_gui_selected_item[playerid] = 0;
        return 1;
    }

    if(!OrgTransportGuiIsOpen(playerid)) return 0;

    new type;
    JSON_GetInt(request, "t", type);
    if(type != 2) return 1;

    new status;
    JSON_GetInt(request, "s", status);

    switch(status)
    {
        case 1:
        {
            new item_id;
            if(JSON_GetInt(request, "id", item_id)) return OrgTransportGuiSendInfo(playerid, item_id);
        }
        case 2: return OrgTransportGuiHandleAction(playerid, request);
    }

    return OrgTransportGuiSendList(playerid);
}

stock ShowOrgTransportGui(playerid)
{
    if(!FractionGuiIsMember(playerid))
    {
        ShowNotification(playerid, 2, "Вы не состоите в организации", 5, "", "");
        return 0;
    }

    new config_id = OrgTransportGuiFindConfig(GetPlayerTeamEx(playerid));
    if(config_id == -1)
    {
        ShowNotification(playerid, 2, "Для этой организации автопарк не настроен", 5, "", "");
        return 0;
    }

    HidePlayerGUI(playerid, GUIFractionSystem);
    g_org_transport_gui_open[playerid] = true;
    g_org_transport_gui_selected_item[playerid] = 0;

    new Node:response = JSON_Object();
    new org_name[64], player_name[MAX_PLAYER_NAME + 1];
    format(org_name, sizeof org_name, "%s: автопарк", GetTeamData(GetPlayerTeamEx(playerid), O_NAME));
    format(player_name, sizeof player_name, "%s", GetPlayerNameEx(playerid));

    JSON_SetString(response, "n", org_name);
    JSON_SetInt(response, "k", FractionGuiCanManage(playerid) ? 1 : 0);
    JSON_SetInt(response, "m", 0);
    JSON_SetInt(response, "j", 0);
    JSON_SetInt(response, "y", 0);
    JSON_SetInt(response, "b", 0);
    JSON_SetString(response, "pn", player_name);
    JSON_SetInt(response, "pi", playerid);
    JSON_SetInt(response, "is", 0);

    ShowPlayerGUI(playerid, GUIFamilySystem, response);
    JSON_Cleanup(response);

    printf("[ORG TRANSPORT GUI] open player=%d team=%d rank=%d", playerid, GetPlayerTeamEx(playerid), GetPlayerJob(playerid));
    return OrgTransportGuiSendList(playerid);
}

stock FractionGuiIsMember(playerid)
{
    new team = GetPlayerTeamEx(playerid);
    return (IsPlayerConnected(playerid) && IsPlayerLogged(playerid) && team >= 1 && team < MAX_ORG);
}

stock FractionGuiCanManage(playerid)
{
    new rank = GetPlayerJob(playerid);
    return (FractionGuiIsMember(playerid) && rank >= 9 && rank <= 10);
}

stock FractionGuiFindOnlinePlayer(account_id)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(GetPlayerAccountID(i) == account_id) return i;
    }
    return INVALID_PLAYER_ID;
}

// The Android client 16.81.4007 has layouts/resources only for fraction IDs
// 1..7 and legacy ID 11. Server organizations 8..10 are OPG and passing
// those IDs directly makes the client build the screen from empty resource
// lists, which can terminate the Android activity. Reuse the legacy safe
// template (11) for OPG until a custom APK adds dedicated OPG resources.
stock FractionGuiGetClientFractionId(server_team)
{
    if(server_team >= 1 && server_team <= 7) return server_team;
    if(server_team >= 8 && server_team <= 10) return 11;
    return 1;
}

stock FractionGuiSendMain(playerid, bool:open_gui = false)
{
    if(!FractionGuiIsMember(playerid))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в организации");
        return 0;
    }

    new server_team = GetPlayerTeamEx(playerid);
    new client_fraction_id = FractionGuiGetClientFractionId(server_team);
    new player_rank = GetPlayerJob(playerid);
    if(player_rank < 1 || player_rank > 10) player_rank = 1;

    new Node:response = JSON_Object();
    new Node:rank_status = JSON_Array();
    new Node:rank_progress = JSON_Array();

    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_MAIN);
    JSON_SetInt(response, "fraction_id", client_fraction_id);

    for(new rank = 1; rank <= 10; rank++)
    {
        new status;
        if(rank < player_rank) status = 4;          // received
        else if(rank == player_rank) status = 1;   // current
        else if(rank == player_rank + 1) status = 5; // contact leader
        else status = 0;                           // unavailable

        rank_status = JSON_Append(rank_status, JSON_Int(status));
    }

    // The client expects exactly two values: current progress and maximum.
    rank_progress = JSON_Append(rank_progress, JSON_Int(0));
    rank_progress = JSON_Append(rank_progress, JSON_Int(0));

    JSON_SetArray(response, "rank_status", rank_status);
    JSON_SetArray(response, "rank_progress", rank_progress);
    JSON_SetInt(response, "fraction_tokens", 1);
    JSON_SetInt(response, "fraction_tokens_value", 0);
    JSON_SetInt(response, "token_price", 1);

    if(open_gui)
    {
        printf("[ORG GUI] open player=%d server_team=%d client_fraction=%d rank=%d", playerid, server_team, client_fraction_id, player_rank);
        ShowPlayerGUI(playerid, GUIFractionSystem, response);
    }
    else UpdatePlayerGUI(playerid, GUIFractionSystem, response);

    JSON_Cleanup(response);
    return 1;
}

stock ShowFractionGui(playerid)
{
    g_org_transport_gui_open[playerid] = false;
    g_org_transport_gui_selected_item[playerid] = 0;
    HidePlayerGUI(playerid, GUIFamilySystem);
    g_fraction_gui_selected_account[playerid] = 0;
    return FractionGuiSendMain(playerid, true);
}

stock FractionGuiSendSimplePage(playerid, page)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", page);
    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGuiSendQuests(playerid)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_QUESTS);
    JSON_SetInt(response, "taskRank", GetPlayerJob(playerid));
    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGuiSendDocuments(playerid)
{
    new Node:response = JSON_Object();
    new Node:document_status = JSON_Array();

    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_DOCUMENTS);
    for(new i; i < 24; i++) document_status = JSON_Append(document_status, JSON_Int(0));
    JSON_SetArray(response, "document_status", document_status);

    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGuiSendTokenDialog(playerid)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_TOKENS);
    JSON_SetInt(response, "type", 2);
    JSON_SetInt(response, "bc_value", GetPlayerDonateRub(playerid));
    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGuiSendControlResult(playerid, type, value, const value_string[] = "")
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_CONTROL);
    JSON_SetInt(response, "type", type);

    switch(type)
    {
        case 2:
        {
            new rank_name_buffer[64];
            format(rank_name_buffer, sizeof rank_name_buffer, "%s", value_string);
            JSON_SetInt(response, "new_rank", value);
            JSON_SetString(response, "new_rank_name", rank_name_buffer);
        }
        case 3: JSON_SetInt(response, "new_reprimand", value);
        case 4: JSON_SetInt(response, "dismissed_account_id", value);
    }

    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGuiSendPlayerInfo(playerid, account_id)
{
    if(!FractionGuiIsMember(playerid)) return 0;

    new query[180];
    format(query, sizeof query,
        "SELECT id,name,skin,level,job,owarn,phone,team FROM accounts WHERE id=%d LIMIT 1",
        account_id
    );

    new Cache:result = mysql_query(mysql, query, true);
    if(!cache_num_rows())
    {
        cache_delete(result);
        SendClientMessage(playerid, 0xCECECEFF, "Сотрудник не найден");
        return 0;
    }

    new team = cache_get_field_content_int(0, "team");
    new rank = cache_get_field_content_int(0, "job");
    if(team != GetPlayerTeamEx(playerid) || rank < 1 || rank > 10)
    {
        cache_delete(result);
        SendClientMessage(playerid, 0xCECECEFF, "Этот игрок больше не состоит в Вашей организации");
        return 0;
    }

    new name[MAX_PLAYER_NAME + 1], phone_string[24], rank_name[60];
    cache_get_field_content(0, "name", name, sizeof name);
    format(phone_string, sizeof phone_string, "%d", cache_get_field_content_int(0, "phone"));
    format(rank_name, sizeof rank_name, "%s", GetTeamRankName(team, rank));

    g_fraction_gui_selected_account[playerid] = account_id;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_CONTROL);
    JSON_SetInt(response, "type", 1);
    JSON_SetString(response, "nickname", name);
    JSON_SetInt(response, "skin_id", cache_get_field_content_int(0, "skin"));
    JSON_SetInt(response, "level", cache_get_field_content_int(0, "level"));
    JSON_SetString(response, "rank_name", rank_name);
    JSON_SetInt(response, "rank", rank);
    JSON_SetInt(response, "reprimand", cache_get_field_content_int(0, "owarn"));
    JSON_SetString(response, "phone", phone_string);

    cache_delete(result);
    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGuiOpenControlPage(playerid)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", FRACTION_GUI_PAGE_CONTROL);
    JSON_SetInt(response, "type", 5);
    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);
    return FractionGuiSendStaffList(playerid, true);
}

stock FractionGuiSendStaffList(playerid, bool:open_control = true)
{
    if(!FractionGuiIsMember(playerid)) return 0;

    new query[180];
    format(query, sizeof query,
        "SELECT id,name,job,online FROM accounts WHERE team=%d ORDER BY online DESC,job DESC,name ASC LIMIT 100",
        GetPlayerTeamEx(playerid)
    );

    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows();
    new first_account_id;
    new bool:selected_found = false;
    new Node:response = JSON_Object();
    new Node:name_list = JSON_Array();
    new Node:rank_status_list = JSON_Array();

    for(new row; row < rows; row++)
    {
        new account_id = cache_get_field_content_int(row, "id");
        new rank = cache_get_field_content_int(row, "job");
        new online = (FractionGuiFindOnlinePlayer(account_id) != INVALID_PLAYER_ID) ? 1 : 0;
        new name[MAX_PLAYER_NAME + 1];
        cache_get_field_content(row, "name", name, sizeof name);

        if(!first_account_id) first_account_id = account_id;
        if(account_id == g_fraction_gui_selected_account[playerid]) selected_found = true;

        name_list = JSON_Append(name_list, JSON_String(name));
        rank_status_list = JSON_Append(rank_status_list, JSON_Int(account_id));
        rank_status_list = JSON_Append(rank_status_list, JSON_Int(rank));
        rank_status_list = JSON_Append(rank_status_list, JSON_Int(online));
    }

    cache_delete(result);

    JSON_SetInt(response, "t", 4);
    JSON_SetArray(response, "np", name_list);
    JSON_SetArray(response, "rs", rank_status_list);
    UpdatePlayerGUI(playerid, GUIFractionSystem, response);
    JSON_Cleanup(response);

    if(!rows)
    {
        SendClientMessage(playerid, 0xCECECEFF, "В организации нет сотрудников");
        return FractionGuiSendMain(playerid);
    }

    if(open_control || !g_fraction_gui_selected_account[playerid] || !selected_found)
        g_fraction_gui_selected_account[playerid] = first_account_id;

    return FractionGuiSendPlayerInfo(playerid, g_fraction_gui_selected_account[playerid]);
}

stock FractionGuiValidateManagedAccount(playerid, account_id, &target_player, &target_rank, &target_warn, &target_sex, target_name[], target_name_size)
{
    target_player = INVALID_PLAYER_ID;
    target_rank = 0;
    target_warn = 0;
    target_sex = 0;
    target_name[0] = EOS;

    if(!FractionGuiCanManage(playerid))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Управление доступно лидеру и заместителю организации");
        return 0;
    }

    if(account_id <= 0 || account_id == GetPlayerAccountID(playerid))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя применить действие к самому себе");
        return 0;
    }

    new query[150];
    format(query, sizeof query, "SELECT name,team,job,owarn,sex FROM accounts WHERE id=%d LIMIT 1", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(!cache_num_rows())
    {
        cache_delete(result);
        SendClientMessage(playerid, 0xCECECEFF, "Сотрудник не найден");
        return 0;
    }

    new team = cache_get_field_content_int(0, "team");
    target_rank = cache_get_field_content_int(0, "job");
    target_warn = cache_get_field_content_int(0, "owarn");
    target_sex = cache_get_field_content_int(0, "sex");
    cache_get_field_content(0, "name", target_name, mysql, target_name_size);
    cache_delete(result);

    if(team != GetPlayerTeamEx(playerid))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей организации");
        return 0;
    }

    if(target_rank >= GetPlayerJob(playerid))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя управлять сотрудником с равным или более высоким рангом");
        return 0;
    }

    target_player = FractionGuiFindOnlinePlayer(account_id);
    return 1;
}

stock FractionGuiChangeRank(playerid, change)
{
    new account_id = g_fraction_gui_selected_account[playerid];
    if(change != 0 && change != 1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Некорректное направление изменения ранга");
        return 0;
    }

    new target_player, target_rank, target_warn, target_sex, target_name[MAX_PLAYER_NAME + 1];
    if(!FractionGuiValidateManagedAccount(playerid, account_id, target_player, target_rank, target_warn, target_sex, target_name, sizeof target_name)) return 0;

    new new_rank = target_rank + ((change == 1) ? 1 : -1);
    if(new_rank < 1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя понизить ниже первого ранга");
        return 0;
    }
    if(new_rank >= GetPlayerJob(playerid) || new_rank > 9)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя повысить сотрудника до своего ранга или выше");
        return 0;
    }

    #pragma unused target_warn
    new team = GetPlayerTeamEx(playerid);
    new new_org_skin = GetTeamData(team, O_SKINS)[new_rank - 1];
    if(target_sex) new_org_skin = GetTeamData(team, O_WOMEN_SKIN);

    if(target_player != INVALID_PLAYER_ID)
    {
        SetPlayerData(target_player, P_JOB, new_rank);
        SetPlayerData(target_player, P_OSKIN, new_org_skin);
        ResetSkin(target_player);

        new target_message[144];
        format(target_message, sizeof target_message, "Ваш ранг в организации изменён на %d (%s)", new_rank, GetTeamRankName(GetPlayerTeamEx(playerid), new_rank));
        SendClientMessage(target_player, 0x3399FFFF, target_message);
    }

    new query[160];
    format(query, sizeof query, "UPDATE accounts SET job=%d,org_skin=%d WHERE id=%d LIMIT 1", new_rank, new_org_skin, account_id);
    mysql_query(mysql, query, false);

    new log_text[144];
    format(log_text, sizeof log_text, "%s %s[acc:%d] до %d (%s) через меню организации",
        (change == 1) ? ("Повысил") : ("Понизил"),
        target_name, account_id, new_rank, GetTeamRankName(GetPlayerTeamEx(playerid), new_rank));
    SendLog(playerid, LOG_TYPE_FRACTION, log_text);

    FractionGuiSendControlResult(playerid, 2, new_rank, GetTeamRankName(GetPlayerTeamEx(playerid), new_rank));
    return FractionGuiSendStaffList(playerid, false);
}

stock FractionGuiChangeReprimand(playerid, change)
{
    new account_id = g_fraction_gui_selected_account[playerid];
    if(change != 0 && change != 1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Некорректное направление изменения предупреждения");
        return 0;
    }

    new target_player, target_rank, target_warn, target_sex, target_name[MAX_PLAYER_NAME + 1];
    if(!FractionGuiValidateManagedAccount(playerid, account_id, target_player, target_rank, target_warn, target_sex, target_name, sizeof target_name)) return 0;

    #pragma unused target_rank
    #pragma unused target_sex
    new new_warn = target_warn + ((change == 1) ? 1 : -1);
    if(new_warn < 0) new_warn = 0;

    if(new_warn >= 3)
    {
        if(target_player != INVALID_PLAYER_ID)
        {
            SetPlayerData(target_player, P_OWARN, 0);
            UnInvite(playerid, target_player, "3 предупреждения");
        }
        else
        {
            new dismiss_query[150];
            format(dismiss_query, sizeof dismiss_query, "UPDATE accounts SET team=0,job=0,org_skin=0,owarn=0 WHERE id=%d LIMIT 1", account_id);
            mysql_query(mysql, dismiss_query, false);
        }

        FractionGuiSendControlResult(playerid, 4, account_id);
        g_fraction_gui_selected_account[playerid] = 0;

        new log_text[144];
        format(log_text, sizeof log_text, "Уволил %s[acc:%d] за 3 предупреждения через меню организации", target_name, account_id);
        SendLog(playerid, LOG_TYPE_FRACTION, log_text);
        return FractionGuiSendStaffList(playerid, true);
    }

    if(target_player != INVALID_PLAYER_ID) SetPlayerData(target_player, P_OWARN, new_warn);

    new query[120];
    format(query, sizeof query, "UPDATE accounts SET owarn=%d WHERE id=%d LIMIT 1", new_warn, account_id);
    mysql_query(mysql, query, false);

    new log_text[144];
    format(log_text, sizeof log_text, "%s предупреждение %s[acc:%d], теперь %d/3, через меню организации",
        (change == 1) ? ("Выдал") : ("Снял"), target_name, account_id, new_warn);
    SendLog(playerid, LOG_TYPE_FRACTION, log_text);

    FractionGuiSendControlResult(playerid, 3, new_warn);
    return FractionGuiSendStaffList(playerid, false);
}

stock FractionGuiDismissMember(playerid)
{
    new account_id = g_fraction_gui_selected_account[playerid];
    new target_player, target_rank, target_warn, target_sex, target_name[MAX_PLAYER_NAME + 1];
    if(!FractionGuiValidateManagedAccount(playerid, account_id, target_player, target_rank, target_warn, target_sex, target_name, sizeof target_name)) return 0;

    #pragma unused target_rank
    #pragma unused target_warn
    #pragma unused target_sex
    if(target_player != INVALID_PLAYER_ID)
    {
        SetPlayerData(target_player, P_OWARN, 0);
        UnInvite(playerid, target_player, "Уволен через меню организации");
    }
    else
    {
        new query[150];
        format(query, sizeof query, "UPDATE accounts SET team=0,job=0,org_skin=0,owarn=0 WHERE id=%d LIMIT 1", account_id);
        mysql_query(mysql, query, false);
    }

    new log_text[144];
    format(log_text, sizeof log_text, "Уволил %s[acc:%d] через меню организации", target_name, account_id);
    SendLog(playerid, LOG_TYPE_FRACTION, log_text);

    FractionGuiSendControlResult(playerid, 4, account_id);
    g_fraction_gui_selected_account[playerid] = 0;
    return FractionGuiSendStaffList(playerid, true);
}

stock FractionGuiHandlePacket(playerid, Node:request)
{
    if(!FractionGuiIsMember(playerid))
    {
        HidePlayerGUI(playerid, GUIFractionSystem);
        return 1;
    }

    new page, button;
    JSON_GetInt(request, "page", page);
    JSON_GetInt(request, "button", button);

    switch(page)
    {
        case FRACTION_GUI_PAGE_MAIN:
        {
            switch(button)
            {
                case 2: return FractionGuiSendTokenDialog(playerid);
                case 3: return FractionGuiSendSimplePage(playerid, FRACTION_GUI_PAGE_SHOP);
                case 4: return FractionGuiSendDocuments(playerid);
                case 5: return FractionGuiOpenControlPage(playerid);
                case 6: return FractionGuiSendQuests(playerid);
                case 7:
                {
                    SendClientMessage(playerid, 0xCECECEFF, "Повышение выдаётся руководством организации");
                    return FractionGuiSendMain(playerid);
                }
                case 11: return FractionGuiSendMain(playerid);
            }
        }
        case FRACTION_GUI_PAGE_QUESTS:
        {
            if(button == 11) return FractionGuiSendMain(playerid);
            if(button == 10)
            {
                ShowNotification(playerid, 3, "Вы успешно взяли задание", 4, "", "");
                return FractionGuiSendQuests(playerid);
            }
        }
        case FRACTION_GUI_PAGE_DOCUMENTS:
        {
            if(button == 11) return FractionGuiSendMain(playerid);
            if(button == 9)
            {
                new Node:response = JSON_Object();
                JSON_SetInt(response, "page", FRACTION_GUI_PAGE_TEST);
                UpdatePlayerGUI(playerid, GUIFractionSystem, response);
                JSON_Cleanup(response);
                return 1;
            }
        }
        case FRACTION_GUI_PAGE_TEST:
        {
            if(button == 11) return FractionGuiSendDocuments(playerid);
            if(button == 13)
            {
                new Node:response = JSON_Object();
                JSON_SetInt(response, "page", FRACTION_GUI_PAGE_TEST_RESULT);
                JSON_SetInt(response, "testing_result", 1);
                JSON_SetInt(response, "testing_total", 1);
                JSON_SetInt(response, "question_total", 1);
                UpdatePlayerGUI(playerid, GUIFractionSystem, response);
                JSON_Cleanup(response);
                return 1;
            }
        }
        case FRACTION_GUI_PAGE_TOKENS:
        {
            if(button == 14)
                SendClientMessage(playerid, 0xCECECEFF, "Покупка жетонов отключена до настройки экономики организации");
            return 1;
        }
        case FRACTION_GUI_PAGE_SHOP:
        {
            if(button == 11) return FractionGuiSendMain(playerid);
            SendClientMessage(playerid, 0xCECECEFF, "Магазин организации открыт в демонстрационном режиме");
            return FractionGuiSendSimplePage(playerid, FRACTION_GUI_PAGE_SHOP);
        }
        case FRACTION_GUI_PAGE_CONTROL:
        {
            switch(button)
            {
                case 11: return FractionGuiSendMain(playerid);
                case 15:
                {
                    new account_id;
                    if(JSON_GetInt(request, "account_id", account_id))
                        return FractionGuiSendPlayerInfo(playerid, account_id);
                }
                case 16:
                {
                    new change;
                    JSON_GetInt(request, "change", change);
                    return FractionGuiChangeRank(playerid, change);
                }
                case 17:
                {
                    new change;
                    JSON_GetInt(request, "change", change);
                    return FractionGuiChangeReprimand(playerid, change);
                }
                case 18: return FractionGuiDismissMember(playerid);
            }
        }
    }

    return 1;
}

CMD:orgmenu(playerid, params[])
{
    #pragma unused params
    return ShowFractionGui(playerid);
}
alias:orgmenu("omenu", "orgpanel", "fractionmenu", "org")

CMD:orgcars(playerid, params[])
{
    #pragma unused params
    return ShowOrgTransportGui(playerid);
}
alias:orgcars("orgcar", "orgtransport", "fractioncars")
