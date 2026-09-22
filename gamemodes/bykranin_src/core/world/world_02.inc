//>> Файл: bykranin_src/core/world/world_02.inc  (578 строк)
//>> Тема: мир: пикапы, чекпоинты, зоны, области, GPS
//>> Внутри: CreateGreenZones, AddGreenZoneToMemory, GetGreenZoneByArea, GetPlayerGreenZoneVehicle, GreenZoneBrBonus, GreenZoneBrBonusOnTimer, GreenZoneBrBonusOffTimer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock CreateGreenZones()
{
	for(new idx; idx < g_green_zones_loaded; idx ++)
	{
		if(g_green_zones[idx][GZ_SIZE] <= 0.0)
		{
			continue;
		}

		new old_area = g_green_zones[idx][GZ_AREA];
		if(g_green_zones[idx][GZ_AREA] != -1)
		{
			DestroyDynamicArea(g_green_zones[idx][GZ_AREA]);
			g_green_zones[idx][GZ_AREA] = -1;
		}

		g_green_zones[idx][GZ_AREA] = CreateDynamicSphere
		(
			g_green_zones[idx][GZ_X], g_green_zones[idx][GZ_Y],
			g_green_zones[idx][GZ_Z], g_green_zones[idx][GZ_SIZE]
		);
	}
	return 1;
}

stock AddGreenZoneToMemory(Float:x, Float:y, Float:z, Float:radius, name[], bool:allow_park = false, bool:no_weapon = true)
{
	if(g_green_zones_loaded >= MAX_GREEN_ZONES)
	{
		return -1;
	}

	new idx = g_green_zones_loaded;
	g_green_zones[idx][GZ_X] = x;
	g_green_zones[idx][GZ_Y] = y;
	g_green_zones[idx][GZ_Z] = z;
	g_green_zones[idx][GZ_SIZE] = radius;
	format(g_green_zones[idx][GZ_NAME], 32, "%s", name);
	g_green_zones[idx][GZ_AREA] = CreateDynamicSphere(x, y, z, radius);
	g_green_zones[idx][GZ_ALLOW_PARK] = allow_park;
	g_green_zones[idx][GZ_NO_WEAPON] = no_weapon;

	g_green_zones_loaded ++;
	return idx;
}
stock GetGreenZoneByArea(areaid)
{
	for(new idx; idx < g_green_zones_loaded; idx ++)
	{
		if(g_green_zones[idx][GZ_AREA] == areaid) return idx;
	}

	return -1;
}

stock GetPlayerGreenZoneVehicle(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) return GetPlayerVehicleID(playerid);
	return 0;
}

stock GreenZoneBrBonus(playerid, vehicleid, value)
{
	new pvar_value = GetPVarInt(playerid, "player_in_green_zone");

	if(IsPlayerConnected(playerid))
	{
		new fmt_text[128];
	}

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 6);

	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, value);

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
	return 1;
}

forward GreenZoneBrBonusOnTimer(playerid, vehicleid);
public GreenZoneBrBonusOnTimer(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid))
	{
		return 1;
	}

	new pvar_value = GetPVarInt(playerid, "player_in_green_zone");
	if(!pvar_value)
	{
		return 1;
	}

	new current_vehicleid = GetPlayerGreenZoneVehicle(playerid);
	GreenZoneBrBonus(playerid, current_vehicleid, 1);
	if(vehicleid != current_vehicleid) GreenZoneBrBonus(playerid, vehicleid, 1);
	return 1;
}

forward GreenZoneBrBonusOffTimer(playerid, vehicleid);
public GreenZoneBrBonusOffTimer(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid))
	{
		return 1;
	}

	new pvar_value = GetPVarInt(playerid, "player_in_green_zone");
	if(pvar_value)
	{
		return 1;
	}
	GreenZoneBrBonus(playerid, vehicleid, 0);
	GreenZoneBrBonus(playerid, GetPlayerGreenZoneVehicle(playerid), 0);
	GreenZoneBrBonus(playerid, 0, 0);
	return 1;
}

