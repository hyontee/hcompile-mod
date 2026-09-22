//>> Файл: bykranin_src/core/jobs/jobs_03.inc  (425 строк)
//>> Тема: работы и заработок
//>> Внутри: ChangePlayerName, EndPlayerTempJob, TogglePlayerFactoryCP, KillEndJobTimer, StartEndJobTimer, ShowPlayerBuyMetalDialog, SetPlayerMinerJobLoadCP
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ChangePlayerName(playerid, name[], bool: non_rp_nick = false)
{
	new query[128];
	new Cache: result, rows;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	rows = cache_num_rows(result);
	cache_delete(result);

	if(3 <= strlen(name) <= 20 && !rows)
	{
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET name='%e' WHERE id=%d LIMIT 1", name, GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);

		if(!mysql_errno())
		{
			mysql_format(mysql, query, sizeof query, "INSERT INTO change_names (owner_id,name,time,ip) VALUES (%d,'%e',%d,'%e')", GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), gettime(), GetPlayerIpEx(playerid));
			mysql_query(mysql, query, false);

			format(query, sizeof query, "%s сменил %s на %s", GetPlayerNameEx(playerid), non_rp_nick ? "нон-рп имя" : "имя", name);

			format(g_player[playerid][P_NAME], 21, "%s", name);
			SetPlayerName(playerid, GetPlayerNameEx(playerid));

			SendClientMessageToAll(0xCCFF00FF, query);
			UpdateCharity();

			new buffer;
			if((buffer = GetPlayerFuelStation(playerid)) != -1)
			{
				format(g_fuel_station[buffer][FS_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateFuelStationLabel", "i", buffer);
			}
			if((buffer = GetPlayerBusiness(playerid)) != -1)
			{
				format(g_business[buffer][B_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateBusinessLabel", "i", buffer);
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOME)) != -1)
			{
				format(g_house[buffer][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_ROOM)) != -1)
			{
				new room = GetPlayerData(playerid, P_HOUSE_ROOM);
				format(g_house_renters[buffer][room][HR_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL)) != -1)
			{
				new room = GetPlayerData(playerid, P_HOUSE_ROOM);
				format(g_hotel[buffer][room][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
			}
			return 1;
		}
	}
	return 0;
}



stock EndPlayerTempJob(playerid, job, bool:annul = false)
{
	print("EndPlayerTempJob");
	if(GetPlayerTempJob(playerid) == job)
	{
		if(job == TEMP_JOB_MINER) Mine_ClearCarry(playerid);
		printf("GetPlayerTempJob(%d) == job(%d)", GetPlayerTempJob(playerid), job);
		SetPlayerTempJobCheckAnim(playerid, false);

	//	RemovePlayerAttachedObjects(playerid);
		SetPlayerSkinInit(playerid);

		new items = GetPlayerJobLoadItems(playerid);
		new pay_sum = items * GetTempJobInfo(job, TJ_PAY_FOR_LOAD);

		if(g_doubling[DOUBLING_WAGE])
			pay_sum = pay_sum * 2;

		new fmt_str[128];
		switch(job)
		{
			case TEMP_JOB_LOADER:
			{
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);

				TogglePlayerDynamicCP(playerid, help_info_CP, true);

				if(!annul)
				{
					new ts_pay = false;
					if(pay_sum > 0)
						format(fmt_str, sizeof fmt_str, ". Заработано {FFFF00}%d руб.", pay_sum);

					strins(fmt_str, "[Информация]: "c_server"Рабочий день завершен", 0, sizeof fmt_str);
					SendClientMessage(playerid, COR_SERVER, fmt_str);

					if(ts_pay)
					{
						format(fmt_str, sizeof fmt_str, "%d руб {3399FF}за работу на погрузчике", pay_sum);
						SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
					}

					if(pay_sum > 0)
						GivePlayerMoneyEx(playerid, pay_sum, "Зарплата на работе грузчика", true, false);

					format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
					GameTextForPlayer(playerid, fmt_str, 4000, 1);
				}
				/*else SendClientMessage(playerid, 0xFF6600FF, "Вы покинули территорию склада. Заработок был аннулирован");

				items = GetPlayerVehicleID(playerid); // в items временно хранится ид авто
				if(GetVehicleData(items, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_LOADER)
				{
					SetVehicleToRespawn(items);
				}
				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);*/
			}
			case TEMP_JOB_MINER:
			{
				DisablePlayerCheckpoint(playerid);

				if(!annul)
				{
					if(items > 0)
					{
						format(fmt_str, sizeof fmt_str, "Рабочий день завершен. Вы добыли %d кг руды", items);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);

						format(fmt_str, sizeof fmt_str, "Всего заработано %d руб", pay_sum);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);

						GivePlayerMoneyEx(playerid, pay_sum, "Зарплата на работе шахтера", true, false);

						format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
						GameTextForPlayer(playerid, fmt_str, 4000, 1);
					}
					else SendClientMessage(playerid, 0x3399FFFF, "Рабочий день завершен");
				}
					else SendClientMessage(playerid, 0xFF6600FF, "Вы покинули территорию шахты. Заработок был аннулирован");

				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);
			}
			case TEMP_JOB_FACTORY:
			{
				pay_sum = GetPlayerJobWage(playerid);

				new bad_items = GetPVarInt(playerid, "factory_bad_prods");
				new skill = GetPVarInt(playerid, "factory_skill");
				new waste_sum = bad_items * (random(16) + 5);

				if(!annul)
				{
					SendClientMessage(playerid, 0x3399FFFF, "Рабочий день завершен");
					if(pay_sum > 0 && waste_sum < pay_sum)
					{
						format(fmt_str, sizeof fmt_str, "Всего создано {FFFF00}%d {66CC00}продуктов, забракованно {FFFF00}%d шт.", items, bad_items) ;
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);

						if(skill > 0)
						{
							format(fmt_str, sizeof fmt_str, "Рабочий навык увеличился {66CCFF}на %d единиц(ы)", skill);
						}
					else fmt_str = "Рабочий навык не изменился";
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);

						format(fmt_str, sizeof fmt_str, "Заработано {00CC00}%d руб, {FFFFFF}из них {FF6600}%d руб {FFFFFF}- штраф за брак продуктов", pay_sum, waste_sum);
						SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

						pay_sum -= waste_sum;
						format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
						GameTextForPlayer(playerid, fmt_str, 4000, 1);

						GivePlayerMoneyEx(playerid, pay_sum, "Зарплата на работе в цеху (завод)", true, false);
					}
				}
					else SendClientMessage(playerid, 0xFF6600FF, "Вы покинули территорию завода. Выручка была аннулирована");

				skill = GetPlayerData(playerid, P_FACTORY_USE_DESK);
				SetPlayerFactoryDeskUse(playerid, skill, false);
			}
			case TEMP_JOB_LUMBERJACK:
			{
				DisablePlayerCheckpoint(playerid);

				if(!annul)
				{
					if(items > 0)
					{
						format(fmt_str, sizeof fmt_str, "Рабочий день завершен. Вы принесли %d шт дров", items);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);

						format(fmt_str, sizeof fmt_str, "Всего заработано %d руб", pay_sum);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);

						GivePlayerMoneyEx(playerid, pay_sum, "Зарплата на работе лесоруба", true, false);

						format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
						GameTextForPlayer(playerid, fmt_str, 4000, 1);
					}
					else SendClientMessage(playerid, 0x3399FFFF, "Рабочий день завершен");
				}
					else SendClientMessage(playerid, 0xFF6600FF, "Вы покинули территорию лесопилки. Заработок был аннулирован");

				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);
			}
		}

		SetPlayerJobLoadItems(playerid, 0);
		SetPlayerData(playerid, P_JOB_WAGE, 0);
		SetPlayerTempJob(playerid, TEMP_JOB_NONE);
		
		AddPlayerData(playerid, P_TOP_1, +, pay_sum);
		UpdatePlayerDatabaseInt(playerid, "TOP_SalaryNewWork", GetPlayerData(playerid, P_TOP_1));
	}
}

