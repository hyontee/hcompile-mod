#if defined _faction_system_included
    #endinput
#endif
#define _faction_system_included

#define FRACTION_NONE 0
#define FRACTION_GIBDD 1
#define FRACTION_UMVD 2
#define FRACTION_ARMY 3
#define FRACTION_FSB 4
#define FRACTION_FSIN 5
#define FRACTION_HOSPITAL 6
#define FRACTION_GOVERNMENT 7
#define FRACTION_NEWS 8

enum E_FRACTION_DATA
{
    frac_name[32],
    frac_rank_names[10][32],
    frac_rank_exp[10],
    frac_color
}

enum E_PLAYER_FRAC
{
    p_frac_id,
    p_frac_rank,
    p_frac_exp,
    p_frac_tokens,
    p_frac_duty,
    p_frac_mission,
    p_frac_mission_progress
}

new FractionData[9][E_FRACTION_DATA] = {
    {"", {""}, {0}, 0xFFFFFFFF},
    
    {"ГИБДД",
        {"Рядовой", "Младший сержант", "Сержант", "Старший сержант",
         "Прапорщик", "Лейтенант", "Капитан", "Майор",
         "Подполковник", "Полковник"},
        {0, 100, 250, 450, 700, 1000, 1350, 1750, 2200, 2700},
        0x6B8E23FF},
    
    {"МВД",
        {"Рядовой", "Младший сержант", "Сержант", "Старший сержант",
         "Прапорщик", "Лейтенант", "Капитан", "Майор",
         "Подполковник", "Полковник"},
        {0, 120, 280, 500, 780, 1100, 1480, 1920, 2420, 3000},
        0x4169E1FF},
    
    {"Армия",
        {"Рядовой", "Ефрейтор", "Сержант", "Старший сержант",
         "Прапорщик", "Лейтенант", "Капитан", "Майор",
         "Подполковник", "Полковник"},
        {0, 80, 200, 350, 550, 800, 1100, 1450, 1850, 2300},
        0x228B22FF},
    
    {"ФСБ",
        {"Рядовой", "Сержант", "Старший сержант", "Старшина",
         "Прапорщик", "Лейтенант", "Капитан", "Майор",
         "Подполковник", "Полковник"},
        {0, 150, 300, 500, 750, 1050, 1400, 1800, 2250, 2800},
        0x1E90FFFF},
    
    {"ФСИН",
        {"Рядовой", "Сержант", "Старший сержант", "Старшина",
         "Прапорщик", "Лейтенант", "Капитан", "Майор",
         "Подполковник", "Полковник"},
        {0, 110, 240, 400, 600, 850, 1150, 1500, 1900, 2400},
        0x8B4513FF},
    
    {"Больница",
        {"Интерн", "Медбрат", "Медсестра", "Фельдшер",
         "Врач", "Терапевт", "Хирург", "Заведующий",
         "Замглавврача", "Главврач"},
        {0, 70, 160, 280, 430, 620, 840, 1100, 1400, 1750},
        0xFF69B4FF},
    
    {"Правительство",
        {"Водитель", "Охранник", "Секретарь", "Советник",
         "Начальник отдела", "Лицензиар", "Адвокат", "Замгубернатора",
         "Вице-губернатор", "Губернатор"},
        {0, 130, 280, 450, 650, 880, 1150, 1480, 1850, 2300},
        0xFFD700FF},
    
    {"Новости",
        {"Стажёр", "Корреспондент", "Оператор", "Редактор",
         "Продюсер", "Шеф-редактор", "Замдиректора", "Директор",
         "Главный редактор", "Издатель"},
        {0, 50, 120, 210, 320, 450, 600, 780, 980, 1250},
        0xFF4500FF}
};

new PlayerFrac[MAX_PLAYERS][E_PLAYER_FRAC];
new FactionMembers[MAX_FRACTIONS][MAX_PLAYERS];
new FactionMemberCount[MAX_FRACTIONS];
new FactionVehicles[MAX_FRACTIONS][20];
new FactionVehicleCount[MAX_FRACTIONS];
new FactionWarehouse[MAX_FRACTIONS][20][2];

