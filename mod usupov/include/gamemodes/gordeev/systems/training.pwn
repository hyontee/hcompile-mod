// =====================================================
// training.pwn
// Полная система обучения с сохранением этапов
// =====================================================

// ========== Константы этапов ==========
#define TRAINING_STAGE_NONE         0
#define TRAINING_STAGE_INTRO        1
#define TRAINING_STAGE_CAR          2
#define TRAINING_STAGE_MINER        3
#define TRAINING_STAGE_FINISHED     99

// ========== Виртуальный мир ==========
#define TRAINING_VW_BASE            10000

// ========== Координаты спавна игрока ==========
#define TRAINING_PLAYER_X           2740.699462
#define TRAINING_PLAYER_Y           -2440.952880
#define TRAINING_PLAYER_Z           21.781099
#define TRAINING_PLAYER_A           274.623809

// ========== Координаты Дяди Кирилла ==========
#define TRAINING_NPC_X              2753.344970
#define TRAINING_NPC_Y              -2443.316894
#define TRAINING_NPC_Z              21.781099
#define TRAINING_NPC_A              62.520877

// ========== Координаты машины ==========
#define TRAINING_CAR_X              2753.814941
#define TRAINING_CAR_Y              -2420.092773
#define TRAINING_CAR_Z              21.679512
#define TRAINING_CAR_A              312.424622
#define TRAINING_CAR_MODEL          2582

// ========== Координаты шахты ==========
#define TRAINING_MINER_X            2268.8354
#define TRAINING_MINER_Y            506.1029
#define TRAINING_MINER_Z            16.7323

// ========== ID диалогов ==========
#define DIALOG_TRAINING_INTRO       50100

// ========== ID иконок на карте ==========
#define TRAINING_ICON_CAR           250
#define TRAINING_ICON_MINER         251

// ========== Переменные ==========
new g_TrainingStage[MAX_PLAYERS];
new g_TrainingActor[MAX_PLAYERS];
new g_TrainingLabel[MAX_PLAYERS];
new g_TrainingCar[MAX_PLAYERS];

// ========== Forward ==========
forward Training_OnPlayerConnect(playerid);
forward Training_OnPlayerDisconnect(playerid);
forward StartTraining(playerid);
forward StopTraining(playerid);
forward ContinueTraining(playerid);
forward SaveTrainingStage(playerid);
forward Training_EnsureSchema();

forward Training_CallMessage1(playerid);
forward Training_CallMessage2(playerid);
forward Training_CallMessage3(playerid);
forward Training_CallMessage4(playerid);

// ========== Инициализация схемы БД ==========
public Training_EnsureSchema()
{
    new query[128];
    mysql_format(mysql, query, sizeof query, "SELECT training_stage FROM accounts LIMIT 1");
    new Cache:result = mysql_query(mysql, query);
    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE accounts ADD COLUMN training_stage INT NOT NULL DEFAULT 0", false);
        print("[Training] Добавлена колонка training_stage в таблицу accounts");
    }
    cache_delete(result);
    return 1;
}

// ========== Загрузка этапа из БД ==========
public LoadTrainingStageFromDB(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof query, 
        "SELECT training_stage FROM accounts WHERE id=%d LIMIT 1", 
        GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    if(cache_num_rows())
    {
        g_TrainingStage[playerid] = cache_get_field_content_int(0, "training_stage");
    }
    cache_delete(result);
    return g_TrainingStage[playerid];
}

