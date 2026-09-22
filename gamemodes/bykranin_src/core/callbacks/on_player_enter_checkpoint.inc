//>> Файл: bykranin_src/core/callbacks/on_player_enter_checkpoint.inc  (411 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerEnterCheckpoint
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerEnterCheckpoint(playerid)
{
	if(IsPlayerLogged(playerid) && TC_OnPlayerEnterCheckpoint(playerid)) return 1;
    new carid = GetPlayerVehicleID(playerid);

	
	if(GetPVarInt(playerid, "Uroga") == 1 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[2][0], urogcheck[2][1], urogcheck[2][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 2);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 2 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[3][0], urogcheck[3][1], urogcheck[3][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 3);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 3 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[4][0], urogcheck[4][1], urogcheck[4][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 4);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 4 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[5][0], urogcheck[5][1], urogcheck[5][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 5);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 5 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[6][0], urogcheck[6][1], urogcheck[6][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 6);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 6 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[7][0], urogcheck[7][1], urogcheck[7][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 7);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 7 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[8][0], urogcheck[8][1], urogcheck[8][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 8);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 8 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[9][0], urogcheck[9][1], urogcheck[2][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 9);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	
	if(GetPVarInt(playerid, "Uroga") == 9 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[10][0], urogcheck[10][1], urogcheck[10][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 10);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 10 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[11][0], urogcheck[11][1], urogcheck[11][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 11);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 11 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[12][0], urogcheck[12][1], urogcheck[12][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 12);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 12 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[13][0], urogcheck[13][1], urogcheck[13][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 13);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 13 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[14][0], urogcheck[14][1], urogcheck[14][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 14);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 14 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[15][0], urogcheck[15][1], urogcheck[15][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 15);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
    if(GetPVarInt(playerid, "Uroga") == 15 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[16][0], urogcheck[16][1], urogcheck[16][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 16);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 16 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[17][0], urogcheck[17][1], urogcheck[17][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы собрали урожай на этом дереве. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 17);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 17 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[17][0], urogcheck[17][1], urogcheck[17][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Ваша корзина с урожаем переполнена. Отнесите её на склад и продолжайте собирать");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 2);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	if(GetPVarInt(playerid, "Uroga") == 18 )
	{
	  DisablePlayerCheckpoint(playerid);
	  SetPlayerCheckpoint(playerid, urogcheck[0][0], urogcheck[0][1], urogcheck[0][2], 2.0);
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Вы отнесли урожай на склад. Отправляйтесь на следующей чекпоинт");
	  SendClientMessage(playerid, COLOR_LIGHTBLUE, ""SC"Для завершения работы и получения зарплаты отправляйтесь к Дитюковичу");
	  SetPVarInt(playerid, "Uroga", 1);
	  SetPVarInt(playerid, "UrogMoney", GetPVarInt(playerid, "UrogMoney") + UrogMoney);
	ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
	  return 1;
	}
	
	
	
	if (g_PlayerQuestState[playerid] == QUEST_IN_PROGRESS) 
{
        // Игрок достиг Злой Зины
        ShowPlayerDialog(playerid, DIALOG_END_QUEST, DIALOG_STYLE_MSGBOX, 
                         "Злая Зина: Спасибо за бумаги! Возвращайся к Старикам.", 
                         "Спасибо", "Нет проблем", "");
    }


	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	new action_type = GetPlayerCPInfo(playerid, CP_ACTION_TYPE);
	if(IsPlayerInCheckpoint(playerid))
	{
		switch(action_type)
		{
			case CP_ACTION_TYPE_LOADER_JOB_TAKE:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LOADER_LOAD)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{
							DisablePlayerCheckpoint(playerid);

							ClearAnimations(playerid);
							ApplyAnimationEx(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);
							SetTimerEx("SetPlayerLoaderJobLoad", 1000, false, "ii", playerid, g_BRAuthEpoch[playerid]);
						}
					}
				}
			}
			case CP_ACTION_TYPE_MINER_JOB_PUT:
            {
                if(GetPlayerTempJob(playerid) != TEMP_JOB_MINER ||
                    GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_MINER_UNLOAD ||
                    IsPlayerInAnyVehicle(playerid)) return 1;
                if(g_mineCarrySlot[playerid] == -1) return 1;

                new fmt_str[64];
                //
                new rand = random(10) + 5;
                new items = GetPlayerJobLoadItems(playerid) + rand;
                //
                Mine_ClearCarry(playerid);
                //
                ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
                SetPlayerJobLoadItems(playerid, items);
                //
                SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
                //
                format(fmt_str, sizeof fmt_str, "Вы доставили {FF9900}%d кг {32a44b}руды", rand);
                SendClientMessage(playerid, 0x32a44bFF, fmt_str);
                //
                format(fmt_str, sizeof fmt_str, "Общее количество добытого сырья: {FF9900}%d кг", items);
                SendClientMessage(playerid, 0x1E90FFFF, fmt_str);
                //
                format(fmt_str, sizeof fmt_str, "+ %d кг", rand);
                SetPlayerChatBubble(playerid, fmt_str, 0x32a44bFF, 10.0, 2000);
                //
                //SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, itemss + rand);
                //UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);

				new type = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT);

				SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, type + 50);
				UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);
                //
                //SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.02, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);
                SetPlayerMinerJobLoadCP(playerid);

                AddPlayerData(playerid, P_QUEST_EXP_3, +, 1);
				UpdatePlayerDatabaseInt(playerid, "quest_exp_3", GetPlayerData(playerid, P_QUEST_EXP_3));

				if(GetPlayerData(playerid, P_QUEST_EXP_3) == 20)
				{
				    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Высокие заводы'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
				    GivePlayerMoneyEx(playerid, 5000, "Выполнение квеста");

				    SetPlayerData(playerid, P_QUEST_3, 1);
				    UpdatePlayerDatabaseInt(playerid, "quest_3", 1);
				    
				    AddPlayerData(playerid, P_TOP_5, +, 1);
					UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
				}
            }
			case CP_ACTION_TYPE_LOADER_JOB_PUT:
			{
//				if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
//				{
//					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LOADER_UNLOAD)
//					{
				SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + 1);

				RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
				ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 0);
