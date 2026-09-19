#include <YSI_Coding\y_hooks>

new bool:player_wedding_ring[MAX_PLAYERS];

#define br   "{FF6347}"
#define we_c   "{B9234B}"
new p_wedding, p_wedding_exit, p_wedding_car, p_wedding_menu;
hook OnGameModeInit()
{
    p_wedding = CreateDynamicSphere(-2512.555908,2910.743164,40.274486, 1.0);
    p_wedding_exit = CreateDynamicSphere(2500.420898,2500.220703,1500.997192, 1.0, 143);
    p_wedding_menu = CreateDynamicSphere(2534.543945,2526.558593,1501.286254, 3.0, 143);
    p_wedding_car =  CreateDynamicSphere(-2507.844482,2912.990234,37.695709, 3.0);
    CreateDynamic3DTextLabel("Система свадьбы\n"we_c"Подробная информация", -1, 2534.543945,2526.558593,1501.286254 + 1.0, 10.0);
    CreateDynamic3DTextLabel(""we_c"Аренда свадебного транспорта\n{FFFFFF}Встаньте на пикап, чтобы посмотреть доступные\nдля аренды транспортные средства", -1, -2507.844482,2912.990234,37.695709 + 1.0, 10.0);
    return Y_HOOKS_CONTINUE_RETURN_1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1430)
    {
        if(response)
        {    
            switch(listitem)
            {
                case 0:
                {
                    Dialog
                    (
                        playerid, -1, DIALOG_STYLE_MSGBOX,
                        ""br""SERVER_NAME" | Подробнее о свадьбах",
                        "Свадьба - это одно из самых судьбоносных событий в жизни молодой пары\n"\
                        "и воистину их первый и главный бал любви, который запомнится на всю жизнь, а\n"\
                        "также откроет совершенно новую для них - совместную, семейную жизнь.\n"\
                        "По истине сказочное событие, которое ждёт с нетерпением каждая любящая друг\n"\
                        "друга пара. Каждая свадьба сулит о новой интересной страничке в совместной\n"\
                        "жизни. Однако, очень важно, чтобы это событие было невероятно ярким,\n"\
                        "запоминающимся, чувственным и эмоционально наполненным.\n\n"\
                        "Каждое мероприятие должно наполняться позитивом, эмоциями, смехом,,\n"\
                        "улыбками, красками и оригинальностью. И свадебное торжество не,\n"\
                        "исключение. Это событие олицетворяет чистоту, нежность и любовь, которые,\n"\
                        "поселились в сердцах двух влюблённых. Поэтому к организации свадьбы,\n"\
                        "нужно отнестись очень ответственно, чтобы этот важный день был самым,\n"\
                        "приятным воспоминанием в жизни молодоженов.,\n\n"\
                        ""we_c"/wedding [ид игрока]{FFFFFF} - предложить своей половинке пожениться.,\n"\
                        ""we_c"/divorce{FFFFFF} - развестись со своей половинкой.,\n"\
                        ""we_c"/kiss [ид игрока]{FFFFFF} - предложить своей половинке поцеловаться.",
                        "Закрыть", ""
                    );
                }
                case 1:
                {
                        Dialog
                        (
                            playerid, 1401, DIALOG_STYLE_MSGBOX, 
                            ""br""SERVER_NAME"  | Обручальные кольца",
                            ""we_c"Обручальное кольцо{FFFFFF} - это не просто красивый аксессуар из драгоценного\n"\
                            "металла с бриллиантами, которое носят на безымянном пальце левой или правой\n"\
                            "руки. Обручальное кольцо - нечто большее, это своеобразный знак верности,\n"\
                            "глубокого чувства и вечной любви...\n\n"\
                            ""we_c"Стоимость обручальных колец:{FFFFFF} 100.000 рублей.",
                            "Купить", "Отмена"
                        );
                }
            }
        }       
    }
    if(dialogid == 1401)
    {
        if(response)
        {
            if(GetPlayerMoneyEx(playerid) < 100000) return Send(playerid, -1, ""USC" Недостаточно средств. У вас должно быть 100.000 рублей");
            if(GetPlayerData(playerid, P_WIFE)) return Send(playerid, -1, ""USC" Вы уже в браке!");
            if(player_wedding_ring[playerid]) return Send(playerid, -1, ""USC" У Вас уже есть обручальные кольца");

            GivePlayerMoneyEx(playerid, -100000);
            player_wedding_ring[playerid] = true;

            Send(playerid, -1, ""SC" Вы купили обручальные кольца");
            return 1;
        }
    }
    if(dialogid == 1402)
    {
        if(response)
        {
            new to_player = GetPVarInt(playerid, "player_wedding");

            format
            (
                  string256, sizeof string256, 
                 "В нашей области появился новый прекрасный брак - %s и %s.\n"\
                  "Давайте все вместе пожелаем им удачи, счастья и большого благополучия в семейной\n"\ 
                  "- жизни!", GetPlayerNameEx(to_player), GetPlayerNameEx(to_player)
            );
            SendClientMessageToAll(0xB9234BFF, string256);

            SetPlayerData(playerid, P_WIFE, to_player);
            SetPlayerData(to_player, P_WIFE, playerid);

            UpdatePlayerDatabaseInt(playerid, "wife", to_player);
            UpdatePlayerDatabaseInt(to_player, "wife", playerid);


            new name[16], surname[16];
            sscanf(GetPlayerData(to_player, P_NAME),"p<_>s[16]s[16]", name, surname);

            if(!(strlen(surname))|| !(strlen(surname))) return Send(playerid, -1, ""USC" Смена фамалии не возможна");

            format(string64, sizeof string64, "Вы хотите изменить вашу фамалию на %s", surname);

            Dialog
            (
                playerid, 1405, DSM,
                ""br" "SERVER_NAME"| Смена фамилии",
                string64,
                "Сменить", "Выйти"
            );
        }   
    }
    if(dialogid == 1403)
    {
        if(response)
        {
            new Cache:name, wife = GetPlayerData(playerid, P_WIFE), rows;

            if(!IsPlayerConnected(wife)) //если игрок не в сети
            {
                mysql_format(mysql, string128, sizeof string128, "SELECT name FROM accounts WHERE id = %d", wife);
	            name = mysql_query(mysql, string64, true);

	            rows = cache_num_rows();

                SetPlayerData(playerid, P_WIFE, 0);
                UpdatePlayerDatabaseInt(playerid, "wife", 0);

                mysql_format(mysql, string128, sizeof string128, "UPDATE accounts SET wife = 0 WHERE id = %d", wife);
	            mysql_query(mysql, string128, false);
                if(mysql_errno()) return print("Ошибка в запросе [system_wedding | 1]");

                if(!rows) return Send(playerid, -1, ""USC" Ошибка! Обратитесь на форум");

                format(string128, sizeof string128, ""we_c"| {FFFFFF}Вы успешно развелись со своей второй половинкой - "we_c"%s", rows);

                Send(playerid, -1, string128);

                cache_delete(name);
            }
            else
            {
                SetPlayerData(wife, P_WIFE, 0);
                UpdatePlayerDatabaseInt(wife, "wife", 0);

                SetPlayerData(playerid, P_WIFE, 0);
                UpdatePlayerDatabaseInt(playerid, "wife", 0);

                format(string64, sizeof string64, ""we_c"| {FFFFFF}Вы успешно развелись со своей второй половинкой - "we_c"%s", GetPlayerNameEx(wife));

                Send(playerid, -1, string64);
            }
            return 1;
        }
    }
    if(dialogid == 1404)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    new Float:x,Float:y,Float:z;
                    GetPlayerPos(playerid, x,y,z);
                    PutPlayerInVehicle(playerid, CreateVehicle(596, x,y,z, 0.0, 0,0, 2), 0);
                    return 1;
                }
    
            }
        }
    }
    if(dialogid == 1405)
    {
        if(response)
        {

            new name[10], surname[10], to_name[16], to_surname[16], pname[20+1], to_player = GetPVarInt(playerid, "player_wedding");

            if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return Send(playerid, -1, ""USC" Игрок вышел из игры.");

            sscanf(GetPlayerData(playerid, P_NAME),"p<_>s[16]s[16]", name, surname); //узнаю имя и фамилию игрока который согласился

            sscanf(GetPlayerData(to_player, P_NAME),"p<_>s[16]s[16]", name, surname); //узнаю имя и фамилию игрока который предложил

            format(pname, sizeof pname, "%s_%s", name, surname);

            SetPlayerData(playerid, P_NAME, pname);
            SetPlayerName(playerid, pname);
            UpdatePlayerDatabaseString(playerid, "name", pname);//хзвазе пока кактаблица называется

            format(string128, sizeof string128, "[Смена имени] %s сменил имя на %s", GetPlayerNameEx(playerid), pname);
            SendClientMessageToAll(0x73FF00FF, string128);

            format(string128, sizeof string128, ""we_c"| Ваша вторая половинка сменила никнейм на "we_c"%s", pname);
            Send(to_player, 0xFFFFFFFF, string128);
            return 1;
        }  
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}
//СОЗДАНИЕ ДИОЛОГОВ

