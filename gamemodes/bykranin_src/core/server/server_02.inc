//>> Файл: bykranin_src/core/server/server_02.inc  (1220 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: /charity, /bank, FormatPlayerTimeDuration, /time, /id, /buyf, /sellf
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:charity(playerid, params[])
{
	new Cache: result;
	new rows;
	new money;
	new fmt_str[75];
	new string[1024];

	cache_set_active(charity_cache_data);
	rows = cache_num_rows(result);

	string = "Сумма\t\tИмя\n\n{FFFFFF}";
	for(new idx; idx < rows; idx ++)
	{
		cache_get_row(idx, 0, fmt_str);
		money = cache_get_row_int(idx, 1);

		format(fmt_str, sizeof fmt_str, "%d руб\t\t%s\n", money, fmt_str);
		strcat(string, fmt_str);
	}
	cache_set_active(Cache:0); //unset active cache

	format(fmt_str, sizeof fmt_str, "SELECT SUM(money) as money FROM charity WHERE uid=%d LIMIT 1", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, fmt_str, true);

	money = cache_get_row_int(0, 0);
	cache_delete(result);

	format(fmt_str, sizeof fmt_str, "\n{999999}Сумма Ваших пожертвований: %d руб", money);
	strcat(string, fmt_str);

	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{00CC00}Топ 25 благотворителей", string, "Закрыть", "");
}

CMD:bank(playerid, params[])
{
	//if(GetPlayerLevel(playerid) < 4)
	//	return SendClientMessage(playerid, 0x999999FF, "Пользоваться государственными банками можно с 4 уровня");
	
	if(IsPlayerInRangeOfPoint(playerid, 35.0, 2902.8274,2509.2036,1051.0000))
	{
		ShowPlayerBankDialog(playerid);
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы не в банке");

	return 1;
}
stock FormatPlayerTimeDuration(seconds, dest[], size)
{
    if(seconds < 0) seconds = 0;
    format(dest, size, "%d:%02d", seconds / 60, seconds % 60);
    return 1;
}

CMD:time(playerid, params[])
{
    new
		hour, minute, second,
		year, month, day;
		
    gettime(hour, minute, second);
	getdate(year, month, day);

	//new fmt_str[999];
	
    //format(fmt_str, sizeof fmt_str, "~y~%d:%02d:%02d~n~~b~~h~%02d.%02d.%d", hour, minute, second, day, month, year);
	//GameTextForPlayer(playerid, fmt_str, 3000, 1);

    new fmt_msg[128], time_left[16];

if(GetPlayerData(playerid, P_WARN_TIME) > 0)
{
    new warn_days = ((GetPlayerData(playerid, P_WARN_TIME) - gettime()) / 86400) + 1;
    format(fmt_msg, sizeof(fmt_msg), "Время до снятия предупреждения: %d дней", warn_days);
    SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
}

if(GetPlayerData(playerid, P_FMUTE) > 0)
{
    FormatPlayerTimeDuration(GetPlayerData(playerid, P_FMUTE), time_left, sizeof(time_left));
    format(fmt_msg, sizeof(fmt_msg), "Время до разблокировки семейного чата: %s", time_left);
    SendClientMessage(playerid, 0x32a44bFF, fmt_msg);
}

	if(GetPlayerData(playerid, P_MUTE) > 0)
	{
        FormatPlayerTimeDuration(GetPlayerData(playerid, P_MUTE), time_left, sizeof time_left);
        format(fmt_msg, sizeof fmt_msg, "Время до разблокировки чата:%s", time_left);
		SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
	}

	if(GetPlayerData(playerid, P_JAIL) > 0)
	{
        FormatPlayerTimeDuration(GetPlayerData(playerid, P_JAIL), time_left, sizeof time_left);
        format(fmt_msg, sizeof fmt_msg, "Время до конца заключения:%s", time_left);
		SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
	}
	
	ShowTime(playerid);
	ShowCurrentTime(playerid);

	return 1;
}
CMD:id(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /id [имя или часть имени игрока]");

	new fmt_str[64];
	new count;

	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;

		if(strfind(GetPlayerNameEx(idx), params, true) != -1)
		{
			count ++;

			format(fmt_str, sizeof fmt_str, "%d. %s {66CC66}id %d", count, GetPlayerNameEx(idx), idx);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			if(count >= 5)
			{
				SendClientMessage(playerid, 0x999999FF, "Показаны первые 5 совпадений");
				break;
			}
		}
	}
	if(!count)
		SendClientMessage(playerid, 0x999999FF, "Совпадений не найдено");

	return 1;
}

