#include <a_samp>
#include <a_mysql> // Подключение MySQL

// ==================== НАСТРОЙКИ БД ====================
#define MYSQL_HOST     "127.0.0.1"
#define MYSQL_USER     "user41342"
#define MYSQL_PASS     "5otVziBnAEbY"
#define MYSQL_DATABASE "user41342"

// Идентификаторы диалогов
enum
{
    DIALOG_NONE,
    DIALOG_REGISTER,
    DIALOG_LOGIN
}

// Данные игрока
enum pInfo
{
    pID,
    pPassword[64],
    pScore,
    pMoney,
    bool:pLogged
}
new PlayerInfo[MAX_PLAYERS][pInfo];

new MySQL:g_SQL;

main()
{
    print("\n----------------------------------");
    print("  Сервер с нуля успешно запущен!");
    print("----------------------------------\n");
}

public OnGameModeInit()
{
    // Подключение к БД MySQL
    new MySQLOpt:option = mysql_init_options();
    mysql_set_option(option, AUTO_RECONNECT, true);
    
    g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE, option);
    
    if(g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
    {
        print("[MySQL] Ошибка! Не удалось подключиться к Базе Данных!");
    }
    else
    {
        print("[MySQL] База Данных успешно подключена!");
    }

    SetGameModeText("Development v0.1");
    
    // Дефолтный спавн (Вокзал ЛС)
    AddPlayerClass(230, 1752.4971, -1902.9835, 13.5538, 260.4904, 0, 0, 0, 0, 0, 0);
    return 1;
}

public OnGameModeExit()
{
    if(g_SQL) mysql_close(g_SQL);
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Сброс данных игрока при входе
    PlayerInfo[playerid][pLogged] = false;
    PlayerInfo[playerid][pMoney] = 0;
    PlayerInfo[playerid][pScore] = 0;

    // Проверка наличия аккаунта в базе
    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    
    mysql_format(g_SQL, query, sizeof(query), "SELECT `id`, `password` FROM `accounts` WHERE `username` = '%e' LIMIT 1", name);
    mysql_tquery(g_SQL, query, "OnAccountCheck", "i", playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerInfo[playerid][pLogged])
    {
        SaveAccount(playerid); // Сохраняем аккаунт при выходе
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!PlayerInfo[playerid][pLogged])
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы должны авторизоваться перед спавном!");
        Kick(playerid);
        return 1;
    }

    // Установка позиции спавна
    SetPlayerSkin(playerid, 230);
    SetPlayerPos(playerid, 1752.4971, -1902.9835, 13.5538);
    SetPlayerFacingAngle(playerid, 260.4904);
    SetCameraBehindPlayer(playerid);
    
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
    SetPlayerScore(playerid, PlayerInfo[playerid][pScore]);
    return 1;
}

// ==================== CALLBACKS ДЛЯ МУСКУЛА ====================

forward OnAccountCheck(playerid);
public OnAccountCheck(playerid)
{
    new rows = cache_num_rows();
    new name[MAX_PLAYER_NAME], string[256];
    GetPlayerName(playerid, name, sizeof(name));

    if(rows > 0)
    {
        // Аккаунт найден -> Вызываем окно входа
        cache_get_value_name(0, "password", PlayerInfo[playerid][pPassword], 64);
        
        format(string, sizeof(string), "{FFFFFF}Добро пожаловать на сервер, {00FF00}%s{FFFFFF}!\nЭтот аккаунт зарегистрирован.\n\nВведите ваш пароль для входа:", name);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Авторизация", string, "Вход", "Отмена");
    }
    else
    {
        // Аккаунта нет -> Вызываем окно регистрации
        format(string, sizeof(string), "{FFFFFF}Добро пожаловать на сервер, {00FF00}%s{FFFFFF}!\nЭтот аккаунт не зарегистрирован.\n\nПридумайте и введите пароль:", name);
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Регистрация", string, "Далее", "Отмена");
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_REGISTER:
        {
            if(!response) return Kick(playerid);
            if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
            {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Регистрация", "Пароль должен быть от 4 до 32 символов!\nВведите пароль:", "Далее", "Отмена");
                return 1;
            }

            new name[MAX_PLAYER_NAME], query[256];
            GetPlayerName(playerid, name, sizeof(name));
            
            format(PlayerInfo[playerid][pPassword], 64, "%s", inputtext);
            PlayerInfo[playerid][pMoney] = 500; // Начальные деньги
            PlayerInfo[playerid][pScore] = 1;   // Начальный уровень

            mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `accounts` (`username`, `password`, `score`, `money`) VALUES ('%e', '%e', %d, %d)", 
                name, PlayerInfo[playerid][pPassword], PlayerInfo[playerid][pScore], PlayerInfo[playerid][pMoney]);
            
            mysql_tquery(g_SQL, query, "OnAccountRegister", "i", playerid);
        }
        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);
            
            if(!strcmp(inputtext, PlayerInfo[playerid][pPassword], false))
            {
                // Пароль верный -> Загружаем данные
                new name[MAX_PLAYER_NAME], query[128];
                GetPlayerName(playerid, name, sizeof(name));
                
                mysql_format(g_SQL, query, sizeof(query), "SELECT `score`, `money` FROM `accounts` WHERE `username` = '%e' LIMIT 1", name);
                mysql_tquery(g_SQL, query, "OnAccountLoad", "i", playerid);
            }
            else
            {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Авторизация", "{FF0000}Неверный пароль!\n{FFFFFF}Введите ваш пароль для входа:", "Вход", "Отмена");
            }
        }
    }
    return 1;
}

forward OnAccountRegister(playerid);
public OnAccountRegister(playerid)
{
    PlayerInfo[playerid][pID] = cache_insert_id();
    PlayerInfo[playerid][pLogged] = true;
    SendClientMessage(playerid, 0x00FF00FF, "Вы успешно зарегистрировались!");
    SpawnPlayer(playerid);
    return 1;
}

forward OnAccountLoad(playerid);
public OnAccountLoad(playerid)
{
    cache_get_value_name_int(0, "score", PlayerInfo[playerid][pScore]);
    cache_get_value_name_int(0, "money", PlayerInfo[playerid][pMoney]);
    
    PlayerInfo[playerid][pLogged] = true;
    SendClientMessage(playerid, 0x00FF00FF, "Вы успешно авторизовались!");
    SpawnPlayer(playerid);
    return 1;
}

stock SaveAccount(playerid)
{
    if(!PlayerInfo[playerid][pLogged]) return 1;

    new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(playerid, name, sizeof(name));
    
    PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
    PlayerInfo[playerid][pScore] = GetPlayerScore(playerid);

    mysql_format(g_SQL, query, sizeof(query), "UPDATE `accounts` SET `score` = %d, `money` = %d WHERE `username` = '%e'",
        PlayerInfo[playerid][pScore], PlayerInfo[playerid][pMoney], name);
        
    mysql_tquery(g_SQL, query);
    return 1;
}