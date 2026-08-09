#define MAX_GPUS 4
#define MAX_PLAYER_GPUS 5
#define RIG_PRICE 25000000

#define OFFER_MINE 19
#define OFFER_GPU 20
#define OFFER_BTC 21
#define DIALOG_GPU_STORE 4453
#define DIALOG_GPU_BUY 4454
#define DIALOG_GPU_SELL 4455
#define DIALOG_GPU_SELL_CONFIRM 4456
#define DIALOG_MINING_MANAGE 4457
#define DIALOG_MINING_ACTIONS 4458
#define DIALOG_MINER_HELP 4459
#define DIALOG_EXCHANGE_MAIN 4460
#define DIALOG_SELL_BTC_PLAYER 4461
#define DIALOG_SELL_GPU_PLAYER 4462
#define DIALOG_SELL_BTC_AMOUNT 4463
#define DIALOG_SELL_GPU_AMOUNT 4464
#define DIALOG_SELL_BTC_CONFIRM 4465
#define DIALOG_SELL_GPU_CONFIRM 4466

new exchangeAreas[3];
new Text3D:exchangeLabels[3];
new miningTimer[MAX_PLAYERS];
new currentBitcoinRate = 1000000;
new playerOfferBTC[MAX_PLAYERS] = {0, ...};
new playerOfferGPU[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new playerOfferGPUType[MAX_PLAYERS] = {-1, ...};
new playerOfferGPUSlot[MAX_PLAYERS] = {-1, ...};
new playerOfferBTCAmount[MAX_PLAYERS] = {0, ...};
new playerOfferBTCPrice[MAX_PLAYERS] = {0, ...};
new playerOfferGPUPrice[MAX_PLAYERS] = {0, ...};
new gpuPickup, gpuExitPickup;

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

    CreateDynamicObject(1797, -498.76, 494.68, 1501.14, 0.00, 0.00, 90.00);
    CreateDynamicObject(1796, -499.42, 494.70, 1501.14, 0.00, 0.00, 90.00);
    
    gpuPickup = CreatePickup(1314, 23, -500.883544,489.373321,1501.040039, -1);
    gpuExitPickup = CreatePickup(1318, 23, -499.042938,494.306365,1501.040039, -1);

    CreateDynamic3DTextLabel("{FFD700}« Магазин электроники »\n{FFFFFF}Торговая точка видеокарт\n\n{BEBEBE}[ Для покупки нажмите ближе ]", 0xFFFFFFFF, -500.883544, 489.373321, 1501.040039 + 0.5, 8.0);

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


public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(pickupid == gpuPickup) callcmd::buygpu(playerid);

    if(pickupid == gpuExitPickup)
    {
        new businessid = GetPlayerInBiz(playerid);
        SetPlayerPosEx
		(
			playerid,
			GetBusinessData(businessid, B_EXIT_POS_X),
			GetBusinessData(businessid, B_EXIT_POS_Y),
			GetBusinessData(businessid, B_EXIT_POS_Z),
			GetBusinessData(businessid, B_EXIT_ANGLE),
            0,
            0,
            false
		);
        SetPlayerInBiz(playerid, -1);
    }

    switch(action_type)
	{
        case PICKUP_ACTION_TYPE_BIZ_ENTER:
		{
            if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_ELECTRINOCS_STORE)
			{
				SetPlayerInBiz(playerid, action_id);

				EntryElectronicsStore(playerid);
				return 1;
			}
        }
    }
    #if defined wermin_OnPlayerPickUpPickupEx
        return wermin_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx wermin_OnPlayerPickUpPickupEx
#if defined wermin_OnPlayerPickUpPickupEx
    forward wermin_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
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
            exchangeCoords[i][2], 1.0);
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
            format(notificationText, sizeof(notificationText), "Обмен биткойнов (Курс: %s руб.)", formattedRate);
                
            ShowNewNotification(playerid, 4, 6, OFFER_MINE, 0, notificationText, ">>");
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

stock EntryElectronicsStore(playerid)
{
    new businessid = GetPlayerInBiz(playerid);
    SetPlayerPosEx(playerid, -499.244018,492.244659,1501.040039,179.718551, 1, businessid +1);
    return 1;
}

stock ShowExchangeMainDialog(playerid)
{
    new formattedRate[32];
    ConvertMining(currentBitcoinRate, formattedRate);
    
    new btc_amount = GetPlayerEuro(playerid);
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}Вы в зоне обмена Bitcoin\n\n" \
        "{FFFFFF}Текущий курс: {FFFF00}%s руб. за 1 BTC\n" \
        "{FFFFFF}Ваш баланс: {FFFF00}%d Bitcoin\n\n" \
        "{FFFFFF}Выберите действие:", 
        formattedRate, btc_amount);
    
    ShowPlayerDialog(playerid, DIALOG_EXCHANGE_MAIN, DIALOG_STYLE_LIST,
        "{FFFF00}Обмен Bitcoin",
        "Купить Bitcoin у системы\nПродать Bitcoin системе\nПродать Bitcoin игроку",
        "Выбрать", "Отмена");
}

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
    
    UpdatePlayerMiningLabel(playerid);
    
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
    UpdatePlayerMiningLabel(playerid);
    
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
    
    UpdatePlayerMiningLabel(playerid);
    
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

stock CreatePlayerMiningLabel(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return;

    if(GetGarageData(garageid, G_MINE_LABEL) != Text3D:INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(Text3D:GetGarageData(garageid, G_MINE_LABEL));
        SetGarageData(garageid, G_MINE_LABEL, _:Text3D:INVALID_3DTEXT_ID);
    }
    new Float:x, Float:y, Float:z;
    new improvements = GetGarageData(garageid, GARAGE_IMPROVEMENTS);
    
    switch(improvements)
    {
        case 1: // Улучшение 1
        {
            x = 2.282214;
            y = 2005.128173;
            z = 1554.243164;
        }
        case 2: // Улучшение 2
        {
            x = 497.475006;
            y = 1982.386230;
            z = 1547.719726;
        }
        default:
        {
            x = 0.0;
            y = 0.0;
            z = 0.0;
            return;
        }
    }
    new miningStatus = GetPlayerMiningStatus(playerid);
    new gpuCount = GetPlayerGPUCount(playerid);
    new hasRig = GetPlayerMiningRig(playerid);
    
    new labelText[256];
    if(hasRig)
    {
        format(labelText, sizeof(labelText),
            "{FFD700}Майнинг-ферма{FFFFFF}\n\
            {FFFFFF}Состояние: %s\n\
            {FFFFFF}Видеокарт: {FFFF00}%d/%d\n\
            {FFFFFF}Хешрейт: {FFFF00}%.2f BTC/5min",
            miningStatus ? "{00FF00}Активна" : "{FF0000}Остановлена",
            gpuCount, MAX_PLAYER_GPUS,
            GetPlayerTotalHashrate(playerid)
        );
    }
    else
    {
        format(labelText, sizeof(labelText),
            "{FFD700}Майнинг-ферма{FFFFFF}\n\
            {FFFFFF}Статус: {FF0000}Нет майнинг-рига\n\
            {FFFFFF}Для начала купите риг {FFFF00}/buyrig"
        );
    }
    new Text3D:label = CreateDynamic3DTextLabel(labelText, 0xFFFF00FF, x, y, z + 0.5, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, garageid + 2000, -1, -1, 50.0);
    
    SetGarageData(garageid, G_MINE_LABEL, _:label);
}

