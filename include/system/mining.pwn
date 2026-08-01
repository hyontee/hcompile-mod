#define MAX_GPUS 4
#define MAX_PLAYER_GPUS 10
#define RIG_PRICE 25000000

#define OFFER_MINE 19
#define DIALOG_GPU_STORE 4453
#define DIALOG_GPU_BUY 4454
#define DIALOG_GPU_SELL 4455
#define DIALOG_GPU_SELL_CONFIRM 4456
#define DIALOG_MINING_MANAGE 4457

new exchangeAreas[3];
new Text3D:exchangeLabels[3];
new miningTimer[MAX_PLAYERS];
new currentBitcoinRate = 1000000;

enum GPU_INFO 
{
    gpu_name[32],
    Float:gpu_hashrate,
    gpu_price
};

new const gpuData[MAX_GPUS][GPU_INFO] = 
{
    {"GTX 1650", 0.1, 5000000},
    {"RTX 2060", 0.25, 7000000},
    {"RTX 3070", 0.4, 12000000},
    {"RTX 4090", 0.5, 15000000}
};

new Float:exchangeCoords[3][3] = {
    {2894.488281, 2490.898925, 1051.044799},
    {2894.488037, 2489.383300, 1051.044799},
    {2894.416259, 2487.865966, 1051.044799}
};

new playerSelectedGPU[MAX_PLAYERS];

public OnGameModeInit() 
{
    SetTimer("CREATE_MINING_TABLE", 4000, false);
    UpdateBitcoinRate();

    #if defined wermin_OnGameModeInit
        return wermin_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit wermin_OnGameModeInit
#if defined wermin_OnGameModeInit
    forward wermin_OnGameModeInit();
#endif

forward UpdateBitcoinRate();
public UpdateBitcoinRate()
{
    new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour, minute, second);
    
    new weekday = GetWeekday(year, month, day);

    switch(weekday)
    {
        case 1: currentBitcoinRate = 900000;    // Понедельник
        case 2: currentBitcoinRate = 950000;    // Вторник
        case 3: currentBitcoinRate = 1000000;   // Среда
        case 4: currentBitcoinRate = 1050000;   // Четверг
        case 5: currentBitcoinRate = 1100000;   // Пятница
        case 6: currentBitcoinRate = 1200000;   // Суббота
        case 0: currentBitcoinRate = 1150000;   // Воскресенье
        default: currentBitcoinRate = 1000000;  // По умолчанию
    }
    
    UpdateExchangeLabels();
    
    printf("[BITCOIN] Курс биткоина обновлен: %d руб. за 1 BTC (День недели: %d)", currentBitcoinRate, weekday);
    return 1;
}

stock GetWeekday(year, month, day)
{
    if(month < 3)
    {
        month += 12;
        year--;
    }
    
    new k = year % 100;
    new j = year / 100;
    
    new h = (day + (13 * (month + 1)) / 5 + k + (k / 4) + (j / 4) + (5 * j)) % 7;
    
    // Преобразуем результат алгоритма Зеллера (0=суббота, 1=воскресенье, ..., 6=пятница)
    // в наш формат (0=воскресенье, 1=понедельник, ..., 6=суббота)
    new weekday = (h + 5) % 7;
    
    return weekday;
}

stock UpdateExchangeLabels()
{
    new labelText[256];
    new formattedRate[32];
    ConvertMining(currentBitcoinRate, formattedRate);
    
    for(new i = 0; i < 3; i++)
    {
        format(labelText, sizeof(labelText), "{FFD700}« Обмен BTC »\n \n{BEBEBE}[ текущий курс:\n{BEBEBE}%s за 1 BTC ]", formattedRate);

        exchangeLabels[i] = CreateDynamic3DTextLabel(labelText, 0x66CC66FF, \
            exchangeCoords[i][0], \
            exchangeCoords[i][1], \
            exchangeCoords[i][2] + 1.0, 8.0);

        exchangeAreas[i] = CreateDynamicSphere(
            exchangeCoords[i][0], \
            exchangeCoords[i][1], \
            exchangeCoords[i][2], 2.0);
    }
}

stock ConvertMining(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, ".", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < 3; i++)
    {
        if(areaid == exchangeAreas[i])
        {
            new formattedRate[32];
            ConvertMining(currentBitcoinRate, formattedRate);
            
            new notificationText[128];
            format(notificationText, sizeof(notificationText), 
                "Обмен биткойнов (Курс: %s руб.)", formattedRate);
                
            ShowNotificationSander(playerid, 4, 6, OFFER_MINE, 0, notificationText, ">>");
            return 1;
        }
    }
    
    #if defined wermin_OnPlayerEnterDynamicArea
        return wermin_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea wermin_OnPlayerEnterDynamicArea
#if defined wermin_OnPlayerEnterDynamicArea
    forward wermin_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

stock ShowExchangeDialog(playerid)
{
    new btc_amount = GetPlayerEuro(playerid);
    
    new formattedRate[32];
    ConvertMining(currentBitcoinRate, formattedRate);
    
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}У вас на счету: {FFFF00}%d Bitcoin(-ов)\n\n{FFFFFF}Текущий курс обмена: {FFFF00}1 Bitcoin = %s рублей\n\n{FFFFFF}Введите количество {FFFF00}Bitcoin{FFFFFF} для обмена (мин. 1):",
        btc_amount, formattedRate);

    ShowPlayerDialog(playerid, 1602, DIALOG_STYLE_INPUT,
        "{FFFF00}Обмен Bitcoin на рубли",
        string,
        "Обменять", "Назад");
}

