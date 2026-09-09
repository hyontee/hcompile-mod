stock GetPlayerBankBalanceForDisplay(playerid);

new Float:g_coffers_pos[3] = {-2547.3411, 1474.9447, 1081.6489};
new Text3D:g_coffers_3dtext;
static g_dialogText[2048];
static g_dialogTextSmall[512];

stock Kz_InitCoffers()
{
    Kz_UpdateCoffers3DText();
    return 1;
}

stock Kz_UpdateCoffers3DText()
{
    if(g_coffers_3dtext != Text3D:0)
    {
        DestroyDynamic3DTextLabel(g_coffers_3dtext);
    }
    
    static balance_str[32];
    Kz_GetCoffersBalanceStr(balance_str, sizeof(balance_str));
    static text[128];
    format(text, sizeof(text), "Казна\n{3DF22B}%s рублей", formatStr(balance_str));
    
    g_coffers_3dtext = CreateDynamic3DTextLabel(text, 0x66CCFFFF, g_coffers_pos[0], g_coffers_pos[1], g_coffers_pos[2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 7.0);
    
    printf("[COFFERS] 3D Text updated: %s", text);
}

stock Kz_GetCoffersBalance()
{
    static balance_str[32];
    Kz_GetCoffersBalanceStr(balance_str, sizeof(balance_str));
    new balance = strval(balance_str);
    printf("[COFFERS] Balance from DB: %s", balance_str);
    return balance;
}

stock Kz_GetCoffersBalanceInt()
{
    static balance_str[32];
    Kz_GetCoffersBalanceStr(balance_str, sizeof(balance_str));
    return strval(balance_str);
}

stock Kz_GetCoffersBalanceStr(dest[], max_len)
{
    static query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT balance FROM coffers_balance WHERE id = 1 LIMIT 1");
    new Cache:result = mysql_query(mysql, query);
    if(cache_num_rows() > 0)
    {
        cache_get_field_content(0, "balance", dest, mysql, max_len);
    }
    else
    {
        format(dest, max_len, "0");
    }
    cache_delete(result);
    return 1;
}

stock Kz_SetCoffersBalance(balance)
{
    static balance_str[32];
    format(balance_str, sizeof(balance_str), "%d", balance);
    Kz_SetCoffersBalanceStr(balance_str);
}

stock Kz_SetCoffersBalanceStr(balance_str[])
{
    static query[256];
    mysql_format(mysql, query, sizeof(query), "UPDATE coffers_balance SET balance = %s WHERE id = 1", balance_str);
    mysql_query(mysql, query);
    Kz_UpdateCoffers3DText();
}

stock Kz_EditCoffersBalance(current_balance[], amount[])
{
    static result_str[64];
    format(result_str, sizeof(result_str), "%s", EditCountSInteger(0, current_balance, amount));
    
    Kz_SetCoffersBalanceStr(result_str);
    return strval(result_str);
}

stock Kz_AddCoffersLog(playerid, balance_before_str[], balance_after_str[], action_type, amount)
{
    static query[256];
    if(action_type == 2)
    {
        mysql_format(mysql, query, sizeof(query), "INSERT INTO coffers_log (player_name, balance_before, balance_after, action_type, amount) VALUES ('Выдача зарплаты', '%e', '%e', %d, %d)", 
            balance_before_str, balance_after_str, action_type, amount);
    }
    else
    {
        mysql_format(mysql, query, sizeof(query), "INSERT INTO coffers_log (player_name, balance_before, balance_after, action_type, amount) VALUES ('%e', '%e', '%e', %d, %d)", 
            GetPlayerNameEx(playerid), balance_before_str, balance_after_str, action_type, amount);
    }
    mysql_query(mysql, query);
}

stock Kz_GetFinancePercentage(team_id)
{
    static percentage = 100;
    static query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT percentage FROM finance_percentages WHERE team_id = %d LIMIT 1", team_id);
    new Cache:result = mysql_query(mysql, query);
    if(cache_num_rows() > 0)
    {
        percentage = cache_get_field_content_int(0, "percentage");
    }
    cache_delete(result);
    return percentage;
}

stock Kz_SetFinancePercentage(team_id, percentage, playerid)
{
    static query[128];
    mysql_format(mysql, query, sizeof(query), "UPDATE finance_percentages SET percentage = %d WHERE team_id = %d", percentage, team_id);
    mysql_query(mysql, query);
    
    static pvar_name[32];
    format(pvar_name, sizeof(pvar_name), "finance_cd_%d", team_id);
    SetPVarInt(playerid, pvar_name, gettime());
}

stock Kz_CanChangeFinancePercentage(team_id, playerid)
{
    static pvar_name[32];
    format(pvar_name, sizeof(pvar_name), "finance_cd_%d", team_id);
    new last_update = GetPVarInt(playerid, pvar_name);
    new current_time = gettime();
    new hours_passed = (current_time - last_update) / 3600;
    
    if(hours_passed < 24 && last_update > 0)
    {
        return 0;
    }
    return 1;
}

stock Kz_GetFinanceCDRemaining(team_id, playerid)
{
    new pvar_name[32];
    format(pvar_name, sizeof(pvar_name), "finance_cd_%d", team_id);
    new last_update = GetPVarInt(playerid, pvar_name);
    new current_time = gettime();
    new hours_passed = (current_time - last_update) / 3600;
    new hours_remaining = 24 - hours_passed;
    
    if(hours_remaining < 0) hours_remaining = 0;
    return hours_remaining;
}

stock Kz_AddFinanceLog(playerid, team_id, percentage_before, percentage_after)
{
    static query[256];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO finance_log (team_id, player_name, percentage_before, percentage_after) VALUES (%d, '%e', %d, %d)", 
        team_id, GetPlayerNameEx(playerid), percentage_before, percentage_after);
    mysql_query(mysql, query);
}

