//>> Файл: bykranin_src/core/family/family_05.inc  (458 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: /makegun, /close, /tie, /untie, /capture, StartCapture, EndCapture
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:makegun(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_ARMY && !(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать это");

	extract params -> new weapon_id, weapon_ammo;

	if(!(1 <= weapon_id <= 7))
	{
		Dialog
		(
			playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
			"Доступное оружие",
			"{66CCCC}\
			ID\tНазвание\t\tМатериалы\n\n\
			{FFFFFF}1.\tSilenced 9mm\t\t3\n\
			2.\tDesert Eagle\t\t6\n\
			3.\tShotgun\t\t8\n\
			4.\tMP5\t\t\t9\n\
			5.\tAK47\t\t\t10\n\
			6.\tM4\t\t\t10\n\
			7.\tCountry Rifle\t\t11\n\n\
			Для добавления патронов к созданному оружию\n\
			необходимо держать его в руках\
			",
			"Закрыть", ""
		);

		SendClientMessage(playerid, 0xCECECEFF, "Используйте: /makegun [id оружия] [кол-во патронов]");

		return 1;
	}

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /makegun [id оружия] [кол-во патронов]");
	if(weapon_ammo <= 0) return SendClientMessage(playerid, 0xCECECEFF, "Неверное количество патронов");

	enum TEMP_GUN_INFO
	{
		GUN_ID,
		GUN_METAL,
		GUN_NAME[16]
	};

	new temp_gun[7][TEMP_GUN_INFO] =
	{
		{23, 3, 	"Silenced 9mm"},
		{24, 6, 	"Desert Eagle"},
		{25, 8, 	"Shotgun"},
		{29, 9, 	"MP5"},
		{30, 10, 	"AK47"},
		{31, 10, 	"M4"},
		{33, 11, 	"Country Rifle"}
	};

	if(weapon_id != GetPlayerWeapon(playerid) && GetPlayerData(playerid, P_METALL) < temp_gun[weapon_id-1][GUN_METAL])
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет нужного количества Материалыа");
	if(GetPlayerData(playerid, P_AMMO) < weapon_ammo)
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет нужного количества патронов");

	new fmt_text[128];

	if(GetPlayerWeapon(playerid) == temp_gun[weapon_id-1][GUN_ID])
	{
		format(fmt_text, sizeof fmt_text, "добавил к %s %d патронов", temp_gun[weapon_id-1][GUN_NAME], weapon_ammo);

		Action(playerid, fmt_text, _, false);
	}
					else
	{
		new w_id, w_ammo;

		for(new i; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, i, w_id, w_ammo);

			if(w_id == temp_gun[weapon_id-1][GUN_ID])
			{
				GivePlayerWeapon(playerid, w_id, -w_ammo);
				break;
			}
		}

		AddPlayerData(playerid, P_METALL, -, temp_gun[weapon_id-1][GUN_METAL]);
		UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

		format(fmt_text, sizeof fmt_text, "сделал %s из Материалыа и %d патронов", temp_gun[weapon_id-1][GUN_NAME], weapon_ammo);

		Action(playerid, fmt_text, _, false);
	}

	GivePlayerWeapon(playerid, temp_gun[weapon_id-1][GUN_ID], weapon_ammo);

	AddPlayerData(playerid, P_AMMO, -, weapon_ammo);
	UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

	return 1;
}

CMD:close(playerid, params[])
{
	if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать это");

	if(GetPlayerJob(playerid) < 8)
		return SendClientMessage(playerid, 0x999999FF, "Открывать или закрывать склад можно с 8-ого ранга");

	new repository = GetPlayerTeamEx(playerid) - TEAM_OPG_ARZAMASKAYA,
		fmt_text[70];

	SetGangRepositoryData(repository, GR_LOCK, GetGangRepositoryData(repository, GR_LOCK) ^ true);

	UpdateGangRepository(repository);

	format(fmt_text, sizeof fmt_text, "[Внимание] Склад был %s игроком %s[%d]",
	GetGangRepositoryData(repository, GR_LOCK) ? "открыт" : "закрыт", GetPlayerNameEx(playerid), playerid);

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, GetGangRepositoryData(repository, GR_LOCK) ? 0x66CC00FF : 0xFF6600FF);

	return 1;
}

