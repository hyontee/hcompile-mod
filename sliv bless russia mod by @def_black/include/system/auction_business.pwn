#define BUSINESS_BID_PRICE_MULTIPLIER 1.1 // Множитель для следующей ставки (110% от предыдущей)
#define BUSINESS_BID_TIME 3600 // Время ставки в секундах (1 час)

new 
    g_BusinessBidPlayer[MAX_BUSINESS] = {-1, ...}, // ID игрока, сделавшего ставку
    g_BusinessBidAmount[MAX_BUSINESS] = {0, ...}, // Сумма текущей ставки
    g_BusinessBidTime[MAX_BUSINESS] = {0, ...}, // Время окончания ставки
    g_BusinessBidTimer[MAX_BUSINESS] = {-1, ...}, // Таймеры для ставок
    g_BusinessBidUpdateTimer[MAX_BUSINESS] = {-1, ...}; // Таймеры для обновления 3D текста

// В начало файла, после других forwards
forward OnBusinessBidExpire(businessid);
forward OnBusinessBidUpdateLabel(businessid);

// Функции для работы со ставками
stock IsBusinessBidActive(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
    return (g_BusinessBidTime[businessid] > gettime() && g_BusinessBidPlayer[businessid] != -1);
}

stock GetBusinessBidPlayer(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return -1;
    return g_BusinessBidPlayer[businessid];
}

stock GetBusinessBidAmount(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
    return g_BusinessBidAmount[businessid];
}

stock GetBusinessBidTimeLeft(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
    if(!IsBusinessBidActive(businessid)) return 0;
    return g_BusinessBidTime[businessid] - gettime();
}

stock FormatBidTime(time, output[], len)
{
    new hours = time / 3600;
    new minutes = (time % 3600) / 60;
    new seconds = time % 60;
    
    if(hours > 0) format(output, len, "%02d:%02d:%02d", hours, minutes, seconds);
    else format(output, len, "%02d:%02d", minutes, seconds);
    return 1;
}

stock IsCasinoBusiness(businessid)
{
    new type = GetBusinessData(businessid, B_TYPE);
    new sqlid = GetBusinessData(businessid, B_SQL_ID);
    
    if(type == BUSINESS_TYPE_CASINO) return 1;
    if(sqlid == 34 || sqlid == 35 || sqlid == 36 || sqlid == 37) return 1;
    
    return 0;
}

stock CreateBusinessBidsTable()
{
    print("[BUSINESS BIDS] Проверка таблицы businesses_bids...");
    
    new Cache:cache = mysql_query(mysql, "SELECT * FROM businesses_bids", true);

    if(mysql_errno())
    {
        print("[BUSINESS BIDS] Таблица businesses_bids не найдена, creating...");
        
        new query[512];
        format(query, sizeof(query),
            "CREATE TABLE `businesses_bids` (\
            `id` int(11) NOT NULL AUTO_INCREMENT,\
            `business_sqlid` int(11) NOT NULL,\
            `player_id` int(11) NOT NULL,\
            `bid_amount` int(11) NOT NULL,\
            `bid_time` int(11) NOT NULL,\
            `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,\
            PRIMARY KEY (`id`),\
            UNIQUE KEY `business_sqlid` (`business_sqlid`)\
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
        );
        
        mysql_query(mysql, query, false);

        if(mysql_errno()) 
        {
            printf("[BUSINESS BIDS] Error creating table businesses_bids: %d", mysql_errno());
        }
        else
        {
            print("[BUSINESS BIDS] Table businesses_bids created successfully");
        }
    }
    else
    {
        print("[BUSINESS BIDS] Таблица businesses_bids существует");
    }

    cache_delete(cache);
    LoadBusinessBids();
    return 1;
}

