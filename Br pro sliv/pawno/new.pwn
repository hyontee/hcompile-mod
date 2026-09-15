// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

CMD:astart(playerid)
{
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new Float:veh_hp = GetVehicleData(vehicleid, V_HEALTH);
    	if(veh_hp <= 270.0) 
		{
        	ShowNotificationSile(playerid, 2, 5, 0, 0, "Двигатель в транспорте неисправен.", " ");
        	return 1;
    	}
    	if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
        	return ShowNotificationSile(playerid, 2, 5, -1, -1, "В Вашем транспорте нет бензина.", "");

		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicleid, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z))
		{
			ShowNotificationSile(playerid, 2, 5, 0, 0, "Вы находитесь слишком далеко от своего транспорта!", " ");
			return 1;
		}

    	new engine = GetVehicleParam(vehicleid, V_ENGINE) ^ 1;
    	SetVehicleParam(vehicleid, V_ENGINE, engine);

		new lights = (GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_LIGHTS, lights);
		
		if(engine == VEHICLE_PARAM_OFF && lights == VEHICLE_PARAM_OFF)
		{
			ShowNotificationSile(playerid, 1, 5, -1, -1, "Вы заглушили транспорт", "");
			SendClientMessage(playerid, -1, "Для включения двигателя используйте команду /astart");
			
			if(astartactive[playerid])
			{
				KillTimer(astarttimer[playerid]);
				astartactive[playerid] = false;
			}
		}
		else
		{
			ShowNotificationSile(playerid, 1, 5, -1, -1, "Вы успешно запустили транспорт", "");
			SendClientMessage(playerid, -1, "Для выключения двигателя используйте команду /astart");
			
			if(astartactive[playerid])
			{
				KillTimer(astarttimer[playerid]);
			}
			astarttimer[playerid] = SetTimerEx("AutoTurnOffEngine", 600000, false, "i", playerid);
			astartactive[playerid] = true;
			
			SendClientMessage(playerid, 0xFF9900FF, "Если вы не сядете в транспорт в течение 10 минут, двигатель автоматически заглушится!");
		}
	}
	else
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}
}

forward AutoOffEngine(playerid);
public AutoOffEngine(playerid)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 1;
	
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
		return 1;
	
	if(IsPlayerInVehicle(playerid, vehicleid))
	{
		astartactive[playerid] = false;
		SendClientMessage(playerid, -1, "Вы сели в транспорт, автоматическое глушение отменено!");
		return 1;
	}
	
	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	
	if(!IsPlayerInRangeOfPoint(playerid, 150.0, x, y, z))
	{
		SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
		SetVehicleParam(vehicleid, V_LIGHTS, VEHICLE_PARAM_OFF);
		astartactive[playerid] = false;
		
		ShowNotificationSile(playerid, 2, 5, -1, -1, "Транспорт заглушен из-за длительного бездействия!", "");
		SendClientMessage(playerid, -1, "Вы отошли от транспорта. Двигатель автоматически заглушен.");
		
		return 1;
	}
	
	SendClientMessage(playerid, -1, "Транспорт будет заглушен через 10 минут, если вы не сядете в него!");
	astarttimer[playerid] = SetTimerEx("AutoOffEngine", 600000, false, "i", playerid);
	
	return 1;
}

#define BLACKPASS_SEASON_NUMBER         28
#define BLACKPASS_SEASON_NAME           "осрэ й гмюмхъл"
#define BLACKPASS_MAX_LEVELS            75
#define BLACKPASS_DEFAULT_PREMIUM_PRICE 790
#define BLACKPASS_DEFAULT_DELUXE_PRICE  1690
#define BLACKPASS_SEASON_DAYS           42
#define BLACKPASS_LEVEL_EXP             1000
#define BLACKPASS_LEVEL_PRICE           150
#define BLACKPASS_STATUS_NONE           0
#define BLACKPASS_STATUS_PREMIUM        1
#define BLACKPASS_STATUS_DELUXE         2

