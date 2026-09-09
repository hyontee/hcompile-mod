#define Reward: Reward_
const MAX_REWARD_ITEMS = 12;
enum E_REWARDS_STRUCT
{
    E_TYPE_PRIZE,
    E_COUNT_PRIZE,
    E_ITEM_PRIZE,
    bool:E_TYPE_GIVED,
};
new g_rewards[MAX_PLAYERS][E_REWARDS_STRUCT];
new defaultrewards[E_REWARDS_STRUCT] = {0, 0, 0, false};

new reward_temp_id;
new reward_temp_type;
new reward_temp_item;
new reward_temp_count;
new reward_temp_rows;
new reward_temp_index;
new reward_temp_idx;
new Cache:reward_temp_result;
new reward_temp_msg[128];
new reward_temp_dialog[2048];
new reward_temp_line[128];
new reward_temp_type_name[32];
new reward_temp_item_name[64];
new reward_temp_month[32];
new reward_temp_year;
new reward_temp_month_num;
new reward_temp_day;

stock Reward:ClearCodePlayer( playerid )
{
    g_rewards[playerid] = defaultrewards;
}
new DailyreWards_Time[MAX_PLAYERS];

CMD:a_prize( playerid, p[] )
{
    if(GetPlayerAdminEx(playerid) < 10) return 1;
    else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");
    Reward:ClearCodePlayer(playerid);
    Reward:ShowMainMenu(playerid);
    return 1;
}

stock Reward:ShowMainMenu(playerid)
{
    Reward:GetMonthName(Reward:MonthDaily(), reward_temp_month);
    reward_temp_dialog[0] = EOS;
    format(reward_temp_dialog, sizeof reward_temp_dialog, "{ffc869}Текущий месяц: {FFFFFF}%s\n\n", reward_temp_month);
    strcat(reward_temp_dialog, "{FFFFFF}Создать новую награду\n{FFFFFF}Просмотр всех наград\n{FFFFFF}Удалить награду\n{FFFFFF}Очистить все награды месяца");
    Dialog(playerid, DIALOG_REWARDS_MAIN, DIALOG_STYLE_LIST, "{ffc869}Управление наградами", reward_temp_dialog, "Выбрать", "Закрыть");
    return 1;
}

stock Reward:ShowAllRewards(playerid)
{
    mysql_format(mysql, STRING_GLOBAL, sizeof STRING_GLOBAL, "SELECT * FROM rewards WHERE month=%d ORDER BY id", Reward:MonthDaily());
    reward_temp_result = mysql_query(mysql, STRING_GLOBAL, true);
    reward_temp_rows = cache_num_rows();
    if(!reward_temp_rows)
    {
        cache_delete(reward_temp_result);
        SendClientMessage(playerid, 0xFF6600FF, "В этом месяце нет наград!");
        return Reward:ShowMainMenu(playerid);
    }
    reward_temp_dialog[0] = EOS;
    format(reward_temp_dialog, sizeof reward_temp_dialog, "{ffc869}ID\t{FFFFFF}Тип\t{FFFFFF}Предмет\t{FFFFFF}Кол-во\t{FFFFFF}Гарант.\n");
    for(new i = 0; i < reward_temp_rows; i++)
    {
        reward_temp_id = cache_get_field_content_int(i, "id");
        reward_temp_type = cache_get_field_content_int(i, "type");
        reward_temp_item = cache_get_field_content_int(i, "item");
        reward_temp_count = cache_get_field_content_int(i, "count");
        new is_static = cache_get_field_content_int(i, "static");
        Reward:GetTypeName(reward_temp_type, reward_temp_type_name);
        Reward:GetItemName(reward_temp_type, reward_temp_item, reward_temp_item_name);
        format(reward_temp_line, sizeof reward_temp_line, "{ffc869}%d\t{FFFFFF}%s\t{FFFFFF}%s\t{FFFFFF}%d\t{FFFFFF}%s\n", 
            reward_temp_id, reward_temp_type_name, reward_temp_item_name, reward_temp_count, is_static ? "Да" : "Нет");
        strcat(reward_temp_dialog, reward_temp_line);
    }
    cache_delete(reward_temp_result);
    Dialog(playerid, DIALOG_REWARDS_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "{ffc869}Список наград", reward_temp_dialog, "Назад", "");
    return 1;
}

