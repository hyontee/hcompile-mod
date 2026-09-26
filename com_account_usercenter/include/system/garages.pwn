new LoadCarGarage[MAX_PLAYERS];

// One-shot spawn override used only by remote /garage delivery.
// SetVehicleZAngle is unreliable for an unoccupied vehicle; therefore a remotely
// delivered personal car must be CREATED at the garage heading, not created at
// its old DB heading and rotated afterwards.
new bool:g_garage_spawn_override_active = false;
new g_garage_spawn_override_sql_id = 0;
new Float:g_garage_spawn_override_x = 0.0;
new Float:g_garage_spawn_override_y = 0.0;
new Float:g_garage_spawn_override_z = 0.0;
new Float:g_garage_spawn_override_a = 0.0;

// Runtime binding of a vehicle to its authoritative garage slot.
new g_vehicle_garage_index[MAX_VEHICLES] = {-1, ...};
new g_vehicle_garage_slot[MAX_VEHICLES] = {-1, ...};


enum E_GARAGE_STRUCT
{
    GARAGE_ID,
    GARAGE_OWNER_ID,
    GARAGE_PRICE,
    GARAGE_STATUS,
    Float: GARAGE_X,
    Float: GARAGE_Y,
    Float: GARAGE_Z,
    Float: GARAGE_EXIT_X,
    Float: GARAGE_EXIT_Y,
    Float: GARAGE_EXIT_Z,
    Float: GARAGE_EXIT_ANGLE,
    // Optional per-garage player spawn inside the interior. Zero = class default.
    Float: GARAGE_SPAWN_X,
    Float: GARAGE_SPAWN_Y,
    Float: GARAGE_SPAWN_Z,
    Float: GARAGE_SPAWN_ANGLE,
    // Optional exact exterior exit point. Zero = calculate safe point from legacy exit data.
    Float: GARAGE_SAFE_EXIT_X,
    Float: GARAGE_SAFE_EXIT_Y,
    Float: GARAGE_SAFE_EXIT_Z,
    Float: GARAGE_SAFE_EXIT_ANGLE,
    // Optional exact exterior VEHICLE exit point. Zero = use the normal player/safe exit.
    Float: GARAGE_VEHICLE_EXIT_X,
    Float: GARAGE_VEHICLE_EXIT_Y,
    Float: GARAGE_VEHICLE_EXIT_Z,
    Float: GARAGE_VEHICLE_EXIT_ANGLE,
    G_ENTER_PICKUP,
    Text3D: G_LABEL,
    Text3D: G_MINE_LABEL,
    G_OWNER_NAME[20 + 1],
    GARAGE_IMPROVEMENTS,
};

#define MAX_GARAGES           (100)

#define GetPlayerInGarage(%0)	GetPlayerData(%0, P_IN_GARAGE)
#define SetPlayerInGarage(%0,%1)				SetPlayerData(%0, P_IN_GARAGE, %1)

#define GetGarageData(%0,%1)			g_garage[%0][%1]
#define SetGarageData(%0,%1,%2)		g_garage[%0][%1] = %2
#define AddGarageData(%0,%1,%2,%3)	g_garage[%0][%1] %2= %3

#define IsGarageOwned(%0)			(GetGarageData(%0, GARAGE_OWNER_ID) > 0)
#define GARAGE_SAFE_EXIT_DISTANCE                (3.0)
#define GARAGE_SAFE_EXIT_Z_OFFSET                (0.30)

new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];
new g_garage_loaded;

#define DIALOG_GARAGE_INFO                      22313
#define DIALOG_GARAGE_SETTINGS                  22323
#define DIALOG_GARAGE_SELL                      22333
#define DIALOG_GARAGE_BUY                       22343
#define DIALOG_GARAGE_ENTER                     22353
#define DIALOG_OWNABLE_CAR_LOAD_GARAGE          22363
#define DIALOG_GARAGE_CAR_SELECT                 22373
#define DIALOG_GARAGE_IMPROVEMENT               22383
#define DIALOG_GARAGE_IMPROVEMENT_CONFIRM       22393

#define PICKUP_ACTION_TYPE_GARAGE_EXIT          221
#define PICKUP_ACTION_TYPE_GARAGE               222

#define OFFER_TYPE_SELL_GARAGE                  221

forward ShowPlayerGarageInfo(playerid, garageid);
forward CheckAndCreateGaragesTables();