/*Dialog_Create:wedding_menu(playerid)
{
    Dialog_Open
    (
        playerid, Dialog:wedding_menu, DSL, 
        ""br""SERVER_NAME" {FFFFFFF}| Меню системы свадьбы",
        ""br"1. {FFFFFF}Подробная информация о свадьбах\n"\
        ""br"2. {FFFFFF}Покупка обручальных колец",
        "Выбрать", "Закрыть"
    );
}

Dialog_Create:wedding_info(playerid)
{
    Dialog_Open
    (
        playerid, Dialog:wedding_info, DIALOG_STYLE_MSGBOX,
        ""br""SERVER_NAME" | Подробнее о свадьбах",
        "Свадьба - это одно из самых судьбоносных событий в жизни молодой пары\n"\
        "и воистину их первый и главный бал любви, который запомнится на всю жизнь, а\n"\
        "также откроет совершенно новую для них - совместную, семейную жизнь.\n"\
        "По истине сказочное событие, которое ждёт с нетерпением каждая любящая друг\n"\
        "друга пара. Каждая свадьба сулит о новой интересной страничке в совместной\n"\
        "жизни. Однако, очень важно, чтобы это событие было невероятно ярким,\n"\
        "запоминающимся, чувственным и эмоционально наполненным.\n\n"\
        "Каждое мероприятие должно наполняться позитивом, эмоциями, смехом,,\n"\
        "улыбками, красками и оригинальностью. И свадебное торжество не,\n"\
        "исключение. Это событие олицетворяет чистоту, нежность и любовь, которые,\n"\
        "поселились в сердцах двух влюблённых. Поэтому к организации свадьбы,\n"\
        "нужно отнестись очень ответственно, чтобы этот важный день был самым,\n"\
        "приятным воспоминанием в жизни молодоженов.,\n\n"\
        ""we_c"/wedding [ид игрока]{FFFFFF} - предложить своей половинке пожениться.,\n"\
        ""we_c"/divorce{FFFFFF} - развестись со своей половинкой.,\n"\
        ""we_c"/kiss [ид игрока]{FFFFFF} - предложить своей половинке поцеловаться.",
        "Закрыть", ""
    );
}

Dialog_Create:wedding_buy(playerid)
{
    Dialog_Open
    (
        playerid, Dialog:wedding_buy, DIALOG_STYLE_MSGBOX, 
        ""br""SERVER_NAME"  | Обручальные кольца",
        ""we_c"Обручальное кольцо{FFFFFF} - это не просто красивый аксессуар из драгоценного\n"\
        "металла с бриллиантами, которое носят на безымянном пальце левой или правой\n"\
        "руки. Обручальное кольцо - нечто большее, это своеобразный знак верности,\n"\
        "глубокого чувства и вечной любви...\n\n"\
        ""we_c"Стоимость обручальных колец:{FFFFFF} 100.000 рублей.",
        "Купить", "Отмена"
    );
}

Dialog_Create:wedding_yes(playerid, to_player)
{
    format(string128, sizeof string128, "Игрок %s предложил Вам брак.\nВы соглашаетесь на предложение", GetPlayerNameEx(to_player));

    Dialog_Open 
    (
        playerid, Dialog:wedding_yes, DIALOG_STYLE_MSGBOX,
        ""br""SERVER_NAME" | Согласие на брак",
        string128, 
        "Далее", "Назад"
    );
    return 1;
}

Dialog_Create:wedding_plname(playerid, nick)
{
    format(string64, sizeof string64, "Вы хотите изменить вашу фамалию на %s", nick);
    Dialog_Open
    (
        playerid, Dialog:wedding_plname, DSM,
        ""br" "SERVER_NAME"| Смена фамилии",
        string64,
        "Сменить", "Выйти"
    );
    return 1;
}

Dialog_Create:wedding_divorce(playerid)
{
    Dialog_Open(playerid, Dialog:wedding_divorce, DSM, "Вы действительно желаете расторгнуть брак со своей второй половинкой?", "Да", "Отмена");
    return 1;
}

Dialog_Create:wedding_menu_car(playerid)
{
    Dialog_Open
    (
        playerid, Dialog:wedding_menu_car, DSL, 
       ""br" "SERVER_NAME"| Аренда транспорта",
       "BMW M5 F90 | 60000 р",
       "Взять", "Назад"
    );
    return 1;
}*/
//ОСТАЛЬНОЙ КОД

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if(areaid == p_wedding)
    {
        SetPlayerPosEx(playerid, 2501.875244,2500.405273,1500.997192,278.195495, 1, 143);
        return 1;
    }
    if(areaid == p_wedding_exit)
    {
        SetPlayerPosEx(playerid, -2512.592285,2912.512939,40.274486, 0, 0);
        return 1;
    }
    if(areaid == p_wedding_menu)
    {
        Dialog
        (
            playerid, 1430, DSL, 
            ""br""SERVER_NAME" {FFFFFFF}| Меню системы свадьбы",
            ""br"1. {FFFFFF}Подробная информация о свадьбах\n"\
            ""br"2. {FFFFFF}Покупка обручальных колец",
            "Выбрать", "Закрыть"
        );
    }
    if(areaid == p_wedding_car)
    {
        Dialog
        (
            playerid, 1404, DSL, 
           ""br" "SERVER_NAME"| Аренда транспорта",
           "BMW M5 F90 | 60000 р",
           "Взять", "Назад"
        );
        return 1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

/*DialogResponse:wedding_menu(playerid, response, listitem, inputtext[])
{
	if (!response) {
		return 1;
	}
        switch(listitem)
        {
            case 0:
            {
                Dialog_Show::wedding_info(playerid);
                return 1;
            }
            case 1:
            {
                Dialog_Show::wedding_buy(playerid);
                return 1;
            }
        }
}*/

/*DialogResponse:wedding_menu_car(playerid, response, listitem, inputtext[])
{

    if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                new Float:x,Float:y,Float:z;
                GetPlayerPos(playerid, x,y,z);
                PutPlayerInVehicle(playerid, CreateVehicle(596, x,y,z, 0.0, 0,0, 2), 0);
                return 1;
            }

        }
    }
    return 1;
}
DialogResponse:wedding_buy(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPlayerMoneyEx(playerid) < 100000) return Send(playerid, -1, ""USC" Недостаточно средств. У вас должно быть 100.000 рублей");
        if(GetPlayerData(playerid, P_WIFE)) return Send(playerid, -1, ""USC" Вы уже в браке!");
        if(player_wedding_ring[playerid]) return Send(playerid, -1, ""USC" У Вас уже есть обручальные кольца");

        GivePlayerMoneyEx(playerid, -100000);
        player_wedding_ring[playerid] = true;

        Send(playerid, -1, ""SC" Вы купили обручальные кольца");
        return 1;
    }
}*/

CMD:wedding(playerid, params[])
{

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /wedding [id игрока]");
        
    extract params -> new to_wife;

    if(!IsPlayerConnected(to_wife) || !IsPlayerLogged(to_wife) || to_wife == playerid)
	return Send(playerid, -1, "Такого игрока нет");

    new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_wife, to_x, to_y, z);

	new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);

    if(GetPlayerVirtualWorld(playerid) != 143) return Send(playerid, -1, ""USC" Вы должны находиться в ЗАГСе");

    if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(to_wife) || dist <= 10.0) return Send(playerid, -1, "Игрок далеко от вас");

    if(GetPlayerData(to_wife, P_WIFE)) return Send(playerid, -1, "У Игрока уже есть вторая половинка");
   
    format(string64, sizeof string64, "Вы предложили игроку %s вступить в брак", GetPlayerNameEx(to_wife));
    Send(playerid, 0x006EFFFF, string64);

    format(string64, sizeof string64, "Игрок %s делает вам предложение", GetPlayerNameEx(playerid));
    SetPVarInt(to_wife, "player_wedding", playerid);
    ShowNewNotification(to_wife, 4, 7, 3, ENTER_WEDDING, string64, ">>");
    return 1;
}