stock Reward:GetTypeName(reward_type, output[])
{
    switch(reward_type)
    {
        case 0: format(output, 32, "Фишки");
        case 1: format(output, 32, "Донат");
        case 2: format(output, 32, "Предмет");
        case 3: format(output, 32, "EXP");
        case 4: format(output, 32, "Слот");
        case 5: format(output, 32, "Одежда");
        case 6: format(output, 32, "Аксессуар");
        case 7: format(output, 32, "Транспорт");
        default: format(output, 32, "Неизвестно");
    }
}

stock Reward:GetItemName(reward_type, reward_item, output[])
{
    switch(reward_type)
    {
        case 2: format(output, 64, "%s", ItemsInfo[reward_item]);
        case 5: format(output, 64, "Скин №%d", reward_item);
        default: format(output, 64, "-");
    }
}

stock Reward:GetMonthName(reward_month, output[])
{
    new months[][] = {"Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"};
    format(output, 32, "%s", months[reward_month]);
}

stock Reward:InsertIntoMysql(playerid)
{
    mysql_format(mysql, STRING_GLOBAL, sizeof STRING_GLOBAL, 
        "INSERT INTO `rewards`(`item`, `type`, `count`, `static`, month) VALUES ('%d','%d','%d','%d', %d)", 
        g_rewards[playerid][E_ITEM_PRIZE], g_rewards[playerid][E_TYPE_PRIZE], g_rewards[playerid][E_COUNT_PRIZE], 
        g_rewards[playerid][E_TYPE_GIVED], Reward:MonthDaily());
    mysql_tquery(mysql, STRING_GLOBAL);
    Reward:GetTypeName(g_rewards[playerid][E_TYPE_PRIZE], reward_temp_type_name);
    format(reward_temp_msg, sizeof reward_temp_msg, "{ffc869}Награда создана! Тип: %s, Кол-во: %d, Гарантированная: %s", 
        reward_temp_type_name, g_rewards[playerid][E_COUNT_PRIZE], g_rewards[playerid][E_TYPE_GIVED] ? "Да" : "Нет");
    SendClientMessage(playerid, 0xffc869ff, reward_temp_msg);
    Reward:ShowMainMenu(playerid);
}

stock Reward:MonthDaily()
{
    getdate(reward_temp_year, reward_temp_month_num, reward_temp_day);
    return reward_temp_month_num - 1;
}

