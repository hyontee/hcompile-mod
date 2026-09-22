//>> Файл: bykranin_src/core/jobs/jobs_04.inc  (378 строк)
//>> Тема: работы и заработок
//>> Внутри: MapIconsInit, TeleportPickupsInit, DrivingSchoolInit, ShowPlayerATMDialog, ShowPlayerATMSelectSumDialog, ShowPlayerATMSelectOtherSum, ShowPlayerATMCharityDialog
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock MapIconsInit()
{
	for(new idx; idx < sizeof map_icons; idx ++)
	{
		CreateDynamicMapIcon
		(
			GetMapIconsData(idx, MI_POS_X),
			GetMapIconsData(idx, MI_POS_Y),
			GetMapIconsData(idx, MI_POS_Z),
			GetMapIconsData(idx, MI_TYPE),
			0,
			0,
			0,
			-1,
			MAP_ICON_STREAM_DISTANCE,
			MAPICON_LOCAL
		);
	}
}

stock TeleportPickupsInit()
{
	new Text3D:buffer;
	for(new idx; idx < sizeof g_teleport; idx ++)
	{
		if(strlen(GetTeleportData(idx, T_NAME)) && !GetTeleportData(idx, T_PICKUP_VIRTUAL_WORLD))
		{
			buffer = CreateDynamic3DTextLabel
			(
				GetTeleportData(idx, T_NAME),
				0x3399FFEE,
				GetTeleportData(idx, T_PICKUP_POS_X),
				GetTeleportData(idx, T_PICKUP_POS_Y),
				GetTeleportData(idx, T_PICKUP_POS_Z) + 0.8,
				5.0,
				INVALID_PLAYER_ID,
				INVALID_VEHICLE_ID,
				0,
				0,
				0,
				-1,
				STREAMER_3D_TEXT_LABEL_SD
			);
			SetTeleportData(idx, T_LABEL, buffer);
		}
		CreatePickup(1318, 23, GetTeleportData(idx, T_PICKUP_POS_X), GetTeleportData(idx, T_PICKUP_POS_Y), GetTeleportData(idx, T_PICKUP_POS_Z), GetTeleportData(idx, T_PICKUP_VIRTUAL_WORLD), PICKUP_ACTION_TYPE_TELEPORT, idx);
	}

	CreatePickup(1318, 23, 5.6028, -23.3124, 1080.9968, -1, PICKUP_ACTION_TYPE_BIZ_CAR_ENT); // авторынок телепорт ко входу
	CreatePickup(1318, 23, 5.9334, -25.4932, 1085.9291, -1, PICKUP_ACTION_TYPE_BIZ_CAR_EXI); // авторынок телепорт к выходу

	print("[TP]: Все входы/выходы созданы");
}

stock DrivingSchoolInit()
{
	new buffer[5];

	driving_exam_CP = CreateDynamicCP(1644.4178,928.7159,1001.0000, 1.5, 1, 1, -1, 15.0); // автошкола

	CreatePickup(2894, 23, 1643.7570,915.3533,1001.0000, 1, PICKUP_ACTION_TYPE_DRIVING_TUTO); // автошкола обучающий раздел
	CreateDynamic3DTextLabel("Обучающий\nраздел", 0xCC9900BB, 1643.7570,915.3533,1001.0000 + 0.2, 5.0);

	new fmt_str[64];
	for(new idx; idx < sizeof driving_tutorial; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "{CC9900}Раздел %d: ", idx + 1);
		strins(driving_tutorial[idx][DT_TITLE], fmt_str, 0, 64);
	}

	for(new idx; idx < sizeof driving_exam; idx ++)
	{
		strins(driving_exam[idx][DE_TITLE], "{00CC66}", 0, 64);
	}
}

