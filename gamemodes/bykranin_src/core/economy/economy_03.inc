//>> Файл: bykranin_src/core/economy/economy_03.inc  (667 строк)
//>> Тема: экономика: банк, донат, промокоды, аукцион, обмен, торговля
//>> Внутри: ProcessShop247Purchase, /buy, /healme, /present, /mask, /dis, /offdis
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock bool:ProcessShop247Purchase(playerid, businessid, price, take_prods, reason[])
{
    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас не хватает денег"), false;

    new query[255];
    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
    {
        format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
    }
    else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));

    mysql_query(mysql, query, false);
    if(mysql_errno())
        return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку"), false;

    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
    {
        SetBusinessData(businessid, B_PRODS, 10_000);
        AddBusinessData(businessid, B_BALANCE, +, price/2);
    }

    mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(playerid, -price, reason, false, true);
    return true;
}

CMD:buy(playerid, params[])
{
	if(Diner_HandleBuyCommand(playerid))
	{
		return 1;
	}

    new businessid = GetPlayerInBiz(playerid);
	if(businessid != -1)
	{
		if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
		{
            Dialog
            (
                playerid, DIALOG_BIZ_SHOP_24_7, DIALOG_STYLE_TABLIST_HEADERS,
                "{0099FF}Магазин 24/7",
                "{FFFFFF}Товар:	Цена:\n"\
                "1. Аптечка	{00CC00}300 руб\n"\
                "2. Букет цветов	{00CC00}150 руб\n"\
                "3. Трость	{00CC00}600 руб\n"\
                "4. Мобильный телефон	{00CC00}2100 руб\n"\
                "5. Изменить номер	{00CC00}450 руб\n"\
                "6. Изменить цвет телефона	{00CC00}200 руб\n"\
                "7. Пополнить счёт телефона\n"\
                "8. Наушники	{00CC00}10000 руб\n"\
                "9. Ремонтный комплект	{00CC00}350 руб",
                "Купить", "Отмена"
            );
		}
					else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
		{
            Dialog
            (
                playerid, DIALOG_BIZ_CELL_SALON, DIALOG_STYLE_LIST,
                "{FFCD00}Сотовый салон",
                "1. Мобильный телефон	{00CC00}2100 руб\n"\
                "2. Изменение номера	{00CC00}450 руб\n"\
                "3. Дизайн телефона	{00CC00}200 руб\n"\
                "4. Пополнить счёт телефона",
                "Купить", "Отмена"
            );
		}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны быть в продуктовом магазине/24/7");
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны быть в продуктовом магазине/24/7");

	return 1;
}

CMD:healme(playerid, params[])
{
	if(GetPlayerData(playerid, P_MED_CHEST) <= 0)
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет с собой аптечки");

	AddPlayerData(playerid, P_MED_CHEST, -, 1);
	UpdatePlayerDatabaseInt(playerid, "healme", GetPlayerData(playerid, P_MED_CHEST));
	SetPlayerHealthEx(playerid, 60.0, true);

	GameTextForPlayer(playerid, "~b~+60 hp", 4000, 1);
	SendClientMessage(playerid, 0x3399FFFF, "Вы использовали аптечку. Здоровье пополнено на 60 единиц");

	ApplyAnimationEx(playerid, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0, 1);

	return 1;
}

CMD:present(playerid, params[])
{
	if(!IsPlayerHaveWeapon(playerid, WEAPON_FLOWER))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет цветов");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /present [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 3.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Игрок слишком далеко");

	if(IsPlayerHaveWeapon(to_player, WEAPON_FLOWER))
		return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока уже есть букет цветов");

	new fmt_str[64];

	new Float: angle;
	new Float: to_x, Float: to_y;
	new Float: x, Float: y, Float: z;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerPos(to_player, to_x, to_y, z);

	angle = GetAngleToPoint(to_x, to_y, x, y);

	SetPlayerFacingAngle(playerid, angle);
	SetPlayerFacingAngle(to_player, angle + 180.0);

	ApplyAnimationEx(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0, 0);
	ApplyAnimationEx(to_player, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0, 0);

	format(fmt_str, sizeof fmt_str, "%s получил(а) от Вас цветы", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_str);

	format(fmt_str, sizeof fmt_str, "%s подарил(а) Вам цветы", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_str);

	SetTimerEx("PresentFlowersToPlayer", 1500, false, "ii", playerid, to_player);
	return 1;
}

