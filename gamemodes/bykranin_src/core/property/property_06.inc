//>> Файл: bykranin_src/core/property/property_06.inc  (941 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: FuelStationImprovementsPrice, GetVinylNameById, ShowPlayerFuelStationPayForRent, /paybizrent, ShowPlayerBusinessPayForRent, ShowPlayerNewPropertyPayForRent, ShowPlayerHousePayForRent
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).

stock FuelStationImprovementsPrice(stationid)
{
	new price;
	new level = GetFuelStationData(stationid, FS_IMPROVEMENTS);

	if(1 <= level <= sizeof g_fuel_station_improvements)
	{
		for(new idx; idx < level; idx ++)
		{
			price += g_fuel_station_improvements[idx][I_PRICE];
		}
	}
	return price;
}

stock bool:GetVinylNameById(vinylId, outName[], outLen)
{
    if (outLen <= 0) return false;
    outName[0] = '\0';

    switch (vinylId)
    {
        case 0:  return format(outName, outLen, "remapbody8"), true;
        case 1:  return format(outName, outLen, "remapbody5"), true;
        case 2:  return format(outName, outLen, "remapbody32"), true;
        case 3:  return format(outName, outLen, "remapbody40"), true;
        case 4:  return format(outName, outLen, "remapbody21"), true;
        case 5:  return format(outName, outLen, "remapbody29"), true;
        case 6:  return format(outName, outLen, "remapbody41"), true;
        case 7:  return format(outName, outLen, "remapbody6"), true;
        case 8:  return format(outName, outLen, "remapbody31"), true;
        case 9:  return format(outName, outLen, "remapbody19"), true;
        case 10: return format(outName, outLen, "remapbody28"), true;
        case 11: return format(outName, outLen, "remapbody30"), true;
        case 12: return format(outName, outLen, "remapbody11"), true;
        case 13: return format(outName, outLen, "remapbody12"), true;
        case 14: return format(outName, outLen, "remapbody15"), true;
        case 15: return format(outName, outLen, "remapbody26"), true;
        case 16: return format(outName, outLen, "remapbody16"), true;
        case 17: return format(outName, outLen, "remapbody13"), true;
        case 18: return format(outName, outLen, "remapbody18"), true;
        case 19: return format(outName, outLen, "remapbody35"), true;
        case 20: return format(outName, outLen, "remapbody10"), true;
        case 21: return format(outName, outLen, "remapbody17"), true;
        case 22: return format(outName, outLen, "remapbody38"), true;
        case 23: return format(outName, outLen, "remapbody2"), true;
        case 24: return format(outName, outLen, "remapbody23"), true;
        case 25: return format(outName, outLen, "remapbody36"), true;
        case 26: return format(outName, outLen, "remapbody4"), true;
        case 27: return format(outName, outLen, "remapbody14"), true;
        case 28: return format(outName, outLen, "remapbody37"), true;
        case 29: return format(outName, outLen, "remapbody20"), true;
        case 30: return format(outName, outLen, "remapbody7"), true;
        case 31: return format(outName, outLen, "remapbody25"), true;
        case 32: return format(outName, outLen, "remapbody39"), true;
        case 33: return format(outName, outLen, "remapbody1"), true;
        case 34: return format(outName, outLen, "remapbody33"), true;
        case 35: return format(outName, outLen, "remapbody9"), true;
        case 36: return format(outName, outLen, "remapbody22"), true;
        case 37: return format(outName, outLen, "remapbody24"), true;
        case 38: return format(outName, outLen, "remapbody34"), true;
        case 39: return format(outName, outLen, "remapbody42"), true;
        case 40: return format(outName, outLen, "remapbody47"), true;
        case 41: return format(outName, outLen, "remapbody48"), true;
        case 42: return format(outName, outLen, "remapbody43"), true;
        case 43: return format(outName, outLen, "remapbody44"), true;
        case 44: return format(outName, outLen, "remapbody49"), true;
        case 45: return format(outName, outLen, "remapbody51"), true;
        case 46: return format(outName, outLen, "remapbody45"), true;
        case 47: return format(outName, outLen, "remapbody46"), true;
		case 48: return format(outName, outLen, "remaphbody1"), true;
        case 49: return format(outName, outLen, "remaphbody2"), true;
        case 50: return format(outName, outLen, "remaphbody3"), true;
        case 51: return format(outName, outLen, "remaphbody4"), true;
        case 52: return format(outName, outLen, "remaphbody5"), true;
        case 53: return format(outName, outLen, "remaphbody6"), true;
        case 54: return format(outName, outLen, "remaphbody7"), true;
        case 55: return format(outName, outLen, "remaphbody8"), true;
        case 56: return format(outName, outLen, "remaphbody9"), true;
        case 57: return format(outName, outLen, "remaphbody10"), true;
        case 58: return format(outName, outLen, "remaphbody11"), true;

        case 59: return format(outName, outLen, "remapnbody1"), true;
        case 60: return format(outName, outLen, "remapnbody2"), true;
        case 61: return format(outName, outLen, "remapnbody3"), true;
        case 62: return format(outName, outLen, "remapnbody4"), true;
        case 63: return format(outName, outLen, "remapnbody5"), true;
        case 64: return format(outName, outLen, "remapnbody6"), true;
        case 65: return format(outName, outLen, "remapnbody7"), true;
        case 66: return format(outName, outLen, "remapnbody8"), true;
        case 67: return format(outName, outLen, "remapnbody9"), true;
        case 68: return format(outName, outLen, "remapnbody10"), true;
        case 69: return format(outName, outLen, "remapnbody11"), true;
        case 70: return format(outName, outLen, "remapnbody12"), true;
        case 71: return format(outName, outLen, "remapnbody13"), true;
        case 72: return format(outName, outLen, "remapnbody14"), true;
        case 73: return format(outName, outLen, "remapnbody15"), true;
        case 74: return format(outName, outLen, "remapnbody16"), true;
        case 75: return format(outName, outLen, "remapnbody17"), true;

        case 76: return format(outName, outLen, "remapmbody1"), true;
        case 77: return format(outName, outLen, "remapmbody2"), true;
        case 78: return format(outName, outLen, "remapmbody3"), true;
        case 79: return format(outName, outLen, "remapmbody4"), true;
        case 80: return format(outName, outLen, "remapmbody5"), true;
        case 81: return format(outName, outLen, "remapmbody6"), true;
        case 82: return format(outName, outLen, "remapmbody7"), true;
        case 83: return format(outName, outLen, "remapmbody8"), true;
        case 84: return format(outName, outLen, "remapmbody9"), true;
        case 85: return format(outName, outLen, "remapmbody10"), true;
        case 86: return format(outName, outLen, "remapmbody11"), true;
        case 87: return format(outName, outLen, "remapmbody12"), true;
        case 88: return format(outName, outLen, "remapmbody13"), true;
        case 89: return format(outName, outLen, "remapmbody14"), true;
        case 90: return format(outName, outLen, "remapmbody15"), true;
        case 91: return format(outName, outLen, "remapmbody16"), true;
        case 92: return format(outName, outLen, "remapmbody17"), true;

        // Обрати внимание: в JSON есть разрыв (после 92 сразу 110)
        case 110: return format(outName, outLen, "remapnbody18"), true;
        case 111: return format(outName, outLen, "remapnbody19"), true;
        case 112: return format(outName, outLen, "remapnbody20"), true;
        case 113: return format(outName, outLen, "remapnbody21"), true;
        case 114: return format(outName, outLen, "remapnbody22"), true;
        case 115: return format(outName, outLen, "remapnbody23"), true;
        case 116: return format(outName, outLen, "remapnbody24"), true;
        case 117: return format(outName, outLen, "remapnbody25"), true;
        case 118: return format(outName, outLen, "remapnbody26"), true;
        case 119: return format(outName, outLen, "remapnbody27"), true;
        case 277: return format(outName, outLen, "remapstobody0"), true;
        case 278: return format(outName, outLen, "remapstobody1"), true;
        case 279: return format(outName, outLen, "remapstobody2"), true;
        case 280: return format(outName, outLen, "remapstobody3"), true;
        case 281: return format(outName, outLen, "remapstobody4"), true;
    }
    return false;
}
stock ShowPlayerFuelStationPayForRent(playerid)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		new fmt_str[256];

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Заправочная станция:\t\t№%d (%s)\n"\
			"Оплаченных дней арендны:\t\t%d из 30\n"\
			"Ежедневная арендная плата:\t%d руб\n"\
			"Тип аренды:\t\t\t\t%s\n\n"\
			"На сколько дней Вы хотите арендовать заправочную станцию?",
			stationid,
			GetFuelStationData(stationid, FS_NAME),
			GetElapsedTime(GetFuelStationData(stationid, FS_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? GetFuelStationData(stationid, FS_RENT_PRICE) : GetFuelStationData(stationid, FS_RENT_PRICE) / 2,
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? ("Полная") : ("Пониженная")
		);
		Dialog(playerid, DIALOG_PAY_FOR_RENT_FUEL_ST, DIALOG_STYLE_INPUT, "{66CC00}Аренда заправочной станции", fmt_str, "Оплатить", "Назад");
	}
}
CMD:paybizrent(playerid, params[])
{
    new business_count = GetPlayerBusinessCount(playerid);

    if(!business_count)
    {
        return SendClientMessage(playerid,
        0x999999FF,
        "У Вас нет бизнеса");
    }

    if(business_count == 1)
    {
        for(new i = 0; i < MAX_BUSINESS; i++)
        {
            if(GetBusinessData(i, B_OWNER_ID) == GetPlayerAccountID(playerid))
            {
                SetSelectedBusiness(playerid, i);
                ShowPlayerBusinessPayForRent(playerid);
                return 1;
            }
        }
    }

    new string[512];
    string = "{FFFFFF}ID\tНазвание\n";

    for(new i = 0; i < MAX_BUSINESS; i++)
    {
        if(GetBusinessData(i, B_OWNER_ID) == GetPlayerAccountID(playerid))
        {
            new fmt[128];

            format(fmt, sizeof fmt,
            "%d\t%s\n",
            i,
            GetBusinessData(i, B_NAME));

            strcat(string, fmt);
        }
    }

    Dialog(
        playerid,
        DIALOG_BIZ_RENT_SELECT,
        DIALOG_STYLE_TABLIST_HEADERS,
        "{33AACC}Выбор бизнеса",
        string,
        "Выбрать",
        "Закрыть"
    );

    return 1;
}
stock ShowPlayerBusinessPayForRent(playerid)
{
	new businessid = GetSelectedBusiness(playerid);
	if(businessid != -1)
	{
		new fmt_str[256];

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Бизнес:\t\t\t\t№%d (%s)\n"\
			"Оплаченных дней арендны:\t\t%d из 30\n"\
			"Ежедневная арендная плата:\t%d руб\n"\
			"Тип аренды:\t\t\t\t%s\n\n"\
			"На сколько дней Вы хотите арендовать бизнес?",
			businessid,
			GetBusinessData(businessid, B_NAME),
			GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			5000,
			GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Пониженная")
		);
		Dialog(playerid, DIALOG_PAY_FOR_RENT_BIZ, DIALOG_STYLE_INPUT, "{66CC00}Аренда бизнеса", fmt_str, "Оплатить", "Назад");
	}
}