stock GetFractionName(fraction_id)
{
    if(fraction_id < 0 || fraction_id > 8) return "";
    return FractionData[fraction_id][frac_name];
}

stock GetRankName(fraction_id, rank)
{
    if(fraction_id < 1 || fraction_id > 8) return "";
    if(rank < 1 || rank > 10) return "";
    return FractionData[fraction_id][frac_rank_names][rank-1];
}

stock GetRankExpReq(fraction_id, rank)
{
    if(fraction_id < 1 || fraction_id > 8) return 0;
    if(rank < 2 || rank > 10) return 0;
    return FractionData[fraction_id][frac_rank_exp][rank-1];
}

stock GetFractionColor(fraction_id)
{
    if(fraction_id < 1 || fraction_id > 8) return 0xFFFFFFFF;
    return FractionData[fraction_id][frac_color];
}

stock AddPlayerToFraction(playerid, fraction_id, rank)
{
    if(fraction_id < 1 || fraction_id > 8) return 0;
    if(rank < 1 || rank > 10) return 0;
    
    PlayerFrac[playerid][p_frac_id] = fraction_id;
    PlayerFrac[playerid][p_frac_rank] = rank;
    PlayerFrac[playerid][p_frac_exp] = 0;
    PlayerFrac[playerid][p_frac_tokens] = 0;
    PlayerFrac[playerid][p_frac_duty] = 0;
    PlayerFrac[playerid][p_frac_mission] = 0;
    PlayerFrac[playerid][p_frac_mission_progress] = 0;
    
    FactionMembers[fraction_id][FactionMemberCount[fraction_id]] = playerid;
    FactionMemberCount[fraction_id]++;
    
    new string[128];
    format(string, sizeof(string), "Вы вступили во фракцию %s в звании %s", 
        GetFractionName(fraction_id), GetRankName(fraction_id, rank));
    SendClientMessage(playerid, GetFractionColor(fraction_id), string);
    
    return 1;
}

stock RemovePlayerFromFraction(playerid)
{
    new fraction_id = PlayerFrac[playerid][p_frac_id];
    if(fraction_id == FRACTION_NONE) return 0;
    
    for(new i = 0; i < FactionMemberCount[fraction_id]; i++)
    {
        if(FactionMembers[fraction_id][i] == playerid)
        {
            for(new j = i; j < FactionMemberCount[fraction_id] - 1; j++)
            {
                FactionMembers[fraction_id][j] = FactionMembers[fraction_id][j+1];
            }
            FactionMemberCount[fraction_id]--;
            break;
        }
    }
    
    PlayerFrac[playerid][p_frac_id] = FRACTION_NONE;
    PlayerFrac[playerid][p_frac_rank] = 0;
    PlayerFrac[playerid][p_frac_exp] = 0;
    PlayerFrac[playerid][p_frac_tokens] = 0;
    PlayerFrac[playerid][p_frac_duty] = 0;
    
    SetPlayerColor(playerid, 0xFFFFFFFF);
    
    SendClientMessage(playerid, 0xFF0000FF, "Вы покинули фракцию");
    return 1;
}

stock CheckPlayerRankUp(playerid)
{
    new fraction_id = PlayerFrac[playerid][p_frac_id];
    new current_rank = PlayerFrac[playerid][p_frac_rank];
    
    if(fraction_id == FRACTION_NONE) return 0;
    if(current_rank >= 10) return 0;
    
    new required_exp = GetRankExpReq(fraction_id, current_rank + 1);
    
    if(PlayerFrac[playerid][p_frac_exp] >= required_exp)
    {
        PlayerFrac[playerid][p_frac_rank]++;
        
        new string[128];
        format(string, sizeof(string), "Поздравляем! Вы повышены до звания %s", 
            GetRankName(fraction_id, PlayerFrac[playerid][p_frac_rank]));
        SendClientMessage(playerid, GetFractionColor(fraction_id), string);
        
        return 1;
    }
    return 0;
}

