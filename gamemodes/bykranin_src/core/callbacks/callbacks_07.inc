//>> Файл: bykranin_src/core/callbacks/callbacks_07.inc  (737 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: SpeedBooster, OnSecondTimer, ParseBtStr, OnMinuteTimer, OnPlayersWorldTimeInit, OnLottery, OnPayDay
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: SpeedBooster()
{
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(!IsPlayerDriver(playerid)) continue;
		
		new vehicleid = GetPlayerVehicleID(playerid);

		if(vehicleid == INVALID_VEHICLE_ID)
		    continue;

		if(!IsAOwnableCar(vehicleid))
		    continue;

		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		
		new Float: engine_boost,
		    Float: brake_boost;

		for(new idx; idx < GetOwnableCarData(index, OC_PT_ENGINE); idx ++)
		    engine_boost += engine_ptune_boost[idx];

		for(new idx; idx < GetOwnableCarData(index, OC_PT_BRAKE); idx ++)
		    brake_boost += brake_ptune_boost[idx];

		if(GetPVarInt(playerid, "supercar"))
		{
			new pedal_type = player_press_pedal[playerid];

			if(pedal_type != PEDAL_TYPE_NONE)
			{
				//new vehicleid = GetPlayerVehicleID(playerid),
				new Float: v_speed = GetVehicleSpeed(vehicleid);

				if(v_speed > 25.0 || v_speed < -25.0)
				{
					switch(pedal_type)
					{
						case PEDAL_TYPE_GAS:
						{
							v_speed += (0.1 * GetPVarInt(playerid, "supercar_multiplier"));
						}
						case PEDAL_TYPE_BRAKE:
						{
							v_speed -= 0.6;
						}
					}

					SetVehicleSpeed(vehicleid, v_speed);
				}
			}
		}
	}
}

public OnSecondTimer()
{
	new newhour, minute, newsecond;
	gettime(newhour, minute, newsecond);

	new time = gettime();
	if(minute && !newsecond)
	{
		OnMinuteTimer(bool: GetElapsedTime(time, g_last_m_timer_time, CONVERT_TIME_TO_DAYS));
	}

	foreach(new playerid : Player)
	{
		FsinFull_TickSecond(playerid);
		CallLocalFunction("OnPlayerTimer", "i", playerid);
	}

	for(new carriageid; carriageid < sizeof miner_carriage; carriageid++)
		MinerCarriageUpdate(carriageid);

	if(g_capture[C_STATUS] && g_capture[C_TIME] > 0)
	{
		--g_capture[C_TIME];
		UpdateCaptureTextDraw();

		if(g_capture[C_TIME] == 0)
			EndCapture();
	}

	UpdateReporterText();
	ReportGUI_UpdateCounter();
	AdminHUD_UpdateDateTime();
}
#define MAX_BT_ITEMS 16

stock ParseBtStr(const btStr[], bt[], maxCount)
{
    new len = strlen(btStr);
    new buf[16];
    new pos = 0;
    new count = 0;

    for (new i = 0; i <= len; i++)
    {
        if (btStr[i] == ',' || btStr[i] == '\0')
        {
            buf[pos] = '\0';
            new val = strval(buf);
            if (val > 0 && count < maxCount)
                bt[count++] = val;
            pos = 0;
        }
					else if (pos < sizeof(buf)-1)
        {
            buf[pos++] = btStr[i];
        }
    }

    return count;
}

