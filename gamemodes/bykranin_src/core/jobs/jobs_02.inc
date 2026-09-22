//>> Файл: bykranin_src/core/jobs/jobs_02.inc  (795 строк)
//>> Тема: работы и заработок
//>> Внутри: ShowPlayerLoginDialog, ClearPlayerAnim, ClearPlayerChatAnim, SetPlayerLoaderJobLoad, Mine_ClearCarry, SetPlayerMinerJobTakeOre, SetPlayerLumberJackTakeWood
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: ShowPlayerLoginDialog(playerid, step, wrong_pass)
{
	if(GetPlayerData(playerid, P_ACCOUNT_STATE) != ACCOUNT_STATE_LOGIN) return 0;
	if(IsPlayerLogged(playerid)) return 0;
	if(step >= LOGIN_STATE_PHONE && !g_BRAuthVerified[playerid]) return 0;

	/*
	new request_type = REQUEST_TYPE_OFF;
	if(strcmp(GetPlayerIpEx(playerid), GetPlayerData(playerid, P_LAST_IP)) != 0)
	{
		request_type = REQUEST_TYPE_IP;
	}
					else
	{
		new subnet_last_ip[16], subnet_cur_ip[16];

		GetSubnet(subnet_cur_ip, GetPlayerIpEx(playerid));
		GetSubnet(subnet_last_ip, GetPlayerData(playerid, P_LAST_IP));

		if(strcmp(subnet_cur_ip, subnet_last_ip) != 0)
		{
			request_type = REQUEST_TYPE_SUBNET;
		}
	}
	*/

	new fmt_str[1600];
	switch(step)
	{
		        case LOGIN_STATE_CHECK_BAN:
        {
            new Cache: result;
            mysql_format(mysql, fmt_str, sizeof fmt_str, "SELECT admin_name, reason, ban_time, unban_time FROM listban WHERE acc_id=%d LIMIT 1", GetPlayerAccountID(playerid));
            result = mysql_query(mysql, fmt_str, true);

            if(cache_num_rows(result))
            {
                new unban_time = cache_get_field_content_int(0, "unban_time");

                if(unban_time <= 0 || unban_time > gettime())
                {
                    new ban_time = cache_get_field_content_int(0, "ban_time");
                    new admin_name[24] = "";
                    new reason[128] = "";
                    new ban_date[32];
                    new unban_date[32];
                    new year, month, day, hour, minute, second;

                    cache_get_field_content(0, "admin_name", admin_name, mysql, sizeof(admin_name));
                    cache_get_field_content(0, "reason", reason, mysql, sizeof(reason));

                    if(!strlen(reason)) format(reason, sizeof(reason), "Не указана");
                    if(!strlen(admin_name)) format(admin_name, sizeof(admin_name), "Неизвестно");

                    if(ban_time > 0)
                    {
                        timestamp_to_date(ban_time + 10800, year, month, day, hour, minute, second);
                        format(ban_date, sizeof(ban_date), "%02d.%02d.%04d-%02d:%02d:%02d", day, month, year, hour, minute, second);
                    }
					else format(ban_date, sizeof(ban_date), "Неизвестно");

                    if(unban_time > 0)
                    {
                        timestamp_to_date(unban_time + 10800, year, month, day, hour, minute, second);
                        format(unban_date, sizeof(unban_date), "%02d.%02d.%04d-%02d:%02d:%02d", day, month, year, hour, minute, second);
                    }
					else format(unban_date, sizeof(unban_date), "никогда");

                    format(fmt_str, sizeof fmt_str,
                        "{FFFFFF}Ваш игровой аккаунт был заблокирован администрацией за нарушение\n"\
                        "правил сервера. Вы не можете играть на своем аккаунте во время\n"\
                        "действия блокировки.\n\n"\
                        "{FFFF00}| {FFFFFF}Ваш никнейм: {FFFF00}%s\n"\
                        "{FFFF00}| {FFFFFF}Никнейм администратора: {FFFF00}%s\n"\
                        "{FFFF00}| {FFFFFF}Дата выданной блокировки: {FFFF00}%s\n"\
                        "{FFFF00}| {FFFFFF}Дата разблокировки аккаунта: {FFFF00}%s\n"\
                        "{FFFF00}| {FFFFFF}Причина блокировки: {FFFF00}%s\n\n"\
                        "{FFFFFF}Вы не согласны с решением администратора и считаете, что наказание\n"\
                        "было выдано несправедливо или ошибочно? В таком случае,\n"\
                        "необходимо обратиться в специальный раздел с жалобой на\n"\
                        "официальную тех.поддержку проекта: {FFFF00}@brbonussupport_bot{FFFFFF}.\n\n"\
                        "Не забудьте прикрепить скриншот данного окна в жалобу.",
                        GetPlayerNameEx(playerid),
                        admin_name,
                        ban_date,
                        unban_date,
                        reason
                    );

                    ShowPlayerDialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{E0584B}{SERVER_NAME} {FFFFFF}| Аккаунт заблокирован", fmt_str, "Закрыть", "");
                    SetTimerEx("KickBannedPlayer", 5000, false, "i", playerid);
                }
                else
                {
                    mysql_format(mysql, fmt_str, sizeof fmt_str, "DELETE FROM listban WHERE acc_id=%d LIMIT 1", GetPlayerAccountID(playerid));
                    mysql_tquery(mysql, fmt_str, "", "");
                    CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
                }
            }
            else
            {
                CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
            }

            return cache_delete(result);
        }		case LOGIN_STATE_PASSWORD:
		{
			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFFFF}Добро пожаловать на {00FFFF}"SERVER_NAME"{ffffff}!\n"\
				"Аккаунт с Вашим ником зарегистрирован\n\n"\
				"Логин: {66CC66}%s\n",
				GetPlayerNameEx(playerid)
			);
			if(wrong_pass)
			{
				new ch[3];
				new attemps = GetPlayerData(playerid, P_PASS_ATTEMPS);

				valstr(ch, attemps);

				strcat(fmt_str, "{FF3300}Неверный пароль! Осталось попыток: ");
				strcat(fmt_str, ch);

				AddPlayerData(playerid, P_PASS_ATTEMPS, -, 1);
				switch(attemps)
				{
					case 0:
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{FF9933}Лимит попыток авторизации",
							"{FFFFFF}Вы ввели неправильный пароль 3 раза подряд", // . Ваш IP адрес забанен на сутки
							"Закрыть", ""
						);
						Kick:(playerid, " ");

						return 1;

						// BanEx(playerid, "Лимит попыток авторизации");
						// return AddBan(0, gettime(), 1, GetPlayerIpEx(playerid), "Лимит попыток авторизации", "Система безопасности");
					}
					case 1:
					{
						SendClientMessage(playerid, 0xFF6600FF, "При неправильном вводе пароля Вы будете забанены");
					}
				}
				PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
			}
					else strcat(fmt_str, "{FFFFFF}Введите пароль от аккаунта:");

			Dialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{66CCFF}Авторизация", fmt_str, "Войти", "Отмена");
		}
		case LOGIN_STATE_PHONE: // ввод 5 послед. цифр телефона
		{
			if(GetPlayerData(playerid, P_REQUEST_PHONE))
			{
				if(!wrong_pass)
				{
					new phone[13];

					strmid(phone, GetPlayerData(playerid, P_SETTING_PHONE), 0, strlen(GetPlayerData(playerid, P_SETTING_PHONE)) - 5);
					strcat(phone, "*****");

					format
					(
						fmt_str, sizeof fmt_str,
						"{FFFFFF}Система безопасности запрашивает ввод\n"\
						"Вашего мобильного телефона\n\n{FFCD00}%s\n\n"\
						"{FFFFFF}Введите последние 5 цифр номера:",
						phone
					);
					Dialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{66CCFF}Мобильный телефон", fmt_str, "Ввести", "Выход");
				}
					else
				{
					SendClientMessage(playerid, 0xFF0000FF, "Номер мобильного телефона введен неверно. Доступ запрещен");
					Kick:(playerid);
				}
			}
					else
			{
				return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}
		}
		case LOGIN_STATE_PIN_CODE: // ввод пин кода
		{
			if(GetPlayerData(playerid, P_REQUEST_PIN))
			{
				if(wrong_pass)
				{
					SendClientMessage(playerid, 0xFF0000FF, "PIN-код введен неверно. Доступ запрещен");
					Kick:(playerid);
				}
					else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_LOGIN_CHECK);
			}
					else
			{
				return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}
		}
		case LOGIN_STATE_LOAD_ACC:
		{
			SetPlayerData(playerid, P_AUTH_TIME, -1);
			LoadPlayerData(playerid);
		}
	}
	SetPlayerData(playerid, P_ACCOUNT_STEP_STATE, step);

	return 1;
}

