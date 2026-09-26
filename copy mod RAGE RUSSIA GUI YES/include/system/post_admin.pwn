enum struct_post_admin 
{
    Post_Name[46],
    Post_Level,
    Post_Division,
}

#define Division_Junior 1
#define Division_Tracking 2
#define Division_Major_Tracking 3
#define Division_Technical  4
#define Division_Media  5
#define Division_Major  6
#define Division_Maj  7
#define Division_Pok  8


new post_admin[45][struct_post_admin] =
{
    {"Мл. Модератор", 3, 0},                              //0
    {"Модератор", 4, Division_Junior},                              //1
    {"Ст. Модератор", 5, Division_Junior},                  //2
    {"Администратор", 6, Division_Junior},                  //3
    {"Ст. администратор", 7, Division_Junior},                  //4
    {"Следящий за Пра-во", 3, Division_Tracking},                   //5
    {"Следящий за ФСБ", 3, Division_Tracking},                  //6
    {"Следящий за ГИБДД", 3, Division_Tracking},                    //7
    {"Следящий за УМВД", 3, Division_Tracking},                 //8
    {"Следящий за Армией", 3, Division_Tracking},                   //9
    {"Следящий за ЦБ", 3, Division_Tracking},                   //10
    {"Следящий за СМИ", 3, Division_Tracking},                  //11
    {"Следящий за Арз. ОПГ", 3, Division_Tracking},                    //12
    {"Следящий за Бат. ОПГ", 3, Division_Tracking},                    //13
    {"Следящий за Лыт. ОПГ", 3, Division_Tracking},                    //14
    {"ГС ГОСС", 7, Division_Major_Tracking},                    //15
    {"ГС ОПГ", 7, Division_Major_Tracking},                 //16
    {"ГС МП", 7, Division_Major_Tracking},                  //17
    {"ЗГС ГОСС", 7, Division_Major_Tracking},                   //18
    {"ЗГС ОПГ", 7, Division_Major_Tracking},                    //19
    {"ЗГС МП", 7, Division_Major_Tracking},                 //20
    {"Блогер", 2, Division_Media},                  //21
    {"Помощник пиар менеджера", 10, Division_Media},                 //22
    {"Пиар менеджер", 10, Division_Media},                   //23
    {"Технический специалист", 9, Division_Technical},//24
    {"Зам куратора тех специалистов", 10, Division_Technical},//25
    {"Куратор тех специалистов", 10, Division_Technical},//26
    {"Зам гл. тех специалиста", 11, Division_Technical},//27
    {"Главный Тех Специалист", 11, Division_Technical},//28
    {"Куратор администрации", 9, Division_Major},//29
    {"Заместитель ГА", 10, Division_Major},//30
    {"Основной заместитель ГА", 10, Division_Major},//31
    {"Главный администратор", 11, Division_Major},//32
    {"Зам спец администратора", 12, Division_Major},//33
    {"Спец администратор", 13, Division_Major},//34
    {"Разработчик проекта", 12, Division_Major},//35
    {"Следящий за МП", 4, Division_Tracking},//36
    {"Стажер тестировщик", 1, Division_Maj},//38
    {"Младший тестировщик", 1, Division_Maj},//39
    {"Тестировщик", 2, Division_Maj},//40
    {"Старший тестировщик", 4, Division_Maj},//41
    {"Куратор тестирования", 5, Division_Maj},//42
    {"Зам главного тестировщика", 11, Division_Maj},//43
    {"Главный тестировщик", 12, Division_Maj},//44
    {"Владелец проекта", 13, Division_Major}//45
};

new admin_player_post[MAX_PLAYERS];

#define SetPlayerAdminPost(%0,%1)    admin_player_post[%0] = %1
#define GetPlayerAdminPost(%0)    admin_player_post[%0]


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1990)
    {
        if(response)
        {
            new division = listitem+1;

            new list[35], dialog[268];

            for(new i, c = -1;i < sizeof post_admin;i++)
            {
                if(post_admin[i][Post_Division] != division) continue;
                c++;

                format(list, sizeof list, "%d. %s\n", c+1, post_admin[i][Post_Name]);
                strcat(dialog, list);
                SetPlayerListitemValue(playerid, c, i);
            }

            Dialog(playerid, 1991, DIALOG_STYLE_LIST, "{FFCD55}XWEN MOBILE | {FFFFFF}Выдача префикса администратору", dialog, "Назначить", "Выйти");
        }
    }
    if(dialogid == 1991)
    {
        if(response)
        {
            new post = GetPlayerListitemValue(playerid, listitem);

            new to_player = GetPVarInt(playerid, "shablon_player");

            if(GetPlayerAdminEx(to_player) >= GetPlayerAdminEx(playerid))
                return SendClientMessage(playerid, 0xFF9900FF, "Нельзя выдавать префикс адмиинистратору выше или такого же уровня как у Вас.");

            if(!IsPlayerConnected(playerid))
                return SendClientMessage(playerid,-1, "Игрок вышел из игры.");

            SetPlayerAdminPost(to_player, post);
	    	SetPlayerData(to_player, P_ADMIN, post_admin[post][Post_Level]);
			UpdatePlayerDatabaseInt(to_player, "admin", post_admin[post][Post_Level]);
			UpdatePlayerDatabaseInt(to_player, "post", post);

            new text[158];
            format(text, sizeof text, "{eb0000}%s изменил должность администртатору %s. Новая должность (%s)",
             GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), post_admin[post][Post_Name]);

            SendMessageToAdmins(text, -1);
        }
    }
    #if defined post_OnDialogResponse
