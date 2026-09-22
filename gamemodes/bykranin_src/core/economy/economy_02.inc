//>> Файл: bykranin_src/core/economy/economy_02.inc  (910 строк)
//>> Тема: экономика: банк, донат, промокоды, аукцион, обмен, торговля
//>> Внутри: GivePlayerMoneyEx, GivePlayerDonate, GivePlayerDonateRub, BankLog, SendMessageInLocal, Action, SetPlayerGPSPoint
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GivePlayerMoneyEx(playerid, money, description[]="None", bool:save=true, bool:game_text=true)
{
	if(money < 0 && GetPlayerMoneyEx(playerid) < money) return -1;

	new fmt_str[185];
	AddPlayerData(playerid, P_MONEY, +, money);
	GivePlayerMoney(playerid, money);
	format(fmt_str, sizeof fmt_str, "INSERT INTO money_log (uid,uip,time,money,description) VALUES (%d,'%s',%d,%d,'%s')", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), money, description);
	mysql_query(mysql, fmt_str, false);


	if(save)
	{
		format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid), GetPlayerAccountID(playerid));
		mysql_query(mysql, fmt_str, false);
	}
	if(game_text)
	{
		format(fmt_str, sizeof fmt_str, "%s%d rub", money < 0 ? ("~r~") : ("~g~+"), money);
		GameTextForPlayer(playerid, fmt_str, 4000, 1);
	}

	if(money > 0)
	{
		BlackPass_OnMoneyEarned(playerid, money, description);
	}

	return 1;
}

stock GivePlayerDonate(playerid, donate, description[]="None", bool:save=true)
{
	new fmt_str[185];
	AddPlayerData(playerid, P_DONATE_MONEY, +, donate);
	if(donate > 0) AddPlayerData(playerid, P_DONATE_TOTAL, +, donate);

	format(fmt_str, sizeof fmt_str, "INSERT INTO donate_log (uid,uip,time,donate,description) VALUES (%d,'%s',%d,%d,'%s')", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), donate, description);
	mysql_query(mysql, fmt_str, false);

	if(save)
	{
		UpdatePlayerDatabaseInt(playerid, "donate_current", GetPlayerCurrentDonate(playerid));
		UpdatePlayerDatabaseInt(playerid, "donate_total", GetPlayerTotalDonate(playerid));
	}
	return 1;
}


stock GivePlayerDonateRub(playerid, donate, description[]="None", bool:save=true, bool:game_text=true)
{
	new fmt_str[185];
	
	AddPlayerData(playerid, P_DONATE_RUB, +, donate);

	format(fmt_str, sizeof fmt_str, "INSERT INTO donate_log (uid,uip,time,donate,description) VALUES (%d,'%s',%d,%d,'%s')", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), donate, description);
	mysql_query(mysql, fmt_str, false);

	if(save)
	{
		UpdatePlayerDatabaseInt(playerid, "rub", GetPlayerDonateRub(playerid));
	}
	if(game_text)
	{
		format(fmt_str, sizeof fmt_str, "~w~%s%d rub", donate < 0 ? ("") : ("+"), donate);
		GameTextForPlayer(playerid, fmt_str, 4000, 1);
	}
	return 1;
}

stock BankLog(playerid, money, description[] = "None")
{
	new fmt_str[185];

	format(fmt_str, sizeof fmt_str, "[BANK] %s", description);

	format(fmt_str, sizeof fmt_str, "INSERT INTO money_log (uid,uip,time,money,description) VALUES (%d,'%s',%d,%d,'%s')", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), money, fmt_str);
	mysql_query(mysql, fmt_str, false);

	return 1;
}

stock SendMessageInLocal(playerid, const message[], color, Float: radius = 30.0)
{
	new virtual_world = GetPlayerVirtualWorld(playerid);
	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);

	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		if(GetPlayerVirtualWorld(idx) != virtual_world) continue;
		if(!IsPlayerInRangeOfPoint(idx, radius, x, y, z)) continue;

		SendClientMessage(idx, color, message);
	}
	return 1;
}

