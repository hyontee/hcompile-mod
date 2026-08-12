#if defined _achiev_inc
	#endinput
#endif
#define _achiev_inc 
enum
{
	DAY_ACHIEV,
	GLOBAL_ACHIEV,
	JOB_ACHIEV,
	FRAC_ACHIEV
}
enum 
{
	H_COIN,
	VIP,
	BOOST,
	ITEMS_0,//Полицейский щит
	GIVE_CASH, 
	GIVE_CERTIFICATE_HOME
} 
enum ACHIEVEMANT_E
{
	aName[64],
	aPrizeType,
	aPrizeCount,
	aAim,
	aType,
	bool: aStatus
}

new aInfo[][ACHIEVEMANT_E] = {
	/* aName, aPrizeType, aPrizeCount, aAim?, Type, Status */
/*0*/{"Отыграть 5 часов", BOOST, 1, 5, DAY_ACHIEV, false},//0
/*1*/{"Найдите 5 грибов", H_COIN, 2, 5, DAY_ACHIEV, false},//1
/*2*/{"[Такси] Развезти 10 пассажиров", H_COIN, 3, 10, DAY_ACHIEV, false},//2
/*3*/{"Отыграть 100 часов", VIP, 3, 100, GLOBAL_ACHIEV,true},//3
/*4*/{"[Такси] Развезти 50 пассажиров", H_COIN, 15, 50, JOB_ACHIEV,true},//4
/*5*/{"Отыграть 10 часов", BOOST, 2, 10, DAY_ACHIEV, false},//5
/*6*/{"[Автобус] Заработать $20.000 на развозе людей", H_COIN, 10, 20_000, JOB_ACHIEV,true},//6
/*7*/{"[СМИ] Отредактировать и опубликовать 50 объявлений", H_COIN, 10, 50, FRAC_ACHIEV, true},
/*8*/{"[СМИ] Отредактировать и опубликовать 100 объявлений", VIP, 2, 100, FRAC_ACHIEV, true},
/*9*/{"[Мэрия] Освободить 5 заключенных", H_COIN, 2, 5, DAY_ACHIEV, false},
/*10*/{"[Мэрия] Освободить 25 заключенных", H_COIN, 5, 25, JOB_ACHIEV, true},
/*11*/{"[Мэрия] Освободить 50 заключенных", H_COIN, 10, 50, JOB_ACHIEV, true},
/*12*/{"[Мэрия] Освободить 100 заключенных", VIP, 2, 100, JOB_ACHIEV, true}, //12
/*13*/{"Получить водительские права", H_COIN, 1, 1, GLOBAL_ACHIEV, true},
/*14*/{"[Автошкола] Оформить 25 водительских прав", H_COIN, 3, 25, JOB_ACHIEV, true},
/*15*/{"Получить разрешение на оружие",H_COIN, 1, 1, GLOBAL_ACHIEV, true},
/*16*/{"[Полиция] Арестовать 15 игроков", H_COIN, 5, 15, FRAC_ACHIEV,true},
/*17*/{"[Гетто] Ограбить 5 домов", H_COIN, 1, 5, DAY_ACHIEV, false},//17
/*18*/{"[Гетто] Ограбить 50 домов", H_COIN, 10, 50, FRAC_ACHIEV, true},//18
/*19*/{"Починить или заправить 100 игроков на автомеханике", H_COIN, 15, 100, JOB_ACHIEV, true},//19
/*20*/{"[Гетто] Победить 100 дуэлей", H_COIN, 15, 100, FRAC_ACHIEV, true},//20
/*21*/{"[Армия] Отстоять в карауле ЛСа 60 минут", H_COIN, 10, 60, FRAC_ACHIEV, true},//21
/*22*/{"[Развозчик] Выполните 3 заказа на продукты", H_COIN, 5, 3, DAY_ACHIEV, false},//22
/*23*/{"[Развозчик] Выполните 10 заказов на продукты", BOOST, 2, 10, GLOBAL_ACHIEV, true},//23
/*24*/{"[Развозчик] Выполните 50 заказов на продукты", VIP, 3, 50, GLOBAL_ACHIEV, true},//24
/*25*/{"Передайте любому игроку $50.000", H_COIN, 1, 50_000, DAY_ACHIEV, false},//25 
/*26*/{"Пожертвуйте $20.000 в Мэрию штата", BOOST, 2, 20_000, GLOBAL_ACHIEV, true},//26
/*27*/{"Пожертвуйте $50.000 в Мэрию штата", H_COIN, 3, 50_000, GLOBAL_ACHIEV, true},//27 /* */
/*28*/{"Пожертвуйте $150.000 в Мэрию штата", H_COIN, 10, 150_000, GLOBAL_ACHIEV, true},//28
/*29*/{"Пожертвуйте $1.500.000 в Мэрию штата", H_COIN, 15, 1_500_000, GLOBAL_ACHIEV, true},//29
/*30*/{"[Гетто] Победить 50 дуэлей", H_COIN, 3, 50, FRAC_ACHIEV, true},//30
/*31*/{"Создайте семью", H_COIN, 10, 1, GLOBAL_ACHIEV, true},//31
/*32*/{"Пойдите на службу в одну из Армий", H_COIN, 1, 1, GLOBAL_ACHIEV, true},//32
/*33*/{"Пройдите собеседования в Мэрию", H_COIN, 1, 1, GLOBAL_ACHIEV, true},//33
/*34*/{"Пойдите на службу в один из Полицеских участков", H_COIN, 1, 1, GLOBAL_ACHIEV, true},//34
/*35*/{"Пройдите собеседование в одну из Больниц штата", H_COIN, 1, 1, GLOBAL_ACHIEV, true},//35
/*36*/{"Вступите в одно из Новостных агенств", H_COIN, 1, 1, GLOBAL_ACHIEV, true},//36
/*37*/{"Пройдите собеседования в Автошколу", H_COIN, 1, 1, GLOBAL_ACHIEV, true},//37
/*38*/{"Пополните свой счет "DonatePoint" на 1000 рублей!", ITEMS_0, 105, 1_000, GLOBAL_ACHIEV, true},
/*39*/{"[Цех] Упакуйте 50 ящиков", GIVE_CASH, 5000, 50, JOB_ACHIEV, true},
/*40*/{"[Цех] Упакуйте 100 ящиков", GIVE_CASH, 10_000, 100, JOB_ACHIEV, true},
/*41*/{"[Цех] Упакуйте 500 ящиков", H_COIN, 20, 500, JOB_ACHIEV, true},
/*42*/{"[Цех] Упакуйте 1000 ящиков", GIVE_CERTIFICATE_HOME, 1, 1000, JOB_ACHIEV, true}
	//{"Пополните свой счет "DonatePoint" на 20 рублей", H_COIN, 20, 20, DAY_ACHIEV, false},//26
	/*{"Пополните свой счет "DonatePoint" на 30 рублей", BOOST, 1, 30, DAY_ACHIEV, false},//26
	{"Пополните свой счет "DonatePoint" на 40 рублей", VIP, 2, 40, DAY_ACHIEV, false},//27*/
	//{"Пригласить 5 игроков которые достигнут 3 уровня", H_COIN, 50, 5, GLOBAL_ACHIEV, true}//20

}; // Всегда ставить статус у достижения TRUE , если это не ежедневное.
#define MAX_ACHIEV sizeof(aInfo) 
new pAchivID[MAX_PLAYERS][MAX_ACHIEV]; 
stock OnPlayerAchievProgress(playerid, achiev_id, count = 1)
{
	//printf("OnPlayerAchievProgress(%d, %d, count %d",playerid, achiev_id, count);
    if ( pAchivID[playerid][achiev_id] == aInfo[achiev_id][aAim]) return true; 
	//printf("OnPlayerAchievProgress(%d, %d, count %d",playerid, achiev_id, count);
    if ( !aInfo[achiev_id][aStatus] ) return true;
	//printf("OnPlayerAchievProgress(%d, %d, count %d",playerid, achiev_id, count);
	pAchivID[playerid][achiev_id] += count;
	if (pAchivID[playerid][achiev_id] >= aInfo[achiev_id][aAim]) {
		pAchivID[playerid][achiev_id] = aInfo[achiev_id][aAim];
	}
	//printf("OnPlayerAchievProgress(%d, %d, count %d",playerid, achiev_id, count);
/*	if ( pAchivID[playerid][achiev_id] == aInfo[achiev_id][aAim]) return true;
    if ( !aInfo[achiev_id][aStatus] ) return true;
	pAchivID[playerid][achiev_id] += count;
	if (pAchivID[playerid][achiev_id] > aInfo[achiev_id][aAim]) {
		pAchivID[playerid][achiev_id] = aInfo[achiev_id][aAim];
	}*/
    //SavePlayerAchiev(playerid); 
	if (pAchivID[playerid][achiev_id] == aInfo[achiev_id][aAim])
	{ 
	    format(t_string, sizeof t_string, "Вы успешно выполнили достижение: '%s'",aInfo[achiev_id][aName]);
	    SendClientMessage(playerid, COLOR_LIME, t_string), t_string[0] = EOS; 
		new str_[128];
		switch(aInfo[achiev_id][aPrizeType])
		{ 
			case GIVE_CERTIFICATE_HOME: { 
				ChristmasInfo[playerid][aCirtificationHome] ++; 
				SavePlayerCristmasInteger(playerid, "aCirtificationHome", ChristmasInfo[playerid][aCirtificationHome]);
				SendClientMessage(playerid, COLOR_LIME, !"Ваша награда: Сертификат на покупку дома"); 
				format(str_, sizeof str_, "%s. Сертификат на дом", aInfo[achiev_id][aName]); 
				mysql_format(dbHandle, t_string, sizeof(t_string), "INSERT INTO s_achiev (`Name`,`pID`,`Info`,`Date`) VALUE ('%s','%d','%s',NOW())", pInfo[playerid][pName], pInfo[playerid][pID], str_ );
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS; 
			}
			case GIVE_CASH: {
				format(str_, sizeof str_, "Ваша награда: $%d", aInfo[achiev_id][aPrizeCount]);
				SendClientMessage(playerid, COLOR_LIME, str_);
				kLibGivePlayerMoney(playerid, aInfo[achiev_id][aPrizeCount], "give achiev"); 
				format(str_, sizeof str_, "%s. Получено $%i", aInfo[achiev_id][aName], aInfo[achiev_id][aPrizeCount]);
				mysql_format(dbHandle, t_string, sizeof(t_string), "INSERT INTO s_achiev (`Name`,`pID`,`Info`,`Date`) VALUE ('%s','%d','%s',NOW())", pInfo[playerid][pName], pInfo[playerid][pID], str_ );
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
			}
			case ITEMS_0: { 
				SendClientMessage(playerid, COLOR_LIME, !"Ваша награда: Полицейский Щит. Используйте: /inv");
				GivePlayerItem(playerid, 105, 1);
				format(str_, sizeof str_, "%s. Полицесйкий щит", aInfo[achiev_id][aName]);
				mysql_format(dbHandle, t_string, sizeof(t_string), "INSERT INTO s_achiev (`Name`,`pID`,`Info`,`Date`) VALUE ('%s','%d','%s',NOW())", 
					pInfo[playerid][pName], pInfo[playerid][pID], str_ 
				);
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS; 
			}
			case H_COIN: {
				pInfo[playerid][pDonate] += aInfo[achiev_id][aPrizeCount];
				SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
				
				pInfo[playerid][pFreeDonate] += aInfo[achiev_id][aPrizeCount];
				SavePlayerInteger(playerid, "u_free_donate", pInfo[playerid][pFreeDonate]); 
				format(str_, sizeof str_, "Ваша награда: %d "DonatePoint"", aInfo[achiev_id][aPrizeCount]);
				SendClientMessage(playerid, COLOR_LIME, str_);
				format(str_,sizeof(str_), "%s. Получено %i "DonatePoint"", aInfo[achiev_id][aName], aInfo[achiev_id][aPrizeCount]);
				mysql_format(dbHandle, t_string, sizeof(t_string), "INSERT INTO s_achiev (`Name`,`pID`,`Info`,`Date`) VALUE ('%s','%d','%s',NOW())", pInfo[playerid][pName], pInfo[playerid][pID], str_ );
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
			}
			case VIP: { 
				new 
					vip_[32]; 
				switch(aInfo[achiev_id][aPrizeCount]) {
					case VIP_PACK_BRONZE: vip_ = "{D2691E}[BRONZE]";
					case VIP_PACK_SILVER: vip_ = "{C0C0C0}[SILVER]";
					case VIP_PACK_GOLD: vip_ = "{FFD700}[GOLD]";
					case VIP_PACK_PLATINUM: vip_ = "{FF00FF}[PLATINUM]";
					case VIP_PACK_DIAMOND: vip_ = "{4285b4}[DIAMOND]";
					default: vip_ = ""colwarn"[ERROR]";
				} 
				if (pInfo[playerid][VIPRank] == 0) {
					pInfo[playerid][VIPRank] = aInfo[achiev_id][aPrizeCount];
					SavePlayerInteger(playerid, "vip_rank", pInfo[playerid][VIPRank]);
					new 
						unboost = gettime() + (7 * 86400);  
					pInfo[playerid][VIPTime] = unboost;
					SavePlayerInteger(playerid, "vip_time", pInfo[playerid][VIPTime]);
					format(str_, sizeof str_, "[Подсказка] "colwhi"Вы получили %s VIP"colwhi", на срок 7 дней", vip_);
					SendClientMessage(playerid, COLOR_YELLOW, str_);
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Выполняйте достижения и получайте ценные призы!");
					format(str_, sizeof str_, "%s. Получен VIP: %s"colwhi" на 7 дней", aInfo[achiev_id][aName], vip_);
				}
				else if (pInfo[playerid][VIPRank] < aInfo[achiev_id][aPrizeCount]) {
					pInfo[playerid][VIPRank] = aInfo[achiev_id][aPrizeCount];
					SavePlayerInteger(playerid, "vip_rank", pInfo[playerid][VIPRank]);
					new 
						unboost = (7 * 86400);  
					pInfo[playerid][VIPTime] += unboost;
					SavePlayerInteger(playerid, "vip_time", pInfo[playerid][VIPTime]);
					format(str_, sizeof str_, "[Подсказка] "colwhi"Ваш уровень VIP поднялся до уровня %s"colwhi", + 7 дней к сроку", vip_);
					SendClientMessage(playerid, COLOR_YELLOW, str_);
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Выполняйте достижения и получайте ценные призы!");
					format(str_, sizeof str_, "%s. Уровень VIP повысился до: %s"colwhi"", aInfo[achiev_id][aName], vip_);
				}
				else {
					new 
						unboost = (7 * 86400);  
					pInfo[playerid][VIPTime] += unboost;
					SavePlayerInteger(playerid, "vip_time", pInfo[playerid][VIPTime]);
					format(str_, sizeof str_, "[Подсказка] "colwhi"Ваш уровень VIP %s"colwhi", продлен на 7 дней", vip_);
					SendClientMessage(playerid, COLOR_YELLOW, str_);
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Выполняйте достижения и получайте ценные призы!");
					format(str_, sizeof str_, "%s. VIP: %s"colwhi" продлен на 7 дней", aInfo[achiev_id][aName], vip_);
				} 
				mysql_format(dbHandle, t_string, sizeof(t_string), "INSERT INTO s_achiev (`Name`,`pID`,`Info`,`Date`) VALUE ('%s','%d','%s',NOW())", 
					pInfo[playerid][pName], pInfo[playerid][pID], str_ 
				);
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
			}
			case BOOST: {
				new 
					boost_[32];  
				switch(aInfo[achiev_id][aPrizeCount])
				{ 
					case 1: boost_ = "[Стартовый]";
					case 2: boost_ = "[Профессиональный]";
					case 3: boost_ = "[Авторитет]";
					case 4: boost_ = "[Босс]";
					default: boost_ = "[ERROR]";
				}
				if (pInfo[playerid][BoostRank] == 0) {
					pInfo[playerid][BoostRank] = aInfo[achiev_id][aPrizeCount];
					SavePlayerInteger(playerid, "boost_rank", pInfo[playerid][BoostRank]);
					new 
						unboost = gettime() + (7 * 86400);  
					pInfo[playerid][BoostTime] = unboost;
					SavePlayerInteger(playerid, "boost_time", pInfo[playerid][BoostTime]);
					format(str_, sizeof str_, "[Подсказка] "colwhi"Вы получили стартовый пакет: "collime"%s"colwhi", на срок 7 дней", boost_);
					SendClientMessage(playerid, COLOR_YELLOW, str_);
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Выполняйте достижения и получайте ценные призы!");
					format(str_, sizeof str_, "%s. Получен Пакет: %s на 7 дней", aInfo[achiev_id][aName], boost_);
				}
				else if (pInfo[playerid][BoostRank] < aInfo[achiev_id][aPrizeCount]) {
					pInfo[playerid][BoostRank] = aInfo[achiev_id][aPrizeCount];
					SavePlayerInteger(playerid, "boost_rank", pInfo[playerid][BoostRank]);
					new 
						unboost = (7 * 86400);  
					pInfo[playerid][BoostTime] += unboost;
					SavePlayerInteger(playerid, "boost_time", pInfo[playerid][BoostTime]);
					format(str_, sizeof str_, "[Подсказка] "colwhi"Ваш стартовый пакет повысился: "collime"%s"colwhi", + 7 дней к сроку", boost_);
					SendClientMessage(playerid, COLOR_YELLOW, str_);
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Выполняйте достижения и получайте ценные призы!");
					format(str_, sizeof str_, "%s. Уровень стартового пакета повысился до: %s", aInfo[achiev_id][aName], boost_);
				}
				else {
					new 
						unboost = (7 * 86400);  
					pInfo[playerid][BoostTime] += unboost;
					SavePlayerInteger(playerid, "boost_time", pInfo[playerid][BoostTime]);
					format(str_, sizeof str_, "[Подсказка] "colwhi"Ваш уровень стартового пакета "collime"%s"colwhi", продлен на 7 дней", boost_);
					SendClientMessage(playerid, COLOR_YELLOW, str_);
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Выполняйте достижения и получайте ценные призы!");
					format(str_, sizeof str_, "%s. Стартовый пакет: %s продлен на 7 дней", aInfo[achiev_id][aName], boost_);
				} 
				mysql_format(dbHandle, t_string, sizeof(t_string), "INSERT INTO s_achiev (`Name`,`pID`,`Info`,`Date`) VALUE ('%s','%d','%s',NOW())", 
					pInfo[playerid][pName], pInfo[playerid][pID], str_ 
				);
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS; 
			}
			
		}
		
	}
	return 1;
	
}
achiev_OnPlayerConnect(playerid) {
	for(new i; i < MAX_ACHIEV; i++) {
		pAchivID[playerid][i] = 0;
	}
}
/*stock SavePlayerAchiev(playerid) { 
    new 
		str_[128]; 
	for(new i; i < MAX_ACHIEV; i++) {
		if (!i) format(str_,sizeof str_, "%d", pAchivID[playerid][i]);
		else format(str_, sizeof str_, "%s|%d", str_, pAchivID[playerid][i]);
	}  
    format(t_string, sizeof t_string, "UPDATE `s_users` SET `pAchivID` = '%s' WHERE `pID` = '%d' LIMIT 1",
        str_,
        pInfo[playerid][pID]
    ); 
    mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;

    if (MYSQL_DEBUG) printf("CALLBACK | SavePlayerAchiev (%d) | Good", strlen(str_));
	return 1;
}*/

