/*
Система квестов, хорошая доработка системы реал раши
Писал Виталик крутой ок

Система на инклуде, но перед добавлением надо вырезать все выдачи призов за квесты с pwn и убрать оттуда cmd:quest
*/

#define DIALOG_VIT4LKA_QUEST 9844

stock QuestRabota(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_1) == 0)
      	{
             if(player_order_hijacker[playerid] > 0 || GetPlayerDiver(playerid, DIVER_JOOB) > 0 || player_collector[playerid][job_active] || player_mchs_active[playerid])
             {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Первая работа'. {ffffff}Ваша награда: {009900}7.500.000 руб, 10 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 7500000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_1, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_1", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 10);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
} 

stock QuestClothes(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_2) == 0)
      	{
             new fmt_text[900], // Безопасный размер для большинства случаев
             Cache: result,
             id;

             mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM inventory_skins WHERE owner_skin='%d'", GetPlayerAccountID(playerid));
             result = mysql_query(mysql, fmt_text, true);

             new rows = cache_num_rows();

             if(rows > 1)
             {
        
    
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Пора приодеться'. {ffffff}Ваша награда: {009900}2.500.000 руб, 5 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 2500000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_2, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_2", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 5);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
}

stock QuestCar(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_3) == 0)
      	{
             new fmt_text[740],
			Cache: result,
			id;

		mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
		result = mysql_query(mysql, fmt_text, true);

		new rows = cache_num_rows();

		if(rows > 0)
	    {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Это моя машина'. {ffffff}Ваша награда: {009900}15.000.000 руб, 15 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 15000000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_3, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_3", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 15);
			     UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
} 

stock QuestAcs(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_4) == 0)
      	{
               new fmt_text[900],
               Cache: result,
               id;

               mysql_format(mysql, fmt_text, sizeof(fmt_text), "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
               result = mysql_query(mysql, fmt_text, true);

               new rows = cache_num_rows();

             if(rows > 0) 
             {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Красота требует жертв'. {ffffff}Ваша награда: {009900}1.500.000 руб, 3 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 1500000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_4, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_4", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 3);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           cache_delete(result);
	           }
        	} 
	        return 1;
} 

stock QuestOrg(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_5) == 0)
      	{
             if(GetPlayerTeamEx(playerid) > 0)
             {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Вступить во фракцию'. {ffffff}Ваша награда: {009900}10.000.000 руб, 15 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 10000000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_5, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_5", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 15);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
} 

stock QuestFam(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_6) == 0)
      	{
             if(GetPlayerIdFamily(playerid) != -1) // фама велси
             {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Вступить в семью'. {ffffff}Ваша награда: {009900}7.000.000 руб, 15 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 7000000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_6, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_6", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 15);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
} 

stock QuestHome(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_7) == 0)
      	{
             if(GetPlayerHouse(playerid, HOUSE_TYPE_HOME) != -1)
             {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Дом, милый дом'. {ffffff}Ваша награда: {009900}10.000.000 руб, 7 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 10000000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_7, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_7", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 7);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
} 

stock QuestLevel(playerid)
{
      	if(GetPlayerData(playerid, P_QUEST_8) == 0)
      	{
             if(GetPlayerLevel(playerid) >= 10)
             {
         	    SendClientMessage(playerid, -1, "{ffffff}Вы успешно выполнили квест {009900}'Получить 10 уровень'. {ffffff}Ваша награда: {009900}25.000.000 руб, 30 EXP");
                 SendClientMessage(playerid, -1, "{ffffff}Введите {009900}/quest{ffffff} для дополнительной информации по квестам");
         	    GivePlayerMoneyEx(playerid, 25000000, "Выполнение квеста");

         	    SetPlayerData(playerid, P_QUEST_8, 1);
         	    UpdatePlayerDatabaseInt(playerid, "quest_8", 1);
	
             	// выдача exp и ещё если хватает для повышения лвла то отнимаем только столько exp сколько надо для повышения, а не ставим 0 как по дефолту делала реал раша, кринж
	             
			 	AddPlayerData(playerid, P_EXP, +, 30);
			UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
	 	    	if(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
		 		{
						SetPlayerData(playerid, P_EXP, GetPlayerExp(playerid) - GetExpToNextLevel(playerid));
						AddPlayerData(playerid, P_LEVEL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "level", GetPlayerData(playerid, P_LEVEL));
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerExp(playerid));
						SetPlayerLevelInit(playerid);
						new text[90];
						format(text, sizeof text, "{FFFF00}| {FFFFFF}Поздравляем! Уровень {FFFF00}Вашего персонажа {FFFFFF}повысился. Текущий уровень: {FFFF00}%d", GetPlayerLevel(playerid));
						SendClientMessage(playerid, -1, text); // дада виталька научился форматировать сам
	  			}
	           }
        	} 
	        return 1;
} 

stock ShowDialogQuest(playerid)
{
	new fmt_text[900];

	format
	(
		fmt_text,
		sizeof fmt_text,
		"{FA8072}1. "c_b"«Первая работа»\t\t\t\t%s\n"\
		"{FA8072}2. "c_b"«Пора приодеться»\t\t\t\t%s\n"\
		"{FA8072}3. "c_b"«Это моя машина»\t\t\t\t%s\n"\
		"{FA8072}4. "c_b"«Красота требует жертв»\t\t\t\t%s\n"\
		"{FA8072}5. "c_b"«Вступить в организацию»\t\t\t\t%s\n"\
		"{FA8072}6. "c_b"«Вступить в семью»\t\t\t\t%s\n"\
		"{FA8072}7. "c_b"«Дом, милый дом»\t\t\t\t%s\n"\
		"{FA8072}8. "c_b"«Получить 10 уровень»\t\t\t\t%s",
		GetPlayerData(playerid, P_QUEST_1) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_2) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_3) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_4) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_5) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_6) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_7) ? ("{009900}Выполнено") : ("{CA5757}Доступно"),
		GetPlayerData(playerid, P_QUEST_8) ? ("{009900}Выполнено") : ("{CA5757}Доступно")
	);

	Dialog
	(
		playerid, DIALOG_VIT4LKA_QUEST, DIALOG_STYLE_LIST,
		"{FA8072}"SERVER_NAME"{ffffff} | Информация по квестам",
		fmt_text,
		"Подробнее", "Закрыть"
	);

	return 1;
}

