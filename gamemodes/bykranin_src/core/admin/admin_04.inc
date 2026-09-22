//>> Файл: bykranin_src/core/admin/admin_04.inc  (683 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: /medbed, /out, /heal, /changesex, /cuff, /uncuff, StopPoliceFollow
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:medbed(playerid, params[])
{
    #pragma unused params
    return MedBed_TryOccupy(playerid);
}

CMD:out(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "Вы не медицинский работник");
	if(!Hospital_IsPlayerInsideCB(playerid) && !IsPlayerInRangeOfPoint(playerid, 99.0, 2038.0170,1419.8960,999.1563)) return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в больнице");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /out [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
	if(GetPlayerData(to_player, P_OCCUPIED_BED) == -1) return SendClientMessage(playerid, 0x999999FF, "Игрок должен находиться на лечении");

	ClearMedBed(to_player, GetPlayerData(to_player, P_OCCUPIED_BED));
	SetPlayerData(to_player, P_HOSPITAL, false);

	SetPlayerChatBubble(to_player, "Выписан", 0x66CC00FF, 10.0, 2000);

	new fmt_msg[60];
	format(fmt_msg, sizeof fmt_msg, "Медицинский работник %s выписал Вас из больницы", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выписали %s из больницы", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
	return 1;
}

CMD:heal(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "Вы не медицинский работник");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Использование: /heal [id игрока] [цена за лечение]");
	extract params -> new to_player, price;

	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_MED_CAR || GetPlayerVehicleID(to_player) != vehicleid) return SendClientMessage(playerid, 0x999999FF, "Вы или Ваш пациент находитесь не в машине скорой помощи");
	if(!(0 <= price <= 5000)) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость лечения должна быть от 0 до 5000 рублей");
	if(GetPlayerMoneyEx(to_player) < price) return SendClientMessage(playerid, 0x999999FF, "У пациента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_HEAL, price);
	return 1;
}

CMD:changesex(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "Вы не медицинский работник");
	if(!Hospital_IsPlayerInsideCB(playerid) && !IsPlayerInRangeOfPoint(playerid, 99.0, 2038.0170,1419.8960,999.1563)) return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в больнице");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Использование: /changesex [id игрока] [стоимость операции]");
	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
	if(GetPlayerData(to_player, P_OCCUPIED_BED) == -1) return SendClientMessage(playerid, 0xCECECEFF, "Игрок должен находиться на стационарном лечении");
	if(!(500000 <= price <= 1000000)) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость операции должна быть от 500000 до 1000000 рублей");
	if(GetPlayerMoneyEx(to_player) < price) return SendClientMessage(playerid, 0x999999FF, "У пациента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_CHANGE_SEX, price);
	return 1;
}

CMD:cuff(playerid, params[])
{
    if(!IsPlayerInPoliceTeam(playerid)) 
        return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

    new to_player;
    if(sscanf(params, "u", to_player)) 
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /cuff [id игрока]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) 
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
    if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) 
        return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

    if(GetPlayerData(to_player, P_CUFFED)) 
        return SendClientMessage(playerid, 0x999999FF, "Игрок уже закован в наручники");

    SetPlayerSpecialAction(to_player, SPECIAL_ACTION_CUFFED);
    SetPlayerData(to_player, P_CUFFED, true);
    TogglePlayerControllable(to_player, 0); // Freeze the player

    new fmt_str[90];
    format(fmt_str, sizeof fmt_str, "%s %s надел на %s наручники и заморозил персонажа", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
    SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

    return 1;
}

CMD:uncuff(playerid, params[])
{
    if(!IsPlayerInPoliceTeam(playerid) && GetPlayerAdminEx(playerid) == 0) 
        return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

    new to_player;
    if(sscanf(params, "u", to_player)) 
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /uncuff [id игрока]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
    if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) 
        return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

    if(!GetPlayerData(to_player, P_CUFFED)) 
        return SendClientMessage(playerid, 0x999999FF, "Игрок не закован в наручники");

    SetPlayerSpecialAction(to_player, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND);
    SetPlayerData(to_player, P_CUFFED, false);
    TogglePlayerControllable(to_player, 1); // Unfreeze the player

    new fmt_str[90];
    format(fmt_str, sizeof fmt_str, "%s %s снял с %s наручники и разморозил персонажа", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
    SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

    return 1;
}

