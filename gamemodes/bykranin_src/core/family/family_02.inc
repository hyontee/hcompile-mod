//>> Файл: bykranin_src/core/family/family_02.inc  (867 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: AnimListInit, RepositoriesLoad, RepositoriesInit, UpdateRepository, UpdateOilFactory, UpdateMinerRemelting, SaveRepository
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// ===== [ ТЕСТ: все метки складов в один ряд ] =====
// Нужен, если карта другая и метки оказываются под землёй.
// Чтобы вернуть настоящие координаты - закомментируй следующую строку.
#define REPO_TEST_ROW
#define REPO_TEST_X    (-988.0)
#define REPO_TEST_Y    (2215.0)
#define REPO_TEST_Z    (44.0)
#define REPO_TEST_STEP (5.0)   // расстояние между метками по оси X

new g_repo_test_idx = 0;

stock Text3D:Repo_CreateLabel(const text[], color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testlos = 0, worldid = -1, interiorid = -1)
{
#if defined REPO_TEST_ROW
	x = REPO_TEST_X + (float(g_repo_test_idx) * REPO_TEST_STEP);
	y = REPO_TEST_Y;
	z = REPO_TEST_Z;
	worldid = -1;
	interiorid = -1;
	g_repo_test_idx ++;
#endif
	return CreateDynamic3DTextLabel(text, color, x, y, z, drawdistance, attachedplayer, attachedvehicle, testlos, worldid, interiorid);
}

stock Repo_CreatePickup(modelid, Float:x, Float:y, Float:z, worldid = 0)
{
#if defined REPO_TEST_ROW
	x = REPO_TEST_X + (float(g_repo_test_idx) * REPO_TEST_STEP);
	y = REPO_TEST_Y;
	z = REPO_TEST_Z;
	worldid = 0;
	g_repo_test_idx ++;
#endif
	return CreatePickup(modelid, 23, x, y, z, worldid);
}

stock AnimListInit()
{
	new fmt_str[64];
	for(new idx; idx < sizeof anim_list; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d. %s\n", idx + 1, GetAnimListData(idx, AL_DESCRIPTION));
		strcat(anim_list_items, fmt_str);

		if(GetAnimListData(idx, AL_LOOP) > 2)
			anim_list[idx][AL_DESCRIPTION] = 2;
	}
	strcat(anim_list_items, "{33CC00}Информация");
}

stock RepositoriesLoad()
{
	new Cache: result;
	new type, action_id;

	result = mysql_query(mysql, "SELECT * FROM repositories ORDER BY type,action_id ASC");
	new rows = cache_num_rows(result);

	for(new idx; idx < rows; idx ++)
	{
		type = cache_get_row_int(idx, 1);
		action_id = cache_get_row_int(idx, 2);

		if(0 <= type <= sizeof g_repository-1)
		{
			if(0 <= action_id <= sizeof g_repository[]-1)
			{
				SetRepositoryData(type, action_id, R_AMOUNT, cache_get_row_int(idx, 3));
			}
		}
	}
	cache_delete(result);

	RepositoriesInit();
}

