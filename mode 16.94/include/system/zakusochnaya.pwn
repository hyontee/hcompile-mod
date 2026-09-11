#if defined _LIRIPAWN_DINER_SYSTEM_INC
    #endinput
#endif
#define _LIRIPAWN_DINER_SYSTEM_INC

#define DINER_WORLD             184
#define DINER_INTERIOR          1

#define DIALOG_DINER_FOOD       6010

#define DINER_MEDKIT_PRICE      150
#define DINER_MEAT_PRICE        75
#define DINER_MAX_FOOD          100
#define DINER_ENTER_COUNT       10
#define DINER_EXIT_DISTANCE     2.4
#define DINER_FIRST_BUSINESS_ID 102

#define DINER_PICKUP_ENTER      19132
#define DINER_PICKUP_EXIT       19132
#define DINER_PICKUP_MEAT       1239
#define DINER_PICKUP_FOOD       1239
#define DINER_PICKUP_MEDKIT     1240

#if !defined SC
    #define SC "{FF0000}"
#endif
#if !defined USC
    #define USC "{FFAA00}"
#endif

enum E_DINER_FOOD
{
    FOOD_NAME[32],
    FOOD_PRICE,
    FOOD_SATIETY
}
new const diner_food_list[7][E_DINER_FOOD] =
{
    {"Картофель Фри",       180,  10},
    {"Сэндвич",             230,  15},
    {"Бургер",              320,  25},
    {"Крылышки",            450,  35},
    {"Пицца",               580,  50},
    {"Курица с салатом",    690,  65},
    {"Комплексный обед",    780, 100}
};

enum E_DINER_PLAYER
{
    diner_food_level,
    diner_raw_meat,
    diner_enter_id,
    Float:diner_enter_angle,
    bool:diner_loaded
}
new DinerPlayer[MAX_PLAYERS][E_DINER_PLAYER];

stock DinerEnsureDatabaseColumn(const column_name[], const column_definition[])
{
    new query[192];
    mysql_format(mysql, query, sizeof query, "SHOW COLUMNS FROM `accounts` LIKE '%e'", column_name);

    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        printf("[DINER][DB] Failed to check column %s", column_name);
        return 0;
    }

    new rows = cache_num_rows();
    cache_delete(result);
    if(rows > 0)
        return 1;

    mysql_format(mysql, query, sizeof query, "ALTER TABLE `accounts` ADD COLUMN `%e` %s", column_name, column_definition);
    mysql_query(mysql, query, false);
    if(mysql_errno())
    {
        printf("[DINER][DB] Failed to create column %s", column_name);
        return 0;
    }
    printf("[DINER][DB] Created column %s", column_name);
    return 1;
}

stock DinerCreateDatabase()
{
    DinerEnsureDatabaseColumn("diner_food", "INT NOT NULL DEFAULT 100");
    DinerEnsureDatabaseColumn("raw_meat", "INT NOT NULL DEFAULT 0");
    return 1;
}
new diner_pickup_cd[MAX_PLAYERS];

new diner_pickup_food,
    diner_pickup_meat,
    diner_pickup_medkit,
    diner_pickup_exit;

new Text3D:diner_label_food,
    Text3D:diner_label_meat,
    Text3D:diner_label_medkit,
    Text3D:diner_enter_label[DINER_ENTER_COUNT];

new Float:diner_enter_pos[DINER_ENTER_COUNT][3] =
{
{2310.73, -1926.36, 21.9677},
{1855.79, 2270.41, 15.5781},
{1949.89, 1912.71, 15.4655},
{-42.405, 925.929, 12.3321},
{171.677, 737.673, 12.7494},
{-126.885, 986.537, 12.7537},
{-502.048, 1272.18, 20.8908},
{-2184.1, -245.359, 26.7962},
{-2852.24, 2137.26, 10.0017},
{-2398.1, 1235.57, 10.85}
};
new diner_enter_pickup[DINER_ENTER_COUNT];

stock Diner_IsEnterPosition(Float:x, Float:y, Float:z)
{
    for(new i = 0; i < sizeof diner_enter_pos; i++)
    {
        if(floatabs(x - diner_enter_pos[i][0]) <= 1.0 && floatabs(y - diner_enter_pos[i][1]) <= 1.0 && floatabs(z - diner_enter_pos[i][2]) <= 2.0)
            return 1;
    }
    return 0;
}

stock Diner_GetEnterIdByPosition(Float:x, Float:y, Float:z)
{
    for(new i = 0; i < sizeof diner_enter_pos; i++)
    {
        if(floatabs(x - diner_enter_pos[i][0]) <= 1.0 && floatabs(y - diner_enter_pos[i][1]) <= 1.0 && floatabs(z - diner_enter_pos[i][2]) <= 2.0)
            return i;
    }
    return -1;
}

