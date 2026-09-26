#define FRACTION_GUI_ID  (46)
#define ORG_TRANSPORT_GUI_ID  (120) // неправильно, кто сможет найдиле пж гуи айди норм. система сама фулл, только нету норм гаража

#define ORG_TRANSPORT_GUI_ACTIVE_ID_BASE (10000)
#define ORG_TRANSPORT_GUI_MAX_ACTIVE_ROWS (40)

// До 100 сотрудников в списке одновременно на экране — увеличь при необходимости.
new g_FracStaffIds[MAX_PLAYERS][100];
new g_FracStaffCount[MAX_PLAYERS];
new g_fraction_gui_selected_account[MAX_PLAYERS]; // кого выбрали в button 11, для button 12/13
new bool:g_org_transport_gui_open[MAX_PLAYERS];
new g_org_transport_gui_selected_item[MAX_PLAYERS];

// -----------------------------------------------------------------------------
// Права/проверки (из fraction_gui_adapter.pwn)
// -----------------------------------------------------------------------------
stock FracIsMember(playerid)
{
    new team = GetPlayerTeamEx(playerid);
    return (IsPlayerConnected(playerid) && IsPlayerLogged(playerid) && team >= 1 && team < MAX_ORG);
}

stock FracCanManage(playerid)
{
    new rank = GetPlayerData(playerid, P_JOB);
    return (FracIsMember(playerid) && rank >= 9 && rank <= 10);
}

// Алиасы под именами из старого fraction_gui_adapter.pwn — их использует
// секция OrgTransportGui ниже (гараж организации), которую переносим as-is.
stock FractionGuiIsMember(playerid) return FracIsMember(playerid);
stock FractionGuiCanManage(playerid) return FracCanManage(playerid);

stock FracFindOnlinePlayer(account_id)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(GetPlayerAccountID(i) == account_id) return i;
    }
    return INVALID_PLAYER_ID;
}

// Общая проверка + подгрузка данных сотрудника, которым хотим управлять.
// Возвращает 0 и сама шлёт причину игроку, если управлять нельзя.
stock FracValidateManagedAccount(playerid, account_id, &target_player, &target_rank, &target_warn, &target_sex, target_name[], target_name_size)
{
    target_player = INVALID_PLAYER_ID;
    target_rank = 0;
    target_warn = 0;
    target_sex = 0;
    target_name[0] = EOS;

    if(!FracCanManage(playerid))
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

    if(target_rank >= GetPlayerData(playerid, P_JOB))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя управлять сотрудником с равным или более высоким рангом");
        return 0;
    }

    target_player = FracFindOnlinePlayer(account_id);
    return 1;
}