CMD:buyf(playerid, params[])
{
	new factory_fuels = GetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT);

	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на нефтезаводе в рабочем транспорте");

	new modelid;
	new vehicleid = GetPlayerJobCar(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);

	if(IsPlayerInRangeOfPoint(playerid, 20.0, 2710.3369,-2383.5164,17.9063))  // для завода
	{
		if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 514)
			return SendClientMessage(playerid, 0xCECECEFF, "Вы не работаете в отделе доставки завода или заняли не ту линию");
	}
					else if(IsPlayerInRangeOfPoint(playerid, 20.0, 2738.3379,-2273.0725,17.9063))  // для азс
	{
		if(GetPlayerJob(playerid) != JOB_TRUCKER || modelid != 514)
			return SendClientMessage(playerid, 0xCECECEFF, "Вы не работаете развозчиком топлива или заняли не ту линию");
	}
					else
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на нефтезаводе");

	new total_litres = GetPlayerJobLoadItems(playerid);

	if(!IsPlayerInVehicle(playerid, vehicleid))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на нефтезаводе в рабочем транспорте");

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /buyf [кол-во в литрах]");

	if(!IsTrailerAttachedToVehicle(vehicleid))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вашего транспорта отсутствует цистерна для топлива");

	extract params -> new load_fuel;

	if(!(1 <= load_fuel <= 8000))
		return SendClientMessage(playerid, 0x999999FF, "Можно загрузить от 1 до 8000 л топлива");

	if(factory_fuels < load_fuel)
		return SendClientMessage(playerid, 0x999999FF, "На нефтезаводе нет такого количества топлива");

	if((total_litres + load_fuel) > 8000)
		return SendClientMessage(playerid, 0xCECECEFF, "В цистерну столько не поместится");

	if(GetPlayerMoneyEx(playerid) < (load_fuel * 10))
		return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки такого количества топлива");

	GivePlayerMoneyEx(playerid, -(load_fuel * 10), "Покупка топлива (нефтезавод)", true, false);

	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT, factory_fuels - load_fuel);
	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);

	SetPlayerJobLoadItems(playerid, total_litres + load_fuel);

	new fmt_str[64];

	format(fmt_str, sizeof fmt_str, "Вы загрузили %d л топлива общей стоимостью %d руб", load_fuel, load_fuel * 10);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "~g~+ %d litres~n~~b~total %d litres", load_fuel, total_litres + load_fuel);
	GameTextForPlayer(playerid, fmt_str, 2000, 6);

	format(fmt_str, sizeof fmt_str, "Доставка топлива\n{FFFFFF}Загрузка %d / 8000 л", total_litres + load_fuel);
	UpdateVehicleLabel(vehicleid, 0xFF6600FF, fmt_str);

	return 1;
}

CMD:sellf(playerid, params[])
{
	new modelid;
	new vehicleid = GetPlayerJobCar(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);

	if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 514)
		return SendClientMessage(playerid, 0xCECECEFF, "Вы не работаете в службе доставки завода");

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -1120.4103,2175.6133,38.0294))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у склада топлива завода");

	new total_litres = GetPlayerJobLoadItems(playerid);

	new factory_fuels = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /sellf [кол-во в литрах]");

	extract params -> new sell_fuels;

	if(!(1 <= sell_fuels <= 8000))
		return SendClientMessage(playerid, 0x999999FF, "Можно продать от 1 до 8000 л топлива");

	if(vehicleid == INVALID_VEHICLE_ID || !IsTrailerAttachedToVehicle(vehicleid) || total_litres < sell_fuels)
		return SendClientMessage(playerid, 0x999999FF, "В Вашей фуре нет такого количества топлива или цистерна не прицеплена");

	if((factory_fuels + sell_fuels) > 1000000)
		return SendClientMessage(playerid, 0x999999FF, "Склад топлива завода заполнен");

	GivePlayerMoneyEx(playerid, (sell_fuels * 12), "Продажа топлива (завод)", true, true);

	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT, factory_fuels + sell_fuels);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL);

	SetPlayerJobLoadItems(playerid, total_litres - sell_fuels);
	AddPlayerData(playerid, P_JOB_WAGE, +, sell_fuels * 2);

	new fmt_str[64];

	format(fmt_str, sizeof fmt_str, "Вы продали заводу %d л топлива на сумму %d руб", sell_fuels, sell_fuels * 12);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Ваша чистая выручка составляет {FF9900}%d руб", sell_fuels * 2);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Доставка топлива\n{FFFFFF}Загрузка %d / 8000 л", total_litres - sell_fuels);
	UpdateVehicleLabel(vehicleid, 0xFF6600FF, fmt_str);

	return 1;
}

CMD:buyprod(playerid, params[])
{
	if(!(GetPlayerJob(playerid) == JOB_TRUCKER && IsPlayerInJob(playerid)))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны работать дальнобойщиком");

	extract params -> new buy_prod_count; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /buyprod [кол-во]. Стоимость 1 продукта 24 руб.");

	if(!IsPlayerInRangeOfPoint(playerid, 20.0, -1046.5460,2203.9644,38.2055))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у склада исходных материалов завода");

	else if(!IsPlayerInVehicle(playerid, GetPlayerJobCar(playerid)))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться у склада исходных материалов завода в рабочем транспорте");

	else if(!(1 <= buy_prod_count <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Можно загрузить от 1 до 10000 шт. продуктов");

	else if(GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT) < buy_prod_count)
		return SendClientMessage(playerid, 0x999999FF, "На складе исходных материалов нет такого количества продуктов");

	else if((buy_prod_count + GetPlayerJobLoadItems(playerid)) > 10000)
		return SendClientMessage(playerid, 0xCECECEFF, "В фургон столько не поместится, максимум 10000 шт.");

	if(GetPlayerMoneyEx(playerid) < (buy_prod_count * 24))
		return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки такого количества продуктов");

	GivePlayerMoneyEx(playerid, -(buy_prod_count * 24), "Покупка продуктов (разв. продуктов)", true, true);

	SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + buy_prod_count);

	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT, GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT) - buy_prod_count);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD);

	new fmt_msg[64];

	format(fmt_msg, sizeof fmt_msg, "Вы купили %d продуктов на сумму %d руб.", buy_prod_count, buy_prod_count * 24);
	SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Текущее кол-во загруженных продуктов: %d из 10000", GetPlayerJobLoadItems(playerid));
	SendClientMessage(playerid, 0xFFFF00FF, fmt_msg);

	return 1;
}