public OnGameModeInit()
{
    SetTimer("CheckAndCreateGaragesTables", 1500, false);
    print("[WERTON_GARAGES]: Система гаражей загружена!");
    SetTimer("LoadGarages", 3000, false);

    #if defined garage_OnGameModeInit
        return garage_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit garage_OnGameModeInit
#if defined garage_OnGameModeInit
    forward garage_OnGameModeInit();
#endif

stock GarageEnsureFloatColumn(const column[])
{
    new query[192];
    mysql_format(mysql, query, sizeof query, "SHOW COLUMNS FROM `garages` LIKE '%e'", column);
    new Cache:result = mysql_query(mysql, query, true);
    new exists = (!mysql_errno(mysql) && cache_num_rows() > 0);
    cache_delete(result);

    if(!exists)
    {
        format(query, sizeof query, "ALTER TABLE `garages` ADD COLUMN `%s` FLOAT NOT NULL DEFAULT 0", column);
        mysql_query(mysql, query, false);
    }
    return 1;
}

public CheckAndCreateGaragesTables()
{
    new query[1024];

    mysql_format(mysql, query, sizeof(query), "SHOW TABLES LIKE 'garages'");
    mysql_query(mysql, query);

    if (cache_num_rows() == 0)
    {
        print("Таблица 'garages' не найдена. Создаем ее...");

        mysql_format(mysql, query, sizeof(query), "CREATE TABLE `garages` (`id` INT(11) NOT NULL, `owner_id` INT(11) NOT NULL, `price` INT(11) NOT NULL DEFAULT 30000000, `lock` INT(11) NOT NULL, `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `z` FLOAT NOT NULL, `exit_x` FLOAT NOT NULL, `exit_y` FLOAT NOT NULL, `exit_z` FLOAT NOT NULL, `exit_angle` FLOAT NOT NULL, `improvements` INT(11) NOT NULL DEFAULT 1) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        mysql_query(mysql, query);

        mysql_format(mysql, query, sizeof(query), "ALTER TABLE `garages` ADD PRIMARY KEY (`id`);");
        mysql_query(mysql, query);

        mysql_format(mysql, query, sizeof(query), "ALTER TABLE `garages` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT;");
        mysql_query(mysql, query);

        print("Таблица 'garages' успешно создана. Теперь вставляем начальные данные...");

        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (1, 0, 30000000, 0, 353.404, 800.074, 12, 350.682, 800.797, 12, 69.381, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (2, 0, 30000000, 0, 354.905, 804.006, 12, 352.324, 804.991, 12, 66.7752, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (3, 0, 30000000, 0, 356.451, 808.065, 12.0073, 353.898, 808.92, 12.0073, 66.5632, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (4, 0, 30000000, 0, 357.905, 811.891, 12.0073, 355.276, 813.422, 12.0073, 67.9254, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (5, 0, 30000000, 0, 359.422, 815.865, 12, 356.466, 816.753, 12.0073, 65.2152, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (6, 0, 30000000, 0, 360.909, 819.765, 12, 358.047, 820.573, 12, 72.5789, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (7, 0, 30000000, 0, 362.431, 823.763, 12, 360.489, 824.517, 12, 64.0241, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (8, 0, 30000000, 0, 363.94, 827.73, 12, 361.112, 828.732, 12, 71.2634, 1);");
        mysql_query(mysql, query);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `garages` (`id`, `owner_id`, `price`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `improvements`) VALUES (9, 0, 30000000, 0, 365.421, 831.631, 12.0085, 362.63, 832.608, 12, 70.8588, 1);");
        mysql_query(mysql, query);

        print("Начальные данные успешно вставлены в таблицу 'garages'.");
    }

    // Persistent editable interior spawn + exact exterior exit coordinates.
    // Existing servers are upgraded automatically; zero values use safe class defaults.
    GarageEnsureFloatColumn("spawn_x");
    GarageEnsureFloatColumn("spawn_y");
    GarageEnsureFloatColumn("spawn_z");
    GarageEnsureFloatColumn("spawn_angle");
    GarageEnsureFloatColumn("safe_exit_x");
    GarageEnsureFloatColumn("safe_exit_y");
    GarageEnsureFloatColumn("safe_exit_z");
    GarageEnsureFloatColumn("safe_exit_angle");
    GarageEnsureFloatColumn("vehicle_exit_x");
    GarageEnsureFloatColumn("vehicle_exit_y");
    GarageEnsureFloatColumn("vehicle_exit_z");
    GarageEnsureFloatColumn("vehicle_exit_angle");

    mysql_format(mysql, query, sizeof(query), "SHOW COLUMNS FROM `accounts` LIKE 'garage'");
    mysql_query(mysql, query);

    if (cache_num_rows() == 0)
    {
        print("Столбец 'garage' в таблице 'accounts' не найден. Добавляем его...");

        mysql_format(mysql, query, sizeof(query), "ALTER TABLE `accounts` ADD COLUMN `garage` INT(11) NOT NULL DEFAULT -1;");
        mysql_query(mysql, query);

        print("Столбец 'garage' успешно добавлен в таблицу 'accounts'.");
    }
}

public: LoadGarages()
{
 new query[85], buffer[2];
 new Cache: result, rows;

 result = mysql_query(mysql, "SELECT g.*, IFNULL(a.name, 'None') AS owner_name FROM garages g LEFT JOIN accounts a ON a.id=g.owner_id");
 rows = cache_num_rows();

    if(mysql_errno(mysql) != 0)
    {
        printf("[WERTON_GARAGES]: Ошибка при загрузке гаражей из БД: %s", mysql_errno(mysql));
        return 0;
    }

 if(rows > MAX_GARAGES)
 {
  rows = MAX_GARAGES;
  print("[garages by werton]: DB rows > MAX_GARAGES");
 }

 for(new idx; idx < rows; idx ++)
 {
  SetGarageData(idx, GARAGE_ID,   cache_get_field_content_int(idx, "id"));
  SetGarageData(idx, GARAGE_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));

  SetGarageData(idx, GARAGE_PRICE,   30000000);
  SetGarageData(idx, GARAGE_STATUS, bool: cache_get_field_content_int(idx, "lock"));

  SetGarageData(idx, GARAGE_X,   cache_get_field_content_float(idx, "x"));
  SetGarageData(idx, GARAGE_Y,   cache_get_field_content_float(idx, "y"));
  SetGarageData(idx, GARAGE_Z,   cache_get_field_content_float(idx, "z"));
  
  SetGarageData(idx, GARAGE_EXIT_X,   cache_get_field_content_float(idx, "exit_x"));
  SetGarageData(idx, GARAGE_EXIT_Y,   cache_get_field_content_float(idx, "exit_y"));
  SetGarageData(idx, GARAGE_EXIT_Z,   cache_get_field_content_float(idx, "exit_z"));
  SetGarageData(idx, GARAGE_EXIT_ANGLE,   cache_get_field_content_float(idx, "exit_angle"));
  SetGarageData(idx, GARAGE_SPAWN_X,   cache_get_field_content_float(idx, "spawn_x"));
  SetGarageData(idx, GARAGE_SPAWN_Y,   cache_get_field_content_float(idx, "spawn_y"));
  SetGarageData(idx, GARAGE_SPAWN_Z,   cache_get_field_content_float(idx, "spawn_z"));
  SetGarageData(idx, GARAGE_SPAWN_ANGLE, cache_get_field_content_float(idx, "spawn_angle"));
  SetGarageData(idx, GARAGE_SAFE_EXIT_X, cache_get_field_content_float(idx, "safe_exit_x"));
  SetGarageData(idx, GARAGE_SAFE_EXIT_Y, cache_get_field_content_float(idx, "safe_exit_y"));
  SetGarageData(idx, GARAGE_SAFE_EXIT_Z, cache_get_field_content_float(idx, "safe_exit_z"));
  SetGarageData(idx, GARAGE_SAFE_EXIT_ANGLE, cache_get_field_content_float(idx, "safe_exit_angle"));
  SetGarageData(idx, GARAGE_VEHICLE_EXIT_X, cache_get_field_content_float(idx, "vehicle_exit_x"));
  SetGarageData(idx, GARAGE_VEHICLE_EXIT_Y, cache_get_field_content_float(idx, "vehicle_exit_y"));
  SetGarageData(idx, GARAGE_VEHICLE_EXIT_Z, cache_get_field_content_float(idx, "vehicle_exit_z"));
  SetGarageData(idx, GARAGE_VEHICLE_EXIT_ANGLE, cache_get_field_content_float(idx, "vehicle_exit_angle"));
  SetGarageData(idx, GARAGE_IMPROVEMENTS,   cache_get_field_content_int(idx, "improvements"));
  
  cache_get_field_content(idx, "owner_name", g_garage[idx][G_OWNER_NAME], mysql, 21);

  new labelText[128];
  format(labelText, sizeof(labelText), "Нажмите [гудок] чтобы выехать");
  SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(labelText, 0x3399FFFF, GetGarageData(idx, GARAGE_X), GetGarageData(idx, GARAGE_Y), GetGarageData(idx, GARAGE_Z) + 1.0, 15.0));

  if(IsGarageOwned(idx) && !strcmp(GetGarageData(idx, G_OWNER_NAME), "None", true))
  {
   mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1", GetGarageData(idx, GARAGE_OWNER_ID));
   mysql_query(mysql, query, false);

   SetGarageData(idx, GARAGE_OWNER_ID, 0);

   mysql_format(mysql, query, sizeof query, "UPDATE garages SET owner_id=0 WHERE id=%d", GetGarageData(idx, GARAGE_ID));
   mysql_query(mysql, query, false);
  }

  CreatePickup(19134, 23, GetGarageData(idx, GARAGE_X), GetGarageData(idx, GARAGE_Y), GetGarageData(idx, GARAGE_Z), 0, PICKUP_ACTION_TYPE_GARAGE, idx);
  CreatePickup(1318, 23, 1.2011, 1994.7356, 1554.2031, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT, idx);
  CreatePickup(1318, 23, 492.912048,1991.464599,1547.679687, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT, idx);
  
  UpdateGarageInfo(idx);
 }
 g_garage_loaded = rows;
 cache_delete(result);
 
 CreateDynamic3DTextLabel("{ffffff}Нажмите на {ff0000}гудок\n{ffffff}Чтобы выехать", -1, -0.2940,2006.1188,1554.2031, 9.0, _, _, _, -1, -1);
 CreateDynamic3DTextLabel("{ffffff}Нажмите на {ff0000}гудок\n{ffffff}Чтобы выехать", -1, 492.663848,1988.835205,1548.586645, 9.0, _, _, _, -1, -1);
 printf("[WERTON_GARAGES]: Гаражей загружено: %d", g_garage_loaded);
}

stock GetGarageIndexByDbId(db_id)
{
    if(db_id <= 0) return -1;
    for(new idx = 0; idx < g_garage_loaded; idx++)
    {
        if(GetGarageData(idx, GARAGE_ID) == db_id) return idx;
    }
    return -1;
}

stock GetPlayerGarage(playerid)
{
    new stored = GetPlayerData(playerid, P_GARAGE);
    new account_id = GetPlayerAccountID(playerid);

    // Canonical runtime value is the g_garage[] array index.
    if(stored >= 0 && stored < g_garage_loaded && GetGarageData(stored, GARAGE_OWNER_ID) == account_id)
        return stored;

    // Backward compatibility: older builds stored MySQL garages.id in P_GARAGE.
    new idx = GetGarageIndexByDbId(stored);
    if(idx != -1 && GetGarageData(idx, GARAGE_OWNER_ID) == account_id)
    {
        SetPlayerData(playerid, P_GARAGE, idx);
        return idx;
    }

    // Last-resort owner lookup makes /garage self-healing after DB edits/reconnects.
    for(idx = 0; idx < g_garage_loaded; idx++)
    {
        if(GetGarageData(idx, GARAGE_OWNER_ID) == account_id)
        {
            SetPlayerData(playerid, P_GARAGE, idx);
            return idx;
        }
    }

    return -1;
}

stock GarageResolveCurrentInterior(playerid)
{
    // The explicit session DB id is authoritative for a garage entered manually
    // or selected through login GUI. Some old spawn callbacks can briefly assign
    // a different garage VW; trusting that VW first made the exit use somebody
    // else's coordinates (or the Arzamas fallback).
    new session_db_id = GetPVarInt(playerid, "garage_session_dbid");
    new session_idx = GetGarageIndexByDbId(session_db_id);
    if(session_idx != -1 && GetPlayerInterior(playerid) == 1)
    {
        SetPlayerInGarage(playerid, session_idx);
        return session_idx;
    }

    new world = GetPlayerVirtualWorld(playerid);
    new by_world = world - 2000;
    if(GetPlayerInterior(playerid) == 1 && by_world >= 0 && by_world < g_garage_loaded)
    {
        SetPlayerInGarage(playerid, by_world);
        SetPVarInt(playerid, "garage_session_dbid", GetGarageData(by_world, GARAGE_ID));
        return by_world;
    }

    new current = GetPlayerInGarage(playerid);
    if(current >= 0 && current < g_garage_loaded) return current;

    return -1;
}

stock UpdateGarages(garageid)
{
 DestroyPickup(GetGarageData(garageid, g_enter_pickup));
 g_enter_pickup = CreatePickup(19134, 23, GetGarageData(garageid, GARAGE_X), GetGarageData(garageid, GARAGE_Y), GetGarageData(garageid, GARAGE_Z), 0, PICKUP_ACTION_TYPE_GARAGE, garageid);
}

stock UpdateGarageInfo(idx)
{
    new query[666];
    new Cache: result;

    if(GetGarageData(idx, GARAGE_OWNER_ID) > 0) 
    {
        format(query, sizeof(query), 
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}%s{FFFFFF}\n{FFFFFF}Дверь: %s\n{FFFFFF}Цена: {FFA500}30.000.000{FFFFFF} рублей\n{FFFFFF}Въезд на авто: {FFA500}гудок",
            GetGarageData(idx, GARAGE_ID), 
            GetGarageData(idx, G_OWNER_NAME),
            GetGarageData(idx, GARAGE_STATUS) ? ("{FF5252}закрыта") : ("{66CC33}открыта")
        );
    }
    else 
    {
        format(query, sizeof(query), 
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}Отсутствует{FFFFFF}\n{FFFFFF}Дверь: {66CC33}открыта{FFFFFF}\n{FFFFFF}Цена: {FFA500}30.000.000{FFFFFF} рублей\n{FFFFFF}Въезд на авто: {FFA500}гудок",
            GetGarageData(idx, GARAGE_ID)
        );
    }

    UpdateDynamic3DTextLabelText(GetGarageData(idx, G_LABEL), 0xfaf2f6AA, query);

    cache_delete(result); 
}

stock SyncPlayerGarageData(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        SetPlayerData(playerid, P_GARAGE, -1);
        return 0;
    }

    new preferred_db_id = -1;
    new query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT IFNULL(`garage`,-1) AS garage FROM `accounts` WHERE `id`=%d LIMIT 1", account_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(!mysql_errno(mysql) && cache_num_rows() > 0)
        preferred_db_id = cache_get_field_content_int(0, "garage");
    cache_delete(result);

    // accounts.garage is the preferred canonical link. This avoids an arbitrary
    // LIMIT 1 result when an old broken build left two garages with the same owner.
    new runtime_idx = GetGarageIndexByDbId(preferred_db_id);
    if(runtime_idx == -1 || GetGarageData(runtime_idx, GARAGE_OWNER_ID) != account_id)
    {
        mysql_format(mysql, query, sizeof query,
            "SELECT `id` FROM `garages` WHERE `owner_id`=%d ORDER BY (`id`=%d) DESC, `id` DESC LIMIT 1",
            account_id, preferred_db_id);
        result = mysql_query(mysql, query, true);

        preferred_db_id = -1;
        if(!mysql_errno(mysql) && cache_num_rows() > 0)
            preferred_db_id = cache_get_field_content_int(0, "id");
        cache_delete(result);
        runtime_idx = GetGarageIndexByDbId(preferred_db_id);
    }

    if(runtime_idx != -1 && GetGarageData(runtime_idx, GARAGE_OWNER_ID) == account_id)
    {
        SetPlayerData(playerid, P_GARAGE, runtime_idx);

        mysql_format(mysql, query, sizeof query,
            "UPDATE `accounts` SET `garage`=%d WHERE `id`=%d LIMIT 1", preferred_db_id, account_id);
        mysql_query(mysql, query, false);

        // The game supports one garage per account. Clean duplicate ownership left
        // by older builds so the next login can never choose a foreign/old garage.
        mysql_format(mysql, query, sizeof query,
            "UPDATE `garages` SET `owner_id`=0 WHERE `owner_id`=%d AND `id`<>%d",
            account_id, preferred_db_id);
        mysql_query(mysql, query, false);

        // Keep runtime ownership synchronized with the repaired DB immediately.
        // Otherwise an old duplicate garage could remain "owned" until restart
        // and later be selected by a stale VW/P_IN_GARAGE value.
        for(new i = 0; i < g_garage_loaded; i++)
        {
            if(i == runtime_idx) continue;
            if(GetGarageData(i, GARAGE_OWNER_ID) != account_id) continue;
            SetGarageData(i, GARAGE_OWNER_ID, 0);
            g_garage[i][G_OWNER_NAME][0] = EOS;
            UpdateGarageInfo(i);
        }
        return 1;
    }

    SetPlayerData(playerid, P_GARAGE, -1);
    mysql_format(mysql, query, sizeof query,
        "UPDATE `accounts` SET `garage`=-1 WHERE `id`=%d LIMIT 1", account_id);
    mysql_query(mysql, query, false);
    return 1;
}

public: LoadPlayerData(playerid)
{
    LoadCarGarage[playerid] = 0;

    // Resolve garages.owner_id BEFORE the original account loader builds GUI 50.
    // This guarantees the garage spawn card is present immediately after purchase
    // on the next authorization, even if accounts.garage was stale.
    SyncPlayerGarageData(playerid);

    #if defined garage_LoadPlayerData
        return garage_LoadPlayerData(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_LoadPlayerData
    #undef LoadPlayerData
#else
    #define _ALS_LoadPlayerData
#endif
#define LoadPlayerData garage_LoadPlayerData
#if defined garage_LoadPlayerData
    forward garage_LoadPlayerData(playerid);
#endif

stock GarageGetSafeExitTransform(garageid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    // Admin-defined exit is authoritative and is used EXACTLY as saved.
    // This lets /setedit pos exit [garageid] place the final exit point by standing on it.
    if(floatabs(GetGarageData(garageid, GARAGE_SAFE_EXIT_Z)) > 0.001)
    {
        x = GetGarageData(garageid, GARAGE_SAFE_EXIT_X);
        y = GetGarageData(garageid, GARAGE_SAFE_EXIT_Y);
        z = GetGarageData(garageid, GARAGE_SAFE_EXIT_Z);
        a = GetGarageData(garageid, GARAGE_SAFE_EXIT_ANGLE);
        return 1;
    }

    new Float:gate_x = GetGarageData(garageid, GARAGE_X);
    new Float:gate_y = GetGarageData(garageid, GARAGE_Y);
    new Float:exit_x = GetGarageData(garageid, GARAGE_EXIT_X);
    new Float:exit_y = GetGarageData(garageid, GARAGE_EXIT_Y);
    new Float:dx = exit_x - gate_x;
    new Float:dy = exit_y - gate_y;
    new Float:length = floatsqroot(dx * dx + dy * dy);

    a = GetGarageData(garageid, GARAGE_EXIT_ANGLE);

    // Move strictly AWAY from the garage entrance instead of trusting the sign
    // of the recorded angle. This prevents the car from being placed behind the
    // exit point and pushed back into the garage texture.
    if(length > 0.05)
    {
        dx /= length;
        dy /= length;
        x = exit_x + dx * GARAGE_SAFE_EXIT_DISTANCE;
        y = exit_y + dy * GARAGE_SAFE_EXIT_DISTANCE;

        // Keep the vehicle FRONT aimed away from the entrance. Some old garage
        // rows have an exit angle saved in the opposite direction.
        new Float:front_x = floatsin(-a, degrees);
        new Float:front_y = floatcos(-a, degrees);
        if(front_x * dx + front_y * dy < 0.0)
        {
            a += 180.0;
            if(a >= 360.0) a -= 360.0;
        }
    }
    else
    {
        x = exit_x + floatsin(-a, degrees) * GARAGE_SAFE_EXIT_DISTANCE;
        y = exit_y + floatcos(-a, degrees) * GARAGE_SAFE_EXIT_DISTANCE;
    }

    z = GetGarageData(garageid, GARAGE_EXIT_Z) + GARAGE_SAFE_EXIT_Z_OFFSET;
    return 1;
}

stock GarageGetVehicleExitTransform(garageid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    // Separate admin-defined car exit. The vehicle is placed EXACTLY here.
    // /setedit pos vehicleexit [garageid] (alias: carexit)
    if(floatabs(GetGarageData(garageid, GARAGE_VEHICLE_EXIT_Z)) > 0.001)
    {
        x = GetGarageData(garageid, GARAGE_VEHICLE_EXIT_X);
        y = GetGarageData(garageid, GARAGE_VEHICLE_EXIT_Y);
        z = GetGarageData(garageid, GARAGE_VEHICLE_EXIT_Z);
        a = GetGarageData(garageid, GARAGE_VEHICLE_EXIT_ANGLE);
        return 1;
    }

    // Backward compatibility: until a dedicated car point is configured,
    // use the existing safe/player exit instead of breaking old garages.
    return GarageGetSafeExitTransform(garageid, x, y, z, a);
}

stock GarageGetPlayerSpawnTransform(garageid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    // A per-garage point set by /setedit pos spawn [id] has priority.
    if(floatabs(GetGarageData(garageid, GARAGE_SPAWN_Z)) > 0.001)
    {
        x = GetGarageData(garageid, GARAGE_SPAWN_X);
        y = GetGarageData(garageid, GARAGE_SPAWN_Y);
        z = GetGarageData(garageid, GARAGE_SPAWN_Z);
        a = GetGarageData(garageid, GARAGE_SPAWN_ANGLE);
        return 1;
    }

    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        // Premium / large garage: exact PLAYER coordinate supplied by developer.
        x = 500.4164;
        y = 1983.3029;
        z = 1547.7197;
        a = 3.5827;
    }
    else
    {
        // Standard / low-class garage: exact PLAYER coordinate supplied by developer.
        x = 2.5793;
        y = 2001.3175;
        z = 1554.2431;
        a = 95.4341;
    }
    return 1;
}

stock GaragePreparePlayerSpawn(playerid)
{
    SyncPlayerGarageData(playerid);
    new garageid = GetPlayerGarage(playerid);
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;
    if(GetGarageData(garageid, GARAGE_OWNER_ID) != GetPlayerAccountID(playerid)) return 0;

    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageGetPlayerSpawnTransform(garageid, x, y, z, a)) return 0;

    new garage_db_id = GetGarageData(garageid, GARAGE_ID);
    SetPVarInt(playerid, "garage_spawn_pending", garage_db_id);
    SetPVarInt(playerid, "garage_session_dbid", garage_db_id);
    SetPlayerInGarage(playerid, garageid);

    SetSpawnInfo(playerid, 0, GetPlayerSkinEx(playerid), x, y, z, a, 0, 0, 0, 0, 0, 0);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, garageid + 2000);
    return 1;
}

forward GarageApplyPendingPlayerSpawn(playerid);
public GarageApplyPendingPlayerSpawn(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new garage_db_id = GetPVarInt(playerid, "garage_spawn_pending");
    if(garage_db_id <= 0) return 0;

    new garageid = GetGarageIndexByDbId(garage_db_id);
    if(garageid < 0 || garageid >= g_garage_loaded ||
       GetGarageData(garageid, GARAGE_OWNER_ID) != GetPlayerAccountID(playerid))
    {
        DeletePVar(playerid, "garage_spawn_pending");
        DeletePVar(playerid, "garage_session_dbid");
        SetPlayerInGarage(playerid, -1);
        return 0;
    }

    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageGetPlayerSpawnTransform(garageid, x, y, z, a)) return 0;

    new bool:wrong_world = (GetPlayerInterior(playerid) != 1 || GetPlayerVirtualWorld(playerid) != garageid + 2000);
    new bool:far_from_spawn = !IsPlayerInRangeOfPoint(playerid, 35.0, x, y, z);

    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, garageid + 2000);
    if(wrong_world || far_from_spawn)
    {
        SetPlayerPos(playerid, x, y, z);
        SetPlayerFacingAngle(playerid, a);
        SetCameraBehindPlayer(playerid);
    }

    SetPlayerInGarage(playerid, garageid);
    SetPVarInt(playerid, "garage_session_dbid", garage_db_id);
    return 1;
}

forward GarageFinalizePendingPlayerSpawn(playerid);
public GarageFinalizePendingPlayerSpawn(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(GetPVarInt(playerid, "garage_spawn_pending") <= 0) return 0;
    GarageApplyPendingPlayerSpawn(playerid);
    DeletePVar(playerid, "garage_spawn_pending");
    return 1;
}

public OnPlayerSpawn(playerid)
{
    LoadCarGarage[playerid] = 0;

    new pending_db_id = GetPVarInt(playerid, "garage_spawn_pending");
    new pending_garage = GetGarageIndexByDbId(pending_db_id);
    if(pending_garage >= 0 && pending_garage < g_garage_loaded &&
       GetGarageData(pending_garage, GARAGE_OWNER_ID) == GetPlayerAccountID(playerid))
    {
        SetPlayerInGarage(playerid, pending_garage);
        SetPVarInt(playerid, "garage_session_dbid", pending_db_id);
    }
    else if(GarageResolveCurrentInterior(playerid) == -1)
    {
        SetPlayerInGarage(playerid, -1);
    }

    new result = 1;
    #if defined garage_OnPlayerSpawn
        result = garage_OnPlayerSpawn(playerid);
    #endif

    // Re-assert the selected garage after the entire OnPlayerSpawn callback chain.
    // Some legacy systems set the default Arzamas spawn after SpawnPlayer; these
    // checks put the player back only if another callback actually moved him out.
    if(GetPVarInt(playerid, "garage_spawn_pending") > 0)
    {
        SetTimerEx("GarageApplyPendingPlayerSpawn", 150, false, "i", playerid);
        SetTimerEx("GarageApplyPendingPlayerSpawn", 700, false, "i", playerid);
        SetTimerEx("GarageApplyPendingPlayerSpawn", 1500, false, "i", playerid);
        SetTimerEx("GarageApplyPendingPlayerSpawn", 2600, false, "i", playerid);
        SetTimerEx("GarageFinalizePendingPlayerSpawn", 4200, false, "i", playerid);
    }

    return result;
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn garage_OnPlayerSpawn
#if defined garage_OnPlayerSpawn
    forward garage_OnPlayerSpawn(playerid);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
    LoadCarGarage[playerid] = 0;
    SetPlayerData(playerid, P_IN_GARAGE, -1);
    DeletePVar(playerid, "garage_spawn_pending");
    DeletePVar(playerid, "garage_session_dbid");

    #if defined garage_OnPlayerDeath
        return garage_OnPlayerDeath(playerid, killerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath garage_OnPlayerDeath
#if defined garage_OnPlayerDeath
    forward garage_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
        switch(action_type)
   {
                case PICKUP_ACTION_TYPE_GARAGE_EXIT:
    {
     new in_garage = GarageResolveCurrentInterior(playerid);
     if(in_garage != -1)
     {
       new Float:exit_x, Float:exit_y, Float:exit_z, Float:exit_a;
       if(GarageGetSafeExitTransform(in_garage, exit_x, exit_y, exit_z, exit_a))
       {
         DeletePVar(playerid, "garage_spawn_pending");
         DeletePVar(playerid, "garage_session_dbid");
         SetPlayerInGarage(playerid, -1);
         SetPlayerPosEx(playerid, exit_x, exit_y, exit_z, exit_a, 0, 0);
       }
     }
    }
    case PICKUP_ACTION_TYPE_GARAGE:
    {
     ShowPlayerGarageInfo(playerid, action_id);
    }
   }
    #if defined garage_OnPlayerPickUpPickupEx
        return garage_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx garage_OnPlayerPickUpPickupEx
#if defined garage_OnPlayerPickUpPickupEx
    forward garage_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

public: ShowPlayerGarageInfo(playerid, garageid)
{
   SetPlayerUseListitem(playerid, garageid);

   new fmt_str[60];
   new string[256];

   if(IsGarageOwned(garageid))
   {
    format(fmt_str, sizeof fmt_str, "{FFFFFF}Владелец:\t\t\t{33CCFF}%s\n\n", GetGarageData(garageid, G_OWNER_NAME));
    strcat(string, fmt_str);
   }

    format(fmt_str, sizeof fmt_str, "{ffffff}Номер гаража:\t\t\t%d\n", garageid);
    strcat(string, fmt_str);

    if(!IsGarageOwned(garageid)) strcat(string, "\n");

   format(fmt_str, sizeof fmt_str, "{ffffff}Стоимость:{ffff00}\t\t\t30.000.000 руб{ffffff}\n", GetGarageData(garageid, GARAGE_PRICE));
   strcat(string, fmt_str);

   if(IsGarageOwned(garageid))
   {
    Dialog(playerid, DIALOG_GARAGE_ENTER, DIALOG_STYLE_MSGBOX, "{FF9900}Гараж занят", string, "Войти", "Отмена");
   }
   else Dialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{33CC00}Гараж свободен", string, "Купить", "Отмена");
}

stock GetNearestGarageEntrance(playerid, Float:range = 12.0)
{
    new Float:px, Float:py, Float:pz;

    // В машине берём позицию именно транспорта: на мобильном клиенте позиция playerid у ворот
    // иногда обновляется позже позиции автомобиля и старый радиус 7м пропускал гудок.
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            GetVehiclePos(vehicleid, px, py, pz);
        else
            GetPlayerPos(playerid, px, py, pz);
    }
    else GetPlayerPos(playerid, px, py, pz);

    // Сначала свой гараж, чтобы рядом стоящие гаражи не перехватывали гудок.
    new own = GetPlayerGarage(playerid);
    if(own >= 0 && own < g_garage_loaded)
    {
        new Float:dx = px - GetGarageData(own, GARAGE_X);
        new Float:dy = py - GetGarageData(own, GARAGE_Y);
        new Float:dz = pz - GetGarageData(own, GARAGE_Z);
        if(dx*dx + dy*dy + dz*dz <= range*range) return own;
    }

    new nearest = -1;
    new Float:best_dist_sq = range * range;
    for(new idx = 0; idx < g_garage_loaded; idx++)
    {
        new Float:dx = px - GetGarageData(idx, GARAGE_X);
        new Float:dy = py - GetGarageData(idx, GARAGE_Y);
        new Float:dz = pz - GetGarageData(idx, GARAGE_Z);
        new Float:dist_sq = dx * dx + dy * dy + dz * dz;
        if(dist_sq <= best_dist_sq)
        {
            best_dist_sq = dist_sq;
            nearest = idx;
        }
    }
    return nearest;
}

stock IsGarageAccessAllowed(playerid, garageid)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;
    if(!IsGarageOwned(garageid)) return 0;
    if(GetGarageData(garageid, GARAGE_OWNER_ID) == GetPlayerAccountID(playerid)) return 1;
    return GetGarageData(garageid, GARAGE_STATUS) == 0;
}

stock MoveVehicleAndOccupantsToGarage(vehicleid, garageid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    if(!PutVehicleDirectlyInGarage(vehicleid, garageid)) return 0;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerInVehicle(i, vehicleid)) continue;
        SetPlayerInterior(i, 1);
        SetPlayerVirtualWorld(i, garageid + 2000);
        SetPlayerInGarage(i, garageid);
        DeletePVar(i, "garage_spawn_pending");
        SetPVarInt(i, "garage_session_dbid", GetGarageData(garageid, GARAGE_ID));
        SetCameraBehindPlayer(i);
    }
    return 1;
}