public CREATE_MINING_TABLE()
{
    new Cache:cache;
    
    cache = mysql_query(mysql, "SHOW TABLES LIKE 'player_gpus'", true);
    if(!cache_num_rows())
    {
        mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `player_gpus` (\
            `id` INT NOT NULL AUTO_INCREMENT, \
            `player_id` INT NOT NULL, \
            `gpu_type` INT NOT NULL, \
            `active` TINYINT DEFAULT 1, \
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, \
            PRIMARY KEY (`id`)\
        )", false);
    }
    cache_delete(cache);

    cache = mysql_query(mysql, "SHOW COLUMNS FROM `accounts` LIKE 'bitcoin'", true);
    if(!cache_num_rows())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `bitcoin` FLOAT DEFAULT 0.0", false);
    }
    cache_delete(cache);

    cache = mysql_query(mysql, "SHOW COLUMNS FROM `accounts` LIKE 'mining_rig'", true);
    if(!cache_num_rows())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `mining_rig` INT DEFAULT 0", false);
    }
    cache_delete(cache);

    cache = mysql_query(mysql, "SHOW COLUMNS FROM `accounts` LIKE 'mining_status'", true);
    if(!cache_num_rows())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `mining_status` INT DEFAULT 0", false);
    }
    cache_delete(cache);
    
    return 1;
}

stock StartPlayerMining(playerid)
{
    if(GetPlayerMiningStatus(playerid)) return 0;
    
    SetPlayerMiningStatus(playerid, 1);
    
    return 1;
}

stock StopPlayerMining(playerid)
{
    if(!GetPlayerMiningStatus(playerid)) return 0;
    
    SetPlayerMiningStatus(playerid, 0);
    
    if(miningTimer[playerid] != -1)
    {
        KillTimer(miningTimer[playerid]);
        miningTimer[playerid] = -1;
    }
    
    return 1;
}

stock Float:GetPlayerAccumulatedBTC(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0.0;
    
    new query[128];
    format(query, sizeof(query), "SELECT bitcoin FROM accounts WHERE id = %d", account_id);
    new Cache:result = mysql_query(mysql, query);
    
    new Float:btc = 0.0;
    if(cache_num_rows()) 
    {
        btc = cache_get_field_content_float(0, "bitcoin");
    }
    
    cache_delete(result);
    return btc;
}

stock SetPlayerAccumulatedBTC(playerid, Float:amount)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0;
    
    new query[128];
    format(query, sizeof(query), "UPDATE accounts SET bitcoin = %f WHERE id = %d", amount, account_id);
    mysql_query(mysql, query);
    
    return 1;
}

// Функции для работы с целочисленным Bitcoin (обертки)
stock GetPlayerEuro(playerid)
{
    return floatround(GetPlayerAccumulatedBTC(playerid), floatround_floor);
}

stock SetPlayerEuro(playerid, amount)
{
    SetPlayerAccumulatedBTC(playerid, float(amount));
    return 1;
}

stock GetPlayerMiningRig(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0;
    
    new query[128];
    format(query, sizeof(query), "SELECT mining_rig FROM accounts WHERE id = %d", account_id);
    new Cache:result = mysql_query(mysql, query);
    
    new rig = 0;
    if(cache_num_rows()) 
    {
        rig = cache_get_field_content_int(0, "mining_rig");
    }
    
    cache_delete(result);
    return rig;
}

stock SetPlayerMiningRig(playerid, status)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0;
    
    new query[128];
    format(query, sizeof(query), "UPDATE accounts SET mining_rig = %d WHERE id = %d", status, account_id);
    mysql_query(mysql, query);
    
    return 1;
}

stock GetPlayerMiningStatus(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0;
    
    new query[128];
    format(query, sizeof(query), "SELECT mining_status FROM accounts WHERE id = %d", account_id);
    new Cache:result = mysql_query(mysql, query);
    
    new status = 0;
    if(cache_num_rows()) 
    {
        status = cache_get_field_content_int(0, "mining_status");
    }
    
    cache_delete(result);
    return status;
}

stock SetPlayerMiningStatus(playerid, status)
{
    new account_id = GetPlayerAccountID(playerid);
    
    new query[128];
    format(query, sizeof(query), "UPDATE accounts SET mining_status = %d WHERE id = %d", status, account_id);
    mysql_query(mysql, query);
    return 1;
}