stock RepositoriesInit()
{
	// шахта

	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2387.6606, 1757.4240, -1.8463 + 1.0, 20.0));
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_LABEL_2, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2317.1355, 1738.4092, 5.0, 25.0));

	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);

	// ----------------------
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, -2568.2881, 297.3934, -15.7620 + 2.5, 15.0));
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_LABEL_2, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2382.7622, 1720.6998, 4.0, 30.0));

	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);

	// ----------------------
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2387.6606, 1752.0416, -1.8463 + 1.0, 20.0));
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI);

	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_NOT_SAVE, true);
	SetTimer("UpdateMinerRemelting", 10_000, false);

	// завод
	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, -1046.6550,2208.5771, 41.0, 25.0));
	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL_2, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 263.7803, -203.8183, 1010.0, 15.0));

	factory_store_label[0] = Repo_CreateLabel("На складе:\n{FF9900}Топливо: 0 / 1000000 л\n\n{6699FF}/sellf", 0xFFFFFFFF, -1120.4103,2175.6133,38.0294, 20.0); // топливо

	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);

	// нефтезавод
	Repo_CreateLabel("Прямо\n\n{FFFFFF}Продажа топлива для АЗС", 0xFF6600FF, 977.3191, 630.5245, 12.1154 - 0.5, 20.0);
	Repo_CreateLabel("Направо\n\n{FFFFFF}Продажа топлива для завода", 0xFF6600FF, 977.3191, 635.4105, 12.1154 - 0.5, 20.0);

	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2738.3379,-2273.0725,17.9063 + 5.0, 35.0)); // для азс
	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_LABEL_2, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2710.3369,-2383.5164,17.9063 + 5.0, 35.0)); // для завода

	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);
	SetTimer("UpdateOilFactory", 30_000, false);

	// воинская часть
	SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 1562.881469,1642.907470,15.971530 + 1.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 18, 3)); // Материалы
	SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 1584.912963,1636.776245,16.058158 + 1.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 18, 3)); // патроны

	UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL);
	UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO);

	// лесопилка
	SetRepositoryData(REPOSITORY_TYPE_SAWMILL, REPOSITORY_ACTION_SAWMILL_WOOD, R_LABEL, Repo_CreateLabel("-No Init-", 0xFFFFFFFF, 2411.6389,-599.9781,12.3683 + 2.0, 10.0)); // дерево на лесопилке

	UpdateRepository(REPOSITORY_TYPE_SAWMILL, REPOSITORY_ACTION_SAWMILL_WOOD);

	// пикапы складов (раньше создавались в OnGameModeInit)
	Repo_CreatePickup(1279, -1120.4103,2175.6133,38.0294); // топливо завода (/sellf)
	Repo_CreatePickup(1650, -1043.8157,2205.5217,38.1195); // материалы завода (/sellm)
	Repo_CreatePickup(1279, 2424.5317,1765.6780,-0.2507); // склад шахты (/buym)
	Repo_CreatePickup(1650, 2710.3369,-2383.5164,17.9063); // нефтезавод: топливо для завода
	Repo_CreatePickup(1650, 2738.3379,-2273.0725,17.9063); // нефтезавод: топливо для АЗС

	print("[Repositories]: Все склады загружнены");
}

stock UpdateRepository(type, actionid)
{
	new fmt_str[128];
	new amount = GetRepositoryData(type, actionid, R_AMOUNT);
	new Text3D: label = GetRepositoryData(type, actionid, R_LABEL);
	new Text3D: label_2 = GetRepositoryData(type, actionid, R_LABEL_2);

	switch(type)
	{
		case REPOSITORY_TYPE_MINER:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_MINER_METAL:
				{
					format(fmt_str, sizeof fmt_str, "Покупка Материалыа\n(для развозчиков)\n\n{FFCD00}На складе %d кг\nКупить: /buym", amount);
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);

					format(fmt_str, sizeof fmt_str, "Материалы\n{0099CC}На складе:\n%d кг", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
				}
				case REPOSITORY_ACTION_MINER_ORE:
				{
					format(fmt_str, sizeof fmt_str, "Руда\n{00CC00}На складе:\n%d кг", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);

					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);
				}
				case REPOSITORY_ACTION_MINER_REMELTI:
				{
					format(fmt_str, sizeof fmt_str, "Кузница\n{CC9900}%d кг руды\nна переплавке", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
				}
			}
		}
		case REPOSITORY_TYPE_FACTORY:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_FACTORY_METAL..REPOSITORY_ACTION_FACTORY_PROD:
				{
					if(actionid != REPOSITORY_ACTION_FACTORY_PROD)
					{
						format(fmt_str, sizeof fmt_str, "На складе:\n{FF9900}Топливо: %d / 1000000 л\n\n{6699FF}/sellf", GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT));
						UpdateDynamic3DTextLabelText(factory_store_label[0], 0xFFFFFFFF, fmt_str);
					}

					label = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL);
					label_2 = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL_2);

					new factory_text[192];
					format
					(
						factory_text, sizeof factory_text,
						"Склад производственного цеха\n"\
						"{FF9900}Топливо: %d / 1000000 л\n"\
						"Материалы: %d / 1000000 кг\n"\
						"{33CC00}Продукты: %d шт.\n\n"\
						"{6699FF}/sellm  {33CC00}/buyprod",
						GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT),
						GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT),
						GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT)
					);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, factory_text);
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, factory_text);
				}
			}
		}
		case REPOSITORY_TYPE_OIL_FACTORY:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_OIL_FACTORY_F:
				{
					format(fmt_str, sizeof fmt_str, "Топливо для АЗС\n\n{FFCD00}На складе\n%d л топлива\n{33FF00}Купить: /buyf", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);

					format(fmt_str, sizeof fmt_str, "Топливо для завода\n\n{FFCD00}На складе\n%d л топлива\n{33FF00}Купить: /buyf", amount);
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);
				}
			}
		}
		case REPOSITORY_TYPE_ARMY:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_ARMY_METAL:
				{
					format(fmt_str, sizeof fmt_str, "Материалы на складе:\n{66cc33}%d кг\n\n{9999ff}/takem\n/putm", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
				}
				case REPOSITORY_ACTION_ARMY_AMMO:
				{
					format(fmt_str, sizeof fmt_str, "Патроны на складе:\n%d / 200000 шт.", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFCD00FF, fmt_str);
				}
			}
		}
		case REPOSITORY_TYPE_SAWMILL:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_SAWMILL_WOOD:
				{
					format(fmt_str, sizeof fmt_str, "На складе:\n{FF9900}Дерево: %d / 1000000 ед", GetRepositoryData(REPOSITORY_TYPE_SAWMILL, REPOSITORY_ACTION_SAWMILL_WOOD, R_AMOUNT));
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
				}
			}
		}
	}
}