//
				SetPlayerLoaderJobLoadCP(playerid);

				new fmt_str[120];
				format(fmt_str, sizeof fmt_str, "[Информация]: "c_server"Ящик доставлен на склад! Всего перенесено ящиков: {FF9900}%d шт.", GetPlayerJobLoadItems(playerid));
				SendClientMessage(playerid, COR_SERVER, fmt_str);

				AddPlayerData(playerid, P_QUEST_EXP_1, +, 1);
				UpdatePlayerDatabaseInt(playerid, "quest_exp_1", GetPlayerData(playerid, P_QUEST_EXP_1));

				if(GetPlayerData(playerid, P_QUEST_EXP_1) == 10)
				{
				   SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Первые деньги'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
				    GivePlayerMoneyEx(playerid, 5000, "Выполнение квеста");

				    SetPlayerData(playerid, P_QUEST_1, 1);
				    UpdatePlayerDatabaseInt(playerid, "quest_1", 1);
				    
				    AddPlayerData(playerid, P_TOP_5, +, 1);
					UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
				}
			}
			case CP_ACTION_TYPE_GPS:
			{
				DisablePlayerGPS(playerid);
			    DisablePlayerCheckpoint(playerid);
			    Send(playerid,COR_SERVER,"[Навигатор]: Вы прибыли до места назначения.");
			}
			case CP_ACTION_TYPE_MINER_JOB_TAKE:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_LOAD)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{
							if(g_mineExtractionPending[playerid]) return 1;
							g_mineExtractionPending[playerid] = true;
							g_mineCarryTicket[playerid]++;
							DisablePlayerCheckpoint(playerid);
							ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);
							SetTimerEx("SetPlayerMinerJobTakeOre", 15_000, false, "iii", playerid, g_mineCarryTicket[playerid], g_BRAuthEpoch[playerid]);
						}
					}
				}
			}
			case CP_ACTION_TYPE_LUMBERJACK_PUT:
			{

				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_CHOP);
				ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.1, 1, 0, 1, 0, 800, 0);

				RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
				//SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 326, A_OBJECT_BONE_RIGHT_HAND, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

				SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + 1);

				new fmt_text[65];

				format(fmt_text, sizeof fmt_text, "Дрова доставлены на склад! Всего перенесено дров: {FF9900}%d шт", GetPlayerJobLoadItems(playerid));
				SendClientMessage(playerid, 0x66CC00FF, fmt_text);

				SetPlayerLumberJackChopCP(playerid);

				AddPlayerData(playerid, P_QUEST_EXP_4, +, 1);
				UpdatePlayerDatabaseInt(playerid, "quest_exp_4", GetPlayerData(playerid, P_QUEST_EXP_4));

				if(GetPlayerData(playerid, P_QUEST_EXP_4) == 20)
				{
				    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Высокие заводы'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
				    GivePlayerMoneyEx(playerid, 5000, "Выполнение квеста");

				    SetPlayerData(playerid, P_QUEST_4, 1);
				    UpdatePlayerDatabaseInt(playerid, "quest_4", 1);
				    
				    AddPlayerData(playerid, P_TOP_5, +, 1);
					UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
				}

			}
			case CP_ACTION_TYPE_LUMBERJACK_TAKE:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_LUMBERJACK)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LUMBERJACK_CHOP)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{
							DisablePlayerCheckpoint(playerid);

							ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);

							SetTimerEx("SetPlayerLumberJackTakeWood", (random(5) + 10) * 1000, false, "ii", playerid, g_BRAuthEpoch[playerid]);
						}
					}
				}
			}
		}
	}
	return 1;
}

