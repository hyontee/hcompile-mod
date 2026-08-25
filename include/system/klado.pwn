
//==============   [Klado system]   =================
new timer_kaldo;
new kladotimer_zakaz = 2000;
new kladozakaz[MAX_PLAYERS];

new kladoone[MAX_PLAYERS];
new kladotwo[MAX_PLAYERS];
new kladothree[MAX_PLAYERS];
new kladofour[MAX_PLAYERS];
new kladofive[MAX_PLAYERS];
//===================================================
CMD:klado(playerid)
{
	if(kladozakaz[playerid] == 1)
	{
		SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы уже взяли заказ!");
	}
	else
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 827.215393,-1379.809814,40.716537))
		{
			new string[128];
			format(string, sizeof(string),
			"Test Text");
			SPD(playerid, DIALOG_PANTILEEVICH, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Пантилеевич", string, "Начать", "Закрыть");
		}
		else
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Использовать данную команду можно только у Пантилеевича!");
		}
	}
	return 1;
}
CMD:kexit(playerid)
{
	if(kladozakaz[playerid] == 0)
	{
		SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы не можете закончить работу т.к вы не взяли заказ!");
	}
	else
	{
		KillTimer(timer_kaldo);
		SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно прекратили работу!");
	}
	return 1;
}