public: UpdateOilFactory()
{
	new add_fuels = (random(2500) + 500);
	new fuels = GetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT) + add_fuels;

	new time = (random(fuels <= 20_000 ? 1 : 180) + 60) * 1000;

	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT, fuels);
	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);

	SetTimer("UpdateOilFactory", time, false);
}

public: UpdateMinerRemelting()
{
	new remelting = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT);
	new ore = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT);
	new metall = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT);
	new rand;

	// берем с переплавки руду
	rand = random(90) + 11; // от 10 до 100;
	if(remelting > 0) // если на переплавке есть руда
	{
		if(rand > remelting) // если взяли больше чем было
			rand = remelting; // берем все что осталось

		remelting -= rand;

		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT, remelting); // забрали с переплавки
		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, metall + rand); // добавили на склад Материалы
	}

	// берем со склада руду
	rand = random(90) + 11; // от 10 до 100;
	if(remelting < 100) // если на пререплавке меньше 100 кг
	{
		if(rand > ore) // если взяли больше чем на складе
			rand = ore; // берем все что осталось

		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, ore - rand); // взяли со склада
		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT, remelting + rand); // добавили в переплавку
	}

	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI);

	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);

	SetTimer("UpdateMinerRemelting", (random(16)+15) * 1000, false);
}

stock SaveRepository(type = -1, actionid = -1)
{
	new fmt_str[128];

	if(type != -1 && actionid != -1)
	{
		format(fmt_str, sizeof fmt_str, "UPDATE repositories SET amount=%d WHERE type=%d AND action_id=%d LIMIT 1", GetRepositoryData(type, actionid, R_AMOUNT), type, actionid);
		mysql_query(mysql, fmt_str, false);
	}
					else
	{
		for(new idx, idx_2; idx < sizeof g_repository; idx ++)
		{
			for(idx_2 = 0; idx_2 < sizeof g_repository[]; idx_2 ++)
			{
				if(GetRepositoryData(idx, idx_2, R_NOT_SAVE)) continue;

				format(fmt_str, sizeof fmt_str, "UPDATE repositories SET amount=%d WHERE type=%d AND action_id=%d LIMIT 1", GetRepositoryData(idx, idx_2, R_AMOUNT), idx, idx_2);
				mysql_query(mysql, fmt_str, false);
			}
		}
	}
}