stock SetPlayerGreenZoneBrBonus(playerid, bool:enabled)
{
	new vehicleid = GetPlayerGreenZoneVehicle(playerid);
	new pvar_value = GetPVarInt(playerid, "player_in_green_zone");
	new stored_vehicleid = GetPVarInt(playerid, "player_green_zone_vehicle");

	if(enabled)
	{
		SetPVarInt(playerid, "player_green_zone_vehicle", vehicleid);
		GreenZoneBrBonus(playerid, vehicleid, 1);
		SetTimerEx("GreenZoneBrBonusOnTimer", 150, false, "ii", playerid, vehicleid);
		SetTimerEx("GreenZoneBrBonusOnTimer", 500, false, "ii", playerid, vehicleid);
		return 1;
	}

	GreenZoneBrBonus(playerid, vehicleid, 0);
	if(stored_vehicleid != vehicleid) GreenZoneBrBonus(playerid, stored_vehicleid, 0);
	if(vehicleid != 0 || stored_vehicleid != 0) GreenZoneBrBonus(playerid, 0, 0);

	SetTimerEx("GreenZoneBrBonusOffTimer", 250, false, "ii", playerid, stored_vehicleid);
	DeletePVar(playerid, "player_green_zone_vehicle");
	return 1;
}

stock ShowAntiDmGreenZonesDialog(playerid)
{
	new fmt_text[4096], item[80], count;
	fmt_text[0] = EOS;

	for(new idx; idx < g_green_zones_loaded; idx ++)
	{
		if(g_green_zones[idx][GZ_SIZE] <= 0.0) continue;

		format(item, sizeof item, "%d. %s\n", idx, g_green_zones[idx][GZ_NAME]);
		strcat(fmt_text, item);
		SetPlayerListitemValue(playerid, count, idx);
		count ++;
	}

	if(!count) strcat(fmt_text, "Зеленые зоны не загружены");
	Dialog(playerid, DIALOG_ANTIDM_ZONES, DIALOG_STYLE_LIST, "{SERVER_NAME} | Зеленые зоны", fmt_text, "Выбрать", "Закрыть");
	return 1;
}

stock ShowAntiDmGreenZoneInfo(playerid, green_zone_id)
{
	if(green_zone_id < 0 || green_zone_id >= g_green_zones_loaded)
	{
		return SendClientMessage(playerid, -1, "Зеленая зона не найдена");
	}

	new fmt_text[256];
	fmt_text[0] = EOS;
	strcat(fmt_text, "{FF0000}Зеленая зона\\n\\n");
	format(fmt_text, sizeof fmt_text, "%s{FFFFFF}Зеленая зона: %s\\n", fmt_text, g_green_zones[green_zone_id][GZ_NAME]);
	format(fmt_text, sizeof fmt_text, "%s{FFFFFF}Координаты: %.2f, %.2f, %.2f\\n", fmt_text, g_green_zones[green_zone_id][GZ_X], g_green_zones[green_zone_id][GZ_Y], g_green_zones[green_zone_id][GZ_Z]);
	format(fmt_text, sizeof fmt_text, "%s{FFFFFF}Радиус: %.2f", fmt_text, g_green_zones[green_zone_id][GZ_SIZE]);

	Dialog(playerid, DIALOG_ANTIDM_INFO, DIALOG_STYLE_MSGBOX, "{FF0000}Зеленая зона", fmt_text, "Назад", "Закрыть");
	return 1;
}

stock LoadGreenZonesFromDB()
{
	new query[128];
	format(query, sizeof query, "SELECT name,x,y,z,radius,allow_park,no_weapon FROM greenzone ORDER BY id ASC");

	new Cache:result = mysql_query(mysql, query, true);
	new mysql_error_code = mysql_errno();
	if(mysql_error_code)
	{
		print("[GreenZone] Failed to load greenzone table");
		cache_delete(result);
		return 0;
	}

	new rows = cache_num_rows(result);
	new loaded;
	for(new row; row < rows && g_green_zones_loaded < MAX_GREEN_ZONES; row ++)
	{
		new name[32];
		new bool:allow_park = false;
		new bool:no_weapon = true;
		new Float:x, Float:y, Float:z, Float:radius;

		cache_get_field_content(row, "name", name, mysql, sizeof name);
		if(cache_get_field_content_int(row, "allow_park")) allow_park = true;
		if(!cache_get_field_content_int(row, "no_weapon")) no_weapon = false;

		x = cache_get_field_content_float(row, "x");
		y = cache_get_field_content_float(row, "y");
		z = cache_get_field_content_float(row, "z");
		radius = cache_get_field_content_float(row, "radius");

		new added_id = AddGreenZoneToMemory(x, y, z, radius, name, allow_park, no_weapon);

		if(added_id != -1) loaded ++;
	}

	if(rows > loaded && g_green_zones_loaded >= MAX_GREEN_ZONES)
	{
	}

	cache_delete(result);
	printf("[GreenZone] Loaded from greenzone: %d", loaded);
	return 1;
}