CMD:yes_wedding(playerid)
{
    new to_player = GetPVarInt(playerid, "player_wedding");

    if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(to_player))
        return Send(playerid, -1, "Игрок далеко от вас");

    if(GetPlayerData(to_player, P_WIFE) || GetPlayerData(playerid, P_WIFE)) return Send(playerid, -1, "У Игрока уже есть вторая половинка");
    format(string128, sizeof string128, "Игрок %s предложил Вам брак.\nВы соглашаетесь на предложение", GetPlayerNameEx(to_player));

    Dialog
    (
        playerid, 1402, DIALOG_STYLE_MSGBOX,
        ""br""SERVER_NAME" | Согласие на брак",
        string128, 
        "Далее", "Назад"
    );
    
    return 1;
}

/*DialogResponse:wedding_yes(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new to_player = GetPVarInt(playerid, "player_wedding");

        format
        (
              string256, sizeof string256, 
             "В нашей области появился новый прекрасный брак - %s и %s.\n"\
              "Давайте все вместе пожелаем им удачи, счастья и большого благополучия в семейной\n"\ 
              "- жизни!", GetPlayerNameEx(to_player), GetPlayerNameEx(to_player)
        );
        SendClientMessageToAll(we_c, strin256);

        SetPlayerData(playerid, P_WIFE, to_player);
        SetPlayerData(to_player, P_WIFE, playerid);

        UpdatePlayerDatabaseInt(playerid, "wife", to_player);
        UpdatePlayerDatabaseInt(to_player, "wife", playerid);


        new name[16], surname[16];
        sscanf(GetPlayerData(to_player, P_NAME),"p<_>s[16]s[16]", name, surname);

        if(!(name || surname)) return Send(playerid, -1, ""USC" Смена фамалии не возможна");

        format(string64, sizeof string64, "Вы хотите изменить вашу фамалию на %s", nick);

        Dialog_Show::wedding_plname(plaeyrid, nick);
        return 1;
    }   
}*/

