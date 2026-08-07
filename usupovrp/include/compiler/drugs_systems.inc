#define MAX_DRUGS_COUNT	12
new 
	arDrugs[MAX_DRUGS_COUNT],
	arDrugMan,
	arNarkoMan;

stock LoadDrugsEtc()
{
	CreateDynamic3DTextLabel("{1D99D4}Фермер Эдуард", COLOR_WHITE, 0.0361,-2910.4590,32.2430 + 1.0, 10.0);
	CreateActor(30, 0.0361,-2910.4590,32.2430,358.5844);

	arDrugMan = CreateDynamicSphere(-0.0309, -2909.7615, 32.2168, 1.0, 0, 0);

	CreateDynamic3DTextLabel("{1D99D4}Барыга Саня", COLOR_WHITE, -2227.4175,251.5437,24.5337 + 1.0, 10.0);
	CreateActor(146, -2227.4175,251.5437,24.5337,32.8592);
	arNarkoMan = CreateDynamicSphere(-2227.4175,251.5437,24.5337, 1.5, 0, 0);

	CreateDynamicObject(11106, -15.301549,-2924.711425,33.132476, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -19.522300,-2924.624511,33.212432, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -24.377805,-2924.682128,33.142517, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -15.343621,-2921.210205,33.092498, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -19.460269,-2921.292724,33.102458, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -24.391633,-2921.147460,33.172454, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -15.375489,-2917.675048,32.922122, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -19.268526,-2917.559570,33.072513, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -24.299324,-2917.535644,33.142456, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -15.368749,-2914.541503,33.116638, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -19.332614,-2914.562500,33.012458, 0.000000,0.000000,0.000000);
	CreateDynamicObject(11106, -24.235105,-2914.388183,33.152431, 0.000000,0.000000,0.000000);


	arDrugs[0] = CreateDynamicSphere(-15.301549,-2924.711425,33.132476,1.0, 0, 0);
	arDrugs[1] = CreateDynamicSphere(-19.522300,-2924.624511,33.212432,1.0, 0, 0);
	arDrugs[2] = CreateDynamicSphere(-24.377805,-2924.682128,33.142517,1.0, 0, 0);
	arDrugs[3] = CreateDynamicSphere(-15.343621,-2921.210205,33.092498,1.0, 0, 0);
	arDrugs[4] = CreateDynamicSphere(-19.460269,-2921.292724,33.102458,1.0, 0, 0);
	arDrugs[5] = CreateDynamicSphere(-24.391633,-2921.147460,33.172454,1.0, 0, 0);
	arDrugs[6] = CreateDynamicSphere(-15.375489,-2917.675048,32.922122,1.0, 0, 0);
	arDrugs[7] = CreateDynamicSphere(-19.268526,-2917.559570,33.072513,1.0, 0, 0);
	arDrugs[8] = CreateDynamicSphere(-24.299324,-2917.535644,33.142456,1.0, 0, 0);
	arDrugs[9] = CreateDynamicSphere(-15.368749,-2914.541503,33.116638,1.0, 0, 0);
	arDrugs[10] = CreateDynamicSphere(-19.332614,-2914.562500,33.012458,1.0, 0, 0);
	arDrugs[11] = CreateDynamicSphere(-24.235105,-2914.388183,33.152431,1.0, 0, 0);


	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-15.301549,-2924.711425,33.132476 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-19.522300,-2924.624511,33.212432 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-24.377805,-2924.682128,33.142517 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-15.343621,-2921.210205,33.092498 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-19.460269,-2921.292724,33.102458 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-24.391633,-2921.147460,33.172454 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-15.375489,-2917.675048,32.922122 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-19.268526,-2917.559570,33.072513 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-24.299324,-2917.535644,33.142456 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE,-15.368749,-2914.541503,33.116638 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE, -19.332614,-2914.562500,33.012458 + 1.0, 3.0);
	CreateDynamic3DTextLabel(""cMain"Куст наркотиков\n"cLGREY"[ Подойдите ]", COLOR_WHITE, -24.235105,-2914.388183,33.152431 + 1.0, 3.0);

	for(new i; i < MAX_NARKOPRITON; i++)
	{
		nData[i][narkoID] = INVALID_PLAYER_ID;
	}
	return true;
}