CMD:mask(playerid, params[])
{
	if(GetPlayerData(playerid, P_MASK) != 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет с собой маски");

	SetPlayerData(playerid, P_MASK, 600 + 1);
	SetPlayerColorEx(playerid, 0x00000000);

	ApplyAnimationEx(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 0);
	SetPlayerChatBubble(playerid, "Надевает маску", 0xFF9900FF, 15.0, 5000);

	GameTextForPlayer(playerid, "~b~~h~invisible on", 2500, 4);
	SendClientMessage(playerid, 0x3399FFFF, "Ваше месторасположение на GPS скрыто на 10 минут");

	return 1;
}

CMD:dis(playerid)
{
    if(GetPlayerTeamEx(playerid) != TEAM_FBI) return SendClientMessage(playerid, 0x999999FF, "Доступно только ФСБ!");
    
	SetPlayerColorEx(playerid, 0x00000000);


	GameTextForPlayer(playerid, "~b~~h~invisible on", 2500, 4);
	SendClientMessage(playerid, 0x3399FFFF, "Вы успешно замаскировались!");

	return 1;
}

CMD:offdis(playerid)
{
    if(GetPlayerTeamEx(playerid) != TEAM_FBI) return SendClientMessage(playerid, 0x999999FF, "Доступно только ФСБ!");
    
    GameTextForPlayer(playerid, "~b~~h~invisible off", 2500, 4);
    
    SetPlayerColorEx(playerid, GetPlayerTeamColor(playerid));
    
    return 1;
}


/*CMD:gate(playerid, params[])
{
	if(!CheckNearestGate(playerid))
	{
		CallRemoteFunction("FS_PlayerUseButton", "i", playerid);
	}
	return 1;
}*/

CMD:home(playerid, params[])
{
	new accountid = GetPlayerAccountID(playerid);
	new property_count = 0;

	for(new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
	{
		if(gHouseOwned[i] && gHouseOwnerID[i] == accountid) property_count++;
	}
	for(new i = 0; i < 200000; i++)
	{
		if(gFlatOwned[i] && gFlatOwnerID[i] == accountid) property_count++;
	}

	if(property_count > 1)
	{
		return ShowPlayerPropertySelectDialog(playerid);
	}

	new houseid = GetHouseNewByOwner(accountid, playerid);
	if(houseid == -1){
		new flatid = GetFlatNewByOwner(accountid, playerid);
		if(flatid == -1){
			return SendClientMessage(playerid, 0x999999FF, "У Вас нет дома в новой системе");
		}
		SetPVarInt(playerid, "hnew_home_id", flatid);
	    return ShowPlayerFlatNewInfo(playerid, g_flat_real_id[flatid]);
	}
		

	SetPVarInt(playerid, "hnew_home_id", houseid);
	return ShowPlayerHouseNewInfo(playerid, houseid);
}
CMD:sellhome(playerid, params[])
{
    new houseid = GetNearestHouseForPlayerSell(playerid, 20.0);
    if(houseid != -1)
    {
        SetPVarInt(playerid, "hnew_home_id", houseid);
        SetPVarInt(playerid, "hnew_home_type", 0);

        Dialog(playerid, DIALOG_HOUSE_NEW_SELL, DIALOG_STYLE_MSGBOX,
        "{e84509}{SERVER_NAME} -> {ffffff}Продажа дома",
        "Вы уверены, что хотите продать дом государству?\n\n{e84509}|{ffffff} Вам будет возвращено {00ff00}70{ffffff} процентов от стоимости недвижимости.\n{e84509}|{ffffff} Вам будет возвращено {00ff00}60{ffffff} процентов от купленных ранее улучшений.\n\nЕсли Вы хотите продать дом другому игроку, используйте команду {0000ff}/sellmyhome",
        "Да", "Нет");
        return 1;
    }

    new flatid = GetNearestFlatForPlayerSell(playerid);
    if(flatid != -1)
    {
        SetPVarInt(playerid, "hnew_home_id", flatid);
        SetPVarInt(playerid, "hnew_home_type", 1);

        Dialog(playerid, DIALOG_FLAT_NEW_SELL, DIALOG_STYLE_MSGBOX,
        "{e84509}{SERVER_NAME} -> {ffffff}Продажа дома",
        "Вы уверены, что хотите продать дом государству?\n\n{e84509}|{ffffff} Вам будет возвращено {00ff00}70{ffffff} процентов от стоимости недвижимости.\n{e84509}|{ffffff} Вам будет возвращено {00ff00}60{ffffff} процентов от купленных ранее улучшений.\n\nЕсли Вы хотите продать дом другому игроку, используйте команду {0000ff}/sellmyhome",
        "Да", "Нет");
        return 1;
    }
	if (HasAnyHouseOrFlat(GetPlayerAccountID(playerid))){
		SendClientMessage(playerid, 0x999999FF, "Для продажи дома Вы должны находиться рядом с ним");
	}else{
		SendClientMessage(playerid, 0x999999FF, "У Вас нет недвижимости");
	}
}
CMD:sellmyhome(playerid, params[])
{
    if(!strlen(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Используйте: /sellmyhome [id игрока] [стоимость] (Комиссия 1 процент)");

    extract params -> new to_player, price;

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(price < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "Стоимость должна быть больше 0");

    new seller_account_id = GetPlayerAccountID(playerid);
    new buyer_account_id  = GetPlayerAccountID(to_player);

    if(seller_account_id <= 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Ошибка аккаунта продавца");
    if(buyer_account_id <= 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Покупатель не авторизован");

    if(HasAnyHouseOrFlat(buyer_account_id))
        return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока уже есть дом");

    new houseid = GetNearestHouseForPlayerSell(playerid, 20.0);
    new flatid = -1;
    new property_type = -1;
    new gov_price = 0;

    if(houseid != -1)
    {
        property_type = 0;
        gov_price = GetHouseGovPrice(houseid);

        if(!(IsPlayerInRangeOfPoint(playerid, 20.0, gHousesForSale[houseid][0], gHousesForSale[houseid][1], gHousesForSale[houseid][2]) &&
             IsPlayerInRangeOfPoint(to_player, 20.0, gHousesForSale[houseid][0], gHousesForSale[houseid][1], gHousesForSale[houseid][2])))
        {
            return SendClientMessage(playerid, 0x999999FF, "Вы и покупатель должны находиться около дома / квартиры которых хотите продать");
        }
    }
    else
    {
        flatid = GetNearestFlatForPlayerSell(playerid);
        if(flatid == -1)
            return SendClientMessage(playerid, 0x999999FF, "Вы и покупатель должны находиться около дома / квартиры которых хотите продать");

        new real_flatid = g_flat_real_id[flatid];
        new flat_houseid = real_flatid / 1000;

        if(GetPlayerVirtualWorld(playerid) != flat_houseid || GetPlayerVirtualWorld(to_player) != flat_houseid)
            return SendClientMessage(playerid, 0x999999FF, "Вы и покупатель должны находиться около дома / квартиры которых хотите продать");

        property_type = 1;
        gov_price = GetFlatGovPrice(flatid);
    }
	if (property_type == -1){
	    if (HasAnyHouseOrFlat(GetPlayerAccountID(playerid))){
	    	SendClientMessage(playerid, 0x999999FF, "Для продажи дома Вы должны находиться рядом с ним");
	    }else{
	    	SendClientMessage(playerid, 0x999999FF, "У Вас нет недвижимости");
	    }
		return 1;
	}
    new min_price = gov_price / 2;
    new max_price = gov_price * 3;

    if(price < min_price)
    {
        new fmt[144];
        format(fmt, sizeof fmt, "Минимальная стоимость продажи этого дома должна быть от %d руб.", min_price);
        return SendClientMessage(playerid, 0xCECECEFF, fmt);
    }

    if(price > max_price)
        return SendClientMessage(playerid, 0xCECECEFF, "Стоимость не должна быть дороже в 3 раза от стоимости дома");

    if(GetPlayerMoneyEx(to_player) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока нет такой суммы");

    SetPVarInt(to_player, "hnew_offer_from", playerid + 1);
    SetPVarInt(to_player, "hnew_offer_type", property_type);
    SetPVarInt(to_player, "hnew_offer_price", price);
    SetPVarInt(to_player, "hnew_offer_until", gettime() + 60);

    if(property_type == 0)
        SetPVarInt(to_player, "hnew_offer_id", houseid);
    else
        SetPVarInt(to_player, "hnew_offer_id", flatid);

    SetPVarInt(playerid, "hnew_offer_target", to_player + 1);

    new fmt_str[144];
    format(fmt_str, sizeof fmt_str, "Вы предложили игроку %s купить %s за %d руб. Ожидание 60 секунд",
        GetPlayerNameEx(to_player),
        property_type == 0 ? "дом" : "квартиру",
        price);
    SendClientMessage(playerid, 0x66CC33FF, fmt_str);

    format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить %s за %d руб. Введите /yesh для согласия",
        GetPlayerNameEx(playerid),
        property_type == 0 ? "дом" : "квартиру",
        price);
    SendClientMessage(to_player, 0x3399FFFF, fmt_str);
    SendClientMessage(to_player, 0xCECECEFF, "Для отказа используйте /no");
    return 1;
}

CMD:yesh(playerid, params[])
{
    new sellerid      = GetPVarInt(playerid, "hnew_offer_from") - 1;
    new property_type = GetPVarInt(playerid, "hnew_offer_type");
    new property_id   = GetPVarInt(playerid, "hnew_offer_id");
    new price         = GetPVarInt(playerid, "hnew_offer_price");
    new offer_until   = GetPVarInt(playerid, "hnew_offer_until");

    if(sellerid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, 0x999999FF, "В данный момент Вам никто не предлагает купить дом");

    if(!IsPlayerConnected(sellerid) || !IsPlayerLogged(sellerid) || sellerid == playerid)
        return SendClientMessage(playerid, 0x999999FF, "Продавец недоступен");

    if(price < 1)
        return SendClientMessage(playerid, 0x999999FF, "Некорректная стоимость");

    if(gettime() > offer_until)
    {
        DeletePVar(playerid, "hnew_offer_from");
        DeletePVar(playerid, "hnew_offer_type");
        DeletePVar(playerid, "hnew_offer_id");
        DeletePVar(playerid, "hnew_offer_price");
        DeletePVar(playerid, "hnew_offer_until");
        return SendClientMessage(playerid, 0x999999FF, "Срок предложения истек");
    }

    new seller_account_id = GetPlayerAccountID(sellerid);
    new buyer_account_id  = GetPlayerAccountID(playerid);

    if(seller_account_id <= 0 || buyer_account_id <= 0)
        return SendClientMessage(playerid, 0x999999FF, "Ошибка аккаунта. Перезайдите на сервер");

    if(HasAnyHouseOrFlat(buyer_account_id))
        return SendClientMessage(playerid, 0x999999FF, "У Вас уже есть дом");

    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег");

    new owner_name[MAX_PLAYER_NAME + 1];
    format(owner_name, sizeof owner_name, "%s", GetPlayerNameEx(playerid));

    new query[256];

    if(property_type == 0)
    {
        new houseid = property_id;

        if(houseid < 0 || houseid >= HOUSES_FOR_SALE_COUNT)
            return SendClientMessage(playerid, 0x999999FF, "Дом не найден");

        if(!gHouseOwned[houseid] || gHouseOwnerID[houseid] != seller_account_id)
            return SendClientMessage(playerid, 0x999999FF, "Игрок больше не владеет этим домом");

        if(!(IsPlayerInRangeOfPoint(playerid, 20.0, gHousesForSale[houseid][0], gHousesForSale[houseid][1], gHousesForSale[houseid][2]) &&
             IsPlayerInRangeOfPoint(sellerid, 20.0, gHousesForSale[houseid][0], gHousesForSale[houseid][1], gHousesForSale[houseid][2])))
        {
            return SendClientMessage(playerid, 0x999999FF, "Вы и покупатель должны находиться около дома / квартиры которых хотите продать");
        }

        // Если у тебя bought_houses хранит дома именно по houseid — это верно
        format(query, sizeof query,
            "UPDATE bought_houses SET account_id = %d WHERE house_id = %d AND account_id = %d LIMIT 1",
            buyer_account_id, houseid, seller_account_id);
        mysql_tquery(mysql, query);

        GivePlayerMoneyEx(playerid, -price, "Покупка дома у игрока", true, true);
        GivePlayerMoneyEx(sellerid, price, "Продажа дома игроку", true, true);

        gHouseOwnerID[houseid] = buyer_account_id;
        format(gHouseOwner[houseid], 24, "%s", owner_name);

        SetPlayerData(sellerid, P_HOUSE_SELECTED, 0);
        SetPlayerData(playerid, P_HOUSE_SELECTED, 0);
		UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));
        DeletePVar(playerid, "hnew_offer_from");
        DeletePVar(playerid, "hnew_offer_type");
        DeletePVar(playerid, "hnew_offer_id");
        DeletePVar(playerid, "hnew_offer_price");
        DeletePVar(playerid, "hnew_offer_until");
        DeletePVar(sellerid, "hnew_offer_target");

        new fmt_str[160];
        format(fmt_str, sizeof fmt_str, "Вы купили дом у %s за %d руб", GetPlayerNameEx(sellerid), price);
        SendClientMessage(playerid, 0x66CC33FF, fmt_str);

        format(fmt_str, sizeof fmt_str, "%s купил Ваш дом за %d руб", GetPlayerNameEx(playerid), price);
        SendClientMessage(sellerid, 0x66CC33FF, fmt_str);
        return 1;
    }

    else if(property_type == 1)
    {
        new flatid = property_id;

        if(flatid < 0 || flatid >= 200000)
            return SendClientMessage(playerid, 0x999999FF, "Квартира не найдена");

        if(!gFlatOwned[flatid] || gFlatOwnerID[flatid] != seller_account_id)
            return SendClientMessage(playerid, 0x999999FF, "Игрок больше не владеет этой квартирой");

        new houseid = flatid / 100;

        if(GetPlayerVirtualWorld(playerid) != houseid || GetPlayerVirtualWorld(sellerid) != houseid)
            return SendClientMessage(playerid, 0x999999FF, "Вы и покупатель должны находиться около дома / квартиры которых хотите продать");

        format(query, sizeof query,
            "UPDATE bought_houses SET account_id = %d WHERE house_id = %d AND account_id = %d LIMIT 1",
            buyer_account_id, flatid, seller_account_id);
        mysql_tquery(mysql, query);

        GivePlayerMoneyEx(playerid, -price, "Покупка квартиры у игрока", true, true);
        GivePlayerMoneyEx(sellerid, price, "Продажа квартиры игроку", true, true);

        gFlatOwnerID[flatid] = buyer_account_id;
        format(gFlatOwner[flatid], 24, "%s", owner_name);

        SetPlayerData(sellerid, P_HOUSE_SELECTED, 0);
        SetPlayerData(playerid, P_HOUSE_SELECTED, 0);
		UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));
        DeletePVar(playerid, "hnew_offer_from");
        DeletePVar(playerid, "hnew_offer_type");
        DeletePVar(playerid, "hnew_offer_id");
        DeletePVar(playerid, "hnew_offer_price");
        DeletePVar(playerid, "hnew_offer_until");
        DeletePVar(sellerid, "hnew_offer_target");

        new fmt_str[160];
        format(fmt_str, sizeof fmt_str, "Вы купили квартиру у %s за %d руб", GetPlayerNameEx(sellerid), price);
        SendClientMessage(playerid, 0x66CC33FF, fmt_str);

        format(fmt_str, sizeof fmt_str, "%s купил Вашу квартиру за %d руб", GetPlayerNameEx(playerid), price);
        SendClientMessage(sellerid, 0x66CC33FF, fmt_str);
        return 1;
    }

    return SendClientMessage(playerid, 0x999999FF, "Неизвестный тип недвижимости");
}
stock ClearHouseSellOffer(playerid)
{
    DeletePVar(playerid, "hnew_offer_from");
    DeletePVar(playerid, "hnew_offer_type");
    DeletePVar(playerid, "hnew_offer_id");
    DeletePVar(playerid, "hnew_offer_price");
    DeletePVar(playerid, "hnew_offer_until");
    return 1;
}
CMD:live(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new type = GetHouseData(houseid, H_TYPE);
		new rooms = GetHouseTypeInfo(type, HT_ROOMS);

		if(GetHouseRentersCount(houseid) >= rooms)
			return SendClientMessage(playerid, 0x999999FF, "Все комнаты Вашего дома уже заняты");

		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /live [id игрока]"); // [кол-во дней] [цена (необязательно)]

		extract params -> new to_player, days, price;

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
			return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

		if(GetPlayerHouse(to_player) != -1)
			return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока уже есть дом");

		/*
		if(!(300 <= price <= 10_000))
			return SendClientMessage(playerid, 0xCECECEFF, "Цена аренды должна быть от 300 до 10000 руб");

		else if(!(1 <= days <= 30))
			return SendClientMessage(playerid, 0xCECECEFF, "Кол-во дней аренды должно быть от 0 до 30");

		if(GetPlayerMoneyEx(to_player) < price)
			return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока нет такой суммы");
		*/

		if(!(IsPlayerInRangeOfHouse(playerid, houseid, 10.0) && IsPlayerInRangeOfHouse(to_player, houseid, 10.0)))
			return SendClientMessage(playerid, 0xCECECEFF, "Вы и арендатор должны находиться около дома который хотите сдать в аренду");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_HOME_RENT_ROOM, houseid);
	}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет дома");

	return 1;
}

