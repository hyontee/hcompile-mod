//>> Файл: bykranin_src/core/account/account_03.inc  (445 строк)
//>> Тема: аккаунт: вход, регистрация, пин-код, спавн
//>> Внутри: /no, /cancel, /hi, /me, /do, /try, /w
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:no(playerid, params[])
{
    new sellerid = GetPVarInt(playerid, "hnew_offer_from") - 1;

    if(sellerid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, 0x999999FF, "В данный момент Вам никто ничего не предлагает");

    ClearHouseSellOffer(playerid);

    if(IsPlayerConnected(sellerid))
    {
        DeletePVar(sellerid, "hnew_offer_target");

        new fmt[144];
        format(fmt, sizeof fmt, "%s отказался от покупки недвижимости", GetPlayerNameEx(playerid));
        SendClientMessage(sellerid, 0xCECECEFF, fmt);
    }

    SendClientMessage(playerid, 0xCECECEFF, "Вы отказались от покупки недвижимости");
    return 1;
}

CMD:cancel(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER);

	if(offer_id != INVALID_PLAYER_ID)
	{
		if(GetPlayerOfferInfo(offer_id, O_INCOMING_PLAYER) == playerid)
		{
			ClearPlayerOffer(offer_id);

			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "%s отозвал свое предложение", GetPlayerNameEx(playerid));
			SendClientMessage(offer_id, 0xFF6600FF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Вы отозвали свое предложение для %s", GetPlayerNameEx(offer_id));
			SendClientMessage(playerid, 0xFF6600FF, fmt_str);
		}
					else SendClientMessage(playerid, 0xFF6600FF, "Вы отозвали свое последнее предложение");

		ClearPlayerOffer(playerid);
	}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас нет активных предложений");

	return 1;
}

CMD:hi(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Нельзя использовать в машине");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /hi [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
	if(0.5 <= dist <= 1.5)
	{
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_HANDSHAKE);
	}
					else if(dist < 20.0)
	{
		new fmt_str[35];

		new Float: x, Float: y;
		new Float: angle;

		GetPlayerPos(playerid, x, y, z);
		angle = GetAngleToPoint(to_x, to_y, x, y);

		SetPlayerFacingAngle(playerid, angle);

		format(fmt_str, sizeof fmt_str,"машет рукой %s", GetPlayerNameEx(to_player));
		Action(playerid, fmt_str, _, false);

		ApplyAnimationEx(playerid, "PED", "endchat_03", 4.1, 0, 1, 1, 0, 0, 1);
	}
					else SendClientMessage(playerid, 0x999999FF, "Вы находитесь слишком далеко от игрока");

	BlackPass_OnPlayerGreeting(playerid);
	return 1;
}

CMD:me(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /me [текст]");

	return Action(playerid, params);
}

CMD:do(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /do [текст]");

	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xDD90FFFF, 25.0, 5000);

	format(fmt_str, sizeof fmt_str, "%s (%s)", params, GetPlayerNameEx(playerid));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

CMD:try(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /try [текст]");

	new fmt_str[128];

	format(fmt_str, sizeof fmt_str, "%s %s %s", GetPlayerNameEx(playerid), params, !random(3) ? ("{66CC00}| Удачно") : ("{FF6600}| Неудачно"));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

CMD:w(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /w [текст]");

	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xACCE90FF, 3.0, 5000);

	format(fmt_str, sizeof fmt_str, "%s шепчет: %s", GetPlayerNameEx(playerid), params);
	SendMessageInLocal(playerid, fmt_str, 0xACCE90FF, 3.0);

	return 1;
}

CMD:s(playerid, params[])
{
	if(GetPlayerLevel(playerid) < 11)
		return SendClientMessage(playerid, 0xCECECEFF, "Этим можно пользоваться со 2 уровня");

	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /s [текст]");

	if(IsAIP(params))
	{
        SendClientMessage(playerid, -1, "Подозрения в рекламе!");
        return false;
    }

	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xFFFFFFFF, 37.0, 5000);

	format(fmt_str, sizeof fmt_str, "%s[%d] крикнул: %s", GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_str, 0xFFFFFFFF, 37.0);

	ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:dev(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	new Float:Angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, Angle);
	printf("%f,%f,%f,f", x, y, z, Angle);
	return 1;
}