CMD:buym(playerid, params[])
{
	new modelid;
	new vehicleid = GetPlayerJobCar(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);

	if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 406)
		return SendClientMessage(playerid, 0xCECECEFF, "Вы не работник службы доставки завода");

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /buym [кол-во в кг]");

	extract params -> new buy_metal_count;

	new metall_loaded_count = GetPlayerJobLoadItems(playerid);
	new miner_metal = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT);

	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2424.5317,1765.6780,-0.2507) || !IsPlayerInVehicle(playerid, vehicleid))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться у склада шахты в рабочем транспорте");

	if(!(1 <= buy_metal_count <= 500))
		return SendClientMessage(playerid, 0x999999FF, "Можно загрузить от 1 до 500 кг Материалыа");

	if(miner_metal < buy_metal_count)
		return SendClientMessage(playerid, 0x999999FF, "На складе шахты нет такого количества Материалыа");

	if((metall_loaded_count + buy_metal_count) > 500)
		return SendClientMessage(playerid, 0xCECECEFF, "В фургон столько не поместится");

	if(GetPlayerMoneyEx(playerid) < (buy_metal_count * 15))
		return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки такого количества Материалыа");

	GivePlayerMoneyEx(playerid, -(buy_metal_count * 15), "Покупка Материалыа (развозчик)", true, true);

	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, miner_metal - buy_metal_count);
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);

	SetPlayerJobLoadItems(playerid, metall_loaded_count + buy_metal_count);

	new fmt_str[64];

	format(fmt_str, sizeof fmt_str, "Вы загрузили %d кг Материалыа общей стоимостью %d руб", buy_metal_count, buy_metal_count * 15);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Доставка Материалыа\n{FFFFFF}Загрузка %d / 500 кг", metall_loaded_count + buy_metal_count);
	UpdateVehicleLabel(vehicleid, 0x3399FFFF, fmt_str);

	return 1;
}

CMD:sellm(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /sellm [кол-во в кг]");

	extract params -> new sell_metal_count;

	if(!IsPlayerInRangeOfPoint(playerid, 20.0, -1043.8157,2205.5217,38.1195))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у склада Материалыа завода");

	if(!(1 <= sell_metal_count <= 500))
		return SendClientMessage(playerid, 0x999999FF, "Можно продать от 1 до 500 кг Материалыа");

	new factory_metal = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT);

	if((factory_metal + sell_metal_count) > 1_000_000)
		return SendClientMessage(playerid, 0xCECECEFF, "Склад Материалыа завода заполнен");

	new fmt_str[90];

	new modelid;
	new vehicleid = GetPlayerJobCar(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);

	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY_TRUCKER && IsPlayerInVehicle(playerid, vehicleid) && modelid == 406)
	{
		new metall_loaded_count = GetPlayerJobLoadItems(playerid);

		if(metall_loaded_count < sell_metal_count)
			return SendClientMessage(playerid, 0x999999FF, "В Вашем фургоне нет такого количества Материалыа");

		metall_loaded_count -= sell_metal_count;
		SetPlayerJobLoadItems(playerid, metall_loaded_count);

		format(fmt_str, sizeof fmt_str, "Доставка Материалыа\n{FFFFFF}Загрузка %d / 500 кг", metall_loaded_count);
		UpdateVehicleLabel(vehicleid, 0x3399FFFF, fmt_str);

		AddPlayerData(playerid, P_JOB_WAGE, +, sell_metal_count * 3);
		GivePlayerMoneyEx(playerid, (sell_metal_count * 18), "Продажа Материалыа заводу (развозчик)", true, true);
	}
					else
	{
		if(GetPlayerData(playerid, P_METALL) < sell_metal_count)
			return SendClientMessage(playerid, 0x999999FF, "У Вас с собой нет такого количества Материалыа");

		format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,metall=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) + (sell_metal_count * 18), GetPlayerData(playerid, P_METALL), GetPlayerAccountID(playerid));
		mysql_query(mysql, fmt_str, false);

		if(!mysql_errno())
		{
			AddPlayerData(playerid, P_METALL, -, sell_metal_count);
			GivePlayerMoneyEx(playerid, (sell_metal_count * 18), "Продажа Материалыа заводу", false, true);
		}
					else
			return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 13)");

	}
	format(fmt_str, sizeof fmt_str, "Вы продали заводу %d кг Материалыа на сумму %d руб", sell_metal_count, sell_metal_count * 18);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Ваша чистая выручка составляет {FF9900}%d руб", sell_metal_count * 3);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);

	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT, factory_metal + sell_metal_count);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);

	return 1;
}