stock Action(playerid, message[], Float:radius=25.0, bool:bubble=true)
{
	if(bubble)
		SetPlayerChatBubble(playerid, message, 0xDD90FFFF, radius, 7000);

	new fmt_str[128];

	format(fmt_str, sizeof fmt_str, "%s %s", GetPlayerNameEx(playerid), message);
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, radius);

	return 1;
}

stock SetPlayerGPSPoint(playerid, Float:x, Float:y, Float:z, color = 0xFF5252FF)
{
    // Verified in lram.apk: libkranin maps RPC 168 to the native handler.
    // Subcommand 26 reads UINT32 enabled (NOT a color), then XYZ when enabled.
    // Keep the existing color argument for compatibility with callers.
    new BitStream:bs = BS_New();
    new enabled = (color != 0);
    BS_WriteValue(bs, PR_UINT8, 26, PR_UINT32, enabled);
    if(enabled)
        BS_WriteValue(bs, PR_FLOAT, x, PR_FLOAT, y, PR_FLOAT, z);
    PR_SendRPC(bs, playerid, 168, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}
stock EnablePlayerGPS(playerid, markertype, Float: x, Float: y, Float: z, const message[] = "Метка отмечена на мини карте")
{
	if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_ON)
	{
		SendDestroyWayPoint(playerid, 0);
	}

	SetPlayerGPSInfo(playerid, G_POS_X, x);
	SetPlayerGPSInfo(playerid, G_POS_Y, y);
	SetPlayerGPSInfo(playerid, G_POS_Z, z);

	SetPlayerMapIcon(playerid, 98, x, y, z, markertype, 0xFF5252FF, MAPICON_GLOBAL);
	// Navigation must not replace a checkpoint belonging to an active job.
	if(!GetPlayerCPInfo(playerid, CP_ENABLED) || GetPlayerCPInfo(playerid, CP_ACTION_TYPE) == CP_ACTION_TYPE_GPS)
		SetPlayerCheckpoint(playerid, x, y, z, 3.0, CP_ACTION_TYPE_GPS);
    SetPlayerGPSPoint(playerid, x, y, z, 0xFF5252FF);
	SendCreateWayPoint(playerid, 0, x, y, z, 85, 27, 30000.0, GetPlayerInterior(playerid));
	// The target RPC above updates GUI navigation directly. No legacy packet 251.

	if(strlen(message))
		SendClientMessage(playerid, 0xFFFF00FF, message);

	SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_ON);

	return 1;
}

stock DisablePlayerGPS(playerid)
{
	if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_ON)
	{
		SendDestroyWayPoint(playerid, 0);
        SetPlayerGPSPoint(playerid, 0.0, 0.0, 0.0, 0x00000000);
		RemovePlayerMapIcon(playerid, 98);
		if(GetPlayerCPInfo(playerid, CP_ACTION_TYPE) == CP_ACTION_TYPE_GPS)
			DisablePlayerCheckpoint(playerid);
		// Reset of GUI navigation is sent by SetPlayerGPSPoint above.
		SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_OFF);
	}
	return 1;
}

stock IsPlayerInRangeOfPlayer(playerid, to_player, Float: distance)
{
	new Float: x, Float: y, Float: z;
	GetPlayerPos(to_player, x, y, z);

	return IsPlayerInRangeOfPoint(playerid, distance, x, y, z);
}

stock GetPlayerMaxStorage(playerid, storage)
{
	new amount;

	switch(storage)
	{
		case STORAGE_METALL: amount = 20;
		case STORAGE_AMMO: amount = 250;
		case STORAGE_DRUGS: amount = 500;
	}

	return GetPlayerData(playerid, P_IMPROVEMENTS) >= 3 ? amount * 2 : amount;
}

stock GetPlayerOwnableCars(playerid)
{
	new count,
		query[70],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	count = cache_num_rows(result);

	cache_delete(result);

	return count;
}

stock IsPlayerHasDonations(playerid)
{
	new query[256 + 1];
	new Cache: result;
	new rows;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM `unitpay_payments` WHERE account = '%s' AND status = 1", GetPlayerNameEx(playerid));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	cache_delete(result);

	if(rows) return 1;

	return 0;
}

