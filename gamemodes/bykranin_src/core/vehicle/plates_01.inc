//>> Файл: bykranin_src/core/vehicle/plates_01.inc  (405 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: /tab, bgrodster, /bg, /bgoff, bgrod, okdadrugoi, StopPlayerBegging
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
cmd:tab(playerid){
	new JSON:response = JSON_Object();
            
            // Создаем массив игроков
            new JSON:playersArray = JSON_Array();
            new playerIndex = 0;
            
            foreach(new i : Player)
            {
                if(!IsPlayerConnected(i)) continue;
                
                new JSON:playerObj = JSON_Object();
                JSON_SetInt(playerObj, "id", i);
                new name[MAX_PLAYER_NAME];
                GetPlayerName(i, name, sizeof(name));
				JSON_SetInt(playerObj, "level", GetPlayerData(i, P_LEVEL));
				
                JSON_SetString(playerObj, "nick", name);
                 
                
                JSON_SetInt(playerObj, "ping", GetPlayerPing(i));
                
                playersArray = JSON_Append(playersArray, JSON_Array(playerObj));
                JSON_Cleanup(playerObj);
                playerIndex++;
                
                printf("[CASE 25][TYPE 1] Добавлен игрок %d: %s", i, name);
            }
            
            printf("[CASE 25][TYPE 1] Всего добавлено игроков: %d", playerIndex);
            
            JSON_SetArray(response, "data", playersArray);
            JSON_SetInt(response, "t", 1);
			JSON_SetInt(response, "o", playersArray);
            
            // Отправляем ответ
            new jsonString[4096];
            JSON_Stringify(response, jsonString, sizeof(jsonString));
            printf("[CASE 25][TYPE 1] JSON ответ (первые 200 символов): %.200s", jsonString);
            
            ShowPlayerGUI(playerid, 25, response);
            
            // Очистка
            JSON_Cleanup(playersArray);
            JSON_Cleanup(response);
            
            return 1;
}

 

stock bgrodster(playerid)
{
ygygydodo_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 428.6667, 336.4297, "USE"); // generated
PlayerTextDrawLetterSize(playerid, ygygydodo_PTD[playerid][0], 0.5763, 2.9813);
PlayerTextDrawAlignment(playerid, ygygydodo_PTD[playerid][0], 1);
PlayerTextDrawColor(playerid, ygygydodo_PTD[playerid][0], -1);
PlayerTextDrawBackgroundColor(playerid, ygygydodo_PTD[playerid][0], 255);
PlayerTextDrawFont(playerid, ygygydodo_PTD[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, ygygydodo_PTD[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, ygygydodo_PTD[playerid][0], 0);

ygygydodo_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 464.3333, 335.6001, "/BG"); // generated
PlayerTextDrawLetterSize(playerid, ygygydodo_PTD[playerid][1], 0.6169, 3.1223);
PlayerTextDrawAlignment(playerid, ygygydodo_PTD[playerid][1], 1);
PlayerTextDrawColor(playerid, ygygydodo_PTD[playerid][1], 16711935);
PlayerTextDrawBackgroundColor(playerid, ygygydodo_PTD[playerid][1], 255);
PlayerTextDrawFont(playerid, ygygydodo_PTD[playerid][1], 1);
PlayerTextDrawSetProportional(playerid, ygygydodo_PTD[playerid][1], 1);
PlayerTextDrawSetShadow(playerid, ygygydodo_PTD[playerid][1], 0);

ygygydodo_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 428.0000, 358.0000, "+10"); // generated
PlayerTextDrawLetterSize(playerid, ygygydodo_PTD[playerid][2], 0.6446, 3.0767);
PlayerTextDrawAlignment(playerid, ygygydodo_PTD[playerid][2], 1);
PlayerTextDrawColor(playerid, ygygydodo_PTD[playerid][2], 16711935);
PlayerTextDrawBackgroundColor(playerid, ygygydodo_PTD[playerid][2], 255);
PlayerTextDrawFont(playerid, ygygydodo_PTD[playerid][2], 1);
PlayerTextDrawSetProportional(playerid, ygygydodo_PTD[playerid][2], 1);
PlayerTextDrawSetShadow(playerid, ygygydodo_PTD[playerid][2], 0);

