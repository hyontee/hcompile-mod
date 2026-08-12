CMD:lpanel(playerid)
{
	new 
		fraction_id = GetPlayerFraction(playerid);
	if (fraction_id == INVALID_FRACTION_ID) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в организации!");
	if (GetPlayerData(playerid, pLeader) == INVALID_FRACTION_ID && pInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Вы не лидер организации!");
	new
		string_[128],
		total_team = 0;
	foreach(new i: PlayerInLogin) {
		if (!pInfo[i][pLogin]) continue;
		if (pInfo[i][pMember] != pInfo[playerid][pMember]) continue;
		if (pInfo[i][pAdmin] != 0) continue;
		total_team++;
	}
	strcat(t_string, ""colserver"[№] Описание\t"colserver"Настройка\n");
	format(string_, sizeof string_, ""colwhi"[0] Основные настройки:\t%s\n", fInfo[fraction_id][fName]);
	strcat(t_string, string_) ;
	format(string_, sizeof string_, ""colwhi"[1] Участники организации:\tОнлайн: %d\n", total_team);
	strcat(t_string, string_) ;
	strcat(t_string, ""colwhi"[2] Управление транспортом:\t-\n") ;
	strcat(t_string, ""colwhi"[3] Управление рангами:\t-\n") ;
	switch (fraction_id) {
		case FRACTION_LSPD .. FRACTION_HOSPITAL_SF, FRACTION_CITYHALL, FRACTION_SF_NEWS .. FRACTION_AUTOSCHOOL, FRACTION_LS_NEWS, FRACTION_ARMY_LV .. FRACTION_HOSPITAL_LV: {
			new 
				name_money[16];
			switch(fraction_id) {
				case FRACTION_CITYHALL: name_money = "Казна:";
				default: name_money = "Бюджет:";
			}
			format(string_, sizeof string_, ""colwhi"[4] Управление бюджетом:\t%s "collime"$%s\n", name_money, convert_money(FractionInfo[fraction_id][fMoney]));
			strcat(t_string, string_);  
		}
		case FRACTION_LCN, FRACTION_YAKUZA, FRACTION_PIRUS, FRACTION_BALLAS .. FRACTION_GROVE, FRACTION_AZTEC, FRACTION_RIFA: {
			strcat(t_string, ""colwhi"[4] Управление дипломатией:\t-\n") ;
		}
	} 
	ShowPlayerDialog(playerid, D_FRACTION_FUNC_7, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Настройки организации", t_string, "Выбрать", "Закрыть");
    t_string[0] = EOS;
	/*ShowDialog(playerid, DialogID(D_FRACTION_L_PANEL), DIALOG_STYLE_TABLIST_HEADERS, 
		 ""colserver"Настройки организации", t_string, "Далее", "Отмена"
	);*/
	/*if (pInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в организации!");
	new string_[128],
		fraction_id = pInfo[playerid][pMember],
		total_team = 0;
    if (GetString(fInfo[fraction_id][fLeader], pInfo[playerid][pName]) || GetString(fInfo[fraction_id][fAssistant], pInfo[playerid][pName]))
    {
		t_string[0] = EOS;
		foreach(new i: PlayerInLogin) {
		    if (!pInfo[i][pLogin]) continue;
		    if (pInfo[i][pMember] != pInfo[playerid][pMember]) continue;
			if (pInfo[i][pAdmin] != 0) continue;
		    total_team++;
		}
		strcat(t_string, ""colserver"[№] Описание\t"colserver"Настройка\n");
		format(string_, sizeof string_, ""colwhi"[0] Основные настройки:\t%s\n", fInfo[fraction_id][fName]);
		strcat(t_string, string_) ;
		format(string_, sizeof string_, ""colwhi"[1] Участники организации:\tОнлайн: %d\n", total_team);
		strcat(t_string, string_) ;
		strcat(t_string, ""colwhi"[2] Управление транспортом:\t-\n") ;
		strcat(t_string, ""colwhi"[3] Управление рангами:\t-\n") ;
		switch (fraction_id) {
			case FRACTION_LSPD .. FRACTION_HOSPITAL_SF, FRACTION_CITYHALL, FRACTION_SF_NEWS .. FRACTION_AUTOSCHOOL, FRACTION_LS_NEWS, FRACTION_ARMY_LV .. FRACTION_HOSPITAL_LV: {
				new 
					name_money[16];
				switch(fraction_id) {
					case FRACTION_CITYHALL: name_money = "Казна:";
					default: name_money = "Бюджет:";
				}
				format(string_, sizeof string_, ""colwhi"[4] Управление бюджетом:\t%s "collime"$%s\n", name_money, convert_money(FractionInfo[fraction_id][fMoney]));
				strcat(t_string, string_);  
			}
			case FRACTION_LCN, FRACTION_YAKUZA, FRACTION_PIRUS, FRACTION_BALLAS .. FRACTION_GROVE, FRACTION_AZTEC, FRACTION_RIFA: {
				strcat(t_string, ""colwhi"[4] Управление дипломатией:\t-\n") ;
			}
		} 
		ShowPlayerDialog(playerid, D_FRACTION_FUNC_7, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Настройки организации", t_string, "Выбрать", "Закрыть");
	}*/
 	return 1;
}  