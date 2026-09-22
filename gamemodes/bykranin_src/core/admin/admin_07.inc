//>> Файл: bykranin_src/core/admin/admin_07.inc  (599 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: StopVehicleStroboscope, /strob, function_strobocop, /notif, /base, /med, /cheat
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
new bool:status_strobocop[MAX_VEHICLES];
new count_strobrscop[MAX_VEHICLES];
new strobocop_original_lights[MAX_VEHICLES];

stock StopVehicleStroboscope(vehicleid, bool:restore_lights = true)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;

    if(status_strobocop[vehicleid])
    {
        KillTimer(timer_strobocop[vehicleid]);
        status_strobocop[vehicleid] = false;
    }

    timer_strobocop[vehicleid] = -1;
    count_strobrscop[vehicleid] = 0;

    if(restore_lights && IsValidVehicle(vehicleid))
    {
        new panels, doors, lights, tires;
        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        UpdateVehicleDamageStatus(vehicleid, panels, doors, strobocop_original_lights[vehicleid], tires);
    }
    return 1;
}

CMD:strob(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return true;

    if(status_strobocop[vehicleid])
    {
        StopVehicleStroboscope(vehicleid);
        return true;
    }

    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    strobocop_original_lights[vehicleid] = lights;
    count_strobrscop[vehicleid] = 0;
    timer_strobocop[vehicleid] = SetTimerEx("function_strobocop", 200, true, "i", vehicleid);
    status_strobocop[vehicleid] = timer_strobocop[vehicleid] > 0;
    return true;
}

forward function_strobocop(vehicleid);
public function_strobocop(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid))
    {
        StopVehicleStroboscope(vehicleid, false);
        return 0;
    }

    if(!status_strobocop[vehicleid]) return 0;

    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    static const strobe_lights[] = {1, 4, 65, 68};
    UpdateVehicleDamageStatus(vehicleid, panels, doors, strobe_lights[count_strobrscop[vehicleid]], tires);
    count_strobrscop[vehicleid] = (count_strobrscop[vehicleid] + 1) % sizeof strobe_lights;
    return 1;
}

CMD:notif(playerid, params[])
{
    ShowNotificationNew(playerid, 4, 7, 0, 0, "На данный момент уведомлений не найденно!", ">>");
	ShowPlayerDialog(playerid, 666, DIALOG_STYLE_LIST, "{ff0000} Непрочитанные уведомления","Срок Действия VIP-статуса\t\t\t {FFFFFF} 2024-09-15 21:55:13\n{66CC00}Старые уведомления.", "Далее", "Выйти");

}

CMD:base(playerid, params[])
{
   if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");
   
	new fmt_text[125], list[sizeof(fmt_text)*10];

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(!GetPlayerSuspect(i)) continue;
        
		format(fmt_text, sizeof fmt_text, "{FFFFFF}#%d. {FFFF00}%s[%d]{FFFFFF} - уровень розыска: {FFFF00}%d\n", i+1, GetPlayerNameEx(i), i, GetPlayerSuspect(i));
		strcat(list, fmt_text);
		SetPlayerListitemValue(playerid, i, i);
	}

	Dialog(playerid, DIALOG_PBASE, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Список преступников", list, "Поиск", "Закрыть");

	return 1;
}



CMD:med(playerid, params[])
{
	if(g_player[playerid][P_MEDKA] == 0) return SCM(playerid, COLOR_WHITE, "У вас нет мед-карты!");
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "Введите: /med [id]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);
	if(!IsPlayerInRangeOfPoint(params[0], 5.0, px, py, pz)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко!");
	new string[128];
	format(string, sizeof(string), "Никнейм игрока:{ffff00} %s\n {ffffff}Состояние игрока:{ffff00}В норме\n {ffffff}Кем выдано: {ffff00}Городская больница\n {ffffff}Дата выдачи: {ffff00} август", GetPlayerNameEx(playerid));
	SPD(params[0], 99999, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME"{ffffff} | Медицинская карта", string, "Закрыть", "");
	return 1;
}

CMD:cheat(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /cheat [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new ban_time = 9999;

    new reason[999];

	new fmt_msg[999];

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
	return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить администратора выше по рангу");
	if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить самого себя");

	if(AntiSliv(playerid, "/cheat")) return true;

	format(fmt_msg, sizeof fmt_msg, "Администратор %s навсегда забанил игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Постороннее ПО", fmt_msg);

	if(strlen(reason) > 0)
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

    InfoAstats[1] += 1;

	format(fmt_msg, sizeof fmt_msg, "Забанил %s[acc:%d] навсегда. Причина: Постороннее ПО", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));

	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_msg);

	AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), "Постороннее ПО", GetPlayerNameEx(playerid));
	BanEx(to_player, "Нарушение правил сервера");
	return 1;
}

