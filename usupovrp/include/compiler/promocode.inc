CMD:promo(playerid)
{
	return ShowDialogPromocode(playerid);
}
alias:promo("promocode");

CMD:mypromo(playerid)
{
	format(String256, sizeof(String256), "SELECT * FROM `player_promocode` WHERE `userid` = '%i'",PI[playerid][pID]);
	mysql_tquery(db_prod, String256, "ShowDialogMyPromocode", "i", playerid);
	return true;
}
alias:mypromo("mypromocode");

callback:: ShowDialogMyPromocode(playerid)
{
	new 
		rows = cache_get_row_count(db_prod);
	
	if(!rows)	
		return SendErr(playerid, "Список активированных промокодов пуст");

	new 
		promo_name[34],
		status[50],
		promo_time;

	String1024[0] = EOS;
	
	for(new i; i < rows; i++)
	{
		
		cache_get_field_content(i, "name", promo_name, db_prod, 34);
		promo_time = cache_get_field_content_int(i, "remain_hours");

		if(promo_time > 0)
		{
			format(status, sizeof(status), ""cLGREY"%i "cMain"часа(-ов)", promo_time);
		}
		else
		{
			status = ""cGR"Получено";
		}

		format(String1024, sizeof(String1024), "%s"cWH"%s\t%s\n", String1024, promo_name, status);
	}

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, !""cMain"Список промокодов", String1024, !"Закрыть", "");

	return true;
}

