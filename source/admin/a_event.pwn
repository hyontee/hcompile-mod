#if defined _a_event_inc
	#endinput
#endif
#define _a_event_inc
#define Event:%0(       EVS_%0( 
new
    Text:a_event_TD[17];

    // for(new i = 0; i < sizeof a_event_TD; i++) {
	// 		TextDrawShowForPlayer(playerid, tempi]);
	// 	}
enum EVENT_ADMINS {
	bool: eLaunched, // false
	bool: eTeleport, // false
	eName[64],
	eOwnerID,
	eOwner[MAX_PLAYER_NAME],
	Float: ePosition[4],
	eInterior,
	eWorld,
    eTime,// default time 60 second
    eSpecifiedTime // spicified time for admin

}
new gEventSetting[EVENT_ADMINS];

alias:mp("event");
CMD:mp(playerid)
{
	if (!pInfo[playerid][pAdmin]) return 1;
	t_string[0] = EOS;
	if (gEventSetting[eLaunched]) {
		new 
			string_[145];
		format(string_, sizeof string_, "Мероприятие создано: Создатель %s | Название: %s", gEventSetting[eOwner], gEventSetting[eName]);
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	format(t_string, sizeof t_string, 
		"[0] Создать мероприятие (с 3 уровня)\n\
		[1] Раздать оружие в районе 50 метров (с 4 уровня)\n\
		[2] Раздать жизни (с 1 уровня)\n\
		[3] Забрать оружие у всех в районе 50 метров (с 1 уровня)\n\
		[4] Раздать красный цвет ника в районе 10 метров\n\
		[5] Раздать зеленый цвет ника в районе 10 метров\n\
		[6] Заморозить в районе 10 метров\n\
		[7] Разморозить в районе 15 метров\n\
		[8] %s телепорт\n\
		[9] Завершить МП и отправить на ReSpawn\n\
		[10] Завершить МП без ReSpawna", (gEventSetting[eTeleport]) ? (""colwarn"Закрыть"colwhi"") : (""collime"Открыть"colwhi"")
	);
	ShowPlayerDialog(playerid, D_ADMIN_FUNC_24, DIALOG_STYLE_LIST,""colserver"Панель управления мероприятиями", t_string, "Выбрать", "Отмена"), t_string[0] = EOS;
	return 1;
}
CMD:gomp(playerid)
{
	if (pInfo[playerid][pJailTime] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны отсидеть свой срок");
	if (pTemp[playerid][tPaintTeam] != 0 || IsPlayerInDuel(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на дуэлях / PB");
	if (pTemp[playerid][tDMArea][0]) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на ДМ-Арене"); 
	if (!gEventSetting[eTeleport]) return SendClientMessage(playerid, COLOR_GREY, !"[MP] Телепорт на мероприятие закрыт!"); 
	SetPlayerPosAC(playerid, 
		gEventSetting[ePosition][0], gEventSetting[ePosition][1]+2, gEventSetting[ePosition][2], 
		gEventSetting[eWorld], gEventSetting[eInterior]
	);
	SetPlayerArmour(playerid, 0);
	ResetPlayerWeapons(playerid);
	new
		string_[128];
	if (IsPlayerConnected(gEventSetting[eOwnerID])) {
		new
			owner_event_id = gEventSetting[eOwnerID];
		if (pTemp[owner_event_id][PlayerADostup]) {
			format(string_, sizeof string_, "[MP] "colwhi"Присоединился участник %s[%d]", pInfo[playerid][pName], playerid);
			SendClientMessage(owner_event_id, COLOR_SERVER, string_);
		}
	} 
	pTemp[playerid][tEventPaticipant] = true;
	SendClientMessage(playerid, COLOR_SERVER, !"[MP] "colwhi"Вы были успешно телепортированы на мероприятие!");
	SendClientMessage(playerid, COLOR_SERVER, !"[MP] "colwhi"По правилам мероприятий, у Вас было изъято оружие!");
	SendClientMessage(playerid, COLOR_SERVER, !"[MP] "colwhi"Соблюдайте спокойствие на мероприятии во избежание кика или заморозки!");
	return 1;
}
Event:OnSecondTimer() {
    if (gEventSetting[eLaunched]) {
        if (--gEventSetting[eTime] <= 0) {
            if (gEventSetting[eTime] == 0) {
                for(new i = 0; i < sizeof a_event_TD; i++) {
                    TextDrawHideForAll(a_event_TD[i]);
                }
            }
        }
    }
}
    
Event:OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) { 
	switch (dialogid) {
        case D_ADMIN_FUNC_24:
        {
            if (!response) {
                return 1;
            }
            switch(listitem)
            {
                case 0:
                {
                    if (pInfo[playerid][pAdmin] < 3) return 1;
                    ShowPlayerDialog(playerid, D_ADMIN_FUNC_25, DIALOG_STYLE_INPUT,
                        ""colserver"Создание: "colwhi"МП", ""colwhi"Введите название будущего мероприятия:", 
                        "Готово", "Закрыть"
                    );
                }
                case 1:
                {
                    if (pInfo[playerid][pAdmin] < 3) return 1;
                    ShowPlayerDialog(playerid, D_ADMIN_FUNC_26, DIALOG_STYLE_INPUT,
                        ""colserver"МП: "colwhi"Выдача оружия", 
                        ""colwhi"Введите номер оружия, и количество патронов через запятую.\n\n\tПример: 24,100", 
                        "Выдать", "Закрыть"
                    );
                }
                case 2:
                {
                    foreach(new i: PlayerInLogin) {
                        if (GetDistanceBetweenPlayers(playerid,i) < 50 && playerid != i) {
                            SetPlayerHealth(i, 100);
                            SetPlayerArmour(i, 0);
                            SendClientMessage(i, COLOR_SERVER, !"[МП] "colwhi"Администратор выдал вам жизни");
                        }
                    }
                }
                case 3:
                {
                    foreach(new i: PlayerInLogin) {
                        if (GetDistanceBetweenPlayers(playerid,i) < 50 && playerid != i) {
                            ResetPlayerWeapons(i);
                            SendClientMessage(i, COLOR_SERVER, !"[МП] "colwhi"Администратор забрал у вас оружие");
                        }
                    }
                }
                case 4:
                {
                    foreach(new i: PlayerInLogin) {
                        if (GetDistanceBetweenPlayers(playerid,i) < 10 && playerid != i) {
                            SetPlayerColor(i, COLOR_RED);
                        }
                    }
                }
                case 5:
                {
                    foreach(new i: PlayerInLogin) {
                        if (GetDistanceBetweenPlayers(playerid,i) < 10 && playerid != i) {
                            SetPlayerColor(i, COLOR_GREEN);
                        }
                    }
                }
                case 6: { //freeze
                    foreach(new i: PlayerInLogin) {
                        if (GetDistanceBetweenPlayers(playerid,i) < 10 && playerid != i) {
                            if (!pTemp[i][PlayerADostup]) { 
                                TogglePlayerControllable(i, 0);
                                pTemp[i][tFreezePlayer] = true;
                                SendClientMessage(i, COLOR_SERVER, !"[MP] "colwhi"Администратор замарозил Вас");
                            }
                        }
                    }
                }
                case 7: {//unfreeze
                    foreach(new i: PlayerInLogin) {
                        if (GetDistanceBetweenPlayers(playerid,i) < 15 && playerid != i) {
                            if (!pTemp[i][PlayerADostup]) {
                                TogglePlayerControllable(i, 1);
                                pTemp[i][tFreezePlayer] = false;
                                SendClientMessage(i, COLOR_SERVER, !"[MP] "colwhi"Администратор размарозил Вас");
                            } 
                        }
                    }
                }
                case 8:
                {
                    if (!gEventSetting[eLaunched]) {
                        SendClientMessage(playerid, COLOR_GREY, !"Сначала надо создать мероприятие");
                        return 1;
                    }
                    gEventSetting[eTeleport] = (gEventSetting[eTeleport]) ? (false) : (true);
                    new string_[90];
                    format(string_, sizeof string_,
                        "Администратор: "colserver"%s %s "colwhi"телепорт на мероприятие!", 
                        pInfo[playerid][pName], (!gEventSetting[eTeleport]) ? (""colwarn"закрыл") : (""collime"открыл")
                    );
                    ABroadCast(COLOR_WHITE, string_, 1); 

                    format(string_, sizeof string_, 
                        "Вы %s "colwhi"телепорт на мероприятие!", 
                        (!gEventSetting[eTeleport]) ? (""colwarn"закрыли") : (""collime"открыли") );
                    SendClientMessage(playerid, -1, string_); 
                }
                case 9: 
                {
                    if (pInfo[playerid][pAdmin] < 3) {
                        SendClientMessage(playerid, COLOR_GREY, "От 3 уровня");
                        return 1;
                    }
                    if (!gEventSetting[eLaunched]) {
                        SendClientMessage(playerid, COLOR_GREY, !"Сначала надо создать мероприятие");
                        return 1;
                    }
                    new 
                        string_[128];
                    foreach(new i: PlayerInLogin) {
                        if (pTemp[i][tEventPaticipant]) {
                            if (!pTemp[i][PlayerADostup]) { 
                                pTemp[i][tEventPaticipant] = false;
                                format(string_, sizeof string_, "[MP] "colwhi"Администратор %s[%d] отправил всех участников на ReSpawn",pInfo[playerid][pName], playerid);
                                SendClientMessage(i, COLOR_SERVER, string_);
                                PlayerSpawnEx(i);
                            } 
                        }
                    }
                    format(string_, sizeof string_,
                        "[MP] Администратор %s[%d] завершил мероприятие %s!", 
                        pInfo[playerid][pName], playerid, gEventSetting[eName]
                    );
                    ABroadCast(COLOR_YELLOW, string_, 1); 
                    gEventSetting[eLaunched] = false;
                    gEventSetting[eTeleport] = false;
                    format(gEventSetting[eName], 64, "None");
                    //gEventSetting[eName] = "None";
                    gEventSetting[eOwnerID] = INVALID_PLAYER_ID;
                    format(gEventSetting[eOwner], 24, "None");
                    //gEventSetting[eOwner] = "None"; 
                    for(new i = 0; i < sizeof a_event_TD; i++) {
                        TextDrawHideForAll(a_event_TD[i]);
                    }
                }
                case 10: 
                {
                    if (pInfo[playerid][pAdmin] < 3) {
                        SendClientMessage(playerid, COLOR_GREY, "От 3 уровня");
                        return 1;
                    }
                    if (!gEventSetting[eLaunched]) {
                        SendClientMessage(playerid, COLOR_GREY, !"Сначала надо создать мероприятие");
                        return 1;
                    }
                    new 
                        string_[128]; 
                    format(string_, sizeof string_,
                        "[MP] Администратор %s[%d] завершил мероприятие %s!", 
                        pInfo[playerid][pName], playerid, gEventSetting[eName]
                    );
                    ABroadCast(COLOR_YELLOW, string_, 1); 
                    gEventSetting[eLaunched] = false;
                    gEventSetting[eTeleport] = false;
                    format(gEventSetting[eName], 64, "None");
                    //gEventSetting[eName] = "None";
                    gEventSetting[eOwnerID] = INVALID_PLAYER_ID;
                    format(gEventSetting[eOwner], 24, "None");
                    //gEventSetting[eOwner] = "None"; 
                    for(new i = 0; i < sizeof a_event_TD; i++) {
                        TextDrawHideForAll(a_event_TD[i]);
                    }
                        
                }
            }
            return 1;
        }
        case D_ADMIN_FUNC_25:
        {
            if (!response) {
                return 1;
            }
            new 
                string_[144]; 
            if (!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 32) {
                ShowPlayerDialog(playerid, D_ADMIN_FUNC_25, DIALOG_STYLE_INPUT,
                    ""colserver"Создание: "colwhi"МП", 
                    ""colwhi"Введите название мероприятия:", "Готово", "Закрыть"
                );
                return 1;
            } 
            if (is_text_invalid(inputtext)) {
                SendClientMessage(playerid, COLOR_GREY, !"Вы использовали запрещеные символы");
                ShowPlayerDialog(playerid, D_ADMIN_FUNC_25, DIALOG_STYLE_INPUT,
                    ""colserver"Создание: "colwhi"МП", 
                    ""colwhi"Введите название мероприятия:", "Готово", "Закрыть"
                );
                return 1;
            }
            format(gEventSetting[eName], 64, "%s", inputtext);

            format(string_, sizeof string_,
                "[MP] %s "colwhi"создал мероприятие под названием "colserver"%s",
                pInfo[playerid][pName], (inputtext)
            ); 
            SendClientMessageToAll(COLOR_SERVER, string_);
            SendClientMessageToAll(COLOR_SERVER, "[MP] Для участия "colserver"\"/gomp\"");
            LogingAdmins(playerid, pInfo[playerid][pName], "/mp", pInfo[playerid][pAdmin], (inputtext));
            format(gEventSetting[eOwner], 24, "%s", pInfo[playerid][pName]);
            gEventSetting[eLaunched] = true;
            gEventSetting[eTeleport] = true;
            GetPlayerPos(playerid, gEventSetting[ePosition][0], gEventSetting[ePosition][1], gEventSetting[ePosition][2]); 
            gEventSetting[eWorld] = GetPlayerVirtualWorld(playerid);
            gEventSetting[eInterior] = GetPlayerInterior(playerid);
            gEventSetting[eOwnerID] = playerid; 
            gEventSetting[eTime] = 60; 

            //tyt TD SHOW for all player
            return 1;
        }
        case D_ADMIN_FUNC_26:
        {
            if (!response) {
                return 1;
            }
            if (!strlen(inputtext)) return ShowPlayerDialog(playerid, D_ADMIN_FUNC_26, DIALOG_STYLE_INPUT,"Выдача оружия", "Введите номер оружия, и количество патронов через запятую.\n\nПример: 24,100", "Выдать", "Закрыть");
            else if (strfind(inputtext,",", true) != -1)
            {
                new razdel[2];
                sscanf(inputtext,"p<,>ii",razdel[0],razdel[1]);
                if (razdel[0] == 9 || razdel[0] == 26 || razdel[0] == 16 || razdel[0] == 27
                    || razdel[0] == 37 || razdel[0] == 38 || razdel[0] == 35
                    || razdel[0] == 36 || razdel[0] == 39 || razdel[0] == 44
                    || razdel[0] == 45) return SendClientMessage(playerid, -1, "Нельзя выдавать запрещенное оружие");

                GivePlayerWeapon(playerid, razdel[0], razdel[1]);
                foreach(new i: PlayerInLogin)
                {
                    if (GetDistanceBetweenPlayers(playerid,i) < 50 && playerid != i)
                    {
                        GivePlayerWeapon(i, razdel[0], razdel[1]);
                        SendClientMessage(i, -1, !"Администратор: выдал вам оружие");
                    }
                }
            }
            return 1;
        }
    }
    return false;
}