forward GarageEnsureVehicleOutside(vehicleid, garageid);
public GarageEnsureVehicleOutside(vehicleid, garageid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    // A delayed garage-placement callback must never be allowed to win after exit.
    if(g_vehicle_garage_index[vehicleid] != -1 || g_vehicle_garage_slot[vehicleid] != -1) return 0;
    if(GetVehicleVirtualWorld(vehicleid) != 0) return 0;

    new Float:safe_x, Float:safe_y, Float:safe_z, Float:safe_a;
    if(!GarageGetVehicleExitTransform(garageid, safe_x, safe_y, safe_z, safe_a)) return 0;

    new Float:vx, Float:vy, Float:vz;
    GetVehiclePos(vehicleid, vx, vy, vz);

    new Float:gate_x = GetGarageData(garageid, GARAGE_X);
    new Float:gate_y = GetGarageData(garageid, GARAGE_Y);
    new Float:current_dist = floatsqroot((vx - gate_x) * (vx - gate_x) + (vy - gate_y) * (vy - gate_y));
    new Float:safe_dist = floatsqroot((safe_x - gate_x) * (safe_x - gate_x) + (safe_y - gate_y) * (safe_y - gate_y));

    // Only correct the vehicle if a stream/tuning callback actually pulled it
    // back toward the gate. If the player already drove farther away, do nothing.
    if(current_dist + 0.35 < safe_dist)
    {
        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
        SetVehiclePos(vehicleid, safe_x, safe_y, safe_z);
        SetVehicleZAngle(vehicleid, safe_a);
    }
    return 1;
}