stock GetPlayerLastDonation(playerid)
{
	new query[100],
		Cache: result,
		count;

	mysql_format(mysql, query, sizeof query, "SELECT sum FROM `unitpay_payments` WHERE account = '%s' ORDER BY id DESC LIMIT 1", GetPlayerNameEx(playerid));
	result = mysql_query(mysql, query, true);

	if(cache_num_rows(result))
		count = cache_get_row_int(0, 0);

	cache_delete(result);

	return count;
}

stock GetPlayerDonationCurrency(playerid)
{
	new query[100],
		Cache: result,
		currency[64];

	mysql_format(mysql, query, sizeof query, "SELECT currency FROM `unitpay_payments` WHERE account = '%s' AND activated = 1 ORDER BY id DESC LIMIT 1", GetPlayerNameEx(playerid));
	result = mysql_query(mysql, query, true);

	if(cache_num_rows(result))
		cache_get_row(0, 0, currency);

	cache_delete(result);

	return currency;
}

stock ShowPlayerDonateDialog(playerid)
{
	new fmt_text[610];

	format
	(
	    fmt_text,
	    sizeof fmt_text,
	    "{FFFFFF}\
	    В этом разделе вы можете использовать дополнительные\n\
	    возможности сервера. Чтобы получить к ним доступ,\n\
	    необходимо пополнить свой игровой счёт. Описание всех\n\
	    дополнительных возможностей, а также о способах\n\
		пополнения счёта вы можете узнать на нашем сайте:\n\
		{33cc66}"#SERVER_SITE" (раздел \"Донат\")\n\n\
		{6699cc}Информация:{FFFFFF}\n\
		Номер аккаунта:\t\t\t%d\n\
		Текущее состояние счёта:\t\t%d.00 руб.\n\
		Последнее пополнение:\t\t%d.00 руб.\n\
		Общая сумма пополнений:\t\t%d.00 руб.\
		",
		GetPlayerAccountID(playerid),
		GetPlayerDonateMoney(playerid),
		GetPlayerLastDonation(playerid),
		GetPlayerTotalDonate(playerid)
	);

	Dialog
	(
	    playerid, DIALOG_DONATE_INFO, DIALOG_STYLE_MSGBOX,
	    "{FFCC00}Дополнительные возможности",
	    fmt_text,
	    "Просмотр", "Назад"
	);
	return 1;
}

stock ShowPlayerDonateMenu(playerid)
{
	return 1;
}


stock ShowPlayerAdminDonate(playerid)
{
	if(ISBONUS == 0) return 0;
	new fmt_text[800], fmt_description[32];

	format
	(
		fmt_text,
		sizeof fmt_text,
		"1. Повысить свой уровень админ-прав\t\t\t{6699cc} >>\n"\
		"2. Покупка платных команд\t\t{6699cc} >>\n"\
		"3. Снять выговор\t\t{6699cc} {6699cc}%d руб.\n"\
		"4. Изменить свой админ-пароль\t{6699cc}%d руб.\n"\
		"5. Функция 'Скрытность'\t\t{6699cc}%d руб.\n"\
		"6. Префикс в админ чате\t\t{6699cc}%d руб.\n"\
		"7. Префикс для персонажа\t\t{6699cc}%d руб.\n"\
		"{FFFF00}Пополнить свой счёт можно на \t\t{6699cc}"SERVER_SITE"\n",
		GetDonatePrice(DONATE_PRICE_A_UNWARN),
		GetDonatePrice(DONATE_PRICE_A_SETPASS),
		GetDonatePrice(DONATE_PRICE_A_INVISIBLE),
		GetDonatePrice(DONATE_PRICE_A_PREFIX),
		GetDonatePrice(DONATE_PRICE_A3D_PREFIX)

	);

	format(fmt_description, 32, "{6699cc}Ваш баланс: %d рублей", GetPlayerDonateRub(playerid));

	Dialog
	(
		playerid, DIALOG_ADONATE_MENU, DIALOG_STYLE_LIST,
		fmt_description,
		fmt_text,
		"Выбрать", "Закрыть"
	);

	return 1;
}