// -----------------------------------------------------------------------------
// Главная страница (button 1 / 10) — было почти реальным и в стабе, просто
// объединил дублирующийся код кейсов 1 и 10 (в кейсе 10 раньше забывали
// прислать rank_status/rank_progress).
// -----------------------------------------------------------------------------
stock FracBuildMainResponse(playerid, Node:response)
{
    new teamid = GetPlayerTeamEx(playerid);
    if(teamid == TEAM_NONE)
    {
        JSON_SetInt(response, "page", 1);
        return 0;
    }

    new playerRank = GetPlayerData(playerid, P_JOB);
    if(!(1 <= playerRank <= 10)) playerRank = 1;

    JSON_SetInt(response, "page", 1);
    JSON_SetInt(response, "fraction_id", teamid);

    new st[10], pr[10];
    for(new i = 0; i < 10; i++)
    {
        if(i + 1 < playerRank) st[i] = 2;
        else if(i + 1 == playerRank) st[i] = 1;
        else st[i] = 0;
        pr[i] = (i + 1 == playerRank) ? 5 : 0; // TODO: реальный прогресс/XP до след. ранга
    }

    new Node:s1 = JSON_Int(st[0]); new Node:s2 = JSON_Int(st[1]); new Node:s3 = JSON_Int(st[2]); new Node:s4 = JSON_Int(st[3]); new Node:s5 = JSON_Int(st[4]);
    new Node:s6 = JSON_Int(st[5]); new Node:s7 = JSON_Int(st[6]); new Node:s8 = JSON_Int(st[7]); new Node:s9 = JSON_Int(st[8]); new Node:s10 = JSON_Int(st[9]);
    new Node:status_array = JSON_Array(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
    JSON_SetArray(response, "rank_status", status_array);

    new Node:p1 = JSON_Int(pr[0]); new Node:p2 = JSON_Int(pr[1]); new Node:p3 = JSON_Int(pr[2]); new Node:p4 = JSON_Int(pr[3]); new Node:p5 = JSON_Int(pr[4]);
    new Node:p6 = JSON_Int(pr[5]); new Node:p7 = JSON_Int(pr[6]); new Node:p8 = JSON_Int(pr[7]); new Node:p9 = JSON_Int(pr[8]); new Node:p10 = JSON_Int(pr[9]);
    new Node:progress_array = JSON_Array(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
    JSON_SetArray(response, "rank_progress", progress_array);

    JSON_Cleanup(s1); JSON_Cleanup(s2); JSON_Cleanup(s3); JSON_Cleanup(s4); JSON_Cleanup(s5); JSON_Cleanup(s6); JSON_Cleanup(s7); JSON_Cleanup(s8); JSON_Cleanup(s9); JSON_Cleanup(s10);
    JSON_Cleanup(p1); JSON_Cleanup(p2); JSON_Cleanup(p3); JSON_Cleanup(p4); JSON_Cleanup(p5); JSON_Cleanup(p6); JSON_Cleanup(p7); JSON_Cleanup(p8); JSON_Cleanup(p9); JSON_Cleanup(p10);
    JSON_Cleanup(status_array);
    JSON_Cleanup(progress_array);
    return 1;
}

// -----------------------------------------------------------------------------
// Список сотрудников (button 4) — реальный запрос к `accounts` вместо
// Player_One/Player_Two. Сохраняем account_id по индексу в g_FracStaffIds,
// чтобы button 11/12/13 знали, кого выбрали.
// -----------------------------------------------------------------------------
stock FracSendStaffList(playerid, Node:response)
{
    JSON_SetInt(response, "page", 9);

    new query[150];
    format(query, sizeof query,
        "SELECT id,name,job FROM accounts WHERE team=%d ORDER BY job DESC,name ASC LIMIT 100",
        GetPlayerTeamEx(playerid));

    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows();
    if(rows > 100) rows = 100;

    new Node:name_list = JSON_Array();
    new Node:rs_list = JSON_Array();

    for(new row; row < rows; row++)
    {
        new account_id = cache_get_field_content_int(row, "id");
        new rank = cache_get_field_content_int(row, "job");
        new name[MAX_PLAYER_NAME + 1];
        cache_get_field_content(row, "name", name, sizeof name);

        g_FracStaffIds[playerid][row] = account_id;

        new Node:nick_node = JSON_String(name);
        name_list = JSON_Append(name_list, nick_node);
        JSON_Cleanup(nick_node);

        new Node:rank_node = JSON_Int(rank);
        rs_list = JSON_Append(rs_list, rank_node);
        JSON_Cleanup(rank_node);
    }
    cache_delete(result);
    g_FracStaffCount[playerid] = rows;

    JSON_SetArray(response, "fraction_control_t_list_of_nicknames", name_list);
    JSON_SetArray(response, "rs", rs_list);
    JSON_Cleanup(name_list);
    JSON_Cleanup(rs_list);
    return 1;
}

// -----------------------------------------------------------------------------
// Карточка сотрудника (button 11). ДОПУЩЕНИЕ: индекс выбранного сотрудника
// приходит в поле "id" (0-based, по порядку последнего списка из button 4).
// -----------------------------------------------------------------------------
stock FracSendPlayerInfo(playerid, Node:response, Node:incoming)
{
    new selected_index;
    JSON_GetInt(incoming, "id", selected_index);

    if(selected_index < 0 || selected_index >= g_FracStaffCount[playerid])
    {
        SendClientMessage(playerid, 0xCECECEFF, "Сотрудник не найден");
        JSON_SetInt(response, "page", 9);
        return 0;
    }

    new account_id = g_FracStaffIds[playerid][selected_index];

    new query[180];
    format(query, sizeof query,
        "SELECT id,name,skin,level,job,owarn,phone,team FROM accounts WHERE id=%d LIMIT 1",
        account_id);

    new Cache:result = mysql_query(mysql, query, true);
    if(!cache_num_rows())
    {
        cache_delete(result);
        SendClientMessage(playerid, 0xCECECEFF, "Сотрудник не найден");
        JSON_SetInt(response, "page", 9);
        return 0;
    }

    new team = cache_get_field_content_int(0, "team");
    new rank = cache_get_field_content_int(0, "job");
    if(team != GetPlayerTeamEx(playerid) || rank < 1 || rank > 10)
    {
        cache_delete(result);
        SendClientMessage(playerid, 0xCECECEFF, "Этот игрок больше не состоит в Вашей организации");
        JSON_SetInt(response, "page", 9);
        return 0;
    }

    new name[MAX_PLAYER_NAME + 1], phone_string[24], rank_name[60];
    cache_get_field_content(0, "name", name, mysql, sizeof name);
    format(phone_string, sizeof phone_string, "%d", cache_get_field_content_int(0, "phone"));
    format(rank_name, sizeof rank_name, "%s", GetTeamRankName(team, rank));
    cache_delete(result);

    // Запоминаем выбранного, чтобы button 12/13 знали, к кому применять действие.
    g_fraction_gui_selected_account[playerid] = account_id;

    JSON_SetInt(response, "page", 9);
    JSON_SetInt(response, "type", 2);
    JSON_SetString(response, "fraction_control_player_nickname", name);
    JSON_SetInt(response, "fraction_control_player_skin_id", cache_get_field_content_int(0, "skin"));
    JSON_SetInt(response, "level", cache_get_field_content_int(0, "level"));
    JSON_SetString(response, "fraction_control_player_rank_name", rank_name);
    JSON_SetInt(response, "fraction_control_player_rank", rank);
    JSON_SetInt(response, "fraction_control_player_reprimand", cache_get_field_content_int(0, "owarn"));
    JSON_SetString(response, "phone", phone_string);
    return 1;
}

// -----------------------------------------------------------------------------
// Повышение/понижение (button 12). ДОПУЩЕНИЕ: направление приходит в "r"
// (1 = повысить, 0 = понизить) — как и в остальных panel'ях этого клиента.
// -----------------------------------------------------------------------------
stock FracChangeRank(playerid, Node:response, Node:incoming)
{
    new change;
    JSON_GetInt(incoming, "r", change);

    new account_id = g_fraction_gui_selected_account[playerid];
    if(change != 0 && change != 1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Некорректное направление изменения ранга");
        JSON_SetInt(response, "page", 9);
        return 0;
    }

    new target_player, target_rank, target_warn, target_sex, target_name[MAX_PLAYER_NAME + 1];
    if(!FracValidateManagedAccount(playerid, account_id, target_player, target_rank, target_warn, target_sex, target_name, sizeof target_name))
    {
        JSON_SetInt(response, "page", 9);
        return 0;
    }

    new new_rank = target_rank + ((change == 1) ? 1 : -1);
    if(new_rank < 1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя понизить ниже первого ранга");
        JSON_SetInt(response, "page", 9);
        return 0;
    }
    if(new_rank >= GetPlayerData(playerid, P_JOB) || new_rank > 9)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Нельзя повысить сотрудника до своего ранга или выше");
        JSON_SetInt(response, "page", 9);
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
        format(target_message, sizeof target_message, "Ваш ранг в организации изменён на %d (%s)", new_rank, GetTeamRankName(team, new_rank));
        SendClientMessage(target_player, 0x3399FFFF, target_message);
    }

    new query[160];
    format(query, sizeof query, "UPDATE accounts SET job=%d,org_skin=%d WHERE id=%d LIMIT 1", new_rank, new_org_skin, account_id);
    mysql_query(mysql, query, false);

    new log_text[144];
    format(log_text, sizeof log_text, "%s %s[acc:%d] до %d (%s) через меню организации",
        (change == 1) ? ("Повысил") : ("Понизил"),
        target_name, account_id, new_rank, GetTeamRankName(team, new_rank));
    SendLog(playerid, LOG_TYPE_FRACTION, log_text);

    JSON_SetInt(response, "page", 9);
    JSON_SetInt(response, "type", 3);
    JSON_SetInt(response, "new_rank", new_rank);
    JSON_SetString(response, "fraction_control_player_new_position", GetTeamRankName(team, new_rank));
    return 1;
}

// -----------------------------------------------------------------------------
// Выговор (button 13). ДОПУЩЕНИЕ: направление тоже приходит в "r"
// (1 = выдать варн, 0 = снять). При 3-м варне — увольнение.
// -----------------------------------------------------------------------------
stock FracChangeReprimand(playerid, Node:response, Node:incoming)
{
    new change;
    JSON_GetInt(incoming, "r", change);

    new account_id = g_fraction_gui_selected_account[playerid];
    if(change != 0 && change != 1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Некорректное направление изменения предупреждения");
        JSON_SetInt(response, "page", 9);
        return 0;
    }

    new target_player, target_rank, target_warn, target_sex, target_name[MAX_PLAYER_NAME + 1];
    if(!FracValidateManagedAccount(playerid, account_id, target_player, target_rank, target_warn, target_sex, target_name, sizeof target_name))
    {
        JSON_SetInt(response, "page", 9);
        return 0;
    }
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

        new log_text[144];
        format(log_text, sizeof log_text, "Уволил %s[acc:%d] за 3 предупреждения через меню организации", target_name, account_id);
        SendLog(playerid, LOG_TYPE_FRACTION, log_text);

        g_fraction_gui_selected_account[playerid] = 0;
        JSON_SetInt(response, "page", 9);
        JSON_SetInt(response, "type", 4);
        JSON_SetInt(response, "fraction_control_player_new_reprimand", 0);
        return 1;
    }

    if(target_player != INVALID_PLAYER_ID) SetPlayerData(target_player, P_OWARN, new_warn);

    new query[120];
    format(query, sizeof query, "UPDATE accounts SET owarn=%d WHERE id=%d LIMIT 1", new_warn, account_id);
    mysql_query(mysql, query, false);

    JSON_SetInt(response, "page", 9);
    JSON_SetInt(response, "type", 4);
    JSON_SetInt(response, "fraction_control_player_new_reprimand", new_warn);
    return 1;
}

