//>> Файл: bykranin_src/core/property/property_08.inc  (357 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: /rentcar, /unrent, /unfcar, /business, ShowPlayerBusinessInfo, /buybiz, /sellbiz
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:rentcar(playerid, params[])
{
	new current_rent_index = GetRentCarDataIndex(GetPlayerRentCar(playerid));
	if(current_rent_index != -1 && playerid == rent_cars_data[current_rent_index][rent_car_tenant_id])
		return SendClientMessage(playerid, 0xFF6600FF, "Используйте /unrent чтобы разорвать текущий договор аренды");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_RENT_CAR)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны быть в машине, которую можно арендовать");

	new rent_index = GetRentCarDataIndex(vehicleid);
	if(rent_index == -1) return SendClientMessage(playerid, 0x999999FF, "Invalid rent vehicle");

	SetPlayerData(playerid, P_RENT_CAR, vehicleid);
	rent_cars_data[rent_index][rent_car_tenant_id] = playerid;

	Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, " ", " ", " ", " ");

	SendClientMessage(playerid, 0x66CC00FF, "Вы взяли транспорт в аренду");
	SendClientMessage(playerid, -1, "Используйте {00CC66}/lock 2 {FFFFFF}для открытия и закрытия дверей");
	SendClientMessage(playerid, -1, "Чтобы разорвать договор аренды введите {00CC66}/unrent");
	SendClientMessage(playerid, 0x999999FF, "Если Вы попадете в больницу или разобьете транспорт");
	SendClientMessage(playerid, 0x999999FF, "То договор будет расторгнут. Если Вы не закроете транспорт");
	SendClientMessage(playerid, 0x999999FF, "То его может арендовать другой игрок и Вы потеряете его");

	TogglePlayerControllable(playerid, true);

	return 1;
}

CMD:unrent(playerid, params[])
{
	new vehicleid = GetPlayerRentCar(playerid);
	new rent_index = GetRentCarDataIndex(vehicleid);
	if(rent_index == -1 || playerid != rent_cars_data[rent_index][rent_car_tenant_id])
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет договора аренды транспорта");

	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		RemovePlayerFromVehicle(playerid);

	SetPlayerData(playerid, P_RENT_CAR, INVALID_VEHICLE_ID);
	rent_cars_data[rent_index][rent_car_tenant_id] = INVALID_PLAYER_ID;

	SendClientMessage(playerid, 0xFFFF00FF, "Договор аренды транспорта расторгнут");
	return 1;
}

CMD:unfcar(playerid)
{
    new vehicleid = GetPlayerData(playerid, P_FRACTION_CAR);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, -1, ""USC"У вас нет фракционного транспорта");
    }

    SetPlayerData(playerid, P_FRACTION_CAR, INVALID_VEHICLE_ID);

    if(IsValidVehicle(vehicleid) && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_ORG_CAR)
    {
        DestroyVehicle(vehicleid);
        return SendClientMessage(playerid, -1, ""SC"Вы удалили транспорт!");
    }

    return SendClientMessage(playerid, -1, ""USC"Фракционный транспорт уже не найден, состояние сброшено");
}


