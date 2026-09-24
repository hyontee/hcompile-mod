/*
    BLACK BONUS — безопасная административная очистка БД.
    Команда: /delete (13 уровень администрации)
*/

#if defined _admin_delete_included
    #endinput
#endif
#define _admin_delete_included

#define DIALOG_ADMIN_DELETE_MENU       (29890)
#define DIALOG_ADMIN_DELETE_CONFIRM    (29891)

#define ADMIN_DELETE_GARAGES           (1)
#define ADMIN_DELETE_HOUSES            (2)
#define ADMIN_DELETE_VEHICLES_REWARDS  (3)
#define ADMIN_DELETE_FAMILIES          (4)
#define ADMIN_DELETE_ACCOUNTS_ALL       (5)
#define ADMIN_DELETE_LOGS               (6)

new bool:g_admin_delete_restart_pending;

stock AdminDelete_RunQuery(query[], operation[])
{
    mysql_query(mysql, query, false);
    new error_code = mysql_errno();
    if(error_code)
    {
        printf("[ADMIN DELETE][SQL ERROR] operation=%s errno=%d query=%s", operation, error_code, query);
        return 0;
    }
    printf("[ADMIN DELETE][SQL OK] operation=%s", operation);
    return 1;
}

stock AdminDelete_TableExists(const table_name[])
{
    new query[128];
    format(query, sizeof query, "SHOW TABLES LIKE '%s'", table_name);
    new Cache:result = mysql_query(mysql, query, true);
    new error_code = mysql_errno();
    if(error_code)
    {
        cache_delete(result);
        printf("[ADMIN DELETE][TABLE CHECK ERROR] table=%s errno=%d", table_name, error_code);
        return 0;
    }
    new exists = cache_num_rows() > 0;
    cache_delete(result);
    return exists;
}

stock AdminDelete_ClearTable(const table_name[])
{
    if(!AdminDelete_TableExists(table_name))
    {
        printf("[ADMIN DELETE] optional table not found: %s", table_name);
        return 1;
    }

    new query[160], operation[96];
    format(query, sizeof query, "DELETE FROM `%s`", table_name);
    format(operation, sizeof operation, "clear table %s", table_name);
    if(!AdminDelete_RunQuery(query, operation)) return 0;

    format(query, sizeof query, "ALTER TABLE `%s` AUTO_INCREMENT=1", table_name);
    mysql_query(mysql, query, false);
    return 1;
}

stock AdminDelete_ResetGarageOwners()
{
    new ok = 1;
    ok &= AdminDelete_RunQuery(
        "UPDATE `garages` SET `owner_id`=0,`lock`=0",
        "reset garage owners"
    );
    ok &= AdminDelete_RunQuery(
        "UPDATE `accounts` SET `garage`=-1",
        "reset accounts garage"
    );
    if(AdminDelete_TableExists("familynew"))
    {
        ok &= AdminDelete_RunQuery(
            "UPDATE `familynew` SET `house`=-1 WHERE `house`<=-1000000",
            "reset family garage spawn"
        );
    }
    return ok;
}

stock AdminDelete_ResetHouseOwners()
{
    new ok = 1;
    if(AdminDelete_TableExists("houses"))
    {
        ok &= AdminDelete_RunQuery(
            "UPDATE `houses` SET `owner_id`=0,`improvements`=0,`rent_time`=0,`lock`=0,`eviction`=0,`store_x`=0,`store_y`=0,`store_z`=0,`store_metall`=0,`store_drugs`=0,`store_weapon`=0,`store_ammo`=0,`store_skin`=0",
            "reset houses owners"
        );
    }
    if(AdminDelete_TableExists("housesnew"))
    {
        ok &= AdminDelete_RunQuery(
            "UPDATE `housesnew` SET `accounts_id`=0,`owner_name`=''",
            "reset housesnew owners"
        );
    }
    if(AdminDelete_TableExists("hotels"))
    {
        ok &= AdminDelete_RunQuery(
            "UPDATE `hotels` SET `owner_id`=0,`rent_time`=0,`status`=0",
            "reset hotel rooms"
        );
    }
    ok &= AdminDelete_ClearTable("bought_houses");
    ok &= AdminDelete_ClearTable("houses_renters");
    ok &= AdminDelete_RunQuery(
        "UPDATE `accounts` SET `house_type`=-1,`house_room`=-1,`house`=-1",
        "reset accounts houses"
    );
    if(AdminDelete_TableExists("familynew"))
    {
        ok &= AdminDelete_RunQuery(
            "UPDATE `familynew` SET `house`=-1 WHERE `house`>-1000000 AND `house`<>-1",
            "reset family house spawn"
        );
    }
    return ok;
}

