//>> Файл: bykranin_src/core/admin/admin_01.inc  (882 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: GetSkillBar, ShowPlayerSkills, GetPlayerSkillAmount, SetPlayerSkillAmount, ShowTeleportList, CreateTicket, PayTicket
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).

stock GetSkillBar(amount)
{
	new tmp_bar[101];
	if(!amount) return tmp_bar;
 	for(new i = 0; i < amount; i++)
		strcat(tmp_bar, "|");

 	return tmp_bar;
}

stock ShowPlayerSkills(playerid, to_player = -1)
{
	if(to_player < 0)
		to_player = playerid;

	new tmp_skills[1560];
	format
	(
	    tmp_skills,
	    sizeof(tmp_skills),
	    "Сила\t\t%d%s\t%s\n\
	    {99ff66}\
		Colt 45\t\t%d%s\t%s\n\
		SD Pistol\t%d%s\t%s\n\
	    Desert Eagle\t%d%s\t%s\n\
	    Shotgun\t%d%s\t%s\n\
	    MP5\t\t%d%s\t%s\n\
	    AK47\t\t%d%s\t%s\n\
	    M4\t\t%d%s\t%s\n\
	    Sniper Rifle\t%d%s\t%s\n\
		Sawnoff\t%d%s\t%s\n\
		Combat SG\t%d%s\t%s\n\
		Micro Uzi\t%d%s\t%s\
	    ",
	    GetPlayerData(playerid, P_POWER), "%",
	    GetSkillBar(GetPlayerData(playerid, P_POWER)),
	    GetPlayerData(playerid, P_SKILL_COLT), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_COLT)),
		GetPlayerData(playerid, P_SKILL_SDPISTOL), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_SDPISTOL)),
		GetPlayerData(playerid, P_SKILL_DEAGLE), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_DEAGLE)),
		GetPlayerData(playerid, P_SKILL_SHOTGUN), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_SHOTGUN)),
		GetPlayerData(playerid, P_SKILL_MP5), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_MP5)),
		GetPlayerData(playerid, P_SKILL_AK47), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_AK47)),
		GetPlayerData(playerid, P_SKILL_M4), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_M4)),
		GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE)),
		GetPlayerData(playerid, P_SKILL_SAWNOFF), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_SAWNOFF)),
		GetPlayerData(playerid, P_SKILL_COMBAT_SG), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_COMBAT_SG)),
		GetPlayerData(playerid, P_SKILL_MICRO_UZI), "%",
		GetSkillBar(GetPlayerData(playerid, P_SKILL_MICRO_UZI))
	);
	Dialog(to_player, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCC00}Навыки владения оружием", tmp_skills, "Закрыть", "");

	return 1;
}

stock GetPlayerSkillAmount(playerid, skill_index)
{
	new amount;

	switch(skill_index)
	{
		case 0: amount = GetPlayerData(playerid, P_POWER);
		case 1: amount = GetPlayerData(playerid, P_SKILL_COLT);
		case 2: amount = GetPlayerData(playerid, P_SKILL_SDPISTOL);
		case 3: amount = GetPlayerData(playerid, P_SKILL_DEAGLE);
		case 4: amount = GetPlayerData(playerid, P_SKILL_SHOTGUN);
		case 5: amount = GetPlayerData(playerid, P_SKILL_MP5);
		case 6: amount = GetPlayerData(playerid, P_SKILL_AK47);
		case 7: amount = GetPlayerData(playerid, P_SKILL_M4);
		case 8: amount = GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE);
		case 9: amount = GetPlayerData(playerid, P_SKILL_SAWNOFF);
		case 10: amount = GetPlayerData(playerid, P_SKILL_COMBAT_SG);
		case 11: amount = GetPlayerData(playerid, P_SKILL_MICRO_UZI);
	}

	return amount;
}