stock ShowPlayerNewPropertyPayForRent(playerid, bool:is_flat, property_id)
{
	new accountid = GetPlayerAccountID(playerid);
	new fmt_str[512];

	if(!is_flat)
	{
		if(!(0 <= property_id < HOUSES_FOR_SALE_COUNT) || !gHouseOwned[property_id] || gHouseOwnerID[property_id] != accountid)
			return 0;

		new house_type_idx = GetHouseData(gHouseType[property_id]);
		new rent_days = GetNewPropertyRentDaysLeft(gHouseRentTime[property_id]);
		new rent_price = GetNewHouseRentPrice(property_id);

		format(fmt_str, sizeof fmt_str,
			"{FFFFFF}Дом:\t\t\t\t\t№%d (%s)\n"\
			"Оплачено дней:\t\t\t%d из 30\n"\
			"Стоимость налога:\t\t%d руб в день\n"\
			"На банковском счете:\t\t%d руб\n\n"\
			"На сколько дней вы хотите оплатить налог?",
			property_id + 3000,
			HouseData[house_type_idx][hName],
			rent_days,
			rent_price,
			GetPlayerBankMoney(playerid)
		);
		SetPlayerNewPropertyPayContext(playerid, 1, property_id);
		Dialog(playerid, DIALOG_PAY_FOR_RENT_HOUSE, DIALOG_STYLE_INPUT, "{66CC00}Оплата дома", fmt_str, "Оплатить", "Назад");
		return 1;
	}

	if(!(0 <= property_id < 200000) || !gFlatOwned[property_id] || gFlatOwnerID[property_id] != accountid)
		return 0;

	new real_flatid = g_flat_real_id[property_id];
	new flat_houseid = real_flatid / 1000;
	new floor = (real_flatid % 1000) / 10;
	new flatidx = (real_flatid % 10) + (4 * (floor - 1));
	new flat_type_idx = gFlatType[flat_houseid] - 1;
	new rent_days = GetNewPropertyRentDaysLeft(gFlatRentTime[property_id]);
	new rent_price = GetNewFlatRentPrice(property_id);

	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Квартира:\t\t\t№%d-%d (%s)\n"\
		"Оплачено дней:\t\t\t%d из 30\n"\
		"Стоимость налога:\t\t%d руб в день\n"\
		"На банковском счете:\t\t%d руб\n\n"\
		"На сколько дней вы хотите оплатить налог?",
		flat_houseid + 100,
		flatidx,
		FlatData[flat_type_idx][hName],
		rent_days,
		rent_price,
		GetPlayerBankMoney(playerid)
	);
	SetPlayerNewPropertyPayContext(playerid, 2, property_id);
	Dialog(playerid, DIALOG_PAY_FOR_RENT_HOUSE, DIALOG_STYLE_INPUT, "{66CC00}Оплата квартиры", fmt_str, "Оплатить", "Назад");
	return 1;
}