stock UpdatePlayerMiningLabel(playerid)
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return;
    
    new Text3D:label = Text3D:GetGarageData(garageid, G_MINE_LABEL);
    if(label == Text3D:INVALID_3DTEXT_ID) return;
    
    new miningStatus = GetPlayerMiningStatus(playerid);
    new gpuCount = GetPlayerGPUCount(playerid);
    new hasRig = GetPlayerMiningRig(playerid);
    
    new labelText[256];
    if(hasRig)
    {
        format(labelText, sizeof(labelText),
            "{FFD700}Майнинг-ферма{FFFFFF}\n\
            {FFFFFF}Состояние: %s\n\
            {FFFFFF}Видеокарт: {FFFF00}%d/%d\n\
            {FFFFFF}Хешрейт: {FFFF00}%.2f BTC/5min",
            miningStatus ? "{00FF00}Активна" : "{FF0000}Остановлена",
            gpuCount, MAX_PLAYER_GPUS,
            GetPlayerTotalHashrate(playerid)
        );
    }
    else
    {
        format(labelText, sizeof(labelText),
            "{FFD700}Майнинг-ферма{FFFFFF}\n\
            {FFFFFF}Статус: {FF0000}Нет майнинг-рига\n\
            {FFFFFF}Для начала купите риг {FFFF00}/buyrig"
        );
    }
    
    UpdateDynamic3DTextLabelText(label, 0xFFFF00FF, labelText);
}

