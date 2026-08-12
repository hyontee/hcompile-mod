publics: check_account_in_db_player(playerid, type_change)
{
	if (cache_num_rows()) {
		WantNickChange[playerid] = "None"; 
        SendClientMessage(playerid, COLOR_LIGHTRED, !"Указанный никнейм занят другим игроком!");
		return 0;
	} 
	if(!type_change) {
		new
			string_[ 49 + MAX_PLAYER_NAME + 5 + MAX_PLAYER_NAME ]; 
		format(string_, sizeof string_, "[Заявка на смену NonRP Nicka] %s[%d] просит сменить ник на: %s (/rename)", pInfo[playerid][pName], playerid, WantNickChange[playerid]);
		ABroadCast(COLOR_ISPOLZUY, string_, 3);  
		SendClientMessage(playerid, COLOR_LIGHTRED, !"Ваша заявка отправлена. Ждите одобрения администрацией");
	}
	else { 
		new string_[128];
		format(string_, sizeof string_, "[Заявка на смену Nicka оплатил 3.000.000] %s[%d] просит сменить ник на: %s", pInfo[playerid][pName], playerid, WantNickChange[playerid]);
		ABroadCast(COLOR_ISPOLZUY, string_, 3); 
		SendClientMessage(playerid, COLOR_LIGHTRED, !"Ваша заявка отправлена. Ждите одобрения администрацией");
		//SendClientMessage(playerid, COLOR_LIGHTRED, !"Ваша заявка отправлена. Ждите подтверждения мэром штата");
		//SendFamilyMessage(7, TEAM_BLUE_COLOR, string_);
	}

	return 1;
}
publics: ChangeNameDonate(playerid, nick_name[], isDonate)
{
	if (cache_num_rows())
		return SendClientMessage(playerid, COLOR_LIGHTRED, !"Указанный никнейм занят другим игроком!");
		WantNickChange[playerid] = "None"; 

	new 
        query_[356];
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_users` SET `Name`='%s' WHERE `Name` = '%s'", nick_name, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_admin` SET `Name`='%s' WHERE `Name` = '%s'", nick_name, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE "TABLE_SUPPORTS" SET `sName` = '%s' WHERE `sName` = '%s'", nick_name, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE "TABLE_MEDCARDS" SET owner ='%s' WHERE owner = '%s'", nick_name, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `fHouse` SET `hOwner`='%s' WHERE `hOwner`='%s'", nick_name, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `BUSINESS_e` SET `bOwner`='%s' WHERE `bOwner`='%s'", nick_name, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");

	for(new i = 1; i <= TOTALCASINO; i++)
	{
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caManager],true) == 0) strmid(CasinoInfo[i][caManager], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caManager2],true) == 0) strmid(CasinoInfo[i][caManager2], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caManager3],true) == 0) strmid(CasinoInfo[i][caManager3], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie],true) == 0) strmid(CasinoInfo[i][caKrupie], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie2],true) == 0) strmid(CasinoInfo[i][caKrupie2], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie3],true) == 0) strmid(CasinoInfo[i][caKrupie3], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie4],true) == 0) strmid(CasinoInfo[i][caKrupie4], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie5],true) == 0) strmid(CasinoInfo[i][caKrupie5], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie6],true) == 0) strmid(CasinoInfo[i][caKrupie6], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie7],true) == 0) strmid(CasinoInfo[i][caKrupie7], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie8],true) == 0) strmid(CasinoInfo[i][caKrupie8], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie9],true) == 0) strmid(CasinoInfo[i][caKrupie9], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie10],true) == 0) strmid(CasinoInfo[i][caKrupie10], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		SaveCasinoIDManager(i);
		SaveCasinoIDDealer(i);
    }
	for(new i = 1; i <= TOTALFARM; i++)
    {
        if (strcmp(pInfo[playerid][pName],FarmInfo[i][fDeputy_1],true) == 0) strmid(FarmInfo[i][fDeputy_1], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fDeputy_2],true) == 0) strmid(FarmInfo[i][fDeputy_2], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fDeputy_3],true) == 0) strmid(FarmInfo[i][fDeputy_3], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_1],true) == 0) strmid(FarmInfo[i][fFarmer_1], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_2],true) == 0) strmid(FarmInfo[i][fFarmer_2], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_3],true) == 0) strmid(FarmInfo[i][fFarmer_3], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_4],true) == 0) strmid(FarmInfo[i][fFarmer_4], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_5],true) == 0) strmid(FarmInfo[i][fFarmer_5], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		SaveFermIDFarmers(i);
	}
	if (pInfo[playerid][pHouseID] != -1) {
		new	
			H_IDX = pInfo[playerid][pHouseID];
		strmid(HouseInfo[H_IDX][hOwner], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		SaveHouseID(H_IDX);
	}

	if (pTemp[playerid][PlayerFarmID] != -1) {
		new farm_id = pTemp[playerid][PlayerFarmID];
		strmid(FarmInfo[farm_id][fOwner], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		SaveFermID(farm_id);
	}
	if (pInfo[playerid][pLeader] != 0) {
		query_[0] = EOS;
		new fracion_id = pInfo[playerid][pLeader];
		strmid(fInfo[fracion_id][fLeader], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
		mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_fraction` SET `fLeader`= '%s' WHERE `fID` = '%d'", nick_name, fracion_id);
		mysql_tquery(dbHandle, query_, "", "");
	} 
	if (pInfo[playerid][pMember] != 0) {
		if (!strcmp(pInfo[playerid][pName], fInfo[pInfo[playerid][pMember]][fAssistant], true))
		{
			query_[0] = EOS;
			new fracion_id = pInfo[playerid][pMember];
			strmid(fInfo[fracion_id][fAssistant], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
			mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_fraction` SET `fAssistant`= '%s' WHERE `fID` = '%d'", nick_name, fracion_id);
			mysql_tquery(dbHandle, query_, "", "");
		}
	}
	if (pInfo[playerid][pFamily] != 0) {
		if (!strcmp(pInfo[playerid][pName], FamilyInfo[pInfo[playerid][pFamily] - 1][fOwner], true))
		{
			query_[0] = EOS;
			new 
				family_id = pInfo[playerid][pFamily];
			strmid(FamilyInfo[family_id - 1][fOwner], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
			mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_family` SET `fOwner`= '%s' WHERE `fID` = '%d'", nick_name, family_id);
			mysql_tquery(dbHandle, query_, "", ""); 
		}
	}
	for (new i = 0; i < sizeof (BusinessInfo); i++) 
	{ 
		if (!IsValidBusiness(i)) continue;
		if (!strcmp(pInfo[playerid][pName], BusinessInfo[i][bOwner], true))
		{
			strmid(BusinessInfo[i][bOwner], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
			format(t_string, sizeof (t_string), "bOwner = '%s'", BusinessInfo[i][bOwner]);
			SaveBusiness(i, t_string);  
		}
	}
	for(new i = 1; i <= TOTALFARM; i++)
	{
		if (!strcmp(pInfo[playerid][pName], FarmInfo[i][fAuctionName], true))
		{
			strmid(FarmInfo[i][fAuctionName], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME);
			SaveActionsFerm(i);
		}
	}
	for(new i = strlen(nick_name); i != 0; --i) {
		switch(nick_name[i]) {
			case 'А'..'Я', 'а'..'я', '0'..'9', '@': {
			SendClientMessage(playerid, COLOR_GREY, !"Используйте только английские символы!");
			return ShowPlayerDialog(playerid, D_DONATE_MENU_2, 1,""colserver"Донат: "colwhi"Смена ника","{ffffff}Введите игровой ник, на который вы хотите поменять:","Далее","Отмена");
			}			
		}
	}
    if (isDonate == 1) {
        pInfo[playerid][pDonate] -= 50;
        SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
        SendMesAll(COLOR_LIGHTRED, "%s сменил имя на %s ",pInfo[playerid][pName], nick_name);
    }
	if(isDonate == 1)
	{
		SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
        SendMesAll(COLOR_LIGHTRED, "%s сменил имя на %s ",pInfo[playerid][pName], nick_name);
    }
	SetPlayerHistoryName(pInfo[playerid][pID], nick_name, pInfo[playerid][pName]);
	strmid(pInfo[playerid][pName], nick_name, 0, strlen(nick_name), MAX_PLAYER_NAME); 
	SetPlayerName(playerid, nick_name); 
	//pInfo[playerid][pBank] -= 3_000_000;
	return 1;
}