ygygydodo_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 466.6667, 356.3407, "rublei"); // generated
PlayerTextDrawLetterSize(playerid, ygygydodo_PTD[playerid][3], 0.5946, 2.9896);
PlayerTextDrawAlignment(playerid, ygygydodo_PTD[playerid][3], 1);
PlayerTextDrawColor(playerid, ygygydodo_PTD[playerid][3], -1);
PlayerTextDrawBackgroundColor(playerid, ygygydodo_PTD[playerid][3], 255);
PlayerTextDrawFont(playerid, ygygydodo_PTD[playerid][3], 1);
PlayerTextDrawSetProportional(playerid, ygygydodo_PTD[playerid][3], 1);
PlayerTextDrawSetShadow(playerid, ygygydodo_PTD[playerid][3], 0);
}

cmd:bg(playerid)
{
SPD(playerid,DIALOG_BG,DIALOG_STYLE_MSGBOX,"{FFA500}Попрошайничество","{1565C0}Вы начали попрошайничать деньги у прохожих\n{FFFFFF}За каждую минуту Вы будете получать: {008000}10 рублей\n{FFFFFF}За час выходит: {008000}600 рублей\n{FFFFFF}За 24 часа: {008000}14400 рублей\n{FFFFFF}За 48 часов: {008000}28800 рублей\n \n{808080}Заниматся попрошайничеством можно с 1-го по 3-ый уровень\n{808080}Вы можете даже находясь в AFK.Это даст Вам возможность\n{808080}заработать денег на первое время.","Закрыть","");
ApplyAnimation(playerid, "INT_HOUSE", "BED_LOOP_L", 4.1, 1, 1, 1, 1, 0, 1);
}

cmd:bgoff(playerid)
{
    StopPlayerBegging(playerid);
    ClearAnimations(playerid);
    return 1;
}

forward bgrod(playerid);
public bgrod(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        StopPlayerBegging(playerid);
        return 0;
    }

    GivePlayerMoney(playerid, 10);
    bgrodster(playerid);
    bg_textdraw_created[playerid] = true;
    for(new i = 0; i < 4; i++)
    {
        PlayerTextDrawShow(playerid, ygygydodo_PTD[playerid][i]);
    }

    if(bg_hide_timer[playerid] != 0) KillTimer(bg_hide_timer[playerid]);
    bg_hide_timer[playerid] = SetTimerEx("okdadrugoi", 7 * 1000, false, "i", playerid);
    return 1;
}

forward okdadrugoi(playerid);
public okdadrugoi(playerid)
{
    bg_hide_timer[playerid] = 0;
    if(!IsPlayerConnected(playerid)) return 0;

    if(bg_textdraw_created[playerid])
    {
        for(new i = 0; i < 4; i++)
        {
            PlayerTextDrawHide(playerid, ygygydodo_PTD[playerid][i]);
            PlayerTextDrawDestroy(playerid, ygygydodo_PTD[playerid][i]);
        }
        bg_textdraw_created[playerid] = false;
    }
    return 1;
}

stock StopPlayerBegging(playerid)
{
    if(bg_income_timer[playerid] != 0)
    {
        KillTimer(bg_income_timer[playerid]);
        bg_income_timer[playerid] = 0;
    }
    if(bg_hide_timer[playerid] != 0)
    {
        KillTimer(bg_hide_timer[playerid]);
        bg_hide_timer[playerid] = 0;
    }
    if(bg_textdraw_created[playerid])
    {
        for(new i = 0; i < 4; i++)
        {
            PlayerTextDrawHide(playerid, ygygydodo_PTD[playerid][i]);
            PlayerTextDrawDestroy(playerid, ygygydodo_PTD[playerid][i]);
        }
        bg_textdraw_created[playerid] = false;
    }
    return 1;
}

stock DialogTAB(playerid, dialogid, style, title[], text[], button[], button2[])
{
  if(style == 5)
  {
     ShowPlayerDialog(playerid, DIALOG_TESTERSKII, DIALOG_STYLE_LIST, "...", "...", "...", "");
  }
  ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
  return 1;//tetstdt
}

CMD:airdrop(playerid)
{
    new drop, text[185], list[sizeof text * 10 + 50] = "test\tdtest\n";

    new Float:dist;
    
   format(text, sizeof text, "{FFFFFF}1. Замер 100 км/ч\n", dist);
        strcat(list, text);
 	DialogTAB(playerid, DIALOG_TESTERSKII, DIALOG_QM, "КУКУ", text, "закрыть", "ебанько?");
    return 1;
}

