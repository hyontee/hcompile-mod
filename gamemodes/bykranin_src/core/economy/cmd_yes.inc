//>> Файл: bykranin_src/core/economy/cmd_yes.inc  (832 строк)
//>> Тема: экономика: банк, донат, промокоды, аукцион, обмен, торговля
//>> Внутри: /yes
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// ------------------------------------------
CMD:yes(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
	new offer_type = GetPlayerOfferInfo(playerid, O_INCOMING_TYPE);

	new value_1 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[0];
	new value_2 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[1];

	if(offer_id != INVALID_PLAYER_ID)
	{
		if(IsPlayerConnected(offer_id) && IsPlayerLogged(offer_id))
		{
			if(GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
			{
				ClearPlayerOffer(offer_id);
			}
					else offer_type = -1;

			new Float: x, Float: y, Float: z;
			new Float: dist;

			GetPlayerPos(offer_id, x, y, z);

			if(offer_type != OFFER_TYPE_GETHERE)
				dist = GetPlayerDistanceFromPoint(playerid, x, y, z);

			else dist = 5.0;

			if(dist <= 10.0)
			{
				new fmt_str[144];

				switch(offer_type)
				{
					case OFFER_TYPE_SELL_GARAGE:
					{
						GarageSys_TransferGarage(offer_id, playerid, value_1, value_2);
					}
					case OFFER_TYPE_SHOW_SKILL:
					{
						ShowPlayerSkills(offer_id, playerid);
						Action(offer_id, "показал свои навыки владения оружием", _, false);
					}

					case OFFER_TYPE_INVITE:
					{
						new team_id = GetPlayerTeamEx(offer_id);
						if((1 <= team_id < MAX_ORG) || !(1 <= GetPlayerTeamEx(playerid) < MAX_ORG))
						{
							InvitePlayer(playerid, team_id, 1, true);

							new fmt_msg[120];
							format(fmt_msg, sizeof fmt_msg, "{FFFFFF}Вы приняли предложение от{ffff00} %s {FFFFFF}вступить в организацию{ffff00}  \"%s\"", GetPlayerNameEx(playerid), GetPlayerTeamName(offer_id));
							if(IsTeamSubdivision(team_id))
								format(fmt_msg, sizeof fmt_msg, "%s и подразделение \"%s\"", fmt_msg, GetPlayerSubdivisionName(offer_id));

							SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
							SendClientMessage(playerid, 0x3399FFFF, "{FFFFFF}Используйте {FFFFFF}Воспользуйтесь {ffff00}/menu - Команды сервера,{FFFFFF} чтобы узнать о новых возможностях.");

							format(fmt_msg, sizeof fmt_msg, "%s принял Ваше предложение вступить в организацию", GetPlayerNameEx(playerid), value_1);
							SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);

							GameTextForPlayer(offer_id, "~b~~h~yes", 4000, 1);

							format(fmt_msg, sizeof fmt_msg, "Принял %s[acc:%d] в организацию %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetPlayerTeamName(offer_id));
							SendLog(offer_id, LOG_TYPE_FRACTION, fmt_msg);

							AddPlayerData(playerid, P_QUEST_EXP_8, +, 1);
							UpdatePlayerDatabaseInt(playerid, "quest_exp_8", GetPlayerData(playerid, P_QUEST_EXP_8));

							if(GetPlayerData(playerid, P_QUEST_EXP_8) == 1)
							{
							    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Вступить во фракцию'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
							    GivePlayerMoneyEx(playerid, 10000, "Выполнение квеста");

							    SetPlayerData(playerid, P_QUEST_8, 1);
							    UpdatePlayerDatabaseInt(playerid, "quest_8", 1);
							    
							    AddPlayerData(playerid, P_TOP_5, +, 1);
								UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
							}
						}
					else SendClientMessage(playerid, 0xCECECEFF, "При вступлении в организацию произошла ошибка");
					}
                    case OFFER_TYPE_FINVITE:
                    {
                        new fam_id = GetPlayerData(offer_id, P_FAMILY);

                        FInvitePlayer(playerid, fam_id, 1, true);

                        new fmt_msg[120];
                        format(fmt_msg, sizeof fmt_msg, "Поздравляем! Вы вступили в семью \"%s\"", GetFamilyData(fam_id, F_NAME));

                        SendClientMessage(playerid, 0x32a44bFF, fmt_msg);
                        SendClientMessage(playerid, 0x1E90FFFF, "Используйте {d8284c}/fmenu > помощь по семье{1E90FF}, чтобы узнать о новых возможностях");

                        format(fmt_msg, sizeof fmt_msg, "%s принял Ваше предложение вступить в семью", GetPlayerNameEx(playerid), value_1);
                        SendClientMessage(offer_id, 0x32a44bFF, fmt_msg);

                        format(fmt_msg, sizeof fmt_msg, "Принял %s[acc:%d] в семью %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetPlayerTeamName(offer_id));
                        SendLog(offer_id, LOG_TYPE_FRACTION, fmt_msg);

                        AddPlayerData(playerid, P_QUEST_EXP_7, +, 1);
						UpdatePlayerDatabaseInt(playerid, "quest_exp_7", GetPlayerData(playerid, P_QUEST_EXP_7));

						if(GetPlayerData(playerid, P_QUEST_EXP_7) == 1)
						{
						    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Вступить в семью'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
						    GivePlayerMoneyEx(playerid, 10000, "Выполнение квеста");

						    SetPlayerData(playerid, P_QUEST_7, 1);
						    UpdatePlayerDatabaseInt(playerid, "quest_7", 1);
						    
						    AddPlayerData(playerid, P_TOP_5, +, 1);
							UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
						}

                    }
					case OFFER_TYPE_HANDSHAKE:
					{
						if(!(IsPlayerInAnyVehicle(playerid) && IsPlayerInAnyVehicle(offer_id)))
						{
							if(0.5 <= dist <= 1.5)
							{
								new Float: to_x, Float: to_y;
								new Float: angle;

								GetPlayerPos(playerid, to_x, to_y, z);
								angle = GetAngleToPoint(x, y, to_x, to_y);

								SetPlayerFacingAngle(playerid, angle);
								SetPlayerFacingAngle(offer_id, angle + 180.0);

								format(fmt_str, sizeof fmt_str, "пожал(а) руку %s", GetPlayerNameEx(offer_id));
								Action(playerid, fmt_str, _, false);

								ApplyAnimationEx(playerid, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, 0, 1);
								ApplyAnimationEx(offer_id, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, 0, 1);
							}
					else
							{
								valstr(fmt_str, offer_id);
								callcmd::hi(playerid, fmt_str);
							}
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы либо игрок не должны находиться в транспорте");
					}
					case OFFER_TYPE_SELL_FUEL_ST:
					{
						if(GetPlayerFuelStation(offer_id) == value_1 && GetPlayerFuelStation(playerid) == -1)
						{
							if(GetPlayerMoneyEx(playerid) >= value_2)
							{
								new Float: f_pos_x = GetFuelStationData(value_1, FS_POS_X);
								new Float: f_pos_y = GetFuelStationData(value_1, FS_POS_Y);
								new Float: f_pos_z = GetFuelStationData(value_1, FS_POS_Z);

								if(IsPlayerInRangeOfPoint(playerid, 10.0, f_pos_x, f_pos_y, f_pos_z) && IsPlayerInRangeOfPoint(offer_id, 10.0, f_pos_x, f_pos_y, f_pos_z))
								{
									format(fmt_str, sizeof fmt_str, "Вы продали свою АЗС игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "%s продал Вам заправочную станцию \"%s\" за %d руб", GetPlayerNameEx(offer_id), GetFuelStationData(value_1, FS_NAME), value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									SellFuelStation(offer_id, playerid, value_2);
									SendClientMessage(playerid, 0xFFCD00FF, "Проверьте количество оплаченных дней аренды, при необходимости оплатить ее можно в банке");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы и продавец должны находиться рядом с заправкой которую хотите купить");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для заключения сделки");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "При заключении сделки произошла ошибка");
					}
					case OFFER_TYPE_UNUSED_1:
					{
						new vehicleid = GetPlayerVehicleID(playerid);
						new offer_vehicleid = GetPlayerVehicleID(offer_id);

						if(IsPlayerDriver(playerid))
						{
							if(GetPlayerJob(offer_id) == JOB_UNUSED_3 && IsPlayerInJob(offer_id) && IsPlayerInVehicle(offer_id, GetPlayerJobCar(offer_id)))
							{
								if((GetVehicleData(vehicleid, V_FUEL) + float(value_1)) <= 150.0)
								{
									if(GetPlayerMoneyEx(playerid) >= value_2)
									{
										if(GetPlayerJobLoadItems(offer_id) >= value_1)
										{
											GivePlayerMoneyEx(playerid, -value_2, "Заправка транспорта от механика", true, true);

											SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + float(value_1));
											SetPlayerJobLoadItems(offer_id, GetPlayerJobLoadItems(offer_id) - value_1);

											AddPlayerData(offer_id, P_MECHANIC_FILL_PAY, +, value_2);

											format(fmt_str, sizeof fmt_str, "Автомеханик %s заправил Ваш транспорт на %d л", GetPlayerNameEx(offer_id), value_1);
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);

											format(fmt_str, sizeof fmt_str, "Вы заправили транспорт %s на %d л", GetPlayerNameEx(playerid), value_1);
											SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

											format(fmt_str, sizeof fmt_str, "~g~+%d rub", value_2);
											GameTextForPlayer(offer_id, fmt_str, 4000, 1);

											format(fmt_str, sizeof fmt_str, "%s{FFFFFF}Автомеханик\n{999999}Топливо: %d л", GetPlayerData(offer_id, P_JOB_SERVICE_NAME), GetPlayerJobLoadItems(offer_id));
											UpdateVehicleLabel(offer_vehicleid, 0xCC9900FF, fmt_str);
										}
					else SendClientMessage(playerid, 0xCECECEFF, "При заправке произошла ошибка");
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы заплатить автомеханику");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "В бензобак этого транспорта столько не поместится");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Автомеханик должен находиться в рабочем транспорте");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте за рулем");
					}
					case OFFER_TYPE_UNUSED_2:
					{
						new vehicleid = GetPlayerVehicleID(playerid);

						if(IsPlayerDriver(playerid))
						{
							if(GetPlayerJob(offer_id) == JOB_UNUSED_3 && IsPlayerInJob(offer_id) && IsPlayerInVehicle(offer_id, GetPlayerJobCar(offer_id)))
							{
								if(GetPlayerMoneyEx(playerid) >= value_1)
								{
									GivePlayerMoneyEx(playerid, -value_1, "Починка транспорта от механика", true, true);
									AddPlayerData(offer_id, P_MECHANIC_REPAIR_PAY, +, value_1);

									RepairVehicle(vehicleid);
									if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 1000.0);

									SetPlayerChatBubble(playerid, "Repair", 0x3399FFFF, 10.0, 2000);
									SetPlayerChatBubble(offer_id, "Repair", 0x3399FFFF, 10.0, 2000);

									format(fmt_str, sizeof fmt_str, "Автомеханик %s починил Ваш транспорт за %d руб", GetPlayerNameEx(offer_id), value_1);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "Вы починили транспорт %s за %d руб", GetPlayerNameEx(playerid), value_1);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "~g~+%d rub", value_1);
									GameTextForPlayer(offer_id, fmt_str, 4000, 1);
								}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы заплатить автомеханику");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Автомеханик должен находиться в рабочем транспорте");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте за рулем");
					}
					case OFFER_TYPE_SELL_BUSINESS:
					{
						if(IsBusinessOnAuction(value_1))
							return SendClientMessage(playerid, 0xCECECEFF, "Этот бизнес находится на аукционе.");
						if(GetPlayerBusiness(offer_id) == value_1 && GetPlayerBusiness(playerid) == -1)
						{
							if(GetPlayerMoneyEx(playerid) >= value_2)
							{
								new Float: b_pos_x = GetBusinessData(value_1, B_POS_X);
								new Float: b_pos_y = GetBusinessData(value_1, B_POS_Y);
								new Float: b_pos_z = GetBusinessData(value_1, B_POS_Z);

								if(IsPlayerInRangeOfPoint(playerid, 7.0, b_pos_x, b_pos_y, b_pos_z) && IsPlayerInRangeOfPoint(offer_id, 7.0, b_pos_x, b_pos_y, b_pos_z))
								{
									format(fmt_str, sizeof fmt_str, "Вы продали свой бизнес игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "%s продал Вам бизнес \"%s\" за %d руб", GetPlayerNameEx(offer_id), GetBusinessData(value_1, B_NAME), value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									SellBusiness(offer_id, playerid, value_2);
									SendClientMessage(playerid, 0xFFCD00FF, "Проверьте количество оплаченных дней аренды, при необходимости оплатить ее можно в банке");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы и продавец должны находиться рядом с бизнесом который хотите купить");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для заключения сделки");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "При заключении сделки произошла ошибка");
					}
					case OFFER_TYPE_BUSINESS_MANAGER:
					{
						if(GetPlayerBusiness(offer_id) == value_1 || GetPlayerManagedCasino(offer_id) == value_1)
						{
							if(GetBusinessData(value_1, B_TYPE) == BUSINESS_TYPE_CASINO)
							{
								SetCasinoEmployment(playerid, value_1, value_2 == 2 ? 2 : 1);
								format(fmt_str, sizeof fmt_str, "Вы приняты в казино на должность %s", value_2 == 2 ? ("менеджера") : ("крупье"));
								SendClientMessage(playerid, 0x66CC00FF, fmt_str);
								format(fmt_str, sizeof fmt_str, "%s принял предложение о работе", GetPlayerNameEx(playerid));
								SendClientMessage(offer_id, 0x66CC00FF, fmt_str);
								return 1;
							}
							SetPVarInt(playerid, "biz_worker", value_1 + 1);

							format(fmt_str, sizeof fmt_str, "Вы приняли предложение от %s", GetPlayerNameEx(offer_id));
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);

							format(fmt_str, sizeof fmt_str, "%s принял Ваше предложение", GetPlayerNameEx(playerid));
							SendClientMessage(offer_id, 0x66CC00FF, fmt_str);
						}
					}
					case OFFER_TYPE_SELL_HOME:
					{
						if(GetPlayerHouse(offer_id, HOUSE_TYPE_HOME) == value_1 && GetPlayerHouse(playerid) == -1)
						{
							if(GetPlayerMoneyEx(playerid) >= value_2)
							{
								if(IsPlayerInRangeOfHouse(playerid, value_1, 10.0) && IsPlayerInRangeOfHouse(offer_id, value_1, 10.0))
								{
									format(fmt_str, sizeof fmt_str, "Вы продали свой дом игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "%s продал Вам cвой дом за %d руб", GetPlayerNameEx(offer_id), value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									SellHouse(offer_id, playerid, value_2);
									SendClientMessage(playerid, 0xFFCD00FF, "Настоятельно рекомендуем проверить квартплату, при необходимости заплатить за дом в банке");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы и продавец должны находиться рядом с домом который хотите купить");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для заключения сделки");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "При заключении сделки произошла ошибка");
					}
					case OFFER_TYPE_HOME_RENT_ROOM:
					{
						if(GetPlayerHouse(offer_id, HOUSE_TYPE_HOME) == value_1 && GetPlayerHouse(playerid) == -1)
						{
							if(IsPlayerInRangeOfHouse(playerid, value_1, 10.0) && IsPlayerInRangeOfHouse(offer_id, value_1, 10.0))
							{
								new free_room = GetHouseFreeRoom(value_1);
								if(free_room != -1)
								{
									AddHouseRenter(value_1, free_room, playerid);

									format(fmt_str, sizeof fmt_str, "Вы поселили %s в своем доме", GetPlayerNameEx(playerid));
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "%s поселил Вас в своем доме", GetPlayerNameEx(offer_id));
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									GameTextForPlayer(offer_id, "~b~~h~Welcome", 4000, 1);
								}
					else SendClientMessage(playerid, 0x999999FF, "Все комнаты этого дома уже заняты");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы и арендодатель должны находиться рядом с домом в котором хотите снять комнату");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка");
					}
					case OFFER_TYPE_SELL_OWNABLE_CAR:
					{
						if(GetPlayerOwnableCar(offer_id) == value_2 && GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
						{
							new  Float: car_x, Float: car_y, Float: car_z;
							GetVehiclePos(value_2, car_x, car_y, car_z);

							if(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(offer_id, 15.0, car_x, car_y, car_z))
							{
								if(GetPlayerMoneyEx(playerid) >= value_1)
								{
									new index = GetVehicleData(value_2, V_ACTION_ID);

									format(fmt_str, sizeof fmt_str, "UPDATE accounts a, ownable_cars oc SET a.money=%d, oc.owner_id=%d WHERE a.id=%d AND oc.id=%d", GetPlayerMoneyEx(playerid)-value_1, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetOwnableCarData(index, OC_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										GivePlayerMoneyEx(playerid, -value_1, "Продажа авто с рук", false, true);
										GivePlayerMoneyEx(offer_id, value_1, "Продажа авто с рук", true, true);

										SetOwnableCarData(index, OC_OWNER_ID, GetPlayerAccountID(playerid));
										SetOwnableCarData(index, OC_LAST_OWNER_GAME_ID, INVALID_PLAYER_ID);
										SetOwnableCarData(index, OC_LAST_PRICE, 0);

										player_sell_ownable_car[offer_id] = false;
										ownable_car_sell_status[value_2] = false;
										DestroyVehicleLabel(value_2);

										if(GetPlayerOwnableCar(offer_id) == value_2)
											UnloadPlayerOwnableCar(offer_id, true);
										else
											SetPlayerData(offer_id, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

										SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

										format(fmt_str, sizeof fmt_str, "{FFFFFF}Игрок{ffff00} %s {FFFFFF}продал Вам свой транспорт за{ffff00} %d руб", GetPlayerNameEx(offer_id), value_1);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
										SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Транспорт добавлен в Ваш автопарк");
										SendClientMessage(playerid, 0xFFFFFFFF, "{FFFFFF}Загрузите транспорт через {ffff00}/car");

										format(fmt_str, sizeof fmt_str, "Вы продали свой транспорт игроку %s за %d руб", GetPlayerNameEx(playerid), value_1);
										SendClientMessage(offer_id, 0x66CC00FF, fmt_str);
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Произошла ошибка в базе данных");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы и продавец должны находиться рядом с транспортом который хотите купить");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка");
					}

					case OFFER_TYPE_MEDHELP:
					{
						if(GetPlayerTeamEx(offer_id) == TEAM_HOSPITAL)
						{
							if(Hospital_IsPlayerInsideCB(playerid) || IsPlayerInRangeOfPoint(playerid, 70.0, 1131.1603, -8.5709, 1011.1254))
							{
								if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
								{
									if(GetPlayerMoneyEx(playerid) >= value_1)
									{
										GivePlayerMoneyEx(playerid, -value_1, "Курс лечения (купил)", true, true);
										GivePlayerMoneyEx(offer_id, value_1, "Курс лечения (провел)", true, true);

										SetPlayerHealthEx(playerid, 100.0);

										new fmt_msg[128];
										format(fmt_msg, sizeof fmt_msg, "Медицинский работник %s провел курс платного лечения", GetPlayerNameEx(offer_id));
										SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

										format(fmt_msg, sizeof fmt_msg, "Вы провели курс платного лечения у пациента %s", GetPlayerNameEx(playerid));
										SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);

										format(fmt_msg, sizeof fmt_msg, "[MED] Медицинский работник %s[%d] провел курс платного лечения у %s[%d] за %d руб.", GetPlayerNameEx(offer_id), offer_id, GetPlayerNameEx(playerid), playerid, value_1);
										SendMessageToTeam(TEAM_HOSPITAL, fmt_msg, 0x99CC99FF, offer_id);

										ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
										SetPlayerData(playerid, P_HOSPITAL, false);
										
										AddPlayerData(offer_id, P_PROGRESS_EXP_1, +, 1);
										UpdatePlayerDatabaseInt(offer_id, "ProgressExp1", GetPlayerData(offer_id, P_PROGRESS_EXP_1));

										if(GetPlayerData(offer_id, P_PROGRESS_EXP_1) == 1000)
										{
										    SendClientMessage(offer_id, COR_QUEST, "[Достижения]: "c_b"Вы успешно выполнили достижение "c_i"'Больница'. "c_b"Награда: "c_s"100 DONATE-RUB");
										    GivePlayerDonateRub(offer_id, 100, "Выполнение достижения / фракция");

										    SetPlayerData(offer_id, P_PROGRESS_1, 1);
										    UpdatePlayerDatabaseInt(offer_id, "Progress1", 1);
										    
										    AddPlayerData(offer_id, P_TOP_4, +, 1);
											UpdatePlayerDatabaseInt(offer_id, "TOP_Progress", GetPlayerData(offer_id, P_TOP_4));
										}
										
										AddPlayerData(offer_id, P_F_QUEST_EXP_5, +, 1);
										UpdatePlayerDatabaseInt(offer_id, "FracQuestExp5", GetPlayerData(offer_id, P_F_QUEST_EXP_5));

										if(GetPlayerData(offer_id, P_F_QUEST_EXP_5) == 100)
										{
										    SendClientMessage(offer_id, COR_QUEST, "[Квесты]: "c_b"Вы успешно выполнили квест "c_i"'Люди должный жить'. "c_b"Награда: "c_s"1 CASE(/opencase)");

									        AddPlayerData(offer_id, P_DONATE_CASE, +, 1);
											
										    SetPlayerData(offer_id, P_F_QUEST_5, 1);
										    UpdatePlayerDatabaseInt(offer_id, "FracQuest5", 1);
										    
										    AddPlayerData(offer_id, P_TOP_5, +, 1);
											UpdatePlayerDatabaseInt(offer_id, "TOP_Quest", GetPlayerData(offer_id, P_TOP_5));
										}
									
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег, чтобы оплатить лечение");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться на стационарном лечении");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в больнице");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка");
					}
					case OFFER_TYPE_HEAL:
					{
						new vehicleid = GetPlayerVehicleID(offer_id);

						if(GetPlayerTeamEx(offer_id) == TEAM_HOSPITAL)
						{
							if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_MED_CAR && GetPlayerVehicleID(playerid) == vehicleid)
							{
								if(GetPlayerMoneyEx(playerid) >= value_1)
								{
									GivePlayerMoneyEx(playerid, -value_1, "Курс лечения (купил) [veh]", true, true);
									GivePlayerMoneyEx(offer_id, value_1, "Курс лечения (провел) [veh]", true, true);

									SetPlayerHealthEx(playerid, 100.0);

									new fmt_msg[50];
									format(fmt_msg, sizeof fmt_msg, "Вы вылечились у медицинского работника %s", GetPlayerNameEx(offer_id));
									SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

									format(fmt_msg, sizeof fmt_msg, "Вы вылечили пациента %s", GetPlayerNameEx(playerid));
									SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);
									
									AddPlayerData(offer_id, P_PROGRESS_EXP_1, +, 1);
									UpdatePlayerDatabaseInt(offer_id, "ProgressExp1", GetPlayerData(offer_id, P_PROGRESS_EXP_1));

									if(GetPlayerData(offer_id, P_PROGRESS_EXP_1) == 1000)
									{
									    SendClientMessage(offer_id, COR_QUEST, "[Достижения]: "c_b"Вы успешно выполнили достижение "c_i"'Больница'. "c_b"Награда: "c_s"100 DONATE-RUB");
									    GivePlayerDonateRub(offer_id, 100, "Выполнение достижения / фракция");

									    SetPlayerData(offer_id, P_PROGRESS_1, 1);
									    UpdatePlayerDatabaseInt(offer_id, "Progress1", 1);
									    
									    AddPlayerData(offer_id, P_TOP_4, +, 1);
										UpdatePlayerDatabaseInt(offer_id, "TOP_Progress", GetPlayerData(offer_id, P_TOP_4));
									}
									
									AddPlayerData(offer_id, P_F_QUEST_EXP_5, +, 1);
									UpdatePlayerDatabaseInt(offer_id, "FracQuestExp5", GetPlayerData(offer_id, P_F_QUEST_EXP_5));

									if(GetPlayerData(offer_id, P_F_QUEST_EXP_5) == 100)
									{
									    SendClientMessage(offer_id, COR_QUEST, "[Квесты]: "c_b"Вы успешно выполнили квест "c_i"'Люди должный жить'. "c_b"Награда: "c_s"1 CASE(/opencase)");

								        AddPlayerData(offer_id, P_DONATE_CASE, +, 1);
										
									    SetPlayerData(offer_id, P_F_QUEST_5, 1);
									    UpdatePlayerDatabaseInt(offer_id, "FracQuest5", 1);
									    
									    AddPlayerData(offer_id, P_TOP_5, +, 1);
										UpdatePlayerDatabaseInt(offer_id, "TOP_Quest", GetPlayerData(offer_id, P_TOP_5));
									}
								}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег, чтобы оплатить лечение");
							}
					else SendClientMessage(playerid, 0x999999FF, "Вы или медицинский работник находитесь не в машине скорой помощи");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка");
					}
					case OFFER_TYPE_CHANGE_SEX:
					{
						if(GetPlayerTeamEx(offer_id) == TEAM_HOSPITAL)
						{
							if(Hospital_IsPlayerInsideCB(playerid) || IsPlayerInRangeOfPoint(playerid, 70.0, 1131.1603, -8.5709, 1011.1254))
							{
								if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
								{
									if(GetPlayerMoneyEx(playerid) >= value_1)
									{
										GivePlayerMoneyEx(playerid, -value_1, "Смена пола (купил)", true, true);
										GivePlayerMoneyEx(offer_id, value_1, "Смена пола (провел)", true, true);

										SetPlayerSexEx(playerid, GetPlayerSex(playerid) ^ 1);

										new fmt_msg[70];
										format(fmt_msg, sizeof fmt_msg, "Медработник %s сделал Вам операцию по смене пола", GetPlayerNameEx(offer_id));
										SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

										format(fmt_msg, sizeof fmt_msg, "Операция у пациента %s была проведена успешно", GetPlayerNameEx(playerid));
										SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы оплатить операцию");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться на стационарном лечении");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в больнице");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка");
					}
					case OFFER_TYPE_CASINO_DICE:
					{
						new biz_id = GetPlayerInBiz(offer_id);

						if(biz_id != -1)
						{
							if(GetBusinessData(biz_id, B_TYPE) == BUSINESS_TYPE_CASINO)
							{
								new player_dice = random(6) + 1,
									offer_dice = random(6) + 1,
									winner,
									fmt_text[90];

								if(player_dice > offer_dice)
									winner = playerid;
								else if(player_dice < offer_dice)
									winner = offer_id;
								else
									winner = -1;

								format(fmt_text, sizeof fmt_text, "и %s бросили кости. Результат: {FFCD00}%d:%d",
								GetPlayerNameEx(offer_id), player_dice, offer_dice);

								Action(playerid, fmt_text, _, false);

								if(winner == -1)
								{
									SetPlayerChatBubble(playerid, "Ничья!", 0xFFCD00FF, 20.0, 2000);
									SetPlayerChatBubble(offer_id, "Ничья!", 0xFFCD00FF, 20.0, 2000);

									SendClientMessage(playerid, 0xFFCD00FF, "Выпало равное количество, Вы сыграли вничью");
									SendClientMessage(offer_id, 0xFFCD00FF, "Выпало равное количество, Вы сыграли вничью");
								}
					else
								{
									new loser = playerid == winner ? offer_id : playerid,
										winner_dice = playerid == winner ? player_dice : offer_dice,
										loser_dice = playerid == winner ? offer_dice : player_dice;

									new percent = value_1 / 100,
										cash = value_1,
										take_prods = random(5) + 6;

									new query[255];

									if(GetBusinessData(biz_id, B_PRODS) >= take_prods)
									{
										cash -= percent;

										SetBusinessData(biz_id, B_PRODS, 10_000);
										AddBusinessData(biz_id, B_BALANCE, +, percent);

										format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_BALANCE), GetBusinessData(biz_id, B_SQL_ID));
										mysql_query(mysql, query, false);

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(biz_id, B_SQL_ID), GetPlayerAccountID(winner), GetPlayerIpEx(winner), gettime(), percent, IsBusinessOwned(biz_id));
										mysql_query(mysql, query, false);
									}

									SendClientMessage(winner, 0x66CC33FF, "Поздравляем, Вы выиграли!");
									GivePlayerMoneyEx(winner, cash, "Игра в кости (выиграл)", true, true);

									SendClientMessage(loser, 0xFF5533FF, "К сожалению, Вы проиграли");
									GivePlayerMoneyEx(loser, -value_1, "Игра в кости (проиграл)", true, true);

									format(fmt_text, sizeof fmt_text, "Выпало: %d", winner_dice);
									SetPlayerChatBubble(winner, fmt_text, 0x66CC33FF, 20.0, 2000);

									format(fmt_text, sizeof fmt_text, "Выпало: %d", loser_dice);
									SetPlayerChatBubble(loser, fmt_text, 0xFF5533FF, 20.0, 2000);
								}
							}
					else SendClientMessage(playerid, 0x999999FF, "Произошла ошибка. Вы не в казино");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка");
					}
					
					case OFFER_TYPE_GIVE_CAR_KEY:
					{
						new vehicleid = GetPlayerOwnableCar(offer_id);

						if(vehicleid != INVALID_VEHICLE_ID)
						{
							new fmt_text[80];

							format(fmt_text, sizeof fmt_text, "%s выдал Вам ключи от своего транспорта", GetPlayerNameEx(offer_id));
							SendClientMessage(playerid, 0x66CC00FF, fmt_text);

							SendClientMessage(playerid, -1, "Вам были переданы ключи от транспорта. Используйте {BBBB00}/lock 4");
							SendClientMessage(playerid, 0xCECECEFF, "После выхода из игры или выгрузки ТС с сервера они пропадут");

							format(fmt_text, sizeof fmt_text, "Вы дали игроку %s ключи от своего транспорта", GetPlayerNameEx(playerid));
							SendClientMessage(offer_id, 0x66CC00FF, fmt_text);

							SetPlayerData(playerid, P_ALLOWED_CAR, vehicleid);
						}
					else
						{
							if(GetPlayerOwnableCars(offer_id) == 0)
								SendClientMessage(playerid, 0x999999FF, "У игрока нет личного транспорта");
							else
								SendClientMessage(playerid, 0x999999FF, "Личный транспорт игрока не загружен на сервер");
						}
					}
					case OFFER_TYPE_GIVE_MIC:
					{
						SetPVarInt(playerid, "radio_mic", 1);

						new fmt_text[128];

						format(fmt_text, sizeof fmt_text, "%s дал Вам доступ к радио-эфиру", GetPlayerNameEx(offer_id));
						SendClientMessage(playerid, 0x66CC33FF, fmt_text);

						SendClientMessage(playerid, -1, "Вам был дан микрофон. Вы имеете доступ к радио-эфиру. Используйте: {BBBB00}/u");

						format(fmt_text, sizeof fmt_text, "Вы дали игроку %s доступ к радио-эфиру", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, 0x66CC33FF, fmt_text);

						format(fmt_text, sizeof fmt_text, "[СМИ] %s %s[%d] подключил %s[%d] к радио-эфиру",
						GetPlayerJobAndRankName(offer_id), GetPlayerNameEx(offer_id), offer_id, GetPlayerNameEx(playerid), playerid);

						SendMessageToTeam(GetPlayerTeamEx(offer_id), fmt_text, 0x99CC99FF, offer_id);
					}
					case OFFER_TYPE_GIVE_LIC:
					{
						new lic_names[3][34] = {"вождение базового уровня", "вождение профессионального уровня", "оружие"};

						new fmt_text[85];

						switch(value_1)
						{
							case 1..2:
							{
								AddPlayerData(playerid, P_DRIVING_LIC, +, 1);
								UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
							}
							case 3:
							{
								SetPlayerData(playerid, P_WEAPON_LIC, 1);
								UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);
							}
						}

						format(fmt_text, sizeof fmt_text, "%s продал Вам лицензию на %s за %d рублей",
						GetPlayerNameEx(offer_id), lic_names[value_1 - 1], value_2);

						SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

						format(fmt_text, sizeof fmt_text, "Вы продали %s лицензию на %s за %d рублей",
						GetPlayerNameEx(playerid), lic_names[value_1 - 1], value_2);

						SendClientMessage(offer_id, 0x3399FFFF, fmt_text);
						SendClientMessage(offer_id, 0x3399FFFF, "К Вашей зарплате добавлено 10% от стоимости лицензии");

						new wage = value_2 / 10;

						format(fmt_text, sizeof fmt_text, "Покупка лицензии на %s у %s", lic_names[value_1 - 1], GetPlayerNameEx(offer_id));

						GivePlayerMoneyEx(playerid, -value_2, fmt_text, true, true);

						AddPlayerData(offer_id, P_WAGE, +, wage);
						UpdatePlayerDatabaseInt(offer_id, "wage", GetPlayerData(offer_id, P_WAGE));

						format(fmt_text, sizeof fmt_text, "~b~~h~+%d rub", wage);
						GameTextForPlayer(offer_id, fmt_text, 4000, 1);
					}
					case OFFER_TYPE_JAIL_FREE:
					{
						new fmt_text[80];

						format(fmt_text, sizeof fmt_text, "%s помог пересмотреть Ваше дело. Вы выпущены на свободу", GetPlayerNameEx(offer_id));
						SendClientMessage(playerid, 0x66CC33FF, fmt_text);

						format(fmt_text, sizeof fmt_text, "Вы пересмотрели дело %s. Игрок выпущен на свободу", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, 0x3399FFFF, fmt_text);

						format(fmt_text, sizeof fmt_text, "Стоимость услуги: %d руб. 10% этой суммы добавлено к Вашей зарплате", value_1);
						SendClientMessage(offer_id, 0x3399FFFF, fmt_text);

						GivePlayerMoneyEx(playerid, -value_1, "Оплата адвоката", true, true);

						UnjailPlayer(playerid);

						new wage = value_1 / 10;

						AddPlayerData(offer_id, P_WAGE, +, wage);
						UpdatePlayerDatabaseInt(offer_id, "wage", GetPlayerData(offer_id, P_WAGE));

						format(fmt_text, sizeof fmt_text, "~b~~h~+%d rub", wage);
						GameTextForPlayer(offer_id, fmt_text, 4000, 1);
						
						AddPlayerData(offer_id, P_PROGRESS_EXP_6, +, 1);
						UpdatePlayerDatabaseInt(offer_id, "ProgressExp6", GetPlayerData(offer_id, P_PROGRESS_EXP_6));

						if(GetPlayerData(offer_id, P_PROGRESS_EXP_6) == 500)
						{
						    SendClientMessage(offer_id, COR_QUEST, "[Достижения]: "c_b"Вы успешно выполнили достижение "c_i"'Мэрия'. "c_b"Награда: "c_s"100 DONATE-RUB");
						    GivePlayerDonateRub(offer_id, 100, "Выполнение достижения / фракция");

						    SetPlayerData(offer_id, P_PROGRESS_6, 1);
						    UpdatePlayerDatabaseInt(offer_id, "Progress6", 1);
						    
						    AddPlayerData(offer_id, P_TOP_4, +, 1);
							UpdatePlayerDatabaseInt(offer_id, "TOP_Progress", GetPlayerData(offer_id, P_TOP_4));
						}
						
						AddPlayerData(offer_id, P_F_QUEST_EXP_1, +, 1);
						UpdatePlayerDatabaseInt(offer_id, "FracQuestExp1", GetPlayerData(offer_id, P_F_QUEST_EXP_1));

						if(GetPlayerData(offer_id, P_F_QUEST_EXP_1) == 40)
						{
						    SendClientMessage(offer_id, COR_QUEST, "[Квесты]: "c_b"Вы успешно выполнили квест "c_i"'Невиновные люди должный быть на свободе'. "c_b"Награда: "c_s"1 CASE(/opencase)");
						    
                            AddPlayerData(offer_id, P_DONATE_CASE, +, 1);
							
						    SetPlayerData(offer_id, P_F_QUEST_1, 1);
						    UpdatePlayerDatabaseInt(offer_id, "FracQuest1", 1);
						    
						    AddPlayerData(offer_id, P_TOP_5, +, 1);
							UpdatePlayerDatabaseInt(offer_id, "TOP_Quest", GetPlayerData(offer_id, P_TOP_5));
						}
						
					}
					case OFFER_TYPE_ACCESSORY:
					{
						new price = GetPVarInt(offer_id, "owner_accept_price"),
						acs = GetPVarInt(offer_id, "acs_id"), sql = GetPVarInt(offer_id, "owner_accept_acs_sql"), string[124];

						if(price <= GetPlayerMoneyEx(playerid))
						{

							mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET player = %d WHERE id = %d", GetPlayerAccountID(playerid), sql);
							mysql_query(mysql, string, false);

							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -price);
								GivePlayerMoneyEx(offer_id, price);

								format(fmt_str, sizeof fmt_str, "Вы продали/передали %s аксессуар %s за %d руб.", GetPlayerNameEx(playerid), accessory[acs][NAME_ACCESSORY], price);
								SendClientMessage(offer_id, 0x3399FFFF, fmt_str);
							
								format(fmt_str, sizeof fmt_str, "%s продал Вам %s за %d руб.", GetPlayerNameEx(offer_id), accessory[acs][NAME_ACCESSORY], price);
								SendClientMessage(playerid, 0x3399FFFF, fmt_str);
							}
						}
					else
						{
							SendClientMessage(playerid, -1, ""USC" У Вас недостаточно средств");
							SendClientMessage(offer_id, -1, ""USC" У Игрока недостаточно средств");
						}
					}
					default:
						SendClientMessage(playerid, 0x999999FF, "В данный момент Вам ничего не предлагают");
				}
			}
					else SendClientMessage(playerid, 0x999999FF, "Игрок слишком далеко");
		}
					else SendClientMessage(playerid, 0x999999FF, "Игрок вышел из игры");

		ClearPlayerOffer(playerid);
	}
					else SendClientMessage(playerid, 0x999999FF, "В данный момент Вам ничего не предлагают");

	return 1;
}

