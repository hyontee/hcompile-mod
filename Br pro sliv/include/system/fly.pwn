// Массив для хранения состояния полета каждого игрока (true = летает, false = не летает)
new bool:g_bPlayerFlying[MAX_PLAYERS];

// Массив для хранения текущей скорости полета каждого игрока
new Float:g_fPlayerFlySpeed[MAX_PLAYERS];

// Массив для хранения ID таймера полёта для каждого игрока
new g_iFlyTimer[MAX_PLAYERS];

// TextDraws для управления полетом - один набор глобальных TextDraw'ов
new Text:g_FlyControlTextDraws[10]; // Массив из 8 элементов

// НЕВИДИМЫЙ ОБЪЕКТ: Массив для хранения ID невидимой платформы для каждого игрока
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
#define COLOR_ORANGE 0xFF6600FF
#define DEFAULT_FLY_SPEED 1.0 // Скорость по умолчанию при полёте
#define FAST_FLY_SPEED 5.0    // Ускоренная скорость полёта (например, при нажатии Sprint)
#define SLOW_FLY_SPEED 0.2    // Замедленная скорость полёта (например, при нажатии Crouch)

// =========================================================================
// Forward-декларации
// =========================================================================

forward FlyPlayerTask(playerid);

// =========================================================================
// OnGameModeInit - Инициализация TextDraw'ов и переменных
// =========================================================================

public OnGameModeInit()
{
    CreateTextDrawFly();

    // Инициализируем массив невидимых платформ
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        PlayerInvisiblePlatform[i] = INVALID_OBJECT_ID;
    }

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
    g_FlyControlTextDraws[TD_FLY_MAIN] = TextDrawCreate(50.0, 240.0, "_");
    TextDrawTextSize(g_FlyControlTextDraws[TD_FLY_MAIN], 150.0, 150.0);
    TextDrawUseBox(g_FlyControlTextDraws[TD_FLY_MAIN], 1);
    TextDrawBoxColor(g_FlyControlTextDraws[TD_FLY_MAIN], 0x00000066);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_MAIN], 1);

    // Вперёд (стрелка ^)
    g_FlyControlTextDraws[TD_FLY_FORWARD] = TextDrawCreate(105.0, 245.0, "^");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_FORWARD], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_FORWARD], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_FORWARD], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_FORWARD], COLOR_ORANGE);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_FORWARD], true);

    // Назад (стрелка v)
    g_FlyControlTextDraws[TD_FLY_BACKWARD] = TextDrawCreate(105.0, 300.0, "v");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_BACKWARD], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_BACKWARD], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_BACKWARD], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_BACKWARD], COLOR_ORANGE);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_BACKWARD], true);

    // Влево (стрелка <)
    g_FlyControlTextDraws[TD_FLY_LEFT] = TextDrawCreate(80.0, 275.0, "<");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_LEFT], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_LEFT], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_LEFT], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_LEFT], COLOR_ORANGE);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_LEFT], true);

    // Вправо (стрелка >)
    g_FlyControlTextDraws[TD_FLY_RIGHT] = TextDrawCreate(130.0, 275.0, ">");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_RIGHT], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_RIGHT], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_RIGHT], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_RIGHT], COLOR_ORANGE);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_RIGHT], true);

    // Вверх (ось Z)
    g_FlyControlTextDraws[TD_FLY_UP] = TextDrawCreate(200.0, 250.0, "?");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_UP], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_UP], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_UP], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_UP], COLOR_ORANGE);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_UP], true);

    // Вниз (ось Z)
    g_FlyControlTextDraws[TD_FLY_DOWN] = TextDrawCreate(200.0, 300.0, "?");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_DOWN], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_DOWN], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_DOWN], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_DOWN], COLOR_ORANGE);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_DOWN], true);

    // Выключить fly
    g_FlyControlTextDraws[TD_FLY_OFF] = TextDrawCreate(580.0, 20.0, "X");
    TextDrawBackgroundColor(g_FlyControlTextDraws[TD_FLY_OFF], 0);
    TextDrawFont(g_FlyControlTextDraws[TD_FLY_OFF], 2);
    TextDrawLetterSize(g_FlyControlTextDraws[TD_FLY_OFF], 0.5, 1.5);
    TextDrawColor(g_FlyControlTextDraws[TD_FLY_OFF], 0xFF0000FF);
    TextDrawSetSelectable(g_FlyControlTextDraws[TD_FLY_OFF], true);
}