stock ShowPlayerDrubMenu(playerid)
{
	if(ISBONUS == 1)
	{
		new price = Config[helper_price];
		new fmt_text[800], fmt_description[32];

		format
		(
			fmt_text,
			sizeof fmt_text,
			"{99cc00}Просмотреть последние пополнения\n"\
			"1. Конвертировать рубли в игровые деньги\n"\
			"2. Покупка всех лицензий\t\t\t{6699cc}150 руб\n"\
			"3. Изменить номер транспортного средства\t\t{6699cc}от 100 руб\n"\
			"4. Увеличить количество слотов для транспорта\t{6699cc}100 руб/слот\n"\
			"5. Покупка SIM-карты с 4-х значным номером\t\t{6699cc}70 руб\n"\
			"6. Снять все предупреждения\t\t{6699cc}150 руб\n"\
			"7. Прокачать силу или навыки владения оружием\t{6699cc}%d руб/1 ед.\n"\
			"8. Покупка VIP привелегий\n"\
			"9. Бумбокс\t\t{6699cc}100 руб\n"\
			"10. Покупка прав лидера\t\t{6699cc} >>\n"\
			"11. Покупка прав администратора\t\t{6699cc} >>\n"\
			"12. Покупка заместителя в орзанизации\t\t{6699cc} >>",
			GetDonatePrice(DONATE_PRICE_SKILLS)

		);

		format(fmt_description, 32, "{00FFFF}"SERVER_NAME"{ffffff} | (%d рублей)", GetPlayerDonateRub(playerid));

		Dialog
		(
			playerid, DIALOG_DRUB_MENU, DIALOG_STYLE_LIST,
			fmt_description,
			fmt_text,
			"Выбрать", "Закрыть"
		);
	}
					else
	{
	    new price = Config[helper_price];
		new fmt_text[800], fmt_description[32];

		format
		(
			fmt_text,
			sizeof fmt_text,
			"{FFFF00}01. {ffffff}Просмотреть последние пополнения\n"\
			"{FFFF00}02. {ffffff}Конвертировать рубли в игровые деньги\n"\
			"{FFFF00}03. {ffffff}Покупка всех лицензий\t\t\t{99cc00}150 рублей\n"\
			"{FFFF00}04. {ffffff}Изменить номер транспортного средства\t\t{99cc00}от 100 рублей\n"\
			"{FFFF00}05. {ffffff}Увеличить количество слотов для транспорта\t{99cc00}100 рублей/слот\n"\
			"{FFFF00}06. {ffffff}Покупка SIM-карты с 4-х значным номером\t\t{99cc00}70 рублей\n"\
			"{FFFF00}07. {ffffff}Снять все предупреждения\t\t{99cc00}150 рублей\n"\
			"{FFFF00}08. {ffffff}Прокачать силу или навыки владения оружием\t{99cc00}%d рублей/1 ед\n"\
			"{FFFF00}09. {ffffff}Покупка VIP привелегий\n"\
			"{FFFF00}10. {ffffff}Бумбокс\t\t{99cc00}100 рублей",
			GetDonatePrice(DONATE_PRICE_SKILLS)
		);

		format(fmt_description, 32, "{FFFF00}{SERVER_NAME} %d руб", GetPlayerDonateRub(playerid));

		Dialog
		(
			playerid, DIALOG_DRUB_MENU, DIALOG_STYLE_LIST,
			fmt_description,
			fmt_text,
			"Выбрать", "Закрыть"
		);
	}

	return 1;
}

stock ShowPlayerDonations(playerid, name)
{
	new query[256],
		fmt_text[1400],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM `unitpay_payments` WHERE `account`='%s' AND `status`=0", name);
	result = mysql_query(mysql, query, true);

	if(!cache_num_rows(result))
	{
			format
			(
				fmt_text, sizeof fmt_text,
				"{FFFFFF}\
				Вы еще ни разу не пополняли свой аккаунт.\n\
				Это можно сделать на сайте {33cc66}"#SERVER_SITE" {FFFFFF}в разделе {6699cc}\"Донат\".\
				"
			);


			Dialog
			(
				playerid, DIALOG_DONATIONS, DIALOG_STYLE_MSGBOX,
				"{FFCC00}Последние пополнения",
				fmt_text,
				"Назад", ""
			);

			cache_delete(result);
			return 1;
	}

	format(fmt_text, sizeof(fmt_text), "Дата и время\t\t\tСумма\n{FFFFFF}");

	for(new i = 0; i < cache_num_rows(result); i++)
	{
	    new tmp_text[128], tmp_date[16];

	    cache_get_field_content(i, "dateComplete", tmp_date);
	    format(tmp_text, sizeof tmp_text, "\n%s\t\t%d.00 руб.", tmp_date, cache_get_field_content_int(i, "sum"));

	    strcat(fmt_text, tmp_text);
	}

	Dialog
	(
	    playerid,
	    DIALOG_DONATIONS,
	    DIALOG_STYLE_MSGBOX,
	    "{FFCC00}20 последних операций пополнения",
	    fmt_text,
	    "Назад", ""
	);
	cache_delete(result);
	return 1;
}

