// Массив для хранения состояния полета каждого игрока (true = летает, false = не летает)
new bool:g_bPlayerFlying[MAX_PLAYERS];
new Float:g_fPlayerFlySpeed[MAX_PLAYERS];
new g_iFlyTimer[MAX_PLAYERS];
new Text:g_FlyControlTextDraws[10];

// Массив для хранения ID невидимой платформы для каждого игрока
new PlayerInvisiblePlatform[MAX_PLAYERS];

// Индексы для удобства. Кст, пусть Димас(Welsi) на заметку возьмет
#define TD_FLY_MAIN     0
#define TD_FLY_WASD     1
#define TD_FLY_UP_DOWN  2
#define TD_FLY_OFF      3
#define TD_FLY_FORWARD  4
#define TD_FLY_BACKWARD 5
#define TD_FLY_LEFT     6
#define TD_FLY_RIGHT    7
#define TD_FLY_UP       8
#define TD_FLY_DOWN     9

#define DEFAULT_FLY_SPEED 1.0 // Скорость по умолчанию при полёте
#define FAST_FLY_SPEED 5.0    // Ускоренная скорость полёта
#define SLOW_FLY_SPEED 0.2    // Замедленная скорость полёта

forward FlyPlayerTask(playerid);

public OnGameModeInit()
{
    CreateTextDrawFly();

    for (new i = 0; i < MAX_PLAYERS; i++) PlayerInvisiblePlatform[i] = INVALID_OBJECT_ID;

    #if defined fly_OnGameModeInit
        return fly_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit fly_OnGameModeInit
#if defined fly_OnGameModeInit
    forward fly_OnGameModeInit();
#endif

stock CreateTextDrawFly()
{
	// Фон
    g_FlyControlTextDraws[TD_FLY_MAIN] = TextDrawCreate(-2.2000, 0.0000, "txd:fly_main"); // пусто 
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_MAIN], 644.0000, 448.0000); 
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_MAIN], 1); 
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_MAIN], -1); 
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_MAIN], 255); 
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_MAIN], 4); 
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_MAIN], 0); 
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_MAIN], 0); 

	// кнопки: вперед, назад, вправо, влево
    g_FlyControlTextDraws[TD_FLY_WASD] = TextDrawCreate(60.0000, 252.0000, "txd:fly_wasd"); // пусто 
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_WASD], 100.0000, 146.0000); 
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_WASD], 1); 
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_WASD], -1); 
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_WASD], 255); 
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_WASD], 4); 
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_WASD], 0); 
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_WASD], 0); 

	// кнопки: вверх, вниз
    g_FlyControlTextDraws[TD_FLY_UP_DOWN] = TextDrawCreate(536.0000, 269.0000, "txd:fly_up_down"); // пусто 
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_UP_DOWN], 36.0000, 130.0000); 
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_UP_DOWN], 1); 
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_UP_DOWN], -1); 
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_UP_DOWN], 255); 
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_UP_DOWN], 4); 
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_UP_DOWN], 0); 
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_UP_DOWN], 0); 

    // Отключить fly
    g_FlyControlTextDraws[TD_FLY_OFF] = TextDrawCreate(600.1993, -2.5466, "txd:transparent"); // пусто 
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_OFF], 40.0000, 46.0000); 
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_OFF], 1); 
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_OFF], -1); 
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_OFF], 255); 
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_OFF], 4); 
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_OFF], 0); 
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_OFF], 0); 
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_OFF], true); 

    // Вперед
    g_FlyControlTextDraws[TD_FLY_FORWARD] = TextDrawCreate(94.0000, 252.0000, "txd:transparent"); // пусто
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_FORWARD], 34.0000, 47.0000);
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_FORWARD], 1);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_FORWARD], -1);
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_FORWARD], 255);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_FORWARD], 4);
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_FORWARD], 0);
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_FORWARD], 0);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_FORWARD], true);

	// Назад
    g_FlyControlTextDraws[TD_FLY_BACKWARD] = TextDrawCreate(94.0000, 347.0000, "txd:transparent"); // пусто
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_BACKWARD], 34.0000, 47.0000);
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_BACKWARD], 1);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_BACKWARD], -1);
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_BACKWARD], 255);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_BACKWARD], 4);
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_BACKWARD], 0);
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_BACKWARD], 0);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_BACKWARD], true);

	// Влево
    g_FlyControlTextDraws[TD_FLY_LEFT] = TextDrawCreate(60.0000, 300.0000, "txd:transparent"); // пусто
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_LEFT], 34.0000, 47.0000);
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_LEFT], 1);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_LEFT], -1);
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_LEFT], 255);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_LEFT], 4);
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_LEFT], 0);
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_LEFT], 0);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_LEFT], true);

    // Вправо
    g_FlyControlTextDraws[TD_FLY_RIGHT] = TextDrawCreate(128.0000, 300.0000, "txd:transparent"); // пусто
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_RIGHT], 34.0000, 47.0000);
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_RIGHT], 1);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_RIGHT], -1);
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_RIGHT], 255);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_RIGHT], 4);
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_RIGHT], 0);
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_RIGHT], 0);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_RIGHT], true);

	// Вверх (стрелка вверх для Z-оси)
    g_FlyControlTextDraws[TD_FLY_UP] = TextDrawCreate(536.0000, 269.0000, "txd:transparent"); // пусто
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_UP], 34.0000, 47.0000);
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_UP], 1);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_UP], -1);
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_UP], 255);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_UP], 4);
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_UP], 0);
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_UP], 0);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_UP], true);

    // Вниз (стрелка вниз для Z-оси)
    g_FlyControlTextDraws[TD_FLY_DOWN] = TextDrawCreate(536.0000, 315.0000, "txd:transparent"); // пусто
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_DOWN], 34.0000, 47.0000);
    TextDrawAlignment(g_FlyControlTextDraws[TD_FLY_DOWN], 1);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_DOWN], -1);
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_DOWN], 255);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_DOWN], 4);
    TextDrawSetProportional(g_FlyControlTextDraws[TD_FLY_DOWN], 0);
    TextDrawSetShadow(g_FlyControlTextDraws[TD_FLY_DOWN], 0);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_DOWN], true);
}