stock ShowDialogPromocode(playerid)
{
	ShowPlayerDialog(playerid, 2551, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите промокод.\n\
			После отыгрывания определенного времени вы можете получить:\n\t\
			- "cMain"Евро\n\t"cWH"\
			- "cMain""SERVER_COINS""cWH"\n\t\
			- "cMain"Игровую валюту"cWH"\n\t\
			- "cMain"Уникальный транспорт", !"Ввести", !"Отмена");
	return true;
}

CMD:pmenu(playerid)
{
	if(!GetString(GetName(playerid), "Developer") && !GetString(GetName(playerid), "Sambero_Lucanio") && !GetString(GetName(playerid), "Sambero_Lucanio") && !GetString(GetName(playerid), "Eduard_Haunted") && !GetString(GetName(playerid), "Stepan_Kaspesky"))
		return true;

	if(!g_player_full_access[playerid]) 
		return true;

	ShowPlayerDialog(playerid, 2553, DIALOG_STYLE_LIST, !""cMain"Система промокодов", !"\
	"cMain"1. "cWH"Создать промокод\n\
	"cMain"2. "cWH"Список промокодов\n\
	"cMain"3. "cWH"Деактивация промокода", !"Выбрать", !"Отмена");
	return true;
}

DLG(2553, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;

	switch(listitem)
	{
		case 0:
		{
			ShowDialogCreatePromo(playerid, 0);
		}
		case 1:
		{
			mysql_tquery(db_prod, "SELECT * FROM `promocode`", "ShowDialogAllPromocode", "i", playerid);
		}
		case 2:
		{
			ShowDialogDeactivatePromocode(playerid);
		}
	}
	return true;
}

stock ShowDialogCreatePromo(playerid, type = 0)
{
	switch(type)
	{
		case 0:
		{
			ShowPlayerDialog(playerid, 2556, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите название промокода", !"Далее", !"Отмена");
		}
		case 1:
		{
			ShowPlayerDialog(playerid, 2557, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите кол-во часов, необходимое для получения\n"cGREY"Или напишите 0, если бонус должно давать сразу", !"Далее", !"Отмена");
		}
		case 2:
		{
			ShowPlayerDialog(playerid, 2558, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите кол-во виртов, которое игрок получит\n"cGREY"Или напишите 0", !"Далее", !"Отмена");
		}
		case 3:
		{
			ShowPlayerDialog(playerid, 2559, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите кол-во евро, которое игрок получит\n"cGREY"Или напишите 0", !"Далее", !"Отмена");
		}
		case 4:
		{
			ShowPlayerDialog(playerid, 2560, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите кол-во коинов, которое игрок получит\n"cGREY"Или напишите 0", !"Далее", !"Отмена");
		}
		case 5:
		{
			ShowPlayerDialog(playerid, 2561, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите кол-во активаций для промокода\n"cGREY"Или напишите 0 для неограниченного кол-ва", !"Далее", !"Отмена");
		}
		case 6:
		{
			ShowPlayerDialog(playerid, 2562, DIALOG_STYLE_INPUT, !""cMain"Промокод", !""cWH"\
			Введите ID машины, которую игрок получит\n"cGREY"Или напишите 0, если без транспорта", !"Далее", !"Отмена");
		}
		
		case 7:
		{
			ShowPlayerDialog
			(
				playerid, 2563, DIALOG_STYLE_INPUT, 
				""cMain"Промокод",
				""cWH"Введите для какой платформы будет создан промо-код\n\n"\
				"\t{ffbe76}0 - для всех;\n"\
				"\t{ffbe76}1 - для компьютеров;\n"\
				"\t{ffbe76}2 - для телефонов.",
				"Далее", "Закрыть"
			);
		}
	}
	return true;
}

DLG(2563, playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	
	new promo_use_id = strval(inputtext),
	t = GetPVarInt(playerid, "promo_time"),
	m = GetPVarInt(playerid, "promo_money"),
	c = GetPVarInt(playerid, "promo_coin"),
	e = GetPVarInt(playerid, "promo_euro"),
	car = GetPVarInt(playerid, "promo_car_id"),
	count = GetPVarInt(playerid, "promo_count");
	
	// GetPVarInt(playerid, "promo_time"), GetPVarInt(playerid, "promo_money"), GetPVarInt(playerid, "promo_coin"), GetPVarInt(playerid, "promo_euro"), GetPVarInt(playerid, "promo_car_id"), GetPVarInt(playerid, "promo_count"
	
	if(promo_use_id != 0 && promo_use_id != 1 && promo_use_id != 2)
		return SendClientMessage(playerid, COLOR_RED, "Неверный тип промо-кода");
	
	new promoname[34];
	GetPVarString(playerid, "promo_name", promoname, 34);

	STRING_GLOBAL[0] = EOS;

//INSERT INTO `promocode` (`id`, `name`, `hours`, `money`, `coins`, `euro`, `vehicle`, `count`, `status`) VALUES ('0', 'jri', '555', '555555', '555555', '555555', '494', '1', '1');

	mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "\
	INSERT INTO `promocode` (`id`, `name`, `hours`, `money`, `coins`, `euro`, `vehicle`, `count`, `status`) VALUES ('%d', '%s', '%d', '%d', '%d', '%d', '%d', '%d', '1')",
	promo_use_id, promoname, t, m, c, e, car, count);
	mysql_query(db_prod, STRING_GLOBAL);

	new car_model_id = GetPVarInt(playerid, "promo_car_id");
	new vehtext[40];

	if(car_model_id != 0)
	{
		format(vehtext, sizeof(vehtext), "Автомобиль: "cMain"%s", VehicleNames[car_model_id-400]);
	}
	else
		vehtext = "";

	format(String256, sizeof(String256), ""cWH"\
		Даст бонус после отыгрывания: %i часа(-ов)\n\
		Бонусы:\n\t\
		- "cMain"%i Евро\n\t"cWH"\
		- "cMain"%i "SERVER_COINS""cWH"\n\t\
		- "cMain"%i Игровую валюту\n\
		"cWH"%s",  GetPVarInt(playerid, "promo_time"), GetPVarInt(playerid, "promo_euro"), GetPVarInt(playerid, "promo_coin"), GetPVarInt(playerid, "promo_money"), vehtext);

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !""cMain"Промокод создан", String256, !"Закрыть", "");
	fLogs("[ADMIN] %s создал промокод %s", GetName(playerid), promoname);	
	
	return 1;
}

DLG(2556, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;

	if(IsTextInvalid(inputtext))
	{
		ShowDialogCreatePromo(playerid, 0);
		return SendErr(playerid, "Вы ввели запрещенные символы.");
	} 
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 0);

	if(strlen(inputtext) > 34)
		return SendErr(playerid, "До 34 символов");

	format(String144, sizeof(String144), "SELECT * FROM `promocode` WHERE `name` = '%s' LIMIT 1", inputtext);
	new Cache:result = mysql_query(db_prod, String144);

	new rows = cache_num_rows();
	cache_delete(result);

	if(rows)
		return SendErr(playerid, "Данный промокод уже создан");

	SetPVarString(playerid, "promo_name", inputtext);
	ShowDialogCreatePromo(playerid, 1);
	return true;
}

DLG(2557, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 1);

	if(strval(inputtext) > 80 || strval(inputtext) < 0)
		return ShowDialogCreatePromo(playerid, 1); 

	SetPVarInt(playerid, "promo_time", strval(inputtext));
	ShowDialogCreatePromo(playerid, 2);
	return true;
}

DLG(2558, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 2);

	if(strval(inputtext) > 10000000 || strval(inputtext) < 0)
		return ShowDialogCreatePromo(playerid, 2); 

	SetPVarInt(playerid, "promo_money", strval(inputtext));
	ShowDialogCreatePromo(playerid, 3);
	return true;
}

DLG(2559, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 3);
	if(strval(inputtext) > 10000000 || strval(inputtext) < 0)
		return ShowDialogCreatePromo(playerid, 3); 	

	SetPVarInt(playerid, "promo_euro", strval(inputtext));
	ShowDialogCreatePromo(playerid, 4);
	return true;
}

DLG(2560, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 4);

	if(strval(inputtext) > 10000000 || strval(inputtext) < 0)
		return ShowDialogCreatePromo(playerid, 4); 

	SetPVarInt(playerid, "promo_coin", strval(inputtext));
	ShowDialogCreatePromo(playerid, 5);
	return true;
}