public OnMinuteTimer(bool: new_day)
{
	new time;
	new hour, minute, second;

	time = gettime();
	gettime(hour, minute, second);

	switch(minute)
	{
        case 29: SendClientMessageToAll(-1, "{ffff00}| Весь незанятый транспорт будет автоматически зареспавнен системой через 1 минуту!");
        case 30:
        {
            new vehicles_count;
            for(new i = 1; i < MAX_VEHICLES; i++)
            {
                if(!IsValidVehicle(i)) continue;
                else if(IsVehicleOccupied(i)) continue;
                else if(IsTrailerAttachedToAnyVehicle(i)) continue;

                SetVehicleToRespawn(i);
                vehicles_count++;
            }
            SendClientMessageToAll(-1, "{ffff00}| Весь незанятый транспорт был автоматически зареспавнен системой");
        }
        case 35:
        {
            new fmt_text[128];
            new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
            new ggg = GetFamilyData(fam_id, F_VISHARZ);
            new g = GetFamilyData(fam_id, F_VISBUS);
            new gg = GetFamilyData(fam_id, F_VISHKAR);

            AddFamilyData(fam_id, F_VISHARZ, -, ggg);
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET ochki2='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_VISHARZ), fam_id);
            mysql_query(mysql, fmt_text, false);

            AddFamilyData(fam_id, F_VISBUS, -, g);
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET ochki4='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_VISBUS), fam_id);
            mysql_query(mysql, fmt_text, false);

            AddFamilyData(fam_id, F_VISHKAR, -, gg);
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET ochki3='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_VISHKAR), fam_id);
            mysql_query(mysql, fmt_text, false);

            OnZakaza();
            OnZakazk();
            OnZakazb();

            timerarz = SetTimer("ARZERSECVI", 1000, true);
            new fmt_msg[244], rang_id = GetPlayerData(playerid, P_FAMILY_RANK) + 1;

            format(fmt_msg, sizeof fmt_msg, "Началось сражение за {ffff00}Вышка №1");
            format(fmt_msg, sizeof fmt_msg, "Началось сражение за {ffffff}Вышка {ffff00}№2");

            for(new i; i < MAX_PLAYERS; i++)
            {
                if(!IsPlayerConnected(i)) continue;
                if(!IsPlayerLogged(i)) continue;
                if(GetPlayerData(i, P_FAMILY) == 0) continue;
                if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

                SendClientMessage(i, -1, fmt_msg);
            }
        }
        case 12,24,36,48,59:
        {
        }
        case 03,15,27,39,51:
        {
        }
        case 0:
        {
            if(GetElapsedTime(time, g_last_pay_day_time) >= 1)
            {
                KillTimer(timerzavodp);
                GangZoneDestroy(zona21);
                DestroyDynamicArea(zona2);
                LoadZakazTextz();
                new query[100];
                new Cache: result;
                new fmt_text[555];
                new fmt_msg[555];
                new fam_id = GetPlayerData(playerid, P_FAMILY)+1;

                mysql_format(mysql, query, sizeof query, "SELECT name, ochki1 FROM family ORDER BY ochki1 DESC LIMIT 1");
                result = mysql_query(mysql, query, true);
                
                if (cache_num_rows(result))
                {
                    new name[32];
                    cache_get_field_content(0, "name", name, sizeof(name));
                    new lider_ochki = cache_get_field_content_int(0, "ochki1");
                    cache_delete(result);

                    format(fmt_msg, sizeof(fmt_msg), "Сражение за {ffff00}Завод Бусаево {ffffff} окончено. Победила семья: %s, набрав очков %d", name, lider_ochki);
                    
                    for(new i = 0; i < MAX_PLAYERS; i++)
                    {
                        if(!IsPlayerConnected(i)) continue;
                        if(!IsPlayerLogged(i)) continue;
                        if(GetPlayerData(i, P_FAMILY) == 0) continue;
                        if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;
                        SendClientMessage(i, -1, fmt_msg);
                    }
                }

                OnPayDay();

                for(new fam_id = g_family_loaded - 1; fam_id != -1; fam_id--)
                {
                    new fmt_text[348];
                    AddFamilyData(fam_id, F_EXP, +, g_doubling[DOUBLING_EXP] * 5);

                    if(GetFamilyData(fam_id, F_EXP) > 500)
                    {
                        SetFamilyData(fam_id, F_EXP, 0);
                        AddFamilyData(fam_id, F_LEVEL, +, 1);
                    }

                    mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET score='%d',exp='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_LEVEL), GetFamilyData(fam_id, F_EXP), fam_id);
                    mysql_query(mysql, fmt_text, false);
                }
            }
        }
        case 1:
        {
            if(GetElapsedTime(time, g_last_pay_day_time) >= 1)
            {
                OnPayDay();
            }
        }
        case 2:
        {
            if(GetElapsedTime(time, g_last_lottery_time) >= 1)
            {
                OnLottery();
            }
        }
       case 40:
        {
            new query[100];
            new Cache: result;
            new fmt_text[555];
            new fmt_msg[555];
            new fam_id = GetPlayerData(playerid, P_FAMILY)+1;

            mysql_format(mysql, query, sizeof query, "SELECT name, ochki2 FROM family ORDER BY ochki2 DESC LIMIT 1");
            result = mysql_query(mysql, query, true);
            
            if (cache_num_rows(result))
            {
                new name[32];
                cache_get_field_content(0, "name", name, sizeof(name));
                new lider_ochki = cache_get_field_content_int(0, "ochki2");
                cache_delete(result);

                format(fmt_msg, sizeof(fmt_msg), "Сражение за {ffff00}Вышку Арзамас окончено. Победила семья: %s", name, lider_ochki);
                
                for(new i = 0; i < MAX_PLAYERS; i++)
                {
                    if(!IsPlayerConnected(i)) continue;
                    if(!IsPlayerLogged(i)) continue;
                    if(GetPlayerData(i, P_FAMILY) == 0) continue;
                    if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;
                    SendClientMessage(i, -1, fmt_msg);
                }
            }

            mysql_format(mysql, query, sizeof query, "SELECT name, ochki3 FROM family ORDER BY ochki3 DESC LIMIT 1");
            result = mysql_query(mysql, query, true);
            if (cache_num_rows(result))
            {
                new name[32];
                cache_get_field_content(0, "name", name, sizeof(name));
                new lider_ochki = cache_get_field_content_int(0, "ochki3");
                cache_delete(result);

                format(fmt_msg, sizeof(fmt_msg), "Сражение за {ffff00}Вышку Карякино окончено. Победила семья: %s", name, lider_ochki);
                
                for(new i = 0; i < MAX_PLAYERS; i++)
                {
                    if(!IsPlayerConnected(i)) continue;
                    if(!IsPlayerLogged(i)) continue;
                    if(GetPlayerData(i, P_FAMILY) == 0) continue;
                    if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;
                    SendClientMessage(i, -1, fmt_msg);
                }
            }

            mysql_format(mysql, query, sizeof query, "SELECT name, ochki4 FROM family ORDER BY ochki4 DESC LIMIT 1");
            result = mysql_query(mysql, query, true);
            if (cache_num_rows(result))
            {
                new name[32];
                cache_get_field_content(0, "name", name, sizeof(name));
                new lider_ochki = cache_get_field_content_int(0, "ochki4");
                cache_delete(result);

                format(fmt_msg, sizeof(fmt_msg), "Сражение за {ffff00}Вышку Гарель окончено. Победила семья: %s", name, lider_ochki);
                
                for(new i = 0; i < MAX_PLAYERS; i++)
                {
                    if(!IsPlayerConnected(i)) continue;
                    if(!IsPlayerLogged(i)) continue;
                    if(GetPlayerData(i, P_FAMILY) == 0) continue;
                    if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;
                    SendClientMessage(i, -1, fmt_msg);
                }
            }

            KillTimer(timerarzl);
            KillTimer(timerkarr);
            KillTimer(timerbuszl);
            KillTimer(timersecfer);
            KillTimer(timerarz);
            KillTimer(timerkar);
            KillTimer(timebusz);
            
            LoadZakazTexta();
            LoadZakazTextk();
            LoadZakazTextb();
            GangZoneDestroy(zona31);
            DestroyDynamicArea(zona3);
            GangZoneDestroy(zona51);
            DestroyDynamicArea(zona5);
            GangZoneDestroy(zona41);
            DestroyDynamicArea(zona4);

            new ggg = GetFamilyData(fam_id, F_OCKIFARMA);
            AddFamilyData(fam_id, F_OCKIFARMA, -, ggg);
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET ochki='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_OCKIFARMA), fam_id);
            mysql_query(mysql, fmt_text, false);

            OnZakaz();
            timersecfer = SetTimer("FTIMERSEC", 1000, true);

            new rang_id = GetPlayerData(playerid, P_FAMILY_RANK) + 1;
            format(fmt_msg, sizeof fmt_msg, "Началось сражение за {ffff00}Ферма Гарель, {ffffff}найдите место проведения с помощью карты");

            for(new i; i < MAX_PLAYERS; i++)
            {
                if(!IsPlayerConnected(i)) continue;
                if(!IsPlayerLogged(i)) continue;
                if(GetPlayerData(i, P_FAMILY) == 0) continue;
                if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;
                SendClientMessage(i, -1, fmt_msg);
            }
        }
        case 45:
        {
            new fmt_text[128];
            new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
            new ggg = GetFamilyData(fam_id, F_OCZAVOD);

            AddFamilyData(fam_id, F_OCKIFARMA, -, ggg);
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET ochki1='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_OCZAVOD), fam_id);
            mysql_query(mysql, fmt_text, false);

            OnZakazz();
            timerzavod = SetTimer("FTIMERSEC", 1000, true);
            new fmt_msg[144], rang_id = GetPlayerData(playerid, P_FAMILY_RANK) + 1;

            format(fmt_msg, sizeof fmt_msg, "Началось сражение за {ffff00}Завод Бусаево, {ffffff}найдите место проведения с помощью карты");

            for(new i; i < MAX_PLAYERS; i++)
            {
                if(!IsPlayerConnected(i)) continue;
                if(!IsPlayerLogged(i)) continue;
                if(GetPlayerData(i, P_FAMILY) == 0) continue;
                if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;
                SendClientMessage(i, -1, fmt_msg);
            }
        }
        case 50:
        {
            KillTimer(timerochkov);
            GangZoneDestroy(zona11);
            DestroyDynamicArea(zona1);
            LoadZakazText();
            new query[100];
            new Cache: result;
            new fmt_text[555];
            new fmt_msg[555];
            new fam_id = GetPlayerData(playerid, P_FAMILY)+1;

            mysql_format(mysql, query, sizeof query, "SELECT name, ochki FROM family ORDER BY ochki DESC LIMIT 1");
            result = mysql_query(mysql, query, true);
            
            if (cache_num_rows(result))
            {
                new name[32];
                cache_get_field_content(0, "name", name, sizeof(name));
                new lider_ochki = cache_get_field_content_int(0, "ochki");
                cache_delete(result);

                format(fmt_msg, sizeof(fmt_msg), "Сражение за {ffff00}Ферма Гарель {ffffff} окончено. Победила семья: %s, набрав очков %d", name, lider_ochki);
                
                for(new i = 0; i < MAX_PLAYERS; i++)
                {
                    if(!IsPlayerConnected(i)) continue;
                    if(!IsPlayerLogged(i)) continue;
                    if(GetPlayerData(i, P_FAMILY) == 0) continue;
                    if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;
                    SendClientMessage(i, -1, fmt_msg);
                }
            }
					else cache_delete(result);
        }
	}

	if(new_day)
	{
		SetTimer("ClearBanList", 15_000, false);
	}

	SetWorldTime(hour);
	OnPlayersWorldTimeInit(hour, minute);

	g_last_m_timer_time = time;


    return 1;
}