stock ShowPlayerHousePayForRent(playerid)
{
	ClearPlayerNewPropertyPayContext(playerid);

	new accountid = GetPlayerAccountID(playerid);
	new selected = GetPlayerData(playerid, P_HOUSE_SELECTED);
	new bool:selected_is_flat;
	new selected_property = DecodeSelectedHouseProperty(selected, selected_is_flat);

	// В первую очередь оплачиваем именно выбранную игроком новую недвижимость.
	if(ShowPlayerNewPropertyPayForRent(playerid, selected_is_flat, selected_property))
		return 1;

	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new fmt_str[256];

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Дом:\t\t\t\t\t№%d (%s)\n"\
			"Оплаченных дней арендны:\t\t%d из 30\n"\
			"Ежедневная квартплата:\t\t%d руб\n"\
			"Субсидия:\t\t\t\t%s\n\n"\
			"На сколько дней Вы хотите оплатить дом?",
			houseid,
			GetHouseData(houseid, H_NAME),
			30,
			GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? GetHouseData(houseid, H_RENT_PRICE) : GetHouseData(houseid, H_RENT_PRICE) / 2,
			GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? ("Нет") : ("Есть")
		);
		Dialog(playerid, DIALOG_PAY_FOR_RENT_HOUSE, DIALOG_STYLE_INPUT, "{66CC00}Оплата дома", fmt_str, "Оплатить", "Назад");
	}
	else
	{
		new new_houseid = GetHouseNewByOwner(accountid, playerid);
		if(new_houseid != -1)
			return ShowPlayerNewPropertyPayForRent(playerid, false, new_houseid);

		new flatid = GetFlatNewByOwner(accountid, playerid);
		if(flatid != -1)
			return ShowPlayerNewPropertyPayForRent(playerid, true, flatid);

		ClearPlayerNewPropertyPayContext(playerid);
	}
	return 1;
}

