#define TABLE_BOOST_PACK		"s_boost_pack"
#define BOOST_PACK_COUNT		(6) 
#define GetVipBoostMaxPlayerValue%0(%1,%2,%3,%4) \
	GetVipPackPlayerValue(%1,%2,%4)>GetBoostPackPlayerValue(%1,%3,%4)?\
	GetVipPackPlayerValue(%1,%2,%4):GetBoostPackPlayerValue(%1,%3,%4)

#define GetVipBoostMaxPlayerValueSale%0(%1,%2,%3,%4) \
	GetVipPackPlayerValue(%1,%2,%4)<GetBoostPackPlayerValue(%1,%3,%4)?\
	GetVipPackPlayerValue(%1,%2,%4):GetBoostPackPlayerValue(%1,%3,%4)
/*	native GetVipBoostMaxPlayerValue(playerid, E_VIP_PACK: type, E_BOOST_PACK: type, currentValue = 0);

	native GetVipPackPlayerValue(playerid, E_VIP_PACK: type, currentValue = 0);
	native GetBoostPackPlayerValue(playerid, E_BOOST_PACK: type, currentValue = 0); */

// RankBoost = 0;



enum E_VIP_PACK
{
	vCost,
	vMoney,//+
	vPercentSalary, //+
	vPayDayExp,//+
	vCashBack,//+
	vPercentfSalary,//+
	vSaleCar,//+
	vSaleSkin,//+
	vSaleHome,//+
	vSaleBizz,//+
	vCountBizz,//+
	vSkillGun,//+
	vSkillJobTaxi,//+
	vSkillJobTruck,//+
	vSkillJobProd,//+
	vSkillTheftCar,//+
	vTimerFerm,//--
	vTimerDrugs,//--
}
enum E_BOOST_PACK
{
	bCost,
	bMoney, //+
	bPercentSalary, //+
	bLicenses[6], //--
	bPayDayExp, //+
	bCashBack, //+
	bPercentfSalary, //+
	bSaleCar, //+
	bSaleSkin, //+
	bSaleHome, //+
	bSkillGun, //+
	bSkillJobTaxi, //+
	bSkillJobTruck, //+
	bSkillJobProd, //+
	bSkillTheftCar, //+
	TimerFerm, //--
	TimerDrugs, //--
	bGiveDrugs,
	bGiveMaterials
}
new BoostPlayer[BOOST_PACK_COUNT][E_BOOST_PACK];

enum
{
	BOOST_PACK_NONE = 0,
	BOOST_PACK_START,
	BOOST_PACK_PRO,
	BOOST_PACK_POWER,
	BOOST_PACK_BOSS,
	BOOST_PACK_GHETTO
}

stock LoadBoostPack() 
{
	new 
		time = GetTickCount(), rows, BOOST_PACK_TOTAL,
		Cache:tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_BOOST_PACK"");
	
	cache_get_row_count(rows);
	if (!rows) {
		print(!"[Загрузка ...] Данные из s_boost_pack не получены!");
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	for(new i = 0, lic_mass[32]; i < rows; i++) {
		if (BOOST_PACK_TOTAL >= sizeof (BoostPlayer)) {
			printf(!"[Загрузка ...] Пакет: #%i не был загружен из-за лимита \"BOOST_PACK_TOTAL\"!", BOOST_PACK_TOTAL);
			break;
		}
		cache_get_value_name_int(i, "cost", BoostPlayer[i][bCost]);
		cache_get_value_name_int(i, "money", BoostPlayer[i][bMoney]);
		cache_get_value_name_int(i, "percent_salary", BoostPlayer[i][bPercentSalary]); 

		cache_get_value_name(i, "licenses", lic_mass, 32);
	 	sscanf(lic_mass, "p<,>a<d>[6]", BoostPlayer[i][bLicenses]);

		cache_get_value_name_int(i, "exp", BoostPlayer[i][bPayDayExp]);
		cache_get_value_name_int(i, "cashback", BoostPlayer[i][bCashBack]);

		cache_get_value_name_int(i, "f_salary", BoostPlayer[i][bPercentfSalary]);
		cache_get_value_name_int(i, "sale_car", BoostPlayer[i][bSaleCar]);

		cache_get_value_name_int(i, "sale_skin", BoostPlayer[i][bSaleSkin]);
		cache_get_value_name_int(i, "sale_home", BoostPlayer[i][bSaleHome]);
		cache_get_value_name_int(i, "skill_gun", BoostPlayer[i][bSkillGun]);
		cache_get_value_name_int(i, "skill_taxi", BoostPlayer[i][bSkillJobTaxi]);

		cache_get_value_name_int(i, "skill_truck", BoostPlayer[i][bSkillJobTruck]);
		cache_get_value_name_int(i, "skill_prod", BoostPlayer[i][bSkillJobProd]);
		cache_get_value_name_int(i, "skill_theft", BoostPlayer[i][bSkillTheftCar]);
		cache_get_value_name_int(i, "timer_ferm", BoostPlayer[i][TimerFerm]);
		cache_get_value_name_int(i, "timer_drugs", BoostPlayer[i][TimerDrugs]); 

		cache_get_value_name_int(i, "give_drugs", BoostPlayer[i][bGiveDrugs]);
		cache_get_value_name_int(i, "give_mats", BoostPlayer[i][bGiveMaterials]); 
		BOOST_PACK_TOTAL++;

	}
	printf("[Загрузка ...] Данные из s_boost_pack получены! Время: %d", GetTickCount() - time);
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
} 
#define TABLE_VIP_PACK		"s_vip_pack"
#define VIP_PACK_COUNT		(6)