stock AddFractionExp(playerid, exp)
{
    if(PlayerFrac[playerid][p_frac_id] == FRACTION_NONE) return 0;
    if(!PlayerFrac[playerid][p_frac_duty]) return 0;
    
    PlayerFrac[playerid][p_frac_exp] += exp;
    
    new string[64];
    format(string, sizeof(string), "+%d опыта фракции", exp);
    SendClientMessage(playerid, 0x00FF00FF, string);
    
    CheckPlayerRankUp(playerid);
    
    return 1;
}

stock AddFractionTokens(playerid, tokens)
{
    if(PlayerFrac[playerid][p_frac_id] == FRACTION_NONE) return 0;
    
    PlayerFrac[playerid][p_frac_tokens] += tokens;
    
    new string[64];
    format(string, sizeof(string), "+%d организационных жетонов", tokens);
    SendClientMessage(playerid, 0x00FF00FF, string);
    
    return 1;
}

stock StartFractionDuty(playerid)
{
    if(PlayerFrac[playerid][p_frac_id] == FRACTION_NONE)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы не состоите во фракции");
        return 0;
    }
    
    if(PlayerFrac[playerid][p_frac_duty])
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы уже на службе");
        return 0;
    }
    
    PlayerFrac[playerid][p_frac_duty] = 1;
    SetPlayerColor(playerid, GetFractionColor(PlayerFrac[playerid][p_frac_id]));
    
    SendClientMessage(playerid, 0x00FF00FF, "Вы приступили к службе");
    return 1;
}

stock EndFractionDuty(playerid)
{
    if(!PlayerFrac[playerid][p_frac_duty]) return 0;
    
    PlayerFrac[playerid][p_frac_duty] = 0;
    SetPlayerColor(playerid, 0xFFFFFFFF);
    
    SendClientMessage(playerid, 0x00FF00FF, "Вы закончили службу");
    return 1;
}

stock StartFractionMission(playerid, mission_id)
{
    if(PlayerFrac[playerid][p_frac_id] == FRACTION_NONE) return 0;
    if(!PlayerFrac[playerid][p_frac_duty]) return 0;
    if(PlayerFrac[playerid][p_frac_mission] != 0) return 0;
    
    PlayerFrac[playerid][p_frac_mission] = mission_id;
    PlayerFrac[playerid][p_frac_mission_progress] = 0;
    
    new mission_name[64];
    if(mission_id == 1) mission_name = "Патрулирование";
    else if(mission_id == 2) mission_name = "Пост ДПС";
    else mission_name = "Задержание";
    
    new string[128];
    format(string, sizeof(string), "Вы начали задание: %s", mission_name);
    SendClientMessage(playerid, 0x00FF00FF, string);
    
    return 1;
}

stock UpdateMissionProgress(playerid, amount)
{
    if(PlayerFrac[playerid][p_frac_mission] == 0) return 0;
    
    PlayerFrac[playerid][p_frac_mission_progress] += amount;
    
    new required = 0;
    new reward_exp = 0;
    new reward_tokens = 0;
    
    if(PlayerFrac[playerid][p_frac_mission] == 1)
    {
        required = 30;
        reward_exp = 50;
        reward_tokens = 25;
    }
    else if(PlayerFrac[playerid][p_frac_mission] == 2)
    {
        required = 15;
        reward_exp = 75;
        reward_tokens = 35;
    }
    else if(PlayerFrac[playerid][p_frac_mission] == 3)
    {
        required = 5;
        reward_exp = 100;
        reward_tokens = 50;
    }
    
    if(PlayerFrac[playerid][p_frac_mission_progress] >= required)
    {
        AddFractionExp(playerid, reward_exp);
        AddFractionTokens(playerid, reward_tokens);
        
        SendClientMessage(playerid, 0x00FF00FF, "Задание выполнено!");
        
        PlayerFrac[playerid][p_frac_mission] = 0;
        PlayerFrac[playerid][p_frac_mission_progress] = 0;
    }
    
    return 1;
}