stock OnPlayerEnterDrugsArea(playerid, areaid)
{
	if(areaid >= arDrugs[0] && areaid <= arDrugs[MAX_DRUGS_COUNT-1])
	{
		if(!GetPVarInt(playerid, "drugs_work"))
			return true;

		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 0, 0);

		SetTimerEx("TimerTakeDrugs", 5000, false, "i", playerid);
		return true;
	}
	else if(areaid == arDrugMan)
	{
		if(PI[playerid][pMember] != TEAM_CSKA && PI[playerid][pMember] != TEAM_SPARTAK)
			return SendErr(playerid, "Вам здесь нечего делать");

		if(GetPVarInt(playerid, "drugs_work"))
			return SendErr(playerid, "Вы уже арендовываете поле");

		return ShowPlayerDialog(playerid, 2430, DIALOG_STYLE_MSGBOX, "{1D99D4}Фермер Эдуард", "\n\
			"cWH"Желаешь арендовать нарко-поле для сбора наркотиков?\n\n\
			Стоимость аренды - "cGR"100.000 рублей"cWH".\n\
			"cWH"Вы действительно хотите арендовать поле на "cLGREY"3 минуты"cWH"?", "Арендовать", "Отмена");
	}
	else if(areaid == arNarkoMan)
	{
		if(!IsAGang(playerid) && !IsAMafia(playerid) && PI[playerid][pMember] != TEAM_HITMAN)
			return SendErr(playerid, "Вам здесь нечего делать");

		
		String1024[0] = EOS;

		format(String1024, sizeof String1024, "\
		"cMain"- "cWH"Выставить свой товар на продажу");

		new 
			count = 1;

		for(new i; i < MAX_NARKOPRITON; i++)
		{
			if(nData[i][narkoID] == INVALID_PLAYER_ID)
				continue;

			format(String1024, sizeof(String1024), "%s\n\
			"cWH"%s\tКол-во: {CCCCCC}%i\t"cWH"Цена за гр: "cGR"%i р", String1024, GetName(nData[i][narkoID]), nData[i][narkoCount], nData[i][narkoPrice]);

			SetPlayerListitemValue(playerid, count, i);
			count ++;
		}
		ShowPlayerDialog(playerid, 2431, DIALOG_STYLE_LIST, !""cMain"Наркопритон", String1024, !"Выбрать", !"Закрыть");		
	}
	return true;
}

DLG(2431, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	
	switch(listitem)
	{
		case 0:
		{
			if(!IsAGang(playerid))
				return SendErr(playerid, "Выставлять товар может только ОПГ");

			if(GetPVarInt(playerid, "narkopriton"))
				return SendErr(playerid, "У вас уже выставлен товар");

			new 
				count;

			for(new i; i < MAX_NARKOPRITON; i++)
			{
				if(nData[i][narkoID] == INVALID_PLAYER_ID)
				{
					count ++;
					ShowPlayerDialog(playerid, 2432, DIALOG_STYLE_INPUT, !""cMain"Наркопритон", !"\
					"cWH"Введите количество наркотиков,\n\
					которое хотите выставить на продажу:", !"Далее", !"Закрыть");
					break;	
				}
			}
			if(!count)
				return SendErr(playerid, "Все места заняты");
		}
		default:
		{
			new 
			 	id = GetPlayerListitemValue(playerid, listitem);
			SetPVarInt(playerid, "narkopritonid", id);
			format(String256, sizeof(String256), "\
			"cWH"Введите количество, которое хотите купить:\n\n\
			"cLGREY"Примечание: продается %i гр. по %i рублей за гр", nData[id][narkoCount], nData[id][narkoPrice]);

			ShowPlayerDialog(playerid, 2434, DIALOG_STYLE_INPUT, !""cMain"Наркопритон", String256, !"Купить", !"Закрыть");
		}
	}
	return true;
}

DLG(2434, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	new 
		id = GetPVarInt(playerid, "narkopritonid");

	if(!strval(inputtext))
		return SendErr(playerid, "Вы ввели некорректное значение");

	if(strval(inputtext) < 1 || nData[id][narkoCount] < strval(inputtext))
		return SendErr(playerid, "Вы ввели некорректное значение");

	if(GetPlayerRubble(playerid) < strval(inputtext)*nData[id][narkoPrice])
		return SendErr(playerid, "У Вас нет нужной суммы на руках");

	new newslot;
	if(CheckMaxVes(playerid,44,strval(inputtext),newslot)==1)
		return SendClientMessage(playerid,COLOR_GREY,"У вас нет свободного места в инвентаре!");


	PlayerItem1[playerid][newslot] = 44;
	PlayerItem2[playerid][newslot] += strval(inputtext);
	SaveItem(playerid,newslot);

	nData[id][narkoCount] -= strval(inputtext);

	SetPlayerMoney(playerid, -strval(inputtext)*nData[id][narkoPrice]);
	SetPlayerMoney(nData[id][narkoID], strval(inputtext)*nData[id][narkoPrice]);

	fLogs("%s купил у %s %i гр. нарко за %i рублей", GetName(playerid), GetName(nData[id][narkoID]), strval(inputtext), strval(inputtext)*nData[id][narkoPrice]);

	format(String144, sizeof(String144), "Вы купили %i гр. наркотиков за %i рублей у %s", strval(inputtext), strval(inputtext)*nData[id][narkoPrice], GetName(nData[id][narkoID]));
	SendSucc(playerid, String144);

	format(String144, sizeof(String144), "%s купил у Вас %i гр. наркотиков за %i рублей", GetName(playerid), strval(inputtext), strval(inputtext)*nData[id][narkoPrice]);
	SendSucc(nData[id][narkoID], String144);

	if(nData[id][narkoCount] == 0)
	{
		DeletePVar(nData[id][narkoID], "narkopriton");
		SendInf(nData[id][narkoID], "У Вас купили весь товар");
		nData[id][narkoID] = INVALID_PLAYER_ID;
		nData[id][narkoPrice] = 0;
	}
	return true;
}