public OnPlayerDisconnect(playerid, reason) 
{
    StopPlayerMining(playerid);
    
    #if defined wermin_OnPlayerDisconnect
        return wermin_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect wermin_OnPlayerDisconnect
#if defined wermin_OnPlayerDisconnect
    forward wermin_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerConnect(playerid) 
{
    playerSelectedGPU[playerid] = -1;
    miningTimer[playerid] = -1;
    
    SetTimerEx("CheckPlayerGPUsAfterConnect", 20000, false, "i", playerid);
    
    #if defined wermin_OnPlayerConnect
        return wermin_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect wermin_OnPlayerConnect
#if defined wermin_OnPlayerConnect
    forward wermin_OnPlayerConnect(playerid);
#endif

forward CheckPlayerGPUsAfterConnect(playerid);
public CheckPlayerGPUsAfterConnect(playerid)
{
    if(!IsPlayerConnected(playerid)) return;
    
    if(GetPlayerGPUCount(playerid) > 0 && GetPlayerMiningRig(playerid))
    {
        if(GetPlayerMiningStatus(playerid))
        {
            StartPlayerMining(playerid);

            if(miningTimer[playerid] == -1)
            {
                miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid); // 5 минут
            }
            ShowNotificationSander(playerid, 1, 6, 0, 0, "Майнинг автоматически запущен!", "");
        }
        else ShowNotificationSander(playerid, 1, 6, 0, 0, "Для автоматического запуска майнинга активируйте его в доме!", "");
    }
}

forward OnMiningTimer(playerid);
public OnMiningTimer(playerid) 
{
    if(!IsPlayerConnected(playerid)) 
    {
        if(GetPlayerMiningStatus(playerid)) 
        {
            StopPlayerMining(playerid);
        }
        return;
    }
    
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    if(houseid == -1) 
    {
        if(GetPlayerMiningStatus(playerid)) 
        {
            StopPlayerMining(playerid);
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Майнинг остановлен - у вас нет дома!", "");
        }
        return;
    }
    
    if(GetPlayerGPUCount(playerid) == 0) 
    {
        if(GetPlayerMiningStatus(playerid))
        {
            StopPlayerMining(playerid);
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Майнинг остановлен - нет видеокарт!", "");
        }
        return;
    }
    
    if(!GetPlayerMiningRig(playerid))
    {
        if(GetPlayerMiningStatus(playerid))
        {
            StopPlayerMining(playerid);
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Майнинг остановлен - нет майнинг-рига!", "");
        }
        return;
    }
    
    new Float:total_hashrate = GetPlayerTotalHashrate(playerid);
    
    if(total_hashrate > 0.0)
    {
        new Float:current_btc = GetPlayerAccumulatedBTC(playerid);
        current_btc += total_hashrate;
        SetPlayerAccumulatedBTC(playerid, current_btc);
        
        new msg[128];
        format(msg, sizeof(msg), "Майнинг: +%.2f BTC | Текущий баланс: %.2f BTC", total_hashrate, current_btc);
        ShowNotificationSander(playerid, 1, 6, 0, 0, msg, "");
    }
    
    new Float:accumulated_btc = GetPlayerAccumulatedBTC(playerid);
    if(accumulated_btc >= 1.0) 
    {
        new int_btc = floatround(accumulated_btc, floatround_floor);
        accumulated_btc -= float(int_btc);
        SetPlayerAccumulatedBTC(playerid, accumulated_btc);
        
        new current_btc = GetPlayerEuro(playerid);
        SetPlayerEuro(playerid, current_btc + int_btc);
        
        new msg[128];
        format(msg, sizeof(msg), "Майнинг: получено %d Bitcoin! Всего: %d", int_btc, current_btc + int_btc);
        ShowNotificationSander(playerid, 1, 6, 0, 0, msg, "");
    }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    if(dialogid == 1602) 
    {
        if(!response) return 1;
        
        if(isnull(inputtext)) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Введите количество Bitcoin для обмена!", "");
            ShowExchangeDialog(playerid);
            return 1;
        }
        
        new amount = strval(inputtext);
        
        if(amount < 1) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Минимальная сумма для обмена - 1 Bitcoin!", "");
            ShowExchangeDialog(playerid);
            return 1;
        }
        
        new current_btc = GetPlayerEuro(playerid);
        
        if(current_btc < amount) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас недостаточно Bitcoin для обмена!", "");
            ShowExchangeDialog(playerid);
            return 1;
        }
        
        new money_amount = amount * currentBitcoinRate;
        
        SetPlayerEuro(playerid, current_btc - amount);
        GivePlayerMoney(playerid, money_amount);
        
        new formattedRate[32], formattedMoney[32];
        ConvertMining(currentBitcoinRate, formattedRate);
        ConvertMining(money_amount, formattedMoney);
        
        new success_msg[256];
        format(success_msg, sizeof(success_msg), 
            "Вы успешно обменяли %d Bitcoin на %s рублей!\nКурс обмена: 1 BTC = %s руб.",
            amount, formattedMoney, formattedRate);
        ShowNotificationSander(playerid, 1, 6, 0, 0, success_msg, "");
        
        return 1;
    }
    else if(dialogid == DIALOG_GPU_STORE) 
    {
        if(!response) return 1;
        
        if(listitem < 0 || listitem >= MAX_GPUS) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Неверный выбор видеокарты!", "");
            return 1;
        }
        
        playerSelectedGPU[playerid] = listitem;
        
        new confirmString[256];
        format(confirmString, sizeof(confirmString),
            "{FFFFFF}Вы выбрали: {FFFF00}%s\n\n" \
            "{FFFFFF}Хешрейт: {FFFF00}%.2f BTC/5min\n" \
            "{FFFFFF}Цена: {FFFF00}%d руб.\n\n" \
            "{FFFFFF}На ваш баланс: {FFFF00}%d руб.\n\n" \
            "{FFFFFF}Подтвердите покупку:",
            gpuData[listitem][gpu_name],
            gpuData[listitem][gpu_hashrate],
            gpuData[listitem][gpu_price],
            GetPlayerMoney(playerid));
        
        ShowPlayerDialog(playerid, DIALOG_GPU_BUY, DIALOG_STYLE_MSGBOX,
            "{FFFF00}Подтверждение покупки видеокарты",
            confirmString,
            "Купить", "Отмена");
        
        return 1;
    }
    else if(dialogid == DIALOG_GPU_BUY) 
    {
        if(!response) 
        {
            playerSelectedGPU[playerid] = -1;
            return 1;
        }
        
        if(playerSelectedGPU[playerid] == -1) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Ошибка выбора видеокарты!", "");
            return 1;
        }
        
        new gpu_id = playerSelectedGPU[playerid];
        playerSelectedGPU[playerid] = -1;
        
        new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
        if(houseid == -1) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Для покупки видеокарты необходим собственный дом!", "");
            return 1;
        }
        
        if(!GetPlayerMiningRig(playerid)) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
            return 1;
        }
        
        if(GetPlayerGPUCount(playerid) >= MAX_PLAYER_GPUS) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас максимальное количество видеокарт!", "");
            return 1;
        }
        
        if(GetPlayerMoney(playerid) < gpuData[gpu_id][gpu_price]) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Недостаточно денег для покупки этой видеокарты!", "");
            return 1;
        }
        
        GivePlayerMoneyEx(playerid, -gpuData[gpu_id][gpu_price]);
        
        new bool:success = SavePlayerGPU(playerid, gpu_id);
        
        if(success && GetPlayerGPUCount(playerid) == 1 && !GetPlayerMiningStatus(playerid))
        {
            StartPlayerMining(playerid);

            if(miningTimer[playerid] == -1)
            {
                miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid); // 5 минут
            }
            
            ShowNotificationSander(playerid, 1, 6, 0, 0, "Майнинг автоматически запущен!", "");
        }
        
        if(success)
        {
            new msg[128];
            format(msg, sizeof(msg), "Вы успешно купили видеокарту %s за %d руб.!", 
                gpuData[gpu_id][gpu_name], gpuData[gpu_id][gpu_price]);
            ShowNotificationSander(playerid, 1, 6, 0, 0, msg, "");
        }
        else
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Ошибка при покупке видеокарты!", "");
        }
        
        return 1;
    }
    else if(dialogid == DIALOG_GPU_SELL) 
    {
        if(!response) return 1;
        
        if(listitem < 0 || listitem >= GetPlayerGPUCount(playerid)) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Неверный выбор видеокарты!", "");
            return 1;
        }
        
        playerSelectedGPU[playerid] = listitem;
        
        new gpu_id = GetPlayerGPUType(playerid, listitem);
        if(gpu_id == -1)
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Ошибка получения типа видеокарты!", "");
            return 1;
        }
        
        new sell_price = floatround(gpuData[gpu_id][gpu_price] * 0.8);
        
        new confirmString[256];
        format(confirmString, sizeof(confirmString),
            "{FFFFFF}Вы выбрали: {FFFF00}%s\n\n" \
            "{FFFFFF}Хешрейт: {FFFF00}%.2f BTC/5min\n" \
            "{FFFFFF}Цена покупки: {FFFF00}%d руб.\n" \
            "{FFFFFF}Цена продажи: {FFFF00}%d руб. (-20%%)\n\n" \
            "{FFFFFF}Подтвердите продажу:",
                            gpuData[gpu_id][gpu_hashrate],
                gpuData[gpu_id][gpu_price],
                sell_price);
        
        ShowPlayerDialog(playerid, DIALOG_GPU_SELL_CONFIRM, DIALOG_STYLE_MSGBOX,
            "{FFFF00}Подтверждение продажи видеокарты",
            confirmString,
            "Продать", "Отмена");
        
        return 1;
    }
    else if(dialogid == DIALOG_GPU_SELL_CONFIRM) 
    {
        if(!response) 
        {
            playerSelectedGPU[playerid] = -1;
            return 1;
        }
        
        if(playerSelectedGPU[playerid] == -1) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Ошибка выбора видеокарты!", "");
            return 1;
        }
        
        new slot = playerSelectedGPU[playerid];
        playerSelectedGPU[playerid] = -1;
        
        if(slot < 0 || slot >= GetPlayerGPUCount(playerid)) 
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Неверный ID видеокарты!", "");
            return 1;
        }
        
        new gpu_id = GetPlayerGPUType(playerid, slot);
        if(gpu_id == -1)
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Ошибка получения типа видеокарты!", "");
            return 1;
        }
        
        new sell_price = floatround(gpuData[gpu_id][gpu_price] * 0.8);
        
        new bool:success = RemovePlayerGPU(playerid, slot);
        
        if(success)
        {
            GivePlayerMoneyEx(playerid, sell_price);
            new msg[128];
            format(msg, sizeof(msg), "Вы продали видеокарту %s за %d руб. (-20%%)", gpuData[gpu_id][gpu_name], sell_price);
            ShowNotificationSander(playerid, 1, 6, 0, 0, msg, "");
            
            if(GetPlayerGPUCount(playerid) == 0 && GetPlayerMiningStatus(playerid))
            {
                StopPlayerMining(playerid);
                ShowNotificationSander(playerid, 2, 6, 0, 0, "Майнинг остановлен - нет видеокарт!", "");
            }
        }
        else
        {
            ShowNotificationSander(playerid, 2, 6, 0, 0, "Ошибка при продаже видеокарты!", "");
        }
        
        return 1;
    }
    else if(dialogid == 4452)
    {
        if(!response)
        {
            ShowMiningManagementDialog(playerid);
        }
        return 1;
    }
    else if(dialogid == DIALOG_MINING_MANAGE)
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: // Инвентарь видеокарт
            {
                ShowGPUInventory(playerid);
            }
            case 1: // Включить/Выключить майнинг
            {
                if(GetPlayerMiningStatus(playerid))
                {
                    // Выключить майнинг
                    StopPlayerMining(playerid);
                    ShowNotificationSander(playerid, 1, 6, 0, 0, "Майнинг остановлен!", "");
                    
                    ShowMiningManagementDialog(playerid);
                }
                else
                {
                    // Включить майнинг
                    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
                    if(houseid == -1) 
                    {
                        ShowNotificationSander(playerid, 2, 6, 0, 0, "Для майнинга необходим собственный дом!", "");
                        ShowMiningManagementDialog(playerid);
                        return 1;
                    }
                    
                    if(GetPlayerGPUCount(playerid) == 0) 
                    {
                        ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас нет видеокарт для майнинга!", "");
                        ShowMiningManagementDialog(playerid);
                        return 1;
                    }
                    
                    if(!GetPlayerMiningRig(playerid))
                    {
                        ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас нет майнинг-рига!", "");
                        ShowMiningManagementDialog(playerid);
                        return 1;
                    }
                    
                    StartPlayerMining(playerid);
                    
                    if(miningTimer[playerid] == -1)
                    {
                        miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid);
                    }
                    
                    ShowNotificationSander(playerid, 1, 6, 0, 0, "Майнинг запущен!", "");
                    
                    ShowMiningManagementDialog(playerid);
                }
            }
        }
        return 1;
    }
    
    #if defined wermin_OnDialogResponse
        return wermin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse wermin_OnDialogResponse