stock Reward_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(dialogid)
        {
            case DIALOG_REWARDS_MAIN:
            {
                switch(listitem)
                {
                    case 0:
                    {
                        reward_temp_dialog[0] = EOS;
                        strcat(reward_temp_dialog, "{ffc869}Выберите тип награды:\n\n{FFFFFF}Гарантированная награда {ffc869}(выдается каждые 7 дней)\n{FFFFFF}Случайная награда {ffc869}(выдается рандомно)");
                        Dialog(playerid, DIALOG_REWARDS_CREATE1, DIALOG_STYLE_LIST, "{ffc869}Тип награды", reward_temp_dialog, "Выбрать", "Назад");
                    }
                    case 1: Reward:ShowAllRewards(playerid);
                    case 2:
                    {
                        Dialog(playerid, DIALOG_REWARDS_DELETE, DIALOG_STYLE_INPUT, "{ffc869}Удаление награды", 
                            "{FFFFFF}Введите ID награды для удаления:", "Удалить", "Назад");
                    }
                    case 3:
                    {
                        Dialog(playerid, DIALOG_REWARDS_CLEAR, DIALOG_STYLE_MSGBOX, "{ffc869}Подтверждение",
                            "{FFFFFF}Вы уверены что хотите удалить {ffc869}ВСЕ{FFFFFF} награды текущего месяца?\n\n{ffc869}Это действие необратимо!", "Да", "Нет");
                    }
                }
            }
            case DIALOG_REWARDS_VIEW: Reward:ShowMainMenu(playerid);
            case DIALOG_REWARDS_CLEAR:
            {
                mysql_format(mysql, STRING_GLOBAL, sizeof STRING_GLOBAL, "DELETE FROM rewards WHERE month=%d", Reward:MonthDaily());
                mysql_query(mysql, STRING_GLOBAL, false);
                SendClientMessage(playerid, 0xffc869FF, "Все награды текущего месяца удалены!");
                Reward:ShowMainMenu(playerid);
            }
            case DIALOG_REWARDS_DELETE:
            {
                reward_temp_id = strval(inputtext);
                if(reward_temp_id < 1)
                {
                    SendClientMessage(playerid, 0xffc869FF, "Неверный ID награды!");
                    return Reward:ShowMainMenu(playerid);
                }
                mysql_format(mysql, STRING_GLOBAL, sizeof STRING_GLOBAL, "DELETE FROM rewards WHERE id=%d AND month=%d", reward_temp_id, Reward:MonthDaily());
                mysql_query(mysql, STRING_GLOBAL, false);
                format(reward_temp_msg, sizeof reward_temp_msg, "{ffc869}Награда ID %d удалена!", reward_temp_id);
                SendClientMessage(playerid, 0xffc869ff, reward_temp_msg);
                Reward:ShowMainMenu(playerid);
            }
            case DIALOG_REWARDS_CREATE1:
            {
                g_rewards[playerid][E_TYPE_GIVED] = bool:listitem;
                reward_temp_dialog[0] = EOS;
                strcat(reward_temp_dialog, "{ffc869}Выберите тип награды:\n\n{FFFFFF}Фишки\n{FFFFFF}Донат\n{FFFFFF}Предмет\n{FFFFFF}EXP\n{FFFFFF}Слоты\n{FFFFFF}Одежда\n{FFFFFF}Аксессуар\n{FFFFFF}Транспорт");
                Dialog(playerid, DIALOG_REWARDS_CREATE2, DIALOG_STYLE_LIST, "{ffc869}Тип награды", reward_temp_dialog, "Выбрать", "Назад");
            }
            case DIALOG_REWARDS_CREATE2:
            {
                g_rewards[playerid][E_TYPE_PRIZE] = listitem;
                reward_temp_dialog[0] = EOS;
                switch(listitem)
                {
                    case 0, 1, 3:
                    {
                        format(reward_temp_dialog, sizeof reward_temp_dialog, "{FFFFFF}Введите количество:");
                        Dialog(playerid, DIALOG_REWARDS_CREATE3, DIALOG_STYLE_INPUT, "{ffc869}Количество", reward_temp_dialog, "Далее", "Назад");
                    }
                    case 2:
                    {
                        format(reward_temp_dialog, sizeof reward_temp_dialog, "{FFFFFF}Введите ID предмета:");
                        Dialog(playerid, DIALOG_REWARDS_CREATE3, DIALOG_STYLE_INPUT, "{ffc869}ID предмета", reward_temp_dialog, "Далее", "Назад");
                    }
                    case 4:
                    {
                        strcat(reward_temp_dialog, "{ffc869}Выберите тип слота:\n\n{FFFFFF}Слот для машины\n{FFFFFF}Слот для дома\n{FFFFFF}Слот для бизнеса");
                        Dialog(playerid, DIALOG_REWARDS_CREATE3, DIALOG_STYLE_LIST, "{ffc869}Тип слота", reward_temp_dialog, "Далее", "Назад");
                    }
                    case 5:
                    {
                        format(reward_temp_dialog, sizeof reward_temp_dialog, "{FFFFFF}Введите ID скина:");
                        Dialog(playerid, DIALOG_REWARDS_CREATE3, DIALOG_STYLE_INPUT, "{ffc869}ID скина", reward_temp_dialog, "Далее", "Назад");
                    }
                }
            }
            case DIALOG_REWARDS_CREATE3:
            {
                switch(g_rewards[playerid][E_TYPE_PRIZE])
                {
                    case 0, 1, 3:
                    {                
                        g_rewards[playerid][E_COUNT_PRIZE] = strval(inputtext);
                        Reward:InsertIntoMysql(playerid);
                    }
                    case 2:
                    {
                        g_rewards[playerid][E_ITEM_PRIZE] = strval(inputtext);
                        format(reward_temp_dialog, sizeof reward_temp_dialog, "{ffc869}Предмет: {FFFFFF}%s\n\n{FFFFFF}Введите количество:", ItemsInfo[g_rewards[playerid][E_ITEM_PRIZE]]);
                        Dialog(playerid, DIALOG_REWARDS_CREATE4, DIALOG_STYLE_INPUT, "{ffc869}Количество", reward_temp_dialog, "Создать", "Назад");
                    }
                    case 5:
                    {
                        g_rewards[playerid][E_COUNT_PRIZE] = strval(inputtext); 
                        Reward:InsertIntoMysql(playerid);
                    }
                }
            }
            case DIALOG_REWARDS_CREATE4:
            {
                g_rewards[playerid][E_COUNT_PRIZE] = strval(inputtext);
                Reward:InsertIntoMysql(playerid);
            }
        }
    }
    else
    {
        switch(dialogid)
        {
            case DIALOG_REWARDS_CREATE1, DIALOG_REWARDS_CREATE2, DIALOG_REWARDS_CREATE3, DIALOG_REWARDS_DELETE, DIALOG_REWARDS_VIEW:
            {
                Reward:ShowMainMenu(playerid);
            }
        }
    }
    return 1;
}