enum E_BLACKPASS_PLAYER_DATA
{
    bool:BP_DATA_LOADED,
    BP_ACCOUNT_ID,
    BP_EXPERIENCE,
    BP_LEVEL,
    BP_PREMIUM_STATUS,
    BP_DUST,
    BP_SELECTED_LAYOUT,
    bool:BP_DELUXE_REWARDS_CLAIMED
};

new g_blackpass_player[MAX_PLAYERS][E_BLACKPASS_PLAYER_DATA];
new bool:g_blackpass_claimed_standard[MAX_PLAYERS][BLACKPASS_MAX_LEVELS + 1];
new bool:g_blackpass_claimed_premium[MAX_PLAYERS][BLACKPASS_MAX_LEVELS + 1];

#define BLACKPASS_TASK_SLOT_COUNT        11
#define BLACKPASS_TASK_DEF_COUNT         15
#define BLACKPASS_DAILY_TASK_COUNT       6
#define BLACKPASS_WEEKLY_TASK_COUNT      5
#define BLACKPASS_TASK_GROUP_DAILY       1
#define BLACKPASS_TASK_GROUP_WEEKLY      2
#define BLACKPASS_TASK_STATUS_REWARD     1
#define BLACKPASS_TASK_STATUS_PREMIUM    2
#define BLACKPASS_TASK_STATUS_TRACKED    3
#define BLACKPASS_TASK_STATUS_GO_TO      4
#define BLACKPASS_TASK_STATUS_LOCKED     5
#define BLACKPASS_TASK_STATUS_CLAIMED    6
#define BLACKPASS_TASK_GUI_READY         65
#define BLACKPASS_EXCHANGE_COST          10

enum E_BLACKPASS_TASK_DEF
{
    BP_TASK_DEF_ID,
    BP_TASK_DEF_GROUP,
    BP_TASK_DEF_TARGET,
    BP_TASK_DEF_EXP_REWARD,
    BP_TASK_DEF_MONEY_REWARD,
    BP_TASK_DEF_ROUTE_ID,
    BP_TASK_DEF_BUTTON_TYPE,
    BP_TASK_DEF_LEVEL,
    bool:BP_TASK_DEF_PREMIUM_ONLY
};

new const g_blackpass_task_defs[BLACKPASS_TASK_DEF_COUNT][E_BLACKPASS_TASK_DEF] =
{
    {254, BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000,   0, 1, 1, false},
    {52,  BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000,   0, 6, 1, false},
    {124, BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000,   0, 6, 1, false},
    {108, BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000, 126, 6, 1, false},
    {96,  BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000,  32, 6, 2, false},
    {97,  BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000, 157, 6, 1, false},
    {99,  BLACKPASS_TASK_GROUP_WEEKLY, 15000, 800, 5000, 144, 1, 1, false},
    {256, BLACKPASS_TASK_GROUP_WEEKLY, 8, 800, 5000,  49, 6, 1, false},
    {257, BLACKPASS_TASK_GROUP_WEEKLY, 100000, 800, 5000, 0, 6, 1, false},
    {6,   BLACKPASS_TASK_GROUP_WEEKLY, 1, 800, 5000,  69, 1, 1, false},
    {255, BLACKPASS_TASK_GROUP_WEEKLY, 5, 800, 5000,   0, 4, 1, false},
    {143, BLACKPASS_TASK_GROUP_WEEKLY, 2, 800, 5000,   0, 1, 1, false},
    {104, BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000, 147, 6, 2, false},
    {2,   BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000, 144, 1, 1, false},
    {4,   BLACKPASS_TASK_GROUP_DAILY, 1, 200, 1000,  49, 1, 1, false}
};

new const g_blackpass_default_task_ids[BLACKPASS_TASK_SLOT_COUNT] =
{
    254,
    52,
    124,
    108,
    96,
    97,
    99,
    256,
    257,
    6,
    255
};