stock StopPoliceFollow(playerid)
{
	new to_player = GetPVarInt(playerid, "police_follow_target") - 1;
	DeletePVar(playerid, "police_follow_target");
	if(0 <= to_player < MAX_PLAYERS && IsPlayerConnected(to_player))
	{
		if(GetPVarInt(to_player, "police_followed_by") == playerid + 1)
			DeletePVar(to_player, "police_followed_by");
		if(GetPlayerData(to_player, P_CUFFED) && !IsPlayerInAnyVehicle(to_player))
			TogglePlayerControllable(to_player, false);
	}
	return 1;
}

forward PoliceFollowUpdate(playerid, to_player);
public PoliceFollowUpdate(playerid, to_player)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(to_player) ||
		GetPVarInt(playerid, "police_follow_target") != to_player + 1 ||
		GetPVarInt(to_player, "police_followed_by") != playerid + 1 ||
		!GetPlayerData(to_player, P_CUFFED))
	{
		if(IsPlayerConnected(playerid)) StopPoliceFollow(playerid);
		return 0;
	}

	if(GetPlayerInterior(playerid) != GetPlayerInterior(to_player) ||
		GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(to_player) ||
		!IsPlayerInRangeOfPlayer(playerid, to_player, 25.0) ||
		IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(to_player))
	{
		StopPoliceFollow(playerid);
		SendClientMessage(playerid, 0xCECECEFF, "Конвоирование прекращено");
		return 0;
	}

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 1.8))
	{
		new Float:x, Float:y, Float:z, Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		SetPlayerPos(to_player, x - floatsin(-angle, degrees) * 1.1, y - floatcos(-angle, degrees) * 1.1, z);
		SetPlayerFacingAngle(to_player, angle);
	}
	SetTimerEx("PoliceFollowUpdate", 250, false, "ii", playerid, to_player);
	return 1;
}