stock GetPlayerBankBalanceForDisplay(playerid)
{
    new balance = 0;
    static query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT bank FROM PlayersMorallwens WHERE id = %d LIMIT 1", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query);
    if(cache_num_rows() > 0)
    {
        new bank[21];
        cache_get_field_content(0, "bank", bank);
        balance = strval(bank);
    }
    cache_delete(result);
    return balance;
}

stock Kz_GetPlayerLastFinancePerc(playerid)
{
    new percentage = 0;
    static query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT last_finance_percentage FROM PlayersMorallwens WHERE id = %d LIMIT 1", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query);
    if(cache_num_rows() > 0)
    {
        percentage = cache_get_field_content_int(0, "last_finance_percentage");
    }
    cache_delete(result);
    return percentage;
}

stock Kz_SetPlayerLastFinancePerc(playerid, percentage)
{
    static query[128];
    mysql_format(mysql, query, sizeof(query), "UPDATE PlayersMorallwens SET last_finance_percentage = %d WHERE id = %d", percentage, GetPlayerAccountID(playerid));
    mysql_query(mysql, query);
}

stock Kz_GetFinanceLastUpdate(team_id, dest[], max_len)
{
    static query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT DATE_FORMAT(last_update, '%%d-%%m-%%Y %%H:%%i:%%s') as formatted_date FROM finance_percentages WHERE team_id = %d LIMIT 1", team_id);
    new Cache:result = mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        cache_get_field_content(0, "formatted_date", dest, mysql, max_len);
    }
    else
    {
        format(dest, max_len, "08-08-2025 18:10:00");
    }
    
    cache_delete(result);
}

stock Kz_GetTeamName(team_id)
{
    new team_name[32];
    switch(team_id)
    {
        case 1: format(team_name, sizeof(team_name), "Правительство");
        case 2: format(team_name, sizeof(team_name), "Мин. Обороны");
        case 3: format(team_name, sizeof(team_name), "Мин. Здравоохранения");
        case 4: format(team_name, sizeof(team_name), "ТРК `Ритм`");
        case 5: format(team_name, sizeof(team_name), "ФСБ");
        case 6: format(team_name, sizeof(team_name), "Мин. Внутренних дел");
        case 7: format(team_name, sizeof(team_name), "ФСИН");
        default: format(team_name, sizeof(team_name), "Неизвестно");
    }
    return team_name;
}

stock Kz_GetFinanceColor(percentage)
{
    new color[8];
    if(percentage == 100) 
    {
        format(color, sizeof(color), "FFFFFF");
    }
    else if(percentage < 100) 
    {
        format(color, sizeof(color), "DE5555");
    }
    else 
    {
        format(color, sizeof(color), "92D434");
    }
    return color;
}

stock Kz_ShowCoffersDialog(playerid)
{
    if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT)
    {
        static balance_str[32];
        Kz_GetCoffersBalanceStr(balance_str, sizeof(balance_str));
        new team = GetPlayerTeamEx(playerid);
        new job = GetPlayerJob(playerid);
        new wage = 0;
        
        if(team >= 1 && team <= 11 && job >= 1 && job <= 10)
        {
            wage = rank_wages[team-1][job-1];
        }
        
        format(g_dialogTextSmall, sizeof(g_dialogTextSmall), 
            "Всего средств в казне: {CCCCCC}%s{FFFFFF}\n\n" \
            "Ваша зарплата: {CCCCCC}%s{FFFFFF}", 
            formatStr(balance_str), formatInt(wage));
        
        Dialog(playerid, COFFERS_DIALOG_MAIN, DIALOG_STYLE_MSGBOX, "Казна государства", g_dialogTextSmall, "Закрыть", "");
        return 1;
    }
    
    static balance_str[32];
    Kz_GetCoffersBalanceStr(balance_str, sizeof(balance_str));
    format(g_dialogTextSmall, sizeof(g_dialogTextSmall), "Всего средств в казне: {CCCCCC}%s{FFFFFF}", formatStr(balance_str));
    
    if(GetPlayerJob(playerid) >= 10)
    {
        strcat(g_dialogTextSmall, "\n\n1. Пополнить казну\n2. Журнал взаимодействий с казной\n3. Управление распределением финансирования\n4. Журнал распределений финансирования\n5. Государственные закупки\n6. Журнал государственных закупок");
    }
    else
    {
        strcat(g_dialogTextSmall, "\n\n1. Пополнить казну\n2. Журнал взаимодействий с казной");
    }
    
    Dialog(playerid, COFFERS_DIALOG_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Казна организации", g_dialogTextSmall, "Выбрать", "Отмена");
    return 1;
}