enum E_BLACKPASS_TASK_DATA
{
    BP_TASK_ROW_ID,
    BP_TASK_ID,
    BP_TASK_GROUP,
    BP_TASK_PERIOD_KEY,
    BP_TASK_PROGRESS,
    BP_TASK_STORED_STATUS,
    bool:BP_TASK_TRACKED,
    bool:BP_TASK_COMPLETE_NOTIFIED
};

new g_blackpass_tasks[MAX_PLAYERS][BLACKPASS_TASK_SLOT_COUNT][E_BLACKPASS_TASK_DATA];
new bool:g_blackpass_tasks_loaded[MAX_PLAYERS];
new g_blackpass_daily_period[MAX_PLAYERS];
new g_blackpass_weekly_period[MAX_PLAYERS];
new g_blackpass_task_popup[MAX_PLAYERS];
new g_blackpass_tracked_task[MAX_PLAYERS];
new g_blackpass_rating_refresh_until[MAX_PLAYERS];

#define BLACKPASS_REWARD_CASE_ID        99
#define BLACKPASS_REWARD_CASE_INDEX     98
#define BLACKPASS_STANDARD_REWARD_BASE  1000
#define BLACKPASS_PREMIUM_REWARD_BASE   2000
#define BLACKPASS_DELUXE_REWARD_BASE    3000

enum E_BLACKPASS_REWARD_INFO
{
    BP_REWARD_TYPE,
    BP_REWARD_INTERNAL,
    BP_REWARD_COUNT,
    BP_REWARD_RARITY,
    BP_REWARD_PRICE
};

new const g_blackpass_standard_reward_data[BLACKPASS_MAX_LEVELS + 1][E_BLACKPASS_REWARD_INFO] =
{
    {0, 0, 0, 0, 0},
    {9, 2, 8, 2, 0}, {2, 0, 5000, 1, 0}, {3, 0, 5, 1, 0}, {21, 0, 5, 1, 0}, {4, 1, 1, 2, 0},
    {9, 1, 2, 1, 0}, {2, 0, 5000, 1, 0}, {3, 0, 5, 1, 0}, {8, 0, 24, 1, 0}, {11, 951, 1, 4, 0},
    {9, 1, 2, 1, 0}, {2, 0, 5000, 1, 0}, {1, 0, 5, 1, 0}, {21, 0, 5, 1, 0}, {4, 1, 1, 2, 0},
    {9, 1, 2, 1, 0}, {2, 0, 5000, 1, 0}, {3, 0, 5, 1, 0}, {8, 0, 24, 1, 0}, {11, 955, 1, 4, 0},
    {9, 1, 2, 1, 0}, {2, 0, 5000, 1, 0}, {1, 0, 5, 1, 0}, {21, 0, 10, 1, 0}, {4, 1, 1, 2, 0},
    {9, 1, 2, 1, 0}, {2, 0, 5000, 1, 0}, {3, 0, 5, 1, 0}, {8, 0, 24, 1, 0}, {12, 6876, 1, 4, 0},
    {9, 1, 2, 1, 0}, {2, 0, 7500, 1, 0}, {1, 0, 10, 1, 0}, {21, 0, 10, 1, 0}, {4, 1, 1, 2, 0},
    {9, 1, 2, 1, 0}, {2, 0, 7500, 1, 0}, {3, 0, 5, 1, 0}, {8, 0, 24, 1, 0}, {4, 2, 1, 2, 0},
    {9, 2, 2, 1, 0}, {2, 0, 7500, 1, 0}, {1, 0, 10, 2, 0}, {21, 0, 10, 1, 0}, {4, 1, 1, 2, 0},
    {9, 2, 2, 1, 0}, {2, 0, 7500, 1, 0}, {3, 0, 10, 2, 0}, {8, 0, 24, 1, 0}, {12, 6879, 1, 4, 0},
    {9, 2, 2, 1, 0}, {2, 0, 10000, 1, 0}, {1, 0, 10, 1, 0}, {21, 0, 10, 1, 0}, {4, 1, 1, 2, 0},
    {9, 2, 2, 1, 0}, {2, 0, 10000, 1, 0}, {3, 0, 10, 2, 0}, {8, 0, 24, 1, 0}, {4, 2, 2, 3, 0},
    {9, 2, 2, 1, 0}, {2, 0, 10000, 1, 0}, {1, 0, 10, 1, 0}, {21, 0, 10, 1, 0}, {4, 1, 1, 2, 0},
    {9, 3, 2, 2, 0}, {2, 0, 10000, 1, 0}, {3, 0, 10, 2, 0}, {8, 0, 24, 1, 0}, {5, 747, 0, 5, 0},
    {9, 3, 2, 2, 0}, {2, 0, 10000, 1, 0}, {3, 0, 10, 2, 0}, {1, 0, 10, 2, 0}, {2, 0, 5000, 1, 0}
};