stock SaveBusinessBid(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
    
    new query[256];
    format(query, sizeof(query),
        "INSERT INTO businesses_bids (business_sqlid, player_id, bid_amount, bid_time) VALUES (%d, %d, %d, %d) ON DUPLICATE KEY UPDATE player_id = VALUES(player_id), bid_amount = VALUES(bid_amount), bid_time = VALUES(bid_time)",
        GetBusinessData(businessid, B_SQL_ID),
        g_BusinessBidPlayer[businessid],
        g_BusinessBidAmount[businessid],
        g_BusinessBidTime[businessid]
    );
    mysql_query(mysql, query);
    return 1;
}

stock LoadBusinessBids()
{
    printf("[BUSINESS BIDS] Loading business bids from database...");
    mysql_query(mysql, "SELECT * FROM businesses_bids");
    
    new rows = cache_get_row_count();
    if(!rows) 
    {
        printf("[BUSINESS BIDS] No active bids found");
        return 1;
    }
    
    for(new i = 0; i < rows; i++)
    {
        new business_sqlid = cache_get_field_content_int(i, "business_sqlid");
        new player_id = cache_get_field_content_int(i, "player_id");
        new bid_amount = cache_get_field_content_int(i, "bid_amount");
        new bid_time = cache_get_field_content_int(i, "bid_time");
        
        for(new biz = 0; biz < MAX_BUSINESS; biz++)
        {
            if(GetBusinessData(biz, B_SQL_ID) == business_sqlid)
            {
                g_BusinessBidPlayer[biz] = player_id;
                g_BusinessBidAmount[biz] = bid_amount;
                g_BusinessBidTime[biz] = bid_time;
                
                // Запускаем таймер, если ставка еще активна
                if(bid_time > gettime())
                {
                    new time_left = bid_time - gettime();
                    g_BusinessBidTimer[biz] = SetTimerEx("OnBusinessBidExpire", time_left * 1000, false, "i", biz);
                    
                    // Запускаем таймер обновления 3D текста
                    g_BusinessBidUpdateTimer[biz] = SetTimerEx("OnBusinessBidUpdateLabel", 1000, true, "i", biz);
                    
                    printf("[BUSINESS BIDS] Loaded active bid for business %d (SQL: %d) - player %d, amount %d, time left: %d seconds", 
                        biz, business_sqlid, player_id, bid_amount, time_left);
                }
                else
                {
                    // Ставка истекла, передаем бизнес
                    printf("[BUSINESS BIDS] Expired bid found for business %d (SQL: %d) - processing transfer", biz, business_sqlid);
                    OnBusinessBidExpire(biz);
                }
                break;
            }
        }
    }
    
    printf("[BUSINESS BIDS] Загружено %d активных bids", rows);
    return 1;
}

stock RefundBidToPlayer(account_id, amount)
{
    // Возвращаем донат через базу данных в строку rub
    new query[128];
    format(query, sizeof(query), "UPDATE accounts SET rub = rub + %d WHERE id = %d", amount, account_id);
    mysql_query(mysql, query);
    printf("[BUSINESS BIDS] Refunded %d donate rub to account ID: %d", amount, account_id);
    
    // Также уведомляем игрока, если он онлайн
    new message[128];
    format(message, sizeof(message), ""USC"Вам вернули %d донат рублей, так как вашу ставку перебили.", amount);
    
    foreach(new i : Player)
    {
        if(GetPlayerAccountID(i) == account_id)
        {
            SendClientMessage(i, 0x33CC33FF, message);
            break;
        }
    }
    
    return 1;
}

public OnBusinessBidUpdateLabel(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
    
    if(IsBusinessBidActive(businessid))
    {
        UpdateBusinessLabel(businessid);
    }
    else
    {
        if(g_BusinessBidUpdateTimer[businessid] != -1)
        {
            KillTimer(g_BusinessBidUpdateTimer[businessid]);
            g_BusinessBidUpdateTimer[businessid] = -1;
        }
    }
    
    return 1;
}

