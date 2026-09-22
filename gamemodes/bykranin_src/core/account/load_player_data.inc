//>> Файл: bykranin_src/core/account/load_player_data.inc  (521 строк)
//>> Тема: аккаунт: вход, регистрация, пин-код, спавн
//>> Внутри: LoadPlayerData
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: LoadPlayerData(playerid)
{
	if(!IsPlayerConnected(playerid) || IsPlayerLogged(playerid) || !g_BRAuthVerified[playerid] || g_BRAuthStage[playerid] != BR_AUTH_LOADING) return 0;
	new query[138];
	new Cache: result;
	new account_id = GetPlayerAccountID(playerid);

	printf("[LoadPlayerData] START | playerid=%d account_id=%d", playerid, account_id);
	mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", account_id);
	result = mysql_query(mysql, query);

	new mysql_error_id = mysql_errno();
	if(mysql_error_id != 0)
	{
		printf("[LoadPlayerData] MYSQL ERROR %d | playerid=%d account_id=%d | query: %s", mysql_error_id, playerid, account_id, query);
		if(result) cache_delete(result);
		g_BRAuthStage[playerid] = BR_AUTH_BLOCKED;
		return BRAuth_Error(playerid, "LOAD", "Ошибка загрузки аккаунта. Переподключитесь.");
	}

	new rows = cache_num_rows(result);
	printf("[LoadPlayerData] QUERY OK | playerid=%d account_id=%d rows=%d", playerid, account_id, rows);

	if(rows)
	{
		new
			buffer = 0,
			time = gettime();

		cache_get_field_content(0, "email", g_player[playerid][P_EMAIL], mysql, 61);
		SetPlayerData(playerid, P_CONFIRM_EMAIL, bool: cache_get_field_content_int(0, "confirm_email"));

		SetPlayerData(playerid, P_LEVEL, 	cache_get_field_content_int(0, "level"));
		SetPlayerData(playerid, P_EXP, 		cache_get_field_content_int(0, "exp"));

		SetPlayerData(playerid, P_REFER, 	cache_get_field_content_int(0, "refer"));
		SetPlayerData(playerid, P_SEX, 		cache_get_field_content_int(0, "sex") ? 1 : 0);
		SetPlayerData(playerid, P_SKIN, 	cache_get_field_content_int(0, "skin"));
		printf("[AUTH][LOAD] player=%d account=%d sex=%d skin=%d", playerid, account_id, GetPlayerSex(playerid), GetPlayerData(playerid, P_SKIN));
		SetPlayerData(playerid, P_MONEY, 	cache_get_field_content_int(0, "money"));
		SetPlayerData(playerid, P_BANK, 	cache_get_field_content_int(0, "bank"));
		SetPlayerData(playerid, P_ADMIN, 	cache_get_field_content_int(0, "admin"));
		SetPlayerData(playerid, P_OHFAM,	cache_get_field_content_int(0, "ocfam"));
		SetPlayerData(playerid, P_OHZAVOD,	cache_get_field_content_int(0, "oczav"));
		SetPlayerData(playerid, P_OHARZ,	cache_get_field_content_int(0, "ocarz"));
		SetPlayerData(playerid, P_OHKAR,	cache_get_field_content_int(0, "ockar"));
		SetPlayerData(playerid, P_OHBUS,	cache_get_field_content_int(0, "ocbus"));
		SetPlayerData(playerid, P_SECRET, 	cache_get_field_content_int(0, "a_secret"));
		SetPlayerData(playerid, P_3D_PREFIX, 	cache_get_field_content_int(0, "3d_prefix"));
		SetPlayerData(playerid, P_ADMIN_NICK_COLOR, cache_get_field_content_int(0, "nick_color"));
		SetPlayerData(playerid, P_ADMIN_NICK_RAINBOW, cache_get_field_content_int(0, "nick_rainbow") ? 1 : 0);
		SetPlayerData(playerid, P_APASS, 	cache_get_field_content_int(0, "AdminPass"));
		
		

		cache_get_field_content(0, "cmdaccess", g_player[playerid][CMD_ACCESS], mysql, CMD_NUM+1);
		cache_get_field_content(0, "prefix", g_player[playerid][P_PREFIX], mysql, 16);
		SetPlayerData(playerid, P_PLAY_PLAYER, 	cache_get_field_content_int(0, "player"));

		SetPlayerData(playerid, P_DRIVING_LIC, 	cache_get_field_content_int(0, "driving_lic"));
		SetPlayerData(playerid, P_WEAPON_LIC, 	cache_get_field_content_int(0, "weapon_lic"));

		SetPlayerData(playerid, P_SUSPECT, 		cache_get_field_content_int(0, "suspect"));
		SetPlayerData(playerid, P_PHONE, 		cache_get_field_content_int(0, "phone"));
		SetPlayerData(playerid, P_PHONE_BALANCE,cache_get_field_content_int(0, "phone_balance"));
		SetPlayerData(playerid, P_PHONE_COLOR,	cache_get_field_content_int(0, "phone_color"));

		SetPlayerData(playerid, P_LAW_ABIDING,	cache_get_field_content_int(0, "law_abiding"));
		SetPlayerData(playerid, P_IMPROVEMENTS, cache_get_field_content_int(0, "improvements"));
		SetPlayerData(playerid, P_POWER, 		cache_get_field_content_int(0, "power"));

		SetPlayerData(playerid, P_DRUGS, 		cache_get_field_content_int(0, "drugs"));
		SetPlayerData(playerid, P_AMMO, 		cache_get_field_content_int(0, "ammo"));
		SetPlayerData(playerid, P_METALL, 		cache_get_field_content_int(0, "metall"));
		SetPlayerData(playerid, P_WIFE, 		cache_get_field_content_int(0, "wife"));
		SetPlayerData(playerid, P_TEAM, 		cache_get_field_content_int(0, "team"));
		SetPlayerData(playerid, P_SUBDIVISON,	cache_get_field_content_int(0, "subdivison"));
		SetPlayerData(playerid, P_WAGE,			cache_get_field_content_int(0, "wage"));
		new account_job_value = cache_get_field_content_int(0, "job");
		if(1 <= account_job_value <= 2) account_job_value = 0; // удалённые автобус и курьер
		SetPlayerData(playerid, P_JOB, account_job_value);

		SetPlayerData(playerid, P_LOADER_SKILL,		cache_get_field_content_int(0, "loader_skill"));

		SetPlayerData(playerid, P_HOUSE_TYPE,	cache_get_field_content_int(0, "house_type"));
		SetPlayerData(playerid, P_HOUSE_ROOM,	cache_get_field_content_int(0, "house_room"));
		SetPlayerData(playerid, P_HOUSE, 		cache_get_field_content_int(0, "house"));
		SetPlayerData(playerid, P_BUSINESS, cache_get_field_content_int(0, "business"));
		SetPlayerData(playerid, P_CASINO_JOB, cache_get_field_content_int(0, "casino_job"));
		SetPlayerData(playerid, P_CASINO_BUSINESS, cache_get_field_content_int(0, "casino_business"));
		SetPlayerData(playerid, P_FUEL_ST,		cache_get_field_content_int(0, "fuel_st"));
		SetPlayerData(playerid, P_ADMIN_WARN,		cache_get_field_content_int(0, "admin_warn"));
		SetPlayerData(playerid, P_ACOINS, 	cache_get_field_content_int(0, "acoins"));

		SetPlayerData(playerid, P_REG_TIME, 	cache_get_field_content_int(0, "reg_time"));
		cache_get_field_content(0, "reg_ip", g_player[playerid][P_REG_IP], mysql, 16);

		buffer = SetPlayerData(playerid, P_LAST_LOGIN_TIME,	cache_get_field_content_int(0, "last_login"));
		if(GetElapsedTime(time, buffer) < 1)
		{
			if(GetElapsedTime(time, g_last_pay_day_time) < 1)
				SetPlayerData(playerid, P_GAME_FOR_HOUR,	cache_get_field_content_int(0, "game_for_hour"));
		}
		SetPlayerData(playerid, P_GAME_FOR_DAY,			cache_get_field_content_int(0, "game_for_day"));
		SetPlayerData(playerid, P_GAME_FOR_DAY_PREV,	cache_get_field_content_int(0, "game_for_day_prev"));

		buffer = GetElapsedTime(time, buffer, CONVERT_TIME_TO_DAYS);
		if(buffer == 1)
		{
			SetPlayerData(playerid, P_GAME_FOR_DAY_PREV, GetPlayerData(playerid, P_GAME_FOR_DAY));
			SetPlayerData(playerid, P_GAME_FOR_DAY, 0);
		}
					else if(buffer > 1)
		{
			SetPlayerData(playerid, P_GAME_FOR_DAY, 0);
			SetPlayerData(playerid, P_GAME_FOR_DAY_PREV, 0);
		}

		SetPlayerSettingData(playerid, S_CHAT_TYPE, 	cache_get_field_content_int(0, "setting1"));
		SetPlayerSettingData(playerid, S_TEAM_CHAT, 	cache_get_field_content_int(0, "setting2"));
		SetPlayerSettingData(playerid, S_NICK_IN_CHAT, 	cache_get_field_content_int(0, "setting4"));
		SetPlayerSettingData(playerid, S_ID_IN_CHAT, 	cache_get_field_content_int(0, "setting5"));
		SetPlayerSettingData(playerid, S_VEH_CONTROL, 	cache_get_field_content_int(0, "setting6"));

		SetPlayerData(playerid, P_WARN, 				cache_get_field_content_int(0, "warn"));
		SetPlayerData(playerid, P_WARN_TIME,			cache_get_field_content_int(0, "warn_time"));
		SetPlayerData(playerid, P_MUTE, 				cache_get_field_content_int(0, "mute"));

		SetPlayerData(playerid, P_SKILL_COLT, 			cache_get_field_content_int(0, "skill_colt"));
		SetPlayerData(playerid, P_SKILL_SDPISTOL,		cache_get_field_content_int(0, "skill_sdpistol"));
		SetPlayerData(playerid, P_SKILL_DEAGLE, 		cache_get_field_content_int(0, "skill_deagle"));
		SetPlayerData(playerid, P_SKILL_SHOTGUN, 		cache_get_field_content_int(0, "skill_shotgun"));
		SetPlayerData(playerid, P_SKILL_MP5, 			cache_get_field_content_int(0, "skill_mp5"));
		SetPlayerData(playerid, P_SKILL_AK47, 			cache_get_field_content_int(0, "skill_ak47"));
		SetPlayerData(playerid, P_SKILL_M4, 			cache_get_field_content_int(0, "skill_m4"));
		SetPlayerData(playerid, P_SKILL_SNIPER_RIFLE, 	cache_get_field_content_int(0, "skill_sniper_rifle"));
		SetPlayerData(playerid, P_SKILL_SAWNOFF, 		cache_get_field_content_int(0, "skill_sawnoff"));
		SetPlayerData(playerid, P_SKILL_COMBAT_SG, 		cache_get_field_content_int(0, "skill_combat_sg"));
		SetPlayerData(playerid, P_SKILL_MICRO_UZI, 		cache_get_field_content_int(0, "skill_micro_uzi"));
		g_player_case[playerid][0] = EOS;
        g_player_case_bonus[playerid][0] = EOS;
        g_player_case_rewards[playerid][0] = EOS;
        g_player_case_rewards_bonus[playerid][0] = EOS;

        cache_get_field_content(0, "case", g_player_case[playerid], sizeof(g_player_case[]));
		cache_get_field_content(0, "case_bonus", g_player_case_bonus[playerid]);
		if (!IsValidCaseBonusStates(g_player_case_bonus[playerid]))
        {
            InitPlayerCaseBonusStates(g_player_case_bonus[playerid], sizeof(g_player_case_bonus[]));

	        new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
        }
		cache_get_field_content(0, "case_rewards", g_player_case_rewards[playerid]);
		cache_get_field_content(0, "case_bonus_rewards", g_player_case_rewards_bonus[playerid]);
		LoadPlayerCaseRewards(playerid);
		SetPlayerData(playerid, P_DONATE_RUB, 			cache_get_field_content_int(0, "rub"));
		SetPlayerData(playerid, P_DONATE_MONEY, 		cache_get_field_content_int(0, "donate_current"));
		SetPlayerData(playerid, P_DONATE_TOTAL, 		cache_get_field_content_int(0, "donate_total"));
		

		SetPlayerData(playerid, P_GIFTS,        		cache_get_field_content_int(0, "gifts"));

		SetPlayerData(playerid, P_OSKIN,		 		cache_get_field_content_int(0, "org_skin"));
		
		SetPlayerData(playerid, P_MEDKA,		cache_get_field_content_int(0, "med"));

		SetPlayerData(playerid, P_SPAWN,		 		cache_get_field_content_int(0, "setting_spawn"));

		SetPlayerData(playerid, P_HOSPITAL,				bool: cache_get_field_content_int(0, "hospital"));

		SetPlayerData(playerid, P_HEALTH,				cache_get_field_content_float(0, "health"));

		SetPlayerData(playerid, P_CAR_SLOTS,			cache_get_field_content_int(0, "car_slots"));
		if(GetPlayerCarSlots(playerid) < 20)
		{
			SetPlayerData(playerid, P_CAR_SLOTS, 20);
			UpdatePlayerDatabaseInt(playerid, "car_slots", 20);
		}
		SetPlayerData(playerid, P_HOUSE_SLOTS,			cache_get_field_content_int(0, "house_slots"));
		
		SetPlayerData(playerid, P_BUSS_SLOTS,			cache_get_field_content_int(0, "buss_slots"));
		
		SetPlayerData(playerid, P_HOUSE_SELECTED,			cache_get_field_content_int(0, "house_selected"));
		SetPlayerData(playerid, P_JAIL,					cache_get_field_content_int(0, "jail"));
		FsinFull_LoadAccountFromCurrentCache(playerid);

		SetPlayerData(playerid, P_PREMIUM,				cache_get_field_content_int(0, "premium"));
		SetPlayerData(playerid, P_PREMIUM_DATE,				cache_get_field_content_int(0, "premium_date"));

		SetPlayerData(playerid, P_PREMIUM,				cache_get_field_content_int(0, "premium"));
		SetPlayerData(playerid, P_PREMIUM_TIME,			cache_get_field_content_int(0, "premium_time"));
		SetPlayerData(playerid, P_PREMIUM_CHAT,		IsPlayerVipActive(playerid));

		SetPlayerData(playerid, P_FAMILY,               cache_get_field_content_int(0, "family"));
        SetPlayerData(playerid, P_FAMILY_RANK,          cache_get_field_content_int(0, "family_rank"));

        SetPlayerData(playerid, P_TEST,          cache_get_field_content_int(0, "test"));

        SetPlayerData(playerid, P_QUEST_1,        		cache_get_field_content_int(0, "quest_1"));
        SetPlayerData(playerid, P_QUEST_2,        		cache_get_field_content_int(0, "quest_2"));
        SetPlayerData(playerid, P_QUEST_3,        		cache_get_field_content_int(0, "quest_3"));
        SetPlayerData(playerid, P_QUEST_4,        		cache_get_field_content_int(0, "quest_4"));
        SetPlayerData(playerid, P_QUEST_5,        		cache_get_field_content_int(0, "quest_5"));
        SetPlayerData(playerid, P_QUEST_6,        		cache_get_field_content_int(0, "quest_6"));
        SetPlayerData(playerid, P_QUEST_7,        		cache_get_field_content_int(0, "quest_7"));
        SetPlayerData(playerid, P_QUEST_8,        		cache_get_field_content_int(0, "quest_8"));

        SetPlayerData(playerid, P_QUEST_EXP_1,        		cache_get_field_content_int(0, "quest_exp_1"));
        SetPlayerData(playerid, P_QUEST_EXP_2,        		cache_get_field_content_int(0, "quest_exp_2"));
        SetPlayerData(playerid, P_QUEST_EXP_3,        		cache_get_field_content_int(0, "quest_exp_3"));
        SetPlayerData(playerid, P_QUEST_EXP_4,        		cache_get_field_content_int(0, "quest_exp_4"));
        SetPlayerData(playerid, P_QUEST_EXP_5,        		cache_get_field_content_int(0, "quest_exp_5"));
        SetPlayerData(playerid, P_QUEST_EXP_6,        		cache_get_field_content_int(0, "quest_exp_6"));
        SetPlayerData(playerid, P_QUEST_EXP_7,        		cache_get_field_content_int(0, "quest_exp_7"));
        SetPlayerData(playerid, P_QUEST_EXP_8,        		cache_get_field_content_int(0, "quest_exp_8"));

        SetPlayerData(playerid, P_YOUTUBE,        		cache_get_field_content_int(0, "youtube"));

        SetPlayerData(playerid, P_BANIHOP,        		cache_get_field_content_int(0, "AntiBh"));

        SetPlayerData(playerid, P_ADMIN_HOUR,        		cache_get_field_content_int(0, "get_adm_hour"));
        SetPlayerData(playerid, P_ADMIN_STATUS,        		cache_get_field_content_int(0, "get_adm_status"));

        SetPlayerData(playerid, P_ANTISLIV,        		cache_get_field_content_int(0, "antisliv"));
        
        SetPlayerData(playerid, P_QUEST231,        		cache_get_field_content_int(0, "quest231"));
        SetPlayerData(playerid, P_QUEST232,        		cache_get_field_content_int(0, "quest232"));
        SetPlayerData(playerid, P_REPCARID,        		cache_get_field_content_int(0, "repcarid"));
        SetPlayerData(playerid, P_BOXQUEST,             cache_get_field_content_int(0, "QuestBox"));
        SetPlayerData(playerid, P_QUEST233,        		cache_get_field_content_int(0, "quest233"));
        SetPlayerData(playerid, P_POSTCARD,        		cache_get_field_content_int(0, "postcard"));
        
        SetPlayerData(playerid, P_TOTALHOUR,        		cache_get_field_content_int(0, "totalhour"));
        
        SetPlayerData(playerid, P_HELPER, 	cache_get_field_content_int(0, "helper"));
        SetPlayerData(playerid, P_MED_CHEST, 	cache_get_field_content_int(0, "healme"));
        
        SetPlayerData(playerid, P_BOX_QUEST_1, 	cache_get_field_content_int(0, "QuestBox1"));
        SetPlayerData(playerid, P_BOX_QUEST_2, 	cache_get_field_content_int(0, "QuestBox2"));
        SetPlayerData(playerid, P_BOX_QUEST_3, 	cache_get_field_content_int(0, "QuestBox3"));
        SetPlayerData(playerid, P_BOX_QUEST_4, 	cache_get_field_content_int(0, "QuestBox4"));
        SetPlayerData(playerid, P_BOX_QUEST_5, 	cache_get_field_content_int(0, "QuestBox5"));
        SetPlayerData(playerid, P_BOX_QUEST_6, 	cache_get_field_content_int(0, "QuestBox6"));
        
        SetPlayerData(playerid, P_REPCARID, 	cache_get_field_content_int(0, "repair"));
        
        SetPlayerData(playerid, P_FMUTE, 				cache_get_field_content_int(0, "fmute"));
        SetPlayerData(playerid, P_FWARN, 				cache_get_field_content_int(0, "fwarn"));
        
        SetPlayerData(playerid, P_OWARN, 				cache_get_field_content_int(0, "owarn"));
        
        SetPlayerData(playerid, P_DMZ_KILL, 			cache_get_field_content_int(0, "dmz_kills"));
        
        SetPlayerData(playerid, P_PROGRESS_1,        		cache_get_field_content_int(0, "Progress1"));
        SetPlayerData(playerid, P_PROGRESS_2,        		cache_get_field_content_int(0, "Progress2"));
        SetPlayerData(playerid, P_PROGRESS_3,        		cache_get_field_content_int(0, "Progress3"));
        SetPlayerData(playerid, P_PROGRESS_4,        		cache_get_field_content_int(0, "Progress4"));
        SetPlayerData(playerid, P_PROGRESS_5,        		cache_get_field_content_int(0, "Progress5"));
        SetPlayerData(playerid, P_PROGRESS_6,        		cache_get_field_content_int(0, "Progress6"));
        SetPlayerData(playerid, P_PROGRESS_EXP_1,        		cache_get_field_content_int(0, "ProgressExp1"));
        SetPlayerData(playerid, P_PROGRESS_EXP_2,        		cache_get_field_content_int(0, "ProgressExp2"));
        SetPlayerData(playerid, P_PROGRESS_EXP_3,        		cache_get_field_content_int(0, "ProgressExp3"));
        SetPlayerData(playerid, P_PROGRESS_EXP_4,        		cache_get_field_content_int(0, "ProgressExp4"));
        SetPlayerData(playerid, P_PROGRESS_EXP_5,        		cache_get_field_content_int(0, "ProgressExp5"));
        SetPlayerData(playerid, P_PROGRESS_EXP_6,        		cache_get_field_content_int(0, "ProgressExp6"));
        
        SetPlayerData(playerid, P_CAPT_KILL, 			cache_get_field_content_int(0, "capt_kills"));
        
        
        SetPlayerData(playerid, P_COINS, 			cache_get_field_content_int(0, "coins"));
        SetPlayerData(playerid, P_MONETI, 			cache_get_field_content_int(0, "moneti"));
        SetPlayerData(playerid, P_FAMILY_NOTIF_SEEN, 			cache_get_field_content_int(0, "family_notif_seen"));
        SetPlayerData(playerid, P_FAMILY_NOTIF_SEEN_FAMILY, 	cache_get_field_content_int(0, "family_notif_seen_family"));
        
        SetPlayerData(playerid, P_YTPROMO_ACTIVATE,         cache_get_field_content_int(0, "ytpromo_activate"));
        
        SetPlayerData(playerid, P_F_QUEST_EXP_1,        		cache_get_field_content_int(0, "FracQuestExp1"));
        SetPlayerData(playerid, P_F_QUEST_EXP_2,        		cache_get_field_content_int(0, "FracQuestExp2"));
        SetPlayerData(playerid, P_F_QUEST_EXP_3,        		cache_get_field_content_int(0, "FracQuestExp3"));
        SetPlayerData(playerid, P_F_QUEST_EXP_4,        		cache_get_field_content_int(0, "FracQuestExp4"));
        SetPlayerData(playerid, P_F_QUEST_EXP_5,        		cache_get_field_content_int(0, "FracQuestExp5"));
        
        SetPlayerData(playerid, P_F_QUEST_1,        		cache_get_field_content_int(0, "FracQuest1"));
        SetPlayerData(playerid, P_F_QUEST_2,        		cache_get_field_content_int(0, "FracQuest2"));
        SetPlayerData(playerid, P_F_QUEST_3,        		cache_get_field_content_int(0, "FracQuest3"));
        SetPlayerData(playerid, P_F_QUEST_4,        		cache_get_field_content_int(0, "FracQuest4"));
        SetPlayerData(playerid, P_F_QUEST_5,        		cache_get_field_content_int(0, "FracQuest5"));
        
        SetPlayerData(playerid, P_TOP_1,        		cache_get_field_content_int(0, "TOP_SalaryNewWork"));
        SetPlayerData(playerid, P_TOP_2,        		cache_get_field_content_int(0, "TOP_SalaryGosWork"));
        SetPlayerData(playerid, P_TOP_3,        		cache_get_field_content_int(0, "TOP_PayDay"));
        SetPlayerData(playerid, P_TOP_4,        		cache_get_field_content_int(0, "TOP_Progress"));
        SetPlayerData(playerid, P_TOP_5,        		cache_get_field_content_int(0, "TOP_Quest"));
        
        SetPlayerData(playerid, P_BOOMBOX,        		cache_get_field_content_int(0, "boombox"));
        
        SetPlayerData(playerid, P_SPEEDOMETR, 			cache_get_field_content_int(0, "speedometr"));
        
        SetPlayerData(playerid, P_FRACTION_CAR,        		INVALID_VEHICLE_ID);
		SetPlayerData(playerid, P_OWNABLE_CAR,            INVALID_VEHICLE_ID);
        SetPlayerData(playerid, P_BUY_CAR, INVALID_VEHICLE_ID);

		// -------------------------------------------------------------------------
		cache_delete(result);
		GarageSys_SyncPlayer(playerid);
		if(!GetPlayerData(playerid, P_SKIN))
		{
			g_BRAuthStage[playerid] = BR_AUTH_SEX;
			SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REGISTER);
			BRAuth_Open(playerid, false);
			new Node:resume_auth = JSON_Object();
			JSON_SetInt(resume_auth, "t", 3);
			OnPacketIncoming(playerid, 38, resume_auth);
			JSON_Cleanup(resume_auth);
			printf("[AUTH][RESUME_SKIN] player=%d account=%d", playerid, account_id);
			return 1;
		}
		printf("[ACS][AUTH] Trigger from LoadPlayerData: player=%d account_id=%d", playerid, GetPlayerAccountID(playerid));
		LoadAccessory(playerid);
		Blogger_OnPlayerLogin(playerid);


       
		//SetPlayerSpawnInit(playerid);
		//SpawnPlayer(playerid);
		
		//MessageInSpawn(playerid);

		new
			JSON:json_spawn = JSON_Object(),
			JSON:json_spawn_array = JSON_Array(),
			outcoming_data[256];

		json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(1)));

		if(HasRecentSpawnState(GetPlayerAccountID(playerid)))
		{
			json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(2)));
		}

		if(GetHouseNewByOwner(GetPlayerAccountID(playerid), playerid) != -1)
		{
			json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(4)));
		}
		if(GetFlatNewByOwner(GetPlayerAccountID(playerid), playerid) != -1)
		{
			json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(4)));
		}
		if(GetPlayerIdFamily(playerid) != -1 && GetFamily(GetPlayerIdFamily(playerid), family_house) != -1)
		{
			json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(6)));
		}
		if (GetPlayerTeamEx(playerid))
		{
			json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(0)));
		}


		JSON_SetArray(json_spawn, "m", json_spawn_array);

        // V11 hospital intermittent fix: a player who reconnects with hospital=1
        // must never receive the ordinary spawn selector. A late GUI response
        // can overwrite Interior/VW after the hospital timers and leave the
        // mobile client at hospital coordinates in an empty world.
        if(GetPlayerData(playerid, P_HOSPITAL))
        {
            new hospital_token = GetPVarInt(playerid, "hospital_spawn_token") + 1;
            if(hospital_token <= 0) hospital_token = 1;
            SetPVarInt(playerid, "hospital_spawn_token", hospital_token);
            SetPVarInt(playerid, "hospital_spawn_state", 0);
            DeletePVar(playerid, "hospital_spawn_room");

            // SetPlayerInit() (which marks the player logged in) runs below.
            // Defer SpawnPlayer until after that point so OnPlayerSpawn can
            // safely execute the hospital path.
            SetPVarInt(playerid, "hospital_login_autospawn", 1);
        }
        else
        {
            DeletePVar(playerid, "spawn_select_once");
            DeletePVar(playerid, "spawn_select_id");
            DeletePVar(playerid, "spawn_select_int");
            DeletePVar(playerid, "spawn_select_vw");
            g_spawn_request_block_tick[playerid] = 0;
            ShowPlayerGUI(playerid, 50, json_spawn);
        }


		if(GetPlayerData(playerid, P_SKIN))
		{
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET last_ip='%e',last_login=%d, online = 1 WHERE id=%d LIMIT 1", GetPlayerIpEx(playerid), time, GetPlayerAccountID(playerid));
			mysql_tquery(mysql, query, "", "");

			/*format(query, sizeof query, "~y~Добро Пожаловать ~n~~b~%s", GetPlayerNameEx(playerid));
			GameTextForPlayer(playerid, query, 3000, 1);*/

			if(IsPlayerHasDonations(playerid))
				SendClientMessage(playerid, 0x3399FFFF, "У Вас есть новые пополнения счёта. Введите {ff9900}/donat{3399ff}, чтобы зачислить их");

            new player_premium = GetPlayerData(playerid, P_PREMIUM_DATE);

			if(player_premium)
			{
				if((player_premium - time) > 0)
				{
				    new premium_day,
				        premium_month,
				        premium_year;

					timestamp_to_date(player_premium, premium_year, premium_month, premium_day);
				}
					else
				{
				    format(query, sizeof query, "Срок действия VIP статуса истёк. Для продления подписки используйте: {FFFFFF}/mn > Дополнительно");
					SendClientMessage(playerid, 0xEC174FFF, query);

					SetPlayerData(playerid, P_PREMIUM, 					0);

					UpdatePlayerDatabaseInt(playerid, "premium", 		0);
				}
			}

			if(GetPlayerData(playerid, P_WARN) > 0)
			{
				if(time > GetPlayerData(playerid, P_WARN_TIME))
				{
					SetPlayerData(playerid, P_WARN, 0);
					SetPlayerData(playerid, P_WARN_TIME, 0);
				}
					else
				{
					format(query, sizeof query, "Количество предупреждений: %d из 3", GetPlayerData(playerid, P_WARN));
					SendClientMessage(playerid, 0xFF6600FF, query);
					SendClientMessage(playerid, 0xFF6600FF, "После 3 предупреждения аккаунт будет заблокирован");
				}
			}

		/*	if(!GetPlayerData(playerid, P_CONFIRM_EMAIL))
			{
				SendClientMessage(playerid, 0xFFA040FF, "При регистрации Вы указали Email, но не подтвердили его");
				SendClientMessage(playerid, 0xFFA040FF, "Вы можете сделать это прямо сейчас, через /menu > Настройки безопасности");
				SendClientMessage(playerid, 0xFFA040FF, "Без подтверждения Email восстановить доступ к аккаунту будет невозможно");
			}
			*/
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOME)) != -1)
			{
				if(GetElapsedTime(GetHouseData(buffer, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "Срок оплаты Вашего дома скоро заканчивается");
				}
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL)) != -1)
			{
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);
				if(GetElapsedTime(GetHotelData(buffer, room_id, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "У Вас осталось мало оплаченных дней в гостинице");
				}
			}
			if((buffer = GetPlayerBusiness(playerid)) != -1)
			{
				if(GetElapsedTime(GetBusinessData(buffer, B_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "Срок аренды Вашего бизнеса скоро заканчивается");
				}
			}
			if((buffer = GetPlayerFuelStation(playerid)) != -1)
			{
				if(GetElapsedTime(GetFuelStationData(buffer, FS_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "Срок аренды Вашей АЗС скоро заканчивается");
				}
			}
			SetPlayerInit(playerid);

            if(GetPVarInt(playerid, "hospital_login_autospawn") == 1)
            {
                DeletePVar(playerid, "hospital_login_autospawn");
                SetPlayerHospitalSpawnInit(playerid);
                SpawnPlayer(playerid);

                // Some mobile clients finish auth but stay visually outside the
                // hospital/without a spawned ped. Recheck the hospital session
                // independently of OnPlayerSpawn and recover the same room.
                SetTimerEx("HospitalLoginSpawnGuard", 1800, false, "iiii",
                    playerid,
                    GetPVarInt(playerid, "hospital_spawn_token"),
                    mysql_race[playerid],
                    1);
            }

			g_BRAuthStage[playerid] = BR_AUTH_DONE;
			printf("[AUTH][SUCCESS] player=%d account=%d new=%d sex=%d skin=%d", playerid, account_id, g_BRAuthNewAccount[playerid], GetPlayerSex(playerid), GetPlayerData(playerid, P_SKIN));
			if(g_BRAuthNewAccount[playerid])
			{
				SendClientMessage(playerid, 0x66CC00FF, "Регистрация завершена. Стартовые бонусы и лицензии начислены.");
				g_BRAuthNewAccount[playerid] = false;
			}

			//SetTimerEx("PlayerOwnableCarInit", 250, false, "i", playerid);

			//CallLocalFunction("PlayerOwnableCarInit", "i", playerid);
		}
					else
		{
			SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);
			SendClientMessage(playerid, 0xFFFFFFFF, "Регестрация завершена!");
			SendClientMessage(playerid, 0x66CC00FF, "Выберите внешность Вашего персонажа");
		}
	}
					else
	{
		printf("[LoadPlayerData] ACCOUNT NOT FOUND | playerid=%d account_id=%d", playerid, account_id);
		if(result) cache_delete(result);
		g_BRAuthStage[playerid] = BR_AUTH_BLOCKED;
		return BRAuth_Error(playerid, "LOAD_EMPTY", "Аккаунт не найден. Переподключитесь.");
	}
	return 1;
}