stock ShowPlayerGreenZoneText(playerid)
{
	new fmt_text[96];

    // -- this is old real russia & fuss rp
	//TextDrawShowForPlayer(playerid, green_zone_TD[0]);
	
	// -- this is new client (fix) zone
	ShowZona(playerid);
	return 1;
}

stock HidePlayerGreenZoneText(playerid)
{
	new fmt_text[96];

    // -- this is old real russia & fuss rp
	//TextDrawHideForPlayer(playerid, green_zone_TD[0]);

	// -- this is new client (fix) zone
	HideZona(playerid);
	return 1;
}
/*public OnPlayerCheat(playerid,code)
{
	new fmt_text[80];

	format(fmt_text, sizeof fmt_text, "[A] Подозрение на читерство: %s[%d] (код: #%d)", GetPlayerNameEx(playerid), playerid, code);
	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	return 1;
}*/

stock IsPlayerUseForbiddenSoftware(playerid)
{
	static const forbidden_soft_keys[][43 + 1] =
	{
		"5E1C1837D2C54B24EAAED18C3F96D9EA51A2A481003", // RakSAMP v0.5-0.3c
		"381356A6B4349449E8F818B06B405A4FBBE9F8DDDAB", // RakSAMP v0.5-0.3d
		"354A1F8D95B8384F9C365E2D7418C7EC06CD6EE2928", // RakSAMP v0.5-0.3eR2
		"38E4952825700FE3B8476C3F72D976E7447905BA45D" // BabaShura 2.6/2.7 (0.3e)
	};

	new player_key[64 + 1];

	gpci(playerid, player_key, sizeof(player_key));

	for(new i = 0; i < sizeof(forbidden_soft_keys); i++)
	{
		if(strcmp(player_key, forbidden_soft_keys[i]) == 0)
		{
			return 1;
		}
	}

	return 0;
}

CMD:setlights(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) != 6) return 1;

	new Float: x,
		Float: y;

	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		if(player_test_label[playerid][0] == Text3D: INVALID_3DTEXT_ID)
		{
			for(new idx; idx < 4; idx ++)
			{
				GetVehicleTurnSignalPos(vehicleid, idx + 1, x, y);

				player_test_label[playerid][idx] = CreateDynamic3DTextLabel(IntToString(idx), 0xFFCC33FF, x, y, 0.0, 10.0, _, vehicleid);
			}
		}
					else
		{
			for(new idx; idx < 4; idx ++)
			{
				DestroyDynamic3DTextLabel(player_test_label[playerid][idx]);

				player_test_label[playerid][idx] = Text3D: INVALID_3DTEXT_ID;
			}
		}
	}
					else SendClientMessage(playerid, -1, "u r not in a vehicle");

	return 1;
}

CMD:setspeed(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;

	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, -1, "u have to be in a vehicle");

	extract params -> new Float: speed; else return SendClientMessage(playerid, -1, "/setspeed [speed]");

	new vehicleid = GetPlayerVehicleID(playerid);

	SetVehicleSpeed(vehicleid, speed);

	return 1;
}

CMD:supercarblya(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) != 6) return 1;

	new supercar = GetPVarInt(playerid, "supercar");

	supercar = supercar ^ 1;

	SetPVarInt(playerid, "supercar", supercar);

	new fmt_text[2][32] =
	{
		"supercar off",
		"supercar on"
	};

	SendClientMessage(playerid, -1, fmt_text[supercar]);

	return 1;
}

CMD:setmultiplier(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) != 6) return 1;

	extract params -> new multiplier; else return SendClientMessage(playerid, -1, "/setmultiplier [mult]");

	SetPVarInt(playerid, "supercar_multiplier", multiplier);

	SendClientMessage(playerid, -1, "multiplier changed");

	return 1;
}

CMD:getvehspeed(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;

	extract params -> new vehicleid; else return SendClientMessage(playerid, -1, "/getvehspeed [vehicleid]");

	new Float: speed = GetVehicleSpeed(vehicleid);

	new fmt_text[24];

	format(fmt_text, sizeof fmt_text, "vehicle speed: %f", speed);
	SendClientMessage(playerid, 0xFF5533FF, fmt_text);

	return 1;
}