DLG(2561, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 5);

	if(strval(inputtext) > 10000000 || strval(inputtext) < 0)
		return ShowDialogCreatePromo(playerid, 5); 

	SetPVarInt(playerid, "promo_count", strval(inputtext));
	ShowDialogCreatePromo(playerid, 6);
	return true;
}

DLG(2562, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	
	if(!strlen(inputtext))
		return ShowDialogCreatePromo(playerid, 6);

	if(strval(inputtext) != 0)
	{
		if(strval(inputtext) > 611 || strval(inputtext) < 400) 
		{
			ShowDialogCreatePromo(playerid, 6);
			return SendClientMessage(playerid, COLOR_GREY, "ID машины не может быть меньше 400 и больше чем 611");
		}
	}
	
	SetPVarInt(playerid, "promo_car_id", strval(inputtext));
	
	ShowDialogCreatePromo(playerid, 7);
	
	return 1;
}

stock ShowDialogDeactivatePromocode(playerid)
{
	ShowPlayerDialog(playerid, 2554, DIALOG_STYLE_INPUT, !""cMain"Деактивация промокода", !""cWH"\
			Введите промокод, который хотите деактивировать", !"Деактивация", !"Отмена");

	return true;
}

DLG(2554, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;

	if(IsTextInvalid(inputtext))
	{
		ShowDialogDeactivatePromocode(playerid);
		return SendErr(playerid, "Вы ввели запрещенные символы.");
	} 
	if(!strlen(inputtext))
		return ShowDialogDeactivatePromocode(playerid);

	format(String144, sizeof(String144), "SELECT * FROM `promocode` WHERE `name` = '%s' AND `status` = 1 LIMIT 1", inputtext);
	new Cache:result = mysql_query(db_prod, String144);

	new 
		promocode[34];

	new rows = cache_num_rows();
	
	if(rows)
	{
		cache_get_field_content(0, "name", promocode, db_prod, 34);
		cache_delete(result);

		format(String144, sizeof(String144), "Вы деактивировали промокод "cMain"%s"cWH"!", promocode);
		SendClientMessage(playerid, -1, String144);

		STRING_GLOBAL[0] = EOS;
		mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `promocode` SET `status` = 0 WHERE `name` = '%s' LIMIT 1", promocode);
		mysql_tquery(db_prod, STRING_GLOBAL);

		fLogs("[ADMIN] %s деактивировал промокод %s", GetName(playerid), promocode);
	}

	if(!rows)
	{
		cache_delete(result);
		ShowDialogDeactivatePromocode(playerid);
		return SendErr(playerid, "Промокод не найден");
	}
	return true;
}

callback::ShowDialogAllPromocode(playerid)
{
	new 
		rows = cache_get_row_count(db_prod);
	
	if(!rows)	
		return SendErr(playerid, "Список промокодов пуст");

	new 
		promo_name[34],
		status[50],
		promo_status;

	String1024[0] = EOS;
	
	for(new i; i < rows; i++)
	{
		cache_get_field_content(i, "name", promo_name, db_prod, 34);
		promo_status = cache_get_field_content_int(i, "status");

		if(promo_status > 0)
		{
			status = ""cGR"Активен";
		}
		else
		{
			status = ""cRED"Деактивирован";
		}

		format(String1024, sizeof(String1024), "%s"cWH"%s\t%s\n", String1024, promo_name, status);
	}

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, !""cMain"Список промокодов", String1024, !"Закрыть", "");
	return true;
}