return post_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse post_OnDialogResponse
#if defined post_OnDialogResponse
forward post_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerSpawn(playerid)
{
    if(!GetPlayerAdminPost(playerid) && GetPlayerAdminEx(playerid)) LoadAdminPost(playerid);
    #if defined post_OnPlayerSpawn
        return post_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn post_OnPlayerSpawn
#if defined post_OnPlayerSpawn
    forward post_OnPlayerSpawn(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    SetPlayerAdminPost(playerid, 0);
    #if defined post_OnPlayerDisconnect
        return post_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect post_OnPlayerDisconnect
#if defined post_OnPlayerDisconnect
    forward post_OnPlayerDisconnect(playerid, reason);
#endif

public OnGameModeInit()
{
    print("[W_SYSTEM] Команда /shablon и система должностей загружены.");
    SetTimer("CheckAccountPost", 1500, false);
    #if defined post_OnGameModeInit
        return post_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit post_OnGameModeInit
#if defined post_OnGameModeInit
    forward post_OnGameModeInit();
#endif

public:CheckAccountPost()
{
    mysql_query(mysql, "SELECT * FROM accounts WHERE post", false);
    
    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `post` INT NOT NULL  AFTER `admin`", false);

        if(!mysql_errno()) print("Query insert new `post`");
        return 1;
    }
    return 0;
}
CMD:admup(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) <= 11) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /admup [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!GetPlayerAdminEx(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Игрок не администратор");

	if(GetPlayerAdminEx(to_player) >= GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете повысить уровень у администратора выше по рангу");

	AddPlayerData(to_player, P_ADMIN, +, 1);
	UpdatePlayerDatabaseInt(to_player, "admin", GetPlayerAdminEx(to_player));

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "Администратор %s[%d] повысил Ваш уровень администратора до %d",
	GetPlayerNameEx(playerid), playerid, GetPlayerAdminEx(to_player));

	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] повысил уровень администратора %s[%d] до %d",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetPlayerAdminEx(to_player));

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	format(fmt_text, sizeof fmt_text, "Повысил %s[acc:%d] до адм. уровня %d",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), GetPlayerAdminEx(to_player));

	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}

stock LoadAdminPost(playerid)
{
    new welsi[68], Cache:result;

    mysql_format(mysql, welsi, sizeof welsi, "SELECT * FROM accounts WHERE id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, welsi);
    
    if(mysql_errno())
        return print("Добавьте в таблицу accounts столбец post | Error Sql Shablon");

    new text[124], post;

    post = cache_get_field_content_int(0, "post");

    SetPlayerAdminPost(playerid, post);
    SetPlayerData(playerid, P_ADMIN, post_admin[post][Post_Level]);

    if(!post)
    {
        switch(GetPlayerAdminEx(playerid))
        {
            case 1: SetPlayerAdminPost(playerid, 1);
            case 2: SetPlayerAdminPost(playerid, 2);
            case 3: SetPlayerAdminPost(playerid, 3);
            case 4: SetPlayerAdminPost(playerid, 4);
        }
    }
    
    new id = GetPlayerAdminPost(playerid);
    if (GetPlayerAdminEx(playerid) >= 1)
    {
        format(text, sizeof text, "{00BFFF}[A-LOGIN]: {87CEEB}%s [%d] {FFFFFF} авторизовался как: {87CEEB}%s{00BFFF}", GetPlayerNameEx(playerid), playerid, post_admin[id][Post_Name]);
        SendMessageToAdmins(text, -1);
    }

    new color[12];

    switch(post_admin[id][Post_Division])
    {
        case Division_Junior:color = "{11FFFF}";
        case Division_Tracking:color = "{4444FF}";
        case Division_Major_Tracking:color = "{00FFFF}";
        case Division_Technical:color = "{FF5E00}";
        case Division_Media:color = "{FF0000}";
        case Division_Major:
        {
            switch(id)
            {
                case 29:color = "{5555FF}";
                case 35:color = "{00FFFF}";
                default:color = "{FFFF00}";
            }
        }
    }
    
    cache_delete(result);
    return 1;
}

CMD:setadmin(playerid, params[])
{
    if(!(GetPlayerAdminEx(playerid) >= 9)) return 1;

    if(sscanf(params, "u", params[0]))
    return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Используйте {FFFF00}/setadmin {FFFFFF}[ID игрока]");

    if(!IsPlayerConnected(params[0]) || params[0] == playerid) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Введите верный ID игрока.");

    Dialog
    (
        playerid, 1990, DIALOG_STYLE_LIST,
        "Шаблоны администрации",
        "1. Права администратора\n"\
        "2. Шаблон след.администратора\n"\
        "3. Шаблон гл.следящих \n"\
        "4. Шаблон тех.специалистов\n"\
        "5. Шаблон медиа отдела\n"\
        "6. Шаблон гл.администрации\n"\
        "7. Шаблон тестировщиков",
        "Выбрать", "Назад"
    );

    SetPVarInt(playerid, "shablon_player", params[0]);
    return 1;
}

CMD:a(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /a [текст]");

		new fmt_str[128];

		format(fmt_str, sizeof fmt_str, "{00FFFF}[%s] %s[%d]: %s", post_admin[GetPlayerAdminPost(playerid)][Post_Name], GetPlayerNameEx(playerid), playerid, params);
		SendMessageToAdmins(fmt_str, 0x0aeaf2);//тут цвет админ чата (0x0aeaf2)

		SendLog(playerid, LOG_TYPE_ADMIN_CHAT, params);
	}

	return 1;
}