stock AdminDelete_ClearVehiclesRewards()
{
    new ok = 1;
    ok &= AdminDelete_ClearTable("ownable_cars");
    ok &= AdminDelete_ClearTable("rewards");
    ok &= AdminDelete_ClearTable("player_case_bonus_rewards");
    ok &= AdminDelete_ClearTable("car_obmen");
    ok &= AdminDelete_ClearTable("trunks");
    ok &= AdminDelete_ClearTable("trunkcar");
    ok &= AdminDelete_ClearTable("vehicle_store_components");
    ok &= AdminDelete_ClearTable("roulette_prize");
    ok &= AdminDelete_ClearTable("auction");
    ok &= AdminDelete_RunQuery(
        "UPDATE `accounts` SET `case_rewards`='',`case_bonus_rewards`=''",
        "reset account rewards"
    );
    return ok;
}

stock AdminDelete_ClearFamilies()
{
    new ok = 1;
    ok &= AdminDelete_ClearTable("family_cars");
    ok &= AdminDelete_ClearTable("family_log");
    ok &= AdminDelete_ClearTable("family_ad");
    ok &= AdminDelete_ClearTable("family_storage_items");
    ok &= AdminDelete_ClearTable("familyblack");
    ok &= AdminDelete_ClearTable("familynew");
    ok &= AdminDelete_RunQuery(
        "UPDATE `accounts` SET `family_id`=-1,`family_rang`=1,`family_mute`=0,`family_vig`=0,`family_access`='0,0,0,0,0,0,0'",
        "reset account families"
    );
    return ok;
}

stock AdminDelete_ClearLogs()
{
    new ok = 1;
    ok &= AdminDelete_ClearTable("action_log");
    ok &= AdminDelete_ClearTable("money_log");
    ok &= AdminDelete_ClearTable("donate_log");
    ok &= AdminDelete_ClearTable("aclogs");
    ok &= AdminDelete_ClearTable("bank_accounts_log");
    ok &= AdminDelete_ClearTable("blackpass_logs");
    return ok;
}

stock AdminDelete_ClearAccountLinkedTables()
{
    new ok = 1;
    ok &= AdminDelete_ClearTable("accessories_players");
    ok &= AdminDelete_ClearTable("accessory_inventory");
    ok &= AdminDelete_ClearTable("inventory");
    ok &= AdminDelete_ClearTable("inventory_accessories");
    ok &= AdminDelete_ClearTable("inventory_plates");
    ok &= AdminDelete_ClearTable("inventory_skins");
    ok &= AdminDelete_ClearTable("player_skins");
    ok &= AdminDelete_ClearTable("bank_accounts");
    ok &= AdminDelete_ClearTable("bank_accounts_log");
    ok &= AdminDelete_ClearTable("phone_books");
    ok &= AdminDelete_ClearTable("change_names");
    ok &= AdminDelete_ClearTable("promocode_activations");
    ok &= AdminDelete_ClearTable("ytpromocode_activations");
    ok &= AdminDelete_ClearTable("blackpass_players");
    ok &= AdminDelete_ClearTable("tickets");
    ok &= AdminDelete_ClearTable("quick_message");
    ok &= AdminDelete_ClearTable("payments");
    return ok;
}

stock AdminDelete_ClearAllAccounts()
{
    new ok = 1;

    // Сначала отвязываем статическое имущество, чтобы после удаления аккаунтов
    // в гаражах, домах, бизнесах и АЗС не оставались старые владельцы.
    ok &= AdminDelete_ResetGarageOwners();
    ok &= AdminDelete_ResetHouseOwners();
    ok &= AdminDelete_ClearVehiclesRewards();
    ok &= AdminDelete_ClearFamilies();
    ok &= AdminDelete_ClearAccountLinkedTables();

    if(AdminDelete_TableExists("business"))
        ok &= AdminDelete_RunQuery("UPDATE `business` SET `owner_id`=0", "reset businesses owners");
    if(AdminDelete_TableExists("fuel_stations"))
        ok &= AdminDelete_RunQuery("UPDATE `fuel_stations` SET `owner_id`=0", "reset fuel stations owners");
    if(AdminDelete_TableExists("hotels"))
        ok &= AdminDelete_RunQuery("UPDATE `hotels` SET `owner_id`=0,`rent_time`=0,`status`=0", "reset hotels owners");

    ok &= AdminDelete_ClearTable("accounts");
    return ok;
}

stock AdminDelete_GetActionName(action, output[], size = sizeof output)
{
    switch(action)
    {
        case ADMIN_DELETE_GARAGES: format(output, size, "сброс владельцев гаражей");
        case ADMIN_DELETE_HOUSES: format(output, size, "сброс владельцев домов");
        case ADMIN_DELETE_VEHICLES_REWARDS: format(output, size, "удаление машин и наград");
        case ADMIN_DELETE_FAMILIES: format(output, size, "удаление семей");
        case ADMIN_DELETE_ACCOUNTS_ALL: format(output, size, "ПОЛНОЕ удаление аккаунтов и имущества");
        case ADMIN_DELETE_LOGS: format(output, size, "очистка логов");
        default: format(output, size, "неизвестное действие");
    }
    return 1;
}

