CMD:ad(playerid, params[]) {
	if(!PI[playerid][pPhone]) return ErrorMessage(playerid,"У Вас нет телефона/SIM-карты");
	if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
	if(GetPVarInt(playerid, #pAdvertTime) > gettime()) return ErrorMessage(playerid,"Нельзя посылать чаще одного объявления в минуту");
	if(sscanf(params, "s[100]", params[0])) return SendEsp(playerid, "/ad [текст объявления]");
	SetPVarString(playerid,"advert",params[0]);
	new price = params[0] * advertise_price;
	SetPVarInt(playerid,"ad_price",price);
	
	static const f_str[] = ""W"Цена объявления: "GREEN"$%d.\n"W"Вы действительно хотите отправить объявление?";
	new string[sizeof(f_str) +1 + (-2 + 6)];
	
	format(string,sizeof(string),f_str,price);
	D(playerid,D_ADVERT_START,DSM,"{00CC00}Объявление",string,"Да","Нет");
	return 1;
}
CMD:edit(playerid) {
	if(!IsANews(playerid) || !start_work[playerid]) return ErrorMessage(playerid, "Вы не сотрудник новостей");
 	if(!start_work[playerid]) return true;
	if(!PlayerToPoint(3.0,playerid,766.6069,-1531.0240,1417.8180) &&
		!PlayerToPoint(3.0,playerid,766.7095,-1533.7859,1417.8180) &&
		!PlayerToPoint(3.0,playerid,766.6608,-1536.2832,1417.8180) &&
		!PlayerToPoint(3.0,playerid,766.5391,-1539.0297,1417.8180) &&
		!PlayerToPoint(3.0,playerid,759.7090,-1539.0297,1417.8180) &&
		!PlayerToPoint(3.0,playerid,759.6584,-1536.2838,1417.8180) &&
		!PlayerToPoint(3.0,playerid,759.6487,-1533.7859,1417.8180) &&
		!PlayerToPoint(3.0,playerid,759.6533,-1531.2749,1417.8180)) return ErrorMessage(playerid,"Необходимо находиться на рабочем месте");
	ShowAdvertList(playerid);
	return 1;
}
CMD:ether(playerid) {
	if(!IsANews(playerid) || !start_work[playerid]) return ErrorMessage(playerid, "Вы не сотрудник новостей");
	if(PI[playerid][pRank] < 5) return ErrorMessage(playerid, "Доступно с 5 ранга");
	new model = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(model == 582 || model == 488 || PlayerToPoint(5.0,playerid,779.9375,-1497.9346,1418.8450)) {
		if(GetPVarInt(playerid,"ether") == 0) {
			SetPVarInt(playerid,"ether",1);
			SendClientMessage(playerid,COLOR_GREEN,"Вы в прямом эфире");		
			PI[playerid][pSettings][2] = PI[playerid][pMember];	
			save_settings(playerid);
		}
		else {
			SetPVarInt(playerid,"ether",0);
			SendClientMessage(playerid,COLOR_GREEN,"Вы вышли из прямого эфира");
		}
	}
	else if(PlayerToPoint(5.0,playerid,785.3342,-1532.6215,1418.8169)) {
		new str[10];
		switch(GetPVarInt(playerid,"ether")) {
			case 0: str = "Начать";
			case 1: str = "Завершить";
		}
		new string[128];
		format(string,sizeof(string),"1. %s прямой эфир\n2. Приём звонков",str);
		D(playerid,D_NEWS, DSL, "Меню эфира", string, "Далее", "Отмена");
	}
	else ErrorMessage(playerid,"Вы не в офисе/служебном автомобиле");
	return 1;
}
CMD:skip(playerid) {
	if(PI[playerid][pAdmin] > 0 && PI[playerid][pAdmin] < 7) return 1;
	if(!IsANews(playerid) || !start_work[playerid]) return ErrorMessage(playerid, "Вы не сотрудник новостей");

	switch(PI[playerid][pMember]) {
		case fLSNEWS: {
			if(calls_ether[0] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Никого нет на линии");
			SendClientMessage(calls_ether[0],COLOR_GREY,"Вы были отсоединены ведущим");
			PhoneStatus(calls_ether[0],false);
			calls_ether[0] = INVALID_PLAYER_ID;
		}
		case fSFNEWS: {
			if(calls_ether[1] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Никого нет на линии");
			SendClientMessage(calls_ether[1],COLOR_GREY,"Вы были отсоединены ведущим");
			PhoneStatus(calls_ether[1],false);
			calls_ether[1] = INVALID_PLAYER_ID;
		}
		case fLVNEWS: {
			if(calls_ether[2] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Никого нет на линии");
			SendClientMessage(calls_ether[2],COLOR_GREY,"Вы были отсоединены ведущим");
			PhoneStatus(calls_ether[2],false);
			calls_ether[2] = INVALID_PLAYER_ID;
		}
	}
	SendClientMessage(playerid,COLOR_GREY,"Игрок отсоединен");
	return 1;
}