DLG(2552, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;

	switch(listitem)
	{
		case 0: return callcmd::mypromo(playerid);
		case 1: return callcmd::promo(playerid);
	}
	return true;
}
DLG(2551, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;

	if(IsTextInvalid(inputtext))
	{
		ShowDialogPromocode(playerid);
		return SendErr(playerid, "Вы ввели запрещенные символы.");
	} 
	if(!strlen(inputtext))
		return ShowDialogPromocode(playerid);

	format(String256, sizeof(String256), "SELECT * FROM `player_promocode` WHERE `userid` = '%d' AND `name` = '%s' OR `userid` = '%d' AND `remain_hours` > '0' LIMIT 1", PI[playerid][pID], inputtext);
	new Cache:acc_result = mysql_query(db_prod, String256);

	new acc_rows = cache_num_rows();
	cache_delete(acc_result);

	if(acc_rows)
	{
		ShowDialogPromocode(playerid);
		return SendErr(playerid, "Вы уже активировали данный промокод или у Вас активирован другой.");
	}

	format(String144, sizeof(String144), "SELECT * FROM `promocode` WHERE `name` = '%s' AND `status` = 1 LIMIT 1", inputtext);
	new Cache:result = mysql_query(db_prod, String144);

	new 
		promocode[34], payday, money, coins, euro, vehid, vehtext[40], promo_count;

	new rows = cache_num_rows();
	
	if(rows)
	{
		cache_get_field_content(0, "name", promocode, db_prod, 34);
		payday = cache_get_field_content_int(0, "hours");
		money = cache_get_field_content_int(0, "money");
		coins = cache_get_field_content_int(0, "coins");
		euro = cache_get_field_content_int(0, "euro");
		vehid = cache_get_field_content_int(0, "vehicle");
		promo_count = cache_get_field_content_int(0, "count");
		
		new platform_id = cache_get_field_content_int(0, "platform");
		
		switch(platform_id)
		{
			case 1:
			{
				if(IsPlayerFromThePhone(playerid))
					return SendClientMessage(playerid, COLOR_RED, "Введенный промо-код доступен только для игроков с компьютеров");
			}
			
			case 2:
			{
				if(!IsPlayerFromThePhone(playerid))
					return SendClientMessage(playerid, COLOR_RED, "Введенный промо-код доступен только для игроков с телефонов");
			}
		}
		
		cache_delete(result);

		format(String144, sizeof(String144), "Вы активировали промокод "cMain"%s"cWH"!", promocode);
		SendClientMessage(playerid, -1, String144);

		fLogs("[Промокод] %s активировал промокод %s", GetName(playerid), promocode);

		if(vehid != 0)
		{
			format(vehtext, sizeof(vehtext), "Автомобиль: "cMain"%s", VehicleNames[vehid-400]);
		}
		else
			vehtext = "";

		if(promo_count == 1)
		{
			mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `promocode` SET `count` = 0, `status` = 0  WHERE `name` = '%s' LIMIT 1", promocode);
			mysql_tquery(db_prod, STRING_GLOBAL);
		}
		else if(promo_count > 1)
		{
			mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `promocode` SET `count` = '%i'  WHERE `name` = '%s' LIMIT 1", promo_count-1, promocode);
			mysql_tquery(db_prod, STRING_GLOBAL);
		}

		if(payday == 0)
		{
			format(String256, sizeof(String256), ""cWH"\
			Вы активировали промокод и получили:\n\t\
			- "cMain"%i Евро\n\t"cWH"\
			- "cMain"%i "SERVER_COINS""cWH"\n\t\
			- "cMain"%i Игровой валюты\n\
			"cWH"%s", euro, coins, money, vehtext);

			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !""cMain"Промокод активирован", String256, !"Закрыть", "");

			mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `player_promocode` (`userid`, `name`, `remain_hours`, `status`) VALUES ('%i', '%s', '0', '1')", PI[playerid][pID], promocode);
			mysql_tquery(db_prod, STRING_GLOBAL, "", "");

			SetPlayerMoney(playerid, money);
			TransferEuro(-1, playerid, euro, "промокод");
			PI[playerid][pPerfectCoins] += coins;
			UpdatePlayerData(playerid, "credits", PI[playerid][pPerfectCoins]);

			if(vehid != 0)
			{
				global_string = "";
				mysql_format(db_prod, global_string, 500, "\
						INSERT INTO `ownable_cars` (c_model, c_x, c_y, c_z, c_a, c_class, c_owner, c_fuel, c_color1, c_color2, c_lock, c_price, c_health) VALUES \
						('%d', '0', '0', '0', '0', '%d', '%s', '45', '%d', '%d', '1', '%d', '1000.0')",
				vehid, 1, GetName(playerid), 0, 0, 0);
				mysql_tquery(db_prod, global_string, "", "");

				format(String144, sizeof(String144), "За активацию промокода вы получили автомобиль "cMain"%s", VehicleNames[vehid-400]);
				SendClientMessage(playerid, -1, String144);
			}
			fLogs("[Промокод] %s получил бонус за промокод %s", GetName(playerid), promocode);
		}
		else
		{
			format(String256, sizeof(String256), ""cWH"\
			После отыгрывания %i часа(-ов)\n\
			Вы получите:\n\t\
			- "cMain"%i Евро\n\t"cWH"\
			- "cMain"%i "SERVER_COINS""cWH"\n\t\
			- "cMain"%i Игровой валюты\n\
			"cWH"%s", payday, euro, coins, money, vehtext);

			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !""cMain"Промокод активирован", String256, !"Закрыть", "");

			mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `player_promocode` (`userid`, `name`, `remain_hours`, `status`) VALUES ('%i', '%s', '%i', '0')", PI[playerid][pID], promocode, payday);
			mysql_tquery(db_prod, STRING_GLOBAL, "", "");
		}
	}

	if(!rows)
	{
		cache_delete(result);
		ShowDialogPromocode(playerid);
		return SendErr(playerid, "Промокод не найден");
	}
	return true;
}