public: ClearPlayerAnim(playerid)
{
	ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 0);
}


public: ClearPlayerChatAnim(playerid)
{
	if(GetPlayerData(playerid, P_USE_ANIM_TYPE) == USE_ANIM_TYPE_CHAT)
	{
		ClearPlayerAnim(playerid);
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
	}
}

public: SetPlayerLoaderJobLoad(playerid, epoch) // брать груз
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(epoch != g_BRAuthEpoch[playerid] || !IsPlayerLogged(playerid)) return 0;
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LOADER_LOAD)
		{
			//new rand = random(sizeof loader_job_attach_obj);

			ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0);
		//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, loader_job_attach_obj[rand][L_OBJECT], A_OBJECT_BONE_RIGHT_HAND, loader_job_attach_obj[rand][L_POS_X], loader_job_attach_obj[rand][L_POS_Y], loader_job_attach_obj[rand][L_POS_Z], loader_job_attach_obj[rand][L_ROT_X], loader_job_attach_obj[rand][L_ROT_Y], loader_job_attach_obj[rand][L_ROT_Z], 1.0, 1.0, 1.0, 0);

			SetPlayerLoaderJobUnLoadCP(playerid);

//			if(!random(6))
//				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_DROP_LOAD);
		}
	}
	return 1;
}

stock Mine_ClearCarry(playerid)
{
    new bool:active = g_mineCarrySlot[playerid] != -1 || g_mineExtractionPending[playerid];
    g_mineCarryTicket[playerid]++;
    g_mineExtractionPending[playerid] = false;
    if(g_mineCarrySlot[playerid] != -1)
    {
        RemovePlayerAttachedObject(playerid, g_mineCarrySlot[playerid]);
        g_mineCarrySlot[playerid] = -1;
    }
    if(active)
    {
        if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
        ClearAnimations(playerid);
    }
    return 1;
}