//pVip = 0;
new gVipPlayer[VIP_PACK_COUNT][E_VIP_PACK];

enum
{
	VIP_PACK_NONE = 0,
	VIP_PACK_BRONZE,
	VIP_PACK_SILVER,
	VIP_PACK_GOLD,
	VIP_PACK_PLATINUM,
	VIP_PACK_DIAMOND
}

stock LoadVIPPack() 
{
	new 
		time = GetTickCount(), rows, VIP_PACK_TOTAL,
		Cache:tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_VIP_PACK"");
	
	cache_get_row_count(rows);
	if (!rows) {
		print(!"[Загрузка ...] Данные из s_vip_pack не получены!");
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	for(new i = 0; i < rows; i++) {
		if (VIP_PACK_TOTAL >= sizeof (gVipPlayer)) {
			printf(!"[Загрузка ...] Пакет: #%i не был загружен из-за лимита \"VIP_PACK_TOTAL\"!", VIP_PACK_TOTAL);
			break;
		}
		cache_get_value_name_int(i, "cost", gVipPlayer[i][vCost]);
		cache_get_value_name_int(i, "money", gVipPlayer[i][vMoney]);
		cache_get_value_name_int(i, "percent_salary", gVipPlayer[i][vPercentSalary]);  
		cache_get_value_name_int(i, "exp", gVipPlayer[i][vPayDayExp]);
		cache_get_value_name_int(i, "cashback", gVipPlayer[i][vCashBack]);

		cache_get_value_name_int(i, "f_salary", gVipPlayer[i][vPercentfSalary]);

		cache_get_value_name_int(i, "sale_car", gVipPlayer[i][vSaleCar]);
		cache_get_value_name_int(i, "sale_skin", gVipPlayer[i][vSaleSkin]);
		cache_get_value_name_int(i, "sale_home", gVipPlayer[i][vSaleHome]);
		cache_get_value_name_int(i, "sale_bizz", gVipPlayer[i][vSaleBizz]);

		cache_get_value_name_int(i, "count_bizz", gVipPlayer[i][vCountBizz]);

		cache_get_value_name_int(i, "skill_gun", gVipPlayer[i][vSkillGun]);
		cache_get_value_name_int(i, "skill_taxi", gVipPlayer[i][vSkillJobTaxi]);
		cache_get_value_name_int(i, "skill_truck", gVipPlayer[i][vSkillJobTruck]);
		cache_get_value_name_int(i, "skill_prod", gVipPlayer[i][vSkillJobProd]);
		cache_get_value_name_int(i, "skill_theft", gVipPlayer[i][vSkillTheftCar]);

		cache_get_value_name_int(i, "timer_ferm", gVipPlayer[i][vTimerFerm]);
		cache_get_value_name_int(i, "timer_drugs", gVipPlayer[i][vTimerDrugs]);  
		VIP_PACK_TOTAL++;
	}
	printf("[Загрузка ...] Данные из s_vip_pack получены! Время: %d", GetTickCount() - time);
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
} 

#define TABLE_BOOST_SERVER		"s_boost_server"

enum E_BOOST_SERVER
{
	sBoostExp,
	sBoostDonate,
	sBoostCash,
	sBoostTime,
	sTimerDrugs,
	bool: sBoost
}
new gBoostServer[E_BOOST_SERVER];
/*CMD:testcash(playerid) {
	new get_donate = 5120;
	SendMes(playerid, COLOR_GREY, "%d", (gBoostServer[sBoost]) ? get_donate*gBoostServer[sBoostCash] : get_donate);
	return 1;
}*/
BoostServer_OnGameModeInit()
{
	mysql_tquery(
		dbHandle, "SELECT * FROM "TABLE_BOOST_SERVER"", #OnLoadBoostServerData\
	);
	return;
}