stock TogglePlayerFactoryCP(playerid, toggle)
{
	for(new idx; idx < sizeof factory_desk; idx ++)
	{
		TogglePlayerDynamicCP(playerid, factory_desk[idx][FD_CHEK_ID], toggle);
	}
}

stock KillEndJobTimer(playerid)
{
	KillTimer(GetPlayerData(playerid, P_END_JOB_TIMER));
	SetPlayerData(playerid, P_END_JOB_TIMER, -1);
}

stock StartEndJobTimer(playerid, time = 15_000)
{
	if(GetPlayerData(playerid, P_END_JOB_TIMER) == -1)
		SetPlayerData(playerid, P_END_JOB_TIMER, SetTimerEx("EndPlayerJob", time, false, "i", playerid));
}

stock ShowPlayerBuyMetalDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_MINER_BUY_METALL, DIALOG_STYLE_INPUT,
		"{FFCD00}Покупка Материалыа",
		"{FFFFFF}Сколько кг Материалыа вы хотите купить?\n"\
		"{00CC00}Цена за кг: 15 рублей",
		"Купить", "Отмена"
	);
}

stock SetPlayerMinerJobLoadCP(playerid)
{
    if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
    {
        new rand = random(sizeof miner_job_chop_cp);
        SetPlayerCheckpoint(playerid, miner_job_chop_cp[rand][0], miner_job_chop_cp[rand][1], miner_job_chop_cp[rand][2], 2.0, CP_ACTION_TYPE_MINER_JOB_TAKE);
        SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
    }
}

stock SetPlayerMinerJobUnLoadCP(playerid)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
	{
		SetPlayerCheckpoint(playerid, 557.127014,515.962341,999.714599, 2.0, CP_ACTION_TYPE_MINER_JOB_PUT);

		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_UNLOAD);
	}
}

public: SetPlayerLoaderJobUnLoadCP(playerid) // установить чекпоинт где ложить груз
{
    if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
    {
        new rand = random(sizeof loader_job_unload_cp);

        SetPlayerCheckpoint(playerid, loader_job_unload_cp[rand][0], loader_job_unload_cp[rand][1], loader_job_unload_cp[rand][2], 2.0, CP_ACTION_TYPE_LOADER_JOB_PUT);
        //SetPlayerCheckpoint(playerid, 622.3066, 1664.1621, 12.1726, 2.0);
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_UNLOAD);

        SetPlayerTempJobCheckAnim(playerid, true);
    }
}

