//>> Файл: bykranin_src/core/social/social_04.inc  (416 строк)
//>> Тема: телефон, чаты, объявления, справка
//>> Внутри: load_QuickMessage, ProxDetector, /todo, GetNearestBiz, ShowTime, /lmenu, /uninviteoff
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
editMessage(playerid)
{
    new string_qm[(128 * 20) + 34];

    format(string_qm, sizeof string_qm,
    ""c_server"[1] {FFFFFF}%s\n\
    "c_server"[2] {FFFFFF}%s\n\
    "c_server"[3] {FFFFFF}%s\n\
    "c_server"[4] {FFFFFF}%s\n\
    "c_server"[5] {FFFFFF}%s\n\
    "c_server"[6] {FFFFFF}%s\n\
    "c_server"[7] {FFFFFF}%s\n\
    "c_server"[8] {FFFFFF}%s\n\
    "c_server"[9] {FFFFFF}%s\n\
    "c_server"[10] {FFFFFF}%s\n\
    "c_server"[11] {FFFFFF}%s\n\
    "c_server"[12] {FFFFFF}%s\n\
    "c_server"[13] {FFFFFF}%s\n\
    "c_server"[14] {FFFFFF}%s\n\
    "c_server"[15] {FFFFFF}%s\n\
    "c_server"[16] {FFFFFF}%s\n\
    "c_server"[17] {FFFFFF}%s\n\
    "c_server"[18] {FFFFFF}%s\n\
    "c_server"[19] {FFFFFF}%s\n\
    "c_server"[20] {FFFFFF}%s\n\
    {FFBF00}Очистить всё",
    quick_mes[playerid][0][line],
    quick_mes[playerid][1][line],
    quick_mes[playerid][2][line],
    quick_mes[playerid][3][line],
    quick_mes[playerid][4][line],//5
    quick_mes[playerid][5][line],
    quick_mes[playerid][6][line],
    quick_mes[playerid][7][line],
    quick_mes[playerid][8][line],
    quick_mes[playerid][9][line], //10
    quick_mes[playerid][10][line],
    quick_mes[playerid][11][line],
    quick_mes[playerid][12][line],
    quick_mes[playerid][13][line],
    quick_mes[playerid][14][line], //15
    quick_mes[playerid][15][line],
    quick_mes[playerid][16][line],
    quick_mes[playerid][17][line],
    quick_mes[playerid][18][line],
    quick_mes[playerid][19][line] //20
    );

    Dialog(playerid, DIALOG_EDIT_QM, DIALOG_STYLE_LIST, "Редактировать", string_qm, "Выбрать", "Назад");
    return 1;//save_QuickMessage(playerid);
}