stock Kz_ShowDepositDialog(playerid)
{
    static balance_str[32];
    Kz_GetCoffersBalanceStr(balance_str, sizeof(balance_str));
    format(g_dialogTextSmall, sizeof(g_dialogTextSmall), 
        "{FFFFFF}Введите сумму для пополнения казны:");
    
    Dialog(playerid, COFFERS_DIALOG_DEPOSIT, DIALOG_STYLE_INPUT, "Пополнение казны", g_dialogTextSmall, "Пополнить", "Отмена");
    return 1;
}

stock Kz_ShowCoffersLog(playerid)
{
    format(g_dialogText, sizeof(g_dialogText), "Сотрудник\tБаланс до\tБаланс после\tДата\n");
    
    static query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT player_name, balance_before, balance_after, date FROM coffers_log ORDER BY date DESC", 0);
    new Cache:result = mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        new player_name[24], balance_before_str[64], balance_after_str[64], date_str[32];
        for(new i = 0; i < cache_num_rows(); i++)
        {
            cache_get_field_content(i, "player_name", player_name, mysql, sizeof(player_name));
            cache_get_field_content(i, "balance_before", balance_before_str, mysql, sizeof(balance_before_str));
            cache_get_field_content(i, "balance_after", balance_after_str, mysql, sizeof(balance_after_str));
            cache_get_field_content(i, "date", date_str, mysql, sizeof(date_str));
            
            format(g_dialogText, sizeof(g_dialogText), "%s%s\t%s\t%s\t%s\n", 
                g_dialogText, player_name, formatStr(balance_before_str), formatStr(balance_after_str), date_str);
        }
    }
    else
    {
        strcat(g_dialogText, "Нет записей");
    }
    
    cache_delete(result);
    
    Dialog(playerid, COFFERS_DIALOG_LOG, DIALOG_STYLE_TABLIST_HEADERS, "Журнал казны", g_dialogText, "", "Назад");
    return 1;
}

stock Kz_ShowFinanceDialog(playerid)
{
    if(GetPlayerJob(playerid) < 10)
    {
        static message[128];
        format(message, sizeof(message), "Доступ к управлению финансированием имеют только лидеры (ранг 10+)");
        SendClientMessage(playerid, 0x999999FF, message);
        return 0;
    }
    
    format(g_dialogText, sizeof(g_dialogText), "Организация\tФинансирование\tПоследняя дата изменения\n");
    
    new team_ids[] = {1, 2, 3, 4, 6, 7, 11};
    new team_names_finance[][] = {"Правительство", "Мин. Обороны", "Мин. Здравоохранения", "ТРК `Ритм`", "ФСБ", "Мин. Внутренних дел", "ФСИН"};
    
    for(new i = 0; i < sizeof(team_ids); i++)
    {
        new percentage = Kz_GetFinancePercentage(team_ids[i]);
        new color[8];
        strmid(color, Kz_GetFinanceColor(percentage), 0, 6, sizeof(color));
        
        new date_str[32];
        Kz_GetFinanceLastUpdate(team_ids[i], date_str, sizeof(date_str));
        
        format(g_dialogText, sizeof(g_dialogText), "%s%d. %s\t{%s}%d%%\t{FFFFFF}%s\n", 
            g_dialogText, i + 1, team_names_finance[i], color, percentage, date_str);
    }
    
    Dialog(playerid, COFFERS_DIALOG_FINANCE, DIALOG_STYLE_TABLIST_HEADERS, "Управление финансированием", g_dialogText, "Изменить", "Отмена");
    return 1;
}

stock Kz_ShowFinanceLog(playerid)
{
    format(g_dialogText, sizeof(g_dialogText), "Организация\tСотрудник\tПроцент до\tПроцент после\tДата изменения\n");
    
    static query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT fl.team_id, fl.player_name, fl.percentage_before, fl.percentage_after, fl.date FROM finance_log fl ORDER BY fl.date DESC", 0);
    new Cache:result = mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        new team_id, player_name[24], percentage_before, percentage_after, date_str[32];
        for(new i = 0; i < cache_num_rows(); i++)
        {
            team_id = cache_get_field_content_int(i, "team_id");
            cache_get_field_content(i, "player_name", player_name, mysql, sizeof(player_name));
            percentage_before = cache_get_field_content_int(i, "percentage_before");
            percentage_after = cache_get_field_content_int(i, "percentage_after");
            cache_get_field_content(i, "date", date_str, mysql, sizeof(date_str));
            
            format(g_dialogText, sizeof(g_dialogText), "%s%s\t%s\t%d%%\t%d%%\t%s\n", 
                g_dialogText, Kz_GetTeamName(team_id), player_name, percentage_before, percentage_after, date_str);
        }
    }
    else
    {
        strcat(g_dialogText, "Нет записей");
    }
    
    cache_delete(result);
    
    Dialog(playerid, COFFERS_DIALOG_FINANCE_LOG, DIALOG_STYLE_TABLIST_HEADERS, "Журнал финансирования", g_dialogText, "", "Назад");
    return 1;
}