forward OnLoadBoostServerData();
public OnLoadBoostServerData()
{
	new 
		time = GetTickCount(), 
		rows;
	cache_get_row_count(rows);
	if (!rows) return print("[Загрузка ...] Данные из "TABLE_BOOST_SERVER" не получены!");
	cache_get_value_name_int(0, "exp", gBoostServer[sBoostExp]);
	cache_get_value_name_int(0, "donate", gBoostServer[sBoostDonate]);
	cache_get_value_name_int(0, "cash", gBoostServer[sBoostCash]);
	cache_get_value_name_int(0, "boost_time", gBoostServer[sBoostTime]); 
	cache_get_value_name_int(0, "drugs_timer", gBoostServer[sTimerDrugs]); 	
	if (gBoostServer[sBoostTime] >= gettime())
	{
		gBoostServer[sBoost] = true;
		new 
			string_[128];
		if (gBoostServer[sBoostDonate] > 1) {
			format(string_, sizeof string_, "hostname "HostNameBonus""); 
		} else {
			format(string_, sizeof string_, "hostname "HostNameBonus""); 
		}
		SendRconCommand(string_); 
		//SendRconCommand("hostname Creative Role Play | Тех. Работы до 04:00 по МСК");
		print("[Загрузка ...] Бонусы включены!");
	}
	else
	{
		gBoostServer[sBoost] = false;
		SendRconCommand("hostname "HostName"");
		print("[Загрузка ...] Бонусы выключены!");
	}
	printf("[Загрузка ...] Данные из "TABLE_BOOST_SERVER" получены! Время: %d", GetTickCount() - time);
	return 1;
}
CMD:booston(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /booston [days]");
	if (params[0] < 1 || params[0] > 14) return SendClientMessage(playerid, COLOR_GREY, !"Количество дней от 1 до 14");
	//if (!(0 <= params[0] <= 14)) return SendClientMessage(playerid, COLOR_GREY, !"Количество дней от 1 до 14");
	new 
		unwarndate, 
		query_[128];
	unwarndate = gettime() + params[0] * 86400; 
	gBoostServer[sBoost] = true;
	gBoostServer[sBoostTime] = unwarndate;
	mysql_format(dbHandle, query_, sizeof(query_), "UPDATE "TABLE_BOOST_SERVER" SET boost_time = '%d'", gBoostServer[sBoostTime]);
	mysql_tquery(dbHandle, query_, "", "");
	SendMesAll(COLOR_ROSE, "[Подсказка] "colwhi"Администратор %s, Включил Бонусы \"/boostinfo\". Зовите друзей!", pInfo[playerid][pName]);
	BoostServer_OnGameModeInit();
    SendClientMessage(playerid, COLOR_BLUE, !"Параметры Boost-Server были перезагружены!");
	SendClientMessage(playerid, COLOR_WHITE, !"Бонусы включены");
	return 1;
}
CMD:boostoff(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	mysql_tquery(dbHandle, "UPDATE "TABLE_BOOST_SERVER" SET boost_time = '0'");
	gBoostServer[sBoost] = false;
	SendRconCommand("hostname "HostName"");
	return SendClientMessage(playerid, COLOR_WHITE, !"Бонусы отключены");
} 
CMD:boostinfo(playerid)
{
	if (!gBoostServer[sBoost]) return SendClientMessage(playerid, COLOR_WHITE, !"Бонусы отключены"); 
	t_string[0] = EOS; 
	format(t_string, sizeof t_string, ""colserver"[№] Бонус\t"colserver"Множитель\n\
		[0] Опыт\tx%d\n\
		[1] "DonatePoint"(Донат)\tx%d\n\
		[2] Конвертация ("DonatePoint" в $)\tx%d\n\
		- Действует до:\t%s", 
		gBoostServer[sBoostExp], 
		gBoostServer[sBoostDonate], 
		gBoostServer[sBoostCash], 
		date("%dd.%mm.%yyyy", gBoostServer[sBoostTime])
	); 
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Boost: "colwhi"Информация", t_string, "Закрыть", ""); 
	return 1;
}