stock achiev_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused inputtext
	switch(dialogid)
	{
		case D_ACHIV_MENU:
		{
			if (!response) return 1;

			if (listitem == 4) { 
				format(t_string, sizeof (t_string), "SELECT * FROM `s_achiev` WHERE `pID` = '%d' ORDER BY `Date` DESC LIMIT 0, 22", 
					pInfo[playerid][pID]
				);
				new rows, Cache:tempQuery = mysql_query(dbHandle, t_string);
				cache_get_row_count(rows);
				printf("Выполнение запроса \"SELECT * FROM `s_achiev` WHERE `Name` ORDER BY `Date` DESC\" заняло %d м.с / %d мик.с	",
					cache_get_query_exec_time(MILLISECONDS), cache_get_query_exec_time(MICROSECONDS)
				);
				if (!rows) {
					SendClientMessage(playerid, COLOR_GREY, !"У вас нет выполненых достижений!");
					if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
					return true;
				}
				t_string[0] = EOS;
				strcat(t_string, ""colwhi"");
				for(new i = 0, date_[32], name_[120]; i < rows ; i++)
				{ 
					cache_get_value(i, "Date", date_, sizeof date_); 
					cache_get_value(i, "Info", name_, sizeof name_); 
					format(t_string, sizeof t_string, "%s[%s] %s\n", 
						t_string, date_, name_
					);
				}
				ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, !""colserver"История: "colwhi"Выполненных достижений", t_string, !"Закрыть", ""), t_string[0] = EOS;
				if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
				return true;
			}
			new count_ = 0;
			t_string = ""colserver"[№] Название\t"colserver"Награда\t"colserver"Процесс";
			for(new i, prize_[16], typeCount[32]; i < sizeof(aInfo); i++)
			{
				if (aInfo[i][aType] != listitem) continue;
				if (!aInfo[i][aStatus] ) continue; 
				new	
					prizeType[][32] = {""DonatePoint":", "VIP:", "Boost:", "Полицейский щит", "Деньги", "Сертификат"};
				switch(aInfo[i][aPrizeType]) {
					case H_COIN: prize_ = ""DonatePoint":", typeCount = "шт.";
					case VIP: prize_ = "VIP:", typeCount = "шт.";
					case BOOST: prize_ = "Boost:", typeCount = "шт.";
					case ITEMS_0: prize_ = "Полицейский щит", typeCount = "ID";
					case GIVE_CASH: prize_ = "Деньги", typeCount = "$";
					case GIVE_CERTIFICATE_HOME: prize_ = "Сертификат", typeCount = "На дом";
				} 
				if (aInfo[i][aPrizeType] == 1 || aInfo[i][aPrizeType] == 2) {
					typeCount[0] = EOS;
					switch(aInfo[i][aPrizeType])
					{
						case VIP_PACK_BRONZE: typeCount = "{D2691E}[BRONZE]"colwhi"";
						case VIP_PACK_SILVER: typeCount = "{C0C0C0}[SILVER]"colwhi"";
						case VIP_PACK_GOLD: typeCount = "{FFD700}[GOLD]"colwhi"";
						case VIP_PACK_PLATINUM: typeCount = "{FF00FF}[PLATINUM]"colwhi"";
						case VIP_PACK_DIAMOND: typeCount = "{4285b4}[DIAMOND]"colwhi"";
						default: typeCount = ""colwarn"[ERROR]"colwhi"";
					} 
					switch(aInfo[i][aPrizeType])
					{
						case 0: typeCount = "[ERROR]";
						case 1: typeCount = "[Стартовый]";
						case 2: typeCount = "[Профессиональный]";
						case 3: typeCount = "[Авторитет]";
						case 4: typeCount = "[Босс]";
						case 5: typeCount = "[Гетто тащер]";
						default: typeCount = ""colwarn"[ERROR]"colwhi"";
					}
				} 
				format(t_string, sizeof(t_string),"%s\n[%d] %s\t"colserver"%s (%i %s)\t%s%i из %i (%i%%)",t_string, 
					count_++, aInfo[i][aName], prizeType[aInfo[i][aPrizeType]], aInfo[i][aPrizeCount], typeCount,
					(pAchivID[playerid][i]==0) ? ("{a8a7a6}") : ("{FFFFFF}"), pAchivID[playerid][i], aInfo[i][aAim],pAchivID[playerid][i]*100/aInfo[i][aAim]
				);
				
			}

			ShowPlayerDialog(playerid, D_ACHIV_RETURN_MENU, DIALOG_STYLE_TABLIST_HEADERS, !""colserver"Список: "colwhi"Достижений", t_string, !"Назад", ""), t_string[0] = EOS;
		}
		case D_ACHIV_RETURN_MENU: {
			if (!response) return 1;
			callcmd::achievement(playerid);

		}
	}
	return 0;
} 
CMD:achievement(playerid)
{
	if (!NEW_ACHIEV_SYSTEM) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент система отключина администрацией");
	ShowPlayerDialog(playerid, D_ACHIV_MENU, DIALOG_STYLE_LIST, !""colserver"Достижения", !"\
		[0] Посмотреть: {009900}Ежедневные достижения\n\
		[1] Посмотреть: {F4A900}Глобальные достижения\n\
		[2] Посмотреть: {DDB201}Достижения на работах\n\
		[3] Посмотреть: {EEDC82}Достижения во фракциях\n\
		{828282}Посмотреть лог выполненных достижений",!"Выбрать",!"Закрыть");
	return 1;
} 