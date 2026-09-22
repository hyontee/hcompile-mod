//>> Файл: bykranin_src/core/property/property_07.inc  (781 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: /gzcolor, /sellproperty, /sellhotels, /setprods, /fullprods, /setfuels, /fullfuels
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:gzcolor(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new gang_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gzcolor [id банды] (0-Свободная зона, 1-Арзамасская ОПГ, 2-Батыревская ОПГ, 3-Лыткаринская ОПГ)");

	if(!(0 <= gang_id <= 3))
		return SendClientMessage(playerid, 0x999999FF, "Банды: 0-Свободная зона, 1-Арзамасская ОПГ, 2-Батыревская ОПГ, 3-Лыткаринская ОПГ");

	new gang_zone_id = -1;

	for(new idx; idx < g_gang_zones_loaded; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, GetGangZoneData(idx, GZ_AREA))) continue;

		gang_zone_id = idx;
		break;
	}

	if(gang_zone_id == -1)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на нужной территории");

	//SetGangZoneData(gang_zone_id, GZ_GANG, gang_id);
	//SaveGangZone(gang_zone_id);

	//GangZoneShowForAll(GetGangZoneData(gang_zone_id, GZ_ZONE), gang_zone_colors[ GetGangZoneData(gang_zone_id, GZ_GANG) ]);

	new fmt_text[75];

	SendClientMessage(playerid, -1, "Вы изменили банду, владеющую данной территорией");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] изменил банду у территории №%d на %d", GetPlayerNameEx(playerid), playerid, gang_zone_id, gang_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "Изменил банду у территории №%d на %d", gang_zone_id, gang_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:sellproperty(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	SellDebtorsProperty();

	new fmt_text[75];

	SendClientMessage(playerid, -1, "Вы инициировали продажу имущества должников");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] инициировал продажу имущества должников", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Иницировал продажу имущества должников");

	return 1;
}

CMD:sellhotels(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	SellDebtorsHotels();

	new fmt_text[90];

	SendClientMessage(playerid, -1, "Вы инициировали продажу номеров с задолженностью в отеле");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] инициировал продажу номеров с задолженностью в отеле", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Инициировал продажу номеров в отеле");

	return 1;
}