stock SellBusiness(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
	new businessid = GetPlayerBusiness(playerid);

	if(businessid != -1)
	{
		new biz_price = GetBusinessData(businessid, B_PRICE);
		new biz_percent = (biz_price * 30) / 100;
		new biz_improvemnts_price = BusinessImprovementsPrice(businessid);

		if(biz_improvemnts_price)
			biz_improvemnts_price = (biz_improvemnts_price * 60) / 100;

		new query[200];
		new return_money = (biz_price - biz_percent) + biz_improvemnts_price;

		SetPlayerData(playerid, P_BUSINESS, -1);

		SetBusinessData(businessid, B_OWNER_ID, 0);

		if(to_player == INVALID_PLAYER_ID)
		{
			AddPlayerData(playerid, P_BANK, +, return_money);

			BankLog(playerid, return_money, "Продажа бизнеса");

			SetBusinessData(businessid, B_IMPROVEMENTS, 	0);
				SetBusinessData(businessid, B_RENT_PRICE, 	5000);

			SetBusinessData(businessid, B_PRODS, 			0);
			SetBusinessData(businessid, B_PROD_PRICE,		0);

			SetBusinessData(businessid, B_BALANCE,			0);
			SetBusinessData(businessid, B_RENT_DATE,		0);
			SetBusinessData(businessid, B_ENTER_MUSIC,		0);
			SetBusinessData(businessid, B_LOCK_STATUS,	false);

			BusinessHealthPickupInit(businessid);

			format(query, sizeof query, "UPDATE accounts a,business b SET a.bank=%d,a.business=-1,b.owner_id=0,b.products=0,b.prod_price=0,b.lock=0 WHERE a.id=%d AND b.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
			mysql_query(mysql, query, false);

			format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", businessid);
			mysql_query(mysql, query, false);

			g_business_gps_init = false;

			//format(query, sizeof query, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(businessid, B_SQL_ID));
			//mysql_query(mysql, query, false);

			GivePlayerMoneyEx(playerid, 0, "Продажа бизнеса государству", false, false);
			CallLocalFunction("UpdateBusinessLabel", "i", businessid);

			SendClientMessage(playerid, 0x66CC00FF, "Вы продали свой бизнес!");

			format(query, sizeof query, "Налог за продажу бизнеса составил 30 процентов от его стоимости {99CC00}(%d руб)", biz_percent);
			SendClientMessage(playerid, 0xCECECEFF, query);

			format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {CCFF00}%d руб", biz_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);

			format(query, sizeof query, "Итого на банковский счет перечислено: {3399FF}%d руб", return_money);
			SendClientMessage(playerid, 0xFFFFFFFF, query);
		}
					else
		{
			if(BuyPlayerBusiness(to_player, businessid, true, price) == 1)
			{
				new total_price = price + biz_improvemnts_price;

				format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {CCFF00}%d руб", biz_improvemnts_price);
				SendClientMessage(playerid, 0xCECECEFF, query);

				format(query, sizeof query, "UPDATE accounts SET money=%d,business=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);

				format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", businessid);
				mysql_query(mysql, query, false);

				g_business_gps_init = false;
				GivePlayerMoneyEx(playerid, total_price, "Продажа бизнеса игроку", false, false);

				biz_price = price;
				biz_percent = 0;
			}
					else return ;
		}
		format(query, sizeof query, "~g~+%d rub~n~+%d rub", (biz_price - biz_percent), biz_improvemnts_price);
		GameTextForPlayer(playerid, query, 4000, 1);
	}
}

stock BuyPlayerBusiness(playerid, businessid, bool: buy_from_owner = false, price = -1)
{
	if(businessid < 0 || businessid >= g_business_loaded || IsBusinessOnAuction(businessid)) return -1;
	new business_count = GetPlayerBusinessCount(playerid);
	new max_business = 1 + GetPlayerData(playerid, P_BUSS_SLOTS);
	if(max_business > 2)
	{
		max_business = 2;
	}

	if(!IsBusinessOwned(businessid) && business_count < max_business)
	{
		if(price <= 0)
			price = GetBusinessData(businessid, B_PRICE);
		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[256];
			mysql_query(mysql, "START TRANSACTION", false);
			if(mysql_errno()) return 0;

			mysql_format(mysql, query, sizeof query,
				"UPDATE business SET owner_id=%d,ownership_started_at=%d WHERE id=%d AND owner_id=0 LIMIT 1",
				GetPlayerAccountID(playerid), gettime(), GetBusinessData(businessid, B_SQL_ID));
			if(!AuctionDatabaseExecuteAffected(query))
			{
				mysql_query(mysql, "ROLLBACK", false);
				return 0;
			}

			mysql_format(mysql, query, sizeof query,
				"UPDATE accounts SET money=money-%d,business=%d WHERE id=%d AND money>=%d LIMIT 1",
				price, businessid, GetPlayerAccountID(playerid), price);
			if(!AuctionDatabaseExecuteAffected(query))
			{
				mysql_query(mysql, "ROLLBACK", false);
				return 0;
			}
			mysql_query(mysql, "COMMIT", false);

			if(!mysql_errno())
			{
				SetPlayerData(playerid, P_BUSINESS, businessid);

				SetBusinessData(businessid, B_OWNER_ID, GetPlayerAccountID(playerid));
				SetBusinessData(businessid, B_IMPROVEMENTS, 	0);
				SetBusinessData(businessid, B_RENT_PRICE, 	5000);

				new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;

				if(!buy_from_owner)
				{
					SetBusinessData(businessid,	B_PRODS, 		10_000);
					SetBusinessData(businessid,	B_PROD_PRICE, 	0);

					SetBusinessData(businessid,	B_ENTER_MUSIC, 	0);
					SetBusinessData(businessid,	B_ENTER_PRICE, 	0);

					SetBusinessData(businessid,	B_BALANCE, 		0);
					SetBusinessData(businessid,	B_RENT_DATE,	rent_time);
					SetBusinessData(businessid,	B_LOCK_STATUS,	false);
				}
				else
				{
					SetBusinessData(businessid, B_PRODS, 10_000);
					if(GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetBusinessData(businessid, B_RENT_DATE, rent_time);
					}
				}
				format(g_business[businessid][B_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateBusinessLabel", "i", businessid);

				GivePlayerMoneyEx(playerid, -price, "Покупка бизнеса", false, true);
				SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/business {66CC00}чтобы узнать о возможностях");

				format(query, sizeof query, "UPDATE business SET improvements=0,products=%d,prod_price=%d,balance=%d,rent_time=%d,rent_price=5000,`lock`=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_RENT_DATE), GetBusinessData(businessid, B_LOCK_STATUS), GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);

				format(query, sizeof query, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);

				return 1;
			}
			SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 21)");
			return 0;
		}
		return 0;
	}
	return -1;
}

stock BusinessHealthPickupInit(businessid)
{
    if(GetBusinessData(businessid, B_IMPROVEMENTS) >= 2)
    {
        if(!GetBusinessData(businessid, B_HEALTH_PICKUP))
        {
            new interior = GetBusinessData(businessid, B_INTERIOR);

            if(!IsValidBusinessInteriorId(interior))
            {
                printf("[biz] invalid interior %d for business %d type %d while creating health pickup", interior, businessid, GetBusinessData(businessid, B_TYPE));
                return 1;
            }

            SetBusinessData(businessid, B_HEALTH_PICKUP, CreatePickup(1240, 23, GetBusinessInteriorInfo(interior, BT_HEALTH_POS_X), GetBusinessInteriorInfo(interior, BT_HEALTH_POS_Y), GetBusinessInteriorInfo(interior, BT_HEALTH_POS_Z), businessid + 255, PICKUP_ACTION_TYPE_BIZ_HEALTH, businessid));
        }
    }
    else
    {
        if(GetBusinessData(businessid, B_HEALTH_PICKUP))
        {
            DestroyPickup(GetBusinessData(businessid, B_HEALTH_PICKUP));
            SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
        }
    }
    return 1;
}

stock GetBusinessEnterProdCount(businessid)
{
	new take_prods = 0;
	new enter_price = GetBusinessData(businessid, B_ENTER_PRICE);

	if(enter_price > 0)
	{
		if(enter_price < 150)
		{
			take_prods = 1;
		}
					else if(enter_price < 500)
		{
			take_prods = 2;
		}
					else take_prods = 3;
	}
	return take_prods;
}

stock GetBusinessMaxProd(businessid)
{
	#pragma unused businessid
	return 10_000;
}

stock GetNearestBusiness(playerid, Float: dist = 10.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;

	new businessid = -1;
	new Float: my_dist;

	for(new idx; idx < g_business_loaded; idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			businessid = idx;
		}
	}
	return businessid;
}

stock BusinessImprovementsPrice(businessid)
{
	new price;
	new level = GetBusinessData(businessid, B_IMPROVEMENTS);

	if(1 <= level <= sizeof g_business_improvements)
	{
		for(new idx; idx < level; idx ++)
		{
			price += g_business_improvements[idx][I_PRICE];
		}
	}
	return price;
}

stock EnterPlayerToBiz(playerid, businessid)
{
    if(GetPlayerInBiz(playerid) == -1)
    {
        new type = GetBusinessData(businessid, B_TYPE),
            buffer = GetBusinessData(businessid, B_INTERIOR);

        if(!IsValidBusinessInteriorId(buffer))
        {
            printf("[biz] invalid interior %d for business %d type %d", buffer, businessid, type);
            return 1;
        }

        if(type == BUSINESS_TYPE_CAR_TUNING)
        {
            new vehicleid = GetPlayerOwnableCar(playerid);

            if(vehicleid == INVALID_VEHICLE_ID)
                return 1;

            GetVehiclePos(vehicleid, vehicle_temp_position[playerid][0], vehicle_temp_position[playerid][1], vehicle_temp_position[playerid][2]);
            GetVehicleZAngle(vehicleid, vehicle_temp_position[playerid][3]);

            SetVehiclePos(vehicleid, 2503.6116,1503.9767,1497.8375);
            SetVehicleZAngle(vehicleid, 161.0);

            LinkVehicleToInterior(vehicleid, GetBusinessInteriorInfo(buffer, BT_ENTER_INTERIOR));
            SetVehicleVirtualWorld(vehicleid, businessid + 255);
        }

        SetPlayerPosEx
        (
            playerid,
            GetBusinessInteriorInfo(buffer, BT_ENTER_POS_X),
            GetBusinessInteriorInfo(buffer, BT_ENTER_POS_Y),
            GetBusinessInteriorInfo(buffer, BT_ENTER_POS_Z),
            GetBusinessInteriorInfo(buffer, BT_ENTER_ANGLE),
            GetBusinessInteriorInfo(buffer, BT_ENTER_INTERIOR),
            businessid + 255, false
        );
        SetPlayerInBiz(playerid, businessid);

        buffer = GetBusinessData(businessid, B_ENTER_MUSIC);

        if(1 <= buffer <= sizeof g_business_sound)
        {
            PlayerPlaySound(playerid, g_business_sound[buffer - 1], 0.0, 0.0, 0.0);
        }
    }
    return 1;
}

stock GetPlayerBusinessCount(playerid)
{
    new count = 0;

    for(new i = 0; i < MAX_BUSINESS; i++)
    {
        if(GetBusinessData(i, B_OWNER_ID) == GetPlayerAccountID(playerid))
        {
            count++;
        }
    }
    return count;
}
stock GetPlayerBusiness(playerid)
{
	new businessid = GetSelectedBusiness(playerid);

	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_OWNER_ID) == GetPlayerAccountID(playerid))
		{
			return businessid;
		}
	}

	businessid = GetPlayerData(playerid, P_BUSINESS);

	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_OWNER_ID) == GetPlayerAccountID(playerid))
		{
			SetSelectedBusiness(playerid, businessid);
			return businessid;
		}
	}

	for(new i = 0; i < MAX_BUSINESS; i++)
	{
		if(GetBusinessData(i, B_OWNER_ID) == GetPlayerAccountID(playerid))
		{
			SetSelectedBusiness(playerid, i);
			return i;
		}
	}
	return -1;
}

