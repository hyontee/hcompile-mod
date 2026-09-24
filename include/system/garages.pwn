new LoadCarGarage[MAX_PLAYERS];

// [ФИКС КОМПИЛЯЦИИ] Флаг стиля уведомлений. В этой кодовой базе есть
// только ShowNotification (не ShowNotificationNew), поэтому = 0.
#if !defined USE_ZOMENO_OLD_ENGINE
    #define USE_ZOMENO_OLD_ENGINE 0
#endif

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

new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];
new g_garage_loaded;

// ==== Мульти-слотовый паркинг для элитного гаража (GARAGE_IMPROVEMENTS == 2) ====
#define MAX_GARAGE_SLOTS (6)

// Elite garage: straight 3+2 parking, fixed angles.
new const Float: g_eliteGarageSlotPos[MAX_GARAGE_SLOTS][4] =
{
    {497.951904, 1996.764648, 1547.182373, 356.277679},
    {498.490997, 2003.710083, 1547.182373, 356.277679},
    {497.773254, 2012.197998, 1547.237792, 356.277679},
    {505.370513, 2012.768188, 1547.224853, 356.277679},
    {505.195098, 2005.821533, 1547.182373, 356.277679},
    {505.348999, 1996.814208, 1547.182861, 356.277679}
};

new g_garageSlotVehicle[MAX_GARAGES][MAX_GARAGE_SLOTS];

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
forward SyncGarageOwnableCarProximity();

public OnGameModeInit()
{
    SetTimer("CheckAndCreateGaragesTables", 1500, false);
    print("[WERTON_GARAGES]: Система гаражей загружена!");
    SetTimer("LoadGarages", 3000, false);
    SetTimer("SyncGarageOwnableCarProximity", 800, true);

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

 for(new g = 0; g < MAX_GARAGES; g++)
 {
     for(new s = 0; s < MAX_GARAGE_SLOTS; s++)
     {
         g_garageSlotVehicle[g][s] = INVALID_VEHICLE_ID;
     }
 }

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

// Каждые 800 мс переключаем "активную" личную машину игрока (P_OWNABLE_CAR) на ту,
// рядом с которой он сейчас стоит/сидит внутри элитного гаража. Это нужно, чтобы
// команды вроде /lock, /key и открытие багажника (которые смотрят только на
// GetPlayerOwnableCar) корректно работали с любой из до 5 припаркованных машин,
// а не только с последней загруженной.
public SyncGarageOwnableCarProximity()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid)) continue;

        new garageid = GetPlayerInGarage(playerid);
        if(garageid == -1) continue;
        if(garageid < 0 || garageid >= g_garage_loaded) continue;
        if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) != 2) continue;

        new Float: px, Float: py, Float: pz;
        GetPlayerPos(playerid, px, py, pz);

        new nearest = INVALID_VEHICLE_ID;
        new Float: nearest_dist = 6.0;

        for(new s = 0; s < MAX_GARAGE_SLOTS; s++)
        {
            new vid = g_garageSlotVehicle[garageid][s];
            if(vid == INVALID_VEHICLE_ID || !IsValidVehicle(vid)) continue;

            new Float: vx, Float: vy, Float: vz;
            GetVehiclePos(vid, vx, vy, vz);

            new Float: dist = VectorSize(px - vx, py - vy, pz - vz);
            if(dist < nearest_dist)
            {
                nearest_dist = dist;
                nearest = vid;
            }
        }

        if(nearest != INVALID_VEHICLE_ID && GetPlayerOwnableCar(playerid) != nearest)
        {
            SetPlayerData(playerid, P_OWNABLE_CAR, nearest);
        }
    }
    return 1;
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
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}%s{FFFFFF}\n{FFFFFF}Дверь: %s\n{FFFFFF}Цена: {FFA500}30.000.000{FFFFFF} рублей",
            GetGarageData(idx, GARAGE_ID), 
            GetGarageData(idx, G_OWNER_NAME),
            GetGarageData(idx, GARAGE_STATUS) ? ("{FF5252}закрыта") : ("{66CC33}открыта")
        );
    }
    else 
    {
        format(query, sizeof(query), 
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}Отсутствует{FFFFFF}\n{FFFFFF}Дверь: {66CC33}открыта{FFFFFF}\n{FFFFFF}Цена: {FFA500}30.000.000{FFFFFF} рублей",
            GetGarageData(idx, GARAGE_ID)
        );
    }

    UpdateDynamic3DTextLabelText(GetGarageData(idx, G_LABEL), 0xfaf2f6AA, query);

    cache_delete(result); 
}

