#if defined _kosti_table_included
    #endinput
#endif
#define _kosti_table_included

// Основные настройки
#define KOSTI_BET_SUM              (1000000)
#define KOSTI_COMMISSION_PERCENT   (5)
#define KOSTI_COUNTDOWN_SECONDS    (9)
#define KOSTI_TD_COUNT             (16)
#define KOSTI_TABLES_COUNT         (6)
#define KOSTI_TABLE_AREA_RADIUS    (2.0)
#define NOTIFCMD_BLACKJACK         (6104)
#define DIALOG_DICE                (6105)

// Позиции столов
new KostiTableArea[KOSTI_TABLES_COUNT] = { -1, ... };
static const Float:KostiTablePos[KOSTI_TABLES_COUNT][3] =
{
    {2496.77, 2438.24, 2500.75},
    {2496.69, 2443.55, 2500.75},
    {2496.70, 2448.68, 2500.75},
    {2500.82, 2449.14, 2500.75},
    {2500.80, 2443.77, 2500.75},
    {2500.82, 2438.47, 2500.75}
};

// Позиция раздевалки
#define KOSTI_DRESS_X              (2517.021484)
#define KOSTI_DRESS_Y              (2489.340087)
#define KOSTI_DRESS_Z              (2501.078125)
#define KOSTI_DRESS_RADIUS         (3.0)

// Переменные состояния игроков
new bool:KostiInTable[MAX_PLAYERS];
new bool:KostiBetDone[MAX_PLAYERS];
new bool:KostiKrupier[MAX_PLAYERS];
new bool:KostiTDCreated[MAX_PLAYERS];
new PlayerText:KostiTD[MAX_PLAYERS][KOSTI_TD_COUNT];
new PlayerText:KostiTimerTD[MAX_PLAYERS];
new PlayerOldSkin[MAX_PLAYERS]; // Для сохранения старого скина

// Переменные игры
new KostiBank = 0;
new bool:KostiRoundStarted = false;
new KostiCountdown = 0;
new KostiTimer = -1;

// Пикап и метка работы крупье
new KostiKrupierJobPickup = -1;
new Text3D:KostiKrupierJobLabel;
new KostiDressArea = -1; // Зона раздевалки

// Константы работы крупье
#define KOSTI_KRUPIER_JOB_SKIN    (173)
#define KOSTI_KRUPIER_JOB_WORLD   (-1)
#define KOSTI_KRUPIER_JOB_X       (2516.487304)
#define KOSTI_KRUPIER_JOB_Y       (2488.611083)
#define KOSTI_KRUPIER_JOB_Z       (2501.118164)

// Константы раздевалки
#define KOSTI_SKIN_MANAGER         (170)
#define KOSTI_SKIN_DEALER          (171)
#define KOSTI_SKIN_GUARD           (172)

forward Kosti_CountdownTick();

// ============================================================================
// Форматирование денег
// ============================================================================
stock Kosti_FormatMoney(value, dest[], size)
{
    format(dest, size, "%d", value);
    return 1;
}

// ============================================================================
// Создание пикапа работы крупье
// ============================================================================
stock Kosti_CreateJobPickup()
{
    if(KostiKrupierJobPickup != -1) return 1;

    KostiKrupierJobPickup = CreatePickup(1239, 23, 
        KOSTI_KRUPIER_JOB_X, 
        KOSTI_KRUPIER_JOB_Y, 
        KOSTI_KRUPIER_JOB_Z, 
        KOSTI_KRUPIER_JOB_WORLD
    );
    
    KostiKrupierJobLabel = CreateDynamic3DTextLabel(
        "{F28C28}Работа крупье~n~{FFFFFF}Подойдите, чтобы устроиться~n~{AAAAAA}Скин: 173",
        -1, 
        KOSTI_KRUPIER_JOB_X, 
        KOSTI_KRUPIER_JOB_Y, 
        KOSTI_KRUPIER_JOB_Z + 0.55, 
        8.0,
        INVALID_PLAYER_ID, 
        INVALID_VEHICLE_ID, 
        0, 
        KOSTI_KRUPIER_JOB_WORLD, 
        -1, 
        -1, 
        50.0
    );
    
    return 1;
}

// ============================================================================
// Создание зон столов
// ============================================================================
stock Kosti_CreateTableAreas()
{
    for(new i; i < KOSTI_TABLES_COUNT; i++)
    {
        if(KostiTableArea[i] != -1) continue;
        KostiTableArea[i] = CreateDynamicSphere(
            KostiTablePos[i][0],
            KostiTablePos[i][1],
            KostiTablePos[i][2],
            KOSTI_TABLE_AREA_RADIUS,
            -1, -1, -1, 50.0
        );
    }
    return 1;
}