cmd:ffsgssddssdfAWDAEWEFaeokgeijpagdafd(playerid)
{
    Dialog
 (
	playerid, DIALOG_CHANGEPROPTIP, DIALOG_STYLE_LIST,
	"{00FFFF}"SERVER_NAME"{ffffff} | Выберете тип имущества",
	"{FFFF00}#1.\t\t\t\t{ffffff}Дом/квартира \t\t\t\t\t{888888}Нажмите для взаимодействия\n\
	{FFFF00}#2.\t\t\t\t{ffffff}Машина\t\t\t\t\t{888888}Нажмите для взаимодействия\n\
	{FFFF00}#3.\t\t\t\t{ffffff}Гараж\t\t\t\t\t{888888}Нажмите для взаимодействия",

	 "Выбрать",
	 "Выйти"
 );
 return 1;
}

cmd:ffsgssddssdfAWDAEWEFfadfjapo(playerid)
{
    Dialog
 (
	playerid, DIALOG_CHANGEPROPDOPLATA, DIALOG_STYLE_LIST,
	"{00FFFF}"SERVER_NAME"{ffffff} | Предоплата",
	"1. Без доплаты\n\
	2. Доплачиваете Вы\n\
	3. Доплачивает игрок",

	 "Выбрать",
	 "Выйти"
 );
 return 1;
}

cmd:ffsgssddssdfAWDAEWEFdaksfjoaifj(playerid)
{
    Dialog
 (
	playerid, DIALOG_CHANGEPROPSKOKDP, DIALOG_STYLE_INPUT,
	"{00FFFF}"SERVER_NAME"{ffffff} | Обмен",
	"Введите сумму которую Вам должны доплатить за обмен",

	 "Обмен",
	 "Выйти"
 );
 return 1;
}

cmd:ffsgssddsaetgadfFxzfeq325fkjfzrttr(playerid)
{
    Dialog
 (
	playerid, DIALOG_CHANGEPROPOBMENV, DIALOG_STYLE_LIST,
	"{00FFFF}"SERVER_NAME"{ffffff} | Выберете что обменять",
	"{FFFF00}#38237998\t\t{ffffff}Bugatti Divo\t\t\t\t{888888}Нажмите для взаимодействия\n\
   {FFFF00}№352\t\t{ffffff}Bugatti Chiron\t\t{888888}Нажмите для взаимодействия\n\
	 {FFFF00}№388\t\t{ffffff}Bugatti La Noire\t\t{888888}Нажмите для взаимодействия\n\
 	{FFFF00}№382\t\t{ffffff}Bmw M5 F90\t\t{888888}Нажмите для взаимодействия",

	 "Выбрать",
	 "Выйти"
 );
 return 1;
}

CMD:reklama(playerid)
{
	if(GetPlayerAdminEx(playerid)< 13) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
    new fmt_msg[999];
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] проинформировал сервер заявлением \"Счасливыми часами\".", GetPlayerNameEx(playerid), playerid);

	 SendClientMessageToAll(0xFFFFFFFF, "{FA8072}Счастливые часы | {32CD32}При получении зарплаты на каждой из доступных работ она будет умножаться в{00FA9A} X2{32CD32} раза.");
     SendClientMessageToAll(0xFFFFFFFF, "{FA8072}Счастливые часы | {32CD32}Каждый 'PayDay' на сервере Вы будете получать в{00FA9A} X2{32CD32} раза больше очков опыта (EXP).");
     SendClientMessageToAll(0xFFFFFFFF, "{FA8072}Счастливые часы | {32CD32}При пополнении баланса аккаунта (Black Coin)- сумма пополнения будет умножаться в{00FA9A} X2{32CD32} раза!");
     SendClientMessageToAll(0xFFFFFFFF, "{FA8072}Счастливые часы | {32CD32}Пополнить счет своего игрового аккаунта можно прямо в лаунчере, или через сайт: {00FA9A}"SERVER_SITE"");
return 1;
}

CMD:cevent(playerid, params[])
{
	SendClientMessage(playerid, -1, "{E4A010} Вы успешно покинули место проведения мероприятия.");
	SpawnPlayer(playerid);

	SetPlayerData(playerid, P_LAST_MP, 0);

	return 1;
}