stock SetPlayerSkillAmount(playerid, skill_index, amount)
{
	switch(skill_index)
	{
		case 0: SetPlayerData(playerid, P_POWER, amount);
		case 1: SetPlayerData(playerid, P_SKILL_COLT, amount);
		case 2: SetPlayerData(playerid, P_SKILL_SDPISTOL, amount);
		case 3: SetPlayerData(playerid, P_SKILL_DEAGLE, amount);
		case 4: SetPlayerData(playerid, P_SKILL_SHOTGUN, amount);
		case 5: SetPlayerData(playerid, P_SKILL_MP5, amount);
		case 6: SetPlayerData(playerid, P_SKILL_AK47, amount);
		case 7: SetPlayerData(playerid, P_SKILL_M4, amount);
		case 8: SetPlayerData(playerid, P_SKILL_SNIPER_RIFLE, amount);
		case 9: SetPlayerData(playerid, P_SKILL_SAWNOFF, amount);
		case 10: SetPlayerData(playerid, P_SKILL_COMBAT_SG, amount);
		case 11: SetPlayerData(playerid, P_SKILL_MICRO_UZI, amount);
	}

	return 1;
}

stock ShowTeleportList(playerid)
{
    return SRAdmin_ShowTeleports(playerid);
}

stock CreateTicket(playerid, amount, issuer[], description[])
{
	new query[190];

	mysql_format(mysql, query, sizeof query, "INSERT INTO tickets (uid, amount, issuer, description) VALUES (%d, %d, '%s', '%s')",
	GetPlayerAccountID(playerid), amount, issuer, description);
	mysql_query(mysql, query, false);

	return 1;
}

