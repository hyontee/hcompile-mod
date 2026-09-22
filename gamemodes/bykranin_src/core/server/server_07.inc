//>> Файл: bykranin_src/core/server/server_07.inc  (469 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: /db, /pg, /mg, /goss, /osk, /oskadm, /tehnicaloff
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:db(playerid, params[])

{

	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");





	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /db [ID игрока]");



	extract params -> new to_player;



	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");



	new jail_time = 60;

    if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Этот игрок уже сидит в тюрьме");

	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя посадить в тюрьму администратора выше вашего ранга");



	if(AntiSliv(playerid, "/db")) return true;



	new fmt_msg[999];

	format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);



	format(fmt_msg, sizeof fmt_msg, "%s. Причина: DriveBy(DB)", fmt_msg);



	SendClientMessageToAll(0xFF5533FF, fmt_msg);



	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания заключения: {CCCC00}/time");
    SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
    ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}Время до окончания заключения: {CCCC00}/time", "");



	JailPlayer(to_player, jail_time);



	format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: DriveBy (DB)",

	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time);



	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);



	return 1;

}



CMD:pg(playerid, params[])

{



	if(GetPlayerAdminEx(playerid) < 3) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");





	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /pg [ID игрока]");



	extract params -> new to_player;



	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");



	new jail_time = 30;

    if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Этот игрок уже сидит в тюрьме");

	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя посадить в тюрьму администратора выше вашего ранга");



	if(AntiSliv(playerid, "/pg")) return true;



	new fmt_msg[999];

	format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);



	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Power Gaming (PG)", fmt_msg);



	SendClientMessageToAll(0xFF5533FF, fmt_msg);



	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания заключения: {CCCC00}/time");
    SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
    ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}Время до окончания заключения: {CCCC00}/time", "");



	JailPlayer(to_player, jail_time);



	format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: PG",

	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time);



	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);



	return 1;

}





CMD:mg(playerid, params[])

{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");





	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /mg [ID игрока]");



	extract params -> new to_player;



	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");



	new mute_time = 30;

	//if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Время должно быть не меньше 1 и не больше 360 минут");

	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"У этого игрока уже есть мут");

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить заблокировать чат администратору выше по рангу");

	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить затычку самому себе");



	if(AntiSliv(playerid, "/mg")) return true;



	new fmt_msg[999];

	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);



	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Meta Gaming (MG)", fmt_msg);



	SendClientMessageToAll(0xFF5533FF, fmt_msg);



	SetPlayerData(to_player, P_MUTE, mute_time * 60);

	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);



	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");



	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: MetaGaming (MG)",

	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);



	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);



	return 1;

}











CMD:goss(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /goss [id игрока]");
	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
	new mute_time = 30;
	//if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Время должно быть не меньше 1 и не больше 360 минут");
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить заблокировать чат администратору выше по рангу");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить затычку самому себе");
	if(AntiSliv(playerid, "/goss")) return true;
	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);
	format(fmt_msg, sizeof fmt_msg, "%s. Причина: В форме госс на авторынке", fmt_msg);
	SendClientMessageToAll(0xFF5533FF, fmt_msg);
	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");
	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: торг на тт госс",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
	return 1;

}

CMD:osk(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /osk [id игрока]");
	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
	new mute_time = 60;
	//if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Время должно быть не меньше 1 и не больше 360 минут");
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить заблокировать чат администратору выше по рангу");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить затычку самому себе");
	if(AntiSliv(playerid, "/osk")) return true;
	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);
	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Оскорбление", fmt_msg);
	SendClientMessageToAll(0xFF5533FF, fmt_msg);
	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");
	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: Оскорбление",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
	return 1;
}

CMD:oskadm(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /oskadm [id игрока]");
	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
	new mute_time = 180;
	//if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Время должно быть не меньше 1 и не больше 360 минут");
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить заблокировать чат администратору выше по рангу");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить затычку самому себе");
	if(AntiSliv(playerid, "/aosk")) return true;
	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);
	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Оск. администрации", fmt_msg);
	SendClientMessageToAll(0xFF5533FF, fmt_msg);
	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");
	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: Оскорбление Администрации",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
	return 1;

}

