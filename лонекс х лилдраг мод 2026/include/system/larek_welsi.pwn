new Float:larek_default[11][3] =
{
    {2744.392333,-2429.169677,21.7},
    {1889.020263,-2243.588134,11.0},
    {1912.404785,-2266.849121,11.0},
    {847.117126,802.560485,13.3750},
    {1801.615356,2531.533203,14.60},
    {-1760.908569,790.954895,35.70},
    {-2402.363525,194.538864,26.00},
    {-111.869384,905.176818,12.210},
    {-113.259536,942.282653,12.210},
    {-256.006896,573.983764,12.19},
    {-1777.695312,817.128906,35.5}
};

new player_larek[MAX_PLAYERS][7];
new player_satiety[MAX_PLAYERS] = 100;

public CREATE_LAREK()
{
    mysql_query(mysql, "SELECT * FROM accounts WHERE satiety", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `satiety` INT NOT NULL DEFAULT '100' AFTER `money`", false);
        if(mysql_errno()) printf("[LAREK] Ошибка ALTER TABLE: %d", mysql_errno());
    }

    new string[684];
    format(string, sizeof string, "SELECT * FROM business WHERE type = %d", BUSINESS_TYPE_LAREK);
    new Cache:cache = mysql_query(mysql, string);
    new rows = cache_num_rows();

    if(rows == 0) 
    {
        printf("[LAREK] Ларьки не найдены в БД. Создаю %d ларьков...", sizeof larek_default);
        
        for(new i, s = sizeof larek_default; i < s; i++) 
        {
            mysql_format(mysql, string, sizeof string, 
                "INSERT INTO `business` (`owner_id`, `name`, `improvements`, `products`, `prod_price`, `balance`, `rent_time`, `price`, `rent_price`, `type`, `interior`, `enter_price`, `enter_music`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `eviction`) \
                VALUES ('0', 'Ларёк', '0', '0', '0', '0', '0', '500000', '2500', '%d', '11', '0', '0', '0', '%.2f', '%.2f', '%.2f', '0.0', '0.0', '0.0', '0.0', '0')", 
                BUSINESS_TYPE_LAREK,    
                larek_default[i][0],
                larek_default[i][1],
                larek_default[i][2]
            );
            mysql_query(mysql, string, false);

            if(mysql_errno()) 
            {
                printf("[LAREK] ОШИБКА создания ларька #%d: MySQL error %d", i, mysql_errno());
            }
            else
            {
                printf("[LAREK] Создан ларек #%d в %.2f, %.2f, %.2f", 
                    i, larek_default[i][0], larek_default[i][1], larek_default[i][2]);
            }
        }

        cache_delete(cache);
        
        printf("[LAREK] Ларьки добавлены в БД. Перезапуск сервера...");
        SetTimer("DelayedRestart", 2000, false);
        return 1;
    }
    else
    {
        printf("[LAREK] Найдено ларьков в БД: %d шт.", rows);
    }

    cache_delete(cache);
    return 1;
}

forward DelayedRestart();
public DelayedRestart()
{
    SendRconCommand("gmx");
}

public UpdateSatiety()
{
    new Float:heath, Float:heath_n, string[144];

    foreach(new i : Player) 
    {
        if(!IsPlayerLogged(i)) continue;
        if(player_satiety[i] > 50) continue; // Не спамить

        heath = GetPlayerHealthEx(i);
        
        if(player_satiety[i] >= 25 && player_satiety[i] <= 50)
        {
            format(string, sizeof string, "Уровень сытости ниже 50%% (%d%%). Рекомендуем подкрепиться в ближайшем ларьке", player_satiety[i]);
            SendClientMessage(i, 0xF3D80CFF, string);
            player_satiety[i] -= random(5)+1;
        }
        else if(player_satiety[i] >= 5 && player_satiety[i] <= 24)
        {
            format(string, sizeof string, "Уровень сытости ниже 25%% (%d%%)", player_satiety[i]);
            SendClientMessage(i, 0xF3D80CFF, "Вы голодны! Подкрепитесь в ближайшем ларьке, иначе здоровье ухудшится!");
            SendClientMessage(i, 0xF3D80CFF, string);
            player_satiety[i] -= random(6)+3;

            heath_n = heath - random(8);

            if(heath_n <= 0) 
            {
                SendClientMessage(i, -1, "Вы потеряли сознание от голода!");
                SetPlayerHealthEx(i, 0);
            }
            else SetPlayerHealthEx(i, heath - random(5));
        }
        else if(player_satiety[i] >= 0 && player_satiety[i] <= 4)
        {
            player_satiety[i] = 0;
            SetPlayerHealthEx(i, 0);
            SendClientMessage(i, -1, "Вы потеряли сознание от голода!");
        }

        UpdatePlayerDatabaseInt(i, "satiety", player_satiety[i]);
    }

    return 1;
}

public OnGameModeInit()
{
    SetTimer("CREATE_LAREK", 4000, false);
    SetTimer("UpdateSatiety", 1000*300, true);
    
    #if defined larekk_OnGameModeInit
        return larekk_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit larekk_OnGameModeInit
#if defined larekk_OnGameModeInit
    forward larekk_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    player_satiety[playerid] = 100;
    
    #if defined larekk_OnPlayerConnect
        return larekk_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect larekk_OnPlayerConnect
#if defined larekk_OnPlayerConnect
    forward larekk_OnPlayerConnect(playerid);
#endif