// ============================================================================
// Создание зоны раздевалки
// ============================================================================
stock Kosti_CreateDressArea()
{
    if(KostiDressArea != -1) return 1;
    
    KostiDressArea = CreateDynamicSphere(
        KOSTI_DRESS_X,
        KOSTI_DRESS_Y,
        KOSTI_DRESS_Z,
        KOSTI_DRESS_RADIUS,
        -1, -1, -1, 50.0
    );
    
    // Создаем актера для раздевалки
    CreateActorEx(
        "", 
        "{FFFF00}Раздевалка\n{FFFFFF}Подойдите для взаимодействия с персонажем", 
        170, 
        2516.653320, 
        2488.738281, 
        2501.078125, 
        326.203186, 
        293, 
        1, 
        1
    );
    
    return 1;
}

// ============================================================================
// Проверка зоны стола
// ============================================================================
stock Kosti_IsTableArea(areaid)
{
    for(new i; i < KOSTI_TABLES_COUNT; i++)
    {
        if(KostiTableArea[i] != -1 && areaid == KostiTableArea[i]) return 1;
    }
    return 0;
}

// ============================================================================
// Показ уведомления о столе
// ============================================================================
stock Kosti_ShowTableNotification(playerid)
{
    ShowNotificationKirill(playerid, 4, 10, NOTIFCMD_BLACKJACK, 0, 
        "\xc6\xe5\xeb\xe0\xe5\xf2\xe5 \xf1\xfb\xe3\xf0\xe0\xf2\xfc \xe2 \xca\xee\xf1\xf2\xe8?", 
        "\xf2\xfb\xea"
    );
    return 1;
}

// ============================================================================
// Обработка входа в зону
// ============================================================================
stock Kosti_OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(Kosti_IsTableArea(areaid))
    {
        Kosti_ShowTableNotification(playerid);
        return 1;
    }
    
    if(areaid == KostiDressArea)
    {
        ShowNotification(playerid, 4, "Взаимодействовать by west", 3, "/west", ">>");
        return 1;
    }
    
    return 0;
}

// ============================================================================
// Обработка уведомлений
// ============================================================================
stock Kosti_OnNotification(playerid, notificationid)
{
    if(notificationid == NOTIFCMD_BLACKJACK)
    {
        Kosti_Join(playerid);
        return 1;
    }
    return 0;
}

// ============================================================================
// Выдача работы крупье
// ============================================================================
stock Kosti_GiveKrupierJob(playerid)
{
    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Сначала авторизуйтесь.");
        return 1;
    }

    if(KostiBetDone[playerid])
    {
        if(!KostiRoundStarted)
        {
            GivePlayerMoneyEx(playerid, KOSTI_BET_SUM, "Krupier bet refund", true, true);
            if(KostiBank >= KOSTI_BET_SUM) KostiBank -= KOSTI_BET_SUM;
        }
        KostiBetDone[playerid] = false;
    }

    KostiKrupier[playerid] = true;
    PlayerOldSkin[playerid] = GetPlayerSkin(playerid);
    SetPlayerData(playerid, P_SKIN, KOSTI_KRUPIER_JOB_SKIN);
    UpdatePlayerDatabaseInt(playerid, "skin", KOSTI_KRUPIER_JOB_SKIN);
    SetPlayerSkin(playerid, KOSTI_KRUPIER_JOB_SKIN);

    SendClientMessage(playerid, 0xF28C28FF, "Вы устроились крупье. Вам выдан скин 173.");
    SendClientMessage(playerid, 0xFFFFFFFF, "Откройте /kosti и играйте за столом как крупье.");
    Kosti_UpdatePlayerTD(playerid);
    return 1;
}

// ============================================================================
// Обработка подбора пикапа
// ============================================================================
stock Kosti_OnPlayerPickUpPickup(playerid, pickupid)
{
    if(KostiKrupierJobPickup != -1 && pickupid == KostiKrupierJobPickup)
    {
        Kosti_GiveKrupierJob(playerid);
        return 1;
    }
    return 0;
}