CMD:liveout(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_ROOM);
	if(houseid != -1)
	{
		Dialog
		(
			playerid, DIALOG_HOUSE_EVICT, DIALOG_STYLE_MSGBOX,
			"{FF9900}Выселение из дома",
			"{FFFFFF}Вы действительно хотите выселиться из дома?",
			"Да", "Нет"
		);
	}
					else SendClientMessage(playerid, 0x999999FF, "Вы нигде не проживаете");

	return 1;
}

CMD:makestore(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		if(GetHouseData(houseid, H_IMPROVEMENTS) >= 5)
		{
			if(GetPlayerInHouse(playerid) == houseid)
			{
				new type = GetHouseData(houseid, H_TYPE);
				if(IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_MOVE_STORE, DIALOG_STYLE_MSGBOX,
						"{FFCD00}Шкаф",
						"{FFFFFF}Вы хотите разместить шкаф в этом месте?",
						"Да", "Нет"
					);
				}
					else SendClientMessage(playerid, 0x999999FF, "Вы должны находиться у себя в доме");
			}
					else SendClientMessage(playerid, 0x999999FF, "Вы должны находиться у себя в доме");
		}
					else SendClientMessage(playerid, 0x999999FF, "Необходим 5 уровень улучшений для дома");
	}
					else SendClientMessage(playerid, 0x999999FF, "Функция доступна владельцам недвижимости");

	return 1;
}