stock ShowBoostPackInfo(playerid, boost_id, bool: price = false)
{
   //if (pInfo[playerid][BoostRank] == BOOST_PACK_NONE) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет буст пакета");
	t_string[0] = EOS;
	new
		string_[128],
		boost_[32];
	switch(boost_id)
	{
		case 0: boost_ = "[ERROR]";
		case 1: boost_ = "[Стартовый]";
		case 2: boost_ = "[Профессиональный]";
		case 3: boost_ = "[Авторитет]";
		case 4: boost_ = "[Босс]";
		case 5: boost_ = "[Гетто тащер]";
	}
	if (price == true)
	{
		format(string_, sizeof string_, ""colwhi"Пакет(Цена):\t\t\t\t%s("collime"%d"colwhi" рублей)\n", boost_, BoostPlayer[boost_id][bCost] );
		strcat(t_string, string_);
	}
	
	format(string_, sizeof string_, ""colwhi"Сумма при покупки:\t\t\t"collime"$%d\n", BoostPlayer[boost_id][bMoney]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Опыта в час:\t\t\t\tx%d\n", BoostPlayer[boost_id][bPayDayExp]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Процент к зарплате на работе:\t\t+%d процентов\n", BoostPlayer[boost_id][bPercentSalary]);
	strcat(t_string, string_);
	if (BoostPlayer[boost_id][bPercentfSalary] != 0) {
		format(string_, sizeof string_, ""colwhi"Процент к зарплате в организации:\t+%d процентов\n", BoostPlayer[boost_id][bPercentfSalary]);
		strcat(t_string, string_);
	}  
	strcat(t_string, "\n\tСкидки:\n");
	format(string_, sizeof string_, ""colwhi"Скидка в автосалоне:\t\t\t%d процентов\n", BoostPlayer[boost_id][bSaleCar]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Скидка в магазине одежды:\t\t%d процентов\n", BoostPlayer[boost_id][bSaleSkin]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Скидка на покупку дома:\t\t%d процентов\n\n", BoostPlayer[boost_id][bSaleHome]);
	strcat(t_string, string_);
	
	if (BoostPlayer[boost_id][bSkillGun] != 1)
	{
		strcat(t_string, "\tНавыки:\n");
		format(string_, sizeof string_, ""colwhi"Опыт на навыки Оружия:\t\tx%d\n", BoostPlayer[boost_id][bSkillGun]);
		strcat(t_string, string_);
	}
	if (BoostPlayer[boost_id][bSkillJobTaxi] != 1) {
		format(string_, sizeof string_, ""colwhi"Опыт на работе Такси:\t\t\tx%d\n", BoostPlayer[boost_id][bSkillJobTaxi]);
		strcat(t_string, string_);
	}
	if (BoostPlayer[boost_id][bSkillJobTruck] != 1)  {
		format(string_, sizeof string_, ""colwhi"Опыт на работе Дальнобойщиков:\tx%d\n", BoostPlayer[boost_id][bSkillJobTruck]);
		strcat(t_string, string_);
	}
	if (BoostPlayer[boost_id][bSkillJobProd] != 1)  {
		format(string_, sizeof string_, ""colwhi"Опыт на работе Продуктовозов:\tx%d\n", BoostPlayer[boost_id][bSkillJobProd]);
		strcat(t_string, string_);
	}
	if (BoostPlayer[boost_id][bSkillTheftCar] != 1) {
		format(string_, sizeof string_, ""colwhi"Опыт на работе Автоугонщиков:\tx%d\n", BoostPlayer[boost_id][bSkillTheftCar]);
		strcat(t_string, string_);
	}
		
	if (price == true)
	{
		format(string_, sizeof string_, ""colmaline"Кэшбэк от стоимости пакета:\t%d процентов\n", BoostPlayer[boost_id][bCashBack]);
		strcat(t_string, string_);
		if (BoostPlayer[boost_id][bGiveDrugs] != 0 && BoostPlayer[boost_id][bGiveMaterials] != 0) {
			format(string_, sizeof string_, "\t"C_PODS" - Уникальное предложение:\n\
				"colwhi"+%d наркотиков\n\
				"colwhi"+%d материалов", BoostPlayer[boost_id][bGiveDrugs], BoostPlayer[boost_id][bGiveMaterials]
			);
			strcat(t_string, string_);
		}
	}
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver" - Информация", t_string, "Готово", "");
	return 1;
} 
GetVIPRankName(playerid, dest[MAX_VIP_RANK_NAME + 1]) {
    dest[0] = EOS;
    
    switch(pInfo[playerid][VIPRank])
    {
        case VIP_PACK_NONE: dest = ""colwhi"Нет";
        case VIP_PACK_BRONZE: dest = "{D2691E}[BRONZE]";
        case VIP_PACK_SILVER: dest = "{C0C0C0}[SILVER]";
        case VIP_PACK_GOLD: dest = "{FFD700}[GOLD]";
        case VIP_PACK_PLATINUM: dest = "{FF00FF}[PLATINUM]";
        case VIP_PACK_DIAMOND: dest = "{4285b4}[DIAMOND]";
    }
}
GetBoostRankName(playerid, dest[MAX_VIP_RANK_NAME + 1]) {
    dest[0] = EOS;
    
    switch(pInfo[playerid][BoostRank])
    {
        case BOOST_PACK_NONE: dest = ""colwhi"Нет";
        case BOOST_PACK_START: dest = "[Стартовый]";
        case BOOST_PACK_PRO: dest = "[Профессиональный]";
        case BOOST_PACK_POWER: dest = "[Авторитет]";
        case BOOST_PACK_BOSS: dest = "[Босс]"; 
    }
}
stock ShowVIPPackInfo(playerid, boost_id, bool: price = false)
{
   //if (pInfo[playerid][BoostRank] == BOOST_PACK_NONE) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет буст пакета");
	t_string[0] = EOS;
	new
		string_[128],
		vip_[32]; 
	switch(boost_id)
	{
		case VIP_PACK_BRONZE: vip_ = "{D2691E}[BRONZE]";
		case VIP_PACK_SILVER: vip_ = "{C0C0C0}[SILVER]";
		case VIP_PACK_GOLD: vip_ = "{FFD700}[GOLD]";
		case VIP_PACK_PLATINUM: vip_ = "{FF00FF}[PLATINUM]";
		case VIP_PACK_DIAMOND: vip_ = "{4285b4}[DIAMOND]";
		default: vip_ = ""colwarn"[ERROR]";
	}
	if (price == true)
	{
		format(string_, sizeof string_, ""colwhi"Пакет(Цена):\t\t\t\t%s("collime"%d"colwhi" рублей)\n", vip_, gVipPlayer[boost_id][vCost] );
		strcat(t_string, string_);
	}
	
	format(string_, sizeof string_, ""colwhi"Каждый PayDay + зарплате:\t\t\t%d\n", gVipPlayer[boost_id][vMoney]);
	strcat(t_string, string_);
	if (gVipPlayer[boost_id][vPayDayExp] != 1) {
		format(string_, sizeof string_, ""colwhi"Опыта в час:\t\t\t\tx%d\n", gVipPlayer[boost_id][vPayDayExp]);
		strcat(t_string, string_);
	}
	format(string_, sizeof string_, ""colwhi"Процент к зарплате на работе:\t\t+%d процентов\n", gVipPlayer[boost_id][vPercentSalary]);
	strcat(t_string, string_); 
	format(string_, sizeof string_, ""colwhi"Процент к зарплате в организации:\t+%d процентов\n", gVipPlayer[boost_id][vPercentfSalary]);
	strcat(t_string, string_); 
	strcat(t_string, "\n\tСкидки:\n");
	format(string_, sizeof string_, ""colwhi"Скидка в автосалоне:\t\t\t%d процентов\n", gVipPlayer[boost_id][vSaleCar]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Скидка в магазине одежды:\t\t%d процентов\n", gVipPlayer[boost_id][vSaleSkin]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Скидка на покупку дома:\t\t%d процентов\n\n", gVipPlayer[boost_id][vSaleHome]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Скидка на покупку бизнеса:\t\t%d процентов\n\n", gVipPlayer[boost_id][vSaleBizz]);
	strcat(t_string, string_); 
	strcat(t_string, "\tВозможности:\n");
	format(string_, sizeof string_, ""colwhi"Возможность иметь бизнесов:\t\t%d процент\n\n", gVipPlayer[boost_id][vCountBizz]);
	strcat(t_string, string_); 
	strcat(t_string, "\tНавыки:\n");
	format(string_, sizeof string_, ""colwhi"Опыт на навыки Оружия:\t\tx%d\n", gVipPlayer[boost_id][vSkillGun]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Опыт на работе Такси:\t\t\tx%d\n", gVipPlayer[boost_id][vSkillJobTaxi]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Опыт на работе Дальнобойщиков:\tx%d\n", gVipPlayer[boost_id][vSkillJobTruck]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Опыт на работе Продуктовозов:\tx%d\n", gVipPlayer[boost_id][vSkillJobProd]);
	strcat(t_string, string_);
	format(string_, sizeof string_, ""colwhi"Опыт на работе Автоугонщиков:\tx%d\n", gVipPlayer[boost_id][vSkillTheftCar]);
	strcat(t_string, string_); 
	if (price == true)
	{
		format(string_, sizeof string_, ""colmaline"Кэшбэк от стоимости VIP:\t%d процентов\n", gVipPlayer[boost_id][vCashBack]);
		strcat(t_string, string_);
	}
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver" - Информация", t_string, "Готово", "");
	return 1;
} 
CMD:boostplus(playerid)
{
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	pInfo[playerid][BoostRank]++;
	SendMes(playerid, COLOR_GREY, "COUNT: %d", pInfo[playerid][BoostRank]);
	return 1;
}

CMD:vipplus(playerid)
{
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	pInfo[playerid][VIPRank]++;
	new vip_[32];
	switch(pInfo[playerid][VIPRank])
	{
		case VIP_PACK_BRONZE: vip_ = "{D2691E}[BRONZE]";
		case VIP_PACK_SILVER: vip_ = "{C0C0C0}[SILVER]";
		case VIP_PACK_GOLD: vip_ = "{FFD700}[GOLD]";
		case VIP_PACK_PLATINUM: vip_ = "{FF00FF}[PLATINUM]";
		case VIP_PACK_DIAMOND: vip_ = "{4285b4}[DIAMOND]";
		default: 
		{
			pInfo[playerid][VIPRank] = 0;
			vip_ = ""colwarn"[ERROR]";
		}
	}
	SendMes(playerid, COLOR_GREY, "COUNT: %d %s", pInfo[playerid][VIPRank], vip_);
	return 1;
}

CMD:vleave(playerid, params[])
{
    if (pInfo[playerid][pLeader] >= 1) return SendClientMessage(playerid, COLOR_WHITE, !"Вы не можете уволить себя!");
    if (pInfo[playerid][pMember] > 0 && pInfo[playerid][VIPRank] >= VIP_PACK_SILVER)
	{
	    SendClientMessage(playerid, COLOR_BLUE, !"Вы были уволены по собственному желанию");
	    uninvite_player(playerid);
	}
	return 1;
}
CMD:togphone(playerid, params[])//TESTCMD
{
    if (pInfo[playerid][VIPRank] >= VIP_PACK_BRONZE || pInfo[playerid][pAdmin] >= 1 || pInfo[playerid][pLeader] >= 1)
	{
		if (!pTemp[playerid][PlayerPhoneOnline]) pTemp[playerid][PlayerPhoneOnline] = true;
		else pTemp[playerid][PlayerPhoneOnline] = false;
		new string_[32];
		format(string_, sizeof(string_), "Ваш телефон %s!",pTemp[playerid][PlayerPhoneOnline] ? ("выключен") : ("включен"));
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	else return err(!"Вы не админ / лидер организации / VIP игрок!");
	return 1;
}
CMD:vip(playerid,params[]) {
	if (pInfo[playerid][VIPRank] == VIP_PACK_NONE) return true;
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (isnull(params) || strlen(params) > 144) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /v [текст]");
	new 
		string_[128],
		vip_[32]; 
	switch(pInfo[playerid][VIPRank])
	{
		case VIP_PACK_BRONZE: vip_ = "{D2691E}[BRONZE]";
		case VIP_PACK_SILVER: vip_ = "{C0C0C0}[SILVER]";
		case VIP_PACK_GOLD: vip_ = "{FFD700}[GOLD]";
		case VIP_PACK_PLATINUM: vip_ = "{FF00FF}[PLATINUM]";
		case VIP_PACK_DIAMOND: vip_ = "{4285b4}[DIAMOND]";
		default: vip_ = ""colwarn"[ERROR]";
	}
	format(string_, sizeof string_, "%s "colwhi"%s[%d]: %s", vip_, pInfo[playerid][pName], playerid, params);
	SendVIPMessage(COLOR_WHITE, string_);
	return 1;
}
alias:vip("v");
stock SendVIPMessage(color, const message[])
{
	foreach(new i: PlayerInLogin)
	{
		if (pInfo[i][VIPRank] == VIP_PACK_NONE && !GetPVarInt(i, #MessageOnVIP_adm)) continue;
		SendClientMessage(i, color, message);
	}
}
stock GetVipPackPlayerValue(playerid, E_VIP_PACK: type, currentValue = 0) {
	new 
		vipLevel = pInfo[playerid][VIPRank], 
		value = gVipPlayer[vipLevel][type], return_value;

	switch (type) {
		case vCashBack: { // %
			if (!value) return_value = currentValue;
			else return_value = currentValue * (value) / 100;
		}
		case vSaleCar, vSaleSkin, vSaleHome, vSaleBizz: { // (скидки-%) *= value
			if (!value) return_value = currentValue;
			else return_value = currentValue - (currentValue * value / 100);
		}
		case vPercentSalary, vPercentfSalary: { // (надбавки+%) *= value
			
			if (!value) return_value = currentValue;
			else return_value = currentValue + (currentValue * value / 100);
		}
		case vCountBizz:
		{
			if (!value) return_value = 1;
			else return_value = value;
		}
		case vSkillJobTruck: {
			if (!value) return_value = currentValue;
			else return_value = (currentValue * value);
		}
		default: return_value = value;
	}
	return return_value;
}
stock GetBoostPackPlayerValue(playerid, E_BOOST_PACK: type, currentValue = 0) {
	new 
		boostLevel = pInfo[playerid][BoostRank], 
		value = BoostPlayer[boostLevel][type], return_value;

	switch (type) {
		case bCashBack: { // %
			if (!value) return_value = currentValue;
			else return_value = currentValue * (value) / 100;
		}
		case bSaleCar, bSaleSkin, bSaleHome: { // (скидки-%)
			
			if (!value) return_value = currentValue;
			else return_value = currentValue - (currentValue * value / 100);
		}
		case bPercentSalary, bPercentfSalary: { // (надбавки+%)
			
			if (!value) return_value = currentValue;
			else return_value = currentValue + (currentValue * value / 100);
		}
		case bGiveMaterials, bGiveDrugs: {
            if (!value) return_value = 0;
            else return_value = value;
        }
		case bSkillJobTruck: {
			if (!value) return_value = currentValue;
			else return_value = (currentValue * value);
		}
		default: return_value = value;
	}
	return return_value;
} 
stock CheckPlayerVipTime(playerid) {
	if (!pInfo[playerid][VIPRank]) return;

	if (gettime() > pInfo[playerid][VIPTime]) {
		pInfo[playerid][VIPRank] = 0;
		pInfo[playerid][VIPTime] = 0; 
		new 
			query_[64];
		format(query_, sizeof query_,"`vip_rank` = '%i', `vip_time` = '%i'",pInfo[playerid][VIPRank], pInfo[playerid][VIPTime]);
		SavePlayerStr(playerid,query_); 
		if (GetPlayerBusinesses(playerid) > GetPlayerAvailableBusiness(playerid)) {
			for (new id = 0, amount = 0; id < MAX_PLAYER_BUSINESS; id++) {
				if (!pInfo[playerid][pBusinessID][id]) 
					continue;
				if (++amount <= GetPlayerAvailableBusiness(playerid))  
					continue;
				ClearBusiness(pInfo[playerid][pBusinessID][id] - 1, .type_sell = 1);
				//printf("[businesses] Бизнес #%i был продан из-за слета VIP (%s)!", BusinessInfo[pInfo[playerid][pBusinessID][id] - 1][bID], pInfo[playerid][pName]);
			}
		}
		SendClientMessage(playerid, COLOR_RED, !"Внимание! Время вашего VIP статуса истекло, необходимо продлить!");
	} 
}
stock CheckPlayerBoostTime(playerid) {
	if (!pInfo[playerid][BoostRank]) return;

	if (gettime() > pInfo[playerid][BoostTime]) {
		pInfo[playerid][BoostRank] = 0;
		pInfo[playerid][BoostTime] = 0;

		new 
			query_[64];
		format(query_, sizeof query_,"`boost_rank` = '%i', `boost_time` = '%i'",pInfo[playerid][BoostRank], pInfo[playerid][BoostTime]);
		SavePlayerStr(playerid,query_); 

		SendClientMessage(playerid, COLOR_RED, !"Внимание! Время вашего Boost пакета истекло!");
	} 
} 
GetVIPLimitMaterials(playerid) {
	new 
		materials = 500;
	switch(pInfo[playerid][VIPRank]) {
		case VIP_PACK_NONE: materials = 500;
		case VIP_PACK_BRONZE, VIP_PACK_SILVER: materials = 800;
		case VIP_PACK_GOLD: materials = 1200;
		case VIP_PACK_PLATINUM, VIP_PACK_DIAMOND: materials = 1500;
	} 
	return materials;
}
GetVIPLimitDrugs(playerid) {
	new 
		drugs_ = 150;
	switch(pInfo[playerid][VIPRank]) {
		case VIP_PACK_NONE: drugs_ = 150;
		case VIP_PACK_BRONZE, VIP_PACK_SILVER: drugs_ = 250;
		case VIP_PACK_GOLD: drugs_ = 300;
		case VIP_PACK_PLATINUM, VIP_PACK_DIAMOND: drugs_ = 400;
	} 
	return drugs_;
}
GetVIPLimitPayCash(playerid) {
	new
		pay_cash = 100000;
	switch(pInfo[playerid][VIPRank]) {
		case VIP_PACK_NONE: pay_cash = 150000;
		case VIP_PACK_BRONZE, VIP_PACK_SILVER: pay_cash = 200000;
		case VIP_PACK_GOLD: pay_cash = 250000;
		case VIP_PACK_PLATINUM, VIP_PACK_DIAMOND: pay_cash = 400000;
	}
	return pay_cash;
}
/*
None =
	Money = 0
	Percetn = 0
	Licenses = 0
	Exp = 1
	CashBack = 0  
	fPercent = 0
	SaleCar = 0
	SaleSkin = 0
	SaleHome = 0
	SkillGun = 1
	SkillTaxi = 1
	SkillTruck = 1
	SkillProd = 1
	SkillTheftCar = 1
	TimerFerm = 0
	TimerDrugs = 0
Start = 150
	Money = 50000
	Percetn = 5
	Licenses = 
	Exp = 2
	CashBack = 5 
	fPercent = 0
	SaleCar = 5
	SaleSkin = 5
	SaleHome = 5
	SkillGun = 1
	SkillTaxi = 1
	SkillTruck = 1
	SkillProd = 1
	SkillTheftCar = 1
	TimerFerm = 0
	TimerDrugs = 0
INSERT INTO `s_boost_pack` (`id`, `money`, `percent_salary`, `licenses`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES ('3', '100000', '10', '0, 0, 0, 0, 0, 0', '2', '10', '10', '10', '10', '10', '2', '2', '2', '2', '2', '0', '0');
PRO = 299
	Money = 100000
	Percetn = 10
	Licenses = 
	Exp = 2
	CashBack = 10 
	fPercent = 10
	SaleCar = 10
	SaleSkin = 10
	SaleHome = 10
	SkillGun = 2
	SkillTaxi = 2
	SkillTruck = 2
	SkillProd = 2
	SkillTheftCar = 2
	TimerFerm = 0
	TimerDrugs = 0
INSERT INTO `s_boost_pack` (`id`, `money`, `percent_salary`, `licenses`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES ('4', '300000', '15', '0, 0, 0, 0, 0, 0', '3', '10', '15', '15', '15', '15', '3', '3', '2', '2', '2', '0', '0');
Power = 499
	Money = 300000
	Percetn = 15
	Licenses = 
	Exp = 3
	CashBack = 10 
	fPercent = 15
	SaleCar = 15
	SaleSkin = 15
	SaleHome = 15
	SkillGun = 3
	SkillTaxi = 3
	SkillTruck = 2
	SkillProd = 2
	SkillTheftCar = 2
	TimerFerm = 0
	TimerDrugs = 0
INSERT INTO `s_boost_pack` (`id`, `money`, `percent_salary`, `licenses`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES ('5', '1000000', '20', '0, 0, 0, 0, 0, 0', '4', '15', '20', '20', '20', '1520', '4', '3', '3', '3', '3', '0', '0');
Boss = 799
	Money = 1000000
	Percetn = 20
	Licenses = 
	Exp = 4
	CashBack = 15 
	fPercent = 20
	SaleCar = 20
	SaleSkin = 20
	SaleHome = 20
	SkillGun = 4
	SkillTaxi = 3
	SkillTruck = 3
	SkillProd = 3
	SkillTheftCar = 3
	TimerFerm = 0
	TimerDrugs = 0
*/
/*new 
	boos_ = pInfo[playerid][pBoost];
pInfo[playerid][pExp] += BoostPlayer[boos_][bPayDayExp]*/
/*
VIP None = 0
	Money = 0
	PercentSalary = 0
	Licenses[6] =0
	PayDayExp =1
	CashBack =0
	PercentfSalary =0
	SaleCar =0
	SaleSkin =0
	SaleHome =0
	SaleBizz =0
	CountBizz = 1
	CountCar = 1
	SkillGun =0
	SkillJobTaxi =0
	SkillJobTruck =0
	SkillJobProd =0
	SkillTheftCar =0
	TimerFerm =0
	TimerDrugs =0

VIP BRONZE = 300
	Money = 5000 Каждый PayDay
	PercentSalary = 5 
	PayDayExp = 1
	CashBack = 5
	PercentfSalary = 5
	SaleCar = 5
	SaleSkin = 5
	SaleHome = 5
	SaleBizz = 5
	CountBizz = 1
	CountCar = 1
	SkillGun = 2
	SkillJobTaxi = 3
	SkillJobTruck = 3
	SkillJobProd = 3
	SkillTheftCar = 3
	TimerFerm =
	TimerDrugs =


VIP SILVER = 500
	Money = 7500 Каждый PaDay
	PercentSalary =  10 
	PayDayExp = 2
	CashBack = 10
	PercentfSalary = 10
	SaleCar = 10
	SaleSkin = 10
	SaleHome = 10
	SaleBizz = 10
	CountBizz = 2
	CountCar = 2
	SkillGun = 3
	SkillJobTaxi = 3
	SkillJobTruck = 3
	SkillJobProd = 3
	SkillTheftCar = 3
	TimerFerm =
	TimerDrugs =
	INSERT INTO `s_vip_pack` (`id`, `money`, `percent_salary`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `sale_bizz`, `count_bizz`, `count_car`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES\
		('3', '7500', '10', '2', '10', '10', '10', '10', '10', '10', '2', '2', '3', '3', '3', '3', '3', '0', '0');

VIP GOLD = 700
	Money = 8500
	PercentSalary = 15 
	PayDayExp = 2
	CashBack = 10
	PercentfSalary = 15
	SaleCar = 15
	SaleSkin = 15
	SaleHome = 15
	SaleBizz = 15
	CountBizz = 2
	CountCar = 2
	SkillGun = 3
	SkillJobTaxi = 3
	SkillJobTruck = 3
	SkillJobProd = 3
	SkillTheftCar = 3
	TimerFerm =
	TimerDrugs =
	INSERT INTO `s_vip_pack` (`id`, `money`, `percent_salary`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `sale_bizz`, `count_bizz`, `count_car`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES\
 ('4', '8500', '15', '2', '10', '15', '15', '15', '15', '15', '2', '2', '3', '3', '3', '3', '3', '0', '0');

VIP PLATINUM = 1000
	Money = 9500
	PercentSalary =  20 
	PayDayExp = 3
	CashBack = 15
	PercentfSalary = 20
	SaleCar = 20
	SaleSkin = 20
	SaleHome = 20
	SaleBizz = 20
	CountBizz = 3
	CountCar = 3
	SkillGun = 3
	SkillJobTaxi = 3
	SkillJobTruck = 3
	SkillJobProd = 3
	SkillTheftCar = 3
	TimerFerm =
	TimerDrugs =
	INSERT INTO `s_vip_pack` (`id`, `money`, `percent_salary`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `sale_bizz`, `count_bizz`, `count_car`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES\
 ('5', '9500', '20', '3', '15', '20', '20', '20', '20', '20', '3', '3', '3', '3', '3', '3', '3', '0', '0');

VIP DIAMOND = 1500
	Money = 10000
	PercentSalary = 25 
	PayDayExp = 3
	CashBack = 20
	PercentfSalary = 25
	SaleCar = 25
	SaleSkin = 25
	SaleHome = 25
	SaleBizz = 25
	CountBizz = 3
	CountCar = 3
	SkillGun = 6
	SkillJobTaxi = 6
	SkillJobTruck = 6
	SkillJobProd = 6
	SkillTheftCar = 6
	TimerFerm =
	TimerDrugs =
	INSERT INTO `s_vip_pack` (`id`, `money`, `percent_salary`, `exp`, `cashback`, `f_salary`, `sale_car`, `sale_skin`, `sale_home`, `sale_bizz`, `count_bizz`, `count_car`, `skill_gun`, `skill_taxi`, `skill_truck`, `skill_prod`, `skill_theft`, `timer_ferm`, `timer_drugs`) VALUES\
	('6', '10000', '25', '3', '20', '25', '25', '25', '25', '25', '3', '3', '6', '6', '6', '6', '6', '0', '0');
*/