#if defined wermin_OnDialogResponse
    forward wermin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif





stock GetPlayerBitcoin(playerid) 
{
    return floatround(GetPlayerAccumulatedBTC(playerid));
}

stock SetPlayerBitcoin(playerid, Float:amount) 
{
    SetPlayerAccumulatedBTC(playerid, amount);
}

stock GetPlayerGPUCount(playerid) 
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0;
    
    new query[128];
    format(query, sizeof(query), "SELECT COUNT(*) as count FROM player_gpus WHERE player_id = %d", account_id);
    new Cache:result = mysql_query(mysql, query);
    
    new count = 0;
    if(cache_num_rows()) 
    {
        count = cache_get_field_content_int(0, "count");
    }
    
    cache_delete(result);
    return count;
}

stock GetPlayerGPUType(playerid, slot)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return -1;
    
    new query[256];
    format(query, sizeof(query), "SELECT gpu_type FROM player_gpus WHERE player_id = %d ORDER BY id LIMIT %d, 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query);
    
    new gpu_type = -1;
    if(cache_num_rows()) 
    {
        gpu_type = cache_get_field_content_int(0, "gpu_type");
    }
    
    cache_delete(result);
    return gpu_type;
}

stock GetPlayerGPUDBID(playerid, slot)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return -1;
    
    new query[256];
    format(query, sizeof(query), "SELECT id FROM player_gpus WHERE player_id = %d ORDER BY id LIMIT %d, 1", account_id, slot);
    new Cache:result = mysql_query(mysql, query);
    
    new db_id = -1;
    if(cache_num_rows()) 
    {
        db_id = cache_get_field_content_int(0, "id");
    }
    
    cache_delete(result);
    return db_id;
}