CMD:follow(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	new current = GetPVarInt(playerid, "police_follow_target") - 1;
	new to_player;
	if(sscanf(params, "u", to_player))
	{
		if(current != -1)
		{
			StopPoliceFollow(playerid);
			return SendClientMessage(playerid, 0x66CC00FF, "Вы прекратили вести задержанного");
		}
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /follow [id игрока]");
	}
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(current == to_player)
	{
		StopPoliceFollow(playerid);
		return SendClientMessage(playerid, 0x66CC00FF, "Вы прекратили вести задержанного");
	}
	if(current != -1) return SendClientMessage(playerid, 0xCECECEFF, "Сначала прекратите текущее конвоирование командой /follow");
	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не закован в наручники");
	if(GetPVarInt(to_player, "police_followed_by")) return SendClientMessage(playerid, 0xCECECEFF, "Этого игрока уже ведёт другой сотрудник");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0) || GetPlayerInterior(playerid) != GetPlayerInterior(to_player) || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");
	if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Для конвоирования выйдите из транспорта");

	SetPVarInt(playerid, "police_follow_target", to_player + 1);
	SetPVarInt(to_player, "police_followed_by", playerid + 1);
	TogglePlayerControllable(to_player, false);
	SetTimerEx("PoliceFollowUpdate", 250, false, "ii", playerid, to_player);
	SendClientMessage(playerid, 0x66CC00FF, "Вы начали вести задержанного. Повторите /follow, чтобы отпустить");
	SendClientMessage(to_player, 0xFFFF00FF, "Сотрудник полиции ведёт Вас за собой");
	return 1;
}
CMD:putpl(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /putpl [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0x999999FF, "Игрок не закован в наручники");

	new vehicle_id = GetPlayerVehicleID(playerid);
	if(!vehicle_id) return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в автомобиле");

	if(!IsPlayerInPoliceCar(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в служебном транспорте");

	new bool: is_there_some_free_places;

	for(new i = 1; i < 4; i++)
	{
		if(IsVehicleSeatOccupied(vehicle_id, i)) continue;
		PutPlayerInVehicle(to_player, vehicle_id, i);
		if(!IsPlayerInVehicle(to_player, vehicle_id)) continue;
		new follower = GetPVarInt(to_player, "police_followed_by") - 1;
		if(follower != -1) StopPoliceFollow(follower);
		is_there_some_free_places = true;
		break;
	}

	if(!is_there_some_free_places) return SendClientMessage(playerid, 0x999999FF, "В автомобиле нет свободных пассажирских мест");

	new fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s посадил %s в машину", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

CMD:search(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /search [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	new fmt_text[110],
		bool: some_is_found;

	format(fmt_text, sizeof fmt_text, "%s %s произвёл обыск у %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_text, 0xDD90FFFF, 25.0);

	if(GetPlayerData(to_player, P_DRUGS))
	{
		format(fmt_text, sizeof fmt_text, "У %s[%d] обнаружено %d г наркотиков", GetPlayerData(to_player, P_DRUGS));
		SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

		some_is_found = true;
	}
	if(GetPlayerData(to_player, P_AMMO))
	{
		format(fmt_text, sizeof fmt_text, "У %s[%d] обнаружено %d патронов", GetPlayerData(to_player, P_AMMO));
		SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

		some_is_found = true;
	}

	if(!some_is_found) SendClientMessage(playerid, 0xFFFF00FF, "Ничего не найдено");

	return 1;
}

CMD:su(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	extract params -> new criminalid, string:message[66]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /su [id игрока] [причина]");

	if(!IsPlayerConnected(criminalid) || !IsPlayerLogged(criminalid) || criminalid == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, criminalid, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	if(!strlen(message)) return SendClientMessage(playerid, 0x999999FF, "Введите причину");

	if(GetPlayerSuspect(criminalid) >= 6) return SendClientMessage(playerid, 0x999999FF, "Игрок имеет максимальный уровень розыска");

	new fmt_text[255];

	AddPlayerData(criminalid, P_SUSPECT, +, 1);
	SetPlayerSuspectInit(criminalid);
	UpdatePlayerDatabaseInt(criminalid, "suspect", GetPlayerData(criminalid, P_SUSPECT));

	format(fmt_text, sizeof fmt_text, "%s объявил Вас в розыск. Причина: %s. Текущий уровень розыска %d", GetPlayerNameEx(playerid), message, GetPlayerSuspect(criminalid));
	SendClientMessage(criminalid, 0x3399FFFF, fmt_text);
	format(fmt_text, sizeof fmt_text, "Вы объявили %s в розыск. Причина: %s. Текущий уровень розыска %d", GetPlayerNameEx(criminalid), message, GetPlayerSuspect(criminalid));
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] объявил %s[%d] в розыск [%d/6], причина: %s", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(criminalid), criminalid, GetPlayerSuspect(criminalid), message);

	SendMessageToPoliceTeam(fmt_text, 0xFFC000FF, playerid);
	
	AddPlayerData(playerid, P_PROGRESS_EXP_3, +, 1);
	UpdatePlayerDatabaseInt(playerid, "ProgressExp3", GetPlayerData(playerid, P_PROGRESS_EXP_3));

	if(GetPlayerData(playerid, P_PROGRESS_EXP_3) == 500)
	{
	    SendClientMessage(playerid, COR_QUEST, "[Достижения]: "c_b"Вы успешно выполнили достижение "c_i"'Полиция №2'. "c_b"Награда: "c_s"100 DONATE-RUB");
	    GivePlayerDonateRub(playerid, 100, "Выполнение достижения / фракция");

	    SetPlayerData(playerid, P_PROGRESS_3, 1);
	    UpdatePlayerDatabaseInt(playerid, "Progress3", 1);
	    
	    AddPlayerData(playerid, P_TOP_4, +, 1);
		UpdatePlayerDatabaseInt(playerid, "TOP_Progress", GetPlayerData(playerid, P_TOP_4));
	}

	return 1;
}

CMD:clear(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	extract params -> new criminalid; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /clear [id игрока]");

	if(!IsPlayerConnected(criminalid) || !IsPlayerLogged(criminalid) || criminalid == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!GetPlayerSuspect(criminalid)) return SendClientMessage(playerid, 0x999999FF, "Игрок не имеет розыска");

	new fmt_text[255];

	SetPlayerData(criminalid, P_SUSPECT, 0);
	SetPlayerSuspectInit(criminalid);
	UpdatePlayerDatabaseInt(criminalid, "suspect", 0);

	format(fmt_text, sizeof fmt_text, "%s удалил Вас из базы разыскиваемых", GetPlayerNameEx(playerid));
	SendClientMessage(criminalid, 0x3399FFFF, fmt_text);
	format(fmt_text, sizeof fmt_text, "Вы удалили %s из базы разыскиваемых", GetPlayerNameEx(criminalid));
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] удалил %s[%d] из базы разыскиваемых людей", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(criminalid), criminalid);

	SendMessageToPoliceTeam(fmt_text, 0xFFC000FF, playerid);

	return 1;
}



CMD:m(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /m [текст]");

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "<< %s %s[%d]: %s >>", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_text, 0xFFFF00FF, 60.0);

	return 1;
}

CMD:takelic(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_DPS) return SendClientMessage(playerid, 0x999999FF, "Вы не работник ГИБДД");

	extract params -> new to_player, string:message[66]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /takelic [id игрока] [причина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	if(!strlen(message)) return SendClientMessage(playerid, 0x999999FF, "Введите причину");

	if(!GetPlayerData(to_player, P_DRIVING_LIC)) return SendClientMessage(playerid, 0x999999FF, "У игрока нет прав");

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "%s[%d] забрал у Вас права. Причина: %s", GetPlayerNameEx(playerid), playerid, message);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);
	format(fmt_text, sizeof fmt_text, "Вы забрали у %s[%d] права. Причина: %s", GetPlayerNameEx(to_player), to_player, message);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] забрал у %s[%d] %s права, причина: %s", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "проф." : "базовые", message);

	SendMessageToPoliceTeam(fmt_text, 0xFFC000FF, playerid);

	SetPlayerData(to_player, P_DRIVING_LIC, 0);
	UpdatePlayerDatabaseInt(to_player, "driving_lic", 0);

	return 1;
}

