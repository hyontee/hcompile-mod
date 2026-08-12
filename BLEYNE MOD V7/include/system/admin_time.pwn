new Text: admin_time_TD;



public: OnSecondTimer()
{
new hour, minute, second, year, month, day;
gettime(hour, minute, second);
getdate(year, month, day);

new fmt_str[150];

format(fmt_str, sizeof fmt_str, "%d:%02d:%02d-%02d.%02d.%d", hour, minute, second, day, month, year);
TextDrawSetString(admin_time_TD, fmt_str);

    // Правильный вызов хука, без аргументов и скобок
    #if defined time_OnSecondTimer
        return time_OnSecondTimer();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnSecondTimer
#undef OnSecondTimer
#else
#define _ALS_OnSecondTimer
#endif
#define OnSecondTimer time_OnSecondTimer
#if defined time_OnSecondTimer
    // Правильное объявление forward, без аргументов
    forward time_OnSecondTimer();
#endif



public: OnPlayerTimer(playerid)
{
	if(GetPlayerAdminEx(playerid) > 1)
	TextDrawShowForPlayer(playerid, admin_time_TD);
	else
   	TextDrawHideForPlayer(playerid, admin_time_TD);

    #if defined time_OnPlayerTimer
        return time_OnPlayerTimer(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerTimer
#undef OnPlayerTimer
#else
#define _ALS_OnPlayerTimer
#endif
#define OnPlayerTimer time_OnPlayerTimer
#if defined time_OnPlayerTimer
    // Правильное объявление forward, с аргументом
    forward time_OnPlayerTimer(playerid);
#endif



stock CreateTextDrawAdminTime()
{
	admin_time_TD = TextDrawCreate(500.0, 420.000122, "_"); // Сдвинуто левее (было 536.838958)
	TextDrawLetterSize(admin_time_TD, 0.262385, 1.605833);
	TextDrawTextSize(admin_time_TD, -0.468522, -10.583328);
	TextDrawAlignment(admin_time_TD, 1);
	TextDrawColor(admin_time_TD, -1);
	TextDrawSetShadow(admin_time_TD, 0);
	TextDrawSetOutline(admin_time_TD, 1);
	TextDrawBackgroundColor(admin_time_TD, 255);
	TextDrawFont(admin_time_TD, 1);
	TextDrawSetProportional(admin_time_TD, 1);
}
public OnGameModeInit()
{
    print("[Extrazz_system] Система админ-времени загружена.");
    CreateTextDrawAdminTime();
    SetTimer("OnSecondTimer", 1000, true);

    #if defined time_OnGameModeInit
        return time_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit time_OnGameModeInit
#if defined time_OnGameModeInit
    forward time_OnGameModeInit();
#endif