// ============================================================================
// Создание TD для игрока
// ============================================================================
stock Kosti_CreatePlayerTD(playerid)
{
    if(KostiTDCreated[playerid]) return 1;

    // main background
    KostiTD[playerid][0] = CreatePlayerTextDraw(playerid, 486.000000, 58.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][0], 148.000000, 188.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][0], 0x141414D4);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][0], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][0], 4);

    // Заголовок стола
    KostiTD[playerid][1] = CreatePlayerTextDraw(playerid, 560.000000, 64.000000, "\xd1\xf2\xee\xeb 4");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][1], 0.330000, 1.420000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][1], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][1], 0xFFD85CFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][1], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][1], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][1], 1);

    // Ставка
    KostiTD[playerid][2] = CreatePlayerTextDraw(playerid, 560.000000, 86.000000, "\xd1\xf2\xe0\xe2\xea\xe0: 1000000");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][2], 0.235000, 1.060000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][2], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][2], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][2], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][2], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][2], 1);

    // Общий банк
    KostiTD[playerid][3] = CreatePlayerTextDraw(playerid, 560.000000, 101.000000, "\xce\xe1\xf9\xe8\xe9 \xe1\xe0\xed\xea: 0");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][3], 0.235000, 1.060000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][3], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][3], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][3], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][3], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][3], 1);

    // Баланс
    KostiTD[playerid][4] = CreatePlayerTextDraw(playerid, 560.000000, 116.000000, "\xc1\xe0\xeb\xe0\xed\xf1: 0");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][4], 0.235000, 1.060000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][4], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][4], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][4], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][4], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][4], 1);

    // Статус
    KostiTD[playerid][13] = CreatePlayerTextDraw(playerid, 560.000000, 131.000000, "\xd1\xf2\xe0\xf2\xf3\xf1: \xe8\xe3\xf0\xee\xea");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][13], 0.185000, 0.860000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][13], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][13], 0xEAEAEAFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][13], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][13], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][13], 1);

    // Разделитель
    KostiTD[playerid][5] = CreatePlayerTextDraw(playerid, 497.000000, 146.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][5], 126.000000, 2.200000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][5], 0xF04A2CFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][5], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][5], 4);

    // Пустое место для списка игроков
    KostiTD[playerid][14] = CreatePlayerTextDraw(playerid, 501.000000, 152.000000, " ");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][14], 0.200000, 0.900000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][14], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][14], 0x00000000);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][14], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][14], 2);

    // Список игроков
    KostiTD[playerid][6] = CreatePlayerTextDraw(playerid, 502.500000, 153.000000, "-");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][6], 0.235000, 1.020000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][6], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][6], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][6], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][6], 1);

    // Кнопка "Сделать ставку" (фон)
    KostiTD[playerid][7] = CreatePlayerTextDraw(playerid, 497.000000, 215.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][7], 60.000000, 18.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][7], 0xEF7F1AFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][7], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][7], 4);
    PlayerTextDrawSetSelectable(playerid, KostiTD[playerid][7], 1);

    // Кнопка "Сделать ставку" (текст)
    KostiTD[playerid][8] = CreatePlayerTextDraw(playerid, 527.000000, 218.000000, "\xd1\xc4\xc5\xcb\xc0\xd2\xdc \xd1\xd2\xc0\xc2\xca\xd3");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][8], 0.122000, 0.780000);
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][8], 60.000000, 15.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][8], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][8], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][8], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][8], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][8], 1);
    PlayerTextDrawSetSelectable(playerid, KostiTD[playerid][8], 1);

    // Кнопка "Бросить кости" (фон)
    KostiTD[playerid][9] = CreatePlayerTextDraw(playerid, 563.000000, 215.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][9], 60.000000, 18.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][9], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][9], 0xEF7F1AFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][9], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][9], 4);
    PlayerTextDrawSetSelectable(playerid, KostiTD[playerid][9], 1);

    // Кнопка "Бросить кости" (текст)
    KostiTD[playerid][10] = CreatePlayerTextDraw(playerid, 593.000000, 218.000000, "\xc1\xd0\xce\xd1\xc8\xd2\xdc \xca\xce\xd1\xd2\xc8");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][10], 0.122000, 0.780000);
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][10], 60.000000, 15.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][10], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][10], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][10], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][10], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, KostiTD[playerid][10], 1);

    // Кнопка "Выход" (фон)
    KostiTD[playerid][11] = CreatePlayerTextDraw(playerid, 529.000000, 236.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][11], 63.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][11], 1);
    PlayerTextDrawColor(playerid, KostiTD[playerid][11], 0x303030E0);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][11], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][11], 4);
    PlayerTextDrawSetSelectable(playerid, KostiTD[playerid][11], 1);

    // Кнопка "Выход" (текст)
    KostiTD[playerid][12] = CreatePlayerTextDraw(playerid, 560.500000, 237.000000, "\xc2\xdb\xd5\xce\xc4");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][12], 0.165000, 0.740000);
    PlayerTextDrawTextSize(playerid, KostiTD[playerid][12], 63.000000, 12.000000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][12], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][12], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][12], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][12], 2);
    PlayerTextDrawSetOutline(playerid, KostiTD[playerid][12], 1);
    PlayerTextDrawSetSelectable(playerid, KostiTD[playerid][12], 1);

    // Пустое место
    KostiTD[playerid][15] = CreatePlayerTextDraw(playerid, 560.000000, 251.000000, " ");
    PlayerTextDrawLetterSize(playerid, KostiTD[playerid][15], 0.120000, 0.620000);
    PlayerTextDrawAlignment(playerid, KostiTD[playerid][15], 2);
    PlayerTextDrawColor(playerid, KostiTD[playerid][15], 0x00000000);
    PlayerTextDrawBackgroundColor(playerid, KostiTD[playerid][15], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTD[playerid][15], 2);

    // Таймер
    KostiTimerTD[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 334.000000, "");
    PlayerTextDrawLetterSize(playerid, KostiTimerTD[playerid], 0.660000, 2.350000);
    PlayerTextDrawAlignment(playerid, KostiTimerTD[playerid], 2);
    PlayerTextDrawColor(playerid, KostiTimerTD[playerid], 0x29E35FFF);
    PlayerTextDrawBackgroundColor(playerid, KostiTimerTD[playerid], 0x00000000);
    PlayerTextDrawFont(playerid, KostiTimerTD[playerid], 2);
    PlayerTextDrawSetOutline(playerid, KostiTimerTD[playerid], 1);

    KostiTDCreated[playerid] = true;
    return 1;
}