stock AdminDelete_ShowMenu(playerid)
{
    if(GetPlayerAdminEx(playerid) < 13)
        return ShowNotification(playerid, 2, "Команда доступна только администрации 13 уровня", 3, "", "");

    new list[1024];
    format(list, sizeof list,
        "Сбросить владельцев гаражей (гаражи останутся)\n"\
        "Сбросить владельцев домов (дома останутся)\n"\
        "Удалить все машины и награды игроков\n"\
        "Удалить все семьи\n"\
        "{FF4444}Удалить ВСЕ аккаунты и всё имущество\n"\
        "Очистить административные и денежные логи"
    );

    ShowPlayerDialog(playerid, DIALOG_ADMIN_DELETE_MENU, DIALOG_STYLE_LIST,
        "{FF4444}DELETE — очистка базы данных", list, "Выбрать", "Отмена");
    return 1;
}

stock AdminDelete_ShowConfirmation(playerid, action)
{
    new action_name[96], body[640];
    AdminDelete_GetActionName(action, action_name, sizeof action_name);
    SetPVarInt(playerid, "admin_delete_action", action);

    format(body, sizeof body,
        "{FF4444}ВНИМАНИЕ! Действие необратимо.\n\n"\
        "{FFFFFF}Вы выбрали: {FFCC00}%s\n"\
        "{FFFFFF}После выполнения сервер автоматически перезагрузит мод.\n\n"\
        "{FF4444}Для подтверждения введите точное слово: {FFFFFF}DELETE",
        action_name
    );

    ShowPlayerDialog(playerid, DIALOG_ADMIN_DELETE_CONFIRM, DIALOG_STYLE_INPUT,
        "{FF4444}Подтверждение очистки", body, "Удалить", "Отмена");
    return 1;
}

forward AdminDelete_RestartGameMode();
public AdminDelete_RestartGameMode()
{
    SendRconCommand("gmx");
    return 1;
}

stock AdminDelete_ScheduleRestart()
{
    if(g_admin_delete_restart_pending) return 1;
    g_admin_delete_restart_pending = true;
    SendClientMessageToAll(0xFF4444FF, "[DELETE] База данных очищена. Перезапуск игрового мода через 3 секунды...");
    SetTimer("AdminDelete_RestartGameMode", 3000, false);
    return 1;
}

stock AdminDelete_Execute(playerid, action)
{
    if(GetPlayerAdminEx(playerid) < 13) return 0;

    new action_name[96], log_message[220];
    AdminDelete_GetActionName(action, action_name, sizeof action_name);
    format(log_message, sizeof log_message,
        "[A] %s[%d] выполнил DELETE: %s",
        GetPlayerNameEx(playerid), playerid, action_name);

    // Пишем лог до удаления accounts, чтобы запись администратора не потерялась.
    printf("[ADMIN DELETE] %s", log_message);
    SendMessageToAdmins(log_message, 0xFF4444FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log_message);

    new success = 0;
    switch(action)
    {
        case ADMIN_DELETE_GARAGES: success = AdminDelete_ResetGarageOwners();
        case ADMIN_DELETE_HOUSES: success = AdminDelete_ResetHouseOwners();
        case ADMIN_DELETE_VEHICLES_REWARDS: success = AdminDelete_ClearVehiclesRewards();
        case ADMIN_DELETE_FAMILIES: success = AdminDelete_ClearFamilies();
        case ADMIN_DELETE_ACCOUNTS_ALL: success = AdminDelete_ClearAllAccounts();
        case ADMIN_DELETE_LOGS: success = AdminDelete_ClearLogs();
    }

    DeletePVar(playerid, "admin_delete_action");

    if(!success)
    {
        SendClientMessage(playerid, 0xFF4444FF, "Очистка выполнена не полностью. Проверьте [ADMIN DELETE][SQL ERROR] в server_log.");
        return 1;
    }

    SendClientMessage(playerid, 0x66CC33FF, "Очистка базы данных успешно выполнена.");
    return AdminDelete_ScheduleRestart();
}

stock AdminDelete_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ADMIN_DELETE_MENU)
    {
        if(!response) return 1;
        if(GetPlayerAdminEx(playerid) < 13) return 1;

        new action = listitem + 1;
        if(action < ADMIN_DELETE_GARAGES || action > ADMIN_DELETE_LOGS) return 1;
        return AdminDelete_ShowConfirmation(playerid, action);
    }

    if(dialogid == DIALOG_ADMIN_DELETE_CONFIRM)
    {
        if(!response)
        {
            DeletePVar(playerid, "admin_delete_action");
            return 1;
        }
        if(GetPlayerAdminEx(playerid) < 13) return 1;

        new action = GetPVarInt(playerid, "admin_delete_action");
        if(strcmp(inputtext, "DELETE", false) != 0)
        {
            SendClientMessage(playerid, 0xFF4444FF, "Подтверждение неверное. Нужно ввести точное слово DELETE.");
            return AdminDelete_ShowConfirmation(playerid, action);
        }
        return AdminDelete_Execute(playerid, action);
    }
    return 0;
}

CMD:delete(playerid, params[])
{
    #pragma unused params
    return AdminDelete_ShowMenu(playerid);
}