CMD:tehnicaloff(playerid, params[])
    {
      if(!GetPlayerAdminEx(playerid))
return ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас нет доступа к использованию данной команды.", "");
    if(GetPlayerAdminEx(playerid) < 13) return 1;
    SendRconCommand("password 0");
        SendClientMessage(playerid, 0xCECECEFF, "Вы успешно открыли сервер после технической работы!");
        SendClientMessageToAll(COLOR_RED, "ВНИМАНИЕ!");
  SendClientMessageToAll(0xCECECEFF, "{FFFF00}| {FFFFFF}Сервера были открыты после технических работ!");
  return 1;
    }
    
    
CMD:tehnical(playerid, params[])
{
if(!GetPlayerAdminEx(playerid))
return ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас нет доступа к использованию данной команды.", "");

    if(GetPlayerAdminEx(playerid) < 13) return 1;
    SendRconCommand("password 11232009");
        SendClientMessage(playerid, 0xCECECEFF, "Вы успешно закрыли сервер на технические работы!");
        SendClientMessageToAll(COLOR_RED, "ВНИМАНИЕ!");
  SendClientMessageToAll(0xCECECEFF, "{FFFF00}| {FFFFFF}Сервера были закрыты на технические работы!");
  if(GetPlayerAdminEx(playerid) < 13) return 1;
  SendClientMessageToAll(0xCECECEFF, "{FFFF00}| {FFFFFF}Можете приступать!");
  return 1;
  }

CMD:caps(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /caps [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new mute_time = 30;
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя выдать мут администратору выше вашего ранга");

	if(AntiSliv(playerid, "/caps")) return true;

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d минут", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);

	format(fmt_msg, sizeof fmt_msg, "%s. Причина: CapsLock", fmt_msg);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");

	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d минут. Причина: CapsLock",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:sk(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sk [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new jail_time = 30;
	if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Этот игрок уже сидит в тюрьме");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя посадить в тюрьму администратора выше вашего ранга");
	if(AntiSliv(playerid, "/sk")) return true;

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d минут", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);

	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Spawn Kill (SK)", fmt_msg);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

	SetPlayerData(to_player, P_JAIL, jail_time * 60);
	UpdatePlayerDatabaseInt(to_player, "jail", jail_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания заключения: {CCCC00}/time");
    SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
    ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}Время до окончания заключения: {CCCC00}/time", "");

	JailPlayer(to_player, jail_time);

	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] посадил в тюрьму на %d минут. Причина: SpawnKill",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:inforestart(playerid)
{
    if(GetPlayerAdminEx(playerid)< 13) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
    new fmt_msg[999];
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] проинформировал сервер о рестарте сервера.", GetPlayerNameEx(playerid), playerid);
    SendMessageToAdmins(fmt_msg, 0x999999FF);
for(new i = 0; i < 20; i++)
	{
		SendClientMessageToAll(-1, "");
	}    
    SendClientMessageToAll(COLOR_RED, "{FF5533}Уважаемые игроки, через 1 минуту пройдет технический рестарт сервера.");
    SendClientMessageToAll(COLOR_RED, "{FF5533}Уважаемые игроки, через 1 минуту пройдет технический рестарт сервера.");
    SendClientMessageToAll(COLOR_RED, "{FF5533}Уважаемые игроки, через 1 минуту пройдет технический рестарт сервера.");
    return 1;
}

CMD:topfam(playerid)
{
new fmt_text[75],
  list[sizeof fmt_text * 10 + 50] = "Название фамы - место{FFFFFF}\n";
  Dialog(playerid, DIALOG_HELPERLIST, DIALOG_STYLE_MSGBOX, "{FFCD00}Топ 5 фам", list, "Закрыть", "");
  }

new timer_strobocop[MAX_VEHICLES] = {-1, ...};