// ============================================================================
// Уничтожение TD игрока
// ============================================================================
stock Kosti_DestroyPlayerTD(playerid)
{
    if(!KostiTDCreated[playerid]) return 1;

    for(new i; i < KOSTI_TD_COUNT; i++)
    {
        PlayerTextDrawDestroy(playerid, KostiTD[playerid][i]);
    }
    PlayerTextDrawDestroy(playerid, KostiTimerTD[playerid]);

    KostiTDCreated[playerid] = false;
    return 1;
}

// ============================================================================
// Показ TD игрока
// ============================================================================
stock Kosti_ShowPlayerTD(playerid)
{
    Kosti_CreatePlayerTD(playerid);
    for(new i; i < KOSTI_TD_COUNT; i++) PlayerTextDrawShow(playerid, KostiTD[playerid][i]);
    Kosti_UpdatePlayerTD(playerid);
    SelectTextDraw(playerid, 0xFF8B2FAA);
    return 1;
}

// ============================================================================
// Скрытие TD игрока
// ============================================================================
stock Kosti_HidePlayerTD(playerid)
{
    if(!KostiTDCreated[playerid]) return 1;
    for(new i; i < KOSTI_TD_COUNT; i++) PlayerTextDrawHide(playerid, KostiTD[playerid][i]);
    PlayerTextDrawHide(playerid, KostiTimerTD[playerid]);
    CancelSelectTextDraw(playerid);
    return 1;
}

// ============================================================================
// Получение количества игроков
// ============================================================================
stock Kosti_GetPlayersCount()
{
    new count;
    foreach(new i : Player)
    {
        if(KostiInTable[i] && !KostiKrupier[i]) count++;
    }
    return count;
}

// ============================================================================
// Получение количества ставок
// ============================================================================
stock Kosti_GetBetsCount()
{
    new count;
    foreach(new i : Player)
    {
        if(KostiInTable[i] && !KostiKrupier[i] && KostiBetDone[i]) count++;
    }
    return count;
}

// ============================================================================
// Обновление TD игрока
// ============================================================================
stock Kosti_UpdatePlayerTD(playerid)
{
    if(!KostiTDCreated[playerid]) return 1;

    new str[512], money[32];
    Kosti_FormatMoney(KOSTI_BET_SUM, money, sizeof money);
    format(str, sizeof str, "\xd1\xf2\xe0\xe2\xea\xe0: %s", money);
    PlayerTextDrawSetString(playerid, KostiTD[playerid][2], str);

    Kosti_FormatMoney(KostiBank, money, sizeof money);
    format(str, sizeof str, "\xce\xe1\xf9\xe8\xe9 \xe1\xe0\xed\xea: %s", money);
    PlayerTextDrawSetString(playerid, KostiTD[playerid][3], str);

    Kosti_FormatMoney(GetPlayerMoneyEx(playerid), money, sizeof money);
    format(str, sizeof str, "\xc1\xe0\xeb\xe0\xed\xf1: %s", money);
    PlayerTextDrawSetString(playerid, KostiTD[playerid][4], str);

    format(str, sizeof str, "\xd1\xf2\xe0\xf2\xf3\xf1: %s", 
        KostiKrupier[playerid] ? ("\xea\xf0\xf3\xef\xfc\xe5") : ("\xe8\xe3\xf0\xee\xea")
    );
    PlayerTextDrawSetString(playerid, KostiTD[playerid][13], str);

    new list[512], player_name[MAX_PLAYER_NAME], shown;
    list[0] = EOS;
    foreach(new i : Player)
    {
        if(!KostiInTable[i] || KostiKrupier[i]) continue;

        GetPlayerName(i, player_name, sizeof player_name);
        format(list, sizeof list, "%s%s%s%s", 
            list, 
            shown > 0 ? ("~n~") : (""), 
            player_name, 
            KostiBetDone[i] ? (" +") : ("")
        );

        shown++;
        if(shown >= 10) break;
    }
    if(!shown) format(list, sizeof list, "-");
    PlayerTextDrawSetString(playerid, KostiTD[playerid][6], list);

    return 1;
}

// ============================================================================
// Обновление всех TD
// ============================================================================
stock Kosti_UpdateAllTD()
{
    foreach(new i : Player)
    {
        if(KostiInTable[i]) Kosti_UpdatePlayerTD(i);
    }
    return 1;
}

// ============================================================================
// Отправка сообщения за стол
// ============================================================================
stock Kosti_SendTableMessage(color, const text[])
{
    foreach(new i : Player)
    {
        if(KostiInTable[i]) SendClientMessage(i, color, text);
    }
    return 1;
}