stock Diner_UpdateEnterLabelText(enter_id, businessid, const owner_name[])
{
    if(enter_id < 0 || enter_id >= DINER_ENTER_COUNT) return 0;
    if(!IsValidDynamic3DTextLabel(diner_enter_label[enter_id])) return 0;

    new label_text[144];
    format(label_text, sizeof label_text,
        "{FFFF00}Закусочная (%d)\n{FFFFFF}Владелец: {0b7ecf}%s\n{FFFF00}Крыша: отсутствует",
        DINER_FIRST_BUSINESS_ID + enter_id, owner_name);

    UpdateDynamic3DTextLabelText(diner_enter_label[enter_id], 0xFFFFFFFF, label_text);
    return 1;
}

stock Diner_UpdateBusinessEnterLabel(Float:x, Float:y, Float:z, businessid, const owner_name[])
{
    return Diner_UpdateEnterLabelText(Diner_GetEnterIdByPosition(x, y, z), businessid, owner_name);
}
stock ShowDinerFoodDialog(playerid)
{
    new dialog[512], row[80];

    for(new i = 0; i < sizeof diner_food_list; i++)
    {
        format(row, sizeof row, "{FFFFFF}%d. %s\t{73C13F}%d руб\n", i + 1, diner_food_list[i][FOOD_NAME], diner_food_list[i][FOOD_PRICE]);
        strcat(dialog, row);
    }

    Dialog
    (
        playerid, DIALOG_DINER_FOOD, DIALOG_STYLE_LIST,
        "{33AAFF}Закусочная",
        dialog,
        "Купить", "Отмена"
    );
    return 1;
}

stock bool:Diner_HandleBuyCommand(playerid)
{
    if(GetPlayerVirtualWorld(playerid) != DINER_WORLD)
    {
        return false;
    }

    ShowDinerFoodDialog(playerid);
    return true;
}

stock Diner_LoadAccount(playerid)
{
    if(DinerPlayer[playerid][diner_loaded]) return 1;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[160], Cache:result;

    mysql_format(mysql, query, sizeof query, "SELECT diner_food, raw_meat FROM accounts WHERE id = %d LIMIT 1", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        print("[ERROR DINER MYSQL] LOAD");
        return 0;
    }

    if(cache_num_rows())
    {
        DinerPlayer[playerid][diner_food_level] = cache_get_field_content_int(0, "diner_food");
        DinerPlayer[playerid][diner_raw_meat]   = cache_get_field_content_int(0, "raw_meat");
    }
    cache_delete(result);

    DinerPlayer[playerid][diner_loaded] = true;
    return 1;
}

stock Diner_SaveAccount(playerid)
{
    if(!DinerPlayer[playerid][diner_loaded]) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET diner_food = %d, raw_meat = %d WHERE id = %d",
        DinerPlayer[playerid][diner_food_level], DinerPlayer[playerid][diner_raw_meat], GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    if(mysql_errno()) return print("[ERROR DINER MYSQL] SAVE");
    return 1;
}

stock Diner_LogPurchase(playerid, const itemname[], price)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO diner_logs (account_id, item, price, date_buy) VALUES (%d, '%e', %d, NOW())",
        GetPlayerAccountID(playerid), itemname, price);
    mysql_query(mysql, query, false);
    if(mysql_errno()) return print("[ERROR DINER MYSQL] LOG");
    return 1;
}

stock Diner_GiveRawMeat(playerid, amount)
{
    DinerPlayer[playerid][diner_raw_meat] += amount;
    Diner_SaveAccount(playerid);
    return DinerPlayer[playerid][diner_raw_meat];
}

forward Diner_HungerUpdate();
public Diner_HungerUpdate()
{
    foreach(new i : Player)
    {
        if(!DinerPlayer[i][diner_loaded]) continue;

        if(DinerPlayer[i][diner_food_level] > 0)
        {
            DinerPlayer[i][diner_food_level]--;
        }
        else
        {
            if(GetPVarInt(i, "agm")) continue;

            new Float:hp;
            GetPlayerHealth(i, hp);
            SetPlayerHealth(i, hp - 2.0);
            SendClientMessage(i, -1, ""SC" Вы голодны! Зайдите в закусочную и поешьте (/buy).");
        }
    }
    return 1;
}