public: SetPlayerMinerJobTakeOre(playerid, ticket, epoch)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(epoch != g_BRAuthEpoch[playerid] || ticket != g_mineCarryTicket[playerid]) return 1;
    if(!g_mineExtractionPending[playerid]) return 1;
    if(GetPlayerTempJob(playerid) != TEMP_JOB_MINER ||
        GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_MINER_LOAD ||
        GetPlayerState(playerid) != PLAYER_STATE_ONFOOT ||
        !IsPlayerInRangeOfPoint(playerid, 3.0, GetPlayerCPInfo(playerid, CP_POS_X),
            GetPlayerCPInfo(playerid, CP_POS_Y), GetPlayerCPInfo(playerid, CP_POS_Z)))
    {
        Mine_ClearCarry(playerid);
        if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER &&
            GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_LOAD)
            SetPlayerMinerJobLoadCP(playerid);
        return 1;
    }

    new slot = -1;
    for(new i; i < 10; i++)
    {
        if(!IsPlayerAttachedObjectSlotUsed(playerid, i)) { slot = i; break; }
    }
    if(slot == -1)
    {
        Mine_ClearCarry(playerid);
        SetPlayerMinerJobLoadCP(playerid);
        return SendClientMessage(playerid, -1, "Освободите один слот аксессуаров для переноски руды.");
    }
    // Original mine rock model and hand attachment, not a new client model.
    if(!SetPlayerAttachedObject(playerid, slot, 905, A_OBJECT_BONE_LEFT_HAND,
        0.1, 0.05, -0.1, 0.0, 90.0, 0.0, 0.2, 0.2, 0.2))
    {
        Mine_ClearCarry(playerid);
        SetPlayerMinerJobLoadCP(playerid);
        return 1;
    }
    g_mineCarrySlot[playerid] = slot;
    g_mineExtractionPending[playerid] = false;
    ClearAnimations(playerid);
    ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 0, 0, 0, 0, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerMinerJobUnLoadCP(playerid);
    return 1;
}