CMD:setprods(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new biz_id, amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setprods [id бизнеса] [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество продуктов от 0 до 10000");

	if(!(0 <= biz_id <= g_business_loaded - 1))
		return SendClientMessage(playerid, 0x999999FF, "Данного бизнеса не существует на сервере");

	SetBusinessData(biz_id, B_PRODS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d продуктов в бизнесе №%d", amount, biz_id);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d продуктов в бизнесе №%d", GetPlayerNameEx(playerid), playerid, amount, biz_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:fullprods(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fullprods [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество продуктов от 0 до 10000");

	for(new biz_id; biz_id < g_business_loaded - 1; biz_id ++)
		SetBusinessData(biz_id, B_PRODS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d", amount);
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d продуктов во всех бизнесах", amount);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d продуктов во всех бизнесах", GetPlayerNameEx(playerid), playerid, amount);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:setfuels(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new fs_id, amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setfuels [id АЗС] [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество топлива от 0 до 10000");

	if(!(0 <= fs_id <= g_fuel_station_loaded-1))
		return SendClientMessage(playerid, 0x999999FF, "Данной АЗС не существует на сервере");

	SetFuelStationData(fs_id, FS_FUELS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE fuel_stations SET fuels=%d WHERE id=%d", GetFuelStationData(fs_id, FS_FUELS), GetFuelStationData(fs_id, FS_SQL_ID));
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива в АЗС №%d", amount, fs_id);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d топлива в АЗС №%d", GetPlayerNameEx(playerid), playerid, amount, fs_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:fullfuels(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fullfuels [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество топлива от 0 до 10000");

	for(new fs_id; fs_id < g_fuel_station_loaded - 1; fs_id ++)
		SetFuelStationData(fs_id, FS_FUELS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE fuel_stations SET fuels=%d", amount);
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива во всех АЗС", amount);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d топлива во всех АЗС", GetPlayerNameEx(playerid), playerid, amount);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}
/*
CMD:addbiz(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) != 13) return 1;

	extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addbiz [тип] [стоимость] [цена аренды]");

	new fmt_text[300];

	if(!(1 <= type <= 11))
		return SendClientMessage(playerid, 0x999999FF, "Типы бизнесов: 1-24/7, 2-Клуб, 3-Управление стат., 4-Риэлторск., 5-Одежда, 6-Отель, 7-Авторынок, 8-Казино, 9-Сотовый салон 10 - Тюнинг салон 11-Магазин оружия");

	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость бизнеса не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость аренды не может быть меньше 1");

	new Cache: result,
		idx = g_business_loaded;

	GetPlayerPos(playerid, g_business[idx][B_POS_X], g_business[idx][B_POS_Y], g_business[idx][B_POS_Z]);

	SetBusinessData(idx, B_PRICE,			price);
	SetBusinessData(idx, B_RENT_PRICE,		rent_price);
	SetBusinessData(idx, B_TYPE,			type);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO business \
		(type, price, rent_price, x, y, z)\
		VALUES ('%d', '%d', '%f', '%f', '%f', '%f')",
		type, price, rent_price,
		GetBusinessData(idx, B_POS_X),
		GetBusinessData(idx, B_POS_Y),
		GetBusinessData(idx, B_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetBusinessData(idx, B_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_business_loaded ++;

	RecreateBusinessEnterPickup(idx);

	UpdateBusinessLabel(idx);

	new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), city);
	GetAreaName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), area);
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал бизнес №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, x, city, area);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);

	SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/bsetexitpos{3399FF}, чтобы завершить создание бизнеса");

	return 1;
}
*/

CMD:addbiz(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

    extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addbiz [тип] [стоимость] [цена аренды]");

    new fmt_text[320];

    if(!(1 <= type <= 11) && type != BUSINESS_TYPE_ACCESSORY_SHOP)
        return SendClientMessage(playerid, 0x999999FF, "Типы бизнесов: 1-24/7, 2-Клуб, 3-Управление стат., 4-Риэлторск., 5-Одежда, 6-Отель, 7-Авторынок, 8-Казино, 9-Сотовый салон 10 - Тюнинг салон 11-Магазин оружия");

    if(price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость бизнеса не может быть меньше 1");

    if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость аренды не может быть меньше 1");

    new Cache: result,
        idx = g_business_loaded;

    GetPlayerPos(playerid, g_business[idx][B_POS_X], g_business[idx][B_POS_Y], g_business[idx][B_POS_Z]);

    SetBusinessData(idx, B_PRICE,			price);
    SetBusinessData(idx, B_RENT_PRICE,		rent_price);
    SetBusinessData(idx, B_TYPE,			type);

    SetBusinessData(idx, B_INTERIOR,		type-1);

    format
    (
        fmt_text, sizeof fmt_text,
        "INSERT INTO business \
        (type, price, rent_price, x, y, z, interior)\
        VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '%d')",
        type, price, rent_price,
        GetBusinessData(idx, B_POS_X),
        GetBusinessData(idx, B_POS_Y),
        GetBusinessData(idx, B_POS_Z),
        type-1
    );

    result = mysql_query(mysql, fmt_text, true);

    SetBusinessData(idx, B_SQL_ID, 		cache_insert_id());
    
    cache_delete(result);

    g_business_loaded ++;

    RecreateBusinessEnterPickup(idx);

    UpdateBusinessLabel(idx);

    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
    GetCityName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), city);
    GetAreaName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), area);
    format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал бизнес №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);

    SendMessageToAdmins(fmt_text, 0x66CC33FF);

    SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/bsetexitpos{3399FF}, чтобы завершить создание бизнеса");

    return 1;
}

CMD:bsetexitpos(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;
    extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bsetexitpos [id бизнеса]");

    if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного бизнеса не существует на сервере");

    GetPlayerPos(playerid, g_business[biz_id][B_EXIT_POS_X], g_business[biz_id][B_EXIT_POS_Y], g_business[biz_id][B_EXIT_POS_Z]);
    GetPlayerFacingAngle(playerid, g_business[biz_id][B_EXIT_ANGLE]);

    new fmt_text[144];

    format
    (
        fmt_text, sizeof fmt_text,
        "UPDATE business SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
        GetBusinessData(biz_id, B_EXIT_POS_X),
        GetBusinessData(biz_id, B_EXIT_POS_Y),
        GetBusinessData(biz_id, B_EXIT_POS_Z),
        GetBusinessData(biz_id, B_EXIT_ANGLE),
        GetBusinessData(biz_id, B_SQL_ID)
    );

    mysql_query(mysql, fmt_text, false);

    format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у бизнеса №%d", biz_id);

    SendClientMessage(playerid, 0x66CC33FF, fmt_text);

    return 1;
}

CMD:bsetpos(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;
    

	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bsetpos [id бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного бизнеса не существует на сервере");

	GetPlayerPos(playerid, g_business[biz_id][B_POS_X], g_business[biz_id][B_POS_Y], g_business[biz_id][B_POS_Z]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE business SET x='%f', y='%f', z='%f' WHERE id=%d",
		GetBusinessData(biz_id, B_POS_X),
		GetBusinessData(biz_id, B_POS_Y),
		GetBusinessData(biz_id, B_POS_Z),
		GetBusinessData(biz_id, B_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты входа у бизнеса №%d (%s)", biz_id, GetBusinessData(biz_id, B_NAME));
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	SendClientMessage(playerid, -1, "Не забудьте использовать /bsetexitpos id Для изменения координат выхода");
	UpdateBusinessLabel(biz_id);
	return 1;
}

CMD:addfuelst(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;
    

	extract params -> new price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addfuelst [стоимость] [цена аренды]");

	if(price < 1) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость бензоколонки не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость бензоколонки не может быть меньше 1");

	new Cache: result,
		idx = g_fuel_station_loaded;

	GetPlayerPos(playerid, g_fuel_station[idx][FS_POS_X], g_fuel_station[idx][FS_POS_Y], g_fuel_station[idx][FS_POS_Z]);

	new fmt_text[256];

	format
	(

		fmt_text, sizeof fmt_text,
		"INSERT INTO `fuel_stations`\
		(`price`,`rent_price`,`fuels`, `fuel_price`, `buy_fuel_price`, `balance`, `x`, `y`, `z`)\
		VALUES('%d','%d','100','50','50','100000','%f','%f','%f')",
		price, rent_price,
		GetFuelStationData(idx, FS_POS_X),
		GetFuelStationData(idx, FS_POS_Y),
		GetFuelStationData(idx, FS_POS_Z)
	);


	result = mysql_query(mysql, fmt_text, true);

	SetFuelStationData(idx, FS_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_fuel_station_loaded ++;

	SetFuelStationData(idx, FS_LABEL, CreateDynamic3DTextLabel("бензоколонка", 0xFFFF00FF, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z) + 0.3, 6.50));

	UpdateFuelStationLabel(idx);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал заправку №%d", GetPlayerNameEx(playerid), playerid, idx);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);
	return 1;
}

/*CMD:addpadik(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	new fmt_text[300];


	new Cache: result,
		idx = g_entera;

	GetPlayerPos(playerid, g_house[idx][H_POS_X], g_house[idx][H_POS_Y], g_house[idx][H_POS_Z]);

	SetHouseData(idx, H_PRICE,			price);
	SetHouseData(idx, H_RENT_PRICE,		rent_price);
	SetHouseData(idx, H_TYPE,			type);

	SetHouseData(idx, H_ENTRACE,		-1);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO houses \
		(type, price, rent_price, x, y, z)\
		VALUES ('%d', '%d', '%f', '%f', '%f', '%f')",
		type, price, rent_price,
		GetHouseData(idx, H_POS_X),
		GetHouseData(idx, H_POS_Y),
		GetHouseData(idx, H_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetHouseData(idx, H_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_house_loaded ++;

	UpdateHouse(idx);

	new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y), city);
	GetAreaName(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y), area);
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал дом №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);

	SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/setexitpos и /setcarpos{3399FF}, чтобы завершить создание дома");

	return 1;
}

*/
CMD:addadse(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addhouse [тип] [стоимость] [цена аренды]");

	new fmt_text[300];

	if(!(0 <= type <= sizeof g_house_type - 1))
	{
		SendClientMessage(playerid, 0x999999FF, "Типы домов:");

		for(new i; i < sizeof g_house_type; i ++)
		{
			format(fmt_text, sizeof fmt_text, "%d. %s", i, GetHouseTypeInfo(i, HT_NAME));

			SendClientMessage(playerid, 0xCECECEFF, fmt_text);
		}

		return 1;
	}

	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость дома не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость аренды не может быть меньше 1");

	new Cache: result,
		idx = g_house_loaded;

	GetPlayerPos(playerid, g_house[idx][H_POS_X], g_house[idx][H_POS_Y], g_house[idx][H_POS_Z]);

	SetHouseData(idx, H_PRICE,			price);
	SetHouseData(idx, H_RENT_PRICE,		rent_price);
	SetHouseData(idx, H_TYPE,			type);

	SetHouseData(idx, H_ENTRACE,		-1);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO houses \
		(type, price, rent_price, x, y, z)\
		VALUES ('%d', '%d', '%f', '%f', '%f', '%f')",
		type, price, rent_price,
		GetHouseData(idx, H_POS_X),
		GetHouseData(idx, H_POS_Y),
		GetHouseData(idx, H_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetHouseData(idx, H_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_house_loaded ++;

	UpdateHouse(idx);

	new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y), city);
	GetAreaName(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y), area);
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал дом №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);

	SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/setexitpos и /setcarpos{3399FF}, чтобы завершить создание дома");

	return 1;
}

CMD:setexitpos(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;
    if(TEST_SERVER == 14) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setexitpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_EXIT_POS_X], g_house[house_id][H_EXIT_POS_Y], g_house[house_id][H_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_EXIT_ANGLE]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE houses SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
		GetHouseData(house_id, H_EXIT_POS_X),
		GetHouseData(house_id, H_EXIT_POS_Y),
		GetHouseData(house_id, H_EXIT_POS_Z),
		GetHouseData(house_id, H_EXIT_ANGLE),
		GetHouseData(house_id, H_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у дома №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

CMD:setcarpos(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;
    

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setcarpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_CAR_POS_X], g_house[house_id][H_CAR_POS_Y], g_house[house_id][H_CAR_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_CAR_ANGLE]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE houses SET car_x='%f', car_y='%f', car_z='%f', car_angle='%f' WHERE id=%d",
		GetHouseData(house_id, H_CAR_POS_X),
		GetHouseData(house_id, H_CAR_POS_Y),
		GetHouseData(house_id, H_CAR_POS_Z),
		GetHouseData(house_id, H_CAR_ANGLE),
		GetHouseData(house_id, H_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты спавна авто у дома №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

CMD:getname(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new user_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /getname [номер аккаунта]");

	new name[21],
		fmt_text[120];

	format(name, sizeof name, "%s", GetPlayerNameBySqlID(user_id));

	if(strcmp(name, "none", true))
	{
		format(fmt_text, sizeof fmt_text, "Имя: %s / Номер аккаунта: %d", name, user_id);

		SendClientMessage(playerid, 0xFFFF00FF, fmt_text);
	}
					else SendClientMessage(playerid, 0x999999FF, "Данный аккаунт не найден в базе данных");

	return 1;
}

// Slap: реальный телепорт по координатам (одинаково для вверх и вниз),
// работает и пешком, и в транспорте. offset > 0 - вверх, offset < 0 - вниз.
#define SLAP_UP_OFFSET    (8.0)
#define SLAP_DOWN_OFFSET  (-5.0)

stock Slap_MoveZ(targetid, Float:offset)
{
	new Float:sx, Float:sy, Float:sz;

	if(IsPlayerInAnyVehicle(targetid))
	{
		new vehicleid = GetPlayerVehicleID(targetid);
		GetVehiclePos(vehicleid, sx, sy, sz);
		SetVehiclePos(vehicleid, sx, sy, sz + offset);
		SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	}
	else
	{
		GetPlayerPos(targetid, sx, sy, sz);
		SetPlayerPos(targetid, sx, sy, sz + offset);
		SetPlayerVelocity(targetid, 0.0, 0.0, 0.0);
	}
	PlayerPlaySound(targetid, 1130, 0.0, 0.0, 0.0);
	return 1;
}

CMD:slap(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;

	extract params -> new to_player, set_code, string: reason[30]; else {

		SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /slap [id игрока] [0 - вверх, 1 - вниз] [причина]");

		return 1;
	}
	
	new fmt_text[999];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new fmt_msg[999];

	switch(set_code)
	{
		case 0:
		{
			// Реальный телепорт вверх (не слабый импульс) - всегда заметен.
			Slap_MoveZ(to_player, SLAP_UP_OFFSET);

			format(fmt_text, sizeof fmt_text, "[A] %s[%d] подбросил игрока %s[%d]. Причина: %s ", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, reason);
			SendMessageToAdmins(fmt_text, 0x999999FF);

			format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы подбросили игрока %s[%d]. Причина: %s ", GetPlayerNameEx(to_player), to_player, reason);
			SendClientMessage(playerid, -1, fmt_msg);
			
			format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] подбросил Вас. Причина: %s ", GetPlayerNameEx(playerid), playerid, reason);
			SendClientMessage(to_player, -1, fmt_text);	
		}
		case 1:
		{
			// Реальный телепорт вниз по координатам - так же, как slap вверх.
			Slap_MoveZ(to_player, SLAP_DOWN_OFFSET);

			format(fmt_text, sizeof fmt_text, "[A] %s[%d] опустил игрока %s[%d]. Причина: %s ", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, reason);
			SendMessageToAdmins(fmt_text, 0x999999FF);

			format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы опустили игрока %s[%d]. Причина: %s ", GetPlayerNameEx(to_player), to_player, reason);
			SendClientMessage(playerid, -1, fmt_msg);
			
			format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] опустил Вас. Причина: %s ", GetPlayerNameEx(playerid), playerid, reason);
			SendClientMessage(to_player, -1, fmt_text);
		}
		default: return SendClientMessage(playerid, 0xFF6600FF, "Ошибка: Неверно введен код");
	}

	return 1;
}

CMD:sethp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sethp [id игрока] [количество здоровья]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "Администраторам 1-го уровня доступно изменение только своего уровня здоровья");

	else if(!(0 <= health <= 100)) return SendClientMessage(playerid, 0x999999FF, ""SC"Уровень здоровья от 0 до 100");

	SetPlayerData(to_player, P_HEALTH, health);
	SetPlayerHealthEx(to_player, health);

	if(GetPlayerData(to_player, P_HOSPITAL))
		SetPlayerData(to_player, P_HOSPITAL, false);

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил уровень здоровья %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
	SendMessageToAdmins(fmt_msg, 0x999999FF);
	
	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы изменили %s[%d] уровень здоровья", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_msg);	
	
	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] изменил Вам уровень здоровья", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, -1, fmt_msg);	

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] уровень здоровья на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:hp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sethp [id игрока] [количество здоровья]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "Администраторам 1-го уровня доступно изменение только своего уровня здоровья");

	else if(!(0 <= health <= 100)) return SendClientMessage(playerid, 0x999999FF, ""SC"Уровень здоровья от 0 до 100");

	SetPlayerData(to_player, P_HEALTH, health);
	SetPlayerHealthEx(to_player, health);

	if(GetPlayerData(to_player, P_HOSPITAL))
		SetPlayerData(to_player, P_HOSPITAL, false);

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил уровень здоровья %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
	SendMessageToAdmins(fmt_msg, 0x999999FF);
	
	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы изменили %s[%d] уровень здоровья", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_msg);	
	
	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] изменил Вам уровень здоровья", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, -1, fmt_msg);	

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] уровень здоровья на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}