CMD:takem(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_ARMY) return SendClientMessage(playerid, 0x999999FF, "Вы не военнослужащий");

	extract params -> new take_metal_count; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /takem [кол-во в кг]");

	if(take_metal_count <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество Материалыа");

	new army_metal = GetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_AMOUNT);

	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2883.7095,1447.6533,1050.9984))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться у склада воинской части");

	if(army_metal < take_metal_count)
		return SendClientMessage(playerid, 0x999999FF, "На складе воинской части нет такого количества Материалыа");

	if((GetPlayerData(playerid, P_METALL) + take_metal_count) > GetPlayerMaxStorage(playerid, STORAGE_METALL))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы не можете унести с собой столько Материалыа (максимум 20 кг)");

	AddPlayerData(playerid, P_METALL, +, take_metal_count);
	UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

	SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_AMOUNT, army_metal - take_metal_count);
	UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL);

	new fmt_str[128];

	format(fmt_str, sizeof fmt_str, "%s[%d] взял(а) на военном складе {00cc33}%d кг Материалыа", GetPlayerNameEx(playerid), playerid, take_metal_count);
	SendMessageToTeam(TEAM_ARMY, fmt_str, 0x3399FFFF);

	return 1;
}

CMD:putm(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_ARMY) return SendClientMessage(playerid, 0x999999FF, "Вы не военнослужащий");

	extract params -> new put_metal_count; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /putm [кол-во в кг]");

	if(put_metal_count <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество Материалыа");

	new army_metal = GetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_AMOUNT);

	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2883.7095,1447.6533,1050.9984))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться у склада воинской части");

	if(GetPlayerData(playerid, P_METALL) < put_metal_count)
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет такого количества Материалыа");

	AddPlayerData(playerid, P_METALL, -, put_metal_count);
	UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

	SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_AMOUNT, army_metal + put_metal_count);
	UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL);

	new fmt_str[128];

	format(fmt_str, sizeof fmt_str, "%s[%d] положил(а) на военный склад {00cc33}%d кг Материалов", GetPlayerNameEx(playerid), playerid, put_metal_count);
	SendMessageToTeam(TEAM_ARMY, fmt_str, 0x3399FFFF);

	return 1;
}

CMD:givemet(playerid, params[])
{
	extract params -> new to_player, give_metall_count; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /givemet [id игрока] [кол-во в кг]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(give_metall_count <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество Материалыа");

	if(give_metall_count > GetPlayerData(playerid, P_METALL))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет такого количества Материалыа");

	new fmt_text[80];

	if((GetPlayerData(to_player, P_METALL) + give_metall_count) > GetPlayerMaxStorage(to_player, STORAGE_METALL))
	{
		format(fmt_text, sizeof fmt_text, "Игрок не может унести с собой столько Материалыа (максимум %d кг)", GetPlayerMaxStorage(to_player, STORAGE_METALL));
		SendClientMessage(playerid, 0xCECECEFF, fmt_text);
	}

	AddPlayerData(playerid, P_METALL, -, give_metall_count);
	UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

	AddPlayerData(to_player, P_METALL, +, give_metall_count);
	UpdatePlayerDatabaseInt(to_player, "metall", GetPlayerData(to_player, P_METALL));

	format(fmt_text, sizeof fmt_text, "~b~-%d metall", give_metall_count);
	GameTextForPlayer(playerid, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "~b~+%d metall", give_metall_count);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали Материалы игроку %s (%d кг.)", GetPlayerNameEx(to_player), give_metall_count);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Игрок %s передал Вам Материалы (%d кг.)", GetPlayerNameEx(playerid), give_metall_count);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}