/*CMD:fly(playerid, params[])
{
    // Проверка уровня администратора (замените на вашу функцию GetPlayerAdminEx)
    if(GetPlayerAdminEx(playerid) < 5) return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа к этой команде. Требуется уровень администратора 5+.");
    if (g_bPlayerFlying[playerid])
    {
        // Отключение режима полёта
        g_bPlayerFlying[playerid] = false;

        if (g_iFlyTimer[playerid] != 0)
        {
            KillTimer(g_iFlyTimer[playerid]);
            g_iFlyTimer[playerid] = 0;
        }
		TogglePlayerControllable(playerid, true);
        // Очищаем анимации, чтобы игрок вернулся в нормальное состояние
        ClearAnimations(playerid);

        // Отключаем режим выбора TextDraw, используя вашу функцию
        CancelSelectTextDraw(playerid);

        // Скрываем все TextDraw'ы управления полётом для этого игрока
        for (new i = 0; i < sizeof(g_FlyControlTextDraws); i++)
        {
            TextDrawHideForPlayer(playerid, g_FlyControlTextDraws[i]);
        }

        // Уничтожаем невидимый объект, если он существует
        if (IsValidObject(PlayerInvisiblePlatform[playerid]))
        {
            DestroyObject(PlayerInvisiblePlatform[playerid]);
            PlayerInvisiblePlatform[playerid] = INVALID_OBJECT_ID; // Сбрасываем ID
        }

        SendClientMessage(playerid, 0x00FF00FF, "{FFFF00}| {ffffff}Режим полёта отключён.");
    }
    else
    {
        // Включение режима полёта
        g_bPlayerFlying[playerid] = true;
        g_fPlayerFlySpeed[playerid] = DEFAULT_FLY_SPEED;

        if (IsPlayerInAnyVehicle(playerid))
        {
            RemovePlayerFromVehicle(playerid); // Высаживаем из машины, если игрок в ней
        }
        SetPlayerArmedWeapon(playerid, 0); // Убираем оружие (по желанию)

        // Запускаем таймер для обработки движения по клавишам
        g_iFlyTimer[playerid] = SetTimerEx("FlyPlayerTask", 20, true, "i", playerid);

        // Применяем анимацию полёта "PARACHUTE:FALL_FRONT"
        // library, animname, fDelta, bLoop, bLockX, bLockY, bFreeze, iTime, bForceSync
        ApplyAnimation(playerid, "PARACHUTE", "FALL_FRONT", 4.1, 1, 1, 1, 1, 0);
        // Установлен bFreeze в 1 (true) для заморозки ходьбы.

        // Получаем текущую позицию игрока для создания объекта
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        // Уничтожаем старый объект, если он есть, перед созданием нового
        if (IsValidObject(PlayerInvisiblePlatform[playerid]))
        {
            DestroyObject(PlayerInvisiblePlatform[playerid]);
        }

        // Включаем режим выбора TextDraw, используя вашу функцию и цвет курсора
        SelectTextDraw(playerid, -1); // -1 для стандартного цвета (зеленый)

        // Показываем все TextDraw'ы управления полётом для этого игрока
        for (new i = 0; i < sizeof(g_FlyControlTextDraws); i++)
        {
            TextDrawShowForPlayer(playerid, g_FlyControlTextDraws[i]);
        }

		TogglePlayerControllable(playerid, true);

        SendClientMessage(playerid, 0xFFFF00FF, "Режим полёта включён! Используйте джойстик для движения.");
        SendClientMessage(playerid, 0xFFFF00FF, "Нажмите кнопку вверх или вниз чтобы подняться или опуститься");
        SendClientMessage(playerid, 0xFFFFFFFF, "Вращайте камерой чтобы поменять угол поворота.");
    }
    return 1;
}*/

