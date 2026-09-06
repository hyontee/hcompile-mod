#include <a_samp>

#define DRIFT_MIN_SPEED        25.0
#define DRIFT_POINTS_PER_LEVEL 5000
#define MAX_SERVER_VEHICLES    2000
#define DUEL_TIME_LIMIT        60

#define DIALOG_REGISTER      3000
#define DIALOG_LOGIN         3001
#define DIALOG_MAIN_MENU     1000
#define DIALOG_DRIFT_CARS   2000
#define DIALOG_TUNING_MAIN   2001
#define DIALOG_WHEELS        2002
#define DIALOG_TP_CATEGORIES 5000
#define DIALOG_TP_SPECIAL    5001
#define DIALOG_TP_SPOTS      5002
#define DIALOG_TP_CITIES     5003
#define DIALOG_DUEL_INVITE   6000

new DB:gDB;

enum pInfo {
    pPassword[32],
    pDriftPoints,
    pLevel,
    pMoney,
    bool:pIsLoggedIn
}
new PlayerData[MAX_PLAYERS][pInfo];

enum pVehicleInfo {
    vModel,
    vWheels,
    vNitro,
    vHydraulics,
    vSpoiler,
    vColor1,
    vColor2
}
new PlayerVehicle[MAX_PLAYERS][pVehicleInfo];

enum dInfo {
    bool:dActive,
    dPlayer1,
    dPlayer2,
    dScore1,
    dScore2,
    dBet,
    dTimer
}
new DuelData[dInfo];

new PlayerChallengedBy[MAX_PLAYERS] = {-1, ...};
new PlayerDuelBet[MAX_PLAYERS];

new Text:DriftTD[MAX_PLAYERS] = {Text:INVALID_TEXT_DRAW, ...};

new const DriftCarModels[] = {562, 560, 559, 477, 565, 411};
new const WheelModels[] = {1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080};

forward EndDriftDuel();

// =============================================================================
// ОБЪЯВЛЕНИЕ ФУНКЦИЙ (STOCKS)
// =============================================================================
stock AddPlayerDriftPoints(playerid, points)
{
    if(points <= 0) return 0;
    PlayerData[playerid][pDriftPoints] += points;

    new newLevel = (PlayerData[playerid][pDriftPoints] / DRIFT_POINTS_PER_LEVEL) + 1;
    if(newLevel > PlayerData[playerid][pLevel])
    {
        PlayerData[playerid][pLevel] = newLevel;
        new reward = newLevel * 5000;
        GivePlayerMoney(playerid, reward);

        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
        new string[128];
        format(string, sizeof(string), "[Rising Sun] ~g~LEVEL UP! ~w~Уровень ~y~%d! ~w~Награда: ~g~$%d", newLevel, reward);
        SendClientMessage(playerid, 0xFF9900FF, string);
    }
    return 1;
}

stock AddDuelDriftPoints(playerid, points)
{
    if(!DuelData[dActive]) return 0;
    if(playerid == DuelData[dPlayer1]) DuelData[dScore1] += points;
    else if(playerid == DuelData[dPlayer2]) DuelData[dScore2] += points;
    return 1;
}

stock TeleportPlayerToTrack(playerid, Float:x, Float:y, Float:z, Float:angle, const trackName[])
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new veh = GetPlayerVehicleID(playerid);
        SetVehiclePos(veh, x, y, z);
        SetVehicleZAngle(veh, angle);
    }
    else
    {
        SetPlayerPos(playerid, x, y, z);
        SetPlayerFacingAngle(playerid, angle);
    }

    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
    new msg[128];
    format(msg, sizeof(msg), "[Rising Sun] Вы телепортированы на: {FF9900}%s", trackName);
    SendClientMessage(playerid, 0x00FF00FF, msg);
    return 1;
}

stock SavePlayerAccount(playerid)
{
    new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(playerid, name, sizeof(name));
    format(query, sizeof(query), "UPDATE users SET drift_points = %d, level = %d, money = %d WHERE username = '%s'",
        PlayerData[playerid][pDriftPoints], PlayerData[playerid][pLevel], GetPlayerMoney(playerid), name);
    db_query(gDB, query);
    return 1;
}