CMD:tie(playerid, params[])
{
	if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать это");
		
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /tie [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");

	if(GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок уже связан/закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_CUFFED);
	//SetPlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND, 19418, A_OBJECT_BONE_RIGHT_HAND, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 0.891999, 1.00, 1.168);
	SetPlayerData(to_player, P_CUFFED, true);

	TogglePlayerControllable(to_player, false);

	new fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s связал %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

CMD:untie(playerid, params[])
{
	if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать это");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /untie [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не завязан");

	//if(GetPlayerData(to_player, P_FOLLOWED_BY) != INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xCECECEFF, "Перестаньте вести игрока за собой (/follow)");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_NONE);

	SetPlayerData(to_player, P_CUFFED, false);

	TogglePlayerControllable(to_player, true);

	new fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s развязал %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

CMD:capture(playerid, params[])
{
	if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA))
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать это");

	if(GetPlayerJob(playerid) < 6)
		return SendClientMessage(playerid, 0x999999FF, "Организовывать захват территории можно только с 6-ого ранга");

	if(g_capture[C_STATUS])
		return SendClientMessage(playerid, 0x999999FF, "Дождитесь окончания текущего захвата");

	new gang_id = (GetPlayerTeamEx(playerid) - TEAM_OPG_ARZAMASKAYA) + 1;

	if(g_capture[C_WAIT_TIME][gang_id - 1] > gettime())
		return SendClientMessage(playerid, 0x999999FF, "С момента последнего Вашего захвата еще не прошел 1 час");

	new gang_zone_id = -1;

	for(new idx; idx < g_gang_zones_loaded; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, GetGangZoneData(idx, GZ_AREA))) continue;

		gang_zone_id = idx;
		break;
	}

	if(gang_zone_id == -1)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на захваченной кем-то территории");

	new gang_zone_team = GetGangZoneData(gang_zone_id, GZ_GANG);

	if(!gang_zone_team)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на захваченной кем-то территории");

	if(gang_zone_team == gang_id)
		return SendClientMessage(playerid, 0x999999FF, "Вы не можете захватить свою территорию");

	if(g_capture[C_WAIT_TIME][gang_zone_team - 1] > gettime())
		return SendClientMessage(playerid, 0x999999FF, "Банда, чью территорию Вы хотите захватить, еще не окрепла с последнего захвата (не прошел 1 час)");

	new gang_players[2];

	foreach(new idx : Player)
	{
		if(GetPlayerTeamEx(idx) == GetPlayerTeamEx(playerid)) gang_players[0] ++;
		else if(GetPlayerTeamEx(idx) == (gang_zone_team - 1) + TEAM_OPG_ARZAMASKAYA) gang_players[1] ++;
		else continue;
	}

	if(gang_players[0] < MIN_PLAYERS_FOR_CAPTURE)
		return SendClientMessage(playerid, 0x999999FF, "В Вашей банде должно быть не менее 5-ти людей для захвата");

	if(gang_players[1] < MIN_PLAYERS_FOR_CAPTURE)
		return SendClientMessage(playerid, 0x999999FF, "В банде, территорию которой Вы хотите захватить, должно быть не менее 5-ти людей для захвата");

	StartCapture(playerid, gang_zone_id, gang_id, gang_zone_team);

	return 1;
}