public OnBusinessBidExpire(businessid)
{
    if(businessid < 0 || businessid >= MAX_BUSINESS) return 0;
    
    if(g_BusinessBidUpdateTimer[businessid] != -1)
    {
        KillTimer(g_BusinessBidUpdateTimer[businessid]);
        g_BusinessBidUpdateTimer[businessid] = -1;
    }
    
    new winner_id = g_BusinessBidPlayer[businessid];
    
    if(winner_id != -1)
    {
        printf("[BUSINESS BIDS] Business %d transfer to player %d", businessid, winner_id);
        
        SetBusinessData(businessid, B_OWNER_ID, winner_id);
        
        new query[128];
        format(query, sizeof(query), "SELECT username FROM accounts WHERE id = %d", winner_id);
        mysql_query(mysql, query);
        
        if(cache_get_row_count() > 0)
        {
            new username[21];
            cache_get_field_content(0, "username", username);
            SetBusinessData(businessid, B_OWNER_NAME, username);

            foreach(new i : Player)
            {
                if(GetPlayerAccountID(i) == winner_id)
                {
                    SendClientMessage(i, 0x33CC33FF, ""SC"Поздравляем! Вы выиграли бизнес в ставках!");
                    break;
                }
            }
        }
    }
    else
    {
        printf("[BUSINESS BIDS] Business %d - no winner found", businessid);
    }

    g_BusinessBidPlayer[businessid] = -1;
    g_BusinessBidAmount[businessid] = 0;
    g_BusinessBidTime[businessid] = 0;
    g_BusinessBidTimer[businessid] = -1;
    
    new delete_query[128];
    format(delete_query, sizeof(delete_query), "DELETE FROM businesses_bids WHERE business_sqlid = %d", GetBusinessData(businessid, B_SQL_ID));
    mysql_query(mysql, delete_query);

    UpdateBusinessLabel(businessid);
    
    return 1;
}