stock bool:SavePlayerGPU(playerid, gpu_type) 
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return false;
    
    new query[256];
    format(query, sizeof(query), "INSERT INTO player_gpus (player_id, gpu_type, active) VALUES (%d, %d, 1)", account_id, gpu_type);
    
    mysql_query(mysql, query);
    
    if(mysql_errno()) 
    {
        return false;
    }
    
    return true;
}

stock bool:RemovePlayerGPU(playerid, slot) 
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return false;
    
    new db_id = GetPlayerGPUDBID(playerid, slot);
    if(db_id == -1) return false;
    
    new query[128];
    format(query, sizeof(query), "DELETE FROM player_gpus WHERE id = %d", db_id);
    
    mysql_query(mysql, query);
    
    if(mysql_errno()) 
    {
        return false;
    }
    
    return true;
}

stock Float:GetPlayerTotalHashrate(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id == 0) return 0.0;
    
    new query[256];
    format(query, sizeof(query), "SELECT gpu_type FROM player_gpus WHERE player_id = %d AND active = 1", account_id);
    new Cache:result = mysql_query(mysql, query);
    
    new Float:total_hashrate = 0.0;
    new rows = cache_num_rows();
    
    for(new i = 0; i < rows; i++) 
    {
        new gpu_type = cache_get_field_content_int(i, "gpu_type");
        if(gpu_type >= 0 && gpu_type < MAX_GPUS)
        {
            total_hashrate += gpuData[gpu_type][gpu_hashrate];
        }
    }
    
    cache_delete(result);
    return total_hashrate;
}

