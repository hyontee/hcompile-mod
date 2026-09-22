//>> Файл: bykranin_src/core/admin/admin_06.inc  (281 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: GetNumberOfPaintjobsForVehicle, /report, sssreport, /rep, /freeze, /unfreeze, /arules
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetNumberOfPaintjobsForVehicle(vehiclemodel)
{
    switch(vehiclemodel)
    {
        case 483:
            return 1;
        case 575:
            return 2;
        case 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 576,611,612,613:
            return 3;
    }
    return 0;
}

CMD:report(playerid, params[])
{
	if(!isnull(params))
		return ReportGUI_Submit(playerid, params);

	Dialog(playerid, DIALOG_REPORT_CLAIM, DIALOG_STYLE_INPUT,
		"{00CC00}"SERVER_NAME" {FFFFFF}| Жалоба",
		"Введите текст жалобы для администрации сервера:",
		"Готово", "Закрыть");
	return 1;
}


stock sssreport(playerid)
{
	Dialog(playerid, DIALOG_REPORT_CLAIM, DIALOG_STYLE_INPUT,
		"{00CC00}"SERVER_NAME" {FFFFFF}| Жалоба",
		"Введите текст жалобы для администрации сервера:",
		"Готово", "Закрыть");
	return 1;
}

CMD:rep(playerid, params[])
{
	return callcmd::ans(playerid, params);
}


alias:freeze("fz")
CMD:freeze(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2)
    return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
  
    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /unfreeze [id игрока]");

    extract params -> new to_player;
 
    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
    return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
 
    TogglePlayerControllable(to_player, 0); 
 
    new fmt_msg[999];
  
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] заморозил %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(fmt_msg, 0x999999FF);
  
    format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы заморозили %s[%d]", GetPlayerNameEx(to_player), to_player);
    SendClientMessage(playerid, -1, fmt_msg);
  
    format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] заморозил Вашего персонажа.", GetPlayerNameEx(playerid), playerid);
    SendClientMessage(to_player, -1, fmt_msg);
  
    return true;
}

alias:unfreeze("unfz")
CMD:unfreeze(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2)
    return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /unfreeze [id игрока]");

    extract params -> new to_player;

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
    return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
 
    TogglePlayerControllable(to_player, 1); 
 
    new fmt_msg[999];
 
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] разморозил %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(fmt_msg, 0x999999FF); 
 
    format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы разморозили %s[%d]", GetPlayerNameEx(to_player), to_player);
    SendClientMessage(playerid, -1, fmt_msg);
 
    format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] разморозил Вашего персонажа.", GetPlayerNameEx(playerid), playerid);
    SendClientMessage(to_player, -1, fmt_msg);
 
    return true;
}

CMD:arules(playerid)
{
    if(GetPlayerAdminEx(playerid)< 1) return SendClientMessage(playerid, -1, "{FFFF00}| {ffffff}Вам не доступна данная команда!");
    Dialog
      (
		playerid, DIALOG_NG, DIALOG_STYLE_MSGBOX,
		"{F81414}{SERVER_NAME} | {FFFFFF}Правила Админов",
		"{FF0000}ОБЯЗАННОСТИ Администраторов:\n\
		{FFFFFF}-Отвечать на каждый репорт\n\
        {FFFFFF}-Следить за территорией банд\n\
        {FFFFFF}-Следить за респой новичков\n\
        {FFFFFF}-Помогать игрокам\n\
        {FFFFFF}-Слушать старших по рангу\n\n\
        {FF0000}Администраторам ЗАПРЕЩЕНО:\n\
        {FFFFFF}-Участвовать в каптах\n\
        {FFFFFF}-Использовать полномочия администратора\n\
        {FFFFFF}-Похабное обращение с игроками\n\
        {FFFFFF}-Неподчиняться страшим\n\
        {FFFFFF}-Стоять целый день афк и лентяйничеть\n\
        {FFFFFF}-Обсуждать действия администраторов\n\
        {FFFFFF}-Игнорировать просьбы игроков и репорты\n\
        {FFFFFF}-Кикать нонрп ники запрещается!\n\
        {FFFFFF}-Говорить админ.панель при игроках\n\n\
        {FFA500}Наказания:\n\
        {FFFFFF}-DM - /jail на 5 мин\n\
        {FFFFFF}-Dm in zz - /jail 10-30 мин\n\
        {FFFFFF}-MG - мут на 5-10 мин\n\
        {FFFFFF}-Оск - 10-20 минут мута\n\
        {FFFFFF}-Читы(вред) - Бан на 10-30 дней.\n\
        {FFFFFF}-Оффтоп/флуд в репорт - 5-15мин мута\n\
        {FFFFFF}-Сheat - Бан 5-30\n\
        {FFFFFF}-Реклама - /banpc 30 дней.\n\
        {FFFFFF}-Багоюз -  /jail 10-20мин.\n\
        {FFFFFF}-Non rp cop - /warn или /jail 15-30 минут.",
        "Прочитал", "");
        return 1;
}

CMD:wf(playerid, params[])
{
 new string[32];
 format(string, sizeof(string), "Ваш виртуальный мир: %d", GetPlayerVirtualWorld(playerid));
 SendClientMessage(playerid,0xFFFFFFFF,string);
 return 1;
}
forward golodbr(playerid);
public golodbr(playerid)
{
    if(0 <= playerid < MAX_PLAYERS)
    {
        golod[playerid] = 100;
    }
    return 1;
}
cmd:menuhud(playerid)
{
	Dialog
	(
	playerid,DIALOG_MENUHUD,DIALOG_STYLE_LIST,
	"VING RUSSIA | Интерфейс",
	"1. Скрыть худ\n\
	2. Показать худ\n\
	3. Скрыть чат\n\
	4. Показать чат",
	"Выбрать","Закрыть"
	);
	return 1;
}

CMD:helpers(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) == 0)
	{
		if(GetPlayerPremium(playerid) == 0)
		    return  SendClientMessage(playerid, 0xCECECEFF, "У Вас нет VIP аккаунта.");
	}

 new fmt_text[100],
 list[sizeof fmt_text * 10 + 50] = "Никнейм\t\t\t\t\tДолжность\t\t\t\tИнформация\n";


  foreach(new i : Player)
  {
  if(!IsPlayerConnected(i)) continue;
  else if(!IsPlayerLogged(i)) continue;
  else if(!GetPlayerHelperEx(i)) continue;
  new Helper = GetPlayerHelperEx(i);
  switch(Helper)
  {
        case 1: fmt_text = "Хелпер(1)";
        default: fmt_text = "Главный хелпер(2)";
  }

  format(fmt_text, sizeof fmt_text, "%s[%d]\t\t\t\t\t%s\t\t\t\t{66CC33}в игре\n",  GetPlayerNameEx(i), i, fmt_text);
  strcat(list, fmt_text);
 }

 Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Помощники в сети", list, "Закрыть", "");

 return 1;
}

CMD:dm(playerid, params[])

{


    
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");





	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /dm [ID игрока]");



	extract params -> new to_player;



	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");



	new jail_time = 60;

    if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Этот игрок уже сидит в тюрьме");

	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя поставить затычку самому себе");



	if(AntiSliv(playerid, "/dm")) return true;



	new fmt_msg[999];

	format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);



	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Death Match (DM)", fmt_msg);



	SendClientMessageToAll(0xFF5533FF, fmt_msg);



	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания заключения: {CCCC00}/time");
    SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
    ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}Время до окончания заключения: {CCCC00}/time", "");



	JailPlayer(to_player, jail_time);



	format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: DM",

	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time);



	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);



	return 1;

}



