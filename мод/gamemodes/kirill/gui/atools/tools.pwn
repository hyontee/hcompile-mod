enum E_BAN_SPECTATE_STRUCT
{
    BSP_REASON[128],
    BSP_TIME
}

new const b_ban_spectate[][E_BAN_SPECTATE_STRUCT] =
{
    {"Mass DM", 7},
    {"Оск. родни", 14},
    {"Сторонее ПО", 9999},
    {"Багоюз", 9999},
    {"ППИВ", 9999},
    {"Реклама", 30},
    {"Ущерб ЭКО", 9999},
    {"Розжиг межнац. розни", 7},
    {"Полит/Религиоз пропаганда", 9999},
    {"OOC угрозы", 7},
    {"Вред рес. проекта", 9999},
    {"Реклама промо", 14},
    {"Ввод в заблуждение", 15}
};

enum E_MUTE_SPECTATE_STRUCT
{
	MSP_REASON[128],
	MSP_TIME
}

new const b_mute_spectate[][E_MUTE_SPECTATE_STRUCT] =
{
	{"MetaGaming", 30},
	{"Упоминания родни", 120},
	{"Неуважение к администрации", 120},
	{"CapsLock", 60},
	{"Флуд", 30},
	{"Оск. адм", 120},
	{"Транслит", 30},
	{"Неуваж к адм", 180},
	{"CapsLock", 60},
	{"Оскорбление", 30},
	{"OOC угрозы", 120}
};

enum E_JAIL_SPECTATE_STRUCT
{
	JSP_REASON[128],
	JSP_TIME
}

new const b_jail_spectate[][E_JAIL_SPECTATE_STRUCT] =
{
	{"Убийство без причины", 60},
	{"Убийство машиной", 60},
	{"Убийство своих", 60},
	{"nRP поведение", 30},
	{"nRP вождение", 30},
	{"Езда по полям", 60},
	{"SpawnKill", 60},
	{"PowerGaming", 30},
	{"RevengKill", 60},
	{"Огонь по своим", 60}
};

enum E_WARN_SPECTATE_STRUCT
{
	WSP_REASON[128]
}

new const b_warn_spectate[][E_WARN_SPECTATE_STRUCT] =
{
	{"nRP В/Ч"},
	{"Аморал. действияй"},
	{"Уход от RP"},
	{"Ввод в заблуж. командами"},
	{"Mass SpawnKill(SK)"},
	{"Mass TeamKill(TK)"},
	{"Mass Death-Match(DM)"},
	{"Перенос конфликта IC в OOC"}
};

stock ShowReportsGUI(playerid, name[], text[])
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 3);
    JSON_SetInt(json, "id", playerid);
    JSON_SetString(json, "pn", name, strlen(name));
    JSON_SetString(json, "tr", text, strlen(text));

    ShowPlayerGUI(playerid, 66, json);
    JSON_Cleanup(json);
    return 1;
}

stock ShowControlPanelGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 6);

    ShowPlayerGUI(playerid, 66, json);
    JSON_Cleanup(json);
    return 1;
}


CMD:showtools(playerid, params[])
{
    new screenType;
    if(sscanf(params, "d", screenType)) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Использование: /showtools [тип экрана]");
    
    switch(screenType)
    {
        case 1: ShowReportsGUI(playerid);
        case 2: ShowControlPanelGUI(playerid);
        default: ShowNotificationKirill(playerid, 0, 3, 0, 0, "Хуйню высрал", "");
    }
    
    return 1;
}


