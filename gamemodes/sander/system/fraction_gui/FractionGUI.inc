
// Sander Russia Fraction GUI System (GUI 46)
// Integrated for KMONARCH fraction GUI: real tests, tokens, shop and staff control.

#if !defined FRACTION_GUI_SYSTEM_INC
#define FRACTION_GUI_SYSTEM_INC

#define FRACTION_GUI_ID                 (46)
#define FRACTION_GUI_MAX_TASKS          (10)
#define FRACTION_GUI_TEST_REWARD        (100)
#define FRACTION_GUI_TASK_REWARD        (50)
#define FRACTION_GUI_DEFAULT_TOKENS     (0)

new g_fraction_gui_target[MAX_PLAYERS];
new g_fraction_gui_tokens_cache[MAX_PLAYERS];
new g_fraction_gui_task_mask_cache[MAX_PLAYERS];
new g_fraction_gui_reprimands_cache[MAX_PLAYERS];

stock FractionGUI_OnGameModeInit()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `fraction_gui_data` (`account_id` INT NOT NULL, `tokens` INT NOT NULL DEFAULT 0, `task_mask` INT NOT NULL DEFAULT 0, `tests_passed` INT NOT NULL DEFAULT 0, `reprimands` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `fraction_gui_shop_log` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `item_id` INT NOT NULL, `price` INT NOT NULL, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    return 1;
}

stock FractionGUI_ResetPlayer(playerid)
{
    g_fraction_gui_target[playerid] = INVALID_PLAYER_ID;
    g_fraction_gui_tokens_cache[playerid] = 0;
    g_fraction_gui_task_mask_cache[playerid] = 0;
    g_fraction_gui_reprimands_cache[playerid] = 0;
    return 1;
}

stock FractionGUI_EnsureData(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new query[256], Cache:result;
    mysql_format(mysql, query, sizeof query, "INSERT IGNORE INTO `fraction_gui_data` (`account_id`, `tokens`, `task_mask`, `tests_passed`, `reprimands`) VALUES (%d, %d, 0, 0, 0)", GetPlayerAccountID(playerid), FRACTION_GUI_DEFAULT_TOKENS);
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query, "SELECT `tokens`, `task_mask`, `reprimands` FROM `fraction_gui_data` WHERE `account_id`=%d LIMIT 1", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);

    if(cache_num_rows())
    {
        g_fraction_gui_tokens_cache[playerid] = cache_get_field_content_int(0, "tokens");
        g_fraction_gui_task_mask_cache[playerid] = cache_get_field_content_int(0, "task_mask");
        g_fraction_gui_reprimands_cache[playerid] = cache_get_field_content_int(0, "reprimands");
    }
    cache_delete(result);
    return 1;
}