CMD:givemycoins(playerid, params[])
{
	if (GetPlayerData(playerid, P_TOTALHOUR) < 30) {
		SendClientMessage(playerid, 0x999999FF, "Нужно отыграть 30 часов, чтобы передавать коины");
		return 1;
	}

	extract params -> new to_player, give; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /givemycoins [id игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(give <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество");

	if(give > GetPlayerData(playerid, P_COINS))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет такого количества коинов");

	new fmt_text[80];

	AddPlayerData(playerid, P_COINS, -, give);
	UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

	AddPlayerData(to_player, P_COINS, +, give);
	UpdatePlayerDatabaseInt(to_player, "coins", GetPlayerData(to_player, P_COINS));

	format(fmt_text, sizeof fmt_text, "~b~-%d coin", give);
	GameTextForPlayer(playerid, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "~b~+%d coin", give);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали монеты игроку %s в количестве %d", GetPlayerNameEx(to_player), give);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Игрок %s передал Вам монеты в количестве %d", GetPlayerNameEx(playerid), give);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}

CMD:givepatr(playerid, params[])
{
	extract params -> new to_player, give_ammo_count; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /givepatr [id игрока] [кол-во патронов]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(give_ammo_count <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество патронов");

	if(give_ammo_count > GetPlayerData(playerid, P_AMMO))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет такого количества патронов");

	new fmt_text[80];

	if((GetPlayerData(to_player, P_AMMO) + give_ammo_count) > GetPlayerMaxStorage(to_player, STORAGE_AMMO))
	{
		format(fmt_text, sizeof fmt_text, "Игрок не может унести с собой столько патронов (максимум %d шт)", GetPlayerMaxStorage(to_player, STORAGE_AMMO));
		SendClientMessage(playerid, 0xCECECEFF, fmt_text);
	}

	AddPlayerData(playerid, P_AMMO, -, give_ammo_count);
	UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

	AddPlayerData(to_player, P_AMMO, +, give_ammo_count);
	UpdatePlayerDatabaseInt(to_player, "ammo", GetPlayerData(playerid, P_AMMO));

	format(fmt_text, sizeof fmt_text, "~b~-%d patr.", give_ammo_count);
	GameTextForPlayer(playerid, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "~b~+%d patr.", give_ammo_count);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали Патроны игроку %s (%d шт.)", GetPlayerNameEx(to_player), give_ammo_count);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Игрок %s передал Вам Патроны (%d шт.)", GetPlayerNameEx(playerid), give_ammo_count);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}

CMD:givedrugs(playerid, params[])
{
	extract params -> new to_player, give_drugs_count; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /givedrugs [id игрока] [кол-во в г]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(give_drugs_count <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество наркотиков");

	if(give_drugs_count > GetPlayerData(playerid, P_DRUGS))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет такого количества наркотиков");

	new fmt_text[80];

	if((GetPlayerData(to_player, P_DRUGS) + give_drugs_count) > GetPlayerMaxStorage(to_player, STORAGE_DRUGS))
	{
		format(fmt_text, sizeof fmt_text, "Игрок не может унести с собой столько наркотиков (максимум %d г)", GetPlayerMaxStorage(to_player, STORAGE_DRUGS));
		SendClientMessage(playerid, 0xCECECEFF, fmt_text);
	}

	AddPlayerData(playerid, P_DRUGS, -, give_drugs_count);
	UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

	AddPlayerData(to_player, P_DRUGS, +, give_drugs_count);
	UpdatePlayerDatabaseInt(to_player, "drugs", GetPlayerData(playerid, P_DRUGS));

	format(fmt_text, sizeof fmt_text, "~b~-%d g.", give_drugs_count);
	GameTextForPlayer(playerid, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "~b~+%d g.", give_drugs_count);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали Патроны наркотики %s (%d г.)", GetPlayerNameEx(to_player), give_drugs_count);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Игрок %s передал Вам наркотики (%d г.)", GetPlayerNameEx(playerid), give_drugs_count);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}

CMD:msg(playerid, params[])
{
if(GetPlayerAdminEx(playerid) < 13) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /msg [текст]");

		if(IsAIP(params))
		{
	   		SendClientMessage(playerid, -1, "Подозрения в рекламе!");
	       	return false;
	    }

		new fmt_str[128];

		format(fmt_str, sizeof fmt_str, "Администратор %s: %s", GetPlayerNameEx(playerid), params);
		SendClientMessageToAll(0xFFCD00FF, fmt_str);

		SendLog(playerid, LOG_TYPE_OOC_CHAT, params);
	}

	return 1;
}

alias:msg("o")

CMD:prefix(playerid, params[])
{
    
    if(GetPlayerAdminEx(playerid) < 4) return 1;


	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /prefix [id игрока] [префикс]");

	extract params -> new to_player, string: prefix[15];

	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!strlen(prefix))
		return SendClientMessage(playerid, 0x999999FF, "Введите префикс");

	if(GetPlayerAdminEx(to_player))
	{

		format(GetPlayerData(to_player, P_PREFIX), 15, prefix);
        new fmt_msg[144];
        UpdatePlayerDatabaseString(to_player, "prefix", prefix);

        format(fmt_msg, sizeof(fmt_msg), "[A] %s установил префикс '%s' администратору: %s", GetPlayerNameEx(playerid), GetPlayerData(to_player, P_PREFIX), GetPlayerNameEx(to_player));
        SendMessageToAdmins(fmt_msg, -1);
        SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
        return 1;
	}
					else
		return SendClientMessage(playerid, 0x999999FF, "Данный игрок не администратор!");

}

CMD:ears(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;

	g_admin_ears = g_admin_ears ^ true;

	new fmt_text[70];

	format(fmt_text, sizeof fmt_text, "Вы %s прослушку SMS", g_admin_ears ? "включили" : "выключили");
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s прослушку SMS", GetPlayerNameEx(playerid), playerid, g_admin_ears ? "включил" : "выключил");
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "%s прослушку SMS", g_admin_ears ? "Включил" : "Выключил");

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:62(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 2)
	{
		if(!mp[MP_CREATE])
		{
			SendClientMessage(playerid, 0xCECECEFF, "Мероприятие не создано, создайте его");

			Dialog
			(
				playerid, DIALOG_MP_CREATE, DIALOG_STYLE_INPUT,
				"Создание мероприятия",
				"{FFFFFF}Для создания мероприятия введите\n"\
				"следующие параметры в окно ниже:\n\n"\
				"{33CC66}Параметры: Название, приз\n\n"\
				"{888888}Примечание:\n"\
				"{FFFFFF}- Название может содержать от 1 до 30 символов\n"\
				"- Приз от 1.000.000 до 10.000.000 (деньги)",
				"Далее", "Отмена"
			);
		}
					else
		{
			new fmt_str[1026];

		    format(fmt_str, sizeof fmt_str, \
			"{ffff00}1. {FFFFFF}Название: {ffff00}%s\n"\
			"{ffff00}2. {FFFFFF}Приз: {3399FF}$%d\n"\
			"{ffff00}3. {FFFFFF}Выдать всем скины\n"\
			"{ffff00}4. {FFFFFF}%s телепорт\n"\
			"{ffff00}5. {FFFFFF}Завершить мероприятие\n"\
			"{ffff00}6. {FFFFFF}Чат МП (/smp)",
		 	mp[MP_NAME],
		 	mp[MP_PRIZE],
		 	mp[MP_POS_X] ? ("Закрыть") : ("Открыть"));

			Dialog(playerid, DIALOG_MP_MENU, DIALOG_STYLE_LIST, "Панель МП", fmt_str, "Выбрать", "Закрыть");
		}
	}
	return 1;
}