CMD:business(playerid, params[])
{
    new business_count = GetPlayerBusinessCount(playerid);

    if(!business_count)
    {
        return SendClientMessage(playerid, 0x999999FF,
        "У Вас нет бизнеса");
    }

    if(business_count > 1)
    {
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

        return Dialog(
            playerid,
            DIALOG_BIZ_SELECT,
            DIALOG_STYLE_TABLIST_HEADERS,
            "{33AACC}Выбор бизнеса",
            string,
            "Выбрать",
            "Закрыть"
        );
    }

    for(new i = 0; i < MAX_BUSINESS; i++)
    {
        if(GetBusinessData(i, B_OWNER_ID) == GetPlayerAccountID(playerid))
        {
            SetSelectedBusiness(playerid, i);
            ShowPlayerBusinessInfo(playerid, i);
            break;
        }
    }

    return 1;
}
stock ShowPlayerBusinessInfo(playerid, businessid)
{
    static const music_name[6][9] =
    {
        "Отключен",
        "Звук 1",
        "Звук 2",
        "Звук 3",
        "Звук 4",
        "Звук 5"
    };

    new fmt_str[1024];
    new city[MAX_ZONES_NAME + 1];

    GetCityName(
        GetBusinessData(businessid, B_POS_X),
        GetBusinessData(businessid, B_POS_Y),
        city
    );

    format
    (
        fmt_str, sizeof fmt_str,
        "{555555}| {FFFFFF}Название:\t{339999}%s (%d)\n"\
        "{555555}| {FFFFFF}Номер бизнеса:\t%d\n"\
        "{555555}| {FFFFFF}Владелец:\t{CC3333}%s\n"\
        "{555555}| {FFFFFF}Город / область:\t%s\n"\
        "{555555}| {FFFFFF}Количество продуктов:\t{66CC33}%d {ffffff}из {CC3333}%d\n"\
        "{555555}| {FFFFFF}Стоимость 1 продукта:\t%d руб\n"\
        "{555555}| {FFFFFF}Уровень улучшений:\t%d\n"\
        "{555555}| {FFFFFF}Баланс предприятия:\t%d руб\n"\
        "{555555}| {FFFFFF}Бизнес арендован на:\t{66CC33}%d {ffffff}из {CC3333}30 {ffffff}дней\n"\
        "{555555}| {FFFFFF}Звук при входе:\t{%s}%s\n"\
        "{555555}| {FFFFFF}Гос. стоимость:\t{CC3333}%d {ffffff}руб\n"\
        "{555555}| {FFFFFF}Аренда помещения:\t%d руб в день\n"\
        "{555555}| {FFFFFF}Тип аренды:\t%s\n"\
        "{555555}| {FFFFFF}Процент прибыли:\t100%%",

        GetBusinessData(businessid, B_NAME),
        businessid,
        businessid,
        GetBusinessData(businessid, B_OWNER_NAME),
        city,
        GetBusinessData(businessid, B_PRODS),
        GetBusinessMaxProd(businessid),
        GetBusinessData(businessid, B_PROD_PRICE),
        GetBusinessData(businessid, B_IMPROVEMENTS),
        GetBusinessData(businessid, B_BALANCE),

        GetBusinessData(businessid, B_RENT_DATE) <= gettime()
        ? 0
        : GetElapsedTime(
            GetBusinessData(businessid, B_RENT_DATE),
            gettime(),
            CONVERT_TIME_TO_DAYS
        ),

        !GetBusinessData(businessid, B_ENTER_MUSIC)
        ? ("FF3333")
        : ("33CC00"),

        music_name[GetBusinessData(businessid, B_ENTER_MUSIC)],

        GetBusinessData(businessid, B_PRICE),
        5000,

        GetBusinessData(businessid, B_IMPROVEMENTS) < 3
        ? ("Полная")
        : ("Льготная")
    );

    Dialog(
        playerid,
        DIALOG_BIZ_INFO,
        DIALOG_STYLE_TABLIST,
        "{E0584B}{SERVER_NAME} {FFFFFF}| Информация о бизнесе",
        fmt_str,
        "Изменить",
        "Отмена"
    );

    return 1;
}

CMD:buybiz(playerid, params[])
{
	#pragma unused params
	return SendClientMessage(playerid, 0xCECECEFF,
		"Покупка свободных бизнесов доступна только через /auction.");
	#if 0 // Direct state purchase is intentionally disabled.
	new business_count = GetPlayerBusinessCount(playerid);
new max_business = 1 + GetPlayerData(playerid, P_BUSS_SLOTS);
if(max_business > 2)
{
    max_business = 2;
}

if(business_count >= max_business)
{
    if(GetPlayerData(playerid, P_BUSS_SLOTS) < 1)
    {
        return SendClientMessage(playerid, 0xCECECEFF,
        "У Вас уже есть бизнес. Купите дополнительный слот чтобы иметь 2 бизнеса");
    }

    return SendClientMessage(playerid, 0xCECECEFF,
    "Вы уже достигли максимального количества бизнесов (2)");
}

	new businessid = GetNearestBusiness(playerid, 4.0);
	if(businessid != -1)
	{
		if(IsBusinessOnAuction(businessid))
			return SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес продаётся через аукцион и недоступен для /buybiz.");

		if(IsBusinessNoBuy(businessid))
			return SendClientMessage(playerid, 0xCECECEFF, "Данный тип бизнеса в разработке, его еще нельзя купить!");

		SetPVarInt(playerid, "buy_biz_id", businessid);

		new fmt_str[256];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Название:\t\t\t{339999}%s\n"\
			"{FFFFFF}Стоимость:\t\t\t{6699FF}%d руб\n"\
			"{FFFFFF}Плата за аренду:\t\t{6699FF}%d руб в день\n\n"\
			"{669966}Вы уверены что хотите купить этот бизнес?",
			GetBusinessData(businessid, B_NAME),
			GetBusinessData(businessid, B_PRICE),
			5000
		);
		Dialog(playerid, DIALOG_BIZ_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}Покупка нового бизнеса", fmt_str, "Да", "Нет");
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны быть рядом с бизнесом, который хотите купить");

	return 1;
	#endif
}