stock ExitVehicleFromGarage(playerid, garageid)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;

    new Float:exit_x, Float:exit_y, Float:exit_z, Float:exit_a;
    if(!GarageGetVehicleExitTransform(garageid, exit_x, exit_y, exit_z, exit_a)) return 0;

    // Clear the garage binding FIRST. Delivery/tuning timers check this binding,
    // so they can no longer return the vehicle to its old indoor parking slot.
    Garage_ResetVehicleBinding(vehicleid);

    SetVehicleVirtualWorld(vehicleid, 0);
    LinkVehicleToInterior(vehicleid, 0);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehiclePos(vehicleid, exit_x, exit_y, exit_z);
    SetVehicleZAngle(vehicleid, exit_a);

    // Mobile clients may briefly reuse the last streamed indoor transform.
    // Re-check shortly afterwards, but only push the car outward - never back.
    SetTimerEx("GarageEnsureVehicleOutside", 140, false, "ii", vehicleid, garageid);
    SetTimerEx("GarageEnsureVehicleOutside", 420, false, "ii", vehicleid, garageid);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerInVehicle(i, vehicleid)) continue;
        SetPlayerVirtualWorld(i, 0);
        SetPlayerInterior(i, 0);
        SetPlayerInGarage(i, -1);
        DeletePVar(i, "garage_spawn_pending");
        DeletePVar(i, "garage_session_dbid");
        SetCameraBehindPlayer(i);
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH))
    {
        // Гудок внутри гаража: водитель выезжает наружу вместе со всеми пассажирами.
        new in_garage = GetPlayerInGarage(playerid);
        if(in_garage >= 0 && in_garage < g_garage_loaded && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            if(IsPlayerInRangeOfPoint(playerid, 8.0, -0.2940, 2006.1188, 1554.2031) ||
               IsPlayerInRangeOfPoint(playerid, 8.0, 492.663848, 1988.835205, 1548.586645))
            {
                if(ExitVehicleFromGarage(playerid, in_garage)) return 1;
            }
        }

        // Гудок у внешних ворот: владелец въезжает всегда, чужой игрок — только когда гараж открыт.
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerInterior(playerid) == 0)
        {
            new garageid = GetNearestGarageEntrance(playerid, 12.0);
            if(garageid != -1 && IsGarageOwned(garageid))
            {
                if(!IsGarageAccessAllowed(playerid, garageid))
                    return SendClientMessage(playerid, 0xCC3333FF, "Гараж закрыт. Въезд разрешен только владельцу.");

                new vehicleid = GetPlayerVehicleID(playerid);
                if(MoveVehicleAndOccupantsToGarage(vehicleid, garageid))
                {
                    if(GetGarageData(garageid, GARAGE_OWNER_ID) == GetPlayerAccountID(playerid))
                        SendClientMessage(playerid, 0x66CC33FF, "Вы въехали в свой гараж.");
                    else
                        SendClientMessage(playerid, 0x66CC33FF, "Вы въехали в открытый гараж другого игрока.");
                    return 1;
                }
            }
        }
    }

   #if defined garage_OnPlayerKeyStateChange
        return garage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange garage_OnPlayerKeyStateChange
#if defined garage_OnPlayerKeyStateChange
    forward garage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
   if(dialogid == DIALOG_GARAGE_IMPROVEMENT)
 {
     if(response)
  {
   switch(listitem)
   {
    case 0:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
    case 1:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
    case 2:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
    case 3:
    {
    new garageid = GetPlayerGarage(playerid);
    
    if(GetPlayerInGarage(playerid) != -1)
    {
       SendClientMessage(playerid, 0xCECECEFF, "Вы должны находится на улице");
    }
    else 
    {
       if(GetPlayerMoneyEx(playerid) < 5000000) return SendClientMessage(playerid, 0xCECECEFF, "Для покупки этого улучшения нужно иметь 5.000.000 рублей!");
       ShowPlayerDialog(playerid, DIALOG_GARAGE_IMPROVEMENT_CONFIRM, DIALOG_STYLE_MSGBOX, "{ff0000}Улучшение", "При покупке этого улучшения Вы измените интерьер своего гаража\nи сможете доставлять в гараж больше автомобилей\n\nСтоимость ремонта гаража: 5.000.000 рублей.\nВы уверены, что хотите продолжить?", "Далее", "Выйти");
    }
    }
   }
  }
  else return 1;
 }
 if(dialogid == DIALOG_GARAGE_IMPROVEMENT_CONFIRM)
 {
 new query[255];
 new garageid = GetPlayerGarage(playerid);
 
    if(response)
    {
   format(query, sizeof query, "UPDATE garages SET improvements=2 WHERE id=%d LIMIT 1",  GetGarageData(garageid, GARAGE_ID));
        mysql_query(mysql, query, false);
        SetGarageData(garageid, GARAGE_IMPROVEMENTS, 2);
#if USE_ZOMENO_OLD_ENGINE == 0
        ShowNotification(playerid, 3, "Улучшение было куплено!", 3, "", "");
        ShowNotification(playerid, 0, "Вы потратили 5000000 рублей", 3, "", "");
        GivePlayerMoneyEx(playerid, -5000000);
#else
        ShowNotificationNew(playerid, 3, 5, 1, 10, "Улучшение было куплено!", "");
        GivePlayerMoneyEx(playerid, -5000000);
#endif
     }
      else 
        {
        Dialog
               (
                    playerid, DIALOG_GARAGE_IMPROVEMENT, DIALOG_STYLE_LIST, 
                    "{ff0000}Улучшения",
                    "{FFFFFF}Название\t \t \t \t \t \t \t \t \t{FFFFFF}Цена\t \t \t \t \t \t \t \t \t{FFFFFF}Статус\n"\
                    "{ffffff}1. Возможность проживания в гараже\t{ffffff}30000 руб.\t\t{66CC00}имеется\n"\
                    "{ffffff}2. Сейф в гараже{ffffff}\t\t\t\t\t\t\t\t\t40000 руб.\t\t\t\t\t{66CC00}имеется\n"\
                    "{ffffff}3. Улучшить до элитного\t\t\t\t\t{ffffff}5000000 руб.\t\t\t\t\t{ff0000}не имеется",
                    "Далее", "Выйти"
                );
        }
    }
    if(dialogid == DIALOG_GARAGE_INFO)
 {
  if(response)
  {
   ShowPlayerGarageDialog(playerid);
  }
 }
 if(dialogid == DIALOG_GARAGE_SELL) 
 {
  new garageid = GetPlayerGarage(playerid);
  if(garageid != -1)
  {
   if(response)
   {
    SellGarage(playerid);
   }
  }
 }
 if(dialogid == 2432)
 {
 if(response)
  {
   switch(listitem)
   {
    case 0:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
    case 1:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
    case 2:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
    case 3:
    {
    SendClientMessage(playerid, 0x999999FF, ""USC"У вас уже приобретено это улучшение");
    }
   }
  }
  else return 1;
 }
 if(dialogid == DIALOG_GARAGE_SETTINGS) 
   {
   new garageid = GetPlayerGarage(playerid);
     if(response)
     {
       switch(listitem)
       {
        case 0:
        {
          if(garageid == -1 || GetGarageData(garageid, GARAGE_OWNER_ID) != GetPlayerAccountID(playerid))
              return SendClientMessage(playerid, 0xCC3333FF, "Вы не являетесь владельцем этого гаража.");

          new new_status = GetGarageData(garageid, GARAGE_STATUS) ? 0 : 1;
          SetGarageData(garageid, GARAGE_STATUS, new_status);

          new query[128];
          mysql_format(mysql, query, sizeof query, "UPDATE `garages` SET `lock`=%d WHERE `id`=%d LIMIT 1", new_status, GetGarageData(garageid, GARAGE_ID));
          mysql_query(mysql, query, false);
          UpdateGarageInfo(garageid);

          if(new_status)
              SendClientMessage(playerid, 0xCC3333FF, "Гараж закрыт. Чужие игроки больше не смогут заехать по гудку.");
          else
              SendClientMessage(playerid, 0x66CC33FF, "Гараж открыт. Теперь другие игроки смогут заехать по гудку.");
          return ShowPlayerGarageDialog(playerid);
        }
        case 1:
        {
        callcmd::sellgarage(playerid, "");
        }
        case 2:
        {
        if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 1)
          {
    Dialog
                                    (
                                         playerid, DIALOG_GARAGE_IMPROVEMENT, DIALOG_STYLE_LIST, 
                                        "{ff0000}Улучшения",
                                        "{FFFFFF}Название\t \t \t \t \t \t \t \t \t{FFFFFF}Цена\t \t \t \t \t \t \t \t \t{FFFFFF}Статус\n"\
                                        "{ffffff}1. Возможность проживания в гараже\t{ffffff}30000 руб.\t\t{66CC00}имеется\n"\
                                        "{ffffff}2. Сейф в гараже{ffffff}\t\t\t\t\t\t\t\t\t40000 руб.\t\t\t\t\t{66CC00}имеется\n"\
                                        "{ffffff}3. Улучшить до элитного\t\t\t\t\t{ffffff}5000000 руб.\t\t\t\t\t{ff0000}не имеется",
                                        "Далее", "Выйти"
                                    );
                               }
                               else if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
          {
    Dialog
                                    (
                                         playerid, 2432, DIALOG_STYLE_LIST, 
                                        "{ff0000}Улучшения",
                                        "{FFFFFF}Название\t \t \t \t \t \t \t \t \t{FFFFFF}Цена\t \t \t \t \t \t \t \t \t{FFFFFF}Статус\n"\
                                        "{ffffff}1. Возможность проживания в гараже\t{ffffff}30000 руб.\t\t{66CC00}имеется\n"\
                                        "{ffffff}2. Сейф в гараже{ffffff}\t\t\t\t\t\t\t\t\t40000 руб.\t\t\t\t\t{66CC00}имеется\n"\
                                        "{ffffff}3. Улучшить до элитного\t\t\t\t\t{ffffff}5000000 руб.\t\t\t\t\t{66CC00}имеется",
                                        "Далее", "Выйти"
                                    );
                               }
        }
        case 3:
        {
         if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 1) LoadCarGarage[playerid] = 1;     
                                    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2) LoadCarGarage[playerid] = 2;

          ShowGarageOwnableCarListDialog(playerid);
        }
        case 4:
        {
          new Float: x = GetGarageData(garageid, GARAGE_X);
                      new Float: y = GetGarageData(garageid, GARAGE_Y);
        new Float: z = GetGarageData(garageid, GARAGE_Z);
                          
        if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
          {
            if(GetPlayerMoneyEx(playerid) >= 300)
            {
              GivePlayerMoneyEx(playerid, -300, "Метка ТС на GPS", true, true);

              EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего гаража отмечено на GPS");
              return 1;
            }
            else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
          }
          else SendClientMessage(playerid, 0xCECECEFF, "На Вашем GPS уже отмечено место");
        }
        case 5:
        {
          SendClientMessage(playerid, 0x999999FF, "Используйте команду /sellmygarage");
                                }
       }
     }
     else 
     {
      LoadCarGarage[playerid] = 0;
      ShowPlayerGarageDialog(playerid);
     }
   }
 if(dialogid == DIALOG_GARAGE_CAR_SELECT)
 {
    if(!response)
    {
        LoadCarGarage[playerid] = 0;
        DeletePVar(playerid, "garage_delivery_index");
        return ShowPlayerGarageDialog(playerid);
    }

    new sql_id = GetPlayerListitemValue(playerid, listitem);
    new garageid = GetPVarInt(playerid, "garage_delivery_index");
    if(sql_id <= 0)
    {
        LoadCarGarage[playerid] = 0;
        return SendClientMessage(playerid, 0xCECECEFF, "Не удалось определить выбранную машину");
    }
    return DeliverCarSqlIdToGarage(playerid, sql_id, garageid);
 }
 if(dialogid == DIALOG_GARAGE_BUY) 
 {
      new garageid = GetPlayerUseListitem(playerid);
  
      if(response)
    {
              if(GetPlayerGarage(playerid) == -1)
            {
        if(!IsGarageOwned(garageid))
        {
         if(GetPlayerMoneyEx(playerid) >= 30000000)
         {
          SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы купили новый гараж");
          BuyPlayerGarage(playerid, garageid);
         }
         else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого гаража");
        }
        else
        {
         new fmt_str[64];

         format(fmt_str, sizeof fmt_str, "Этот гараж уже куплен. Владелец: %s", GetGarageData(garageid, G_OWNER_NAME));
         SendClientMessage(playerid, 0xCECECEFF, fmt_str);
        }
       }
       else SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть гараж. Чтобы купить новый - необходимо продать старый");
    }
    else return 1;
   }
   if(dialogid == DIALOG_GARAGE_ENTER)
   {
    new garageid = GetPlayerUseListitem(playerid);
    if(response)
    {
        if(!IsGarageAccessAllowed(playerid, garageid))
            return SendClientMessage(playerid, 0xCC3333FF, "Гараж закрыт. Войти может только владелец.");
        EnterPlayerToGarage(playerid, garageid);
    }
    else return 1;
   }
   if(dialogid == DIALOG_OWNABLE_CAR_LOAD_GARAGE)
   {
    if(!response)
    {
     LoadCarGarage[playerid] = 0;
     return 1;
    }
    if(response)
    {
     new idx = GetPVarInt(playerid, "ownablecar_id"),
      Float: x,
      Float: y,
      Float: z,
      Cache: result,
      query[100];

     mysql_format(mysql, query, sizeof query, "SELECT pos_x, pos_y, pos_z FROM ownable_cars WHERE id='%d'", idx);
     result = mysql_query(mysql, query, true);

     if(cache_num_rows())
     {
      x = cache_get_row_float(0, 0);
      y = cache_get_row_float(0, 1);
      z = cache_get_row_float(0, 2);
     }

     cache_delete(result);

              if(LoadCarGarage[playerid] == 0)
         {
      switch(listitem + 1)
      {
       case 1:
       {
        if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
        {
         if(GetPlayerMoneyEx(playerid) >= 300)
         {
          GivePlayerMoneyEx(playerid, -300, "Метка ТС на GPS", true, true);

          EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
          return 1;
         }
         else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
        }
        else SendClientMessage(playerid, 0xCECECEFF, "На Вашем GPS уже отмечено место");
       }
       case 2:
       {
        SCM(playerid, -1, "{FFFF00}| {FFFFFF}Временно не доступно.");
       } 
       case 3:
       {
        if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
        {
         SendClientMessage(playerid, 0x999999FF, "Системная ошибка. Транспорт уже загружен.");
         return 1;
        }
        else
        {
         if(GetPVarInt(playerid, "rent_true") != 1)
         {
          if(LoadOwnableCar(idx, playerid) != -1)
          {
           PlayerOwnableCarInit(playerid);
           SendClientMessage(playerid, 0x66CC33FF, "Ваш транспорт успешно загружен!");
          }
          else SendClientMessage(playerid, 0x999999FF, "Ошибка при загрузке личного транспорта");
         }
         else 
         {
          if(GetPlayerMoneyEx(playerid) >= GetPVarInt(playerid, "price_rent"))
          {
           if(LoadOwnableCarRent(playerid, idx) != -1)
           {
            PlayerOwnableCarInit(playerid);
            PutPlayerInVehicle(playerid, GetPlayerData(playerid, P_OWNABLE_CAR), 0);
            SendClientMessage(playerid, 0x66CC33FF, "Ваш транспорт успешно выгружен!");

            GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "price_rent"));
            DeletePVar(playerid, "price_rent");
            DeletePVar(playerid, "rent_true");
           }
           else SendClientMessage(playerid, 0x999999FF, "Ошибка при загрузке личного транспорта");
          }
         }
        }
       }
      }
     }
     else
     {
      new garageid = GetPlayerGarage(playerid);
              
                  new Float: x = GetGarageData(garageid, GARAGE_X);
                  new Float: y = GetGarageData(garageid, GARAGE_Y);
                  new Float: z = GetGarageData(garageid, GARAGE_Z);
    
     switch(listitem + 1)
     {
      case 1:
      {
       if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
       {
        if(GetPlayerMoneyEx(playerid) >= 300)
        {
         GivePlayerMoneyEx(playerid, -300, "Метка ТС на GPS", true, true);

         EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение загрузки Вашего транспорта отмечено на GPS");
         LoadCarGarage[playerid] = 0;
         return 1;
        }
        else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
       }
       else SendClientMessage(playerid, 0xCECECEFF, "На Вашем GPS уже отмечено место");
       LoadCarGarage[playerid] = 0;
      }
      case 2:
      {
       if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
       {
        SendClientMessage(playerid, 0x999999FF, "Системная ошибка. Транспорт уже загружен.");
        LoadCarGarage[playerid] = 0;
        return 1;
       }
       else
       {
        if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 1)
        {
           LoadCarGarage[playerid] = 1;
        }
        if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
        {
           LoadCarGarage[playerid] = 2;
        }
        if(GetPVarInt(playerid, "rent_true") != 1)
        {
         if(LoadOwnableCar(idx, playerid) != -1)
         {
          PlayerOwnableCarInit(playerid);
          PutOwnableCarInGarage(playerid, garageid);
          SendClientMessage(playerid, 0x66CC33FF, "Ваш транспорт успешно загружен в гараж!");
          LoadCarGarage[playerid] = 0;
         }
         else SendClientMessage(playerid, 0x999999FF, "Ошибка при загрузке личного транспорта");
        }
       }
      }
     }
    }
   }
   else
   {
       LoadCarGarage[playerid] = 0;
     if(GetPVarInt(playerid, "show_menu"))
     {
      DeletePVar(playerid, "show_menu");
      callcmd::car(playerid, "");
     }
   }
   
   return 1;
   }
    #if defined garage_OnDialogResponse
    return garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse garage_OnDialogResponse