public: SetPlayerLumberJackTakeWood(playerid, epoch)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(epoch != g_BRAuthEpoch[playerid] || !IsPlayerLogged(playerid)) return 0;
    if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_LUMBERJACK_CHOP) return 0;
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LUMBERJACK)
	{
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_PUT);

		SetPlayerLumberUnJackChopCP(playerid);

		RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 1, 0, 1, 0, 1500, 0);

		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 0, 1, 1, 1);
	//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 1463, A_OBJECT_BONE_RIGHT_HAND, 0.006, 0.138, -0.192, -109.8, -2.2, -102.9, 0.505, 0.328, 0.57);
	}
	return 1;
}

public: LumberJackPlayerDrop(playerid, bool: message)
{
	SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_CHOP);

	if(message)
		SendClientMessage(playerid, 0xFF6600FF, "Вы уронили дрова");

	RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 326, A_OBJECT_BONE_RIGHT_HAND, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);

	ApplyAnimationEx(playerid, "MISC", "Idle_Chat_02", 4.1, 0, 0, 0, 0, 1, 0);

	SetPlayerLumberJackChopCP(playerid);

	return 1;
}

public: MinerCarriageUpdate(carriageid)
{
	if(miner_carriage[carriageid][MC_STATUS] && !miner_carriage[carriageid][MC_IN_MOVE])
	{
		if(miner_carriage[carriageid][MC_ORE_COUNT] >= 500)
		{
			new fmt_str[55],
				items = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT);

			miner_carriage[carriageid][MC_ORE_COUNT] -= 500;

			SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, items + 500);
			UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);

			format(fmt_str, sizeof fmt_str, "Разгрузка\n\n{FFCC00}Количество руды\n%d / 10000 кг", miner_carriage[carriageid][MC_ORE_COUNT]);
			UpdateDynamic3DTextLabelText(miner_carriage[carriageid][MC_LABEL], 0x66CCFFFF, fmt_str);
		}
					else if(miner_carriage[carriageid][MC_ORE_COUNT] <= 0)
		{
			miner_carriage[carriageid][MC_IN_MOVE] = true;

			SetTimerEx("MinerCarriageMove", 7_000, false, "i", carriageid);
			UpdateDynamic3DTextLabelText(miner_carriage[carriageid][MC_LABEL], 0xFFFF00FF, "Ожидание...");
		}
	}
}

public: MinerCarriageMove(carriageid)
{
	new bool: status = miner_carriage[carriageid][MC_STATUS];
	if(status)
	{
	//	MoveDynamicObject(miner_carriage[carriageid][MC_OBJECT_ID], miner_carriage[carriageid][MC_START_POS_X], miner_carriage[carriageid][MC_START_POS_Y], miner_carriage[carriageid][MC_START_POS_Z], 10.0, 0.0, 0.0, 90.0);
	}
					else
	{
	//	MoveDynamicObject(miner_carriage[carriageid][MC_OBJECT_ID], miner_carriage[carriageid][MC_END_POS_X], miner_carriage[carriageid][MC_END_POS_Y], miner_carriage[carriageid][MC_END_POS_Z], 10.0, 0.0, 0.0, 90.0);
	}

	DestroyDynamic3DTextLabel(miner_carriage[carriageid][MC_LABEL]);

	miner_carriage[carriageid][MC_IN_MOVE] = true;

	miner_carriage[carriageid][MC_STATUS] = (status ^ true);
}