stock PacketIncomingAtools(playerid, Node:json)
{
	new buttonId, screenType, closeFlag;
	JSON_GetInt(json, "b", buttonId);
	JSON_GetInt(json, "t", screenType);
	JSON_GetInt(json, "c", closeFlag);
	
    new jsonString[512];
    JSON_Stringify(json, jsonString, sizeof(jsonString));
    printf("[A-DEBUG] AdminTools JSON: %s", jsonString);
	
	if(closeFlag == 1)
	{
		StopSpectate(playerid);
		JSON_Cleanup(json);
		return 1;
	}
	
	new tableButtonId;
	JSON_GetInt(json, "bi", tableButtonId);
	
	switch(screenType)
	{
		case 1:
		{
			new to_player = GetPlayerSpectateData(playerid, S_PLAYER);
			
			if(to_player == -1 || !IsPlayerConnected(to_player))
			{
				SendClientMessage(playerid, 0xFF3333FF, "Игрок не найден!");
				JSON_Cleanup(json);
				return 1;
			}
			
			switch(buttonId)
			{
				case 1:
				{
					if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
					{
						SetPlayerInterior(playerid, GetPlayerInterior(to_player));
						SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(to_player));
						PlayerSpectatePlayer(playerid, to_player);
						ShowSpectateGUI(playerid, to_player);
					}
				}
				case 2:
				{
					new prevPlayer = FindPreviousPlayer(to_player);
					if(prevPlayer != -1)
					{
						StartSpectate(playerid, prevPlayer);
						ShowSpectateGUI(playerid, prevPlayer);
					}
					else ShowNotificationKirill(playerid, 0, 3, 0, 0, "Игрок не найден", "");
				}
				case 3:
				{
					new Node:json_response = JSON_Object();
					JSON_SetInt(json_response, "t", 2);
					JSON_SetString(json_response, "bn", "Кик");
					JSON_SetInt(json_response, "tf", 0);
					
					new Node:template1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Перезайдите"), "be", JSON_String("Перезайдите"));
					new Node:template2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Помеха"), "be", JSON_String("Помеха"));
					new Node:templates = JSON_Array(template1, template2);
					
					JSON_SetArray(json_response, "bt", templates);
					
					SendPacketToClient(playerid, 66, json_response);
					JSON_Cleanup(json_response);
				}
				case 4:
				{
					new Node:json_response = JSON_Object();
					JSON_SetInt(json_response, "t", 2);
					JSON_SetString(json_response, "bn", "Мут");
					JSON_SetInt(json_response, "tf", 1);
					
					new Node:template50 = JSON_Object("bi", JSON_Int(50), "bn", JSON_String("MG"), "be", JSON_String("MetaGaming"), "br", JSON_Int(30));
					new Node:template51 = JSON_Object("bi", JSON_Int(51), "bn", JSON_String("Упом. родни"), "be", JSON_String("Упоминания родни"), "br", JSON_Int(120));
					new Node:template52 = JSON_Object("bi", JSON_Int(52), "bn", JSON_String("Неуваж. к Адм."), "be", JSON_String("Неуважение к администрации"), "br", JSON_Int(120));
					new Node:template53 = JSON_Object("bi", JSON_Int(53), "bn", JSON_String("CAPS"), "be", JSON_String("CapsLock"), "br", JSON_Int(60));
					new Node:template54 = JSON_Object("bi", JSON_Int(54), "bn", JSON_String("Флуд"), "be", JSON_String("Флуд"), "br", JSON_Int(30));
					new Node:template55 = JSON_Object("bi", JSON_Int(55), "bn", JSON_String("Оскорбление администрации"), "be", JSON_String("Оск. адм"), "br", JSON_Int(120));
					new Node:template56 = JSON_Object("bi", JSON_Int(56), "bn", JSON_String("Транслит"), "be", JSON_String("Транслит"), "br", JSON_Int(30));
					new Node:template57 = JSON_Object("bi", JSON_Int(57), "bn", JSON_String("Неуважительное отношение к адм"), "be", JSON_String("Неуваж к адм"), "br", JSON_Int(180));
					new Node:template58 = JSON_Object("bi", JSON_Int(58), "bn", JSON_String("CAPS"), "be", JSON_String("CapsLock"), "br", JSON_Int(60));
					new Node:template59 = JSON_Object("bi", JSON_Int(59), "bn", JSON_String("Оск"), "be", JSON_String("Оскорбление"), "br", JSON_Int(30));
					new Node:template60 = JSON_Object("bi", JSON_Int(60), "bn", JSON_String("OOC угрозы"), "be", JSON_String("OOC угрозы"), "br", JSON_Int(120));
					new Node:templates = JSON_Array(template50, template51, template52, template53, template54, template55, template56, template57, template58, template59, template60);
					
					JSON_SetArray(json_response, "bt", templates);
					
					SendPacketToClient(playerid, 66, json_response);
					JSON_Cleanup(json_response);
				}
				case 5:
				{
					new Node:json_response = JSON_Object();
					JSON_SetInt(json_response, "t", 2);
					JSON_SetString(json_response, "bn", "Тюрьма");
					JSON_SetInt(json_response, "tf", 1);
					
					new Node:template80 = JSON_Object("bi", JSON_Int(80), "bn", JSON_String("DM"), "be", JSON_String("Убийство без причины"), "br", JSON_Int(60));
					new Node:template81 = JSON_Object("bi", JSON_Int(81), "bn", JSON_String("DB"), "be", JSON_String("Убийство машиной"), "br", JSON_Int(60));
					new Node:template82 = JSON_Object("bi", JSON_Int(82), "bn", JSON_String("TK"), "be", JSON_String("Убийство своих"), "br", JSON_Int(60));
					new Node:template83 = JSON_Object("bi", JSON_Int(83), "bn", JSON_String("nRP поведение"), "be", JSON_String("nRP поведение"), "br", JSON_Int(30));
					new Node:template84 = JSON_Object("bi", JSON_Int(84), "bn", JSON_String("nRP drive"), "be", JSON_String("nRP вождение"), "br", JSON_Int(30));
					new Node:template85 = JSON_Object("bi", JSON_Int(85), "bn", JSON_String("ЕПП"), "be", JSON_String("Езда по полям"), "br", JSON_Int(60));
					new Node:template86 = JSON_Object("bi", JSON_Int(86), "bn", JSON_String("SK"), "be", JSON_String("Убийство при спавне"), "br", JSON_Int(60));
					new Node:template87 = JSON_Object("bi", JSON_Int(87), "bn", JSON_String("PG"), "be", JSON_String("PowerGaming"), "br", JSON_Int(30));
					new Node:template88 = JSON_Object("bi", JSON_Int(88), "bn", JSON_String("RK"), "be", JSON_String("RevengKill"), "br", JSON_Int(60));
					new Node:template89 = JSON_Object("bi", JSON_Int(89), "bn", JSON_String("ФФ"), "be", JSON_String("Огонь по своим"), "br", JSON_Int(60));
					new Node:templates = JSON_Array(template80, template81, template82, template83, template84, template85, template86, template87, template88, template89);
					
					JSON_SetArray(json_response, "bt", templates);
					
					SendPacketToClient(playerid, 66, json_response);
					JSON_Cleanup(json_response);
				}
				case 6:
				{
					new Node:json_response = JSON_Object();
					JSON_SetInt(json_response, "t", 2);
					JSON_SetString(json_response, "bn", "Предупреждение");
					JSON_SetInt(json_response, "tf", 0);
					
					new Node:template100 = JSON_Object("bi", JSON_Int(100), "bn", JSON_String("nRP воинская часть"), "be", JSON_String("nRP воинская часть"));
					new Node:template101 = JSON_Object("bi", JSON_Int(101), "bn", JSON_String("Аморал. действия"), "be", JSON_String("Аморал. действия"));
					new Node:template102 = JSON_Object("bi", JSON_Int(102), "bn", JSON_String("Уход от RP"), "be", JSON_String("Уход от RP"));
					new Node:template103 = JSON_Object("bi", JSON_Int(103), "bn", JSON_String("Ввод в заблуж. командами"), "be", JSON_String("Ввод в заблуж. командами"));
					new Node:template104 = JSON_Object("bi", JSON_Int(104), "bn", JSON_String("Mass SK"), "be", JSON_String("Mass SpawnKill(SK)"));
					new Node:template105 = JSON_Object("bi", JSON_Int(105), "bn", JSON_String("Mass TK"), "be", JSON_String("Mass TeamKill(TK)"));
					new Node:template106 = JSON_Object("bi", JSON_Int(106), "bn", JSON_String("Mass DM"), "be", JSON_String("Mass Death-Match(DM)"));
					new Node:template107 = JSON_Object("bi", JSON_Int(107), "bn", JSON_String("Перенос конфликта IC в OOC"), "be", JSON_String("Перенос конфликта IC в OOC"));
					new Node:templates = JSON_Array(template100, template101, template102, template103, template104, template105, template106, template107);
					
					JSON_SetArray(json_response, "bt", templates);
					
					SendPacketToClient(playerid, 66, json_response);
					JSON_Cleanup(json_response);
				}
				case 7:
				{
					new Node:json_response = JSON_Object();
					JSON_SetInt(json_response, "t", 2);
					JSON_SetString(json_response, "bn", "Подброс");
					JSON_SetInt(json_response, "tf", 0);
					
					new Node:template16 = JSON_Object("bi", JSON_Int(16), "bn", JSON_String("Slap вверх"), "be", JSON_String("Подбросить вверх"));
					new Node:template17 = JSON_Object("bi", JSON_Int(17), "bn", JSON_String("Slap вниз"), "be", JSON_String("Подбросить вниз"));
					new Node:templates = JSON_Array(template16, template17);
					
					JSON_SetArray(json_response, "bt", templates);
					
					SendPacketToClient(playerid, 66, json_response);
					JSON_Cleanup(json_response);
				}
				case 8:
				{
					new Node:json_response = JSON_Object();
					JSON_SetInt(json_response, "t", 2);
					JSON_SetString(json_response, "bn", "Бан");
					JSON_SetInt(json_response, "tf", 1);
					
					new Node:template18 = JSON_Object("bi", JSON_Int(18), "bn", JSON_String("Mass DM"), "be", JSON_String("Mass DM"), "br", JSON_Int(7));
					new Node:template19 = JSON_Object("bi", JSON_Int(19), "bn", JSON_String("Оскорбление родни"), "be", JSON_String("Оск. родни"), "br", JSON_Int(14));
					new Node:template20 = JSON_Object("bi", JSON_Int(20), "bn", JSON_String("Читы"), "be", JSON_String("Сторонее ПО"), "br", JSON_Int(9999));
					new Node:template21 = JSON_Object("bi", JSON_Int(21), "bn", JSON_String("Багоюз"), "be", JSON_String("Багоюз"), "br", JSON_Int(9999));
					new Node:template22 = JSON_Object("bi", JSON_Int(22), "bn", JSON_String("Покупка/Продажа ИВ"), "be", JSON_String("ППИВ"), "br", JSON_Int(9999));
					new Node:template23 = JSON_Object("bi", JSON_Int(23), "bn", JSON_String("Реклама"), "be", JSON_String("Реклама"), "br", JSON_Int(30));
					new Node:template24 = JSON_Object("bi", JSON_Int(24), "bn", JSON_String("Ущерб экономике"), "be", JSON_String("Ущерб ЭКО"), "br", JSON_Int(9999));
					new Node:template25 = JSON_Object("bi", JSON_Int(25), "bn", JSON_String("Розжиг межнац. розни"), "be", JSON_String("Розжиг межнац. розни"), "br", JSON_Int(7));
					new Node:template26 = JSON_Object("bi", JSON_Int(26), "bn", JSON_String("Полит/Религиоз пропаганда"), "be", JSON_String("Полит/Религиоз пропаганда"), "br", JSON_Int(9999));
					new Node:template27 = JSON_Object("bi", JSON_Int(27), "bn", JSON_String("OOC угрозы"), "be", JSON_String("OOC угрозы"), "br", JSON_Int(7));
					new Node:template28 = JSON_Object("bi", JSON_Int(28), "bn", JSON_String("Нанесение вред рес. проекта"), "be", JSON_String("Вред рес. проекта"), "br", JSON_Int(9999));
					new Node:template29 = JSON_Object("bi", JSON_Int(29), "bn", JSON_String("Реклама промокода"), "be", JSON_String("Реклама промо"), "br", JSON_Int(14));
					new Node:template30 = JSON_Object("bi", JSON_Int(30), "bn", JSON_String("Введение в заблуждение"), "be", JSON_String("Ввод в заблуждение"), "br", JSON_Int(15));
					new Node:templates = JSON_Array(template18, template19, template20, template21, template22, template23, template24, template25, template26, template27, template28, template29, template30);
					
					JSON_SetArray(json_response, "bt", templates);
					
					SendPacketToClient(playerid, 66, json_response);
					JSON_Cleanup(json_response);
				}
				case 9:
				{
					new nextPlayer = FindNextPlayer(to_player);
					if(nextPlayer != -1)
					{
						StartSpectate(playerid, nextPlayer);
						ShowSpectateGUI(playerid, nextPlayer);
					}
					else ShowNotificationKirill(playerid, 0, 3, 0, 0, "Игрок не найден", "");
				}
				case 10:
				{
					new params[128];
					format(params, sizeof(params), "%d", to_player);
					callcmd::stats(playerid, params);
				}
				case 11: 
				{
					callcmd::af(playerid, "");
				}
			}
		}
		
		case 2:
		{
			new to_player = GetPlayerSpectateData(playerid, S_PLAYER);
			
			if(to_player == -1 || !IsPlayerConnected(to_player))
			{
				SendClientMessage(playerid, 0xFF3333FF, "Игрок не найден!");
				JSON_Cleanup(json);
				return 1;
			}
			
			switch(tableButtonId)
			{
				case 1: 
				{
						if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationKirill(playerid, 2, 5, -1, -1, "Вам не доступно использование данной функции",  "");
						
						new fmt_msg[128];
						format(fmt_msg, sizeof fmt_msg, "Администратор %s кикнул игрока %s. Причина: Перезайдите", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

						SendClientMessageToAll(0xFF5533FF, fmt_msg);

						format(fmt_msg, sizeof fmt_msg, "Кикнул %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
						SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
						
						new fmt_text[512];
						format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] кикнул %s[%d]. Причина: Перезайдите", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						SendMessageToAdmins(fmt_text, 0x999999FF); 

						SetTimerEx("KickSpectate", 50, false, "i", to_player);
 
						return 1;
				} 
				case 2:
				{
						if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationKirill(playerid, 2, 5, -1, -1, "Вам не доступно использование данной функции",  "");
						
						new fmt_msg[128];
						format(fmt_msg, sizeof fmt_msg, "Администратор %s кикнул игрока %s. Причина: Помеха", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

						SendClientMessageToAll(0xFF5533FF, fmt_msg);

						format(fmt_msg, sizeof fmt_msg, "Кикнул %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
						SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
						
						new fmt_text[512];
						format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] кикнул %s[%d]. Причина: Помеха", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						SendMessageToAdmins(fmt_text, 0x999999FF); 

						SetTimerEx("KickSpectate", 50, false, "i", to_player);
 
						return 1;
				} 
				case 50..60: 
				{
					new index = tableButtonId - 50; 
					
					if(AntiSliv(playerid, "/mute")) return true;

					new fmt_msg[128];
					format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), b_mute_spectate[index][MSP_TIME], b_mute_spectate[index][MSP_REASON]);

					 SendClientMessageToAll(0xFF5533FF, fmt_msg);

					SetPlayerData(to_player, P_MUTE, b_mute_spectate[index][MSP_TIME] * 60);
					UpdatePlayerDatabaseInt(to_player, "mute", b_mute_spectate[index][MSP_TIME] * 60);

					SendClientMessage(to_player, 0xCECECEFF, "Время до окончания бана чата: {CCCC00}/time");

					format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: %s",
					GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), b_mute_spectate[index][MSP_TIME], b_mute_spectate[index][MSP_REASON]);

					 SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
					return 1; 
				} 
				case 80..89: 
				{
					new index = tableButtonId - 80; 
					if(AntiSliv(playerid, "/jail")) return true;

					new fmt_msg[128];
					format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), b_jail_spectate[index][JSP_TIME], b_jail_spectate[index][JSP_REASON]);

					SendClientMessageToAll(0xFF5533FF, fmt_msg);

					SendClientMessage(to_player, 0xCECECEFF, "Время до окончания заключения: {CCCC00}/time");

					JailPlayer(to_player, b_jail_spectate[index][JSP_TIME]);

					format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: %s",
					GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), b_jail_spectate[index][JSP_TIME], b_jail_spectate[index][JSP_REASON]);

					SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
					return 1;
				} 
				case 100..107: 
				{
					new index = tableButtonId - 100; 
					if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationKirill(playerid, 2, 5, -1, -1, "Вам не доступно использование данной функции",  "");
					
					if(AntiSliv(playerid, "/warn")) return true;

					AddPlayerData(to_player, P_WARN, +, 1);
					SetPlayerData(to_player, P_WARN_TIME, gettime() + (86400 * 10));

					new fmt_msg[128];
					format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал предупреждение игроку %s [%d|3]. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetPlayerData(to_player, P_WARN), b_warn_spectate[index][BSP_REASON]);

					SendClientMessageToAll(0xFF5533FF, fmt_msg);

					InvitePlayer(to_player, 0, 0, true);

					new uid = GetPlayerAccountID(to_player);
					new warns = GetPlayerData(to_player, P_WARN);
					new warns_time = GetPlayerData(to_player, P_WARN_TIME);

					format(fmt_msg, sizeof fmt_msg, "Выдал варн %s[acc:%d] (%d/3). Причина: %d", GetPlayerNameEx(to_player), uid, warns, b_warn_spectate[index][BSP_REASON]);
					SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

					if(warns >= 3)
					{
						SendClientMessage(to_player, 0xFF5533FF, "Аккаунт заблокирован на 10 дней");

						warns =
						warns_time = 0;

						AddBan(uid, gettime(), 10, GetPlayerIpEx(to_player), "получено 3 варна", GetPlayerNameEx(playerid));
						BanEx(to_player, "получено 3 варна");
					}
					else Kick:(to_player);

					format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET warn=%d,warn_time=%d WHERE id=%d", warns, warns_time, uid);
					mysql_query(mysql, fmt_msg, false);
					
					return 1;
				} 
				case 16:
				{
					if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationKirill(playerid, 2, 5, -1, -1, "Вам не доступно использование данной функции",  "");
					
					new Float: x, Float: y, Float: z, fmt_text[999], fmt_msg[512];
					GetPlayerPos(to_player, x, y, z);
					
					SetPlayerPos(to_player, x, y, z + 5);
					
					format(fmt_text, sizeof fmt_text, "[A] %s[%d] подбросил игрока %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
					SendMessageToAdmins(fmt_text, 0x999999FF);

					format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы подбросили игрока %s[%d]", GetPlayerNameEx(to_player), to_player);
					SendClientMessage(playerid, -1, fmt_msg);

					format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] подбросил Вас.", GetPlayerNameEx(playerid), playerid);
					SendClientMessage(to_player, -1, fmt_text);
					return 1; 
				} 
				case 17:
				{
					if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationKirill(playerid, 2, 5, -1, -1, "Вам не доступно использование данной функции",  "");
					
					new Float: x, Float: y, Float: z, fmt_text[999], fmt_msg[512];
					GetPlayerPos(to_player, x, y, z);
					
					SetPlayerPos(to_player, x, y, z - 5);
					
					format(fmt_text, sizeof fmt_text, "[A] %s[%d] подбросил игрока %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
					SendMessageToAdmins(fmt_text, 0x999999FF);

					format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы подбросили игрока %s[%d]", GetPlayerNameEx(to_player), to_player);
					SendClientMessage(playerid, -1, fmt_msg);

					format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] подбросил Вас.", GetPlayerNameEx(playerid), playerid);
					SendClientMessage(to_player, -1, fmt_text);
					return 1; 
				} 
				case 18..30:
				{
   					new index = tableButtonId - 18;
   					new ban_time = b_ban_spectate[index][BSP_TIME];
   					new reason[64];
   					format(reason, sizeof reason, "%s", b_ban_spectate[index][BSP_REASON]);

   					if(GetPlayerAdminEx(playerid) < 3)
       					return ShowNotificationKirill(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной функции", " ");

   					if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
       					return ShowNotificationKirill(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

   					if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
       					return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить администратора выше по рангу");

   					if(AntiSliv(playerid, "/ban"))
       					return true;
       
					   if(ban_time > 365) 
					   {
							new announce[256];
   					 	format(announce, sizeof announce, "Администратор %s навсегда заблокировал игрока %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), reason);
   					 	SendClientMessageToAll(0xFF5533FF, announce);
					   } 
					   else 
					   {
   						new announce[256];
   						format(announce, sizeof announce, "Администратор %s заблокировал игрока %s на %d дней. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), ban_time, reason);
   						SendClientMessageToAll(0xFF5533FF, announce);
  				 	} 
   
  					new fmt_text[512];
  					format(fmt_text, sizeof fmt_text, "[A] %s[%d] забанил игрока игрока %s[%d]. Причина: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, reason);
					  SendMessageToAdmins(fmt_text, 0x999999FF);

   					InfoAstats[1] += 1;

   					new log_msg[256];
   					format(log_msg, sizeof log_msg, "Забанил %s[acc:%d] на %d дней. Причина: %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), ban_time, reason);
   					SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, log_msg);

   					AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), reason, GetPlayerNameEx(playerid));
					   BanEx(to_player, reason);
   					Kick(to_player);

   					return 1;
				}
			}
		}
		
		case 3:
		{
			if(tableButtonId != 0)
			{
			format(f_string144, sizeof f_string144, "tableButtonId %s", tableButtonId);
			ShowNotificationKirill(playerid, 2, 5, -1, -1, f_string144, "");
				switch(tableButtonId)
				{
					case 1:
					{
						new xaxaxas[512];
						JSON_GetString(json, "bn", xaxaxas);
						new to_player = GetPlayerSpectateData(playerid, S_PLAYER);
						if(to_player != -1 && IsPlayerConnected(to_player))
						{
							new message[128];
							format(message, sizeof(message), "{FFFF00}|{FFFFFF} Вы ответили: {FFFF00}%s", xaxaxas);
							SendClientMessage(playerid, -1, message);
							
							SendClientMessage(to_player, 0x33CCFFAA, "Здравствуйте, работаю по вашей жалобе. // Приятной Игры");
						}
						HidePlayerGUI(playerid);
					}
					case 2:
					{
						new xaxaxas[512];
						JSON_GetString(json, "bn", xaxaxas);
						new to_player = GetPlayerSpectateData(playerid, S_PLAYER);
						if(to_player != -1 && IsPlayerConnected(to_player))
						{
							new message[128];
							format(message, sizeof(message), "{FFFF00}|{FFFFFF} Вы ответили: {FFFF00}%s", xaxaxas);
							SendClientMessage(playerid, -1, message);
							
							SendClientMessage(to_player, 0x33CCFFAA, "Здравствуйте, не по теме. // Приятной Игры");
						}
						HidePlayerGUI(playerid);
					}
					case 3:
					{
					new xaxaxas[512];
						JSON_GetString(json, "bn", xaxaxas);
						new to_player = GetPlayerSpectateData(playerid, S_PLAYER);
						if(to_player != -1 && IsPlayerConnected(to_player))
						{
							new message[128];
							format(message, sizeof(message), "{FFFF00}|{FFFFFF} Вы ответили: {FFFF00}%s", xaxaxas);
							SendClientMessage(playerid, -1, message);
							
							SendClientMessage(to_player, 0x33CCFFAA, "Здравствуйте, RolePlay путем. // Приятной Игры");
						}
						HidePlayerGUI(playerid);
					}
				}
			}
			else
			{
			format(f_string144, sizeof f_string144, "buttonId %s", buttonId);
			ShowNotificationKirill(playerid, 2, 5, -1, -1, f_string144, "");
				switch(buttonId)
				{
				
					case 1:
					{
						new Node:json_response = JSON_Object();
						JSON_SetInt(json_response, "t", 4);
						
						new Node:template1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("hui Zalupa chlen bobr"), "be", JSON_String("hui Zalupa chlen bobr"));
						new Node:template2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Не по теме"), "be", JSON_String("Здравствуйте, не по теме. // Приятной Игры"));
						new Node:template3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("РП путем"), "be", JSON_String("Здравствуйте, RolePlay путем. // Приятной Игры"));
						new Node:templates = JSON_Array(template1, template2, template3);
						
						JSON_SetArray(json_response, "bt", templates);
						
						SendPacketToClient(playerid, 66, json_response);
						JSON_Cleanup(json_response);
					}
					case 2:
					{
						HidePlayerGUI(playerid);
					}
				}
			}
		}
		
		case 4:
		{
			new message[128];
			
			switch(tableButtonId)
			{
				case 1:
				{
				new xaxaxas[512];
					JSON_GetString(json, "be", xaxaxas, sizeof(xaxaxas));
					format(message, sizeof(message), "{FFFF00}|{FFFFFF} Вы ответили: {FFFF00}%s", xaxaxas);
					SendClientMessage(playerid, -1, message);
					HidePlayerGUI(playerid);
				}
				case 2:
				{
					new xaxaxas[512];
					JSON_GetString(json, "be", xaxaxas, sizeof(xaxaxas));
					format(message, sizeof(message), "{FFFF00}|{FFFFFF} Вы ответили: {FFFF00}%s", xaxaxas);
					HidePlayerGUI(playerid);
				}
				case 3:
				{
					new xaxaxas[512];
					JSON_GetString(json, "be", xaxaxas, sizeof(xaxaxas));
					format(message, sizeof(message), "{FFFF00}|{FFFFFF} Вы ответили: {FFFF00}%s", xaxaxas);
					HidePlayerGUI(playerid);
				}
			}
		}
		case 5:
{
    new rep[512];
    new repConverted[512];
    UTF8_tto_CP1251(rep, repConverted, sizeof(repConverted));
    JSON_GetString(json, "rt", repConverted, sizeof(repConverted));

    

    SendClientMessage(playerid, -1, repConverted);

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 5);
    JSON_SetString(response, "rt", repConverted);
    
    SendPacketToClient(playerid, 66, response);
}
		case 6:
		{
			if(tableButtonId == 0)
			{
				new Node:json_response = JSON_Object();
				JSON_SetInt(json_response, "t", 8);
				
				new Node:template1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("hui Zalupa chlen bobr"), "be", JSON_String("hui Zalupa chlen bobr"));
				new Node:template2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Не по теме"), "be", JSON_String("Здравствуйте, не по теме. // Приятной Игры"));
				new Node:template3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("РП путем"), "be", JSON_String("Здравствуйте, RolePlay путем. // Приятной Игры"));
				new Node:templates = JSON_Array(template1, template2, template3);
				
				JSON_SetArray(json_response, "bt", templates);
				
				SendPacketToClient(playerid, 66, json_response);
				JSON_Cleanup(json_response);
			}
			else if(tableButtonId == 1)
			{
				new Node:json_response = JSON_Object();
				JSON_SetInt(json_response, "t", 9);
				
				SendPacketToClient(playerid, 66, json_response);
				JSON_Cleanup(json_response);
			}
		}
		
		case 7:
		{
			if(tableButtonId != 0)
			{
				new Node:json_response = JSON_Object();
				JSON_SetInt(json_response, "t", 2);
				
				switch(tableButtonId)
				{
					case 3:
					{
						JSON_SetString(json_response, "bn", "Кик");
						JSON_SetInt(json_response, "tf", 0);
						
						new Node:template1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Кик: Afk no esc"), "be", JSON_String("Afk no esc"));
						new Node:template2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Кик: Помеха"), "be", JSON_String("Помеха"));
						new Node:template3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("Кик: Баг"), "be", JSON_String("Баг"));
						new Node:templates = JSON_Array(template1, template2, template3);
						
						JSON_SetArray(json_response, "bt", templates);
					}
					case 4:
					{
						JSON_SetString(json_response, "bn", "Мут");
						JSON_SetInt(json_response, "tf", 1);
						
						new Node:template4 = JSON_Object("bi", JSON_Int(4), "bn", JSON_String("Мут: Оск"), "be", JSON_String("Оскорбление игроков"), "br", JSON_Int(15));
						new Node:template5 = JSON_Object("bi", JSON_Int(5), "bn", JSON_String("Мут: Упом родни"), "be", JSON_String("Упоминание родни"), "br", JSON_Int(30));
						new Node:template6 = JSON_Object("bi", JSON_Int(6), "bn", JSON_String("Мут: Неуваж. Адм."), "be", JSON_String("Неуважение к администрации"), "br", JSON_Int(60));
						new Node:template7 = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("Мут: CAPS"), "be", JSON_String("Капс в чате"), "br", JSON_Int(10));
						new Node:templates = JSON_Array(template4, template5, template6, template7);
						
						JSON_SetArray(json_response, "bt", templates);
					}
					case 5:
					{
						JSON_SetString(json_response, "bn", "Тюрьма");
						JSON_SetInt(json_response, "tf", 1);
						
						new Node:template8 = JSON_Object("bi", JSON_Int(8), "bn", JSON_String("Тюрьма: DM"), "be", JSON_String("DM без причины"), "br", JSON_Int(10));
						new Node:template9 = JSON_Object("bi", JSON_Int(9), "bn", JSON_String("Тюрьма: DB"), "be", JSON_String("DriveBy"), "br", JSON_Int(15));
						new Node:template10 = JSON_Object("bi", JSON_Int(10), "bn", JSON_String("Тюрьма: TK"), "be", JSON_String("TeamKill"), "br", JSON_Int(20));
						new Node:template11 = JSON_Object("bi", JSON_Int(11), "bn", JSON_String("Тюрьма: Провокация ГОС"), "be", JSON_String("Провокация гос. организаций"), "br", JSON_Int(25));
						new Node:templates = JSON_Array(template8, template9, template10, template11);
						
						JSON_SetArray(json_response, "bt", templates);
					}
					case 6:
					{
						JSON_SetString(json_response, "bn", "Предупреждение");
						JSON_SetInt(json_response, "tf", 0);
						
						new Node:template12 = JSON_Object("bi", JSON_Int(12), "bn", JSON_String("Предупреждение: НонРП COP"), "be", JSON_String("НонРП коп"));
						new Node:template13 = JSON_Object("bi", JSON_Int(13), "bn", JSON_String("Предупреждение: НонРП В/Ч"), "be", JSON_String("НонРП в/ч"));
						new Node:template14 = JSON_Object("bi", JSON_Int(14), "bn", JSON_String("Предупреждение: ОРП"), "be", JSON_String("ОРП"));
						new Node:template15 = JSON_Object("bi", JSON_Int(15), "bn", JSON_String("Предупреждение: Снят ЛД"), "be", JSON_String("Снятие ЛД"));
						new Node:templates = JSON_Array(template12, template13, template14, template15);
						
						JSON_SetArray(json_response, "bt", templates);
					}
					case 7:
					{
						JSON_SetString(json_response, "bn", "Шлепок");
						JSON_SetInt(json_response, "tf", 0);
						
						new Node:template16 = JSON_Object("bi", JSON_Int(16), "bn", JSON_String("Подбросить: Вверх"), "be", JSON_String("Подбросить вверх"));
						new Node:template17 = JSON_Object("bi", JSON_Int(17), "bn", JSON_String("Подбросить: Вниз"), "be", JSON_String("Подбросить вниз"));
						new Node:templates = JSON_Array(template16, template17);
						
						JSON_SetArray(json_response, "bt", templates);
					}
					case 8:
					{
						JSON_SetString(json_response, "bn", "Бан");
						JSON_SetInt(json_response, "tf", 1);
						
						new Node:template18 = JSON_Object("bi", JSON_Int(18), "bn", JSON_String("Бан: Mass DM"), "be", JSON_String("Массовый DM"), "br", JSON_Int(7));
						new Node:template19 = JSON_Object("bi", JSON_Int(19), "bn", JSON_String("Бан: П/П/В"), "be", JSON_String("П/П/В"), "br", JSON_Int(30));
						new Node:template20 = JSON_Object("bi", JSON_Int(20), "bn", JSON_String("Бан: Оск. Родни"), "be", JSON_String("Оскорбление родни"), "br", JSON_Int(14));
						new Node:template21 = JSON_Object("bi", JSON_Int(21), "bn", JSON_String("Бан: Читы"), "be", JSON_String("Использование читов"), "br", JSON_Int(365));
						new Node:templates = JSON_Array(template18, template19, template20, template21);
						
						JSON_SetArray(json_response, "bt", templates);
					}
				}
				
				SendPacketToClient(playerid, 66, json_response);
				JSON_Cleanup(json_response);
			}
		}
		
		case 9:
		{
			new templateTitle[64], templateDesc[256], templateTime;
			JSON_GetString(json, "bn", templateTitle, sizeof(templateTitle));
			JSON_GetString(json, "be", templateDesc, sizeof(templateDesc));
			JSON_GetInt(json, "br", templateTime);
			
			if(strlen(templateTitle) > 0 && strlen(templateDesc) > 0)
			{
				new msg[128];
				format(msg, sizeof(msg), "{33CCFF}Шаблон создан: {FFFFFF}%s - %s", templateTitle, templateDesc);
				SendClientMessage(playerid, -1, msg);
				
				new Node:json_response = JSON_Object();
				JSON_SetInt(json_response, "t", 6);
				
				new Node:btn0 = JSON_Object("bi", JSON_Int(0), "bn", JSON_String("Мои шаблоны"), "be", JSON_String("Просмотр всех шаблонов"));
				new Node:btn1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Создать шаблон"), "be", JSON_String("Создать новый шаблон"));
				new Node:buttons = JSON_Array(btn0, btn1);
				
				JSON_SetArray(json_response, "bt", buttons);
				
				SendPacketToClient(playerid, 66, json_response);
				JSON_Cleanup(json_response);
			}
		}

	}
	
	JSON_Cleanup(json);
	return 1;
}

forward KickSpectate(to_player);
public KickSpectate(to_player)
{
	Kick(to_player);
} 