// ========== Сохранение этапа в БД ==========
public SaveTrainingStage(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new query[128];
    mysql_format(mysql, query, sizeof query, 
        "UPDATE accounts SET training_stage=%d WHERE id=%d LIMIT 1", 
        g_TrainingStage[playerid], GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return 1;
}

// ========== Подключение игрока ==========
public Training_OnPlayerConnect(playerid)
{
    g_TrainingStage[playerid] = TRAINING_STAGE_NONE;
    g_TrainingActor[playerid] = -1;
    g_TrainingLabel[playerid] = Text3D:-1;
    g_TrainingCar[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

// ========== Отключение игрока ==========
public Training_OnPlayerDisconnect(playerid)
{
    StopTraining(playerid);
    return 1;
}

// ========== Создание Дяди Кирилла ==========
stock CreateTrainingNPC(playerid)
{
    if(g_TrainingActor[playerid] != -1) return 1;
    
    new vw = GetPlayerVirtualWorld(playerid);
    
    g_TrainingActor[playerid] = CreateActor(18, TRAINING_NPC_X, TRAINING_NPC_Y, TRAINING_NPC_Z, TRAINING_NPC_A);
    SetActorVirtualWorld(g_TrainingActor[playerid], vw);
    SetActorInvulnerable(g_TrainingActor[playerid], true);
    
    g_TrainingLabel[playerid] = Create3DTextLabel(
        "{FFFF00}Дядя Кирилл\n{808080}Подойдите для взаимодействия",
        0xFFFF00FF,
        TRAINING_NPC_X, TRAINING_NPC_Y, TRAINING_NPC_Z + 0.5,
        15.0, vw, 0);
    
    return 1;
}

// ========== Удаление NPC ==========
stock DestroyTrainingNPC(playerid)
{
    if(g_TrainingActor[playerid] != -1)
    {
        DestroyActor(g_TrainingActor[playerid]);
        g_TrainingActor[playerid] = -1;
    }
    if(g_TrainingLabel[playerid] != Text3D:-1)
    {
        Delete3DTextLabel(g_TrainingLabel[playerid]);
        g_TrainingLabel[playerid] = Text3D:-1;
    }
    return 1;
}

// ========== Создание машины ==========
stock CreateTrainingCar(playerid)
{
    if(g_TrainingCar[playerid] != INVALID_VEHICLE_ID) return 1;
    
    new vw = GetPlayerVirtualWorld(playerid);
    
    g_TrainingCar[playerid] = CreateVehicle(
        TRAINING_CAR_MODEL,
        TRAINING_CAR_X, TRAINING_CAR_Y, TRAINING_CAR_Z, TRAINING_CAR_A,
        -1, -1, -1);
    SetVehicleVirtualWorld(g_TrainingCar[playerid], vw);
    
    SetPlayerMapIcon(playerid, TRAINING_ICON_CAR, 
        TRAINING_CAR_X, TRAINING_CAR_Y, TRAINING_CAR_Z, 
        55, 0xFFFF00FF, MAPICON_LOCAL);
    
    return 1;
}

// ========== Удаление машины ==========
stock DestroyTrainingCar(playerid)
{
    if(g_TrainingCar[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(g_TrainingCar[playerid]);
        g_TrainingCar[playerid] = INVALID_VEHICLE_ID;
    }
    RemovePlayerMapIcon(playerid, TRAINING_ICON_CAR);
    return 1;
}

// ========== Запуск обучения ==========
public StartTraining(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(g_TrainingStage[playerid] != TRAINING_STAGE_NONE) return 0;
    
    // Спавним игрока
    SpawnPlayer(playerid);
    
    // Показываем фон
    ShowPlayerBackground(playerid, 1000, 1000, 1000);
    
    // Устанавливаем виртуальный мир
    new vw = TRAINING_VW_BASE + playerid;
    SetPlayerVirtualWorld(playerid, vw);
    SetPlayerInterior(playerid, 0);
    
    // Телепортируем игрока
    SetPlayerPos(playerid, TRAINING_PLAYER_X, TRAINING_PLAYER_Y, TRAINING_PLAYER_Z);
    SetPlayerFacingAngle(playerid, TRAINING_PLAYER_A);
    SetCameraBehindPlayer(playerid);
    
    // Создаём NPC с задержкой
    SetTimerEx("CreateTrainingNPCDelayed", 500, false, "i", playerid);
    
    // Устанавливаем первый этап
    g_TrainingStage[playerid] = TRAINING_STAGE_INTRO;
    
    // Сохраняем в БД
    SaveTrainingStage(playerid);
    
    SendClientMessage(playerid, 0xFFFF00FF, "[Обучение] Добро пожаловать! Подойдите к Дяде Кириллу для начала обучения.");
    
    return 1;
}

// ========== Таймер создания NPC ==========
forward CreateTrainingNPCDelayed(playerid);
public CreateTrainingNPCDelayed(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    CreateTrainingNPC(playerid);
    return 1;
}

// ========== Остановка обучения ==========
public StopTraining(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    DestroyTrainingNPC(playerid);
    DestroyTrainingCar(playerid);
    
    // Возвращаем в обычный мир
    SetPlayerVirtualWorld(playerid, 0);
    
    return 1;
}

// ========== Продолжение обучения ==========
public ContinueTraining(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    if(g_TrainingStage[playerid] == TRAINING_STAGE_NONE)
        return SendClientMessage(playerid, 0xFF6600FF, "[Обучение] Вы не проходите обучение."), 0;
    
    if(g_TrainingStage[playerid] == TRAINING_STAGE_FINISHED)
        return SendClientMessage(playerid, 0x66CC33FF, "[Обучение] Вы уже завершили обучение."), 0;
    
    // Устанавливаем виртуальный мир
    new vw = TRAINING_VW_BASE + playerid;
    SetPlayerVirtualWorld(playerid, vw);
    SetPlayerInterior(playerid, 0);
    
    // Телепортируем игрока
    SetPlayerPos(playerid, TRAINING_PLAYER_X, TRAINING_PLAYER_Y, TRAINING_PLAYER_Z);
    SetPlayerFacingAngle(playerid, TRAINING_PLAYER_A);
    SetCameraBehindPlayer(playerid);
    
    // Восстанавливаем NPC если нужно
    if(g_TrainingActor[playerid] == -1 && g_TrainingStage[playerid] == TRAINING_STAGE_INTRO)
    {
        CreateTrainingNPC(playerid);
    }
    
    // Восстанавливаем машину если нужно
    if(g_TrainingCar[playerid] == INVALID_VEHICLE_ID && g_TrainingStage[playerid] >= TRAINING_STAGE_CAR)
    {
        CreateTrainingCar(playerid);
    }
    
    SendClientMessage(playerid, 0x66CC33FF, "[Обучение] Вы вернулись к продолжению обучения.");
    return 1;
}

// ========== Показ диалога с Дядей Кириллом ==========
stock ShowTrainingIntroDialog(playerid)
{
    Dialog(playerid, DIALOG_TRAINING_INTRO, DIALOG_STYLE_MSGBOX, 
        "{FA8072}USUPOV RP {FFFFFF}| Обучение",
        "{FFFFFF}С прибытием родной, вижу российские вокзалы не порадовали тебя, но ты не переживай, позволь я тебе помогу, возьми у меня немного денег на первое время и мою машину, и я помогу тебе освоится.",
        "Принять", "");
    return 1;
}

// ========== Завершение первого этапа ==========
stock CompleteTrainingStage1(playerid)
{
    // Зачисляем 2000 рублей
    GivePlayerMoneyEx(playerid, 2000, "Обучение - деньги от Дяди Кирилла", true, true);
    
    // Создаём машину в виртуальном мире
    CreateTrainingCar(playerid);
    
    // Переходим ко второму этапу
    g_TrainingStage[playerid] = TRAINING_STAGE_CAR;
    SaveTrainingStage(playerid);
    
    SendClientMessage(playerid, 0x66CC33FF, "[Обучение] Деньги зачислены! Сядь в машину, чтобы продолжить.");
    return 1;
}

// ========== Звонок при посадке в машину ==========
stock StartTrainingCall(playerid)
{
    SendClientMessage(playerid, 0xFFFFFFFF, "Входящий звонок от {FFFF00}Дяди Кирилла...");
    SetTimerEx("Training_CallMessage1", 2000, false, "i", playerid);
    return 1;
}

// ========== Таймеры звонка ==========
public Training_CallMessage1(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}Дядя Кирилл:{FFFFFF} Здарова ещё раз, вижу ты нашел мой старый телефон в бардачке.");
    SetTimerEx("Training_CallMessage2", 3000, false, "i", playerid);
    return 1;
}

public Training_CallMessage2(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}Вы:{FFFFFF} Ну да.");
    SetTimerEx("Training_CallMessage3", 2000, false, "i", playerid);
    return 1;
}

public Training_CallMessage3(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}Дядя Кирилл:{FFFFFF} Звоню я тебе не просто так, моему дяде на работе нужен хороший человек, его рабочий заболел нужно подменить, деньгами не обидит, поэтому отправляйся на шахту, тебя там мой дядя встретит.");
    SetTimerEx("Training_CallMessage4", 4000, false, "i", playerid);
    return 1;
}

public Training_CallMessage4(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}Дядя Кирилл:{FFFFFF} Звонок окончен.");
    
    // Устанавливаем метку на шахту
    SetPlayerMapIcon(playerid, TRAINING_ICON_MINER, 
        TRAINING_MINER_X, TRAINING_MINER_Y, TRAINING_MINER_Z, 
        55, 0xFFFF00FF, MAPICON_LOCAL);
    
    // Переходим к третьему этапу
    g_TrainingStage[playerid] = TRAINING_STAGE_MINER;
    SaveTrainingStage(playerid);
    
    SendClientMessage(playerid, 0x66CC33FF, "[Обучение] Отправляйтесь на шахту!");
    return 1;
}

