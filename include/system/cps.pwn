/*
 это в SellBusiness после GameTextForPlayer(playerid, query, 4000, 1);

		for(new b;b < count_business_auction;b++)
		{
			if(auction_business[b][id_business_sql] == -1)
			{
				auction_business[b][id_business_sql] = GetBusinessData(businessid, B_SQL_ID);
				auction_business[b][last_rate] = GetBusinessData(businessid, B_PRICE);
				format(auction_business[b][name_business], 94, GetBusinessData(businessid, B_NAME));
				if(b == count_business_auction) count_business_auction++;
				break;
			}
		}
*/

new second_auction = 600; //тут менять время аукциона

//Автор данной системы https://t.me/welsistudio (Welsi Studio)
enum struct_action_business
{
    id_business_sql, 
    id_rate_owner, 
    last_rate,
    name_business[94],
    date_start_rate,
    date_end_rate, 
    timer_auction,
}
new count_business_auction = 0;
new auction_business[MAX_BUSINESS][struct_action_business];

new enter_auction, exit_auction;

CMD:auction(playerid)
{
    if(GetPlayerVirtualWorld(playerid) != 152) return 1;

    new text[144];

    if(!count_business_auction) return SendClientMessage(playerid, -1, ""USC" В данный момент нету свободных бизнесов");

    new stats[98], dialog[sizeof stats + 328] = "Далее\n", count;

    switch(count_business_auction)
    {
        case 0..10:
        {
            format(dialog, 10, "");

            for(new b; b < count_business_auction;b++)//Автор данной системы https://t.me/welsistudio (Welsi Studio)
            {
                if(auction_business[b][id_business_sql] == -1) continue;

                count++;

                format(stats, sizeof stats, "%d. %s\t\t\t\t%d р.\n", b+1, auction_business[b][name_business], auction_business[b][last_rate]);
                strcat(dialog, stats);
                SetPlayerListitemValue(playerid, count, b);
            }
        }
        default:
        {
            new c;
            while(c != 10)
            {   
                if(auction_business[c][id_business_sql] != -1)
                {
                    format(stats, sizeof stats, "%d. %s\t\t\t\t%d р.\n", c+1, auction_business[c][name_business], auction_business[c][last_rate]);
                    strcat(dialog, stats);
                    SetPlayerListitemValue(playerid, c+1, c);

                    c++;
                }
            }

            SetPVarInt(playerid, "list_dialog", 1);
        }
    }

    Dialog
    (
        playerid, 2758, DIALOG_STYLE_LIST, 
        "Аукцион бизнесов",
        dialog,
        "Далее", "Выйти"
    );

    return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 2758)
    {
        if(response)
        {

            if(GetPVarInt(playerid, "list_dialog"))
            {
                if(!listitem)
                {
                    new stats[98], dialog[sizeof stats + 328] = "Далее\n";

                    new count = 10 * GetPVarInt(playerid, "list_dialog"), list, ponda = count_business_auction - count;

                    if(!(ponda >= 10))  format(dialog, 10, "");
                    else list++;

                    while(list != 10)
                    {
                        if(count <= count_business_auction && auction_business[count][id_business_sql] != -1)
                        {
                            format(stats, sizeof stats, "%d. %s\t\t\t\t%d р.\n", count+1, auction_business[count][name_business], auction_business[count][last_rate]);
                            strcat(dialog, stats);
                            SetPlayerListitemValue(playerid, list, count);
                            list++;
                            count++;
                        }
                        else{
                            list++;
                            count++;
                        }

                    }

                    SetPVarInt(playerid, "list_dialog", GetPVarInt(playerid, "list_dialog") + 1);        
                    
                    Dialog
                    (
                        playerid, 2758, DIALOG_STYLE_LIST, 
                        "Аукцион бизнесов",
                        dialog,
                        "Далее", "Выйти"
                    );

                    return 1;
                }
                else DeletePVar(playerid, "list_dialog");
            }

            if(GetPlayerData(playerid, P_BUSINESS) != -1) return SendClientMessage(playerid, -1, ""SC" У вас уже есть бизнес.");

            new id = GetPlayerListitemValue(playerid, listitem);
            

            SetPVarInt(playerid, "biz_id_auction", id);

            if(auction_business[id][id_rate_owner] == GetPlayerAccountID(playerid))
            {
                SendClientMessage(playerid, -1, ""SC" Вы не можете поставить ставку на бизнес");
                SendClientMessage(playerid, -1, ""SC" Вы уже ставили ставку на этот бизнес");
                callcmd::auction(playerid);
                return 1;
            }

            

            new stats[244], time[9], next_rate = auction_business[id][last_rate] + 50000;

            if(!auction_business[id][date_start_rate]) format(time, sizeof time, "не начат");
            else format(time, sizeof time, "%d:%d", ConvertUnixTime(auction_business[id][date_end_rate] - gettime(), CONVERT_TIME_TO_MINUTES), ConvertUnixTime(auction_business[id][date_end_rate] - gettime(), CONVERT_TIME_TO_SECONDS));

            format
            (
                stats, sizeof stats,
                "Вы хотите поставить ставку на бизнес?\n\n"\
                "{FFFFFF}Название: {FFFF00}%s\n"\
                "{FFFFFF}Последняя ставка: {FFFF00}%d\n"\
                "{FFFFFF}До конца окончания аукциона: {FFFF00}%s\n"\
                "{FFFFFF}Минимальная ставка: {FFFF00}%d",
                auction_business[id][name_business],
                auction_business[id][last_rate],
                time,
                next_rate
            );

            Dialog
            (
                playerid, 4600, DIALOG_STYLE_INPUT, 
                "Аукцион | Информация",
                stats, 
                "Далее", "Назад"
            );
        }
    }
    if(dialogid == 4600)
    {
        if(response)
        {
            new id = GetPVarInt(playerid, "biz_id_auction"), money = strval(inputtext), text[124];


            DeletePVar(playerid, "biz_id_auction");


            if(GetPlayerMoneyEx(playerid) < money) return SendClientMessage(playerid, -1, ""USC" У вас недостаточно денег.");

            if(money >= auction_business[id][last_rate] + 50000)
            {
                if(auction_business[id][id_rate_owner] != -1)
                {
                    new player_none;

                    foreach(new i : Player)
                    {
                        if(auction_business[id][id_rate_owner] == GetPlayerAccountID(i))
                        {
                            player_none++;
                            SendClientMessage(i, -1, ""SC" Вашу ставку на бизнес перебили.");
                            GivePlayerMoneyEx(i, auction_business[id][last_rate]);
                        }
                    }

                    if(!player_none)
                    {
                        format(text, sizeof text, "UPDATE `accounts` SET `money` = `money` + %d WHERE `id` = %d", auction_business[id][last_rate], auction_business[id][id_rate_owner]);
                        mysql_query(mysql, text, false);
                        if(mysql_errno()) return print("error return money mysql");
                    }
                }

                auction_business[id][last_rate] = money;
                auction_business[id][date_end_rate] = gettime() + second_auction;
                auction_business[id][date_start_rate] = gettime();
                auction_business[id][id_rate_owner] = GetPlayerAccountID(playerid);

                GivePlayerMoneyEx(playerid, -money);

                if(auction_business[id][timer_auction]) KillTimer(auction_business[id][timer_auction]);

                auction_business[id][timer_auction] = SetTimerEx("AuctionBusiness", 1000, true, "i", id);
            }

        }
    }
    #if defined biz_OnDialogResponse