stock PayTicket(playerid, ticketid)
{
	new query[90],
		Cache: result,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE id=%d LIMIT 1", ticketid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	new uid = cache_get_field_content_int(0, "uid"),
		amount = cache_get_field_content_int(0, "amount"),
		status = cache_get_field_content_int(0, "status"),
		desc[64];

	cache_get_field_content(0, "description", desc);

	cache_delete(result);

	if(!rows)
		return SendClientMessage(playerid, 0xCECECEFF, "Данный штраф не найден");

	if(uid != GetPlayerAccountID(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Данный штраф выписан не Вам");

	if(status)
		return SendClientMessage(playerid, 0xCECECEFF, "Данный штраф уже оплачен");

	if(GetPlayerBankMoney(playerid) < amount)
		return SendClientMessage(playerid, 0x999999FF, "Недостаточно средств на основном банковском счету для оплаты штрафа");

	GivePlayerMoneyEx(playerid, -amount, "Оплата штрафа", true, true);

	mysql_format(mysql, query, sizeof query, "UPDATE tickets SET status=1 WHERE id=%d", ticketid);
	mysql_query(mysql, query, false);

	format(query, sizeof query, "Вы оплатили штраф №%d (%s)", ticketid, desc);
	SendClientMessage(playerid, 0x66CC33FF, query);

	return 1;
}

/*stock CreateRadar(playerid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:zone_x, Float:zone_y, Float:zone_z, limit, modelid)
{
	new radar_id = g_radars_created;

	SetRadarData(radar_id, R_OBJECT, CreateDynamicObject(modelid, x, y, z, rx, ry, rz));

	SetRadarData(radar_id, R_ZONE, CreateDynamicSphere(zone_x, zone_y, zone_z, 40.0));

	new fmt_text[110];

	format(fmt_text, sizeof fmt_text, "- Регистратор скорости №%d -\n\n{FFFFFF}Ограничение: %d км/ч\n{888888}Установил: %s", radar_id, limit, GetPlayerNameEx(playerid));

	SetRadarData(radar_id, R_LABEL, CreateDynamic3DTextLabel(fmt_text, 0x3399FFFF, x, y, z + 3.0, 50.0));

	SetRadarData(radar_id, R_POS_X, x);
	SetRadarData(radar_id, R_POS_Y, y);
	SetRadarData(radar_id, R_POS_Z, z);
	SetRadarData(radar_id, R_POS_RX, rx);
	SetRadarData(radar_id, R_POS_RY, ry);
	SetRadarData(radar_id, R_POS_RZ, rz);
	SetRadarData(radar_id, R_ZONE_X, zone_x);
	SetRadarData(radar_id, R_ZONE_Y, zone_y);
	SetRadarData(radar_id, R_ZONE_Z, zone_z);

	SetRadarData(radar_id, R_LIMIT, limit);

	g_radars_created ++;

	return 1;
}

stock RemoveRadar(radar_id)
{
	DestroyDynamic3DTextLabel(GetRadarData(radar_id, R_LABEL));

	DestroyDynamicArea(GetRadarData(radar_id, R_ZONE));

	DestroyDynamicObject(GetRadarData(radar_id, R_OBJECT));

	g_radar[radar_id] = g_radar_default_values;

	if(radar_id == g_radars_created - 1 && radar_id != 0)
		g_radars_created --;

	return 1;
}

stock CheckRadars(playerid)
{
	new Float: speed = GetPlayerSpeed(playerid);

	for(new idx; idx < g_radars_created; idx ++)
	{
		if(!IsValidDynamicObject(GetRadarData(idx, R_OBJECT))) continue;
		if(GetPVarInt(playerid, "radar_detected") > gettime()) continue;

		if(IsPlayerInRangeOfPoint(playerid, 40.0, GetRadarData(idx, R_POS_X), GetRadarData(idx, R_POS_Y), GetRadarData(idx, R_POS_Z)))
		{
			if(speed > (GetRadarData(idx, R_LIMIT) + 20))
			{
				new fmt_text[35],
					excess;

				excess = floatround(speed) - GetRadarData(idx, R_LIMIT);

				format(fmt_text, sizeof fmt_text, "Превышение скорости на %d км/ч", excess);

				CreateTicket(playerid, excess * 200, "Регистратор скорости", fmt_text);

				GameTextForPlayer(playerid, "~w~ЊPE‹‘ЋE®…E CKOPOC¦…~n~~r~‹‘ OЋ¦PAЃO‹A®‘", 4000, 3);

				SetPVarInt(playerid, "radar_detected", gettime() + 5);

				break;
			}
		}
	}
	return 1;
}*/

stock SendAdvert(playerid, const message[])
{
	new ad_id = g_advert_created;

	if (g_advert_created >= MAX_ADVERTS) return 1;

	SetAdvertData(ad_id, A_CREATOR, 	playerid);
	SetAdvertData(ad_id, A_EDIT, 		false);

	format(g_advert[ad_id][A_TEXT], 128, message);

	g_advert_created ++;

	return 1;
}

stock DeleteAdvert(ad_id)
{
	if(!(0 <= ad_id <= g_advert_created - 1)) return 0;

	SetAdvertData(ad_id, A_CREATOR, 	INVALID_PLAYER_ID);
	SetAdvertData(ad_id, A_EDIT, 		false);

	format(g_advert[ad_id][A_TEXT], 128, "");

	if(ad_id == g_advert_created - 1 && ad_id != 0)
		g_advert_created --;

	return 1;
}

stock UpdateReporterText()
{
	new count,
		fmt_text[15];

	for(new idx = g_advert_created - 1; idx >= 0; idx --)
	{
		if(GetAdvertData(idx, A_EDIT) || GetAdvertData(idx, A_CREATOR) == INVALID_PLAYER_ID) continue;

		count ++;
	}

	format(fmt_text, sizeof fmt_text, "%d~n~Edit", count);

	TextDrawSetString(radio_edit_TD, fmt_text);
}

stock GetAdvertIndexInQueue(ad_id)
{
	new index;

	for(new idx = g_advert_created - 1; idx >= 0; idx --)
	{
		if(GetAdvertData(idx, A_EDIT) || GetAdvertData(idx, A_CREATOR) == INVALID_PLAYER_ID) continue;

		index ++;

		if(idx != ad_id) continue;
	}

	return index;
}

stock SendLog(playerid = INVALID_PLAYER_ID, type, desc[])
{
	new fmt_log[700];

	mysql_format(mysql, fmt_log, sizeof fmt_log, "INSERT INTO action_log (acc_id, uip, type, description, time) VALUES (%d, '%s', %d, '%s', %d)",
	GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), type, desc, gettime());

	mysql_query(mysql, fmt_log, false);

	return 1;
}

stock GetTruckIndex(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 609)
		return 0;

	else if(GetVehicleModel(vehicleid) == 514 || GetVehicleModel(vehicleid) == 584)
		return 1;

	else
		return -1;
}

stock SpectateAttachToTarget(playerid, for_player)
{
    if(!IsPlayerConnected(for_player) || !IsPlayerLogged(for_player)) return 0;

    SetPlayerInterior(playerid, GetPlayerInterior(for_player));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(for_player));

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        TogglePlayerSpectating(playerid, true);
    }

    if(IsPlayerInAnyVehicle(for_player))
    {
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(for_player));
    }
    else
    {
        PlayerSpectatePlayer(playerid, for_player);
    }

    return 1;
}