stock Kz_ShowFinanceEditDialog(playerid, team_id)
{
    new current_percentage = Kz_GetFinancePercentage(team_id);
    new team_name[32];
    format(team_name, sizeof(team_name), "%s", Kz_GetTeamName(team_id));
    
    format(g_dialogTextSmall, sizeof(g_dialogTextSmall), 
        "{FFFFFF}Изменение финансирования для организации:\n\n" \
        "{FFD700}Организация: {FFFFFF}%s\n" \
        "{FFD700}Текущий процент: {FFFFFF}%d%%",
        team_name, current_percentage);
    
    SetPVarInt(playerid, "editing_team_id", team_id);
    Dialog(playerid, COFFERS_DIALOG_FINANCE_EDIT, DIALOG_STYLE_INPUT, "Изменение финансирования", g_dialogTextSmall, "Изменить", "Отмена");
    return 1;
}

stock Kz_ShowPurchasesDialog(playerid)
{
    format(g_dialogText, sizeof(g_dialogText), "{ffffff}№\t{ffffff}Запросил\t{ffffff}Модель\t{ffffff}Стоимость\t{ffffff}Дата\n");
    
    static query[512];
    mysql_format(mysql, query, sizeof(query), "SELECT r.id, r.owner_id, r.model_id, r.price, r.created_at, IFNULL(a.name, 'Неизвестно') as owner_name FROM org_car_requests r LEFT JOIN PlayersMorallwens a ON r.owner_id = a.id WHERE r.status = 0 ORDER BY r.id ASC");
    new Cache:result = mysql_query(mysql, query, true);
    
    if(cache_num_rows() > 0)
    {
        for(new i = 0; i < cache_num_rows(); i++)
        {
            new request_id = cache_get_field_content_int(i, "id");
            new model_id_purchases = cache_get_field_content_int(i, "model_id");
            new price = cache_get_field_content_int(i, "price");
            
            new owner_name[24];
            cache_get_field_content(i, "owner_name", owner_name, sizeof(owner_name));
            
            new created_at_str[32];
            cache_get_field_content(i, "created_at", created_at_str, sizeof(created_at_str));
            
            new vehicle_name_purchases[32];
            format(vehicle_name_purchases, sizeof(vehicle_name_purchases), "%s", GetVehicleInfo(model_id_purchases, VI_NAME));
            
            format(g_dialogText, sizeof(g_dialogText), "%s%d\t{ffffff}%s\t{ffffff}%s (%d)\t{ffffff}%s руб\t{ffffff}%s\n",
                g_dialogText, request_id, owner_name, vehicle_name_purchases, model_id_purchases, formatInt(price), created_at_str);
        }
    }
    else
    {
        strcat(g_dialogText, "Нет запросов на рассмотрении");
    }
    
    cache_delete(result);
    
    Dialog(playerid, COFFERS_DIALOG_PURCHASES, DIALOG_STYLE_TABLIST_HEADERS, "Государственные закупки", g_dialogText, "Выбрать", "Назад");
    return 1;
}

stock Kz_ShowPurchasesLogDialog(playerid)
{
    format(g_dialogText, sizeof(g_dialogText), "{ffffff}Рассмотрел\t{ffffff}Организация\t{ffffff}Лидер\t{ffffff}Транспорт\t{ffffff}Дата\t{ffffff}Статус\n");
    
    static query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT reviewer_name, organization, leader, vehicle_id, date, status FROM org_car_purchases_log ORDER BY date DESC LIMIT 50");
    new Cache:result = mysql_query(mysql, query, true);
    
    if(cache_num_rows() > 0)
    {
        for(new i = 0; i < cache_num_rows(); i++)
        {
            new reviewer_name[24], organization[32], leader[24], vehicle_id, formatted_date[32], status[128];
            cache_get_field_content(i, "reviewer_name", reviewer_name, sizeof(reviewer_name));
            cache_get_field_content(i, "organization", organization, sizeof(organization));
            cache_get_field_content(i, "leader", leader, sizeof(leader));
            vehicle_id = cache_get_field_content_int(i, "vehicle_id");
            cache_get_field_content(i, "date", formatted_date, sizeof(formatted_date));
            cache_get_field_content(i, "status", status, sizeof(status));
            
            new vehicle_name_log[32];
            format(vehicle_name_log, sizeof(vehicle_name_log), "%s", GetVehicleInfo(vehicle_id, VI_NAME));
            
            format(g_dialogText, sizeof(g_dialogText), "%s%s\t{ffffff}%s\t{ffffff}%s\t{ffffff}%s (%d)\t{ffffff}%s\t{ffffff}%s\n",
                g_dialogText, reviewer_name, organization, leader, vehicle_name_log, vehicle_id, formatted_date, status);
        }
    }
    else
    {
        strcat(g_dialogText, "Нет записей в журнале");
    }
    
    cache_delete(result);
    
    Dialog(playerid, COFFERS_DIALOG_PURCHASES_LOG, DIALOG_STYLE_TABLIST_HEADERS, "Журнал государственных закупок", g_dialogText, "", "Назад");
    return 1;
}

stock Kz_ProcessDeposit(playerid, amount)
{
    if(amount < 1000)
    {

        return 0;
    }
    
    if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), amount))
    {

        return 0;
    }
    
    new balance_before_str[64];
    Kz_GetCoffersBalanceStr(balance_before_str, sizeof(balance_before_str));
    
    new amount_str[32];
    format(amount_str, sizeof(amount_str), "%d", amount);
    Kz_EditCoffersBalance(balance_before_str, amount_str);
    new balance_after_str[64];
    Kz_GetCoffersBalanceStr(balance_after_str, sizeof(balance_after_str));
    
    GivePlayerMoneyEx(playerid, -amount, "Пополнение казны");
    
    Kz_AddCoffersLog(playerid, balance_before_str, balance_after_str, 1, amount);
    
    return 1;
}