alias:quest("quests")
CMD:quest(playerid)
{
	ShowDialogQuest(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
 switch(dialogid)
 {
            case DIALOG_VIT4LKA_QUEST:
			{
				if(!response) return 1;
				if(response) return 1;

				switch(listitem)
				{
					case 0:
					{

					    if(GetPlayerData(playerid, P_QUEST_1) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Устройся на любую основную работу.\n\
							Награда: {009900}7.500.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}/gps — Основные работы"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 1:
					{

					    if(GetPlayerData(playerid, P_QUEST_2) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Приобрети любой скин в магазине одежды или в /donate.\n\
							Награда: {009900}2.500.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}/gps — Поиск ближайших мест"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 2:
					{

					    if(GetPlayerData(playerid, P_QUEST_3) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Приобретите автомобиль в автосалоне или /donate.\n\
							Награда: {009900}15.000.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}/gps — Автосалоны"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 3:
					{

					    if(GetPlayerData(playerid, P_QUEST_4) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Приобретите аксессуар в магазине аксессуаров или в /donate.\n\
							Награда: {009900}1.500.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}/gps — Поиск ближайших мест"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Маршрут", "Закрыть");
						return 1;
					}
					case 4:
					{

					    if(GetPlayerData(playerid, P_QUEST_5) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Вступи в любую организацию (ОПГ/Гос. Структуры).\n\
							Награда: {009900}10.000.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}/gps — Гос. Организации/Преступные группировки"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Маршрут", "Закрыть");
						return 1;
					}
					case 5:
					{

					    if(GetPlayerData(playerid, P_QUEST_6) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Вступи в любую семью или создай свою.\n\
							Награда: {009900}10.000.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}—"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Маршрут", "Закрыть");
						return 1;
					}
					case 6:
					{

					    if(GetPlayerData(playerid, P_QUEST_7) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[255 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Приобретите дом у государства или с рук.\n\
							Награда: {009900}10.000.000 руб\n\
							{FFFFFF}Местоположение: {FFFF00}—"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Маршрут", "Закрыть");
						return 1;
					}
					case 7:
					{

					    if(GetPlayerData(playerid, P_QUEST_8) >= 1) return ShowUvedQuest(playerid);

					    new fmt_str[270 + 1];

						format
						(
							fmt_str, sizeof fmt_str,
							"Задание: {FFFF00}Прокачайте своего персонажа до 10 уровня.\n\
							Награда: {009900}25.000.000 руб\n\
							{FFFFFF}Информация: {FFFF00}/mm — Статистика"
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FA8072}Квесты", fmt_str, "Маршрут", "Закрыть");
						return 1;
					}
				}
			}
    	}
    #if defined quest_OnDialogResponse
return quest_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse quest_OnDialogResponse
#if defined quest_OnDialogResponse
forward quest_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock ShowUvedQuest(playerid)
{
       ShowNewNotification(playerid, 2, 6, 0, 0, "Данный квест уже выполнен", "");
       ShowDialogQuest(playerid);
       return 1;
}

public: OnPlayerTimer(playerid)
{
 	if(IsPlayerLogged(playerid))
 	{
        if(GetPlayerData(playerid, P_QUEST_1) == 0 || GetPlayerData(playerid, P_QUEST_2) == 0 || GetPlayerData(playerid, P_QUEST_3) == 0 || GetPlayerData(playerid, P_QUEST_4) == 0 || GetPlayerData(playerid, P_QUEST_5) == 0 || GetPlayerData(playerid, P_QUEST_6) == 0 || GetPlayerData(playerid, P_QUEST_7) == 0 || GetPlayerData(playerid, P_QUEST_8) == 0)
        {
         CheckAllQuest(playerid);
        } 
     }
#if defined quest_OnPlayerTimer
return quest_OnPlayerTimer(playerid);
#endif
}
#if defined _ALS_OnPlayerTimer
#undef OnPlayerTimer
#else
#define _ALS_OnPlayerTimer
#endif
#define OnPlayerTimer quest_OnPlayerTimer
#if defined quest_OnPlayerTimer
forward quest_OnPlayerTimer(playerid);
#endif


public OnGameModeInit()
{
     CreateQuests();


    #if defined quest_OnGameModeInit
        return quest_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit quest_OnGameModeInit
#if defined quest_OnGameModeInit
    forward quest_OnGameModeInit();
#endif


stock CreateQuests()
{
 
  return 1;
}

stock CheckAllQuest(playerid)
{
  QuestRabota(playerid);
  QuestClothes(playerid);
  QuestCar(playerid);
  QuestAcs(playerid);
  QuestOrg(playerid);
  QuestFam(playerid);
  QuestHome(playerid);
  QuestLevel(playerid);
  return 1;
} 