public: SpectateAttachDelayed(playerid, targetid, actor_session, target_session)
{
    if(actor_session != SRAdmin_Session(playerid) || target_session != SRAdmin_Session(targetid)) return 1;
    if(!SRAdmin_ViewerAuthorized(playerid)) return 1;
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(GetPlayerSpectateData(playerid, S_PLAYER) != targetid) return 1;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return 1;

    printf("[SP][DELAY] admin=%d target=%d state=%d", playerid, targetid, GetPlayerState(playerid));
    SpectateAttachToTarget(playerid, targetid);
    return 1;
}
stock StartSpectateGUIRefresh(playerid)
{
    if(!SRAdmin_ViewerAuthorized(playerid)) return 0;
    if(g_spectate_gui_timer[playerid] != 0)
    {
        KillTimer(g_spectate_gui_timer[playerid]);
        g_spectate_gui_timer[playerid] = 0;
    }

    g_spectate_gui_timer[playerid] = SetTimerEx("SpectateGUIRefresh", 1000, true, "ii", playerid, SRAdmin_Session(playerid));
    return 1;
}

stock StopSpectateGUIRefresh(playerid)
{
    if(g_spectate_gui_timer[playerid] != 0)
    {
        KillTimer(g_spectate_gui_timer[playerid]);
        g_spectate_gui_timer[playerid] = 0;
    }

    return 1;
}

public: SpectateGUIRefresh(playerid, session)
{
    if(session != SRAdmin_Session(playerid)) return 1;
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
    {
        StopSpectateGUIRefresh(playerid);
        return 1;
    }

    new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
    if(targetid == -1)
    {
        StopSpectateGUIRefresh(playerid);
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
    {
        StopSpectateGUIRefresh(playerid);
        return 1;
    }

    if(!SRAdmin_ViewerAuthorized(playerid) || GetPVarInt(playerid, "SRSpecTargetSession") != SRAdmin_Session(targetid) || !Spectate_CanWatchPlayer(playerid, targetid))
    {
        StopSpectate(playerid);
        return 1;
    }

    ShowSpectateGUI(playerid, targetid, true);
    return 1;
}

stock StartSpectate(playerid, for_player)
{
	if(!SRAdmin_TeleportAllowed(playerid)) return 0;
	if(for_player < 0 || for_player >= MAX_PLAYERS || !IsPlayerConnected(for_player) || !IsPlayerLogged(for_player)) return 0;
	if(!Spectate_CanWatchPlayer(playerid, for_player)) return 0;

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, a);
		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));
        SetPVarInt(playerid, "SRSpecStartHouse", GetPlayerInHouse(playerid));
        SetPVarInt(playerid, "SRSpecStartBiz", GetPlayerInBiz(playerid));

		printf("[SP][START-POS] admin=%d pos=%.2f %.2f %.2f int=%d vw=%d", playerid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	}
	else
	{
		printf("[SP][START-POS] keep previous admin=%d pos=%.2f %.2f %.2f int=%d vw=%d", playerid, GetPlayerSpectateData(playerid, S_START_POS_X), GetPlayerSpectateData(playerid, S_START_POS_Y), GetPlayerSpectateData(playerid, S_START_POS_Z), GetPlayerSpectateData(playerid, S_START_INTERIOR), GetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD));
	}

	SetPVarInt(playerid, "sp_gui_ignore_close_until", GetTickCount() + 1200);

	SetPlayerSpectateData(playerid, S_PLAYER, for_player);
    SetPVarInt(playerid, "SRSpecTargetSession", SRAdmin_Session(for_player));
	SpectateAttachToTarget(playerid, for_player);
	SetTimerEx("SpectateAttachDelayed", 80, false, "iiii", playerid, for_player, SRAdmin_Session(playerid), SRAdmin_Session(for_player));

	printf("[SP][START] admin=%d target=%d state=%d", playerid, for_player, GetPlayerState(playerid));
	return 1;
}