public: MinerCarriageSetState(carriageid)
{
	if(miner_carriage[carriageid][MC_STATUS]) // вагонетка
	{
		miner_carriage[carriageid][MC_LABEL] = CreateDynamic3DTextLabel("Разгрузка\n\n{FFCC00}Количество руды\n10000 / 10000 кг", 0x66CCFFFF, -2548.1213, 294.7194, -15.4815 + 3.0, 10.0);
		miner_carriage[carriageid][MC_ORE_COUNT] = 10_000;
	}
					else
	{
		miner_carriage[carriageid][MC_LABEL] = CreateDynamic3DTextLabel("Загрузка\n\n{FFCC00}Количество руды\n0 / 10000 кг", 0x66CC00FF, -2375.1228, 294.7194, -15.4815 + 3.0, 10.0);
		miner_carriage[carriageid][MC_PICKUP_ID] = CreatePickup(1239, 23, -2375.1228, 296.8900, -15.7689, -1, PICKUP_ACTION_TYPE_MINER_CARRI);
		miner_carriage[carriageid][MC_ORE_COUNT] = 0;
	}
}

public: NextBusRouteCP(playerid)
{
	if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
	{
		if(IsPlayerInJob(playerid))
		{
			new route_id = GetPlayerData(playerid, P_BUS_ROUTE);
			new route_step = GetPlayerData(playerid, P_BUS_ROUTE_STEP);
			new next_cp = route_step + 1;

			if(g_bus_route[route_id][next_cp][BRS_POS_X] == 0.0)
			{
				next_cp = 0;
			}

			SetPlayerRaceCheckpoint
			(
				playerid,
				g_bus_route[route_id][route_step][BRS_STOP],
				g_bus_route[route_id][route_step][BRS_POS_X],
				g_bus_route[route_id][route_step][BRS_POS_Y],
				g_bus_route[route_id][route_step][BRS_POS_Z],
				g_bus_route[route_id][next_cp][BRS_POS_X],
				g_bus_route[route_id][next_cp][BRS_POS_Y],
				g_bus_route[route_id][next_cp][BRS_POS_Z],
				4.0,
				RCP_ACTION_TYPE_BUS_ROUTE
			);
			AddPlayerData(playerid, P_BUS_ROUTE_STEP, +, 1);
		}
	}
}