sendQuickMessage(playerid, const string_qm[]) //Обработчик текста
{
	if(strfind(string_qm, "Введите текст", true) != -1)
		return 1; //если поле не заполнено, блокируем.
	new p_name[ MAX_PLAYER_NAME ];

	strmid(str, string_qm, 0, strlen(string_qm), 255);

	GetPlayerName( playerid, p_name, MAX_PLAYER_NAME );
/*	if(strfind(str, "@name", true) != -1)
	{
		new macros = strfind(str, "@name");
		strdel(str, macros, macros + strlen("@name"));
		strins(str, p_name, macros, strlen(str));
	}
	if(strfind(str, "@frac", true)!= -1)
	{
		new macros = strfind(str, "@frac");
		strdel(str, macros, macros + strlen("@frac"));
		new string[ 24 ]; format(string, sizeof string, "%s", GetPlayerTeamName(playerid));
		strins(str, string, macros, strlen(str));
	}
	if(strfind(str, "@pass", true)!= -1)
	{
		new macros = strfind(str, "@pass");
		strdel(str, macros, macros + strlen("@pass"));
		new string[16 + 1];
		format(string, sizeof(string), "(( /pass %d ))", playerid);
		strins(str, string, macros, strlen(str));
	}
	if(strfind(str, "@lic", true)!= -1)
	{
		new macros = strfind(str, "@lic");

		strdel(str, macros, macros + strlen("@lic"));
		new string[15 + 1];
		format(string, sizeof(string), "(( /lic %d ))", playerid);
		strins(str, string, macros, strlen(str));
	}
	if(strfind(str, "@alldoc", true)!= -1)
	{
		new macros = strfind(str, "@alldoc");
		strdel(str, macros, macros + strlen("@alldoc"));
		new string[25 + 1];
		format(string, sizeof(string), "(( /pass %d /lic %d ))", playerid, playerid);
		strins(str, string, macros, strlen(str));
	}*/
	if(strfind(str, "/me", true) != -1)
	{
		new macros = strfind(str, "/me ");
		strdel(str, macros, macros + strlen("/me "));
		return callcmd::me(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/do", true) != -1)
	{
		new macros = strfind(str, "/do ");
		strdel(str, macros, macros + strlen("/do "));
		return callcmd::do(playerid, str); //pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/try", true) != -1)
	{
		new macros = strfind(str, "/try ");
		strdel(str, macros, macros + strlen("/try "));
		return callcmd::try(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/todo", true) != -1)
	{
		new macros = strfind(str, "/todo ");
		strdel(str, macros, macros + strlen("/todo "));
		return callcmd::todo(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/f", true) != -1)
	{
		new macros = strfind(str, "/f ");
		strdel(str, macros, macros + strlen("/f "));
		return callcmd::f(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/fn", true) != -1)
	{
		new macros = strfind(str, "/fn ");
		strdel(str, macros, macros + strlen("/fn "));
		return callcmd::fn(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/r", true) != -1)
	{
		new macros = strfind(str, "/r ");
		strdel(str, macros, macros + strlen("/r "));
		return callcmd::r(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/rn", true) != -1)
	{
		new macros = strfind(str, "/rn ");
		strdel(str, macros, macros + strlen("/rn "));
		return callcmd::rn(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/s", true) != -1)
	{
		new macros = strfind(str, "/s ");
		strdel(str, macros, macros + strlen("/s "));
		return callcmd::s(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/n", true) != -1)
	{
		new macros = strfind(str, "/n ");
		strdel(str, macros, macros + strlen("/n "));
		return callcmd::n(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/w", true) != -1)
	{
		new macros = strfind(str, "/w ");
		strdel(str, macros, macros + strlen("/w "));
		return callcmd::w(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/u", true) != -1)
	{
		new macros = strfind(str, "/u ");
		strdel(str, macros, macros + strlen("/u "));
		return callcmd::u(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/gnews", true) != -1)
	{
		new macros = strfind(str, "/gnews ");
		strdel(str, macros, macros + strlen("/gnews "));
		return callcmd::gnews(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/msg", true) != -1)
	{
		new macros = strfind(str, "/msg ");
		strdel(str, macros, macros + strlen("/msg "));
		return callcmd::msg(playerid, str);//pc_cmd_me (if pawn.cmd)
	}
	if(strfind(str, "/o", true) != -1)
	{
		new macros = strfind(str, "/o ");
		strdel(str, macros, macros + strlen("/o "));
		return callcmd::msg(playerid, str);//pc_cmd_me (if pawn.cmd)
	}

	format(str, sizeof(str), "%s[%d] говорит: {FFFFFF}%s ",p_name, playerid, str);
	ProxDetector(playerid, 30.0, 0xFFFFFFFF, str); str[0] = EOS; return 1;
}

forward load_QuickMessage(playerid);
public load_QuickMessage(playerid)
{
    new query[128];
    new Cache: result;
    mysql_format(mysql, query, sizeof query, "SELECT * FROM quick_message WHERE name= '%s'", GetPlayerNameEx(playerid));
    result = mysql_query(mysql, query);

    printf("query load %s", query);


    if(!cache_num_rows(result))
    {

        format(query, sizeof query , "INSERT INTO `quick_message` (`name`) VALUES ('%s')", GetPlayerNameEx(playerid));
        mysql_tquery(mysql, query, "", "");

        for(new i = 0; i < 20; i++)
            format(quick_mes[playerid][i][line], 128, "Введите текст для поля №%d", i+1);

        return SendClientMessage(playerid, -1, "Binder успешно создал сток текст!");
    }

    for(new i = 0; i < 20; i++)
    {
            format(query, 12, "text_%d", i+1);
            cache_get_field_content(0, query, quick_mes[playerid][i][line], 128);
    }
    cache_delete(result);
    return SendClientMessage(playerid, -1, "Binder успешно загружен!");


}
save_QuickMessage(playerid, id_text)
{
    new query_string[256];

    format(query_string, sizeof(query_string), "UPDATE `quick_message` SET 	ext_%d` = '%s' WHERE name = '%s'",id_text+1, quick_mes[playerid][id_text][line], GetPlayerNameEx(playerid));
   // format(query_string, sizeof(query_string), "UPDATE `quick_message` SET 	ext_1` = '%s', 	ext_2` = '%s', 	ext_3` = '%s', 	ext_4` = '%s', 	ext_5` = '%s', 	ext_6` = '%s', 	ext_7` = '%s', 	ext_8` = '%s', 	ext_9` = '%s', 	ext_10` = '%s', 	ext_11` = '%s', 	ext_12` = '%s', 	ext_13` = '%s', 	ext_14` = '%s', 	ext_15` = '%s', 	ext_16` = '%s', 	ext_17` = '%s', 	ext_18` = '%s', 	ext_19` = '%s', 	ext_20` = '%s' WHERE `name` = '%s'", quick_mes[playerid][0][line], quick_mes[playerid][1][line], quick_mes[playerid][2][line], quick_mes[playerid][3][line], quick_mes[playerid][4][line], quick_mes[playerid][5][line],quick_mes[playerid][6][line],quick_mes[playerid][7][line],quick_mes[playerid][8][line],quick_mes[playerid][9][line],quick_mes[playerid][10][line],quick_mes[playerid][11][line],quick_mes[playerid][12][line],quick_mes[playerid][13][line],quick_mes[playerid][14][line],quick_mes[playerid][15][line],quick_mes[playerid][16][line],quick_mes[playerid][17][line],quick_mes[playerid][18][line],quick_mes[playerid][19][line], GetPlayerNameEx(playerid));
    printf("save %s", query_string);
    return mysql_tquery(mysql, query_string, "", "");
}

stock ProxDetector(playerid, Float:max_range, color, const string[], Float:max_ratio = 1.6)
{
	new Float:pos_x,
		Float:pos_y,
		Float:pos_z,
		Float:range,
		Float:range_ratio,
		Float:range_with_ratio,
		clr_r,
		clr_g,
		clr_b,
		Float:color_r,
		Float:color_g,
		Float:color_b;

	if (!GetPlayerPos(playerid, pos_x, pos_y, pos_z)) {
		return 0;
	}
	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

#if defined foreach
	foreach (new i : Player) {
#else
	for (new i = GetPlayerPoolSize(); i != -1; i--) {
#endif
		if (!IsPlayerStreamedIn(playerid, i))
		{
			continue;
		}
		range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);
		if (range > max_range)
		{
			continue;
		}

		range_ratio = (range_with_ratio - range) / range_with_ratio;
		clr_r = floatround(range_ratio * color_r);
		clr_g = floatround(range_ratio * color_g);
		clr_b = floatround(range_ratio * color_b);

		SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
	}

	SendClientMessage(playerid, color, string);
	return 1;
}

CMD:todo(playerid, params[])
{
	if(strlen(params) > 95) return SCM(playerid, -1, !"Слишком длинный текст и действие");

	new message[48], action[49];

	if(sscanf(params, "p<*>s[47]s[48]", message, action)) return SCM(playerid, -1, !"Используйте /todo [текст*действие]");

	if(strlen(message) < 2 || strlen(action) < 2) return SCM(playerid, -1, !"Используйте /todo [текст*действие]");
	new string[144];

	format(string, sizeof(string), "- '%s' - {DE92FF}сказал(-а) %s[%d], %s", message, GetPlayerNameEx(playerid), playerid, action);
	Action(playerid, string);
	return 1;
}

stock GetNearestBiz(playerid, type, Float: dist = 15.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;

	new biz_id = -1;
	new Float: my_dist;

	for(new idx; idx < g_business_loaded; idx ++)
	{
	    if(GetBusinessData(idx, B_TYPE) != type) continue;
		my_dist = GetPlayerDistanceFromPoint(playerid, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			biz_id = idx;
		}
	}
	return biz_id;
}

stock ShowTime(playerid)
{
	new
		hour, minute, second,
		year, month, day;

	gettime(hour, minute, second);
	getdate(year, month, day);

	

	new fmt_str[350];

	format(fmt_str, sizeof fmt_str, "~y~%d:%02d:%02d~n~~b~~h~%02d.%02d.%d", hour, minute, second, day, month, year);
	GameTextForPlayer(playerid, fmt_str, 3000, 1);

	return 1;
}

CMD:lmenu(playerid)
{
    if(!(1 <= GetPlayerTeamEx(playerid) <= 7)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	new menu[320];
	format(menu, sizeof(menu),
		""c_s"[1] "c_b"Уволить игрока оффлайн\n\
		"c_s"[2] "c_b"Посмотреть всех сотрудников\n\
		"c_s"[3] "c_b"Меню вакансий");
	if(GetPlayerJob(playerid) == 10 && OrgWarehouse_IsSupportedTeam(GetPlayerTeamEx(playerid)))
	{
		strcat(menu, "\n"c_s"[4] "c_b"Управление складом", sizeof(menu));
	}
	Dialog(playerid, DIALOG_LEADER_MENU, DIALOG_STYLE_LIST, "Панель лидера", menu, "Выбрать", "Закрыть");
	return 1;
}

CMD:uninviteoff(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /uninviteoff [ник игрока]");

	extract params -> new string: player_name[21];

	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0xCECECEFF, "Игрок с таким именем находится на сервере");

	new query[144],
		Cache: result,
		rows,
		team,
		rank;

	mysql_format(mysql, query, sizeof query, "SELECT team, job FROM accounts WHERE name='%s'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	if(rows)
	{
		team = cache_get_row_int(0, 0);
		rank = cache_get_row_int(0, 1);
	}

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0xCECECEFF, "Игрок с таким именем не найден");

	if(team != GetPlayerTeamEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей организации");

	if(rank >= GetPlayerJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя уволить уволить заместителя/лидера организации");

	format(query, sizeof query, "Вы уволили игрока %s в оффлайне", player_name);
	SendClientMessage(playerid, 0xFF5533FF, query);

	format(query, sizeof query, "UPDATE accounts SET team=0,org_skin=0,job=0 WHERE name='%s'", player_name);
	mysql_query(mysql, query, false);

	return 1;
}

CMD:addvacancy(playerid)
{
	
	if(!(1 <= GetPlayerTeamEx(playerid) <= 7)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	Dialog(playerid, 30000,DIALOG_STYLE_INPUT,"Создать собеседование","Введите время, на которое вы хотите назначить собеседование","Ввести","Закрыть");
	return 1;
}