CMD:sobes(playerid,params[])//kinder
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
 	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна только лидеру и заместителям организации");

	Dialog
	(
	playerid, 5004, DIALOG_STYLE_LIST,
	"{00FFFF}"SERVER_NAME"{ffffff} | Оповещение об активном собеседовании",
	"- Центральная больница\n\
	- Армия\n\
	- Правительство\n\
	- ГИБДД\n\
	- ФСБ\n\
	- ФСИН\n\
	- УМВД\n\
	- СМИ",
	"Выбрать",
	"Закрыть"
	);
	return 1;
}
						
CMD:spawn1(playerid)
{
    if(GetPlayerData(playerid, P_JAIL) > 0)
        return SendClientMessage(playerid, COLOR_RED, "Вы не можете использовать эту команду, пока находитесь в тюрьме!");
    
    return SetPlayerPosEx(playerid, -2159.371093, 1558.103271, 9.840852, 0, 0);
}

CMD:spawn2(playerid)
{
    if(GetPlayerData(playerid, P_JAIL) > 0)
        return SendClientMessage(playerid, COLOR_RED, "Вы не можете использовать эту команду, пока находитесь в тюрьме!");
    
    return SetPlayerPosEx(playerid, -2667.526611, 2006.567016, 11.197804, 0, 0);
}

CMD:spawn3(playerid)
{
    if(GetPlayerData(playerid, P_JAIL) > 0)
        return SendClientMessage(playerid, COLOR_RED, "Вы не можете использовать эту команду, пока находитесь в тюрьме!");
    
    return SetPlayerPosEx(playerid, 1804.651611, 2517.014648, 14.633841, 124.989479, 0, 0);
}

forward RestartServer();

public RestartServer()
{
	SendClientMessageToAll(-1, " {CA0303} Уважаемые игроки сейчас произойдет перезапуск сервера!");

	foreach(new i : Player)
	{
		OnPlayerDisconnect(i, 0);
	}

	server_restart = true;
	return GameModeExit();
}

CMD:RentCarScooterBR(playerid)
{
ShowRentMenu(playerid);
}

CMD:disarm(playerid, params[])
{
    if(!strcmp(params, "all", true))
    {
        for(new i = 0; i < MAX_PLAYERS; i++)
            if(IsPlayerConnected(i))
                ResetPlayerWeapons(i);
                
        SendClientMessageToAll(-1, "Оружие у всех игроков было убрано.");
        return 1;
    }
    
    ResetPlayerWeapons(playerid);
    SendClientMessage(playerid, -1, "Вы сняли с себя всё оружие.");
    return 1;
}

CMD:skin(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 7)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    // to_player, skin_id are declared in extract below
    extract params -> new to_player, skin_id; else
        return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /skin [id игрока] [id скина]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

    if(!(2 <= skin_id <= 20000000))
        return SendClientMessage(playerid, 0xCECECEFF, ""SC"ID скина от 2 до 20000000");

    new old_skin_id = GetPlayerData(to_player, P_SKIN);
    SetPlayerData(to_player, P_SKIN, skin_id);
    UpdatePlayerDatabaseInt(to_player, "skin", skin_id);
    SetPlayerSkinInit(to_player);

    new fmt_text[144];

    if(to_player == playerid)
    {
        format(fmt_text, sizeof fmt_text, "{1E90FF}Вы установили себе скин №%d", skin_id);
        SendClientMessage(playerid, -1, fmt_text);
    }
    else
    {
        format(fmt_text, sizeof fmt_text, "{1E90FF}Вы установили %s[%d] скин №%d", GetPlayerNameEx(to_player), to_player, skin_id);
        SendClientMessage(playerid, -1, fmt_text);

        format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] установил Вам скин №%d", GetPlayerNameEx(playerid), playerid, skin_id);
        SendClientMessage(to_player, -1, fmt_text);
    }

    format(fmt_text, sizeof fmt_text, "{FF5533}[A] %s[%d] установил %s[%d] скин №%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, skin_id);
    SendMessageToAdmins(fmt_text, 0xCECECEFF);

    format(fmt_text, sizeof fmt_text, "Установил %s[acc:%d] скин %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), skin_id);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}