CMD:repaircar(playerid, params[])
{
	if(GetPlayerRepCar(playerid) < 1) return Send(playerid, -1,"У вас нет рем. комплекса, купить его можно на АЗС");
	
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,-1, !"[Ошибка] {FFFFFF}Вы должны быть за рулём");
	
	SendClientMessage(playerid,-1, !"[Информация] {FFFFFF}Вы успешно починили свой транспорт");
	new vehicleid = GetPlayerVehicleID(playerid);
	
	SetVehicleHealth(vehicleid,1000);
	PlayerPlaySound(playerid, 1133, 0.0,0.0,0.0);
	

	RepairVehicle(vehicleid);
	
	AddPlayerData(playerid, P_REPCARID, -, 1);
	UpdatePlayerDatabaseInt(playerid, "repcarid",GetPlayerData(playerid, P_REPCARID));
	return 1;
}
CMD:n(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /n [нон-рп сообщение]");

	if(IsAIP(params))
	{
        SendClientMessage(playerid, -1, "Подозрения в рекламе!");
        return false;
    }

	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0x999999FF, 30.0, 5000);

	format(fmt_str, sizeof fmt_str, "(( %s[%d]: %s ))", GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_str, 0xCCCC99FF, 30.0);

	return 1;
}

CMD:lic(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /lic [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 4.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	static const
		lic_names[3][32 + 1] = {"{FFFF00}Отсутствует", "{2fdb07}Имеется", "{2fdb07}Имеется"};

	new fmt_str[700];

	format(fmt_str, sizeof fmt_str, "%s свои лицензии", to_player == playerid ? "просматривает" : "показал");

	Action(playerid, fmt_str, _, false);

    format(fmt_str, sizeof fmt_str,
	"{FFFF00}#1.{FFFFFF}Категория A \t\t\t\t\t{FFFF00}отсутсв...\t\t\t\t\t {FFFFFF}-\n"\
	"{FFFF00}#2.{FFFFFF}Категория B \t\t\t\t\t{2fdb07}Имеется\t\t\t\t\t {FFFFFF}до 08.11.20...\n"\
	"{FFFF00}#3.{FFFFFF}Категория C \t\t\t\t\t{FFFF00}отсутсв...\t\t\t\t\t {FFFFFF}-\n"\
	"{FFFF00}#4.{FFFFFF}Категория D \t\t\t\t\t{FFFF00}отсутсв...\t\t\t\t\t {FFFFFF}-\n"\
	"{FFFF00}#5.{FFFFFF}Категория Оружие \t\t\t\t\t%s\t\t\t\t\t {FFFFFF}до 08.11.20...\n"\
	"{FFFF00}#6.{FFFFFF}Категория Водный трансп...\t\t\t\t\t%s\t\t\t\t\t {FFFFFF}до 08.11.20...",
	lic_names[ GetPlayerData(playerid, P_DRIVING_LIC) ],
	GetPlayerData(playerid, P_WEAPON_LIC) >= 1 ? ("{2fdb07}Имеется") : ("{FFFF00}Отсутсв.."));

	Dialog(to_player, 3562, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Лицензии гражданина", fmt_str, "Закрыть", "");
	return 1;
}

CMD:pass(playerid, params[])
{
    extract params -> new to_player; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /pass [id игрока]");
	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	new fmt_text[450];
	
  	format
	 (
      fmt_text, sizeof fmt_text,

	  "{FFFFFF}Имя:{FF6600}\t\t\t\t\t\t\t\t%s\n"\
   	  "{FFFFFF}Возраст:{FF6600}\t\t\t\t\t\t%d\n"\
      "{FFFFFF}Пол:{FF6600}\t\t\t\t\t\t\t\t%s\n"\
      "{FFFFFF}Проживание:{FF6600}\t\t\t%s\n"\
      "-----------         -----------\n"\
      "{FFFFFF}Организация:{FF6600}\t%s\n"\
	  "{FFFFFF}Должность:{FF6600}\t\t\t\t\t%s\n"\
	  "-----------         -----------\n"\
	  "{FFFFFF}Телефон:{FF6600}\t\t\t%d\n"\
	  "{FFFFFF}Уровень розыска:{FF6600}\t\t\t%d\n"\
	  "{FFFFFF}Законопослушность:{FF6600}\t\t%d",
      GetPlayerNameEx(playerid),
      GetPlayerLevel(playerid),
      GetPlayerSexName(playerid),
      GetPlayerHouseName(playerid),
      GetPlayerTeamName(playerid),
      GetPlayerJobAndRankName(playerid),
      GetPlayerPhone(playerid),
      GetPlayerSuspect(playerid),
      GetPlayerData(playerid, P_LAW_ABIDING)
     );
     
    Action(playerid, "показал свой паспорт", _, false);

     
    return Dialog(to_player, DIALOG_PASSPORT, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{FFFFFF} | Паспорт", fmt_text, "Закрыть", "");

}

CMD:restart(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	server_restart = true;

	return GameModeExit();
}
CMD:save_pos(playerid)
{
	new Float:POS[4];
	new fmt_str[64];
	GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
	GetPlayerFacingAngle(playerid, POS[3]);

	format(fmt_str, 64, "X: %f Y: %f Z: %f ANGLE: %f", POS[0], POS[1], POS[2], POS[3]);
	SendClientMessage(playerid, -1, fmt_str);
	return 1;
}

CMD:antidm(playerid, params[])
{
	#pragma unused params
	if(GetPlayerAdminEx(playerid) < 13) return 1;
	return ShowAntiDmGreenZonesDialog(playerid);
}

CMD:addzone(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new Float:radius, string:name[32]; else return SendClientMessage(playerid, -1, "Используйте: /addzone [радиус] [название]");
	if(!(1.0 <= radius <= 500.0)) return SendClientMessage(playerid, -1, "Радиус зеленой зоны должен быть от 1 до 500");
	if(g_green_zones_loaded >= MAX_GREEN_ZONES) return SendClientMessage(playerid, -1, "Достигнут лимит зеленых зон");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new query[256];
	mysql_format(mysql, query, sizeof query, "INSERT INTO greenzone (name,x,y,z,radius,allow_park,no_weapon) VALUES ('%e','%f','%f','%f','%f','0','1')", name, x, y, z, radius);
	new Cache:result = mysql_query(mysql, query, true);
	if(mysql_errno())
	{
		cache_delete(result);
		return SendClientMessage(playerid, -1, "Ошибка сохранения зеленой зоны в базу данных");
	}
	cache_delete(result);

	new green_zone_id = AddGreenZoneToMemory(x, y, z, radius, name, false, true);
	if(green_zone_id == -1) return SendClientMessage(playerid, -1, "Не удалось создать зеленую зону в памяти сервера");

	new fmt_text[128];
	format(fmt_text, sizeof fmt_text, "Зеленая зона #%d создана: %s | Радиус: %.2f", green_zone_id, name, radius);
	SendClientMessage(playerid, -1, fmt_text);
	return 1;
}
CMD:define(playerid)
{
	new string[1500], null = 0;
	if(GetPlayerAdminEx(playerid) > 0) {
		foreach(new i:Player)
		{
			if(GetPVarInt(i, "RepUn") > 0)
			{
				null++;
				format(string, sizeof(string), "%s\n{FFFFFF}%i. %s[%d] | Жалоба: %s [%s]", string, null, GetPlayerNameEx(i),i,RepInfo[i][Reptex], date("%hh:%ii:%ss", RepInfo[i][RepTime]));
			}
		}
		strcat(string, "\n\n{FFCC00}Ответить на жалобу: /pm [id] [ответ]");
		if(null == 0) return SendClientMessage(playerid, 0xAA3333AA,"Список репортов пуст");
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "Репорт",string, "Обновить", "Закрыть");
	}

	return 1;
}

CMD:mm(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_PLAYER_MENU, DIALOG_STYLE_LIST,
		"{00FFFF}"SERVER_NAME"{ffffff} | Меню игрока",
		""c_b"1. Статистика\n"\
		"2. Список команд\n"\
		"3. Личные настройки\n"\
		"4. Настройки безопасности\n"\
		"5. Связь с администрацией\n"\
		"6. Улучшения\n"\
		"7. Правила сервера\n"\
		"8. Изменить имя\n"\
		"9. Дополнительно\n"\
		"{FFFFCC}10. Активация промокода\n"\
		"11. Достижения\n"\
		"12. Квесты",
		"Выбрать", "Закрыть"
	);
	return 1;
}
alias:mm("mn")
//alias:mm("menu");
stock gpswww(playerid)
{
	DisablePlayerGPS(playerid);

	Dialog
	(
		playerid, DIALOG_GPS, DIALOG_STYLE_LIST,
		"{00FFFF}"SERVER_NAME"{ffffff} | GPS",
		""c_server"1. "c_b"Важные места\n"\
		""c_server"2. "c_b"Работы для новичков\n"\
		""c_server"3. "c_b"Основные работы\n"\
		""c_server"4. "c_b"Государственные организации\n"\
		""c_server"5. "c_b"Преступные группировки\n"\
		""c_server"6. "c_b"Транспортные компании\n"\
		""c_server"7. "c_b"Строительные компании\n"\
		""c_server"8. "c_b"Таксопарки\n"\
		""c_server"9. "c_b"Развлечения\n"\
		""c_server"10. "c_b"Банки\n"\
		""c_server"11. "c_b"Причалы\n"\
		""c_server"12. "c_b"Автосалоны\n"\
		""c_server"13. "c_b"Тюнинг ателье\n"\
		""c_server"14. "c_b"Города и населенные пункты\n"\
		""c_server"15. "c_b"Вокзалы\n"\
		""c_server"16. "c_b"Поиск ближайших мест",
		"Выбрать", "Закрыть"
	);
	return 1;
}