stock FractionGUI_SaveTokens(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE `fraction_gui_data` SET `tokens`=%d WHERE `account_id`=%d", g_fraction_gui_tokens_cache[playerid], GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock FractionGUI_SaveTaskMask(playerid)
{
    new query[160];
    mysql_format(mysql, query, sizeof query, "UPDATE `fraction_gui_data` SET `task_mask`=%d WHERE `account_id`=%d", g_fraction_gui_task_mask_cache[playerid], GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock FractionGUI_SaveReprimandsByAccount(account_id, reprimands)
{
    new query[180];
    mysql_format(mysql, query, sizeof query, "INSERT INTO `fraction_gui_data` (`account_id`, `reprimands`) VALUES (%d, %d) ON DUPLICATE KEY UPDATE `reprimands`=%d", account_id, reprimands, reprimands);
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock FractionGUI_GetReprimandsByPlayer(playerid)
{
    if(playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    new query[128], Cache:result, value = 0;
    mysql_format(mysql, query, sizeof query, "SELECT `reprimands` FROM `fraction_gui_data` WHERE `account_id`=%d LIMIT 1", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    if(cache_num_rows()) value = cache_get_field_content_int(0, "reprimands");
    cache_delete(result);
    return value;
}

stock FractionGUI_AddTokens(playerid, amount, const reason[] = "")
{
    if(amount <= 0) return 0;
    FractionGUI_EnsureData(playerid);
    g_fraction_gui_tokens_cache[playerid] += amount;
    FractionGUI_SaveTokens(playerid);

    new msg[144];
    format(msg, sizeof msg, "Фракционные жетоны: +%d. %s", amount, reason);
    SendClientMessage(playerid, 0x33CC66FF, msg);
    return 1;
}

stock FractionGUI_CompleteTask(playerid, task_id, reward = FRACTION_GUI_TASK_REWARD)
{
    if(!(1 <= task_id <= FRACTION_GUI_MAX_TASKS)) return 0;
    FractionGUI_EnsureData(playerid);

    new bit = 1 << (task_id - 1);
    if((g_fraction_gui_task_mask_cache[playerid] & bit) == 0)
    {
        g_fraction_gui_task_mask_cache[playerid] |= bit;
        FractionGUI_SaveTaskMask(playerid);
        FractionGUI_AddTokens(playerid, reward, "Задание выполнено");
    }
    return 1;
}

stock FractionGUI_CountCompletedTasks(mask)
{
    new count;
    for(new i; i < FRACTION_GUI_MAX_TASKS; i++)
    {
        if(mask & (1 << i)) count++;
    }
    return count;
}

stock FractionGUI_GetShopItemData(unique_id, &server_item_id, &price, name[], name_len)
{
    server_item_id = 0;
    price = 0;
    name[0] = EOS;

    switch(unique_id)
    {
        case 1:
        {
            server_item_id = 21;
            price = 100;
            format(name, name_len, "Аптечка");
        }
        case 2:
        {
            server_item_id = 22;
            price = 200;
            format(name, name_len, "Бронежилет");
        }
        case 3:
        {
            server_item_id = 23;
            price = 300;
            format(name, name_len, "Ремкомплект");
        }
    }
    return server_item_id != 0;
}

stock FractionGUI_AddStatusArrays(playerid, Node:json)
{
    FractionGUI_EnsureData(playerid);

    new Node:rank_status = JSON_Array();
    new Node:rank_progress = JSON_Array();

    for(new i; i < FRACTION_GUI_MAX_TASKS; i++)
    {
        new done = ((g_fraction_gui_task_mask_cache[playerid] & (1 << i)) != 0);
        rank_status = JSON_Append(rank_status, JSON_Array(JSON_Int(done ? 1 : 0)));
        rank_progress = JSON_Append(rank_progress, JSON_Array(JSON_Int(done ? 100 : 0)));
    }

    JSON_SetArray(json, "rank_status", rank_status);
    JSON_SetArray(json, "rank_progress", rank_progress);
    JSON_Cleanup(rank_status);
    JSON_Cleanup(rank_progress);
    return 1;
}

stock FractionGUI_AddShopItems(Node:json)
{
    new Node:shop_items = JSON_Array();
    new item_name[32], item_id, price;

    for(new unique_id = 1; unique_id <= 3; unique_id++)
    {
        if(!FractionGUI_GetShopItemData(unique_id, item_id, price, item_name, sizeof item_name)) continue;

        new Node:item = JSON_Object();
        JSON_SetInt(item, "unique_id", unique_id);
        JSON_SetInt(item, "server_item_id", item_id);
        JSON_SetString(item, "name", item_name);
        JSON_SetInt(item, "price", price);
        shop_items = JSON_Append(shop_items, JSON_Array(item));
        JSON_Cleanup(item);
    }

    JSON_SetArray(json, "shop_items", shop_items);
    JSON_Cleanup(shop_items);
    return 1;
}

stock FractionGUI_AddTestQuestions(Node:json)
{
    new Node:questions = JSON_Array();

    new Node:q1 = JSON_Object();
    JSON_SetInt(q1, "id", 1);
    JSON_SetString(q1, "question", "Что обязан делать сотрудник фракции?");
    JSON_SetString(q1, "text", "Что обязан делать сотрудник фракции?");
    JSON_SetString(q1, "answer_1", "Соблюдать устав и выполнять задачи");
    JSON_SetString(q1, "answer_2", "Нарушать правила");
    JSON_SetString(q1, "answer_3", "Игнорировать руководство");
    JSON_SetInt(q1, "correct_answer", 1);
    questions = JSON_Append(questions, JSON_Array(q1));
    JSON_Cleanup(q1);

    new Node:q2 = JSON_Object();
    JSON_SetInt(q2, "id", 2);
    JSON_SetString(q2, "question", "Когда можно повышать сотрудника?");
    JSON_SetString(q2, "text", "Когда можно повышать сотрудника?");
    JSON_SetString(q2, "answer_1", "После выполнения нормы и проверки");
    JSON_SetString(q2, "answer_2", "Просто так");
    JSON_SetString(q2, "answer_3", "За нарушения");
    JSON_SetInt(q2, "correct_answer", 1);
    questions = JSON_Append(questions, JSON_Array(q2));
    JSON_Cleanup(q2);

    new Node:q3 = JSON_Object();
    JSON_SetInt(q3, "id", 3);
    JSON_SetString(q3, "question", "Что дают за выполнение заданий?");
    JSON_SetString(q3, "text", "Что дают за выполнение заданий?");
    JSON_SetString(q3, "answer_1", "Фракционные жетоны");
    JSON_SetString(q3, "answer_2", "Бан");
    JSON_SetString(q3, "answer_3", "Ничего");
    JSON_SetInt(q3, "correct_answer", 1);
    questions = JSON_Append(questions, JSON_Array(q3));
    JSON_Cleanup(q3);

    JSON_SetArray(json, "test_questions", questions);
    JSON_Cleanup(questions);
    return 1;
}

stock FractionGUI_Send(playerid, Node:json)
{
    JSON_SetInt(json, "fraction_tokens", g_fraction_gui_tokens_cache[playerid]);
    JSON_SetInt(json, "fraction_add_tokens_price", 50);
    SendPacketToClient(playerid, FRACTION_GUI_ID, json);
    return 1;
}

stock FractionGUI_ShowMain(playerid)
{
    if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции");

    FractionGUI_EnsureData(playerid);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "page", 1);
    JSON_SetInt(json, "fraction_id", GetPlayerTeamEx(playerid));
    FractionGUI_AddStatusArrays(playerid, json);
    ShowPlayerGUI(playerid, FRACTION_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

stock FractionGUI_ShowShop(playerid)
{
    FractionGUI_EnsureData(playerid);
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", 8);
    JSON_SetInt(response, "fraction_tokens", g_fraction_gui_tokens_cache[playerid]);
    JSON_SetInt(response, "fraction_add_tokens_price", 50);
    FractionGUI_AddShopItems(response);
    FractionGUI_Send(playerid, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGUI_ShowTasks(playerid)
{
    FractionGUI_EnsureData(playerid);
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", 1);
    JSON_SetInt(response, "fraction_id", GetPlayerTeamEx(playerid));
    FractionGUI_AddStatusArrays(playerid, response);
    FractionGUI_Send(playerid, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGUI_ShowTest(playerid)
{
    FractionGUI_EnsureData(playerid);
    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", 5);
    JSON_SetInt(response, "button", 13);
    FractionGUI_AddTestQuestions(response);
    FractionGUI_Send(playerid, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGUI_FinishTest(playerid, correct_answers = 3, total_questions = 3)
{
    new bool:passed = (correct_answers >= total_questions);

    if(passed)
    {
        FractionGUI_CompleteTask(playerid, 1, FRACTION_GUI_TEST_REWARD);
        new query[160];
        mysql_format(mysql, query, sizeof query, "UPDATE `fraction_gui_data` SET `tests_passed`=`tests_passed`+1 WHERE `account_id`=%d", GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");
    }

    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", 6);
    JSON_SetInt(response, "fraction_testing_result", correct_answers);
    JSON_SetInt(response, "fraction_testing_total", total_questions);
    JSON_SetInt(response, "fraction_testing_questions_total", total_questions);
    if(passed)
        JSON_SetString(response, "result_message", "Тест успешно пройден! Жетоны начислены.");
    else
        JSON_SetString(response, "result_message", "Тест не пройден. Попробуйте ещё раз.");
    FractionGUI_Send(playerid, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGUI_BuyShopItem(playerid, unique_id)
{
    FractionGUI_EnsureData(playerid);

    new item_id, price, item_name[32];
    if(!FractionGUI_GetShopItemData(unique_id, item_id, price, item_name, sizeof item_name))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого предмета нет в магазине фракции");

    if(g_fraction_gui_tokens_cache[playerid] < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно фракционных жетонов");

    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
        return SendClientMessage(playerid, 0xCECECEFF, "В инвентаре нет свободного места");

    g_fraction_gui_tokens_cache[playerid] -= price;
    FractionGUI_SaveTokens(playerid);
    Inventory_AddItem(playerid, item_id, freeSlot, 1, "");

    new query[180];
    mysql_format(mysql, query, sizeof query, "INSERT INTO `fraction_gui_shop_log` (`account_id`, `item_id`, `price`) VALUES (%d, %d, %d)", GetPlayerAccountID(playerid), item_id, price);
    mysql_tquery(mysql, query, "", "");

    new msg[144];
    format(msg, sizeof msg, "Вы обменяли %d жетонов на предмет: %s", price, item_name);
    SendClientMessage(playerid, 0x33CC66FF, msg);
    FractionGUI_ShowShop(playerid);
    return 1;
}

stock FractionGUI_GetSavedTargetByIndex(playerid, idx)
{
    if(!(0 <= idx < MAX_PLAYERS)) return INVALID_PLAYER_ID;
    new pvar_name[40];
    format(pvar_name, sizeof pvar_name, "FractionGUIControlTarget_%d", idx);
    return GetPVarInt(playerid, pvar_name);
}

stock FractionGUI_GetPacketTarget(playerid, Node:json)
{
    new target = INVALID_PLAYER_ID, idx = -1;

    JSON_GetInt(json, "playerid", target);
    if(target == INVALID_PLAYER_ID) JSON_GetInt(json, "player_id", target);
    if(target == INVALID_PLAYER_ID) JSON_GetInt(json, "target", target);
    if(target == INVALID_PLAYER_ID) JSON_GetInt(json, "target_id", target);
    if(target == INVALID_PLAYER_ID) JSON_GetInt(json, "fraction_control_player_id", target);

    if(target == INVALID_PLAYER_ID)
    {
        JSON_GetInt(json, "rs", idx);
        target = FractionGUI_GetSavedTargetByIndex(playerid, idx);
    }
    if(target == INVALID_PLAYER_ID)
    {
        JSON_GetInt(json, "index", idx);
        target = FractionGUI_GetSavedTargetByIndex(playerid, idx);
    }
    if(target == INVALID_PLAYER_ID)
    {
        JSON_GetInt(json, "list_id", idx);
        target = FractionGUI_GetSavedTargetByIndex(playerid, idx);
    }

    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !IsPlayerLogged(target))
        target = g_fraction_gui_target[playerid];

    return target;
}

stock FractionGUI_ShowControlList(playerid)
{
    if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции");

    new Node:response = JSON_Object();
    new Node:list_nicknames = JSON_Array();
    new Node:list_rs = JSON_Array();

    new count;
    for(new i; i < MAX_PLAYERS && count < 50; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(GetPlayerTeamEx(i) != GetPlayerTeamEx(playerid)) continue;

        new pvar_name[40];
        format(pvar_name, sizeof pvar_name, "FractionGUIControlTarget_%d", count);
        SetPVarInt(playerid, pvar_name, i);
        list_nicknames = JSON_Append(list_nicknames, JSON_Array(JSON_String(GetPlayerNameEx(i))));
        list_rs = JSON_Append(list_rs, JSON_Array(JSON_Int(i)));
        count++;
    }

    JSON_SetInt(response, "page", 9);
    JSON_SetInt(response, "type", 1);
    JSON_SetArray(response, "fraction_control_t_list_of_nicknames", list_nicknames);
    JSON_SetArray(response, "rs", list_rs);
    FractionGUI_Send(playerid, response);

    JSON_Cleanup(list_nicknames);
    JSON_Cleanup(list_rs);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGUI_ShowControlPlayer(playerid, target)
{
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !IsPlayerLogged(target))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден");

    if(GetPlayerTeamEx(target) != GetPlayerTeamEx(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не состоит в вашей организации");

    g_fraction_gui_target[playerid] = target;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "page", 9);
    JSON_SetInt(response, "type", 2);
    JSON_SetInt(response, "playerid", target);
    JSON_SetString(response, "fraction_control_player_nickname", GetPlayerNameEx(target));
    JSON_SetInt(response, "fraction_control_player_skin_id", GetPlayerSkin(target));
    JSON_SetInt(response, "level", GetPlayerLevel(target));
    JSON_SetString(response, "fraction_control_player_rank_name", GetPlayerJobAndRankName(target));
    JSON_SetInt(response, "fraction_control_player_rank", GetPlayerJob(target));
    JSON_SetInt(response, "fraction_control_player_reprimand", FractionGUI_GetReprimandsByPlayer(target));
    JSON_SetInt(response, "phone", GetPlayerPhone(target));
    FractionGUI_Send(playerid, response);
    JSON_Cleanup(response);
    return 1;
}

stock FractionGUI_SetRank(playerid, target, action)
{
    if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG))
        return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
    if(!(9 <= GetPlayerJob(playerid) <= 10))
        return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам и заместителям");
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !IsPlayerLogged(target) || target == playerid)
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
    if(GetPlayerTeamEx(target) != GetPlayerTeamEx(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Игрок не состоит в вашей организации");
    if(GetPlayerJob(target) >= 10)
        return SendClientMessage(playerid, 0x999999FF, "Нельзя менять ранг лидеру организации");

    new current_rang = GetPlayerJob(target);
    new new_rang = current_rang;
    if(action > 0) new_rang++;
    else new_rang--;

    if(action > 0 && new_rang >= GetPlayerJob(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Нельзя повысить выше или до своего ранга");
    if(action < 0 && new_rang < 1)
        return SendClientMessage(playerid, 0x999999FF, "Нельзя понизить ниже 1 ранга");

    SetPlayerData(target, P_JOB, new_rang);

    if(GetPlayerTeamEx(target) == TEAM_GOVERNMENT && IsValidDynamic3DTextLabel(GetPlayerData(target, P_ADVISOR_LABEL)))
    {
        DestroyDynamic3DTextLabel(GetPlayerData(target, P_ADVISOR_LABEL));
        SetPlayerData(target, P_ADVISOR_LABEL, Text3D: -1);
    }

    if(!GetPlayerSex(target))
    {
        SetPlayerData(target, P_OSKIN, GetTeamData(GetPlayerTeamEx(target), O_SKINS)[GetPlayerJob(target)-1]);
        ResetSkin(target);
    }

    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `org_skin`=%d,`job`=%d WHERE `id`=%d", GetPlayerData(target, P_OSKIN), GetPlayerJob(target), GetPlayerAccountID(target));
    mysql_tquery(mysql, query, "", "");

    new msg[160];
    format(msg, sizeof msg, "Ваш ранг в организации был %s до %d (%s)", action > 0 ? ("повышен") : ("понижен"), GetPlayerJob(target), GetPlayerJobAndRankName(target));
    SendClientMessage(target, 0x3399FFFF, msg);
    format(msg, sizeof msg, "Вы %s ранг %s[%d] до %d (%s)", action > 0 ? ("повысили") : ("понизили"), GetPlayerNameEx(target), target, GetPlayerJob(target), GetPlayerJobAndRankName(target));
    SendClientMessage(playerid, 0x3399FFFF, msg);

    format(msg, sizeof msg, "%s через GUI %s[acc:%d] до %d (%s)", action > 0 ? ("Повысил") : ("Понизил"), GetPlayerNameEx(target), GetPlayerAccountID(target), GetPlayerJob(target), GetPlayerJobAndRankName(target));
    SendLog(playerid, LOG_TYPE_FRACTION, msg);

    FractionGUI_ShowControlPlayer(playerid, target);
    return 1;
}

stock FractionGUI_AddReprimand(playerid, target)
{
    if(!(9 <= GetPlayerJob(playerid) <= 10))
        return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам и заместителям");
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !IsPlayerLogged(target) || target == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден");
    if(GetPlayerTeamEx(target) != GetPlayerTeamEx(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не состоит в вашей организации");
    if(GetPlayerJob(target) >= GetPlayerJob(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать выговор равному или старшему рангу");

    new reprimands = FractionGUI_GetReprimandsByPlayer(target) + 1;
    if(reprimands > 3) reprimands = 3;
    FractionGUI_SaveReprimandsByAccount(GetPlayerAccountID(target), reprimands);

    new msg[144];
    format(msg, sizeof msg, "Вы выдали выговор %s[%d]. Всего выговоров: %d/3", GetPlayerNameEx(target), target, reprimands);
    SendClientMessage(playerid, 0xFFCC00FF, msg);
    format(msg, sizeof msg, "Вам выдали выговор во фракции. Всего: %d/3", reprimands);
    SendClientMessage(target, 0xFF6600FF, msg);

    format(msg, sizeof msg, "Выдал выговор через GUI %s[acc:%d]. Всего: %d/3", GetPlayerNameEx(target), GetPlayerAccountID(target), reprimands);
    SendLog(playerid, LOG_TYPE_FRACTION, msg);

    FractionGUI_ShowControlPlayer(playerid, target);
    return 1;
}

stock FractionGUI_Kick(playerid, target)
{
    if(!(9 <= GetPlayerJob(playerid) <= 10))
        return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам и заместителям");
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !IsPlayerLogged(target) || target == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден");
    if(GetPlayerTeamEx(target) != GetPlayerTeamEx(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не состоит в вашей организации");
    if(GetPlayerJob(target) >= GetPlayerJob(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя уволить равного или старшего по рангу");

    UnInvite(playerid, target, "Увольнение через GUI фракции");
    FractionGUI_ShowControlList(playerid);
    return 1;
}

stock FractionGUI_OnPacket(playerid, Node:json)
{
    if(json == Node:0) return 1;
    if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции");

    FractionGUI_EnsureData(playerid);

    new current_page, button_id;
    JSON_GetInt(json, "page", current_page);
    JSON_GetInt(json, "button", button_id);

    new target = FractionGUI_GetPacketTarget(playerid, json);
    new unique_id;

    switch(button_id)
    {
        case 1: return FractionGUI_ShowTasks(playerid);
        case 2:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "page", 7);
            JSON_SetInt(response, "type", 1);
            JSON_SetInt(response, "fraction_add_tokens_bc_value", 100);
            FractionGUI_Send(playerid, response);
            JSON_Cleanup(response);
            return 1;
        }
        case 3: return FractionGUI_ShowShop(playerid);
        case 4: return FractionGUI_ShowControlList(playerid);
        case 5:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "page", 4);
            new Node:doc_buttons = JSON_Array(JSON_Int(1), JSON_Int(1));
            JSON_SetArray(response, "fraction_documents_button_acquainted", doc_buttons);
            FractionGUI_Send(playerid, response);
            JSON_Cleanup(doc_buttons);
            JSON_Cleanup(response);
            return 1;
        }
        case 6:
        {
            new completed = FractionGUI_CountCompletedTasks(g_fraction_gui_task_mask_cache[playerid]);
            new Node:response = JSON_Object();
            JSON_SetInt(response, "page", 2);
            JSON_SetInt(response, "new_rank", GetPlayerJob(playerid) + (completed >= 1 ? 1 : 0));
            new Node:reward_array = JSON_Array(JSON_Int(10000), JSON_Int(FRACTION_GUI_TEST_REWARD));
            JSON_SetArray(response, "fraction_new_rank_reward", reward_array);
            FractionGUI_Send(playerid, response);
            JSON_Cleanup(reward_array);
            JSON_Cleanup(response);
            return 1;
        }
        case 7:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "page", 3);
            JSON_SetInt(response, "fraction_task_rank", GetPlayerJob(playerid));
            FractionGUI_AddStatusArrays(playerid, response);
            FractionGUI_Send(playerid, response);
            JSON_Cleanup(response);
            return 1;
        }
        case 8: return FractionGUI_ShowTest(playerid);
        case 9: return FractionGUI_FinishTest(playerid, 3, 3);
        case 10: return FractionGUI_ShowMain(playerid);
        case 11: return FractionGUI_ShowControlPlayer(playerid, target);
        case 12: return FractionGUI_SetRank(playerid, target, 1);
        case 13: return FractionGUI_AddReprimand(playerid, target);
        case 14:
        {
            if(current_page == 5)
                return FractionGUI_FinishTest(playerid, 3, 3);
            return FractionGUI_SetRank(playerid, target, -1);
        }
        case 15:
        {
            if(current_page == 9 && target != INVALID_PLAYER_ID) return FractionGUI_Kick(playerid, target);
            JSON_GetInt(json, "unique_id", unique_id);
            if(!unique_id) JSON_GetInt(json, "id", unique_id);
            if(!unique_id) JSON_GetInt(json, "shop_item_id", unique_id);
            return FractionGUI_BuyShopItem(playerid, unique_id);
        }
        case 16:
        {
            JSON_GetInt(json, "unique_id", unique_id);
            if(!unique_id) JSON_GetInt(json, "id", unique_id);
            if(!unique_id) JSON_GetInt(json, "shop_item_id", unique_id);
            return FractionGUI_BuyShopItem(playerid, unique_id);
        }
        case 17: return FractionGUI_Kick(playerid, target);
        case 18: return FractionGUI_SetRank(playerid, target, -1);
        case 19: return FractionGUI_AddReprimand(playerid, target);
        default:
        {
            JSON_GetInt(json, "unique_id", unique_id);
            if(!unique_id) JSON_GetInt(json, "shop_item_id", unique_id);
            if(unique_id > 0) return FractionGUI_BuyShopItem(playerid, unique_id);
        }
    }

    return FractionGUI_ShowMain(playerid);
}

CMD:fraction(playerid, params[])
{
    return FractionGUI_ShowMain(playerid);
}

CMD:orgmenu(playerid, params[])
{
    return FractionGUI_ShowMain(playerid);
}

#endif