stock ShowPlayerConvertDialog(playerid)
{
    return SendClientMessage(playerid, 0xCECECEFF, "Конвертация отключена");
//    new current_money = GetPVarInt(playerid, "convert_money"),
    //new donate_price = g_doubling[DOUBLING_DONATE] ? GetDonatePrice(DONATE_PRICE_MONEY) * 2 : GetDonatePrice(DONATE_PRICE_MONEY);

    new fmt_text[200];
    format
    (
        fmt_text,
        sizeof fmt_text,
        "{FFFFFF}\
        Ставка: {009900}1000Р\n\
        {FFFFFF}Наличие: {009900}%d\n\
  		\n\
        {6666CC}Введите количество, которое\n\
        Вы хотите конвертировать в игровые деньги:\
        ",
        GetPlayerDonateRub(playerid)
    );

    Dialog(playerid, DIALOG_DONATE_CONVERT, DIALOG_STYLE_INPUT, "{ffcc00}Обмен валют (конвертер)", fmt_text, "Далее", "Назад");
}

stock ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync, anim_type=USE_ANIM_TYPE_NONE)
{
	SetPlayerData(playerid, P_USE_ANIM_TYPE, anim_type);

	if(forcesync == 0)
		forcesync = 1;

	return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
}

stock ResetSkin(playerid)
{
	return SetPlayerSkin(playerid, GetPlayerSkinEx(playerid));
}

stock InvitePlayer(playerid, org_id, give_rang = 1, bool: save = false)
{
	if(!(1 <= give_rang <= 10))
		give_rang = 1;

	new query[128];

	if(1 <= org_id < MAX_ORG)
	{
		SetPlayerTeamEx(playerid, org_id);
		SetPlayerData(playerid, P_JOB, give_rang);
	}
					else
	{
		SetPlayerTeamEx(playerid, 0);
		SetPlayerData(playerid, P_JOB, 0);
		//SetPlayerData(playerid, P_JOB, 0);
	}

	SetPlayerColorEx(playerid, g_organization[org_id][O_COLOR]);

	if(save)
	{
		//SetPlayerData(playerid, P_JOB, 0);

		if(1 <= org_id < MAX_ORG)
		{
			if(!GetPlayerSex(playerid))
				SetPlayerData(playerid, P_OSKIN, g_organization[org_id][O_SKINS][give_rang - 1]);
			else
				SetPlayerData(playerid, P_OSKIN, g_organization[org_id][O_WOMEN_SKIN]);
		}
					else SetPlayerData(playerid, P_OSKIN, 0);

		format(query, sizeof query, "UPDATE accounts SET team=%d,org_skin=%d,job=%d WHERE id=%d",\
			GetPlayerTeamEx(playerid), GetPlayerData(playerid, P_OSKIN), GetPlayerData(playerid, P_JOB), GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);

		if(give_rang == 10)
		{
			format(g_organization[org_id][O_LEADER], 64, GetPlayerNameEx(playerid));
			mysql_format(mysql, query, sizeof(query), "INSERT INTO `leaders`(`accout_id`, `name`, `frac_id`) VALUES ('%d', '%s', '%d')", GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), org_id);
			//mysql_query(mysql, query, false);
		}

		ResetSkin(playerid);
	}

	return 1;
}