stock ShowPlayerATMDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_ATM, DIALOG_STYLE_LIST,
		"{FFCD00}Банкомат",
		"1. Снять с банковского счета\n"\
		"2. Положить на банковский счет\n"\
		"3. Баланс банковского счета\n"\
		"4. Снять со счета предприятия\n"\
		"5. Положить на счет предприятия\n"\
		"6. Пополнить мобильный телефон\n"\
		"7. Безналичный перевод\n"\
		"8. Оплата штрафа\n"\
		"9. Благотворительность",
		"Выбрать", "Выйти"
	);
	return 1;
}

stock ShowPlayerATMSelectSumDialog(playerid, bool:take)
{
	Dialog
	(
		playerid, take ? DIALOG_ATM_TAKE_MONEY : DIALOG_ATM_PUT_MONEY, DIALOG_STYLE_LIST,
		"Выберите сумму",
		"100 руб\n"\
		"200 руб\n"\
		"500 руб\n"\
		"1000 руб\n"\
		"2000 руб\n"\
		"5000 руб\n"\
		"10000 руб\n"\
		"Другая сумма...",
		take ? ("Снять") : ("Положить"), "Назад"
	);
	return 1;
}

stock ShowPlayerATMSelectOtherSum(playerid, bool:take)
{
	Dialog
	(
		playerid, take ? DIALOG_ATM_TAKE_OTHER_MONEY : DIALOG_ATM_PUT_OTHER_MONEY, DIALOG_STYLE_INPUT,
		"{FFCD00}Другая сумма",
		"{FFFFFF}Укажите сумму:",
		take ? ("Снять") : ("Положить"), "Назад"
	);
	return 1;
}

stock ShowPlayerATMCharityDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_ATM_CHARITY, DIALOG_STYLE_INPUT,
		"{FFCD00}Благотворительность",
		"{FFFFFF}Мы предлагаем вам перечислить любую\n"\
		"сумму на благотворительный счет\n"\
		"государства. Все средства пойдут на\n"\
		"развитие нашей страны и поднятие\n"\
		"экономики.\n\n"\
		"Помимо этого, в мэриях время от времени\n"\
		"будут публиковаться списки тех, кто\n"\
		"сделал наибольшие взносы.\n\n"\
		"Этот список можно просмотреть командой\n"\
		"/charity. Там же можно узнать общую\n"\
		"сумму сделанных Вами пожертвований.",
		"Внести", "Закрыть"
	);
	return 1;
}

stock ShowPlayerATMCompanyDialog(playerid, bool: take)
{
	new stationid = GetPlayerFuelStation(playerid);
	new businessid = GetPlayerBusiness(playerid);

	if(stationid != -1 && businessid != -1)
	{
		new fmt_str[64 + 1];

		format
		(
			fmt_str, sizeof fmt_str,
			"1. %s (№%d)\n"\
			"2. %s (№%d)",
			GetBusinessData(businessid, B_NAME), businessid,
			GetFuelStationData(stationid, FS_NAME), stationid
		);
		Dialog(playerid, take ? DIALOG_ATM_SELECT_COMPANY_TAKE : DIALOG_ATM_SELECT_COMPANY_PUT, DIALOG_STYLE_LIST, "{FFCD00}Выберите предприятие", fmt_str, "Выбрать", "Назад");
	}
					else if(stationid != -1)
	{
		ShowPlayerATMFuelStationDialog(playerid, take);
	}
					else if(businessid != -1)
	{
		ShowPlayerATMBusinessDialog(playerid, take);
	}
}

stock ShowPlayerATMFuelStationDialog(playerid, bool:take)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		Dialog
		(
			playerid, take ? DIALOG_ATM_FUEL_ST_TAKE_MONEY : DIALOG_ATM_FUEL_ST_PUT_MONEY, DIALOG_STYLE_INPUT,
			GetFuelStationData(stationid, FS_NAME),
			"{FFFFFF}Укажите сумму:",
			take ? ("Снять") : ("Положить"), "Выйти"
		);
	}
}