stock SyncPlayerGarageData(playerid)
{
 new player_account_id = GetPlayerAccountID(playerid);
 new query_gar[128];
 mysql_format(mysql, query_gar, sizeof(query_gar), "SELECT `id` FROM `garages` WHERE `owner_id` = %d LIMIT 1", player_account_id);
 mysql_query(mysql, query_gar);

 new garage_id = 0;

 if (cache_num_rows() > 0)
 {
     garage_id = cache_get_field_content_int(0, "id");

     if (garage_id > 0)
     {
         new update_query[128];
         mysql_format(mysql, update_query, sizeof(update_query), "UPDATE `accounts` SET `garage` = %d WHERE `id` = %d LIMIT 1", garage_id, player_account_id);
         mysql_query(mysql, update_query);

         new runtime_idx = GetGarageIndexByDbId(garage_id);
         SetPlayerData(playerid, P_GARAGE, runtime_idx);

         printf("[WERTON_GARAGE] Игрок ID %d (Аккаунт ID: %d) - найден гараж ID: %d. Обновляю accounts.garage.", playerid, player_account_id, garage_id);
     }
     else
     {
         SetPlayerData(playerid, P_GARAGE, -1);
     }
 }
 else
 {
     SetPlayerData(playerid, P_GARAGE, -1);
 }

 return 1;
}