stock LoadPlayerAccount(playerid)
{
    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(query, sizeof(query), "SELECT * FROM users WHERE username = '%s'", name);
    new DBResult:result = db_query(gDB, query);

    if(db_num_rows(result) > 0)
    {
        PlayerData[playerid][pDriftPoints] = db_get_field_assoc_int(result, "drift_points");
        PlayerData[playerid][pLevel]       = db_get_field_assoc_int(result, "level");
        PlayerData[playerid][pMoney]       = db_get_field_assoc_int(result, "money");

        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
        PlayerData[playerid][pIsLoggedIn] = true;
        SendClientMessage(playerid, 0x00FF00FF, "[Rising Sun] Успешная авторизация!");
    }
    db_free_result(result);
    return 1;
}

stock SavePlayerVehicleTuning(playerid)
{
    new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(playerid, name, sizeof(name));
    format(query, sizeof(query), "INSERT OR REPLACE INTO player_tuning VALUES ('%s', %d, %d, %d, %d, %d, %d, %d)",
        name, PlayerVehicle[playerid][vModel], PlayerVehicle[playerid][vWheels], PlayerVehicle[playerid][vNitro],
        PlayerVehicle[playerid][vHydraulics], PlayerVehicle[playerid][vSpoiler], PlayerVehicle[playerid][vColor1], PlayerVehicle[playerid][vColor2]);
    db_query(gDB, query);
    SendClientMessage(playerid, 0x00FF00FF, "[Rising Sun] Машина сохранена!");
    return 1;
}

stock LoadPlayerVehicleTuning(playerid)
{
    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(query, sizeof(query), "SELECT * FROM player_tuning WHERE account_name = '%s'", name);
    new DBResult:result = db_query(gDB, query);

    if(db_num_rows(result) > 0)
    {
        PlayerVehicle[playerid][vModel]  = db_get_field_assoc_int(result, "model");
        PlayerVehicle[playerid][vWheels] = db_get_field_assoc_int(result, "wheels");
        PlayerVehicle[playerid][vNitro]  = db_get_field_assoc_int(result, "nitro");

        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        new vehid = CreateVehicle(PlayerVehicle[playerid][vModel], x + 2.0, y, z, a, -1, -1, -1);
        PutPlayerInVehicle(playerid, vehid, 0);

        if(PlayerVehicle[playerid][vWheels] > 0) AddVehicleComponent(vehid, PlayerVehicle[playerid][vWheels]);
        if(PlayerVehicle[playerid][vNitro] > 0)  AddVehicleComponent(vehid, PlayerVehicle[playerid][vNitro]);
        
        SendClientMessage(playerid, 0x00FF00FF, "[Rising Sun] Авто загружено!");
    }
    db_free_result(result);
    return 1;
}

stock StartDriftDuel(p1, p2, bet)
{
    GivePlayerMoney(p1, -bet);
    GivePlayerMoney(p2, -bet);

    DuelData[dActive] = true;
    DuelData[dPlayer1] = p1;
    DuelData[dPlayer2] = p2;
    DuelData[dScore1] = 0;
    DuelData[dScore2] = 0;
    DuelData[dBet] = bet;

    SetPlayerPos(p1, 388.1, 2500.5, 16.5);
    SetPlayerPos(p2, 395.1, 2500.5, 16.5);

    SendClientMessage(p1, 0xFF9900FF, "[Rising Sun] ДУЭЛЬ НАЧАЛАСЬ! Время: 60 секунд!");
    SendClientMessage(p2, 0xFF9900FF, "[Rising Sun] ДУЭЛЬ НАЧАЛАСЬ! Время: 60 секунд!");

    DuelData[dTimer] = SetTimer("EndDriftDuel", DUEL_TIME_LIMIT * 1000, false);
    return 1;
}

public EndDriftDuel()
{
    if(!DuelData[dActive]) return 1;

    new p1 = DuelData[dPlayer1];
    new p2 = DuelData[dPlayer2];
    new prizePool = DuelData[dBet] * 2;

    if(DuelData[dScore1] > DuelData[dScore2]) {
        GivePlayerMoney(p1, prizePool);
        GameTextForPlayer(p1, "~g~VICTORY!", 3000, 3);
        GameTextForPlayer(p2, "~r~DEFEAT!", 3000, 3);
    } else if(DuelData[dScore2] > DuelData[dScore1]) {
        GivePlayerMoney(p2, prizePool);
        GameTextForPlayer(p2, "~g~VICTORY!", 3000, 3);
        GameTextForPlayer(p1, "~r~DEFEAT!", 3000, 3);
    } else {
        GivePlayerMoney(p1, DuelData[dBet]);
        GivePlayerMoney(p2, DuelData[dBet]);
    }

    DuelData[dActive] = false;
    return 1;
}