#if defined garage_OnDialogResponse
forward garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock ShowGarageOwnableCarListDialog(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1)
    {
        LoadCarGarage[playerid] = 0;
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет гаража или данные гаража не загружены");
    }

    new query[160], Cache:result;
    mysql_format(mysql, query, sizeof query, "SELECT id,model_id,number FROM ownable_cars WHERE owner_id=%d ORDER BY id ASC", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    if(mysql_errno(mysql) != 0)
    {
        cache_delete(result);
        LoadCarGarage[playerid] = 0;
        return SendClientMessage(playerid, 0xCECECEFF, "Ошибка БД при загрузке списка транспорта");
    }

    new rows = cache_num_rows();
    if(rows <= 0)
    {
        cache_delete(result);
        LoadCarGarage[playerid] = 0;
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет личного транспорта");
    }

    ClearPlayerListitemValues(playerid);
    new text[4096], garage_line[128], model_name[32], plate[32];
    text[0] = EOS;
    strcat(text, "Авто\tНомер\n");
    new count = 0;
    for(new row = 0; row < rows && count < 40; row++)
    {
        new sql_id = cache_get_field_content_int(row, "id");
        new model_id = cache_get_field_content_int(row, "model_id");
        cache_get_field_content(row, "number", plate, mysql, sizeof plate);
        GetVehicleModelName(model_id, model_name, sizeof(model_name));
        garage_line[0] = EOS;
        strcat(garage_line, model_name);
        strcat(garage_line, "\t");
        strcat(garage_line, plate);
        strcat(garage_line, "\n");
        strcat(text, garage_line);
        SetPlayerListitemValue(playerid, count, sql_id);
        count++;
    }
    cache_delete(result);

    SetPVarInt(playerid, "garage_delivery_index", garageid);
    Dialog(playerid, DIALOG_GARAGE_CAR_SELECT, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}Доставка транспорта в гараж", text, "Доставить", "Отмена");
    return 1;
}

stock ApplyOwnableCarSavedColorsForPlayer(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsValidVehicle(vehicleid)) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    new body_color = GetOwnableCarData(index, OC_body_colors);
    new wheel_color = GetOwnableCarData(index, OC_wheelcolors);

    // Explicitly apply 0/0 too: leaving the vehicle untouched causes the mobile client to show its blue default.


    SetVehicleColorHexForPlayers(playerid, vehicleid, body_color, wheel_color);
    return 1;
}

stock GarageReloadOwnableCarStraight(playerid, sql_id, garageid)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return -1;
    if(sql_id <= 0) return -2;

    // If this exact car is already loaded, remote rotation is not authoritative
    // while it is empty. Recreate it instead. This is the core difference from
    // driving into the garage, where a driver is present and SetVehicleZAngle works.
    new vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        if(GarageVehicleHasOccupants(vehicleid)) return -3;
        if(UnloadOwnableCarBySqlID(playerid, sql_id) != 1) return -4;
    }

    // The project supports one active personal vehicle per player. If another
    // personal vehicle is loaded, unload it before creating the selected car.
    new current_vehicle = GetPlayerOwnableCar(playerid);
    if(current_vehicle != INVALID_VEHICLE_ID && IsValidVehicle(current_vehicle))
    {
        if(GarageVehicleHasOccupants(current_vehicle)) return -3;
        if(UnloadPlayerOwnableCar(playerid, true) != 1) return -4;
    }

    new slot = GetFreeGarageParkingSlot(garageid, INVALID_VEHICLE_ID);
    if(slot == -1) return -5;

    // Arm a one-shot CreateVehicle override. LoadOwnableCar consumes these exact
    // coordinates/heading, so the native vehicle is born straight in the slot.
    if(!GarageArmOwnableSpawnOverride(sql_id, garageid, slot)) return -5;
    new load_result = LoadOwnableCar(sql_id);
    GarageClearOwnableSpawnOverride();
    if(load_result == -1) return -6;

    vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return -6;

    SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
    SetPVarInt(playerid, "ownable_vehicle_id", vehicleid);

    // Apply saved tuning before the vehicle is moved to the player's garage world.
    // The player cannot stream the world-0 creation, so no old transform is visible.
    LoadTuning(playerid);

    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageGetParkingSlotTransform(garageid, slot, x, y, z, a)) return -5;

    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, garageid + 2000);
    SetVehiclePos(vehicleid, x, y, z);
    // The native CreateVehicle call already used 'a'. Keep this call for occupied
    // edge cases, but correctness no longer depends on rotating an empty car.
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);

    g_vehicle_garage_index[vehicleid] = garageid;
    g_vehicle_garage_slot[vehicleid] = slot;

    ApplyOwnableCarSavedColorsForPlayer(playerid, vehicleid);
    return vehicleid;
}