CMD:wanted(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	new fmt_text[40],
		fmt_list[1024] = "Розыск\tИмя{FFFFFF}\n";

	foreach(new i : Player)
	{
		if(!GetPlayerSuspect(i)) continue;
		format(fmt_text, sizeof fmt_text, "\n%d\t\t%s", GetPlayerSuspect(i), GetPlayerNameEx(i));
		strcat(fmt_list, fmt_text);
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{ffcd00}Список разыскиваемых", fmt_list, "Закрыть", "");

	return 1;
}

CMD:setmark(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setmark [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!GetPlayerSuspect(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не в розыске");

	new Float: x,
		Float: y,
		Float: z;

	GetPlayerPos(to_player, x, y, z);

	EnablePlayerGPS(playerid, 37, x, y, z, "{66cc33}В последний раз преступника видели на отмеченном месте");

	return 1;
}

CMD:ticket(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_DPS) return SendClientMessage(playerid, 0x999999FF, "Вы не работник ГИБДД");

	extract params -> new to_player, amount, string:message[64]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ticket [id игрока] [сумма штрафа] [причина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	if(!(1 <= amount <= 50_000)) return SendClientMessage(playerid, 0x999999FF, "Сумма штрафа может быть от 1 до 50.000 рублей");

	if(!strlen(message)) return SendClientMessage(playerid, 0x999999FF, "Введите причину");

	CreateTicket(to_player, amount, GetPlayerNameEx(playerid), message);

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "%s[%d] выписал Вам штраф в размере %d руб. Причина: %s", GetPlayerNameEx(playerid), playerid, amount, message);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выписали %s[%d] штраф в размере %d руб. Причина: %s", GetPlayerNameEx(to_player), to_player, amount, message);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] выписал %s[%d] штраф (%d руб), причина: %s", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, amount, message);

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0xFFC000FF, playerid);

	new Cache: result,
		id;

	result = mysql_query(mysql, "SELECT id FROM tickets ORDER BY id DESC LIMIT 1", true);

	id = cache_get_row_int(0, 0);

	cache_delete(result);

	new day, month, year;

	getdate(year, month, day);

	format(fmt_text, sizeof fmt_text, "Номер штрафа: #%d | Дата: %02d-%02d-%d", id, day, month, year);
	SendClientMessage(playerid, 0xFFCD00FF, fmt_text);
	
	AddPlayerData(playerid, P_PROGRESS_EXP_2, +, 1);
	UpdatePlayerDatabaseInt(playerid, "ProgressExp2", GetPlayerData(playerid, P_PROGRESS_EXP_2));

	if(GetPlayerData(playerid, P_PROGRESS_EXP_2) == 500)
	{
	    SendClientMessage(playerid, COR_QUEST, "[Достижения]: "c_b"Вы успешно выполнили достижение "c_i"'Полиция №1'. "c_b"Награда: "c_s"100 DONATE-RUB");
	    GivePlayerDonateRub(playerid, 100, "Выполнение достижения / фракция");

	    SetPlayerData(playerid, P_PROGRESS_2, 1);
	    UpdatePlayerDatabaseInt(playerid, "Progress2", 1);
	    
	    AddPlayerData(playerid, P_TOP_4, +, 1);
		UpdatePlayerDatabaseInt(playerid, "TOP_Progress", GetPlayerData(playerid, P_TOP_4));
	}

	return 1;
}