CMD:sliv(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 9) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sliv [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new ban_time = 9999;

    new reason[999];

	new fmt_msg[999];

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
	return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить администратора выше по рангу");
	if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить самого себя");

	if(AntiSliv(playerid, "/sliv")) return true;

	format(fmt_msg, sizeof fmt_msg, "Администратор %s навсегда забанил игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Слив", fmt_msg);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

    InfoAstats[1] += 1;

	format(fmt_msg, sizeof fmt_msg, "Забанил %s[acc:%d] навсегда. Причина: Слив", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));

	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_msg);

	AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), "Слив", GetPlayerNameEx(playerid));
	BanEx(to_player, "Нарушение правил сервера");
	return 1;
}

CMD:bot(playerid, params[])

{





	if(GetPlayerAdminEx(playerid) < 6) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");





	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /bot [ID игрока]");



	extract params -> new to_player, string:reason[30];



	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");



	new ban_time = 9999;



	new fmt_msg[999];

	



	/*(ban_time);

	{

		format(fmt_msg, sizeof fmt_msg, ""SC"Срок бана может быть от 1 до %d дней", max_days);



		return SendClientMessage(playerid, 0xCECECEFF, fmt_msg);

	}*/



	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))

	return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить администратора выше по рангу");

	//if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить самого себя");



	if(AntiSliv(playerid, "/bot")) return true;



	format(fmt_msg, sizeof fmt_msg, "Администратор %s забанил игрока %s навсегда", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));


	format(fmt_msg, sizeof fmt_msg, "%s. Причина: БОТ", fmt_msg);

	if(strlen(reason) > 0)
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);



	SendClientMessageToAll(0xFF5533FF, fmt_msg);






	format(fmt_msg, sizeof fmt_msg, "Забанил %s[acc:%d] навсегда. Причина %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), reason);



	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_msg);

    InfoAstats[1] += 1;

	AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), reason, GetPlayerNameEx(playerid));

	BanEx(to_player, reason);

	return 1;

}

CMD:permban(playerid, params[])

{


	if(GetPlayerAdminEx(playerid) < 6) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");





	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /permban [ID игрока] [причина]");



	extract params -> new to_player, string:reason[30];



	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");



	new ban_time = 9999;



	new fmt_msg[999];

	



	/*(ban_time);

	{

		format(fmt_msg, sizeof fmt_msg, ""SC"Срок бана может быть от 1 до %d дней", max_days);



		return SendClientMessage(playerid, 0xCECECEFF, fmt_msg);

	}*/



	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))

	return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить администратора выше по рангу");

	//if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить самого себя");



	if(AntiSliv(playerid, "/permban")) return true;



	format(fmt_msg, sizeof fmt_msg, "Администратор %s навсегда заблокировал игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));



	if(strlen(reason) > 0)

	format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);



	SendClientMessageToAll(0xFF5533FF, fmt_msg);



	if(!strlen(reason)) reason = "None";



	format(fmt_msg, sizeof fmt_msg, "Забанил %s[acc:%d] навсегда. Причина %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), reason);



	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_msg);

    InfoAstats[1] += 1;

	AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), reason, GetPlayerNameEx(playerid));

	BanEx(to_player, reason);

	return 1;

}

CMD:ppv(playerid, params[])
{
 if(GetPlayerAdminEx(playerid) < 6) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");


 if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /ppv [ID игрока]");

 extract params -> new to_player;

 if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
 return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

 new ban_time = 9999;

 new fmt_msg[999];

 if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
 return SendClientMessage(playerid, 0xCECECEFF, "Нельзя забанить администратора выше по рангу");
 if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя забанить самого себя");

 if(AntiSliv(playerid, "/ppv")) return true;

 format(fmt_msg, sizeof fmt_msg, "Администратор %s забанил игрока навсегда %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

 format(fmt_msg, sizeof fmt_msg, "%s. Причина: ППВ", fmt_msg);

 SendClientMessageToAll(0xFF5533FF, fmt_msg);

 format(fmt_msg, sizeof fmt_msg, "Забанил %s[acc:%d] навсегда. Причина: ППВ", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));

 SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_msg);

 AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), "ППВ", GetPlayerNameEx(playerid));
 BanEx(to_player, "Нарушение правил сервера");
 return 1;
}

CMD:flood(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 3) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /flood [id игрока]");
	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
	new mute_time = 30;
	//if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Время должно быть не меньше 1 и не больше 360 минут");
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить заблокировать чат администратору выше по рангу");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить затычку самому себе");
	if(AntiSliv(playerid, "/flood")) return true;
	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);
	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Флуд", fmt_msg);
	SendClientMessageToAll(0xFF5533FF, fmt_msg);
	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");
	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: Флуд",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
	return 1;
}