public: StartPlayerJob(playerid, jobid)
{
	if(GetPlayerJob(playerid) == jobid)
	{
		//if(!IsPlayerInJob(playerid))
		//{
			new job_car = GetPlayerJobCar(playerid);
			//if(IsPlayerInVehicle(playerid, job_car))
			//{
				new action_type = GetVehicleData(job_car, V_ACTION_TYPE);
				new car_type = (action_type - VEHICLE_ACTION_TYPE_BUS_DRIVER) + 1;

				//if(jobid == car_type)
				//{
					SetPlayerJobLoadItems(playerid, 0);

					SetPlayerData(playerid, P_JOB_WAGE, 0);
					SetPlayerData(playerid, P_IN_JOB, true);
					SetVehicleData(job_car, V_ACTION_ID, true);

					new fmt_str[128];

					switch(jobid)
					{
						case JOB_BUS_DRIVER:
						{
							new route_id = GetPlayerData(playerid, P_BUS_ROUTE);

							format(fmt_str, sizeof fmt_str, "%s\n{FFFFFF}Стоимость проезда: {FF9900}%d руб", g_bus_routes[route_id][BR_NAME], GetPlayerData(playerid, P_JOB_TARIFF));
							CreateVehicleLabel(job_car, fmt_str, g_bus_routes[route_id][BR_COLOR], 0.0, 0.0, 2.6, 45.0);

							format(fmt_str, sizeof fmt_str, "начал работу водителя автобуса на маршруте %s", g_bus_routes[route_id][BR_NAME]);
							Action(playerid, fmt_str, _, false);

							NextBusRouteCP(playerid);

							SetPVarFloat(playerid, "car_damage", 1000.0);
						}
						case 6:
						{
							format(fmt_str, sizeof fmt_str, "%s{FFFF00}Тариф: %d руб", GetPlayerData(playerid, P_JOB_SERVICE_NAME), GetPlayerData(playerid, P_JOB_TARIFF));
							CreateVehicleLabel(job_car, fmt_str, 0x3399FFFF, 0.0, 0.0, 1.4, 25.0);

							Action(playerid, "начал работу таксиста", _, false);
						}
						case JOB_UNUSED_3:
						{
							SetPlayerData(playerid, P_MECHANIC_FILL_PAY, 0);
							SetPlayerData(playerid, P_MECHANIC_REPAIR_PAY, 0);

							format(fmt_str, sizeof fmt_str, "%s{FFFFFF}Автомеханик\n{999999}Нет топлива", GetPlayerData(playerid, P_JOB_SERVICE_NAME));
							CreateVehicleLabel(job_car, fmt_str, 0xCC9900FF, 0.0, 0.0, 2.0, 25.0);

							Action(playerid, "начал работу автомеханика", _, false);
						}
						case JOB_TRUCKER:
						{
							if(!GetTruckIndex(job_car))
							{
								fmt_str = "Служба\n{FFFFFF}Доставки продуктов";

								SendClientMessage(playerid, 0x66CC00FF, "Используйте {3399FF}/bizlist {66CC00}чтобы посмотреть заказы от владельцев бизнесов");
								Action(playerid, "начал работу развозчика продуктов", _, false);
							}
					else
							{
								fmt_str = "Служба\n{FFFFFF}Доставки топлива";

								SendClientMessage(playerid, 0x66CC00FF, "Используйте {3399FF}/fuellist {66CC00}для просмотра заказов от владельцев АЗС");
								Action(playerid, "начал работу развозчика топлива", _, false);
							}

							CreateVehicleLabel(job_car, fmt_str, 0x3399FFFF, 0.0, 2.1, 2.1, 20.0);
						}
					//}
				//}
			//}
		}
	}
	return 1;
}