CMD:63(playerid, params[])
{
	if(!mp[MP_CREATE]) return SendClientMessage(playerid, 0xCECECEFF, "Мероптиятие не создано");

	if(!mp[MP_POS_X]) return SendClientMessage(playerid, 0xCECECEFF, "Координаты мероптиятия не выставлены");

	SetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);

	SendClientMessage(playerid, -1, "Вы были телепортированы на мероприятие");

	SetPlayerData(playerid, P_LAST_MP, 1);

	return 1;
}

CMD:mp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 3)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /mp [текст]");

        new fmt_str[999];

		for(new i; i < MAX_PLAYERS; i ++)
		{
			if(!IsPlayerConnected(i)) continue;
			else if(!IsPlayerLogged(i)) continue;
			else if(GetPlayerData(i, P_LAST_MP) != 0) continue;

			format(fmt_str, sizeof fmt_str, "{FFCC33}[EVENT] Администратор {d58300}%s{FFCC33}: %s", GetPlayerNameEx(playerid), params);
			SendClientMessage(playerid, 0x3399FFFF, fmt_str);
		}
	}
	return 1;
}


CMD:event(playerid, params[])
{
    new pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));

    if(GetPlayerAdminEx(playerid) >= 2 || strcmp(pname, "", true) == 0)
	{
		if(!mp[MP_CREATE])
		{
			Dialog
			(
				playerid, DIALOG_EVENT_CREATE, DIALOG_STYLE_INPUT,
				"{00FFFF}"SERVER_NAME" {FFFFFF}| Создание мероприятия",
				"{FFFFFF}Для создания мероприятия введите его название и сумму приза\n"\
				"в одном сообщении, через запятую.\n\n"\
				"{FFFFFF}Пример: {AFAFAF}Мясо, 50000\n\n"\
				"{FFFFFF}- Название: от 3 до 32 символов (русские/латинские буквы, цифры)\n"\
				"- Сумма приза: только число, не менее 0",
				"Далее", "Отмена"
			);
		}
					else
		{
new fmt_str[1026];

format(fmt_str, sizeof fmt_str, \
    "{FFFF00}01. {FFFFFF} Название мероприятия: {ffff00}%s\n"\
    "{FFFF00}02. {FFFFFF} Приз мероприятия: {ffff00}%d игровых рублей\n"\
    "{FFFF00}03. {FFFFFF} Чат мероприятия - /mp\n"\
    "{FFFF00}04. {FFFFFF} %s телепорт на мероприятие\n"\
    "{FFFF00}05. {FFFFFF} Закончить мероприятие\n"\
    "{FFFF00}06. {FFFFFF} Выдать всем участникам мероприятия скины\n"\
    "{FFFF00}07. {FFFFFF} Выдать всем участникам мероприятия здоровье\n"\
    "{FFFF00}08. {FFFFFF} Выдать всем участникам мероприятия броню\n"\
    "{FFFF00}09. {FFFFFF} Выдать всем участникам мероприятия диглы\n"\
    "{FFFF00}10. {FFFFFF} Выдать всем участникам мероприятия дробовики\n"\
    "{FFFF00}11. {FFFFFF} Выдать всем участникам мероприятия MP5\n"\
    "{FFFF00}12. {FFFFFF} Заморозить всех участников мероприятия\n"\
    "{FFFF00}13. {FFFFFF} Разморозить всех участников мероприятия\n"\
    "{FFFF00}14. {FFFFFF} Обезоружить всех участников мероприятия", // <-- Запятая для аргументов format
    mp[MP_NAME],
    mp[MP_PRIZE],
    mp[MP_POS_X] ? ("Закрыть") : ("Открыть") // Последний аргумент без запятой
); // <-- Добавлена точка с запятой здесь

Dialog(playerid, DIALOG_EVENT_MENU, DIALOG_STYLE_LIST,
    "{FFFF00}" SERVER_NAME " {FFFFFF}| Меню мероприятий",
    fmt_str,
    "Выбрать",
    "Закрыть"
);

		}
	}
	return 1;
}

