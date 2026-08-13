// ==========================================
// СИСТЕМА ИНВЕНТАРЯ (ДИАЛОГОВАЯ ВЕРСИЯ)
// ==========================================

#if defined _inventory_dialog_included
    #endinput
#endif
#define _inventory_dialog_included

// Диалоги
#define DIALOG_INVENTORY_MAIN   51000
#define DIALOG_INVENTORY_ITEM   51001

// Типы предметов
#define ITEM_TYPE_FOOD          1
#define ITEM_TYPE_MEDKIT        2
#define ITEM_TYPE_ARMOR         3
#define ITEM_TYPE_OTHER         0

// Временные массивы для хранения инвентаря
static inv_id[MAX_PLAYERS][50];
static inv_name[MAX_PLAYERS][50][64];
static inv_type[MAX_PLAYERS][50];
static inv_value[MAX_PLAYERS][50];
static inv_count[MAX_PLAYERS][50];
static inv_desc[MAX_PLAYERS][50][255];
static inv_rows[MAX_PLAYERS];

// Загрузка инвентаря
stock Inv_Load(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT id, item_name, item_type, item_value, item_count, item_desc FROM player_inventory WHERE player_id = %d",
        GetPlayerAccountID(playerid));
    new Cache:res = mysql_query(mysql, query, true);
    
    inv_rows[playerid] = cache_num_rows();
    if(inv_rows[playerid] > 50) inv_rows[playerid] = 50;
    
    new temp[128];
    for(new i = 0; i < inv_rows[playerid]; i++)
    {
        inv_id[playerid][i] = cache_get_field_content_int(i, "id");
        
        cache_get_field_content(i, "item_name", temp, mysql, 64);
        format(inv_name[playerid][i], 64, "%s", temp);
        
        inv_type[playerid][i] = cache_get_field_content_int(i, "item_type");
        inv_value[playerid][i] = cache_get_field_content_int(i, "item_value");
        inv_count[playerid][i] = cache_get_field_content_int(i, "item_count");
        
        cache_get_field_content(i, "item_desc", temp, mysql, 255);
        format(inv_desc[playerid][i], 255, "%s", temp);
    }
    
    cache_delete(res);
    return 1;
}

// Показать главное меню инвентаря
stock Inv_ShowMain(playerid)
{
    if(inv_rows[playerid] == 0)
    {
        SendClientMessage(playerid, -1, "{ff0000}[Инвентарь]{ffffff} Ваш инвентарь пуст");
        return 1;
    }
    
    new dialog_text[4096];
    new line[128];
    
    strcat(dialog_text, "{FAD201}№\t{FAD201}Название\t{FAD201}Кол-во\t{FAD201}Тип\n");
    
    for(new i = 0; i < inv_rows[playerid]; i++)
    {
        new type_name[16];
        if(inv_type[playerid][i] == ITEM_TYPE_FOOD) type_name = "Еда";
        else if(inv_type[playerid][i] == ITEM_TYPE_MEDKIT) type_name = "Аптечка";
        else if(inv_type[playerid][i] == ITEM_TYPE_ARMOR) type_name = "Броня";
        else type_name = "Предмет";
        
        format(line, sizeof line, "%d\t%s\t%d\t%s\n", i + 1, inv_name[playerid][i], inv_count[playerid][i], type_name);
        strcat(dialog_text, line);
    }
    
    ShowPlayerDialog(playerid, DIALOG_INVENTORY_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{ff0000}BLACK RUSSIA{ffffff} | Инвентарь",
        dialog_text,
        "Управление", "Закрыть");
    return 1;
}

// Показать меню действий с предметом
stock Inv_ShowItemMenu(playerid, index)
{
    SetPVarInt(playerid, "inv_selected_index", index);
    
    new dialog_text[512];
    
    format(dialog_text, sizeof dialog_text,
        "{FFFFFF}Предмет: {ffff00}%s{FFFFFF}\n\
        Количество: {ffff00}%d{FFFFFF}\n\
        Описание: {ffff00}%s{FFFFFF}\n\n\
        {FFFFFF}Выберите действие:",
        inv_name[playerid][index], inv_count[playerid][index], inv_desc[playerid][index]);
    
    ShowPlayerDialog(playerid, DIALOG_INVENTORY_ITEM, DIALOG_STYLE_LIST,
        "{ff0000}BLACK RUSSIA{ffffff} | Управление предметом",
        "Использовать\nВыбросить\nИнформация",
        "Выбрать", "Назад");
    return 1;
}