// ============================================================================
// Присоединение к столу
// ============================================================================
stock Kosti_Join(playerid)
{
    if(!IsPlayerLogged(playerid)) 
        return SendClientMessage(playerid, 0xCECECEFF, "\xd1\xed\xe0\xf7\xe0\xeb\xe0 \xe0\xe2\xf2\xee\xf0\xe8\xe7\xf3\xe9\xf2\xe5\xf1\xfc."), 1;

    KostiInTable[playerid] = true;
    Kosti_ShowPlayerTD(playerid);
    Kosti_UpdateAllTD();

    if(KostiKrupier[playerid])
    {
        SendClientMessage(playerid, 0xF28C28FF, "Panel krupie otkryta. Krupie ne uchastvuet v stavkah.");
    }
    else
    {
        SendClientMessage(playerid, 0xFFCC33FF, 
            "\xc2\xfb \xe2\xee\xf8\xeb\xe8 \xe7\xe0 \xf1\xf2\xee\xeb\xe8\xea \xea\xee\xf1\xf2\xe5\xe9. \xd1\xf2\xe0\xe2\xea\xe0: 1.000.000 \xf0\xf3\xe1."
        );
    }
    return 1;
}

// ============================================================================
// Выход из-за стола
// ============================================================================
stock Kosti_Leave(playerid, bool:disconnect = false)
{
    if(!KostiInTable[playerid]) return 1;

    if(KostiRoundStarted && KostiBetDone[playerid] && !disconnect)
    {
        SendClientMessage(playerid, 0xFF5252FF, 
            "\xcd\xe5\xeb\xfc\xe7\xff \xe2\xfb\xe9\xf2\xe8 \xe2\xee \xe2\xf0\xe5\xec\xff \xe1\xf0\xee\xf1\xea\xe0 \xea\xee\xf1\xf2\xe5\xe9. \xc4\xee\xe6\xe4\xe8\xf2\xe5\xf1\xfc \xea\xee\xed\xf6\xe0 \xf0\xe0\xf3\xed\xe4\xe0."
        );
        return 1;
    }

    if(KostiBetDone[playerid])
    {
        if(!KostiRoundStarted)
        {
            GivePlayerMoneyEx(playerid, KOSTI_BET_SUM, 
                "\xc2\xee\xe7\xe2\xf0\xe0\xf2 \xf1\xf2\xe0\xe2\xea\xe8 \xea\xee\xf1\xf2\xe8", 
                true, true
            );
            if(KostiBank >= KOSTI_BET_SUM) KostiBank -= KOSTI_BET_SUM;
        }
        KostiBetDone[playerid] = false;
    }

    KostiInTable[playerid] = false;
    Kosti_HidePlayerTD(playerid);

    if(Kosti_GetPlayersCount() <= 0 && KostiTimer != -1)
    {
        KillTimer(KostiTimer);
        KostiTimer = -1;
        KostiRoundStarted = false;
        KostiCountdown = 0;
        KostiBank = 0;
    }

    Kosti_UpdateAllTD();
    return 1;
}

// ============================================================================
// Сделать ставку
// ============================================================================
stock Kosti_MakeBet(playerid)
{
    if(!KostiInTable[playerid]) return 1;
    if(KostiKrupier[playerid]) 
        return SendClientMessage(playerid, 0xFF5252FF, "Krupie ne mozhet delat stavku."), 1;
    if(KostiRoundStarted) 
        return SendClientMessage(playerid, 0xFF5252FF, "\xd0\xe0\xf3\xed\xe4 \xf3\xe6\xe5 \xed\xe0\xf7\xe0\xeb\xf1\xff."), 1;
    if(KostiBetDone[playerid]) 
        return SendClientMessage(playerid, 0xFF5252FF, "\xc2\xfb \xf3\xe6\xe5 \xf1\xe4\xe5\xeb\xe0\xeb\xe8 \xf1\xf2\xe0\xe2\xea\xf3."), 1;
    if(GetPlayerMoneyEx(playerid) < KOSTI_BET_SUM) 
        return SendClientMessage(playerid, 0xFF5252FF, "\xd3 \xe2\xe0\xf1 \xed\xe5\xe4\xee\xf1\xf2\xe0\xf2\xee\xf7\xed\xee \xe4\xe5\xed\xe5\xe3 \xe4\xeb\xff \xf1\xf2\xe0\xe2\xea\xe8."), 1;

    GivePlayerMoneyEx(playerid, -KOSTI_BET_SUM, "\xd1\xf2\xe0\xe2\xea\xe0 \xe2 \xea\xee\xf1\xf2\xe8", true, true);
    KostiBetDone[playerid] = true;
    KostiBank += KOSTI_BET_SUM;

    new str[144];
    format(str, sizeof str, 
        "%s \xf1\xe4\xe5\xeb\xe0\xeb \xf1\xf2\xe0\xe2\xea\xf3 1.000.000 \xf0\xf3\xe1. \xce\xe1\xf9\xe8\xe9 \xe1\xe0\xed\xea: %d", 
        GetPlayerNameEx(playerid), 
        KostiBank
    );
    Kosti_SendTableMessage(0xFFCC33FF, str);

    Kosti_UpdateAllTD();
    return 1;
}