/*DialogResponse:wedding_plname(playerid, response, listitem, inputtext[])
{
    if(response)
    {

        new name[16], surname[16], to_name[16], to_surname[16], pname[32], to_player = GetPVarInt(playerid, "player_wedding");

        if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return Send(playerid, -1, ""USC" Игрок вышел из игры.");

        sscanf(GetPlayerData(playerid, P_NAME),"p<_>s[16]s[16]", name, surname); //узнаю имя и фамилию игрока который согласился

        sscanf(GetPlayerData(to_player, P_NAME),"p<_>s[16]s[16]", name, surname); //узнаю имя и фамилию игрока который предложил

        format(pname, sizeof pname, "%s_%s", name, surname);

        SetPlayerData(plaeyrid, P_NAME, pname);
        SetPlayerName(playerid, pname);
        UpdatePlayerDatabaseInt(plaeyrid, "name", pname);//хзвазе пока кактаблица называется

        format(string128, sizeof string128, "[Смена имени] %s_%s сменил имя на", name, surname, pname);
        SendClientMessageToAll(0x73FF00FF, string128);

        format(string128, sizeof string128, ""we_c"| Ваша вторая половинка сменила никнейм на "we_c"%s", pname);
        Send(to_player, 0xFFFFFFFF, string128);
        return 1;
    }
}*/