CMD:fly(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа к этой команде. Требуется уровень администратора 5+.");

    if (g_bPlayerFlying[playerid])
    {
        g_bPlayerFlying[playerid] = false;

        if (g_iFlyTimer[playerid] != 0)
        {
            KillTimer(g_iFlyTimer[playerid]);
            g_iFlyTimer[playerid] = 0;
        }
		TogglePlayerControllable(playerid, true);

        ClearAnimations(playerid);

        CancelSelectTextDraw(playerid);

        for (new i = 0; i < sizeof(g_FlyControlTextDraws); i++) TextDrawHideForPlayer(playerid, g_FlyControlTextDraws[i]);

        if (IsValidObject(PlayerInvisiblePlatform[playerid]))
        {
            DestroyObject(PlayerInvisiblePlatform[playerid]);
            PlayerInvisiblePlatform[playerid] = INVALID_OBJECT_ID;
        }

        SendClientMessage(playerid, 0x00FF00FF, "{FFFF00}| {ffffff}Режим полёта отключён.");
    }
    else
    {
        g_bPlayerFlying[playerid] = true;
        g_fPlayerFlySpeed[playerid] = DEFAULT_FLY_SPEED;

        if (IsPlayerInAnyVehicle(playerid))
        {
            RemovePlayerFromVehicle(playerid);
        }
        SetPlayerArmedWeapon(playerid, 0);

        g_iFlyTimer[playerid] = SetTimerEx("FlyPlayerTask", 20, true, "i", playerid);

        ApplyAnimation(playerid, "PARACHUTE", "FALL_FRONT", 4.1, 1, 1, 1, 1, 0);
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        if (IsValidObject(PlayerInvisiblePlatform[playerid])) DestroyObject(PlayerInvisiblePlatform[playerid]);

        SelectTextDraw(playerid, -1);

        for (new i = 0; i < sizeof(g_FlyControlTextDraws); i++) TextDrawShowForPlayer(playerid, g_FlyControlTextDraws[i]);

		TogglePlayerControllable(playerid, true);

        SendClientMessage(playerid, 0xFFFF00FF, "Режим полёта включён! Используйте джойстик для движения.");
        SendClientMessage(playerid, 0xFFFF00FF, "Нажмите кнопку вверх или вниз чтобы подняться или опуститься");
        SendClientMessage(playerid, 0xFFFFFFFF, "Вращайте камерой чтобы поменять угол поворота.");
    }
    return 1;
}