stock ShowPlayerATMBusinessDialog(playerid, bool:take)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		Dialog
		(
			playerid, take ? DIALOG_ATM_BIZ_TAKE_MONEY : DIALOG_ATM_BIZ_PUT_MONEY, DIALOG_STYLE_INPUT,
			GetBusinessData(businessid, B_NAME),
			"{FFFFFF}Укажите сумму:",
			take ? ("Снять") : ("Положить"), "Выйти"
		);
	}
}

stock CreateATMs()
{
	for(new idx; idx < sizeof(g_atm); idx ++)
	{
		ATM_Areas[idx] = CreateDynamicSphere
		(
			g_atm[idx][A_POS_X],
			g_atm[idx][A_POS_Y],
			g_atm[idx][A_POS_Z],
			2.0,
			g_atm_virtual_world[idx],
			g_atm_interior[idx]
		);

		CreateDynamic3DTextLabel
		(
			"{33AAFF}Банкомат\n{FFFFFF}Нажмите Y",
			0xFFFFFFFF,
			g_atm[idx][A_POS_X],
			g_atm[idx][A_POS_Y],
			g_atm[idx][A_POS_Z] + 0.35,
			6.0,
			INVALID_PLAYER_ID,
			INVALID_VEHICLE_ID,
			0,
			g_atm_virtual_world[idx],
			g_atm_interior[idx],
			-1,
			STREAMER_3D_TEXT_LABEL_SD
		);
	}
	return 1;
}

stock IsPlayerAtATM(playerid)
{
	for(new idx; idx < sizeof(ATM_Areas); idx ++)
	{
		if(ATM_Areas[idx] != 0 && IsPlayerInDynamicArea(playerid, ATM_Areas[idx]))
		{
			return 1;
		}
	}
	return 0;
}

stock BanksInit()
{

	CreatePickup(1274, 23, 2900.7514,2509.6052,1051.0048, -1, PICKUP_ACTION_TYPE_BANK, false);
	CreateDynamic3DTextLabel("Оплата\n{CCCC00}дома\nбизнеса\nАЗС\nгаража", 0x00CC00FF, 2900.7514,2509.6052,1051.0048 + 0.8, 8.0);

	CreatePickup(1274, 23, 2905.8186,2505.3171,1051.0048, -1, PICKUP_ACTION_TYPE_BANK, true);
	CreateDynamic3DTextLabel("Управление счетами\n{FFFFFF}/bank", 0x00CC00FF, 2905.8186,2505.3171,1051.0048 + 0.8, 8.0);

	CreatePickup(1274, 23, 2909.5684,2503.9167,1051.0048, -1, PICKUP_ACTION_TYPE_BANK, true);
	CreateDynamic3DTextLabel("Управление счетами\n{FFFFFF}/bank", 0x00CC00FF, 2909.5684,2503.9167,1051.0048 + 0.8, 8.0);

	CreatePickup(1274, 23, 2913.0930,2503.5193,1051.0048, -1, PICKUP_ACTION_TYPE_BANK, true);
	CreateDynamic3DTextLabel("Управление счетами\n{FFFFFF}/bank", 0x66CC66FF, 2913.0930,2503.5193,1051.0048 + 0.8, 8.0);

	CreatePickup(1274, 23, 2903.0869,2507.1462,1051.0048, -1, PICKUP_ACTION_TYPE_BANK, false);
	CreateDynamic3DTextLabel("Оплата\n{CCCC00}дома\nбизнеса\nАЗС\nгаража", 0x66CC66FF, 2903.0869,2507.1462,1051.0048 + 0.8, 8.0);
}