new str_f[4096];
const MAX_REWARDS_LOADED = 40;
enum E_REWARDS_LOADED
{
    E_SQL_ID,
    E_TYPE_PRIZE,
    E_ITEM_PRIZE,
    E_COUNT_PRIZE,
    E_TYPE_GIVED,
    E_SOURCE_INDEX
};
new g_loaded_rewards[MAX_REWARDS_LOADED+1][E_REWARDS_LOADED];
new g_player_getted_rew[MAX_PLAYERS][E_REWARDS_LOADED][MAX_REWARDS_LOADED]; 

stock GetRewardPlayer(playerid, id_prize)
{
    mysql_format(mysql, STRING_GLOBAL, sizeof STRING_GLOBAL, 
        "SELECT * FROM reward_player WHERE player_id = %d AND id_prize = %d LIMIT 1", 
        g_player[playerid][P_ACCOUNT_ID], id_prize); 
    mysql_query(mysql, STRING_GLOBAL, true); 
    return cache_num_rows() > 0;
}

stock GetEventPlayer(playerid, event)
{
    mysql_format(mysql, STRING_GLOBAL, sizeof STRING_GLOBAL, 
        "SELECT * FROM reward_player WHERE player_id = %d AND event = %d LIMIT 1", 
        g_player[playerid][P_ACCOUNT_ID], event); 
    mysql_query(mysql, STRING_GLOBAL, true); 
    return cache_num_rows() > 0;
}

stock MainMenu_OnPlayerRewardOpen(playerid, event)
{  
    reward_temp_index = g_player_getted_rew[playerid][E_SOURCE_INDEX][event];
    if(reward_temp_index < 0 || reward_temp_index >= Reward:GetValidRewards()) return 0;
    reward_temp_type = g_loaded_rewards[reward_temp_index][E_TYPE_PRIZE];
    reward_temp_count = g_loaded_rewards[reward_temp_index][E_COUNT_PRIZE];
    reward_temp_item = g_loaded_rewards[reward_temp_index][E_ITEM_PRIZE];
    printf("pelmeshki_2 -> %d,%d,%d", reward_temp_item, reward_temp_type, reward_temp_count);
    SetPlayerData(playerid, P_WARDS_PRIZE, GetPlayerData(playerid, P_WARDS_PRIZE)-1);
    DailyreWards_Time[playerid] = -2;
    UpdatePlayerDatabaseInt(playerid, "timerrewards", -2);
    GameTextForPlayer(playerid, "~g~Успешно!", 4000, 1);
    g_player[playerid][P_WARDS_TYPE_PRIZES]++;
    UpdatePlayerDatabaseInt(playerid, "wards_type_prizes", GetPlayerData(playerid, P_WARDS_TYPE_PRIZES));
    mysql_queryf(mysql, "INSERT INTO reward_player (player_id, id_prize, event) VALUES (%d, %d, %d)", false, g_player[playerid][P_ACCOUNT_ID], g_loaded_rewards[reward_temp_index][E_SQL_ID], event );
    MainMenuTest(playerid);
    if (g_player[playerid][P_WARDS_TYPE_PRIZES] == 7 || g_player[playerid][P_WARDS_TYPE_PRIZES] == 14 || 
    g_player[playerid][P_WARDS_TYPE_PRIZES] == 21 || g_player[playerid][P_WARDS_TYPE_PRIZES] == 28)
    {
        new idk = 0;
        new prize_index = -1;
        new target_prize_num = g_player[playerid][P_WARDS_TYPE_PRIZES] / 7;
        for (new i = 0; i < Reward:GetValidRewards(); i++)
        {
            if (g_loaded_rewards[i][E_TYPE_GIVED] != 0) continue;
            idk++;
            if (idk == target_prize_num)
            {
                prize_index = i;
                break;
            }
        }
        if (prize_index != -1)
        {
            reward_temp_type = g_loaded_rewards[prize_index][E_TYPE_PRIZE];
            reward_temp_count = g_loaded_rewards[prize_index][E_COUNT_PRIZE];
            reward_temp_item = g_loaded_rewards[prize_index][E_ITEM_PRIZE];
            printf("Гарантированный приз выдан на день %d (приз №%d): тип %d, предмет %d, количество %d", 
                g_player[playerid][P_WARDS_TYPE_PRIZES], target_prize_num, reward_temp_type, reward_temp_item, reward_temp_count);
            MainMenuTest(playerid);
        }
        else
        {
            printf("Не удалось найти гарантированный приз №%d для дня %d", target_prize_num, g_player[playerid][P_WARDS_TYPE_PRIZES]);
        }
    }
    return 1;
}