stock ShowFractionMembers(playerid)
{
    new fraction_id = PlayerFrac[playerid][p_frac_id];
    if(fraction_id == FRACTION_NONE) return 0;
    
    new count = 0;
    new string[1024];
    strcat(string, "Сотрудники фракции:\n");
    
    for(new i = 0; i < FactionMemberCount[fraction_id]; i++)
    {
        new memberid = FactionMembers[fraction_id][i];
        if(IsPlayerConnected(memberid))
        {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(memberid, name, sizeof(name));
            
            new line[128];
            format(line, sizeof(line), "%d. %s - %s %s\n", ++count, name, 
                GetRankName(fraction_id, PlayerFrac[memberid][p_frac_rank]),
                PlayerFrac[memberid][p_frac_duty] ? "[На службе]" : "");
            strcat(string, line);
        }
    }
    
    ShowPlayerDialog(playerid, 100, DIALOG_STYLE_MSGBOX, "Сотрудники", string, "Закрыть", "");
    return 1;
}

stock SpawnFactionVehicle(playerid)
{
    new fraction_id = PlayerFrac[playerid][p_frac_id];
    if(fraction_id == FRACTION_NONE) return 0;
    
    new vehicle_models[4] = {596, 597, 598, 599};
    new model = vehicle_models[random(4)];
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    new veh = CreateVehicle(model, x+5, y+2, z, 0.0, -1, -1, 60000);
    PutPlayerInVehicle(playerid, veh, 0);
    
    FactionVehicles[fraction_id][FactionVehicleCount[fraction_id]] = veh;
    FactionVehicleCount[fraction_id]++;
    
    SendClientMessage(playerid, 0x00FF00FF, "Служебный транспорт выдан");
    return 1;
}

stock ShowWarehouseMenu(playerid)
{
    new fraction_id = PlayerFrac[playerid][p_frac_id];
    if(fraction_id == FRACTION_NONE) return 0;
    
    new string[512];
    format(string, sizeof(string),
        "Склад фракции %s\n\
        \nВаши жетоны: %d\n\
        \n1. Аптечка - 10 жетонов\n\
        2. Бронежилет - 20 жетонов\n\
        3. Ремкомплект - 15 жетонов\n\
        4. Радар - 30 жетонов",
        GetFractionName(fraction_id), PlayerFrac[playerid][p_frac_tokens]);
    
    ShowPlayerDialog(playerid, 101, DIALOG_STYLE_LIST, "Склад фракции", string, "Купить", "Закрыть");
    return 1;
}

