//>> Файл: bykranin_src/core/economy/economy_01.inc  (300 строк)
//>> Тема: экономика: банк, донат, промокоды, аукцион, обмен, торговля
//>> Внутри: ShowPlayerPayForRentDialog, ClearBankAccountInfo, ClearBankAccountsData, ShowPlayerBankDialog, ShowPlayerBankAccounts, IsValidBankAccount, UpdateBankAccountData
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ShowPlayerPayForRentDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_PAY_FOR_RENT, DIALOG_STYLE_LIST,
		"{66CC00}Оплата",
		"1. Заплатить за дом / квартиру\n"\
		"2. Оплатить аренду бизнеса\n"\
		"3. Оплатить аренду АЗС\n"\
		"4. Оплатить гараж\n"\
		"5. Возврат денег за имущество",
		"Далее", "Отмена"
	);
	return 1;
}

stock ClearBankAccountInfo(playerid, accountid)
{
	strmid(g_bank_account[playerid][accountid][BA_NAME], "None", 0, 21, 21);

	SetBankAccountData(playerid, accountid, BA_ID, 0);
	SetBankAccountData(playerid, accountid, BA_PIN_CODE, 0);

	SetBankAccountData(playerid, accountid, BA_BALANCE, 0);
	SetBankAccountData(playerid, accountid, BA_REG_TIME, 0);
}

stock ClearBankAccountsData(playerid)
{
	for(new idx; idx < MAX_BANK_ACCOUNTS; idx ++)
	{
		ClearBankAccountInfo(playerid, idx);
	}
}

stock ShowPlayerBankDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_BANK, DIALOG_STYLE_LIST,
		"{00CC00}Банк",
		"Мои счета\n"\
		"Открыть новый счет\n",
		"Выбрать", "Отмена"
	);
}

stock ShowPlayerBankAccounts(playerid)
{
	new query[64];
	new Cache: result;
	new rows;
	new bank_accounts_list[(37 * MAX_BANK_ACCOUNTS) + 22 + 1];

	format(query, sizeof query, "SELECT * FROM bank_accounts WHERE uid=%d LIMIT %d", GetPlayerAccountID(playerid), MAX_BANK_ACCOUNTS);
	result = mysql_query(mysql, query);
	rows = cache_num_rows(result);

	bank_accounts_list = "{99CC00}Основной счет\n";
	for(new idx, count; idx < MAX_BANK_ACCOUNTS; idx ++)
	{
		ClearBankAccountInfo(playerid, idx);

		if(idx < rows)
		{
			SetBankAccountData(playerid, idx, BA_ID, cache_get_row_int(idx, 0));

			cache_get_row(idx, 2, g_bank_account[playerid][idx][BA_NAME], mysql, 21);
			cache_get_row(idx, 4, g_bank_account[playerid][idx][BA_PIN_CODE], mysql, 9);

			SetBankAccountData(playerid, idx, BA_BALANCE, cache_get_row_int(idx, 3));
			SetBankAccountData(playerid, idx, BA_REG_TIME, cache_get_row_int(idx, 5));

			format(query, sizeof query, "%s - №%d\n", GetBankAccountData(playerid, idx, BA_NAME), GetBankAccountData(playerid, idx, BA_ID));
			strcat(bank_accounts_list, query);

			SetPlayerListitemValue(playerid, count ++, idx);
		}
	}
	cache_delete(result);

	return Dialog(playerid, DIALOG_BANK_ACCOUNTS, DIALOG_STYLE_LIST, "{FFCD00}Ваши счета", bank_accounts_list, "Операции", "Назад");
}

stock IsValidBankAccount(playerid, accountid)
{
	if(0 <= accountid <= MAX_BANK_ACCOUNTS-1)
	{
		if(GetBankAccountData(playerid, accountid, BA_ID) > 0)
		{
			return 1;
		}
	}
	return 0;
}

stock UpdateBankAccountData(playerid, accountid)
{
	if(IsValidBankAccount(playerid, accountid))
	{
		new query[64];
		new Cache: result;

		format(query, sizeof query, "SELECT balance FROM bank_accounts WHERE id=%d LIMIT 1", GetBankAccountData(playerid, accountid, BA_ID));
		result = mysql_query(mysql, query);

		if(cache_num_rows(result))
			SetBankAccountData(playerid, accountid, BA_BALANCE, cache_get_row_int(0, 0));

		cache_delete(result);
	}
}

stock ShowPlayerBankAccountOperation(playerid)
{
	Dialog
	(
		playerid, DIALOG_BANK_ACCOUNT_OPERATION, DIALOG_STYLE_LIST,
		"{0099FF}Список операций",
		"1. Информация о счете\n"\
		"2. История операций\n"\
		"3. Снять деньги\n"\
		"4. Положить деньги\n"\
		"5. Перевести на другой счет\n"\
		"6. Переименовать счет\n"\
		"7. Изменить PIN-код",
		"Выбрать", "Назад"
	);
	return 1;
}

stock ShowPlayerBankAccountTransfer(playerid, accountid)
{
	if(IsValidBankAccount(playerid, accountid))
	{
		new fmt_str[128];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Исходный счет:\t%d\n"\
			"Назначение:\t\t\"%s\", №%d\n\n"\
			"Введите сумму для перевода:",
			GetBankAccountData(playerid, accountid, BA_ID),
			GetPlayerBankTransfer(playerid, BT_NAME),
			GetPlayerBankTransfer(playerid, BT_ID)
		);
		Dialog(playerid, DIALOG_BANK_ACCOUNT_TRANSFER_2, DIALOG_STYLE_INPUT, "{FFCD00}Перевод средств", fmt_str, "Перевести", "Отмена");
	}
	return 1;
}