callback:: PayDayPlayerPromo(playerid)
{
	format(String256, sizeof(String256), "SELECT * FROM `player_promocode` WHERE `userid` = '%i' AND `status` = 0",PI[playerid][pID]);
	new Cache:acc_result = mysql_query(db_prod, String256);

	new acc_rows = cache_num_rows();

	new 
		promoname[34], hours;

	if(!acc_rows)
	{
		cache_delete(acc_result);
		return true;
	}

	for(new i; i < acc_rows; i++)
	{
		cache_get_field_content(i, "name", promoname, db_prod, 34);
		hours = cache_get_field_content_int(i, "remain_hours");

		if(hours == 1)
		{
			STRING_GLOBAL[0] = EOS;
			mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `player_promocode` SET `remain_hours` = 0, `status` = 1  WHERE `userid` = '%i' AND `name` = '%s' LIMIT 1", PI[playerid][pID], promoname);
			mysql_tquery(db_prod, STRING_GLOBAL);

			format(String144, sizeof(String144), "Вы получили бонус за промокод "cMain"%s", promoname);
			SendClientMessage(playerid, -1, String144);

			fLogs("[Промокод] %s получил бонус за промокод %s", GetName(playerid), promoname);

			format(String144, sizeof(String144), "SELECT * FROM `promocode` WHERE `name` = '%s' LIMIT 1", promoname);
			new Cache:result = mysql_query(db_prod, String144);

			new 
				money, coins, euro, vehid;

			new rows = cache_num_rows();
			
			if(rows)
			{
				money = cache_get_field_content_int(0, "money");
				coins = cache_get_field_content_int(0, "coins");
				euro = cache_get_field_content_int(0, "euro");
				vehid = cache_get_field_content_int(0, "vehicle");
				cache_delete(result);
			}

			SetPlayerMoney(playerid, money);
			TransferEuro(-1, playerid, euro, "промокод");
			PI[playerid][pPerfectCoins] += coins;
			UpdatePlayerData(playerid, "credits", PI[playerid][pPerfectCoins]);

			if(vehid != 0)
			{
				global_string = "";
				mysql_format(db_prod, global_string, 500, "\
						INSERT INTO `ownable_cars` (c_model, c_x, c_y, c_z, c_a, c_class, c_owner, c_fuel, c_color1, c_color2, c_lock, c_price, c_health) VALUES \
						('%d', '0', '0', '0', '0', '%d', '%s', '45', '%d', '%d', '1', '%d', '1000.0')",
				vehid, 1, GetName(playerid), 0, 0, 0);
				mysql_tquery(db_prod, global_string, "", "");

				format(String144, sizeof(String144), "За активацию промокода вы получили автомобиль "cMain"%s", VehicleNames[vehid-400]);
				SendClientMessage(playerid, -1, String144);
			}
		}
		else
		{
			STRING_GLOBAL[0] = EOS;
			mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "UPDATE `player_promocode` SET `remain_hours` = remain_hours - 1  WHERE `userid` = '%i' AND `name` = '%s' LIMIT 1", PI[playerid][pID], promoname);
			mysql_tquery(db_prod, STRING_GLOBAL);
		}
	}
	cache_delete(acc_result);
	return true;
}