CMD:pedaltype(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) != 6) return 1;

	new pedal_name[3][] = {"none", "gas", "brake"};

	new pedal_type = player_press_pedal[playerid];

	SendClientMessage(playerid, -1, pedal_name[pedal_type]);

	return 1;
}

CMD:createpromo(playerid, params[])
{
	

	Dialog
	(
		playerid, DIALOG_PROMO_CREATE, DIALOG_STYLE_INPUT,
		"{ff0000}Создание промокода",
		"{FFFF00}Промокод {FFFFFF}- уникальный набор символов,позволяющий Вам и человеку,использующему Ваш промокод получить вознаграждение.\n"\
		"Промокод разделен на {FFFF00}10 уровней{FFFFFF},с повыщением которого Вы будете получать ценные призы.\n"\
		"Вы можете самостоятельно создать {FFFF00}свой промокод{FFFFFF},при условии что он свободен.\n\n"\
		"Однако стоит помнить,что количество символов в промокоде определяют его стоимость\n"\
		"{FFFF00}1 символ {FFFFFF}- 10.000.000 рублей или 2000 донат-рублей\n"\
		"{FFFF00}От 2 символов до 3 символов {FFFFFF}- 7.000.000 рублей или 1.000 донат-рублей\n"\
		"{FFFF00}{FFFF00}От 3 символов до 5 символов {FFFFFF}- 6.000.000 рублей.\n"\
		"{FFFF00}От 5 символов до 7 символов {FFFFFF}- 3.000.000 рублей.\n"\
		"{FFFF00}От 7 символов {FFFFFF}- 1.000.000 рублей.\n"\
		"Вы можете использовать {FFFF00}латиницу и кириллицу,@ и цифры\n\n"\
		"{FFFFFF}Для создания промокода введите в поле ниже желаемый набор символов.",
		"Далее", "Выйти"
	);

	return 1;
}

CMD:ytpromo(playerid, params[])
{
    if(GetPlayerData(playerid, P_YTPROMO_ACTIVATE) == 1) return Send(playerid, COR_RED, "[Ошибка]: "c_b"Ютуберский промокод можно активировать только один раз!");
    
	Dialog
	(
		playerid, DIALOG_YTPROMO_ACTIVATE, DIALOG_STYLE_INPUT,
		"{FF0000}Промокод",
		"{FFFFFF}Введите промокод для того чтобы получить приз:",
		"Ввести", "Выйти"
	);

	return 1;
}
CMD:promos(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_PROMO_ACTIVATE, DIALOG_STYLE_INPUT,
		"{FF0000}Промокод",
		"{FFFFFF}Введите промокод для того чтобы получить приз:",
		"Далее", "Отмена"
	);

	return 1;
}
stock ShowPlayerBuyLeadDialog(playerid)
{
//	if(GetPlayerTeamEx(playerid) && GetPlayerJob(playerid) == 10 || GetPlayerData(playerid, P_ADMIN))
//		return SendClientMessage(playerid, -1, "Вы не можете купить лидерку потому что вы уже лидер или администратор!");

    new count, fmt_str[256];
    for(new i = 1; i < MAX_ORG; i++)
    {
    	if(g_organization[i][O_PRICE] != 0 && !strlen(g_organization[i][O_LEADER]))
    	{
    		SetPlayerListitemValue(playerid, count, i);
    		count++;
    		format(fmt_str, sizeof(fmt_str), "%s%s\t{FFFF00}%d {FFFFFF}рублей\n", fmt_str, g_organization[i][O_NAME], g_organization[i][O_PRICE]);
    	}
    }
    if(count == 0) return SendClientMessage(playerid, -1, ""USC"В данный момент нет свободных лидерок.");
    return Dialog(playerid, DIALOG_DRUB_BUYLEAD, DIALOG_STYLE_LIST, "{FFFF00}Список свободных постов лидерства", fmt_str, "Купить", "Назад");

}
stock ShowPlayerBuyZamDialog(playerid)
{
	if(GetPlayerTeamEx(playerid) && GetPlayerJob(playerid) == 10 || GetPlayerData(playerid, P_ADMIN))
		return SendClientMessage(playerid, -1, ""USC"Вы не можете купить 9 ранг потому что вы уже лидер или администратор!");

    new count, fmt_str[256];
    for(new i = 1; i < MAX_ORG; i++)
    {
		SetPlayerListitemValue(playerid, count, i);
		count++;
		format(fmt_str, sizeof(fmt_str), "%s%s\t{FFFF00}%d {FFFFFF}рублей\n", fmt_str, g_organization[i][O_NAME], GetDonatePrice(DONATE_PRICE_ZAM));

		Dialog(playerid, DIALOG_DRUB_BUYZAM, DIALOG_STYLE_LIST, "{FFFF00}Покупка заместителя", fmt_str, "Купить", "Назад");
    }
    return 1;
}
stock ShowPlayerBuyAdminDialog(playerid)
{
	if(GetPlayerAdminEx(playerid) >= 6)
		return SendClientMessage(playerid, -1, ""USC"У вас уже максимальный уровень админ прав");

	new fmt_str[256];

	for(new i = GetPlayerAdminEx(playerid); i < 11; i++)
    {
        format(fmt_str, sizeof(fmt_str), "%s{ffffff}%i уровень\t{FFFF00}%i {FFFFFF}рублей\n",fmt_str, i + 1, ((i + 1) - GetPlayerAdminEx(playerid)) * Config[admin_price]);
    }
    strcat(fmt_str, "12 уровень\t{FFFF00} 2500{FFFFFF} рублей");

    return Dialog(playerid, DIALOG_DRUB_BUYADMIN, DIALOG_STYLE_LIST, "{FFFF00}Покупка админ прав", fmt_str, "Купить", "Назад");
    

}
stock ShowAdminLoginPasswordDialog(playerid)
{
    return SRAdmin_ShowLogin(playerid);
}