stock PreLoadPlayerAnimList(playerid)
{
	if(!GetPlayerData(playerid, P_ANIM_LIST_INIT))
	{
		PreLoadPlayerAnims(playerid);
		SetPlayerData(playerid, P_ANIM_LIST_INIT, true);

		return 1;
	}
	return 0;
}

stock SetPlayerAnimation(playerid, animid)
{
    //HideAnimTD(playerid);
    
    //CreateAnimTD(playerid);
    
    //CreateAnimTD(playerid);
    
	if(0 <= animid <= sizeof anim_list-1)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			switch(animid+1)
			{
				case 1..4:
				{
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1 + animid);
				}
				default:
				{
					new type = USE_ANIM_TYPE_NONE - 1;
					if(GetAnimListData(animid, AL_LOOP))
					{
						SetPlayerData(playerid, P_USE_ANIM, true);
						
						//CreateAnimTD(playerid);
					}
					else
					{
						if(IsPlayerUseAnim(playerid))
						{
							SetPlayerData(playerid, P_USE_ANIM, false);
							//HideAnimTD(playerid);
						}
						type = USE_ANIM_TYPE_NONE;
					}
					ApplyAnimationEx(playerid, GetAnimListData(animid, AL_LIB), GetAnimListData(animid, AL_NAME), GetAnimListData(animid, AL_DELTA), (GetAnimListData(animid, AL_LOOP) % 2), GetAnimListData(animid, AL_LOCK_X), GetAnimListData(animid, AL_LOCK_Y), GetAnimListData(animid, AL_FREEZE), GetAnimListData(animid, AL_TIME), 0, type);
				}
			}
		}
		return 1;
	}
	return 0;
}

stock ClearPlayerUseAnim(playerid)
{
    HideAnimTD(playerid);
    
	if(IsPlayerUseAnim(playerid))
	{
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);

		SetPlayerData(playerid, P_USE_ANIM, false);
		
		HideAnimTD(playerid);

		ClearPlayerAnim(playerid);
	}
}

stock IsValidMail(email[], len = sizeof email)
{
    new count[2];
    if(!(5 <= len <= 60)) return 0;
    for(new i; i != len; i++)
    {
		switch(email[i])
		{
			case '@':
			{
				count[0]++;
				if(count[0] != 1 || i == len - 1 || i == 0) return 0;
			}
			case '.':
			{
				if(count[0] == 1 && count[1] == 0 && i != len - 1)
				{
					count[1] = 1;
				}
			}
			case '0'..'9', 'a'..'z', 'A'..'Z', '_', '-':
			{
				continue;
			}
			default:
				return 0;
		}
    }
    if(count[1] == 0) return 0;
    return 1;
}

stock ShowPlayerRegDialog(playerid, step)
{
    #pragma unused step
    if(!IsPlayerConnected(playerid) || IsPlayerLogged(playerid)) return 0;
    if(g_BRAuthStage[playerid] != BR_AUTH_PASSWORD) return 0;
    return BRAuth_Open(playerid, false);
}

stock ShowServerRules(playerid, bool: reg = false)
{
	Dialog
	(
		playerid, reg ? DIALOG_REGISTER : DIALOG_PLAYER_STATS, DIALOG_STYLE_MSGBOX,
		"{66CCFF}Правила сервера",
		"{FFCD00}1. Основное\n"\
		"{FFFFFF}- Запрещено использовать любые читы или CLEO скрипты\n"\
		"- Запрещен DM -нанесение вреда игрокам без причины\n"\
		"- Запрещено убивать игроков на спавне\n"\
		"- Запрещены убийства путем наезда на него\n"\
		"- Запрещено уходить на паузу в целях спасения\n"\
		"- Запрещено использование возможностей сервера для создания помех\n\n"\
		"{FFCD00}2. Процесс общения\n"\
		"{FFFFFF}- Запрещено оскорбление игроков\n"\
		"- Запрещены угрозы вне игры\n"\
		"- Запрещено писать транслитом\n"\
		"- Запрещена любая реклама сторонних ресурсов\n"\
		"- Запрещено флудить\n\n"\
		"{FFCD00}3. Администрация\n"\
		"- Необходимо сообщать администрации сервера о нарушения данных правил\n"\
		"- Администрация самостоятельно выбирает штрафные санкции\n"\
		"- Санкции могут применяться сразу после нарушения или через время\n"\
		"- При неполадках, свяжитесь с администрацией",
		"Продолжить", "Отмена"
	);
}