stock ShowPlayerATMTransfer(playerid)
{
	new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
	if(transfer_id)
	{
		new fmt_str[64 + 1];

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Вы выполняете перевод на счет №%d\n"\
			"Укажите сумму:",
			transfer_id
		);
		Dialog(playerid, DIALOG_ATM_TRANSFER_MONEY_2, DIALOG_STYLE_INPUT, "{FFCD00}Безналичный перевод", fmt_str, "Перевести", "Отмена");
	}
	return 1;
}

stock IsABadBankAccountName(const dest[], pos=0)
{
	new is_bad_name = false;
	do
	{
		switch(dest[pos])
		{
			case
				'a'..'z', 'A'..'Z', 'а'..'я', 'А'..'Я', '0'..'9': continue;

			default:
				is_bad_name = true;

		}
	}
	while(dest[++pos]);

	return is_bad_name;
}

stock BankAccountLog(playerid, accountid, description[])
{
	new query[180 + 1];

	mysql_format(mysql, query, sizeof query, "INSERT INTO bank_accounts_log (acc_id,uip,time,description) VALUES (%d,'%e',%d,'%e')", accountid, GetPlayerIpEx(playerid), gettime(), description);
	mysql_query(mysql, query, false);

	return 1;
}

stock ShowPlayerBankAccountLog(playerid, accountid)
{
	new fmt_str[128];
	new Cache: result;
	new rows;

	format(fmt_str, sizeof fmt_str, "SELECT FROM_UNIXTIME(time,'%%Y-%%m-%%d') AS date,description FROM bank_accounts_log WHERE acc_id=%d ORDER BY id DESC LIMIT 10", accountid);
	result = mysql_query(mysql, fmt_str);

	rows = cache_num_rows(result);

	if(rows)
	{
		new text[900] = "{FFFFFF}";
		new day, month, year;

		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str);
			sscanf(fmt_str, "P<->ddd", year, month, day);

			cache_get_row(idx, 1, fmt_str);

			format(fmt_str, sizeof fmt_str, "%d %s %d г.\t\t%s\n", day, GetMonthName(month), year, fmt_str);
			strcat(text, fmt_str);
		}
		Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}Последние 10 операций", text, "Вернуться", "");
	}
					else Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}История", "{FFFFFF}История операций пуста", "Вернуться", "");

	cache_delete(result);
	return 1;
}

stock RemovePlayerAttachedObjects(playerid)
{
	for(new idx; idx < MAX_PLAYER_ATTACHED_OBJECTS; idx ++)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, idx))
		{
			RemovePlayerAttachedObject(playerid, idx);
		}
	}
}

stock RemovePlayerAttachedObjectEx(playerid, ...)
{
	new args = numargs()-1;
	for(new idx; idx < args; idx ++)
		RemovePlayerAttachedObject(playerid, getarg(idx + 1));
}

stock HelpInfoInit()
{
	new fmt_str[64];

	for(new idx; idx < sizeof help_info; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d. %s\n", idx + 1, help_info[idx][H_TITLE]);
		strcat(help_info_items, fmt_str);

		format(fmt_str, sizeof fmt_str, "{FFCD00}%d. ", idx + 1);
		strins(help_info[idx][H_TITLE], fmt_str, 0, 64);

		//strins(help_info[idx][H_INFO], "{FFFFFF}", 0, 1024);
	}


	markerhelp = CreateDynamicCP(-116.0248,965.5103,12.1417, 2.1, _, _, _, 23.0); // ЖД-вокзал ЛС
	CreateDynamic3DTextLabel("Раздел для новичков\n{FFFF00}Помощь по игре", 0x3399FFFF, 1763.693, -1885.828, 13.555 + 0.66, 26.0, _, _, _, 0, 0);

//	CreateDynamic3DTextLabel("Станция технического обслуживания\nПосигнальте чтобы починить авто\n{FFFF00}Стоимость услуги: 50.000 рублей", 0x3399FFFF, 1850.7094,2196.4565,15.8480 + 0.66, 26.0, _, _, _, 0, 0);
//	CreateDynamicCP(1850.7094,2196.4565,15.8480	, 2.1, _, _, _, 23.0); // ЖД-вокзал ЛС

//	CreateDynamic3DTextLabel("Станция технического обслуживания\nПосигнальте чтобы починить авто\n{FFFF00}Стоимость услуги: 50.000 рублей", 0x3399FFFF, 275.8153,673.9254,12.0000 + 0.66, 26.0, _, _, _, 0, 0);
//	CreateDynamicCP(275.8153,673.9254,12.0000	, 2.1, _, _, _, 23.0); // ЖД-вокзал ЛС

	markerhelp1 = CreateDynamicCP(1808.5878,2498.1243,15.8725, 2.1, _, _, _, 23.0); // ЖД-вокзал ЛС
	CreateDynamic3DTextLabel("Раздел для новичков\n{FFFF00}Помощь по игре", 0x3399FFFF, 1763.693, -1885.828, 13.555 + 0.66, 26.0, _, _, _, 0, 0);
}

stock ShowPlayerHelpSection(playerid, sectionid)
{
	new next_buttom[9] = "Далее >>";
	if(sectionid >= sizeof help_info - 1)
	{
		next_buttom[0] = '\0';
	}

	Dialog
	(
		playerid, DIALOG_HELP_SECTION, DIALOG_STYLE_MSGBOX,
		GetHelpInfoData(sectionid, H_TITLE),
		GetHelpInfoData(sectionid, H_INFO),
		"<< Меню", next_buttom
	);
	SetPVarInt(playerid, "help_section", sectionid);
}

