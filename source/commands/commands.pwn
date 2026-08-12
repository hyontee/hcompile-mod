CMD:fish(playerid)
{
    ShowPlayerFishMenu(playerid);
	return 1;
}//

ShowPlayerFishMenu(playerid) {
	ShowPlayerDialog(playerid, D_PLAYER_FISH, DIALOG_STYLE_LIST, "Рыбалка","[0] Начать / Закончить рыбалку\n\
	[1] Накопать червей\n\ 
	[2] Приготовить рыбу\n\
	[3] Съесть рыбу\n\
	[4] Информация\n\
	[-] Помощь", "Выбрать", "Назад"); 
	return 1;
}

CMD:infos(playerid)
{
    SendClientMessage(playerid, COLOR_RED, "---------------------------------------------------------------------------------------");
	SendClientMessage(playerid, COLOR_WHITE, "- Tg канал проекта:{FFFF00} t.me/HellRolePlay");
	SendClientMessage(playerid, COLOR_WHITE, "- Покупка доната:{FFFF00} t.me/Devil_Deatns");
	SendClientMessage(playerid, COLOR_WHITE, "- Хочет стать ютубером проекта? Пиши заявку сюда:{FFFF00} t.me/ForumHellRolePlay");
	SendClientMessage(playerid, COLOR_WHITE, "- Хочет стать админом проекта? Оставляй заявку на форуме:{FFFF00} t.me/ForumHellRolePlay");
	SendClientMessage(playerid, COLOR_WHITE, "- Хочет стать лидером проекта? Оставляй заявку на форуме:{FFFF00} t.me/ForumHellRolePlay");
	SendClientMessage(playerid, COLOR_RED, "---------------------------------------------------------------------------------------");
    return 1;
}

CMD:showlic(playerid, params[])
{ 
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /showlic [id]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	new
		Float: Pos_x,
		Float: Pos_y,
		Float: Pos_z;
	GetPlayerPos(params[0], Pos_x, Pos_y, Pos_z);
	if (!IsPlayerInRangeOfPoint(playerid, 6.0, Pos_x, Pos_y, Pos_z)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок далеко от вас!");
	new
		string_[128]; 
	if (params[0] != playerid) {
		format(string_, sizeof string_, "показал(а) свои лицензии %s'у",pInfo[params[0]][pName]);
		MeAction(playerid, string_, SELECT_ACTION_IN_CHAT);
		format(string_, sizeof string_, "показал(а) свои лицензии %s'у",pInfo[params[0]][pName]);
		MeAction(playerid, string_, SELECT_ACTION_IN_BUBBLE);
	}
	else {
		MeAction(playerid, "смотрит свои лицензии", SELECT_ACTION_IN_BUBBLE);
	} 
	format(string_, sizeof string_, "-----------===[ LICENSES %s ]===-----------", pInfo[playerid][pName]);
	SendClientMessage(params[0], 0x059BD3AA, string_);
	if (pInfo[playerid][pLicense][0]) {
		format(string_, sizeof string_, " Водительские права: Есть | Действительны до: %s", date("%dd.%mm.%yyyy", pInfo[playerid][pLicenseTime][0]));
		SendClientMessage(params[0], 0xC5EEFEAA, string_);
	}
	else SendClientMessage(params[0], 0xC5EEFEAA, " Водительские права: Отсутствуют");

	if (pInfo[playerid][pLicense][1]) {
		format(string_, sizeof string_, " Лицензия пилота: Есть | Действительна до: %s", date("%dd.%mm.%yyyy", pInfo[playerid][pLicenseTime][1]));
		SendClientMessage(params[0], 0xC5EEFEAA, string_);
	}
	else SendClientMessage(params[0], 0xC5EEFEAA, " Лицензия пилота: Отсутствует");

	if (pInfo[playerid][pLicense][2]) {
		format(string_, sizeof string_, " Лицензия на катера: Есть | Действительна до: %s", date("%dd.%mm.%yyyy", pInfo[playerid][pLicenseTime][2]));
		SendClientMessage(params[0], 0xC5EEFEAA, string_);
	}
	else SendClientMessage(params[0], 0xC5EEFEAA, " Лицензия на катера: Отсутствует");

	if (pInfo[playerid][pLicense][3]) {
		format(string_, sizeof string_, " Лицензия на охоту: Есть | Действительна до: %s", date("%dd.%mm.%yyyy", pInfo[playerid][pLicenseTime][3]));
		SendClientMessage(params[0], 0xC5EEFEAA, string_);
	}
	else SendClientMessage(params[0], 0xC5EEFEAA, " Лицензия на охоту: Отсутствует");

	if (pInfo[playerid][pLicense][4]) {
		format(string_, sizeof string_, " Лицензия на оружие: Есть | Действительна до: %s", date("%dd.%mm.%yyyy", pInfo[playerid][pLicenseTime][4]));
		SendClientMessage(params[0], 0xC5EEFEAA, string_);
	}
	else SendClientMessage(params[0], 0xC5EEFEAA, " Лицензия на оружие: Отсутствует");
	SendClientMessage(params[0], 0x059BD3AA, !"===============================================");  
	return 1;
}
alias:showlic("licenses", "showlicenses");


CMD:divorce(playerid, params[])
{
    if (GetString(pInfo[playerid][pMarriedTo],"-")) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоит в браке!");
    new id_, query_[128];
    sscanf(pInfo[playerid][pMarriedTo], "u", id_);
	if (PlayerInConnected(id_)) {
		SendMes(id_, COLOR_BLUE, "Ваш супруг(а) %s подал(а) на развод.",pInfo[playerid][pMarriedTo]);
	    SetString(pInfo[id_][pMarriedTo],"-", MAX_PLAYER_NAME);
	    mysql_format(dbHandle,query_, sizeof(query_), "UPDATE s_users SET pMarriedTo = '-' WHERE Name = '%s'",pInfo[id_][pName]);
	}
	else {
		mysql_format(dbHandle,query_, sizeof(query_), "UPDATE s_users SET pMarriedTo = '-' WHERE Name = '%s'",pInfo[playerid][pMarriedTo]);
	}
	mysql_tquery(dbHandle, query_, "", "");

    mysql_format(dbHandle, query_, sizeof(query_), "UPDATE s_users SET pMarriedTo = '-' WHERE Name = '%s'",pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");

    SetString(pInfo[playerid][pMarriedTo],"-", MAX_PLAYER_NAME);
	return SendClientMessage(playerid, COLOR_GREY, !"Вы развелись");
}
#if !defined _poffer_inc
CMD:propose(playerid, params[])
{
    if (kLibGetPlayerMoney(playerid) < 100000) return SendClientMessage(playerid, COLOR_GREY, !"Вам нужно 100.000 на свадьбу!");
    if (!IsPlayerInRangeOfPoint(playerid, 20, -1968.6589,1119.4569,1333.0275)) return SendClientMessage(playerid, COLOR_GREY, !"Команду можно использовать только в церкви.");
	if (!GetString(pInfo[playerid][pMarriedTo],"-")) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже женаты!");
	if (sscanf(params, "u", params[0])) return scm(playerid, COLOR_WHITE, !"Введите: /propose [id]");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!GetString(pInfo[params[0]][pMarriedTo],"-")) return SendClientMessage(playerid, COLOR_GREY, !"Человек уже состоит в браке!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не рядом с вами!");
	if (Select[params[0]][SelectCharWedding] == 255) return SendClientMessage(playerid, COLOR_GREY, !"Человеку уже кто то сделал предложение!");

	SendMes(playerid, 0x6495EDFF, "Вы предложили руку и сердце %s.",pInfo[params[0]][pName]);
	SendMes(params[0], 0x6495EDFF,"%s предлагает вам руку и сердце. (( Нажмите: {33AA33}Y {6495ED}- согласиться или "colred"N {6495ED}- отказаться))",pInfo[playerid][pName]);
	Select[params[0]][SelectCharWedding] = 255;
	SetPVarInt(params[0], "WedderID", playerid);
	return 1;
}
#endif
CMD:ram(playerid, params[])
{
    if (IsACop(playerid)|| IsAArmy(playerid) || pInfo[playerid][pAdmin] >= 1)
	{
		if (pTemp[playerid][tSelectHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть рядом с домом!");
		new
			H_IDX = pTemp[playerid][tSelectHouseID]; 
		if (IsPlayerInRangeOfPoint(playerid, 3, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2])) {
			new
				idx = HouseInfo[H_IDX][hIntID];
			SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]);
			pTemp[playerid][tCurrentHouseID] = H_IDX;
		} 
	}
	return 1;
}
CMD:take(playerid)
{
	if (pInfo[playerid][pAdmin] > 1 ||
		pTemp[playerid][tDutyWork] == 1 && ((pInfo[playerid][pMember] == FRACTION_LSPD || pInfo[playerid][pMember] == FRACTION_FBI || pInfo[playerid][pMember] == FRACTION_SFPD || pInfo[playerid][pMember] == FRACTION_LVPD) && pInfo[playerid][pRank] > 3))
	{
	    if (pInfo[playerid][pAdmin] == 0) { 
			ShowPlayerDialog(playerid, D_TAKELIST_PD_0, DIALOG_STYLE_LIST, "Изъять", "Водительские права\nЛицензия пилота \nЛицензия на лодки\nЛицензия на охоту\nЛицензия на оружие\nМатериалы\nНаркотики\nОружие", "Готово", "Отмена");
		}
		else ShowPlayerDialog(playerid, D_TAKELIST_PD_0, DIALOG_STYLE_LIST, "Изъять", "Водительские права\nЛицензия пилота \nЛицензия на лодки\nЛицензия на охоту\nЛицензия на оружие\nМатериалы\nНаркотики\nОружие", "Готово", "Отмена");
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вы не можете использовать данную команду!");
	return 1;
}
CMD:suspect(playerid, params[])
{
    if (!IsACop(playerid) || pTemp[playerid][tDutyWork] == 0) return 1;

	if (NEW_SUSPECT_SYSTEM) {
		if (sscanf(params, "u", params[0])) 
			return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/su)spect [id]");

		if (!PlayerInConnected(params[0]) || playerid == params[0]) return 1;
		if (pInfo[params[0]][pJailTime] != 0) return 1;
		if (pInfo[params[0]][pWantedLevel] >= 6) return SendClientMessage(playerid, COLOR_GREY, !"У данного игрока уже 6 уровней розыска!");

		pTemp[playerid][pEditSuspectTargetID] = params[0];
		ShowSuspectList(playerid, pInfo[playerid][pMember], D_GIVE_SUSPECT);
		return true;
	} 
	if (sscanf(params, "uds[32]", params[0], params[1], params[2])) 
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/su)spect [id] [уровень розыска] [преступление]");
	if (strlen(params[2]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");

	if (!PlayerInConnected(params[0]) || playerid == params[0]) return 1;
	if (pInfo[params[0]][pJailTime] != 0) return 1;
	if (pInfo[params[0]][pWantedLevel] >= 6) return SendClientMessage(playerid, COLOR_GREY, !"У данного игрока уже 6 уровней розыска!");

	if (params[1] <= pInfo[params[0]][pWantedLevel])
	{
	    new string_[128];
	    format(string_, sizeof string_, "У игрока уже %d Уровень розыска.",pInfo[params[0]][pWantedLevel]);
	    return scm(playerid, COLOR_GREY, string_);
	}
	if (params[1] < 1 || params[1] > 6) return SendClientMessage(playerid, COLOR_GREY, !"Минимальный уровень розыска 1, а максимальный 6.");
	pInfo[params[0]][pWantedLevel] = params[1];
	if (IsACop(params[0])) return SendClientMessage(playerid, COLOR_GRAD2, "Вы не можете давать розыск законникам!");
	SetPlayerWantedLevelEx(params[0], pInfo[params[0]][pWantedLevel]);
	SetPlayerCriminal(params[0],pInfo[playerid][pName], params[2]);
	return 1;
}



CMD:findhouse(playerid, params[])
{
    if (pTemp[playerid][tDutyWork] == 1 && pInfo[playerid][pMember] == FRACTION_FBI && pInfo[playerid][pRank] > 3) return 1;
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /findhouse [дом]");
	SetPlayerCheckpoint(playerid,HouseInfo[params[0]][hEnter][0], HouseInfo[params[0]][hEnter][1], HouseInfo[params[0]][hEnter][2], 4.0);
	SendClientMessage(playerid, COLOR_WHITE, !"Метка на карте установлена");
	CP[playerid] = 0;
	return 1;
}
CMD:home(playerid, params[])
{
    if (pInfo[playerid][pHouseID] != -1) {
        new 
			H_IDX = pInfo[playerid][pHouseID];
		SetPlayerCheckpoint(playerid, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2], 4.0);
		SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш дом обозначен на карте красной меткой");
		SetPVarInt(playerid, #CheckpointHome, 1);
	}
	else if (pInfo[playerid][pRentHouse] != -1) {
	    new house_ = pInfo[playerid][pRentHouse];
		SetPlayerCheckpoint(playerid,HouseInfo[house_][hEnter][0], HouseInfo[house_][hEnter][1], HouseInfo[house_][hEnter][2], 4.0);
		SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш дом обозначен на карте красной меткой");
		SetPVarInt(playerid, #CheckpointHome, 1);
	}
	else SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома/прописки");
	return 1;
}
CMD:clear(playerid, params[])
{
	new string_[128];
	if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
    if ((pInfo[playerid][pMember] == 1 && pInfo[playerid][pRank] >= 10) || (pInfo[playerid][pMember] == 10 &&  pInfo[playerid][pRank] >= 10) || (pInfo[playerid][pMember] == 21 &&  pInfo[playerid][pRank] >= 2) || (pInfo[playerid][pMember] == 2 &&  pInfo[playerid][pRank] >= 2))
    {
		new V_IDX = GetPlayerVehicleID(playerid);
		if (V_IDX > 0 && VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
			(VehicleInfo[ V_IDX - 1 ][vFraction] == 1 || VehicleInfo[ V_IDX - 1 ][vFraction] == 2 || VehicleInfo[ V_IDX - 1 ][vFraction] == 10 || VehicleInfo[ V_IDX - 1 ][vFraction] == 21 ))
		{
			if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /clear [id]");
			if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
			if (pInfo[params[0]][pWantedLevel] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Человек не находиться в розыске!");
			format(string_, sizeof(string_), "Вы сняли уровни розыска у %s.", pInfo[params[0]][pName]);
			SendClientMessage(playerid, 0x6495EDFF, string_);
			format(string_, sizeof(string_), "%s %s снял с Вас уровни розыска.", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName]);
			SendClientMessage(params[0], 0x6495EDFF, string_);
			pInfo[params[0]][pWantedLevel] = 0;
			SetPlayerWantedLevelEx(params[0], pInfo[params[0]][pWantedLevel]);
			format(string_, sizeof(string_), "[Clear] %s удалил из розыскиваемых %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
			SendPoliceMessage(0xFEBC41AA,string_);
		}
		else return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в полицейской машине");
    }
	return 1;
}
#if !defined _poffer_inc
CMD:ticket(playerid, params[])
{
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
	if (strlen(params[2]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "uds[32]",params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ticket [id] [цена] [причина]");
	if (params[1] < 1 || params[1] > 10000) return SendClientMessage(playerid, COLOR_GREY, !"Штраф не должен привышать 10000 и не должен быть меньше $0!");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return 1;
	if (kLibGetPlayerMoney(params[0]) < params[1]) return SendClientMessage(playerid, COLOR_GRAD1, !"У этого человека нет столько денег!");
	if (Select[params[0]][SelectCharTicket] == 255) return SendClientMessage(playerid, COLOR_GREY, !"Человеку уже кто то уже выписывает штраф!");
	SendMes(playerid, 0x6495EDFF, "Вы выписали штраф в размере $%d %s. Причина: %s",params[1],pInfo[params[0]][pName],params[2]);
	SendMes(params[0], 0x6495EDFF, "Офицер %s выписал вам штраф в размере $%d. Причина: %s",pInfo[playerid][pName],params[1],params[2]);
	scm(params[0], 0x6495EDFF, !"(( Нажмите: {33AA33}Y {6495ED}- чтобы оплатить штраф или "colred"N {6495ED}- отказаться ))");
	Select[params[0]][SelectCharTicket] = 255;
	SetPVarInt(params[0], "SellerTicketID", playerid);
	SetPVarInt(params[0], "SellerTicketCost",params[1]);
	return 1;
}
#endif


CMD:arrest(playerid, params[])
{
	if (pTemp[playerid][tDutyWork] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть в форме!");
	if (!IsACop(playerid)) return SendClientMessage(playerid, CGRAY2, !"Функция доступна только для \"Police/FBI\"");

	if (
		IsPlayerInRangeOfPoint(playerid,16.0, 2747.6575, 1398.9071, 1100.904)		|| // lspd
		IsPlayerInRangeOfPoint(playerid,16.0, 227.7436,114.5075,999.0156) 			|| // sfpd
		IsPlayerInRangeOfPoint(playerid,16.0, 198.1339,158.4835,1003.0234)			 // lvpd
	)
	{
		if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /arrest [playerid] [время]");
		if (params[1] < 6 || params[1] > 36) return SendClientMessage(playerid, COLOR_GREY, !"От 6 минуты до 36");
		new	
			string_[128]; 
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
		if (!IsPlayerInRangeOfPlayer(6.0, playerid, params[0])) return 1;
		if (pInfo[params[0]][pWantedLevel] < 1) return  SendClientMessage(playerid, COLOR_GREY, !"Человек должен иметь хотя бы один уровень розыска!");
		format(string_, sizeof string_, "Вы арестовали %s",pInfo[params[0]][pName]);
		SendClientMessage(playerid, COLOR_BLUE, string_);
		pInfo[playerid][pPayCheck]+= 200*pInfo[params[0]][pWantedLevel];
		ResetPlayerWeapons(params[0]); 
		if (pTemp[params[0]][tPlayerCuffed] && gFollowInfo[playerid][gtID] == params[0]) {
			TogglePlayerControllable(params[0], 1);
			CheckPlayerGoCuff(params[0]);
			CheckPlayerGoCuff(params[0]);
			//return 1;
		}
		switch(pInfo[playerid][pMember])
		{
			case FRACTION_LSPD, FRACTION_SFPD, FRACTION_LVPD: format(string_, sizeof string_, "<< Офицер %s арестовал %s >>",pInfo[playerid][pName], pInfo[params[0]][pName]);
			case FRACTION_FBI: format(string_, sizeof string_, "<< Агент FBI %s арестовал %s >>",pInfo[playerid][pName], pInfo[params[0]][pName]);
		}
		OnPlayerAchievProgress(playerid, 16);
		SendPoliceMessage(0xFEBC41AA, string_); 
		if (IsPlayerInRangeOfPoint(playerid, 16.0, 2747.6575, 1398.9071, 1100.904)) //lspd
		{ 
			pInfo[params[0]][pMestoJail] = 1;
			SetPlayerPosAC(params[0], 2742.6187, 1396.9856, 1100.9045, 1, 6);
		}
		else if (IsPlayerInRangeOfPoint(playerid,16.0, 218.2263,114.9286,999.0156)) //sfpd
		{
			pInfo[params[0]][pMestoJail] = 2;
			SetPlayerPosAC(params[0], 219.5400,109.9767,999.0156, 0, 10);
		}
		else
		{
			pInfo[params[0]][pMestoJail] = 3;
			SetPlayerPosAC(params[0],198.3642,161.8103,1003.0300, 122, 3);
		}
		SetPlayerFacingAngle(params[0], 1.0000);
		pInfo[ params[0] ][pJailTime] = params[1] * 60;
		format(string_, sizeof string_, "Вы были арестованы на %d секунд", pInfo[ params[0] ][pJailTime]);
		SendClientMessage(playerid, COLOR_LIGHTRED, string_);
		pInfo[ params[0] ][pArrested] += 1; 
		pInfo[ params[0] ][pWantedLevel] = 0;
		if (pInfo[ params[0] ][pWantedLevel] == 6) {
			OnPlayerQuestProgress(playerid, QUEST_PD, QUEST_TASK_PD_PATRUL);
		}
		SetPlayerWantedLevelEx(params[0], pInfo[params[0]][pWantedLevel]);
		TogglePlayerControllable(params[0], 1);
		SetPlayerSpecialAction(params[0],SPECIAL_ACTION_NONE);
		RemovePlayerAttachedObject(params[0],0);
		pTemp[params[0]][tPlayerCuffed] = 0; 
		PlayerCuffedTime[params[0]] = 0; 
	}
	else SendClientMessage(playerid, CGRAY2, !"Вы должны находится возле изолятора \"police department\"");
	return 1;
}

CMD:frisk(playerid, params[])
{ 
	if (!IsACop(playerid) || !pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /frisk [id]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(3.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не рядом с Вами"); 
	new string[128];
	format(string, sizeof(string), "Вещи %s", pInfo[params[0]][pName]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), " %s.",(pInfo[params[0]][pDrugs])?("| Наркотики.") : ("| Пустой карман."));
	SendClientMessage(playerid, COLOR_GREY, string);
	format(string, sizeof(string), " %s.",(pInfo[params[0]][pMats])?("| Материалы.") : ("| Пустой карман."));
	SendClientMessage(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "%s обыскал %s", pInfo[playerid][pName] ,pInfo[params[0]][pName]);
	SetPlayerSpecialAction(params[0], SPECIAL_ACTION_HANDSUP);
	SendBeside(playerid,COLOR_PURPLE, string,30.0);
	return 1;
}
CMD:wanted(playerid, params[])
{
    new string[128];
    if (!IsACop(playerid) || !pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
    t_string[0] = EOS;
    foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue;
	    if (!pInfo[i][pWantedLevel]) continue;
		format(string, sizeof string, "%s\t|\tУровень розыска: %d\n",pInfo[i][pName], pInfo[i][pWantedLevel]);
		strcat(t_string, string);
	}
	if (strlen(t_string) > 1) ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Розыскиваются", t_string, "Закрыть", "");
	else SendClientMessage(playerid, -1, !"Нет розыскиваемых");
	return 1;
}
CMD:mdc(playerid, params[])
{
	if (!pInfo[playerid][pLogin] ||pTemp[playerid][tDutyWork] == 0) return 1;
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
	if (GetPlayerState(playerid) != 2) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в автомобиле.");
	new V_IDX = GetPlayerVehicleID(playerid);
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
		(VehicleInfo[ V_IDX - 1 ][vFraction] == 1 || VehicleInfo[ V_IDX - 1 ][vFraction] == 2 || VehicleInfo[ V_IDX - 1 ][vFraction] == 10 || VehicleInfo[ V_IDX - 1 ][vFraction] == 21 ))
	{
		return ShowPlayerDialog(playerid, D_MDC_PD_0, DIALOG_STYLE_LIST, "Бортовой компьютер", "[0] Список розыскиваемых\n[1] База данных на жителей штата\n"colserver"- Статистика преступности", "Выбрать", "Закрыть");
    }
	else return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в полицейской машине");
}
CMD:unsearch(playerid, params[])
{
	if (ShowBoxSearchWanted[playerid] == INVALID_GANGZONE_ID) return 1;
	GangZoneHideForAll(ShowBoxSearchWanted[playerid]);
	GangZoneDestroy(ShowBoxSearchWanted[playerid]);
	return SendClientMessage(playerid, 0x6495EDFF, !"Вы завершили поиски преступника");
}
CMD:megaphone(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
	new string_[145];
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/m)egaphone [текст]");
	new V_IDX = GetPlayerVehicleID(playerid);
	switch(pInfo[playerid][pMember])
	{
		case FRACTION_LSPD, FRACTION_SFPD, FRACTION_LVPD:
		{
			if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
				(VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_LSPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_SFPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_LVPD))
			{
				format(string_, sizeof string_, "{{ Офицер %s: %s }}", pInfo[playerid][pName], params[0]);
				SendBeside(playerid, COLOR_YELLOW, string_, 80.0);
			}
			else return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в полицейской машине");
		}
		case FRACTION_ARMY_SF, FRACTION_ARMY_LV:
		{
            if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_ARMY_SF || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_ARMY_LV ))
			{
				format(string_, sizeof string_ , "{{ Солдат %s: %s }}",pInfo[playerid][pName], params[0]);
				SendBeside(playerid, COLOR_YELLOW, string_, 80.0);
			}
			else return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в солдатской машине");
		}
		case FRACTION_FBI:
		{
		    if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_FBI))
			{
				format(string_, sizeof string_ , "{{ Агент FBI %s: %s }}", pInfo[playerid][pName], params[0]);
				SendBeside(playerid, COLOR_YELLOW, string_, 80.0);
			}
			else return  SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине ФБР");
		}
	}
	return 1;
}
alias:megaphone("m");
CMD:gps(playerid)
{
    if (GetPVarInt(playerid,"farm_status") == 1) 
        return SendClientMessage(playerid, COLOR_GREY, !"В данный момент нельзя использовать GPS(Выполните заказ)!"); 
	if (CP[playerid] == 777) {
		DisablePlayerCheckpoint(playerid);
		CP[playerid] = 0;
	}
	ShowPlayerGPSList(playerid); 
	return 1;
} 
ShowPlayerGPSList(playerid) {
	t_string[0] = EOS;
	format(t_string, sizeof t_string, "\
		[0] Важные места\n\
		[1] Работы\n\
		[2] Бизнесы\n\
		[3] Автосалоны и СТО\n\
		[4] Государственные организации\n\
		[5] Дальнобойщики\n\
		[6] Нелегальные места\n\
		[7] Развлечения\n\
		[8] Фермы\n\
		"colserver"- Найти ближайшую заправку\n\
		"colserver"- Найти ближайшую закусочную\n\
		"colserver"- Найти ближайший банкомат\n\
		"colserver"- Найти личный транспорт");
		 
	new
		street_name[64];
 	format(street_name, sizeof street_name, "{2641FE}[GPS] "colwhi"| "colserver"Вы в районе: %s", GetPlayerZone(playerid, 0));
    return ShowPlayerDialog(playerid, D_GPS_FUNC_0, DIALOG_STYLE_LIST, street_name, t_string, "Выбрать", "Отмена");
}   
CMD:gnews(playerid, params[]) {
	new 
		count_player_row = GetPVarInt(playerid,"count_row"),
		max_rows = GetPVarInt(playerid, "max_rows"),
		get_goverment_text[100],
		set_pvar_string[15],
		fraction_ = pInfo[playerid][pMember];
	if (!IsACop(playerid) && !IsAArmy(playerid) && !IsAMayor(playerid) && !IsAMedic(playerid) && pInfo[playerid][pMember] != FRACTION_AUTOSCHOOL && pInfo[playerid][pMember] != FRACTION_CITYHALL) return 1;
	else if (pInfo[playerid][pRank] < fInfo[fraction_][fHelper][0]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда");
	else if (!pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Вам необходимо начать рабочий день");
	else if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);

	if (!IsPlayerGetSettings(playerid, setGovChat)) return SendClientMessage(playerid, COLOR_GREY, !"Включите новостную волну в настройках (/mm - Настройки)");  
	if (GetSVarInt("gnews_timer") > gettime()) { 
		timestamp_to_date(GetSVarInt("gnews_timer") - gettime(), year, month, day, hour, minute, second);
		new string[128];
		format(string, sizeof string, "До подачи гос.новостей осталось: "colwhi"%02d:%02d", minute, second);
		SendClientMessage(playerid, COLOR_GREY, string);
		return 1;
	}
	new string[262];
	if (!max_rows) {
		if (sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gnews [кол-во строк]");
		if (params[0] < 1 || params[0] > 4) return SendClientMessage(playerid, COLOR_GREY, !"от 1 до 4 строк");
		SetPVarInt(playerid,"max_rows", params[0] + 1);
		SetPVarInt(playerid, "count_row", 1);
		format(string, sizeof string, "Вы выбрали для гос. новостей строк: %d "collime"| Используйте: /gnews [строка 1]", params[0]);
		SendClientMessage(playerid, 0x489191C8, string);
	}
	else {
		if (max_rows == count_player_row) {
			if (!isnull(params)) {
				DeletePVar(playerid,"max_rows");
				DeletePVar(playerid,"count_row");
				SendClientMessage(playerid, COLOR_WHITE, !"Гос.Новости успешно сброшены");
				return 1;
			}
			SendGovermentMessage(0x2641EDFF, !"================== {C0C0C0}[ Государственные новости ]{2641ED} ==================");
			
			for(new i = 1; i < max_rows; i++) { 
				format(set_pvar_string, 15, "gnews%d", i);
				GetPVarString(playerid, set_pvar_string, get_goverment_text, 100);
				format(string, sizeof(string), "{%s} %s [%s]: "colwhi"%s", gFraction[fraction_][fRGBColor], pInfo[playerid][pName], gFraction[fraction_][fTagName], get_goverment_text);
				SendGovermentMessage(gFraction[fraction_][fColor], string);
			}
			SendGovermentMessage(0x2641EDFF, !"============================================================="); 
			format(string, sizeof(string), "[A] %s %s[%d] - Использовал /gnews", gFraction[fraction_][fName], pInfo[playerid][pName], playerid);
			SendAdminMessage(COLOR_GREY, string);
			SetSVarInt("gnews_timer", gettime() + 60*3);
			DeletePVar(playerid,"max_rows");
			DeletePVar(playerid,"count_row");
			return 1;
		}
		format(string, 64, "/gnews [строка %d]",count_player_row);
		if (isnull(params)) return SendClientMessage(playerid, COLOR_GREY, string);
		format(set_pvar_string, 15, "gnews%d", count_player_row);
		SetPVarString(playerid, set_pvar_string, params);
		format(string, sizeof(string), "[A] [GNEWS BIND] %s[%d] - %s", pInfo[playerid][pName], playerid, params);
		SendAdminMessage(COLOR_SERVER, string);
		if (count_player_row + 1 == max_rows) {
			format(string, sizeof(string), "Строка %d : %s", count_player_row, params);
			SendClientMessage(playerid,0xD6D6D6C8, string);
			SendClientMessage(playerid, COLOR_WHITE, !"Используйте команду /gnews еще раз. Чтобы опубликовать новости");
			SendClientMessage(playerid, COLOR_WHITE, !"В случае опечатки, используйте: /gnews 0");
		}
		else {
			format(string, sizeof(string), "Строка %d : %s "collime"| Используйте: /gnews [строка %d]", count_player_row, params, count_player_row + 1);
			SendClientMessage(playerid, 0xD6D6D6C8, string);
		}
		SetPVarInt(playerid,"count_row", count_player_row + 1);
		if(!Reklama(playerid, params[0])) return 1;
	}
	return 1;
}
alias:gnews("gov");

CMD:fstyle(playerid, params[])
{
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /fstyle [0-3]");
	if (params[0] < 0 || params[0] > 3) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /fstyle [0-3]");
	if (params[0] == 0)
	{
		SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
		SendClientMessage(playerid, COLOR_WHITE, !"Обычный стиль");
	}
	else if (params[0] == 1)
	{
		if (pInfo[playerid][pBoxSkill] >= 5000) SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING), SendClientMessage(playerid, COLOR_LIGHTGREEN, !"Вы установили новый стиль боя");
		else return SendClientMessage(playerid, COLOR_GREY, !"Вы не изучали этот стиль боя");
	}
	else if (params[0] == 2)
	{
		if (pInfo[playerid][pKongfuSkill] >= 5000) SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU), SendClientMessage(playerid, COLOR_LIGHTGREEN, !"Вы установили новый стиль боя");
		else return SendClientMessage(playerid, COLOR_GREY, !"Вы не изучали этот стиль боя");
	}
	else if (params[0] == 3)
	{
		if (pInfo[playerid][pKickboxSkill] >= 5000) SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD), SendClientMessage(playerid, COLOR_LIGHTGREEN, !"Вы установили новый стиль боя");
		else return SendClientMessage(playerid, COLOR_GREY, !"Вы не изучали этот стиль боя");
	}
	return 1;
}
CMD:donate(playerid)
{
	return UpdatePlayerDonate(playerid);
} 
CMD:strobe(playerid, params[])
{
    if (pInfo[playerid][VIPRank] >= VIP_PACK_SILVER || pInfo[playerid][pAdmin] >= 1 || IsACop(playerid))
	{
		if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в машине!");
		if (sscanf(params,"d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /strobe [1,2,3,4,5,6 | 0 - Выключить.]");
		new	
			V_IDX = GetPlayerVehicleID(playerid);
		if (params[0] == 0) {
			if (VehicleBlinkStatus[V_IDX] == true) {
				StopVehicleBling(V_IDX);
			}
			return 1;
		}
		if (params[0] < 1 || params[0] > 6) return SendClientMessage(playerid, COLOR_GREY, !"Скороть мигания от 1 до 6 | 0 - Выключить");
	  	if (VehicleBlinkStatus[V_IDX]) return SendClientMessage(playerid, COLOR_GREY, !"У этой машины уже мигают фары!");
	  	SetVehicleBling(V_IDX, params[0]*50);
	}
    else return SendClientMessage(playerid, COLOR_GREY, !"Вы не админ / VIP игрок! / Сотрудник PD");
  	return 1;
}


CMD:en(playerid)
{
    if (pInfo[playerid][pLogin] == 0) return 1; 
	new V_IDX = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;
	if (VehicleInfo[ V_IDX - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт нельзя заводить, пока его загружают!");
	if (IsASellCar(V_IDX)) return SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт нельзя заводить, пока он на продаже!");
	if (GetVehicleState(V_IDX) < VEHICLE_STATE_BOAT || pTemp[playerid][PlayerVehicle] != V_IDX) return 1;
	toggle_engine1(playerid, V_IDX);
	return 1 ;
}
CMD:light(playerid)
{
	new V_IDX = GetPlayerVehicleID ( playerid ) ;
	if (v_velo(V_IDX) || IsAPlane(V_IDX) || IsABoat(V_IDX)) return 1;
	ToggleLights(V_IDX);
	return 1;
}


CMD:hi(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать в машине");
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /hi [ид]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(2.0, playerid, params[0]) || IsPlayerInAnyVehicle(params[0])) return 1;
	new Float:angle,string_[128];
	GetPlayerFacingAngle(playerid, angle);
	SetPlayerFacingAngle(params[0], angle + 180);
	format(string_, sizeof(string_), "%s пожал руку %s'у",pInfo[playerid][pName],pInfo[params[0]][pName]);
	SendBeside(playerid,COLOR_PURPLE,string_,10.0);
	ApplyAnimation(playerid, "GANGS", "hndshkfa",4.0,0,0,0,0,0,1);
	ApplyAnimation(params[0], "GANGS", "hndshkfa",4.0,0,0,0,0,0,1);
	return 1;
}
CMD:referals(playerid) {
	ShowPlayerReferals(playerid);
	return true;
}


CMD:me(playerid, params[])//ANTIFLOOD
{
    if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /me [действие]");
	new mes[128];
    if (strlen(params[0]) > 90)
	{
		new text2[128];
		strmid(text2, params[0], 0, strlen(params[0]), 128);
		strdel(params[0], 90, 128);
		strdel(text2, 0, 90);
		format(mes, sizeof(mes), "%s %s", pInfo[playerid][pName], params[0]);
		SetPlayerChatBubble(playerid, params[0], COLOR_PURPLE, 20.0, 5000);
		SendBeside(playerid,COLOR_PURPLE, mes,30.0);
		format(mes, sizeof(mes), "...%s (%s)", text2,  pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, mes,30.0);
		return 1;
	}

	format(mes, sizeof(mes), "%s %s", pInfo[playerid][pName], params[0]);
	SendBeside(playerid,COLOR_PURPLE, mes, 30.0);

	SetPlayerChatBubble(playerid, params[0], COLOR_PURPLE, 30.0, 10000);
	pTemp[playerid][AntiFloodText] = gettime()+2;
	return 1;
}
CMD:ame(playerid, params[])
{
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ame [действие]");
	SetPlayerChatBubble(playerid, params[0], COLOR_PURPLE, 30.0, 10000);
	new mes[144];
	format(mes, sizeof(mes), "%s %s", pInfo[playerid][pName], params[0]);
	SendClientMessage(playerid, COLOR_PURPLE, mes);
	return 1;
}
CMD:do(playerid, params[])//ANTIFLOOD
{
    if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /do [действие]");
	new mes[128];
    if (strlen(params[0]) > 90)
	{
		new text2[128];
		strmid(text2, params[0], 0, strlen(params[0]), 128);
		strdel(params[0], 90, 128);
		strdel(text2, 0, 90);
		format(mes, sizeof(mes), "(( %s[%d] )) "colserver"%s", pInfo[playerid][pName],playerid, params[0]);
		SetPlayerChatBubble(playerid, params[0], COLOR_WHITE, 20.0, 5000);
		SendBeside(playerid, COLOR_WHITE, mes,30.0);
		format(mes, sizeof(mes), ""colserver"...%s (%s)", text2,  pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_WHITE, mes,30.0);
		return 1;
	}
	format(mes, sizeof mes, "(( %s[%d] )) "colserver"%s", pInfo[playerid][pName], playerid, params[0]);
	SendBeside(playerid,COLOR_WHITE, mes, 30.0);
	SetPlayerChatBubble(playerid, params[0], COLOR_WHITE,30.0,10000);
	pTemp[playerid][AntiFloodText] = gettime()+2;
	return 1;
}
CMD:try(playerid, params[])//ANTIFLOOD
{
    if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /try [действие]");
	new randomchik = RandomFIX(0,2), string_[200];
	format(string_, sizeof string_, "%s %s %s",pInfo[playerid][pName],params[0],(!randomchik)?("{63C600} [Удачно]") : ("{BF0000} [Неудачно]"));
	SendBeside(playerid,COLOR_PURPLE, string_, 30.0);
	SetPlayerChatBubble(playerid,params[0],COLOR_PURPLE,30.0,10000);
	pTemp[playerid][AntiFloodText] = gettime()+2;
	return 1;
}

CMD:todo(playerid,params[])
{
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	new str_todo[144];
	strcat(str_todo,params);
	new data_of_token = strfind(str_todo, "*");
	if (isnull(str_todo) || data_of_token == -1) return SendClientMessage(playerid, COLOR_WHITE,!"Введите: /todo [текст] * [действите]");
	new data_temp_string[18+MAX_PLAYER_NAME];
	format(data_temp_string, sizeof(data_temp_string), "{DD90FF}- сказал(а) %s,", pInfo[playerid][pName]);
	strdel(str_todo,data_of_token,data_of_token+1);
	strins(str_todo,data_temp_string,data_of_token,strlen(data_temp_string));
	ProxDetector(playerid, 30.0, 0xFFFFFFFF, str_todo);
	return 1;
}


CMD:shout(playerid, params[])//ANTIFLOOD
{
    if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	new string_[164];
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (strlen(params[0]) >= 100) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[100]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /s [текст]");
	format(string_, sizeof string_, "%s кричит: %s!!", pInfo[playerid][pName], params[0]);
	SendBeside(playerid,COLOR_WHITE, string_ ,60.0);
	pTemp[playerid][AntiFloodText] = gettime()+2;
	if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		ApplyAnimation(playerid, "RIOT", "RIOT_shout", 2000.0, 0, 1, 1, 1, 1, 1);
		SetTimerEx("ClearAnim", 800, false, "d", playerid);
	}
	SetPlayerChatBubble(playerid,params[0],COLOR_YELLOW,60.0,10000);
	return 1;
}
alias:shout("s");
CMD:fb(playerid, params[])
{
	if (!IsAMafia(playerid) && !IsAGang(playerid) && !IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не член какой-либо фракции!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
    if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, "Не флуди!");
    if (!IsPlayerGetSettings(playerid, setFractionChat)) return SendClientMessage(playerid, COLOR_GREY, !"Включите чат организации в настройках (/mm - Настройки)");  
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /fb [текст]");

	pTemp[playerid][AntiFloodText] = gettime()+2;
	new string_[200];
	if (pInfo[playerid][FractionMute] > 0) {
	    format(string_, sizeof string_, "У Вас бан чата организации! До снятия: %d секунд(ы)", pInfo[playerid][FractionMute]);
	    scm(playerid, COLOR_YELLOW, string_);
		return 1;
	} 
	format(string_, sizeof string_, "(( [F] %s %s: %s ))", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
	SendFamilyMessage(pInfo[playerid][pMember], TEAM_AZTECAS_COLOR, string_);
	if (tipsteron == pInfo[playerid][pMember])
	{
		foreach(new i: PlayerInLogin)
		{
			if (!pInfo[i][pLogin]) continue;
			if (tipsterlisten[i])
			{
				SendClientMessage(i, COLOR_LIGHTRED, string_);
			}
		}
	}
	return 1;
}
CMD:family(playerid, params[])
{
    if (!pInfo[playerid][pLogin]) return true; 
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid); 
    if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!"); 
    if (!IsPlayerGetSettings(playerid, setFractionChat)) return SendClientMessage(playerid, COLOR_GREY, !"Включите чат организации в настройках (/mm - Настройки)");  

	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/f)amily [текст]");
	if(!Reklama(playerid, params[0])) return 1;
	pTemp[playerid][AntiFloodText] = gettime()+2;
	new string_[160];
	if (GetPlayerTaxi{playerid} == 1)
	{
		format(string_, sizeof(string_), "[T.LVL %d]: "colwhi"%s %s",pInfo[playerid][pTaxiLevel], pInfo[playerid][pName], params[0]);
		foreach(new i: JobTaxi)
		{
			SendClientMessage(i, 0xAA5C40FF, string_);
		}
		return 1;
	}
	if (pInfo[playerid][pJob] == 7)
	{
		format(string_, sizeof(string_), "%s [T.LVL %d]: "colwhi"%s",pInfo[playerid][pName], pInfo[playerid][pDLevel], params[0]);
		SendJobMessage(7, 0x4d6783FF, string_);
		return 1;
	}//pTemp[select_id][JobInFarmRank]
	if (pTemp[playerid][JobInFarmRank] > 2)
	{
	    new FARM_ID = pTemp[playerid][TempFermID];
	    switch(pTemp[playerid][JobInFarmRank])
	    {
	        case 2: format(string_, sizeof(string_), "[FARM %d] Фермер %s: %s",FARM_ID-1, pInfo[playerid][pName], params[0]);
	        case 3: format(string_, sizeof(string_), "[FARM %d] Заместитель %s: %s",FARM_ID-1, pInfo[playerid][pName], params[0]);
	        case 4: format(string_, sizeof(string_), "[FARM %d] Владелец %s: %s",FARM_ID-1, pInfo[playerid][pName], params[0]);
		}
		foreach(new i: PlayerInLogin)
 		{
			if (!pInfo[i][pLogin]) continue;
			if (pTemp[i][JobInFarmRank] < 2)continue;
			if (pTemp[i][TempFermID] == FARM_ID)
			{
				SendClientMessage(i,TEAM_AZTECAS_COLOR,string_);
			}
		}
		return 1;
	}
	if (GetPVarInt(playerid,"CasinoRank"))
	{
	    for(new i = 1; i <= TOTALCASINO; i++)
		{
			if (!IsPlayerInRangeOfPoint(playerid, 300, CasinoInfo[i][caPos][0], CasinoInfo[i][caPos][1], CasinoInfo[i][caPos][2])) continue;
			switch(GetPVarInt(playerid,"CasinoRank"))
			{
			    case 1: format(string_, sizeof(string_), "[CASINO] Крупье %s: %s", pInfo[playerid][pName], params[0]);
			    default: format(string_, sizeof(string_), "[CASINO] Менеджер %s: %s", pInfo[playerid][pName], params[0]);
			}
		}
		for(new i = 1; i <= TOTALCASINO; i++)
		{
			foreach(new idx: PlayerInLogin)
			{
				if (!IsPlayerInRangeOfPoint(idx, 300,CasinoInfo[i][caPos][0],CasinoInfo[i][caPos][1], CasinoInfo[i][caPos][2]) || !GetPVarInt(idx,"CasinoRank")) continue;
				if (GetCasino(idx, i) && GetCasino(playerid, idx) && GetPVarInt(idx,"CasinoRank")) 
				{
					SendClientMessage(idx,TEAM_AZTECAS_COLOR,string_);
				}
			}
		}
		return 1;
	}
	if (pInfo[playerid][FractionMute] > 0) {
	    format(string_, sizeof string_, "У Вас бан чата организации! До снятия: %d секунд(ы)", pInfo[playerid][FractionMute]);
	    SendClientMessage(playerid, COLOR_YELLOW, string_);
		return 1;
	}
	if (!IsAMafia(playerid) && !IsAGang(playerid) && !IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не член какой-либо фракции!");
	if (!pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Начните рабочий день!");  

	format(string_, sizeof(string_), "[F] %s %s: %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
	SendFamilyMessage(pInfo[playerid][pMember], TEAM_AZTECAS_COLOR, string_);
	if (tipsteron == pInfo[playerid][pMember])
	{
		foreach(new i: PlayerInLogin)
		{
			if (!pInfo[i][pLogin]) continue;
			if (tipsterlisten[i])
			{
				SendClientMessage(i, COLOR_LIGHTRED, string_);
			}
		}
	}
	return 1;
}
alias:family("f");
//Старая кмд

/*CMD:fmute(playerid, params[])
{
    if (pInfo[playerid][pLeader] > 0 || pInfo[playerid][pMember] > 0)
	{
		new 
			string_[145];
	    if (pInfo[playerid][pRank] < fInfo[pInfo[playerid][pMember]][fHelper][5])
		{ 
			format(string_, sizeof string_, "Данную команду можно использовать с %d ранга", fInfo[pInfo[playerid][pMember]][fHelper][5]);
			SendClientMessage(playerid, COLOR_GREY, string_);
			return 1;
		}
    	if (strlen(params[2]) >= 64) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
		if(sscanf(params, "uds[64]",params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /fmute [playerid] [минуты] [причина]");
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Вы указали свой ID");
		if (pInfo[playerid][pMember] != pInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не из вашей организации!");
		if (pInfo[playerid][pRank] < pInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на человека, который старше вас рангом!"); 
		if (IsAIP(params[2])) return 1;
		if (pInfo[params[0]][FractionMute] > 0)
		{
			pInfo[params[0]][FractionMute] = 0;
			format(string_, sizeof(string_), "%s %s снял бан чата организации у %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName],pInfo[params[0]][pName]);
			SendFamilyMessage(pInfo[playerid][pMember], COLOR_YELLOW, string_);
			SavePlayerInteger(params[0], "fmute", pInfo[params[0]][FractionMute]);
			return 1;
		}
		if (params[1] > 30 || params[1] < 0) return SendClientMessage(playerid, COLOR_GREY, !"Не менeе 0 и не более 30!");
		pInfo[params[0]][FractionMute] = params[1]*60;
		format(string_, sizeof(string_), "%s: %s выдал бан чата организации %s. Причина: %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1],pInfo[playerid][pName],pInfo[params[0]][pName], params[2]);
		SendFamilyMessage(pInfo[playerid][pMember], COLOR_YELLOW, string_);
		SendClientMessage(params[0], COLOR_YELLOW, !"Вам дали бан чата организации!");
		SavePlayerInteger(params[0], "fmute", pInfo[params[0]][FractionMute]);
	}
	return 1;
}*/

//новая кмд
CMD:fmute(playerid, params[])
{
    if(pInfo[playerid][pLeader] > 0 || pInfo[playerid][pMember] > 0)
	{
	    if(!IsAAssis(playerid)) return err(!"[Ошибка]: {ffffff}Вы не можете это использовать.");
    	new string_[145], query_[100];
    	if(strlen(params[0]) >= 64) return err(!"[Ошибка]: {ffffff}Вы указали слишком много символов!");
		if(sscanf(params, "uds[64]",params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /fmute [playerid] [минуты] [причина]");
		if(pInfo[playerid][pMember] != pInfo[params[0]][pMember]) return scm(playerid, COLOR_GREY, !"Игрок не из вашей организации!");
		if(!PlayerInConnected(params[0]) || playerid == params[0]) return err(!"[Ошибка]: {ffffff} Человек не найден! / Вы указали свой ID");
		if(!Reklama(playerid, params[2])) return 1;
		if(pInfo[params[0]][FractionMute] > 0)
		{
			pInfo[params[0]][FractionMute] = 0;
			format(string_, sizeof(string_), "%s %s снял бан чата организации у %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName],pInfo[params[0]][pName]);
			SendFamilyMessage(pInfo[playerid][pMember], COLOR_YELLOW, string_);
			format(query_, sizeof(query_), "UPDATE `s_users` SET `fmute` = '%d' WHERE `Name` = '%s'", pInfo[playerid][FractionMute], pInfo[playerid][pName]);
   			mysql_tquery(dbHandle, query_, "", "");
			return 1;
		}
		if(params[1] > 30 || params[1] < 0) return err(!"[Ошибка]: {ffffff}Не менeе 0 и не более 30!");
		pInfo[params[0]][FractionMute] = params[1]*60;
		format(string_, sizeof(string_), "%s: %s выдал бан чата организации %s. Причина: %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1],pInfo[playerid][pName],pInfo[params[0]][pName], params[2]);
		SendFamilyMessage(pInfo[playerid][pMember], COLOR_YELLOW, string_);
		SendClientMessage(params[0], COLOR_YELLOW, !"Вам дали бан чата организации!");
		format(query_, sizeof(query_), "UPDATE `s_users` SET `fmute` = '%d' WHERE `Name` = '%s'", pInfo[playerid][FractionMute], pInfo[playerid][pName]);
		mysql_tquery(dbHandle, query_, "", "");
	}
	return 1;
}
CMD:taxigps(playerid)
{
	if (pInfo[playerid][pJob] != PLAYER_JOB_TAXI && !SupportInfo[playerid][sDuty] && !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new null[7];
	t_string[0] = EOS;
	foreach(new i: PlayerInLogin)
    {
		if (!pInfo[i][pLogin]) continue;
		if (Prorab[i]) null[0]++;
		if (pTemp[i][tGruzJob]) null[1]++;
		if (pTemp[i][JobInFarmRank] < 2) continue;
		new FARM_ID = pTemp[i][TempFermID];
		if (FARM_ID == 1) null[2]++;
		if (FARM_ID == 2) null[3]++;
		if (FARM_ID == 3) null[4]++;
		if (FARM_ID == 4) null[5]++;
		if (FARM_ID == 5) null[6]++;
	}
	format(t_string, sizeof t_string,"{ffffff}[Грузчики] {33AA33} Прорабов %d Рабочих %d\n\
	                    {ffffff}[Ферма №0] {33AA33} Фермеров %d {FFFF00} Цена за куст %d$\n\
	                    {ffffff}[Ферма №1] {33AA33} Фермеров %d {FFFF00} Цена за куст %d$\n\
	                    {ffffff}[Ферма №2] {33AA33} Фермеров %d {FFFF00} Цена за куст %d$\n\
	                    {ffffff}[Ферма №3] {33AA33} Фермеров %d {FFFF00} Цена за куст %d$\n\
	                    {ffffff}[Ферма №4] {33AA33} Фермеров %d {FFFF00} Цена за куст %d$",
	null[0], null[1], null[2], FarmInfo[1][fZp], null[3], FarmInfo[2][fZp], null[4], FarmInfo[3][fZp], null[5], FarmInfo[4][fZp], null[6], FarmInfo[5][fZp]);
	return ShowPlayerDialog(playerid, D_JOB_STATS, DIALOG_STYLE_LIST, "Статистика", t_string, "GPS", "Закрыть");
}
CMD:prodmenu(playerid)
{
	if (pInfo[playerid][pJob] != 5) return scm(playerid, COLOR_GREY, !"Вам недоступна данная команда!");
	new V_IDX = GetPlayerVehicleID(playerid);
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || VehicleInfo[ V_IDX - 1 ][vFraction] != PLAYER_JOB_DELIVERY) {
		SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем рабочего транспората!");
		return true;
	}
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ V_IDX - 1 ] [vSubFraction] == DELIVERY_TYPE_0)) {
		if (pTemp[playerid][pRentCar] != V_IDX) return scm(playerid, COLOR_GREY, !"Это не ваш автомобиль!");
		return ShowPlayerDialog(playerid, D_JOB_FUNC_2, DIALOG_STYLE_LIST, "Развозка продуктов", "[0] Покупка зерна\n[1] Продажа зерна\n[2] Покупка урожая\n[3] Продажа урожая", "Выбрать", "Отмена");
	}
	else if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ V_IDX - 1 ] [vSubFraction] == DELIVERY_TYPE_1)) {
		// ShowPlayerDialog(playerid, D_JOB_FUNC_7, DIALOG_STYLE_LIST, "Развозка бензина", "[0] Купить\n[1] Продать\n[2] Мониторинг\n[3] Статистика\n[4] Выбросить продукты", "Выбрать", "Отмена");
		//pTemp[playerid][tCurrentBusinessID] = 0;
		ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_MENU);
		return 1;
	}
	else if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ V_IDX - 1 ] [vSubFraction] >= DELIVERY_TYPE_2)) {
		// ShowPlayerDialog(playerid, D_JOB_FUNC_7, DIALOG_STYLE_LIST, "Развозка продуктов", "[0] Купить\n[1] Продать\n[2] Мониторинг\n[3] Статистика\n[4] Выбросить продукты", "Выбрать", "Отмена");
		//pTemp[playerid][tCurrentBusinessID] = 0;
		ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_MENU);
		return 1;
	}
	return 1;
}

CMD:funload(playerid, params[])
{
    if (pTemp[playerid][JobInFarmRank] < 2) return SendClientMessage(playerid, COLOR_GREY, !"Вы не фермер!");
	
	new
		V_IDX = GetPlayerVehicleID(playerid),
		FARM_ID = pTemp[playerid][TempFermID];
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB_FARM
		&& (VehicleInfo[ V_IDX - 1 ][vFraction] == FARM_ID && VehicleInfo[ V_IDX - 1 ] [vSubFraction] == F_VEHILE_FARM_SEEDCAR))
	{
		if (IsPlayerInDynamicArea(playerid, FarmInfo[FARM_ID][fSphere]))
		{
		 	if (FarmInfo[FARM_ID][fProds] >= 10000) return SendClientMessage(playerid, COLOR_GREY, !"Склад полон!");
		    if (!Farmcar_prods[V_IDX]) return SendClientMessage(playerid, COLOR_GREY, !"В грузовике нет урожая");
		    FarmInfo[FARM_ID][fProds] += Farmcar_prods[V_IDX];
		    if (FarmInfo[FARM_ID][fProds] >= 10000)
			{
				FarmInfo[FARM_ID][fProds] = 10000;
			}
		    new string_[128], str_[16];
		    format(str_, sizeof str_, "~g~+$%d", Farmcar_prods[V_IDX]*3);
			GameTextForPlayer(playerid, str_, 5000, 1);
		    kLibGivePlayerMoney(playerid, Farmcar_prods[V_IDX]*3, "/funload");
		    Farmcar_prods[V_IDX] = 0;
		    SaveFermID(FARM_ID);
		    format(string_, sizeof string_, "В грузовике 0 / 1000 урожая. На складе %d / 10000", FarmInfo[FARM_ID][fProds]);
		    scm(playerid, COLOR_GREEN, string_);
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться возле фермы");
	}
    return 1;
}
CMD:sellfarm(playerid, params[])
{
    if (!GetPlayerFarm(playerid)) return SendClientMessage(playerid, COLOR_LOSE, !"Вы не владеете фермой!");
	if (pTemp[playerid][PlayerFarmID] == -1 ) return SendClientMessage(playerid, COLOR_LOSE, !"Вы не владеете фермой!");
	new FARM_ID = pTemp[playerid][PlayerFarmID];
	if (!IsPlayerInRangeOfPoint(playerid, 20.0, FarmInfo[FARM_ID][fMenu][0], FarmInfo[FARM_ID][fMenu][1], FarmInfo[FARM_ID][fMenu][2] )
		&& !IsPlayerInRangeOfPoint(playerid,20.0, FarmInfo[FARM_ID][fCloakroom][0], FarmInfo[FARM_ID][fCloakroom][1], FarmInfo[FARM_ID][fCloakroom][2] ) )
			return SendClientMessage(playerid, -1, !"Вы не возле фермы!");
	//if (FARM_ID == i) return SendClientMessage(playerid, COLOR_GREY, !"Для начала переоденьтесь!");
    if ( GetString( FarmInfo[FARM_ID][fOwner], pInfo[playerid][pName] ) )
	{
		pInfo[playerid][pBank] += FarmInfo[FARM_ID][fBank]+FarmInfo[FARM_ID][fLandTax];
		SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
		LogMoney(playerid, FarmInfo[FARM_ID][fBank]+FarmInfo[FARM_ID][fLandTax], "/sellfarm");
		new str_[64], string_[128];
		format(str_, sizeof str_,"~w~farm in sold~n~~g~$%d",FarmInfo[FARM_ID][fBank]+FarmInfo[FARM_ID][fLandTax]);
		GameTextForPlayer(playerid, str_, 5000, 3);
		strmid(FarmInfo[FARM_ID][fOwner],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fDeputy_1],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fDeputy_2],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fDeputy_3],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fFarmer_1],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fFarmer_2],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fFarmer_3],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fFarmer_4],"None",0,strlen("None"),MAX_PLAYER_NAME);
		strmid(FarmInfo[FARM_ID][fFarmer_5],"None",0,strlen("None"),MAX_PLAYER_NAME);
		SaveFermIDFarmers(FARM_ID);
		FarmInfo[FARM_ID][fAuction][0] = 0;
		FarmInfo[FARM_ID][fAuction][1] = 0;
		FarmInfo[FARM_ID][fAuction][2] = 0;
		FarmInfo[FARM_ID][fAuction][3] = 0;
		FarmInfo[FARM_ID][fLandTax] = 0;
		FarmInfo[FARM_ID][fBank] = 0;
		FarmInfo[FARM_ID][fProds] = 0;
		FarmInfo[FARM_ID][fZp] = 30;
		FarmInfo[FARM_ID][fGrain_Price] = 5;
		FarmInfo[FARM_ID][fGrain] = 0;
		FarmInfo[FARM_ID][fGrain_Sown] = 0;
		FarmInfo[FARM_ID][fProds_Selling] = 1;
		FarmInfo[FARM_ID][fProds_Price] = 21;
		SaveFermID(FARM_ID);
		pTemp[playerid][PlayerFarmID] = -1;


		format(string_,sizeof(string_), "Бизнес Ферма [%d] выставлен на аукцион!", FARM_ID-1 );
		return SendClientMessage(playerid,0x4B00B0AA, string_);
	}
	else return SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться возле фермы!");
}

CMD:fpanel(playerid, params[])
{
	if (pTemp[playerid][JobInFarmRank] == 0) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Для того чтобы открыть панель управления фермой вам требуется переодеться в одежду фермера");
	new FARM_ID = pTemp[playerid][TempFermID];
	if (FARM_ID < 1 || pTemp[playerid][JobInFarmRank] < 3) return SendClientMessage(playerid, COLOR_LOSE, !"Вы не владеете фермой!");
	if (!IsPlayerInRangeOfPoint(playerid, 20.0, FarmInfo[FARM_ID][fMenu][0], FarmInfo[FARM_ID][fMenu][1], FarmInfo[FARM_ID][fMenu][2] )
		&& !IsPlayerInRangeOfPoint(playerid,20.0, FarmInfo[FARM_ID][fCloakroom][0], FarmInfo[FARM_ID][fCloakroom][1], FarmInfo[FARM_ID][fCloakroom][2] ) )
			return SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться возле фермы!");
	ShowFarmPanel(playerid);
	return true;
}



CMD:finfo(playerid, params[])
{
	new FARM_ID = -1;
	for(new idx = 1; idx <= TOTALFARM; idx++)
	{
	   if ( IsPlayerInRangeOfPoint(playerid, 20.0,FarmInfo[idx][fMenu][0], FarmInfo[idx][fMenu][1], FarmInfo[idx][fMenu][2]))
	    
	    {
	        FARM_ID = idx;
	        break;
	    }
	}
    if (FARM_ID == -1) return SendClientMessage(playerid,-1,"Вы не возле фермы!");
	FarmStats(playerid, FARM_ID);

	return 1;
}
CMD:farmfixcar(playerid, params[])
{
    if (pTemp[playerid][JobInFarmRank] < 3) return 1;
    new
		FARM_ID = pTemp[playerid][TempFermID];
    
    for(new idx = 1 ; idx < MAX_VEHICLES; idx ++)
	{
	    if (VehicleInfo[ idx - 1 ][vType] == VEHICLE_TYPE_JOB_FARM && VehicleInfo[ idx - 1 ][vFraction] == FARM_ID)
	    {
	        if (IsVehicleOccupied(idx) != -1) continue;
	        if (GetVehicleModel(idx) == 450) continue;
	        if (GetVehicleModel(idx) == 478)
	        {
				if (VehicleInfo[ idx - 1 ][vFarmText] != Text3D:-1) {
					DestroyDynamic3DTextLabel(VehicleInfo[ idx - 1 ][vFarmText]);
					VehicleInfo[ idx - 1 ][vFarmText] = Text3D:-1;
				}
				VehicleInfo[ idx - 1 ][vJobLoad] = false;
	            if (Farmcar_pickup[idx] > 0)
				{ 
					DestroyDynamicPickup(Farmcar_pickup[idx]);
					Farmcar_pickup[idx] = 0; 
				}
	        }
	        SetVehicleToRespawn(idx);
	    }
	}
	return 1;
}

CMD:gmap(playerid, params[])
{
	//if (!pInfo[playerid][pLogin] || !IsAGang(playerid)) return 1;
	/*new null = 0, string_[128];
    for(new i =1;i<= TOTALGZ;i++)
	{
		if (pInfo[playerid][pMember] == GZInfo[i][gFrakVlad]) null++;
	}*/
	new
		c_gzGang[5], string_[128]; 
	for(new i = 1; i <= TOTALGZ; i++){
		if (GZInfo[i][gFrakVlad] == 12)
			c_gzGang[0]++;
		else if (GZInfo[i][gFrakVlad] == 13)
			c_gzGang[1]++;
		else if (GZInfo[i][gFrakVlad] == 15)
			c_gzGang[2]++;
		else if (GZInfo[i][gFrakVlad] == 17)
			c_gzGang[3]++;
		else if (GZInfo[i][gFrakVlad] == 18)
			c_gzGang[4]++; 
	}
    format(string_, sizeof(string_), "Территорий под контролем The Ballas Gang: %d", c_gzGang[0]);
    SendClientMessage(playerid, 0x6BB3FFAA,string_);
	format(string_, sizeof(string_), "Территорий под контролем The Vagos Gang: %d", c_gzGang[1]);
    SendClientMessage(playerid, 0x6BB3FFAA,string_);
	format(string_, sizeof(string_), "Территорий под контролем The Grove Gang: %d", c_gzGang[2]);
    SendClientMessage(playerid, 0x6BB3FFAA,string_);
	format(string_, sizeof(string_), "Территорий под контролем The Aztec Gang: %d", c_gzGang[3]);
    SendClientMessage(playerid, 0x6BB3FFAA,string_);
	format(string_, sizeof(string_), "Территорий под контролем The Rifa Gang: %d", c_gzGang[4]);
    SendClientMessage(playerid, 0x6BB3FFAA,string_); 
	return 1;
}
CMD:limit(playerid, params[]) {
	if (!pInfo[playerid][pLogin] || IsANoLimiter(GetPlayerVehicleID(playerid))) return 1;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return  SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть за рулем");
	if(pTemp[playerid][pSLimit]) {
		pTemp[playerid][pSLimit] = 0;
		SendClientMessage(playerid, COLOR_ORANGE, !"Ограничение скорости снято");
		return 1;
	}
	if(sscanf(params,"d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /limit [скорость]");
	if(params[0] < 20 || params[0] > 120) return SendClientMessage(playerid, COLOR_GREY, !"Ограничение должно быть от 20 до 120");
	pTemp[playerid][pSLimit] = params[0];
	SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Установлено ограничение скорости");
	return 1;
}
CMD:slimit(playerid)
{//GetModelStaticSpeed(GetVehicleModel(RE_IDX));
	if (!pInfo[playerid][pLogin] || IsANoLimiter(GetPlayerVehicleID(playerid))) return 1;
	if (pInfo[playerid][pDrivingSkill] > 1) return SendClientMessage(playerid, COLOR_GREY, !"Ваш навык недостаточно высок!");
	switch(pInfo[playerid][pDrivingSkill])
	{
	    case 0: pInfo[playerid][pDrivingSkill] = 1/*, PlayerTextDrawSetString(playerid,gSpeedometr[playerid][7],"~r~MAX")*/;
	    case 1: pInfo[playerid][pDrivingSkill] = 0/*, PlayerTextDrawSetString(playerid,gSpeedometr[playerid][7],"MAX")*/;
	}
    return 1;
} 
CMD:setmng(playerid, params[])
{
	new casino_tmp = 1;
	if (casino_tmp == 1) return SendClientMessage(playerid, COLOR_GREY, !"Эта команда временно не доступна");
    for(new i = 1; i <= TOTALCASINO; i++)
	{
	    new string_[128];
		if (!IsPlayerInRangeOfPoint(playerid, 200, CasinoInfo[i][caPos][0], CasinoInfo[i][caPos][1], CasinoInfo[i][caPos][2])) continue;
		if (pInfo[playerid][pMember] != CasinoInfo[i][caMafia] || pInfo[playerid][pRank] < 9) return 1;
		if (sscanf(params, "dd",params[0],params[1]) || (params[0] == playerid && params[0] > -1)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setmng [playerid (-1 для увольнения)] [слот (0 - 2)]");
		if (params[0] > -1 && pInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Этот человек состоит в организации!");
		if (params[0] == -1)
		{
			switch(params[1]){
			    case 1:{
			        format(string_, sizeof string_, "Вы уволили %s с должности Менеджера [%d]",CasinoInfo[i][caManager],params[1]);
			     	strmid(CasinoInfo[i][caManager],"-", 0, strlen("-"), MAX_PLAYER_NAME);
				}
			    case 2:{
			        format(string_, sizeof string_, "Вы уволили %s с должности Менеджера [%d]",CasinoInfo[i][caManager2],params[1]);
			        strmid(CasinoInfo[i][caManager2],"-", 0, strlen("-"), MAX_PLAYER_NAME);
				}
			    case 3:{
			        format(string_, sizeof string_, "Вы уволили %s с должности Менеджера [%d]",CasinoInfo[i][caManager3],params[1]);
			        strmid(CasinoInfo[i][caManager3],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			    }
				default:
				    return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!");
			}
			SaveCasinoIDManager(i);
			return SendClientMessage(playerid, COLOR_BLUE, string_);
		}
		else
		{
  			if (params[1] == 0) strmid(CasinoInfo[i][caManager],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
	    	else if (params[1] == 1) strmid(CasinoInfo[i][caManager2],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
		   	else if (params[1] == 2) strmid(CasinoInfo[i][caManager3],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
		    else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
		    format(string_, sizeof string_, "%s назначил вас Менеджером казино [%d]",pInfo[playerid][pName],params[1]);
			SendClientMessage(params[0], COLOR_BLUE, string_);
			SaveCasinoIDManager(i);
			format(string_, sizeof string_, "Вы назначили %s Менеджером казино [%d]",pInfo[params[0]][pName],params[1]);
			return SendClientMessage(playerid, COLOR_BLUE, string_);
		}
	}
	return 1;
}


CMD:finvite(playerid, params[])
{
	new FARM_ID = pTemp[playerid][TempFermID];
	if (pTemp[playerid][JobInFarmRank]< 3 || FARM_ID < 1) return 1;

	new string_[128];//fCloakroom
	if (!IsPlayerInRangeOfPoint(playerid, 20.0, FarmInfo[FARM_ID][fMenu][0], FarmInfo[FARM_ID][fMenu][1], FarmInfo[FARM_ID][fMenu][2] )
		&& !IsPlayerInRangeOfPoint(playerid,20.0, FarmInfo[FARM_ID][fCloakroom][0], FarmInfo[FARM_ID][fCloakroom][1], FarmInfo[FARM_ID][fCloakroom][2] ) )
			return SendClientMessage(playerid,-1,"Вы не возле фермы!");
    if (sscanf(params, "ddd", params[0], params[1], params[2]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /finvite [playerid (-1 для увольнения)] [тип] [место (от 1)]");
		return SendClientMessage(playerid, COLOR_WHITE, !"Тип: 1 - заместитель | 2 - фермер");
	}
	if (playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали свой ID");
	if (params[0] != -1 && pInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Этот человек состоит в организации!");
	switch(params[1])
	{
	    case 1:
	    {
	        if (pTemp[playerid][JobInFarmRank] < 4) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете нанимать заместителей");
	        if (params[0] == -1)
			{
				if (params[2] == 1) strmid(FarmInfo[FARM_ID][fDeputy_1],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else if (params[2] == 2) strmid(FarmInfo[FARM_ID][fDeputy_2],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else if (params[2] == 3) strmid(FarmInfo[FARM_ID][fDeputy_3],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
				SaveFermIDFarmers(FARM_ID);
				format(string_, sizeof string_, "Вы уволили %s с должности заместителя [%d]",pInfo[params[0]][pName],params[2]);
				return SendClientMessage(playerid, COLOR_BLUE, string_);
			}
			else
			{
			    if (IsFermerPlayer(pInfo[params[0]][pName], FARM_ID)) return scm(playerid, COLOR_GREY, !"Игрок уже фермер на ферме!");
			    if (params[2] == 1) strmid(FarmInfo[FARM_ID][fDeputy_1],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else if (params[2] == 2) strmid(FarmInfo[FARM_ID][fDeputy_2],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else if (params[2] == 3) strmid(FarmInfo[FARM_ID][fDeputy_3],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
				SaveFermIDFarmers(FARM_ID);
				format(string_, sizeof string_, "%s назначил вас заместителям фермы [%d]",pInfo[playerid][pName], params[2]);
				SendClientMessage(params[0],COLOR_BLUE,string_);
			    format(string_, sizeof string_, "Вы приняли %s на должность заместителя", pInfo[params[0]][pName]);
			    return SendClientMessage(playerid, COLOR_BLUE,string_);
			}
		}
		case 2:
		{
		    if (params[0] == -1)
			{
				if (params[2] == 1) strmid(FarmInfo[FARM_ID][fFarmer_1],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else if (params[2] == 2) strmid(FarmInfo[FARM_ID][fFarmer_2],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else if (params[2] == 3) strmid(FarmInfo[FARM_ID][fFarmer_3],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else if (params[2] == 4) strmid(FarmInfo[FARM_ID][fFarmer_4],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else if (params[2] == 5) strmid(FarmInfo[FARM_ID][fFarmer_5],"None", 0, strlen("None"), MAX_PLAYER_NAME);
				else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
				SaveFermIDFarmers(FARM_ID);
				format(string_, sizeof string_, "Вы уволили %s с должности фермера [%d]",pInfo[params[0]][pName],params[2]);
				return SendClientMessage(playerid,COLOR_BLUE,string_);
			}
			else
			{
			    if (IsDeputyPlayer(pInfo[params[0]][pName], FARM_ID)) return scm(playerid, COLOR_GREY, !"Игрок уже заместитель на ферме!");
			    if (params[2] == 1) strmid(FarmInfo[FARM_ID][fFarmer_1],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else if (params[2] == 2) strmid(FarmInfo[FARM_ID][fFarmer_2],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else if (params[2] == 3) strmid(FarmInfo[FARM_ID][fFarmer_3],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else if (params[2] == 4) strmid(FarmInfo[FARM_ID][fFarmer_4],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else if (params[2] == 5) strmid(FarmInfo[FARM_ID][fFarmer_5],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
				else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
				SaveFermIDFarmers(FARM_ID);
				format(string_, sizeof string_, "%s назначил вас фермером [%d]",pInfo[playerid][pName], params[2]);
				SendClientMessage(params[0],COLOR_BLUE, string_);
			    format(string_, sizeof string_, "Вы приняли %s на должность фермера", pInfo[params[0]][pName]);
			    return scm(playerid, COLOR_BLUE, string_);
			}
		}
		default: return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
	}
	return 1;
}
CMD:cinvite(playerid, params[])
{
	new casino_tmp = 1;
	if (casino_tmp == 1) return SendClientMessage(playerid, COLOR_GREY, !"Эта команда временно не доступна");
    for(new i = 1; i <= TOTALCASINO; i++)
	{
	    new string_[128];
		if (!IsPlayerInRangeOfPoint(playerid, 200.0, CasinoInfo[i][caPos][0],CasinoInfo[i][caPos][1], CasinoInfo[i][caPos][2])) continue;
		if (GetPVarInt(playerid,"CasinoRank") != 2) return 1;
		if (sscanf(params, "dd",params[0],params[1]) || (params[0] == playerid && params[0] > -1)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /cinvite [playerid (-1 для увольнения)] [слот (0 - 9)]");
		if (params[0] > -1 && pInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Этот человек состоит в организации!");
		if (params[0] == -1)	
		{
			if (params[1] == 0) strmid(CasinoInfo[i][caKrupie],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 1) strmid(CasinoInfo[i][caKrupie2],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 2) strmid(CasinoInfo[i][caKrupie3],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 3) strmid(CasinoInfo[i][caKrupie4],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 4) strmid(CasinoInfo[i][caKrupie5],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 5) strmid(CasinoInfo[i][caKrupie6],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 6) strmid(CasinoInfo[i][caKrupie7],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 7) strmid(CasinoInfo[i][caKrupie8],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 8) strmid(CasinoInfo[i][caKrupie9],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else if (params[1] == 9) strmid(CasinoInfo[i][caKrupie10],"-", 0, strlen("-"), MAX_PLAYER_NAME);
			else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
			SaveCasinoIDDealer(i);
			format(string_, sizeof string_, "Вы уволили %s с должности Крупье [%d]",pInfo[params[0]][pName],params[1]);
			return SendClientMessage(playerid,COLOR_BLUE, string_);
		}
		else
		{
     		if (params[1] == 0) strmid(CasinoInfo[i][caKrupie],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 1) strmid(CasinoInfo[i][caKrupie2],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 2) strmid(CasinoInfo[i][caKrupie3],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 3) strmid(CasinoInfo[i][caKrupie4],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 4) strmid(CasinoInfo[i][caKrupie5],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 5) strmid(CasinoInfo[i][caKrupie6],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 6) strmid(CasinoInfo[i][caKrupie7],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 7) strmid(CasinoInfo[i][caKrupie8],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 8) strmid(CasinoInfo[i][caKrupie9],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else if (params[1] == 9) strmid(CasinoInfo[i][caKrupie10],pInfo[params[0]][pName], 0, strlen(pInfo[params[0]][pName]), MAX_PLAYER_NAME);
			else return SendClientMessage(playerid, COLOR_GREY, !"Неверный слот!"), 1;
			format(string_, sizeof string_, "%s назначил вас Крупье [%d]",pInfo[playerid][pName],params[1]);
			SendClientMessage(params[0],COLOR_BLUE,string_);
			SaveCasinoIDDealer(i);
			format(string_, sizeof string_, "Вы назначили %s Крупье [%d]",pInfo[params[0]][pName],params[1]);
			return SendClientMessage(playerid,COLOR_BLUE,string_);
		}
	}
	return 1;
}
CMD:cinfo(playerid, params[])
{
	new casino_tmp = 1;
	if (casino_tmp == 1) return SendClientMessage(playerid, COLOR_GREY, !"Эта команда временно не доступна");
    for(new i = 1; i <= TOTALCASINO; i++)
	{
		if (!IsPlayerInRangeOfPoint(playerid, 200,CasinoInfo[i][caPos][0], CasinoInfo[i][caPos][1], CasinoInfo[i][caPos][2])) continue;
		t_string[0] = EOS;
		format(t_string, sizeof t_string, ""colwhi"Казино: %s\n\nРаботники казино:\n\n[0] Менеджер: %s\n[1] Менеджер: %s\n[2] Менеджер: %s\n\n[0] Крупье: %s\n[1] Крупье: %s\n[2] Крупье: %s\n[3] Крупье: %s\n[4] Крупье: %s\n[5] Крупье: %s\n[6] Крупье: %s\n[7] Крупье: %s\n[8] Крупье: %s\n[9] Крупье: %s",
		CasinoInfo[i][caName],CasinoInfo[i][caManager],CasinoInfo[i][caManager2],CasinoInfo[i][caManager3],CasinoInfo[i][caKrupie],CasinoInfo[i][caKrupie2],CasinoInfo[i][caKrupie3],CasinoInfo[i][caKrupie4],CasinoInfo[i][caKrupie5],
		CasinoInfo[i][caKrupie6],CasinoInfo[i][caKrupie7],CasinoInfo[i][caKrupie8],CasinoInfo[i][caKrupie9],CasinoInfo[i][caKrupie10]);
		ShowPlayerDialog(playerid, D_NULL,DIALOG_STYLE_MSGBOX,"Информация о Казино", t_string,"Скрыть","");
		break;
	}
	return 1;
} 


CMD:sellgrib(playerid, params[])
{
    for (new id = 0; id < sizeof (BusinessInfo); id++)
	{
		if (!IsValidBusiness(id)) continue;
		if (BusinessInfo[id][bType] != BUSINESS_TYPE_CLUCKIN_BELL && BusinessInfo[id][bType] != BUSINESS_TYPE_PIZZA  && BusinessInfo[id][bType] != BUSINESS_TYPE_BURGER_SHOT) continue; 
		if (!pInfo[playerid][pMushrooms]) return SendClientMessage(playerid, COLOR_WHITE, !"У Вас нет грибов");
		if (IsPlayerInRangeOfPoint(playerid, 5.0, BusinessInfo[id][bPos][0],BusinessInfo[id][bPos][1],BusinessInfo[id][bPos][2]))
		{
			kLibGivePlayerMoney(playerid, pInfo[playerid][pMushrooms]*25, "/sellbiz");
			//BizzInfo[i][bProducts] += pInfo[playerid][pMushrooms];
			new
                string_[128];
			format(string_, sizeof string_, "Вы продали "colserver"%d "colwhi"грибов за "collime"$%d", pInfo[playerid][pMushrooms], pInfo[playerid][pMushrooms]*25);
			SendClientMessage(playerid, COLOR_WHITE, string_);
			pInfo[playerid][pMushrooms] = 0;
			SavePlayerInteger(playerid, "pMushrooms", pInfo[playerid][pMushrooms]);
		}
	}
	return 1;
} 

CMD:bizlist(playerid, params[])
{
	if (!IsAMafia(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда");
    new
		count_ = 0,
		string[128];
    t_string[0] = EOS;
	for (new i = 0; i < sizeof (BusinessInfo); i++) 
	{ 
		if (!IsValidBusiness(i)) 
			continue;
		if (BusinessInfo[i][bMafia] == pInfo[playerid][pMember])
		{
		    count_ ++;
			format(string, sizeof(string), ""colwhi"[%d] %s\n", count_, BusinessInfo[i][bName]);
			strcat(t_string, string);
		}
	}
	if (strlen(t_string) > 1) ShowPlayerDialog(playerid, D_NULL, 2, "Завоёванные бизнесы", t_string, "$", "$");
	else SendClientMessage(playerid, -1, !"Нет бизнесов");
	return 1;
}
alias:bizlist("blist", "бизлист");
 
CMD:smoke(playerid,params[])
{
	if (pTemp[playerid][tPaintTeam] != 0 || IsPlayerInDuel(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на дуэлях/PB");
	if (pTemp[playerid][PlayerIsSmoking] != 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже курите");
 	if (pInfo[playerid][pLighter] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет зажигалки");
  	if (pInfo[playerid][pCigarettes] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет сигарет");
  	new randlighter = RandomFIX(0,10), string[64];
  	if (randlighter == 3)
  	{
  	    pInfo[playerid][pLighter] = 0;
  	    SavePlayerInteger(playerid, "pLighter", pInfo[playerid][pLighter]);
  		return SendClientMessage(playerid,COLOR_WHITE,!"Вы сломали зажигалку");
  	}
   	new randsmoke = random(2)+1;
	if (randsmoke == 1)
	{
 		pInfo[playerid][pCigarettes] -= 1;
 		SavePlayerInteger(playerid, "pCigarettes", pInfo[playerid][pCigarettes]);
   		format(string, sizeof(string), "%s прикурил(а) сигарету.",pInfo[playerid][pName]);
   		SendBeside(playerid,COLOR_PURPLE, string,30.0);
   		pTemp[playerid][PlayerIsSmoking] = 60;
   		SendClientMessage(playerid, COLOR_WHITE, !"Используйте /dropcigarette чтобы выбросить сигарету.");
   		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
   		return 1;
	}
	else
	{
		format(string, sizeof(string), "%s пытается прикурить сигарету.",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE,string,30.0);
	}
	return 1;
}
CMD:dropcigarette(playerid,params[])
{
    if (pTemp[playerid][PlayerIsSmoking] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не курите");
    pTemp[playerid][PlayerIsSmoking] = 0;
    new string[128];
    format(string, sizeof(string), "%s выбросил(а) сигарету на землю.", pInfo[playerid][pName]);
    SendBeside(playerid,COLOR_PURPLE,string,30.0);
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
    return 1;
}
CMD:ciga(playerid,params[])
{
    new string[128];
    format(string, sizeof(string), "%s открыл(а) пачку сигарет.", pInfo[playerid][pName]);
    SendBeside(playerid,COLOR_PURPLE,string,30.0);
    format(string, sizeof(string), "У вас в пачке %d сигарет.", pInfo[playerid][pCigarettes]);
    SendClientMessage(playerid,-1,string);
    return 1;
}


 
CMD:buycar(playerid, params[])
{
    if (!pInfo[playerid][pLicense][0]) return SendClientMessage(playerid, COLOR_WHITE, !"У вас нет Лицензии на управление авто");
	if (pInfo[playerid][pHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы не имеете дома/квартиры!");
	if (IsPlayerInRangeOfPoint(playerid,5.0, 539.6257,-1293.9208,17.2422))
	{
		SetPVarInt(playerid,"AutoShopShow",1);
		SetPVarInt(playerid,"CarShop",0);
		return ShowBuyCar(playerid);
	}
	else if (IsPlayerInRangeOfPoint(playerid,5.0, -1951.2544,293.6375,35.4688))//
	{
		SetPVarInt(playerid,"AutoShopShow",2);
		return ShowPlayerDialog(playerid,D_AUTOSHOP_SHOW_0,0," ","Выберите класс машин","C","D");
	}
	else if (IsPlayerInRangeOfPoint(playerid,5.0, -1657.7015,1210.2267,7.2500))
	{
		SetPVarInt(playerid,"AutoShopShow",3);
		return ShowPlayerDialog(playerid,D_AUTOSHOP_SHOW_0,0," ","Выберите класс машин","A","B");
	}
	else if (IsPlayerInRangeOfPoint(playerid,5.0, 2200.8857,1394.2892,11.0625))
	{
		SetPVarInt(playerid,"AutoShopShow",4);
		return ShowPlayerDialog(playerid,D_AUTOSHOP_SHOW_0,0," ","Выберите класс машин","A","B");
	}
	else SendClientMessage(playerid, COLOR_WHITE, !"Вы не в месте продажи автомобилей!");
	return 1;
} 

CMD:route(playerid, params[])
{
    if (pInfo[playerid][pJob] != PLAYER_JOB_BUS) return SendClientMessage(playerid, COLOR_GREY, !"Вы не водитель автобуса!");

	#if defined _job_inc

	if (GetPlayerBus{playerid} == 1) {
		ShowPlayerDialog(playerid,D_JOB_START_ROUTE,DIALOG_STYLE_MSGBOX, 
		!""colserver"Водитель автобуса", !""colwhi"Вы хотите завершить рабочий день?", !"Да", !"Нет");
	}
	else
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем автобуса!");
		new 
			V_IDX = GetPlayerVehicleID(playerid);
		if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_BUS)) {
			ShowPlayerDialog(playerid,D_JOB_START_ROUTE,DIALOG_STYLE_MSGBOX,!""colserver"Водитель автобуса", !""colwhi"Начать работу водителя автобуса?", !"Да", !"Нет");
		} else {
			SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в рабочем транспорте");
		}
	}

	#else

	if (GetPlayerState(playerid) != 2) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем автобуса!");
	new 
		V_IDX = GetPlayerVehicleID(playerid);
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB &&//TYPE_ROUTE_BUS_0
		(VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_BUS))
	{
		if (GetPVarInt(playerid, "TypeBus") > 0)
		{
			new 
				string_[128];
			format(string_, sizeof string_, "Рабочий день завершен. Вами заработано: $%d. За ремонт: $-%d", GetPVarInt(playerid, "BusMoney"), GetPVarInt(playerid,"BusRepairMoney"));
			SendClientMessage(playerid, 0x6495EDFF, string_);
			SendClientMessage(playerid, COLOR_WHITE, !"Деньги будут перечислены на счет во время зарплаты");
			pInfo[playerid][pPayCheck] -= GetPVarInt(playerid,"BusRepairMoney");
			DeletePVar(playerid, "BusTime");
			DeletePVar(playerid, "TypeBus");
			DeletePVar(playerid, "BusStop");
			DeletePVar(playerid, "BusMoney");
			DeletePVar(playerid, "BusRepairMoney");
			pTemp[playerid][pRentCar] = INVALID_VEHICLE_ID;
			pPressed[playerid] = 0; 
			SetVehicleToRespawn(V_IDX);
			DisablePlayerRaceCheckpoint(playerid);
			return 1;
		}
		if (VehicleInfo[ V_IDX - 1 ][vSubFraction] == TYPE_ROUTE_BUS_0) ShowPlayerDialog(playerid, D_JOB_START_ROUTE, DIALOG_STYLE_MSGBOX," ","Начать работу водителя автобуса?", "Да", "Нет");
  		else if (VehicleInfo[ V_IDX - 1 ][vSubFraction] == TYPE_ROUTE_BUS_1) ShowPlayerDialog(playerid, D_JOB_START_ROUTE, DIALOG_STYLE_MSGBOX," ","Начать работу водителя автобуса?", "Да", "Нет");
    	else if (VehicleInfo[ V_IDX - 1 ][vSubFraction] == TYPE_ROUTE_BUS_2) ShowPlayerDialog(playerid, D_JOB_START_ROUTE, DIALOG_STYLE_MSGBOX," ","Начать работу водителя автобуса?", "Да", "Нет");
     	else ShowPlayerDialog(playerid, D_BUS_ROUTE, 2, "Маршрут", "АвтоВокзал LS << >> Автошкола SF\nАвтоВокзал LS << >> АвтоВокзал LV\nАвтоВокзал LS << >> Заводы", "Принять", "Отмена");
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в автобусе!");

	#endif

	return 1;
}


CMD:outdrugs(playerid){
	if (!pInfo[playerid][pDrugs])
	    return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет наркотиков!");
    pInfo[playerid][pDrugs] = 0;
    return SendClientMessage(playerid, -1, !"Вы выбросили все наркотики!");
}
CMD:outmats(playerid){
	if (!pInfo[playerid][pMats])
	    return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет материалов!");
    pInfo[playerid][pMats] = 0;
    return SendClientMessage(playerid, -1, !"Вы выбросили все материалы!");
}
CMD:sellform(playerid, params[]){
	if (!PlayerInConnected(playerid))
	    return true;
	if (pInfo[playerid][pMember] != FRACTION_ARMY_SF && pInfo[playerid][pMember] != FRACTION_ARMY_LV || !pTemp[playerid][tDutyWork])
	    return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет формы!");
	if (sscanf(params, "ii", params[0], params[1]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Введите: /sellform [playerid][цена]");
    if (!PlayerInConnected(params[0]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Игрок не авторизован!");
	if (pInfo[playerid][pModel] == 252)
	    return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет формы!");
	if (!IsAGang(params[0]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться в банде!");
	if (params[1] < 0 || params[1] > 100000)
	    return SendClientMessage(playerid, COLOR_GREY, !"Цена должна быть не ниже 1$ и не более 100.000$");
    if (GetPVarInt(params[0], #formprice) != 0)
        return SendClientMessage(playerid, COLOR_GREY, !"Игроку уже предложили сделку!");
	new
	    Float: p_posX,
	    Float: p_posY,
	    Float: p_posZ;
	GetPlayerPos(params[0], p_posX, p_posY, p_posZ);
	if (!IsPlayerInRangeOfPoint(playerid, 5, p_posX, p_posY, p_posZ))
	    return SendClientMessage(playerid, COLOR_GREY, !"Нужно находиться рядом с игроком!");
	SetPVarInt(params[0], #formprice, params[1]);
	SetPVarInt(params[0], #psellform, playerid);
	new
	    string_[256];
	SendMes(playerid, -1, "Вы предложили %s купить военную форму за $%d. Ждите подтверждения!", pInfo[params[0]][pName], params[1]);
	format(string_, sizeof string_, ""colmain"%s{FFFFFF} предложил Вам купить военную форму за "colmain"$%d", pInfo[playerid][pName], params[1]);
	return ShowPlayerDialog(params[0], D_SELLARMY_CHAR, DIALOG_STYLE_MSGBOX, "Сделка", string_, "Принять", "Отказаться");
}


CMD:mafiastats(playerid){
    if (!IsAMafia(playerid) && !pInfo[playerid][pAdmin]) return true; 
	ShowPlayerDialog(playerid, D_MAFIA_FUNC_0, DIALOG_STYLE_LIST, ""colserver"Список лучших", 
		""colmain" - Статистика мафии\n"colmain" - Дипломатия", "Выбрать", "Закрыть"
	);
	return true;
} 
CMD:gangstats(playerid)
{
	if (!IsAGang(playerid) && !pInfo[playerid][pAdmin]) return true;
	ShowPlayerDialog(playerid, D_GANG_FUNC_0, DIALOG_STYLE_LIST, ""colserver"Список лучших", "[0] Лучшие стрелки\n [1] Топ захватчиков\n [2] Топ 15 райтеров\n [3] Топ 15 Дуэлянтов\n "colmain" - Статистика банд\n"colmain" - Дипломатия", "Выбрать", "Закрыть");
	return 1;
}
CMD:ffixcar(playerid)
{ 
	if ((!IsAGang(playerid) && !IsAMafia(playerid) && !IsABiker(playerid)) || pInfo[playerid][pRank] < 8) return SendClientMessage(playerid, COLOR_GREY, !"Данная комадна доступна только Бандам/Мафиям ( Ваш ранг должен быть выше 8 )!");
	new 
		fraction_id = pInfo[playerid][pMember],
		string_[128];
	if (SystemConfig[gCDReSpawnCar][fraction_id - 1] > gettime()) {
		format(string_, sizeof string_, "[Оповещение] "colwhi"Респавн транспорта возможен через %s", Converts(SystemConfig[gCDReSpawnCar][fraction_id - 1] - gettime()) );
		SendClientMessage(playerid, COLOR_LI_RED, string_);
		return 1;
	}
	ShowPlayerDialog(playerid, D_RESPAWN_FRAC_CAR, DIALOG_STYLE_MSGBOX, ""colserver"Респавн фракционных машин", "\
		"colwhi"Вы собираетесь выполнить респавн фракционных машин, учтите:\n\n\
		- За каждую машину с банка банды снимется "collime"$1.000\n\
		"colwhi"- Занятые машины не будут заспавнены\n\
		- Машины находящиеся на территории Вашего респавна не будут заспавнены.", "Выполнить", "Отмена");
	return 1;
}
alias:ffixcar("gfixcar");
CMD:gwage(playerid, params[]){
    if ((!IsAGang(playerid) && !IsAMafia(playerid)) || pInfo[playerid][pRank] < 9) return SendClientMessage(playerid, COLOR_GREY, !"Данная комадна доступна только Бандам/Мафиям ( Ваш ранг должен быть выше 9 )!");
	if (gFraction[ pInfo[playerid][pMember] ][fLimitPrize] > 3) { 
		SendClientMessage(playerid, 0x6495EDFF, !"В день можно выдать три раза премию");
		return 1;
	}
	if (sscanf(params, "d", params[0]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Введите: /gwage [сумма]");
	if (params[0] < 1000 || params[0] > 30000)
	    return SendClientMessage(playerid, COLOR_GREY, !"Сумма зарплаты должна быть от $1.000 до $30.000!");
	
	if(gFraction[ pInfo[playerid][pMember] ][fPrizeTime] > 0) return SendMes(playerid,CGRAY2,"Премию можно будет дать через %d час(а)",gFraction[ pInfo[playerid][pMember] ][fPrizeTime]);

	new
	    string_[128];

	// foreach(new i : PlayerTeam[pInfo[playerid][pMember]])

	if (Iter_Count(PlayerTeam[pInfo[playerid][pMember]]) * params[0] > FractionInfo[ pInfo[playerid][pMember] ][fMoney])
	    return SendClientMessage(playerid, COLOR_GREY, !"На балансе банка недостаточно денежных средств!");

	gFraction[ pInfo[playerid][pMember] ][fLimitPrize] ++;

	foreach(new i : PlayerTeam[pInfo[playerid][pMember]])
	{
		pInfo[i][pBank] += params[0];
		SavePlayerInteger(i, "pBank", pInfo[i][pBank]);
		LogMoney(i, params[0], "/gwage");
		FractionInfo[pInfo[playerid][pMember]][fMoney] -= params[0];
	}

	gFraction[ pInfo[playerid][pMember] ][fPrizeTime] = 3;

	format(string_, sizeof string_, "%s выплатил зарплату всему составу в размере $%d", pInfo[playerid][pName], params[0]);
	SendFamilyMessage(pInfo[playerid][pMember], 0x6BB3FFAA, string_);
	return true;
}


CMD:tsetstat(playerid, params[]){
	if (sscanf(params, "dd", params[0], params[1]))
	    return SendClientMessage(playerid, COLOR_GREY, !"/tsetstat [уровень][exp]");
    if (pInfo[playerid][pJob] != 7) return SendClientMessage(playerid, COLOR_GREY, !"Вы не Дальнобойщик");
    pInfo[playerid][pDLevel] = params[0];
    return pInfo[playerid][pDExp] = params[1];
}
CMD:tmonitor(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid,1.0,-1731.5077,118.8833,3.5547) || IsPlayerInRangeOfPoint(playerid,1.0,2768.2495,-2456.6716,13.6432))
	if (pInfo[playerid][pJob] != JOB_TRUCKER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не Дальнобойщик");
	t_string[0] = EOS;
	format(t_string, sizeof t_string, 
		""colwhi"Цены продуктов:\n\
		\tНефтезавод №1 Цена 1т: "collime"$%d\n\t\t\
		"colwhi"Нефтезавод №2 Цена 1т: "collime"$%d\n\t\t\
		"colwhi"Склад угля №1 Цена 1т: "collime"$%d\n\t\t\
		"colwhi"Склад угля №2 Цена 1т: "collime"$%d\n\t\t\
		"colwhi"Лесопилка №1 Цена 1т: "collime"$%d\n\t\t\
		"colwhi"Лесопилка №2 Цена 1т: "collime"$%d\n\n\
		"colwhi"Порт [LS], Цена 1т:\n\t\t\
		"colwhi"Нефть: "collime"$%d\n\t\t\
		"colwhi"Уголь: "collime"$%d\n\t\t\
		"colwhi"Дерево: "collime"$%d\n\
		"colwhi"Порт [SF], Цена 1т:\n\t\t\
		"colwhi"Нефть: "collime"$%d\n\t\t\
		"colwhi"Уголь: "collime"$%d\n\t\t\
		"colwhi"Дерево: "collime"$%d\n",
		Benzbuy[0], Benzbuy[1], ugolbuy[0], 
		ugolbuy[1], Buyderevo[0], Buyderevo[1], 
		Sellbenz[0], Sellugol[0], Sellderevo[0], 
		Sellbenz[1], Sellugol[1], Sellderevo[1]
	);
	ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Мониторинг: "colwhi"Цен", t_string, "Готово", "");
	return 1;
}

CMD:radio(playerid, params[])
{
    if (sscanf(params, "d", params[0]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /switchwave [номер]");
		SendClientMessage(playerid, COLOR_WHITE, !" [0] Выключить");
		SendClientMessage(playerid, COLOR_WHITE, !" [1] SF News");
		SendClientMessage(playerid, COLOR_WHITE, !" [2] LS News");
		SendClientMessage(playerid, COLOR_WHITE, !" [3] LV News");
		return 1;
	}
	switch (params[0])
	{
		case 1:
		{
			lNews[playerid] = true;
			gNews[playerid] = false;
			LvNews[playerid] = true;
			SendClientMessage(playerid, COLOR_WHITE, !"Волна переключена на SF News");
		}
		case 2:
		{
			lNews[playerid] = false;
			gNews[playerid] = true;
			LvNews[playerid] = true;
			SendClientMessage(playerid, COLOR_WHITE, !"Волна переключена на LS News");
		}
		case 3:
		{
			lNews[playerid] = true;
			gNews[playerid] = true;
			LvNews[playerid] = false;
			SendClientMessage(playerid, COLOR_WHITE, !"Волна переключена на LV News");
		}
		case 0:
		{
			lNews[playerid] = true;
			gNews[playerid] = true;
			LvNews[playerid] = true;
			SendClientMessage(playerid, COLOR_WHITE, !"Вы выключили радио");
		}
	}
	return 1;
}
alias:radio("switchwave");
/*CMD:instopen(playerid)
{
    if (pInfo[playerid][pMember] != 11 && pInfo[playerid][pLeader] != 11 && pTemp[playerid][TakingLesson] != false) return 1;
	if (!IsPlayerInRangeOfPoint(playerid,8.0,-2074.50000000,-94.90000153,35.00000000)) return 1;
	SetObjectRot(licgate,0.00000000,0.00000000,270.00000000);
	SetTimer("LicClose", 8000, 0);
	SendClientMessage(playerid, 0x6495EDFF, !"Шлагбаум опустится через 8 секунд");
	return 1;
}*/

CMD:givenewskeys(playerid, params[])
{
	if (!IsANews(playerid)) return 1;
    if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /givenewskeys [id]");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом");
    if (pTemp[params[0]][PlayerKeyNews] == true) return SendClientMessage(playerid, COLOR_GREY, !"У человека уже есть пропуск!");
	if (((pInfo[playerid][pMember] == 9 || pInfo[playerid][pMember] == 16 || pInfo[playerid][pMember] == 20) && pTemp[playerid][tDutyWork] == 1) || pInfo[playerid][pAdmin] == 5)
	{
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return 1;
		pTemp[params[0]][PlayerKeyNews] = true;
		new string[128];
		format(string, sizeof string, "Сотрудник News %s выдал пропуск в офис %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
		SendBeside(playerid, COLOR_PURPLE, string, 30.0);
	}
	return 1;
}
CMD:takenewskeys(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
    if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /takenewskeys [id]");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (pTemp[params[0]][PlayerKeyNews] == false) return SendClientMessage(playerid, COLOR_GREY, !"У человека нет пропуска!");
	if (pInfo[playerid][pMember] == 9 || pInfo[playerid][pMember] == 16 || pInfo[playerid][pMember] == 20 || pInfo[playerid][pAdmin] == 5)
	{
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return 1;
		pTemp[params[0]][PlayerKeyNews] = false;
		new string[128];
		format(string, sizeof(string), "Сотрудник News %s забрал пропуск в офис %s",pInfo[playerid][pName],pInfo[params[0]][pName]);
		SendBeside(playerid,COLOR_PURPLE,string,30.0);
	}
	return 1;
}

CMD:news(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
	new string[144],
		V_IDX = GetPlayerVehicleID(playerid);
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	//if (pInfo[playerid][pRank] < 2) return SendClientMessage(playerid, COLOR_WHITE, !"Вам не доступна эта функция");
	if (strlen(params[0]) >= 64) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[64]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /news [текст]");
    if (V_IDX != 0)
    {
	    if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == 9 || VehicleInfo[ V_IDX - 1 ][vFraction] == 16 || VehicleInfo[ V_IDX - 1 ][vFraction] == 20) )
	    {
	        if (pInfo[playerid][pMember] == FRACTION_SF_NEWS)
	        {
	            format(string, sizeof string, "< SF News > %s: %s", pInfo[playerid][pName], params[0] );
				OOCNews(COLOR_GREEN, string);
				gNews[playerid] = false;
	        }
	        else if (pInfo[playerid][pMember] == FRACTION_LS_NEWS)
	        {
	            format(string, sizeof string, "< LS News > %s: %s", pInfo[playerid][pName], params[0] );
				LSNews(0x0073B7AA, string);
				lNews[playerid] = false;
	        }
	        else if (pInfo[playerid][pMember] == FRACTION_LV_NEWS)
	        {
	            format(string, sizeof string, "< LV News > %s: %s", pInfo[playerid][pName], params[0] );
				LVNews(0xC3003AAA, string);
				LvNews[playerid] = false;
	        }
	    }
	}
	else
	{
    	if (IsPlayerInRangeOfPoint(playerid, 10.0,1376.7966,-30.4065,1000.9265))
	    {
	        if (GetPlayerVirtualWorld(playerid) == 1)
	        {
	        	if (pInfo[playerid][pMember] != FRACTION_SF_NEWS) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	        	format(string, sizeof string, "< SF News > %s: %s", pInfo[playerid][pName], params[0] );
				OOCNews(COLOR_GREEN, string);
				gNews[playerid] = false;
	        }
	        else if (GetPlayerVirtualWorld(playerid) == 2)
	        {
	        	if (pInfo[playerid][pMember] != FRACTION_LS_NEWS) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	        	format(string, sizeof string, "< LS News > %s: %s", pInfo[playerid][pName], params[0] );
				LSNews(0x0073B7AA, string);
				lNews[playerid] = false;
	        }
	        else if (GetPlayerVirtualWorld(playerid) == 3)
	        {
	        	if (pInfo[playerid][pMember] != FRACTION_LV_NEWS) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	        	format(string, sizeof string, "< LV News > %s: %s", pInfo[playerid][pName], params[0] );
				LVNews(0xC3003AAA, string);
				LvNews[playerid] = false;
	        }
	        else SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	    }
	    else SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
    }
	return 1;
}

CMD:npanel(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
    if (!IsANews(playerid)) return 1;
    new V_IDX = GetPlayerVehicleID(playerid);
    if (V_IDX != 0)
    {
	    if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == 9 || VehicleInfo[ V_IDX - 1 ][vFraction] == 16 || VehicleInfo[ V_IDX - 1 ][vFraction] == 20) )
	    {
	        ShowPlayerDialog(playerid, D_NEWS_PANEL_4, DIALOG_STYLE_LIST, "[ NEWS MENU ]", "[0] Прямой эфир\n[1] Выйти из прямого эфира\n[2] Начать принимать звонки / смс\n[3] Завершить принимать звонки / смс\n[4] Объявления\n[5] Банк\n[6] Раздел лидера", "Выбрать", "Закрыть");
	    }
	}
    else
	{
    	if (IsPlayerInRangeOfPoint(playerid, 10.0,1376.7966,-30.4065,1000.9265))
	    {
	        if (GetPlayerVirtualWorld(playerid) == 1)
	        {
	        	if (pInfo[playerid][pMember] != FRACTION_SF_NEWS) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	        	ShowPlayerDialog(playerid, D_NEWS_PANEL_4, DIALOG_STYLE_LIST, "[ NEWS MENU ]", "[0] Прямой эфир\n[1] Выйти из прямого эфира\n[2] Начать принимать звонки / смс\n[3] Завершить принимать звонки / смс\n[4] Объявления\n[5] Банк\n[6] Раздел лидера", "Выбрать", "Закрыть");
	        }
	        else if (GetPlayerVirtualWorld(playerid) == 2)
	        {
	        	if (pInfo[playerid][pMember] != FRACTION_LS_NEWS) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	        	ShowPlayerDialog(playerid, D_NEWS_PANEL_4, DIALOG_STYLE_LIST, "[ NEWS MENU ]", "[0] Прямой эфир\n[1] Выйти из прямого эфира\n[2] Начать принимать звонки / смс\n[3] Завершить принимать звонки / смс\n[4] Объявления\n[5] Банк\n[6] Раздел лидера", "Выбрать", "Закрыть");
	        }
	        else if (GetPlayerVirtualWorld(playerid) == 3)
	        {
	        	if (pInfo[playerid][pMember] != FRACTION_LV_NEWS) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	        	ShowPlayerDialog(playerid, D_NEWS_PANEL_4, DIALOG_STYLE_LIST, "[ NEWS MENU ]", "[0] Прямой эфир\n[1] Выйти из прямого эфира\n[2] Начать принимать звонки / смс\n[3] Завершить принимать звонки / смс\n[4] Объявления\n[5] Банк\n[6] Раздел лидера", "Выбрать", "Закрыть");
	        }
	        else SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	    }
	    else SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
    }
	return 1;
}
	
	
alias:npanel("n");
CMD:live(playerid, params[])//OPT
{
    if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
    if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /live [id/name]");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (IsPlayerInRangeOfPlayer(5.0, playerid, params[0])){} else { SendClientMessage(playerid, COLOR_GREY, !"Человек далеко от вас!"); return 1; }
    new V_IDX = GetPlayerVehicleID(playerid),
		string_[128];
    if (V_IDX != 0)
    {
	    if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == 9 || VehicleInfo[ V_IDX - 1 ][vFraction] == 16 || VehicleInfo[ V_IDX - 1 ][vFraction] == 20) )
	    {
	        if (pInfo[playerid][pMember] == 9)
	        {
	            if (TalkingLive[playerid] != 255)
				{
					SendClientMessage(playerid, 0x6495EDFF, !"Прямой эфир завершён");
					SendClientMessage(TalkingLive[playerid], 0x6495EDFF, !"Прямой эфир завершён");
					TogglePlayerControllable(playerid, 1);
					TogglePlayerControllable(TalkingLive[playerid], 1);
					TalkingLive[TalkingLive[playerid]] = 255;
					TalkingLive[playerid] = 255;
					return 1;
				}
				format(string_, sizeof(string_), "Вы предложили %s снять интервью",pInfo[params[0]][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				format(string_, sizeof(string_), "%s предлагает вам снять интервью",pInfo[playerid][pName]);
				SendClientMessage(params[0], 0x6495EDFF, string_);
				SendClientMessage(params[0], COLOR_WHITE, !"Введите /accept livesf, чтобы согласиться");
				LiveOffer[params[0]] = playerid;
	        }
	        else if (pInfo[playerid][pMember] == 16)
	        {
	            if (TalkingLivels[playerid] != 255)
				{
					SendClientMessage(playerid, 0x6495EDFF, !"Прямой эфир завершён");
					SendClientMessage(TalkingLivels[playerid], 0x6495EDFF, !"Прямой эфир завершён");
					TogglePlayerControllable(playerid, 1);
					TogglePlayerControllable(TalkingLivels[playerid], 1);
					TalkingLivels[TalkingLivels[playerid]] = 255;
					TalkingLivels[playerid] = 255;
					return 1;
				}
				format(string_, sizeof(string_), "Вы предложили %s снять интервью",pInfo[params[0]][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				format(string_, sizeof(string_), "%s предлагает вам снять интервью",pInfo[playerid][pName]);
				SendClientMessage(params[0], 0x6495EDFF, string_);
				SendClientMessage(params[0], COLOR_WHITE, !"Введите /accept livels, чтобы согласиться");
				LiveOfferls[params[0]] = playerid;
	        }
	        else if (pInfo[playerid][pMember] == 20)
	        {
	            if (TalkingLivelv[playerid] != 255)
				{
					SendClientMessage(playerid, 0x6495EDFF, !"Прямой эфир завершён");
					SendClientMessage(TalkingLivelv[playerid], 0x6495EDFF, !"Прямой эфир завершён");
					TogglePlayerControllable(playerid, 1);
					TogglePlayerControllable(TalkingLivelv[playerid], 1);
					TalkingLivelv[TalkingLivelv[playerid]] = 255;
					TalkingLivelv[playerid] = 255;
					return 1;
				}
				format(string_, sizeof(string_), "Вы предложили %s снять интервью",pInfo[params[0]][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				format(string_, sizeof(string_), "%s предлагает вам снять интервью",pInfo[playerid][pName]);
				SendClientMessage(params[0], 0x6495EDFF, string_);
				SendClientMessage(params[0], COLOR_WHITE, !"Введите /accept livelv, чтобы согласиться");
				LiveOfferlv[params[0]] = playerid;
	        }
	    }
	}
	else
	{
    	if (IsPlayerInRangeOfPoint(playerid, 10.0,1376.7966,-30.4065,1000.9265))
	    {
	        if (GetPlayerVirtualWorld(playerid) == 1)
	        {
	            if (TalkingLive[playerid] != 255)
				{
					SendClientMessage(playerid, 0x6495EDFF, !"Прямой эфир завершён");
					SendClientMessage(TalkingLive[playerid], 0x6495EDFF, !"Прямой эфир завершён");
					TogglePlayerControllable(playerid, 1);
					TogglePlayerControllable(TalkingLive[playerid], 1);
					TalkingLive[TalkingLive[playerid]] = 255;
					TalkingLive[playerid] = 255;
					return 1;
				}
				format(string_, sizeof(string_), "Вы предложили %s снять интервью",pInfo[params[0]][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				format(string_, sizeof(string_), "%s предлагает вам снять интервью",pInfo[playerid][pName]);
				SendClientMessage(params[0], 0x6495EDFF, string_);
				SendClientMessage(params[0], COLOR_WHITE, !"Введите /accept livesf, чтобы согласиться");
				LiveOffer[params[0]] = playerid;
	        }
	        else if (GetPlayerVirtualWorld(playerid) == 2)
	        {
	            if (TalkingLivels[playerid] != 255)
				{
					SendClientMessage(playerid, 0x6495EDFF, !"Прямой эфир завершён");
					SendClientMessage(TalkingLivels[playerid], 0x6495EDFF, !"Прямой эфир завершён");
					TogglePlayerControllable(playerid, 1);
					TogglePlayerControllable(TalkingLivels[playerid], 1);
					TalkingLivels[TalkingLivels[playerid]] = 255;
					TalkingLivels[playerid] = 255;
					return 1;
				}
				format(string_, sizeof(string_), "Вы предложили %s снять интервью",pInfo[params[0]][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				format(string_, sizeof(string_), "%s предлагает вам снять интервью",pInfo[playerid][pName]);
				SendClientMessage(params[0], 0x6495EDFF, string_);
				SendClientMessage(params[0], COLOR_WHITE, !"Введите /accept livels, чтобы согласиться");
				LiveOfferls[params[0]] = playerid;
	        }
	        else if (GetPlayerVirtualWorld(playerid) == 3)
	        {
	            if (TalkingLivelv[playerid] != 255)
				{
					SendClientMessage(playerid, 0x6495EDFF, !"Прямой эфир завершён");
					SendClientMessage(TalkingLivelv[playerid], 0x6495EDFF, !"Прямой эфир завершён");
					TogglePlayerControllable(playerid, 1);
					TogglePlayerControllable(TalkingLivelv[playerid], 1);
					TalkingLivelv[TalkingLivelv[playerid]] = 255;
					TalkingLivelv[playerid] = 255;
					return 1;
				}
				format(string_, sizeof(string_), "Вы предложили %s снять интервью",pInfo[params[0]][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				format(string_, sizeof(string_), "%s предлагает вам снять интервью",pInfo[playerid][pName]);
				SendClientMessage(params[0], 0x6495EDFF, string_);
				SendClientMessage(params[0], COLOR_WHITE, !"Введите /accept livelv, чтобы согласиться");
				LiveOfferlv[params[0]] = playerid;
	        }
	        else SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
	    }
	    else SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в репортёрской машине / вертолёте / офисе!");
    }
	return 1;
}

CMD:quitjob(playerid, params[])
{
    /*if (pInfo[playerid][pJob] == 10 && avtocar[playerid] > 0)
	{
		pInfo[playerid][pSkilla]--;
		SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
	}*/
    if (pInfo[playerid][pJob] == 8)
    { 
		PlayerLeaveCollector(playerid);
    }
    LeavePlayerTaxi(playerid);
    pInfo[playerid][pJob] = 0;
	return SendClientMessage(playerid, COLOR_GREY, !"Вы уволились с работы");
}  	
/*CMD:testgetid(playerid) {
	new	
		war_id = GetCaptureID();
	if (war_id != -1) {
		setCaptureFreeID[war_id] = pInfo[playerid][pMember];
		SendMes(playerid, -1, "War id: %d, Member %d", war_id, setCaptureFreeID[war_id]);
	}
	else {
		SendClientMessage(playerid, -1, "Сейчас идут войны!");
	}
	return 1;
}*/
CMD:timecapture(playerid) {
	new band = capture_band(pInfo[playerid][pMember]);
	if (band == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, !"Данная команда Вам {EB6B56}недоступна."); 
	if (capture_start[band] > 0)
	{
		new gang_was_already_at_war[64];
		format(gang_was_already_at_war, sizeof gang_was_already_at_war, "Данная команда станет доступна через {EB6B56}%s.",
			capture_start[band] == 2 ? "2 часа" : "1 час");
		return SendClientMessage(playerid, CGRAY2, gang_was_already_at_war);
	} 
	return 1;
}
stock CoolDownHourCapture() {
	new
		cooldown = SystemConfig[gCaptureEveryOneHour];
	gettime(hour, _, _);
	if (hour > 0 && hour < 10) {
		cooldown = 2;
	}
	if (SystemConfig[gCaptureEveryOneHour] != 2) {
		cooldown = 1;
	}
	return cooldown;
} 
CMD:capture(playerid)
{
	if (!IsAGang(playerid)) return SendClientMessage(playerid, COLOR_WHITE, !"Данная команда Вам {EB6B56}недоступна.");
	new band = capture_band(pInfo[playerid][pMember]);
	if (band == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, !"Данная команда Вам {EB6B56}недоступна.");
	if (!SystemConfig[gCaptureOnlyDay][0]) {
		gettime(hour, _, _);
		if (hour >= 1 && hour < 7) 
			return SendClientMessage(playerid, COLOR_WHITE, !"Во время с {EB6B56}01:00 {FFFFFF}до {EB6B56}07:00 {FFFFFF}утра захват территории {EB6B56}невозможен.");
	}
	if (pInfo[playerid][pRank] < 7)
	    return SendClientMessage(playerid, COLOR_WHITE, !"Вам недоступна {EB6B56}данная команда.");
	if (capture_start[band] > 0)
	{
		new gang_was_already_at_war[64];
		format(gang_was_already_at_war, sizeof gang_was_already_at_war, "Данная команда станет доступна через {EB6B56}%s.",
			capture_start[band] == 2 ? "2 часа" : "1 час");

		return SendClientMessage(playerid, CGRAY2, gang_was_already_at_war);
	}

	if(capture_fix > gettime()) return  SendClientMessage(playerid, CGRAY2, !"Данная команда станет доступна через пару секунд");

    if (fInfo[ pInfo[playerid][pMember] ][fFreeze] == 1) return SendClientMessage(playerid, COLOR_WHITE, !"Вашей организации запрещено {EB6B56}воевать за территорию.");
	new Float:xxp,Float:yyp,Float:zzp,i = -1;
    GetPlayerPos(playerid, xxp, yyp, zzp);
    for(new x = 1; x <= TOTALGZ; x++)
    {
        if ((xxp <= GZInfo[x][gCoords][2] && xxp >= GZInfo[x][gCoords][0]) && (yyp <= GZInfo[x][gCoords][3] && yyp >= GZInfo[x][gCoords][1])) {
		    i = x;
		    break;
		}
	}
	if (i == -1) return SendClientMessage(playerid, COLOR_WHITE, !"Захват {EB6B56}невозможен.");
	if (GZInfo[i][gID] == 47 || GZInfo[i][gID] == 57 || GZInfo[i][gID] == 35  || GZInfo[i][gID] == 34 || GZInfo[i][gID] == 18 || GZInfo[i][gID] == 19 || GZInfo[i][gID] == 59 || GZInfo[i][gID] == 60 || GZInfo[i][gID] == 1) 
		return SendClientMessage(playerid, COLOR_WHITE, !"Данная территория прилегает к респавну, {EB6B56}захват запрещен.");
	if (pInfo[playerid][pMember] == GZInfo[i][gFrakVlad]) return SendClientMessage(playerid, COLOR_WHITE, !"Нельзя захватить {EB6B56}собственную территорию.");
	band = capture_band(GZInfo[i][gFrakVlad]);
	if (crimeDiplomation[capture_band(pInfo[playerid][pMember])][band] == sDIP_ALLIANCE) return SendClientMessage(playerid, COLOR_LI_RED, !"[Дипломатия] "colwhi"С данной бандой заключен союз");
	if (fInfo[ GZInfo[i][gFrakVlad] ][fFreeze] == 1) return SendClientMessage(playerid, COLOR_WHITE, !"Захват невозможен, банда подписала {EB6B56}нейтралитет.");
	if (band == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, !"Территория принадлежит {EB6B56}государству.");
	if (capture_start[band] > 0) return SendClientMessage(playerid, COLOR_WHITE, !"Банда истощена, захват {EB6B56}невозможен.");
    //if(IsPlayerInBandOnline(pInfo[playerid][pMember]) < 3) return SendClientMessage(playerid, COLOR_WHITE, !"{EB6B56}В Вашей банде нет трех человек!");//тест капта
    if(IsPlayerInBandOnline(GZInfo[i][gFrakVlad]) < 1) return SCM(playerid,COLOR_WHITE, !"Банда на которую вы собираетесь напасть нет в сети!");
	capture_start[capture_band(pInfo[playerid][pMember])] = CoolDownHourCapture();
	capture_start[band] = CoolDownHourCapture();


	new str_refill_zone[28];
	GetPlayer2DZone(playerid,str_refill_zone,sizeof(str_refill_zone));
//
	new string_[144];
	format(string_, sizeof string_, "[Внимание]: %s спровоцировала войну с %s. Инициатор: %s[%d]", name_band[capture_band(pInfo[playerid][pMember])], name_band[band], pInfo[playerid][pName], playerid); 
	SendFamilyMessage(pInfo[playerid][pMember], 0x00cc44FF, string_); 
	SendFamilyMessage(GZInfo[i][gFrakVlad], 0x00cc44FF, string_); 

	format(string_,sizeof(string_),"[Оповещение]: %s (%s) {FFFFFF}инициировал захват территории {FFFFFF}против банды {EB6B56}%s.",pInfo[playerid][pName],
	name_band[capture_band(pInfo[playerid][pMember])],name_band[band]);
	SendAdminMessage(COLOR_LI_RED, string_); 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][0] = 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][1] = 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][2] = 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][3] = 0; 
	FractionInfo[ GZInfo[i][gFrakVlad]] [fViolation][0] = 
	FractionInfo[ GZInfo[i][gFrakVlad]] [fViolation][1] = 
	FractionInfo[ GZInfo[i][gFrakVlad]] [fViolation][2] = 
	FractionInfo[ GZInfo[i][gFrakVlad]] [fViolation][3] = 0; 
    new query_[128];
	mysql_format(dbHandle, query_,sizeof query_,"UPDATE s_users SET CaptureStart = CaptureStart + 1 WHERE pID = '%e' LIMIT 1", pInfo[playerid][pID]);
	mysql_tquery(dbHandle, query_, "", "");

	GiveFractionRepute(pInfo[playerid][pMember], 5);
	new	
		gangwar_id = GetCaptureID();
	setCaptureFreeID[gangwar_id] = pInfo[playerid][pMember];
	GZInfo[i][gTD] = gangwar_id;
	//
	GZInfo[i][gNapad] = pInfo[playerid][pMember]; 
	OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_CAPTURE);

	if (Iter_Count(PlayerTeam[GZInfo[i][gFrakVlad]]) == 0) {
	    SendFamilyMessage(pInfo[playerid][pMember], COLOR_WHITE, !"{EB6B56}[Внимание]: {FFFFFF}Вы устранили врага, и взяли под свой контроль {EB6B56}данную территорию.");
	    GZInfo[i][gFrakVlad] = pInfo[playerid][pMember];
		setCaptureFreeID[gangwar_id] = -1;
	    SaveGangZone(i); 
	    return 1;
	}
	GZInfo[i][gCaptureArea] = CreateDynamicRectangle(GZInfo[i][gCoords][0], GZInfo[i][gCoords][1],GZInfo[i][gCoords][2],GZInfo[i][gCoords][3], 0, 0);
	SetDynamicAreaType(GZInfo[i][gCaptureArea], AREA_TYPE_CAPTURE, gangwar_id);
	#if defined _capture_stats_inc
		if (CAPTURE_STATS_ENABLED) {
			//new capture_id = GetFreeCaptureID();
			new capture_id = gangwar_id;
			if (capture_id != -1) {
				captureid_slots[capture_id] = pInfo[playerid][pMember];
				capture_gangs[capture_id][0] = pInfo[playerid][pMember];
				capture_gangs[capture_id][1] = GZInfo[i][gFrakVlad];

				if (capture_band(capture_gangs[capture_id][0]) < sizeof (capture_band_captureid))
					capture_band_captureid[capture_band(capture_gangs[capture_id][0])] = capture_id;
				if (capture_band(capture_gangs[capture_id][1]) < sizeof (capture_band_captureid))
					capture_band_captureid[capture_band(capture_gangs[capture_id][1])] = capture_id;
			}
			/*printf("new capture_id = GetFreeCaptureID(=%d) capture_band[%d | %d]", capture_id, 
				capture_band(capture_gangs[capture_id][0]), capture_band(capture_gangs[capture_id][1])
			);*/

			OnCaptureStart(capture_id);
		}
	#endif
	capture_kills[ capture_band(pInfo[playerid][pMember]) ] = 0;
	capture_kills[band] = 0;
	capture_kills_need[ capture_band( pInfo[playerid][pMember] ) ] = Iter_Count(PlayerTeam[pInfo[playerid][pMember]])*3;
	capture_kills_need[band] = Iter_Count(PlayerTeam[GZInfo[i][gFrakVlad]])*3;
	capture_now[ capture_band( pInfo[playerid][pMember] )] = i+1;
	capture_now[band] = i+1;

	GangZoneFlashForAll(GZInfo[i][gZone], GetGZColorF(pInfo[playerid][pMember]));

	GZInfo[i][gCaptureTime] = capture_timer;
	GZInfo[i][gCaptureOverTime] = 0;
	GZInfo[i][gTimer] = SetTimerEx("GzCheck",1000, true, "iii", i, pInfo[playerid][pMember], GZInfo[i][gFrakVlad]); 
    SetStringMainTextDrawCapture(i);
    UpdateSeconds(i);
    UpdateKillsCapture(i); 
	foreach(new idx: PlayerTeam[pInfo[playerid][pMember]]) { 
        ShowTextDrawCapture(idx, gangwar_id);
	    SetPlayerColor(idx,gFractionColor[pInfo[idx][pMember]]); 
	    
	} 
	foreach(new idx: PlayerTeam[GZInfo[i][gFrakVlad]]) { 
        ShowTextDrawCapture(idx, gangwar_id);
	    SetPlayerColor(idx,gFractionColor[pInfo[idx][pMember]]); 
	}
	return 1;
}

CMD:to(playerid,params[])
{
	if (isnull(params) || strlen(params) > 3) return SendClientMessage(playerid,-1,!"Введите: /to [id игрока]");
	if (GetPlayerTaxi{playerid} != 1) return SendClientMessage(playerid, COLOR_GREY, !"Вам не доступна эта команда");
	new id = strval(params);
	if (!PlayerInConnected(id) || id == playerid) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен / Вы указали свой ID");

    for(new i; i < 3; i++) // в случаи если сбилась метка
    {
        if (pTemp[playerid][pTaxiCalled][i] == id){
            goto gps_passanger;
            break;
        }
    }

    if (!GetPVarInt(id,!"call_taxi")) return SendClientMessage(playerid,CGRAY2,!"Игрок не вызывал такси или его вызов уже приняли");

    new to_yes = -1,max_passanger;
    if (pInfo[playerid][pTaxiLevel] < 3) max_passanger = 1;
    else if (pInfo[playerid][pTaxiLevel] < 8) max_passanger = 2;
    else max_passanger = 3;

    for(new i; i < max_passanger; i++)
    {
        printf("[%d] pTemp[playerid][pTaxiCalled][i] (%d) == INVALID_PLAYER_ID (%d) | max_passanger %d",i, pTemp[playerid][pTaxiCalled][i],INVALID_PLAYER_ID, max_passanger);
        if (pTemp[playerid][pTaxiCalled][i] == INVALID_PLAYER_ID){
            to_yes = i;
            pTemp[playerid][pTaxiCalled][i] = id;
            break;
        }
    }
    if (to_yes == -1) return SendClientMessage(playerid,CGRAY2,!"Прокачайте уровень таксиста, что бы принимать несколько заказов одновременно");

    DeletePVar(id,!"call_taxi");
    pTemp[id][pTaxiDriver] = playerid;
	new str_fmt_call_ok[65+(MAX_PLAYER_NAME*2)];
	
    format(str_fmt_call_ok,98,"Работник таксопарка %s принял вызов от клиента %s",pInfo[playerid][pName],pInfo[id][pName]);
    foreach(JobTaxi,i)
    {
        SendClientMessage(i,0xF7EA6EFF,str_fmt_call_ok);
    }
    format(str_fmt_call_ok,98,"Работник таксопарка %s принял Ваш вызов",pInfo[playerid][pName]);
    SendClientMessage(id,0xF7EA6EFF,str_fmt_call_ok);

    gps_passanger:
    new
		Float:x,
		Float:y,
		Float:z;
	GetPlayerPos(id,x,y,z);
	CP[playerid] = 777;
	SetPlayerCheckpoint(playerid,x,y,z,12.0);

	SendClientMessage(playerid,-1,!"Местоположение игрока отмечено на GPS {FF0000}красной меткой");
	return 1;
}


CMD:fare(playerid)
{
    if (pInfo[playerid][pJob] != PLAYER_JOB_TAXI) return 1;
	new 
		V_IDX = GetPlayerVehicleID(playerid);
	if (V_IDX != pTemp[playerid][pRentCar]) return SendClientMessage(playerid, COLOR_GREY, !"Это не ваш автомобиль");
	if (V_IDX == INVALID_VEHICLE_ID) return 1;
	if (VehicleInfo[ V_IDX - 1 ] [vType] != VEHICLE_TYPE_JOB || VehicleInfo [ V_IDX - 1 ] [vFraction] != PLAYER_JOB_TAXI) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в служебном транспорте!");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем автомобиля!");
	if (GetPlayerTaxi{playerid} == 1) {
		LeavePlayerTaxi(playerid);
        SendClientMessage(playerid, 0x6BB3FFAA, !"Рабочий день окончен");
		return 1;
	}
    InvitePlayerTaxi(playerid);
    SendClientMessage(playerid, 0x6BB3FFAA, !"Рабочий день начат");
	return 1;
}


CMD:question(playerid, params[])
{
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /question(/ask) [текст]");
	if (GetPVarInt(playerid, "report_id")) return SendClientMessage(playerid, COLOR_GREY, !"Сначала дождитесь ответа на Ваше последнее обращение в репорт.");
	if (SupportInfo[playerid][sDuty]) 
				return SendClientMessage (playerid, COLOR_GREY,"Нельзя писать в /ask Если вы саппорт");
	if (pInfo[playerid][rMuted] != 0) return SendClientMessage(playerid, COLOR_GREY, !"У Вас бан репорта!");
	new
		string[168],
		string_[145];

	if (Iter_Count(SupportsTeam) != 0) {
		format(string_, sizeof string_, "Вопрос от %s[%d]:{ffffff} %s", pInfo[playerid][pName], playerid, params);
		SendHelperMessage(0xFFA500FF, string_);
		GameTextForSupport("ASK++~n~/(ti)ckets");
	}
	else {
		for(new i = 1; i < MAX_REPORT_SLOTS; i++)
		{
			if (aReportInfo[i][rPlayerID] != -1) continue;
			aReportInfo[i][rIsTooked] = false;
			aReportInfo[i][rID] = i;
			aReportInfo[i][rType] = TICKETS_TYPE_REPORT;
			aReportInfo[i][rPlayerID] = playerid;
			format(string, sizeof string, "%s", params);
			strmid(aReportInfo[i][rText], string, 0, 116, 116);
			aReportInfo[i][rWhenWroted_Time] = gettime();
			gettime(hour, minute, second);
			format(string, sizeof string, "%02d:%02d:%02d", hour, minute, second);
			strmid(aReportInfo[i][rWhenWroted_Text], string, 0, 10, 10);
			SetPVarInt(playerid, "report_id", i + 1);
			break;
		}
		SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещение] "colwhi"В данный момент нету не одного саппорта в сети, вопрос отправлен администрации.");
	}

	SendMes(playerid, COLOR_GREEN, "Ваше обращение:{FFFFFF} %s", params);

	for(new i = 1; i < MAX_REPORT_SLOTS; i++)
	{
		if (aReportInfo[i][rPlayerID] != -1) continue;
		aReportInfo[i][rIsTooked] = false;
		aReportInfo[i][rID] = i; 
		aReportInfo[i][rType] = TICKETS_TYPE_ASK;
		aReportInfo[i][rPlayerID] = playerid;
		format(string, sizeof string, "%s", params);
		strmid(aReportInfo[i][rText], string, 0, 116, 116);
		aReportInfo[i][rWhenWroted_Time] = gettime();
		gettime(hour, minute, second);
		format(string, sizeof string, "%02d:%02d:%02d", hour, minute, second);
		strmid(aReportInfo[i][rWhenWroted_Text], string, 0, 10, 10);
		SetPVarInt(playerid, "report_id", i + 1);
		break;
	}
	return 1;
}

alias:question("ask");

CMD:dmexit(playerid) {
	if (pTemp[playerid][tDMArea][0]) 
	{
		if (IsPlayerDying(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент Вы не можете использовать данную команду");
	    SetPlayerPosAC(playerid, 2029.2552, -1776.8894,1323.5253, 1, DUEL_HOLL_LOBBY);
		SetPlayerFacingAngle(playerid, 271.6136);
		if (pTemp[playerid][tDMLabel]) {
  			DestroyDynamic3DTextLabel(pTemp[playerid][tDMLabel]);
			pTemp[playerid][tDMLabel] = Text3D:0;
		} 
		PlayerTextDrawHide(playerid, DmArenaTextDraw[playerid]);
		new 
			query_[156];
		if (pTemp[playerid][tDMArea][3] == 1) {
			format(query_, sizeof query_, "UPDATE `s_users` SET a1Kills = a1Kills + '%d', a1Death = a1Death + '%d'  WHERE pID = '%d'", 
				pTemp[playerid][tDMArea][1], pTemp[playerid][tDMArea][2], pInfo[playerid][pID]
			);
			mysql_tquery(dbHandle, query_, "", "");
		} 
		if (pTemp[playerid][tDMArea][3] == 2) {
			format(query_, sizeof query_, "UPDATE `s_users` SET a2Kills = a2Kills + '%d', a2Death = a2Death + '%d'  WHERE pID = '%d'", 
				pTemp[playerid][tDMArea][1], pTemp[playerid][tDMArea][2], pInfo[playerid][pID]
			);
			mysql_tquery(dbHandle, query_, "", "");
		} 
		if (pTemp[playerid][tDMArea][3] == 3) {
			format(query_, sizeof query_, "UPDATE `s_users` SET a3Kills = a3Kills + '%d', a3Death = a3Death + '%d'  WHERE pID = '%d'", 
				pTemp[playerid][tDMArea][1], pTemp[playerid][tDMArea][2], pInfo[playerid][pID]
			);
			mysql_tquery(dbHandle, query_, "", "");
		} 
		pTemp[playerid][tDMArea][0] = 0;
		pTemp[playerid][tDMArea][1] = 0;
		pTemp[playerid][tDMArea][2] = 0;
		pTemp[playerid][tDMArea][3] = 0;
		pTemp[playerid][tDMArea][4] = 0; 
		pTemp[playerid][tSeriasKilled] = 0;
		SetPlayerColor(playerid, gFractionColor[pInfo[playerid][pMember]]);
		SetPlayerSkinEx(playerid, pInfo[playerid][pModel]);
		ResetPlayerWeapons(playerid);
	} 
	return 1;
}

//GANG
publics: AddictionTimer(playerid) return SetPlayerWeather(playerid,10);
CMD:usedrugs(playerid, params[])
{
    if (pTemp[playerid][tPaintTeam] != 0 || IsPlayerInDuel(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на дуэлях / PB");
	if (pTemp[playerid][tDMArea][0]) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на ДМ-Арене");
	if (IsAMafia(playerid) || IsAGosFraction(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать в вашей организаций.");
	if(sscanf(params, "d", params[0]))
	{
		if(pInfo[playerid][pAddiction] < 2000) params[0] = 5;
		else if(pInfo[playerid][pAddiction] < 5000) params[0] = 10;
		else if(pInfo[playerid][pAddiction] > 5000) params[0] = 15;
	}
	new Float:health;
	new string_[128], query_[128];
	GetPlayerHealth(playerid, health);
	if(pInfo[playerid][pDrugs] < params[0]) return err(!"[Ошибка]: {ffffff}Недостаточно наркотиков");
	if(params[0] < 1) return SendClientMessage(playerid, COLOR_WHITE, "Введите: /usedrugs [кол-во]");
	if(pInfo[playerid][pAddiction] < 2000 && params[0] > 5) return SendClientMessage(playerid,COLOR_GRAD1,"Не более 5 грамм");
	else if(pInfo[playerid][pAddiction] < 5000 && params[0] > 10) return SendClientMessage(playerid,COLOR_GRAD1,"Не более 10 грамм");
	else if(params[0] > 15) return SendClientMessage(playerid,COLOR_GRAD1,"Не более 15 грамм");
	if(pInfo[playerid][pAddiction] < 2000 && health+ 10.0*params[0] > 120)
	{
	    if(pTemp[playerid][PlayerTimeDrugsCD] <= gettime()){
			SendClientMessage(playerid,COLOR_WHITE, !"(( Здоровье пополнено до: 120 ))");
			SetPlayerHealth(playerid,120);
		}
		SetPlayerTime(playerid,17,0);
		SetPlayerWeather(playerid, -67);
	 	SetTimerEx("AddictionTimer", 10000, false, "i", playerid);
	}
	else if(pInfo[playerid][pAddiction] < 5000 && health+ 10.0*params[0] > 140)
	{
	    if(pTemp[playerid][PlayerTimeDrugsCD] <= gettime()){
			SendClientMessage(playerid,COLOR_WHITE, !"(( Здоровье пополнено до: 140 ))");
			SetPlayerHealth(playerid,140);
		}
	}
	else if(pInfo[playerid][pAddiction] >= 5000 && health+10.0*params[0] > 160)
	{
	    if(pTemp[playerid][PlayerTimeDrugsCD] <= gettime()){
			SendClientMessage(playerid,COLOR_WHITE, !"(( Здоровье пополнено до: 160 ))");
			SetPlayerHealth(playerid,160);
		}
	}
	else
	{
	    if(pTemp[playerid][PlayerTimeDrugsCD] <= gettime()){
			SendMes(playerid,COLOR_WHITE, "(( Здоровье пополнено до: %.0f ))",health+10*params[0]);
			SetPlayerHealth(playerid, health + 10.0*params[0]);
		}
		if(pInfo[playerid][pAddiction] < 2000)
		{
			SetPlayerTime(playerid,17,0);
			SetPlayerWeather(playerid, -68);
			SetTimerEx("AddictionTimer", 10000, false, "i", playerid);
		}
	}
	pInfo[playerid][pNarcoLomka] = 0;
	if(pTemp[playerid][PlayerTimeDrugsCD] <= gettime())
		pTemp[playerid][PlayerTimeDrugsCD] = gettime() + 60;
	pInfo[playerid][pDrugs] -= params[0];
	SendMes(playerid, COLOR_WHITE,"(( Осталось наркотиков: %d ))", pInfo[playerid][pDrugs]);
	ApplyAnimation(playerid,"SMOKING","M_smk_drag",4.1,0,0,0,0,0,1);
	SetPVarInt(playerid, "ClearAnimSI", gettime()+4);
	SetPlayerChatBubble(playerid,"употребил(a) наркотик",COLOR_PURPLE,30.0,10000);
	format(string_, sizeof string_, "%s употребил(a) наркотик",pInfo[playerid][pName]);
	SendBeside(playerid,COLOR_PURPLE,string_,10.0);
	pInfo[playerid][pAddiction] = pInfo[playerid][pAddiction] >= 5000 ? 5000 : pInfo[playerid][pAddiction] + 4 * params[0];
	if(pTemp[playerid][StartAddiction])
	{
		pTemp[playerid][StartAddiction] = false;
		ApplyAnimation(playerid, !"SMOKING", !"M_smk_drag", 3.59, 0, 1, 1, 0, 0, 1);
		pTemp[playerid][tTimeAddiction] = gettime()+10800;
	}
	format(query_, sizeof(query_), "UPDATE `s_users` SET `pNarcoLomka` = '%d', `pAddiction` = '%d', `pDrugs` = '%d' WHERE `Name` = '%s'", pInfo[playerid][pNarcoLomka], pInfo[playerid][pAddiction], pInfo[playerid][pDrugs], pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	return 1;
}
CMD:healme(playerid)
{
    for(new i = 1; i <= TOTALHOUSE; i++)
	{
	    new idx = HouseInfo[i][hIntID];
		if(!PlayerToPoint(5, playerid,HouseInt[idx][hIntPos], HouseInt[idx][hIntPos], HouseInt[idx][hIntPos])) continue;
		if(GetPlayerVirtualWorld(playerid) != i+50) continue;
		if(HouseInfo[i][hHel] == 0)return SendClientMessage(playerid, COLOR_GRAD1, !"В этом месте нет аптечек");
		if(pTemp[playerid][TempUseHealth] >= 10) return err(!"[Ошибка]: {ffffff} Только 10 штук в час!");
		if (GetPlayerHP(playerid) >= 100) return SendClientMessage(playerid, COLOR_GREY, !"Вы здоровы");
		SendClientMessage(playerid, COLOR_WHITE, !"Вы были вылечены на 25 процентов");
		SendMes(playerid, COLOR_BLUE, "Осталось %d аптечек", HouseInfo[i][hHel]-1);
		HouseInfo[i][hHel] -= 1;
		new query_[128];
		format(query_, sizeof(query_), "UPDATE `house` SET `hHel`= '%d' WHERE `hID` = '%d'", HouseInfo[i][hHel], HouseInfo[i][hID]);
 		mysql_tquery(dbHandle, query_, "", "");
		SetPlayerHealth(playerid, pInfo[playerid][PlayerHealth] + 25.0);
		if(pInfo[playerid][PlayerHealth] > 100) SetPlayerHealth(playerid, 100.0);
		SetPlayerChatBubble(playerid, "использовал(а) аптечку", COLOR_PURPLE, 30.0, 10000);
		pTemp[playerid][TempUseHealth] ++;
		return 1;
	}
	if(IsAMedKit(playerid))
	{
	    if(!IsAGang(playerid) && !IsAMafia(playerid)) return 1;
		new fraction_ = pInfo[playerid][pMember];
		if(FractionInfo[fraction_][fHeal] <= 0) return SendClientMessage(playerid, COLOR_GRAD1, !"На базе нет аптечек");
		if (GetPlayerHP(playerid) >= 100) return SendClientMessage(playerid, COLOR_GREY, !"Вы здоровы");
		SendClientMessage(playerid, COLOR_WHITE, !"Вы были вылечены на 25 процентов");
		FractionInfo[fraction_][fHeal]--;
		SaveFractionInfoID(FractionInfo[fraction_][fID]);
		SendMes(playerid, COLOR_BLUE, "Осталось %d аптечек", FractionInfo[fraction_][fHeal]);
		SetPlayerHealth(playerid, pInfo[playerid][PlayerHealth] + 25.0);
		if(pInfo[playerid][PlayerHealth] > 100) SetPlayerHealth(playerid, 100.0);
		return SetPlayerChatBubble(playerid, "использовал(а) аптечку", COLOR_PURPLE, 30.0, 10000);
	}
	else
	{
		if(pInfo[playerid][sAptechka] <= 0) return err(!"[Ошибка]: {ffffff}У Вас нет аптечек! Совершить покупку можно в магазине 24/7");
		if (GetPlayerHP(playerid) >= 100) return SendClientMessage(playerid, COLOR_GREY, !"Вы здоровы");
		SendClientMessage(playerid, COLOR_WHITE, !"Вы были вылечены на 50 процентов");
		pInfo[playerid][sAptechka]--;
		SendMes(playerid, COLOR_BLUE, "Осталось %d аптечек", pInfo[playerid][sAptechka]);
		ApplyAnimation(playerid,"BAR","dnK_StndM_loop",4.1,0,0,0,0,0,1);
		SetPVarInt(playerid, "ClearAnimSI", gettime()+4);
		SetPlayerHealth(playerid, pInfo[playerid][PlayerHealth] += 50);
		if(pInfo[playerid][PlayerHealth] > 100) SetPlayerHealth(playerid, 100.0);
		return SetPlayerChatBubble(playerid, "использовал(а) аптечку", COLOR_PURPLE, 30.0, 10000);
	}
}

CMD:hfm(playerid,params[])
{
	//if ( GetString( CreativeMedia[hDj], pInfo[playerid][pName] ) )

	if(pTemp[playerid][tRadioHost] == 0)  return SendClientMessage(playerid,CGRAY2,!"Вам не доступен этот чат!");

	if (strlen(params[0]) >= 105) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[106]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /hfm [сообщение]");

	static const msg_fm[] = "[Creative FM - %s ]: %s";
	new chat_fm[sizeof(msg_fm)-4+MAX_PLAYER_NAME+88];
	format(chat_fm,sizeof(chat_fm),msg_fm,pInfo[playerid][pName],params[0]);
	SendClientMessageToAll(0x0A8495FF,chat_fm);
	return 1;
}

CMD:nextexp(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params,"d", params[0])) return SendClientMessage(playerid, COLOR_RED, !"В: /nextexp [exp]");
	UpdatePlayerExp(playerid, params[0]);
	return 1;
}

CMD:mafiawar(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || !IsAMafia(playerid) || pInfo[playerid][pRank] < 6) return 1;
    gettime(hour,_,_);
	if (!SystemConfig[gCaptureOnlyDay][1]) {
		if (hour >= 1 && hour < 10)
	    	return SendClientMessage(playerid, COLOR_GREY, !"Стрелы отключены с 01:00 до 10:00 утра!");
	} 
	new 
		band = capture_band(pInfo[playerid][pMember]);
	if (capture_start[band] > 0) { 
		if (capture_start[band] == 2) SendClientMessage(playerid, COLOR_GREY, !"Ваша мафия уже воевала за бизнес. ( Следующий захват через 1 payday )");
		else SendClientMessage(playerid, COLOR_GREY, !"Ваша мафия уже воевала за бизнес.( Следующий захват в payday )");
		return 1;
	} 
	if (fInfo[ pInfo[playerid][pMember] ][fFreeze] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Вашей организации запрещено нападать на бизнес");
	if (capture_fix > gettime()) return  SendClientMessage(playerid, CGRAY2, !"Данная команда станет доступна через пару секунд");
	if (sscanf(params, "d",params[0]) || params[0] < 1 || params[0] > sizeof (MafiaWarZonePos))  
		return scm(playerid, COLOR_WHITE, !"Введите: /mafiawar [id стрелы (1 - Карьер | 2 - Аэропорт | 3 - Деревня | 4 - Стройка)]");
	for (new b = 0; b < sizeof (BusinessInfo); b++) { 
		if (!IsValidBusiness(b)) continue; 
		if (IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[b][bPos][0], BusinessInfo[b][bPos][1], BusinessInfo[b][bPos][2])) 
		{
		    if (BusinessInfo[b][bMafia] == pInfo[playerid][pMember]) return scm(playerid, COLOR_WHITE, !" Этот бизнес под Вашим контролем");
			new 
				string_[128];
		    if (BusinessInfo[b][bMafia] == 0) {
			    //if (strcmp(BusinessInfo[b][bOwner], "None", true) == 0)
			      //  return SendClientMessage(playerid, COLOR_GREY, !"Бизнес на данный момент принадлежит государству - Вы не можете взять его под свой контроль!");
				BusinessInfo[b][bMafia] = pInfo[playerid][pMember]; 
				format(string_, sizeof string_, "bMafia = %i", BusinessInfo[b][bMafia]);
            	SaveBusiness(b, string_); 
				return scm(playerid, COLOR_WHITE, !"Бизнес взят под контроль"), 1; 
			}
			if (crimeDiplomation[capture_band(pInfo[playerid][pMember])][capture_band(BusinessInfo[b][bMafia])] == sDIP_ALLIANCE) return SendClientMessage(playerid, COLOR_LI_RED, !"[Дипломатия] "colwhi"С данной мафией заключен союз");
			if (fInfo[ BusinessInfo[b][bMafia] ][fFreeze] == 1) return SendMes(playerid, COLOR_GREY, "%s запрещено нападать на бизнес", fInfo[ BusinessInfo[b][bMafia] ][fName]);
			if (capture_start[capture_band(BusinessInfo[b][bMafia])] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Мафия, на которую вы хотите напасть уже воевала в этом часу.");
			if (mafia_frac_id[0] != 0) return SendClientMessage(playerid, COLOR_GREY, !"В данное время уже идет война!");//
		  	
			format(string_, sizeof string_, "Вы набили стрелку %s. Бизнес: %s. Место встречи: Территория [ID %d]",name_band[capture_band(BusinessInfo[b][bMafia])], BusinessInfo[b][bName],params[0]);
			SendFamilyMessage(pInfo[playerid][pMember],0x114D71AA, string_);
			SendFamilyMessage(pInfo[playerid][pMember],0x114D71AA, "Встреча через 20 минут");
            format(string_, sizeof string_, "%s набила вам стрелку. Бизнес: %s. Место встречи: Территория [ID %d]",name_band[capture_band(pInfo[playerid][pMember])],BusinessInfo[b][bName],params[0]);
			SendFamilyMessage(BusinessInfo[b][bMafia],COLOR_RED, string_);
			SendFamilyMessage(BusinessInfo[b][bMafia],COLOR_RED, "Встреча через 20 минут");
			format(string_, sizeof string_, "%s %s инициировал(а) захват бизнеса", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName]);
			SendFamilyMessage(pInfo[playerid][pMember], TEAM_AZTECAS_COLOR, string_);
			SendFamilyMessage(BusinessInfo[b][bMafia], TEAM_AZTECAS_COLOR, string_); 
			format(string_, sizeof string_, "Shooter %s (%s) инициировал захват территории в ID: %d против мафии %s", pInfo[playerid][pName],
				name_band[capture_band(pInfo[playerid][pMember])], params[0], name_band[capture_band(BusinessInfo[b][bMafia])]
			);
			SendAdminMessage(0xBEBEBEFF, string_);
			 
			FractionInfo[ pInfo[playerid][pMember] ][fViolation][0] = 
			FractionInfo[ pInfo[playerid][pMember] ][fViolation][1] = 
			FractionInfo[ pInfo[playerid][pMember] ][fViolation][2] = 
			FractionInfo[ pInfo[playerid][pMember] ][fViolation][3] = 0; 

			FractionInfo[ BusinessInfo[b][bMafia] ][fViolation][0] = 
			FractionInfo[ BusinessInfo[b][bMafia] ][fViolation][1] = 
			FractionInfo[ BusinessInfo[b][bMafia] ][fViolation][2] = 
			FractionInfo[ BusinessInfo[b][bMafia] ][fViolation][3] = 0; 
 
			band = capture_band(BusinessInfo[b][bMafia]);
			capture_start[capture_band(pInfo[playerid][pMember])] = 2;
			capture_start[band] = 2;
			ZoneID = params[0];
			mafia_frac_id[0] = pInfo[playerid][pMember];
			mafia_frac_id[1] = BusinessInfo[b][bMafia];
			kills_mafia[0] = 0;
			kills_mafia[1] = 0; 
			ZoneTimer = 1200;
			
            ZoneWar = GangZoneCreate(
				MafiaWarZonePos[ZoneID - 1][0], MafiaWarZonePos[ZoneID - 1][1],
				MafiaWarZonePos[ZoneID - 1][2], MafiaWarZonePos[ZoneID - 1][3]
			);
			GangZoneShowForAll(ZoneWar, 0xB2B2B2AA);
			GangZoneFlashForAll(ZoneWar, COLOR_RED);

			#if defined _capture_stats_inc
				if (CAPTURE_STATS_ENABLED) {
					new capture_id = TYPE_WAR_MAFIA;
					if (capture_id != -1) {
						captureid_slots[capture_id] = pInfo[playerid][pMember];

						capture_gangs[capture_id][0] = pInfo[playerid][pMember];
						capture_gangs[capture_id][1] = BusinessInfo[b][bMafia];

						if (capture_band(capture_gangs[capture_id][0]) < sizeof (capture_band_captureid))
							capture_band_captureid[capture_band(capture_gangs[capture_id][0])] = capture_id;
						if (capture_band(capture_gangs[capture_id][1]) < sizeof (capture_band_captureid))
							capture_band_captureid[capture_band(capture_gangs[capture_id][1])] = capture_id;

						capture_kills[capture_band(capture_gangs[capture_id][0])] = 0;
						capture_kills[capture_band(capture_gangs[capture_id][1])] = 0;
					} 
					OnCaptureStart(capture_id);
				}
			#endif
			MzCheckTimer = SetTimerEx("MzCheck",1000, true, "iii",b, pInfo[playerid][pMember], BusinessInfo[b][bMafia]);
			SetStringMainTextDrawMafiaWar(); 
			UpdateKillsMafiaWar(); 
            foreach(new idx: PlayerTeam[mafia_frac_id[0]]) {
				/*for(new i_ = 0; i_ < 5; i_++) {
					if (!player_mobile[idx]) SendDeathMessageToPlayer(idx,INVALID_PLAYER_ID-1, INVALID_PLAYER_ID-1, 0);
				}*/
				SetPlayerColor(idx, gFractionColor[mafia_frac_id[0]]);
				ShowTextDrawCapture(idx, TYPE_WAR_MAFIA);
	 		}
            foreach(new idx: PlayerTeam[mafia_frac_id[1]]) {
				/*for(new i_ = 0; i_ < 5; i_++) {
					if (!player_mobile[idx]) SendDeathMessageToPlayer(idx,INVALID_PLAYER_ID-1, INVALID_PLAYER_ID-1, 0);
				}*/
				SetPlayerColor(idx, gFractionColor[mafia_frac_id[1]]);
				ShowTextDrawCapture(idx, TYPE_WAR_MAFIA);
	 		}

			OnPlayerQuestProgress(playerid, QUEST_MAFIA, QUEST_TASK_RACKET_BIZ);

	 		break;
		}
	}
	return 1;
}

CMD:bikerswar(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || !IsABiker(playerid) || pInfo[playerid][pRank] < 6) return 1;
    gettime(hour,_,_);
	if (!SystemConfig[gCaptureOnlyDay][2]) {
		if (hour >= 1 && hour < 10)
	    	return SendClientMessage(playerid, COLOR_GREY, !"Войны отключены с 01:00 до 10:00 утра!");
	}  
	new 
		band = capture_band(pInfo[playerid][pMember]);
	if (capture_start[band] > 0) { 
		if (capture_start[band] == 2) SendClientMessage(playerid, COLOR_GREY, !"Ваш клуб уже воевал за крышу семейного дома. ( Следующий захват через 1 payday )");
		else SendClientMessage(playerid, COLOR_GREY, !"Ваш клуб уже воевал за крышу семейного дома.( Следующий захват в payday )");
		return 1;
	} 
	if (sscanf(params, "d",params[0]) || params[0] < 1 || params[0] > sizeof (BikersWarZonePos))  
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /bikerswar [id стрелы (1 - Стоянка | 2 - Деревня | 3 - Склад)]");
	if (fInfo[ pInfo[playerid][pMember] ][fFreeze] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Вашей организации запрещено нападать на семейный дом");
	//if (!pTemp[playerid][tSelectFamilyHouseArea]) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться возле семейного дома!");
	new 
		location_name[][] = {"Стоянка", "Деревня", "Склад"},
		H_IDX = pTemp[playerid][tSelectFamilyHouse],
		string_[128];
	if (FamilyHouse[H_IDX][fhBikers] == pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_WHITE, !"Этот дом под Вашим контролем");
	if (FamilyHouse[H_IDX][fhBikers] == 0) {
		//if (strcmp(FamilyHouse[H_IDX][fhOwner], "None", true) == 0) 
			//return SendClientMessage(playerid, COLOR_GREY, !"Семейный дом на данный момент принадлежит государству - Вы не можете взять его под свой контроль!");
		FamilyHouse[H_IDX][fhBikers] = pInfo[playerid][pMember]; 
		format(t_string, sizeof t_string, "hBikers = '%d'", FamilyHouse[H_IDX][fhBikers]);
		SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS; 
		SendClientMessage(playerid, COLOR_WHITE, !"Семья взята под Ваш контроль");
		return 1; 
	}
	if (fInfo[ FamilyHouse[H_IDX][fhBikers] ][fFreeze] == 1) return SendMes(playerid, COLOR_GREY, "%s запрещено нападать на семейный дома", fInfo[ FamilyHouse[H_IDX][fhBikers] ][fName]);
	if (capture_start[capture_band(FamilyHouse[H_IDX][fhBikers])] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Клуб, на который вы хотите напасть уже воевал в этом часу");
	//fhBikers 
	//if (crimeDiplomation[capture_band(pInfo[playerid][pMember])][capture_band(FamilyHouse[H_IDX][fhBikers])] == sDIP_ALLIANCE) return SendClientMessage(playerid, COLOR_LI_RED, !"[Дипломатия] "colwhi"С данной мафией заключен союз");
	if (BikersWarGZ != INVALID_GANGZONE_ID) return SendClientMessage(playerid, COLOR_GREY, !"В данное время уже идет война!");

	format(string_, sizeof string_, "%s забила вам стрелу за клиентуру: %s",name_band[capture_band(pInfo[playerid][pMember])], FamilyHouse[H_IDX][fhOwner]);
	SendFamilyMessage(FamilyHouse[H_IDX][fhBikers], COLOR_RED, string_);
	SendFamilyMessage(FamilyHouse[H_IDX][fhBikers], COLOR_RED, "Встреча через 20 минут");

	format(string_, sizeof string_, "%s %s инициировал(а) войну за клиентуру против клуба %s [Локация: %s]", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], name_band[capture_band(FamilyHouse[H_IDX][fhBikers])], location_name[ params[0] - 1 ]);
	SendFamilyMessage(pInfo[playerid][pMember], 0x00cc44FF, string_, .dliv = true);
	SendFamilyMessage(FamilyHouse[H_IDX][fhBikers], 0x00cc44FF, string_, .dliv = true); 
//
	format(string_, sizeof string_, "Biker %s (%s) инициировал захват дома против клуба %s", pInfo[playerid][pName],
		name_band[capture_band(pInfo[playerid][pMember])], name_band[capture_band(FamilyHouse[H_IDX][fhBikers])]
	);
	SendAdminMessage(0xBEBEBEFF, string_);
		
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][0] = 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][1] = 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][2] = 
	FractionInfo[ pInfo[playerid][pMember] ][fViolation][3] = 0; 

	FractionInfo[ FamilyHouse[H_IDX][fhBikers] ][fViolation][0] = 
	FractionInfo[ FamilyHouse[H_IDX][fhBikers] ][fViolation][1] = 
	FractionInfo[ FamilyHouse[H_IDX][fhBikers] ][fViolation][2] = 
	FractionInfo[ FamilyHouse[H_IDX][fhBikers] ][fViolation][3] = 0; 
 
	band = capture_band(FamilyHouse[H_IDX][fhBikers]);
	capture_start[capture_band(pInfo[playerid][pMember])] = 2;
	capture_start[band] = 2; 

	bikers_frac_id[0] = pInfo[playerid][pMember];
	bikers_frac_id[1] = FamilyHouse[H_IDX][fhBikers];
	kills_bikers[0] = 0;
	kills_bikers[1] = 0; 
	BikersTimer = 1200;  
	BikersFamilyHouseID = params[0]; 
	BikersWarGZ = GangZoneCreate(
		BikersWarZonePos[ params[0] - 1 ][0], BikersWarZonePos[ params[0] - 1 ][1], BikersWarZonePos[ params[0] - 1 ][2], BikersWarZonePos[ params[0] - 1 ][3]
	);
	foreach(new idx: AdminsTeam) {
		GangZoneShowForPlayer(idx, BikersWarGZ, 0xB2B2B2AA);
		GangZoneFlashForPlayer(idx, BikersWarGZ, COLOR_RED);
	}

	#if defined _capture_stats_inc
		if (CAPTURE_STATS_ENABLED) {
			new capture_id = TYPE_WAR_BIKERS;
			if (capture_id != -1) {
				captureid_slots[capture_id] = pInfo[playerid][pMember];

				capture_gangs[capture_id][0] = pInfo[playerid][pMember];
				capture_gangs[capture_id][1] = FamilyHouse[H_IDX][fhBikers];

				if (capture_band(capture_gangs[capture_id][0]) < sizeof (capture_band_captureid))
					capture_band_captureid[capture_band(capture_gangs[capture_id][0])] = capture_id;
				if (capture_band(capture_gangs[capture_id][1]) < sizeof (capture_band_captureid))
					capture_band_captureid[capture_band(capture_gangs[capture_id][1])] = capture_id;

				capture_kills[capture_band(capture_gangs[capture_id][0])] = 0;
				capture_kills[capture_band(capture_gangs[capture_id][1])] = 0;
			} 
			OnCaptureStart(capture_id);
		}
	#endif
	BzCheckTimer = SetTimerEx("BzCheck", 1000, true, "iii", H_IDX, pInfo[playerid][pMember], FamilyHouse[H_IDX][fhBikers]);
	SetStringMainTextDrawBikersWar(); 
	UpdateKillsBikersWar(); 
	foreach(new idx: PlayerTeam[bikers_frac_id[0]]) {
		/*for(new i_ = 0; i_ < 5; i_++) {
			if (!player_mobile[idx]) SendDeathMessageToPlayer(idx,INVALID_PLAYER_ID-1, INVALID_PLAYER_ID-1, 0);
		}*/
		if (pInfo[idx][pAdmin]) {
			if (pInfo[playerid][pAdmin]) continue;
		}
		SetPlayerColor(idx, gFractionColor[bikers_frac_id[0]]);
		ShowTextDrawCapture(idx, TYPE_WAR_BIKERS);
		GangZoneShowForPlayer(idx, BikersWarGZ, 0xB2B2B2AA);
		GangZoneFlashForPlayer(idx, BikersWarGZ, COLOR_RED);
	}
	foreach(new idx: PlayerTeam[bikers_frac_id[1]]) {
		/*for(new i_ = 0; i_ < 5; i_++) {
			if (!player_mobile[idx]) SendDeathMessageToPlayer(idx,INVALID_PLAYER_ID-1, INVALID_PLAYER_ID-1, 0);
		}*/
		if (pInfo[idx][pAdmin]) {
			if (pInfo[playerid][pAdmin]) continue;
		}
		SetPlayerColor(idx, gFractionColor[bikers_frac_id[1]]);
		ShowTextDrawCapture(idx, TYPE_WAR_BIKERS);
		GangZoneShowForPlayer(idx, BikersWarGZ, 0xB2B2B2AA);
		GangZoneFlashForPlayer(idx, BikersWarGZ, COLOR_RED);
	}  
	return 1;
} 

CMD:endlesson(playerid, params[])
{
    if (!pTemp[playerid][TakingLesson]) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не начинали урок");
	pTemp[playerid][TestAutoShcool] = false;
	pTemp[playerid][TakingLesson] = false;
	RemovePlayerFromVehicle(playerid);
	return 1;
}


CMD:buyinterior(playerid)
{
	if (pInfo[playerid][pHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет дома"); 
	if (pTemp[playerid][SelectBuyInt] == -1)
	{
		new 
			H_IDX = pInfo[playerid][pHouseID],
			idx = HouseInfo[H_IDX][hIntID];
	    if (IsPlayerInRangeOfPoint(playerid, 30.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2])
		&& GetPlayerVirtualWorld(playerid) == H_IDX + 50 )
		{
		    new count_ammo = 1;
      		t_string[0] = EOS;
		    for(new i = 0; i < sizeof(HouseInt); i++)
			{
			    if (HouseInfo[H_IDX][hKlass] != HouseInt[i][hIntClass]) continue;
	            format(t_string,(count_ammo*80),"%s"colserver"Интерьер: %d\t"colwhi"Цена: "collime"$%d\n",t_string, count_ammo, HouseInt[i][hIntCost]);
	        	count_ammo++;
			}
			ShowPlayerDialog(playerid, D_HOUSE_FUNC_8, 2, ""colserver"Список: "colwhi"Интерьеров", t_string, "Выбрать", "Назад");
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться в доме");
	}
	else
 	{
	    new string_[40];
	    format(string_, sizeof string_, "Купить за "collime"$%d?", HouseInt[pTemp[playerid][SelectBuyInt]][hIntCost]);
	    ShowPlayerDialog(playerid, D_HOUSE_FUNC_9, DIALOG_STYLE_MSGBOX, ""colserver"Покупка: "colwhi"Интерьера", string_, "Выбор", "Отмена");
	}
	return 1;
}
CMD:buygarageint(playerid)
{
	if (HouseInfo[playerid][hGarageID] == -1)
	{
		SendClientMessage(playerid, COLOR_GREY, !"У вас нет гаража в доме"); 
		return 0;
	}
	if (pTemp[playerid][SelectBuyInt] == -1)
	{
		new 
			H_IDX = pInfo[playerid][pHouseID],
			idx = HouseInfo[H_IDX][hIntID];
		if (IsPlayerInRangeOfPoint(playerid, 30.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2])
		&& GetPlayerVirtualWorld(playerid) == H_IDX + 50 )
		{
		    new count_ammo = 1;
      		t_string[0] = EOS;
		    for(new i = 0; i < sizeof(HouseInt); i++)
			{
				if (HouseInfo[playerid][hGarageID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"В Вашем доме нет гаража!");
	            format(t_string,(count_ammo*80),"%s"colserver"Интерьер: %d\t"colwhi"Цена: "collime"$%d\n",t_string, count_ammo, HouseInt[i][hIntCost]);
	        	count_ammo++;
				t_string[0] = EOS;
				if (HouseInfo[playerid][hGarageID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"В Вашем доме нет гаража!");
				format(t_string, sizeof t_string, "Гараж D класса\t"colwhi"Цена: 500.000$\n\
				Гараж C класса\t"colwhi"Цена: 500.000$\n\
				Гараж B класса\t"colwhi"Цена: 500.000$\n\
				Гараж A класса\t\t"colwhi"Цена: 500.000$\n\
				Гараж S класса\t"colwhi"Цена: 500.000$");
			}
			ShowPlayerDialog(playerid, D_HOUSE_FUNC_15, 2, ""colserver"Список: "colwhi"Интерьеров", t_string, "Выбрать", "Назад");
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться в доме");
	}
	else
 	{
	    new string_[60];
	    format(string_, sizeof string_, "Купить интерьер гаража за "collime"500.000$?");
	    ShowPlayerDialog(playerid, D_HOUSE_FUNC_16, DIALOG_STYLE_MSGBOX, ""colserver"Покупка: "colwhi"Интерьера", string_, "Выбор", "Отмена");
	}
	return 1;
}
CMD:buyhouse(playerid)
{
	if (pTemp[playerid][tSelectHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, "Вы должны находиться возле дома!"); 
	new
		H_IDX = pTemp[playerid][tSelectHouseID], 
		idx = HouseInfo[H_IDX][hIntID];
	if ((IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2]) 
		|| (IsPlayerInRangeOfPoint(playerid, 2.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) && GetPlayerVirtualWorld(playerid) == H_IDX+50))
	&& strcmp(HouseInfo[H_IDX][hOwner],"None",true) == 0)
	{
		if (pInfo[playerid][pHouseID] != -1) return SendClientMessage(playerid, COLOR_LIGHTGREEN, !"У вас уже есть дом!"); 
		new cost = GetVipBoostMaxPlayerValueSale(playerid, vSaleHome, bSaleHome, HouseInfo[H_IDX][hValue]);
		new cost_home = cost+(GetHouseOplata(H_IDX) * 24);
		if (pInfo[playerid][pBank] < cost_home) return SendClientMessage(playerid, COLOR_GREY, !"Недостаточно денег для покупки!");
		HouseInfo[H_IDX][hHel] = 0;
		HouseInfo[H_IDX][hLock] = 1;
		new query_[128];
		format(query_, sizeof(query_), "UPDATE `house` SET `hHel`= '%d', `hLock`= '%d' WHERE `hID` = '%d'", HouseInfo[H_IDX][hHel], HouseInfo[H_IDX][hLock], HouseInfo[H_IDX][hID]);
		mysql_tquery(dbHandle, query_, "", "");
		strmid(HouseInfo[H_IDX][hOwner],pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), 32); 
		pInfo[playerid][pHouseID] = H_IDX;
		pInfo[playerid][pBank] -= cost_home;
		SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
		HouseInfo[H_IDX][hTakings] = GetHouseOplata(H_IDX) * 24;
		SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]);
		pInfo[playerid][PlayerSpawn] = 1;
		SavePlayerInteger(playerid, "playerspawn", pInfo[playerid][PlayerSpawn]);

		SendClientMessage(playerid, COLOR_WHITE, !"Поздравляем с покупкой!");
		SendMes(playerid, COLOR_YELLOW, "Внимание! Теперь каждый час со счёта вашего дома будут снимать комунальные платежи в размере "collime"$%d", GetHouseOplata(H_IDX));
		SendClientMessage(playerid, COLOR_YELLOW, !"Если на счету недостаточно денег, вас выселят");
		SendClientMessage(playerid, COLOR_YELLOW, !"Пополнить домашний счёт или узнать баланс можно через банк/банкомат (помощь: /mm -> команды)");

		GameTextForPlayer(playerid, !"~w~welcome home~n~print:~g~/exit", 5000, 3); 
		UpdateHouseInfo(H_IDX, false);
		SaveHouseID(H_IDX); 
		OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_HOUSE);
		return 1;
	} 
	return 1;
} 
CMD:buyfarm(playerid, params[])
{
	new str[10], string[128];
	if (pTemp[playerid][PlayerFarmID] != -1)  return SendClientMessage(playerid, COLOR_WHITE, !"У вас уже есть ферма");
	for(new i = 1; i <= TOTALFARM; i++)
	{
		if (!IsPlayerInRangeOfPoint(playerid, 10.0, FarmInfo[i][fMenu][0], FarmInfo[i][fMenu][1], FarmInfo[i][fMenu][2]) || strcmp(FarmInfo[i][fOwner],"None",true) != 0) continue;
		bizselect[playerid] = i;
  		if (FarmInfo[bizselect[playerid]][fAuction][1] == 0) format(str,9,"%d",FarmInfo[bizselect[playerid]][fAuction][0]);
    	else format(str,16,"Скрыта");
	    format(string,sizeof(string),"{FFFF00}Бизнес: Ферма [%d].\tДо окончания: %d час(а/ов)\n{ffffff}Предыдущая ставка: %d\n{ffffff}Текущая ставка: %s\n{33AA33}Сделать ставку",FarmInfo[bizselect[playerid]][fID]-1,FarmInfo[bizselect[playerid]][fAuction][2],FarmInfo[bizselect[playerid]][fAuction][1], str);
	    ShowPlayerDialog(playerid,D_BIZZ_AUCTION_2,DIALOG_STYLE_LIST,"Аукцион бизнесов",string, "Далее", "Отмена");
    	break;
	}
	return 1;
}


CMD:bsellgun(playerid, params[])
{
	if (!IsABiker(playerid)) return 1;
	new gunname[18], string_[128];
	if (strlen(gunname) >= 18) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[18]ddu",gunname,params[0],params[1],params[2]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /bsellgun [название оружия] [патроны] [цена] [playerid]");
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gunlist - название оружия и расходы материалов");
		SendClientMessage(playerid, COLOR_WHITE, !"Минимальная цена $5!");
		return 1;
	}
	if (params[0] > 100|| params[0] < 0) return SendClientMessage(playerid, COLOR_GREY, !"От 1 до 100 патронов за раз");
	if (params[1] > 50000 || params[1] < 4 || params[0] < 0) return SendClientMessage(playerid, COLOR_GREY, !"Неверная цена/патроны");
	if (!IsPlayerInRangeOfPlayer(5.0, playerid, params[2])) return SendClientMessage(playerid, COLOR_GREY, !"Человек должен быть рядом с вами");
	if (strcmp(gunname,"sdpistol", true) == 0)
	{
		SetPVarInt(params[2], "Sell_Gun", 23);
		SetPVarInt(params[2], "Sell_GunMats", 1);
	}
	else if (strcmp(gunname,"deagle", true) == 0)
	{
		SetPVarInt(params[2], "Sell_Gun", 24);
		SetPVarInt(params[2], "Sell_GunMats", 3);
	}
	else if (strcmp(gunname,"shotgun", true) == 0)
	{
		SetPVarInt(params[2], "Sell_Gun", 25);
		SetPVarInt(params[2], "Sell_GunMats", 3);
	}
	else if (strcmp(gunname,"smg", true) == 0)
	{
 		SetPVarInt(params[2], "Sell_Gun", 29);
 		SetPVarInt(params[2], "Sell_GunMats", 2);
 	}
	else if (strcmp(gunname,"ak47", true) == 0)
	{
		SetPVarInt(params[2], "Sell_Gun", 30);
		SetPVarInt(params[2], "Sell_GunMats", 3);
	}
	else if (strcmp(gunname,"m4", true) == 0)
	{
		SetPVarInt(params[2], "Sell_Gun", 31);
		SetPVarInt(params[2], "Sell_GunMats", 3);
	}
	else if (strcmp(gunname,"rifle", true) == 0)
	{
		SetPVarInt(params[2], "Sell_Gun", 33);
		SetPVarInt(params[2], "Sell_GunMats", 5);
	}
	else return SendClientMessage(playerid, COLOR_GREY, !"Неизвестное оружие");

	new ammo = GetPVarInt(playerid,"Sell_GunMats") * params[0];
	if (pInfo[playerid][pMats] < ammo) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
	if (playerid == params[2])
	{
		GivePlayerWeapon(playerid, GetPVarInt(params[2],"Sell_Gun"), params[0]);
		pInfo[playerid][pMats] -= ammo; 
  		format(string_, sizeof string_, "%s сделал себе оружие из материалов", pInfo[playerid][pName]);
  		SendBeside(playerid,COLOR_PURPLE,string_,10.0);
		DeletePVar(playerid, #Sell_Gun);
		DeletePVar(playerid, #Sell_GunMats);
		return 1;
	}
	SetPVarInt(params[2],"Sell_GunId", playerid);
	SetPVarInt(params[2],"Sell_GunAmmo", params[0]);
	SetPVarInt(params[2],"Sell_GunPrice",params[1]);
	SetPVarInt(params[2],"Sell_GunMats", ammo);
	SendMes(params[2],COLOR_BLUE, "%s предлагает вам купить оружие %s. Патроны: %d",pInfo[playerid][pName],gunname,params[0]);
	SendClientMessage(params[2],COLOR_BLUE, !"Введите: /accept gun для покупки оружия");
	SendClientMessage(playerid, 0x6495EDFF, !"Вы предложили купить оружие!");
	return 1;
} 
CMD:gunlist(playerid)
{
	ShowPlayerDialog(playerid,D_NULL,0,"Список оружия","{FFFFFF}\
	___________________________________________________________\n\n\
	Название\t\tКоличество затрачевыемых материалов\n\n\
	- \"Sdpistol\"\t\t\t\t\t1\n\
	- \"Deagle\"\t\t\t\t\t3\n\
	- \"ShotGun\"\t\t\t\t\t3\n\
	- \"SMG\"\t\t\t\t\t2\n\
	- \"AK47\"\t\t\t\t\t3\n\
	- \"M4\"\t\t\t\t\t\t3\n\
	- \"Rifle\"\t\t\t\t\t5\n\n\
	___________________________________________________________","Закрыть","");
	return 1;
}

CMD:makegun(playerid, params[])
{
	if (IsPlayerDeath(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент Вы не можете использовать данную команду");
	if ((!IsAGang(playerid) && !IsAMafia(playerid)/* && !IsABiker(playerid)*/) || pInfo[playerid][pRank] < 4) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете использовать это ( Ваш ранг должен быть выше 4 )!");
	if (pInfo[playerid][pJailTime]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать в тюрьме");
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете сделать оружие в транспорте"); 
	switch(pInfo[playerid][pMember])
	{
		case FRACTION_PIRUS, FRACTION_BALLAS, FRACTION_VAGOS, FRACTION_GROVE, FRACTION_RIFA, FRACTION_AZTEC:
		{
			//if(!GetIDOwnerGangZone(playerid) && !IsPlayerInVehicleHome(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не на своей территории/или не в доме на колесах");
			if (sscanf(params, "dd", params[0], params[1]))
			{
				ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [ID из списка, для быстрого доступа] [патроны]");
				return 1;
			}
			switch(params[0])
			{
				case 0 .. 6:
				{
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
						//AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
						//MatsGunList[] = {15, 63, 150, 60, 90, 90, 50},
						xMats[] = {1, 3, 3, 2, 3, 3, 5};
					if (params[1] < 1 || params[1] > 500) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя сделать более 500 патрон");
					if (pInfo[playerid][pMats] < xMats[params[0]] * params[1]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
					GivePlayerWeapon(playerid, GunList[params[0]], params[1]);
					pInfo[playerid][pMats] -= xMats[params[0]] * params[1]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
					if (GunList[params[0]] == 24)
						OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_GUN, params[1]);
				}
				default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			} 
		}
		case 5:
		{ 
		    if (GetPlayerInterior(playerid) != LCN_INTERIOR && GetPlayerVirtualWorld(playerid) != 1)
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не в особняке Мафии");
		    if (sscanf(params, "d", params[0]))
			{
			    ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [id] (ID из списка, для быстрого доступа)");
				return 1;
			}
			switch(params[0])
			{
			    case 0..6:
			    {
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
				    	AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
				    	MatsGunList[] = {15, 63, 150, 60, 90, 90, 50};
		            if (pInfo[playerid][pMats] < MatsGunList[params[0]]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
		            GivePlayerWeapon(playerid, GunList[params[0]], AmmoList[params[0]]);
					pInfo[playerid][pMats] -= GunList[params[0]]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
		        }
		        default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			}
		}
		case 6:
		{
		    if (GetPlayerInterior(playerid) != YAKUZA_INTERIOR && GetPlayerVirtualWorld(playerid) != 1)
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не в особняке Мафии");
		    if (sscanf(params, "d", params[0]))
			{
			    ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [id] (ID из списка, для быстрого доступа)");
				return 1;
			}
			switch(params[0])
			{
			    case 0..6:
			    {
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
				    	AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
				    	MatsGunList[] = {15, 63, 150, 60, 90, 90, 50};
		            if (pInfo[playerid][pMats] < MatsGunList[params[0]]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
		            GivePlayerWeapon(playerid, GunList[params[0]], AmmoList[params[0]]);
					pInfo[playerid][pMats] -= GunList[params[0]]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
		        }
		        default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			}
		}
		case FRACTION_RUSSIAN:
		{
		    if (GetPlayerInterior(playerid) != RM_INTERIOR && GetPlayerVirtualWorld(playerid) != 1)
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не в особняке Мафии");
		    if (sscanf(params, "d", params[0]))
			{
			    ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [id] (ID из списка, для быстрого доступа)");
				return 1;
			}
			switch(params[0])
			{
			    case 0..6:
			    {
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
				    	AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
				    	MatsGunList[] = {15, 63, 150, 60, 90, 90, 50};
		            if (pInfo[playerid][pMats] < MatsGunList[params[0]]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
		            GivePlayerWeapon(playerid, GunList[params[0]], AmmoList[params[0]]);
					pInfo[playerid][pMats] -= GunList[params[0]]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
		        }
		        default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			}
		}
		/*case FRACTION_MONGOLS_MC: {
			if (GetPlayerInterior(playerid) != RM_INTERIOR && GetPlayerVirtualWorld(playerid) != 1)
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не в своем клубе");
		    if (sscanf(params, "d", params[0]))
			{
			    ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [id] (ID из списка, для быстрого доступа)");
				return 1;
			}
			switch(params[0])
			{
			    case 0..6:
			    {
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
				    	AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
				    	MatsGunList[] = {15, 63, 150, 60, 90, 90, 50};
		            if (pInfo[playerid][pMats] < MatsGunList[params[0]]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
		            GivePlayerWeapon(playerid, GunList[params[0]], AmmoList[params[0]]);
					pInfo[playerid][pMats] -= GunList[params[0]]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
		        }
		        default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			}
		}
		case FRACTION_BANDIDOS_MC: {
			if (GetPlayerInterior(playerid) != RM_INTERIOR && GetPlayerVirtualWorld(playerid) != 1)
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не в своем клубе");
		    if (sscanf(params, "d", params[0]))
			{
			    ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [id] (ID из списка, для быстрого доступа)");
				return 1;
			}
			switch(params[0])
			{
			    case 0..6:
			    {
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
				    	AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
				    	MatsGunList[] = {15, 63, 150, 60, 90, 90, 50};
		            if (pInfo[playerid][pMats] < MatsGunList[params[0]]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
		            GivePlayerWeapon(playerid, GunList[params[0]], AmmoList[params[0]]);
					pInfo[playerid][pMats] -= GunList[params[0]]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
		        }
		        default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			}
		}
		case FRACTION_OUTLAWS_MC: {
			if (GetPlayerInterior(playerid) != RM_INTERIOR && GetPlayerVirtualWorld(playerid) != 1)
				return SendClientMessage(playerid, COLOR_GREY, !"Вы не в своем клубе");
		    if (sscanf(params, "d", params[0]))
			{
			    ShowPlayerDialog(playerid, D_MAKEGUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Собрать оружие",""colserver"[№] Оружие\t"colserver"Патроны\t"colserver"Материалы\n\
				"colwhi"[0] Sd Pistol\t15\t15\n\
				[1] Deagle\t21\t63\n\
				[2] Shotgun\t50\t150\n\
				[3] SMG\t30\t60\n\
				[4] AK-47\t30\t90\n\
				[5] M4A1\t30\t90\n\
				[6] Rifle\t10\t50", "Выбрать", "Отмена");
				SendClientMessage(playerid, COLOR_WHITE, !"Введите: /makegun [id] (ID из списка, для быстрого доступа)");
				return 1;
			}
			switch(params[0])
			{
			    case 0..6:
			    {
					new GunList[] = {23, 24, 25, 29, 30, 31, 33},
				    	AmmoList[] = {15, 21, 50, 30, 30, 31, 10},
				    	MatsGunList[] = {15, 63, 150, 60, 90, 90, 50};
		            if (pInfo[playerid][pMats] < MatsGunList[params[0]]) return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно материалов!");
		            GivePlayerWeapon(playerid, GunList[params[0]], AmmoList[params[0]]);
					pInfo[playerid][pMats] -= GunList[params[0]]; 
					MeAction(playerid, "сделал(а) себе оружие из материалов", SELECT_ACTION_IN_BUBBLE, 10.0);
		        }
		        default: SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID (От 0 до 6)");
			}
		}*/
	}
	return 1;
}

CMD:getgun(playerid, params[])
{ 
	if (!IsABiker(playerid) && !IsAMafia(playerid)) return 1;
    switch(pInfo[playerid][pMember])
	{
		case 5:
		{
			if (GetPlayerInterior(playerid) == LCN_INTERIOR && GetPlayerVirtualWorld(playerid) == 1)
			{
			    new fraction_ = pInfo[playerid][pMember];
			    if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
			    if (sscanf(params, "u",params[0]))
				{
					if (pInfo[playerid][pRank] < 3) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно взять с 3 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]\n[6] Бронежилет\t[1. 350м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = playerid;
					SendClientMessage(playerid, COLOR_WHITE, !"Вы можете использовать:{00BF00} /getgun [ид игрока] {ffffff},чтобы выдать оружие другим членам организации");
				}
				else
				{
					if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");
					if (GetPlayerInterior(params[0]) != LCN_INTERIOR) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в особняке");
				    if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в вашей организации");
				    if (pInfo[playerid][pRank] <= 5) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно выдать с 6 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]\n[6] Бронежилет\t[1. 350м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = params[0];
				}
			}
		}
		case 6:
		{
			if (GetPlayerInterior(playerid) == YAKUZA_INTERIOR && GetPlayerVirtualWorld(playerid) == 1)
			{
			    new fraction_ = pInfo[playerid][pMember];
			    if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
			    if (sscanf(params, "u",params[0]))
				{
					if (pInfo[playerid][pRank] < 3) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно взять с 3 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]\n[6] Бронежилет\t[1. 350м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = playerid;
					SendClientMessage(playerid,COLOR_WHITE,!"Вы можете использовать:{00BF00} /getgun [ид игрока] {ffffff},чтобы выдать оружие другим членам организации");
				}
				else
				{
					if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");
					if (GetPlayerInterior(params[0]) != YAKUZA_INTERIOR) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в особняке");
				    if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в вашей организации");
				    if (pInfo[playerid][pRank] <= 5) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно выдать с 6 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]\n[6] Бронежилет\t[1. 350м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = params[0];
				}
			}
		}
		case 14:
		{
			if (GetPlayerInterior(playerid) == RM_INTERIOR && GetPlayerVirtualWorld(playerid) == 1)
			{
			    new fraction_ = pInfo[playerid][pMember];
			    if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
			    if (sscanf(params, "u",params[0]))
				{
					if (pInfo[playerid][pRank] < 3) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно взять с 3 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]\n[6] Бронежилет\t[1. 350м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = playerid;
					SendClientMessage(playerid,COLOR_WHITE,!"Вы можете использовать:{00BF00} /getgun [ид игрока] {ffffff},чтобы выдать оружие другим членам организации");
				}
				else
				{
					if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");
					if (GetPlayerInterior(params[0]) != RM_INTERIOR) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в особняке");
				    if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в вашей организации");
				    if (pInfo[playerid][pRank] < 3) return SendClientMessage(playerid,COLOR_GRAD1, !"Оружие можно выдать с 6 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]\n[6] Бронежилет\t[1. 350м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = params[0];
				}
			}
		}
		//
		case 24:
		{
			if (GetPlayerInterior(playerid) == BIKERS_INT && GetPlayerVirtualWorld(playerid) == 1)
			{
				new fraction_ = pInfo[playerid][pMember];
			    if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
				if (sscanf(params, "u",params[0]))
				{
					if (pInfo[playerid][pRank] < 2) return SendClientMessage(playerid,COLOR_GRAD1, !"Оружие можно взять с 2 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = playerid;
					SendClientMessage(playerid,COLOR_WHITE,!"Вы можете использовать:{00BF00} /getgun [ид игрока] {ffffff},чтобы выдать оружие другим членам организации");
				}
				else
				{
					if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");
					if (GetPlayerInterior(params[0]) != BIKERS_INT) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в клубе");
				    if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в вашей организации");
				    if (pInfo[playerid][pRank] <= 4) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно выдать с 5 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1 , DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = params[0];
				} 
			}
		}
		case 25:
		{
			if (GetPlayerInterior(playerid) == BIKERS_INT && GetPlayerVirtualWorld(playerid) == 2)
			{
				new fraction_ = pInfo[playerid][pMember];
			    if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
				if (sscanf(params, "u",params[0]))
				{
					if (pInfo[playerid][pRank] < 2) return SendClientMessage(playerid,COLOR_GRAD1, !"Оружие можно взять с 2 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1 , DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = playerid;
					SendClientMessage(playerid,COLOR_WHITE,!"Вы можете использовать:{00BF00} /getgun [ид игрока] {ffffff},чтобы выдать оружие другим членам организации");
				}
				else
				{
					if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");
					if (GetPlayerInterior(params[0]) != BIKERS_INT) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в клубе");
				    if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в вашей организации");
				    if (pInfo[playerid][pRank] <= 4) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно выдать с 5 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1 , DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = params[0];
				} 
			}
		}
		case 26:
		{
			if (GetPlayerInterior(playerid) == BIKERS_INT && GetPlayerVirtualWorld(playerid) == 3)
			{
				new fraction_ = pInfo[playerid][pMember];
			    if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
				if (sscanf(params, "u",params[0]))
				{
					if (pInfo[playerid][pRank] < 2) return SendClientMessage(playerid,COLOR_GRAD1, !"Оружие можно взять с 2 ранга!"); 
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1 , DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = playerid;
					SendClientMessage(playerid,COLOR_WHITE,!"Вы можете использовать:{00BF00} /getgun [ид игрока] {ffffff},чтобы выдать оружие другим членам организации");
				}
				else
				{
					if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");
					if (GetPlayerInterior(params[0]) != BIKERS_INT) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в клубе");
				    if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоит в вашей организации");
				    if (pInfo[playerid][pRank] <= 4) return SendClientMessage(playerid,COLOR_GRAD1, "Оружие можно выдать с 5 ранга!");
					format(t_string, sizeof t_string,
						""colserver"[№] Оружие\t"colserver"Кол-во Патрон/Материалов\n\
						"colwhi"[0] Desert Eagle\t[50п. 70м.]\n[1] Shotgun\t[15п. 50м.]\n[2] SMG\t[200п. 400м.]\n[3] AK47\t[100п. 300м.]\n[4] M4A1\t[100п. 300м.]\n[5] Rifle\t[15п. 100м.]"
					);
					ShowPlayerDialog(playerid, D_FRAC_FUNC_1 , DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружие", t_string, "Взять", "Выйти");
					getgunsid[playerid] = params[0];
				} 
			}
		}
	}
	return 1;
}   
CMD:ghouselock(playerid, params[])
{
    if (!IsAGang(playerid) || !IsAMafia(playerid) || !IsABiker(playerid))
	{
		new
			member_ = pInfo[playerid][pMember],
			string_[128];
	    if (!IsAAssis(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Доступно лидеру и заму");
     	if (FractionInfo[member_][fHouseLock] == 0) FractionInfo[member_][fHouseLock] = 1;
		else FractionInfo[member_][fHouseLock] = 0;
		format(string_, sizeof(string_), "%s %s %s доступ к дому!", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], FractionInfo[member_][fHouseLock] ? ("Закрыл") : ("Открыл"));
  		SendFamilyMessage(member_, COLOR_LIGHTGREEN, string_);
  		SaveFractionInfoID(FractionInfo[member_][fID], false);
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Данная функция доступна только бандам и мафиози");
	return 1;
}
CMD:warelock(playerid)
{
    if (!IsAGang(playerid) || !IsAMafia(playerid) || !IsABiker(playerid))
	{
		new
			member_ = pInfo[playerid][pMember],
			string_[128];
	    if (!IsAAssis(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Доступно лидеру и заму");
     	if (FractionInfo[member_][fLock] == 0) FractionInfo[member_][fLock] = 1;
		else FractionInfo[member_][fLock] = 0;
		format(string_, sizeof(string_), "%s %s %s {9ACD32}доступ к складу с материалами!", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], FractionInfo[member_][fLock] ? (""colwarn"Закрыл") : (""collime"Открыл"));
  		SendFamilyMessage(member_, COLOR_LIGHTGREEN, string_);
  		SaveFractionInfoID(FractionInfo[member_][fID], false);
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Данная функция доступна только бандам и мафиози");
	return 1;
}
CMD:warehouse(playerid)
{
	new string_[128];
    switch(pInfo[playerid][pMember])
	{
		case 1: {
			format(string_, sizeof string_, "На складе LSPD %d/100000 материалов", FractionInfo[1][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 2: {
			format(string_, sizeof string_, "На складе FBI %d/100000 материалов", FractionInfo[2][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 3: {
			format(string_, sizeof string_, "На складе Армии SF: %d материалов", FractionInfo[3][fMaterials]);
			SendClientMessage(playerid, 0x6BB3FFAA, string_);
			format(string_, sizeof string_, "На главном складе: %d материалов", FractionInfo[19][fMaterials]);
			SendClientMessage(playerid, 0x6BB3FFAA, string_);
			format(string_, sizeof string_, "На складе LSA: Ангар 0: %d, Ангар 1: %d", gEconomyServer[eMaterialsLSa][0], gEconomyServer[eMaterialsLSa][1]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 5: {
			format(string_, sizeof string_, "На складе LCN %d/"#STORE_MAFIA_MATERIALS" материалов. Склад: %s", FractionInfo[5][fMaterials], FractionInfo[5][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 6: {
			format(string_, sizeof string_, "На складе Yakuza %d/"#STORE_MAFIA_MATERIALS" материалов. Склад: %s", FractionInfo[6][fMaterials], FractionInfo[6][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 10:
		{
			format(string_, sizeof string_, "На складе SFPD %d/100000 материалов", FractionInfo[10][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 12:
		{
			format(string_, sizeof string_, "На складе Ballas %d/"#STORE_GANG_MATERIALS" материалов. Склад: %s", FractionInfo[12][fMaterials], FractionInfo[12][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 13:
		{
			format(string_, sizeof string_, "На складе Vagos %d/"#STORE_GANG_MATERIALS" материалов. Склад: %s", FractionInfo[13][fMaterials], FractionInfo[13][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 14:
		{
			format(string_, sizeof string_, "На складе Russian Mafia %d/"#STORE_MAFIA_MATERIALS" материалов. Склад: %s", FractionInfo[14][fMaterials], FractionInfo[14][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 15:
		{
			format(string_, sizeof string_, "На складе Grove %d/"#STORE_GANG_MATERIALS" материалов. Склад: %s", FractionInfo[15][fMaterials], FractionInfo[15][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 17:
		{
			format(string_, sizeof string_, "На складе Aztec %d/"#STORE_GANG_MATERIALS" материалов. Склад: %s", FractionInfo[17][fMaterials], FractionInfo[17][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 18:
		{
			format(string_, sizeof string_, "На складе Rifa %d/"#STORE_GANG_MATERIALS" материалов. Склад: %s", FractionInfo[18][fMaterials], FractionInfo[18][fLock] ? ("Закрыт") : ("Открыт"));
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 19:
		{
			format(string_, sizeof string_, "На главном складе: %d материалов", FractionInfo[19][fMaterials]);
			SendClientMessage(playerid, 0x6BB3FFAA, string_);
			format(string_, sizeof string_, "На складе Армии SF: %d материалов", FractionInfo[3][fMaterials]);
			SendClientMessage(playerid, 0x6BB3FFAA, string_);
			format(string_, sizeof string_, "На складе LSA: %d материалов", lsamatbi);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 21:
		{
			format(string_, sizeof string_, "На складе LVPD %d/100000 материалов", FractionInfo[21][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 24:
		{
			format(string_, sizeof string_, "На складе Mongols MC %d/"#STORE_BIKERS_MATERIALS" материалов", FractionInfo[24][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 25:
		{
			format(string_, sizeof string_, "На складе Bandidos MC %d/"#STORE_BIKERS_MATERIALS" материалов", FractionInfo[25][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		case 26:
		{
			format(string_, sizeof string_, "На складе Outlaws MC %d/"#STORE_BIKERS_MATERIALS" материалов", FractionInfo[26][fMaterials]);
			return SendClientMessage(playerid, 0x6BB3FFAA, string_);
		}
		default: SendClientMessage(playerid, COLOR_GREY, !"Вам не доступна данная команда!");
	}
	return 1;
}

CMD:unloading(playerid, params[])
{
    if (!IsAGang(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid), string_[128];
	new fraction_ = pInfo[playerid][pMember];
	if (GetVehicleModel(vehicleid) != 482 && GetVehicleModel(vehicleid) != 433) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в фургоне!");
	if (pInfo[playerid][pRank] < 3) return SendClientMessage(playerid,COLOR_GRAD1, !"Доступно только с 3 ранга!");
	if (gVehicleGun[vehicleid][vGunAmmo] <= 0) return SendClientMessage(playerid, COLOR_GREY, !"недостаточно материалов, для разгрузки");
	if (IsPlayerInRangeOfPoint(playerid,6.0,1454.3406,758.1638,11.0234))
	{
		FractionInfo[FRACTION_LCN][fMaterials] += gVehicleGun[vehicleid][vGunAmmo];
		gVehicleGun[vehicleid][vGunAmmo] = 0;
		format(string_, sizeof(string_), "Материалы разргружены! В фургоне: %d/10000 матов", gVehicleGun[vehicleid][vGunAmmo]);
		SendClientMessage(playerid, TEAM_GROVE_COLOR, string_);
		if (FractionInfo[FRACTION_LCN][fMaterials] > STORE_LIMITS_MATERIALS) FractionInfo[FRACTION_LCN][fMaterials] = STORE_LIMITS_MATERIALS;
		SaveFractionInfoID(FractionInfo[FRACTION_LCN][fID], false);
		UpdateFractionStore(FRACTION_LCN);
		format(string_, sizeof(string_), "Склад мафии LCN: %d/"#STORE_LIMITS_MATERIALS"", FractionInfo[FRACTION_LCN][fMaterials]);
		return scm(playerid, COLOR_WHITE, string_);
	}
	else if (IsPlayerInRangeOfPoint(playerid,6.0,967.3965,1684.1112,8.8516))
	{
		FractionInfo[FRACTION_RUSSIAN][fMaterials] += gVehicleGun[vehicleid][vGunAmmo];
		gVehicleGun[vehicleid][vGunAmmo] = 0;
		format(string_, sizeof(string_), "Материалы разргружены! В фургоне: %d/10000 матов", gVehicleGun[vehicleid][vGunAmmo]);
		SendClientMessage(playerid, TEAM_GROVE_COLOR, string_);
		if (FractionInfo[FRACTION_RUSSIAN][fMaterials] > STORE_LIMITS_MATERIALS) FractionInfo[FRACTION_RUSSIAN][fMaterials] = STORE_LIMITS_MATERIALS;
		SaveFractionInfoID(FractionInfo[FRACTION_RUSSIAN][fID], false);
		UpdateFractionStore(FRACTION_RUSSIAN);
		format(string_, sizeof(string_), "Склад Русской мафии: %d/"#STORE_LIMITS_MATERIALS"", FractionInfo[FRACTION_RUSSIAN][fMaterials]);
		return scm(playerid, COLOR_WHITE, string_);
	}
	else if (IsPlayerInRangeOfPoint(playerid,6.0,1460.3116,2763.8110,10.8203))
	{
		FractionInfo[FRACTION_YAKUZA][fMaterials] += gVehicleGun[vehicleid][vGunAmmo];
		gVehicleGun[vehicleid][vGunAmmo] = 0;
		format(string_, sizeof(string_), "Материалы разргружены! В фургоне: %d/10000 матов", gVehicleGun[vehicleid][vGunAmmo]);
		SendClientMessage(playerid, TEAM_GROVE_COLOR, string_);
		if (FractionInfo[FRACTION_YAKUZA][fMaterials] > STORE_LIMITS_MATERIALS) FractionInfo[FRACTION_YAKUZA][fMaterials] = STORE_LIMITS_MATERIALS;
		SaveFractionInfoID(FractionInfo[FRACTION_YAKUZA][fID], false);
		UpdateFractionStore(FRACTION_YAKUZA);
		format(string_, sizeof(string_), "Склад Якудза: %d/"#STORE_LIMITS_MATERIALS"", FractionInfo[FRACTION_YAKUZA][fMaterials]);
		return scm(playerid, COLOR_WHITE, string_);
	}
	if (!IsATerra (playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не на своей базе");
	if (FractionInfo[fraction_][fMaterials] > STORE_LIMITS_MATERIALS) return SendClientMessage(playerid, COLOR_GREY, !"Склад заполнен");
	FractionInfo[fraction_][fMaterials] += gVehicleGun[vehicleid][vGunAmmo]; 
	UpdateFractionStore(fraction_);

	OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_MATS_250, gVehicleGun[vehicleid][vGunAmmo]);

	gVehicleGun[vehicleid][vGunAmmo] = 0;
	return scm(playerid,COLOR_GREEN, !"Материалы разгружены");
}

CMD:carm(playerid, params[])
{
    if (pInfo[playerid][pMember] != FRACTION_ARMY_LV && pTemp[playerid][PlayerInArmyForm] != true) return 1; 
	ShowPlayerDialog(playerid, D_UNLOAD_MATERIALS_0, DIALOG_STYLE_LIST, "Развозка материалов", ""colwhi"[0] "collime"Загрузка\n\
		"colwhi"[1] Разгрузить на гл.склад\n\
		[2] Разгрузить на склад Армии ЛС\n\
		[3] Разгрузить на склад Армии СФ\n\
		[4] Разгрузить на склад ЛСПД\n\
		[5] Разгрузить на склад ФБР\n\
		[6] Разгрузить на склад СФПД\n\
		[7] Разгрузить на склад ЛВПД\n\
		[8] Разгрузить на склад Мэрии\n\
		[9] Разгрузить на склад бандам", "Выбрать", "Отмена"
	);
	return 1;
}
alias:carm("conveyingarms");
CMD:carmat(playerid, params[])
{
	if (pInfo[playerid][pMember] != 3) return 1;
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в загрузочном вертолёте!");
	SetPVarInt(playerid,#LoadGunArmy, 1);
	SetPVarInt(playerid, #LoadTypeArmy, 1);
	SetPlayerCheckpoint(playerid,-1420.4194,1485.6796,11.8084,14.0);
	SendClientMessage(playerid,COLOR_WHITE, !"Отправляйтесь на корабль, для загрузки Оружия");
	//VertMats[playerid] = 1;
	return 1;
}
CMD:gbank(playerid, params[])
{
    if (!IsAGang(playerid)) return 1;
    new string_[32];
    switch(pInfo[playerid][pMember])
	{
		case 15: format(string_, sizeof(string_), "В банке Grove: "collime"$%d", FractionInfo[15][fMoney]);
		case 12: format(string_, sizeof(string_), "В банке Ballas: "collime"$%d", FractionInfo[12][fMoney]);
		case 13: format(string_, sizeof(string_), "В банке Vagos: "collime"$%d", FractionInfo[13][fMoney]);
		case 17: format(string_, sizeof(string_), "В банке Aztec: "collime"$%d", FractionInfo[17][fMoney]);
		case 18: format(string_, sizeof(string_), "В банке Rifa: "collime"$%d", FractionInfo[18][fMoney]);
	}
	SendClientMessage(playerid, 0x6495EDFF, string_);
	return 1;
}
CMD:gbankwithdraw(playerid, params[])
{
	if (!IsAGang(playerid)) return 1;

    if pInfo[playerid][pRank] < 10 *then return 1;

	if sscanf(params, "d", params[0]) *then return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gbankwithdraw [количество]");

	new 
        fraction_id = pInfo[playerid][pMember],
        string_[144];

    if gFraction[fraction_id][fLimitWareHouse] + params[0] > 500_000 *then
    { 
        SendMes(playerid, 0x6495EDFF, "Можно снять $%d. Дневной лимит (500.000)", 500_000 - gFraction[fraction_id][fLimitWareHouse]);
        return true;
    }
    
    if FractionInfo[ pInfo[playerid][pMember] ][fMoney] == 0 *then return SendMes(playerid, COLOR_GREY, "В банке банды %s нет денег", gFraction[fraction_id][fName]);
    
    if FractionInfo[ pInfo[playerid][pMember] ][fMoney] < params[0] *then return SendMes(playerid, COLOR_GREY, "В банке банды %s нет столько денег", gFraction[fraction_id][fName]);
    
    if !(1 <= params[0] <= 500_000) *then return SendClientMessage(playerid, COLOR_GREY, !"Неправильный количество денег!");
    
    FractionInfo[fraction_id][fMoney] -= params[0];

    switch(fraction_id)
    {
        case 8: kLibGivePlayerMoney(playerid, params[0], "/gbankwithdraw 1");
        case 12: kLibGivePlayerMoney(playerid, params[0], "/gbankwithdraw 2");
        case 13: kLibGivePlayerMoney(playerid, params[0], "/gbankwithdraw 3");
        case 15: kLibGivePlayerMoney(playerid, params[0], "/gbankwithdraw 4");
        case 17: kLibGivePlayerMoney(playerid, params[0], "/gbankwithdraw 6");
        case 18: kLibGivePlayerMoney(playerid, params[0], "/gbankwithdraw 7");
    }

    format(string_, sizeof(string_), "Вы сняли с банка банды %s: $%d", gFraction[fraction_id][fName], params[0]);

    SendClientMessage(playerid, 0x6495EDFF, string_);

    gFraction[fraction_id][fLimitWareHouse] += params[0];

	SaveFractionInfoID(FractionInfo[pInfo[playerid][pMember]][fID], false);

	return 1;
}
CMD:gbankput(playerid, params[])
{
    if (!IsAGang(playerid)) return 1;
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gbankput [количество]");
	if (params[0] < 1 || kLibGetPlayerMoney(playerid) < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Неправильный количество денег!");
	new fraction_ = pInfo[playerid][pMember], string_[64];
	FractionInfo[fraction_][fMoney] += params[0];
	kLibGivePlayerMoney(playerid, -params[0], "/gbankput"); 
    switch(pInfo[playerid][pMember])
    {
		case 15: format(string_, sizeof(string_), "Вы положили в банк Grove: "collime"$%d", params[0]);
		case 12: format(string_, sizeof(string_), "Вы положили в банк Ballas: "collime"$%d", params[0]);
		case 13: format(string_, sizeof(string_), "Вы положили в банк Vagos: "collime"$%d", params[0]);
		case 17: format(string_, sizeof(string_), "Вы положили в банк Aztec: "collime"$%d", params[0]);
		case 18: format(string_, sizeof(string_), "Вы положили в банк Rifa: "collime"$%d", params[0]);
	}
	SendClientMessage(playerid, 0x6495EDFF, string_);
	return 1;
}
CMD:newsbank(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
    new string_[32];
    switch(pInfo[playerid][pMember])
	{
		case 9: format(string_, sizeof(string_), "В банке SF NEWS: $%d", FractionInfo[9][fMoney]);
		case 16: format(string_, sizeof(string_), "В банке LS NEWS: $%d", FractionInfo[16][fMoney]);
		case 20: format(string_, sizeof(string_), "В банке LV NEWS: $%d", FractionInfo[20][fMoney]);
	}
	SendClientMessage(playerid, 0x6495EDFF, string_);
	return 1;
}
CMD:newsput(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /newsput [количество]");
	if (params[0] < 1 || kLibGetPlayerMoney(playerid) < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Неправильный количество денег!");
	new fraction_ = pInfo[playerid][pMember], string_[64];
	FractionInfo[fraction_][fMoney] += params[0];
	kLibGivePlayerMoney(playerid, -params[0], "/newsput"); 
	if (pInfo[playerid][pMember] == 9) format(string_, sizeof(string_), "Вы положили в банк SF NEWS: $%d", params[0]);
	else if (pInfo[playerid][pMember] == 16) format(string_, sizeof(string_), "Вы положили в банк LS NEWS: $%d", params[0]);
	else if (pInfo[playerid][pMember] == 20) format(string_, sizeof(string_), "Вы положили в банк LV NEWS: $%d", params[0]);
	SendClientMessage(playerid, 0x6495EDFF, string_);
	return 1;
}
CMD:newswithdraw(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /newswithdraw [количество]");
	if (params[0] < 1 || params[0] > 500000) return SendClientMessage(playerid, COLOR_GREY, !"Не может быть меньше 1 и больше $500000!");
	//if (params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Неправильное количество денег!"); 
	new string_[128], 
		fraction_id = pInfo[playerid][pMember]; 
	if (gFraction[fraction_id][fLimitWareHouse] + params[0] > 500_000)
	{
		format(string_, sizeof string_, "Можно снять $%d. Дневной лимит (500.000)", 500_000 - gFraction[fraction_id][fLimitWareHouse]);
		return scm(playerid, 0x6495EDFF, string_);
	}
	if (pInfo[playerid][pMember] == 9 && pInfo[playerid][pRank] == 10)
	{
		if (FractionInfo[9][fMoney] == 0) return SendClientMessage(playerid, COLOR_GREY, !"В банке SF NEWS нет денег");
		if (FractionInfo[9][fMoney] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"В банке SF NEWS нет столько денег");
		FractionInfo[9][fMoney] -= params[0];
		kLibGivePlayerMoney(playerid, params[0], "/newswithdraw 1");
		gFraction[fraction_id][fLimitWareHouse] += params[0];
		format(string_, sizeof(string_), "Вы сняли с банка SF NEWS: $%d", params[0]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	else if (pInfo[playerid][pMember] == 16 && pInfo[playerid][pRank] == 10)
	{
		if (FractionInfo[16][fMoney] == 0) return SendClientMessage(playerid, COLOR_GREY, !"В банке LS NEWS нет денег");
		if (FractionInfo[16][fMoney] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"В банке LS NEWS нет столько денег");
		FractionInfo[16][fMoney] -= params[0];
		gFraction[fraction_id][fLimitWareHouse] += params[0];
		kLibGivePlayerMoney(playerid, params[0], "/newswithdraw 2");
		format(string_, sizeof(string_), "Вы сняли с банка LS NEWS: $%d", params[0]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	else if (pInfo[playerid][pMember] == 20 && pInfo[playerid][pRank] == 10)
	{
		if (FractionInfo[20][fMoney] == 0) return SendClientMessage(playerid, COLOR_GREY, !"В банке LV NEWS нет денег");
		if (FractionInfo[20][fMoney] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"В банке LV NEWS нет столько денег");
		FractionInfo[20][fMoney] -= params[0];
		gFraction[fraction_id][fLimitWareHouse] += params[0];
		kLibGivePlayerMoney(playerid, params[0], "/newswithdraw 3");
		format(string_, sizeof(string_), "Вы сняли с банка LV NEWS: $%d", params[0]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	SaveFractionInfoID(FractionInfo[pInfo[playerid][pMember]][fID], false);
	return 1;
}
CMD:mafiabalance(playerid, params[])
{
    if (!IsAMafia(playerid)) return 1;
    new string_[64];
    switch(pInfo[playerid][pMember])
	{
		case 6: format(string_, sizeof string_, "В банке мафии Yakuza: $%d", FractionInfo[6][fMoney] );
		case 14: format(string_, sizeof string_, "В банке Русской мафии: $%d", FractionInfo[14][fMoney] );
		case 5: format(string_, sizeof string_, "В банке мафии LCN: $%d", FractionInfo[5][fMoney] );
	}
	SendClientMessage(playerid, 0x6495EDFF, string_);
	return 1;
}
CMD:mafiawithdraw(playerid, params[])
{
	if (!IsAMafia(playerid)) return 1;
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /mafiawithdraw [количество]");
	if (params[0] < 1 || params[0] > 500000) return SendClientMessage(playerid, COLOR_GREY, !"Не может быть меньше 1 и больше $500000!");
    new string_[128], 
		fraction_id = pInfo[playerid][pMember]; 
	if (gFraction[fraction_id][fLimitWareHouse] + params[0] > 500_000)
	{
		format(string_, sizeof string_, "Можно снять $%d. Дневной лимит (500.000)", 500_000 - gFraction[fraction_id][fLimitWareHouse]);
		return SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	if (pInfo[playerid][pMember] == 6 && pInfo[playerid][pRank] == 10)
	{
		if (FractionInfo[6][fMoney] <= 0) return SendClientMessage(playerid, COLOR_GREY, !"В банке мафии Yakuza нет денег");
		if (FractionInfo[6][fMoney] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"В банке мафии Yakuza нет столько денег");
		FractionInfo[6][fMoney] -= params[0];
		kLibGivePlayerMoney(playerid, params[0], "/mafiawithdraw 1");
		HistoryStoreLog(playerid, params[0], "взял с банка мафии");
		gFraction[fraction_id][fLimitWareHouse] += params[0];
		format(string_, sizeof string_, "Вы сняли с банка мафии Yakuza: $%d", params[0]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	else if (pInfo[playerid][pMember] == 14 && pInfo[playerid][pRank] == 10)
	{
		if (FractionInfo[14][fMoney] <= 0) return SendClientMessage(playerid, COLOR_GREY, !"В банке Русской мафии нет денег");
		if (FractionInfo[14][fMoney] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"В банке Русской мафии нет столько денег");
		FractionInfo[14][fMoney] -= params[0];
		kLibGivePlayerMoney(playerid, params[0], "/mafiawithdraw 2");
		gFraction[fraction_id][fLimitWareHouse] += params[0];
		HistoryStoreLog(playerid, params[0], "взял с банка мафии");
		format(string_, sizeof string_, "Вы сняли с банка Русской мафии: $%d", params[0]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	else if (pInfo[playerid][pMember] == 5 && pInfo[playerid][pRank] == 10)
	{
		if (FractionInfo[5][fMoney] <= 0) return SendClientMessage(playerid, COLOR_GREY, !"В банке мафии LCN нет денег");
		if (FractionInfo[5][fMoney] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"В банке мафии LCN нет столько денег");
		FractionInfo[5][fMoney] -= params[0];
		kLibGivePlayerMoney(playerid, params[0], "/mafiawithdraw 3");
		gFraction[fraction_id][fLimitWareHouse] += params[0];
		HistoryStoreLog(playerid, params[0], "взял с банка мафии");
		format(string_, sizeof string_, "Вы сняли с банка мафии LCN: $%d", params[0]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
	}
	SaveFractionInfoID(FractionInfo[pInfo[playerid][pMember]][fID], false);
	return 1;
}
CMD:mafiabank(playerid, params[])
{
	if (!pInfo[playerid][pLogin] || !IsAMafia(playerid) || pInfo[playerid][pRank] < 6) return 1;
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /mafiabank [количество]");
	if (params[0] < 1 || kLibGetPlayerMoney(playerid) < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Неправильный количество денег!");
	new fraction_ = pInfo[playerid][pMember], string_[64];
	FractionInfo[fraction_][fMoney] += params[0];
	kLibGivePlayerMoney(playerid, -params[0], "/mafiabank");
	if (pInfo[playerid][pMember] == 6 && pInfo[playerid][pRank] > 6) format(string_, sizeof string_, "Вы положили в банк мафии Yakuza: $%d", params[0]);
	else if (pInfo[playerid][pMember] == 14 && pInfo[playerid][pRank] > 6) format(string_, sizeof string_, "Вы положили в банк Русской мафии: $%d", params[0]);
	else if (pInfo[playerid][pMember] == 5 && pInfo[playerid][pRank] > 6) format(string_, sizeof string_, "Вы положили в банк мафии LCN: $%d", params[0]);
	SendClientMessage(playerid, 0x6495EDFF, string_); 
	return 1;
}
CMD:materials(playerid, params[])
{
    if (!IsAGang(playerid) || !IsAMafia(playerid) || !IsAArmy(playerid))
	{
		if (strlen(params[0]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"buy - Мафиям | load | put | get");
		if (sscanf(params, "s[32]", params[0]))
		{
			SendClientMessage(playerid, COLOR_WHITE, !"Введите: /materials [значение]");
			return SendClientMessage(playerid, COLOR_WHITE,"buy - Мафиям | load | put | get");
		}

		if (strcmp(params[0], "buy",true) == 0)
		{
			if (IsAMafia(playerid) && pInfo[playerid][pRank] >= 9)
			{
				for (new id = 0; id < sizeof (BusinessInfo); id++)
				{
					if (!IsValidBusiness(id)) continue;
					if (BusinessInfo[id][bType] != BUSINESS_TYPE_AMMO) continue; 
					new interior_id = BusinessInfo[id][bInteriorID];
					if (IsPlayerInRangeOfPoint(playerid, 10.0, BusinessInteriorInfo[interior_id][bIntMenuPos][0], BusinessInteriorInfo[interior_id][bIntMenuPos][1], BusinessInteriorInfo[interior_id][bIntMenuPos][2])
						&& GetPlayerInterior(playerid) == BusinessInteriorInfo[interior_id][bIntInterior]) {//bIntInterior 					
						ShowPlayerDialog(playerid, D_FRAC_FUNC_0, DIALOG_STYLE_INPUT, ""colserver"Покупка "colwhi"Материалов",
							""colwhi"Укажите количество материалов которое желаете купить:\n\nЦена за 1 материал, стоит "collime"$50", "Да", "Отмена"
						);
					}
					else {
						SendClientMessage(playerid, COLOR_WHITE, !"Вы должны находиться в одном из Аммо");
					}
					return 1;
				}  
			} 
		} 
		else if (strcmp(params[0], "load",true) == 0)
		{
		    if (!IsAGang(playerid)) return 1;
			new vehicleid = GetPlayerVehicleID(playerid), string_[128];
			new fraction_ = pInfo[playerid][pMember];
			if (GetVehicleModel(vehicleid) != 482) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в фургоне!");
			if (!IsATerra(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы должны находится на своей базе!");
			if (pInfo[playerid][pRank] < 8) return SendClientMessage(playerid,COLOR_GRAD1, !"Доступно только с 8 ранга!");
			if (FractionInfo[fraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт");
			if (FractionInfo[fraction_][fMaterials] < 15000) return SendClientMessage(playerid, COLOR_GREY, !"На складе недостаточно материалов");
			if (gVehicleGun[vehicleid][vGunAmmo] == CARAVAN_MATERIALS_LIMITS) return SendClientMessage(playerid,COLOR_GRAD1, !"Фургон заполнен");
			if (gVehicleGun[vehicleid][vGunAmmo] == 0)
			{
				format(string_, sizeof string_, "%s загрузил(а) "#CARAVAN_MATERIALS_LIMITS" материалов в фургон", pInfo[playerid][pName]);
				SendBeside(playerid,COLOR_PURPLE,string_,10.0); 
				gVehicleGun[vehicleid][vGunAmmo] += 15000;
				FractionInfo[fraction_][fMaterials] -= 15000; 
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_NONE);
			}
		}
		else if (strcmp(params[0], "put",true) == 0)
		{
		    if (!IsAGang(playerid)) return 1;
			new 
				vehicleid = GetNearestVehicle(playerid), string_[128];
			if (GetVehicleModel(GetNearestVehicle(playerid)) != 482) return SendClientMessage(playerid, COLOR_GREY, !"Вы не около фургона!");
			if (usemats[playerid] == 0)
			{
				SendClientMessage(playerid,COLOR_GRAD1, "У вас нет материалов с собой");
				format(string_, sizeof string_, "Материалов в фургоне: %d/"#CARAVAN_MATERIALS_LIMITS"", gVehicleGun[vehicleid][vGunAmmo]);
				SendClientMessage(playerid, TEAM_GROVE_COLOR, string_);
				return 1;
			}
	        if (gVehicleGun[vehicleid][vGunAmmo] >= CARAVAN_MATERIALS_LIMITS) return SendClientMessage(playerid,COLOR_GRAD1, "Фургон заполнен");
			SendClientMessage(playerid, COLOR_WHITE, !"Вы положили в фургон 500 матов");
			gVehicleGun[vehicleid][vGunAmmo] += 500;
			usemats[playerid] = 0; 
			DeletePVar(playerid, "Player:ArmyAreaID");
			if (IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
			format(string_, sizeof string_, "Материалов в фургоне: %d/"#CARAVAN_MATERIALS_LIMITS"", gVehicleGun[vehicleid][vGunAmmo]);
			SendClientMessage(playerid, TEAM_GROVE_COLOR, string_);
			SetPlayerSpecialAction (playerid, SPECIAL_ACTION_NONE);
		}
		else if (strcmp(params[0], "get",true) == 0)
		{
		    if (!IsAGang(playerid)) return 1; 
			if (IsPlayerInRangeOfPoint(playerid, 10.0, -1290.9072,501.4489,11.1953) && GetPlayerVirtualWorld(playerid) == 0)//SFA
			{
				if (FractionInfo[3][fMaterials] < 250)return SendClientMessage(playerid,COLOR_GRAD1, "Склад армии пуст");
				if (usemats[playerid] != 0) return SendClientMessage(playerid,COLOR_GRAD1, "Вы не можете взять больше");
				SendClientMessage(playerid, 0x6495EDFF, "Вы взяли 250 материалов со склада армии");
				SendClientMessage(playerid, COLOR_WHITE, !"Несите ящик в грузовик, используйте /materials put, чтобы положить материалы в фургон");
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_CARRY);
				SetPlayerAttachedObject(playerid, 1 , 2358, 1,0.11,0.36,0.0,0.0,90.0);
				usemats[playerid] = 1;
				FractionInfo[3][fMaterials] -= 250;
				SaveFractionInfoID(FractionInfo[3][fID], false);
			}
			/*if (IsPlayerInRangeOfPoint(playerid, 2.0,2729.3267,-2451.5051,17.5937))//Пикап на улице
			{
				if (lsamatbi < 250)return SendClientMessage(playerid,COLOR_GRAD1, "Склад армии пуст");
				if (usemats[playerid] != 0) return SendClientMessage(playerid,COLOR_GRAD1, "Вы не можете взять больше");
				SendClientMessage(playerid, 0x6495EDFF, "Вы взяли 250 материалов со склада армии");
				SendClientMessage(playerid, COLOR_WHITE, !"Несите ящик в грузовик, используйте /materials put, чтобы положить материалы в фургон");
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_CARRY);
				SetPlayerAttachedObject(playerid, 1 , 2358, 1,0.11,0.36,0.0,0.0,90.0);
				usemats[playerid] = 2;
				lsamatbi -= 250;
				new t_query[64];
				format(t_query, sizeof(t_query),"UPDATE `s_others` SET `mats_lsa`= '%d'", lsamatbi);
				mysql_tquery(dbHandle, t_query, "", "");
			}*/
			if (IsPlayerInRangeOfPoint(playerid, 10.0,316.8127,-167.5395,999.5938) && GetPlayerVirtualWorld(playerid) == 23)//LVA
			{
				if (FractionInfo[19][fMaterials] < 250) return SendClientMessage(playerid,COLOR_GRAD1, "Склад армии пуст");
				if (usemats[playerid] != 0) return SendClientMessage(playerid,COLOR_GRAD1, "Вы не можете взять больше");
				SendClientMessage(playerid, 0x6495EDFF, !"Вы взяли 250 материалов со склада армии");
				SendClientMessage(playerid, COLOR_WHITE, !"Несите ящик в грузовик, используйте /materials put, чтобы положить материалы в фургон");
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_CARRY);
				SetPlayerAttachedObject(playerid, 1 , 2358, 1,0.11,0.36,0.0,0.0,90.0);
				usemats[playerid] = 3;
				FractionInfo[19][fMaterials] -= 250;
				SaveFractionInfoID(FractionInfo[19][fID], false);
			}
		}
		return 1;
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Данная функция доступна только бандам/мафиози/армиям!");
	return 1;
}


CMD:callsign( playerid, params[] ) 
{
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не находитесь в машине"); 
	if (sscanf(params, "s[60]", params[0]) || strlen(params[0]) > 60) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /callsign [текст]");	
	new 
		V_IDX = GetPlayerVehicleID(playerid); 
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
		(VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_LSPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_SFPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_LVPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_FBI))
	{
		if (VehicleInfo[ V_IDX - 1 ][vText] == Text3D:-1) {
			VehicleInfo[ V_IDX - 1 ][vText] = CreateDynamic3DTextLabel(params[0], 0x999999FF,
				VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2],
				7.6, INVALID_PLAYER_ID, VehicleInfo[ V_IDX - 1 ][vVehicle], 0,0, 0, -1
			); 
			AttachDynamic3DTextLabelToVeh(VehicleInfo[ V_IDX - 1 ][vText], VehicleInfo[ V_IDX - 1 ][vVehicle], -1.0, -2.5, 0.25);
			new
				string_[256];
			format(string_, sizeof string_, "[R] %s %s: установил маркировку: %s (( /dellsign %d ))",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0], V_IDX);
			SendRadioMessage(pInfo[playerid][pMember], TEAM_BLUE_COLOR, string_);
		}
		else { 
			DestroyDynamic3DTextLabel(VehicleInfo[ V_IDX - 1 ][vText]);
			VehicleInfo[ V_IDX - 1 ][vText] = Text3D:-1; 
		} 
	}
	else SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в полицейской машине");  
	return 1;
}
CMD:dellsign( playerid, params[] )
{
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	new
		string_[256];
	if (pInfo[playerid][pRank] < fInfo[ pInfo[playerid][pMember] ][fHelper][0]) {
		format(string_, sizeof string_, "Данная команда доступна с %i ранга", fInfo[ pInfo[playerid][pMember] ][fHelper][0]);
		SendClientMessage(playerid, COLOR_GREY, string_);
		return 1;
	}
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /dellsign [ID]");
	if (params[0] < 1 || params[0] > S_VEHICLE_COUNT) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID"); /* S_VEHICLE_COUNT - Переменная серверного ТС */
	if (pInfo[playerid][pAdmin] == 0) {
		if (VehicleInfo[ params[0] - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ params[0] - 1 ][vFraction] != pInfo[playerid][pMember])) 
			return SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт не принадлежит Вашей организации!");
	}
	
	if (VehicleInfo[ params[0] - 1 ][vText] != Text3D:-1)
	{
		DestroyDynamic3DTextLabel(VehicleInfo[ params[0] - 1 ][vText]);
		VehicleInfo[ params[0] - 1 ][vText] = Text3D:-1;  
		SendClientMessage(playerid, COLOR_LI_RED, "[Информация] "colwhi"Маркировка транспорта была удалена!");
		return true;
	}
	else SendClientMessage(playerid, COLOR_LI_RED, "[Информация] "colwhi"Никто из сотрудников не устанавливал маркировку");
	return 1;
}
 




CMD:repaydebt(playerid, params[])
{
    if (pInfo[playerid][pJob] == 0) return 1;
    new string_[128], query_[128];
    if (pInfo[playerid][pDolg] < 50) return SendClientMessage(playerid, COLOR_GRAD1, "Не достаточная сумма, для возврата долга!");
    if (kLibGetPlayerMoney(playerid) < pInfo[playerid][pDolg]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег!");
	switch(pInfo[playerid][pKrisha])
	{
		case 6:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Долг был возвращён мафии Yakuza!");
			format(string_, sizeof string_, "%s вернул долг в размере $%d",pInfo[playerid][pName], pInfo[playerid][pDolg]);
			SendFamilyMessage(pInfo[playerid][pKrisha], COLOR_YELLOW2, string_);
			kLibGivePlayerMoney(playerid, -pInfo[playerid][pDolg], "/repaydebt 1");
			FractionInfo[pInfo[playerid][pKrisha]][fMoney] += pInfo[playerid][pDolg] ;
			pInfo[playerid][pDolg] = 0;
			SaveFractionInfoID(FractionInfo[pInfo[playerid][pKrisha]][fID], false);
		}
		case 5:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Долг был возвращён LCN!");
			format(string_, sizeof string_, "%s вернул долг в размере $%d",pInfo[playerid][pName], pInfo[playerid][pDolg]);
			SendFamilyMessage(pInfo[playerid][pKrisha], COLOR_YELLOW2, string_);
			kLibGivePlayerMoney(playerid, -pInfo[playerid][pDolg], "/repaydebt 2");
			FractionInfo[pInfo[playerid][pKrisha]][fMoney] += pInfo[playerid][pDolg] ;
			pInfo[playerid][pDolg] = 0;
			SaveFractionInfoID(FractionInfo[pInfo[playerid][pKrisha]][fID], false);
		}
		case 14:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Долг был возвращён Русской мафии!");
			format(string_, sizeof string_, "%s вернул долг в размере $%d",pInfo[playerid][pName], pInfo[playerid][pDolg]);
			SendFamilyMessage(pInfo[playerid][pKrisha], COLOR_YELLOW2, string_);
			kLibGivePlayerMoney(playerid, -pInfo[playerid][pDolg], "/repaydebt 3");
			FractionInfo[pInfo[playerid][pKrisha]][fMoney] += pInfo[playerid][pDolg] ;
			pInfo[playerid][pDolg] = 0;
			SaveFractionInfoID(FractionInfo[pInfo[playerid][pKrisha]][fID], false);
		}
		default: SendClientMessage(playerid, COLOR_YELLOW, "У Вас нет крыши!");
	}
	format(query_, sizeof query_, "UPDATE `s_users` SET `pDolg` = '%d' WHERE `Name` = '%s'", pInfo[playerid][pDolg], pInfo[playerid][pName]);
	return mysql_tquery(dbHandle, query_, "", "");
}
CMD:mydebts(playerid, params[])
{
    if (pInfo[playerid][pJob] == 0) return 1;
	new mafiatext[20], string_[64];
	if (pInfo[playerid][pKrisha] == 6) mafiatext = "Yakuza";
	else if (pInfo[playerid][pKrisha] == 14) mafiatext = "RM";
	else if (pInfo[playerid][pKrisha] == 5) mafiatext = "LCN";
	else if (pInfo[playerid][pKrisha] == 0) mafiatext = "Нет";
	format(string_,sizeof(string_), "Крыша: %s\nДолг: $%d", mafiatext, pInfo[playerid][pDolg]);
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Информация о себе",string_, "Готово", "");
	return 1;
}
CMD:fgstyle(playerid)
{
    if (pInfo[playerid][pJob] != 6) return 1;
	if (!IsPlayerInRangeOfPoint(playerid,30.0,768.1588,6.5715,1000.7144)) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в спортзале...");
	ShowPlayerDialog(playerid, D_PLAYER_FIHGT_0, DIALOG_STYLE_LIST, "Уроки боевых искусств", "[0] Начать урок по стилю Box\n[1] Начать урок по стилю Kong - Fu\n[2] Начать урок по стилю Kick - Box\n[3] Завершить урок Box\n[4] Завершить урок Kong - Fu\n[5] Завершить урок Kick - Box", "Выбрать", "Отмена");
	return 1;
}

CMD:busdrivers(playerid, params[])
{
	new null[13] ;
	t_string[0] = EOS;
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue;
		if (GetPVarInt(i,"TypeBus")) null[GetPVarInt(i,"TypeBus")]++, null[0]++;
	}
	if (!null[0]) return SendClientMessage(playerid, COLOR_GREY, !"Нет водителей автобуса!");
	null[7] = 100 / null[0] * null[1];
	null[8] = 100 / null[0] * null[2];
	null[9] = 100 / null[0] * null[3];
	null[10] = 100 / null[0] * null[4];
	null[11] = 100 / null[0] * null[5];
	null[12] = 100 / null[0] * null[6];
	format(t_string, sizeof t_string,			"Всего водителей: %d человек\n\n\
									ВнутриГородской ЛС\t\t\t\t[%s]%d%% %d человек\n\
									ВнутриГородской СФ\t\t\t\t[%s]%d%% %d человек\n\
									ВнутриГородской ЛВ\t\t\t\t[%s]%d%% %d человек\n", null[0],
									ToDevelopSkills(null[7], 100 - null[7]), null[7], null[1],
									ToDevelopSkills(null[8], 100 - null[8]), null[8], null[2],
									ToDevelopSkills(null[9], 100 - null[9]), null[9], null[3]);
	format(t_string, sizeof t_string,			"%sАвтоВокзал LS << >> Автошкола SF\t\t[%s]%d%% %d человек\n\
									АвтоВокзал LS << >> АвтоВокзал LV\t\t[%s]%d%% %d человек\n\
									АвтоВокзал LS << >> Заводы\t\t\t[%s]%d%% %d человек", t_string,
									ToDevelopSkills(null[10], 100 - null[10]), null[10], null[4],
									ToDevelopSkills(null[11], 100 - null[11]), null[11], null[5],
									ToDevelopSkills(null[12], 100 - null[12]), null[12], null[6]);
	return ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX," ",  t_string, "Готово", "");
}
CMD:ratingnews(playerid)
{
    /*new radioall = 0,
		Float: points[3];
	t_string[0] = EOS;
	new ratingGNews = 0,
		ratingLNews = 0,
		ratingLvNews = 0;
		
	new Float: procls = 0, Float: procsf = 0, Float: proclv = 0;

	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue;
		if (gNews[i] == false) ratingGNews++, radioall++;
		if (lNews[i] == false) ratingLNews++, radioall++;
		if (LvNews[i] == false) ratingLvNews++, radioall++;
	}
	if (radioall && ratingLNews)
		procls = 100 / radioall * ratingLNews;
	if (radioall && ratingGNews)
		procsf = 100 / radioall * ratingGNews;
	if (radioall && ratingLvNews)
		proclv = 100 / radioall * ratingLvNews;
	points[0] = 100 - procls;
	points[1] = 100 - procsf;
	points[2] = 100 - proclv;
	format(t_string, sizeof t_string,"\t\t<< Количество слушателей >>\n\n\
	LS News:\t[%s]%d%%\n\
	SF News:\t[%s]%d%%\n\
	LV News:\t[%s]%d%%\n",
	ToDevelopSkills(floatround(procls), floatround(points[0])), floatround(procls),
	ToDevelopSkills(floatround(procsf), floatround(points[1])), floatround(procsf),
	ToDevelopSkills(floatround(proclv), floatround(points[2])), floatround(proclv));
	return ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX," ", t_string,"Готово","");*/
	new radioall = 0,
		Float: points[3];
	t_string[0] = EOS;
	new ratingGNews = 0,
		ratingLNews = 0,
		ratingLvNews = 0;

	new Float: procls = 0, Float: procsf = 0, Float: proclv = 0;

	foreach(new i: PlayerInLogin)
	{
		if (gNews[i] == false) ratingGNews++, radioall++;
		if (lNews[i] == false) ratingLNews++, radioall++;
		if (LvNews[i] == false) ratingLvNews++, radioall++;
	}
	if (radioall && ratingLNews)
		procls = 100 / radioall * ratingLNews;
	if (radioall && ratingGNews)
		procsf = 100 / radioall * ratingGNews;
	if (radioall && ratingLvNews)
		proclv = 100 / radioall * ratingLvNews;
	points[0] = 100 - procls;
	points[1] = 100 - procsf;
	points[2] = 100 - proclv;
	format(t_string, sizeof t_string,"\t\t<< Количество слушателей >>\n\n\
	"colwhi"LS News:\t[%s]%d%% (%d Человек)\nSF News:\t[%s]%d%% (%d Человек)\nLV News:\t[%s]%d%% (%d Человек)\n",
	ToDevelopSkills(floatround(procls), floatround(points[0])), floatround(procls), ratingLNews,
	ToDevelopSkills(floatround(procsf), floatround(points[1])), floatround(procsf), ratingGNews,
	ToDevelopSkills(floatround(proclv), floatround(points[2])), floatround(proclv), ratingLvNews);
	return ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX," ", t_string,"Готово","");
}





CMD:gettax(playerid, params[])
{
    if (!IsAMayor(playerid)) return 1;
	return SendMes(playerid, COLOR_WHITE, "В казне: $%d", FractionInfo[7][fMoney]);
}
CMD:settax(playerid, params[])
{
	if (!IsAMayor(playerid)) return 1;
	if (pInfo[playerid][pRank] < 5) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная функция!");
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /settax [налог]");
	if (params[0] < 1 || params[0] > 1000) return SendClientMessage(playerid, COLOR_GREY, !"Сумма должна быть от 1 до 1000 $");
	FractionInfo[7][fTaxState] = params[0];
	SaveFractionInfoID(FractionInfo[7][fID], false);
	return SendClientMessage(playerid, COLOR_GRAD2, !"Вы установили налог!");
}
CMD:selleat(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pInfo[playerid][pJob] != 3) return 1;
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /selleat [playerid]");
	new V_IDX = GetPlayerVehicleID(playerid);
    if ((VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && VehicleInfo[ V_IDX - 1 ][vFraction] != PLAYER_JOB_HOTDOG_SALLER) && !GetPVarInt(playerid,"h_stall")) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете продать хот дог");
	if (!GetPVarInt(playerid,"h_contract")) return SendClientMessage(playerid, COLOR_GREY, !"Вы не заключили контракт с закусочной");
	if (GetPlayerVehicleID(playerid) != pTemp[playerid][pRentCar] && !GetPVarInt(playerid,"h_stall")) return SendClientMessage(playerid, COLOR_GREY, !"Это не ваш автомобиль");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами");
	new string_[128];
	format(string_,sizeof string_, "Вы предложили %s ХотДог за $%d", pInfo[params[0]][pName], GetPVarInt(playerid,"h_price"));
	SendClientMessage(playerid,0x6495EDFF, string_);
	format(string_,sizeof string_, "%s предлагает Вам ХотДог за $%d. (( Введите: /(ac)cept hotdog для покупки ХотДога ))", pInfo[playerid][pName], GetPVarInt(playerid,"h_price"));
	SendClientMessage(params[0],0x6495EDFF, string_);
	SetPVarInt(params[0],"h_id",playerid+1);
	return 1;
} 

CMD:payeu(playerid, params[])
{
	if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /payeu [id] [сумма]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (SpecAd[params[0]] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Вы слишком далеко.");
	if ((params[1] > 1000 && pInfo[playerid][pLevel] < 1) || (params[1] > 10000 && pInfo[playerid][pLevel] < 2)) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы должны быть 2 лвл, чтобы передать больше 1000 Euro!");
	new
	string_[128];
	if (!IsPlayerInRangeOfPlayer(5.0, playerid, params[0]) || GetPlayerState(params[0]) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы слишком далеко.");
	if (kLibGetPlayerMoney(playerid) < params[1]) return 1;
	kLibGivePlayerEuro(params[0], params[1]);
	kLibGivePlayerEuro(playerid, -params[1]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);

	format(string_, sizeof string_, "Вы передали %s[%d] %d Euro",pInfo[params[0]][pName],params[0],params[1]);
	SendClientMessage(playerid, COLOR_GRAD1, string_);
	format(string_, sizeof string_, "Вы получили %d Euro от %s[%d]",params[1],pInfo[playerid][pName], playerid);
	SendClientMessage(params[0], COLOR_GRAD1, string_);
	format(string_, sizeof string_, "достал бумажник и передал деньги %s",pInfo[params[0]][pName]);
	SetPlayerChatBubble(playerid,string_,COLOR_PURPLE,30.0,10000);
	return 1;
}

CMD:pay(playerid, params[])
{
	if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /pay [id] [сумма]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (SpecAd[params[0]] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Вы слишком далеко.");
	if ((params[1] > 1000 && pInfo[playerid][pLevel] < 1) || (params[1] > 10000 && pInfo[playerid][pLevel] < 2)) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы должны быть 2 лвл, чтобы передать больше $1000!");
	new
	string_[128];
	if (params[1] < 1 || params[1] > GetVIPLimitPayCash(playerid)) {
	format(string_, sizeof string_, "Нельзя передать меньше 1 и больше $%d", GetVIPLimitPayCash(playerid));
	return SendClientMessage(playerid, COLOR_GRAD1, string_), string_[0] = EOS;
	}
	if (!IsPlayerInRangeOfPlayer(5.0, playerid, params[0]) || GetPlayerState(params[0]) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы слишком далеко.");
	if (kLibGetPlayerMoney(playerid) < params[1]) return 1;
	kLibGivePlayerMoney(params[0], params[1], "(/pay)", playerid);
	kLibGivePlayerMoney(playerid, -params[1], "(/pay)", params[0]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);
	OnPlayerAchievProgress(playerid, 25, params[1]);
	format(string_, sizeof string_, "Вы передали %s[%d] $%d",pInfo[params[0]][pName],params[0],params[1]);
	SendClientMessage(playerid, COLOR_GRAD1, string_);
	format(string_, sizeof string_, "Вы получили $%d от %s[%d]",params[1],pInfo[playerid][pName], playerid);
	SendClientMessage(params[0], COLOR_GRAD1, string_);
	format(string_, sizeof string_, "достал бумажник и передал деньги %s",pInfo[params[0]][pName]);
	SetPlayerChatBubble(playerid,string_,COLOR_PURPLE,30.0,10000);
	return 1;
}

CMD:number(playerid, params[])
{
	new string_[128];
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /number [id]");
	if (!PlayerInConnected(params[0])) return 1;
	format(string_, sizeof(string_), "Владелец: %s. Телефон: %d",pInfo[params[0]][pName],pInfo[params[0]][PlayerNumber]);
	return scm(playerid, COLOR_WHITE, string_);
}

CMD:rb(playerid, params[])
{ 
	if (!IsACop(playerid) && !IsAMedic(playerid) && !IsAArmy(playerid) && !IsANews(playerid) && !IsALicenser(playerid) && !IsAMayor(playerid)) return true;
	if (!pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, "Вам необходимо начать рабочий день!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);  
	if (!IsPlayerGetSettings(playerid, setFractionChat)) return SendClientMessage(playerid, COLOR_GREY, !"Включите чат организации в настройках (/mm - Настройки)"); 
	new  
		string_[200];
	if (pInfo[playerid][FractionMute] > 0) {
	    format(string_, sizeof string_, "У Вас бан чата организации! До снятия: %d секунд(ы)", pInfo[playerid][FractionMute]);
	    SendClientMessage(playerid, COLOR_YELLOW, string_);
		return 1;
	}
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /rb [текст]");
	
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	pTemp[playerid][AntiFloodText] = gettime()+2;  

	format(string_, sizeof string_, "(( [R] %s %s: %s ))", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
	SendRadioMessage(pInfo[playerid][pMember], TEAM_BLUE_COLOR, string_);
	if (tipsteron == pInfo[playerid][pMember]) {
		foreach(new i: PlayerInLogin) {
			if (!pInfo[i][pLogin]) continue;
			if (tipsterlisten[i]) {
				SendClientMessage(i, COLOR_LIGHTRED, string_);
			}
		}
	}
	return 1;
}
CMD:rr(playerid, params[])
{ 
	if (!IsAMedic(playerid)) return true;
	if (!pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, "Вам необходимо начать рабочий день!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);  
	if (!IsPlayerGetSettings(playerid, setFractionChat)) return SendClientMessage(playerid, COLOR_GREY, !"Включите чат организации в настройках (/mm - Настройки)"); 
	new  
		string_[200];
	if (pInfo[playerid][FractionMute] > 0) {
	    format(string_, sizeof string_, "У Вас бан чата организации! До снятия: %d секунд(ы)", pInfo[playerid][FractionMute]);
	    SendClientMessage(playerid, COLOR_YELLOW, string_);
		return 1;
	}
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_GRAD2, "Введите: (/rr) [текст]");
	
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	pTemp[playerid][AntiFloodText] = gettime()+2; 

	format(string_, sizeof string_, "[RR] %s %s: %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
	if (tipsteron == pInfo[playerid][pMember]) {
		foreach(new i: PlayerInLogin) {
			if (!pInfo[i][pLogin]) continue;
			if (tipsterlisten[i]) {
				SendClientMessage(i, COLOR_LIGHTRED, string_);
			}
		}
	}
	SendHospitalMessage(COLOR_ALLDEPT, string_);
	return 1;
}
CMD:r(playerid, params[])
{ 
	if (!IsACop(playerid) && !IsAMedic(playerid) && !IsAArmy(playerid) && !IsANews(playerid) && !IsALicenser(playerid) && !IsAMayor(playerid)) return true;
	if (!pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, "Вам необходимо начать рабочий день!");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);  
	if (!IsPlayerGetSettings(playerid, setFractionChat)) return SendClientMessage(playerid, COLOR_GREY, !"Включите чат организации в настройках (/mm - Настройки)"); 
	new  
		string_[200];
	if (pInfo[playerid][FractionMute] > 0) {
	    format(string_, sizeof string_, "У Вас бан чата организации! До снятия: %d секунд(ы)", pInfo[playerid][FractionMute]);
	    SendClientMessage(playerid, COLOR_YELLOW, string_);
		return 1;
	}
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_GRAD2, "Введите: (/r)adio [текст]");
	
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	pTemp[playerid][AntiFloodText] = gettime()+2; 

	format(string_, sizeof string_, "[R] %s %s: %s", fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
	SendRadioMessage(pInfo[playerid][pMember], TEAM_BLUE_COLOR, string_);
	if (tipsteron == pInfo[playerid][pMember]) {
		foreach(new i: PlayerInLogin) {
			if (!pInfo[i][pLogin]) continue;
			if (tipsterlisten[i]) {
				SendClientMessage(i, COLOR_LIGHTRED, string_);
			}
		}
	}
	return 1;
} 
new	
	departamentsCoolDown = 0;
CMD:departments(playerid, params[])
{
	new string_[200];
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/d)epartments [текст]");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (pInfo[playerid][FractionMute] > 0) {
	    format(string_, sizeof string_, "У Вас бан чата организации! До снятия: %d секунд(ы)", pInfo[playerid][FractionMute]);
	    SendClientMessage(playerid, COLOR_YELLOW, string_);
		return 1;
	}
	if (pInfo[playerid][pRank] < 2) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не уполномочены писать в департамент!");
	if (!pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, "Вам необходимо начать рабочий день!");
	if (departamentsCoolDown > gettime()) return SendClientMessage(playerid, COLOR_GREY, !"Посылать сообщение в можно раз в 10 секунд!");
	switch(pInfo[playerid][pMember])
	{
		case FRACTION_LSPD: format(string_, sizeof string_, "[LSPD] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_FBI: format(string_, sizeof string_, "[FBI] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_ARMY_SF: format(string_, sizeof string_, "[ВМС] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_HOSPITAL_SF, FRACTION_HOSPITAL_LS, FRACTION_HOSPITAL_LV: format(string_, sizeof string_, "[MOH] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_CITYHALL: format(string_, sizeof string_, "[Mayor] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_SFPD: format(string_, sizeof string_, "[SFPD] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_ARMY_LV: format(string_, sizeof string_, "[СВ] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_LVPD: format(string_, sizeof string_, "[LVPD] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		case FRACTION_AUTOSCHOOL: format(string_, sizeof string_, "[Instructors] %s %s: %s",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0]);
		default: return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная функция");
	}
    SendTeamMessage(COLOR_ALLDEPT, string_);
	departamentsCoolDown = gettime() + 10;
	return 1;
}
new strR[255][255];
CMD:sms(playerid, params[])
{
    if (pInfo[playerid][pLevel] >= 1 && pInfo[playerid][pLevel] <= 2)
    if (sms_timer[playerid] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Для игроков с уровнем ниже 3, работает лимит 1 смс в 30 секунд!");
    if (strlen(params[1]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "ds[128]",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sms [playerid / phonenumber] [текст]");
	if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);

	new is1=1, string_[144];
	new r=0;
	while(strlen(params[is1]))
	{
		if ('0'<=params[is1]<='9')
		{
			new is2=is1+1;
			new p=0;
			while(p==0)
			{
				if ('0'<=params[is2]<='9'&&strlen(params[is2])) is2++;
				else
				{
					strmid(strR[r],params,is1,is2,255);
					if (strval(strR[r])<255) r++;
					is1=is2;
					p=1;
					sms_timer[playerid] = 30;
				}
			}
		}
		is1++;
	}
	if (r>=4)
	{
		format(string_, sizeof(string_), "SMS: Login: %s[%d] %s",pInfo[playerid][pName],playerid,params[1]);
		ABroadCast(COLOR_LIGHTRED, string_, 1);
		return 1;
	}
	/*if (strfind(params[1],"www",true) != -1 || strfind(params[1],".ru",true) != -1 ||
	strfind(params[1],".net",true) != -1 || strfind(params[1],".com",true) != -1 || strfind(params[1],"http",true) != -1)
	{
		format(string_, sizeof(string_), "SMS: Login: %s[%d] %s",pInfo[playerid][pName],playerid,params[1]);
		ABroadCast(COLOR_LIGHTRED, string_, 1);
		format(string_,sizeof(string_),"Вы получили бан чата на 3 часа. /mm - репорт");
		SendClientMessage(playerid, COLOR_LIGHTRED, string_);
		pInfo[playerid][pMuted] = 10800000;
		return 1;
	}*/
	GetPlayerPos(playerid,CallInfo[playerid][callx],CallInfo[playerid][cally],CallInfo[playerid][callz]);
	CallInfo[playerid][callused] = true;
	switch (params[0])
	{
		case 11888:
		{
			if (!SmsNewsEnter[0]) return SendClientMessage(playerid, COLOR_GREY, !"Приём SMS отключен");
			if (pInfo[playerid][pBank] < pInfo[playerid][pMobile])
			{
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средст на банковском счету!");
				return 1;
			}
			format(string_, sizeof(string_), "[Эфир] %s. Отправитель: %s[%d]",params[1],pInfo[playerid][pName], playerid);
			SendFamilyMessage(16, COLOR_YELLOW, string_);
			format(string_, sizeof(string_), "SMS: %s. Получатель: LS NEWS",params[1]);
			SendClientMessage(playerid,  COLOR_YELLOW, string_);
			pInfo[playerid][pMobile] += fInfo[16][fCost][1];
			FractionInfo[16][fMoney] += fInfo[16][fCost][1];
			SaveFractionInfoID(FractionInfo[16][fID], false);
			return 1;
		}
		case 11555:
		{
			if (!SmsNewsEnter[1]) return SendClientMessage(playerid, COLOR_GREY, !"Приём SMS отключен");
			if (pInfo[playerid][pBank] < pInfo[playerid][pMobile])
			{
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средст на банковском счету!");
				return 1;
			}
			format(string_, sizeof(string_), "[Эфир] %s. Отправитель: %s[%d]",params[1],pInfo[playerid][pName], playerid);
			SendFamilyMessage(9, COLOR_YELLOW, string_);
			format(string_, sizeof(string_), "SMS: %s. Получатель: SF NEWS",params[1]);
			SendClientMessage(playerid,  COLOR_YELLOW, string_);
			pInfo[playerid][pMobile] += fInfo[9][fCost][1];
			FractionInfo[9][fMoney] += fInfo[9][fCost][1];
			SaveFractionInfoID(FractionInfo[9][fID], false);
			return 1;
		} 
		case 11333:
		{
			if (!SmsNewsEnter[2]) return SendClientMessage(playerid, COLOR_GREY, !"Приём SMS отключен");
			if (pInfo[playerid][pBank] < pInfo[playerid][pMobile])
			{
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средст на банковском счету!");
				return 1;
			}
			format(string_, sizeof(string_), "[Эфир] %s. Отправитель: %s[%d]",params[1],pInfo[playerid][pName], playerid);
			SendFamilyMessage(20, COLOR_YELLOW, string_);
			format(string_, sizeof(string_), "SMS: %s. Получатель: LV NEWS",params[1]);
			SendClientMessage(playerid,  COLOR_YELLOW, string_);
			pInfo[playerid][pMobile] += fInfo[20][fCost][1];
			FractionInfo[20][fMoney] += fInfo[20][fCost][1];
			SaveFractionInfoID(FractionInfo[20][fID], false);
			return 1;
		}
	}
	
	new id = - 1,count_mobile = 2;
	if (IsPlayerConnected(params[0]))
	{
		id = params[0];
	}
	if (id == -1)
	{
		foreach(new i: PlayerInLogin)
		{
			if (params[0] == pInfo[i][PlayerNumber])
			{
				id = i;
				count_mobile = 20;
				break;
			}
		}
	}
	if (id == -1) return SendClientMessage(playerid,CGRAY2,!"Телефон на который Вы послали SMS выключен или находиться в не зоны действия сети");

	if (pTemp[id][PlayerPhoneOnline])
	{
		SendClientMessage(playerid, COLOR_GREY, !"Телефон абонента выключен.");
		format(string_, sizeof(string_), "%s достает телефон",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE,string_,5.0);
		return 1;
	}
	format(string_, sizeof(string_), "SMS: %s. Отправитель: %s[%d]",params[1],pInfo[playerid][pName], playerid);
	SendClientMessage(id, COLOR_YELLOW, string_);
	format(string_, sizeof(string_), "%s достает мобильник",pInfo[playerid][pName]);
	SendBeside(playerid,COLOR_PURPLE,string_,5.0);
	format(string_, sizeof(string_), "SMS: %s. Получатель: %s[%d]",params[1],pInfo[id][pName],id);
	SendClientMessage(playerid,  COLOR_YELLOW, string_);
	SendClientMessage(playerid,  COLOR_WHITE, !"Сообщение доставлено");

	pInfo[playerid][pMobile] += count_mobile;

	if (Iter_Count(AdminsTeam) > 0)
	{
	    format(string_,sizeof(string_),"[ASMS] %s[%d]* к %s[%d]: %s",pInfo[playerid][pName],playerid,pInfo[id][pName],id,params[1]);
	    foreach(new i: AdminsTeam)
	    {
	        if (player_sms_on{i} == 1)
	        {
	            SendClientMessage(i, 0xFFFF00FF,string_);
	        }
	    }
	}
	PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	return 1;
}
alias:sms("t", "txt");

CMD:yes(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /yes [id]");
	if (!IsPlayerConnected(params[0])) return 1;
	if (pTemp[params[0]][CallInNews] != true) return SendClientMessage(playerid, COLOR_GRAD1, !"Этот человек не звонил в студию!");
	SendMes(playerid, COLOR_WHITE, "Вы приняли звонок от %s",pInfo[params[0]][pName]);
	Tel[params[0]] = 1;
	SendClientMessage(params[0], COLOR_YELLOW, "Вы попали в студию, говорите.");
	if (pInfo[playerid][pMember] == 9) {
		TalkingLive[params[0]] = 1;
		pInfo[params[0]][pMobile] += fInfo[9][fCost][1];
		FractionInfo[9][fMoney] += fInfo[9][fCost][1];
		SaveFractionInfoID(FractionInfo[9][fID], false);
	}
	if (pInfo[playerid][pMember] == 16) {
		TalkingLivels[params[0]] = 1;
		pInfo[params[0]][pMobile] += fInfo[16][fCost][1];
		FractionInfo[16][fMoney] += fInfo[16][fCost][1];
		SaveFractionInfoID(FractionInfo[16][fID], false);
	}
	if (pInfo[playerid][pMember] == 20) {
		TalkingLivelv[params[0]] = 1;
		pInfo[params[0]][pMobile] += fInfo[20][fCost][1];
		FractionInfo[20][fMoney] += fInfo[20][fCost][1];
		SaveFractionInfoID(FractionInfo[20][fID], false);
	} 
	return 1;
}
CMD:off(playerid, params[])
{
    if (!IsANews(playerid)) return 1;
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /off [id]");
	if (!IsPlayerConnected(params[0])) return 1;
	if (pTemp[params[0]][CallInNews] != true) return SendClientMessage(playerid, COLOR_GRAD1, !"Этот человек не звонил в студию!");
	SendMes(playerid, COLOR_BLUE, "Вы завершили звонок от %s",pInfo[params[0]][pName]);
	SetPlayerSpecialAction(params[0],SPECIAL_ACTION_STOPUSECELLPHONE);
	SendClientMessage(params[0], COLOR_YELLOW, "Звонок завершён.");
	pTemp[params[0]][CallInNews] = false;
	Tel[params[0]] = 255;
	if (pInfo[playerid][pMember] == 9)
	{
		TalkingLive[params[0]] = 255;
	}
	if (pInfo[playerid][pMember] == 16)
	{
		TalkingLivels[params[0]] = 255;
	}
	if (pInfo[playerid][pMember] == 20)
	{
		TalkingLivelv[params[0]] = 255;
	} 
	return 1;
}
CMD:call(playerid, params[])
{
	new str_[44],
		string_[128];
    if (sscanf(params, "d",params[0]))
	{
	    if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя вызывать сервисы в здании!");
		format(str_, sizeof str_, "%s достает телефон",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,30.0);
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
		ShowPlayerDialog(playerid, D_SELECT_SERVICE_0, DIALOG_STYLE_LIST, "Выберите сервис", "[1] Полиция \n[2] Скорая помощь \n[3] Таксопарк\n[4] Автомастерская", "Выбор", "Отмена");
		return 1;
	}
	if (Mobile[playerid] != 999) return SendClientMessage(playerid, COLOR_GRAD2, "Вы уже разговариваете по телефону ");
	format(str_, sizeof str_, "%s достает телефон",pInfo[playerid][pName]);
	SendBeside(playerid,COLOR_PURPLE, str_,30.0);
	GetPlayerPos(playerid,CallInfo[playerid][callx],CallInfo[playerid][cally],CallInfo[playerid][callz]);
	CallInfo[playerid][callused] = true;
	if (params[0] == pInfo[playerid][PlayerNumber])
	{
		SendClientMessage(playerid, COLOR_GRAD2, "Линия занята");
		SetPlayerSpecialAction(playerid,13);
		return 1;
	}
	if (params[0] == 11888)
	{
		if (!SmsNewsEnter[0]) return SendClientMessage(playerid, COLOR_GREY, !"Прямой эфир отключен.");
		if (pInfo[playerid][pBank] < pInfo[playerid][pMobile])
		{
			SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средст на банковском счету!");
			return 1;
		}
		format(string_, sizeof string_, "В студию звонит: %s. Введите /yes [%d], чтобы ответить", pInfo[playerid][pName], playerid);
		SendFamilyMessage(16, COLOR_YELLOW, string_);
		SetPlayerSpecialAction(playerid,11);
		pTemp[playerid][CallInNews] = true;
		pInfo[playerid][pMobile] += fInfo[16][fCost][1];
		FractionInfo[16][fMoney] += fInfo[16][fCost][1];

		return 1;
	}
	if (params[0] == 11555)
	{
		if (!SmsNewsEnter[1]) return SendClientMessage(playerid, COLOR_GREY, !"Прямой эфир отключен.");
		if (pInfo[playerid][pBank] < pInfo[playerid][pMobile])
		{
			SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средст на банковском счету!");
			return 1;
		}
		format(string_, sizeof string_, "В студию звонит: %s. Введите /yes [%d], чтобы ответить",pInfo[playerid][pName], playerid);
		SendFamilyMessage(9, COLOR_YELLOW, string_);
		SetPlayerSpecialAction(playerid,11);
		pInfo[playerid][pMobile] += fInfo[9][fCost][1];
		FractionInfo[9][fMoney] += fInfo[9][fCost][1];
		pTemp[playerid][CallInNews] = true;
		return 1;
	}
	if (params[0] == 11333)
	{
		if (!SmsNewsEnter[2]) return SendClientMessage(playerid, COLOR_GREY, !"Прямой эфир отключен.");
		if (pInfo[playerid][pBank] < pInfo[playerid][pMobile])
		{
			SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средст на банковском счету!");
			return 1;
		}
		format(string_, sizeof string_, "В студию звонит: %s. Введите /yes [%d], чтобы ответить",pInfo[playerid][pName], playerid);
		SendFamilyMessage(20, COLOR_YELLOW, string_);
		SetPlayerSpecialAction(playerid,11);
		pInfo[playerid][pMobile] += fInfo[20][fCost][1];
		FractionInfo[20][fMoney] += fInfo[20][fCost][1];
		pTemp[playerid][CallInNews] = true;
		return 1;
	}
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue;
		if (pInfo[i][PlayerNumber] == params[0] && params[0] != 0)
		{
			Mobile[playerid] = i;
			if (!IsPlayerConnected(i)) return 1;
			if (pTemp[Mobile[playerid]][PlayerPhoneOnline] == true) return SendClientMessage(playerid, COLOR_GREY, !"Телефон абонента выключен...");
			if (Mobile[Mobile[playerid]] == 999)
			{
				SendMes(Mobile[playerid], COLOR_WHITE, "Ваш мобильник звонит. Введите (/P)ickup. Звонит: %s",pInfo[playerid][pName]);
				PlayerPlaySound(Mobile[playerid], 20600, 0.0, 0.0, 0.0);
				format(string_, sizeof string_, "У %s звонит мобильник",pInfo[i][pName]);
				SendBeside(i,COLOR_PURPLE, string_,30.0);
				SetPlayerSpecialAction(playerid,11);
				CellTime[playerid] = 1;
				return 1;
			}
		}
	}
	if (Mobile[playerid] == -1)
	{
		SendClientMessage(playerid, COLOR_GRAD2, !"Телефон вне зоны доступа сети");
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
		return 1;
	}
	return 1;
}
alias:call("c");
CMD:pickup(playerid, params[])
{
    if (Mobile[playerid] != 999) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы уже разговариваете");
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue; 
		if (Mobile[i] == playerid) {
			Mobile[playerid] = i;
			SendClientMessage(i, COLOR_GRAD2, !"Поднял(а) трубку телефона.");
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
			new str_[64];
			format(str_, sizeof str_, "%s ответил на звонок", pInfo[playerid][pName]);
			SendBeside(playerid,COLOR_PURPLE, str_,30.0);
			PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);
			GetPlayerPos(playerid,CallInfo[playerid][callx],CallInfo[playerid][cally],CallInfo[playerid][callz]);
			CallInfo[playerid][callused] = true;
		} 
	}
	return 1;
}
alias:pickup("p");
CMD:hangup(playerid, params[])
{
	if (IsPlayerConnected(Mobile[playerid]))
	{
		if (Mobile[playerid] != 999)
		{
			SendClientMessage(Mobile[playerid], COLOR_GRAD2, "Абонент положил(a) трубку");
			SetPlayerSpecialAction(Mobile[playerid],SPECIAL_ACTION_STOPUSECELLPHONE);
			CellTime[Mobile[playerid]] = 0;
			CellTime[playerid] = 0;
			Mobile[Mobile[playerid]] = 999;
			SendClientMessage(playerid, COLOR_GRAD2, "Вы повесили трубку");
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
		}
		Mobile[playerid] = 999;
		Mobile[Mobile[playerid]] = 999;
		CellTime[playerid] = 0;
		return 1;
	}
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
	TalkingLive[playerid] = 255;
	TalkingLivels[playerid] = 255;
	TalkingLivelv[playerid] = 255;
	pTemp[playerid][CallInNews] = false;
	Tel[playerid] = 255;
	return 1;
}
CMD:advertise(playerid, params[])
{
    if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (pInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, COLOR_GREY, !"Подать обьявление можно с 3 левела");
	if (gNews[playerid] == true && lNews[playerid] == true && LvNews[playerid] == true) return SendClientMessage(playerid, COLOR_WHITE, !"Сначала включите радио");
	if (pInfo[playerid][tAdvertTimer] > gettime()) return SendClientMessage(playerid, COLOR_GREY, "Посылать объявление можно раз в 60 секунд!");
//	if (gFraction[ frac_id[newsid] ][fCoolDown] > gettime()) return SendClientMessage(playerid, COLOR_GREY, !"Посылать объявление можно раз в 15 секунд!");
	if (strlen(params) > 78) return SendClientMessage(playerid, COLOR_GREY, !"Максимальная длина объявления - 78 символов");
	if (isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/ad)vertise [текст]");
	if(!Reklama(playerid, params)) return 1;
 	new string_[356];
	strcat(string_,params);
	SetPVarString(playerid, "advert", string_);

	SetPVarInt(playerid, "ad_price", strlen(string_) * fInfo[16][fCost][0]);
	if (!lNews[playerid])
	    SetPVarInt(playerid, "ad_price", strlen(string_) * fInfo[16][fCost][0]);
	else if (!gNews[playerid])
	    SetPVarInt(playerid, "ad_price", strlen(string_) * fInfo[9][fCost][0]);
	else if (!LvNews[playerid])
	    SetPVarInt(playerid, "ad_price", strlen(string_) * fInfo[20][fCost][0]);

	if (lNews[playerid] == false)
	{
		format(string_, sizeof string_, "{B8B8B8}Вы собираетесь отправить объявление:\n\t\t\t{00FF5E}%s\n\n{B8B8B8}Стоимость:{00FF5E} $%d\n\n\n{56839C}Объявление будет подано после проверки!\nСпасибо что воспользовались услугами LS News",string_,GetPVarInt(playerid, "ad_price"));
		ShowPlayerDialog(playerid, D_NEWS_PANEL_14,DIALOG_STYLE_MSGBOX,"{FFFFFF}Проверка", string_,"Отправить","Отмена");
	}
	else if (gNews[playerid] == false)
	{
		format(string_, sizeof string_, "{B8B8B8}Вы собираетесь отправить объявление:\n\t\t\t{00FF5E}%s\n\n{B8B8B8}Стоимость:{00FF5E} $%d\n\n\n{56839C}Объявление будет подано после проверки!\nСпасибо что воспользовались услугами SF News",string_,GetPVarInt(playerid, "ad_price"));
		ShowPlayerDialog(playerid, D_NEWS_PANEL_15,DIALOG_STYLE_MSGBOX,"{FFFFFF}Проверка", string_,"Отправить","Отмена");
	}
	else if (LvNews[playerid] == false)
	{
		format(string_, sizeof string_, "{B8B8B8}Вы собираетесь отправить объявление:\n\t\t\t{00FF5E}%s\n\n{B8B8B8}Стоимость:{00FF5E} $%d\n\n\n{56839C}Объявление будет подано после проверки!\nСпасибо что воспользовались услугами LV News",string_,GetPVarInt(playerid, "ad_price"));
		ShowPlayerDialog(playerid, D_NEWS_PANEL_16,DIALOG_STYLE_MSGBOX,"{FFFFFF}Проверка", string_,"Отправить","Отмена");
	}
	return 1;
}
alias:advertise("ad");

CMD:time(playerid, params[])
{
	if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		if (GetPVarInt(playerid,"ClearAnimSI") > gettime()) return 1;
		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch",4.1,0,0,0,0,0); 
	}
	//SendMes(playerid, COLOR_GREY, "До бесплатной рулетки осталось: "colmaline"%s", Convert(10800 - pTemp[playerid][gTimeNoAFK]));
	 
	if (pInfo[playerid][pAdmin]) {
		SendMes(playerid, COLOR_YELLOW, "[A] "colgrey"Количество ответов: "colmaline"%d "colgrey"", aAdminInfo[playerid][aReport]); 
	}
	MeAction(playerid, "взглянул(а) на часы", SELECT_ACTION_IN_BUBBLE);
	new string_[144],
		gMonthNames[12][32] = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
	getdate(year, month, day);
	gettime(hour, minute, second);
	if (pInfo[playerid][pJailTime] > 0) {
		format(string_, sizeof string_, "~y~%02i %s~n~~g~~w~%02i:%02i~n~~w~Jail Time Left: %d sec~n~~g~Time played: ~y~%d~n~~g~Server 01",
			day, gMonthNames[month-1], hour, minute, pInfo[playerid][pJailTime],Convert(pInfo[playerid][pInGame]));
	}
	else {
		format(string_, sizeof string_, "~y~%02i %s~n~~g~~w~%02i:%02i~n~~g~Time played: ~y~%d~n~~g~Server 01",
			day, gMonthNames[month-1], hour, minute,Convert(pInfo[playerid][pInGame]));
	}
	GameTextForPlayer(playerid, string_, 6000, 1);
	return 1;
} 
CMD:abl(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new
		string_[256];
	if (pInfo[playerid][pRank] < fInfo[ pInfo[playerid][pMember] ][fHelper][0]) {
		format(string_, sizeof string_, "Данная команда доступна с %i ранга", fInfo[ pInfo[playerid][pMember] ][fHelper][0]);
		SendClientMessage(playerid, COLOR_GREY, string_);
		return 1;
	}
	if (sscanf(params, "u", params[0])) return scm(playerid, COLOR_GRAD2, !"Введите: /abl [id]");
	if (IsPlayerInBlackList(pInfo[params[0]][pName], pInfo[playerid][pMember]) == 1) scm(playerid, COLOR_WHITE, !"Игрок уже находиться в черном списке Вашей организации!");
	else
	{
	    SetPVarInt(playerid, "PlayerIDBlackList", params[0]);
	    ShowPlayerDialog(playerid, D_FRACTION_FUNC_19, 1, ""colserver"Черный список: "colwhi"Добавить", "{ffffff}Укажите сумму и причину занесения игрока в черный список организации\nПример: 8.000.000 $, Причина", "Занести", "Отмена");
	}
	return 1;
}


CMD:invite(playerid, params[])
{
    if (pInfo[playerid][pLeader] > 0 || pInfo[playerid][pMember] > 0)
	{ 
		new
			string_[256];
		if (pInfo[playerid][pRank] < fInfo[ pInfo[playerid][pMember] ][fHelper][0]) {
			format(string_, sizeof string_, "Данная команда доступна с %i ранга", fInfo[ pInfo[playerid][pMember] ][fHelper][0]);
			SendClientMessage(playerid, COLOR_GREY, string_);
			return 1;
		} 
		if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /invite [id]");
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
		if (GetPVarInt(params[0], "CasinoRank") == 1) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок работает в крупье");
		if (IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок в машине!");
		if (pInfo[params[0]][pMember] > 0 || pInfo[params[0]][pLeader] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже где то состоит");
		if (pInfo[params[0]][pWarns] > 0) return SendClientMessage(playerid, COLOR_GREY, !"У игрока Warn.");
		if (GetPVarInt(params[0], "PlayerIDBlackList")== 1) return SendClientMessage(playerid, COLOR_GRAD2,"У игрока черный список");
		new level = 1;
		if (IsACop(playerid)) level = ServerInviteSettings[0];
		else if (IsAGang(playerid)) 
		{
			/*new temp = capture_band( pInfo[playerid][pMember] );
			if (temp != INVALID_PLAYER_ID && pInfo[playerid][pAdmin] < 4) {
				if (capture_now[temp] != 0) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать во время капта!");
			}*/
			level = ServerInviteSettings[2];
		}
		else if (IsAMafia(playerid)) level = ServerInviteSettings[3];
		else if (IsAArmy(playerid)) level = ServerInviteSettings[4];
		else level = ServerInviteSettings[1];
		if (pInfo[params[0]][pLevel] < level) {
			return SendMes(playerid, COLOR_GREY, "Игрок должен иметь %d уровень!", level);
		}
		if (GetDistanceBetweenPlayers(playerid, params[0]) > 5.0) return SendClientMessage(playerid, COLOR_GREY, !"Вы слишком далеко!");
		if (IsPlayerInBlackList(pInfo[params[0]][pName], pInfo[playerid][pMember]) == 1) return scm(playerid, COLOR_WHITE, !"Игрок в черном списке организации!");
		
		format(string_, sizeof string_,"{FFFFFF}%s предлагает Вам вступить в организацию: "colserver"%s{FFFFFF}\n\nНажмите Да для согласия.\nНажмите Нет для отказа!", pInfo[playerid][pName], gFraction[pInfo[playerid][pMember]][fName]);
		ShowPlayerDialog(params[0], D_PLAYER_INVITE, DIALOG_STYLE_MSGBOX, ""colserver"Предложение", string_, "Да", "Нет");
		SendMes(playerid, COLOR_WHITE, "Вы пригласили "colserver"%s "colwhi"присоединиться к "colserver"%s"colwhi"", pInfo[params[0]][pName], gFraction[pInfo[playerid][pMember]][fName]);
		
		

		DeletePVar(playerid, "PlayerActionInvite");
		DeletePVar(playerid, "PlayerInvite");
		
        DeletePVar(params[0], "PlayerActionInvite");
		DeletePVar(params[0], "PlayerInvite");
		SetPVarInt(params[0], "PlayerInvite", playerid);
		SetPVarInt(playerid, "PlayerActionInvite", params[0]);
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная функция!");
	return 1;
}

CMD:fwarn(playerid, params[]) {
	if (!pInfo[playerid][pLogin] || !pTemp[playerid][tDutyWork] || pInfo[playerid][pMember] == 0) return 1; 
	new	
		string_[145],
		fraction_id = pInfo[playerid][pMember];
	if (pInfo[playerid][pRank] < fInfo[fraction_id][fHelper][1]) {
		format(string_, sizeof string_, "Данная команда доступна с %i ранга", fInfo[ pInfo[playerid][pMember] ][fHelper][1]);
		SendClientMessage(playerid, COLOR_GREY, string_);
		return 1;
	}
	if (strlen(params[1]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "ds[128]",params[0],params[1])) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /fwarn [id] [причина]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (pInfo[params[0]][pMember] != pInfo[playerid][pMember] || pInfo[playerid][pRank] <= pInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в Вашей организации / выше в должности");
    if (IsAIP(params[1])) return 1;
	pInfo[params[0]][FractionWarn] ++; 
	SavePlayerInteger(params[0], "fmute", pInfo[params[0]][FractionWarn]);
	if (pInfo[params[0]][FractionWarn] >= 3) {
		uninvite_player(params[0]); 
		format(string_, sizeof string_, "[F] %s %s: выдал выговор и уволил игрока %s (3/3). Причина: %s", 
			fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], pInfo[params[0]][pName], params[1]
		);
		SendFamilyMessage(pInfo[playerid][pMember], COLOR_LI_RED, string_);  
		return 1;
	}
	format(string_, sizeof string_, "[F] %s %s: выдал выговор игроку %s (%i/3). Причина: %s", 
		fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], 
		pInfo[params[0]][pName], pInfo[params[0]][FractionWarn], params[1]
	);
	SendFamilyMessage(pInfo[playerid][pMember], COLOR_LI_RED, string_);  
	return 1;
}

CMD:funwarn(playerid, params[]) {
	if (!pInfo[playerid][pLogin] || !pTemp[playerid][tDutyWork] || pInfo[playerid][pMember] == 0) return 1;
	new	
		string_[145],
		fraction_id = pInfo[playerid][pMember];
	if(pInfo[playerid][pRank] < fInfo[fraction_id][fHelper][1]) {
		format(string_, sizeof string_, "Данная команда доступна с %i ранга", fInfo[ pInfo[playerid][pMember] ][fHelper][1]);
		SendClientMessage(playerid, COLOR_GREY, string_);
		return 1;
	}
	if (strlen(params[1]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "ds[128]", params[0], params[1])) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /funwarn [id] [причина]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!pInfo[params[0]][FractionWarn]) return SendClientMessage(playerid, COLOR_GREY, !"У данного игрока нет выговоров");
	if (pInfo[params[0]][pMember] != pInfo[playerid][pMember] || pInfo[playerid][pRank] <= pInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в Вашей организации / выше в должности");
	pInfo[params[0]][FractionWarn]--; 
	format(string_, sizeof string_, "[F] %s %s: снял выговор игроку %s. Причина: %s", 
		fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], pInfo[params[0]][pName], params[1]
	);
	SendFamilyMessage(pInfo[playerid][pMember], COLOR_LI_RED, string_); 
	return 1;
}
CMD:uninvite(playerid, params[])
{
   	if (!pInfo[playerid][pLogin] || !pTemp[playerid][tDutyWork] || pInfo[playerid][pMember] == 0) return 1;
   	new string_[145];
   	if (strlen(params[1]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "us[32]", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /uninvite [id] [причина]");
	if (pInfo[playerid][pRank] <= pInfo[params[0]][pRank] || pInfo[params[0]][pLeader] > 0 ) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете уволить этого игрока");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок не состоит в Вашей организации!");
	if (!IsUnInviteAssistant(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	if (IsANews(playerid))
	{
		pInfo[params[0]][edited_ads] = 0;
		SavePlayerInteger(params[0], "edited_ads", 0);
	}
	format(string_, sizeof string_, "%s выгнал вас из организации. Причина: %s",pInfo[playerid][pName],params[1]);
	SendClientMessage(params[0], 0x6BB3FFAA, string_);
	format(string_, sizeof string_, "Вы выгнали %s из организации. Причина: %s",pInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, 0x6BB3FFAA, string_);
	uninvite_player(params[0]);
	return 1;
}

CMD:geton(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта функция");
    if (strlen(params[0]) >= MAX_PLAYER_NAME) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
    if (sscanf(params, "s[24]",params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Введите: /geton [name]");
    new query_[128];
    mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_users` WHERE `Name` = '%s'",params[0]);
	mysql_tquery(dbHandle, query_, "OnMySQL_QUERY", "iis", MYSQL_SELECT_GETON, playerid, params[0]);
	return 1;
}
CMD:demote(playerid, params[])
{
	if (pInfo[playerid][pMember] != 2 && pInfo[playerid][pMember] != 7) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда!");
	switch (pInfo[playerid][pMember]) {
		case 2: if (pInfo[playerid][pRank] < 6) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда!");
		case 7: if (pInfo[playerid][pRank] < 5) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда!");
	}
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /demote [id]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return 1;
	new query_[256];
	if (pInfo[params[0]][pLeader] != 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете уволить лидера!");
	if (pInfo[params[0]][pMember] == 3 || pInfo[params[0]][pMember] == 19 || pInfo[params[0]][pMember] == 1 || pInfo[params[0]][pMember] == 10 ||
	pInfo[params[0]][pMember] == 21)
	{
		new mes[128],string_[128];
		if (pInfo[params[0]][pRank]-1 == 0 && (pInfo[params[0]][pMember] == 3 || pInfo[params[0]][pMember] == 19))
		{

		    leave_team(params[0], pInfo[params[0]][pMember]);

			pInfo[params[0]][pMember] = 0;

			pInfo[params[0]][pLeader] = 0; 
			pInfo[params[0]][pRank] = 0;
			if (pInfo[params[0]][PlayerSpawn] == 2)
			{
			    if (pInfo[params[0]][pHouseID] == -1) pInfo[params[0]][PlayerSpawn] = 0;
				else pInfo[params[0]][PlayerSpawn] = 1;
			    SavePlayerInteger(params[0], "playerspawn", pInfo[params[0]][PlayerSpawn]);
			}
			pTemp[params[0]][tDutyWork] =0;
			SetPlayerArmour(params[0],0);
			ResetPlayerWeapons(params[0]);
			format(string_,sizeof(string_),"%s %s уволил вас из армии",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName]);
			SendClientMessage(params[0],0x6495EDFF,string_);
			SendClientMessage(params[0], 0x6495EDFF, "Вы снова гражданский");
			format(mes,sizeof(mes),"Вы уволили %s из армии.", pInfo[params[0]][pName]);
			SendClientMessage(playerid,0x6495EDFF,mes);
			format(query_, sizeof query_ , "UPDATE `s_users` SET `pLeader` = '%d', `pMember` = '%d', `pRank` = '%d', `pJob` = '%d' WHERE `Name` = '%s'",
			pInfo[params[0]][pLeader], pInfo[params[0]][pMember], pInfo[params[0]][pRank], pInfo[params[0]][pJob], pInfo[params[0]][pName]);
			mysql_tquery(dbHandle, query_, "", "");
			PlayerSpawnEx(params[0]);
			return 1;
		}
		if (pInfo[params[0]][pMember] != 0)
		{
			pInfo[params[0]][pRank] --;
			format(string_,sizeof(string_),"%s %s понизил вас до %d ранга",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], pInfo[params[0]][pRank]);
			SendClientMessage(params[0],0x6495EDFF,string_);
			format(mes,sizeof(mes),"Вы понизили %s до %d ранга.", pInfo[params[0]][pName], pInfo[params[0]][pRank]);
			SendClientMessage(playerid,0x6495EDFF,mes);
			format(query_, sizeof query_ , "UPDATE `s_users` SET `pRank` = '%d' WHERE `Name` = '%s'", pInfo[params[0]][pRank], pInfo[params[0]][pName]);
			mysql_tquery(dbHandle, query_, "", "");
		}
		else SendClientMessage(playerid, COLOR_GREY, !"Игрок уволен!");
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Этот человек не состоит в армии/ПД!");
	return 1;
}
CMD:giverank(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || !pTemp[playerid][tDutyWork]) return 1;
    if (pInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /giverank [id] [ранг]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pInfo[playerid][pRank] < pInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете повысить/понизить старшего по рангу!");
	if (params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Ранг должен быть не меньше одного!");
	if (pInfo[params[0]][pLeader] >= 1) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали ID лидера!");
	if (params[1] >= pInfo[playerid][pRank]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете повысить до ранга, выше вашего/до вашего ранга!");
	if (pInfo[playerid][pMember] != pInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не из вашей организации!");
	if (pInfo[playerid][pRank] == pInfo[params[0]][pRank]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете понизить равного себе по рангу");
	new string_[128], query_[128],
		fraction_id = pInfo[playerid][pMember];
	if (pInfo[params[0]][pRank] > params[1])
	{
	    if (!IsUnGiveRankAssistant(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете понизить ранг игроку");
	}
	if (pInfo[params[0]][pRank] < params[1])
	{
	    if (!IsGiveRankAssistant(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете повысить ранг игроку");
	    if (params[1] > gFracionCountRank[fraction_id - 1] - 1) return SendMes(playerid, COLOR_GREY, "Нельзя меньше 1 и больше %d!", gFracionCountRank[fraction_id - 1] - 1);
		if (IsPlayerProgress(playerid, QUEST_TASK_ARMY_KMB)) OnPlayerQuestProgress(playerid, QUEST_ARMY, QUEST_TASK_ARMY_KMB);
	}
	pInfo[params[0]][pRank] = params[1];


	f(string_, "%s %s повысил/понизил Вас до %d ранга (%s)", 
	fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName],params[1],
	fFractionRank[pInfo[playerid][pMember]][pInfo[params[0]][pRank] - 1]);
	SendClientMessage(params[0], 0x6495EDFF, string_);

	f(string_, "Вы повысили/понизили %s до %d ранга (%s)", pInfo[params[0]][pName], params[1],
	fFractionRank[pInfo[playerid][pMember]][pInfo[params[0]][pRank] - 1]);
	SendClientMessage(playerid, 0x6495EDFF, string_);



	format(query_, sizeof query_ , "UPDATE `s_users` SET `pRank` = '%d' WHERE `Name` = '%s'", pInfo[params[0]][pRank], pInfo[params[0]][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	return 1;
}  
CMD:get(playerid, params[])
{
	new string_[256], param[40];
	if ( sscanf( params, "s[32]S()[64]", param, params ) ) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /get [значение] Доступные значения: guns, drugs, fuel");
	if (strcmp(param, "fuel",true) == 0)
	{
		for (new id = 0; id < sizeof (BusinessInfo); id++)
		{
			if (!IsValidBusiness(id)) continue;
			if (BusinessInfo[id][bType] != BUSINESS_TYPE_GAS) continue;
			if (IsPlayerInRangeOfPoint(playerid, 7.0, BusinessInfo[id][bPos][0],BusinessInfo[id][bPos][1],BusinessInfo[id][bPos][2]))
			{
			    //if (BizzInfo[b][bProducts] <= 0 && strcmp(BizzInfo[b][bOwner],"None",true) != 0) return SendClientMessage(playerid,COLOR_GRAD1,"Заправка не работает");
				//if (BizzInfo[b][bLocked] == 1) return SendClientMessage(playerid,COLOR_GRAD1, "Заправка закрыта!");
				if (pInfo[playerid][pFuel] != 0) return SendClientMessage(playerid, COLOR_GRAD1, "У вас уже есть канистра");
				if (kLibGetPlayerMoney(playerid) < 2500) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько денег!");
				kLibGivePlayerMoney(playerid, -2500, "/get");
				BusinessInfo[id][bBank] += 2500; 
				format(string_, sizeof (string_), "bBank = %i", 
					BusinessInfo[id][bBank]
				);
				SaveBusiness(id, string_);
				format(string_, sizeof(string_), "Вы купили 50 литров бензина за $2500");
				SendClientMessage(playerid, 0x6495EDFF, string_);
				pInfo[playerid][pFuel] = 1;
				SavePlayerInteger(playerid, "pFuel", pInfo[playerid][pFuel]); 
				return 1;
			}
		}
	}
	else if (strcmp(param, "drugs",true) == 0)
	{
		if (!IsAGang(playerid)) return SendClientMessage(playerid,COLOR_GRAD1, "Вы не бандит!");
		new ammo;
		new
			D_IDX = pTemp[playerid][tSelectDealerID];
		if (sscanf( params, "d", ammo ) ) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /get drugs [количество]");
		if (pTemp[playerid][tSelectDealerID] == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Вы не в притоне!");
  		if (ammo < 1 || ammo > 150) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя меньше 1 или больше 150!");
		if (kLibGetPlayerMoney(playerid) < (ammo*DealerInfo[D_IDX][dCost][0])) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько денег!");
		if (ammo > DealerInfo[D_IDX][dDrugs])
		{
			format(string_, sizeof string_, "В наркопритоне нет столько наркотиков | Остаток: %d", DealerInfo[D_IDX][dDrugs]);
			SendClientMessage(playerid, 0x6495EDFF, string_);
			return 1;
		}
		if (pInfo[playerid][pDrugs] + ammo > GetVIPLimitDrugs(playerid)) 
		{
			OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_DRUGS, 150);
			format(string_, sizeof string_, "Нельзя унести с собой более %d грамм!", GetVIPLimitDrugs(playerid));
			SendClientMessage(playerid, 0x6495EDFF, string_);
			return 1;
		}
		kLibGivePlayerMoney(playerid, -ammo*DealerInfo[D_IDX][dCost][0], "/get drugs");
		pInfo[playerid][pDrugs] += ammo; 
		format(string_, sizeof(string_), "Вы купили %d грамм наркотиков за $%d (У вас есть %d грамм)", ammo, ammo*DealerInfo[D_IDX][dCost][0], pInfo[playerid][pDrugs]);
		SendClientMessage(playerid, 0x6495EDFF, string_);

		OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_DRUGS,ammo);

		return 1;
	} 
	else if (strcmp(param,"guns",true) == 0)
	{
		if (!IsAGang(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не бандит");
		new numberof;
		if (sscanf( params, "d", numberof ) ) return SendClientMessage(playerid, COLOR_GRAD2, "Введите: /get guns [кол-во]");
		if (pInfo[playerid][pRank] < 4) return SendClientMessage(playerid, COLOR_GREY, !"Функция доступна с 4 ранга");
		if (!IsATerra(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "Вы не на своей базе"); 
		if (pInfo[playerid][pMats] + numberof > GetVIPLimitMaterials(playerid)) { 
			format(string_, sizeof string_, "Вы не можете взять меньше 1 и больше %d материалов", GetVIPLimitMaterials(playerid));
			SendClientMessage(playerid, COLOR_GREY, string_);
			return 1;
		}
		if (numberof < 1 || numberof > 500) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете взять меньше 1 и больше 500 материалов за раз");
		if (IsAGang(playerid) && pInfo[playerid][pRank] >= 4)
		{
		    new ftraction_ = pInfo[playerid][pMember];
		    if (FractionInfo[ftraction_][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад закрыт!");
		    if (FractionInfo[ftraction_][fMaterials] <= numberof) return SendClientMessage(playerid, COLOR_GREY, !"На складе нет материалов");
			FractionInfo[ftraction_][fMaterials] -= numberof;
			SaveFractionInfoID(FractionInfo[ftraction_][fID], false);
			pInfo[playerid][pMats] += numberof; 
			format(string_, sizeof string_, "У вас %d/%d материалов с собой", pInfo[playerid][pMats], GetVIPLimitMaterials(playerid));
			SendClientMessage(playerid, COLOR_WHITE, string_);
			format(string_, sizeof string_, "%s взял материалы со склада", pInfo[playerid][pName]);
			SendBeside(playerid,COLOR_PURPLE,string_,30.0);
			return 1;
		}
	}
	/*else if (strcmp(param,"medkit",true) == 0)
	{
	    if ((!IsAGang(playerid) && !IsAMafia(playerid)) || pInfo[playerid][pRank] < 9) return SendClientMessage(playerid, COLOR_GREY, !" Вам недоступна данная команда");
 		if (!IsPlayerInRangeOfPoint(playerid,30, 372.0985,-53.2946,1076.4708))
 		{
			new fraction_ = pInfo[playerid][pMember];
			format(string_,sizeof(string_),"На складе организации %d аптечек",FractionInfo[fraction_][fHeal]);
			return SendClientMessage(playerid,0x6495EDFF,string_);
		}
 		new null, str[16];
 		new fraction_ = pInfo[playerid][pMember];
  		if (sscanf(params, "i",null) || null < 1 || null > 5000) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /get medkit [колличество] (стоимость 1 аптечки - $4)");
        if (FractionInfo[fraction_][fHeal] + null > 5000) return SendClientMessage(playerid, COLOR_GREY, !" Неверное колличество! (Максимум 5000)");
		if (FractionInfo[fraction_][fMoney] < null*4) return SendClientMessage(playerid, COLOR_GREY, !" Недостаточно средств в банке организации!");
		FractionInfo[fraction_][fHeal] += null;
		FractionInfo[fraction_][fMoney] -= null*4; 
		format(string_,sizeof(string_), " Вы купили %d аптечек. Остаток в банке организации: $%d!",null, FractionInfo[fraction_][fMoney]);
		SendClientMessage(playerid,COLOR_YELLOW,string_);
		format(str,sizeof str,"~r~$-%d",null*4);
		GameTextForPlayer(playerid,str, 5000, 1);
		return 1;
	}*/
	return 1;
}
CMD:fillcar(playerid, params[])
{
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, !"Вы не в авто");
 	new V_IDX = GetPlayerVehicleID(playerid);
 	if (pInfo[playerid][pFuel] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет канистры");
 	if (!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER
	 	|| GetVehicleModel(V_IDX) == 481 || GetVehicleModel(V_IDX) == 509 || GetVehicleModel(V_IDX) == 510)
	 	return SendClientMessage(playerid, COLOR_YELLOW, !"Вы не в автомобиле/Этот транспорт нельзя заправить");
	if (VehicleInfo[ V_IDX - 1 ][vFuel] >= GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel])) return SendClientMessage(playerid, COLOR_GREY, !"Ваш бак полон!");
 	SendClientMessage(playerid, 0x6495EDFF, !"Вы дозаправили свой автомобиль 50 литрами бензина");
	VehicleInfo[ V_IDX - 1 ][vFuel] += 50.0;
	if (VehicleInfo[ V_IDX - 1 ][vFuel] > GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel])) {
		VehicleInfo[ V_IDX - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel]);
	} 
 	pInfo[playerid][pFuel] = 0;
 	SavePlayerInteger(playerid, "pFuel", pInfo[playerid][pFuel]);
 	return 1;
}


CMD:rem(playerid)
{
    if (!pInfo[playerid][sTool]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет комплекта инструментов! Совершить покупку можно в магазине 24/7");
	if (IsPlayerInAnyVehicle(playerid))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться за рулем транспортного средства!");
		_RepairVehicle(GetPlayerVehicleID(playerid));
		pInfo[playerid][sTool]--;
		SendClientMessage(playerid, COLOR_WHITE, !"Машина отремонтирована!"); 
		MeAction(playerid, "использовал(а) комплект инструментов", SELECT_ACTION_GENERAL);
		return PlayerPlaySound(playerid, 32000, 0.0, 0.0, 0.0);
	}
	else return  SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться в машине!");
}
alias:rem("usespare"); 

CMD:satiety(playerid, params[])
{
	new Stats_Level[40],
		satiety_chislo = floatround(pInfo[playerid][Satiety], floatround_round);
	switch(satiety_chislo)
	{
	    case 810..1000: Stats_Level = "{63BD4E}[Вы сыты]";
	    case 510..800: Stats_Level = "{CCFF00}[Вы сыты]";
	    case 310..500: Stats_Level = "{FDE910}[Вы немного проголодались]";
	    case 160..300: Stats_Level = "{FF8800}[Вы голодны]";
	    case 0..150: Stats_Level = "{FF0600}[Вы очень голодны]";
	}
	return SendMes(playerid, 0x6495EDFF, "Ваша «Сытость»: %d / 100 %s", (satiety_chislo/100)*10, Stats_Level);
}
CMD:sethealcost(playerid, params[])
{
    if (pInfo[playerid][pLeader] == 4 || pInfo[playerid][pLeader] == 22 || pInfo[playerid][pLeader] == 23)
	{
		if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sethealcost [сумма]");
		if (params[0] < 1 || params[0] > 30) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете поставить меньше 0 и больше 30");
		healpric = params[0];
		new t_query[100];
		format(t_query, sizeof(t_query),"UPDATE `s_others` SET `healprice`= '%d'", healpric);
		mysql_tquery(dbHandle, t_query, "", "");
		SendClientMessageToAll(COLOR_WHITE, !"---========== Государственные Новости==========---");
		SendMesAll(0x954F4FFF, "Цена лечения, в размере $%d. установлена Глав. Врачом: %s.", healpric,pInfo[playerid][pName]);
		return 1;
	}
	return 1;
}
CMD:escape(playerid, params[])
{
    if (pInfo[playerid][pMestoJail] != 4)
    {
		if (pInfo[playerid][pJailTime] < 1) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в тюрьме!");
		new key_num = -1;
		if (pInfo[playerid][pMestoJail] == 1) key_num = 0;
		else if (pInfo[playerid][pMestoJail] == 2) key_num = 9;
		else if (pInfo[playerid][pMestoJail] == 3) key_num = 20;
		if (key_num == -1) return SendClientMessage(playerid, COLOR_GREY, !"Данную тюрьму нельзя покинуть");
		if (pInfo[playerid][pFracIntKeys][key_num] < 1) return SendClientMessage(playerid, COLOR_GRAD1, !"У Вас нет ключа от данной тюрьмы!");
		pInfo[playerid][pFracIntKeys][key_num]--;
		if (pInfo[playerid][pMestoJail] == 1)
		{ 
		    SetPlayerPosAC(playerid, 1553.4962,-1675.2714,16.1953, 0, 0);
		    SetPlayerFacingAngle(playerid, 95.0636);
		}
		if (pInfo[playerid][pMestoJail] == 2)
		{
		    SetPlayerPosAC(playerid, -1607.1873,721.3649,12.2721, 0, 0);
		    SetPlayerFacingAngle(playerid, 2.3026);
		}
		if (pInfo[playerid][pMestoJail] == 3)
		{
		    SetPlayerPosAC(playerid, 2334.8467,2454.9456,14.9688, 0, 0);
		    SetPlayerFacingAngle(playerid, 115.7874);
		}
		pInfo[playerid][pJailTime] = 0;
		pInfo[playerid][pMestoJail] = 0; 
		pTemp[playerid][tPlayerCuffed] = 0;
		SendClientMessage(playerid, COLOR_YELLOW, !"Вы совершили побег из тюрьмы");
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вы не можете покинуть тюрьму форт ДеМорган");
	return 1;
}
CMD:getekey(playerid, params[])
{
	new keys = pInfo[playerid][pFracIntKeys][FRACTION_LSPD - 1];
	if (keys < 1 || keys == 322) return SendClientMessage(playerid, COLOR_GRAD1, !"У Вас нет ключей от тюрьмы!");
	SendMes(playerid, COLOR_YELLOW, "У Вас %d ключей", keys);
	new str_[64];
	format(str_, sizeof str_, "%s достает ключи",pInfo[playerid][pName]);
	SendBeside(playerid, COLOR_PURPLE, str_,30.0);
	return 1;
}
CMD:givecopkeys(playerid, params[])
{
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /givecopkeys [id]");
	if ((pInfo[playerid][pMember] == 1 || pInfo[playerid][pMember] == 2 || pInfo[playerid][pMember] == 10 || pInfo[playerid][pMember] == 21) && pTemp[playerid][tDutyWork] == 1 )
	{
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return 1;
		new Float:x, Float:y, Float:z;
		GetPlayerPos(params[0],x,y,z);
		if (!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) return SendClientMessage(playerid,COLOR_WHITE, !"Игрок не возле тебя.");
		if (pInfo[params[0]][pFracIntKeys][pInfo[playerid][pMember] - 1] > 0)
			return SendClientMessage(playerid, COLOR_GREY, !"У игрока уже есть ключ!");
		pInfo[params[0]][pFracIntKeys][pInfo[playerid][pMember] - 1] ++;


		
		new string_[128];
		format(string_, sizeof string_, "Офицер %s выдал ключи от полицейского участка %s",pInfo[playerid][pName],pInfo[params[0]][pName]);
		SendBeside(playerid,COLOR_PURPLE, string_,30.0);
	}
	return 1;
}

CMD:takecopkeys(playerid, params[])
{
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /takecopkeys [id]");
	if (pInfo[playerid][pMember] == 1 || pInfo[playerid][pMember] == 2 || pInfo[playerid][pMember] == 10 || pInfo[playerid][pMember] == 21 || pInfo[playerid][pAdmin] >= 1)
	{
		if (!IsPlayerConnected(params[0]) || !pInfo[params[0]][pFracIntKeys][pInfo[playerid][pMember] - 1]) return 1;
		pInfo[params[0]][pFracIntKeys][pInfo[playerid][pMember] - 1]  = 0;
		
		new string_[128];
		format(string_, sizeof string_, "Офицер %s забрал ключи от полицейского участка %s",pInfo[playerid][pName],pInfo[params[0]][pName]);
		SendBeside(playerid,COLOR_PURPLE, string_,30.0);
	}
	return 1;
}

 
CMD:id(playerid, params[])
{
	if (isnull(params)) return scm(playerid, COLOR_WHITE, "Введите: /id [ид игрока / часть ника]");
	new iTargetID = strval(params);
	new bool: total_ = false;
	if (isNumeric(params) && IsPlayerConnected(strval(params)))
	{
		SendMes(playerid,COLOR_WHITE, "[%d] %s | LVL: %d | PING: %d | %s | "colserver"%s", iTargetID, pInfo[iTargetID][pName], pInfo[iTargetID][pLevel], GetPlayerPing(iTargetID), pTemp[iTargetID][PlayerAFK]> 2 ?("[AFK]"):("В игре"), player_mobile[iTargetID] == true ? ("Mobile") : ("PC"));
		total_ = true;
	}
	else
	{
		foreach(new i: PlayerInLogin)
		{ 
			if (strfind(pInfo[i][pName], params, true) != -1)
			{
				SendMes(playerid,COLOR_WHITE,  "[%d] %s | LVL: %d | PING: %d | %s | %s", i, pInfo[i][pName], pInfo[i][pLevel], GetPlayerPing(i), pTemp[i][PlayerAFK] > 2 ?("[AFK]"):("В игре"), player_mobile[i] == true ? ("Mobile") : ("PC"));
				total_ = true;
				/*if (total_ > 5)
				{
				    scm(playerid,COLOR_WHITE, !"Показаны первые 5 совпадений");
					break;
				}*/
			}
		}
	}
	if (total_ == false) SendClientMessage(playerid, COLOR_GREY, !"Совпадений не найдено");
	return 1;
} 
CMD:b(playerid, params[])//ANTIFLOOD
{
    if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, "Не флуди!");
	//Анти реклама
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /b [сообщение]");
	new succ;
	for(new i; i<strlen(params[0]); i++)
	{
		if (PText[playerid][i] == params[0]) succ++;
	}
	new string_[145];
	format(string_, sizeof string_, "%s: (( %s ))",pInfo[playerid][pName],params[0]);
	SendBeside(playerid,COLOR_WHITE, string_,20.0);
	pTemp[playerid][AntiFloodText] = gettime()+2;
	return 1;
}
CMD:whisper(playerid, params[])
{
    if (pInfo[playerid][pMuted] > 0) return IsPlayerMuted(playerid);
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, "Не флуди!");
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /w [сообщение]");
	new succ;
	for(new i; i<strlen(params[0]); i++)
	{
		if (PText[playerid][i] == params[0]) succ++;
	}
	new string_[145];
	format(string_, sizeof string_, "%s шепнул(а): %s", pInfo[playerid][pName],params[0]);
	ProxDetector(playerid, 2.0, 0x6E6E6EAA, string_);
 	pTemp[playerid][AntiFloodText] = gettime()+2;
	return 1;
}
alias:whisper("w"); 

CMD:offmembers(playerid, params[])
{
 	if (pInfo[playerid][pLeader] == 0) return SendClientMessage(playerid, COLOR_GRAD1, !"Вам недоступна эта функция!");
	if (!IsUnInviteAssistant(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать."); 
    new query_[164];
	format(query_, sizeof query_, "SELECT `pRank`,`Name`,`pGetonDate` FROM `s_users` WHERE `pMember` = '%d' AND pLogin = '0'", pInfo[playerid][pMember]);
	mysql_tquery(dbHandle, query_, "TestOffmembers", "d", playerid);
	return 1;
}

CMD:historyname(playerid,params[])
{
	new kLibName[32],uninviteid,query[128];
    if (sscanf(params, "s[32]", kLibName)) return scm(playerid, COLOR_WHITE, !"Введите: /historyname [имя игрока]");
	sscanf(kLibName, "u", uninviteid);
	if (IsPlayerConnected(uninviteid) && pInfo[uninviteid][pLogin]) {
	    mysql_format(dbHandle, query, sizeof query, "SELECT * FROM `sh_login` WHERE `pID` = '%d' ORDER BY `Data` DESC LIMIT 0, 15", pInfo[uninviteid][pID]);
		mysql_tquery(dbHandle, query, "LoadHistoryNameList", "dsd", playerid, kLibName, 2);
		return 1;
	}
	else {
	    mysql_format(dbHandle, query,sizeof query, "SELECT * FROM `s_users` WHERE `Name` = '%e'",kLibName);
		mysql_tquery(dbHandle, query, "GetIDAccountNameStore", "dsd", playerid, kLibName, 2);
	}
	return 1;
}

CMD:changeskin(playerid, params[])
{
    if (!pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в организации");
    if (pTemp[playerid][tDutyWork] == 0) return 1;
    if (pInfo[playerid][pRank] < fInfo[pInfo[playerid][pMember]][fHelper][5])
	{
		new str_[128];
		format(str_, sizeof str_, "Данную команду можно использовать с %d ранга", fInfo[pInfo[playerid][pMember]][fHelper][5]);
		SendClientMessage(playerid, COLOR_GREY, str_);
		return 1;
	}
	if (sscanf(params,"u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /changeskin [playerid]");
	if (!IsPlayerConnected(params[0])) return 1;
	if (pInfo[params[0]][pMember] != pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок находиться в другой организации!");
	if (pInfo[params[0]][pRank] >= pInfo[playerid][pRank] && params[0] != playerid) return SendClientMessage(playerid, COLOR_GREY, !"Вы рангом ниже");
	SetPVarInt(playerid, "PlayerChangeSkin", params[0]);
	new
		fraction_ = pInfo[playerid][pMember] - 1;
	t_string[0] = EOS;
	for(new i; i < 16; i++)
	{
		new
			skinid = gFractionSkin[fraction_][i];
		if (!skinid) break;
		if (skinid == pInfo[params[0]][pModel])
		{
			if (!i) format(t_string, sizeof t_string,""collime"[%d] Скин [%d]", i, skinid);
			else format(t_string, sizeof t_string,"%s\n"collime"[%d] Скин [%d]", t_string, i, skinid);
		}
		else
		{
			if (!i) format(t_string, sizeof t_string,"[%d] Скин [%d]", i, skinid);
			else format(t_string, sizeof t_string,"%s\n[%d] Скин [%d]", t_string, i, skinid);
		}
	}
	new
		str_[64];
	format(str_, sizeof str_, ""colserver"Сменить скин: "colwhi"%s", pInfo[params[0]][pName]);
	ShowPlayerDialog(playerid, D_FRACTION_FUNC_27, 2, str_, t_string, "Сменить", "Закрыть");
	return 1;
}



CMD:vacancy(playerid)
{
    new
		total_v = 0,
   		string [128];
	t_string[0] = EOS;
	strcat(t_string, ""colserver"[№] Организация\t"colserver"Автор\n");
	for(new i = 0; i < 15; i++)
	{
	    if (VacancyInfo[i][VacancyStatus])
		{ 
			format(string, sizeof string, ""colwhi"[%d] %s\t"colwhi"%s\n", 
				total_v, fInfo[ VacancyInfo[i][VacancyFraction] ][fName], VacancyInfo[i][VacancyOwner]
			);
			strcat(t_string, string);
	        total_v++;
	    }
	}
	if (total_v != 15 && pInfo[playerid][pMember] && pInfo[playerid][pRank] >= fInfo[ pInfo[playerid][pMember] ][fHelper][0])
	{
	    strcat(t_string, ""collime"- Добавить вакансию");
	  	return ShowPlayerDialog(playerid, D_VACANCY_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Вакансии", t_string, "Далее", "Закрыть");
	}
	if (total_v == 0) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Сейчас нет доступных вакансий");
	return ShowPlayerDialog(playerid, D_VACANCY_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Вакансии", t_string, "Далее", "Закрыть");
}




CMD:camera(playerid, params[])
{
    if (pInfo[playerid][pMember] != 19) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в рядах Зоны 51");
	if (!IsPlayerInRangeOfPoint(playerid,2.0,212.2816,1812.2374,21.8672)) return SendClientMessage(playerid, COLOR_GRAD1, "Вы не у точки наблюдения");
	ShowPlayerDialog(playerid, D_ZONE51_CAM, DIALOG_STYLE_LIST, "Выберите камеру", "Сектор - 1\nСектор - 2\nСектор - 3\nСектор - 4", "Выбрать", "Закрыть");
	return 1;
}
CMD:cameraoff(playerid, params[])
{
    if (pInfo[playerid][pMember] != 19) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в рядах Зоны 51");
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	return 1;
}






CMD:hcounter(playerid, params[])
{
	if (pInfo[playerid][pJob] != 3) return 1;
	if (GetPVarInt(playerid,"h_stall"))
	{
 		//UpdateDynamic3DTextLabelText(StallInfo[GetPVarInt(playerid,"h_stall")][stText], 0xFF8C37FF,"Не работает");
		DeletePVar(playerid,"h_stall");
		SetPlayerSkinEx(playerid,pInfo[playerid][pChar][0]);
		return SendClientMessage(playerid,0x6495EDFF,!"Работа закончена");
	}
	if (!GetPVarInt(playerid,"h_contract")) return SendClientMessage(playerid, COLOR_GREY, !"Заключите контракт с закусочной!");
	new null, null_, string_[32];
	for(new i = 1; i <= TOTALSTALL; i++) if (IsPlayerInRangeOfPoint(playerid, 3, StallInfo[i][stPos][0], StallInfo[i][stPos][1], StallInfo[i][stPos][2]) && StallInfo[i][stType] == 1) null = i;
	if (!null) return SendClientMessage(playerid, COLOR_GREY, !"В данном месте вы не можете начать работу");
	foreach(new x: PlayerInLogin)
	{
		if (GetPVarInt(x,"h_stall") == null)
		{
			null_++;
			break;
		}
	}
	if (null_ != 0) return SendClientMessage(playerid, COLOR_GREY, !"Данное место занято!");
	SetPVarInt(playerid,"h_stall",null);
	SetPlayerSkinEx(playerid,209);
	format(string_, sizeof string_,"Цена Хот Дога: %d",GetPVarInt(playerid,"h_price"));
 	//return UpdateDynamic3DTextLabelText(StallInfo[GetPVarInt(playerid,"h_stall")][stText], TEAM_GROVE_COLOR, string_);
	return 1;
}
/*CMD:hcontract(playerid, params[])
{
	if (pInfo[playerid][pJob] != 3) return 1;
	if (GetPVarInt(playerid,"h_contract"))
	{
		DeletePVar(playerid,"h_contract");
		DeletePVar(playerid,"h_price");
		if (GetPVarInt(playerid,"h_stall"))
		{
		    UpdateDynamic3DTextLabelText(StallInfo[GetPVarInt(playerid,"h_stall")][stText], 0xFF8C37FF,"Не работает");
			DeletePVar(playerid,"h_stall");
		}
		return SendClientMessage(playerid,COLOR_WHITE,!"Контракт с закусочной расторгнут!");
	}
	for(new b = 1; b <= TOTALBIZZ; b++)
	{
		if (PlayerToPoint(10.0, playerid, BizzInfo[b][bEnter][0], BizzInfo[b][bEnter][1], BizzInfo[b][bEnter][2]) && BizzInfo[b][bType] == 2)
		{
		    if (strcmp(BizzInfo[b][bOwner],"None",true) == 0 || BizzInfo[b][bLocked]) return SendClientMessage(playerid, COLOR_GREY, !"Закусочная не работает");
			SetPVarInt(playerid,"h_contract",b);
			SetPVarInt(playerid,"h_price",BizzInfo[b][bPrice]/2);
			new string_[128];
			format(string_,sizeof(string_), "Вы заключили контракт с закусочной %s",BizzInfo[b][bMessage]);
			SendClientMessage(playerid,0x6495EDFF,string_);
			format(string_,sizeof(string_), "Цена хот дога: %d (( Продать: /selleat ))",BizzInfo[b][bPrice]/2);
			SendClientMessage(playerid,0x6495EDFF,string_);
			break;
		}
	}
	return 1;
}*/ 



CMD:rlock(playerid)
{
	if (arenda[playerid] != INVALID_VEHICLE_ID)
	{
	    GetVehicleParamsEx(arenda[playerid], engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
		new Float:cx, Float:cy, Float:cz;
		GetVehiclePos(arenda[playerid], cx, cy, cz);
		if (!IsPlayerInRangeOfPoint(playerid, 4.0, cx, cy, cz)) return 1;
		if (doors3 == 1) UnLockCar(arenda[playerid]);
		else LockCar(arenda[playerid]);
		GameTextForPlayer(playerid, (doors3 == 1)?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~r~LOCK"), 3000, 3);
		PlayerPlaySound(playerid, 24600, 0.0, 0.0, 0.0);
	}
	else if (tookmoped[playerid] != INVALID_VEHICLE_ID)
	{
	    GetVehicleParamsEx(tookmoped[playerid], engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
		new Float:cx, Float:cy, Float:cz;
		GetVehiclePos(tookmoped[playerid], cx, cy, cz);
		if (!IsPlayerInRangeOfPoint( playerid, 4.0,cx, cy, cz)) return 1;
		if (doors3 == 1) UnLockCar(tookmoped[playerid]);
		else LockCar(tookmoped[playerid]);
		GameTextForPlayer(playerid, (doors3 == 1)?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~r~LOCK"), 3000, 3);
		PlayerPlaySound(playerid, 24600, 0.0, 0.0, 0.0);
	}
	else if (pTemp[playerid][pRentCar] != INVALID_VEHICLE_ID)
	{
	    new
	        RENT_IDX_CAR = pTemp[playerid][pRentCar];
	    GetVehicleParamsEx(RENT_IDX_CAR, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
		new Float:cx, Float:cy, Float:cz;
		GetVehiclePos(RENT_IDX_CAR, cx, cy, cz);
		if (!IsPlayerInRangeOfPoint(playerid, 4.0, cx, cy, cz)) return 1;
		if (doors3 == 1) UnLockCar(RENT_IDX_CAR);
		else LockCar(RENT_IDX_CAR);
		GameTextForPlayer(playerid, (doors3 == 1)?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~r~LOCK"), 3000, 3);
		PlayerPlaySound(playerid, 24600, 0.0, 0.0, 0.0);
	}
	else if (pTemp[playerid][id_arended_truck] != INVALID_VEHICLE_ID)
	{
	    new
	        RENT_IDX_CAR = pTemp[playerid][id_arended_truck];
	    GetVehicleParamsEx(RENT_IDX_CAR, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
		new Float:cx, Float:cy, Float:cz;
		GetVehiclePos(RENT_IDX_CAR, cx, cy, cz);
		if (!IsPlayerInRangeOfPoint(playerid, 4.0, cx, cy, cz)) return 1;
		if (doors3 == 1) UnLockCar(RENT_IDX_CAR);
		else LockCar(RENT_IDX_CAR);
		GameTextForPlayer(playerid, (doors3 == 1)?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~r~LOCK"), 3000, 3);
		PlayerPlaySound(playerid, 24600, 0.0, 0.0, 0.0);
	}
	else SendClientMessage(playerid, COLOR_GREY, !"У Вас нет арендованого транспорта!");
	return 1;
}
CMD:unrentcar(playerid)
{
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем рабочего транспорта!");
	new 
        V_IDX = GetPlayerVehicleID(playerid);
    if (
		(arenda[playerid] == INVALID_VEHICLE_ID) && 
		(tookmoped[playerid] == INVALID_VEHICLE_ID) && 
		(pTemp[playerid][ id_arended_truck ] == INVALID_VEHICLE_ID) &&
		(pTemp[playerid][pRentCar] == INVALID_VEHICLE_ID)
		
		) {
		return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет в аренде траснспорта!");
	}
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_RENTCAR && 
        (VehicleInfo[ V_IDX - 1 ][vFraction] >= RENT_CAR_SANTA_MARIA && VehicleInfo[ V_IDX - 1 ][vFraction] <= RENT_CAR_FAGGIO_THEFT))
	{
		if (VehicleInfo[ V_IDX - 1 ][vFraction] >= RENT_CAR_SANTA_MARIA && VehicleInfo[ V_IDX - 1 ][vFraction] <= RENT_CAR_LAS_VETURAS) {
            SetVehicleToRespawn(arenda[playerid]);
			arenda[playerid] = INVALID_VEHICLE_ID;
			SendClientMessage(playerid, COLOR_GREY, !"Арендованный транспорт был отбуксирован"); 
		}
		else if (VehicleInfo[ V_IDX - 1 ][vFraction] == RENT_CAR_FAGGIO) {
			_DestroyVehicle(V_IDX); 
			arenda[playerid] = INVALID_VEHICLE_ID;
			SendClientMessage(playerid, COLOR_GREY, !"Арендованный скутер был отбуксирован"); 
		}
		else if (VehicleInfo[ V_IDX - 1][vFraction] == RENT_CAR_BOAT) {
			_DestroyVehicle(V_IDX); 
			arenda[playerid] = INVALID_VEHICLE_ID;
			SendClientMessage(playerid, COLOR_GREY, !"Арендованный катер был отбуксирован"); 
		}
		else if (VehicleInfo[ V_IDX - 1][vFraction] == RENT_CAR_FAGGIO_THEFT) {
			_DestroyVehicle(V_IDX); 
			tookmoped[playerid] = INVALID_VEHICLE_ID;
			SendClientMessage(playerid, COLOR_GREY, !"Арендованный скутер был отбуксирован"); 
		}
	}
	else if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && 
		(VehicleInfo[ V_IDX - 1 ][vFraction] >= PLAYER_JOB_BUS && VehicleInfo[ V_IDX - 1 ][vFraction] <= PLAYER_JOB_HUNTER)) {
		if (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_TRUCKER) {
			if (pTemp[playerid][tTruckerTrailerBuy] != INVALID_VEHICLE_ID) {
				new	
					trailer_id = pTemp[playerid][tTruckerTrailerBuy];
				trailer_count[ trailer_id - 1 ] = 0;
				_DestroyVehicle(trailer_id);
				SendClientMessage(playerid, COLOR_GREY, !"Вы не смогли доставить груз, затраты не будут возмещены");
				pTemp[playerid][tTruckerLoadTime] = -1; 
				if (GetPVarInt(playerid, "truck_waiting") > 0) {
					for (new j = 0 ; j < LOADING_ALL ; j ++) { 
						if (TurnLoadingPlayerID[j] == playerid) {
							TurnLoadingPlayerID[j] = INVALID_PLAYER_ID;  
							DeletePVar(playerid, "truck_waiting");
						}
					}
				} 
				pTemp[playerid][tTruckerTrailerBuy] = INVALID_VEHICLE_ID;
			}
			HideTruckerMainMenu(playerid, .main = true, .timer = true); 
			VehicleInfo[ pTemp[playerid][ id_arended_truck ] - 1 ][id_arender_truck] = INVALID_PLAYER_ID;
			SetVehicleToRespawn(pTemp[playerid][ id_arended_truck ]);
			pTemp[playerid][ id_arended_truck ] = INVALID_VEHICLE_ID;
			SendClientMessage(playerid, COLOR_GREY, !"Арендованный грузовик был отбускирован на стоянку");
		}
		else if (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_DELIVERY) {
			SetVehicleToRespawn(pTemp[playerid][ pRentCar ]);
			pTemp[playerid][ pRentCar ] = INVALID_VEHICLE_ID;
		}
		else {
			SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт нельзя отбуксировать!");
			return 1;
		}
	}
    return 1;
}
 

CMD:animlist(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы находитесь в т.с.");
	if (pTemp[playerid][tFreezePlayer] || pTemp[playerid][tHospitalBed] != -1) return SendClientMessage(playerid, COLOR_GREY, !"Сейчас нельзя использавать данную команду!");
	if (GetPVarInt(playerid,"ClearAnimSI") > gettime()) return 1; 
	if (anim_loaded{playerid} == 0)
	{
		SendClientMessage(playerid, COLOR_BLUE, !"Подождите, прогрузка анимаций");
		PreloadAllAnimLibs(playerid);
		anim_loaded{playerid} = 1;
	}
	if (sscanf(params, "s[84]", params[0]))
	if (!strlen(params[0]))
	{
		new Animser[][] = {
			{"1. Танец - 1\n2. Танец - 2\n3. Танец - 3\n4. Танец - 4\n5. Стойка дилера\n6. Передал что-то\n7. Съел что-то\n8. Справить нужду\n9. Медитация\n10. Сидеть раненым\n11. Спать на боку\n12. Лечь на спину\n13. Шлепнуть рукой\n14. Наносить граффити 1\n15. Наносить граффити 2\n16. Курение\n17. Ограбление\n18. Одеть маску\n19. Руки в верх\n20. Позвать кого-то\n21. Поднять руки\n22. Болельщик 1\n23. Болельщик 2\n24. Болельщик 3\n"},
			{"25. Показать средний палец\n26. Выпить что-то\n27. Махать руками\n28. Мужское курение\n29. Прилечь 1\n30. Прилечь 2\n31. Прилечь 3\n32. Прилечь 4\n33. Присесть на пол\n34. Читать реп 1\n35. Читать реп 2\n36. Читать реп 3\n37. Читать реп 4\n38. Набивать мяч\n39. Кинуть мяч\n40. Поднять мяч\n41. Позвать\n42. Чинить авто\n43. Прислониться к авто\n44. Сложить руки вместе\n"},
			{"45. Держать биту 1\n46. Держать биту 2\n47. Гангстерский жест 1\n48. Гангстерский жест 2\n49. Гангстерский жест 3\n50. Гангстерский жест 4\n51. Гангстерский жест 5\n52. Гангстерский жест 6\n53. Гангстерский жест 7\n54. Гангстерский жест 8\n55. Плакать\n56. Присесть 1\n57. Присесть 2\n58. Присесть облокотившись\n59. Женское курение\n60. Искусственное дыхание\n61. Облокотится\n62. Облокотится 2\n63. Facepalm\n64. Чесаться"}
		};
		t_string[0] = EOS;
		format(t_string, sizeof(t_string), "%s%s%s", Animser[0], Animser[1], Animser[2]);
		ShowPlayerDialog(playerid, D_PLAYER_ANIMATION, DIALOG_STYLE_LIST, ""colserver"Список: "colwhi"Анимаций", t_string, "Выбрать", "Отмена");
	}
	if (params[0] < 0 || params[0] > 64) return SendClientMessage(playerid, 0xFF0000AA, !"/animlist 1-64");
	new seted = strval(params[0]);
	switch(seted)
	{
		case 0:
		{
			new Animsser[][] = {
				{"1. Танец - 1\n2. Танец - 2\n3. Танец - 3\n4. Танец - 4\n5. Стойка дилера\n6. Передал что-то\n7. Съел что-то\n8. Справить нужду\n9. Медитация\n10. Сидеть раненым\n11. Спать на боку\n12. Лечь на спину\n13. Шлепнуть рукой\n14. Наносить граффити 1\n15. Наносить граффити 2\n16. Курение\n17. Ограбление\n18. Одеть маску\n19. Руки в верх\n20. Позвать кого-то\n21. Поднять руки\n22. Болельщик 1\n23. Болельщик 2\n24. Болельщик 3\n"},
				{"25. Показать средний палец\n26. Выпить что-то\n27. Махать руками\n28. Мужское курение\n29. Прилечь 1\n30. Прилечь 2\n31. Прилечь 3\n32. Прилечь 4\n33. Присесть на пол\n34. Читать реп 1\n35. Читать реп 2\n36. Читать реп 3\n37. Читать реп 4\n38. Набивать мяч\n39. Кинуть мяч\n40. Поднять мяч\n41. Позвать\n42. Чинить авто\n43. Прислониться к авто\n44. Сложить руки вместе\n"},
				{"45. Держать биту 1\n46. Держать биту 2\n47. Гангстерский жест 1\n48. Гангстерский жест 2\n49. Гангстерский жест 3\n50. Гангстерский жест 4\n51. Гангстерский жест 5\n52. Гангстерский жест 6\n53. Гангстерский жест 7\n54. Гангстерский жест 8\n55. Плакать\n56. Присесть 1\n57. Присесть 2\n58. Присесть облокотившись\n59. Женское курение\n60. Искусственное дыхание\n61. Облокотится\n62. Облокотится 2\n63. Facepalm\n64. Чесаться"}
			};
			t_string[0] = EOS;
			format(t_string, sizeof(t_string), "%s%s%s", Animsser[0], Animsser[1], Animsser[2]);
			ShowPlayerDialog(playerid, D_PLAYER_ANIMATION, DIALOG_STYLE_LIST, ""colserver"Список: "colwhi"Анимаций", t_string, "Выбрать", "Отмена");
			return 1;
		}
		case 1: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE1);
		case 2: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE4);
		case 5: ApplyAnimation(playerid,"DEALER","Dealer_idle",4.1,1,0,0,0,0,0);
		case 6: ApplyAnimation(playerid,"DEALER","Dealer_Deal",4.1,0,0,0,0,0,1);
		case 7: ApplyAnimation(playerid,"FOOD","Eat_Burger",4.1,0,0,0,0,0,1);
		case 8: ApplyAnimation(playerid,"PAULNMAC","Piss_in",4.1,0,0,0,0,0,1);
		case 9: ApplyAnimation(playerid,"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0,0);
		case 10: ApplyAnimation(playerid,"CRACK","Crckidle1",4.1,1,0,0,0,0,0);
		case 11: ApplyAnimation(playerid,"CRACK","Crckidle2",4.1,1,0,0,0,0,0);
		case 12: ApplyAnimation(playerid,"CRACK","Crckidle4",4.1,1,0,0,0,0,0);
		case 13: ApplyAnimation(playerid,"SWEET","sweet_ass_slap",4.1,0,0,0,0,0,1);
		case 14: ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",4.1,1,0,0,0,0,0);
		case 15: ApplyAnimation(playerid,"GRAFFITI","spraycan_fire",4.1,1,0,0,0,0,0);
		case 16: ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0,0);
		case 17: ApplyAnimation(playerid,"SHOP","ROB_Loop_Threat",4.1,1,0,0,0,0,0);
		case 18: ApplyAnimation(playerid,"SHOP","ROB_shifty",4.1,0,0,0,0,0,1);
		case 19: ApplyAnimation(playerid,"SHOP","SHP_Rob_HandsUP",4.1,1,0,0,0,0,0);
		case 20: ApplyAnimation(playerid,"RYDER","Ryd_Beckon_02",4.1,1,0,0,0,0,0);
		case 21: ApplyAnimation(playerid,"RIOT","Riot_Angry",4.1,0,0,0,0,0,0);
		case 22: ApplyAnimation(playerid,"RIOT","Riot_Angry_B",4.1,1,0,0,0,0,0);
		case 23: ApplyAnimation(playerid,"RIOT","Riot_Chant",4.1,1,1,0,0,0,0);
		case 24: ApplyAnimation(playerid,"RIOT","Riot_Punches",4.1,1,0,0,0,0,0);
		case 25: ApplyAnimation(playerid,"PED","fucku",4.1,0,0,0,0,0,1);
		case 26: ApplyAnimation(playerid,"BAR","dnK_StndM_loop",4.1,0,0,0,0,0,1);
		case 27: ApplyAnimation(playerid,"BD_FIRE","BD_Panic_03",4.1,1,0,0,0,0,0);
		case 28: ApplyAnimation(playerid,"BD_FIRE","M_smklean_loop",4.1,1,0,0,0,0,0);
		case 29: ApplyAnimation(playerid,"BEACH","bather",4.1,1,0,0,0,0,0);
		case 30: ApplyAnimation(playerid,"BEACH","Lay_Bac_loop",4.1,1,0,0,0,0,0);
		case 31: ApplyAnimation(playerid,"BEACH","Parksit_w_loop",4.1,1,0,0,0,0,0);
		case 32: ApplyAnimation(playerid,"BEACH","Sitnwait_Loop_W",4.1,1,0,0,0,0,0);
		case 33: ApplyAnimation(playerid,"BEACH","Parksit_M_loop",4.1,1,0,0,0,0,0);
		case 34: ApplyAnimation(playerid,"benchpress","gym_bp_celebrate",4.1,1,0,0,0,0,0);
		case 35: ApplyAnimation(playerid,"LOWRIDER","Rap_C_loop",4.1,1,0,0,0,0,0);
		case 36: ApplyAnimation(playerid,"LOWRIDER","Rap_B_loop",4.1,1,0,0,0,0,0);
		case 37: ApplyAnimation(playerid,"LOWRIDER","Rap_A_loop",4.1,1,0,0,0,0,0);
		case 38: ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop",4.1,1,0,0,0,0,0);
		case 39: ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1,0,0,0,0,0,1);
		case 40: ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.1,0,0,0,0,0,1);
		case 41: ApplyAnimation(playerid,"CAMERA","camstnd_cmon",4.1,0,0,0,0,0,1);
		case 42: ApplyAnimation(playerid,"CAR","fixn_car_loop",4.1,1,0,0,0,0,0);
		case 43: ApplyAnimation(playerid,"CAR_CHAT","car_talkm_loop",4.1,1,0,0,0,0,0);
		case 44: ApplyAnimation(playerid,"COP_AMBIENT","coplook_loop",4.1,1,0,0,0,0,0);
		case 45: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_01",4.1,1,0,0,0,0,0);
		case 46: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_02",4.1,1,0,0,0,0,0);
		case 47: ApplyAnimation(playerid,"GHANDS","gsign1",4.1,0,0,0,0,0,1);
		case 48: ApplyAnimation(playerid,"GHANDS","gsign2",4.1,0,0,0,0,0,1);
		case 49: ApplyAnimation(playerid,"GHANDS","gsign3",4.1,0,0,0,0,0,1);
		case 50: ApplyAnimation(playerid,"GHANDS","gsign4",4.1,0,0,0,0,0,1);
		case 51: ApplyAnimation(playerid,"GHANDS","gsign5",4.1,0,0,0,0,0,1);
		case 52: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1,0,0,0,0,0,1);
		case 53: ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1,0,0,0,0,0,1);
		case 54: ApplyAnimation(playerid,"GHANDS","gsign4LH",4.1,0,0,0,0,0,1);
		case 55: ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1,1,0,0,0,0,0);
		case 56: ApplyAnimation(playerid,"MISC","seat_LR",4.1,1,0,0,0,0,0);
		case 57: ApplyAnimation(playerid,"INT_HOUSE","Lou_in",4.1,0,1,1,1,1,0);
		case 58: ApplyAnimation(playerid,"INT_OFFICE","OFF_sit_Bored_loop",4.1,1,0,0,0,0,0);
		case 59: ApplyAnimation(playerid,"LOWRIDER","F_smklean_loop",4.1,1,0,0,0,0,0);
		case 60: ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,0,0,0,0,1);
		case 61: ApplyAnimation(playerid,"GANGS","LeanIn",4.1,0,1,1,1,1,0);
		case 62: ApplyAnimation(playerid,"MISC","plyrlean_loop",4.1,1,0,0,0,0,0);
		case 63: ApplyAnimation(playerid,"MISC","plyr_shkhead",4.1,0,0,0,0,0,1);
		case 64: ApplyAnimation(playerid,"MISC","scratchballs_01",4.1,1,0,0,0,0,0);
	}
	TextDrawShowForPlayer(playerid, InfoAnimDraw);
	SetPVarInt(playerid, #PlayerAnimation , 1);
	return 1;
}
alias:animlist("anim");
CMD:clist(playerid, params[])
{
	if (pTemp[playerid][tDMArea][0]) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на ДМ-Арене");
	if (pTemp[playerid][tPaintTeam] != 0 || IsPlayerInDuel(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на дуэлях / PB");
    new temp = capture_band( pInfo[playerid][pMember] );
    if (temp != INVALID_PLAYER_ID) {
    	if (capture_now[temp] != 0) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать во время капта!");
    }
    if ((pInfo[playerid][pMember] == mafia_frac_id[0] || pInfo[playerid][pMember] == mafia_frac_id[1]) && ZoneTimer > 0)
        return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать во время стрелы!");
    if (sscanf(params, "d",params[0]))
    {
	    new dialog[512 char];
		strcat(dialog, !"[0]	Выключить цвет\n[1]	Зелёный\n[2]	Светло зелёный\n[3]	Ярко зелёный\n[4]	Бирюзовый\n[5]	Жёлто-зелёный\n[6]	Тёмно-зелёный\n[7]	Серо-зелёный\n[8]	Красный\n[9]	Ярко-красный\n[10]	Оранжевый\n[11]	Коричневый\n[12]	Тёмно-красный\n[13]	Cеро-красный\n[14]	Жёлто-оранжевый\n[15]	Малиновый\n[16]	Розовый\n[17]	Синий\n[18]	Голубой\n[19]	Синяя сталь\n[20]	Сине-зелёный\n[21]	Тёмно-синий\n[22]	Фиолетовый\n");
		strcat(dialog, !"[23]	Индиго\n[24]	Серо-синий\n[25]	Жёлтый\n[26]	Кукурузный\n[27]	Золотой\n[28]	Старое золото\n[29]	Оливковый\n[30]	Серый\n[31]	Серебро\n[32]	Чёрный\n[33]	Белый");
		return ShowPlayerDialog(playerid, D_PLAYER_CLIST, DIALOG_STYLE_LIST, !"Цвет", dialog, !"Выбрать", !"Отмена");
	}
	else
	{
	    if (params[0] > 33) return SendClientMessage(playerid, COLOR_GREY, !" Неверный цвет");
	    switch(params[0])
	    {
	        case 0: SetPlayerColor(playerid, TEAM_HIT_COLOR); case 1: SetPlayerColor(playerid,0x089401FF);
			case 2: SetPlayerColor(playerid,0x56FB4EFF); case 3: SetPlayerColor(playerid,0x49E789FF);
			case 4: SetPlayerColor(playerid,0x2A9170FF); case 5: SetPlayerColor(playerid,0x9ED201FF);
			case 6: SetPlayerColor(playerid,0x279B1EFF); case 7: SetPlayerColor(playerid,COLOR_GREEN);
			case 8: SetPlayerColor(playerid,0xFF0606FF); case 9: SetPlayerColor(playerid,0xFF6600FF);
			case 10: SetPlayerColor(playerid,0xF45000FF); case 11: SetPlayerColor(playerid,0xBE8A01FF);
			case 12: SetPlayerColor(playerid,0xB30000FF); case 13: SetPlayerColor(playerid,0x954F4FFF);
			case 14: SetPlayerColor(playerid,0xE7961DFF); case 15: SetPlayerColor(playerid,0xE6284EFF);
			case 16: SetPlayerColor(playerid,0xFF9DB6FF); case 17: SetPlayerColor(playerid,0x110CE7FF);
			case 18: SetPlayerColor(playerid,0x0CD7E7FF); case 19: SetPlayerColor(playerid,0x139BECFF);
			case 20: SetPlayerColor(playerid,0x2C9197FF); case 21: SetPlayerColor(playerid,0x114D71FF);
			case 22: SetPlayerColor(playerid,0x8813E7FF); case 23: SetPlayerColor(playerid,0xB313E7FF);
			case 24: SetPlayerColor(playerid,0x758C9DFF); case 25: SetPlayerColor(playerid,0xFFDE24FF);
			case 26: SetPlayerColor(playerid,0xFFEE8AFF); case 27: SetPlayerColor(playerid,COLOR_ORANGE);
			case 28: SetPlayerColor(playerid,0xDDA701FF); case 29: SetPlayerColor(playerid,0xB0B000FF);
			case 30: SetPlayerColor(playerid,0x868484FF); case 31: SetPlayerColor(playerid,0xB8B6B6FF);
			case 32: SetPlayerColor(playerid,0x333333FF); case 33: SetPlayerColor(playerid,0xFAFAFAFF);
		}
	}
	return 1;
}



CMD:safe(playerid)
{
	if (pTemp[playerid][tCurrentHouseID] == -1) {
		SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться дома");
		return 1;
	}
	new
		H_IDX = pTemp[playerid][tCurrentHouseID],
		idx = HouseInfo[H_IDX][hIntID];
	if (!IsPlayerInRangeOfPoint(playerid, 50, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) || GetPlayerVirtualWorld(playerid) != H_IDX + 50) return 1;
	if (!IsPlayerInRangeOfPoint(playerid, 2.0, HouseInt[idx][hSafePos][0], HouseInt[idx][hSafePos][1], HouseInt[idx][hSafePos][2]) || GetPlayerVirtualWorld(playerid) != H_IDX + 50) 
		return SendClientMessage(playerid,COLOR_WHITE, !"Вы далеко от сейфа!");
    if (GetPlayerVirtualWorld(playerid) != H_IDX + 50) return 1; 
	if (HouseInfo[H_IDX][hFamily] != -1) {
		if (HouseInfo[H_IDX][hFamily] != pInfo[playerid][pFamily]) {
			SendClientMessage(playerid, COLOR_GREY, !"Этот дом не Вашей семьи");
			return 1;
		} 
		if (FamilyInfo[ HouseInfo[H_IDX][hFamily] - 1 ][fSafeLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Сейф семьи закрыт!");
		format(t_string, sizeof t_string, ""colwhi"Наименование\t"colwhi"Количество\n\
			{758C9D}Материалы\t"colwhi"[%d/20000]\n\
			{758C9D}Наркотики\t"colwhi"[%d/5000]\n\
			{758C9D}Ключи от камеры\t"colwhi"[%d/300]\n\
			{758C9D}Готовая рыба\t"colwhi"[%d/5000]\n\
			"colserver" - Оружие",
		HouseInfo[H_IDX][hSafe][0], HouseInfo[H_IDX][hSafe][1],
		HouseInfo[H_IDX][hSafe][2], HouseInfo[H_IDX][hSafe][3] );
		new	
			strTitle[90];
		format(strTitle, sizeof strTitle, ""colwhi"Сейф | {%s}%s", family_chat_color[ FamilyInfo[ HouseInfo[H_IDX][hFamily] - 1 ][fChatColor] ], FamilyInfo[ HouseInfo[H_IDX][hFamily] - 1 ] [fName]);
		ShowPlayerDialog(playerid, D_SAFE_FAMILY_0, DIALOG_STYLE_TABLIST_HEADERS, strTitle, t_string, "Выбор", "Отмена"), t_string[0] = EOS;
	}
	else {
		if (pInfo[playerid][pHouseID] != H_IDX) return SendClientMessage(playerid,COLOR_WHITE, !"Данный дом не принадлежит Вам");
		format(t_string, sizeof t_string, ""colwhi"Наименование\t"colwhi"Количество\n\
		{758C9D}Материалы\t"colwhi"[%d/5000]\n\
		{758C9D}Наркотики\t"colwhi"[%d/1500]\n\
		{758C9D}Ключи от камеры\t"colwhi"[%d/50]\n\
		{758C9D}Готовая рыба\t"colwhi"[%d/250]\n"colserver" - Оружие",
		HouseInfo[H_IDX][hSafe][0], HouseInfo[H_IDX][hSafe][1],
		HouseInfo[H_IDX][hSafe][2], HouseInfo[H_IDX][hSafe][3] );
		ShowPlayerDialog(playerid, D_SAFE_FUNC_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Дом: "colwhi"Сейф", t_string, "Выбор", "Отмена"), t_string[0] = EOS;
	}
	return 1; 
}

CMD:open(playerid)
{
	if (pInfo[playerid][pHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома!");
	new H_IDX = pInfo[playerid][pHouseID],
		idx = HouseInfo[H_IDX][hIntID];
	if ((!IsPlayerInRangeOfPoint( playerid,10,HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) || GetPlayerVirtualWorld(playerid) != H_IDX+50) 
		&& !IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2])) return 1;
	if (HouseInfo[H_IDX][hLock] == 1) HouseInfo[H_IDX][hLock] = 0, GameTextForPlayer(playerid, !"~w~House ~g~UNLOCK", 5000, 3);
	else if (HouseInfo[H_IDX][hLock] == 0) HouseInfo[H_IDX][hLock] = 1, GameTextForPlayer(playerid, !"~w~House ~r~LOCK", 5000, 3);
	new query_[128];
	format(query_, sizeof(query_), "UPDATE `house` SET `hLock`= '%d' WHERE `hID` = '%d'", HouseInfo[H_IDX][hLock], HouseInfo[H_IDX][hID]);
	mysql_tquery(dbHandle, query_, "", "");
	PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	return 1;
}

CMD:robhouse(playerid, params[]) {
	if (!IsAGang(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не бандит!");
	new idx = 0;

	for(new i = 1; i <= TOTALHOUSE; i++) {
		if (IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2]) && GetPlayerVirtualWorld(playerid) == 0) {
			idx = i;
			break;
		}
	}
	if(!idx) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с домом!");
	new 
		Float:vehx, 
		Float:vehy, 
		Float:vehz;

	GetVehiclePos(pTemp[playerid][tRobVeh], vehx, vehy, vehz);
	if(!IsPlayerInRangeOfPoint(playerid, 11.0, vehx,vehy,vehz)) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с фургоном"); 
	if(!IsPlayerToGhetto(playerid)) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Грабить дом можно только на территории гетто");
	/* проверка на свой дом */
	if (!strcmp(HouseInfo[idx][hOwner],"None",true)) return SendClientMessage(playerid, COLOR_GREY, !"У дома нет владельца!");
	if (HouseInfo[idx][hRobHouse]) return SendClientMessage(playerid, COLOR_GREY, !"Этот дом уже был ограблен в этом часу");
	/* Сделать отмычки */
	pTemp[playerid][tActionType] = ACTION_ROB_HOUSE;
	pTemp[playerid][tActionStep] = 0;
	ActionMiniGamePlayer(playerid, true);
	SetPVarInt(playerid, "playerRobIDX", idx); 
	HouseInfo[idx][hRobHouse] = true; 
	return 1;
}
/*	
CMD:callsign( playerid, params[] ) 
{
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Вы не находитесь в машине"); 
	if (sscanf(params, "s[60]", params[0]) || strlen(params[0]) > 60) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /callsign [текст]");	
	new 
		V_IDX = GetPlayerVehicleID(playerid); 
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
		(VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_LSPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_SFPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_LVPD || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_FBI))
	{
		if (VehicleInfo[ V_IDX - 1 ][vText] == Text3D:-1) {
			VehicleInfo[ V_IDX - 1 ][vText] = CreateDynamic3DTextLabel(params[0], 0xFFFFFF80,
				VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2],
				7.6, INVALID_PLAYER_ID, VehicleInfo[ V_IDX - 1 ][vVehicle], 12000, 3, 0, 1
			); 
			AttachDynamic3DTextLabelToVeh(VehicleInfo[ V_IDX - 1 ][vText], VehicleInfo[ V_IDX - 1 ][vVehicle], 0.0, 0.0, -0.8);
			new
				string_[256];
			format(string_, sizeof string_, "[R] %s %s: установил маркировку: %s (( /dellsign %d ))",fFractionRank[pInfo[playerid][pMember]][pInfo[playerid][pRank] - 1], pInfo[playerid][pName], params[0], V_IDX);
			SendRadioMessage(pInfo[playerid][pMember], TEAM_BLUE_COLOR, string_);
		}
		else { 
			DestroyDynamic3DTextLabel(VehicleInfo[ V_IDX - 1 ][vText]);
			VehicleInfo[ V_IDX - 1 ][vText] = Text3D:-1; 
		} 
	} 
	else SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в полицейской машине");  
	return 1;
}
CMD:dellsign( playerid, params[] )
{
	if (!IsACop(playerid) && pInfo[playerid][pAdmin] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	new
		string_[256];
	if (pInfo[playerid][pRank] < fInfo[ pInfo[playerid][pMember] ][fHelper][0] && pInfo[playerid][pAdmin] == 0) {
		format(string_, sizeof string_, "Данная команда доступна с %i ранга", fInfo[ pInfo[playerid][pMember] ][fHelper][0]);
		SendClientMessage(playerid, COLOR_GREY, string_);
		return 1;
	}
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /dellsign [ID]");
	if (params[0] < 1 || params[0] > S_VEHICLE_COUNT) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный ID"); /S_VEHICLE_COUNT - Переменная серверного ТС 
	if (pInfo[playerid][pAdmin] == 0) {
		if (VehicleInfo[ params[0] - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ params[0] - 1 ][vFraction] != pInfo[playerid][pMember])) 
			return SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт не принадлежит Вашей организации!");
	}
	
	if (VehicleInfo[ params[0] - 1 ][vText] != Text3D:-1)
	{
		DestroyDynamic3DTextLabel(VehicleInfo[ params[0] - 1 ][vText]);
		VehicleInfo[ params[0] - 1 ][vText] = Text3D:-1;  
		SendClientMessage(playerid, COLOR_LI_RED, "[Информация] "colwhi"Маркировка транспорта была удалена!");
		return true;
	}
	else SendClientMessage(playerid, COLOR_LI_RED, "[Информация] "colwhi"Никто из сотрудников не устанавливал маркировку");
	return 1;
}*/
#if !defined _poffer_inc
CMD:myskill(playerid, params[])
{
    if (sscanf(params, "u",params[0]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /myskill [id] - Показать выписку другому человеку");
		show_skill(playerid, playerid);
		return 1;
	}
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами");
	SendMes(playerid,0x6495EDFF,"Вы предложили %s посмотреть ваши навыки владением оружия",pInfo[params[0]][pName]);
	SendMes(params[0],0x6495EDFF,"%s предлагает Вам посмотреть его навыки владения оружием. (( Нажмите: {33AA33}Y {6495ED}- согласиться или "colred"N {6495ED}- отказаться))", pInfo[playerid][pName]);
	Select[params[0]][SelectCharSkill] = 255;
	SetPVarInt(params[0], "PlayerSkillID", playerid);
	return 1;
}
#endif


CMD:carpass(playerid, params[])
{
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине!");
	new 
		V_IDX = GetPlayerVehicleID(playerid), 
		str_[94];
	
	if (VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_PLAYER) return SendClientMessage(playerid, -1, !"Данное транспортное средство принадлежит организации.");
	
	new ownerName[MAX_PLAYER_NAME + 1];
	strcpy(ownerName, "неизвестен");

	foreach (new i : Player)
	{
		if (pInfo[i][pID] == VehicleInfo[V_IDX - 1][vFraction]) 
		{
			strcpy(ownerName, pInfo[i][pName]);
			break;
		}
	}

	if (sscanf(params, "u", params[0]) || params[0] == playerid)
	{
	    SendClientMessage(playerid, 0x0AA8DAFF, !"-------========[ VEHICLE PASSPORT ]========-------");
		SendMes(playerid, 0xC0E1EEFF, " Модель: %s(%d)",VehicleNames[VehicleInfo[ V_IDX - 1 ][vModel]-400], VehicleInfo[ V_IDX - 1 ][vModel]);
		SendMes(playerid, 0xC0E1EEFF, " Владелец: %s", ownerName);
		SendMes(playerid, 0xC0E1EEFF, " Пробег: %.3fкм", VehicleInfo[ V_IDX - 1 ][vMillage]);
		SendMes(playerid, 0xC0E1EEFF, " Номерной знак: %s", VehicleInfo[ V_IDX - 1 ][vNumber]);
		SendMes(playerid, 0xC0E1EEFF, " Двигатель: "colrose"%s", vehicleNameEngine[VehicleInfo[ V_IDX - 1 ][vPT_Engine][0]]);
		SendMes(playerid, 0xC0E1EEFF, " Тормоза: "colrose"%s", vehicleNameBreak[VehicleInfo[ V_IDX - 1 ][vPT_Engine][3]]);  
		SendClientMessage(playerid, 0x0AA8DAFF, !"-------====================================-------");
		MeAction(playerid, "достал(а) документы из бардачка", SELECT_ACTION_GENERAL);
		return 1;
	}
	if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid,-1, !"Игрок не в сети");

    if (!IsPlayerInRangeOfPoint(playerid, 5, pTemp[params[0]][tPos][0], pTemp[params[0]][tPos][1], pTemp[params[0]][tPos][2] ) || GetPlayerVirtualWorld(params[0]) != GetPlayerVirtualWorld(playerid)) return SendClientMessage(playerid, -1, !"Игрок слишком далеко");
    SendClientMessage( params[0], 0x0AA8DAFF, !"-------========[ VEHICLE PASSPORT ]========-------");
	SendMes( params[0], 0xC0E1EEFF, " Модель: %s(%d)",VehicleNames[VehicleInfo[ V_IDX - 1 ][vModel]-400], VehicleInfo[ V_IDX - 1 ][vModel]);
	SendMes( params[0], 0xC0E1EEFF, " Владелец: %s", ownerName);
	SendMes( params[0], 0xC0E1EEFF, " Пробег: %.3fкм", VehicleInfo[ V_IDX - 1 ][vMillage]);
	SendMes( params[0], 0xC0E1EEFF, " Номерной знак: %s", VehicleInfo[ V_IDX - 1 ][vNumber]);
	SendMes( params[0], 0xC0E1EEFF, " Двигатель: "colrose"%s", vehicleNameEngine[VehicleInfo[ V_IDX - 1 ][vPT_Engine][0]]);
	SendMes( params[0], 0xC0E1EEFF, " Тормоза: "colrose"%s", vehicleNameBreak[VehicleInfo[ V_IDX - 1 ][vPT_Engine][3]]);  
	SendClientMessage( params[0], 0x0AA8DAFF, !"-------====================================-------");

	format(str_, sizeof str_, "достал(а) документы из бардачка и показал их %s",pInfo[params[0]][pName]);
	SetPlayerChatBubble(playerid, str_,COLOR_PURPLE,30.0,10000);

	format(str_, sizeof str_, "%s достал(а) документы из бардачка и показал их %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
	SendBeside(playerid, COLOR_PURPLE, str_, 10.0);
	return 1;
} 
CMD:fixcar(playerid)
{ 
	if (Iter_Count(PlayerListVehicle[playerid]) == 0)
	{
		new H_IDX = pInfo [ playerid ] [ pHouseID ];

		if ( H_IDX == -1 )
			return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"У Вас нет транспорта или он находится на штрафстоянке");
		
		if ( pTemp [ playerid ] [ tMopedGarage ] != INVALID_VEHICLE_ID )
			_DestroyVehicle ( pTemp [ playerid ]  [ tMopedGarage ] );

		pTemp [ playerid ] [ tMopedGarage ] = INVALID_VEHICLE_ID;
		
		new G_IDX = HouseInfo [ H_IDX ] [ hGarageID ];

		pTemp [ playerid ] [ tMopedGarage ] = _CreateVehicle(462, GarageInt[G_IDX][gCarPos_0][0], GarageInt[G_IDX][gCarPos_0][1], GarageInt[G_IDX][gCarPos_0][2], GarageInt[G_IDX][gCarPos_0][3], 1, 0, 0, 300);
		VehicleInfo[ pTemp [ playerid ] [ tMopedGarage ] ][vFuel] = GetModelMaxFuel(462);
		
		LinkVehicleToInterior( pTemp [ playerid ] [ tMopedGarage ], GarageInt[G_IDX][gIntInterior] );
		SetVehicleVirtualWorld ( pTemp [ playerid ] [ tMopedGarage ], GarageHouse[H_IDX][gVirtualWorld] );
		return 1;
	}
	new string_[128],
		TOTAL_VEH = 0;

	t_string[0] = EOS;
	strcat(t_string, ""colserver"[№] Название(Модель)\t"colserver"Номерной знак\n");
	foreach(new veh_id:PlayerListVehicle[playerid]) {
		format(string_, sizeof string_, "[%d] %s(%d)\t%s\n", TOTAL_VEH, VehicleNames[ GetVehicleModel(veh_id) - 400 ], GetVehicleModel(veh_id), VehicleInfo[ veh_id - 1 ][vNumber]);
		strcat(t_string, string_);
		TOTAL_VEH++;
	}
	ShowPlayerDialog(playerid, D_FIXCAR_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Личный Транспорт", t_string, "Принять", "Отмена");
	return 1;
}
CMD:givevkey(playerid, params[])
{
	new V_IDX = GetPlayerVehicleID(playerid);
	if (IsValidVehicle(V_IDX))
	{
		if (VehicleInfo[ V_IDX - 1 ][vFraction] != pInfo[playerid][pID] || VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_PLAYER) return SendClientMessage(playerid, -1, !"Вы должны находиться в Вашем личном транспорте!" ) ;
		if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /givevkey [id]");
		if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0]) || GetPlayerVirtualWorld(params[0]) != GetPlayerVirtualWorld(playerid)) 
			return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами");
		if (pTemp[params[0]][tVehicleKey] > 0) return SendClientMessage ( playerid, -1, "У игрока уже есть ключи от какого-либо автомобиля" ) ;
		pTemp[params[0]][tVehicleKey] = V_IDX;
		new string_[128];
		format(string_, sizeof string_, "Вы успешно выдали ключи от Вашего автомобиля игроку "colserver"%s", pInfo[params[0]][pName]);
		SendClientMessage(playerid, COLOR_WHITE, string_);
		format(string_, sizeof string_, "%s "colwhi"выдал Вам ключи от своего автомобиля.", pInfo[playerid][pName]);
		SendClientMessage(params[0], COLOR_SERVER, string_);
	}
	else SendClientMessage ( playerid, -1, "Для передачи ключей от автомобиля необходимо быть в нём") ;
	return 1 ;
}

CMD:takevkey(playerid, params[])
{
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /takevkey [id]");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0]) || GetPlayerVirtualWorld(params[0]) != GetPlayerVirtualWorld(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами"); 
	if (pTemp[params[0]][tVehicleKey] == 0 ) return SendClientMessage(playerid, -1, "У игрока нет ключей от Вашего автомобиля");
	if (Iter_Count(PlayerListVehicle[playerid]) != 0)foreach(new veh_id:PlayerListVehicle[playerid])
	{
		if (pTemp[params[0]][tVehicleKey] == veh_id)
		{
			new string_[100];
			pTemp[params[0]][tVehicleKey] = 0;
			format(string_, sizeof string_, "%s "colwhi"забрал у Вас ключи от своего автомобиля.", pInfo[playerid][pName]);
			SendClientMessage(params[0], COLOR_SERVER, string_);
			format(string_, sizeof string_, "Вы успешно забрали ключи от своего автомобиля у "colserver"%s", pInfo[params[0]][pName]);
			SendClientMessage(playerid, COLOR_WHITE, string_);
			return 1;
		}
		else continue ;
	}
	SendClientMessage ( playerid, -1, "У игрока нет ключей от Вашего автомобиля" ) ;
	return 1 ;
}
CMD:leave(playerid)
{
	if (pInfo[playerid][pLeader]) return SendClientMessage(playerid, COLOR_GREY, !"Данную команду запрещенно использовать лидеру");
	if (!pInfo[playerid][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в организации");
	if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать в машине");
	ShowPlayerDialog(playerid, D_FRACTION_FUNC_28, DIALOG_STYLE_MSGBOX, ""colserver"Организация: "colwhi"Увольнение", "\n\n"colwhi"Вы действительно хотите покинуть организацию по собственному желанию?\nВы должны будете заплатить штраф в сумме "collime"$15.000\n", "Уволиться", "Отмена");
	return 1;
}
CMD:sellcar(playerid, params[])
{
	//if(!IsPlayerInRangeOfPoint(playerid, 2.0, 902.9178,-1190.7859,16.9832)) return SendClientMessage(playerid,COLOR_RED, !"{FF0000}[Ошибка!]"colwhi"Вы должны находится На авто базаре!");
	new V_IDX = GetPlayerVehicleID(playerid),
		null,
		t_stra[256];
	if (IsValidVehicle(V_IDX))
	{
		if (VehicleInfo[ V_IDX - 1 ][vFraction] != pInfo[playerid][pID] || VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_PLAYER) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы должны находиться в Вашем личном транспорте!");
		if (sscanf(params, "ud", params[0], params[1]))
		{
		    switch(GetVehicleModel(V_IDX))
			{ 
				case 400: null = 130_000;//n 0
				case 567: null = 200_000;
				case 549: null = 120_000;
				case 547: null = 110_000;
				case 546: null = 140_000;
				case 543: null = 100_000;
				case 527: null = 100_000;
				case 526: null = 110_000;
				case 518: null = 170_000;
				case 517: null = 150_000;
				case 516: null = 140_000;
				case 492: null = 140_000;
				case 479: null = 110_000;
				case 478: null = 100_000;
				case 475: null = 190_000;
				case 466: null = 110_000;
				case 458: null = 120_000;
				case 439: null = 150_000;
				case 436: null = 100_000;
				case 404: null = 100_000;
				case 419: null = 800_000;//c 
				case 586: null = 800_000;
				case 581: null = 1_000_000;
				case 461: null = 1_000_000;
				case 418: null = 700_000;
				case 603: null = 750_000;
				case 589: null = 770_000;
				case 580: null = 1_000_000;
				case 579: null = 940_000;
				case 561: null = 910_000;
				case 555: null = 940_000;
				case 554: null = 840_000;
				case 534: null = 760_000;
				case 533: null = 920_000;
				case 505: null = 880_000;
				case 491: null = 800_000;
				case 489: null = 880_000;
				case 445: null = 810_000;
				case 421: null = 830_000;//c 
				case 401: null = 340_000;//d 39
				case 600: null = 420_000;
				case 585: null = 360_000;
				case 576: null = 350_000;
				case 575: null = 460_000;
				case 566: null = 340_000;
				case 551: null = 480_000;
				case 550: null = 480_000;
				case 540: null = 330_000;
				case 536: null = 400_000;
				case 529: null = 440_000;
				case 507: null = 450_000;
				case 474: null = 370_000;
				case 467: null = 390_000;
				case 426: null = 420_000;
				case 422: null = 310_000;
				case 412: null = 390_000;
				case 405: null = 400_000;//d 56 
				case 477: null = 2_200_000;//b 57
				case 471: null = 2_100_000;
				case 468: null = 1_900_000;
				case 463: null = 2_000_000;
				case 521: null = 1_900_000;
				case 602: null = 2_000_000;
				case 587: null = 2_100_000;
				case 565: null = 2_100_000;
				case 562: null = 2_200_000;
				case 560: null = 2_250_000;
				case 559: null = 2_200_000;
				case 558: null = 2_100_000;
				case 545: null = 1_900_000;
				case 535: null = 2_000_000;
				case 480: null = 2_400_000;//b 71 
				case 402: null = 4_800_000;//a 72
				case 503: null = 6_000_000;
				case 502: null = 6_000_000;
				case 494: null = 6_000_000;
				case 495: null = 5_800_000; 
				case 434: null = 4_800_000;
				case 522: null = 4_600_000;
				case 541: null = 6_000_000;
				case 506: null = 5_100_000;
				case 451: null = 6_000_000;
				case 429: null = 5_400_000;
				case 415: null = 5_600_000;
				case 411: null = 6_000_000;//a 84
				case 454: null = 14_000_000;//Boat 
				case 446: null = 8_000_000; 
				case 484, 508: null = 12_000_000; 
				case 493: null = 10_000_000;// END BOAT
				case 513: null = 5_000_000; //Plane
				case 519: null = 30_000_000; 
				case 553: null = 25_000_000;
				case 511: null = 20_000_000; 
				case 487: null = 14_000_000; 
				case 469: null = 10_000_000; // END PLANE
				/*
				case 469: null = 10_000_000; // END PLANE // слоты для донат авто 
				case 469: null = 10_000_000; // END PLANE
				case 469: null = 10_000_000; // END PLANE
				*/
		  		//default: return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете продать данный автомобиль!");
			}
			new cost = null / 2;
			SetPVarInt(playerid, "playerCarCost", cost);
			SetPVarInt(playerid, "playerCarID", V_IDX);
			format(t_stra, sizeof t_stra, ""colwhi"При продаже личного автомобиля "colserver"(%s)"colwhi" государству\nГосударство возместит не полную стоимость авто\n\n\
			Цена автомобиля составит: "collime"$%d\n\n"colwhi"Подтвердите продажу", VehicleNames[ VehicleInfo[ V_IDX - 1 ][vModel] - 400 ], cost);
			ShowPlayerDialog(playerid, D_PLAYER_SELLCAR_0, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Автомобиля", t_stra, "Продать","Отмена");
			SendClientMessage(playerid, COLOR_WHITE, !"Для продажи игроку используйте: /sellcar [ID] [Цена]");
			return 1;
		}
        if (!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
		if (params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали свой ID");
		if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом");
		if (!IsPlayerInRangeOfPoint(playerid, 5, pTemp[params[0]][tPos][0], pTemp[params[0]][tPos][1], pTemp[params[0]][tPos][2]) || GetPlayerVirtualWorld(params[0]) != GetPlayerVirtualWorld(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок слишком далеко от Вас");
		if (params[1] < 1 || params[1] > 100_000_000) return SendClientMessage(playerid, COLOR_GREY, !"Цена не может быть меньше 1 или больше $100.000.000");

		format(t_stra, sizeof t_stra, 
			"{ffffff}%s[%d] предлагает Вам приобрести "colserver"%s(%d)\n{ffffff}Цена: "collime"$%d",
			pInfo[playerid][pName], playerid, VehicleNames[ VehicleInfo[ V_IDX - 1 ][vModel] - 400 ], VehicleInfo[ V_IDX - 1 ][vModel], params[1]
		);
		ShowPlayerDialog(params[0], D_PLAYER_SELLCAR_1, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Автомобиля", t_stra, "Купить","Отмена"); 

		format(t_stra, sizeof t_stra, "Вы предложили "colserver"%s "colwhi"купить Ваш транспорт, за "collime"$%d",pInfo[params[0]][pName], params[1]);
		SendClientMessage(playerid, COLOR_WHITE, t_stra);
		SetPVarInt(playerid, "sc_price", params[1]);
		SetPVarInt(playerid, "sc_buyer", params[0]);
		SetPVarInt(params[0], "sc_seller", playerid);
		SetPVarInt(params[0], "sc_sellveh", V_IDX);
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в Транспорте");
	return 1 ;
} 
/*
CMD:leaders(playerid, params[])
{
	SendClientMessage(playerid, 0xF10DEB10AA, !"Лидеры Online:");
	new str_[128];
	foreach(new i: PlayerInLogin)
	{
		if (pInfo[i][pLeader] > 0 && pInfo[i][pLogin] == 1)
		{
			format(str_, sizeof(str_), " %s: %s [тел: %d]",gFraction[pInfo[i][pLeader]][fName],pInfo[i][pName],pInfo[i][PlayerNumber]);
			SendClientMessage(playerid, 0xF99DEB9AA, str_);
		}
	}
	return 1;
}*/

CMD:leaders(playerid)
{
	//if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new
		str_[128],
		total_ = 0;
	t_string[0] = EOS;
	strcat(t_string, ""colserver"[№] Организации\t"colserver"Лидер\t"colserver"Телефон\t"colserver"Статус\n");
	for(new i = 1; i <= TOTAL_FRACTION; i++)
	{
		new	getid_ = GetCheckID(fInfo[i][fLeader]);
		if (getid_ != INVALID_PLAYER_ID)
		{
			format(str_, sizeof str_,""colwhi"[%d] %s\t%s(%d)\t%d\t%s\n",
				i, fInfo[i][fName], pInfo[getid_][pName], getid_, pInfo[getid_][PlayerNumber], pTemp[getid_][PlayerAFK]>=3?(""colwarn"[AFK]"colwhi""):(""collime"[ONLINE]"colwhi""));
            strcat(t_string, str_);
			total_ ++;
		}
		else
		{
			if (!strcmp(fInfo[i][fLeader],"None",true)) format(str_, sizeof str_, ""colwhi"[%d] %s\t"colwarn"Отсутствует"colwhi"\t-\t-\n", i, fInfo[i][fName]);
			else format(str_, sizeof str_, ""colwhi"[%d] %s\t%s\t-\t"colwarn"[OFFLINE]\n", i, fInfo[i][fName], fInfo[i][fLeader]);
			strcat(t_string, str_);
		}
	}
	format(str_, sizeof str_, "- В сети %d %s", total_, Declension_ReturnWord(total_, "лидер", "лидера", "лидеров"));
	strcat(t_string, str_);
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Список: "colwhi"Лидеров организаций", t_string, "Закрыть", ""), t_string[0] = EOS;
	return 1;
}
CMD:subleaders(playerid) {
	new countleader = 0;
	new
		str_[128];
	t_string[0] = EOS;
	strcat(t_string, ""colserver"[№] Никнейм(ID)\t"colserver"Телефон\t"colserver"Организация\t"colserver"Статус\n");
	foreach(new i: PlayerInLogin) {
		if (!pInfo[i][pLogin] || AntiCheatIsKickedWithDesync(i)) continue;
		if (pInfo[i][pMember] == INVALID_FRACTION_ID) continue;
		if (pInfo[i][pLeader] != INVALID_FRACTION_ID) continue;
		if (pInfo[i][pMember] == FRACTION_PIRUS || pInfo[i][pMember] == FRACTION_BALLAS || pInfo[i][pMember] == FRACTION_VAGOS || pInfo[i][pMember] == FRACTION_GROVE || pInfo[i][pMember] == FRACTION_AZTEC || pInfo[i][pMember] == FRACTION_RIFA) continue;
		if (pInfo[i][pRank] < fInfo[pInfo[i][pMember]][fHelper][0]) continue;
		if (pInfo[i][pAdmin]) continue;
		format(str_, sizeof str_, ""colwhi"[%d] %s(%d)\t[т. %d]\t%s\t%s\n", countleader,
			pInfo[i][pName], i, pInfo[i][PlayerNumber], 
			fInfo[ pInfo[i][pMember] ][fName],
			pTemp[i][PlayerAFK] >= 3 ? (""colwarn"[AFK]"colwhi""):(""collime"[ONLINE]"colwhi"")
		);
		strcat(t_string, str_);
		countleader++;
	}
	if (countleader > 0) { 
		new 
			string_[70];
		format(string_, sizeof string_, ""colserver"Заместители: "colwhi"Организаций (В сети: %d)", countleader);
		ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, string_, t_string, "Закрыть", "");
	} else {
		ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, 
			""colserver"Список: "colwhi"Заместители организаций",
			""colwhi"Нет заместителей в сети", 
			"Закрыть", ""
		);
	}
	return 1;
}

//""colserver"Организация: "colwhi"%s (В сети: %d)"
CMD:instructors(playerid, params[])
{
	SendClientMessage(playerid, 0x6495EDFF, !"Инструкторы Online:");
	new string_[128];
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue;
		if (pInfo[i][pMember] != 11) continue;
		format(string_, sizeof string_, "Инструктор: %s тел: %d", pInfo[i][pName], pInfo[i][PlayerNumber]);
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	return 1;
}
CMD:members(playerid)
{
    if (pInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта функция");
    pTemp[playerid][tSelectPage] = 1;
    //pTemp[playerid][tSelectNextList] = 0;
	ShowPlayerMemberFraction(playerid, pInfo[playerid][pMember]);
    return 1;
}
CMD:testmemebers(playerid) {
	if (pInfo[playerid][pAdmin] < 9 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (pInfo[playerid][pMember] == 0) return true;
	new
		fraction_id = pInfo[playerid][pMember],
		sort_rank,
		array_memebers[MAX_PLAYERS][2],
		idx[2];
	foreach(new i: PlayerTeam[fraction_id]) {
		sort_rank = pInfo[i][pRank];
		if (!sort_rank) continue;

		if (pInfo[i][pMember] == fraction_id && (idx[0] + 1) < sizeof (array_memebers)) {
			array_memebers[idx[0]][0] = i;
			array_memebers[idx[0]++][1] = sort_rank;
		}
	}
	SortDeepArray(array_memebers, 1, .order = SORT_DESC);
	for (new i = 0, md_id, string_[64]; i < MAX_PLAYERS; i++) {
		if (!array_memebers[i][0]) continue;
		md_id = array_memebers[i][0];
		format(string_, sizeof string_, "%s[%d] rank: %d", pInfo[md_id][pName], md_id, pInfo[md_id][pRank]);
		SendClientMessage(md_id, -1, string_);
	}
	return 1;
}

CMD:pdd(playerid, params[])
{
	new
		t_stra[128];
	t_string[0] = EOS;
	strcat(t_string, ""colwhi"<< 1. Общие правила >>\n\nОбгон транспортного средства разрешен только с левой стороны,\n");
	strcat(t_string, ""colwhi"при этом водители обязаны убедиться, что встречная полоса свободна на достаточном для обгона расстояние.\n");
	strcat(t_string, ""colwhi"При ДТП водители обязаны позвонить в полицию, и дождаться ДПС\n\n<< 2. Скорость движения >> \n\n");
	strcat(t_string, ""colwhi"В пределах города разрешается движение транспортных средств со скоростью не более 50 км/ч.\n");
	strcat(t_string, ""colwhi"В жилых зонах и на дворовых территориях не более 30 км/ч\n\n<< 3. Остановка и стоянка >>\n\n");
	strcat(t_string, ""colwhi"Остановка и стоянка транспортных средств разрешаются на правой стороне дороги на обочине.\n");
	strcat(t_string, ""colwhi"В специальных отведённых для этого местах\n\n<< 4. ДПС >> \n\n");
    strcat(t_string, ""colwhi"При виде автомобиля с включённой сиреной, водитель обязан сбавить скорость и прижаться к обочине.\n");
    strcat(t_string, ""colwhi"Водитель обязан предъявить паспорт/лицензии, если тот попросил\n");
	ShowPlayerDialog(playerid, D_NULL,DIALOG_STYLE_MSGBOX, "Правила дорожного движения", t_string, "Готово", "");
	format(t_stra, sizeof(t_stra), "%s читает Правила Дорожного Движения.", pInfo[playerid][pName]);
	SendBeside(playerid,COLOR_PURPLE,t_stra,30.0);
	return 1;
} 
CMD:exit(playerid, params[])
{
	if (pTemp[playerid][tSelectHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть в доме!");

	new	
		H_IDX = pTemp[playerid][tSelectHouseID],
		idx = HouseInfo[H_IDX][hIntID]; 
	if (!IsPlayerInRangeOfPoint(playerid, 3, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2])) return true;
	if (GetPlayerVirtualWorld(playerid) == H_IDX+50) {
		SetPlayerPosAC(playerid, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2], 0, 0);
	} 

	return 1;
}
CMD:directory(playerid, params[])
{
    if (pInfo[playerid][pDirectory] == 0) return SendClientMessage(playerid, COLOR_GRAD1, !"У вас нет телефонной книги");
	ShowPlayerDialog(playerid,D_DIRECTORY_LIST_0,DIALOG_STYLE_LIST, "Телефонная книга", " Таксисты\n Механики\n Прорабы\n Медики\n Лидеры\n Адвокаты\n Развозчики продуктов\n Тренеры\n"colserver" - Мои контакты", "Просмотр", "Отмена");
	return 1;
}
alias:directory("dir");
CMD:play(playerid) return ShowPlayerDialog(playerid, D_PLAYER_RADIO, DIALOG_STYLE_LIST, ""colserver"Выберите радиостанцию", "\
		[0] Missouri FM\n\
		[1] Radio Record\n\
		[2] TRAP.FM\n\
		[3] Europa Plus\n\
		[4] Retro FM\n\
		[5] Jazz FM\n\
		[6] Pop FM\n\
		[7] Rap FM\n\
		[8] Rock FM\n\
		[9] Country FM\n\
		"colserver" - Выключить радио", 
		"Выбор", "Закрыть"
	);
alias:play("fm");
CMD:stats(playerid, params[]) return ShowStats(playerid, playerid);
CMD:help(playerid) return SendClientMessage(playerid, COLOR_WHITE, !"Используйте: /mm");
CMD:mainmenu(playerid, params[])
{
	ShowPlayerDialog(playerid, D_MAINMENU_FUNC_0, DIALOG_STYLE_LIST, ""colserver"Личное меню", "[0] Настройки\n\
		[1] Статистика персонажа\n\
		[2] Команды сервера\n{FFFF00}[3] Задать вопрос / Отправить жалобу\n\
		{FFFFFF}[4] Правила сервера\n[5] Сервисы\n[6] Квесты\n[7] Донат\n[8] Промокод\n[9] Бонусный код", "Выбрать", "Отмена");
	return 1;
}
alias:mainmenu("mm", "mn", "menu");


CMD:spawnchange(playerid)
{
	format(t_string, sizeof t_string,
		"[0] Стандартный спавн\n[1] Дом/Квартира\n[2] Организация\n[3] В доме на колёсах\n[4] На Яхте\n[5] В Семейном особняке\n[6] В Семейном доме\n"colserver" - Текущий спавн: %s", GetPlayerSpawnName(playerid));
	return ShowPlayerDialog(playerid, D_PLAYER_SPAWNCHANGE, DIALOG_STYLE_LIST, ""colserver"Место респавна", t_string, "Выбрать", "Закрыть"), t_string[0] = EOS;
}
alias:spawnchange("setspawn");

CMD:sellkeys(playerid, params[])
{
    if (!IsACop(playerid) && !IsAGang(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда!");
	if (sscanf(params, "udd", params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_GRAD2, "Введите: /sellkeys [id] [кол-во] [Цена]");
	if (params[1] < 1 || params[1] > 5) return SendClientMessage(playerid, COLOR_GREY, !"Ключей не может быть меньше 1 и больше 5!");
	if (params[2] < 1 || params[2] > 50000) return SendClientMessage(playerid, COLOR_GREY, !"Цена не может быть меньше 1 и больше 50000 вирт!");
	if (params[1] > pInfo[params[0]][pFracIntKeys][FRACTION_LSPD - 1] >= 0) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько ключей!");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом");
	if (pInfo[params[0]][pFracIntKeys][FRACTION_LSPD - 1] >= 5)return SendClientMessage(playerid,COLOR_GREEN, "У игрока уже имеется 5 ключей!");
	new string_[128];
	format(string_, sizeof string_, "Вы предложили %s купить %d ключ(а/ей) за $%d",pInfo[params[0]][pName],params[1],params[2]);
	SendClientMessage(playerid, 0x6495EDFF, string_);
	format(string_, sizeof string_, "%s предлагает вам купить %d ключ(а/ей) за $%d. ((Введите: /accept keys для покупки ))",pInfo[playerid][pName],params[1],params[2]);
	SendClientMessage(params[0], 0x6495EDFF, string_);
	KeysOffer[params[0]] = playerid;
	KeysPrice[params[0]] = params[2];
	KeysGram[params[0]] = params[1];
	return 1;
}
CMD:tazerall(playerid, params[])
{
    if (pInfo[playerid][pMember] != 2 || pInfo[playerid][pMember] == 2 && pInfo[playerid][pRank] < 3) return 1;
	params[0] = GetClosestforeach(playerid);
	if (!IsPlayerInRangeOfPlayer(6.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Нет никого рядом");
	if (IsPlayerInAnyVehicle(playerid)) return  SendClientMessage(playerid, COLOR_GREY, !"Невозможно использовать в машине");
	new string_[64];
	format(string_, sizeof string_, "Агент FBI %s оглушил всех на 15 секунд",pInfo[playerid][pName]);
	SendBeside(playerid,COLOR_PURPLE,string_,30.0);
	//ProxDetector(30.0, playerid, string_, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	TogglePlayerControllable(params[0], 0);
	SetPlayerSpecialAction(params[0],SPECIAL_ACTION_HANDSUP);
	pTemp[params[0]][tPlayerCuffed] = 1;
	PlayerCuffedTime[params[0]] = 15;
	return 1;
}

CMD:ftazer(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
    if (pInfo[playerid][pMember] != 2 && pInfo[playerid][pLeader] != 2) return 1;
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid,COLOR_WHITE,!"Введите: /ftazer [1/2/3]");
	new str_[64];
	if (params[0] == 1)
	{
		format(str_, sizeof str_, "Агент FBI %s оглушил всех",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,20.0);
		foreach(new i: PlayerInLogin)
		{
			if (!pInfo[i][pLogin]) continue;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if (IsPlayerInRangeOfPoint(i,20,X,Y,Z) && i != playerid)
			{
				TogglePlayerControllable(i,0);
				SendClientMessage(i,-1,!"Вы заморожены на 10 секунд");
				SetPlayerSpecialAction(i,SPECIAL_ACTION_HANDSUP);
				SetTimerEx("UnFreeze", 10000, 0, "i", i);
			}
		}
	}
	else if (params[0] == 2)
	{
		format(str_, sizeof str_, "Агент FBI %s оглушил всех рядом стоящих законников",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,20.0);
		foreach(new i: PlayerInLogin)
		{
			if (!pInfo[i][pLogin]) continue;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if (IsPlayerInRangeOfPoint(i,20,X,Y,Z) && i != playerid)
			{
				if (pInfo[i][pMember] == 1 || pInfo[i][pMember] == 2 ||pInfo[i][pMember] == 3 || pInfo[i][pMember] == 19 ||pInfo[i][pMember] == 10 || pInfo[i][pMember] == 21)
				{
					TogglePlayerControllable(i,0);
					SendClientMessage(i,-1,!"Вы заморожены на 10 секунд");
					SetPlayerSpecialAction(i,SPECIAL_ACTION_HANDSUP);
					SetTimerEx("UnFreeze", 10000, 0, "i", i);
				}
			}
		}
	}
	else if (params[0] == 3)
	{
		format(str_, sizeof str_, "Агент FBI %s оглушил всех рядом стоящих жителей", pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,20.0);
		foreach(new i: PlayerInLogin)
		{
			if (!pInfo[i][pLogin]) continue;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if (IsPlayerInRangeOfPoint(i,20,X,Y,Z) && i != playerid)
			{
				TogglePlayerControllable(i, 0);
				SendClientMessage(i,-1,!"Вы заморожены на 10 секунд");
				SetPlayerSpecialAction(i,SPECIAL_ACTION_HANDSUP);
				SetTimerEx("UnFreeze", 10000, 0, "i", i);
			}
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, !"Неверное число");
	return 1;
}//7-9 (19:00)13 Эндокринолог ()19
CMD:tazer(playerid, params[])
{
    if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	//if ()
	if (NewTazer[playerid] == false)
 	{
		NewTazer[playerid] = true;
		SendClientMessage(playerid,COLOR_BLUE,!"Вы поменяли пули на резиновые");
		// SendClientMessage(playerid,COLOR_BLUE,!"Для быстрой смены пуль, зажмите клавижу ПРОБЕЛ");
	}
	else
	{
		NewTazer[playerid] = false;
		SendClientMessage(playerid,COLOR_BLUE,!"Вы поменяли пули на обычные");
		// SendClientMessage(playerid,COLOR_BLUE,!"Для быстрой смены пуль, зажмите клавижу ПРОБЕЛ");
	}
	return 1;
}
CMD:mtazer(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
    new string_[128];
    if (IsACop(playerid) || pInfo[playerid][pMember] == 7 && pInfo[playerid][pRank] >= 3)
	{
		if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Невозможно использовать в машине!");
		new suspect_ = GetClosestforeach(playerid);
		if (suspect_ < 0) return SendClientMessage(playerid, COLOR_GREY, !"Рядом с вами никого нет");
		if (pTemp[suspect_][tPlayerCuffed] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже в обездвижин");
		if (GetDistanceBetweenPlayers(playerid,suspect_) < 5)
		{
			if (IsACop(suspect_)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете ударить тазером законника");
			if (IsPlayerInAnyVehicle(suspect_)) return SendClientMessage(playerid, COLOR_GREY, !"Человек в машине");

			format(string_, sizeof(string_), "Вас обездвижил электрошокером %s на 15 секунд",pInfo[playerid][pName]);
			SendClientMessage(suspect_, 0x6495EDFF, string_);

			format(string_, sizeof(string_), "Вы обездвижили электрошокером %s на 15 секунд",pInfo[suspect_][pName]);
			SendClientMessage(playerid, 0x6495EDFF, string_);

			format(string_, sizeof(string_), "%s проводит задержание %s", pInfo[playerid][pName] ,pInfo[suspect_][pName]);
			SendBeside(playerid,COLOR_PURPLE,string_,20.0);

			TogglePlayerControllable(suspect_, 0);
			SetPlayerSpecialAction(suspect_,SPECIAL_ACTION_HANDSUP);
			pTemp[suspect_][tPlayerCuffed] = 1;
			PlayerCuffedTime[suspect_] = 15;
		}
		else SendClientMessage(playerid, COLOR_GREY, !"Рядом с тобой никого нет");
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вам не доступна данная команда");
	return 1;
}
CMD:itazer(playerid, params[])
{
    if (!IsALicenser(playerid) || pTemp[playerid][tDutyWork] == 0) return 1;
	if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Невозможно использовать в машине");
	new suspect_ = GetClosestforeach(playerid);
	if (pTemp[suspect_][tPlayerCuffed] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже в наручниках!");
	if (GetDistanceBetweenPlayers(playerid,suspect_) < 5)
	{
		if (IsACop(suspect_)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете ударить тазером законника");
		if (IsPlayerInAnyVehicle(suspect_)) return SendClientMessage(playerid, COLOR_GREY, !"Человек в машине!");
		new string_[128];
		SendMes(suspect_, 0x6495EDFF,"Вас обездвижил электрошокером %s на 15 секунд",pInfo[playerid][pName]);
		SendMes(playerid, 0x6495EDFF,"Вы обездвижили электрошокером %s на 15 секунд",pInfo[suspect_][pName]);
		format(string_, sizeof(string_), "Инструктор %s обезвредил %s", pInfo[playerid][pName] ,pInfo[suspect_][pName]);
		SendBeside(playerid,COLOR_PURPLE,string_,30.0);
		TogglePlayerControllable(suspect_, 0);
		SetPlayerSpecialAction(suspect_,SPECIAL_ACTION_HANDSUP);
		pTemp[suspect_][tPlayerCuffed] = 1;
		PlayerCuffedTime[suspect_] = 15;
	}
	return 1;
}

CMD:patrul(playerid,params[])
{
	if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
	if (GetPlayerState(playerid) != 2) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в автомобиле.");
	new V_IDX = GetPlayerVehicleID(playerid), string_[128];
	if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
		(VehicleInfo[ V_IDX - 1 ][vFraction] == 1 || VehicleInfo[ V_IDX - 1 ][vFraction] == 10 || VehicleInfo[ V_IDX - 1 ][vFraction] == 21
		|| VehicleInfo[ V_IDX - 1 ][vFraction] == 2 ))
	{
		foreach(new i: PlayerInLogin)
	 	{
			if (!pInfo[i][pLogin]) continue;
	  		if (!IsPlayerInRangeOfPlayer(600.0, playerid, i) || !pInfo[i][pWantedLevel]) continue;
	  		IsFind[playerid] = i;
	    	format(string_, sizeof string_, "[Внимание]{FFFFFF} Преступник %s[%d] найден, начинайте погоню!", pInfo[i][pName], i);
		    SendClientMessage(playerid, COLOR_RED, string_);
		   	foreach(new z: PlayerInLogin)
			{
				if (GetPlayerVehicleID(z) == GetPlayerVehicleID(playerid) && z != playerid && IsACop(z)) {
					IsFind[z] = i;
					format(string_, sizeof string_, "[Внимание]{FFFFFF} Преступник %s[%d] найден, начинайте погоню!", pInfo[i][pName], i);
			    	SendClientMessage(z, COLOR_RED, string_);
				}
			}
	  		return 1;
	    }
    	return SendClientMessage(playerid, COLOR_GREY, !"Рядом с вами нет преступников."), 1;
    }
	else return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в полицейской машине");
}


CMD:break(playerid, params[])
{
	if (pTemp[playerid][tDutyWork] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Сначало надо начать рабочий день");
	if (pInfo[playerid][pMember] == 1 || pInfo[playerid][pMember] == 2 || pInfo[playerid][pMember] == 10 || pInfo[playerid][pMember] == 21)
	{
		if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете использовать это в машине.");
		if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы находитесь в интерьере");
		if (pTemp[playerid][PlayerUseBreak] == true)
		{
			if (pTemp[playerid][pSpikeArea]) {
				new areaid = pTemp[playerid][pSpikeArea] - 1;
				SetDynamicAreaType(areaid, AREA_TYPE_NONE);
				DestroyDynamicArea(areaid);
		
				if (pTemp[playerid][pSpikeText]) {
					DestroyDynamic3DTextLabel(pTemp[playerid][pSpikeText]);
					pTemp[playerid][pSpikeText] = Text3D:0;
				}
				pTemp[playerid][pSpikeArea] = 0;
			}
			DestroyDynamicObject(object[playerid]);
			pTemp[playerid][PlayerUseBreak] = false;
			if (pTemp[playerid][tBlockText]) {
				DestroyDynamic3DTextLabel(pTemp[playerid][tBlockText]);
				pTemp[playerid][tBlockText] = Text3D:0;
			}
			scm(playerid,0x66CC00ff,"Вы убрали ограждение");
			return 1;
		}
		if (sscanf(params,"d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /break [тип (1-6)] (6 - шипы)");
		if (params[0] < 1 || params[0] > 6) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /break [тип (1-6)] (6 - шипы)");
		new Float:x, Float:y, Float:z, Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		x += floatsin(-angle, degrees);
		y += floatcos(-angle, degrees);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
		if (pTemp[playerid][PlayerUseBreak] == false)
		{
			switch(params[0])
			{
			case 1: object[playerid] = CreateDynamicObject(1228, x, y, z-0.5, 0, 0, 0);
			case 2: object[playerid] = CreateDynamicObject(1237, x, y, z-1.0, 0, 0, 0);
			case 3: object[playerid] = CreateDynamicObject(1423, x, y, z-0.3, 0, 0, 0);
			case 4: object[playerid] = CreateDynamicObject(1422, x, y, z-0.49, 0, 0, 0);
			case 5: object[playerid] = CreateDynamicObject(981, x+2, y,z-0.2,0.00,0.00,angle+180);
			case 6: {
					object[playerid] = CreateDynamicObject(2899, 
						x + floatcos(angle + 90, degrees), y + floatsin(angle + 90, degrees),z - 0.82, 0.00, 0.00, angle+ 90
					);
					SetDynamicObjectMaterial(object[playerid], 0, 7520, "vgnretail72", "solairtyre64", 0x00000000);
					pTemp[playerid][pSpikeArea] = 1 + CreateDynamicSphere(x, y, z, 3.0, .worldid = 0, .interiorid = 0);

					format(t_string, sizeof (t_string), ""colserver"Шипы\n"colwhi"Установил: "colserver"%s [%i]",
						pInfo[playerid][pName], playerid
					);
					new areaid = pTemp[playerid][pSpikeArea] - 1;
					SetDynamicAreaType(areaid, AREA_TYPE_SPIKE_STRIPS);

					if (pTemp[playerid][pSpikeText]) {
						DestroyDynamic3DTextLabel(pTemp[playerid][pSpikeText]);
						pTemp[playerid][pSpikeText] = Text3D:0;
					}
					pTemp[playerid][pSpikeText] = CreateDynamic3DTextLabel(
						t_string, COLOR_GREY, x + floatcos(angle + 90, degrees), y + floatsin(angle + 90, degrees), z + 0.20, 
						1.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID,0, .worldid = 0, .interiorid = 0
					);
					t_string[0] = EOS;
				}
				
			}
			new string_[64];
			format(string_, sizeof string_, "%d(%s)", playerid, gFraction[pInfo[playerid][pMember]][fName]);
			if (IsValidDynamic3DTextLabel(pTemp[playerid][tBlockText])) {
				DestroyDynamic3DTextLabel(pTemp[playerid][tBlockText]);
				pTemp[playerid][tBlockText] = Text3D:0;
			}
			pTemp[playerid][tBlockText] = CreateDynamic3DTextLabel(string_, 0xd8a903FF, x, y, z - 0.7, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
			Streamer_Update(playerid); //Для того чтобы сразу появилось
			pTemp[playerid][PlayerUseBreak] = true;
			scm(playerid, COLOR_WHITE, !"Вы установили ограждение. Введите '/break' ещё раз, чтобы убрать его");
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Эта функция только для Полиции/ФБР");
	return 1;
}
CMD:deject(playerid,params[])
{
	if (pTemp[playerid][tDutyWork] == 1 && (pInfo[playerid][pMember] == 1 ||pInfo[playerid][pMember] == 2 ||pInfo[playerid][pMember] == 10 ||pInfo[playerid][pMember] == 21))
	{ 
		if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /deject [id]");
		if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!"); 
		if (!IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок не в транспорте");
		if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "Игрок далеко от вас"); 
		new
			string_[128];
		format(string_, sizeof string_, "Вы выкинули из машины %s", pInfo[params[0]][pName]);
		SendClientMessage(playerid, 0x6495EDFF, string_);
		format(string_, sizeof string_, "Вас выкинул из машины %s",pInfo[playerid][pName]);
		SendClientMessage(params[0], 0x6495EDFF, string_);
		RemovePlayerFromVehicle(params[0]);
		format(string_, sizeof string_, "выкинул из автомобиля %s", pInfo[params[0]][pName]);
		MeAction(playerid, string_, SELECT_ACTION_IN_CHAT, 15.0);
	}
	return 1;
}
CMD:cuff(playerid, params[])
{
	if (pTemp[playerid][tDutyWork] == 1 && (pInfo[playerid][pMember] == 1 ||pInfo[playerid][pMember] == 2 ||pInfo[playerid][pMember] == 10 ||pInfo[playerid][pMember] == 21))
	{
		if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /cuff [id]");
        if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
		if (IsACop(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете надеть наручники на законника");
		if (pInfo[params[0]][pWantedLevel] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не находится в розыске");
		if (pTemp[params[0]][tPlayerCuffed] == 2) return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже в наручниках");
		if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return 1;
		SendMes(params[0], 0x6495EDFF,"%s надел вам наручники",pInfo[playerid][pName]);
		GameTextForPlayer(params[0], "~r~cuffed", 5000, 3);
		SendMes(playerid, 0x6495EDFF,"Вы надели наручники на %s", pInfo[params[0]][pName]); 
		MeAction(playerid, "резким движением рук снял наручники с пояса после чего надел их на преступника", SELECT_ACTION_GENERAL);
		MeAction(playerid, "надел наручники", SELECT_ACTION_IN_CHAT);
		SetPlayerAttachedObject(params[0], 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
		SetPlayerSpecialAction(params[0], SPECIAL_ACTION_CUFFED); 
		
		TogglePlayerControllable(params[0], 0);
		pTemp[params[0]][tPlayerCuffed] = 2;
		PlayerCuffedTime[params[0]] = 3600;
		if (pInfo[playerid][pMember] == 2)
		{ 
			if (IsPlayerToGhetto(playerid) && GetPlayerVirtualWorld(playerid) == 0)
			{
				OnPlayerQuestProgress(playerid,QUEST_FBI,QUEST_TASK_FBI_ARREST); 
				if (pTemp[playerid][FBISpyAction] != -1 && IsAGang(params[0]) && pInfo[params[0]][pRank] > 6)
				{
					OnPlayerQuestProgress(playerid,QUEST_FBI, QUEST_TASK_FBI_ARREST_GHETTO);
				}
			}
		}
	}
	return 1;
}
CMD:uncuff(playerid, params[])
{	if(IsACop(playerid) && pTemp[playerid][tDutyWork] || pInfo[playerid][pAdmin] >= 2 && pTemp[playerid][PlayerADostup])
	//if (pTemp[playerid][tDutyWork] == 1 && (pInfo[playerid][pMember] == 1 ||pInfo[playerid][pMember] == 2 || pInfo[playerid][pMember] == 10 ||pInfo[playerid][pMember] == 21))
	{
		if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /uncuff [id]");
        if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
		if (IsACop(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете снять наручники с законника");
		if (pTemp[params[0]][tPlayerCuffed] != 2) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в наручниках");
		if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return 1;
		GameTextForPlayer(params[0],"~g~uncuffed", 5000, 3);
		SendMes(playerid, 0x6495EDFF,"Вы сняли наручники с %s", pInfo[params[0]][pName]);
		TogglePlayerControllable(params[0], 1);
		SetPlayerSpecialAction(params[0],SPECIAL_ACTION_NONE);
		if (IsPlayerAttachedObjectSlotUsed(params[0], 0)) RemovePlayerAttachedObject(params[0], 0);
		if(gFollowInfo[playerid][gtID] == params[0]) {
			CheckPlayerGoCuff(params[0]);
			CheckPlayerGoCuff(playerid);
		}
		pTemp[params[0]][tPlayerCuffed] = 0;
		PlayerCuffedTime[params[0]] = 0; 
	}
	return 1;
}
CMD:breathalyser(playerid, params[])
{
	if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать.");
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/br)eathalyser [ид]");
    if (!PlayerInConnected(params[0])) return 1; // В одну строчку
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Необходимо находиться рядом друг с другом");
	new bh[64], patrol[144];
	if (GetPlayerDrunkLevel(params[0]) > 0) format(bh, sizeof(bh), "%s пьяный", pInfo[params[0]][pName]);
	else format(bh, sizeof(bh), "%s трезвый", pInfo[params[0]][pName]);
	SendClientMessage(playerid, 0x6ab1ffaa, bh), SendClientMessage(params[0], 0x6ab1ffaa, bh);
	format(patrol, sizeof(patrol), "Патрульный %s протянул(а) %s алкометр для проверки", pInfo[playerid][pName], pInfo[params[0]][pName]);

	SendBeside(playerid,COLOR_PURPLE,patrol,30.0);
	return 1;
}
CMD:follow(playerid, params[]) {
	if(!IsACop(playerid) || !pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете это использовать."); 
	if (sscanf(params, "u", params[0])) return scm(playerid,COLOR_WHITE, !"Введите: /follow [playerid]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (GetDistanceBetweenPlayers(playerid,params[0]) > 3.0) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок далеко от вас."); 
	if (pTemp[params[0]][tPlayerCuffed] && gFollowInfo[playerid][gtID] == params[0])
	{
		TogglePlayerControllable(params[0], 0);
	    format(t_string,sizeof t_string, "%s отцепил(а) наручники %s от себя",pInfo[playerid][pName],pInfo[params[0]][pName]);
	    SendBeside(playerid,COLOR_PURPLE,t_string,30.0);
		CheckPlayerGoCuff(params[0]);
		CheckPlayerGoCuff(playerid);
		return 1;
	}  
	if (gFollowInfo[playerid][gtID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже кого-то ведете за собой");
	if (gFollowInfo[params[0]][gtGoID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Этого игрока уже кто-то ведет за собой");
	if (pTemp[params[0]][tPlayerCuffed] != 2) return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен быть в наручниках.");
	CheckPlayerGoCuff(playerid);
	CheckPlayerGoCuff(params[0]);
	gFollowInfo[playerid][gtID] = params[0];
	gFollowInfo[params[0]][gtGoID] = playerid;
	gFollowInfo[params[0]][gtState] = GetPlayerState(playerid);
	GetPlayerPos(params[0], gFollowInfo[params[0]][gtX], gFollowInfo[params[0]][gtY], gFollowInfo[params[0]][gtZ]);
	SendClientMessage(playerid, COLOR_WHITE, !"Вы прицепили наручниками к себе приступника");
	format(t_string, sizeof t_string, "%s прицепил(а) наручниками к себе %s",pInfo[playerid][pName],pInfo[params[0]][pName]);
	SendBeside(playerid,COLOR_PURPLE,t_string,30.0);
	TogglePlayerControllable(params[0], true);
	return true;
}
CMD:cput(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pTemp[playerid][tDutyWork] == 0) return 1;
    if (pInfo[playerid][pRank] >= 1 && (pInfo[playerid][pMember] == 1 || pInfo[playerid][pMember] == 2 || pInfo[playerid][pMember] == 10 ||pInfo[playerid][pMember] == 21))
	{
	    new V_IDX = GetPlayerVehicleID(playerid);
		if (V_IDX < 1) return  SendClientMessage(playerid, COLOR_GREY, !"Вы должны находится в транспорте!");
 		if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
			(VehicleInfo[ V_IDX - 1 ][vFraction] == 1 || VehicleInfo[ V_IDX - 1 ][vFraction] == 10 || VehicleInfo[ V_IDX - 1 ][vFraction] == 21
			|| VehicleInfo[ V_IDX - 1 ][vFraction] == 2 ))
		{
			if (sscanf(params, "u",params[0])) return  SendClientMessage(playerid, COLOR_WHITE, !"Введите: /cput [playerid]");
	        if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
			if (!IsPlayerInRangeOfPlayer(5.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GRAD1, !"Человек далеко от вас");
			if (!pInfo[params[0]][pWantedLevel]) return SendClientMessage(playerid, COLOR_GRAD1, !"Человек не является преступником");
			if (GetPlayerState(params[0]) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GRAD1, !"Человек в автомобиле");
			new seat = GetFreeSeat(V_IDX);
			if (seat == -1) return SendClientMessage(playerid, COLOR_GREY, !"В машине нет свободных мест"); 
			if(pTemp[params[0]][tPlayerCuffed] && gFollowInfo[playerid][gtID] == params[0]) {  
				CheckPlayerGoCuff(params[0]);
				CheckPlayerGoCuff(params[0]);
				//return 1;
			} 
			SetPlayerArmedWeapon(params[0],0);
			SendMes(params[0],0x64E96EDFF, "Вы были затащены в машину офицером / агентом FBI %s",pInfo[playerid][pName]);
			SendMes(playerid,0x64E96EDFF, "Вы затащили в машину преступника %s",pInfo[params[0]][pName]);
			PutPlayerInVehicle(params[0], V_IDX, seat);
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в патрульной машине");
	}
	return 1;
}

CMD:ceject(playerid, params[])
{
    if (pTemp[playerid][tDutyWork] == 1 && (pInfo[playerid][pMember] == 1 ||pInfo[playerid][pMember] == 2 ||pInfo[playerid][pMember] == 10 ||pInfo[playerid][pMember] == 21))
	{
	    new string_[128];
		new V_IDX = GetPlayerVehicleID(playerid);
 		if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
			(VehicleInfo[ V_IDX - 1 ][vFraction] == 1 || VehicleInfo[ V_IDX - 1 ][vFraction] == 10 || VehicleInfo[ V_IDX - 1 ][vFraction] == 21
			|| VehicleInfo[ V_IDX - 1 ][vFraction] == 2 ))
		{
			if (sscanf(params, "u",params[0])) return  SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ceject [playerid]");
	        if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
			if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(params[0])) return SendClientMessage(playerid, COLOR_GRAD1, !"Человек не в вашей машине");
			RemovePlayerFromVehicle(params[0]);
			if(pTemp[params[0]][tPlayerCuffed] && gFollowInfo[playerid][gtID] == params[0]) { 
				TogglePlayerControllable(params[0], 0);
				CheckPlayerGoCuff(params[0]);
				CheckPlayerGoCuff(params[0]);
				//return 1;
			}
			if (IsPlayerInRangeOfPoint(params[0],5.0,1568.6144,-1689.9901,6.2188))
			{
				SetPlayerInterior(params[0],6);
				SetPlayerPosAC(params[0],2746.5713,1398.0675,1100.9045, 1,6 );
				SetPlayerFacingAngle(params[0], 100.7670);
				SendMes(params[0],0x64E96EDFF, "Вы были высажены с машины офицером %s в участок Лос Сантоса",pInfo[playerid][pName]);
				SendMes(playerid,0x64E96EDFF, "Вы высадили подозреваемого %s в полицейский участок Лос Сантоса",pInfo[params[0]][pName]);
				format(string_, sizeof string_, "Затолкал(а) подозреваемого %s в полицейский участок",pInfo[params[0]][pName]);
				SetPlayerChatBubble(playerid, string_,COLOR_PURPLE,30.0,10000); 
			}
			else if (IsPlayerInRangeOfPoint(params[0],5.0,-1594.2096,716.1803,-4.9063))
			{
				SetPlayerInterior(params[0],10);
				SetPlayerPosAC(params[0],220.1259,114.6476,999.0156);
				SetPlayerFacingAngle(params[0], 95.3400);
				SendMes(params[0],0x64E96EDFF,"Вы были высажены с машины офицером %s в участок Сан Фиеро",pInfo[playerid][pName]);
				SendMes(playerid,0x64E96EDFF,"Вы высадили подозреваемого %s в полицейский участок Сан Фиерро",pInfo[params[0]][pName]);
				format(string_, sizeof string_, "Затолкал(а) подозреваемого %s в полицейский участок",pInfo[params[0]][pName]);
				SetPlayerChatBubble(playerid, string_,COLOR_PURPLE,30.0,10000); 
			}
			else if (IsPlayerInRangeOfPoint(params[0],5.0,2297.1138,2451.4346,10.8203))
			{
				SetPlayerInterior(params[0],3);
				SetPlayerVirtualWorld(params[0], 122);
				SetPlayerPosAC(params[0],198.1339,158.4835,1003.0234);
				SetPlayerFacingAngle(params[0], 354.8164);
				SendMes(params[0],0x64E96EDFF,"Вы были высажены с машины офицером %s в участок Лас Вентурас",pInfo[playerid][pName]);
				SendMes(playerid,0x64E96EDFF,"Вы высадили подозреваемого %s в полицейский участок Лас Вентурас",pInfo[params[0]][pName]);
				format(string_, sizeof string_, "Затолкал(а) подозреваемого %s в полицейский участок",pInfo[params[0]][pName]);
				SetPlayerChatBubble(playerid, string_,COLOR_PURPLE,30.0,10000); 
			}
			else
			{
				SendMes(params[0],0x64E96EDFF, "Вы были высажены с машины офицером/агентом ФБР %s",pInfo[playerid][pName]);
				SendMes(playerid,0x64E96EDFF, "Вы вытащили с машины подозреваемого %s",pInfo[params[0]][pName]);
				format(string_, sizeof string_, "Вытащил(а) из машины подозреваемого %s",pInfo[params[0]][pName]);
				SetPlayerChatBubble(playerid, string_,COLOR_PURPLE,30.0,10000); 
			}
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вы не в патрульной машине");
	}
	return 1;
}
CMD:find(playerid, params[])
{
	
    if (GetPVarInt(playerid,"farm_status") == 1) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент нельзя использовать GPS!");

    if (pInfo[playerid][pMember] != 2) return SendClientMessage(playerid, COLOR_GREY, !"Вы не агент FBI");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /find [id]");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!CallInfo[params[0]][callused] && pTemp[params[0]][PlayerPhoneOnline]) return SendClientMessage(playerid, COLOR_GREY, !"Не удается соедениться!");
	if (pInfo[params[0]][pWantedLevel] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Этот человек не в розыске!");
	{
		GetPlayerPos(params[0], CallInfo[ params[0] ][callx], CallInfo[ params[0] ][cally], CallInfo[ params[0] ][callz]);
		SetPlayerCheckpoint(playerid, CallInfo[ params[0] ][callx], CallInfo[ params[0] ][cally], CallInfo[ params[0] ][callz], 6);
		CP[playerid] = 777;
	}
	return 1;
}

CMD:tipster(playerid, params[])
{
	new param[40],
		string_[128];
    if (pInfo[playerid][pMember] != FRACTION_FBI) return SendClientMessage(playerid, COLOR_GREY, !"Вы не агент FBI");
	if (sscanf(params, "s[32]S()[64]", param, params))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /tipster [действие]. Доступные действия:");
		SendClientMessage(playerid, COLOR_WHITE, !"  GET - Взять жучёк.");
		SendClientMessage(playerid, COLOR_WHITE, !"  SET - Прикрепить жучёк к игроку");
		SendClientMessage(playerid, COLOR_WHITE, !"  REMOVE - Деактивировать жучёк");
		SendClientMessage(playerid, COLOR_WHITE, !"  LISTEN - Начать прослушивание чата фракции");
		return 1;
	}
	if (!strcmp(param, "get",true))
	{
	    new V_IDX = GetPlayerVehicleID(playerid);
 		if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_FBI))
		{
		    if (pInfo[playerid][pRank] < 6) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Вам недоступна данная функция!");
		    if (tipster[playerid]) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"У вас уже есть жучёк");
		    tipster[playerid] = 1;
		    format(string_, sizeof string_,"%s взял(а) жучёк",pInfo[playerid][pName]);
		    SendRadioMessage(FRACTION_FBI, 0x00b953ff, string_);
	    }
	    else return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в автомобиле FBI");
	}
	else if (!strcmp(param, "set",true))
	{
	    new ammo;
	    if (pInfo[playerid][pRank] < 6) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Вам недоступна данная функция!");
	    if (sscanf(params, "u", ammo)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /tipster SET [playerid]");
	    if (!tipster[playerid]) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"У вас нет жучка");
	    if (!IsPlayerInRangeOfPlayer(2.0, playerid, ammo)) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Игрок далеко от вас");
	    if (tipsteron != -1) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Жучёк уже прикреплен! Используйте /tipster REMOVE");
	    if (!pInfo[ammo][pMember]) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Игрок не состоит в организации");
	    tipster[playerid] = 0;
	    tipsteron = pInfo[ammo][pMember];
	    tipsterplayer = ammo;
		format(string_,sizeof string_,"%s установил(а) жучёк на %s. Чтобы подключиться к волне, введите /tipster listen",pInfo[playerid][pName],pInfo[ammo][pName]);
	    SendRadioMessage(FRACTION_FBI, 0x00b953ff, string_);
		if (
			IsAGosFraction(ammo) && pInfo[ammo][pMember] != pInfo[playerid][pMember]
		){
			OnPlayerQuestProgress(playerid,QUEST_FBI,QUEST_TASK_FBI_TIPSTER);
		}
	}
	else if (!strcmp(param, "remove",true))
	{
	    if (pInfo[playerid][pRank] < 6) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Вам недоступна данная функция!");
	    if (tipsteron == -1) return SendClientMessage(playerid,COLOR_ISPOLZUY, !"Жучёк не прикреплен!");
	    tipsteron = -1;
	    tipsterplayer = -1;
	    SendClientMessage(playerid, 0x00b953ff, !"Вы отключили жучёк!");
	}
	else if (!strcmp(param, "listen",true))
	{
	    if (tipsteron == -1) return SendClientMessage(playerid,0x00b953ff, !"Жучёк не прикреплен!");
	    if (!tipsterlisten[playerid])
	    {
	        tipsterlisten[playerid] = 1;
	        SendClientMessage(playerid, 0x00b953ff, !"Вы включили прослушивание!");
		}
		else
		{
		    tipsterlisten[playerid] = 0;
	        SendClientMessage(playerid, 0x00b953ff, !"Вы отключили прослушивание!");
		}
	}
	return 1;
}
CMD:cancel(playerid, params[])
{//ACTION_FACTORY_SORT
	if (pTemp[playerid][tJobFactory] && pTemp[playerid][tActionType] == ACTION_FACTORY_SORT) {
		//SetActionGameProgressBar(playerid, pTemp[playerid][tActionStep], false);  
		ActionMiniGamePlayer(playerid, false);
		new	 
			area_id = pTemp[playerid][tUseFactorySordID];
		if (area_id != -1) {
			if (gFactorySortInfo[area_id][sortPlaceToggle] != INVALID_PLAYER_ID) { 
				if(PlayerInConnected(gFactorySortInfo[area_id][sortPlaceToggle])) {
					pTemp[playerid][tUseFactorySordID] = -1;  
				}
				gFactorySortInfo[area_id][sortPlaceToggle] = INVALID_PLAYER_ID; 
			} 
		} 
		return 1;
	}
 	ShowPlayerDialog(playerid, D_CANCEL_COMMAND, DIALOG_STYLE_LIST, "Отмена","[1] Вызов такси", "Выбор", "Закрыть");
 	return 1;
}

CMD:accept(playerid, params[])
{
	new string_[300];
	if (strlen(params[0]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[32]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /(ac)cept [значение]");
	
	else if (strcmp(params[0], "contract",true) == 0)
	{
		if (JobOffer[playerid] == 999) return SendClientMessage(playerid, COLOR_WHITE, !"Никто не предлагал тебе контракт.");
		if (Employer[playerid] != 999) return SendClientMessage(playerid, COLOR_WHITE, !"Ты уже заключал контракт.");
		if (!Prorab[JobOffer[playerid]]) return SendClientMessage(playerid,COLOR_WHITE, "Прораб уже неработает.");
		if (!IsPlayerInRangeOfPoint(playerid,5.0,2127.5701,-2275.1938,20.6719)) SendClientMessage(playerid,COLOR_WHITE, "Игрок не возле тебя.");
		if (!IsPlayerConnected(JobOffer[playerid])) return SendClientMessage(playerid,COLOR_WHITE, "Этот игрок не в сети.");
		if (!IsPlayerInRangeOfPlayer(5.0, playerid, JobOffer[playerid])) return SendClientMessage(playerid,COLOR_WHITE, "Игрок не возле тебя.");
		Employer[playerid] = JobOffer[playerid];
		JobOffer[playerid] = 0;
		f(string_, "Ты заключил контакт с %s.", pInfo[JobOffer[playerid]][pName]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string_);
		f(string_, "Прораб %s заключил с тобой контракт.", pInfo[playerid][pName]);
		SendClientMessage(Employer[playerid], COLOR_LIGHTBLUE, string_);
		SendClientMessage(Employer[playerid], COLOR_WHITE, "/gpayday - выдать зарплату.");
	}
	else if (strcmp(params[0], "medic",true) == 0)
	{
		if (pInfo[playerid][pMember] == 4 || pInfo[playerid][pMember] == 22 || pInfo[playerid][pMember] == 23)
		{
			if (MedicCallTime[playerid] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже приняли вызов!");
			if (MedicCall < 999)
			{
				if (IsPlayerConnected(MedicCall))
				{
					f(string_, "Вы приняли запрос от %s.",pInfo[MedicCall][pName]);
					SendClientMessage(playerid, 0x6495EDFF, string_);
					f(string_, "Доктор %s принял ваш вызов!",pInfo[playerid][pName]);
					SendClientMessage(MedicCall, COLOR_GREEN, string_);
					new Float:X,Float:Y,Float:Z;
					GetPlayerPos(MedicCall, X, Y, Z);
					SetPlayerCheckpoint(playerid, X, Y, Z, 5);
					CP[playerid] = 777;
					MedicCall = 999;
					return 1;
				}
			}
			else return SendClientMessage(playerid, COLOR_GREY, !"Вызовов нет!");
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вы не медик!");
	}
	else if (strcmp(params[0], "police",true) == 0)
	{
		if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
		if (PoliceCallTime[playerid] > 0) return  SendClientMessage(playerid, COLOR_GREY, !"Вы уже приняли вызов!");
		if (PoliceCall != INVALID_PLAYER_ID)
		{
			if (IsPlayerConnected(PoliceCall))
			{
				f(string_, "Вы приняли вызов от %s",pInfo[PoliceCall][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				f(string_, "Патрульный %s принял Ваш вызов!",pInfo[playerid][pName]);
				SendClientMessage(PoliceCall, COLOR_GREEN, string_);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(PoliceCall, X, Y, Z);
				SetPlayerCheckpoint(playerid, X, Y, Z, 5);
				CP[playerid] = 777;
				PoliceCall = INVALID_PLAYER_ID;
				return 1;
			}
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вызовов нет!");
	}
	else if (strcmp(params[0], "mechanic",true) == 0)
	{
		if (pInfo[playerid][pJob] != PLAYER_JOB_MECHANIC) return SendClientMessage(playerid, COLOR_GREY, !"Вы не механик!");
		if (MechanicCallTime[playerid] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже приняли вызов!");
		if (MechanicCall < 999)
		{
			if (IsPlayerConnected(MechanicCall))
			{
				f(string_, "Вы приняли вызов от %s",pInfo[MechanicCall][pName]);
				SendClientMessage(playerid, 0x6495EDFF, string_);
				f(string_, "Механик %s принял Ваш вызов!",pInfo[playerid][pName]);
				SendClientMessage(MechanicCall, COLOR_GREEN, string_);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(MechanicCall, X, Y, Z);
				SetPlayerCheckpoint(playerid, X, Y, Z, 5);
				CP[playerid] = 777;
				MechanicCall = 999;
				return 1;
			}
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вызовов нет!");
	}
	else if (strcmp(params[0],"livels",true) == 0)
	{
		if (LiveOfferls[playerid] < 999)
		{
			if (IsPlayerConnected(LiveOfferls[playerid]))
			{
				if (IsPlayerInRangeOfPlayer(5.0, playerid, LiveOfferls[playerid]))
				{
					TalkingLivels[LiveOfferls[playerid]] = 2;
					SendClientMessage(LiveOfferls[playerid], COLOR_WHITE, "Введите: /live чтобы закончить интервью");
					lNews[playerid] = false;
					gNews[playerid] = true;
					LvNews[playerid] = true;
					lNews[LiveOfferls[playerid]] = false;
					gNews[LiveOfferls[playerid]] = true;
					LvNews[LiveOfferls[playerid]] = true;
					LiveOfferls[playerid] = 999;
					TalkingLivels[playerid] = 2;
					SendClientMessage(playerid, COLOR_YELLOW, "Вы даёте интервью в прямом эфире радио Los Santos");
					return 1;
				}
				else return SendClientMessage(playerid, COLOR_GREY, !"Вы далеко от репортёра");
			}
			return 1;
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вам никто не предлагал дать интервью");
	}
	else if (strcmp(params[0],"livesf",true) == 0)
	{
		if (LiveOffer[playerid] < 999)
		{
			if (IsPlayerConnected(LiveOffer[playerid]))
			{
				if (IsPlayerInRangeOfPlayer(5.0, playerid, LiveOffer[playerid]))
				{
					TalkingLive[LiveOffer[playerid]] = 2;
					SendClientMessage(LiveOffer[playerid], COLOR_WHITE, "Введите: /live чтобы закончить интервью");
					lNews[playerid] = true;
					gNews[playerid] = false;
					LvNews[playerid] = true;
					lNews[LiveOffer[playerid]] = true;
					gNews[LiveOffer[playerid]] = false;
					LvNews[LiveOffer[playerid]] = true;
					LiveOffer[playerid] = 999;
					TalkingLive[playerid] = 2;
					SendClientMessage(playerid, COLOR_YELLOW, "Вы даёте интервью в прямом эфире радио San Fierro");
					return 1;
				}
				else return SendClientMessage(playerid, COLOR_GREY, !"Вы далеко от репортёра");
			}
			return 1;
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вам никто не предлагал дать интервью");
	}
	else if (strcmp(params[0],"livelv",true) == 0)
	{
		if (LiveOfferlv[playerid] < 999)
		{
			if (IsPlayerConnected(LiveOfferlv[playerid]))
			{
				if (IsPlayerInRangeOfPlayer(5.0, playerid, LiveOfferlv[playerid]))
				{
					TalkingLivelv[LiveOfferlv[playerid]] = 2;
					SendClientMessage(LiveOfferlv[playerid], COLOR_WHITE, "Введите: /live чтобы закончить интервью");
					lNews[playerid] = true;
					gNews[playerid] = true;
					LvNews[playerid] = false;
					lNews[LiveOfferlv[playerid]] = true;
					gNews[LiveOfferlv[playerid]] = true;
					LvNews[LiveOfferlv[playerid]] = false;
					LiveOfferlv[playerid] = 999;
					TalkingLivelv[playerid] = 2;
					SendClientMessage(playerid, COLOR_YELLOW, "Вы даёте интервью в прямом эфире радио Las Venturas");
					return 1;
				}
				else return SendClientMessage(playerid, COLOR_GREY, !"Вы далеко от репортёра");
			}
			return 1;
		}
		else return SendClientMessage(playerid, COLOR_GREY, !"Вам никто не предлагал дать интервью");
	} 
	else
	{
		return 1;
	}
	return 1;
}

CMD:eject(playerid,params[])
{
	if (!IsPlayerInAnyVehicle(playerid)) return 1;
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не водитель!");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /eject [id]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок не в транспорте");
	if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок не в Вашем авто");
	SendMes(playerid, 0x6495EDFF,"Вы выкинули из машины %s",pInfo[params[0]][pName]);
	SendMes(params[0], 0x6495EDFF, "Вас выкинул из машины %s",pInfo[playerid][pName]);
	RemovePlayerFromVehicle(params[0]);
	return 1;
}
alias:live("l");
//alias:goverment("gov");
//alias:givepayday("gpayday");

alias:ooc("o");



alias:suspect("su");
alias:amegaphone("am");

alias:departments("d");


alias:hangup("h");
alias:breathalyser("bh");

alias:admin("a");
alias:geton("online");

alias:agivelicense("agl"); 
alias:accept("ac");
alias:prodmenu("pmenu");

CMD:spylist(playerid, params[])
{
    if (pInfo[playerid][pMember] != 2) return SendClientMessage(playerid, COLOR_GREY, !"Вы не агент FBI");
	new want_text[128], want;
	t_string[0] = EOS;
	strcat(t_string, "Должность\tИмя\tТелефон\tМаскировка\n");
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) continue;
		if (pTemp[i][FBISpyAction] != -1)
		{
		    new ttext[21];
			switch(pTemp[i][FBISpyAction])
			{
			    case 1: ttext = "LSPD";
			    case 2: ttext = "ФБР";
			    case 3: ttext = "Армия СФ";
			    case 4: ttext = "Медики СФ";
			    case 5: ttext = "La Cosa Nostra";
			    case 6: ttext = "Yakuza";
			    case 7: ttext = "Мэрия";
			    case 8: ttext = "Casino";
			    case 9: ttext = "SF News";
			    case 10: ttext = "SFPD";
			    case 11: ttext = "Автошкола";
			    case 12: ttext = "Ballas Gang";
			    case 13: ttext = "Vagos Gang";
			    case 14: ttext = "Русская Мафия";
			    case 15: ttext = "Grove Street";
			    case 16: ttext = "LS News";
			    case 17: ttext = "Aztecas Gang";
			    case 18: ttext = "Rifa Gang";
			    case 19: ttext = "Армия ЛВ";
			    case 20: ttext = "LV News";
			    case 21: ttext = "LVPD";
			    case 22: ttext = "Медики ЛС";
			    case 23: ttext = "Медики ЛВ";
			    case 24: ttext = "Mongols MC";
			    case 25: ttext = "Bandidos MC";
			    case 26: ttext = "Outlaws MC";
				default: ttext = "Нет";
			}
			format(want_text, sizeof(want_text), "{FFFFFF}%s\t%s\t%d\t%s\n", fFractionRank[pInfo[i][pMember]][pInfo[i][pRank] - 1], pInfo[i][pName], pInfo[i][PlayerNumber], ttext);
			strcat(t_string, want_text);
			want++;
		}
	}
	if (want == 0) strcat(t_string, "");
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, "Под маскировкой", t_string, "Закрыть", "");
	return 1;
}
CMD:spyoff(playerid, params[])
{
    new string_[128];
    if (pInfo[playerid][pMember] != 2 || pInfo[playerid][pRank] < 6) return SendClientMessage(playerid, -1, "Доступно с 6 ранга");
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "Введите: /spyoff [id]");
    if (pInfo[params[0]][pMember] != 2) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок не состоит в FBI");
    f(string_, "%s забрал у %s возможность шпионить.", pInfo[playerid][pName], pInfo[params[0]][pName]);
	SendFamilyMessage(2, 0x00b953ff, string_);
	pTemp[params[0]][FBISpyAction] = -1;
	SetPlayerSkinEx(params[0], pInfo[params[0]][pModel]);
    SetPlayerColor(params[0], gFractionColor[pInfo[params[0]][pMember]]);
    return 1;
} 

CMD:alogin(playerid, params[])
{ 
	if (GetPlayerAdminSearch(playerid) == 0) return 1; 
    if (pTemp[playerid][PlayerADostup] == true)
	{
		new query_[128];
		
		format(query_, sizeof query_, "<off ALogin> %s %s[%d][Admin %d lvl]", pInfo[playerid][pSex] == 1 ? ("вышел") : ("вышла"), pInfo[playerid][pName], playerid, pInfo[playerid][pAdmin]);
		SendAdminMessage(0xF4B800AA, query_); 

		for(new i; i < sizeof(CheatShow); i++) {
			TextDrawHideForPlayer(playerid, CheatShow[i]);
		} 

		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(playerid,X,Y,Z);
		AC_Info[playerid][acPosDiff] = 40.0;
		AC_Info[playerid][acSpeed] = 40.0;
		AC_Info[playerid][acPosX] = X;
		AC_Info[playerid][acPosY] = Y;
		AC_Info[playerid][acPosZ] = Z;

		pTemp[playerid][PlayerADostup] = false;
	    pInfo[playerid][pAdmin] = 0;

		aAdminInfo[playerid][aID] 		=
		aAdminInfo[playerid][aRepute] 	= 
		aAdminInfo[playerid][aRegIP]    = 0;
	    Iter_Remove(AdminsTeam, playerid);
		return 1;
	}
	else
	{ 
		new query_[128];
	 	ShowPlayerDialog(playerid, D_ADMIN_FUNC_15, DIALOG_STYLE_PASSWORD, ""colserver"Авторизация: "colwhi"Администратор", ""colwhi"Введите пароль\n\nПароль должен состоять из латинских букв и цифр\n\tразмером от 6 до 15 символов", "Вход", "Отмена");
	    mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_admin` WHERE `Name` = '%e'", pInfo[playerid][pName]);
	 	mysql_tquery(dbHandle, query_, "OnMySQL_QUERY", "iis", MYSQL_LOGIN_ADMINS, playerid, "");
 	}
 	return 1;
}

CMD:report(playerid)
{ 
	return ShowPlayerDialog(playerid, D_MAINMENU_FUNC_2, DIALOG_STYLE_LIST, "Задать вопрос / Отправить жалобу","[0] Задать вопрос помощникам\n[1] Отправить жалобу", "Выбрать", "Назад");
}
alias:aquestion("aq");
CMD:aquestion(playerid, params[])
{
	new formatMessage[144];

	if (pInfo[playerid][rMuted])
		return SendClientMessage(playerid, COLOR_GREY, "У вас бан репорта!");

	if (pInfo[playerid][pAdmin] && pTemp[playerid][PlayerADostup])
		return SendClientMessage(playerid, COLOR_GREY, "Администраторы не могут подавать жалоб.");

	if (GetPVarInt(playerid, "report_id"))
		return SendClientMessage(playerid, COLOR_GREY, "Сначала дождитесь ответа на Ваше последнее обращение в репорт.");

	if (strlen(params) > 80 || strlen(params) < 2)
		return SendClientMessage(playerid, COLOR_GREY, "Введите: /aquestion [текст]");

	if (pInfo[playerid][pReportTimer] > gettime())
		return SendClientMessage(playerid, COLOR_GREY, "Подавать жалобу можно раз в 60 секунд.");

	pInfo[playerid][pReportTimer] = gettime() + 60;
	format(formatMessage, sizeof(formatMessage), " Жалоба от %s[%d]: %s", 
		pInfo[playerid][pName], playerid, params);
	
	SendClientMessage(playerid, COLOR_BROWN, formatMessage);
	SendAdminMessage(COLOR_BROWN, formatMessage);

	GameTextForAdmin("REPORT++~n~/(ti)ckets");
	
	for (new i = 1, string[116]; i < MAX_REPORT_SLOTS; i++)
	{
		if (aReportInfo[i][rPlayerID] != -1) 
			continue;
		
		aReportInfo[i][rIsTooked] = false;
		aReportInfo[i][rID] = i;
		aReportInfo[i][rType] = TICKETS_TYPE_REPORT;
		aReportInfo[i][rPlayerID] = playerid;
		
		format(string, sizeof(string), "%s", params);
		strmid(aReportInfo[i][rText], string, 0, 116, 116);
		
		aReportInfo[i][rWhenWroted_Time] = gettime();
		
		gettime(hour, minute, second);
		format(string, sizeof(string), "%02d:%02d:%02d", hour, minute, second);
		strmid(aReportInfo[i][rWhenWroted_Text], string, 0, 10, 10);
		SetPVarInt(playerid, "report_id", i + 1);

		break;
	}

	return SendClientMessage(playerid, COLOR_LIGHTRED, " Ваша жалоба была отправлена администрации");
}


CMD:tickets(playerid, params[])
{
	if (pInfo[playerid][pAdmin] == 0 && !SupportInfo[playerid][sDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта функция");
	return ShowReportForAdmin(playerid);
}  
alias:tickets("ti","arep");


CMD:tskill(playerid, params[])
{
    if (pInfo[playerid][pJob] != JOB_TRUCKER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не Дальнобойщик");
	new 
		gtext[12],
		corge_count = 0;
	t_string[0] = EOS;
	if (pTemp[playerid][tTruckerTrailerBuy] == INVALID_VEHICLE_ID) {
		gtext = "Нет";
	} else {
		switch(trailer_type[ pTemp[playerid][tTruckerTrailerBuy] - 1 ])
		{
			case 0, 1: gtext = "Дерево"; 
			case 2, 3: gtext = "Уголь";
			case 4, 5: gtext = "Бензин";
			default: gtext = "Ошибка";
		}
		corge_count = trailer_count[pTemp[playerid][tTruckerTrailerBuy] -1];
	}
	
	new nxtlevel = pInfo[playerid][pDLevel]+1;
	new expamount = nxtlevel*levelDexp;
	format(t_string, sizeof t_string, 
		""colwhi"Навык:\n\t\t\
		Уровень: %d\n\t\t\
		Exp: %d/%d\n\
		Фура:\n\t\t\
		Макс груз: %dт.\n\t\t\
		Загружено: %d\n\
		Груз: %s",
	pInfo[playerid][pDLevel], pInfo[playerid][pDExp], expamount, pInfo[playerid][pDMgruz], corge_count, gtext);
	ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Статистика: "colwhi"Дальнобойщика", t_string, "Готово", "");
	return 1;
}
CMD:thefskill(playerid) {
    new string_[128];
	format(string_,sizeof(string_), "Ваш опыт автоугонщика: %d / 1000.", pInfo[playerid][pSkilla]);
	return SendClientMessage(playerid, COLOR_BLUE, string_);
}
CMD:taxiskill(playerid) {
	new string_[128];
	format(string_, sizeof(string_), "Ваш уровень таксиста %d. До следующего осталось %d/%d exp",pInfo[playerid][pTaxiLevel], pInfo[playerid][pTaxiExp], pInfo[playerid][pTaxiLevel]*8);
	return SendClientMessage(playerid, 0x6495EDFF, string_);
}


CMD:agm(playerid)
{
	if (pInfo[playerid][pAdmin] < 1) return 1;
	if (pTemp[playerid][PlayerUseAdminGM] == false) {
		pTemp[playerid][PlayerUseAdminGM] = true;
		SendClientMessage(playerid, COLOR_YELLOW, !"Вы включили Anti GM. (/agm)");
	}
	else {
		pTemp[playerid][PlayerUseAdminGM] = false ;
		SendClientMessage(playerid, COLOR_YELLOW, !"Вы выключили Anti GM. (/agm)");
	}
	return 1;
}


CMD:boot(playerid)
{
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать в машине");
    new
		V_IDX = GetPlayerNearestVehicle(playerid);
	if (V_IDX != INVALID_VEHICLE_ID)
	{ 
		if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_DYNAMIC || (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_RENTCAR
			&& (VehicleInfo[ V_IDX - 1 ][vFraction] == RENT_CAR_BOAT || VehicleInfo[ V_IDX - 1 ][vFraction] == RENT_CAR_FAGGIO || VehicleInfo[ V_IDX - 1 ][vFraction] == RENT_CAR_FAGGIO_THEFT))) return SendClientMessage(playerid, COLOR_GREY, !"В данном транспорте нельзя пользоваться багажников!");
		if (IsPlayerInAnyVehicle(playerid)) return 1;
		if (VehicleInfo[ V_IDX - 1 ][vModel] == 508) return 1;
		new
			Float: coord[3];//
		GetCoordBootVehicle(V_IDX, coord[0], coord[1], coord[2]); 
		if (IsPlayerInRangeOfPoint(playerid, 3.0, coord[0], coord[1], coord[2]))
		{ 
			if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_PLAYER && (VehicleInfo[ V_IDX - 1 ][vFraction] == pInfo[playerid][pID])) {
				DialogBootVehicle(playerid, V_IDX);
				GetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 );
				if (boot1 != VEHICLE_PARAMS_ON) {
					SetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, VEHICLE_PARAMS_ON, objective1 );
				}
			}
			else if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION && (VehicleInfo[ V_IDX - 1 ][vFraction] == pInfo[playerid][pMember])) {
				DialogBootVehicle(playerid, V_IDX);
				GetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 );
				if (boot1 != VEHICLE_PARAMS_ON) {
					SetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, VEHICLE_PARAMS_ON, objective1 );
				}
			} 
			else return SendClientMessage(playerid, COLOR_GREY, !"В данном транспорте не доступен багажник!");
		    SetPVarInt(playerid, #PlayerVehicleID, V_IDX);
		    return 1;
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться возле транспорта!");
	return 1;
}
CMD:snow(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	if(snow[playerid] == 0)
	{
		GetPlayerCameraPos(playerid, x, y, z);
		snowobj[playerid] = CreatePlayerObject(playerid, 18864, x, y, z-5, 0.0, 0.0, 0.0,300.0);
		snow[playerid] = 1;
		SendClientMessage(playerid, COLOR_GREEN, "Снег включен.");
	}
	else if(snow[playerid] == 1)
	{
		snow[playerid] = 0;
		SendClientMessage(playerid, COLOR_GREEN, "Снег выключен");
		DestroyPlayerObject(playerid, snowobj[playerid]);
	}
	return 1;
}

CMD:kickout(playerid, params[]) {
	if (pInfo[playerid][pMember]) {
		if (pTemp[playerid][tDutyWork] != 1) 
			return SendClientMessage(playerid, COLOR_GREY, !"Начните рабочий день!");

		new targetid = INVALID_PLAYER_ID;
		if (sscanf(params, "u",targetid)) 
			return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /kickout [id]");
        if (!PlayerInConnected(targetid) || playerid == targetid) 
			return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
		if (pInfo[playerid][pMember] == pInfo[targetid][pMember] /*|| pTemp[targetid][PlayerADostup]*/ || IsACop(targetid)) 
			return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете выгнать данного игрока!");
		if (!IsPlayerInRangeOfPlayer(7.0, playerid, targetid))
			return  SendClientMessage(playerid, COLOR_GREY, !"Человек далеко от вас!");
		if (!IsPlayerInFractionInterior(targetid, pInfo[playerid][pMember]))
			return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться в Вашем интерьере!");
		new member = pInfo[playerid][pMember];
		if (pInfo[targetid][pFracIntKeys][member - 1] > 1)
			return SendClientMessage(playerid, COLOR_GREY, !"Вы уже выгнали из рабочего помещения данного игрока!");
		switch (member) {
			case FRACTION_LSPD: {
				SetPlayerPosAC(targetid, 1552.8159, -1675.4498, 16.1953, 0, 0);
				SetPlayerFacingAngle(targetid, 91.8310);
			}
			case FRACTION_HOSPITAL_SF: {
				if (pInfo[targetid][pHospital]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете выгнать пациента!");
				SetPlayerPosAC(playerid,-2664.4895, 636.7567, 14.4531, 0, 0);
				SetPlayerFacingAngle(playerid, 180.9984); 
			}
			case FRACTION_HOSPITAL_LS: {
				if (pInfo[targetid][pHospital]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете выгнать пациента!");
				SetPlayerPosAC(targetid, 1177.6982, -1323.7684, 14.0835, 0, 0);
				SetPlayerFacingAngle(targetid, 269.0719);
			}
			case FRACTION_CITYHALL: { 
				SetPlayerPosAC(targetid, 1480.8832,-1769.0471,18.7958, 0, 0);
				SetPlayerFacingAngle(targetid, 0.3133); 
			}
			case FRACTION_HOSPITAL_LV: {
				if (pInfo[targetid][pHospital]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете выгнать пациента!");
				SetPlayerPosAC(targetid, 1607.5677,1818.9572,10.8203, 0, 0);
				SetPlayerFacingAngle(targetid, 0.0); 
			}
			default: return SendClientMessage(playerid, COLOR_GREY, !"Недоступно для вашей организации!");
		}
		pInfo[targetid][pFracIntBlock][member - 1] = gettime() + (5 * 60);

		new query[512];
		format(query, sizeof(query), "UPDATE s_users SET \
			pFracIntBlock = '%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i' \
			WHERE `pID` = '%d' LIMIT 1",
			pInfo[targetid][pFracIntBlock][0], pInfo[targetid][pFracIntBlock][1], pInfo[targetid][pFracIntBlock][2],
			pInfo[targetid][pFracIntBlock][3], pInfo[targetid][pFracIntBlock][1], pInfo[targetid][pFracIntBlock][2],
			pInfo[targetid][pFracIntBlock][6], pInfo[targetid][pFracIntBlock][7], pInfo[targetid][pFracIntBlock][8],
			pInfo[targetid][pFracIntBlock][9], pInfo[targetid][pFracIntBlock][10], pInfo[targetid][pFracIntBlock][11],
			pInfo[targetid][pFracIntBlock][12], pInfo[targetid][pFracIntBlock][13], pInfo[targetid][pFracIntBlock][14],
			pInfo[targetid][pFracIntBlock][15], pInfo[targetid][pFracIntBlock][16], pInfo[targetid][pFracIntBlock][17],
			pInfo[targetid][pFracIntBlock][18], pInfo[targetid][pFracIntBlock][19], pInfo[targetid][pFracIntBlock][20],
			pInfo[targetid][pFracIntBlock][21], pInfo[targetid][pFracIntBlock][22], pInfo[targetid][pFracIntBlock][23],
			pInfo[targetid][pFracIntBlock][24], pInfo[targetid][pFracIntBlock][25],
			pInfo[playerid][pID]
		);
		mysql_tquery(dbHandle, query);
	
		format(t_string, sizeof (t_string), "%s[%d] выгнал Вас из рабочего помещения!",
			pInfo[playerid][pName], playerid
		);
		SendClientMessage(targetid, COLOR_BLUE, t_string);

		format(t_string, sizeof (t_string), "Вы выгнали %s[%d] из рабочего помещения!",
			pInfo[targetid][pName], targetid
		);
		SendClientMessage(playerid, COLOR_BLUE, t_string);

		t_string[0] = EOS;
	}
	else SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда!");
	return 1;
}

CMD:editsu(playerid) {
    if (!IsACop(playerid) || !pInfo[playerid][pLeader] || pTemp[playerid][tDutyWork] == 0) 
		return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда!");
	//if (!NEW_SUSPECT_SYSTEM) return true;
    
	ShowSuspectList(playerid, pInfo[playerid][pMember]);
	return true;
} 


cmd:boombox(playerid) {
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return SendClientMessage(playerid, COLOR_GREY, "Вы должны находиться пешком!");
	if (pTemp[playerid][tBoomboxArea]) {
		ShowPlayerDialog(playerid, D_BOOMBOX, DIALOG_STYLE_LIST, ""colserver"Бумбокс: "colwhi"установить", "\
			[0] Изменить музыку\n\
			[1] Убрать бумбокс", "Выбрать", "Отмена"
		), t_string[0] = 0;
		return true;
	}
	new idx = 0;
	t_string[0] = EOS;

	for (new i = 0; i < 3; i++) {
		if (!pInfo[playerid][pBoombox][i]) continue;
		format(t_string, sizeof (t_string), "%s[%i] %s (ID: %d)\n", t_string, idx,
			DonateAccesoryInfo[i][accesoryName],
			DonateAccesoryInfo[i][accesoryModel]
		);
		playerListItem[playerid][idx++] = i;
	}
	if (idx == 0) return SendClientMessage(playerid, COLOR_GREY, "У вас нет бумбокса, приобретите в /donate");
	ShowPlayerDialog(playerid, D_BOOMBOX, DIALOG_STYLE_LIST, ""colserver"Бумбокс: "colwhi"Установить", t_string, "Выбрать", "Отмена"), t_string[0] = 0;
	return true;
}


CMD:setcapttime(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new setting;
	if (sscanf(params, "i", setting)) 
		return true;
	if (setting < 1 || setting > 2) return SendClientMessage(playerid, COLOR_GREY, !"от 1 до 2");
	SystemConfig[gCaptureEveryOneHour] = setting;
	SendMes(playerid, COLOR_YELLOW, "Капт через каждые %d часа", SystemConfig[gCaptureEveryOneHour]);
	return true;
}
CMD:settoggle(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new setting;
	if (sscanf(params, "i", setting)) 
		return true;

	switch (setting) {
		case 0: { 
			if (DAMAGER_FIX) DAMAGER_FIX = 0, SendClientMessage(playerid, -1, "DAMAGER_FIX = 0");
			else DAMAGER_FIX = 1, SendClientMessage(playerid, -1, "DAMAGER_FIX = 1");
		} 
		case 1: {
			if (CAPTURE_STATS_ENABLED) CAPTURE_STATS_ENABLED = 0, SendClientMessage(playerid, -1, "Просмотр статистики капта выключен");
			else CAPTURE_STATS_ENABLED = 1, SendClientMessage(playerid, -1, "Просмотр статистики капта включен");
		}
		case 2: {
			if (SPECPL_SPAWN_ON) SPECPL_SPAWN_ON = 0, SendClientMessage(playerid, -1, "Специальный спавн выключен");
			else SPECPL_SPAWN_ON = 1, SendClientMessage(playerid, -1, "Специальный спавн включен");
		}
		case 3: {
			if (NEW_SUSPECT_SYSTEM) NEW_SUSPECT_SYSTEM = 0, SendClientMessage(playerid, -1, "/su по диалогу = 0");
			else NEW_SUSPECT_SYSTEM = 1, SendClientMessage(playerid, -1, "/su по диалогу = 1");
		}
		case 4: {
			if (NEW_ACHIEV_SYSTEM) NEW_ACHIEV_SYSTEM = 0, SendClientMessage(playerid, -1, "ачивки = 0");
			else NEW_ACHIEV_SYSTEM = 1, SendClientMessage(playerid, -1, "ачивки = 1");
		}
		case 5: {
			if (DAMAGER_INFO) DAMAGER_INFO = 0, SendClientMessage(playerid, -1, !"DAMAGER_INFO = 0");
			else DAMAGER_INFO = 1, SendClientMessage(playerid, -1, !"DAMAGER_INFO = 1");
		}
		case 6: {
			if (SB_INFO) SB_INFO = 0, SendClientMessage(playerid, -1, !"SB_INFO = 0");
			else SB_INFO = 1, SendClientMessage(playerid, -1, !"SB_INFO = 1");
		}
		case 7:
		{
			if (DRUGS_NO_SBIV) DRUGS_NO_SBIV = 0, SendClientMessage(playerid, -1, !"DRUGS_NO_SBIV = 0");
			else DRUGS_NO_SBIV = 1, SendClientMessage(playerid, -1, !"DRUGS_NO_SBIV = 1");
		}  
		case 8: {
			if (SKILL_PROMO) SKILL_PROMO = 0, SendClientMessage(playerid, -1, !"SKILL_PROMO = 0");
			else SKILL_PROMO = 1, SendClientMessage(playerid, -1, !"SKILL_PROMO = 1");
		}
		case 9:{
			if (NEW_ANTICHEAT_ALF) NEW_ANTICHEAT_ALF = 0, SendClientMessage(playerid, -1, !"NEW_ANTICHEAT_ALF = 0");
			else NEW_ANTICHEAT_ALF = 1, SendClientMessage(playerid, -1, !"NEW_ANTICHEAT_ALF = 1");
		}
		case 10:{
			if (NEW_ANTICHEAT_ALF_CAR) NEW_ANTICHEAT_ALF_CAR = 0, SendClientMessage(playerid, -1, !"NEW_ANTICHEAT_ALF_CAR = 0");
			else NEW_ANTICHEAT_ALF_CAR = 1, SendClientMessage(playerid, -1, !"NEW_ANTICHEAT_ALF_CAR = 1");
		}
		
	}
	return true;
} 


CMD:imghetto(playerid) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (IsPlayerToGhetto(playerid)) {
		SendClientMessage(playerid, -1, !"ok!");
	} else {
		SendClientMessage(playerid, -1, !"no!");
	}
	return true;
}


CMD:imnopark(playerid)
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине!");
	new 
		V_IDX = GetPlayerVehicleID(playerid);
	
	if ( GetVehicleIsNoParking(V_IDX)) {
		SendClientMessage(playerid, -1, "No park");
	}
	else  {
		SendClientMessage(playerid, -1, "Use park");
	}
	return 1;
} 


CMD:addbikercar(playerid) { 
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	InsertCreateVehicleAC(478,-265.4724,-2192.6326,28.8503,26.1699,2,1,PLAYER_JOB_HUNTER, VEHICLE_TYPE_JOB); //Pony
	InsertCreateVehicleAC(478,-271.6810,-2195.6863,28.7282,26.1692,2,1,PLAYER_JOB_HUNTER, VEHICLE_TYPE_JOB); //Pony

	/*InsertCreateVehicleAC(492, 1920.5137, -1130.5640, 24.6577, -90.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);
	InsertCreateVehicleAC(492, 1904.4801, -1130.2136, 24.2582, -90.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);
	InsertCreateVehicleAC(600, 1908.5996, -1140.1581, 24.2956, -90.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);
	InsertCreateVehicleAC(600, 1918.6846, -1140.5591, 24.5409, -90.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);
	InsertCreateVehicleAC(466, 1936.2096, -1130.1022, 24.9958, -90.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);
	InsertCreateVehicleAC(478, 1931.6448, -1141.1777, 25.1629, -90.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);
	InsertCreateVehicleAC(482, 1910.3499, -1115.8289, 25.7508, 180.0000, 84,84, FRACTION_PIRUS, VEHICLE_TYPE_FRACTION);*/
	return 1;
}


CMD:lock(playerid)
{
	new unlock_vehicle;
	new veh_id = GetPlayerVehicleID(playerid);
	if ( pTemp [ playerid ] [ tMopedGarage ] != INVALID_VEHICLE_ID )
	{
		new vehicleid = GetNearestVehicle(playerid);
		if ( pTemp [ playerid ] [ tMopedGarage ] == vehicleid ) unlock_vehicle = vehicleid;
		else unlock_vehicle = veh_id;
	}
	else if (veh_id > 0 )
	{
		new pos = -1;

		if (pTemp[playerid][tVehicleKey] == veh_id) pos = 1;
		else if (VehicleInfo[ veh_id - 1 ][vType] == VEHICLE_TYPE_PLAYER && VehicleInfo[ veh_id - 1 ][vFraction] == pInfo[playerid][pID]) pos = 2;
		else if (VehicleInfo[ veh_id - 1 ][vType] == VEHICLE_TYPE_FRACTION && VehicleInfo[ veh_id - 1 ][vFraction] == pInfo[playerid][pMember]) pos = 3;
		else if (VehicleInfo[ veh_id - 1 ][vType] == VEHICLE_TYPE_FAMILY && VehicleInfo[ veh_id - 1 ][vFraction] ==  pInfo[playerid][pFamily]) pos = 4;

		if (pos == -1 ) return SendClientMessage(playerid,CGRAY2,!"У вас нет ключей от данной машины");

		unlock_vehicle = veh_id;
	}
	else
	{
		new Float: pl_pos_x,
			Float: pl_pos_y,
			Float: pl_pos_z;
		GetPlayerPos(playerid, pl_pos_x, pl_pos_y, pl_pos_z);
		if (pTemp[playerid][tVehicleKey] != 0 && IsVehicleInRangeOfPoint (pTemp[playerid][tVehicleKey], 5.0, pl_pos_x, pl_pos_y, pl_pos_z ) )
		{
			unlock_vehicle = pTemp[playerid][tVehicleKey];
		}
		if (Iter_Count(PlayerListVehicle[playerid]) != 0)foreach(new veh_id_x:PlayerListVehicle[playerid])
		{
			
			if (!IsVehicleInRangeOfPoint ( veh_id_x, 3.6, pl_pos_x, pl_pos_y, pl_pos_z )) continue;
			unlock_vehicle = veh_id_x;
			break;
		}
		if (pInfo[playerid][pFamily] && Iter_Count(FamilyListVehicle[pInfo[playerid][pFamily]]) != 0)
		{
			foreach(new veh_id_x: FamilyListVehicle[ pInfo[playerid][pFamily] ])
			{ 
				if (!IsVehicleInRangeOfPoint ( veh_id_x, 3.6, pl_pos_x, pl_pos_y, pl_pos_z )) continue;
				unlock_vehicle = veh_id_x;
				break;
			}
		}
		if (pInfo[playerid][pMember] > 0 )
		{
			foreach(new vehicleid:StreamedVehicles[playerid])
			{
				if (VehicleInfo[vehicleid-1][vType] != VEHICLE_TYPE_FRACTION || VehicleInfo[vehicleid-1][vFraction] != pInfo[playerid][pMember]) continue ;
				if (IsVehicleInRangeOfPoint(VehicleInfo[vehicleid-1][vVehicle], 3.2, pl_pos_x, pl_pos_y, pl_pos_z ))
				{
					unlock_vehicle = VehicleInfo[vehicleid-1][vVehicle];
					break;
				}
			}
		}
	}
	if (unlock_vehicle)
	{
		PlayerPlaySound ( playerid, 1145, 0.0, 0.0, 0.0 ) ;
		GetVehicleParamsEx ( unlock_vehicle, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 ) ;
		if (VehicleInfo[ unlock_vehicle - 1 ][vLocked]) {
			VehicleInfo[ unlock_vehicle - 1 ][vLocked] = false ;
			SetVehicleParamsEx ( unlock_vehicle, engine1, lights2, alarm2, false, bonnet2, boot1, objective1 ) ;
			if (IsABoat(unlock_vehicle)) GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~ BOAT UNLOCK", 3000, 3);
			else if (IsAPlane(unlock_vehicle)) GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~ PLANE UNLOCK", 3000, 3);
			else GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~UNLOCK", 3000, 3 ) ;
		} else {
			VehicleInfo[ unlock_vehicle - 1 ][vLocked] = true ;
			SetVehicleParamsEx ( unlock_vehicle, engine1, lights2, alarm2, true, bonnet2, boot1, objective1 ) ;
			if (IsABoat(unlock_vehicle)) GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~ BOAT LOCK", 3000, 3 ) ;
			else if (IsAPlane(unlock_vehicle)) GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~ PLANE LOCK", 3000, 3 ) ;
			else GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~r~LOCK", 3000, 3 ) ;
		} 
        UpdateVehiclevText(playerid, unlock_vehicle); 
	}
	return 1;
}

CMD:gift(playerid, params[])
{
    new query_[128];
    format(query_, sizeof query_, "SELECT `w_rSpins` FROM `s_users` WHERE `pID` = '%d' LIMIT 1", pInfo[playerid][pID]);
    mysql_tquery(dbHandle, query_, "UpdatePrizeInfo", "i", playerid);
    if(pInfo[playerid][pSpins] < 1) return SCM(playerid, COLOR_RED, !"У Вас нет доступных прокруток!");
    switch(random(4))
	{
 		case 0: currentcase[playerid] = 1;
		case 1: currentcase[playerid] = 2;
		case 2: currentcase[playerid] = 3;
		case 3: currentcase[playerid] = 4;
	}
    ShowPlayerDialog(playerid, D_PRIZE_OPEN, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Прокрутка | {1E90FF}Подарочное вращение",
	"{FFFFFF}Наименование\t{FFFFFF}Подробнее\n\
	{FFFFFF}+2 EXP\t+2 к опыту\n\
	{FFFFFF}Полный комплект лицензий\tКатегории A, B, C, AIR\n\
	{FFFFFF}Все скиллы на 100%\tПолная прокачка скиллов\n\
	{FFFFFF}Санятие одного Warn\tСнятие предупреждения\n\
	{FFFFFF}Донат валюта\tОт 2, до 100\n\
	{FFFFFF}Игровая валюта\tОт 10000, до 100000\n\
	{FFFFFF}Персональный скин\tНовая одежда","Крутить","");
    SendClientMessage(playerid, COLOR_GREEN, "Сейчас случайным образом для Вас определится подарок!");
    SetPlayerSpecialAction (playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 1, 19054, 1, 0.11, 0.36, 0.0, 0.0, 0.0,0.40, 0.40, 0.40);
	return 1;
}

CMD:giveroulette(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6) return SendClientMessage(playerid, COLOR_GREY, !"Вам не доступна эта команда");
	new targetid;
	if (sscanf(params,"u",targetid)) {
		foreach(new i: PlayerInLogin) {
			if (!PlayerInConnected(i)) continue;
			GiveFreeRoulette(i);
		}
		SendClientMessage(playerid, COLOR_ISPOLZUY, !"Вы выдали рулетки всем игрокам");
		SendClientMessage(playerid, -1, !"Используйте: /(giver)oulette [ид игрока]");
		return 1;
	}
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн");
	GiveFreeRoulette(targetid);
	new
		string_[128];
	format(string_, sizeof string_, "Вы выдали рулетку игроку %s", pInfo[targetid][pName]);
	SendClientMessage(playerid, COLOR_ISPOLZUY, string_);
	return 1;
}
alias:giveroulette("giver");

CMD:getcampos(playerid, params[])
{
	new Float:x1,Float:y1,Float:z1;
	GetPlayerCameraLookAt(playerid,x1,y1,z1);
	SendMes(playerid,COLOR_GREY, "GetPlayerCameraLookAt %f,%f,%f",x1,y1,z1);
	GetPlayerCameraPos(playerid,x1,y1,z1);
	SendMes(playerid,COLOR_GREY, "GetPlayerCameraPos %f,%f,%f",x1,y1,z1);
	return 1;
}