stock UnInvite(playerid, to_player, reason[] = "")
{
	if(!(1 <= GetPlayerTeamEx(to_player) < MAX_ORG)) return 0;

	new fmt_msg[110];

	if(playerid != to_player)
	{
		format(fmt_msg, sizeof fmt_msg, "%s[%d] уволил Вас из организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(to_player));
		SendClientMessage(to_player, 0xFF6600FF, fmt_msg);

		if(GetPlayerTeamEx(playerid) == GetPlayerTeamEx(to_player))
		{
			format(fmt_msg, sizeof fmt_msg, "Вы уволили %s[%d] из своей организации", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
		}
					else
		{
			format(fmt_msg, sizeof fmt_msg, "Вы уволили %s[%d] из организации \"%s\"", GetPlayerNameEx(to_player), to_player, GetPlayerTeamName(to_player));
			SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
		}

		if(GetPlayerTeamEx(to_player) == TEAM_GOVERNMENT && IsValidDynamic3DTextLabel(GetPlayerData(to_player, P_ADVISOR_LABEL)))
		{
			DestroyDynamic3DTextLabel(GetPlayerData(to_player, P_ADVISOR_LABEL));
			SetPlayerData(to_player, P_ADVISOR_LABEL, Text3D: -1);
		}

		format(fmt_msg, sizeof fmt_msg, "Уволил %s[acc:%d] из организации %s. Причина: %s",
		GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), GetPlayerTeamName(to_player), reason);

		SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);
	}
					else
	{
		format(fmt_msg, sizeof fmt_msg, "Покинул организацию %s по собственному желанию", GetPlayerTeamName(to_player));
		SendLog(to_player, LOG_TYPE_FRACTION, fmt_msg);
	}
	if(!strcmp(g_organization[GetPlayerData(playerid, P_TEAM)][O_LEADER], GetPlayerNameEx(to_player)))
	{
		mysql_format(mysql, sctring, sizeof(sctring), "DELETE FROM `leaders` WHERE account_id = %d", GetPlayerAccountID(to_player));
		mysql_query(mysql, sctring, false);
		g_organization[GetPlayerData(playerid, P_TEAM)][O_LEADER] = EOS;
	}


	InvitePlayer(to_player, 0, 0, true);

	return 1;
}