// =============================================================================
// CALLBACKS
// =============================================================================
public OnGameModeInit()
{
    SetGameModeText("Rising Sun Drift v1.0");
    ShowNameTags(1);
    EnableStuntBonusForAll(0);

    gDB = db_open("drift_server.db");
    
    db_query(gDB, "CREATE TABLE IF NOT EXISTS users (username TEXT PRIMARY KEY, password TEXT, drift_points INTEGER, level INTEGER, money INTEGER)");
    db_query(gDB, "CREATE TABLE IF NOT EXISTS player_tuning (account_name TEXT PRIMARY KEY, model INTEGER, wheels INTEGER, nitro INTEGER, hydraulics INTEGER, spoiler INTEGER, color1 INTEGER, color2 INTEGER)");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        DriftTD[i] = TextDrawCreate(320.0, 360.0, " ");
        TextDrawAlignment(DriftTD[i], 2);
        TextDrawBackgroundColor(DriftTD[i], 255);
        TextDrawFont(DriftTD[i], 3);
        TextDrawLetterSize(DriftTD[i], 0.6, 2.2);
        TextDrawColor(DriftTD[i], 0xFF9900FF);
        TextDrawSetOutline(DriftTD[i], 1);
        TextDrawSetProportional(DriftTD[i], 1);
    }
    return 1;
}