CMD:gevent(playerid, params[])
{
	if(!mp[MP_CREATE]) return SendClientMessage(playerid, 0xCECECEFF, "Мероптиятие не создано");

	if(!mp[MP_POS_X]) return SendClientMessage(playerid, 0xCECECEFF, "Координаты мероптиятия не выставлены");

	SetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);

	SendClientMessage(playerid, -1, "Вы были телепортированы на мероприятие");

	SetPlayerData(playerid, P_LAST_MP, 1);

	return 1;
}



CMD:namelist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 2)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используй: /namelist [id игрока]");

		extract params -> new to_player;

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
			return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

		if(!GetPVarInt(to_player, "change_name_status"))
			return SendClientMessage(playerid, 0xCECECEFF, "Игрок не подавал запрос на смену ника");

		new player_name[20 + 1];
		GetPVarString(to_player, "change_name", player_name, sizeof(player_name));

		if(ChangePlayerName(to_player, player_name, true))
		{
			Dialog
			(
				to_player, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
				"{FFCD00}Имя изменено",
				"{66FF00}Заявка на изменение имени одобрена, новое имя установлено.\n\n"\
				"{FFFFFF}В следующий раз при входе в игру используйте свое новое имя. Для\n"\
				"этого нужно изменить его в окне клиента CRMP. Рекомендуем прямо\n"\
				"сейчас свернуть игру и сделать это.",
				"Ок", ""
			);
		}
					else SendClientMessage(playerid, 0xFF6600FF, "При смене ника произошла ошибка");

		new fmt_text[75];

		format(fmt_text, sizeof fmt_text, "[A] %s[%d] одобрил заявку на смену никнейма", GetPlayerNameEx(playerid), playerid);
		SendMessageToAdmins(fmt_text, 0x999999FF);

		DeletePVar(to_player, "change_name");
		DeletePVar(to_player, "change_name_status");

		format(fmt_text, sizeof fmt_text, "Одобрил заявку смены никнейма для %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
	}

	return 1;
}

CMD:cc(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 10) return 1;

    // Пустая строка "" отбрасывается клиентом и не сдвигает историю чата.
    // Строка с пробелом и цветовым кодом отображается как пустая на всех клиентах.
    for(new i = 0; i < 100; i++)
    {
        SendClientMessageToAll(0xFFFFFFFF, "{FFFFFF} ");
    }

    new cc[128];
    format(cc, sizeof(cc), CCMessage, GetPlayerNameEx(playerid));
    SendClientMessageToAll(0xFFCD00FF, cc);

    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Очистил чат");

    return 1;
}

CMD:leave(playerid, params[])
{
	if(GetPlayerData(playerid, P_IMPROVEMENTS) < 2) return SendClientMessage(playerid, 0x999999FF, "Приобретите улучшение \"Решительность\", чтобы уволиться по собственному желанию");

	if(!GetPlayerTeamEx(playerid)) return ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы не состоите в организации", "");

	new fmt_text[999];

	format
	(
		fmt_text, sizeof fmt_text,
		""SC"Ваша организация{ffff00}: \"%s\".\n\n"\
		"{ffffff}Вы действительно хотите покинуть данную организацию по\n"\
		"{ffffff}собственному желанию?",
		GetTeamName(GetPlayerTeamEx(playerid))
	);

	Dialog(playerid, DIALOG_TEAM_LEAVE, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME" {ffffff}| Подтверждение", fmt_text, "Далее", "Отмена");

	return 1;
}