stock DeliverCarSqlIdToGarage(playerid, sql_id, garageid)
{
    if(garageid < 0 || garageid >= g_garage_loaded || GetGarageData(garageid, GARAGE_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден или Вы не являетесь его владельцем");

    if(sql_id <= 0) return SendClientMessage(playerid, 0xCECECEFF, "Некорректный ID транспорта");

    new query[160], Cache:result;
    mysql_format(mysql, query, sizeof query, "SELECT id FROM ownable_cars WHERE id=%d AND owner_id=%d LIMIT 1", sql_id, GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    new bool:owned = (mysql_errno(mysql) == 0 && cache_num_rows() > 0);
    cache_delete(result);
    if(!owned) return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт Вам не принадлежит");

    new delivery_result = GarageReloadOwnableCarStraight(playerid, sql_id, garageid);
    if(delivery_result == -3)
    {
        LoadCarGarage[playerid] = 0;
        DeletePVar(playerid, "garage_delivery_index");
        return SendClientMessage(playerid, 0xCECECEFF, "Transport is occupied. Exit the vehicle before garage delivery.");
    }
    if(delivery_result < 1)
    {
        LoadCarGarage[playerid] = 0;
        DeletePVar(playerid, "garage_delivery_index");
        return SendClientMessage(playerid, 0xCECECEFF, "Garage delivery failed. No free slot or vehicle load error.");
    }

    LoadCarGarage[playerid] = 0;
    DeletePVar(playerid, "garage_delivery_index");
    printf("[GARAGE DELIVERY] player=%d account=%d garage_idx=%d garage_db=%d car_sql=%d vehicle=%d STRAIGHT-SPAWN", playerid, GetPlayerAccountID(playerid), garageid, GetGarageData(garageid, GARAGE_ID), sql_id, delivery_result);
    return SendClientMessage(playerid, 0x66CC33FF, "Транспорт успешно доставлен в Ваш гараж!");
}

stock ShowPlayerGarageDialog(playerid) 
{
Dialog
 (
  playerid, DIALOG_GARAGE_SETTINGS, DIALOG_STYLE_LIST,
  "{ffff00}Управление гаражем",
    "1. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}гараж\n"\
    "2. Продать гараж\n"\
    "3. Улучшения\n"\
    "4. Доставить транспорт в гараж\n"\
    "5. Отметить гараж на GPS\n"\
    "6. Продать гараж другому игроку", 
  "Выбрать",
  "Отмена"
 );
}

stock SellGarage(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
 new garageid = GetPlayerGarage(playerid);

 if(garageid != -1)
 {
  new garage_price = 30000000;
  new garage_percent = (garage_price * 30) / 100;

  new query[200];
  new return_money = (garage_price - garage_percent);

  SetPlayerData(playerid, P_GARAGE, -1);

  SetGarageData(garageid, GARAGE_OWNER_ID, 0);

  if(to_player == INVALID_PLAYER_ID)
  {
   AddPlayerData(playerid, P_BANK, +, return_money);

   BankLog(playerid, return_money, "Продажа гаража");

   SetGarageData(garageid, GARAGE_STATUS, 0);

   format(query, sizeof query, "UPDATE accounts a,garages g SET a.bank=%d,a.garage=-1,g.owner_id=0,g.lock=0 WHERE a.id=%d AND g.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetGarageData(garageid, GARAGE_ID));
   mysql_query(mysql, query, false);

   GivePlayerMoneyEx(playerid, 0, "Продажа гаража государству", false, false);
   UpdateGarageInfo(garageid);
            
            format(query, sizeof query, "UPDATE garages SET improvements=1 WHERE id=%d LIMIT 1",  GetGarageData(garageid, GARAGE_ID));
        mysql_query(mysql, query, false);
        SetGarageData(garageid, GARAGE_IMPROVEMENTS, 2);
            
   SendClientMessage(playerid, 0x66CC00FF, "Вы продали свой гараж!");

   format(query, sizeof query, "Налог за продажу бизнеса составил 30 процентов от его стоимости {99CC00}(%d руб)", garage_percent);
   SendClientMessage(playerid, 0xCECECEFF, query);

   format(query, sizeof query, "Итого на банковский счет перечислено: {3399FF}%d руб", return_money);
   SendClientMessage(playerid, 0xFFFFFFFF, query);
  }
  else
  {
   if(BuyPlayerGarage(to_player, garageid, true, price) == 1)
   {
    new total_price = price;

    format(query, sizeof query, "UPDATE accounts SET money=%d,garage=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, total_price, "Продажа гаража игроку", false, false);

    garage_price = price;
    garage_percent = 0;
   }
   else return ;
  }
  format(query, sizeof query, "~g~+%d rub~n~+%d rub", (garage_price - garage_percent));
  GameTextForPlayer(playerid, query, 4000, 1);
 }
}

stock EnterPlayerToGarage(playerid, garageid)
{
    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageGetPlayerSpawnTransform(garageid, x, y, z, a)) return 0;

    DeletePVar(playerid, "garage_spawn_pending");
    SetPVarInt(playerid, "garage_session_dbid", GetGarageData(garageid, GARAGE_ID));
    SetPlayerPosEx(playerid, x, y, z, a, 1, garageid + 2000);
    SetPlayerInGarage(playerid, garageid);
    return 1;
}

// Parking positions are taken directly from in-game VEHICLE coordinates.
// The 4th value is the exact FRONT direction (Z angle) recorded by the developer.
// Координаты большого гаража сняты прямо с VEHICLE-позиций в интерьере.
// Углы используются без каких-либо дополнительных разворотов: как записано разработчиком, так машина и ставится.
static const Float:g_small_garage_slots[][4] =
{
    {-0.053077, 2001.108886, 1554.203125, 358.0202}
};

static const Float:g_large_garage_slots[][4] =
{
    // Exact VEHICLE transforms recorded in the large garage interior (VW garageid+2000, INT 1).
    // The supplied Z-angle is already the desired FRONT direction; never add/subtract 180 degrees here.
    {498.1144, 2011.4840, 1546.8634, 336.3175},
    {497.7579, 2007.0754, 1546.8634, 60.1091},
    {497.7836, 2001.9765, 1546.8635, 57.4816},
    {497.8058, 1997.0471, 1546.8635, 54.7068},
    {505.7543, 2011.5400, 1546.8635, 321.9996},
    {505.8538, 2006.7685, 1546.8643, 302.1908},
    {505.2553, 2001.4718, 1546.8635, 300.4099},
    {505.3285, 1997.3212, 1546.8635, 308.2902},
    {505.1429, 1993.1505, 1546.8635, 302.1363},
    {505.2163, 1989.4876, 1546.8635, 298.6312}
};

stock GarageGetParkingSlotTransform(garageid, slot, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        if(slot < 0 || slot >= sizeof(g_large_garage_slots)) return 0;
        x = g_large_garage_slots[slot][0];
        y = g_large_garage_slots[slot][1];
        z = g_large_garage_slots[slot][2];
        a = g_large_garage_slots[slot][3];
        return 1;
    }

    if(slot < 0 || slot >= sizeof(g_small_garage_slots)) return 0;
    x = g_small_garage_slots[slot][0];
    y = g_small_garage_slots[slot][1];
    z = g_small_garage_slots[slot][2];
    a = g_small_garage_slots[slot][3];
    return 1;
}

stock GarageArmOwnableSpawnOverride(sql_id, garageid, slot)
{
    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageGetParkingSlotTransform(garageid, slot, x, y, z, a)) return 0;

    g_garage_spawn_override_sql_id = sql_id;
    g_garage_spawn_override_x = x;
    g_garage_spawn_override_y = y;
    g_garage_spawn_override_z = z;
    g_garage_spawn_override_a = a;
    g_garage_spawn_override_active = true;
    return 1;
}

stock GarageClearOwnableSpawnOverride()
{
    g_garage_spawn_override_active = false;
    g_garage_spawn_override_sql_id = 0;
    g_garage_spawn_override_x = 0.0;
    g_garage_spawn_override_y = 0.0;
    g_garage_spawn_override_z = 0.0;
    g_garage_spawn_override_a = 0.0;
    return 1;
}

stock GarageVehicleHasOccupants(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid)) continue;
        if(IsPlayerInVehicle(playerid, vehicleid)) return 1;
    }
    return 0;
}

stock IsGarageParkingSlotOccupied(garageid, Float:x, Float:y, Float:z, ignore_vehicleid = INVALID_VEHICLE_ID)
{
    new world = garageid + 2000;
    new Float:vx, Float:vy, Float:vz;
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(vehicleid == ignore_vehicleid || !IsValidVehicle(vehicleid)) continue;
        if(GetVehicleVirtualWorld(vehicleid) != world) continue;

        GetVehiclePos(vehicleid, vx, vy, vz);
        if(VectorSize(vx - x, vy - y, vz - z) < 3.25) return 1;
    }
    return 0;
}

stock GetFreeGarageParkingSlot(garageid, vehicleid)
{
    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        for(new slot = 0; slot < sizeof(g_large_garage_slots); slot++)
        {
            if(!IsGarageParkingSlotOccupied(garageid,
                g_large_garage_slots[slot][0],
                g_large_garage_slots[slot][1],
                g_large_garage_slots[slot][2],
                vehicleid)) return slot;
        }
        return -1;
    }

    for(new slot = 0; slot < sizeof(g_small_garage_slots); slot++)
    {
        if(!IsGarageParkingSlotOccupied(garageid,
            g_small_garage_slots[slot][0],
            g_small_garage_slots[slot][1],
            g_small_garage_slots[slot][2],
            vehicleid)) return slot;
    }
    return -1;
}


forward Garage_ResetVehicleBinding(vehicleid);
public Garage_ResetVehicleBinding(vehicleid)
{
    if(vehicleid < 0 || vehicleid >= MAX_VEHICLES) return 0;
    g_vehicle_garage_index[vehicleid] = -1;
    g_vehicle_garage_slot[vehicleid] = -1;
    return 1;
}

stock GarageScheduleVehicleStabilize(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;

    // A freshly created personal vehicle is first streamed with its DB spawn
    // transform, then receives delayed tuning/model RPCs. Reassert the selected
    // garage slot several times so the client never keeps that old heading.
    SetTimerEx("ReapplyGarageVehicleTransform", 120, false, "i", vehicleid);
    SetTimerEx("ReapplyGarageVehicleTransform", 650, false, "i", vehicleid);
    SetTimerEx("ReapplyGarageVehicleTransform", 1350, false, "i", vehicleid);
    return 1;
}

forward ReapplyGarageVehicleTransform(vehicleid);
public ReapplyGarageVehicleTransform(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;

    new garageid = g_vehicle_garage_index[vehicleid];
    new slot = g_vehicle_garage_slot[vehicleid];
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;
    if(GetVehicleVirtualWorld(vehicleid) != garageid + 2000) return 0;

    new Float:target_x, Float:target_y, Float:target_z, Float:target_a;
    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        if(slot < 0 || slot >= sizeof(g_large_garage_slots)) return 0;
        target_x = g_large_garage_slots[slot][0];
        target_y = g_large_garage_slots[slot][1];
        target_z = g_large_garage_slots[slot][2];
        target_a = g_large_garage_slots[slot][3];
    }
    else
    {
        if(slot < 0 || slot >= sizeof(g_small_garage_slots)) return 0;
        target_x = g_small_garage_slots[slot][0];
        target_y = g_small_garage_slots[slot][1];
        target_z = g_small_garage_slots[slot][2];
        target_a = g_small_garage_slots[slot][3];
    }

    new Float:current_x, Float:current_y, Float:current_z, Float:current_a;
    GetVehiclePos(vehicleid, current_x, current_y, current_z);
    GetVehicleZAngle(vehicleid, current_a);

    new Float:angle_diff = floatabs(current_a - target_a);
    if(angle_diff > 180.0) angle_diff = 360.0 - angle_diff;

    // Do not keep teleporting a correctly parked vehicle back to the recorded Z.
    // After wheel/suspension tuning the physics engine must be allowed to settle
    // naturally on the garage floor. Reposition only if another callback really
    // changed its XY/heading.
    if(floatabs(current_x - target_x) > 0.35 ||
       floatabs(current_y - target_y) > 0.35 ||
       floatabs(current_z - target_z) > 2.0 ||
       angle_diff > 2.0)
    {
        SetVehiclePos(vehicleid, target_x, target_y, target_z);
        SetVehicleZAngle(vehicleid, target_a);
        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    }

    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, garageid + 2000);
    return 1;
}

stock PutVehicleDirectlyInGarageForDelivery(vehicleid, garageid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    new slot = GetFreeGarageParkingSlot(garageid, vehicleid);
    if(slot == -1) return 0;

    new Float:x, Float:y, Float:z, Float:a;
    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        x = g_large_garage_slots[slot][0];
        y = g_large_garage_slots[slot][1];
        z = g_large_garage_slots[slot][2];
        a = g_large_garage_slots[slot][3];
    }
    else
    {
        x = g_small_garage_slots[slot][0];
        y = g_small_garage_slots[slot][1];
        z = g_small_garage_slots[slot][2];
        a = g_small_garage_slots[slot][3];
    }

    // /garage delivery can create the car immediately before it is streamed.
    // Switch world/interior first, then apply the exact recorded VEHICLE transform.
    // Clear angular velocity too: clearing only linear velocity allowed a fresh car
    // to keep a spawn/collision rotation and end up visibly crooked.
    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, garageid + 2000);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);

    g_vehicle_garage_index[vehicleid] = garageid;
    g_vehicle_garage_slot[vehicleid] = slot;

    // Saved tuning is sent around 500 ms and firmware around 1500 ms after stream-in.
    // Reassert the exact slot after those stages, unconditionally, so the mobile client
    // cannot keep a tilted/rotated visual state even when server Z-angle already matches.
    SetTimerEx("ReapplyGarageDeliveryTransform", 80, false, "iii", vehicleid, garageid, slot);
    SetTimerEx("ReapplyGarageDeliveryTransform", 650, false, "iii", vehicleid, garageid, slot);
    SetTimerEx("ReapplyGarageDeliveryTransform", 1750, false, "iii", vehicleid, garageid, slot);
    SetTimerEx("ReapplyGarageDeliveryTransform", 3000, false, "iii", vehicleid, garageid, slot);
    return 1;
}