stock GetRecentSpawnStateIndex(account_id)
{
	if(account_id <= 0)
	{
		return -1;
	}

	new current_time = gettime();
	for(new idx = 0; idx < MAX_RECENT_SPAWN_STATES; idx++)
	{
		if(g_recent_spawn_account_id[idx] != account_id)
		{
			continue;
		}

		if((current_time - g_recent_spawn_time[idx]) > RECENT_SPAWN_EXPIRE_TIME)
		{
			g_recent_spawn_account_id[idx] = 0;
			g_recent_spawn_time[idx] = 0;
			return -1;
		}

		return idx;
	}
	return -1;
}

stock bool:HasRecentSpawnState(account_id)
{
	return GetRecentSpawnStateIndex(account_id) != -1;
}

stock SaveRecentSpawnState(playerid)
{
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0)
	{
		return 0;
	}

	new slot = GetRecentSpawnStateIndex(account_id);
	if(slot == -1)
	{
		slot = -1;
		new oldest_time = cellmax;

		for(new idx = 0; idx < MAX_RECENT_SPAWN_STATES; idx++)
		{
			if(g_recent_spawn_account_id[idx] == 0)
			{
				slot = idx;
				break;
			}

			if(g_recent_spawn_time[idx] < oldest_time)
			{
				oldest_time = g_recent_spawn_time[idx];
				slot = idx;
			}
		}
	}

	if(slot == -1)
	{
		return 0;
	}

	g_recent_spawn_account_id[slot] = account_id;
	g_recent_spawn_time[slot] = gettime();
	GetPlayerPos(playerid, g_recent_spawn_x[slot], g_recent_spawn_y[slot], g_recent_spawn_z[slot]);
	GetPlayerFacingAngle(playerid, g_recent_spawn_angle[slot]);
	g_recent_spawn_interior[slot] = GetPlayerInterior(playerid);
	g_recent_spawn_world[slot] = GetPlayerVirtualWorld(playerid);
	return 1;
}