// ========== ALS для OnPlayerStateChange ==========
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    // Проверяем посадку в машину обучения
    if(newstate == PLAYER_STATE_DRIVER && g_TrainingStage[playerid] == TRAINING_STAGE_CAR)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid == g_TrainingCar[playerid])
        {
            StartTrainingCall(playerid);
        }
    }
    
    #if defined Training_OnPlayerStateChange
        return Training_OnPlayerStateChange(playerid, newstate, oldstate);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange Training_OnPlayerStateChange

#if defined Training_OnPlayerStateChange
    forward Training_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

// ========== ALS для OnDialogResponse ==========
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TRAINING_INTRO)
    {
        if(response)
        {
            CompleteTrainingStage1(playerid);
        }
        return 1;
    }
    
    #if defined Training_OnDialogResponse
        return Training_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
    return 0;
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Training_OnDialogResponse

#if defined Training_OnDialogResponse
    forward Training_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ========== Команды ==========
CMD:training(playerid, params[])
{
    if(g_TrainingStage[playerid] == TRAINING_STAGE_NONE)
        return SendClientMessage(playerid, 0xFF6600FF, "[Обучение] Вы не проходите обучение."), 0;
    
    if(g_TrainingStage[playerid] == TRAINING_STAGE_FINISHED)
        return SendClientMessage(playerid, 0x66CC33FF, "[Обучение] Вы уже завершили обучение."), 0;
    
    ContinueTraining(playerid);
    return 1;
}

CMD:stoptraining(playerid, params[])
{
    if(g_TrainingStage[playerid] == TRAINING_STAGE_NONE)
        return SendClientMessage(playerid, 0xFF6600FF, "[Обучение] Вы не проходите обучение."), 0;
    
    g_TrainingStage[playerid] = TRAINING_STAGE_FINISHED;
    SaveTrainingStage(playerid);
    StopTraining(playerid);
    
    SendClientMessage(playerid, 0x66CC33FF, "[Обучение] Обучение завершено.");
    return 1;
}

CMD:testtraining(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6)
        return SendClientMessage(playerid, 0xFF6600FF, "[Ошибка] Команда доступна только администраторам 6+ уровня"), 0;
    
    if(!IsPlayerLogged(playerid))
        return SendClientMessage(playerid, 0xFF6600FF, "[Ошибка] Вы должны быть авторизованы"), 0;
    
    if(g_TrainingStage[playerid] != TRAINING_STAGE_NONE)
        return SendClientMessage(playerid, 0xFF6600FF, "[Ошибка] Вы уже в обучении"), 0;
    
    StartTraining(playerid);
    SendClientMessage(playerid, 0x66CC33FF, "[Тест] Обучение запущено!");
    return 1;
}