CMD:kladoone(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2212.019531,2651.057128,20.577194))
	{
		if(kladozakaz[playerid] == 0)
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас не взят заказ!");
		}
		else
		{
			if(kladoone[playerid] == 1)
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы уже подобрали первый клад!");
			}
			else
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно подобрали первый клад!");
				kladoone[playerid] = 1;
				SetPlayerPos(playerid, 2239.305908,2657.435546,21.600778);
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно телепортировались к 2 кладу!");
			}
		}
	}
	else SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться у первого клада!");
	return 1;
}
CMD:kladotwo(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2239.305908,2657.435546,21.600778))
	{
		if(kladozakaz[playerid] == 0)
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас не взят заказ!");
		}
		else
		{
			if(kladotwo[playerid] == 1)
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы уже подобрали второй клад!");
			}
			else
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно подобрали второй клад!");
				kladotwo[playerid] = 1;
				SetPlayerPos(playerid,  2253.698486,2677.848388,21.965864);
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно телепортировались кo 2 кладу!");
			}
		}
	}
	else SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться у второго клада!");
	return 1;
}
CMD:kladothree(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2253.698486,2677.848388,21.965864))
	{
		if(kladozakaz[playerid] == 0)
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас не взят заказ!");
		}
		else
		{
			if(kladothree[playerid] == 1)
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы уже подобрали третий клад!");
			}
			else
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно подобрали третий клад!");
				kladothree[playerid] = 1;
				SetPlayerPos(playerid, 2257.379150,2702.074707,21.448757);
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно телепортировались к 4 кладу!");
			}
		}
	}
	else SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться у третьего клада!");
	return 1;
}
CMD:kladofour(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2257.379150,2702.074707,21.448757))
	{
		if(kladozakaz[playerid] == 0)
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас не взят заказ!");
		}
		else
		{
			if(kladofour[playerid] == 1)
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы уже подобрали четвертый клад!");
			}
			else
			{
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно подобрали четвертый клад!");
				kladofour[playerid] = 1;
				SetPlayerPos(playerid, 2247.478027,2724.226562,21.310909);
				SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно телепортировались к 5 кладу!");
			}
		}
	}
	else SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться у четвертого клада!");
	return 1;
}
CMD:kladofive(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2247.478027,2724.226562,21.310909))
	{
		if(kladozakaz[playerid] == 0)
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас не взят заказ!");
		}
		else	
		{
			SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно подобрали пятый клад!");
			GivePlayerMoneyEx(playerid, 38000);
			new string[128];
			format(string, sizeof(string), ""c_yellow"[Уведомление]"c_white" Вы получили 38000 рублей");
			SCM(playerid, COLOR_WHITE, string);
			KillTimer(timer_kaldo);
			kladofive[playerid] = 0;
			kladofour[playerid] = 0;
			kladothree[playerid] = 0;
			kladotwo[playerid] = 0;
			kladoone[playerid] = 0;
			kladozakaz[playerid] = 0;
		}
	}
	else SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться у пятого клада!");
	return 1;
}
CMD:kinfo(playerid)
{
	new string[550];
	format(string, sizeof(string), 
	""c_white"/klado - Команда начинающая работу(использовать можно только у пантилеевича)\n\
	/kladoone - Добыча первого клада (использовать можно только у первого клада)\n\
	/kladotwo - Добыча второго клада (использовать можно только у второго клада)\n\
	/kladothree - Добыча третьего клада (использовать можно только у третьего клада)\n\
	/kladofour - Добыча четвертого клада (использовать можно только у четвертого клада)\n\
	/kladofive- Добыча пятого клада (использовать можно только у пятого клада)"
	);
	SPD(playerid, 45454547474, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Информация о кладоискателе", string, "Закрыть", "");
}
CMD:tpklado(playerid)
{
	SetPlayerPos(playerid, 827.215393,-1379.809814,40.716537);
}
//Timers вниз мода
forward KladoTimer(playerid);
public KladoTimer(playerid)
{
	if(kladotimer_zakaz > 0)
	{
		kladotimer_zakaz--;
		new stirng[128];
		format(stirng, sizeof(stirng), ""c_yellow"[Уведомление]"c_white" У вас осталось %d секунд!", kladotimer_zakaz);
		SCM(playerid, COLOR_WHITE, stirng);
	}
	else
	{
		kladotimer_zakaz = 2000;
		KillTimer(timer_kaldo);
		SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Время вышло!");
		kladozakaz[playerid] = 0;
	}
	return 1;
}
//=== OnDialogResponse 
case DIALOG_PANTILEEVICH:
{
	if(response)
	{
		kladozakaz[playerid] = 1;
		KladoTimers(playerid);
		SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Для прекращения работы введите /kexit");
		SetPlayerPos(playerid, 2212.019531,2651.057128,20.577194);
		SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно телепортировались к 1 кладу!");
		return 1;
	}
}
//Добавить  в диалоги
DIALOG_PANTILEEVICH
//В public OnPlayerDisconnect
kladofive[playerid] = 0;
kladofour[playerid] = 0;
kladothree[playerid] = 0;
kladotwo[playerid] = 0;
kladoone[playerid] = 0;
kladozakaz[playerid] = 0;
KillTimer(timer_kaldo);

//В OnGameModeInit
CreateDynamic3DTextLabel("{FFFF00}Первый клад\nВведите /kladoone", 0xFFFF00FF, 2212.019531,2651.057128,20.577194 + 1.5, 10.0);
CreateDynamic3DTextLabel("{FFFF00}Второй клад\nВведите /kladotwo", 0xFFFF00FF, 2239.305908,2657.435546,21.60077 + 1.5, 10.0);
CreateDynamic3DTextLabel("{FFFF00}Третий клад\nВведите /kladothree", 0xFFFF00FF, 2253.698486,2677.848388,21.965864 + 1.5, 10.0);
CreateDynamic3DTextLabel("{FFFF00}Четвертый клад\nВведите /kladofour", 0xFFFF00FF, 2257.379150,2702.074707,21.44875 + 1.5, 10.0);
CreateDynamic3DTextLabel("{FFFF00}Пятый клад\nВведите /kladofive", 0xFFFF00FF,2247.478027,2724.226562,21.310909 + 1.5, 10.0);
CreateActor(83, 827.215393,-1379.809814,40.716537,343.521972);
CreateDynamic3DTextLabel("{FFFF00}Пантилеевич\nРабота кладоискателя\nВведите /klado для начала работы", 0xFFFF00FF, 827.215393,-1379.809814,40.716537 + 1.5, 10.0);

//===== ПОМНИТЕ ЭТО ПЕРВАЯ ВЕРСИЯ КЛАДОИСКАТЕЛЯ!!
//В СЛУЧАЕ СЛИВА СЛЕДУЙЩИИ ВЕРСИИ НЕ БУДУТ СЛИТЫ!!!!!!
//АВТОР СЛИВА Neizvestev
//Автор кода N1kso
//Всем удачи!