stock bool:GetRecentSpawnState(account_id, &Float:spawn_x, &Float:spawn_y, &Float:spawn_z, &Float:spawn_angle, &spawn_interior, &spawn_world)
{
	new slot = GetRecentSpawnStateIndex(account_id);
	if(slot == -1)
	{
		return false;
	}

	spawn_x = g_recent_spawn_x[slot];
	spawn_y = g_recent_spawn_y[slot];
	spawn_z = g_recent_spawn_z[slot];
	spawn_angle = g_recent_spawn_angle[slot];
	spawn_interior = g_recent_spawn_interior[slot];
	spawn_world = g_recent_spawn_world[slot];
	return true;
}

stock RecreateBusinessEnterPickup(businessid)
{
	if(!(0 <= businessid < MAX_BUSINESS))
	{
		return 0;
	}

	if(g_business_enter_pickup[businessid] != 0)
	{
		DestroyPickup(g_business_enter_pickup[businessid]);
		g_business_enter_pickup[businessid] = 0;
	}

	if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CASINO)
	{
		return 1;
	}

    if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_SHOP_GUN)
    {
        return 1;
    }

    new modelid = GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CAR_MARKET || GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_SHOP_24_7 ? 19132 : 1318;
	g_business_enter_pickup[businessid] = CreatePickup(
		modelid,
		23,
		GetBusinessData(businessid, B_POS_X),
		GetBusinessData(businessid, B_POS_Y),
		GetBusinessData(businessid, B_POS_Z),
		0,
		PICKUP_ACTION_TYPE_BIZ_ENTER,
		businessid
	);
	return g_business_enter_pickup[businessid];
}