stock StartCapture(playerid, gang_zone_id, attack_team, protect_team)
{
	// Time: 9:53~n~~w~Zhopa OPG__~r~~h~10~n~~w~Super-Analnaya OPG__~r~~h~5
	if(g_capture[C_STATUS]) return 0;

	new fmt_text[128],
		gps_icons[3] = {62, 61, 60};

	format(fmt_text, sizeof fmt_text, "%s начали захват территории у %s",
	GetTeamName( (attack_team + TEAM_OPG_ARZAMASKAYA) - 1), GetTeamName( (protect_team + TEAM_OPG_ARZAMASKAYA) - 1));

	SendMessageToGang(fmt_text, 0xFF5533FF);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] инициировал захват",
	GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0xFF5533FF);

	foreach(new idx : Player)
	{
		if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(idx) <= TEAM_OPG_LYTKARINSKAYA)) continue;

		TextDrawShowForPlayer(playerid, capture_TD[0]);
		TextDrawShowForPlayer(playerid, capture_TD[1]);

		format(fmt_text, sizeof fmt_text, "Место отмечено на GPS. Окажите сопротивление вражеской банде, чтобы %s территорию",
		GetPlayerTeamEx(idx) == ((attack_team + TEAM_OPG_ARZAMASKAYA) - 1) ? "захватить" : "сохранить свою");

		SendClientMessage(idx, 0xFFFF00FF, fmt_text);

		SetPlayerMapIcon
		(
			idx, 97,
			GetGangZoneData(gang_zone_id, GZ_MIN_X) + 50.0,
			GetGangZoneData(gang_zone_id, GZ_MIN_Y) + 50.0,
			0.0,
			gps_icons[ GetPlayerTeamEx(idx) - TEAM_OPG_ARZAMASKAYA ],
			0xFFFFFFFF,
			MAPICON_GLOBAL
		);
	}

	//GangZoneFlashForAll(GetGangZoneData(gang_zone_id, GZ_ZONE), gang_zone_colors[attack_team]);

	g_capture[C_STATUS] = true;

	g_capture[C_GANG_ZONE] = gang_zone_id;

	g_capture[C_ATTACK_TEAM] = attack_team;
	g_capture[C_PROTECT_TEAM] = protect_team;

	g_capture[C_ATTACKER_KILLS] = 0;
	g_capture[C_PROTECTOR_KILLS] = 0;

	g_capture[C_TIME] = 7 * 60;

	UpdateCaptureTextDraw();

	return 1;
}

stock EndCapture()
{
	if(!g_capture[C_STATUS]) return 0;

	new fmt_text[90],
		attack_team = (g_capture[C_ATTACK_TEAM] + TEAM_OPG_ARZAMASKAYA) - 1,
		protect_team = (g_capture[C_PROTECT_TEAM] + TEAM_OPG_ARZAMASKAYA) - 1;
		//gang_zone_id = g_capture[C_GANG_ZONE];

	if(g_capture[C_ATTACKER_KILLS] > g_capture[C_PROTECTOR_KILLS])
		format(fmt_text, sizeof fmt_text, "%s захватили территорию у %s", GetTeamName(attack_team), GetTeamName(protect_team));

	else
		format(fmt_text, sizeof fmt_text, "Попытка %s захватить территорию у %s провалилась", GetTeamName(attack_team), GetTeamName(protect_team));

	SendMessageToGang(fmt_text, 0xFF5533FF);

	//new gz_index = GetGangZoneData(gang_zone_id, GZ_ZONE);

	//GangZoneStopFlashForAll(gz_index);

	if(g_capture[C_ATTACKER_KILLS] > g_capture[C_PROTECTOR_KILLS])
	{
		//SetGangZoneData(gang_zone_id, GZ_GANG, g_capture[C_ATTACK_TEAM]);
		//SaveGangZone(gang_zone_id);

		//GangZoneShowForAll(gz_index, gang_zone_colors[ GetGangZoneData(gang_zone_id, GZ_GANG) ]);

		UpdateGangRepository(g_capture[C_ATTACK_TEAM] - 1);
		UpdateGangRepository(g_capture[C_PROTECT_TEAM] - 1);
	}

	TextDrawHideForAll(capture_TD[0]);
	TextDrawHideForAll(capture_TD[1]);

	g_capture[C_STATUS] = false;

	g_capture[C_GANG_ZONE] = -1;

	g_capture[C_ATTACK_TEAM] =
	g_capture[C_PROTECT_TEAM] = -1;

	g_capture[C_ATTACKER_KILLS] =
	g_capture[C_PROTECTOR_KILLS] = 0;

	g_capture[C_TIME] = 0;

	g_capture[C_WAIT_TIME][attack_team - 1] =
	g_capture[C_WAIT_TIME][protect_team - 1] = gettime() + 3600;

	foreach(new idx : Player)
		RemovePlayerMapIcon(idx, 97);

	return 1;
}