public FlyPlayerTask(playerid)
{
    if (!g_bPlayerFlying[playerid] || !IsPlayerConnected(playerid))
    {
        if (g_iFlyTimer[playerid] != 0)
        {
            KillTimer(g_iFlyTimer[playerid]);
            g_iFlyTimer[playerid] = 0;
        }
        return 1;
    }
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.1);
    else PlayerInvisiblePlatform[playerid] = CreateObject(19128, x, y, z - 1.0, 0.0, 0.0, 0.0, 0.0, -1, -1, playerid, 2.0, 2.0, 2.0);

    ApplyAnimationEx(playerid, "PARACHUTE", "FALL_FRONT", 4.1, true, 0, 0, 0, 0, 0);

    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if (g_bPlayerFlying[playerid])
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        new Float:camera_look_x, Float:camera_look_y, Float:camera_look_z;
        GetPlayerCameraFrontVector(playerid, camera_look_x, camera_look_y, camera_look_z);

        new Float:current_click_speed = DEFAULT_FLY_SPEED * 5.0;

        if (clickedid == g_FlyControlTextDraws[TD_FLY_FORWARD])
        {
            x += (camera_look_x * current_click_speed);
            y += (camera_look_y * current_click_speed);
            z += (camera_look_z * current_click_speed);
            SetPlayerPos(playerid, x, y, z);

            if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_BACKWARD])
        {
            x -= (camera_look_x * current_click_speed);
            y -= (camera_look_y * current_click_speed);
            z -= (camera_look_z * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_LEFT])
        {
            new Float:side_vector_x = -camera_look_y;
            new Float:side_vector_y = camera_look_x;
            x += (side_vector_x * current_click_speed);
            y += (side_vector_y * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_RIGHT])
        {
            new Float:side_vector_x = -camera_look_y;
            new Float:side_vector_y = camera_look_x;
            x -= (side_vector_x * current_click_speed);
            y -= (side_vector_y * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_UP])
        {
            z += current_click_speed;
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_DOWN])
        {
            z -= current_click_speed;
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid])) SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_OFF])
        {
            callcmd::fly(playerid, "");
            return 1;
        }
    }
    #if defined fly_OnPlayerClickTextDraw
        return fly_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw fly_OnPlayerClickTextDraw
#if defined fly_OnPlayerClickTextDraw
    forward fly_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnPlayerConnect(playerid)
{
    g_bPlayerFlying[playerid] = false;
    g_fPlayerFlySpeed[playerid] = DEFAULT_FLY_SPEED;
    g_iFlyTimer[playerid] = 0;
    PlayerInvisiblePlatform[playerid] = INVALID_OBJECT_ID; 

    #if defined fly_OnPlayerConnect
        return fly_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect fly_OnPlayerConnect
#if defined fly_OnPlayerConnect
    forward fly_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if (g_bPlayerFlying[playerid])
    {
        g_bPlayerFlying[playerid] = false;
        if (g_iFlyTimer[playerid] != 0)
        {
            KillTimer(g_iFlyTimer[playerid]);
            g_iFlyTimer[playerid] = 0;
        }
        for (new i = 0; i < sizeof(g_FlyControlTextDraws); i++) TextDrawHideForPlayer(playerid, g_FlyControlTextDraws[i]);

        CancelSelectTextDraw(playerid);
        ClearAnimations(playerid);
    }

    if (IsValidObject(PlayerInvisiblePlatform[playerid]))
    {
        DestroyObject(PlayerInvisiblePlatform[playerid]);
        PlayerInvisiblePlatform[playerid] = INVALID_OBJECT_ID;
    }

    #if defined fly_OnPlayerDisconnect
        return fly_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect fly_OnPlayerDisconnect
#if defined fly_OnPlayerDisconnect
    forward fly_OnPlayerDisconnect(playerid, reason);
#endif