stock SendPlayerOffer(playerid, to_player, type, value_1 = 0, value_2 = 0)
{
	if(GetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER) == INVALID_PLAYER_ID)
	{
		new fmt_str[144];
		switch(type)
		{
			case OFFER_TYPE_HANDSHAKE:
			{
				format(fmt_str, sizeof fmt_str, "Игрок %s предлагает пожать Вам руку", GetPlayerNameEx(playerid));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				format(fmt_str, sizeof fmt_str, "Предложение от %s", GetPlayerNameEx(playerid));
                ShowNotificationNew(to_player, 5, 10, 0, 0, fmt_str, ">>");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s пожать руку", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_FUEL_ST:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить заправочную станцию №%d \"%s\" по цене %d руб", GetPlayerNameEx(playerid), value_1, GetFuelStationData(value_1, FS_NAME), value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы заключить сделку или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s купить Вашу заправочную станцию \"%s\" за %d руб", GetPlayerNameEx(to_player), GetFuelStationData(value_1, FS_NAME), value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_UNUSED_1:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает заправить Ваш транспорт на %d л за %d руб", GetPlayerNameEx(playerid), value_1, value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s заправку транспорта на %d л за %d руб", GetPlayerNameEx(to_player), value_1, value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_UNUSED_2:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает починить Ваш транспорт за %d руб", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s сделать ремонт транспорта за %d руб", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_BUSINESS:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить бизнес №%d \"%s\" по цене %d руб", GetPlayerNameEx(playerid), value_1, GetBusinessData(value_1, B_NAME), value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы заключить сделку или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s купить Ваш бизнес \"%s\" за %d руб", GetPlayerNameEx(to_player), GetBusinessData(value_1, B_NAME), value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_BUSINESS_MANAGER:
			{
				if(GetBusinessData(value_1, B_TYPE) == BUSINESS_TYPE_CASINO)
					format(fmt_str, sizeof fmt_str, "%s предлагает Вам работать в казино в должности %s", GetPlayerNameEx(playerid), value_2 == 2 ? ("менеджера") : ("крупье"));
				else format(fmt_str, sizeof fmt_str, "%s предлагает Вам стать сотрудником его предприятия (%s)", GetPlayerNameEx(playerid), GetBusinessData(value_1, B_NAME));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "%s получил предложение стать вашим сотрудником", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_HOME:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить дом №%d по цене %d руб", GetPlayerNameEx(playerid), value_1, value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы заключить сделку или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s купить Ваш дом по цене %d руб", GetPlayerNameEx(to_player), value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_HOME_RENT_ROOM:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам поселиться в своем доме №%d", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, 0xFFFFFFFF, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s поселиться в своем доме №%d", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_OWNABLE_CAR:
			{
				new model_id = GetVehicleData(value_2, V_MODELID);
				new index = GetVehicleData(value_2, V_ACTION_ID);

				if(model_id <= 0 || index < 0)
					return 1;
				
				format(fmt_str, sizeof fmt_str, "Вы предложили %s купить Ваш транспорт \"%s\" за %d руб", GetPlayerNameEx(to_player), GetVehicleInfo(model_id-400, VI_NAME), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
				
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить транспорт по цене %d руб", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				new fmt_text[512];
				format
				(
					fmt_text, sizeof(fmt_text),
					"{ffffff}Игрок {ffff00}%s {ffffff}предлагает купить транспорт {ffff00}\"%s\" {ffffff}за {ffff00}%d руб.\n \n{ffffff}Информация о транспорте:\n{FFFF00}1. {ffffff}Стоимость продажи государству: {ffff00}%d руб\n{FFFF00}2. {ffffff}Пробег: {ffff00}%.2f KM\n{FFFF00}3. {ffffff}Сабвуфер: {ffff00}нет\n{FFFF00}4. {ffffff}Прошивка: {ffff00}-\n{FFFF00}5. {ffffff}Номерной знак: {ffff00}%s",
					GetPlayerNameEx(playerid),
					GetVehicleInfo(model_id-400, VI_NAME),
					value_1,
					GetVehicleInfo(model_id-400, VI_PRICE),
					GetVehicleData(value_2, V_MILEAGE),
					g_ownable_car[index][OC_NUMBER]
				);
				ShowPlayerDialog(to_player, DIALOG_SELLCARMY, DIALOG_STYLE_MSGBOX, "{ff0000} Продажа", fmt_text, "Купить", "Выйти");
			}
			case OFFER_TYPE_SELL_OWNABLE_CAR2:
			{
				new model_id = GetVehicleData(value_2, V_MODELID);
				new index = GetVehicleData(value_2, V_ACTION_ID);

				if(model_id <= 0 || index < 0)
					return 1;

				new fmt_text[512];
				format
				(
					fmt_text, sizeof(fmt_text),
					"{ffffff}Игрок {ffff00}%s {ffffff}продает транспорт {ffff00}\"%s\" {ffffff}за {ffff00}%d руб.\n \n{ffffff}Информация о транспорте:\n{EB4C42}1. {ffffff}Стоимость продажи государству: {ffff00}%d руб\n{EB4C42}2. {ffffff}Пробег: {ffff00}%.2f KM\n{EB4C42}3. {ffffff}Сабвуфер: {ffff00}нет\n{EB4C42}4. {ffffff}Прошивка: {ffff00}-\n{EB4C42}5. {ffffff}Номерной знак: {ffff00}%s",
					GetPlayerNameEx(GetOwnableCarData(index, OC_LAST_OWNER_GAME_ID)),
					GetVehicleInfo(model_id - 400, VI_NAME),
					GetOwnableCarData(index, OC_LAST_PRICE),
					GetVehicleInfo(model_id - 400, VI_PRICE),
					GetVehicleData(value_2, V_MILEAGE),
					g_ownable_car[index][OC_NUMBER]
				);

				ShowPlayerDialog(playerid, DIALOG_SELLCAR, DIALOG_STYLE_MSGBOX, "{ff0000} Покупка транспорта", fmt_text, "Купить", "Выйти");
			}
			case OFFER_TYPE_INVITE:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам вступить в организацию \"%s\"", GetPlayerNameEx(playerid), GetPlayerTeamName(playerid));

				if(IsTeamSubdivision(GetPlayerTeamEx(playerid)))
					format(fmt_str, sizeof fmt_str, "%s, подразделение \"%s\"", fmt_str, GetPlayerSubdivisionName(playerid));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Введите {00CC00}/yes {FFFFFF}чтобы принять предложение или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s вступить в организацию \"%s\"", GetPlayerNameEx(to_player), GetPlayerTeamName(playerid));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_FINVITE:
            {
                format(fmt_str, sizeof fmt_str, "{FFFFFF}%s предлагает Вам вступить в семью \"%s\"", GetPlayerNameEx(playerid), GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME));
                SendClientMessage(to_player, 0x1E90FFFF, fmt_str);

                SendClientMessage(to_player, -1, "Введите {00CC00}/yes {FFFFFF}чтобы принять предложение или {FF6600}/no {FFFFFF}для отказа");

                format(fmt_str, sizeof fmt_str, "Вы предложили игроку {d8284c}%s {1E90FF}вступить в семью \"%s\"", GetPlayerNameEx(to_player), GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME));
                SendClientMessage(playerid, 0x1E90FFFF, fmt_str);
            }
			case OFFER_TYPE_MEDHELP:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам пройти курс платного лечения за %d руб", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы пройти экспресс-лечение или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s пройти у Вас курс платного лечения за %d руб", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_HEAL:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам пройти курс лечения за %d руб", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s пройти у Вас курс лечения за %d руб", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_CHANGE_SEX:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает сделать Вам операцию по смене пола за %d руб", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s операцию по смене пола за %d руб", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SHOW_SKILL:
			{
				format(fmt_str, sizeof fmt_str, "%s хочет показать Вам свои навыки владения оружием", GetPlayerNameEx(playerid));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}для просмотра или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s посмотреть на Ваши навыки владения оружием", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_CASINO_DICE:
			{
				format(fmt_str, sizeof fmt_str, "%s хочет сыграть с Вами в кости. Ставка: %d руб.", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s сыграть в кости. Ставка: %d руб.", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			
			case OFFER_TYPE_GIVE_CAR_KEY:
			{
				format(fmt_str, sizeof fmt_str, "%s хочет дать Вам ключи от своего транспотра", GetPlayerNameEx(playerid));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы взять их или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили игроку %s взять ключи от своего транспорта", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_GIVE_MIC:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам подключиться к радио-эфиру", GetPlayerNameEx(playerid));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s подключиться к радио-эфиру", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_GIVE_LIC:
			{
				new lic_names[3][34] = {"вождение базового уровня", "вождение профессионального уровня", "оружие"};

				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить лицензию на %s за %d руб.",
				GetPlayerNameEx(playerid), lic_names[value_1 - 1], value_2);

				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s купить у Вас лицензию на %s за %d руб.",
				GetPlayerNameEx(to_player), lic_names[value_1 - 1], value_2);

				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_JAIL_FREE:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам пересмотреть Ваше дело за %d руб.", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Нажмите {00CC00}Y {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s пересмотреть его дело за %d руб.", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_ACCESSORY:
			{
				new price = GetPVarInt(playerid, "owner_accept_price"),
				acs = GetPVarInt(playerid, "acs_id");

				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить %s за %d руб.", GetPlayerNameEx(playerid), accessory[acs][NAME_ACCESSORY], price);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Напишите {00CC00}/yes {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s взять %s за %d руб.", GetPlayerNameEx(to_player), accessory[acs][NAME_ACCESSORY], price);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_GARAGE:
			{
				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить гараж №%d за %d руб.", GetPlayerNameEx(playerid), value_1, value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				SendClientMessage(to_player, 0xFFFFFFFF, "Напишите {00CC00}/yes {FFFFFF}для покупки или {FF6600}/no {FFFFFF}для отказа");
				format(fmt_str, sizeof fmt_str, "Вы предложили %s купить Ваш гараж №%d за %d руб.", GetPlayerNameEx(to_player), value_1, value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			default: return 1;
		}

		SetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER, to_player);

		SetPlayerOfferInfo(to_player, O_INCOMING_PLAYER, playerid);
		SetPlayerOfferInfo(to_player, O_INCOMING_TYPE, type);

		SetPlayerOfferValue(to_player, 0, value_1);
		SetPlayerOfferValue(to_player, 1, value_2);
	}
					else SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {FF9900}/cancel {FFFFFF}чтобы отозвать предыдущее предложение");

	return 1;
}