stock GetPlayerHouseName(playerid)
{
	new name[32];
	new houseid = GetPlayerHouse(playerid);

	if(houseid != -1)
	{
		switch(GetPlayerData(playerid, P_HOUSE_TYPE))
		{
			case HOUSE_TYPE_HOME:
			{
				if(GetHouseData(houseid, H_ENTRACE) != -1)
				{
					format(name, sizeof name, "Подъезд %d (№%d на %d этаже)", GetHouseData(houseid, H_ENTRACE) + 1, GetHouseData(houseid, H_FLAT_ID) + 1, GetHouseData(houseid, H_FLAT_ID) / 4 + 1);
				}
					else format(name, sizeof name, "%s (№%d)", GetHouseData(houseid, H_NAME), houseid);
			}
			case HOUSE_TYPE_ROOM:
			{
				format(name, sizeof name, "В гостях (дом №%d)", houseid);
			}
			case HOUSE_TYPE_HOTEL:
			{
				format(name, sizeof name, "Гостиница (№%d на %d этаже)", (GetPlayerData(playerid, P_HOUSE_ROOM) % 12) + 1, (GetPlayerData(playerid, P_HOUSE_ROOM) / 12) + 1);
			}
		}
	}
					else name = "Бездомный";

	return name;
}

stock GetPlayerBizName(playerid)
{
	new name[32];
	new businessid = GetPlayerBusiness(playerid);

	if(businessid != -1)
	{
		format(name, sizeof name, "%s (№%d)", GetBusinessData(businessid, B_NAME),  businessid);
	}
					else name = "Нет";

	return name;
}

stock GetPlayerJobAndRankName(playerid)
{
	new team = GetPlayerTeamEx(playerid);
	new rang = GetPlayerJob(playerid);
	new fmt_rank[32];

	if(GetPlayerData(playerid, P_CASINO_JOB) == 1) format(fmt_rank, sizeof fmt_rank, "Крупье казино");
	else if(GetPlayerData(playerid, P_CASINO_JOB) == 2) format(fmt_rank, sizeof fmt_rank, "Менеджер казино");
	else if(TEAM_GOVERNMENT <= team <= TEAM_OPG_LYTKARINSKAYA)
	{
		if(!(1 <= rang <= 10)) rang = 1;
		format(fmt_rank, sizeof fmt_rank, rank_names[team - 1][rang - 1]);
	}
	else format(fmt_rank, sizeof fmt_rank, GetPlayerJobName(playerid));

	return fmt_rank;
}

stock IsTeamSubdivision(team)
{
	if(TEAM_DPS <= team <= TEAM_FBI)
	{
		return true;
	}
	return false;
}

stock GetPlayerSubdivisionName(playerid)
{
	new player_team = GetPlayerTeamEx(playerid);

	if(IsTeamSubdivision(player_team))
		return team_subdivision_name[player_team - 4];

	return team_subdivision_name[0];
}

stock GetPlayerTeamStats(playerid)
{
	new fmt_text[110];

	format(fmt_text, sizeof fmt_text, "Организация:\t\t\t%s\n", GetPlayerTeamName(playerid));

	if(IsTeamSubdivision(GetPlayerTeamEx(playerid)))
	{
	    format(fmt_text, sizeof fmt_text, "%sПодразделение:\t\t%s\n", fmt_text, GetPlayerSubdivisionName(playerid));
	}

	return fmt_text;
}

