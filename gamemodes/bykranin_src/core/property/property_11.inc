//>> Файл: bykranin_src/core/property/property_11.inc  (1171 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: /delvacancy, /vacancy, DuelOn, ProxDetectorS, SpawnDeathMatch, /dmzexit, /mycoins
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:delvacancy(playerid)
{

	if(!(1 <= GetPlayerTeamEx(playerid) <= 7)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	switch(GetPlayerTeamEx(playerid))
	{
	    case TEAM_ARMY:
	    {
	    	if(strlen(interview[TEAM_ARMY][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
			interview[TEAM_ARMY][text_time] = EOS; interview[TEAM_ARMY][text_crit] = EOS;
		}
		case TEAM_DPS:
		{
		    if(strlen(interview[TEAM_DPS][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
		    interview[TEAM_DPS][text_time] = EOS; interview[TEAM_DPS][text_crit] = EOS;
		}
		case TEAM_HOSPITAL:
		{
		    if(strlen(interview[TEAM_HOSPITAL][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
		    interview[TEAM_ARMY][text_time] = EOS; interview[TEAM_HOSPITAL][text_crit] = EOS;
		}
		case TEAM_FBI:
		{
		    if(strlen(interview[TEAM_FBI][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
		    interview[TEAM_FBI][text_time] = EOS; interview[TEAM_FBI][text_crit] = EOS;
		}
		case TEAM_RADIO:
		{
		    if(strlen(interview[TEAM_RADIO][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
		    interview[TEAM_RADIO][text_time] = EOS; interview[TEAM_RADIO][text_crit] = EOS;
		}
		case TEAM_GOVERNMENT:
		{
		    if(strlen(interview[TEAM_GOVERNMENT][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
		    interview[TEAM_GOVERNMENT][text_time] = EOS; interview[TEAM_GOVERNMENT][text_crit] = EOS;
		}
		case TEAM_PPS:
		{
		    if(strlen(interview[TEAM_PPS][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} Вакансии не существует!");
		    interview[TEAM_PPS][text_time] = EOS; interview[TEAM_PPS][text_crit] = EOS;
		}
	}

	SendClientMessage(playerid, -1,"{FFFF00}[Информация]{FFFFFF} Вы успешно удалили вакансию из журнала собеседований");
	return 1;
}

CMD:vacancy(playerid)
{
	Dialog(playerid, 29000, DIALOG_STYLE_LIST,"Журнал вакансий","\
	"c_s"[1] "c_b"ВМФ\n\
	"c_s"[2] "c_b"Мэрия\n\
	"c_s"[3] "c_b"ГИБДД\n\
	"c_s"[4] "c_b"Больница\n\
	"c_s"[5] "c_b"СМИ\n\
	"c_s"[6] "c_b"FBI\n\
	"c_s"[7] "c_b"УМВД","Выбрать","Закрыть");
	return 1;
}

/*CMD:duel(playerid, params[])
{
	new id,
		cash,
		string[400];

	if(GetPVarInt(playerid, "antifloodduel") > gettime()) return SendClientMessage(playerid, -1, "Предлагать дуэли можно раз в минуту!");

	if(sscanf(params, "ii", id, cash)) return SendClientMessage(playerid, -1, "Используй: /duel [id игрока] [ставка]");

	if(!ProxDetectorS(10, playerid, id)) return SendClientMessage(playerid, -1, "Вы далеко друг от друга!");

	if(DuelOffer[id] != -1)return SendClientMessage(playerid, -1, "Данному игроку уже предложили дуэль!");

	if(DuelOffer[id] == playerid)return SendClientMessage(playerid, -1, "Вы уже предложили дуэль данному игроку!");

	if(cash < 1000 || cash > 10000000)return SendClientMessage(playerid, -1, "Нельзя предложить меньше 1.000$ или больше 10.000.000$!");

	if(playerid == id)return SendClientMessage(playerid, -1, "Нельзя самому себе предложить дуэль!");

	new bool: gun = false;

	new ammo,
		gunid;

	new ammo2,
		gunid2;

	for(new i; i < 13; i ++)
	{
		GetPlayerWeaponData(id, i, gunid, ammo);
		GetPlayerWeaponData(playerid, i, gunid2, ammo2);

		if(!gunid || !ammo) continue;
		if(!gunid2 || !ammo2) continue;
		gun = true;
		break;
	}
	if(!gun)return SendClientMessage(playerid, -1, "У Вас или же у Вашего соперника нет оружия!");
	
	SendClientMessage(playerid, -1, "Вы успешно предложили игроку дуэль!");

	new Name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, Name, MAX_PLAYER_NAME); f("Игрок {99CC00}%s[%d] {ffffff}предлагает Вам дуэль на {99CC00}%d${ffffff}!", Name, playerid, cash);

	Dialog(id, 3000, 0, "Дуэль", string, "Принять", "Отклонить");

	DuelOffer[id] = playerid;
	DuelCash[id] = cash;
	DuelCash[playerid] = cash;
	DuelOffer[playerid] = id;

	return true;
}
forward DuelOn(playerid, id);
public DuelOn(playerid, id)
{
	new string[50];
	timeduel[playerid]--;
	f("~g~Duel: %d", timeduel[playerid]);
	GameTextForPlayer(playerid, string, 1000, 3);
	GameTextForPlayer(id, string, 1000, 3);
	if(timeduel[playerid] <= 0)
	{
		if(!IsPlayerConnected(id) || !IsPlayerConnected(playerid))
		{
			SendClientMessage(id, -1, "Один из игроков вышел!");
			SendClientMessage(playerid, -1, "Один из игроков вышел!");

			KillTimer(DuelTimer[playerid]);
			timeduel[playerid] = 11;
			DuelOffer[playerid] = -1;
			DuelOffer[id] = -1;
			DuelCash[id] = 0;
			DuelCash[playerid] = 0;

			return false;
		}
		KillTimer(DuelTimer[playerid]);
		timeduel[playerid] = 11;
		SendClientMessage(playerid, -1, "Дуэль началась!");
		SendClientMessage(id, -1, "Дуэль началась!");
		TogglePlayerControllable(id, 1);
		TogglePlayerControllable(playerid, 1);
	}
	return true;
}
*/
stock ProxDetectorS(Float:radi, playerid, targetid, spec = 0)
{
	new Float:p[3];

	if(!IsPlayerConnected(playerid)) return false;

	if(!IsPlayerConnected(targetid)) return false;

	if(!spec)
	{
		if(GetPlayerState(playerid) == 9) return false;

		if(GetPlayerState(targetid) == 9) return false;
	}
	if(!GetPlayerPos(targetid, p[0], p[1], p[2])) return false;
	if(!IsPlayerInRangeOfPoint(playerid, radi, p[0], p[1], p[2])) return false;

	return true;
}

stock SpawnDeathMatch(playerid)
{
    
    switch(random(3))
    {
        case 0:
		{
			SetPlayerPos(playerid, 742.591735,1754.569946,1191.398559);
			GivePlayerWeapon(playerid, 24, 999);
			SetPlayerHealth(playerid, 100);// 100 HP
			SetPlayerInterior(playerid, 1);
    		SetPlayerVirtualWorld(playerid, 1);
		}
        case 1:
		{
			SetPlayerPos(playerid, 721.075805,1747.330932,1192.843872);
			SetPlayerHealth(playerid, 100);// 100 HP
    		SetPlayerVirtualWorld(playerid, 1);
            SetPlayerInterior(playerid, 1);
    		GivePlayerWeapon(playerid, 24, 999);
		}
        case 2:
		{
			SetPlayerPos(playerid, 762.154357,1755.301635,1191.429687);
			SetPlayerHealth(playerid, 100);// 100 HP
    		SetPlayerVirtualWorld(playerid, 1);
            SetPlayerInterior(playerid, 1);
    		GivePlayerWeapon(playerid, 24, 999);
		}
        case 3:
		{
			SetPlayerPos(playerid, 775.674072,1751.479370,1191.429687);
			SetPlayerHealth(playerid, 100);// 100 HP
    		SetPlayerVirtualWorld(playerid, 1);
           SetPlayerInterior(playerid, 1);
    		GivePlayerWeapon(playerid, 24, 999);
		}
    }
    
    return 1;
}

CMD:dmzexit(playerid)
{
    if(GetPlayerData(playerid, P_DMZ_STATUS) == 1)
	{
		SetPlayerPos(playerid, 1301.493896,1704.872924,1498.363159);
	    SetPlayerVirtualWorld(playerid, 0);
	    ResetPlayerWeapons(playerid);
	    SetPlayerHealth(playerid, 100);// 100 HP
	    SetPlayerInterior(playerid, 0);

	    SetPlayerData(playerid, P_DMZ_STATUS, 0);
	}
}

CMD:mycoins(playerid)
{
	new fmt_text[80];
    format(fmt_text, sizeof fmt_text, "У вас %d монет.", GetPlayerData(playerid, P_COINS));
	SendClientMessage(playerid, 0xFF5533FF, fmt_text);


	return 1;
}

CMD:dmztop(playerid)
{
	new fmt_text[80];
    format(fmt_text, sizeof fmt_text, "У вас %d киллов на DeathMatch.", GetPlayerData(playerid, P_DMZ_KILL));
	SendClientMessage(playerid, 0xFF5533FF, fmt_text);
		
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY dmz_kills DESC LIMIT 10");
	mysql_tquery(mysql, string, "TopDMZKills", "d",playerid);

	return 1;
}

public: TopDMZKills(playerid)
{
	new name[24], cash,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			cash = 0;
			cache_get_field_content(i, "name", name, mysql);
			cash = cache_get_field_content_int(i, "dmz_kills", mysql);
			format(string, sizeof(string), "%s\n"c_b"Ник: "c_server"%s "c_b"Kills: "c_server"%d", string, name, cash);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Топ 10 игроков", string, "Закрыть", "");

	return 1;
}

CMD:killstop(playerid)
{
	if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать это");

	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY capt_kills DESC LIMIT 5");
	mysql_tquery(mysql, string, "TopCaptKills", "d",playerid);

	return 1;
}

public: TopCaptKills(playerid)
{
	new name[24], cash,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			cash = 0;
			cache_get_field_content(i, "name", name, mysql);
			cash = cache_get_field_content_int(i, "capt_kills", mysql);
			format(string, sizeof(string), "%s\n"c_b"Ник: "c_server"%s "c_b"Kills: "c_server"%d", string, name, cash);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Топ 5 игроков", string, "Закрыть", "");

	return 1;
}

/*CMD:opencase(playerid)
{
    ShowPlayerOpenCase(playerid);
}

stock ShowPlayerOpenCase(playerid)
{
    Dialog(playerid,DIALOG_DONATE_CASE,DIALOG_STYLE_MSGBOX,
	"Открытие кейса",
	"У Вас есть возможность выиграть VIP-статус, слот для транспорта, деньги, донат рубли и донат коины\n"\
	"Вы уверены что хотите открыть кейс?",
	"Открыть","Отмена"
	);
}*/

stock ShowPlayerOpenDonate(playerid)
{
    Dialog(playerid,DIALOG_DONATE_OPEN,DIALOG_STYLE_LIST,
	"Донат",
	"1. Получить донат который Вы пополнили\n"\
	"2. Донат-Меню",
	"Открыть","Отмена"
	);
}

public: GetPlayerPrise(playerid)
{
	new fmt_text[256];
	
	AddPlayerData(playerid, P_DONATE_CASE, -, 1);
	BlackPass_OnCaseOpened(playerid);
	
    switch(random(15))
	{
		case 0..6:
		{
			new rand = random(10000000);

			GivePlayerMoneyEx(playerid, rand,"Открытие кейса", true, true);
			format(fmt_text, sizeof fmt_text, "Поздравляем! Вы выиграли: %d$", rand);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
			return 1;
		}
		case 7..8:
		{
		    new rand = random(15);
		    
		    GivePlayerDonateRub(playerid, rand,"Открытие кейса", true, true);
			format(fmt_text, sizeof fmt_text, "Поздравляем! Вы выиграли: %d DONATE-RUB", rand);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
			return 1;
		}
		case 9:
		{
		    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
			UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
			
			format(fmt_text, sizeof fmt_text, "Вы выиграли слот для транспорта. Текущее количество слотов: %d",
			GetPlayerData(playerid, P_CAR_SLOTS));
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
			return 1;
		}
		case 10..13:
		{
		    new rand = random(500) + 300;

		    GivePlayerDonate(playerid, rand,"Открытие кейса", true);
			format(fmt_text, sizeof fmt_text, "Поздравляем! Вы выиграли: %d DONATE-COINS", rand);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
		}
		case 14..15:
		{
		    new premium = GetPlayerPremium(playerid);
      		if(!premium)
        	{
         		SetPlayerData(playerid, P_PREMIUM, 1);
         		SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 3 * 86400);
			}
					else
			{
   				AddPlayerData(playerid, P_PREMIUM_DATE, +, 3 * 86400);
			}

			new prem_day,
   			prem_month,
   			prem_year;

			timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

			format(fmt_text, sizeof fmt_text, "Вы успешно выиграли {EC174F} VIP {FFFFFF}до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
			SendClientMessage(playerid, -1, fmt_text);
			UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
			UpdatePlayerDatabaseInt(playerid, "premium", 1);
			return 1;
		}
 	}
	return false;
}

CMD:testt(playerid)
{
     ShowPlayerClientSettings(playerid);
}

CMD:testoff(playerid)
{
    RemovePlayerAttachedObject(playerid, 3);
}

CMD:online(playerid)
{
    new query[70];
    format(query, sizeof query, "[Информация]: "c_b"Текущий онлайн: {FFFF00}%d "c_b"человек", Iter_Count(Player));
	SendClientMessage(playerid, COR_SERVER, query);
	return 1;
}

stock MessageInSpawn()
{
	/*new query[70];
    format(query, sizeof query, "Добро пожаловать");
	SendClientMessage(playerid, COR_SERVER, query);*/
	return 1;
}

stock ShowPlayerObmenMonet(playerid)
{
	new fmt_str[500];
	
    format
	(
		fmt_str, sizeof fmt_str,
		""c_b"1. Пожарная машина (ID: 407) - "c_s"1.000 монет "c_b"| Осталось "c_s"%d из 5\n\
		"c_b"2. Автобус (ID: 431) - "c_s"1.000 монет "c_b"| Осталось "c_s"%d из 5\n\
		"c_b"3. Пожарный вертолет (ID: 563) - "c_s"1.000 монет "c_b"| Осталось "c_s"%d из 5\n\
		"c_b"4. Полицейская машина (ID: 597) - "c_s"1.000 монет "c_b"| Осталось "c_s"%d из 5\n\
		"c_b"5. Монстер (ID: 444) - "c_s"3.000 монет "c_b"| Осталось "c_s"%d из 1",
		Cars[car_1],
		Cars[car_2],
		Cars[car_3],
		Cars[car_4],
		Cars[car_5]
	);

	Dialog(playerid, DIALOG_OBMEN_MONET, DIALOG_STYLE_LIST, "Обмен монет", fmt_str, "Обменять", "Закрыть");
	return 1;

}



public: LoadCarObmen()
{
	new Cache: result;

	result = mysql_query(mysql, "SELECT * FROM `car_obmen`", true);

	Cars[car_1] = cache_get_field_content_int(0, "car_1", mysql);
    Cars[car_2] = cache_get_field_content_int(0, "car_2", mysql);
    Cars[car_3] = cache_get_field_content_int(0, "car_3", mysql);
    Cars[car_4] = cache_get_field_content_int(0, "car_4", mysql);
    Cars[car_5] = cache_get_field_content_int(0, "car_5", mysql);


	cache_delete(result);

	printf("[CAR_OBMEN]: Load!");
}

CMD:createytpromo(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	Dialog
	(
		playerid, DIALOG_YTPROMO_CREATE, DIALOG_STYLE_INPUT,
		"Создание промокода ютубера",
		"{FFFFFF}Для создания промокода введите\n"\
		"следующие параметры в окно ниже:\n\n"\
		"{33CC66}Параметры: Код, Тип, Кол-во\n\n"\
		"{888888}Примечание:\n"\
		"{FFFFFF}- Код может содержать от 1 до 30 символов\n"\
		"- Тип от 0 до 3 (0. деньги, 1.донат, 2. донат-рубли, 3. exp)\n"\
		"- Количество от 1 до 10.000.000",
		"Далее", "Отмена"
	);

	return 1;
}


CMD:asellhouse(playerid, params[])
{
	if (GetPlayerAdminEx(playerid) != 6) {
		return 0;
	}
	extract params -> new i; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /asellhouse [id дома]");

	new
		query[180];
	//if(!GetHouseData(i, H_EVICTION)) continue;
	//if(GetHouseData(i, H_RENT_DATE) < cur_time) continue;

	format(query, sizeof query, "UPDATE houses SET owner_id='0',lock='0',eviction='0' WHERE id='%d'", GetHouseData(i, H_SQL_ID));
	mysql_query(mysql, query, false);

	new owner_player = GetPlayerIDBySqlID(GetHouseData(i, H_OWNER_ID));
	if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
		SetPlayerData(owner_player, P_HOUSE, -1);
		SetPlayerData(owner_player, P_HOUSE_ROOM, -1);
		SetPlayerData(owner_player, P_HOUSE_TYPE, -1);
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
		mysql_query(mysql, query, false);
	}
					else {
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetHouseData(i, H_OWNER_ID));
		mysql_query(mysql, query, false);
	}
	SetHouseData(i, H_OWNER_ID, 0);
	SetHouseData(i, H_IMPROVEMENTS,		0);

	SetHouseData(i, H_EVICTION, 0);

	SetHouseData(i, H_RENT_DATE,		0);
	SetHouseData(i, H_LOCK_STATUS,		false);

	UpdateHouse(i);

	HouseHealthInit(i);
	HouseStoreInit(i);
	return 1;
}

CMD:asellbiz(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", "");

	extract params -> new businessid; else
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /asellbiz [id бизнеса]");

	if(businessid < 0 || businessid >= g_business_loaded || GetBusinessData(businessid, B_SQL_ID) < 1)
		return SendClientMessage(playerid, 0xCECECEFF, "Бизнес с таким ID не найден");

	new owner_account_id = GetBusinessData(businessid, B_OWNER_ID);
	if(owner_account_id < 1)
		return SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес уже принадлежит государству");

	new auction_slot_id = AuctionBusiness_FindActiveSlot(businessid);
	new bool:has_free_auction_slot = auction_slot_id != -1;
	if(!has_free_auction_slot)
	{
		for(new slot; slot < MAX_AUCTION_SLOT; slot++)
		{
			if(!auction_slot[slot][SLOT_TYPE])
			{
				has_free_auction_slot = true;
				break;
			}
		}
	}
	if(!AuctionBusiness_IsAuctionable(businessid))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот тип бизнеса нельзя выставить на аукцион");
	if(!has_free_auction_slot)
		return SendClientMessage(playerid, 0xCECECEFF, "На аукционе нет свободных слотов. Бизнес не был продан");

	if(auction_slot_id != -1)
	{
		if(auction_slot_busy[auction_slot_id])
			return SendClientMessage(playerid, 0xCECECEFF, "Аукцион обрабатывает этот бизнес. Повторите команду позднее");

		if(!AuctionRefundBid(auction_slot_id, "Бизнес снят с аукциона администратором. Ставка возвращена."))
			return SendClientMessage(playerid, 0xCECECEFF, "Не удалось вернуть ставку аукциона. Продажа отменена");

		if(auction_slot[auction_slot_id][AUCTION_DB_ID] > 0)
		{
			new auction_query[192];
			mysql_format(mysql, auction_query, sizeof auction_query,
				"UPDATE auction_lots SET status='cancelled_by_admin' WHERE id=%d AND status='active'",
				auction_slot[auction_slot_id][AUCTION_DB_ID]);
			mysql_query(mysql, auction_query, false);
		}
		reset_slot_auction(auction_slot_id);
	}

	new query[256];
	mysql_format(mysql, query, sizeof query,
		"UPDATE business SET owner_id=0,improvements=0,products=0,prod_price=0,balance=0,rent_time=0,enter_music=0,`lock`=0,eviction=0,ownership_started_at=0 WHERE id=%d",
		GetBusinessData(businessid, B_SQL_ID));
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET business=-1 WHERE id=%d AND business=%d LIMIT 1",
		owner_account_id, businessid);
	mysql_query(mysql, query, false);

	new owner_player = GetPlayerIDBySqlID(owner_account_id);
	if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
	{
		if(GetPlayerData(owner_player, P_BUSINESS) == businessid)
			SetPlayerData(owner_player, P_BUSINESS, -1);
		if(GetSelectedBusiness(owner_player) == businessid)
			SetSelectedBusiness(owner_player, -1);

		SendClientMessage(owner_player, 0xFFCC00FF, "Ваш бизнес был принудительно продан государству администратором.");
	}

	SetBusinessData(businessid, B_OWNER_ID, 0);
	SetBusinessData(businessid, B_IMPROVEMENTS, 0);
	SetBusinessData(businessid, B_EVICTION, 0);
	SetBusinessData(businessid, B_PRODS, 0);
	SetBusinessData(businessid, B_PROD_PRICE, 0);
	SetBusinessData(businessid, B_BALANCE, 0);
	SetBusinessData(businessid, B_RENT_DATE, 0);
	SetBusinessData(businessid, B_ENTER_MUSIC, 0);
	SetBusinessData(businessid, B_LOCK_STATUS, false);
	format(g_business[businessid][B_OWNER_NAME], 21, "Государство");

	BusinessHealthPickupInit(businessid);

	mysql_format(mysql, query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", businessid);
	mysql_query(mysql, query, false);

	g_business_gps_init = false;
	if(!AuctionManager_AddStateBusiness(businessid, "Решение администратора"))
	{
		CallLocalFunction("UpdateBusinessLabel", "i", businessid);
		SendClientMessage(playerid, 0xFF5533FF,
			"Бизнес продан государству, но создать аукционный лот не удалось. Проверьте MySQL");
		return 1;
	}
	CallLocalFunction("UpdateRealtorBizInfo", "");

	new message[160];
	format(message, sizeof message, "[A] Администратор %s[%d] продал бизнес ID %d государству и выставил его на аукцион.",
		GetPlayerNameEx(playerid), playerid, businessid);
	SendMessageToAdmins(message, 0x999999FF);
	SendClientMessage(playerid, 0x66CC00FF, "Бизнес продан государству и сразу выставлен на аукцион");

	format(message, sizeof message, "Продал бизнес ID %d государству и выставил на аукцион (владелец аккаунта: %d)",
		businessid, owner_account_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
	return 1;
}

CMD:abuybiz(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", "");

    extract params -> new businessid; else
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /abuybiz [id бизнеса]");

    if(businessid < 0 || businessid >= g_business_loaded || GetBusinessData(businessid, B_SQL_ID) < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "Бизнес с таким ID не найден");

    new slot = AuctionBusiness_FindActiveSlot(businessid);
    if(slot == -1 || auction_slot[slot][SLOT_TYPE] != TYPE_BUSINESS
        || auction_slot[slot][BUSINESS_SOURCE_SLOT] != AUCTION_BUSINESS_SOURCE_REGULAR)
        return SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес сейчас не продаётся на аукционе");
    if(auction_slot_busy[slot])
        return SendClientMessage(playerid, 0xCECECEFF, "Лот сейчас обрабатывается. Повторите команду позднее");
    if(auction_slot[slot][OWNER_SLOT_SQL] == GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя купить собственный лот");

    new max_business = 1 + GetPlayerData(playerid, P_BUSS_SLOTS);
    if(max_business > 2) max_business = 2;
    if(GetPlayerBusinessCount(playerid) >= max_business)
        return SendClientMessage(playerid, 0xCECECEFF, "Достигнут лимит бизнесов");

    new price = auction_slot[slot][CURRENT_RATE];
    if(price <= 0 || price > 2000000000)
        return SendClientMessage(playerid, 0xCECECEFF, "У лота указана некорректная цена");
    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки бизнеса");

    if(auction_slot[slot][OWNER_RATE] != -1)
    {
        if(!AuctionRefundBid(slot, "Администратор мгновенно выкупил лот. Ваша ставка возвращена."))
            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось безопасно вернуть текущую ставку");
    }

    new query[512];
    if(auction_slot[slot][AUCTION_DB_ID] > 0)
    {
        mysql_format(mysql, query, sizeof query,
            "UPDATE auction_lots SET current_price=%d,highest_bidder_account_id=%d,highest_bidder_name='%e',ends_at=%d,status='active' WHERE id=%d AND status='active'",
            price, GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), gettime(), auction_slot[slot][AUCTION_DB_ID]);
        new Cache:result = mysql_query(mysql, query, true);
        if(mysql_errno() || cache_affected_rows() < 1)
        {
            cache_delete(result);
            return SendClientMessage(playerid, 0xCECECEFF, "Лот уже завершён или изменён. Обновите аукцион");
        }
        cache_delete(result);

        mysql_format(mysql, query, sizeof query,
            "INSERT INTO auction_bids (auction_id,bidder_account_id,bidder_name,amount,created_at,status) VALUES (%d,%d,'%e',%d,%d,'active')",
            auction_slot[slot][AUCTION_DB_ID], GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), price, gettime());
        mysql_query(mysql, query, false);
        if(mysql_errno())
            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось сохранить выкуп лота");
    }

    GivePlayerMoneyEx(playerid, -price, "Мгновенный выкуп бизнеса на аукционе", true, true);
    auction_slot[slot][OWNER_RATE] = GetPlayerAccountID(playerid);
    auction_slot[slot][CURRENT_RATE] = price;
    auction_slot[slot][TIMER_END] = gettime();
    format(auction_slot[slot][OWNER_SLOT_NAME], 24, "%s", GetPlayerNameEx(playerid));

    if(!finish_auction_slot(slot))
        return SendClientMessage(playerid, 0xCECECEFF, "Не удалось завершить лот. Деньги будут возвращены системой");

    new message[160];
    format(message, sizeof message, "[A] Администратор %s[%d] мгновенно выкупил бизнес ID %d за %d руб.",
        GetPlayerNameEx(playerid), playerid, businessid, price);
    SendMessageToAdmins(message, 0x999999FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return 1;
}
CMD:asellfuel(playerid, params[])
{
	if (GetPlayerAdminEx(playerid) != 6) {
		return 0;
	}
	extract params -> new i; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /asellfuel [id заправки]");

	new
		query[180];
	//if(!GetFuelStationData(i, FS_EVICTION)) continue;
	//if(GetFuelStationData(i, FS_RENT_DATE) < cur_time) continue;

	format(query, sizeof query, "UPDATE fuel_stations SET owner_id='0',fuels='1000',fuel_price='3',lock='0',eviction='0' WHERE id='%d'", GetFuelStationData(i, FS_SQL_ID));
	mysql_query(mysql, query, false);

	new owner_player = GetPlayerIDBySqlID(GetFuelStationData(i, FS_OWNER_ID));
	if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
		SetPlayerData(owner_player, P_FUEL_ST, -1);
		format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
		mysql_query(mysql, query, false);
	}
					else {
		format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", GetFuelStationData(i, FS_OWNER_ID));
		mysql_query(mysql, query, false);
	}

	SetFuelStationData(i, FS_OWNER_ID, 0);
	SetFuelStationData(i, FS_IMPROVEMENTS, 0);

	SetFuelStationData(i, FS_EVICTION, 0);

	SetFuelStationData(i, FS_FUELS, 		1000);
	SetFuelStationData(i, FS_FUEL_PRICE,	3);
	SetFuelStationData(i, FS_BUY_FUEL_PRICE,0);

	SetFuelStationData(i, FS_BALANCE,		0);
	SetFuelStationData(i, FS_RENT_DATE,		0);
	SetFuelStationData(i, FS_LOCK_STATUS,	false);
	CallLocalFunction("UpdateFuelStationLabel", "i", i);
	return 1;
}

CMD:mtop(playerid)
{
	new fmt_str[3000];
    format
	(
		fmt_str, sizeof fmt_str,
		""c_b"Получай Донат-Коины за игру на сервере!\n\
		\n\
		Каждый месяц топ 1 игроки будут получать вознаграждение, список вознаграждений\n\
		можно посмотреть с помощью команды: "c_s"/mpriz\n\
		"c_b"Так же, каждый месяц список топ-игроков будет обнуляться.\n\
		\n\
		"c_i"1. "c_b"ТОП: Заработанных денег на начальных работах.\n\
		\tЗарабатывая деньги на начальных работах, Вы будете увеличивать прогресс данного этапа.\n\
		\t"c_i"Список работ: "c_b"Грузчик, Шахтер, Завод, Лесоруб.\n\
		\n\
		"c_i"2. "c_b"ТОП: Заработанных денег на гос. работах.\n\
		\tЗарабатывая деньги на гос. работах, Вы будете увеличивать прогресс данного этапа.\n\
		\t"c_i"Список работ: "c_b"Водитель автобуса, Таксист, Механик.\n\
		\n\
		"c_i"3. "c_b"ТОП: Полученных PayDay\n\
		\tКаждый собранный PayDay, Вам будет прибавлять +1 к прогрессу данного этапа.\n\
		\t"c_i"Информация: "c_b"PayDay происходит каждый час. Например в 11:00, 12:00\n\
		\n\
		"c_i"4. "c_b"ТОП: Выполненных достижений\n\
		\tВыполняя достижения, Вы будете увеличивать прогресс данного этапа\n\
  		\t"c_s"/reward"c_b"- информация о достижениях и список достижений.\n\
  		\n\
		"c_i"5. "c_b"ТОП: Выполненных квестов\n\
		\tВыполняя квесты, Вы будете увеличивать прогресс данного этапа.\n\
		\t"c_s"/quest "c_b"- информация о квестах и список квестов."
	);

	Dialog(playerid, DIALOG_MTOP, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Информация", fmt_str, "Далее", "Закрыть");
	return 1;
}

stock MtopMenu(playerid)
{
    Dialog
	(
		playerid, DIALOG_MTOP_MENU, DIALOG_STYLE_LIST,
		"Меню ТОП-Игроков",
		""c_server"1. "c_i"ТОП: "c_b"Заработанных денег на начальных работах\n"\
		""c_server"2. "c_i"ТОП: "c_b"Заработанных денег на гос. работах\n"\
		""c_server"3. "c_i"ТОП: "c_b"Полученных PayDay\n"\
		""c_server"4. "c_i"ТОП: "c_b"Выполненных достижений\n"\
		""c_server"5. "c_i"ТОП: "c_b"Выполненных квестов\n"\
	    ""c_i"ТОП Игроки по скиллам на работах",
		"Выбрать", "Закрыть"
	);
	return 1;
}

CMD:top_salary_new_work(playerid)
{
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY TOP_SalaryNewWork DESC LIMIT 25");
	mysql_tquery(mysql, string, "TopSalaryNewWork", "d",playerid);

	return 1;
}

CMD:top_salary_gos_work(playerid)
{
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY TOP_SalaryGosWork DESC LIMIT 25");
	mysql_tquery(mysql, string, "TopSalaryGovWork", "d",playerid);

	return 1;
}

public: TopSalaryNewWork(playerid)
{
	new name[24], top,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			top = 0;
			cache_get_field_content(i, "name", name, mysql);
			top = cache_get_field_content_int(i, "TOP_SalaryNewWork", mysql);
			format(string, sizeof(string), "%s\n"c_b" %s: "c_i"%d", string, name, top);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Заработанных денег на начальных работах", string, "Закрыть", "");

	return 1;
}

public: TopSalaryGovWork(playerid)
{
	new name[24], top,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			top = 0;
			cache_get_field_content(i, "name", name, mysql);
			top = cache_get_field_content_int(i, "TOP_SalaryGosWork", mysql);
			format(string, sizeof(string), "%s\n"c_b" %s: "c_i"%d", string, name, top);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Заработанных денег на гос. работах", string, "Закрыть", "");

	return 1;
}

public: TopPayDay(playerid)
{
	new name[24], top,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			top = 0;
			cache_get_field_content(i, "name", name, mysql);
			top = cache_get_field_content_int(i, "TOP_PayDay", mysql);
			format(string, sizeof(string), "%s\n"c_b" %s: "c_i"%d", string, name, top);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Полученных PayDay", string, "Закрыть", "");

	return 1;
}

CMD:top_payday(playerid)
{
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY TOP_PayDay DESC LIMIT 25");
	mysql_tquery(mysql, string, "TopPayDay", "d",playerid);

	return 1;
}

public: TopQuest(playerid)
{
	new name[24], top,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			top = 0;
			cache_get_field_content(i, "name", name, mysql);
			top = cache_get_field_content_int(i, "TOP_Quest", mysql);
			format(string, sizeof(string), "%s\n"c_b" %s: "c_i"%d", string, name, top);
			strcat(string, string, 0);
		}
	}
	
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Выполненных квестов", string, "Закрыть", "");
	return 1;
}

CMD:top_quest(playerid)
{
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY TOP_Quest DESC LIMIT 25");
	mysql_tquery(mysql, string, "TopQuest", "d",playerid);

	return 1;
}

CMD:mpriz(playerid)
{
    Top1PlayerAndPriz(playerid);

	return 1;
}

public: Top1PlayerAndPriz(playerid)
{
	new string[400];


	format(string, sizeof(string),
	""c_i"1. "c_b"2000 донат-рублей.\n\
	"c_i"2. "c_b"2000 донат-рублей.\n\
	"c_i"3. "c_b"1500 донат-рублей.\n\
	"c_i"4. "c_b"2000 донат-рублей.\n\
	"c_i"5. "c_b"1000 донат-рублей."
	);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Награды", string, "Закрыть", "");

	return 1;
}

public: TopProgress(playerid)
{
	new name[24], top,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			top = 0;
			cache_get_field_content(i, "name", name, mysql);
			top = cache_get_field_content_int(i, "TOP_Progress", mysql);
			format(string, sizeof(string), "%s\n"c_b" %s: "c_i"%d", string, name, top);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, ""c_i"ТОП: "c_b"Выполненных достижений", string, "Закрыть", "");

	return 1;
}

CMD:top_progress(playerid)
{
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY TOP_Progress DESC LIMIT 25");
	mysql_tquery(mysql, string, "TopProgress", "d",playerid);

	return 1;
}

CMD:placeboomboxx(playerid, params[])
{
    new string[128], Float:BBCoord[4], pName[MAX_PLAYER_NAME];
    GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
    GetPlayerFacingAngle(playerid, BBCoord[3]);
    SetPVarFloat(playerid, "BBX", BBCoord[0]);
    SetPVarFloat(playerid, "BBY", BBCoord[1]);
    SetPVarFloat(playerid, "BBZ", BBCoord[2]);
    GetPlayerName(playerid, pName, sizeof(pName));
    BBCoord[0] += (2 * floatsin(-BBCoord[3], degrees));
   	BBCoord[1] += (2 * floatcos(-BBCoord[3], degrees));
   	BBCoord[2] -= 1.0;
	//if(Boombox[playerid] == 0) return SCM(playerid, COLOR_WHITE, "You don't have a Boombox - Ask a Admin for one"); // Part of Variable
	if(GetPVarInt(playerid, "PlacedBB")) return SCM(playerid, -1, "Вы уже поставили бумбокс");
	foreach(Player, i)
	{
 		if(GetPVarType(i, "PlacedBB"))
   		{
  			if(IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ")))
			{
   				SendClientMessage(playerid, COLOR_WHITE, "Вы не можете поместить свой бумбокс в этом месте, так как в этом месте уже есть бумбокс.");
			    return 1;
			}
		}
	}
	new string2[128];
	format(string2, sizeof(string2), "%s поставил бумбокс", pName);
	SendNearbyMessage(playerid, 15, string2, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	SetPVarInt(playerid, "PlacedBB", 0);
	format(string, sizeof(string), "{FF0000} Магнитофон\n {FFFFFF}Установил: {FF0000} %s \n {FFFFFF} Играет:\n {ff0000} Новое радио", pName);
	SetPVarInt(playerid, "BBLabel", _:CreateDynamic3DTextLabel(string, -1, BBCoord[0], BBCoord[1], BBCoord[2]+0.6, 5, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
	SetPVarInt(playerid, "BBArea", CreateDynamicSphere(BBCoord[0], BBCoord[1], BBCoord[2], 30.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
	SetPVarInt(playerid, "BBInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "BBVW", GetPlayerVirtualWorld(playerid));
	ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
	return 1;
}

CMD:boombox(playerid)
{
    if(GetPlayerData(playerid, P_BOOMBOX) == 1)
    {
		Dialog(playerid, DIALOG_BOOMBOX_MENU, DIALOG_STYLE_LIST,"Меню BoomBox",
		""c_b"Поставить BoomBox\n\
		Забрать BoomBox\n\
		Включить BoomBox\n\
		Выключить BoomBox",
		"Далее", "Закрыть");
	}
					else
	    return Send(playerid,-1,"У вас нет бумбокса");
	    
	return 1;

}

CMD:setboomboxx(playerid, params[])
{
	if(GetPVarType(playerid, "PlacedBB"))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
		{
			Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Меню BoomBox",
			""c_b"Радиостанции\n\
			"c_b"Музыкант: "c_s"Макс Корж\n\
			"c_b"Музыканты: "c_s"Miyagi & Эндшпиль\n\
			"c_b"Музыкант: "c_s"Канги",
			/*Мэвл\n\
			Канги\n\
			Country\n\
			Morgenshtern\n\
			Slava Marlow\n\
			VAVAN\n\
			Выключить",*/
			"Далее", "Закрыть");
		}
					else
		{
   			return SendClientMessage(playerid, -1, "Вы далеко от своего BoomBox!");
		}
    }
					else
    {
        SendClientMessage(playerid, -1, "Вы не поставили BoomBox!");
	}
	return 1;
}

CMD:placeboomboxxx(playerid, params [])
{

	PickUpBoombox(playerid);

}

stock StopStream(playerid)
{
	DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

stock PlayStream(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(GetPVarType(playerid, "pAudioStream")) StopAudioStreamForPlayer(playerid);
	else SetPVarInt(playerid, "pAudioStream", 1);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

stock PickUpBoombox(playerid)
{
    foreach(Player, i)
	{
 		if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
   		{
     		StopStream(i);
		}
	}
	//DeletePVar(playerid, "BBArea");
	DeletePVar(playerid, "PlacedBB");
	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
	DeletePVar(playerid, "PlacedBB"); DeletePVar(playerid, "BBLabel");
 	DeletePVar(playerid, "BBX"); DeletePVar(playerid, "BBY"); DeletePVar(playerid, "BBZ");
	DeletePVar(playerid, "BBInt");
	DeletePVar(playerid, "BBVW");
	DeletePVar(playerid, "BBStation");
	return 1;
}

stock SendNearbyMessage(playerid, Float:radius, const string[], col1, col2, col3, col4, col5)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	new Float:ix, Float:iy, Float:iz;
	new Float:cx, Float:cy, Float:cz;
	foreach(Player, i)
	{
 		if(gPlayerLoggin{i})
	    {
	        if(GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	        {
				GetPlayerPos(i, ix, iy, iz);
				cx = (x - ix);
				cy = (y - iy);
				cz = (z - iz);
				if(((cx < radius/16) && (cx > -radius/16)) && ((cy < radius/16) && (cy > -radius/16)) && ((cz < radius/16) && (cz > -radius/16)))
				{
				    SendClientMessage(i, col1, string);
				}
					else if(((cx < radius/8) && (cx > -radius/8)) && ((cy < radius/8) && (cy > -radius/8)) && ((cz < radius/8) && (cz > -radius/8)))
				{
				    SendClientMessage(i, col2, string);
				}
					else if(((cx < radius/4) && (cx > -radius/4)) && ((cy < radius/4) && (cy > -radius/4)) && ((cz < radius/4) && (cz > -radius/4)))
				{
				    SendClientMessage(i, col3, string);
				}
					else if(((cx < radius/2) && (cx > -radius/2)) && ((cy < radius/2) && (cy > -radius/2)) && ((cz < radius/2) && (cz > -radius/2)))
				{
				    SendClientMessage(i, col4, string);
				}
					else if(((cx < radius) && (cx > -radius)) && ((cy < radius) && (cy > -radius)) && ((cz < radius) && (cz > -radius)))
				{
				    SendClientMessage(i, col5, string);
				}
			}
	    }
	}
	return 1;
}