public OnPlayerDisconnect(playerid, reason) 
{
    StopPlayerMining(playerid);
    playerOfferBTC[playerid] = 0;
    playerOfferGPU[playerid] = INVALID_PLAYER_ID;
    playerOfferGPUType[playerid] = -1;
    playerOfferGPUSlot[playerid] = -1;
    playerOfferBTCAmount[playerid] = 0;
    playerOfferBTCPrice[playerid] = 0;
    playerOfferGPUPrice[playerid] = 0;
    
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
    playerOfferBTC[playerid] = 0;
    playerOfferGPU[playerid] = INVALID_PLAYER_ID;
    playerOfferGPUType[playerid] = -1;
    playerOfferGPUSlot[playerid] = -1;
    playerOfferBTCAmount[playerid] = 0;
    playerOfferBTCPrice[playerid] = 0;
    playerOfferGPUPrice[playerid] = 0;
    
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
    
    CreatePlayerMiningLabel(playerid);
    
    if(GetPlayerGPUCount(playerid) > 0 && GetPlayerMiningRig(playerid))
    {
        if(GetPlayerMiningStatus(playerid))
        {
            StartPlayerMining(playerid);

            if(miningTimer[playerid] == -1)
            {
                miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid); // 5 минут
            }
            ShowNewNotification(playerid, 1, 6, 0, 0, "Майнинг автоматически запущен!", "");
        }
        else ShowNewNotification(playerid, 1, 6, 0, 0, "Для авоматического запуска майнинга активируйте его в гараже!", "");
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
    
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) 
    {
        if(GetPlayerMiningStatus(playerid)) 
        {
            StopPlayerMining(playerid);
            ShowNewNotification(playerid, 2, 6, 0, 0, "Майнинг остановлен - у вас нет гаража!", "");
        }
        return;
    }
    
    if(GetPlayerGPUCount(playerid) == 0) 
    {
        if(GetPlayerMiningStatus(playerid))
        {
            StopPlayerMining(playerid);
            ShowNewNotification(playerid, 2, 6, 0, 0, "Майнинг остановлен - нет видеокарт!", "");
        }
        return;
    }
    
    if(!GetPlayerMiningRig(playerid))
    {
        if(GetPlayerMiningStatus(playerid))
        {
            StopPlayerMining(playerid);
            ShowNewNotification(playerid, 2, 6, 0, 0, "Майнинг остановлен - нет майнинг-рига!", "");
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
        ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
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
        ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
    }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    if(dialogid == 1602) 
    {
        if(!response) 
        {
            ShowExchangeMainDialog(playerid);
            return 1;
        }
        
        if(isnull(inputtext)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Введите количество Bitcoin для обмена!", "");
            ShowExchangeDialog(playerid);
            return 1;
        }
        
        new amount = strval(inputtext);
        
        if(amount < 1) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Минимальная сумма для обмена - 1 Bitcoin!", "");
            ShowExchangeDialog(playerid);
            return 1;
        }
        
        new current_btc = GetPlayerEuro(playerid);
        
        if(current_btc < amount) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У вас недостаточно Bitcoin для обмена!", "");
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
        ShowNewNotification(playerid, 1, 6, 0, 0, success_msg, "");
        
        ShowExchangeMainDialog(playerid);
        return 1;
    }
    else if(dialogid == DIALOG_GPU_STORE) 
    {
        if(!response) return 1;
        
        if(listitem < 0 || listitem >= MAX_GPUS) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Неверный выбор видеокарты!", "");
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
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка выбора видеокарты!", "");
            return 1;
        }
        
        new gpu_id = playerSelectedGPU[playerid];
        playerSelectedGPU[playerid] = -1;
        
        new garageid = GetPlayerGarage(playerid);
        if(garageid == -1) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Для покупки видеокарты необходим собственный гараж!", "");
            return 1;
        }
        
        if(!GetPlayerMiningRig(playerid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
            return 1;
        }
        
        if(GetPlayerGPUCount(playerid) >= MAX_PLAYER_GPUS) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У вас максимальное количество видеокарт!", "");
            return 1;
        }
        
        if(GetPlayerMoney(playerid) < gpuData[gpu_id][gpu_price]) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Недостаточно денег для покупки этой видеокарты!", "");
            return 1;
        }
        
        GivePlayerMoneyEx(playerid, -gpuData[gpu_id][gpu_price]);
        
        new businessid = GetPlayerInBiz(playerid);
        if(businessid != -1 && GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_ELECTRINOCS_STORE)
        {
            new Float:percentFloat = gpuData[gpu_id][gpu_price] * 0.3;
            new percent = floatround(percentFloat, floatround_round);
            new take_prods = random(5) + 6;
            
            AddBusinessData(businessid, B_PRODS, -, take_prods); 
            AddBusinessData(businessid, B_BALANCE, +, percent);
            
            new query[256];
            format(query, sizeof(query), "UPDATE business SET products=%d, balance=%d WHERE id=%d", 
                GetBusinessData(businessid, B_PRODS), 
                GetBusinessData(businessid, B_BALANCE), 
                GetBusinessData(businessid, B_SQL_ID));
            mysql_query(mysql, query, false);
        }
        
        new bool:success = SavePlayerGPU(playerid, gpu_id);
        
        if(success)
        {
            new msg[128];
            format(msg, sizeof(msg), "Вы успешно купили видеокарту %s за %d руб.!", 
                gpuData[gpu_id][gpu_name], gpuData[gpu_id][gpu_price]);
            ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
            
            UpdatePlayerMiningLabel(playerid);
            
            if(GetPlayerGPUCount(playerid) == 1 && !GetPlayerMiningStatus(playerid))
            {
                StartPlayerMining(playerid);

                if(miningTimer[playerid] == -1)
                {
                    miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid); // 5 минут
                }
                
                ShowNewNotification(playerid, 1, 6, 0, 0, "Майнинг автоматически запущен!", "");
            }
        }
        else
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка при покупке видеокарты!", "");
        }
        
        return 1;
    }
    else if(dialogid == DIALOG_GPU_SELL) 
    {
        if(!response) return 1;
        
        if(listitem < 0 || listitem >= GetPlayerGPUCount(playerid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Неверный выбор видеокарты!", "");
            return 1;
        }
        
        playerSelectedGPU[playerid] = listitem;
        
        new gpu_id = GetPlayerGPUType(playerid, listitem);
        if(gpu_id == -1)
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка получения типа видеокарты!", "");
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
            gpuData[gpu_id][gpu_name],
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
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка выбора видеокарты!", "");
            return 1;
        }
        
        new slot = playerSelectedGPU[playerid];
        playerSelectedGPU[playerid] = -1;
        
        if(slot < 0 || slot >= GetPlayerGPUCount(playerid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Неверный ID видеокарты!", "");
            return 1;
        }
        
        new gpu_id = GetPlayerGPUType(playerid, slot);
        if(gpu_id == -1)
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка получения типа видеокарты!", "");
            return 1;
        }
        
        new sell_price = floatround(gpuData[gpu_id][gpu_price] * 0.8);
        
        new bool:success = RemovePlayerGPU(playerid, slot);
        
        if(success)
        {
            GivePlayerMoneyEx(playerid, sell_price);
            new msg[128];
            format(msg, sizeof(msg), "Вы продали видеокарту %s за %d руб. (-20%%)", gpuData[gpu_id][gpu_name], sell_price);
            ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
            
            UpdatePlayerMiningLabel(playerid);
            
            if(GetPlayerGPUCount(playerid) == 0 && GetPlayerMiningStatus(playerid))
            {
                StopPlayerMining(playerid);
                ShowNewNotification(playerid, 2, 6, 0, 0, "Майнинг остановлен - нет видеокарт!", "");
            }
        }
        else
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка при продаже видеокарты!", "");
        }
        
        return 1;
    }
    else if(dialogid == 4452)
    {
        if(!response)
        {
            ShowMiningManagementDialog(playerid);
        }
        else
        {
            ShowMiningActionsDialog(playerid);
        }
        return 1;
    }
    else if(dialogid == DIALOG_MINING_MANAGE)
    {
        if(!response) 
        {
            ShowMiningMenu(playerid);
            return 1;
        }
        
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
                    ShowNewNotification(playerid, 1, 6, 0, 0, "Майнинг остановлен!", "");
                    
                    ShowMiningManagementDialog(playerid);
                }
                else
                {
                    // Включить майнинг
                    new garageid = GetPlayerGarage(playerid);
                    if(garageid == -1) 
                    {
                        ShowNewNotification(playerid, 2, 6, 0, 0, "Для майнинга необходим собственный гараж!", "");
                        ShowMiningManagementDialog(playerid);
                        return 1;
                    }
                    
                    if(GetPlayerGPUCount(playerid) == 0) 
                    {
                        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет видеокарт для майнинга!", "");
                        ShowMiningManagementDialog(playerid);
                        return 1;
                    }
                    
                    if(!GetPlayerMiningRig(playerid))
                    {
                        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет майнинг-рига!", "");
                        ShowMiningManagementDialog(playerid);
                        return 1;
                    }
                    
                    StartPlayerMining(playerid);
                    
                    if(miningTimer[playerid] == -1)
                    {
                        miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid); // 5 минут
                    }
                    
                    ShowNewNotification(playerid, 1, 6, 0, 0, "Майнинг запущен!", "");
                    
                    ShowMiningManagementDialog(playerid);
                }
            }
            case 2: // Продать Bitcoin игроку
            {
                ShowSellBTCToPlayerDialog(playerid);
            }
        }
        return 1;
    }
    else if(dialogid == DIALOG_MINING_ACTIONS)
    {
        if(!response) 
        {
            ShowMiningMenu(playerid);
            return 1;
        }
        
        switch(listitem)
        {
            case 0: // Магазин видеокарт
            {
                new garageid = GetPlayerGarage(playerid);
                if(garageid == -1) 
                {
                    ShowNewNotification(playerid, 2, 6, 0, 0, "Для покупки видеокарт необходим собственный гараж!", "");
                    ShowMiningActionsDialog(playerid);
                    return 1;
                }
                
                if(!GetPlayerMiningRig(playerid)) 
                {
                    ShowNewNotification(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
                    ShowMiningActionsDialog(playerid);
                    return 1;
                }
                
                if(GetPlayerGPUCount(playerid) >= MAX_PLAYER_GPUS) 
                {
                    ShowNewNotification(playerid, 2, 6, 0, 0, "У вас максимальное количество видеокарт!", "");
                    ShowMiningActionsDialog(playerid);
                    return 1;
                }
                
                ShowGPUStore(playerid);
            }
            case 1: // Инвентарь видеокарт
            {
                ShowGPUInventory(playerid);
            }
            case 2: // Продать видеокарту
            {
                ShowGPUSellMenu(playerid);
            }
            case 3: // Проверить баланс Bitcoin
            {
                new btc_amount = GetPlayerEuro(playerid);
                new msg[128];
                format(msg, sizeof(msg), "Ваш баланс Bitcoin: %d", btc_amount);
                ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
                ShowMiningActionsDialog(playerid);
            }
            case 4: // Проверить курс Bitcoin
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
                
                ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
                ShowMiningActionsDialog(playerid);
            }
            case 5: // Помощь по майнингу
            {
                ShowMinerHelpDialog(playerid);
            }
        }
        return 1;
    }
    else if(dialogid == DIALOG_MINER_HELP)
    {
        ShowMiningActionsDialog(playerid);
        return 1;
    }
    else if(dialogid == DIALOG_EXCHANGE_MAIN)
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: // Купить Bitcoin у системы
            {
                // Покупка Bitcoin у системы (пока не реализовано)
                ShowNewNotification(playerid, 1, 6, 0, 0, "Функция покупки Bitcoin у системы в разработке!", "");
                ShowExchangeMainDialog(playerid);
            }
            case 1: // Продать Bitcoin системе
            {
                ShowExchangeDialog(playerid);
            }
            case 2: // Продать Bitcoin игроку
            {
                ShowSellBTCToPlayerDialog(playerid);
            }
        }
        return 1;
    }
    else if(dialogid == DIALOG_SELL_BTC_PLAYER)
    {
        if(!response) 
        {
            ShowExchangeMainDialog(playerid);
            return 1;
        }
        
        if(isnull(inputtext)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Введите ID игрока!", "");
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        
        new targetid = strval(inputtext);
        
        if(!IsPlayerConnected(targetid) || targetid == playerid) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Неверный ID игрока!", "");
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        
        playerOfferBTC[playerid] = targetid;
        
        new string[256];
        format(string, sizeof(string),
            "{FFFFFF}Игрок: {FFFF00}%s (ID: %d)\n\n" \
            "{FFFFFF}Введите количество Bitcoin для продажи (мин. 1):",
            GetPlayerNameEx(targetid), targetid);
        
        ShowPlayerDialog(playerid, DIALOG_SELL_BTC_AMOUNT, DIALOG_STYLE_INPUT,
            "{FFFF00}Продажа Bitcoin игроку",
            string,
            "Далее", "Назад");
        
        return 1;
    }
    else if(dialogid == DIALOG_SELL_BTC_AMOUNT)
    {
        if(!response) 
        {
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        
        if(isnull(inputtext)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Введите количество Bitcoin!", "");
            ShowPlayerDialog(playerid, DIALOG_SELL_BTC_AMOUNT, DIALOG_STYLE_INPUT,
                "{FFFF00}Продажа Bitcoin игроку",
                "Введите количество Bitcoin для продажи (мин. 1):",
                "Далее", "Назад");
            return 1;
        }
        
        new amount = strval(inputtext);
        
        if(amount < 1) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Минимальная сумма - 1 Bitcoin!", "");
            ShowPlayerDialog(playerid, DIALOG_SELL_BTC_AMOUNT, DIALOG_STYLE_INPUT,
                "{FFFF00}Продажа Bitcoin игроку",
                "Введите количество Bitcoin для продажи (мин. 1):",
                "Далее", "Назад");
            return 1;
        }
        
        new current_btc = GetPlayerEuro(playerid);
        
        if(current_btc < amount) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У вас недостаточно Bitcoin!", "");
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        
        new targetid = playerOfferBTC[playerid];
        
        if(!IsPlayerConnected(targetid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Игрок вышел из игры!", "");
            playerOfferBTC[playerid] = 0;
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        
        new price_per_btc = floatround(currentBitcoinRate * 0.9); // 10% дешевле рыночной цены
        new total_price = amount * price_per_btc;
        
        playerOfferBTCAmount[playerid] = amount;
        playerOfferBTCPrice[playerid] = total_price;
        
        new formattedRate[32], formattedPrice[32];
        ConvertMining(price_per_btc, formattedRate);
        ConvertMining(total_price, formattedPrice);
        
        new string[512];
        format(string, sizeof(string),
            "{FFFFFF}Игрок: {FFFF00}%s (ID: %d)\n\n" \
            "{FFFFFF}Количество Bitcoin: {FFFF00}%d\n" \
            "{FFFFFF}Цена за 1 BTC: {FFFF00}%s руб. (-10%%)\n" \
            "{FFFFFF}Общая стоимость: {FFFF00}%s руб.\n\n" \
            "{FFFFFF}Подтвердите отправку предложения:",
            GetPlayerNameEx(targetid), targetid,
            amount, formattedRate, formattedPrice);
        
        ShowPlayerDialog(playerid, DIALOG_SELL_BTC_CONFIRM, DIALOG_STYLE_MSGBOX,
            "{FFFF00}Подтверждение продажи Bitcoin",
            string,
            "Отправить", "Отмена");
        
        return 1;
    }
    else if(dialogid == DIALOG_SELL_BTC_CONFIRM)
    {
        if(!response) 
        {
            playerOfferBTC[playerid] = 0;
            playerOfferBTCAmount[playerid] = 0;
            playerOfferBTCPrice[playerid] = 0;
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        
        new targetid = playerOfferBTC[playerid];
        new amount = playerOfferBTCAmount[playerid];
        new total_price = playerOfferBTCPrice[playerid];
        
        if(!IsPlayerConnected(targetid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Игрок вышел из игры!", "");
            playerOfferBTC[playerid] = 0;
            playerOfferBTCAmount[playerid] = 0;
            playerOfferBTCPrice[playerid] = 0;
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        new current_btc = GetPlayerEuro(playerid);
        if(current_btc < amount) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У вас недостаточно Bitcoin!", "");
            playerOfferBTC[playerid] = 0;
            playerOfferBTCAmount[playerid] = 0;
            playerOfferBTCPrice[playerid] = 0;
            ShowSellBTCToPlayerDialog(playerid);
            return 1;
        }
        new formattedPrice[32];
        ConvertMining(total_price, formattedPrice);

        SendClientMessage(targetid, COLOR_WHITE, "Игрок {FFFF00}%s {FFFFFF}предлагает вам купить {FFFF00}%d Bitcoin{FFFFFF} за {FFFF00}%s руб.", GetPlayerNameEx(playerid), amount, formattedPrice);
        SendClientMessage(targetid, COLOR_WHITE, "Используйте {FFFF00}/acceptbtc {FFFFFF}или {FFFF00}кнопку на увегаражлении {FFFFFF}чтобы принять предложение");
        
        ShowNewNotification(targetid, 4, 6, OFFER_BTC, 0, "Принять предложение", ">>");
        
        new sellerMsg[128];
        format(sellerMsg, sizeof(sellerMsg), "Вы предложили игроку %s купить %d Bitcoin за %s руб.", 
            GetPlayerNameEx(targetid), amount, formattedPrice);
        ShowNewNotification(playerid, 1, 6, 0, 0, sellerMsg, "");
        
        playerOfferBTC[targetid] = playerid;
        playerOfferBTCAmount[targetid] = amount;
        playerOfferBTCPrice[targetid] = total_price;
        
        playerOfferBTC[playerid] = 0;
        playerOfferBTCAmount[playerid] = 0;
        playerOfferBTCPrice[playerid] = 0;
        
        ShowExchangeMainDialog(playerid);
        return 1;
    }
    else if(dialogid == DIALOG_SELL_GPU_PLAYER)
    {
        if(!response) 
        {
            ShowGPUInventory(playerid);
            return 1;
        }
        
        if(isnull(inputtext)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Введите ID игрока!", "");
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        new targetid = strval(inputtext);
        
        if(!IsPlayerConnected(targetid) || targetid == playerid) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Неверный ID игрока!", "");
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        if(GetPlayerGPUCount(targetid) >= MAX_PLAYER_GPUS) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У игрока максимальное количество видеокарт!", "");
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        playerOfferGPU[playerid] = targetid;
        
        new string[512];
        format(string, sizeof(string),
            "{FFFFFF}Игрок: {FFFF00}%s (ID: %d)\n\n" \
            "{FFFFFF}Выберите видеокарту для продажи:",
            GetPlayerNameEx(targetid), targetid);

        new gpu_count = GetPlayerGPUCount(playerid);
        if(gpu_count == 0)
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет видеокарт для продажи!", "");
            ShowGPUInventory(playerid);
            return 1;
        }
        
        new list_mine[1024];
        format(list_mine, sizeof(list_mine), "");
        
        new account_id = GetPlayerAccountID(playerid);
        new query[256];
        format(query, sizeof(query), "SELECT gpu_type FROM player_gpus WHERE player_id = %d ORDER BY id", account_id);
        new Cache:result = mysql_query(mysql, query);
        
        new rows = cache_num_rows();
        for(new i = 0; i < rows; i++) 
        {
            new gpu_type = cache_get_field_content_int(i, "gpu_type");
            
            new line_mineGPU[128];
            format(line_mineGPU, sizeof(line_mineGPU), "%d. %s (%.2f BTC/5min)\n", i, gpuData[gpu_type][gpu_name], gpuData[gpu_type][gpu_hashrate]);
            strcat(list_mine, line_mineGPU);
        }
        
        cache_delete(result);
        
        ShowPlayerDialog(playerid, DIALOG_SELL_GPU_AMOUNT, DIALOG_STYLE_LIST,
            "{FFFF00}Выбор видеокарты для продажи",
            list_mine,
            "Выбрать", "Назад");
        
        return 1;
    }
    else if(dialogid == DIALOG_SELL_GPU_AMOUNT)
    {
        if(!response) 
        {
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        if(listitem < 0 || listitem >= GetPlayerGPUCount(playerid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Неверный выбор видеокарты!", "");
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        playerOfferGPUSlot[playerid] = listitem;
        
        new gpu_id = GetPlayerGPUType(playerid, listitem);
        if(gpu_id == -1)
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка получения типа видеокарты!", "");
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        playerOfferGPUType[playerid] = gpu_id;
        
        new string[512];
        format(string, sizeof(string),
            "{FFFFFF}Вы выбрали: {FFFF00}%s\n\n" \
            "{FFFFFF}Хешрейт: {FFFF00}%.2f BTC/5min\n" \
            "{FFFFFF}Цена покупки: {FFFF00}%d руб.\n\n" \
            "{FFFFFF}Введите цену продажи игроку (мин. 1.000.000 руб.):",
            gpuData[gpu_id][gpu_name],
            gpuData[gpu_id][gpu_hashrate],
            gpuData[gpu_id][gpu_price]);
        
        ShowPlayerDialog(playerid, DIALOG_SELL_GPU_CONFIRM, DIALOG_STYLE_INPUT,
            "{FFFF00}Цена продажи видеокарты",
            string,
            "Далее", "Назад");
        
        return 1;
    }
    else if(dialogid == DIALOG_SELL_GPU_CONFIRM)
    {
        if(!response) 
        {
            playerOfferGPU[playerid] = INVALID_PLAYER_ID;
            playerOfferGPUType[playerid] = -1;
            playerOfferGPUSlot[playerid] = -1;
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        if(isnull(inputtext)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Введите цену продажи!", "");
            ShowPlayerDialog(playerid, DIALOG_SELL_GPU_CONFIRM, DIALOG_STYLE_INPUT,
                "{FFFF00}Цена продажи видеокарты",
                "Введите цену продажи игроку (мин. 1.000.000 руб.):",
                "Далее", "Назад");
            return 1;
        }
        
        new price = strval(inputtext);
        
        if(price < 1000000) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Минимальная цена - 1.000.000 руб.!", "");
            ShowPlayerDialog(playerid, DIALOG_SELL_GPU_CONFIRM, DIALOG_STYLE_INPUT,
                "{FFFF00}Цена продажи видеокарты",
                "Введите цену продажи игроку (мин. 1.000.000 руб.):",
                "Далее", "Назад");
            return 1;
        }
        
        new targetid = playerOfferGPU[playerid];
        new gpu_id = playerOfferGPUType[playerid];
        new slot = playerOfferGPUSlot[playerid];
        
        if(!IsPlayerConnected(targetid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Игрок вышел из игры!", "");
            playerOfferGPU[playerid] = INVALID_PLAYER_ID;
            playerOfferGPUType[playerid] = -1;
            playerOfferGPUSlot[playerid] = -1;
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        if(slot >= GetPlayerGPUCount(playerid)) 
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Эта видеокарта уже продана!", "");
            playerOfferGPU[playerid] = INVALID_PLAYER_ID;
            playerOfferGPUType[playerid] = -1;
            playerOfferGPUSlot[playerid] = -1;
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        new current_gpu_id = GetPlayerGPUType(playerid, slot);
        if(current_gpu_id != gpu_id)
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "Инвентарь видеокарт изменился!", "");
            playerOfferGPU[playerid] = INVALID_PLAYER_ID;
            playerOfferGPUType[playerid] = -1;
            playerOfferGPUSlot[playerid] = -1;
            ShowSellGPUToPlayerDialog(playerid);
            return 1;
        }
        
        playerOfferGPUPrice[playerid] = price;
        
        new formattedPrice[32];
        ConvertMining(price, formattedPrice);
        
        SendClientMessage(targetid, COLOR_WHITE, "Игрок {FFFF00}%s {FFFFFF}предлагает вам купить видеокарту:", GetPlayerNameEx(playerid));
        SendClientMessage(targetid, COLOR_WHITE, "{FFFF00}%s {FFFFFF}(%.2f BTC/5min) за {FFFF00}%s руб.", gpuData[gpu_id][gpu_name], gpuData[gpu_id][gpu_hashrate], formattedPrice);
        SendClientMessage(targetid, COLOR_WHITE, "Используйте {FFFF00}/acceptgpu {FFFFFF}или {FFFF00}кнопку на увегаражлении {FFFFFF}чтобы принять предложение");
        
        ShowNewNotification(targetid, 4, 6, OFFER_GPU, 0, "Принять предложение", ">>");
        
        new sellerMsg[128];
        format(sellerMsg, sizeof(sellerMsg), "Вы предложили игроку %s купить видеокарту %s за %s руб.", 
            GetPlayerNameEx(targetid), gpuData[gpu_id][gpu_name], formattedPrice);
        ShowNewNotification(playerid, 1, 6, 0, 0, sellerMsg, "");
        
        playerOfferGPU[targetid] = playerid;
        playerOfferGPUType[targetid] = gpu_id;
        playerOfferGPUSlot[targetid] = slot;
        playerOfferGPUPrice[targetid] = price;
        
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        
        ShowGPUInventory(playerid);
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
    strcat(string, "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту системе\n");
    strcat(string, "{FFFF00}/sellgpuplayer {FFFFFF}- Продать видеокарту игроку\n\n");
    strcat(string, "{FFFFFF}Майнинг работает автоматически при наличии рига и видеокарт!");
    
    ShowPlayerDialog(playerid, 1603, DIALOG_STYLE_MSGBOX, "{FFFF00}Инвентарь видеокарт", string, "Закрыть", "");
}

stock ShowGPUSellMenu(playerid)
{
    new gpu_count = GetPlayerGPUCount(playerid);
    if(gpu_count == 0)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет видеокарт для продажи!", "");
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
    new garageid = GetPlayerGarage(playerid);
    
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
        "{FFFFFF}В гараже: {FFFF00}%s\n" \
        "{FFFFFF}Накоплено Bitcoin: {FFFF00}%.2f\n\n" \
        "{FFFFFF}Текущий курс Bitcoin:\n" \
        "{FFFF00}%s руб. за 1 BTC\n" \
        "{FFFFFF}День недели: {FFFF00}%s\n\n" \
        "{FFFFFF}Доступные команды:\n" \
        "{FFFF00}/buyrig {FFFFFF}- Купить майнинг-риг (25.000.000 руб.)\n" \
        "{FFFF00}/buygpu {FFFFFF}- Магазин видеокарт\n" \
        "{FFFF00}/gpuinv {FFFFFF}- Инвентарь видеокарт\n" \
        "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту системе\n" \
        "{FFFF00}/sellgpuplayer {FFFFFF}- Продать видеокарту игроку\n" \
        "{FFFF00}/btc {FFFFFF}- Проверить баланс Bitcoin\n" \
        "{FFFF00}/exchangebtc {FFFFFF}- Обменять Bitcoin",
        GetPlayerMiningRig(playerid) ? "Есть" : "Нет",
        GetPlayerGPUCount(playerid),
        MAX_PLAYER_GPUS,
        total_hashrate,
        GetPlayerMiningStatus(playerid) ? "Активен" : "Остановлен",
        garageid > -1 ? "Да" : "Нет",
        accumulated_btc,
        formattedRate,
        weekdayNames[weekday]
    );
    
    ShowPlayerDialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "{FFFF00}Майнинг-ферма", string, "Управление", "Действия");
}

stock ShowMiningManagementDialog(playerid)
{
    new miningStatus = GetPlayerMiningStatus(playerid);
    new statusText[32];
    format(statusText, sizeof(statusText), miningStatus ? "Выключить майнинг" : "Включить майнинг");

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
        "2. %s\n" \
        "3. Продать Bitcoin игроку\n\n" \
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

stock ShowMiningActionsDialog(playerid)
{
    new string[512];
    format(string, sizeof(string),
        "1. Магазин видеокарт\n" \
        "2. Инвентарь видеокарт\n" \
        "3. Продать видеокарту системе\n" \
        "4. Проверить баланс Bitcoin\n" \
        "5. Проверить курс Bitcoin\n" \
        "6. Помощь по майнингу");
    
    ShowPlayerDialog(playerid, DIALOG_MINING_ACTIONS, DIALOG_STYLE_LIST, 
        "{FFFF00}Действия с майнинг-фермой", 
        string, 
        "Выбрать", "Назад");
}

stock ShowMinerHelpDialog(playerid)
{
    new string[2048];
    format(string, sizeof(string),
        "{FFFFFF}Основные команды:\n" \
        "{FFFF00}/mining {FFFFFF}- Главное меню майнинг-фермы\n" \
        "{FFFF00}/buyrig {FFFFFF}- Купить майнинг-риг (25.000.000 руб.)\n" \
        "{FFFF00}/buygpu {FFFFFF}- Магазин видеокарт\n" \
        "{FFFF00}/gpuinv {FFFFFF}- Инвентарь видеокарт\n" \
        "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту системе\n" \
        "{FFFF00}/sellgpuplayer {FFFFFF}- Продать видеокарту игроку\n\n" \
        "{FFFFFF}Bitcoin операции:\n" \
        "{FFFF00}/btc {FFFFFF}- Проверить баланс Bitcoin\n" \
        "{FFFF00}/btcrate {FFFFFF}- Проверить текущий курс Bitcoin\n" \
        "{FFFF00}/exchangebtc {FFFFFF}- Обменять Bitcoin на рубли\n" \
        "{FFFF00}/sellbtcplayer {FFFFFF}- Продать Bitcoin игроку\n\n" \
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
        "{FFFFFF}Максимальное количество видеокарт: {FFFF00}5\n\n" \
        "{FFFFFF}Майнинг работает автоматически при наличии рига и видеокарт!");
    
    ShowPlayerDialog(playerid, DIALOG_MINER_HELP, DIALOG_STYLE_MSGBOX, "Помощь по майнинг-ферме", string, "Назад", "");
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

stock ShowSellBTCToPlayerDialog(playerid)
{
    new string[256];
    format(string, sizeof(string),
        "{FFFFFF}Введите ID игрока, которому хотите продать Bitcoin:\n\n" \
        "{FFFFFF}Ваш баланс Bitcoin: {FFFF00}%d\n" \
        "{FFFFFF}Текущий курс: {FFFF00}1 BTC = %d руб.\n\n" \
        "{FFFFFF}При продаже игроку цена будет на 10%% ниже рыночной.",
        GetPlayerEuro(playerid), currentBitcoinRate);
    
    ShowPlayerDialog(playerid, DIALOG_SELL_BTC_PLAYER, DIALOG_STYLE_INPUT,
        "{FFFF00}Продажа Bitcoin игроку",
        string,
        "Далее", "Отмена");
}

stock ShowSellGPUToPlayerDialog(playerid)
{
    new string[256];
    format(string, sizeof(string),
        "{FFFFFF}Введите ID игрока, которому хотите продать видеокарту:\n\n" \
        "{FFFFFF}Ваше количество видеокарт: {FFFF00}%d/%d\n" \
        "{FFFFFF}Минимальная цена продажи: {FFFF00}1.000.000 руб.",
        GetPlayerGPUCount(playerid), MAX_PLAYER_GPUS);
    
    ShowPlayerDialog(playerid, DIALOG_SELL_GPU_PLAYER, DIALOG_STYLE_INPUT,
        "{FFFF00}Продажа видеокарты игроку",
        string,
        "Далее", "Отмена");
}

CMD:acceptbtc(playerid, params[])
{
    new sellerid = playerOfferBTC[playerid];
    
    if(sellerid == 0 || !IsPlayerConnected(sellerid))
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет активных предложений о покупке Bitcoin!", "");
        return 1;
    }
    
    new amount = playerOfferBTCAmount[playerid];
    new total_price = playerOfferBTCPrice[playerid];
    
    if(amount == 0 || total_price == 0)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка получения данных предложения!", "");
        playerOfferBTC[playerid] = 0;
        playerOfferBTCAmount[playerid] = 0;
        playerOfferBTCPrice[playerid] = 0;
        return 1;
    }
    
    if(GetPlayerMoney(playerid) < total_price)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас недостаточно денег для покупки!", "");
        return 1;
    }
    
    new seller_btc = GetPlayerEuro(sellerid);
    if(seller_btc < amount)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У продавца недостаточно Bitcoin!", "");
        ShowNewNotification(sellerid, 2, 6, 0, 0, "У вас недостаточно Bitcoin для завершения сделки!", "");
        playerOfferBTC[playerid] = 0;
        playerOfferBTCAmount[playerid] = 0;
        playerOfferBTCPrice[playerid] = 0;
        return 1;
    }
    
    if(!IsPlayerConnected(sellerid))
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Продавец вышел из игры!", "");
        playerOfferBTC[playerid] = 0;
        playerOfferBTCAmount[playerid] = 0;
        playerOfferBTCPrice[playerid] = 0;
        return 1;
    }
    
    GivePlayerMoneyEx(playerid, -total_price);
    GivePlayerMoneyEx(sellerid, total_price);
    
    SetPlayerEuro(sellerid, seller_btc - amount);
    new buyer_btc = GetPlayerEuro(playerid);
    SetPlayerEuro(playerid, buyer_btc + amount);
    
    new formattedPrice[32];
    ConvertMining(total_price, formattedPrice);
    
    new buyerMsg[256], sellerMsg[256];
    format(buyerMsg, sizeof(buyerMsg), "Вы купили {FFFF00}%d Bitcoin{FFFFFF} у игрока {FFFF00}%s{FFFFFF} за {FFFF00}%s руб.", 
        amount, GetPlayerNameEx(sellerid), formattedPrice);
    format(sellerMsg, sizeof(sellerMsg), "Игрок {FFFF00}%s{FFFFFF} купил у вас {FFFF00}%d Bitcoin{FFFFFF} за {FFFF00}%s руб.", 
        GetPlayerNameEx(playerid), amount, formattedPrice);
    
    SendClientMessage(playerid, COLOR_WHITE, buyerMsg);
    SendClientMessage(sellerid, COLOR_WHITE, sellerMsg);
    
    playerOfferBTC[playerid] = 0;
    playerOfferBTCAmount[playerid] = 0;
    playerOfferBTCPrice[playerid] = 0;
    
    playerOfferBTC[sellerid] = 0;
    playerOfferBTCAmount[sellerid] = 0;
    playerOfferBTCPrice[sellerid] = 0;
    
    return 1;
}

CMD:acceptgpu(playerid, params[])
{
    new sellerid = playerOfferGPU[playerid];
    
    if(sellerid == INVALID_PLAYER_ID || !IsPlayerConnected(sellerid))
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет активных предложений о покупке видеокарты!", "");
        return 1;
    }
    
    new gpu_id = playerOfferGPUType[playerid];
    new slot = playerOfferGPUSlot[playerid];
    new price = playerOfferGPUPrice[playerid];
    
    if(gpu_id == -1 || slot == -1 || price == 0)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка получения данных предложения!", "");
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    
    if(GetPlayerMoney(playerid) < price)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас недостаточно денег для покупки!", "");
        return 1;
    }
    
    if(GetPlayerGPUCount(playerid) >= MAX_PLAYER_GPUS)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас максимальное количество видеокарт!", "");
        ShowNewNotification(sellerid, 2, 6, 0, 0, "У покупателя максимальное количество видеокарт!", "");
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    
    if(!IsPlayerConnected(sellerid))
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Продавец вышел из игры!", "");
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    
    if(slot >= GetPlayerGPUCount(sellerid))
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Эта видеокарта уже продана!", "");
        ShowNewNotification(sellerid, 2, 6, 0, 0, "Эта видеокарта уже продана!", "");
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    
    new current_gpu_id = GetPlayerGPUType(sellerid, slot);
    if(current_gpu_id != gpu_id)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Инвентарь видеокарт продавца изменился!", "");
        ShowNewNotification(sellerid, 2, 6, 0, 0, "Инвентарь видеокарт изменился!", "");
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    GivePlayerMoneyEx(playerid, -price);
    GivePlayerMoneyEx(sellerid, price);
    
    new bool:success = RemovePlayerGPU(sellerid, slot);
    
    if(!success)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка при продаже видеокарты!", "");
        ShowNewNotification(sellerid, 2, 6, 0, 0, "Ошибка при продаже видеокарты!", "");
        
        GivePlayerMoneyEx(playerid, price);
        GivePlayerMoneyEx(sellerid, -price);
        
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    
    success = SavePlayerGPU(playerid, gpu_id);
    
    if(!success)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Ошибка при получении видеокарты!", "");
        ShowNewNotification(sellerid, 2, 6, 0, 0, "Ошибка при передаче видеокарты!", "");
        
        GivePlayerMoneyEx(playerid, price);
        GivePlayerMoneyEx(sellerid, -price);
        
        playerOfferGPU[playerid] = INVALID_PLAYER_ID;
        playerOfferGPUType[playerid] = -1;
        playerOfferGPUSlot[playerid] = -1;
        playerOfferGPUPrice[playerid] = 0;
        return 1;
    }
    
    new formattedPrice[32];
    ConvertMining(price, formattedPrice);
    
    new buyerMsg[256], sellerMsg[256];
    format(buyerMsg, sizeof(buyerMsg), "Вы купили видеокарту {FFFF00}%s{FFFFFF} у игрока {FFFF00}%s{FFFFFF} за {FFFF00}%s руб.", 
        gpuData[gpu_id][gpu_name], GetPlayerNameEx(sellerid), formattedPrice);
    format(sellerMsg, sizeof(sellerMsg), "Игрок {FFFF00}%s{FFFFFF} купил у вас видеокарту {FFFF00}%s{FFFFFF} за {FFFF00}%s руб.", 
        GetPlayerNameEx(playerid), gpuData[gpu_id][gpu_name], formattedPrice);
    
    SendClientMessage(playerid, COLOR_WHITE, buyerMsg);
    SendClientMessage(sellerid, COLOR_WHITE, sellerMsg);
    
    playerOfferGPU[playerid] = INVALID_PLAYER_ID;
    playerOfferGPUType[playerid] = -1;
    playerOfferGPUSlot[playerid] = -1;
    playerOfferGPUPrice[playerid] = 0;
    
    playerOfferGPU[sellerid] = INVALID_PLAYER_ID;
    playerOfferGPUType[sellerid] = -1;
    playerOfferGPUSlot[sellerid] = -1;
    playerOfferGPUPrice[sellerid] = 0;
    
    if(GetPlayerGPUCount(sellerid) == 0 && GetPlayerMiningStatus(sellerid))
    {
        StopPlayerMining(sellerid);
        ShowNewNotification(sellerid, 2, 6, 0, 0, "Майнинг остановлен - нет видеокарт!", "");
    }
    UpdatePlayerMiningLabel(playerid);
    UpdatePlayerMiningLabel(sellerid);
    
    return 1;
}

