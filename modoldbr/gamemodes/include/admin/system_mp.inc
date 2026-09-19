enum E_MP_STRUCT
{
	MP_CREATE, 			// создано ли мероприятие
	MP_NAME[32],        // название
	MP_PRIZE,           // приз на мероприятии
	MP_MAX_KOLVO,       // максимальное кол-во участников
	MP_KOLVO,           // кол-во участников
	MP_WORLD,           // вирт мир мп
	MP_CLOSE,           // закрыт ли телепорт на мп
	Float: MP_POS_X,    // координата X
	Float: MP_POS_Y,    // координата Y
	Float: MP_POS_Z     // координата Z
};

new mp[E_MP_STRUCT];

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    case DIALOG_MP_MENU:
			{
				if(response)
				{
					new query[144];

				    switch(listitem)
				    {
						case 0: // создание
						{
						    if(!mp[MP_CREATE])
							{
								Dialog
								(
									playerid, DIALOG_MP_CREATE, DIALOG_STYLE_INPUT,
									"{FF6347}KNYAZEV MOBILE {FFFFFF}| Создать мероприятие",
									"{FFFFFF}Для того, чтобы создать мероприятие - придумайте и впишите\n"\
									"его название в диалоговое поле ниже.\n\n"\
									"Дилна от 3 до 32 символов, буквы латинского или русского алфавита, цифры.",
									"Далее", "Отмена"
								);
							}
                            else
							{
								ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие уже кем-то создано.", "");
							}
						}
						case 1: // выдать оружие
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");
						    
							Dialog
							(
								playerid, DIALOG_MP_GUN, DIALOG_STYLE_LIST,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Выдать оружие",
								"Desert Eagle\n"\
								"Shotgun\n"\
								"MP5\n"\
								"AK-47\n"\
								"Rifle",
								"Далее", "Отмена"
							);
						}
						case 2: // выдать здоровье
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");
						    
						    Dialog
							(
								playerid, DIALOG_MP_HP, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Выдать здоровье",
								"Вы уверены в том, что хотите установить всем участникам меропрития\n\
								максимальное значение здоровья персонажа (100.0)?",
								"Далее", "Отмена"
							);
						}
						case 3: // забрать оружие
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");
						    
							Dialog
							(
								playerid, DIALOG_MP_TAKE_GUN, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Обезоружить игроков",
								"Вы уверены в том, что хотите обезоружить всех участников мероприятия?\n\n\
								Важно понимать, что совершенно все оружие (даже личное) будет функционально\n\
                                изъято у всех игроков, которые находятся на мероприятии.",
								"Далее", "Отмена"
							);
						}
						case 4: // выдать броню
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");
						    
							Dialog
							(
								playerid, DIALOG_MP_ARMOUR, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Выдать броню",
								"Вы уверены в том, что хотите установить всем участникам мероприятия\n\
                                максимальное значение брони для персонажа (100.0)?",
								"Далее", "Отмена"
							);
						}
						case 5: // забрать броню
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");

							Dialog
							(
								playerid, DIALOG_MP_TAKE_ARMOUR, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Выдать броню",
								"Вы уверены в том, что хотите установить у всех участников мероприятия\n\
                                минимальное значение брони для персонажа (0.0)?",
								"Далее", "Отмена"
							);
						}
						case 6: // исключить участника
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");

							Dialog
							(
								playerid, DIALOG_MP_KICK, DIALOG_STYLE_INPUT,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Исключить игрока",
								"Для того, чтобы исключить игрока из мероприятия - необходимо\n"\
								"ввести его идентификатор (ID) в диалоговое поле ниже",
								"Готово", "Отмена"
							);
						}
						case 7: // телепортироваться на место мп
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");

							Dialog
							(
								playerid, DIALOG_MP_ATP, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Телепортироваться на мероприятие",
								"Вы уверены в том, что хотите телепортироваться на место проведения мероприятия?",
								"Далее", "Отмена"
							);
						}
						case 8: // заморозить
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");

							Dialog
							(
								playerid, DIALOG_MP_ALLFREEZE, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Заморозить игроков",
								"Вы уверены в том, что хотите заморозить всех участников\n\
                                мероприятия?\n\n\
                                Важно понимать, что совершенно все участники больше не\n\
                                смогут двигаться и совершать каких-либо действий до\n\
								момента их полной разморозки.",
								"Далее", "Отмена"
							);
						}
						case 9: // разморозить
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
						    
						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");

							Dialog
							(
								playerid, DIALOG_MP_UN_ALLFREEZE, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Разморозить игроков",
								"Вы уверены в том, что хотите разморозить всех участников\n\
                                мероприятия?\n\n\
                                Важно понимать, что совершенно все участники смогут\n\
                                двигаться и совершать какие-либо действий до\n\
								момента их полной заморозки.",
								"Далее", "Отмена"
							);
						}
						case 10: // разделить на две команды
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");
							//Notka(playerid, 2, "В разработке", 4, "", "");
						}
						case 11: // закончить мп с победителем
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");

						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");
						    
						    if(mp[MP_CLOSE] == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "С момента создания мероприятия не прошла минута", "");

							Dialog
							(
								playerid, DIALOG_MP_PRIZE_PLAYER, DIALOG_STYLE_INPUT,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Выдать вознагрождение и закончить",
								"Для того, чтобы закончить активное мероприятие и выдать какому-либо игроку заслуженное\n"\
								"вознаграждение - заполните и отправьте шаблон: ID победителя, сумма вознаграждения\n\n"\
								"Сумма вознаграждения: от 50.000 до 500.000 игровых рублей",
								"Готово", "Отмена"
							);
						}
						case 12: // закончить мп без победителя
						{
						    if(!mp[MP_CREATE]) return ShowNewNotification(playerid, 2, 4, 1, 1, "Мероприятие не создано", "");

						    if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии.", "");
						    
						    if(mp[MP_CLOSE] == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "С момента создания мероприятия не прошла минута", "");

							Dialog
							(
								playerid, DIALOG_MP_FINISH, DIALOG_STYLE_MSGBOX,
								"{FF6347}KNYAZEV MOBILE {FFFFFF}| Закончить мероприятие",
								"Вы уверены в том, что хотите закончить мероприятие без победителя?",
								"Готово", "Отмена"
							);
						}
				    }
				}
			}
			case DIALOG_MP_WORLD:
			{
				if(response)
				{
				    switch(listitem)
				    {
						case 0:
						{
						    mp[MP_WORLD] = 0;
						    mp[MP_CREATE] = 1;
						    mp[MP_CLOSE] = 0;
						    
						    new Float: x,
							Float: y,
							Float: z,
							Float: a,
							skin = GetPlayerSkin(playerid);

							GetPlayerPos(playerid, x, y, z);
							GetPlayerFacingAngle(playerid, a);

							SetPlayerMpData(playerid, G_MP_POS_X, x);
							SetPlayerMpData(playerid, G_MP_POS_Y, y);
							SetPlayerMpData(playerid, G_MP_POS_Z, z);
							SetPlayerMpData(playerid, G_MP_ANGLE, a);

							SetPlayerMpData(playerid, G_MP_INTERIOR, GetPlayerInterior(playerid));
							SetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

							SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
						    
						    GetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);
						    
						    SetPlayerVirtualWorld(playerid, 0);
						    
						    SetTimer("CloseMpTeleport", 60000, false);
						    
						    SetPlayerData(playerid, P_LAST_MP, 1);
						    
						    new query[999];
						    
						    format(query, sizeof query, "{EDBF23}Уважаемые игроки, сейчас пройдет мероприятие под названием {A5871A}'%s'{EDBF23}.", mp[MP_NAME]);
							SendClientMessageToAll(-1, query);
							format(query, sizeof query, "{EDBF23}Достное количество участников: {A5871A}%d человек, {EDBF23}будьте аккуратнее, оружие может быть отобрано.", mp[MP_MAX_KOLVO]);
							SendClientMessageToAll(-1, query);
							format(query, sizeof query, "{EDBF23}Ровно через минуту доступ к телепортации на место проведения мероприятия будет автоматически закрыт.");
							SendClientMessageToAll(-1, query);
							format(query, sizeof query, "{EDBF23}Для того, чтобы поучаствовать в мероприятии - воспользуйтесь командой: {A5871A}'/gevent'{EDBF23}.");
							SendClientMessageToAll(-1, query);
							
							format(query, sizeof query, "[A] Администратор %s[%d] создал мероприятие '%s' в глобальном мире", GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
							SendMessageToAdmins(query, 0x999999FF);
						}
						case 1:
						{
						    mp[MP_WORLD] = 100;
						    mp[MP_CREATE] = 1;
						    mp[MP_CLOSE] = 0;
						    
						    new Float: x,
							Float: y,
							Float: z,
							Float: a,
							skin = GetPlayerSkin(playerid);

							GetPlayerPos(playerid, x, y, z);
							GetPlayerFacingAngle(playerid, a);

							SetPlayerMpData(playerid, G_MP_POS_X, x);
							SetPlayerMpData(playerid, G_MP_POS_Y, y);
							SetPlayerMpData(playerid, G_MP_POS_Z, z);
							SetPlayerMpData(playerid, G_MP_ANGLE, a);

							SetPlayerMpData(playerid, G_MP_INTERIOR, GetPlayerInterior(playerid));
							SetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

							SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
						    
						    GetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);
						    
						    SetPlayerVirtualWorld(playerid, 100);
						    
						    SetTimer("CloseMpTeleport", 60000, false);
						    
						    SetPlayerData(playerid, P_LAST_MP, 1);

						    new query[999];

						    format(query, sizeof query, "{EDBF23}Уважаемые игроки, сейчас пройдет мероприятие под названием {A5871A}'%s'{EDBF23}.", mp[MP_NAME]);
							SendClientMessageToAll(-1, query);
							format(query, sizeof query, "{EDBF23}Достное количество участников: {A5871A}%d человек, {EDBF23}будьте аккуратнее, оружие может быть отобрано.", mp[MP_MAX_KOLVO]);
							SendClientMessageToAll(-1, query);
							format(query, sizeof query, "{EDBF23}Ровно через минуту доступ к телепортации на место проведения мероприятия будет автоматически закрыт.");
							SendClientMessageToAll(-1, query);
							format(query, sizeof query, "{EDBF23}Для того, чтобы поучаствовать в мероприятии - воспользуйтесь командой: {A5871A}'/gevent'{EDBF23}.");
							SendClientMessageToAll(-1, query);
							
							format(query, sizeof query, "[A] Администратор %s[%d] создал мероприятие '%s' в отдельном виртуальном мире", GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
							SendMessageToAdmins(query, 0x999999FF);
						}
				    }
				}
			}
			case DIALOG_MP_HP:
			{
				if(response)
				{
				    new query[999];
				    
                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						SetPlayerData(i, P_HEALTH, 100);
						SetPlayerHealthEx(i, 100);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}установил всем максимальное значение здоровья.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(i, -1, query);
					}
		  		}
			}
			case DIALOG_MP_TAKE_GUN:
			{
				if(response)
				{
				    new query[999];

                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						ResetPlayerWeapons(i);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}отобрал все имеющееся оружие на мероприятии.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(i, -1, query);
					}
		  		}
			}
			case DIALOG_MP_ARMOUR:
			{
				if(response)
				{
				    new query[999];

                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						SetPlayerArmour(i, 100.0);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}установил всем максимальное значение брони.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(i, -1, query);
					}
		  		}
			}
			case DIALOG_MP_TAKE_ARMOUR:
			{
				if(response)
				{
				    new query[999];

                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						SetPlayerArmour(i, 0.0);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}отобрал всю имеющуюся броню на мероприятии.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(i, -1, query);
					}
		  		}
			}
			case DIALOG_MP_KICK:
			{
				if(response)
				{
					new to_player;
					
					new query[999];

					if(sscanf(inputtext, "d", to_player))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::event(playerid, "");

						return 1;
					}
					else
					{
					    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return ShowNewNotification(playerid, 2, 4, 1, 1, "Такого игрока нет в сети.", "");
						if(!IsPlayerConnected(to_player) || to_player == playerid) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не можете исключить самого себя.", "");
						if(GetPlayerData(to_player, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Игрок не участник мероприятия", "");
						
						SetPlayerPosEx
						(
							to_player,
							GetPlayerMpData(to_player, G_MP_POS_X),
							GetPlayerMpData(to_player, G_MP_POS_Y),
							GetPlayerMpData(to_player, G_MP_POS_Z),
							GetPlayerMpData(to_player, G_MP_ANGLE),
							GetPlayerMpData(to_player, G_MP_INTERIOR),
							GetPlayerMpData(to_player, G_MP_VIRTUAL_WORLD)
						);
						
						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_LAST_MP) == 0) continue;

							format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}исключил игрока {A5871A}%s[%d] {EDBF23}из списка участников мероприятия.", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
							SendClientMessage(i, -1, query);
						}
						
						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}исключил Вас из списка участников мероприятия.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(to_player, -1, query);

						SetPlayerData(to_player, P_LAST_MP, 0);
					}
				}
			}
			case DIALOG_MP_ATP:
			{
				if(response)
				{
				    new query[999];
				    
                    if(!mp[MP_POS_X]) return SendClientMessage(playerid, 0xCECECEFF, "Координаты мероптиятия не выставлены");
                    
                    new Float: x,
					Float: y,
					Float: z,
					Float: a,
					skin = GetPlayerSkin(playerid);

					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, a);

					SetPlayerMpData(playerid, G_MP_POS_X, x);
					SetPlayerMpData(playerid, G_MP_POS_Y, y);
					SetPlayerMpData(playerid, G_MP_POS_Z, z);
					SetPlayerMpData(playerid, G_MP_ANGLE, a);

					SetPlayerMpData(playerid, G_MP_INTERIOR, GetPlayerInterior(playerid));
					SetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

					SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
                    
                    SetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);
                    
                    SetPlayerVirtualWorld(playerid, mp[MP_WORLD]);
                    
                    SetPlayerData(playerid, P_LAST_MP, 1);

                    format(query, sizeof query, "{EDBF23}Вы телепортировались на место проведения мероприятия.", GetPlayerNameEx(playerid), playerid);
					SendClientMessage(playerid, -1, query);
		  		}
			}
			case DIALOG_MP_ALLFREEZE:
			{
				if(response)
				{
				    new query[999];

                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						TogglePlayerControllable(i, 0);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}заморозил всех участников мероприятия.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(i, -1, query);
					}
		  		}
			}
			case DIALOG_MP_UN_ALLFREEZE:
			{
				if(response)
				{
				    new query[999];

                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						TogglePlayerControllable(i, 1);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}разморозил всех участников мероприятия.", GetPlayerNameEx(playerid), playerid);
						SendClientMessage(i, -1, query);
					}
		  		}
			}
			case DIALOG_MP_PRIZE_PLAYER:
			{
				if(response)
				{
					new to_player, prize;

					new query[999];
                    if(sscanf(inputtext, "P<,>dd", to_player, prize))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::event(playerid, "");

						return 1;
					}
					else
					{
					    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return ShowNewNotification(playerid, 2, 4, 1, 1, "Такого игрока нет в сети.", "");
						if(!IsPlayerConnected(to_player) || to_player == playerid) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не можете выдать приз самому себе.", "");
						if(GetPlayerData(to_player, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Игрок не участник мероприятия", "");
						
						if(!(50000 <= prize <= 500000))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Приз должен быть от 50.000 до 500.000 рублей");
							callcmd::event(playerid, "");

							return 1;
						}

						SetPlayerPosEx
						(
							to_player,
							GetPlayerMpData(to_player, G_MP_POS_X),
							GetPlayerMpData(to_player, G_MP_POS_Y),
							GetPlayerMpData(to_player, G_MP_POS_Z),
							GetPlayerMpData(to_player, G_MP_ANGLE),
							GetPlayerMpData(to_player, G_MP_INTERIOR),
							GetPlayerMpData(to_player, G_MP_VIRTUAL_WORLD)
						);
						
						SetPlayerPosEx
						(
							playerid,
							GetPlayerMpData(playerid, G_MP_POS_X),
							GetPlayerMpData(playerid, G_MP_POS_Y),
							GetPlayerMpData(playerid, G_MP_POS_Z),
							GetPlayerMpData(playerid, G_MP_ANGLE),
							GetPlayerMpData(playerid, G_MP_INTERIOR),
							GetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD)
						);

						format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}закончил мероприятие под названием {A5871A}'%s' {EDBF23}.", GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
						SendClientMessageToAll(-1, query);

						format(query, sizeof query, "{EDBF23}Игрок {A5871A}%s[%d] {EDBF23}получил вознаграждение в размере: {A5871A}%d {EDBF23}игровых рублей.", GetPlayerNameEx(to_player), to_player, prize);
						SendClientMessageToAll(-1, query);
						
						format(query, sizeof query, "{EDBF23}Мероприятие было окончено, мы телепортировали Вас обратно на исходное место!", GetPlayerNameEx(to_player), to_player, prize);
						SendClientMessage(to_player, -1, query);
						
						format(query, sizeof query, "{EDBF23}Мероприятие было окончено, мы телепортировали Вас обратно на исходное место!");
						SendClientMessage(playerid, -1, query);
						
						format(query, sizeof query, "Вы получили %d рублей", prize);
						ShowNewNotification(to_player, 1, 4, 1, 1, query, "");
						GivePlayerMoneyEx(to_player, prize);

						SetPlayerData(to_player, P_LAST_MP, 0);
						
						mp[MP_CREATE] = 0;
						mp[MP_KOLVO] = 0;
					}
				}
			}
			case DIALOG_MP_FINISH:
			{
				if(response)
				{
				    new query[999];
				    
				    format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}закончил мероприятие под названием {A5871A}'%s' {EDBF23} без победителя.", GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
					SendClientMessageToAll(-1, query);

                    for(new i; i < MAX_PLAYERS; i ++)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_LAST_MP) == 0) continue;

						SetPlayerPosEx
						(
							i,
							GetPlayerMpData(i, G_MP_POS_X),
							GetPlayerMpData(i, G_MP_POS_Y),
							GetPlayerMpData(i, G_MP_POS_Z),
							GetPlayerMpData(i, G_MP_ANGLE),
							GetPlayerMpData(i, G_MP_INTERIOR),
							GetPlayerMpData(i, G_MP_VIRTUAL_WORLD)
						);
						
						format(query, sizeof query, "{EDBF23}Мероприятие было окончено, мы телепортировали Вас обратно на исходное место!");
						SendClientMessage(i, -1, query);
						
						SetPlayerData(i, P_LAST_MP, 0);
						
                        mp[MP_CREATE] = 0;
                        mp[MP_KOLVO] = 0;
					}
		  		}
			}
			case DIALOG_MP_GUN:
			{
			    if(response)
				{
				    new query[999];
				    
				    switch(listitem)
				    {
						case 0: // дигл
						{
							for(new i; i < MAX_PLAYERS; i ++)
							{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_LAST_MP) == 0) continue;

                                    GivePlayerWeapon(i, 24, 500);
                                    
                                    format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}выдал всем оружие {A5871A}'Desert Eagle' + 500 патрон {EDBF23}к нему.", GetPlayerNameEx(playerid), playerid);
									SendClientMessage(i, -1, query);
							}
						}
						case 1: // дробовик
						{
						    for(new i; i < MAX_PLAYERS; i ++)
							{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_LAST_MP) == 0) continue;

                                    GivePlayerWeapon(i, 25, 500);

                                    format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}выдал всем оружие {A5871A}'Shotgun' + 500 патрон {EDBF23}к нему.", GetPlayerNameEx(playerid), playerid);
									SendClientMessage(i, -1, query);
							}
						}
						case 2: // мп5
						{
						    for(new i; i < MAX_PLAYERS; i ++)
							{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_LAST_MP) == 0) continue;

                                    GivePlayerWeapon(i, 29, 500);

                                    format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}выдал всем оружие {A5871A}'MP5' + 500 патрон {EDBF23}к нему.", GetPlayerNameEx(playerid), playerid);
									SendClientMessage(i, -1, query);
							}
						}
						case 3: // ак-47
						{
						    for(new i; i < MAX_PLAYERS; i ++)
							{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_LAST_MP) == 0) continue;

                                    GivePlayerWeapon(i, 30, 500);

                                    format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}выдал всем оружие {A5871A}'AK-47' + 500 патрон {EDBF23}к нему.", GetPlayerNameEx(playerid), playerid);
									SendClientMessage(i, -1, query);
							}
						}
						case 4: // рифл винтовка
						{
						    for(new i; i < MAX_PLAYERS; i ++)
							{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_LAST_MP) == 0) continue;

                                    GivePlayerWeapon(i, 33, 500);

                                    format(query, sizeof query, "{EDBF23}Администратор {A5871A}%s[%d] {EDBF23}выдал всем оружие {A5871A}'Rifle' + 500 патрон {EDBF23}к нему.", GetPlayerNameEx(playerid), playerid);
									SendClientMessage(i, -1, query);
							}
						}
				    }
				}
			}
			case DIALOG_MP_KOLVO:
			{
				if(response)
				{
					new kolvo;

					if(sscanf(inputtext, "d", kolvo))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::event(playerid, "");

						return 1;
					}
					else
					{
						if(!(5 <= kolvo <= 100))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Количество участников должно быть от 5 до 100");
							callcmd::event(playerid, "");

							return 1;
						}

						mp[MP_MAX_KOLVO] = kolvo;

						Dialog
						(
							playerid, DIALOG_MP_WORLD, DIALOG_STYLE_LIST,
							"{FF6347}KNYAZEV MOBILE {FFFFFF}| Выберите виртуальный мир",
							"Выбрать глобальный мир, где находятся все игроки сервера.\n"\
							"Создать отдельный виртуальный мир, в котором будут только участники мероприятия.",
							"Готово", "Отмена"
						);
					}
				}
			}
			case DIALOG_MP_CREATE:
			{
				if(response)
				{
					new name[32];

					if(sscanf(inputtext, "s[32]", name)) //if(sscanf(inputtext, "P<,>s[32]", name))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::event(playerid, "");

						return 1;
					}
					else
					{
						/*if(!(5 <= kolvo <= 100))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Количество участников должно быть от 5 до 100");
							callcmd::event(playerid, "");

							return 1;
						}*/

						//mp[MP_CREATE] = 1;
						format(mp[MP_NAME], 32, name);
						
						Dialog
						(
							playerid, DIALOG_MP_KOLVO, DIALOG_STYLE_INPUT,
							"{FF6347}KNYAZEV MOBILE {FFFFFF}| Создать мероприятие",
							"{FFFFFF}Для того, чтобы продолжить создание мероприятия - впишите\n"\
							"количество возможных участников в диалоговое поле ниже.\n\n"\
							"Лимиты на количество - от 5 до 100 участников.",
							"Далее", "Отмена"
						);
						//mp[MP_PRIZE] = prize;
					}
				}
			}
	return 1;
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

