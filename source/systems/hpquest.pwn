/*#if defined _hpquest_inc
	#endinput
#endif
#define _hpquest_inc
//Дефайны
#define SPD 			ShowPlayerDialog
#define DSL 			DIALOG_STYLE_LIST
#define DSM				DIALOG_STYLE_MSGBOX
//РАЗВОЗКА ТОВАРА
forward podtwo(playerid);
new podartwo[MAX_PLAYERS char],//работа
time_podtwo[MAX_PLAYERS];//таймер
new Float:podtwo_coord[7][3]=//координаты чекпоинтов
{
	{1469.3763,-899.8984,54.3838},//1
	{2223.3037,725.5395,10.6543},//2
	{761.3708,-1747.5504,12.1577},
	{803.1808,-1460.1035,13.0916},
	{1166.6190,-1096.2941,24.7527},
	{-329.3387,1358.5803,55.6078},
	{-329.3387,1358.5803,55.6078}
};
new CarQuests[5];
//


new snyq[4096];
//ПОДАРКИ ПО КАРТЕ
//new podarok[15];
stock hpquest_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused inputtext
	switch(dialogid)
	{
		case 19500: // DLG_QUEST_MAN
		{
			if(!response) return true;
			{
				format(snyq,sizeof(snyq), "\
				{FFFFFF}1. Приглашение на праздник \tПрогресс: {d10f55}[%s]\n\
				2. Поиск пропажи\t\tПрогресс: {d10f55}[%s]\n\
				3. Доставка подарков\t\tПрогресс: {d10f55}[%s]\n\
				4. Новогодний наряд\t\tПрогресс: {d10f55}[%s]\n\
				5. Подарки к спеху\t\tПрогресс: {d10f55}[%s]\n\
				6. Поиск эльфов\t\tПрогресс: {d10f55}[%s]\n\
				7. Волшебные олени\t\tПрогресс: {d10f55}[%s]\n\
				8. Новогодний дресс-код\tПрогресс: {d10f55}[%s]\n\
				9. Ели на всех хватит\t\tПрогресс: {d10f55}[%s]\n\
				10. Покажи этому правительству Прогресс: {d10f55}[%s]"
				, (pInfo[playerid][questtype] > 0 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 1 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 2 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 3 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 4 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 5 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 6 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 7 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 8 ) ? ("Выполнен") : ("Доступен")
				, (pInfo[playerid][questtype] > 9 ) ? ("Выполнен") : ("Доступен"));
				SPD(playerid, 19501/*DLG_QUEST_CHOOSE*/, DSL, "{FFFFFF}Новогодние квесты | {d10f55}Спасение Нового Года", snyq, "Далее", "Выход");