public: EndPlayerJob(playerid)
{
	if(IsPlayerInJob(playerid))
	{
		new vehicleid = GetPlayerJobCar(playerid);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			SetVehicleToRespawn(vehicleid);
			SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);
		}
	}
	KillEndJobTimer(playerid);

	new fmt_str[128];
	new wage = GetPlayerJobWage(playerid);
	new items = GetPlayerJobLoadItems(playerid);

	SetPlayerData(playerid, P_JOB_WAGE, 0);
	SendClientMessage(playerid, 0xFFFF00FF, "Рабочий день завершен!");

	SetPlayerData(playerid, P_IN_JOB, false);
	switch(GetPlayerData(playerid, P_JOB))
	{
		case JOB_BUS_DRIVER:
		{
			new Float: health = GetPVarFloat(playerid, "car_damage");
			new repair_sum;

			if(health < 1000.0)
				repair_sum = (floatround((1000.0 - health) + float(random(100)+10))) / 3;

			DisablePlayerRaceCheckpoint(playerid);

			format(fmt_str, sizeof fmt_str, "Заработано: {00FF00}%d руб", wage + (items * GetPlayerData(playerid, P_JOB_TARIFF)));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Количество пассажиров: {00FF00}%d{FFFFFF}. Куплено билетов на {00FF00}%d руб", items, items * GetPlayerData(playerid, P_JOB_TARIFF));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			format(fmt_str, sizeof fmt_str, "За ремонт автобуса: {FF6600}-%d руб", repair_sum);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			if(repair_sum < wage)
				wage -= repair_sum;

			//GiveMoney(playerid, salary, "Зарплата Водителя Маршрутки", true, true);
		}
		case 6:
		{
			DisablePlayerRaceCheckpoint(playerid);
			wage = items * GetPlayerData(playerid, P_JOB_TARIFF);

			format(fmt_str, sizeof fmt_str, "Заработано: {00FF00}%d руб", wage);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Количество пассажиров: {00FF00}%d", items);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		}
		case JOB_UNUSED_3:
		{
			DisablePlayerRaceCheckpoint(playerid);
			wage = GetPlayerData(playerid, P_MECHANIC_FILL_PAY) + GetPlayerData(playerid, P_MECHANIC_REPAIR_PAY);

			format(fmt_str, sizeof fmt_str, "Получено за ремонт: {00FF00}%d руб", GetPlayerData(playerid, P_MECHANIC_REPAIR_PAY));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Получено за заправку: {00FF00}%d руб", GetPlayerData(playerid, P_MECHANIC_FILL_PAY));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Всего заработано: {FFCD00}%d руб", wage);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		}
		case JOB_TRUCKER:
		{
			DisablePlayerRaceCheckpoint(playerid);

			format(fmt_str, sizeof fmt_str, "Ваша общая чистая прибыль составляет {00CC00}%d руб", wage);
			SendClientMessage(playerid, -1, fmt_str);

			if(GetPlayerData(playerid, P_ORDER) != -1)
				SetOrderData(GetPlayerData(playerid, P_ORDER), O_USED, false);

			return 1;
		}
		/*
		case JOB_PITCHMAN:
		{
			new marketid = player_use_market[playerid];
			player_use_market[playerid] = -1;

			if(marketid != -1)
			{
				market_status[marketid] = false;
				UpdateMarket(marketid);
			}

			salary = player_job_load_items[playerid];

			format(fmt_str, sizeof fmt_str, "Общее количество покупателей: {00FF00}%d", market_buyers_count[playerid]);
			SendClientMessage(playerid, -1, fmt_str);

			format(fmt_str, sizeof fmt_str, "Всего продано товаров на {00FF00}%d руб", salary);
			SendClientMessage(playerid, -1, fmt_str);
		}

		case JOB_FIREFIGHTER:
		{
			check_extinguish_the_fire{playerid} = false;

			DisablePlayerRaceCheckpoint(playerid);
			TextDrawHideForPlayer(playerid, time_to_fire_TD);

			salary = player_job_load_items[playerid];

			format(fmt_str, sizeof fmt_str, "Потушено очагов возгорания: {FF3333}%d", extinguished_fires_count[playerid]);
			SendClientMessage(playerid, -1, fmt_str);

			format(fmt_str, sizeof fmt_str, "Заработано {0099CC}%d руб", salary);
			SendClientMessage(playerid, -1, fmt_str);
		}
		*/
		default:
		{
			switch(GetPlayerTempJob(playerid))
			{
				case TEMP_JOB_FACTORY_TRUCKER:
				{
			//		RemovePlayerAttachedObjects(playerid);
					SetPlayerSkinInit(playerid);

					format(fmt_str, sizeof fmt_str, "Ваша общая чистая прибыль составляет {00CC00}%d руб", wage);
					SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

					SetPlayerJobLoadItems(playerid, 0);
					SetPlayerTempJob(playerid, TEMP_JOB_NONE);
				}
			}
			return 1;
		}
	}
	SendClientMessage(playerid, 0x66CC00FF, "Деньги будут перечислены на Ваш счет во время зарплаты");

	AddPlayerData(playerid, P_WAGE, +, wage);
	
	AddPlayerData(playerid, P_TOP_2, +, wage);
	UpdatePlayerDatabaseInt(playerid, "TOP_SalaryGosWork", GetPlayerData(playerid, P_TOP_2));

	format(fmt_str, sizeof fmt_str, "UPDATE accounts SET wage=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_WAGE), GetPlayerAccountID(playerid));
	mysql_query(mysql, fmt_str, false);

	return 1;
}