public: CloseMpTeleport()
{
    new query[999];

	format(query, sizeof query, "{EDBF23}Телепортация на место проведения мероприятия была автоматически закрыта. Набрано участников: {A5871A}%d из %d{EDBF23}.", mp[MP_KOLVO], mp[MP_MAX_KOLVO]);
	SendClientMessageToAll(-1, query);
	
	mp[MP_CLOSE] = 1;

	return 1;
}

CMD:event(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) >= 2 || GetPlayerYouTubeEx(playerid))
	{
	//if(GetPlayerAdminEx(playerid) < 2) return ShowNotification(playerid, 2, "У Вас нет доступа к использованию данной команды", 7, "", "");
		Dialog
		(
			playerid, DIALOG_MP_MENU, DIALOG_STYLE_LIST,
			"{FF6347}KNYAZEV MOBILE {FFFFFF}| Меню мероприятия",
			"{FF6347}1. {FFFFFF}Создать мероприятие\n"\
			"{FF6347}2. {FFFFFF}Выдать всем участникам мероприятия оружие\n"\
			"{FF6347}3. {FFFFFF}Выдать всем участникам мероприятия здоровье\n"\
			"{FF6347}4. {FFFFFF}Обезоружить всех участников мероприятия\n"\
			"{FF6347}5. {FFFFFF}Выдать всем участникам мероприятия броню\n"\
			"{FF6347}6. {FFFFFF}Забрать у всех участников мероприятия броню\n"\
			"{FF6347}7. {FFFFFF}Исключить участника мероприятия\n"\
			"{FF6347}8. {FFFFFF}Телепортироваться на место проведения мероприятия\n"\
			"{FF6347}9. {FFFFFF}Заморозить всех участников мероприятия\n"\
		    "{FF6347}10. {FFFFFF}Разморозить всех участников мероприятия\n"\
		    "{FF6347}11. {FFFFFF}Разделить участников мероприятия на две команды\n"\
		    "{FF6347}12. {FFFFFF}Закончить мероприятие и выдать вознаграждение\n"\
			"{FF6347}13. {FFFFFF}Закончить мероприятие без победителя",
			"Далее", "Закрыть"
		);
	}
	else ShowNotification(playerid, 2, "У Вас нет доступа к использованию данной команды", 7, "", "");
}