stock StopSpectate(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1) return 1;

	new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
	printf("[SP][STOP] admin=%d target=%d state=%d", playerid, targetid, GetPlayerState(playerid));

	TogglePlayerSpectating(playerid, false);

	SetPlayerSpectateData(playerid, S_PLAYER, -1);
	StopSpectateGUIRefresh(playerid);
	DeletePVar(playerid, "sp_gui_ignore_close_until");

	new Float:ret_x = GetPlayerSpectateData(playerid, S_START_POS_X);
	new Float:ret_y = GetPlayerSpectateData(playerid, S_START_POS_Y);
	new Float:ret_z = GetPlayerSpectateData(playerid, S_START_POS_Z);

	if(ret_x != 0.0 || ret_y != 0.0 || ret_z != 0.0)
	{
		SetPlayerPosEx
		(
			playerid,
			ret_x,
			ret_y,
			ret_z,
			GetPlayerSpectateData(playerid, S_START_ANGLE),
			GetPlayerSpectateData(playerid, S_START_INTERIOR),
			GetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD),
            false
		);
	}
	else
	{
		printf("[SP][STOP] skip return-pos admin=%d (zero start pos)", playerid);
	}

    SetPlayerInHouse(playerid, GetPVarInt(playerid, "SRSpecStartHouse"));
    SetPlayerInBiz(playerid, GetPVarInt(playerid, "SRSpecStartBiz"));
    DeletePVar(playerid, "SRSpecStartHouse");
    DeletePVar(playerid, "SRSpecStartBiz");
    DeletePVar(playerid, "SRSpecTargetSession");
    TogglePlayerControllable(playerid, true);
    SetCameraBehindPlayer(playerid);
    Spectate_RestoreSkin(playerid);
    HidePlayerGUI(playerid, 66);

	return 1;
}

stock UpdateSpectate(playerid, disconnect)
{
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(GetPlayerAdminEx(i) < 1 && GetPlayerYouTubeEx(i) < 1) continue;
		else if(GetPlayerSpectateData(i, S_PLAYER) != playerid) continue;

		if(disconnect)
		{
			StopSpectate(i);
			GameTextForPlayer(i, "~r~~h~player disconnect", 4000, 4);
		}
		else
		{
			SpectateAttachToTarget(i, playerid);
			if(g_spectate_gui_timer[i] != 0)
			{
				ShowSpectateGUI(i, playerid, true);
			}
		}
	}
	return 1;
}

new const
	weapon_names[47][30] =
{
	"Пусто",
	"Кастет",
	"Клюшка для гольфа",
	"Дубинка",
	"Нож",
	"Бита",
	"Лопата",
	"Кий",
	"Катана",
	"Бензопила",
	"Фиолетовый дилдо",
	"Дилдо",
	"Вибратор",
	"Серебряный вибратор",
	"Цветы",
	"Топор",
	"Граната",
	"Дымовая граната",
	"Коктейль молотова",
	"Пусто",
	"Пусто",
	"Пусто",
	"Пистолет",
	"Пистолет с глушителем",
	"Пустынный орёл",
	"Дробовик",
	"Обрез",
	"Тактический дробовик",
	"Micro-Uzi",
	"MP5",
	"AK-47",
	"M4",
	"TEC-9",
	"Винтовка",
	"Снайперская винтовка",
	"РПГ",
	"Самонаводящаяся установка",
	"Огнемет",
	"Миниган",
	"C4",
	"Кнопка детонатора",
	"Баллончик",
	"Огнетушитель",
	"Фотоаппарат",
	"Очки ночного видения",
	"Очки с тепловизором",
	"Парашют"
};

new const
	weapon_dialog_tabulation[47][7] =
{
	"\t\t\t",
	"\t\t\t",
	"\t",
	"\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t",
	"\t",
	"\t\t\t",
	"\t\t",
	"\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t",
	"\t",
	"\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t",
	"\t",
	"\t",
	"\t\t",
	"\t\t\t",
	"\t",
	"\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t\t",
	"\t\t",
	"\t",
	"\t\t\t",
	"\t",
	"\t\t",
	"\t\t",
	"\t\t\t",
	"\t",
	"\t\t",
	"\t\t",
	"\t\t",
	"\t",
	"\t",
	"\t\t"
};

// ---------------------------------------------------------------
new const
	skill_name[12][16] =
{
	"Сила",
	"Colt 45",
	"SD Pistol",
	"Desert Eagle",
	"Shotgun",
	"MP5",
	"AK47",
	"M4",
	"Sniper Rifle",
	"Sawnoff",
	"Combat SG",
	"Micro Uzi"
};