CMD:sellbiz(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(IsBusinessOnAuction(businessid))
			return SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес находится на аукционе.");
		Dialog
		(
			playerid, DIALOG_BIZ_SELL, DIALOG_STYLE_MSGBOX,
			"{00FFFF}"SERVER_NAME" -> {ffffff}  Продажа бизнеса",
			"{FFFFFF}Вы уверены что хотите продать свой бизнес государству?\n\n"\
			"{ffffff}Вам будет возвращено {32CD32} 70 {ffffff}процентов от стоимости Вашего бизнеса.\n"\
			"{ffffff}Вам будет возвращено {32CD32} 60 {ffffff}процентов от купленных ранее улучшений.\n\n"\
			"{ffffff}Если Вы хотите продать бизнес другому игроку,\n"\
			"{ffffff}используйте команду {1E90FF} /sellmybiz",
			"Да", "Отмена"
		);
	}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет бизнеса");

	return 1;
}

CMD:sellmybiz(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(IsBusinessOnAuction(businessid))
			return SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес находится на аукционе.");
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellmybiz [id игрока] [стоимость]");

		extract params -> new to_player, price;

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
			return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

		if(price < 1)
			return SendClientMessage(playerid, 0xCECECEFF, "Укажите стоимость продажи");

		new Float: b_pos_x = GetBusinessData(businessid, B_POS_X);
		new Float: b_pos_y = GetBusinessData(businessid, B_POS_Y);
		new Float: b_pos_z = GetBusinessData(businessid, B_POS_Z);

		if(GetPlayerMoneyEx(to_player) < price)
			return SendClientMessage(playerid, 0xCECECEFF, "У покупателя нет такого количества средств");

		if(!(IsPlayerInRangeOfPoint(playerid, 7.0, b_pos_x, b_pos_y, b_pos_z) && IsPlayerInRangeOfPoint(to_player, 7.0, b_pos_x, b_pos_y, b_pos_z)))
			SendClientMessage(playerid, 0xCECECEFF, "Вы и покупатель должны находиться рядом с бизнесом который хотите продать");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_BUSINESS, businessid, price);
	}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет бизнеса");

	return 1;
}

CMD:bizmusic(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_IMPROVEMENTS) >= 4)
		{
			new fmt_str[13 + 1];
			new string[(sizeof fmt_str - 1) * (sizeof g_business_sound) + 1];

			string = "1. Отключен\n";
			for(new idx = 1; idx <= sizeof g_business_sound; idx ++)
			{
				format(fmt_str, sizeof fmt_str, "%d. Звук №%d\n", idx + 1, idx);
				strcat(string, fmt_str);
			}
			Dialog(playerid, DIALOG_BIZ_ENTER_MUSIC, DIALOG_STYLE_LIST, "{FFCD00}Звук при входе в бизнес", string, "Выбрать", "Закрыть");
		}
					else SendClientMessage(playerid, 0xCECECEFF, "Для использование этой функции необходим 4 уровень улучшения бизнеса");
	}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас нет бизнеса");

	return 1;
}

CMD:manager(playerid, params[])
{
    #pragma unused params
    new casino_business = GetPlayerManagedCasino(playerid);
    if(casino_business != -1) return ShowCasinoManagerDialog(playerid);

    new businessid = GetPlayerBusiness(playerid);
    if(businessid == -1) return SendClientMessage(playerid, 0xCECECEFF, "Вы не являетесь менеджером или владельцем казино");
    return SendClientMessage(playerid, 0xCECECEFF, "Для управления сотрудниками обычного бизнеса используйте меню /business");
}