public OnGameModeExit()
{
    db_close(gDB);
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerData[playerid][pIsLoggedIn] = false;
    PlayerData[playerid][pDriftPoints] = 0;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pMoney] = 5000;

    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    
    format(query, sizeof(query), "SELECT * FROM users WHERE username = '%s'", name);
    new DBResult:result = db_query(gDB, query);

    if(db_num_rows(result) > 0)
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "{FF9900}Rising Sun {FFFFFF}| Авторизация", 
            "{FFFFFF}Добро пожаловать обратно!\nВведите ваш пароль для входа:", 
            "Войти", "Выход");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, 
            "{FF9900}Rising Sun {FFFFFF}| Регистрация", 
            "{FFFFFF}Приветствуем на сервере!\nПридумайте пароль для нового аккаунта:", 
            "Принять", "Выход");
    }
    db_free_result(result);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][pIsLoggedIn])
    {
        SavePlayerAccount(playerid);
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{
    if(!PlayerData[playerid][pIsLoggedIn]) return 1;

    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new Float:vx, Float:vy, Float:vz;
        GetVehicleVelocity(vehicleid, vx, vy, vz);
        
        new Float:speed = floatsqroot(vx*vx + vy*vy + vz*vz) * 180.0;
        
        if(speed >= DRIFT_MIN_SPEED)
        {
            new Float:angle;
            GetVehicleZAngle(vehicleid, angle);
            
            new Float:moveAngle = atan2(vy, vx) - 90.0;
            if(moveAngle < 0.0) moveAngle += 360.0;
            
            new Float:driftAngle = floatabs(angle - moveAngle);
            if(driftAngle > 180.0) driftAngle = 360.0 - driftAngle;
            
            if(driftAngle >= 12.0 && driftAngle <= 85.0)
            {
                new points = floatround((speed / 2.0) * (driftAngle / 8.0));
                
                AddPlayerDriftPoints(playerid, points);
                if(DuelData[dActive]) AddDuelDriftPoints(playerid, points);
                
                new str[64];
                format(str, sizeof(str), "~y~DRIFT ~w~+%d PTS~n~~g~ANGLE: %.0f~k~DEG", PlayerData[playerid][pDriftPoints], driftAngle);
                TextDrawSetString(DriftTD[playerid], str);
                TextDrawShowForPlayer(playerid, DriftTD[playerid]);
            }
            else
            {
                TextDrawHideForPlayer(playerid, DriftTD[playerid]);
            }
        }
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!PlayerData[playerid][pIsLoggedIn]) 
        return SendClientMessage(playerid, 0xFF0000FF, "[Ошибка] Вы должны сначала авторизоваться!");

    if(strcmp(cmdtext, "/tp", true) == 0 || strcmp(cmdtext, "/teleport", true) == 0)
    {
        ShowPlayerDialog(playerid, DIALOG_TP_CATEGORIES, DIALOG_STYLE_LIST, 
            "{FF9900}Rising Sun {FFFFFF}| Категории телепорта", 
            "1. Особые карты (Akina, Ebisu & Touge)\n2. Обычные споты (TikTok Trend Spots)\n3. Города (Los Santos, San Fierro, Las Venturas)", 
            "Открыть", "Отмена");
        return 1;
    }

    if(strcmp(cmdtext, "/v", true) == 0 || strcmp(cmdtext, "/cars", true) == 0)
    {
        ShowPlayerDialog(playerid, DIALOG_DRIFT_CARS, DIALOG_STYLE_LIST, 
            "{FF9900}Rising Sun {FFFFFF}| Выбор авто", 
            "Elegy (JDM)\nSultan (AWD)\nJester (Sport)\nZR-350 (Rotary)\nFlash (Compact)\nInfernus (Hyper)", 
            "Спавн", "Отмена");
        return 1;
    }

    if(strcmp(cmdtext, "/tune", true) == 0)
    {
        if(!IsPlayerInAnyVehicle(playerid)) 
            return SendClientMessage(playerid, 0xFF0000FF, "[Ошибка] Вы должны находиться в машине!");

        ShowPlayerDialog(playerid, DIALOG_TUNING_MAIN, DIALOG_STYLE_LIST, 
            "{FF9900}Rising Sun {FFFFFF}| Гараж тюнинга", 
            "1. Установить Nitro (x10)\n2. Установить Гидравлику\n3. Сменить диски\n4. Починить и покрасить", 
            "Выбрать", "Закрыть");
        return 1;
    }

    if(strcmp(cmdtext, "/savecar", true) == 0)
    {
        if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Вы должны быть в машине!");
        new vehid = GetPlayerVehicleID(playerid);
        PlayerVehicle[playerid][vModel] = GetVehicleModel(vehid);
        SavePlayerVehicleTuning(playerid);
        return 1;
    }

    if(strcmp(cmdtext, "/loadcar", true) == 0)
    {
        LoadPlayerVehicleTuning(playerid);
        return 1;
    }

    if(strcmp(cmdtext, "/stats", true) == 0 || strcmp(cmdtext, "/menu", true) == 0)
    {
        new nextLevelPoints = PlayerData[playerid][pLevel] * DRIFT_POINTS_PER_LEVEL;
        new pointsNeeded = nextLevelPoints - PlayerData[playerid][pDriftPoints];

        new str[256];
        format(str, sizeof(str), "{FF9900}--- Rising Sun Profile ---\n\n{FFFFFF}Текущий уровень: {FF9900}%d\n{FFFFFF}Всего очков дрифта: {00FF00}%d pts\n{FFFFFF}Очков до следующего уровня: {Yellow}%d pts\n{FFFFFF}Баланс: {00FF00}$%d", PlayerData[playerid][pLevel], PlayerData[playerid][pDriftPoints], pointsNeeded, GetPlayerMoney(playerid));

        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Статистика Дрифтера", str, "Закрыть", "");
        return 1;
    }
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(!response && (dialogid == DIALOG_REGISTER || dialogid == DIALOG_LOGIN)) {
        Kick(playerid);
        return 1;
    }
    if(!response) return 1;

    new vehid = GetPlayerVehicleID(playerid);

    switch(dialogid)
    {
        case DIALOG_REGISTER:
        {
            if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Ошибка", "Короткий пароль! Введите снова:", "Принять", "Выход");
            
            new name[MAX_PLAYER_NAME], query[256];
            GetPlayerName(playerid, name, sizeof(name));
            format(query, sizeof(query), "INSERT INTO users VALUES ('%s', '%s', 0, 1, 10000)", name, inputtext);
            db_query(gDB, query);

            PlayerData[playerid][pIsLoggedIn] = true;
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid, 10000);
            SendClientMessage(playerid, 0x00FF00FF, "[Rising Sun] Вы успешно зарегистрировались!");
        }

        case DIALOG_LOGIN:
        {
            new name[MAX_PLAYER_NAME], query[128];
            GetPlayerName(playerid, name, sizeof(name));
            format(query, sizeof(query), "SELECT password FROM users WHERE username = '%s'", name);
            new DBResult:result = db_query(gDB, query);

            new dbPassword[32];
            db_get_field_assoc(result, "password", dbPassword, sizeof(dbPassword));
            db_free_result(result);

            if(strcmp(inputtext, dbPassword, false) == 0) LoadPlayerAccount(playerid);
            else ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Ошибка", "Неверный пароль!", "Войти", "Выход");
        }

        case DIALOG_DRIFT_CARS:
        {
            new Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);

            if(IsPlayerInAnyVehicle(playerid)) DestroyVehicle(vehid);

            new createdVeh = CreateVehicle(DriftCarModels[listitem], x, y, z, a, -1, -1, -1);
            PutPlayerInVehicle(playerid, createdVeh, 0);
            GameTextForPlayer(playerid, "~w~DRIFT CAR ~g~SPAWNED!", 2000, 3);
        }

        case DIALOG_TUNING_MAIN:
        {
            switch(listitem)
            {
                case 0: { AddVehicleComponent(vehid, 1010); PlayerVehicle[playerid][vNitro] = 1010; }
                case 1: { AddVehicleComponent(vehid, 1087); PlayerVehicle[playerid][vHydraulics] = 1087; }
                case 2: ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST, "Выбор дисков", "Shadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutlass\nAtomic", "Выбрать", "Назад");
                case 3: { RepairVehicle(vehid); ChangeVehicleColor(vehid, random(126), random(126)); }
            }
        }

        case DIALOG_WHEELS:
        {
            AddVehicleComponent(vehid, WheelModels[listitem]);
            PlayerVehicle[playerid][vWheels] = WheelModels[listitem];
            GameTextForPlayer(playerid, "~y~WHEELS ~w~INSTALLED!", 2000, 3);
        }

        case DIALOG_TP_CATEGORIES:
        {
            switch(listitem)
            {
                case 0: ShowPlayerDialog(playerid, DIALOG_TP_SPECIAL, DIALOG_STYLE_LIST, "Особые карты", "1. Akina Touge\n2. Ebisu Minami\n3. Haruna Drift\n4. Irohazaka Touge", "Телепорт", "Назад");
                case 1: ShowPlayerDialog(playerid, DIALOG_TP_SPOTS, DIALOG_STYLE_LIST, "TikTok Споты", "1. SF Docks\n2. LV Airport Ring\n3. Mulholland LS\n4. LV Parking Garage", "Телепорт", "Назад");
                case 2: ShowPlayerDialog(playerid, DIALOG_TP_CITIES, DIALOG_STYLE_LIST, "Города", "1. Los Santos\n2. San Fierro\n3. Las Venturas", "Телепорт", "Назад");
            }
        }

        case DIALOG_TP_SPECIAL:
        {
            switch(listitem)
            {
                case 0: TeleportPlayerToTrack(playerid, -2412.5, -2223.1, 800.0, 180.0, "Akina Touge");
                case 1: TeleportPlayerToTrack(playerid, -1400.5, -300.2, 14.2, 90.0, "Ebisu Minami");
                case 2: TeleportPlayerToTrack(playerid, 2500.0, -2200.0, 120.0, 0.0, "Haruna Drift");
                case 3: TeleportPlayerToTrack(playerid, -2800.0, -1500.0, 350.0, 270.0, "Irohazaka Touge");
            }
        }

        case DIALOG_TP_SPOTS:
        {
            switch(listitem)
            {
                case 0: TeleportPlayerToTrack(playerid, -1600.0, 700.0, 7.0, 0.0, "SF Docks");
                case 1: TeleportPlayerToTrack(playerid, 388.1, 2500.5, 16.5, 270.0, "LV Airport Ring");
                case 2: TeleportPlayerToTrack(playerid, 680.0, -1250.0, 13.5, 90.0, "Mulholland Intersection");
                case 3: TeleportPlayerToTrack(playerid, 2150.0, 1400.0, 10.8, 180.0, "LV Parking Garage");
            }
        }

        case DIALOG_TP_CITIES:
        {
            switch(listitem)
            {
                case 0: TeleportPlayerToTrack(playerid, 380.0, -1880.0, 7.8, 180.0, "Los Santos");
                case 1: TeleportPlayerToTrack(playerid, -1980.0, 130.0, 27.6, 90.0, "San Fierro");
                case 2: TeleportPlayerToTrack(playerid, 2000.0, 1500.0, 12.8, 270.0, "Las Venturas");
            }
        }

        // СТАЛО (ПРАВИЛЬНО):
        case DIALOG_TUNING_MAIN:
{
    switch(listitem)
    {
        case 0: 
        { 
            AddVehicleComponent(vehid, 1010); 
            PlayerVehicle[playerid][vNitro] = 1010; 
        }
        case 1: 
        { 
            AddVehicleComponent(vehid, 1087); 
            PlayerVehicle[playerid][vHydraulics] = 1087; 
        }
        case 2: ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST, "Выбор дисков", "Shadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutlass\nAtomic", "Выбрать", "Назад");
        case 3: 
        { 
            RepairVehicle(vehid); 
            ChangeVehicleColor(vehid, random(126), random(126)); 
        }
    }
}