CMD:mining(playerid, params[]) 
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return ShowNewNotification(playerid, 2, 6, 0, 0, "Для майнинга необходим собственный гараж!", "");

    if(GetPlayerInGarage(playerid) == -1)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Вы должны находиться у себя в гараже для просмотра статистики. Используйте /btc чтобы проверить свой баланс Bitcoin", "");
        return 1;
    }

    ShowMiningMenu(playerid);
    return 1;
}

CMD:buyrig(playerid, params[]) 
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return ShowNewNotification(playerid, 2, 6, 0, 0, "Для установки рига необходим собственный гараж!", "");
    if(GetPlayerMiningRig(playerid)) return ShowNewNotification(playerid, 2, 6, 0, 0, "У вас уже есть майнинг-риг!", "");
    if(GetPlayerMoney(playerid) < RIG_PRICE) return ShowNewNotification(playerid, 2, 6, 0, 0, "Недостаточно денег для покупки рига!", "");

    if(GetPlayerInGarage(playerid) == -1)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Вы должны находиться у себя в гараже для покупки", "");
        return 1;
    }

    GivePlayerMoneyEx(playerid, -RIG_PRICE);
    SetPlayerMiningRig(playerid, 1);
    ShowNewNotification(playerid, 1, 6, 0, 0, "Вы успешно купили майнинг-риг!", "");
    
    UpdatePlayerMiningLabel(playerid);
    
    if(GetPlayerGPUCount(playerid) > 0 && !GetPlayerMiningStatus(playerid))
    {
        StartPlayerMining(playerid);
        
        if(miningTimer[playerid] == -1)
        {
            miningTimer[playerid] = SetTimerEx("OnMiningTimer", 300000, true, "i", playerid); // 5 минут
        }
        
        ShowNewNotification(playerid, 1, 6, 0, 0, "Майнинг автоматически запущен!", "");
    }
    
    return 1;
}