CMD:divorce(playerid)
{
    if(!GetPlayerData(playerid, P_WIFE)) return Send(playerid, -1, ""USC" У вас нету второй половинки");

    Dialog(playerid, 1403, DSM, "Вы действительно желаете расторгнуть брак со своей второй половинкой?", "Да", "Отмена");
    return 1;
}

/*DialogResponse:wedding_divorce(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new Cache:name, wife = GetPlayerData(playerid, P_WIFE);

        if(!IsPlayerConnected(wife)) //если игрок не в сети
        {
            mysql_format(mysql, query, sizeof query, "SELECT name FROM accounts WHERE id = %d", wife);
	        name = mysql_query(mysql, query, true);

	        rows = cache_num_rows();

            SetPlayerData(playerid, P_WIFE, 0);
            UpdatePlayerDatabaseInt(playerid, "wife", 0);

            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET wife = 0 WHERE id = %d", wife);
	        mysql_query(mysql, query, false);
            if(mysql_errno()) return print("Ошибка в запросе [system_wedding | 1]");

            if(!rows) return Send(playerid, -1, ""USC" Ошибка! Обратитесь на форум");
            format(string64, sizeof string64, ""we_c"| {FFFFFF}Вы успешно развелись со своей второй половинкой - "we_c"%s", rows);

            Send(playerid, -1, string64);

            cache_delete(name);
        }
        else
        {
            SetPlayerData(wife, P_WIFE, 0);
            UpdatePlayerDatabaseInt(wife, "wife", 0);

            SetPlayerData(playerid, P_WIFE, 0);
            UpdatePlayerDatabaseInt(playerid, "wife", 0);

            format(string64, sizeof string64, ""we_c"| {FFFFFF}Вы успешно развелись со своей второй половинкой - "we_c"%s", GetPlayerNameEx(wife));

            Send(playerid, -1, string64);
        }
        return 1;
    }
}*/