public OnGameModeInit()
{
	SetTimer("CreateBusinessBidsTable", 3000, false);

    #if defined aucbiz_OnGameModeInit
        return aucbiz_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit aucbiz_OnGameModeInit
#if defined aucbiz_OnGameModeInit
    forward aucbiz_OnGameModeInit();
#endif

// Обновленная функция UpdateBusinessLabel
public: UpdateBusinessLabel(businessid)
{
	new fmt_str[256];
	new time_str[32];

	new type = GetBusinessData(businessid, B_TYPE);
if(type == BUSINESS_TYPE_SHOP_24_7)
{
    new entryPrice = GetBusinessData(businessid, B_ENTER_PRICE);
    new entryColor[16];
    
    if(entryPrice > 0) entryColor = "{FF0000}";
    else entryColor = "{33CC00}";

    if(!IsBusinessOwned(businessid))
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}Магазин 24/7 (№ %d)\n"\
            "{ebb121}Бизнес: {FFFFFF}Продается\n"\
            "{ebb121}Стоимость: {FFFFFF}%s%d рублей\n"\
            " \n"\
            "{DCDCDC}[ Для покупки используйте: /buybiz ]",
            businessid,
            entryColor,
            GetBusinessData(businessid, B_PRICE)
        );
    }
    else
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}Магазин 24/7 (№ %d)\n"\
            "{ebb121}Владелец: {FFFFFF}%s\n",
            businessid,
            GetBusinessData(businessid, B_OWNER_NAME)
        );
        if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{ebb121}Вход: {FFFFFF}%s%d руб\n{DCDCDC}[ Подойдите для входа ]", fmt_str, entryColor, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
    }
}
    else if(type == BUSINESS_TYPE_STALLS)
	{
        new entryPrice = GetBusinessData(businessid, B_ENTER_PRICE);
        new entryColor[16];

        if(entryPrice > 0) entryColor = "{FF0000}";
        else entryColor = "{33CC00}";
        
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ebb121}Ларек (%d)\n"\
			"{ebb121}Бизнес продается\n"\
			"{ebb121}Стоимость: {FFFFFF}%s%d рублей\n"\
    		" \n"\
    		"{DCDCDC}[ Для покупки используйте: /buybiz ]",
    		businessid,
    		entryColor,
    		GetBusinessData(businessid, B_PRICE)
        );
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ebb121}Ларек (%d)\n"\
			"{ebb121}Владелец: {FFFFFF}%s\n",
    		businessid,
    		GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{ebb121}Вход: {FFFFFF}%s%d руб\n{DCDCDC}[ Подойдите для входа ]", fmt_str, entryColor, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
	else if(type == BUSINESS_TYPE_CLOTHING_SHOP)
	{
	
	    new entryPrice = GetBusinessData(businessid, B_ENTER_PRICE);
    new entryColor[16];
    
    if(entryPrice > 0) entryColor = "{FF0000}";
    else entryColor = "{33CC00}";
		if(!IsBusinessOwned(businessid))
		{
format
(
    fmt_str, sizeof fmt_str,
    "{ebb121}Магазин одежды (№ %d)\n"\
    "{ebb121}Бизнес: {FFFFFF}Продается\n"\
    "{ebb121}Стоимость: {FFFFFF}%s%d рублей\n"\
    " \n"\
    "{DCDCDC}[ Для покупки используйте: /buybiz ]",
    businessid,
    entryColor,
    GetBusinessData(businessid, B_PRICE)
);
}
else
{
format
(
    fmt_str, sizeof fmt_str,
    "{ebb121}Магазин одежды (№ %d)\n"\
    "{ebb121}Владелец: {FFFFFF}%s\n",
    businessid,
    GetBusinessData(businessid, B_OWNER_NAME)
);

			if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{ebb121}Вход: {FFFFFF}%s%d руб\n{DCDCDC}[ Подойдите для входа ]", fmt_str, entryColor, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
		}
	}
	else if(type == BUSINESS_TYPE_CASINO || IsCasinoBusiness(businessid))
{
    new entryPrice = GetBusinessData(businessid, B_ENTER_PRICE);
    new entryColor[16];
    
    // Если цена > 0, делаем красным, иначе зелёным
    if(entryPrice > 0) entryColor = "{FF0000}";
    else entryColor = "{33CC00}";

    new business_name[70];
        if(type == BUSINESS_TYPE_CASINO) format(business_name, sizeof(business_name), "Казино");
        if(GetBusinessData(businessid, B_SQL_ID) == 35) format(business_name, sizeof(business_name), "Мотосалон");
        if(GetBusinessData(businessid, B_SQL_ID) == 36) format(business_name, sizeof(business_name), "Автосалон низкого класса");
        if(GetBusinessData(businessid, B_SQL_ID) == 37) format(business_name, sizeof(business_name), "Автосалон высокого класса");
        if(GetBusinessData(businessid, B_SQL_ID) == 38) format(business_name, sizeof(business_name), "Автосалон среднего класса");

    if(!IsBusinessOwned(businessid))
    {
        if(IsBusinessBidActive(businessid))
        {
            FormatBidTime(GetBusinessBidTimeLeft(businessid), time_str, sizeof(time_str));
            
            format
            (
                fmt_str, sizeof fmt_str,
                "{ebb121}%s (№ %d)\n"\
                "{ebb121}Бизнес: {FFFFFF}Идут ставки\n"\
                "{ebb121}Начальная цена: {FFFFFF}%s%d BC\n"\
                "{ebb121}Текущая ставка: {FFFFFF}%s%d BC\n"\
                "{ebb121}До конца: {FFFFFF}%s\n"\
                " \n"\
                "{DCDCDC}[ Для ставки используйте: /buybiz ]",
                business_name,
                businessid,
                entryColor,
                GetBusinessData(businessid, B_PRICE),
                entryColor,
                GetBusinessBidAmount(businessid),
                time_str
            );
        }
        else
        {
            format
            (
                fmt_str, sizeof fmt_str,
                "{ebb121}%s (№ %d)\n"\
                "{ebb121}Бизнес: {FFFFFF}Продается\n"\
                "{ebb121}Стоимость: {FFFFFF}%s%d BC\n"\
                " \n"\
                "{DCDCDC}[ Для ставки используйте: /buybiz ]",
                business_name,
                businessid,
                entryColor,
                GetBusinessData(businessid, B_PRICE)
            );
        }
    }
    else
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}%s (№ %d)\n"\
            "{ebb121}Владелец: {FFFFFF}%s\n"\
            " \n"\
            "{DCDCDC}[ Подойдите для входа ]",
            business_name,
            businessid,
            GetBusinessData(businessid, B_OWNER_NAME)
        );
        if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{ebb121}Вход: {FFFFFF}%s%d руб\n{DCDCDC}[ Подойдите для входа ]", fmt_str, entryColor, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
    }
}
else if(type == BUSINESS_TYPE_SHOP_GUN)
{
    new entryPrice = GetBusinessData(businessid, B_ENTER_PRICE);
    new entryColor[16];
    
    if(entryPrice > 0) entryColor = "{FF0000}";
    else entryColor = "{33CC00}";

    if(!IsBusinessOwned(businessid))
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}Магазин оружия (№ %d)\n"\
            "{ebb121}Бизнес: {FFFFFF}Продается\n"\
            "{ebb121}Стоимость: {FFFFFF}%s%d рублей\n"\
            " \n"\
            "{DCDCDC}[ Для покупки используйте: /buybiz ]",
            businessid,
            entryColor,
            GetBusinessData(businessid, B_PRICE)
        );
    }
    else
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}Магазин оружия (№ %d)\n"\
            "{ebb121}Владелец: {FFFFFF}%s\n",
            businessid,
            GetBusinessData(businessid, B_OWNER_NAME)
        );
        if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{ebb121}Вход: {FFFFFF}%s%d руб\n{DCDCDC}[ Подойдите для входа ]", fmt_str, entryColor, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
    }
}
else if(type == BUSINESS_TYPE_ACCESSORY_SHOP)
{
    new entryPrice = GetBusinessData(businessid, B_ENTER_PRICE);
    new entryColor[16];
    
    if(entryPrice > 0) entryColor = "{FF0000}";
    else entryColor = "{33CC00}";

    if(!IsBusinessOwned(businessid))
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}Магазин аксессуаров (№ %d)\n"\
            "{ebb121}Бизнес: {FFFFFF}Продается\n"\
            "{ebb121}Стоимость: {FFFFFF}%s%d рублей\n"\
            " \n"\
            "{DCDCDC}[ Для покупки используйте: /buybiz ]",
            businessid,
            entryColor,
            GetBusinessData(businessid, B_PRICE)
        );
    }
    else
    {
        format
        (
            fmt_str, sizeof fmt_str,
            "{ebb121}Магазин аксессуаров (№ %d)\n"\
            "{ebb121}Владелец: {FFFFFF}%s\n"\
            "{ebb121}Вход: {FFFFFF}%s%d рублей\n",
            businessid,
            GetBusinessData(businessid, B_OWNER_NAME)
        );
        if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{ebb121}Вход: {FFFFFF}%s%d руб\n{DCDCDC}[ Подойдите для входа ]", fmt_str, entryColor, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
    }
}

