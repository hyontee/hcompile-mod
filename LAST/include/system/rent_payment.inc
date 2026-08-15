#if defined _RENT_PAYMENT_INC
	#endinput
#endif
#define _RENT_PAYMENT_INC

#if !defined DIALOG_BR_PAY_RENT_MAIN
	#define DIALOG_BR_PAY_RENT_MAIN   (19541)
	#define DIALOG_BR_PAY_RENT_HOUSE  (19550)
	#define DIALOG_BR_PAY_RENT_BIZ    (19551)
#endif

#define RENT_PAY_GOS_COOLDOWN_SEC   (86400)

forward Family_ClearHouseBySqlId(house_sql_id);
forward bool:RentPay_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

stock RentPay_GetMaxDays(playerid)
{
	if(Player[playerid][pVipType] == 3 && Player[playerid][pVipTime] > 0) return 30;
	if(Player[playerid][pVipType] == 2 && Player[playerid][pVipTime] > 0) return 14;
	return 7;
}

stock bool:RentPay_IsBuyable(eviction_ts)
{
	if(eviction_ts <= 0) return true;
	return gettime() >= eviction_ts;
}

stock RentPay_GetPaidDays(rent_time)
{
	new now = gettime();
	if(rent_time <= now) return 0;
	return GetElapsedTime(rent_time, now, CONVERT_TIME_TO_DAYS);
}

stock RentPay_ShowMainDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_BR_PAY_RENT_MAIN, DIALOG_STYLE_LIST,
		"{66CC00}Оплата",
		"1. Заплатить за дом\n"\
		"2. Оплатить аренду бизнеса",
		"Далее", "Отмена");
	return 1;
}

stock RentPay_ShowHouseDialog(playerid)
{
	new houseid = GetPlayerHouseSlot(playerid);
	if(houseid == -1)
	{
		SendClientMessage(playerid, 0x999999FF, "У Вас нет дома.");
		return 0;
	}

	new max_days = RentPay_GetMaxDays(playerid);
	new paid_days = RentPay_GetPaidDays(HouseInfo[houseid][hRentTime]);
	new daily = House_GetKvartplata(houseid);
	new type_name[32];
	GetHouseTypeName(houseid, type_name, sizeof type_name);

	new body[384];
	format(body, sizeof body,
		"{FFFFFF}Дом:\t\t\t\t№%d (%s)\n"\
		"Оплаченных дней аренды:\t\t%d из %d\n"\
		"Ежедневная квартплата:\t\t%d руб\n"\
		"Субсидия:\t\t\t\t%s\n\n"\
		"На сколько дней Вы хотите оплатить дом?",
		houseid + 1,
		type_name,
		paid_days,
		max_days,
		daily,
		HouseInfo[houseid][hImprovements] >= 4 ? ("Есть") : ("Нет"));

	ShowPlayerDialog(playerid, DIALOG_BR_PAY_RENT_HOUSE, DIALOG_STYLE_INPUT,
		"{66CC00}Оплата дома", body, "Оплатить", "Назад");
	return 1;
}

stock RentPay_ShowBusinessDialog(playerid)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid == -1)
	{
		SendClientMessage(playerid, 0x999999FF, "У Вас нет бизнеса.");
		return 0;
	}

	new max_days = RentPay_GetMaxDays(playerid);
	new paid_days = RentPay_GetPaidDays(GetBusinessData(businessid, B_RENT_DATE));
	new daily = GetBusinessData(businessid, B_IMPROVEMENTS) < 3
		? GetBusinessData(businessid, B_RENT_PRICE)
		: GetBusinessData(businessid, B_RENT_PRICE) / 2;

	new body[384];
	format(body, sizeof body,
		"{FFFFFF}Бизнес:\t\t\t\t№%d (%s)\n"\
		"Оплаченных дней аренды:\t\t%d из %d\n"\
		"Ежедневная арендная плата:\t%d руб\n"\
		"Тип аренды:\t\t\t\t%s\n\n"\
		"На сколько дней Вы хотите оплатить бизнес?",
		businessid,
		GetBusinessData(businessid, B_NAME),
		paid_days,
		max_days,
		daily,
		GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Пониженная"));

	ShowPlayerDialog(playerid, DIALOG_BR_PAY_RENT_BIZ, DIALOG_STYLE_INPUT,
		"{66CC00}Оплата бизнеса", body, "Оплатить", "Назад");
	return 1;
}