stock ShowFractionMenu(playerid)
{
    if(PlayerFrac[playerid][p_frac_id] == FRACTION_NONE)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы не состоите во фракции");
        return 0;
    }
    
    new fraction_id = PlayerFrac[playerid][p_frac_id];
    new player_rank = PlayerFrac[playerid][p_frac_rank];
    new player_exp = PlayerFrac[playerid][p_frac_exp];
    
    new Node:json = JSON_Object();
    
    JSON_SetInt(json, "page", 1);
    JSON_SetString(json, "fraction_name", FractionData[fraction_id][frac_name]);
    JSON_SetInt(json, "fraction_id", fraction_id);
    JSON_SetInt(json, "fraction_color", FractionData[fraction_id][frac_color]);
    JSON_SetInt(json, "player_rank", player_rank);
    JSON_SetString(json, "player_rank_name", GetRankName(fraction_id, player_rank));
    JSON_SetInt(json, "player_exp", player_exp);
    JSON_SetInt(json, "player_tokens", PlayerFrac[playerid][p_frac_tokens]);
    JSON_SetInt(json, "player_duty", PlayerFrac[playerid][p_frac_duty]);
    
    new next_rank = (player_rank < 10) ? player_rank + 1 : 10;
    new required_exp = (player_rank < 10) ? GetRankExpReq(fraction_id, next_rank) : 0;
    new current_progress = 0;
    
    if(player_rank < 10 && required_exp > 0)
    {
        current_progress = (player_exp * 100) / required_exp;
        if(current_progress > 100) current_progress = 100;
    }
    
    JSON_SetInt(json, "next_rank", next_rank);
    JSON_SetString(json, "next_rank_name", GetRankName(fraction_id, next_rank));
    JSON_SetInt(json, "next_rank_exp", required_exp);
    JSON_SetInt(json, "progress_percent", current_progress);
    
    new Node:ranks_table = JSON_Array();
    
    for(new i = 1; i <= 10; i++)
    {
        new Node:rank_item = JSON_Object();
        
        JSON_SetInt(rank_item, "id", i);
        JSON_SetString(rank_item, "name", GetRankName(fraction_id, i));
        
        new exp_req = GetRankExpReq(fraction_id, i);
        JSON_SetInt(rank_item, "exp_required", exp_req);
        
        new is_available = (player_rank >= i) ? 1 : 0;
        JSON_SetInt(rank_item, "available", is_available);
        
        new is_current = (player_rank == i) ? 1 : 0;
        JSON_SetInt(rank_item, "current", is_current);
        
        new rank_progress = 0;
        if(i == player_rank + 1 && player_rank < 10)
        {
            if(exp_req > 0)
            {
                rank_progress = (player_exp * 100) / exp_req;
                if(rank_progress > 100) rank_progress = 100;
            }
        }
        else if(player_rank >= i)
        {
            rank_progress = 100;
        }
        JSON_SetInt(rank_item, "progress", rank_progress);
        
        JSON_AddArray(ranks_table, rank_item);
        JSON_Cleanup(rank_item);
    }
    
    JSON_SetArray(json, "ranks", ranks_table);
    JSON_Cleanup(ranks_table);
    
    new Node:missions = JSON_Array();
    
    new Node:mission1 = JSON_Object();
    JSON_SetString(mission1, "name", "Патрулирование");
    JSON_SetString(mission1, "desc", "Патрулируйте город 30 минут");
    JSON_SetInt(mission1, "reward_exp", 50);
    JSON_SetInt(mission1, "reward_tokens", 25);
    JSON_SetInt(mission1, "progress", PlayerFrac[playerid][p_frac_mission] == 1 ? PlayerFrac[playerid][p_frac_mission_progress] : 0);
    JSON_AddArray(missions, mission1);
    JSON_Cleanup(mission1);
    
    new Node:mission2 = JSON_Object();
    JSON_SetString(mission2, "name", "Пост ДПС");
    JSON_SetString(mission2, "desc", "Остановите 15 автомобилей");
    JSON_SetInt(mission2, "reward_exp", 75);
    JSON_SetInt(mission2, "reward_tokens", 35);
    JSON_SetInt(mission2, "progress", PlayerFrac[playerid][p_frac_mission] == 2 ? PlayerFrac[playerid][p_frac_mission_progress] : 0);
    JSON_AddArray(missions, mission2);
    JSON_Cleanup(mission2);
    
    new Node:mission3 = JSON_Object();
    JSON_SetString(mission3, "name", "Задержание");
    JSON_SetString(mission3, "desc", "Задержите 5 нарушителей");
    JSON_SetInt(mission3, "reward_exp", 100);
    JSON_SetInt(mission3, "reward_tokens", 50);
    JSON_SetInt(mission3, "progress", PlayerFrac[playerid][p_frac_mission] == 3 ? PlayerFrac[playerid][p_frac_mission_progress] : 0);
    JSON_AddArray(missions, mission3);
    JSON_Cleanup(mission3);
    
    JSON_SetArray(json, "daily_missions", missions);
    JSON_Cleanup(missions);
    
    if(player_rank >= 8)
    {
        new Node:admin_panel = JSON_Object();
        JSON_SetInt(admin_panel, "can_manage_ranks", 1);
        JSON_SetInt(admin_panel, "can_manage_members", 1);
        JSON_SetInt(admin_panel, "can_manage_vehicles", 1);
        JSON_SetInt(admin_panel, "can_manage_warehouse", 1);
        JSON_SetObject(json, "admin_panel", admin_panel);
        JSON_Cleanup(admin_panel);
    }
    
    ShowPlayerGUI(playerid, 46, json);
    
    JSON_Cleanup(json);
    JSON_Cleanup(ranks_table);
    
    return 1;
}