new const g_blackpass_standard_reward_names[BLACKPASS_MAX_LEVELS + 1][64] =
{
    "",
    "GOLD 8в.", "5000 п", "5 BC", "X5 ошкэ", "ефедмебмши X1",
    "SILVER 2в.", "5000 п", "5 BC", "X2 мю 24в.", "нВЙХ Street",
    "SILVER 2в.", "5000 п", "5 EXP", "X5 ошкэ", "ефедмебмши X1",
    "SILVER 2в.", "5000 п", "5 BC", "X2 мю 24в.", "пЧЙГЮЙ",
    "SILVER 2в.", "5000 п", "5 EXP", "X10 ошкэ", "ефедмебмши X1",
    "SILVER 2в.", "5000 п", "5 BC", "X2 мю 24в.", "яНТХЪ",
    "SILVER 2в.", "7500 п", "10 EXP", "X10 ошкэ", "ефедмебмши X1",
    "SILVER 2в.", "7500 п", "5 BC", "X2 мю 24в.", "анлфю X1",
    "GOLD 2в.", "7500 п", "10 EXP", "X10 ошкэ", "ефедмебмши X1",
    "GOLD 2в.", "7500 п", "10 BC", "X2 мю 24в.", "еЛЕКЪ",
    "GOLD 2в.", "10000 п", "10 EXP", "X10 ошкэ", "ефедмебмши X1",
    "GOLD 2в.", "10000 п", "10 BC", "X2 мю 24в.", "анлфю X2",
    "VIP GOLD мю 2в.", "10000 п", "10 EXP", "X10 ошкэ", "ефедмебмши X1",
    "PLATINUM 2в.", "10000 п", "10 BC", "X2 мю 24в.", "Daevo Matiz",
    "PLATINUM 2в.", "10000 п", "10 BC", "10 EXP", "5000 п"
};