/*			}
		}
		case 19501://DLG_QUEST_CHOOSE
		{
			if(!response) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Эх... Жаль что ты отказался от моих заданий. Жду тебя вновь у себя в лавке!");
			{
				switch(listitem)
				{
					case 0: // Приглашение на праздник
					{
						if(pInfo[playerid][questtype] >= 1)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты уже выполнял данное поручение от меня!");
						}
						if(pInfo[playerid][questtype] >= 0 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] <= 10)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты же уже принялся за выполнение данного задания!");
						}
						if(pInfo[playerid][questtype] == 0 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] >= 10)
						{
							pInfo[playerid][questtype] = 1;
							pTemp[playerid][isquest] = false;
							pTemp[playerid][tempquest] = 0;
							/*Выдача награды*/
							/*pInfo[playerid][pCash] += 5000;
							GivePlayerMoneyEx(playerid); 
							pInfo[playerid][pHPcoin] += 10;
							pInfo[playerid][pExp] += 2;
							SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Поздравляю, ты успешно завершил одно из моих новогодних заданий.");
							new tmp_query[128];
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `questtype` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][questtype], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `HPcoin` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][pHPcoin], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							if (MYSQL_DEBUG) printf("CALLBACK | SaveNYquest (%d) | Good", strlen(tmp_query));
							format(snyq, sizeof snyq, "~b~cash+5OOO$");
							return GameTextForPlayer(playerid, snyq, 2000, 1);
							/****************/
						/*}
						SPD(playerid, 19502 /*DLG_QUESTS*/, DSM, "{d10f55}Приглашение на праздник", "{FFFFFF}\n\
/*						Спешу сообщить что Санта прилетел в наш штат, дабы раздать своё предновогоднее настроение и свои по						Но он прилетело неожиданно, некому не сообщив. Помоги нам разослать эту информацию по всему штату\n\
						и получишь своей маленький новогодний подарок!\n\n\
						{d10f55}Задание: {FFFFFF}Раздать 10 подарочных открыток разным игрокам\n\
						{d10f55}Награда: {FFFFFF}5.000$ + 2 exp и 5 Happy "DonatePoint"", "Далее", "Выход");
					}
					case 1: // Поиск пропажи
					{
						if(pInfo[playerid][questtype] == 0) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты ещё не выполнил прошлое задание а уже тянешься к этому!");
						if(pInfo[playerid][questtype] >= 2)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты уже выполнял данное поручение от меня!");
						}
						if(pInfo[playerid][questtype] >= 1 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] <= 10)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты же уже принялся за выполнение данного задания!");
						}
						if(pInfo[playerid][questtype] == 1 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] >= 10)
						{
							SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Поздравляю, ты успешно завершил второе моё новогоднее задание.");
							pInfo[playerid][questtype] = 2;
							pTemp[playerid][isquest] = false;
							pTemp[playerid][tempquest] = 0;
							/*Выдача награды*/
							pInfo[playerid][pCash] += 10000;
							GivePlayerMoneyEx(playerid); 
							pInfo[playerid][pHPcoin] += 15;
							pInfo[playerid][pExp] += 2;
							new tmp_query[128];
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `questtype` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][questtype], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `HPcoin` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][pHPcoin], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							if (MYSQL_DEBUG) printf("CALLBACK | SaveNYquest (%d) | Good", strlen(tmp_query));
							format(snyq, sizeof snyq, "~b~cash+1OOOO$");
							return GameTextForPlayer(playerid, snyq, 2000, 1);
							/****************/
						}
						SPD(playerid, 19502 /*DLG_QUESTS*/, DSM, "{d10f55}Поиск пропажи", "\n\
						{FFFFFF}К нам пришла беда, наши новогодние украшения потерялись во время перелёта\n\
						видимо в нашем мешке была дырка.\n\n\
						{d10f55}Задание: {FFFFFF}Розыскать 10 новогодних игрушек санты\n\
						{d10f55}Награда: {FFFFFF}10.000$ + 2 exp и 5 Happy "DonatePoint"", "Далее", "Выход");
					}
					case 2: // Доставка подарков
					{
						if(pInfo[playerid][questtype] == 1) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты ещё не выполнил прошлое задание а уже тянешься к этому!");
						if(pInfo[playerid][questtype] >= 3)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты уже выполнял данное поручение от меня!");
						}
						if(pInfo[playerid][questtype] >= 2 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] <= 10)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты же уже принялся за выполнение данного задания!");
						}
						if(pInfo[playerid][questtype] == 2 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] >= 10)
						{
							SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Поздравляю, ты успешно завершил второе моё новогоднее задание.");
							pInfo[playerid][questtype] = 3;
							pTemp[playerid][isquest] = false;
							pTemp[playerid][tempquest] = 0;
							/*Выдача награды*/
							pInfo[playerid][pCash] += 10000;
							GivePlayerMoneyEx(playerid); 
							pInfo[playerid][pHPcoin] += 25;
							pInfo[playerid][pExp] += 3;
							pInfo[playerid][pDonate] += 3;
							new tmp_query[128];
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `questtype` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][questtype], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `HPcoin` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][pHPcoin], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							if (MYSQL_DEBUG) printf("CALLBACK | SaveNYquest (%d) | Good", strlen(tmp_query));
							format(snyq, sizeof snyq, "~b~cash+1OOOO$");
							return GameTextForPlayer(playerid, snyq, 2000, 1);
							/****************/
						}
						SPD(playerid, 19502 /*DLG_QUESTS*/, DSM, "{d10f55}Поиск пропажи", "\n\
						{FFFFFF}Нам нужная твоя помощь, у нас совсем не хватает рук для доставки подарков каждому жителю штата... \n\
						а сроки идут на минуты!\n\n\
						{d10f55}Задание: {FFFFFF}Получить 10 подарков у помощника Санты и развезти их\n\
						{d10f55}Награда: {FFFFFF}10.000$ + 3 exp + 10 Happy "DonatePoint" 15 и "DonatePoint"", "Далее", "Выход");
					}
					case 3:
					{
						if(pInfo[playerid][questtype] == 2) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты ещё не выполнил прошлое задание а уже тянешься к этому!");
						if(pInfo[playerid][questtype] >= 4)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты уже выполнял данное поручение от меня!");
						}
						if(pInfo[playerid][questtype] >= 3 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] <= 10)
						{
							return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Хмм... Ты же уже принялся за выполнение данного задания!");
						}
						if(pInfo[playerid][questtype] == 3 && pTemp[playerid][isquest] == true && pTemp[playerid][tempquest] >= 10)
						{
							SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Поздравляю, ты успешно завершил второе моё новогоднее задание.");
							pInfo[playerid][questtype] = 4;
							pTemp[playerid][isquest] = false;
							pTemp[playerid][tempquest] = 0;
							/*Выдача награды*/
							pInfo[playerid][pCash] += 10000;
							GivePlayerMoneyEx(playerid); 
							pInfo[playerid][pHPcoin] += 25;
							pInfo[playerid][pExp] += 3;
							pInfo[playerid][pDonate] += 3;
							new tmp_query[128];
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `questtype` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][questtype], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `HPcoin` = '%d' WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][pHPcoin], pInfo[playerid][pID]);
							mysql_tquery(dbHandle, tmp_query, "", "");
							if (MYSQL_DEBUG) printf("CALLBACK | SaveNYquest (%d) | Good", strlen(tmp_query));
							format(snyq, sizeof snyq, "~b~cash+1OOOO$");
							return GameTextForPlayer(playerid, snyq, 2000, 1);
							/****************/
						}
						SPD(playerid, 19502 /*DLG_QUESTS*/, DSM, "{d10f55}Поиск пропажи", "\n\
						Ой, что ты совсем не важно выглядишь.\n\
						Отправляйся к нашему другу, он подберет тебе наряд к новому году.\n\n\
						{d10f55}Задание: {FFFFFF}Поехать в любой магазин одежды и приобрести новогоднюю шапку\n\
						{d10f55}Награда: {FFFFFF}5.000$ + 5 Happy "DonatePoint" и 5 "DonatePoint"", "Далее", "Выход");
					}
				}
			}
		}
		case 19502:
		{
			if(!response) return true;
			{
				switch(pInfo[playerid][questtype])
				{
					case 0:
					{
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Вы успешно принялись за выполнение задания.");
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Чтобы передать данную открытку другому игроку используй —> /postcard [ID]");
						pTemp[playerid][isquest] = true;
					}
					case 1:
					{
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Вы успешно принялись за выполнение задания.");
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} К сожалению я не знаю где находятся подарки нашего Санты на данный момент.");
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Единственное что я знаю это то, что их растащили злые эльфы по всему штату.");
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Я полагаюсь на твою помощь, спаси этот праздник и удачи тебе в поисках.");
						pTemp[playerid][isquest] = true;
					}
					case 2:
					{
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Вы успешно принялись за выполнение задания.");
						SendClientMessage(playerid, COLOR_YELLOW, "[Подсказка]{FFFFFF} Фуры с подарками стоят возле склона площади");
						pTemp[playerid][isquest] = true;
					}
				}
			}
		}
		case 16782:
		{
			if(response)
			{
				if(podartwo{playerid} == 0)
				{
					SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Отправляйтесь к метке на карте! У вас есть 10 минут на это задание.");
					SetPlayerCheckpoint(playerid,1469.3763,-899.8984,54.3838,2.0);
					time_podtwo[playerid] = SetTimer(!"job",550000,false);//на задание даётся 10 мин,если мы не выполнили работу в течении 10 минут задание проваливается
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Ты отказался от прохождения квеста, жду с возвращением!");
				podartwo{playerid} = 0;//обнуляем переменную
				DisablePlayerCheckpoint(playerid);//удаляем чекпоинт
				return 1;
			}
		}
	}
	return true;
}/*DLG_QUEST_CHOOSE хуйня */
//КОМАНДЫ
/*
CMD:hquest(playerid, params[])
{
	snyq[0]= EOS;
	if(pTemp[playerid][isquest] != true) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Ты ещё не приступал к выполнению новогодней линии квестов!");
	format(snyq,sizeof(snyq), "\
	{FFFFFF}1. Приглашение на праздник \tПрогресс: {d10f55}[%s]\n\
	2. Поиск пропажи\t\tПрогресс: {d10f55}[%s]\n\
	3. Доставка подарков\t\tПрогресс: {d10f55}[%s]\n\
	4. Новогодний наряд\t\tПрогресс: {d10f55}[%s]\n\
	5. Подарки к спеху\t\tПрогресс: {d10f55}[%s]\n\
	6. Поиск эльфов\t\tПрогресс: {d10f55}[%s]\n\
	7. Волшебные олени\t\tПрогресс: {d10f55}[%s]\n\
	8. Новогодний дресс-код\tПрогресс: {d10f55}[%s]\n\
	9. Ели на всех хватит\t\tПрогресс: {d10f55}[%s]\n\
	10. Покажи этому правительству Прогресс: {d10f55}[%s]"
	, (pInfo[playerid][questtype] > 0 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 1 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 2 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 3 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 4 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 5 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 6 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 7 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 8 ) ? ("Выполнен") : ("Доступен")
	, (pInfo[playerid][questtype] > 9 ) ? ("Выполнен") : ("Доступен"));
	SPD(playerid, 19501 DLG_QUEST_CHOOSE, DSL, "{FFFFFF}Новогодние квесты | {d10f55}Спасение Нового Года", snyq, "Далее", "Выход");
	return true;
}
CMD:postcard(playerid, params[])
{
	if(pInfo[playerid][questtype] > 0) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Ты ещё не принимал задание с открытками от меня!");
	if(pInfo[playerid][pPostcard] < 0) return SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} У тебя закончились открытки которые я тебе давал!");
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] {FFFFFF}Введите: /postcard [id]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] {FFFFFF}Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(5.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] {FFFFFF}Человек далеко от вас");
	if (pInfo[playerid][tPostCardTimer] > gettime())
	return SendClientMessage(playerid, COLOR_GREY, "[Подсказка] {FFFFFF}Передавать открытку можно раз в 2 минуты");
	pInfo[playerid][tPostCardTimer] = gettime() + 120;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);
	new
	string_[128];
	format(string_, sizeof string_, "Вы передали %s[%d] 1 новогоднюю открытку. ",pInfo[params[0]][pName],params[0]);
	SendClientMessage(playerid, COLOR_GRAD1, string_);
	format(string_, sizeof string_, "Вы получили 1 новогоднюю открытку от %s[%d]",pInfo[playerid][pName], playerid);
	SendClientMessage(params[0], COLOR_GRAD1, string_);
	format(string_, sizeof string_, "достал открытку и передал её %s",pInfo[params[0]][pName]);
	SetPlayerChatBubble(playerid,string_,COLOR_PURPLE,30.0,10000);
	if(pInfo[playerid][questtype] == 0 && pTemp[playerid][isquest] == true)
	{
		if(pTemp[playerid][tempquest] >= 10) SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Ты успешно раздал 10 открыток, возвращайся ко мне за наградой!");
		pTemp[playerid][tempquest] += 1;
	}
	return true;
}*/
/*hpquest_OnPlayerConnect(playerid)
{
	pInfo[playerid][pPodarok][0] = 0; pInfo[playerid][pPodarok][1] = 0;//Подарки//
	pInfo[playerid][pPodarok][2] = 0; pInfo[playerid][pPodarok][3] = 0;//Подарки//
	pInfo[playerid][pPodarok][4] = 0; pInfo[playerid][pPodarok][5] = 0;//Подарки//
	pInfo[playerid][pPodarok][6] = 0; pInfo[playerid][pPodarok][7] = 0;//Подарки//
	pInfo[playerid][pPodarok][8] = 0; pInfo[playerid][pPodarok][9] = 0;//Подарки//
	pInfo[playerid][pPodarok][10] = 0; pInfo[playerid][pPodarok][11] = 0;//Подарки//
	pInfo[playerid][pPodarok][12] = 0; pInfo[playerid][pPodarok][13] = 0;//Подарки//
	pInfo[playerid][pPodarok][14] = 0;//Подарки//
	return true;
}*/
hpquest_OnGamemodeInit()
{
	CarQuests[0] =  _CreateVehicle(448, 1243.8479,-2010.8134,59.4686,264.7307, 1,1,-1);
	CarQuests[1] =  _CreateVehicle(448,1243.9962,-2015.6879,59.4549,267.8134, 1,1,-1);
	CarQuests[2] =  _CreateVehicle(448,1244.0176,-2013.2334,59.4651,271.2257, 1,1,-1);
	CarQuests[3] =  _CreateVehicle(448,1243.9075,-2017.8452,59.4690,265.8674, 1,1,-1);
	CarQuests[4] =  _CreateVehicle(448,1243.9263,-2020.1005,59.4684,265.6667, 1,1,-1);
	return true;
}
hpquest_OnPlayerDisconnect(playerid)
{
	podartwo{playerid} =
	time_podtwo[playerid] = 0;
	return true;
}
//
public podtwo(playerid)
{
	SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} К сожалению ты не успел справиться с данным заданием. Жду тебя вновь!");
	podartwo{playerid} = 0;//обнуляем переменную
	RemovePlayerAttachedObject(playerid,0);//удаляем рюкзак
	SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	DisablePlayerCheckpoint(playerid);//удаляем чекпоинт работы
	return 1;
}
//
/*hpquest_OnPlayerEnterCheckpoint(playerid)
{
	if(podartwo{playerid} >= 0 && GetPlayerVehicleID(playerid) >= CarQuests[0] && GetPlayerVehicleID(playerid) <= CarQuests[4])//проверка на то сидит ли игрок на велосипеде
	{
	    podartwo{playerid} ++;
	    DisablePlayerCheckpoint(playerid);
	    switch(podartwo{playerid})
	    {
	        case 3..12:
	        {
	            {
			        switch(podartwo{playerid})
				    {
				        case 3:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}1{FFFFFF}/{FF0000}10");
				        case 4:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}2{FFFFFF}/{FF0000}10");
				        case 5:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}3{FFFFFF}/{FF0000}10");
				        case 6:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}4{FFFFFF}/{FF0000}10");
				        case 7:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}5{FFFFFF}/{FF0000}10");
						case 8:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}6{FFFFFF}/{FF0000}10");
						case 9:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}7{FFFFFF}/{FF0000}10");
						case 10:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}8{FFFFFF}/{FF0000}10");
						case 11:SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}9{FFFFFF}/{FF0000}10");
						case 12: 
						{
							if(pInfo[playerid][questtype] == 1 && pTemp[playerid][isquest] == true)
							{
								if(pTemp[playerid][tempquest] >= 10) SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Доставлено подарков: {00FF00}9{FFFFFF}/{FF0000}10");
								SendClientMessage(playerid, -1, "{d10f55}[Помощник Санты]{FFFFFF} Возвращайся за наградой");
								pTemp[playerid][tempquest] += 1;
							}
						}
				    }
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid,podtwo_coord[podartwo{playerid}-1][0],podtwo_coord[podartwo{playerid}-1][1],podtwo_coord[podartwo{playerid}-1][2],6.0);//даём координаты игроку из массива podtwo_coord
					return 1;
				}
	        }
	        case 13:
	        {
		        podartwo{playerid} = 0;
				DisablePlayerCheckpoint(playerid);
				SetVehicleToRespawn(GetPlayerVehicleID(playerid));
				return 1;
	        }
	    }
		SetPlayerCheckpoint(playerid,podtwo_coord[podartwo{playerid}-1][0],podtwo_coord[podartwo{playerid}-1][1],podtwo_coord[podartwo{playerid}-1][2], 6.0);
	}
	else
	{
		SendClientMessage(playerid,COLOR_WHITE,!"Вы должны быть в фуре");
		podartwo{playerid} = 0;
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		DisablePlayerCheckpoint(playerid);
		KillTimer(time_podtwo[playerid]);
	    return 1;
	}
	return 1;
}*/