return biz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse biz_OnDialogResponse
#if defined biz_OnDialogResponse
forward biz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnGameModeInit()
{//Автор данной системы https://t.me/welsistudio (Welsi Studio)
    enter_auction = CreateDynamicSphere(2092.610351,-2283.928955,23.096267, 1.0, 0, 0);
    exit_auction = CreateDynamicSphere(999.965148,2488.335205,1499.304687, 1.0, 152, 1);
    CreateDynamicPickup(19134, 23, 2092.610351,-2283.928955,23.096267, 0, 0);
    CreateDynamicPickup(19134, 23, 999.965148,2488.335205,1499.304687, 152, 1);
    Create3DTextLabel("{FFFF00}Вход в аукцион\n{FFFFFF}Подойдите ближе чтобы войти", -1, 2092.610351,-2283.928955,23.096267, 10.0, 0);//Автор данной системы https://t.me/welsistudio (Welsi Studio)

    for(new b; b < MAX_BUSINESS;b++)
    {
        auction_business[b][id_business_sql] = -1;
        auction_business[b][id_rate_owner] = -1;
    }

    SetTimer("LoadBusinessToAuction", 2500, 0);
    #if defined biz_OnGameModeInit
        return biz_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else//Автор данной системы https://t.me/welsistudio (Welsi Studio)
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit biz_OnGameModeInit
#if defined biz_OnGameModeInit
    forward biz_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == enter_auction)
    {
        SetPlayerPosEx(playerid, 999.987854,2489.679443,1499.304687,359.335876, 1, 152);
    }
    if(areaid == exit_auction)
    {
        SetPlayerPosEx(playerid, 2090.941650,-2283.999511,23.101566,92.530944, 0, 0);
    }
    #if defined biz_OnPlayerEnterDynamicArea
        return biz_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea biz_OnPlayerEnterDynamicArea
#if defined biz_OnPlayerEnterDynamicArea
    forward biz_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif
//Автор данной системы https://t.me/welsistudio (Welsi Studio)
public:LoadBusinessToAuction()
{
    new text[114], Cache:result;
    format(text, sizeof text, "SELECT * FROM business WHERE `owner_id` = 0");
    result = mysql_query(mysql, text, true);

    if(mysql_errno()) return print("error_sql auction business");

    new memory = cache_num_rows();

    if(!memory) return 1;

    for(new b;b < memory;b++)
    {
        auction_business[b][id_business_sql] = cache_get_field_content_int(b, "id");
        auction_business[b][last_rate] = cache_get_field_content_int(b, "price");
        cache_get_field_content(b, "name", auction_business[b][name_business]);
        count_business_auction++;
    }


    cache_delete(result);
//Автор данной системы https://t.me/welsistudio (Welsi Studio)
    return 1;
}

public: AuctionBusiness(business)
{
    if(auction_business[business][date_end_rate] <= gettime())
    {
        new text[144];

        foreach(new i : Player)
        {
            if(auction_business[business][id_rate_owner] == GetPlayerAccountID(i)) SendClientMessage(i, -1, ""SC" Поздравляем! Вы получили бизнес с аукциона");
        }

//Автор данной системы https://t.me/welsistudio (Welsi Studio)
        BuyPlayerBusinessAuction(auction_business[business][id_rate_owner], business, auction_business[business][last_rate]);

        KillTimer(auction_business[business][timer_auction]);

        auction_business[business][timer_auction] = -1;
        auction_business[business][id_business_sql] = -1;
        auction_business[business][last_rate] = 0;
        auction_business[business][id_rate_owner] = 0;
        format(auction_business[business][name_business], 94, "");
        auction_business[business][date_end_rate] = 0;
        auction_business[business][date_start_rate] = 0;
    }
    return 1;
}

stock BuyPlayerBusinessAuction(sql_id, businessid, price = -1)//Автор данной системы https://t.me/welsistudio (Welsi Studio)
{
        new query[256];
        new player = -1;

        for(new b; b < MAX_BUSINESS;b++)
        {
            if(GetBusinessData(b, B_SQL_ID) == auction_business[businessid][id_business_sql]) businessid = b - 1;
            break;
        }

        foreach(new i : Player)
        {
            if(sql_id == GetPlayerAccountID(i)) player = i;
        }

        
        
        format(query, sizeof query, "UPDATE accounts a, business b SET a.business=%d,b.owner_id=%d WHERE a.id=%d AND b.id=%d", businessid, sql_id, sql_id, GetBusinessData(businessid, B_SQL_ID));
        mysql_query(mysql, query, false);
        printf("sql %s", query);

        if(!mysql_errno())
        {
            SetPlayerData(player, P_BUSINESS, businessid);

            SetBusinessData(businessid, B_OWNER_ID, sql_id);
            SetBusinessData(businessid, B_IMPROVEMENTS, 	0);

            new time = gettime();//Автор данной системы https://t.me/welsistudio (Welsi Studio)
            new rent_time = (time - (time % 86400)) + 86400;


            SetBusinessData(businessid,	B_PRODS, 		20);
            SetBusinessData(businessid,	B_PROD_PRICE, 	0);

            SetBusinessData(businessid,	B_ENTER_MUSIC, 	0);
            SetBusinessData(businessid,	B_ENTER_PRICE, 	0);

            SetBusinessData(businessid,	B_BALANCE, 		0);
            SetBusinessData(businessid,	B_RENT_DATE,	rent_time);
            SetBusinessData(businessid,	B_LOCK_STATUS,	false);

            new name[24], Cache:result;

            format(query, sizeof query, "SELECT name FROM accounts WHERE id = %d", sql_id);
            result = mysql_query(mysql, query);

            cache_get_row(0, 0, name);//Автор данной системы https://t.me/welsistudio (Welsi Studio)
            if(mysql_errno()) return print("error name label to business");

            format(g_business[businessid][B_OWNER_NAME], 21, name, 0);
            CallLocalFunction("UpdateBusinessLabel", "i", businessid);

            cache_delete(result);

            SendClientMessage(player, 0x66CC00FF, "Напишите {0099FF}/business {66CC00}чтобы узнать о возможностях");

            format(query, sizeof query, "UPDATE business SET improvements=0,products=%d,prod_price=%d,balance=%d,rent_time=%d,`lock`=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_RENT_DATE), GetBusinessData(businessid, B_LOCK_STATUS), GetBusinessData(businessid, B_SQL_ID));
            mysql_query(mysql, query, false);

            format(query, sizeof query, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(businessid, B_SQL_ID));
            mysql_query(mysql, query, false);

            return 1;
        }
        return 0;
}//Автор данной системы https://t.me/welsistudio (Welsi Studio)