public: LoadPlayerData(playerid)
{
 new query[138];
 new Cache: result;

 mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
 result = mysql_query(mysql, query);

 if(cache_num_rows())
 {
    LoadCarGarage[playerid] = 0;

 new player_account_id = GetPlayerAccountID(playerid);

 new query_gar[128];
    mysql_format(mysql, query_gar, sizeof(query_gar), "SELECT `id` FROM `garages` WHERE `owner_id` = %d LIMIT 1", player_account_id);

    mysql_query(mysql, query_gar);

    new garage_id = 0;

    if (cache_num_rows() > 0)
    {
        garage_id = cache_get_field_content_int(0, "id");

        if (garage_id > 0)
        {
            new update_query[128];
            mysql_format(mysql, update_query, sizeof(update_query), "UPDATE `accounts` SET `garage` = %d WHERE `id` = %d LIMIT 1", garage_id, player_account_id);
            mysql_query(mysql, update_query);

   new runtime_idx = GetGarageIndexByDbId(garage_id);
   SetPlayerData(playerid, P_GARAGE, runtime_idx);

            printf("[WERTON_GARAGE OnPlayerConnect]: Игрок ID %d (Аккаунт ID: %d) - найден гараж ID: %d. Обновляю accounts.garage.", playerid, player_account_id, garage_id);
        }
    }
 }

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

public OnPlayerSpawn(playerid)
{
    LoadCarGarage[playerid] = 0;
    
    SetPlayerData(playerid, P_IN_GARAGE, -1);
    #if defined garage_OnPlayerSpawn
        return garage_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
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
    #if defined garage_OnPlayerSpawn
        return garage_OnPlayerSpawn(playerid, killerid, reason);
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
     new in_garage = GetPlayerInGarage(playerid);
     if(in_garage != -1)
     {
       SetPlayerPosEx
       (
        playerid,
        GetGarageData(in_garage, GARAGE_EXIT_X),
        GetGarageData(in_garage, GARAGE_EXIT_Y),
        GetGarageData(in_garage, GARAGE_EXIT_Z),
        GetGarageData(in_garage, GARAGE_EXIT_ANGLE),
        0,
        0
       );
       SetPlayerInGarage(playerid, -1);
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

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
if(newkeys == KEY_CROUCH)
   {
       print("[eq]");
       if(IsPlayerInRangeOfPoint(playerid,  5.0, -0.2940,2006.1188,1554.2031))
       {
                new garageid = GetPlayerGarage(playerid);
                new exit_vehicleid = GetPlayerGarageVehicleInUse(playerid, garageid);
               if(!IsPlayerInVehicle(playerid, exit_vehicleid)) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
    new vehicleID = GetPlayerVehicleID(playerid);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
          if(IsPlayerInVehicle(i, vehicleID))

          SetPlayerVirtualWorld(i, 0);
          SetPlayerInterior(i, 0);
          SetCameraBehindPlayer(i);
          }
          new vehicleid = exit_vehicleid;
          FreeGarageVehicleSlot(garageid, vehicleid);
          SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
          
          SetVehiclePos(vehicleid, GetGarageData(garageid, GARAGE_EXIT_X), GetGarageData(garageid, GARAGE_EXIT_Y), GetGarageData(garageid, GARAGE_EXIT_Z));
          SetVehicleZAngle(vehicleid, GetGarageData(garageid, GARAGE_EXIT_ANGLE));
          SetVehicleVirtualWorld(vehicleid, 0);
          SetPlayerVirtualWorld(playerid, 0);
          LinkVehicleToInterior(vehicleid, 0);
          SetCameraBehindPlayer(playerid);
                    return 1;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       print("[eq]");
       if(IsPlayerInRangeOfPoint(playerid,  5.0, 492.663848,1988.835205,1548.586645))
       {
                new garageid = GetPlayerGarage(playerid);
                new exit_vehicleid = GetPlayerGarageVehicleInUse(playerid, garageid);
               if(!IsPlayerInVehicle(playerid, exit_vehicleid)) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
    new vehicleID = GetPlayerVehicleID(playerid);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
          if(IsPlayerInVehicle(i, vehicleID))

          SetPlayerVirtualWorld(i, 0);
          SetPlayerInterior(i, 0);
          SetCameraBehindPlayer(i);
          }
          new vehicleid = exit_vehicleid;
          FreeGarageVehicleSlot(garageid, vehicleid);
          SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
          
          SetVehiclePos(vehicleid, GetGarageData(garageid, GARAGE_EXIT_X), GetGarageData(garageid, GARAGE_EXIT_Y), GetGarageData(garageid, GARAGE_EXIT_Z));
          SetVehicleZAngle(vehicleid, GetGarageData(garageid, GARAGE_EXIT_ANGLE));
          SetVehicleVirtualWorld(vehicleid, 0);
          SetPlayerVirtualWorld(playerid, 0);
          LinkVehicleToInterior(vehicleid, 0);
          SetCameraBehindPlayer(playerid);
                    return 1;
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
  if(USE_ZOMENO_OLD_ENGINE == 0)
        {
        ShowNotification(playerid, 3, "Улучшение было куплено!", 3, "", "");
        ShowNotification(playerid, 0, "Вы потратили 5000000 рублей", 3, "", "");
   GivePlayerMoneyEx(playerid, -5000000);
     }
     else
     {
         ShowNotificationSile(playerid, 3, 5, 1, 10, "Улучшение было куплено!", "");
            GivePlayerMoneyEx(playerid, -5000000);
        }
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
          return SendClientMessage(playerid, 0x999999FF, "В разработке");
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
       if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
       {
        if(FindFreeGarageSlot(garageid) == -1)
        {
         SendClientMessage(playerid, 0x999999FF, "В гараже нет свободных мест (макс. 5 машин одновременно).");
         LoadCarGarage[playerid] = 0;
         return 1;
        }
       }
       else if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
       {
        SendClientMessage(playerid, 0x999999FF, "Системная ошибка. Транспорт уже загружен.");
        LoadCarGarage[playerid] = 0;
        return 1;
       }
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

stock DeliverCarSqlIdToGarage(playerid, sql_id, garageid)
{
    if(garageid < 0 || garageid >= g_garage_loaded || GetGarageData(garageid, GARAGE_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден или Вы не являетесь его владельцем");

    if(sql_id <= 0) return SendClientMessage(playerid, 0xCECECEFF, "Некорректный ID транспорта");

    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2 && FindFreeGarageSlot(garageid) == -1)
        return SendClientMessage(playerid, 0xCECECEFF, "В гараже нет свободных мест (макс. 5 машин одновременно). Сначала выведите один из автомобилей.");

    new query[160], Cache:result;
    mysql_format(mysql, query, sizeof query, "SELECT id FROM ownable_cars WHERE id=%d AND owner_id=%d LIMIT 1", sql_id, GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    new bool:owned = (mysql_errno(mysql) == 0 && cache_num_rows() > 0);
    cache_delete(result);
    if(!owned) return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт Вам не принадлежит");

    new vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        if(LoadOwnableCar(sql_id) == -1)
            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось загрузить транспорт с сервера");
        vehicleid = GetOwnableCarBySqlID(sql_id);
    }

    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "Машина не была создана. Проверьте ownable_cars");

    if(IsPlayerInVehicle(playerid, vehicleid))
        RemovePlayerFromVehicle(playerid);

    if(!PutVehicleDirectlyInGarage(vehicleid, garageid))
        return SendClientMessage(playerid, 0xCECECEFF, "Ошибка при перемещении транспорта в гараж");

    SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
    SetPVarInt(playerid, "ownable_vehicle_id", vehicleid);
    LoadCarGarage[playerid] = 0;
    DeletePVar(playerid, "garage_delivery_index");

    printf("[GARAGE DELIVERY] player=%d account=%d garage_idx=%d garage_db=%d car_sql=%d vehicle=%d OK", playerid, GetPlayerAccountID(playerid), garageid, GetGarageData(garageid, GARAGE_ID), sql_id, vehicleid);
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
   495.083526,
            1990.127807,
            1547.679687,
            272.186431,
   1,
   garageid + 2000
  );
  SetPlayerInGarage(playerid, garageid);
 }
}

stock FindGarageSlotForVehicle(garageid, vehicleid)
{
    if(garageid < 0 || garageid >= MAX_GARAGES || vehicleid == INVALID_VEHICLE_ID) return -1;
    for(new s = 0; s < MAX_GARAGE_SLOTS; s++)
    {
        if(g_garageSlotVehicle[garageid][s] == vehicleid) return s;
    }
    return -1;
}

stock FindFreeGarageSlot(garageid)
{
    if(garageid < 0 || garageid >= MAX_GARAGES) return -1;
    for(new s = 0; s < MAX_GARAGE_SLOTS; s++)
    {
        new vid = g_garageSlotVehicle[garageid][s];
        if(vid == INVALID_VEHICLE_ID || !IsValidVehicle(vid)) return s;
    }
    return -1;
}

stock FreeGarageVehicleSlot(garageid, vehicleid)
{
    new s = FindGarageSlotForVehicle(garageid, vehicleid);
    if(s != -1) g_garageSlotVehicle[garageid][s] = INVALID_VEHICLE_ID;
    return 1;
}

// Если игрок сидит в одном из своих припаркованных авто - возвращаем именно его,
// иначе откатываемся на старое поведение (P_OWNABLE_CAR).
stock GetPlayerGarageVehicleInUse(playerid, garageid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vid = GetPlayerVehicleID(playerid);
        if(FindGarageSlotForVehicle(garageid, vid) != -1) return vid;
    }
    return GetPlayerOwnableCar(playerid);
}

stock PutVehicleDirectlyInGarage(vehicleid, garageid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(garageid < 0 || garageid >= g_garage_loaded) return 0;

    if(GetGarageData(garageid, GARAGE_IMPROVEMENTS) == 2)
    {
        new slot = FindGarageSlotForVehicle(garageid, vehicleid);
        if(slot == -1) slot = FindFreeGarageSlot(garageid);
        if(slot == -1) return 0; // все 6 мест заняты

        g_garageSlotVehicle[garageid][slot] = vehicleid;

        SetVehiclePos(vehicleid, g_eliteGarageSlotPos[slot][0], g_eliteGarageSlotPos[slot][1], g_eliteGarageSlotPos[slot][2]);
        SetVehicleZAngle(vehicleid, g_eliteGarageSlotPos[slot][3]);
    }
    else
    {
        // Any invalid/legacy improvements value falls back to the standard garage.
        SetVehiclePos(vehicleid, 1.2011, 1994.7356, 1554.2031);
        SetVehicleZAngle(vehicleid, 359.354705);
    }

    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, garageid + 2000);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
    SetVehicleParam(vehicleid, V_ALARM, VEHICLE_PARAM_OFF);
    return 1;
}

stock PutOwnableCarInGarage(playerid, garageid)
{
    return PutVehicleDirectlyInGarage(GetPlayerOwnableCar(playerid), garageid);
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

CMD:gsetexitpos(playerid, params[])
{
 if(GetPlayerAdminEx(playerid) < 8) return 1;

 extract params -> new garage_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gsetexitpos [id гаража]");

 if(!(0 <= garage_id <= g_garage_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного гаража не существует на сервере");

 new Float:POS[4];
 GetPlayerPos(playerid, POS[0],POS[1],POS[2]);
 GetPlayerFacingAngle(playerid, POS[3]);
        
 new Float: exit_pos_x = POS[0];
 new Float: exit_pos_y = POS[1];
 new Float: exit_pos_z = POS[2];
 new Float: exit_angle = POS[3];

 new fmt_text[144];

 format
 (
  fmt_text, sizeof fmt_text,
  "UPDATE garages SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
  exit_pos_x,
  exit_pos_y,
  exit_pos_z,
  exit_angle,
  GetGarageData(garage_id, GARAGE_ID)
 );

 mysql_query(mysql, fmt_text, false);

 format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у гаража №%d", garage_id);

 SendClientMessage(playerid, 0x66CC33FF, fmt_text);

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