CMD:delticket(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_DPS) return SendClientMessage(playerid, 0x999999FF, "Вы не сотрудник ГИБДД");

	extract params -> new ticket_id; else return SendClientMessage(playerid, 0xCECECEFF, "/delticket [номер штрафа]");

	new query[144],
		Cache: result,
		rows,
		uid,
		reason[64],
		player_name[21],
		status,
		amount;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE id=%d", ticket_id);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	uid = cache_get_field_content_int(0, "uid");
	status = cache_get_field_content_int(0, "status");
	amount = cache_get_field_content_int(0, "amount");

	cache_get_field_content(0, "description", reason);

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT name FROM accounts WHERE id=%d", uid);
	result = mysql_query(mysql, query, true);

	cache_get_row(0, 0, player_name);

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "Штраф с таким номером не найден");

	if(status) return SendClientMessage(playerid, 0x999999FF, "Вы не можете удалить уже оплаченный штраф");

	mysql_format(mysql, query, sizeof query, "DELETE FROM tickets WHERE id=%d", ticket_id);
	mysql_query(mysql, query, false);

	format(query, sizeof query, "Вы удалили штраф #%d из базы данных ГИБДД", ticket_id);
	SendClientMessage(playerid, 0x66CC33FF, query);

	format(query, sizeof query, "%s %s[%d] удалил штраф #%d (%s,%s,%d руб) из базы данных ГИБДД", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, ticket_id, player_name, reason, amount);

	SendMessageToTeam(GetPlayerTeamEx(playerid), query, 0xFFC000FF, playerid);

	return 1;
}

CMD:tickets(playerid, params[])
{
	new query[128],
		Cache: result,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE uid=%d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	SendClientMessage(playerid, 0x66CC33FF, "Список штрафов:");

	if(!rows)
		SendClientMessage(playerid, 0xFFCD00FF, "Штрафы отсутствуют");

	else
	{
		new paid_tickets;

		for(new idx; idx < rows; idx ++)
		{
			new id = cache_get_field_content_int(idx, "id"),
				amount = cache_get_field_content_int(idx, "amount"),
				status = cache_get_field_content_int(idx, "status"),
				desc[64],
				issuer[32];

			cache_get_field_content(idx, "description", desc);
			cache_get_field_content(idx, "issuer", issuer);

			format(query, sizeof query, "#%d | %d руб | %s | Выдал: %s | %s", id, amount, desc, issuer, status ? "{66CC33}Оплачен" : "{FF5533}Не оплачен");
			SendClientMessage(playerid, 0xFFCD00FF, query);

			if(status) paid_tickets ++;
		}

		format(query, sizeof query, "Общее количество штрафов: %d | Оплачены: %d | Не оплачены: %d", rows, paid_tickets, rows-paid_tickets);
		SendClientMessage(playerid, 0x66CC33FF, query);
	}

	cache_delete(result);

	return 1;
}

CMD:ptickets(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_DPS) return SendClientMessage(playerid, 0x999999FF, "Вы не работник ГИБДД");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ptickets [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	new query[128],
		Cache: result,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE uid=%d", GetPlayerAccountID(to_player));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	SendClientMessage(playerid, 0x66CC33FF, "Список штрафов:");

	if(!rows)
		SendClientMessage(playerid, 0xFFCD00FF, "Штрафы отсутствуют");

	else
	{
		new paid_tickets;

		for(new idx; idx < rows; idx ++)
		{
			new id = cache_get_field_content_int(idx, "id"),
				amount = cache_get_field_content_int(idx, "amount"),
				status = cache_get_field_content_int(idx, "status"),
				desc[64],
				issuer[32];

			cache_get_field_content(idx, "description", desc);
			cache_get_field_content(idx, "issuer", issuer);

			format(query, sizeof query, "#%d | %d руб | %s | Выдал: %s | %s", id, amount, desc, issuer, status ? "{66CC33}Оплачен" : "{FF5533}Не оплачен");
			SendClientMessage(playerid, 0xFFCD00FF, query);

			if(status) paid_tickets ++;
		}

		format(query, sizeof query, "Общее количество штрафов: %d | Оплачены: %d | Не оплачены: %d", rows, paid_tickets, rows-paid_tickets);
		SendClientMessage(playerid, 0x66CC33FF, query);
	}

	cache_delete(result);

	return 1;
}

/*CMD:radar(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_DPS) return SendClientMessage(playerid, 0x999999FF, "Вы не работник ГИБДД");

	Dialog
	(
		playerid, DIALOG_RADAR_SELECT, DIALOG_STYLE_LIST,
		"{FFCD00}Установка регистратора скорости",
		"1. Дворовые территории (20 км/ч)\n"\
		"2. Населенные пункты (60 км/ч)\n"\
		"3. Вне населенных пунктов (90 км/ч)\n"\
		"4. Автомагистрали (110 км/ч)\n"\
		"{888888}5. Удалить регистратор скорости",
		"Выбор", "Отмена"
	);

	return 1;
}*/

