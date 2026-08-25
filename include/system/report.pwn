

//================= [OnDialogResponse] ==========
case 122:
			{
					if(response)
					{
						switch(listitem)
						{
							case 0:
							{
								SPD(playerid, 125, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Жалоба", ""c_white"Для того чтобы отправить свою жалобу администрации\nсервера - просто введите ее в диалоговое поле в ниже.\n\nПросьба корректно формулировать и излагать свою мысли,\nчтобы администрация смогла полностью понять суть\nпроблемы и максимально быстро среагировать.Не\nзабывайте о правилах этики, а так же правилах сервера.", "Готово", "Назад");
							}
							case 1:
							{
								SPD(playerid, 127, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Вопрос", ""c_white"Для того, чтобы отправить свой вопрос помощниками сервера - просто\nвведите его в диалоговое поле ниже.\n\nПожалуйста, убидительная просьба, прежде чем отпраивть свой\nвопрос - постарайтесь четко и понятно его сформулироватью.Не\n\nзабывайте о правилах этики, а так же правилах сервера.", "Готово", "Назад");
							}
						}
					}
			}
			case 127:
			{
				if(response)
				{
					if(!strlen(inputtext))
					{
						SPD(playerid, 127, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Вопрос", ""c_white"Для того, чтобы отправить свой вопрос помощниками сервера - просто\nвведите его в диалоговое поле ниже.\n\nПожалуйста, убидительная просьба, прежде чем отпраивть свой\nвопрос - постарайтесь четко и понятно его сформулироватью.Не\n\nзабывайте о правилах этики, а так же правилах сервера.", "Готово", "Назад");
					}
					else
					{
						new string[200];
						format(string, sizeof(string), "{ffff00}|{ffffff} Вы успешно отправили свой вопрос для агентов поддержки сервера, ожидайте ответа.");
						SCM(playerid, COLOR_WHITE, string);
						g_player[playerid][P_REPORTS] = 1;
						UpdatePlayerDatabaseInt(playerid, "reports", 1);
						format(string, sizeof(string), "{ffff00}|{ffffff} Жалоба от %s[%d].Жалоба: %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), inputtext);
						SendMessageToHelpers(string, COLOR_WHITE);
						strmid(g_player[playerid][P_REPSTATUS], inputtext, 0, strlen(inputtext), 32);
						strmid(g_player[playerid][P_MYREPS], inputtext, 0, strlen(inputtext), 32);
						new query[128];
						format(query, sizeof(query), "INSERT INTO `accounts` (`repstatus`, `myreps`) VALUES ('%s', '%s')", g_player[playerid][P_REPSTATUS], g_player[playerid][P_MYREPS]);
						mysql_tquery(mysql, query);
					}
				}
				else SPD(playerid, 122, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA {FFFFFF}| Свзяь", ""c_red"#1"c_white"\tСвязь с администрацией"c_red"\t(жалоба)"c_gray"\tнажмите для взаимодействия\n"c_red"#2"c_white"\tСвязь с помощниками"c_red"\t(вопрос)"c_gray"\tнажмите для взаимодействия", "Выбрать", "Закрыть");
			}
			case 125:
			{
				if(response)
				{
					if(!strlen(inputtext))
					{
						SPD(playerid, 125, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Жалоба", ""c_white"Для того чтобы отправить свою жалобу администрации\nсервера - просто введите ее в диалоговое поле в ниже.\n\nПросьба корректно формулировать и излагать свою мысли,\nчтобы администрация смогла полностью понять суть\nпроблемы и максимально быстро среагировать.Не\nзабывайте о правилах этики, а так же правилах сервера.", "Готово", "Назад");
					}
					else
					{
						new string[200];
						format(string, sizeof(string), "{ffff00}|{ffffff} Вы успешно отправили свою жалобу! Ожидайте ответа");
						SCM(playerid, COLOR_WHITE, string);
						g_player[playerid][P_REPORTS] = 1;
						UpdatePlayerDatabaseInt(playerid, "reports", 1);
						format(string, sizeof(string), "{ffff00}|{ffffff} Жалоба от %s[%d].Жалоба: %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), inputtext);
						SendMessageToAdmins(string, COLOR_WHITE);
						strmid(g_player[playerid][P_REPSTATUS], inputtext, 0, strlen(inputtext), 32);
						strmid(g_player[playerid][P_MYREPS], inputtext, 0, strlen(inputtext), 32);
						new query[128];
						format(query, sizeof(query), "INSERT INTO `accounts` (`repstatus`, `myreps`) VALUES ('%s', '%s')", g_player[playerid][P_REPSTATUS], g_player[playerid][P_MYREPS]);
						mysql_tquery(mysql, query);
					}
				}
				else SPD(playerid, 122, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA {FFFFFF}| Свзяь", ""c_red"#1"c_white"\tСвязь с администрацией"c_red"\t(жалоба)"c_gray"\tнажмите для взаимодействия\n"c_red"#2"c_white"\tСвязь с помощниками"c_red"\t(вопрос)"c_gray"\tнажмите для взаимодействия", "Выбрать", "Закрыть");
			}
			case 126:
			{
				if(response)
				{
					callcmd::atvet(playerid, "");
					g_player[playerid][P_REPORTS] = 0;
					UpdatePlayerDatabaseInt(playerid, "reports", 0);
					g_player[playerid][P_REPSTATUS] = 0;
					UpdatePlayerDatabaseInt(playerid, "repstatus", 0);
					g_player[playerid][P_ADMINASK]++;
					UpdatePlayerDatabaseInt(playerid, "ask", 1);
					SCM(playerid, COLOR_WHITE, "Вы получили +1 аск в статистику");
					return 1;
				}
			}
			case 129:
			{
				if(response)
				{
					callcmd::atvettwo(playerid, "");
					g_player[playerid][P_REPORTS] = 0;
					UpdatePlayerDatabaseInt(playerid, "reports", 0);
					g_player[playerid][P_REPSTATUS] = 0;
					UpdatePlayerDatabaseInt(playerid, "repstatus", 0);
					g_player[playerid][P_ADMINASK]++;
					UpdatePlayerDatabaseInt(playerid, "ask", 1);
					SCM(playerid, COLOR_WHITE, "Вы получили +1 аск в статистику");
					return 1;
				}
			}
//===============================================

//======== В E_PLAYER_STRUCTUR =============
P_REPORTS,
P_REPSTATUS[33],
P_MYREPS[33],
//==========================================

//=========== В LoadPlayerData
SetPlayerData(playerid, P_REPORTS, 	cache_get_field_content_int(0, "reports"));
cache_get_field_content(0, "myreps", g_player[playerid][P_MYREPS], mysql, 33);
//=============================
//======Cmd
alias:report("rep")
CMD:report(playerid)
{
	SPD(playerid, 122, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA {FFFFFF}| Свзяь", ""c_red"#1"c_white"\tСвязь с администрацией"c_red"(жалоба)"c_gray"\tнажмите для взаимодействия\n"c_red"#2"c_white"\tСвязь с помощниками"c_red"\t(вопрос)"c_gray"\tнажмите для взаимодействия", "Выбрать", "Закрыть");
	return 1;
}

CMD:reps(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только {FFFF00}администрации сервера{FFFFFF}.");
	if(g_player[playerid][P_REPSTATUS] == 0)
	{
		SCM(playerid, -1, "Нет активных жалоб!");
	}
	else
	{
		new string[350];
		format(string, sizeof(string), "{ffff00}|{ffffff} Отправитель: %s\n{ffff00}|{ffffff} Статус отправителя: Test\n{ffff00}|{ffffff} Время и дата: Test\n{ffff00}|{ffffff} Содержимое: %s\n\n"c_white"Вам не обходимо сформулировать, а затем ввести ответ на\nжалобу игрока в диалоговое поле", GetPlayerNameEx(params[0]), g_player[playerid][P_REPSTATUS]);
		SPD(playerid, 126, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Жалоба", string, "Отправить", "Закрыть");
	}
	return 1;
}
CMD:ask(playerid, params[])
{
	if(!GetPlayerHelperEx(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только {FFFF00}хелперам сервера{FFFFFF}.");
	if(g_player[playerid][P_REPORTS] == 0)
	{
		SCM(playerid, -1, "Нет активных вопросов!");
	}
	else
	{
		new string[350];
		format(string, sizeof(string), "{ffff00}|{ffffff }Отправитель: %s\n{ffff00}|{ffffff} Статус отправителя:Test\n{ffff00}|{ffffff} Время и дата:Test\n{ffff00}|{ffffff} Содержимое:%s\n\n"c_white"Вам не обходимо сформулировать, а затем ввести ответ на\nжалобу игрока в диалоговое поле", GetPlayerNameEx(params[0]), g_player[playerid][P_REPSTATUS]);
		SPD(playerid, 129, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Вопрос", string, "Отправить", "Закрыть");
	}
	return 1;
}
CMD:atvet(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только {FFFF00}администрации сервера{FFFFFF}.");
	new string[155];
	format(string, sizeof(string), ""c_brown"Администратор %s[%d] рассмотрел Вашу жалобу (/myreports).", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid));
	SCM(params[0], COLOR_WHITE, string);
	return 1;
}
CMD:atvettwo(playerid, params[])
{
    if(!GetPlayerHelperEx(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только {FFFF00}хелперам сервера{FFFFFF}.");
	new string[155];
	format(string, sizeof(string), ""c_brown"Агент поддержки %s[%d] рассмотрел Ваш вопрос (/myreports).", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid));
	SCM(params[0], COLOR_WHITE, string);
	return 1;
}
CMD:myreports(playerid)
{
	if(g_player[playerid][P_MYREPS] == 0)
	{
		ShowNotification(playerid, 2, "Нет отвеченных репортов!", 7, "", "");
	}
	else
	{
		new string[1222];
		format(string, sizeof(string), "%s", g_player[playerid][P_MYREPS]);
		SPD(playerid, 555, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA {FFFFFF}|{FFFFFF} Отвеченные репорты", string, "Закрыть", "");
		return 1;
	}
	return 1;
}

//!!!!!!! ВАЖНО не забудте добавить в базу данных 
repstatus
myreps
reports