stock UpdateCaptureTextDraw()
{
	new fmt_text[128];

	format
	(
		fmt_text, sizeof fmt_text,
		"Время: %d:%02d~n~"\
		"~w~%s__~r~~h~%d~n~"\
		"~w~%s__~r~~h~%d",
		g_capture[C_TIME] / 60,
		g_capture[C_TIME] % 60,
		GetTeamName( (g_capture[C_ATTACK_TEAM] + TEAM_OPG_ARZAMASKAYA) - 1 ),
		g_capture[C_ATTACKER_KILLS],
		GetTeamName( (g_capture[C_PROTECT_TEAM] + TEAM_OPG_ARZAMASKAYA) - 1 ),
		g_capture[C_PROTECTOR_KILLS]
	);

	TextDrawSetString(capture_TD[1], fmt_text);

	foreach(new idx : Player)
	{
		if(!IsPlayerConnected(idx)) continue;
		if(!IsPlayerLogged(idx)) continue;
		if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(idx) <= TEAM_OPG_LYTKARINSKAYA)) continue;

		TextDrawShowForPlayer(idx, capture_TD[0]);
		TextDrawShowForPlayer(idx, capture_TD[1]);
	}
}

stock IsPlayerInPoliceTeam(playerid)
{
	if(TEAM_DPS <= GetPlayerTeamEx(playerid) <= TEAM_FBI) return true;
	return false;
}

stock IsPlayerInPoliceCar(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(VEHICLE_ACTION_TYPE_DPS_CAR <= GetVehicleData(vehicleid, V_ACTION_TYPE) <= VEHICLE_ACTION_TYPE_FBI_CAR) return true;
	if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_ORG_CAR &&
		GetVehicleData(vehicleid, V_ACTION_ID) == GetPlayerTeamEx(playerid) && IsPlayerInPoliceTeam(playerid)) return true;
	return false;
}

stock GenerateCarNumber()
{
	static const chars[11] = {'A', 'B', 'C', 'E', 'H', 'K', 'M', 'O', 'P', 'T', 'X'};
	new number[6];

	number[0] = chars[random(sizeof chars)];
	number[1] = random('9' - '0') + '0';
	number[2] = random('9' - '0') + '0';
	number[3] = random('9' - '0') + '0';

	if(number[1] == number[2] && number[2] == number[3] && number[3] == '0')
		number[3] = random('9' - '0') + '1';

	number[4] = chars[random(sizeof chars)];
	number[5] = chars[random(sizeof chars)];

	return number;
}

stock IsACarNumber(const text[])
{
	new length = strlen(text);

	if(length != 6)
	{
		return 0;
	}

	for(new i; i < length; i ++)
	{
		switch(i)
		{
			case 0, 4, 5:
			{
				switch(text[i])
				{
					case 'A'..'Z': continue;
					default: return 0;
				}
			}
			case 1..3:
			{
				switch(text[i])
				{
					case '0'..'9': continue;
					default: return 0;
				}
			}
		}
	}

	if(text[1] == text[2] && text[2] == text[3] && text[3] == '0')
	{
		return 0;
	}

	return 1;
}