public: ShowChangeNameHistory(playerid, name[])
{
	new fmt_str[64];
	new rows = cache_num_rows();

	if(!rows)
	{
		format(fmt_str, sizeof fmt_str, "{FFCD00}Прошлые имена %s", name);
		return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, fmt_str, "{FFFFFF}История изменения имен персонажа пуста", "Закрыть", "");
	}

	new text[1024] = "{FFFFFF}";
	for(new idx; idx < rows; idx ++)
	{
		cache_get_row(idx, 0, fmt_str);
		strcat(fmt_str, "\n");

		strcat(text, fmt_str);
	}
	format(fmt_str, sizeof fmt_str, "{FFCD00}Прошлые имена %s", name);
	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, fmt_str, text, "Закрыть", "");
}

public: ShowPlayerPhoneBook(playerid)
{
	if(IsPlayerPhoneBookInit(playerid))
	{
		if(GetPlayerPhoneBookContacts(playerid) > 0)
		{
			new fmt_str[37];
			new string[((sizeof fmt_str) * MAX_PHONE_BOOK_CONTACTS) + 1];

			for(new idx, count; idx < MAX_PHONE_BOOK_CONTACTS; idx ++)
			{
				if(!GetPlayerPhoneBook(playerid, idx, PB_SQL_ID)) continue;
				SetPlayerListitemValue(playerid, count ++, idx);

				format(fmt_str, sizeof fmt_str, "%s - tel.%s\n", GetPlayerPhoneBook(playerid, idx, PB_NAME), GetPlayerPhoneBook(playerid, idx, PB_NUMBER));
				strcat(string, fmt_str);
			}
			Dialog(playerid, DIALOG_PHONE_BOOK, DIALOG_STYLE_LIST, "{FFCD00}Телефонная книга", string, "Варианты", "Отмены");
		}
					else
		{
			SendClientMessage(playerid, 0xCECECEFF, "В телефонной книге нет номеров");
			SendClientMessage(playerid, 0xCECECEFF, "Чтобы добавить новый контакт введите {FFFF00}/add [id игрока]");
		}
	}
					else
	{
		InitPlayerPhoneBook(playerid);
		CallLocalFunction("ShowPlayerPhoneBook", "i", playerid);
	}
	return 1;
}

public: BusinesGPSListInit()
{
	new rows;
	new query[64 + 1];
	new Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM business_gps ORDER BY pos DESC, time ASC LIMIT %d", MAX_BUSINESS_GPS);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);
	for(new idx; idx < rows; idx ++)
	{
		SetBusinessGPSInfo(idx, BG_SQL_ID, 	cache_get_row_int(idx, 0));
		SetBusinessGPSInfo(idx, BG_BIZ_ID, 	cache_get_row_int(idx, 1));
		SetBusinessGPSInfo(idx, BG_POS, 	cache_get_row_int(idx, 2));
		SetBusinessGPSInfo(idx, BG_TIME, 	cache_get_row_int(idx, 3));
	}
	g_business_gps_count = rows;
	g_business_gps_init = true;

	cache_delete(result);
}

public: ShowPlayerGPSBusinessList(playerid)
{
	if(g_business_gps_init)
	{
		new businessid;

		new fmt_str[44];
		new string[(sizeof fmt_str) * MAX_BUSINESS_GPS];
		new city[MAX_ZONES_NAME + 1];

		if(!g_business_gps_count)
			string = "В данный момент в списке нет бизнесов";

		for(new idx, count; idx < g_business_gps_count; idx ++)
		{
			businessid = GetBusinessGPSInfo(idx, BG_BIZ_ID);

			GetCityName(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), city);
			format(fmt_str, sizeof fmt_str, "%d. %s (%s)\n", idx + 1, GetBusinessInteriorInfo(GetBusinessData(businessid, B_INTERIOR), BT_NAME) , city);
			strcat(string, fmt_str);

			SetPlayerListitemValue(playerid, count ++, idx);
		}
		Dialog(playerid, DIALOG_GPS_BUSINESS, DIALOG_STYLE_LIST, "{FFCD00}Реклама бизнеса", string, "Отметить", "Назад");
	}
					else
	{
		BusinesGPSListInit();
		CallLocalFunction("ShowPlayerGPSBusinessList", "i", playerid);
	}
}