CMD:avig(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 9) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /avig [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string:reason[66];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!GetPlayerAdminEx(to_player))
	    return SendClientMessage(playerid, 0xCECECEFF, "Игрок не является администратором");

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать предупреждение админу выше по рангу");

	//if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать предупреждение самому себе");

	AddPlayerData(to_player, P_ADMIN_WARN, +, 1);

	new fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "[A] %s выдал предупреждение администратору %s [%d|3]. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetPlayerData(to_player, P_ADMIN_WARN), reason);

	SendMessageToAdmins(fmt_msg, 0xFF5533FF);

	new uid = GetPlayerAccountID(to_player);
	new warns = GetPlayerData(to_player, P_ADMIN_WARN);

	format(fmt_msg, sizeof fmt_msg, "Выдал аварн %s[acc:%d] (%d/3). Причина: %d", GetPlayerNameEx(to_player), uid, warns, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	if(warns >= 3)
	{
		SendClientMessage(to_player, 0xFF5533FF, "Ваш администраторский уровень аннулирован");

		warns = 0;

		SetPlayerData(to_player, P_ADMIN, 0);
		UpdatePlayerDatabaseInt(to_player, "admin", 0);
	}
					else SendClientMessage(to_player, 0xFF5533FF, "При получении 3-ёх предупреждений Вы будете сняты с поста администратора");

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET admin_warn=%d WHERE id=%d", warns, uid);
	mysql_query(mysql, fmt_msg, false);

	return 1;
}
CMD:unavig(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 9) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /unavig [id игрока] [причина]");

	extract params -> new to_player, string: reason[66];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(!GetPlayerAdminEx(to_player))
	    return SendClientMessage(playerid, 0xCECECEFF, "Игрок не является администратором");

	SetPlayerData(to_player, P_ADMIN_WARN, 				0);

	UpdatePlayerDatabaseInt(to_player, "admin_warn", 	0);

	new fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "[A] %s снял все предупреждения с администратора %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player),reason);

	SendMessageToAdmins(fmt_msg, 0xFF5533FF);

	format(fmt_msg, sizeof fmt_msg, "Снял все аварны %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:setleader(playerid, params[])
{
    // Проверка уровня админки (требуется 5+)
    if(GetPlayerAdminEx(playerid) < 5)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", "");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xFFFFFFFF, ""SC"Используйте /setleader [ID игрока]");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

    g_player[playerid][P_TARGET_PLAYER_ID] = targetid;

    new leader_dialog[512];
    leader_dialog[0] = '\0';
    strcat(leader_dialog, "{F0E68C}| Правительство {008000}Выдать\n");
    strcat(leader_dialog, "{4169E1}| ФСБ {008000}Выдать\n");
    strcat(leader_dialog, "{4169E1}| Отдел полиции №1 (УМВД) {008000}Выдать\n");
    strcat(leader_dialog, "{4169E1}| Отдел полиции №2 (ГИБДД) {008000}Выдать\n");
    strcat(leader_dialog, "{8B4513}| Армия {008000}Выдать\n");
    strcat(leader_dialog, "{FA8072}| Больница {008000}Выдать\n");
    strcat(leader_dialog, "{FF4500}| СМИ {008000}Выдать\n");
    strcat(leader_dialog, "{32CD32}| Арзамасская ОПГ {008000}Выдать\n");
    strcat(leader_dialog, "{7B68EE}| Батыревская ОПГ {008000}Выдать\n");
    strcat(leader_dialog, "{FFD700}| Лыткаринская ОПГ {008000}Выдать\n");
    strcat(leader_dialog, "{3399FF}| ФСИН {008000}Выдать\n");
    strcat(leader_dialog, "{FFFFFF}| Снять с поста");

    Dialog(playerid, 19464, DIALOG_STYLE_LIST,
        "{00FFFF}"SERVER_NAME" {FFFFFF}| Выдача постоянного лидерства",
        leader_dialog, "Выбрать", "Выход");
    return 1;
}

CMD:ahelp(playerid)
{
    return SRAdmin_ShowHelp(playerid);
}

CMD:spoff(playerid, params[])
{
    #pragma unused params
    if(!SRAdmin_TeleportAllowed(playerid)) return 1;

    if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
    {
        StopSpectate(playerid);
    }

    return 1;
}

CMD:weap(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /weap [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_text[625],
		text[45];

	format
	(
		fmt_text,
		sizeof fmt_text,
		"\
		Слот\tОружие\t\tПатроны\n{FFFFFF}\
		"
	);

	for(new i = 0; i < 13; i++)
	{
		new weapon_id, weapon_ammo;

		GetPlayerWeaponData(to_player, i, weapon_id, weapon_ammo);

		format(text, sizeof text, "\n%d\t%s%s%d", i+1, GetWeaponName(weapon_id), weapon_dialog_tabulation[weapon_id], weapon_ammo);
		strcat(fmt_text, text);
	}

	Dialog
	(
		playerid,
		INVALID_DIALOG_ID,
		DIALOG_STYLE_LIST,
		"{FFCC00}Оружия у игрока",
		fmt_text,
		"Закрыть",
		""
	);

	format(fmt_text, sizeof fmt_text, "Смотрит оружие %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:givegun(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У Вас нет доступа к этой команде", ""), 1;

	new to_player, weapon_id, weapon_ammo;
	if(sscanf(params, "iii", to_player, weapon_id, weapon_ammo))
		return SendClientMessage(playerid, 0xCECECEFF, "Использование: /givegun [ID игрока] [ID оружия] [патроны]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Игрок не найден");

	if(weapon_id < 1 || weapon_id > 46 || (19 <= weapon_id <= 21))
		return SendClientMessage(playerid, 0xCECECEFF, "ID оружия: 1-18 или 22-46 (Desert Eagle: 24)");

	if(weapon_ammo < 1 || weapon_ammo > 10000)
		return SendClientMessage(playerid, 0xCECECEFF, "Количество патронов должно быть от 1 до 10000");

	GivePlayerWeapon(to_player, weapon_id, weapon_ammo);

	new fmt_text[180];
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] выдал %s[%d] оружие %s (ID %d), патроны: %d",
		GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player,
		GetWeaponName(weapon_id), weapon_id, weapon_ammo);
	SendMessageToAdmins(fmt_text, 0x999999FF);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выдали %s[%d] оружие %s (ID %d), патроны: %d",
		GetPlayerNameEx(to_player), to_player, GetWeaponName(weapon_id), weapon_id, weapon_ammo);
	SendClientMessage(playerid, 0x66CC99FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Администратор %s выдал Вам оружие %s (ID %d), патроны: %d",
		GetPlayerNameEx(playerid), GetWeaponName(weapon_id), weapon_id, weapon_ammo);
	SendClientMessage(to_player, 0x66CC99FF, fmt_text);
	return 1;
}

CMD:adonate(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) >= 1)
    {
		ShowPlayerAdminDonate(playerid);
	}
	return 1;
}

CMD:a(playerid, params[])
{
    return SRAdmin_Chat(playerid, params);
}




CMD:admins(playerid, params[])
{
    return SRAdmin_ShowList(playerid, 0);
}