// -----------------------------------------------------------------------------
// Гараж организации (guiid = ORG_TRANSPORT_GUI_ID). Перенесено без изменений
// из fraction_gui_adapter.pwn — по твоим словам, эта часть уже работала.
// -----------------------------------------------------------------------------
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
    SendPacketToClient(playerid, ORG_TRANSPORT_GUI_ID, response);
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
    SendPacketToClient(playerid, ORG_TRANSPORT_GUI_ID, response);
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
    SendPacketToClient(playerid, ORG_TRANSPORT_GUI_ID, response);
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

    HidePlayerGUI(playerid, FRACTION_GUI_ID);
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

    ShowPlayerGUI(playerid, ORG_TRANSPORT_GUI_ID, response);
    JSON_Cleanup(response);

    printf("[ORG TRANSPORT GUI] open player=%d team=%d rank=%d", playerid, GetPlayerTeamEx(playerid), GetPlayerJob(playerid));
    return OrgTransportGuiSendList(playerid);
}


// =============================================================================
// FractionGuiHandlePacket — вызывается из case 46 в switch(guiid) внутри
// IPacket:252 (ipacket.inc), одной строкой, так же как OrgTransportGuiHandlePacket
// вызывается из case ORG_TRANSPORT_GUI_ID:
//
//     case 46:
//     {
//         FractionGuiHandlePacket(playerid, JSONObject);
//     }
//
// Кнопки 1,2,3,5,6,8,9,14 логически не менялись — перенёс as-is (они и так
// работали / являются заглушками без источника данных в БД); реальными стали
// 1/10 (объединены), 4, 11, 12, 13.
// =============================================================================
stock FractionGuiHandlePacket(playerid, Node:json)
{
    new current_page, button_id;

    JSON_GetInt(json, "page", current_page);
    JSON_GetInt(json, "button", button_id);

    new Node:response = JSON_Object();

    switch(button_id)
    {
        case 1, 10:
        {
            FracBuildMainResponse(playerid, response);
        }
        case 2:
        {
            JSON_SetInt(response, "page", 7);
            JSON_SetInt(response, "type", 1);
            // Раньше тут был донат-баланс как заглушка — теперь реальный
            // баланс токенов (P_FAMILY_TOKEN), как и везде на этой странице.
            JSON_SetInt(response, "fraction_add_tokens_bc_value", GetPlayerData(playerid, P_FAMILY_TOKEN));
        }
        case 3:
        {
            JSON_SetInt(response, "page", 8);
            // Реальный баланс: P_FAMILY_TOKEN (accounts.fam_token) — уже
            // подгружается при заходе, просто раньше нигде не выводился.
            JSON_SetInt(response, "fraction_tokens", GetPlayerData(playerid, P_FAMILY_TOKEN));
            JSON_SetInt(response, "fraction_add_tokens_price", 50); // TODO: курс доната->токены нигде не нашёл

            new Node:item1 = JSON_Object();
            JSON_SetInt(item1, "unique_id", 1);
            JSON_SetString(item1, "name", "Акс");
            JSON_SetInt(item1, "price", 100);

            new Node:item2 = JSON_Object();
            JSON_SetInt(item2, "unique_id", 2);
            JSON_SetString(item2, "name", "Шапка меллисса");
            JSON_SetInt(item2, "price", 200);

            new Node:shop_items = JSON_Array(item1, item2);
            JSON_SetArray(response, "shop_items", shop_items);

            JSON_Cleanup(item1);
            JSON_Cleanup(item2);
            JSON_Cleanup(shop_items);
        }
        case 4:
        {
            FracSendStaffList(playerid, response);
        }
        case 5:
        {
            JSON_SetInt(response, "page", 4);
            // TODO: нет таблицы прочтения документов — заглушка как в оригинале.
            new Node:d1 = JSON_Int(1);
            new Node:d2 = JSON_Int(0);
            new Node:doc_buttons = JSON_Array(d1, d2);
            JSON_SetArray(response, "fraction_documents_button_acquainted", doc_buttons);
            JSON_Cleanup(d1); JSON_Cleanup(d2);
            JSON_Cleanup(doc_buttons);
        }
        case 6:
        {
            JSON_SetInt(response, "page", 2);
            new Node:reward1 = JSON_Int(10000);
            new Node:reward2 = JSON_Int(500);
            new Node:reward_array = JSON_Array(reward1, reward2);
            JSON_SetArray(response, "fraction_new_rank_reward", reward_array);
            JSON_SetInt(response, "new_rank", 3);
            JSON_Cleanup(reward1); JSON_Cleanup(reward2);
            JSON_Cleanup(reward_array);
        }
        case 7:
        {
            JSON_SetInt(response, "page", 3);
            JSON_SetInt(response, "fraction_task_rank", GetPlayerData(playerid, P_JOB));
        }
        case 8:
        {
            SendClientMessage(playerid, -1, "Тест кнопка кейс 8");
        }
        case 9:
        {
            // TODO: нет банка вопросов теста — заглушка как в оригинале.
            JSON_SetInt(response, "page", 6);
            JSON_SetInt(response, "fraction_testing_result", 8);
            JSON_SetInt(response, "fraction_testing_total", 10);
            JSON_SetInt(response, "fraction_testing_questions_total", 10);
            JSON_SetString(response, "result_message", "Вы успешно прошли тестирование");
        }
        case 11:
        {
            FracSendPlayerInfo(playerid, response, json);
        }
        case 12:
        {
            FracChangeRank(playerid, response, json);
        }
        case 13:
        {
            FracChangeReprimand(playerid, response, json);
        }
        case 14:
        {
            // TODO: нет банка вопросов теста — заглушка как в оригинале.
            if(current_page == 5)
            {
                new chosen_answer;
                JSON_GetInt(json, "fraction_testing_chosen_answer", chosen_answer);

                new correct_answers = 1;
                new total_questions = 2;

                JSON_SetInt(response, "page", 6);
                JSON_SetInt(response, "fraction_testing_result", correct_answers);
                JSON_SetInt(response, "fraction_testing_total", total_questions);
                JSON_SetInt(response, "fraction_testing_questions_total", total_questions);

                JSON_SetString(response, "result_message",
                    (correct_answers >= total_questions / 2)
                        ? "Тест успешно пройден!"
                        : "Тест не пройден. Попробуйте еще раз.");
            }
        }
        default:
        {
            JSON_SetInt(response, "page", 1);
            JSON_SetInt(response, "fraction_id", 1);
        }
    }

    JSON_SetInt(response, "fraction_tokens", GetPlayerData(playerid, P_FAMILY_TOKEN));
    JSON_SetInt(response, "fraction_add_tokens_price", 50); // TODO: курс доната->токены нигде не нашёл

    SendPacketToClient(playerid, FRACTION_GUI_ID, response);
    JSON_Cleanup(response);
    return 1;
}

// -----------------------------------------------------------------------------
// /fraction — так же переиспользует FracBuildMainResponse, чтобы не держать
// вычисление rank_status/rank_progress в двух местах с риском рассинхрона.
// -----------------------------------------------------------------------------
CMD:fraction(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) == TEAM_NONE)
    {
        SendClientMessage(playerid, -1, "Ошибка: вы не состоите ни в одной фракции.");
        return 1;
    }

    new Node:json = JSON_Object();
    FracBuildMainResponse(playerid, json);
    JSON_SetInt(json, "fraction_tokens", GetPlayerData(playerid, P_FAMILY_TOKEN));
    JSON_SetInt(json, "fraction_add_tokens_price", 50); // TODO: курс доната->токены нигде не нашёл

    ShowPlayerGUI(playerid, 46, json);
    JSON_Cleanup(json);
    return 1;
}

// Команда для гаража организации — сам ShowOrgTransportGui уже в перенесённой
// секции выше, тут только вешаем её на команду.
CMD:orgtransport(playerid, params[])
{
    return ShowOrgTransportGui(playerid);
}
