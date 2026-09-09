cmd:mp_menu(playerid) return callcmd::eventmenu(playerid);
cmd:eventmenu(playerid)
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
	string_dialog[0] = EOS;
	format(string_dialog, sizeof string_dialog,
	"{ffa500}• {FFFFFF}Позиция телепорта\n\
	{ffa500}• {FFFFFF}Название мероприятия:\"%s\"\n\
	{ffa500}• {FFFFFF}Количество Health: %d\n\
	{ffa500}• {FFFFFF}Количество Armour: %d\n\
	{ffa500}• {FFFFFF}Лимит игроков: %d игроков\n\
	{ffa500}• {FFFFFF}Время действия телепорта: %d секунд\n\
	{ffa500}• {FFFFFF}Отбирать оружие при телепорте: %s\n\
	{ffa500}• %s{FFFFFF}", MPName,MPHealth,MPArmour,MPPlayerLimit,MPTimeStatic,MPWeapon ? ("{05B212}Нет{FFFFFF}") : ("{FF1C05}Да{FFFFFF}"),Teleport ? ("{FF1C05}Остановить{FFFFFF} мероприятие") : ("{7CFC00}Запустить {FFFFFF}мероприятие"));

	Dialog(playerid, DIALOG_EVENT_MENU, DIALOG_STYLE_LIST, "Настройка", string_dialog, "Выбрать", "Закрыть");
	return 1;
}