CMD:buygpu(playerid, params[]) 
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, -500.883544,489.373321,1501.040039))
    {
        new garageid = GetPlayerGarage(playerid);
        if(garageid == -1) return ShowNewNotification(playerid, 2, 6, 0, 0, "Для майнинга необходим собственный гараж!", "");
        if(!GetPlayerMiningRig(playerid)) return ShowNewNotification(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
        if(GetPlayerGPUCount(playerid) >= MAX_PLAYER_GPUS) return ShowNewNotification(playerid, 2, 6, 0, 0, "У вас максимальное количество видеокарт!", "");

        ShowGPUStore(playerid);
    }
    else ShowNewNotification(playerid, 2, 6, 0, 0, "Для покупки видеокарт необходимо находиться у стойки в магазине электроники!", "");
    return 1;
}

CMD:gpuinv(playerid, params[]) 
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return ShowNewNotification(playerid, 2, 6, 0, 0, "Для доступа к инвентарю необходим собственный гараж!", "");
    if(!GetPlayerMiningRig(playerid)) return ShowNewNotification(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
    
    if(GetPlayerInGarage(playerid) == -1)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Вы должны находиться у себя в гараже для просмотра видеокарт", "");
        return 1;
    }

    ShowGPUInventory(playerid);
    return 1;
}