public: SetPlayerLoaderJobLoadCP(playerid) // установить чекпоинт где брать груз
{
    if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
    {
        new rand = random(sizeof loader_get_cp);

        SetPlayerTempJobCheckAnim(playerid, false);

        SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_LOAD);
        SetPlayerCheckpoint(playerid, loader_get_cp[rand][0], loader_get_cp[rand][1], loader_get_cp[rand][2], 2.0, CP_ACTION_TYPE_LOADER_JOB_TAKE);
    }
}

stock SetPlayerLumberJackChopCP(playerid)
{
	new rand = random(sizeof lumberjack_job_chop_cp);

	SetPlayerCheckpoint(playerid, lumberjack_job_chop_cp[rand][0], lumberjack_job_chop_cp[rand][1], lumberjack_job_chop_cp[rand][2], 2.0, CP_ACTION_TYPE_LUMBERJACK_TAKE);
}

stock SetPlayerLumberUnJackChopCP(playerid)
{
	SetPlayerCheckpoint(playerid, 2239.7788,496.8613,15.7230, 2.0, CP_ACTION_TYPE_LUMBERJACK_PUT);
}

stock ShowPlayerDrivingTutorial(playerid)
{
    
	Dialog
	(
		playerid, DIALOG_DRIVING_TUTORIAL_START, DIALOG_STYLE_MSGBOX,
		"{0099FF}Введение",
		"{FFFFFF}Это пособие поможет вам хорошо подготовиться\n"\
		"к экзамену по вождению\n\n"\
		"{CC9900}Для того, чтобы начать обучение нажмите \"Далее\"",
		"Далее", "Отмена"
	);
	return 1;
}

stock ShowDrivingTutorialSection(playerid, step)
{
	if(0 <= step <= sizeof driving_tutorial-1)
	{
		Dialog
		(
			playerid, DIALOG_DRIVING_TUTORIAL, DIALOG_STYLE_MSGBOX,
			driving_tutorial[step][DT_TITLE],
			driving_tutorial[step][DT_INFO],
			"Далее", "Назад"
		);
		SetPVarInt(playerid, "driving_tutorial_step", step);
	}
}

stock ShowPlayerDrivingExam(playerid, step)
{
	if(0 <= step <= sizeof driving_exam - 1)
	{
		Dialog
		(
			playerid, DIALOG_DRIVING_EXAM, DIALOG_STYLE_LIST,
			driving_exam[step][DE_TITLE],
			driving_exam[step][DE_LIST_ITEMS],
			"Ответить", ""
		);
		SetPlayerDrivingExamInfo(playerid, DE_EXAM_STEP, step);
	}
					else if(step >= sizeof driving_exam)
	{
		new points = GetPlayerDrivingExamInfo(playerid, DE_POINTS);
		SetPlayerDrivingExamInfo(playerid, DE_EXAM_STEP, 0);
		SetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP, 0);

		if(points >= 9)
			SetPlayerData(playerid, P_DRIVING_LIC, 1);

		new fmt_str[256];
		format(fmt_str, sizeof fmt_str, "{FFFFFF}Количество правильных ответов: {66CC00}%d\n\n", points);

		if(points == 9)
		{
			strcat
			(
				fmt_str,
				"{6699FF}Поздравляем!\n"\
				"Вы набрали минимальное количество баллов, чтобы приступить ко второй части экзамена!"
			);
		}
					else if(points >= 10)
		{
			static const
				medal_name[3][12] = {"бронзовую", "серебрянную", "золотую"};

			format(fmt_str, sizeof fmt_str, "%s{6699FF}Поздравляем!\nВы получаете %s медаль за теоретическую часть экзамена!", fmt_str, medal_name[points - 10]);
		}
					else
		{
			ClearPlayerDrivingExamInfo(playerid);
			strcat
			(
				fmt_str,
				"{FF6600}К сожалению вы не набрали необходимого количества баллов\n"\
				"В следующий раз внимательно прочитайте обучающий раздел\n"\
				"Ждем вас на пересдаче!"
			);
		}

		Dialog
		(
			playerid, DIALOG_DRIVING_EXAM_RESULT, DIALOG_STYLE_MSGBOX,
			"{FFFF00}Результаты теоретической части",
			fmt_str,
			"Ок", ""
		);
	}
	return 1;
}

stock NextDrivingExamRouteCP(playerid)
{
	new step = GetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP);

	SetPlayerRaceCheckpoint
	(
		playerid,
		0,
		driving_exam_route[step][0],
		driving_exam_route[step][1],
		driving_exam_route[step][2],
		driving_exam_route[step + 1][0],
		driving_exam_route[step + 1][1],
		driving_exam_route[step + 1][2],
		4.0,
		RCP_ACTION_TYPE_DRIVING_EXAM
	);
	SetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP, step + 1);
}

