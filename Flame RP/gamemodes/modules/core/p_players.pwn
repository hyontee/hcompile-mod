public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
	if(hittype > 4) return false;
	if((hittype == BULLET_HIT_TYPE_PLAYER && ! IsPlayerConnected(hitid)) || (hittype == BULLET_HIT_TYPE_VEHICLE && !IsValidVehicle(hitid)) || (hittype == BULLET_HIT_TYPE_OBJECT && !IsValidVehicle(hitid)) || (hittype == BULLET_HIT_TYPE_PLAYER_OBJECT && !IsValidPlayerObject(playerid, hitid))) return false;
    return 1;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	if(newinteriorid > 0 && oldinteriorid == 0) SetPlayerWeather(playerid, 1);
	else if(newinteriorid == 0 && oldinteriorid > 0) SetPlayerWeather(playerid,2);
	return 1;
}
public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(result == -1)
	{
	    new string_warning[102];
	    format(string_warning, sizeof(string_warning), "Команда /%s не существует! Используйте "P"/mn > Команды сервера{1965D9}", cmd);
	    SCM(playerid, COLOR_GREY, string_warning);
	    return 0;
	}

	return 1;
}
public OnPlayerCommandReceived(playerid, cmd[], params[], flags) {
    /*if(TI[playerid][tDialog]) {
		ErrorMessage(playerid,"Нельзя использовать команды при открытом диалоге");
		return 0;
	}*/
	if(!TI[playerid][tLogin]) {
		ErrorMessage(playerid,"Необходимо авторизоваться");
		return 0;
	}
	if(GetTickCount()-GetPVarInt(playerid, "AntiFlood") < 500) {
		if(CountFloodForPlayer[playerid] >= 2) return 0;
		CountFloodForPlayer[playerid]++;
		ErrorMessage(playerid, "Пожалуйста, не флудите");
		return 0;
	}
	if(timer_job_mower[playerid] > 1)
	{
		ErrorMessage(playerid,"В данный момент момент вы работаете, нельзя использовать команды");
		return 0;
	}
	SetPVarInt(playerid, "AntiFlood", GetTickCount());
	return TI[playerid][tLogin];
}
public OnPlayerConnect(playerid) {
	if(playerid == 65535) return Kick(playerid);

	TI[playerid][tLogin] = false;
	TI[playerid][tSpawn] = false;
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 850, playerid);
	SetPlayerVirtualWorld(playerid,playerid+1);
	GetPlayerIp(playerid,player_ip_check[playerid],16);
	Check_Client(playerid);

	for(new i; i<MAX_QUESTS; i++) {
		AcceptQuest[playerid][i]=0;
		QuestShow[playerid][i]=0;
		QuestProgress[playerid][i]=0;
	}
	GetPlayerName(playerid,player_name[playerid],MAX_PLAYER_NAME);


	new query_name[82 + MAX_PLAYER_NAME];

	mysql_format(connects,query_name,sizeof(query_name), "SELECT `online_status` FROM `accounts` WHERE Name = '%e' AND `online_status` < 1001",player_name[playerid]);
 	mysql_tquery(connects, query_name, "check_online_status", "i", playerid);

	new tag_position = strfind(player_name[playerid], "[PC]",true);
	if(tag_position != -1) {
		strdel(player_name[playerid], tag_position, tag_position + 4);
		SetPlayerName(playerid, player_name[playerid]);
	}

	if(!IsRPNick(player_name[playerid])) {
		ErrorMessage(playerid, "У вас nRP никнейм (Пример правильного ника: James_Marvey)");
		return Kick(playerid);
	}

	ac_1{playerid} = false;
	to_default(playerid);

    shotTime[playerid] = 0;
	shot[playerid] = 0;

	spaned[playerid]=0;

	//if(strcmp(player_name[playerid],"None",true) == 0) return Kick(playerid);
	new query_banip_check[70];
	format(query_banip_check, sizeof(query_banip_check), "SELECT * FROM `"TABLE_BANIP"` WHERE `IP` = '%s' LIMIT 1", player_ip_check[playerid]);
	mysql_tquery(connects, query_banip_check, "check_ip_ban", "i", playerid);


	for(new i; i < 2; i++) TextDrawShowForPlayer(playerid, world_time[i]);
	
	
	if(TI[playerid][pAndroid]) {
		TextDrawShowForPlayer(playerid, LOGO_ANDROID);
	}
	else {
		for (new i = 0; i < 23; i++) {
			TextDrawShowForPlayer(playerid, LOGO[i]);
		}
	}

	GangZoneShowForPlayer(playerid, SFa, COLOR_YELLOW2);
	GangZoneShowForPlayer(playerid, Army, COLOR_YELLOW2);

    if(TI[playerid][pAndroid]) {
		SCM(playerid, COLOR_GREY, "Инициализация клиента "NAME_SERVER" Mobile");
		ACLoad(playerid);
	}

	else
	{
	    SCM(playerid, COLOR_GREY, "Осуществление входа через PC");
	}
	RemoveBuildings(playerid);

	//SCM(playerid, CGOLD, "[Testing System] Для активации режима тестера введите /tester");
	//SCM(playerid, CGOLD, "[Testing System] Для входа в режим Android введите /android_mode");

	return true;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	new Float: x, Float: y, Float: z;
    GetPlayerPos(playerid, x, y, z);

	new arend_id = INVALID_PLAYER_ID;
	if(GetArendCarID(vehicleid, arend_id) != -1) {
		new string[200];
		if(arend_id == INVALID_PLAYER_ID || !IsPlayerConnected(arend_id)) {
			if(!ispassenger) {
				new rc = GetArendCarID(vehicleid);

				new price;
				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(ArendInfo[rc][aCost]/100*vip_status[PI[playerid][pVips]][vip_rentcar]);
					price = (ArendInfo[rc][aCost]-seller);
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(ArendInfo[rc][aCost]/100*BonusInfo[act_rentcar]);
						price = (ArendInfo[rc][aCost]-seller);
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(ArendInfo[rc][aCost]/100*BonusInfo[act_rentcar]);
						price = (ArendInfo[rc][aCost]-seller);
					}
				    else price = ArendInfo[rc][aCost];
				}

				format(string,sizeof(string),""YELLOW"Транспорт для аренды\n\n"W"- Модель: "P"%s"W"\n- Стоимость: "GREEN"$%i"W"\n\nДля аренды Т/С нажмите "ORANGE"'Аренда'", gTransport[GetVehicleModel(vehicleid)-400][trName], price);
				D(playerid, dRentCar, DSM, ""P"Аренда", string, "Аренда", "Отмена");
				SetPVarInt(playerid, "rent_carid", vehicleid);
				ClearAnimations(playerid, 1);
			}
			else ClearAnimations(playerid, 1);
		}
		else if(arend_id != playerid) {
			ErrorMessage(playerid,"Этот транспорт уже арендуют");
			if(!ispassenger) ClearAnimations(playerid, 1);
		}
	}
	if(VehicleInfo[vehicleid][vBizz] > 0) {

		if(IsVehicleOccupiedEx(vehicleid) && VehicleInfo[vehicleid][vBizz] > 0 && !ispassenger) return ClearAnimations(playerid);
		switch(VehicleInfo[vehicleid][vBizz]) {
			case 2..4: {
				if(VehicleInfo[vehicleid][vBizz] != PI[playerid][bizz_work] && !ispassenger) return ErrorMessage(playerid,"Вы не водитель такси"),ClearAnimations(playerid);
				switch(GetVehicleModel(vehicleid)) {
					case 540,550:
					{
						if(PI[playerid][bizz_status] < 2 && !ispassenger) return ErrorMessage(playerid,"У Вас нет доступа к этому классу такси"),ClearAnimations(playerid);
					}
					case 483:
					{
						if(PI[playerid][bizz_status] < 3 && !ispassenger) return ErrorMessage(playerid,"У Вас нет доступа к этому классу такси"),ClearAnimations(playerid);
					}
					case 560,580:
					{
						if(PI[playerid][bizz_status] < 4 && !ispassenger) return ErrorMessage(playerid,"У Вас нет доступа к этому классу такси"),ClearAnimations(playerid);
					}
				}
			}
			case 5..7: {
				if(VehicleInfo[vehicleid][vBizz] != PI[playerid][bizz_work] && !ispassenger) return ErrorMessage(playerid,"Вы не сотрудник транспортной компании"),ClearAnimations(playerid);
			}
		}
	}
	if(VehicleInfo[vehicleid][vType] == VEHICLE_TYPE_AUTOSALON) ClearAnimations(playerid, 1);
	if(VehicleInfo[vehicleid][vBizz] && !ispassenger) {
		for(new i = 0; i < 20; i++) {
			if(vehicleid == FuncBizz[VehicleInfo[vehicleid][vBizz]][funcbCars][i])
			{
				FuncBizz[VehicleInfo[vehicleid][vBizz]][funcbCarID][i] = playerid;
			}

		}
	}
	if(VehicleInfo[vehicleid][vRobHouse]) {
		if(vehicleid != rob_veh[playerid]) ClearAnimations(playerid, 1);
	}
	if(TI[playerid][tJobLoader][0] && TI[playerid][tJobLoader][1])
	{
		SendOk(playerid,"Нельзя садиться в авто во время рабочего дня");
		if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid,2);
		ClearAnimations(playerid);
		TI[playerid][tJobLoader][1] = 0;
		SetPlayerCheckpoint(playerid, 836.7643,-1203.7499,16.9766, 4.0);
	}
	if(TI[playerid][tJobOil][0] && TI[playerid][tJobOil][1]) {
		SendOk(playerid,"Нельзя садиться в авто во время рабочего дня");
		ClearAnimations(playerid);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
		SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
		SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);
		TI[playerid][tJobOil][1] = false;
	}
	//
    GetVehicleParamsEx(vehicleid, engine,lights,alarm,doors,bonnet,boot,objective);
	if(doors) {
		if(IsAPlane(vehicleid)) return 1; // костыль (из-за тупой системы аренды aurora)
	 	SetPlayerPos(playerid, x, y, z);
		D(playerid, DIALOG_NONE, DSM, !""P"Уведомление", !""W"Данный транспорт закрыт", !"Закрыть", !"");
	}
	//
	SetPlayerArmedWeapon(playerid,0);
	return true;
}
public OnPlayerDisconnect(playerid, reason) {

	// Итераторы
	if(Iter_Contains(adminsCount, playerid)) Iter_Remove(adminsCount, playerid);
	if(Iter_Contains(helpersCount, playerid)) Iter_Remove(helpersCount, playerid);
	if(Iter_Contains(youtubersCount, playerid)) Iter_Remove(youtubersCount, playerid);
	//

	if(TI[playerid][tClothesWork][0] && GetPVarInt(playerid,"zp_clothes")) {
		GiveMoney(playerid, GetPVarInt(playerid,"zp_clothes"), "зп alcatraz");
		SetPVarInt(playerid, "zp_clothes", 0);
	}
	else if(TI[playerid][tJobSalary]) {
		FI[fWHITEHOUSE][fBank] -= TI[playerid][tJobSalary];
		GiveMoney(playerid, TI[playerid][tJobSalary], "зп какая-то работа, выход из игры");
		TI[playerid][tJobSalary] = 0;
	}
	
	PlayerTextDrawDestroy(playerid, work_td_local[playerid][0]);

	if(GetPVarInt(playerid, "PlacedBB")) {

		foreach(new i: Player) if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) StopStream(i);
		DeletePVar(playerid, "BBArea");
		DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
		DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
		DeletePVar(playerid, "PlacedBB"); DeletePVar(playerid, "BBLabel");
		DeletePVar(playerid, "BBX"); DeletePVar(playerid, "BBY"); DeletePVar(playerid, "BBZ");
		DeletePVar(playerid, "BBInt");
		DeletePVar(playerid, "BBVW");
		DeletePVar(playerid, "BBStation");
	}

	if(TI[playerid][tArendaCar] != -1) A_DestroyVehicle(TI[playerid][tArendaCar]);
	leave_robhouse(playerid);
	for(new i;i<10;i++) {
	    if(ChetInfo[i][cheatid1]==playerid) {
			TextDrawSetString(CheatText[i], "-");
			Cheat1 ++;
			if(Cheat1 > 9) Cheat1 = 0;
		}
 	}
	if(TI[playerid][pAndroid]) {
		TextDrawHideForPlayer(playerid, LOGO_ANDROID);
/* 		TextDrawHideForPlayer(playerid, mobile_global_hud);
		for (new i; i < 7; i++) {
			PlayerTextDrawDestroy(playerid, mobile_local_hud[playerid][i]);
		} */
	}
	else for (new i = 0; i < 23; i++) TextDrawHideForPlayer(playerid, LOGO[i]);
	for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, world_time[i]);
	//if(actorereg[playerid][0] != -1) DestroyActor(actorereg[playerid][0]);
	//if(actorereg[playerid][1] != -1) DestroyActor(actorereg[playerid][1]);
	if(maniken[playerid] != -1) DestroyDynamicObject(maniken[playerid]);
	if(TI[playerid][tRaceID] != INVALID_VEHICLE_ID) srace_end(playerid,1);
	if(player_to_game[playerid] == 1) {
		players_in_game--;
		DelGun(playerid);
	}
	if(TI[playerid][tDuel] != -1) {
		if(DI[TI[playerid][tDuel]][duel_start] == true) end_duel(playerid,1);
		else duel_delete(TI[playerid][tDuel],false);
	}
	if(TI[playerid][tCashDM]) {
		GiveMoney(playerid,TI[playerid][tCashDM],"возвращение взноса сумасшедших войн");
		TI[playerid][tCashDM] = 0;
		new query[48 + MAX_PLAYER_NAME];
		format(query, sizeof(query), "DELETE FROM `dm_arena` WHERE BINARY `Name` = '%s'", player_name[playerid]);
		mysql_tquery(connects, query, "", "");
	}
	if(player_to_race_lv[playerid] != 0) {
		players_in_race_lv--;
		player_to_race_lv[playerid] = 0;
		if(player_to_race_lv_id[playerid] != INVALID_VEHICLE_ID) {
			A_DestroyVehicle(player_car_race_lv_id[playerid]);
			player_to_race_lv_id[playerid] = INVALID_VEHICLE_ID;
		}
	}
	if(TI[playerid][tCashRace]) {
		GiveMoney(playerid,TI[playerid][tCashRace],"возвращение взноса безумных гонок");
		TI[playerid][tCashRace] = 0;
	}
	if(player_to_golod[playerid] == 1) {
		players_in_golod--;
		golod_deatch(playerid,players_in_golod);
		DelGun(playerid);
	}
	for(new i = 0; i < 14; i++) {
		if(VacancyInfo[i][VacancyCreator] == playerid) {
			VacancyInfo[i][VacancyStatus] = false;
			VacancyInfo[i][VacancyCreator] = INVALID_PLAYER_ID;
		}
	}
	TI[playerid][tDiceID] = INVALID_PLAYER_ID;
	TI[playerid][tDiceIDs] = INVALID_PLAYER_ID;

	ether_closed(playerid);
	if(reason == 1 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) {
		arrest(playerid);
		static const f_str[] = "%s вышел из игры во время задержания и был посажен в КПЗ";
		new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];
		format(string,sizeof(string), f_str, player_name[playerid]);
		SendClientMessageToAll(CBADINFO,string);
	}
	if(car_autoschool[playerid] != INVALID_VEHICLE_ID) {
		A_DestroyVehicle(car_autoschool[playerid]);
		car_autoschool[playerid] = INVALID_VEHICLE_ID;
	}
	if(TI[playerid][tFight] != -1) {
		GiveMoney(playerid,-RingInfo[0][rgPrice],"поражение поединок");
		GiveMoney(TI[playerid][tFight],(RingInfo[0][rgPrice]*2),"победа поединок");
		PlayerSpawn(TI[playerid][tFight]);
		TI[TI[playerid][tFight]][tFight] = -1;
		TI[playerid][tFight] = -1;
		CheckPlayerRing(playerid);
	}
	if(TI[playerid][tSpectr] != INVALID_PLAYER_ID && SERIU[TI[playerid][tSpectr]][sID] == playerid) {
	 	callcmd::reoff(TI[playerid][tSpectr],"");
	 	GameTextForPlayer(TI[playerid][tSpectr], "Player Disconected", 700, 3);
	}
	if(avir[playerid] != -1) {
 	    PI[playerid][pMember] = TI[playerid][preOrg];
	    PI[playerid][pRank] = TI[playerid][preOrgg];
	    avir[playerid] = -1;
	    SERIU[playerid][sID] = -1;
	    TI[playerid][preOrg] = 0;
	    TI[playerid][preOrgg] = 0;
 	}
	if(TI[playerid][tJobWood][0]) {
        RemovePlayerAttachedObject(playerid,9);
        if(TI[playerid][tJobWood][2] != -1) {
			WD::[TI[playerid][tJobWood][2]][woodUse] = false;
        }
    }
   	if(TI[playerid][tJobLoader][0]) {
        RemovePlayerAttachedObject(playerid,2);
    }
	if(TI[playerid][tArendKey] != -1) {
		new v = TI[playerid][tArendKey];
		if(ArendInfo[v][aPlayerID] == playerid) {
			ArendInfo[v][aPlayerID] = INVALID_PLAYER_ID;
            SetVehicleToRespawn(ArendInfo[v][aID]);
		}
    }
	if(TI[playerid][tJobSad][1]) {
		if(SI[TI[playerid][tJobSad][1]-1][sad_temp] == 1) {
			UpdateDynamic3DTextLabelText(SI[TI[playerid][tJobSad][1]-1][sad_3dtext],-1,"Дерево\nСтадия: сохнет\nФермер: отсутствует");
			SI[TI[playerid][tJobSad][1]-1][sad_temp] = 0;
		}
	}
	if(GotoInfo[playerid][gtGoID] != INVALID_PLAYER_ID) CheckPlayerGoCuff(playerid);
	if(GotoInfo[playerid][gtID] != INVALID_PLAYER_ID) {
	    TI[GotoInfo[playerid][gtID]][tCuffed] = false;
		TI[GotoInfo[playerid][gtID]][tCuffedTime] = 0;
		TogglePlayerControllable(GotoInfo[playerid][gtID],true);
		SetPlayerSpecialAction(GotoInfo[playerid][gtID], 0);
	    ClearAnims(GotoInfo[playerid][gtID]);
     	SendOk(GotoInfo[playerid][gtID],"Вы были выпущены с конвоя");
        CheckPlayerGoCuff(GotoInfo[playerid][gtID]);
        CheckPlayerGoCuff(playerid);
	}
	if(p_mh[playerid]!=PlayerText:-1) {
		PlayerTextDrawHide(playerid,p_mh[playerid]);
		PlayerTextDrawDestroy(playerid,p_mh[playerid]);
		p_mh[playerid]=PlayerText:-1;
	}
	CheckPlayerGoCuff(playerid);
	if(ReportID[playerid] != -1) {
		ReportSlot[ReportID[playerid]] = -1;
		ReportID[playerid] = -1;
	}
	if(ReportIDAsk[playerid] != -1) {
		ReportSlotAsk[ReportIDAsk[playerid]] = -1;
		ReportIDAsk[playerid] = -1;
	}
	for(new i;i<MAX_ASK;i++) {
		if(PlayerReportAsk[i] == -1) continue;
		if(PlayerReportAsk[i] == playerid) ReportDellAsk(i);
	}
	if(rep_system) {
		for(new i;i<MAX_REPORTS;i++) {
			if(PlayerReport[i] == -1) continue;
			if(PlayerReport[i] == playerid) ReportDell(i);
		}
	}
	if(fam_lable[playerid] != Text3D:-1) {
		DestroyDynamic3DTextLabel(fam_lable[playerid]);
		fam_lable[playerid] = Text3D:-1;
	}
	if(TI[playerid][tDMArea][0] || TI[playerid][tGunArea][0]) {
		callcmd::exitdm(playerid);
	}
	for(new i; i<3; i++) {
		if(calls_ether[i] == playerid) {
			calls_ether[i] = INVALID_PLAYER_ID;
			SendOk(calls_news[i], "Игрок вышел из игры");
		}
		if(calls_news[i] == playerid && calls_ether[i] != INVALID_PLAYER_ID) {
			SendOk(calls_ether[i], "Ведущий вышел из игры");
			PhoneStatus(calls_ether[i],false);
			calls_ether[i] = INVALID_PLAYER_ID;
			calls_news[i] = INVALID_PLAYER_ID;
		}
	}
	if(GetPVarInt(playerid,"adchecking_fix")) {
		gAdvert[GetPVarInt(playerid,"adchecking_fix")-1][adCheking]=false;
		DeletePVar(playerid,"adchecking_fix");
	}
	if(Casino_Flag[playerid][select_casino_table] != -1 ){
		ShowCasino_TD(playerid, Casino_Flag[playerid][select_casino_table]);
		Casino_Flag[playerid][select_casino_table] = -1;
	}
	if(PTD_DiceStat[playerid]!=PlayerText:-1){
		PlayerTextDrawDestroy(playerid,PTD_DiceStat[playerid]);
		PTD_DiceStat[playerid]=PlayerText:-1;
	}
	if(buy_player_skins[playerid]!=PlayerText:-1){
		PlayerTextDrawDestroy(playerid,buy_player_skins[playerid]);
		buy_player_skins[playerid]=PlayerText:-1;
	}
	if(skill_player_td[playerid][0]!=PlayerText:-1){
		PlayerTextDrawDestroy(playerid,skill_player_td[playerid][0]);
		skill_player_td[playerid][0]=PlayerText:-1;
	}
	if(skill_player_td[playerid][1]!=PlayerText:-1){
		PlayerTextDrawDestroy(playerid,skill_player_td[playerid][1]);
		skill_player_td[playerid][1]=PlayerText:-1;
	}
	if(TI[playerid][tAlcotraz][0]) {
		PI[playerid][pJailTime] = 4500;
	}
	if(GetPVarInt(playerid,"block")) {
		if(ObjectShip[playerid] != 0x7F800000) {
			DestroyDynamicObject(ObjectShip[playerid]);
		}
		DestroyDynamicArea(GetPVarInt(playerid,"Ships"));
		DestroyDynamic3DTextLabel(ShipText[playerid]);
	}
	if(TI[playerid][tPhoneCaller] == playerid || TI[playerid][tPhoneCalled] == playerid) {
		new id;
		if(TI[playerid][tPhoneCaller] == playerid) id = TI[playerid][tPhoneCalled];
		else if(TI[playerid][tPhoneCalled] == playerid) id = TI[playerid][tPhoneCaller];
		else return SendClientMessage(playerid,COLOR_LIGHTRED,"Ошибка (#112)");
		SendOk(id,"Абонент отключился, связь прекращена");
		PhoneStatus(id,false);
		TI[playerid][tPhoneCaller] = INVALID_PLAYER_ID;
		TI[playerid][tPhoneCalled] = INVALID_PLAYER_ID;
		TI[id][tPhoneCaller] = INVALID_PLAYER_ID;
		TI[id][tPhoneCalled] = INVALID_PLAYER_ID;
		TI[playerid][tPhone] = false;
		TI[id][tPhone] = false;
	}
	if(thefttime[playerid] != 0) { // угон
		DestroyDynamicArea(theftarea[playerid][0]);
		DisablePlayerCheckpoint(playerid);
		DestroyDynamicCP(theftCheck[playerid][0]);
		A_DestroyVehicle(theftIDveh[playerid][0]);
		theftIDveh[playerid][0] = INVALID_VEHICLE_ID;
		if(theftplayer[theftIDveh[playerid][1]][0] != 1010) theftplayer[theftIDveh[playerid][1]][0] = 1010;
		if(theftveh[playerid][0] != INVALID_VEHICLE_ID) {
			A_DestroyVehicle(theftveh[playerid][0]);
			theftveh[playerid][0] = INVALID_VEHICLE_ID;
		}
		theftplayer[playerid][0] = 1010;
		theftplayer[playerid][1] = 0;
		theftCheck[playerid][1] = 0;
		PlayerTextDrawHide(playerid, theft_PTD[playerid][0]);
		thefttime[playerid] = 0;
		if(PI[playerid][ptheftExp] == 0) {
			if(PI[playerid][ptheftSkill] != 0) PI[playerid][ptheftSkill]--, UpdatePlayerData(playerid,"theftSkill",PI[playerid][ptheftSkill]);
			PI[playerid][ptheftExp] = TheftSkillMax[PI[playerid][ptheftSkill]]-1, UpdatePlayerData(playerid,"theftExp",PI[playerid][ptheftExp]);
		}
		else {
			if(PI[playerid][ptheftExp] != 0) PI[playerid][ptheftExp]--, UpdatePlayerData(playerid,"theftExp",PI[playerid][ptheftExp]);
		}
	}
	if(house_car[playerid][0] != INVALID_VEHICLE_ID) {
		gPlayerCars[playerid][carFuel][0] = VehicleInfo[house_car[playerid][0]][vFuel];
		gPlayerCars[playerid][carDrived][0] = VehicleInfo[house_car[playerid][0]][vDrived];
		save_car(playerid,0);
		if(theftplayer[playerid][0] == 1010) {
			A_DestroyVehicle(house_car[playerid][0]);
			house_car[playerid][0] = INVALID_VEHICLE_ID;
		}
		if(house_car[playerid][0] != INVALID_VEHICLE_ID) {
			A_DestroyVehicle(house_car[playerid][0]);
			house_car[playerid][0] = INVALID_VEHICLE_ID;
		}
	}
	if(house_car[playerid][1] != INVALID_VEHICLE_ID) {
		gPlayerCars[playerid][carFuel][1] = VehicleInfo[house_car[playerid][1]][vFuel];
		gPlayerCars[playerid][carDrived][1] = VehicleInfo[house_car[playerid][1]][vDrived];
		save_car(playerid,1);
	    if(theftplayer[playerid][0] == 1010) {
	    	A_DestroyVehicle(house_car[playerid][1]);
	    	house_car[playerid][1] = INVALID_VEHICLE_ID;
	    }
		if(house_car[playerid][1] != INVALID_VEHICLE_ID) {
			A_DestroyVehicle(house_car[playerid][1]);
			house_car[playerid][1] = INVALID_VEHICLE_ID;
		}
	}
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);

	if(!TI[playerid][pAndroid] && GetPVarInt(playerid, "speedometr_show") == 1) 
	{
		for(new i; i < 13; i++) TextDrawHideForPlayer(playerid, SPEEDOMETR_GLOBAL[i]);
		for(new i; i < 7; i++) PlayerTextDrawDestroy(playerid, SPEEDOMETR_LOCAL[playerid][i]);
	}
	else if(TI[playerid][pAndroid] && GetPVarInt(playerid, "speedometr_show") == 2) {
		for(new i; i < 8; i++) PlayerTextDrawDestroy(playerid, fspeed[playerid][i]);
	}

	DestroyDynamic3DTextLabel(DMSTATUS[playerid]);
	DMSTATUS[playerid] = Text3D:(0xFFFF);

	format(WantNickChange[playerid],MAX_PLAYER_NAME, "");

	//new year, month,day;
	//getdate(year, month, day);
	//new hour, minute, second;
	//gettime(hour, minute, second);
	new query[558],string[128];

	if(speed_timer[playerid] != -1){
		KillTimer(speed_timer[playerid]);
		speed_timer[playerid] = -1;
	}

	format(query,76,"UPDATE `accounts` SET `pOnline` = NOW() WHERE `pID` = '%d' LIMIT 1",PI[playerid][pID]);
	mysql_pquery(connects, query, "", "");

	if(TI[playerid][tSelectedBusinessID] <= 0) {
		new 
			Float: LastPosX,
			Float: LastPosY,
			Float: LastPosZ,
			Float: LastPosR;
		
		GetPlayerPos(playerid, LastPosX, LastPosY, LastPosZ);
		GetPlayerFacingAngle(playerid, LastPosR);

		format(query, 231, "UPDATE `"TABLE_ACCOUNTS"` SET `pLastPosX` = '%f', `pLastPosY` = '%f', `pLastPosZ` = '%f', `pLastPosR` = '%f', `pLastWorld` = '%i', `pLastInt` = '%i' WHERE `pID` = '%d'", 
		LastPosX, LastPosY, LastPosZ, LastPosR, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), PI[playerid][pID]);

		mysql_tquery(connects, query, "", "");
	}
	
	if(PI[playerid][pAdmin] > 0 && dostup[playerid] == 1 || gAdmin[playerid][7] == 1) {
		new saturday = 1310155200, w = gettime(), day_week;
		while(w - saturday > 60 * 60 * 24) {
			w -= 60 * 60 * 24;
			day_week ++;
		}
		while(day_week >= 7) day_week -= 7;
		static const Names_Days[7][22] = {"online_saturday","online_sunday","online_monday","online_tuesday","online_wednesday","online_thursday","online_friday"};

		query = "";
		format(query,sizeof(query),"UPDATE `admin` SET `%s` = '%d', `kick` = '%d', `ban` = '%d', `mute` = '%d', `pm` = '%d', `warn` = '%d', `jail` = '%d',`vig`='%d',`blockadmin`='%d',`rep`='%d',online_status = '0' WHERE `Name` = '%s' LIMIT 1",Names_Days[day_week], gAdminTime[playerid],gAdmin[playerid][0],gAdmin[playerid][1],gAdmin[playerid][2],gAdmin[playerid][3],gAdmin[playerid][4],gAdmin[playerid][5],gAdmin[playerid][6],gAdmin[playerid][7],gAdmin[playerid][8],player_name[playerid]);
		mysql_pquery(connects, query, "", "");

		format(string, sizeof(string), "[A] «"G" %s отключился от сервера",player_name[playerid]);
		if(gAdmin[playerid][7] != 1) SendAdminMessage(COLOR_SERVER, string);
		dostup[playerid] = 0;
	}
	if(IsValid3DTextLabel(gPlayerBusText[playerid])) DestroyDynamic3DTextLabelEx(gPlayerBusText[playerid]);
	if(PlayerMehText[playerid] != Text3D:-1) {
		DestroyDynamic3DTextLabel(PlayerMehText[playerid]);
		PlayerMehText[playerid] = Text3D:-1;
	}
	if(PlayerEatText[playerid] != Text3D:-1) {
		DestroyDynamic3DTextLabel(PlayerEatText[playerid]);
		PlayerEatText[playerid] = Text3D:-1;
	}
	if(GetPVarInt(playerid,"veh_id_cleaner")) EndGazon(playerid);
	if(GetPVarInt(playerid,"clear_id")) EndClear(playerid);
	if(GetPVarInt(playerid,"bus_id")) EndBus(playerid);
	if(TI[playerid][tJobSad][0]) EndSad(playerid);
	if(TI[playerid][tJobOil][0]) EndOil(playerid);
	if(TI[playerid][tJobGun][0]) EndGun(playerid);
	if(TI[playerid][tJobLoader][0]) EndLoader(playerid);
	if(TI[playerid][tJobMine][0]) EndMine(playerid);
	if(GetPVarInt(playerid,"track_id")) EndTrack(playerid);
	if(GetPVarInt(playerid,"mehjob")) EndMeh(playerid);
	if(GetPVarInt(playerid,"eatjob")) EndEat(playerid);
	if(gPlayerProdText[playerid] != Text3D:-1) {
		DestroyDynamic3DTextLabel(gPlayerProdText[playerid]);
		gPlayerProdText[playerid] = Text3D:-1;
	}
	if(gPlayerProdCP[playerid] != -1) DestroyDynamicCP(gPlayerProdCP[playerid]);

	if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) {
		A_DestroyVehicle(TK_Trailer[playerid]);
		TK_Trailer[playerid] = INVALID_VEHICLE_ID;
	}
	if(GetPVarInt(playerid, "Templeader"))
	{
		PI[playerid][pLeader] = 0;
		PI[playerid][pMember] = 0;
		PI[playerid][pRank] = 0;
		start_work[playerid] = 0;
	}
	SaveAccount(playerid);

	if(IsAMafia(playerid) && BizWarTime > 0) for(new i; i < 8; i++) TextDrawHideForPlayer(playerid,Bizwar[i]);
 	if(IsAGang(playerid) && zahvat) for(new i; i < 7; i++) TextDrawHideForPlayer(playerid, ghettotablica_TD[i]);

	PI[playerid][pAdmin] = 0;
	PI[playerid][pYoutube] = 0;
	score_number[playerid] = 0;
	TI[playerid][tLogin] = false;
	TI[playerid][tSpawn] = false;
	TI[playerid][tJoined] = false;
	TI[playerid][tSelectSkin] = false;

    mysql_format(connects,query,sizeof(query), "UPDATE `"TABLE_ACCOUNTS"` SET `online_status` = '1001' WHERE pID = '%d'",PI[playerid][pID]);
 	mysql_tquery(connects,query, "", "");

	PI[playerid][pPhone] = 0;

	if(gOnlinePlayer[playerid][0] > 1) {
		format(query,256,"SELECT * FROM online_player WHERE date >= CURDATE() AND accountid = %d",PI[playerid][pID]);
		new Cache:result = mysql_query(connects, query);
		new rows = cache_num_rows();
		if(!rows) {
			format(query,256, "INSERT INTO online_player (accountid,date,online_sec,afk_sec) VALUES (%d, CURDATE(), %d, %d)", PI[playerid][pID], gOnlinePlayer[playerid][0], gOnlinePlayerAFK[playerid][0]);
			mysql_tquery(connects,query);
		}
		else {
			format(query,256,"UPDATE online_player SET online_sec = %d, afk_sec = %d WHERE accountid = %d AND date >= CURDATE()", gOnlinePlayer[playerid][0], gOnlinePlayerAFK[playerid][0], PI[playerid][pID]);
			mysql_tquery(connects,query);
		}
		cache_delete(result);
	}
	return true;
}
public OnPlayerDeath(playerid, killerid, reason) {
    DelGun(playerid);
	DisablePlayerCheckpoint(playerid);

	DeletePVar(playerid, "SettingGraffiti");

	if(GetPVarInt(playerid,"ChangingSkin")) {
		A_SetPlayerSkin(playerid, GetPVarInt(playerid, "curskin"));
		cancel_skin(playerid);
	}

	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);

	TI[playerid][tMasked] = 0;
	DeletePVar(playerid,"carrygun");
	DeletePVar(playerid,"use_mats");
	DeletePVar(playerid,"takephone");
	DeletePVar(playerid,"takeradio");


	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicleAC(playerid);

	if(GetPVarInt(playerid,"adchecking_fix")) {
		gAdvert[GetPVarInt(playerid,"adchecking_fix")-1][adCheking]=false;
		DeletePVar(playerid,"adchecking_fix");
	}
	if(GotoInfo[playerid][gtGoID]!=INVALID_PLAYER_ID) CheckPlayerGoCuff(playerid);
	if(GotoInfo[playerid][gtID]!=INVALID_PLAYER_ID) {
	    TI[GotoInfo[playerid][gtID]][tCuffed] = false;
		TI[GotoInfo[playerid][gtID]][tCuffedTime] = 0;
		TogglePlayerControllable(GotoInfo[playerid][gtID],true);
		SetPlayerSpecialAction(GotoInfo[playerid][gtID], 0);
	    ClearAnims(GotoInfo[playerid][gtID]);
     	SendOk(GotoInfo[playerid][gtID],"Вы были выпущены с конвоя");
        CheckPlayerGoCuff(GotoInfo[playerid][gtID]);
        CheckPlayerGoCuff(playerid);
	}
	if(p_mh[playerid]!=PlayerText:-1) {
		PlayerTextDrawHide(playerid,p_mh[playerid]);
		PlayerTextDrawDestroy(playerid,p_mh[playerid]);
		p_mh[playerid]=PlayerText:-1;
	}
	if(thefttime[playerid] != 0) { // угон
		SendOk(playerid,"Вы провалили задание, ваш навык угона понижен.");
		DestroyDynamicArea(theftarea[playerid][0]);
		DisablePlayerCheckpoint(playerid);
		DestroyDynamicCP(theftCheck[playerid][0]);
		A_DestroyVehicle(theftIDveh[playerid][0]);
		theftIDveh[playerid][0] = INVALID_VEHICLE_ID;
		if(theftveh[playerid][0] != INVALID_VEHICLE_ID) {
			A_DestroyVehicle(theftveh[playerid][0]);
			theftveh[playerid][0] = INVALID_VEHICLE_ID;
		}
		if(theftplayer[theftIDveh[playerid][1]][0] != 1010) theftplayer[theftIDveh[playerid][1]][0] = 1010;
		theftplayer[playerid][1] = 0;
		theftCheck[playerid][1] = 0;
		PlayerTextDrawHide(playerid, theft_PTD[playerid][0]);
		thefttime[playerid] = 0;
		if(PI[playerid][ptheftExp] == 0) {
			if(PI[playerid][ptheftSkill] != 0) PI[playerid][ptheftSkill]--, UpdatePlayerData(playerid,"theftSkill",PI[playerid][ptheftSkill]);
			PI[playerid][ptheftExp] = TheftSkillMax[PI[playerid][ptheftSkill]]-1, UpdatePlayerData(playerid,"theftExp",PI[playerid][ptheftExp]);
		}
		else {
			if(PI[playerid][ptheftExp] != 0) PI[playerid][ptheftExp]--, UpdatePlayerData(playerid,"theftExp",PI[playerid][ptheftExp]);
		}
	}
	if(killerid != INVALID_PLAYER_ID) {
		if(TI[killerid][tDMArea][0] && TI[playerid][tDMArea][0]) {
			new Float:health;
			TI[killerid][tDMArea][1]++;
			TI[playerid][tDMArea][2]++;
			GetPlayerHealth(killerid,health);
			if(health + 25 > 100) SetPlayerHealth(killerid,100);
			else SetPlayerHealth(killerid,health+25);
			new string[156];
			format(string,sizeof(string),"{1bd12f}Убийств:{ffffff}%d\n{1bd12f}Смертей:{ffffff}%d",TI[playerid][tDMArea][1],TI[playerid][tDMArea][2]);
			UpdateDynamic3DTextLabelText(DMSTATUS[playerid],0xFF6347FF,string);

			format(string,sizeof(string),"{1bd12f}Убийств:{ffffff}%d\n{1bd12f}Смертей:{ffffff}%d",TI[killerid][tDMArea][1],TI[killerid][tDMArea][2]);
			UpdateDynamic3DTextLabelText(DMSTATUS[killerid],0xFF6347FF,string);
		}
		if(TI[killerid][tGunArea][0] && TI[playerid][tGunArea][0]) {
			new Float:health;
			TI[killerid][tGunArea][1]++;
			TI[playerid][tGunArea][2]++;
			GetPlayerHealth(killerid,health);
			if(health + 25 > 100) SetPlayerHealth(killerid,100);
			else SetPlayerHealth(killerid,health+25);
			switch(TI[killerid][tGunArea][1])
			{
				case 3: DelGun(killerid), AC_GivePlayerWeapon(killerid, ArenaGun[4], 5000),TI[killerid][tGunArea][3] = 2,TI[killerid][tGunArea][1] = 0;
				case 6: DelGun(killerid), AC_GivePlayerWeapon(killerid, ArenaGun[3], 5000),TI[killerid][tGunArea][3] = 3,TI[killerid][tGunArea][1] = 0;
				case 9: DelGun(killerid), AC_GivePlayerWeapon(killerid, ArenaGun[2], 5000),TI[killerid][tGunArea][3] = 4,TI[killerid][tGunArea][1] = 0;
				case 12: DelGun(killerid), AC_GivePlayerWeapon(killerid, ArenaGun[1], 5000),TI[killerid][tGunArea][3] = 5,TI[killerid][tGunArea][1] = 0;
				case 15: DelGun(killerid), AC_GivePlayerWeapon(killerid, ArenaGun[0], 5000),TI[killerid][tGunArea][3] = 6,TI[killerid][tGunArea][1] = 0;
				case 18:
				{
					new string[100];
				    format(string, sizeof(string), "Победителем Гонки Вооружений стал - "W"%s",player_name[killerid]);
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!TI[i][tGunArea][0]) continue;
						SendClientMessage(i,CGOLD,string);
					}
					new query[128];
					format(query,sizeof(query), "UPDATE `"TABLE_ACCOUNTS"` SET pWinArea = pWinArea + 1 WHERE pID = '%d'",PI[killerid][pID]);
					mysql_tquery(connects,query,"","");
				    ResetGunsArena();
				}
			}
			new string[128];
			format(string,sizeof(string),"{1bd12f}Kills Gun:{ffffff}%d/3\n{1bd12f}Guns:{ffffff}%d/6",TI[playerid][tGunArea][1],TI[playerid][tGunArea][3]);
			UpdateDynamic3DTextLabelText(DMSTATUS[playerid],0xFF6347FF,string);

			format(string,sizeof(string),"{1bd12f}Kills Gun:{ffffff}%d/3\n{1bd12f}Guns:{ffffff}%d/6",TI[killerid][tGunArea][1],TI[killerid][tGunArea][3]);
			UpdateDynamic3DTextLabelText(DMSTATUS[killerid],0xFF6347FF,string);
		}
		if(!IsACop(killerid) && !IsAArm(killerid) && IsAGang(playerid) != IsAGang(killerid) && IsAMafia(playerid) != IsAMafia(killerid) && !TI[killerid][tDMArea][0] && !TI[killerid][tGunArea][0] && !TI[killerid][tGym] && !player_to_golod[killerid] && !player_to_game[killerid] && TI[killerid][tDuel] == -1) {
			PI[killerid][pZakonp] --;
			if(PI[killerid][pZakonp] < -100) PI[killerid][pZakonp] = -100;
			UpdatePlayerData(killerid,"pZakonp",PI[killerid][pZakonp]);
			SetPlayerCriminal(killerid,"Неизвестный", "Убийство человека");
			if(PI[killerid][pSearch] < 2) {
				PI[killerid][pSearch] = 2;
				ANDROID_SetPlayerWantedLevel(killerid,PI[killerid][pSearch]);
				new string[156];
				format(string,sizeof(string),"[Внимание] %s объявлен(а) в розыск. Обвинитель: неизвестно. Причина: убийство",player_name[killerid]);
				SendTeamMessage(CDEPARTMENT,string);

				format(string,sizeof(string),"Вы объявлены в розыск. Причина: убийство. Уровень: %d",PI[killerid][pSearch]);
				SendClientMessage(killerid,CBADINFO,string);
			}
		}
		if(game_start == 1 && player_to_game[playerid] == 1 && player_to_game[killerid] == 1) {
			kills_player_game[killerid]++;
			new string[128];
			mysql_format(connects, string, sizeof(string),"UPDATE `dm_arena` SET `kills_dm` = '%d' WHERE `Name` = '%e'", kills_player_game[killerid], player_name[killerid]);
			mysql_tquery(connects, string, "", "");
		}
		if(!TI[playerid][tDMArea][0] && !TI[playerid][tGunArea][0] && !TI[killerid][tGym] && !player_to_game[playerid]) {
			if(PI[playerid][pSearch] > 0) {
				if(IsACop(killerid)) {
					new search,src = PI[playerid][pSearch];
					if(PI[playerid][pSearch] <= 5) search = 600;
					else search = 750;
					arrest(playerid);

					static const f_str_1[] = "Вы были посажены в тюрьму офицером %s на %d секунд";
					new string_1[sizeof(f_str_1)  +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];

					format(string_1,sizeof(string_1),f_str_1,player_name[killerid],(src * search));
					SendClientMessage(playerid,COLOR_LIGHTRED,string_1);

					static const f_str_2[] = "Вы посадили в тюрьму преступника %s на %d секунд";
					new string_2[sizeof(f_str_2) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];

					format(string_2,sizeof(string_2),f_str_2,player_name[playerid],(src * search));
					SendClientMessage(killerid,COLOR_LIGHTRED,string_2);
				}
			}
		}
	}
	new bool:spawn = false;
	if(IsAGang(killerid) && IsAGang(playerid) && GetPlayerVirtualWorld(playerid) == 0) {
		for(new i = 0; i < TOTALGZ; i++) {
			if(GZInfo[i][ZoneOnBattle] == 1) {
				if(PI[killerid][pMember] != PI[playerid][pMember]) {
					if(PI[killerid][pMember] == GZInfo[i][gNapad] || PI[killerid][pMember] == GZInfo[i][gFrakVlad]) {
						if(PI[playerid][pMember] == GZInfo[i][gNapad] || PI[playerid][pMember] == GZInfo[i][gFrakVlad]) {
							SendDead(PI[killerid][pMember],PI[playerid][pMember],killerid,playerid,reason);
							CountOnZone[PI[killerid][pMember]]++;
							SetPVarInt(killerid,"killed_shot",GetPVarInt(killerid,"killed_shot")+1);
							if(PI[killerid][pFamily]) reputation_family(PI[killerid][pFamily]-1,1);
							if(PI[playerid][pFamily]) reputation_family(PI[playerid][pFamily]-1,-1);
							GameTextForPlayer(killerid, "~r~+Kill", 5000, 6);
							//if(PI[killerid][pMember]) add_gang_points(PI[killerid][pMember],1);
							break;
						}
					}
				}
			}
		}
	}
	if(BizWarTime > 0 && killerid != INVALID_PLAYER_ID) {

		if(PI[killerid][pMember] != PI[playerid][pMember]) {
			if(PI[killerid][pMember] == MZInfo[bNapad] || PI[killerid][pMember] == MZInfo[bFrakVlad]) {
				if(PI[playerid][pMember] == MZInfo[bNapad] || PI[playerid][pMember] == MZInfo[bFrakVlad]) {
					if(PlayerToKvadrat(killerid, bizwar_coordinates[0], bizwar_coordinates[1], bizwar_coordinates[2], bizwar_coordinates[3]) && PlayerToKvadrat(playerid, bizwar_coordinates[0], bizwar_coordinates[1], bizwar_coordinates[2], bizwar_coordinates[3])) {
						SendDead(PI[killerid][pMember],PI[playerid][pMember],killerid,playerid,reason);
						MZInfo[bCountDead][PI[killerid][pMember]]++;
		    			new string[50];
						if(PI[killerid][pMember] == MZInfo[bNapad])
						{

						    foreach(new m:Player)
						    {
						        if(!TI[m][tLogin] || AntiCheatIsKickedWithDecync(m)) continue;
						        if(MZInfo[bFrakVlad]!=PI[m][pMember] && MZInfo[bNapad]!=PI[m][pMember]) continue;

								TextDrawHideForPlayer(m, Bizwar[7]);
								format(string,11,"%d",MZInfo[bCountDead][PI[killerid][pMember]]);
								TextDrawSetString(Bizwar[7],string);
								TextDrawShowForPlayer(m, Bizwar[7]);
							}
						}
						else
						{

		    				foreach(new m:Player)
						    {
		        				if(!TI[m][tLogin] || AntiCheatIsKickedWithDecync(m)) continue;
						        if(MZInfo[bFrakVlad]!=PI[m][pMember] && MZInfo[bNapad]!=PI[m][pMember]) continue;

						       	TextDrawHideForPlayer(m, Bizwar[5]);
								format(string,11,"%d",MZInfo[bCountDead][PI[killerid][pMember]]);
								TextDrawSetString(Bizwar[5],string);
								TextDrawShowForPlayer(m, Bizwar[5]);
							}
						}

						SetPVarInt(killerid,"m_killed_shot",GetPVarInt(killerid,"m_killed_shot") + 1);
						if(PI[killerid][pFamily]) reputation_family(PI[killerid][pFamily]-1,1);
						if(PI[playerid][pFamily]) reputation_family(PI[playerid][pFamily]-1,-1);
					}
				}
			}
		}
	}
	if(IsAArm(killerid)) {
		if(IsAGang(playerid) || IsAMafia(playerid)) {
		    if(PlayerToKvadrat(killerid, -1544.892, 270.5747, -1232.015, 558.557) || PlayerToKvadrat(killerid, -49.979476, 1695.982177, 414.020507, 2175.982177)) {
		        if(PlayerToKvadrat(playerid, -1544.892, 270.5747, -1232.015, 558.557) || PlayerToKvadrat(playerid, -49.979476, 1695.982177, 414.020507, 2175.982177)) {
		            GiveMoney(killerid,500,"Убийство бандита на территории армии");
				}
			}
		}
	}
	if(IsAGang(killerid) || IsACop(killerid) || IsAArm(killerid)) {
		if(invent_zone_id != -1) {
 			if(PlayerToKvadrat(playerid,invent_place[invent_zone_id][0], invent_place[invent_zone_id][1],invent_place[invent_zone_id][2],invent_place[invent_zone_id][3])) {
	 			if((IsACop(playerid) || IsAArm(playerid)) && IsAGang(killerid)) {
	 				GiveMoney(killerid,1500,"Убийство госника на территории корабля");
	 				//if(PI[killerid][pMember]) add_gang_points(PI[killerid][pMember],2);
	 			}
	 			else if(IsAGang(playerid) && (IsACop(killerid) || IsAArm(killerid))) {
	 				GiveMoney(killerid,3000,"Убийство бандита на территории корабля");
	 			}
	 		}
 		}
	}
 	if(IsAGang(killerid) && killerid != INVALID_PLAYER_ID) {
 		if(IsAArm(playerid) && start_work[playerid]) {
			for(new i = 0; i < TOTALGZ; i++) {
				if(PlayerToKvadrat(playerid,GZInfo[i][gCoords][0], GZInfo[i][gCoords][1],GZInfo[i][gCoords][2],GZInfo[i][gCoords][3])) {
					if(GetPlayerSkin(playerid) != 252 || PI[playerid][pFracSkin] != 252) {
						if(!PI[killerid][pArmSkin]) {
							PI[playerid][pFracSkin] = 252;
							SendOk(playerid, "Вы потеряли армейскую форму");
							SendOk(killerid, "Вы cняли с армейца форму, введите /dress, чтобы переодеться");
							PI[killerid][pZakonp] -= 2;
							if(PI[killerid][pZakonp] < -100) PI[killerid][pZakonp] = -100;
							PI[killerid][pArmSkin] = 1;
							UpdatePlayerData(killerid,"ArmSkin",1);
						}
					}
				}
			}
		}
	}
	TI[playerid][tMaskTime] = 0;
	TI[playerid][tTazers][0] = 0;

	if(!PI[playerid][pAdmin] && !TI[playerid][tDMArea][0] && !TI[playerid][tGunArea][0] && !TI[playerid][tGym] && !player_to_game[playerid] && !player_to_golod[playerid] && !IsAGang(playerid) && PI[playerid][pVips] != VIP_ECSCLUSIVE) SetPlayerHospital(playerid,spawn);
	//else SetPlayerHealth(playerid,100);
	foreach(new i:adminsCount) {
		if(PI[i][pAdmKL] && !IsAGang(i)) {
			SendDeathMessageToPlayer(i, killerid, playerid, reason);
		}
	}
	SettingSpawn(playerid);
	return true;
}
public OnPlayerSpawn(playerid) {
	printf("%s[%d] was spawned | OnPlayerSpawn", player_name[playerid], playerid); // debug

	leave_robhouse(playerid);
	DeletePVar(playerid,"carrygun");
	DeletePVar(playerid, "SettingGraffiti");
	TI[playerid][tProcess][0] = -1;
	TI[playerid][tProcess][1] = -1;
    SetPlayerSkills(playerid);
	SetPlayerColor(playerid,0xFFFFFF11);
	TI[playerid][tSpawn] = true;
	if(!TI[playerid][tLogin] || !TI[playerid][tJoined]) return 1;
	if(TI[playerid][tClothesWork][0]) {
		for(new i = 0;i < 5;i++) {
			TextDrawHideForPlayer(playerid,work_td_global[i]);
		}
		PlayerTextDrawDestroy(playerid, work_td_local[playerid][0]);
	}
	if(GetTeamID(playerid) == 0) start_work[playerid] = 0;
	if(IsAGang(playerid) && IsAMafia(playerid)) start_work[playerid] = 1;
	if(PI[playerid][pMember] && start_work[playerid]) {
		A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
		SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
	}
	else A_SetPlayerSkin(playerid,PI[playerid][pSkin]);

	if(GetPlayerHP(playerid) < 10) SetPlayerHealth(playerid, 10);
	else SetPlayerHealth(playerid, GetPlayerHP(playerid));

	if(IsAGang(playerid)) {
		SetPlayerHealth(playerid, 95);
		AC_GivePlayerWeapon(playerid,5, 1);
	}

	if(TI[playerid][tLogin] == true) {
		for(new i; i < 10 ; i ++) {
			if(GunPlayer[playerid][i][0] == 0 || GunPlayer[playerid][i][1] == 0) continue;
			AC_GivePlayerWeapon(playerid,GunPlayer[playerid][i][0], GunPlayer[playerid][i][1]);
		}
		if(PI[playerid][pSearch] >= 1) ANDROID_SetPlayerWantedLevel(playerid,PI[playerid][pSearch]);
	}
	switch(PI[playerid][pSettings][5]) {
	    case 0: SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
	    case 1: SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
	    case 2: SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
	    case 3: SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
	}
	if(GotoInfo[playerid][gtGoID] != INVALID_PLAYER_ID) CheckPlayerGoCuff(playerid);
	if(GotoInfo[playerid][gtID] != INVALID_PLAYER_ID) {
	    TI[GotoInfo[playerid][gtID]][tCuffed] = false;
		TI[GotoInfo[playerid][gtID]][tCuffedTime] = 0;
		TogglePlayerControllable(GotoInfo[playerid][gtID],true);
		SetPlayerSpecialAction(GotoInfo[playerid][gtID], 0);
	    ClearAnims(GotoInfo[playerid][gtID]);
     	SendOk(GotoInfo[playerid][gtID],"Вы были выпущены с конвоя");
        CheckPlayerGoCuff(GotoInfo[playerid][gtID]);
        CheckPlayerGoCuff(playerid);
	}
	else if(player_to_race_lv[playerid]) {
		new random_spawn = random(sizeof spawns_pos_game_end);
		SetPlayerPosAC(playerid, spawns_pos_game_end[random_spawn][0],spawns_pos_game_end[random_spawn][1],spawns_pos_game_end[random_spawn][2],200,3);
		SetPlayerFacingAngle(playerid, spawns_pos_game_end[random_spawn][4]);
		return 1;
	}
	else if(player_to_golod[playerid]) {
		players_in_golod--;
		new random_spawn = random(sizeof spawns_pos_game_end);
		SetPlayerPosAC(playerid, spawns_pos_game_end[random_spawn][0],spawns_pos_game_end[random_spawn][1],spawns_pos_game_end[random_spawn][2],200,3);
		SetPlayerFacingAngle(playerid, spawns_pos_game_end[random_spawn][4]);
		golod_deatch(playerid,players_in_golod);
		return 1;
	}
	else if(TI[playerid][tDuel] != -1) {
		end_duel(playerid,0);
		return 1;
	}
	SetPlayerPosAC(playerid, setX[playerid], setY[playerid], setZ[playerid], TI[playerid][tVirtualWorld], TI[playerid][tInterior], true);
	if(spaned[playerid]==0) ReloadAllAnims(playerid);
	//SettingSpawn(playerid);
	return true;
}
public OnPlayerPickUpPickup(playerid, pickupid) {
	return 1;
}
public OnPlayerPickUpDynamicPickup(playerid, pickupid) {
	if(!TI[playerid][tLogin]) return 1;
	if(pickupid == oldpickup[playerid]) return true;
	oldpickup[playerid] = pickupid;
	timepickup[playerid] = 3;
	new Float:zx;
	GetPlayerPos(playerid, PickupX[playerid], PickupY[playerid], zx);
	if(pickupid >= pickups_game_dm[0] && pickupid <= pickups_game_dm[13]) return SetPlayerHealth(playerid,100);

	else if(golod_start) {
		for(new id; id <= 20; id++) {
			if(pickups_game_golod[id] == -1) continue;
			if(pickupid == pickups_game_golod[id]) {
				if(golod_use_pickup[playerid]) return ErrorMessage(playerid,"Вы уже брали начальный пикап");
				DestroyDynamicPickup(pickups_game_golod[id]);
				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);
				pickups_game_golod[id] = -1;
				golod_use_pickup[playerid] = 1;
				return 1;
			}
		}
		for(new id; id <= 20; id++) {
			if(pickups_game_golod_2[id] == -1) continue;
			if(pickupid == pickups_game_golod_2[id]) {
				DestroyDynamicPickup(pickups_game_golod_2[id]);
				pickups_game_golod_2[id] = -1;
				new random_weapon = random(sizeof weapon_id_game);
				new random_ammo = Random(10,35);
				AC_GivePlayerWeapon(playerid, weapon_id_game[random_weapon], random_ammo);
				return 1;
			}
		}
	}
	else if(pickupid == fork_pickup) {
		fork_pickups = 0;
		DestroyDynamicPickup(fork_pickup);
		TI[playerid][tAlcotraz][2] = 1;
		D(playerid,DIALOG_NONE,DSM, ""P"Побег",""W"Мысли...\n\nТак-так, вилка..\nИнтересно, где ее можно использовать..\nМожет попробовать открыть что-то..","Закрыть","");
		return 1;
	}
	else if(g_arena_created) {
		for(new blockid; blockid < 64; blockid++) {
			if(pickupid == b_pickupid[blockid]) return OnPlayerCaptureBlock(playerid, blockid);
		}
	}
	else if(pickupid == election) {
		if(PI[playerid][pLevel] < 3) return ErrorMessage(playerid,"Голосовать можно с 3 уровня");
		if(PI[playerid][pGolos]) return ErrorMessage(playerid,"Вы уже голосовали");
		new string[54 * MAX_VOTES];
		for(new i = 0; i < MAX_VOTES; i++) {
			if(strlen(vote_name[i])) {
				format(string,sizeof(string), "%s%i. %s (Голосов: %i)\n", string, i+1, vote_name[i],vote_count[i]);
			}
			else format(string,sizeof(string),"%s%i. -\n",string, i+1);
		}
		return D(playerid,D_ELECTION_2,DSL,""P"Список кандидатов",string,"Выбрать","Закрыть");
	}
	return true;
}
public OnPlayerSelectedMenuRow(playerid, row) {
	if(TI[playerid][pAndroid]) return 1;
	new Menu:Current = GetPlayerMenu(playerid);
	if(Current == specmenu) {
		switch(row) {
			case 0: SpecPlayer(playerid,SERIU[playerid][sID]);
			case 1: return D(playerid,D_REC_KICK,DSI, ""P"KICK","\n\n"W"Введите причину, по которой хотите кикнуть игрока с сервера:\n\n","Кикнуть","Отмена"),ShowMenuForPlayer(specmenu,playerid);
			//case 2: return D(playerid,D_REC_WARN,DSI, ""P"WARN","\n\n"W"Введите причину, по которой хотите выдать Warn игроку:\n\n","Варн","Отмена"),ShowMenuForPlayer(specmenu,playerid);
			case 3: return D(playerid,D_REC_BAN,DSI, ""P"BAN","\n\n"W"Введите причину, по которой хотите заблокировать аккаунт игроку:\n"NO"ВНИМАНИЕ!"W" Введите время и причину через запятую без пробелов (15,читер)\nВремя блокировки аккаунта: от 7 до 30 дней\n\n","Бан","Отмена"),ShowMenuForPlayer(specmenu,playerid);
			case 4: {
				new stm[11];
				format(stm,10,"%d",SERIU[playerid][sID]);
				callcmd::slap(playerid,stm);
				// ShowMenuForPlayer(specmenu,playerid);
				return 1;
			}
			// case 5: return ShowStats(playerid,SERIU[playerid][sID],1),ShowMenuForPlayer(specmenu,playerid);//stats
			case 6: {
				for(new plid = SERIU[playerid][sID]+1; plid<MAX_PLAYERS; plid++) {
					if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
					SERIU[playerid][sID]=plid;
					SpecPlayer(playerid,SERIU[playerid][sID]);
					return 1;
				}
				for(new plid; plid<=SERIU[playerid][sID]; plid++) {
					if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
					SERIU[playerid][sID]=plid;
					SpecPlayer(playerid,SERIU[playerid][sID]);
					return 1;
				}
				return 1;
			}
			case 7:  {
				for(new plid = SERIU[playerid][sID]-1; plid>=0; plid--) {
					if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
					SERIU[playerid][sID]=plid;
					SpecPlayer(playerid,SERIU[playerid][sID]);
					return 1;
				}
				for(new plid=MAX_PLAYERS-1; plid>=SERIU[playerid][sID]; plid--) {
					if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
					SERIU[playerid][sID]=plid;
					SpecPlayer(playerid,SERIU[playerid][sID]);
					return 1;
				}
				return 1;
			}
			case 8: Lastspec[playerid] = SERIU[playerid][sID],callcmd::reoff(playerid,"");//exit
		}
	}
	return true;
}
public OnPlayerExitedMenu(playerid) {
	if(TI[playerid][pAndroid]) return 1;
	if(!IsValidMenu(GetPlayerMenu(playerid))) return true;
	// ShowMenuForPlayer(GetPlayerMenu(playerid), playerid);
	TogglePlayerControllable(playerid,0);
	return true;
}
public OnPlayerStateChange(playerid, newstate, oldstate) {
	if(newstate == PLAYER_STATE_PASSENGER && (GetPlayerWeapon( playerid ) == 24 || GetPlayerWeapon( playerid ) == 25)) SetPlayerArmedWeapon(playerid, 0);
	if(!ac_1{playerid} && newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_NONE) return Kick(playerid),printf("%d",55555);
	if(newstate == oldstate) return Kick(playerid),printf("%d","333333");

	if(newstate == PLAYER_STATE_DRIVER) {
		LastVeh[playerid] = GetPlayerVehicleID(playerid);
		new tr = GetVehicleTrailer(LastVeh[playerid]);
		if(tr != 0) VehTrailer[playerid] = tr;
	}
	if(oldstate == PLAYER_STATE_DRIVER) {
		if(speed_timer[playerid] != -1) {
			KillTimer(speed_timer[playerid]);
			speed_timer[playerid] = -1;
		}
		if(GetPVarInt(playerid, "speedometr_show") == 1)
		{
			for(new j; j < 13; j++) TextDrawHideForPlayer(playerid, SPEEDOMETR_GLOBAL[j]);
			for(new k; k < 7; k++) PlayerTextDrawHide(playerid, SPEEDOMETR_LOCAL[playerid][k]);
			SetPVarInt(playerid, "speedometr_show", 0);
		}

		else if(GetPVarInt(playerid, "speedometr_show") == 2) {
			for(new q; q < 8; q++) PlayerTextDrawHide(playerid, fspeed[playerid][q]);
			SetPVarInt(playerid, "speedometr_show", 0);
		}

		LastVeh[playerid] = INVALID_VEHICLE_ID;
		VehTrailer[playerid] = INVALID_VEHICLE_ID;

		if(player_to_race_lv[playerid] == 1) {
			A_DestroyVehicle(player_car_race_lv_id[playerid]);
			player_car_race_lv_id[playerid] = INVALID_VEHICLE_ID;
			DisablePlayerRaceCheckpoint(playerid);
			player_to_race_lv[playerid] = 0;
			for(new t; t != 6; t++) TextDrawHideForPlayer(playerid, td_game[t]);
			new random_spawn = random(sizeof spawns_pos_game_end);
			SetPlayerPosAC(playerid, spawns_pos_game_end[random_spawn][0],spawns_pos_game_end[random_spawn][1],spawns_pos_game_end[random_spawn][2],200,3);
			SetPlayerFacingAngle(playerid, spawns_pos_game_end[random_spawn][4]);
			ErrorMessage(playerid,"Вы вышли из автомобиля и были дисквалифицированы с гонки");
		}
		if(theftveh[playerid][0] != INVALID_VEHICLE_ID && theftveh[playerid][2] == 1){ //угон
			theftveh[playerid][1] = 120;
			PlayerTextDrawShow(playerid, theft_PTD[playerid][1]);
		}
		if(TI[playerid][tRaceID] != INVALID_VEHICLE_ID) srace_end(playerid,2);
	}
	if((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && newstate == PLAYER_STATE_WASTED) {
		new vid = GetPlayerVehicleID(playerid);
		if(vid) {
			new Float:x, Float:y, Float:z;
			GetVehiclePos(vid, x, y, z),
			SetPlayerPosAC(playerid, x, y, z,TI[playerid][tVirtualWorld], TI[playerid][tInterior]);
		}
	}
	if(newstate == PLAYER_STATE_DRIVER) {
	    new carid = GetPlayerVehicleID(playerid);
		if(VehicleInfo[carid][vFuel] <= 0.0 && IsADriveVehicle(carid)) {
			ErrorMessage(playerid, "В транспорте закончилось топливо");
			VehicleInfo[carid][vFuel] = 0;
		}
		if(IsAVelik(carid)) {
			GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(carid,true,lights,alarm,doors,bonnet,boot,objective);
		}
		if(CarLic(carid) && !GetPVarInt(playerid, "WaitExam")) {
			if(lic[playerid][0] == 0) {
				ErrorMessage(playerid,"У Вас нет водительских прав");
				return RemovePlayerFromVehicleAC(playerid);
			}
		}
		if(IsABoat(carid)) {
			if(TI[playerid][tAutoSchool] == 3) return 1;
			if(VehicleInfo[carid][vType] == VEHICLE_TYPE_ALCATRAZ) return 1;
			if(lic[playerid][2] < 1) {
				ErrorMessage(playerid, "У Вас нет лицензии на водный транспорт");
				RemovePlayerFromVehicleAC(playerid);
				return true;
			}
		}
		if(IsAPlane(carid)) {
			if(TI[playerid][tAutoSchool] == 2) return 1;
			if(lic[playerid][1] < 1) {
				ErrorMessage(playerid,"У Вас нет лицензии на воздушный транспорт");
				RemovePlayerFromVehicleAC(playerid);
				return true;
			}
		}
		if(IsAPlane(carid) || IsABoat(carid)) SendClientMessage(playerid,COLOR_GREY, "Завести/заглушить двигатель, используйте: "P"/en");
  		if(IsADriveVehicle(carid)) {
			SendClientMessage(playerid, COLOR_GREY, "Для того чтобы завести/заглушить, нажмите кнопку "P"\"CTRL\""G"");
			SendClientMessage(playerid, COLOR_GREY, "Для включения фар "P"\"ALT\"");
			SendClientMessage(playerid, COLOR_GREY, "Установка ограничения скорости: "P"\"/slimit\"");
			update_speedometer(playerid);
			speed_timer[playerid] = SetTimerEx("update_speedometer", 300, true, "i",playerid);
			GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);

			if(!TI[playerid][pAndroid]) {
				for(new i; i < 13; i++) TextDrawShowForPlayer(playerid, SPEEDOMETR_GLOBAL[i]);
				for (new i; i < 7; i++) PlayerTextDrawShow(playerid, SPEEDOMETR_LOCAL[playerid][i]);
				SetPVarInt(playerid, "speedometr_show", 1);
			}
			else 
			{
				for (new i; i < 8; i++) PlayerTextDrawShow(playerid, fspeed[playerid][i]);
				SetPVarInt(playerid, "speedometr_show", 2);
			}
			/*
			for(new i; i < 73; i++) {
				if(i == 10) {
					if(engine) PlayerTextDrawColor(playerid, speedometr_playerid[playerid][10], 8388863);
					else PlayerTextDrawColor(playerid, speedometr_playerid[playerid][10], -16776961);
				}
				if(i == 11) {
					if(lights) PlayerTextDrawColor(playerid, speedometr_playerid[playerid][11], 8388863);
					else PlayerTextDrawColor(playerid, speedometr_playerid[playerid][11], -16776961);
				}
				if(i == 15) {
					if(doors) PlayerTextDrawColor(playerid, speedometr_playerid[playerid][15], -16776961);
					else PlayerTextDrawColor(playerid, speedometr_playerid[playerid][15], 8388863);
				}
				PlayerTextDrawShow(playerid, speedometr_playerid[playerid][i]);
			}*/
		}
		if(theftveh[playerid][0] == GetPlayerVehicleID(playerid)){ //угон
			theftveh[playerid][1] = 0;
			theftveh[playerid][2] = 1;
			PlayerTextDrawHide(playerid, theft_PTD[playerid][1]);
		}
		if(TI[playerid][tJobOil][0] && TI[playerid][tJobOil][1] && GetVehicleModel(carid) != 530) {
			SendOk(playerid,"Вы уронили бочку");
			ClearAnimations(playerid);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
			SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
			SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);
			TI[playerid][tJobOil][1] = false;
		}
		if(GetVehicleModel(carid) == 433) {
		    static const f_str[] = "Загружено боеприпасов: "W"%d/40"G" ящиков";
		    new string[sizeof(f_str) +4];

			format(string,sizeof(string),f_str,VG[carid][vgAmount][0]);
			SendOk(playerid,string);
			if(PI[playerid][pMember] == fARMYLV) {
				SendOk(playerid,"Для загрузки/разгрузки боеприпасов введите: "W"/load | /unload");
				SendOk(playerid,"Для транспортировки боеприпасов на склады фракций: "W"/carm");
			}
			if(PI[playerid][pMember] == fARMYSF) SendOk(playerid,"Используйте: "W"/carm");
			if(IsAGang(playerid)) SendOk(playerid,"Для загрузки боеприпасов введите: "W"/load");
		}
		if(GetVehicleModel(carid) == 548) {
		    static const f_str[] = "Загружено боеприпасов: "W"%d";
		    new string[sizeof(f_str) +7];

			format(string,sizeof(string),f_str,VG[carid][vgAmount][0]);
			SendOk(playerid,string);
			SendOk(playerid,"Используйте: "W"/carm");
		}
		if(GetPVarInt(playerid,"WaitExam") && GetVehicleModel(carid) == 426) {
			new slot = GetPVarInt(playerid,"LessonSlot");
			if(!slot) SetPlayerRaceCheckpoint(playerid, 0, AutoCP[slot][0], AutoCP[slot][1], AutoCP[slot][2], AutoCP[slot+1][0], AutoCP[slot+1][1], AutoCP[slot+1][2], 3.0);
			else SetPlayerRaceCheckpoint(playerid, 0, AutoCP[slot - 1][0], AutoCP[slot - 1][1], AutoCP[slot - 1][2], AutoCP[slot][0], AutoCP[slot][1], AutoCP[slot][2], 3.0);

			GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(carid,engine,lights,alarm,1,bonnet,boot,objective);
			return 1;
		}
		if(VehicleInfo[carid][vTeam] != 0) {
			if(GetTeamID(playerid) != VehicleInfo[carid][vTeam] && (!IsAGang(playerid) || GetPlayerSkin(playerid) != 191) && (!IsAGang(playerid) || GetPlayerSkin(playerid) != 287)) {
				ErrorMessage(playerid, "У Вас нет ключей");
				RemovePlayerFromVehicleAC(playerid);
				return false;
			}
			if(!start_work[playerid]) {
		        ErrorMessage(playerid, "Служебный транспорт Вам недоступен");
	   			RemovePlayerFromVehicleAC(playerid);
				return false;
			}
			else {
			    if(PI[playerid][pRank] < VehicleInfo[carid][vRank]) {
			        ErrorMessage(playerid, "Недоступно для Вашего ранга");
					RemovePlayerFromVehicleAC(playerid);
			    }
			}
		}
		if(VG[carid][vgLoading] || VG[carid][vgUnloading]) {
			if(!IsAGang(playerid) && !IsAMafia(playerid) && !IsAArm(playerid)) {
				ErrorMessage(playerid,"Данный транспорт доступен только: бандам/мафиям/армиям");
				return RemovePlayerFromVehicleAC(playerid);
			}
			return D(playerid,D_STOP_LOAD,DSM, ""P"Погрузка","\n\n"W"Вы хотите прекратить загрузку/разгрузку боеприпасов?\n\n","Да","Нет");

		}
		if(VG[carid][vgRobHouse]) D(playerid,D_STOP_LOAD_ROBHOUSE,DSM, ""P"Погрузка","\n\n"W"Вы хотите прекратить загрузку награбленной техники?\n\n","Да","Нет");
		/*if(VehicleInfo[carid][vType] == VEHICLE_TYPE_SPAWN) {
			if(PI[playerid][pLevel] > 1) {
				ErrorMessage(playerid,"Данный транспорт только для новичков (1 уровень)");
				return RemovePlayerFromVehicleAC(playerid);
			}
		}*/
		if(VehicleInfo[carid][vType] == VEHICLE_TYPE_INVENT) {
			if(!IsAGang(playerid) && !IsAMafia(playerid) && !IsAArm(playerid)) {
				ErrorMessage(playerid,"Данный транспорт доступен только: бандам/мафиям/армиям");
				return RemovePlayerFromVehicleAC(playerid);
			}
			SendOk(playerid,"Для загрузки/разгрузки боеприпасов введите: "W"/load | /unload");
		}
		if(VehicleInfo[carid][vType] == VEHICLE_TYPE_RENT_NEWBIE) {
			if(TI[playerid][tArendaCar] != carid) return ErrorMessage(playerid, "Этот транспорт арендуется другим человеком");
		}
	    if(VehicleInfo[carid][vJob] > 0 && GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) {
		    switch(VehicleInfo[carid][vJob]) {
				case 1: {
					if((VehicleInfo[carid][vPlayer] !=-1 ) && VehicleInfo[carid][vPlayer] != playerid) return ErrorMessage(playerid,"Транспорт арендован другим игроком"),RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] != VehicleInfo[carid][vJob]) return ErrorMessage(playerid,"Вы не работаете водителем автобуса"), RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] == VehicleInfo[carid][vJob] && TI[playerid][tArendaCar] != carid) {
						if(TI[playerid][tArendaCar] != -1) {
							ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт");
							return RemovePlayerFromVehicleAC(playerid);
						}
						if(GetPlayerMoneyEx(playerid) < BUS_PRICE_RENT) {
							ErrorMessage(playerid,"Для аренды автобуса необходимо $500");
							return RemovePlayerFromVehicleAC(playerid);
						}
						new string[128];
						format(string, sizeof(string), ""W"Вы хотите арендовать этот автобус за "GREEN"$%i"W"?",BUS_PRICE_RENT);
						D(playerid,dBusRent,DSM, ""P"Аренда",string,"Да","Нет");
					}
					TI[playerid][tSpcarTime] = 0;
				}
				case 2: {
					if((VehicleInfo[carid][vPlayer] != -1) && VehicleInfo[carid][vPlayer] != playerid) return ErrorMessage(playerid,"Транспорт арендован другим игроком"),RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] != VehicleInfo[carid][vJob]) return ErrorMessage(playerid,"Вы не работаете механиком"), RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] == VehicleInfo[carid][vJob] && TI[playerid][tArendaCar] != carid) {
						if(TI[playerid][tArendaCar] != -1) {
							ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт");
							return RemovePlayerFromVehicleAC(playerid);
						}
						new string[128];
						format(string, sizeof(string), ""W"Вы хотите арендовать буксир за "GREEN"$%i"W"?",500);
						D(playerid,D_BUKSIR,DSM, ""P"Аренда",string,"Да","Нет");
					}
					TI[playerid][tSpcarTime] = 0;
				}
				case 3: {
					if((VehicleInfo[carid][vPlayer] != -1) && VehicleInfo[carid][vPlayer] != playerid) return ErrorMessage(playerid,"Транспорт арендован другим игроком"),RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] != VehicleInfo[carid][vJob]) return ErrorMessage(playerid,"Вы не работаете развозчиком продуктов/топлива"), RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] == VehicleInfo[carid][vJob] && TI[playerid][tArendaCar] != carid) {
						if(TI[playerid][tArendaCar] != -1) {
							ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт, для отказа используйте /unrent");
							return RemovePlayerFromVehicleAC(playerid);
						}
						static const fmt_str[] = ""W"Вы хотите арендовать авто для развозки продуктов/топлива за "GREEN"$%i"W"?";
						new string_dialog[sizeof(fmt_str) + (-2 + 4)];

						format(string_dialog, sizeof(string_dialog), fmt_str, 500);
						D(playerid,dProdRent,DSM, ""P"Аренда",string_dialog,"Да","Нет");
					}
					TI[playerid][tSpcarTime] = 0;
				}
				case 4: {
					if((VehicleInfo[carid][vPlayer] != -1) && VehicleInfo[carid][vPlayer] != playerid) return ErrorMessage(playerid,"Транспорт арендован другим игроком"),RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] != VehicleInfo[carid][vJob]) return ErrorMessage(playerid,"Вы не работаете развозчиком еды"), RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] == VehicleInfo[carid][vJob] && TI[playerid][tArendaCar] != carid) {
						if(TI[playerid][tArendaCar] != -1) {
							ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт");
							return RemovePlayerFromVehicleAC(playerid);
						}
						new string[128];
						format(string, sizeof(string), ""W"Вы хотите арендовать авто для развозки еды за "GREEN"$%i"W"?",500);
						D(playerid,dEatRent,DSM, ""P"Аренда",string,"Да","Нет");
					}
					TI[playerid][tSpcarTime] = 0;
				}
				case 5: {
					if((VehicleInfo[carid][vPlayer] != -1) && VehicleInfo[carid][vPlayer] != playerid) return ErrorMessage(playerid,"Транспорт арендован другим игроком"),
					RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] != VehicleInfo[carid][vJob]) return ErrorMessage(playerid,"Вы не работаете мойщиком"), RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] == VehicleInfo[carid][vJob] && TI[playerid][tArendaCar] != carid) {
						if(TI[playerid][tArendaCar] != -1) {
							ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт");
							return RemovePlayerFromVehicleAC(playerid);
						}
						if(GetPlayerMoneyEx(playerid) < 500) {
							ErrorMessage(playerid,"Для аренды рабочего транспорта необходимо $500");
							return RemovePlayerFromVehicleAC(playerid);
						}
						new string[124];
						format(string,sizeof(string),""W"Вы хотите арендовать авто для мойки улиц за "GREEN"$%i"W"?\n\nСостояние дорог: "P"%s",500,condition_of_roads[condition_of_roads_]);
						D(playerid,D_JOB_CLEAR,DSM, ""P"Аренда",string,"Да","Нет");
					}
					TI[playerid][tSpcarTime] = 0;
				}
				case 6: {
					if((VehicleInfo[carid][vPlayer] != -1) && VehicleInfo[carid][vPlayer] != playerid) return ErrorMessage(playerid,"Транспорт арендован другим игроком"),RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] != VehicleInfo[carid][vJob]) return ErrorMessage(playerid,"Вы не работаете газонокосильщиком"), RemovePlayerFromVehicleAC(playerid);
					if(PI[playerid][pJob] == VehicleInfo[carid][vJob] && TI[playerid][tArendaCar] != carid) {
						if(TI[playerid][tArendaCar] != -1) {
							ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт");
							return RemovePlayerFromVehicleAC(playerid);
						}
						if(GetPlayerMoneyEx(playerid) < 500) {
							ErrorMessage(playerid,"Для аренды рабочего транспорта необходимо $500");
							return RemovePlayerFromVehicleAC(playerid);
						}
						new string[128];
						format(string, sizeof(string), ""W"Вы хотите арендовать авто для скашивания травы за "GREEN"$%i"W"?",500);
						D(playerid,D_JOB_GAZON,DSM, ""P"Аренда",string,"Да","Нет");
					}
					TI[playerid][tSpcarTime] = 0;
				}
				case 50: {
					if(!TI[playerid][tJobOil][0]) return RemovePlayerFromVehicleAC(playerid), ErrorMessage(playerid,"Вы не начали работу на нефтезаводе");
					if(PI[playerid][pProgress] < 150) return RemovePlayerFromVehicleAC(playerid),ErrorMessage(playerid,"Уровень мастерства мал. Введите: /progress");
					if((VehicleInfo[carid][vPlayer]!=-1) && VehicleInfo[carid][vPlayer] != playerid) return RemovePlayerFromVehicleAC(playerid),ErrorMessage(playerid,"Транспорт занят другим игроком");
					if(GetPVarInt(playerid,"track_id") != 0 && GetPVarInt(playerid,"track_id") != carid) {
						ErrorMessage(playerid,"Вы уже арендуете рабочий транспорт");
						return RemovePlayerFromVehicleAC(playerid);
					}
					DisablePlayerRaceCheckpoint(playerid);

					SetPlayerMapIcon(playerid,1,525.7095,1470.6411,4.0315,11,-1,MAPICON_GLOBAL);
					SetPlayerMapIcon(playerid,2,481.0192,1308.8954,9.3572,11,-1,MAPICON_GLOBAL);
					TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
					SetPVarInt(playerid,"track_id",carid);
					TI[playerid][tSpcarTime] = 0;
				}
				case 70: {
					if(!GetPVarInt(playerid,"fish_yes")) return ErrorMessage(playerid,"У Вас нет билета для ловли рыбы. Купить его можно в рыболовном магазине"),RemovePlayerFromVehicleAC(playerid);
					SendOk(playerid,"Для ловили рыбы отправляйтесь в указанный квадрат на карте");
					SendOk(playerid,"Используй команду - "W"/fish");
					if(!GetPVarInt(playerid,"fish_place")) {
						new rand = random(sizeof(fish_place));
						GangZoneShowForPlayer(playerid,fish_zone[rand],COLOR_RED);
						SetPVarInt(playerid,"fish_place",rand+1);
					}
				}
				case 71: {
					if(!TI[playerid][tAlcotraz][0]) return ErrorMessage(playerid,"Лодка доступна только для побега с алькатраса"),RemovePlayerFromVehicleAC(playerid);
					D(playerid,DIALOG_NONE,DSM, ""P"Побег",""W"Мысли...\n\nВот я и в лодке..\nГлавно не свалиться в воду, иначе замерзну и меня быстро поймают..\nВремени в обрез..\nЯ близок к свободе...","Закрыть","");
					EnableGPSForPlayer(playerid, -2412.9822,2314.3362,0.3909);
				}
		        case 99: {
					for(new i = 1; i <= gPlaneCount; i++) {
						if(carid == gAirplanes[i][aCar]) {
							if(GetString(gAirplanes[i][aOwner],"State")) {
								SetPVarInt(playerid,"SelectPlane", gAirplanes[i][aID]);
								static const f_str[] = ""W"Стоимость аренды данного воздушного транспорта: "GREEN"$%d"W"\n\
								Вы действительно хотите взять под аренду воздушный транспорт на 10 дней?";
								new string[sizeof(f_str) +1 + 11];
								format(string,sizeof(string),f_str,gAirs[gAirplanes[i][aAirport]-1][airCoast] * gAirplanes[i][aPrice]);
								return D(playerid,D_ARENDA,DSM, ""P"Аренда",string,"Аренда","Отмена");
							}
							else {
								if(GetString(gAirplanes[i][aOwner],player_name[playerid])) return SendOk(playerid,"Для отказа от аренды, введите: "W"/norent");
								else if(!GetString(player_name[playerid],gAirplanes[i][aOwner])) {
									ErrorMessage(playerid, "Вы не арендуете данный самолёт");
									return RemovePlayerFromVehicleAC(playerid);
								}
							}
						}
					}
				}
			}
		}
		if(GetVehicleModel(carid) == 426 && !GetPVarInt(playerid,"WaitExam"))
		{
			ErrorMessage(playerid,"Данный транспорт предназначен для прохождения экзаменов");
			return RemovePlayerFromVehicleAC(playerid);
		}
	}
	else if(newstate == PLAYER_STATE_PASSENGER) {
		new carid = GetPlayerVehicleID(playerid);
	    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);

	    if(doors == 1) return RemovePlayerFromVehicleAC(playerid);

		if(VehicleInfo[carid][vJob] == 1 && VehicleInfo[carid][vPlayer] != -1) {
			/* new 
				payerID =
				driverID = INVALID_PLAYER_ID;

			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(GetPlayerVehicleID(i) != carid) continue;
				if(GetPlayerMoneyEx(playerid) < 100) {
					MeAction(playerid,"показал(а) проездной водителю");
					return 1;
				}
				if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
					driverID = i;
				} else {
					payerID = i;
				}
				break;
			} */
			if(GetPlayerMoneyEx(playerid) < 100) {
				MeAction(playerid,"показал(а) проездной водителю");
				return 1;
			}
			GiveMoney(playerid,-gRoutePrice[VehicleInfo[carid][vPlayer]],"оплата за проезд автобус");
			GiveMoney(VehicleInfo[carid][vPlayer],gRoutePrice[VehicleInfo[carid][vPlayer]],"зарплата за проезд автобус");
		}
		if(VehicleInfo[carid][vBizz] > 0 && VehicleInfo[carid][vBizz] < 5)
		{
			new
				string_message[26 + MAX_PLAYER_NAME];

			format(string_message, sizeof(string_message), "Игрок %s сел к вам в такси.", player_name[playerid]);
			for(new i = 0; i < 20; i++)
			{
				if(carid == FuncBizz[VehicleInfo[carid][vBizz]][funcbCars][i])
				{
					SetPVarInt(playerid, "taxidriver", FuncBizz[VehicleInfo[carid][vBizz]][funcbCarID][i]);
				}
			}
			SendOk(GetPVarInt(playerid, "taxidriver"), string_message);

			return D(playerid, D_TAXI_WAYCHOICE, DSL, "Такси", "1. Выбрать из доступных пунктов в GPS\n2. Отметить точку на карте\n3. Договориться с водителем", "Выбор", "Отмена" );
		}
		if(TI[playerid][tJobOil][0] && TI[playerid][tJobOil][1] && GetVehicleModel(carid) != 530) {
			SendOk(playerid,"Вы уронили бочку");
			ClearAnimations(playerid);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
			SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
			SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);
			TI[playerid][tJobOil][1] = false;
		}
	}
	else if(newstate == PLAYER_STATE_ONFOOT) {
		if(speed_timer[playerid] != -1) {
			KillTimer(speed_timer[playerid]);
			speed_timer[playerid] = -1;
		}
		if(GetPVarInt(playerid, "repairoffee") && PI[playerid][pJob] == 2) { // fix бага на вирты /repair
			new player_id = GetPVarInt(playerid, "repairoffee");
			
			DeletePVar(playerid,"repairoffee");
			if(IsPlayerConnected(player_id)) {
				SetPVarInt(player_id,"repairoffee",-1);
				SetPVarInt(player_id,"repairoffer",-1);
				DeletePVar(player_id,"repairprice");
			}
			new string_message[34 + MAX_PLAYER_NAME];
			format(string_message, sizeof(string_message), "Механик %s отозвал своё предложение", player_name[playerid]);

			SCM(player_id, COLOR_ADVANCEORANGE, string_message);
		}

		if(TI[playerid][tJobOil][0]) {
			SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
			SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);
		}
		if(TI[playerid][tEther]) {
			TI[playerid][tEther] = false;
			SendOk(playerid,"Вы вышли из прямого эфира");
		}
	}
	return true;
}
public OnPlayerExitVehicle(playerid, vehicleid) {
	if(VehicleInfo[vehicleid][vBizz] && VehicleInfo[vehicleid][vBizz] == PI[playerid][bizz_work]) {
		for(new i = 0; i < 20; i++) {
			if(vehicleid == FuncBizz[VehicleInfo[vehicleid][vBizz]][funcbCars][i]) FuncBizz[VehicleInfo[vehicleid][vBizz]][funcbCarID][i] = -1;
		}
	}
	if(GetPVarInt(playerid, "Patrul") == 1) {
		DeletePVar(playerid, "Patrul");
		KillTimer(time_wanted[playerid]);
		DisablePlayerCheckpoint(playerid);
		SendOk(playerid,"Вы закончили патрулирование");
		return 1;
	}
	if(vehicleid == car_autoschool[playerid]) {
		RemovePlayerFromVehicleAC(playerid);
		SetPlayerPosAC(playerid,GetPVarFloat(playerid,"pos_x_autos"),GetPVarFloat(playerid,"pos_y_autos"),GetPVarFloat(playerid,"pos_z_autos"),45,3);
		A_DestroyVehicle(car_autoschool[playerid]);
		car_autoschool[playerid] = INVALID_VEHICLE_ID;
		DisablePlayerRaceCheckpoint(playerid);
		ErrorMessage(playerid,"Экзамен завален");
		TI[playerid][tAutoSchool] = 0;
		DeletePVar(playerid,"LessonSlotMav");
		DeletePVar(playerid,"LessonSlotBoat");
	}
	if(VG[vehicleid][vgAmount][0]) {
		VG[vehicleid][vgAmount][0] = 0;
	}
	if(GetPVarInt(playerid,"bus_id") == vehicleid) {
		TI[playerid][tSpcarTime] = 60;
		SendOk(playerid, "У Вас есть 60 секунд чтобы вернуться в автобус");
	}
	if(GetPVarInt(playerid,"track_id") == vehicleid) {
		TI[playerid][tSpcarTime] = 60;
		SendOk(playerid, "У Вас есть 60 секунд чтобы вернуться в погрузчик");
	}
	if(GetPVarInt(playerid,"mehjob") == vehicleid) {
		TI[playerid][tSpcarTime] = 60;
		SendOk(playerid, "У Вас есть 60 секунд чтобы вернуться в буксир");
	}
	if(GetPVarInt(playerid,"eatjob") == vehicleid) {
		TI[playerid][tSpcarTime] = 60;
		SendOk(playerid, "У Вас есть 60 секунд чтобы вернуться в автомобиль для продажи еды");
	}
	if(GetPVarInt(playerid,"clear_id") == vehicleid) {
		TI[playerid][tSpcarTime] = 60;
		SendOk(playerid, "У Вас есть 60 секунд чтобы вернуться в автомобиль для чистки улиц");
	}
	if(GetPVarInt(playerid,"veh_id_cleaner") == vehicleid) {
		TI[playerid][tSpcarTime] = 60;
		SendOk(playerid, "У Вас есть 60 секунд чтобы вернуться в автомобиль для скашивания травы");
	}
	return true;
}
public OnPlayerRequestSpawn(playerid) {
    if(!TI[playerid][tLogin]) {
	    ErrorMessage(playerid, "Для игры на нашем сервере введите пароль");
	    Kick(playerid);
	    return false;
	}
	return false;
}
public OnPlayerRequestClass(playerid, classid) {

	SetSpawnInfo(playerid, 255, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0);
    if(TI[playerid][tLogin]) {
		SetTimerEx("PlayerSpawn", 200, false, "i", playerid);
		
		for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
		return false;
	}
	else if(!PI[playerid][pID]) {
		TI[playerid][tJoined] = true;
		ac_1{playerid} = true;
		new query[137];
		format(query,sizeof query,"SELECT `pID`, `pKey`, `pKeyip`, `pEmail`, `pEmailStatus`, `pvIp` FROM `accounts` WHERE `Name` = '%s' LIMIT 1",player_name[playerid]);
		mysql_tquery(connects, query, "OnPlayerRequestDetect", "d", playerid);

	}
	return true;
}
public OnPlayerText(playerid, text[]) {
    if(!TI[playerid][tLogin]) return 0;
	new string[150];
	if(PI[playerid][pMute] > 0) {
		ErrorMessage(playerid, "У Вас бан чата");
		SetPlayerChatBubble(playerid, "пытается что-то сказать", COLOR_REDD, 30.0, 10000);
		return 0;
	}
	if(TI[playerid][tGag]) {
		ErrorMessage(playerid, "У Вас кляп");
		SetPlayerChatBubble(playerid, "пытается что-то сказать", COLOR_REDD, 30.0, 10000);
		return 0;
	}
    // if(CountFloodForPlayer[playerid] >= 2) {
	// 	ErrorMessage(playerid, "Пожалуйста, не флудите");
	// 	return 0;
	// }
	CountFloodForPlayer[playerid]++;
	if(TI[playerid][tEther]) {
		format(string,sizeof(string),"[%s] %s: %s",FI[PI[playerid][pMember]][fName],player_name[playerid],text);
		foreach(new i:Player) {
			if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
			if(PI[i][pSettings][2] != PI[playerid][pMember]) continue;
			SendClientMessage(i,0xFF9900AA,string);
		}
		return 0;
	}
	if(TI[playerid][tPhoneNews]) {
		for(new i; i<sizeof(calls_ether); i++) {
			if(calls_ether[i] == playerid && calls_news[i]) {
				new mes[128];
				format(mes,sizeof(mes),"[%s] %s [тел.]: %s",FI[PI[calls_news[i]][pMember]][fName],player_name[playerid],text);
				new subid = PI[calls_news[i]][pMember];
				foreach(new r:Player) {
					if(!TI[r][tLogin] || AntiCheatIsKickedWithDecync(r)) continue;
					if(PI[r][pSettings][2] == subid || r == playerid) SendClientMessage(r, 0xFF9900AA, mes);
				}
				return false;
			}
		}
	}
	if(TI[playerid][tPhone] == true) {
		new id,mes[128];
		if(TI[playerid][tPhoneCaller] == playerid) id = TI[playerid][tPhoneCalled];
		else if(TI[playerid][tPhoneCalled] == playerid) id = TI[playerid][tPhoneCaller];

		format(mes,sizeof(mes),"[тел] %s: %s",player_name[playerid], text);
		SendClientMessage(playerid, COLOR_YELLOW, mes);

		format(mes,sizeof(mes),"[тел] %s: %s",player_name[playerid], text);
		SendClientMessage(id, COLOR_YELLOW, mes);

		SetPlayerChatBubble(playerid, mes, COLOR_WHITE, 10.0, 10000);
		return false;
	}
	if(GetString(text,")")) {
		MeAction(playerid,"улыбается");
		return false;
	}
	if(GetString(text,"))")) {
		MeAction(playerid,"смеётся");
		return false;
	}
	if(GetString(text,"xD")) {
		MeAction(playerid,"хохочет во весь голос");
		return false;
	}
	if(GetString(text,"(")) {
		if(PI[playerid][pSex] == 1) MeAction(playerid,"расстроился");
		else MeAction(playerid,"расстроилась");
		return false;
	}
	if(GetString(text,"((")) {
		if(PI[playerid][pSex] == 1) MeAction(playerid,"сильно расстроился");
		else MeAction(playerid,"сильно расстроилась");
		return false;
	}
	if(GetString(text,":D")) {
		MeAction(playerid,"хохочет");
		return false;
	}
	if(GetString(text,"O_o")) 	{
		MeAction(playerid,"удивлен(а)");
		return false;
	}
	if(GetString(text,">_<")) {
		if(PI[playerid][pSex] == 1) MeAction(playerid,"сморщился от злости");
		else MeAction(playerid,"сморщилась от злости");
		return false;
	}
	if(GetString(text,";)")) {
		MeAction(playerid,"подмигивает");
		return false;
	}
	if(GetString(text, "q")) {
		if(GetPVarInt(playerid,"anti_sbiv_time") > unix) return 1;
		if(PI[playerid][pAdmin] >= 1) {
			MeAction(playerid,"показал(а) распальцовку {33AA33}Admins Team");
			ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,0,1);
			return false;
		}
		new member[20];
		switch(PI[playerid][pMember]) {
			case fBALLAS,fVAGOS,fGROVE,fAZTEC,fRIFA: {
				format(string,sizeof(string),"показал(а) распальцовку %s",member);
				MeAction(playerid,string);
				ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,0,0,0,1,1);
			}
			case fARMYSF,fARMYLV: {
				MeAction(playerid,"выполнил(а) воинское приветствие");
				ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P",4.0,0,0,0,0,1000,1);
			}
		}
		return false;
	}
	if(PI[playerid][pMember] == 0 || start_work[playerid] == 0) {
		format(string,sizeof(string),"- %s "W"(%s) [%d]",text,player_name[playerid],playerid);
	}
	else if(TI[playerid][tMasked]) {
		format(string,sizeof(string),"- %s {%s}(%s) [%d]",text,GetColorFrac(TI[playerid][tMasked]),player_name[playerid],playerid);
	}
	else if(TI[playerid][tMaskTime]) {
		format(string,sizeof(string),"- %s {7a7667}(%s) [%d]",text,player_name[playerid],playerid);
	}
	else {
		format(string,sizeof(string),"- %s {%s}(%s) [%d]",text,GetColor(playerid),player_name[playerid],playerid);
	}
	ProxDetector(25.0,playerid,string,-1);
	if(!TI[playerid][tTazer] && !TI[playerid][tCuffedTime] && GetPVarInt(playerid,"anti_sbiv_time") < unix && !TI[playerid][tTied] && !GetPVarInt(playerid,"Animation")) {
		if(PI[playerid][pSettings][4] == 0) {
			ApplyAnimation(playerid,"PED",Talk[PI[playerid][pSettings][4]],8.1,0,1,1,1,1,0);
			SetTimerEx("ClearAnim",100*strlen(text),false,"i",playerid);
		}
		else if(PI[playerid][pSettings][4] != 0) {
			ApplyAnimation(playerid,"GANGS",Talk[PI[playerid][pSettings][4]],4.1,1,1,1,1,1,1);
			SetTimerEx("ClearAnim",100*strlen(text),false,"i",playerid);
		}
	}
	SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20.0, 10000);
	return false;
}
public OnPlayerUpdate(playerid) {
    new tickcount1 = GetTickCount();
	if(!TI[playerid][tLogin] || AntiCheatIsKickedWithDecync(playerid)) return 0;
	//TI[playerid][tUpdate] = GetTickCount();
	TI[playerid][tAFK] = 0;
	time_update = GetTickCount() - tickcount1;
	if(time_update > time_update_max) time_update_max = time_update;
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(!TI[playerid][tLogin]) {
		return 1;
	}
	if(newkeys == KEY_WALK || (newkeys == 5120 && TI[playerid][pAndroid]))
	{
    	if(!IsPlayerInAnyVehicle(playerid)) {

/* 			new barrierid = IsObjectBarrier(playerid);
			if(barrierid != -1) CheckBarrier(playerid,barrierid); */
			if(!TI[playerid][tHeal])
			{
				for(new i = 0; i < 12; i++)
				{
					if(PlayerToPoint(1.7,playerid,med_heal[i][0],med_heal[i][1],med_heal[i][2]))
					{
						new Float: health;
						GetPlayerHealth(playerid,health);
						if(health >= 75) return ErrorMessage(playerid,"Вы не нуждаетесь в лечении");
						TI[playerid][tHeal] = true;
						SendOk(playerid, "Вы заняли койку, ожидайте оказания помощи от мед.работников");
						break;
					}
				}
			}
			else
			{
				TI[playerid][tHeal] = false;
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 1796.2955,-1934.6094,13.4182) || 
				IsPlayerInRangeOfPoint(playerid, 3.0, 1153.2728,-1734.2365,13.7734) || 
				IsPlayerInRangeOfPoint(playerid, 3.0, -105.3106,13.6186,3.1094) ||
				IsPlayerInRangeOfPoint(playerid, 3.0, 2672.5862,-2414.1428,13.6328) || 
				IsPlayerInRangeOfPoint(playerid, 3.0, 284.7523,1398.9626,10.5859) || 
				IsPlayerInRangeOfPoint(playerid, 3.0, 916.9587,-1204.4753,16.9832) ||
				IsPlayerInRangeOfPoint(playerid, 3.0, -507.2391,-1533.2319,10.3160) ||
				IsPlayerInRangeOfPoint(playerid, 3.0, -2055.5447,-85.0393,35.3203))
			{
				return ShowRentMenu(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.3, 2346.9180,-1245.6836,22.5000)) {//наркобот
				static const f_str[] = ""W"Укажите количество наркотиков для покупки:\n\n\
	                "O"Примечание:"W"\n\
	                \tСтоимость "P"1г"W" наркотиков: "GREEN"$%d"W"\n\
	                \tДоступно грамм на складе: "P"%d"W"\n\
					\tВ карман поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

	   			format(string,sizeof(string),f_str,black_prods[5],black_prods[1],vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs]);
				D(playerid,D_MARKET_NARKO,DSI, ""P"Покупка наркотиков", string, "Купить", "Отмена");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.3, 2347.5073,-1263.8671,22.5095)) {//армоур
				D(playerid,D_MARKET,DSL, ""P"Черный рынок", ""P"1."W" Бронежилет\n"P"2."W" Армейская форма", "Выбрать", "Отмена");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.3, 2327.8286,-1255.9642,22.5000)) {//материалы
				static const f_str[] = ""W"Укажите количество боеприпасов для покупки:\n\n\
	                "O"Примечание:"W"\n\
	                \tСтоимость "P"1"W" боеприпаса: "GREEN"$%d"W"\n\
	                \tДоступно боеприпасов на складе: "P"%d"W"\n\
					\tВ карман поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

	   			format(string,sizeof(string),f_str,black_prods[6],black_prods[2],vip_status[PI[playerid][pVips]][vip_mats]-PI[playerid][pMats]);
				D(playerid, D_MARKET_GUN, DSI, ""P"Покупка оружия",string, "Купить", "Отмена");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.3, 2324.0752,-1273.6428,22.5000)) {//бот скупка
				D(playerid,D_MARKET_BUY,DSL, ""P"Черный рынок [СКУПКА]", ""P"1."W" Бронежилет\n"P"2."W" Армейская форма\n"P"3."W" Наркотики\n"P"4."W" Материалы", "Выбрать", "Отмена");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.3, 2343.9939,-1314.1212,24.0606)) {
				if(PI[playerid][pLevel] < 3) return SendBotMessage(playerid,"Ты еще совсем мал, подработать можно с 3 лет в штате");
				if(!IsAGang(playerid)) return SendBotMessage(playerid,"Не на тот район зашёл, вали-ка отсюда");
				if(rob_veh[playerid] != INVALID_VEHICLE_ID) return SendBotMessage(playerid,"Ты уже брал тачку, вали-ка отсюда");
				D(playerid,D_ROB_CAR,DSM, ""P"Ограбление домов", "\n\n"W"Ты действительно хочешь грабить дома?\n\n", "Да", "Нет");
			}
			else if(IsAAlca(playerid) && maniken[playerid] != -1 && TI[playerid][tAlcotraz][2]) {
				TI[playerid][tAlcotraz][2] = 0;
				ApplyAnimation(playerid,"BOMBER","BOM_Plant_Loop",4.1, 1, 1, 1, 1, 0, 0);
				SetTimerEx("alcatraz_timer",10000,false,"i",playerid);
				return 1;
			}
	  		else if(IsAGang(playerid) && IsPlayerInDynamicArea(playerid,gAreas[arZavodSklad])) {
			    if(GetPVarInt(playerid,"carrygun")) return ErrorMessage(playerid,"У Вас уже есть ящик с боеприпасами");
				if(zavodsklad < 500) return ErrorMessage(playerid, "На складе недостаточно боеприпасов");
				if(!GetPVarInt(playerid,"carrygun")) {
					zavodsklad -= 500;
					SetPlayerFacingAngle(playerid,270.0);
					ClearAnimations(playerid);
					ApplyAnimation(playerid,"CARRY","liftup",1.0,0,1,1,0,0,1);
					SetTimerEx("CarryDelay",1000,false,"i",playerid);
					SetPlayerAttachedObject(playerid,1,2358,6,0.0,0.10,-0.2, -110.0,0.0,78.0);
					SetPVarInt(playerid,"carrygun",1);
				}
			}
	  		else if((IsAGang(playerid) || GetTeamID(playerid) == fARMYLV || IsAMafia(playerid)) && IsPlayerInDynamicArea(playerid,gAreas[arArmyLVSklad])) {
			    if(GetPVarInt(playerid,"carrygun")) return ErrorMessage(playerid,"У Вас уже есть ящик с боеприпасами");
				if(FI[fARMYLV][fMats] < 500) return ErrorMessage(playerid, "На складе недостаточно боеприпасов");
				if(!GetPVarInt(playerid,"carrygun")) {
					FI[fARMYLV][fMats] -= 500;
					SetPlayerFacingAngle(playerid,270.0);
					ClearAnimations(playerid);
					ApplyAnimation(playerid,"CARRY","liftup",1.0,0,1,1,0,0,1);
					SetTimerEx("CarryDelay",1000,false,"i",playerid);
					SetPlayerAttachedObject(playerid,1,2358,6,0.0,0.10,-0.2, -110.0,0.0,78.0);
					SetPVarInt(playerid,"carrygun",1);
					SetPVarInt(playerid,"use_mats",1);
				}
			}
			else if((IsAGang(playerid) || IsAMafia(playerid)) && IsPlayerInDynamicArea(playerid,gAreas[arArmySFSklad])) {
				if(GetPVarInt(playerid,"carrygun")) return ErrorMessage(playerid,"У Вас уже есть ящик с боеприпасами");
				if(FI[fARMYSF][fMats] < 500) return ErrorMessage(playerid, "На складе недостаточно боеприпасов");
				if(!GetPVarInt(playerid,"carrygun")) {
					FI[fARMYSF][fMats] -= 500;
					SetPlayerFacingAngle(playerid,270.0);
					ClearAnimations(playerid);
					ApplyAnimation(playerid,"CARRY","liftup",1.0,0,1,1,0,0,1);
					SetTimerEx("CarryDelay",1000,false,"i",playerid);
					SetPlayerAttachedObject(playerid,1,2358,6,0.0,0.10,-0.2, -110.0,0.0,78.0);
					SetPVarInt(playerid,"carrygun",1);
					SetPVarInt(playerid,"use_mats",2);
				}
			}
			else if(IsPlayerInRangeOfPoint(playerid, 1.7, 1050.3049,2313.1973,10.6818)) {
				if(!IsAMafia(playerid)) return ErrorMessage(playerid,"Вы не мафиози");
				static const f_str[] = ""W"Стоимость "P"10.000"W" боеприпасов: "GREEN"$%d"W"\n\
	                					Доступно боеприпасов на складе мафии: "P"%d"W"\n\n\
										"YELLOW"Вы действительно хотите купить "P"10.000"YELLOW" боеприпасов за "GREEN"$%d?";
				new string[sizeof(f_str) +1 + (-2 +6) + (-2 + 7) + (-2 + 7)];

	   			format(string,sizeof(string),f_str,50000,FI[GetTeamID(playerid)][fMats],50000);
				D(playerid, D_MATERIALS_BUY, DSM, ""P"Покупка боеприпасов",string, "Купить", "Отмена");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 1.7, 324.3706,1120.0488,1083.8828)) {
				if(!IsAMafia(playerid) && !IsAGang(playerid)) return ErrorMessage(playerid,"Вы не мафиози/бандит");
				static const f_str[] = ""W"Укажите количество наркотиков для покупки:\n\n\
	                "O"Примечание:"W"\n\
	                \tСтоимость "P"1г"W" наркотиков: "GREEN"$%d"W"\n\
					\tВ карман поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5)];

				format(string,sizeof(string),f_str,pricedrugs,vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs]);
				D(playerid,D_BUYNARKO,DSI, ""P"Покупка наркотиков", string, "Купить", "Отмена");
			}
			else if(PlayerToPoint(1.5,playerid,2425.8130,-2472.8911,13.6338)){ //угон
				if(theftCheck[playerid][1] != 3) return ErrorMessage(playerid, "Нужно сначала взять задание");
				if(PI[playerid][ptheftSkill] == 0) return ErrorMessage(playerid, "Доступно только со 2 уровня угона");
				if(theftveh[playerid][0] != INVALID_VEHICLE_ID) return ErrorMessage(playerid, "Вы уже получили машину");
				theftveh[playerid][1] = 120;
				PlayerTextDrawShow(playerid, theft_PTD[playerid][1]);
				new car;
				switch(PI[playerid][ptheftSkill]){
					case 1: car = 462;
					case 2: car = 509;
					case 3..25: car = 461;
				}
				switch (random(5)){
						case 0: theftveh[playerid][0] = A_CreateVehicle(car, 2422.7231,-2475.2529,13.2169,60.4655, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 1: theftveh[playerid][0] = A_CreateVehicle(car, 2421.5354,-2476.5518,13.2079,49.9015, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 2: theftveh[playerid][0] = A_CreateVehicle(car, 2420.4478,-2477.8716,13.2073,50.6490, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 3: theftveh[playerid][0] = A_CreateVehicle(car, 2419.2532,-2479.0793,13.2080,52.1076, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 4: theftveh[playerid][0] = A_CreateVehicle(car, 2418.3071,-2480.1309,13.2084,54.3323, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
				}
				if(car == 461) VehicleInfo[theftveh[playerid][0]][vFuel] = 50.0;
			}
			else if(PlayerToPoint(1.5,playerid,952.2404,2054.9951,10.8203)){ //угон
				if(theftCheck[playerid][1] != 3) return ErrorMessage(playerid, "Нужно сначала взять задание");
				if(PI[playerid][ptheftSkill] == 0) return ErrorMessage(playerid, "Доступно только со 2 уровня угона");
				if(theftveh[playerid][0] != INVALID_VEHICLE_ID) return ErrorMessage(playerid, "Вы уже получили машину");
				theftveh[playerid][1] = 120;
				PlayerTextDrawShow(playerid, theft_PTD[playerid][1]);
				new car;
				switch(PI[playerid][ptheftSkill]){
					case 1: car = 462;
					case 2: car = 509;
					case 3..25: car = 461;
				}
				switch (random(5)){
						case 0: theftveh[playerid][0] = A_CreateVehicle(car, 936.2581,2055.4512,10.3150,0.8911, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 1: theftveh[playerid][0] = A_CreateVehicle(car, 937.9734,2055.4656,10.3769,4.5768, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 2: theftveh[playerid][0] = A_CreateVehicle(car, 939.6783,2055.5396,10.3773,0.1772, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 3: theftveh[playerid][0] = A_CreateVehicle(car, 941.4130,2055.5398,10.3531,354.9440, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 4: theftveh[playerid][0] = A_CreateVehicle(car, 942.8529,2055.6968,10.3881,1.3770, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
				}
				if(car == 461) VehicleInfo[theftveh[playerid][0]][vFuel] = 50.0;
			}
			else if(PlayerToPoint(1.5,playerid,-2137.6365,-248.1024,36.5156)){ //угон
				if(theftCheck[playerid][1] != 3) return ErrorMessage(playerid, "Нужно сначала взять задание");
				if(PI[playerid][ptheftSkill] == 0) return ErrorMessage(playerid, "Доступно только со 2 уровня угона");
				if(theftveh[playerid][0] != INVALID_VEHICLE_ID) return ErrorMessage(playerid, "Вы уже получили машину");
				theftveh[playerid][1] = 120;
				PlayerTextDrawShow(playerid, theft_PTD[playerid][1]);
				new car;
				switch(PI[playerid][ptheftSkill]){
					case 1: car = 462;
					case 2: car = 509;
					case 3..25: car = 461;
				}
				switch (random(5)){
						case 0: theftveh[playerid][0] = A_CreateVehicle(car, -2135.4351,-251.4438,34.8944,266.1584, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 1: theftveh[playerid][0] = A_CreateVehicle(car, -2135.0457,-253.0109,34.9052,272.1158, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 2: theftveh[playerid][0] = A_CreateVehicle(car, -2135.1604,-254.5086,34.8624,270.5945, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 3: theftveh[playerid][0] = A_CreateVehicle(car, -2134.9924,-255.8532,34.9064,272.1504, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 4: theftveh[playerid][0] = A_CreateVehicle(car, -2135.0635,-257.1605,34.8368,271.0209, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
				}
				if(car == 461)VehicleInfo[theftveh[playerid][0]][vFuel] = 50.0;
			}
			else if(PlayerToPoint(1.5,playerid,2508.5442,-1471.2617,24.0337)){ //угон //коорды
				if(PI[playerid][ptheftSkill] < 15) {
					if(!IsAGang(playerid)) return ErrorMessage(playerid, "Ты не с нашего района!");
				}
				if(PI[playerid][ptheftTime] > gettime()) {
					new string[80];
					format(string,sizeof(string),"Пошел вон, ты слишком часто сюда приходишь, возвращайся через %02d:%02d", (PI[playerid][ptheftTime]-gettime())/60,(PI[playerid][ptheftTime]-gettime())%60);
					return ErrorMessage(playerid,string);
				}
				if(PI[playerid][ptheftSkill] == 0){
					if(thefttime[playerid] > 0) return ErrorMessage(playerid, "Вы уже начали задание, для отмены введите команду /theftcancel");
				 	D(playerid,D_THEFT,DSM, ""P"Угон транспорта",""W"Здарова, я James Sattora, наш общий знакомый сказал,\nчто ты не против заработать на нелегальной работенке.\nСуть моего задания в том, что я передаю на GPS координаты тачки, которая мне нужна.\nПеред тем, как берешься за работу, нужно купить в магазине отмычки.\nНичего сложного нет, крадешь тачку и получаешь - легкие деньги.\nБудешь браться за дело?","Да","Нет");
				}
				else {
					D(playerid,D_THEFT_LIST,DSL, ""P"Угон транспорта",""W"Взять задание\nВзять транспорт","Выбрать","Отмена");
				}
			}
			else if(PlayerToPoint(1.5,playerid,1774.2423,-1897.0193,13.5493) || PlayerToPoint(1.5,playerid,1153.8350,-1750.8284,13.5703)) {//квест спавн ждлс/вокзал/3 спавн

				new
					string[580],
					skr[124],
					num;

				string = ""P"Задание\t"P"Статус\n";

				DisablePlayerCheckpoint(playerid);
				for(new q; q < 11;q++)
			 	{
					new quest = q + 1;
					if(AcceptQuest[playerid][quest]==0) skr = "\t"GREEN"Доступно"W"";
					else if(QuestProgress[playerid][quest] == 100) skr = "\t"NO"Выполнено"W"";
					else if(QuestProgress[playerid][quest] == QI[quest][LastProgress] && AcceptQuest[playerid][quest]!=0) skr = "\t"ORANGE"Можно завершить"W"";
					else if(QuestProgress[playerid][quest] >= 0 && AcceptQuest[playerid][quest] != 0) skr = "\t"G"В процессе"W"";

					format(string,sizeof(string),"%s%s%s\n",string,QI[quest][QuestName],skr);
					QuestShow[playerid][num] = quest;
					num++;
				}
				D(playerid,D_QUEST,DSTH,"Квесты",string,"Выбрать","Отмена");
			}
			else if(PlayerToPoint(2.5,playerid,2235.8772,761.5479,1153.9510)) {//актер news
				if(!PI[playerid][pPhone]) return SendBotMessage(playerid,"У Вас нет мобильного телефона");
				new bool:online = false;
				foreach(new i:Player) {
					if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
					if(IsANews(i) && start_work[playerid]) continue;
					online = true;
					break;
				}
				if(!online) return ErrorMessage(playerid,"На сервере присутвутют редакторы. Отправьте объявление: /ad [текст]");
				D(playerid, D_AUTONEWS, DSL, ""P"Объявление",""P"1."W" Купить\n"P"2."W" Продать\n"P"3."W" Обменять\n"P"4."W" Услуги", "Выбрать", "Отмена");
				return 1;
			}
			else if(PlayerToPoint(1.5,playerid,1359.5322,1065.0143,1626.4896) && IsACop(playerid) && start_work[playerid]) {//пд вход в регистратуру
				SetPlayerPosAC(playerid,1357.0570,1068.3199,1626.4896,TI[playerid][tVirtualWorld], TI[playerid][tInterior]);
				SetPlayerFacingAngle(playerid,269.8491);
				SetCameraBehindPlayer(playerid);
			}
			else if(PlayerToPoint(1.5,playerid,1356.3823,1068.3185,1626.4896) && IsACop(playerid) && start_work[playerid]) {//пд вход в регистратуру
				SetPlayerPosAC(playerid,1360.2255,1065.2034,1626.4896,TI[playerid][tVirtualWorld], TI[playerid][tInterior]);
				SetPlayerFacingAngle(playerid,295.5193);
				SetCameraBehindPlayer(playerid);
			}
			else if(PlayerToPoint(2.0,playerid,2194.1531,-2279.8872,13.5469)) {
				if(!duels) return SendBotMessage(playerid,"Временно недоступно");
				if(!IsAGang(playerid) && !IsAMafia(playerid)) return SendBotMessage(playerid,"Вы не состоите в банде/мафии");
				D(playerid,D_DUEL,DSL,""P"Дуэли",""P"1."W" Доступные лобби\n"P"2."W" Создать лобби","Выбрать","Отмена");
			}
			else if(PlayerToPoint(1.5,playerid,1942.2025,-1117.6656,26.4455) || PlayerToPoint(1.5,playerid,2747.1582,-1180.8827,69.4016) ||
					PlayerToPoint(1.5,playerid,2498.2842,-1687.7340,13.5188) || PlayerToPoint(1.5,playerid,1669.6034,-2118.1514,13.5469) ||
					PlayerToPoint(1.5,playerid,2735.0513,-1949.6676,13.5394)) {//квест банды
				if((PlayerToPoint(1.5,playerid,1942.2025,-1117.6656,26.4455) && PI[playerid][pMember] != fBALLAS) || (PlayerToPoint(1.5,playerid,2747.1582,-1180.8827,69.4016) && PI[playerid][pMember] != fVAGOS) ||
					(PlayerToPoint(1.5,playerid,2498.2842,-1687.7340,13.5188) && PI[playerid][pMember] != fGROVE) || (PlayerToPoint(1.5,playerid,1669.6034,-2118.1514,13.5469) && PI[playerid][pMember] != fAZTEC) ||
					(PlayerToPoint(1.5,playerid,2735.0513,-1949.6676,13.5394) && PI[playerid][pMember] != fRIFA)) return SendBotMessage(playerid,"Не на тот район зашёл, вали-ка отсюда");
				new num,string[300 * 2];
				new skr[124];
				string = ""P"Задание\t"P"Статус\n";
				for(new i = 12;i<MAX_QUESTS;i++) {
				    new quest = i;
					if(AcceptQuest[playerid][quest]==0) skr = "\t"GREEN"Доступно"W"";
					else if(QuestProgress[playerid][quest] == 100) skr = "\t"NO"Выполнено"W"";
					else if(QuestProgress[playerid][quest] == QI[quest][LastProgress] && AcceptQuest[playerid][quest]!=0) skr = "\t"ORANGE"Можно завершить"W"";
					else if(QuestProgress[playerid][quest] >= 0 && AcceptQuest[playerid][quest] != 0) skr = "\t"G"В процессе"W"";

					format(string,sizeof(string),"%s%s%s\n",string,QI[quest][QuestName],skr);
					QuestShow[playerid][num] = quest;
					num++;
				}
				D(playerid,D_QUEST_GANG,DSTH,""P"Квесты",string,"Выбрать","Отмена");
			}
			else if(TI[playerid][tInHouse]) {
				new houseid = TI[playerid][tSelectHouse];
				new hint = gHouses[houseid][houseHint];
				new Float:x, Float:y, Float:z;
				x = hinterior_info[hint][h_pos_exit][0];
				y = hinterior_info[hint][h_pos_exit][1];
				z = hinterior_info[hint][h_pos_exit][2];
				if(IsPlayerInRangeOfPoint(playerid,2.0,x,y,z)) {
				    if(gHouses[houseid][houseImprove][0]) {
						callcmd::exit(playerid);
					}
					else ErrorMessage(playerid, "Улучшение 'Автоматические двери' не установлено (/exit)");
				}
			}
			else if(GetNearestATM(playerid) != -1) ShowATMMenu(playerid);
			else if(PI[playerid][pMember] == fFBI) {
				 for (new i = GetVehiclePoolSize() + 1; --i != 0;) {
					if(VehicleInfo[i][vTeam] == fFBI) {
						new Float:X,Float:Y,Float:Z;
						GetVehicleShiftPos(i,1,X,Y,Z,3.0);

						if(IsPlayerInRangeOfPoint(playerid,3,X,Y,Z)) {
							new string[45];
							SetPVarInt(playerid,"veh", i);
							string = "Название\tКОЛ-во"W"\n";
							format(string,sizeof(string), "%sЖучок\t{CFFF4D}1\n",string);
							D(playerid,D_TIPSTER,DSTH,"{ffff00}Багажник", string, "Взять", "Закрыть");
							GetVehicleParamsEx(i,engine,lights,alarm,doors,bonnet,boot,objective);
							SetVehicleParamsEx(i,engine,lights,alarm,doors,bonnet,true,objective);
							break;
						}
					}
				}
			}
			for (new i; i < sizeof(comp_club); i++) {
				if(PlayerToPoint(1.8, playerid, comp_club[i][0], comp_club[i][1], comp_club[i][2])) {
					if(GetPVarInt(playerid,"comp_game") <= unix) return ErrorMessage(playerid,"Купите билет для игры");
					D(playerid,D_COMP_GAME,DSL,""P"Game Menu",""P"1."W" Capture Blocks\n"P"2."W" DM - Арена\n"P"3."W" Гонка Вооружений", "Выбрать", "Закрыть");
					break;
				}
			}
			for(new i=0;i<MAX_DROP_GUNS;i++) {
				if(drop_gun[i][dg_object] == -1) continue;
				if(drop_gun[i][dg_time] < 1) continue;
				new Float:x, Float:y, Float:z;
				GetDynamicObjectPos(drop_gun[i][dg_object], x,y,z);
				if(!PlayerToPoint(1.5,playerid,x,y,z)) continue;
				DestroyDynamicObject(drop_gun[i][dg_object]);
				drop_gun[i][dg_object]=-1;
				if(drop_gun[i][dg_text] != Text3D:-1) {
					Delete3DTextLabel(drop_gun[i][dg_text]);
					drop_gun[i][dg_text] = Text3D:-1;
				}
				AC_GivePlayerWeapon(playerid ,drop_gun[i][dg_gun],drop_gun[i][dg_ammo]);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0,0);
				MeAction(playerid,"подобрал(а) оружие");
			}
	    }
	}
	if(TI[playerid][tTazer]) ApplyAnimation(playerid,"CRACK","crckidle2",4.1,0,1,1,1,1,0);
	if ((oldkeys & KEY_WALK) && !(newkeys & KEY_WALK)) {
		if(SERIU[playerid][sID] != INVALID_PLAYER_ID) {
			 SpecPlayer(playerid,SERIU[playerid][sID]);
			 TogglePlayerControllable(playerid, 1);
		}
        for(new i; i < gRoomsCount; i++) {
            if(IsPlayerInRangeOfPoint(playerid, 2, gRooms[i][roomsEnterX],gRooms[i][roomsEnterY],gRooms[i][roomsEnterZ]) && gRooms[i][roomsWorld] == GetPlayerVirtualWorld(playerid)) {
                if(gRooms[i][roomsDoors] == 1) return ErrorMessage(playerid, "Номер закрыт. У Вас нет ключей");
                SetPlayerPosAC(playerid,1401.8759,-1205.0002,130.2086,i+1,81);
				SetPlayerFacingAngle(playerid,272.2149);
				SetCameraBehindPlayer(playerid);
				OnPlayerUpdateLoadingMode(playerid);
                return true;
            }
            else if(IsPlayerInRangeOfPoint(playerid, 3, 1401.8759,-1205.0002,130.2086)) {
                new x = GetPlayerVirtualWorld(playerid)-1;
                SetPlayerPosAC(playerid,gRooms[x][roomsEnterX],gRooms[x][roomsEnterY],gRooms[x][roomsEnterZ],gRooms[x][roomsWorld],80);
				SetPlayerFacingAngle(playerid,gRooms[x][roomsEnterR]);
                updaterooms(playerid,gRooms[x][roomsWorld]);
				SetCameraBehindPlayer(playerid);
				OnPlayerUpdateLoadingMode(playerid);
                return true;
            }
        }
		if(GetPVarInt(playerid,"Animation") == 2) {
			ClearAnimationsEX(playerid);
			DeletePVar(playerid,"Animation");
			TextDrawHideForPlayer(playerid, AnimDraw);
		}
    }
    new tickcount1 = GetTickCount();
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        switch(GetPlayerWeapon(playerid)) {
            case 23..25, 29..31: {
                if(newkeys == 132 || newkeys == 4 || newkeys == 65410 || newkeys == 130) GUARD_TICK_C_BUG[playerid] = GetTickCount();
                if(GetTickCount() - GUARD_TICK_C_BUG[playerid] < 500 && newkeys == 2) {
                	if(GetPlayerVirtualWorld(playerid) == 0 && (PlayerToKvadrat(playerid, -1544.892, 270.5747, -1232.015, 558.5571) || PlayerToKvadrat(playerid, -49.979476, 1695.982177, 414.020507, 2175.982177))) {
                    	SetPlayerArmedWeapon(playerid,0);
                    	ApplyAnimation(playerid, "PED", "getup_front",4.0,0,0,0,0,0);
                    }
                }
            }
        }
    }
	// if(PRESSED(262144) || GetPlayerState(playerid) == PLAYER_STATE_DRIVER && PRESSED(KEY_CROUCH)) {
	//     if(TI[playerid][tProcess][0] != -1) {
	// 		if(GetPVarInt(playerid,"Klavisha") == 2455) MyButtonSystem(playerid);
	// 		else {
	// 			TI[playerid][tProcess][0] += -(3*(10/TI[playerid][tProcess][1]));
	// 			RandomYareNforJOBS(playerid);
	// 		}
	// 		return true;
	// 	}
	// }
	if(PRESSED(4)) {
		callcmd::lights(playerid,"");
		if(IsPlayerInAnyVehicle(playerid)) return 1;
		new Float:face_angle; GetPlayerFacingAngle(playerid, face_angle);
		for(new i; i<CountGraffity; i++) {
			if(!IsPlayerInRangeOfPoint(playerid, 3.0, GrafInfo[i][gr_x][0],GrafInfo[i][gr_x][1],GrafInfo[i][gr_x][2])) continue;
			if(GetPVarInt(playerid, "SettingGraffiti")) continue;
			//if(!(face_angle >= GrafInfo[i][gr_x][5] - 20.0 && face_angle < GrafInfo[i][gr_x][5] + 20.0)) continue;
			if(!IsAGang(playerid)) continue;
			if(PI[playerid][pMember] != GrafInfo[i][gFrak]) {
				if(GetPlayerWeapon(playerid) != 41) return ErrorMessage(playerid,"У Вас нет балончика");
				SetPVarInt(playerid,"Grafity",i);
				StartDrawing(playerid);
			}
		}
	}
	else if(RELEASED(4)) {
		if(IsPlayerInAnyVehicle(playerid)) return 1;
		if(!GetPVarInt(playerid, "SettingGraffiti")) return 1;
		GraffitiFailed(playerid);
		KillTimer(graf_timer[playerid]);
	}
	/*if(newkeys & KEY_FIRE) // ANTI ZZ
	{
		if(!IsAGreenZone(playerid) || IsPlayerInAnyVehicle(playerid)) return 1;
		//ClearAnimations(playerid);
		ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
		//anti_dm{playerid} ++;
		//D(playerid, DIALOG_NONE, DSM, ""P"Предупреждение","\n\n"W"В данном месте запрещено драться\n"NO"*"G" В случае повторных нарушений Вы будете кикнуты", "Закрыть", "" );
		if(anti_dm{playerid} >= 5) {
			ErrorMessage(playerid,"Вы были кикнуты за попытки DM в зеленой зоне");
			return Kick(playerid);
		}
	}
	*/
	if((newkeys & KEY_JUMP) || (newkeys == KEY_FIRE)) {
		if((TI[playerid][tJobGun][0] && TI[playerid][tJobGun][2])) {
			SendOk(playerid,"Вы уронили ящик");
			TI[playerid][tJobGun][2] = 0;
			if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
			ClearAnimations(playerid);
			TI[playerid][tJobGun][1] = 1;
			RemovePlayerMapIcon(playerid, 20);
			DisablePlayerRaceCheckpoint(playerid);
		}
		else if(TI[playerid][tJobOil][0] && TI[playerid][tJobOil][1] && !IsPlayerInAnyVehicle(playerid)) {
			SendOk(playerid,"Вы уронили бочку");
			ClearAnimations(playerid);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
			SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
			SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);
			TI[playerid][tJobOil][1] = false;
		}
		else if(GetPVarInt(playerid,"carrygun")) {
			SendOk(playerid,"Вы уронили ящик");
			DeletePVar(playerid,"carrygun");
			if(GetPVarInt(playerid,"use_mats") == 1) FI[fARMYLV][fMats] += 500,DeletePVar(playerid,"use_mats");
			if(GetPVarInt(playerid,"use_mats") == 2) FI[fARMYSF][fMats] += 500,DeletePVar(playerid,"use_mats");
			if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid,1);
			ClearAnimations(playerid);
		}
		else if(TI[playerid][tJobLoader][0] && TI[playerid][tJobLoader][1])
		{
			SendOk(playerid,"Вы уронили мешок");
			if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid,2);
			ClearAnimations(playerid);
			TI[playerid][tJobLoader][1] = 0;
			SetPlayerCheckpoint(playerid, 836.7643,-1203.7499,16.9766, 4.0);
		}
		if(TI[playerid][tJobMine] && GetPVarInt(playerid, "minesuccess") == 1)
		{
			SendOk(playerid,"Вы уронили мешок");
			//if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid,2);
			ClearAnimations(playerid);
			ErrorMessage(playerid, "Вы сломали тележку");
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
	        {
	            RemovePlayerAttachedObject(playerid, 4);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
	        {
	            RemovePlayerAttachedObject(playerid, 2);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 3))
	        {
	            RemovePlayerAttachedObject(playerid, 3);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 6))
	        {
	            RemovePlayerAttachedObject(playerid, 6);
			}
			SetPVarInt(playerid, "minesuccess", 0);
			SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.078221, 0.034000, 0.028844, -67.902618, 264.126861, 193.350555, 1.861999, 1.884000, 1.727000);
			DisablePlayerCheckpoint(playerid);
			switch(random(4)) { 
				case 0: SetPlayerCheckpoint(playerid, -1810.9850,-1651.5428,22.9537, 1.5);
				case 1: SetPlayerCheckpoint(playerid, -1807.7166,-1646.6080,23.5568, 1.5);
				case 2: SetPlayerCheckpoint(playerid, -1811.6035,-1655.8864,22.7126, 1.5);
				case 3: SetPlayerCheckpoint(playerid, -1802.2560,-1649.0052,26.0626, 1.5);
			}
			switch(random(4))
			{
			    case 2:D(playerid, DIALOG_NONE, DSM, "{FFEF0D}Нарушение технологии добычи руды", "{FFFFFF}Руководство шахты недовольно Вашей работой\nПопробуйте заново начать рабочий день. Впредь будьте более внимательны", "Ок", "");
			    default:
			    {
			        mine_ruda[playerid][0] = CreateDynamicCP(-1810.9850,-1651.5428,22.9537, 1.5, 0, 0, playerid, 1.5);
					mine_ruda[playerid][1] = CreateDynamicCP(-1807.7166,-1646.6080,23.5568, 1.5, 0, 0, playerid, 1.5);
					mine_ruda[playerid][2] = CreateDynamicCP(-1811.6035,-1655.8864,22.7126, 1.5, 0, 0, playerid, 1.5);
					mine_ruda[playerid][3] = CreateDynamicCP(-1802.2560,-1649.0052,26.0626, 1.5, 0, 0, playerid, 1.5);
					ClearAnimations(playerid);
			    }
			}
		}
		else if((TI[playerid][tJobWood][0] && TI[playerid][tJobWood][1])) {
			SendOk(playerid,"Вы уронили древесину");
	        TI[playerid][tJobWood][1] = 0;
	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid,9);
			ClearAnimations(playerid);
			SetPlayerAttachedObject(playerid,8,341,6);
			TI[playerid][tJobWood][3] = 1;
			TI[playerid][tJobWood][2] = -1;
		}
		else if(TI[playerid][tJobSad][0] && TI[playerid][tJobSad][2])
		{
			SendOk(playerid,"Вы уронили ящик");
			if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid,4);
			ClearAnimations(playerid);
			TI[playerid][tJobSad][3] -= TI[playerid][tJobSad][2];
			TI[playerid][tJobSad][2] = 0;
			DeletePVar(playerid,"bailer_3");
			DisablePlayerRaceCheckpoint(playerid);
		}
	}
	if(newkeys & KEY_LOOK_RIGHT) callcmd::style(playerid);
	if(newkeys == KEY_LOOK_BEHIND && GetPlayerVehicleID(playerid) == TI[playerid][tArendaCar]) {
		return D(playerid, dEndWork, DSM, ""P"Завершение рабочего дня", ""W"Желаете завершить рабочий день?", "Завершить", "Отмена");
	}
	if(newkeys & KEY_HANDBRAKE && newkeys & KEY_SECONDARY_ATTACK ) {
		new animname[32];
  		GetAnimationName(GetPlayerAnimationIndex(playerid),animname,32,animname,32);
		if((PlayerToPoint(2.0,playerid,768.5205,-2.8860,1000.7214) || PlayerToPoint(2.0,playerid,769.8723,14.4393,1000.6978))) {
  			if((strcmp(animname,"FIGHTB_1",true) == 0 || strcmp(animname,"FIGHTB_2",true) == 0 || strcmp(animname,"FIGHTB_3",true) == 0 || strcmp(animname,"FIGHTA_1",true) == 0
		  		|| strcmp(animname,"FIGHTC_1",true) == 0 || strcmp(animname,"FIGHTC_2",true) == 0 || strcmp(animname,"FIGHTC_3",true) == 0 || strcmp(animname,"FIGHTA_2",true) == 0
			  	|| strcmp(animname,"FIGHTD_1",true) == 0 || strcmp(animname,"FIGHTD_2",true) == 0 || strcmp(animname,"FIGHTD_3",true) == 0 || strcmp(animname,"FIGHTA_3",true) == 0)
		  	&& TI[playerid][tGym]) {
				if(PI[playerid][pBox] == 3) return ErrorMessage(playerid,"Вы изучили все навыки владения боем");
				if(!TI[playerid][tGymSkill]) return ErrorMessage(playerid,"Для начала проиобретите абонемент");
				if(floatround(PI[playerid][pSnow]) < 1000) {
					new skill;
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) skill = BonusInfo[act_sport];
					else if(BonusInfo[act_select] == 2) skill = BonusInfo[act_sport];
				    else skill = 1;

					if(TI[playerid][tGyms] <= 0) PI[playerid][pSnow] += (0.2*skill);
					else {
						if(TI[playerid][tGyms] - 0.4 <= 0) TI[playerid][tGyms] = 0;
						PI[playerid][pSnow] += (0.4*skill);
						TI[playerid][tGyms] -= 0.4;
					}
				}
				else if(floatround(PI[playerid][pSnow]) >= 1000) {
					PI[playerid][pBox] ++;
					UpdatePlayerData(playerid,"pBox",PI[playerid][pBox]);
					PI[playerid][pSnow] = 0;
					TI[playerid][tGymSkill] = 0;
					SendOk(playerid,"Вы изучили новый стиль боя. Для переключения введите: "W"/mn > личные настройки > стиль боя");
				}
				new string[33];
				format(string,32,"~g~NEED: ~w~%i",1000-floatround(PI[playerid][pSnow]));
				GameTextForPlayer(playerid,string, 5000, 3);
			}
		}
	}
	if(newkeys & KEY_WALK) {
		if(GetPVarInt(playerid,"hrieltor") || GetPVarInt(playerid,"bizzrielor")) {
			TogglePlayerControllable(playerid,1);
			SetPlayerPosAC(playerid,GetPVarFloat(playerid,"rielX"),GetPVarFloat(playerid,"rielY"),GetPVarFloat(playerid,"rielZ"),GetPVarInt(playerid,"rielVW"),1);
			SetCameraBehindPlayer(playerid);
			DeletePVar(playerid,"rielX");
			DeletePVar(playerid,"rielY");
			DeletePVar(playerid,"rielZ");
			DeletePVar(playerid,"rielVW");
			DeletePVar(playerid,"hrieltor");
			DeletePVar(playerid,"bizzrielor");
		}
	}
	if(newkeys == KEY_CTRL_BACK) {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, -1520.8967,485.7871,7.3062))
	    {
	        if(!IsAArm(playerid)) return 1;
/*         	MoveDynamicObject(moved_info[0][moved_id],moved_pos_object[0][0],moved_pos_object[0][1],moved_pos_object[0][2]+0.04,(moved_info[0][moved_modelid] == 968) ? (0.014) : (moved_info[0][moved_modelid] == 2920) ? (0.014) : (moved_info[0][moved_modelid] == 1495) ? (0.034) : (moved_info[0][moved_modelid] == 2949) ? (0.034) : (moved_info[0][moved_modelid] == 2949) ? (10.0) : (1.2),moved_pos_object[0][3],moved_pos_object[0][4],moved_pos_object[0][5]);
			moved_info[0][status_moved]=true;
			PlayerPlaySound(playerid,4203,0.0,0.0,0.0); */
	    }
	}
	if(newkeys == KEY_CROUCH || (newkeys == 262144 && TI[playerid][pAndroid])) {
/*         new barrierid = IsObjectBarrier(playerid);
		if(barrierid != -1) CheckBarrier(playerid,barrierid); */

		if((IsPlayerInRangeOfPoint(playerid,  20.0, 1050.0936,-1868.7532,894.0478) ||
				IsPlayerInRangeOfPoint(playerid,  20.0, 1123.6130,-1849.0645,894.0478) ||
				IsPlayerInRangeOfPoint(playerid,  20.0, 1053.8595,-1785.5875,894.0478) ||
				IsPlayerInRangeOfPoint(playerid,  20.0, 1108.8413,-1783.3357,894.0478)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {

			new i = TI[playerid][tSelectHouse];
			new Veh = GetPlayerVehicleID(playerid);
			SetVehiclePos(Veh, gHouses[i][houseParkX], gHouses[i][houseParkY], gHouses[i][houseParkZ]);
			SetVehicleZAngle(Veh, gHouses[i][houseParkR]);
			exit_garage(Veh,0);
			SetCameraBehindPlayer(playerid);
			TI[playerid][tInHouse] = false;
		}
		else if((IsPlayerInRangeOfPoint(playerid,  20.0, 1646.7213,738.0809,590.4441)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			new Veh = GetPlayerVehicleID(playerid),rand;
			switch(PI[playerid][pRoom]) {
				case 1..60: rand = Random(0,9);
				case 61..120: rand = Random(10,18);
				case 121..180: rand = Random(24,33);
				case 181..240: rand = Random(19,23);
				default: return ErrorMessage(playerid,"Вы не снимаете комнату в данном отеле");
			}
			SetVehiclePos(Veh, hotel_spawncar[rand][0], hotel_spawncar[rand][1], hotel_spawncar[rand][2]);
			SetVehicleZAngle(Veh, hotel_spawncar[rand][3]);
			exit_garage(Veh,0);
			SetCameraBehindPlayer(playerid);
		}
		// ARmy LV ворота для машин пикапы 'H'
		else if((IsPlayerInRangeOfPoint(playerid, 5.0, 290.0635,1821.3661,17.6406)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if(!IsAArm(playerid)) return ErrorMessage(playerid, "У вас нет доступа к этим воротам");
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 280.4901,1823.4368,17.6709);
		}
		else if((IsPlayerInRangeOfPoint(playerid, 5.0, 283.0171,1821.3195,17.6709)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if(!IsAArm(playerid)) return ErrorMessage(playerid, "У вас нет доступа к этим воротам");
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 289.9789,1824.4294,17.6509);
		}
		else if((IsPlayerInRangeOfPoint(playerid, 5.0, 134.8916,1938.0608,19.2849)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if(!IsAArm(playerid)) return ErrorMessage(playerid, "У вас нет доступа к этим воротам");
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 135.3344,1948.7473,19.3771);
		}
		else if((IsPlayerInRangeOfPoint(playerid, 5.0, 135.1537,1945.2299,19.3479)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		   	if(!IsAArm(playerid)) return ErrorMessage(playerid, "У вас нет доступа к этим воротам");
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, 134.9621,1933.0717,19.2444);
		}
		//
		else if((IsPlayerInRangeOfPoint(playerid,  10.0, 1153.4031,-1208.7499,19.0252) ||
				IsPlayerInRangeOfPoint(playerid,  10.0, -1786.8206,1206.0835,25.1250) ||
				IsPlayerInRangeOfPoint(playerid,  10.0, 1643.8298,2197.1387,10.8203)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return ErrorMessage(playerid, "Вы не за рулём своего Т/С");
			new Veh = GetPlayerVehicleID(playerid);
			if(GetVehicleFreeSeat(Veh) == -1) return ErrorMessage(playerid,"У Вас в Т/C пассажиры");
			switch(GetNearestTune(playerid)) {
				case 1: exit_garage(Veh,1,true);
				case 2: exit_garage(Veh,2,true);
				case 3: exit_garage(Veh,3,true);
			}
			SetVehiclePos(Veh, 1911.3821,71.0226,1139.2352);
			SetVehicleZAngle(Veh, 180.4593);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4.5, 1905.1360,59.3574,1139.4918)) {
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return ErrorMessage(playerid, "Вы не за рулём своего Т/С");
			if(!GetPVarInt(playerid,"TunningSaluna")) {
				SetPVarInt(playerid,"VehicleTunnSALON",GetPlayerVehicleID(playerid));
				SetPVarInt(playerid,"TunningSaluna",1);

				for(new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid,ColorTD[i]);
				SendClientMessage(playerid, CGOLD, "Используйте "W"/buy для покупки и "W"/cancel для выхода из меню.");
				new curcol,vehicleid = GetPlayerVehicleID(playerid);
				for(new i = 0; i < 2; i++) {
					curcol = VehicleInfo[vehicleid][vColor][i];
					PlayerTextDrawColor(playerid, ColorTDPl[playerid][2+3*i], RGBArray[curcol]);
					curcol--;
					if(curcol < 0) curcol = 255;
					PlayerTextDrawColor(playerid, ColorTDPl[playerid][1+3*i], RGBArray[curcol]);
					curcol += 2;
					if(curcol > 255) curcol = 0;
					PlayerTextDrawColor(playerid, ColorTDPl[playerid][3+3*i], RGBArray[curcol]);
				}
				for(new i = 0; i < 6; i++) PlayerTextDrawShow(playerid,ColorTDPl[playerid][1+i]);
				for(new i = 0, b = VehicleModelToPaintjobNum(GetVehicleModel(GetPlayerVehicleID(playerid)))+1; i < b; i++) TextDrawShowForPlayer(playerid,ColorTD[11+i]);
				VinylJob[playerid] = 0;
				TextDrawShowForPlayer(playerid,ColorTD[16]);
				PrimaryColor[playerid] = VehicleInfo[vehicleid][vColor][0];
				SecondaryColor[playerid] = VehicleInfo[vehicleid][vColor][1];
				RepaintValue[playerid] = 0;
				DeletePVar(playerid, "PaintJob");
				ChangedPrimaryColor[playerid] = false;
				ChangedSecondaryColor[playerid] = false;
				ChangedVinylJob[playerid] = false;
				PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],"$0");
				PlayerTextDrawShow(playerid,ColorTDPl[playerid][0]);
				TextDrawShowForPlayer(playerid,ColorTD[15]);
				SelectTextDraw(playerid,0xAA3333AA);
			}
			else {
				CancelSelectTextDraw(playerid);
				SetPVarInt(playerid,"TunningSaluna",0);
				for(new h = 0;h < 20;h++) {
					if(h < 7)PlayerTextDrawHide(playerid,ColorTDPl[playerid][h]);
					TextDrawHideForPlayer(playerid,ColorTD[h]);
				}
				new cartune = GetPVarInt(playerid,"VehicleTunnSALON");
				ChangeVehicleColor(cartune,VehicleInfo[cartune][vColor][0],VehicleInfo[cartune][vColor][1]);
				ChangeVehiclePaintjob(cartune, VehicleInfo[cartune][vPaintJob]);
			}
			SetCameraBehindPlayer(playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid,  4.5, 1913.2271,59.1919,1139.4918)) {
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return ErrorMessage(playerid, "Вы не за рулём своего Т/С");
			if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return ErrorMessage(playerid, "Недоступно для данного Т/С");
			if(!GetPVarInt(playerid,"TunningSalun")) {
				SetPVarInt(playerid,"VehicleTunnSALON",GetPlayerVehicleID(playerid));
				SetPVarInt(playerid,"TunningSalun",1);
				new str[64],value;
				for(new i = 0; i < 3; i++) TextDrawShowForPlayer(playerid,CustomTD[i]);
                SendClientMessage(playerid, CGOLD, "Используйте "W"/buy для покупки и "W"/cancel для выхода из меню.");
				CustomType[playerid] = 0;
				CustomListNum[playerid] = 0;
				CustomLimitNum[playerid] = 0;
				for(new i = 0; i < 5; i++) {
					if(i > TypeBorder[CustomType[playerid]]-1) break;
					TextDrawShowForPlayer(playerid,CustomTD[5+i]);
					format(str,64,"TUN[%d][Value]",i);
					value = GetGVarInt(str,CustomType[playerid]);

					new price;
					if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
						new seller = floatround(value/100*vip_status[PI[playerid][pVips]][vip_tune]);
						price = (value-seller);
					}
					else {
						if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
							new seller = floatround(value/100*BonusInfo[act_tune]);
							price = (value-seller);
						}
						else if(BonusInfo[act_select] == 2) {
							new seller = floatround(value/100*BonusInfo[act_tune]);
							price = (value-seller);
						}
					    else price = value;
					}

					format(str,64,"TUN[%d][Name]",i);
					GetGVarString(str,str,64,CustomType[playerid]);
					format(str,64,"%s~n~$%d",str,price);
					PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+i],str);
					PlayerTextDrawShow(playerid,CustomTDPl[playerid][1+i]);
					format(str,64,"TUN[%d][ModelID]",i);
					if(!IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)),GetGVarInt(str,CustomType[playerid]))) TextDrawShowForPlayer(playerid,CustomTD[15+i]);
					else if(i == 0) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],GetGVarInt(str,CustomType[playerid]));
				}
				TextDrawShowForPlayer(playerid,CustomTD[10]);
				TextDrawShowForPlayer(playerid,CustomTD[20]);
				TextDrawShowForPlayer(playerid,CustomTD[21]);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][0],CustomTypeName[0]);
				PlayerTextDrawShow(playerid,CustomTDPl[playerid][0]);
				CameraViewChange(playerid,CustomType[playerid]);
				SelectTextDraw(playerid,0xAA3333AA);
			}
			else {
				SetCameraBehindPlayer(playerid);
				CancelSelectTextDraw(playerid);
				SetPVarInt(playerid,"TunningSalun",0);
				for(new h = 0;h < 22;h++) {
					if(h < 6)PlayerTextDrawHide(playerid,CustomTDPl[playerid][h]);
					TextDrawHideForPlayer(playerid,CustomTD[h]);
				}
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid,  5.5, 1909.0234,73.2966,1139.4918)) {
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return ErrorMessage(playerid, "Вы не за рулём своего Т/С");
			new Veh = GetPlayerVehicleID(playerid);
			new id = random(2);
			switch(GetPlayerInterior(playerid)) {
				case 1: {
					SetVehiclePos(Veh, tuning_exit_1[id][0],tuning_exit_1[id][1],tuning_exit_1[id][2]);
					SetVehicleZAngle(Veh, tuning_exit_1[id][3]);
				}
				case 2: {
					SetVehiclePos(Veh, tuning_exit_3[id][0],tuning_exit_3[id][1],tuning_exit_3[id][2]);
					SetVehicleZAngle(Veh, tuning_exit_3[id][3]);
				}
				case 3: {
					SetVehiclePos(Veh, tuning_exit_2[id][0],tuning_exit_2[id][1],tuning_exit_2[id][2]);
					SetVehicleZAngle(Veh, tuning_exit_2[id][3]);
				}
			}
			exit_garage(Veh,0);
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, 2653.8486,-2387.8660,13.63287) && (PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7)) {
			new Veh = GetPlayerVehicleID(playerid);
			if((VehicleInfo[Veh][vBizz] != 5 && VehicleInfo[Veh][vBizz] != 6 && VehicleInfo[Veh][vBizz] != 7) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"Необходимо находиться за рулём тягоча");
			if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) return ErrorMessage(playerid,"У Вас уже есть груз");
			if(GetVehicleFreeSeat(Veh) == -1) return ErrorMessage(playerid,"Начать загрузку можно без пассажиров");
			SetVehiclePos(Veh, 2628.4819,-589.2004,2768.9805);
			SetVehicleZAngle(Veh, 200.1132);

			SetPlayerVirtualWorld(playerid,playerid+1);

			SetVehicleVirtualWorld(Veh,playerid+1);

			SetPlayerCameraPos(playerid, 2635.027099, -597.102844, 2768.397460);
			SetPlayerCameraLookAt(playerid, 2632.648681, -592.704895, 2768.367431);

			TogglePlayerControllable(playerid, false);

			TK_Trailer[playerid] = A_CreateVehicle(450,2624.5708,-578.5069,2768.5903,200.0733,color_td[FuncBizz[PI[playerid][bizz_work]][funcbColor]][col_car],color_td[FuncBizz[PI[playerid][bizz_work]][funcbColor]][col_car],-1,VEHICLE_TYPE_TRAILER);
			SetVehicleVirtualWorld(TK_Trailer[playerid],playerid+1);

			new prods;
			switch(GetVehicleModel(Veh)) {
				case 609: prods = 10000;
				case 514: prods = 12000;
				case 515: prods = 15000;
				default: prods = 10000;
			}

			//SetPVarInt(playerid, "loading_truck", 1);
			static const f_str[] = ""W"Сколько боеприпасов вы хотите загрузить?\n\n\
								Максимальная грузоподъемность фуры: "ORANGE"%d"W" кг\n\
								Боеприпасов на складе: "ORANGE"%d"W" ед\n\n\
								"W"Количество загружаемых боеприпасов должно быть кратное: "ORANGE"1000"W" кг";
			new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 7) + (-2 + 5)];
			format(string,sizeof(string),f_str,prods,zavodsklad);

			D(playerid,D_TRUCK,DSI, ""P"Оружейный завод",string,"Загрузить","Отмена");
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, 2343.6523,-1220.3994,22.5000) && rob_veh[playerid] != INVALID_VEHICLE_ID && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			if(!VG[rob_veh[playerid]][vgAmount][0]) return ErrorMessage(playerid,"Фургон пуст");
			GiveMoney(playerid,250*VG[rob_veh[playerid]][vgAmount][0],"ограбление дома");
			VG[rob_veh[playerid]][vgAmount][0] = 0;
			SendOk(playerid,"Вы успешно продали награбленную технику");
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, 253.3007,1396.0299,10.5859) && (PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7)) {
			new Veh = GetPlayerVehicleID(playerid);
			if((VehicleInfo[Veh][vBizz] != 5 && VehicleInfo[Veh][vBizz] != 6 && VehicleInfo[Veh][vBizz] != 7) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"Необходимо находиться за рулём тягоча");
			if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) return ErrorMessage(playerid,"У Вас уже есть груз");
			if(GetVehicleFreeSeat(Veh) == -1) return ErrorMessage(playerid,"Начать загрузку можно без пассажиров");
			SetVehiclePos(Veh, 2628.4819,-589.2004,2768.9805);
			SetVehicleZAngle(Veh, 200.1132);
			SetPlayerVirtualWorld(playerid,playerid+1);

			SetVehicleVirtualWorld(Veh,playerid+1);

			SetPlayerCameraPos(playerid, 2635.027099, -597.102844, 2768.397460);
			SetPlayerCameraLookAt(playerid, 2632.648681, -592.704895, 2768.367431);

			TogglePlayerControllable(playerid, false);

			TK_Trailer[playerid] = A_CreateVehicle(584,2624.5708,-578.5069,2768.5903,200.0733,color_td[FuncBizz[PI[playerid][bizz_work]][funcbColor]][col_car],color_td[FuncBizz[PI[playerid][bizz_work]][funcbColor]][col_car],-1,VEHICLE_TYPE_TRAILER);
			SetVehicleVirtualWorld(TK_Trailer[playerid],playerid+1);

			new prods;
			switch(GetVehicleModel(Veh)) {
				case 609: prods = 10000;
				case 514: prods = 12000;
				case 515: prods = 15000;
				default: prods = 10000;
			}

			//SetPVarInt(playerid, "loading_truck", 2);
			static const f_str[] = ""W"Сколько тонн нефти вы хотите загрузить?\n\n\
								Максимальная грузоподъемность фуры: "ORANGE"%d"W" ед.\n\
								Нефти на складе: "ORANGE"%d"W" т.\n\n\
								"W"Количество загружаемой должно быть кратное: "ORANGE"1000"W" т.";
			new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 7) + (-2 + 5)];
			format(string,sizeof(string),f_str,prods,oilsklad*10000);

			D(playerid,D_TRUCK_2,DSI, ""P"Нефтезавод",string,"Загрузить","Отмена");
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, -506.2975,-1563.9176,10.3160) && (PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7)) {
			new Veh = GetPlayerVehicleID(playerid);
			if((VehicleInfo[Veh][vBizz] != 5 && VehicleInfo[Veh][vBizz] != 6 && VehicleInfo[Veh][vBizz] != 7) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"Необходимо находиться за рулём тягоча");
			if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) return ErrorMessage(playerid,"У Вас уже есть груз");
			if(GetVehicleFreeSeat(Veh) == -1) return ErrorMessage(playerid,"Начать загрузку можно без пассажиров");
			SetVehiclePos(Veh, 2628.4819,-589.2004,2768.9805);
			SetVehicleZAngle(Veh, 200.1132);
			SetPlayerVirtualWorld(playerid,playerid+1);

			SetVehicleVirtualWorld(Veh,playerid+1);

			SetPlayerCameraPos(playerid, 2635.027099, -597.102844, 2768.397460);
			SetPlayerCameraLookAt(playerid, 2632.648681, -592.704895, 2768.367431);

			TogglePlayerControllable(playerid, false);

			TK_Trailer[playerid] = A_CreateVehicle(584,2624.5708,-578.5069,2768.5903,200.0733,color_td[FuncBizz[PI[playerid][bizz_work]][funcbColor]][col_car],color_td[FuncBizz[PI[playerid][bizz_work]][funcbColor]][col_car],-1,VEHICLE_TYPE_TRAILER);
			SetVehicleVirtualWorld(TK_Trailer[playerid],playerid+1);

			new prods;
			switch(GetVehicleModel(Veh)) {
				case 609: prods = 10000;
				case 514: prods = 12000;
				case 515: prods = 15000;
				default: prods = 10000;
			}

			//SetPVarInt(playerid, "loading_truck", 3);
			static const f_str[] = ""W"Сколько кг деревесины вы хотите загрузить?\n\n\
								Максимальная грузоподъемность фуры: "ORANGE"%d"W" кг.\n\
								Древесины на складе: "ORANGE"%d"W" кг.\n\n\
								"W"Количество загружаемой древесины должно быть кратное: "ORANGE"1000"W" кг.";
			new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 7) + (-2 + 5)];
			format(string,sizeof(string),f_str,prods,woodsklad);

			D(playerid,D_TRUCK_3,DSI, ""P"Лесопилка",string,"Загрузить","Отмена");
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, -1744.4447,149.4602,3.5496) && (PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7) && TI[playerid][tTrucker][1] == 1) {//порт сф
			new Veh = GetPlayerVehicleID(playerid);
			if((VehicleInfo[Veh][vBizz] != 5 || VehicleInfo[Veh][vBizz] != 6 || VehicleInfo[Veh][vBizz] != 7) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"Необходимо находиться за рулём тягоча");
			if(TK_Trailer[playerid] == INVALID_VEHICLE_ID || !GetVehicleTrailer(Veh)) return ErrorMessage(playerid,"У Вас нет груза");

			new percent = floatround(TI[playerid][tTrucker][0]/1000*TI[playerid][tTrucker][2]);//общая сумма
			new price_1 = floatround(percent/100*FuncBizz[PI[playerid][bizz_work]][funcbPercent]);//процент который идёт в ТК
			new price_2 = percent-price_1;//сумма которая идёт игроку

			static const f_str[] = ""W"%d"G" кг груза было продано за "ORANGE"$%d. "G"Доход: $%d ($%d доставлено в кассу компании)";
			new string[sizeof(f_str) +1 + (-2 + 5) + (-2 + 5) + (-2 + 5) + (-2 + 5)];
			format(string,sizeof(string),f_str,TI[playerid][tTrucker][0],percent,price_2,price_1);
			SendOk(playerid,string);
			GiveMoney(playerid,price_2,"разгрузка ТК");
			bizz_pay(PI[playerid][bizz_work]-1,price_1);

			PI[playerid][bizz_lcash] += price_1;
			PI[playerid][bizz_cash] += price_1;

			UpdatePlayerData(playerid,"bizz_lcash",PI[playerid][bizz_lcash]);
			UpdatePlayerData(playerid,"bizz_cash",PI[playerid][bizz_cash]);
			A_DestroyVehicle(TK_Trailer[playerid]);
			TK_Trailer[playerid] = INVALID_VEHICLE_ID;
			TI[playerid][tTrucker][3] = 0;
			TI[playerid][tTrucker][2] = 0;
			TI[playerid][tTrucker][1] = 0;
			TI[playerid][tTrucker][0] = 0;
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, 2616.7119,-2226.7627,13.3819) && (PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7) && TI[playerid][tTrucker][1] == 2) {//порт ЛС
			new Veh = GetPlayerVehicleID(playerid);
			if((VehicleInfo[Veh][vBizz] != 5 || VehicleInfo[Veh][vBizz] != 6 || VehicleInfo[Veh][vBizz] != 7) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"Необходимо находиться за рулём тягоча");
			if(TK_Trailer[playerid] == INVALID_VEHICLE_ID || !GetVehicleTrailer(Veh)) return ErrorMessage(playerid,"У Вас нет груза");

			new percent = floatround(TI[playerid][tTrucker][0]/1000*TI[playerid][tTrucker][2]);//общая сумма
			new price_1 = floatround(percent/100*FuncBizz[PI[playerid][bizz_work]][funcbPercent]);//процент который идёт в ТК
			new price_2 = percent-price_1;//сумма которая идёт игроку

			static const f_str[] = ""W"%d"G" кг груза было продано за "ORANGE"$%d. "G"Доход: $%d ($%d доставлено в кассу компании)";
			new string[sizeof(f_str) +1 + (-2 + 5) + (-2 + 5) + (-2 + 5) + (-2 + 5)];
			format(string,sizeof(string),f_str,TI[playerid][tTrucker][0],percent,price_2,price_1);
			SendOk(playerid,string);
			GiveMoney(playerid,price_2,"разгрузка ТК");
			bizz_pay(PI[playerid][bizz_work]-1,price_1);

			PI[playerid][bizz_lcash] += price_1;
			PI[playerid][bizz_cash] += price_1;

			UpdatePlayerData(playerid,"bizz_lcash",PI[playerid][bizz_lcash]);
			UpdatePlayerData(playerid,"bizz_cash",PI[playerid][bizz_cash]);
			A_DestroyVehicle(TK_Trailer[playerid]);
			TK_Trailer[playerid] = INVALID_VEHICLE_ID;
			TI[playerid][tTrucker][3] = 0;
			TI[playerid][tTrucker][1] = 0;
			TI[playerid][tTrucker][0] = 0;
		}
		else if(IsPlayerInRangeOfPoint(playerid,  7.0, 2687.9753,-2480.1912,13.5008) && (PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7) && TI[playerid][tTrucker][1] == 3) {//оружейка
			new Veh = GetPlayerVehicleID(playerid);
			if((VehicleInfo[Veh][vBizz] != 5 || VehicleInfo[Veh][vBizz] != 6 || VehicleInfo[Veh][vBizz] != 7) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"Необходимо находиться за рулём тягоча");
			if(TK_Trailer[playerid] == INVALID_VEHICLE_ID || !GetVehicleTrailer(Veh)) return ErrorMessage(playerid,"У Вас нет груза");

			new percent = floatround(TI[playerid][tTrucker][0]/1000*TI[playerid][tTrucker][2]);//общая сумма
			new price_1 = floatround(percent/100*FuncBizz[PI[playerid][bizz_work]][funcbPercent]);//процент который идёт в ТК
			new price_2 = percent-price_1;//сумма которая идёт игроку

			static const f_str[] = ""W"%d"G" кг груза было продано за "ORANGE"$%d. "G"Доход: $%d ($%d доставлено в кассу компании)";
			new string[sizeof(f_str) +1 + (-2 + 5) + (-2 + 5) + (-2 + 5) + (-2 + 5)];
			format(string,sizeof(string),f_str,TI[playerid][tTrucker][0],percent,price_2,price_1);
			SendOk(playerid,string);
			GiveMoney(playerid,price_2,"разгрузка ТК");
			bizz_pay(PI[playerid][bizz_work]-1,price_1);

			PI[playerid][bizz_lcash] += price_1;
			PI[playerid][bizz_cash] += price_1;

			UpdatePlayerData(playerid,"bizz_lcash",PI[playerid][bizz_lcash]);
			UpdatePlayerData(playerid,"bizz_cash",PI[playerid][bizz_cash]);
			A_DestroyVehicle(TK_Trailer[playerid]);
			TK_Trailer[playerid] = INVALID_VEHICLE_ID;
			TI[playerid][tTrucker][3] = 0;
			TI[playerid][tTrucker][1] = 0;
			TI[playerid][tTrucker][0] = 0;
		}
		else if(PI[playerid][pHouse] && gHouses[PI[playerid][pHouse]-1][houseImprove][2]) {
			if(PlayerToPoint(10,playerid,gHouses[PI[playerid][pHouse]-1][houseParkX], gHouses[PI[playerid][pHouse]-1][houseParkY], gHouses[PI[playerid][pHouse]-1][houseParkZ]) && ((house_car[playerid][0] != INVALID_VEHICLE_ID && GetPlayerVehicleID(playerid) == house_car[playerid][0]) || (house_car[playerid][1] != INVALID_VEHICLE_ID && GetPlayerVehicleID(playerid) == house_car[playerid][1]))) {
				new id = -1,house = PI[playerid][pHouse]-1,car;
				switch(gHouses[house][houseClass]) {
					case 0: id = 0;
					case 1: id = 2;
					case 2: id = 4;
					case 3: id = 6;
				}
				new hint = gHouses[house][houseHint];
				new interior = hinterior_info[hint][h_interior];
				new Veh = GetPlayerVehicleID(playerid);
				if(GetPlayerVehicleID(playerid) == house_car[playerid][0]) car = 0;
				else car = 1;
				switch(car) {
					case 0: {
						SetVehiclePos(Veh, cargarage[id][0],cargarage[id][1],cargarage[id][2]);
						SetVehicleZAngle(Veh,cargarage[id][3]);
						enter_garage(Veh,interior,PI[playerid][pHouse]-1);
						SetCameraBehindPlayer(playerid);
					}
					case 1: {
						SetVehiclePos(Veh, cargarage[id+1][0],cargarage[id+1][1],cargarage[id+1][2]);
						SetVehicleZAngle(Veh,cargarage[id+1][3]);
						enter_garage(Veh,interior,PI[playerid][pHouse]-1);
						SetCameraBehindPlayer(playerid);
					}
				}
			}
		}
    }
	if(newkeys & KEY_SPRINT || newkeys & KEY_JUMP) {

		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			
			if(!GetEngineStat(GetPlayerVehicleID(playerid))) return 0;
		}
		else { if(IsPlayerInRangeOfPoint(playerid,50,2072.4404,1710.0946,1113.7882)) ClearAnimations(playerid); }
	}
	/*
	if(newkeys & KEY_JUMP && newkeys & KEY_SPRINT) {
	    if(!IsPlayerInAnyVehicle(playerid)) {
			new index = GetPlayerAnimationIndex(playerid);
			if(index == 1224 || index == 1247 || index == 1257 || index == 1249 || index == 1196 || index == 1249) {
				if(!TI[playerid][tCuffed] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
					if(GetPVarInt(playerid,"anti_sbiv_time") < unix && !TI[playerid][tTazer] && !TI[playerid][tCuffedTime] && GetPVarInt(playerid,"Animation") == 0) {
						new keys,ud,lr;
						GetPlayerKeys(playerid,keys,ud,lr);
						if(ud != 0 || lr != 0) ClearAnimations(playerid);
					}
				}
			}
		}
	}*/
 	if(PRESSED(KEY_NO)) {
		// if(TI[playerid][tProcess][0] != -1) {
		// 	if(GetPVarInt(playerid,"Klavisha") == 131072) MyButtonSystem(playerid);
		// 	else {
		// 		TI[playerid][tProcess][0] += -(3*(10/TI[playerid][tProcess][1]));
		// 		RandomYareNforJOBS(playerid);
		// 	}
		// 	return true;
		// }
		if(TI[playerid][tDiceID] != INVALID_PLAYER_ID) {
			new id = TI[playerid][tDiceID];
			TI[playerid][tDiceMoney] = 0;
			TI[playerid][tDiceClosed] = TI[id][tDiceClosed] = false;
			new string[128];
			format(string,sizeof(string),"Вы отказались играть в кости с %s",player_name[id]);
			SendOk(playerid, string);

			format(string,sizeof(string),"%s отказался играть с вами в кости",player_name[playerid]);
			SendOk(id, string);
			if(TI[id][tDiceIDs] == playerid) TI[playerid][tDiceID] = TI[id][tDiceIDs] = INVALID_PLAYER_ID;
			else TI[playerid][tDiceID] = INVALID_PLAYER_ID;
		}
		else if(GetPVarInt(playerid,"race_offer")) {
			new string[128];
			format(string,sizeof(string),"Вы отказались от участия в уличных гонках с %s",player_name[GetPVarInt(playerid,"race_offer")-1]);
			SendOk(playerid, string);

			format(string,sizeof(string),"%s отказался от участия в уличных гонках",player_name[playerid]);
			SendOk(GetPVarInt(playerid,"race_offer")-1, string);
		}
		else if(GetPVarInt(playerid,"lices")) {
			SendOk(playerid,"Вы отказались от просмотра лицензий");
			SendOk(GetPVarInt(playerid,"lices")-1,"Игрок отказался от просмотра лицензий");
			DeletePVar(playerid,"lices");
		}
		else if(GetPVarInt(playerid,"skillss")) {
			SendOk(playerid,"Вы отказались от просмотра навыков владения оружием");
			SendOk(GetPVarInt(playerid,"skillss")-1,"Игрок отказался от просмотра ваших навыков владения оружием");
			DeletePVar(playerid,"skillss");
		}
		else if(GetPVarInt(playerid,"wbook")) {
			SendOk(playerid,"Вы отказались от просмотра трудовой книжки");
			SendOk(GetPVarInt(playerid,"wbook")-1,"Игрок отказался от просмотра вашей трудовой книжки");
			DeletePVar(playerid,"wbook");
		}
		else if(GetPVarInt(playerid,"uds")) {
			SendOk(playerid,"Вы отказались от просмотра удостоверения");
			SendOk(GetPVarInt(playerid,"uds")-1,"Игрок отказался от просмотра удостоверения");
			DeletePVar(playerid,"uds");
		}
		else if(GetPVarInt(playerid,"udjur")) {
			SendOk(playerid,"Вы отказались от просмотра удостоверения журналиста");
			SendOk(GetPVarInt(playerid,"udjur")-1,"Игрок отказался от просмотра удостоверения журналиста");
			DeletePVar(playerid,"udjur");
		}
		else if(GetPVarInt(playerid,"pass")) {
			SendOk(playerid,"Вы отказались от просмотра паспорта");
			SendOk(GetPVarInt(playerid,"pass")-1,"Игрок отказался от просмотра паспорта");
			DeletePVar(playerid,"pass");
		}
		else if(GetPVarInt(playerid,"fpass")) {
			SendOk(playerid,"Вы отказались от просмотра паспорта");
			SendOk(GetPVarInt(playerid,"fpass")-1,"Игрок отказался от просмотра паспорта");
			DeletePVar(playerid,"fpass");
		}
		else if(GetPVarInt(playerid,"medcard")) {
			SendOk(playerid,"Вы отказались от просмотра мед.карты");
			SendOk(GetPVarInt(playerid,"medcard")-1,"Игрок отказался от просмотра мед.карты");
			DeletePVar(playerid,"medcard");
		}
		else if(GetPVarInt(playerid,"taxi_id")) {
			SendOk(playerid, "Вы отказались от вступления в таксопарк");
			DeletePVar(playerid,"taxi_id");
		}
		else if(GetPVarInt(playerid,"tk_id")) {
			SendOk(playerid, "Вы отказались от вступления в транспортную компанию");
			DeletePVar(playerid,"tk_id");
		}
		else if(HealOffer[playerid] != INVALID_PLAYER_ID) {
			SendOk(playerid, "Вы отказались от лечения");
			SendOk(HealOffer[playerid], "Игрок отказался от лечения");
			HealOffer[playerid] = INVALID_PLAYER_ID;
		}
		else if(GetPVarInt(playerid,"repairoffee") == playerid && GetPVarInt(playerid,"repairoffer") != playerid) {
			new offer = GetPVarInt(playerid,"repairoffer");
			if(GetPVarInt(offer,"repairoffee") == playerid) {
				SetPVarInt(playerid,"repairoffee",-1);
				SetPVarInt(playerid,"repairoffer",-1);
				DeletePVar(playerid,"repairprice");
				DeletePVar(offer,"repairoffee");
				new string[128];
				format(string, sizeof(string), "Вы отказались от починки транспорта игроком %s", player_name[offer]);
				SendOk(playerid, string);
				format(string, sizeof(string), "%s отказался от починки транспорта", player_name[playerid]);
				SendOk(offer, string);
			}
		}
		else if(GetPVarInt(playerid, "invstat") == playerid) {
			SendOk(playerid,"Вы отказались от вступления в организацию");
			SendOk(GetPVarInt(playerid, "invinv"),"Игрок отказался от вступления в организацию");
			DeletePVar(playerid, "invinv");
			DeletePVar(playerid, "invskin");
			SetPVarInt(playerid, "invstat",-1);
		}
		else if(GetPVarInt(playerid, "sellbizmafia_seller"))
		{
			SendOk(playerid,"Вы отказались от покупки контроля над бизнесом");
			SendOk(GetPVarInt(playerid, "sellbizmafia_seller"),"Игрок отказался от покупки контроля над бизнесом");
			DeletePVar(playerid, "sellbizmafia_seller");
			DeletePVar(playerid, "sellbizmafia_business");
		}
		else if(GetPVarInt(playerid,"kiss")) {
			SendOk(playerid,"Вы отказались от поцелуя");
			SendOk(GetPVarInt(playerid,"kiss")-1,"Игрок отказался от поцелуя");
			DeletePVar(playerid,"kiss");
		}
		if(GetPVarInt(playerid,"hi")) {
			SendOk(playerid,"Вы отказались от рукопожатия");
			SendOk(GetPVarInt(playerid,"hi")-1,"Игрок отказался от рукопожатия");
			DeletePVar(playerid,"hi");
		}
		if(GetPVarInt(playerid,"family_invite")) {
			SendOk(playerid,"Вы отказались от предложения вступить в семью");
			SendOk(GetPVarInt(playerid,"family_invite") - 1,"Игрок отказался от предложения вступить в Вашу семью");
			DeletePVar(GetPVarInt(playerid,"family_invite") - 1,"family_invite");
			DeletePVar(playerid,"family_invite");
		}
		else if(GetPVarInt(playerid, "drugoffee") == playerid && GetPVarInt(playerid,"drugoffer") != playerid) {
			new offer = GetPVarInt(playerid,"drugoffer");
			if(GetPVarInt(offer,"drugoffee") == playerid) {
				DeletePVar(playerid,"drugoffee");
				DeletePVar(playerid,"drugoffer");
				DeletePVar(playerid,"drugprice");
				DeletePVar(offer,"drugoffee");

				new string[128];
				format(string, sizeof(string), "Вы отказались от покупки наркотиков у игрока %s", player_name[offer]);
				SendOk(playerid, string);
				format(string, sizeof(string), "%s отказался от покупки наркотиков", player_name[playerid]);
				SendOk(offer, string);
			}
		}
		else if(GetPVarInt(playerid, "gunoffee") == playerid && GetPVarInt(playerid,"gunoffer") != playerid) {
			new offer = GetPVarInt(playerid,"gunoffer");
			if(GetPVarInt(offer,"gunoffee") == playerid) {
				DeletePVar(playerid,"gunoffee");
				DeletePVar(playerid,"gunoffer");
				DeletePVar(playerid,"gunprice");
				DeletePVar(offer,"gunoffee");

				new string[128];
				format(string, sizeof(string), "Вы отказались от покупки оружия у игрока %s", player_name[offer]);
				SendOk(playerid, string);
				format(string, sizeof(string), "%s отказался от покупки оружия", player_name[playerid]);
				SendOk(offer, string);
			}
		}
		else if(GetPVarInt(playerid, "ZoneOffer")) {
			SendOk(GetPVarInt(playerid,"ZoneOffer")-1, "Игрок отказался от покупки территории");
			SendOk(playerid, "Вы отказались от покупки территории");
			DeletePVar(playerid,"ZoneOffer");
			DeletePVar(playerid,"ZonePrice");
			DeletePVar(playerid,"sellzone");
		}
		else if(GetPVarInt(playerid, "sim_id_sell")) {
			SendOk(GetPVarInt(playerid, "sim_id_sell")-1, "Игрок отказался от покупки SIM-карты");
			SendOk(playerid, "Вы отказались от покупки SIM-карты");
			DeletePVar(playerid, "sim_id_sell");
			DeletePVar(playerid, "sim_summ");
		}
		else if(GetPVarInt(playerid,"bizzProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"bizzProdaet")-1;
			new id_pokupaet = GetPVarInt(id_prodaet,"bizzPokupaet")-1;
			SendOk(playerid,"Вы отказались от покупки бизнеса");
			SendOk(id_prodaet,"Игрок отказался от покупки Вашего бизнеса");
			DeletePVar(playerid,"bizzProdaet");
			DeletePVar(playerid,"bizzCena");
			DeletePVar(id_pokupaet,"bizzPokupaet");
		}
		else if(GetPVarInt(playerid,"hotelProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"hotelProdaet")-1;
			new id_pokupaet = GetPVarInt(id_prodaet,"hotelPokupaet")-1;
			SendOk(playerid,"Вы отказались от покупки отеля");
			SendOk(id_prodaet,"Игрок отказался от покупки Вашего отеля");
			DeletePVar(playerid,"hotelProdaet");
			DeletePVar(playerid,"hotelCena");
			DeletePVar(id_pokupaet,"hotelPokupaet");
		}
		else if(GetPVarInt(playerid,"airProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"airProdaet")-1;
			new id_pokupaet = GetPVarInt(id_prodaet,"airPokupaet")-1;
			SendOk(playerid,"Вы отказались от покупки аэропорта");
			SendOk(id_prodaet,"Игрок отказался от покупки Вашего аэропорта");
			DeletePVar(playerid,"airProdaet");
			DeletePVar(playerid,"airCena");
			DeletePVar(id_pokupaet,"airPokupaet");
		}
		else if(GetPVarInt(playerid,"houseSeller")) {
			new id_prodaet = GetPVarInt(playerid,"houseSeller")-1;
			SendOk(playerid,"Вы отказались от покупки дома");
			SendOk(id_prodaet,"Игрок отказался от покупки Вашего дома");
			DeletePVar(playerid,"houseSeller");
			DeletePVar(playerid,"housePrices");
			DeletePVar(id_prodaet,"houseBuyer");
		}
		else if(GetPVarInt(playerid,"carProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"carProdaet")-1;
			SendOk(playerid,"Вы отказались от предложения на обмен транспортом");
			SendOk(id_prodaet,"Игрок отказался от предложения на обмен транспортом");
			change_carcancel(playerid,id_prodaet);
			return 1;
		}
		else if(TI[playerid][tTazers][2] != -1) {
			new target = TI[playerid][tTazers][2];
			if(IsPlayerStream(2.0, playerid, target)) callcmd::cuff(playerid, IntToStr(target));
			TI[target][tTazers][2] = -1;
			TI[playerid][tTazers][2] = -1;
		}
	}
	if(PRESSED(KEY_YES)) {
		// if(TI[playerid][tProcess][0] != -1) {
		// 	if(GetPVarInt(playerid,"Klavisha") == 65536) MyButtonSystem(playerid);
		// 	else {
		// 		TI[playerid][tProcess][0] += -(3*(10/TI[playerid][tProcess][1]));
		// 		RandomYareNforJOBS(playerid);
		// 	}
		// 	return true;
		// }
		if(TI[playerid][tDiceID] != INVALID_PLAYER_ID)
		{
			new id = TI[playerid][tDiceID];
			new ids = TI[id][tDiceIDs];
			new money = TI[playerid][tDiceMoney];
			TI[playerid][tDiceID] = TI[id][tDiceIDs] = INVALID_PLAYER_ID;
			TI[playerid][tDiceMoney] = 0;
			TI[playerid][tDiceClosed] = TI[id][tDiceClosed] = false;
			if(ids != playerid) return ErrorMessage(playerid,"Игрок покинул игру");
			if(!TI[id][tLogin]) return ErrorMessage(playerid,"Игрок который хотел с Вами играть оффлайн");
			else if(PI[playerid][pCash] < money) {
				ErrorMessage(playerid,"У Вас недостаточно средств");
				SendOk(id,"У игрока недостаточно средств");
				return 1;
			}
			else if(PI[id][pCash] < money) {
				SendOk(playerid,"У игрока недостаточно средств");
				ErrorMessage(id,"У Вас недостаточно средств");
				return 1;
			}
			else if(!PlayerToPoint(2.5,playerid,2080.7615, 1710.6829, 1113.5668) &&
					!PlayerToPoint(2.5,playerid,2073.6392, 1710.6829, 1113.5668) &&
					!PlayerToPoint(2.5,playerid,2067.1243, 1710.6829, 1113.5668)) {
				ErrorMessage(playerid, "Вы не у стола для игры 1x1");
				SendOk(id,"Игрок отклонил Ваше предложение");
				return 1;
			}
			new dice = random(6)+1;
			new dice1 = random(6)+1;
			new string[128];
			format(string,sizeof(string), "%s и %s бросили кости. Результат: {CC9900}%i:%i",player_name[id],player_name[playerid],dice,dice1);
			ProxDetector(15.0,playerid, string,0x44b2ffff);
			SetTimerEx("DiceOff",5000, false, "i",playerid);
			SetTimerEx("DiceOff",5000, false, "i",id);
			TI[id][tKubik] = 1;
			TI[playerid][tKubik] = 1;
			TI[playerid][tDiceTime] = TI[id][tDiceTime] = unix+10;
			format(string,sizeof(string), "Выпало: %i",dice1);
			SetPlayerChatBubble(playerid,string,COLOR_ORANGE,30.0,10000);
			format(string,sizeof(string), "Выпало: %i",dice);
			SetPlayerChatBubble(id,string,TEAM_GROVE_COLOR,30.0,10000);
			ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,1,1,1,1,1);
			SetPlayerAttachedObject(playerid, 1, 1851, 1, 0.062400, 0.453750, 0.000000, 0.000000, 94.689310, 0.000000);
			ApplyAnimation(id,"CARRY","crry_prtial",4.0,1,1,1,1,1,1);
			SetPlayerAttachedObject(id, 1, 1851, 1, 0.062400, 0.453750, 0.000000, 0.000000, 94.689310, 0.000000);

			if(dice > dice1) {
				GiveMoney(id,money,"выиграл в dice");
				GiveMoney(playerid,-money,"проиграл в dice");
				format(string, sizeof(string), "Поздравляем, Вы выиграли! Выигрыш составляет: "GREEN"$%d",money);
				SendClientMessage(id, CGOLD, string);
				SendOk(playerid, "К сожалению, Вы проиграли");
			}
			if(dice < dice1) {
				GiveMoney(playerid,money,"выиграл в dice");
				GiveMoney(id,-money,"проиграл в dice");
				format(string, sizeof(string), "Поздравляем, Вы выиграли! Выигрыш составляет: "GREEN"$%d",money);
				SendClientMessage(playerid, CGOLD, string);
				SendOk(id, "К сожалению, Вы проиграли");
			}
			else if(dice == dice1) {
				SendOk(playerid, "Игра закончилась в ничью");
				SendOk(id, "Игра закончилась в ничью");
			}
		}
		else if(GetPVarInt(playerid,"race_offer"))
		{
			new i = GetPVarInt(playerid,"race_offer")-1;
			if(PI[i][pCash] < TI[playerid][tRaceMoney] || PI[playerid][pCash] < TI[playerid][tRaceMoney]) {
				ErrorMessage(playerid,"У Игрока/Вас недостаточно средств");
				DeletePVar(playerid,"race_offer");
				return 1;
			}
			if(!ProxDetectorS(5.0, playerid, i)) {
				ErrorMessage(playerid,"Игрок слишком далеко от Вас");
				DeletePVar(playerid,"race_offer");
				return 1;
			}
			if(GetPlayerState(i) != PLAYER_STATE_DRIVER || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
				ErrorMessage(playerid,"Игрок/Вы не за рулём Т/С");
				DeletePVar(playerid,"race_offer");
				return 1;
			}
			new rand = random(sizeof(race_checkpoint));
			TI[playerid][tRaceCP] = CreateDynamicCP(race_checkpoint[rand][0],race_checkpoint[rand][1],race_checkpoint[rand][2], 2.0,0,0,playerid);
			EnableGPSForPlayer(playerid,race_checkpoint[rand][0],race_checkpoint[rand][1],race_checkpoint[rand][2]);
			TI[i][tRaceCP] = CreateDynamicCP(race_checkpoint[rand][0],race_checkpoint[rand][1],race_checkpoint[rand][2], 2.0,0,0,i);
			EnableGPSForPlayer(i,race_checkpoint[rand][0],race_checkpoint[rand][1],race_checkpoint[rand][2]);
			SendClientMessage(playerid, COLOR_YELLOW, "Внимание! Место финиша уличных гонок отмечено в Вашем GPS");
			SendClientMessage(i, COLOR_YELLOW, "Внимание! Место финиша уличных гонок отмечено в Вашем GPS");
			TI[playerid][tRaceID] = i;
			TI[i][tRaceID] = playerid;
			TI[playerid][tRaceLeftStartTime] = 10;
			TI[i][tRaceLeftStartTime] = 10;
			TogglePlayerControllable(i, false);
			TogglePlayerControllable(playerid, false);

			GameTextForPlayer(playerid, "~r~10", 5000, 3);
			GameTextForPlayer(i, "~r~10", 5000, 3);

			GiveMoney(playerid,-TI[playerid][tRaceMoney],"взнос уличные гонки");
			GiveMoney(i,-TI[playerid][tRaceMoney],"взнос уличные гонки");
			DeletePVar(playerid,"race_offer");
			return 1;
		}
		else if(GetPVarInt(playerid,"lices")) {
			new acter = GetPVarInt(playerid,"lices")-1;
			DeletePVar(playerid,"lices");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowLic(acter,playerid);
					new string[128];
					format(string,sizeof(string),"показал(а) свои лицензии %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"skillss")) {
			new acter = GetPVarInt(playerid,"skillss")-1;
			DeletePVar(playerid,"skillss");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowSkill(acter,playerid);
					new string[128];
					format(string,sizeof(string),"показал(а) навыки владения оружием %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"wbook")) {
			new acter = GetPVarInt(playerid,"wbook")-1;
			DeletePVar(playerid,"wbook");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowWBook(acter,playerid);
					new string[128];
					format(string,sizeof(string),"показал(а) трудовую книжку %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"uds")) {
			new acter = GetPVarInt(playerid,"uds")-1;
			DeletePVar(playerid,"uds");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowUd(acter,playerid);
					new string[128];
					format(string,sizeof(string),"достал(а) удостоверение и показал(а) его %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"udjur")) {
			new acter = GetPVarInt(playerid,"udjur")-1;
			DeletePVar(playerid,"udjur");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowUdJur(acter,playerid);
					new string[128];
					format(string,sizeof(string),"достал(а) удостоверение журналиста и показал(а) его %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"pass")) {
			new acter = GetPVarInt(playerid,"pass")-1;
			DeletePVar(playerid,"pass");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowPass(acter,playerid);
					new string[128];
					format(string,sizeof(string),"достал(а) паспорт и показал(а) его %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"fpass")) {
			new acter = GetPVarInt(playerid,"fpass")-1;
			DeletePVar(playerid,"fpass");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowFPass(acter,playerid);
					new string[128];
					format(string,sizeof(string),"достал(а) паспорт и показал его %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"medcard")) {
			new acter = GetPVarInt(playerid,"medcard")-1;
			DeletePVar(playerid,"medcard");
			if(acter >= 0) {
				if(IsPlayerConnected(playerid) && IsPlayerConnected(acter)) {
					ShowMedcard(acter,playerid);
					new string[128];
					format(string,sizeof(string),"достал(а) мед.карту и показал ее %s",player_name[playerid]);
					MeAction(acter,string);
				}
			}
		}
		else if(GetPVarInt(playerid,"taxi_id")) {
			new bizz = GetPVarInt(playerid,"taxi_id");
			DeletePVar(playerid,"taxi_id");
			if(PI[playerid][bizz_work] == 2 || PI[playerid][bizz_work] == 3 || PI[playerid][bizz_work] == 4) return ErrorMessage(playerid, "Вы уже работаете в таксопарке");
			if(PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7) return ErrorMessage(playerid, "Вы работаете в транспортной компании");
			if(info_funcmembers(bizz) >= 50) return ErrorMessage(playerid,"В таксопарке нет свободных мест");
			PI[playerid][bizz_work] = bizz;
			UpdatePlayerData(playerid,"bizz_work",PI[playerid][bizz_work]);
			PI[playerid][bizz_status] = 1;
			UpdatePlayerData(playerid,"bizz_status",1);
			PI[playerid][bizz_cash] = 0;
			UpdatePlayerData(playerid,"bizz_cash",0);
			new string[100];
			format(string,sizeof(string),"[TAXI] %s вступил в таксопарк",player_name[playerid]);
			BizzMSG(bizz,COLOR_YELLOW,string);
		}
		else if(GetPVarInt(playerid,"tk_id")) {
			new bizz = GetPVarInt(playerid,"tk_id");
			DeletePVar(playerid,"tk_id");
			if(PI[playerid][bizz_work] == 2 || PI[playerid][bizz_work] == 3 || PI[playerid][bizz_work] == 4) return ErrorMessage(playerid, "Вы работаете в таксопарке");
			if(PI[playerid][bizz_work] == 5 || PI[playerid][bizz_work] == 6 || PI[playerid][bizz_work] == 7) return ErrorMessage(playerid, "Вы уже работаете в транспортной компании");
			if(info_funcmembers(bizz) >= 50) return ErrorMessage(playerid,"В транспортной компании нет свободных мест");
			PI[playerid][bizz_work] = bizz;
			UpdatePlayerData(playerid,"bizz_work",PI[playerid][bizz_work]);
			PI[playerid][bizz_status] = 1;
			UpdatePlayerData(playerid,"bizz_status",1);
			PI[playerid][bizz_cash] = 0;
			UpdatePlayerData(playerid,"bizz_cash",0);
			PI[playerid][bizz_lcash] = 0;
			UpdatePlayerData(playerid,"bizz_lcash",0);

			PI[playerid][pSettings][3] = 1;
			save_settings(playerid);

			new string[100];
			format(string,sizeof(string),"[TRUCK] %s вступил в транспортную компанию",player_name[playerid]);
			BizzMSG(bizz,COLOR_YELLOW,string);
		}
		else if(GetPVarInt(playerid,"selectpoint") == 2) {
			new driverid = GetPVarInt(playerid,"taxidriver");
			if(GetPlayerState(playerid) != PLAYER_STATE_PASSENGER || VehicleInfo[GetPlayerVehicleID(playerid)][vBizz] != PI[driverid][bizz_work]) {
				SetPVarInt(playerid,"selectpoint",0);
				SetPVarInt(playerid,"taxidriver",0);
				RemovePlayerMapIcon(playerid,iconTaxi);
			}
			new Float:x, Float:y;
			x = GetPVarFloat(playerid,"selectpointX");
			y = GetPVarFloat(playerid,"selectpointY");
			SetPlayerMapIcon(driverid,iconTaxi,x,y,0.0,0,COLOR_YELLOW,1);
			SetPVarFloat(playerid,"selectpointX",x);
			SetPVarFloat(playerid,"selectpointY",y);
			SetPVarInt(playerid,"selectpoint",0);
			SetPVarInt(driverid,"selectpoint",0);
			SendOk(playerid,"Данные о месте назначения отправлены таксисту");
			SendUse(driverid,"Пассажир установил "YELLOW"метку "G"на карте");
		}
		else if(GetPVarInt(playerid,"family_invite")) {
			new fam = GetPVarInt(playerid,"family_invite")-1;
			DeletePVar(playerid,"family_invite");
			if(PI[fam][pFamily]) {
				new string[128];
				PI[playerid][pFamily] = PI[fam][pFamily];
				UpdatePlayerData(playerid,"family",PI[playerid][pFamily]);
				PI[playerid][pFamRank] = 1;
				UpdatePlayerData(playerid,"pFamRank",1);

				format(string,sizeof(string),"[FAMILY] "W"%s{%s} вступил в семью",player_name[playerid],FamilyColor[gFamily[PI[playerid][pFamily]-1][famColor]]);
				FamMSG(PI[playerid][pFamily],string);
			}
		}
		else if(GetPVarInt(playerid,"fight_offer")) {
			new i = GetPVarInt(playerid,"fight_offer")-1;
			if(PI[i][pCash] < GetPVarInt(playerid,"fight_price") || PI[playerid][pCash] < GetPVarInt(playerid,"fight_price")) {
				ErrorMessage(playerid,"У Игрока/Вас недостаточно средств");
				DeletePVar(playerid,"fight_offer");
				DeletePVar(playerid,"fight_price");
				return 1;
			}
			if(!ProxDetectorS(5.0, playerid, i)) {
				ErrorMessage(playerid,"Игрок слишком далеко от Вас");
				DeletePVar(playerid,"fight_offer");
				DeletePVar(playerid,"fight_price");
				return 1;
			}
			if(!TI[playerid][tGym] || !TI[i][tGym]) {
				ErrorMessage(playerid,"Вы/Игрок не в спортзале");
				DeletePVar(playerid,"fight_offer");
				DeletePVar(playerid,"fight_price");
				return 1;
			}
			if(TOTALSTYLELIST > 4) {
				ErrorMessage(playerid,"Очередь заполнена");
				DeletePVar(playerid,"fight_offer");
				DeletePVar(playerid,"fight_price");
				return 1;
			}
			RingInfo[TOTALSTYLELIST][rgPlayer][0] = playerid;
			RingInfo[TOTALSTYLELIST][rgPlayer][1] = i;
			RingInfo[TOTALSTYLELIST][rgState] = 1;
			RingInfo[TOTALSTYLELIST][rgTime] = 60;
			RingInfo[TOTALSTYLELIST][rgPrice] = GetPVarInt(playerid,"fight_price");
			TOTALSTYLELIST++;
			new string[156];
			format(string,sizeof(string),""G"Вы записались на бой. Противник "W"%s."G" Ставка: "ORANGE"$%i",player_name[i],GetPVarInt(playerid,"fight_price"));
			SendOk(playerid,string);

			SendClientMessage(playerid,CGOLD,"При появлении таймера на экране, займите место на ринге");

			format(string,sizeof(string),""W"%s"G" принял ваше предложение. Ставка: "ORANGE"$%i",player_name[playerid], GetPVarInt(playerid,"fight_price"));
			SendOk(i,string);
			SendClientMessage(i,CGOLD,"При появлении таймера на экране, займите место на ринге");
			DeletePVar(playerid,"fight_offer");
			DeletePVar(playerid,"fight_price");
			return 1;
		}
		else if(GetPVarInt(playerid, "invstat") == playerid) {
			new pltot = GetPVarInt(playerid, "invinv");
			new skinid = GetPVarInt(playerid, "invskin");
			DeletePVar(playerid, "invinv");
			DeletePVar(playerid, "invskin");
			SetPVarInt(playerid, "invstat",-1);
			if(!IsPlayerConnected(pltot)) return ErrorMessage(playerid,"Игрок пригласивший Вас в организацию оффлайн");
			new fractionid = PI[pltot][pMember];
			PI[playerid][pMember] = fractionid;
			PI[playerid][pRank] = 1;
			PI[playerid][pFracSkin] = skinid;
			PI[playerid][pJob] = 0;
			start_work[playerid] = 1;
			PI[playerid][pSpawn] = FRACTION_SPAWN;
			SaveAccount(playerid);
			PI[playerid][pfWarn] = 0;
			UpdatePlayerData(playerid,"fwarn",0);
			PI[playerid][pFMute] = 0;
			UpdatePlayerData(playerid,"pFMute",PI[playerid][pFMute]);
			SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
			new string[128];
			format(string,sizeof(string),""P"%s"G" был принят в Вашу организацию",player_name[playerid]);
			SendUse(pltot,string);
			format(string,sizeof(string),"Вы были приняты во фракцию "W"%s",FI[PI[playerid][pMember]][fName]);
			SendOk(playerid,string);
			A_SetPlayerSkin(playerid, PI[playerid][pFracSkin]);
			add_datefrac(playerid);

			FracLog(LOGS_INVITE,player_name[pltot],player_name[playerid],"invite");
		}
		else if(GetPVarInt(playerid, "sellbizmafia_seller"))
		{
			new bizid = GetPVarInt(playerid, "sellbizmafia_business");
			new seller_id = GetPVarInt(playerid, "sellbizmafia_seller");
			if(!IsPlayerConnected(seller_id)) return ErrorMessage(playerid,"Данный игрок оффлайн");
			if(!IsPlayerStream(4.0, playerid, seller_id)) return ErrorMessage(playerid, "Игрок далеко от Вас");

			gBusiness[bizid][bizzMafia] = PI[playerid][pMember];
			UpdateBusinessText(bizid);

			new mafia_string[142];
			format(mafia_string, sizeof(mafia_string), "%s мафия купила контроль над бизнесом %s у %s мафии",
			GetMN(PI[playerid][pMember]), gBusiness[bizid][bizzName], GetMN(PI[seller_id][pMember]));

			SendMafia(0x54548CFF, mafia_string);
			DeletePVar(playerid, "sellbizmafia_seller");
			DeletePVar(playerid, "sellbizmafia_business");

		}
		else if(HealOffer[playerid] != INVALID_PLAYER_ID) {
			if(!IsPlayerConnected(HealOffer[playerid])) return ErrorMessage(playerid,"Игрок предложивший Вам лечение оффлайн"),HealOffer[playerid] = INVALID_PLAYER_ID;
			if(PI[playerid][pCash] < HealPrice[playerid]) {
				ErrorMessage(playerid, "У Вас нет столько денег");
				static const f_str[] = "У %s недостаточно денежных средств для лечения";
				new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];
				format(string,sizeof(string),f_str,player_name[playerid]);
				SendOk(HealOffer[playerid],string);
				HealOffer[playerid] = INVALID_PLAYER_ID;
				return 1;
			}
			SetPlayerHealth(playerid, 100.0);

			static const f_str_1[] = "Доктор "P"%s"G" вылечил вас за "ORANGE"$%d";
			new string_1[sizeof(f_str_1) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];

			format(string_1,sizeof(string_1),f_str_1,player_name[HealOffer[playerid]],HealPrice[playerid]);
			SendUse(playerid,string_1);

			GiveMoney(playerid, -HealPrice[playerid], "оплата за лечение медику");

			new price = floatround(HealPrice[playerid]*0.2);
			FI[fWHITEHOUSE][fBank] += floatround(HealPrice[playerid] - price);
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			static const f_str_2[] = "Вы вылечили "P"%s"G" за "ORANGE"$%d";
			new string_2[sizeof(f_str_2) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];

			format(string_2,sizeof(string_2),f_str_2,player_name[playerid],price);
			SendUse(HealOffer[playerid],string_2);
			GiveMoney(HealOffer[playerid], price,"оплата за лечение игрока");

			PI[HealOffer[playerid]][pMedHeal] ++;

			HealOffer[playerid] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(GetPVarInt(playerid,"gunoffee") == playerid && GetPVarInt(playerid,"gunoffer") != playerid) {
			new offer = GetPVarInt(playerid,"gunoffer");
			new price = GetPVarInt(playerid,"gunprice");
			new needammo = GetPVarInt(playerid,"gunammo");
			new weaponid = GetPVarInt(playerid,"gunid");
			if(GetPVarInt(offer,"gunoffee") == playerid) {
				DeletePVar(playerid,"gunoffee");
				DeletePVar(playerid,"gunoffer");
				DeletePVar(playerid,"gunammo");
				DeletePVar(playerid,"gunprice");
				DeletePVar(playerid,"gunid");
				DeletePVar(offer,"gunoffee");
				new slot = GetWeaponSlot(weaponid);
				new weapon,ammo;
				GetPlayerWeaponData(offer,slot,weapon,ammo);
				if(weapon != weaponid || ammo < needammo) return ErrorMessage(playerid,"У продавца закончилось оружие");
				new remain = ammo - needammo;
				if(remain > ammo) return 1;
				if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
				AC_GivePlayerWeapon(playerid,weaponid,needammo);
				//AC_SetPlayerAmmo(offer,weaponid,remain);
				AC_GivePlayerWeapon(offer,weaponid,-needammo);
				SetPlayerArmedWeapon(offer,0);

				GiveMoney(offer, price, "продажа оружия");
				GiveMoney(playerid, -price, "покупка оружия");

				if(QuestProgress[offer][14] < 10 && AcceptQuest[offer][14] != 0) QuestProgress[offer][14] ++,save_quest(offer,14);
				if(QuestProgress[offer][14] == 10 && AcceptQuest[offer][14] != 0) {
					D(offer,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно продали 10ед оружия. Данное задание можно завершить и забрать за него награду","Закрыть","");
					NextStapQI(offer,14);
				}
				new mes[128];
				format(mes,sizeof(mes),"продал(а) оружие %s",player_name[playerid]);
				MeAction(offer,mes);
			}
		}
		else if(GetPVarInt(playerid,"drugoffee") == playerid && GetPVarInt(playerid,"drugoffer") != playerid) {
			new offer = GetPVarInt(playerid,"drugoffer");
			new price = GetPVarInt(playerid,"drugprice");
			new value = GetPVarInt(playerid,"drugvalue");
			if(GetPVarInt(offer,"drugoffee") == playerid) {
				DeletePVar(playerid,"drugoffee");
				DeletePVar(playerid,"drugoffer");
				DeletePVar(playerid,"drugvalue");
				DeletePVar(playerid,"drugprice");
				DeletePVar(offer,"drugoffee");
				if(PI[playerid][pDrugs]+value > vip_status[PI[playerid][pVips]][vip_drugs]) return ErrorMessage(playerid, "Вы не можете хранить так много наркотиков");
				if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid, "У Вас недостаточно средств");

				GiveMoney(offer, price, "продажа нарко");
				GiveMoney(playerid, -price, "покупка нарко");
				PI[playerid][pDrugs] += value;
				PI[offer][pDrugs] -= value;
				UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
				UpdatePlayerData(offer,"pDrugs",PI[offer][pDrugs]);

				new string[137];
				format(string,sizeof(string),""P"%s"G" передал Вам "W"%d"G" грамм наркотиков за "ORANGE"$%d",player_name[offer],value,price);
				SendUse(playerid,string);
				format(string,sizeof(string),"Вы передали "P"%d"G" грамм наркотиков игроку "W"%s"G" за "ORANGE"$%d",value,player_name[playerid],price);
				SendUse(offer,string);
				ApplyAnimation(playerid,"DEALER","shop_pay",4.1, 0, 1, 1, 0, 0, 1);
				ApplyAnimation(offer,"DEALER","shop_pay",4.1, 0, 1, 1, 0, 0, 1);
			}
		}
		else if(GetPVarInt(playerid,"ZoneOffer")) {
			new price = GetPVarInt(playerid,"ZonePrice");
			new offter = GetPVarInt(playerid,"ZoneOffer")-1;
			new sell = GetPVarInt(playerid,"sellzone");
			DeletePVar(playerid,"ZoneOffer");
			DeletePVar(playerid,"ZonePrice");
			DeletePVar(playerid,"sellzone");
			if(!IsPlayerConnected(offter)) return ErrorMessage(playerid,"Игрок предложивший Вам купить территорию оффлайн");
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid, "У Вас не достаточно денег");
			IDGZ[playerid] = GetIDGZ(playerid);
			if(IDGZ[playerid] != -1) {
				new i = IDGZ[playerid];
				if(GZInfo[i][gFrakVlad] != sell) return ErrorMessage(playerid, "Вам не предлагали купить эту территорию");
				VladGzone[GZInfo[i][gFrakVlad]]--;
				VladGzone[PI[playerid][pMember]]++;
				GZInfo[i][gFrakVlad] = PI[playerid][pMember];
				GangZoneStopFlashForAll(GZInfo[i][gID]);
				GangZoneHideForAll(GZInfo[i][gID]);
				GangZoneShowForAll(GZInfo[i][gID],GetGangZoneColor(i));
				SaveGZ(i);
			}

			new string[137];
			format(string,sizeof(string),""P"%s"G" купил у Вас территорию за "ORANGE"$%d",player_name[playerid],price);
			SendUse(offter,string);
			format(string,sizeof(string),"Вы купили территорию у "P"%s"G" за "ORANGE"$%d",player_name[offter], price);
			SendUse(playerid,string);
			GiveMoney(offter,price, "продажа территории");
			GiveMoney(playerid, -price, "покупка территории");
		}
		else if(GetPVarInt(playerid,"hi")) {
			new hi = GetPVarInt(playerid,"hi")-1;
			if(!IsPlayerConnected(hi)) return ErrorMessage(playerid,"Игрок который хотел пожать Вам руку оффлайн");
			new Float:angle,string[128];
			GetPlayerFacingAngle(hi, angle);
			SetPlayerFacingAngle(playerid, angle + 180);
			ApplyAnimation(hi,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
			ApplyAnimation(playerid,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
			format(string, sizeof(string), "пожал(а) руку %s'у", player_name[playerid]);
			MeAction(hi,string, 5.0);
			DeletePVar(playerid,"hi");
			if(PI[hi][pDisease][0] && !PI[playerid][pDDisease]) {
				new rand = random(7);
				if(rand > 2) return 1;
				PI[playerid][pDisease][0] = 1;
				UpdatePlayerData(playerid,"pDisease_0",1);
				SendOk(playerid,"Игрок, которому Вы пожали руку был болен");
				SendOk(playerid,"Советуем Вам обратиться к медикам в любую из больниц");
				SendOk(playerid,"(( Внимание! Состояние Вашей жизни (HP) будет падать значительно быстрее ))");
			}
		}
		else if(GetPVarInt(playerid,"kiss")) {
			new kiss = GetPVarInt(playerid,"kiss")-1;
			if(!IsPlayerConnected(kiss)) return ErrorMessage(playerid,"Игрок который хотел поцеловать Вас оффлайн");
			if(!IsPlayerStream(4.0, playerid, kiss)) return ErrorMessage(playerid, "Игрок далеко от Вас");
			else {
				SetPosInFrontOfPlayer(kiss,playerid,1);
				new Float:a;
				GetPlayerFacingAngle(kiss,a);
				SetPlayerFacingAngle(playerid,180 + a);
				ApplyAnimation(kiss,"BD_FIRE","GRLFRD_KISS_03",4.0,0,0,0,0,0,1);
				ApplyAnimation(playerid,"BD_FIRE","PLAYA_KISS_03",4.0,0,0,0,0,0,0);
				DeletePVar(playerid,"kiss");
				SetPVarInt(kiss, "callcmd::kiss", unix+15);
				SetPVarInt(playerid, "callcmd::kiss", unix+15);
				if(PI[kiss][pDisease][0] && !PI[playerid][pDDisease]) {
					new rand = random(7);
					if(rand > 2) return 1;
					PI[playerid][pDisease][0] = 1;
					UpdatePlayerData(playerid,"pDisease_0",1);
					SendOk(playerid,"Игрок, с которым Вы поцеловались был болен");
					SendOk(playerid,"Советуем Вам обратиться к медикам в любую из больниц");
					SendOk(playerid,"(( Внимание! Состояние Вашей жизни (HP) будет падать значительно быстрее ))");
				}
			}
		}
		else if(GetPVarInt(playerid,"repairoffee") == playerid && GetPVarInt(playerid,"repairoffer") != playerid) {
			new offer = GetPVarInt(playerid,"repairoffer");
			new price = GetPVarInt(playerid,"repairprice");
			if(GetPVarInt(offer,"repairoffee") == playerid) {
				SetPVarInt(playerid,"repairoffee",-1);
				SetPVarInt(playerid,"repairoffer",-1);
				DeletePVar(playerid,"repairprice");
				DeletePVar(offer,"repairoffee");
				new vehicleid = GetPlayerVehicleID(playerid);
				if(!vehicleid) return ErrorMessage(playerid,"Вы должны быть в автомобиле");
				if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У вас недостаточно средств");

				GiveMoney(offer, price, "механик отремонтировал");
				GiveMoney(playerid, -price, "отремонтировался у механика");
				SetVehicleHealth(vehicleid,1000.0);
				RepairVehicle(vehicleid);
				new string[137];
				format(string,sizeof(string),"Механик "P"%s"G" отремонтировал Вам транспорт за "ORANGE"$%d",player_name[offer],price);
				SendUse(playerid,string);
				format(string,sizeof(string),"Вы отремонтировали транспорт игроку "P"%s"G" за "ORANGE"$%d",player_name[playerid],price);
				SendUse(offer,string);
			}
		}
		else if(GetPVarInt(playerid, "sim_id_sell")) {
			new sell_sim_id = GetPVarInt(playerid, "sim_id_sell")-1;
			new sell_sim_sum = GetPVarInt(playerid, "sim_summ");
			new string[120];
			format(string,sizeof(string),"Вы действительно хотите приобрели SIM-карту у "P"%s "G"за "ORANGE"$%i?", player_name[sell_sim_id],sell_sim_sum);
			D(playerid, D_SELL_SIM, DSM, ""P"Покупка SIM-карты", string, "Да", "Нет");
		}
		else if(GetPVarInt(playerid,"bizzProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"bizzProdaet")-1;
			new id = PI[id_prodaet][pBusiness]-1;
			new status[20];
			new atext[24];
			switch(gBusiness[id][bizzMafia]) {
				case fRM: atext = "Русская Мафия";
				case fLCN: atext = "Итальянская мафия";
				case fYAKUZA: atext = "Японская мафия";
				default: atext = "---";
			}
			new type = gBusiness[id][bizzType] - 1;
			if(gBusiness[id][bizzStatus]) strcat(status,"{7FB151}Работает");
			else strcat(status,"{FF4242}Не работает");

			new day;
			day = (gBusiness[id][bizzDay]-gettime())/86400;

			static const f_str[] = ""W"Название: "O"%s\n\n\
									"W"Тип: "O"%s\n\
									"W"Гос.стоимость: "GREEN"$%d\n\
									"W"Цена товара: "GREEN"$%d\n\n\
									"W"Продуктов: "O"%d ед.\n\
									"W"Продуктов заказано: "O"%d"W" ед. ["GREEN"$%d"W" за ед]\n\n\
									"W"Касса: "GREEN"$%d"W"\n\
									"W"Заработано за сутки: "GREEN"$%d"W"\n\n\
									"W"Посетителей: "O"%d\n\
									"W"Аренда бизнеса: "O"%iд\n\
									"W"Крыша: "O"%s\n\
									"W"Состояние: "O"%s\n\n\
									"W"Вы действительно хотите купить данный бизнес за "GREEN"$%d?";
			new string[700];
			format(string,sizeof(string),f_str,gBusiness[id][bizzName],gBusinessTypeName[type],
				gBusiness[id][bizzSellPrice],gBusiness[id][bizzPrice],gBusiness[id][bizzProduct],gBusiness[id][bizzProdOrder],gBusiness[id][bizzProdOrderPrice],gBusiness[id][bizzBank],gBusiness[id][bizzBankDay]
				,gBusiness[id][bizzVisitors],day,atext,status,GetPVarInt(playerid,"bizzCena"));

			D(playerid,D_BIZZ_BUY_2,DSM, ""P"Покупка бизнеса",string,"Купить","Отмена");
		}
		else if(GetPVarInt(playerid,"hotelProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"hotelProdaet")-1;
			new id = PI[id_prodaet][pHotel]-1;

			new day;
			day = (gHotels[id][hotelDay]-gettime())/86400;

			static const f_str[] = ""W"Название: "O"%s\n\n\
									"W"Гос.стоимость: "GREEN"$%d\n\
									"W"Касса: "GREEN"$%d"W"\n\
									"W"Заработано за сутки: "GREEN"$%d"W"\n\
									"W"Посетителей: "O"%d\n\
									"W"Аренда отеля: "O"%iд\n\n\
									"W"Вы действительно хотите купить данный отель за "GREEN"$%d";
			new string[700];
			format(string,sizeof(string),f_str,gHotels[id][hotelName],gHotels[id][hotelPrice],gHotels[id][hotelBank],gHotels[id][hotelBankDay],gHotels[id][hotelVisitors],
				day,GetPVarInt(playerid,"hotelCena"));

			D(playerid,D_HOTEL_BUY_2,DSM, ""P"Покупка отеля",string,"Купить","Отмена");
		}
		else if(GetPVarInt(playerid,"airProdaet")) {
			new id_prodaet = GetPVarInt(playerid,"airProdaet")-1;
			new id = PI[id_prodaet][pAirport]-1;

			new day;
			day = (gAirs[id][airDay]-gettime())/86400;

			static const f_str[] = ""W"Название: "O"%s\n\n\
									"W"Гос.стоимость: "GREEN"$%d\n\
									"W"Касса: "GREEN"$%d"W"\n\
									"W"Аренда аэропорта: "O"%iд\n\n\
									"W"Вы действительно хотите купить данный аэропорт за "GREEN"$%d";
			new string[500];
			format(string,sizeof(string),f_str,gAirs[id][airName],gAirs[id][airPrice],gAirs[id][airBank],
				day,GetPVarInt(playerid,"airCena"));

			D(playerid,D_AIRPORT_BUY_2,DSM, ""P"Покупка аэропорта",string,"Купить","Отмена");
		}
		else if(GetPVarInt(playerid,"houseSeller")) {
			new id_prodaet = GetPVarInt(playerid,"houseSeller")-1;
			new id = PI[id_prodaet][pHouse]-1;

			new classname[20],status[12];
			switch(gHouses[id][houseClass]) {
				case 0:classname = "Эконом";
				case 1:classname = "Cредний";
				case 2:classname = "Элитный";
				case 3:classname = "Особняк";
				default: classname = "Неизвестно";
			}
			new cnt;
			for(new i;i<3;i++) {
				if(gHouses[id][houseHabitID][i]) cnt++;
			}
			if(gHouses[id][houseClose]) strcat(status,"Закрыт");
			else strcat(status,"Открыт");
			new improve[96];
			if(gHouses[id][houseImprove][0]) strcat(improve,"Автоматические двери\n");
			if(gHouses[id][houseImprove][1]) strcat(improve,"Снижение субсидий\n");
			if(gHouses[id][houseImprove][2]) strcat(improve,"Гараж\n");
			if(gHouses[id][houseImprove][0] == 0 && gHouses[id][houseImprove][1] == 0 && gHouses[id][houseImprove][2] == 0) strcat(improve,"Отсутствуют");

			new day;
			day = (gHouses[id][houseDay]-gettime())/86400;
			static const f_str[] = ""W"Номер дома: \t\t"O"%d\n\
									"W"Класс: \t\t\t"O"%s\n\
									"W"КОЛ-во жильцов: \t"O"%d/%d\n\
									"W"Аренда дома: \t\t"O"%iд\n\
									"W"Статус: \t\t"O"%s\n\
									"W"Гос. цена: \t\t"O"%d\n\n\
									"P"Улучшения:\n\
									"GREEN"%s\n\n\
									"W"Вы действительно хотите купить данный дом за "GREEN"$%d"W"?";
			new string[512];
			format(string,sizeof(string),f_str,id+1,classname,cnt,gHouses[id][houseClass],day,status,gHouses[id][housePrice],improve,GetPVarInt(playerid,"housePrices"));
			D(playerid,D_HOUSE_BUY_2,DSM, ""P"Покупка дома",string,"Купить","Отмена");
		}
		else if(GetPVarInt(playerid,"carProdaet") && GetPVarInt(playerid,"sellcar_type")) {
			new id_prodaet = GetPVarInt(playerid,"carProdaet")-1;
			new car_cena = GetPVarInt(playerid,"carCena");
			new car1 = GetPVarInt(id_prodaet,"numbercar1")-1;
			new car2 = GetPVarInt(id_prodaet,"numbercar2")-1;

			new improve[256];
			if(gPlayerCars[id_prodaet][carVehcom_1][car1]) strcat(improve,"\t\t\t[Спойлер]\n");
			if(gPlayerCars[id_prodaet][carVehcom_2][car1]) strcat(improve,"\t\t\t[Капот]\n");
			if(gPlayerCars[id_prodaet][carVehcom_3][car1]) strcat(improve,"\t\t\t[Воздухозаборник]\n");
			if(gPlayerCars[id_prodaet][carVehcom_4][car1]) strcat(improve,"\t\t\t[Боковая юбка]\n");
			if(gPlayerCars[id_prodaet][carVehcom_5][car1]) strcat(improve,"\t\t\t[Фары]\n");
			if(gPlayerCars[id_prodaet][carVehcom_6][car1]) strcat(improve,"\t\t\t[Нитро]\n");
			if(gPlayerCars[id_prodaet][carVehcom_7][car1]) strcat(improve,"\t\t\t[Выхлопная тFCа]\n");
			if(gPlayerCars[id_prodaet][carVehcom_8][car1]) strcat(improve,"\t\t\t[Диски]\n");
			if(gPlayerCars[id_prodaet][carVehcom_9][car1]) strcat(improve,"\t\t\t[Стерео]\n");
			if(gPlayerCars[id_prodaet][carVehcom_10][car1]) strcat(improve,"\t\t\t[Гидравлика]\n");
			if(gPlayerCars[id_prodaet][carVehcom_11][car1]) strcat(improve,"\t\t\t[Передний бампер]\n");
			if(gPlayerCars[id_prodaet][carVehcom_12][car1]) strcat(improve,"\t\t\t[Задний бампер]\n");

			new improve2[256];
			if(gPlayerCars[playerid][carVehcom_1][car2]) strcat(improve2,"\t\t\t[Спойлер]\n");
			if(gPlayerCars[playerid][carVehcom_2][car2]) strcat(improve2,"\t\t\t[Капот]\n");
			if(gPlayerCars[playerid][carVehcom_3][car2]) strcat(improve2,"\t\t\t[Воздухозаборник]\n");
			if(gPlayerCars[playerid][carVehcom_4][car2]) strcat(improve2,"\t\t\t[Боковая юбка]\n");
			if(gPlayerCars[playerid][carVehcom_5][car2]) strcat(improve2,"\t\t\t[Фары]\n");
			if(gPlayerCars[playerid][carVehcom_6][car2]) strcat(improve2,"\t\t\t[Нитро]\n");
			if(gPlayerCars[playerid][carVehcom_7][car2]) strcat(improve2,"\t\t\t[Выхлопная тFCа]\n");
			if(gPlayerCars[playerid][carVehcom_8][car2]) strcat(improve2,"\t\t\t[Диски]\n");
			if(gPlayerCars[playerid][carVehcom_9][car2]) strcat(improve2,"\t\t\t[Стерео]\n");
			if(gPlayerCars[playerid][carVehcom_10][car2]) strcat(improve2,"\t\t\t[Гидравлика]\n");
			if(gPlayerCars[playerid][carVehcom_11][car2]) strcat(improve2,"\t\t\t[Передний бампер]\n");
			if(gPlayerCars[playerid][carVehcom_12][car2]) strcat(improve2,"\t\t\t[Задний бампер]\n");

			new model1 = gPlayerCars[playerid][carModel][car2]-400;
			new model2 = gPlayerCars[id_prodaet][carModel][car1]-400;
			new classname[12];
			new classname2[12];
			GetCarClassName(gTransport[model1][trClass],classname);
			GetCarClassName(gTransport[model2][trClass],classname2);
			static const f_str[] = "\t\t\t"ORANGE"==== ИНФОРМАЦИЯ ====\n\n\
									"YELLOW"\t\t\tВаше авто:\n\n\
									"W"Марка авто: \t\t"P"%s\n\
									"W"Класс: \t\t\t"P"%s\n\
									"W"Пробег: \t\t"P"%.0fкм\n\
									"W"Бензобак: \t\t"P"%dл\n\
									"W"Расход: \t\t"P"%dл/100км\n\
									"W"Тюнинг:\n\
									"GREEN"%s\n\n\
									"YELLOW"\t\t\tОбмен на авто:\n\n\
									"W"Марка авто: \t\t"P"%s\n\
									"W"Класс: \t\t\t"P"%s\n\
									"W"Пробег: \t\t"P"%.0fкм\n\
									"W"Бензобак: \t\t"P"%dл\n\
									"W"Расход: \t\t"P"%dл/100км\n\
									"W"Тюнинг:\n\
									"GREEN"%s\n\n\
									"NO"Вы действительно хотите совершить обмен с Вашей доплатой:"ORANGE" $%d?";
			new string[900];
			format(string,sizeof(string),f_str,gTransport[model1][trName],classname,gPlayerCars[id_prodaet][carDrived][car1],gTransport[model1][trTank],gTransport[model1][trConsumption],improve2,
				gTransport[model2][trName],classname2,gPlayerCars[id_prodaet][carDrived][car2],gTransport[model2][trTank],gTransport[model2][trConsumption],improve,car_cena);
			D(playerid,D_CAR_BUY,DSM, ""P"Обмен авто",string,"Да","Отмена");
		}
	}
	if(PRESSED(KEY_WALK)) {
		if(Casino_Flag[playerid][select_casino_table] == -1) {
			for(new c = 0; c < MAX_TABLES_DICE; c++) {
				if(IsPlayerInDynamicArea(playerid, InfoDice[c][dice_area])) {
					if(InfoDice[c][dice_game_start] == true) return ErrorMessage(playerid,"Данная партия уже играется");
					if(Casino_Flag[playerid][casino_crup] == 1) {
						if(InfoDice[c][dice_crup]!=INVALID_PLAYER_ID) return ErrorMessage(playerid,"Тут уже есть крупье");
						InfoDice[c][dice_crup] = playerid;
					}
					else {
						new bool:check_played=false;
						for(new i = 0;i<5;i++) {
							if(InfoDice[c][dice_gamer][i] == INVALID_PLAYER_ID) {
								InfoDice[c][dice_gamer][i] = playerid;
								check_played = true;
								break;
							}
						}
						if(!check_played) return ErrorMessage(playerid,"Максимум игроков: (5)");
					}
					Casino_Flag[playerid][select_casino_table] = c;
					ShowCasino_TD(playerid, Casino_Flag[playerid][select_casino_table]);
					UpdateTextCasino(c);
					break;
				}
			}
		}
	}
	if(IsPlayerInAnyVehicle(playerid)) {
	    // new carid = GetPlayerVehicleID(playerid);
	    // new model = (GetVehicleModel(carid)-400);
/* 	    if(GetPlayerState(playerid) == 2) {
	        if(!IsAPlane(carid) && !IsABoat(carid) && !IsABike(carid) && !IsAVelik(carid) && GetEngineStat(carid))  {
		        if(PRESSED(KEY_NUM4)) {
				    DestroyDynamicObject(LightsObject[carid][0]);
		            DestroyDynamicObject(LightsObject[carid][1]);
		            LightsObject[carid][0] = -1;
		            LightsObject[carid][1] = -1;
				    if(Signal[carid] == 1) {
		                SignalTick[carid][0] = 0;
		                SignalTick[carid][1] = -1;
		                Signal[carid] = 0;
		                SetPlayerChatBubble(playerid, "выключил(а) левый поворотник", COLOR_PURPLE, 30.0, 5000);
				    }
				    else {
				        LightsObject[carid][0] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
		                LightsObject[carid][1] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
		                AttachDynamicObjectToVehicle(LightsObject[carid][0], carid, -LightsPos[model][0], LightsPos[model][1], LightsPos[model][2], 0, 0, 0);
		                AttachDynamicObjectToVehicle(LightsObject[carid][1], carid, -LightsPos[model][3], LightsPos[model][4], LightsPos[model][5], 0, 0, 0);
				        GetVehicleZAngle(carid, SignalAngle[carid]);
				        SignalTick[carid][0] = 0;
				        SignalTick[carid][1] = -1;
				    	Signal[carid] = 1;
						SetPlayerChatBubble(playerid, "включил(а) левый поворотник", COLOR_PURPLE, 30.0, 5000);
				    }
				    return true;
				}
				else if(PRESSED(KEY_NUM6)) {
				    DestroyDynamicObject(LightsObject[carid][0]);
		            DestroyDynamicObject(LightsObject[carid][1]);
		            LightsObject[carid][0] = -1;
		            LightsObject[carid][1] = -1;
				    if(Signal[carid] == 2) {
		                SignalTick[carid][0] = 0;
		                SignalTick[carid][1] = -1;
		                Signal[carid] = 0;
		                SetPlayerChatBubble(playerid, "выключил(а) правый поворотник", COLOR_PURPLE, 30.0, 5000);
				    }
				    else {
						LightsObject[carid][0] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
		                LightsObject[carid][1] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
		                AttachDynamicObjectToVehicle(LightsObject[carid][0], carid, LightsPos[model][0], LightsPos[model][1], LightsPos[model][2], 0, 0, 0);
		                AttachDynamicObjectToVehicle(LightsObject[carid][1], carid, LightsPos[model][3], LightsPos[model][4], LightsPos[model][5], 0, 0, 0);
				        GetVehicleZAngle(carid, SignalAngle[carid]);
				        SignalTick[carid][0] = 0;
				        SignalTick[carid][1] = -1;
				    	Signal[carid] = 2;
						SetPlayerChatBubble(playerid, "включил(а) правый поворотник", COLOR_PURPLE, 30.0, 5000);
				    }
				    return true;
				}
			}
		} */
		if((newkeys & 1 && !(oldkeys & 1)) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			    if(IsAPlane(GetPlayerVehicleID(playerid)) || IsABoat(GetPlayerVehicleID(playerid))) callcmd::eng(playerid);
			    else callcmd::engine(playerid, "");
		}
	}
	time_newkeys = GetTickCount() - tickcount1;
	if(time_newkeys > time_newkeys_max) time_newkeys_max = time_newkeys;
	return true;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	return false;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	/* // Авторизация
	if(playertextid == mobile_local_auth[playerid][1]) { // окно ввода пароля
		CancelSelectTextDraw(playerid);
		return showLoginDialog(playerid);
	} 
	else if(playertextid == mobile_local_auth[playerid][2]) { // восстановление аккаунта
		CancelSelectTextDraw(playerid);
		return callAccountRecovery(playerid);
	}
	else if(playertextid == mobile_local_auth[playerid][3]) { // отмена авторизации
		ErrorMessage(playerid, "Вы отменили авторизацию");
		destroyLoginInterface(playerid);
		return Kick(playerid);
	}
	else if(playertextid == mobile_local_auth[playerid][4]) { // подтверждение авторизации (когда введен верно пароль)
		if(!GetPVarInt(playerid, "successfulAuth")) return ErrorMessage(playerid, "Вы должны авторизоваться (ввести пароль)");
		DeletePVar(playerid, "successfulAuth");
		SendOk(playerid, "Вы успешно нажали 'Войти'");
		destroyLoginInterface(playerid);
		return load_load(playerid);
	}
	// Регистрация
	// - - - --  - 1 страница ---------------
	if(playertextid == mobile_local_register[playerid][1]) { // кнопка ввода пароля
		CancelSelectTextDraw(playerid);
		return showRegisterDialog(playerid);
	} 
	else if(playertextid == mobile_local_register[playerid][3]) { // кнопка ввода почты
		if(!strlen(player_pass[playerid])) return ErrorMessage(playerid, "Вы пропустили ввод пароля");
		CancelSelectTextDraw(playerid);
		return showRegisterEmailDialog(playerid);
	}
	else if(playertextid == mobile_local_register[playerid][4]) { // // кнопка выйти
		ErrorMessage(playerid, "Вы отменили регистрацию");
		hideRegisterInterface(playerid, -1); // удаление текстдравов
		return Kick(playerid);
	}
	else if(playertextid == mobile_local_register[playerid][5]) { // Кнопка далее (переход на 2 стр)
		if(!strlen(player_pass[playerid]) || !strlen(PI[playerid][pEmail])) return ErrorMessage(playerid, "Вы пропустили одно или два обязательных поля");
		hideRegisterInterface(playerid, 0);

		return showRegisterInterface(playerid, 1);
	}
	// - - - --  - 2 страница --------------
	else if(playertextid == mobile_local_register[playerid][8]) { // Кнопка ввода реферала
		CancelSelectTextDraw(playerid);
		return D(playerid,D_REG_FRIEND,DSI, ""P"Регистрация", ""G"Введите "ORANGE"ник"G" игрока, пригласившего Вас на сервер.\n\n\
			При достижении 4 уровня он получит "P"награду", "Далее", "Пропуск");
	}
	// - - - - - - Выбор пола - - - - - - -
	else if(playertextid == mobile_local_register[playerid][9]) { // кнопка выбора мужского пола
		PI[playerid][pSex] = 2;
		return 1;
	}
	else if(playertextid == mobile_local_register[playerid][10]) { // кнопка выбора женского пола
		PI[playerid][pSex] = 1;
		return 1;
	}
	// - - - - - - - - - - - - - - - - - - - -- 
	else if(playertextid == mobile_local_register[playerid][11]) { // Кнопка назад (на 1 стр)
		hideRegisterInterface(playerid, 1);
		return showRegisterInterface(playerid, 0);
	}
	else if(playertextid == mobile_local_register[playerid][12]) { // Кнопка завершения регистрации
		if(PI[playerid][pSex] < 1 || 
		!strlen(player_pass[playerid]) ||
		!strlen(PI[playerid][pEmail])) return ErrorMessage(playerid, "Вы пропустили одно или несколько обязательных полей");

		hideRegisterInterface(playerid, -1);
		return ChosePlayerSkin(playerid);
	}
	//
	if(playertextid == mobile_local_hud[playerid][2]) { // смена оружия
		new findGunsCount = 0;

		new dialogString[38 * 9];
		for (new slot; slot < 13; slot++) {

			new 
				dialogLine[38],
				weaponName[32];

			GetPlayerWeaponData(playerid, slot, GunPlayer[playerid][slot][0], GunPlayer[playerid][slot][1]);

			// если оружие валидное, то оно будет иметь имя, иначе мы запишем слово пусто
			if(GunPlayer[playerid][slot][0] >= 0 && IsValidWeaponID(GunPlayer[playerid][slot][0])) {
				GetWeaponName(GunPlayer[playerid][slot][0], weaponName, sizeof(weaponName));
			} else {
				weaponName = "пусто";
			}

			findGunsCount++;


			format(dialogLine, sizeof(dialogLine), "[%d] %s\n", slot, weaponName);
			strcat(dialogString, dialogLine);
		}
		if(!findGunsCount) return ErrorMessage(playerid, "У вас нет оружия");

		return D(playerid, D_HUD_CHOOSEGUN, DSL, ""P"Смена оружия", dialogString, "Выбрать", "Отмена");
	}
	for(new i = 19; i < sizeof(Captcha); i++) {
		if(playertextid == Captcha[i]) {
			new sstring[96];
			GetPVarString(playerid, "CaptchaText", sstring, sizeof(sstring));
			switch(GetPVarInt(playerid, "CaptchaStep")) {
				case 0: format(sstring, sizeof(sstring), "%c", TextArray[i - 19]), strcat(sstring, "---"), SetPVarString(playerid, "CaptchaText", sstring);
				case 1: format(sstring, sizeof(sstring), "%s%c", sstring, TextArray[i - 19]), strdel(sstring, 1, 4), strcat(sstring, "--"), SetPVarString(playerid, "CaptchaText", sstring);
				case 2: format(sstring, sizeof(sstring), "%s%c", sstring, TextArray[i - 19]), strdel(sstring, 2, 4), strcat(sstring, "-"), SetPVarString(playerid, "CaptchaText", sstring);
				case 3: format(sstring, sizeof(sstring), "%s%c", sstring, TextArray[i - 19]), strdel(sstring, 3, 4), strcat(sstring, ""), SetPVarString(playerid, "CaptchaText", sstring);
			}
			SetPVarInt(playerid, "CaptchaStep", GetPVarInt(playerid, "CaptchaStep") + 1);
			PlayerTextDrawSetString(playerid, Captcha[8], sstring);
		}
	} */
	if(playertextid == Captcha[5]) {
		DeletePVar(playerid, "CaptchaStep"); DeletePVar(playerid, "CaptchaText");
		PlayerTextDrawSetString(playerid, Captcha[8], "----");
	}
	else if(playertextid == Captcha[6]) {
		new sstring[96];
		GetPVarString(playerid, "CaptchaText", sstring, sizeof(sstring));
		if(!GetString(PI[playerid][pKeyip], sstring) || !GetPVarInt(playerid, "CaptchaStep")) {
			new playerip[16], data2[64], day, month, year,query[200];
			getdate(day, month, year);
			format(data2, 64, "%d-%d-%d", day, month, year);
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			mysql_format(connects, query, sizeof(query), "INSERT INTO `captchalog` (`clName`, `clIP`, `clDate`, `clStatus`) VALUES ('%e', '%e', '%s', '0')", player_name[playerid], playerip, data2);
			mysql_tquery(connects, query);
			for(new l = 0; l < sizeof(Captcha); l++) PlayerTextDrawHide(playerid, Captcha[l]);
			DeletePVar(playerid, "CaptchaStep"); DeletePVar(playerid, "CaptchaText");
			Kick(playerid);
			return true;
		}
		else {
			new playerip[16], data2[64],day, month, year,query[200];
			getdate(day, month, year);
			format(data2, 64, "%d-%d-%d", day, month, year);
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			mysql_format(connects, query, sizeof(query), "INSERT INTO `captchalog` (`clName`, `clIP`, `clDate`, `clStatus`) VALUES ('%e', '%s', '%s', '1')", player_name[playerid], playerip, data2);
			mysql_tquery(connects, query);
			for(new l = 0; l < sizeof(Captcha); l++) PlayerTextDrawHide(playerid, Captcha[l]);
			DeletePVar(playerid, "CaptchaStep"); DeletePVar(playerid, "CaptchaText");
			CancelSelectTextDraw(playerid);
			TogglePlayerControllable(playerid, true);
			load_load(playerid);
			return true;
		}
	}
	return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	if(!(_:clickedid ^ 0xFFFF)) {
		if(GetPVarInt(playerid,"TunningSaluna")) {
			CancelSelectTextDraw(playerid);
			DeletePVar(playerid,"TunningSaluna");
			new vehicleid = GetPlayerVehicleID(playerid);
			ChangeVehicleColor(vehicleid,VehicleInfo[vehicleid][vColor][0],VehicleInfo[vehicleid][vColor][1]);
			ChangeVehiclePaintjob(vehicleid,VehicleInfo[vehicleid][vPaintJob]);
			for(new h = 0;h < 20;h++) {
				if(h < 7) PlayerTextDrawHide(playerid,ColorTDPl[playerid][h]);
				TextDrawHideForPlayer(playerid,ColorTD[h]);
			}
		}
		if(GetPVarInt(playerid,"TunningSalun")) {
			CancelSelectTextDraw(playerid);
			SetCameraBehindPlayer(playerid);
			DeletePVar(playerid,"TunningSalun");
			for(new h = 0;h < 22;h++) {
				if(h < 6) PlayerTextDrawHide(playerid,CustomTDPl[playerid][h]);
				TextDrawHideForPlayer(playerid,CustomTD[h]);
			}
			new vehicleid = GetPlayerVehicleID(playerid);
			for(new p = 1000;p < 1194;p++) {
			    RemoveVehicleComponent(vehicleid,p);
			}
			LoadTuning(playerid,house_car[playerid][GetNearestCar(playerid)],GetNearestCar(playerid));
		}
		if(GetPVarInt(playerid,"select_colortd")) cancel_selectcolor(playerid);
	}
	else if(clickedid == reconMenuAndroid[1]) {
		SpecPlayer(playerid,SERIU[playerid][sID]);
	}
	else if(clickedid == reconMenuAndroid[2]) {
		CancelSelectTextDraw(playerid);
		return D(playerid,D_REC_KICK,DSI, ""P"KICK","\n\n"W"Введите причину, по которой хотите кикнуть игрока с сервера:\n\n","Кикнуть","Отмена");
	}
	else if(clickedid == reconMenuAndroid[3]) {
		CancelSelectTextDraw(playerid);
		return D(playerid,D_REC_WARN,DSI, ""P"WARN","\n\n"W"Введите причину, по которой хотите выдать Warn игроку:\n\n","Варн","Отмена");
	}
	else if(clickedid == reconMenuAndroid[4]) {
		CancelSelectTextDraw(playerid);
		return D(playerid,D_REC_BAN,DSI, ""P"BAN","\n\n"W"Введите причину, по которой хотите заблокировать аккаунт игроку:\n"NO"ВНИМАНИЕ!"W" Введите время и причину через запятую без пробелов (15,читер)\nВремя блокировки аккаунта: от 7 до 30 дней\n\n","Бан","Отмена");
	}
	else if(clickedid == reconMenuAndroid[5]) {
		new stm[11];
		format(stm,10,"%d",SERIU[playerid][sID]);
		callcmd::slap(playerid,stm);
	}
	else if(clickedid == reconMenuAndroid[6]) {
		CancelSelectTextDraw(playerid);
		return ShowStats(playerid,SERIU[playerid][sID],1);
	}
	else if(clickedid == reconMenuAndroid[7]) {
		for(new plid = SERIU[playerid][sID]+1; plid<MAX_PLAYERS; plid++) {
			if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
			SERIU[playerid][sID]=plid;
			SpecPlayer(playerid,SERIU[playerid][sID]);
			return 1;
		}
	}
	else if(clickedid == reconMenuAndroid[8]) {
		for(new plid = SERIU[playerid][sID]-1; plid>=0; plid--) {
			if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
			SERIU[playerid][sID]=plid;
			SpecPlayer(playerid,SERIU[playerid][sID]);
			return 1;
		}
		for(new plid=MAX_PLAYERS-1; plid>=SERIU[playerid][sID]; plid--) {
			if(!TI[plid][tLogin] || plid == playerid || SERIU[plid][sID] != INVALID_PLAYER_ID) continue;
			SERIU[playerid][sID]=plid;
			SpecPlayer(playerid,SERIU[playerid][sID]);
			return 1;
		}
		return 1;
	}
	else if(GetPVarInt(playerid,"ChangingSkin")) {
		if(_:clickedid == 65535) SelectTextDraw(playerid, 0x0080FFFF);
		if(clickedid == buy_skins[5]) {
			callcmd::prev(playerid);
		}
		else if(clickedid == buy_skins[6]) {
			callcmd::next(playerid);
		}
	    else if(clickedid == buy_skins[0]) {
            callcmd::select(playerid);
		}
		else if(clickedid == buy_skins[1] || Text:INVALID_TEXT_DRAW) {
            callcmd::cancel(playerid);
		}
	}
	else if(GetPVarInt(playerid,"buy_accses")) {
		if(_:clickedid == 65535) SelectTextDraw(playerid, 0x0080FFFF);
		if(clickedid == buy_skins[5]) {
			callcmd::prev(playerid);
		}
		else if(clickedid == buy_skins[6]) {
			callcmd::next(playerid);
		}
	    else if(clickedid == buy_skins[0]) {
            callcmd::select(playerid);
		}
		else if(clickedid == buy_skins[1]) {
			 callcmd::cancel(playerid);
		}
	}
	else if(clickedid == ColorTD[5]) {
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][1]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][1],RGBArray[PrimaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][1]);
		PrimaryColor[playerid]++;
		if(PrimaryColor[playerid] > 255) PrimaryColor[playerid] = 0;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][2]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][2],RGBArray[PrimaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][2]);
		new curcol = PrimaryColor[playerid]+1,vehicleid = GetPlayerVehicleID(playerid);
		if(curcol > 255) curcol = 0;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][3]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][3],RGBArray[curcol]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][3]);
		if(PrimaryColor[playerid] == VehicleInfo[vehicleid][vColor][0]) {
			new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedPrimaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		else if(!ChangedPrimaryColor[playerid]) {
			new str[32];
			ChangedPrimaryColor[playerid] = true;
			RepaintValue[playerid] += PAINT_VALUE;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(GetPlayerVehicleID(playerid),PrimaryColor[playerid],SecondaryColor[playerid]);
		return 1;
	}
	else if(clickedid == ColorTD[6]) {
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][3]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][3],RGBArray[PrimaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][3]);
		PrimaryColor[playerid]--;
		if(PrimaryColor[playerid] < 0) PrimaryColor[playerid] = 255;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][2]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][2],RGBArray[PrimaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][2]);
		new curcol = PrimaryColor[playerid]-1,vehicleid = GetPlayerVehicleID(playerid);
		if(curcol < 0) curcol = 255;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][1]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][1],RGBArray[curcol]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][1]);
		if(PrimaryColor[playerid] == VehicleInfo[vehicleid][vColor][0]) {
			new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedPrimaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		else if(!ChangedPrimaryColor[playerid]) {
			new str[32];
			ChangedPrimaryColor[playerid] = true;
			RepaintValue[playerid] += PAINT_VALUE;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(GetPlayerVehicleID(playerid),PrimaryColor[playerid],SecondaryColor[playerid]);
		return 1;
	}
	else if(clickedid == ColorTD[7]) {
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][4]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][4],RGBArray[SecondaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][4]);
		SecondaryColor[playerid]++;
		if(SecondaryColor[playerid] > 255) SecondaryColor[playerid] = 0;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][5]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][5],RGBArray[SecondaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][5]);
		new curcol = SecondaryColor[playerid]+1,vehicleid = GetPlayerVehicleID(playerid);
		if(curcol > 255) curcol = 0;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][6]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][6],RGBArray[curcol]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][6]);
		if(SecondaryColor[playerid] == VehicleInfo[vehicleid][vColor][1]) {
			new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedSecondaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		else if(!ChangedSecondaryColor[playerid]) {
			new str[32];
			ChangedSecondaryColor[playerid] = true;
			RepaintValue[playerid] += PAINT_VALUE;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(GetPlayerVehicleID(playerid),PrimaryColor[playerid],SecondaryColor[playerid]);
		return 1;
	}
	else if(clickedid == ColorTD[8]) {
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][6]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][6],RGBArray[SecondaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][6]);
		SecondaryColor[playerid]--;
		if(SecondaryColor[playerid] < 0) SecondaryColor[playerid] = 255;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][5]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][5],RGBArray[SecondaryColor[playerid]]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][5]);
		new curcol = SecondaryColor[playerid]-1,vehicleid = GetPlayerVehicleID(playerid);
		if(curcol < 0) curcol = 255;
		PlayerTextDrawHide(playerid,ColorTDPl[playerid][4]);
		PlayerTextDrawColor(playerid,ColorTDPl[playerid][4],RGBArray[curcol]);
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][4]);
		if(SecondaryColor[playerid] == VehicleInfo[vehicleid][vColor][1]) {
			new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedSecondaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		else if(!ChangedSecondaryColor[playerid]) {
			new str[32];
			ChangedSecondaryColor[playerid] = true;
			RepaintValue[playerid] += PAINT_VALUE;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(GetPlayerVehicleID(playerid),PrimaryColor[playerid],SecondaryColor[playerid]);
		return 1;
	}
	else if(ColorTD[11] <= clickedid <= ColorTD[14]) {
		new i = _:clickedid - _:ColorTD[11];
		if(i == VinylJob[playerid]) return 1;
		new curvin = 0;
		TextDrawHideForPlayer(playerid,ColorTD[16+VinylJob[playerid]]);
		if(curvin == i) {
			if(ChangedVinylJob[playerid]) {
				new str[32];
				RepaintValue[playerid] -= VYNIL_VALUE;

				new price;
				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(RepaintValue[playerid]/100*vip_status[PI[playerid][pVips]][vip_tune]);
					price = (RepaintValue[playerid]-seller);
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(RepaintValue[playerid]/100*BonusInfo[act_tune]);
						price = (RepaintValue[playerid]-seller);
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(RepaintValue[playerid]/100*BonusInfo[act_tune]);
						price = (RepaintValue[playerid]-seller);
					}
				    else price = RepaintValue[playerid];
				}

				format(str,32,"$%d",price);
				PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
				ChangedVinylJob[playerid] = false;
				if(i == 0) ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),3), SetPVarInt(playerid, "PaintJob", 3);
				else ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),curvin-1), SetPVarInt(playerid, "PaintJob", curvin-1);
			}
		}
		else {
			if(!ChangedVinylJob[playerid]) {
				new str[32];
				RepaintValue[playerid] += VYNIL_VALUE;

				new price;
				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(RepaintValue[playerid]/100*vip_status[PI[playerid][pVips]][vip_tune]);
					price = (RepaintValue[playerid]-seller);
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(RepaintValue[playerid]/100*BonusInfo[act_tune]);
						price = (RepaintValue[playerid]-seller);
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(RepaintValue[playerid]/100*BonusInfo[act_tune]);
						price = (RepaintValue[playerid]-seller);
					}
				    else price = RepaintValue[playerid];
				}

				format(str,32,"$%d",price);
				PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
				ChangedVinylJob[playerid] = true;
				if(i == 0) ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),3), SetPVarInt(playerid, "PaintJob", 3);
				else ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),i-1), SetPVarInt(playerid, "PaintJob", i-1);
			}
			else {
				if(i == 0) ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),3), SetPVarInt(playerid, "PaintJob", 3);
				else ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),i-1), SetPVarInt(playerid, "PaintJob", i-1);
			}
		}
		TextDrawShowForPlayer(playerid,ColorTD[16+i]);
		VinylJob[playerid] = i;
		return 1;
	}
	else if(clickedid == ColorTD[15]) {
		return callcmd::select(playerid);
	}
	else if(clickedid == CustomTD[2]) {
		if(CustomType[playerid] == 11) return 1;
		new str[64],model,value;
		format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
		model = GetGVarInt(str,CustomType[playerid]);
		if(IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)),model)) RemoveVehicleComponent(GetPlayerVehicleID(playerid),model);
		LoadTuning(playerid,house_car[playerid][GetNearestCar(playerid)],GetNearestCar(playerid));
		CustomType[playerid]++;
		PlayerTextDrawSetString(playerid,CustomTDPl[playerid][0],CustomTypeName[CustomType[playerid]]);
		if(CustomType[playerid] == 11) TextDrawHideForPlayer(playerid,CustomTD[2]);
		else TextDrawShowForPlayer(playerid,CustomTD[3]);
		TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
		TextDrawShowForPlayer(playerid,CustomTD[10]);
		TextDrawHideForPlayer(playerid,CustomTD[4]);
		TextDrawShowForPlayer(playerid,CustomTD[20]);
		CustomListNum[playerid] = 0;
		CustomLimitNum[playerid] = 0;
		for(new i = 0; i < 5; i++) {
			TextDrawHideForPlayer(playerid,CustomTD[5+i]);
			TextDrawHideForPlayer(playerid,CustomTD[15+i]);
			PlayerTextDrawHide(playerid,CustomTDPl[playerid][1+i]);
		}
		for(new i = 0; i < 5; i++) {
			if(i > TypeBorder[CustomType[playerid]]-1) break;
			TextDrawShowForPlayer(playerid,CustomTD[5+i]);
			format(str,64,"TUN[%d][Value]",i);
			value = GetGVarInt(str,CustomType[playerid]);

			new price;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(value/100*vip_status[PI[playerid][pVips]][vip_tune]);
				price = (value-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(value/100*BonusInfo[act_tune]);
					price = (value-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(value/100*BonusInfo[act_tune]);
					price = (value-seller);
				}
			    else price = value;
			}

			format(str,64,"TUN[%d][Name]",i);
			GetGVarString(str,str,64,CustomType[playerid]);
			format(str,64,"%s~n~$%d",str,price);
			PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+i],str);
			PlayerTextDrawShow(playerid,CustomTDPl[playerid][1+i]);
			format(str,64,"TUN[%d][ModelID]",i);
			model = GetGVarInt(str,CustomType[playerid]);
			if(!IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)),model)) TextDrawShowForPlayer(playerid,CustomTD[15+i]);
			else if(i == 0) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
		}
		CameraViewChange(playerid,CustomType[playerid]);
		return 1;
	}
	else if(clickedid == CustomTD[20]) {
		if(CustomListNum[playerid] >= TypeBorder[CustomType[playerid]]-1) return 1;
		new model,str[64],value,vehicleid = GetPlayerVehicleID(playerid);
		format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
		model = GetGVarInt(str,CustomType[playerid]);
		if(IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) RemoveVehicleComponent(vehicleid,model);
		LoadTuning(playerid,house_car[playerid][GetNearestCar(playerid)],GetNearestCar(playerid));
		CustomListNum[playerid]++;
		if(CustomListNum[playerid] == 1) TextDrawShowForPlayer(playerid,CustomTD[4]);
		if(CustomListNum[playerid] >= TypeBorder[CustomType[playerid]]-1) TextDrawHideForPlayer(playerid,CustomTD[20]);
		CustomLimitNum[playerid]++;
		if(CustomLimitNum[playerid] > 4) {
			for(new i = CustomListNum[playerid]-4, b = 0; b < 5; i++,b++) {
				format(str,64,"TUN[%d][Value]",i);
				value = GetGVarInt(str,CustomType[playerid]);

				new price;
				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(value/100*vip_status[PI[playerid][pVips]][vip_tune]);
					price = (value-seller);
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(value/100*BonusInfo[act_tune]);
						price = (value-seller);
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(value/100*BonusInfo[act_tune]);
						price = (value-seller);
					}
				    else price = value;
				}

				format(str,64,"TUN[%d][Name]",i);
				GetGVarString(str,str,64,CustomType[playerid]);
				format(str,64,"%s~n~$%d",str,price);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+b],str);
				format(str,64,"TUN[%d][ModelID]",i);
				model = GetGVarInt(str,CustomType[playerid]);
				TextDrawHideForPlayer(playerid,CustomTD[15+b]);
				if(!IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) TextDrawShowForPlayer(playerid,CustomTD[15+b]);
				else if(b == 4) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
			}
			CustomLimitNum[playerid] = 4;
		}
		else {
			TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]-1]);
			TextDrawShowForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
			format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
			model = GetGVarInt(str,CustomType[playerid]);
			if(IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
		}
		return 1;
	}
	else if(clickedid == CustomTD[4]) {
		if(CustomListNum[playerid] == 0) return 1;
		new model,str[64],value,vehicleid = GetPlayerVehicleID(playerid);
		format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
		model = GetGVarInt(str,CustomType[playerid]);
		if(IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) RemoveVehicleComponent(vehicleid,model);
		LoadTuning(playerid,house_car[playerid][GetNearestCar(playerid)],GetNearestCar(playerid));
		CustomListNum[playerid]--;
		if(CustomListNum[playerid] == 0) TextDrawHideForPlayer(playerid,CustomTD[4]);
		if(CustomListNum[playerid] == TypeBorder[CustomType[playerid]]-2) TextDrawShowForPlayer(playerid,CustomTD[20]);
		CustomLimitNum[playerid]--;
		if(CustomLimitNum[playerid] < 0) {
			for(new i = CustomListNum[playerid], b = 0; b < 5; i++,b++) {
				format(str,64,"TUN[%d][Value]",i);
				value = GetGVarInt(str,CustomType[playerid]);

				new price;
				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(value/100*vip_status[PI[playerid][pVips]][vip_tune]);
					price = (value-seller);
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(value/100*BonusInfo[act_tune]);
						price = (value-seller);
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(value/100*BonusInfo[act_tune]);
						price = (value-seller);
					}
				    else price = value;
				}

				format(str,64,"TUN[%d][Name]",i);
				GetGVarString(str,str,64,CustomType[playerid]);
				format(str,64,"%s~n~$%d",str,price);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+b],str);
				format(str,64,"TUN[%d][ModelID]",i);
				model = GetGVarInt(str,CustomType[playerid]);
				TextDrawHideForPlayer(playerid,CustomTD[15+b]);
				if(!IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) TextDrawShowForPlayer(playerid,CustomTD[15+b]);
				else if(b == 0) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
			}
			CustomLimitNum[playerid] = 0;
		}
		else {
			TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]+1]);
			TextDrawShowForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
			format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
			model = GetGVarInt(str,CustomType[playerid]);
			if(IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)),model)) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
		}
		return 1;
	}
	else if(clickedid == CustomTD[3]) {
		if(CustomType[playerid] == 0) return 1;
		new str[64],model,value,vehicleid = GetPlayerVehicleID(playerid);
		format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
		model = GetGVarInt(str,CustomType[playerid]);
		if(IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) RemoveVehicleComponent(vehicleid,model);
		LoadTuning(playerid,house_car[playerid][GetNearestCar(playerid)],GetNearestCar(playerid));
		CustomType[playerid]--;
		PlayerTextDrawSetString(playerid,CustomTDPl[playerid][0],CustomTypeName[CustomType[playerid]]);
		if(CustomType[playerid] == 0) TextDrawHideForPlayer(playerid,CustomTD[3]);
		else TextDrawShowForPlayer(playerid,CustomTD[2]);

		TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
		TextDrawShowForPlayer(playerid,CustomTD[10]);
		TextDrawHideForPlayer(playerid,CustomTD[4]);
		TextDrawShowForPlayer(playerid,CustomTD[20]);
		CustomListNum[playerid] = 0;
		CustomLimitNum[playerid] = 0;
		for(new i = 0; i < 5; i++) {
			TextDrawHideForPlayer(playerid,CustomTD[5+i]);
			PlayerTextDrawHide(playerid,CustomTDPl[playerid][1+i]);
			TextDrawHideForPlayer(playerid,CustomTD[15+i]);
		}
		for(new i = 0; i < 5; i++) {
			if(i > TypeBorder[CustomType[playerid]]-1) break;
			TextDrawShowForPlayer(playerid,CustomTD[5+i]);
			format(str,64,"TUN[%d][Value]",i);
			value = GetGVarInt(str,CustomType[playerid]);

			new price;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(value/100*vip_status[PI[playerid][pVips]][vip_tune]);
				price = (value-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(value/100*BonusInfo[act_tune]);
					price = (value-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(value/100*BonusInfo[act_tune]);
					price = (value-seller);
				}
			    else price = value;
			}

			format(str,64,"TUN[%d][Name]",i);
			GetGVarString(str,str,64,CustomType[playerid]);
			format(str,64,"%s~n~$%d",str,price);
			PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+i],str);
			PlayerTextDrawShow(playerid,CustomTDPl[playerid][1+i]);
			format(str,64,"TUN[%d][ModelID]",i);
			model = GetGVarInt(str,CustomType[playerid]);
			if(!IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)),model)) TextDrawShowForPlayer(playerid,CustomTD[15+i]);
			else if(i == 0) ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
		}
		CameraViewChange(playerid,CustomType[playerid]);
		return 1;
	}
	else if(clickedid == CustomTD[21]) {
		return callcmd::select(playerid);
	}
	else if(Casino_Flag[playerid][show_casino_td] == 1 && Casino_Flag[playerid][select_casino_table] != -1){
		if(_:clickedid == INVALID_TEXT_DRAW) {
			if((InfoDice[Casino_Flag[playerid][select_casino_table]][dice_game_start] && Casino_Flag[playerid][casino_crup] == 1) || (Casino_Flag[playerid][casino_bet_cash] != 0 && InfoDice[Casino_Flag[playerid][select_casino_table]][dice_game_start])) return ErrorMessage(playerid,"Вы не можете покинуть партию пока идёт игра"),SelectTextDraw(playerid,0x9BF2EAAA);
			else return ShowCasino_TD(playerid, Casino_Flag[playerid][select_casino_table], false);
		}
		else if(clickedid == Casino_TD[Casino_TD_Exit]) {
			if((InfoDice[Casino_Flag[playerid][select_casino_table]][dice_game_start] && Casino_Flag[playerid][casino_crup] == 1) || (Casino_Flag[playerid][casino_bet_cash] != 0 && InfoDice[Casino_Flag[playerid][select_casino_table]][dice_game_start])) return ErrorMessage(playerid,"Вы не можете покинуть партию пока идёт игра"),SelectTextDraw(playerid,0x9BF2EAAA);
			else {
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Box]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Set_Bet]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Dice]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Exit]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_TableNicks][select_casino_table]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_TableScore][select_casino_table]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_TableName][select_casino_table]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Box]);
				TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Enum]);
				for(new i = 0; i < 5; i++) {
					if(i<2) TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Modeled][i]);
					TextDrawHideForPlayer(playerid,Casino_TD[Casino_TD_Lines][i]);
				}
				PlayerTextDrawHide(playerid,PTD_DiceStat[playerid]);
				CancelSelectTextDraw(playerid);
				Casino_Flag[playerid][show_casino_td] = 0;
				Casino_Flag[playerid][select_casino_table] = -1;
				//
				new s = Casino_Flag[playerid][select_casino_table];
				for(new p = 0; p < 5; p++) {
					if(InfoDice[s][dice_gamer][p]!=playerid) continue;
					InfoDice[s][dice_gamer][p] = INVALID_PLAYER_ID;
					break;
				}
				//
			}
		}
		else if(clickedid == Casino_TD[Casino_TD_Set_Bet]) {
			new s = Casino_Flag[playerid][select_casino_table];
			if(InfoDice[s][dice_game_start]) return ErrorMessage(playerid,"В данный момент идёт игра");
			if(Casino_Flag[playerid][casino_crup] == 1) {
				if(InfoDice[s][dice_bank] != 0) return ErrorMessage(playerid,"Кто то из игроков уже поставил ставку");
				D(playerid, D_SET_BET, DSI, ""P"Ставка", ""W"Введите сумму ставки!\nСтавка должна быть не менее "ORANGE"$"#MIN_STAVKA"\n"W"и не более "ORANGE"$"#MAX_STAVKA"", "Далее", "Отмена");
			}
			else {
				if(InfoDice[s][dice_stavka] == 0) return ErrorMessage(playerid,"Ставка не установлена");
				if(Casino_Flag[playerid][casino_bet_cash] != 0) return ErrorMessage(playerid,"Вы уже поставили ставку");
				if(GetPlayerMoneyEx(playerid) < InfoDice[s][dice_stavka]) return ErrorMessage(playerid,"У Вас недостаточно денег чтобы поставить ставку");
				GiveMoney(playerid,-InfoDice[s][dice_stavka],"ставка в казино");
				Casino_Flag[playerid][casino_bet_cash] = InfoDice[s][dice_stavka];
				InfoDice[s][dice_bank] += InfoDice[s][dice_stavka];
				UpdateTextCasino(s);
			}
			return 1;
		}
		else if(clickedid == Casino_TD[Casino_TD_Dice]) {
			new s = Casino_Flag[playerid][select_casino_table];
			if(InfoDice[s][dice_stavka] == 0) return ErrorMessage(playerid,"Ставка не установлена");
			if(Casino_Flag[playerid][casino_crup] == 1) {
				if(InfoDice[s][dice_game_start]) return ErrorMessage(playerid,"В данный момент идёт игра");
				new count_player = 0, count_player2 = 0;
				for(new p = 0; p < 5; p++) {
					if(InfoDice[s][dice_gamer][p]==INVALID_PLAYER_ID) continue;
					if(Casino_Flag[InfoDice[s][dice_gamer][p]][casino_bet_cash] != 0) count_player2++;
					count_player++;
				}
				if(count_player2 < 2) return ErrorMessage(playerid,"Для того чтобы начать игру, нужно два игрока установивших ставку");
				else if(InfoDice[s][dice_game_start]) return ErrorMessage(playerid,"Игра запущена");
				InfoDice[s][dice_game_start] = true;
				InfoDice[s][dice_game_start_time] = gettime() + 30;
				InfoDice[s][dice_game_start_timer] = SetTimerEx("UpdateGameDice", 1000, 1, "i", s);
			}
			else {
				if(!InfoDice[s][dice_game_start]) return ErrorMessage(playerid,"Игра еще не запущена");
				if(Casino_Flag[playerid][casino_bet_cash] == 0) return ErrorMessage(playerid,"Вы не ставили ставку");
				for(new c = 0; c < 5; c++) {
					if(InfoDice[s][dice_gamer][c] == playerid) {
						if(InfoDice[s][dice_score][c] != 0) return ErrorMessage(playerid,"Вы уже кинули кости");
						InfoDice[s][dice_score][c] = dice_random[random(sizeof(dice_random))];
						UpdateScores(s);
						UpdateTextCasino(s);
						break;
					}
				}
			}
		}
	}
	if(func_bcolor[1] <= clickedid <= func_bcolor[21] && GetPVarInt(playerid,"select_colortd")) {
		for(new i = 1; i <= 21; i++) {
			if(clickedid == func_bcolor[i]) {
				if(!GetPVarInt(playerid,"SelectButton")) SetPVarInt(playerid,"SelectButton",i);
				else if(GetPVarInt(playerid,"color_shashka")) {
					FuncBizz[PI[playerid][pBusiness]][funcbShash] = i;
					UpdateFuncBizzData(PI[playerid][pBusiness],"color_shash",FuncBizz[PI[playerid][pBusiness]][funcbShash]);
					update_bfunc(0,PI[playerid][pBusiness],FuncBizz[PI[playerid][pBusiness]][funcbShash]);
					cancel_selectcolor(playerid);
					SendClientMessage(playerid,CGOLD,"Вы изменили цвет таксопарка. Все шашки на Ваших автомобилях находящиеся на стоянке были перекрашены");
					SendClientMessage(playerid,CGOLD,"Остальные шашки на автомобилях изменят цвет после респавна");
					return 1;
				}
				else if(GetPVarInt(playerid,"color_allcolor")) {
					FuncBizz[PI[playerid][pBusiness]][funcbColor] = i;
					UpdateFuncBizzData(PI[playerid][pBusiness],"color",FuncBizz[PI[playerid][pBusiness]][funcbColor]);
					update_bfunc(1,PI[playerid][pBusiness],FuncBizz[PI[playerid][pBusiness]][funcbColor]);
					cancel_selectcolor(playerid);
					if(gBusiness[PI[playerid][pBusiness]-1][bizzType] == 11) {
						SendClientMessage(playerid,CGOLD,"Вы изменили цвет таксопарка. Все автомобили находящиеся на стоянке были перекрашены");
						SendClientMessage(playerid,CGOLD,"Остальные автомобили изменят цвет после респавна");
					}
					else if(gBusiness[PI[playerid][pBusiness]-1][bizzType] == 14) {
						SendClientMessage(playerid,CGOLD,"Вы изменили цвет транспортной компании. Все автомобили находящиеся на стоянке были перекрашены");
						SendClientMessage(playerid,CGOLD,"Остальные автомобили изменят цвет после респавна");
					}
					else if(gBusiness[PI[playerid][pBusiness]-1][bizzType] == 15) {
						SendClientMessage(playerid,CGOLD,"Вы изменили цвет банковского отделения");
					}
					return 1;
				}
			}
		}
		return 1;
	}
    return 1;
}
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid,
                                   Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,
                                   Float:fRotX, Float:fRotY, Float:fRotZ,
                                   Float:fScaleX, Float:fScaleY, Float:fScaleZ ) {
	new string[144];
	format(string,sizeof(string),"[INDEX: %d] [MODEL: %d] [BONE: %d] [X: %.2f] [Y: %.2f] [Z: %.2f] [RX: %.2f] [RY: %.2f] [RZ: %.2f] [SX: %.2f] [SY: %.2f] [SZ: %.2f]",index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
	SendClientMessage(playerid,-1,string);
    return 1;
}
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ) {
	if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return true;
	return EditObject(playerid,objectid);
}
public OnPlayerEditDynamicObject( playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz ) {
	if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return true;
	if(response == EDIT_RESPONSE_FINAL) {
		if(EdittingATM[playerid] != 0) {
			new atmID = EdittingATM[playerid];
			ATMData[atmID][ATM_Pos][0]   = x;
			ATMData[atmID][ATM_Pos][1]   = y;
			ATMData[atmID][ATM_Pos][2]   = z;
			ATMData[atmID][ATM_Pos][3]   = rx;
			ATMData[atmID][ATM_Pos][4]   = ry;
			ATMData[atmID][ATM_Pos][5]   = rz;

			SaveATM(atmID);
			new string[128];
			format(string, sizeof(string), "Вы изменили позицию ATM номер %d", atmID);
			SendOk(playerid, string);

			UpdateATMLabel(atmID);

			if(ATMData[atmID][atm_Object]) DestroyDynamicObject(ATMData[atmID][atm_Object]);

			ATMData[atmID][atm_Object] = CreateDynamicObject(2754, ATMData[atmID][ATM_Pos][0], ATMData[atmID][ATM_Pos][1], ATMData[atmID][ATM_Pos][2], 0.0, 0.0, ATMData[atmID][ATM_Pos][5], ATMData[atmID][atm_VW], ATMData[atmID][atm_INT]);
			EdittingATM[playerid] = 0;
			return 1;
		}
    }
    else if(response == EDIT_RESPONSE_UPDATE) {
        SetObjectPos(objectid, x, y, z);
        SetObjectRot(objectid, rx, ry, rz);
    }
	if (response == EDIT_RESPONSE_CANCEL) {
		new atmID = EdittingATM[playerid];
		if(EdittingATM[playerid] != 0) {
			SetTimerEx("SetObjectOldPos", 300, false, "dffffff", ATMData[atmID][atm_Object], ATMData[objectid][ATM_Pos][0], ATMData[objectid][ATM_Pos][1], ATMData[objectid][ATM_Pos][2], ATMData[objectid][ATM_Pos][3], ATMData[objectid][ATM_Pos][4], ATMData[objectid][ATM_Pos][5]);
			EdittingATM[playerid] = 0;
		}
	}
	else if(response) SetDynamicObjectPos(objectid,x, y, z), SetDynamicObjectRot(objectid,rx,ry,rz);
	return true;
}
public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z) return EditDynamicObject(playerid,objectid);
public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z) {
	return 0;
}
public OnTrailerUpdate(playerid, vehicleid) {
	return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {
	if(GetPVarInt(playerid,"selectpoint") > 0 && GetPVarInt(playerid,"selectpoint") < 3) {
		SetPVarInt(playerid,"selectpoint",2);
		SetPVarFloat(playerid,"selectpointX",fX);
		SetPVarFloat(playerid,"selectpointY",fY);
		SetPlayerMapIcon(playerid,iconTaxi,fX,fY,fZ,0,COLOR_YELLOW,1);
		SendOk(playerid,"Вы установили "W"место назначения. "G"Чтобы подтвердить, нажмите "W"Y");
	}
	else if(GetPVarInt(playerid, "bizwar_selectpoint"))
	{
		SetPVarFloat(playerid,"bizwar_selectpointX",fX);
		SetPVarFloat(playerid,"bizwar_selectpointY",fY);
		SendOk(playerid,"Вы установили "W"место назначения. "G"Подтвердите место для начала стрелы");
		return D(playerid, D_BIZWAR_CONFIRM, DSM, ""P"Подтверждение стрелы", "\n\n"W"Вы действительно желаете провести стрелу в выбранной точке?\n\n", "Принять", "Отмена");
	}
  	if(PI[playerid][pAdmin] > 0 || PI[playerid][pYoutube] > 0) {
  		if(GetPlayerState(playerid) == 2) {
	   		new tmpcar = GetPlayerVehicleID(playerid);
	   		SetVehiclePos(tmpcar, fX, fY, fZ+2);
			PutPlayerInVehicle(playerid, tmpcar, 0);
  		}
  		else SetPlayerPosAC(playerid, fX, fY, fZ+1,0,0);
		SetPlayerPosFindZ(playerid, fX, fY, 999.0);
  		return 1;
 	}
	return 1;
}
public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart) {
	if(issuerid != INVALID_PLAYER_ID) {
		if(0 <= weapon <= 46 && playerid != INVALID_PLAYER_ID) {
			if(TI[issuerid][tAFK] >= 3 || PI[issuerid][pJailTime]) {
				SCM(playerid, -1, "if(TI[issuerid][tAFK] >= 3 || PI[issuerid][pJailTime])");
				return 0;
			}
			else if(player_gm{playerid}) return 0;
			else if(weapon == 3 || (TI[issuerid][tTazers][0] > 0 && weapon == TI[issuerid][tTazers][1])) {
				if(!TI[playerid][tTazer] ) {
					if(IsACop(issuerid)) {
						if(TI[issuerid][tTazers][0] > 0 && weapon != 3) {
							TI[issuerid][tTazers][0]--;
							if(TI[issuerid][tTazers][0] == 0) {
								ErrorMessage(issuerid, "Парализующие боеприпасы закончены. Следующая зарядка через 2 минуты");
								SetPVarInt(issuerid ,"tazershoottime", unix + 60*2);
								TI[issuerid][tTazers][0] = 0;
								TI[issuerid][tTazers][1] = 0;
							}
						}
						switch(GetPlayerAnimationIndex(issuerid)) {
							case 17: SetTimerEx("UnTazer",5 * 1000, 0, "i", playerid);
							case 18: SetTimerEx("UnTazer",10 * 1000, 0, "i", playerid);
							case 19: SetTimerEx("UnTazer",15 * 1000, 0, "i", playerid);
							default: SetTimerEx("UnTazer",10 * 1000, 0, "i", playerid);
						}
						SendClientMessage(issuerid, COLOR_GREY, "Нажмите "P"N"G" около игрока чтобы сковать его");
						TI[playerid][tTazers][2] = issuerid;
						TI[issuerid][tTazers][2] = playerid;
						TI[playerid][tTazer] = true;
						TogglePlayerControllable(playerid,false);
						ApplyAnimation(playerid, "PED", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, 0, 1);
						new string[60];
						format(string,sizeof(string),"оглушил(а) %s",player_name[playerid]);
						MeAction(issuerid,string);
						return false;
					}
				}
			}
			if(weapon != 43 && weapon != 9 && GetPlayerSpecialAction(issuerid) != SPECIAL_ACTION_DRINK_SPRUNK && GetPlayerSpecialAction(issuerid) != SPECIAL_ACTION_DRINK_WINE && GetPlayerSpecialAction(issuerid) != SPECIAL_ACTION_SMOKE_CIGGY && GetPlayerSpecialAction(issuerid)!=SPECIAL_ACTION_DRINK_BEER) {
				if(!IsACop(issuerid) && !IsAArm(issuerid) && PI[issuerid][pMember] != fWHITEHOUSE && IsAGreenZone(issuerid)) {
					anti_dm{issuerid} ++;
					D(issuerid, DIALOG_NONE, DSM, ""P"Предупреждение","\n\n"W"В данном месте запрещено драться\n"NO"*"G" В случае повторных нарушений Вы будете наказаны", "Закрыть", "" );
					if(anti_dm{issuerid} >= 5) {
						ErrorMessage(issuerid,"Вы были кикнуты за попытки DM в зеленой зоне");
						Kick(issuerid);
					}
					FreezePlayerForTime(issuerid, 2);
					return 0;
				}
				// DEBUG ANTI TK
				if(PI[issuerid][pMember] == PI[playerid][pMember] && FI[PI[playerid][pMember]][fAntiTK] ) printf("%s[%d] anti tk [0]", player_name[issuerid], issuerid);
				if(TI[playerid][tDuel] == -1 && TI[issuerid][tDuel] == -1) printf("%s[%d] anti tk [1]", player_name[issuerid], issuerid);
				if(player_to_game[issuerid] == 0 && player_to_golod[issuerid] == 0) printf("%s[%d] anti tk [2]", player_name[issuerid], issuerid);
				if(TI[issuerid][tGunArea][0] == 0) printf("%s[%d] anti tk [3]", player_name[issuerid], issuerid);
				if(TI[issuerid][tDMArea][0] == 0) printf("%s[%d] anti tk [4]", player_name[issuerid], issuerid);
				//
				if(anti_tk) {
					if(PI[issuerid][pMember] == PI[playerid][pMember] && FI[PI[playerid][pMember]][fAntiTK] && TI[playerid][tDuel] == -1 && TI[issuerid][tDuel] == -1 && player_to_game[issuerid] == 0 && player_to_golod[issuerid] == 0 && TI[issuerid][tGunArea][0] == 0 && TI[issuerid][tDMArea][0] == 0) {
						ErrorMessage(issuerid,"Запрещено наносить урон членам своей организации");
						printf("%s[%d] anti tk [full]", player_name[issuerid], issuerid);
						return false;
					}
				}
			}
            if(TI[issuerid][tAFK] >= 15) {
				printf("%s[%d]: if(TI[issuerid][tAFK] >= 15)", player_name[playerid], playerid);
				return 0;
			}
		}
	}
	return true;
}