CMD:gpusell(playerid, params[]) 
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return ShowNewNotification(playerid, 2, 6, 0, 0, "Для продажи видеокарт необходим собственный гараж!", "");
    if(!GetPlayerMiningRig(playerid)) return ShowNewNotification(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");

    if(GetPlayerInGarage(playerid) == -1)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Вы должны находиться у себя в гараже для продажи", "");
        return 1;
    }
    ShowGPUSellMenu(playerid);
    return 1;
}

CMD:sellgpuplayer(playerid, params[]) 
{
    new garageid = GetPlayerGarage(playerid);
    if(garageid == -1) return ShowNewNotification(playerid, 2, 6, 0, 0, "Для продажи видеокарт необходим собственный гараж!", "");
    if(!GetPlayerMiningRig(playerid)) return ShowNewNotification(playerid, 2, 6, 0, 0, "Сначала купите майнинг-риг!", "");
    
    if(GetPlayerInGarage(playerid) == -1)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "Вы должны находиться у себя в гараже для продажи", "");
        return 1;
    }

    ShowSellGPUToPlayerDialog(playerid);
    return 1;
}

CMD:sellbtcplayer(playerid, params[]) 
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
        ShowNewNotification(playerid, 2, 6, 0, 0, "Для продажи Bitcoin игроку необходимо находиться в зоне обмена в банке!", "");
        return 1;
    }
    
    ShowSellBTCToPlayerDialog(playerid);
    return 1;
}