stock RentPay_EvictHouse(houseid)
{
	if(houseid < 0 || houseid >= TotalHouses || HouseInfo[houseid][hID] <= 0) return 0;
	if(HouseInfo[houseid][hOwnerID] <= 0) return 0;

	new owner_id = HouseInfo[houseid][hOwnerID];
	for(new p; p < MAX_PLAYERS; p++)
	{
		if(!IsPlayerConnected(p)) continue;
		if(Player[p][pID] != owner_id) continue;
		SendClientMessage(p, 0xFF6600FF, "Ваш дом был изъят государством за неуплату квартплаты.");
		if(GetPVarInt(p, "InHouseID") == houseid)
			House_ExitPlayer(p, houseid);
		break;
	}

	HouseInfo[houseid][hOwnerID] = 0;
	format(HouseInfo[houseid][hOwnerName], 24, "None");
	HouseInfo[houseid][hImprovements] = 0;
	HouseInfo[houseid][hRentTime] = 0;
	HouseInfo[houseid][hLock] = false;
	HouseInfo[houseid][hEviction] = gettime() + RENT_PAY_GOS_COOLDOWN_SEC;

	new q[220];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `houses` SET owner_id=0, owner_name='None', rent_time=0, improvements=0, eviction=%d WHERE id=%d LIMIT 1",
		HouseInfo[houseid][hEviction], HouseInfo[houseid][hID]);
	mysql_tquery(db_handle, q, "", "");

	UpdateHouseStatus(houseid);
	Family_ClearHouseBySqlId(HouseInfo[houseid][hID]);
	return 1;
}

stock RentPay_EvictBusiness(businessid)
{
	if(!IsBusinessSlotValid(businessid)) return 0;
	if(GetBusinessData(businessid, B_OWNER_ID) <= 0) return 0;

	new owner_id = GetBusinessData(businessid, B_OWNER_ID);
	for(new p; p < MAX_PLAYERS; p++)
	{
		if(!IsPlayerConnected(p)) continue;
		if(Player[p][pID] != owner_id) continue;
		SendClientMessage(p, 0xFF6600FF, "Ваш бизнес был изъят государством за неуплату аренды.");
		if(Player[p][pBusiness] == businessid)
		{
			Player[p][pBusiness] = -1;
			SavePlayerAccount(p);
		}
		break;
	}

	SetBusinessData(businessid, B_OWNER_ID, 0);
	SetBusinessData(businessid, B_IMPROVEMENTS, 0);
	SetBusinessData(businessid, B_PRODS, 0);
	SetBusinessData(businessid, B_PROD_PRICE, 0);
	SetBusinessData(businessid, B_BALANCE, 0);
	SetBusinessData(businessid, B_RENT_DATE, 0);
	SetBusinessData(businessid, B_ENTER_MUSIC, 0);
	SetBusinessData(businessid, B_LOCK_STATUS, false);
	SetBusinessData(businessid, B_EVICTION, gettime() + RENT_PAY_GOS_COOLDOWN_SEC);
	format(GetBusinessData(businessid, B_OWNER_NAME), BIZ_OWNER_NAME_LEN, "None");

	new q[280];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `business` SET owner_id=0, improvements=0, products=0, prod_price=0, balance=0, rent_time=0, enter_music=0, `lock`=0, eviction=%d WHERE id=%d LIMIT 1",
		GetBusinessData(businessid, B_EVICTION), GetBusinessData(businessid, B_SQL_ID));
	mysql_tquery(db_handle, q, "", "");

	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET business=-1 WHERE id=%d LIMIT 1", owner_id);
	mysql_tquery(db_handle, q, "", "");

	UpdateBusinessLabel(businessid);
	BusinessHealthPickupInit(businessid);
	return 1;
}

stock RentPay_ProcessExpired()
{
	new now = gettime();

	for(new h; h < TotalHouses; h++)
	{
		if(HouseInfo[h][hID] <= 0) continue;
		if(HouseInfo[h][hOwnerID] <= 0) continue;
		if(HouseInfo[h][hRentTime] > now) continue;
		RentPay_EvictHouse(h);
	}

	for(new b; b < g_business_loaded; b++)
	{
		if(!IsBusinessSlotValid(b)) continue;
		if(GetBusinessData(b, B_OWNER_ID) <= 0) continue;
		if(GetBusinessData(b, B_RENT_DATE) > now) continue;
		RentPay_EvictBusiness(b);
	}
	return 1;
}