stock LoadingRewards()
{
    mysql_format(mysql, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT * FROM rewards WHERE month=%d ORDER BY id LIMIT 30", Reward:MonthDaily());
    mysql_query(mysql, STRING_GLOBAL, true);
    new idk;
    for (new i ; i <= cache_num_rows(); i++)
    {
        idk++;
        g_loaded_rewards[i][E_SQL_ID] = cache_get_field_content_int(i, "id");
        g_loaded_rewards[i][E_TYPE_PRIZE] = cache_get_field_content_int(i, "type");
        g_loaded_rewards[i][E_ITEM_PRIZE] = cache_get_field_content_int(i, "item");
        g_loaded_rewards[i][E_COUNT_PRIZE] = cache_get_field_content_int(i, "count");
        g_loaded_rewards[i][E_TYPE_GIVED] = cache_get_field_content_int(i, "static");
    }
    printf("loaded -> %d ", idk);
}

stock Reward:GetValidRewards()
{
    reward_temp_idx = 0;
    for ( new i ; i <= MAX_REWARDS_LOADED ; i ++ )
    {
        if ( g_loaded_rewards[i][E_SQL_ID] == 0 && g_loaded_rewards[i][E_TYPE_PRIZE] == 0 && g_loaded_rewards[i][E_ITEM_PRIZE] == 0 ) continue;
        reward_temp_idx++;
    }
    return reward_temp_idx;
}

stock MainMenuTest(playerid)
{
    str_f[0] = EOS;
    STRING_GLOBAL[0] = EOS;
    new idddk;
    new indices[28];
    new reward_count = 0;   
    new valid_rewards = Reward:GetValidRewards();
    for (new i = 0; i < valid_rewards && reward_count < sizeof(indices); i++)
    {
        if (g_loaded_rewards[i][E_TYPE_GIVED] == 1)
        {
            indices[reward_count] = i;
            reward_count++;
        }
    }
    if (reward_count == 0) return;
    idddk = 0; 
    for (new j = 0; j < 28; j++)
    {
        new reward_index = indices[j % reward_count]; 
        idddk++;
        g_player_getted_rew[playerid][E_ITEM_PRIZE][j] = g_loaded_rewards[reward_index][E_ITEM_PRIZE];
        g_player_getted_rew[playerid][E_COUNT_PRIZE][j] = g_loaded_rewards[reward_index][E_COUNT_PRIZE];
        g_player_getted_rew[playerid][E_TYPE_PRIZE][j] = g_loaded_rewards[reward_index][E_TYPE_PRIZE];
        g_player_getted_rew[playerid][E_TYPE_GIVED][j] = g_loaded_rewards[reward_index][E_TYPE_GIVED];
        g_player_getted_rew[playerid][E_SOURCE_INDEX][j] = reward_index;
        if (g_loaded_rewards[reward_index][E_TYPE_PRIZE] == 2)
            format(str_f, sizeof str_f, "%s[8,%d,%d,0,\"\",%d,0],", str_f, g_loaded_rewards[reward_index][E_ITEM_PRIZE], g_loaded_rewards[reward_index][E_COUNT_PRIZE], GetEventPlayer(playerid, j));
        else if (g_loaded_rewards[reward_index][E_TYPE_PRIZE] == 0)
            format(str_f, sizeof str_f, "%s[8,293,%d,0,\"\",%d,0],", str_f, g_loaded_rewards[reward_index][E_COUNT_PRIZE], GetEventPlayer(playerid, j));
        else if (g_loaded_rewards[reward_index][E_TYPE_PRIZE] == 1)
            format(str_f, sizeof str_f, "%s[10,0,%d,0,\"\",%d,0],", str_f, g_loaded_rewards[reward_index][E_COUNT_PRIZE], GetEventPlayer(playerid, j));
        else if (g_loaded_rewards[reward_index][E_TYPE_PRIZE] == 3)
            format(str_f, sizeof str_f, "%s[2,%d,0,0,\"\",%d,0],", str_f, g_loaded_rewards[reward_index][E_COUNT_PRIZE], GetEventPlayer(playerid, j));
        else if (g_loaded_rewards[reward_index][E_TYPE_PRIZE] == 5)
            format(str_f, sizeof str_f, "%s[4,%d,0,0,\"\",%d,0],", str_f, g_loaded_rewards[reward_index][E_COUNT_PRIZE], GetEventPlayer(playerid, j));
    }
    str_q[0]=EOS;
    new idk = 0 ;
    for (new i ; i <= Reward:GetValidRewards(); i++)
    {
        if ( g_loaded_rewards[i][E_TYPE_GIVED] != 0 ) continue;
        if (g_loaded_rewards[i][E_ITEM_PRIZE] == 0 && g_loaded_rewards[i][E_COUNT_PRIZE] == 0 && g_loaded_rewards[i][E_TYPE_PRIZE] == 0) continue;
        idk++;
        if (g_loaded_rewards[i][E_TYPE_PRIZE] == 2)
            format(str_q, sizeof str_q, "%s[8,%d,%d,0,\"%s x%d\",[%d,%d]],", str_q, g_loaded_rewards[i][E_ITEM_PRIZE], g_loaded_rewards[i][E_COUNT_PRIZE], ItemsInfo[g_loaded_rewards[i][E_ITEM_PRIZE]], g_loaded_rewards[i][E_COUNT_PRIZE], g_player[playerid][P_WARDS_TYPE_PRIZES],  idk * 7);
        else if (g_loaded_rewards[i][E_TYPE_PRIZE] == 0)
            format(str_q, sizeof str_q, "%s[8,293,%d,0,\"Фишки x%d\",[%d,%d]],", str_q, g_loaded_rewards[i][E_COUNT_PRIZE], g_loaded_rewards[i][E_COUNT_PRIZE], g_player[playerid][P_WARDS_TYPE_PRIZES],  idk * 7);
        else if (g_loaded_rewards[i][E_TYPE_PRIZE] == 1)
            format(str_q, sizeof str_q, "%s[10,%d,0,0,\"Донат x%d\",[%d,%d]],", str_q, g_loaded_rewards[i][E_ITEM_PRIZE], g_loaded_rewards[i][E_COUNT_PRIZE], g_player[playerid][P_WARDS_TYPE_PRIZES],  idk * 7);
        else if (g_loaded_rewards[i][E_TYPE_PRIZE] == 4)
            format(str_q, sizeof str_q, "%s[4,%d,0,0,\"Скин №%d\",[%d,%d]],", str_q, g_loaded_rewards[i][E_ITEM_PRIZE], g_loaded_rewards[i][E_ITEM_PRIZE], g_player[playerid][P_WARDS_TYPE_PRIZES],  idk * 7);
        else if (g_loaded_rewards[i][E_TYPE_PRIZE] == 3)
            format(str_q, sizeof str_q, "%s[2,0,0,0,\"EXP x%d\",[%d,%d]],", str_q, g_loaded_rewards[i][E_COUNT_PRIZE], g_player[playerid][P_WARDS_TYPE_PRIZES],  idk * 7);
    }
    strdel(str_f, strlen( str_f)-1, strlen(str_f));
    strdel(str_q, strlen(str_q)-1, strlen(str_q));
    print(str_f);
    print(str_q);
    STRING_GLOBAL[0] = EOS;
    if (GetPlayerData(playerid, P_PRIZE_OPENED) == 0)
    {
        format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('MainMenu').onServerResponse(8, '[%d,%d,7200,%d,[%s],[%s], 1]')", Reward:MonthDaily(), DailyreWards_Time[playerid], GetPlayerData(playerid, P_WARDS_PRIZE), str_f, str_q);
        print(STRING_GLOBAL);
        g_player[playerid][P_PRIZE_OPENED] = 1;
        UpdatePlayerDatabaseInt(playerid, "rewards_status", 1);
    }
    if (GetPlayerData(playerid, P_PRIZE_OPENED) == 1)
    {
        format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('MainMenu').onServerResponse(8, '[%d,%d,7200,%d,[%s],[%s]]')", Reward:MonthDaily(), DailyreWards_Time[playerid], GetPlayerData(playerid, P_WARDS_PRIZE), str_f, str_q);
        print(STRING_GLOBAL);
    }
}

CMD:reset_motnth(playerid)
{
    mysql_query(mysql, "DELETE FROM rewards");
    mysql_query(mysql, "DELETE FROM reward_player");
    mysql_query(mysql, "UPDATE PlayerMorallwens SET reward_opened=0, timerrewards=0,wards_prize=0");
    return 1;
}