forward ReapplyGarageDeliveryTransform(vehicleid, garageid, slot);
public ReapplyGarageDeliveryTransform(vehicleid, garageid, slot)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    // Timers from a destroyed/reused vehicle must never move the new vehicle.
    if(g_vehicle_garage_index[vehicleid] != garageid) return 0;
    if(g_vehicle_garage_slot[vehicleid] != slot) return 0;

    new Float:x, Float:y, Float:z, Float:a;
    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        if(slot < 0 || slot >= sizeof(g_large_garage_slots)) return 0;
        x = g_large_garage_slots[slot][0];
        y = g_large_garage_slots[slot][1];
        z = g_large_garage_slots[slot][2];
        a = g_large_garage_slots[slot][3];
    }
    else
    {
        if(slot < 0 || slot >= sizeof(g_small_garage_slots)) return 0;
        x = g_small_garage_slots[slot][0];
        y = g_small_garage_slots[slot][1];
        z = g_small_garage_slots[slot][2];
        a = g_small_garage_slots[slot][3];
    }

    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, garageid + 2000);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
    return 1;
}

stock PutVehicleDirectlyInGarage(vehicleid, garageid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    new slot = GetFreeGarageParkingSlot(garageid, vehicleid);
    if(slot == -1) return 0;

    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        SetVehiclePos(vehicleid,
            g_large_garage_slots[slot][0],
            g_large_garage_slots[slot][1],
            g_large_garage_slots[slot][2]);
        SetVehicleZAngle(vehicleid, g_large_garage_slots[slot][3]);
    }
    else
    {
        SetVehiclePos(vehicleid,
            g_small_garage_slots[slot][0],
            g_small_garage_slots[slot][1],
            g_small_garage_slots[slot][2]);
        SetVehicleZAngle(vehicleid, g_small_garage_slots[slot][3]);
    }

    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, garageid + 2000);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);

    // Некоторые части загрузки/тюнинга транспорта меняют transform уже после доставки.
    // Запоминаем слот и дважды подтверждаем координаты/угол после завершения этих callback'ов.
    g_vehicle_garage_index[vehicleid] = garageid;
    g_vehicle_garage_slot[vehicleid] = slot;
    GarageScheduleVehicleStabilize(vehicleid);
    return 1;
}

stock PutOwnableCarInGarage(playerid, garageid)
{
    return PutVehicleDirectlyInGarageForDelivery(GetPlayerOwnableCar(playerid), garageid);
}

stock SavePlayerGarageOwnership(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new garageidx = GetPlayerGarage(playerid);
    new query[256];

    if(garageidx >= 0 && garageidx < g_garage_loaded && GetGarageData(garageidx, GARAGE_OWNER_ID) == account_id)
    {
        new db_id = GetGarageData(garageidx, GARAGE_ID);
        mysql_format(mysql, query, sizeof query, "UPDATE `garages` SET `owner_id`=%d WHERE `id`=%d LIMIT 1", account_id, db_id);
        mysql_query(mysql, query, false);
        mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `garage`=%d WHERE `id`=%d LIMIT 1", db_id, account_id);
        mysql_query(mysql, query, false);
        return 1;
    }

    // Recover the link from garages.owner_id if P_GARAGE was lost/reset.
    mysql_format(mysql, query, sizeof query, "SELECT `id` FROM `garages` WHERE `owner_id`=%d LIMIT 1", account_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(!mysql_errno(mysql) && cache_num_rows() > 0)
    {
        new db_id = cache_get_field_content_int(0, "id");
        cache_delete(result);
        mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `garage`=%d WHERE `id`=%d LIMIT 1", db_id, account_id);
        mysql_query(mysql, query, false);
        new runtime_idx = GetGarageIndexByDbId(db_id);
        if(runtime_idx != -1) SetPlayerData(playerid, P_GARAGE, runtime_idx);
        return 1;
    }
    cache_delete(result);
    return 0;
}

stock BuyPlayerGarage(playerid, garageid, bool: buy_from_owner = false, price = -1)
{
    if(IsGarageOwned(garageid) || GetPlayerGarage(playerid) != -1) return -1;

    if(price <= 0) price = GetGarageData(garageid, GARAGE_PRICE);
    if(price <= 0) price = 30000000;
    if(GetPlayerMoneyEx(playerid) < price) return 0;

    new account_id = GetPlayerAccountID(playerid);
    new db_id = GetGarageData(garageid, GARAGE_ID);
    new query[256];

    // Canonical ownership is garages.owner_id.
    mysql_format(mysql, query, sizeof query,
        "UPDATE `garages` SET `owner_id`=%d WHERE `id`=%d AND `owner_id`=0 LIMIT 1",
        account_id, db_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno(mysql))
    {
        cache_delete(result);
        SendClientMessage(playerid, 0xFF6600FF, "Garage DB save error (owner)");
        return 0;
    }
    cache_delete(result);

    // Mirror the DB garage id in accounts.garage for persistence across relog/restart.
    mysql_format(mysql, query, sizeof query,
        "UPDATE `accounts` SET `garage`=%d WHERE `id`=%d LIMIT 1",
        db_id, account_id);
    result = mysql_query(mysql, query, true);
    if(mysql_errno(mysql))
    {
        cache_delete(result);
        mysql_format(mysql, query, sizeof query,
            "UPDATE `garages` SET `owner_id`=0 WHERE `id`=%d AND `owner_id`=%d LIMIT 1",
            db_id, account_id);
        mysql_query(mysql, query, false);
        SendClientMessage(playerid, 0xFF6600FF, "Garage DB save error (account)");
        return 0;
    }
    cache_delete(result);

    SetPlayerData(playerid, P_GARAGE, garageid);
    SetGarageData(garageid, GARAGE_OWNER_ID, account_id);
    strmid(g_garage[garageid][G_OWNER_NAME], GetPlayerNameEx(playerid), 0, strlen(GetPlayerNameEx(playerid)), 21);

    SavePlayerGarageOwnership(playerid);
    EnterPlayerToGarage(playerid, garageid);
    UpdateGarageInfo(garageid);

    GivePlayerMoneyEx(playerid, -price, "РџРѕРєСѓРїРєР° РіР°СЂР°Р¶Р°", false, true);
    SendClientMessage(playerid, 0x66CC00FF, "Garage purchased and saved. Use /garage");
    return 1;
}

CMD:addgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этой команде.");

    if(g_garage_loaded >= MAX_GARAGES)
        return SendClientMessage(playerid, 0xFF5252FF, "Достигнут лимит гаражей на сервере.");

    new price = 30000000;
    if(strlen(params))
    {
        if(sscanf(params, "d", price))
            return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addgarage [цена] или /creategarage [цена]");
        if(price < 1)
            return SendClientMessage(playerid, 0xCECECEFF, "Цена гаража должна быть больше 0.");
    }

    new idx = g_garage_loaded;
    new Float:pos_x, Float:pos_y, Float:pos_z, Float:angle;
    GetPlayerPos(playerid, pos_x, pos_y, pos_z);
    GetPlayerFacingAngle(playerid, angle);

    new query[384];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `garages` (`owner_id`,`price`,`lock`,`x`,`y`,`z`,`exit_x`,`exit_y`,`exit_z`,`exit_angle`,`improvements`) VALUES (0,%d,0,%f,%f,%f,%f,%f,%f,%f,1)",
        price,
        pos_x, pos_y, pos_z,
        pos_x, pos_y, pos_z,
        angle
    );

    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno(mysql) != 0)
    {
        cache_delete(result);
        return SendClientMessage(playerid, 0xFF5252FF, "Ошибка MySQL при создании гаража.");
    }

    new db_id = cache_insert_id();
    cache_delete(result);

    SetGarageData(idx, GARAGE_ID, db_id);
    SetGarageData(idx, GARAGE_OWNER_ID, 0);
    SetGarageData(idx, GARAGE_PRICE, price);
    SetGarageData(idx, GARAGE_STATUS, false);
    SetGarageData(idx, GARAGE_X, pos_x);
    SetGarageData(idx, GARAGE_Y, pos_y);
    SetGarageData(idx, GARAGE_Z, pos_z);
    SetGarageData(idx, GARAGE_EXIT_X, pos_x);
    SetGarageData(idx, GARAGE_EXIT_Y, pos_y);
    SetGarageData(idx, GARAGE_EXIT_Z, pos_z);
    SetGarageData(idx, GARAGE_EXIT_ANGLE, angle);
    SetGarageData(idx, GARAGE_SPAWN_X, 0.0);
    SetGarageData(idx, GARAGE_SPAWN_Y, 0.0);
    SetGarageData(idx, GARAGE_SPAWN_Z, 0.0);
    SetGarageData(idx, GARAGE_SPAWN_ANGLE, 0.0);
    SetGarageData(idx, GARAGE_SAFE_EXIT_X, 0.0);
    SetGarageData(idx, GARAGE_SAFE_EXIT_Y, 0.0);
    SetGarageData(idx, GARAGE_SAFE_EXIT_Z, 0.0);
    SetGarageData(idx, GARAGE_SAFE_EXIT_ANGLE, 0.0);
    SetGarageData(idx, GARAGE_IMPROVEMENTS, 1);
    format(g_garage[idx][G_OWNER_NAME], 21, "None");

    SetGarageData(idx, G_ENTER_PICKUP, CreatePickup(19134, 23, pos_x, pos_y, pos_z, 0, PICKUP_ACTION_TYPE_GARAGE, idx));

    new label_text[256];
    format(label_text, sizeof label_text,
        "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}Отсутствует{FFFFFF}\n{FFFFFF}Дверь: {66CC33}открыта{FFFFFF}\n{FFFFFF}Цена: {FFA500}%d{FFFFFF} рублей",
        db_id, price
    );
    SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(label_text, 0xFAF2F6AA, pos_x, pos_y, pos_z + 1.0, 15.0));

    g_garage_loaded++;

    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1], msg[192];
    GetCityName(pos_x, pos_y, city);
    GetAreaName(pos_x, pos_y, area);
    format(msg, sizeof msg, "[A] %s[%d] создал гараж DB ID %d / index %d (%s / %s), цена: %d", GetPlayerNameEx(playerid), playerid, db_id, idx, city, area, price);
    SendMessageToAdmins(msg, 0x66CC33FF);

    format(msg, sizeof msg, "Гараж создан. ID для команд: %d. Цена: %d. Теперь встаньте в точку выезда и используйте /gsetexitpos %d", idx, price, idx);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

CMD:creategarage(playerid, params[])
{
    return callcmd::addgarage(playerid, params);
}

CMD:gotogarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этой команде.");

    new garage_id;
    if(sscanf(params, "d", garage_id))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gotogarage [id]");
    if(garage_id < 0 || garage_id >= g_garage_loaded)
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж с таким ID не загружен.");

    SetPlayerPos(playerid, GetGarageData(garage_id, GARAGE_X), GetGarageData(garage_id, GARAGE_Y), GetGarageData(garage_id, GARAGE_Z) + 1.0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    return 1;
}

CMD:delgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этой команде.");

    new garage_id;
    if(sscanf(params, "d", garage_id))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delgarage [id]");
    if(garage_id < 0 || garage_id >= g_garage_loaded)
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж с таким ID не загружен.");
    if(IsGarageOwned(garage_id))
        return SendClientMessage(playerid, 0xFF5252FF, "Нельзя удалить купленный гараж. Сначала освободите его через /asellgarage.");

    new db_id = GetGarageData(garage_id, GARAGE_ID);
    new query[128];
    mysql_format(mysql, query, sizeof query, "DELETE FROM `garages` WHERE `id`=%d LIMIT 1", db_id);
    mysql_query(mysql, query, false);

    DestroyPickup(GetGarageData(garage_id, G_ENTER_PICKUP));
    DestroyDynamic3DTextLabel(GetGarageData(garage_id, G_LABEL));

    // Удаляем из памяти без дырки: последний загруженный гараж переносим на место удалённого.
    new last = g_garage_loaded - 1;
    if(garage_id != last)
    {
        g_garage[garage_id] = g_garage[last];
        DestroyPickup(GetGarageData(garage_id, G_ENTER_PICKUP));
        new new_pickup = CreatePickup(19134, 23,
            GetGarageData(garage_id, GARAGE_X), GetGarageData(garage_id, GARAGE_Y), GetGarageData(garage_id, GARAGE_Z),
            0, PICKUP_ACTION_TYPE_GARAGE, garage_id);
        SetGarageData(garage_id, G_ENTER_PICKUP, new_pickup);
    }
    g_garage_loaded--;

    new msg[128];
    format(msg, sizeof msg, "Гараж удалён. DB ID: %d. После массового редактирования рекомендуется рестарт сервера.", db_id);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