public OnGameModeInit()
{
    diner_pickup_food = CreateDynamicPickup(DINER_PICKUP_FOOD, 23, 10.0089, 1004.5281, 1381.0469, DINER_WORLD, DINER_INTERIOR, -1, 50.0);
    diner_label_food  = CreateDynamic3DTextLabel("{73C13F}Список еды\n{FFFFFF}Введите {73C13F}/buy",
        0xFFFFFFFF, 10.0089, 1004.5281, 1381.5469, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DINER_WORLD, DINER_INTERIOR);

    diner_pickup_meat = CreateDynamicPickup(DINER_PICKUP_MEAT, 23, 5.7481, 1007.9025, 1381.0469, DINER_WORLD, DINER_INTERIOR, -1, 50.0);
    diner_label_meat  = CreateDynamic3DTextLabel("{FFFFFF}Переработка\n[{FF0000}Мяса{FFFFFF}]",
        0xFFFFFFFF, 5.7481, 1007.9025, 1381.5469, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DINER_WORLD, DINER_INTERIOR);

    diner_pickup_medkit = CreateDynamicPickup(DINER_PICKUP_MEDKIT, 23, 16.8146, 1002.9560, 1381.0460, DINER_WORLD, DINER_INTERIOR, -1, 50.0);
    diner_label_medkit  = CreateDynamic3DTextLabel("{00FF00}Аптечка\n{FFFFFF}Стоимость: {00FF00}150 RUB",
        0xFFFFFFFF, 16.8146, 1002.9560, 1381.5460, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DINER_WORLD, DINER_INTERIOR);

    diner_pickup_exit = CreateDynamicPickup(DINER_PICKUP_EXIT, 23, 3.7928, 992.4143, 1381.0469, DINER_WORLD, DINER_INTERIOR, -1, 50.0);

    for(new i = 0; i < sizeof diner_enter_pos; i++)
    {
        diner_enter_pickup[i] = CreateDynamicPickup(DINER_PICKUP_ENTER, 23,
            diner_enter_pos[i][0], diner_enter_pos[i][1], diner_enter_pos[i][2], 0, 0, -1, 50.0);

        new start_label[144];
        format(start_label, sizeof start_label, "{FFFF00}Закусочная (%d)\n{FFFFFF}Владелец: {0b7ecf}отсутствует\n{FFFF00}Крыша: отсутствует", DINER_FIRST_BUSINESS_ID + i);

        diner_enter_label[i] = CreateDynamic3DTextLabel(start_label,
            0xFFFFFFFF, diner_enter_pos[i][0], diner_enter_pos[i][1], diner_enter_pos[i][2] + 0.5,
            12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    }

    SetTimer("Diner_HungerUpdate", 60000, true);

    #if defined zk_OnGameModeInit
        return zk_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit zk_OnGameModeInit
#if defined zk_OnGameModeInit
    forward zk_OnGameModeInit();
#endif

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    for(new i = 0; i < sizeof diner_enter_pickup; i++)
    {
        if(pickupid == diner_enter_pickup[i])
        {
            DinerPlayer[playerid][diner_enter_id] = i;
            GetPlayerFacingAngle(playerid, DinerPlayer[playerid][diner_enter_angle]);
            SetPlayerPosEx(playerid, 4.0677, 994.8851, 1381.0469, 0.0, DINER_INTERIOR, DINER_WORLD);
            SendClientMessage(playerid, -1, ""SC" Добро пожаловать в закусочную! Для покупки еды введите /buy.");
            return 1;
        }
    }

    if(diner_pickup_cd[playerid] > gettime() && (pickupid == diner_pickup_food || pickupid == diner_pickup_meat || pickupid == diner_pickup_medkit))
        return 1;

    if(pickupid == diner_pickup_food)
    {
        diner_pickup_cd[playerid] = gettime() + 2;
        ShowDinerFoodDialog(playerid);
        return 1;
    }

    if(pickupid == diner_pickup_meat)
    {
        diner_pickup_cd[playerid] = gettime() + 2;

        if(DinerPlayer[playerid][diner_raw_meat] <= 0)
            return SendClientMessage(playerid, -1, ""USC" У вас нет сырого мяса для переработки.");

        new amount = DinerPlayer[playerid][diner_raw_meat];
        new payout = amount * DINER_MEAT_PRICE;

        DinerPlayer[playerid][diner_raw_meat] = 0;
        GivePlayerMoneyEx(playerid, payout);
        Diner_SaveAccount(playerid);

        new str[144];
        format(str, sizeof str, ""SC" Вы переработали %d ед. мяса и получили %d руб.", amount, payout);
        SendClientMessage(playerid, -1, str);
        return 1;
    }

    if(pickupid == diner_pickup_medkit)
    {
        diner_pickup_cd[playerid] = gettime() + 2;

        new Float:hp;
        GetPlayerHealth(playerid, hp);
        if(hp >= 100.0)
            return SendClientMessage(playerid, -1, ""USC" У вас полное здоровье.");

        if(GetPlayerMoneyEx(playerid) < DINER_MEDKIT_PRICE)
            return SendClientMessage(playerid, -1, ""USC" Недостаточно денег. Стоимость аптечки: 150 RUB.");

        GivePlayerMoneyEx(playerid, -DINER_MEDKIT_PRICE);
        SetPlayerHealth(playerid, 100.0);
        SendClientMessage(playerid, -1, ""SC" Вы воспользовались аптечкой за 150 RUB. Здоровье восстановлено.");
        return 1;
    }

    if(pickupid == diner_pickup_exit)
    {
        new e = DinerPlayer[playerid][diner_enter_id];
        if(e < 0 || e >= sizeof diner_enter_pos) e = 0;
        new Float:angle,
            Float:exit_x,
            Float:exit_y;

        angle = DinerPlayer[playerid][diner_enter_angle];
        exit_x = diner_enter_pos[e][0] + DINER_EXIT_DISTANCE * floatsin(-angle, degrees);
        exit_y = diner_enter_pos[e][1] + DINER_EXIT_DISTANCE * floatcos(-angle, degrees);

        SetPlayerPosEx(playerid, exit_x, exit_y, diner_enter_pos[e][2], angle, 0, 0);
        SendClientMessage(playerid, -1, ""SC" Вы вышли из закусочной.");
        return 1;
    }

    #if defined zk_OnPlayerPickUpDynamicPickup
        return zk_OnPlayerPickUpDynamicPickup(playerid, pickupid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpDynPickup
    #undef OnPlayerPickUpDynamicPickup
#else
    #define _ALS_OnPlayerPickUpDynPickup
#endif
#define OnPlayerPickUpDynamicPickup zk_OnPlayerPickUpDynamicPickup
#if defined zk_OnPlayerPickUpDynamicPickup
    forward zk_OnPlayerPickUpDynamicPickup(playerid, pickupid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_DINER_FOOD)
    {
        if(!response) return 1;

        if(GetPlayerVirtualWorld(playerid) != DINER_WORLD)
            return SendClientMessage(playerid, -1, ""USC" Вы должны находиться в закусочной.");

        new price = diner_food_list[listitem][FOOD_PRICE];
        new satiety = diner_food_list[listitem][FOOD_SATIETY];

        if(GetPlayerMoneyEx(playerid) < price)
            return SendClientMessage(playerid, -1, ""USC" У вас недостаточно денег для покупки.");

        GivePlayerMoneyEx(playerid, -price);

        new newfood = DinerPlayer[playerid][diner_food_level] + satiety;
        if(newfood > DINER_MAX_FOOD) newfood = DINER_MAX_FOOD;
        DinerPlayer[playerid][diner_food_level] = newfood;

        Diner_SaveAccount(playerid);
        Diner_LogPurchase(playerid, diner_food_list[listitem][FOOD_NAME], price);

        new str[160];
        format(str, sizeof str, ""SC" Вы купили \"%s\" за %d руб. Сытость: %d%%.",
            diner_food_list[listitem][FOOD_NAME], price, DinerPlayer[playerid][diner_food_level]);
        SendClientMessage(playerid, -1, str);
        return 1;
    }

    #if defined zk_OnDialogResponse
        return zk_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse zk_OnDialogResponse
#if defined zk_OnDialogResponse
    forward zk_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

CMD:food(playerid)
{
    new str[128];
    format(str, sizeof str, ""SC" Сытость: {FFFFFF}%d%%{FF0000} | Сырое мясо: {FFFFFF}%d ед.",
        DinerPlayer[playerid][diner_food_level], DinerPlayer[playerid][diner_raw_meat]);
    SendClientMessage(playerid, -1, str);
    return 1;
}

public OnPlayerConnect(playerid)
{
    DinerPlayer[playerid][diner_food_level] = DINER_MAX_FOOD;
    DinerPlayer[playerid][diner_raw_meat] = 0;
    DinerPlayer[playerid][diner_enter_id] = -1;
    DinerPlayer[playerid][diner_enter_angle] = 0.0;
    DinerPlayer[playerid][diner_loaded] = false;
    diner_pickup_cd[playerid] = 0;

    #if defined zk_OnPlayerConnect
        return zk_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect zk_OnPlayerConnect
#if defined zk_OnPlayerConnect
    forward zk_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn(playerid)
{
    if(IsPlayerLogged(playerid) && !DinerPlayer[playerid][diner_loaded])
    {
        Diner_LoadAccount(playerid);
    }

    #if defined zk_OnPlayerSpawn
        return zk_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn zk_OnPlayerSpawn
#if defined zk_OnPlayerSpawn
    forward zk_OnPlayerSpawn(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    Diner_SaveAccount(playerid);

    #if defined zk_OnPlayerDisconnect
        return zk_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect zk_OnPlayerDisconnect
#if defined zk_OnPlayerDisconnect
    forward zk_OnPlayerDisconnect(playerid, reason);
#endif