// ---------------------------------------------------------------
enum
{
	LOG_TYPE_ADMIN_CHAT = 1,

	LOG_TYPE_ADMIN_ANSWER,
	LOG_TYPE_ADMIN_ACTION,
	LOG_TYPE_SET_ADMIN,
	LOG_TYPE_SET_LEADER,
	LOG_TYPE_SMS_CHAT,
	LOG_TYPE_OOC_CHAT,
	LOG_TYPE_REPORT,
	LOG_TYPE_FRACTION,
	LOG_TYPE_SUPERADMIN_ACTION
}


// /giveacs filter: every model that is sold through the donate accessory mapping is hidden.
stock bool:AccessoryIsDonateModel(modelid)
{
    for(new i = 0; i < sizeof(AccessoryMapping); i++)
    {
        if(AccessoryMapping[i][2] == modelid) return true;
    }
    return false;
}

// Таблица accessory[] - общий каталог предметов (материалы, рыба, инструкции, расходники и т.д.),
// а не только аксессуаров. Индекс в ней = acs_id в БД, поэтому он стабилен. Ниже диапазоны индексов,
// которые НЕ являются надеваемыми аксессуарами - в /giveacs они не показываются и не выдаются.
new const g_giveacs_hidden_ranges[][2] =
{
    {20, 28},       // канистра, аптечка, ремонтный комплект, мясо, шкуры, набор для костра
    {57, 58},       // SIM-карта, номерной знак
    {65, 66},       // лекарство, конфеты
    {79, 82},       // динамит, номерные знаки
    {116, 122},     // бустер, наушники, колонка, магнитофон, монета, шашка, отвертка
    {124, 132},     // заточка, самогон, вода, сгущенка, шоколад, напильник, сахар, карты, ключ
    {161, 161},     // деньги
    {344, 345},     // бомба, документы
    {461, 461},     // адреналин
    {476, 488},     // удочка, вазы, чашки, компас, будильник, запчасти
    {612, 645},     // рыба, удочки, наживка
    {759, 875},     // материалы и инструкции крафта
    {892, 910},     // инструкции и детали лодок/транспорта
    {992, 992},     // камера ЦОДД
    {1005, 1011},   // радар, улика, путевой лист, ордера, инструкции
    {1034, 1037},   // билет, инструкции, осколки
    {1058, 1060},   // инструкции, праздничная энергия
    {1069, 1071}    // инструкции, синяя сталь
};

// true - запись каталога является надеваемым аксессуаром
stock bool:AccessoryIsGiveable(acs)
{
    if(acs < 0 || acs >= sizeof(accessory)) return false;
    if(accessory[acs][ID_ACCESSORY] <= 0) return false;
    if(accessory[acs][BONE_ACCESSORY] <= 0) return false;

    // служебные модели-заглушки (инструкции/осколки)
    if(accessory[acs][ID_ACCESSORY] == 9973 || accessory[acs][ID_ACCESSORY] == 9974) return false;

    for(new r = 0; r < sizeof(g_giveacs_hidden_ranges); r++)
    {
        if(acs >= g_giveacs_hidden_ranges[r][0] && acs <= g_giveacs_hidden_ranges[r][1]) return false;
    }
    return true;
}

stock AccessoryGetNonDonateCount()
{
    new count = 0;
    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(!AccessoryIsGiveable(i)) continue;
        count++;
    }
    return count;
}

stock AccessoryGetNonDonateIndexByOrdinal(ordinal)
{
    if(ordinal < 0) return -1;

    new current = 0;
    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(!AccessoryIsGiveable(i)) continue;
        if(current == ordinal) return i;
        current++;
    }
    return -1;
}