CMD:setedit(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "No access.");

    new section[16], action[16], garage_db_id;
    if(sscanf(params, "s[16]s[16]d", section, action, garage_db_id) || strcmp(section, "pos", true) || strcmp(action, "spawn", true))
        return SendClientMessage(playerid, 0xCECECEFF, "Use: /setedit pos spawn [garage DB id]");

    new garage_id = GetGarageIndexByDbId(garage_db_id);
    if(garage_id == -1)
        return SendClientMessage(playerid, 0xFF5252FF, "Garage with this DB ID is not loaded.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    SetGarageData(garage_id, GARAGE_SPAWN_X, x);
    SetGarageData(garage_id, GARAGE_SPAWN_Y, y);
    SetGarageData(garage_id, GARAGE_SPAWN_Z, z);
    SetGarageData(garage_id, GARAGE_SPAWN_ANGLE, a);

    new query[384], msg[192];
    mysql_format(mysql, query, sizeof query,
        "UPDATE `garages` SET `spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_angle`=%f WHERE `id`=%d LIMIT 1",
        x, y, z, a, garage_db_id);
    mysql_query(mysql, query, false);

    format(msg, sizeof msg, "Garage DB %d spawn saved: %.4f, %.4f, %.4f, %.4f | VW:%d INT:1",
        garage_db_id, x, y, z, a, garage_id + 2000);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

CMD:gexitsetpos(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "No access.");

    new garage_db_id;
    if(sscanf(params, "d", garage_db_id))
        return SendClientMessage(playerid, 0xCECECEFF, "Use: /gexitsetpos [garage DB id]");

    new garage_id = GetGarageIndexByDbId(garage_db_id);
    if(garage_id == -1)
        return SendClientMessage(playerid, 0xFF5252FF, "Garage with this DB ID is not loaded.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    SetGarageData(garage_id, GARAGE_SAFE_EXIT_X, x);
    SetGarageData(garage_id, GARAGE_SAFE_EXIT_Y, y);
    SetGarageData(garage_id, GARAGE_SAFE_EXIT_Z, z);
    SetGarageData(garage_id, GARAGE_SAFE_EXIT_ANGLE, a);

    new query[384], msg[192];
    mysql_format(mysql, query, sizeof query,
        "UPDATE `garages` SET `safe_exit_x`=%f,`safe_exit_y`=%f,`safe_exit_z`=%f,`safe_exit_angle`=%f WHERE `id`=%d LIMIT 1",
        x, y, z, a, garage_db_id);
    mysql_query(mysql, query, false);

    format(msg, sizeof msg, "Garage DB %d PLAYER exit saved: %.4f, %.4f, %.4f, %.4f",
        garage_db_id, x, y, z, a);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

CMD:gexitsetposcar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "No access.");

    new garage_db_id;
    if(sscanf(params, "d", garage_db_id))
        return SendClientMessage(playerid, 0xCECECEFF, "Use: /gexitsetposcar [garage DB id]");

    new garage_id = GetGarageIndexByDbId(garage_db_id);
    if(garage_id == -1)
        return SendClientMessage(playerid, 0xFF5252FF, "Garage with this DB ID is not loaded.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    SetGarageData(garage_id, GARAGE_VEHICLE_EXIT_X, x);
    SetGarageData(garage_id, GARAGE_VEHICLE_EXIT_Y, y);
    SetGarageData(garage_id, GARAGE_VEHICLE_EXIT_Z, z);
    SetGarageData(garage_id, GARAGE_VEHICLE_EXIT_ANGLE, a);

    new query[384], msg[192];
    mysql_format(mysql, query, sizeof query,
        "UPDATE `garages` SET `vehicle_exit_x`=%f,`vehicle_exit_y`=%f,`vehicle_exit_z`=%f,`vehicle_exit_angle`=%f WHERE `id`=%d LIMIT 1",
        x, y, z, a, garage_db_id);
    mysql_query(mysql, query, false);

    format(msg, sizeof msg, "Garage DB %d CAR exit saved: %.4f, %.4f, %.4f, %.4f",
        garage_db_id, x, y, z, a);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

CMD:garage(playerid, params[])
{
 new garageid = GetPlayerGarage(playerid);
 if(garageid != -1)
 {
  new fmt_str[1024];
  new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
  GetCityName(GetGarageData(garageid, GARAGE_X), GetBusinessData(garageid, GARAGE_Y), city);
  GetAreaName(GetGarageData(garageid, GARAGE_X), GetBusinessData(garageid, GARAGE_Y), area);
  format
  (
   fmt_str, sizeof fmt_str,
   "{FFFFFF}Номер гаража:\t\t\t%d\n"\
   "Владелец:\t\t\t\t%s\n"\
   "Город / область:\t\t\t%s\n"\
   "Район:\t\t\t\t\t%s\n"\
   "{FFFFFF}Гос. стоимость:\t\t\t30.000.000 руб\n"\
   "Статус:\t\t\t\t\t%s\n\n"\
   "{669966}Для открытия панели управления вашим бизнесом\n"\
   "нажмите кнопку \"Изменить\"",
   garageid,
   GetGarageData(garageid, G_OWNER_NAME),
   city,
   area,
   GetGarageData(garageid, GARAGE_STATUS) ? ("{CC3333}гараж закрыт") : ("{66CC33}гараж открыт")
  );
  Dialog(playerid, DIALOG_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}Информация о гараже", fmt_str, "Управление", "Выйти");
 }
 else SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража");

 return 1;
}

CMD:sellgarage(playerid, params[])
{
 new garageid = GetPlayerGarage(playerid);
 if(garageid != -1)
 {
  Dialog
  (
   playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_MSGBOX,
   "{FFCD00}Продажа гаража",
   "{FFFFFF}Вы уверены что хотите продать свой гараж государству?\n\n"\
   "Вам будет возвращено его стоимость за вычитом 30%\n"\
   "Если Вы хотите продать бизнес другому игроку,\n"\
   "используйте команду /sellmygarage",
   "Да", "Нет"
  );
 }
 else SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража");

 return 1;
}

CMD:sellmygarage(playerid, params[])
{
 new garageid = GetPlayerGarage(playerid);
 if(garageid != -1)
 {
  if(!strlen(params))
   return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellmybiz [id игрока] [стоимость]");

  extract params -> new to_player, price;

  if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
   return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

  if(price < 1)
   return SendClientMessage(playerid, 0xCECECEFF, "Укажите стоимость продажи");

  new Float: g_pos_x = GetGarageData(garageid, GARAGE_X);
  new Float: g_pos_y = GetGarageData(garageid, GARAGE_Y);
  new Float: g_pos_z = GetGarageData(garageid, GARAGE_Z);

  if(GetPlayerMoneyEx(to_player) < price)
   return SendClientMessage(playerid, 0xCECECEFF, "У покупателя нет такого количества средств");

  if(!(IsPlayerInRangeOfPoint(playerid, 7.0, g_pos_x, g_pos_y, g_pos_z) && IsPlayerInRangeOfPoint(to_player, 7.0, g_pos_x, g_pos_y, g_pos_z)))
   SendClientMessage(playerid, 0xCECECEFF, "Вы и покупатель должны находиться рядом с гаражеи который хотите продать");

  SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_GARAGE, garageid, price);
 }
 else SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража");

 return 1;
}

stock spawningarage(playerid)
{
 new garageid = GetPlayerGarage(playerid);
 if(garageid != -1)
 {
 if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 1)
 {
  SetPlayerPosEx
  (
   playerid,
   1.265544,
            1996.246215,
            1554.203125,
            359.354705,
   1,
   garageid + 2000
  );
  SetPlayerInGarage(playerid, garageid);
 }
 else 
    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
 {
  SetPlayerPosEx
  (
   playerid,
   499.663299,
            1983.485473,
            1547.686645,
             358.738708,
   1,
   garageid + 2000
  );
  SetPlayerInGarage(playerid, garageid);
 }
 }
 else 
    {
     SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража");
     SetPlayerSpawnInit(playerid);
     SpawnPlayer(playerid);
     }
    return 1;
}

CMD:asellgarage(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, 0x999999FF, "У вас нет прав для использования этой команды.");

    new garageid;
    new reason[128];

    if (sscanf(params, "d s[128]", garageid, reason))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Использование: /asellgarage [ID гаража] [Причина (необязательно)]");
        return 1;
    }

    if (garageid < 1 || garageid > MAX_GARAGES)
    {
        SendClientMessage(playerid, 0x999999FF, "Неверный ID гаража. ID должен быть от 1 до MAX_GARAGES.");
        return 1;
    }

    new query[256];
    new owner_account_id = 0;
    new former_owner_name[MAX_PLAYER_NAME + 1];

    mysql_format(mysql, query, sizeof(query), "SELECT `owner_id` FROM `garages` WHERE `id` = %d LIMIT 1", garageid);
    mysql_query(mysql, query);

    if (mysql_errno(mysql) != 0)
    {
        printf("[MySQL Error]: Ошибка при получении owner_id для гаража %d: %s", garageid, mysql_errno(mysql));
        SendClientMessage(playerid, COLOR_RED, "Ошибка базы данных при проверке владельца гаража. Пожалуйста, сообщите разработчикам.");
        return 1;
    }

    if (cache_num_rows() > 0)
    {
        owner_account_id = cache_get_field_content_int(0, "owner_id");
    }
    else
    {
        SendClientMessage(playerid, 0xCECECEFF, "Гараж с таким ID не найден в базе данных.");
        return 1;
    }

    if (owner_account_id > 0)
    {
        mysql_format(mysql, query, sizeof(query), "SELECT `name` FROM `accounts` WHERE `id` = %d LIMIT 1", owner_account_id);
        mysql_query(mysql, query);
        if (mysql_errno(mysql) != 0)
        {
            printf("[MySQL Error]: Ошибка при получении имени владельца аккаунта %d: %s", owner_account_id, mysql_errno(mysql));
            SendClientMessage(playerid, COLOR_RED, "Ошибка базы данных при получении имени владельца.");
            format(former_owner_name, sizeof(former_owner_name), "Неизвестный игрок (ID: %d)", owner_account_id);
        }
        else if (cache_num_rows() > 0)
        {
            cache_get_field_content(0, "name", former_owner_name, mysql, sizeof(former_owner_name));
        }
        else
        {
            format(former_owner_name, sizeof(former_owner_name), "Неизвестный игрок (ID: %d)", owner_account_id);
        }

        new garage_idx = GetGarageIndexByDbId(garageid);
        if (garage_idx >= 0 && garage_idx < g_garage_loaded)
        {
            SetGarageData(garage_idx, GARAGE_OWNER_ID, 0);
            UpdateGarageInfo(garage_idx);
        }

        mysql_format(mysql, query, sizeof(query), "UPDATE `garages` SET `owner_id` = 0 WHERE `id` = %d LIMIT 1", garageid);
        mysql_query(mysql, query);
        if (mysql_errno(mysql) != 0)
        {
            printf("[MySQL Error]: Ошибка при обновлении garages.owner_id для гаража %d: %s", garageid, mysql_errno(mysql));
            SendClientMessage(playerid, COLOR_RED, "Ошибка БД при обнулении владельца гаража.");
            return 1;
        }

        mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `garage` = -1 WHERE `id` = %d LIMIT 1", owner_account_id);
        mysql_query(mysql, query);
        if (mysql_errno(mysql) != 0)
        {
            printf("[MySQL Error]: Ошибка при обновлении accounts.garage для владельца %d: %s", owner_account_id, mysql_errno(mysql));
            SendClientMessage(playerid, COLOR_RED, "Ошибка БД при обнулении гаража у владельца.");
            return 1;
        }

        SendClientMessage(playerid, 0x00FF00FF, !"Гараж успешно обнулен.");
        printf("[ADMIN]: Администратор %s (ID: %d) обнулил гараж ID: %d, бывший владелец аккаунт ID: %d",
               GetPlayerNameEx(playerid), playerid, garageid, owner_account_id);

        new broadcast_message[MAX_PLAYER_NAME + MAX_PLAYER_NAME + 150];
        format(broadcast_message, sizeof(broadcast_message), "Администратор %s обнулил гараж игрока %s", GetPlayerNameEx(playerid), former_owner_name);

        if(strlen(reason) > 0)
        {
            new reason_text[sizeof(reason) + 16];
            format(reason_text, sizeof(reason_text), ". Причина: %s", reason);
            strcat(broadcast_message, reason_text);
        }

        SendClientMessageToAll(0xFF5533FF, broadcast_message);
    }
    else
    {
        SendClientMessage(playerid, 0x999999FF, !"Гаражом никто не владеет.");
    }

    return 1;
}