stock Kz_ProcessFinanceEdit(playerid, team_id, new_percentage)
{
    if(new_percentage < 50 || new_percentage > 150)
    {

        return 0;
    }
    
    if(!Kz_CanChangeFinancePercentage(team_id, playerid))
    {
        new team_name[32];
        format(team_name, sizeof(team_name), "%s", Kz_GetTeamName(team_id));

        return 0;
    }
    
    new percentage_before = Kz_GetFinancePercentage(team_id);
    if(percentage_before == new_percentage)
    {
        return 0;
    }
    
    Kz_SetFinancePercentage(team_id, new_percentage, playerid);
    Kz_AddFinanceLog(playerid, team_id, percentage_before, new_percentage);
    
    new team_name[32];
    format(team_name, sizeof(team_name), "%s", Kz_GetTeamName(team_id));
    return 1;
}

stock Kz_GetAdjustedWage(playerid)
{
    new team = GetPlayerTeamEx(playerid);
    new job = GetPlayerJob(playerid);
    
    if(team < 1 || team > 7 || job < 1 || job > 10) return 0;
    
    new base_wage = rank_wages[team-1][job-1];
    new percentage = Kz_GetFinancePercentage(team);
    
    new adjusted_wage = (base_wage * percentage) / 100;
    return adjusted_wage;
}

stock Kz_ProcessPayDay(playerid)
{
    new team = GetPlayerTeamEx(playerid);
    new job = GetPlayerJob(playerid);
    
    if(team < 1 || team > 7 || job < 1 || job > 10) return 0;
    
    new base_wage = rank_wages[team-1][job-1];
    new percentage = Kz_GetFinancePercentage(team);
    new adjusted_wage = (base_wage * percentage) / 100;
    
    if(adjusted_wage <= 0) return 0;
    
    new coffers_balance_str[64];
    Kz_GetCoffersBalanceStr(coffers_balance_str, sizeof(coffers_balance_str));
    new coffers_balance = strval(coffers_balance_str);
    new final_wage = adjusted_wage;
    new insufficient_funds = 0;
    new budget_warning = 0;
    
    if(!(TEAM_GOVERNMENT <= GetPlayerTeamEx(playerid) <= TEAM_FSB))
    {
        new total_team_wages = 0;
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && GetPlayerTeamEx(i) == team && GetPlayerJob(i) >= 1 && GetPlayerJob(i) <= 10)
            {
                new player_base_wage = rank_wages[team-1][GetPlayerJob(i)-1];
                new player_percentage = Kz_GetFinancePercentage(team);
                new player_adjusted_wage = (player_base_wage * player_percentage) / 100;
                total_team_wages += player_adjusted_wage;
            }
        }
        
        new coffers_balance_str_cmp[64];
        format(coffers_balance_str_cmp, sizeof(coffers_balance_str_cmp), "%d", coffers_balance);
        if(!GetILPlayerInt(coffers_balance_str_cmp, total_team_wages))
        {
            final_wage = adjusted_wage / 2;
            budget_warning = 1;
            insufficient_funds = 1;
        }
    }
    else
    {
        new coffers_balance_str_cmp2[64];
        format(coffers_balance_str_cmp2, sizeof(coffers_balance_str_cmp2), "%d", coffers_balance);
        if(!GetILPlayerInt(coffers_balance_str_cmp2, final_wage))
        {
            insufficient_funds = 1;
            final_wage = final_wage / 2;
        }
    }
    
    static query[256];
    mysql_format(mysql, query, sizeof(query), "UPDATE PlayersMorallwens SET bank=bank+%d WHERE id=%d LIMIT 1", 
        final_wage, GetPlayerAccountID(playerid));
    mysql_query(mysql, query);
    
    new new_bank = GetPlayerBankMoney(playerid) + final_wage;
    format(g_player[playerid][P_BANK], 21, "%d", new_bank);
    BankLog(playerid, final_wage, "Зарплата");
    
    if(final_wage > 0 && !insufficient_funds)
    {
        new coffers_balance_before_str[64];
        Kz_GetCoffersBalanceStr(coffers_balance_before_str, sizeof(coffers_balance_before_str));
        
        new wage_str[32];
        format(wage_str, sizeof(wage_str), "-%d", final_wage);
        Kz_EditCoffersBalance(coffers_balance_before_str, wage_str);
        new coffers_balance_after_str[64];
        Kz_GetCoffersBalanceStr(coffers_balance_after_str, sizeof(coffers_balance_after_str));
        
        Kz_AddCoffersLog(playerid, coffers_balance_before_str, coffers_balance_after_str, 2, final_wage);
    }
    
    if(insufficient_funds)
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "В казне недостаточно средств для полной выплаты зарплаты {FF6B6B}(-50%)");
    }
    else if(budget_warning)
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "В госс. бюджете недостаток бюджета зарплата урезана(-50%)");
    }
    
    new last_percentage = Kz_GetPlayerLastFinancePerc(playerid);
    if(percentage != 100 && !insufficient_funds && last_percentage != percentage && last_percentage != 0)
    {
        new finance_message[256];
        if(percentage > 100)
        {
            format(finance_message, sizeof(finance_message), "Правительство изменило вам сумму финансирования {FFD700}(+%d%%)", percentage - 100);
        }
        else
        {
            format(finance_message, sizeof(finance_message), "Правительство изменило вам сумму финансирования {FF6B6B}(-%d%%)", 100 - percentage);
        }
        SendClientMessage(playerid, 0xFFFFFFFF, finance_message);
    }
    
    if(last_percentage != percentage)
    {
        Kz_SetPlayerLastFinancePerc(playerid, percentage);
    }
    
    static fmt_str[256];
    format(fmt_str, sizeof(fmt_str), "Зарплата: {66CC00}%s рублей", formatInt(final_wage));
    SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
    
    return 1;
}