CMD:btc(playerid, params[]) 
{
    new btc_amount = GetPlayerEuro(playerid);
    new msg[128];
    format(msg, sizeof(msg), "Ваш баланс Bitcoin: %d", btc_amount);
    ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
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
        ShowNewNotification(playerid, 2, 6, 0, 0, "Для обмена Bitcoin необходимо находиться в зоне обмена в банке!", "");
        return 1;
    }
    
    ShowExchangeMainDialog(playerid);
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
    
    ShowNewNotification(playerid, 1, 6, 0, 0, msg, "");
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
        "{FFFF00}/gpusell {FFFFFF}- Продать видеокарту системе\n" \
        "{FFFF00}/sellgpuplayer {FFFFFF}- Продать видеокарту игроку\n\n" \
        "{FFFFFF}Bitcoin операции:\n" \
        "{FFFF00}/btc {FFFFFF}- Проверить баланс Bitcoin\n" \
        "{FFFF00}/btcrate {FFFFFF}- Проверить текущий курс Bitcoin\n" \
        "{FFFF00}/exchangebtc {FFFFFF}- Обменять Bitcoin на рубли\n" \
        "{FFFF00}/sellbtcplayer {FFFFFF}- Продать Bitcoin игроку\n" \
        "{FFFF00}/acceptbtc {FFFFFF}- Принять предложение о покупке Bitcoin\n" \
        "{FFFF00}/acceptgpu {FFFFFF}- Принять предложение о покупке видеокарты\n\n" \
        "{FFFFFF}Обмен Bitcoin:\n" \
        "{FFFFFF}Обменять Bitcoin можно в {FFFF00}любом банке{FFFFFF} в специальных\n" \
        "{FFFFFF}зонах обмена. Подойдите к стойке с надписью\n" \
        "{FFFFFF}'Обменник Bitcoin'\n\n" \
        "{FFFFFF}Доступные видеокарты:\n" \
        "{FFFF00}0. {FFFFFF}GTX 1650 - 0.1 BTC/5min - {FFFF00}5.000.000 руб.\n" \
        "{FFFF00}1. {FFFFFF}RTX 2060 - 0.25 BTC/5min - {FFFF00}7.000.000 руб.\n" \
        "{FFFF00}2. {FFFFFF}RTX 3070 - 0.4 BTC/5min - {FFFF00}12.000.000 руб.\n" \
        "{FFFF00}3. {FFFFFF}RTX 4090 - 0.5 BTC/5min - {FFFF00}15.000.000 руб.\n\n" \
        "{FFFFFF}Максимальное количество видеокарт: {FFFF00}5\n\n" \
        "{FFFFFF}Майнинг работает автоматически при наличии рига и видеокарт!");

    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Помощь по майнинг-ферме", string, "Закрыть", "");
    return 1;
}