CMD:giveacs(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна администраторам с 1 уровня.");

    new to_player, acs_model;
    if(sscanf(params, "dI(-1)", to_player, acs_model))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /giveacs [id игрока] [id аксессуара (необязательно)]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет.");

    // Без id аксессуара - прежнее поведение (список для выбора)
    if(acs_model == -1)
    {
        gGiveAcsTarget[playerid] = to_player;
        gGiveAcsDialogPage[playerid] = 0;
        return ShowAdminGiveAcsDialog(playerid, 0);
    }

    // Прямая выдача по id аксессуара, без диалога
    new acs = AccessoryGetIndexByModel(acs_model);
    if(acs < 0 || acs >= sizeof(accessory) || accessory[acs][ID_ACCESSORY] <= 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Аксессуар с таким id не найден.");
    if(!AccessoryIsGiveable(acs))
        return SendClientMessage(playerid, 0xCECECEFF, "Этот предмет не является аксессуаром.");

    // AdminGiveAccessoryAndOfferEdit уже сама уведомляет админа и цель,
    // предлагает диалог настройки позиции и пишет лог - дублировать не нужно.
    return AdminGiveAccessoryAndOfferEdit(playerid, to_player, acs);
}

CMD:acss(playerid, params[])
{
    #pragma unused params
    return AccessoryShowInventory(playerid);
}
stock CreateAcsTextDraw(playerid)
{
	SelectTextDraw(playerid, COR_SERVER);

	TextDrawShowForPlayer(playerid, acs_TD[0]);
	TextDrawShowForPlayer(playerid, acs_TD[1]);
	TextDrawShowForPlayer(playerid, acs_TD[2]);
	TextDrawShowForPlayer(playerid, acs_TD[4]);
	TextDrawShowForPlayer(playerid, acs_TD[5]);
	TextDrawShowForPlayer(playerid, acs_TD[6]);
	TextDrawShowForPlayer(playerid, acs_TD[7]);
	TextDrawShowForPlayer(playerid, acs_TD[8]);
	TextDrawShowForPlayer(playerid, acs_TD[9]);
	TextDrawShowForPlayer(playerid, acs_TD[10]);
	TextDrawShowForPlayer(playerid, acs_TD[17]);
	TextDrawShowForPlayer(playerid, acs_TD[24]);
	TextDrawShowForPlayer(playerid, acs_TD[25]);

	new acs_coords[144];
	format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_1"));

	acs_coords_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
	PlayerTextDrawLetterSize(playerid, acs_coords_PTD[playerid][0], 0.3000, 1.6000);
	PlayerTextDrawAlignment(playerid, acs_coords_PTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, acs_coords_PTD[playerid][0], 0xFFFFFFFF);
	PlayerTextDrawBackgroundColor(playerid, acs_coords_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, acs_coords_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, acs_coords_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, acs_coords_PTD[playerid][0], 0);

	PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);

	SetPVarInt(playerid, "acs_td_use", 1);
	TogglePlayerControllable(playerid, true);
}

CMD:editacss(playerid, params[])
{
	extract params -> new slot; else return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: {FFFF00}/{FFFFFF}editacs [слот]");

	if(!(0 <= slot <= 9)) return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: слот от 0 до 9");

    new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT modelid, bone, x, y, z, rX, rY, rZ, scale FROM accessories WHERE id=%d AND slot=%d", GetPlayerAccountID(playerid), slot);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	new modelid = cache_get_field_content_int(0, "modelid"),
	bone = cache_get_field_content_int(0, "bone"),
	Float: x =  cache_get_field_content_float(0, "x"),
  	Float: y =  cache_get_field_content_float(0, "y"),
   	Float: z =  cache_get_field_content_float(0, "z"),
   	Float: rX = cache_get_field_content_int(0, "rX"),
   	Float: rY = cache_get_field_content_int(0, "rY"),
   	Float: rZ = cache_get_field_content_int(0, "rZ"),
   	Float: scale =  cache_get_field_content_float(0, "scale");

	if(rows)
	{
       	SetPVarInt(playerid, "slot", slot);
		SetPVarInt(playerid, "modelid", modelid);
		SetPVarInt(playerid, "bone", bone);
		SetPVarFloat(playerid, "num_1", x);
		SetPVarFloat(playerid, "num_2", y);
		SetPVarFloat(playerid, "num_3", z);
		SetPVarFloat(playerid, "num_4", rX);
		SetPVarFloat(playerid, "num_5", rY);
		SetPVarFloat(playerid, "num_6", rZ);
		SetPVarFloat(playerid, "num_7", scale);

		CreateAcsTextDraw(playerid);

        if (GetPVarInt(playerid, "bone") > 0 && GetPVarInt(playerid, "modelid") > 0){
		SetPlayerAttachedObject
		(
			playerid,
			GetPVarInt(playerid, "slot"),
			GetPVarInt(playerid, "modelid"),
			GetPVarInt(playerid, "bone"),
			GetPVarFloat(playerid, "num_1"),
			GetPVarFloat(playerid, "num_2"),
   			GetPVarFloat(playerid, "num_3"),
      		GetPVarFloat(playerid, "num_4"),
			GetPVarFloat(playerid, "num_5"),
			GetPVarFloat(playerid, "num_6"),
			GetPVarFloat(playerid, "num_7"),
			GetPVarFloat(playerid, "num_7"),
			GetPVarFloat(playerid, "num_7"),
			0
		);
		}
		SetPVarInt(playerid, "acs_use", 1);
		SetPVarInt(playerid, "updateacs", 1);
	}
					else
	{
	    SCM(playerid, -1, "{FFFF00}| {FFFFFF}В данном слоту нет аксессуара");
	}

	cache_delete(result);

	return 1;

}