stock ShowGPUInventory(playerid) 
{
    new string[2048];
    format(string, sizeof(string), "{FFFFFF}Ваши видеокарты:\n\n");
    
    new gpu_count = GetPlayerGPUCount(playerid);
    if(gpu_count == 0) 
    {
        strcat(string, "{FFFF00}У вас нет видеокарт\n\n");
    }
    else 
    {
        new Float:total_hashrate = GetPlayerTotalHashrate(playerid);
        
        new account_id = GetPlayerAccountID(playerid);
        new query[256];
        format(query, sizeof(query), "SELECT gpu_type, active FROM player_gpus WHERE player_id = %d ORDER BY id", account_id);
        new Cache:result = mysql_query(mysql, query);
        
        new rows = cache_num_rows();
        for(new i = 0; i < rows; i++) 
        {
            new gpu_type = cache_get_field_content_int(i, "gpu_type");
            new active = cache_get_field_content_int(i, "active");
            
            new status[32];
            format(status, sizeof(status), "{00FF00}Активна");
            
            new lineMine[256];
            format(lineMine, sizeof(lineMine), "{FFFF00}%d. {FFFFFF}%s - %s {FFFFFF}(%.2f BTC/5min)\n", 
                i + 1, gpuData[gpu_type][gpu_name], status, gpuData[gpu_type][gpu_hashrate]);
            strcat(string, lineMine);
        }
        
        cache_delete(result);
        
        new infoLine[128];
        format(infoLine, sizeof(infoLine), "\n{FFFFFF}Общий хешрейт: {FFFF00}%.2f BTC/5min\n", total_hashrate);
        strcat(string, infoLine);
    }
    
    strcat(string, "\n{FFFFFF}Команды управления:\n");
    strcat(string, "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту\n\n");
    strcat(string, "{FFFFFF}Майнинг работает автоматически при наличии рига и видеокарт!");
    
    ShowPlayerDialog(playerid, 1603, DIALOG_STYLE_MSGBOX, "{FFFF00}Инвентарь видеокарт", string, "Закрыть", "");
}

stock ShowGPUSellMenu(playerid)
{
    new gpu_count = GetPlayerGPUCount(playerid);
    if(gpu_count == 0)
    {
        ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас нет видеокарт для продажи!", "");
        return 0;
    }
    
    new string[2048];
    format(string, sizeof(string), "");
    
    new account_id = GetPlayerAccountID(playerid);
    new query[256];
    format(query, sizeof(query), "SELECT gpu_type FROM player_gpus WHERE player_id = %d ORDER BY id", account_id);
    new Cache:result = mysql_query(mysql, query);
    
    new rows = cache_num_rows();
    for(new i = 0; i < rows; i++) 
    {
        new gpu_type = cache_get_field_content_int(i, "gpu_type");
        new sell_price = floatround(gpuData[gpu_type][gpu_price] * 0.8);
        
        new SellGpu[128];
        format(SellGpu, sizeof(SellGpu), "{FFFF00}%d. {FFFFFF}%s - {FFFF00}%d руб.{FFFFFF}(%.2f BTC/5min)\n", 
            i, gpuData[gpu_type][gpu_name], sell_price, gpuData[gpu_type][gpu_hashrate]);
        strcat(string, SellGpu);
    }
    
    cache_delete(result);
    
    ShowPlayerDialog(playerid, DIALOG_GPU_SELL, DIALOG_STYLE_LIST,
        "Продажа видеокарт",
        string,
        "Выбрать", "Отмена");
    
    return 1;
}

stock ShowMiningMenu(playerid) 
{
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    
    new Float:total_hashrate = GetPlayerTotalHashrate(playerid);
    new Float:accumulated_btc = GetPlayerAccumulatedBTC(playerid);
    
    new formattedRate[32];
    ConvertMining(currentBitcoinRate, formattedRate);

    new year, month, day;
    getdate(year, month, day);
    new weekday = GetWeekday(year, month, day);
    
    new weekdayNames[7][] = {
        "Воскресенье",
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота"
    };
    
    new string[2048];
    format(string, sizeof(string),
        "{FFFFFF}Состояние майнинг-фермы:\n\n" \
        "{FFFFFF}Майнинг-риг: {FFFF00}%s\n" \
        "{FFFFFF}Видеокарт: {FFFF00}%d/%d\n" \
        "{FFFFFF}Общий хешрейт: {FFFF00}%.2f BTC/5min\n" \
        "{FFFFFF}Состояние: {FFFF00}%s\n" \
        "{FFFFFF}В доме: {FFFF00}%s\n" \
        "{FFFFFF}Накоплено Bitcoin: {FFFF00}%.2f\n\n" \
        "{FFFFFF}Текущий курс Bitcoin:\n" \
        "{FFFF00}%s руб. за 1 BTC\n" \
        "{FFFFFF}День недели: {FFFF00}%s\n\n" \
        "{FFFFFF}Доступные команды:\n" \
        "{FFFF00}/buyrig {FFFFFF}- Купить майнинг-риг (25.000.000 руб.)\n" \
        "{FFFF00}/buygpu {FFFFFF}- Магазин видеокарт\n" \
        "{FFFF00}/gpuinv {FFFFFF}- Инвентарь видеокарт\n" \
        "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту\n" \
        "{FFFF00}/btc {FFFFFF}- Проверить баланс Bitcoin\n" \
        "{FFFF00}/exchangebtc {FFFFFF}- Обменять Bitcoin",
        GetPlayerMiningRig(playerid) ? "Есть" : "Нет",
        GetPlayerGPUCount(playerid),
        MAX_PLAYER_GPUS,
        total_hashrate,
        GetPlayerMiningStatus(playerid) ? "Активен" : "Остановлен",
        houseid > -1 ? "Да" : "Нет",
        accumulated_btc,
        formattedRate,
        weekdayNames[weekday]
    );
    
    ShowPlayerDialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "{FFFF00}Майнинг-ферма", string, "Закрыть", "Управление");
}