CMD:gevent(playerid, params[])
{
	if(!mp[MP_CREATE]) return SendClientMessage(playerid, 0xCECECEFF, "Мероприятие не создано");

	if(!mp[MP_POS_X]) return SendClientMessage(playerid, 0xCECECEFF, "Координаты мероптиятия не выставлены");
	
	if(GetPlayerData(playerid, P_LAST_MP) == 1) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы уже находитесь на мероприятии", "");
	
	if(mp[MP_KOLVO] == mp[MP_MAX_KOLVO]) return SendClientMessage(playerid, -1, "На мероприятии набрано максимальное количество участников.");
	
	if(mp[MP_CLOSE] == 1) return SendClientMessage(playerid, -1, "Телепортация на место проведения мероприятия закрыта.");
	
	new Float: x,
	Float: y,
	Float: z,
	Float: a,
	skin = GetPlayerSkin(playerid);

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	SetPlayerMpData(playerid, G_MP_POS_X, x);
	SetPlayerMpData(playerid, G_MP_POS_Y, y);
	SetPlayerMpData(playerid, G_MP_POS_Z, z);
	SetPlayerMpData(playerid, G_MP_ANGLE, a);

	SetPlayerMpData(playerid, G_MP_INTERIOR, GetPlayerInterior(playerid));
	SetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

	SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	
	SetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);
	
	SetPlayerVirtualWorld(playerid, mp[MP_WORLD]);
	
	SendClientMessage(playerid, -1, "Вы были телепортированы на мероприятие");
	
	mp[MP_KOLVO] += 1;

	SetPlayerData(playerid, P_LAST_MP, 1);

	return 1;
}