stock TempJobsInit()
{
	new idx;
	for(idx = 0; idx < sizeof g_temp_jobs; idx ++)
	{
		//if(idx == 3) continue; // пикап в заводе (создается отдельно от всех)

		CreatePickup(1275, 23, GetTempJobInfo(idx, TJ_POS_X), GetTempJobInfo(idx, TJ_POS_Y), GetTempJobInfo(idx, TJ_POS_Z), -1, PICKUP_ACTION_TYPE_TEMP_JOB, idx);
	}
	//loader_job_area = CreateDynamicRectangle(591.4026, 1781.0015, 482.7329, 1534.9045, 0, 0);

//	AddStaticVehicleEx(530, 494.4254, 1639.0137, 11.9525, 266.6, 6, 1, 5, 0, VEHICLE_ACTION_TYPE_LOADER); // погрузчик в порту
//	AddStaticVehicleEx(530, 494.4254, 1641.4299, 11.9525, 266.6, 6, 1, 5, 0, VEHICLE_ACTION_TYPE_LOADER); // погрузчик в порту
//	AddStaticVehicleEx(530, 494.4254, 1643.8461, 11.9525, 266.6, 6, 1, 5, 0, VEHICLE_ACTION_TYPE_LOADER); // погрузчик в порту

	// шахта
	for(idx = 0; idx < sizeof miner_carriage; idx ++)
	{
		miner_carriage[idx][MC_STATUS] = false;
//		miner_carriage[idx][MC_OBJECT_ID] = CreateDynamicObject(1769, miner_carriage[idx][MC_START_POS_X], miner_carriage[idx][MC_START_POS_Y], miner_carriage[idx][MC_START_POS_Z], 0.0, 0.0, 90.0);

//		Streamer_SetIntData(STREAMER_TYPE_OBJECT, miner_carriage[idx][MC_OBJECT_ID], E_STREAMER_EXTRA_ID, OBJECT_TYPE_CARRIAGE);

		miner_carriage[idx][MC_LABEL] = CreateDynamic3DTextLabel("Загрузка\n\n{FFCC00}Количество руды\n0 / 10000 кг", 0x66CC00FF, -2375.1228, 294.7194, -15.4815 + 3.0, 10.0);
		miner_carriage[idx][MC_PICKUP_ID] = CreatePickup(1239, 23, -2375.1228, 296.8900, -15.7689, -1, PICKUP_ACTION_TYPE_MINER_CARRI);
	}
	miner_job_area = CreateDynamicRectangle(2447.1799,1697.9985, 2279.3557,1806.0872, 0, 0);

	for(new i; i < sizeof miner_job_load_pos; i ++)
	{
		CreateDynamic3DTextLabel("Место\nдобычи руды", 0xFFFF00AA, miner_job_load_pos[i][0], miner_job_load_pos[i][1], miner_job_load_pos[i][2], 10.0);
		//miner_job_load_cp[i] = CreateDynamicCP(miner_job_load_pos[i][0], miner_job_load_pos[i][1], miner_job_load_pos[i][2], 1.2, _, _, _, 1.3);
	}

	CreatePickup(1318, 23, 2305.8884, 1738.6920, 1.7285, 0, PICKUP_ACTION_TYPE_MINER_SELL_M);
	CreateDynamic3DTextLabel("Продажа Материалыа\n{00CC00}15 рублей {FFFFFF}за 1 кг", 0x9966FFBB,  2305.8884, 1738.6920, 1.7285 + 1.2, 10.0);

	CreateDynamic3DTextLabel("Шахта\n\n{3399CC}1. Выдача инструментов\n2. Получение зарплаты", 0x009933FF, GetTempJobInfo(TEMP_JOB_MINER, TJ_POS_X), GetTempJobInfo(TEMP_JOB_MINER, TJ_POS_Y), GetTempJobInfo(TEMP_JOB_MINER, TJ_POS_Z) + 0.82, 5.0);

	// завод
	for(idx = 0; idx < 3; idx ++)
	{
		CreatePickup(1275, 33, 264.4713, -217.2706 + float(idx * 2), 1006.5694, -1, PICKUP_ACTION_TYPE_TEMP_JOB, TEMP_JOB_FACTORY);
	}
	for(idx = 0; idx < sizeof factory_take_metall_pos; idx ++)
	{
		CreatePickup(1279, 23, factory_take_metall_pos[idx][0], factory_take_metall_pos[idx][1], factory_take_metall_pos[idx][2] - 0.4, 1, PICKUP_ACTION_TYPE_FACTORY_MET);
	}
	for(idx = 0; idx < sizeof factory_put_metall_pos; idx ++)
	{
		CreatePickup(1318, 23, factory_put_metall_pos[idx][0], factory_put_metall_pos[idx][1], factory_put_metall_pos[idx][2] - 0.4, 1, PICKUP_ACTION_TYPE_P_CREATE, idx);
	}

	new Float: x = 311.6580, Float: y = -207.6711, Float: z = 1006.5694;
	for(idx = 0; idx < sizeof factory_desk; idx ++)
	{
		if(idx && !(idx % 4))
			y -= (idx != 8 ? 2.9917 : 3.0085);

		factory_desk[idx][FD_POS_X] = x - (float(idx % 4) * 5.5003);
		factory_desk[idx][FD_POS_Y] = y;
		factory_desk[idx][FD_POS_Z] = z;

		factory_desk[idx][FD_USED] = false;
		factory_desk[idx][FD_OBJECT_ID] = -1;

		factory_desk[idx][FD_CHEK_ID] = CreateDynamicCP(factory_desk[idx][FD_POS_X], factory_desk[idx][FD_POS_Y], factory_desk[idx][FD_POS_Z], 0.3, _, _, _, 0.3);
		factory_desk[idx][FD_LABEl] = CreateDynamic3DTextLabel("Рабочее место", 0xFFFFFFEE, factory_desk[idx][FD_POS_X], factory_desk[idx][FD_POS_Y], factory_desk[idx][FD_POS_Z] + 1.0, 5.0);

		CallLocalFunction("UpdateFactoryDesk", "i", idx);
	}
	factory_put_zone = CreateDynamicRectangle(264.8033, -199.8648, 296.8693, -202.0421);
	factory_job_area = CreateDynamicRectangle(-981.2298, 2098.1736, -1170.6591, 2263.3167, 0, 0);

	// --------------- Завод
	AddStaticVehicleEx(406, -1076.2706, 2204.9490, 38.4303, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // фургон для перевози Материалыа
	AddStaticVehicleEx(406, -1081.3639, 2204.7727, 38.4130, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // фургон для перевози Материалыа
	AddStaticVehicleEx(406, -1086.3571, 2204.7319, 38.3786, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // фургон для перевози Материалыа
	AddStaticVehicleEx(406, -1090.8806, 2204.7322, 38.3446, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // фургон для перевози Материалыа

	AddStaticVehicleEx(514, -1116.3119, 2205.5913, 38.2890, 179.9556, 6, 6, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // фура для перевозки топлива
	AddStaticVehicleEx(514, -1107.9980, 2205.7349, 38.1867, 180.4830, 6, 6, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // фура для перевозки топлива

	AddStaticVehicleEx(584,-1121.6831, 2190.3965, 38.0457, 263.2740, 1, 1, 180, 0, VEHICLE_ACTION_TYPE_FACTORY, true); // цистерна
	AddStaticVehicleEx(584,-1121.6831, 2181.3005, 38.0457, 263.2740, 1, 1, 180, 0, VEHICLE_ACTION_TYPE_FACTORY, true); // цистерна
}

stock BusRoutesInit()
{
	new fmt_str[64];

	for(new idx; idx < sizeof g_bus_routes; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d.  %s\n", idx + 1, g_bus_routes[idx][BR_NAME]);
		strcat(g_bus_routes_list, fmt_str);

		if(g_bus_routes[idx][BR_COLOR] > 0)
		{
			g_bus_routes[idx][BR_COLOR] = 0x66CC00FF;
		}
					else g_bus_routes[idx][BR_COLOR] = 0x3399FFFF;
	}
}