stock ShowMiningManagementDialog(playerid)
{
    new miningStatus = GetPlayerMiningStatus(playerid);
    new statusText[32];
    format(statusText, sizeof(statusText), miningStatus ? "2. Выключить майнинг" : "2. Включить майнинг");

    new formattedRate[32];
    ConvertMining(currentBitcoinRate, formattedRate);
    
    new year, month, day;
    getdate(year, month, day);
    new weekday = GetWeekday(year, month, day);
    
    new weekdayNames[7][] = {
        "Воскресенье",
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота"
    };
    
    new string[512];
    format(string, sizeof(string),
        "1. Инвентарь видеокарт\n" \
        "%s\n\n" \
        "{FFFFFF}Статус майнинга: {FFFF00}%s\n" \
        "{FFFFFF}Текущий курс BTC: {FFFF00}%s руб.\n" \
        "{FFFFFF}День недели: {FFFF00}%s",
        statusText,
        miningStatus ? "{00FF00}Включен" : "{FF0000}Выключен",
        formattedRate,
        weekdayNames[weekday]);
    
    ShowPlayerDialog(playerid, DIALOG_MINING_MANAGE, DIALOG_STYLE_LIST, 
        "{FFFF00}Управление майнинг-фермой", 
        string, 
        "Выбрать", "Назад");
}

stock ShowGPUStore(playerid) 
{
    ShowPlayerDialog(playerid, DIALOG_GPU_STORE, DIALOG_STYLE_LIST, 
        "Магазин видеокарт", 
        "{FFFF00}0. {FFFFFF}GTX 1650 - {FFFF00}5.000.000 руб.{FFFFFF}(0.1 BTC/5min)\n" \
        "{FFFF00}1. {FFFFFF}RTX 2060 - {FFFF00}7.000.000 руб.{FFFFFF}(0.25 BTC/5min)\n" \
        "{FFFF00}2. {FFFFFF}RTX 3070 - {FFFF00}12.000.000 руб.{FFFFFF}(0.4 BTC/5min)\n" \
        "{FFFF00}3. {FFFFFF}RTX 4090 - {FFFF00}15.000.000 руб.{FFFFFF}(0.5 BTC/5min)\n\n", 
        "Выбрать", "Отмена");
}

CMD:mining(playerid, params[]) 
{
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    if(houseid == -1) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Для майнинга необходим собственный дом!", "");

    new type = GetHouseData(GetPlayerInHouse(playerid), H_TYPE);
    if(!IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z))) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Вы должны находиться у себя дома для просмотра статистики. Используйте /btc чтобы проверить свой баланс Bitcoin", "");

    ShowMiningMenu(playerid);
    return 1;
}

CMD:buyrig(playerid, params[]) 
{
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    if(houseid == -1) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Для установки рига необходим собственный дом!", "");
    if(GetPlayerMiningRig(playerid)) return ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас уже есть майнинг-риг!", "");
    if(GetPlayerMoney(playerid) < RIG_PRICE) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Недостаточно денег для покупки рига!", "");

    new type = GetHouseData(GetPlayerInHouse(playerid), H_TYPE);
    if(!IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z))) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Вы должны находиться у себя дома для покупки", "");

    GivePlayerMoneyEx(playerid, -RIG_PRICE);
    SetPlayerMiningRig(playerid, 1);
    ShowNotificationSander(playerid, 1, 6, 0, 0, "Вы успешно купили майнинг-риг!", "");
    
    if(GetPlayerGPUCount(playerid) > 0 && !GetPlayerMiningStatus(playerid))
    {
        StartPlayerMining(playerid);
        
        if(miningTimer[playerid] == -1)
        {
            miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid);
        }
        
        ShowNotificationSander(playerid, 1, 6, 0, 0, "Майнинг автоматически запущен!", "");
    }
    
    return 1;
}

CMD:buygpu(playerid, params[]) 
{
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    if(houseid == -1) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Для майнинга необходим собственный дом!", "");
    if(!GetPlayerMiningRig(playerid)) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
    if(GetPlayerGPUCount(playerid) >= MAX_PLAYER_GPUS) return ShowNotificationSander(playerid, 2, 6, 0, 0, "У вас максимальное количество видеокарт!", "");
    
    new type = GetHouseData(GetPlayerInHouse(playerid), H_TYPE);
    if(!IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z))) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Вы должны находиться у себя дома для покупки", "");

    ShowGPUStore(playerid);
    return 1;
}