CMD:cevent(playerid, params[])
{
	if(!mp[MP_CREATE]) return SendClientMessage(playerid, 0xCECECEFF, "Мероптиятие не создано");

	if(GetPlayerData(playerid, P_LAST_MP) == 0) return ShowNewNotification(playerid, 2, 4, 1, 1, "Вы не находитесь на мероприятии", "");
	
	if(GetPlayerData(playerid, P_LAST_MP) == 1)
	{
		mp[MP_KOLVO] -= 1;
	}
	
	SetPlayerPosEx
	(
		playerid,
		GetPlayerMpData(playerid, G_MP_POS_X),
		GetPlayerMpData(playerid, G_MP_POS_Y),
		GetPlayerMpData(playerid, G_MP_POS_Z),
		GetPlayerMpData(playerid, G_MP_ANGLE),
		GetPlayerMpData(playerid, G_MP_INTERIOR),
		GetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD)
	);
	
	SetPlayerVirtualWorld(playerid, GetPlayerMpData(playerid, G_MP_VIRTUAL_WORLD));
	SetPlayerInterior(playerid, GetPlayerMpData(playerid, G_MP_INTERIOR));

	SendClientMessage(playerid, -1, "Вы успешно покинули мероприятие");

	SetPlayerData(playerid, P_LAST_MP, 0);

	return 1;
}

CMD:emsg(playerid, params[])
{
	if(!mp[MP_CREATE]) return SendClientMessage(playerid, 0xCECECEFF, "Мероптиятие не создано");
	
	if(GetPlayerAdminEx(playerid) >= 2)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /emsg [текст]");

        new fmt_str[999];

		for(new i; i < MAX_PLAYERS; i ++)
		{
			if(!IsPlayerConnected(i)) continue;
			if(!IsPlayerLogged(i)) continue;
			if(GetPlayerData(i, P_LAST_MP) == 0) continue;

			format(fmt_str, sizeof fmt_str, "{EDBF23}[EVENT] Администратор %s[%d]: {A5871A}%s", GetPlayerNameEx(playerid), playerid, params);
			SendClientMessage(i, -1, fmt_str);
		}
	}
	return 1;
}