stock ShowAdminGiveAcsDialog(playerid, page)
{
    const items_per_page = 30;
    new total = AccessoryGetNonDonateCount();

    if(total <= 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Нет доступных аксессуаров для выдачи.");

    new max_page = (total - 1) / items_per_page;
    if(page < 0) page = 0;
    if(page > max_page) page = max_page;
    gGiveAcsDialogPage[playerid] = page;

    new text[4096];
    text[0] = '\0';

    new start = page * items_per_page;
    new end = start + items_per_page;
    if(end > total) end = total;

    for(new ordinal = start; ordinal < end; ordinal++)
    {
        new acs = AccessoryGetNonDonateIndexByOrdinal(ordinal);
        if(acs < 0) continue;

        new acs_row[112];
        format(acs_row, sizeof acs_row, "[%d] %s\n", accessory[acs][ID_ACCESSORY], accessory[acs][NAME_ACCESSORY]);
        strcat(text, acs_row);
    }

    if(page > 0) strcat(text, "{AAAAAA}<< Предыдущая страница\n");
    if(page < max_page) strcat(text, "{AAAAAA}Следующая страница >>\n");

    new title[112];
    new target = gGiveAcsTarget[playerid];
    if(IsPlayerConnected(target))
        format(title, sizeof title, "{FFCD00}Выдать аксессуар: %s (%d/%d)", GetPlayerNameEx(target), page + 1, max_page + 1);
    else
        format(title, sizeof title, "{FFCD00}Выдать аксессуар (%d/%d)", page + 1, max_page + 1);

    ShowPlayerDialog(playerid, DIALOG_ADMIN_GIVEACS_LIST, DIALOG_STYLE_LIST, title, text, "Выдать", "Закрыть");
    return 1;
}

stock AdminGiveAccessoryEnsureStorage()
{
    new Cache:storage_result = mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS admin_given_accessories (player_id INT NOT NULL, command_slot TINYINT NOT NULL, physical_slot TINYINT NOT NULL, acs_id INT NOT NULL, PRIMARY KEY (player_id, command_slot), UNIQUE KEY uq_admin_acs_physical (player_id, physical_slot)) ENGINE=InnoDB DEFAULT CHARSET=utf8",
        true);
    cache_delete(storage_result);
    return 1;
}

// /giveacs has three logical slots. They are mapped to GTA attached-object slots
// 7..9 and tracked separately, so inventory accessories in slots 1..4 are untouched.
stock AdminGiveAccessoryFindFreeSlot(targetid)
{
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return -2;
    AdminGiveAccessoryEnsureStorage();

    // Записи admin_given_accessories без соответствующего аксессуара в accessories_players
    // ("осиротевшие" - например аксессуар был перенесён/удалён другой системой) блокировали выдачу:
    // command_slot уже занят в таблице -> INSERT падал с "не удалось сохранить командный слот".
    new cleanup_query[256];
    mysql_format(mysql, cleanup_query, sizeof cleanup_query,
        "DELETE FROM admin_given_accessories WHERE player_id=%d AND physical_slot NOT IN (SELECT slot FROM accessories_players WHERE player_id=%d)",
        GetPlayerAccountID(targetid), GetPlayerAccountID(targetid));
    mysql_query(mysql, cleanup_query, false);

    new bool:used[10];
    for(new physical_slot = 7; physical_slot <= 9; physical_slot++)
        if(IsPlayerAttachedObjectSlotUsed(targetid, physical_slot)) used[physical_slot] = true;

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "SELECT slot FROM accessories_players WHERE player_id=%d AND slot BETWEEN 7 AND 9",
        GetPlayerAccountID(targetid));
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno()) { cache_delete(result); return -2; }
    for(new row_idx = 0; row_idx < cache_num_rows(); row_idx++)
    {
        new physical_slot = cache_get_field_content_int(row_idx, "slot");
        if(physical_slot >= 7 && physical_slot <= 9) used[physical_slot] = true;
    }
    cache_delete(result);

    for(new physical_slot = 7; physical_slot <= 9; physical_slot++)
        if(!used[physical_slot]) return physical_slot;
    return -1;
}