DLG(2432, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	new ok = SearchInventoryItem(playerid, 44);

	new 
		count = strval(inputtext);

	if(!ok) 
		return SendErr(playerid, "У вас нет предмета");

	if(PlayerItem2[playerid][ok] < count)
		return SendClientMessage(playerid,COLOR_GREY,"У вас нет столько наркотиков");

	if(count < 1)
		return ShowPlayerDialog(playerid, 2432, DIALOG_STYLE_INPUT, !""cMain"Наркопритон", !"\
			"cWH"Введите количество наркотиков,\n\
			которое хотите выставить на продажу:", !"Далее", !"Закрыть");

	if(!PlayerItem2[playerid][ok]) PlayerItem1[playerid][ok]=0;

	SetPVarInt(playerid, "narko_count", count);

	ShowPlayerDialog(playerid, 2433, DIALOG_STYLE_INPUT, !""cMain"Наркопритон", !"\
		"cWH"Введите сумму за 1 гр. наркотиков.\n\n\
		"cLGREY"Примечание: цена должна быть от 10 руб. до 1000 руб.", !"Далее", !"Закрыть");
	return true;
}

DLG(2433, playerid, response, listitem, inputtext[])
{
	new 
		cost = strval(inputtext),
		narko_count = GetPVarInt(playerid, "narko_count");

	if(!strval(inputtext))
		return ShowPlayerDialog(playerid, 2433, DIALOG_STYLE_INPUT, !""cMain"Наркопритон", !"\
		"cWH"Введите сумму за 1 гр. наркотиков.\n\n\
		"cLGREY"Примечание: цена должна быть от 10 руб. до 1000 руб.", !"Далее", !"Закрыть");

	if(cost < 10 || cost > 1000)
		return ShowPlayerDialog(playerid, 2433, DIALOG_STYLE_INPUT, !""cMain"Наркопритон", !"\
		"cWH"Введите сумму за 1 гр. наркотиков.\n\n\
		"cLGREY"Примечание: цена должна быть от 10 руб. до 1000 руб.", !"Далее", !"Закрыть");

	new 
		count;

	for(new i; i < MAX_NARKOPRITON; i++)
	{
		if(nData[i][narkoID] == INVALID_PLAYER_ID)
		{
			count ++;
			nData[i][narkoID] = playerid;
			nData[i][narkoCount] = narko_count;
			nData[i][narkoPrice] = cost;
			new ok = SearchInventoryItem(playerid, 44);
			PlayerItem2[playerid][ok] -= narko_count;
			UpDateInv(playerid);
			SaveItem(playerid,ok);
			SendSucc(playerid, "Вы выставили товар");
			SetPVarInt(playerid, "narkopriton", 1);
			break;	
		}
	}
	if(!count)
		return SendErr(playerid, "Все места заняты");
	
	return true;
}

DLG(2430, playerid, response, listitem, inputtext[])
{
	if(!response)
		return true;
	SetPlayerMoney(playerid, -100000);
	SetPVarInt(playerid, "drugs_work", 1);
	SetTimerEx("DrugsEndWork", 180000, false, "i", playerid);
	SendSucc(playerid, "Вы арендовали нарко-ферму на 3 минуты");
	SendInf(playerid, "Нарко поле отмечено на карте");

	UseGPS[playerid] = true;
	SetPlayerCheckpoint(playerid, -19.2468,-2912.2285,33.5224, 4.0);
	return true;
}

callback:: DrugsEndWork(playerid)
{
	if(GetPVarInt(playerid, "drugs_work"))
	{
		DeletePVar(playerid, "drugs_work");
		SendInf(playerid, "Время аренды поля закончено");
	}
	return true;
}

callback:: TimerTakeDrugs(playerid)
{
	new 	
		newslot;

	if(CheckMaxVes(playerid,44,10,newslot)==1)
	{
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 1);
		return SendClientMessage(playerid,COLOR_GREY,"У вас нет свободного места в инвентаре!");
	}

	PlayerItem1[playerid][newslot] = 44;
	PlayerItem2[playerid][newslot] += 10;
	SaveItem(playerid,newslot);
	SendInf(playerid, "Вы собрали "cGREY"10 грамм "cWH"наркотиков");

	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, 1);
	return true;
}