public: OnPlayersWorldTimeInit(hour, minute)
{
	foreach(new playerid : Player)
	{
		SetPlayerTime(playerid, hour, minute);
	}
}

public: OnLottery()
{
	new fmt_str[85];
	new buffer[4];

	new lottery_str[4];
	new lottery_number;
	new buy_tickets_count;
	new hour, count;

	gettime(hour);
	lottery_number = random(900) + 100;

	valstr(lottery_str, lottery_number);
	buy_tickets_count = LotteryBuyTicketCount();

	static const
		lottery_pay[3] = {2000, 15_000, 50_000};

	foreach(new playerid : Player)
	{
		if(IsPlayerLogged(playerid))
		{
			if(GetPlayerData(playerid, P_LOTTERY))
			{
				format(fmt_str, sizeof fmt_str, "Сейчас %d:02! Начинаем лотерейный розыгрыш. Ваше счастливое число: %d", hour, GetPlayerData(playerid, P_LOTTERY));
				SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

				format(fmt_str, sizeof fmt_str, "За этот час было куплено %d билетов. Счастливое число этого часа: {FF9900}%d", buy_tickets_count, lottery_number);
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);

				valfmt(buffer, GetPlayerData(playerid, P_LOTTERY));

				for(count = 0; count < 3; count ++)
					if(lottery_str[count] != buffer[count]) break;

				switch(count)
				{
					case 0:
					{
						SendClientMessage(playerid, 0xFFFFFFFF, "К сожалению в вашем билете не совпала первая цифра");
						SendClientMessage(playerid, 0xFFFFFFFF, "Не расстраивайтесь. В следующий раз Вам обязательно повезёт");
					}
					case 1..3:
					{
						GivePlayerMoneyEx(playerid, lottery_pay[count-1], "Выигрыш в лотереи", true, true);

						format(fmt_str, sizeof fmt_str, "В вашем билете совпали %d цифры! Выигрыш: %d рублей", count, lottery_pay[count-1]);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);
					}
				}
				SetPlayerData(playerid, P_LOTTERY, 0);
			}
		}
	}
	g_last_lottery_time = gettime();
}