// ============================================================================
// Начать раунд
// ============================================================================
stock Kosti_StartRound(playerid)
{
    if(!KostiInTable[playerid]) return 1;
    if(!KostiKrupier[playerid]) 
        return SendClientMessage(playerid, 0xFF5252FF, "\xc1\xf0\xee\xf1\xe0\xf2\xfc \xea\xee\xf1\xf2\xe8 \xec\xee\xe6\xe5\xf2 \xf2\xee\xeb\xfc\xea\xee \xea\xf0\xf3\xef\xfc\xe5."), 1;
    if(KostiRoundStarted) 
        return SendClientMessage(playerid, 0xFF5252FF, "\xd0\xe0\xf3\xed\xe4 \xf3\xe6\xe5 \xe8\xe4\xe5\xf2."), 1;
    if(Kosti_GetBetsCount() < 2) 
        return SendClientMessage(playerid, 0xFF5252FF, "\xcd\xf3\xe6\xed\xee \xec\xe8\xed\xe8\xec\xf3\xec 2 \xe8\xe3\xf0\xee\xea\xe0 \xf1\xee \xf1\xf2\xe0\xe2\xea\xee\xe9."), 1;

    KostiRoundStarted = true;
    KostiCountdown = KOSTI_COUNTDOWN_SECONDS;

    foreach(new i : Player)
    {
        if(!KostiInTable[i]) continue;
        PlayerTextDrawSetString(i, KostiTimerTD[i], "9");
        PlayerTextDrawShow(i, KostiTimerTD[i]);
    }

    if(KostiTimer != -1) KillTimer(KostiTimer);
    KostiTimer = SetTimer("Kosti_CountdownTick", 1000, true);
    return 1;
}

// ============================================================================
// Завершить раунд
// ============================================================================
stock Kosti_FinishRound()
{
    if(KostiTimer != -1)
    {
        KillTimer(KostiTimer);
        KostiTimer = -1;
    }

    foreach(new i : Player)
    {
        if(KostiInTable[i]) PlayerTextDrawHide(i, KostiTimerTD[i]);
    }

    new winner = INVALID_PLAYER_ID;
    new bestScore = -1;
    new winners[MAX_PLAYERS], winnersCount;
    new score[MAX_PLAYERS];
    new str[160];

    foreach(new i : Player)
    {
        if(!KostiInTable[i] || KostiKrupier[i] || !KostiBetDone[i]) continue;

        score[i] = 2 + random(10);
        format(str, sizeof str, "%s \xe2\xfb\xe1\xf0\xee\xf1\xe8\xeb %d \xee\xf7\xea\xee\xe2.", 
            GetPlayerNameEx(i), 
            score[i]
        );
        Kosti_SendTableMessage(0xFFFFFFFF, str);

        if(score[i] > bestScore)
        {
            bestScore = score[i];
            winnersCount = 0;
            winners[winnersCount++] = i;
        }
        else if(score[i] == bestScore)
        {
            winners[winnersCount++] = i;
        }
    }

    if(winnersCount > 0) winner = winners[random(winnersCount)];

    if(winner != INVALID_PLAYER_ID)
    {
        new prize = KostiBank - ((KostiBank * KOSTI_COMMISSION_PERCENT) / 100);
        GivePlayerMoneyEx(winner, prize, "\xc2\xfb\xe8\xe3\xf0\xfb\xf8 \xe2 \xea\xee\xf1\xf2\xe8", true, true);

        format(str, sizeof str, 
            "\xcf\xee\xe1\xe5\xe4\xe8\xeb %s: %d \xee\xf7\xea\xee\xe2. \xc2\xfb\xe8\xe3\xf0\xfb\xf8: %d \xf0\xf3\xe1. \xca\xee\xec\xe8\xf1\xf1\xe8\xff: 5%%.", 
            GetPlayerNameEx(winner), 
            bestScore, 
            prize
        );
        Kosti_SendTableMessage(0x66CC00FF, str);
    }
    else
    {
        Kosti_SendTableMessage(0xFF5252FF, 
            "\xd0\xe0\xf3\xed\xe4 \xee\xf2\xec\xe5\xed\xe5\xed: \xed\xe5\xf2 \xe8\xe3\xf0\xee\xea\xee\xe2 \xf1\xee \xf1\xf2\xe0\xe2\xea\xee\xe9."
        );
    }

    foreach(new i : Player)
    {
        if(KostiBetDone[i]) KostiBetDone[i] = false;
    }

    KostiBank = 0;
    KostiRoundStarted = false;
    KostiCountdown = 0;
    Kosti_UpdateAllTD();
    return 1;
}

// ============================================================================
// Таймер обратного отсчета
// ============================================================================
public Kosti_CountdownTick()
{
    if(!KostiRoundStarted)
    {
        if(KostiTimer != -1) KillTimer(KostiTimer);
        KostiTimer = -1;
        return 1;
    }

    KostiCountdown--;

    new str[16];
    format(str, sizeof str, "%d", (KostiCountdown < 0 ? 0 : KostiCountdown));

    foreach(new i : Player)
    {
        if(!KostiInTable[i]) continue;
        PlayerTextDrawSetString(i, KostiTimerTD[i], str);
        PlayerTextDrawShow(i, KostiTimerTD[i]);
    }

    if(KostiCountdown < 0)
    {
        Kosti_FinishRound();
        return 1;
    }
    return 1;
}