new const g_blackpass_premium_reward_data[BLACKPASS_MAX_LEVELS + 1][E_BLACKPASS_REWARD_INFO] =
{
    {0, 0, 0, 0, 0},
    {3, 0, 40, 3, 0}, {2, 0, 15000, 2, 0}, {3, 0, 10, 2, 0}, {21, 0, 10, 1, 0}, {11, 952, 1, 4, 0},
    {9, 2, 2, 1, 0}, {2, 0, 15000, 2, 0}, {3, 0, 10, 2, 0}, {4, 2, 1, 2, 0}, {5, 743, 0, 5, 0},
    {9, 2, 2, 1, 0}, {2, 0, 15000, 2, 0}, {3, 0, 10, 2, 0}, {21, 0, 15, 1, 0}, {12, 6877, 1, 4, 0},
    {9, 2, 2, 1, 0}, {2, 0, 15000, 2, 0}, {3, 0, 10, 2, 0}, {4, 1, 1, 2, 0}, {11, 953, 1, 4, 0},
    {9, 2, 2, 1, 0}, {2, 0, 15000, 2, 0}, {3, 0, 10, 2, 0}, {21, 0, 15, 1, 0}, {12, 6878, 1, 4, 0},
    {9, 2, 2, 1, 0}, {2, 0, 15000, 2, 0}, {3, 0, 10, 2, 0}, {4, 2, 1, 2, 0}, {5, 744, 0, 5, 0},
    {9, 2, 2, 1, 0}, {2, 0, 20000, 2, 0}, {3, 0, 10, 2, 0}, {21, 0, 20, 2, 0}, {11, 954, 1, 4, 0},
    {9, 2, 2, 1, 0}, {2, 0, 20000, 2, 0}, {3, 0, 10, 2, 0}, {4, 2, 1, 2, 0}, {12, 6880, 1, 4, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {21, 0, 20, 2, 0}, {4, 3, 1, 4, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {4, 2, 1, 2, 0}, {5, 745, 0, 5, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {21, 0, 20, 2, 0}, {11, 957, 1, 4, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {4, 2, 1, 2, 0}, {12, 6875, 1, 4, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {21, 0, 20, 2, 0}, {11, 956, 1, 4, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {4, 2, 1, 2, 0}, {5, 746, 0, 5, 0},
    {9, 3, 2, 2, 0}, {2, 0, 20000, 2, 0}, {3, 0, 20, 2, 0}, {4, 3, 1, 4, 0}, {2, 0, 10000, 1, 0}
};

new const g_blackpass_premium_reward_names[BLACKPASS_MAX_LEVELS + 1][64] =
{
    "",
    "40 BC", "15000 п", "10 BC", "X10 ошкэ", "оНЪЯ Nitro",
    "GOLD 2в.", "15000 п", "10 BC", "анлфю X1", "Mercedes 190 Evo",
    "GOLD 2в.", "15000 п", "10 BC", "X15 ошкэ", "оЕРП РПЕМЕП ",
    "GOLD 2в.", "15000 п", "10 BC", "ефедмебмши X1", "лЮЯЙЮ",
    "GOLD 2в.", "15000 п", "10 BC", "X15 ошкэ", "йПХЯРХМЮ",
    "GOLD 2в.", "15000 п", "10 BC", "анлфю X1", "Toyota Tundra",
    "GOLD 2в.", "20000 п", "10 BC", "X20 ошкэ", "DeathSnake",
    "GOLD 2в.", "20000 п", "10 BC", "анлфю X1", "оПНДЧЯЕП",
    "PLATINUM 2в.", "20000 п", "20 BC", "X20 ошкэ", "ярюмдюпрмши X1",
    "PLATINUM 2в.", "20000 п", "20 BC", "анлфю X1", "Viper GTC",
    "PLATINUM 2в.", "20000 п", "20 BC", "X20 ошкэ", "мЮЦПСДМХЙ",
    "PLATINUM 2в.", "20000 п", "20 BC", "анлфю X1", "бХЙРНП",
    "PLATINUM 2в.", "20000 п", "20 BC", "X20 ошкэ", "яЙНПНЯРМШЕ йПШКЭЪ",
    "PLATINUM 2в.", "20000 п", "20 BC", "анлфю X1", "Lamborghini",
    "PLATINUM 2в.", "20000 п", "20 BC", "ярюмдюпрмши X1", "10000 п"
};

new const g_blackpass_deluxe_reward_data[5][E_BLACKPASS_REWARD_INFO] =
{
    {0, 0, 0, 0, 0},
    {5, 28744, 0, 5, 0},
    {9, 3, 360, 5, 0},
    {21, 0, 250, 5, 0},
    {10, 0, 10000, 5, 0}
};

new const g_blackpass_deluxe_reward_names[5][64] =
{
    "",
    "Porsche 718 Cayman GT4 RS",
    "VIP PLATINUM мю 15 д.",
    "X250 ошкэ",
    "10 СПНБМЕИ BP"
};

stock BlackPass_LogEvent(playerid, const action[], reward_id = 0, reward_type = 0, reward_value = 0, amount = 0, extra = 0)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO blackpass_logs (account_id,season_number,action,reward_id,reward_type,reward_value,amount,extra,created_at) VALUES (%d,%d,'%e',%d,%d,%d,%d,%d,UNIX_TIMESTAMP())",
        GetPlayerAccountID(playerid),
        BLACKPASS_SEASON_NUMBER,
        action,
        reward_id,
        reward_type,
        reward_value,
        amount,
        extra
    );
    mysql_query(mysql, query, false);
    return 1;
}


stock BlackPass_CreateTables()
{
    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `blackpass_players` (`account_id` INT NOT NULL, `season_number` INT NOT NULL, `experience` INT NOT NULL DEFAULT 0, `level` INT NOT NULL DEFAULT 1, `premium_status` INT NOT NULL DEFAULT 0, `dust` INT NOT NULL DEFAULT 0, `selected_layout` INT NOT NULL DEFAULT 0, `deluxe_rewards_claimed` TINYINT(1) NOT NULL DEFAULT 0, `claimed_standard` VARCHAR(80) NOT NULL DEFAULT '', `claimed_premium` VARCHAR(80) NOT NULL DEFAULT '', `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`,`season_number`), KEY `idx_blackpass_players_season` (`season_number`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
    if(mysql_errno()) printf("[BLACKPASS][DB][ERROR] create blackpass_players errno=%d", mysql_errno());

    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `blackpass_tasks` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `season_number` INT NOT NULL, `task_id` INT NOT NULL, `task_group` INT NOT NULL, `period_key` INT NOT NULL, `target_count` INT NOT NULL DEFAULT 0, `reward_exp` INT NOT NULL DEFAULT 0, `reward_money` INT NOT NULL DEFAULT 0, `route_id` INT NOT NULL DEFAULT 0, `button_type` INT NOT NULL DEFAULT 0, `premium_only` TINYINT(1) NOT NULL DEFAULT 0, `progress` INT NOT NULL DEFAULT 0, `status` INT NOT NULL DEFAULT 0, `tracked` TINYINT(1) NOT NULL DEFAULT 0, `complete_notified` TINYINT(1) NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `idx_blackpass_tasks_player` (`account_id`,`season_number`,`task_group`,`period_key`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
    if(mysql_errno()) printf("[BLACKPASS][DB][ERROR] create blackpass_tasks errno=%d", mysql_errno());

    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `blackpass_logs` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `season_number` INT NOT NULL, `action` VARCHAR(32) NOT NULL, `reward_id` INT NOT NULL DEFAULT 0, `reward_type` INT NOT NULL DEFAULT 0, `reward_value` INT NOT NULL DEFAULT 0, `amount` INT NOT NULL DEFAULT 0, `extra` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `idx_blackpass_logs_player` (`account_id`,`season_number`), KEY `idx_blackpass_logs_action` (`action`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);
    if(mysql_errno()) printf("[BLACKPASS][DB][ERROR] create blackpass_logs errno=%d", mysql_errno());

    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `rewards` (`id` INT NOT NULL AUTO_INCREMENT, `uid` INT NOT NULL, `award_id` INT NOT NULL, `case_id` INT NOT NULL, PRIMARY KEY (`id`), KEY `uid_idx` (`uid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", false);
    if(mysql_errno()) printf("[BLACKPASS][DB][ERROR] create rewards errno=%d", mysql_errno());

    return 1;
}
stock BlackPass_ResetPlayer(playerid)
{
    g_blackpass_player[playerid][BP_DATA_LOADED] = false;
    g_blackpass_player[playerid][BP_ACCOUNT_ID] = -1;
    g_blackpass_player[playerid][BP_EXPERIENCE] = 0;
    g_blackpass_player[playerid][BP_LEVEL] = 1;
    g_blackpass_player[playerid][BP_PREMIUM_STATUS] = BLACKPASS_STATUS_NONE;
    g_blackpass_player[playerid][BP_DUST] = 0;
    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 0;
    g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED] = false;

    for(new i = 0; i <= BLACKPASS_MAX_LEVELS; i++)
    {
        g_blackpass_claimed_standard[playerid][i] = false;
        g_blackpass_claimed_premium[playerid][i] = false;
    }

    g_blackpass_tasks_loaded[playerid] = false;
    g_blackpass_daily_period[playerid] = 0;
    g_blackpass_weekly_period[playerid] = 0;
    g_blackpass_task_popup[playerid] = 0;
    g_blackpass_tracked_task[playerid] = 0;
    g_blackpass_rating_refresh_until[playerid] = 0;

    for(new task_idx = 0; task_idx < BLACKPASS_TASK_SLOT_COUNT; task_idx++)
    {
        g_blackpass_tasks[playerid][task_idx][BP_TASK_ROW_ID] = 0;
        new default_task_id = g_blackpass_default_task_ids[task_idx];
        new def_index = BlackPass_FindTaskDefIndex(default_task_id);
        g_blackpass_tasks[playerid][task_idx][BP_TASK_ID] = default_task_id;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_GROUP] = def_index == -1 ? (task_idx < BLACKPASS_DAILY_TASK_COUNT ? BLACKPASS_TASK_GROUP_DAILY : BLACKPASS_TASK_GROUP_WEEKLY) : g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP];
        g_blackpass_tasks[playerid][task_idx][BP_TASK_PERIOD_KEY] = 0;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_PROGRESS] = 0;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_STORED_STATUS] = BLACKPASS_STATUS_NONE;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_TRACKED] = false;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_COMPLETE_NOTIFIED] = false;
    }
    return 1;
}

stock BlackPass_GetLevelFromExperience(experience)
{
    new level = 1 + (experience / BLACKPASS_LEVEL_EXP);
    if(level < 1) level = 1;
    if(level > BLACKPASS_MAX_LEVELS) level = BLACKPASS_MAX_LEVELS;
    return level;
}

stock BlackPass_GetMaxExperience()
{
    return (BLACKPASS_MAX_LEVELS - 1) * BLACKPASS_LEVEL_EXP;
}

stock BlackPass_BuildClaimFlagsString(playerid, bool:is_premium, output[], output_len)
{
    output[0] = EOS;
    for(new i = 1; i <= BLACKPASS_MAX_LEVELS; i++)
    {
        new part[2];
        part[0] = (is_premium ? g_blackpass_claimed_premium[playerid][i] : g_blackpass_claimed_standard[playerid][i]) ? '1' : '0';
        part[1] = EOS;
        strcat(output, part, output_len);
    }
    return 1;
}

stock BlackPass_ParseClaimFlagsString(playerid, bool:is_premium, const source[])
{
    for(new i = 1; i <= BLACKPASS_MAX_LEVELS; i++)
    {
        new bool:is_claimed = ((i - 1) < strlen(source) && source[i - 1] == '1');
        if(is_premium) g_blackpass_claimed_premium[playerid][i] = is_claimed;
        else g_blackpass_claimed_standard[playerid][i] = is_claimed;
    }
    return 1;
}

stock BlackPass_GetCurrentLevel(playerid)
{
    g_blackpass_player[playerid][BP_LEVEL] = BlackPass_GetLevelFromExperience(g_blackpass_player[playerid][BP_EXPERIENCE]);
    return g_blackpass_player[playerid][BP_LEVEL];
}

stock BlackPass_GetClientPremiumStatus(status)
{
    switch(status)
    {
        case BLACKPASS_STATUS_PREMIUM: return 2;
        case BLACKPASS_STATUS_DELUXE: return 1;
    }
    return 0;
}

stock BlackPass_RefreshStateFlags(playerid, Node:json)
{
    new current_level = BlackPass_GetCurrentLevel(playerid);
    JSON_SetInt(json, "lv", current_level);
    JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
    JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
    JSON_SetInt(json, "es", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(json, "l", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(json, "lc", g_blackpass_player[playerid][BP_SELECTED_LAYOUT]);
    JSON_SetInt(json, "is", g_blackpass_claimed_standard[playerid][current_level] ? 0 : 1);
    JSON_SetInt(json, "ps", g_blackpass_claimed_premium[playerid][current_level] ? 0 : 1);
    return 1;
}

stock BlackPass_GetRewardInventoryItemId(level, bool:is_premium)
{
    return (is_premium ? BLACKPASS_PREMIUM_REWARD_BASE : BLACKPASS_STANDARD_REWARD_BASE) + level;
}

stock BlackPass_GetDeluxeInventoryItemId(index)
{
    return BLACKPASS_DELUXE_REWARD_BASE + index;
}

stock BlackPass_IsRewardInventoryItem(itemid)
{
    if(itemid >= BLACKPASS_STANDARD_REWARD_BASE + 1 && itemid <= BLACKPASS_STANDARD_REWARD_BASE + BLACKPASS_MAX_LEVELS) return 1;
    if(itemid >= BLACKPASS_PREMIUM_REWARD_BASE + 1 && itemid <= BLACKPASS_PREMIUM_REWARD_BASE + BLACKPASS_MAX_LEVELS) return 1;
    if(itemid >= BLACKPASS_DELUXE_REWARD_BASE + 1 && itemid <= BLACKPASS_DELUXE_REWARD_BASE + 4) return 1;
    return 0;
}

stock BlackPass_GetRewardInventoryData(itemid, name[], name_len, &type, &internal, &count, &rarity, &price)
{
    name[0] = EOS;
    type = 0;
    internal = 0;
    count = 0;
    rarity = 0;
    price = 0;
    if(itemid >= BLACKPASS_STANDARD_REWARD_BASE + 1 && itemid <= BLACKPASS_STANDARD_REWARD_BASE + BLACKPASS_MAX_LEVELS)
    {
        new level = itemid - BLACKPASS_STANDARD_REWARD_BASE;
        if(1 <= level <= BLACKPASS_MAX_LEVELS)
        {
            format(name, name_len, "%s", g_blackpass_standard_reward_names[level]);
            type = g_blackpass_standard_reward_data[level][BP_REWARD_TYPE];
            internal = g_blackpass_standard_reward_data[level][BP_REWARD_INTERNAL];
            count = g_blackpass_standard_reward_data[level][BP_REWARD_COUNT];
            rarity = g_blackpass_standard_reward_data[level][BP_REWARD_RARITY];
            price = g_blackpass_standard_reward_data[level][BP_REWARD_PRICE];
            return 1;
        }
        return 0;
    }
    if(itemid >= BLACKPASS_PREMIUM_REWARD_BASE + 1 && itemid <= BLACKPASS_PREMIUM_REWARD_BASE + BLACKPASS_MAX_LEVELS)
    {
        new level = itemid - BLACKPASS_PREMIUM_REWARD_BASE;
        if(1 <= level <= BLACKPASS_MAX_LEVELS)
        {
            format(name, name_len, "%s", g_blackpass_premium_reward_names[level]);
            type = g_blackpass_premium_reward_data[level][BP_REWARD_TYPE];
            internal = g_blackpass_premium_reward_data[level][BP_REWARD_INTERNAL];
            count = g_blackpass_premium_reward_data[level][BP_REWARD_COUNT];
            rarity = g_blackpass_premium_reward_data[level][BP_REWARD_RARITY];
            price = g_blackpass_premium_reward_data[level][BP_REWARD_PRICE];
            return 1;
        }
        return 0;
    }
    if(itemid