stock GetPlayerGameStatus(playerid)
{
	new status[16];

	switch(GetPlayerLevel(playerid))
	{
	    case 0: status = "Ошибка";
	    case 1: status = "Без статуса";
	    case 2..5: status = "Новичок";
	    case 6..9: status = "Развивающийся";
	    case 10..14: status = "Освоившийся";
	    case 15..19: status = "Опытный игрок";
	    case 20..29: status = "Активный игрок";
	    default: status = "Легендарный";
	}

	if(GetPlayerTeamEx(playerid) && (GetPlayerJob(playerid) == 10)) status = "Лидер";
	if(GetPlayerAdminEx(playerid) != 0) status = "Администратор";

	return status;
}

stock ShowPlayerStats(playerid, targetid = INVALID_PLAYER_ID)
{
    if(targetid == INVALID_PLAYER_ID) targetid = playerid;
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid))
        return 0;

    new fmt_str[2048], rank_value[8] = "-";

    if(1 <= GetPlayerTeamEx(targetid) < MAX_ORG)
    {
        new job = GetPlayerJob(targetid);
        if(1 <= job <= 10)
            valstr(rank_value, job);
        else
            rank_value = "1";
    }

    format(fmt_str, sizeof(fmt_str), "\
        {FFFFFF}Имя:\t\t\t\t{0099FF}%s\n\
        {FFFFFF}Уровень:\t\t\t%d\n\
        Очки опыта:\t\t\t%d из %d\n\
        Номер телефона:\t\t%d\n\
        На счету телефона:\t\t%d руб\n\
        Законопослушность:\t\t%d\n\
        Уровень розыска:\t\t%d\n\
        Уровень улучшений:\t\t%d\n\
        Сила:\t\t\t\t%d\n\
        Наркотики:\t\t\t%d\n\
        Патроны:\t\t\t%d\n\
        Материалы:\t\t\t%d\n\
        Пол:\t\t\t\t%s\n\
        %s:\t\t\t%s\n\n\
        %s\
        Работа / должность:\t\t%s\n\
        Ранг:\t\t\t\t%s\n\n\
        Проживание:\t\t\t%s\n\
        Бизнес:\t\t\t%s\n\
        Игровой статус:\t\t%s\n",
        GetPlayerNameEx(targetid),
        GetPlayerLevel(targetid),
        GetPlayerExp(targetid),
        GetExpToNextLevel(targetid),
        GetPlayerPhone(targetid),
        GetPlayerData(targetid, P_PHONE_BALANCE),
        GetPlayerData(targetid, P_LAW_ABIDING),
        GetPlayerSuspect(targetid),
        GetPlayerData(targetid, P_IMPROVEMENTS),
        GetPlayerData(targetid, P_POWER),
        GetPlayerData(targetid, P_DRUGS),
        GetPlayerData(targetid, P_AMMO),
        GetPlayerData(targetid, P_METALL),
        GetPlayerSexName(targetid),
        GetPlayerSex(targetid) ? "Замужем за" : "Женат на",
        GetPlayerData(targetid, P_WIFE_NAME),
        GetPlayerTeamStats(targetid),
        GetPlayerJobAndRankName(targetid),
        rank_value,
        GetPlayerHouseName(targetid),
        GetPlayerBizName(targetid),
        GetPlayerGameStatus(targetid)
    );

    printf("[ShowPlayerStats] Dialog opened by player %d for target %d", playerid, targetid);
    return Dialog(playerid, DIALOG_PLAYER_STATS, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME"{ffffff} | Статистика игрока", fmt_str, "Назад", "Закрыть");
}
stock ShowPlayerCMDSDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_LIST,
		"{00FFFF}"SERVER_NAME"{ffffff} | Список команд",
		""c_b"1. Транспорт\n"\
		"2. Общение\n"\
		"3. Дома\n"\
		"4. Бизнес и АЗС\n"\
		"5. Работы\n"\
		"6. Банды\n"\
		"7. Правительство\n"\
		"8. Армия\n"\
		"9. Полиция\n"\
		"10. СМИ\n"\
		"11. Больница\n"\
		"12. Лидеры\n"\
		"13. Общие",
		"Выбрать", "Назад"
	);
	return 1;
}