stock AdminAuthorization(playerid)
{
    return SRAdmin_ShowLogin(playerid);
}
stock GiveFamilyMoneyEx(fam_id, money)
{

    new fmt_str[185];
    AddFamilyData(fam_id, F_MONEY, +, money);

    format(fmt_str, sizeof fmt_str, "UPDATE family SET money=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_MONEY), fam_id);
    mysql_query(mysql, fmt_str, false);
    return 1;
}
stock FInvitePlayer(playerid, fam_id, give_rang = 1, bool: save = false)
{
    if(!(1 <= give_rang <= 10))
        give_rang = 1;


    SetPlayerData(playerid, P_FAMILY, fam_id);
    SetPlayerData(playerid, P_FAMILY_RANK, give_rang);

    if(save)
    {
        new query[80];

        format(query, sizeof query, "UPDATE accounts SET family=%d,family_rank=%d WHERE id=%d",\
            GetPlayerData(playerid, P_FAMILY), GetPlayerData(playerid, P_FAMILY_RANK), GetPlayerAccountID(playerid));
        mysql_query(mysql, query, false);
    }

    return 1;
}
stock FUnInvite(playerid, to_player, reason[] = "")
{
    new fmt_msg[110];

    if(playerid != to_player)
    {
        format(fmt_msg, sizeof fmt_msg, "%s[%d] уволил Вас из семьи \"%s\"", GetPlayerNameEx(playerid), playerid, GetFamilyData(GetPlayerData(to_player, P_FAMILY), F_NAME));
        SendClientMessage(to_player, 0xCECECEFF, fmt_msg);

        if(GetPlayerTeamEx(playerid) == GetPlayerTeamEx(to_player))
        {
            format(fmt_msg, sizeof fmt_msg, "Вы уволили %s[%d] из своей семьи", GetPlayerNameEx(to_player), to_player);
            SendClientMessage(playerid, 0x1E90FFFF, fmt_msg);
        }
					else
        {
            format(fmt_msg, sizeof fmt_msg, "Вы уволили %s[%d] из семьи \"%s\"", GetPlayerNameEx(to_player), to_player, GetFamilyData(GetPlayerData(to_player, P_FAMILY), F_NAME));
            SendClientMessage(playerid, 0x1E90FFFF, fmt_msg);
        }

        format(fmt_msg, sizeof fmt_msg, "Уволил %s[acc:%d] из семьи %s. Причина: %s",
        GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), GetFamilyData(GetPlayerData(to_player, P_FAMILY), F_NAME), reason);

        SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);
    }
					else
    {
        format(fmt_msg, sizeof fmt_msg, "Покинул семью %s по собственному желанию", GetPlayerTeamName(to_player));
        SendLog(to_player, LOG_TYPE_FRACTION, fmt_msg);
    }

    FInvitePlayer(to_player, 0, 0, true);

    return 1;
}