CMD:use(playerid, params[])
{
	new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);

	if(house_id == -1) return SendClientMessage(playerid, 0x999999FF, "Функция доступна владельцам недвижимости");

	if(GetPlayerInHouse(playerid) != house_id) return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в своём доме");

	if(GetHouseData(house_id, H_IMPROVEMENTS) < 5) return SendClientMessage(playerid, 0x999999FF, "Необходим 5 уровень улучшений для дома");

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, GetHouseData(house_id, H_STORE_X), GetHouseData(house_id, H_STORE_Y), GetHouseData(house_id, H_STORE_Z)))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у своего шкафа");

	Dialog
	(
		playerid, DIALOG_HOUSE_STORE, DIALOG_STYLE_LIST,
		"{FFCC00}Шкаф",
		"1. Положить Материалы\n\
		2. Положить наркотики\n\
		3. Положить оружие\n\
		4. Положить одежду\n\
		{99FF99}5. Взять Материалы\n\
		{99FF99}6. Взять наркотики\n\
		{99FF99}7. Взять оружие\n\
		{99FF99}8. Взять одежду",
		"Далее", "Закрыть"
	);

	return 1;
}

CMD:homelock(playerid, params[])
{
	new hotel_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL);
	new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

	if(hotel_id != -1)
	{
		if(GetHotelData(hotel_id, room_id, H_STATUS))
		{
			SetHotelData(hotel_id, room_id, H_STATUS, false);

			GameTextForPlayer(playerid, "~g~~h~OЏKP‘ЏO", 2000, 4);
			SendClientMessage(playerid, 0x66CC00FF, "Номер открыт");
		}
					else
		{
			SetHotelData(hotel_id, room_id, H_STATUS, true);

			GameTextForPlayer(playerid, "~r~~h~€AKP‘ЏO", 2000, 4);
			SendClientMessage(playerid, 0xFF6600FF, "Номер закрыт");
		}

		new query[64];
		format(query, sizeof query, "UPDATE hotels SET status=%d WHERE id=%d LIMIT 1", GetHotelData(hotel_id, room_id, H_STATUS), GetHotelData(hotel_id, room_id, H_SQL_ID));
		mysql_query(mysql, query, false);
	}
					else SendClientMessage(playerid, 0x999999FF, "Вы не снимаете номер в гостинице");

	return 1;
}