stock ShowPlayerSettings(playerid)
{
	static const
		chat_type_name[3][30] = {"{FF3333}Отключен", "{00CC00}Стандарт", "{0099FF}"SERVER_NAME};

	new s_info[256];
	format
	(
		s_info, sizeof s_info,
		"Основной чат\t\t%s\n"\
		"Чат организации\t%s\n"\
		"Ники над игроками\t%s\n"\
		"Ники в чате\t\t%s\n"\
		"ID игроков в чате\t%s\n"\
		"Управл. транспортом\t%s\n"\
		"Изменить место появления\n"\
		"{888888}[Сохранить настройки]",
		chat_type_name[GetPlayerSettingData(playerid, S_CHAT_TYPE)],
		GetPlayerSettingData(playerid, S_TEAM_CHAT) 	? ("{00CC00}Включен")  : ("{FF3333}Отключен"),
		GetPlayerSettingData(playerid, S_PLAYERS_NICK) 	? ("{00CC00}Включены") : ("{FF3333}Отключены"),
		GetPlayerSettingData(playerid, S_NICK_IN_CHAT) 	? ("{00CC00}Включены") : ("{FF3333}Отключены"),
		GetPlayerSettingData(playerid, S_ID_IN_CHAT) 	? ("{00CC00}Включены") : ("{FF3333}Отключены"),
		GetPlayerSettingData(playerid, S_VEH_CONTROL) 	? ("{00CC00}Клавиши и команды") : ("{FF9900}Только команды")
	);
	return Dialog(playerid, DIALOG_PLAYER_SETTINGS, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Личные настройки", s_info, "Вкл|Выкл", "Назад");
}

stock ShowPlayerSecuritySettings(playerid)
{
	Dialog
	(
		playerid, DIALOG_PLAYER_SECURITY_SETTINGS, DIALOG_STYLE_LIST,
		"{FFCD00}Настройки безопасности",
		"1. Информация о настройках\n"\
		"2. Мобильный телефон\n"\
		"3. 'Случайный' PIN-код\n"\
		"4. Google Authenticator\n"\
		"{00CC66}5. Изменить пароль\n"\
		"6. Изменить 'случайный' PIN-код\n"\
		"{0099FF}7. Статус безопасности\n"\
		"{999999}8. Подтвердить Email",
		"Выбрать", "Назад"
	);
}

stock ShowPlayerReportDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_REPORT, DIALOG_STYLE_INPUT,
		"{FFCD00}Связь с администрацией",
		"{FFFFFF}Вы собираетесь написать Администрации сервера\n\
		{FFFFFF}Перед тем как отправить сообщение\n\
		{FFFFFF}убедитесь, что один из пунктов помощи не дал Вам ответа на Ваш вопрос\n\
		{FF3300}Запрещено:\n\
		{FFFFFF}- флуд, сквернословие, оффтоп\n\
		{FFFFFF}- Выпрашивание игровых ценностей ('дать денег', 'дать лидерку', 'дать права')\n\
		{FFFFFF}- ложные сообщения о нарушении\n\n\
		{FF3300}За нарушение правил Администратор может:\n\
		{FFFFFF}- предупредить (warn)\n\
		{FFFFFF}- отключить от сервера (kick)\n\
		{FFFFFF}- лишить возможности писать (mute)\n\
		{FFFFFF}- заблокировать (ban)\n\n\
		{FFFFFF}Данные правила установлены для всех игроков {339966}RUSSIA-MOBILE.RU",
		"Отправить", "Назад"
	);
}

stock ShowPlayerChangeNameDialog(playerid)
{
    new title[128];
    format(title, sizeof(title), "{FF5252}"SERVER_NAME"{FFFFFF} | Изменение имени");
    
    Dialog
    (
        playerid, DIALOG_CHANGE_NAME, DIALOG_STYLE_INPUT,
        title,
        "{FFFFFF}Вы можете изменить имя своего персонажа, если оно не соответствует RP правилам\n"\
        "Во всех остальных случаях смена имени осуществляется в {6699FF}/menu > Дополнительно.\n\n"\
        "{FFFFFF}RP ник имеет формат Имя_Фамилия.\n"\
        "Например: Andrey_Ivanov, Nikolas_Ryan, Kate_Valente и т. п.\n\n"\
        "Введите новое имя в поле ниже. Допустимы только латинские символы:",
        "Изменить", "Закрыть"
    );
}