// =========================================================================
// FlyPlayerTask - Таймер для обработки движения с клавиатуры/джойстика
// =========================================================================

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

    // Получаем текущую позицию игрока
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    // Обновляем позицию невидимого объекта, чтобы он всегда был под игроком
    // Это ключевой момент для обеспечения постоянной коллизии
    if (IsValidObject(PlayerInvisiblePlatform[playerid]))
    {
        SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.1);
    }
    else { // Если объект вдруг пропал, можно его пересоздать, хотя в норме не должно быть
        PlayerInvisiblePlatform[playerid] = CreateObject(19128, x, y, z - 1.0, 0.0, 0.0, 0.0, 0.0, -1, -1, playerid, 2.0, 2.0, 2.0);
    }
    // СЮДА АПЛИ АННИМАТИОН
    ApplyAnimationEx(playerid, "PARACHUTE", "FALL_FRONT", 4.1, true, 0, 0, 0, 0, 0);
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    // Обрабатываем клики только если игрок находится в режиме полёта
    if (g_bPlayerFlying[playerid])
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        new Float:camera_look_x, Float:camera_look_y, Float:camera_look_z;
        GetPlayerCameraFrontVector(playerid, camera_look_x, camera_look_y, camera_look_z);

        // Скорость для движения по клику.
        new Float:current_click_speed = DEFAULT_FLY_SPEED * 5.0;

        // Определяем, на какую кнопку нажали, и телепортируем игрока
        if (clickedid == g_FlyControlTextDraws[TD_FLY_FORWARD])
        {
            x += (camera_look_x * current_click_speed);
            y += (camera_look_y * current_click_speed);
            z += (camera_look_z * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            // Обновляем позицию невидимого объекта после телепортации игрока
            if (IsValidObject(PlayerInvisiblePlatform[playerid]))
            {
                SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            }
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_BACKWARD])
        {
            x -= (camera_look_x * current_click_speed);
            y -= (camera_look_y * current_click_speed);
            z -= (camera_look_z * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid]))
            {
                SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            }
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_LEFT])
        {
            new Float:side_vector_x = -camera_look_y;
            new Float:side_vector_y = camera_look_x;
            x += (side_vector_x * current_click_speed);
            y += (side_vector_y * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid]))
            {
                SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            }
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_RIGHT])
        {
            new Float:side_vector_x = -camera_look_y;
            new Float:side_vector_y = camera_look_x;
            x -= (side_vector_x * current_click_speed);
            y -= (side_vector_y * current_click_speed);
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid]))
            {
                SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            }
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_UP])
        {
            z += current_click_speed;
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid]))
            {
                SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            }
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_DOWN])
        {
            z -= current_click_speed;
            SetPlayerPos(playerid, x, y, z);
            if (IsValidObject(PlayerInvisiblePlatform[playerid]))
            {
                SetObjectPos(PlayerInvisiblePlatform[playerid], x, y, z - 1.0);
            }
            return 1;
        }
        else if (clickedid == g_FlyControlTextDraws[TD_FLY_OFF])
        {
            //callcmd::fly(playerid, "");
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
    PlayerInvisiblePlatform[playerid] = INVALID_OBJECT_ID; // Инициализируем ID объекта для нового игрока

    // Передача управления другим плагинам/скриптам
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

// =========================================================================
// OnPlayerDisconnect - Очистка данных игрока при отключении
// =========================================================================

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
        // Скрываем все TextDraw'ы управления полётом для этого игрока
        for (new i = 0; i < sizeof(g_FlyControlTextDraws); i++)
        {
            TextDrawHideForPlayer(playerid, g_FlyControlTextDraws[i]);
        }
        // Отключаем режим выбора TextDraw, используя вашу функцию
        CancelSelectTextDraw(playerid);
        // Очищаем анимации при выходе
        ClearAnimations(playerid);
    }

    // Уничтожаем невидимый объект при отключении игрока
    if (IsValidObject(PlayerInvisiblePlatform[playerid]))
    {
        DestroyObject(PlayerInvisiblePlatform[playerid]);
        PlayerInvisiblePlatform[playerid] = INVALID_OBJECT_ID; // Сбрасываем ID
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