// ============================================================================
// Обработка клика по TD
// ============================================================================
stock Kosti_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(!KostiTDCreated[playerid]) return 0;

    if(playertextid == KostiTD[playerid][7] || playertextid == KostiTD[playerid][8])
    {
        Kosti_MakeBet(playerid);
        return 1;
    }
    if(playertextid == KostiTD[playerid][9] || playertextid == KostiTD[playerid][10])
    {
        Kosti_StartRound(playerid);
        return 1;
    }
    if(playertextid == KostiTD[playerid][11] || playertextid == KostiTD[playerid][12])
    {
        Kosti_Leave(playerid);
        return 1;
    }
    return 0;
}

// ============================================================================
// Обработка отключения игрока
// ============================================================================
stock Kosti_OnPlayerDisconnect(playerid)
{
    Kosti_Leave(playerid, true);
    KostiKrupier[playerid] = false;
    Kosti_DestroyPlayerTD(playerid);
    return 1;
}

// ============================================================================
// Команда /kosti - присоединиться к столу
// ============================================================================
CMD:kosti(playerid, params[])
{
    return Kosti_Join(playerid);
}

// ============================================================================
// Команда /givekrupa - выдать права крупье (админ)
// ============================================================================
CMD:givekrupa(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xCECECEFF, 
            "\xca\xee\xec\xe0\xed\xe4\xe0 \xe4\xee\xf1\xf2\xf3\xef\xed\xe0 \xf2\xee\xeb\xfc\xea\xee \xe0\xe4\xec\xe8\xed\xe8\xf1\xf2\xf0\xe0\xf6\xe8\xe8."
        ), 1;

    new targetid;
    if(sscanf(params, "u", targetid)) 
        return SendClientMessage(playerid, 0xCECECEFF, "\xc8\xf1\xef\xee\xeb\xfc\xe7\xf3\xe9\xf2\xe5: /givekrupa [id \xe8\xe3\xf0\xee\xea\xe0]"), 1;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) 
        return SendClientMessage(playerid, 0xCECECEFF, "\xc8\xe3\xf0\xee\xea \xed\xe5 \xed\xe0\xe9\xe4\xe5\xed."), 1;

    if(KostiBetDone[targetid])
    {
        if(!KostiRoundStarted)
        {
            GivePlayerMoneyEx(targetid, KOSTI_BET_SUM, "Krupier bet refund", true, true);
            if(KostiBank >= KOSTI_BET_SUM) KostiBank -= KOSTI_BET_SUM;
        }
        KostiBetDone[targetid] = false;
    }
    KostiKrupier[targetid] = true;
    Kosti_UpdateAllTD();

    new str[144];
    format(str, sizeof str, 
        "\xc2\xfb \xe2\xfb\xe4\xe0\xeb\xe8 \xef\xf0\xe0\xe2\xe0 \xea\xf0\xf3\xef\xfc\xe5 \xe8\xe3\xf0\xee\xea\xf3 %s.", 
        GetPlayerNameEx(targetid)
    );
    SendClientMessage(playerid, 0x66CC00FF, str);
    SendClientMessage(targetid, 0x66CC00FF, 
        "\xc2\xe0\xec \xe2\xfb\xe4\xe0\xeb\xe8 \xef\xf0\xe0\xe2\xe0 \xea\xf0\xf3\xef\xfc\xe5. \xce\xf2\xea\xf0\xee\xe9\xf2\xe5 /kosti \xe8 \xed\xe0\xe6\xec\xe8\xf2\xe5 '\xc1\xf0\xee\xf1\xe8\xf2\xfc \xea\xee\xf1\xf2\xe8'."
    );
    return 1;
}

// ============================================================================
// Команда /takekrupa - снять права крупье (админ)
// ============================================================================
CMD:takekrupa(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xCECECEFF, 
            "\xca\xee\xec\xe0\xed\xe4\xe0 \xe4\xee\xf1\xf2\xf3\xef\xed\xe0 \xf2\xee\xeb\xfc\xea\xee \xe0\xe4\xec\xe8\xed\xe8\xf1\xf2\xf0\xe0\xf6\xe8\xe8."
        ), 1;

    new targetid;
    if(sscanf(params, "u", targetid)) 
        return SendClientMessage(playerid, 0xCECECEFF, "\xc8\xf1\xef\xee\xeb\xfc\xe7\xf3\xe9\xf2\xe5: /takekrupa [id \xe8\xe3\xf0\xee\xea\xe0]"), 1;
    if(!IsPlayerConnected(targetid)) 
        return SendClientMessage(playerid, 0xCECECEFF, "\xc8\xe3\xf0\xee\xea \xed\xe5 \xed\xe0\xe9\xe4\xe5\xed."), 1;

    KostiKrupier[targetid] = false;
    Kosti_UpdateAllTD();

    SendClientMessage(playerid, 0x66CC00FF, "\xcf\xf0\xe0\xe2\xe0 \xea\xf0\xf3\xef\xfc\xe5 \xf1\xed\xff\xf2\xfb.");
    SendClientMessage(targetid, 0xFF5252FF, 
        "\xd1 \xe2\xe0\xf1 \xf1\xed\xff\xeb\xe8 \xef\xf0\xe0\xe2\xe0 \xea\xf0\xf3\xef\xfc\xe5."
    );
    return 1;
}

