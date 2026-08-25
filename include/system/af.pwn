//============ [af system] ====================
new names[MAX_PLAYERS];//Добыча имени в /af
new spawnaf[MAX_PLAYERS];
new kickaf[MAX_PLAYERS];
new banaf[MAX_PLAYERS];
new warnaf[MAX_PLAYERS];
new unwarnaf[MAX_PLAYERS];
new unbanaf[MAX_PLAYERS];
new af[MAX_PLAYERS];//Переменная которая хранит общие формы
//==================================================



//=====================[OnDialogResponse]
case DIALOG_AF:
			{
			    if(response)
			    {
	                switch(listitem)
	                {
	       				case 0:
				        {
							if(af[playerid] == 0)
							{
								SCM(playerid, COLOR_RED, "Административные формы не найдены системой!");
							}
							else
							{
								if(spawnaf[playerid] == 1)
        						{
        						    new id = names[playerid];
        							new string[5000];
									format(string, sizeof(string), "{ffff00}|{ffffff} Ник нейм администратора: %s\n{ffff00}|{ffffff} Причина: %s\n{ffff00}|{ffffff} Ник нейм игрока:%s", GetPlayerNameEx(playerid), g_player[playerid][P_AFREASON], GetPlayerNameEx(id));
									SPD(playerid, DIALOG_SPAWNOD, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Одобрение формы /spawn", string, "Одобрить", "Закрыть");
								}
								if(kickaf[playerid] == 1)
        						{
        						    new id = names[playerid];
        							new string[5000];
									format(string, sizeof(string), "{ffff00}|{ffffff} Ник нейм администратора: %s\n{ffff00}|{ffffff} Причина: %s\n{ffff00}|{ffffff} Ник нейм игрока:%s", GetPlayerNameEx(playerid),  g_player[playerid][P_AFREASON], GetPlayerNameEx(id));
									SPD(playerid, DIALOG_KICKOD, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Одобрение формы /kick", string, "Одобрить", "Закрыть");
								}
								if(banaf[playerid] == 1)
        						{
        						    new id = names[playerid];
        							new string[5000];
									format(string, sizeof(string), "{ffff00}|{ffffff} Ник нейм администратора: %s\n{ffff00}|{ffffff} Причина: %s\n{ffff00}|{ffffff} Ник нейм игрока:%s", GetPlayerNameEx(playerid),  g_player[playerid][P_AFREASON], GetPlayerNameEx(id));
									SPD(playerid, DIALOG_BANOD, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Одобрение формы /ban", string, "Одобрить", "Закрыть");
								}
								if(warnaf[playerid] == 1)
        						{
        						    new id = names[playerid];
        							new string[5000];
									format(string, sizeof(string), "{ffff00}|{ffffff} Ник нейм администратора: %s\n{ffff00}|{ffffff} Причина: %s\n{ffff00}|{ffffff} Ник нейм игрока:%s", GetPlayerNameEx(playerid),  g_player[playerid][P_AFREASON], GetPlayerNameEx(id));
									SPD(playerid, DIALOG_WARNOD, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Одобрение формы /warn", string, "Одобрить", "Закрыть");
								}
								if(unwarnaf[playerid] == 1)
        						{
        						    new id = names[playerid];
        							new string[5000];
									format(string, sizeof(string), "{ffff00}|{ffffff} Ник нейм администратора: %s\n{ffff00}|{ffffff} Причина: %s\n{ffff00}|{ffffff} Ник нейм игрока:%s", GetPlayerNameEx(playerid),  g_player[playerid][P_AFREASON], GetPlayerNameEx(id));
									SPD(playerid, DIALOG_UNWARNOD, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Одобрение формы /unwarn", string, "Одобрить", "Закрыть");
								}
								if(unbanaf[playerid] == 1)
        						{
        						    new id = names[playerid];
        							new string[5000];
									format(string, sizeof(string), "{ffff00}|{ffffff} Ник нейм администратора: %s\n{ffff00}|{ffffff} Причина: %s\n{ffff00}|{ffffff} Ник нейм игрока:%s", GetPlayerNameEx(playerid),  g_player[playerid][P_AFREASON], GetPlayerNameEx(id));
									SPD(playerid, DIALOG_UNBANOD, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Одобрение формы /unban", string, "Одобрить", "Закрыть");
								}
							}
				        }
						case 1:
						{
							new string[1222];
							format(string, sizeof(string), ""c_red"#1"c_white"\t/spawn"c_gray"\tНажмите для взаимодействия\n"c_red"#2"c_white"\t/kick"c_gray"\tНажмите для взаимодействия\n"c_red"#3"c_white"\t/ban"c_gray"\tНажмите для взаимодействия\n"c_red"#4"c_white"\t/warn"c_gray"\tНажмите для взаимодействия\n"c_red"#5"c_white"\t/unwarn"c_gray"\tНажмите для взаимодействия\n"c_red"#6"c_white"\t/unban"c_gray"\tНажмите для взаимодействия");
							SPD(playerid, DIALOG_AFMENU, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Формы для выбора", string, "Далее", "Закрыть");
							return 1;
						}
	                }
			    }
			}
			case DIALOG_AFMENU:
			{
			    if(response)
			    {
					switch(listitem)
					{
					    case 0:
					    {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /spawn игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_SPAWNAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /spawn", string, "Далее", "Закрыть");
					    }
  			    		case 1:
					    {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /kick игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_KICKAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /kick", string, "Далее", "Закрыть");
					    }
	    				case 2:
					    {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /ban игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_BANAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /ban", string, "Далее", "Закрыть");
					    }
		    			case 3:
					    {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /warn игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_WARNAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /warn", string, "Далее", "Закрыть");
					    }
 	    				case 4:
					    {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /unwarn игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_UNWARNAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /unwarn", string, "Далее", "Закрыть");
					    }
	    				case 5:
					    {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /unban игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_UNBANAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /unban", string, "Далее", "Закрыть");
					    }
					}
			    }
			}
			case DIALOG_UNBANAF:
			{
			    if(response)
			    {
			        if(!strlen(inputtext))
			        {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /unban игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_UNBANAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /unban", string, "Далее", "Закрыть");
			        }
					else
					{
						new id = names[playerid];
				        new string[500], query[200];
						strmid(g_player[playerid][P_AFREASON], inputtext, 0, strlen(inputtext), 16);
	           			format(string, sizeof(string), ""c_white"Вы успешно отправили форму на /unban");
	           			format(query, sizeof(query), ""c_white"Администратор: %s отправил форму на unban игрока: %s с причиной: %s. Введите /af для одобрения формы!", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
	           			SendMessageToAdmins(query, COLOR_WHITE);
				        SCM(playerid, COLOR_RED, string);
	                    unbanaf[playerid] = 1;
	                    af[playerid] = 1;
					}
			    }
			}
			case DIALOG_UNWARNAF:
			{
			    if(response)
			    {
			        if(!strlen(inputtext))
			        {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /unwarn игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_UNWARNAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /unwarn", string, "Далее", "Закрыть");
			        }
					else
					{
						new id = names[playerid];
				        new string[500], query[200];
				        strmid(g_player[playerid][P_AFREASON], inputtext, 0, strlen(inputtext), 16);
	           			format(string, sizeof(string), ""c_white"Вы успешно отправили форму на /unwarn");
	           			format(query, sizeof(query), ""c_white"Администратор: %s отправил форму на unwarn игрока: %s с причиной: %s. Введите /af для одобрения формы!", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
	           			SendMessageToAdmins(query, COLOR_WHITE);
				        SCM(playerid, COLOR_RED, string);
	                    unwarnaf[playerid] = 1;
	                    af[playerid] = 1;
					}
			    }
			}
			case DIALOG_WARNAF:
			{
			    if(response)
			    {
			        if(!strlen(inputtext))
			        {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /warn игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_WARNAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /warn", string, "Далее", "Закрыть");
			        }
					else
					{
						new id = names[playerid];
				        new string[500], query[200];
				        strmid(g_player[playerid][P_AFREASON], inputtext, 0, strlen(inputtext), 16);
	           			format(string, sizeof(string), ""c_white"Вы успешно отправили форму на /warn");
	           			format(query, sizeof(query), ""c_white"Администратор: %s отправил форму на warn игрока: %s с причиной: %s. Введите /af для одобрения формы!", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
	           			SendMessageToAdmins(query, COLOR_WHITE);
				        SCM(playerid, COLOR_RED, string);
	                    warnaf[playerid] = 1;
	                    af[playerid] = 1;
					}
			    }
			}
			case DIALOG_BANAF:
			{
			    if(response)
			    {
			        if(!strlen(inputtext))
			        {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /ban игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_BANAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /ban", string, "Далее", "Закрыть");
			        }
					else
					{
						new id = names[playerid];
				        new string[500], query[200];
				        strmid(g_player[playerid][P_AFREASON], inputtext, 0, strlen(inputtext), 16);
	           			format(string, sizeof(string), ""c_white"Вы успешно отправили форму на /ban");
	           			format(query, sizeof(query), ""c_white"Администратор: %s отправил форму на ban игрока: %s с причиной: %s. Введите /af для одобрения формы!", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
	           			SendMessageToAdmins(query, COLOR_WHITE);
				        SCM(playerid, COLOR_RED, string);
	                    banaf[playerid] = 1;
	                    af[playerid] = 1;
					}
			    }
			}
			case DIALOG_KICKAF:
			{
   					if(!strlen(inputtext))
			        {
       						new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /kick игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_KICKAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /kick", string, "Далее", "Закрыть");
			        }
					else
					{
						new id = names[playerid];
				        new string[500], query[200];
				        strmid(g_player[playerid][P_AFREASON], inputtext, 0, strlen(inputtext), 16);
	           			format(string, sizeof(string), ""c_white"Вы успешно отправили форму на /kick ");
	           			format(query, sizeof(query), ""c_white"Администратор: %s отправил форму на kick игрока: %s с причиной: %s. Введите /af для одобрения формы!", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
	           			SendMessageToAdmins(query, COLOR_WHITE);
				        SCM(playerid, COLOR_RED, string);
	                    kickaf[playerid] = 1;
	                    af[playerid] = 1;
					}
			}
			case DIALOG_SPAWNAF:
			{
			    if(response)
			    {
			        if(!strlen(inputtext))
			        {
							new string[500];
                            format(string, sizeof(string), ""c_white"Уважаемый администратор. Админиские формы это не игрушка!"c_red"\nЭто очень ответственная вещь, а так же нужно соблюдать правила которые вы можете прочитать с помощью команды /admprav\n\n"c_white"Для формы на /spawn игрока введите [id] и [причину]!");
                            SPD(playerid, DIALOG_SPAWNAF, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} /spawn", string, "Далее", "Закрыть");
			        }
					else
					{
						new id = names[playerid];
				        new string[500], query[200];
				        strmid(g_player[playerid][P_AFREASON], inputtext, 0, strlen(inputtext), 16);
	           			format(string, sizeof(string), ""c_white"Вы успешно отправили форму на /spawn ");
	           			format(query, sizeof(query), ""c_white"Администратор: %s отправил форму на spawn игрока: %s с причиной: %s. Введите /af для одобрения формы!", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
	           			SendMessageToAdmins(query, COLOR_WHITE);
				        SCM(playerid, COLOR_RED, string);
	                    spawnaf[playerid] = 1;
	                    af[playerid] = 1;
					}
			    }
			}
			case DIALOG_SPAWNOD:
			{
				if(response)
				{
                	new id = names[playerid];
                	new string[500], query[200];
           			format(string, sizeof(string), "Вас успешно заспавнили!");
           			format(query, sizeof(query), ""c_white"Администратор: %s заспавнил игрока по форме /spawn игрока: %s по причине: %s | By N1kso x Neizvestev", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
           			SendMessageToAdmins(query, COLOR_WHITE);
			        SCM(playerid, COLOR_RED, string);
                	SpawnPlayer(id);
               	 	spawnaf[playerid] = 0;
                  	af[playerid] = 0;
				}
			}
			case DIALOG_KICKOD:
			{
				if(response)
				{
                	new id = names[playerid];
                	new string[500], query[200];
           			format(string, sizeof(string), "Вас успешно заспавнили!");
           			format(query, sizeof(query), ""c_white"Администратор: %s кикнул игрока по форме /kick игрока: %s по причине: %s | By N1kso x Neizvestev", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
           			SendMessageToAdmins(query, COLOR_WHITE);
			        SCM(playerid, COLOR_RED, string);
                	Kick(id);
               	 	kickaf[playerid] = 0;
                  	af[playerid] = 0;
				}
			}
			case DIALOG_BANOD:
			{
				if(response)
				{
				    new ban_time, reason[30];
                	new id = names[playerid];
                	new query[200];
           			format(query, sizeof(query), ""c_white"Администратор: %s забанил игрока по форме /ban игрока: %s по причине: %s | By N1kso x Neizvestev", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
           			SendMessageToAdmins(query, COLOR_WHITE);
           			AddBan(GetPlayerAccountID(id), gettime(), ban_time, GetPlayerIpEx(id), reason, GetPlayerNameEx(playerid));
					BanEx(id, reason);
               	 	banaf[playerid] = 0;
                  	af[playerid] = 0;
				}
			}
			case DIALOG_WARNOD:
			{
				if(response)
				{
                	new id = names[playerid];
                	new string[500], query[200];
           			format(string, sizeof(string), "Ваc заварнили по форме!");
           			format(query, sizeof(query), ""c_white"Администратор: %s выдал предупреждение игрока по форме /warn игрока: %s по причине: %s | By N1kso x Neizvestev", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
           			SendMessageToAdmins(query, COLOR_WHITE);
			        SCM(playerid, COLOR_RED, string);
         			AddPlayerData(id, P_WARN, +, 1);
					SetPlayerData(id, P_WARN_TIME, gettime() + (86400 * 10));
               	 	warnaf[playerid] = 0;
                  	af[playerid] = 0;
				}
			}
			case DIALOG_UNWARNOD:
			{
				if(response)
				{
                	new id = names[playerid];
                	new string[500], query[200];
           			format(string, sizeof(string), "С вас сняли варн!!");
           			format(query, sizeof(query), ""c_white"Администратор: %s снял предупреждение игрока по форме /unwarn игрока: %s по причине: %s | By N1kso x Neizvestev", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
           			SendMessageToAdmins(query, COLOR_WHITE);
			        SCM(playerid, COLOR_RED, string);
         			SetPlayerData(id, P_WARN, 		0);
					SetPlayerData(id, P_WARN_TIME, 	0);
					UpdatePlayerDatabaseInt(id, "warn", 		0);
					UpdatePlayerDatabaseInt(id, "warn_time", 	0);
               	 	unwarnaf[playerid] = 0;
                  	af[playerid] = 0;
				}
			}
			case DIALOG_UNBANOD:
			{
				if(response)
				{
					new query[128], uid;
                	new id = names[playerid];
                	new string[200];
           			format(string, sizeof(string), ""c_white"Администратор: %s разбанил игрока по форме /ban игрока: %s по причине: %s | By N1kso x Neizvestev", GetPlayerNameEx(playerid), GetPlayerNameEx(id),  g_player[playerid][P_AFREASON]);
           			SendMessageToAdmins(string, COLOR_WHITE);
     				mysql_format(mysql, query, sizeof query, "DELETE FROM `ban_list` WHERE `user_id` = %d", uid);
					mysql_query(mysql, query, false);
               	 	unbanaf[playerid] = 0;
                  	af[playerid] = 0;
				}
			}
//=======================================


//============================== [DALOG`S]
DIALOG_AF,
DIALOG_AFMENU,
DIALOG_SPAWNAF,
DIALOG_SPAWNOD,
DIALOG_KICKAF,
DIALOG_BANAF,
DIALOG_WARNAF,
DIALOG_UNWARNAF,
DIALOG_UNBANAF,
DIALOG_KICKOD,
DIALOG_BANOD,
DIALOG_WARNOD,
DIALOG_UNWARNOD,
DIALOG_UNBANOD,
DIALOG_AHELP,
//========================================

//CMD
CMD:af(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только {FFFF00}администрации сервера{FFFFFF}.");
	names[playerid] = params[0];
	new string[1222];
	format(string, sizeof(string), ""c_red"#1"c_white"\t\tАктивыне формы"c_gray"\tнажмите для взаимодействия\n"c_red"#2"c_white"\t\tПодать форму"c_gray"\tнажмите для взаимодействия");
	SPD(playerid, DIALOG_AF, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF}Формы администрации", string, "Далее", "Закрыть");
	return 1;
}