CMD:gpuinv(playerid, params[]) 
{
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    if(houseid == -1) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Для доступа к инвентарю необходим собственный дом!", "");
    if(!GetPlayerMiningRig(playerid)) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
    
    new type = GetHouseData(GetPlayerInHouse(playerid), H_TYPE);
    if(!IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z))) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Вы должны находиться у себя дома для просмотра видеокарт", "");

    ShowGPUInventory(playerid);
    return 1;
}

CMD:gpusell(playerid, params[]) 
{
    new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
    if(houseid == -1) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Для продажи видеокарт необходим собственный дом!", "");
    if(!GetPlayerMiningRig(playerid)) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
    
    new type = GetHouseData(GetPlayerInHouse(playerid), H_TYPE);
    if(!IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z))) return ShowNotificationSander(playerid, 2, 6, 0, 0, "Вы должны находиться у себя дома для продажи", "");

    ShowGPUSellMenu(playerid);
    return 1;
}

CMD:btc(playerid, params[]) 
{
    new btc_amount = GetPlayerEuro(playerid);
    new msg[128];
    format(msg, sizeof(msg), "Ваш баланс Bitcoin: %d", btc_amount);
    ShowNotificationSander(playerid, 1, 6, 0, 0, msg, "");
    return 1;
}

CMD:exchangebtc(playerid, params[]) 
{
    new inExchangeZone = 0;
    for(new i = 0; i < 3; i++)
    {
        if(IsPlayerInDynamicArea(playerid, exchangeAreas[i]))
        {
            inExchangeZone = 1;
            break;
        }
    }
    
    if(!inExchangeZone)
    {
        ShowNotificationSander(playerid, 2, 6, 0, 0, "Для обмена Bitcoin необходимо находиться в зоне обмена в банке!", "");
        return 1;
    }
    
    ShowExchangeDialog(playerid);
    return 1;
}

CMD:btcrate(playerid, params[]) 
{
    new year, month, day;
    getdate(year, month, day);
    new weekday = GetWeekday(year, month, day);
    
    new weekdayNames[7][] = {
        "Воскресенье",
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота"
    };
    
    new formattedRate[32];
    ConvertMining(currentBitcoinRate, formattedRate);
    
    new msg[256];
    format(msg, sizeof(msg), 
        "Курс Bitcoin: {FFFF00}%s руб. за 1 BTC\n{FFFFFF}День недели: {FFFF00}%s\n{FFFFFF}Курс меняется ежедневно!",
        formattedRate, weekdayNames[weekday]);
    
    ShowNotificationSander(playerid, 1, 6, 0, 0, msg, "");
    return 1;
}

CMD:minehelp(playerid, params[]) 
{
    new string[2048];
    format(string, sizeof(string),
        "{FFFFFF}Основные команды:\n" \
        "{FFFF00}/mining {FFFFFF}- Главное меню майнинг-фермы\n" \
        "{FFFF00}/buyrig {FFFFFF}- Купить майнинг-риг (25.000.000 руб.)\n" \
        "{FFFF00}/buygpu {FFFFFF}- Магазин видеокарт\n" \
        "{FFFF00}/gpuinv {FFFFFF}- Инвентарь видеокарт\n" \
        "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту\n\n" \
        "{FFFFFF}Bitcoin операции:\n" \
        "{FFFF00}/btc {FFFFFF}- Проверить баланс Bitcoin\n" \
        "{FFFF00}/btcrate {FFFFFF}- Проверить текущий курс Bitcoin\n" \
        "{FFFF00}/exchangebtc {FFFFFF}- Обменять Bitcoin на рубли\n\n" \
        "{FFFFFF}Курс Bitcoin меняется по дням недели:\n" \
        "{FFFF00}Понедельник: {FFFFFF}900.000 руб.\n" \
        "{FFFF00}Вторник: {FFFFFF}950.000 руб.\n" \
        "{FFFF00}Среда: {FFFFFF}1.000.000 руб.\n" \
        "{FFFF00}Четверг: {FFFFFF}1.050.000 руб.\n" \
        "{FFFF00}Пятница: {FFFFFF}1.100.000 руб.\n" \
        "{FFFF00}Суббота: {FFFFFF}1.200.000 руб.\n" \
        "{FFFF00}Воскресенье: {FFFFFF}1.150.000 руб.\n\n" \
        "{FFFFFF}Обмен Bitcoin:\n" \
        "{FFFFFF}Обменять Bitcoin можно в {FFFF00}любом банке{FFFFFF} в специальных\n" \
        "{FFFFFF}зонах обмена. Подойдите к стойке с надписью\n" \
        "{FFFFFF}'Обменник Bitcoin'\n\n" \
        "{FFFFFF}Доступные видеокарты:\n" \
        "{FFFF00}0. {FFFFFF}GTX 1650 - 0.1 BTC/5min - {FFFF00}5.000.000 руб.\n" \
        "{FFFF00}1. {FFFFFF}RTX 2060 - 0.25 BTC/5min - {FFFF00}7.000.000 руб.\n" \
        "{FFFF00}2. {FFFFFF}RTX 3070 - 0.4 BTC/5min - {FFFF00}12.000.000 руб.\n" \
        "{FFFF00}3. {FFFFFF}RTX 4090 - 0.5 BTC/5min - {FFFF00}15.000.000 руб.\n\n" \
        "{FFFFFF}Майнинг работает автоматически при наличии рига и видеокарт!");

    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Помощь по майнинг-ферме", string, "Закрыть", "");
    return 1;
}