stock bool:RentPay_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused listitem
	switch(dialogid)
	{
		case DIALOG_BR_PAY_RENT_MAIN:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerHouseSlot(playerid) == -1)
					{
						SendClientMessage(playerid, 0x999999FF, "У Вас нет дома.");
						RentPay_ShowMainDialog(playerid);
						return true;
					}
					RentPay_ShowHouseDialog(playerid);
				}
				case 1:
				{
					if(GetPlayerBusiness(playerid) == -1)
					{
						SendClientMessage(playerid, 0x999999FF, "У Вас нет бизнеса.");
						RentPay_ShowMainDialog(playerid);
						return true;
					}
					RentPay_ShowBusinessDialog(playerid);
				}
				default: RentPay_ShowMainDialog(playerid);
			}
			return true;
		}
		case DIALOG_BR_PAY_RENT_HOUSE:
		{
			new houseid = GetPlayerHouseSlot(playerid);
			if(houseid == -1) return false;

			if(!response)
			{
				RentPay_ShowMainDialog(playerid);
				return true;
			}

			if(!Bank_IsNumericString(inputtext) || strval(inputtext) <= 0)
			{
				SendClientMessage(playerid, 0xB5B500FF, "Укажите корректное количество дней.");
				RentPay_ShowHouseDialog(playerid);
				return true;
			}

			new days = strval(inputtext);
			new max_days = RentPay_GetMaxDays(playerid);
			new paid_days = RentPay_GetPaidDays(HouseInfo[houseid][hRentTime]);
			if((paid_days + days) > max_days)
			{
				SendClientMessage(playerid, 0xB5B500FF, "Превышен лимит оплаченных дней для вашего VIP-статуса.");
				RentPay_ShowHouseDialog(playerid);
				return true;
			}

			new daily = House_GetKvartplata(houseid);
			new total = daily * days;
			if(Player[playerid][pBank] < total)
			{
				SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счёте недостаточно средств для оплаты.");
				new hint[96];
				format(hint, sizeof hint, "Для оплаты на %d дн. с основного счёта нужно %d руб.", days, total);
				SendClientMessage(playerid, 0x999999FF, hint);
				RentPay_ShowHouseDialog(playerid);
				return true;
			}

			new now = gettime();
			new rent_time = HouseInfo[houseid][hRentTime];
			if(rent_time <= now) rent_time = now;
			rent_time += days * 86400;

			Player[playerid][pBank] -= total;
			HouseInfo[houseid][hRentTime] = rent_time;
			HouseInfo[houseid][hLock] = false;

			new q[220];
			mysql_format(db_handle, q, sizeof q,
				"UPDATE `houses` SET rent_time=%d WHERE id=%d LIMIT 1",
				rent_time, HouseInfo[houseid][hID]);
			mysql_tquery(db_handle, q, "", "");
			SavePlayerAccount(playerid);

			new msg[96];
			format(msg, sizeof msg, "С основного счёта снято {3399FF}%d руб", total);
			SendClientMessage(playerid, 0xFFFFFFFF, msg);
			format(msg, sizeof msg, "Вы успешно оплатили дом на {3399FF}%d дн.", days);
			SendClientMessage(playerid, 0x66CC00FF, msg);
			return true;
		}
		case DIALOG_BR_PAY_RENT_BIZ:
		{
			new businessid = GetPlayerBusiness(playerid);
			if(businessid == -1) return false;

			if(!response)
			{
				RentPay_ShowMainDialog(playerid);
				return true;
			}

			if(!Bank_IsNumericString(inputtext) || strval(inputtext) <= 0)
			{
				SendClientMessage(playerid, 0xB5B500FF, "Укажите корректное количество дней.");
				RentPay_ShowBusinessDialog(playerid);
				return true;
			}

			new days = strval(inputtext);
			new max_days = RentPay_GetMaxDays(playerid);
			new paid_days = RentPay_GetPaidDays(GetBusinessData(businessid, B_RENT_DATE));
			if((paid_days + days) > max_days)
			{
				SendClientMessage(playerid, 0xB5B500FF, "Превышен лимит оплаченных дней для вашего VIP-статуса.");
				RentPay_ShowBusinessDialog(playerid);
				return true;
			}

			new daily = GetBusinessData(businessid, B_IMPROVEMENTS) < 3
				? GetBusinessData(businessid, B_RENT_PRICE)
				: GetBusinessData(businessid, B_RENT_PRICE) / 2;
			new total = daily * days;
			if(Player[playerid][pBank] < total)
			{
				SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счёте недостаточно средств для оплаты.");
				new hint[96];
				format(hint, sizeof hint, "Для оплаты на %d дн. с основного счёта нужно %d руб.", days, total);
				SendClientMessage(playerid, 0x999999FF, hint);
				RentPay_ShowBusinessDialog(playerid);
				return true;
			}

			new now = gettime();
			new rent_time = GetBusinessData(businessid, B_RENT_DATE);
			if(rent_time <= now) rent_time = now;
			rent_time += days * 86400;

			Player[playerid][pBank] -= total;
			SetBusinessData(businessid, B_RENT_DATE, rent_time);
			SetBusinessData(businessid, B_LOCK_STATUS, false);

			new q[160];
			mysql_format(db_handle, q, sizeof q,
				"UPDATE `business` SET rent_time=%d, `lock`=0 WHERE id=%d LIMIT 1",
				rent_time, GetBusinessData(businessid, B_SQL_ID));
			mysql_tquery(db_handle, q, "", "");
			SavePlayerAccount(playerid);

			new msg[96];
			format(msg, sizeof msg, "С основного счёта снято {3399FF}%d руб", total);
			SendClientMessage(playerid, 0xFFFFFFFF, msg);
			format(msg, sizeof msg, "Вы успешно оплатили бизнес на {3399FF}%d дн.", days);
			SendClientMessage(playerid, 0x66CC00FF, msg);
			return true;
		}
	}
	return false;
}