public: OnPayDay()
{
	new fmt_str[164];
	new level, cur_time;
	new hour, minute, second;

	cur_time = gettime();
	gettime(hour, minute, second);

	SetWorldTime(hour);
	
	//SendClientMessageToAll(0xFFFFFFFF, "{3399FF}--------------------------");
	SendClientMessageToAll(0xFFFFFFFF, fmt_str);

	foreach(new playerid : Player)
	{
		if(IsPlayerLogged(playerid))
		{
		    new rub = Config[sDistRub];
		    new coins = Config[sGiveCoins];
		    
		    AddPlayerData(playerid, P_COINS, +, coins);
			UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

			GivePlayerDonateRub(playerid, rub,"акция");
			

			if(GetPlayerData(playerid, P_ADMIN_STATUS))
				AddPlayerData(playerid, P_ADMIN_HOUR, +, 1);

			//SendClientMessage(playerid, 0xFFFFFFFF, "   БАНКОВСКИЙ ЧЕК");
			SendClientMessage(playerid, 0xFFFFFFFF, "{3399FF}______________________");
			SendClientMessageToAll(0xFFFFFFFF, "   ВРЕМЯ ВЫПЛАТЫ");
			SendClientMessage(playerid, 0xFFFFFFFF, " ");

			level = GetPlayerLevel(playerid);
			if(!IsPlayerAFK(playerid) || GetPlayerAFKTime(playerid) < 60)
			{
				if(ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_HOUR), CONVERT_TIME_TO_MINUTES) >= 20)
				{
					if(GetPlayerTeamEx(playerid))
					{
						new team_wage;

						if(GetPlayerTeamEx(playerid) < TEAM_OPG_ARZAMASKAYA || GetPlayerTeamEx(playerid) == TEAM_FSIN)
						{
							new team_id = GetPlayerTeamEx(playerid),
								rank = GetPlayerJob(playerid);

							if(team_id == TEAM_FSIN) team_wage = g_FsinFullRankWages[rank - 1];
							else team_wage = rank_wages[ team_id - 1 ][ rank - 1 ];
						}
					else
						{
							new gang_id = GetPlayerTeamEx(playerid) - TEAM_OPG_ARZAMASKAYA;

							team_wage = GetGangZonesCount(gang_id + 1) * 70 + 1000;
						}

						AddPlayerData(playerid, P_WAGE, +, team_wage);
					}
					//else SendClientMessage(playerid, 0xFFFFFFFF, "Зарплата: {00CC00}0 руб");
					zona1 = CreateDynamicRectangle(2325.411865,-239.441284, 2293.379150,-271.735473, 0, 0,-1);
     zona11 = GangZoneCreate(2325.411865,-239.441284, 2293.379150,-271.735473);
     GangZoneShowForAll(zona11,0xFF0000FF);

					AddPlayerData(playerid, P_BANK, +, GetPlayerData(playerid, P_WAGE));

					BankLog(playerid, GetPlayerData(playerid, P_WAGE), "Зарплата");

					SetPlayerData(playerid, P_WAGE, 0);
					AddPlayerData(playerid, P_EXP, +, g_doubling[DOUBLING_EXP] ? 2 : 1);
					AddPlayerData(playerid, P_TOTALHOUR, +, 1);
					BlackPass_OnPlayedHour(playerid);
					
					AddPlayerData(playerid, P_TOP_3, +, 1);
					UpdatePlayerDatabaseInt(playerid, "TOP_PayDay", GetPlayerData(playerid, P_TOP_3));

					//if(!IsPlayerAfk(i))
					//{
					if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
					{
						SetPlayerData(playerid, P_EXP, 0);
						AddPlayerData(playerid, P_LEVEL, +, 1);

						SetPlayerLevelInit(playerid);
					}
					//}
				}
					else SendClientMessage(playerid, COLOR_RED, "{FF5533}Для получения зарплаты необходимо находиться в игре минимум 20 минут");
			}
					else SendClientMessage(playerid, 0xFFBB00FF, "Вы не должны находиться на паузе для получения зарплаты");

			SendClientMessage(playerid, 0xFFFFFFFF, "{3399FF}______________________");
			
			BankLog(playerid, GetPlayerData(playerid, P_WAGE), "Зарплата");
			
			format(fmt_str, sizeof fmt_str, "Зарплата: {ff0000}%d руб", GetPlayerData(playerid, P_WAGE));
					SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

					format(fmt_str, sizeof fmt_str, "Текущий баланс счета: {%s}%d руб", GetPlayerBankMoney(playerid) > 0 ? ("ff0000") : ("ff0000"), GetPlayerBankMoney(playerid));
					SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
			SendClientMessage(playerid, 0xFFFFFFFF, "{ffff00}| {ffffff}Вы получили {ffff00}2BC {ffffff}на свой счет как пользователь со статусом {ffff00}Gold VIP");
			
			//SendClientMessage(playerid, 0xFFFFFFFF, ""SC"+5 донат монет");
			//SendClientMessage(playerid, 0xFFFFFFFF, "{ffff00} [Контейнера] {FFFFFF}Через 10 минут начнутся торги за контейнера(/gps-развлечения)");
			cont1 +=5;
			cont3 +=5;
			AddPlayerData(playerid, P_DONATE_MONEY, +, 5);
			UpdatePlayerDatabaseInt(playerid, "donate_current", GetPlayerDonateMoney(playerid));
			UpdatePlayerDatabaseInt(playerid, "donate_total", GetPlayerTotalDonate(playerid));
			SavePlayerAccount(playerid);
			if(GetPlayerData(playerid, P_TOTALHOUR) == 10)
			{
				AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
				SendClientMessage(playerid, 0x3399FFFF, "Поздравляем! Вы получили дополнительный слот автомобиля");
				UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
			}
			if(GetPlayerLevel(playerid) > level)
			{
				SendClientMessage(playerid, 0x3399FFFF, "Поздравляем! Ваш уровень повышен");
				switch(GetPlayerLevel(playerid))
				{
					case 2:
					{
						SendClientMessage(playerid, 0x66CC00FF, "Вы начали второй год своей жизни в нашей стране");
						SendClientMessage(playerid, 0x66CC00FF, "Доступна новая работа водителя автобуса");
					}
					case 5:
					{
						CallLocalFunction("OnGiveReferBonus", "i", GetPlayerData(playerid, P_REFER));
					}
					/*
					case 3:
						SendClientMessage(playerid, 0x66CC00FF, "Доступна новая работа таксиста");

					case 4:
						SendClientMessage(playerid, 0x66CC00FF, "Доступна новая работа дальнобойщика");

					case 5:
						SendClientMessage(playerid, 0x66CC00FF, "Доступна новая работа автоменаника");

					case 6:
						SendClientMessage(playerid, 0x66CC00FF, "Доступна новая работа уличного торговца");

					case 7:
						SendClientMessage(playerid, 0x66CC00FF, "Доступна новая работа сотрудника МЧС");
					*/
				}
			}
			format(fmt_str, sizeof fmt_str, "UPDATE accounts SET level=%d,exp=%d,bank=%d,wage=0,last_login=%d,game_for_hour=0,get_adm_hour=%d,totalhour = %d WHERE id=%d LIMIT 1", GetPlayerLevel(playerid), GetPlayerExp(playerid), GetPlayerBankMoney(playerid), cur_time, GetPlayerData(playerid, P_ADMIN_HOUR), GetPlayerData(playerid, P_TOTALHOUR), GetPlayerAccountID(playerid));
			mysql_query(mysql, fmt_str, false);

			if(mysql_errno() != 0)
				SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения аккаунта {FF0000}(equ-code 100)");

			new rows,
				Cache: result;

			mysql_format(mysql, fmt_str, sizeof fmt_str, "SELECT id, paydays, code FROM promocode_activations WHERE uid=%d AND paydays > 0", GetPlayerAccountID(playerid));
			result = mysql_query(mysql, fmt_str, true);

			rows = cache_num_rows(result);

			if(rows)
			{
				for(new idx; idx < rows; idx ++)
				{
					new id = cache_get_row_int(idx, 0),
						paydays = cache_get_row_int(idx, 1),
						code[32];

					cache_get_row(idx, 2, code);

					mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE promocode_activations SET paydays='%d' WHERE id='%d'", paydays - 1, id);
					mysql_query(mysql, fmt_str, false);

					if(paydays == 1)
					{
						new Cache: p_cache;

						mysql_format(mysql, fmt_str, sizeof fmt_str, "SELECT type, amount FROM promocode WHERE code='%s'", code);
						p_cache = mysql_query(mysql, fmt_str, true);

						new type = cache_get_row_int(0, 0),
							amount = cache_get_row_int(0, 1);

						cache_delete(p_cache);

						AddPlayerData(playerid, promo_info[type][P_DATA], +, amount);
						UpdatePlayerDatabaseInt(playerid, promo_info[type][P_SQL_NAME], GetPlayerData(playerid, promo_info[type][P_DATA]));

						SendClientMessage(playerid, -1, "");

						format(fmt_str, sizeof fmt_str, "Получен приз за промокод \"%s\"", code);
						SendClientMessage(playerid, 0x66CC33FF, fmt_str);
					}
				}
			}

			cache_delete(result);
		}
		SetPlayerData(playerid, P_GAME_FOR_HOUR, 0);
	}

	//SellDebtorsProperty();

	if(hour == 5) SellDebtorsHotels();

	printf("hour live %d", hour);

	#if defined RAND_WEATHER
	SetTimer("SetRandomWeather", (random(60) + 60) * 1000, false);
	#endif

	CallLocalFunction("UpdateRealtorHomeInfo", "");
	CallLocalFunction("UpdateRealtorBizInfo", "");

	g_last_pay_day_time = cur_time;
	SellDebtorsNewProperties();
	SellDebtorsHome();
	SellDebtorsFuel();
    SellDebtorsBusiness();
	return 1;
}