// ============================================================================
// Команда /west - раздевалка казино
// ============================================================================
CMD:west(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xCECECEFF, 
            "\xca\xee\xec\xe0\xed\xe4\xe0 \xe4\xee\xf1\xf2\xf3\xef\xed\xe0 \xf2\xee\xeb\xfc\xea\xee \xe0\xe4\xec\xe8\xed\xe8\xf1\xf2\xf0\xe0\xf6\xe8\xe8."
        ), 1;
    
    ShowPlayerDialog(playerid, DIALOG_DICE, DIALOG_STYLE_LIST, 
        "{EB4C42}"SERVER_NAME" | {FFFFFF}\xca\xc0\xc7\xc8\xcd\xce",
        "{EB4C42}1. {FFFFFF}\xcf\xe5\xf0\xe5\xee\xe4\xe5\xf2\xfc\xf1\xff \xe2 \xec\xe5\xed\xe5\xe4\xe6\xe5\xf0\xe0\n\
        {EB4C42}2. {FFFFFF}\xcf\xe5\xf0\xe5\xee\xe4\xe5\xf2\xfc\xf1\xff \xe2 \xea\xf0\xf3\xef\xfc\xe5\n\
        {EB4C42}3. {FFFFFF}\xcf\xe5\xf0\xe5\xee\xe4\xe5\xf2\xfc\xf1\xff \xe2 \xee\xf5\xf0\xe0\xed\xed\xe8\xea\xe0\n\
        {EB4C42}4. {FFFFFF}\xd1\xed\xff\xf2\xfc \xf4\xee\xf0\xec\xf3",
        "\xc2\xfb\xe1\xf0\xe0\xf2\xfc", "\xc7\xe0\xea\xf0\xfb\xf2\xfc"
    );
    return 1;
}

// ============================================================================
// Обработка диалога раздевалки
// ============================================================================
stock Kosti_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_DICE)
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: // Менеджер
            {
                PlayerOldSkin[playerid] = GetPlayerSkin(playerid);
                SetPlayerSkin(playerid, KOSTI_SKIN_MANAGER);
                SendClientMessage(playerid, 0x66CC00FF, "\xc2\xfb \xed\xe0\xf7\xe0\xeb\xe8 \xf0\xe0\xe1\xee\xf2\xe0\xf2\xfc \xec\xe5\xed\xe5\xe4\xe6\xe5\xf0\xee\xec, \xe2\xe2\xe5\xe4\xe8\xf2\xe5 \xea\xee\xec\xe0\xed\xe4\xf3 /westwork");
                SendClientMessage(playerid, 0xFFFFFFFF, "\xc8\xe3\xf0\xee\xea \xef\xe5\xf0\xe5\xee\xe4\xe5\xeb\xf1\xff \xe2 \xf1\xea\xe8\xed \xec\xe5\xed\xe5\xe4\xe6\xe5\xf0\xe0 \xea\xe0\xe7\xe8\xed\xee");
            }
            case 1: // Крупье
            {
                PlayerOldSkin[playerid] = GetPlayerSkin(playerid);
                SetPlayerSkin(playerid, KOSTI_SKIN_DEALER);
                SendClientMessage(playerid, 0xFFFFFFFF, "\xc2\xfb \xef\xe5\xf0\xe5\xee\xe4\xe5\xeb\xe8\xf1\xfc \xe2 \xea\xf0\xf3\xef\xfc\xe5");
            }
            case 2: // Охранник
            {
                PlayerOldSkin[playerid] = GetPlayerSkin(playerid);
                SetPlayerSkin(playerid, KOSTI_SKIN_GUARD);
                SendClientMessage(playerid, 0xFFFFFFFF, "\xc2\xfb \xef\xe5\xf0\xe5\xee\xe4\xe5\xeb\xe8\xf1\xfc \xe2 \xee\xf5\xf0\xe0\xed\xed\xe8\xea\xe0");
            }
            case 3: // Снять форму
            {
                if(PlayerOldSkin[playerid] != 0)
                {
                    SetPlayerSkin(playerid, PlayerOldSkin[playerid]);
                    SendClientMessage(playerid, 0x66CC00FF, "\xc2\xfb \xf1\xed\xff\xeb\xe8 \xf4\xee\xf0\xec\xf3 \xea\xe0\xe7\xe8\xed\xee");
                    PlayerOldSkin[playerid] = 0;
                }
                else
                {
                    SendClientMessage(playerid, 0xFF5252FF, "\xc2\xfb \xed\xe5 \xed\xe0\xe4\xe5\xe2\xe0\xeb\xe8 \xf4\xee\xf0\xec\xf3 \xea\xe0\xe7\xe8\xed\xee");
                }
            }
        }
        return 1;
    }
    return 0;
}