stock ShowPlayerImprovementsDialog(playerid)
{
	new fmt_str[67 + 1];
	new dest[((sizeof(fmt_str)-1) * (sizeof(g_player_improvements))) + 10 + 1];

	new str_numeric[14 + 1];
	new my_i_level = GetPlayerData(playerid, P_IMPROVEMENTS);

	for(new idx = 0; idx < sizeof g_player_improvements; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d. %s\t\t", idx + 1, GetPlayerImprovementInfo(idx, I_NAME));
		if(idx == 2)
			strcat(fmt_str, "\t");

		if(my_i_level > idx)
		{
			strins(fmt_str, "{FFCD00}", 0);
			strcat(fmt_str, "Активно\n");
			strcat(dest, fmt_str);

			continue;
		}
					else if(my_i_level < idx)
		{
			strins(fmt_str, "{FF3333}", 0);
		}
					else
		{
			strcat(fmt_str, "{00CC00}");
		}
		strcat(dest, fmt_str);
		valfmt(str_numeric, GetPlayerImprovementInfo(idx, I_PRICE));

		format(fmt_str, sizeof fmt_str, "требуется %d уровень и %s руб\n", GetPlayerImprovementInfo(idx, I_LEVEL), str_numeric);
		strcat(dest, fmt_str);
	}
	strcat(dest, "Информация");

	return Dialog(playerid, DIALOG_PLAYER_IMPROVEMENTS, DIALOG_STYLE_LIST, "{FFCD00}Улучшения", dest, "Выбрать", "Назад");
}

stock SendMessageToAdmins(message[], color, a_level = 1)
{
	if(a_level < 1)
		a_level = 1;

	new count;
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(GetPlayerAdminEx(playerid) < a_level) continue;

		SendClientMessage(playerid, color, message);
		count ++;
	}
	return count;
}

stock SendMessageToHelpers(const message[], color, h_level = 1)
{
	if(h_level < 1)
		h_level = 1;

	new count;
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(GetPlayerHelperEx(playerid) < h_level) continue;

		SendClientMessage(playerid, color, message);
		count ++;
	}
	return count;
}

stock SendMessageToTeam(team, const message[], color = -1, playerid = -1)
{
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(GetPlayerSettingData(i, S_TEAM_CHAT) == 0) continue;
		else if(GetPlayerTeamEx(i) != team) continue;
		else if(i == playerid) continue;

		SendClientMessage(i, color, message);
	}
	return 1;
}

stock SendMessageToPoliceTeam(const message[], color = -1, playerid = -1)
{
	SendMessageToTeam(TEAM_DPS, message, color, playerid);
	SendMessageToTeam(TEAM_PPS, message, color, playerid);
	SendMessageToTeam(TEAM_FBI, message, color, playerid);

	return 1;
}

stock SendMessageToGang(const message[], color = -1, playerid = -1)
{
	SendMessageToTeam(TEAM_OPG_ARZAMASKAYA, message, color, playerid);
	SendMessageToTeam(TEAM_OPG_BATYREVSKAYA, message, color, playerid);
	SendMessageToTeam(TEAM_OPG_LYTKARINSKAYA, message, color, playerid);

	return 1;
}

stock SendMessageToJob(to_job, const message[], color = -1, playerid = -1, bool: org_chat = false)
{
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(GetPlayerJob(i) != to_job) continue;
		else if(org_chat && !GetPlayerSettingData(i, S_TEAM_CHAT)) continue;
		else if(playerid == i) continue;

		SendClientMessage(i, color, message);
	}
	return 1;
}

stock HidePlayerDialog(playerid)
{
	return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, "NULL", "NULL", "NULL", "NULL");
}

stock Shuffle(array[], size = sizeof array)
{
	new
		index,
		rand,
		buffer;

	for(index = 0; index < size; index ++)
	{
		rand = random(size);
		buffer = array[index];

		array[index] = array[rand];
		array[rand] = buffer;
	}
}

