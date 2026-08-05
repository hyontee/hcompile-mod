callback: kick(giveplayerid) {
	return Kick(giveplayerid);
}
#define Kick(%0) SetTimerEx("kick",250,false,"d",%0)
/*callback: check_online_status(playerid) {

    new rows;

    cache_get_row_count(rows);

    if(!rows) return 1;

	ErrorMessage(playerid, "Пользователь с таким ником уже онлайн на сервере");
	Kick(playerid);

	return 1;
}*/
callback: login_call_account_recovery(playerid) {
	new rows;

    cache_get_row_count(rows);
	
	if(!rows) return 1;
	cache_get_value_name(0, "pEmail", PI[playerid][pEmail], 32);
	cache_get_value_name_int(0, "pEmailStatus", PI[playerid][pEmailStatus]);

	if(GetString(PI[playerid][pEmail], "no"))
	{
		ErrorMessage(playerid, "Вы не привязали почту к аккаунту");
		if(!TI[playerid][pAndroid]) return showLoginDialog(playerid);
		else SelectTextDraw(playerid, 0xFF0000FF);
	}

	if(PI[playerid][pEmailStatus] == 0)
	{
		ErrorMessage(playerid, "Ваша почта не подтверждена");
		if(!TI[playerid][pAndroid]) return showLoginDialog(playerid);
		else SelectTextDraw(playerid, 0xFF0000FF);
	}


	if(!GetString(PI[playerid][pEmail], "no") && PI[playerid][pEmailStatus] >= 1)
	{
		return MailVerification(playerid);
	}
	return 1;
}
callback: ylogin(playerid) {
	new rows;
	cache_get_row_count(rows);
	if(!rows) return 1;
	
	cache_get_value_int(0,"rank",PI[playerid][pYoutube]);

	new string[64];
	format(string, sizeof(string), "[Y]"W" %s(%i) авторизовался",player_name[playerid],playerid);
	SendYouTubeMessage(COLOR_YELLOW, string, 1);
	Iter_Add(youtubersCount, playerid);
	return 1;
}
callback: show_referals(playerid) {

	new rows;
   	cache_get_row_count(rows);
	if(rows) {
		FirstReferal[playerid] = 0;
		new Name[MAX_PLAYER_NAME + 1], Level;
		string_1024[0] = EOS;
		for(new i; i < rows; i ++) {
			cache_get_value_name(i, "Name", Name, MAX_PLAYER_NAME);
			cache_get_value_name_int(i, "pLevel",Level);
			new string[70];

			if(Level < 4) format(string, sizeof(string), "%s"ORANGE"%i."W" %s - "NO"%d LEVEL\n", string, i+1, Name, Level);
			else format(string, sizeof(string), "%s"ORANGE"%i."W" %s - "GREEN"%d LEVEL\n", string, i+1, Name, Level);
			strcat(string_1024, string);
		}
		if(!D(playerid, D_REFERALS, 0, "Приглашенные", string_1024, "Далее", "Назад")) ErrorMessage(playerid, "Недоступно, попробуйте повторить заного");
	}
	else ErrorMessage(playerid,"Вас никто не указывал как пригласившего на сервер");
}
callback: all_referals(playerid,const names[]) {
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ErrorMessage(playerid, "Рефералы не найдены");
	new level,stats[3];
	for(new i = 0; i < rows; i++) {
		cache_get_value_int(i,"pLevel",level);
		if(level == 2) stats[0] ++;
		if(level == 3) stats[1] ++;
		if(level >= 4) stats[2] ++;
	}
	static const f_str[] = ""W"Ник: "YELLOW"%s\n\n\
							"W"Игроки достигшие 2 лвл: "ORANGE"[%d]\n\
							"W"Игроки достигшие 3 лвл: "ORANGE"[%d]\n\
							"W"Игроки достигшие 4+ лвл: "ORANGE"[%d]\n\n\
							"W"Всего игроков приглашено: "P"[%d]";
	new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4) + (-2 + 4) + (-2 + 4) + (-2 + 4)];
	format(string,sizeof(string),f_str,names,stats[0],stats[1],stats[2],rows);
	D(playerid,DIALOG_NONE,DSM, ""P"Рефералы",string,"Закрыть","");
	return 1 ;
}
callback: AGetID(playerid, id) {
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ErrorMessage(playerid, "Аккаунт не найден");
	new ids,names[MAX_PLAYER_NAME+1];
	cache_get_value_int(0,"pID",ids);
	cache_get_value(0,"Name",names,MAX_PLAYER_NAME);
	new string[256];
	format(string,sizeof(string),""W"%sНомер аккаунта:      \t%i\n",string,id);
	format(string,sizeof(string),"%sИмя:      \t\t%s\n\n",string,names);
	D(playerid,DIALOG_NONE,DSM, ""P"GETID",string,"Закрыть","");
	return 1;
}
callback: AGetStats(playerid, const name[]) {
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ErrorMessage(playerid, "Аккаунт не найден");
	new level,awarn,money,moneyb,id;
	new leader,member,rank,house;
	new biz,regip[17],onlin[33],drug[25];
	new ip[17];
	cache_get_value_int(0,"pID",id);
	cache_get_value_int(0,"pLevel",level);
	cache_get_value_int(0,"pWarns",awarn);
	cache_get_value_int(0,"pCash",money);
	cache_get_value_int(0,"pBank",moneyb);
	cache_get_value_int(0,"pLeader",leader);
	cache_get_value_int(0,"pMember",member);
	cache_get_value_int(0,"pRank",rank);
	cache_get_value_int(0,"bussiness",biz);
	cache_get_value_int(0,"house",house);
	cache_get_value(0,"pIpReg",regip,16);
	cache_get_value(0,"pvIp",ip,16);
	cache_get_value(0,"pOnline",onlin,32);
	cache_get_value(0,"pDrug",drug,24);

	string_1024[0] = EOS;

	format(string_1024,sizeof(string_1024),""W"Номер аккаунта:      \t%i\n",string_1024,id);
	format(string_1024,sizeof(string_1024),"%sИмя:      \t\t%s\n\n",string_1024,name);
	format(string_1024,sizeof(string_1024),"%sУровень:      \t\t%d\n",string_1024,level);
	format(string_1024,sizeof(string_1024),"%sВарны:      \t\t%d\n",string_1024,awarn);
	format(string_1024,sizeof(string_1024),"%sДеньги(нал):      \t%d\n",string_1024,money);
	format(string_1024,sizeof(string_1024),"%sДеньги(банк):      \t%d\n",string_1024,moneyb);
	format(string_1024,sizeof(string_1024),"%sЛидер:      \t\t%d\n",string_1024,leader);
	format(string_1024,sizeof(string_1024),"%sФракция:      \t\t%d\n",string_1024,member);
	format(string_1024,sizeof(string_1024),"%sРанг:      \t\t%d\n",string_1024,rank);
	if(biz != 0) format(string_1024,sizeof(string_1024),"%sБизнес:          \t\t%d(%s)\n",string_1024,biz,gBusiness[biz-1][bizzName]);
	else format(string_1024,sizeof(string_1024),"%sБизнес:          \t\t%d(Отсутствует)\n",string_1024,biz);
	format(string_1024,sizeof(string_1024),"%sДом:          \t\t%d\n",string_1024,house);
	format(string_1024,sizeof(string_1024),"%sR-IP:      \t\t%s\n",string_1024,regip);
	format(string_1024,sizeof(string_1024),"%sL-IP:      \t\t%s\n",string_1024,ip);
	format(string_1024,sizeof(string_1024),"%sOnline:\t\t\t%s\n",string_1024,onlin);
	format(string_1024,sizeof(string_1024),"%sУказывал при регистрации:\t\t\t%s\n\n",string_1024,drug);
	if(!GetString(regip,ip)) format(string_1024,sizeof(string_1024),"%s"NO" IP регистрации и IP последнего входа разные\n",string_1024);
	D(playerid,DIALOG_NONE,DSM, ""P"OFFSTATS",string_1024,"Закрыть","");
	return 1;
}
callback: get_info_player(playerid) {
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ErrorMessage(playerid, "Аккаунт не найден");
	new name[MAX_PLAYER_NAME + 1];
	new ipreg[17];
	new getonip[17];
	new datareg[32+1];

	cache_get_value(0,"Name",name, MAX_PLAYER_NAME);
	cache_get_value(0,"pIpReg",ipreg, 16);
	cache_get_value(0,"pvIp",getonip, 16);
	cache_get_value(0,"pDataReg",datareg, 32+1);

	new id,cash,level,donate;
	cache_get_value_int(0,"pID",id);
	cache_get_value_int(0,"pCash",cash);
	cache_get_value_int(0,"pLevel",level);
	cache_get_value_int(0,"donatemoney",donate);

	static const fmt_str[] = ""W"Номер аккаунта: "P"%d\nДеньги наличными: "GREEN"$%d\nУровень: "P"%d\nREG-IP: "P"%s\nLAST-IP: "P"%s\n"W"Донат: "P"%d\nЗарегистрирован: "P"%s";
	new string[sizeof(fmt_str) + (-2 * 7 + 11 * 3 + 3 + 16 * 2 + 32) + (5 * 7 + 1)]; // правый - цвета

	format(string, sizeof(string), fmt_str, id,cash,level,ipreg,getonip,donate,datareg);

	D(playerid,DIALOG_NONE,DSM,name,string,"Закрыть","");
	return 1;
}
callback:offwarn(playerid, const Nick[],const Reason[]) {
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ErrorMessage(playerid, "Аккаунт не найден");
	new query[300];
	new count_warns;
	cache_get_value_int(0,"pWarns",count_warns);
	if((count_warns+1) < 3) {

		mysql_format(connects, query, sizeof(query), "UPDATE `accounts` SET `pWarns` = '%i', `warntime` = '%i', `pLeader` = '0', `pMember` = '0', `pRank` = '0' WHERE `Name` = '%e' LIMIT 1",(count_warns+1),unix + 7*86400,Nick);
		mysql_pquery(connects,query);

		WriteLog(LOG_WARN,player_name[playerid],Nick,Reason);
		gAdmin[playerid][ADMIN_WARN] ++;

		new string[128];
		format(string,sizeof(string),"Администратор %s выдал предупреждение игроку %s [%i/3]. Причина: %s",player_name[playerid],Nick,(count_warns+1),Reason);
		SendClientMessageToAll(COLOR_LIGHTRED,string);
		//Insert_Warn(Nick,count_warns+1,player_name[playerid],Reason);
	}
	else {
		if(IsBannedName(Nick)) return ErrorMessage(playerid, "Данный игрок уже заблокирован");
		new string[144];
		BanName(Nick, player_name[playerid], 30, Reason);
		format(string, sizeof(string), "Администратор %s забанил (3 предупреждения) %s на %d дней в оффлайне. Причина: %s",player_name[playerid], Nick, 30, Reason);
		SendClientMessageToAll(COLOR_LIGHTRED,string);
	}
	off_add_jobinfo(Nick,"Недееспособен");
	return 1;
}