stock AdminGiveAccessoryAndOfferEdit(adminid, targetid, acs)
{
    if(!(0 <= acs < sizeof(accessory))) return 0;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return 0;
    if(!AccessoryIsGiveable(acs)) return 0;

    new physical_slot = AdminGiveAccessoryFindFreeSlot(targetid);
    if(physical_slot == -2)
        return SendClientMessage(adminid, 0xFF6666FF, "Не удалось проверить отдельные слоты /giveacs.");
    if(physical_slot == -1)
        return SendClientMessage(adminid, 0xFFCC66FF, "Все 3 отдельных слота /giveacs заняты. Используйте /delacs [1-3].");

    new command_slot = physical_slot - 6;
    new modelid = accessory[acs][ID_ACCESSORY], bone = accessory[acs][BONE_ACCESSORY];
    new Float:x = 0.01, Float:y = 0.01, Float:z = 0.01;
    new Float:rX = 0.01, Float:rY = 0.01, Float:rZ = 0.01, Float:scale = 1.01;
    new query[320];

    mysql_format(mysql, query, sizeof query,
        "INSERT INTO accessories_players (player_id,slot,bone,acs_id,x,y,z,rX,rY,rZ,scale) VALUES (%d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f)",
        GetPlayerAccountID(targetid), physical_slot, bone, acs, x, y, z, rX, rY, rZ, scale);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        new err = mysql_errno();
        cache_delete(result);
        printf("[GIVEACS][ERROR] active insert admin=%d target=%d slot=%d acs=%d errno=%d", adminid, targetid, physical_slot, acs, err);
        return SendClientMessage(adminid, 0xFF6666FF, "Аксессуар не выдан: ошибка базы данных.");
    }
    cache_delete(result);

    mysql_format(mysql, query, sizeof query,
        "REPLACE INTO admin_given_accessories (player_id,command_slot,physical_slot,acs_id) VALUES (%d,%d,%d,%d)",
        GetPlayerAccountID(targetid), command_slot, physical_slot, acs);
    result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[GIVEACS][ERROR] admin_given_accessories insert admin=%d target=%d command_slot=%d physical=%d acs=%d errno=%d", adminid, targetid, command_slot, physical_slot, acs, mysql_errno());
        cache_delete(result);
        mysql_format(mysql, query, sizeof query,
            "DELETE FROM accessories_players WHERE player_id=%d AND slot=%d",
            GetPlayerAccountID(targetid), physical_slot);
        mysql_query(mysql, query, false);
        return SendClientMessage(adminid, 0xFF6666FF, "Аксессуар не выдан: не удалось сохранить командный слот.");
    }
    cache_delete(result);

    SetPlayerAttachedObject(targetid, physical_slot, modelid, bone, x, y, z, rX, rY, rZ, scale, scale, scale);
    AccessorySyncTempData(targetid, physical_slot, modelid, bone, x, y, z, rX, rY, rZ, scale);
    gGiveAcsPendingDatabase[targetid] = -physical_slot;

    new msg[256];
    format(msg, sizeof msg,
        "Вы получили командный аксессуар {FFFF00}%s{FFFFFF}. Слот /giveacs: {FFCD00}%d{FFFFFF}. Удалить: {FFFF00}/delacs %d",
        accessory[acs][NAME_ACCESSORY], command_slot, command_slot);
    SendClientMessage(targetid, 0xFFFFFFFF, msg);
    if(adminid != targetid)
    {
        format(msg, sizeof msg, "Вы выдали %s[%d] аксессуар %s в отдельный слот %d.",
            GetPlayerNameEx(targetid), targetid, accessory[acs][NAME_ACCESSORY], command_slot);
        SendClientMessage(adminid, 0x66CC66FF, msg);
    }

    format(msg, sizeof msg, "Аксессуар {FFFF00}%s{FFFFFF} установлен в отдельный слот {FFCD00}%d{FFFFFF}. Изменить положение?",
        accessory[acs][NAME_ACCESSORY], command_slot);
    ShowPlayerDialog(targetid, DIALOG_ADMIN_GIVEACS_EDIT_OFFER, DIALOG_STYLE_MSGBOX,
        "{FFCD00}Настройка аксессуара", msg, "Изменить", "Позже");

    format(msg, sizeof msg, "Выдал %s[acc:%d] командный аксессуар %s [acs:%d model:%d command_slot:%d physical:%d]",
        GetPlayerNameEx(targetid), GetPlayerAccountID(targetid), accessory[acs][NAME_ACCESSORY], acs, modelid, command_slot, physical_slot);
    SendLog(adminid, LOG_TYPE_SUPERADMIN_ACTION, msg);
    return 1;
}
// ---------------------------------------------------------------
new
	g_donate_prices[] =
{
	2000, 8, 65, 1, 4, 249, 1, 299, 99, 100, 400, 49, 49, 299, 250, 55, 300, 88, 400, 100, 400, 600, 800, 30000
}; // цены на товары в меню Дополнительно