stock GetFreeBusinessCount()
{
	new count;
	for(new idx; idx < g_business_loaded; idx ++)
	{
		if(IsBusinessOwned(idx)) continue;

		count ++;
	}
	return count;
}

stock IsPlayerInBuyPosBiz(playerid, businessid, type, Float: radius = 50.0)
{
    if(GetBusinessData(businessid, B_TYPE) == type)
    {
        new interior = GetBusinessData(businessid, B_INTERIOR);

        if(!IsValidBusinessInteriorId(interior))
        {
            return 0;
        }

        if(IsPlayerInRangeOfPoint(playerid, radius, GetBusinessInteriorInfo(interior, BT_BUY_POS_X), GetBusinessInteriorInfo(interior, BT_BUY_POS_Y), GetBusinessInteriorInfo(interior, BT_BUY_POS_Z)))
        {
            return 1;
        }
    }
    return 0;
}

stock ShowPlayerRealtorHomeDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_BIZ_REALTOR_HOME_GET, DIALOG_STYLE_INPUT,
		"{99CC00}Информация о доме",
		"{FFFFFF}Введите номер дома, информацию\n"\
		"о котором Вы хотите получить\n\n"\
		"{FFCD00}Стоимость услуги 50 рублей",
		"Далее", "Отмена"
	);
}

stock IsABike(vehicleid)
{
	
	switch(GetVehicleData(vehicleid, V_MODELID))
	{
		case 481, 509, 510:
		{
			return 1;
		}
	}
	return 0;
}

stock IsModelHasBootAndBonnet(modelid)
{
	switch(modelid)
	{
		case 481,509,510,417,425,447,460,469,464,465,476,487,489,497,501,511,512,513,519,520,530,548,553,563,577,592,593: return 0;
	}
	return 1;
}

stock SetPlayerPhoneUseState(playerid, bool: use = true, bool: bubble = true)
{
	if(use)
	{
	//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, GetPlayerData(playerid, P_PHONE_COLOR) + 18865, A_OBJECT_BONE_RIGHT_HAND, 0.1, 0.001, 0.0, 280.0, 0.0, 200.0, 1.0, 1.0, 1.0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE - 1);

		if(bubble)
			Action(playerid, "достал телефон", _, false);
	}
					else
	{
	//	RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);

		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
}