UpdateDynamic3DTextLabelText(GetBusinessData(businessid, B_LABEL), 0xFFFF00FF, fmt_str);
}

CMD:buybiz(playerid, params[])
{
	if(GetPlayerBusiness(playerid) != -1)
	{
		SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть бизнес. Чтобы купить другой необходимо продать старый");
		return 1;
	}

	new businessid = GetNearestBusiness(playerid, 4.0);
	if(businessid == -1)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Вы должны быть рядом с бизнесом, который хотите купить");
		return 1;
	}

	if(IsBusinessNoBuy(businessid))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Данный тип бизнеса в разработке, его еще нельзя купить!");
		return 1;
	}

	// Если это казино или автосалон - используем систему ставок
	if(IsCasinoBusiness(businessid))
	{
		if(IsBusinessOwned(businessid))
		{
			SendClientMessage(playerid, 0xCECECEFF, ""USC"Этот бизнес уже куплен");
			return 1;
		}

		new amount;
		if(sscanf(params, "i", amount))
		{
			new min_bid = IsBusinessBidActive(businessid) ? 
				floatround(GetBusinessBidAmount(businessid) * BUSINESS_BID_PRICE_MULTIPLIER) : 
				GetBusinessData(businessid, B_PRICE);
			
			new message[128];
			format(message, sizeof(message), "{FFD700}[Информация] {d6d6d6}Используйте: /buybiz [сумма] | Минимальная ставка: %d руб", min_bid);
			SendClientMessage(playerid, 0xCECECEFF, message);
			return 1;
		}

		new min_bid = IsBusinessBidActive(businessid) ? 
			floatround(GetBusinessBidAmount(businessid) * BUSINESS_BID_PRICE_MULTIPLIER) : 
			GetBusinessData(businessid, B_PRICE);

		if(amount < min_bid)
		{
			new message[128];
			format(message, sizeof(message), "{FFD700}[Информация] {d6d6d6}Минимальная ставка: %d руб", min_bid);
			SendClientMessage(playerid, 0xCECECEFF, message);
			return 1;
		}

		if(GetPlayerDonateRub(playerid) < amount)
		{
			SendClientMessage(playerid, 0xCECECEFF, ""USC"У вас недостаточно донат рублей");
			return 1;
		}

		if(IsBusinessBidActive(businessid) && GetBusinessBidPlayer(businessid) != GetPlayerAccountID(playerid))
		{
			RefundBidToPlayer(GetBusinessBidPlayer(businessid), GetBusinessBidAmount(businessid));

			if(g_BusinessBidTimer[businessid] != -1)
			{
				KillTimer(g_BusinessBidTimer[businessid]);
				g_BusinessBidTimer[businessid] = -1;
			}

			if(g_BusinessBidUpdateTimer[businessid] != -1)
			{
				KillTimer(g_BusinessBidUpdateTimer[businessid]);
				g_BusinessBidUpdateTimer[businessid] = -1;
			}
		}

		GivePlayerDonateRub(playerid, -amount);

		g_BusinessBidPlayer[businessid] = GetPlayerAccountID(playerid);
		g_BusinessBidAmount[businessid] = amount;
		g_BusinessBidTime[businessid] = gettime() + BUSINESS_BID_TIME;

		g_BusinessBidTimer[businessid] = SetTimerEx("OnBusinessBidExpire", BUSINESS_BID_TIME * 1000, false, "i", businessid);
		g_BusinessBidUpdateTimer[businessid] = SetTimerEx("OnBusinessBidUpdateLabel", 1000, true, "i", businessid);

		SaveBusinessBid(businessid);
		UpdateBusinessLabel(businessid);

		new success_msg[128];
		format(success_msg, sizeof(success_msg), "| {ffffff}Вы сделали ставку в размере %d донат рублей на бизнес. Ставка действует 1 час.", amount);
		SendClientMessage(playerid, 0x33CC33FF, success_msg);
		
		if(IsBusinessBidActive(businessid) && GetBusinessBidPlayer(businessid) != GetPlayerAccountID(playerid))
		{
			SendClientMessage(playerid, 0xFFFF00FF, "| {ffffff}Вы перебили ставку предыдущего участника. Его донат рубли были возвращены.");
		}
	}
	else // Обычный бизнес - стандартная покупка
	{
		if(IsBusinessOwned(businessid))
		{
			SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес уже куплен");
			return 1;
		}

		SetPVarInt(playerid, "buy_biz_id", businessid);

		new fmt_str[256];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Название:\t\t\t{FFD700}%s\n"\
			"{FFFFFF}Стоимость:\t\t\t{FFD700}%d руб\n"\
			"{CA5757}Вы уверены что хотите купить этот бизнес?",
			GetBusinessData(businessid, B_NAME),
			GetBusinessData(businessid, B_PRICE),
			GetBusinessData(businessid, B_RENT_PRICE)
		);
		Dialog(playerid, DIALOG_BIZ_BUY, DIALOG_STYLE_MSGBOX, "{FFD700}Покупка нового бизнеса {FFFFFF}| BEST RUSSIA", fmt_str, "Да", "Нет");
	}

	return 1;
}