public OnPlayerGUIResponse(playerid, gui_id, response, listitem, inputtext[])
{
    if(gui_id == 46)
    {
        switch(response)
        {
            case 1:
            {
                new string[512];
                format(string, sizeof(string),
                    "Ваша статистика\n\
                    \nФракция: %s\n\
                    Звание: %s\n\
                    Опыт: %d\n\
                    Жетоны: %d\n\
                    Заданий выполнено: 0\n\
                    На службе: %s",
                    GetFractionName(PlayerFrac[playerid][p_frac_id]),
                    GetRankName(PlayerFrac[playerid][p_frac_id], PlayerFrac[playerid][p_frac_rank]),
                    PlayerFrac[playerid][p_frac_exp],
                    PlayerFrac[playerid][p_frac_tokens],
                    PlayerFrac[playerid][p_frac_duty] ? "Да" : "Нет");
                ShowPlayerDialog(playerid, 102, DIALOG_STYLE_MSGBOX, "Моя статистика", string, "Закрыть", "");
            }
            case 2: ShowFractionMembers(playerid);
            case 3: SpawnFactionVehicle(playerid);
            case 4: ShowWarehouseMenu(playerid);
            case 5:
            {
                new string[256];
                format(string, sizeof(string),
                    "Магазин жетонов\n\
                    \nВаши жетоны: %d\n\
                    \n1. Удостоверение - 50 жетонов\n\
                    2. Сирена - 75 жетонов\n\
                    3. Броня - 100 жетонов\n\
                    4. Оружие - 150 жетонов",
                    PlayerFrac[playerid][p_frac_tokens]);
                ShowPlayerDialog(playerid, 103, DIALOG_STYLE_LIST, "Жетоны", string, "Купить", "Закрыть");
            }
            case 6:
            {
                if(PlayerFrac[playerid][p_frac_rank] < 10)
                {
                    new required = GetRankExpReq(PlayerFrac[playerid][p_frac_id], PlayerFrac[playerid][p_frac_rank] + 1);
                    if(PlayerFrac[playerid][p_frac_exp] >= required)
                    {
                        PlayerFrac[playerid][p_frac_rank]++;
                        SendClientMessage(playerid, 0x00FF00FF, "Поздравляем с повышением!");
                        ShowFractionMenu(playerid);
                    }
                    else
                    {
                        SendClientMessage(playerid, 0xFF0000FF, "Недостаточно опыта для повышения");
                    }
                }
            }
        }
        return 1;
    }
    
    if(gui_id == 101)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(PlayerFrac[playerid][p_frac_tokens] >= 10)
                    {
                        PlayerFrac[playerid][p_frac_tokens] -= 10;
                        GivePlayerHealth(playerid, 100);
                        SendClientMessage(playerid, 0x00FF00FF, "Вы купили аптечку");
                    }
                    else SendClientMessage(playerid, 0xFF0000FF, "Недостаточно жетонов");
                }
                case 1:
                {
                    if(PlayerFrac[playerid][p_frac_tokens] >= 20)
                    {
                        PlayerFrac[playerid][p_frac_tokens] -= 20;
                        SetPlayerArmour(playerid, 100);
                        SendClientMessage(playerid, 0x00FF00FF, "Вы купили бронежилет");
                    }
                    else SendClientMessage(playerid, 0xFF0000FF, "Недостаточно жетонов");
                }
                case 2:
                {
                    if(PlayerFrac[playerid][p_frac_tokens] >= 15)
                    {
                        PlayerFrac[playerid][p_frac_tokens] -= 15;
                        SendClientMessage(playerid, 0x00FF00FF, "Вы купили ремкомплект");
                    }
                    else SendClientMessage(playerid, 0xFF0000FF, "Недостаточно жетонов");
                }
                case 3:
                {
                    if(PlayerFrac[playerid][p_frac_tokens] >= 30)
                    {
                        PlayerFrac[playerid][p_frac_tokens] -= 30;
                        SendClientMessage(playerid, 0x00FF00FF, "Вы получили радар");
                    }
                    else SendClientMessage(playerid, 0xFF0000FF, "Недостаточно жетонов");
                }
            }
            ShowWarehouseMenu(playerid);
        }
        return 1;
    }
    
    return 1;
}