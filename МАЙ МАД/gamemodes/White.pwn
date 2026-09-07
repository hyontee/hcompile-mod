#include <a_samp>
#include <a_mysql>

#define MYSQL_HOST       "127.0.0.1"
#define MYSQL_USER       "root"
#define MYSQL_PASSWORD   ""
#define MYSQL_DATABASE   "whitemobile"

new MySQL:g_SQL;

enum E_PLAYER_DATA
{
    pID,
    pMoney,
    pLevel,
    pLogged
};

new PlayerInfo[MAX_PLAYERS][E_PLAYER_DATA];

public OnGameModeInit()
{
    SetGameModeText("White Mobile");

    g_SQL = mysql_connect(
        MYSQL_HOST,
        MYSQL_USER,
        MYSQL_PASSWORD,
        MYSQL_DATABASE
    );

    if (g_SQL == MYSQL_INVALID_HANDLE)
    {
        print("MYSQL: Ошибка подключения!");
        return 1;
    }

    print("MYSQL: Подключение успешно!");

    mysql_tquery(g_SQL,
        "CREATE TABLE IF NOT EXISTS `accounts` (\
        `id` INT NOT NULL AUTO_INCREMENT,\
        `name` VARCHAR(24) NOT NULL,\
        `password` VARCHAR(255) NOT NULL,\
        `money` INT NOT NULL DEFAULT 5000,\
        `level` INT NOT NULL DEFAULT 1,\
        PRIMARY KEY (`id`),\
        UNIQUE KEY `name` (`name`)\
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
    );

    return 1;
}

public OnGameModeExit()
{
    mysql_close(g_SQL);
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerInfo[playerid][pID] = 0;
    PlayerInfo[playerid][pMoney] = 5000;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pLogged] = 0;

    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    new query[256];

    mysql_format(
        g_SQL,
        query,
        sizeof(query),
        "SELECT * FROM `accounts` WHERE `name` = '%e' LIMIT 1",
        name
    );

    mysql_tquery(
        g_SQL,
        query,
        "OnPlayerCheckAccount",
        "i",
        playerid
    );

    return 1;
}

forward OnPlayerCheckAccount(playerid);
public OnPlayerCheckAccount(playerid)
{
    if (!IsPlayerConnected(playerid))
        return 1;

    if (cache_num_rows() > 0)
    {
        SendClientMessage(
            playerid,
            0xFFFF00AA,
            "Ваш аккаунт найден. Используйте /login [пароль]"
        );
    }
    else
    {
        SendClientMessage(
            playerid,
            0x00FF00AA,
            "Аккаунт не найден. Используйте /register [пароль]"
        );
    }

    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new password[128];

    if (!strcmp(cmdtext, "/register", true))
    {
        SendClientMessage(
            playerid,
            0xFFFF00AA,
            "Использование: /register [пароль]"
        );

        return 1;
    }

    if (!strcmp(cmdtext, "/login", true))
    {
        SendClientMessage(
            playerid,
            0xFFFF00AA,
            "Использование: /login [пароль]"
        );

        return 1;
    }

    return 0;
}