forward Kz_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
public Kz_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & 1024) && !(oldkeys & 1024))
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, g_coffers_pos[0], g_coffers_pos[1], g_coffers_pos[2]))
        {
            Kz_ShowCoffersDialog(playerid);
            return 1;
        }
    }
    return 1;
}

forward Kz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public Kz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case COFFERS_DIALOG_MAIN:
        {
            if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT)
            {
                return 1;
            }
            
            if(!response) return 1;
            
            switch(listitem)
            {
                case 0: Kz_ShowDepositDialog(playerid);
                case 1: Kz_ShowCoffersLog(playerid);
                case 2: 
                {
                    if(GetPlayerJob(playerid) >= 10) Kz_ShowFinanceDialog(playerid);
                    else 
                    {
                        return 1;
                    }
                }
                case 3: 
                {
                    if(GetPlayerJob(playerid) >= 10) Kz_ShowFinanceLog(playerid);
                    else 
                    {
                        return 1;
                    }
                }
                case 4: 
                {
                    if(GetPlayerJob(playerid) >= 10) 
                    {
                        Kz_ShowPurchasesDialog(playerid);
                    }
                    else 
                    {
                        return 1;
                    }
                }
                case 5: 
                {
                    if(GetPlayerJob(playerid) >= 10) 
                    {
                        Kz_ShowPurchasesLogDialog(playerid);
                    }
                    else 
                    {
                        return 1;
                    }
                }
            }
        }
        case COFFERS_DIALOG_DEPOSIT:
        {
            if(!response) return 1;
            
            new amount = strval(inputtext);
            Kz_ProcessDeposit(playerid, amount);
        }
        case COFFERS_DIALOG_LOG:
        {
            if(!response)
            {
                Kz_ShowCoffersDialog(playerid);
                return 1;
            }
            return 1;
        }
        case COFFERS_DIALOG_FINANCE:
        {
            if(!response) return 1;
            
            new team_ids[] = {1, 2, 3, 4, 5, 6, 7};
            if(listitem >= 0 && listitem < sizeof(team_ids))
            {
                Kz_ShowFinanceEditDialog(playerid, team_ids[listitem]);
            }
        }
        case COFFERS_DIALOG_FINANCE_LOG:
        {
            if(!response)
            {
                Kz_ShowCoffersDialog(playerid);
                return 1;
            }
            return 1;
        }
        case COFFERS_DIALOG_FINANCE_EDIT:
        {
            if(!response) return 1;
            
            new new_percentage = strval(inputtext);
            new team_id = GetPVarInt(playerid, "editing_team_id");
            DeletePVar(playerid, "editing_team_id");
            
            Kz_ProcessFinanceEdit(playerid, team_id, new_percentage);
        }
        case COFFERS_DIALOG_PURCHASES:
        {
            if(!response)
            {
                Kz_ShowCoffersDialog(playerid);
                return 1;
            }
            
            static query_str[256];
            mysql_format(mysql, query_str, sizeof(query_str), "SELECT id, owner_id, org_id, model_id, price, created_at FROM org_car_requests WHERE status = 0 ORDER BY id ASC LIMIT %d, 1", listitem);
            new Cache:result = mysql_query(mysql, query_str, true);
            
            if(cache_num_rows() > 0)
            {
                new request_id = cache_get_field_content_int(0, "id");
                new owner_id = cache_get_field_content_int(0, "owner_id");
                new org_id_local = cache_get_field_content_int(0, "org_id");
                new model_id_local = cache_get_field_content_int(0, "model_id");
                new price = cache_get_field_content_int(0, "price");
                
                new created_at_str[32];
                created_at_str[0] = EOS;
                cache_get_field_content(0, "created_at", created_at_str, mysql, sizeof(created_at_str));
                
                new created_date[32];
                if(strlen(created_at_str) > 0)
                {
                    format(created_date, sizeof(created_date), "%s", created_at_str);
                }
                else
                {
                    format(created_date, sizeof(created_date), "Неизвестно");
                }
                
                new owner_name[24] = "Неизвестно";
                static name_query[128];
                mysql_format(mysql, name_query, sizeof(name_query), "SELECT name FROM PlayersMorallwens WHERE id = %d LIMIT 1", owner_id);
                new Cache:name_result = mysql_query(mysql, name_query, true);
                if(cache_num_rows() > 0)
                {
                    cache_get_field_content(0, "name", owner_name, mysql, sizeof(owner_name));
                }
                cache_delete(name_result);
                
                new org_name[32];
                new team_name_temp[32];
                format(team_name_temp, sizeof(team_name_temp), "%s", Kz_GetTeamName(org_id_local));
                format(org_name, sizeof(org_name), "%s", team_name_temp);
                
                new vehicle_name_local[32];
                format(vehicle_name_local, sizeof(vehicle_name_local), "%s", GetVehicleInfo(model_id_local, VI_NAME));
                
                format(g_dialogTextSmall, sizeof(g_dialogTextSmall),
					"{ffffff}Лидер %s %s, запрашивает разрешение (№%d) на приобретение {deff69}%s{ffffff}\nдля нужд организации на сумму {006400}%s{ffffff} рублей. Если желаете рассмотреть запрос, нажмите `Далее`.",
					org_name, owner_name, request_id, vehicle_name_local, formatInt(price), created_date);
				
				SetPVarInt(playerid, "Kz_SelectedRequestID", request_id);
				Dialog(playerid, COFFERS_DIALOG_PURCHASES_INFO, DIALOG_STYLE_MSGBOX, "Информация о закупке", g_dialogTextSmall, "Далее", "Назад");
            }
            else
            {
                Kz_ShowPurchasesDialog(playerid);
            }
            
            cache_delete(result);
            return 1;
        }
        case COFFERS_DIALOG_PURCHASES_INFO:
        {
            if(!response)
            {
                Kz_ShowPurchasesDialog(playerid);
                return 1;
            }
            
            new request_id = GetPVarInt(playerid, "Kz_SelectedRequestID");
            DeletePVar(playerid, "Kz_SelectedRequestID");
            
            if(request_id <= 0)
            {
                Kz_ShowPurchasesDialog(playerid);
                return 1;
            }
            
            format(g_dialogTextSmall, sizeof(g_dialogTextSmall), "- Одобрить\n- Отказать"); 
            SetPVarInt(playerid, "Kz_SelectedRequestID", request_id);
            Dialog(playerid, COFFERS_DIALOG_PURCHASES_REVIEW, DIALOG_STYLE_LIST, "Рассмотрение заявки", g_dialogTextSmall, "Выбрать", "Назад");
            return 1;
        }
        case COFFERS_DIALOG_PURCHASES_REVIEW:
        {
            if(!response)
            {
                DeletePVar(playerid, "Kz_SelectedRequestID");
                Kz_ShowPurchasesDialog(playerid);
                return 1;
            }
            
            new request_id = GetPVarInt(playerid, "Kz_SelectedRequestID");
            DeletePVar(playerid, "Kz_SelectedRequestID");
            
            if(request_id <= 0)
            {
                Kz_ShowPurchasesDialog(playerid);
                return 1;
            }
            
            if(listitem == 0) 
            {
                static query_review[256];
                mysql_format(mysql, query_review, sizeof(query_review), "SELECT owner_id, org_id, model_id, price, toner, color, pj FROM org_car_requests WHERE id = %d LIMIT 1", request_id);
                new Cache:result = mysql_query(mysql, query_review, true);
                
                if(cache_num_rows() > 0)
                {
                    new owner_id = cache_get_field_content_int(0, "owner_id");
                    new org_id_local2 = cache_get_field_content_int(0, "org_id");
                    new model_id_local2 = cache_get_field_content_int(0, "model_id");
                    new price = cache_get_field_content_int(0, "price");
                    new toner = cache_get_field_content_int(0, "toner");
                    new color = cache_get_field_content_int(0, "color");
                    new pj = cache_get_field_content_int(0, "pj");
                    
                    new owner_name[24] = "NULL";
                    static name_query[128];
                    mysql_format(mysql, name_query, sizeof(name_query), "SELECT name FROM PlayersMorallwens WHERE id = %d LIMIT 1", owner_id);
                    new Cache:name_result = mysql_query(mysql, name_query, true);
                    if(cache_num_rows() > 0)
                    {
                        cache_get_field_content(0, "name", owner_name, mysql, sizeof(owner_name));
                    }
                    cache_delete(name_result);
                    
                    new org_name[32];
                    new team_name_temp2[32];
                    format(team_name_temp2, sizeof(team_name_temp2), "%s", Kz_GetTeamName(org_id_local2));
                    format(org_name, sizeof(org_name), "%s", team_name_temp2);
                    
                    new reviewer_name[24];
                    format(reviewer_name, sizeof(reviewer_name), "%s", GetPlayerNameEx(playerid));
                    
                    new update_query[256];
                    mysql_format(mysql, update_query, sizeof(update_query), "UPDATE org_car_requests SET status = 1 WHERE id = %d", request_id);
                    mysql_tquery(mysql, update_query);
                    
                    static log_query[512];
                    mysql_format(mysql, log_query, sizeof(log_query),
                        "INSERT INTO org_car_purchases_log (reviewer_name, organization, leader, vehicle_id, date, status) VALUES ('%e', '%e', '%e', %d, NOW(), 'Одобрено')",
                        reviewer_name, org_name, owner_name, model_id_local2);
                    mysql_tquery(mysql, log_query);
                    
                    new create_query[512];
                    mysql_format(mysql, create_query, sizeof(create_query),
                        "INSERT INTO org_cars (model_id, owner_id, price, toner, color, pj, created_at) VALUES (%d, %d, %d, %d, %d, %d, NOW())",
                        model_id_local2, owner_id, price, toner, color, pj);
                    mysql_tquery(mysql, create_query);
                }
                else
                {
                    return 1;
                }
                
                cache_delete(result);
            }
            else if(listitem == 1)
            {
                format(g_dialogTextSmall, sizeof(g_dialogTextSmall), "Введите причину отказа:");
                SetPVarInt(playerid, "Kz_SelectedRequestID", request_id);
                Dialog(playerid, COFFERS_DIALOG_PURCHASES_REJECT, DIALOG_STYLE_INPUT, "Причина отказа", g_dialogTextSmall, "Отказать", "Назад");
                return 1;
            }
            
            return 1;
        }
        case COFFERS_DIALOG_PURCHASES_REJECT:
        {
            if(!response)
            {
                new request_id = GetPVarInt(playerid, "Kz_SelectedRequestID");
                DeletePVar(playerid, "Kz_SelectedRequestID");
                
                if(request_id > 0)
                {
                    format(g_dialogTextSmall, sizeof(g_dialogTextSmall), "- Одобрить\n- Отказать");
                    SetPVarInt(playerid, "Kz_SelectedRequestID", request_id);
                    Dialog(playerid, COFFERS_DIALOG_PURCHASES_REVIEW, DIALOG_STYLE_LIST, "Рассмотрение заявки", g_dialogTextSmall, "Выбрать", "Назад");
                }
                return 1;
            }
            
            if(strlen(inputtext) < 3)
            {
                format(g_dialogTextSmall, sizeof(g_dialogTextSmall), "Введите причину отказа:");
                Dialog(playerid, COFFERS_DIALOG_PURCHASES_REJECT, DIALOG_STYLE_INPUT, "Причина отказа", g_dialogTextSmall, "Отказать", "Назад");
                return 1;
            }
            
            new request_id = GetPVarInt(playerid, "Kz_SelectedRequestID");
            DeletePVar(playerid, "Kz_SelectedRequestID");
            
            if(request_id <= 0)
            {
                Kz_ShowPurchasesDialog(playerid);
                return 1;
            }
            
            static query_str2[256];
            mysql_format(mysql, query_str2, sizeof(query_str2), "SELECT owner_id, org_id, model_id FROM org_car_requests WHERE id = %d LIMIT 1", request_id);
            new Cache:result = mysql_query(mysql, query_str2, true);
            
            if(cache_num_rows() > 0)
            {
                new owner_id = cache_get_field_content_int(0, "owner_id");
                new org_id_local3 = cache_get_field_content_int(0, "org_id");
                new model_id_local3 = cache_get_field_content_int(0, "model_id");
                
                new owner_name[24] = "NULL";
                static name_query[128];
                mysql_format(mysql, name_query, sizeof(name_query), "SELECT name FROM PlayersMorallwens WHERE id = %d LIMIT 1", owner_id);
                new Cache:name_result = mysql_query(mysql, name_query, true);
                if(cache_num_rows() > 0)
                {
                    cache_get_field_content(0, "name", owner_name, mysql, sizeof(owner_name));
                }
                cache_delete(name_result);
                
                new org_name[32];
                new team_name_temp3[32];
                format(team_name_temp3, sizeof(team_name_temp3), "%s", Kz_GetTeamName(org_id_local3));
                format(org_name, sizeof(org_name), "%s", team_name_temp3);
                
                new reviewer_name[24];
                format(reviewer_name, sizeof(reviewer_name), "%s", GetPlayerNameEx(playerid));
                
                static update_query[256];
                mysql_format(mysql, update_query, sizeof(update_query), "UPDATE org_car_requests SET status = 2 WHERE id = %d", request_id);
                mysql_tquery(mysql, update_query);
                
                static reason[128];
                mysql_escape_string(inputtext, reason);
                static log_query[512];
                mysql_format(mysql, log_query, sizeof(log_query),
                    "INSERT INTO org_car_purchases_log (reviewer_name, organization, leader, vehicle_id, date, status) VALUES ('%e', '%e', '%e', %d, NOW(), 'Отказано. Причина: %e')",
                    reviewer_name, org_name, owner_name, model_id_local3, reason);
                mysql_tquery(mysql, log_query);
                
            }
            else
            {
                return 1;
            }
            
            cache_delete(result);
            Kz_ShowPurchasesDialog(playerid);
            return 1;
        }
        case COFFERS_DIALOG_PURCHASES_LOG:
        {
            if(!response)
            {
                Kz_ShowCoffersDialog(playerid);
                return 1;
            }
            return 1;
        }
    }
    return 1;
}

forward Kz_OnPlayerConnect(playerid);
public Kz_OnPlayerConnect(playerid)
{
    Kz_UpdateCoffers3DText();
    return 1;
}

cmd:null_c(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 10)
    {
        return 1;
    }
    
    new team_ids[] = {1, 2, 3, 4, 5, 6, 7};
    for(new i = 0; i < sizeof(team_ids); i++)
    {
        new pvar_name[32];
        format(pvar_name, sizeof(pvar_name), "finance_cd_%d", team_ids[i]);
        DeletePVar(playerid, pvar_name);
    }
    
    return 1;
}