// Использовать предмет
stock Inv_UseItem(playerid, index)
{
    new item_id = inv_id[playerid][index];
    new item_name[64];
    new item_type = inv_type[playerid][index];
    new item_value = inv_value[playerid][index];
    new count = inv_count[playerid][index];
    format(item_name, 64, "%s", inv_name[playerid][index]);
    
    if(item_type == ITEM_TYPE_FOOD)
    {
        new Float:health;
        GetPlayerHealth(playerid, health);
        new new_health = floatround(health) + item_value;
        if(new_health > 100) new_health = 100;
        SetPlayerHealth(playerid, float(new_health));
        
        new msg[128];
        format(msg, sizeof msg, "{66cc33}[Инвентарь]{ffffff} Вы использовали {ffff00}%s{ffffff} и восстановили {66cc33}%d HP", item_name, item_value);
        SendClientMessage(playerid, -1, msg);
    }
    else if(item_type == ITEM_TYPE_MEDKIT)
    {
        SetPlayerHealth(playerid, 100.0);
        new msg[128];
        format(msg, sizeof msg, "{66cc33}[Инвентарь]{ffffff} Вы использовали {ffff00}%s{ffffff} и полностью восстановили здоровье", item_name);
        SendClientMessage(playerid, -1, msg);
    }
    else if(item_type == ITEM_TYPE_ARMOR)
    {
        SetPlayerArmour(playerid, float(item_value));
        new msg[128];
        format(msg, sizeof msg, "{66cc33}[Инвентарь]{ffffff} Вы надели {ffff00}%s{ffffff} (броня: %d)", item_name, item_value);
        SendClientMessage(playerid, -1, msg);
    }
    else
    {
        new msg[128];
        format(msg, sizeof msg, "{66cc33}[Инвентарь]{ffffff} Вы использовали {ffff00}%s", item_name);
        SendClientMessage(playerid, -1, msg);
    }
    
    // Уменьшаем количество
    if(count > 1)
    {
        new query[128];
        mysql_format(mysql, query, sizeof query, "UPDATE player_inventory SET item_count = item_count - 1 WHERE id = %d", item_id);
        mysql_query(mysql, query, false);
    }
    else
    {
        new query[128];
        mysql_format(mysql, query, sizeof query, "DELETE FROM player_inventory WHERE id = %d", item_id);
        mysql_query(mysql, query, false);
    }
    
    Inv_Load(playerid);
    return 1;
}

// Выбросить предмет
stock Inv_DropItem(playerid, index)
{
    new item_id = inv_id[playerid][index];
    new item_name[64];
    format(item_name, 64, "%s", inv_name[playerid][index]);
    
    new query[128];
    mysql_format(mysql, query, sizeof query, "DELETE FROM player_inventory WHERE id = %d", item_id);
    mysql_query(mysql, query, false);
    
    new msg[128];
    format(msg, sizeof msg, "{ff6666}[Инвентарь]{ffffff} Вы выбросили {ffff00}%s", item_name);
    SendClientMessage(playerid, -1, msg);
    
    Inv_Load(playerid);
    return 1;
}

// Выдать предмет
stock Inv_GiveItem(playerid, const item_name[], item_type, item_value, item_count = 1, const item_desc[] = "")
{
    new query[512];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO player_inventory (player_id, item_name, item_type, item_value, item_count, item_desc) VALUES (%d, '%e', %d, %d, %d, '%e')",
        GetPlayerAccountID(playerid), item_name, item_type, item_value, item_count, item_desc);
    mysql_query(mysql, query, false);
    
    new msg[128];
    format(msg, sizeof msg, "{66cc33}[Инвентарь]{ffffff} Вы получили {ffff00}%s x%d", item_name, item_count);
    SendClientMessage(playerid, -1, msg);
    
    Inv_Load(playerid);
    return 1;
}

// ========== ОБРАБОТЧИК ДИАЛОГОВ ==========
stock Inv_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_INVENTORY_MAIN)
    {
        if(!response) return 1;
        
        if(listitem >= 0 && listitem < inv_rows[playerid])
        {
            Inv_ShowItemMenu(playerid, listitem);
        }
        return 1;
    }
    
    if(dialogid == DIALOG_INVENTORY_ITEM)
    {
        if(!response)
        {
            Inv_ShowMain(playerid);
            return 1;
        }
        
        new index = GetPVarInt(playerid, "inv_selected_index");
        
        switch(listitem)
        {
            case 0: // Использовать
            {
                Inv_UseItem(playerid, index);
                Inv_ShowMain(playerid);
            }
            case 1: // Выбросить
            {
                Inv_DropItem(playerid, index);
                Inv_ShowMain(playerid);
            }
            case 2: // Информация
            {
                ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Информация", inv_desc[playerid][index], "ОК", "");
                Inv_ShowItemMenu(playerid, index);
            }
        }
        return 1;
    }
    
    return 0;
}

// ========== КОМАНДА ==========
CMD:inventor(playerid)
{
    Inv_Load(playerid);
    Inv_ShowMain(playerid);
    return 1;
}
#endif