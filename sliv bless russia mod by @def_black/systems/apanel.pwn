cmd:apanel(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}У вас нет доступа к этой команде.");

	Dialog
	(
		playerid, DIALOG_ADMIN_PANEL, DIALOG_STYLE_LIST,
		"{FFCC00}Панель управления сервером",
		"1. Список администраторов\n\
		2. Список лидеров",
		"Выбрать", "Закрыть"
	);

	return 1;
}
